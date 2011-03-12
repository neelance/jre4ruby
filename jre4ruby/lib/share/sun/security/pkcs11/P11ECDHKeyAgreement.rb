require "rjava"

# Copyright 2006-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module P11ECDHKeyAgreementImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Security
      include_const ::Java::Security::Interfaces, :ECPublicKey
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Javax::Crypto
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # KeyAgreement implementation for ECDH.
  # 
  # @author  Andreas Sterbenz
  # @since   1.6
  class P11ECDHKeyAgreement < P11ECDHKeyAgreementImports.const_get :KeyAgreementSpi
    include_class_members P11ECDHKeyAgreementImports
    
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
    
    # private key, if initialized
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    # encoded public point, non-null between doPhase() and generateSecret() only
    attr_accessor :public_value
    alias_method :attr_public_value, :public_value
    undef_method :public_value
    alias_method :attr_public_value=, :public_value=
    undef_method :public_value=
    
    # length of the secret to be derived
    attr_accessor :secret_len
    alias_method :attr_secret_len, :secret_len
    undef_method :secret_len
    alias_method :attr_secret_len=, :secret_len=
    undef_method :secret_len=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @private_key = nil
      @public_value = nil
      @secret_len = 0
      super()
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
    end
    
    typesig { [Key, SecureRandom] }
    # see JCE spec
    def engine_init(key, random)
      if ((key.is_a?(PrivateKey)).equal?(false))
        raise InvalidKeyException.new("Key must be instance of PrivateKey")
      end
      @private_key = P11KeyFactory.convert_key(@token, key, "EC")
      @public_value = nil
    end
    
    typesig { [Key, AlgorithmParameterSpec, SecureRandom] }
    # see JCE spec
    def engine_init(key, params, random)
      if (!(params).nil?)
        raise InvalidAlgorithmParameterException.new("Parameters not supported")
      end
      engine_init(key, random)
    end
    
    typesig { [Key, ::Java::Boolean] }
    # see JCE spec
    def engine_do_phase(key, last_phase)
      if ((@private_key).nil?)
        raise IllegalStateException.new("Not initialized")
      end
      if (!(@public_value).nil?)
        raise IllegalStateException.new("Phase already executed")
      end
      if ((last_phase).equal?(false))
        raise IllegalStateException.new("Only two party agreement supported, lastPhase must be true")
      end
      if ((key.is_a?(ECPublicKey)).equal?(false))
        raise InvalidKeyException.new("Key must be a PublicKey with algorithm EC")
      end
      ec_key = key
      key_len_bits = ec_key.get_params.get_curve.get_field.get_field_size
      @secret_len = (key_len_bits + 7) >> 3
      @public_value = P11ECKeyFactory.get_encoded_public_value(ec_key)
      return nil
    end
    
    typesig { [] }
    # see JCE spec
    def engine_generate_secret
      if (((@private_key).nil?) || ((@public_value).nil?))
        raise IllegalStateException.new("Not initialized correctly")
      end
      session = nil
      begin
        session = @token.get_op_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_GENERIC_SECRET)])
        ck_params = CK_ECDH1_DERIVE_PARAMS.new(CKD_NULL, nil, @public_value)
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, CKK_GENERIC_SECRET, attributes)
        key_id = @token.attr_p11._c_derive_key(session.id, CK_MECHANISM.new(@mechanism, ck_params), @private_key.attr_key_id, attributes)
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE)])
        @token.attr_p11._c_get_attribute_value(session.id, key_id, attributes)
        secret = attributes[0].get_byte_array
        @token.attr_p11._c_destroy_object(session.id, key_id)
        return secret
      rescue PKCS11Exception => e
        raise ProviderException.new("Could not derive key", e)
      ensure
        @public_value = nil
        @token.release_session(session)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # see JCE spec
    def engine_generate_secret(shared_secret, offset)
      if (offset + @secret_len > shared_secret.attr_length)
        raise ShortBufferException.new("Need " + RJava.cast_to_string(@secret_len) + " bytes, only " + RJava.cast_to_string((shared_secret.attr_length - offset)) + " available")
      end
      secret = engine_generate_secret
      System.arraycopy(secret, 0, shared_secret, offset, secret.attr_length)
      return secret.attr_length
    end
    
    typesig { [String] }
    # see JCE spec
    def engine_generate_secret(algorithm)
      if ((algorithm).nil?)
        raise NoSuchAlgorithmException.new("Algorithm must not be null")
      end
      if (((algorithm == "TlsPremasterSecret")).equal?(false))
        raise NoSuchAlgorithmException.new("Only supported for algorithm TlsPremasterSecret")
      end
      return native_generate_secret(algorithm)
    end
    
    typesig { [String] }
    def native_generate_secret(algorithm)
      if (((@private_key).nil?) || ((@public_value).nil?))
        raise IllegalStateException.new("Not initialized correctly")
      end
      key_type = CKK_GENERIC_SECRET
      session = nil
      begin
        session = @token.get_obj_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, key_type)])
        ck_params = CK_ECDH1_DERIVE_PARAMS.new(CKD_NULL, nil, @public_value)
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, key_type, attributes)
        key_id = @token.attr_p11._c_derive_key(session.id, CK_MECHANISM.new(@mechanism, ck_params), @private_key.attr_key_id, attributes)
        len_attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE_LEN)])
        @token.attr_p11._c_get_attribute_value(session.id, key_id, len_attributes)
        key_len = (len_attributes[0].get_long).to_int
        key = P11Key.secret_key(session, key_id, algorithm, key_len << 3, attributes)
        return key
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not derive key", e)
      ensure
        @public_value = nil
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11ecdhkey_agreement, :initialize
  end
  
end
