require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X509CertImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Cert
      include_const ::Java::Security::Cert, :Certificate
      include ::Java::Util
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Misc, :BASE64Decoder
      include ::Sun::Security::Util
      include_const ::Sun::Security::Provider, :X509Factory
    }
  end
  
  # The X509CertImpl class represents an X.509 certificate. These certificates
  # are widely used to support authentication and other functionality in
  # Internet security systems.  Common applications include Privacy Enhanced
  # Mail (PEM), Transport Layer Security (SSL), code signing for trusted
  # software distribution, and Secure Electronic Transactions (SET).  There
  # is a commercial infrastructure ready to manage large scale deployments
  # of X.509 identity certificates.
  # 
  # <P>These certificates are managed and vouched for by <em>Certificate
  # Authorities</em> (CAs).  CAs are services which create certificates by
  # placing data in the X.509 standard format and then digitally signing
  # that data.  Such signatures are quite difficult to forge.  CAs act as
  # trusted third parties, making introductions between agents who have no
  # direct knowledge of each other.  CA certificates are either signed by
  # themselves, or by some other CA such as a "root" CA.
  # 
  # <P>RFC 1422 is very informative, though it does not describe much
  # of the recent work being done with X.509 certificates.  That includes
  # a 1996 version (X.509v3) and a variety of enhancements being made to
  # facilitate an explosion of personal certificates used as "Internet
  # Drivers' Licences", or with SET for credit card transactions.
  # 
  # <P>More recent work includes the IETF PKIX Working Group efforts,
  # especially RFC2459.
  # 
  # @author Dave Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see X509CertInfo
  class X509CertImpl < X509CertImplImports.const_get :X509Certificate
    include_class_members X509CertImplImports
    overload_protected {
      include DerEncoder
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3457612960190864406 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:DOT) { "." }
      const_attr_reader  :DOT
      
      # Public attribute names.
      const_set_lazy(:NAME) { "x509" }
      const_attr_reader  :NAME
      
      const_set_lazy(:INFO) { X509CertInfo::NAME }
      const_attr_reader  :INFO
      
      const_set_lazy(:ALG_ID) { "algorithm" }
      const_attr_reader  :ALG_ID
      
      const_set_lazy(:SIGNATURE) { "signature" }
      const_attr_reader  :SIGNATURE
      
      const_set_lazy(:SIGNED_CERT) { "signed_cert" }
      const_attr_reader  :SIGNED_CERT
      
      # The following are defined for ease-of-use. These
      # are the most frequently retrieved attributes.
      # 
      # x509.info.subject.dname
      const_set_lazy(:SUBJECT_DN) { NAME + DOT + INFO + DOT + RJava.cast_to_string(X509CertInfo::SUBJECT) + DOT + RJava.cast_to_string(CertificateSubjectName::DN_NAME) }
      const_attr_reader  :SUBJECT_DN
      
      # x509.info.issuer.dname
      const_set_lazy(:ISSUER_DN) { NAME + DOT + INFO + DOT + RJava.cast_to_string(X509CertInfo::ISSUER) + DOT + RJava.cast_to_string(CertificateIssuerName::DN_NAME) }
      const_attr_reader  :ISSUER_DN
      
      # x509.info.serialNumber.number
      const_set_lazy(:SERIAL_ID) { NAME + DOT + INFO + DOT + RJava.cast_to_string(X509CertInfo::SERIAL_NUMBER) + DOT + RJava.cast_to_string(CertificateSerialNumber::NUMBER) }
      const_attr_reader  :SERIAL_ID
      
      # x509.info.key.value
      const_set_lazy(:PUBLIC_KEY) { NAME + DOT + INFO + DOT + RJava.cast_to_string(X509CertInfo::KEY) + DOT + RJava.cast_to_string(CertificateX509Key::KEY) }
      const_attr_reader  :PUBLIC_KEY
      
      # x509.info.version.value
      const_set_lazy(:VERSION) { NAME + DOT + INFO + DOT + RJava.cast_to_string(X509CertInfo::VERSION) + DOT + RJava.cast_to_string(CertificateVersion::VERSION) }
      const_attr_reader  :VERSION
      
      # x509.algorithm
      const_set_lazy(:SIG_ALG) { NAME + DOT + ALG_ID }
      const_attr_reader  :SIG_ALG
      
      # x509.signature
      const_set_lazy(:SIG) { NAME + DOT + SIGNATURE }
      const_attr_reader  :SIG
    }
    
    # when we sign and decode we set this to true
    # this is our means to make certificates immutable
    attr_accessor :read_only
    alias_method :attr_read_only, :read_only
    undef_method :read_only
    alias_method :attr_read_only=, :read_only=
    undef_method :read_only=
    
    # Certificate data, and its envelope
    attr_accessor :signed_cert
    alias_method :attr_signed_cert, :signed_cert
    undef_method :signed_cert
    alias_method :attr_signed_cert=, :signed_cert=
    undef_method :signed_cert=
    
    attr_accessor :info
    alias_method :attr_info, :info
    undef_method :info
    alias_method :attr_info=, :info=
    undef_method :info=
    
    attr_accessor :alg_id
    alias_method :attr_alg_id, :alg_id
    undef_method :alg_id
    alias_method :attr_alg_id=, :alg_id=
    undef_method :alg_id=
    
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    class_module.module_eval {
      # recognized extension OIDS
      const_set_lazy(:KEY_USAGE_OID) { "2.5.29.15" }
      const_attr_reader  :KEY_USAGE_OID
      
      const_set_lazy(:EXTENDED_KEY_USAGE_OID) { "2.5.29.37" }
      const_attr_reader  :EXTENDED_KEY_USAGE_OID
      
      const_set_lazy(:BASIC_CONSTRAINT_OID) { "2.5.29.19" }
      const_attr_reader  :BASIC_CONSTRAINT_OID
      
      const_set_lazy(:SUBJECT_ALT_NAME_OID) { "2.5.29.17" }
      const_attr_reader  :SUBJECT_ALT_NAME_OID
      
      const_set_lazy(:ISSUER_ALT_NAME_OID) { "2.5.29.18" }
      const_attr_reader  :ISSUER_ALT_NAME_OID
      
      const_set_lazy(:AUTH_INFO_ACCESS_OID) { "1.3.6.1.5.5.7.1.1" }
      const_attr_reader  :AUTH_INFO_ACCESS_OID
      
      # number of standard key usage bits.
      const_set_lazy(:NUM_STANDARD_KEY_USAGE) { 9 }
      const_attr_reader  :NUM_STANDARD_KEY_USAGE
    }
    
    # SubjectAlterntativeNames cache
    attr_accessor :subject_alternative_names
    alias_method :attr_subject_alternative_names, :subject_alternative_names
    undef_method :subject_alternative_names
    alias_method :attr_subject_alternative_names=, :subject_alternative_names=
    undef_method :subject_alternative_names=
    
    # IssuerAlternativeNames cache
    attr_accessor :issuer_alternative_names
    alias_method :attr_issuer_alternative_names, :issuer_alternative_names
    undef_method :issuer_alternative_names
    alias_method :attr_issuer_alternative_names=, :issuer_alternative_names=
    undef_method :issuer_alternative_names=
    
    # ExtendedKeyUsage cache
    attr_accessor :ext_key_usage
    alias_method :attr_ext_key_usage, :ext_key_usage
    undef_method :ext_key_usage
    alias_method :attr_ext_key_usage=, :ext_key_usage=
    undef_method :ext_key_usage=
    
    # AuthorityInformationAccess cache
    attr_accessor :auth_info_access
    alias_method :attr_auth_info_access, :auth_info_access
    undef_method :auth_info_access
    alias_method :attr_auth_info_access=, :auth_info_access=
    undef_method :auth_info_access=
    
    # PublicKey that has previously been used to verify
    # the signature of this certificate. Null if the certificate has not
    # yet been verified.
    attr_accessor :verified_public_key
    alias_method :attr_verified_public_key, :verified_public_key
    undef_method :verified_public_key
    alias_method :attr_verified_public_key=, :verified_public_key=
    undef_method :verified_public_key=
    
    # If verifiedPublicKey is not null, name of the provider used to
    # successfully verify the signature of this certificate, or the
    # empty String if no provider was explicitly specified.
    attr_accessor :verified_provider
    alias_method :attr_verified_provider, :verified_provider
    undef_method :verified_provider
    alias_method :attr_verified_provider=, :verified_provider=
    undef_method :verified_provider=
    
    # If verifiedPublicKey is not null, result of the verification using
    # verifiedPublicKey and verifiedProvider. If true, verification was
    # successful, if false, it failed.
    attr_accessor :verification_result
    alias_method :attr_verification_result, :verification_result
    undef_method :verification_result
    alias_method :attr_verification_result=, :verification_result=
    undef_method :verification_result=
    
    typesig { [] }
    # Default constructor.
    def initialize
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      @subject_alternative_names = nil
      @issuer_alternative_names = nil
      @ext_key_usage = nil
      @auth_info_access = nil
      @verified_public_key = nil
      @verified_provider = nil
      @verification_result = false
      super()
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Unmarshals a certificate from its encoded form, parsing the
    # encoded bytes.  This form of constructor is used by agents which
    # need to examine and use certificate contents.  That is, this is
    # one of the more commonly used constructors.  Note that the buffer
    # must include only a certificate, and no "garbage" may be left at
    # the end.  If you need to ignore data at the end of a certificate,
    # use another constructor.
    # 
    # @param certData the encoded bytes, with no trailing padding.
    # @exception CertificateException on parsing and initialization errors.
    def initialize(cert_data)
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      @subject_alternative_names = nil
      @issuer_alternative_names = nil
      @ext_key_usage = nil
      @auth_info_access = nil
      @verified_public_key = nil
      @verified_provider = nil
      @verification_result = false
      super()
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      begin
        parse(DerValue.new(cert_data))
      rescue IOException => e
        @signed_cert = nil
        ce = CertificateException.new("Unable to initialize, " + RJava.cast_to_string(e))
        ce.init_cause(e)
        raise ce
      end
    end
    
    typesig { [InputStream] }
    # unmarshals an X.509 certificate from an input stream.  If the
    # certificate is RFC1421 hex-encoded, then it must begin with
    # the line X509Factory.BEGIN_CERT and end with the line
    # X509Factory.END_CERT.
    # 
    # @param in an input stream holding at least one certificate that may
    # be either DER-encoded or RFC1421 hex-encoded version of the
    # DER-encoded certificate.
    # @exception CertificateException on parsing and initialization errors.
    def initialize(in_)
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      @subject_alternative_names = nil
      @issuer_alternative_names = nil
      @ext_key_usage = nil
      @auth_info_access = nil
      @verified_public_key = nil
      @verified_provider = nil
      @verification_result = false
      super()
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      der = nil
      in_buffered = BufferedInputStream.new(in_)
      # First try reading stream as HEX-encoded DER-encoded bytes,
      # since not mistakable for raw DER
      begin
        in_buffered.mark(JavaInteger::MAX_VALUE)
        der = read_rfc1421cert(in_buffered)
      rescue IOException => ioe
        begin
          # Next, try reading stream as raw DER-encoded bytes
          in_buffered.reset
          der = DerValue.new(in_buffered)
        rescue IOException => ioe1
          ce = CertificateException.new("Input stream must be " + "either DER-encoded bytes " + "or RFC1421 hex-encoded " + "DER-encoded bytes: " + RJava.cast_to_string(ioe1.get_message))
          ce.init_cause(ioe1)
          raise ce
        end
      end
      begin
        parse(der)
      rescue IOException => ioe
        @signed_cert = nil
        ce = CertificateException.new("Unable to parse DER value of " + "certificate, " + RJava.cast_to_string(ioe))
        ce.init_cause(ioe)
        raise ce
      end
    end
    
    typesig { [InputStream] }
    # read input stream as HEX-encoded DER-encoded bytes
    # 
    # @param in InputStream to read
    # @returns DerValue corresponding to decoded HEX-encoded bytes
    # @throws IOException if stream can not be interpreted as RFC1421
    # encoded bytes
    def read_rfc1421cert(in_)
      der = nil
      line = nil
      cert_buffered_reader = BufferedReader.new(InputStreamReader.new(in_, "ASCII"))
      begin
        line = RJava.cast_to_string(cert_buffered_reader.read_line)
      rescue IOException => ioe1
        raise IOException.new("Unable to read InputStream: " + RJava.cast_to_string(ioe1.get_message))
      end
      if ((line == X509Factory::BEGIN_CERT))
        # stream appears to be hex-encoded bytes
        decoder = BASE64Decoder.new
        decstream = ByteArrayOutputStream.new
        begin
          while (!((line = RJava.cast_to_string(cert_buffered_reader.read_line))).nil?)
            if ((line == X509Factory::END_CERT))
              der = DerValue.new(decstream.to_byte_array)
              break
            else
              decstream.write(decoder.decode_buffer(line))
            end
          end
        rescue IOException => ioe2
          raise IOException.new("Unable to read InputStream: " + RJava.cast_to_string(ioe2.get_message))
        end
      else
        raise IOException.new("InputStream is not RFC1421 hex-encoded " + "DER bytes")
      end
      return der
    end
    
    typesig { [X509CertInfo] }
    # Construct an initialized X509 Certificate. The certificate is stored
    # in raw form and has to be signed to be useful.
    # 
    # @params info the X509CertificateInfo which the Certificate is to be
    # created from.
    def initialize(cert_info)
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      @subject_alternative_names = nil
      @issuer_alternative_names = nil
      @ext_key_usage = nil
      @auth_info_access = nil
      @verified_public_key = nil
      @verified_provider = nil
      @verification_result = false
      super()
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      @info = cert_info
    end
    
    typesig { [DerValue] }
    # Unmarshal a certificate from its encoded form, parsing a DER value.
    # This form of constructor is used by agents which need to examine
    # and use certificate contents.
    # 
    # @param derVal the der value containing the encoded cert.
    # @exception CertificateException on parsing and initialization errors.
    def initialize(der_val)
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      @subject_alternative_names = nil
      @issuer_alternative_names = nil
      @ext_key_usage = nil
      @auth_info_access = nil
      @verified_public_key = nil
      @verified_provider = nil
      @verification_result = false
      super()
      @read_only = false
      @signed_cert = nil
      @info = nil
      @alg_id = nil
      @signature = nil
      begin
        parse(der_val)
      rescue IOException => e
        @signed_cert = nil
        ce = CertificateException.new("Unable to initialize, " + RJava.cast_to_string(e))
        ce.init_cause(e)
        raise ce
      end
    end
    
    typesig { [OutputStream] }
    # Appends the certificate to an output stream.
    # 
    # @param out an input stream to which the certificate is appended.
    # @exception CertificateEncodingException on encoding errors.
    def encode(out)
      if ((@signed_cert).nil?)
        raise CertificateEncodingException.new("Null certificate to encode")
      end
      begin
        out.write(@signed_cert.clone)
      rescue IOException => e
        raise CertificateEncodingException.new(e.to_s)
      end
    end
    
    typesig { [OutputStream] }
    # DER encode this object onto an output stream.
    # Implements the <code>DerEncoder</code> interface.
    # 
    # @param out the output stream on which to write the DER encoding.
    # 
    # @exception IOException on encoding error.
    def der_encode(out)
      if ((@signed_cert).nil?)
        raise IOException.new("Null certificate to encode")
      end
      out.write(@signed_cert.clone)
    end
    
    typesig { [] }
    # Returns the encoded form of this certificate. It is
    # assumed that each certificate type would have only a single
    # form of encoding; for example, X.509 certificates would
    # be encoded as ASN.1 DER.
    # 
    # @exception CertificateEncodingException if an encoding error occurs.
    def get_encoded
      return get_encoded_internal.clone
    end
    
    typesig { [] }
    # Returned the encoding as an uncloned byte array. Callers must
    # guarantee that they neither modify it nor expose it to untrusted
    # code.
    def get_encoded_internal
      if ((@signed_cert).nil?)
        raise CertificateEncodingException.new("Null certificate to encode")
      end
      return @signed_cert
    end
    
    typesig { [PublicKey] }
    # Throws an exception if the certificate was not signed using the
    # verification key provided.  Successfully verifying a certificate
    # does <em>not</em> indicate that one should trust the entity which
    # it represents.
    # 
    # @param key the public key used for verification.
    # 
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception NoSuchProviderException if there's no default provider.
    # @exception SignatureException on signature errors.
    # @exception CertificateException on encoding errors.
    def verify(key)
      verify(key, "")
    end
    
    typesig { [PublicKey, String] }
    # Throws an exception if the certificate was not signed using the
    # verification key provided.  Successfully verifying a certificate
    # does <em>not</em> indicate that one should trust the entity which
    # it represents.
    # 
    # @param key the public key used for verification.
    # @param sigProvider the name of the provider.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException on incorrect provider.
    # @exception SignatureException on signature errors.
    # @exception CertificateException on encoding errors.
    def verify(key, sig_provider)
      synchronized(self) do
        if ((sig_provider).nil?)
          sig_provider = ""
        end
        if ((!(@verified_public_key).nil?) && (@verified_public_key == key))
          # this certificate has already been verified using
          # this public key. Make sure providers match, too.
          if ((sig_provider == @verified_provider))
            if (@verification_result)
              return
            else
              raise SignatureException.new("Signature does not match.")
            end
          end
        end
        if ((@signed_cert).nil?)
          raise CertificateEncodingException.new("Uninitialized certificate")
        end
        # Verify the signature ...
        sig_verf = nil
        if ((sig_provider.length).equal?(0))
          sig_verf = Signature.get_instance(@alg_id.get_name)
        else
          sig_verf = Signature.get_instance(@alg_id.get_name, sig_provider)
        end
        sig_verf.init_verify(key)
        raw_cert = @info.get_encoded_info
        sig_verf.update(raw_cert, 0, raw_cert.attr_length)
        # verify may throw SignatureException for invalid encodings, etc.
        @verification_result = sig_verf.verify(@signature)
        @verified_public_key = key
        @verified_provider = sig_provider
        if ((@verification_result).equal?(false))
          raise SignatureException.new("Signature does not match.")
        end
      end
    end
    
    typesig { [PrivateKey, String] }
    # Creates an X.509 certificate, and signs it using the given key
    # (associating a signature algorithm and an X.500 name).
    # This operation is used to implement the certificate generation
    # functionality of a certificate authority.
    # 
    # @param key the private key used for signing.
    # @param algorithm the name of the signature algorithm used.
    # 
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception NoSuchProviderException if there's no default provider.
    # @exception SignatureException on signature errors.
    # @exception CertificateException on encoding errors.
    def sign(key, algorithm)
      sign(key, algorithm, nil)
    end
    
    typesig { [PrivateKey, String, String] }
    # Creates an X.509 certificate, and signs it using the given key
    # (associating a signature algorithm and an X.500 name).
    # This operation is used to implement the certificate generation
    # functionality of a certificate authority.
    # 
    # @param key the private key used for signing.
    # @param algorithm the name of the signature algorithm used.
    # @param provider the name of the provider.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException on incorrect provider.
    # @exception SignatureException on signature errors.
    # @exception CertificateException on encoding errors.
    def sign(key, algorithm, provider)
      begin
        if (@read_only)
          raise CertificateEncodingException.new("cannot over-write existing certificate")
        end
        sig_engine = nil
        if (((provider).nil?) || ((provider.length).equal?(0)))
          sig_engine = Signature.get_instance(algorithm)
        else
          sig_engine = Signature.get_instance(algorithm, provider)
        end
        sig_engine.init_sign(key)
        # in case the name is reset
        @alg_id = AlgorithmId.get(sig_engine.get_algorithm)
        out = DerOutputStream.new
        tmp = DerOutputStream.new
        # encode certificate info
        @info.encode(tmp)
        raw_cert = tmp.to_byte_array
        # encode algorithm identifier
        @alg_id.encode(tmp)
        # Create and encode the signature itself.
        sig_engine.update(raw_cert, 0, raw_cert.attr_length)
        @signature = sig_engine.sign
        tmp.put_bit_string(@signature)
        # Wrap the signed data in a SEQUENCE { data, algorithm, sig }
        out.write(DerValue.attr_tag_sequence, tmp)
        @signed_cert = out.to_byte_array
        @read_only = true
      rescue IOException => e
        raise CertificateEncodingException.new(e.to_s)
      end
    end
    
    typesig { [] }
    # Checks that the certificate is currently valid, i.e. the current
    # time is within the specified validity period.
    # 
    # @exception CertificateExpiredException if the certificate has expired.
    # @exception CertificateNotYetValidException if the certificate is not
    # yet valid.
    def check_validity
      date = JavaDate.new
      check_validity(date)
    end
    
    typesig { [JavaDate] }
    # Checks that the specified date is within the certificate's
    # validity period, or basically if the certificate would be
    # valid at the specified date/time.
    # 
    # @param date the Date to check against to see if this certificate
    # is valid at that date/time.
    # 
    # @exception CertificateExpiredException if the certificate has expired
    # with respect to the <code>date</code> supplied.
    # @exception CertificateNotYetValidException if the certificate is not
    # yet valid with respect to the <code>date</code> supplied.
    def check_validity(date)
      interval = nil
      begin
        interval = @info.get(CertificateValidity::NAME)
      rescue JavaException => e
        raise CertificateNotYetValidException.new("Incorrect validity period")
      end
      if ((interval).nil?)
        raise CertificateNotYetValidException.new("Null validity period")
      end
      interval.valid(date)
    end
    
    typesig { [String] }
    # Return the requested attribute from the certificate.
    # 
    # Note that the X509CertInfo is not cloned for performance reasons.
    # Callers must ensure that they do not modify it. All other
    # attributes are cloned.
    # 
    # @param name the name of the attribute.
    # @exception CertificateParsingException on invalid attribute identifier.
    def get(name)
      attr = X509AttributeName.new(name)
      id = attr.get_prefix
      if (!(id.equals_ignore_case(NAME)))
        raise CertificateParsingException.new("Invalid root of " + "attribute name, expected [" + NAME + "], received " + "[" + id + "]")
      end
      attr = X509AttributeName.new(attr.get_suffix)
      id = RJava.cast_to_string(attr.get_prefix)
      if (id.equals_ignore_case(INFO))
        if ((@info).nil?)
          return nil
        end
        if (!(attr.get_suffix).nil?)
          begin
            return @info.get(attr.get_suffix)
          rescue IOException => e
            raise CertificateParsingException.new(e.to_s)
          rescue CertificateException => e
            raise CertificateParsingException.new(e.to_s)
          end
        else
          return @info
        end
      else
        if (id.equals_ignore_case(ALG_ID))
          return (@alg_id)
        else
          if (id.equals_ignore_case(SIGNATURE))
            if (!(@signature).nil?)
              return @signature.clone
            else
              return nil
            end
          else
            if (id.equals_ignore_case(SIGNED_CERT))
              if (!(@signed_cert).nil?)
                return @signed_cert.clone
              else
                return nil
              end
            else
              raise CertificateParsingException.new("Attribute name not " + "recognized or get() not allowed for the same: " + id)
            end
          end
        end
      end
    end
    
    typesig { [String, Object] }
    # Set the requested attribute in the certificate.
    # 
    # @param name the name of the attribute.
    # @param obj the value of the attribute.
    # @exception CertificateException on invalid attribute identifier.
    # @exception IOException on encoding error of attribute.
    def set(name, obj)
      # check if immutable
      if (@read_only)
        raise CertificateException.new("cannot over-write existing" + " certificate")
      end
      attr = X509AttributeName.new(name)
      id = attr.get_prefix
      if (!(id.equals_ignore_case(NAME)))
        raise CertificateException.new("Invalid root of attribute name," + " expected [" + NAME + "], received " + id)
      end
      attr = X509AttributeName.new(attr.get_suffix)
      id = RJava.cast_to_string(attr.get_prefix)
      if (id.equals_ignore_case(INFO))
        if ((attr.get_suffix).nil?)
          if (!(obj.is_a?(X509CertInfo)))
            raise CertificateException.new("Attribute value should" + " be of type X509CertInfo.")
          end
          @info = obj
          @signed_cert = nil # reset this as certificate data has changed
        else
          @info.set(attr.get_suffix, obj)
          @signed_cert = nil # reset this as certificate data has changed
        end
      else
        raise CertificateException.new("Attribute name not recognized or " + "set() not allowed for the same: " + id)
      end
    end
    
    typesig { [String] }
    # Delete the requested attribute from the certificate.
    # 
    # @param name the name of the attribute.
    # @exception CertificateException on invalid attribute identifier.
    # @exception IOException on other errors.
    def delete(name)
      # check if immutable
      if (@read_only)
        raise CertificateException.new("cannot over-write existing" + " certificate")
      end
      attr = X509AttributeName.new(name)
      id = attr.get_prefix
      if (!(id.equals_ignore_case(NAME)))
        raise CertificateException.new("Invalid root of attribute name," + " expected [" + NAME + "], received " + id)
      end
      attr = X509AttributeName.new(attr.get_suffix)
      id = RJava.cast_to_string(attr.get_prefix)
      if (id.equals_ignore_case(INFO))
        if (!(attr.get_suffix).nil?)
          @info = nil
        else
          @info.delete(attr.get_suffix)
        end
      else
        if (id.equals_ignore_case(ALG_ID))
          @alg_id = nil
        else
          if (id.equals_ignore_case(SIGNATURE))
            @signature = nil
          else
            if (id.equals_ignore_case(SIGNED_CERT))
              @signed_cert = nil
            else
              raise CertificateException.new("Attribute name not recognized or " + "delete() not allowed for the same: " + id)
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(NAME + DOT + INFO)
      elements.add_element(NAME + DOT + ALG_ID)
      elements.add_element(NAME + DOT + SIGNATURE)
      elements.add_element(NAME + DOT + SIGNED_CERT)
      return elements.elements
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    typesig { [] }
    # Returns a printable representation of the certificate.  This does not
    # contain all the information available to distinguish this from any
    # other certificate.  The certificate must be fully constructed
    # before this function may be called.
    def to_s
      if ((@info).nil? || (@alg_id).nil? || (@signature).nil?)
        return ""
      end
      sb = StringBuilder.new
      sb.append("[\n")
      sb.append(RJava.cast_to_string(@info.to_s) + "\n")
      sb.append("  Algorithm: [" + RJava.cast_to_string(@alg_id.to_s) + "]\n")
      encoder = HexDumpEncoder.new
      sb.append("  Signature:\n" + RJava.cast_to_string(encoder.encode_buffer(@signature)))
      sb.append("\n]")
      return sb.to_s
    end
    
    typesig { [] }
    # the strongly typed gets, as per java.security.cert.X509Certificate
    # 
    # Gets the publickey from this certificate.
    # 
    # @return the publickey.
    def get_public_key
      if ((@info).nil?)
        return nil
      end
      begin
        key = @info.get(RJava.cast_to_string(CertificateX509Key::NAME) + DOT + RJava.cast_to_string(CertificateX509Key::KEY))
        return key
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the version number from the certificate.
    # 
    # @return the version number, i.e. 1, 2 or 3.
    def get_version
      if ((@info).nil?)
        return -1
      end
      begin
        vers = (@info.get(RJava.cast_to_string(CertificateVersion::NAME) + DOT + RJava.cast_to_string(CertificateVersion::VERSION))).int_value
        return vers + 1
      rescue JavaException => e
        return -1
      end
    end
    
    typesig { [] }
    # Gets the serial number from the certificate.
    # 
    # @return the serial number.
    def get_serial_number
      ser = get_serial_number_object
      return !(ser).nil? ? ser.get_number : nil
    end
    
    typesig { [] }
    # Gets the serial number from the certificate as
    # a SerialNumber object.
    # 
    # @return the serial number.
    def get_serial_number_object
      if ((@info).nil?)
        return nil
      end
      begin
        ser = @info.get(RJava.cast_to_string(CertificateSerialNumber::NAME) + DOT + RJava.cast_to_string(CertificateSerialNumber::NUMBER))
        return ser
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the subject distinguished name from the certificate.
    # 
    # @return the subject name.
    def get_subject_dn
      if ((@info).nil?)
        return nil
      end
      begin
        subject = @info.get(RJava.cast_to_string(CertificateSubjectName::NAME) + DOT + RJava.cast_to_string(CertificateSubjectName::DN_NAME))
        return subject
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Get subject name as X500Principal. Overrides implementation in
    # X509Certificate with a slightly more efficient version that is
    # also aware of X509CertImpl mutability.
    def get_subject_x500principal
      if ((@info).nil?)
        return nil
      end
      begin
        subject = @info.get(RJava.cast_to_string(CertificateSubjectName::NAME) + DOT + RJava.cast_to_string(CertificateSubjectName::DN_PRINCIPAL))
        return subject
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the issuer distinguished name from the certificate.
    # 
    # @return the issuer name.
    def get_issuer_dn
      if ((@info).nil?)
        return nil
      end
      begin
        issuer = @info.get(RJava.cast_to_string(CertificateIssuerName::NAME) + DOT + RJava.cast_to_string(CertificateIssuerName::DN_NAME))
        return issuer
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Get issuer name as X500Principal. Overrides implementation in
    # X509Certificate with a slightly more efficient version that is
    # also aware of X509CertImpl mutability.
    def get_issuer_x500principal
      if ((@info).nil?)
        return nil
      end
      begin
        issuer = @info.get(RJava.cast_to_string(CertificateIssuerName::NAME) + DOT + RJava.cast_to_string(CertificateIssuerName::DN_PRINCIPAL))
        return issuer
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the notBefore date from the validity period of the certificate.
    # 
    # @return the start date of the validity period.
    def get_not_before
      if ((@info).nil?)
        return nil
      end
      begin
        d = @info.get(RJava.cast_to_string(CertificateValidity::NAME) + DOT + RJava.cast_to_string(CertificateValidity::NOT_BEFORE))
        return d
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the notAfter date from the validity period of the certificate.
    # 
    # @return the end date of the validity period.
    def get_not_after
      if ((@info).nil?)
        return nil
      end
      begin
        d = @info.get(RJava.cast_to_string(CertificateValidity::NAME) + DOT + RJava.cast_to_string(CertificateValidity::NOT_AFTER))
        return d
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the DER encoded certificate informations, the
    # <code>tbsCertificate</code> from this certificate.
    # This can be used to verify the signature independently.
    # 
    # @return the DER encoded certificate information.
    # @exception CertificateEncodingException if an encoding error occurs.
    def get_tbscertificate
      if (!(@info).nil?)
        return @info.get_encoded_info
      else
        raise CertificateEncodingException.new("Uninitialized certificate")
      end
    end
    
    typesig { [] }
    # Gets the raw Signature bits from the certificate.
    # 
    # @return the signature.
    def get_signature
      if ((@signature).nil?)
        return nil
      end
      dup = Array.typed(::Java::Byte).new(@signature.attr_length) { 0 }
      System.arraycopy(@signature, 0, dup, 0, dup.attr_length)
      return dup
    end
    
    typesig { [] }
    # Gets the signature algorithm name for the certificate
    # signature algorithm.
    # For example, the string "SHA-1/DSA" or "DSS".
    # 
    # @return the signature algorithm name.
    def get_sig_alg_name
      if ((@alg_id).nil?)
        return nil
      end
      return (@alg_id.get_name)
    end
    
    typesig { [] }
    # Gets the signature algorithm OID string from the certificate.
    # For example, the string "1.2.840.10040.4.3"
    # 
    # @return the signature algorithm oid string.
    def get_sig_alg_oid
      if ((@alg_id).nil?)
        return nil
      end
      oid = @alg_id.get_oid
      return (oid.to_s)
    end
    
    typesig { [] }
    # Gets the DER encoded signature algorithm parameters from this
    # certificate's signature algorithm.
    # 
    # @return the DER encoded signature algorithm parameters, or
    # null if no parameters are present.
    def get_sig_alg_params
      if ((@alg_id).nil?)
        return nil
      end
      begin
        return @alg_id.get_encoded_params
      rescue IOException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the Issuer Unique Identity from the certificate.
    # 
    # @return the Issuer Unique Identity.
    def get_issuer_unique_id
      if ((@info).nil?)
        return nil
      end
      begin
        id = @info.get(RJava.cast_to_string(CertificateIssuerUniqueIdentity::NAME) + DOT + RJava.cast_to_string(CertificateIssuerUniqueIdentity::ID))
        if ((id).nil?)
          return nil
        else
          return (id.get_id)
        end
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets the Subject Unique Identity from the certificate.
    # 
    # @return the Subject Unique Identity.
    def get_subject_unique_id
      if ((@info).nil?)
        return nil
      end
      begin
        id = @info.get(RJava.cast_to_string(CertificateSubjectUniqueIdentity::NAME) + DOT + RJava.cast_to_string(CertificateSubjectUniqueIdentity::ID))
        if ((id).nil?)
          return nil
        else
          return (id.get_id)
        end
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Get AuthorityKeyIdentifier extension
    # @return AuthorityKeyIdentifier object or null (if no such object
    # in certificate)
    def get_authority_key_identifier_extension
      return get_extension(PKIXExtensions::AuthorityKey_Id)
    end
    
    typesig { [] }
    # Get BasicConstraints extension
    # @return BasicConstraints object or null (if no such object in
    # certificate)
    def get_basic_constraints_extension
      return get_extension(PKIXExtensions::BasicConstraints_Id)
    end
    
    typesig { [] }
    # Get CertificatePoliciesExtension
    # @return CertificatePoliciesExtension or null (if no such object in
    # certificate)
    def get_certificate_policies_extension
      return get_extension(PKIXExtensions::CertificatePolicies_Id)
    end
    
    typesig { [] }
    # Get ExtendedKeyUsage extension
    # @return ExtendedKeyUsage extension object or null (if no such object
    # in certificate)
    def get_extended_key_usage_extension
      return get_extension(PKIXExtensions::ExtendedKeyUsage_Id)
    end
    
    typesig { [] }
    # Get IssuerAlternativeName extension
    # @return IssuerAlternativeName object or null (if no such object in
    # certificate)
    def get_issuer_alternative_name_extension
      return get_extension(PKIXExtensions::IssuerAlternativeName_Id)
    end
    
    typesig { [] }
    # Get NameConstraints extension
    # @return NameConstraints object or null (if no such object in certificate)
    def get_name_constraints_extension
      return get_extension(PKIXExtensions::NameConstraints_Id)
    end
    
    typesig { [] }
    # Get PolicyConstraints extension
    # @return PolicyConstraints object or null (if no such object in
    # certificate)
    def get_policy_constraints_extension
      return get_extension(PKIXExtensions::PolicyConstraints_Id)
    end
    
    typesig { [] }
    # Get PolicyMappingsExtension extension
    # @return PolicyMappingsExtension object or null (if no such object
    # in certificate)
    def get_policy_mappings_extension
      return get_extension(PKIXExtensions::PolicyMappings_Id)
    end
    
    typesig { [] }
    # Get PrivateKeyUsage extension
    # @return PrivateKeyUsage object or null (if no such object in certificate)
    def get_private_key_usage_extension
      return get_extension(PKIXExtensions::PrivateKeyUsage_Id)
    end
    
    typesig { [] }
    # Get SubjectAlternativeName extension
    # @return SubjectAlternativeName object or null (if no such object in
    # certificate)
    def get_subject_alternative_name_extension
      return get_extension(PKIXExtensions::SubjectAlternativeName_Id)
    end
    
    typesig { [] }
    # Get SubjectKeyIdentifier extension
    # @return SubjectKeyIdentifier object or null (if no such object in
    # certificate)
    def get_subject_key_identifier_extension
      return get_extension(PKIXExtensions::SubjectKey_Id)
    end
    
    typesig { [] }
    # Get CRLDistributionPoints extension
    # @return CRLDistributionPoints object or null (if no such object in
    # certificate)
    def get_crldistribution_points_extension
      return get_extension(PKIXExtensions::CRLDistributionPoints_Id)
    end
    
    typesig { [] }
    # Return true if a critical extension is found that is
    # not supported, otherwise return false.
    def has_unsupported_critical_extension
      if ((@info).nil?)
        return false
      end
      begin
        exts = @info.get(CertificateExtensions::NAME)
        if ((exts).nil?)
          return false
        end
        return exts.has_unsupported_critical_extension
      rescue JavaException => e
        return false
      end
    end
    
    typesig { [] }
    # Gets a Set of the extension(s) marked CRITICAL in the
    # certificate. In the returned set, each extension is
    # represented by its OID string.
    # 
    # @return a set of the extension oid strings in the
    # certificate that are marked critical.
    def get_critical_extension_oids
      if ((@info).nil?)
        return nil
      end
      begin
        exts = @info.get(CertificateExtensions::NAME)
        if ((exts).nil?)
          return nil
        end
        ext_set = HashSet.new
        exts.get_all_extensions.each do |ex|
          if (ex.is_critical)
            ext_set.add(ex.get_extension_id.to_s)
          end
        end
        return ext_set
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Gets a Set of the extension(s) marked NON-CRITICAL in the
    # certificate. In the returned set, each extension is
    # represented by its OID string.
    # 
    # @return a set of the extension oid strings in the
    # certificate that are NOT marked critical.
    def get_non_critical_extension_oids
      if ((@info).nil?)
        return nil
      end
      begin
        exts = @info.get(CertificateExtensions::NAME)
        if ((exts).nil?)
          return nil
        end
        ext_set = HashSet.new
        exts.get_all_extensions.each do |ex|
          if (!ex.is_critical)
            ext_set.add(ex.get_extension_id.to_s)
          end
        end
        ext_set.add_all(exts.get_unparseable_extensions.key_set)
        return ext_set
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [ObjectIdentifier] }
    # Gets the extension identified by the given ObjectIdentifier
    # 
    # @param oid the Object Identifier value for the extension.
    # @return Extension or null if certificate does not contain this
    # extension
    def get_extension(oid)
      if ((@info).nil?)
        return nil
      end
      begin
        extensions = nil
        begin
          extensions = @info.get(CertificateExtensions::NAME)
        rescue CertificateException => ce
          return nil
        end
        if ((extensions).nil?)
          return nil
        else
          extensions.get_all_extensions.each do |ex|
            if ((ex.get_extension_id == oid))
              # XXXX May want to consider cloning this
              return ex
            end
          end
          # no such extension in this certificate
          return nil
        end
      rescue IOException => ioe
        return nil
      end
    end
    
    typesig { [ObjectIdentifier] }
    def get_unparseable_extension(oid)
      if ((@info).nil?)
        return nil
      end
      begin
        extensions = nil
        begin
          extensions = @info.get(CertificateExtensions::NAME)
        rescue CertificateException => ce
          return nil
        end
        if ((extensions).nil?)
          return nil
        else
          return extensions.get_unparseable_extensions.get(oid.to_s)
        end
      rescue IOException => ioe
        return nil
      end
    end
    
    typesig { [String] }
    # Gets the DER encoded extension identified by the given
    # oid String.
    # 
    # @param oid the Object Identifier value for the extension.
    def get_extension_value(oid)
      begin
        find_oid = ObjectIdentifier.new(oid)
        ext_alias = OIDMap.get_name(find_oid)
        cert_ext = nil
        exts = @info.get(CertificateExtensions::NAME)
        if ((ext_alias).nil?)
          # may be unknown
          # get the extensions, search thru' for this oid
          if ((exts).nil?)
            return nil
          end
          exts.get_all_extensions.each do |ex|
            in_cert_oid = ex.get_extension_id
            if ((in_cert_oid == find_oid))
              cert_ext = ex
              break
            end
          end
        else
          # there's sub-class that can handle this extension
          begin
            cert_ext = self.get(ext_alias)
          rescue CertificateException => e
            # get() throws an Exception instead of returning null, ignore
          end
        end
        if ((cert_ext).nil?)
          if (!(exts).nil?)
            cert_ext = exts.get_unparseable_extensions.get(oid)
          end
          if ((cert_ext).nil?)
            return nil
          end
        end
        ext_data = cert_ext.get_extension_value
        if ((ext_data).nil?)
          return nil
        end
        out = DerOutputStream.new
        out.put_octet_string(ext_data)
        return out.to_byte_array
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # Get a boolean array representing the bits of the KeyUsage extension,
    # (oid = 2.5.29.15).
    # @return the bit values of this extension as an array of booleans.
    def get_key_usage
      begin
        ext_alias = OIDMap.get_name(PKIXExtensions::KeyUsage_Id)
        if ((ext_alias).nil?)
          return nil
        end
        cert_ext = self.get(ext_alias)
        if ((cert_ext).nil?)
          return nil
        end
        ret = cert_ext.get_bits
        if (ret.attr_length < NUM_STANDARD_KEY_USAGE)
          usage_bits = Array.typed(::Java::Boolean).new(NUM_STANDARD_KEY_USAGE) { false }
          System.arraycopy(ret, 0, usage_bits, 0, ret.attr_length)
          ret = usage_bits
        end
        return ret
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [] }
    # This method are the overridden implementation of
    # getExtendedKeyUsage method in X509Certificate in the Sun
    # provider. It is better performance-wise since it returns cached
    # values.
    def get_extended_key_usage
      synchronized(self) do
        if (@read_only && !(@ext_key_usage).nil?)
          return @ext_key_usage
        else
          ext = get_extended_key_usage_extension
          if ((ext).nil?)
            return nil
          end
          @ext_key_usage = Collections.unmodifiable_list(ext.get_extended_key_usage)
          return @ext_key_usage
        end
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate] }
      # This static method is the default implementation of the
      # getExtendedKeyUsage method in X509Certificate. A
      # X509Certificate provider generally should overwrite this to
      # provide among other things caching for better performance.
      def get_extended_key_usage(cert)
        begin
          ext = cert.get_extension_value(EXTENDED_KEY_USAGE_OID)
          if ((ext).nil?)
            return nil
          end
          val = DerValue.new(ext)
          data = val.get_octet_string
          eku_ext = ExtendedKeyUsageExtension.new(Boolean::FALSE, data)
          return Collections.unmodifiable_list(eku_ext.get_extended_key_usage)
        rescue IOException => ioe
          cpe = CertificateParsingException.new
          cpe.init_cause(ioe)
          raise cpe
        end
      end
    }
    
    typesig { [] }
    # Get the certificate constraints path length from the
    # the critical BasicConstraints extension, (oid = 2.5.29.19).
    # @return the length of the constraint.
    def get_basic_constraints
      begin
        ext_alias = OIDMap.get_name(PKIXExtensions::BasicConstraints_Id)
        if ((ext_alias).nil?)
          return -1
        end
        cert_ext = self.get(ext_alias)
        if ((cert_ext).nil?)
          return -1
        end
        if (((cert_ext.get(BasicConstraintsExtension::IS_CA)).boolean_value).equal?(true))
          return (cert_ext.get(BasicConstraintsExtension::PATH_LEN)).int_value
        else
          return -1
        end
      rescue JavaException => e
        return -1
      end
    end
    
    class_module.module_eval {
      typesig { [GeneralNames] }
      # Converts a GeneralNames structure into an immutable Collection of
      # alternative names (subject or issuer) in the form required by
      # {@link #getSubjectAlternativeNames} or
      # {@link #getIssuerAlternativeNames}.
      # 
      # @param names the GeneralNames to be converted
      # @return an immutable Collection of alternative names
      def make_alt_names(names)
        if (names.is_empty)
          return Collections.empty_set
        end
        new_names = HashSet.new
        names.names.each do |gname|
          name = gname.get_name
          name_entry = ArrayList.new(2)
          name_entry.add(JavaInteger.value_of(name.get_type))
          case (name.get_type)
          when GeneralNameInterface::NAME_RFC822
            name_entry.add((name).get_name)
          when GeneralNameInterface::NAME_DNS
            name_entry.add((name).get_name)
          when GeneralNameInterface::NAME_DIRECTORY
            name_entry.add((name).get_rfc2253name)
          when GeneralNameInterface::NAME_URI
            name_entry.add((name).get_name)
          when GeneralNameInterface::NAME_IP
            begin
              name_entry.add((name).get_name)
            rescue IOException => ioe
              # IPAddressName in cert is bogus
              raise RuntimeException.new("IPAddress cannot be parsed", ioe)
            end
          when GeneralNameInterface::NAME_OID
            name_entry.add((name).get_oid.to_s)
          else
            # add DER encoded form
            der_out = DerOutputStream.new
            begin
              name.encode(der_out)
            rescue IOException => ioe
              # should not occur since name has already been decoded
              # from cert (this would indicate a bug in our code)
              raise RuntimeException.new("name cannot be encoded", ioe)
            end
            name_entry.add(der_out.to_byte_array)
          end
          new_names.add(Collections.unmodifiable_list(name_entry))
        end
        return Collections.unmodifiable_collection(new_names)
      end
      
      typesig { [Collection] }
      # Checks a Collection of altNames and clones any name entries of type
      # byte [].
      # 
      # only partially generified due to javac bug
      def clone_alt_names(alt_names)
        must_clone = false
        alt_names.each do |nameEntry|
          if (name_entry.get(1).is_a?(Array.typed(::Java::Byte)))
            # must clone names
            must_clone = true
          end
        end
        if (must_clone)
          names_copy = HashSet.new
          alt_names.each do |nameEntry|
            name_object = name_entry.get(1)
            if (name_object.is_a?(Array.typed(::Java::Byte)))
              name_entry_copy = ArrayList.new(name_entry)
              name_entry_copy.set(1, (name_object).clone)
              names_copy.add(Collections.unmodifiable_list(name_entry_copy))
            else
              names_copy.add(name_entry)
            end
          end
          return Collections.unmodifiable_collection(names_copy)
        else
          return alt_names
        end
      end
    }
    
    typesig { [] }
    # This method are the overridden implementation of
    # getSubjectAlternativeNames method in X509Certificate in the Sun
    # provider. It is better performance-wise since it returns cached
    # values.
    def get_subject_alternative_names
      synchronized(self) do
        # return cached value if we can
        if (@read_only && !(@subject_alternative_names).nil?)
          return clone_alt_names(@subject_alternative_names)
        end
        subject_alt_name_ext = get_subject_alternative_name_extension
        if ((subject_alt_name_ext).nil?)
          return nil
        end
        names_ = nil
        begin
          names_ = subject_alt_name_ext.get(SubjectAlternativeNameExtension::SUBJECT_NAME)
        rescue IOException => ioe
          # should not occur
          return Collections.empty_set
        end
        @subject_alternative_names = make_alt_names(names_)
        return @subject_alternative_names
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate] }
      # This static method is the default implementation of the
      # getSubjectAlternaitveNames method in X509Certificate. A
      # X509Certificate provider generally should overwrite this to
      # provide among other things caching for better performance.
      def get_subject_alternative_names(cert)
        begin
          ext = cert.get_extension_value(SUBJECT_ALT_NAME_OID)
          if ((ext).nil?)
            return nil
          end
          val = DerValue.new(ext)
          data = val.get_octet_string
          subject_alt_name_ext = SubjectAlternativeNameExtension.new(Boolean::FALSE, data)
          names_ = nil
          begin
            names_ = subject_alt_name_ext.get(SubjectAlternativeNameExtension::SUBJECT_NAME)
          rescue IOException => ioe
            # should not occur
            return Collections.empty_set
          end
          return make_alt_names(names_)
        rescue IOException => ioe
          cpe = CertificateParsingException.new
          cpe.init_cause(ioe)
          raise cpe
        end
      end
    }
    
    typesig { [] }
    # This method are the overridden implementation of
    # getIssuerAlternativeNames method in X509Certificate in the Sun
    # provider. It is better performance-wise since it returns cached
    # values.
    def get_issuer_alternative_names
      synchronized(self) do
        # return cached value if we can
        if (@read_only && !(@issuer_alternative_names).nil?)
          return clone_alt_names(@issuer_alternative_names)
        end
        issuer_alt_name_ext = get_issuer_alternative_name_extension
        if ((issuer_alt_name_ext).nil?)
          return nil
        end
        names_ = nil
        begin
          names_ = issuer_alt_name_ext.get(IssuerAlternativeNameExtension::ISSUER_NAME)
        rescue IOException => ioe
          # should not occur
          return Collections.empty_set
        end
        @issuer_alternative_names = make_alt_names(names_)
        return @issuer_alternative_names
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate] }
      # This static method is the default implementation of the
      # getIssuerAlternaitveNames method in X509Certificate. A
      # X509Certificate provider generally should overwrite this to
      # provide among other things caching for better performance.
      def get_issuer_alternative_names(cert)
        begin
          ext = cert.get_extension_value(ISSUER_ALT_NAME_OID)
          if ((ext).nil?)
            return nil
          end
          val = DerValue.new(ext)
          data = val.get_octet_string
          issuer_alt_name_ext = IssuerAlternativeNameExtension.new(Boolean::FALSE, data)
          names_ = nil
          begin
            names_ = issuer_alt_name_ext.get(IssuerAlternativeNameExtension::ISSUER_NAME)
          rescue IOException => ioe
            # should not occur
            return Collections.empty_set
          end
          return make_alt_names(names_)
        rescue IOException => ioe
          cpe = CertificateParsingException.new
          cpe.init_cause(ioe)
          raise cpe
        end
      end
    }
    
    typesig { [] }
    def get_authority_info_access_extension
      return get_extension(PKIXExtensions::AuthInfoAccess_Id)
    end
    
    typesig { [DerValue] }
    # Cert is a SIGNED ASN.1 macro, a three elment sequence:
    # 
    # - Data to be signed (ToBeSigned) -- the "raw" cert
    # - Signature algorithm (SigAlgId)
    # - The signature bits
    # 
    # This routine unmarshals the certificate, saving the signature
    # parts away for later verification.
    def parse(val)
      # check if can over write the certificate
      if (@read_only)
        raise CertificateParsingException.new("cannot over-write existing certificate")
      end
      if ((val.attr_data).nil? || !(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CertificateParsingException.new("invalid DER-encoded certificate data")
      end
      @signed_cert = val.to_byte_array
      seq = Array.typed(DerValue).new(3) { nil }
      seq[0] = val.attr_data.get_der_value
      seq[1] = val.attr_data.get_der_value
      seq[2] = val.attr_data.get_der_value
      if (!(val.attr_data.available).equal?(0))
        raise CertificateParsingException.new("signed overrun, bytes = " + RJava.cast_to_string(val.attr_data.available))
      end
      if (!(seq[0].attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CertificateParsingException.new("signed fields invalid")
      end
      @alg_id = AlgorithmId.parse(seq[1])
      @signature = seq[2].get_bit_string
      if (!(seq[1].attr_data.available).equal?(0))
        raise CertificateParsingException.new("algid field overrun")
      end
      if (!(seq[2].attr_data.available).equal?(0))
        raise CertificateParsingException.new("signed fields overrun")
      end
      # The CertificateInfo
      @info = X509CertInfo.new(seq[0])
      # the "inner" and "outer" signature algorithms must match
      info_sig_alg = @info.get(RJava.cast_to_string(CertificateAlgorithmId::NAME) + DOT + RJava.cast_to_string(CertificateAlgorithmId::ALGORITHM))
      if (!(@alg_id == info_sig_alg))
        raise CertificateException.new("Signature algorithm mismatch")
      end
      @read_only = true
    end
    
    class_module.module_eval {
      typesig { [X509Certificate, ::Java::Boolean] }
      # Extract the subject or issuer X500Principal from an X509Certificate.
      # Parses the encoded form of the cert to preserve the principal's
      # ASN.1 encoding.
      def get_x500principal(cert, get_issuer)
        encoded = cert.get_encoded
        der_in = DerInputStream.new(encoded)
        tbs_cert = der_in.get_sequence(3)[0]
        tbs_in = tbs_cert.attr_data
        tmp = nil
        tmp = tbs_in.get_der_value
        # skip version number if present
        if (tmp.is_context_specific(0))
          tmp = tbs_in.get_der_value
        end
        # tmp always contains serial number now
        tmp = tbs_in.get_der_value # skip signature
        tmp = tbs_in.get_der_value # issuer
        if ((get_issuer).equal?(false))
          tmp = tbs_in.get_der_value # skip validity
          tmp = tbs_in.get_der_value # subject
        end
        principal_bytes = tmp.to_byte_array
        return X500Principal.new(principal_bytes)
      end
      
      typesig { [X509Certificate] }
      # Extract the subject X500Principal from an X509Certificate.
      # Called from java.security.cert.X509Certificate.getSubjectX500Principal().
      def get_subject_x500principal(cert)
        begin
          return get_x500principal(cert, false)
        rescue JavaException => e
          raise RuntimeException.new("Could not parse subject", e)
        end
      end
      
      typesig { [X509Certificate] }
      # Extract the issuer X500Principal from an X509Certificate.
      # Called from java.security.cert.X509Certificate.getIssuerX500Principal().
      def get_issuer_x500principal(cert)
        begin
          return get_x500principal(cert, true)
        rescue JavaException => e
          raise RuntimeException.new("Could not parse issuer", e)
        end
      end
      
      typesig { [Certificate] }
      # Returned the encoding of the given certificate for internal use.
      # Callers must guarantee that they neither modify it nor expose it
      # to untrusted code. Uses getEncodedInternal() if the certificate
      # is instance of X509CertImpl, getEncoded() otherwise.
      def get_encoded_internal(cert)
        if (cert.is_a?(X509CertImpl))
          return (cert).get_encoded_internal
        else
          return cert.get_encoded
        end
      end
      
      typesig { [X509Certificate] }
      # Utility method to convert an arbitrary instance of X509Certificate
      # to a X509CertImpl. Does a cast if possible, otherwise reparses
      # the encoding.
      def to_impl(cert)
        if (cert.is_a?(X509CertImpl))
          return cert
        else
          return X509Factory.intern(cert)
        end
      end
      
      typesig { [X509Certificate] }
      # Utility method to test if a certificate is self-issued. This is
      # the case iff the subject and issuer X500Principals are equal.
      def is_self_issued(cert)
        subject = cert.get_subject_x500principal
        issuer = cert.get_issuer_x500principal
        return (subject == issuer)
      end
      
      typesig { [X509Certificate, String] }
      # Utility method to test if a certificate is self-signed. This is
      # the case iff the subject and issuer X500Principals are equal
      # AND the certificate's subject public key can be used to verify
      # the certificate. In case of exception, returns false.
      def is_self_signed(cert, sig_provider)
        if (is_self_issued(cert))
          begin
            if ((sig_provider).nil?)
              cert.verify(cert.get_public_key)
            else
              cert.verify(cert.get_public_key, sig_provider)
            end
            return true
          rescue JavaException => e
            # In case of exception, return false
          end
        end
        return false
      end
    }
    
    private
    alias_method :initialize__x509cert_impl, :initialize
  end
  
end
