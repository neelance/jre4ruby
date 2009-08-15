require "rjava"

# Copyright 2005-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Mscapi
  module RSASignatureImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security, :PrivateKey
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :InvalidParameterException
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :ProviderException
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Security, :Signature
      include_const ::Java::Security, :SignatureSpi
      include_const ::Java::Security, :SignatureException
      include_const ::Java::Math, :BigInteger
      include_const ::Sun::Security::Rsa, :RSAKeyFactory
    }
  end
  
  # RSA signature implementation. Supports RSA signing using PKCS#1 v1.5 padding.
  # 
  # Objects should be instantiated by calling Signature.getInstance() using the
  # following algorithm names:
  # 
  # . "SHA1withRSA"
  # . "MD5withRSA"
  # . "MD2withRSA"
  # 
  # Note: RSA keys must be at least 512 bits long
  # 
  # @since   1.6
  # @author  Stanley Man-Kit Ho
  class RSASignature < Java::Security::SignatureSpi
    include_class_members RSASignatureImports
    
    # message digest implementation we use
    attr_accessor :message_digest
    alias_method :attr_message_digest, :message_digest
    undef_method :message_digest
    alias_method :attr_message_digest=, :message_digest=
    undef_method :message_digest=
    
    # flag indicating whether the digest is reset
    attr_accessor :needs_reset
    alias_method :attr_needs_reset, :needs_reset
    undef_method :needs_reset
    alias_method :attr_needs_reset=, :needs_reset=
    undef_method :needs_reset=
    
    # the signing key
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    # the verification key
    attr_accessor :public_key
    alias_method :attr_public_key, :public_key
    undef_method :public_key
    alias_method :attr_public_key=, :public_key=
    undef_method :public_key=
    
    typesig { [String] }
    def initialize(digest_name)
      @message_digest = nil
      @needs_reset = false
      @private_key = nil
      @public_key = nil
      super()
      @private_key = nil
      @public_key = nil
      begin
        @message_digest = MessageDigest.get_instance(digest_name)
      rescue NoSuchAlgorithmException => e
        raise ProviderException.new(e)
      end
      @needs_reset = false
    end
    
    class_module.module_eval {
      const_set_lazy(:SHA1) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("SHA1")
        end
        
        private
        alias_method :initialize__sha1, :initialize
      end }
      
      const_set_lazy(:MD5) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("MD5")
        end
        
        private
        alias_method :initialize__md5, :initialize
      end }
      
      const_set_lazy(:MD2) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("MD2")
        end
        
        private
        alias_method :initialize__md2, :initialize
      end }
    }
    
    typesig { [PublicKey] }
    # Initializes this signature object with the specified
    # public key for verification operations.
    # 
    # @param publicKey the public key of the identity whose signature is
    # going to be verified.
    # 
    # @exception InvalidKeyException if the key is improperly
    # encoded, parameters are missing, and so on.
    def engine_init_verify(key)
      # This signature accepts only RSAPublicKey
      if (((key.is_a?(Java::Security::Interfaces::RSAPublicKey))).equal?(false))
        raise InvalidKeyException.new("Key type not supported")
      end
      rsa_key = key
      if (((key.is_a?(Sun::Security::Mscapi::RSAPublicKey))).equal?(false))
        # convert key to MSCAPI format
        modulus = rsa_key.get_modulus
        exponent = rsa_key.get_public_exponent
        # Check against the local and global values to make sure
        # the sizes are ok.  Round up to the nearest byte.
        RSAKeyFactory.check_key_lengths(((modulus.bit_length + 7) & ~7), exponent, -1, RSAKeyPairGenerator::KEY_SIZE_MAX)
        modulus_bytes = modulus.to_byte_array
        exponent_bytes = exponent.to_byte_array
        # Adjust key length due to sign bit
        key_bit_length = ((modulus_bytes[0]).equal?(0)) ? (modulus_bytes.attr_length - 1) * 8 : modulus_bytes.attr_length * 8
        key_blob = generate_public_key_blob(key_bit_length, modulus_bytes, exponent_bytes)
        @public_key = import_public_key(key_blob, key_bit_length)
      else
        @public_key = key
      end
      if (@needs_reset)
        @message_digest.reset
        @needs_reset = false
      end
    end
    
    typesig { [PrivateKey] }
    # Initializes this signature object with the specified
    # private key for signing operations.
    # 
    # @param privateKey the private key of the identity whose signature
    # will be generated.
    # 
    # @exception InvalidKeyException if the key is improperly
    # encoded, parameters are missing, and so on.
    def engine_init_sign(key)
      # This signature accepts only RSAPrivateKey
      if (((key.is_a?(Sun::Security::Mscapi::RSAPrivateKey))).equal?(false))
        raise InvalidKeyException.new("Key type not supported")
      end
      @private_key = key
      # Check against the local and global values to make sure
      # the sizes are ok.  Round up to nearest byte.
      RSAKeyFactory.check_key_lengths(((@private_key.bit_length + 7) & ~7), nil, RSAKeyPairGenerator::KEY_SIZE_MIN, RSAKeyPairGenerator::KEY_SIZE_MAX)
      if (@needs_reset)
        @message_digest.reset
        @needs_reset = false
      end
    end
    
    typesig { [::Java::Byte] }
    # Updates the data to be signed or verified
    # using the specified byte.
    # 
    # @param b the byte to use for the update.
    # 
    # @exception SignatureException if the engine is not initialized
    # properly.
    def engine_update(b)
      @message_digest.update(b)
      @needs_reset = true
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates the data to be signed or verified, using the
    # specified array of bytes, starting at the specified offset.
    # 
    # @param b the array of bytes
    # @param off the offset to start from in the array of bytes
    # @param len the number of bytes to use, starting at offset
    # 
    # @exception SignatureException if the engine is not initialized
    # properly
    def engine_update(b, off, len)
      @message_digest.update(b, off, len)
      @needs_reset = true
    end
    
    typesig { [ByteBuffer] }
    # Updates the data to be signed or verified, using the
    # specified ByteBuffer.
    # 
    # @param input the ByteBuffer
    def engine_update(input)
      @message_digest.update(input)
      @needs_reset = true
    end
    
    typesig { [] }
    # Returns the signature bytes of all the data
    # updated so far.
    # The format of the signature depends on the underlying
    # signature scheme.
    # 
    # @return the signature bytes of the signing operation's result.
    # 
    # @exception SignatureException if the engine is not
    # initialized properly or if this signature algorithm is unable to
    # process the input data provided.
    def engine_sign
      hash = @message_digest.digest
      @needs_reset = false
      # Sign hash using MS Crypto APIs
      result = sign_hash(hash, hash.attr_length, @message_digest.get_algorithm, @private_key.get_hcrypt_provider, @private_key.get_hcrypt_key)
      # Convert signature array from little endian to big endian
      return convert_endian_array(result)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Convert array from big endian to little endian, or vice versa.
    def convert_endian_array(byte_array)
      if ((byte_array).nil? || (byte_array.attr_length).equal?(0))
        return byte_array
      end
      retval = Array.typed(::Java::Byte).new(byte_array.attr_length) { 0 }
      # make it big endian
      i = 0
      while i < byte_array.attr_length
        retval[i] = byte_array[byte_array.attr_length - i - 1]
        i += 1
      end
      return retval
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_security_mscapi_RSASignature_signHash, [:pointer, :long, :long, :int32, :long, :int64, :int64], :long
      typesig { [Array.typed(::Java::Byte), ::Java::Int, String, ::Java::Long, ::Java::Long] }
      # Sign hash using Microsoft Crypto API with HCRYPTKEY.
      # The returned data is in little-endian.
      def sign_hash(hash, hash_size, hash_algorithm, h_crypt_prov, h_crypt_key)
        JNI.__send__(:Java_sun_security_mscapi_RSASignature_signHash, JNI.env, self.jni_id, hash.jni_id, hash_size.to_int, hash_algorithm.jni_id, h_crypt_prov.to_int, h_crypt_key.to_int)
      end
      
      JNI.native_method :Java_sun_security_mscapi_RSASignature_verifySignedHash, [:pointer, :long, :long, :int32, :long, :long, :int32, :int64, :int64], :int8
      typesig { [Array.typed(::Java::Byte), ::Java::Int, String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Long, ::Java::Long] }
      # Verify a signed hash using Microsoft Crypto API with HCRYPTKEY.
      def verify_signed_hash(hash, hash_size, hash_algorithm, signature, signature_size, h_crypt_prov, h_crypt_key)
        JNI.__send__(:Java_sun_security_mscapi_RSASignature_verifySignedHash, JNI.env, self.jni_id, hash.jni_id, hash_size.to_int, hash_algorithm.jni_id, signature.jni_id, signature_size.to_int, h_crypt_prov.to_int, h_crypt_key.to_int) != 0
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # Verifies the passed-in signature.
    # 
    # @param sigBytes the signature bytes to be verified.
    # 
    # @return true if the signature was verified, false if not.
    # 
    # @exception SignatureException if the engine is not
    # initialized properly, the passed-in signature is improperly
    # encoded or of the wrong type, if this signature algorithm is unable to
    # process the input data provided, etc.
    def engine_verify(sig_bytes)
      hash = @message_digest.digest
      @needs_reset = false
      return verify_signed_hash(hash, hash.attr_length, @message_digest.get_algorithm, convert_endian_array(sig_bytes), sig_bytes.attr_length, @public_key.get_hcrypt_provider, @public_key.get_hcrypt_key)
    end
    
    typesig { [String, Object] }
    # Sets the specified algorithm parameter to the specified
    # value. This method supplies a general-purpose mechanism through
    # which it is possible to set the various parameters of this object.
    # A parameter may be any settable parameter for the algorithm, such as
    # a parameter size, or a source of random bits for signature generation
    # (if appropriate), or an indication of whether or not to perform
    # a specific but optional computation. A uniform algorithm-specific
    # naming scheme for each parameter is desirable but left unspecified
    # at this time.
    # 
    # @param param the string identifier of the parameter.
    # 
    # @param value the parameter value.
    # 
    # @exception InvalidParameterException if <code>param</code> is an
    # invalid parameter for this signature algorithm engine,
    # the parameter is already set
    # and cannot be set again, a security exception occurs, and so on.
    # 
    # @deprecated Replaced by {@link
    # #engineSetParameter(java.security.spec.AlgorithmParameterSpec)
    # engineSetParameter}.
    def engine_set_parameter(param, value)
      raise InvalidParameterException.new("Parameter not supported")
    end
    
    typesig { [String] }
    # Gets the value of the specified algorithm parameter.
    # This method supplies a general-purpose mechanism through which it
    # is possible to get the various parameters of this object. A parameter
    # may be any settable parameter for the algorithm, such as a parameter
    # size, or  a source of random bits for signature generation (if
    # appropriate), or an indication of whether or not to perform a
    # specific but optional computation. A uniform algorithm-specific
    # naming scheme for each parameter is desirable but left unspecified
    # at this time.
    # 
    # @param param the string name of the parameter.
    # 
    # @return the object that represents the parameter value, or null if
    # there is none.
    # 
    # @exception InvalidParameterException if <code>param</code> is an
    # invalid parameter for this engine, or another exception occurs while
    # trying to get this parameter.
    # 
    # @deprecated
    def engine_get_parameter(param)
      raise InvalidParameterException.new("Parameter not supported")
    end
    
    JNI.native_method :Java_sun_security_mscapi_RSASignature_generatePublicKeyBlob, [:pointer, :long, :int32, :long, :long], :long
    typesig { [::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Generates a public-key BLOB from a key's components.
    def generate_public_key_blob(key_bit_length, modulus, public_exponent)
      JNI.__send__(:Java_sun_security_mscapi_RSASignature_generatePublicKeyBlob, JNI.env, self.jni_id, key_bit_length.to_int, modulus.jni_id, public_exponent.jni_id)
    end
    
    JNI.native_method :Java_sun_security_mscapi_RSASignature_importPublicKey, [:pointer, :long, :long, :int32], :long
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Imports a public-key BLOB.
    def import_public_key(key_blob, key_size)
      JNI.__send__(:Java_sun_security_mscapi_RSASignature_importPublicKey, JNI.env, self.jni_id, key_blob.jni_id, key_size.to_int)
    end
    
    private
    alias_method :initialize__rsasignature, :initialize
  end
  
end
