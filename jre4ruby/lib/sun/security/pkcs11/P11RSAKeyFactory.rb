require "rjava"

# 
# Copyright 2003-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
  module P11RSAKeyFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include ::Sun::Security::Pkcs11::Wrapper
      include_const ::Sun::Security::Rsa, :RSAKeyFactory
    }
  end
  
  # 
  # RSA KeyFactory implemenation.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11RSAKeyFactory < P11RSAKeyFactoryImports.const_get :P11KeyFactory
    include_class_members P11RSAKeyFactoryImports
    
    typesig { [Token, String] }
    def initialize(token, algorithm)
      super(token, algorithm)
    end
    
    typesig { [PublicKey] }
    def impl_translate_public_key(key)
      begin
        if (key.is_a?(RSAPublicKey))
          rsa_key = key
          return generate_public(rsa_key.get_modulus, rsa_key.get_public_exponent)
        else
          if (("X.509" == key.get_format))
            # let SunRsaSign provider parse for us, then recurse
            encoded = key.get_encoded
            key = Sun::Security::Rsa::RSAPublicKeyImpl.new(encoded)
            return impl_translate_public_key(key)
          else
            raise InvalidKeyException.new("PublicKey must be instance " + "of RSAPublicKey or have X.509 encoding")
          end
        end
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not create RSA public key", e)
      end
    end
    
    typesig { [PrivateKey] }
    def impl_translate_private_key(key)
      begin
        if (key.is_a?(RSAPrivateCrtKey))
          rsa_key = key
          return generate_private(rsa_key.get_modulus, rsa_key.get_public_exponent, rsa_key.get_private_exponent, rsa_key.get_prime_p, rsa_key.get_prime_q, rsa_key.get_prime_exponent_p, rsa_key.get_prime_exponent_q, rsa_key.get_crt_coefficient)
        else
          if (key.is_a?(RSAPrivateKey))
            rsa_key_ = key
            return generate_private(rsa_key_.get_modulus, rsa_key_.get_private_exponent)
          else
            if (("PKCS#8" == key.get_format))
              # let SunRsaSign provider parse for us, then recurse
              encoded = key.get_encoded
              key = Sun::Security::Rsa::RSAPrivateCrtKeyImpl.new_key(encoded)
              return impl_translate_private_key(key)
            else
              raise InvalidKeyException.new("Private key must be instance " + "of RSAPrivate(Crt)Key or have PKCS#8 encoding")
            end
          end
        end
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not create RSA private key", e)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA spec
    def engine_generate_public(key_spec)
      self.attr_token.ensure_valid
      if (key_spec.is_a?(X509EncodedKeySpec))
        begin
          encoded = (key_spec).get_encoded
          key = Sun::Security::Rsa::RSAPublicKeyImpl.new(encoded)
          return impl_translate_public_key(key)
        rescue InvalidKeyException => e
          raise InvalidKeySpecException.new("Could not create RSA public key", e)
        end
      end
      if ((key_spec.is_a?(RSAPublicKeySpec)).equal?(false))
        raise InvalidKeySpecException.new("Only RSAPublicKeySpec and " + "X509EncodedKeySpec supported for RSA public keys")
      end
      begin
        rs = key_spec
        return generate_public(rs.get_modulus, rs.get_public_exponent)
      rescue PKCS11Exception => e
        raise InvalidKeySpecException.new("Could not create RSA public key", e_)
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new("Could not create RSA public key", e__)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA spec
    def engine_generate_private(key_spec)
      self.attr_token.ensure_valid
      if (key_spec.is_a?(PKCS8EncodedKeySpec))
        begin
          encoded = (key_spec).get_encoded
          key = Sun::Security::Rsa::RSAPrivateCrtKeyImpl.new_key(encoded)
          return impl_translate_private_key(key)
        rescue GeneralSecurityException => e
          raise InvalidKeySpecException.new("Could not create RSA private key", e)
        end
      end
      begin
        if (key_spec.is_a?(RSAPrivateCrtKeySpec))
          rs = key_spec
          return generate_private(rs.get_modulus, rs.get_public_exponent, rs.get_private_exponent, rs.get_prime_p, rs.get_prime_q, rs.get_prime_exponent_p, rs.get_prime_exponent_q, rs.get_crt_coefficient)
        else
          if (key_spec.is_a?(RSAPrivateKeySpec))
            rs_ = key_spec
            return generate_private(rs_.get_modulus, rs_.get_private_exponent)
          else
            raise InvalidKeySpecException.new("Only RSAPrivate(Crt)KeySpec " + "and PKCS8EncodedKeySpec supported for RSA private keys")
          end
        end
      rescue PKCS11Exception => e
        raise InvalidKeySpecException.new("Could not create RSA private key", e_)
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new("Could not create RSA private key", e__)
      end
    end
    
    typesig { [BigInteger, BigInteger] }
    def generate_public(n, e)
      RSAKeyFactory.check_key_lengths(n.bit_length, e, -1, 64 * 1024)
      attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_PUBLIC_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_RSA), CK_ATTRIBUTE.new(CKA_MODULUS, n), CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT, e), ])
      attributes = self.attr_token.get_attributes(O_IMPORT, CKO_PUBLIC_KEY, CKK_RSA, attributes)
      session = nil
      begin
        session = self.attr_token.get_obj_session
        key_id = self.attr_token.attr_p11._c_create_object(session.id, attributes)
        return P11Key.public_key(session, key_id, "RSA", n.bit_length, attributes)
      ensure
        self.attr_token.release_session(session)
      end
    end
    
    typesig { [BigInteger, BigInteger] }
    def generate_private(n, d)
      RSAKeyFactory.check_key_lengths(n.bit_length, nil, -1, 64 * 1024)
      attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_PRIVATE_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_RSA), CK_ATTRIBUTE.new(CKA_MODULUS, n), CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT, d), ])
      attributes = self.attr_token.get_attributes(O_IMPORT, CKO_PRIVATE_KEY, CKK_RSA, attributes)
      session = nil
      begin
        session = self.attr_token.get_obj_session
        key_id = self.attr_token.attr_p11._c_create_object(session.id, attributes)
        return P11Key.private_key(session, key_id, "RSA", n.bit_length, attributes)
      ensure
        self.attr_token.release_session(session)
      end
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger] }
    def generate_private(n, e, d, p, q, pe, qe, coeff)
      RSAKeyFactory.check_key_lengths(n.bit_length, e, -1, 64 * 1024)
      attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_PRIVATE_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_RSA), CK_ATTRIBUTE.new(CKA_MODULUS, n), CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT, e), CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT, d), CK_ATTRIBUTE.new(CKA_PRIME_1, p), CK_ATTRIBUTE.new(CKA_PRIME_2, q), CK_ATTRIBUTE.new(CKA_EXPONENT_1, pe), CK_ATTRIBUTE.new(CKA_EXPONENT_2, qe), CK_ATTRIBUTE.new(CKA_COEFFICIENT, coeff), ])
      attributes = self.attr_token.get_attributes(O_IMPORT, CKO_PRIVATE_KEY, CKK_RSA, attributes)
      session = nil
      begin
        session = self.attr_token.get_obj_session
        key_id = self.attr_token.attr_p11._c_create_object(session.id, attributes)
        return P11Key.private_key(session, key_id, "RSA", n.bit_length, attributes)
      ensure
        self.attr_token.release_session(session)
      end
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_public_key_spec(key, key_spec, session)
      if (RSAPublicKeySpec.class.is_assignable_from(key_spec))
        session[0] = self.attr_token.get_obj_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_MODULUS), CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT), ])
        self.attr_token.attr_p11._c_get_attribute_value(session[0].id, key.attr_key_id, attributes)
        spec = RSAPublicKeySpec.new(attributes[0].get_big_integer, attributes[1].get_big_integer)
        return spec
      else
        # X.509 handled in superclass
        raise InvalidKeySpecException.new("Only RSAPublicKeySpec and " + "X509EncodedKeySpec supported for RSA public keys")
      end
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_private_key_spec(key, key_spec, session)
      if (RSAPrivateCrtKeySpec.class.is_assignable_from(key_spec))
        session[0] = self.attr_token.get_obj_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_MODULUS), CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT), CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT), CK_ATTRIBUTE.new(CKA_PRIME_1), CK_ATTRIBUTE.new(CKA_PRIME_2), CK_ATTRIBUTE.new(CKA_EXPONENT_1), CK_ATTRIBUTE.new(CKA_EXPONENT_2), CK_ATTRIBUTE.new(CKA_COEFFICIENT), ])
        self.attr_token.attr_p11._c_get_attribute_value(session[0].id, key.attr_key_id, attributes)
        spec = RSAPrivateCrtKeySpec.new(attributes[0].get_big_integer, attributes[1].get_big_integer, attributes[2].get_big_integer, attributes[3].get_big_integer, attributes[4].get_big_integer, attributes[5].get_big_integer, attributes[6].get_big_integer, attributes[7].get_big_integer)
        return spec
      else
        if (RSAPrivateKeySpec.class.is_assignable_from(key_spec))
          session[0] = self.attr_token.get_obj_session
          attributes_ = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_MODULUS), CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT), ])
          self.attr_token.attr_p11._c_get_attribute_value(session[0].id, key.attr_key_id, attributes_)
          spec_ = RSAPrivateKeySpec.new(attributes_[0].get_big_integer, attributes_[1].get_big_integer)
          return spec_
        else
          # PKCS#8 handled in superclass
          raise InvalidKeySpecException.new("Only RSAPrivate(Crt)KeySpec " + "and PKCS8EncodedKeySpec supported for RSA private keys")
        end
      end
    end
    
    typesig { [] }
    def impl_get_software_factory
      return KeyFactory.get_instance("RSA", P11Util.get_sun_rsa_sign_provider)
    end
    
    private
    alias_method :initialize__p11rsakey_factory, :initialize
  end
  
end
