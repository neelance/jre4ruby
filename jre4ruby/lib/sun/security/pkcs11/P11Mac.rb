require "rjava"

# 
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
  module P11MacImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Javax::Crypto, :MacSpi
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # MAC implementation class. This class currently supports HMAC using
  # MD5, SHA-1, SHA-256, SHA-384, and SHA-512 and the SSL3 MAC using MD5
  # and SHA-1.
  # 
  # Note that unlike other classes (e.g. Signature), this does not
  # composite various operations if the token only supports part of the
  # required functionality. The MAC implementations in SunJCE already
  # do exactly that by implementing an MAC on top of MessageDigests. We
  # could not do any better than they.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11Mac < P11MacImports.const_get :MacSpi
    include_class_members P11MacImports
    
    class_module.module_eval {
      # unitialized, all fields except session have arbitrary values
      const_set_lazy(:S_UNINIT) { 1 }
      const_attr_reader  :S_UNINIT
      
      # session initialized, no data processed yet
      const_set_lazy(:S_RESET) { 2 }
      const_attr_reader  :S_RESET
      
      # session initialized, data processed
      const_set_lazy(:S_UPDATE) { 3 }
      const_attr_reader  :S_UPDATE
      
      # transitional state after doFinal() before we go to S_UNINIT
      const_set_lazy(:S_DOFINAL) { 4 }
      const_attr_reader  :S_DOFINAL
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
    
    # mechanism object
    attr_accessor :ck_mechanism
    alias_method :attr_ck_mechanism, :ck_mechanism
    undef_method :ck_mechanism
    alias_method :attr_ck_mechanism=, :ck_mechanism=
    undef_method :ck_mechanism=
    
    # length of the MAC in bytes
    attr_accessor :mac_length
    alias_method :attr_mac_length, :mac_length
    undef_method :mac_length
    alias_method :attr_mac_length=, :mac_length=
    undef_method :mac_length=
    
    # key instance used, if operation active
    attr_accessor :p11key
    alias_method :attr_p11key, :p11key
    undef_method :p11key
    alias_method :attr_p11key=, :p11key=
    undef_method :p11key=
    
    # associated session, if any
    attr_accessor :session
    alias_method :attr_session, :session
    undef_method :session
    alias_method :attr_session=, :session=
    undef_method :session=
    
    # state, one of S_* above
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
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @ck_mechanism = nil
      @mac_length = 0
      @p11key = nil
      @session = nil
      @state = 0
      @one_byte = nil
      super()
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
      params = nil
      case (RJava.cast_to_int(mechanism))
      when RJava.cast_to_int(CKM_MD5_HMAC)
        @mac_length = 16
      when RJava.cast_to_int(CKM_SHA_1_HMAC)
        @mac_length = 20
      when RJava.cast_to_int(CKM_SHA256_HMAC)
        @mac_length = 32
      when RJava.cast_to_int(CKM_SHA384_HMAC)
        @mac_length = 48
      when RJava.cast_to_int(CKM_SHA512_HMAC)
        @mac_length = 64
      when RJava.cast_to_int(CKM_SSL3_MD5_MAC)
        @mac_length = 16
        params = Long.value_of(16)
      when RJava.cast_to_int(CKM_SSL3_SHA1_MAC)
        @mac_length = 20
        params = Long.value_of(20)
      else
        raise ProviderException.new("Unknown mechanism: " + (mechanism).to_s)
      end
      @ck_mechanism = CK_MECHANISM.new(mechanism, params)
      @state = S_UNINIT
      initialize_
    end
    
    typesig { [] }
    def ensure_initialized
      @token.ensure_valid
      if ((@state).equal?(S_UNINIT))
        initialize_
      end
    end
    
    typesig { [] }
    def cancel_operation
      @token.ensure_valid
      if ((@state).equal?(S_UNINIT))
        return
      end
      @state = S_UNINIT
      if (((@session).nil?) || ((@token.attr_explicit_cancel).equal?(false)))
        return
      end
      begin
        @token.attr_p11._c_sign_final(@session.id, 0)
      rescue PKCS11Exception => e
        raise ProviderException.new("Cancel failed", e)
      end
    end
    
    typesig { [] }
    def initialize_
      if ((@state).equal?(S_RESET))
        return
      end
      if ((@session).nil?)
        @session = @token.get_op_session
      end
      if (!(@p11key).nil?)
        @token.attr_p11._c_sign_init(@session.id, @ck_mechanism, @p11key.attr_key_id)
        @state = S_RESET
      else
        @state = S_UNINIT
      end
    end
    
    typesig { [] }
    # see JCE spec
    def engine_get_mac_length
      return @mac_length
    end
    
    typesig { [] }
    # see JCE spec
    def engine_reset
      # the framework insists on calling reset() after doFinal(),
      # but we prefer to take care of reinitialization ourselves
      if ((@state).equal?(S_DOFINAL))
        @state = S_UNINIT
        return
      end
      cancel_operation
      begin
        initialize_
      rescue PKCS11Exception => e
        raise ProviderException.new("reset() failed, ", e)
      end
    end
    
    typesig { [Key, AlgorithmParameterSpec] }
    # see JCE spec
    def engine_init(key, params)
      if (!(params).nil?)
        raise InvalidAlgorithmParameterException.new("Parameters not supported")
      end
      cancel_operation
      @p11key = P11SecretKeyFactory.convert_key(@token, key, @algorithm)
      begin
        initialize_
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("init() failed", e)
      end
    end
    
    typesig { [] }
    # see JCE spec
    def engine_do_final
      begin
        ensure_initialized
        mac = @token.attr_p11._c_sign_final(@session.id, 0)
        @state = S_DOFINAL
        return mac
      rescue PKCS11Exception => e
        raise ProviderException.new("doFinal() failed", e)
      ensure
        @session = @token.release_session(@session)
      end
    end
    
    typesig { [::Java::Byte] }
    # see JCE spec
    def engine_update(input)
      if ((@one_byte).nil?)
        @one_byte = Array.typed(::Java::Byte).new(1) { 0 }
      end
      @one_byte[0] = input
      engine_update(@one_byte, 0, 1)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCE spec
    def engine_update(b, ofs, len)
      begin
        ensure_initialized
        @token.attr_p11._c_sign_update(@session.id, 0, b, ofs, len)
        @state = S_UPDATE
      rescue PKCS11Exception => e
        raise ProviderException.new("update() failed", e)
      end
    end
    
    typesig { [ByteBuffer] }
    # see JCE spec
    def engine_update(byte_buffer)
      begin
        ensure_initialized
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
        @token.attr_p11._c_sign_update(@session.id, addr + ofs, nil, 0, len)
        byte_buffer.position(ofs + len)
        @state = S_UPDATE
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
    alias_method :initialize__p11mac, :initialize
  end
  
end
