require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DistributionPointFetcherImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include ::Java::Io
      include_const ::Java::Net, :URI
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Cert
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Security::Util, :Debug
      include ::Sun::Security::X509
    }
  end
  
  # Class to obtain CRLs via the CRLDistributionPoints extension.
  # Note that the functionality of this class must be explicitly enabled
  # via a system property, see the USE_CRLDP variable below.
  # 
  # This class uses the URICertStore class to fetch CRLs. The URICertStore
  # class also implements CRL caching: see the class description for more
  # information.
  # 
  # @author Andreas Sterbenz
  # @author Sean Mullan
  # @since 1.4.2
  class DistributionPointFetcher 
    include_class_members DistributionPointFetcherImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      const_set_lazy(:ALL_REASONS) { Array.typed(::Java::Boolean).new([true, true, true, true, true, true, true, true, true]) }
      const_attr_reader  :ALL_REASONS
      
      # Flag indicating whether support for the CRL distribution point
      # extension shall be enabled. Currently disabled by default for
      # compatibility and legal reasons.
      const_set_lazy(:USE_CRLDP) { get_boolean_property("com.sun.security.enableCRLDP", false) }
      const_attr_reader  :USE_CRLDP
      
      typesig { [String, ::Java::Boolean] }
      # Return the value of the boolean System property propName.
      def get_boolean_property(prop_name, default_value)
        # if set, require value of either true or false
        b = AccessController.do_privileged(GetPropertyAction.new(prop_name))
        if ((b).nil?)
          return default_value
        else
          if (b.equals_ignore_case("false"))
            return false
          else
            if (b.equals_ignore_case("true"))
              return true
            else
              raise RuntimeException.new("Value of " + prop_name + " must either be 'true' or 'false'")
            end
          end
        end
      end
      
      # singleton instance
      const_set_lazy(:INSTANCE) { DistributionPointFetcher.new }
      const_attr_reader  :INSTANCE
    }
    
    typesig { [] }
    # Private instantiation only.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return a DistributionPointFetcher instance.
      def get_instance
        return INSTANCE
      end
    }
    
    typesig { [X509CRLSelector, ::Java::Boolean, PublicKey, String, JavaList, Array.typed(::Java::Boolean), TrustAnchor] }
    # Return the X509CRLs matching this selector. The selector must be
    # an X509CRLSelector with certificateChecking set.
    # 
    # If CRLDP support is disabled, this method always returns an
    # empty set.
    def get_crls(selector, sign_flag, prev_key, provider, cert_stores, reasons_mask, anchor)
      if ((USE_CRLDP).equal?(false))
        return Collections.empty_set
      end
      cert = selector.get_certificate_checking
      if ((cert).nil?)
        return Collections.empty_set
      end
      begin
        cert_impl = X509CertImpl.to_impl(cert)
        if (!(Debug).nil?)
          Debug.println("DistributionPointFetcher.getCRLs: Checking " + "CRLDPs for " + RJava.cast_to_string(cert_impl.get_subject_x500principal))
        end
        ext = cert_impl.get_crldistribution_points_extension
        if ((ext).nil?)
          if (!(Debug).nil?)
            Debug.println("No CRLDP ext")
          end
          return Collections.empty_set
        end
        points = ext.get(CRLDistributionPointsExtension::POINTS)
        results = HashSet.new
        t = points.iterator
        while t.has_next && !(Arrays == reasons_mask)
          point = t.next_
          crls = get_crls(selector, cert_impl, point, reasons_mask, sign_flag, prev_key, provider, cert_stores, anchor)
          results.add_all(crls)
        end
        if (!(Debug).nil?)
          Debug.println("Returning " + RJava.cast_to_string(results.size) + " CRLs")
        end
        return results
      rescue CertificateException => e
        return Collections.empty_set
      rescue IOException => e
        return Collections.empty_set
      end
    end
    
    typesig { [X509CRLSelector, X509CertImpl, DistributionPoint, Array.typed(::Java::Boolean), ::Java::Boolean, PublicKey, String, JavaList, TrustAnchor] }
    # Download CRLs from the given distribution point, verify and return them.
    # See the top of the class for current limitations.
    def get_crls(selector, cert_impl, point, reasons_mask, sign_flag, prev_key, provider, cert_stores, anchor)
      # check for full name
      full_name = point.get_full_name
      if ((full_name).nil?)
        # check for relative name
        relative_name = point.get_relative_name
        if ((relative_name).nil?)
          return Collections.empty_set
        end
        begin
          crl_issuers = point.get_crlissuer
          if ((crl_issuers).nil?)
            full_name = get_full_names(cert_impl.get_issuer_dn, relative_name)
          else
            # should only be one CRL Issuer
            if (!(crl_issuers.size).equal?(1))
              return Collections.empty_set
            else
              full_name = get_full_names(crl_issuers.get(0).get_name, relative_name)
            end
          end
        rescue IOException => ioe
          return Collections.empty_set
        end
      end
      possible_crls = ArrayList.new
      crls = ArrayList.new(2)
      t = full_name.iterator
      while t.has_next
        name = t.next_
        if ((name.get_type).equal?(GeneralNameInterface::NAME_DIRECTORY))
          x500name = name.get_name
          possible_crls.add_all(get_crls(x500name, cert_impl.get_issuer_x500principal, cert_stores))
        else
          if ((name.get_type).equal?(GeneralNameInterface::NAME_URI))
            uri_name = name.get_name
            crl = get_crl(uri_name)
            if (!(crl).nil?)
              possible_crls.add(crl)
            end
          end
        end
      end
      possible_crls.each do |crl|
        begin
          # make sure issuer is not set
          # we check the issuer in verifyCRLs method
          selector.set_issuer_names(nil)
          if (selector.match(crl) && verify_crl(cert_impl, point, crl, reasons_mask, sign_flag, prev_key, provider, anchor, cert_stores))
            crls.add(crl)
          end
        rescue JavaException => e
          # don't add the CRL
          if (!(Debug).nil?)
            Debug.println("Exception verifying CRL: " + RJava.cast_to_string(e.get_message))
            e.print_stack_trace
          end
        end
      end
      return crls
    end
    
    typesig { [URIName] }
    # Download CRL from given URI.
    def get_crl(name)
      uri = name.get_uri
      if (!(Debug).nil?)
        Debug.println("Trying to fetch CRL from DP " + RJava.cast_to_string(uri))
      end
      begin
        ucs = URICertStore.get_instance(URICertStore::URICertStoreParameters.new(uri))
        crls = ucs.get_crls(nil)
        if (crls.is_empty)
          return nil
        else
          return crls.iterator.next_
        end
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("Exception getting CRL from CertStore: " + RJava.cast_to_string(e))
          e.print_stack_trace
        end
      end
      return nil
    end
    
    typesig { [X500Name, X500Principal, JavaList] }
    # Fetch CRLs from certStores.
    def get_crls(name, cert_issuer, cert_stores)
      if (!(Debug).nil?)
        Debug.println("Trying to fetch CRL from DP " + RJava.cast_to_string(name))
      end
      xcs = X509CRLSelector.new
      xcs.add_issuer(name.as_x500principal)
      xcs.add_issuer(cert_issuer)
      crls = ArrayList.new
      cert_stores.each do |store|
        begin
          store.get_crls(xcs).each do |crl|
            crls.add(crl)
          end
        rescue CertStoreException => cse
          # don't add the CRL
          if (!(Debug).nil?)
            Debug.println("Non-fatal exception while retrieving " + "CRLs: " + RJava.cast_to_string(cse))
            cse.print_stack_trace
          end
        end
      end
      return crls
    end
    
    typesig { [X509CertImpl, DistributionPoint, X509CRL, Array.typed(::Java::Boolean), ::Java::Boolean, PublicKey, String, TrustAnchor, JavaList] }
    # Verifies a CRL for the given certificate's Distribution Point to
    # ensure it is appropriate for checking the revocation status.
    # 
    # @param certImpl the certificate whose revocation status is being checked
    # @param point one of the distribution points of the certificate
    # @param crl the CRL
    # @param reasonsMask the interim reasons mask
    # @param signFlag true if prevKey can be used to verify the CRL
    # @param prevKey the public key that verifies the certificate's signature
    # @param provider the Signature provider to use
    # @return true if ok, false if not
    def verify_crl(cert_impl, point, crl, reasons_mask, sign_flag, prev_key, provider, anchor, cert_stores)
      indirect_crl = false
      crl_impl = X509CRLImpl.to_impl(crl)
      idp_ext = crl_impl.get_issuing_distribution_point_extension
      cert_issuer = cert_impl.get_issuer_dn
      crl_issuer = crl_impl.get_issuer_dn
      # if crlIssuer is set, verify that it matches the issuer of the
      # CRL and the CRL contains an IDP extension with the indirectCRL
      # boolean asserted. Otherwise, verify that the CRL issuer matches the
      # certificate issuer.
      point_crl_issuers = point.get_crlissuer
      point_crl_issuer = nil
      if (!(point_crl_issuers).nil?)
        if ((idp_ext).nil? || ((idp_ext.get(IssuingDistributionPointExtension::INDIRECT_CRL)) == Boolean::FALSE))
          return false
        end
        match_ = false
        t = point_crl_issuers.iterator
        while !match_ && t.has_next
          name = t.next_.get_name
          if (((crl_issuer == name)).equal?(true))
            point_crl_issuer = name
            match_ = true
          end
        end
        if ((match_).equal?(false))
          return false
        end
        indirect_crl = true
      else
        if (((crl_issuer == cert_issuer)).equal?(false))
          if (!(Debug).nil?)
            Debug.println("crl issuer does not equal cert issuer")
          end
          return false
        end
      end
      if (!indirect_crl && !sign_flag)
        # cert's key cannot be used to verify the CRL
        return false
      end
      if (!(idp_ext).nil?)
        idp_point = idp_ext.get(IssuingDistributionPointExtension::POINT)
        if (!(idp_point).nil?)
          idp_names = idp_point.get_full_name
          if ((idp_names).nil?)
            relative_name = idp_point.get_relative_name
            if ((relative_name).nil?)
              if (!(Debug).nil?)
                Debug.println("IDP must be relative or full DN")
              end
              return false
            end
            if (!(Debug).nil?)
              Debug.println("IDP relativeName:" + RJava.cast_to_string(relative_name))
            end
            idp_names = get_full_names(crl_issuer, relative_name)
          end
          # if the DP name is present in the IDP CRL extension and the
          # DP field is present in the DP, then verify that one of the
          # names in the IDP matches one of the names in the DP
          if (!(point.get_full_name).nil? || !(point.get_relative_name).nil?)
            point_names = point.get_full_name
            if ((point_names).nil?)
              relative_name = point.get_relative_name
              if ((relative_name).nil?)
                if (!(Debug).nil?)
                  Debug.println("DP must be relative or full DN")
                end
                return false
              end
              if (!(Debug).nil?)
                Debug.println("DP relativeName:" + RJava.cast_to_string(relative_name))
              end
              if (indirect_crl)
                if (!(point_crl_issuers.size).equal?(1))
                  # RFC 3280: there must be only 1 CRL issuer
                  # name when relativeName is present
                  if (!(Debug).nil?)
                    Debug.println("must only be one CRL " + "issuer when relative name present")
                  end
                  return false
                end
                point_names = get_full_names(point_crl_issuer, relative_name)
              else
                point_names = get_full_names(cert_issuer, relative_name)
              end
            end
            match_ = false
            i = idp_names.iterator
            while !match_ && i.has_next
              idp_name = i.next_.get_name
              if (!(Debug).nil?)
                Debug.println("idpName: " + RJava.cast_to_string(idp_name))
              end
              p = point_names.iterator
              while !match_ && p.has_next
                point_name = p.next_.get_name
                if (!(Debug).nil?)
                  Debug.println("pointName: " + RJava.cast_to_string(point_name))
                end
                match_ = (idp_name == point_name)
              end
            end
            if (!match_)
              if (!(Debug).nil?)
                Debug.println("IDP name does not match DP name")
              end
              return false
            end
            # if the DP name is present in the IDP CRL extension and the
            # DP field is absent from the DP, then verify that one of the
            # names in the IDP matches one of the names in the crlIssuer
            # field of the DP
          else
            # verify that one of the names in the IDP matches one of
            # the names in the cRLIssuer of the cert's DP
            match_ = false
            t = point_crl_issuers.iterator
            while !match_ && t.has_next
              crl_issuer_name = t.next_.get_name
              i = idp_names.iterator
              while !match_ && i.has_next
                idp_name = i.next_.get_name
                match_ = (crl_issuer_name == idp_name)
              end
            end
            if (!match_)
              return false
            end
          end
        end
        # if the onlyContainsUserCerts boolean is asserted, verify that the
        # cert is not a CA cert
        b = idp_ext.get(IssuingDistributionPointExtension::ONLY_USER_CERTS)
        if ((b == Boolean::TRUE) && !(cert_impl.get_basic_constraints).equal?(-1))
          if (!(Debug).nil?)
            Debug.println("cert must be a EE cert")
          end
          return false
        end
        # if the onlyContainsCACerts boolean is asserted, verify that the
        # cert is a CA cert
        b = idp_ext.get(IssuingDistributionPointExtension::ONLY_CA_CERTS)
        if ((b == Boolean::TRUE) && (cert_impl.get_basic_constraints).equal?(-1))
          if (!(Debug).nil?)
            Debug.println("cert must be a CA cert")
          end
          return false
        end
        # verify that the onlyContainsAttributeCerts boolean is not
        # asserted
        b = idp_ext.get(IssuingDistributionPointExtension::ONLY_ATTRIBUTE_CERTS)
        if ((b == Boolean::TRUE))
          if (!(Debug).nil?)
            Debug.println("cert must not be an AA cert")
          end
          return false
        end
      end
      # compute interim reasons mask
      interim_reasons_mask = Array.typed(::Java::Boolean).new(9) { false }
      reasons = nil
      if (!(idp_ext).nil?)
        reasons = idp_ext.get(IssuingDistributionPointExtension::REASONS)
      end
      point_reason_flags = point.get_reason_flags
      if (!(reasons).nil?)
        if (!(point_reason_flags).nil?)
          # set interim reasons mask to the intersection of
          # reasons in the DP and onlySomeReasons in the IDP
          idp_reason_flags = reasons.get_flags
          i = 0
          while i < idp_reason_flags.attr_length
            if (idp_reason_flags[i] && point_reason_flags[i])
              interim_reasons_mask[i] = true
            end
            i += 1
          end
        else
          # set interim reasons mask to the value of
          # onlySomeReasons in the IDP (and clone it since we may
          # modify it)
          interim_reasons_mask = reasons.get_flags.clone
        end
      else
        if ((idp_ext).nil? || (reasons).nil?)
          if (!(point_reason_flags).nil?)
            # set interim reasons mask to the value of DP reasons
            interim_reasons_mask = point_reason_flags.clone
          else
            # set interim reasons mask to the special value all-reasons
            interim_reasons_mask = Array.typed(::Java::Boolean).new(9) { false }
            Arrays.fill(interim_reasons_mask, true)
          end
        end
      end
      # verify that interim reasons mask includes one or more reasons
      # not included in the reasons mask
      one_or_more = false
      i = 0
      while i < interim_reasons_mask.attr_length && !one_or_more
        if (!reasons_mask[i] && interim_reasons_mask[i])
          one_or_more = true
        end
        i += 1
      end
      if (!one_or_more)
        return false
      end
      # Obtain and validate the certification path for the complete
      # CRL issuer (if indirect CRL). If a key usage extension is present
      # in the CRL issuer's certificate, verify that the cRLSign bit is set.
      if (indirect_crl)
        cert_sel = X509CertSelector.new
        cert_sel.set_subject(crl_issuer.as_x500principal)
        crl_sign = Array.typed(::Java::Boolean).new([false, false, false, false, false, false, true])
        cert_sel.set_key_usage(crl_sign)
        params = nil
        begin
          params = PKIXBuilderParameters.new(Collections.singleton(anchor), cert_sel)
        rescue InvalidAlgorithmParameterException => iape
          raise CRLException.new(iape)
        end
        params.set_cert_stores(cert_stores)
        params.set_sig_provider(provider)
        begin
          builder = CertPathBuilder.get_instance("PKIX")
          result = builder.build(params)
          prev_key = result.get_public_key
        rescue JavaException => e
          raise CRLException.new(e)
        end
      end
      # validate the signature on the CRL
      begin
        crl.verify(prev_key, provider)
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("CRL signature failed to verify")
        end
        return false
      end
      # reject CRL if any unresolved critical extensions remain in the CRL.
      unres_crit_exts = crl.get_critical_extension_oids
      # remove any that we have processed
      if (!(unres_crit_exts).nil?)
        unres_crit_exts.remove(PKIXExtensions::IssuingDistributionPoint_Id.to_s)
        if (!unres_crit_exts.is_empty)
          if (!(Debug).nil?)
            Debug.println("Unrecognized critical extension(s) in CRL: " + RJava.cast_to_string(unres_crit_exts))
            i_ = unres_crit_exts.iterator
            while (i_.has_next)
              Debug.println(i_.next_)
            end
          end
          return false
        end
      end
      # update reasonsMask
      i_ = 0
      while i_ < interim_reasons_mask.attr_length
        if (!reasons_mask[i_] && interim_reasons_mask[i_])
          reasons_mask[i_] = true
        end
        i_ += 1
      end
      return true
    end
    
    typesig { [X500Name, RDN] }
    # Append relative name to the issuer name and return a new
    # GeneralNames object.
    def get_full_names(issuer, rdn)
      rdns_ = ArrayList.new(issuer.rdns)
      rdns_.add(rdn)
      full_name = X500Name.new(rdns_.to_array(Array.typed(RDN).new(0) { nil }))
      full_names = GeneralNames.new
      full_names.add(GeneralName.new(full_name))
      return full_names
    end
    
    private
    alias_method :initialize__distribution_point_fetcher, :initialize
  end
  
end
