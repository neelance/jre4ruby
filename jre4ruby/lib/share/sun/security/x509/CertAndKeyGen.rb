require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertAndKeyGenImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateEncodingException
      include ::Java::Security
      include_const ::Java::Util, :JavaDate
      include_const ::Sun::Security::Pkcs, :PKCS10
    }
  end
  
  # Generate a pair of keys, and provide access to them.  This class is
  # provided primarily for ease of use.
  # 
  # <P>This provides some simple certificate management functionality.
  # Specifically, it allows you to create self-signed X.509 certificates
  # as well as PKCS 10 based certificate signing requests.
  # 
  # <P>Keys for some public key signature algorithms have algorithm
  # parameters, such as DSS/DSA.  Some sites' Certificate Authorities
  # adopt fixed algorithm parameters, which speeds up some operations
  # including key generation and signing.  <em>At this time, this interface
  # does not provide a way to provide such algorithm parameters, e.g.
  # by providing the CA certificate which includes those parameters.</em>
  # 
  # <P>Also, note that at this time only signature-capable keys may be
  # acquired through this interface.  Diffie-Hellman keys, used for secure
  # key exchange, may be supported later.
  # 
  # @author David Brownell
  # @author Hemma Prafullchandra
  # @see PKCS10
  # @see X509CertImpl
  class CertAndKeyGen 
    include_class_members CertAndKeyGenImports
    
    typesig { [String, String] }
    # Creates a CertAndKeyGen object for a particular key type
    # and signature algorithm.
    # 
    # @param keyType type of key, e.g. "RSA", "DSA"
    # @param sigAlg name of the signature algorithm, e.g. "MD5WithRSA",
    # "MD2WithRSA", "SHAwithDSA".
    # @exception NoSuchAlgorithmException on unrecognized algorithms.
    def initialize(key_type, sig_alg)
      @prng = nil
      @sig_alg = nil
      @key_gen = nil
      @public_key = nil
      @private_key = nil
      @key_gen = KeyPairGenerator.get_instance(key_type)
      @sig_alg = sig_alg
    end
    
    typesig { [String, String, String] }
    # Creates a CertAndKeyGen object for a particular key type,
    # signature algorithm, and provider.
    # 
    # @param keyType type of key, e.g. "RSA", "DSA"
    # @param sigAlg name of the signature algorithm, e.g. "MD5WithRSA",
    # "MD2WithRSA", "SHAwithDSA".
    # @param providerName name of the provider
    # @exception NoSuchAlgorithmException on unrecognized algorithms.
    # @exception NoSuchProviderException on unrecognized providers.
    def initialize(key_type, sig_alg, provider_name)
      @prng = nil
      @sig_alg = nil
      @key_gen = nil
      @public_key = nil
      @private_key = nil
      if ((provider_name).nil?)
        @key_gen = KeyPairGenerator.get_instance(key_type)
      else
        begin
          @key_gen = KeyPairGenerator.get_instance(key_type, provider_name)
        rescue JavaException => e
          # try first available provider instead
          @key_gen = KeyPairGenerator.get_instance(key_type)
        end
      end
      @sig_alg = sig_alg
    end
    
    typesig { [SecureRandom] }
    # Sets the source of random numbers used when generating keys.
    # If you do not provide one, a system default facility is used.
    # You may wish to provide your own source of random numbers
    # to get a reproducible sequence of keys and signatures, or
    # because you may be able to take advantage of strong sources
    # of randomness/entropy in your environment.
    def set_random(generator)
      @prng = generator
    end
    
    typesig { [::Java::Int] }
    # want "public void generate (X509Certificate)" ... inherit DSA/D-H param
    # 
    # Generates a random public/private key pair, with a given key
    # size.  Different algorithms provide different degrees of security
    # for the same key size, because of the "work factor" involved in
    # brute force attacks.  As computers become faster, it becomes
    # easier to perform such attacks.  Small keys are to be avoided.
    # 
    # <P>Note that not all values of "keyBits" are valid for all
    # algorithms, and not all public key algorithms are currently
    # supported for use in X.509 certificates.  If the algorithm
    # you specified does not produce X.509 compatible keys, an
    # invalid key exception is thrown.
    # 
    # @param keyBits the number of bits in the keys.
    # @exception InvalidKeyException if the environment does not
    # provide X.509 public keys for this signature algorithm.
    def generate(key_bits)
      pair = nil
      begin
        if ((@prng).nil?)
          @prng = SecureRandom.new
        end
        @key_gen.initialize_(key_bits, @prng)
        pair = @key_gen.generate_key_pair
      rescue JavaException => e
        raise IllegalArgumentException.new(e.get_message)
      end
      @public_key = pair.get_public
      @private_key = pair.get_private
    end
    
    typesig { [] }
    # Returns the public key of the generated key pair if it is of type
    # <code>X509Key</code>, or null if the public key is of a different type.
    # 
    # XXX Note: This behaviour is needed for backwards compatibility.
    # What this method really should return is the public key of the
    # generated key pair, regardless of whether or not it is an instance of
    # <code>X509Key</code>. Accordingly, the return type of this method
    # should be <code>PublicKey</code>.
    def get_public_key
      if (!(@public_key.is_a?(X509Key)))
        return nil
      end
      return @public_key
    end
    
    typesig { [] }
    # Returns the private key of the generated key pair.
    # 
    # <P><STRONG><em>Be extremely careful when handling private keys.
    # When private keys are not kept secret, they lose their ability
    # to securely authenticate specific entities ... that is a huge
    # security risk!</em></STRONG>
    def get_private_key
      return @private_key
    end
    
    typesig { [X500Name, ::Java::Long] }
    # Returns a self-signed X.509v1 certificate for the public key.
    # The certificate is immediately valid.
    # 
    # <P>Such certificates normally are used to identify a "Certificate
    # Authority" (CA).  Accordingly, they will not always be accepted by
    # other parties.  However, such certificates are also useful when
    # you are bootstrapping your security infrastructure, or deploying
    # system prototypes.
    # 
    # @deprecated Use the new <a href =
    # "#getSelfCertificate(sun.security.x509.X500Name, long)">
    # 
    # @param myname X.500 name of the subject (who is also the issuer)
    # @param validity how long the certificate should be valid, in seconds
    def get_self_cert(myname, validity)
      cert = nil
      begin
        cert = get_self_certificate(myname, validity)
        return X509Cert.new(cert.get_encoded)
      rescue CertificateException => e
        raise SignatureException.new(e.get_message)
      rescue NoSuchProviderException => e
        raise NoSuchAlgorithmException.new(e.get_message)
      rescue IOException => e
        raise SignatureException.new(e.get_message)
      end
    end
    
    typesig { [X500Name, JavaDate, ::Java::Long] }
    # Returns a self-signed X.509v3 certificate for the public key.
    # The certificate is immediately valid. No extensions.
    # 
    # <P>Such certificates normally are used to identify a "Certificate
    # Authority" (CA).  Accordingly, they will not always be accepted by
    # other parties.  However, such certificates are also useful when
    # you are bootstrapping your security infrastructure, or deploying
    # system prototypes.
    # 
    # @param myname X.500 name of the subject (who is also the issuer)
    # @param firstDate the issue time of the certificate
    # @param validity how long the certificate should be valid, in seconds
    # @exception CertificateException on certificate handling errors.
    # @exception InvalidKeyException on key handling errors.
    # @exception SignatureException on signature handling errors.
    # @exception NoSuchAlgorithmException on unrecognized algorithms.
    # @exception NoSuchProviderException on unrecognized providers.
    def get_self_certificate(myname, first_date, validity)
      issuer = nil
      cert = nil
      last_date = nil
      begin
        issuer = get_signer(myname)
        last_date = JavaDate.new
        last_date.set_time(first_date.get_time + validity * 1000)
        interval = CertificateValidity.new(first_date, last_date)
        info = X509CertInfo.new
        # Add all mandatory attributes
        info.set(X509CertInfo::VERSION, CertificateVersion.new(CertificateVersion::V3))
        info.set(X509CertInfo::SERIAL_NUMBER, CertificateSerialNumber.new(RJava.cast_to_int((first_date.get_time / 1000))))
        alg_id = issuer.get_algorithm_id
        info.set(X509CertInfo::ALGORITHM_ID, CertificateAlgorithmId.new(alg_id))
        info.set(X509CertInfo::SUBJECT, CertificateSubjectName.new(myname))
        info.set(X509CertInfo::KEY, CertificateX509Key.new(@public_key))
        info.set(X509CertInfo::VALIDITY, interval)
        info.set(X509CertInfo::ISSUER, CertificateIssuerName.new(issuer.get_signer))
        if (!(System.get_property("sun.security.internal.keytool.skid")).nil?)
          ext = CertificateExtensions.new
          ext.set(SubjectKeyIdentifierExtension::NAME, SubjectKeyIdentifierExtension.new(KeyIdentifier.new(@public_key).get_identifier))
          info.set(X509CertInfo::EXTENSIONS, ext)
        end
        cert = X509CertImpl.new(info)
        cert.sign(@private_key, @sig_alg)
        return cert
      rescue IOException => e
        raise CertificateEncodingException.new("getSelfCert: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [X500Name, ::Java::Long] }
    # Keep the old method
    def get_self_certificate(myname, validity)
      return get_self_certificate(myname, JavaDate.new, validity)
    end
    
    typesig { [X500Name] }
    # Returns a PKCS #10 certificate request.  The caller uses either
    # <code>PKCS10.print</code> or <code>PKCS10.toByteArray</code>
    # operations on the result, to get the request in an appropriate
    # transmission format.
    # 
    # <P>PKCS #10 certificate requests are sent, along with some proof
    # of identity, to Certificate Authorities (CAs) which then issue
    # X.509 public key certificates.
    # 
    # @param myname X.500 name of the subject
    # @exception InvalidKeyException on key handling errors.
    # @exception SignatureException on signature handling errors.
    def get_cert_request(myname)
      req = PKCS10.new(@public_key)
      begin
        req.encode_and_sign(get_signer(myname))
      rescue CertificateException => e
        raise SignatureException.new(@sig_alg + " CertificateException")
      rescue IOException => e
        raise SignatureException.new(@sig_alg + " IOException")
      rescue NoSuchAlgorithmException => e
        # "can't happen"
        raise SignatureException.new(@sig_alg + " unavailable?")
      end
      return req
    end
    
    typesig { [X500Name] }
    def get_signer(me)
      signature = Signature.get_instance(@sig_alg)
      # XXX should have a way to pass prng to the signature
      # algorithm ... appropriate for DSS/DSA, not RSA
      signature.init_sign(@private_key)
      return X500Signer.new(signature, me)
    end
    
    attr_accessor :prng
    alias_method :attr_prng, :prng
    undef_method :prng
    alias_method :attr_prng=, :prng=
    undef_method :prng=
    
    attr_accessor :sig_alg
    alias_method :attr_sig_alg, :sig_alg
    undef_method :sig_alg
    alias_method :attr_sig_alg=, :sig_alg=
    undef_method :sig_alg=
    
    attr_accessor :key_gen
    alias_method :attr_key_gen, :key_gen
    undef_method :key_gen
    alias_method :attr_key_gen=, :key_gen=
    undef_method :key_gen=
    
    attr_accessor :public_key
    alias_method :attr_public_key, :public_key
    undef_method :public_key
    alias_method :attr_public_key=, :public_key=
    undef_method :public_key=
    
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    private
    alias_method :initialize__cert_and_key_gen, :initialize
  end
  
end
