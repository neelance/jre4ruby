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
  module TlsMasterSecretParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Internal::Spec
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Javax::Crypto, :SecretKey
    }
  end
  
  # 
  # Parameters for SSL/TLS master secret generation.
  # This class encapsulates the information necessary to calculate a SSL/TLS
  # master secret from the premaster secret and other parameters.
  # It is used to initialize KeyGenerators of the type "TlsMasterSecret".
  # 
  # <p>Instances of this class are immutable.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  # @deprecated Sun JDK internal use only --- WILL BE REMOVED in Dolphin (JDK 7)
  class TlsMasterSecretParameterSpec 
    include_class_members TlsMasterSecretParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :premaster_secret
    alias_method :attr_premaster_secret, :premaster_secret
    undef_method :premaster_secret
    alias_method :attr_premaster_secret=, :premaster_secret=
    undef_method :premaster_secret=
    
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
    
    typesig { [SecretKey, ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # 
    # Constructs a new TlsMasterSecretParameterSpec.
    # 
    # <p>The <code>getAlgorithm()</code> method of <code>premasterSecret</code>
    # should return <code>"TlsRsaPremasterSecret"</code> if the key exchange
    # algorithm was RSA and <code>"TlsPremasterSecret"</code> otherwise.
    # 
    # @param premasterSecret the premaster secret
    # @param majorVersion the major number of the protocol version
    # @param minorVersion the minor number of the protocol version
    # @param clientRandom the client's random value
    # @param serverRandom the server's random value
    # 
    # @throws NullPointerException if premasterSecret, clientRandom,
    # or serverRandom are null
    # @throws IllegalArgumentException if minorVersion or majorVersion are
    # negative or larger than 255
    def initialize(premaster_secret, major_version, minor_version, client_random, server_random)
      @premaster_secret = nil
      @major_version = 0
      @minor_version = 0
      @client_random = nil
      @server_random = nil
      if ((premaster_secret).nil?)
        raise NullPointerException.new("premasterSecret must not be null")
      end
      @premaster_secret = premaster_secret
      @major_version = check_version(major_version)
      @minor_version = check_version(minor_version)
      @client_random = client_random.clone
      @server_random = server_random.clone
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def check_version(version)
        if ((version < 0) || (version > 255))
          raise IllegalArgumentException.new("Version must be between 0 and 255")
        end
        return version
      end
    }
    
    typesig { [] }
    # 
    # Returns the premaster secret.
    # 
    # @return the premaster secret.
    def get_premaster_secret
      return @premaster_secret
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
    
    private
    alias_method :initialize__tls_master_secret_parameter_spec, :initialize
  end
  
end
