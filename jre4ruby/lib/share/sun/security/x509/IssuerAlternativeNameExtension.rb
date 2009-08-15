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
  module IssuerAlternativeNameExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # This represents the Issuer Alternative Name Extension.
  # 
  # This extension, if present, allows the issuer to specify multiple
  # alternative names.
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
  class IssuerAlternativeNameExtension < IssuerAlternativeNameExtensionImports.const_get :Extension
    include_class_members IssuerAlternativeNameExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.IssuerAlternativeName" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "IssuerAlternativeName" }
      const_attr_reader  :NAME
      
      const_set_lazy(:ISSUER_NAME) { "issuer_name" }
      const_attr_reader  :ISSUER_NAME
    }
    
    # private data members
    attr_accessor :names
    alias_method :attr_names, :names
    undef_method :names
    alias_method :attr_names=, :names=
    undef_method :names=
    
    typesig { [] }
    # Encode this extension
    def encode_this
      if ((@names).nil? || @names.is_empty)
        self.attr_extension_value = nil
        return
      end
      os = DerOutputStream.new
      @names.encode(os)
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [GeneralNames] }
    # Create a IssuerAlternativeNameExtension with the passed GeneralNames.
    # 
    # @param names the GeneralNames for the issuer.
    # @exception IOException on error.
    def initialize(names)
      @names = nil
      super()
      @names = nil
      @names = names
      self.attr_extension_id = PKIXExtensions::IssuerAlternativeName_Id
      self.attr_critical = false
      encode_this
    end
    
    typesig { [] }
    # Create a default IssuerAlternativeNameExtension.
    def initialize
      @names = nil
      super()
      @names = nil
      self.attr_extension_id = PKIXExtensions::IssuerAlternativeName_Id
      self.attr_critical = false
      @names = GeneralNames.new
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @names = nil
      super()
      @names = nil
      self.attr_extension_id = PKIXExtensions::IssuerAlternativeName_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if ((val.attr_data).nil?)
        @names = GeneralNames.new
        return
      end
      @names = GeneralNames.new(val)
    end
    
    typesig { [] }
    # Returns a printable representation of the IssuerAlternativeName.
    def to_s
      result = RJava.cast_to_string(super) + "IssuerAlternativeName [\n"
      if ((@names).nil?)
        result += "  null\n"
      else
        @names.names.each do |name|
          result += "  " + RJava.cast_to_string(name) + "\n"
        end
      end
      result += "]\n"
      return result
    end
    
    typesig { [OutputStream] }
    # Write the extension to the OutputStream.
    # 
    # @param out the OutputStream to write the extension to.
    # @exception IOException on encoding error.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::IssuerAlternativeName_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(ISSUER_NAME))
        if (!(obj.is_a?(GeneralNames)))
          raise IOException.new("Attribute value should be of" + " type GeneralNames.")
        end
        @names = obj
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:IssuerAlternativeName.")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(ISSUER_NAME))
        return (@names)
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:IssuerAlternativeName.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(ISSUER_NAME))
        @names = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:IssuerAlternativeName.")
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(ISSUER_NAME)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__issuer_alternative_name_extension, :initialize
  end
  
end
