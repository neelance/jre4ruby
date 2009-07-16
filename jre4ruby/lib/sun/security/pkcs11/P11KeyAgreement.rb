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
  module P11KeyAgreementImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Spec
      include ::Javax::Crypto
      include ::Javax::Crypto::Interfaces
      include ::Javax::Crypto::Spec
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # KeyAgreement implementation class. This class currently supports
  # DH.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11KeyAgreement < P11KeyAgreementImports.const_get :KeyAgreementSpi
    include_class_members P11KeyAgreementImports
    
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
    
    # other sides public value ("y"), if doPhase() already called
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
    
    # KeyAgreement from SunJCE as fallback for > 2 party agreement
    attr_accessor :multi_party_agreement
    alias_method :attr_multi_party_agreement, :multi_party_agreement
    undef_method :multi_party_agreement
    alias_method :attr_multi_party_agreement=, :multi_party_agreement=
    undef_method :multi_party_agreement=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @private_key = nil
      @public_value = nil
      @secret_len = 0
      @multi_party_agreement = nil
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
      @private_key = P11KeyFactory.convert_key(@token, key, @algorithm)
      @public_value = nil
      @multi_party_agreement = nil
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
      # PKCS#11 only allows key agreement between 2 parties
      # JCE allows >= 2 parties. To support that case (for compatibility
      # and to pass JCK), fall back to SunJCE in this case.
      # NOTE that we initialize using the P11Key, which will fail if it
      # is sensitive/unextractable. However, this is not an issue in the
      # compatibility configuration, which is all we are targeting here.
      if ((!(@multi_party_agreement).nil?) || ((last_phase).equal?(false)))
        if ((@multi_party_agreement).nil?)
          begin
            @multi_party_agreement = KeyAgreement.get_instance("DH", P11Util.get_sun_jce_provider)
            @multi_party_agreement.init(@private_key)
          rescue NoSuchAlgorithmException => e
            raise InvalidKeyException.new("Could not initialize multi party agreement", e)
          end
        end
        return @multi_party_agreement.do_phase(key, last_phase)
      end
      if (((key.is_a?(PublicKey)).equal?(false)) || (((key.get_algorithm == @algorithm)).equal?(false)))
        raise InvalidKeyException.new("Key must be a PublicKey with algorithm DH")
      end
      p = nil
      g = nil
      y = nil
      if (key.is_a?(DHPublicKey))
        dh_key = key
        y = dh_key.get_y
        params = dh_key.get_params
        p = params.get_p
        g = params.get_g
      else
        # normally, DH PublicKeys will always implement DHPublicKey
        # just in case not, attempt conversion
        kf = P11DHKeyFactory.new(@token, "DH")
        begin
          spec = kf.engine_get_key_spec(key, DHPublicKeySpec.class)
          y = spec.get_y
          p = spec.get_p
          g = spec.get_g
        rescue InvalidKeySpecException => e
          raise InvalidKeyException.new("Could not obtain key values", e_)
        end
      end
      # if parameters of private key are accessible, verify that
      # they match parameters of public key
      # XXX p and g should always be readable, even if the key is sensitive
      if (@private_key.is_a?(DHPrivateKey))
        dh_key_ = @private_key
        params_ = dh_key_.get_params
        if ((((p == params_.get_p)).equal?(false)) || (((g == params_.get_g)).equal?(false)))
          raise InvalidKeyException.new("PublicKey DH parameters must match PrivateKey DH parameters")
        end
      end
      @public_value = y
      # length of the secret is length of key
      @secret_len = (p.bit_length + 7) >> 3
      return nil
    end
    
    typesig { [] }
    # see JCE spec
    def engine_generate_secret
      if (!(@multi_party_agreement).nil?)
        val = @multi_party_agreement.generate_secret
        @multi_party_agreement = nil
        return val
      end
      if (((@private_key).nil?) || ((@public_value).nil?))
        raise IllegalStateException.new("Not initialized correctly")
      end
      session = nil
      begin
        session = @token.get_op_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_GENERIC_SECRET), ])
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, CKK_GENERIC_SECRET, attributes)
        key_id = @token.attr_p11._c_derive_key(session.id, CK_MECHANISM.new(@mechanism, @public_value), @private_key.attr_key_id, attributes)
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE)])
        @token.attr_p11._c_get_attribute_value(session.id, key_id, attributes)
        secret = attributes[0].get_byte_array
        @token.attr_p11._c_destroy_object(session.id, key_id)
        # trim leading 0x00 bytes per JCE convention
        return P11Util.trim_zeroes(secret)
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
      if (!(@multi_party_agreement).nil?)
        n = @multi_party_agreement.generate_secret(shared_secret, offset)
        @multi_party_agreement = nil
        return n
      end
      if (offset + @secret_len > shared_secret.attr_length)
        raise ShortBufferException.new("Need " + (@secret_len).to_s + " bytes, only " + ((shared_secret.attr_length - offset)).to_s + " available")
      end
      secret = engine_generate_secret
      System.arraycopy(secret, 0, shared_secret, offset, secret.attr_length)
      return secret.attr_length
    end
    
    typesig { [String] }
    # see JCE spec
    def engine_generate_secret(algorithm)
      if (!(@multi_party_agreement).nil?)
        key = @multi_party_agreement.generate_secret(algorithm)
        @multi_party_agreement = nil
        return key
      end
      if ((algorithm).nil?)
        raise NoSuchAlgorithmException.new("Algorithm must not be null")
      end
      if ((algorithm == "TlsPremasterSecret"))
        # For now, only perform native derivation for TlsPremasterSecret
        # as that is required for FIPS compliance.
        # For other algorithms, there are unresolved issues regarding
        # how this should work in JCE plus a Solaris truncation bug.
        # (bug not yet filed).
        return native_generate_secret(algorithm)
      end
      secret = engine_generate_secret
      # Maintain compatibility for SunJCE:
      # verify secret length is sensible for algorithm / truncate
      # return generated key itself if possible
      key_len = 0
      if (algorithm.equals_ignore_case("DES"))
        key_len = 8
      else
        if (algorithm.equals_ignore_case("DESede"))
          key_len = 24
        else
          if (algorithm.equals_ignore_case("Blowfish"))
            key_len = Math.min(56, secret.attr_length)
          else
            if (algorithm.equals_ignore_case("TlsPremasterSecret"))
              key_len = secret.attr_length
            else
              raise NoSuchAlgorithmException.new("Unknown algorithm " + algorithm)
            end
          end
        end
      end
      if (secret.attr_length < key_len)
        raise InvalidKeyException.new("Secret too short")
      end
      if (algorithm.equals_ignore_case("DES") || algorithm.equals_ignore_case("DESede"))
        i = 0
        while i < key_len
          P11SecretKeyFactory.fix_desparity(secret, i)
          i += 8
        end
      end
      return SecretKeySpec.new(secret, 0, key_len, algorithm)
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
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, key_type), ])
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, key_type, attributes)
        key_id = @token.attr_p11._c_derive_key(session.id, CK_MECHANISM.new(@mechanism, @public_value), @private_key.attr_key_id, attributes)
        len_attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE_LEN), ])
        @token.attr_p11._c_get_attribute_value(session.id, key_id, len_attributes)
        key_len = RJava.cast_to_int(len_attributes[0].get_long)
        key = P11Key.secret_key(session, key_id, algorithm, key_len << 3, attributes)
        if (("RAW" == key.get_format))
          # Workaround for Solaris bug 6318543.
          # Strip leading zeroes ourselves if possible (key not sensitive).
          # This should be removed once the Solaris fix is available
          # as here we always retrieve the CKA_VALUE even for tokens
          # that do not have that bug.
          key_bytes = key.get_encoded
          new_bytes = P11Util.trim_zeroes(key_bytes)
          if (!(key_bytes).equal?(new_bytes))
            key = SecretKeySpec.new(new_bytes, algorithm)
          end
        end
        return key
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not derive key", e)
      ensure
        @public_value = nil
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11key_agreement, :initialize
  end
  
end
