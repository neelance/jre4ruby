require "rjava"

# 
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
  module BuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :GeneralSecurityException
      include ::Java::Security::Cert
      include ::Java::Util
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :GeneralNames
      include_const ::Sun::Security::X509, :GeneralNameInterface
      include_const ::Sun::Security::X509, :GeneralSubtrees
      include_const ::Sun::Security::X509, :NameConstraintsExtension
      include_const ::Sun::Security::X509, :SubjectAlternativeNameExtension
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::X509, :X509CertImpl
    }
  end
  
  # 
  # Abstract class representing a builder, which is able to retrieve
  # matching certificates and is able to verify a particular certificate.
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  class Builder 
    include_class_members BuilderImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :matching_policies
    alias_method :attr_matching_policies, :matching_policies
    undef_method :matching_policies
    alias_method :attr_matching_policies=, :matching_policies=
    undef_method :matching_policies=
    
    attr_accessor :build_params
    alias_method :attr_build_params, :build_params
    undef_method :build_params
    alias_method :attr_build_params=, :build_params=
    undef_method :build_params=
    
    attr_accessor :target_subject_dn
    alias_method :attr_target_subject_dn, :target_subject_dn
    undef_method :target_subject_dn
    alias_method :attr_target_subject_dn=, :target_subject_dn=
    undef_method :target_subject_dn=
    
    attr_accessor :date
    alias_method :attr_date, :date
    undef_method :date
    alias_method :attr_date=, :date=
    undef_method :date=
    
    attr_accessor :target_cert_constraints
    alias_method :attr_target_cert_constraints, :target_cert_constraints
    undef_method :target_cert_constraints
    alias_method :attr_target_cert_constraints=, :target_cert_constraints=
    undef_method :target_cert_constraints=
    
    class_module.module_eval {
      # 
      # Flag indicating whether support for the caIssuers field of the
      # Authority Information Access extension shall be enabled. Currently
      # disabled by default for compatibility reasons.
      const_set_lazy(:USE_AIA) { DistributionPointFetcher.get_boolean_property("com.sun.security.enableAIAcaIssuers", false) }
      const_attr_reader  :USE_AIA
    }
    
    typesig { [PKIXBuilderParameters, X500Principal] }
    # 
    # Initialize the builder with the input parameters.
    # 
    # @param params the parameter set used to build a certification path
    def initialize(build_params, target_subject_dn)
      @matching_policies = nil
      @build_params = nil
      @target_subject_dn = nil
      @date = nil
      @target_cert_constraints = nil
      @build_params = build_params
      @target_subject_dn = target_subject_dn
      # Initialize date if not specified
      params_date = build_params.get_date
      @date = !(params_date).nil? ? params_date : Date.new
      @target_cert_constraints = build_params.get_target_cert_constraints
    end
    
    typesig { [State, JavaList] }
    # 
    # Retrieves certificates from the list of certStores using the buildParams
    # and the currentState as a filter
    # 
    # @param currentState the current State
    # @param certStores list of CertStores
    def get_matching_certs(current_state, cert_stores)
      raise NotImplementedError
    end
    
    typesig { [X509Certificate, State, JavaList] }
    # 
    # Verifies the cert against the currentState, using the certPathList
    # generated thus far to help with loop detection
    # 
    # @param cert the certificate to be verified
    # @param currentState the current state against which the cert is verified
    # @param certPathList the certPathList generated thus far
    def verify_cert(cert, current_state, cert_path_list)
      raise NotImplementedError
    end
    
    typesig { [X509Certificate] }
    # 
    # Verifies whether the input certificate completes the path.
    # When building forward, a trust anchor will complete the path.
    # When building reverse, the target certificate will complete the path.
    # 
    # @param cert the certificate to test
    # @return a boolean value indicating whether the cert completes the path.
    def is_path_completed(cert)
      raise NotImplementedError
    end
    
    typesig { [X509Certificate, LinkedList] }
    # 
    # Adds the certificate to the certPathList
    # 
    # @param cert the certificate to be added
    # @param certPathList the certification path list
    def add_cert_to_path(cert, cert_path_list)
      raise NotImplementedError
    end
    
    typesig { [LinkedList] }
    # 
    # Removes final certificate from the certPathList
    # 
    # @param certPathList the certification path list
    def remove_final_cert_from_path(cert_path_list)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [GeneralNameInterface, GeneralNameInterface, ::Java::Int] }
      # 
      # get distance of one GeneralName from another
      # 
      # @param base GeneralName at base of subtree
      # @param test GeneralName to be tested against base
      # @param incomparable the value to return if the names are
      # incomparable
      # @return distance of test name from base, where 0
      # means exact match, 1 means test is an immediate
      # child of base, 2 means test is a grandchild, etc.
      # -1 means test is a parent of base, -2 means test
      # is a grandparent, etc.
      def distance(base, test, incomparable)
        case (base.constrains(test))
        when GeneralNameInterface::NAME_DIFF_TYPE
          if (!(Debug).nil?)
            Debug.println("Builder.distance(): Names are different types")
          end
          if (!(Debug).nil?)
            Debug.println("Builder.distance(): Names are same type but " + "in different subtrees")
          end
          return incomparable
        when GeneralNameInterface::NAME_SAME_TYPE
          if (!(Debug).nil?)
            Debug.println("Builder.distance(): Names are same type but " + "in different subtrees")
          end
          return incomparable
        when GeneralNameInterface::NAME_MATCH
          return 0
        when GeneralNameInterface::NAME_WIDENS
        when GeneralNameInterface::NAME_NARROWS
        else
          # should never occur
          return incomparable
        end
        # names are in same subtree
        return test.subtree_depth - base.subtree_depth
      end
      
      typesig { [GeneralNameInterface, GeneralNameInterface, ::Java::Int] }
      # 
      # get hop distance of one GeneralName from another in links where
      # the names need not have an ancestor/descendant relationship.
      # For example, the hop distance from ou=D,ou=C,o=B,c=US to
      # ou=F,ou=E,ou=C,o=B,c=US is 3: D->C, C->E, E->F.  The hop distance
      # from ou=C,o=B,c=US to ou=D,ou=C,o=B,c=US is -1: C->D
      # 
      # @param base GeneralName
      # @param test GeneralName to be tested against base
      # @param incomparable the value to return if the names are
      # incomparable
      # @return distance of test name from base measured in hops in the
      # namespace hierarchy, where 0 means exact match.  Result
      # is positive if path is some number of up hops followed by
      # some number of down hops; result is negative if path is
      # some number of down hops.
      def hops(base, test, incomparable)
        base_rtest = base.constrains(test)
        case (base_rtest)
        when GeneralNameInterface::NAME_DIFF_TYPE
          if (!(Debug).nil?)
            Debug.println("Builder.hops(): Names are different types")
          end
          return incomparable
        when GeneralNameInterface::NAME_SAME_TYPE
          # base and test are in different subtrees
        when GeneralNameInterface::NAME_MATCH
          # base matches test
          return 0
        when GeneralNameInterface::NAME_WIDENS
          # base is ancestor of test
          return (test.subtree_depth - base.subtree_depth)
        when GeneralNameInterface::NAME_NARROWS
          # base is descendant of test
          return (test.subtree_depth - base.subtree_depth)
        else
          # should never occur
          return incomparable
        end
        # names are in different subtrees
        if (!(base.get_type).equal?(GeneralNameInterface::NAME_DIRECTORY))
          if (!(Debug).nil?)
            Debug.println("Builder.hops(): hopDistance not implemented " + "for this name type")
          end
          return incomparable
        end
        base_name = base
        test_name = test
        common_name = base_name.common_ancestor(test_name)
        if ((common_name).nil?)
          if (!(Debug).nil?)
            Debug.println("Builder.hops(): Names are in different " + "namespaces")
          end
          return incomparable
        else
          common_distance = common_name.subtree_depth
          base_distance = base_name.subtree_depth
          test_distance = test_name.subtree_depth
          return (base_distance + test_distance - (2 * common_distance))
        end
      end
      
      typesig { [NameConstraintsExtension, X509Certificate, GeneralNameInterface] }
      # 
      # Determine how close a given certificate gets you toward
      # a given target.
      # 
      # @param constraints Current NameConstraints; if null,
      # then caller must verify NameConstraints
      # independently, realizing that this certificate
      # may not actually lead to the target at all.
      # @param cert Candidate certificate for chain
      # @param target GeneralNameInterface name of target
      # @return distance from this certificate to target:
      # <ul>
      # <li>-1 means certificate could be CA for target, but
      # there are no NameConstraints limiting how close
      # <li> 0 means certificate subject or subjectAltName
      # matches target
      # <li> 1 means certificate is permitted to be CA for
      # target.
      # <li> 2 means certificate is permitted to be CA for
      # parent of target.
      # <li>&gt;0 in general, means certificate is permitted
      # to be a CA for this distance higher in the naming
      # hierarchy than the target, plus 1.
      # </ul>
      # <p>Note that the subject and/or subjectAltName of the
      # candidate cert does not have to be an ancestor of the
      # target in order to be a CA that can issue a certificate to
      # the target. In these cases, the target distance is calculated
      # by inspecting the NameConstraints extension in the candidate
      # certificate. For example, suppose the target is an X.500 DN with
      # a value of "CN=mullan,OU=ireland,O=sun,C=us" and the
      # NameConstraints extension in the candidate certificate
      # includes a permitted component of "O=sun,C=us", which implies
      # that the candidate certificate is allowed to issue certs in
      # the "O=sun,C=us" namespace. The target distance is 3
      # ((distance of permitted NC from target) + 1).
      # The (+1) is added to distinguish the result from the case
      # which returns (0).
      # @throws IOException if certificate does not get closer
      def target_distance(constraints, cert, target)
        # ensure that certificate satisfies existing name constraints
        if (!(constraints).nil? && !constraints.verify(cert))
          raise IOException.new("certificate does not satisfy existing name " + "constraints")
        end
        cert_impl = nil
        begin
          cert_impl = X509CertImpl.to_impl(cert)
        rescue CertificateException => e
          raise IOException.new("Invalid certificate").init_cause(e)
        end
        # see if certificate subject matches target
        subject = X500Name.as_x500name(cert_impl.get_subject_x500principal)
        if ((subject == target))
          # match!
          return 0
        end
        alt_name_ext = cert_impl.get_subject_alternative_name_extension
        if (!(alt_name_ext).nil?)
          alt_names = alt_name_ext.get(alt_name_ext.attr_subject_name)
          # see if any alternative name matches target
          if (!(alt_names).nil?)
            j = 0
            n = alt_names.size
            while j < n
              alt_name = alt_names.get(j).get_name
              if ((alt_name == target))
                return 0
              end
              ((j += 1) - 1)
            end
          end
        end
        # no exact match; see if certificate can get us to target
        # first, get NameConstraints out of certificate
        nc_ext = cert_impl.get_name_constraints_extension
        if ((nc_ext).nil?)
          return -1
        end
        # merge certificate's NameConstraints with current NameConstraints
        if (!(constraints).nil?)
          constraints.merge(nc_ext)
        else
          # Make sure we do a clone here, because we're probably
          # going to modify this object later and we don't want to
          # be sharing it with a Certificate object!
          constraints = nc_ext.clone
        end
        if (!(Debug).nil?)
          Debug.println("Builder.targetDistance() merged constraints: " + (String.value_of(constraints)).to_s)
        end
        # reduce permitted by excluded
        permitted = constraints.get(constraints.attr_permitted_subtrees)
        excluded = constraints.get(constraints.attr_excluded_subtrees)
        if (!(permitted).nil?)
          permitted.reduce(excluded)
        end
        if (!(Debug).nil?)
          Debug.println("Builder.targetDistance() reduced constraints: " + (permitted).to_s)
        end
        # see if new merged constraints allow target
        if (!constraints.verify(target))
          raise IOException.new("New certificate not allowed to sign " + "certificate for target")
        end
        # find distance to target, if any, in permitted
        if ((permitted).nil?)
          # certificate is unconstrained; could sign for anything
          return -1
        end
        i = 0
        n_ = permitted.size
        while i < n_
          per_name = permitted.get(i).get_name.get_name
          distance_ = distance(per_name, target, -1)
          if (distance_ >= 0)
            return (distance_ + 1)
          end
          ((i += 1) - 1)
        end
        # no matching type in permitted; cert holder could certify target
        return -1
      end
    }
    
    typesig { [] }
    # 
    # This method can be used as an optimization to filter out
    # certificates that do not have policies which are valid.
    # It returns the set of policies (String OIDs) that should exist in
    # the certificate policies extension of the certificate that is
    # needed by the builder. The logic applied is as follows:
    # <p>
    # 1) If some initial policies have been set *and* policy mappings are
    # inhibited, then acceptable certificates are those that include
    # the ANY_POLICY OID or with policies that intersect with the
    # initial policies.
    # 2) If no initial policies have been set *or* policy mappings are
    # not inhibited then we don't have much to work with. All we know is
    # that a certificate must have *some* policy because if it didn't
    # have any policy then the policy tree would become null (and validation
    # would fail).
    # 
    # @return the Set of policies any of which must exist in a
    # cert's certificate policies extension in order for a cert to be selected.
    def get_matching_policies
      if (!(@matching_policies).nil?)
        initial_policies = @build_params.get_initial_policies
        if ((!initial_policies.is_empty) && (!initial_policies.contains(PolicyChecker::ANY_POLICY)) && (@build_params.is_policy_mapping_inhibited))
          initial_policies.add(PolicyChecker::ANY_POLICY)
          @matching_policies = initial_policies
        else
          # we just return an empty set to make sure that there is
          # at least a certificate policies extension in the cert
          @matching_policies = Collections.empty_set
        end
      end
      return @matching_policies
    end
    
    typesig { [X509CertSelector, Collection, Collection, ::Java::Boolean] }
    # 
    # Search the specified CertStores and add all certificates matching
    # selector to resultCerts. Self-signed certs are not useful here
    # and therefore ignored.
    # 
    # If the targetCert criterion of the selector is set, only that cert
    # is examined and the CertStores are not searched.
    # 
    # If checkAll is true, all CertStores are searched for matching certs.
    # If false, the method returns as soon as the first CertStore returns
    # a matching cert(s).
    # 
    # Returns true iff resultCerts changed (a cert was added to the collection)
    def add_matching_certs(selector, cert_stores, result_certs, check_all)
      target_cert = selector.get_certificate
      if (!(target_cert).nil?)
        # no need to search CertStores
        if (selector.match(target_cert) && !X509CertImpl.is_self_signed(target_cert, @build_params.get_sig_provider))
          if (!(Debug).nil?)
            Debug.println("Builder.addMatchingCerts: adding target cert")
          end
          return result_certs.add(target_cert)
        end
        return false
      end
      add_ = false
      cert_stores.each do |store|
        begin
          certs = store.get_certificates(selector)
          certs.each do |cert|
            if (!X509CertImpl.is_self_signed(cert, @build_params.get_sig_provider))
              if (result_certs.add(cert))
                add_ = true
              end
            end
          end
          if (!check_all && add_)
            return true
          end
        rescue CertStoreException => cse
          # if getCertificates throws a CertStoreException, we ignore
          # it and move on to the next CertStore
          if (!(Debug).nil?)
            Debug.println("Builder.addMatchingCerts, non-fatal " + "exception retrieving certs: " + (cse).to_s)
            cse.print_stack_trace
          end
        end
      end
      return add_
    end
    
    class_module.module_eval {
      typesig { [CertStore] }
      # 
      # Returns true if CertStore is local. Currently, returns true if
      # type is Collection or if it has been initialized with
      # CollectionCertStoreParameters. A new API method should be added
      # to CertStore that returns local or remote.
      def is_local_cert_store(cert_store)
        return ((cert_store.get_type == "Collection") || cert_store.get_cert_store_parameters.is_a?(CollectionCertStoreParameters))
      end
    }
    
    private
    alias_method :initialize__builder, :initialize
  end
  
end
