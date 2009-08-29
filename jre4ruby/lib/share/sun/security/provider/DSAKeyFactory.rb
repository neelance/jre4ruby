require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module DSAKeyFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Util
      include ::Java::Lang
      include_const ::Java::Security, :Key
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security, :PrivateKey
      include_const ::Java::Security, :KeyFactorySpi
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security::Interfaces, :DSAParams
      include_const ::Java::Security::Spec, :DSAPublicKeySpec
      include_const ::Java::Security::Spec, :DSAPrivateKeySpec
      include_const ::Java::Security::Spec, :KeySpec
      include_const ::Java::Security::Spec, :InvalidKeySpecException
      include_const ::Java::Security::Spec, :X509EncodedKeySpec
      include_const ::Java::Security::Spec, :PKCS8EncodedKeySpec
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # This class implements the DSA key factory of the Sun provider.
  # 
  # @author Jan Luehe
  # 
  # 
  # @since 1.2
  class DSAKeyFactory < DSAKeyFactoryImports.const_get :KeyFactorySpi
    include_class_members DSAKeyFactoryImports
    
    class_module.module_eval {
      const_set_lazy(:SERIAL_PROP) { "sun.security.key.serial.interop" }
      const_attr_reader  :SERIAL_PROP
      
      when_class_loaded do
        # Check to see if we need to maintain interoperability for serialized
        # keys between JDK 5.0 -> JDK 1.4.  In other words, determine whether
        # a key object serialized in JDK 5.0 must be deserializable in
        # JDK 1.4.
        # 
        # If true, then we generate sun.security.provider.DSAPublicKey.
        # If false, then we generate sun.security.provider.DSAPublicKeyImpl.
        # 
        # By default this is false.
        # This incompatibility was introduced by 4532506.
        prop = AccessController.do_privileged(GetPropertyAction.new(SERIAL_PROP, nil))
        const_set :SERIAL_INTEROP, "true".equals_ignore_case(prop)
      end
    }
    
    typesig { [KeySpec] }
    # Generates a public key object from the provided key specification
    # (key material).
    # 
    # @param keySpec the specification (key material) of the public key
    # 
    # @return the public key
    # 
    # @exception InvalidKeySpecException if the given key specification
    # is inappropriate for this key factory to produce a public key.
    def engine_generate_public(key_spec)
      begin
        if (key_spec.is_a?(DSAPublicKeySpec))
          dsa_pub_key_spec = key_spec
          if (SERIAL_INTEROP)
            return DSAPublicKey.new(dsa_pub_key_spec.get_y, dsa_pub_key_spec.get_p, dsa_pub_key_spec.get_q, dsa_pub_key_spec.get_g)
          else
            return DSAPublicKeyImpl.new(dsa_pub_key_spec.get_y, dsa_pub_key_spec.get_p, dsa_pub_key_spec.get_q, dsa_pub_key_spec.get_g)
          end
        else
          if (key_spec.is_a?(X509EncodedKeySpec))
            if (SERIAL_INTEROP)
              return DSAPublicKey.new((key_spec).get_encoded)
            else
              return DSAPublicKeyImpl.new((key_spec).get_encoded)
            end
          else
            raise InvalidKeySpecException.new("Inappropriate key specification")
          end
        end
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new("Inappropriate key specification: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [KeySpec] }
    # Generates a private key object from the provided key specification
    # (key material).
    # 
    # @param keySpec the specification (key material) of the private key
    # 
    # @return the private key
    # 
    # @exception InvalidKeySpecException if the given key specification
    # is inappropriate for this key factory to produce a private key.
    def engine_generate_private(key_spec)
      begin
        if (key_spec.is_a?(DSAPrivateKeySpec))
          dsa_priv_key_spec = key_spec
          return DSAPrivateKey.new(dsa_priv_key_spec.get_x, dsa_priv_key_spec.get_p, dsa_priv_key_spec.get_q, dsa_priv_key_spec.get_g)
        else
          if (key_spec.is_a?(PKCS8EncodedKeySpec))
            return DSAPrivateKey.new((key_spec).get_encoded)
          else
            raise InvalidKeySpecException.new("Inappropriate key specification")
          end
        end
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new("Inappropriate key specification: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [Key, Class] }
    # Returns a specification (key material) of the given key object
    # in the requested format.
    # 
    # @param key the key
    # 
    # @param keySpec the requested format in which the key material shall be
    # returned
    # 
    # @return the underlying key specification (key material) in the
    # requested format
    # 
    # @exception InvalidKeySpecException if the requested key specification is
    # inappropriate for the given key, or the given key cannot be processed
    # (e.g., the given key has an unrecognized algorithm or format).
    def engine_get_key_spec(key, key_spec)
      params = nil
      begin
        if (key.is_a?(Java::Security::Interfaces::DSAPublicKey))
          # Determine valid key specs
          dsa_pub_key_spec = Class.for_name("java.security.spec.DSAPublicKeySpec")
          x509key_spec = Class.for_name("java.security.spec.X509EncodedKeySpec")
          if (dsa_pub_key_spec.is_assignable_from(key_spec))
            dsa_pub_key = key
            params = dsa_pub_key.get_params
            return DSAPublicKeySpec.new(dsa_pub_key.get_y, params.get_p, params.get_q, params.get_g)
          else
            if (x509key_spec.is_assignable_from(key_spec))
              return X509EncodedKeySpec.new(key.get_encoded)
            else
              raise InvalidKeySpecException.new("Inappropriate key specification")
            end
          end
        else
          if (key.is_a?(Java::Security::Interfaces::DSAPrivateKey))
            # Determine valid key specs
            dsa_priv_key_spec = Class.for_name("java.security.spec.DSAPrivateKeySpec")
            pkcs8key_spec = Class.for_name("java.security.spec.PKCS8EncodedKeySpec")
            if (dsa_priv_key_spec.is_assignable_from(key_spec))
              dsa_priv_key = key
              params = dsa_priv_key.get_params
              return DSAPrivateKeySpec.new(dsa_priv_key.get_x, params.get_p, params.get_q, params.get_g)
            else
              if (pkcs8key_spec.is_assignable_from(key_spec))
                return PKCS8EncodedKeySpec.new(key.get_encoded)
              else
                raise InvalidKeySpecException.new("Inappropriate key specification")
              end
            end
          else
            raise InvalidKeySpecException.new("Inappropriate key type")
          end
        end
      rescue ClassNotFoundException => e
        raise InvalidKeySpecException.new("Unsupported key specification: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [Key] }
    # Translates a key object, whose provider may be unknown or potentially
    # untrusted, into a corresponding key object of this key factory.
    # 
    # @param key the key whose provider is unknown or untrusted
    # 
    # @return the translated key
    # 
    # @exception InvalidKeyException if the given key cannot be processed by
    # this key factory.
    def engine_translate_key(key)
      begin
        if (key.is_a?(Java::Security::Interfaces::DSAPublicKey))
          # Check if key originates from this factory
          if (key.is_a?(Sun::Security::Provider::DSAPublicKey))
            return key
          end
          # Convert key to spec
          dsa_pub_key_spec = engine_get_key_spec(key, DSAPublicKeySpec)
          # Create key from spec, and return it
          return engine_generate_public(dsa_pub_key_spec)
        else
          if (key.is_a?(Java::Security::Interfaces::DSAPrivateKey))
            # Check if key originates from this factory
            if (key.is_a?(Sun::Security::Provider::DSAPrivateKey))
              return key
            end
            # Convert key to spec
            dsa_priv_key_spec = engine_get_key_spec(key, DSAPrivateKeySpec)
            # Create key from spec, and return it
            return engine_generate_private(dsa_priv_key_spec)
          else
            raise InvalidKeyException.new("Wrong algorithm type")
          end
        end
      rescue InvalidKeySpecException => e
        raise InvalidKeyException.new("Cannot translate key: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__dsakey_factory, :initialize
  end
  
end
