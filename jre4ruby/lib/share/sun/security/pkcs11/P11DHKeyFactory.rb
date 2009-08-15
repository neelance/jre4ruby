require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module P11DHKeyFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Spec
      include ::Javax::Crypto::Interfaces
      include ::Javax::Crypto::Spec
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # DH KeyFactory implemenation.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11DHKeyFactory < P11DHKeyFactoryImports.const_get :P11KeyFactory
    include_class_members P11DHKeyFactoryImports
    
    typesig { [Token, String] }
    def initialize(token, algorithm)
      super(token, algorithm)
    end
    
    typesig { [PublicKey] }
    def impl_translate_public_key(key)
      begin
        if (key.is_a?(DHPublicKey))
          dh_key = key
          params = dh_key.get_params
          return generate_public(dh_key.get_y, params.get_p, params.get_g)
        else
          if (("X.509" == key.get_format))
            # let SunJCE provider parse for us, then recurse
            begin
              factory = impl_get_software_factory
              key = factory.translate_key(key)
              return impl_translate_public_key(key)
            rescue GeneralSecurityException => e
              raise InvalidKeyException.new("Could not translate key", e)
            end
          else
            raise InvalidKeyException.new("PublicKey must be instance " + "of DHPublicKey or have X.509 encoding")
          end
        end
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not create DH public key", e)
      end
    end
    
    typesig { [PrivateKey] }
    def impl_translate_private_key(key)
      begin
        if (key.is_a?(DHPrivateKey))
          dh_key = key
          params = dh_key.get_params
          return generate_private(dh_key.get_x, params.get_p, params.get_g)
        else
          if (("PKCS#8" == key.get_format))
            # let SunJCE provider parse for us, then recurse
            begin
              factory = impl_get_software_factory
              key = factory.translate_key(key)
              return impl_translate_private_key(key)
            rescue GeneralSecurityException => e
              raise InvalidKeyException.new("Could not translate key", e)
            end
          else
            raise InvalidKeyException.new("PrivateKey must be instance " + "of DHPrivateKey or have PKCS#8 encoding")
          end
        end
      rescue PKCS11Exception => e
        raise InvalidKeyException.new("Could not create DH private key", e)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA spec
    def engine_generate_public(key_spec)
      self.attr_token.ensure_valid
      if (key_spec.is_a?(X509EncodedKeySpec))
        begin
          factory = impl_get_software_factory
          key = factory.generate_public(key_spec)
          return impl_translate_public_key(key)
        rescue GeneralSecurityException => e
          raise InvalidKeySpecException.new("Could not create DH public key", e)
        end
      end
      if ((key_spec.is_a?(DHPublicKeySpec)).equal?(false))
        raise InvalidKeySpecException.new("Only DHPublicKeySpec and " + "X509EncodedKeySpec supported for DH public keys")
      end
      begin
        ds = key_spec
        return generate_public(ds.get_y, ds.get_p, ds.get_g)
      rescue PKCS11Exception => e
        raise InvalidKeySpecException.new("Could not create DH public key", e)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA spec
    def engine_generate_private(key_spec)
      self.attr_token.ensure_valid
      if (key_spec.is_a?(PKCS8EncodedKeySpec))
        begin
          factory = impl_get_software_factory
          key = factory.generate_private(key_spec)
          return impl_translate_private_key(key)
        rescue GeneralSecurityException => e
          raise InvalidKeySpecException.new("Could not create DH private key", e)
        end
      end
      if ((key_spec.is_a?(DHPrivateKeySpec)).equal?(false))
        raise InvalidKeySpecException.new("Only DHPrivateKeySpec and " + "PKCS8EncodedKeySpec supported for DH private keys")
      end
      begin
        ds = key_spec
        return generate_private(ds.get_x, ds.get_p, ds.get_g)
      rescue PKCS11Exception => e
        raise InvalidKeySpecException.new("Could not create DH private key", e)
      end
    end
    
    typesig { [BigInteger, BigInteger, BigInteger] }
    def generate_public(y, p, g)
      attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_PUBLIC_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_DH), CK_ATTRIBUTE.new(CKA_VALUE, y), CK_ATTRIBUTE.new(CKA_PRIME, p), CK_ATTRIBUTE.new(CKA_BASE, g), ])
      attributes = self.attr_token.get_attributes(O_IMPORT, CKO_PUBLIC_KEY, CKK_DH, attributes)
      session = nil
      begin
        session = self.attr_token.get_obj_session
        key_id = self.attr_token.attr_p11._c_create_object(session.id, attributes)
        return P11Key.public_key(session, key_id, "DH", p.bit_length, attributes)
      ensure
        self.attr_token.release_session(session)
      end
    end
    
    typesig { [BigInteger, BigInteger, BigInteger] }
    def generate_private(x, p, g)
      attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_PRIVATE_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_DH), CK_ATTRIBUTE.new(CKA_VALUE, x), CK_ATTRIBUTE.new(CKA_PRIME, p), CK_ATTRIBUTE.new(CKA_BASE, g), ])
      attributes = self.attr_token.get_attributes(O_IMPORT, CKO_PRIVATE_KEY, CKK_DH, attributes)
      session = nil
      begin
        session = self.attr_token.get_obj_session
        key_id = self.attr_token.attr_p11._c_create_object(session.id, attributes)
        return P11Key.private_key(session, key_id, "DH", p.bit_length, attributes)
      ensure
        self.attr_token.release_session(session)
      end
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_public_key_spec(key, key_spec, session)
      if (DHPublicKeySpec.is_assignable_from(key_spec))
        session[0] = self.attr_token.get_obj_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE), CK_ATTRIBUTE.new(CKA_PRIME), CK_ATTRIBUTE.new(CKA_BASE), ])
        self.attr_token.attr_p11._c_get_attribute_value(session[0].id, key.attr_key_id, attributes)
        spec = DHPublicKeySpec.new(attributes[0].get_big_integer, attributes[1].get_big_integer, attributes[2].get_big_integer)
        return spec
      else
        # X.509 handled in superclass
        raise InvalidKeySpecException.new("Only DHPublicKeySpec and " + "X509EncodedKeySpec supported for DH public keys")
      end
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_private_key_spec(key, key_spec, session)
      if (DHPrivateKeySpec.is_assignable_from(key_spec))
        session[0] = self.attr_token.get_obj_session
        attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE), CK_ATTRIBUTE.new(CKA_PRIME), CK_ATTRIBUTE.new(CKA_BASE), ])
        self.attr_token.attr_p11._c_get_attribute_value(session[0].id, key.attr_key_id, attributes)
        spec = DHPrivateKeySpec.new(attributes[0].get_big_integer, attributes[1].get_big_integer, attributes[2].get_big_integer)
        return spec
      else
        # PKCS#8 handled in superclass
        raise InvalidKeySpecException.new("Only DHPrivateKeySpec " + "and PKCS8EncodedKeySpec supported for DH private keys")
      end
    end
    
    typesig { [] }
    def impl_get_software_factory
      return KeyFactory.get_instance("DH", P11Util.get_sun_jce_provider)
    end
    
    private
    alias_method :initialize__p11dhkey_factory, :initialize
  end
  
end
