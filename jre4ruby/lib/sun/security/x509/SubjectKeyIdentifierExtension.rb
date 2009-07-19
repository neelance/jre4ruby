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
  module SubjectKeyIdentifierExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # Represent the Subject Key Identifier Extension.
  # 
  # This extension, if present, provides a means of identifying the particular
  # public key used in an application.  This extension by default is marked
  # non-critical.
  # 
  # <p>Extensions are addiitonal attributes which can be inserted in a X509
  # v3 certificate. For example a "Driving License Certificate" could have
  # the driving license number as a extension.
  # 
  # <p>Extensions are represented as a sequence of the extension identifier
  # (Object Identifier), a boolean flag stating whether the extension is to
  # be treated as being critical and the extension value itself (this is again
  # a DER encoding of the extension value).
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class SubjectKeyIdentifierExtension < SubjectKeyIdentifierExtensionImports.const_get :Extension
    include_class_members SubjectKeyIdentifierExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.SubjectKeyIdentifier" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "SubjectKeyIdentifier" }
      const_attr_reader  :NAME
      
      const_set_lazy(:KEY_ID) { "key_id" }
      const_attr_reader  :KEY_ID
    }
    
    # Private data member
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      if ((@id).nil?)
        self.attr_extension_value = nil
        return
      end
      os = DerOutputStream.new
      @id.encode(os)
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Create a SubjectKeyIdentifierExtension with the passed octet string.
    # The criticality is set to False.
    # @param octetString the octet string identifying the key identifier.
    def initialize(octet_string)
      @id = nil
      super()
      @id = nil
      @id = KeyIdentifier.new(octet_string)
      self.attr_extension_id = PKIXExtensions::SubjectKey_Id
      self.attr_critical = false
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @id = nil
      super()
      @id = nil
      self.attr_extension_id = PKIXExtensions::SubjectKey_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      @id = KeyIdentifier.new(val)
    end
    
    typesig { [] }
    # Returns a printable representation.
    def to_s
      return (super).to_s + "SubjectKeyIdentifier [\n" + (String.value_of(@id)).to_s + "]\n"
    end
    
    typesig { [OutputStream] }
    # Write the extension to the OutputStream.
    # 
    # @param out the OutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::SubjectKey_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(KEY_ID))
        if (!(obj.is_a?(KeyIdentifier)))
          raise IOException.new("Attribute value should be of" + " type KeyIdentifier.")
        end
        @id = obj
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:SubjectKeyIdentifierExtension.")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(KEY_ID))
        return (@id)
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:SubjectKeyIdentifierExtension.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(KEY_ID))
        @id = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:SubjectKeyIdentifierExtension.")
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(KEY_ID)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__subject_key_identifier_extension, :initialize
  end
  
end
