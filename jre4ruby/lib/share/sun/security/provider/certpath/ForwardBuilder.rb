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
  module ForwardBuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include ::Java::Util
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :CertStore
      include_const ::Java::Security::Cert, :CertStoreException
      include_const ::Java::Security::Cert, :PKIXBuilderParameters
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :TrustAnchor
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :X509CertSelector
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :AccessDescription
      include_const ::Sun::Security::X509, :AuthorityInfoAccessExtension
      include_const ::Sun::Security::X509, :PKIXExtensions
      include_const ::Sun::Security::X509, :PolicyMappingsExtension
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::X509, :X509CertImpl
    }
  end
  
  # This class represents a forward builder, which is able to retrieve
  # matching certificates from CertStores and verify a particular certificate
  # against a ForwardState.
  # 
  # @since       1.4
  # @author      Yassir Elley
  # @author      Sean Mullan
  class ForwardBuilder < ForwardBuilderImports.const_get :Builder
    include_class_members ForwardBuilderImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :trusted_certs
    alias_method :attr_trusted_certs, :trusted_certs
    undef_method :trusted_certs
    alias_method :attr_trusted_certs=, :trusted_certs=
    undef_method :trusted_certs=
    
    attr_accessor :trusted_subject_dns
    alias_method :attr_trusted_subject_dns, :trusted_subject_dns
    undef_method :trusted_subject_dns
    alias_method :attr_trusted_subject_dns=, :trusted_subject_dns=
    undef_method :trusted_subject_dns=
    
    attr_accessor :trust_anchors
    alias_method :attr_trust_anchors, :trust_anchors
    undef_method :trust_anchors
    alias_method :attr_trust_anchors=, :trust_anchors=
    undef_method :trust_anchors=
    
    attr_accessor :ee_selector
    alias_method :attr_ee_selector, :ee_selector
    undef_method :ee_selector
    alias_method :attr_ee_selector=, :ee_selector=
    undef_method :ee_selector=
    
    attr_accessor :ca_selector
    alias_method :attr_ca_selector, :ca_selector
    undef_method :ca_selector
    alias_method :attr_ca_selector=, :ca_selector=
    undef_method :ca_selector=
    
    attr_accessor :ca_target_selector
    alias_method :attr_ca_target_selector, :ca_target_selector
    undef_method :ca_target_selector
    alias_method :attr_ca_target_selector=, :ca_target_selector=
    undef_method :ca_target_selector=
    
    attr_accessor :trust_anchor
    alias_method :attr_trust_anchor, :trust_anchor
    undef_method :trust_anchor
    alias_method :attr_trust_anchor=, :trust_anchor=
    undef_method :trust_anchor=
    
    attr_accessor :comparator
    alias_method :attr_comparator, :comparator
    undef_method :comparator
    alias_method :attr_comparator=, :comparator=
    undef_method :comparator=
    
    attr_accessor :search_all_cert_stores
    alias_method :attr_search_all_cert_stores, :search_all_cert_stores
    undef_method :search_all_cert_stores
    alias_method :attr_search_all_cert_stores=, :search_all_cert_stores=
    undef_method :search_all_cert_stores=
    
    typesig { [PKIXBuilderParameters, X500Principal, ::Java::Boolean] }
    # Initialize the builder with the input parameters.
    # 
    # @param params the parameter set used to build a certification path
    def initialize(build_params, target_subject_dn, search_all_cert_stores)
      @trusted_certs = nil
      @trusted_subject_dns = nil
      @trust_anchors = nil
      @ee_selector = nil
      @ca_selector = nil
      @ca_target_selector = nil
      @trust_anchor = nil
      @comparator = nil
      @search_all_cert_stores = false
      super(build_params, target_subject_dn)
      @search_all_cert_stores = true
      # populate sets of trusted certificates and subject DNs
      @trust_anchors = build_params.get_trust_anchors
      @trusted_certs = HashSet.new(@trust_anchors.size)
      @trusted_subject_dns = HashSet.new(@trust_anchors.size)
      @trust_anchors.each do |anchor|
        trusted_cert = anchor.get_trusted_cert
        if (!(trusted_cert).nil?)
          @trusted_certs.add(trusted_cert)
          @trusted_subject_dns.add(trusted_cert.get_subject_x500principal)
        else
          @trusted_subject_dns.add(anchor.get_ca)
        end
      end
      @comparator = PKIXCertComparator.new(@trusted_subject_dns)
      @search_all_cert_stores = search_all_cert_stores
    end
    
    typesig { [State, JavaList] }
    # Retrieves all certs from the specified CertStores that satisfy the
    # requirements specified in the parameters and the current
    # PKIX state (name constraints, policy constraints, etc).
    # 
    # @param currentState the current state.
    # Must be an instance of <code>ForwardState</code>
    # @param certStores list of CertStores
    def get_matching_certs(current_state, cert_stores)
      if (!(Debug).nil?)
        Debug.println("ForwardBuilder.getMatchingCerts()...")
      end
      curr_state = current_state
      # We store certs in a Set because we don't want duplicates.
      # As each cert is added, it is sorted based on the PKIXCertComparator
      # algorithm.
      certs = TreeSet.new(@comparator)
      # Only look for EE certs if search has just started.
      if (curr_state.is_initial)
        get_matching_eecerts(curr_state, cert_stores, certs)
      end
      get_matching_cacerts(curr_state, cert_stores, certs)
      return certs
    end
    
    typesig { [ForwardState, JavaList, Collection] }
    # Retrieves all end-entity certificates which satisfy constraints
    # and requirements specified in the parameters and PKIX state.
    def get_matching_eecerts(current_state, cert_stores, ee_certs)
      if (!(Debug).nil?)
        Debug.println("ForwardBuilder.getMatchingEECerts()...")
      end
      # Compose a certificate matching rule to filter out
      # certs which don't satisfy constraints
      # 
      # First, retrieve clone of current target cert constraints,
      # and then add more selection criteria based on current validation
      # state. Since selector never changes, cache local copy & reuse.
      if ((@ee_selector).nil?)
        @ee_selector = self.attr_target_cert_constraints.clone
        # Match on certificate validity date
        @ee_selector.set_certificate_valid(self.attr_date)
        # Policy processing optimizations
        if (self.attr_build_params.is_explicit_policy_required)
          @ee_selector.set_policy(get_matching_policies)
        end
        # Require EE certs
        @ee_selector.set_basic_constraints(-2)
      end
      # Retrieve matching EE certs from CertStores
      add_matching_certs(@ee_selector, cert_stores, ee_certs, @search_all_cert_stores)
    end
    
    typesig { [ForwardState, JavaList, Collection] }
    # Retrieves all CA certificates which satisfy constraints
    # and requirements specified in the parameters and PKIX state.
    def get_matching_cacerts(current_state, cert_stores, ca_certs)
      if (!(Debug).nil?)
        Debug.println("ForwardBuilder.getMatchingCACerts()...")
      end
      initial_size = ca_certs.size
      # Compose a CertSelector to filter out
      # certs which do not satisfy requirements.
      sel = nil
      if (current_state.is_initial)
        # This means a CA is the target, so match on same stuff as
        # getMatchingEECerts
        if (!(Debug).nil?)
          Debug.println("ForwardBuilder.getMatchingCACerts(): ca is target")
        end
        if ((@ca_target_selector).nil?)
          @ca_target_selector = self.attr_target_cert_constraints.clone
          # Match on certificate validity date
          @ca_target_selector.set_certificate_valid(self.attr_date)
          # Policy processing optimizations
          if (self.attr_build_params.is_explicit_policy_required)
            @ca_target_selector.set_policy(get_matching_policies)
          end
        end
        # Require CA certs with a pathLenConstraint that allows
        # at least as many CA certs that have already been traversed
        @ca_target_selector.set_basic_constraints(current_state.attr_traversed_cacerts)
        sel = @ca_target_selector
      else
        if ((@ca_selector).nil?)
          @ca_selector = X509CertSelector.new
          # Match on certificate validity date.
          @ca_selector.set_certificate_valid(self.attr_date)
          # Policy processing optimizations
          if (self.attr_build_params.is_explicit_policy_required)
            @ca_selector.set_policy(get_matching_policies)
          end
        end
        # Match on subject (issuer of previous cert)
        @ca_selector.set_subject(current_state.attr_issuer_dn)
        # Match on subjectNamesTraversed (both DNs and AltNames)
        # (checks that current cert's name constraints permit it
        # to certify all the DNs and AltNames that have been traversed)
        CertPathHelper.set_path_to_names(@ca_selector, current_state.attr_subject_names_traversed)
        # Require CA certs with a pathLenConstraint that allows
        # at least as many CA certs that have already been traversed
        @ca_selector.set_basic_constraints(current_state.attr_traversed_cacerts)
        sel = @ca_selector
      end
      # Check if any of the trusted certs could be a match.
      # Since we are not validating the trusted cert, we can't
      # re-use the selector we've built up (sel) - we need
      # to use a new selector (trustedSel)
      trusted_sel = nil
      if (current_state.is_initial)
        trusted_sel = self.attr_target_cert_constraints
      else
        trusted_sel = X509CertSelector.new
        trusted_sel.set_subject(current_state.attr_issuer_dn)
      end
      found_matching_cert = false
      @trusted_certs.each do |trustedCert|
        if (trusted_sel.match(trusted_cert))
          if (!(Debug).nil?)
            Debug.println("ForwardBuilder.getMatchingCACerts: " + "found matching trust anchor")
          end
          if (ca_certs.add(trusted_cert) && !@search_all_cert_stores)
            return
          end
        end
      end
      # If we have already traversed as many CA certs as the maxPathLength
      # will allow us to, then we don't bother looking through these
      # certificate pairs. If maxPathLength has a value of -1, this
      # means it is unconstrained, so we always look through the
      # certificate pairs.
      if (current_state.is_initial || ((self.attr_build_params.get_max_path_length).equal?(-1)) || (self.attr_build_params.get_max_path_length > current_state.attr_traversed_cacerts))
        if (add_matching_certs(sel, cert_stores, ca_certs, @search_all_cert_stores) && !@search_all_cert_stores)
          return
        end
      end
      if (!current_state.is_initial && Builder::USE_AIA)
        # check for AuthorityInformationAccess extension
        aia_ext = current_state.attr_cert.get_authority_info_access_extension
        if (!(aia_ext).nil?)
          get_certs(aia_ext, ca_certs)
        end
      end
      if (!(Debug).nil?)
        num_certs = ca_certs.size - initial_size
        Debug.println("ForwardBuilder.getMatchingCACerts: found " + RJava.cast_to_string(num_certs) + " CA certs")
      end
    end
    
    typesig { [AuthorityInfoAccessExtension, Collection] }
    # Download Certificates from the given AIA and add them to the
    # specified Collection.
    def get_certs(aia_ext, certs)
      if ((Builder::USE_AIA).equal?(false))
        return false
      end
      ad_list = aia_ext.get_access_descriptions
      if ((ad_list).nil? || ad_list.is_empty)
        return false
      end
      add_ = false
      ad_list.each do |ad|
        cs = URICertStore.get_instance(ad)
        begin
          if (certs.add_all(cs.get_certificates(@ca_selector)))
            add_ = true
            if (!@search_all_cert_stores)
              return true
            end
          end
        rescue CertStoreException => cse
          if (!(Debug).nil?)
            Debug.println("exception getting certs from CertStore:")
            cse.print_stack_trace
          end
          next
        end
      end
      return add_
    end
    
    class_module.module_eval {
      # This inner class compares 2 PKIX certificates according to which
      # should be tried first when building a path from the target.
      # The preference order is as follows:
      # 
      # Given trusted certificate(s):
      # Subject:ou=D,ou=C,o=B,c=A
      # 
      # Preference order for current cert:
      # 
      # 1) Issuer matches a trusted subject
      # Issuer: ou=D,ou=C,o=B,c=A
      # 
      # 2) Issuer is a descendant of a trusted subject (in order of
      # number of links to the trusted subject)
      # a) Issuer: ou=E,ou=D,ou=C,o=B,c=A        [links=1]
      # b) Issuer: ou=F,ou=E,ou=D,ou=C,ou=B,c=A  [links=2]
      # 
      # 3) Issuer is an ancestor of a trusted subject (in order of number of
      # links to the trusted subject)
      # a) Issuer: ou=C,o=B,c=A [links=1]
      # b) Issuer: o=B,c=A      [links=2]
      # 
      # 4) Issuer is in the same namespace as a trusted subject (in order of
      # number of links to the trusted subject)
      # a) Issuer: ou=G,ou=C,o=B,c=A  [links=2]
      # b) Issuer: ou=H,o=B,c=A       [links=3]
      # 
      # 5) Issuer is an ancestor of certificate subject (in order of number
      # of links to the certificate subject)
      # a) Issuer:  ou=K,o=J,c=A
      # Subject: ou=L,ou=K,o=J,c=A
      # b) Issuer:  o=J,c=A
      # Subject: ou=L,ou=K,0=J,c=A
      # 
      # 6) Any other certificates
      const_set_lazy(:PKIXCertComparator) { Class.new do
        include_class_members ForwardBuilder
        include Comparator
        
        class_module.module_eval {
          const_set_lazy(:METHOD_NME) { "PKIXCertComparator.compare()" }
          const_attr_reader  :METHOD_NME
        }
        
        attr_accessor :trusted_subject_dns
        alias_method :attr_trusted_subject_dns, :trusted_subject_dns
        undef_method :trusted_subject_dns
        alias_method :attr_trusted_subject_dns=, :trusted_subject_dns=
        undef_method :trusted_subject_dns=
        
        typesig { [class_self::JavaSet] }
        def initialize(trusted_subject_dns)
          @trusted_subject_dns = nil
          @trusted_subject_dns = trusted_subject_dns
        end
        
        typesig { [class_self::X509Certificate, class_self::X509Certificate] }
        # @param oCert1 First X509Certificate to be compared
        # @param oCert2 Second X509Certificate to be compared
        # @return -1 if oCert1 is preferable to oCert2, or
        # if oCert1 and oCert2 are equally preferable (in this
        # case it doesn't matter which is preferable, but we don't
        # return 0 because the comparator would behave strangely
        # when used in a SortedSet).
        # 1 if oCert2 is preferable to oCert1
        # 0 if oCert1.equals(oCert2). We only return 0 if the
        # certs are equal so that this comparator behaves
        # correctly when used in a SortedSet.
        # @throws ClassCastException if either argument is not of type
        # X509Certificate
        def compare(o_cert1, o_cert2)
          # if certs are the same, return 0
          if ((o_cert1 == o_cert2))
            return 0
          end
          c_issuer1 = o_cert1.get_issuer_x500principal
          c_issuer2 = o_cert2.get_issuer_x500principal
          c_issuer1name = X500Name.as_x500name(c_issuer1)
          c_issuer2name = X500Name.as_x500name(c_issuer2)
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " o1 Issuer:  " + RJava.cast_to_string(c_issuer1))
            Debug.println(self.class::METHOD_NME + " o2 Issuer:  " + RJava.cast_to_string(c_issuer2))
          end
          # If one cert's issuer matches a trusted subject, then it is
          # preferable.
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " MATCH TRUSTED SUBJECT TEST...")
          end
          m1 = @trusted_subject_dns.contains(c_issuer1)
          m2 = @trusted_subject_dns.contains(c_issuer2)
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " m1: " + RJava.cast_to_string(m1))
            Debug.println(self.class::METHOD_NME + " m2: " + RJava.cast_to_string(m2))
          end
          if (m1 && m2)
            return -1
          else
            if (m1)
              return -1
            else
              if (m2)
                return 1
              end
            end
          end
          # If one cert's issuer is a naming descendant of a trusted subject,
          # then it is preferable, in order of increasing naming distance.
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " NAMING DESCENDANT TEST...")
          end
          @trusted_subject_dns.each do |tSubject|
            t_subject_name = X500Name.as_x500name(t_subject)
            distance_tto1 = Builder.distance(t_subject_name, c_issuer1name, -1)
            distance_tto2 = Builder.distance(t_subject_name, c_issuer2name, -1)
            if (!(Debug).nil?)
              Debug.println(self.class::METHOD_NME + " distanceTto1: " + RJava.cast_to_string(distance_tto1))
              Debug.println(self.class::METHOD_NME + " distanceTto2: " + RJava.cast_to_string(distance_tto2))
            end
            if (distance_tto1 > 0 || distance_tto2 > 0)
              if ((distance_tto1).equal?(distance_tto2))
                return -1
              else
                if (distance_tto1 > 0 && distance_tto2 <= 0)
                  return -1
                else
                  if (distance_tto1 <= 0 && distance_tto2 > 0)
                    return 1
                  else
                    if (distance_tto1 < distance_tto2)
                      return -1
                    else
                      # distanceTto1 > distanceTto2
                      return 1
                    end
                  end
                end
              end
            end
          end
          # If one cert's issuer is a naming ancestor of a trusted subject,
          # then it is preferable, in order of increasing naming distance.
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " NAMING ANCESTOR TEST...")
          end
          @trusted_subject_dns.each do |tSubject|
            t_subject_name = X500Name.as_x500name(t_subject)
            distance_tto1 = Builder.distance(t_subject_name, c_issuer1name, JavaInteger::MAX_VALUE)
            distance_tto2 = Builder.distance(t_subject_name, c_issuer2name, JavaInteger::MAX_VALUE)
            if (!(Debug).nil?)
              Debug.println(self.class::METHOD_NME + " distanceTto1: " + RJava.cast_to_string(distance_tto1))
              Debug.println(self.class::METHOD_NME + " distanceTto2: " + RJava.cast_to_string(distance_tto2))
            end
            if (distance_tto1 < 0 || distance_tto2 < 0)
              if ((distance_tto1).equal?(distance_tto2))
                return -1
              else
                if (distance_tto1 < 0 && distance_tto2 >= 0)
                  return -1
                else
                  if (distance_tto1 >= 0 && distance_tto2 < 0)
                    return 1
                  else
                    if (distance_tto1 > distance_tto2)
                      return -1
                    else
                      return 1
                    end
                  end
                end
              end
            end
          end
          # If one cert's issuer is in the same namespace as a trusted
          # subject, then it is preferable, in order of increasing naming
          # distance.
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " SAME NAMESPACE AS TRUSTED TEST...")
          end
          @trusted_subject_dns.each do |tSubject|
            t_subject_name = X500Name.as_x500name(t_subject)
            t_ao1 = t_subject_name.common_ancestor(c_issuer1name)
            t_ao2 = t_subject_name.common_ancestor(c_issuer2name)
            if (!(Debug).nil?)
              Debug.println(self.class::METHOD_NME + " tAo1: " + RJava.cast_to_string(String.value_of(t_ao1)))
              Debug.println(self.class::METHOD_NME + " tAo2: " + RJava.cast_to_string(String.value_of(t_ao2)))
            end
            if (!(t_ao1).nil? || !(t_ao2).nil?)
              if (!(t_ao1).nil? && !(t_ao2).nil?)
                hops_tto1 = Builder.hops(t_subject_name, c_issuer1name, JavaInteger::MAX_VALUE)
                hops_tto2 = Builder.hops(t_subject_name, c_issuer2name, JavaInteger::MAX_VALUE)
                if (!(Debug).nil?)
                  Debug.println(self.class::METHOD_NME + " hopsTto1: " + RJava.cast_to_string(hops_tto1))
                  Debug.println(self.class::METHOD_NME + " hopsTto2: " + RJava.cast_to_string(hops_tto2))
                end
                if ((hops_tto1).equal?(hops_tto2))
                else
                  if (hops_tto1 > hops_tto2)
                    return 1
                  else
                    # hopsTto1 < hopsTto2
                    return -1
                  end
                end
              else
                if ((t_ao1).nil?)
                  return 1
                else
                  return -1
                end
              end
            end
          end
          # If one cert's issuer is an ancestor of that cert's subject,
          # then it is preferable, in order of increasing naming distance.
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " CERT ISSUER/SUBJECT COMPARISON TEST...")
          end
          c_subject1 = o_cert1.get_subject_x500principal
          c_subject2 = o_cert2.get_subject_x500principal
          c_subject1name = X500Name.as_x500name(c_subject1)
          c_subject2name = X500Name.as_x500name(c_subject2)
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " o1 Subject: " + RJava.cast_to_string(c_subject1))
            Debug.println(self.class::METHOD_NME + " o2 Subject: " + RJava.cast_to_string(c_subject2))
          end
          distance_sto_i1 = Builder.distance(c_subject1name, c_issuer1name, JavaInteger::MAX_VALUE)
          distance_sto_i2 = Builder.distance(c_subject2name, c_issuer2name, JavaInteger::MAX_VALUE)
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " distanceStoI1: " + RJava.cast_to_string(distance_sto_i1))
            Debug.println(self.class::METHOD_NME + " distanceStoI2: " + RJava.cast_to_string(distance_sto_i2))
          end
          if (distance_sto_i2 > distance_sto_i1)
            return -1
          else
            if (distance_sto_i2 < distance_sto_i1)
              return 1
            end
          end
          # Otherwise, certs are equally preferable.
          if (!(Debug).nil?)
            Debug.println(self.class::METHOD_NME + " no tests matched; RETURN 0")
          end
          return -1
        end
        
        private
        alias_method :initialize__pkixcert_comparator, :initialize
      end }
    }
    
    typesig { [X509Certificate, State, JavaList] }
    # Verifies a matching certificate.
    # 
    # This method executes the validation steps in the PKIX path
    # validation algorithm <draft-ietf-pkix-new-part1-08.txt> which were
    # not satisfied by the selection criteria used by getCertificates()
    # to find the certs and only the steps that can be executed in a
    # forward direction (target to trust anchor). Those steps that can
    # only be executed in a reverse direction are deferred until the
    # complete path has been built.
    # 
    # Trust anchor certs are not validated, but are used to verify the
    # signature and revocation status of the previous cert.
    # 
    # If the last certificate is being verified (the one whose subject
    # matches the target subject, then steps in 6.1.4 of the PKIX
    # Certification Path Validation algorithm are NOT executed,
    # regardless of whether or not the last cert is an end-entity
    # cert or not. This allows callers to certify CA certs as
    # well as EE certs.
    # 
    # @param cert the certificate to be verified
    # @param currentState the current state against which the cert is verified
    # @param certPathList the certPathList generated thus far
    def verify_cert(cert, current_state, cert_path_list)
      if (!(Debug).nil?)
        Debug.println("ForwardBuilder.verifyCert(SN: " + RJava.cast_to_string(Debug.to_hex_string(cert.get_serial_number)) + "\n  Issuer: " + RJava.cast_to_string(cert.get_issuer_x500principal) + ")" + "\n  Subject: " + RJava.cast_to_string(cert.get_subject_x500principal) + ")")
      end
      curr_state = current_state
      # check for looping - abort a loop if
      # ((we encounter the same certificate twice) AND
      # ((policyMappingInhibited = true) OR (no policy mapping
      # extensions can be found between the occurences of the same
      # certificate)))
      if (!(cert_path_list).nil?)
        policy_mapping_found = false
        cert_path_list.each do |cpListCert|
          cp_list_cert_impl = X509CertImpl.to_impl(cp_list_cert)
          policy_mappings_ext = cp_list_cert_impl.get_policy_mappings_extension
          if (!(policy_mappings_ext).nil?)
            policy_mapping_found = true
          end
          if (!(Debug).nil?)
            Debug.println("policyMappingFound = " + RJava.cast_to_string(policy_mapping_found))
          end
          if ((cert == cp_list_cert))
            if ((self.attr_build_params.is_policy_mapping_inhibited) || (!policy_mapping_found))
              if (!(Debug).nil?)
                Debug.println("loop detected!!")
              end
              raise CertPathValidatorException.new("loop detected")
            end
          end
        end
      end
      # check if trusted cert
      is_trusted_cert = @trusted_certs.contains(cert)
      # we don't perform any validation of the trusted cert
      if (!is_trusted_cert)
        # Check CRITICAL private extensions for user checkers that
        # support forward checking (forwardCheckers) and remove
        # ones we know how to check.
        unres_crit_exts = cert.get_critical_extension_oids
        if ((unres_crit_exts).nil?)
          unres_crit_exts = Collections.empty_set
        end
        curr_state.attr_forward_checkers.each do |checker|
          checker.check(cert, unres_crit_exts)
        end
        # Remove extensions from user checkers that don't support
        # forward checking. After this step, we will have removed
        # all extensions that all user checkers are capable of
        # processing.
        self.attr_build_params.get_cert_path_checkers.each do |checker|
          if (!checker.is_forward_checking_supported)
            supported_exts = checker.get_supported_extensions
            if (!(supported_exts).nil?)
              unres_crit_exts.remove_all(supported_exts)
            end
          end
        end
        # Look at the remaining extensions and remove any ones we know how
        # to check. If there are any left, throw an exception!
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
            raise CertificateException.new("Unrecognized critical " + "extension(s)")
          end
        end
      end
      # if this is the target certificate (init=true), then we are
      # not able to do any more verification, so just return
      if (curr_state.is_initial)
        return
      end
      # we don't perform any validation of the trusted cert
      if (!is_trusted_cert)
        # Make sure this is a CA cert
        if ((cert.get_basic_constraints).equal?(-1))
          raise CertificateException.new("cert is NOT a CA cert")
        end
        # Check keyUsage extension
        KeyChecker.verify_cakey_usage(cert)
      end
      # the following checks are performed even when the cert
      # is a trusted cert, since we are only extracting the
      # subjectDN, and publicKey from the cert
      # in order to verify a previous cert
      # 
      # 
      # Check revocation for the previous cert
      if (self.attr_build_params.is_revocation_enabled)
        # first off, see if this cert can authorize revocation...
        if (CrlRevocationChecker.cert_can_sign_crl(cert))
          # And then check to be sure no key requiring key parameters
          # has been encountered
          if (!curr_state.key_params_needed)
            # If all that checks out, we can check the
            # revocation status of the cert. Otherwise,
            # we'll just wait until the end.
            curr_state.attr_crl_checker.check(curr_state.attr_cert, cert.get_public_key, true)
          end
        end
      end
      # Check signature only if no key requiring key parameters has been
      # encountered.
      if (!curr_state.key_params_needed)
        (curr_state.attr_cert).verify(cert.get_public_key, self.attr_build_params.get_sig_provider)
      end
    end
    
    typesig { [X509Certificate] }
    # Verifies whether the input certificate completes the path.
    # Checks the cert against each trust anchor that was specified, in order,
    # and returns true as soon as it finds a valid anchor.
    # Returns true if the cert matches a trust anchor specified as a
    # certificate or if the cert verifies with a trust anchor that
    # was specified as a trusted {pubkey, caname} pair. Returns false if none
    # of the trust anchors are valid for this cert.
    # 
    # @param cert the certificate to test
    # @return a boolean value indicating whether the cert completes the path.
    def is_path_completed(cert)
      @trust_anchors.each do |anchor|
        if (!(anchor.get_trusted_cert).nil?)
          if ((cert == anchor.get_trusted_cert))
            @trust_anchor = anchor
            return true
          else
            next
          end
        end
        trusted_caname = anchor.get_ca
        # Check subject/issuer name chaining
        if (!(trusted_caname == cert.get_issuer_x500principal))
          next
        end
        # Check revocation if it is enabled
        if (self.attr_build_params.is_revocation_enabled)
          begin
            crl_checker = CrlRevocationChecker.new(anchor, self.attr_build_params)
            crl_checker.check(cert, anchor.get_capublic_key, true)
          rescue CertPathValidatorException => cpve
            if (!(Debug).nil?)
              Debug.println("ForwardBuilder.isPathCompleted() cpve")
              cpve.print_stack_trace
            end
            next
          end
        end
        # Check signature
        begin
          # NOTE: the DSA public key in the buildParams may lack
          # parameters, yet there is no key to inherit the parameters
          # from.  This is probably such a rare case that it is not worth
          # trying to detect the situation earlier.
          cert.verify(anchor.get_capublic_key, self.attr_build_params.get_sig_provider)
        rescue InvalidKeyException => ike
          if (!(Debug).nil?)
            Debug.println("ForwardBuilder.isPathCompleted() invalid " + "DSA key found")
          end
          next
        rescue JavaException => e
          if (!(Debug).nil?)
            Debug.println("ForwardBuilder.isPathCompleted() " + "unexpected exception")
            e.print_stack_trace
          end
          next
        end
        @trust_anchor = anchor
        return true
      end
      return false
    end
    
    typesig { [X509Certificate, LinkedList] }
    # Adds the certificate to the certPathList
    # 
    # @param cert the certificate to be added
    # @param certPathList the certification path list
    def add_cert_to_path(cert, cert_path_list)
      cert_path_list.add_first(cert)
    end
    
    typesig { [LinkedList] }
    # Removes final certificate from the certPathList
    # 
    # @param certPathList the certification path list
    def remove_final_cert_from_path(cert_path_list)
      cert_path_list.remove_first
    end
    
    private
    alias_method :initialize__forward_builder, :initialize
  end
  
end
