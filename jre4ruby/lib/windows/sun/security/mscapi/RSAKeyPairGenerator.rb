require "rjava"

# Copyright 2005-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Mscapi
  module RSAKeyPairGeneratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include_const ::Java::Util, :UUID
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Spec, :RSAKeyGenParameterSpec
      include_const ::Sun::Security::Jca, :JCAUtil
      include_const ::Sun::Security::Rsa, :RSAKeyFactory
    }
  end
  
  # RSA keypair generator.
  # 
  # Standard algorithm, minimum key length is 512 bit, maximum is 16,384.
  # Generates a private key that is exportable.
  # 
  # @since 1.6
  class RSAKeyPairGenerator < RSAKeyPairGeneratorImports.const_get :KeyPairGeneratorSpi
    include_class_members RSAKeyPairGeneratorImports
    
    class_module.module_eval {
      # Supported by Microsoft Base, Strong and Enhanced Cryptographic Providers
      const_set_lazy(:KEY_SIZE_MIN) { 512 }
      const_attr_reader  :KEY_SIZE_MIN
      
      # disallow MSCAPI min. of 384
      const_set_lazy(:KEY_SIZE_MAX) { 16384 }
      const_attr_reader  :KEY_SIZE_MAX
      
      const_set_lazy(:KEY_SIZE_DEFAULT) { 1024 }
      const_attr_reader  :KEY_SIZE_DEFAULT
    }
    
    # size of the key to generate, KEY_SIZE_MIN <= keySize <= KEY_SIZE_MAX
    attr_accessor :key_size
    alias_method :attr_key_size, :key_size
    undef_method :key_size
    alias_method :attr_key_size=, :key_size=
    undef_method :key_size=
    
    typesig { [] }
    def initialize
      @key_size = 0
      super()
      # initialize to default in case the app does not call initialize()
      initialize_(KEY_SIZE_DEFAULT, nil)
    end
    
    typesig { [::Java::Int, SecureRandom] }
    # initialize the generator. See JCA doc
    # random is always ignored
    def initialize_(key_size, random)
      begin
        RSAKeyFactory.check_key_lengths(key_size, nil, KEY_SIZE_MIN, KEY_SIZE_MAX)
      rescue InvalidKeyException => e
        raise InvalidParameterException.new(e.get_message)
      end
      @key_size = key_size
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # second initialize method. See JCA doc
    # random and exponent are always ignored
    def initialize_(params, random)
      tmp_size = 0
      if ((params).nil?)
        tmp_size = KEY_SIZE_DEFAULT
      else
        if (params.is_a?(RSAKeyGenParameterSpec))
          if (!((params).get_public_exponent).nil?)
            raise InvalidAlgorithmParameterException.new("Exponent parameter is not supported")
          end
          tmp_size = (params).get_keysize
        else
          raise InvalidAlgorithmParameterException.new("Params must be an instance of RSAKeyGenParameterSpec")
        end
      end
      begin
        RSAKeyFactory.check_key_lengths(tmp_size, nil, KEY_SIZE_MIN, KEY_SIZE_MAX)
      rescue InvalidKeyException => e
        raise InvalidAlgorithmParameterException.new("Invalid Key sizes", e)
      end
      @key_size = tmp_size
    end
    
    typesig { [] }
    # generate the keypair. See JCA doc
    def generate_key_pair
      # Generate each keypair in a unique key container
      keys = generate_rsakey_pair(@key_size, "{" + RJava.cast_to_string(UUID.random_uuid.to_s) + "}")
      return KeyPair.new(keys.get_public, keys.get_private)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_security_mscapi_RSAKeyPairGenerator_generateRSAKeyPair, [:pointer, :long, :int32, :long], :long
      typesig { [::Java::Int, String] }
      def generate_rsakey_pair(key_size, key_container_name)
        JNI.call_native_method(:Java_sun_security_mscapi_RSAKeyPairGenerator_generateRSAKeyPair, JNI.env, self.jni_id, key_size.to_int, key_container_name.jni_id)
      end
    }
    
    private
    alias_method :initialize__rsakey_pair_generator, :initialize
  end
  
end
