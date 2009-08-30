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
module Sun::Security::Pkcs11
  module P11TlsPrfGeneratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include_const ::Sun::Security::Internal::Spec, :TlsPrfParameterSpec
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # KeyGenerator for the TLS PRF. Note that although the PRF is used in a number
  # of places during the handshake, this class is usually only used to calculate
  # the Finished messages. The reason is that for those other uses more specific
  # PKCS#11 mechanisms have been defined (CKM_SSL3_MASTER_KEY_DERIVE, etc.).
  # 
  # <p>This class supports the CKM_TLS_PRF mechanism from PKCS#11 v2.20 and
  # the older NSS private mechanism.
  # 
  # @author  Andreas Sterbenz
  # @since   1.6
  class P11TlsPrfGenerator < P11TlsPrfGeneratorImports.const_get :KeyGeneratorSpi
    include_class_members P11TlsPrfGeneratorImports
    
    class_module.module_eval {
      const_set_lazy(:MSG) { "TlsPrfGenerator must be initialized using a TlsPrfParameterSpec" }
      const_attr_reader  :MSG
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
    
    attr_accessor :spec
    alias_method :attr_spec, :spec
    undef_method :spec
    alias_method :attr_spec=, :spec=
    undef_method :spec=
    
    attr_accessor :p11key
    alias_method :attr_p11key, :p11key
    undef_method :p11key
    alias_method :attr_p11key=, :p11key=
    undef_method :p11key=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @spec = nil
      @p11key = nil
      super()
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
    end
    
    typesig { [SecureRandom] }
    def engine_init(random)
      raise InvalidParameterException.new(MSG)
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    def engine_init(params, random)
      if ((params.is_a?(TlsPrfParameterSpec)).equal?(false))
        raise InvalidAlgorithmParameterException.new(MSG)
      end
      @spec = params
      key = @spec.get_secret
      if ((key).nil?)
        key = NULL_KEY
      end
      begin
        @p11key = P11SecretKeyFactory.convert_key(@token, key, nil)
      rescue InvalidKeyException => e
        raise InvalidAlgorithmParameterException.new("init() failed", e)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:NULL_KEY) { # SecretKeySpec does not allow zero length keys, so we define our own class.
      Class.new(SecretKey.class == Class ? SecretKey : Object) do
        extend LocalClass
        include_class_members P11TlsPrfGenerator
        include SecretKey if SecretKey.class == Module
        
        typesig { [] }
        define_method :get_encoded do
          return Array.typed(::Java::Byte).new(0) { 0 }
        end
        
        typesig { [] }
        define_method :get_format do
          return "RAW"
        end
        
        typesig { [] }
        define_method :get_algorithm do
          return "Generic"
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :NULL_KEY
    }
    
    typesig { [::Java::Int, SecureRandom] }
    def engine_init(keysize, random)
      raise InvalidParameterException.new(MSG)
    end
    
    typesig { [] }
    def engine_generate_key
      if ((@spec).nil?)
        raise IllegalStateException.new("TlsPrfGenerator must be initialized")
      end
      label = P11Util.get_bytes_utf8(@spec.get_label)
      seed = @spec.get_seed
      if ((@mechanism).equal?(CKM_NSS_TLS_PRF_GENERAL))
        session = nil
        begin
          session = @token.get_op_session
          @token.attr_p11._c_sign_init(session.id, CK_MECHANISM.new(@mechanism), @p11key.attr_key_id)
          @token.attr_p11._c_sign_update(session.id, 0, label, 0, label.attr_length)
          @token.attr_p11._c_sign_update(session.id, 0, seed, 0, seed.attr_length)
          out = @token.attr_p11._c_sign_final(session.id, @spec.get_output_length)
          return SecretKeySpec.new(out, "TlsPrf")
        rescue PKCS11Exception => e
          raise ProviderException.new("Could not calculate PRF", e)
        ensure
          @token.release_session(session)
        end
      end
      # mechanism == CKM_TLS_PRF
      out = Array.typed(::Java::Byte).new(@spec.get_output_length) { 0 }
      params = CK_TLS_PRF_PARAMS.new(seed, label, out)
      session = nil
      begin
        session = @token.get_op_session
        key_id = @token.attr_p11._c_derive_key(session.id, CK_MECHANISM.new(@mechanism, params), @p11key.attr_key_id, nil)
        # ignore keyID, returned PRF bytes are in 'out'
        return SecretKeySpec.new(out, "TlsPrf")
      rescue PKCS11Exception => e
        raise ProviderException.new("Could not calculate PRF", e)
      ensure
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11tls_prf_generator, :initialize
  end
  
end
