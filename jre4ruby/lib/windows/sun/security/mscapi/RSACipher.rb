require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RSACipherImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include ::Java::Security
      include_const ::Java::Security, :Key
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
    }
  end
  
  # RSA cipher implementation using the Microsoft Crypto API.
  # Supports RSA en/decryption and signing/verifying using PKCS#1 v1.5 padding.
  # 
  # Objects should be instantiated by calling Cipher.getInstance() using the
  # following algorithm name:
  # 
  # . "RSA/ECB/PKCS1Padding" (or "RSA") for PKCS#1 padding. The mode (blocktype)
  # is selected based on the en/decryption mode and public/private key used.
  # 
  # We only do one RSA operation per doFinal() call. If the application passes
  # more data via calls to update() or doFinal(), we throw an
  # IllegalBlockSizeException when doFinal() is called (see JCE API spec).
  # Bulk encryption using RSA does not make sense and is not standardized.
  # 
  # Note: RSA keys should be at least 512 bits long
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  # @author  Vincent Ryan
  class RSACipher < RSACipherImports.const_get :CipherSpi
    include_class_members RSACipherImports
    
    class_module.module_eval {
      # constant for an empty byte array
      const_set_lazy(:B0) { Array.typed(::Java::Byte).new(0) { 0 } }
      const_attr_reader  :B0
      
      # mode constant for public key encryption
      const_set_lazy(:MODE_ENCRYPT) { 1 }
      const_attr_reader  :MODE_ENCRYPT
      
      # mode constant for private key decryption
      const_set_lazy(:MODE_DECRYPT) { 2 }
      const_attr_reader  :MODE_DECRYPT
      
      # mode constant for private key encryption (signing)
      const_set_lazy(:MODE_SIGN) { 3 }
      const_attr_reader  :MODE_SIGN
      
      # mode constant for public key decryption (verifying)
      const_set_lazy(:MODE_VERIFY) { 4 }
      const_attr_reader  :MODE_VERIFY
      
      # constant for PKCS#1 v1.5 RSA
      const_set_lazy(:PAD_PKCS1) { "PKCS1Padding" }
      const_attr_reader  :PAD_PKCS1
      
      const_set_lazy(:PAD_PKCS1_LENGTH) { 11 }
      const_attr_reader  :PAD_PKCS1_LENGTH
    }
    
    # current mode, one of MODE_* above. Set when init() is called
    attr_accessor :mode
    alias_method :attr_mode, :mode
    undef_method :mode
    alias_method :attr_mode=, :mode=
    undef_method :mode=
    
    # active padding type, one of PAD_* above. Set by setPadding()
    attr_accessor :padding_type
    alias_method :attr_padding_type, :padding_type
    undef_method :padding_type
    alias_method :attr_padding_type=, :padding_type=
    undef_method :padding_type=
    
    attr_accessor :padding_length
    alias_method :attr_padding_length, :padding_length
    undef_method :padding_length
    alias_method :attr_padding_length=, :padding_length=
    undef_method :padding_length=
    
    # buffer for the data
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # offset into the buffer (number of bytes buffered)
    attr_accessor :buf_ofs
    alias_method :attr_buf_ofs, :buf_ofs
    undef_method :buf_ofs
    alias_method :attr_buf_ofs=, :buf_ofs=
    undef_method :buf_ofs=
    
    # size of the output (the length of the key).
    attr_accessor :output_size
    alias_method :attr_output_size, :output_size
    undef_method :output_size
    alias_method :attr_output_size=, :output_size=
    undef_method :output_size=
    
    # the public key, if we were initialized using a public key
    attr_accessor :public_key
    alias_method :attr_public_key, :public_key
    undef_method :public_key
    alias_method :attr_public_key=, :public_key=
    undef_method :public_key=
    
    # the private key, if we were initialized using a private key
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    typesig { [] }
    def initialize
      @mode = 0
      @padding_type = nil
      @padding_length = 0
      @buffer = nil
      @buf_ofs = 0
      @output_size = 0
      @public_key = nil
      @private_key = nil
      super()
      @padding_length = 0
      SunMSCAPI.verify_self_integrity(get_class)
      @padding_type = PAD_PKCS1
    end
    
    typesig { [String] }
    # modes do not make sense for RSA, but allow ECB
    # see JCE spec
    def engine_set_mode(mode)
      if ((mode.equals_ignore_case("ECB")).equal?(false))
        raise NoSuchAlgorithmException.new("Unsupported mode " + mode)
      end
    end
    
    typesig { [String] }
    # set the padding type
    # see JCE spec
    def engine_set_padding(padding_name)
      if (padding_name.equals_ignore_case(PAD_PKCS1))
        @padding_type = PAD_PKCS1
      else
        raise NoSuchPaddingException.new("Padding " + padding_name + " not supported")
      end
    end
    
    typesig { [] }
    # return 0 as block size, we are not a block cipher
    # see JCE spec
    def engine_get_block_size
      return 0
    end
    
    typesig { [::Java::Int] }
    # return the output size
    # see JCE spec
    def engine_get_output_size(input_len)
      return @output_size
    end
    
    typesig { [] }
    # no iv, return null
    # see JCE spec
    def engine_get_iv
      return nil
    end
    
    typesig { [] }
    # no parameters, return null
    # see JCE spec
    def engine_get_parameters
      return nil
    end
    
    typesig { [::Java::Int, Key, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, random)
      init(opmode, key)
    end
    
    typesig { [::Java::Int, Key, AlgorithmParameterSpec, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, params, random)
      if (!(params).nil?)
        raise InvalidAlgorithmParameterException.new("Parameters not supported")
      end
      init(opmode, key)
    end
    
    typesig { [::Java::Int, Key, AlgorithmParameters, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, params, random)
      if (!(params).nil?)
        raise InvalidAlgorithmParameterException.new("Parameters not supported")
      end
      init(opmode, key)
    end
    
    typesig { [::Java::Int, Key] }
    # initialize this cipher
    def init(opmode, key)
      encrypt = false
      case (opmode)
      when Cipher::ENCRYPT_MODE, Cipher::WRAP_MODE
        @padding_length = PAD_PKCS1_LENGTH
        encrypt = true
      when Cipher::DECRYPT_MODE, Cipher::UNWRAP_MODE
        @padding_length = 0 # reset
        encrypt = false
      else
        raise InvalidKeyException.new("Unknown mode: " + RJava.cast_to_string(opmode))
      end
      if (!(key.is_a?(Sun::Security::Mscapi::Key)))
        raise InvalidKeyException.new("Unsupported key type: " + RJava.cast_to_string(key))
      end
      if (key.is_a?(PublicKey))
        @mode = encrypt ? MODE_ENCRYPT : MODE_VERIFY
        @public_key = key
        @private_key = nil
        @output_size = @public_key.bit_length / 8
      else
        if (key.is_a?(PrivateKey))
          @mode = encrypt ? MODE_SIGN : MODE_DECRYPT
          @private_key = key
          @public_key = nil
          @output_size = @private_key.bit_length / 8
        else
          raise InvalidKeyException.new("Unknown key type: " + RJava.cast_to_string(key))
        end
      end
      @buf_ofs = 0
      @buffer = Array.typed(::Java::Byte).new(@output_size) { 0 }
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # internal update method
    def update(in_, in_ofs, in_len)
      if (((in_len).equal?(0)) || ((in_).nil?))
        return
      end
      if (@buf_ofs + in_len > (@buffer.attr_length - @padding_length))
        @buf_ofs = @buffer.attr_length + 1
        return
      end
      System.arraycopy(in_, in_ofs, @buffer, @buf_ofs, in_len)
      @buf_ofs += in_len
    end
    
    typesig { [] }
    # internal doFinal() method. Here we perform the actual RSA operation
    def do_final
      if (@buf_ofs > @buffer.attr_length)
        raise IllegalBlockSizeException.new("Data must not be longer " + "than " + RJava.cast_to_string((@buffer.attr_length - @padding_length)) + " bytes")
      end
      begin
        data = @buffer
        case (@mode)
        when MODE_SIGN
          return encrypt_decrypt(data, @buf_ofs, @private_key.get_hcrypt_key, true)
        when MODE_VERIFY
          return encrypt_decrypt(data, @buf_ofs, @public_key.get_hcrypt_key, false)
        when MODE_ENCRYPT
          return encrypt_decrypt(data, @buf_ofs, @public_key.get_hcrypt_key, true)
        when MODE_DECRYPT
          return encrypt_decrypt(data, @buf_ofs, @private_key.get_hcrypt_key, false)
        else
          raise AssertionError.new("Internal error")
        end
      rescue KeyException => e
        raise ProviderException.new(e)
      ensure
        @buf_ofs = 0
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCE spec
    def engine_update(in_, in_ofs, in_len)
      update(in_, in_ofs, in_len)
      return B0
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # see JCE spec
    def engine_update(in_, in_ofs, in_len, out, out_ofs)
      update(in_, in_ofs, in_len)
      return 0
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCE spec
    def engine_do_final(in_, in_ofs, in_len)
      update(in_, in_ofs, in_len)
      return do_final
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # see JCE spec
    def engine_do_final(in_, in_ofs, in_len, out, out_ofs)
      if (@output_size > out.attr_length - out_ofs)
        raise ShortBufferException.new("Need " + RJava.cast_to_string(@output_size) + " bytes for output")
      end
      update(in_, in_ofs, in_len)
      result = do_final
      n = result.attr_length
      System.arraycopy(result, 0, out, out_ofs, n)
      return n
    end
    
    typesig { [Key] }
    # see JCE spec
    def engine_wrap(key)
      encoded = key.get_encoded # TODO - unextractable key
      if (((encoded).nil?) || ((encoded.attr_length).equal?(0)))
        raise InvalidKeyException.new("Could not obtain encoded key")
      end
      if (encoded.attr_length > @buffer.attr_length)
        raise InvalidKeyException.new("Key is too long for wrapping")
      end
      update(encoded, 0, encoded.attr_length)
      begin
        return do_final
      rescue BadPaddingException => e
        # should not occur
        raise InvalidKeyException.new("Wrapping failed", e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), String, ::Java::Int] }
    # see JCE spec
    def engine_unwrap(wrapped_key, algorithm, type)
      if (wrapped_key.attr_length > @buffer.attr_length)
        raise InvalidKeyException.new("Key is too long for unwrapping")
      end
      update(wrapped_key, 0, wrapped_key.attr_length)
      begin
        encoding = do_final
        case (type)
        when Cipher::PUBLIC_KEY
          return construct_public_key(encoding, algorithm)
        when Cipher::PRIVATE_KEY
          return construct_private_key(encoding, algorithm)
        when Cipher::SECRET_KEY
          return construct_secret_key(encoding, algorithm)
        else
          raise InvalidKeyException.new("Unknown key type " + RJava.cast_to_string(type))
        end
      rescue BadPaddingException => e
        # should not occur
        raise InvalidKeyException.new("Unwrapping failed", e)
      rescue IllegalBlockSizeException => e
        # should not occur, handled with length check above
        raise InvalidKeyException.new("Unwrapping failed", e)
      end
    end
    
    typesig { [Key] }
    # see JCE spec
    def engine_get_key_size(key)
      if (key.is_a?(Sun::Security::Mscapi::Key))
        return (key).bit_length
      else
        raise InvalidKeyException.new("Unsupported key type: " + RJava.cast_to_string(key))
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), String] }
      # Construct an X.509 encoded public key.
      def construct_public_key(encoded_key, encoded_key_algorithm)
        begin
          key_factory = KeyFactory.get_instance(encoded_key_algorithm)
          key_spec = X509EncodedKeySpec.new(encoded_key)
          return key_factory.generate_public(key_spec)
        rescue NoSuchAlgorithmException => nsae
          raise NoSuchAlgorithmException.new("No installed provider " + "supports the " + encoded_key_algorithm + " algorithm", nsae)
        rescue InvalidKeySpecException => ike
          raise InvalidKeyException.new("Cannot construct public key", ike)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), String] }
      # Construct a PKCS #8 encoded private key.
      def construct_private_key(encoded_key, encoded_key_algorithm)
        begin
          key_factory = KeyFactory.get_instance(encoded_key_algorithm)
          key_spec = PKCS8EncodedKeySpec.new(encoded_key)
          return key_factory.generate_private(key_spec)
        rescue NoSuchAlgorithmException => nsae
          raise NoSuchAlgorithmException.new("No installed provider " + "supports the " + encoded_key_algorithm + " algorithm", nsae)
        rescue InvalidKeySpecException => ike
          raise InvalidKeyException.new("Cannot construct private key", ike)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), String] }
      # Construct an encoded secret key.
      def construct_secret_key(encoded_key, encoded_key_algorithm)
        return SecretKeySpec.new(encoded_key, encoded_key_algorithm)
      end
      
      JNI.native_method :Java_sun_security_mscapi_RSACipher_encryptDecrypt, [:pointer, :long, :long, :int32, :int64, :int8], :long
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Long, ::Java::Boolean] }
      # Encrypt/decrypt a data buffer using Microsoft Crypto API with HCRYPTKEY.
      # It expects and returns ciphertext data in big-endian form.
      def encrypt_decrypt(data, data_size, h_crypt_key, do_encrypt)
        JNI.__send__(:Java_sun_security_mscapi_RSACipher_encryptDecrypt, JNI.env, self.jni_id, data.jni_id, data_size.to_int, h_crypt_key.to_int, do_encrypt ? 1 : 0)
      end
    }
    
    private
    alias_method :initialize__rsacipher, :initialize
  end
  
end
