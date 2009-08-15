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
  module CertificatePoliciesExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Util
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # This class defines the certificate policies extension which specifies the
  # policies under which the certificate has been issued
  # and the purposes for which the certificate may be used.
  # <p>
  # Applications with specific policy requirements are expected to have a
  # list of those policies which they will accept and to compare the
  # policy OIDs in the certificate to that list.  If this extension is
  # critical, the path validation software MUST be able to interpret this
  # extension (including the optional qualifier), or MUST reject the
  # certificate.
  # <p>
  # Optional qualifiers are not supported in this implementation, as they are
  # not recommended by RFC2459.
  # 
  # The ASN.1 syntax for this is (IMPLICIT tagging is defined in the
  # module definition):
  # <pre>
  # id-ce-certificatePolicies OBJECT IDENTIFIER ::=  { id-ce 32 }
  # 
  # certificatePolicies ::= SEQUENCE SIZE (1..MAX) OF PolicyInformation
  # 
  # PolicyInformation ::= SEQUENCE {
  # policyIdentifier   CertPolicyId,
  # policyQualifiers   SEQUENCE SIZE (1..MAX) OF
  # PolicyQualifierInfo OPTIONAL }
  # 
  # CertPolicyId ::= OBJECT IDENTIFIER
  # </pre>
  # @author Anne Anderson
  # @since       1.4
  # @see Extension
  # @see CertAttrSet
  class CertificatePoliciesExtension < CertificatePoliciesExtensionImports.const_get :Extension
    include_class_members CertificatePoliciesExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.CertificatePolicies" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "CertificatePolicies" }
      const_attr_reader  :NAME
      
      const_set_lazy(:POLICIES) { "policies" }
      const_attr_reader  :POLICIES
    }
    
    # List of PolicyInformation for this object.
    attr_accessor :cert_policies
    alias_method :attr_cert_policies, :cert_policies
    undef_method :cert_policies
    alias_method :attr_cert_policies=, :cert_policies=
    undef_method :cert_policies=
    
    typesig { [] }
    # Encode this extension value.
    def encode_this
      if ((@cert_policies).nil? || @cert_policies.is_empty)
        self.attr_extension_value = nil
      else
        os = DerOutputStream.new
        tmp = DerOutputStream.new
        @cert_policies.each do |info|
          info.encode(tmp)
        end
        os.write(DerValue.attr_tag_sequence, tmp)
        self.attr_extension_value = os.to_byte_array
      end
    end
    
    typesig { [JavaList] }
    # Create a CertificatePoliciesExtension object from
    # a List of PolicyInformation; the criticality is set to false.
    # 
    # @param certPolicies the List of PolicyInformation.
    def initialize(cert_policies)
      initialize__certificate_policies_extension(Boolean::FALSE, cert_policies)
    end
    
    typesig { [Boolean, JavaList] }
    # Create a CertificatePoliciesExtension object from
    # a List of PolicyInformation with specified criticality.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param certPolicies the List of PolicyInformation.
    def initialize(critical, cert_policies)
      @cert_policies = nil
      super()
      @cert_policies = cert_policies
      self.attr_extension_id = PKIXExtensions::CertificatePolicies_Id
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
      @cert_policies = nil
      super()
      self.attr_extension_id = PKIXExtensions::CertificatePolicies_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for " + "CertificatePoliciesExtension.")
      end
      @cert_policies = ArrayList.new
      while (!(val.attr_data.available).equal?(0))
        seq = val.attr_data.get_der_value
        policy = PolicyInformation.new(seq)
        @cert_policies.add(policy)
      end
    end
    
    typesig { [] }
    # Return the extension as user readable string.
    def to_s
      if ((@cert_policies).nil?)
        return ""
      end
      sb = StringBuilder.new(super)
      sb.append("CertificatePolicies [\n")
      @cert_policies.each do |info|
        sb.append(info.to_s)
      end
      sb.append("]\n")
      return sb.to_s
    end
    
    typesig { [OutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::CertificatePolicies_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(POLICIES))
        if (!(obj.is_a?(JavaList)))
          raise IOException.new("Attribute value should be of type List.")
        end
        @cert_policies = obj
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:CertificatePoliciesExtension.")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(POLICIES))
        # XXXX May want to consider cloning this
        return @cert_policies
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:CertificatePoliciesExtension.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(POLICIES))
        @cert_policies = nil
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:CertificatePoliciesExtension.")
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(POLICIES)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__certificate_policies_extension, :initialize
  end
  
end
