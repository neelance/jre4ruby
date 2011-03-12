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
  module X509CertSelectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :PublicKey
      include ::Java::Util
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include ::Sun::Security::X509
    }
  end
  
  # A <code>CertSelector</code> that selects <code>X509Certificates</code> that
  # match all specified criteria. This class is particularly useful when
  # selecting certificates from a <code>CertStore</code> to build a
  # PKIX-compliant certification path.
  # <p>
  # When first constructed, an <code>X509CertSelector</code> has no criteria
  # enabled and each of the <code>get</code> methods return a default value
  # (<code>null</code>, or <code>-1</code> for the {@link #getBasicConstraints
  # getBasicConstraints} method). Therefore, the {@link #match match}
  # method would return <code>true</code> for any <code>X509Certificate</code>.
  # Typically, several criteria are enabled (by calling
  # {@link #setIssuer setIssuer} or
  # {@link #setKeyUsage setKeyUsage}, for instance) and then the
  # <code>X509CertSelector</code> is passed to
  # {@link CertStore#getCertificates CertStore.getCertificates} or some similar
  # method.
  # <p>
  # Several criteria can be enabled (by calling {@link #setIssuer setIssuer}
  # and {@link #setSerialNumber setSerialNumber},
  # for example) such that the <code>match</code> method
  # usually uniquely matches a single <code>X509Certificate</code>. We say
  # usually, since it is possible for two issuing CAs to have the same
  # distinguished name and each issue a certificate with the same serial
  # number. Other unique combinations include the issuer, subject,
  # subjectKeyIdentifier and/or the subjectPublicKey criteria.
  # <p>
  # Please refer to <a href="http://www.ietf.org/rfc/rfc3280.txt">RFC 3280:
  # Internet X.509 Public Key Infrastructure Certificate and CRL Profile</a> for
  # definitions of the X.509 certificate extensions mentioned below.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CertSelector
  # @see X509Certificate
  # 
  # @since       1.4
  # @author      Steve Hanna
  class X509CertSelector 
    include_class_members X509CertSelectorImports
    include CertSelector
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      const_set_lazy(:ANY_EXTENDED_KEY_USAGE) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([2, 5, 29, 37, 0])) }
      const_attr_reader  :ANY_EXTENDED_KEY_USAGE
      
      when_class_loaded do
        CertPathHelperImpl.initialize_
      end
    }
    
    attr_accessor :serial_number
    alias_method :attr_serial_number, :serial_number
    undef_method :serial_number
    alias_method :attr_serial_number=, :serial_number=
    undef_method :serial_number=
    
    attr_accessor :issuer
    alias_method :attr_issuer, :issuer
    undef_method :issuer
    alias_method :attr_issuer=, :issuer=
    undef_method :issuer=
    
    attr_accessor :subject
    alias_method :attr_subject, :subject
    undef_method :subject
    alias_method :attr_subject=, :subject=
    undef_method :subject=
    
    attr_accessor :subject_key_id
    alias_method :attr_subject_key_id, :subject_key_id
    undef_method :subject_key_id
    alias_method :attr_subject_key_id=, :subject_key_id=
    undef_method :subject_key_id=
    
    attr_accessor :authority_key_id
    alias_method :attr_authority_key_id, :authority_key_id
    undef_method :authority_key_id
    alias_method :attr_authority_key_id=, :authority_key_id=
    undef_method :authority_key_id=
    
    attr_accessor :certificate_valid
    alias_method :attr_certificate_valid, :certificate_valid
    undef_method :certificate_valid
    alias_method :attr_certificate_valid=, :certificate_valid=
    undef_method :certificate_valid=
    
    attr_accessor :private_key_valid
    alias_method :attr_private_key_valid, :private_key_valid
    undef_method :private_key_valid
    alias_method :attr_private_key_valid=, :private_key_valid=
    undef_method :private_key_valid=
    
    attr_accessor :subject_public_key_alg_id
    alias_method :attr_subject_public_key_alg_id, :subject_public_key_alg_id
    undef_method :subject_public_key_alg_id
    alias_method :attr_subject_public_key_alg_id=, :subject_public_key_alg_id=
    undef_method :subject_public_key_alg_id=
    
    attr_accessor :subject_public_key
    alias_method :attr_subject_public_key, :subject_public_key
    undef_method :subject_public_key
    alias_method :attr_subject_public_key=, :subject_public_key=
    undef_method :subject_public_key=
    
    attr_accessor :subject_public_key_bytes
    alias_method :attr_subject_public_key_bytes, :subject_public_key_bytes
    undef_method :subject_public_key_bytes
    alias_method :attr_subject_public_key_bytes=, :subject_public_key_bytes=
    undef_method :subject_public_key_bytes=
    
    attr_accessor :key_usage
    alias_method :attr_key_usage, :key_usage
    undef_method :key_usage
    alias_method :attr_key_usage=, :key_usage=
    undef_method :key_usage=
    
    attr_accessor :key_purpose_set
    alias_method :attr_key_purpose_set, :key_purpose_set
    undef_method :key_purpose_set
    alias_method :attr_key_purpose_set=, :key_purpose_set=
    undef_method :key_purpose_set=
    
    attr_accessor :key_purpose_oidset
    alias_method :attr_key_purpose_oidset, :key_purpose_oidset
    undef_method :key_purpose_oidset
    alias_method :attr_key_purpose_oidset=, :key_purpose_oidset=
    undef_method :key_purpose_oidset=
    
    attr_accessor :subject_alternative_names
    alias_method :attr_subject_alternative_names, :subject_alternative_names
    undef_method :subject_alternative_names
    alias_method :attr_subject_alternative_names=, :subject_alternative_names=
    undef_method :subject_alternative_names=
    
    attr_accessor :subject_alternative_general_names
    alias_method :attr_subject_alternative_general_names, :subject_alternative_general_names
    undef_method :subject_alternative_general_names
    alias_method :attr_subject_alternative_general_names=, :subject_alternative_general_names=
    undef_method :subject_alternative_general_names=
    
    attr_accessor :policy
    alias_method :attr_policy, :policy
    undef_method :policy
    alias_method :attr_policy=, :policy=
    undef_method :policy=
    
    attr_accessor :policy_set
    alias_method :attr_policy_set, :policy_set
    undef_method :policy_set
    alias_method :attr_policy_set=, :policy_set=
    undef_method :policy_set=
    
    attr_accessor :path_to_names
    alias_method :attr_path_to_names, :path_to_names
    undef_method :path_to_names
    alias_method :attr_path_to_names=, :path_to_names=
    undef_method :path_to_names=
    
    attr_accessor :path_to_general_names
    alias_method :attr_path_to_general_names, :path_to_general_names
    undef_method :path_to_general_names
    alias_method :attr_path_to_general_names=, :path_to_general_names=
    undef_method :path_to_general_names=
    
    attr_accessor :nc
    alias_method :attr_nc, :nc
    undef_method :nc
    alias_method :attr_nc=, :nc=
    undef_method :nc=
    
    attr_accessor :nc_bytes
    alias_method :attr_nc_bytes, :nc_bytes
    undef_method :nc_bytes
    alias_method :attr_nc_bytes=, :nc_bytes=
    undef_method :nc_bytes=
    
    attr_accessor :basic_constraints
    alias_method :attr_basic_constraints, :basic_constraints
    undef_method :basic_constraints
    alias_method :attr_basic_constraints=, :basic_constraints=
    undef_method :basic_constraints=
    
    attr_accessor :x509cert
    alias_method :attr_x509cert, :x509cert
    undef_method :x509cert
    alias_method :attr_x509cert=, :x509cert=
    undef_method :x509cert=
    
    attr_accessor :match_all_subject_alt_names
    alias_method :attr_match_all_subject_alt_names, :match_all_subject_alt_names
    undef_method :match_all_subject_alt_names
    alias_method :attr_match_all_subject_alt_names=, :match_all_subject_alt_names=
    undef_method :match_all_subject_alt_names=
    
    class_module.module_eval {
      const_set_lazy(:FALSE) { Boolean::FALSE }
      const_attr_reader  :FALSE
      
      const_set_lazy(:PRIVATE_KEY_USAGE_ID) { 0 }
      const_attr_reader  :PRIVATE_KEY_USAGE_ID
      
      const_set_lazy(:SUBJECT_ALT_NAME_ID) { 1 }
      const_attr_reader  :SUBJECT_ALT_NAME_ID
      
      const_set_lazy(:NAME_CONSTRAINTS_ID) { 2 }
      const_attr_reader  :NAME_CONSTRAINTS_ID
      
      const_set_lazy(:CERT_POLICIES_ID) { 3 }
      const_attr_reader  :CERT_POLICIES_ID
      
      const_set_lazy(:EXTENDED_KEY_USAGE_ID) { 4 }
      const_attr_reader  :EXTENDED_KEY_USAGE_ID
      
      const_set_lazy(:NUM_OF_EXTENSIONS) { 5 }
      const_attr_reader  :NUM_OF_EXTENSIONS
      
      const_set_lazy(:EXTENSION_OIDS) { Array.typed(String).new(NUM_OF_EXTENSIONS) { nil } }
      const_attr_reader  :EXTENSION_OIDS
      
      when_class_loaded do
        EXTENSION_OIDS[PRIVATE_KEY_USAGE_ID] = "2.5.29.16"
        EXTENSION_OIDS[SUBJECT_ALT_NAME_ID] = "2.5.29.17"
        EXTENSION_OIDS[NAME_CONSTRAINTS_ID] = "2.5.29.30"
        EXTENSION_OIDS[CERT_POLICIES_ID] = "2.5.29.32"
        EXTENSION_OIDS[EXTENDED_KEY_USAGE_ID] = "2.5.29.37"
      end
      
      # Constants representing the GeneralName types
      const_set_lazy(:NAME_ANY) { 0 }
      const_attr_reader  :NAME_ANY
      
      const_set_lazy(:NAME_RFC822) { 1 }
      const_attr_reader  :NAME_RFC822
      
      const_set_lazy(:NAME_DNS) { 2 }
      const_attr_reader  :NAME_DNS
      
      const_set_lazy(:NAME_X400) { 3 }
      const_attr_reader  :NAME_X400
      
      const_set_lazy(:NAME_DIRECTORY) { 4 }
      const_attr_reader  :NAME_DIRECTORY
      
      const_set_lazy(:NAME_EDI) { 5 }
      const_attr_reader  :NAME_EDI
      
      const_set_lazy(:NAME_URI) { 6 }
      const_attr_reader  :NAME_URI
      
      const_set_lazy(:NAME_IP) { 7 }
      const_attr_reader  :NAME_IP
      
      const_set_lazy(:NAME_OID) { 8 }
      const_attr_reader  :NAME_OID
    }
    
    typesig { [] }
    # Creates an <code>X509CertSelector</code>. Initially, no criteria are set
    # so any <code>X509Certificate</code> will match.
    def initialize
      @serial_number = nil
      @issuer = nil
      @subject = nil
      @subject_key_id = nil
      @authority_key_id = nil
      @certificate_valid = nil
      @private_key_valid = nil
      @subject_public_key_alg_id = nil
      @subject_public_key = nil
      @subject_public_key_bytes = nil
      @key_usage = nil
      @key_purpose_set = nil
      @key_purpose_oidset = nil
      @subject_alternative_names = nil
      @subject_alternative_general_names = nil
      @policy = nil
      @policy_set = nil
      @path_to_names = nil
      @path_to_general_names = nil
      @nc = nil
      @nc_bytes = nil
      @basic_constraints = -1
      @x509cert = nil
      @match_all_subject_alt_names = true
      # empty
    end
    
    typesig { [X509Certificate] }
    # Sets the certificateEquals criterion. The specified
    # <code>X509Certificate</code> must be equal to the
    # <code>X509Certificate</code> passed to the <code>match</code> method.
    # If <code>null</code>, then this check is not applied.
    # 
    # <p>This method is particularly useful when it is necessary to
    # match a single certificate. Although other criteria can be specified
    # in conjunction with the certificateEquals criterion, it is usually not
    # practical or necessary.
    # 
    # @param cert the <code>X509Certificate</code> to match (or
    # <code>null</code>)
    # @see #getCertificate
    def set_certificate(cert)
      @x509cert = cert
    end
    
    typesig { [BigInteger] }
    # Sets the serialNumber criterion. The specified serial number
    # must match the certificate serial number in the
    # <code>X509Certificate</code>. If <code>null</code>, any certificate
    # serial number will do.
    # 
    # @param serial the certificate serial number to match
    #        (or <code>null</code>)
    # @see #getSerialNumber
    def set_serial_number(serial)
      @serial_number = serial
    end
    
    typesig { [X500Principal] }
    # Sets the issuer criterion. The specified distinguished name
    # must match the issuer distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, any issuer
    # distinguished name will do.
    # 
    # @param issuer a distinguished name as X500Principal
    #                 (or <code>null</code>)
    # @since 1.5
    def set_issuer(issuer)
      @issuer = issuer
    end
    
    typesig { [String] }
    # <strong>Denigrated</strong>, use {@linkplain #setIssuer(X500Principal)}
    # or {@linkplain #setIssuer(byte[])} instead. This method should not be
    # relied on as it can fail to match some certificates because of a loss of
    # encoding information in the
    # <a href="http://www.ietf.org/rfc/rfc2253.txt">RFC 2253</a> String form
    # of some distinguished names.
    # <p>
    # Sets the issuer criterion. The specified distinguished name
    # must match the issuer distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, any issuer
    # distinguished name will do.
    # <p>
    # If <code>issuerDN</code> is not <code>null</code>, it should contain a
    # distinguished name, in RFC 2253 format.
    # 
    # @param issuerDN a distinguished name in RFC 2253 format
    #                 (or <code>null</code>)
    # @throws IOException if a parsing error occurs (incorrect form for DN)
    def set_issuer(issuer_dn)
      if ((issuer_dn).nil?)
        @issuer = nil
      else
        @issuer = X500Name.new(issuer_dn).as_x500principal
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the issuer criterion. The specified distinguished name
    # must match the issuer distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code> is specified,
    # the issuer criterion is disabled and any issuer distinguished name will
    # do.
    # <p>
    # If <code>issuerDN</code> is not <code>null</code>, it should contain a
    # single DER encoded distinguished name, as defined in X.501. The ASN.1
    # notation for this structure is as follows.
    # <pre><code>
    # Name ::= CHOICE {
    #   RDNSequence }
    # 
    # RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
    # 
    # RelativeDistinguishedName ::=
    #   SET SIZE (1 .. MAX) OF AttributeTypeAndValue
    # 
    # AttributeTypeAndValue ::= SEQUENCE {
    #   type     AttributeType,
    #   value    AttributeValue }
    # 
    # AttributeType ::= OBJECT IDENTIFIER
    # 
    # AttributeValue ::= ANY DEFINED BY AttributeType
    # ....
    # DirectoryString ::= CHOICE {
    #       teletexString           TeletexString (SIZE (1..MAX)),
    #       printableString         PrintableString (SIZE (1..MAX)),
    #       universalString         UniversalString (SIZE (1..MAX)),
    #       utf8String              UTF8String (SIZE (1.. MAX)),
    #       bmpString               BMPString (SIZE (1..MAX)) }
    # </code></pre>
    # <p>
    # Note that the byte array specified here is cloned to protect against
    # subsequent modifications.
    # 
    # @param issuerDN a byte array containing the distinguished name
    #                 in ASN.1 DER encoded form (or <code>null</code>)
    # @throws IOException if an encoding error occurs (incorrect form for DN)
    def set_issuer(issuer_dn)
      begin
        @issuer = ((issuer_dn).nil? ? nil : X500Principal.new(issuer_dn))
      rescue IllegalArgumentException => e
        raise IOException.new("Invalid name").init_cause(e)
      end
    end
    
    typesig { [X500Principal] }
    # Sets the subject criterion. The specified distinguished name
    # must match the subject distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, any subject
    # distinguished name will do.
    # 
    # @param subject a distinguished name as X500Principal
    #                  (or <code>null</code>)
    # @since 1.5
    def set_subject(subject)
      @subject = subject
    end
    
    typesig { [String] }
    # <strong>Denigrated</strong>, use {@linkplain #setSubject(X500Principal)}
    # or {@linkplain #setSubject(byte[])} instead. This method should not be
    # relied on as it can fail to match some certificates because of a loss of
    # encoding information in the RFC 2253 String form of some distinguished
    # names.
    # <p>
    # Sets the subject criterion. The specified distinguished name
    # must match the subject distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, any subject
    # distinguished name will do.
    # <p>
    # If <code>subjectDN</code> is not <code>null</code>, it should contain a
    # distinguished name, in RFC 2253 format.
    # 
    # @param subjectDN a distinguished name in RFC 2253 format
    #                  (or <code>null</code>)
    # @throws IOException if a parsing error occurs (incorrect form for DN)
    def set_subject(subject_dn)
      if ((subject_dn).nil?)
        @subject = nil
      else
        @subject = X500Name.new(subject_dn).as_x500principal
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the subject criterion. The specified distinguished name
    # must match the subject distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, any subject
    # distinguished name will do.
    # <p>
    # If <code>subjectDN</code> is not <code>null</code>, it should contain a
    # single DER encoded distinguished name, as defined in X.501. For the ASN.1
    # notation for this structure, see
    # {@link #setIssuer(byte [] issuerDN) setIssuer(byte [] issuerDN)}.
    # 
    # @param subjectDN a byte array containing the distinguished name in
    #                  ASN.1 DER format (or <code>null</code>)
    # @throws IOException if an encoding error occurs (incorrect form for DN)
    def set_subject(subject_dn)
      begin
        @subject = ((subject_dn).nil? ? nil : X500Principal.new(subject_dn))
      rescue IllegalArgumentException => e
        raise IOException.new("Invalid name").init_cause(e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the subjectKeyIdentifier criterion. The
    # <code>X509Certificate</code> must contain a SubjectKeyIdentifier
    # extension for which the contents of the extension
    # matches the specified criterion value.
    # If the criterion value is <code>null</code>, no
    # subjectKeyIdentifier check will be done.
    # <p>
    # If <code>subjectKeyID</code> is not <code>null</code>, it
    # should contain a single DER encoded value corresponding to the contents
    # of the extension value (not including the object identifier,
    # criticality setting, and encapsulating OCTET STRING)
    # for a SubjectKeyIdentifier extension.
    # The ASN.1 notation for this structure follows.
    # <p>
    # <pre><code>
    # SubjectKeyIdentifier ::= KeyIdentifier
    # 
    # KeyIdentifier ::= OCTET STRING
    # </code></pre>
    # <p>
    # Since the format of subject key identifiers is not mandated by
    # any standard, subject key identifiers are not parsed by the
    # <code>X509CertSelector</code>. Instead, the values are compared using
    # a byte-by-byte comparison.
    # <p>
    # Note that the byte array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param subjectKeyID the subject key identifier (or <code>null</code>)
    # @see #getSubjectKeyIdentifier
    def set_subject_key_identifier(subject_key_id)
      if ((subject_key_id).nil?)
        @subject_key_id = nil
      else
        @subject_key_id = subject_key_id.clone
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the authorityKeyIdentifier criterion. The
    # <code>X509Certificate</code> must contain an
    # AuthorityKeyIdentifier extension for which the contents of the
    # extension value matches the specified criterion value.
    # If the criterion value is <code>null</code>, no
    # authorityKeyIdentifier check will be done.
    # <p>
    # If <code>authorityKeyID</code> is not <code>null</code>, it
    # should contain a single DER encoded value corresponding to the contents
    # of the extension value (not including the object identifier,
    # criticality setting, and encapsulating OCTET STRING)
    # for an AuthorityKeyIdentifier extension.
    # The ASN.1 notation for this structure follows.
    # <p>
    # <pre><code>
    # AuthorityKeyIdentifier ::= SEQUENCE {
    #    keyIdentifier             [0] KeyIdentifier           OPTIONAL,
    #    authorityCertIssuer       [1] GeneralNames            OPTIONAL,
    #    authorityCertSerialNumber [2] CertificateSerialNumber OPTIONAL  }
    # 
    # KeyIdentifier ::= OCTET STRING
    # </code></pre>
    # <p>
    # Authority key identifiers are not parsed by the
    # <code>X509CertSelector</code>.  Instead, the values are
    # compared using a byte-by-byte comparison.
    # <p>
    # When the <code>keyIdentifier</code> field of
    # <code>AuthorityKeyIdentifier</code> is populated, the value is
    # usually taken from the <code>SubjectKeyIdentifier</code> extension
    # in the issuer's certificate.  Note, however, that the result of
    # <code>X509Certificate.getExtensionValue(&lt;SubjectKeyIdentifier Object
    # Identifier&gt;)</code> on the issuer's certificate may NOT be used
    # directly as the input to <code>setAuthorityKeyIdentifier</code>.
    # This is because the SubjectKeyIdentifier contains
    # only a KeyIdentifier OCTET STRING, and not a SEQUENCE of
    # KeyIdentifier, GeneralNames, and CertificateSerialNumber.
    # In order to use the extension value of the issuer certificate's
    # <code>SubjectKeyIdentifier</code>
    # extension, it will be necessary to extract the value of the embedded
    # <code>KeyIdentifier</code> OCTET STRING, then DER encode this OCTET
    # STRING inside a SEQUENCE.
    # For more details on SubjectKeyIdentifier, see
    # {@link #setSubjectKeyIdentifier(byte[] subjectKeyID)}.
    # <p>
    # Note also that the byte array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param authorityKeyID the authority key identifier
    #        (or <code>null</code>)
    # @see #getAuthorityKeyIdentifier
    def set_authority_key_identifier(authority_key_id)
      if ((authority_key_id).nil?)
        @authority_key_id = nil
      else
        @authority_key_id = authority_key_id.clone
      end
    end
    
    typesig { [JavaDate] }
    # Sets the certificateValid criterion. The specified date must fall
    # within the certificate validity period for the
    # <code>X509Certificate</code>. If <code>null</code>, no certificateValid
    # check will be done.
    # <p>
    # Note that the <code>Date</code> supplied here is cloned to protect
    # against subsequent modifications.
    # 
    # @param certValid the <code>Date</code> to check (or <code>null</code>)
    # @see #getCertificateValid
    def set_certificate_valid(cert_valid)
      if ((cert_valid).nil?)
        @certificate_valid = nil
      else
        @certificate_valid = cert_valid.clone
      end
    end
    
    typesig { [JavaDate] }
    # Sets the privateKeyValid criterion. The specified date must fall
    # within the private key validity period for the
    # <code>X509Certificate</code>. If <code>null</code>, no privateKeyValid
    # check will be done.
    # <p>
    # Note that the <code>Date</code> supplied here is cloned to protect
    # against subsequent modifications.
    # 
    # @param privateKeyValid the <code>Date</code> to check (or
    #                        <code>null</code>)
    # @see #getPrivateKeyValid
    def set_private_key_valid(private_key_valid)
      if ((private_key_valid).nil?)
        @private_key_valid = nil
      else
        @private_key_valid = private_key_valid.clone
      end
    end
    
    typesig { [String] }
    # Sets the subjectPublicKeyAlgID criterion. The
    # <code>X509Certificate</code> must contain a subject public key
    # with the specified algorithm. If <code>null</code>, no
    # subjectPublicKeyAlgID check will be done.
    # 
    # @param oid The object identifier (OID) of the algorithm to check
    #            for (or <code>null</code>). An OID is represented by a
    #            set of nonnegative integers separated by periods.
    # @throws IOException if the OID is invalid, such as
    # the first component being not 0, 1 or 2 or the second component
    # being greater than 39.
    # 
    # @see #getSubjectPublicKeyAlgID
    def set_subject_public_key_alg_id(oid)
      if ((oid).nil?)
        @subject_public_key_alg_id = nil
      else
        @subject_public_key_alg_id = ObjectIdentifier.new(oid)
      end
    end
    
    typesig { [PublicKey] }
    # Sets the subjectPublicKey criterion. The
    # <code>X509Certificate</code> must contain the specified subject public
    # key. If <code>null</code>, no subjectPublicKey check will be done.
    # 
    # @param key the subject public key to check for (or <code>null</code>)
    # @see #getSubjectPublicKey
    def set_subject_public_key(key)
      if ((key).nil?)
        @subject_public_key = nil
        @subject_public_key_bytes = nil
      else
        @subject_public_key = key
        @subject_public_key_bytes = key.get_encoded
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the subjectPublicKey criterion. The <code>X509Certificate</code>
    # must contain the specified subject public key. If <code>null</code>,
    # no subjectPublicKey check will be done.
    # <p>
    # Because this method allows the public key to be specified as a byte
    # array, it may be used for unknown key types.
    # <p>
    # If <code>key</code> is not <code>null</code>, it should contain a
    # single DER encoded SubjectPublicKeyInfo structure, as defined in X.509.
    # The ASN.1 notation for this structure is as follows.
    # <pre><code>
    # SubjectPublicKeyInfo  ::=  SEQUENCE  {
    #   algorithm            AlgorithmIdentifier,
    #   subjectPublicKey     BIT STRING  }
    # 
    # AlgorithmIdentifier  ::=  SEQUENCE  {
    #   algorithm               OBJECT IDENTIFIER,
    #   parameters              ANY DEFINED BY algorithm OPTIONAL  }
    #                              -- contains a value of the type
    #                              -- registered for use with the
    #                              -- algorithm object identifier value
    # </code></pre>
    # <p>
    # Note that the byte array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param key a byte array containing the subject public key in ASN.1 DER
    #            form (or <code>null</code>)
    # @throws IOException if an encoding error occurs (incorrect form for
    # subject public key)
    # @see #getSubjectPublicKey
    def set_subject_public_key(key)
      if ((key).nil?)
        @subject_public_key = nil
        @subject_public_key_bytes = nil
      else
        @subject_public_key_bytes = key.clone
        @subject_public_key = X509Key.parse(DerValue.new(@subject_public_key_bytes))
      end
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    # Sets the keyUsage criterion. The <code>X509Certificate</code>
    # must allow the specified keyUsage values. If <code>null</code>, no
    # keyUsage check will be done. Note that an <code>X509Certificate</code>
    # that has no keyUsage extension implicitly allows all keyUsage values.
    # <p>
    # Note that the boolean array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param keyUsage a boolean array in the same format as the boolean
    #                 array returned by
    # {@link X509Certificate#getKeyUsage() X509Certificate.getKeyUsage()}.
    #                 Or <code>null</code>.
    # @see #getKeyUsage
    def set_key_usage(key_usage)
      if ((key_usage).nil?)
        @key_usage = nil
      else
        @key_usage = key_usage.clone
      end
    end
    
    typesig { [JavaSet] }
    # Sets the extendedKeyUsage criterion. The <code>X509Certificate</code>
    # must allow the specified key purposes in its extended key usage
    # extension. If <code>keyPurposeSet</code> is empty or <code>null</code>,
    # no extendedKeyUsage check will be done. Note that an
    # <code>X509Certificate</code> that has no extendedKeyUsage extension
    # implicitly allows all key purposes.
    # <p>
    # Note that the <code>Set</code> is cloned to protect against
    # subsequent modifications.
    # 
    # @param keyPurposeSet a <code>Set</code> of key purpose OIDs in string
    # format (or <code>null</code>). Each OID is represented by a set of
    # nonnegative integers separated by periods.
    # @throws IOException if the OID is invalid, such as
    # the first component being not 0, 1 or 2 or the second component
    # being greater than 39.
    # @see #getExtendedKeyUsage
    def set_extended_key_usage(key_purpose_set)
      if (((key_purpose_set).nil?) || key_purpose_set.is_empty)
        @key_purpose_set = nil
        @key_purpose_oidset = nil
      else
        @key_purpose_set = Collections.unmodifiable_set(HashSet.new(key_purpose_set))
        @key_purpose_oidset = HashSet.new
        @key_purpose_set.each do |s|
          @key_purpose_oidset.add(ObjectIdentifier.new(s))
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Enables/disables matching all of the subjectAlternativeNames
    # specified in the {@link #setSubjectAlternativeNames
    # setSubjectAlternativeNames} or {@link #addSubjectAlternativeName
    # addSubjectAlternativeName} methods. If enabled,
    # the <code>X509Certificate</code> must contain all of the
    # specified subject alternative names. If disabled, the
    # <code>X509Certificate</code> must contain at least one of the
    # specified subject alternative names.
    # 
    # <p>The matchAllNames flag is <code>true</code> by default.
    # 
    # @param matchAllNames if <code>true</code>, the flag is enabled;
    # if <code>false</code>, the flag is disabled.
    # @see #getMatchAllSubjectAltNames
    def set_match_all_subject_alt_names(match_all_names)
      @match_all_subject_alt_names = match_all_names
    end
    
    typesig { [Collection] }
    # Sets the subjectAlternativeNames criterion. The
    # <code>X509Certificate</code> must contain all or at least one of the
    # specified subjectAlternativeNames, depending on the value of
    # the matchAllNames flag (see {@link #setMatchAllSubjectAltNames
    # setMatchAllSubjectAltNames}).
    # <p>
    # This method allows the caller to specify, with a single method call,
    # the complete set of subject alternative names for the
    # subjectAlternativeNames criterion. The specified value replaces
    # the previous value for the subjectAlternativeNames criterion.
    # <p>
    # The <code>names</code> parameter (if not <code>null</code>) is a
    # <code>Collection</code> with one
    # entry for each name to be included in the subject alternative name
    # criterion. Each entry is a <code>List</code> whose first entry is an
    # <code>Integer</code> (the name type, 0-8) and whose second
    # entry is a <code>String</code> or a byte array (the name, in
    # string or ASN.1 DER encoded form, respectively).
    # There can be multiple names of the same type. If <code>null</code>
    # is supplied as the value for this argument, no
    # subjectAlternativeNames check will be performed.
    # <p>
    # Each subject alternative name in the <code>Collection</code>
    # may be specified either as a <code>String</code> or as an ASN.1 encoded
    # byte array. For more details about the formats used, see
    # {@link #addSubjectAlternativeName(int type, String name)
    # addSubjectAlternativeName(int type, String name)} and
    # {@link #addSubjectAlternativeName(int type, byte [] name)
    # addSubjectAlternativeName(int type, byte [] name)}.
    # <p>
    # <strong>Note:</strong> for distinguished names, specify the byte
    # array form instead of the String form. See the note in
    # {@link #addSubjectAlternativeName(int, String)} for more information.
    # <p>
    # Note that the <code>names</code> parameter can contain duplicate
    # names (same name and name type), but they may be removed from the
    # <code>Collection</code> of names returned by the
    # {@link #getSubjectAlternativeNames getSubjectAlternativeNames} method.
    # <p>
    # Note that a deep copy is performed on the <code>Collection</code> to
    # protect against subsequent modifications.
    # 
    # @param names a <code>Collection</code> of names (or <code>null</code>)
    # @throws IOException if a parsing error occurs
    # @see #getSubjectAlternativeNames
    def set_subject_alternative_names(names)
      if ((names).nil?)
        @subject_alternative_names = nil
        @subject_alternative_general_names = nil
      else
        if (names.is_empty)
          @subject_alternative_names = nil
          @subject_alternative_general_names = nil
          return
        end
        temp_names = clone_and_check_names(names)
        # Ensure that we either set both of these or neither
        @subject_alternative_general_names = parse_names(temp_names)
        @subject_alternative_names = temp_names
      end
    end
    
    typesig { [::Java::Int, String] }
    # Adds a name to the subjectAlternativeNames criterion. The
    # <code>X509Certificate</code> must contain all or at least one
    # of the specified subjectAlternativeNames, depending on the value of
    # the matchAllNames flag (see {@link #setMatchAllSubjectAltNames
    # setMatchAllSubjectAltNames}).
    # <p>
    # This method allows the caller to add a name to the set of subject
    # alternative names.
    # The specified name is added to any previous value for the
    # subjectAlternativeNames criterion. If the specified name is a
    # duplicate, it may be ignored.
    # <p>
    # The name is provided in string format.
    # <a href="http://www.ietf.org/rfc/rfc822.txt">RFC 822</a>, DNS, and URI
    # names use the well-established string formats for those types (subject to
    # the restrictions included in RFC 3280). IPv4 address names are
    # supplied using dotted quad notation. OID address names are represented
    # as a series of nonnegative integers separated by periods. And
    # directory names (distinguished names) are supplied in RFC 2253 format.
    # No standard string format is defined for otherNames, X.400 names,
    # EDI party names, IPv6 address names, or any other type of names. They
    # should be specified using the
    # {@link #addSubjectAlternativeName(int type, byte [] name)
    # addSubjectAlternativeName(int type, byte [] name)}
    # method.
    # <p>
    # <strong>Note:</strong> for distinguished names, use
    # {@linkplain #addSubjectAlternativeName(int, byte[])} instead.
    # This method should not be relied on as it can fail to match some
    # certificates because of a loss of encoding information in the RFC 2253
    # String form of some distinguished names.
    # 
    # @param type the name type (0-8, as specified in
    #             RFC 3280, section 4.2.1.7)
    # @param name the name in string form (not <code>null</code>)
    # @throws IOException if a parsing error occurs
    def add_subject_alternative_name(type, name)
      add_subject_alternative_name_internal(type, name)
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Adds a name to the subjectAlternativeNames criterion. The
    # <code>X509Certificate</code> must contain all or at least one
    # of the specified subjectAlternativeNames, depending on the value of
    # the matchAllNames flag (see {@link #setMatchAllSubjectAltNames
    # setMatchAllSubjectAltNames}).
    # <p>
    # This method allows the caller to add a name to the set of subject
    # alternative names.
    # The specified name is added to any previous value for the
    # subjectAlternativeNames criterion. If the specified name is a
    # duplicate, it may be ignored.
    # <p>
    # The name is provided as a byte array. This byte array should contain
    # the DER encoded name, as it would appear in the GeneralName structure
    # defined in RFC 3280 and X.509. The encoded byte array should only contain
    # the encoded value of the name, and should not include the tag associated
    # with the name in the GeneralName structure. The ASN.1 definition of this
    # structure appears below.
    # <pre><code>
    #  GeneralName ::= CHOICE {
    #       otherName                       [0]     OtherName,
    #       rfc822Name                      [1]     IA5String,
    #       dNSName                         [2]     IA5String,
    #       x400Address                     [3]     ORAddress,
    #       directoryName                   [4]     Name,
    #       ediPartyName                    [5]     EDIPartyName,
    #       uniformResourceIdentifier       [6]     IA5String,
    #       iPAddress                       [7]     OCTET STRING,
    #       registeredID                    [8]     OBJECT IDENTIFIER}
    # </code></pre>
    # <p>
    # Note that the byte array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param type the name type (0-8, as listed above)
    # @param name a byte array containing the name in ASN.1 DER encoded form
    # @throws IOException if a parsing error occurs
    def add_subject_alternative_name(type, name)
      # clone because byte arrays are modifiable
      add_subject_alternative_name_internal(type, name.clone)
    end
    
    typesig { [::Java::Int, Object] }
    # A private method that adds a name (String or byte array) to the
    # subjectAlternativeNames criterion. The <code>X509Certificate</code>
    # must contain the specified subjectAlternativeName.
    # 
    # @param type the name type (0-8, as specified in
    #             RFC 3280, section 4.2.1.7)
    # @param name the name in string or byte array form
    # @throws IOException if a parsing error occurs
    def add_subject_alternative_name_internal(type, name)
      # First, ensure that the name parses
      temp_name = make_general_name_interface(type, name)
      if ((@subject_alternative_names).nil?)
        @subject_alternative_names = HashSet.new
      end
      if ((@subject_alternative_general_names).nil?)
        @subject_alternative_general_names = HashSet.new
      end
      list = ArrayList.new(2)
      list.add(JavaInteger.value_of(type))
      list.add(name)
      @subject_alternative_names.add(list)
      @subject_alternative_general_names.add(temp_name)
    end
    
    class_module.module_eval {
      typesig { [Collection] }
      # Parse an argument of the form passed to setSubjectAlternativeNames,
      # returning a <code>Collection</code> of
      # <code>GeneralNameInterface</code>s.
      # Throw an IllegalArgumentException or a ClassCastException
      # if the argument is malformed.
      # 
      # @param names a Collection with one entry per name.
      #              Each entry is a <code>List</code> whose first entry
      #              is an Integer (the name type, 0-8) and whose second
      #              entry is a String or a byte array (the name, in
      #              string or ASN.1 DER encoded form, respectively).
      #              There can be multiple names of the same type. Null is
      #              not an acceptable value.
      # @return a Set of <code>GeneralNameInterface</code>s
      # @throws IOException if a parsing error occurs
      def parse_names(names)
        gen_names = HashSet.new
        names.each do |nameList|
          if (!(name_list.size).equal?(2))
            raise IOException.new("name list size not 2")
          end
          o = name_list.get(0)
          if (!(o.is_a?(JavaInteger)))
            raise IOException.new("expected an Integer")
          end
          name_type = (o).int_value
          o = name_list.get(1)
          gen_names.add(make_general_name_interface(name_type, o))
        end
        return gen_names
      end
      
      typesig { [Collection, Collection] }
      # Compare for equality two objects of the form passed to
      # setSubjectAlternativeNames (or X509CRLSelector.setIssuerNames).
      # Throw an <code>IllegalArgumentException</code> or a
      # <code>ClassCastException</code> if one of the objects is malformed.
      # 
      # @param object1 a Collection containing the first object to compare
      # @param object2 a Collection containing the second object to compare
      # @return true if the objects are equal, false otherwise
      def equal_names(object1, object2)
        if (((object1).nil?) || ((object2).nil?))
          return (object1).equal?(object2)
        end
        return (object1 == object2)
      end
      
      typesig { [::Java::Int, Object] }
      # Make a <code>GeneralNameInterface</code> out of a name type (0-8) and an
      # Object that may be a byte array holding the ASN.1 DER encoded
      # name or a String form of the name.  Except for X.509
      # Distinguished Names, the String form of the name must not be the
      # result from calling toString on an existing GeneralNameInterface
      # implementing class.  The output of toString is not compatible
      # with the String constructors for names other than Distinguished
      # Names.
      # 
      # @param type name type (0-8)
      # @param name name as ASN.1 Der-encoded byte array or String
      # @return a GeneralNameInterface name
      # @throws IOException if a parsing error occurs
      def make_general_name_interface(type, name)
        result = nil
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.makeGeneralNameInterface(" + RJava.cast_to_string(type) + ")...")
        end
        if (name.is_a?(String))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.makeGeneralNameInterface() " + "name is String: " + RJava.cast_to_string(name))
          end
          case (type)
          when NAME_RFC822
            result = RFC822Name.new(name)
          when NAME_DNS
            result = DNSName.new(name)
          when NAME_DIRECTORY
            result = X500Name.new(name)
          when NAME_URI
            result = URIName.new(name)
          when NAME_IP
            result = IPAddressName.new(name)
          when NAME_OID
            result = OIDName.new(name)
          else
            raise IOException.new("unable to parse String names of type " + RJava.cast_to_string(type))
          end
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.makeGeneralNameInterface() " + "result: " + RJava.cast_to_string(result.to_s))
          end
        else
          if (name.is_a?(Array.typed(::Java::Byte)))
            val = DerValue.new(name)
            if (!(Debug).nil?)
              Debug.println("X509CertSelector.makeGeneralNameInterface() is byte[]")
            end
            case (type)
            when NAME_ANY
              result = OtherName.new(val)
            when NAME_RFC822
              result = RFC822Name.new(val)
            when NAME_DNS
              result = DNSName.new(val)
            when NAME_X400
              result = X400Address.new(val)
            when NAME_DIRECTORY
              result = X500Name.new(val)
            when NAME_EDI
              result = EDIPartyName.new(val)
            when NAME_URI
              result = URIName.new(val)
            when NAME_IP
              result = IPAddressName.new(val)
            when NAME_OID
              result = OIDName.new(val)
            else
              raise IOException.new("unable to parse byte array names of " + "type " + RJava.cast_to_string(type))
            end
            if (!(Debug).nil?)
              Debug.println("X509CertSelector.makeGeneralNameInterface() result: " + RJava.cast_to_string(result.to_s))
            end
          else
            if (!(Debug).nil?)
              Debug.println("X509CertSelector.makeGeneralName() input name " + "not String or byte array")
            end
            raise IOException.new("name not String or byte array")
          end
        end
        return result
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the name constraints criterion. The <code>X509Certificate</code>
    # must have subject and subject alternative names that
    # meet the specified name constraints.
    # <p>
    # The name constraints are specified as a byte array. This byte array
    # should contain the DER encoded form of the name constraints, as they
    # would appear in the NameConstraints structure defined in RFC 3280
    # and X.509. The ASN.1 definition of this structure appears below.
    # 
    # <pre><code>
    #  NameConstraints ::= SEQUENCE {
    #       permittedSubtrees       [0]     GeneralSubtrees OPTIONAL,
    #       excludedSubtrees        [1]     GeneralSubtrees OPTIONAL }
    # 
    #  GeneralSubtrees ::= SEQUENCE SIZE (1..MAX) OF GeneralSubtree
    # 
    #  GeneralSubtree ::= SEQUENCE {
    #       base                    GeneralName,
    #       minimum         [0]     BaseDistance DEFAULT 0,
    #       maximum         [1]     BaseDistance OPTIONAL }
    # 
    #  BaseDistance ::= INTEGER (0..MAX)
    # 
    #  GeneralName ::= CHOICE {
    #       otherName                       [0]     OtherName,
    #       rfc822Name                      [1]     IA5String,
    #       dNSName                         [2]     IA5String,
    #       x400Address                     [3]     ORAddress,
    #       directoryName                   [4]     Name,
    #       ediPartyName                    [5]     EDIPartyName,
    #       uniformResourceIdentifier       [6]     IA5String,
    #       iPAddress                       [7]     OCTET STRING,
    #       registeredID                    [8]     OBJECT IDENTIFIER}
    # </code></pre>
    # <p>
    # Note that the byte array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param bytes a byte array containing the ASN.1 DER encoding of
    #              a NameConstraints extension to be used for checking
    #              name constraints. Only the value of the extension is
    #              included, not the OID or criticality flag. Can be
    #              <code>null</code>,
    #              in which case no name constraints check will be performed.
    # @throws IOException if a parsing error occurs
    # @see #getNameConstraints
    def set_name_constraints(bytes)
      if ((bytes).nil?)
        @nc_bytes = nil
        @nc = nil
      else
        @nc_bytes = bytes.clone
        @nc = NameConstraintsExtension.new(FALSE, bytes)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the basic constraints constraint. If the value is greater than or
    # equal to zero, <code>X509Certificates</code> must include a
    # basicConstraints extension with
    # a pathLen of at least this value. If the value is -2, only end-entity
    # certificates are accepted. If the value is -1, no check is done.
    # <p>
    # This constraint is useful when building a certification path forward
    # (from the target toward the trust anchor. If a partial path has been
    # built, any candidate certificate must have a maxPathLen value greater
    # than or equal to the number of certificates in the partial path.
    # 
    # @param minMaxPathLen the value for the basic constraints constraint
    # @throws IllegalArgumentException if the value is less than -2
    # @see #getBasicConstraints
    def set_basic_constraints(min_max_path_len)
      if (min_max_path_len < -2)
        raise IllegalArgumentException.new("basic constraints less than -2")
      end
      @basic_constraints = min_max_path_len
    end
    
    typesig { [JavaSet] }
    # Sets the policy constraint. The <code>X509Certificate</code> must
    # include at least one of the specified policies in its certificate
    # policies extension. If <code>certPolicySet</code> is empty, then the
    # <code>X509Certificate</code> must include at least some specified policy
    # in its certificate policies extension. If <code>certPolicySet</code> is
    # <code>null</code>, no policy check will be performed.
    # <p>
    # Note that the <code>Set</code> is cloned to protect against
    # subsequent modifications.
    # 
    # @param certPolicySet a <code>Set</code> of certificate policy OIDs in
    #                      string format (or <code>null</code>). Each OID is
    #                      represented by a set of nonnegative integers
    #                    separated by periods.
    # @throws IOException if a parsing error occurs on the OID such as
    # the first component is not 0, 1 or 2 or the second component is
    # greater than 39.
    # @see #getPolicy
    def set_policy(cert_policy_set)
      if ((cert_policy_set).nil?)
        @policy_set = nil
        @policy = nil
      else
        # Snapshot set and parse it
        temp_set = Collections.unmodifiable_set(HashSet.new(cert_policy_set))
        # Convert to Vector of ObjectIdentifiers
        i = temp_set.iterator
        pol_id_vector = Vector.new
        while (i.has_next)
          o = i.next_
          if (!(o.is_a?(String)))
            raise IOException.new("non String in certPolicySet")
          end
          pol_id_vector.add(CertificatePolicyId.new(ObjectIdentifier.new(o)))
        end
        # If everything went OK, make the changes
        @policy_set = temp_set
        @policy = CertificatePolicySet.new(pol_id_vector)
      end
    end
    
    typesig { [Collection] }
    # Sets the pathToNames criterion. The <code>X509Certificate</code> must
    # not include name constraints that would prohibit building a
    # path to the specified names.
    # <p>
    # This method allows the caller to specify, with a single method call,
    # the complete set of names which the <code>X509Certificates</code>'s
    # name constraints must permit. The specified value replaces
    # the previous value for the pathToNames criterion.
    # <p>
    # This constraint is useful when building a certification path forward
    # (from the target toward the trust anchor. If a partial path has been
    # built, any candidate certificate must not include name constraints that
    # would prohibit building a path to any of the names in the partial path.
    # <p>
    # The <code>names</code> parameter (if not <code>null</code>) is a
    # <code>Collection</code> with one
    # entry for each name to be included in the pathToNames
    # criterion. Each entry is a <code>List</code> whose first entry is an
    # <code>Integer</code> (the name type, 0-8) and whose second
    # entry is a <code>String</code> or a byte array (the name, in
    # string or ASN.1 DER encoded form, respectively).
    # There can be multiple names of the same type. If <code>null</code>
    # is supplied as the value for this argument, no
    # pathToNames check will be performed.
    # <p>
    # Each name in the <code>Collection</code>
    # may be specified either as a <code>String</code> or as an ASN.1 encoded
    # byte array. For more details about the formats used, see
    # {@link #addPathToName(int type, String name)
    # addPathToName(int type, String name)} and
    # {@link #addPathToName(int type, byte [] name)
    # addPathToName(int type, byte [] name)}.
    # <p>
    # <strong>Note:</strong> for distinguished names, specify the byte
    # array form instead of the String form. See the note in
    # {@link #addPathToName(int, String)} for more information.
    # <p>
    # Note that the <code>names</code> parameter can contain duplicate
    # names (same name and name type), but they may be removed from the
    # <code>Collection</code> of names returned by the
    # {@link #getPathToNames getPathToNames} method.
    # <p>
    # Note that a deep copy is performed on the <code>Collection</code> to
    # protect against subsequent modifications.
    # 
    # @param names a <code>Collection</code> with one entry per name
    #              (or <code>null</code>)
    # @throws IOException if a parsing error occurs
    # @see #getPathToNames
    def set_path_to_names(names)
      if (((names).nil?) || names.is_empty)
        @path_to_names = nil
        @path_to_general_names = nil
      else
        temp_names = clone_and_check_names(names)
        @path_to_general_names = parse_names(temp_names)
        # Ensure that we either set both of these or neither
        @path_to_names = temp_names
      end
    end
    
    typesig { [JavaSet] }
    # called from CertPathHelper
    def set_path_to_names_internal(names)
      # set names to non-null dummy value
      # this breaks getPathToNames()
      @path_to_names = Collections.empty_set
      @path_to_general_names = names
    end
    
    typesig { [::Java::Int, String] }
    # Adds a name to the pathToNames criterion. The <code>X509Certificate</code>
    # must not include name constraints that would prohibit building a
    # path to the specified name.
    # <p>
    # This method allows the caller to add a name to the set of names which
    # the <code>X509Certificates</code>'s name constraints must permit.
    # The specified name is added to any previous value for the
    # pathToNames criterion.  If the name is a duplicate, it may be ignored.
    # <p>
    # The name is provided in string format. RFC 822, DNS, and URI names
    # use the well-established string formats for those types (subject to
    # the restrictions included in RFC 3280). IPv4 address names are
    # supplied using dotted quad notation. OID address names are represented
    # as a series of nonnegative integers separated by periods. And
    # directory names (distinguished names) are supplied in RFC 2253 format.
    # No standard string format is defined for otherNames, X.400 names,
    # EDI party names, IPv6 address names, or any other type of names. They
    # should be specified using the
    # {@link #addPathToName(int type, byte [] name)
    # addPathToName(int type, byte [] name)} method.
    # <p>
    # <strong>Note:</strong> for distinguished names, use
    # {@linkplain #addPathToName(int, byte[])} instead.
    # This method should not be relied on as it can fail to match some
    # certificates because of a loss of encoding information in the RFC 2253
    # String form of some distinguished names.
    # 
    # @param type the name type (0-8, as specified in
    #             RFC 3280, section 4.2.1.7)
    # @param name the name in string form
    # @throws IOException if a parsing error occurs
    def add_path_to_name(type, name)
      add_path_to_name_internal(type, name)
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Adds a name to the pathToNames criterion. The <code>X509Certificate</code>
    # must not include name constraints that would prohibit building a
    # path to the specified name.
    # <p>
    # This method allows the caller to add a name to the set of names which
    # the <code>X509Certificates</code>'s name constraints must permit.
    # The specified name is added to any previous value for the
    # pathToNames criterion. If the name is a duplicate, it may be ignored.
    # <p>
    # The name is provided as a byte array. This byte array should contain
    # the DER encoded name, as it would appear in the GeneralName structure
    # defined in RFC 3280 and X.509. The ASN.1 definition of this structure
    # appears in the documentation for
    # {@link #addSubjectAlternativeName(int type, byte [] name)
    # addSubjectAlternativeName(int type, byte [] name)}.
    # <p>
    # Note that the byte array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param type the name type (0-8, as specified in
    #             RFC 3280, section 4.2.1.7)
    # @param name a byte array containing the name in ASN.1 DER encoded form
    # @throws IOException if a parsing error occurs
    def add_path_to_name(type, name)
      # clone because byte arrays are modifiable
      add_path_to_name_internal(type, name.clone)
    end
    
    typesig { [::Java::Int, Object] }
    # A private method that adds a name (String or byte array) to the
    # pathToNames criterion. The <code>X509Certificate</code> must contain
    # the specified pathToName.
    # 
    # @param type the name type (0-8, as specified in
    #             RFC 3280, section 4.2.1.7)
    # @param name the name in string or byte array form
    # @throws IOException if an encoding error occurs (incorrect form for DN)
    def add_path_to_name_internal(type, name)
      # First, ensure that the name parses
      temp_name = make_general_name_interface(type, name)
      if ((@path_to_general_names).nil?)
        @path_to_names = HashSet.new
        @path_to_general_names = HashSet.new
      end
      list = ArrayList.new(2)
      list.add(JavaInteger.value_of(type))
      list.add(name)
      @path_to_names.add(list)
      @path_to_general_names.add(temp_name)
    end
    
    typesig { [] }
    # Returns the certificateEquals criterion. The specified
    # <code>X509Certificate</code> must be equal to the
    # <code>X509Certificate</code> passed to the <code>match</code> method.
    # If <code>null</code>, this check is not applied.
    # 
    # @return the <code>X509Certificate</code> to match (or <code>null</code>)
    # @see #setCertificate
    def get_certificate
      return @x509cert
    end
    
    typesig { [] }
    # Returns the serialNumber criterion. The specified serial number
    # must match the certificate serial number in the
    # <code>X509Certificate</code>. If <code>null</code>, any certificate
    # serial number will do.
    # 
    # @return the certificate serial number to match
    #                (or <code>null</code>)
    # @see #setSerialNumber
    def get_serial_number
      return @serial_number
    end
    
    typesig { [] }
    # Returns the issuer criterion as an <code>X500Principal</code>. This
    # distinguished name must match the issuer distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, the issuer criterion
    # is disabled and any issuer distinguished name will do.
    # 
    # @return the required issuer distinguished name as X500Principal
    #         (or <code>null</code>)
    # @since 1.5
    def get_issuer
      return @issuer
    end
    
    typesig { [] }
    # <strong>Denigrated</strong>, use {@linkplain #getIssuer()} or
    # {@linkplain #getIssuerAsBytes()} instead. This method should not be
    # relied on as it can fail to match some certificates because of a loss of
    # encoding information in the RFC 2253 String form of some distinguished
    # names.
    # <p>
    # Returns the issuer criterion as a <code>String</code>. This
    # distinguished name must match the issuer distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, the issuer criterion
    # is disabled and any issuer distinguished name will do.
    # <p>
    # If the value returned is not <code>null</code>, it is a
    # distinguished name, in RFC 2253 format.
    # 
    # @return the required issuer distinguished name in RFC 2253 format
    #         (or <code>null</code>)
    def get_issuer_as_string
      return ((@issuer).nil? ? nil : @issuer.get_name)
    end
    
    typesig { [] }
    # Returns the issuer criterion as a byte array. This distinguished name
    # must match the issuer distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, the issuer criterion
    # is disabled and any issuer distinguished name will do.
    # <p>
    # If the value returned is not <code>null</code>, it is a byte
    # array containing a single DER encoded distinguished name, as defined in
    # X.501. The ASN.1 notation for this structure is supplied in the
    # documentation for
    # {@link #setIssuer(byte [] issuerDN) setIssuer(byte [] issuerDN)}.
    # <p>
    # Note that the byte array returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return a byte array containing the required issuer distinguished name
    #         in ASN.1 DER format (or <code>null</code>)
    # @throws IOException if an encoding error occurs
    def get_issuer_as_bytes
      return ((@issuer).nil? ? nil : @issuer.get_encoded)
    end
    
    typesig { [] }
    # Returns the subject criterion as an <code>X500Principal</code>. This
    # distinguished name must match the subject distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, the subject criterion
    # is disabled and any subject distinguished name will do.
    # 
    # @return the required subject distinguished name as X500Principal
    #         (or <code>null</code>)
    # @since 1.5
    def get_subject
      return @subject
    end
    
    typesig { [] }
    # <strong>Denigrated</strong>, use {@linkplain #getSubject()} or
    # {@linkplain #getSubjectAsBytes()} instead. This method should not be
    # relied on as it can fail to match some certificates because of a loss of
    # encoding information in the RFC 2253 String form of some distinguished
    # names.
    # <p>
    # Returns the subject criterion as a <code>String</code>. This
    # distinguished name must match the subject distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, the subject criterion
    # is disabled and any subject distinguished name will do.
    # <p>
    # If the value returned is not <code>null</code>, it is a
    # distinguished name, in RFC 2253 format.
    # 
    # @return the required subject distinguished name in RFC 2253 format
    #         (or <code>null</code>)
    def get_subject_as_string
      return ((@subject).nil? ? nil : @subject.get_name)
    end
    
    typesig { [] }
    # Returns the subject criterion as a byte array. This distinguished name
    # must match the subject distinguished name in the
    # <code>X509Certificate</code>. If <code>null</code>, the subject criterion
    # is disabled and any subject distinguished name will do.
    # <p>
    # If the value returned is not <code>null</code>, it is a byte
    # array containing a single DER encoded distinguished name, as defined in
    # X.501. The ASN.1 notation for this structure is supplied in the
    # documentation for
    # {@link #setSubject(byte [] subjectDN) setSubject(byte [] subjectDN)}.
    # <p>
    # Note that the byte array returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return a byte array containing the required subject distinguished name
    #         in ASN.1 DER format (or <code>null</code>)
    # @throws IOException if an encoding error occurs
    def get_subject_as_bytes
      return ((@subject).nil? ? nil : @subject.get_encoded)
    end
    
    typesig { [] }
    # Returns the subjectKeyIdentifier criterion. The
    # <code>X509Certificate</code> must contain a SubjectKeyIdentifier
    # extension with the specified value. If <code>null</code>, no
    # subjectKeyIdentifier check will be done.
    # <p>
    # Note that the byte array returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return the key identifier (or <code>null</code>)
    # @see #setSubjectKeyIdentifier
    def get_subject_key_identifier
      if ((@subject_key_id).nil?)
        return nil
      end
      return @subject_key_id.clone
    end
    
    typesig { [] }
    # Returns the authorityKeyIdentifier criterion. The
    # <code>X509Certificate</code> must contain a AuthorityKeyIdentifier
    # extension with the specified value. If <code>null</code>, no
    # authorityKeyIdentifier check will be done.
    # <p>
    # Note that the byte array returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return the key identifier (or <code>null</code>)
    # @see #setAuthorityKeyIdentifier
    def get_authority_key_identifier
      if ((@authority_key_id).nil?)
        return nil
      end
      return @authority_key_id.clone
    end
    
    typesig { [] }
    # Returns the certificateValid criterion. The specified date must fall
    # within the certificate validity period for the
    # <code>X509Certificate</code>. If <code>null</code>, no certificateValid
    # check will be done.
    # <p>
    # Note that the <code>Date</code> returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return the <code>Date</code> to check (or <code>null</code>)
    # @see #setCertificateValid
    def get_certificate_valid
      if ((@certificate_valid).nil?)
        return nil
      end
      return @certificate_valid.clone
    end
    
    typesig { [] }
    # Returns the privateKeyValid criterion. The specified date must fall
    # within the private key validity period for the
    # <code>X509Certificate</code>. If <code>null</code>, no privateKeyValid
    # check will be done.
    # <p>
    # Note that the <code>Date</code> returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return the <code>Date</code> to check (or <code>null</code>)
    # @see #setPrivateKeyValid
    def get_private_key_valid
      if ((@private_key_valid).nil?)
        return nil
      end
      return @private_key_valid.clone
    end
    
    typesig { [] }
    # Returns the subjectPublicKeyAlgID criterion. The
    # <code>X509Certificate</code> must contain a subject public key
    # with the specified algorithm. If <code>null</code>, no
    # subjectPublicKeyAlgID check will be done.
    # 
    # @return the object identifier (OID) of the signature algorithm to check
    #         for (or <code>null</code>). An OID is represented by a set of
    #         nonnegative integers separated by periods.
    # @see #setSubjectPublicKeyAlgID
    def get_subject_public_key_alg_id
      if ((@subject_public_key_alg_id).nil?)
        return nil
      end
      return @subject_public_key_alg_id.to_s
    end
    
    typesig { [] }
    # Returns the subjectPublicKey criterion. The
    # <code>X509Certificate</code> must contain the specified subject
    # public key. If <code>null</code>, no subjectPublicKey check will be done.
    # 
    # @return the subject public key to check for (or <code>null</code>)
    # @see #setSubjectPublicKey
    def get_subject_public_key
      return @subject_public_key
    end
    
    typesig { [] }
    # Returns the keyUsage criterion. The <code>X509Certificate</code>
    # must allow the specified keyUsage values. If null, no keyUsage
    # check will be done.
    # <p>
    # Note that the boolean array returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return a boolean array in the same format as the boolean
    #                 array returned by
    # {@link X509Certificate#getKeyUsage() X509Certificate.getKeyUsage()}.
    #                 Or <code>null</code>.
    # @see #setKeyUsage
    def get_key_usage
      if ((@key_usage).nil?)
        return nil
      end
      return @key_usage.clone
    end
    
    typesig { [] }
    # Returns the extendedKeyUsage criterion. The <code>X509Certificate</code>
    # must allow the specified key purposes in its extended key usage
    # extension. If the <code>keyPurposeSet</code> returned is empty or
    # <code>null</code>, no extendedKeyUsage check will be done. Note that an
    # <code>X509Certificate</code> that has no extendedKeyUsage extension
    # implicitly allows all key purposes.
    # 
    # @return an immutable <code>Set</code> of key purpose OIDs in string
    # format (or <code>null</code>)
    # @see #setExtendedKeyUsage
    def get_extended_key_usage
      return @key_purpose_set
    end
    
    typesig { [] }
    # Indicates if the <code>X509Certificate</code> must contain all
    # or at least one of the subjectAlternativeNames
    # specified in the {@link #setSubjectAlternativeNames
    # setSubjectAlternativeNames} or {@link #addSubjectAlternativeName
    # addSubjectAlternativeName} methods. If <code>true</code>,
    # the <code>X509Certificate</code> must contain all of the
    # specified subject alternative names. If <code>false</code>, the
    # <code>X509Certificate</code> must contain at least one of the
    # specified subject alternative names.
    # 
    # @return <code>true</code> if the flag is enabled;
    # <code>false</code> if the flag is disabled. The flag is
    # <code>true</code> by default.
    # @see #setMatchAllSubjectAltNames
    def get_match_all_subject_alt_names
      return @match_all_subject_alt_names
    end
    
    typesig { [] }
    # Returns a copy of the subjectAlternativeNames criterion.
    # The <code>X509Certificate</code> must contain all or at least one
    # of the specified subjectAlternativeNames, depending on the value
    # of the matchAllNames flag (see {@link #getMatchAllSubjectAltNames
    # getMatchAllSubjectAltNames}). If the value returned is
    # <code>null</code>, no subjectAlternativeNames check will be performed.
    # <p>
    # If the value returned is not <code>null</code>, it is a
    # <code>Collection</code> with
    # one entry for each name to be included in the subject alternative name
    # criterion. Each entry is a <code>List</code> whose first entry is an
    # <code>Integer</code> (the name type, 0-8) and whose second
    # entry is a <code>String</code> or a byte array (the name, in
    # string or ASN.1 DER encoded form, respectively).
    # There can be multiple names of the same type.  Note that the
    # <code>Collection</code> returned may contain duplicate names (same name
    # and name type).
    # <p>
    # Each subject alternative name in the <code>Collection</code>
    # may be specified either as a <code>String</code> or as an ASN.1 encoded
    # byte array. For more details about the formats used, see
    # {@link #addSubjectAlternativeName(int type, String name)
    # addSubjectAlternativeName(int type, String name)} and
    # {@link #addSubjectAlternativeName(int type, byte [] name)
    # addSubjectAlternativeName(int type, byte [] name)}.
    # <p>
    # Note that a deep copy is performed on the <code>Collection</code> to
    # protect against subsequent modifications.
    # 
    # @return a <code>Collection</code> of names (or <code>null</code>)
    # @see #setSubjectAlternativeNames
    def get_subject_alternative_names
      if ((@subject_alternative_names).nil?)
        return nil
      end
      return clone_names(@subject_alternative_names)
    end
    
    class_module.module_eval {
      typesig { [Collection] }
      # Clone an object of the form passed to
      # setSubjectAlternativeNames and setPathToNames.
      # Throw a <code>RuntimeException</code> if the argument is malformed.
      # <p>
      # This method wraps cloneAndCheckNames, changing any
      # <code>IOException</code> into a <code>RuntimeException</code>. This
      # method should be used when the object being
      # cloned has already been checked, so there should never be any exceptions.
      # 
      # @param names a <code>Collection</code> with one entry per name.
      #              Each entry is a <code>List</code> whose first entry
      #              is an Integer (the name type, 0-8) and whose second
      #              entry is a String or a byte array (the name, in
      #              string or ASN.1 DER encoded form, respectively).
      #              There can be multiple names of the same type. Null
      #              is not an acceptable value.
      # @return a deep copy of the specified <code>Collection</code>
      # @throws RuntimeException if a parsing error occurs
      def clone_names(names)
        begin
          return clone_and_check_names(names)
        rescue IOException => e
          raise RuntimeException.new("cloneNames encountered IOException: " + RJava.cast_to_string(e.get_message))
        end
      end
      
      typesig { [Collection] }
      # Clone and check an argument of the form passed to
      # setSubjectAlternativeNames and setPathToNames.
      # Throw an <code>IOException</code> if the argument is malformed.
      # 
      # @param names a <code>Collection</code> with one entry per name.
      #              Each entry is a <code>List</code> whose first entry
      #              is an Integer (the name type, 0-8) and whose second
      #              entry is a String or a byte array (the name, in
      #              string or ASN.1 DER encoded form, respectively).
      #              There can be multiple names of the same type.
      #              <code>null</code> is not an acceptable value.
      # @return a deep copy of the specified <code>Collection</code>
      # @throws IOException if a parsing error occurs
      def clone_and_check_names(names)
        # Copy the Lists and Collection
        names_copy = HashSet.new
        i = names.iterator
        while (i.has_next)
          o = i.next_
          if (!(o.is_a?(JavaList)))
            raise IOException.new("expected a List")
          end
          names_copy.add(ArrayList.new(o))
        end
        # Check the contents of the Lists and clone any byte arrays
        i = names_copy.iterator
        while (i.has_next)
          name_list = i.next_
          if (!(name_list.size).equal?(2))
            raise IOException.new("name list size not 2")
          end
          o = name_list.get(0)
          if (!(o.is_a?(JavaInteger)))
            raise IOException.new("expected an Integer")
          end
          name_type = (o).int_value
          if ((name_type < 0) || (name_type > 8))
            raise IOException.new("name type not 0-8")
          end
          name_object = name_list.get(1)
          if (!(name_object.is_a?(Array.typed(::Java::Byte))) && !(name_object.is_a?(String)))
            if (!(Debug).nil?)
              Debug.println("X509CertSelector.cloneAndCheckNames() " + "name not byte array")
            end
            raise IOException.new("name not byte array or String")
          end
          if (name_object.is_a?(Array.typed(::Java::Byte)))
            name_list.set(1, (name_object).clone)
          end
        end
        return names_copy
      end
    }
    
    typesig { [] }
    # Returns the name constraints criterion. The <code>X509Certificate</code>
    # must have subject and subject alternative names that
    # meet the specified name constraints.
    # <p>
    # The name constraints are returned as a byte array. This byte array
    # contains the DER encoded form of the name constraints, as they
    # would appear in the NameConstraints structure defined in RFC 3280
    # and X.509. The ASN.1 notation for this structure is supplied in the
    # documentation for
    # {@link #setNameConstraints(byte [] bytes) setNameConstraints(byte [] bytes)}.
    # <p>
    # Note that the byte array returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return a byte array containing the ASN.1 DER encoding of
    #         a NameConstraints extension used for checking name constraints.
    #         <code>null</code> if no name constraints check will be performed.
    # @see #setNameConstraints
    def get_name_constraints
      if ((@nc_bytes).nil?)
        return nil
      else
        return @nc_bytes.clone
      end
    end
    
    typesig { [] }
    # Returns the basic constraints constraint. If the value is greater than
    # or equal to zero, the <code>X509Certificates</code> must include a
    # basicConstraints extension with a pathLen of at least this value.
    # If the value is -2, only end-entity certificates are accepted. If
    # the value is -1, no basicConstraints check is done.
    # 
    # @return the value for the basic constraints constraint
    # @see #setBasicConstraints
    def get_basic_constraints
      return @basic_constraints
    end
    
    typesig { [] }
    # Returns the policy criterion. The <code>X509Certificate</code> must
    # include at least one of the specified policies in its certificate policies
    # extension. If the <code>Set</code> returned is empty, then the
    # <code>X509Certificate</code> must include at least some specified policy
    # in its certificate policies extension. If the <code>Set</code> returned is
    # <code>null</code>, no policy check will be performed.
    # 
    # @return an immutable <code>Set</code> of certificate policy OIDs in
    #         string format (or <code>null</code>)
    # @see #setPolicy
    def get_policy
      return @policy_set
    end
    
    typesig { [] }
    # Returns a copy of the pathToNames criterion. The
    # <code>X509Certificate</code> must not include name constraints that would
    # prohibit building a path to the specified names. If the value
    # returned is <code>null</code>, no pathToNames check will be performed.
    # <p>
    # If the value returned is not <code>null</code>, it is a
    # <code>Collection</code> with one
    # entry for each name to be included in the pathToNames
    # criterion. Each entry is a <code>List</code> whose first entry is an
    # <code>Integer</code> (the name type, 0-8) and whose second
    # entry is a <code>String</code> or a byte array (the name, in
    # string or ASN.1 DER encoded form, respectively).
    # There can be multiple names of the same type. Note that the
    # <code>Collection</code> returned may contain duplicate names (same
    # name and name type).
    # <p>
    # Each name in the <code>Collection</code>
    # may be specified either as a <code>String</code> or as an ASN.1 encoded
    # byte array. For more details about the formats used, see
    # {@link #addPathToName(int type, String name)
    # addPathToName(int type, String name)} and
    # {@link #addPathToName(int type, byte [] name)
    # addPathToName(int type, byte [] name)}.
    # <p>
    # Note that a deep copy is performed on the <code>Collection</code> to
    # protect against subsequent modifications.
    # 
    # @return a <code>Collection</code> of names (or <code>null</code>)
    # @see #setPathToNames
    def get_path_to_names
      if ((@path_to_names).nil?)
        return nil
      end
      return clone_names(@path_to_names)
    end
    
    typesig { [] }
    # Return a printable representation of the <code>CertSelector</code>.
    # 
    # @return a <code>String</code> describing the contents of the
    #         <code>CertSelector</code>
    def to_s
      sb = StringBuffer.new
      sb.append("X509CertSelector: [\n")
      if (!(@x509cert).nil?)
        sb.append("  Certificate: " + RJava.cast_to_string(@x509cert.to_s) + "\n")
      end
      if (!(@serial_number).nil?)
        sb.append("  Serial Number: " + RJava.cast_to_string(@serial_number.to_s) + "\n")
      end
      if (!(@issuer).nil?)
        sb.append("  Issuer: " + RJava.cast_to_string(get_issuer_as_string) + "\n")
      end
      if (!(@subject).nil?)
        sb.append("  Subject: " + RJava.cast_to_string(get_subject_as_string) + "\n")
      end
      sb.append("  matchAllSubjectAltNames flag: " + RJava.cast_to_string(String.value_of(@match_all_subject_alt_names)) + "\n")
      if (!(@subject_alternative_names).nil?)
        sb.append("  SubjectAlternativeNames:\n")
        i = @subject_alternative_names.iterator
        while (i.has_next)
          list = i.next_
          sb.append("    type " + RJava.cast_to_string(list.get(0)) + ", name " + RJava.cast_to_string(list.get(1)) + "\n")
        end
      end
      if (!(@subject_key_id).nil?)
        enc = HexDumpEncoder.new
        sb.append("  Subject Key Identifier: " + RJava.cast_to_string(enc.encode_buffer(@subject_key_id)) + "\n")
      end
      if (!(@authority_key_id).nil?)
        enc = HexDumpEncoder.new
        sb.append("  Authority Key Identifier: " + RJava.cast_to_string(enc.encode_buffer(@authority_key_id)) + "\n")
      end
      if (!(@certificate_valid).nil?)
        sb.append("  Certificate Valid: " + RJava.cast_to_string(@certificate_valid.to_s) + "\n")
      end
      if (!(@private_key_valid).nil?)
        sb.append("  Private Key Valid: " + RJava.cast_to_string(@private_key_valid.to_s) + "\n")
      end
      if (!(@subject_public_key_alg_id).nil?)
        sb.append("  Subject Public Key AlgID: " + RJava.cast_to_string(@subject_public_key_alg_id.to_s) + "\n")
      end
      if (!(@subject_public_key).nil?)
        sb.append("  Subject Public Key: " + RJava.cast_to_string(@subject_public_key.to_s) + "\n")
      end
      if (!(@key_usage).nil?)
        sb.append("  Key Usage: " + RJava.cast_to_string(key_usage_to_string(@key_usage)) + "\n")
      end
      if (!(@key_purpose_set).nil?)
        sb.append("  Extended Key Usage: " + RJava.cast_to_string(@key_purpose_set.to_s) + "\n")
      end
      if (!(@policy).nil?)
        sb.append("  Policy: " + RJava.cast_to_string(@policy.to_s) + "\n")
      end
      if (!(@path_to_general_names).nil?)
        sb.append("  Path to names:\n")
        i = @path_to_general_names.iterator
        while (i.has_next)
          sb.append("    " + RJava.cast_to_string(i.next_) + "\n")
        end
      end
      sb.append("]")
      return sb.to_s
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Boolean)] }
      # Copied from sun.security.x509.KeyUsageExtension
      # (without calling the superclass)
      # Returns a printable representation of the KeyUsage.
      def key_usage_to_string(k)
        s = "KeyUsage [\n"
        begin
          if (k[0])
            s += "  DigitalSignature\n"
          end
          if (k[1])
            s += "  Non_repudiation\n"
          end
          if (k[2])
            s += "  Key_Encipherment\n"
          end
          if (k[3])
            s += "  Data_Encipherment\n"
          end
          if (k[4])
            s += "  Key_Agreement\n"
          end
          if (k[5])
            s += "  Key_CertSign\n"
          end
          if (k[6])
            s += "  Crl_Sign\n"
          end
          if (k[7])
            s += "  Encipher_Only\n"
          end
          if (k[8])
            s += "  Decipher_Only\n"
          end
        rescue ArrayIndexOutOfBoundsException => ex
        end
        s += "]\n"
        return (s)
      end
      
      typesig { [X509Certificate, ::Java::Int] }
      # Returns an Extension object given any X509Certificate and extension oid.
      # Throw an <code>IOException</code> if the extension byte value is
      # malformed.
      # 
      # @param cert a <code>X509Certificate</code>
      # @param extId an <code>integer</code> which specifies the extension index.
      # Currently, the supported extensions are as follows:
      # index 0 - PrivateKeyUsageExtension
      # index 1 - SubjectAlternativeNameExtension
      # index 2 - NameConstraintsExtension
      # index 3 - CertificatePoliciesExtension
      # index 4 - ExtendedKeyUsageExtension
      # @return an <code>Extension</code> object whose real type is as specified
      # by the extension oid.
      # @throws IOException if cannot construct the <code>Extension</code>
      # object with the extension encoding retrieved from the passed in
      # <code>X509Certificate</code>.
      def get_extension_object(cert, ext_id)
        if (cert.is_a?(X509CertImpl))
          impl = cert
          case (ext_id)
          when PRIVATE_KEY_USAGE_ID
            return impl.get_private_key_usage_extension
          when SUBJECT_ALT_NAME_ID
            return impl.get_subject_alternative_name_extension
          when NAME_CONSTRAINTS_ID
            return impl.get_name_constraints_extension
          when CERT_POLICIES_ID
            return impl.get_certificate_policies_extension
          when EXTENDED_KEY_USAGE_ID
            return impl.get_extended_key_usage_extension
          else
            return nil
          end
        end
        raw_ext_val = cert.get_extension_value(EXTENSION_OIDS[ext_id])
        if ((raw_ext_val).nil?)
          return nil
        end
        in_ = DerInputStream.new(raw_ext_val)
        encoded = in_.get_octet_string
        case (ext_id)
        when PRIVATE_KEY_USAGE_ID
          begin
            return PrivateKeyUsageExtension.new(FALSE, encoded)
          rescue CertificateException => ex
            raise IOException.new(ex.get_message)
          end
          return SubjectAlternativeNameExtension.new(FALSE, encoded)
        when SUBJECT_ALT_NAME_ID
          return SubjectAlternativeNameExtension.new(FALSE, encoded)
        when NAME_CONSTRAINTS_ID
          return NameConstraintsExtension.new(FALSE, encoded)
        when CERT_POLICIES_ID
          return CertificatePoliciesExtension.new(FALSE, encoded)
        when EXTENDED_KEY_USAGE_ID
          return ExtendedKeyUsageExtension.new(FALSE, encoded)
        else
          return nil
        end
      end
    }
    
    typesig { [Certificate] }
    # Decides whether a <code>Certificate</code> should be selected.
    # 
    # @param cert the <code>Certificate</code> to be checked
    # @return <code>true</code> if the <code>Certificate</code> should be
    #         selected, <code>false</code> otherwise
    def match(cert)
      if (!(cert.is_a?(X509Certificate)))
        return false
      end
      xcert = cert
      if (!(Debug).nil?)
        Debug.println("X509CertSelector.match(SN: " + RJava.cast_to_string((xcert.get_serial_number).to_s(16)) + "\n  Issuer: " + RJava.cast_to_string(xcert.get_issuer_dn) + "\n  Subject: " + RJava.cast_to_string(xcert.get_subject_dn) + ")")
      end
      # match on X509Certificate
      if (!(@x509cert).nil?)
        if (!(@x509cert == xcert))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "certs don't match")
          end
          return false
        end
      end
      # match on serial number
      if (!(@serial_number).nil?)
        if (!(@serial_number == xcert.get_serial_number))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "serial numbers don't match")
          end
          return false
        end
      end
      # match on issuer name
      if (!(@issuer).nil?)
        if (!(@issuer == xcert.get_issuer_x500principal))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "issuer DNs don't match")
          end
          return false
        end
      end
      # match on subject name
      if (!(@subject).nil?)
        if (!(@subject == xcert.get_subject_x500principal))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "subject DNs don't match")
          end
          return false
        end
      end
      # match on certificate validity range
      if (!(@certificate_valid).nil?)
        begin
          xcert.check_validity(@certificate_valid)
        rescue CertificateException => e
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "certificate not within validity period")
          end
          return false
        end
      end
      # match on subject public key
      if (!(@subject_public_key_bytes).nil?)
        cert_key = xcert.get_public_key.get_encoded
        if (!Arrays.==(@subject_public_key_bytes, cert_key))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "subject public keys don't match")
          end
          return false
        end
      end
      result = match_basic_constraints(xcert) && match_key_usage(xcert) && match_extended_key_usage(xcert) && match_subject_key_id(xcert) && match_authority_key_id(xcert) && match_private_key_valid(xcert) && match_subject_public_key_alg_id(xcert) && match_policy(xcert) && match_subject_alternative_names(xcert) && match_path_to_names(xcert) && match_name_constraints(xcert)
      if (result && (!(Debug).nil?))
        Debug.println("X509CertSelector.match returning: true")
      end
      return result
    end
    
    typesig { [X509Certificate] }
    # match on subject key identifier extension value
    def match_subject_key_id(xcert)
      if ((@subject_key_id).nil?)
        return true
      end
      begin
        ext_val = xcert.get_extension_value("2.5.29.14")
        if ((ext_val).nil?)
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "no subject key ID extension")
          end
          return false
        end
        in_ = DerInputStream.new(ext_val)
        cert_subject_key_id = in_.get_octet_string
        if ((cert_subject_key_id).nil? || !Arrays.==(@subject_key_id, cert_subject_key_id))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "subject key IDs don't match")
          end
          return false
        end
      rescue IOException => ex
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: " + "exception in subject key ID check")
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on authority key identifier extension value
    def match_authority_key_id(xcert)
      if ((@authority_key_id).nil?)
        return true
      end
      begin
        ext_val = xcert.get_extension_value("2.5.29.35")
        if ((ext_val).nil?)
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "no authority key ID extension")
          end
          return false
        end
        in_ = DerInputStream.new(ext_val)
        cert_auth_key_id = in_.get_octet_string
        if ((cert_auth_key_id).nil? || !Arrays.==(@authority_key_id, cert_auth_key_id))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "authority key IDs don't match")
          end
          return false
        end
      rescue IOException => ex
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: " + "exception in authority key ID check")
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on private key usage range
    def match_private_key_valid(xcert)
      if ((@private_key_valid).nil?)
        return true
      end
      ext = nil
      begin
        ext = get_extension_object(xcert, PRIVATE_KEY_USAGE_ID)
        if (!(ext).nil?)
          ext.valid(@private_key_valid)
        end
      rescue CertificateExpiredException => e1
        if (!(Debug).nil?)
          time = "n/a"
          begin
            not_after = ext.get(PrivateKeyUsageExtension::NOT_AFTER)
            time = RJava.cast_to_string(not_after.to_s)
          rescue CertificateException => ex
            # not able to retrieve notAfter value
          end
          Debug.println("X509CertSelector.match: private key usage not " + "within validity date; ext.NOT_After: " + time + "; X509CertSelector: " + RJava.cast_to_string(self.to_s))
          e1.print_stack_trace
        end
        return false
      rescue CertificateNotYetValidException => e2
        if (!(Debug).nil?)
          time = "n/a"
          begin
            not_before = ext.get(PrivateKeyUsageExtension::NOT_BEFORE)
            time = RJava.cast_to_string(not_before.to_s)
          rescue CertificateException => ex
            # not able to retrieve notBefore value
          end
          Debug.println("X509CertSelector.match: private key usage not " + "within validity date; ext.NOT_BEFORE: " + time + "; X509CertSelector: " + RJava.cast_to_string(self.to_s))
          e2.print_stack_trace
        end
        return false
      rescue CertificateException => e3
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: CertificateException " + "in private key usage check; X509CertSelector: " + RJava.cast_to_string(self.to_s))
          e3.print_stack_trace
        end
        return false
      rescue IOException => e4
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: IOException in " + "private key usage check; X509CertSelector: " + RJava.cast_to_string(self.to_s))
          e4.print_stack_trace
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on subject public key algorithm OID
    def match_subject_public_key_alg_id(xcert)
      if ((@subject_public_key_alg_id).nil?)
        return true
      end
      begin
        encoded_key = xcert.get_public_key.get_encoded
        val = DerValue.new(encoded_key)
        if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("invalid key format")
        end
        alg_id = AlgorithmId.parse(val.attr_data.get_der_value)
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: subjectPublicKeyAlgID = " + RJava.cast_to_string(@subject_public_key_alg_id) + ", xcert subjectPublicKeyAlgID = " + RJava.cast_to_string(alg_id.get_oid))
        end
        if (!(@subject_public_key_alg_id == alg_id.get_oid))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "subject public key alg IDs don't match")
          end
          return false
        end
      rescue IOException => e5
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: IOException in subject " + "public key algorithm OID check")
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on key usage extension value
    def match_key_usage(xcert)
      if ((@key_usage).nil?)
        return true
      end
      cert_key_usage = xcert.get_key_usage
      if (!(cert_key_usage).nil?)
        key_bit = 0
        while key_bit < @key_usage.attr_length
          if (@key_usage[key_bit] && ((key_bit >= cert_key_usage.attr_length) || !cert_key_usage[key_bit]))
            if (!(Debug).nil?)
              Debug.println("X509CertSelector.match: " + "key usage bits don't match")
            end
            return false
          end
          key_bit += 1
        end
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on extended key usage purpose OIDs
    def match_extended_key_usage(xcert)
      if (((@key_purpose_set).nil?) || @key_purpose_set.is_empty)
        return true
      end
      begin
        ext = get_extension_object(xcert, EXTENDED_KEY_USAGE_ID)
        if (!(ext).nil?)
          cert_key_purpose_vector = ext.get(ExtendedKeyUsageExtension::USAGES)
          if (!cert_key_purpose_vector.contains(ANY_EXTENDED_KEY_USAGE) && !cert_key_purpose_vector.contains_all(@key_purpose_oidset))
            if (!(Debug).nil?)
              Debug.println("X509CertSelector.match: cert failed " + "extendedKeyUsage criterion")
            end
            return false
          end
        end
      rescue IOException => ex
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: " + "IOException in extended key usage check")
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on subject alternative name extension names
    def match_subject_alternative_names(xcert)
      if (((@subject_alternative_names).nil?) || @subject_alternative_names.is_empty)
        return true
      end
      begin
        san_ext = get_extension_object(xcert, SUBJECT_ALT_NAME_ID)
        if ((san_ext).nil?)
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "no subject alternative name extension")
          end
          return false
        end
        cert_names = san_ext.get(SubjectAlternativeNameExtension::SUBJECT_NAME)
        i = @subject_alternative_general_names.iterator
        while (i.has_next)
          match_name = i.next_
          found = false
          t = cert_names.iterator
          while t.has_next && !found
            cert_name = (t.next_).get_name
            found = (cert_name == match_name)
          end
          if (!found && (@match_all_subject_alt_names || !i.has_next))
            if (!(Debug).nil?)
              Debug.println("X509CertSelector.match: subject alternative " + "name " + RJava.cast_to_string(match_name) + " not found")
            end
            return false
          else
            if (found && !@match_all_subject_alt_names)
              break
            end
          end
        end
      rescue IOException => ex
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: IOException in subject " + "alternative name check")
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on name constraints
    def match_name_constraints(xcert)
      if ((@nc).nil?)
        return true
      end
      begin
        if (!@nc.verify(xcert))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "name constraints not satisfied")
          end
          return false
        end
      rescue IOException => e
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: " + "IOException in name constraints check")
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on policy OIDs
    def match_policy(xcert)
      if ((@policy).nil?)
        return true
      end
      begin
        ext = get_extension_object(xcert, CERT_POLICIES_ID)
        if ((ext).nil?)
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "no certificate policy extension")
          end
          return false
        end
        policies = ext.get(CertificatePoliciesExtension::POLICIES)
        # Convert the Vector of PolicyInformation to a Vector
        # of CertificatePolicyIds for easier comparison.
        policy_ids = ArrayList.new(policies.size)
        policies.each do |info|
          policy_ids.add(info.get_policy_identifier)
        end
        if (!(@policy).nil?)
          found_one = false
          # if the user passes in an empty policy Set, then
          # we just want to make sure that the candidate certificate
          # has some policy OID in its CertPoliciesExtension
          if (@policy.get_cert_policy_ids.is_empty)
            if (policy_ids.is_empty)
              if (!(Debug).nil?)
                Debug.println("X509CertSelector.match: " + "cert failed policyAny criterion")
              end
              return false
            end
          else
            @policy.get_cert_policy_ids.each do |id|
              if (policy_ids.contains(id))
                found_one = true
                break
              end
            end
            if (!found_one)
              if (!(Debug).nil?)
                Debug.println("X509CertSelector.match: " + "cert failed policyAny criterion")
              end
              return false
            end
          end
        end
      rescue IOException => ex
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: " + "IOException in certificate policy ID check")
        end
        return false
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on pathToNames
    def match_path_to_names(xcert)
      if ((@path_to_general_names).nil?)
        return true
      end
      begin
        ext = get_extension_object(xcert, NAME_CONSTRAINTS_ID)
        if ((ext).nil?)
          return true
        end
        if ((!(Debug).nil?) && Debug.is_on("certpath"))
          Debug.println("X509CertSelector.match pathToNames:\n")
          i = @path_to_general_names.iterator
          while (i.has_next)
            Debug.println("    " + RJava.cast_to_string(i.next_) + "\n")
          end
        end
        permitted = ext.get(NameConstraintsExtension::PERMITTED_SUBTREES)
        excluded = ext.get(NameConstraintsExtension::EXCLUDED_SUBTREES)
        if (!(excluded).nil?)
          if ((match_excluded(excluded)).equal?(false))
            return false
          end
        end
        if (!(permitted).nil?)
          if ((match_permitted(permitted)).equal?(false))
            return false
          end
        end
      rescue IOException => ex
        if (!(Debug).nil?)
          Debug.println("X509CertSelector.match: " + "IOException in name constraints check")
        end
        return false
      end
      return true
    end
    
    typesig { [GeneralSubtrees] }
    def match_excluded(excluded)
      # Enumerate through excluded and compare each entry
      # to all pathToNames. If any pathToName is within any of the
      # subtrees listed in excluded, return false.
      t = excluded.iterator
      while t.has_next
        tree = t.next_
        excluded_name = tree.get_name.get_name
        i = @path_to_general_names.iterator
        while (i.has_next)
          path_to_name = i.next_
          if ((excluded_name.get_type).equal?(path_to_name.get_type))
            case (path_to_name.constrains(excluded_name))
            when GeneralNameInterface::NAME_WIDENS, GeneralNameInterface::NAME_MATCH
              if (!(Debug).nil?)
                Debug.println("X509CertSelector.match: name constraints " + "inhibit path to specified name")
                Debug.println("X509CertSelector.match: excluded name: " + RJava.cast_to_string(path_to_name))
              end
              return false
            else
            end
          end
        end
      end
      return true
    end
    
    typesig { [GeneralSubtrees] }
    def match_permitted(permitted)
      # Enumerate through pathToNames, checking that each pathToName
      # is in at least one of the subtrees listed in permitted.
      # If not, return false. However, if no subtrees of a given type
      # are listed, all names of that type are permitted.
      i = @path_to_general_names.iterator
      while (i.has_next)
        path_to_name = i.next_
        t = permitted.iterator
        permitted_name_found = false
        name_type_found = false
        names = ""
        while (t.has_next && !permitted_name_found)
          tree = t.next_
          permitted_name = tree.get_name.get_name
          if ((permitted_name.get_type).equal?(path_to_name.get_type))
            name_type_found = true
            names = names + "  " + RJava.cast_to_string(permitted_name)
            case (path_to_name.constrains(permitted_name))
            when GeneralNameInterface::NAME_WIDENS, GeneralNameInterface::NAME_MATCH
              permitted_name_found = true
            else
            end
          end
        end
        if (!permitted_name_found && name_type_found)
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: " + "name constraints inhibit path to specified name; " + "permitted names of type " + RJava.cast_to_string(path_to_name.get_type) + ": " + names)
          end
          return false
        end
      end
      return true
    end
    
    typesig { [X509Certificate] }
    # match on basic constraints
    def match_basic_constraints(xcert)
      if ((@basic_constraints).equal?(-1))
        return true
      end
      max_path_len = xcert.get_basic_constraints
      if ((@basic_constraints).equal?(-2))
        if (!(max_path_len).equal?(-1))
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: not an EE cert")
          end
          return false
        end
      else
        if (max_path_len < @basic_constraints)
          if (!(Debug).nil?)
            Debug.println("X509CertSelector.match: maxPathLen too small (" + RJava.cast_to_string(max_path_len) + " < " + RJava.cast_to_string(@basic_constraints) + ")")
          end
          return false
        end
      end
      return true
    end
    
    class_module.module_eval {
      typesig { [JavaSet] }
      def clone_set(set_)
        if (set_.is_a?(HashSet))
          clone_ = (set_).clone
          return clone_
        else
          return HashSet.new(set_)
        end
      end
    }
    
    typesig { [] }
    # Returns a copy of this object.
    # 
    # @return the copy
    def clone
      begin
        copy = super
        # Must clone these because addPathToName et al. modify them
        if (!(@subject_alternative_names).nil?)
          copy.attr_subject_alternative_names = clone_set(@subject_alternative_names)
          copy.attr_subject_alternative_general_names = clone_set(@subject_alternative_general_names)
        end
        if (!(@path_to_general_names).nil?)
          copy.attr_path_to_names = clone_set(@path_to_names)
          copy.attr_path_to_general_names = clone_set(@path_to_general_names)
        end
        return copy
      rescue CloneNotSupportedException => e
        # Cannot happen
        raise InternalError.new(e.to_s)
      end
    end
    
    private
    alias_method :initialize__x509cert_selector, :initialize
  end
  
end
