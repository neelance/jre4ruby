require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Validator
  module EndEntityCheckerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Validator
      include ::Java::Util
      include ::Java::Security::Cert
      include_const ::Sun::Security::X509, :NetscapeCertTypeExtension
    }
  end
  
  # Class to check if an end entity cert is suitable for use in some
  # context.<p>
  # 
  # This class is used internally by the validator. Currently, seven variants
  # are supported defined as VAR_XXX constants in the Validator class:
  # <ul>
  # <li>Generic. No additional requirements, all certificates are ok.
  # 
  # <li>TLS server. Requires that a String parameter is passed to
  # validate that specifies the name of the TLS key exchange algorithm
  # in use. See the JSSE X509TrustManager spec for details.
  # 
  # <li>TLS client.
  # 
  # <li>Code signing.
  # 
  # <li>JCE code signing. Some early JCE code signing certs issued to
  # providers had incorrect extensions. In this mode the checks
  # are relaxed compared to standard code signing checks in order to
  # allow these certificates to pass.
  # 
  # <li>Plugin code signing. WebStart and Plugin require their own variant
  # which is equivalent to VAR_CODE_SIGNING with additional checks for
  # compatibility/special cases. See also PKIXValidator.
  # 
  # <li>TSA Server (see RFC 3161, section 2.3).
  # 
  # </ul>
  # 
  # @author Andreas Sterbenz
  class EndEntityChecker 
    include_class_members EndEntityCheckerImports
    
    class_module.module_eval {
      # extended key usage OIDs for TLS server, TLS client, code signing
      # and any usage
      const_set_lazy(:OID_EXTENDED_KEY_USAGE) { SimpleValidator::OID_EXTENDED_KEY_USAGE }
      const_attr_reader  :OID_EXTENDED_KEY_USAGE
      
      const_set_lazy(:OID_EKU_TLS_SERVER) { "1.3.6.1.5.5.7.3.1" }
      const_attr_reader  :OID_EKU_TLS_SERVER
      
      const_set_lazy(:OID_EKU_TLS_CLIENT) { "1.3.6.1.5.5.7.3.2" }
      const_attr_reader  :OID_EKU_TLS_CLIENT
      
      const_set_lazy(:OID_EKU_CODE_SIGNING) { "1.3.6.1.5.5.7.3.3" }
      const_attr_reader  :OID_EKU_CODE_SIGNING
      
      const_set_lazy(:OID_EKU_TIME_STAMPING) { "1.3.6.1.5.5.7.3.8" }
      const_attr_reader  :OID_EKU_TIME_STAMPING
      
      const_set_lazy(:OID_EKU_ANY_USAGE) { "2.5.29.37.0" }
      const_attr_reader  :OID_EKU_ANY_USAGE
      
      # the Netscape Server-Gated-Cryptography EKU extension OID
      const_set_lazy(:OID_EKU_NS_SGC) { "2.16.840.1.113730.4.1" }
      const_attr_reader  :OID_EKU_NS_SGC
      
      # the Microsoft Server-Gated-Cryptography EKU extension OID
      const_set_lazy(:OID_EKU_MS_SGC) { "1.3.6.1.4.1.311.10.3.3" }
      const_attr_reader  :OID_EKU_MS_SGC
      
      const_set_lazy(:NSCT_SSL_CLIENT) { NetscapeCertTypeExtension::SSL_CLIENT }
      const_attr_reader  :NSCT_SSL_CLIENT
      
      const_set_lazy(:NSCT_SSL_SERVER) { NetscapeCertTypeExtension::SSL_SERVER }
      const_attr_reader  :NSCT_SSL_SERVER
      
      const_set_lazy(:NSCT_CODE_SIGNING) { NetscapeCertTypeExtension::OBJECT_SIGNING }
      const_attr_reader  :NSCT_CODE_SIGNING
      
      # bit numbers in the key usage extension
      const_set_lazy(:KU_SIGNATURE) { 0 }
      const_attr_reader  :KU_SIGNATURE
      
      const_set_lazy(:KU_KEY_ENCIPHERMENT) { 2 }
      const_attr_reader  :KU_KEY_ENCIPHERMENT
      
      const_set_lazy(:KU_KEY_AGREEMENT) { 4 }
      const_attr_reader  :KU_KEY_AGREEMENT
      
      # TLS key exchange algorithms requiring digitalSignature key usage
      const_set_lazy(:KU_SERVER_SIGNATURE) { Arrays.as_list("DHE_DSS", "DHE_RSA", "ECDHE_ECDSA", "ECDHE_RSA", "RSA_EXPORT", "UNKNOWN") }
      const_attr_reader  :KU_SERVER_SIGNATURE
      
      # TLS key exchange algorithms requiring keyEncipherment key usage
      const_set_lazy(:KU_SERVER_ENCRYPTION) { Arrays.as_list("RSA") }
      const_attr_reader  :KU_SERVER_ENCRYPTION
      
      # TLS key exchange algorithms requiring keyAgreement key usage
      const_set_lazy(:KU_SERVER_KEY_AGREEMENT) { Arrays.as_list("DH_DSS", "DH_RSA", "ECDH_ECDSA", "ECDH_RSA") }
      const_attr_reader  :KU_SERVER_KEY_AGREEMENT
    }
    
    # variant of this end entity cert checker
    attr_accessor :variant
    alias_method :attr_variant, :variant
    undef_method :variant
    alias_method :attr_variant=, :variant=
    undef_method :variant=
    
    # type of the validator this checker belongs to
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    typesig { [String, String] }
    def initialize(type, variant)
      @variant = nil
      @type = nil
      @type = type
      @variant = variant
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      def get_instance(type, variant)
        return EndEntityChecker.new(type, variant)
      end
    }
    
    typesig { [X509Certificate, Object] }
    def check(cert, parameter)
      if ((@variant == Validator::VAR_GENERIC))
        # no checks
        return
      else
        if ((@variant == Validator::VAR_TLS_SERVER))
          check_tlsserver(cert, parameter)
        else
          if ((@variant == Validator::VAR_TLS_CLIENT))
            check_tlsclient(cert)
          else
            if ((@variant == Validator::VAR_CODE_SIGNING))
              check_code_signing(cert)
            else
              if ((@variant == Validator::VAR_JCE_SIGNING))
                check_code_signing(cert)
              else
                if ((@variant == Validator::VAR_PLUGIN_CODE_SIGNING))
                  check_code_signing(cert)
                else
                  if ((@variant == Validator::VAR_TSA_SERVER))
                    check_tsaserver(cert)
                  else
                    raise CertificateException.new("Unknown variant: " + @variant)
                  end
                end
              end
            end
          end
        end
      end
    end
    
    typesig { [X509Certificate] }
    # Utility method returning the Set of critical extensions for
    # certificate cert (never null).
    def get_critical_extensions(cert)
      exts = cert.get_critical_extension_oids
      if ((exts).nil?)
        exts = Collections.empty_set
      end
      return exts
    end
    
    typesig { [JavaSet] }
    # Utility method checking if there are any unresolved critical extensions.
    # @throws CertificateException if so.
    def check_remaining_extensions(exts)
      # basic constraints irrelevant in EE certs
      exts.remove(SimpleValidator::OID_BASIC_CONSTRAINTS)
      if (!exts.is_empty)
        raise CertificateException.new("Certificate contains unsupported " + "critical extensions: " + RJava.cast_to_string(exts))
      end
    end
    
    typesig { [X509Certificate, JavaSet, String] }
    # Utility method checking if the extended key usage extension in
    # certificate cert allows use for expectedEKU.
    def check_eku(cert, exts, expected_eku)
      eku = cert.get_extended_key_usage
      if ((eku).nil?)
        return true
      end
      return eku.contains(expected_eku) || eku.contains(OID_EKU_ANY_USAGE)
    end
    
    typesig { [X509Certificate, ::Java::Int] }
    # Utility method checking if bit 'bit' is set in this certificates
    # key usage extension.
    # @throws CertificateException if not
    def check_key_usage(cert, bit)
      key_usage = cert.get_key_usage
      if ((key_usage).nil?)
        return true
      end
      return (key_usage.attr_length > bit) && key_usage[bit]
    end
    
    typesig { [X509Certificate] }
    # Check whether this certificate can be used for TLS client
    # authentication.
    # @throws CertificateException if not.
    def check_tlsclient(cert)
      exts = get_critical_extensions(cert)
      if ((check_key_usage(cert, KU_SIGNATURE)).equal?(false))
        raise ValidatorException.new("KeyUsage does not allow digital signatures", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      if ((check_eku(cert, exts, OID_EKU_TLS_CLIENT)).equal?(false))
        raise ValidatorException.new("Extended key usage does not " + "permit use for TLS client authentication", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      if (!SimpleValidator.get_netscape_cert_type_bit(cert, NSCT_SSL_CLIENT))
        raise ValidatorException.new("Netscape cert type does not permit use for SSL client", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      # remove extensions we checked
      exts.remove(SimpleValidator::OID_KEY_USAGE)
      exts.remove(SimpleValidator::OID_EXTENDED_KEY_USAGE)
      exts.remove(SimpleValidator::OID_NETSCAPE_CERT_TYPE)
      check_remaining_extensions(exts)
    end
    
    typesig { [X509Certificate, String] }
    # Check whether this certificate can be used for TLS server authentication
    # using the specified authentication type parameter. See X509TrustManager
    # specification for details.
    # @throws CertificateException if not.
    def check_tlsserver(cert, parameter)
      exts = get_critical_extensions(cert)
      if (KU_SERVER_ENCRYPTION.contains(parameter))
        if ((check_key_usage(cert, KU_KEY_ENCIPHERMENT)).equal?(false))
          raise ValidatorException.new("KeyUsage does not allow key encipherment", ValidatorException::T_EE_EXTENSIONS, cert)
        end
      else
        if (KU_SERVER_SIGNATURE.contains(parameter))
          if ((check_key_usage(cert, KU_SIGNATURE)).equal?(false))
            raise ValidatorException.new("KeyUsage does not allow digital signatures", ValidatorException::T_EE_EXTENSIONS, cert)
          end
        else
          if (KU_SERVER_KEY_AGREEMENT.contains(parameter))
            if ((check_key_usage(cert, KU_KEY_AGREEMENT)).equal?(false))
              raise ValidatorException.new("KeyUsage does not allow key agreement", ValidatorException::T_EE_EXTENSIONS, cert)
            end
          else
            raise CertificateException.new("Unknown authType: " + parameter)
          end
        end
      end
      if ((check_eku(cert, exts, OID_EKU_TLS_SERVER)).equal?(false))
        # check for equivalent but now obsolete Server-Gated-Cryptography
        # (aka Step-Up, 128 bit) EKU OIDs
        if (((check_eku(cert, exts, OID_EKU_MS_SGC)).equal?(false)) && ((check_eku(cert, exts, OID_EKU_NS_SGC)).equal?(false)))
          raise ValidatorException.new("Extended key usage does not permit use for TLS " + "server authentication", ValidatorException::T_EE_EXTENSIONS, cert)
        end
      end
      if (!SimpleValidator.get_netscape_cert_type_bit(cert, NSCT_SSL_SERVER))
        raise ValidatorException.new("Netscape cert type does not permit use for SSL server", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      # remove extensions we checked
      exts.remove(SimpleValidator::OID_KEY_USAGE)
      exts.remove(SimpleValidator::OID_EXTENDED_KEY_USAGE)
      exts.remove(SimpleValidator::OID_NETSCAPE_CERT_TYPE)
      check_remaining_extensions(exts)
    end
    
    typesig { [X509Certificate] }
    # Check whether this certificate can be used for code signing.
    # @throws CertificateException if not.
    def check_code_signing(cert)
      exts = get_critical_extensions(cert)
      if ((check_key_usage(cert, KU_SIGNATURE)).equal?(false))
        raise ValidatorException.new("KeyUsage does not allow digital signatures", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      if ((check_eku(cert, exts, OID_EKU_CODE_SIGNING)).equal?(false))
        raise ValidatorException.new("Extended key usage does not permit use for code signing", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      # do not check Netscape cert type for JCE code signing checks
      # (some certs were issued with incorrect extensions)
      if (((@variant == Validator::VAR_JCE_SIGNING)).equal?(false))
        if (!SimpleValidator.get_netscape_cert_type_bit(cert, NSCT_CODE_SIGNING))
          raise ValidatorException.new("Netscape cert type does not permit use for code signing", ValidatorException::T_EE_EXTENSIONS, cert)
        end
        exts.remove(SimpleValidator::OID_NETSCAPE_CERT_TYPE)
      end
      # remove extensions we checked
      exts.remove(SimpleValidator::OID_KEY_USAGE)
      exts.remove(SimpleValidator::OID_EXTENDED_KEY_USAGE)
      check_remaining_extensions(exts)
    end
    
    typesig { [X509Certificate] }
    # Check whether this certificate can be used by a time stamping authority
    # server (see RFC 3161, section 2.3).
    # @throws CertificateException if not.
    def check_tsaserver(cert)
      exts = get_critical_extensions(cert)
      if ((check_key_usage(cert, KU_SIGNATURE)).equal?(false))
        raise ValidatorException.new("KeyUsage does not allow digital signatures", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      if ((cert.get_extended_key_usage).nil?)
        raise ValidatorException.new("Certificate does not contain an extended key usage " + "extension required for a TSA server", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      if ((check_eku(cert, exts, OID_EKU_TIME_STAMPING)).equal?(false))
        raise ValidatorException.new("Extended key usage does not permit use for TSA server", ValidatorException::T_EE_EXTENSIONS, cert)
      end
      # remove extensions we checked
      exts.remove(SimpleValidator::OID_KEY_USAGE)
      exts.remove(SimpleValidator::OID_EXTENDED_KEY_USAGE)
      check_remaining_extensions(exts)
    end
    
    private
    alias_method :initialize__end_entity_checker, :initialize
  end
  
end
