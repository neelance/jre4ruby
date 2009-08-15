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
module Sun::Security::Provider::Certpath
  module ReverseBuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :Principal
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :CertStore
      include_const ::Java::Security::Cert, :CertStoreException
      include_const ::Java::Security::Cert, :PKIXBuilderParameters
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :PKIXParameters
      include_const ::Java::Security::Cert, :TrustAnchor
      include_const ::Java::Security::Cert, :X509CertSelector
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaSet
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :Extension
      include_const ::Sun::Security::X509, :PKIXExtensions
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::X509, :X509CertImpl
      include_const ::Sun::Security::X509, :PolicyMappingsExtension
    }
  end
  
  # This class represents a reverse builder, which is able to retrieve
  # matching certificates from CertStores and verify a particular certificate
  # against a ReverseState.
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  class ReverseBuilder < ReverseBuilderImports.const_get :Builder
    include_class_members ReverseBuilderImports
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    attr_accessor :init_policies
    alias_method :attr_init_policies, :init_policies
    undef_method :init_policies
    alias_method :attr_init_policies=, :init_policies=
    undef_method :init_policies=
    
    typesig { [PKIXBuilderParameters, X500Principal] }
    # Initialize the builder with the input parameters.
    # 
    # @param params the parameter set used to build a certification path
    def initialize(build_params, target_subject_dn)
      @debug = nil
      @init_policies = nil
      super(build_params, target_subject_dn)
      @debug = Debug.get_instance("certpath")
      initial_policies = build_params.get_initial_policies
      @init_policies = HashSet.new
      if (initial_policies.is_empty)
        # if no initialPolicies are specified by user, set
        # initPolicies to be anyPolicy by default
        @init_policies.add(PolicyChecker::ANY_POLICY)
      else
        initial_policies.each do |policy|
          @init_policies.add(policy)
        end
      end
    end
    
    typesig { [State, JavaList] }
    # Retrieves all certs from the specified CertStores that satisfy the
    # requirements specified in the parameters and the current
    # PKIX state (name constraints, policy constraints, etc).
    # 
    # @param currentState the current state.
    # Must be an instance of <code>ReverseState</code>
    # @param certStores list of CertStores
    def get_matching_certs(curr_state, cert_stores)
      current_state = curr_state
      if (!(@debug).nil?)
        @debug.println("In ReverseBuilder.getMatchingCerts.")
      end
      # The last certificate could be an EE or a CA certificate
      # (we may be building a partial certification path or
      # establishing trust in a CA).
      # 
      # Try the EE certs before the CA certs. It will be more
      # common to build a path to an end entity.
      certs = get_matching_eecerts(current_state, cert_stores)
      certs.add_all(get_matching_cacerts(current_state, cert_stores))
      return certs
    end
    
    typesig { [ReverseState, JavaList] }
    # Retrieves all end-entity certificates which satisfy constraints
    # and requirements specified in the parameters and PKIX state.
    def get_matching_eecerts(current_state, cert_stores)
      # Compose a CertSelector to filter out
      # certs which do not satisfy requirements.
      # 
      # First, retrieve clone of current target cert constraints,
      # and then add more selection criteria based on current validation state.
      sel = self.attr_target_cert_constraints.clone
      # Match on issuer (subject of previous cert)
      sel.set_issuer(current_state.attr_subject_dn)
      # Match on certificate validity date.
      sel.set_certificate_valid(self.attr_date)
      # Policy processing optimizations
      if ((current_state.attr_explicit_policy).equal?(0))
        sel.set_policy(get_matching_policies)
      end
      # If previous cert has a subject key identifier extension,
      # use it to match on authority key identifier extension.
      # 
      # if (currentState.subjKeyId != null) {
      # AuthorityKeyIdentifierExtension authKeyId = new AuthorityKeyIdentifierExtension(
      # (KeyIdentifier) currentState.subjKeyId.get(SubjectKeyIdentifierExtension.KEY_ID),
      # null, null);
      # sel.setAuthorityKeyIdentifier(authKeyId.getExtensionValue());
      # }
      # 
      # Require EE certs
      sel.set_basic_constraints(-2)
      # Retrieve matching certs from CertStores
      ee_certs = HashSet.new
      add_matching_certs(sel, cert_stores, ee_certs, true)
      if (!(@debug).nil?)
        @debug.println("ReverseBuilder.getMatchingEECerts got " + RJava.cast_to_string(ee_certs.size) + " certs.")
      end
      return ee_certs
    end
    
    typesig { [ReverseState, JavaList] }
    # Retrieves all CA certificates which satisfy constraints
    # and requirements specified in the parameters and PKIX state.
    def get_matching_cacerts(current_state, cert_stores)
      # Compose a CertSelector to filter out
      # certs which do not satisfy requirements.
      sel = X509CertSelector.new
      # Match on issuer (subject of previous cert)
      sel.set_issuer(current_state.attr_subject_dn)
      # Match on certificate validity date.
      sel.set_certificate_valid(self.attr_date)
      # Match on target subject name (checks that current cert's
      # name constraints permit it to certify target).
      # (4 is the integer type for DIRECTORY name).
      sel.add_path_to_name(4, self.attr_target_cert_constraints.get_subject_as_bytes)
      # Policy processing optimizations
      if ((current_state.attr_explicit_policy).equal?(0))
        sel.set_policy(get_matching_policies)
      end
      # If previous cert has a subject key identifier extension,
      # use it to match on authority key identifier extension.
      # 
      # if (currentState.subjKeyId != null) {
      # AuthorityKeyIdentifierExtension authKeyId = new AuthorityKeyIdentifierExtension(
      # (KeyIdentifier) currentState.subjKeyId.get(SubjectKeyIdentifierExtension.KEY_ID),
      # null, null);
      # sel.setAuthorityKeyIdentifier(authKeyId.getExtensionValue());
      # }
      # 
      # Require CA certs
      sel.set_basic_constraints(0)
      # Retrieve matching certs from CertStores
      reverse_certs = ArrayList.new
      add_matching_certs(sel, cert_stores, reverse_certs, true)
      # Sort remaining certs using name constraints
      Collections.sort(reverse_certs, PKIXCertComparator.new_local(self))
      if (!(@debug).nil?)
        @debug.println("ReverseBuilder.getMatchingCACerts got " + RJava.cast_to_string(reverse_certs.size) + " certs.")
      end
      return reverse_certs
    end
    
    class_module.module_eval {
      # This inner class compares 2 PKIX certificates according to which
      # should be tried first when building a path to the target. For
      # now, the algorithm is to look at name constraints in each cert and those
      # which constrain the path closer to the target should be
      # ranked higher. Later, we may want to consider other components,
      # such as key identifiers.
      const_set_lazy(:PKIXCertComparator) { Class.new do
        extend LocalClass
        include_class_members ReverseBuilder
        include Comparator
        
        attr_accessor :debug
        alias_method :attr_debug, :debug
        undef_method :debug
        alias_method :attr_debug=, :debug=
        undef_method :debug=
        
        typesig { [X509Certificate, X509Certificate] }
        def compare(cert1, cert2)
          # if either cert certifies the target, always
          # put at head of list.
          if ((cert1.get_subject_x500principal == self.attr_target_subject_dn))
            return -1
          end
          if ((cert2.get_subject_x500principal == self.attr_target_subject_dn))
            return 1
          end
          target_dist1 = 0
          target_dist2 = 0
          begin
            target_subject_name = X500Name.as_x500name(self.attr_target_subject_dn)
            target_dist1 = Builder.target_distance(nil, cert1, target_subject_name)
            target_dist2 = Builder.target_distance(nil, cert2, target_subject_name)
          rescue IOException => e
            if (!(@debug).nil?)
              @debug.println("IOException in call to Builder.targetDistance")
              e.print_stack_trace
            end
            raise ClassCastException.new("Invalid target subject distinguished name")
          end
          if ((target_dist1).equal?(target_dist2))
            return 0
          end
          if ((target_dist1).equal?(-1))
            return 1
          end
          if (target_dist1 < target_dist2)
            return -1
          end
          return 1
        end
        
        typesig { [] }
        def initialize
          @debug = Debug.get_instance("certpath")
        end
        
        private
        alias_method :initialize__pkixcert_comparator, :initialize
      end }
    }
    
    typesig { [X509Certificate, State, JavaList] }
    # Verifies a matching certificate.
    # 
    # This method executes any of the validation steps in the PKIX path validation
    # algorithm which were not satisfied via filtering out non-compliant
    # certificates with certificate matching rules.
    # 
    # If the last certificate is being verified (the one whose subject
    # matches the target subject, then the steps in Section 6.1.4 of the
    # Certification Path Validation algorithm are NOT executed,
    # regardless of whether or not the last cert is an end-entity
    # cert or not. This allows callers to certify CA certs as
    # well as EE certs.
    # 
    # @param cert the certificate to be verified
    # @param currentState the current state against which the cert is verified
    # @param certPathList the certPathList generated thus far
    def verify_cert(cert, curr_state, cert_path_list)
      if (!(@debug).nil?)
        @debug.println("ReverseBuilder.verifyCert(SN: " + RJava.cast_to_string(Debug.to_hex_string(cert.get_serial_number)) + "\n  Subject: " + RJava.cast_to_string(cert.get_subject_x500principal) + ")")
      end
      current_state = curr_state
      # we don't perform any validation of the trusted cert
      if (current_state.is_initial)
        return
      end
      # check for looping - abort a loop if
      # ((we encounter the same certificate twice) AND
      # ((policyMappingInhibited = true) OR (no policy mapping
      # extensions can be found between the occurences of the same
      # certificate)))
      # in order to facilitate the check to see if there are
      # any policy mapping extensions found between the occurences
      # of the same certificate, we reverse the certpathlist first
      if ((!(cert_path_list).nil?) && (!cert_path_list.is_empty))
        reverse_cert_list = ArrayList.new
        cert_path_list.each do |c|
          reverse_cert_list.add(0, c)
        end
        policy_mapping_found = false
        reverse_cert_list.each do |cpListCert|
          cp_list_cert_impl = X509CertImpl.to_impl(cp_list_cert)
          policy_mappings_ext = cp_list_cert_impl.get_policy_mappings_extension
          if (!(policy_mappings_ext).nil?)
            policy_mapping_found = true
          end
          if (!(@debug).nil?)
            @debug.println("policyMappingFound = " + RJava.cast_to_string(policy_mapping_found))
          end
          if ((cert == cp_list_cert))
            if ((self.attr_build_params.is_policy_mapping_inhibited) || (!policy_mapping_found))
              if (!(@debug).nil?)
                @debug.println("loop detected!!")
              end
              raise CertPathValidatorException.new("loop detected")
            end
          end
        end
      end
      # check if target cert
      final_cert = (cert.get_subject_x500principal == self.attr_target_subject_dn)
      # check if CA cert
      ca_cert = (!(cert.get_basic_constraints).equal?(-1) ? true : false)
      # if there are more certs to follow, verify certain constraints
      if (!final_cert)
        # check if CA cert
        if (!ca_cert)
          raise CertPathValidatorException.new("cert is NOT a CA cert")
        end
        # If the certificate was not self-issued, verify that
        # remainingCerts is greater than zero
        if ((current_state.attr_remaining_cacerts <= 0) && !X509CertImpl.is_self_issued(cert))
          raise CertPathValidatorException.new("pathLenConstraint violated, path too long")
        end
        # Check keyUsage extension (only if CA cert and not final cert)
        KeyChecker.verify_cakey_usage(cert)
      else
        # If final cert, check that it satisfies specified target
        # constraints
        if ((self.attr_target_cert_constraints.match(cert)).equal?(false))
          raise CertPathValidatorException.new("target certificate " + "constraints check failed")
        end
      end
      # Check revocation.
      if (self.attr_build_params.is_revocation_enabled)
        current_state.attr_crl_checker.check(cert, current_state.attr_pub_key, current_state.attr_crl_sign)
      end
      # Check name constraints if this is not a self-issued cert
      if (final_cert || !X509CertImpl.is_self_issued(cert))
        if (!(current_state.attr_nc).nil?)
          begin
            if (!current_state.attr_nc.verify(cert))
              raise CertPathValidatorException.new("name constraints check failed")
            end
          rescue IOException => ioe
            raise CertPathValidatorException.new(ioe)
          end
        end
      end
      # Check policy
      cert_impl = X509CertImpl.to_impl(cert)
      current_state.attr_root_node = PolicyChecker.process_policies(current_state.attr_cert_index, @init_policies, current_state.attr_explicit_policy, current_state.attr_policy_mapping, current_state.attr_inhibit_any_policy, self.attr_build_params.get_policy_qualifiers_rejected, current_state.attr_root_node, cert_impl, final_cert)
      # Check CRITICAL private extensions
      unresolved_crit_exts = cert.get_critical_extension_oids
      if ((unresolved_crit_exts).nil?)
        unresolved_crit_exts = Collections.empty_set
      end
      current_state.attr_user_checkers.each do |checker|
        checker.check(cert, unresolved_crit_exts)
      end
      # Look at the remaining extensions and remove any ones we have
      # already checked. If there are any left, throw an exception!
      if (!unresolved_crit_exts.is_empty)
        unresolved_crit_exts.remove(PKIXExtensions::BasicConstraints_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::NameConstraints_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::CertificatePolicies_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::PolicyMappings_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::PolicyConstraints_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::InhibitAnyPolicy_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::SubjectAlternativeName_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::KeyUsage_Id.to_s)
        unresolved_crit_exts.remove(PKIXExtensions::ExtendedKeyUsage_Id.to_s)
        if (!unresolved_crit_exts.is_empty)
          raise CertificateException.new("Unrecognized critical extension(s)")
        end
      end
      # Check signature.
      if (!(self.attr_build_params.get_sig_provider).nil?)
        cert.verify(current_state.attr_pub_key, self.attr_build_params.get_sig_provider)
      else
        cert.verify(current_state.attr_pub_key)
      end
    end
    
    typesig { [X509Certificate] }
    # Verifies whether the input certificate completes the path.
    # This checks whether the cert is the target certificate.
    # 
    # @param cert the certificate to test
    # @return a boolean value indicating whether the cert completes the path.
    def is_path_completed(cert)
      return (cert.get_subject_x500principal == self.attr_target_subject_dn)
    end
    
    typesig { [X509Certificate, LinkedList] }
    # Adds the certificate to the certPathList
    # 
    # @param cert the certificate to be added
    # @param certPathList the certification path list
    def add_cert_to_path(cert, cert_path_list)
      cert_path_list.add_last(cert)
    end
    
    typesig { [LinkedList] }
    # Removes final certificate from the certPathList
    # 
    # @param certPathList the certification path list
    def remove_final_cert_from_path(cert_path_list)
      cert_path_list.remove_last
    end
    
    private
    alias_method :initialize__reverse_builder, :initialize
  end
  
end
