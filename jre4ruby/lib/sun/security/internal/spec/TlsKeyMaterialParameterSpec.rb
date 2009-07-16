require "rjava"

# 
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
module Sun::Security::Internal::Spec
  module TlsKeyMaterialParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Internal::Spec
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Javax::Crypto, :SecretKey
    }
  end
  
  # 
  # Parameters for SSL/TLS key material generation.
  # This class is used to initialize KeyGenerator of the type
  # "TlsKeyMaterial". The keys returned by such KeyGenerators will be
  # instances of {@link TlsKeyMaterialSpec}.
  # 
  # <p>Instances of this class are immutable.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  # @deprecated Sun JDK internal use only --- WILL BE REMOVED in Dolphin (JDK 7)
  class TlsKeyMaterialParameterSpec 
    include_class_members TlsKeyMaterialParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :master_secret
    alias_method :attr_master_secret, :master_secret
    undef_method :master_secret
    alias_method :attr_master_secret=, :master_secret=
    undef_method :master_secret=
    
    attr_accessor :major_version
    alias_method :attr_major_version, :major_version
    undef_method :major_version
    alias_method :attr_major_version=, :major_version=
    undef_method :major_version=
    
    attr_accessor :minor_version
    alias_method :attr_minor_version, :minor_version
    undef_method :minor_version
    alias_method :attr_minor_version=, :minor_version=
    undef_method :minor_version=
    
    attr_accessor :client_random
    alias_method :attr_client_random, :client_random
    undef_method :client_random
    alias_method :attr_client_random=, :client_random=
    undef_method :client_random=
    
    attr_accessor :server_random
    alias_method :attr_server_random, :server_random
    undef_method :server_random
    alias_method :attr_server_random=, :server_random=
    undef_method :server_random=
    
    attr_accessor :cipher_algorithm
    alias_method :attr_cipher_algorithm, :cipher_algorithm
    undef_method :cipher_algorithm
    alias_method :attr_cipher_algorithm=, :cipher_algorithm=
    undef_method :cipher_algorithm=
    
    attr_accessor :cipher_key_length
    alias_method :attr_cipher_key_length, :cipher_key_length
    undef_method :cipher_key_length
    alias_method :attr_cipher_key_length=, :cipher_key_length=
    undef_method :cipher_key_length=
    
    attr_accessor :iv_length
    alias_method :attr_iv_length, :iv_length
    undef_method :iv_length
    alias_method :attr_iv_length=, :iv_length=
    undef_method :iv_length=
    
    attr_accessor :mac_key_length
    alias_method :attr_mac_key_length, :mac_key_length
    undef_method :mac_key_length
    alias_method :attr_mac_key_length=, :mac_key_length=
    undef_method :mac_key_length=
    
    attr_accessor :expanded_cipher_key_length
    alias_method :attr_expanded_cipher_key_length, :expanded_cipher_key_length
    undef_method :expanded_cipher_key_length
    alias_method :attr_expanded_cipher_key_length=, :expanded_cipher_key_length=
    undef_method :expanded_cipher_key_length=
    
    typesig { [SecretKey, ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), String, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # == 0 for domestic ciphersuites
    # 
    # Constructs a new TlsKeyMaterialParameterSpec.
    # 
    # @param masterSecret the master secret
    # @param majorVersion the major number of the protocol version
    # @param minorVersion the minor number of the protocol version
    # @param clientRandom the client's random value
    # @param serverRandom the server's random value
    # @param cipherAlgorithm the algorithm name of the cipher keys to
    # be generated
    # @param cipherKeyLength if 0, no cipher keys will be generated;
    # otherwise, the length in bytes of cipher keys to be
    # generated for domestic cipher suites; for cipher suites defined as
    # exportable, the number of key material bytes to be generated;
    # @param expandedCipherKeyLength 0 for domestic cipher suites; for
    # exportable cipher suites the length in bytes of the key to be
    # generated.
    # @param ivLength the length in bytes of the initialization vector
    # to be generated, or 0 if no initialization vector is required
    # @param macKeyLength the length in bytes of the MAC key to be generated
    # 
    # @throws NullPointerException if masterSecret, clientRandom,
    # serverRandom, or cipherAlgorithm are null
    # @throws IllegalArgumentException if the algorithm of masterSecret is
    # not TlsMasterSecret, or if majorVersion or minorVersion are
    # negative or larger than 255; or if cipherKeyLength, expandedKeyLength,
    # ivLength, or macKeyLength are negative
    def initialize(master_secret, major_version, minor_version, client_random, server_random, cipher_algorithm, cipher_key_length, expanded_cipher_key_length, iv_length, mac_key_length)
      @master_secret = nil
      @major_version = 0
      @minor_version = 0
      @client_random = nil
      @server_random = nil
      @cipher_algorithm = nil
      @cipher_key_length = 0
      @iv_length = 0
      @mac_key_length = 0
      @expanded_cipher_key_length = 0
      if (((master_secret.get_algorithm == "TlsMasterSecret")).equal?(false))
        raise IllegalArgumentException.new("Not a TLS master secret")
      end
      if ((cipher_algorithm).nil?)
        raise NullPointerException.new
      end
      @master_secret = master_secret
      @major_version = TlsMasterSecretParameterSpec.check_version(major_version)
      @minor_version = TlsMasterSecretParameterSpec.check_version(minor_version)
      @client_random = client_random.clone
      @server_random = server_random.clone
      @cipher_algorithm = cipher_algorithm
      @cipher_key_length = check_sign(cipher_key_length)
      @expanded_cipher_key_length = check_sign(expanded_cipher_key_length)
      @iv_length = check_sign(iv_length)
      @mac_key_length = check_sign(mac_key_length)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def check_sign(k)
        if (k < 0)
          raise IllegalArgumentException.new("Value must not be negative")
        end
        return k
      end
    }
    
    typesig { [] }
    # 
    # Returns the master secret.
    # 
    # @return the master secret.
    def get_master_secret
      return @master_secret
    end
    
    typesig { [] }
    # 
    # Returns the major version number.
    # 
    # @return the major version number.
    def get_major_version
      return @major_version
    end
    
    typesig { [] }
    # 
    # Returns the minor version number.
    # 
    # @return the minor version number.
    def get_minor_version
      return @minor_version
    end
    
    typesig { [] }
    # 
    # Returns a copy of the client's random value.
    # 
    # @return a copy of the client's random value.
    def get_client_random
      return @client_random.clone
    end
    
    typesig { [] }
    # 
    # Returns a copy of the server's random value.
    # 
    # @return a copy of the server's random value.
    def get_server_random
      return @server_random.clone
    end
    
    typesig { [] }
    # 
    # Returns the cipher algorithm.
    # 
    # @return the cipher algorithm.
    def get_cipher_algorithm
      return @cipher_algorithm
    end
    
    typesig { [] }
    # 
    # Returns the length in bytes of the encryption key to be generated.
    # 
    # @return the length in bytes of the encryption key to be generated.
    def get_cipher_key_length
      return @cipher_key_length
    end
    
    typesig { [] }
    # 
    # Returns the length in bytes of the expanded encryption key to be generated.
    # 
    # @return the length in bytes of the expanded encryption key to be generated.
    def get_expanded_cipher_key_length
      return @expanded_cipher_key_length
    end
    
    typesig { [] }
    # 
    # Returns the length in bytes of the initialization vector to be generated.
    # 
    # @return the length in bytes of the initialization vector to be generated.
    def get_iv_length
      return @iv_length
    end
    
    typesig { [] }
    # 
    # Returns the length in bytes of the MAC key to be generated.
    # 
    # @return the length in bytes of the MAC key to be generated.
    def get_mac_key_length
      return @mac_key_length
    end
    
    private
    alias_method :initialize__tls_key_material_parameter_spec, :initialize
  end
  
end
