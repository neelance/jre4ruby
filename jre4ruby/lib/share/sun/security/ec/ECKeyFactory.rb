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
module Sun::Security::Ec
  module ECKeyFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ec
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
    }
  end
  
  # KeyFactory for EC keys. Keys must be instances of PublicKey or PrivateKey
  # and getAlgorithm() must return "EC". For such keys, it supports conversion
  # between the following:
  # 
  # For public keys:
  # . PublicKey with an X.509 encoding
  # . ECPublicKey
  # . ECPublicKeySpec
  # . X509EncodedKeySpec
  # 
  # For private keys:
  # . PrivateKey with a PKCS#8 encoding
  # . ECPrivateKey
  # . ECPrivateKeySpec
  # . PKCS8EncodedKeySpec
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ECKeyFactory < ECKeyFactoryImports.const_get :KeyFactorySpi
    include_class_members ECKeyFactoryImports
    
    class_module.module_eval {
      when_class_loaded do
        p = Class.new(Provider.class == Class ? Provider : Object) do
          extend LocalClass
          include_class_members ECKeyFactory
          include Provider if Provider.class == Module
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, "SunEC-Internal", 1.0, nil)
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ECKeyFactory
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            p.put("KeyFactory.EC", "sun.security.ec.ECKeyFactory")
            p.put("AlgorithmParameters.EC", "sun.security.ec.ECParameters")
            p.put("Alg.Alias.AlgorithmParameters.1.2.840.10045.2.1", "EC")
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        begin
          const_set :INSTANCE, KeyFactory.get_instance("EC", p)
        rescue NoSuchAlgorithmException => e
          raise RuntimeException.new(e)
        end
        const_set :EcInternalProvider, p
      end
    }
    
    typesig { [] }
    def initialize
      super()
      # empty
    end
    
    class_module.module_eval {
      typesig { [Key] }
      # Static method to convert Key into a useable instance of
      # ECPublicKey or ECPrivateKey. Check the key and convert it
      # to a Sun key if necessary. If the key is not an EC key
      # or cannot be used, throw an InvalidKeyException.
      # 
      # The difference between this method and engineTranslateKey() is that
      # we do not convert keys of other providers that are already an
      # instance of ECPublicKey or ECPrivateKey.
      # 
      # To be used by future Java ECDSA and ECDH implementations.
      def to_eckey(key)
        if (key.is_a?(ECKey))
          ec_key = key
          check_key(ec_key)
          return ec_key
        else
          return INSTANCE.translate_key(key)
        end
      end
      
      typesig { [ECKey] }
      # Check that the given EC key is valid.
      def check_key(key)
        # check for subinterfaces, omit additional checks for our keys
        if (key.is_a?(ECPublicKey))
          if (key.is_a?(ECPublicKeyImpl))
            return
          end
        else
          if (key.is_a?(ECPrivateKey))
            if (key.is_a?(ECPrivateKeyImpl))
              return
            end
          else
            raise InvalidKeyException.new("Neither a public nor a private key")
          end
        end
        # ECKey does not extend Key, so we need to do a cast
        key_alg = (key).get_algorithm
        if (((key_alg == "EC")).equal?(false))
          raise InvalidKeyException.new("Not an EC key: " + key_alg)
        end
        # XXX further sanity checks about whether this key uses supported
        # fields, point formats, etc. would go here
      end
    }
    
    typesig { [Key] }
    # Translate an EC key into a Sun EC key. If conversion is
    # not possible, throw an InvalidKeyException.
    # See also JCA doc.
    def engine_translate_key(key)
      if ((key).nil?)
        raise InvalidKeyException.new("Key must not be null")
      end
      key_alg = key.get_algorithm
      if (((key_alg == "EC")).equal?(false))
        raise InvalidKeyException.new("Not an EC key: " + key_alg)
      end
      if (key.is_a?(PublicKey))
        return impl_translate_public_key(key)
      else
        if (key.is_a?(PrivateKey))
          return impl_translate_private_key(key)
        else
          raise InvalidKeyException.new("Neither a public nor a private key")
        end
      end
    end
    
    typesig { [KeySpec] }
    # see JCA doc
    def engine_generate_public(key_spec)
      begin
        return impl_generate_public(key_spec)
      rescue InvalidKeySpecException => e
        raise e
      rescue GeneralSecurityException => e
        raise InvalidKeySpecException.new(e)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA doc
    def engine_generate_private(key_spec)
      begin
        return impl_generate_private(key_spec)
      rescue InvalidKeySpecException => e
        raise e
      rescue GeneralSecurityException => e
        raise InvalidKeySpecException.new(e)
      end
    end
    
    typesig { [PublicKey] }
    # internal implementation of translateKey() for public keys. See JCA doc
    def impl_translate_public_key(key)
      if (key.is_a?(ECPublicKey))
        if (key.is_a?(ECPublicKeyImpl))
          return key
        end
        ec_key = key
        return ECPublicKeyImpl.new(ec_key.get_w, ec_key.get_params)
      else
        if (("X.509" == key.get_format))
          encoded = key.get_encoded
          return ECPublicKeyImpl.new(encoded)
        else
          raise InvalidKeyException.new("Public keys must be instance " + "of ECPublicKey or have X.509 encoding")
        end
      end
    end
    
    typesig { [PrivateKey] }
    # internal implementation of translateKey() for private keys. See JCA doc
    def impl_translate_private_key(key)
      if (key.is_a?(ECPrivateKey))
        if (key.is_a?(ECPrivateKeyImpl))
          return key
        end
        ec_key = key
        return ECPrivateKeyImpl.new(ec_key.get_s, ec_key.get_params)
      else
        if (("PKCS#8" == key.get_format))
          return ECPrivateKeyImpl.new(key.get_encoded)
        else
          raise InvalidKeyException.new("Private keys must be instance " + "of ECPrivateKey or have PKCS#8 encoding")
        end
      end
    end
    
    typesig { [KeySpec] }
    # internal implementation of generatePublic. See JCA doc
    def impl_generate_public(key_spec)
      if (key_spec.is_a?(X509EncodedKeySpec))
        x509spec = key_spec
        return ECPublicKeyImpl.new(x509spec.get_encoded)
      else
        if (key_spec.is_a?(ECPublicKeySpec))
          ec_spec = key_spec
          return ECPublicKeyImpl.new(ec_spec.get_w, ec_spec.get_params)
        else
          raise InvalidKeySpecException.new("Only ECPublicKeySpec " + "and X509EncodedKeySpec supported for EC public keys")
        end
      end
    end
    
    typesig { [KeySpec] }
    # internal implementation of generatePrivate. See JCA doc
    def impl_generate_private(key_spec)
      if (key_spec.is_a?(PKCS8EncodedKeySpec))
        pkcs_spec = key_spec
        return ECPrivateKeyImpl.new(pkcs_spec.get_encoded)
      else
        if (key_spec.is_a?(ECPrivateKeySpec))
          ec_spec = key_spec
          return ECPrivateKeyImpl.new(ec_spec.get_s, ec_spec.get_params)
        else
          raise InvalidKeySpecException.new("Only ECPrivateKeySpec " + "and PKCS8EncodedKeySpec supported for EC private keys")
        end
      end
    end
    
    typesig { [Key, Class] }
    def engine_get_key_spec(key, key_spec)
      begin
        # convert key to one of our keys
        # this also verifies that the key is a valid EC key and ensures
        # that the encoding is X.509/PKCS#8 for public/private keys
        key = engine_translate_key(key)
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new(e)
      end
      if (key.is_a?(ECPublicKey))
        ec_key = key
        if (ECPublicKeySpec.is_assignable_from(key_spec))
          return ECPublicKeySpec.new(ec_key.get_w, ec_key.get_params)
        else
          if (X509EncodedKeySpec.is_assignable_from(key_spec))
            return X509EncodedKeySpec.new(key.get_encoded)
          else
            raise InvalidKeySpecException.new("KeySpec must be ECPublicKeySpec or " + "X509EncodedKeySpec for EC public keys")
          end
        end
      else
        if (key.is_a?(ECPrivateKey))
          if (PKCS8EncodedKeySpec.is_assignable_from(key_spec))
            return PKCS8EncodedKeySpec.new(key.get_encoded)
          else
            if (ECPrivateKeySpec.is_assignable_from(key_spec))
              ec_key = key
              return ECPrivateKeySpec.new(ec_key.get_s, ec_key.get_params)
            else
              raise InvalidKeySpecException.new("KeySpec must be ECPrivateKeySpec or " + "PKCS8EncodedKeySpec for EC private keys")
            end
          end
        else
          # should not occur, caught in engineTranslateKey()
          raise InvalidKeySpecException.new("Neither public nor private key")
        end
      end
    end
    
    private
    alias_method :initialize__eckey_factory, :initialize
  end
  
end
