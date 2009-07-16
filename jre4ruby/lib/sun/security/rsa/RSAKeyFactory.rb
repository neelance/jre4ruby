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
module Sun::Security::Rsa
  module RSAKeyFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # 
  # KeyFactory for RSA keys. Keys must be instances of PublicKey or PrivateKey
  # and getAlgorithm() must return "RSA". For such keys, it supports conversion
  # between the following:
  # 
  # For public keys:
  # . PublicKey with an X.509 encoding
  # . RSAPublicKey
  # . RSAPublicKeySpec
  # . X509EncodedKeySpec
  # 
  # For private keys:
  # . PrivateKey with a PKCS#8 encoding
  # . RSAPrivateKey
  # . RSAPrivateCrtKey
  # . RSAPrivateKeySpec
  # . RSAPrivateCrtKeySpec
  # . PKCS8EncodedKeySpec
  # (of course, CRT variants only for CRT keys)
  # 
  # Note: as always, RSA keys should be at least 512 bits long
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSAKeyFactory < RSAKeyFactoryImports.const_get :KeyFactorySpi
    include_class_members RSAKeyFactoryImports
    
    class_module.module_eval {
      const_set_lazy(:RsaPublicKeySpecClass) { RSAPublicKeySpec.class }
      const_attr_reader  :RsaPublicKeySpecClass
      
      const_set_lazy(:RsaPrivateKeySpecClass) { RSAPrivateKeySpec.class }
      const_attr_reader  :RsaPrivateKeySpecClass
      
      const_set_lazy(:RsaPrivateCrtKeySpecClass) { RSAPrivateCrtKeySpec.class }
      const_attr_reader  :RsaPrivateCrtKeySpecClass
      
      const_set_lazy(:X509KeySpecClass) { X509EncodedKeySpec.class }
      const_attr_reader  :X509KeySpecClass
      
      const_set_lazy(:Pkcs8KeySpecClass) { PKCS8EncodedKeySpec.class }
      const_attr_reader  :Pkcs8KeySpecClass
      
      const_set_lazy(:MIN_MODLEN) { 512 }
      const_attr_reader  :MIN_MODLEN
      
      const_set_lazy(:MAX_MODLEN) { 16384 }
      const_attr_reader  :MAX_MODLEN
      
      # 
      # If the modulus length is above this value, restrict the size of
      # the exponent to something that can be reasonably computed.  We
      # could simply hardcode the exp len to something like 64 bits, but
      # this approach allows flexibility in case impls would like to use
      # larger module and exponent values.
      const_set_lazy(:MAX_MODLEN_RESTRICT_EXP) { 3072 }
      const_attr_reader  :MAX_MODLEN_RESTRICT_EXP
      
      const_set_lazy(:MAX_RESTRICTED_EXPLEN) { 64 }
      const_attr_reader  :MAX_RESTRICTED_EXPLEN
      
      const_set_lazy(:RestrictExpLen) { "true".equals_ignore_case(AccessController.do_privileged(GetPropertyAction.new("sun.security.rsa.restrictRSAExponent", "true"))) }
      const_attr_reader  :RestrictExpLen
      
      # instance used for static translateKey();
      const_set_lazy(:INSTANCE) { RSAKeyFactory.new }
      const_attr_reader  :INSTANCE
    }
    
    typesig { [] }
    def initialize
      super()
      # empty
    end
    
    class_module.module_eval {
      typesig { [Key] }
      # 
      # Static method to convert Key into an instance of RSAPublicKeyImpl
      # or RSAPrivate(Crt)KeyImpl. If the key is not an RSA key or cannot be
      # used, throw an InvalidKeyException.
      # 
      # Used by RSASignature and RSACipher.
      def to_rsakey(key)
        if ((key.is_a?(RSAPrivateKeyImpl)) || (key.is_a?(RSAPrivateCrtKeyImpl)) || (key.is_a?(RSAPublicKeyImpl)))
          return key
        else
          return INSTANCE.engine_translate_key(key)
        end
      end
      
      typesig { [::Java::Int, BigInteger] }
      # 
      # Single test entry point for all of the mechanisms in the SunRsaSign
      # provider (RSA*KeyImpls).  All of the tests are the same.
      # 
      # For compatibility, we round up to the nearest byte here:
      # some Key impls might pass in a value within a byte of the
      # real value.
      def check_rsaprovider_key_lengths(modulus_len, exponent)
        check_key_lengths(((modulus_len + 7) & ~7), exponent, RSAKeyFactory::MIN_MODLEN, JavaInteger::MAX_VALUE)
      end
      
      typesig { [::Java::Int, BigInteger, ::Java::Int, ::Java::Int] }
      # 
      # Check the length of an RSA key modulus/exponent to make sure it
      # is not too short or long.  Some impls have their own min and
      # max key sizes that may or may not match with a system defined value.
      # 
      # @param modulusLen the bit length of the RSA modulus.
      # @param exponent the RSA exponent
      # @param minModulusLen if > 0, check to see if modulusLen is at
      # least this long, otherwise unused.
      # @param maxModulusLen caller will allow this max number of bits.
      # Allow the smaller of the system-defined maximum and this param.
      # 
      # @throws InvalidKeyException if any of the values are unacceptable.
      def check_key_lengths(modulus_len, exponent, min_modulus_len, max_modulus_len)
        if ((min_modulus_len > 0) && (modulus_len < (min_modulus_len)))
          raise InvalidKeyException.new("RSA keys must be at least " + (min_modulus_len).to_s + " bits long")
        end
        # Even though our policy file may allow this, we don't want
        # either value (mod/exp) to be too big.
        max_len = Math.min(max_modulus_len, MAX_MODLEN)
        # If a RSAPrivateKey/RSAPublicKey, make sure the
        # modulus len isn't too big.
        if (modulus_len > max_len)
          raise InvalidKeyException.new("RSA keys must be no longer than " + (max_len).to_s + " bits")
        end
        # If a RSAPublicKey, make sure the exponent isn't too big.
        if (RestrictExpLen && (!(exponent).nil?) && (modulus_len > MAX_MODLEN_RESTRICT_EXP) && (exponent.bit_length > MAX_RESTRICTED_EXPLEN))
          raise InvalidKeyException.new("RSA exponents can be no longer than " + (MAX_RESTRICTED_EXPLEN).to_s + " bits " + " if modulus is greater than " + (MAX_MODLEN_RESTRICT_EXP).to_s + " bits")
        end
      end
    }
    
    typesig { [Key] }
    # 
    # Translate an RSA key into a SunRsaSign RSA key. If conversion is
    # not possible, throw an InvalidKeyException.
    # See also JCA doc.
    def engine_translate_key(key)
      if ((key).nil?)
        raise InvalidKeyException.new("Key must not be null")
      end
      key_alg = key.get_algorithm
      if (((key_alg == "RSA")).equal?(false))
        raise InvalidKeyException.new("Not an RSA key: " + key_alg)
      end
      if (key.is_a?(PublicKey))
        return translate_public_key(key)
      else
        if (key.is_a?(PrivateKey))
          return translate_private_key(key)
        else
          raise InvalidKeyException.new("Neither a public nor a private key")
        end
      end
    end
    
    typesig { [KeySpec] }
    # see JCA doc
    def engine_generate_public(key_spec)
      begin
        return generate_public(key_spec)
      rescue InvalidKeySpecException => e
        raise e
      rescue GeneralSecurityException => e
        raise InvalidKeySpecException.new(e_)
      end
    end
    
    typesig { [KeySpec] }
    # see JCA doc
    def engine_generate_private(key_spec)
      begin
        return generate_private(key_spec)
      rescue InvalidKeySpecException => e
        raise e
      rescue GeneralSecurityException => e
        raise InvalidKeySpecException.new(e_)
      end
    end
    
    typesig { [PublicKey] }
    # internal implementation of translateKey() for public keys. See JCA doc
    def translate_public_key(key)
      if (key.is_a?(RSAPublicKey))
        if (key.is_a?(RSAPublicKeyImpl))
          return key
        end
        rsa_key = key
        begin
          return RSAPublicKeyImpl.new(rsa_key.get_modulus, rsa_key.get_public_exponent)
        rescue RuntimeException => e
          # catch providers that incorrectly implement RSAPublicKey
          raise InvalidKeyException.new("Invalid key", e)
        end
      else
        if (("X.509" == key.get_format))
          encoded = key.get_encoded
          return RSAPublicKeyImpl.new(encoded)
        else
          raise InvalidKeyException.new("Public keys must be instance " + "of RSAPublicKey or have X.509 encoding")
        end
      end
    end
    
    typesig { [PrivateKey] }
    # internal implementation of translateKey() for private keys. See JCA doc
    def translate_private_key(key)
      if (key.is_a?(RSAPrivateCrtKey))
        if (key.is_a?(RSAPrivateCrtKeyImpl))
          return key
        end
        rsa_key = key
        begin
          return RSAPrivateCrtKeyImpl.new(rsa_key.get_modulus, rsa_key.get_public_exponent, rsa_key.get_private_exponent, rsa_key.get_prime_p, rsa_key.get_prime_q, rsa_key.get_prime_exponent_p, rsa_key.get_prime_exponent_q, rsa_key.get_crt_coefficient)
        rescue RuntimeException => e
          # catch providers that incorrectly implement RSAPrivateCrtKey
          raise InvalidKeyException.new("Invalid key", e)
        end
      else
        if (key.is_a?(RSAPrivateKey))
          if (key.is_a?(RSAPrivateKeyImpl))
            return key
          end
          rsa_key_ = key
          begin
            return RSAPrivateKeyImpl.new(rsa_key_.get_modulus, rsa_key_.get_private_exponent)
          rescue RuntimeException => e
            # catch providers that incorrectly implement RSAPrivateKey
            raise InvalidKeyException.new("Invalid key", e_)
          end
        else
          if (("PKCS#8" == key.get_format))
            encoded = key.get_encoded
            return RSAPrivateCrtKeyImpl.new_key(encoded)
          else
            raise InvalidKeyException.new("Private keys must be instance " + "of RSAPrivate(Crt)Key or have PKCS#8 encoding")
          end
        end
      end
    end
    
    typesig { [KeySpec] }
    # internal implementation of generatePublic. See JCA doc
    def generate_public(key_spec)
      if (key_spec.is_a?(X509EncodedKeySpec))
        x509spec = key_spec
        return RSAPublicKeyImpl.new(x509spec.get_encoded)
      else
        if (key_spec.is_a?(RSAPublicKeySpec))
          rsa_spec = key_spec
          return RSAPublicKeyImpl.new(rsa_spec.get_modulus, rsa_spec.get_public_exponent)
        else
          raise InvalidKeySpecException.new("Only RSAPublicKeySpec " + "and X509EncodedKeySpec supported for RSA public keys")
        end
      end
    end
    
    typesig { [KeySpec] }
    # internal implementation of generatePrivate. See JCA doc
    def generate_private(key_spec)
      if (key_spec.is_a?(PKCS8EncodedKeySpec))
        pkcs_spec = key_spec
        return RSAPrivateCrtKeyImpl.new_key(pkcs_spec.get_encoded)
      else
        if (key_spec.is_a?(RSAPrivateCrtKeySpec))
          rsa_spec = key_spec
          return RSAPrivateCrtKeyImpl.new(rsa_spec.get_modulus, rsa_spec.get_public_exponent, rsa_spec.get_private_exponent, rsa_spec.get_prime_p, rsa_spec.get_prime_q, rsa_spec.get_prime_exponent_p, rsa_spec.get_prime_exponent_q, rsa_spec.get_crt_coefficient)
        else
          if (key_spec.is_a?(RSAPrivateKeySpec))
            rsa_spec_ = key_spec
            return RSAPrivateKeyImpl.new(rsa_spec_.get_modulus, rsa_spec_.get_private_exponent)
          else
            raise InvalidKeySpecException.new("Only RSAPrivate(Crt)KeySpec " + "and PKCS8EncodedKeySpec supported for RSA private keys")
          end
        end
      end
    end
    
    typesig { [Key, Class] }
    def engine_get_key_spec(key, key_spec)
      begin
        # convert key to one of our keys
        # this also verifies that the key is a valid RSA key and ensures
        # that the encoding is X.509/PKCS#8 for public/private keys
        key = engine_translate_key(key)
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new(e)
      end
      if (key.is_a?(RSAPublicKey))
        rsa_key = key
        if (RsaPublicKeySpecClass.is_assignable_from(key_spec))
          return RSAPublicKeySpec.new(rsa_key.get_modulus, rsa_key.get_public_exponent)
        else
          if (X509KeySpecClass.is_assignable_from(key_spec))
            return X509EncodedKeySpec.new(key.get_encoded)
          else
            raise InvalidKeySpecException.new("KeySpec must be RSAPublicKeySpec or " + "X509EncodedKeySpec for RSA public keys")
          end
        end
      else
        if (key.is_a?(RSAPrivateKey))
          if (Pkcs8KeySpecClass.is_assignable_from(key_spec))
            return PKCS8EncodedKeySpec.new(key.get_encoded)
          else
            if (RsaPrivateCrtKeySpecClass.is_assignable_from(key_spec))
              if (key.is_a?(RSAPrivateCrtKey))
                crt_key = key
                return RSAPrivateCrtKeySpec.new(crt_key.get_modulus, crt_key.get_public_exponent, crt_key.get_private_exponent, crt_key.get_prime_p, crt_key.get_prime_q, crt_key.get_prime_exponent_p, crt_key.get_prime_exponent_q, crt_key.get_crt_coefficient)
              else
                raise InvalidKeySpecException.new("RSAPrivateCrtKeySpec can only be used with CRT keys")
              end
            else
              if (RsaPrivateKeySpecClass.is_assignable_from(key_spec))
                rsa_key_ = key
                return RSAPrivateKeySpec.new(rsa_key_.get_modulus, rsa_key_.get_private_exponent)
              else
                raise InvalidKeySpecException.new("KeySpec must be RSAPrivate(Crt)KeySpec or " + "PKCS8EncodedKeySpec for RSA private keys")
              end
            end
          end
        else
          # should not occur, caught in engineTranslateKey()
          raise InvalidKeySpecException.new("Neither public nor private key")
        end
      end
    end
    
    private
    alias_method :initialize__rsakey_factory, :initialize
  end
  
end
