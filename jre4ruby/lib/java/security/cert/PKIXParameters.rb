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
module Java::Security::Cert
  module PKIXParametersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :KeyStore
      include_const ::Java::Security, :KeyStoreException
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :JavaSet
    }
  end
  
  # Parameters used as input for the PKIX <code>CertPathValidator</code>
  # algorithm.
  # <p>
  # A PKIX <code>CertPathValidator</code> uses these parameters to
  # validate a <code>CertPath</code> according to the PKIX certification path
  # validation algorithm.
  # 
  # <p>To instantiate a <code>PKIXParameters</code> object, an
  # application must specify one or more <i>most-trusted CAs</i> as defined by
  # the PKIX certification path validation algorithm. The most-trusted CAs
  # can be specified using one of two constructors. An application
  # can call {@link #PKIXParameters(Set) PKIXParameters(Set)},
  # specifying a <code>Set</code> of <code>TrustAnchor</code> objects, each
  # of which identify a most-trusted CA. Alternatively, an application can call
  # {@link #PKIXParameters(KeyStore) PKIXParameters(KeyStore)}, specifying a
  # <code>KeyStore</code> instance containing trusted certificate entries, each
  # of which will be considered as a most-trusted CA.
  # <p>
  # Once a <code>PKIXParameters</code> object has been created, other parameters
  # can be specified (by calling {@link #setInitialPolicies setInitialPolicies}
  # or {@link #setDate setDate}, for instance) and then the
  # <code>PKIXParameters</code> is passed along with the <code>CertPath</code>
  # to be validated to {@link CertPathValidator#validate
  # CertPathValidator.validate}.
  # <p>
  # Any parameter that is not set (or is set to <code>null</code>) will
  # be set to the default value for that parameter. The default value for the
  # <code>date</code> parameter is <code>null</code>, which indicates
  # the current time when the path is validated. The default for the
  # remaining parameters is the least constrained.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CertPathValidator
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  class PKIXParameters 
    include_class_members PKIXParametersImports
    include CertPathParameters
    
    attr_accessor :unmod_trust_anchors
    alias_method :attr_unmod_trust_anchors, :unmod_trust_anchors
    undef_method :unmod_trust_anchors
    alias_method :attr_unmod_trust_anchors=, :unmod_trust_anchors=
    undef_method :unmod_trust_anchors=
    
    attr_accessor :date
    alias_method :attr_date, :date
    undef_method :date
    alias_method :attr_date=, :date=
    undef_method :date=
    
    attr_accessor :cert_path_checkers
    alias_method :attr_cert_path_checkers, :cert_path_checkers
    undef_method :cert_path_checkers
    alias_method :attr_cert_path_checkers=, :cert_path_checkers=
    undef_method :cert_path_checkers=
    
    attr_accessor :sig_provider
    alias_method :attr_sig_provider, :sig_provider
    undef_method :sig_provider
    alias_method :attr_sig_provider=, :sig_provider=
    undef_method :sig_provider=
    
    attr_accessor :revocation_enabled
    alias_method :attr_revocation_enabled, :revocation_enabled
    undef_method :revocation_enabled
    alias_method :attr_revocation_enabled=, :revocation_enabled=
    undef_method :revocation_enabled=
    
    attr_accessor :unmod_initial_policies
    alias_method :attr_unmod_initial_policies, :unmod_initial_policies
    undef_method :unmod_initial_policies
    alias_method :attr_unmod_initial_policies=, :unmod_initial_policies=
    undef_method :unmod_initial_policies=
    
    attr_accessor :explicit_policy_required
    alias_method :attr_explicit_policy_required, :explicit_policy_required
    undef_method :explicit_policy_required
    alias_method :attr_explicit_policy_required=, :explicit_policy_required=
    undef_method :explicit_policy_required=
    
    attr_accessor :policy_mapping_inhibited
    alias_method :attr_policy_mapping_inhibited, :policy_mapping_inhibited
    undef_method :policy_mapping_inhibited
    alias_method :attr_policy_mapping_inhibited=, :policy_mapping_inhibited=
    undef_method :policy_mapping_inhibited=
    
    attr_accessor :any_policy_inhibited
    alias_method :attr_any_policy_inhibited, :any_policy_inhibited
    undef_method :any_policy_inhibited
    alias_method :attr_any_policy_inhibited=, :any_policy_inhibited=
    undef_method :any_policy_inhibited=
    
    attr_accessor :policy_qualifiers_rejected
    alias_method :attr_policy_qualifiers_rejected, :policy_qualifiers_rejected
    undef_method :policy_qualifiers_rejected
    alias_method :attr_policy_qualifiers_rejected=, :policy_qualifiers_rejected=
    undef_method :policy_qualifiers_rejected=
    
    attr_accessor :cert_stores
    alias_method :attr_cert_stores, :cert_stores
    undef_method :cert_stores
    alias_method :attr_cert_stores=, :cert_stores=
    undef_method :cert_stores=
    
    attr_accessor :cert_selector
    alias_method :attr_cert_selector, :cert_selector
    undef_method :cert_selector
    alias_method :attr_cert_selector=, :cert_selector=
    undef_method :cert_selector=
    
    typesig { [JavaSet] }
    # Creates an instance of <code>PKIXParameters</code> with the specified
    # <code>Set</code> of most-trusted CAs. Each element of the
    # set is a {@link TrustAnchor TrustAnchor}.
    # <p>
    # Note that the <code>Set</code> is copied to protect against
    # subsequent modifications.
    # 
    # @param trustAnchors a <code>Set</code> of <code>TrustAnchor</code>s
    # @throws InvalidAlgorithmParameterException if the specified
    # <code>Set</code> is empty <code>(trustAnchors.isEmpty() == true)</code>
    # @throws NullPointerException if the specified <code>Set</code> is
    # <code>null</code>
    # @throws ClassCastException if any of the elements in the <code>Set</code>
    # are not of type <code>java.security.cert.TrustAnchor</code>
    def initialize(trust_anchors)
      @unmod_trust_anchors = nil
      @date = nil
      @cert_path_checkers = nil
      @sig_provider = nil
      @revocation_enabled = true
      @unmod_initial_policies = nil
      @explicit_policy_required = false
      @policy_mapping_inhibited = false
      @any_policy_inhibited = false
      @policy_qualifiers_rejected = true
      @cert_stores = nil
      @cert_selector = nil
      set_trust_anchors(trust_anchors)
      @unmod_initial_policies = Collections.empty_set
      @cert_path_checkers = ArrayList.new
      @cert_stores = ArrayList.new
    end
    
    typesig { [KeyStore] }
    # Creates an instance of <code>PKIXParameters</code> that
    # populates the set of most-trusted CAs from the trusted
    # certificate entries contained in the specified <code>KeyStore</code>.
    # Only keystore entries that contain trusted <code>X509Certificates</code>
    # are considered; all other certificate types are ignored.
    # 
    # @param keystore a <code>KeyStore</code> from which the set of
    # most-trusted CAs will be populated
    # @throws KeyStoreException if the keystore has not been initialized
    # @throws InvalidAlgorithmParameterException if the keystore does
    # not contain at least one trusted certificate entry
    # @throws NullPointerException if the keystore is <code>null</code>
    def initialize(keystore)
      @unmod_trust_anchors = nil
      @date = nil
      @cert_path_checkers = nil
      @sig_provider = nil
      @revocation_enabled = true
      @unmod_initial_policies = nil
      @explicit_policy_required = false
      @policy_mapping_inhibited = false
      @any_policy_inhibited = false
      @policy_qualifiers_rejected = true
      @cert_stores = nil
      @cert_selector = nil
      if ((keystore).nil?)
        raise NullPointerException.new("the keystore parameter must be " + "non-null")
      end
      hash_set = HashSet.new
      aliases_ = keystore.aliases
      while (aliases_.has_more_elements)
        alias_ = aliases_.next_element
        if (keystore.is_certificate_entry(alias_))
          cert = keystore.get_certificate(alias_)
          if (cert.is_a?(X509Certificate))
            hash_set.add(TrustAnchor.new(cert, nil))
          end
        end
      end
      set_trust_anchors(hash_set)
      @unmod_initial_policies = Collections.empty_set
      @cert_path_checkers = ArrayList.new
      @cert_stores = ArrayList.new
    end
    
    typesig { [] }
    # Returns an immutable <code>Set</code> of the most-trusted
    # CAs.
    # 
    # @return an immutable <code>Set</code> of <code>TrustAnchor</code>s
    # (never <code>null</code>)
    # 
    # @see #setTrustAnchors
    def get_trust_anchors
      return @unmod_trust_anchors
    end
    
    typesig { [JavaSet] }
    # Sets the <code>Set</code> of most-trusted CAs.
    # <p>
    # Note that the <code>Set</code> is copied to protect against
    # subsequent modifications.
    # 
    # @param trustAnchors a <code>Set</code> of <code>TrustAnchor</code>s
    # @throws InvalidAlgorithmParameterException if the specified
    # <code>Set</code> is empty <code>(trustAnchors.isEmpty() == true)</code>
    # @throws NullPointerException if the specified <code>Set</code> is
    # <code>null</code>
    # @throws ClassCastException if any of the elements in the set
    # are not of type <code>java.security.cert.TrustAnchor</code>
    # 
    # @see #getTrustAnchors
    def set_trust_anchors(trust_anchors)
      if ((trust_anchors).nil?)
        raise NullPointerException.new("the trustAnchors parameters must" + " be non-null")
      end
      if (trust_anchors.is_empty)
        raise InvalidAlgorithmParameterException.new("the trustAnchors " + "parameter must be non-empty")
      end
      i = trust_anchors.iterator
      while i.has_next
        if (!(i.next.is_a?(TrustAnchor)))
          raise ClassCastException.new("all elements of set must be " + "of type java.security.cert.TrustAnchor")
        end
      end
      @unmod_trust_anchors = Collections.unmodifiable_set(HashSet.new(trust_anchors))
    end
    
    typesig { [] }
    # Returns an immutable <code>Set</code> of initial
    # policy identifiers (OID strings), indicating that any one of these
    # policies would be acceptable to the certificate user for the purposes of
    # certification path processing. The default return value is an empty
    # <code>Set</code>, which is interpreted as meaning that any policy would
    # be acceptable.
    # 
    # @return an immutable <code>Set</code> of initial policy OIDs in
    # <code>String</code> format, or an empty <code>Set</code> (implying any
    # policy is acceptable). Never returns <code>null</code>.
    # 
    # @see #setInitialPolicies
    def get_initial_policies
      return @unmod_initial_policies
    end
    
    typesig { [JavaSet] }
    # Sets the <code>Set</code> of initial policy identifiers
    # (OID strings), indicating that any one of these
    # policies would be acceptable to the certificate user for the purposes of
    # certification path processing. By default, any policy is acceptable
    # (i.e. all policies), so a user that wants to allow any policy as
    # acceptable does not need to call this method, or can call it
    # with an empty <code>Set</code> (or <code>null</code>).
    # <p>
    # Note that the <code>Set</code> is copied to protect against
    # subsequent modifications.
    # 
    # @param initialPolicies a <code>Set</code> of initial policy
    # OIDs in <code>String</code> format (or <code>null</code>)
    # @throws ClassCastException if any of the elements in the set are
    # not of type <code>String</code>
    # 
    # @see #getInitialPolicies
    def set_initial_policies(initial_policies)
      if (!(initial_policies).nil?)
        i = initial_policies.iterator
        while i.has_next
          if (!(i.next.is_a?(String)))
            raise ClassCastException.new("all elements of set must be " + "of type java.lang.String")
          end
        end
        @unmod_initial_policies = Collections.unmodifiable_set(HashSet.new(initial_policies))
      else
        @unmod_initial_policies = Collections.empty_set
      end
    end
    
    typesig { [JavaList] }
    # Sets the list of <code>CertStore</code>s to be used in finding
    # certificates and CRLs. May be <code>null</code>, in which case
    # no <code>CertStore</code>s will be used. The first
    # <code>CertStore</code>s in the list may be preferred to those that
    # appear later.
    # <p>
    # Note that the <code>List</code> is copied to protect against
    # subsequent modifications.
    # 
    # @param stores a <code>List</code> of <code>CertStore</code>s (or
    # <code>null</code>)
    # @throws ClassCastException if any of the elements in the list are
    # not of type <code>java.security.cert.CertStore</code>
    # 
    # @see #getCertStores
    def set_cert_stores(stores)
      if ((stores).nil?)
        @cert_stores = ArrayList.new
      else
        i = stores.iterator
        while i.has_next
          if (!(i.next.is_a?(CertStore)))
            raise ClassCastException.new("all elements of list must be " + "of type java.security.cert.CertStore")
          end
        end
        @cert_stores = ArrayList.new(stores)
      end
    end
    
    typesig { [CertStore] }
    # Adds a <code>CertStore</code> to the end of the list of
    # <code>CertStore</code>s used in finding certificates and CRLs.
    # 
    # @param store the <code>CertStore</code> to add. If <code>null</code>,
    # the store is ignored (not added to list).
    def add_cert_store(store)
      if (!(store).nil?)
        @cert_stores.add(store)
      end
    end
    
    typesig { [] }
    # Returns an immutable <code>List</code> of <code>CertStore</code>s that
    # are used to find certificates and CRLs.
    # 
    # @return an immutable <code>List</code> of <code>CertStore</code>s
    # (may be empty, but never <code>null</code>)
    # 
    # @see #setCertStores
    def get_cert_stores
      return Collections.unmodifiable_list(ArrayList.new(@cert_stores))
    end
    
    typesig { [::Java::Boolean] }
    # Sets the RevocationEnabled flag. If this flag is true, the default
    # revocation checking mechanism of the underlying PKIX service provider
    # will be used. If this flag is false, the default revocation checking
    # mechanism will be disabled (not used).
    # <p>
    # When a <code>PKIXParameters</code> object is created, this flag is set
    # to true. This setting reflects the most common strategy for checking
    # revocation, since each service provider must support revocation
    # checking to be PKIX compliant. Sophisticated applications should set
    # this flag to false when it is not practical to use a PKIX service
    # provider's default revocation checking mechanism or when an alternative
    # revocation checking mechanism is to be substituted (by also calling the
    # {@link #addCertPathChecker addCertPathChecker} or {@link
    # #setCertPathCheckers setCertPathCheckers} methods).
    # 
    # @param val the new value of the RevocationEnabled flag
    def set_revocation_enabled(val)
      @revocation_enabled = val
    end
    
    typesig { [] }
    # Checks the RevocationEnabled flag. If this flag is true, the default
    # revocation checking mechanism of the underlying PKIX service provider
    # will be used. If this flag is false, the default revocation checking
    # mechanism will be disabled (not used). See the {@link
    # #setRevocationEnabled setRevocationEnabled} method for more details on
    # setting the value of this flag.
    # 
    # @return the current value of the RevocationEnabled flag
    def is_revocation_enabled
      return @revocation_enabled
    end
    
    typesig { [::Java::Boolean] }
    # Sets the ExplicitPolicyRequired flag. If this flag is true, an
    # acceptable policy needs to be explicitly identified in every certificate.
    # By default, the ExplicitPolicyRequired flag is false.
    # 
    # @param val <code>true</code> if explicit policy is to be required,
    # <code>false</code> otherwise
    def set_explicit_policy_required(val)
      @explicit_policy_required = val
    end
    
    typesig { [] }
    # Checks if explicit policy is required. If this flag is true, an
    # acceptable policy needs to be explicitly identified in every certificate.
    # By default, the ExplicitPolicyRequired flag is false.
    # 
    # @return <code>true</code> if explicit policy is required,
    # <code>false</code> otherwise
    def is_explicit_policy_required
      return @explicit_policy_required
    end
    
    typesig { [::Java::Boolean] }
    # Sets the PolicyMappingInhibited flag. If this flag is true, policy
    # mapping is inhibited. By default, policy mapping is not inhibited (the
    # flag is false).
    # 
    # @param val <code>true</code> if policy mapping is to be inhibited,
    # <code>false</code> otherwise
    def set_policy_mapping_inhibited(val)
      @policy_mapping_inhibited = val
    end
    
    typesig { [] }
    # Checks if policy mapping is inhibited. If this flag is true, policy
    # mapping is inhibited. By default, policy mapping is not inhibited (the
    # flag is false).
    # 
    # @return true if policy mapping is inhibited, false otherwise
    def is_policy_mapping_inhibited
      return @policy_mapping_inhibited
    end
    
    typesig { [::Java::Boolean] }
    # Sets state to determine if the any policy OID should be processed
    # if it is included in a certificate. By default, the any policy OID
    # is not inhibited ({@link #isAnyPolicyInhibited isAnyPolicyInhibited()}
    # returns <code>false</code>).
    # 
    # @param val <code>true</code> if the any policy OID is to be
    # inhibited, <code>false</code> otherwise
    def set_any_policy_inhibited(val)
      @any_policy_inhibited = val
    end
    
    typesig { [] }
    # Checks whether the any policy OID should be processed if it
    # is included in a certificate.
    # 
    # @return <code>true</code> if the any policy OID is inhibited,
    # <code>false</code> otherwise
    def is_any_policy_inhibited
      return @any_policy_inhibited
    end
    
    typesig { [::Java::Boolean] }
    # Sets the PolicyQualifiersRejected flag. If this flag is true,
    # certificates that include policy qualifiers in a certificate
    # policies extension that is marked critical are rejected.
    # If the flag is false, certificates are not rejected on this basis.
    # 
    # <p> When a <code>PKIXParameters</code> object is created, this flag is
    # set to true. This setting reflects the most common (and simplest)
    # strategy for processing policy qualifiers. Applications that want to use
    # a more sophisticated policy must set this flag to false.
    # <p>
    # Note that the PKIX certification path validation algorithm specifies
    # that any policy qualifier in a certificate policies extension that is
    # marked critical must be processed and validated. Otherwise the
    # certification path must be rejected. If the policyQualifiersRejected flag
    # is set to false, it is up to the application to validate all policy
    # qualifiers in this manner in order to be PKIX compliant.
    # 
    # @param qualifiersRejected the new value of the PolicyQualifiersRejected
    # flag
    # @see #getPolicyQualifiersRejected
    # @see PolicyQualifierInfo
    def set_policy_qualifiers_rejected(qualifiers_rejected)
      @policy_qualifiers_rejected = qualifiers_rejected
    end
    
    typesig { [] }
    # Gets the PolicyQualifiersRejected flag. If this flag is true,
    # certificates that include policy qualifiers in a certificate policies
    # extension that is marked critical are rejected.
    # If the flag is false, certificates are not rejected on this basis.
    # 
    # <p> When a <code>PKIXParameters</code> object is created, this flag is
    # set to true. This setting reflects the most common (and simplest)
    # strategy for processing policy qualifiers. Applications that want to use
    # a more sophisticated policy must set this flag to false.
    # 
    # @return the current value of the PolicyQualifiersRejected flag
    # @see #setPolicyQualifiersRejected
    def get_policy_qualifiers_rejected
      return @policy_qualifiers_rejected
    end
    
    typesig { [] }
    # Returns the time for which the validity of the certification path
    # should be determined. If <code>null</code>, the current time is used.
    # <p>
    # Note that the <code>Date</code> returned is copied to protect against
    # subsequent modifications.
    # 
    # @return the <code>Date</code>, or <code>null</code> if not set
    # @see #setDate
    def get_date
      if ((@date).nil?)
        return nil
      else
        return @date.clone
      end
    end
    
    typesig { [Date] }
    # Sets the time for which the validity of the certification path
    # should be determined. If <code>null</code>, the current time is used.
    # <p>
    # Note that the <code>Date</code> supplied here is copied to protect
    # against subsequent modifications.
    # 
    # @param date the <code>Date</code>, or <code>null</code> for the
    # current time
    # @see #getDate
    def set_date(date)
      if (!(date).nil?)
        @date = date.clone
      else
        date = nil
      end
    end
    
    typesig { [JavaList] }
    # Sets a <code>List</code> of additional certification path checkers. If
    # the specified <code>List</code> contains an object that is not a
    # <code>PKIXCertPathChecker</code>, it is ignored.
    # <p>
    # Each <code>PKIXCertPathChecker</code> specified implements
    # additional checks on a certificate. Typically, these are checks to
    # process and verify private extensions contained in certificates.
    # Each <code>PKIXCertPathChecker</code> should be instantiated with any
    # initialization parameters needed to execute the check.
    # <p>
    # This method allows sophisticated applications to extend a PKIX
    # <code>CertPathValidator</code> or <code>CertPathBuilder</code>.
    # Each of the specified <code>PKIXCertPathChecker</code>s will be called,
    # in turn, by a PKIX <code>CertPathValidator</code> or
    # <code>CertPathBuilder</code> for each certificate processed or
    # validated.
    # <p>
    # Regardless of whether these additional <code>PKIXCertPathChecker</code>s
    # are set, a PKIX <code>CertPathValidator</code> or
    # <code>CertPathBuilder</code> must perform all of the required PKIX
    # checks on each certificate. The one exception to this rule is if the
    # RevocationEnabled flag is set to false (see the {@link
    # #setRevocationEnabled setRevocationEnabled} method).
    # <p>
    # Note that the <code>List</code> supplied here is copied and each
    # <code>PKIXCertPathChecker</code> in the list is cloned to protect
    # against subsequent modifications.
    # 
    # @param checkers a <code>List</code> of <code>PKIXCertPathChecker</code>s.
    # May be <code>null</code>, in which case no additional checkers will be
    # used.
    # @throws ClassCastException if any of the elements in the list
    # are not of type <code>java.security.cert.PKIXCertPathChecker</code>
    # @see #getCertPathCheckers
    def set_cert_path_checkers(checkers)
      if (!(checkers).nil?)
        tmp_list = ArrayList.new
        checkers.each do |checker|
          tmp_list.add(checker.clone)
        end
        @cert_path_checkers = tmp_list
      else
        @cert_path_checkers = ArrayList.new
      end
    end
    
    typesig { [] }
    # Returns the <code>List</code> of certification path checkers.
    # The returned <code>List</code> is immutable, and each
    # <code>PKIXCertPathChecker</code> in the <code>List</code> is cloned
    # to protect against subsequent modifications.
    # 
    # @return an immutable <code>List</code> of
    # <code>PKIXCertPathChecker</code>s (may be empty, but not
    # <code>null</code>)
    # @see #setCertPathCheckers
    def get_cert_path_checkers
      tmp_list = ArrayList.new
      @cert_path_checkers.each do |ck|
        tmp_list.add(ck.clone)
      end
      return Collections.unmodifiable_list(tmp_list)
    end
    
    typesig { [PKIXCertPathChecker] }
    # Adds a <code>PKIXCertPathChecker</code> to the list of certification
    # path checkers. See the {@link #setCertPathCheckers setCertPathCheckers}
    # method for more details.
    # <p>
    # Note that the <code>PKIXCertPathChecker</code> is cloned to protect
    # against subsequent modifications.
    # 
    # @param checker a <code>PKIXCertPathChecker</code> to add to the list of
    # checks. If <code>null</code>, the checker is ignored (not added to list).
    def add_cert_path_checker(checker)
      if (!(checker).nil?)
        @cert_path_checkers.add(checker.clone)
      end
    end
    
    typesig { [] }
    # Returns the signature provider's name, or <code>null</code>
    # if not set.
    # 
    # @return the signature provider's name (or <code>null</code>)
    # @see #setSigProvider
    def get_sig_provider
      return @sig_provider
    end
    
    typesig { [String] }
    # Sets the signature provider's name. The specified provider will be
    # preferred when creating {@link java.security.Signature Signature}
    # objects. If <code>null</code> or not set, the first provider found
    # supporting the algorithm will be used.
    # 
    # @param sigProvider the signature provider's name (or <code>null</code>)
    # @see #getSigProvider
    def set_sig_provider(sig_provider)
      @sig_provider = sig_provider
    end
    
    typesig { [] }
    # Returns the required constraints on the target certificate.
    # The constraints are returned as an instance of <code>CertSelector</code>.
    # If <code>null</code>, no constraints are defined.
    # 
    # <p>Note that the <code>CertSelector</code> returned is cloned
    # to protect against subsequent modifications.
    # 
    # @return a <code>CertSelector</code> specifying the constraints
    # on the target certificate (or <code>null</code>)
    # @see #setTargetCertConstraints
    def get_target_cert_constraints
      if (!(@cert_selector).nil?)
        return @cert_selector.clone
      else
        return nil
      end
    end
    
    typesig { [CertSelector] }
    # Sets the required constraints on the target certificate.
    # The constraints are specified as an instance of
    # <code>CertSelector</code>. If <code>null</code>, no constraints are
    # defined.
    # 
    # <p>Note that the <code>CertSelector</code> specified is cloned
    # to protect against subsequent modifications.
    # 
    # @param selector a <code>CertSelector</code> specifying the constraints
    # on the target certificate (or <code>null</code>)
    # @see #getTargetCertConstraints
    def set_target_cert_constraints(selector)
      if (!(selector).nil?)
        @cert_selector = selector.clone
      else
        @cert_selector = nil
      end
    end
    
    typesig { [] }
    # Makes a copy of this <code>PKIXParameters</code> object. Changes
    # to the copy will not affect the original and vice versa.
    # 
    # @return a copy of this <code>PKIXParameters</code> object
    def clone
      begin
        copy = super
        # Must clone these because addCertStore, et al. modify them
        if (!(@cert_stores).nil?)
          @cert_stores = ArrayList.new(@cert_stores)
        end
        if (!(@cert_path_checkers).nil?)
          @cert_path_checkers = ArrayList.new(@cert_path_checkers)
        end
        return copy
      rescue CloneNotSupportedException => e
        # Cannot happen
        raise InternalError.new(e.to_s)
      end
    end
    
    typesig { [] }
    # Returns a formatted string describing the parameters.
    # 
    # @return a formatted string describing the parameters.
    def to_s
      sb = StringBuffer.new
      sb.append("[\n")
      # start with trusted anchor info
      if (!(@unmod_trust_anchors).nil?)
        sb.append("  Trust Anchors: " + (@unmod_trust_anchors.to_s).to_s + "\n")
      end
      # now, append initial state information
      if (!(@unmod_initial_policies).nil?)
        if (@unmod_initial_policies.is_empty)
          sb.append("  Initial Policy OIDs: any\n")
        else
          sb.append("  Initial Policy OIDs: [" + (@unmod_initial_policies.to_s).to_s + "]\n")
        end
      end
      # now, append constraints on all certificates in the path
      sb.append("  Validity Date: " + (String.value_of(@date)).to_s + "\n")
      sb.append("  Signature Provider: " + (String.value_of(@sig_provider)).to_s + "\n")
      sb.append("  Default Revocation Enabled: " + (@revocation_enabled).to_s + "\n")
      sb.append("  Explicit Policy Required: " + (@explicit_policy_required).to_s + "\n")
      sb.append("  Policy Mapping Inhibited: " + (@policy_mapping_inhibited).to_s + "\n")
      sb.append("  Any Policy Inhibited: " + (@any_policy_inhibited).to_s + "\n")
      sb.append("  Policy Qualifiers Rejected: " + (@policy_qualifiers_rejected).to_s + "\n")
      # now, append target cert requirements
      sb.append("  Target Cert Constraints: " + (String.value_of(@cert_selector)).to_s + "\n")
      # finally, append miscellaneous parameters
      if (!(@cert_path_checkers).nil?)
        sb.append("  Certification Path Checkers: [" + (@cert_path_checkers.to_s).to_s + "]\n")
      end
      if (!(@cert_stores).nil?)
        sb.append("  CertStores: [" + (@cert_stores.to_s).to_s + "]\n")
      end
      sb.append("]")
      return sb.to_s
    end
    
    private
    alias_method :initialize__pkixparameters, :initialize
  end
  
end
