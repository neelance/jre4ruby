require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Sun designates this
# particular file as subject to the "Classpath" exception as provided
# by Sun in the LICENSE file that accompanied this code.
# 
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
# 
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
# 
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
# CA 95054 USA or visit www.sun.com if you need additional information or
# have any questions.
module Sun::Security::X509
  module ExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Arrays
      include ::Sun::Security::Util
    }
  end
  
  # Represent a X509 Extension Attribute.
  # 
  # <p>Extensions are additional attributes which can be inserted in a X509
  # v3 certificate. For example a "Driving License Certificate" could have
  # the driving license number as a extension.
  # 
  # <p>Extensions are represented as a sequence of the extension identifier
  # (Object Identifier), a boolean flag stating whether the extension is to
  # be treated as being critical and the extension value itself (this is again
  # a DER encoding of the extension value).
  # <pre>
  # ASN.1 definition of Extension:
  # Extension ::= SEQUENCE {
  #      ExtensionId     OBJECT IDENTIFIER,
  #      critical        BOOLEAN DEFAULT FALSE,
  #      extensionValue  OCTET STRING
  # }
  # </pre>
  # All subclasses need to implement a constructor of the form
  # <pre>
  #     <subclass> (Boolean, Object)
  # </pre>
  # where the Object is typically an array of DER encoded bytes.
  # <p>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class Extension 
    include_class_members ExtensionImports
    
    attr_accessor :extension_id
    alias_method :attr_extension_id, :extension_id
    undef_method :extension_id
    alias_method :attr_extension_id=, :extension_id=
    undef_method :extension_id=
    
    attr_accessor :critical
    alias_method :attr_critical, :critical
    undef_method :critical
    alias_method :attr_critical=, :critical=
    undef_method :critical=
    
    attr_accessor :extension_value
    alias_method :attr_extension_value, :extension_value
    undef_method :extension_value
    alias_method :attr_extension_value=, :extension_value=
    undef_method :extension_value=
    
    typesig { [] }
    # Default constructor.  Used only by sub-classes.
    def initialize
      @extension_id = nil
      @critical = false
      @extension_value = nil
    end
    
    typesig { [DerValue] }
    # Constructs an extension from a DER encoded array of bytes.
    def initialize(der_val)
      @extension_id = nil
      @critical = false
      @extension_value = nil
      in_ = der_val.to_der_input_stream
      # Object identifier
      @extension_id = in_.get_oid
      # If the criticality flag was false, it will not have been encoded.
      val = in_.get_der_value
      if ((val.attr_tag).equal?(DerValue.attr_tag_boolean))
        @critical = val.get_boolean
        # Extension value (DER encoded)
        val = in_.get_der_value
        @extension_value = val.get_octet_string
      else
        @critical = false
        @extension_value = val.get_octet_string
      end
    end
    
    typesig { [ObjectIdentifier, ::Java::Boolean, Array.typed(::Java::Byte)] }
    # Constructs an Extension from individual components of ObjectIdentifier,
    # criticality and the DER encoded OctetString.
    # 
    # @param extensionId the ObjectIdentifier of the extension
    # @param critical the boolean indicating if the extension is critical
    # @param extensionValue the DER encoded octet string of the value.
    def initialize(extension_id, critical, extension_value)
      @extension_id = nil
      @critical = false
      @extension_value = nil
      @extension_id = extension_id
      @critical = critical
      # passed in a DER encoded octet string, strip off the tag
      # and length
      in_der_val = DerValue.new(extension_value)
      @extension_value = in_der_val.get_octet_string
    end
    
    typesig { [Extension] }
    # Constructs an Extension from another extension. To be used for
    # creating decoded subclasses.
    # 
    # @param ext the extension to create from.
    def initialize(ext)
      @extension_id = nil
      @critical = false
      @extension_value = nil
      @extension_id = ext.attr_extension_id
      @critical = ext.attr_critical
      @extension_value = ext.attr_extension_value
    end
    
    typesig { [DerOutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors
    def encode(out)
      if ((@extension_id).nil?)
        raise IOException.new("Null OID to encode for the extension!")
      end
      if ((@extension_value).nil?)
        raise IOException.new("No value to encode for the extension!")
      end
      dos = DerOutputStream.new
      dos.put_oid(@extension_id)
      if (@critical)
        dos.put_boolean(@critical)
      end
      dos.put_octet_string(@extension_value)
      out.write(DerValue.attr_tag_sequence, dos)
    end
    
    typesig { [] }
    # Returns true if extension is critical.
    def is_critical
      return @critical
    end
    
    typesig { [] }
    # Returns the ObjectIdentifier of the extension.
    def get_extension_id
      return @extension_id
    end
    
    typesig { [] }
    # Returns the extension value as an byte array for further processing.
    # Note, this is the raw DER value of the extension, not the DER
    # encoded octet string which is in the certificate.
    # This method does not return a clone; it is the responsibility of the
    # caller to clone the array if necessary.
    def get_extension_value
      return @extension_value
    end
    
    typesig { [] }
    # Returns the Extension in user readable form.
    def to_s
      s = "ObjectId: " + RJava.cast_to_string(@extension_id.to_s)
      if (@critical)
        s += " Criticality=true\n"
      else
        s += " Criticality=false\n"
      end
      return (s)
    end
    
    class_module.module_eval {
      # Value to mix up the hash
      const_set_lazy(:HashMagic) { 31 }
      const_attr_reader  :HashMagic
    }
    
    typesig { [] }
    # Returns a hashcode value for this Extension.
    # 
    # @return the hashcode value.
    def hash_code
      h = 0
      if (!(@extension_value).nil?)
        val = @extension_value
        len = val.attr_length
        while (len > 0)
          h += len * val[(len -= 1)]
        end
      end
      h = h * HashMagic + @extension_id.hash_code
      h = h * HashMagic + (@critical ? 1231 : 1237)
      return h
    end
    
    typesig { [Object] }
    # Compares this Extension for equality with the specified
    # object. If the <code>other</code> object is an
    # <code>instanceof</code> <code>Extension</code>, then
    # its encoded form is retrieved and compared with the
    # encoded form of this Extension.
    # 
    # @param other the object to test for equality with this Extension.
    # @return true iff the other object is of type Extension, and the
    # criticality flag, object identifier and encoded extension value of
    # the two Extensions match, false otherwise.
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(Extension)))
        return false
      end
      other_ext = other
      if (!(@critical).equal?(other_ext.attr_critical))
        return false
      end
      if (!(@extension_id == other_ext.attr_extension_id))
        return false
      end
      return Arrays.==(@extension_value, other_ext.attr_extension_value)
    end
    
    private
    alias_method :initialize__extension, :initialize
  end
  
end
