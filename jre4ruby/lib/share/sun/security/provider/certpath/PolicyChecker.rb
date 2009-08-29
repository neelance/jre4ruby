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
  module PolicyCheckerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include ::Java::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :PolicyNode
      include_const ::Java::Security::Cert, :PolicyQualifierInfo
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :CertificatePoliciesExtension
      include_const ::Sun::Security::X509, :PolicyConstraintsExtension
      include_const ::Sun::Security::X509, :PolicyMappingsExtension
      include_const ::Sun::Security::X509, :CertificatePolicyMap
      include_const ::Sun::Security::X509, :PKIXExtensions
      include_const ::Sun::Security::X509, :PolicyInformation
      include_const ::Sun::Security::X509, :X509CertImpl
      include_const ::Sun::Security::X509, :InhibitAnyPolicyExtension
    }
  end
  
  # PolicyChecker is a <code>PKIXCertPathChecker</code> that checks policy
  # information on a PKIX certificate, namely certificate policies, policy
  # mappings, policy constraints and policy qualifiers.
  # 
  # @since       1.4
  # @author      Yassir Elley
  class PolicyChecker < PolicyCheckerImports.const_get :PKIXCertPathChecker
    include_class_members PolicyCheckerImports
    
    attr_accessor :init_policies
    alias_method :attr_init_policies, :init_policies
    undef_method :init_policies
    alias_method :attr_init_policies=, :init_policies=
    undef_method :init_policies=
    
    attr_accessor :cert_path_len
    alias_method :attr_cert_path_len, :cert_path_len
    undef_method :cert_path_len
    alias_method :attr_cert_path_len=, :cert_path_len=
    undef_method :cert_path_len=
    
    attr_accessor :exp_policy_required
    alias_method :attr_exp_policy_required, :exp_policy_required
    undef_method :exp_policy_required
    alias_method :attr_exp_policy_required=, :exp_policy_required=
    undef_method :exp_policy_required=
    
    attr_accessor :pol_mapping_inhibited
    alias_method :attr_pol_mapping_inhibited, :pol_mapping_inhibited
    undef_method :pol_mapping_inhibited
    alias_method :attr_pol_mapping_inhibited=, :pol_mapping_inhibited=
    undef_method :pol_mapping_inhibited=
    
    attr_accessor :any_policy_inhibited
    alias_method :attr_any_policy_inhibited, :any_policy_inhibited
    undef_method :any_policy_inhibited
    alias_method :attr_any_policy_inhibited=, :any_policy_inhibited=
    undef_method :any_policy_inhibited=
    
    attr_accessor :reject_policy_qualifiers
    alias_method :attr_reject_policy_qualifiers, :reject_policy_qualifiers
    undef_method :reject_policy_qualifiers
    alias_method :attr_reject_policy_qualifiers=, :reject_policy_qualifiers=
    undef_method :reject_policy_qualifiers=
    
    attr_accessor :root_node
    alias_method :attr_root_node, :root_node
    undef_method :root_node
    alias_method :attr_root_node=, :root_node=
    undef_method :root_node=
    
    attr_accessor :explicit_policy
    alias_method :attr_explicit_policy, :explicit_policy
    undef_method :explicit_policy
    alias_method :attr_explicit_policy=, :explicit_policy=
    undef_method :explicit_policy=
    
    attr_accessor :policy_mapping
    alias_method :attr_policy_mapping, :policy_mapping
    undef_method :policy_mapping
    alias_method :attr_policy_mapping=, :policy_mapping=
    undef_method :policy_mapping=
    
    attr_accessor :inhibit_any_policy
    alias_method :attr_inhibit_any_policy, :inhibit_any_policy
    undef_method :inhibit_any_policy
    alias_method :attr_inhibit_any_policy=, :inhibit_any_policy=
    undef_method :inhibit_any_policy=
    
    attr_accessor :cert_index
    alias_method :attr_cert_index, :cert_index
    undef_method :cert_index
    alias_method :attr_cert_index=, :cert_index=
    undef_method :cert_index=
    
    class_module.module_eval {
      
      def supported_exts
        defined?(@@supported_exts) ? @@supported_exts : @@supported_exts= nil
      end
      alias_method :attr_supported_exts, :supported_exts
      
      def supported_exts=(value)
        @@supported_exts = value
      end
      alias_method :attr_supported_exts=, :supported_exts=
      
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      const_set_lazy(:ANY_POLICY) { "2.5.29.32.0" }
      const_attr_reader  :ANY_POLICY
    }
    
    typesig { [JavaSet, ::Java::Int, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, PolicyNodeImpl] }
    # Constructs a Policy Checker.
    # 
    # @param initialPolicies Set of initial policies
    # @param certPathLen length of the certification path to be checked
    # @param expPolicyRequired true if explicit policy is required
    # @param polMappingInhibited true if policy mapping is inhibited
    # @param anyPolicyInhibited true if the ANY_POLICY OID should be inhibited
    # @param rejectPolicyQualifiers true if pol qualifiers are to be rejected
    # @param rootNode the initial root node of the valid policy tree
    def initialize(initial_policies, cert_path_len, exp_policy_required, pol_mapping_inhibited, any_policy_inhibited, reject_policy_qualifiers, root_node)
      @init_policies = nil
      @cert_path_len = 0
      @exp_policy_required = false
      @pol_mapping_inhibited = false
      @any_policy_inhibited = false
      @reject_policy_qualifiers = false
      @root_node = nil
      @explicit_policy = 0
      @policy_mapping = 0
      @inhibit_any_policy = 0
      @cert_index = 0
      super()
      if (initial_policies.is_empty)
        # if no initialPolicies are specified by user, set
        # initPolicies to be anyPolicy by default
        @init_policies = HashSet.new(1)
        @init_policies.add(ANY_POLICY)
      else
        @init_policies = HashSet.new(initial_policies)
      end
      @cert_path_len = cert_path_len
      @exp_policy_required = exp_policy_required
      @pol_mapping_inhibited = pol_mapping_inhibited
      @any_policy_inhibited = any_policy_inhibited
      @reject_policy_qualifiers = reject_policy_qualifiers
      @root_node = root_node
      init(false)
    end
    
    typesig { [::Java::Boolean] }
    # Initializes the internal state of the checker from parameters
    # specified in the constructor
    # 
    # @param forward a boolean indicating whether this checker should
    # be initialized capable of building in the forward direction
    # @exception CertPathValidatorException Exception thrown if user
    # wants to enable forward checking and forward checking is not supported.
    def init(forward)
      if (forward)
        raise CertPathValidatorException.new("forward checking not supported")
      end
      @cert_index = 1
      @explicit_policy = (@exp_policy_required ? 0 : @cert_path_len + 1)
      @policy_mapping = (@pol_mapping_inhibited ? 0 : @cert_path_len + 1)
      @inhibit_any_policy = (@any_policy_inhibited ? 0 : @cert_path_len + 1)
    end
    
    typesig { [] }
    # Checks if forward checking is supported. Forward checking refers
    # to the ability of the PKIXCertPathChecker to perform its checks
    # when presented with certificates in the forward direction (from
    # target to anchor).
    # 
    # @return true if forward checking is supported, false otherwise
    def is_forward_checking_supported
      return false
    end
    
    typesig { [] }
    # Gets an immutable Set of the OID strings for the extensions that
    # the PKIXCertPathChecker supports (i.e. recognizes, is able to
    # process), or null if no extensions are
    # supported. All OID strings that a PKIXCertPathChecker might
    # possibly be able to process should be included.
    # 
    # @return the Set of extensions supported by this PKIXCertPathChecker,
    # or null if no extensions are supported
    def get_supported_extensions
      if ((self.attr_supported_exts).nil?)
        self.attr_supported_exts = HashSet.new
        self.attr_supported_exts.add(PKIXExtensions::CertificatePolicies_Id.to_s)
        self.attr_supported_exts.add(PKIXExtensions::PolicyMappings_Id.to_s)
        self.attr_supported_exts.add(PKIXExtensions::PolicyConstraints_Id.to_s)
        self.attr_supported_exts.add(PKIXExtensions::InhibitAnyPolicy_Id.to_s)
        self.attr_supported_exts = Collections.unmodifiable_set(self.attr_supported_exts)
      end
      return self.attr_supported_exts
    end
    
    typesig { [Certificate, Collection] }
    # Performs the policy processing checks on the certificate using its
    # internal state.
    # 
    # @param cert the Certificate to be processed
    # @param unresCritExts the unresolved critical extensions
    # @exception CertPathValidatorException Exception thrown if
    # the certificate does not verify.
    def check(cert, unres_crit_exts)
      # now do the policy checks
      check_policy(cert)
      if (!(unres_crit_exts).nil? && !unres_crit_exts.is_empty)
        unres_crit_exts.remove(PKIXExtensions::CertificatePolicies_Id.to_s)
        unres_crit_exts.remove(PKIXExtensions::PolicyMappings_Id.to_s)
        unres_crit_exts.remove(PKIXExtensions::PolicyConstraints_Id.to_s)
        unres_crit_exts.remove(PKIXExtensions::InhibitAnyPolicy_Id.to_s)
      end
    end
    
    typesig { [X509Certificate] }
    # Internal method to run through all the checks.
    # 
    # @param currCert the certificate to be processed
    # @exception CertPathValidatorException Exception thrown if
    # the certificate does not verify
    def check_policy(curr_cert)
      msg = "certificate policies"
      if (!(Debug).nil?)
        Debug.println("PolicyChecker.checkPolicy() ---checking " + msg + "...")
        Debug.println("PolicyChecker.checkPolicy() certIndex = " + RJava.cast_to_string(@cert_index))
        Debug.println("PolicyChecker.checkPolicy() BEFORE PROCESSING: " + "explicitPolicy = " + RJava.cast_to_string(@explicit_policy))
        Debug.println("PolicyChecker.checkPolicy() BEFORE PROCESSING: " + "policyMapping = " + RJava.cast_to_string(@policy_mapping))
        Debug.println("PolicyChecker.checkPolicy() BEFORE PROCESSING: " + "inhibitAnyPolicy = " + RJava.cast_to_string(@inhibit_any_policy))
        Debug.println("PolicyChecker.checkPolicy() BEFORE PROCESSING: " + "policyTree = " + RJava.cast_to_string(@root_node))
      end
      curr_cert_impl = nil
      begin
        curr_cert_impl = X509CertImpl.to_impl(curr_cert)
      rescue CertificateException => ce
        raise CertPathValidatorException.new(ce)
      end
      final_cert = ((@cert_index).equal?(@cert_path_len))
      @root_node = process_policies(@cert_index, @init_policies, @explicit_policy, @policy_mapping, @inhibit_any_policy, @reject_policy_qualifiers, @root_node, curr_cert_impl, final_cert)
      if (!final_cert)
        @explicit_policy = merge_explicit_policy(@explicit_policy, curr_cert_impl, final_cert)
        @policy_mapping = merge_policy_mapping(@policy_mapping, curr_cert_impl)
        @inhibit_any_policy = merge_inhibit_any_policy(@inhibit_any_policy, curr_cert_impl)
      end
      @cert_index += 1
      if (!(Debug).nil?)
        Debug.println("PolicyChecker.checkPolicy() AFTER PROCESSING: " + "explicitPolicy = " + RJava.cast_to_string(@explicit_policy))
        Debug.println("PolicyChecker.checkPolicy() AFTER PROCESSING: " + "policyMapping = " + RJava.cast_to_string(@policy_mapping))
        Debug.println("PolicyChecker.checkPolicy() AFTER PROCESSING: " + "inhibitAnyPolicy = " + RJava.cast_to_string(@inhibit_any_policy))
        Debug.println("PolicyChecker.checkPolicy() AFTER PROCESSING: " + "policyTree = " + RJava.cast_to_string(@root_node))
        Debug.println("PolicyChecker.checkPolicy() " + msg + " verified")
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, X509CertImpl, ::Java::Boolean] }
      # Merges the specified explicitPolicy value with the
      # requireExplicitPolicy field of the <code>PolicyConstraints</code>
      # extension obtained from the certificate. An explicitPolicy
      # value of -1 implies no constraint.
      # 
      # @param explicitPolicy an integer which indicates if a non-null
      # valid policy tree is required
      # @param currCert the Certificate to be processed
      # @param finalCert a boolean indicating whether currCert is
      # the final cert in the cert path
      # @return returns the new explicitPolicy value
      # @exception CertPathValidatorException Exception thrown if an error
      # occurs
      def merge_explicit_policy(explicit_policy, curr_cert, final_cert)
        if ((explicit_policy > 0) && !X509CertImpl.is_self_issued(curr_cert))
          explicit_policy -= 1
        end
        begin
          pol_const_ext = curr_cert.get_policy_constraints_extension
          if ((pol_const_ext).nil?)
            return explicit_policy
          end
          require = (pol_const_ext.get(PolicyConstraintsExtension::REQUIRE)).int_value
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.mergeExplicitPolicy() " + "require Index from cert = " + RJava.cast_to_string(require))
          end
          if (!final_cert)
            if (!(require).equal?(-1))
              if (((explicit_policy).equal?(-1)) || (require < explicit_policy))
                explicit_policy = require
              end
            end
          else
            if ((require).equal?(0))
              explicit_policy = require
            end
          end
        rescue JavaException => e
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.mergeExplicitPolicy " + "unexpected exception")
            e.print_stack_trace
          end
          raise CertPathValidatorException.new(e)
        end
        return explicit_policy
      end
      
      typesig { [::Java::Int, X509CertImpl] }
      # Merges the specified policyMapping value with the
      # inhibitPolicyMapping field of the <code>PolicyConstraints</code>
      # extension obtained from the certificate. A policyMapping
      # value of -1 implies no constraint.
      # 
      # @param policyMapping an integer which indicates if policy mapping
      # is inhibited
      # @param currCert the Certificate to be processed
      # @return returns the new policyMapping value
      # @exception CertPathValidatorException Exception thrown if an error
      # occurs
      def merge_policy_mapping(policy_mapping, curr_cert)
        if ((policy_mapping > 0) && !X509CertImpl.is_self_issued(curr_cert))
          policy_mapping -= 1
        end
        begin
          pol_const_ext = curr_cert.get_policy_constraints_extension
          if ((pol_const_ext).nil?)
            return policy_mapping
          end
          inhibit = (pol_const_ext.get(PolicyConstraintsExtension::INHIBIT)).int_value
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.mergePolicyMapping() " + "inhibit Index from cert = " + RJava.cast_to_string(inhibit))
          end
          if (!(inhibit).equal?(-1))
            if (((policy_mapping).equal?(-1)) || (inhibit < policy_mapping))
              policy_mapping = inhibit
            end
          end
        rescue JavaException => e
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.mergePolicyMapping " + "unexpected exception")
            e.print_stack_trace
          end
          raise CertPathValidatorException.new(e)
        end
        return policy_mapping
      end
      
      typesig { [::Java::Int, X509CertImpl] }
      # Merges the specified inhibitAnyPolicy value with the
      # SkipCerts value of the InhibitAnyPolicy
      # extension obtained from the certificate.
      # 
      # @param inhibitAnyPolicy an integer which indicates whether
      # "any-policy" is considered a match
      # @param currCert the Certificate to be processed
      # @return returns the new inhibitAnyPolicy value
      # @exception CertPathValidatorException Exception thrown if an error
      # occurs
      def merge_inhibit_any_policy(inhibit_any_policy, curr_cert)
        if ((inhibit_any_policy > 0) && !X509CertImpl.is_self_issued(curr_cert))
          inhibit_any_policy -= 1
        end
        begin
          inh_any_pol_ext = curr_cert.get_extension(PKIXExtensions::InhibitAnyPolicy_Id)
          if ((inh_any_pol_ext).nil?)
            return inhibit_any_policy
          end
          skip_certs = (inh_any_pol_ext.get(InhibitAnyPolicyExtension::SKIP_CERTS)).int_value
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.mergeInhibitAnyPolicy() " + "skipCerts Index from cert = " + RJava.cast_to_string(skip_certs))
          end
          if (!(skip_certs).equal?(-1))
            if (skip_certs < inhibit_any_policy)
              inhibit_any_policy = skip_certs
            end
          end
        rescue JavaException => e
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.mergeInhibitAnyPolicy " + "unexpected exception")
            e.print_stack_trace
          end
          raise CertPathValidatorException.new(e)
        end
        return inhibit_any_policy
      end
      
      typesig { [::Java::Int, JavaSet, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean, PolicyNodeImpl, X509CertImpl, ::Java::Boolean] }
      # Processes certificate policies in the certificate.
      # 
      # @param certIndex the index of the certificate
      # @param initPolicies the initial policies required by the user
      # @param explicitPolicy an integer which indicates if a non-null
      # valid policy tree is required
      # @param policyMapping an integer which indicates if policy
      # mapping is inhibited
      # @param inhibitAnyPolicy an integer which indicates whether
      # "any-policy" is considered a match
      # @param rejectPolicyQualifiers a boolean indicating whether the
      # user wants to reject policies that have qualifiers
      # @param origRootNode the root node of the valid policy tree
      # @param currCert the Certificate to be processed
      # @param finalCert a boolean indicating whether currCert is the final
      # cert in the cert path
      # @return the root node of the valid policy tree after modification
      # @exception CertPathValidatorException Exception thrown if an
      # error occurs while processing policies.
      def process_policies(cert_index, init_policies, explicit_policy, policy_mapping, inhibit_any_policy, reject_policy_qualifiers, orig_root_node, curr_cert, final_cert)
        policies_critical = false
        policy_info = nil
        root_node = nil
        any_quals = HashSet.new
        if ((orig_root_node).nil?)
          root_node = nil
        else
          root_node = orig_root_node.copy_tree
        end
        # retrieve policyOIDs from currCert
        curr_cert_policies = curr_cert.get_certificate_policies_extension
        # PKIX: Section 6.1.3: Step (d)
        if ((!(curr_cert_policies).nil?) && (!(root_node).nil?))
          policies_critical = curr_cert_policies.is_critical
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.processPolicies() " + "policiesCritical = " + RJava.cast_to_string(policies_critical))
          end
          begin
            policy_info = curr_cert_policies.get(CertificatePoliciesExtension::POLICIES)
          rescue IOException => ioe
            raise CertPathValidatorException.new("Exception while " + "retrieving policyOIDs", ioe)
          end
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.processPolicies() " + "rejectPolicyQualifiers = " + RJava.cast_to_string(reject_policy_qualifiers))
          end
          found_any_policy = false
          # process each policy in cert
          policy_info.each do |curPolInfo|
            cur_policy = cur_pol_info.get_policy_identifier.get_identifier.to_s
            if ((cur_policy == ANY_POLICY))
              found_any_policy = true
              any_quals = cur_pol_info.get_policy_qualifiers
            else
              # PKIX: Section 6.1.3: Step (d)(1)
              if (!(Debug).nil?)
                Debug.println("PolicyChecker.processPolicies() " + "processing policy: " + cur_policy)
              end
              # retrieve policy qualifiers from cert
              p_quals = cur_pol_info.get_policy_qualifiers
              # reject cert if we find critical policy qualifiers and
              # the policyQualifiersRejected flag is set in the params
              if (!p_quals.is_empty && reject_policy_qualifiers && policies_critical)
                raise CertPathValidatorException.new("critical " + "policy qualifiers present in certificate")
              end
              # PKIX: Section 6.1.3: Step (d)(1)(i)
              found_match = process_parents(cert_index, policies_critical, reject_policy_qualifiers, root_node, cur_policy, p_quals, false)
              if (!found_match)
                # PKIX: Section 6.1.3: Step (d)(1)(ii)
                process_parents(cert_index, policies_critical, reject_policy_qualifiers, root_node, cur_policy, p_quals, true)
              end
            end
          end
          # PKIX: Section 6.1.3: Step (d)(2)
          if (found_any_policy)
            if ((inhibit_any_policy > 0) || (!final_cert && X509CertImpl.is_self_issued(curr_cert)))
              if (!(Debug).nil?)
                Debug.println("PolicyChecker.processPolicies() " + "processing policy: " + ANY_POLICY)
              end
              process_parents(cert_index, policies_critical, reject_policy_qualifiers, root_node, ANY_POLICY, any_quals, true)
            end
          end
          # PKIX: Section 6.1.3: Step (d)(3)
          root_node.prune(cert_index)
          if (!root_node.get_children.has_next)
            root_node = nil
          end
        else
          if ((curr_cert_policies).nil?)
            if (!(Debug).nil?)
              Debug.println("PolicyChecker.processPolicies() " + "no policies present in cert")
            end
            # PKIX: Section 6.1.3: Step (e)
            root_node = nil
          end
        end
        # We delay PKIX: Section 6.1.3: Step (f) to the end
        # because the code that follows may delete some nodes
        # resulting in a null tree
        if (!(root_node).nil?)
          if (!final_cert)
            # PKIX: Section 6.1.4: Steps (a)-(b)
            root_node = process_policy_mappings(curr_cert, cert_index, policy_mapping, root_node, policies_critical, any_quals)
          end
        end
        # At this point, we optimize the PKIX algorithm by
        # removing those nodes which would later have
        # been removed by PKIX: Section 6.1.5: Step (g)(iii)
        if ((!(root_node).nil?) && (!init_policies.contains(ANY_POLICY)) && (!(curr_cert_policies).nil?))
          root_node = remove_invalid_nodes(root_node, cert_index, init_policies, curr_cert_policies)
          # PKIX: Section 6.1.5: Step (g)(iii)
          if ((!(root_node).nil?) && final_cert)
            # rewrite anyPolicy leaf nodes (see method comments)
            root_node = rewrite_leaf_nodes(cert_index, init_policies, root_node)
          end
        end
        if (final_cert)
          # PKIX: Section 6.1.5: Steps (a) and (b)
          explicit_policy = merge_explicit_policy(explicit_policy, curr_cert, final_cert)
        end
        # PKIX: Section 6.1.3: Step (f)
        # verify that either explicit policy is greater than 0 or
        # the valid_policy_tree is not equal to NULL
        if (((explicit_policy).equal?(0)) && ((root_node).nil?))
          raise CertPathValidatorException.new("non-null policy tree required and policy tree is null")
        end
        return root_node
      end
      
      typesig { [::Java::Int, JavaSet, PolicyNodeImpl] }
      # Rewrite leaf nodes at the end of validation as described in RFC 3280
      # section 6.1.5: Step (g)(iii). Leaf nodes with anyPolicy are replaced
      # by nodes explicitly representing initial policies not already
      # represented by leaf nodes.
      # 
      # This method should only be called when processing the final cert
      # and if the policy tree is not null and initial policies is not
      # anyPolicy.
      # 
      # @param certIndex the depth of the tree
      # @param initPolicies Set of user specified initial policies
      # @param rootNode the root of the policy tree
      def rewrite_leaf_nodes(cert_index, init_policies, root_node)
        any_nodes = root_node.get_policy_nodes_valid(cert_index, ANY_POLICY)
        if (any_nodes.is_empty)
          return root_node
        end
        any_node = any_nodes.iterator.next_
        parent_node = any_node.get_parent
        parent_node.delete_child(any_node)
        # see if there are any initialPolicies not represented by leaf nodes
        initial = HashSet.new(init_policies)
        root_node.get_policy_nodes(cert_index).each do |node|
          initial.remove(node.get_valid_policy)
        end
        if (initial.is_empty)
          # we deleted the anyPolicy node and have nothing to re-add,
          # so we need to prune the tree
          root_node.prune(cert_index)
          if ((root_node.get_children.has_next).equal?(false))
            root_node = nil
          end
        else
          any_critical = any_node.is_critical
          any_qualifiers = any_node.get_policy_qualifiers
          initial.each do |policy|
            expected_policies = Collections.singleton(policy)
            node = PolicyNodeImpl.new(parent_node, policy, any_qualifiers, any_critical, expected_policies, false)
          end
        end
        return root_node
      end
      
      typesig { [::Java::Int, ::Java::Boolean, ::Java::Boolean, PolicyNodeImpl, String, JavaSet, ::Java::Boolean] }
      # Finds the policy nodes of depth (certIndex-1) where curPolicy
      # is in the expected policy set and creates a new child node
      # appropriately. If matchAny is true, then a value of ANY_POLICY
      # in the expected policy set will match any curPolicy. If matchAny
      # is false, then the expected policy set must exactly contain the
      # curPolicy to be considered a match. This method returns a boolean
      # value indicating whether a match was found.
      # 
      # @param certIndex the index of the certificate whose policy is
      # being processed
      # @param policiesCritical a boolean indicating whether the certificate
      # policies extension is critical
      # @param rejectPolicyQualifiers a boolean indicating whether the
      # user wants to reject policies that have qualifiers
      # @param rootNode the root node of the valid policy tree
      # @param curPolicy a String representing the policy being processed
      # @param pQuals the policy qualifiers of the policy being processed or an
      # empty Set if there are no qualifiers
      # @param matchAny a boolean indicating whether a value of ANY_POLICY
      # in the expected policy set will be considered a match
      # @return a boolean indicating whether a match was found
      # @exception CertPathValidatorException Exception thrown if error occurs.
      def process_parents(cert_index, policies_critical, reject_policy_qualifiers, root_node, cur_policy, p_quals, match_any)
        found_match = false
        if (!(Debug).nil?)
          Debug.println("PolicyChecker.processParents(): matchAny = " + RJava.cast_to_string(match_any))
        end
        # find matching parents
        parent_nodes = root_node.get_policy_nodes_expected(cert_index - 1, cur_policy, match_any)
        # for each matching parent, extend policy tree
        parent_nodes.each do |curParent|
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.processParents() " + "found parent:\n" + RJava.cast_to_string(cur_parent.as_string))
          end
          found_match = true
          cur_par_policy = cur_parent.get_valid_policy
          cur_node = nil
          cur_exp_pols = nil
          if ((cur_policy == ANY_POLICY))
            # do step 2
            par_exp_pols = cur_parent.get_expected_policies
            par_exp_pols.each do |curParExpPol|
              catch(:next_parent_explicit_policies) do
                child_iter = cur_parent.get_children
                while (child_iter.has_next)
                  child_node = child_iter.next_
                  child_policy = child_node.get_valid_policy
                  if ((cur_par_exp_pol == child_policy))
                    if (!(Debug).nil?)
                      Debug.println(child_policy + " in parent's " + "expected policy set already appears in " + "child node")
                    end
                    throw :next_parent_explicit_policies, :thrown
                  end
                end
                exp_pols = HashSet.new
                exp_pols.add(cur_par_exp_pol)
                cur_node = PolicyNodeImpl.new(cur_parent, cur_par_exp_pol, p_quals, policies_critical, exp_pols, false)
              end == :thrown or break
            end
          else
            cur_exp_pols = HashSet.new
            cur_exp_pols.add(cur_policy)
            cur_node = PolicyNodeImpl.new(cur_parent, cur_policy, p_quals, policies_critical, cur_exp_pols, false)
          end
        end
        return found_match
      end
      
      typesig { [X509CertImpl, ::Java::Int, ::Java::Int, PolicyNodeImpl, ::Java::Boolean, JavaSet] }
      # Processes policy mappings in the certificate.
      # 
      # @param currCert the Certificate to be processed
      # @param certIndex the index of the current certificate
      # @param policyMapping an integer which indicates if policy
      # mapping is inhibited
      # @param rootNode the root node of the valid policy tree
      # @param policiesCritical a boolean indicating if the certificate policies
      # extension is critical
      # @param anyQuals the qualifiers associated with ANY-POLICY, or an empty
      # Set if there are no qualifiers associated with ANY-POLICY
      # @return the root node of the valid policy tree after modification
      # @exception CertPathValidatorException exception thrown if an error
      # occurs while processing policy mappings
      def process_policy_mappings(curr_cert, cert_index, policy_mapping, root_node, policies_critical, any_quals)
        pol_mappings_ext = curr_cert.get_policy_mappings_extension
        if ((pol_mappings_ext).nil?)
          return root_node
        end
        if (!(Debug).nil?)
          Debug.println("PolicyChecker.processPolicyMappings() " + "inside policyMapping check")
        end
        maps = nil
        begin
          maps = pol_mappings_ext.get(PolicyMappingsExtension::MAP)
        rescue IOException => e
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.processPolicyMappings() " + "mapping exception")
            e.print_stack_trace
          end
          raise CertPathValidatorException.new("Exception while checking " + "mapping", e)
        end
        child_deleted = false
        j = 0
        while j < maps.size
          pol_map = maps.get(j)
          issuer_domain = pol_map.get_issuer_identifier.get_identifier.to_s
          subject_domain = pol_map.get_subject_identifier.get_identifier.to_s
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.processPolicyMappings() " + "issuerDomain = " + issuer_domain)
            Debug.println("PolicyChecker.processPolicyMappings() " + "subjectDomain = " + subject_domain)
          end
          if ((issuer_domain == ANY_POLICY))
            raise CertPathValidatorException.new("encountered an issuerDomainPolicy of ANY_POLICY")
          end
          if ((subject_domain == ANY_POLICY))
            raise CertPathValidatorException.new("encountered a subjectDomainPolicy of ANY_POLICY")
          end
          valid_nodes = root_node.get_policy_nodes_valid(cert_index, issuer_domain)
          if (!valid_nodes.is_empty)
            valid_nodes.each do |curNode|
              if ((policy_mapping > 0) || ((policy_mapping).equal?(-1)))
                cur_node.add_expected_policy(subject_domain)
              else
                if ((policy_mapping).equal?(0))
                  parent_node = cur_node.get_parent
                  if (!(Debug).nil?)
                    Debug.println("PolicyChecker.processPolicyMappings" + "() before deleting: policy tree = " + RJava.cast_to_string(root_node))
                  end
                  parent_node.delete_child(cur_node)
                  child_deleted = true
                  if (!(Debug).nil?)
                    Debug.println("PolicyChecker.processPolicyMappings" + "() after deleting: policy tree = " + RJava.cast_to_string(root_node))
                  end
                end
              end
            end
          else
            # no node of depth i has a valid policy
            if ((policy_mapping > 0) || ((policy_mapping).equal?(-1)))
              valid_any_nodes = root_node.get_policy_nodes_valid(cert_index, ANY_POLICY)
              valid_any_nodes.each do |curAnyNode|
                cur_any_node_parent = cur_any_node.get_parent
                exp_pols = HashSet.new
                exp_pols.add(subject_domain)
                cur_node = PolicyNodeImpl.new(cur_any_node_parent, issuer_domain, any_quals, policies_critical, exp_pols, true)
              end
            end
          end
          j += 1
        end
        if (child_deleted)
          root_node.prune(cert_index)
          if (!root_node.get_children.has_next)
            if (!(Debug).nil?)
              Debug.println("setting rootNode to null")
            end
            root_node = nil
          end
        end
        return root_node
      end
      
      typesig { [PolicyNodeImpl, ::Java::Int, JavaSet, CertificatePoliciesExtension] }
      # Removes those nodes which do not intersect with the initial policies
      # specified by the user.
      # 
      # @param rootNode the root node of the valid policy tree
      # @param certIndex the index of the certificate being processed
      # @param initPolicies the Set of policies required by the user
      # @param currCertPolicies the CertificatePoliciesExtension of the
      # certificate being processed
      # @returns the root node of the valid policy tree after modification
      # @exception CertPathValidatorException Exception thrown if error occurs.
      def remove_invalid_nodes(root_node, cert_index, init_policies, curr_cert_policies)
        policy_info = nil
        begin
          policy_info = curr_cert_policies.get(CertificatePoliciesExtension::POLICIES)
        rescue IOException => ioe
          raise CertPathValidatorException.new("Exception while " + "retrieving policyOIDs", ioe)
        end
        child_deleted = false
        policy_info.each do |curPolInfo|
          cur_policy = cur_pol_info.get_policy_identifier.get_identifier.to_s
          if (!(Debug).nil?)
            Debug.println("PolicyChecker.processPolicies() " + "processing policy second time: " + cur_policy)
          end
          valid_nodes = root_node.get_policy_nodes_valid(cert_index, cur_policy)
          valid_nodes.each do |curNode|
            parent_node = cur_node.get_parent
            if ((parent_node.get_valid_policy == ANY_POLICY))
              if ((!init_policies.contains(cur_policy)) && (!(cur_policy == ANY_POLICY)))
                if (!(Debug).nil?)
                  Debug.println("PolicyChecker.processPolicies() " + "before deleting: policy tree = " + RJava.cast_to_string(root_node))
                end
                parent_node.delete_child(cur_node)
                child_deleted = true
                if (!(Debug).nil?)
                  Debug.println("PolicyChecker.processPolicies() " + "after deleting: policy tree = " + RJava.cast_to_string(root_node))
                end
              end
            end
          end
        end
        if (child_deleted)
          root_node.prune(cert_index)
          if (!root_node.get_children.has_next)
            root_node = nil
          end
        end
        return root_node
      end
    }
    
    typesig { [] }
    # Gets the root node of the valid policy tree, or null if the
    # valid policy tree is null. Marks each node of the returned tree
    # immutable and thread-safe.
    # 
    # @returns the root node of the valid policy tree, or null if
    # the valid policy tree is null
    def get_policy_tree
      if ((@root_node).nil?)
        return nil
      else
        policy_tree = @root_node.copy_tree
        policy_tree.set_immutable
        return policy_tree
      end
    end
    
    private
    alias_method :initialize__policy_checker, :initialize
  end
  
end
