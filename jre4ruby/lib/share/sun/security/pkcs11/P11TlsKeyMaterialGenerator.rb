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
  module P11TlsKeyMaterialGeneratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include ::Sun::Security::Internal::Spec
      include_const ::Sun::Security::Internal::Interfaces, :TlsMasterSecret
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # KeyGenerator to calculate the SSL/TLS key material (cipher keys and ivs,
  # mac keys) from the master secret.
  # 
  # @author  Andreas Sterbenz
  # @since   1.6
  class P11TlsKeyMaterialGenerator < P11TlsKeyMaterialGeneratorImports.const_get :KeyGeneratorSpi
    include_class_members P11TlsKeyMaterialGeneratorImports
    
    class_module.module_eval {
      const_set_lazy(:MSG) { "TlsKeyMaterialGenerator must be " + "initialized using a TlsKeyMaterialParameterSpec" }
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
    
    # parameter spec
    attr_accessor :spec
    alias_method :attr_spec, :spec
    undef_method :spec
    alias_method :attr_spec=, :spec=
    undef_method :spec=
    
    # master secret as a P11Key
    attr_accessor :p11key
    alias_method :attr_p11key, :p11key
    undef_method :p11key
    alias_method :attr_p11key=, :p11key=
    undef_method :p11key=
    
    # version, e.g. 0x0301
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @spec = nil
      @p11key = nil
      @version = 0
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
      if ((params.is_a?(TlsKeyMaterialParameterSpec)).equal?(false))
        raise InvalidAlgorithmParameterException.new(MSG)
      end
      @spec = params
      begin
        @p11key = P11SecretKeyFactory.convert_key(@token, @spec.get_master_secret, "TlsMasterSecret")
      rescue InvalidKeyException => e
        raise InvalidAlgorithmParameterException.new("init() failed", e)
      end
      @version = (@spec.get_major_version << 8) | @spec.get_minor_version
      if ((@version < 0x300) && (@version > 0x302))
        raise InvalidAlgorithmParameterException.new("Only SSL 3.0, TLS 1.0, and TLS 1.1 are supported")
      end
      # we assume the token supports both the CKM_SSL3_* and the CKM_TLS_*
      # mechanisms
    end
    
    typesig { [::Java::Int, SecureRandom] }
    def engine_init(keysize, random)
      raise InvalidParameterException.new(MSG)
    end
    
    typesig { [] }
    def engine_generate_key
      if ((@spec).nil?)
        raise IllegalStateException.new("TlsKeyMaterialGenerator must be initialized")
      end
      @mechanism = ((@version).equal?(0x300)) ? CKM_SSL3_KEY_AND_MAC_DERIVE : CKM_TLS_KEY_AND_MAC_DERIVE
      mac_bits = @spec.get_mac_key_length << 3
      iv_bits = @spec.get_iv_length << 3
      expanded_key_bits = @spec.get_expanded_cipher_key_length << 3
      key_bits = @spec.get_cipher_key_length << 3
      is_exportable = false
      if (!(expanded_key_bits).equal?(0))
        is_exportable = true
      else
        is_exportable = false
        expanded_key_bits = key_bits
      end
      random = CK_SSL3_RANDOM_DATA.new(@spec.get_client_random, @spec.get_server_random)
      params = CK_SSL3_KEY_MAT_PARAMS.new(mac_bits, key_bits, iv_bits, is_exportable, random)
      cipher_algorithm = @spec.get_cipher_algorithm
      key_type = P11SecretKeyFactory.get_key_type(cipher_algorithm)
      if (key_type < 0)
        if (!(key_bits).equal?(0))
          raise ProviderException.new("Unknown algorithm: " + RJava.cast_to_string(@spec.get_cipher_algorithm))
        else
          # NULL encryption ciphersuites
          key_type = CKK_GENERIC_SECRET
        end
      end
      session = nil
      begin
        session = @token.get_obj_session
        attributes = nil
        if (!(key_bits).equal?(0))
          attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, key_type), CK_ATTRIBUTE.new(CKA_VALUE_LEN, expanded_key_bits >> 3), ])
        else
          # ciphersuites with NULL ciphers
          attributes = Array.typed(CK_ATTRIBUTE).new(0) { nil }
        end
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, key_type, attributes)
        # the returned keyID is a dummy, ignore
        key_id = @token.attr_p11._c_derive_key(session.id, CK_MECHANISM.new(@mechanism, params), @p11key.attr_key_id, attributes)
        out = params.attr_p_returned_key_material
        # Note that the MAC keys do not inherit all attributes from the
        # template, but they do inherit the sensitive/extractable/token
        # flags, which is all P11Key cares about.
        client_mac_key = P11Key.secret_key(session, out.attr_h_client_mac_secret, "MAC", mac_bits, attributes)
        server_mac_key = P11Key.secret_key(session, out.attr_h_server_mac_secret, "MAC", mac_bits, attributes)
        client_cipher_key = nil
        server_cipher_key = nil
        if (!(key_bits).equal?(0))
          client_cipher_key = P11Key.secret_key(session, out.attr_h_client_key, cipher_algorithm, expanded_key_bits, attributes)
          server_cipher_key = P11Key.secret_key(session, out.attr_h_server_key, cipher_algorithm, expanded_key_bits, attributes)
        else
          client_cipher_key = nil
          server_cipher_key = nil
        end
        client_iv = ((out.attr_p_ivclient).nil?) ? nil : IvParameterSpec.new(out.attr_p_ivclient)
        server_iv = ((out.attr_p_ivserver).nil?) ? nil : IvParameterSpec.new(out.attr_p_ivserver)
        return TlsKeyMaterialSpec.new(client_mac_key, server_mac_key, client_cipher_key, client_iv, server_cipher_key, server_iv)
      rescue JavaException => e
        raise ProviderException.new("Could not generate key", e)
      ensure
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11tls_key_material_generator, :initialize
  end
  
end
