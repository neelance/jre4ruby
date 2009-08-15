require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module P11RSACipherImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Java::Security::Spec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # RSA Cipher implementation class. We currently only support
  # PKCS#1 v1.5 padding on top of CKM_RSA_PKCS.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11RSACipher < P11RSACipherImports.const_get :CipherSpi
    include_class_members P11RSACipherImports
    
    class_module.module_eval {
      # minimum length of PKCS#1 v1.5 padding
      const_set_lazy(:PKCS1_MIN_PADDING_LENGTH) { 11 }
      const_attr_reader  :PKCS1_MIN_PADDING_LENGTH
      
      # constant byte[] of length 0
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
    }
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # algorithm name (always "RSA")
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # mechanism id
    attr_accessor :mechanism
    alias_method :attr_mechanism, :mechanism
    undef_method :mechanism
    alias_method :attr_mechanism=, :mechanism=
    undef_method :mechanism=
    
    # associated session, if any
    attr_accessor :session
    alias_method :attr_session, :session
    undef_method :session
    alias_method :attr_session=, :session=
    undef_method :session=
    
    # mode, one of MODE_* above
    attr_accessor :mode
    alias_method :attr_mode, :mode
    undef_method :mode
    alias_method :attr_mode=, :mode=
    undef_method :mode=
    
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    attr_accessor :buf_ofs
    alias_method :attr_buf_ofs, :buf_ofs
    undef_method :buf_ofs
    alias_method :attr_buf_ofs=, :buf_ofs=
    undef_method :buf_ofs=
    
    # key, if init() was called
    attr_accessor :p11key
    alias_method :attr_p11key, :p11key
    undef_method :p11key
    alias_method :attr_p11key=, :p11key=
    undef_method :p11key=
    
    # flag indicating whether an operation is initialized
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    # maximum input data size allowed
    # for decryption, this is the length of the key
    # for encryption, length of the key minus minimum padding length
    attr_accessor :max_input_size
    alias_method :attr_max_input_size, :max_input_size
    undef_method :max_input_size
    alias_method :attr_max_input_size=, :max_input_size=
    undef_method :max_input_size=
    
    # maximum output size. this is the length of the key
    attr_accessor :output_size
    alias_method :attr_output_size, :output_size
    undef_method :output_size
    alias_method :attr_output_size=, :output_size=
    undef_method :output_size=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @session = nil
      @mode = 0
      @buffer = nil
      @buf_ofs = 0
      @p11key = nil
      @initialized = false
      @max_input_size = 0
      @output_size = 0
      super()
      @token = token
      @algorithm = "RSA"
      @mechanism = mechanism
      @session = token.get_op_session
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
    def engine_set_padding(padding)
      lower_padding = padding.to_lower_case
      if ((lower_padding == "pkcs1Padding"))
        # empty
      else
        raise NoSuchPaddingException.new("Unsupported padding " + padding)
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
    # no IV, return null
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
      impl_init(opmode, key)
    end
    
    typesig { [::Java::Int, Key, AlgorithmParameterSpec, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, params, random)
      if (!(params).nil?)
        raise InvalidAlgorithmParameterException.new("Parameters not supported")
      end
      impl_init(opmode, key)
    end
    
    typesig { [::Java::Int, Key, AlgorithmParameters, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, params, random)
      if (!(params).nil?)
        raise InvalidAlgorithmParameterException.new("Parameters not supported")
      end
      impl_init(opmode, key)
    end
    
    typesig { [::Java::Int, Key] }
    def impl_init(opmode, key)
      cancel_operation
      @p11key = P11KeyFactory.convert_key(@token, key, @algorithm)
      encrypt = false
      if ((opmode).equal?(Cipher::ENCRYPT_MODE))
        encrypt = true
      else
        if ((opmode).equal?(Cipher::DECRYPT_MODE))
          encrypt = false
        else
          if ((opmode).equal?(Cipher::WRAP_MODE))
            if ((@p11key.is_public).equal?(false))
              raise InvalidKeyException.new("Wrap has to be used with public keys")
            end
            # No further setup needed for C_Wrap(). We remain uninitialized.
            return
          else
            if ((opmode).equal?(Cipher::UNWRAP_MODE))
              if ((@p11key.is_private).equal?(false))
                raise InvalidKeyException.new("Unwrap has to be used with private keys")
              end
              encrypt = false
            else
              raise InvalidKeyException.new("Unsupported mode: " + RJava.cast_to_string(opmode))
            end
          end
        end
      end
      if (@p11key.is_public)
        @mode = encrypt ? MODE_ENCRYPT : MODE_VERIFY
      else
        if (@p11key.is_private)
          @mode = encrypt ? MODE_SIGN : MODE_DECRYPT
        else
          raise InvalidKeyException.new("Unknown key type: " + RJava.cast_to_string(@p11key))
        end
      end
      n = (@p11key.key_length + 7) >> 3
      @output_size = n
      @buffer = Array.typed(::Java::Byte).new(n) { 0 }
      @max_input_size = encrypt ? (n - PKCS1_MIN_PADDING_LENGTH) : n
      begin
        initialize_
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("init() failed", e)
      end
    end
    
    typesig { [] }
    def cancel_operation
      @token.ensure_valid
      if ((@initialized).equal?(false))
        return
      end
      @initialized = false
      if (((@session).nil?) || ((@token.attr_explicit_cancel).equal?(false)))
        return
      end
      if ((@session.has_objects).equal?(false))
        @session = @token.kill_session(@session)
        return
      end
      begin
        p11 = @token.attr_p11
        in_len = @max_input_size
        out_len = @buffer.attr_length
        case (@mode)
        when MODE_ENCRYPT
          p11._c_encrypt(@session.id, @buffer, 0, in_len, @buffer, 0, out_len)
        when MODE_DECRYPT
          p11._c_decrypt(@session.id, @buffer, 0, in_len, @buffer, 0, out_len)
        when MODE_SIGN
          tmp_buffer = Array.typed(::Java::Byte).new(@max_input_size) { 0 }
          p11._c_sign(@session.id, tmp_buffer)
        when MODE_VERIFY
          p11._c_verify_recover(@session.id, @buffer, 0, in_len, @buffer, 0, out_len)
        else
          raise ProviderException.new("internal error")
        end
      rescue PKCS11Exception => e
        # XXX ensure this always works, ignore error
      end
    end
    
    typesig { [] }
    def ensure_initialized
      @token.ensure_valid
      if ((@initialized).equal?(false))
        initialize_
      end
    end
    
    typesig { [] }
    def initialize_
      if ((@session).nil?)
        @session = @token.get_op_session
      end
      p11 = @token.attr_p11
      ck_mechanism = CK_MECHANISM.new(@mechanism)
      case (@mode)
      when MODE_ENCRYPT
        p11._c_encrypt_init(@session.id, ck_mechanism, @p11key.attr_key_id)
      when MODE_DECRYPT
        p11._c_decrypt_init(@session.id, ck_mechanism, @p11key.attr_key_id)
      when MODE_SIGN
        p11._c_sign_init(@session.id, ck_mechanism, @p11key.attr_key_id)
      when MODE_VERIFY
        p11._c_verify_recover_init(@session.id, ck_mechanism, @p11key.attr_key_id)
      else
        raise AssertionError.new("internal error")
      end
      @buf_ofs = 0
      @initialized = true
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def impl_update(in_, in_ofs, in_len)
      begin
        ensure_initialized
      rescue PKCS11Exception => e
        raise ProviderException.new("update() failed", e)
      end
      if (((in_len).equal?(0)) || ((in_).nil?))
        return
      end
      if (@buf_ofs + in_len > @max_input_size)
        @buf_ofs = @max_input_size + 1
        return
      end
      System.arraycopy(in_, in_ofs, @buffer, @buf_ofs, in_len)
      @buf_ofs += in_len
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def impl_do_final(out, out_ofs, out_len)
      if (@buf_ofs > @max_input_size)
        raise IllegalBlockSizeException.new("Data must not be longer " + "than " + RJava.cast_to_string(@max_input_size) + " bytes")
      end
      begin
        ensure_initialized
        p11 = @token.attr_p11
        n = 0
        case (@mode)
        when MODE_ENCRYPT
          n = p11._c_encrypt(@session.id, @buffer, 0, @buf_ofs, out, out_ofs, out_len)
        when MODE_DECRYPT
          n = p11._c_decrypt(@session.id, @buffer, 0, @buf_ofs, out, out_ofs, out_len)
        when MODE_SIGN
          tmp_buffer = Array.typed(::Java::Byte).new(@buf_ofs) { 0 }
          System.arraycopy(@buffer, 0, tmp_buffer, 0, @buf_ofs)
          tmp_buffer = p11._c_sign(@session.id, tmp_buffer)
          if (tmp_buffer.attr_length > out_len)
            raise BadPaddingException.new("Output buffer too small")
          end
          System.arraycopy(tmp_buffer, 0, out, out_ofs, tmp_buffer.attr_length)
          n = tmp_buffer.attr_length
        when MODE_VERIFY
          n = p11._c_verify_recover(@session.id, @buffer, 0, @buf_ofs, out, out_ofs, out_len)
        else
          raise ProviderException.new("internal error")
        end
        return n
      rescue PKCS11Exception => e
        raise BadPaddingException.new("doFinal() failed").init_cause(e)
      ensure
        @initialized = false
        @session = @token.release_session(@session)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCE spec
    def engine_update(in_, in_ofs, in_len)
      impl_update(in_, in_ofs, in_len)
      return B0
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # see JCE spec
    def engine_update(in_, in_ofs, in_len, out, out_ofs)
      impl_update(in_, in_ofs, in_len)
      return 0
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCE spec
    def engine_do_final(in_, in_ofs, in_len)
      impl_update(in_, in_ofs, in_len)
      n = impl_do_final(@buffer, 0, @buffer.attr_length)
      out = Array.typed(::Java::Byte).new(n) { 0 }
      System.arraycopy(@buffer, 0, out, 0, n)
      return out
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # see JCE spec
    def engine_do_final(in_, in_ofs, in_len, out, out_ofs)
      impl_update(in_, in_ofs, in_len)
      return impl_do_final(out, out_ofs, out.attr_length - out_ofs)
    end
    
    typesig { [] }
    def do_final
      t = Array.typed(::Java::Byte).new(2048) { 0 }
      n = impl_do_final(t, 0, t.attr_length)
      out = Array.typed(::Java::Byte).new(n) { 0 }
      System.arraycopy(t, 0, out, 0, n)
      return out
    end
    
    typesig { [Key] }
    # see JCE spec
    def engine_wrap(key)
      # XXX Note that if we cannot convert key to a key on this token,
      # we will fail. For example, trying a wrap an AES key on a token that
      # does not support AES.
      # We could implement a fallback that just encrypts the encoding
      # (assuming the key is not sensitive). For now, we are operating under
      # the assumption that this is not necessary.
      key_alg = key.get_algorithm
      secret_key = P11SecretKeyFactory.convert_key(@token, key, key_alg)
      s = nil
      begin
        s = @token.get_op_session
        b = @token.attr_p11._c_wrap_key(s.id, CK_MECHANISM.new(@mechanism), @p11key.attr_key_id, secret_key.attr_key_id)
        return b
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("wrap() failed", e)
      ensure
        @token.release_session(s)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), String, ::Java::Int] }
    # see JCE spec
    def engine_unwrap(wrapped_key, algorithm, type)
      if ((algorithm == "TlsRsaPremasterSecret"))
        # the instance variable "session" has been initialized for
        # decrypt mode, so use a local variable instead.
        s = nil
        begin
          s = @token.get_obj_session
          key_type = CKK_GENERIC_SECRET
          attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, key_type), ])
          attributes = @token.get_attributes(O_IMPORT, CKO_SECRET_KEY, key_type, attributes)
          key_id = @token.attr_p11._c_unwrap_key(s.id, CK_MECHANISM.new(@mechanism), @p11key.attr_key_id, wrapped_key, attributes)
          return P11Key.secret_key(@session, key_id, algorithm, 48 << 3, attributes)
        rescue PKCS11Exception => e
          raise InvalidKeyException.new("wrap() failed", e)
        ensure
          @token.release_session(s)
        end
      end
      # XXX implement unwrap using C_Unwrap() for all keys
      if (wrapped_key.attr_length > @max_input_size)
        raise InvalidKeyException.new("Key is too long for unwrapping")
      end
      impl_update(wrapped_key, 0, wrapped_key.attr_length)
      begin
        encoded = do_final
        return ConstructKeys.construct_key(encoded, algorithm, type)
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
      n = P11KeyFactory.convert_key(@token, key, @algorithm).key_length
      return n
    end
    
    typesig { [] }
    def finalize
      begin
        if ((!(@session).nil?) && @token.is_valid)
          cancel_operation
          @session = @token.release_session(@session)
        end
      ensure
        super
      end
    end
    
    private
    alias_method :initialize__p11rsacipher, :initialize
  end
  
  class ConstructKeys 
    include_class_members P11RSACipherImports
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), String] }
      # Construct a public key from its encoding.
      # 
      # @param encodedKey the encoding of a public key.
      # 
      # @param encodedKeyAlgorithm the algorithm the encodedKey is for.
      # 
      # @return a public key constructed from the encodedKey.
      def construct_public_key(encoded_key, encoded_key_algorithm)
        begin
          key_factory = KeyFactory.get_instance(encoded_key_algorithm)
          key_spec = X509EncodedKeySpec.new(encoded_key)
          return key_factory.generate_public(key_spec)
        rescue NoSuchAlgorithmException => nsae
          raise NoSuchAlgorithmException.new("No installed providers " + "can create keys for the " + encoded_key_algorithm + "algorithm", nsae)
        rescue InvalidKeySpecException => ike
          raise InvalidKeyException.new("Cannot construct public key", ike)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), String] }
      # Construct a private key from its encoding.
      # 
      # @param encodedKey the encoding of a private key.
      # 
      # @param encodedKeyAlgorithm the algorithm the wrapped key is for.
      # 
      # @return a private key constructed from the encodedKey.
      def construct_private_key(encoded_key, encoded_key_algorithm)
        begin
          key_factory = KeyFactory.get_instance(encoded_key_algorithm)
          key_spec = PKCS8EncodedKeySpec.new(encoded_key)
          return key_factory.generate_private(key_spec)
        rescue NoSuchAlgorithmException => nsae
          raise NoSuchAlgorithmException.new("No installed providers " + "can create keys for the " + encoded_key_algorithm + "algorithm", nsae)
        rescue InvalidKeySpecException => ike
          raise InvalidKeyException.new("Cannot construct private key", ike)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), String] }
      # Construct a secret key from its encoding.
      # 
      # @param encodedKey the encoding of a secret key.
      # 
      # @param encodedKeyAlgorithm the algorithm the secret key is for.
      # 
      # @return a secret key constructed from the encodedKey.
      def construct_secret_key(encoded_key, encoded_key_algorithm)
        return SecretKeySpec.new(encoded_key, encoded_key_algorithm)
      end
      
      typesig { [Array.typed(::Java::Byte), String, ::Java::Int] }
      def construct_key(encoding, key_algorithm, key_type)
        case (key_type)
        when Cipher::SECRET_KEY
          return construct_secret_key(encoding, key_algorithm)
        when Cipher::PRIVATE_KEY
          return construct_private_key(encoding, key_algorithm)
        when Cipher::PUBLIC_KEY
          return construct_public_key(encoding, key_algorithm)
        else
          raise InvalidKeyException.new("Unknown keytype " + RJava.cast_to_string(key_type))
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__construct_keys, :initialize
  end
  
end
