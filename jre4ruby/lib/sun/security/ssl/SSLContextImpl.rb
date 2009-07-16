require "rjava"

# 
# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module SSLContextImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Net, :Socket
      include ::Java::Security
      include ::Java::Security::Cert
      include ::Javax::Net::Ssl
    }
  end
  
  class SSLContextImpl < SSLContextImplImports.const_get :SSLContextSpi
    include_class_members SSLContextImplImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :ephemeral_key_manager
    alias_method :attr_ephemeral_key_manager, :ephemeral_key_manager
    undef_method :ephemeral_key_manager
    alias_method :attr_ephemeral_key_manager=, :ephemeral_key_manager=
    undef_method :ephemeral_key_manager=
    
    attr_accessor :client_cache
    alias_method :attr_client_cache, :client_cache
    undef_method :client_cache
    alias_method :attr_client_cache=, :client_cache=
    undef_method :client_cache=
    
    attr_accessor :server_cache
    alias_method :attr_server_cache, :server_cache
    undef_method :server_cache
    alias_method :attr_server_cache=, :server_cache=
    undef_method :server_cache=
    
    attr_accessor :is_initialized
    alias_method :attr_is_initialized, :is_initialized
    undef_method :is_initialized
    alias_method :attr_is_initialized=, :is_initialized=
    undef_method :is_initialized=
    
    attr_accessor :key_manager
    alias_method :attr_key_manager, :key_manager
    undef_method :key_manager
    alias_method :attr_key_manager=, :key_manager=
    undef_method :key_manager=
    
    attr_accessor :trust_manager
    alias_method :attr_trust_manager, :trust_manager
    undef_method :trust_manager
    alias_method :attr_trust_manager=, :trust_manager=
    undef_method :trust_manager=
    
    attr_accessor :secure_random
    alias_method :attr_secure_random, :secure_random
    undef_method :secure_random
    alias_method :attr_secure_random=, :secure_random=
    undef_method :secure_random=
    
    typesig { [] }
    def initialize
      initialize__sslcontext_impl(nil)
    end
    
    typesig { [SSLContextImpl] }
    def initialize(other)
      @ephemeral_key_manager = nil
      @client_cache = nil
      @server_cache = nil
      @is_initialized = false
      @key_manager = nil
      @trust_manager = nil
      @secure_random = nil
      super()
      if ((other).nil?)
        @ephemeral_key_manager = EphemeralKeyManager.new
        @client_cache = SSLSessionContextImpl.new
        @server_cache = SSLSessionContextImpl.new
      else
        @ephemeral_key_manager = other.attr_ephemeral_key_manager
        @client_cache = other.attr_client_cache
        @server_cache = other.attr_server_cache
      end
    end
    
    typesig { [Array.typed(KeyManager), Array.typed(TrustManager), SecureRandom] }
    def engine_init(km, tm, sr)
      @is_initialized = false
      @key_manager = choose_key_manager(km)
      if ((tm).nil?)
        begin
          tmf = TrustManagerFactory.get_instance(TrustManagerFactory.get_default_algorithm)
          tmf.init(nil)
          tm = tmf.get_trust_managers
        rescue Exception => e
          # eat
        end
      end
      @trust_manager = choose_trust_manager(tm)
      if ((sr).nil?)
        @secure_random = JsseJce.get_secure_random
      else
        if (SunJSSE.is_fips && (!(sr.get_provider).equal?(SunJSSE.attr_crypto_provider)))
          raise KeyManagementException.new("FIPS mode: SecureRandom must be from provider " + (SunJSSE.attr_crypto_provider.get_name).to_s)
        end
        @secure_random = sr
      end
      # 
      # The initial delay of seeding the random number generator
      # could be long enough to cause the initial handshake on our
      # first connection to timeout and fail. Make sure it is
      # primed and ready by getting some initial output from it.
      if (!(Debug).nil? && Debug.is_on("sslctx"))
        System.out.println("trigger seeding of SecureRandom")
      end
      @secure_random.next_int
      if (!(Debug).nil? && Debug.is_on("sslctx"))
        System.out.println("done seeding SecureRandom")
      end
      @is_initialized = true
    end
    
    typesig { [Array.typed(TrustManager)] }
    def choose_trust_manager(tm)
      # We only use the first instance of X509TrustManager passed to us.
      i = 0
      while !(tm).nil? && i < tm.attr_length
        if (tm[i].is_a?(X509TrustManager))
          if (SunJSSE.is_fips && !(tm[i].is_a?(X509TrustManagerImpl)))
            raise KeyManagementException.new("FIPS mode: only SunJSSE TrustManagers may be used")
          end
          return tm[i]
        end
        ((i += 1) - 1)
      end
      # nothing found, return a dummy X509TrustManager.
      return DummyX509TrustManager::INSTANCE
    end
    
    typesig { [Array.typed(KeyManager)] }
    def choose_key_manager(kms)
      i = 0
      while !(kms).nil? && i < kms.attr_length
        km = kms[i]
        if ((km.is_a?(X509KeyManager)).equal?(false))
          ((i += 1) - 1)
          next
        end
        if (SunJSSE.is_fips)
          # In FIPS mode, require that one of SunJSSE's own keymanagers
          # is used. Otherwise, we cannot be sure that only keys from
          # the FIPS token are used.
          if ((km.is_a?(X509KeyManagerImpl)) || (km.is_a?(SunX509KeyManagerImpl)))
            return km
          else
            # throw exception, we don't want to silently use the
            # dummy keymanager without telling the user.
            raise KeyManagementException.new("FIPS mode: only SunJSSE KeyManagers may be used")
          end
        end
        if (km.is_a?(X509ExtendedKeyManager))
          return km
        end
        if (!(Debug).nil? && Debug.is_on("sslctx"))
          System.out.println("X509KeyManager passed to " + "SSLContext.init():  need an " + "X509ExtendedKeyManager for SSLEngine use")
        end
        return AbstractWrapper.new(km)
        ((i += 1) - 1)
      end
      # nothing found, return a dummy X509ExtendedKeyManager
      return DummyX509KeyManager::INSTANCE
    end
    
    typesig { [] }
    def engine_get_socket_factory
      if (!@is_initialized)
        raise IllegalStateException.new("SSLContextImpl is not initialized")
      end
      return SSLSocketFactoryImpl.new(self)
    end
    
    typesig { [] }
    def engine_get_server_socket_factory
      if (!@is_initialized)
        raise IllegalStateException.new("SSLContext is not initialized")
      end
      return SSLServerSocketFactoryImpl.new(self)
    end
    
    typesig { [] }
    def engine_create_sslengine
      if (!@is_initialized)
        raise IllegalStateException.new("SSLContextImpl is not initialized")
      end
      return SSLEngineImpl.new(self)
    end
    
    typesig { [String, ::Java::Int] }
    def engine_create_sslengine(host, port)
      if (!@is_initialized)
        raise IllegalStateException.new("SSLContextImpl is not initialized")
      end
      return SSLEngineImpl.new(self, host, port)
    end
    
    typesig { [] }
    def engine_get_client_session_context
      return @client_cache
    end
    
    typesig { [] }
    def engine_get_server_session_context
      return @server_cache
    end
    
    typesig { [] }
    def get_secure_random
      return @secure_random
    end
    
    typesig { [] }
    def get_x509key_manager
      return @key_manager
    end
    
    typesig { [] }
    def get_x509trust_manager
      return @trust_manager
    end
    
    typesig { [] }
    def get_ephemeral_key_manager
      return @ephemeral_key_manager
    end
    
    private
    alias_method :initialize__sslcontext_impl, :initialize
  end
  
  # Dummy X509TrustManager implementation, rejects all peer certificates.
  # Used if the application did not specify a proper X509TrustManager.
  class DummyX509TrustManager 
    include_class_members SSLContextImplImports
    include X509TrustManager
    
    class_module.module_eval {
      const_set_lazy(:INSTANCE) { DummyX509TrustManager.new }
      const_attr_reader  :INSTANCE
    }
    
    typesig { [] }
    def initialize
      # empty
    end
    
    typesig { [Array.typed(X509Certificate), String] }
    # 
    # Given the partial or complete certificate chain
    # provided by the peer, build a certificate path
    # to a trusted root and return if it can be
    # validated and is trusted for client SSL authentication.
    # If not, it throws an exception.
    def check_client_trusted(chain, auth_type)
      raise CertificateException.new("No X509TrustManager implementation avaiable")
    end
    
    typesig { [Array.typed(X509Certificate), String] }
    # 
    # Given the partial or complete certificate chain
    # provided by the peer, build a certificate path
    # to a trusted root and return if it can be
    # validated and is trusted for server SSL authentication.
    # If not, it throws an exception.
    def check_server_trusted(chain, auth_type)
      raise CertificateException.new("No X509TrustManager implementation available")
    end
    
    typesig { [] }
    # 
    # Return an array of issuer certificates which are trusted
    # for authenticating peers.
    def get_accepted_issuers
      return Array.typed(X509Certificate).new(0) { nil }
    end
    
    private
    alias_method :initialize__dummy_x509trust_manager, :initialize
  end
  
  # Inherit chooseEngineClientAlias() and chooseEngineServerAlias() from
  # X509ExtendedKeymanager. It defines them to return null;
  # 
  # A wrapper class to turn a X509KeyManager into an X509ExtendedKeyManager
  class AbstractWrapper < SSLContextImplImports.const_get :X509ExtendedKeyManager
    include_class_members SSLContextImplImports
    
    attr_accessor :km
    alias_method :attr_km, :km
    undef_method :km
    alias_method :attr_km=, :km=
    undef_method :km=
    
    typesig { [X509KeyManager] }
    def initialize(km)
      @km = nil
      super()
      @km = km
    end
    
    typesig { [String, Array.typed(Principal)] }
    def get_client_aliases(key_type, issuers)
      return @km.get_client_aliases(key_type, issuers)
    end
    
    typesig { [Array.typed(String), Array.typed(Principal), Socket] }
    def choose_client_alias(key_type, issuers, socket)
      return @km.choose_client_alias(key_type, issuers, socket)
    end
    
    typesig { [String, Array.typed(Principal)] }
    def get_server_aliases(key_type, issuers)
      return @km.get_server_aliases(key_type, issuers)
    end
    
    typesig { [String, Array.typed(Principal), Socket] }
    def choose_server_alias(key_type, issuers, socket)
      return @km.choose_server_alias(key_type, issuers, socket)
    end
    
    typesig { [String] }
    def get_certificate_chain(alias_)
      return @km.get_certificate_chain(alias_)
    end
    
    typesig { [String] }
    def get_private_key(alias_)
      return @km.get_private_key(alias_)
    end
    
    private
    alias_method :initialize__abstract_wrapper, :initialize
  end
  
  # Dummy X509KeyManager implementation, never returns any certificates/keys.
  # Used if the application did not specify a proper X509TrustManager.
  class DummyX509KeyManager < SSLContextImplImports.const_get :X509ExtendedKeyManager
    include_class_members SSLContextImplImports
    
    class_module.module_eval {
      const_set_lazy(:INSTANCE) { DummyX509KeyManager.new }
      const_attr_reader  :INSTANCE
    }
    
    typesig { [] }
    def initialize
      super()
      # empty
    end
    
    typesig { [String, Array.typed(Principal)] }
    # 
    # Get the matching aliases for authenticating the client side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def get_client_aliases(key_type, issuers)
      return nil
    end
    
    typesig { [Array.typed(String), Array.typed(Principal), Socket] }
    # 
    # Choose an alias to authenticate the client side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def choose_client_alias(key_types, issuers, socket)
      return nil
    end
    
    typesig { [Array.typed(String), Array.typed(Principal), SSLEngine] }
    # 
    # Choose an alias to authenticate the client side of an
    # engine given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def choose_engine_client_alias(key_types, issuers, engine)
      return nil
    end
    
    typesig { [String, Array.typed(Principal)] }
    # 
    # Get the matching aliases for authenticating the server side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def get_server_aliases(key_type, issuers)
      return nil
    end
    
    typesig { [String, Array.typed(Principal), Socket] }
    # 
    # Choose an alias to authenticate the server side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def choose_server_alias(key_type, issuers, socket)
      return nil
    end
    
    typesig { [String, Array.typed(Principal), SSLEngine] }
    # 
    # Choose an alias to authenticate the server side of an engine
    # given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def choose_engine_server_alias(key_type, issuers, engine)
      return nil
    end
    
    typesig { [String] }
    # 
    # Returns the certificate chain associated with the given alias.
    # 
    # @param alias the alias name
    # 
    # @return the certificate chain (ordered with the user's certificate first
    # and the root certificate authority last)
    def get_certificate_chain(alias_)
      return nil
    end
    
    typesig { [String] }
    # 
    # Returns the key associated with the given alias, using the given
    # password to recover it.
    # 
    # @param alias the alias name
    # 
    # @return the requested key
    def get_private_key(alias_)
      return nil
    end
    
    private
    alias_method :initialize__dummy_x509key_manager, :initialize
  end
  
end
