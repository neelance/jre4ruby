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
  module ReverseStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :TrustAnchor
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Interfaces, :DSAPublicKey
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :JavaSet
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :NameConstraintsExtension
      include_const ::Sun::Security::X509, :SubjectKeyIdentifierExtension
      include_const ::Sun::Security::X509, :X509CertImpl
    }
  end
  
  # A specification of a reverse PKIX validation state
  # which is initialized by each build and updated each time a
  # certificate is added to the current path.
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  class ReverseState 
    include_class_members ReverseStateImports
    include State
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    # The subject DN of the last cert in the path
    attr_accessor :subject_dn
    alias_method :attr_subject_dn, :subject_dn
    undef_method :subject_dn
    alias_method :attr_subject_dn=, :subject_dn=
    undef_method :subject_dn=
    
    # The subject public key of the last cert
    attr_accessor :pub_key
    alias_method :attr_pub_key, :pub_key
    undef_method :pub_key
    alias_method :attr_pub_key=, :pub_key=
    undef_method :pub_key=
    
    # The subject key identifier extension (if any) of the last cert
    attr_accessor :subj_key_id
    alias_method :attr_subj_key_id, :subj_key_id
    undef_method :subj_key_id
    alias_method :attr_subj_key_id=, :subj_key_id=
    undef_method :subj_key_id=
    
    # The PKIX constrained/excluded subtrees state variable
    attr_accessor :nc
    alias_method :attr_nc, :nc
    undef_method :nc
    alias_method :attr_nc=, :nc=
    undef_method :nc=
    
    # The PKIX explicit policy, policy mapping, and inhibit_any-policy
    # state variables
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
    
    attr_accessor :root_node
    alias_method :attr_root_node, :root_node
    undef_method :root_node
    alias_method :attr_root_node=, :root_node=
    undef_method :root_node=
    
    # The number of remaining CA certs which may follow in the path.
    # -1: previous cert was an EE cert
    # 0: only EE certs may follow.
    # >0 and <Integer.MAX_VALUE:no more than this number of CA certs may follow
    # Integer.MAX_VALUE: unlimited
    attr_accessor :remaining_cacerts
    alias_method :attr_remaining_cacerts, :remaining_cacerts
    undef_method :remaining_cacerts
    alias_method :attr_remaining_cacerts=, :remaining_cacerts=
    undef_method :remaining_cacerts=
    
    # The list of user-defined checkers retrieved from the PKIXParameters
    # instance
    attr_accessor :user_checkers
    alias_method :attr_user_checkers, :user_checkers
    undef_method :user_checkers
    alias_method :attr_user_checkers=, :user_checkers=
    undef_method :user_checkers=
    
    # Flag indicating if state is initial (path is just starting)
    attr_accessor :init
    alias_method :attr_init, :init
    undef_method :init
    alias_method :attr_init=, :init=
    undef_method :init=
    
    # the checker used for revocation status
    attr_accessor :crl_checker
    alias_method :attr_crl_checker, :crl_checker
    undef_method :crl_checker
    alias_method :attr_crl_checker=, :crl_checker=
    undef_method :crl_checker=
    
    # the trust anchor used to validate the path
    attr_accessor :trust_anchor
    alias_method :attr_trust_anchor, :trust_anchor
    undef_method :trust_anchor
    alias_method :attr_trust_anchor=, :trust_anchor=
    undef_method :trust_anchor=
    
    # Flag indicating if current cert can vouch for the CRL for
    # the next cert
    attr_accessor :crl_sign
    alias_method :attr_crl_sign, :crl_sign
    undef_method :crl_sign
    alias_method :attr_crl_sign=, :crl_sign=
    undef_method :crl_sign=
    
    typesig { [] }
    # Returns a boolean flag indicating if the state is initial
    # (just starting)
    # 
    # @return boolean flag indicating if the state is initial (just starting)
    def is_initial
      return @init
    end
    
    typesig { [] }
    # Display state for debugging purposes
    def to_s
      sb = StringBuffer.new
      begin
        sb.append("State [")
        sb.append("\n  subjectDN of last cert: " + RJava.cast_to_string(@subject_dn))
        sb.append("\n  subjectKeyIdentifier: " + RJava.cast_to_string(String.value_of(@subj_key_id)))
        sb.append("\n  nameConstraints: " + RJava.cast_to_string(String.value_of(@nc)))
        sb.append("\n  certIndex: " + RJava.cast_to_string(@cert_index))
        sb.append("\n  explicitPolicy: " + RJava.cast_to_string(@explicit_policy))
        sb.append("\n  policyMapping:  " + RJava.cast_to_string(@policy_mapping))
        sb.append("\n  inhibitAnyPolicy:  " + RJava.cast_to_string(@inhibit_any_policy))
        sb.append("\n  rootNode: " + RJava.cast_to_string(@root_node))
        sb.append("\n  remainingCACerts: " + RJava.cast_to_string(@remaining_cacerts))
        sb.append("\n  crlSign: " + RJava.cast_to_string(@crl_sign))
        sb.append("\n  init: " + RJava.cast_to_string(@init))
        sb.append("\n]\n")
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("ReverseState.toString() unexpected exception")
          e.print_stack_trace
        end
      end
      return sb.to_s
    end
    
    typesig { [::Java::Int, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, JavaList] }
    # Initialize the state.
    # 
    # @param maxPathLen The maximum number of CA certs in a path, where -1
    # means unlimited and 0 means only a single EE cert is allowed.
    # @param explicitPolicyRequired True, if explicit policy is required.
    # @param policyMappingInhibited True, if policy mapping is inhibited.
    # @param anyPolicyInhibited True, if any policy is inhibited.
    # @param certPathCheckers the list of user-defined PKIXCertPathCheckers
    def init_state(max_path_len, explicit_policy_required, policy_mapping_inhibited, any_policy_inhibited, cert_path_checkers)
      # Initialize number of remainingCACerts.
      # Note that -1 maxPathLen implies unlimited.
      # 0 implies only an EE cert is acceptable.
      @remaining_cacerts = ((max_path_len).equal?(-1) ? JavaInteger::MAX_VALUE : max_path_len)
      # Initialize explicit policy state variable
      if (explicit_policy_required)
        @explicit_policy = 0
      else
        # unconstrained if maxPathLen is -1,
        # otherwise, we want to initialize this to the value of the
        # longest possible path + 1 (i.e. maxpathlen + finalcert + 1)
        @explicit_policy = ((max_path_len).equal?(-1)) ? max_path_len : max_path_len + 2
      end
      # Initialize policy mapping state variable
      if (policy_mapping_inhibited)
        @policy_mapping = 0
      else
        @policy_mapping = ((max_path_len).equal?(-1)) ? max_path_len : max_path_len + 2
      end
      # Initialize inhibit any policy state variable
      if (any_policy_inhibited)
        @inhibit_any_policy = 0
      else
        @inhibit_any_policy = ((max_path_len).equal?(-1)) ? max_path_len : max_path_len + 2
      end
      # Initialize certIndex
      @cert_index = 1
      # Initialize policy tree
      init_exp_pol_set = HashSet.new(1)
      init_exp_pol_set.add(PolicyChecker::ANY_POLICY)
      @root_node = PolicyNodeImpl.new(nil, PolicyChecker::ANY_POLICY, nil, false, init_exp_pol_set, false)
      # Initialize each user-defined checker
      if (!(cert_path_checkers).nil?)
        # Shallow copy the checkers
        @user_checkers = ArrayList.new(cert_path_checkers)
        # initialize each checker (just in case)
        cert_path_checkers.each do |checker|
          checker.init(false)
        end
      else
        @user_checkers = ArrayList.new
      end
      # Start by trusting the cert to sign CRLs
      @crl_sign = true
      @init = true
    end
    
    typesig { [TrustAnchor] }
    # Update the state with the specified trust anchor.
    # 
    # @param anchor the most-trusted CA
    def update_state(anchor)
      @trust_anchor = anchor
      trusted_cert = anchor.get_trusted_cert
      if (!(trusted_cert).nil?)
        update_state(trusted_cert)
      else
        ca_name = anchor.get_ca
        update_state(anchor.get_capublic_key, ca_name)
      end
      @init = false
    end
    
    typesig { [PublicKey, X500Principal] }
    # Update the state. This method is used when the most-trusted CA is
    # a trusted public-key and caName, instead of a trusted cert.
    # 
    # @param pubKey the public key of the trusted CA
    # @param subjectDN the subject distinguished name of the trusted CA
    def update_state(pub_key, subject_dn)
      # update subject DN
      @subject_dn = subject_dn
      # update subject public key
      @pub_key = pub_key
    end
    
    typesig { [X509Certificate] }
    # Update the state with the next certificate added to the path.
    # 
    # @param cert the certificate which is used to update the state
    def update_state(cert)
      if ((cert).nil?)
        return
      end
      # update subject DN
      @subject_dn = cert.get_subject_x500principal
      # check for key needing to inherit alg parameters
      icert = X509CertImpl.to_impl(cert)
      new_key = cert.get_public_key
      if (new_key.is_a?(DSAPublicKey) && (((new_key).get_params).nil?))
        new_key = BasicChecker.make_inherited_params_key(new_key, @pub_key)
      end
      # update subject public key
      @pub_key = new_key
      # if this is a trusted cert (init == true), then we
      # don't update any of the remaining fields
      if (@init)
        @init = false
        return
      end
      # update subject key identifier
      @subj_key_id = icert.get_subject_key_identifier_extension
      # update crlSign
      @crl_sign = CrlRevocationChecker.cert_can_sign_crl(cert)
      # update current name constraints
      if (!(@nc).nil?)
        @nc.merge(icert.get_name_constraints_extension)
      else
        @nc = icert.get_name_constraints_extension
        if (!(@nc).nil?)
          # Make sure we do a clone here, because we're probably
          # going to modify this object later and we don't want to
          # be sharing it with a Certificate object!
          @nc = @nc.clone
        end
      end
      # update policy state variables
      @explicit_policy = PolicyChecker.merge_explicit_policy(@explicit_policy, icert, false)
      @policy_mapping = PolicyChecker.merge_policy_mapping(@policy_mapping, icert)
      @inhibit_any_policy = PolicyChecker.merge_inhibit_any_policy(@inhibit_any_policy, icert)
      @cert_index += 1
      # Update remaining CA certs
      @remaining_cacerts = ConstraintsChecker.merge_basic_constraints(cert, @remaining_cacerts)
      @init = false
    end
    
    typesig { [] }
    # Returns a boolean flag indicating if a key lacking necessary key
    # algorithm parameters has been encountered.
    # 
    # @return boolean flag indicating if key lacking parameters encountered.
    def key_params_needed
      # when building in reverse, we immediately get parameters needed
      # or else throw an exception
      return false
    end
    
    typesig { [] }
    # Clone current state. The state is cloned as each cert is
    # added to the path. This is necessary if backtracking occurs,
    # and a prior state needs to be restored.
    # 
    # Note that this is a SMART clone. Not all fields are fully copied,
    # because some of them (e.g., subjKeyId) will
    # not have their contents modified by subsequent calls to updateState.
    def clone
      begin
        cloned_state = super
        # clone checkers, if cloneable
        cloned_state.attr_user_checkers = @user_checkers.clone
        li = cloned_state.attr_user_checkers.list_iterator
        while (li.has_next)
          checker = li.next_
          if (checker.is_a?(Cloneable))
            li.set(checker.clone)
          end
        end
        # make copy of name constraints
        if (!(@nc).nil?)
          cloned_state.attr_nc = @nc.clone
        end
        # make copy of policy tree
        if (!(@root_node).nil?)
          cloned_state.attr_root_node = @root_node.copy_tree
        end
        return cloned_state
      rescue CloneNotSupportedException => e
        raise InternalError.new(e.to_s)
      end
    end
    
    typesig { [] }
    def initialize
      @subject_dn = nil
      @pub_key = nil
      @subj_key_id = nil
      @nc = nil
      @explicit_policy = 0
      @policy_mapping = 0
      @inhibit_any_policy = 0
      @cert_index = 0
      @root_node = nil
      @remaining_cacerts = 0
      @user_checkers = nil
      @init = true
      @crl_checker = nil
      @trust_anchor = nil
      @crl_sign = true
    end
    
    private
    alias_method :initialize__reverse_state, :initialize
  end
  
end
