require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module P11DigestImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Security
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # MessageDigest implementation class. This class currently supports
  # MD2, MD5, SHA-1, SHA-256, SHA-384, and SHA-512.
  # 
  # Note that many digest operations are on fairly small amounts of data
  # (less than 100 bytes total). For example, the 2nd hashing in HMAC or
  # the PRF in TLS. In order to speed those up, we use some buffering to
  # minimize number of the Java->native transitions.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11Digest < P11DigestImports.const_get :MessageDigestSpi
    include_class_members P11DigestImports
    
    class_module.module_eval {
      # unitialized, fields uninitialized, no session acquired
      const_set_lazy(:S_BLANK) { 1 }
      const_attr_reader  :S_BLANK
      
      # data in buffer, all fields valid, session acquired
      # but digest not initialized
      const_set_lazy(:S_BUFFERED) { 2 }
      const_attr_reader  :S_BUFFERED
      
      # session initialized for digesting
      const_set_lazy(:S_INIT) { 3 }
      const_attr_reader  :S_INIT
      
      const_set_lazy(:BUFFER_SIZE) { 96 }
      const_attr_reader  :BUFFER_SIZE
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
    
    # mechanism id
    attr_accessor :mechanism
    alias_method :attr_mechanism, :mechanism
    undef_method :mechanism
    alias_method :attr_mechanism=, :mechanism=
    undef_method :mechanism=
    
    # length of the digest in bytes
    attr_accessor :digest_length
    alias_method :attr_digest_length, :digest_length
    undef_method :digest_length
    alias_method :attr_digest_length=, :digest_length=
    undef_method :digest_length=
    
    # associated session, if any
    attr_accessor :session
    alias_method :attr_session, :session
    undef_method :session
    alias_method :attr_session=, :session=
    undef_method :session=
    
    # current state, one of S_* above
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # one byte buffer for the update(byte) method, initialized on demand
    attr_accessor :one_byte
    alias_method :attr_one_byte, :one_byte
    undef_method :one_byte
    alias_method :attr_one_byte=, :one_byte=
    undef_method :one_byte=
    
    # buffer to reduce number of JNI calls
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # offset into the buffer
    attr_accessor :buf_ofs
    alias_method :attr_buf_ofs, :buf_ofs
    undef_method :buf_ofs
    alias_method :attr_buf_ofs=, :buf_ofs=
    undef_method :buf_ofs=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @digest_length = 0
      @session = nil
      @state = 0
      @one_byte = nil
      @buffer = nil
      @buf_ofs = 0
      super()
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
      case (RJava.cast_to_int(mechanism))
      when RJava.cast_to_int(CKM_MD2), RJava.cast_to_int(CKM_MD5)
        @digest_length = 16
      when RJava.cast_to_int(CKM_SHA_1)
        @digest_length = 20
      when RJava.cast_to_int(CKM_SHA256)
        @digest_length = 32
      when RJava.cast_to_int(CKM_SHA384)
        @digest_length = 48
      when RJava.cast_to_int(CKM_SHA512)
        @digest_length = 64
      else
        raise ProviderException.new("Unknown mechanism: " + (mechanism).to_s)
      end
      @buffer = Array.typed(::Java::Byte).new(BUFFER_SIZE) { 0 }
      @state = S_BLANK
      engine_reset
    end
    
    typesig { [] }
    # see JCA spec
    def engine_get_digest_length
      return @digest_length
    end
    
    typesig { [] }
    def cancel_operation
      @token.ensure_valid
      if ((@session).nil?)
        return
      end
      if ((!(@state).equal?(S_INIT)) || ((@token.attr_explicit_cancel).equal?(false)))
        return
      end
      # need to explicitly "cancel" active op by finishing it
      begin
        @token.attr_p11._c_digest_final(@session.id, @buffer, 0, @buffer.attr_length)
      rescue PKCS11Exception => e
        raise ProviderException.new("cancel() failed", e)
      ensure
        @state = S_BUFFERED
      end
    end
    
    typesig { [] }
    def fetch_session
      @token.ensure_valid
      if ((@state).equal?(S_BLANK))
        engine_reset
      end
    end
    
    typesig { [] }
    # see JCA spec
    def engine_reset
      begin
        cancel_operation
        @buf_ofs = 0
        if ((@session).nil?)
          @session = @token.get_op_session
        end
        @state = S_BUFFERED
      rescue PKCS11Exception => e
        @state = S_BLANK
        raise ProviderException.new("reset() failed, ", e)
      end
    end
    
    typesig { [] }
    # see JCA spec
    def engine_digest
      begin
        digest = Array.typed(::Java::Byte).new(@digest_length) { 0 }
        n = engine_digest(digest, 0, @digest_length)
        return digest
      rescue DigestException => e
        raise ProviderException.new("internal error", e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCA spec
    def engine_digest(digest, ofs, len)
      if (len < @digest_length)
        raise DigestException.new("Length must be at least " + (@digest_length).to_s)
      end
      fetch_session
      begin
        n = 0
        if ((@state).equal?(S_BUFFERED))
          n = @token.attr_p11._c_digest_single(@session.id, CK_MECHANISM.new(@mechanism), @buffer, 0, @buf_ofs, digest, ofs, len)
        else
          if (!(@buf_ofs).equal?(0))
            do_update(@buffer, 0, @buf_ofs)
          end
          n = @token.attr_p11._c_digest_final(@session.id, digest, ofs, len)
        end
        if (!(n).equal?(@digest_length))
          raise ProviderException.new("internal digest length error")
        end
        return n
      rescue PKCS11Exception => e
        raise ProviderException.new("digest() failed", e)
      ensure
        @state = S_BLANK
        @buf_ofs = 0
        @session = @token.release_session(@session)
      end
    end
    
    typesig { [::Java::Byte] }
    # see JCA spec
    def engine_update(in_)
      if ((@one_byte).nil?)
        @one_byte = Array.typed(::Java::Byte).new(1) { 0 }
      end
      @one_byte[0] = in_
      engine_update(@one_byte, 0, 1)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCA spec
    def engine_update(in_, ofs, len)
      fetch_session
      if (len <= 0)
        return
      end
      if ((!(@buf_ofs).equal?(0)) && (@buf_ofs + len > @buffer.attr_length))
        do_update(@buffer, 0, @buf_ofs)
        @buf_ofs = 0
      end
      if (@buf_ofs + len > @buffer.attr_length)
        do_update(in_, ofs, len)
      else
        System.arraycopy(in_, ofs, @buffer, @buf_ofs, len)
        @buf_ofs += len
      end
    end
    
    typesig { [SecretKey] }
    # Called by SunJSSE via reflection during the SSL 3.0 handshake if
    # the master secret is sensitive. We may want to consider making this
    # method public in a future release.
    def impl_update(key)
      fetch_session
      if (!(@buf_ofs).equal?(0))
        do_update(@buffer, 0, @buf_ofs)
        @buf_ofs = 0
      end
      # SunJSSE calls this method only if the key does not have a RAW
      # encoding, i.e. if it is sensitive. Therefore, no point in calling
      # SecretKeyFactory to try to convert it. Just verify it ourselves.
      if ((key.is_a?(P11Key)).equal?(false))
        raise InvalidKeyException.new("Not a P11Key: " + (key).to_s)
      end
      p11key = key
      if (!(p11key.attr_token).equal?(@token))
        raise InvalidKeyException.new("Not a P11Key of this provider: " + (key).to_s)
      end
      begin
        if ((@state).equal?(S_BUFFERED))
          @token.attr_p11._c_digest_init(@session.id, CK_MECHANISM.new(@mechanism))
          @state = S_INIT
        end
        @token.attr_p11._c_digest_key(@session.id, p11key.attr_key_id)
      rescue PKCS11Exception => e
        raise ProviderException.new("update(SecretKey) failed", e)
      end
    end
    
    typesig { [ByteBuffer] }
    # see JCA spec
    def engine_update(byte_buffer)
      fetch_session
      len = byte_buffer.remaining
      if (len <= 0)
        return
      end
      if ((byte_buffer.is_a?(DirectBuffer)).equal?(false))
        super(byte_buffer)
        return
      end
      addr = (byte_buffer).address
      ofs = byte_buffer.position
      begin
        if ((@state).equal?(S_BUFFERED))
          @token.attr_p11._c_digest_init(@session.id, CK_MECHANISM.new(@mechanism))
          @state = S_INIT
          if (!(@buf_ofs).equal?(0))
            do_update(@buffer, 0, @buf_ofs)
            @buf_ofs = 0
          end
        end
        @token.attr_p11._c_digest_update(@session.id, addr + ofs, nil, 0, len)
        byte_buffer.position(ofs + len)
      rescue PKCS11Exception => e
        raise ProviderException.new("update() failed", e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def do_update(in_, ofs, len)
      if (len <= 0)
        return
      end
      begin
        if ((@state).equal?(S_BUFFERED))
          @token.attr_p11._c_digest_init(@session.id, CK_MECHANISM.new(@mechanism))
          @state = S_INIT
        end
        @token.attr_p11._c_digest_update(@session.id, 0, in_, ofs, len)
      rescue PKCS11Exception => e
        raise ProviderException.new("update() failed", e)
      end
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
    alias_method :initialize__p11digest, :initialize
  end
  
end
