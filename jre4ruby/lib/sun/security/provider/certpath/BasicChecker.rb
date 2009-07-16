require "rjava"

# 
# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider::Certpath
  module BasicCheckerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Security, :KeyFactory
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :TrustAnchor
      include_const ::Java::Security::Interfaces, :DSAParams
      include_const ::Java::Security::Interfaces, :DSAPublicKey
      include_const ::Java::Security::Spec, :DSAPublicKeySpec
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # 
  # BasicChecker is a PKIXCertPathChecker that checks the basic information
  # on a PKIX certificate, namely the signature, timestamp, and subject/issuer
  # name chaining.
  # 
  # @since       1.4
  # @author      Yassir Elley
  class BasicChecker < BasicCheckerImports.const_get :PKIXCertPathChecker
    include_class_members BasicCheckerImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :trusted_pub_key
    alias_method :attr_trusted_pub_key, :trusted_pub_key
    undef_method :trusted_pub_key
    alias_method :attr_trusted_pub_key=, :trusted_pub_key=
    undef_method :trusted_pub_key=
    
    attr_accessor :ca_name
    alias_method :attr_ca_name, :ca_name
    undef_method :ca_name
    alias_method :attr_ca_name=, :ca_name=
    undef_method :ca_name=
    
    attr_accessor :test_date
    alias_method :attr_test_date, :test_date
    undef_method :test_date
    alias_method :attr_test_date=, :test_date=
    undef_method :test_date=
    
    attr_accessor :sig_provider
    alias_method :attr_sig_provider, :sig_provider
    undef_method :sig_provider
    alias_method :attr_sig_provider=, :sig_provider=
    undef_method :sig_provider=
    
    attr_accessor :sig_only
    alias_method :attr_sig_only, :sig_only
    undef_method :sig_only
    alias_method :attr_sig_only=, :sig_only=
    undef_method :sig_only=
    
    attr_accessor :prev_subject
    alias_method :attr_prev_subject, :prev_subject
    undef_method :prev_subject
    alias_method :attr_prev_subject=, :prev_subject=
    undef_method :prev_subject=
    
    attr_accessor :prev_pub_key
    alias_method :attr_prev_pub_key, :prev_pub_key
    undef_method :prev_pub_key
    alias_method :attr_prev_pub_key=, :prev_pub_key=
    undef_method :prev_pub_key=
    
    typesig { [TrustAnchor, Date, String, ::Java::Boolean] }
    # 
    # Constructor that initializes the input parameters.
    # 
    # @param anchor the anchor selected to validate the target certificate
    # @param testDate the time for which the validity of the certificate
    # should be determined
    # @param sigProvider the name of the signature provider
    # @param sigOnly true if only signature checking is to be done;
    # if false, all checks are done
    def initialize(anchor, test_date, sig_provider, sig_only)
      @trusted_pub_key = nil
      @ca_name = nil
      @test_date = nil
      @sig_provider = nil
      @sig_only = false
      @prev_subject = nil
      @prev_pub_key = nil
      super()
      if (!(anchor.get_trusted_cert).nil?)
        @trusted_pub_key = anchor.get_trusted_cert.get_public_key
        @ca_name = anchor.get_trusted_cert.get_subject_x500principal
      else
        @trusted_pub_key = anchor.get_capublic_key
        @ca_name = anchor.get_ca
      end
      @test_date = test_date
      @sig_provider = sig_provider
      @sig_only = sig_only
      init(false)
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Initializes the internal state of the checker from parameters
    # specified in the constructor.
    def init(forward)
      if (!forward)
        @prev_pub_key = @trusted_pub_key
        @prev_subject = @ca_name
      else
        raise CertPathValidatorException.new("forward checking not supported")
      end
    end
    
    typesig { [] }
    def is_forward_checking_supported
      return false
    end
    
    typesig { [] }
    def get_supported_extensions
      return nil
    end
    
    typesig { [Certificate, Collection] }
    # 
    # Performs the signature, timestamp, and subject/issuer name chaining
    # checks on the certificate using its internal state. This method does
    # not remove any critical extensions from the Collection.
    # 
    # @param cert the Certificate
    # @param unresolvedCritExts a Collection of the unresolved critical
    # extensions
    # @exception CertPathValidatorException Exception thrown if certificate
    # does not verify.
    def check(cert, unresolved_crit_exts)
      curr_cert = cert
      if (!@sig_only)
        verify_timestamp(curr_cert, @test_date)
        verify_name_chaining(curr_cert, @prev_subject)
      end
      verify_signature(curr_cert, @prev_pub_key, @sig_provider)
      update_state(curr_cert)
    end
    
    typesig { [X509Certificate, PublicKey, String] }
    # 
    # Verifies the signature on the certificate using the previous public key
    # @param cert the Certificate
    # @param prevPubKey the previous PublicKey
    # @param sigProvider a String containing the signature provider
    # @exception CertPathValidatorException Exception thrown if certificate
    # does not verify.
    def verify_signature(cert, prev_pub_key, sig_provider)
      msg = "signature"
      if (!(Debug).nil?)
        Debug.println("---checking " + msg + "...")
      end
      begin
        cert.verify(prev_pub_key, sig_provider)
      rescue Exception => e
        if (!(Debug).nil?)
          Debug.println(e.get_message)
          e.print_stack_trace
        end
        raise CertPathValidatorException.new(msg + " check failed", e)
      end
      if (!(Debug).nil?)
        Debug.println(msg + " verified.")
      end
    end
    
    typesig { [X509Certificate, Date] }
    # 
    # Internal method to verify the timestamp on a certificate
    def verify_timestamp(cert, date)
      msg = "timestamp"
      if (!(Debug).nil?)
        Debug.println("---checking " + msg + ":" + (date.to_s).to_s + "...")
      end
      begin
        cert.check_validity(date)
      rescue Exception => e
        if (!(Debug).nil?)
          Debug.println(e.get_message)
          e.print_stack_trace
        end
        raise CertPathValidatorException.new(msg + " check failed", e)
      end
      if (!(Debug).nil?)
        Debug.println(msg + " verified.")
      end
    end
    
    typesig { [X509Certificate, X500Principal] }
    # 
    # Internal method to check that cert has a valid DN to be next in a chain
    def verify_name_chaining(cert, prev_subject)
      if (!(prev_subject).nil?)
        msg = "subject/issuer name chaining"
        if (!(Debug).nil?)
          Debug.println("---checking " + msg + "...")
        end
        curr_issuer = cert.get_issuer_x500principal
        # reject null or empty issuer DNs
        if (X500Name.as_x500name(curr_issuer).is_empty)
          raise CertPathValidatorException.new(msg + " check failed: " + "empty/null issuer DN in certificate is invalid")
        end
        if (!((curr_issuer == prev_subject)))
          raise CertPathValidatorException.new(msg + " check failed")
        end
        if (!(Debug).nil?)
          Debug.println(msg + " verified.")
        end
      end
    end
    
    typesig { [X509Certificate] }
    # 
    # Internal method to manage state information at each iteration
    def update_state(curr_cert)
      c_key = curr_cert.get_public_key
      if (!(Debug).nil?)
        Debug.println("BasicChecker.updateState issuer: " + (curr_cert.get_issuer_x500principal.to_s).to_s + "; subject: " + (curr_cert.get_subject_x500principal).to_s + "; serial#: " + (curr_cert.get_serial_number.to_s).to_s)
      end
      if (c_key.is_a?(DSAPublicKey) && ((c_key).get_params).nil?)
        # cKey needs to inherit DSA parameters from prev key
        c_key = make_inherited_params_key(c_key, @prev_pub_key)
        if (!(Debug).nil?)
          Debug.println("BasicChecker.updateState Made " + "key with inherited params")
        end
      end
      @prev_pub_key = c_key
      @prev_subject = curr_cert.get_subject_x500principal
    end
    
    class_module.module_eval {
      typesig { [PublicKey, PublicKey] }
      # 
      # Internal method to create a new key with inherited key parameters
      # 
      # @param keyValueKey key from which to obtain key value
      # @param keyParamsKey key from which to obtain key parameters
      # @return new public key having value and parameters
      # @throws CertPathValidatorException if keys are not appropriate types
      # for this operation
      def make_inherited_params_key(key_value_key, key_params_key)
        usable_key = nil
        if (!(key_value_key.is_a?(DSAPublicKey)) || !(key_params_key.is_a?(DSAPublicKey)))
          raise CertPathValidatorException.new("Input key is not " + "appropriate type for " + "inheriting parameters")
        end
        params = (key_params_key).get_params
        if ((params).nil?)
          raise CertPathValidatorException.new("Key parameters missing")
        end
        begin
          y = (key_value_key).get_y
          kf = KeyFactory.get_instance("DSA")
          ks = DSAPublicKeySpec.new(y, params.get_p, params.get_q, params.get_g)
          usable_key = kf.generate_public(ks)
        rescue Exception => e
          raise CertPathValidatorException.new("Unable to generate key with" + " inherited parameters: " + (e.get_message).to_s, e)
        end
        return usable_key
      end
    }
    
    typesig { [] }
    # 
    # return the public key associated with the last certificate processed
    # 
    # @return PublicKey the last public key processed
    def get_public_key
      return @prev_pub_key
    end
    
    private
    alias_method :initialize__basic_checker, :initialize
  end
  
end
