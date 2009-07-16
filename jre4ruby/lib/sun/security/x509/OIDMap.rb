require "rjava"

# 
# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module OIDMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateParsingException
      include ::Sun::Security::Util
    }
  end
  
  # 
  # This class defines the mapping from OID & name to classes and vice
  # versa.  Used by CertificateExtensions & PKCS10 to get the java
  # classes associated with a particular OID/name.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @author Andreas Sterbenz
  class OIDMap 
    include_class_members OIDMapImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      # "user-friendly" names
      const_set_lazy(:ROOT) { (X509CertImpl::NAME).to_s + "." + (X509CertInfo::NAME).to_s + "." + (X509CertInfo::EXTENSIONS).to_s }
      const_attr_reader  :ROOT
      
      const_set_lazy(:AUTH_KEY_IDENTIFIER) { ROOT + "." + (AuthorityKeyIdentifierExtension::NAME).to_s }
      const_attr_reader  :AUTH_KEY_IDENTIFIER
      
      const_set_lazy(:SUB_KEY_IDENTIFIER) { ROOT + "." + (SubjectKeyIdentifierExtension::NAME).to_s }
      const_attr_reader  :SUB_KEY_IDENTIFIER
      
      const_set_lazy(:KEY_USAGE) { ROOT + "." + (KeyUsageExtension::NAME).to_s }
      const_attr_reader  :KEY_USAGE
      
      const_set_lazy(:PRIVATE_KEY_USAGE) { ROOT + "." + (PrivateKeyUsageExtension::NAME).to_s }
      const_attr_reader  :PRIVATE_KEY_USAGE
      
      const_set_lazy(:POLICY_MAPPINGS) { ROOT + "." + (PolicyMappingsExtension::NAME).to_s }
      const_attr_reader  :POLICY_MAPPINGS
      
      const_set_lazy(:SUB_ALT_NAME) { ROOT + "." + (SubjectAlternativeNameExtension::NAME).to_s }
      const_attr_reader  :SUB_ALT_NAME
      
      const_set_lazy(:ISSUER_ALT_NAME) { ROOT + "." + (IssuerAlternativeNameExtension::NAME).to_s }
      const_attr_reader  :ISSUER_ALT_NAME
      
      const_set_lazy(:BASIC_CONSTRAINTS) { ROOT + "." + (BasicConstraintsExtension::NAME).to_s }
      const_attr_reader  :BASIC_CONSTRAINTS
      
      const_set_lazy(:NAME_CONSTRAINTS) { ROOT + "." + (NameConstraintsExtension::NAME).to_s }
      const_attr_reader  :NAME_CONSTRAINTS
      
      const_set_lazy(:POLICY_CONSTRAINTS) { ROOT + "." + (PolicyConstraintsExtension::NAME).to_s }
      const_attr_reader  :POLICY_CONSTRAINTS
      
      const_set_lazy(:CRL_NUMBER) { ROOT + "." + (CRLNumberExtension::NAME).to_s }
      const_attr_reader  :CRL_NUMBER
      
      const_set_lazy(:CRL_REASON) { ROOT + "." + (CRLReasonCodeExtension::NAME).to_s }
      const_attr_reader  :CRL_REASON
      
      const_set_lazy(:NETSCAPE_CERT) { ROOT + "." + (NetscapeCertTypeExtension::NAME).to_s }
      const_attr_reader  :NETSCAPE_CERT
      
      const_set_lazy(:CERT_POLICIES) { ROOT + "." + (CertificatePoliciesExtension::NAME).to_s }
      const_attr_reader  :CERT_POLICIES
      
      const_set_lazy(:EXT_KEY_USAGE) { ROOT + "." + (ExtendedKeyUsageExtension::NAME).to_s }
      const_attr_reader  :EXT_KEY_USAGE
      
      const_set_lazy(:INHIBIT_ANY_POLICY) { ROOT + "." + (InhibitAnyPolicyExtension::NAME).to_s }
      const_attr_reader  :INHIBIT_ANY_POLICY
      
      const_set_lazy(:CRL_DIST_POINTS) { ROOT + "." + (CRLDistributionPointsExtension::NAME).to_s }
      const_attr_reader  :CRL_DIST_POINTS
      
      const_set_lazy(:CERT_ISSUER) { ROOT + "." + (CertificateIssuerExtension::NAME).to_s }
      const_attr_reader  :CERT_ISSUER
      
      const_set_lazy(:AUTH_INFO_ACCESS) { ROOT + "." + (AuthorityInfoAccessExtension::NAME).to_s }
      const_attr_reader  :AUTH_INFO_ACCESS
      
      const_set_lazy(:ISSUING_DIST_POINT) { ROOT + "." + (IssuingDistributionPointExtension::NAME).to_s }
      const_attr_reader  :ISSUING_DIST_POINT
      
      const_set_lazy(:DELTA_CRL_INDICATOR) { ROOT + "." + (DeltaCRLIndicatorExtension::NAME).to_s }
      const_attr_reader  :DELTA_CRL_INDICATOR
      
      const_set_lazy(:FRESHEST_CRL) { ROOT + "." + (FreshestCRLExtension::NAME).to_s }
      const_attr_reader  :FRESHEST_CRL
      
      const_set_lazy(:NetscapeCertType_data) { Array.typed(::Java::Int).new([2, 16, 840, 1, 113730, 1, 1]) }
      const_attr_reader  :NetscapeCertType_data
      
      when_class_loaded do
        const_set :OidMap, HashMap.new
        const_set :NameMap, HashMap.new
        add_internal(SUB_KEY_IDENTIFIER, PKIXExtensions::SubjectKey_Id, "sun.security.x509.SubjectKeyIdentifierExtension")
        add_internal(KEY_USAGE, PKIXExtensions::KeyUsage_Id, "sun.security.x509.KeyUsageExtension")
        add_internal(PRIVATE_KEY_USAGE, PKIXExtensions::PrivateKeyUsage_Id, "sun.security.x509.PrivateKeyUsageExtension")
        add_internal(SUB_ALT_NAME, PKIXExtensions::SubjectAlternativeName_Id, "sun.security.x509.SubjectAlternativeNameExtension")
        add_internal(ISSUER_ALT_NAME, PKIXExtensions::IssuerAlternativeName_Id, "sun.security.x509.IssuerAlternativeNameExtension")
        add_internal(BASIC_CONSTRAINTS, PKIXExtensions::BasicConstraints_Id, "sun.security.x509.BasicConstraintsExtension")
        add_internal(CRL_NUMBER, PKIXExtensions::CRLNumber_Id, "sun.security.x509.CRLNumberExtension")
        add_internal(CRL_REASON, PKIXExtensions::ReasonCode_Id, "sun.security.x509.CRLReasonCodeExtension")
        add_internal(NAME_CONSTRAINTS, PKIXExtensions::NameConstraints_Id, "sun.security.x509.NameConstraintsExtension")
        add_internal(POLICY_MAPPINGS, PKIXExtensions::PolicyMappings_Id, "sun.security.x509.PolicyMappingsExtension")
        add_internal(AUTH_KEY_IDENTIFIER, PKIXExtensions::AuthorityKey_Id, "sun.security.x509.AuthorityKeyIdentifierExtension")
        add_internal(POLICY_CONSTRAINTS, PKIXExtensions::PolicyConstraints_Id, "sun.security.x509.PolicyConstraintsExtension")
        add_internal(NETSCAPE_CERT, ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([2, 16, 840, 1, 113730, 1, 1])), "sun.security.x509.NetscapeCertTypeExtension")
        add_internal(CERT_POLICIES, PKIXExtensions::CertificatePolicies_Id, "sun.security.x509.CertificatePoliciesExtension")
        add_internal(EXT_KEY_USAGE, PKIXExtensions::ExtendedKeyUsage_Id, "sun.security.x509.ExtendedKeyUsageExtension")
        add_internal(INHIBIT_ANY_POLICY, PKIXExtensions::InhibitAnyPolicy_Id, "sun.security.x509.InhibitAnyPolicyExtension")
        add_internal(CRL_DIST_POINTS, PKIXExtensions::CRLDistributionPoints_Id, "sun.security.x509.CRLDistributionPointsExtension")
        add_internal(CERT_ISSUER, PKIXExtensions::CertificateIssuer_Id, "sun.security.x509.CertificateIssuerExtension")
        add_internal(AUTH_INFO_ACCESS, PKIXExtensions::AuthInfoAccess_Id, "sun.security.x509.AuthorityInfoAccessExtension")
        add_internal(ISSUING_DIST_POINT, PKIXExtensions::IssuingDistributionPoint_Id, "sun.security.x509.IssuingDistributionPointExtension")
        add_internal(DELTA_CRL_INDICATOR, PKIXExtensions::DeltaCRLIndicator_Id, "sun.security.x509.DeltaCRLIndicatorExtension")
        add_internal(FRESHEST_CRL, PKIXExtensions::FreshestCRL_Id, "sun.security.x509.FreshestCRLExtension")
      end
      
      typesig { [String, ObjectIdentifier, String] }
      # 
      # Add attributes to the table. For internal use in the static
      # initializer.
      def add_internal(name, oid, class_name)
        info = OIDInfo.new(name, oid, class_name)
        OidMap.put(oid, info)
        NameMap.put(name, info)
      end
      
      # 
      # Inner class encapsulating the mapping info and Class loading.
      const_set_lazy(:OIDInfo) { Class.new do
        include_class_members OIDMap
        
        attr_accessor :oid
        alias_method :attr_oid, :oid
        undef_method :oid
        alias_method :attr_oid=, :oid=
        undef_method :oid=
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :class_name
        alias_method :attr_class_name, :class_name
        undef_method :class_name
        alias_method :attr_class_name=, :class_name=
        undef_method :class_name=
        
        attr_accessor :clazz
        alias_method :attr_clazz, :clazz
        undef_method :clazz
        alias_method :attr_clazz=, :clazz=
        undef_method :clazz=
        
        typesig { [String, ObjectIdentifier, String] }
        def initialize(name, oid, class_name)
          @oid = nil
          @name = nil
          @class_name = nil
          @clazz = nil
          @name = name
          @oid = oid
          @class_name = class_name
        end
        
        typesig { [String, ObjectIdentifier, Class] }
        def initialize(name, oid, clazz)
          @oid = nil
          @name = nil
          @class_name = nil
          @clazz = nil
          @name = name
          @oid = oid
          @class_name = clazz.get_name
          @clazz = clazz
        end
        
        typesig { [] }
        # 
        # Return the Class object associated with this attribute.
        def get_clazz
          begin
            c = @clazz
            if ((c).nil?)
              c = Class.for_name(@class_name)
              @clazz = c
            end
            return c
          rescue ClassNotFoundException => e
            raise CertificateException.new("Could not load class: " + (e).to_s).init_cause(e)
          end
        end
        
        private
        alias_method :initialize__oidinfo, :initialize
      end }
      
      typesig { [String, String, Class] }
      # 
      # Add a name to lookup table.
      # 
      # @param name the name of the attr
      # @param oid the string representation of the object identifier for
      # the class.
      # @param clazz the Class object associated with this attribute
      # @exception CertificateException on errors.
      def add_attribute(name, oid, clazz)
        obj_id = nil
        begin
          obj_id = ObjectIdentifier.new(oid)
        rescue IOException => ioe
          raise CertificateException.new("Invalid Object identifier: " + oid)
        end
        info = OIDInfo.new(name, obj_id, clazz)
        if (!(OidMap.put(obj_id, info)).nil?)
          raise CertificateException.new("Object identifier already exists: " + oid)
        end
        if (!(NameMap.put(name, info)).nil?)
          raise CertificateException.new("Name already exists: " + name)
        end
      end
      
      typesig { [ObjectIdentifier] }
      # 
      # Return user friendly name associated with the OID.
      # 
      # @param oid the name of the object identifier to be returned.
      # @return the user friendly name or null if no name
      # is registered for this oid.
      def get_name(oid)
        info = OidMap.get(oid)
        return ((info).nil?) ? nil : info.attr_name
      end
      
      typesig { [String] }
      # 
      # Return Object identifier for user friendly name.
      # 
      # @param name the user friendly name.
      # @return the Object Identifier or null if no oid
      # is registered for this name.
      def get_oid(name)
        info = NameMap.get(name)
        return ((info).nil?) ? nil : info.attr_oid
      end
      
      typesig { [String] }
      # 
      # Return the java class object associated with the user friendly name.
      # 
      # @param name the user friendly name.
      # @exception CertificateException if class cannot be instantiated.
      def get_class(name)
        info = NameMap.get(name)
        return ((info).nil?) ? nil : info.get_clazz
      end
      
      typesig { [ObjectIdentifier] }
      # 
      # Return the java class object associated with the object identifier.
      # 
      # @param oid the name of the object identifier to be returned.
      # @exception CertificateException if class cannot be instatiated.
      def get_class(oid)
        info = OidMap.get(oid)
        return ((info).nil?) ? nil : info.get_clazz
      end
    }
    
    private
    alias_method :initialize__oidmap, :initialize
  end
  
end
