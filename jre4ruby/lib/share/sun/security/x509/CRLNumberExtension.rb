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
  module CRLNumberExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # Represent the CRL Number Extension.
  # 
  # <p>This extension, if present, conveys a monotonically increasing
  # sequence number for each CRL issued by a given CA through a specific
  # CA X.500 Directory entry or CRL distribution point. This extension
  # allows users to easily determine when a particular CRL supersedes
  # another CRL.
  # 
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class CRLNumberExtension < CRLNumberExtensionImports.const_get :Extension
    include_class_members CRLNumberExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Attribute name.
      const_set_lazy(:NAME) { "CRLNumber" }
      const_attr_reader  :NAME
      
      const_set_lazy(:NUMBER) { "value" }
      const_attr_reader  :NUMBER
      
      const_set_lazy(:LABEL) { "CRL Number" }
      const_attr_reader  :LABEL
    }
    
    attr_accessor :crl_number
    alias_method :attr_crl_number, :crl_number
    undef_method :crl_number
    alias_method :attr_crl_number=, :crl_number=
    undef_method :crl_number=
    
    attr_accessor :extension_name
    alias_method :attr_extension_name, :extension_name
    undef_method :extension_name
    alias_method :attr_extension_name=, :extension_name=
    undef_method :extension_name=
    
    attr_accessor :extension_label
    alias_method :attr_extension_label, :extension_label
    undef_method :extension_label
    alias_method :attr_extension_label=, :extension_label=
    undef_method :extension_label=
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      if ((@crl_number).nil?)
        self.attr_extension_value = nil
        return
      end
      os = DerOutputStream.new
      os.put_integer(@crl_number)
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [::Java::Int] }
    # Create a CRLNumberExtension with the integer value .
    # The criticality is set to false.
    # 
    # @param crlNum the value to be set for the extension.
    def initialize(crl_num)
      initialize__crlnumber_extension(PKIXExtensions::CRLNumber_Id, false, BigInteger.value_of(crl_num), NAME, LABEL)
    end
    
    typesig { [BigInteger] }
    # Create a CRLNumberExtension with the BigInteger value .
    # The criticality is set to false.
    # 
    # @param crlNum the value to be set for the extension.
    def initialize(crl_num)
      initialize__crlnumber_extension(PKIXExtensions::CRLNumber_Id, false, crl_num, NAME, LABEL)
    end
    
    typesig { [ObjectIdentifier, ::Java::Boolean, BigInteger, String, String] }
    # Creates the extension (also called by the subclass).
    def initialize(extension_id, is_critical, crl_num, extension_name, extension_label)
      @crl_number = nil
      @extension_name = nil
      @extension_label = nil
      super()
      @crl_number = nil
      self.attr_extension_id = extension_id
      self.attr_critical = is_critical
      @crl_number = crl_num
      @extension_name = extension_name
      @extension_label = extension_label
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      initialize__crlnumber_extension(PKIXExtensions::CRLNumber_Id, critical, value, NAME, LABEL)
    end
    
    typesig { [ObjectIdentifier, Boolean, Object, String, String] }
    # Creates the extension (also called by the subclass).
    def initialize(extension_id, critical, value, extension_name, extension_label)
      @crl_number = nil
      @extension_name = nil
      @extension_label = nil
      super()
      @crl_number = nil
      self.attr_extension_id = extension_id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      @crl_number = val.get_big_integer
      @extension_name = extension_name
      @extension_label = extension_label
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(NUMBER))
        if (!(obj.is_a?(BigInteger)))
          raise IOException.new("Attribute must be of type BigInteger.")
        end
        @crl_number = obj
      else
        raise IOException.new("Attribute name not recognized by" + " CertAttrSet:" + @extension_name + ".")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(NUMBER))
        if ((@crl_number).nil?)
          return nil
        else
          return @crl_number
        end
      else
        raise IOException.new("Attribute name not recognized by" + " CertAttrSet:" + @extension_name + ".")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(NUMBER))
        @crl_number = nil
      else
        raise IOException.new("Attribute name not recognized by" + " CertAttrSet:" + @extension_name + ".")
      end
      encode_this
    end
    
    typesig { [] }
    # Returns a printable representation of the CRLNumberExtension.
    def to_s
      s = RJava.cast_to_string(super) + @extension_label + ": " + RJava.cast_to_string((((@crl_number).nil?) ? "" : Debug.to_hex_string(@crl_number))) + "\n"
      return (s)
    end
    
    typesig { [OutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      encode(out, PKIXExtensions::CRLNumber_Id, true)
    end
    
    typesig { [OutputStream, ObjectIdentifier, ::Java::Boolean] }
    # Write the extension to the DerOutputStream.
    # (Also called by the subclass)
    def encode(out, extension_id, is_critical)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = extension_id
        self.attr_critical = is_critical
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(NUMBER)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (@extension_name)
    end
    
    private
    alias_method :initialize__crlnumber_extension, :initialize
  end
  
end
