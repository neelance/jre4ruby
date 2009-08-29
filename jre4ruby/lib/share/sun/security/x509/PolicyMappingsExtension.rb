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
  module PolicyMappingsExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Util
      include_const ::Java::Security::Cert, :CertificateException
      include ::Sun::Security::Util
    }
  end
  
  # Represent the Policy Mappings Extension.
  # 
  # This extension, if present, identifies the certificate policies considered
  # identical between the issuing and the subject CA.
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
  class PolicyMappingsExtension < PolicyMappingsExtensionImports.const_get :Extension
    include_class_members PolicyMappingsExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.PolicyMappings" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "PolicyMappings" }
      const_attr_reader  :NAME
      
      const_set_lazy(:MAP) { "map" }
      const_attr_reader  :MAP
    }
    
    # Private data members
    attr_accessor :maps
    alias_method :attr_maps, :maps
    undef_method :maps
    alias_method :attr_maps=, :maps=
    undef_method :maps=
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      if ((@maps).nil? || @maps.is_empty)
        self.attr_extension_value = nil
        return
      end
      os = DerOutputStream.new
      tmp = DerOutputStream.new
      @maps.each do |map|
        map.encode(tmp)
      end
      os.write(DerValue.attr_tag_sequence, tmp)
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [JavaList] }
    # Create a PolicyMappings with the List of CertificatePolicyMap.
    # 
    # @param maps the List of CertificatePolicyMap.
    def initialize(map)
      @maps = nil
      super()
      @maps = map
      self.attr_extension_id = PKIXExtensions::PolicyMappings_Id
      self.attr_critical = false
      encode_this
    end
    
    typesig { [] }
    # Create a default PolicyMappingsExtension.
    def initialize
      @maps = nil
      super()
      self.attr_extension_id = PKIXExtensions::KeyUsage_Id
      self.attr_critical = false
      @maps = ArrayList.new
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value.
    # 
    # @params critical true if the extension is to be treated as critical.
    # @params value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @maps = nil
      super()
      self.attr_extension_id = PKIXExtensions::PolicyMappings_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for " + "PolicyMappingsExtension.")
      end
      @maps = ArrayList.new
      while (!(val.attr_data.available).equal?(0))
        seq = val.attr_data.get_der_value
        map = CertificatePolicyMap.new(seq)
        @maps.add(map)
      end
    end
    
    typesig { [] }
    # Returns a printable representation of the policy map.
    def to_s
      if ((@maps).nil?)
        return ""
      end
      s = RJava.cast_to_string(super) + "PolicyMappings [\n" + RJava.cast_to_string(@maps.to_s) + "]\n"
      return (s)
    end
    
    typesig { [OutputStream] }
    # Write the extension to the OutputStream.
    # 
    # @param out the OutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::PolicyMappings_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(MAP))
        if (!(obj.is_a?(JavaList)))
          raise IOException.new("Attribute value should be of" + " type List.")
        end
        @maps = obj
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:PolicyMappingsExtension.")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(MAP))
        return (@maps)
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:PolicyMappingsExtension.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(MAP))
        @maps = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:PolicyMappingsExtension.")
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(MAP)
      return elements.elements
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__policy_mappings_extension, :initialize
  end
  
end
