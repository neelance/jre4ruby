require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module X509TrustManagerImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Cert
      include ::Javax::Net::Ssl
      include_const ::Com::Sun::Net::Ssl::Internal::Ssl, :X509ExtendedTrustManager
      include ::Sun::Security::Validator
      include_const ::Sun::Security::Util, :HostnameChecker
    }
  end
  
  # This class implements the SunJSSE X.509 trust manager using the internal
  # validator API in J2SE core. The logic in this class is minimal.<p>
  # 
  # This class supports both the Simple validation algorithm from previous
  # JSSE versions and PKIX validation. Currently, it is not possible for the
  # application to specify PKIX parameters other than trust anchors. This will
  # be fixed in a future release using new APIs. When that happens, it may also
  # make sense to separate the Simple and PKIX trust managers into separate
  # classes.
  # 
  # @author Andreas Sterbenz
  # @author Xuelei Fan
  class X509TrustManagerImpl < X509TrustManagerImplImports.const_get :X509ExtendedTrustManager
    include_class_members X509TrustManagerImplImports
    overload_protected {
      include X509TrustManager
    }
    
    class_module.module_eval {
      # Flag indicating whether to enable revocation check for the PKIX trust
      # manager. Typically, this will only work if the PKIX implementation
      # supports CRL distribution points as we do not manually setup CertStores.
      const_set_lazy(:CheckRevocation) { Debug.get_boolean_property("com.sun.net.ssl.checkRevocation", false) }
      const_attr_reader  :CheckRevocation
    }
    
    attr_accessor :validator_type
    alias_method :attr_validator_type, :validator_type
    undef_method :validator_type
    alias_method :attr_validator_type=, :validator_type=
    undef_method :validator_type=
    
    # The Set of trusted X509Certificates.
    attr_accessor :trusted_certs
    alias_method :attr_trusted_certs, :trusted_certs
    undef_method :trusted_certs
    alias_method :attr_trusted_certs=, :trusted_certs=
    undef_method :trusted_certs=
    
    attr_accessor :pkix_params
    alias_method :attr_pkix_params, :pkix_params
    undef_method :pkix_params
    alias_method :attr_pkix_params=, :pkix_params=
    undef_method :pkix_params=
    
    # note that we need separate validator for client and server due to
    # the different extension checks. They are initialized lazily on demand.
    attr_accessor :client_validator
    alias_method :attr_client_validator, :client_validator
    undef_method :client_validator
    alias_method :attr_client_validator=, :client_validator=
    undef_method :client_validator=
    
    attr_accessor :server_validator
    alias_method :attr_server_validator, :server_validator
    undef_method :server_validator
    alias_method :attr_server_validator=, :server_validator=
    undef_method :server_validator=
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    typesig { [String, KeyStore] }
    def initialize(validator_type, ks)
      @validator_type = nil
      @trusted_certs = nil
      @pkix_params = nil
      @client_validator = nil
      @server_validator = nil
      super()
      @validator_type = validator_type
      @pkix_params = nil
      if ((ks).nil?)
        @trusted_certs = Collections.empty_set
      else
        @trusted_certs = KeyStores.get_trusted_certs(ks)
      end
      show_trusted_certs
    end
    
    typesig { [String, PKIXBuilderParameters] }
    def initialize(validator_type, params)
      @validator_type = nil
      @trusted_certs = nil
      @pkix_params = nil
      @client_validator = nil
      @server_validator = nil
      super()
      @validator_type = validator_type
      @pkix_params = params
      # create server validator eagerly so that we can conveniently
      # get the trusted certificates
      # clients need it anyway eventually, and servers will not mind
      # the little extra footprint
      v = get_validator(Validator::VAR_TLS_SERVER)
      @trusted_certs = v.get_trusted_certificates
      @server_validator = v
      show_trusted_certs
    end
    
    typesig { [] }
    def show_trusted_certs
      if (!(Debug).nil? && Debug.is_on("trustmanager"))
        @trusted_certs.each do |cert|
          System.out.println("adding as trusted cert:")
          System.out.println("  Subject: " + RJava.cast_to_string(cert.get_subject_x500principal))
          System.out.println("  Issuer:  " + RJava.cast_to_string(cert.get_issuer_x500principal))
          System.out.println("  Algorithm: " + RJava.cast_to_string(cert.get_public_key.get_algorithm) + "; Serial number: 0x" + RJava.cast_to_string(cert.get_serial_number.to_s(16)))
          System.out.println("  Valid from " + RJava.cast_to_string(cert.get_not_before) + " until " + RJava.cast_to_string(cert.get_not_after))
          System.out.println
        end
      end
    end
    
    typesig { [String] }
    def get_validator(variant)
      v = nil
      if ((@pkix_params).nil?)
        v = Validator.get_instance(@validator_type, variant, @trusted_certs)
        # if the PKIX validator is created from a KeyStore,
        # disable revocation checking
        if (v.is_a?(PKIXValidator))
          pkix_validator = v
          pkix_validator.get_parameters.set_revocation_enabled(CheckRevocation)
        end
      else
        v = Validator.get_instance(@validator_type, variant, @pkix_params)
      end
      return v
    end
    
    class_module.module_eval {
      typesig { [Validator, Array.typed(X509Certificate), String] }
      def validate(v, chain, auth_type)
        o = JsseJce.begin_fips_provider
        begin
          return v.validate(chain, nil, auth_type)
        ensure
          JsseJce.end_fips_provider(o)
        end
      end
    }
    
    typesig { [Array.typed(X509Certificate), String] }
    # Returns true if the client certificate can be trusted.
    # 
    # @param chain certificates which establish an identity for the client.
    # Chains of arbitrary length are supported, and certificates
    # marked internally as trusted will short-circuit signature checks.
    # @throws IllegalArgumentException if null or zero-length chain
    # is passed in for the chain parameter or if null or zero-length
    # string is passed in for the authType parameter.
    # @throws CertificateException if the certificate chain is not trusted
    # by this TrustManager.
    def check_client_trusted(chain, auth_type)
      if ((chain).nil? || (chain.attr_length).equal?(0))
        raise IllegalArgumentException.new("null or zero-length certificate chain")
      end
      if ((auth_type).nil? || (auth_type.length).equal?(0))
        raise IllegalArgumentException.new("null or zero-length authentication type")
      end
      # assume double checked locking with a volatile flag works
      # (guaranteed under the new Tiger memory model)
      v = @client_validator
      if ((v).nil?)
        synchronized((self)) do
          v = @client_validator
          if ((v).nil?)
            v = get_validator(Validator::VAR_TLS_CLIENT)
            @client_validator = v
          end
        end
      end
      trusted_chain = validate(v, chain, nil)
      if (!(Debug).nil? && Debug.is_on("trustmanager"))
        System.out.println("Found trusted certificate:")
        System.out.println(trusted_chain[trusted_chain.attr_length - 1])
      end
    end
    
    typesig { [Array.typed(X509Certificate), String] }
    # Returns true if the server certifcate can be trusted.
    # 
    # @param chain certificates which establish an identity for the server.
    # Chains of arbitrary length are supported, and certificates
    # marked internally as trusted will short-circuit signature checks.
    # @throws IllegalArgumentException if null or zero-length chain
    # is passed in for the chain parameter or if null or zero-length
    # string is passed in for the authType parameter.
    # @throws CertificateException if the certificate chain is not trusted
    # by this TrustManager.
    def check_server_trusted(chain, auth_type)
      if ((chain).nil? || (chain.attr_length).equal?(0))
        raise IllegalArgumentException.new("null or zero-length certificate chain")
      end
      if ((auth_type).nil? || (auth_type.length).equal?(0))
        raise IllegalArgumentException.new("null or zero-length authentication type")
      end
      # assume double checked locking with a volatile flag works
      # (guaranteed under the new Tiger memory model)
      v = @server_validator
      if ((v).nil?)
        synchronized((self)) do
          v = @server_validator
          if ((v).nil?)
            v = get_validator(Validator::VAR_TLS_SERVER)
            @server_validator = v
          end
        end
      end
      trusted_chain = validate(v, chain, auth_type)
      if (!(Debug).nil? && Debug.is_on("trustmanager"))
        System.out.println("Found trusted certificate:")
        System.out.println(trusted_chain[trusted_chain.attr_length - 1])
      end
    end
    
    typesig { [] }
    # Returns a list of CAs accepted to authenticate entities for the
    # specified purpose.
    # 
    # @param purpose activity for which CAs should be trusted
    # @return list of CAs accepted for authenticating such tasks
    def get_accepted_issuers
      certs_array = Array.typed(X509Certificate).new(@trusted_certs.size) { nil }
      @trusted_certs.to_array(certs_array)
      return certs_array
    end
    
    typesig { [Array.typed(X509Certificate), String, String, String] }
    # Given the partial or complete certificate chain provided by the
    # peer, check its identity and build a certificate path to a trusted
    # root, return if it can be validated and is trusted for client SSL
    # authentication based on the authentication type.
    def check_client_trusted(chain, auth_type, hostname, algorithm)
      check_client_trusted(chain, auth_type)
      check_identity(hostname, chain[0], algorithm)
    end
    
    typesig { [Array.typed(X509Certificate), String, String, String] }
    # Given the partial or complete certificate chain provided by the
    # peer, check its identity and build a certificate path to a trusted
    # root, return if it can be validated and is trusted for server SSL
    # authentication based on the authentication type.
    def check_server_trusted(chain, auth_type, hostname, algorithm)
      check_server_trusted(chain, auth_type)
      check_identity(hostname, chain[0], algorithm)
    end
    
    typesig { [String, X509Certificate, String] }
    # Identify the peer by its certificate and hostname.
    def check_identity(hostname, cert, algorithm)
      if (!(algorithm).nil? && !(algorithm.length).equal?(0))
        # if IPv6 strip off the "[]"
        if (!(hostname).nil? && hostname.starts_with("[") && hostname.ends_with("]"))
          hostname = RJava.cast_to_string(hostname.substring(1, hostname.length - 1))
        end
        if (algorithm.equals_ignore_case("HTTPS"))
          HostnameChecker.get_instance(HostnameChecker::TYPE_TLS).match(hostname, cert)
        else
          if (algorithm.equals_ignore_case("LDAP"))
            HostnameChecker.get_instance(HostnameChecker::TYPE_LDAP).match(hostname, cert)
          else
            raise CertificateException.new("Unknown identification algorithm: " + algorithm)
          end
        end
      end
    end
    
    private
    alias_method :initialize__x509trust_manager_impl, :initialize
  end
  
end
