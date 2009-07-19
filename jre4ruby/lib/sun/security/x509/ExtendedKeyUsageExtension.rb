require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ExtendedKeyUsageExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :Vector
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :ObjectIdentifier
    }
  end
  
  # This class defines the Extended Key Usage Extension, which
  # indicates one or more purposes for which the certified public key
  # may be used, in addition to or in place of the basic purposes
  # indicated in the key usage extension field.  This field is defined
  # as follows:<p>
  # 
  # id-ce-extKeyUsage OBJECT IDENTIFIER ::= {id-ce 37}<p>
  # 
  # ExtKeyUsageSyntax ::= SEQUENCE SIZE (1..MAX) OF KeyPurposeId<p>
  # 
  # KeyPurposeId ::= OBJECT IDENTIFIER<p>
  # 
  # Key purposes may be defined by any organization with a need. Object
  # identifiers used to identify key purposes shall be assigned in
  # accordance with IANA or ITU-T Rec. X.660 | ISO/IEC/ITU 9834-1.<p>
  # 
  # This extension may, at the option of the certificate issuer, be
  # either critical or non-critical.<p>
  # 
  # If the extension is flagged critical, then the certificate MUST be
  # used only for one of the purposes indicated.<p>
  # 
  # If the extension is flagged non-critical, then it indicates the
  # intended purpose or purposes of the key, and may be used in finding
  # the correct key/certificate of an entity that has multiple
  # keys/certificates. It is an advisory field and does not imply that
  # usage of the key is restricted by the certification authority to
  # the purpose indicated. Certificate using applications may
  # nevertheless require that a particular purpose be indicated in
  # order for the certificate to be acceptable to that application.<p>
  # 
  # If a certificate contains both a critical key usage field and a
  # critical extended key usage field, then both fields MUST be
  # processed independently and the certificate MUST only be used for a
  # purpose consistent with both fields.  If there is no purpose
  # consistent with both fields, then the certificate MUST NOT be used
  # for any purpose.<p>
  # 
  # @since       1.4
  class ExtendedKeyUsageExtension < ExtendedKeyUsageExtensionImports.const_get :Extension
    include_class_members ExtendedKeyUsageExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.ExtendedKeyUsage" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "ExtendedKeyUsage" }
      const_attr_reader  :NAME
      
      const_set_lazy(:USAGES) { "usages" }
      const_attr_reader  :USAGES
      
      # OID defined in RFC 3280 Sections 4.2.1.13
      # more from http://www.alvestrand.no/objectid/1.3.6.1.5.5.7.3.html
      const_set_lazy(:Map) { HashMap.new }
      const_attr_reader  :Map
      
      const_set_lazy(:AnyExtendedKeyUsageOidData) { Array.typed(::Java::Int).new([2, 5, 29, 37, 0]) }
      const_attr_reader  :AnyExtendedKeyUsageOidData
      
      const_set_lazy(:ServerAuthOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 1]) }
      const_attr_reader  :ServerAuthOidData
      
      const_set_lazy(:ClientAuthOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 2]) }
      const_attr_reader  :ClientAuthOidData
      
      const_set_lazy(:CodeSigningOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 3]) }
      const_attr_reader  :CodeSigningOidData
      
      const_set_lazy(:EmailProtectionOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 4]) }
      const_attr_reader  :EmailProtectionOidData
      
      const_set_lazy(:IpsecEndSystemOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 5]) }
      const_attr_reader  :IpsecEndSystemOidData
      
      const_set_lazy(:IpsecTunnelOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 6]) }
      const_attr_reader  :IpsecTunnelOidData
      
      const_set_lazy(:IpsecUserOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 7]) }
      const_attr_reader  :IpsecUserOidData
      
      const_set_lazy(:TimeStampingOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 8]) }
      const_attr_reader  :TimeStampingOidData
      
      const_set_lazy(:OCSPSigningOidData) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 3, 9]) }
      const_attr_reader  :OCSPSigningOidData
      
      when_class_loaded do
        Map.put(ObjectIdentifier.new_internal(AnyExtendedKeyUsageOidData), "anyExtendedKeyUsage")
        Map.put(ObjectIdentifier.new_internal(ServerAuthOidData), "serverAuth")
        Map.put(ObjectIdentifier.new_internal(ClientAuthOidData), "clientAuth")
        Map.put(ObjectIdentifier.new_internal(CodeSigningOidData), "codeSigning")
        Map.put(ObjectIdentifier.new_internal(EmailProtectionOidData), "emailProtection")
        Map.put(ObjectIdentifier.new_internal(IpsecEndSystemOidData), "ipsecEndSystem")
        Map.put(ObjectIdentifier.new_internal(IpsecTunnelOidData), "ipsecTunnel")
        Map.put(ObjectIdentifier.new_internal(IpsecUserOidData), "ipsecUser")
        Map.put(ObjectIdentifier.new_internal(TimeStampingOidData), "timeStamping")
        Map.put(ObjectIdentifier.new_internal(OCSPSigningOidData), "OCSPSigning")
      end
    }
    
    # Vector of KeyUsages for this object.
    attr_accessor :key_usages
    alias_method :attr_key_usages, :key_usages
    undef_method :key_usages
    alias_method :attr_key_usages=, :key_usages=
    undef_method :key_usages=
    
    typesig { [] }
    # Encode this extension value.
    def encode_this
      if ((@key_usages).nil? || @key_usages.is_empty)
        self.attr_extension_value = nil
        return
      end
      os = DerOutputStream.new
      tmp = DerOutputStream.new
      i = 0
      while i < @key_usages.size
        tmp.put_oid(@key_usages.element_at(i))
        ((i += 1) - 1)
      end
      os.write(DerValue.attr_tag_sequence, tmp)
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [Vector] }
    # Create a ExtendedKeyUsageExtension object from
    # a Vector of Key Usages; the criticality is set to false.
    # 
    # @param keyUsages the Vector of KeyUsages (ObjectIdentifiers)
    def initialize(key_usages)
      initialize__extended_key_usage_extension(Boolean::FALSE, key_usages)
    end
    
    typesig { [Boolean, Vector] }
    # Create a ExtendedKeyUsageExtension object from
    # a Vector of KeyUsages with specified criticality.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param keyUsages the Vector of KeyUsages (ObjectIdentifiers)
    def initialize(critical, key_usages)
      @key_usages = nil
      super()
      @key_usages = key_usages
      self.attr_extension_id = PKIXExtensions::ExtendedKeyUsage_Id
      self.attr_critical = critical.boolean_value
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from its DER encoded value and criticality.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @key_usages = nil
      super()
      self.attr_extension_id = PKIXExtensions::ExtendedKeyUsage_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for " + "ExtendedKeyUsageExtension.")
      end
      @key_usages = Vector.new
      while (!(val.attr_data.available).equal?(0))
        seq = val.attr_data.get_der_value
        usage = seq.get_oid
        @key_usages.add_element(usage)
      end
    end
    
    typesig { [] }
    # Return the extension as user readable string.
    def to_s
      if ((@key_usages).nil?)
        return ""
      end
      usage = "  "
      first = true
      @key_usages.each do |oid|
        if (!first)
          usage += "\n  "
        end
        result = Map.get(oid)
        if (!(result).nil?)
          usage += result
        else
          usage += (oid.to_s).to_s
        end
        first = false
      end
      return (super).to_s + "ExtendedKeyUsages [\n" + usage + "\n]\n"
    end
    
    typesig { [OutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::ExtendedKeyUsage_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(USAGES))
        if (!(obj.is_a?(Vector)))
          raise IOException.new("Attribute value should be of type Vector.")
        end
        @key_usages = obj
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:ExtendedKeyUsageExtension.")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(USAGES))
        # XXXX May want to consider cloning this
        return @key_usages
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:ExtendedKeyUsageExtension.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(USAGES))
        @key_usages = nil
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:ExtendedKeyUsageExtension.")
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(USAGES)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    typesig { [] }
    def get_extended_key_usage
      al = ArrayList.new(@key_usages.size)
      @key_usages.each do |oid|
        al.add(oid.to_s)
      end
      return al
    end
    
    private
    alias_method :initialize__extended_key_usage_extension, :initialize
  end
  
end
