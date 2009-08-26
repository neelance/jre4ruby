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
  module SunCertPathBuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaSet
      include ::Java::Security::Cert
      include_const ::Java::Security::Interfaces, :DSAPublicKey
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::X509, :PKIXExtensions
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # This class is able to build certification paths in either the forward
  # or reverse directions.
  # 
  # <p> If successful, it returns a certification path which has succesfully
  # satisfied all the constraints and requirements specified in the
  # PKIXBuilderParameters object and has been validated according to the PKIX
  # path validation algorithm defined in RFC 3280.
  # 
  # <p> This implementation uses a depth-first search approach to finding
  # certification paths. If it comes to a point in which it cannot find
  # any more certificates leading to the target OR the path length is too long
  # it backtracks to previous paths until the target has been found or
  # all possible paths have been exhausted.
  # 
  # <p> This implementation is not thread-safe.
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  class SunCertPathBuilder < SunCertPathBuilderImports.const_get :CertPathBuilderSpi
    include_class_members SunCertPathBuilderImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    # private objects shared by methods
    attr_accessor :build_params
    alias_method :attr_build_params, :build_params
    undef_method :build_params
    alias_method :attr_build_params=, :build_params=
    undef_method :build_params=
    
    attr_accessor :cf
    alias_method :attr_cf, :cf
    undef_method :cf
    alias_method :attr_cf=, :cf=
    undef_method :cf=
    
    attr_accessor :path_completed
    alias_method :attr_path_completed, :path_completed
    undef_method :path_completed
    alias_method :attr_path_completed=, :path_completed=
    undef_method :path_completed=
    
    attr_accessor :target_subject_dn
    alias_method :attr_target_subject_dn, :target_subject_dn
    undef_method :target_subject_dn
    alias_method :attr_target_subject_dn=, :target_subject_dn=
    undef_method :target_subject_dn=
    
    attr_accessor :policy_tree_result
    alias_method :attr_policy_tree_result, :policy_tree_result
    undef_method :policy_tree_result
    alias_method :attr_policy_tree_result=, :policy_tree_result=
    undef_method :policy_tree_result=
    
    attr_accessor :trust_anchor
    alias_method :attr_trust_anchor, :trust_anchor
    undef_method :trust_anchor
    alias_method :attr_trust_anchor=, :trust_anchor=
    undef_method :trust_anchor=
    
    attr_accessor :final_public_key
    alias_method :attr_final_public_key, :final_public_key
    undef_method :final_public_key
    alias_method :attr_final_public_key=, :final_public_key=
    undef_method :final_public_key=
    
    attr_accessor :target_sel
    alias_method :attr_target_sel, :target_sel
    undef_method :target_sel
    alias_method :attr_target_sel=, :target_sel=
    undef_method :target_sel=
    
    attr_accessor :ordered_cert_stores
    alias_method :attr_ordered_cert_stores, :ordered_cert_stores
    undef_method :ordered_cert_stores
    alias_method :attr_ordered_cert_stores=, :ordered_cert_stores=
    undef_method :ordered_cert_stores=
    
    typesig { [] }
    # Create an instance of <code>SunCertPathBuilder</code>.
    # 
    # @throws CertPathBuilderException if an error occurs
    def initialize
      @build_params = nil
      @cf = nil
      @path_completed = false
      @target_subject_dn = nil
      @policy_tree_result = nil
      @trust_anchor = nil
      @final_public_key = nil
      @target_sel = nil
      @ordered_cert_stores = nil
      super()
      @path_completed = false
      begin
        @cf = CertificateFactory.get_instance("X.509")
      rescue CertificateException => e
        raise CertPathBuilderException.new(e)
      end
    end
    
    typesig { [CertPathParameters] }
    # Attempts to build a certification path using the Sun build
    # algorithm from a trusted anchor(s) to a target subject, which must both
    # be specified in the input parameter set. By default, this method will
    # attempt to build in the forward direction. In order to build in the
    # reverse direction, the caller needs to pass in an instance of
    # SunCertPathBuilderParameters with the buildForward flag set to false.
    # 
    # <p>The certification path that is constructed is validated
    # according to the PKIX specification.
    # 
    # @param params the parameter set for building a path. Must be an instance
    # of <code>PKIXBuilderParameters</code>.
    # @return a certification path builder result.
    # @exception CertPathBuilderException Exception thrown if builder is
    # unable to build a complete certification path from the trusted anchor(s)
    # to the target subject.
    # @throws InvalidAlgorithmParameterException if the given parameters are
    # inappropriate for this certification path builder.
    def engine_build(params)
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.engineBuild(" + RJava.cast_to_string(params) + ")")
      end
      if (!(params.is_a?(PKIXBuilderParameters)))
        raise InvalidAlgorithmParameterException.new("inappropriate " + "parameter type, must be an instance of PKIXBuilderParameters")
      end
      build_forward = true
      if (params.is_a?(SunCertPathBuilderParameters))
        build_forward = (params).get_build_forward
      end
      @build_params = params
      # Check mandatory parameters
      # Make sure that none of the trust anchors include name constraints
      # (not supported).
      @build_params.get_trust_anchors.each do |anchor|
        if (!(anchor.get_name_constraints).nil?)
          raise InvalidAlgorithmParameterException.new("name constraints in trust anchor not supported")
        end
      end
      sel = @build_params.get_target_cert_constraints
      if (!(sel.is_a?(X509CertSelector)))
        raise InvalidAlgorithmParameterException.new("the " + "targetCertConstraints parameter must be an " + "X509CertSelector")
      end
      @target_sel = sel
      @target_subject_dn = @target_sel.get_subject
      if ((@target_subject_dn).nil?)
        target_cert = @target_sel.get_certificate
        if (!(target_cert).nil?)
          @target_subject_dn = target_cert.get_subject_x500principal
        end
      end
      # reorder CertStores so that local CertStores are tried first
      @ordered_cert_stores = ArrayList.new(@build_params.get_cert_stores)
      Collections.sort(@ordered_cert_stores, CertStoreComparator.new)
      if ((@target_subject_dn).nil?)
        @target_subject_dn = get_target_subject_dn(@ordered_cert_stores, @target_sel)
      end
      if ((@target_subject_dn).nil?)
        raise InvalidAlgorithmParameterException.new("Could not determine unique target subject")
      end
      adj_list = ArrayList.new
      result = build_cert_path(build_forward, false, adj_list)
      if ((result).nil?)
        if (!(Debug).nil?)
          Debug.println("SunCertPathBuilder.engineBuild: 2nd pass")
        end
        # try again
        adj_list.clear
        result = build_cert_path(build_forward, true, adj_list)
        if ((result).nil?)
          raise SunCertPathBuilderException.new("unable to find valid " + "certification path to requested target", AdjacencyList.new(adj_list))
        end
      end
      return result
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean, JavaList] }
    def build_cert_path(build_forward, search_all_cert_stores, adj_list)
      # Init shared variables and build certification path
      @path_completed = false
      @trust_anchor = nil
      @final_public_key = nil
      @policy_tree_result = nil
      cert_path_list = LinkedList.new
      begin
        if (build_forward)
          build_forward(adj_list, cert_path_list, search_all_cert_stores)
        else
          build_reverse(adj_list, cert_path_list)
        end
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("SunCertPathBuilder.engineBuild() exception in " + "build")
          e.print_stack_trace
        end
        raise SunCertPathBuilderException.new("unable to find valid " + "certification path to requested target", e, AdjacencyList.new(adj_list))
      end
      # construct SunCertPathBuilderResult
      begin
        if (@path_completed)
          if (!(Debug).nil?)
            Debug.println("SunCertPathBuilder.engineBuild() " + "pathCompleted")
          end
          # we must return a certpath which has the target
          # as the first cert in the certpath - i.e. reverse
          # the certPathList
          Collections.reverse(cert_path_list)
          return SunCertPathBuilderResult.new(@cf.generate_cert_path(cert_path_list), @trust_anchor, @policy_tree_result, @final_public_key, AdjacencyList.new(adj_list))
        end
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("SunCertPathBuilder.engineBuild() exception " + "in wrap-up")
          e.print_stack_trace
        end
        raise SunCertPathBuilderException.new("unable to find valid " + "certification path to requested target", e, AdjacencyList.new(adj_list))
      end
      return nil
    end
    
    typesig { [JavaList, LinkedList] }
    # Private build reverse method.
    def build_reverse(adjacency_list, cert_path_list)
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.buildReverse()...")
        Debug.println("SunCertPathBuilder.buildReverse() InitialPolicies: " + RJava.cast_to_string(@build_params.get_initial_policies))
      end
      current_state = ReverseState.new
      # Initialize adjacency list
      adjacency_list.clear
      adjacency_list.add(LinkedList.new)
      # Perform a search using each trust anchor, until a valid
      # path is found
      iter = @build_params.get_trust_anchors.iterator
      while (iter.has_next)
        anchor = iter.next_
        # check if anchor satisfies target constraints
        if (anchor_is_target(anchor, @target_sel))
          @trust_anchor = anchor
          @path_completed = true
          @final_public_key = anchor.get_trusted_cert.get_public_key
          break
        end
        # Initialize current state
        current_state.init_state(@build_params.get_max_path_length, @build_params.is_explicit_policy_required, @build_params.is_policy_mapping_inhibited, @build_params.is_any_policy_inhibited, @build_params.get_cert_path_checkers)
        current_state.update_state(anchor)
        # init the crl checker
        current_state.attr_crl_checker = CrlRevocationChecker.new(nil, @build_params)
        begin
          depth_first_search_reverse(nil, current_state, ReverseBuilder.new(@build_params, @target_subject_dn), adjacency_list, cert_path_list)
        rescue JavaException => e
          # continue on error if more anchors to try
          if (iter.has_next)
            next
          else
            raise e
          end
        end
        # break out of loop if search is successful
        break
      end
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.buildReverse() returned from " + "depthFirstSearchReverse()")
        Debug.println("SunCertPathBuilder.buildReverse() " + "certPathList.size: " + RJava.cast_to_string(cert_path_list.size))
      end
    end
    
    typesig { [JavaList, LinkedList, ::Java::Boolean] }
    # Private build forward method.
    def build_forward(adjacency_list, cert_path_list, search_all_cert_stores)
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.buildForward()...")
      end
      # Initialize current state
      current_state = ForwardState.new
      current_state.init_state(@build_params.get_cert_path_checkers)
      # Initialize adjacency list
      adjacency_list.clear
      adjacency_list.add(LinkedList.new)
      # init the crl checker
      current_state.attr_crl_checker = CrlRevocationChecker.new(nil, @build_params)
      depth_first_search_forward(@target_subject_dn, current_state, ForwardBuilder.new(@build_params, @target_subject_dn, search_all_cert_stores), adjacency_list, cert_path_list)
    end
    
    typesig { [X500Principal, ForwardState, ForwardBuilder, JavaList, LinkedList] }
    # This method performs a depth first search for a certification
    # path while building forward which meets the requirements set in
    # the parameters object.
    # It uses an adjacency list to store all certificates which were
    # tried (i.e. at one time added to the path - they may not end up in
    # the final path if backtracking occurs). This information can
    # be used later to debug or demo the build.
    # 
    # See "Data Structure and Algorithms, by Aho, Hopcroft, and Ullman"
    # for an explanation of the DFS algorithm.
    # 
    # @param dN the distinguished name being currently searched for certs
    # @param currentState the current PKIX validation state
    def depth_first_search_forward(d_n, current_state, builder, adj_list, cert_path_list)
      # XXX This method should probably catch & handle exceptions
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.depthFirstSearchForward(" + RJava.cast_to_string(d_n) + ", " + RJava.cast_to_string(current_state.to_s) + ")")
      end
      # Find all the certificates issued to dN which
      # satisfy the PKIX certification path constraints.
      vertices = add_vertices(builder.get_matching_certs(current_state, @ordered_cert_stores), adj_list)
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.depthFirstSearchForward(): " + "certs.size=" + RJava.cast_to_string(vertices.size))
      end
      # For each cert in the collection, verify anything
      # that hasn't been checked yet (signature, revocation, etc)
      # and check for loops. Call depthFirstSearchForward()
      # recursively for each good cert.
      vertices.each do |vertex|
        catch(:next_vertices) do
          # Restore state to currentState each time through the loop.
          # This is important because some of the user-defined
          # checkers modify the state, which MUST be restored if
          # the cert eventually fails to lead to the target and
          # the next matching cert is tried.
          next_state = current_state.clone
          cert = vertex.get_certificate
          begin
            builder.verify_cert(cert, next_state, cert_path_list)
          rescue GeneralSecurityException => gse
            if (!(Debug).nil?)
              Debug.println("SunCertPathBuilder.depthFirstSearchForward()" + ": validation failed: " + RJava.cast_to_string(gse))
              gse.print_stack_trace
            end
            vertex.set_throwable(gse)
            next
          end
          # Certificate is good.
          # If cert completes the path,
          # process userCheckers that don't support forward checking
          # and process policies over whole path
          # and backtrack appropriately if there is a failure
          # else if cert does not complete the path,
          # add it to the path
          if (builder.is_path_completed(cert))
            basic_checker = nil
            if (!(Debug).nil?)
              Debug.println("SunCertPathBuilder.depthFirstSearchForward()" + ": commencing final verification")
            end
            appended_certs = ArrayList.new(cert_path_list)
            # if the trust anchor selected is specified as a trusted
            # public key rather than a trusted cert, then verify this
            # cert (which is signed by the trusted public key), but
            # don't add it yet to the certPathList
            if ((builder.attr_trust_anchor.get_trusted_cert).nil?)
              appended_certs.add(0, cert)
            end
            init_exp_pol_set = HashSet.new(1)
            init_exp_pol_set.add(PolicyChecker::ANY_POLICY)
            root_node = PolicyNodeImpl.new(nil, PolicyChecker::ANY_POLICY, nil, false, init_exp_pol_set, false)
            policy_checker = PolicyChecker.new(@build_params.get_initial_policies, appended_certs.size, @build_params.is_explicit_policy_required, @build_params.is_policy_mapping_inhibited, @build_params.is_any_policy_inhibited, @build_params.get_policy_qualifiers_rejected, root_node)
            user_checkers = ArrayList.new(@build_params.get_cert_path_checkers)
            must_check = 0
            user_checkers.add(must_check, policy_checker)
            must_check += 1
            if (next_state.key_params_needed)
              root_key = cert.get_public_key
              if ((builder.attr_trust_anchor.get_trusted_cert).nil?)
                root_key = builder.attr_trust_anchor.get_capublic_key
                if (!(Debug).nil?)
                  Debug.println("SunCertPathBuilder.depthFirstSearchForward" + " using buildParams public key: " + RJava.cast_to_string(root_key.to_s))
                end
              end
              anchor = TrustAnchor.new(cert.get_subject_x500principal, root_key, nil)
              basic_checker = BasicChecker.new(anchor, builder.attr_date, @build_params.get_sig_provider, true)
              user_checkers.add(must_check, basic_checker)
              must_check += 1
              if (@build_params.is_revocation_enabled)
                user_checkers.add(must_check, CrlRevocationChecker.new(anchor, @build_params))
                must_check += 1
              end
            end
            i = 0
            while i < appended_certs.size
              curr_cert = appended_certs.get(i)
              if (!(Debug).nil?)
                Debug.println("current subject = " + RJava.cast_to_string(curr_cert.get_subject_x500principal))
              end
              unres_crit_exts = curr_cert.get_critical_extension_oids
              if ((unres_crit_exts).nil?)
                unres_crit_exts = Collections.empty_set
              end
              j = 0
              while j < user_checkers.size
                curr_checker = user_checkers.get(j)
                if (j < must_check || !curr_checker.is_forward_checking_supported)
                  if ((i).equal?(0))
                    curr_checker.init(false)
                  end
                  begin
                    curr_checker.check(curr_cert, unres_crit_exts)
                  rescue CertPathValidatorException => cpve
                    if (!(Debug).nil?)
                      Debug.println("SunCertPathBuilder.depthFirstSearchForward(): " + "final verification failed: " + RJava.cast_to_string(cpve))
                    end
                    vertex.set_throwable(cpve)
                    throw :next_vertices, :thrown
                  end
                end
                j += 1
              end
              # Remove extensions from user checkers that support
              # forward checking. After this step, we will have
              # removed all extensions that all user checkers
              # are capable of processing.
              @build_params.get_cert_path_checkers.each do |checker|
                if (checker.is_forward_checking_supported)
                  supp_exts = checker.get_supported_extensions
                  if (!(supp_exts).nil?)
                    unres_crit_exts.remove_all(supp_exts)
                  end
                end
              end
              if (!unres_crit_exts.is_empty)
                unres_crit_exts.remove(PKIXExtensions::BasicConstraints_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::NameConstraints_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::CertificatePolicies_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::PolicyMappings_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::PolicyConstraints_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::InhibitAnyPolicy_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::SubjectAlternativeName_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::KeyUsage_Id.to_s)
                unres_crit_exts.remove(PKIXExtensions::ExtendedKeyUsage_Id.to_s)
                if (!unres_crit_exts.is_empty)
                  raise CertPathValidatorException.new("unrecognized " + "critical extension(s)")
                end
              end
              i += 1
            end
            if (!(Debug).nil?)
              Debug.println("SunCertPathBuilder.depthFirstSearchForward()" + ": final verification succeeded - path completed!")
            end
            @path_completed = true
            # if the user specified a trusted public key rather than
            # trusted certs, then add this cert (which is signed by
            # the trusted public key) to the certPathList
            if ((builder.attr_trust_anchor.get_trusted_cert).nil?)
              builder.add_cert_to_path(cert, cert_path_list)
            end
            # Save the trust anchor
            @trust_anchor = builder.attr_trust_anchor
            # Extract and save the final target public key
            if (!(basic_checker).nil?)
              @final_public_key = basic_checker.get_public_key
            else
              final_cert = nil
              if ((cert_path_list.size).equal?(0))
                final_cert = builder.attr_trust_anchor.get_trusted_cert
              else
                final_cert = cert_path_list.get(cert_path_list.size - 1)
              end
              @final_public_key = final_cert.get_public_key
            end
            @policy_tree_result = policy_checker.get_policy_tree
            return
          else
            builder.add_cert_to_path(cert, cert_path_list)
          end
          # Update the PKIX state
          next_state.update_state(cert)
          # Append an entry for cert in adjacency list and
          # set index for current vertex.
          adj_list.add(LinkedList.new)
          vertex.set_index(adj_list.size - 1)
          # recursively search for matching certs at next dN
          depth_first_search_forward(cert.get_issuer_x500principal, next_state, builder, adj_list, cert_path_list)
          # If path has been completed, return ASAP!
          if (@path_completed)
            return
          else
            # If we get here, it means we have searched all possible
            # certs issued by the dN w/o finding any matching certs.
            # This means we have to backtrack to the previous cert in
            # the path and try some other paths.
            if (!(Debug).nil?)
              Debug.println("SunCertPathBuilder.depthFirstSearchForward()" + ": backtracking")
            end
            builder.remove_final_cert_from_path(cert_path_list)
          end
        end
      end
    end
    
    typesig { [X500Principal, ReverseState, ReverseBuilder, JavaList, LinkedList] }
    # This method performs a depth first search for a certification
    # path while building reverse which meets the requirements set in
    # the parameters object.
    # It uses an adjacency list to store all certificates which were
    # tried (i.e. at one time added to the path - they may not end up in
    # the final path if backtracking occurs). This information can
    # be used later to debug or demo the build.
    # 
    # See "Data Structure and Algorithms, by Aho, Hopcroft, and Ullman"
    # for an explanation of the DFS algorithm.
    # 
    # @param dN the distinguished name being currently searched for certs
    # @param currentState the current PKIX validation state
    def depth_first_search_reverse(d_n, current_state, builder, adj_list, cert_path_list)
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.depthFirstSearchReverse(" + RJava.cast_to_string(d_n) + ", " + RJava.cast_to_string(current_state.to_s) + ")")
      end
      # Find all the certificates issued by dN which
      # satisfy the PKIX certification path constraints.
      vertices = add_vertices(builder.get_matching_certs(current_state, @ordered_cert_stores), adj_list)
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.depthFirstSearchReverse(): " + "certs.size=" + RJava.cast_to_string(vertices.size))
      end
      # For each cert in the collection, verify anything
      # that hasn't been checked yet (signature, revocation, etc)
      # and check for loops. Call depthFirstSearchReverse()
      # recursively for each good cert.
      vertices.each do |vertex|
        # Restore state to currentState each time through the loop.
        # This is important because some of the user-defined
        # checkers modify the state, which MUST be restored if
        # the cert eventually fails to lead to the target and
        # the next matching cert is tried.
        next_state = current_state.clone
        cert = vertex.get_certificate
        begin
          builder.verify_cert(cert, next_state, cert_path_list)
        rescue GeneralSecurityException => gse
          if (!(Debug).nil?)
            Debug.println("SunCertPathBuilder.depthFirstSearchReverse()" + ": validation failed: " + RJava.cast_to_string(gse))
          end
          vertex.set_throwable(gse)
          next
        end
        # Certificate is good, add it to the path (if it isn't a
        # self-signed cert) and update state
        if (!current_state.is_initial)
          builder.add_cert_to_path(cert, cert_path_list)
        end
        # save trust anchor
        @trust_anchor = current_state.attr_trust_anchor
        # Check if path is completed, return ASAP if so.
        if (builder.is_path_completed(cert))
          if (!(Debug).nil?)
            Debug.println("SunCertPathBuilder.depthFirstSearchReverse()" + ": path completed!")
          end
          @path_completed = true
          root_node = next_state.attr_root_node
          if ((root_node).nil?)
            @policy_tree_result = nil
          else
            @policy_tree_result = root_node.copy_tree
            (@policy_tree_result).set_immutable
          end
          # Extract and save the final target public key
          @final_public_key = cert.get_public_key
          if (@final_public_key.is_a?(DSAPublicKey) && ((@final_public_key).get_params).nil?)
            @final_public_key = BasicChecker.make_inherited_params_key(@final_public_key, current_state.attr_pub_key)
          end
          return
        end
        # Update the PKIX state
        next_state.update_state(cert)
        # Append an entry for cert in adjacency list and
        # set index for current vertex.
        adj_list.add(LinkedList.new)
        vertex.set_index(adj_list.size - 1)
        # recursively search for matching certs at next dN
        depth_first_search_reverse(cert.get_subject_x500principal, next_state, builder, adj_list, cert_path_list)
        # If path has been completed, return ASAP!
        if (@path_completed)
          return
        else
          # If we get here, it means we have searched all possible
          # certs issued by the dN w/o finding any matching certs. This
          # means we have to backtrack to the previous cert in the path
          # and try some other paths.
          if (!(Debug).nil?)
            Debug.println("SunCertPathBuilder.depthFirstSearchReverse()" + ": backtracking")
          end
          if (!current_state.is_initial)
            builder.remove_final_cert_from_path(cert_path_list)
          end
        end
      end
      if (!(Debug).nil?)
        Debug.println("SunCertPathBuilder.depthFirstSearchReverse() all " + "certs in this adjacency list checked")
      end
    end
    
    typesig { [Collection, JavaList] }
    # Adds a collection of matching certificates to the
    # adjacency list.
    def add_vertices(certs, adj_list)
      l = adj_list.get(adj_list.size - 1)
      certs.each do |cert|
        v = Vertex.new(cert)
        l.add(v)
      end
      return l
    end
    
    typesig { [TrustAnchor, X509CertSelector] }
    # Returns true if trust anchor certificate matches specified
    # certificate constraints.
    def anchor_is_target(anchor, sel)
      anchor_cert = anchor.get_trusted_cert
      if (!(anchor_cert).nil?)
        return sel.match(anchor_cert)
      end
      return false
    end
    
    class_module.module_eval {
      # Comparator that orders CertStores so that local CertStores come before
      # remote CertStores.
      const_set_lazy(:CertStoreComparator) { Class.new do
        include_class_members SunCertPathBuilder
        include Comparator
        
        typesig { [self::CertStore, self::CertStore] }
        def compare(store1, store2)
          if (Builder.is_local_cert_store(store1))
            return -1
          else
            return 1
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__cert_store_comparator, :initialize
      end }
    }
    
    typesig { [JavaList, X509CertSelector] }
    # Returns the target subject DN from the first X509Certificate that
    # is fetched that matches the specified X509CertSelector.
    def get_target_subject_dn(stores, target_sel)
      stores.each do |store|
        begin
          target_certs = store.get_certificates(target_sel)
          if (!target_certs.is_empty)
            target_cert = target_certs.iterator.next_
            return target_cert.get_subject_x500principal
          end
        rescue CertStoreException => e
          # ignore but log it
          if (!(Debug).nil?)
            Debug.println("SunCertPathBuilder.getTargetSubjectDN: " + "non-fatal exception retrieving certs: " + RJava.cast_to_string(e))
            e.print_stack_trace
          end
        end
      end
      return nil
    end
    
    private
    alias_method :initialize__sun_cert_path_builder, :initialize
  end
  
end
