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
  module PKIXValidatorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Validator
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Cert
      include_const ::Javax::Security::Auth::X500, :X500Principal
    }
  end
  
  # Validator implementation built on the PKIX CertPath API. This
  # implementation will be emphasized going forward.<p>
  # 
  # Note that the validate() implementation tries to use a PKIX validator
  # if that appears possible and a PKIX builder otherwise. This increases
  # performance and currently also leads to better exception messages
  # in case of failures.
  # 
  # @author Andreas Sterbenz
  class PKIXValidator < PKIXValidatorImports.const_get :Validator
    include_class_members PKIXValidatorImports
    
    class_module.module_eval {
      # enable use of the validator if possible
      const_set_lazy(:TRY_VALIDATOR) { true }
      const_attr_reader  :TRY_VALIDATOR
    }
    
    attr_accessor :trusted_certs
    alias_method :attr_trusted_certs, :trusted_certs
    undef_method :trusted_certs
    alias_method :attr_trusted_certs=, :trusted_certs=
    undef_method :trusted_certs=
    
    attr_accessor :parameter_template
    alias_method :attr_parameter_template, :parameter_template
    undef_method :parameter_template
    alias_method :attr_parameter_template=, :parameter_template=
    undef_method :parameter_template=
    
    attr_accessor :cert_path_length
    alias_method :attr_cert_path_length, :cert_path_length
    undef_method :cert_path_length
    alias_method :attr_cert_path_length=, :cert_path_length=
    undef_method :cert_path_length=
    
    # needed only for the validator
    attr_accessor :trusted_subjects
    alias_method :attr_trusted_subjects, :trusted_subjects
    undef_method :trusted_subjects
    alias_method :attr_trusted_subjects=, :trusted_subjects=
    undef_method :trusted_subjects=
    
    attr_accessor :factory
    alias_method :attr_factory, :factory
    undef_method :factory
    alias_method :attr_factory=, :factory=
    undef_method :factory=
    
    attr_accessor :plugin
    alias_method :attr_plugin, :plugin
    undef_method :plugin
    alias_method :attr_plugin=, :plugin=
    undef_method :plugin=
    
    typesig { [String, Collection] }
    def initialize(variant, trusted_certs)
      @trusted_certs = nil
      @parameter_template = nil
      @cert_path_length = 0
      @trusted_subjects = nil
      @factory = nil
      @plugin = false
      super(TYPE_PKIX, variant)
      @cert_path_length = -1
      @plugin = false
      if (trusted_certs.is_a?(JavaSet))
        @trusted_certs = trusted_certs
      else
        @trusted_certs = HashSet.new(trusted_certs)
      end
      trust_anchors = HashSet.new
      trusted_certs.each do |cert|
        trust_anchors.add(TrustAnchor.new(cert, nil))
      end
      begin
        @parameter_template = PKIXBuilderParameters.new(trust_anchors, nil)
      rescue InvalidAlgorithmParameterException => e
        raise RuntimeException.new("Unexpected error: " + (e.to_s).to_s, e)
      end
      set_default_parameters(variant)
      init_common
    end
    
    typesig { [String, PKIXBuilderParameters] }
    def initialize(variant, params)
      @trusted_certs = nil
      @parameter_template = nil
      @cert_path_length = 0
      @trusted_subjects = nil
      @factory = nil
      @plugin = false
      super(TYPE_PKIX, variant)
      @cert_path_length = -1
      @plugin = false
      @trusted_certs = HashSet.new
      params.get_trust_anchors.each do |anchor|
        cert = anchor.get_trusted_cert
        if (!(cert).nil?)
          @trusted_certs.add(cert)
        end
      end
      @parameter_template = params
      init_common
    end
    
    typesig { [] }
    def init_common
      if ((TRY_VALIDATOR).equal?(false))
        return
      end
      @trusted_subjects = HashMap.new
      @trusted_certs.each do |cert|
        @trusted_subjects.put(cert.get_subject_x500principal, cert)
      end
      begin
        @factory = CertificateFactory.get_instance("X.509")
      rescue CertificateException => e
        raise RuntimeException.new("Internal error", e)
      end
      @plugin = (self.attr_variant == VAR_PLUGIN_CODE_SIGNING)
    end
    
    typesig { [] }
    def get_trusted_certificates
      return @trusted_certs
    end
    
    typesig { [] }
    # Returns the length of the last certification path that is validated by
    # CertPathValidator. This is intended primarily as a callback mechanism
    # for PKIXCertPathCheckers to determine the length of the certification
    # path that is being validated. It is necessary since engineValidate()
    # may modify the length of the path.
    # 
    # @return the length of the last certification path passed to
    # CertPathValidator.validate, or -1 if it has not been invoked yet
    def get_cert_path_length
      return @cert_path_length
    end
    
    typesig { [String] }
    # Set J2SE global default PKIX parameters. Currently, hardcoded to disable
    # revocation checking. In the future, this should be configurable.
    def set_default_parameters(variant)
      @parameter_template.set_revocation_enabled(false)
    end
    
    typesig { [] }
    # Return the PKIX parameters used by this instance. An application may
    # modify the parameters but must make sure not to perform any concurrent
    # validations.
    def get_parameters
      return @parameter_template
    end
    
    typesig { [Array.typed(X509Certificate), Collection, Object] }
    def engine_validate(chain, other_certs, parameter)
      if (((chain).nil?) || ((chain.attr_length).equal?(0)))
        raise CertificateException.new("null or zero-length certificate chain")
      end
      if (TRY_VALIDATOR)
        # check if chain contains trust anchor
        i = 0
        while i < chain.attr_length
          if (@trusted_certs.contains(chain[i]))
            if ((i).equal?(0))
              return Array.typed(X509Certificate).new([chain[0]])
            end
            # Remove and call validator
            new_chain = Array.typed(X509Certificate).new(i) { nil }
            System.arraycopy(chain, 0, new_chain, 0, i)
            return do_validate(new_chain)
          end
          i += 1
        end
        # not self issued and apparently issued by trust anchor?
        last = chain[chain.attr_length - 1]
        issuer = last.get_issuer_x500principal
        subject = last.get_subject_x500principal
        if (@trusted_subjects.contains_key(issuer) && !(issuer == subject) && is_signature_valid(@trusted_subjects.get(issuer), last))
          return do_validate(chain)
        end
        # don't fallback to builder if called from plugin/webstart
        if (@plugin)
          # Validate chain even if no trust anchor is found. This
          # allows plugin/webstart to make sure the chain is
          # otherwise valid
          if (chain.attr_length > 1)
            new_chain = Array.typed(X509Certificate).new(chain.attr_length - 1) { nil }
            System.arraycopy(chain, 0, new_chain, 0, new_chain.attr_length)
            # temporarily set last cert as sole trust anchor
            params = @parameter_template.clone
            begin
              params.set_trust_anchors(Collections.singleton(TrustAnchor.new(chain[chain.attr_length - 1], nil)))
            rescue InvalidAlgorithmParameterException => iape
              # should never occur, but ...
              raise CertificateException.new(iape)
            end
            do_validate(new_chain, params)
          end
          # if the rest of the chain is valid, throw exception
          # indicating no trust anchor was found
          raise ValidatorException.new(ValidatorException::T_NO_TRUST_ANCHOR)
        end
        # otherwise, fall back to builder
      end
      return do_build(chain, other_certs)
    end
    
    typesig { [X509Certificate, X509Certificate] }
    def is_signature_valid(iss, sub)
      if (@plugin)
        begin
          sub.verify(iss.get_public_key)
        rescue Exception => ex
          return false
        end
        return true
      end
      return true # only check if PLUGIN is set
    end
    
    class_module.module_eval {
      typesig { [CertPath, TrustAnchor] }
      def to_array(path, anchor)
        list = path.get_certificates
        chain = Array.typed(X509Certificate).new(list.size + 1) { nil }
        list.to_array(chain)
        trusted_cert = anchor.get_trusted_cert
        if ((trusted_cert).nil?)
          raise ValidatorException.new("TrustAnchor must be specified as certificate")
        end
        chain[chain.attr_length - 1] = trusted_cert
        return chain
      end
    }
    
    typesig { [PKIXBuilderParameters] }
    # Set the check date (for debugging).
    def set_date(params)
      date = self.attr_validation_date
      if (!(date).nil?)
        params.set_date(date)
      end
    end
    
    typesig { [Array.typed(X509Certificate)] }
    def do_validate(chain)
      params = @parameter_template.clone
      return do_validate(chain, params)
    end
    
    typesig { [Array.typed(X509Certificate), PKIXBuilderParameters] }
    def do_validate(chain, params)
      begin
        set_date(params)
        # do the validation
        validator = CertPathValidator.get_instance("PKIX")
        path = @factory.generate_cert_path(Arrays.as_list(chain))
        @cert_path_length = chain.attr_length
        result = validator.validate(path, params)
        return to_array(path, result.get_trust_anchor)
      rescue GeneralSecurityException => e
        raise ValidatorException.new("PKIX path validation failed: " + (e.to_s).to_s, e)
      end
    end
    
    typesig { [Array.typed(X509Certificate), Collection] }
    def do_build(chain, other_certs)
      begin
        params = @parameter_template.clone
        set_date(params)
        # setup target constraints
        selector = X509CertSelector.new
        selector.set_certificate(chain[0])
        params.set_target_cert_constraints(selector)
        # setup CertStores
        certs = ArrayList.new
        certs.add_all(Arrays.as_list(chain))
        if (!(other_certs).nil?)
          certs.add_all(other_certs)
        end
        store = CertStore.get_instance("Collection", CollectionCertStoreParameters.new(certs))
        params.add_cert_store(store)
        # do the build
        builder = CertPathBuilder.get_instance("PKIX")
        result = builder.build(params)
        return to_array(result.get_cert_path, result.get_trust_anchor)
      rescue GeneralSecurityException => e
        raise ValidatorException.new("PKIX path building failed: " + (e.to_s).to_s, e)
      end
    end
    
    private
    alias_method :initialize__pkixvalidator, :initialize
  end
  
end
