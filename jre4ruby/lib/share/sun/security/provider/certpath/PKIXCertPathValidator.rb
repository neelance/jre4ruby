require "rjava"

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
  module PKIXCertPathValidatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :Security
      include_const ::Java::Security::Cert, :CertPath
      include_const ::Java::Security::Cert, :CertPathParameters
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :CertPathValidatorSpi
      include_const ::Java::Security::Cert, :CertPathValidatorResult
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :PKIXCertPathValidatorResult
      include_const ::Java::Security::Cert, :PKIXParameters
      include_const ::Java::Security::Cert, :PolicyNode
      include_const ::Java::Security::Cert, :TrustAnchor
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :X509CertSelector
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :HashSet
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # This class implements the PKIX validation algorithm for certification
  # paths consisting exclusively of <code>X509Certificates</code>. It uses
  # the specified input parameter set (which must be a
  # <code>PKIXParameters</code> object) and signature provider (if any).
  # 
  # @since       1.4
  # @author      Yassir Elley
  class PKIXCertPathValidator < PKIXCertPathValidatorImports.const_get :CertPathValidatorSpi
    include_class_members PKIXCertPathValidatorImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :test_date
    alias_method :attr_test_date, :test_date
    undef_method :test_date
    alias_method :attr_test_date=, :test_date=
    undef_method :test_date=
    
    attr_accessor :user_checkers
    alias_method :attr_user_checkers, :user_checkers
    undef_method :user_checkers
    alias_method :attr_user_checkers=, :user_checkers=
    undef_method :user_checkers=
    
    attr_accessor :sig_provider
    alias_method :attr_sig_provider, :sig_provider
    undef_method :sig_provider
    alias_method :attr_sig_provider=, :sig_provider=
    undef_method :sig_provider=
    
    attr_accessor :basic_checker
    alias_method :attr_basic_checker, :basic_checker
    undef_method :basic_checker
    alias_method :attr_basic_checker=, :basic_checker=
    undef_method :basic_checker=
    
    typesig { [] }
    # Default constructor.
    def initialize
      @test_date = nil
      @user_checkers = nil
      @sig_provider = nil
      @basic_checker = nil
      super()
    end
    
    typesig { [CertPath, CertPathParameters] }
    # Validates a certification path consisting exclusively of
    # <code>X509Certificate</code>s using the PKIX validation algorithm,
    # which uses the specified input parameter set.
    # The input parameter set must be a <code>PKIXParameters</code> object.
    # 
    # @param cp the X509 certification path
    # @param param the input PKIX parameter set
    # @return the result
    # @exception CertPathValidatorException Exception thrown if cert path
    # does not validate.
    # @exception InvalidAlgorithmParameterException if the specified
    # parameters are inappropriate for this certification path validator
    def engine_validate(cp, param)
      if (!(Debug).nil?)
        Debug.println("PKIXCertPathValidator.engineValidate()...")
      end
      if (!(param.is_a?(PKIXParameters)))
        raise InvalidAlgorithmParameterException.new("inappropriate " + "parameters, must be an instance of PKIXParameters")
      end
      if (!(cp.get_type == "X.509") && !(cp.get_type == "X509"))
        raise InvalidAlgorithmParameterException.new("inappropriate " + "certification path type specified, must be X.509 or X509")
      end
      pkix_param = param
      # Make sure that none of the trust anchors include name constraints
      # (not supported).
      anchors = pkix_param.get_trust_anchors
      anchors.each do |anchor|
        if (!(anchor.get_name_constraints).nil?)
          raise InvalidAlgorithmParameterException.new("name constraints in trust anchor not supported")
        end
      end
      # the certpath which has been passed in (cp)
      # has the target cert as the first certificate - we
      # need to keep this cp so we can return it
      # in case of an exception and for policy qualifier
      # processing - however, for certpath validation,
      # we need to create a reversed path, where we reverse the
      # ordering so that the target cert is the last certificate
      # Must copy elements of certList into a new modifiable List before
      # calling Collections.reverse().
      cert_list = ArrayList.new(cp.get_certificates)
      if (!(Debug).nil?)
        if (cert_list.is_empty)
          Debug.println("PKIXCertPathValidator.engineValidate() " + "certList is empty")
        end
        Debug.println("PKIXCertPathValidator.engineValidate() " + "reversing certpath...")
      end
      Collections.reverse(cert_list)
      # now certList has the target cert as the last cert and we
      # can proceed with normal validation
      populate_variables(pkix_param)
      # Retrieve the first certificate in the certpath
      # (to be used later in pre-screening)
      first_cert = nil
      if (!cert_list.is_empty)
        first_cert = cert_list.get(0)
      end
      last_exception = nil
      # We iterate through the set of trust anchors until we find
      # one that works at which time we stop iterating
      anchors.each do |anchor|
        trusted_cert = anchor.get_trusted_cert
        if (!(trusted_cert).nil?)
          if (!(Debug).nil?)
            Debug.println("PKIXCertPathValidator.engineValidate() " + "anchor.getTrustedCert() != null")
          end
          # if this trust anchor is not worth trying,
          # we move on to the next one
          if (!is_worth_trying(trusted_cert, first_cert))
            next
          end
          if (!(Debug).nil?)
            Debug.println("anchor.getTrustedCert()." + "getSubjectX500Principal() = " + RJava.cast_to_string(trusted_cert.get_subject_x500principal))
          end
        else
          if (!(Debug).nil?)
            Debug.println("PKIXCertPathValidator.engineValidate(): " + "anchor.getTrustedCert() == null")
          end
        end
        begin
          root_node = PolicyNodeImpl.new(nil, PolicyChecker::ANY_POLICY, nil, false, Collections.singleton(PolicyChecker::ANY_POLICY), false)
          policy_tree = do_validate(anchor, cp, cert_list, pkix_param, root_node)
          # if this anchor works, return success
          return PKIXCertPathValidatorResult.new(anchor, policy_tree, @basic_checker.get_public_key)
        rescue CertPathValidatorException => cpe
          # remember this exception
          last_exception = cpe
        end
      end
      # could not find a trust anchor that verified
      # (a) if we did a validation and it failed, use that exception
      if (!(last_exception).nil?)
        raise last_exception
      end
      # (b) otherwise, generate new exception
      raise CertPathValidatorException.new("Path does not chain with any of the trust anchors")
    end
    
    typesig { [X509Certificate, X509Certificate] }
    # Internal method to do some simple checks to see if a given cert is
    # worth trying to validate in the chain.
    def is_worth_trying(trusted_cert, first_cert)
      if (!(Debug).nil?)
        Debug.println("PKIXCertPathValidator.isWorthTrying() checking " + "if this trusted cert is worth trying ...")
      end
      if ((first_cert).nil?)
        return true
      end
      # the subject of the trusted cert should match the
      # issuer of the first cert in the certpath
      trusted_subject = trusted_cert.get_subject_x500principal
      if ((trusted_subject == first_cert.get_issuer_x500principal))
        if (!(Debug).nil?)
          Debug.println("YES - try this trustedCert")
        end
        return true
      else
        if (!(Debug).nil?)
          Debug.println("NO - don't try this trustedCert")
        end
        return false
      end
    end
    
    typesig { [PKIXParameters] }
    # Internal method to setup the internal state
    def populate_variables(pkix_param)
      # default value for testDate is current time
      @test_date = pkix_param.get_date
      if ((@test_date).nil?)
        @test_date = JavaDate.new(System.current_time_millis)
      end
      @user_checkers = pkix_param.get_cert_path_checkers
      @sig_provider = RJava.cast_to_string(pkix_param.get_sig_provider)
    end
    
    typesig { [TrustAnchor, CertPath, JavaList, PKIXParameters, PolicyNodeImpl] }
    # Internal method to actually validate a constructed path.
    # 
    # @return the valid policy tree
    def do_validate(anchor, cp_original, cert_list, pkix_param, root_node)
      cert_path_checkers = ArrayList.new
      cert_path_len = cert_list.size
      @basic_checker = BasicChecker.new(anchor, @test_date, @sig_provider, false)
      key_checker = KeyChecker.new(cert_path_len, pkix_param.get_target_cert_constraints)
      constraints_checker = ConstraintsChecker.new(cert_path_len)
      policy_checker = PolicyChecker.new(pkix_param.get_initial_policies, cert_path_len, pkix_param.is_explicit_policy_required, pkix_param.is_policy_mapping_inhibited, pkix_param.is_any_policy_inhibited, pkix_param.get_policy_qualifiers_rejected, root_node)
      # add standard checkers that we will be using
      cert_path_checkers.add(key_checker)
      cert_path_checkers.add(constraints_checker)
      cert_path_checkers.add(policy_checker)
      cert_path_checkers.add(@basic_checker)
      # only add a revocationChecker if revocation is enabled
      if (pkix_param.is_revocation_enabled)
        ocsp_property = AccessController.do_privileged(# Examine OCSP security property
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members PKIXCertPathValidator
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Security.get_property(OCSPChecker::OCSP_ENABLE_PROP)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # Use OCSP if it has been enabled
        if ("true".equals_ignore_case(ocsp_property))
          ocsp_checker = OCSPChecker.new(cp_original, pkix_param)
          cert_path_checkers.add(ocsp_checker)
        end
        # Always use CRLs
        revocation_checker = CrlRevocationChecker.new(anchor, pkix_param, cert_list)
        cert_path_checkers.add(revocation_checker)
      end
      # add user-specified checkers
      cert_path_checkers.add_all(@user_checkers)
      master_validator = PKIXMasterCertPathValidator.new(cert_path_checkers)
      master_validator.validate(cp_original, cert_list)
      return policy_checker.get_policy_tree
    end
    
    private
    alias_method :initialize__pkixcert_path_validator, :initialize
  end
  
end
