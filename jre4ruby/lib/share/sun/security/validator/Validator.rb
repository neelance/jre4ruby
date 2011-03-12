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
  module ValidatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Validator
      include ::Java::Util
      include_const ::Java::Security, :KeyStore
      include ::Java::Security::Cert
    }
  end
  
  # Validator abstract base class. Concrete classes are instantiated by calling
  # one of the getInstance() methods. All methods defined in this class
  # must be safe for concurrent use by multiple threads.<p>
  # 
  # The model is that a Validator instance is created specifying validation
  # settings, such as trust anchors or PKIX parameters. Then one or more
  # paths are validated using those parameters. In some cases, additional
  # information can be provided per path validation. This is independent of
  # the validation parameters and currently only used for TLS server validation.
  # <p>
  # Path validation is performed by calling one of the validate() methods. It
  # specifies a suggested path to be used for validation if available, or only
  # the end entity certificate otherwise. Optionally additional certificates can
  # be specified that the caller believes could be helpful. Implementations are
  # free to make use of this information or validate the path using other means.
  # validate() also checks that the end entity certificate is suitable for the
  # intended purpose as described below.
  # 
  # <p>There are two orthogonal parameters to select the Validator
  # implementation: type and variant. Type selects the validation algorithm.
  # Currently supported are TYPE_SIMPLE and TYPE_PKIX. See SimpleValidator and
  # PKIXValidator for details.
  # <p>
  # Variant controls additional extension checks. Currently supported are
  # five variants:
  # <ul>
  # <li>VAR_GENERIC (no additional checks),
  # <li>VAR_TLS_CLIENT (TLS client specific checks)
  # <li>VAR_TLS_SERVER (TLS server specific checks), and
  # <li>VAR_CODE_SIGNING (code signing specific checks).
  # <li>VAR_JCE_SIGNING (JCE code signing specific checks).
  # <li>VAR_TSA_SERVER (TSA server specific checks).
  # <li>VAR_PLUGIN_CODE_SIGNING (Plugin/WebStart code signing specific checks).
  # </ul>
  # See EndEntityChecker for more information.
  # <p>
  # Examples:
  # <pre>
  #   // instantiate validator specifying type, variant, and trust anchors
  #   Validator validator = Validator.getInstance(Validator.TYPE_PKIX,
  #                                               Validator.VAR_TLS_CLIENT,
  #                                               trustedCerts);
  #   // validate one or more chains using the validator
  #   validator.validate(chain); // throws CertificateException if failed
  # </pre>
  # 
  # @see SimpleValidator
  # @see PKIXValidator
  # @see EndEntityChecker
  # 
  # @author Andreas Sterbenz
  class Validator 
    include_class_members ValidatorImports
    
    class_module.module_eval {
      const_set_lazy(:CHAIN0) { Array.typed(X509Certificate).new([]) }
      const_attr_reader  :CHAIN0
      
      # Constant for a validator of type Simple.
      # @see #getInstance
      const_set_lazy(:TYPE_SIMPLE) { "Simple" }
      const_attr_reader  :TYPE_SIMPLE
      
      # Constant for a validator of type PKIX.
      # @see #getInstance
      const_set_lazy(:TYPE_PKIX) { "PKIX" }
      const_attr_reader  :TYPE_PKIX
      
      # Constant for a Generic variant of a validator.
      # @see #getInstance
      const_set_lazy(:VAR_GENERIC) { "generic" }
      const_attr_reader  :VAR_GENERIC
      
      # Constant for a Code Signing variant of a validator.
      # @see #getInstance
      const_set_lazy(:VAR_CODE_SIGNING) { "code signing" }
      const_attr_reader  :VAR_CODE_SIGNING
      
      # Constant for a JCE Code Signing variant of a validator.
      # @see #getInstance
      const_set_lazy(:VAR_JCE_SIGNING) { "jce signing" }
      const_attr_reader  :VAR_JCE_SIGNING
      
      # Constant for a TLS Client variant of a validator.
      # @see #getInstance
      const_set_lazy(:VAR_TLS_CLIENT) { "tls client" }
      const_attr_reader  :VAR_TLS_CLIENT
      
      # Constant for a TLS Server variant of a validator.
      # @see #getInstance
      const_set_lazy(:VAR_TLS_SERVER) { "tls server" }
      const_attr_reader  :VAR_TLS_SERVER
      
      # Constant for a TSA Server variant of a validator.
      # @see #getInstance
      const_set_lazy(:VAR_TSA_SERVER) { "tsa server" }
      const_attr_reader  :VAR_TSA_SERVER
      
      # Constant for a Code Signing variant of a validator for use by
      # the J2SE Plugin/WebStart code.
      # @see #getInstance
      const_set_lazy(:VAR_PLUGIN_CODE_SIGNING) { "plugin code signing" }
      const_attr_reader  :VAR_PLUGIN_CODE_SIGNING
    }
    
    attr_accessor :end_entity_checker
    alias_method :attr_end_entity_checker, :end_entity_checker
    undef_method :end_entity_checker
    alias_method :attr_end_entity_checker=, :end_entity_checker=
    undef_method :end_entity_checker=
    
    attr_accessor :variant
    alias_method :attr_variant, :variant
    undef_method :variant
    alias_method :attr_variant=, :variant=
    undef_method :variant=
    
    # @deprecated
    # @see #setValidationDate
    attr_accessor :validation_date
    alias_method :attr_validation_date, :validation_date
    undef_method :validation_date
    alias_method :attr_validation_date=, :validation_date=
    undef_method :validation_date=
    
    typesig { [String, String] }
    def initialize(type, variant)
      @end_entity_checker = nil
      @variant = nil
      @validation_date = nil
      @variant = variant
      @end_entity_checker = EndEntityChecker.get_instance(type, variant)
    end
    
    class_module.module_eval {
      typesig { [String, String, KeyStore] }
      # Get a new Validator instance using the trusted certificates from the
      # specified KeyStore as trust anchors.
      def get_instance(type, variant, ks)
        return get_instance(type, variant, KeyStores.get_trusted_certs(ks))
      end
      
      typesig { [String, String, Collection] }
      # Get a new Validator instance using the Set of X509Certificates as trust
      # anchors.
      def get_instance(type, variant, trusted_certs)
        if ((type == TYPE_SIMPLE))
          return SimpleValidator.new(variant, trusted_certs)
        else
          if ((type == TYPE_PKIX))
            return PKIXValidator.new(variant, trusted_certs)
          else
            raise IllegalArgumentException.new("Unknown validator type: " + type)
          end
        end
      end
      
      typesig { [String, String, PKIXBuilderParameters] }
      # Get a new Validator instance using the provided PKIXBuilderParameters.
      # This method can only be used with the PKIX validator.
      def get_instance(type, variant, params)
        if (((type == TYPE_PKIX)).equal?(false))
          raise IllegalArgumentException.new("getInstance(PKIXBuilderParameters) can only be used " + "with PKIX validator")
        end
        return PKIXValidator.new(variant, params)
      end
    }
    
    typesig { [Array.typed(X509Certificate)] }
    # Validate the given certificate chain.
    def validate(chain)
      return validate(chain, nil, nil)
    end
    
    typesig { [Array.typed(X509Certificate), Collection] }
    # Validate the given certificate chain. If otherCerts is non-null, it is
    # a Collection of additional X509Certificates that could be helpful for
    # path building.
    def validate(chain, other_certs)
      return validate(chain, other_certs, nil)
    end
    
    typesig { [Array.typed(X509Certificate), Collection, Object] }
    # Validate the given certificate chain. If otherCerts is non-null, it is
    # a Collection of additional X509Certificates that could be helpful for
    # path building.
    # <p>
    # Parameter is an additional parameter with variant specific meaning.
    # Currently, it is only defined for TLS_SERVER variant validators, where
    # it must be non null and the name of the TLS key exchange algorithm being
    # used (see JSSE X509TrustManager specification). In the future, it
    # could be used to pass in a PKCS#7 object for code signing to check time
    # stamps.
    # <p>
    # @return a non-empty chain that was used to validate the path. The
    # end entity cert is at index 0, the trust anchor at index n-1.
    def validate(chain, other_certs, parameter)
      chain = engine_validate(chain, other_certs, parameter)
      # omit EE extension check if EE cert is also trust anchor
      if (chain.attr_length > 1)
        @end_entity_checker.check(chain[0], parameter)
      end
      return chain
    end
    
    typesig { [Array.typed(X509Certificate), Collection, Object] }
    def engine_validate(chain, other_certs, parameter)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an immutable Collection of the X509Certificates this instance
    # uses as trust anchors.
    def get_trusted_certificates
      raise NotImplementedError
    end
    
    typesig { [JavaDate] }
    # Set the date to be used for subsequent validations. NOTE that
    # this is not a supported API, it is provided to simplify
    # writing tests only.
    # 
    # @deprecated
    def set_validation_date(validation_date)
      @validation_date = validation_date
    end
    
    private
    alias_method :initialize__validator, :initialize
  end
  
end
