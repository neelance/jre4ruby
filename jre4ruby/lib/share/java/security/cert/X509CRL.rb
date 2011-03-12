require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X509CRLImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :NoSuchProviderException
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :SignatureException
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :PublicKey
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Security::X509, :X509CRLImpl
    }
  end
  
  # <p>
  # Abstract class for an X.509 Certificate Revocation List (CRL).
  # A CRL is a time-stamped list identifying revoked certificates.
  # It is signed by a Certificate Authority (CA) and made freely
  # available in a public repository.
  # 
  # <p>Each revoked certificate is
  # identified in a CRL by its certificate serial number. When a
  # certificate-using system uses a certificate (e.g., for verifying a
  # remote user's digital signature), that system not only checks the
  # certificate signature and validity but also acquires a suitably-
  # recent CRL and checks that the certificate serial number is not on
  # that CRL.  The meaning of "suitably-recent" may vary with local
  # policy, but it usually means the most recently-issued CRL.  A CA
  # issues a new CRL on a regular periodic basis (e.g., hourly, daily, or
  # weekly).  Entries are added to CRLs as revocations occur, and an
  # entry may be removed when the certificate expiration date is reached.
  # <p>
  # The X.509 v2 CRL format is described below in ASN.1:
  # <pre>
  # CertificateList  ::=  SEQUENCE  {
  #     tbsCertList          TBSCertList,
  #     signatureAlgorithm   AlgorithmIdentifier,
  #     signature            BIT STRING  }
  # </pre>
  # <p>
  # More information can be found in
  # <a href="http://www.ietf.org/rfc/rfc3280.txt">RFC 3280: Internet X.509
  # Public Key Infrastructure Certificate and CRL Profile</a>.
  # <p>
  # The ASN.1 definition of <code>tbsCertList</code> is:
  # <pre>
  # TBSCertList  ::=  SEQUENCE  {
  #     version                 Version OPTIONAL,
  #                             -- if present, must be v2
  #     signature               AlgorithmIdentifier,
  #     issuer                  Name,
  #     thisUpdate              ChoiceOfTime,
  #     nextUpdate              ChoiceOfTime OPTIONAL,
  #     revokedCertificates     SEQUENCE OF SEQUENCE  {
  #         userCertificate         CertificateSerialNumber,
  #         revocationDate          ChoiceOfTime,
  #         crlEntryExtensions      Extensions OPTIONAL
  #                                 -- if present, must be v2
  #         }  OPTIONAL,
  #     crlExtensions           [0]  EXPLICIT Extensions OPTIONAL
  #                                  -- if present, must be v2
  #     }
  # </pre>
  # <p>
  # CRLs are instantiated using a certificate factory. The following is an
  # example of how to instantiate an X.509 CRL:
  # <pre><code>
  # InputStream inStream = null;
  # try {
  #     inStream = new FileInputStream("fileName-of-crl");
  #     CertificateFactory cf = CertificateFactory.getInstance("X.509");
  #     X509CRL crl = (X509CRL)cf.generateCRL(inStream);
  # } finally {
  #     if (inStream != null) {
  #         inStream.close();
  #     }
  # }
  # </code></pre>
  # 
  # @author Hemma Prafullchandra
  # 
  # 
  # @see CRL
  # @see CertificateFactory
  # @see X509Extension
  class X509CRL < X509CRLImports.const_get :CRL
    include_class_members X509CRLImports
    overload_protected {
      include X509Extension
    }
    
    attr_accessor :issuer_principal
    alias_method :attr_issuer_principal, :issuer_principal
    undef_method :issuer_principal
    alias_method :attr_issuer_principal=, :issuer_principal=
    undef_method :issuer_principal=
    
    typesig { [] }
    # Constructor for X.509 CRLs.
    def initialize
      @issuer_principal = nil
      super("X.509")
    end
    
    typesig { [Object] }
    # Compares this CRL for equality with the given
    # object. If the <code>other</code> object is an
    # <code>instanceof</code> <code>X509CRL</code>, then
    # its encoded form is retrieved and compared with the
    # encoded form of this CRL.
    # 
    # @param other the object to test for equality with this CRL.
    # 
    # @return true iff the encoded forms of the two CRLs
    # match, false otherwise.
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(X509CRL)))
        return false
      end
      begin
        this_crl = X509CRLImpl.get_encoded_internal(self)
        other_crl = X509CRLImpl.get_encoded_internal(other)
        return Arrays.==(this_crl, other_crl)
      rescue CRLException => e
        return false
      end
    end
    
    typesig { [] }
    # Returns a hashcode value for this CRL from its
    # encoded form.
    # 
    # @return the hashcode value.
    def hash_code
      retval = 0
      begin
        crl_data = X509CRLImpl.get_encoded_internal(self)
        i = 1
        while i < crl_data.attr_length
          retval += crl_data[i] * i
          i += 1
        end
        return retval
      rescue CRLException => e
        return retval
      end
    end
    
    typesig { [] }
    # Returns the ASN.1 DER-encoded form of this CRL.
    # 
    # @return the encoded form of this certificate
    # @exception CRLException if an encoding error occurs.
    def get_encoded
      raise NotImplementedError
    end
    
    typesig { [PublicKey] }
    # Verifies that this CRL was signed using the
    # private key that corresponds to the given public key.
    # 
    # @param key the PublicKey used to carry out the verification.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException if there's no default provider.
    # @exception SignatureException on signature errors.
    # @exception CRLException on encoding errors.
    def verify(key)
      raise NotImplementedError
    end
    
    typesig { [PublicKey, String] }
    # Verifies that this CRL was signed using the
    # private key that corresponds to the given public key.
    # This method uses the signature verification engine
    # supplied by the given provider.
    # 
    # @param key the PublicKey used to carry out the verification.
    # @param sigProvider the name of the signature provider.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException on incorrect provider.
    # @exception SignatureException on signature errors.
    # @exception CRLException on encoding errors.
    def verify(key, sig_provider)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the <code>version</code> (version number) value from the CRL.
    # The ASN.1 definition for this is:
    # <pre>
    # version    Version OPTIONAL,
    #             -- if present, must be v2<p>
    # Version  ::=  INTEGER  {  v1(0), v2(1), v3(2)  }
    #             -- v3 does not apply to CRLs but appears for consistency
    #             -- with definition of Version for certs
    # </pre>
    # 
    # @return the version number, i.e. 1 or 2.
    def get_version
      raise NotImplementedError
    end
    
    typesig { [] }
    # <strong>Denigrated</strong>, replaced by {@linkplain
    # #getIssuerX500Principal()}. This method returns the <code>issuer</code>
    # as an implementation specific Principal object, which should not be
    # relied upon by portable code.
    # 
    # <p>
    # Gets the <code>issuer</code> (issuer distinguished name) value from
    # the CRL. The issuer name identifies the entity that signed (and
    # issued) the CRL.
    # 
    # <p>The issuer name field contains an
    # X.500 distinguished name (DN).
    # The ASN.1 definition for this is:
    # <pre>
    # issuer    Name
    # 
    # Name ::= CHOICE { RDNSequence }
    # RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
    # RelativeDistinguishedName ::=
    #     SET OF AttributeValueAssertion
    # 
    # AttributeValueAssertion ::= SEQUENCE {
    #                               AttributeType,
    #                               AttributeValue }
    # AttributeType ::= OBJECT IDENTIFIER
    # AttributeValue ::= ANY
    # </pre>
    # The <code>Name</code> describes a hierarchical name composed of
    # attributes,
    # such as country name, and corresponding values, such as US.
    # The type of the <code>AttributeValue</code> component is determined by
    # the <code>AttributeType</code>; in general it will be a
    # <code>directoryString</code>. A <code>directoryString</code> is usually
    # one of <code>PrintableString</code>,
    # <code>TeletexString</code> or <code>UniversalString</code>.
    # 
    # @return a Principal whose name is the issuer distinguished name.
    def get_issuer_dn
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the issuer (issuer distinguished name) value from the
    # CRL as an <code>X500Principal</code>.
    # <p>
    # It is recommended that subclasses override this method.
    # 
    # @return an <code>X500Principal</code> representing the issuer
    #          distinguished name
    # @since 1.4
    def get_issuer_x500principal
      if ((@issuer_principal).nil?)
        @issuer_principal = X509CRLImpl.get_issuer_x500principal(self)
      end
      return @issuer_principal
    end
    
    typesig { [] }
    # Gets the <code>thisUpdate</code> date from the CRL.
    # The ASN.1 definition for this is:
    # <pre>
    # thisUpdate   ChoiceOfTime
    # ChoiceOfTime ::= CHOICE {
    #     utcTime        UTCTime,
    #     generalTime    GeneralizedTime }
    # </pre>
    # 
    # @return the <code>thisUpdate</code> date from the CRL.
    def get_this_update
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the <code>nextUpdate</code> date from the CRL.
    # 
    # @return the <code>nextUpdate</code> date from the CRL, or null if
    # not present.
    def get_next_update
      raise NotImplementedError
    end
    
    typesig { [BigInteger] }
    # Gets the CRL entry, if any, with the given certificate serialNumber.
    # 
    # @param serialNumber the serial number of the certificate for which a CRL entry
    # is to be looked up
    # @return the entry with the given serial number, or null if no such entry
    # exists in this CRL.
    # @see X509CRLEntry
    def get_revoked_certificate(serial_number)
      raise NotImplementedError
    end
    
    typesig { [X509Certificate] }
    # Get the CRL entry, if any, for the given certificate.
    # 
    # <p>This method can be used to lookup CRL entries in indirect CRLs,
    # that means CRLs that contain entries from issuers other than the CRL
    # issuer. The default implementation will only return entries for
    # certificates issued by the CRL issuer. Subclasses that wish to
    # support indirect CRLs should override this method.
    # 
    # @param certificate the certificate for which a CRL entry is to be looked
    #   up
    # @return the entry for the given certificate, or null if no such entry
    #   exists in this CRL.
    # @exception NullPointerException if certificate is null
    # 
    # @since 1.5
    def get_revoked_certificate(certificate)
      cert_issuer = certificate.get_issuer_x500principal
      crl_issuer = get_issuer_x500principal
      if (((cert_issuer == crl_issuer)).equal?(false))
        return nil
      end
      return get_revoked_certificate(certificate.get_serial_number)
    end
    
    typesig { [] }
    # Gets all the entries from this CRL.
    # This returns a Set of X509CRLEntry objects.
    # 
    # @return all the entries or null if there are none present.
    # @see X509CRLEntry
    def get_revoked_certificates
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the DER-encoded CRL information, the
    # <code>tbsCertList</code> from this CRL.
    # This can be used to verify the signature independently.
    # 
    # @return the DER-encoded CRL information.
    # @exception CRLException if an encoding error occurs.
    def get_tbscert_list
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the <code>signature</code> value (the raw signature bits) from
    # the CRL.
    # The ASN.1 definition for this is:
    # <pre>
    # signature     BIT STRING
    # </pre>
    # 
    # @return the signature.
    def get_signature
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the signature algorithm name for the CRL
    # signature algorithm. An example is the string "SHA-1/DSA".
    # The ASN.1 definition for this is:
    # <pre>
    # signatureAlgorithm   AlgorithmIdentifier<p>
    # AlgorithmIdentifier  ::=  SEQUENCE  {
    #     algorithm               OBJECT IDENTIFIER,
    #     parameters              ANY DEFINED BY algorithm OPTIONAL  }
    #                             -- contains a value of the type
    #                             -- registered for use with the
    #                             -- algorithm object identifier value
    # </pre>
    # 
    # <p>The algorithm name is determined from the <code>algorithm</code>
    # OID string.
    # 
    # @return the signature algorithm name.
    def get_sig_alg_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the signature algorithm OID string from the CRL.
    # An OID is represented by a set of nonnegative whole numbers separated
    # by periods.
    # For example, the string "1.2.840.10040.4.3" identifies the SHA-1
    # with DSA signature algorithm defined in
    # <a href="http://www.ietf.org/rfc/rfc3279.txt">RFC 3279: Algorithms and
    # Identifiers for the Internet X.509 Public Key Infrastructure Certificate
    # and CRL Profile</a>.
    # 
    # <p>See {@link #getSigAlgName() getSigAlgName} for
    # relevant ASN.1 definitions.
    # 
    # @return the signature algorithm OID string.
    def get_sig_alg_oid
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the DER-encoded signature algorithm parameters from this
    # CRL's signature algorithm. In most cases, the signature
    # algorithm parameters are null; the parameters are usually
    # supplied with the public key.
    # If access to individual parameter values is needed then use
    # {@link java.security.AlgorithmParameters AlgorithmParameters}
    # and instantiate with the name returned by
    # {@link #getSigAlgName() getSigAlgName}.
    # 
    # <p>See {@link #getSigAlgName() getSigAlgName} for
    # relevant ASN.1 definitions.
    # 
    # @return the DER-encoded signature algorithm parameters, or
    #         null if no parameters are present.
    def get_sig_alg_params
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__x509crl, :initialize
  end
  
end
