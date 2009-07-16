require "rjava"

# 
# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module X509CertImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :Serializable
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # DER
  # 
  # @author David Brownell
  # 
  # @see CertAndKeyGen
  # @deprecated  Use the new X509Certificate class.
  # This class is only restored for backwards compatibility.
  class X509Cert 
    include_class_members X509CertImports
    include Certificate
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -52595524744692374 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # NOTE: All fields are marked transient, because we do not want them to
    # be included in the class description when we serialize an object of
    # this class. We override "writeObject" and "readObject" to use the
    # ASN.1 encoding of a certificate as the serialized form, instead of
    # calling the default routines which would operate on the field values.
    # 
    # MAKE SURE TO MARK ANY FIELDS THAT ARE ADDED IN THE FUTURE AS TRANSIENT.
    # 
    # The algorithm id
    attr_accessor :algid
    alias_method :attr_algid, :algid
    undef_method :algid
    alias_method :attr_algid=, :algid=
    undef_method :algid=
    
    # 
    # Certificate data, and its envelope
    attr_accessor :raw_cert
    alias_method :attr_raw_cert, :raw_cert
    undef_method :raw_cert
    alias_method :attr_raw_cert=, :raw_cert=
    undef_method :raw_cert=
    
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    attr_accessor :signed_cert
    alias_method :attr_signed_cert, :signed_cert
    undef_method :signed_cert
    alias_method :attr_signed_cert=, :signed_cert=
    undef_method :signed_cert=
    
    # 
    # X509.v1 data (parsed)
    attr_accessor :subject
    alias_method :attr_subject, :subject
    undef_method :subject
    alias_method :attr_subject=, :subject=
    undef_method :subject=
    
    # from subject
    attr_accessor :pubkey
    alias_method :attr_pubkey, :pubkey
    undef_method :pubkey
    alias_method :attr_pubkey=, :pubkey=
    undef_method :pubkey=
    
    attr_accessor :notafter
    alias_method :attr_notafter, :notafter
    undef_method :notafter
    alias_method :attr_notafter=, :notafter=
    undef_method :notafter=
    
    # from CA (constructor)
    attr_accessor :notbefore
    alias_method :attr_notbefore, :notbefore
    undef_method :notbefore
    alias_method :attr_notbefore=, :notbefore=
    undef_method :notbefore=
    
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    # from CA (signAndEncode)
    attr_accessor :serialnum
    alias_method :attr_serialnum, :serialnum
    undef_method :serialnum
    alias_method :attr_serialnum=, :serialnum=
    undef_method :serialnum=
    
    attr_accessor :issuer
    alias_method :attr_issuer, :issuer
    undef_method :issuer
    alias_method :attr_issuer=, :issuer=
    undef_method :issuer=
    
    attr_accessor :issuer_sig_alg
    alias_method :attr_issuer_sig_alg, :issuer_sig_alg
    undef_method :issuer_sig_alg
    alias_method :attr_issuer_sig_alg=, :issuer_sig_alg=
    undef_method :issuer_sig_alg=
    
    # 
    # flag to indicate whether or not this certificate has already been parsed
    # (through a call to one of the constructors or the "decode" or
    # "readObject" methods). This is to ensure that certificates are
    # immutable.
    attr_accessor :parsed
    alias_method :attr_parsed, :parsed
    undef_method :parsed
    alias_method :attr_parsed=, :parsed=
    undef_method :parsed=
    
    typesig { [] }
    # 
    # X509.v2 extensions
    # 
    # 
    # X509.v3 extensions
    # 
    # 
    # Other extensions ... Netscape, Verisign, SET, etc
    # 
    # 
    # Construct a uninitialized X509 Cert on which <a href="#decode">
    # decode</a> must later be called (or which may be deserialized).
    # 
    # XXX deprecated, delete this
    def initialize
      @algid = nil
      @raw_cert = nil
      @signature = nil
      @signed_cert = nil
      @subject = nil
      @pubkey = nil
      @notafter = nil
      @notbefore = nil
      @version = 0
      @serialnum = nil
      @issuer = nil
      @issuer_sig_alg = nil
      @parsed = false
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Unmarshals a certificate from its encoded form, parsing the
    # encoded bytes.  This form of constructor is used by agents which
    # need to examine and use certificate contents.  That is, this is
    # one of the more commonly used constructors.  Note that the buffer
    # must include only a certificate, and no "garbage" may be left at
    # the end.  If you need to ignore data at the end of a certificate,
    # use another constructor.
    # 
    # @param cert the encoded bytes, with no terminatu (CONSUMED)
    # @exception IOException when the certificate is improperly encoded.
    def initialize(cert)
      @algid = nil
      @raw_cert = nil
      @signature = nil
      @signed_cert = nil
      @subject = nil
      @pubkey = nil
      @notafter = nil
      @notbefore = nil
      @version = 0
      @serialnum = nil
      @issuer = nil
      @issuer_sig_alg = nil
      @parsed = false
      in_ = DerValue.new(cert)
      parse(in_)
      if (!(in_.attr_data.available).equal?(0))
        raise CertParseError.new("garbage at end")
      end
      @signed_cert = cert
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Unmarshals a certificate from its encoded form, parsing the
    # encoded bytes.  This form of constructor is used by agents which
    # need to examine and use certificate contents.  That is, this is
    # one of the most commonly used constructors.
    # 
    # @param buf the buffer holding the encoded bytes
    # @param offset the offset in the buffer where the bytes begin
    # @param len how many bytes of certificate exist
    # 
    # @exception IOException when the certificate is improperly encoded.
    def initialize(buf, offset, len)
      @algid = nil
      @raw_cert = nil
      @signature = nil
      @signed_cert = nil
      @subject = nil
      @pubkey = nil
      @notafter = nil
      @notbefore = nil
      @version = 0
      @serialnum = nil
      @issuer = nil
      @issuer_sig_alg = nil
      @parsed = false
      in_ = DerValue.new(buf, offset, len)
      parse(in_)
      if (!(in_.attr_data.available).equal?(0))
        raise CertParseError.new("garbage at end")
      end
      @signed_cert = Array.typed(::Java::Byte).new(len) { 0 }
      System.arraycopy(buf, offset, @signed_cert, 0, len)
    end
    
    typesig { [DerValue] }
    # 
    # Unmarshal a certificate from its encoded form, parsing a DER value.
    # This form of constructor is used by agents which need to examine
    # and use certificate contents.
    # 
    # @param derVal the der value containing the encoded cert.
    # @exception IOException when the certificate is improperly encoded.
    def initialize(der_val)
      @algid = nil
      @raw_cert = nil
      @signature = nil
      @signed_cert = nil
      @subject = nil
      @pubkey = nil
      @notafter = nil
      @notbefore = nil
      @version = 0
      @serialnum = nil
      @issuer = nil
      @issuer_sig_alg = nil
      @parsed = false
      parse(der_val)
      if (!(der_val.attr_data.available).equal?(0))
        raise CertParseError.new("garbage at end")
      end
      @signed_cert = der_val.to_byte_array
    end
    
    typesig { [X500Name, X509Key, Date, Date] }
    # 
    # Partially constructs a certificate from descriptive parameters.
    # This constructor may be used by Certificate Authority (CA) code,
    # which later <a href="#signAndEncode">signs and encodes</a> the
    # certificate.  Also, self-signed certificates serve as CA certificates,
    # and are sometimes used as certificate requests.
    # 
    # <P>Until the certificate has been signed and encoded, some of
    # the mandatory fields in the certificate will not be available
    # via accessor functions:  the serial number, issuer name and signing
    # algorithm, and of course the signed certificate.  The fields passed
    # to this constructor are available, and must be non-null.
    # 
    # <P>Note that the public key being signed is generally independent of
    # the signature algorithm being used.  So for example Diffie-Hellman
    # keys (which do not support signatures) can be placed in X.509
    # certificates when some other signature algorithm (e.g. DSS/DSA,
    # or one of the RSA based algorithms) is used.
    # 
    # @see CertAndKeyGen
    # 
    # @param subjectName the X.500 distinguished name being certified
    # @param subjectPublicKey the public key being certified.  This
    # must be an "X509Key" implementing the "PublicKey" interface.
    # @param notBefore the first time the certificate is valid
    # @param notAfter the last time the certificate is valid
    # 
    # @exception CertException if the public key is inappropriate
    def initialize(subject_name, subject_public_key, not_before, not_after)
      @algid = nil
      @raw_cert = nil
      @signature = nil
      @signed_cert = nil
      @subject = nil
      @pubkey = nil
      @notafter = nil
      @notbefore = nil
      @version = 0
      @serialnum = nil
      @issuer = nil
      @issuer_sig_alg = nil
      @parsed = false
      @subject = subject_name
      if (!(subject_public_key.is_a?(PublicKey)))
        raise CertException.new(CertException.attr_err_invalid_public_key, "Doesn't implement PublicKey interface")
      end
      # The X509 cert API requires X509 keys, else things break.
      @pubkey = subject_public_key
      @notbefore = not_before
      @notafter = not_after
      @version = 0
    end
    
    typesig { [InputStream] }
    # 
    # Decode an X.509 certificate from an input stream.
    # 
    # @param in an input stream holding at least one certificate
    # @exception IOException when the certificate is improperly encoded, or
    # if it has already been parsed.
    def decode(in_)
      val = DerValue.new(in_)
      parse(val)
      @signed_cert = val.to_byte_array
    end
    
    typesig { [OutputStream] }
    # 
    # Appends the certificate to an output stream.
    # 
    # @param out an input stream to which the certificate is appended.
    # @exception IOException when appending fails.
    def encode(out)
      out.write(get_signed_cert)
    end
    
    typesig { [Object] }
    # 
    # Compares two certificates.  This is false if the
    # certificates are not both X.509 certs, otherwise it
    # compares them as binary data.
    # 
    # @param other the object being compared with this one
    # @return true iff the certificates are equivalent
    def equals(other)
      if (other.is_a?(X509Cert))
        return equals(other)
      else
        return false
      end
    end
    
    typesig { [X509Cert] }
    # 
    # Compares two certificates, returning false if any data
    # differs between the two.
    # 
    # @param other the object being compared with this one
    # @return true iff the certificates are equivalent
    def equals(src)
      if ((self).equal?(src))
        return true
      end
      if ((@signed_cert).nil? || (src.attr_signed_cert).nil?)
        return false
      end
      if (!(@signed_cert.attr_length).equal?(src.attr_signed_cert.attr_length))
        return false
      end
      i = 0
      while i < @signed_cert.attr_length
        if (!(@signed_cert[i]).equal?(src.attr_signed_cert[i]))
          return false
        end
        ((i += 1) - 1)
      end
      return true
    end
    
    typesig { [] }
    # Returns the "X.509" format identifier.
    def get_format
      # for Certificate
      return "X.509"
    end
    
    typesig { [] }
    # Returns <a href="#getIssuerName">getIssuerName</a>
    def get_guarantor
      # for Certificate
      return get_issuer_name
    end
    
    typesig { [] }
    # Returns <a href="#getSubjectName">getSubjectName</a>
    def get_principal
      return get_subject_name
    end
    
    typesig { [PublicKey] }
    # 
    # Throws an exception if the certificate is invalid because it is
    # now outside of the certificate's validity period, or because it
    # was not signed using the verification key provided.  Successfully
    # verifying a certificate does <em>not</em> indicate that one should
    # trust the entity which it represents.
    # 
    # <P><em>Note that since this class represents only a single X.509
    # certificate, it cannot know anything about the certificate chain
    # which is used to provide the verification key and to establish trust.
    # Other code must manage and use those cert chains.
    # 
    # <P>For now, you must walk the cert chain being used to verify any
    # given cert.  Start at the root, which is a self-signed certificate;
    # verify it using the key inside the certificate.  Then use that to
    # verify the next certificate in the chain, issued by that CA.  In
    # this manner, verify each certificate until you reach the particular
    # certificate you wish to verify.  You should not use a certificate
    # if any of the verification operations for its certificate chain
    # were unsuccessful.
    # </em>
    # 
    # @param issuerPublicKey the public key of the issuing CA
    # @exception CertException when the certificate is not valid.
    def verify(issuer_public_key)
      now = Date.new
      if (now.before(@notbefore))
        raise CertException.new(CertException.attr_verf_invalid_notbefore)
      end
      if (now.after(@notafter))
        raise CertException.new(CertException.attr_verf_invalid_expired)
      end
      if ((@signed_cert).nil?)
        raise CertException.new(CertException.attr_verf_invalid_sig, "?? certificate is not signed yet ??")
      end
      # 
      # Verify the signature ...
      alg_name = nil
      begin
        sig_verf = nil
        alg_name = (@issuer_sig_alg.get_name).to_s
        sig_verf = Signature.get_instance(alg_name)
        sig_verf.init_verify(issuer_public_key)
        sig_verf.update(@raw_cert, 0, @raw_cert.attr_length)
        if (!sig_verf.verify(@signature))
          raise CertException.new(CertException.attr_verf_invalid_sig, "Signature ... by <" + (@issuer).to_s + "> for <" + (@subject).to_s + ">")
        end
        # Gag -- too many catch clauses, let most through.
      rescue NoSuchAlgorithmException => e
        raise CertException.new(CertException.attr_verf_invalid_sig, "Unsupported signature algorithm (" + alg_name + ")")
      rescue InvalidKeyException => e
        # e.printStackTrace();
        raise CertException.new(CertException.attr_err_invalid_public_key, "Algorithm (" + alg_name + ") rejected public key")
      rescue SignatureException => e
        raise CertException.new(CertException.attr_verf_invalid_sig, "Signature by <" + (@issuer).to_s + "> for <" + (@subject).to_s + ">")
      end
    end
    
    typesig { [BigInteger, X500Signer] }
    # 
    # Creates an X.509 certificate, and signs it using the issuer
    # passed (associating a signature algorithm and an X.500 name).
    # This operation is used to implement the certificate generation
    # functionality of a certificate authority.
    # 
    # @see #getSignedCert
    # @see #getSigner
    # @see CertAndKeyGen
    # 
    # @param serial the serial number of the certificate (non-null)
    # @param issuer the certificate issuer (CA) (non-null)
    # @return the signed certificate, as returned by getSignedCert
    # 
    # @exception IOException if any of the data could not be encoded,
    # or when any mandatory data was omitted
    # @exception SignatureException on signing failures
    def encode_and_sign(serial, issuer)
      @raw_cert = nil
      # 
      # Get the remaining cert parameters, and make sure we have enough.
      # 
      # We deduce version based on what attribute data are available
      # For now, we have no attributes, so we always deduce X.509v1 !
      @version = 0
      @serialnum = serial
      @issuer = issuer.get_signer
      @issuer_sig_alg = issuer.get_algorithm_id
      if ((@subject).nil? || (@pubkey).nil? || (@notbefore).nil? || (@notafter).nil?)
        raise IOException.new("not enough cert parameters")
      end
      # 
      # Encode the raw cert, create its signature and put it
      # into the envelope.
      @raw_cert = _derencode
      @signed_cert = sign(issuer, @raw_cert)
      return @signed_cert
    end
    
    typesig { [AlgorithmId, PrivateKey] }
    # 
    # Returns an X500Signer that may be used to create signatures.  Those
    # signature may in turn be verified using this certificate (or a
    # copy of it).
    # 
    # <P><em><b>NOTE:</b>  If the private key is by itself capable of
    # creating signatures, this fact may not be recognized at this time.
    # Specifically, the case of DSS/DSA keys which get their algorithm
    # parameters from higher in the certificate chain is not supportable
    # without using an X509CertChain API, and there is no current support
    # for other sources of algorithm parameters.</em>
    # 
    # @param algorithm the signature algorithm to be used.  Note that a
    # given public/private key pair may support several such algorithms.
    # @param privateKey the private key used to create the signature,
    # which must correspond to the public key in this certificate
    # @return the Signer object
    # 
    # @exception NoSuchAlgorithmException if the signature
    # algorithm is not supported
    # @exception InvalidKeyException if either the key in the certificate,
    # or the private key parameter, does not support the requested
    # signature algorithm
    def get_signer(algorithm_id, private_key)
      algorithm = nil
      sig = nil
      if (private_key.is_a?(Key))
        key = private_key
        algorithm = (key.get_algorithm).to_s
      else
        raise InvalidKeyException.new("private key not a key!")
      end
      sig = Signature.get_instance(algorithm_id.get_name)
      if (!(@pubkey.get_algorithm == algorithm))
        raise InvalidKeyException.new("Private key algorithm " + algorithm + " incompatible with certificate " + (@pubkey.get_algorithm).to_s)
      end
      sig.init_sign(private_key)
      return X500Signer.new(sig, @subject)
    end
    
    typesig { [String] }
    # 
    # Returns a signature object that may be used to verify signatures
    # created using a specified signature algorithm and the public key
    # contained in this certificate.
    # 
    # <P><em><b>NOTE:</b>  If the public key in this certificate is not by
    # itself capable of verifying signatures, this may not be recognized
    # at this time.  Specifically, the case of DSS/DSA keys which get
    # their algorithm parameters from higher in the certificate chain
    # is not supportable without using an X509CertChain API, and there
    # is no current support for other sources of algorithm parameters.</em>
    # 
    # @param algorithm the algorithm of the signature to be verified
    # @return the Signature object
    # @exception NoSuchAlgorithmException if the signature
    # algorithm is not supported
    # @exception InvalidKeyException if the key in the certificate
    # does not support the requested signature algorithm
    def get_verifier(algorithm)
      alg_name = nil
      sig = nil
      sig = Signature.get_instance(algorithm)
      sig.init_verify(@pubkey)
      return sig
    end
    
    typesig { [] }
    # 
    # Return the signed X.509 certificate as a byte array.
    # The bytes are in standard DER marshaled form.
    # Null is returned in the case of a partially constructed cert.
    def get_signed_cert
      return @signed_cert.clone
    end
    
    typesig { [] }
    # 
    # Returns the certificate's serial number.
    # Null is returned in the case of a partially constructed cert.
    def get_serial_number
      return @serialnum
    end
    
    typesig { [] }
    # 
    # Returns the subject's X.500 distinguished name.
    def get_subject_name
      return @subject
    end
    
    typesig { [] }
    # 
    # Returns the certificate issuer's X.500 distinguished name.
    # Null is returned in the case of a partially constructed cert.
    def get_issuer_name
      return @issuer
    end
    
    typesig { [] }
    # 
    # Returns the algorithm used by the issuer to sign the certificate.
    # Null is returned in the case of a partially constructed cert.
    def get_issuer_algorithm_id
      return @issuer_sig_alg
    end
    
    typesig { [] }
    # 
    # Returns the first time the certificate is valid.
    def get_not_before
      return Date.new(@notbefore.get_time)
    end
    
    typesig { [] }
    # 
    # Returns the last time the certificate is valid.
    def get_not_after
      return Date.new(@notafter.get_time)
    end
    
    typesig { [] }
    # 
    # Returns the subject's public key.  Note that some public key
    # algorithms support an optional certificate generation policy
    # where the keys in the certificates are not in themselves sufficient
    # to perform a public key operation.  Those keys need to be augmented
    # by algorithm parameters, which the certificate generation policy
    # chose not to place in the certificate.
    # 
    # <P>Two such public key algorithms are:  DSS/DSA, where algorithm
    # parameters could be acquired from a CA certificate in the chain
    # of issuers; and Diffie-Hellman, with a similar solution although
    # the CA then needs both a Diffie-Hellman certificate and a signature
    # capable certificate.
    def get_public_key
      return @pubkey
    end
    
    typesig { [] }
    # 
    # Returns the X.509 version number of this certificate, zero based.
    # That is, "2" indicates an X.509 version 3 (1993) certificate,
    # and "0" indicates X.509v1 (1988).
    # Zero is returned in the case of a partially constructed cert.
    def get_version
      return @version
    end
    
    typesig { [] }
    # 
    # Calculates a hash code value for the object.  Objects
    # which are equal will also have the same hashcode.
    def hash_code
      retval = 0
      i = 0
      while i < @signed_cert.attr_length
        retval += @signed_cert[i] * i
        ((i += 1) - 1)
      end
      return retval
    end
    
    typesig { [] }
    # 
    # Returns a printable representation of the certificate.  This does not
    # contain all the information available to distinguish this from any
    # other certificate.  The certificate must be fully constructed
    # before this function may be called; in particular, if you are
    # creating certificates you must call encodeAndSign() before calling
    # this function.
    def to_s
      s = nil
      if ((@subject).nil? || (@pubkey).nil? || (@notbefore).nil? || (@notafter).nil? || (@issuer).nil? || (@issuer_sig_alg).nil? || (@serialnum).nil?)
        raise NullPointerException.new("X.509 cert is incomplete")
      end
      s = "  X.509v" + ((@version + 1)).to_s + " certificate,\n"
      s += "  Subject is " + (@subject).to_s + "\n"
      s += "  Key:  " + (@pubkey).to_s
      s += "  Validity <" + (@notbefore).to_s + "> until <" + (@notafter).to_s + ">\n"
      s += "  Issuer is " + (@issuer).to_s + "\n"
      s += "  Issuer signature used " + (@issuer_sig_alg.to_s).to_s + "\n"
      s += "  Serial number = " + (Debug.to_hex_string(@serialnum)).to_s + "\n"
      # optional v2, v3 extras
      return "[\n" + s + "]"
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Returns a printable representation of the certificate.
    # 
    # @param detailed true iff lots of detail is requested
    def to_s(detailed)
      return to_s
    end
    
    typesig { [DerValue] }
    # 
    # 
    # Cert is a SIGNED ASN.1 macro, a three elment sequence:
    # 
    # - Data to be signed (ToBeSigned) -- the "raw" cert
    # - Signature algorithm (SigAlgId)
    # - The signature bits
    # 
    # This routine unmarshals the certificate, saving the signature
    # parts away for later verification.
    def parse(val)
      if ((@parsed).equal?(true))
        raise IOException.new("Certificate already parsed")
      end
      seq = Array.typed(DerValue).new(3) { nil }
      seq[0] = val.attr_data.get_der_value
      seq[1] = val.attr_data.get_der_value
      seq[2] = val.attr_data.get_der_value
      if (!(val.attr_data.available).equal?(0))
        raise CertParseError.new("signed overrun, bytes = " + (val.attr_data.available).to_s)
      end
      if (!(seq[0].attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CertParseError.new("signed fields invalid")
      end
      @raw_cert = seq[0].to_byte_array # XXX slow; fixme!
      @issuer_sig_alg = AlgorithmId.parse(seq[1])
      @signature = seq[2].get_bit_string
      if (!(seq[1].attr_data.available).equal?(0))
        # XXX why was this error check commented out?
        # It was originally part of the next check.
        raise CertParseError.new("algid field overrun")
      end
      if (!(seq[2].attr_data.available).equal?(0))
        raise CertParseError.new("signed fields overrun")
      end
      # 
      # Let's have fun parsing the cert itself.
      in_ = nil
      tmp = nil
      in_ = seq[0].attr_data
      # 
      # Version -- this is optional (default zero). If it's there it's
      # the first field and is specially tagged.
      # 
      # Both branches leave "tmp" holding a value for the serial
      # number that comes next.
      @version = 0
      tmp = in_.get_der_value
      if (tmp.is_constructed && tmp.is_context_specific)
        @version = tmp.attr_data.get_integer
        if (!(tmp.attr_data.available).equal?(0))
          raise IOException.new("X.509 version, bad format")
        end
        tmp = in_.get_der_value
      end
      # 
      # serial number ... an integer
      @serialnum = tmp.get_big_integer
      # 
      # algorithm type for CA's signature ... needs to match the
      # one on the envelope, and that's about it!  different IDs
      # may represent a signature attack.  In general we want to
      # inherit parameters.
      tmp = in_.get_der_value
      algid = nil
      algid = AlgorithmId.parse(tmp)
      if (!(algid == @issuer_sig_alg))
        raise CertParseError.new("CA Algorithm mismatch!")
      end
      @algid = algid
      # 
      # issuer name
      @issuer = X500Name.new(in_)
      # 
      # validity:  SEQUENCE { start date, end date }
      tmp = in_.get_der_value
      if (!(tmp.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CertParseError.new("corrupt validity field")
      end
      @notbefore = tmp.attr_data.get_utctime
      @notafter = tmp.attr_data.get_utctime
      if (!(tmp.attr_data.available).equal?(0))
        raise CertParseError.new("excess validity data")
      end
      # 
      # subject name and public key
      @subject = X500Name.new(in_)
      tmp = in_.get_der_value
      @pubkey = X509Key.parse(tmp)
      # 
      # XXX for v2 and later, a bunch of tagged options follow
      if (!(in_.available).equal?(0))
        # 
        # Until we parse V2/V3 data ... ignore it.
        # 
        # // throw new CertParseError ("excess cert data");
        # System.out.println (
        # "@end'o'cert, optional V2/V3 data unparsed:  "
        # + in.available ()
        # + " bytes"
        # );
      end
      @parsed = true
    end
    
    typesig { [] }
    # 
    # Encode only the parts that will later be signed.
    def _derencode
      raw = DerOutputStream.new
      encode(raw)
      return raw.to_byte_array
    end
    
    typesig { [DerOutputStream] }
    # 
    # Marshal the contents of a "raw" certificate into a DER sequence.
    def encode(out)
      tmp = DerOutputStream.new
      # 
      # encode serial number, issuer signing algorithm,
      # and issuer name into the data we'll return
      tmp.put_integer(@serialnum)
      @issuer_sig_alg.encode(tmp)
      @issuer.encode(tmp)
      # 
      # Validity is a two element sequence ... encode the
      # elements, then wrap them into the data we'll return
      seq = DerOutputStream.new
      seq.put_utctime(@notbefore)
      seq.put_utctime(@notafter)
      tmp.write(DerValue.attr_tag_sequence, seq)
      # 
      # Encode subject (principal) and associated key
      @subject.encode(tmp)
      tmp.write(@pubkey.get_encoded)
      # 
      # Wrap the data; encoding of the "raw" cert is now complete.
      out.write(DerValue.attr_tag_sequence, tmp)
    end
    
    typesig { [X500Signer, Array.typed(::Java::Byte)] }
    # 
    # Calculate the signature of the "raw" certificate,
    # and marshal the cert with the signature and a
    # description of the signing algorithm.
    def sign(issuer, data)
      # 
      # Encode the to-be-signed data, then the algorithm used
      # to create the signature.
      out = DerOutputStream.new
      tmp = DerOutputStream.new
      tmp.write(data)
      issuer.get_algorithm_id.encode(tmp)
      # 
      # Create and encode the signature itself.
      issuer.update(data, 0, data.attr_length)
      @signature = issuer.sign
      tmp.put_bit_string(@signature)
      # 
      # Wrap the signed data in a SEQUENCE { data, algorithm, sig }
      out.write(DerValue.attr_tag_sequence, tmp)
      return out.to_byte_array
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # 
    # Serialization write ... X.509 certificates serialize as
    # themselves, and they're parsed when they get read back.
    # (Actually they serialize as some type data from the
    # serialization subsystem, then the cert data.)
    def write_object(stream)
      encode(stream)
    end
    
    typesig { [ObjectInputStream] }
    # 
    # Serialization read ... X.509 certificates serialize as
    # themselves, and they're parsed when they get read back.
    def read_object(stream)
      decode(stream)
    end
    
    private
    alias_method :initialize__x509cert, :initialize
  end
  
end
