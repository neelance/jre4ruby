require "rjava"

# 
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
  module P11TlsMasterSecretGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include_const ::Sun::Security::Internal::Spec, :TlsMasterSecretParameterSpec
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # KeyGenerator for the SSL/TLS master secret.
  # 
  # @author  Andreas Sterbenz
  # @since   1.6
  class P11TlsMasterSecretGenerator < P11TlsMasterSecretGeneratorImports.const_get :KeyGeneratorSpi
    include_class_members P11TlsMasterSecretGeneratorImports
    
    class_module.module_eval {
      const_set_lazy(:MSG) { "TlsMasterSecretGenerator must be " + "initialized using a TlsMasterSecretParameterSpec" }
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
      if ((params.is_a?(TlsMasterSecretParameterSpec)).equal?(false))
        raise InvalidAlgorithmParameterException.new(MSG)
      end
      @spec = params
      key = @spec.get_premaster_secret
      # algorithm should be either TlsRsaPremasterSecret or TlsPremasterSecret,
      # but we omit the check
      begin
        @p11key = P11SecretKeyFactory.convert_key(@token, key, nil)
      rescue InvalidKeyException => e
        raise InvalidAlgorithmParameterException.new("init() failed", e)
      end
      @version = (@spec.get_major_version << 8) | @spec.get_minor_version
      if ((@version < 0x300) || (@version > 0x302))
        raise InvalidAlgorithmParameterException.new("Only SSL 3.0, TLS 1.0, and TLS 1.1 supported")
      end
      # We assume the token supports the required mechanism. If it does not,
      # generateKey() will fail and the failover should take care of us.
    end
    
    typesig { [::Java::Int, SecureRandom] }
    def engine_init(keysize, random)
      raise InvalidParameterException.new(MSG)
    end
    
    typesig { [] }
    def engine_generate_key
      if ((@spec).nil?)
        raise IllegalStateException.new("TlsMasterSecretGenerator must be initialized")
      end
      ck_version = nil
      if ((@p11key.get_algorithm == "TlsRsaPremasterSecret"))
        @mechanism = ((@version).equal?(0x300)) ? CKM_SSL3_MASTER_KEY_DERIVE : CKM_TLS_MASTER_KEY_DERIVE
        ck_version = CK_VERSION.new(0, 0)
      else
        # Note: we use DH for all non-RSA premaster secrets. That includes
        # Kerberos. That should not be a problem because master secret
        # calculation is always a straightforward application of the
        # TLS PRF (or the SSL equivalent).
        # The only thing special about RSA master secret calculation is
        # that it extracts the version numbers from the premaster secret.
        @mechanism = ((@version).equal?(0x300)) ? CKM_SSL3_MASTER_KEY_DERIVE_DH : CKM_TLS_MASTER_KEY_DERIVE_DH
        ck_version = nil
      end
      client_random = @spec.get_client_random
      server_random = @spec.get_server_random
      random = CK_SSL3_RANDOM_DATA.new(client_random, server_random)
      params = CK_SSL3_MASTER_KEY_DERIVE_PARAMS.new(random, ck_version)
      session = nil
      begin
        session = @token.get_obj_session
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, CKK_GENERIC_SECRET, Array.typed(CK_ATTRIBUTE).new(0) { nil })
        key_id = @token.attr_p11._c_derive_key(session.id, CK_MECHANISM.new(@mechanism, params), @p11key.attr_key_id, attributes)
        major = 0
        minor = 0
        ck_version = params.attr_p_version
        if ((ck_version).nil?)
          major = -1
          minor = -1
        else
          major = ck_version.attr_major
          minor = ck_version.attr_minor
        end
        key = P11Key.master_secret_key(session, key_id, "TlsMasterSecret", 48 << 3, attributes, major, minor)
        return key
      rescue Exception => e
        raise ProviderException.new("Could not generate key", e)
      ensure
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11tls_master_secret_generator, :initialize
  end
  
end
