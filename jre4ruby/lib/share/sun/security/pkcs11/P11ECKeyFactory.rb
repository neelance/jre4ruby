require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module P11ECKeyFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include_const ::Sun::Security::Ec, :ECPublicKeyImpl
      include_const ::Sun::Security::Ec, :ECParameters
      include_const ::Sun::Security::Ec, :NamedCurve
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # EC KeyFactory implemenation.
  # 
  # @author  Andreas Sterbenz
  # @since   1.6
  class P11ECKeyFactory < P11ECKeyFactoryImports.const_get :P11KeyFactory
    include_class_members P11ECKeyFactoryImports
    
    typesig { [Token, String] }
    def initialize(token, algorithm)
      super(token, algorithm)
    end
    
    class_module.module_eval {
      typesig { [String] }
      def get_ecparameter_spec(name)
        return NamedCurve.get_ecparameter_spec(name)
      end
      
      typesig { [::Java::Int] }
      def get_ecparameter_spec(key_size)
        return NamedCurve.get_ecparameter_spec(key_size)
      end
      
      typesig { [ECParameterSpec] }
      # Check that spec is a known supported curve and convert it to our
      # ECParameterSpec subclass. If not possible, return null.
      def get_ecparameter_spec(spec)
        return ECParameters.get_named_curve(spec)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def decode_parameters(params)
        return ECParameters.decode_parameters(params)
      end
      
      typesig { [ECParameterSpec] }
      def encode_parameters(params)
        return ECParameters.encode_parameters(params)
      end
      
      typesig { [Array.typed(::Java::Byte), EllipticCurve] }
      def decode_point(encoded, curve)
        return ECParameters.decode_point(encoded, curve)
      end
      
      typesig { [PublicKey] }
      # Used by ECDH KeyAgreement
      def get_encoded_public_value(key)
        if (key.is_a?(ECPublicKeyImpl))
          return (key).get_encoded_public_value
        else
          if (key.is_a?(ECPublicKey))
            ec_key = key
            w = ec_key.get_w
            params = ec_key.get_params
            return ECParameters.encode_point(w, params.get_curve)
          else
            # should never occur
            raise InvalidKeyException.new("Key class not yet supported: " + RJava.cast_to_string(key.get_class.get_name))
          end
        end
      end
    }
    
    typesig { [PublicKey] }
    def impl_translate_public_key(key)
      begin
        if (key.is_a?(ECPublicKey))
          ec_key = key
          return generate_public(ec_key.get_w, ec_key.get_params)
        else
          if (("X.509" == key.get_format))
            # let Sun provider parse for us, then recurse
            encoded = key.get_encoded
            key = Sun::Security::Ec::ECPublicKeyImpl.new(encoded)
            return impl_translate_public_key(key)
          else
            raise InvalidKeyException.new("PublicKey must be instance " + "of ECPublicKey or have X.509 encoding")
          end
        end
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not create EC public key", e)
      end
    end
    
    typesig { [PrivateKey] }
    def impl_translate_private_key(key)
      begin
        if (key.is_a?(ECPrivateKey))
          ec_key = key
          return generate_private(ec_key.get_s, ec_key.get_params)
        else
          if (("PKCS#8" == key.get_format))
            # let Sun provider parse for us, then recurse
            encoded = key.get_encoded
            key = Sun::Security::Ec::ECPrivateKeyImpl.new(encoded)
            return impl_translate_private_key(key)
          else
            raise InvalidKeyException.new("PrivateKey must be instance " + "of ECPrivateKey or have PKCS#8 encoding")
          end
        end
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not create EC private key", e)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA spec
    def engine_generate_public(key_spec)
      self.attr_token.ensure_valid
      if (key_spec.is_a?(X509EncodedKeySpec))
        begin
          encoded = (key_spec).get_encoded
          key = Sun::Security::Ec::ECPublicKeyImpl.new(encoded)
          return impl_translate_public_key(key)
        rescue InvalidKeyException => e
          raise InvalidKeySpecException.new("Could not create EC public key", e)
        end
      end
      if ((key_spec.is_a?(ECPublicKeySpec)).equal?(false))
        raise InvalidKeySpecException.new("Only ECPublicKeySpec and " + "X509EncodedKeySpec supported for EC public keys")
      end
      begin
        ec = key_spec
        return generate_public(ec.get_w, ec.get_params)
      rescue PKCS11Exception => e
        raise InvalidKeySpecException.new("Could not create EC public key", e)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA spec
    def engine_generate_private(key_spec)
      self.attr_token.ensure_valid
      if (key_spec.is_a?(PKCS8EncodedKeySpec))
        begin
          encoded = (key_spec).get_encoded
          key = Sun::Security::Ec::ECPrivateKeyImpl.new(encoded)
          return impl_translate_private_key(key)
        rescue GeneralSecurityException => e
          raise InvalidKeySpecException.new("Could not create EC private key", e)
        end
      end
      if ((key_spec.is_a?(ECPrivateKeySpec)).equal?(false))
        raise InvalidKeySpecException.new("Only ECPrivateKeySpec and " + "PKCS8EncodedKeySpec supported for EC private keys")
      end
      begin
        ec = key_spec
        return generate_private(ec.get_s, ec.get_params)
      rescue PKCS11Exception => e
        raise InvalidKeySpecException.new("Could not create EC private key", e)
      end
    end
    
    typesig { [ECPoint, ECParameterSpec] }
    def generate_public(point, params)
      encoded_params = ECParameters.encode_parameters(params)
      encoded_point = ECParameters.encode_point(point, params.get_curve)
      attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_PUBLIC_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_EC), CK_ATTRIBUTE.new(CKA_EC_POINT, encoded_point), CK_ATTRIBUTE.new(CKA_EC_PARAMS, encoded_params), ])
      attributes = self.attr_token.get_attributes(O_IMPORT, CKO_PUBLIC_KEY, CKK_EC, attributes)
      session = nil
      begin
        session = self.attr_token.get_obj_session
        key_id = self.attr_token.attr_p11._c_create_object(session.id, attributes)
        return P11Key.public_key(session, key_id, "EC", params.get_curve.get_field.get_field_size, attributes)
      ensure
        self.attr_token.release_session(session)
      end
    end
    
    typesig { [BigInteger, ECParameterSpec] }
    def generate_private(s, params)
      encoded_params = ECParameters.encode_parameters(params)
      attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_PRIVATE_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_EC), CK_ATTRIBUTE.new(CKA_VALUE, s), CK_ATTRIBUTE.new(CKA_EC_PARAMS, encoded_params), ])
      attributes = self.attr_token.get_attributes(O_IMPORT, CKO_PRIVATE_KEY, CKK_EC, attributes)
      session = nil
      begin
        session = self.attr_token.get_obj_session
        key_id = self.attr_token.attr_p11._c_create_object(session.id, attributes)
        return P11Key.private_key(session, key_id, "EC", params.get_curve.get_field.get_field_size, attributes)
      ensure
        self.attr_token.release_session(session)
      end
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_public_key_spec(key, key_spec, session)
      if (ECPublicKeySpec.is_assignable_from(key_spec))
        session[0] = self.attr_token.get_obj_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_EC_POINT), CK_ATTRIBUTE.new(CKA_EC_PARAMS), ])
        self.attr_token.attr_p11._c_get_attribute_value(session[0].id, key.attr_key_id, attributes)
        begin
          params = decode_parameters(attributes[1].get_byte_array)
          point = decode_point(attributes[0].get_byte_array, params.get_curve)
          return ECPublicKeySpec.new(point, params)
        rescue IOException => e
          raise InvalidKeySpecException.new("Could not parse key", e)
        end
      else
        # X.509 handled in superclass
        raise InvalidKeySpecException.new("Only ECPublicKeySpec and " + "X509EncodedKeySpec supported for EC public keys")
      end
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_private_key_spec(key, key_spec, session)
      if (ECPrivateKeySpec.is_assignable_from(key_spec))
        session[0] = self.attr_token.get_obj_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE), CK_ATTRIBUTE.new(CKA_EC_PARAMS), ])
        self.attr_token.attr_p11._c_get_attribute_value(session[0].id, key.attr_key_id, attributes)
        begin
          params = decode_parameters(attributes[1].get_byte_array)
          return ECPrivateKeySpec.new(attributes[0].get_big_integer, params)
        rescue IOException => e
          raise InvalidKeySpecException.new("Could not parse key", e)
        end
      else
        # PKCS#8 handled in superclass
        raise InvalidKeySpecException.new("Only ECPrivateKeySpec " + "and PKCS8EncodedKeySpec supported for EC private keys")
      end
    end
    
    typesig { [] }
    def impl_get_software_factory
      return Sun::Security::Ec::ECKeyFactory::INSTANCE
    end
    
    private
    alias_method :initialize__p11eckey_factory, :initialize
  end
  
end
