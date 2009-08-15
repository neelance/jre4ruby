require "rjava"

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
  module SunX509KeyManagerImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Javax::Net::Ssl
      include ::Java::Security
      include ::Java::Security::Cert
      include_const ::Java::Security::Cert, :Certificate
      include ::Java::Util
      include_const ::Java::Net, :Socket
      include_const ::Javax::Security::Auth::X500, :X500Principal
    }
  end
  
  # An implemention of X509KeyManager backed by a KeyStore.
  # 
  # The backing KeyStore is inspected when this object is constructed.
  # All key entries containing a PrivateKey and a non-empty chain of
  # X509Certificate are then copied into an internal store. This means
  # that subsequent modifications of the KeyStore have no effect on the
  # X509KeyManagerImpl object.
  # 
  # Note that this class assumes that all keys are protected by the same
  # password.
  # 
  # The JSSE handshake code currently calls into this class via
  # chooseClientAlias() and chooseServerAlias() to find the certificates to
  # use. As implemented here, both always return the first alias returned by
  # getClientAliases() and getServerAliases(). In turn, these methods are
  # implemented by calling getAliases(), which performs the actual lookup.
  # 
  # Note that this class currently implements no checking of the local
  # certificates. In particular, it is *not* guaranteed that:
  # . the certificates are within their validity period and not revoked
  # . the signatures verify
  # . they form a PKIX compliant chain.
  # . the certificate extensions allow the certificate to be used for
  # the desired purpose.
  # 
  # Chains that fail any of these criteria will probably be rejected by
  # the remote peer.
  class SunX509KeyManagerImpl < SunX509KeyManagerImplImports.const_get :X509ExtendedKeyManager
    include_class_members SunX509KeyManagerImplImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
      
      const_set_lazy(:STRING0) { Array.typed(String).new(0) { nil } }
      const_attr_reader  :STRING0
    }
    
    # The credentials from the KeyStore as
    # Map: String(alias) -> X509Credentials(credentials)
    attr_accessor :credentials_map
    alias_method :attr_credentials_map, :credentials_map
    undef_method :credentials_map
    alias_method :attr_credentials_map=, :credentials_map=
    undef_method :credentials_map=
    
    # Cached server aliases for the case issuers == null.
    # (in the current JSSE implementation, issuers are always null for
    # server certs). See chooseServerAlias() for details.
    # 
    # Map: String(keyType) -> String[](alias)
    attr_accessor :server_alias_cache
    alias_method :attr_server_alias_cache, :server_alias_cache
    undef_method :server_alias_cache
    alias_method :attr_server_alias_cache=, :server_alias_cache=
    undef_method :server_alias_cache=
    
    class_module.module_eval {
      # Basic container for credentials implemented as an inner class.
      const_set_lazy(:X509Credentials) { Class.new do
        include_class_members SunX509KeyManagerImpl
        
        attr_accessor :private_key
        alias_method :attr_private_key, :private_key
        undef_method :private_key
        alias_method :attr_private_key=, :private_key=
        undef_method :private_key=
        
        attr_accessor :certificates
        alias_method :attr_certificates, :certificates
        undef_method :certificates
        alias_method :attr_certificates=, :certificates=
        undef_method :certificates=
        
        attr_accessor :issuer_x500principals
        alias_method :attr_issuer_x500principals, :issuer_x500principals
        undef_method :issuer_x500principals
        alias_method :attr_issuer_x500principals=, :issuer_x500principals=
        undef_method :issuer_x500principals=
        
        typesig { [PrivateKey, Array.typed(X509Certificate)] }
        def initialize(private_key, certificates)
          @private_key = nil
          @certificates = nil
          @issuer_x500principals = nil
          # assert privateKey and certificates != null
          @private_key = private_key
          @certificates = certificates
        end
        
        typesig { [] }
        def get_issuer_x500principals
          synchronized(self) do
            # lazy initialization
            if ((@issuer_x500principals).nil?)
              @issuer_x500principals = HashSet.new
              i = 0
              while i < @certificates.attr_length
                @issuer_x500principals.add(@certificates[i].get_issuer_x500principal)
                i += 1
              end
            end
            return @issuer_x500principals
          end
        end
        
        private
        alias_method :initialize__x509credentials, :initialize
      end }
    }
    
    typesig { [KeyStore, Array.typed(::Java::Char)] }
    def initialize(ks, password)
      @credentials_map = nil
      @server_alias_cache = nil
      super()
      @credentials_map = HashMap.new
      @server_alias_cache = HashMap.new
      if ((ks).nil?)
        return
      end
      aliases_ = ks.aliases
      while aliases_.has_more_elements
        alias_ = aliases_.next_element
        if (!ks.is_key_entry(alias_))
          next
        end
        key = ks.get_key(alias_, password)
        if ((key.is_a?(PrivateKey)).equal?(false))
          next
        end
        certs = ks.get_certificate_chain(alias_)
        if (((certs).nil?) || ((certs.attr_length).equal?(0)) || !(certs[0].is_a?(X509Certificate)))
          next
        end
        if (!(certs.is_a?(Array.typed(X509Certificate))))
          tmp = Array.typed(X509Certificate).new(certs.attr_length) { nil }
          System.arraycopy(certs, 0, tmp, 0, certs.attr_length)
          certs = tmp
        end
        cred = X509Credentials.new(key, certs)
        @credentials_map.put(alias_, cred)
        if (!(Debug).nil? && Debug.is_on("keymanager"))
          System.out.println("***")
          System.out.println("found key for : " + alias_)
          i = 0
          while i < certs.attr_length
            System.out.println("chain [" + RJava.cast_to_string(i) + "] = " + RJava.cast_to_string(certs[i]))
            i += 1
          end
          System.out.println("***")
        end
      end
    end
    
    typesig { [String] }
    # Returns the certificate chain associated with the given alias.
    # 
    # @return the certificate chain (ordered with the user's certificate first
    # and the root certificate authority last)
    def get_certificate_chain(alias_)
      if ((alias_).nil?)
        return nil
      end
      cred = @credentials_map.get(alias_)
      if ((cred).nil?)
        return nil
      else
        return cred.attr_certificates.clone
      end
    end
    
    typesig { [String] }
    # Returns the key associated with the given alias
    def get_private_key(alias_)
      if ((alias_).nil?)
        return nil
      end
      cred = @credentials_map.get(alias_)
      if ((cred).nil?)
        return nil
      else
        return cred.attr_private_key
      end
    end
    
    typesig { [Array.typed(String), Array.typed(Principal), Socket] }
    # Choose an alias to authenticate the client side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def choose_client_alias(key_types, issuers, socket)
      # We currently don't do anything with socket, but
      # someday we might.  It might be a useful hint for
      # selecting one of the aliases we get back from
      # getClientAliases().
      if ((key_types).nil?)
        return nil
      end
      i = 0
      while i < key_types.attr_length
        aliases_ = get_client_aliases(key_types[i], issuers)
        if ((!(aliases_).nil?) && (aliases_.attr_length > 0))
          return aliases_[0]
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Array.typed(String), Array.typed(Principal), SSLEngine] }
    # Choose an alias to authenticate the client side of an
    # <code>SSLEngine</code> connection given the public key type
    # and the list of certificate issuer authorities recognized by
    # the peer (if any).
    # 
    # @since 1.5
    def choose_engine_client_alias(key_type, issuers, engine)
      # If we ever start using socket as a selection criteria,
      # we'll need to adjust this.
      return choose_client_alias(key_type, issuers, nil)
    end
    
    typesig { [String, Array.typed(Principal), Socket] }
    # Choose an alias to authenticate the server side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def choose_server_alias(key_type, issuers, socket)
      # We currently don't do anything with socket, but
      # someday we might.  It might be a useful hint for
      # selecting one of the aliases we get back from
      # getServerAliases().
      if ((key_type).nil?)
        return nil
      end
      aliases_ = nil
      if ((issuers).nil? || (issuers.attr_length).equal?(0))
        aliases_ = @server_alias_cache.get(key_type)
        if ((aliases_).nil?)
          aliases_ = get_server_aliases(key_type, issuers)
          # Cache the result (positive and negative lookups)
          if ((aliases_).nil?)
            aliases_ = STRING0
          end
          @server_alias_cache.put(key_type, aliases_)
        end
      else
        aliases_ = get_server_aliases(key_type, issuers)
      end
      if ((!(aliases_).nil?) && (aliases_.attr_length > 0))
        return aliases_[0]
      end
      return nil
    end
    
    typesig { [String, Array.typed(Principal), SSLEngine] }
    # Choose an alias to authenticate the server side of an
    # <code>SSLEngine</code> connection given the public key type
    # and the list of certificate issuer authorities recognized by
    # the peer (if any).
    # 
    # @since 1.5
    def choose_engine_server_alias(key_type, issuers, engine)
      # If we ever start using socket as a selection criteria,
      # we'll need to adjust this.
      return choose_server_alias(key_type, issuers, nil)
    end
    
    typesig { [String, Array.typed(Principal)] }
    # Get the matching aliases for authenticating the client side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def get_client_aliases(key_type, issuers)
      return get_aliases(key_type, issuers)
    end
    
    typesig { [String, Array.typed(Principal)] }
    # Get the matching aliases for authenticating the server side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    def get_server_aliases(key_type, issuers)
      return get_aliases(key_type, issuers)
    end
    
    typesig { [String, Array.typed(Principal)] }
    # Get the matching aliases for authenticating the either side of a secure
    # socket given the public key type and the list of
    # certificate issuer authorities recognized by the peer (if any).
    # 
    # Issuers comes to us in the form of X500Principal[].
    def get_aliases(key_type, issuers)
      if ((key_type).nil?)
        return nil
      end
      if ((issuers).nil?)
        issuers = Array.typed(X500Principal).new(0) { nil }
      end
      if ((issuers.is_a?(Array.typed(X500Principal))).equal?(false))
        # normally, this will never happen but try to recover if it does
        issuers = convert_principals(issuers)
      end
      sig_type = nil
      if (key_type.contains("_"))
        k = key_type.index_of("_")
        sig_type = RJava.cast_to_string(key_type.substring(k + 1))
        key_type = RJava.cast_to_string(key_type.substring(0, k))
      else
        sig_type = RJava.cast_to_string(nil)
      end
      x500issuers = issuers
      # the algorithm below does not produce duplicates, so avoid Set
      aliases_ = ArrayList.new
      @credentials_map.entry_set.each do |entry|
        alias_ = entry.get_key
        credentials = entry.get_value
        certs = credentials.attr_certificates
        if (!(key_type == certs[0].get_public_key.get_algorithm))
          next
        end
        if (!(sig_type).nil?)
          if (certs.attr_length > 1)
            # if possible, check the public key in the issuer cert
            if (!(sig_type == certs[1].get_public_key.get_algorithm))
              next
            end
          else
            # Check the signature algorithm of the certificate itself.
            # Look for the "withRSA" in "SHA1withRSA", etc.
            sig_alg_name = certs[0].get_sig_alg_name.to_upper_case(Locale::ENGLISH)
            pattern = "WITH" + RJava.cast_to_string(sig_type.to_upper_case(Locale::ENGLISH))
            if ((sig_alg_name.contains(pattern)).equal?(false))
              next
            end
          end
        end
        if ((issuers.attr_length).equal?(0))
          # no issuer specified, match all
          aliases_.add(alias_)
          if (!(Debug).nil? && Debug.is_on("keymanager"))
            System.out.println("matching alias: " + alias_)
          end
        else
          cert_issuers = credentials.get_issuer_x500principals
          i = 0
          while i < x500issuers.attr_length
            if (cert_issuers.contains(issuers[i]))
              aliases_.add(alias_)
              if (!(Debug).nil? && Debug.is_on("keymanager"))
                System.out.println("matching alias: " + alias_)
              end
              break
            end
            i += 1
          end
        end
      end
      alias_strings = aliases_.to_array(STRING0)
      return (((alias_strings.attr_length).equal?(0)) ? nil : alias_strings)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Principal)] }
      # Convert an array of Principals to an array of X500Principals, if
      # possible. Principals that cannot be converted are ignored.
      def convert_principals(principals)
        list = ArrayList.new(principals.attr_length)
        i = 0
        while i < principals.attr_length
          p = principals[i]
          if (p.is_a?(X500Principal))
            list.add(p)
          else
            begin
              list.add(X500Principal.new(p.get_name))
            rescue IllegalArgumentException => e
              # ignore
            end
          end
          i += 1
        end
        return list.to_array(Array.typed(X500Principal).new(list.size) { nil })
      end
    }
    
    private
    alias_method :initialize__sun_x509key_manager_impl, :initialize
  end
  
end
