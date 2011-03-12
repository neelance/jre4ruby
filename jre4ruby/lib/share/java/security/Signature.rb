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
module Java::Security
  module SignatureImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Java::Util
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include ::Java::Io
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Security::Provider, :Service
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto, :CipherSpi
      include_const ::Javax::Crypto, :IllegalBlockSizeException
      include_const ::Javax::Crypto, :BadPaddingException
      include_const ::Javax::Crypto, :NoSuchPaddingException
      include_const ::Sun::Security::Util, :Debug
      include ::Sun::Security::Jca
      include_const ::Sun::Security::Jca::GetInstance, :Instance
    }
  end
  
  # This Signature class is used to provide applications the functionality
  # of a digital signature algorithm. Digital signatures are used for
  # authentication and integrity assurance of digital data.
  # 
  # <p> The signature algorithm can be, among others, the NIST standard
  # DSA, using DSA and SHA-1. The DSA algorithm using the
  # SHA-1 message digest algorithm can be specified as <tt>SHA1withDSA</tt>.
  # In the case of RSA, there are multiple choices for the message digest
  # algorithm, so the signing algorithm could be specified as, for example,
  # <tt>MD2withRSA</tt>, <tt>MD5withRSA</tt>, or <tt>SHA1withRSA</tt>.
  # The algorithm name must be specified, as there is no default.
  # 
  # <p> A Signature object can be used to generate and verify digital
  # signatures.
  # 
  # <p> There are three phases to the use of a Signature object for
  # either signing data or verifying a signature:<ol>
  # 
  # <li>Initialization, with either
  # 
  #     <ul>
  # 
  #     <li>a public key, which initializes the signature for
  #     verification (see {@link #initVerify(PublicKey) initVerify}), or
  # 
  #     <li>a private key (and optionally a Secure Random Number Generator),
  #     which initializes the signature for signing
  #     (see {@link #initSign(PrivateKey)}
  #     and {@link #initSign(PrivateKey, SecureRandom)}).
  # 
  #     </ul><p>
  # 
  # <li>Updating<p>
  # 
  # <p>Depending on the type of initialization, this will update the
  # bytes to be signed or verified. See the
  # {@link #update(byte) update} methods.<p>
  # 
  # <li>Signing or Verifying a signature on all updated bytes. See the
  # {@link #sign() sign} methods and the {@link #verify(byte[]) verify}
  # method.
  # 
  # </ol>
  # 
  # <p>Note that this class is abstract and extends from
  # <code>SignatureSpi</code> for historical reasons.
  # Application developers should only take notice of the methods defined in
  # this <code>Signature</code> class; all the methods in
  # the superclass are intended for cryptographic service providers who wish to
  # supply their own implementations of digital signature algorithms.
  # 
  # @author Benjamin Renaud
  class Signature < SignatureImports.const_get :SignatureSpi
    include_class_members SignatureImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("jca", "Signature") }
      const_attr_reader  :Debug
    }
    
    # The algorithm for this signature object.
    # This value is used to map an OID to the particular algorithm.
    # The mapping is done in AlgorithmObject.algOID(String algorithm)
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # The provider
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    class_module.module_eval {
      # Possible {@link #state} value, signifying that
      # this signature object has not yet been initialized.
      const_set_lazy(:UNINITIALIZED) { 0 }
      const_attr_reader  :UNINITIALIZED
      
      # Possible {@link #state} value, signifying that
      # this signature object has been initialized for signing.
      const_set_lazy(:SIGN) { 2 }
      const_attr_reader  :SIGN
      
      # Possible {@link #state} value, signifying that
      # this signature object has been initialized for verification.
      const_set_lazy(:VERIFY) { 3 }
      const_attr_reader  :VERIFY
    }
    
    # Current state of this signature object.
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    typesig { [String] }
    # Creates a Signature object for the specified algorithm.
    # 
    # @param algorithm the standard string name of the algorithm.
    # See Appendix A in the <a href=
    # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    def initialize(algorithm)
      @algorithm = nil
      @provider = nil
      @state = 0
      super()
      @state = UNINITIALIZED
      @algorithm = algorithm
    end
    
    class_module.module_eval {
      # name of the special signature alg
      const_set_lazy(:RSA_SIGNATURE) { "NONEwithRSA" }
      const_attr_reader  :RSA_SIGNATURE
      
      # name of the equivalent cipher alg
      const_set_lazy(:RSA_CIPHER) { "RSA/ECB/PKCS1Padding" }
      const_attr_reader  :RSA_CIPHER
      
      # all the services we need to lookup for compatibility with Cipher
      const_set_lazy(:RsaIds) { Arrays.as_list(Array.typed(ServiceId).new([ServiceId.new("Signature", "NONEwithRSA"), ServiceId.new("Cipher", "RSA/ECB/PKCS1Padding"), ServiceId.new("Cipher", "RSA/ECB"), ServiceId.new("Cipher", "RSA//PKCS1Padding"), ServiceId.new("Cipher", "RSA")])) }
      const_attr_reader  :RsaIds
      
      typesig { [String] }
      # Returns a Signature object that implements the specified signature
      # algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new Signature object encapsulating the
      # SignatureSpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the standard name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @return the new Signature object.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports a
      #          Signature implementation for the
      #          specified algorithm.
      # 
      # @see Provider
      def get_instance(algorithm)
        list = nil
        if (algorithm.equals_ignore_case(RSA_SIGNATURE))
          list = GetInstance.get_services(RsaIds)
        else
          list = GetInstance.get_services("Signature", algorithm)
        end
        t = list.iterator
        if ((t.has_next).equal?(false))
          raise NoSuchAlgorithmException.new(algorithm + " Signature not available")
        end
        # try services until we find an Spi or a working Signature subclass
        failure = nil
        begin
          s = t.next_
          if (is_spi(s))
            return Delegate.new(s, t, algorithm)
          else
            # must be a subclass of Signature, disable dynamic selection
            begin
              instance = GetInstance.get_instance(s, SignatureSpi)
              return get_instance(instance, algorithm)
            rescue NoSuchAlgorithmException => e
              failure = e
            end
          end
        end while (t.has_next)
        raise failure
      end
      
      typesig { [Instance, String] }
      def get_instance(instance, algorithm)
        sig = nil
        if (instance.attr_impl.is_a?(Signature))
          sig = instance.attr_impl
        else
          spi = instance.attr_impl
          sig = Delegate.new(spi, algorithm)
        end
        sig.attr_provider = instance.attr_provider
        return sig
      end
      
      when_class_loaded do
        const_set :SignatureInfo, ConcurrentHashMap.new
        true_ = Boolean::TRUE
        # pre-initialize with values for our SignatureSpi implementations
        SignatureInfo.put("sun.security.provider.DSA$RawDSA", true_)
        SignatureInfo.put("sun.security.provider.DSA$SHA1withDSA", true_)
        SignatureInfo.put("sun.security.rsa.RSASignature$MD2withRSA", true_)
        SignatureInfo.put("sun.security.rsa.RSASignature$MD5withRSA", true_)
        SignatureInfo.put("sun.security.rsa.RSASignature$SHA1withRSA", true_)
        SignatureInfo.put("sun.security.rsa.RSASignature$SHA256withRSA", true_)
        SignatureInfo.put("sun.security.rsa.RSASignature$SHA384withRSA", true_)
        SignatureInfo.put("sun.security.rsa.RSASignature$SHA512withRSA", true_)
        SignatureInfo.put("com.sun.net.ssl.internal.ssl.RSASignature", true_)
        SignatureInfo.put("sun.security.pkcs11.P11Signature", true_)
      end
      
      typesig { [Service] }
      def is_spi(s)
        if ((s.get_type == "Cipher"))
          # must be a CipherSpi, which we can wrap with the CipherAdapter
          return true
        end
        class_name = s.get_class_name
        result = SignatureInfo.get(class_name)
        if ((result).nil?)
          begin
            instance = s.new_instance(nil)
            # Signature extends SignatureSpi
            # so it is a "real" Spi if it is an
            # instance of SignatureSpi but not Signature
            r = (instance.is_a?(SignatureSpi)) && ((instance.is_a?(Signature)).equal?(false))
            if ((!(Debug).nil?) && ((r).equal?(false)))
              Debug.println("Not a SignatureSpi " + class_name)
              Debug.println("Delayed provider selection may not be " + "available for algorithm " + RJava.cast_to_string(s.get_algorithm))
            end
            result = Boolean.value_of(r)
            SignatureInfo.put(class_name, result)
          rescue JavaException => e
            # something is wrong, assume not an SPI
            return false
          end
        end
        return result.boolean_value
      end
      
      typesig { [String, String] }
      # Returns a Signature object that implements the specified signature
      # algorithm.
      # 
      # <p> A new Signature object encapsulating the
      # SignatureSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the name of the provider.
      # 
      # @return the new Signature object.
      # 
      # @exception NoSuchAlgorithmException if a SignatureSpi
      #          implementation for the specified algorithm is not
      #          available from the specified provider.
      # 
      # @exception NoSuchProviderException if the specified provider is not
      #          registered in the security provider list.
      # 
      # @exception IllegalArgumentException if the provider name is null
      #          or empty.
      # 
      # @see Provider
      def get_instance(algorithm, provider)
        if (algorithm.equals_ignore_case(RSA_SIGNATURE))
          # exception compatibility with existing code
          if (((provider).nil?) || ((provider.length).equal?(0)))
            raise IllegalArgumentException.new("missing provider")
          end
          p = Security.get_provider(provider)
          if ((p).nil?)
            raise NoSuchProviderException.new("no such provider: " + provider)
          end
          return get_instance_rsa(p)
        end
        instance = GetInstance.get_instance("Signature", SignatureSpi, algorithm, provider)
        return get_instance(instance, algorithm)
      end
      
      typesig { [String, Provider] }
      # Returns a Signature object that implements the specified
      # signature algorithm.
      # 
      # <p> A new Signature object encapsulating the
      # SignatureSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the provider.
      # 
      # @return the new Signature object.
      # 
      # @exception NoSuchAlgorithmException if a SignatureSpi
      #          implementation for the specified algorithm is not available
      #          from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(algorithm, provider)
        if (algorithm.equals_ignore_case(RSA_SIGNATURE))
          # exception compatibility with existing code
          if ((provider).nil?)
            raise IllegalArgumentException.new("missing provider")
          end
          return get_instance_rsa(provider)
        end
        instance = GetInstance.get_instance("Signature", SignatureSpi, algorithm, provider)
        return get_instance(instance, algorithm)
      end
      
      typesig { [Provider] }
      # return an implementation for NONEwithRSA, which is a special case
      # because of the Cipher.RSA/ECB/PKCS1Padding compatibility wrapper
      def get_instance_rsa(p)
        # try Signature first
        s = p.get_service("Signature", RSA_SIGNATURE)
        if (!(s).nil?)
          instance = GetInstance.get_instance(s, SignatureSpi)
          return get_instance(instance, RSA_SIGNATURE)
        end
        # check Cipher
        begin
          c = Cipher.get_instance(RSA_CIPHER, p)
          return Delegate.new(CipherAdapter.new(c), RSA_SIGNATURE)
        rescue GeneralSecurityException => e
          # throw Signature style exception message to avoid confusion,
          # but append Cipher exception as cause
          raise NoSuchAlgorithmException.new("no such algorithm: " + RSA_SIGNATURE + " for provider " + RJava.cast_to_string(p.get_name), e)
        end
      end
    }
    
    typesig { [] }
    # Returns the provider of this signature object.
    # 
    # @return the provider of this signature object
    def get_provider
      choose_first_provider
      return @provider
    end
    
    typesig { [] }
    def choose_first_provider
      # empty, overridden in Delegate
    end
    
    typesig { [PublicKey] }
    # Initializes this object for verification. If this method is called
    # again with a different argument, it negates the effect
    # of this call.
    # 
    # @param publicKey the public key of the identity whose signature is
    # going to be verified.
    # 
    # @exception InvalidKeyException if the key is invalid.
    def init_verify(public_key)
      engine_init_verify(public_key)
      @state = VERIFY
    end
    
    typesig { [Certificate] }
    # Initializes this object for verification, using the public key from
    # the given certificate.
    # <p>If the certificate is of type X.509 and has a <i>key usage</i>
    # extension field marked as critical, and the value of the <i>key usage</i>
    # extension field implies that the public key in
    # the certificate and its corresponding private key are not
    # supposed to be used for digital signatures, an
    # <code>InvalidKeyException</code> is thrown.
    # 
    # @param certificate the certificate of the identity whose signature is
    # going to be verified.
    # 
    # @exception InvalidKeyException  if the public key in the certificate
    # is not encoded properly or does not include required  parameter
    # information or cannot be used for digital signature purposes.
    # @since 1.3
    def init_verify(certificate)
      # If the certificate is of type X509Certificate,
      # we should check whether it has a Key Usage
      # extension marked as critical.
      if (certificate.is_a?(Java::Security::Cert::X509Certificate))
        # Check whether the cert has a key usage extension
        # marked as a critical extension.
        # The OID for KeyUsage extension is 2.5.29.15.
        cert = certificate
        crit_set = cert.get_critical_extension_oids
        if (!(crit_set).nil? && !crit_set.is_empty && crit_set.contains("2.5.29.15"))
          key_usage_info = cert.get_key_usage
          # keyUsageInfo[0] is for digitalSignature.
          if ((!(key_usage_info).nil?) && ((key_usage_info[0]).equal?(false)))
            raise InvalidKeyException.new("Wrong key usage")
          end
        end
      end
      public_key = certificate.get_public_key
      engine_init_verify(public_key)
      @state = VERIFY
    end
    
    typesig { [PrivateKey] }
    # Initialize this object for signing. If this method is called
    # again with a different argument, it negates the effect
    # of this call.
    # 
    # @param privateKey the private key of the identity whose signature
    # is going to be generated.
    # 
    # @exception InvalidKeyException if the key is invalid.
    def init_sign(private_key)
      engine_init_sign(private_key)
      @state = SIGN
    end
    
    typesig { [PrivateKey, SecureRandom] }
    # Initialize this object for signing. If this method is called
    # again with a different argument, it negates the effect
    # of this call.
    # 
    # @param privateKey the private key of the identity whose signature
    # is going to be generated.
    # 
    # @param random the source of randomness for this signature.
    # 
    # @exception InvalidKeyException if the key is invalid.
    def init_sign(private_key, random)
      engine_init_sign(private_key, random)
      @state = SIGN
    end
    
    typesig { [] }
    # Returns the signature bytes of all the data updated.
    # The format of the signature depends on the underlying
    # signature scheme.
    # 
    # <p>A call to this method resets this signature object to the state
    # it was in when previously initialized for signing via a
    # call to <code>initSign(PrivateKey)</code>. That is, the object is
    # reset and available to generate another signature from the same
    # signer, if desired, via new calls to <code>update</code> and
    # <code>sign</code>.
    # 
    # @return the signature bytes of the signing operation's result.
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly or if this signature algorithm is unable to
    # process the input data provided.
    def sign
      if ((@state).equal?(SIGN))
        return engine_sign
      end
      raise SignatureException.new("object not initialized for " + "signing")
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Finishes the signature operation and stores the resulting signature
    # bytes in the provided buffer <code>outbuf</code>, starting at
    # <code>offset</code>.
    # The format of the signature depends on the underlying
    # signature scheme.
    # 
    # <p>This signature object is reset to its initial state (the state it
    # was in after a call to one of the <code>initSign</code> methods) and
    # can be reused to generate further signatures with the same private key.
    # 
    # @param outbuf buffer for the signature result.
    # 
    # @param offset offset into <code>outbuf</code> where the signature is
    # stored.
    # 
    # @param len number of bytes within <code>outbuf</code> allotted for the
    # signature.
    # 
    # @return the number of bytes placed into <code>outbuf</code>.
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly, if this signature algorithm is unable to
    # process the input data provided, or if <code>len</code> is less
    # than the actual signature length.
    # 
    # @since 1.2
    def sign(outbuf, offset, len)
      if ((outbuf).nil?)
        raise IllegalArgumentException.new("No output buffer given")
      end
      if (outbuf.attr_length - offset < len)
        raise IllegalArgumentException.new("Output buffer too small for specified offset and length")
      end
      if (!(@state).equal?(SIGN))
        raise SignatureException.new("object not initialized for " + "signing")
      end
      return engine_sign(outbuf, offset, len)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Verifies the passed-in signature.
    # 
    # <p>A call to this method resets this signature object to the state
    # it was in when previously initialized for verification via a
    # call to <code>initVerify(PublicKey)</code>. That is, the object is
    # reset and available to verify another signature from the identity
    # whose public key was specified in the call to <code>initVerify</code>.
    # 
    # @param signature the signature bytes to be verified.
    # 
    # @return true if the signature was verified, false if not.
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly, the passed-in signature is improperly
    # encoded or of the wrong type, if this signature algorithm is unable to
    # process the input data provided, etc.
    def verify(signature)
      if ((@state).equal?(VERIFY))
        return engine_verify(signature)
      end
      raise SignatureException.new("object not initialized for " + "verification")
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Verifies the passed-in signature in the specified array
    # of bytes, starting at the specified offset.
    # 
    # <p>A call to this method resets this signature object to the state
    # it was in when previously initialized for verification via a
    # call to <code>initVerify(PublicKey)</code>. That is, the object is
    # reset and available to verify another signature from the identity
    # whose public key was specified in the call to <code>initVerify</code>.
    # 
    # 
    # @param signature the signature bytes to be verified.
    # @param offset the offset to start from in the array of bytes.
    # @param length the number of bytes to use, starting at offset.
    # 
    # @return true if the signature was verified, false if not.
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly, the passed-in signature is improperly
    # encoded or of the wrong type, if this signature algorithm is unable to
    # process the input data provided, etc.
    # @exception IllegalArgumentException if the <code>signature</code>
    # byte array is null, or the <code>offset</code> or <code>length</code>
    # is less than 0, or the sum of the <code>offset</code> and
    # <code>length</code> is greater than the length of the
    # <code>signature</code> byte array.
    # @since 1.4
    def verify(signature, offset, length_)
      if ((@state).equal?(VERIFY))
        if (((signature).nil?) || (offset < 0) || (length_ < 0) || (offset + length_ > signature.attr_length))
          raise IllegalArgumentException.new("Bad arguments")
        end
        return engine_verify(signature, offset, length_)
      end
      raise SignatureException.new("object not initialized for " + "verification")
    end
    
    typesig { [::Java::Byte] }
    # Updates the data to be signed or verified by a byte.
    # 
    # @param b the byte to use for the update.
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly.
    def update(b)
      if ((@state).equal?(VERIFY) || (@state).equal?(SIGN))
        engine_update(b)
      else
        raise SignatureException.new("object not initialized for " + "signature or verification")
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Updates the data to be signed or verified, using the specified
    # array of bytes.
    # 
    # @param data the byte array to use for the update.
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly.
    def update(data)
      update(data, 0, data.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates the data to be signed or verified, using the specified
    # array of bytes, starting at the specified offset.
    # 
    # @param data the array of bytes.
    # @param off the offset to start from in the array of bytes.
    # @param len the number of bytes to use, starting at offset.
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly.
    def update(data, off, len)
      if ((@state).equal?(SIGN) || (@state).equal?(VERIFY))
        engine_update(data, off, len)
      else
        raise SignatureException.new("object not initialized for " + "signature or verification")
      end
    end
    
    typesig { [ByteBuffer] }
    # Updates the data to be signed or verified using the specified
    # ByteBuffer. Processes the <code>data.remaining()</code> bytes
    # starting at at <code>data.position()</code>.
    # Upon return, the buffer's position will be equal to its limit;
    # its limit will not have changed.
    # 
    # @param data the ByteBuffer
    # 
    # @exception SignatureException if this signature object is not
    # initialized properly.
    # @since 1.5
    def update(data)
      if ((!(@state).equal?(SIGN)) && (!(@state).equal?(VERIFY)))
        raise SignatureException.new("object not initialized for " + "signature or verification")
      end
      if ((data).nil?)
        raise NullPointerException.new
      end
      engine_update(data)
    end
    
    typesig { [] }
    # Returns the name of the algorithm for this signature object.
    # 
    # @return the name of the algorithm for this signature object.
    def get_algorithm
      return @algorithm
    end
    
    typesig { [] }
    # Returns a string representation of this signature object,
    # providing information that includes the state of the object
    # and the name of the algorithm used.
    # 
    # @return a string representation of this signature object.
    def to_s
      init_state = ""
      case (@state)
      when UNINITIALIZED
        init_state = "<not initialized>"
      when VERIFY
        init_state = "<initialized for verifying>"
      when SIGN
        init_state = "<initialized for signing>"
      end
      return "Signature object: " + RJava.cast_to_string(get_algorithm) + init_state
    end
    
    typesig { [String, Object] }
    # Sets the specified algorithm parameter to the specified value.
    # This method supplies a general-purpose mechanism through
    # which it is possible to set the various parameters of this object.
    # A parameter may be any settable parameter for the algorithm, such as
    # a parameter size, or a source of random bits for signature generation
    # (if appropriate), or an indication of whether or not to perform
    # a specific but optional computation. A uniform algorithm-specific
    # naming scheme for each parameter is desirable but left unspecified
    # at this time.
    # 
    # @param param the string identifier of the parameter.
    # @param value the parameter value.
    # 
    # @exception InvalidParameterException if <code>param</code> is an
    # invalid parameter for this signature algorithm engine,
    # the parameter is already set
    # and cannot be set again, a security exception occurs, and so on.
    # 
    # @see #getParameter
    # 
    # @deprecated Use
    # {@link #setParameter(java.security.spec.AlgorithmParameterSpec)
    # setParameter}.
    def set_parameter(param, value)
      engine_set_parameter(param, value)
    end
    
    typesig { [AlgorithmParameterSpec] }
    # Initializes this signature engine with the specified parameter set.
    # 
    # @param params the parameters
    # 
    # @exception InvalidAlgorithmParameterException if the given parameters
    # are inappropriate for this signature engine
    # 
    # @see #getParameters
    def set_parameter(params)
      engine_set_parameter(params)
    end
    
    typesig { [] }
    # Returns the parameters used with this signature object.
    # 
    # <p>The returned parameters may be the same that were used to initialize
    # this signature, or may contain a combination of default and randomly
    # generated parameter values used by the underlying signature
    # implementation if this signature requires algorithm parameters but
    # was not initialized with any.
    # 
    # @return the parameters used with this signature, or null if this
    # signature does not use any parameters.
    # 
    # @see #setParameter(AlgorithmParameterSpec)
    # @since 1.4
    def get_parameters
      return engine_get_parameters
    end
    
    typesig { [String] }
    # Gets the value of the specified algorithm parameter. This method
    # supplies a general-purpose mechanism through which it is possible to
    # get the various parameters of this object. A parameter may be any
    # settable parameter for the algorithm, such as a parameter size, or
    # a source of random bits for signature generation (if appropriate),
    # or an indication of whether or not to perform a specific but optional
    # computation. A uniform algorithm-specific naming scheme for each
    # parameter is desirable but left unspecified at this time.
    # 
    # @param param the string name of the parameter.
    # 
    # @return the object that represents the parameter value, or null if
    # there is none.
    # 
    # @exception InvalidParameterException if <code>param</code> is an invalid
    # parameter for this engine, or another exception occurs while
    # trying to get this parameter.
    # 
    # @see #setParameter(String, Object)
    # 
    # @deprecated
    def get_parameter(param)
      return engine_get_parameter(param)
    end
    
    typesig { [] }
    # Returns a clone if the implementation is cloneable.
    # 
    # @return a clone if the implementation is cloneable.
    # 
    # @exception CloneNotSupportedException if this is called
    # on an implementation that does not support <code>Cloneable</code>.
    def clone
      if (self.is_a?(Cloneable))
        return super
      else
        raise CloneNotSupportedException.new
      end
    end
    
    class_module.module_eval {
      # The following class allows providers to extend from SignatureSpi
      # rather than from Signature. It represents a Signature with an
      # encapsulated, provider-supplied SPI object (of type SignatureSpi).
      # If the provider implementation is an instance of SignatureSpi, the
      # getInstance() methods above return an instance of this class, with
      # the SPI object encapsulated.
      # 
      # Note: All SPI methods from the original Signature class have been
      # moved up the hierarchy into a new class (SignatureSpi), which has
      # been interposed in the hierarchy between the API (Signature)
      # and its original parent (Object).
      const_set_lazy(:Delegate) { Class.new(Signature) do
        include_class_members Signature
        
        # The provider implementation (delegate)
        # filled in once the provider is selected
        attr_accessor :sig_spi
        alias_method :attr_sig_spi, :sig_spi
        undef_method :sig_spi
        alias_method :attr_sig_spi=, :sig_spi=
        undef_method :sig_spi=
        
        # lock for mutex during provider selection
        attr_accessor :lock
        alias_method :attr_lock, :lock
        undef_method :lock
        alias_method :attr_lock=, :lock=
        undef_method :lock=
        
        # next service to try in provider selection
        # null once provider is selected
        attr_accessor :first_service
        alias_method :attr_first_service, :first_service
        undef_method :first_service
        alias_method :attr_first_service=, :first_service=
        undef_method :first_service=
        
        # remaining services to try in provider selection
        # null once provider is selected
        attr_accessor :service_iterator
        alias_method :attr_service_iterator, :service_iterator
        undef_method :service_iterator
        alias_method :attr_service_iterator=, :service_iterator=
        undef_method :service_iterator=
        
        typesig { [class_self::SignatureSpi, String] }
        # constructor
        def initialize(sig_spi, algorithm)
          @sig_spi = nil
          @lock = nil
          @first_service = nil
          @service_iterator = nil
          super(algorithm)
          @sig_spi = sig_spi
          @lock = nil # no lock needed
        end
        
        typesig { [class_self::Service, class_self::Iterator, String] }
        # used with delayed provider selection
        def initialize(service, iterator, algorithm)
          @sig_spi = nil
          @lock = nil
          @first_service = nil
          @service_iterator = nil
          super(algorithm)
          @first_service = service
          @service_iterator = iterator
          @lock = Object.new
        end
        
        typesig { [] }
        # Returns a clone if the delegate is cloneable.
        # 
        # @return a clone if the delegate is cloneable.
        # 
        # @exception CloneNotSupportedException if this is called on a
        # delegate that does not support <code>Cloneable</code>.
        def clone
          choose_first_provider
          if (@sig_spi.is_a?(self.class::Cloneable))
            sig_spi_clone = @sig_spi.clone
            # Because 'algorithm' and 'provider' are private
            # members of our supertype, we must perform a cast to
            # access them.
            that = self.class::Delegate.new(sig_spi_clone, (self).attr_algorithm)
            that.attr_provider = (self).attr_provider
            return that
          else
            raise self.class::CloneNotSupportedException.new
          end
        end
        
        class_module.module_eval {
          typesig { [class_self::Service] }
          def new_instance(s)
            if ((s.get_type == "Cipher"))
              # must be NONEwithRSA
              begin
                c = Cipher.get_instance(RSA_CIPHER, s.get_provider)
                return class_self::CipherAdapter.new(c)
              rescue class_self::NoSuchPaddingException => e
                raise class_self::NoSuchAlgorithmException.new(e)
              end
            else
              o = s.new_instance(nil)
              if ((o.is_a?(class_self::SignatureSpi)).equal?(false))
                raise class_self::NoSuchAlgorithmException.new("Not a SignatureSpi: " + RJava.cast_to_string(o.get_class.get_name))
              end
              return o
            end
          end
          
          # max number of debug warnings to print from chooseFirstProvider()
          
          def warn_count
            defined?(@@warn_count) ? @@warn_count : @@warn_count= 10
          end
          alias_method :attr_warn_count, :warn_count
          
          def warn_count=(value)
            @@warn_count = value
          end
          alias_method :attr_warn_count=, :warn_count=
        }
        
        typesig { [] }
        # Choose the Spi from the first provider available. Used if
        # delayed provider selection is not possible because initSign()/
        # initVerify() is not the first method called.
        def choose_first_provider
          if (!(@sig_spi).nil?)
            return
          end
          synchronized((@lock)) do
            if (!(@sig_spi).nil?)
              return
            end
            if (!(Debug).nil?)
              w = (self.attr_warn_count -= 1)
              if (w >= 0)
                Debug.println("Signature.init() not first method " + "called, disabling delayed provider selection")
                if ((w).equal?(0))
                  Debug.println("Further warnings of this type will " + "be suppressed")
                end
                self.class::JavaException.new("Call trace").print_stack_trace
              end
            end
            last_exception = nil
            while ((!(@first_service).nil?) || @service_iterator.has_next)
              s = nil
              if (!(@first_service).nil?)
                s = @first_service
                @first_service = nil
              else
                s = @service_iterator.next_
              end
              if ((is_spi(s)).equal?(false))
                next
              end
              begin
                @sig_spi = new_instance(s)
                self.attr_provider = s.get_provider
                # not needed any more
                @first_service = nil
                @service_iterator = nil
                return
              rescue self.class::NoSuchAlgorithmException => e
                last_exception = e
              end
            end
            e = self.class::ProviderException.new("Could not construct SignatureSpi instance")
            if (!(last_exception).nil?)
              e.init_cause(last_exception)
            end
            raise e
          end
        end
        
        typesig { [::Java::Int, class_self::Key, class_self::SecureRandom] }
        def choose_provider(type, key, random)
          synchronized((@lock)) do
            if (!(@sig_spi).nil?)
              init(@sig_spi, type, key, random)
              return
            end
            last_exception = nil
            while ((!(@first_service).nil?) || @service_iterator.has_next)
              s = nil
              if (!(@first_service).nil?)
                s = @first_service
                @first_service = nil
              else
                s = @service_iterator.next_
              end
              # if provider says it does not support this key, ignore it
              if ((s.supports_parameter(key)).equal?(false))
                next
              end
              # if instance is not a SignatureSpi, ignore it
              if ((is_spi(s)).equal?(false))
                next
              end
              begin
                spi = new_instance(s)
                init(spi, type, key, random)
                self.attr_provider = s.get_provider
                @sig_spi = spi
                @first_service = nil
                @service_iterator = nil
                return
              rescue self.class::JavaException => e
                # NoSuchAlgorithmException from newInstance()
                # InvalidKeyException from init()
                # RuntimeException (ProviderException) from init()
                if ((last_exception).nil?)
                  last_exception = e
                end
              end
            end
            # no working provider found, fail
            if (last_exception.is_a?(self.class::InvalidKeyException))
              raise last_exception
            end
            if (last_exception.is_a?(self.class::RuntimeException))
              raise last_exception
            end
            k = (!(key).nil?) ? key.get_class.get_name : "(null)"
            raise self.class::InvalidKeyException.new("No installed provider supports this key: " + k, last_exception)
          end
        end
        
        class_module.module_eval {
          const_set_lazy(:I_PUB) { 1 }
          const_attr_reader  :I_PUB
          
          const_set_lazy(:I_PRIV) { 2 }
          const_attr_reader  :I_PRIV
          
          const_set_lazy(:I_PRIV_SR) { 3 }
          const_attr_reader  :I_PRIV_SR
        }
        
        typesig { [class_self::SignatureSpi, ::Java::Int, class_self::Key, class_self::SecureRandom] }
        def init(spi, type, key, random)
          case (type)
          when self.class::I_PUB
            spi.engine_init_verify(key)
          when self.class::I_PRIV
            spi.engine_init_sign(key)
          when self.class::I_PRIV_SR
            spi.engine_init_sign(key, random)
          else
            raise self.class::AssertionError.new("Internal error: " + RJava.cast_to_string(type))
          end
        end
        
        typesig { [class_self::PublicKey] }
        def engine_init_verify(public_key)
          if (!(@sig_spi).nil?)
            @sig_spi.engine_init_verify(public_key)
          else
            choose_provider(self.class::I_PUB, public_key, nil)
          end
        end
        
        typesig { [class_self::PrivateKey] }
        def engine_init_sign(private_key)
          if (!(@sig_spi).nil?)
            @sig_spi.engine_init_sign(private_key)
          else
            choose_provider(self.class::I_PRIV, private_key, nil)
          end
        end
        
        typesig { [class_self::PrivateKey, class_self::SecureRandom] }
        def engine_init_sign(private_key, sr)
          if (!(@sig_spi).nil?)
            @sig_spi.engine_init_sign(private_key, sr)
          else
            choose_provider(self.class::I_PRIV_SR, private_key, sr)
          end
        end
        
        typesig { [::Java::Byte] }
        def engine_update(b)
          choose_first_provider
          @sig_spi.engine_update(b)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def engine_update(b, off, len)
          choose_first_provider
          @sig_spi.engine_update(b, off, len)
        end
        
        typesig { [class_self::ByteBuffer] }
        def engine_update(data)
          choose_first_provider
          @sig_spi.engine_update(data)
        end
        
        typesig { [] }
        def engine_sign
          choose_first_provider
          return @sig_spi.engine_sign
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def engine_sign(outbuf, offset, len)
          choose_first_provider
          return @sig_spi.engine_sign(outbuf, offset, len)
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def engine_verify(sig_bytes)
          choose_first_provider
          return @sig_spi.engine_verify(sig_bytes)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def engine_verify(sig_bytes, offset, length)
          choose_first_provider
          return @sig_spi.engine_verify(sig_bytes, offset, length)
        end
        
        typesig { [String, Object] }
        def engine_set_parameter(param, value)
          choose_first_provider
          @sig_spi.engine_set_parameter(param, value)
        end
        
        typesig { [class_self::AlgorithmParameterSpec] }
        def engine_set_parameter(params)
          choose_first_provider
          @sig_spi.engine_set_parameter(params)
        end
        
        typesig { [String] }
        def engine_get_parameter(param)
          choose_first_provider
          return @sig_spi.engine_get_parameter(param)
        end
        
        typesig { [] }
        def engine_get_parameters
          choose_first_provider
          return @sig_spi.engine_get_parameters
        end
        
        private
        alias_method :initialize__delegate, :initialize
      end }
      
      # adapter for RSA/ECB/PKCS1Padding ciphers
      const_set_lazy(:CipherAdapter) { Class.new(SignatureSpi) do
        include_class_members Signature
        
        attr_accessor :cipher
        alias_method :attr_cipher, :cipher
        undef_method :cipher
        alias_method :attr_cipher=, :cipher=
        undef_method :cipher=
        
        attr_accessor :data
        alias_method :attr_data, :data
        undef_method :data
        alias_method :attr_data=, :data=
        undef_method :data=
        
        typesig { [class_self::Cipher] }
        def initialize(cipher)
          @cipher = nil
          @data = nil
          super()
          @cipher = cipher
        end
        
        typesig { [class_self::PublicKey] }
        def engine_init_verify(public_key)
          @cipher.init(Cipher::DECRYPT_MODE, public_key)
          if ((@data).nil?)
            @data = self.class::ByteArrayOutputStream.new(128)
          else
            @data.reset
          end
        end
        
        typesig { [class_self::PrivateKey] }
        def engine_init_sign(private_key)
          @cipher.init(Cipher::ENCRYPT_MODE, private_key)
          @data = nil
        end
        
        typesig { [class_self::PrivateKey, class_self::SecureRandom] }
        def engine_init_sign(private_key, random)
          @cipher.init(Cipher::ENCRYPT_MODE, private_key, random)
          @data = nil
        end
        
        typesig { [::Java::Byte] }
        def engine_update(b)
          engine_update(Array.typed(::Java::Byte).new([b]), 0, 1)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def engine_update(b, off, len)
          if (!(@data).nil?)
            @data.write(b, off, len)
            return
          end
          out = @cipher.update(b, off, len)
          if ((!(out).nil?) && (!(out.attr_length).equal?(0)))
            raise self.class::SignatureException.new("Cipher unexpectedly returned data")
          end
        end
        
        typesig { [] }
        def engine_sign
          begin
            return @cipher.do_final
          rescue self.class::IllegalBlockSizeException => e
            raise self.class::SignatureException.new("doFinal() failed", e)
          rescue self.class::BadPaddingException => e
            raise self.class::SignatureException.new("doFinal() failed", e)
          end
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def engine_verify(sig_bytes)
          begin
            out = @cipher.do_final(sig_bytes)
            data_bytes = @data.to_byte_array
            @data.reset
            return Arrays.==(out, data_bytes)
          rescue self.class::BadPaddingException => e
            # e.g. wrong public key used
            # return false rather than throwing exception
            return false
          rescue self.class::IllegalBlockSizeException => e
            raise self.class::SignatureException.new("doFinal() failed", e)
          end
        end
        
        typesig { [String, Object] }
        def engine_set_parameter(param, value)
          raise self.class::InvalidParameterException.new("Parameters not supported")
        end
        
        typesig { [String] }
        def engine_get_parameter(param)
          raise self.class::InvalidParameterException.new("Parameters not supported")
        end
        
        private
        alias_method :initialize__cipher_adapter, :initialize
      end }
    }
    
    private
    alias_method :initialize__signature, :initialize
  end
  
end
