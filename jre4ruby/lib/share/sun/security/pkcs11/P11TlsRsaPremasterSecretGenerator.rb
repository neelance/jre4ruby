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
  module P11TlsRsaPremasterSecretGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include_const ::Sun::Security::Internal::Spec, :TlsRsaPremasterSecretParameterSpec
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # KeyGenerator for the SSL/TLS RSA premaster secret.
  # 
  # @author  Andreas Sterbenz
  # @since   1.6
  class P11TlsRsaPremasterSecretGenerator < P11TlsRsaPremasterSecretGeneratorImports.const_get :KeyGeneratorSpi
    include_class_members P11TlsRsaPremasterSecretGeneratorImports
    
    class_module.module_eval {
      const_set_lazy(:MSG) { "TlsRsaPremasterSecretGenerator must be " + "initialized using a TlsRsaPremasterSecretParameterSpec" }
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
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @spec = nil
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
      if ((params.is_a?(TlsRsaPremasterSecretParameterSpec)).equal?(false))
        raise InvalidAlgorithmParameterException.new(MSG)
      end
      @spec = params
    end
    
    typesig { [::Java::Int, SecureRandom] }
    def engine_init(keysize, random)
      raise InvalidParameterException.new(MSG)
    end
    
    typesig { [] }
    def engine_generate_key
      if ((@spec).nil?)
        raise IllegalStateException.new("TlsRsaPremasterSecretGenerator must be initialized")
      end
      version = CK_VERSION.new(@spec.get_major_version, @spec.get_minor_version)
      session = nil
      begin
        session = @token.get_obj_session
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, CKK_GENERIC_SECRET, Array.typed(CK_ATTRIBUTE).new(0) { nil })
        key_id = @token.attr_p11._c_generate_key(session.id, CK_MECHANISM.new(@mechanism, version), attributes)
        key = P11Key.secret_key(session, key_id, "TlsRsaPremasterSecret", 48 << 3, attributes)
        return key
      rescue PKCS11Exception => e
        raise ProviderException.new("Could not generate premaster secret", e)
      ensure
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11tls_rsa_premaster_secret_generator, :initialize
  end
  
end
