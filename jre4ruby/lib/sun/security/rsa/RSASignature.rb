require "rjava"

# 
# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Rsa
  module RSASignatureImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Arrays
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Sun::Security::Util
      include_const ::Sun::Security::X509, :AlgorithmId
    }
  end
  
  # 
  # PKCS#1 RSA signatures with the various message digest algorithms.
  # This file contains an abstract base class with all the logic plus
  # a nested static class for each of the message digest algorithms
  # (see end of the file). We support MD2, MD5, SHA-1, SHA-256, SHA-384,
  # and SHA-512.
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSASignature < RSASignatureImports.const_get :SignatureSpi
    include_class_members RSASignatureImports
    
    class_module.module_eval {
      # we sign an ASN.1 SEQUENCE of AlgorithmId and digest
      # it has the form 30:xx:30:0c:[digestOID]:05:00:04:xx:[digest]
      # this means the encoded length is (8 + digestOID.length + digest.length)
      const_set_lazy(:BaseLength) { 8 }
      const_attr_reader  :BaseLength
    }
    
    # object identifier for the message digest algorithm used
    attr_accessor :digest_oid
    alias_method :attr_digest_oid, :digest_oid
    undef_method :digest_oid
    alias_method :attr_digest_oid=, :digest_oid=
    undef_method :digest_oid=
    
    # length of the encoded signature blob
    attr_accessor :encoded_length
    alias_method :attr_encoded_length, :encoded_length
    undef_method :encoded_length
    alias_method :attr_encoded_length=, :encoded_length=
    undef_method :encoded_length=
    
    # message digest implementation we use
    attr_accessor :md
    alias_method :attr_md, :md
    undef_method :md
    alias_method :attr_md=, :md=
    undef_method :md=
    
    # flag indicating whether the digest is reset
    attr_accessor :digest_reset
    alias_method :attr_digest_reset, :digest_reset
    undef_method :digest_reset
    alias_method :attr_digest_reset=, :digest_reset=
    undef_method :digest_reset=
    
    # private key, if initialized for signing
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    # public key, if initialized for verifying
    attr_accessor :public_key
    alias_method :attr_public_key, :public_key
    undef_method :public_key
    alias_method :attr_public_key=, :public_key=
    undef_method :public_key=
    
    # padding to use, set when the initSign/initVerify is called
    attr_accessor :padding
    alias_method :attr_padding, :padding
    undef_method :padding
    alias_method :attr_padding=, :padding=
    undef_method :padding=
    
    typesig { [String, ObjectIdentifier, ::Java::Int] }
    # 
    # Construct a new RSASignature. Used by subclasses.
    def initialize(algorithm, digest_oid, oid_length)
      @digest_oid = nil
      @encoded_length = 0
      @md = nil
      @digest_reset = false
      @private_key = nil
      @public_key = nil
      @padding = nil
      super()
      @digest_oid = digest_oid
      begin
        @md = MessageDigest.get_instance(algorithm)
      rescue NoSuchAlgorithmException => e
        raise ProviderException.new(e)
      end
      @digest_reset = true
      @encoded_length = BaseLength + oid_length + @md.get_digest_length
    end
    
    typesig { [PublicKey] }
    # initialize for verification. See JCA doc
    def engine_init_verify(public_key)
      rsa_key = RSAKeyFactory.to_rsakey(public_key)
      @private_key = nil
      @public_key = rsa_key
      init_common(rsa_key, nil)
    end
    
    typesig { [PrivateKey] }
    # initialize for signing. See JCA doc
    def engine_init_sign(private_key)
      engine_init_sign(private_key, nil)
    end
    
    typesig { [PrivateKey, SecureRandom] }
    # initialize for signing. See JCA doc
    def engine_init_sign(private_key, random)
      rsa_key = RSAKeyFactory.to_rsakey(private_key)
      @private_key = rsa_key
      @public_key = nil
      init_common(rsa_key, random)
    end
    
    typesig { [RSAKey, SecureRandom] }
    # 
    # Init code common to sign and verify.
    def init_common(rsa_key, random)
      reset_digest
      key_size = RSACore.get_byte_length(rsa_key)
      begin
        @padding = RSAPadding.get_instance(RSAPadding::PAD_BLOCKTYPE_1, key_size, random)
      rescue InvalidAlgorithmParameterException => iape
        raise InvalidKeyException.new(iape.get_message)
      end
      max_data_size = @padding.get_max_data_size
      if (@encoded_length > max_data_size)
        raise InvalidKeyException.new("Key is too short for this signature algorithm")
      end
    end
    
    typesig { [] }
    # 
    # Reset the message digest if it is not already reset.
    def reset_digest
      if ((@digest_reset).equal?(false))
        @md.reset
        @digest_reset = true
      end
    end
    
    typesig { [] }
    # 
    # Return the message digest value.
    def get_digest_value
      @digest_reset = true
      return @md.digest
    end
    
    typesig { [::Java::Byte] }
    # update the signature with the plaintext data. See JCA doc
    def engine_update(b)
      @md.update(b)
      @digest_reset = false
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # update the signature with the plaintext data. See JCA doc
    def engine_update(b, off, len)
      @md.update(b, off, len)
      @digest_reset = false
    end
    
    typesig { [ByteBuffer] }
    # update the signature with the plaintext data. See JCA doc
    def engine_update(b)
      @md.update(b)
      @digest_reset = false
    end
    
    typesig { [] }
    # sign the data and return the signature. See JCA doc
    def engine_sign
      digest_ = get_digest_value
      begin
        encoded = encode_signature(@digest_oid, digest_)
        padded = @padding.pad(encoded)
        encrypted = RSACore.rsa(padded, @private_key)
        return encrypted
      rescue GeneralSecurityException => e
        raise SignatureException.new("Could not sign data", e)
      rescue IOException => e
        raise SignatureException.new("Could not encode data", e_)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # verify the data and return the result. See JCA doc
    def engine_verify(sig_bytes)
      digest_ = get_digest_value
      begin
        decrypted = RSACore.rsa(sig_bytes, @public_key)
        unpadded = @padding.unpad(decrypted)
        decoded_digest = decode_signature(@digest_oid, unpadded)
        return (Arrays == digest_)
      rescue Javax::Crypto::BadPaddingException => e
        # occurs if the app has used the wrong RSA public key
        # or if sigBytes is invalid
        # return false rather than propagating the exception for
        # compatibility/ease of use
        return false
      rescue GeneralSecurityException => e
        raise SignatureException.new("Signature verification failed", e_)
      rescue IOException => e
        raise SignatureException.new("Signature encoding error", e__)
      end
    end
    
    class_module.module_eval {
      typesig { [ObjectIdentifier, Array.typed(::Java::Byte)] }
      # 
      # Encode the digest, return the to-be-signed data.
      # Also used by the PKCS#11 provider.
      def encode_signature(oid, digest_)
        out = DerOutputStream.new
        AlgorithmId.new(oid).encode(out)
        out.put_octet_string(digest_)
        result = DerValue.new(DerValue.attr_tag_sequence, out.to_byte_array)
        return result.to_byte_array
      end
      
      typesig { [ObjectIdentifier, Array.typed(::Java::Byte)] }
      # 
      # Decode the signature data. Verify that the object identifier matches
      # and return the message digest.
      def decode_signature(oid, signature)
        in_ = DerInputStream.new(signature)
        values = in_.get_sequence(2)
        if ((!(values.attr_length).equal?(2)) || (!(in_.available).equal?(0)))
          raise IOException.new("SEQUENCE length error")
        end
        alg_id = AlgorithmId.parse(values[0])
        if (((alg_id.get_oid == oid)).equal?(false))
          raise IOException.new("ObjectIdentifier mismatch: " + (alg_id.get_oid).to_s)
        end
        if (!(alg_id.get_encoded_params).nil?)
          raise IOException.new("Unexpected AlgorithmId parameters")
        end
        digest_ = values[1].get_octet_string
        return digest_
      end
    }
    
    typesig { [String, Object] }
    # set parameter, not supported. See JCA doc
    def engine_set_parameter(param, value)
      raise UnsupportedOperationException.new("setParameter() not supported")
    end
    
    typesig { [String] }
    # get parameter, not supported. See JCA doc
    def engine_get_parameter(param)
      raise UnsupportedOperationException.new("getParameter() not supported")
    end
    
    class_module.module_eval {
      # Nested class for MD2withRSA signatures
      const_set_lazy(:MD2withRSA) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("MD2", AlgorithmId::MD2_oid, 10)
        end
        
        private
        alias_method :initialize__md2with_rsa, :initialize
      end }
      
      # Nested class for MD5withRSA signatures
      const_set_lazy(:MD5withRSA) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("MD5", AlgorithmId::MD5_oid, 10)
        end
        
        private
        alias_method :initialize__md5with_rsa, :initialize
      end }
      
      # Nested class for SHA1withRSA signatures
      const_set_lazy(:SHA1withRSA) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("SHA-1", AlgorithmId::SHA_oid, 7)
        end
        
        private
        alias_method :initialize__sha1with_rsa, :initialize
      end }
      
      # Nested class for SHA256withRSA signatures
      const_set_lazy(:SHA256withRSA) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("SHA-256", AlgorithmId::SHA256_oid, 11)
        end
        
        private
        alias_method :initialize__sha256with_rsa, :initialize
      end }
      
      # Nested class for SHA384withRSA signatures
      const_set_lazy(:SHA384withRSA) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("SHA-384", AlgorithmId::SHA384_oid, 11)
        end
        
        private
        alias_method :initialize__sha384with_rsa, :initialize
      end }
      
      # Nested class for SHA512withRSA signatures
      const_set_lazy(:SHA512withRSA) { Class.new(RSASignature) do
        include_class_members RSASignature
        
        typesig { [] }
        def initialize
          super("SHA-512", AlgorithmId::SHA512_oid, 11)
        end
        
        private
        alias_method :initialize__sha512with_rsa, :initialize
      end }
    }
    
    private
    alias_method :initialize__rsasignature, :initialize
  end
  
end
