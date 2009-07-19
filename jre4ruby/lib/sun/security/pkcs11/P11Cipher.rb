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
  module P11CipherImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Security
      include ::Java::Security::Spec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # Cipher implementation class. This class currently supports
  # DES, DESede, AES, ARCFOUR, and Blowfish.
  # 
  # This class is designed to support ECB and CBC with NoPadding and
  # PKCS5Padding for both. However, currently only CBC/NoPadding (and
  # ECB/NoPadding for stream ciphers) is functional.
  # 
  # Note that PKCS#11 current only supports ECB and CBC. There are no
  # provisions for other modes such as CFB, OFB, PCBC, or CTR mode.
  # However, CTR could be implemented relatively easily (and efficiently)
  # on top of ECB mode in this class, if need be.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11Cipher < P11CipherImports.const_get :CipherSpi
    include_class_members P11CipherImports
    
    class_module.module_eval {
      # mode constant for ECB mode
      const_set_lazy(:MODE_ECB) { 3 }
      const_attr_reader  :MODE_ECB
      
      # mode constant for CBC mode
      const_set_lazy(:MODE_CBC) { 4 }
      const_attr_reader  :MODE_CBC
      
      # padding constant for NoPadding
      const_set_lazy(:PAD_NONE) { 5 }
      const_attr_reader  :PAD_NONE
      
      # padding constant for PKCS5Padding
      const_set_lazy(:PAD_PKCS5) { 6 }
      const_attr_reader  :PAD_PKCS5
    }
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # algorithm name
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # name of the key algorithm, e.g. DES instead of algorithm DES/CBC/...
    attr_accessor :key_algorithm
    alias_method :attr_key_algorithm, :key_algorithm
    undef_method :key_algorithm
    alias_method :attr_key_algorithm=, :key_algorithm=
    undef_method :key_algorithm=
    
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
    
    # falg indicating encrypt or decrypt mode
    attr_accessor :encrypt
    alias_method :attr_encrypt, :encrypt
    undef_method :encrypt
    alias_method :attr_encrypt=, :encrypt=
    undef_method :encrypt=
    
    # mode, one of MODE_* above (MODE_ECB for stream ciphers)
    attr_accessor :block_mode
    alias_method :attr_block_mode, :block_mode
    undef_method :block_mode
    alias_method :attr_block_mode=, :block_mode=
    undef_method :block_mode=
    
    # block size, 0 for stream ciphers
    attr_accessor :block_size
    alias_method :attr_block_size, :block_size
    undef_method :block_size
    alias_method :attr_block_size=, :block_size=
    undef_method :block_size=
    
    # padding type, on of PAD_* above (PAD_NONE for stream ciphers)
    attr_accessor :padding_type
    alias_method :attr_padding_type, :padding_type
    undef_method :padding_type
    alias_method :attr_padding_type=, :padding_type=
    undef_method :padding_type=
    
    # original IV, if in MODE_CBC
    attr_accessor :iv
    alias_method :attr_iv, :iv
    undef_method :iv
    alias_method :attr_iv=, :iv=
    undef_method :iv=
    
    # total number of bytes processed
    attr_accessor :bytes_processed
    alias_method :attr_bytes_processed, :bytes_processed
    undef_method :bytes_processed
    alias_method :attr_bytes_processed=, :bytes_processed=
    undef_method :bytes_processed=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @key_algorithm = nil
      @mechanism = 0
      @session = nil
      @p11key = nil
      @initialized = false
      @encrypt = false
      @block_mode = 0
      @block_size = 0
      @padding_type = 0
      @iv = nil
      @bytes_processed = 0
      super()
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
      @key_algorithm = (algorithm.split(Regexp.new("/"))[0]).to_s
      if ((@key_algorithm == "AES"))
        @block_size = 16
        @block_mode = MODE_CBC
        # XXX change default to PKCS5Padding
        @padding_type = PAD_NONE
      else
        if ((@key_algorithm == "RC4") || (@key_algorithm == "ARCFOUR"))
          @block_size = 0
          @block_mode = MODE_ECB
          @padding_type = PAD_NONE
        else
          # DES, DESede, Blowfish
          @block_size = 8
          @block_mode = MODE_CBC
          # XXX change default to PKCS5Padding
          @padding_type = PAD_NONE
        end
      end
      @session = token.get_op_session
    end
    
    typesig { [String] }
    def engine_set_mode(mode)
      mode = (mode.to_upper_case).to_s
      if ((mode == "ECB"))
        @block_mode = MODE_ECB
      else
        if ((mode == "CBC"))
          if ((@block_size).equal?(0))
            raise NoSuchAlgorithmException.new("CBC mode not supported with stream ciphers")
          end
          @block_mode = MODE_CBC
        else
          raise NoSuchAlgorithmException.new("Unsupported mode " + mode)
        end
      end
    end
    
    typesig { [String] }
    # see JCE spec
    def engine_set_padding(padding)
      if (padding.equals_ignore_case("NoPadding"))
        @padding_type = PAD_NONE
      else
        if (padding.equals_ignore_case("PKCS5Padding"))
          if ((@block_size).equal?(0))
            raise NoSuchPaddingException.new("PKCS#5 padding not supported with stream ciphers")
          end
          @padding_type = PAD_PKCS5
          # XXX PKCS#5 not yet implemented
          raise NoSuchPaddingException.new("pkcs5")
        else
          raise NoSuchPaddingException.new("Unsupported padding " + padding)
        end
      end
    end
    
    typesig { [] }
    # see JCE spec
    def engine_get_block_size
      return @block_size
    end
    
    typesig { [::Java::Int] }
    # see JCE spec
    def engine_get_output_size(input_len)
      return do_final_length(input_len)
    end
    
    typesig { [] }
    # see JCE spec
    def engine_get_iv
      return ((@iv).nil?) ? nil : @iv.clone
    end
    
    typesig { [] }
    # see JCE spec
    def engine_get_parameters
      if ((@iv).nil?)
        return nil
      end
      iv_spec = IvParameterSpec.new(@iv)
      begin
        params = AlgorithmParameters.get_instance(@key_algorithm, P11Util.get_sun_jce_provider)
        params.init(iv_spec)
        return params
      rescue GeneralSecurityException => e
        # NoSuchAlgorithmException, NoSuchProviderException
        # InvalidParameterSpecException
        raise ProviderException.new("Could not encode parameters", e)
      end
    end
    
    typesig { [::Java::Int, Key, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, random)
      begin
        impl_init(opmode, key, nil, random)
      rescue InvalidAlgorithmParameterException => e
        raise InvalidKeyException.new("init() failed", e)
      end
    end
    
    typesig { [::Java::Int, Key, AlgorithmParameterSpec, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, params, random)
      iv = nil
      if (!(params).nil?)
        if ((params.is_a?(IvParameterSpec)).equal?(false))
          raise InvalidAlgorithmParameterException.new("Only IvParameterSpec supported")
        end
        iv_spec = params
        iv = iv_spec.get_iv
      else
        iv = nil
      end
      impl_init(opmode, key, iv, random)
    end
    
    typesig { [::Java::Int, Key, AlgorithmParameters, SecureRandom] }
    # see JCE spec
    def engine_init(opmode, key, params, random)
      iv = nil
      if (!(params).nil?)
        begin
          iv_spec = params.get_parameter_spec(IvParameterSpec.class)
          iv = iv_spec.get_iv
        rescue InvalidParameterSpecException => e
          raise InvalidAlgorithmParameterException.new("Could not decode IV", e)
        end
      else
        iv = nil
      end
      impl_init(opmode, key, iv, random)
    end
    
    typesig { [::Java::Int, Key, Array.typed(::Java::Byte), SecureRandom] }
    # actual init() implementation
    def impl_init(opmode, key, iv, random)
      cancel_operation
      case (opmode)
      when Cipher::ENCRYPT_MODE
        @encrypt = true
      when Cipher::DECRYPT_MODE
        @encrypt = false
      else
        raise InvalidAlgorithmParameterException.new("Unsupported mode: " + (opmode).to_s)
      end
      if ((@block_mode).equal?(MODE_ECB))
        # ECB or stream cipher
        if (!(iv).nil?)
          if ((@block_size).equal?(0))
            raise InvalidAlgorithmParameterException.new("IV not used with stream ciphers")
          else
            raise InvalidAlgorithmParameterException.new("IV not used in ECB mode")
          end
        end
      else
        # MODE_CBC
        if ((iv).nil?)
          if ((@encrypt).equal?(false))
            raise InvalidAlgorithmParameterException.new("IV must be specified for decryption in CBC mode")
          end
          # generate random IV
          if ((random).nil?)
            random = SecureRandom.new
          end
          iv = Array.typed(::Java::Byte).new(@block_size) { 0 }
          random.next_bytes(iv)
        else
          if (!(iv.attr_length).equal?(@block_size))
            raise InvalidAlgorithmParameterException.new("IV length must match block size")
          end
        end
      end
      @iv = iv
      @p11key = P11SecretKeyFactory.convert_key(@token, key, @key_algorithm)
      begin
        initialize_
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not initialize cipher", e)
      end
    end
    
    typesig { [] }
    def cancel_operation
      if ((@initialized).equal?(false))
        return
      end
      @initialized = false
      if (((@session).nil?) || ((@token.attr_explicit_cancel).equal?(false)))
        return
      end
      # cancel operation by finishing it
      buf_len = do_final_length(0)
      buffer = Array.typed(::Java::Byte).new(buf_len) { 0 }
      begin
        if (@encrypt)
          @token.attr_p11._c_encrypt_final(@session.id, 0, buffer, 0, buf_len)
        else
          @token.attr_p11._c_decrypt_final(@session.id, 0, buffer, 0, buf_len)
        end
      rescue PKCS11Exception => e
        raise ProviderException.new("Cancel failed", e)
      end
    end
    
    typesig { [] }
    def ensure_initialized
      if ((@initialized).equal?(false))
        initialize_
      end
    end
    
    typesig { [] }
    def initialize_
      if ((@session).nil?)
        @session = @token.get_op_session
      end
      if (@encrypt)
        @token.attr_p11._c_encrypt_init(@session.id, CK_MECHANISM.new(@mechanism, @iv), @p11key.attr_key_id)
      else
        @token.attr_p11._c_decrypt_init(@session.id, CK_MECHANISM.new(@mechanism, @iv), @p11key.attr_key_id)
      end
      @bytes_processed = 0
      @initialized = true
    end
    
    typesig { [::Java::Int] }
    # XXX the calculations below assume the PKCS#11 implementation is smart.
    # conceivably, not all implementations are and we may need to estimate
    # more conservatively
    def bytes_buffered(total_len)
      if ((@padding_type).equal?(PAD_NONE))
        # with NoPadding, buffer only the current unfinished block
        return total_len & (@block_size - 1)
      else
        # PKCS5
        # with PKCS5Padding in decrypt mode, the buffer must never
        # be empty. Buffer a full block instead of nothing.
        buffered = total_len & (@block_size - 1)
        if (((buffered).equal?(0)) && ((@encrypt).equal?(false)))
          buffered = @block_size
        end
        return buffered
      end
    end
    
    typesig { [::Java::Int] }
    # if update(inLen) is called, how big does the output buffer have to be?
    def update_length(in_len)
      if (in_len <= 0)
        return 0
      end
      if ((@block_size).equal?(0))
        return in_len
      else
        # bytes that need to be buffered now
        buffered = bytes_buffered(@bytes_processed)
        # bytes that need to be buffered after this update
        new_buffered = bytes_buffered(@bytes_processed + in_len)
        return in_len + buffered - new_buffered
      end
    end
    
    typesig { [::Java::Int] }
    # if doFinal(inLen) is called, how big does the output buffer have to be?
    def do_final_length(in_len)
      if ((@padding_type).equal?(PAD_NONE))
        return update_length(in_len)
      end
      if (in_len < 0)
        return 0
      end
      buffered = bytes_buffered(@bytes_processed)
      new_processed = @bytes_processed + in_len
      padded_processed = (new_processed + @block_size) & ~(@block_size - 1)
      return padded_processed - @bytes_processed + buffered
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCE spec
    def engine_update(in_, in_ofs, in_len)
      begin
        out = Array.typed(::Java::Byte).new(update_length(in_len)) { 0 }
        n = engine_update(in_, in_ofs, in_len, out, 0)
        return P11Util.convert(out, 0, n)
      rescue ShortBufferException => e
        raise ProviderException.new(e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # see JCE spec
    def engine_update(in_, in_ofs, in_len, out, out_ofs)
      out_len = out.attr_length - out_ofs
      return impl_update(in_, in_ofs, in_len, out, out_ofs, out_len)
    end
    
    typesig { [ByteBuffer, ByteBuffer] }
    # see JCE spec
    def engine_update(in_buffer, out_buffer)
      return impl_update(in_buffer, out_buffer)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCE spec
    def engine_do_final(in_, in_ofs, in_len)
      begin
        out = Array.typed(::Java::Byte).new(do_final_length(in_len)) { 0 }
        n = engine_do_final(in_, in_ofs, in_len, out, 0)
        return P11Util.convert(out, 0, n)
      rescue ShortBufferException => e
        raise ProviderException.new(e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # see JCE spec
    def engine_do_final(in_, in_ofs, in_len, out, out_ofs)
      # BadPaddingException {
      n = 0
      if ((!(in_len).equal?(0)) && (!(in_).nil?))
        n = engine_update(in_, in_ofs, in_len, out, out_ofs)
        out_ofs += n
      end
      n += impl_do_final(out, out_ofs, out.attr_length - out_ofs)
      return n
    end
    
    typesig { [ByteBuffer, ByteBuffer] }
    # see JCE spec
    def engine_do_final(in_buffer, out_buffer)
      n = engine_update(in_buffer, out_buffer)
      n += impl_do_final(out_buffer)
      return n
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def impl_update(in_, in_ofs, in_len, out, out_ofs, out_len)
      if (out_len < update_length(in_len))
        raise ShortBufferException.new
      end
      begin
        ensure_initialized
        k = 0
        if (@encrypt)
          k = @token.attr_p11._c_encrypt_update(@session.id, 0, in_, in_ofs, in_len, 0, out, out_ofs, out_len)
        else
          k = @token.attr_p11._c_decrypt_update(@session.id, 0, in_, in_ofs, in_len, 0, out, out_ofs, out_len)
        end
        @bytes_processed += in_len
        return k
      rescue PKCS11Exception => e
        # XXX throw correct exception
        raise ProviderException.new("update() failed", e)
      end
    end
    
    typesig { [ByteBuffer, ByteBuffer] }
    def impl_update(in_buffer, out_buffer)
      in_len = in_buffer.remaining
      if (in_len <= 0)
        return 0
      end
      out_len = out_buffer.remaining
      if (out_len < update_length(in_len))
        raise ShortBufferException.new
      end
      in_pos_changed = false
      begin
        ensure_initialized
        in_addr = 0
        in_ofs = in_buffer.position
        in_array = nil
        if (in_buffer.is_a?(DirectBuffer))
          in_addr = (in_buffer).address
        else
          if (in_buffer.has_array)
            in_array = in_buffer.array
            in_ofs += in_buffer.array_offset
          else
            in_array = Array.typed(::Java::Byte).new(in_len) { 0 }
            in_buffer.get(in_array)
            in_ofs = 0
            in_pos_changed = true
          end
        end
        out_addr = 0
        out_ofs = out_buffer.position
        out_array = nil
        if (out_buffer.is_a?(DirectBuffer))
          out_addr = (out_buffer).address
        else
          if (out_buffer.has_array)
            out_array = out_buffer.array
            out_ofs += out_buffer.array_offset
          else
            out_array = Array.typed(::Java::Byte).new(out_len) { 0 }
            out_ofs = 0
          end
        end
        k = 0
        if (@encrypt)
          k = @token.attr_p11._c_encrypt_update(@session.id, in_addr, in_array, in_ofs, in_len, out_addr, out_array, out_ofs, out_len)
        else
          k = @token.attr_p11._c_decrypt_update(@session.id, in_addr, in_array, in_ofs, in_len, out_addr, out_array, out_ofs, out_len)
        end
        @bytes_processed += in_len
        if (!in_pos_changed)
          in_buffer.position(in_buffer.position + in_len)
        end
        if (!(out_buffer.is_a?(DirectBuffer)) && !out_buffer.has_array)
          out_buffer.put(out_array, out_ofs, k)
        else
          out_buffer.position(out_buffer.position + k)
        end
        return k
      rescue PKCS11Exception => e
        # Un-read the bytes back to input buffer
        if (in_pos_changed)
          in_buffer.position(in_buffer.position - in_len)
        end
        # XXX throw correct exception
        raise ProviderException.new("update() failed", e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def impl_do_final(out, out_ofs, out_len)
      if (out_len < do_final_length(0))
        raise ShortBufferException.new
      end
      begin
        ensure_initialized
        if (@encrypt)
          return @token.attr_p11._c_encrypt_final(@session.id, 0, out, out_ofs, out_len)
        else
          return @token.attr_p11._c_decrypt_final(@session.id, 0, out, out_ofs, out_len)
        end
      rescue PKCS11Exception => e
        handle_exception(e)
        raise ProviderException.new("doFinal() failed", e)
      ensure
        @initialized = false
        @bytes_processed = 0
        @session = @token.release_session(@session)
      end
    end
    
    typesig { [ByteBuffer] }
    def impl_do_final(out_buffer)
      out_len = out_buffer.remaining
      if (out_len < do_final_length(0))
        raise ShortBufferException.new
      end
      begin
        ensure_initialized
        out_addr = 0
        out_ofs = out_buffer.position
        out_array = nil
        if (out_buffer.is_a?(DirectBuffer))
          out_addr = (out_buffer).address
        else
          if (out_buffer.has_array)
            out_array = out_buffer.array
            out_ofs += out_buffer.array_offset
          else
            out_array = Array.typed(::Java::Byte).new(out_len) { 0 }
            out_ofs = 0
          end
        end
        k = 0
        if (@encrypt)
          k = @token.attr_p11._c_encrypt_final(@session.id, out_addr, out_array, out_ofs, out_len)
        else
          k = @token.attr_p11._c_decrypt_final(@session.id, out_addr, out_array, out_ofs, out_len)
        end
        if (!(out_buffer.is_a?(DirectBuffer)) && !out_buffer.has_array)
          out_buffer.put(out_array, out_ofs, k)
        else
          out_buffer.position(out_buffer.position + k)
        end
        return k
      rescue PKCS11Exception => e
        handle_exception(e)
        raise ProviderException.new("doFinal() failed", e)
      ensure
        @initialized = false
        @bytes_processed = 0
        @session = @token.release_session(@session)
      end
    end
    
    typesig { [PKCS11Exception] }
    def handle_exception(e)
      error_code = e.get_error_code
      # XXX better check
      if ((error_code).equal?(CKR_DATA_LEN_RANGE))
        raise IllegalBlockSizeException.new(e.to_s).init_cause(e)
      end
    end
    
    typesig { [Key] }
    # see JCE spec
    def engine_wrap(key)
      # XXX key wrapping
      raise UnsupportedOperationException.new("engineWrap()")
    end
    
    typesig { [Array.typed(::Java::Byte), String, ::Java::Int] }
    # see JCE spec
    def engine_unwrap(wrapped_key, wrapped_key_algorithm, wrapped_key_type)
      # XXX key unwrapping
      raise UnsupportedOperationException.new("engineUnwrap()")
    end
    
    typesig { [Key] }
    # see JCE spec
    def engine_get_key_size(key)
      n = P11SecretKeyFactory.convert_key(@token, key, @key_algorithm).key_length
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
    alias_method :initialize__p11cipher, :initialize
  end
  
end
