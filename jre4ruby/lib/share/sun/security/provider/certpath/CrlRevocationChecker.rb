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
  module CrlRevocationCheckerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :PublicKey
      include ::Java::Security::Cert
      include_const ::Java::Security::Interfaces, :DSAPublicKey
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :AccessDescription
      include_const ::Sun::Security::X509, :AuthorityInfoAccessExtension
      include_const ::Sun::Security::X509, :CRLDistributionPointsExtension
      include_const ::Sun::Security::X509, :CRLReasonCodeExtension
      include_const ::Sun::Security::X509, :DistributionPoint
      include_const ::Sun::Security::X509, :GeneralName
      include_const ::Sun::Security::X509, :GeneralNames
      include_const ::Sun::Security::X509, :PKIXExtensions
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::X509, :X509CertImpl
      include_const ::Sun::Security::X509, :X509CRLEntryImpl
    }
  end
  
  # CrlRevocationChecker is a <code>PKIXCertPathChecker</code> that checks
  # revocation status information on a PKIX certificate using CRLs obtained
  # from one or more <code>CertStores</code>. This is based on section 6.3
  # of RFC 3280 (http://www.ietf.org/rfc/rfc3280.txt).
  # 
  # @since       1.4
  # @author      Seth Proctor
  # @author      Steve Hanna
  class CrlRevocationChecker < CrlRevocationCheckerImports.const_get :PKIXCertPathChecker
    include_class_members CrlRevocationCheckerImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :m_anchor
    alias_method :attr_m_anchor, :m_anchor
    undef_method :m_anchor
    alias_method :attr_m_anchor=, :m_anchor=
    undef_method :m_anchor=
    
    attr_accessor :m_stores
    alias_method :attr_m_stores, :m_stores
    undef_method :m_stores
    alias_method :attr_m_stores=, :m_stores=
    undef_method :m_stores=
    
    attr_accessor :m_sig_provider
    alias_method :attr_m_sig_provider, :m_sig_provider
    undef_method :m_sig_provider
    alias_method :attr_m_sig_provider=, :m_sig_provider=
    undef_method :m_sig_provider=
    
    attr_accessor :m_current_time
    alias_method :attr_m_current_time, :m_current_time
    undef_method :m_current_time
    alias_method :attr_m_current_time=, :m_current_time=
    undef_method :m_current_time=
    
    attr_accessor :m_prev_pub_key
    alias_method :attr_m_prev_pub_key, :m_prev_pub_key
    undef_method :m_prev_pub_key
    alias_method :attr_m_prev_pub_key=, :m_prev_pub_key=
    undef_method :m_prev_pub_key=
    
    attr_accessor :m_crlsign_flag
    alias_method :attr_m_crlsign_flag, :m_crlsign_flag
    undef_method :m_crlsign_flag
    alias_method :attr_m_crlsign_flag=, :m_crlsign_flag=
    undef_method :m_crlsign_flag=
    
    attr_accessor :m_possible_crls
    alias_method :attr_m_possible_crls, :m_possible_crls
    undef_method :m_possible_crls
    alias_method :attr_m_possible_crls=, :m_possible_crls=
    undef_method :m_possible_crls=
    
    attr_accessor :m_approved_crls
    alias_method :attr_m_approved_crls, :m_approved_crls
    undef_method :m_approved_crls
    alias_method :attr_m_approved_crls=, :m_approved_crls=
    undef_method :m_approved_crls=
    
    attr_accessor :m_params
    alias_method :attr_m_params, :m_params
    undef_method :m_params
    alias_method :attr_m_params=, :m_params=
    undef_method :m_params=
    
    class_module.module_eval {
      const_set_lazy(:M_CrlSignUsage) { Array.typed(::Java::Boolean).new([false, false, false, false, false, false, true]) }
      const_attr_reader  :M_CrlSignUsage
      
      const_set_lazy(:ALL_REASONS) { Array.typed(::Java::Boolean).new([true, true, true, true, true, true, true, true, true]) }
      const_attr_reader  :ALL_REASONS
    }
    
    typesig { [TrustAnchor, PKIXParameters] }
    # Creates a <code>CrlRevocationChecker</code>.
    # 
    # @param anchor anchor selected to validate the target certificate
    # @param params <code>PKIXParameters</code> to be used for
    # finding certificates and CRLs, etc.
    def initialize(anchor, params)
      initialize__crl_revocation_checker(anchor, params, nil)
    end
    
    typesig { [TrustAnchor, PKIXParameters, Collection] }
    # Creates a <code>CrlRevocationChecker</code>, allowing
    # extra certificates to be supplied beyond those contained
    # in the <code>PKIXParameters</code>.
    # 
    # @param anchor anchor selected to validate the target certificate
    # @param params <code>PKIXParameters</code> to be used for
    # finding certificates and CRLs, etc.
    # @param certs a <code>Collection</code> of certificates
    # that may be useful, beyond those available
    # through <code>params</code> (<code>null</code>
    # if none)
    def initialize(anchor, params, certs)
      @m_anchor = nil
      @m_stores = nil
      @m_sig_provider = nil
      @m_current_time = nil
      @m_prev_pub_key = nil
      @m_crlsign_flag = false
      @m_possible_crls = nil
      @m_approved_crls = nil
      @m_params = nil
      super()
      @m_anchor = anchor
      @m_params = params
      @m_stores = ArrayList.new(params.get_cert_stores)
      @m_sig_provider = RJava.cast_to_string(params.get_sig_provider)
      if (!(certs).nil?)
        begin
          @m_stores.add(CertStore.get_instance("Collection", CollectionCertStoreParameters.new(certs)))
        rescue JavaException => e
          # should never occur but not necessarily fatal, so log it,
          # ignore and continue
          if (!(Debug).nil?)
            Debug.println("CrlRevocationChecker: " + "error creating Collection CertStore: " + RJava.cast_to_string(e))
          end
        end
      end
      test_date = params.get_date
      @m_current_time = (!(test_date).nil? ? test_date : Date.new)
      init(false)
    end
    
    typesig { [::Java::Boolean] }
    # Initializes the internal state of the checker from parameters
    # specified in the constructor
    def init(forward)
      if (!forward)
        if (!(@m_anchor).nil?)
          if (!(@m_anchor.get_capublic_key).nil?)
            @m_prev_pub_key = @m_anchor.get_capublic_key
          else
            @m_prev_pub_key = @m_anchor.get_trusted_cert.get_public_key
          end
        else
          @m_prev_pub_key = nil
        end
        @m_crlsign_flag = true
      else
        raise CertPathValidatorException.new("forward checking " + "not supported")
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
    # Performs the revocation status check on the certificate using
    # its internal state.
    # 
    # @param cert the Certificate
    # @param unresolvedCritExts a Collection of the unresolved critical
    # extensions
    # @exception CertPathValidatorException Exception thrown if
    # certificate does not verify
    def check(cert, unresolved_crit_exts)
      curr_cert = cert
      verify_revocation_status(curr_cert, @m_prev_pub_key, @m_crlsign_flag, true)
      # Make new public key if parameters are missing
      c_key = curr_cert.get_public_key
      if (c_key.is_a?(DSAPublicKey) && ((c_key).get_params).nil?)
        # cKey needs to inherit DSA parameters from prev key
        c_key = BasicChecker.make_inherited_params_key(c_key, @m_prev_pub_key)
      end
      @m_prev_pub_key = c_key
      @m_crlsign_flag = cert_can_sign_crl(curr_cert)
    end
    
    typesig { [X509Certificate, PublicKey, ::Java::Boolean] }
    # Performs the revocation status check on the certificate using
    # the provided state variables, as well as the constant internal
    # data.
    # 
    # @param currCert the Certificate
    # @param prevKey the previous PublicKey in the chain
    # @param signFlag a boolean as returned from the last call, or true
    # if this is the first cert in the chain
    # @return a boolean specifying if the cert is allowed to vouch for the
    # validity of a CRL for the next iteration
    # @exception CertPathValidatorException Exception thrown if
    # certificate does not verify.
    def check(curr_cert, prev_key, sign_flag)
      verify_revocation_status(curr_cert, prev_key, sign_flag, true)
      return cert_can_sign_crl(curr_cert)
    end
    
    class_module.module_eval {
      typesig { [X509Certificate] }
      # Checks that a cert can be used to verify a CRL.
      # 
      # @param currCert an X509Certificate to check
      # @return a boolean specifying if the cert is allowed to vouch for the
      # validity of a CRL
      def cert_can_sign_crl(curr_cert)
        # if the cert doesn't include the key usage ext, or
        # the key usage ext asserts cRLSigning, return true,
        # otherwise return false.
        kbools = curr_cert.get_key_usage
        if (!(kbools).nil?)
          return kbools[6]
        end
        return false
      end
    }
    
    typesig { [X509Certificate, PublicKey, ::Java::Boolean, ::Java::Boolean] }
    # Internal method to start the verification of a cert
    def verify_revocation_status(curr_cert, prev_key, sign_flag, allow_separate_key)
      verify_revocation_status(curr_cert, prev_key, sign_flag, allow_separate_key, nil)
    end
    
    typesig { [X509Certificate, PublicKey, ::Java::Boolean, ::Java::Boolean, JavaSet] }
    # Internal method to start the verification of a cert
    # @param stackedCerts a <code>Set</code> of <code>X509Certificate</code>s>
    # whose revocation status depends on the
    # non-revoked status of this cert. To avoid
    # circular dependencies, we assume they're
    # revoked while checking the revocation
    # status of this cert.
    def verify_revocation_status(curr_cert, prev_key, sign_flag, allow_separate_key, stacked_certs)
      msg = "revocation status"
      if (!(Debug).nil?)
        Debug.println("CrlRevocationChecker.verifyRevocationStatus()" + " ---checking " + msg + "...")
      end
      # reject circular dependencies - RFC 3280 is not explicit on how
      # to handle this, so we feel it is safest to reject them until
      # the issue is resolved in the PKIX WG.
      if ((!(stacked_certs).nil?) && stacked_certs.contains(curr_cert))
        if (!(Debug).nil?)
          Debug.println("CrlRevocationChecker.verifyRevocationStatus()" + " circular dependency")
        end
        raise CertPathValidatorException.new("Could not determine revocation status")
      end
      # init the state for this run
      @m_possible_crls = HashSet.new
      @m_approved_crls = HashSet.new
      reasons_mask = Array.typed(::Java::Boolean).new(9) { false }
      begin
        sel = X509CRLSelector.new
        sel.set_certificate_checking(curr_cert)
        sel.set_date_and_time(@m_current_time)
        @m_stores.each do |mStore|
          m_store.get_crls(sel).each do |crl|
            @m_possible_crls.add(crl)
          end
        end
        store = DistributionPointFetcher.get_instance
        # all CRLs returned by the DP Fetcher have also been verified
        @m_approved_crls.add_all(store.get_crls(sel, sign_flag, prev_key, @m_sig_provider, @m_stores, reasons_mask, @m_anchor))
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("CrlRevocationChecker.verifyRevocationStatus() " + "unexpected exception: " + RJava.cast_to_string(e.get_message))
        end
        raise CertPathValidatorException.new(e)
      end
      if (!(Debug).nil?)
        Debug.println("CrlRevocationChecker.verifyRevocationStatus() " + "crls.size() = " + RJava.cast_to_string(@m_possible_crls.size))
      end
      if (!@m_possible_crls.is_empty)
        # Now that we have a list of possible CRLs, see which ones can
        # be approved
        @m_approved_crls.add_all(verify_possible_crls(@m_possible_crls, curr_cert, sign_flag, prev_key, reasons_mask))
      end
      if (!(Debug).nil?)
        Debug.println("CrlRevocationChecker.verifyRevocationStatus() " + "approved crls.size() = " + RJava.cast_to_string(@m_approved_crls.size))
      end
      # make sure that we have at least one CRL that _could_ cover
      # the certificate in question and all reasons are covered
      if (@m_approved_crls.is_empty || !(Arrays == reasons_mask))
        if (allow_separate_key)
          verify_with_separate_signing_key(curr_cert, prev_key, sign_flag, stacked_certs)
          return
        else
          raise CertPathValidatorException.new("Could not determine revocation status")
        end
      end
      # See if the cert is in the set of approved crls.
      if (!(Debug).nil?)
        sn = curr_cert.get_serial_number
        Debug.println("starting the final sweep...")
        Debug.println("CrlRevocationChecker.verifyRevocationStatus" + " cert SN: " + RJava.cast_to_string(sn.to_s))
      end
      reason_code = 0
      entry = nil
      @m_approved_crls.each do |crl|
        e = crl.get_revoked_certificate(curr_cert)
        if (!(e).nil?)
          begin
            entry = X509CRLEntryImpl.to_impl(e)
            reason = entry.get_reason_code
            # if reasonCode extension is absent, this is equivalent
            # to a reasonCode value of unspecified (0)
            reason_code = ((reason).nil? ? CRLReasonCodeExtension::UNSPECIFIED : reason.int_value)
          rescue JavaException => ex
            raise CertPathValidatorException.new(ex)
          end
          if (!(Debug).nil?)
            Debug.println("CrlRevocationChecker.verifyRevocationStatus" + " CRL entry: " + RJava.cast_to_string(entry.to_s))
          end
          # Abort CRL validation and throw exception if there are any
          # unrecognized critical CRL entry extensions (see section
          # 5.3 of RFC 3280).
          unres_crit_exts = entry.get_critical_extension_oids
          if (!(unres_crit_exts).nil? && !unres_crit_exts.is_empty)
            # remove any that we will process
            unres_crit_exts.remove(PKIXExtensions::ReasonCode_Id.to_s)
            unres_crit_exts.remove(PKIXExtensions::CertificateIssuer_Id.to_s)
            if (!unres_crit_exts.is_empty)
              if (!(Debug).nil?)
                Debug.println("Unrecognized " + "critical extension(s) in revoked CRL entry: " + RJava.cast_to_string(unres_crit_exts))
              end
              raise CertPathValidatorException.new("Could not determine revocation status")
            end
          end
          raise CertificateRevokedException.new("Certificate has been" + " revoked, reason: " + RJava.cast_to_string(reason_to_string(reason_code)))
        end
      end
    end
    
    typesig { [X509Certificate, PublicKey, ::Java::Boolean, JavaSet] }
    # We have a cert whose revocation status couldn't be verified by
    # a CRL issued by the cert that issued the CRL. See if we can
    # find a valid CRL issued by a separate key that can verify the
    # revocation status of this certificate.
    # <p>
    # Note that this does not provide support for indirect CRLs,
    # only CRLs signed with a different key (but the same issuer
    # name) as the certificate being checked.
    # 
    # @param currCert the <code>X509Certificate</code> to be checked
    # @param prevKey the <code>PublicKey</code> that failed
    # @param signFlag <code>true</code> if that key was trusted to sign CRLs
    # @param stackedCerts a <code>Set</code> of <code>X509Certificate</code>s>
    # whose revocation status depends on the
    # non-revoked status of this cert. To avoid
    # circular dependencies, we assume they're
    # revoked while checking the revocation
    # status of this cert.
    # @throws CertPathValidatorException if the cert's revocation status
    # cannot be verified successfully with another key
    def verify_with_separate_signing_key(curr_cert, prev_key, sign_flag, stacked_certs)
      msg = "revocation status"
      if (!(Debug).nil?)
        Debug.println("CrlRevocationChecker.verifyWithSeparateSigningKey()" + " ---checking " + msg + "...")
      end
      # reject circular dependencies - RFC 3280 is not explicit on how
      # to handle this, so we feel it is safest to reject them until
      # the issue is resolved in the PKIX WG.
      if ((!(stacked_certs).nil?) && stacked_certs.contains(curr_cert))
        if (!(Debug).nil?)
          Debug.println("CrlRevocationChecker.verifyWithSeparateSigningKey()" + " circular dependency")
        end
        raise CertPathValidatorException.new("Could not determine revocation status")
      end
      # If prevKey wasn't trusted, maybe we just didn't have the right
      # path to it. Don't rule that key out.
      if (!sign_flag)
        prev_key = nil
      end
      # Try to find another key that might be able to sign
      # CRLs vouching for this cert.
      build_to_new_key(curr_cert, prev_key, stacked_certs)
    end
    
    typesig { [X509Certificate, PublicKey, JavaSet] }
    # Tries to find a CertPath that establishes a key that can be
    # used to verify the revocation status of a given certificate.
    # Ignores keys that have previously been tried. Throws a
    # CertPathValidatorException if no such key could be found.
    # 
    # @param currCert the <code>X509Certificate</code> to be checked
    # @param prevKey the <code>PublicKey</code> of the certificate whose key
    # cannot be used to vouch for the CRL and should be ignored
    # @param stackedCerts a <code>Set</code> of <code>X509Certificate</code>s>
    # whose revocation status depends on the
    # establishment of this path.
    # @throws CertPathValidatorException on failure
    def build_to_new_key(curr_cert, prev_key, stacked_certs)
      if (!(Debug).nil?)
        Debug.println("CrlRevocationChecker.buildToNewKey()" + " starting work")
      end
      bad_keys = HashSet.new
      if (!(prev_key).nil?)
        bad_keys.add(prev_key)
      end
      cert_sel = RejectKeySelector.new(bad_keys)
      cert_sel.set_subject(curr_cert.get_issuer_x500principal)
      cert_sel.set_key_usage(M_CrlSignUsage)
      new_anchors = (@m_anchor).nil? ? @m_params.get_trust_anchors : Collections.singleton(@m_anchor)
      builder_params = nil
      if (@m_params.is_a?(PKIXBuilderParameters))
        builder_params = @m_params.clone
        builder_params.set_target_cert_constraints(cert_sel)
        # Policy qualifiers must be rejected, since we don't have
        # any way to convey them back to the application.
        builder_params.set_policy_qualifiers_rejected(true)
        begin
          builder_params.set_trust_anchors(new_anchors)
        rescue InvalidAlgorithmParameterException => iape
          raise RuntimeException.new(iape) # should never occur
        end
      else
        # It's unfortunate that there's no easy way to make a
        # PKIXBuilderParameters object from a PKIXParameters
        # object. This might miss some things if parameters
        # are added in the future or the validatorParams object
        # is a custom class derived from PKIXValidatorParameters.
        begin
          builder_params = PKIXBuilderParameters.new(new_anchors, cert_sel)
        rescue InvalidAlgorithmParameterException => iape
          raise RuntimeException.new(iape) # should never occur
        end
        builder_params.set_initial_policies(@m_params.get_initial_policies)
        builder_params.set_cert_stores(@m_stores)
        builder_params.set_explicit_policy_required(@m_params.is_explicit_policy_required)
        builder_params.set_policy_mapping_inhibited(@m_params.is_policy_mapping_inhibited)
        builder_params.set_any_policy_inhibited(@m_params.is_any_policy_inhibited)
        # Policy qualifiers must be rejected, since we don't have
        # any way to convey them back to the application.
        # That's the default, so no need to write code.
        builder_params.set_date(@m_params.get_date)
        builder_params.set_cert_path_checkers(@m_params.get_cert_path_checkers)
        builder_params.set_sig_provider(@m_params.get_sig_provider)
      end
      # Skip revocation during this build to detect circular
      # references. But check revocation afterwards, using the
      # key (or any other that works).
      builder_params.set_revocation_enabled(false)
      # check for AuthorityInformationAccess extension
      if ((Builder::USE_AIA).equal?(true))
        curr_cert_impl = nil
        begin
          curr_cert_impl = X509CertImpl.to_impl(curr_cert)
        rescue CertificateException => ce
          # ignore but log it
          if (!(Debug).nil?)
            Debug.println("CrlRevocationChecker.buildToNewKey: " + "error decoding cert: " + RJava.cast_to_string(ce))
          end
        end
        aia_ext = nil
        if (!(curr_cert_impl).nil?)
          aia_ext = curr_cert_impl.get_authority_info_access_extension
        end
        if (!(aia_ext).nil?)
          ad_list = aia_ext.get_access_descriptions
          if (!(ad_list).nil?)
            ad_list.each do |ad|
              cs = URICertStore.get_instance(ad)
              if (!(cs).nil?)
                if (!(Debug).nil?)
                  Debug.println("adding AIAext CertStore")
                end
                builder_params.add_cert_store(cs)
              end
            end
          end
        end
      end
      builder = nil
      begin
        builder = CertPathBuilder.get_instance("PKIX")
      rescue NoSuchAlgorithmException => nsae
        raise CertPathValidatorException.new(nsae)
      end
      while (true)
        begin
          if (!(Debug).nil?)
            Debug.println("CrlRevocationChecker.buildToNewKey()" + " about to try build ...")
          end
          cpbr = builder.build(builder_params)
          if (!(Debug).nil?)
            Debug.println("CrlRevocationChecker.buildToNewKey()" + " about to check revocation ...")
          end
          # Now check revocation of all certs in path, assuming that
          # the stackedCerts are revoked.
          if ((stacked_certs).nil?)
            stacked_certs = HashSet.new
          end
          stacked_certs.add(curr_cert)
          ta = cpbr.get_trust_anchor
          prev_key2 = ta.get_capublic_key
          if ((prev_key2).nil?)
            prev_key2 = ta.get_trusted_cert.get_public_key
          end
          sign_flag = true
          cp_list = cpbr.get_cert_path.get_certificates
          begin
            i = cp_list.size - 1
            while i >= 0
              cert = cp_list.get(i)
              if (!(Debug).nil?)
                Debug.println("CrlRevocationChecker.buildToNewKey()" + " index " + RJava.cast_to_string(i) + " checking " + RJava.cast_to_string(cert))
              end
              verify_revocation_status(cert, prev_key2, sign_flag, true, stacked_certs)
              sign_flag = cert_can_sign_crl(cert)
              prev_key2 = cert.get_public_key
              i -= 1
            end
          rescue CertPathValidatorException => cpve
            # ignore it and try to get another key
            bad_keys.add(cpbr.get_public_key)
            next
          end
          if (!(Debug).nil?)
            Debug.println("CrlRevocationChecker.buildToNewKey()" + " got key " + RJava.cast_to_string(cpbr.get_public_key))
          end
          # Now check revocation on the current cert using that key.
          # If it doesn't check out, try to find a different key.
          # And if we can't find a key, then return false.
          new_key = cpbr.get_public_key
          begin
            verify_revocation_status(curr_cert, new_key, true, false)
            # If that passed, the cert is OK!
            return
          rescue CertPathValidatorException => cpve
            # If it is revoked, rethrow exception
            if (cpve.is_a?(CertificateRevokedException))
              raise cpve
            end
            # Otherwise, ignore the exception and
            # try to get another key.
          end
          bad_keys.add(new_key)
        rescue InvalidAlgorithmParameterException => iape
          raise CertPathValidatorException.new(iape)
        rescue CertPathBuilderException => cpbe
          raise CertPathValidatorException.new("Could not determine revocation status", cpbe)
        end
      end
    end
    
    class_module.module_eval {
      # This inner class extends the X509CertSelector to add an additional
      # check to make sure the subject public key isn't on a particular list.
      # This class is used by buildToNewKey() to make sure the builder doesn't
      # end up with a CertPath to a public key that has already been rejected.
      const_set_lazy(:RejectKeySelector) { Class.new(X509CertSelector) do
        include_class_members CrlRevocationChecker
        
        attr_accessor :bad_key_set
        alias_method :attr_bad_key_set, :bad_key_set
        undef_method :bad_key_set
        alias_method :attr_bad_key_set=, :bad_key_set=
        undef_method :bad_key_set=
        
        typesig { [self::JavaSet] }
        # Creates a new <code>RejectKeySelector</code>.
        # 
        # @param badPublicKeys a <code>Set</code> of
        # <code>PublicKey</code>s that
        # should be rejected (or <code>null</code>
        # if no such check should be done)
        def initialize(bad_public_keys)
          @bad_key_set = nil
          super()
          @bad_key_set = bad_public_keys
        end
        
        typesig { [self::Certificate] }
        # Decides whether a <code>Certificate</code> should be selected.
        # 
        # @param cert the <code>Certificate</code> to be checked
        # @return <code>true</code> if the <code>Certificate</code> should be
        # selected, <code>false</code> otherwise
        def match(cert)
          if (!super(cert))
            return (false)
          end
          if (@bad_key_set.contains(cert.get_public_key))
            if (!(Debug).nil?)
              Debug.println("RejectCertSelector.match: bad key")
            end
            return false
          end
          if (!(Debug).nil?)
            Debug.println("RejectCertSelector.match: returning true")
          end
          return true
        end
        
        typesig { [] }
        # Return a printable representation of the <code>CertSelector</code>.
        # 
        # @return a <code>String</code> describing the contents of the
        # <code>CertSelector</code>
        def to_s
          sb = self.class::StringBuilder.new
          sb.append("RejectCertSelector: [\n")
          sb.append(super)
          sb.append(@bad_key_set)
          sb.append("]")
          return sb.to_s
        end
        
        private
        alias_method :initialize__reject_key_selector, :initialize
      end }
      
      typesig { [::Java::Int] }
      # Return a String describing the reasonCode value
      def reason_to_string(reason_code)
        case (reason_code)
        when CRLReasonCodeExtension::UNSPECIFIED
          return "unspecified"
        when CRLReasonCodeExtension::KEY_COMPROMISE
          return "key compromise"
        when CRLReasonCodeExtension::CA_COMPROMISE
          return "CA compromise"
        when CRLReasonCodeExtension::AFFLIATION_CHANGED
          return "affiliation changed"
        when CRLReasonCodeExtension::SUPERSEDED
          return "superseded"
        when CRLReasonCodeExtension::CESSATION_OF_OPERATION
          return "cessation of operation"
        when CRLReasonCodeExtension::CERTIFICATE_HOLD
          return "certificate hold"
        when CRLReasonCodeExtension::REMOVE_FROM_CRL
          return "remove from CRL"
        else
          return "unrecognized reason code"
        end
      end
    }
    
    typesig { [JavaSet, X509Certificate, ::Java::Boolean, PublicKey, Array.typed(::Java::Boolean)] }
    # Internal method that verifies a set of possible_crls,
    # and sees if each is approved, based on the cert.
    # 
    # @param crls a set of possible CRLs to test for acceptability
    # @param cert the certificate whose revocation status is being checked
    # @param signFlag <code>true</code> if prevKey was trusted to sign CRLs
    # @param prevKey the public key of the issuer of cert
    # @param reasonsMask the reason code mask
    # @return a collection of approved crls (or an empty collection)
    def verify_possible_crls(crls, cert, sign_flag, prev_key, reasons_mask)
      begin
        cert_impl = X509CertImpl.to_impl(cert)
        if (!(Debug).nil?)
          Debug.println("CRLRevocationChecker.verifyPossibleCRLs: " + "Checking CRLDPs for " + RJava.cast_to_string(cert_impl.get_subject_x500principal))
        end
        ext = cert_impl.get_crldistribution_points_extension
        points = nil
        if ((ext).nil?)
          # assume a DP with reasons and CRLIssuer fields omitted
          # and a DP name of the cert issuer.
          # TODO add issuerAltName too
          cert_issuer = cert_impl.get_issuer_dn
          point = DistributionPoint.new(GeneralNames.new.add(GeneralName.new(cert_issuer)), nil, nil)
          points = Collections.singleton_list(point)
        else
          points = ext.get(CRLDistributionPointsExtension::POINTS)
        end
        results = HashSet.new
        dpf = DistributionPointFetcher.get_instance
        t = points.iterator
        while t.has_next && !(Arrays == reasons_mask)
          point = t.next_
          crls.each do |crl|
            if (dpf.verify_crl(cert_impl, point, crl, reasons_mask, sign_flag, prev_key, @m_sig_provider, @m_anchor, @m_stores))
              results.add(crl)
            end
          end
        end
        return results
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("Exception while verifying CRL: " + RJava.cast_to_string(e.get_message))
          e.print_stack_trace
        end
        return Collections.empty_set
      end
    end
    
    class_module.module_eval {
      # Indicates that the certificate has been revoked.
      const_set_lazy(:CertificateRevokedException) { Class.new(CertPathValidatorException) do
        include_class_members CrlRevocationChecker
        
        typesig { [self::String] }
        def initialize(msg)
          super(msg)
        end
        
        private
        alias_method :initialize__certificate_revoked_exception, :initialize
      end }
    }
    
    private
    alias_method :initialize__crl_revocation_checker, :initialize
  end
  
end
