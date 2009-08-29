require "rjava"

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
  module P11KeyStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaSet
      include ::Java::Security
      include ::Java::Security::KeyStore
      include_const ::Java::Security::Cert, :CertPath
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :CertificateException
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include_const ::Javax::Crypto, :SecretKey
      include ::Javax::Crypto::Interfaces
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Javax::Security::Auth::Login, :LoginException
      include_const ::Javax::Security::Auth::Callback, :Callback
      include_const ::Javax::Security::Auth::Callback, :PasswordCallback
      include_const ::Javax::Security::Auth::Callback, :CallbackHandler
      include_const ::Javax::Security::Auth::Callback, :UnsupportedCallbackException
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :SerialNumber
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Ec, :ECParameters
      include ::Sun::Security::Pkcs11::Secmod
      include ::Sun::Security::Pkcs11::Wrapper
      include_const ::Sun::Security::Rsa, :RSAKeyFactory
    }
  end
  
  class P11KeyStore < P11KeyStoreImports.const_get :KeyStoreSpi
    include_class_members P11KeyStoreImports
    
    class_module.module_eval {
      const_set_lazy(:ATTR_CLASS_CERT) { CK_ATTRIBUTE.new(CKA_CLASS, CKO_CERTIFICATE) }
      const_attr_reader  :ATTR_CLASS_CERT
      
      const_set_lazy(:ATTR_CLASS_PKEY) { CK_ATTRIBUTE.new(CKA_CLASS, CKO_PRIVATE_KEY) }
      const_attr_reader  :ATTR_CLASS_PKEY
      
      const_set_lazy(:ATTR_CLASS_SKEY) { CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY) }
      const_attr_reader  :ATTR_CLASS_SKEY
      
      const_set_lazy(:ATTR_X509_CERT_TYPE) { CK_ATTRIBUTE.new(CKA_CERTIFICATE_TYPE, CKC_X_509) }
      const_attr_reader  :ATTR_X509_CERT_TYPE
      
      const_set_lazy(:ATTR_TOKEN_TRUE) { CK_ATTRIBUTE.new(CKA_TOKEN, true) }
      const_attr_reader  :ATTR_TOKEN_TRUE
      
      # XXX for testing purposes only
      # - NSS doesn't support persistent secret keys
      # (key type gets mangled if secret key is a token key)
      # - if debug is turned on, then this is set to false
      
      def attr_skey_token_true
        defined?(@@attr_skey_token_true) ? @@attr_skey_token_true : @@attr_skey_token_true= ATTR_TOKEN_TRUE
      end
      alias_method :attr_attr_skey_token_true, :attr_skey_token_true
      
      def attr_skey_token_true=(value)
        @@attr_skey_token_true = value
      end
      alias_method :attr_attr_skey_token_true=, :attr_skey_token_true=
      
      const_set_lazy(:ATTR_TRUSTED_TRUE) { CK_ATTRIBUTE.new(CKA_TRUSTED, true) }
      const_attr_reader  :ATTR_TRUSTED_TRUE
      
      const_set_lazy(:ATTR_PRIVATE_TRUE) { CK_ATTRIBUTE.new(CKA_PRIVATE, true) }
      const_attr_reader  :ATTR_PRIVATE_TRUE
      
      const_set_lazy(:NO_HANDLE) { -1 }
      const_attr_reader  :NO_HANDLE
      
      const_set_lazy(:FINDOBJECTS_MAX) { 100 }
      const_attr_reader  :FINDOBJECTS_MAX
      
      const_set_lazy(:ALIAS_SEP) { "/" }
      const_attr_reader  :ALIAS_SEP
      
      const_set_lazy(:NSS_TEST) { false }
      const_attr_reader  :NSS_TEST
      
      const_set_lazy(:Debug) { Debug.get_instance("pkcs11keystore") }
      const_attr_reader  :Debug
      
      
      def cka_trusted_supported
        defined?(@@cka_trusted_supported) ? @@cka_trusted_supported : @@cka_trusted_supported= true
      end
      alias_method :attr_cka_trusted_supported, :cka_trusted_supported
      
      def cka_trusted_supported=(value)
        @@cka_trusted_supported = value
      end
      alias_method :attr_cka_trusted_supported=, :cka_trusted_supported=
    }
    
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # If multiple certs are found to share the same CKA_LABEL
    # at load time (NSS-style keystore), then the keystore is read
    # and the unique keystore aliases are mapped to the entries.
    # However, write capabilities are disabled.
    attr_accessor :write_disabled
    alias_method :attr_write_disabled, :write_disabled
    undef_method :write_disabled
    alias_method :attr_write_disabled=, :write_disabled=
    undef_method :write_disabled=
    
    # Map of unique keystore aliases to entries in the token
    attr_accessor :alias_map
    alias_method :attr_alias_map, :alias_map
    undef_method :alias_map
    alias_method :attr_alias_map=, :alias_map=
    undef_method :alias_map=
    
    # whether to use NSS Secmod info for trust attributes
    attr_accessor :use_secmod_trust
    alias_method :attr_use_secmod_trust, :use_secmod_trust
    undef_method :use_secmod_trust
    alias_method :attr_use_secmod_trust=, :use_secmod_trust=
    undef_method :use_secmod_trust=
    
    # if useSecmodTrust == true, which type of trust we are interested in
    attr_accessor :nss_trust_type
    alias_method :attr_nss_trust_type, :nss_trust_type
    undef_method :nss_trust_type
    alias_method :attr_nss_trust_type=, :nss_trust_type=
    undef_method :nss_trust_type=
    
    class_module.module_eval {
      # The underlying token may contain multiple certs belonging to the
      # same "personality" (for example, a signing cert and encryption cert),
      # all sharing the same CKA_LABEL.  These must be resolved
      # into unique keystore aliases.
      # 
      # In addition, private keys and certs may not have a CKA_LABEL.
      # It is assumed that a private key and corresponding certificate
      # share the same CKA_ID, and that the CKA_ID is unique across the token.
      # The CKA_ID may not be human-readable.
      # These pairs must be resolved into unique keystore aliases.
      # 
      # Furthermore, secret keys are assumed to have a CKA_LABEL
      # unique across the entire token.
      # 
      # When the KeyStore is loaded, instances of this class are
      # created to represent the private keys/secret keys/certs
      # that reside on the token.
      const_set_lazy(:AliasInfo) { Class.new do
        include_class_members P11KeyStore
        
        # CKA_CLASS - entry type
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        # CKA_LABEL of cert
        attr_accessor :label
        alias_method :attr_label, :label
        undef_method :label
        alias_method :attr_label=, :label=
        undef_method :label=
        
        # CKA_ID - of private key/cert
        attr_accessor :id
        alias_method :attr_id, :id
        undef_method :id
        alias_method :attr_id=, :id=
        undef_method :id=
        
        # CKA_TRUSTED - true if cert is trusted
        attr_accessor :trusted
        alias_method :attr_trusted, :trusted
        undef_method :trusted
        alias_method :attr_trusted=, :trusted=
        undef_method :trusted=
        
        # either end-entity cert or trusted cert depending on 'type'
        attr_accessor :cert
        alias_method :attr_cert, :cert
        undef_method :cert
        alias_method :attr_cert=, :cert=
        undef_method :cert=
        
        # chain
        attr_accessor :chain
        alias_method :attr_chain, :chain
        undef_method :chain
        alias_method :attr_chain=, :chain=
        undef_method :chain=
        
        # true if CKA_ID for private key and cert match up
        attr_accessor :matched
        alias_method :attr_matched, :matched
        undef_method :matched
        alias_method :attr_matched=, :matched=
        undef_method :matched=
        
        typesig { [String] }
        # SecretKeyEntry
        def initialize(label)
          @type = nil
          @label = nil
          @id = nil
          @trusted = false
          @cert = nil
          @chain = nil
          @matched = false
          @type = ATTR_CLASS_SKEY
          @label = label
        end
        
        typesig { [String, Array.typed(::Java::Byte), ::Java::Boolean, class_self::X509Certificate] }
        # PrivateKeyEntry
        def initialize(label, id, trusted, cert)
          @type = nil
          @label = nil
          @id = nil
          @trusted = false
          @cert = nil
          @chain = nil
          @matched = false
          @type = ATTR_CLASS_PKEY
          @label = label
          @id = id
          @trusted = trusted
          @cert = cert
        end
        
        typesig { [] }
        def to_s
          sb = self.class::StringBuilder.new
          if ((@type).equal?(ATTR_CLASS_PKEY))
            sb.append("\ttype=[private key]\n")
          else
            if ((@type).equal?(ATTR_CLASS_SKEY))
              sb.append("\ttype=[secret key]\n")
            else
              if ((@type).equal?(ATTR_CLASS_CERT))
                sb.append("\ttype=[trusted cert]\n")
              end
            end
          end
          sb.append("\tlabel=[" + @label + "]\n")
          if ((@id).nil?)
            sb.append("\tid=[null]\n")
          else
            sb.append("\tid=" + RJava.cast_to_string(P11KeyStore.get_id(@id)) + "\n")
          end
          sb.append("\ttrusted=[" + RJava.cast_to_string(@trusted) + "]\n")
          sb.append("\tmatched=[" + RJava.cast_to_string(@matched) + "]\n")
          if ((@cert).nil?)
            sb.append("\tcert=[null]\n")
          else
            sb.append("\tcert=[\tsubject: " + RJava.cast_to_string(@cert.get_subject_x500principal) + "\n\t\tissuer: " + RJava.cast_to_string(@cert.get_issuer_x500principal) + "\n\t\tserialNum: " + RJava.cast_to_string(@cert.get_serial_number.to_s) + "]")
          end
          return sb.to_s
        end
        
        private
        alias_method :initialize__alias_info, :initialize
      end }
      
      # callback handler for passing password to Provider.login method
      const_set_lazy(:PasswordCallbackHandler) { Class.new do
        include_class_members P11KeyStore
        include CallbackHandler
        
        attr_accessor :password
        alias_method :attr_password, :password
        undef_method :password
        alias_method :attr_password=, :password=
        undef_method :password=
        
        typesig { [Array.typed(::Java::Char)] }
        def initialize(password)
          @password = nil
          if (!(password).nil?)
            @password = password.clone
          end
        end
        
        typesig { [Array.typed(class_self::Callback)] }
        def handle(callbacks)
          if (!(callbacks[0].is_a?(self.class::PasswordCallback)))
            raise self.class::UnsupportedCallbackException.new(callbacks[0])
          end
          pc = callbacks[0]
          pc.set_password(@password) # this clones the password if not null
        end
        
        typesig { [] }
        def finalize
          if (!(@password).nil?)
            Arrays.fill(@password, Character.new(?\s.ord))
          end
          super
        end
        
        private
        alias_method :initialize__password_callback_handler, :initialize
      end }
      
      # getTokenObject return value.
      # 
      # if object is not found, type is set to null.
      # otherwise, type is set to the requested type.
      const_set_lazy(:THandle) { Class.new do
        include_class_members P11KeyStore
        
        attr_accessor :handle
        alias_method :attr_handle, :handle
        undef_method :handle
        alias_method :attr_handle=, :handle=
        undef_method :handle=
        
        # token object handle
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        typesig { [::Java::Long, class_self::CK_ATTRIBUTE] }
        # CKA_CLASS
        def initialize(handle, type)
          @handle = 0
          @type = nil
          @handle = handle
          @type = type
        end
        
        private
        alias_method :initialize__thandle, :initialize
      end }
    }
    
    typesig { [Token] }
    def initialize(token)
      @token = nil
      @write_disabled = false
      @alias_map = nil
      @use_secmod_trust = false
      @nss_trust_type = nil
      super()
      @write_disabled = false
      @token = token
      @use_secmod_trust = token.attr_provider.attr_nss_use_secmod_trust
    end
    
    typesig { [String, Array.typed(::Java::Char)] }
    # Returns the key associated with the given alias.
    # The key must have been associated with
    # the alias by a call to <code>setKeyEntry</code>,
    # or by a call to <code>setEntry</code> with a
    # <code>PrivateKeyEntry</code> or <code>SecretKeyEntry</code>.
    # 
    # @param alias the alias name
    # @param password the password, which must be <code>null</code>
    # 
    # @return the requested key, or null if the given alias does not exist
    # or does not identify a key-related entry.
    # 
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # key cannot be found
    # @exception UnrecoverableKeyException if the key cannot be recovered
    def engine_get_key(alias_, password)
      synchronized(self) do
        @token.ensure_valid
        if (!(password).nil? && !@token.attr_config.get_key_store_compatibility_mode)
          raise NoSuchAlgorithmException.new("password must be null")
        end
        alias_info = @alias_map.get(alias_)
        if ((alias_info).nil? || (alias_info.attr_type).equal?(ATTR_CLASS_CERT))
          return nil
        end
        session = nil
        begin
          session = @token.get_op_session
          if ((alias_info.attr_type).equal?(ATTR_CLASS_PKEY))
            h = get_token_object(session, alias_info.attr_type, alias_info.attr_id, nil)
            if ((h.attr_type).equal?(ATTR_CLASS_PKEY))
              return load_pkey(session, h.attr_handle)
            end
          else
            h = get_token_object(session, ATTR_CLASS_SKEY, nil, alias_)
            if ((h.attr_type).equal?(ATTR_CLASS_SKEY))
              return load_skey(session, h.attr_handle)
            end
          end
          # did not find anything
          return nil
        rescue PKCS11Exception => pe
          raise ProviderException.new(pe)
        rescue KeyStoreException => ke
          raise ProviderException.new(ke)
        ensure
          @token.release_session(session)
        end
      end
    end
    
    typesig { [String] }
    # Returns the certificate chain associated with the given alias.
    # The certificate chain must have been associated with the alias
    # by a call to <code>setKeyEntry</code>,
    # or by a call to <code>setEntry</code> with a
    # <code>PrivateKeyEntry</code>.
    # 
    # @param alias the alias name
    # 
    # @return the certificate chain (ordered with the user's certificate first
    # and the root certificate authority last), or null if the given alias
    # does not exist or does not contain a certificate chain
    def engine_get_certificate_chain(alias_)
      synchronized(self) do
        @token.ensure_valid
        alias_info = @alias_map.get(alias_)
        if ((alias_info).nil? || !(alias_info.attr_type).equal?(ATTR_CLASS_PKEY))
          return nil
        end
        return alias_info.attr_chain
      end
    end
    
    typesig { [String] }
    # Returns the certificate associated with the given alias.
    # 
    # <p> If the given alias name identifies an entry
    # created by a call to <code>setCertificateEntry</code>,
    # or created by a call to <code>setEntry</code> with a
    # <code>TrustedCertificateEntry</code>,
    # then the trusted certificate contained in that entry is returned.
    # 
    # <p> If the given alias name identifies an entry
    # created by a call to <code>setKeyEntry</code>,
    # or created by a call to <code>setEntry</code> with a
    # <code>PrivateKeyEntry</code>,
    # then the first element of the certificate chain in that entry
    # (if a chain exists) is returned.
    # 
    # @param alias the alias name
    # 
    # @return the certificate, or null if the given alias does not exist or
    # does not contain a certificate.
    def engine_get_certificate(alias_)
      synchronized(self) do
        @token.ensure_valid
        alias_info = @alias_map.get(alias_)
        if ((alias_info).nil?)
          return nil
        end
        return alias_info.attr_cert
      end
    end
    
    typesig { [String] }
    # Returns the creation date of the entry identified by the given alias.
    # 
    # @param alias the alias name
    # 
    # @return the creation date of this entry, or null if the given alias does
    # not exist
    def engine_get_creation_date(alias_)
      @token.ensure_valid
      raise ProviderException.new(UnsupportedOperationException.new)
    end
    
    typesig { [String, Key, Array.typed(::Java::Char), Array.typed(Certificate)] }
    # Assigns the given key to the given alias, protecting it with the given
    # password.
    # 
    # <p>If the given key is of type <code>java.security.PrivateKey</code>,
    # it must be accompanied by a certificate chain certifying the
    # corresponding public key.
    # 
    # <p>If the given alias already exists, the keystore information
    # associated with it is overridden by the given key (and possibly
    # certificate chain).
    # 
    # @param alias the alias name
    # @param key the key to be associated with the alias
    # @param password the password to protect the key
    # @param chain the certificate chain for the corresponding public
    # key (only required if the given key is of type
    # <code>java.security.PrivateKey</code>).
    # 
    # @exception KeyStoreException if the given key cannot be protected, or
    # this operation fails for some other reason
    def engine_set_key_entry(alias_, key, password, chain)
      synchronized(self) do
        @token.ensure_valid
        check_write
        if (!(key.is_a?(PrivateKey)) && !(key.is_a?(SecretKey)))
          raise KeyStoreException.new("key must be PrivateKey or SecretKey")
        else
          if (key.is_a?(PrivateKey) && (chain).nil?)
            raise KeyStoreException.new("PrivateKey must be accompanied by non-null chain")
          else
            if (key.is_a?(SecretKey) && !(chain).nil?)
              raise KeyStoreException.new("SecretKey must be accompanied by null chain")
            else
              if (!(password).nil? && !@token.attr_config.get_key_store_compatibility_mode)
                raise KeyStoreException.new("Password must be null")
              end
            end
          end
        end
        entry = nil
        begin
          if (key.is_a?(PrivateKey))
            entry = KeyStore::PrivateKeyEntry.new(key, chain)
          else
            if (key.is_a?(SecretKey))
              entry = KeyStore::SecretKeyEntry.new(key)
            end
          end
        rescue NullPointerException => npe
          raise KeyStoreException.new(npe)
        rescue IllegalArgumentException => iae
          raise KeyStoreException.new(iae)
        end
        engine_set_entry(alias_, entry, KeyStore::PasswordProtection.new(password))
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte), Array.typed(Certificate)] }
    # Assigns the given key (that has already been protected) to the given
    # alias.
    # 
    # <p>If the protected key is of type
    # <code>java.security.PrivateKey</code>,
    # it must be accompanied by a certificate chain certifying the
    # corresponding public key.
    # 
    # <p>If the given alias already exists, the keystore information
    # associated with it is overridden by the given key (and possibly
    # certificate chain).
    # 
    # @param alias the alias name
    # @param key the key (in protected format) to be associated with the alias
    # @param chain the certificate chain for the corresponding public
    # key (only useful if the protected key is of type
    # <code>java.security.PrivateKey</code>).
    # 
    # @exception KeyStoreException if this operation fails.
    def engine_set_key_entry(alias_, key, chain)
      @token.ensure_valid
      raise ProviderException.new(UnsupportedOperationException.new)
    end
    
    typesig { [String, Certificate] }
    # Assigns the given certificate to the given alias.
    # 
    # <p> If the given alias identifies an existing entry
    # created by a call to <code>setCertificateEntry</code>,
    # or created by a call to <code>setEntry</code> with a
    # <code>TrustedCertificateEntry</code>,
    # the trusted certificate in the existing entry
    # is overridden by the given certificate.
    # 
    # @param alias the alias name
    # @param cert the certificate
    # 
    # @exception KeyStoreException if the given alias already exists and does
    # not identify an entry containing a trusted certificate,
    # or this operation fails for some other reason.
    def engine_set_certificate_entry(alias_, cert)
      synchronized(self) do
        @token.ensure_valid
        check_write
        if ((cert).nil?)
          raise KeyStoreException.new("invalid null certificate")
        end
        entry = nil
        entry = KeyStore::TrustedCertificateEntry.new(cert)
        engine_set_entry(alias_, entry, nil)
      end
    end
    
    typesig { [String] }
    # Deletes the entry identified by the given alias from this keystore.
    # 
    # @param alias the alias name
    # 
    # @exception KeyStoreException if the entry cannot be removed.
    def engine_delete_entry(alias_)
      synchronized(self) do
        @token.ensure_valid
        if (@token.is_write_protected)
          raise KeyStoreException.new("token write-protected")
        end
        check_write
        delete_entry(alias_)
      end
    end
    
    typesig { [String] }
    # XXX - not sure whether to keep this
    def delete_entry(alias_)
      alias_info = @alias_map.get(alias_)
      if (!(alias_info).nil?)
        @alias_map.remove(alias_)
        begin
          if ((alias_info.attr_type).equal?(ATTR_CLASS_CERT))
            # trusted certificate entry
            return destroy_cert(alias_info.attr_id)
          else
            if ((alias_info.attr_type).equal?(ATTR_CLASS_PKEY))
              # private key entry
              return destroy_pkey(alias_info.attr_id) && destroy_chain(alias_info.attr_id)
            else
              if ((alias_info.attr_type).equal?(ATTR_CLASS_SKEY))
                # secret key entry
                return destroy_skey(alias_)
              else
                raise KeyStoreException.new("unexpected entry type")
              end
            end
          end
        rescue PKCS11Exception => pe
          raise KeyStoreException.new(pe)
        rescue CertificateException => ce
          raise KeyStoreException.new(ce)
        end
      end
      return false
    end
    
    typesig { [] }
    # Lists all the alias names of this keystore.
    # 
    # @return enumeration of the alias names
    def engine_aliases
      synchronized(self) do
        @token.ensure_valid
        # don't want returned enumeration to iterate off actual keySet -
        # otherwise applications that iterate and modify the keystore
        # may run into concurrent modification problems
        return Collections.enumeration(HashSet.new(@alias_map.key_set))
      end
    end
    
    typesig { [String] }
    # Checks if the given alias exists in this keystore.
    # 
    # @param alias the alias name
    # 
    # @return true if the alias exists, false otherwise
    def engine_contains_alias(alias_)
      synchronized(self) do
        @token.ensure_valid
        return @alias_map.contains_key(alias_)
      end
    end
    
    typesig { [] }
    # Retrieves the number of entries in this keystore.
    # 
    # @return the number of entries in this keystore
    def engine_size
      synchronized(self) do
        @token.ensure_valid
        return @alias_map.size
      end
    end
    
    typesig { [String] }
    # Returns true if the entry identified by the given alias
    # was created by a call to <code>setKeyEntry</code>,
    # or created by a call to <code>setEntry</code> with a
    # <code>PrivateKeyEntry</code> or a <code>SecretKeyEntry</code>.
    # 
    # @param alias the alias for the keystore entry to be checked
    # 
    # @return true if the entry identified by the given alias is a
    # key-related, false otherwise.
    def engine_is_key_entry(alias_)
      synchronized(self) do
        @token.ensure_valid
        alias_info = @alias_map.get(alias_)
        if ((alias_info).nil? || (alias_info.attr_type).equal?(ATTR_CLASS_CERT))
          return false
        end
        return true
      end
    end
    
    typesig { [String] }
    # Returns true if the entry identified by the given alias
    # was created by a call to <code>setCertificateEntry</code>,
    # or created by a call to <code>setEntry</code> with a
    # <code>TrustedCertificateEntry</code>.
    # 
    # @param alias the alias for the keystore entry to be checked
    # 
    # @return true if the entry identified by the given alias contains a
    # trusted certificate, false otherwise.
    def engine_is_certificate_entry(alias_)
      synchronized(self) do
        @token.ensure_valid
        alias_info = @alias_map.get(alias_)
        if ((alias_info).nil? || !(alias_info.attr_type).equal?(ATTR_CLASS_CERT))
          return false
        end
        return true
      end
    end
    
    typesig { [Certificate] }
    # Returns the (alias) name of the first keystore entry whose certificate
    # matches the given certificate.
    # 
    # <p>This method attempts to match the given certificate with each
    # keystore entry. If the entry being considered was
    # created by a call to <code>setCertificateEntry</code>,
    # or created by a call to <code>setEntry</code> with a
    # <code>TrustedCertificateEntry</code>,
    # then the given certificate is compared to that entry's certificate.
    # 
    # <p> If the entry being considered was
    # created by a call to <code>setKeyEntry</code>,
    # or created by a call to <code>setEntry</code> with a
    # <code>PrivateKeyEntry</code>,
    # then the given certificate is compared to the first
    # element of that entry's certificate chain.
    # 
    # @param cert the certificate to match with.
    # 
    # @return the alias name of the first entry with matching certificate,
    # or null if no such entry exists in this keystore.
    def engine_get_certificate_alias(cert)
      synchronized(self) do
        @token.ensure_valid
        e = engine_aliases
        while (e.has_more_elements)
          alias_ = e.next_element
          token_cert = engine_get_certificate(alias_)
          if (!(token_cert).nil? && (token_cert == cert))
            return alias_
          end
        end
        return nil
      end
    end
    
    typesig { [OutputStream, Array.typed(::Java::Char)] }
    # engineStore currently is a No-op.
    # Entries are stored to the token during engineSetEntry
    # 
    # @param stream this must be <code>null</code>
    # @param password this must be <code>null</code>
    def engine_store(stream, password)
      synchronized(self) do
        @token.ensure_valid
        if (!(stream).nil? && !@token.attr_config.get_key_store_compatibility_mode)
          raise IOException.new("output stream must be null")
        end
        if (!(password).nil? && !@token.attr_config.get_key_store_compatibility_mode)
          raise IOException.new("password must be null")
        end
      end
    end
    
    typesig { [KeyStore::LoadStoreParameter] }
    # engineStore currently is a No-op.
    # Entries are stored to the token during engineSetEntry
    # 
    # @param param this must be <code>null</code>
    # 
    # @exception IllegalArgumentException if the given
    # <code>KeyStore.LoadStoreParameter</code>
    # input is not <code>null</code>
    def engine_store(param)
      synchronized(self) do
        @token.ensure_valid
        if (!(param).nil?)
          raise IllegalArgumentException.new("LoadStoreParameter must be null")
        end
      end
    end
    
    typesig { [InputStream, Array.typed(::Java::Char)] }
    # Loads the keystore.
    # 
    # @param stream the input stream, which must be <code>null</code>
    # @param password the password used to unlock the keystore,
    # or <code>null</code> if the token supports a
    # CKF_PROTECTED_AUTHENTICATION_PATH
    # 
    # @exception IOException if the given <code>stream</code> is not
    # <code>null</code>, if the token supports a
    # CKF_PROTECTED_AUTHENTICATION_PATH and a non-null
    # password is given, of if the token login operation failed
    def engine_load(stream, password)
      synchronized(self) do
        @token.ensure_valid
        if (NSS_TEST)
          self.attr_attr_skey_token_true = CK_ATTRIBUTE.new(CKA_TOKEN, false)
        end
        if (!(stream).nil? && !@token.attr_config.get_key_store_compatibility_mode)
          raise IOException.new("input stream must be null")
        end
        if (@use_secmod_trust)
          @nss_trust_type = Secmod::TrustType::ALL
        end
        begin
          if ((password).nil?)
            login(nil)
          else
            login(PasswordCallbackHandler.new(password))
          end
          if ((map_labels).equal?(true))
            # CKA_LABELs are shared by multiple certs
            @write_disabled = true
          end
          if (!(Debug).nil?)
            dump_token_map
          end
        rescue LoginException => le
          ioe = IOException.new("load failed")
          ioe.init_cause(le)
          raise ioe
        rescue KeyStoreException => kse
          ioe = IOException.new("load failed")
          ioe.init_cause(kse)
          raise ioe
        rescue PKCS11Exception => pe
          ioe = IOException.new("load failed")
          ioe.init_cause(pe)
          raise ioe
        end
      end
    end
    
    typesig { [KeyStore::LoadStoreParameter] }
    # Loads the keystore using the given
    # <code>KeyStore.LoadStoreParameter</code>.
    # 
    # <p> The <code>LoadStoreParameter.getProtectionParameter()</code>
    # method is expected to return a <code>KeyStore.PasswordProtection</code>
    # object.  The password is retrieved from that object and used
    # to unlock the PKCS#11 token.
    # 
    # <p> If the token supports a CKF_PROTECTED_AUTHENTICATION_PATH
    # then the provided password must be <code>null</code>.
    # 
    # @param param the <code>KeyStore.LoadStoreParameter</code>
    # 
    # @exception IllegalArgumentException if the given
    # <code>KeyStore.LoadStoreParameter</code> is <code>null</code>,
    # or if that parameter returns a <code>null</code>
    # <code>ProtectionParameter</code> object.
    # input is not recognized
    # @exception IOException if the token supports a
    # CKF_PROTECTED_AUTHENTICATION_PATH and the provided password
    # is non-null, or if the token login operation fails
    def engine_load(param)
      synchronized(self) do
        @token.ensure_valid
        if (NSS_TEST)
          self.attr_attr_skey_token_true = CK_ATTRIBUTE.new(CKA_TOKEN, false)
        end
        # if caller wants to pass a NULL password,
        # force it to pass a non-NULL PasswordProtection that returns
        # a NULL password
        if ((param).nil?)
          raise IllegalArgumentException.new("invalid null LoadStoreParameter")
        end
        if (@use_secmod_trust)
          if (param.is_a?(Secmod::KeyStoreLoadParameter))
            @nss_trust_type = (param).get_trust_type
          else
            @nss_trust_type = Secmod::TrustType::ALL
          end
        end
        handler = nil
        pp = param.get_protection_parameter
        if (pp.is_a?(PasswordProtection))
          password = (pp).get_password
          if ((password).nil?)
            handler = nil
          else
            handler = PasswordCallbackHandler.new(password)
          end
        else
          if (pp.is_a?(CallbackHandlerProtection))
            handler = (pp).get_callback_handler
          else
            raise IllegalArgumentException.new("ProtectionParameter must be either " + "PasswordProtection or CallbackHandlerProtection")
          end
        end
        begin
          login(handler)
          if ((map_labels).equal?(true))
            # CKA_LABELs are shared by multiple certs
            @write_disabled = true
          end
          if (!(Debug).nil?)
            dump_token_map
          end
        rescue LoginException => e
          raise IOException.new("load failed", e)
        rescue KeyStoreException => e
          raise IOException.new("load failed", e)
        rescue PKCS11Exception => e
          raise IOException.new("load failed", e)
        end
      end
    end
    
    typesig { [CallbackHandler] }
    def login(handler)
      if (((@token.attr_token_info.attr_flags & CKF_PROTECTED_AUTHENTICATION_PATH)).equal?(0))
        @token.attr_provider.login(nil, handler)
      else
        # token supports protected authentication path
        # (external pin-pad, for example)
        if (!(handler).nil? && !@token.attr_config.get_key_store_compatibility_mode)
          raise LoginException.new("can not specify password if token " + "supports protected authentication path")
        end
        # must rely on application-set or default handler
        # if one is necessary
        @token.attr_provider.login(nil, nil)
      end
    end
    
    typesig { [String, KeyStore::ProtectionParameter] }
    # Get a <code>KeyStore.Entry</code> for the specified alias
    # 
    # @param alias get the <code>KeyStore.Entry</code> for this alias
    # @param protParam this must be <code>null</code>
    # 
    # @return the <code>KeyStore.Entry</code> for the specified alias,
    # or <code>null</code> if there is no such entry
    # 
    # @exception KeyStoreException if the operation failed
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # entry cannot be found
    # @exception UnrecoverableEntryException if the specified
    # <code>protParam</code> were insufficient or invalid
    # 
    # @since 1.5
    def engine_get_entry(alias_, prot_param)
      synchronized(self) do
        @token.ensure_valid
        if (!(prot_param).nil? && prot_param.is_a?(KeyStore::PasswordProtection) && !((prot_param).get_password).nil? && !@token.attr_config.get_key_store_compatibility_mode)
          raise KeyStoreException.new("ProtectionParameter must be null")
        end
        alias_info = @alias_map.get(alias_)
        if ((alias_info).nil?)
          if (!(Debug).nil?)
            Debug.println("engineGetEntry did not find alias [" + alias_ + "] in map")
          end
          return nil
        end
        session = nil
        begin
          session = @token.get_op_session
          if ((alias_info.attr_type).equal?(ATTR_CLASS_CERT))
            # trusted certificate entry
            if (!(Debug).nil?)
              Debug.println("engineGetEntry found trusted cert entry")
            end
            return KeyStore::TrustedCertificateEntry.new(alias_info.attr_cert)
          else
            if ((alias_info.attr_type).equal?(ATTR_CLASS_SKEY))
              # secret key entry
              if (!(Debug).nil?)
                Debug.println("engineGetEntry found secret key entry")
              end
              h = get_token_object(session, ATTR_CLASS_SKEY, nil, alias_info.attr_label)
              if (!(h.attr_type).equal?(ATTR_CLASS_SKEY))
                raise KeyStoreException.new("expected but could not find secret key")
              else
                skey = load_skey(session, h.attr_handle)
                return KeyStore::SecretKeyEntry.new(skey)
              end
            else
              # private key entry
              if (!(Debug).nil?)
                Debug.println("engineGetEntry found private key entry")
              end
              h = get_token_object(session, ATTR_CLASS_PKEY, alias_info.attr_id, nil)
              if (!(h.attr_type).equal?(ATTR_CLASS_PKEY))
                raise KeyStoreException.new("expected but could not find private key")
              else
                pkey = load_pkey(session, h.attr_handle)
                chain = alias_info.attr_chain
                if ((!(pkey).nil?) && (!(chain).nil?))
                  return KeyStore::PrivateKeyEntry.new(pkey, chain)
                else
                  if (!(Debug).nil?)
                    Debug.println("engineGetEntry got null cert chain or private key")
                  end
                end
              end
            end
          end
          return nil
        rescue PKCS11Exception => pe
          raise KeyStoreException.new(pe)
        ensure
          @token.release_session(session)
        end
      end
    end
    
    typesig { [String, KeyStore::Entry, KeyStore::ProtectionParameter] }
    # Save a <code>KeyStore.Entry</code> under the specified alias.
    # 
    # <p> If an entry already exists for the specified alias,
    # it is overridden.
    # 
    # <p> This KeyStore implementation only supports the standard
    # entry types, and only supports X509Certificates in
    # TrustedCertificateEntries.  Also, this implementation does not support
    # protecting entries using a different password
    # from the one used for token login.
    # 
    # <p> Entries are immediately stored on the token.
    # 
    # @param alias save the <code>KeyStore.Entry</code> under this alias
    # @param entry the <code>Entry</code> to save
    # @param protParam this must be <code>null</code>
    # 
    # @exception KeyStoreException if this operation fails
    # 
    # @since 1.5
    def engine_set_entry(alias_, entry, prot_param)
      synchronized(self) do
        @token.ensure_valid
        check_write
        if (!(prot_param).nil? && prot_param.is_a?(KeyStore::PasswordProtection) && !((prot_param).get_password).nil? && !@token.attr_config.get_key_store_compatibility_mode)
          raise KeyStoreException.new(UnsupportedOperationException.new("ProtectionParameter must be null"))
        end
        if (@token.is_write_protected)
          raise KeyStoreException.new("token write-protected")
        end
        if (entry.is_a?(KeyStore::TrustedCertificateEntry))
          if ((@use_secmod_trust).equal?(false))
            # PKCS #11 does not allow app to modify trusted certs -
            raise KeyStoreException.new(UnsupportedOperationException.new("trusted certificates may only be set by " + "token initialization application"))
          end
          module_ = @token.attr_provider.attr_nss_module
          if ((!(module_.attr_type).equal?(ModuleType::KEYSTORE)) && (!(module_.attr_type).equal?(ModuleType::FIPS)))
            # XXX allow TRUSTANCHOR module
            raise KeyStoreException.new("Trusted certificates can only be " + "added to the NSS KeyStore module")
          end
          cert = (entry).get_trusted_certificate
          if ((cert.is_a?(X509Certificate)).equal?(false))
            raise KeyStoreException.new("Certificate must be an X509Certificate")
          end
          xcert = cert
          info = @alias_map.get(alias_)
          if (!(info).nil?)
            # XXX try to update
            delete_entry(alias_)
          end
          begin
            store_cert(alias_, xcert)
            module_.set_trust(@token, xcert)
            map_labels
          rescue PKCS11Exception => e
            raise KeyStoreException.new(e)
          rescue CertificateException => e
            raise KeyStoreException.new(e)
          end
        else
          if (entry.is_a?(KeyStore::PrivateKeyEntry))
            key = (entry).get_private_key
            if (!(key.is_a?(P11Key)) && !(key.is_a?(RSAPrivateKey)) && !(key.is_a?(DSAPrivateKey)) && !(key.is_a?(DHPrivateKey)) && !(key.is_a?(ECPrivateKey)))
              raise KeyStoreException.new("unsupported key type: " + RJava.cast_to_string(key.get_class.get_name))
            end
            # only support X509Certificate chains
            chain = (entry).get_certificate_chain
            if (!(chain.is_a?(Array.typed(X509Certificate))))
              raise KeyStoreException.new(UnsupportedOperationException.new("unsupported certificate array type: " + RJava.cast_to_string(chain.get_class.get_name)))
            end
            begin
              updated_alias = false
              aliases = @alias_map.key_set
              aliases.each do |oldAlias|
                # see if there's an existing entry with the same info
                alias_info = @alias_map.get(old_alias)
                if ((alias_info.attr_type).equal?(ATTR_CLASS_PKEY) && (alias_info.attr_cert.get_public_key == chain[0].get_public_key))
                  # found existing entry -
                  # caller is renaming entry or updating cert chain
                  # 
                  # set new CKA_LABEL/CKA_ID
                  # and update certs if necessary
                  update_pkey(alias_, alias_info.attr_id, chain, !(alias_info.attr_cert == chain[0]))
                  updated_alias = true
                  break
                end
              end
              if (!updated_alias)
                # caller adding new entry
                engine_delete_entry(alias_)
                store_pkey(alias_, entry)
              end
            rescue PKCS11Exception => pe
              raise KeyStoreException.new(pe)
            rescue CertificateException => ce
              raise KeyStoreException.new(ce)
            end
          else
            if (entry.is_a?(KeyStore::SecretKeyEntry))
              ske = entry
              skey = ske.get_secret_key
              begin
                # first see if the key already exists.
                # if so, update the CKA_LABEL
                if (!update_skey(alias_))
                  # key entry does not exist.
                  # delete existing entry for alias and
                  # create new secret key entry
                  # (new entry might be a secret key
                  # session object converted into a token object)
                  engine_delete_entry(alias_)
                  store_skey(alias_, ske)
                end
              rescue PKCS11Exception => pe
                raise KeyStoreException.new(pe)
              end
            else
              raise KeyStoreException.new(UnsupportedOperationException.new("unsupported entry type: " + RJava.cast_to_string(entry.get_class.get_name)))
            end
          end
          begin
            # XXX  NSS does not write out the CKA_ID we pass to them
            # 
            # therefore we must re-map labels
            # (can not simply update aliasMap)
            map_labels
            if (!(Debug).nil?)
              dump_token_map
            end
          rescue PKCS11Exception => pe
            raise KeyStoreException.new(pe)
          rescue CertificateException => ce
            raise KeyStoreException.new(ce)
          end
        end
        if (!(Debug).nil?)
          Debug.println("engineSetEntry added new entry for [" + alias_ + "] to token")
        end
      end
    end
    
    typesig { [String, Class] }
    # Determines if the keystore <code>Entry</code> for the specified
    # <code>alias</code> is an instance or subclass of the specified
    # <code>entryClass</code>.
    # 
    # @param alias the alias name
    # @param entryClass the entry class
    # 
    # @return true if the keystore <code>Entry</code> for the specified
    # <code>alias</code> is an instance or subclass of the
    # specified <code>entryClass</code>, false otherwise
    def engine_entry_instance_of(alias_, entry_class)
      synchronized(self) do
        @token.ensure_valid
        return super(alias_, entry_class)
      end
    end
    
    typesig { [Session, ::Java::Long] }
    def load_cert(session, o_handle)
      attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE)])
      @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
      bytes = attrs[0].get_byte_array
      if ((bytes).nil?)
        raise CertificateException.new("unexpectedly retrieved null byte array")
      end
      cf = CertificateFactory.get_instance("X.509")
      return cf.generate_certificate(ByteArrayInputStream.new(bytes))
    end
    
    typesig { [Session, X509Certificate] }
    def load_chain(session, end_cert)
      l_chain = nil
      if ((end_cert.get_subject_x500principal == end_cert.get_issuer_x500principal))
        # self signed
        return Array.typed(X509Certificate).new([end_cert])
      else
        l_chain = ArrayList.new
        l_chain.add(end_cert)
      end
      # try loading remaining certs in chain by following
      # issuer->subject links
      next_ = end_cert
      while (true)
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_CERT, CK_ATTRIBUTE.new(CKA_SUBJECT, next_.get_issuer_x500principal.get_encoded)])
        ch = find_objects(session, attrs)
        if ((ch).nil? || (ch.attr_length).equal?(0))
          # done
          break
        else
          # if more than one found, use first
          if (!(Debug).nil? && ch.attr_length > 1)
            Debug.println("engineGetEntry found " + RJava.cast_to_string(ch.attr_length) + " certificate entries for subject [" + RJava.cast_to_string(next_.get_issuer_x500principal.to_s) + "] in token - using first entry")
          end
          next_ = load_cert(session, ch[0])
          l_chain.add(next_)
          if ((next_.get_subject_x500principal == next_.get_issuer_x500principal))
            # self signed
            break
          end
        end
      end
      return l_chain.to_array(Array.typed(X509Certificate).new(l_chain.size) { nil })
    end
    
    typesig { [Session, ::Java::Long] }
    def load_skey(session, o_handle)
      attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_KEY_TYPE)])
      @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
      k_type = attrs[0].get_long
      key_type = nil
      key_length = -1
      # XXX NSS mangles the stored key type for secret key token objects
      if ((k_type).equal?(CKK_DES) || (k_type).equal?(CKK_DES3))
        if ((k_type).equal?(CKK_DES))
          key_type = "DES"
          key_length = 64
        else
          if ((k_type).equal?(CKK_DES3))
            key_type = "DESede"
            key_length = 192
          end
        end
      else
        if ((k_type).equal?(CKK_AES))
          key_type = "AES"
        else
          if ((k_type).equal?(CKK_BLOWFISH))
            key_type = "Blowfish"
          else
            if ((k_type).equal?(CKK_RC4))
              key_type = "ARCFOUR"
            else
              if (!(Debug).nil?)
                Debug.println("unknown key type [" + RJava.cast_to_string(k_type) + "] - using 'Generic Secret'")
              end
              key_type = "Generic Secret"
            end
          end
        end
        # XXX NSS problem CKR_ATTRIBUTE_TYPE_INVALID?
        if (NSS_TEST)
          key_length = 128
        else
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE_LEN)])
          @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
          key_length = RJava.cast_to_int(attrs[0].get_long)
        end
      end
      return P11Key.secret_key(session, o_handle, key_type, key_length, nil)
    end
    
    typesig { [Session, ::Java::Long] }
    def load_pkey(session, o_handle)
      attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_KEY_TYPE)])
      @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
      k_type = attrs[0].get_long
      key_type = nil
      key_length = 0
      if ((k_type).equal?(CKK_RSA))
        key_type = "RSA"
        attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_MODULUS)])
        @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
        modulus = attrs[0].get_big_integer
        key_length = modulus.bit_length
        # This check will combine our "don't care" values here
        # with the system-wide min/max values.
        begin
          RSAKeyFactory.check_key_lengths(key_length, nil, -1, JavaInteger::MAX_VALUE)
        rescue InvalidKeyException => e
          raise KeyStoreException.new(e.get_message)
        end
        return P11Key.private_key(session, o_handle, key_type, key_length, nil)
      else
        if ((k_type).equal?(CKK_DSA))
          key_type = "DSA"
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_PRIME)])
          @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
          prime = attrs[0].get_big_integer
          key_length = prime.bit_length
          return P11Key.private_key(session, o_handle, key_type, key_length, nil)
        else
          if ((k_type).equal?(CKK_DH))
            key_type = "DH"
            attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_PRIME)])
            @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
            prime = attrs[0].get_big_integer
            key_length = prime.bit_length
            return P11Key.private_key(session, o_handle, key_type, key_length, nil)
          else
            if ((k_type).equal?(CKK_EC))
              attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_EC_PARAMS), ])
              @token.attr_p11._c_get_attribute_value(session.id, o_handle, attrs)
              encoded_params = attrs[0].get_byte_array
              begin
                params = ECParameters.decode_parameters(encoded_params)
                key_length = params.get_curve.get_field.get_field_size
              rescue IOException => e
                # we do not want to accept key with unsupported parameters
                raise KeyStoreException.new("Unsupported parameters", e)
              end
              return P11Key.private_key(session, o_handle, "EC", key_length, nil)
            else
              if (!(Debug).nil?)
                Debug.println("unknown key type [" + RJava.cast_to_string(k_type) + "]")
              end
              raise KeyStoreException.new("unknown key type")
            end
          end
        end
      end
    end
    
    typesig { [String] }
    # return true if update occurred
    def update_skey(alias_)
      session = nil
      begin
        session = @token.get_op_session
        # first update existing secret key CKA_LABEL
        h = get_token_object(session, ATTR_CLASS_SKEY, nil, alias_)
        if (!(h.attr_type).equal?(ATTR_CLASS_SKEY))
          if (!(Debug).nil?)
            Debug.println("did not find secret key " + "with CKA_LABEL [" + alias_ + "]")
          end
          return false
        end
        attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_LABEL, alias_)])
        @token.attr_p11._c_set_attribute_value(session.id, h.attr_handle, attrs)
        if (!(Debug).nil?)
          Debug.println("updateSkey set new alias [" + alias_ + "] for secret key entry")
        end
        return true
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte), Array.typed(X509Certificate), ::Java::Boolean] }
    # XXX  On ibutton, when you C_SetAttribute(CKA_ID) for a private key
    # it not only changes the CKA_ID of the private key,
    # it changes the CKA_ID of the corresponding cert too.
    # And vice versa.
    # 
    # XXX  On ibutton, CKR_DEVICE_ERROR if you C_SetAttribute(CKA_ID)
    # for a private key, and then try to delete the corresponding cert.
    # So this code reverses the order.
    # After the cert is first destroyed (if necessary),
    # then the CKA_ID of the private key can be changed successfully.
    # 
    # @param replaceCert if true, then caller is updating alias info for
    # existing cert (only update CKA_ID/CKA_LABEL).
    # if false, then caller is updating cert chain
    # (delete old end cert and add new chain).
    def update_pkey(alias_, cka_id, chain, replace_cert)
      # XXX
      # 
      # always set replaceCert to true
      # 
      # NSS does not allow resetting of CKA_LABEL on an existing cert
      # (C_SetAttribute call succeeds, but is ignored)
      replace_cert = true
      session = nil
      begin
        session = @token.get_op_session
        # first get private key object handle and hang onto it
        h = get_token_object(session, ATTR_CLASS_PKEY, cka_id, nil)
        p_key_handle = 0
        if ((h.attr_type).equal?(ATTR_CLASS_PKEY))
          p_key_handle = h.attr_handle
        else
          raise KeyStoreException.new("expected but could not find private key " + "with CKA_ID " + RJava.cast_to_string(get_id(cka_id)))
        end
        # next find existing end entity cert
        h = get_token_object(session, ATTR_CLASS_CERT, cka_id, nil)
        if (!(h.attr_type).equal?(ATTR_CLASS_CERT))
          raise KeyStoreException.new("expected but could not find certificate " + "with CKA_ID " + RJava.cast_to_string(get_id(cka_id)))
        else
          if (replace_cert)
            # replacing existing cert and chain
            destroy_chain(cka_id)
          else
            # renaming alias for existing cert
            attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_LABEL, alias_), CK_ATTRIBUTE.new(CKA_ID, alias_)])
            @token.attr_p11._c_set_attribute_value(session.id, h.attr_handle, attrs)
          end
        end
        # add new chain
        if (replace_cert)
          # add all certs in chain
          store_chain(alias_, chain)
        else
          # already updated alias info for existing end cert -
          # just update CA certs
          store_ca_certs(chain, 1)
        end
        # finally update CKA_ID for private key
        # 
        # ibutton may have already done this (that is ok)
        attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_ID, alias_)])
        @token.attr_p11._c_set_attribute_value(session.id, p_key_handle, attrs)
        if (!(Debug).nil?)
          Debug.println("updatePkey set new alias [" + alias_ + "] for private key entry")
        end
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [String, P11Key] }
    def update_p11skey(alias_, key)
      session = nil
      begin
        session = @token.get_op_session
        # session key - convert to token key and set CKA_LABEL
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, CK_ATTRIBUTE.new(CKA_LABEL, alias_)])
        @token.attr_p11._c_copy_object(session.id, key.attr_key_id, attrs)
        if (!(Debug).nil?)
          Debug.println("updateP11Skey copied secret session key " + "for [" + alias_ + "] to token entry")
        end
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [String, CK_ATTRIBUTE, P11Key] }
    def update_p11pkey(alias_, attribute, key)
      # if token key, update alias.
      # if session key, convert to token key.
      session = nil
      begin
        session = @token.get_op_session
        if ((key.attr_token_object).equal?(true))
          # token key - set new CKA_ID
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_ID, alias_)])
          @token.attr_p11._c_set_attribute_value(session.id, key.attr_key_id, attrs)
          if (!(Debug).nil?)
            Debug.println("updateP11Pkey set new alias [" + alias_ + "] for key entry")
          end
        else
          # session key - convert to token key and set CKA_ID
          attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, CK_ATTRIBUTE.new(CKA_ID, alias_), ])
          if (!(attribute).nil?)
            attrs = add_attribute(attrs, attribute)
          end
          @token.attr_p11._c_copy_object(session.id, key.attr_key_id, attrs)
          if (!(Debug).nil?)
            Debug.println("updateP11Pkey copied private session key " + "for [" + alias_ + "] to token entry")
          end
        end
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [String, X509Certificate] }
    def store_cert(alias_, cert)
      attr_list = ArrayList.new
      attr_list.add(ATTR_TOKEN_TRUE)
      attr_list.add(ATTR_CLASS_CERT)
      attr_list.add(ATTR_X509_CERT_TYPE)
      attr_list.add(CK_ATTRIBUTE.new(CKA_SUBJECT, cert.get_subject_x500principal.get_encoded))
      attr_list.add(CK_ATTRIBUTE.new(CKA_ISSUER, cert.get_issuer_x500principal.get_encoded))
      attr_list.add(CK_ATTRIBUTE.new(CKA_SERIAL_NUMBER, cert.get_serial_number.to_byte_array))
      attr_list.add(CK_ATTRIBUTE.new(CKA_VALUE, cert.get_encoded))
      if (!(alias_).nil?)
        attr_list.add(CK_ATTRIBUTE.new(CKA_LABEL, alias_))
        attr_list.add(CK_ATTRIBUTE.new(CKA_ID, alias_))
      else
        # ibutton requires something to be set
        # - alias must be unique
        attr_list.add(CK_ATTRIBUTE.new(CKA_ID, get_id(cert.get_subject_x500principal.get_name(X500Principal::CANONICAL), cert)))
      end
      session = nil
      begin
        session = @token.get_op_session
        @token.attr_p11._c_create_object(session.id, attr_list.to_array(Array.typed(CK_ATTRIBUTE).new(attr_list.size) { nil }))
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [String, Array.typed(X509Certificate)] }
    def store_chain(alias_, chain)
      # add new chain
      # 
      # end cert has CKA_LABEL and CKA_ID set to alias.
      # other certs in chain have neither set.
      store_cert(alias_, chain[0])
      store_ca_certs(chain, 1)
    end
    
    typesig { [Array.typed(X509Certificate), ::Java::Int] }
    def store_ca_certs(chain, start)
      # do not add duplicate CA cert if already in token
      # 
      # XXX   ibutton stores duplicate CA certs, NSS does not
      session = nil
      cacerts = HashSet.new
      begin
        session = @token.get_op_session
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_CERT])
        handles = find_objects(session, attrs)
        # load certs currently on the token
        handles.each do |handle|
          cacerts.add(load_cert(session, handle))
        end
      ensure
        @token.release_session(session)
      end
      i = start
      while i < chain.attr_length
        if (!cacerts.contains(chain[i]))
          store_cert(nil, chain[i])
        else
          if (!(Debug).nil?)
            Debug.println("ignoring duplicate CA cert for [" + RJava.cast_to_string(chain[i].get_subject_x500principal) + "]")
          end
        end
        i += 1
      end
    end
    
    typesig { [String, KeyStore::SecretKeyEntry] }
    def store_skey(alias_, ske)
      skey = ske.get_secret_key
      key_type = CKK_GENERIC_SECRET
      if (skey.is_a?(P11Key) && (@token).equal?((skey).attr_token))
        update_p11skey(alias_, skey)
        return
      end
      if ("AES".equals_ignore_case(skey.get_algorithm))
        key_type = CKK_AES
      else
        if ("Blowfish".equals_ignore_case(skey.get_algorithm))
          key_type = CKK_BLOWFISH
        else
          if ("DES".equals_ignore_case(skey.get_algorithm))
            key_type = CKK_DES
          else
            if ("DESede".equals_ignore_case(skey.get_algorithm))
              key_type = CKK_DES3
            else
              if ("RC4".equals_ignore_case(skey.get_algorithm) || "ARCFOUR".equals_ignore_case(skey.get_algorithm))
                key_type = CKK_RC4
              end
            end
          end
        end
      end
      attrs = Array.typed(CK_ATTRIBUTE).new([self.attr_attr_skey_token_true, ATTR_CLASS_SKEY, ATTR_PRIVATE_TRUE, CK_ATTRIBUTE.new(CKA_KEY_TYPE, key_type), CK_ATTRIBUTE.new(CKA_LABEL, alias_), CK_ATTRIBUTE.new(CKA_VALUE, skey.get_encoded)])
      attrs = @token.get_attributes(TemplateManager::O_IMPORT, CKO_SECRET_KEY, key_type, attrs)
      # create the new entry
      session = nil
      begin
        session = @token.get_op_session
        @token.attr_p11._c_create_object(session.id, attrs)
        if (!(Debug).nil?)
          Debug.println("storeSkey created token secret key for [" + alias_ + "]")
        end
      ensure
        @token.release_session(session)
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(CK_ATTRIBUTE), CK_ATTRIBUTE] }
      def add_attribute(attrs, attr)
        n = attrs.attr_length
        new_attrs = Array.typed(CK_ATTRIBUTE).new(n + 1) { nil }
        System.arraycopy(attrs, 0, new_attrs, 0, n)
        new_attrs[n] = attr
        return new_attrs
      end
    }
    
    typesig { [String, KeyStore::PrivateKeyEntry] }
    def store_pkey(alias_, pke)
      key = pke.get_private_key
      attrs = nil
      # If the key is a token object on this token, update it instead
      # of creating a duplicate key object.
      # Otherwise, treat a P11Key like any other key, if is is extractable.
      if (key.is_a?(P11Key))
        p11key = key
        if (p11key.attr_token_object && ((p11key.attr_token).equal?(@token)))
          update_p11pkey(alias_, nil, p11key)
          store_chain(alias_, pke.get_certificate_chain)
          return
        end
      end
      use_ndb = @token.attr_config.get_nss_netscape_db_workaround
      public_key = pke.get_certificate.get_public_key
      if (key.is_a?(RSAPrivateKey))
        cert = pke.get_certificate
        attrs = get_rsa_priv_key_attrs(alias_, key, cert.get_subject_x500principal)
      else
        if (key.is_a?(DSAPrivateKey))
          dsa_key = key
          id_attrs = get_id_attributes(key, public_key, false, use_ndb)
          if ((id_attrs[0]).nil?)
            id_attrs[0] = CK_ATTRIBUTE.new(CKA_ID, alias_)
          end
          attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_PKEY, ATTR_PRIVATE_TRUE, CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_DSA), id_attrs[0], CK_ATTRIBUTE.new(CKA_PRIME, dsa_key.get_params.get_p), CK_ATTRIBUTE.new(CKA_SUBPRIME, dsa_key.get_params.get_q), CK_ATTRIBUTE.new(CKA_BASE, dsa_key.get_params.get_g), CK_ATTRIBUTE.new(CKA_VALUE, dsa_key.get_x), ])
          if (!(id_attrs[1]).nil?)
            attrs = add_attribute(attrs, id_attrs[1])
          end
          attrs = @token.get_attributes(TemplateManager::O_IMPORT, CKO_PRIVATE_KEY, CKK_DSA, attrs)
          if (!(Debug).nil?)
            Debug.println("storePkey created DSA template")
          end
        else
          if (key.is_a?(DHPrivateKey))
            dh_key = key
            id_attrs = get_id_attributes(key, public_key, false, use_ndb)
            if ((id_attrs[0]).nil?)
              id_attrs[0] = CK_ATTRIBUTE.new(CKA_ID, alias_)
            end
            attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_PKEY, ATTR_PRIVATE_TRUE, CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_DH), id_attrs[0], CK_ATTRIBUTE.new(CKA_PRIME, dh_key.get_params.get_p), CK_ATTRIBUTE.new(CKA_BASE, dh_key.get_params.get_g), CK_ATTRIBUTE.new(CKA_VALUE, dh_key.get_x), ])
            if (!(id_attrs[1]).nil?)
              attrs = add_attribute(attrs, id_attrs[1])
            end
            attrs = @token.get_attributes(TemplateManager::O_IMPORT, CKO_PRIVATE_KEY, CKK_DH, attrs)
          else
            if (key.is_a?(ECPrivateKey))
              ec_key = key
              id_attrs = get_id_attributes(key, public_key, false, use_ndb)
              if ((id_attrs[0]).nil?)
                id_attrs[0] = CK_ATTRIBUTE.new(CKA_ID, alias_)
              end
              encoded_params = ECParameters.encode_parameters(ec_key.get_params)
              attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_PKEY, ATTR_PRIVATE_TRUE, CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_EC), id_attrs[0], CK_ATTRIBUTE.new(CKA_VALUE, ec_key.get_s), CK_ATTRIBUTE.new(CKA_EC_PARAMS, encoded_params), ])
              if (!(id_attrs[1]).nil?)
                attrs = add_attribute(attrs, id_attrs[1])
              end
              attrs = @token.get_attributes(TemplateManager::O_IMPORT, CKO_PRIVATE_KEY, CKK_EC, attrs)
              if (!(Debug).nil?)
                Debug.println("storePkey created EC template")
              end
            else
              if (key.is_a?(P11Key))
                # sensitive/non-extractable P11Key
                p11key = key
                if (!(p11key.attr_token).equal?(@token))
                  raise KeyStoreException.new("Cannot move sensitive keys across tokens")
                end
                netscape_db = nil
                if (use_ndb)
                  # Note that this currently fails due to an NSS bug.
                  # They do not allow the CKA_NETSCAPE_DB attribute to be
                  # specified during C_CopyObject() and fail with
                  # CKR_ATTRIBUTE_READ_ONLY.
                  # But if we did not specify it, they would fail with
                  # CKA_TEMPLATE_INCOMPLETE, so leave this code in here.
                  id_attrs = get_id_attributes(key, public_key, false, true)
                  netscape_db = id_attrs[1]
                end
                # Update the key object.
                update_p11pkey(alias_, netscape_db, p11key)
                store_chain(alias_, pke.get_certificate_chain)
                return
              else
                raise KeyStoreException.new("unsupported key type: " + RJava.cast_to_string(key))
              end
            end
          end
        end
      end
      session = nil
      begin
        session = @token.get_op_session
        # create private key entry
        @token.attr_p11._c_create_object(session.id, attrs)
        if (!(Debug).nil?)
          Debug.println("storePkey created token key for [" + alias_ + "]")
        end
      ensure
        @token.release_session(session)
      end
      store_chain(alias_, pke.get_certificate_chain)
    end
    
    typesig { [String, RSAPrivateKey, X500Principal] }
    def get_rsa_priv_key_attrs(alias_, key, subject)
      # subject is currently ignored - could be used to set CKA_SUBJECT
      attrs = nil
      if (key.is_a?(RSAPrivateCrtKey))
        if (!(Debug).nil?)
          Debug.println("creating RSAPrivateCrtKey attrs")
        end
        rsa_key = key
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_PKEY, ATTR_PRIVATE_TRUE, CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_RSA), CK_ATTRIBUTE.new(CKA_ID, alias_), CK_ATTRIBUTE.new(CKA_MODULUS, rsa_key.get_modulus), CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT, rsa_key.get_private_exponent), CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT, rsa_key.get_public_exponent), CK_ATTRIBUTE.new(CKA_PRIME_1, rsa_key.get_prime_p), CK_ATTRIBUTE.new(CKA_PRIME_2, rsa_key.get_prime_q), CK_ATTRIBUTE.new(CKA_EXPONENT_1, rsa_key.get_prime_exponent_p), CK_ATTRIBUTE.new(CKA_EXPONENT_2, rsa_key.get_prime_exponent_q), CK_ATTRIBUTE.new(CKA_COEFFICIENT, rsa_key.get_crt_coefficient)])
        attrs = @token.get_attributes(TemplateManager::O_IMPORT, CKO_PRIVATE_KEY, CKK_RSA, attrs)
      else
        if (!(Debug).nil?)
          Debug.println("creating RSAPrivateKey attrs")
        end
        rsa_key = key
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_PKEY, ATTR_PRIVATE_TRUE, CK_ATTRIBUTE.new(CKA_KEY_TYPE, CKK_RSA), CK_ATTRIBUTE.new(CKA_ID, alias_), CK_ATTRIBUTE.new(CKA_MODULUS, rsa_key.get_modulus), CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT, rsa_key.get_private_exponent)])
        attrs = @token.get_attributes(TemplateManager::O_IMPORT, CKO_PRIVATE_KEY, CKK_RSA, attrs)
      end
      return attrs
    end
    
    typesig { [PrivateKey, PublicKey, ::Java::Boolean, ::Java::Boolean] }
    # Compute the CKA_ID and/or CKA_NETSCAPE_DB attributes that should be
    # used for this private key. It uses the same algorithm to calculate the
    # values as NSS. The public and private keys MUST match for the result to
    # be correct.
    # 
    # It returns a 2 element array with CKA_ID at index 0 and CKA_NETSCAPE_DB
    # at index 1. The boolean flags determine what is to be calculated.
    # If false or if we could not calculate the value, that element is null.
    # 
    # NOTE that we currently do not use the CKA_ID value calculated by this
    # method.
    def get_id_attributes(private_key_, public_key, id_, netscape_db)
      attrs = Array.typed(CK_ATTRIBUTE).new(2) { nil }
      if (((id_ || netscape_db)).equal?(false))
        return attrs
      end
      alg = private_key_.get_algorithm
      if (id_ && (alg == "RSA") && (public_key.is_a?(RSAPublicKey)))
        # CKA_NETSCAPE_DB not needed for RSA public keys
        n = (public_key).get_modulus
        attrs[0] = CK_ATTRIBUTE.new(CKA_ID, sha1(get_magnitude(n)))
      else
        if ((alg == "DSA") && (public_key.is_a?(DSAPublicKey)))
          y = (public_key).get_y
          if (id_)
            attrs[0] = CK_ATTRIBUTE.new(CKA_ID, sha1(get_magnitude(y)))
          end
          if (netscape_db)
            attrs[1] = CK_ATTRIBUTE.new(CKA_NETSCAPE_DB, y)
          end
        else
          if ((alg == "DH") && (public_key.is_a?(DHPublicKey)))
            y = (public_key).get_y
            if (id_)
              attrs[0] = CK_ATTRIBUTE.new(CKA_ID, sha1(get_magnitude(y)))
            end
            if (netscape_db)
              attrs[1] = CK_ATTRIBUTE.new(CKA_NETSCAPE_DB, y)
            end
          else
            if ((alg == "EC") && (public_key.is_a?(ECPublicKey)))
              ec_pub = public_key
              point = ec_pub.get_w
              params = ec_pub.get_params
              encoded_point = ECParameters.encode_point(point, params.get_curve)
              if (id_)
                attrs[0] = CK_ATTRIBUTE.new(CKA_ID, sha1(encoded_point))
              end
              if (netscape_db)
                attrs[1] = CK_ATTRIBUTE.new(CKA_NETSCAPE_DB, encoded_point)
              end
            else
              raise RuntimeException.new("Unknown key algorithm " + alg)
            end
          end
        end
      end
      return attrs
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # return true if cert destroyed
    def destroy_cert(cka_id)
      session = nil
      begin
        session = @token.get_op_session
        h = get_token_object(session, ATTR_CLASS_CERT, cka_id, nil)
        if (!(h.attr_type).equal?(ATTR_CLASS_CERT))
          return false
        end
        @token.attr_p11._c_destroy_object(session.id, h.attr_handle)
        if (!(Debug).nil?)
          Debug.println("destroyCert destroyed cert with CKA_ID [" + RJava.cast_to_string(get_id(cka_id)) + "]")
        end
        return true
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # return true if chain destroyed
    def destroy_chain(cka_id)
      session = nil
      begin
        session = @token.get_op_session
        h = get_token_object(session, ATTR_CLASS_CERT, cka_id, nil)
        if (!(h.attr_type).equal?(ATTR_CLASS_CERT))
          if (!(Debug).nil?)
            Debug.println("destroyChain could not find " + "end entity cert with CKA_ID [0x" + RJava.cast_to_string(Functions.to_hex_string(cka_id)) + "]")
          end
          return false
        end
        end_cert = load_cert(session, h.attr_handle)
        @token.attr_p11._c_destroy_object(session.id, h.attr_handle)
        if (!(Debug).nil?)
          Debug.println("destroyChain destroyed end entity cert " + "with CKA_ID [" + RJava.cast_to_string(get_id(cka_id)) + "]")
        end
        # build chain following issuer->subject links
        next_ = end_cert
        while (true)
          if ((next_.get_subject_x500principal == next_.get_issuer_x500principal))
            # self signed - done
            break
          end
          attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_CERT, CK_ATTRIBUTE.new(CKA_SUBJECT, next_.get_issuer_x500principal.get_encoded)])
          ch = find_objects(session, attrs)
          if ((ch).nil? || (ch.attr_length).equal?(0))
            # done
            break
          else
            # if more than one found, use first
            if (!(Debug).nil? && ch.attr_length > 1)
              Debug.println("destroyChain found " + RJava.cast_to_string(ch.attr_length) + " certificate entries for subject [" + RJava.cast_to_string(next_.get_issuer_x500principal) + "] in token - using first entry")
            end
            next_ = load_cert(session, ch[0])
            # only delete if not part of any other chain
            attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_CERT, CK_ATTRIBUTE.new(CKA_ISSUER, next_.get_subject_x500principal.get_encoded)])
            issuers = find_objects(session, attrs)
            destroy_it = false
            if ((issuers).nil? || (issuers.attr_length).equal?(0))
              # no other certs with this issuer -
              # destroy it
              destroy_it = true
            else
              if ((issuers.attr_length).equal?(1))
                i_cert = load_cert(session, issuers[0])
                if ((next_ == i_cert))
                  # only cert with issuer is itself (self-signed) -
                  # destroy it
                  destroy_it = true
                end
              end
            end
            if (destroy_it)
              @token.attr_p11._c_destroy_object(session.id, ch[0])
              if (!(Debug).nil?)
                Debug.println("destroyChain destroyed cert in chain " + "with subject [" + RJava.cast_to_string(next_.get_subject_x500principal) + "]")
              end
            else
              if (!(Debug).nil?)
                Debug.println("destroyChain did not destroy " + "shared cert in chain with subject [" + RJava.cast_to_string(next_.get_subject_x500principal) + "]")
              end
            end
          end
        end
        return true
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [String] }
    # return true if secret key destroyed
    def destroy_skey(alias_)
      session = nil
      begin
        session = @token.get_op_session
        h = get_token_object(session, ATTR_CLASS_SKEY, nil, alias_)
        if (!(h.attr_type).equal?(ATTR_CLASS_SKEY))
          if (!(Debug).nil?)
            Debug.println("destroySkey did not find secret key " + "with CKA_LABEL [" + alias_ + "]")
          end
          return false
        end
        @token.attr_p11._c_destroy_object(session.id, h.attr_handle)
        return true
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # return true if private key destroyed
    def destroy_pkey(cka_id)
      session = nil
      begin
        session = @token.get_op_session
        h = get_token_object(session, ATTR_CLASS_PKEY, cka_id, nil)
        if (!(h.attr_type).equal?(ATTR_CLASS_PKEY))
          if (!(Debug).nil?)
            Debug.println("destroyPkey did not find private key with CKA_ID [" + RJava.cast_to_string(get_id(cka_id)) + "]")
          end
          return false
        end
        @token.attr_p11._c_destroy_object(session.id, h.attr_handle)
        return true
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [String, X509Certificate] }
    # build [alias + issuer + serialNumber] string from a cert
    def get_id(alias_, cert)
      issuer = cert.get_issuer_x500principal
      serial_num = cert.get_serial_number
      return alias_ + ALIAS_SEP + RJava.cast_to_string(issuer.get_name(X500Principal::CANONICAL)) + ALIAS_SEP + RJava.cast_to_string(serial_num.to_s)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      # build CKA_ID string from bytes
      def get_id(bytes)
        printable = true
        i = 0
        while i < bytes.attr_length
          if (!DerValue.is_printable_string_char(RJava.cast_to_char(bytes[i])))
            printable = false
            break
          end
          i += 1
        end
        if (!printable)
          return "0x" + RJava.cast_to_string(Functions.to_hex_string(bytes))
        else
          begin
            return String.new(bytes, "UTF-8")
          rescue UnsupportedEncodingException => uee
            return "0x" + RJava.cast_to_string(Functions.to_hex_string(bytes))
          end
        end
      end
    }
    
    typesig { [Session, CK_ATTRIBUTE, Array.typed(::Java::Byte), String] }
    # find an object on the token
    # 
    # @param type either ATTR_CLASS_CERT, ATTR_CLASS_PKEY, or ATTR_CLASS_SKEY
    # @param cka_id the CKA_ID if type is ATTR_CLASS_CERT or ATTR_CLASS_PKEY
    # @param cka_label the CKA_LABEL if type is ATTR_CLASS_SKEY
    def get_token_object(session, type, cka_id, cka_label)
      attrs = nil
      if ((type).equal?(ATTR_CLASS_SKEY))
        attrs = Array.typed(CK_ATTRIBUTE).new([self.attr_attr_skey_token_true, CK_ATTRIBUTE.new(CKA_LABEL, cka_label), type])
      else
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, CK_ATTRIBUTE.new(CKA_ID, cka_id), type])
      end
      h = find_objects(session, attrs)
      if ((h.attr_length).equal?(0))
        if (!(Debug).nil?)
          if ((type).equal?(ATTR_CLASS_SKEY))
            Debug.println("getTokenObject did not find secret key " + "with CKA_LABEL [" + cka_label + "]")
          else
            if ((type).equal?(ATTR_CLASS_CERT))
              Debug.println("getTokenObject did not find cert with CKA_ID [" + RJava.cast_to_string(get_id(cka_id)) + "]")
            else
              Debug.println("getTokenObject did not find private key " + "with CKA_ID [" + RJava.cast_to_string(get_id(cka_id)) + "]")
            end
          end
        end
      else
        if ((h.attr_length).equal?(1))
          # found object handle - return it
          return THandle.new(h[0], type)
        else
          # found multiple object handles -
          # see if token ignored CKA_LABEL during search (e.g. NSS)
          if ((type).equal?(ATTR_CLASS_SKEY))
            list = ArrayList.new(h.attr_length)
            i = 0
            while i < h.attr_length
              label = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_LABEL)])
              @token.attr_p11._c_get_attribute_value(session.id, h[i], label)
              if (!(label[0].attr_p_value).nil? && (cka_label == String.new(label[0].get_char_array)))
                list.add(THandle.new(h[i], ATTR_CLASS_SKEY))
              end
              i += 1
            end
            if ((list.size).equal?(1))
              # yes, there was only one CKA_LABEL that matched
              return list.get(0)
            else
              raise KeyStoreException.new("invalid KeyStore state: " + "found " + RJava.cast_to_string(list.size) + " secret keys sharing CKA_LABEL [" + cka_label + "]")
            end
          else
            if ((type).equal?(ATTR_CLASS_CERT))
              raise KeyStoreException.new("invalid KeyStore state: " + "found " + RJava.cast_to_string(h.attr_length) + " certificates sharing CKA_ID " + RJava.cast_to_string(get_id(cka_id)))
            else
              raise KeyStoreException.new("invalid KeyStore state: " + "found " + RJava.cast_to_string(h.attr_length) + " private keys sharing CKA_ID " + RJava.cast_to_string(get_id(cka_id)))
            end
          end
        end
      end
      return THandle.new(NO_HANDLE, nil)
    end
    
    typesig { [] }
    # Create a mapping of all key pairs, trusted certs, and secret keys
    # on the token into logical KeyStore entries unambiguously
    # accessible via an alias.
    # 
    # If the token is removed, the map may contain stale values.
    # KeyStore.load should be called to re-create the map.
    # 
    # Assume all private keys and matching certs share a unique CKA_ID.
    # 
    # Assume all secret keys have a unique CKA_LABEL.
    # 
    # @return true if multiple certs found sharing the same CKA_LABEL
    # (if so, write capabilities are disabled)
    def map_labels
      trusted_attr = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_TRUSTED)])
      session = nil
      begin
        session = @token.get_op_session
        # get all private key CKA_IDs
        pkey_ids = ArrayList.new
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_PKEY, ])
        handles = find_objects(session, attrs)
        handles.each do |handle|
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_ID)])
          @token.attr_p11._c_get_attribute_value(session.id, handle, attrs)
          if (!(attrs[0].attr_p_value).nil?)
            pkey_ids.add(attrs[0].get_byte_array)
          end
        end
        # Get all certificates
        # 
        # If cert does not have a CKA_LABEL nor CKA_ID, it is ignored.
        # 
        # Get the CKA_LABEL for each cert
        # (if the cert does not have a CKA_LABEL, use the CKA_ID).
        # 
        # Map each cert to the its CKA_LABEL
        # (multiple certs may be mapped to a single CKA_LABEL)
        cert_map = HashMap.new
        attrs = Array.typed(CK_ATTRIBUTE).new([ATTR_TOKEN_TRUE, ATTR_CLASS_CERT, ])
        handles = find_objects(session, attrs)
        handles.each do |handle|
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_LABEL)])
          cka_label = nil
          cka_id = nil
          begin
            @token.attr_p11._c_get_attribute_value(session.id, handle, attrs)
            if (!(attrs[0].attr_p_value).nil?)
              # there is a CKA_LABEL
              cka_label = RJava.cast_to_string(String.new(attrs[0].get_char_array))
            end
          rescue PKCS11Exception => pe
            if (!(pe.get_error_code).equal?(CKR_ATTRIBUTE_TYPE_INVALID))
              raise pe
            end
            # GetAttributeValue for CKA_LABEL not supported
            # 
            # XXX SCA1000
          end
          # get CKA_ID
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_ID)])
          @token.attr_p11._c_get_attribute_value(session.id, handle, attrs)
          if ((attrs[0].attr_p_value).nil?)
            if ((cka_label).nil?)
              # no cka_label nor cka_id - ignore
              next
            end
          else
            if ((cka_label).nil?)
              # use CKA_ID as CKA_LABEL
              cka_label = RJava.cast_to_string(get_id(attrs[0].get_byte_array))
            end
            cka_id = attrs[0].get_byte_array
          end
          cert = load_cert(session, handle)
          # get CKA_TRUSTED
          cka_trusted = false
          if (@use_secmod_trust)
            cka_trusted = Secmod.get_instance.is_trusted(cert, @nss_trust_type)
          else
            if (self.attr_cka_trusted_supported)
              begin
                @token.attr_p11._c_get_attribute_value(session.id, handle, trusted_attr)
                cka_trusted = trusted_attr[0].get_boolean
              rescue PKCS11Exception => pe
                if ((pe.get_error_code).equal?(CKR_ATTRIBUTE_TYPE_INVALID))
                  # XXX  NSS, ibutton, sca1000
                  self.attr_cka_trusted_supported = false
                  if (!(Debug).nil?)
                    Debug.println("CKA_TRUSTED attribute not supported")
                  end
                end
              end
            end
          end
          info_set = cert_map.get(cka_label)
          if ((info_set).nil?)
            info_set = HashSet.new(2)
            cert_map.put(cka_label, info_set)
          end
          # initially create private key entry AliasInfo entries -
          # these entries will get resolved into their true
          # entry types later
          info_set.add(AliasInfo.new(cka_label, cka_id, cka_trusted, cert))
        end
        # create list secret key CKA_LABELS -
        # if there are duplicates (either between secret keys,
        # or between a secret key and another object),
        # throw an exception
        s_key_set = HashSet.new
        attrs = Array.typed(CK_ATTRIBUTE).new([self.attr_attr_skey_token_true, ATTR_CLASS_SKEY, ])
        handles = find_objects(session, attrs)
        handles.each do |handle|
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_LABEL)])
          @token.attr_p11._c_get_attribute_value(session.id, handle, attrs)
          if (!(attrs[0].attr_p_value).nil?)
            # there is a CKA_LABEL
            cka_label = String.new(attrs[0].get_char_array)
            if (!s_key_set.contains(cka_label))
              s_key_set.add(cka_label)
            else
              raise KeyStoreException.new("invalid KeyStore state: " + "found multiple secret keys sharing same " + "CKA_LABEL [" + cka_label + "]")
            end
          end
        end
        # update global aliasMap with alias mappings
        matched_certs = map_private_keys(pkey_ids, cert_map)
        shared_label = map_certs(matched_certs, cert_map)
        map_secret_keys(s_key_set)
        return shared_label
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [ArrayList, HashMap] }
    # for each private key CKA_ID, find corresponding cert with same CKA_ID.
    # if found cert, see if cert CKA_LABEL is unique.
    # if CKA_LABEL unique, map private key/cert alias to that CKA_LABEL.
    # if CKA_LABEL not unique, map private key/cert alias to:
    # CKA_LABEL + ALIAS_SEP + ISSUER + ALIAS_SEP + SERIAL
    # if cert not found, ignore private key
    # (don't support private key entries without a cert chain yet)
    # 
    # @return a list of AliasInfo entries that represents all matches
    def map_private_keys(pkey_ids, cert_map)
      # global alias map
      @alias_map = HashMap.new
      # list of matched certs that we will return
      matched_certs = ArrayList.new
      pkey_ids.each do |pkeyID|
        # try to find a matching CKA_ID in a certificate
        found_match = false
        cert_labels = cert_map.key_set
        cert_labels.each do |certLabel|
          # get cert CKA_IDs (if present) for each cert
          info_set = cert_map.get(cert_label)
          info_set.each do |aliasInfo|
            if ((Arrays == pkey_id))
              # found private key with matching cert
              if ((info_set.size).equal?(1))
                # unique CKA_LABEL - use certLabel as alias
                alias_info.attr_matched = true
                @alias_map.put(cert_label, alias_info)
              else
                # create new alias
                alias_info.attr_matched = true
                @alias_map.put(get_id(cert_label, alias_info.attr_cert), alias_info)
              end
              matched_certs.add(alias_info)
              found_match = true
              break
            end
          end
          if (found_match)
            break
          end
        end
        if (!found_match)
          if (!(Debug).nil?)
            Debug.println("did not find match for private key with CKA_ID [" + RJava.cast_to_string(get_id(pkey_id)) + "] (ignoring entry)")
          end
        end
      end
      return matched_certs
    end
    
    typesig { [ArrayList, HashMap] }
    # for each cert not matched with a private key but is CKA_TRUSTED:
    # if CKA_LABEL unique, map cert to CKA_LABEL.
    # if CKA_LABEL not unique, map cert to [label+issuer+serialNum]
    # 
    # if CKA_TRUSTED not supported, treat all certs not part of a chain
    # as trusted
    # 
    # @return true if multiple certs found sharing the same CKA_LABEL
    def map_certs(matched_certs, cert_map)
      # load all cert chains
      matched_certs.each do |aliasInfo|
        session = nil
        begin
          session = @token.get_op_session
          alias_info.attr_chain = load_chain(session, alias_info.attr_cert)
        ensure
          @token.release_session(session)
        end
      end
      # find all certs in certMap not part of a cert chain
      # - these are trusted
      shared_label = false
      cert_labels = cert_map.key_set
      cert_labels.each do |certLabel|
        info_set = cert_map.get(cert_label)
        info_set.each do |aliasInfo|
          if ((alias_info.attr_matched).equal?(true))
            # already found a private key match for this cert -
            # just continue
            alias_info.attr_trusted = false
            next
          end
          # cert in this aliasInfo is not matched yet
          # 
          # if CKA_TRUSTED_SUPPORTED == true,
          # then check if cert is trusted
          if (self.attr_cka_trusted_supported)
            if (alias_info.attr_trusted)
              # trusted certificate
              if ((map_trusted_cert(cert_label, alias_info, info_set)).equal?(true))
                shared_label = true
              end
            end
            next
          end
        end
      end
      return shared_label
    end
    
    typesig { [String, AliasInfo, HashSet] }
    def map_trusted_cert(cert_label, alias_info, info_set)
      shared_label = false
      alias_info.attr_type = ATTR_CLASS_CERT
      alias_info.attr_trusted = true
      if ((info_set.size).equal?(1))
        # unique CKA_LABEL - use certLabel as alias
        @alias_map.put(cert_label, alias_info)
      else
        # create new alias
        shared_label = true
        @alias_map.put(get_id(cert_label, alias_info.attr_cert), alias_info)
      end
      return shared_label
    end
    
    typesig { [HashSet] }
    # If the secret key shares a CKA_LABEL with another entry,
    # throw an exception
    def map_secret_keys(s_key_set)
      s_key_set.each do |label|
        if (!@alias_map.contains_key(label))
          @alias_map.put(label, AliasInfo.new(label))
        else
          raise KeyStoreException.new("invalid KeyStore state: " + "found secret key sharing CKA_LABEL [" + label + "] with another token object")
        end
      end
    end
    
    typesig { [] }
    def dump_token_map
      aliases = @alias_map.key_set
      System.out.println("Token Alias Map:")
      if ((aliases.size).equal?(0))
        System.out.println("  [empty]")
      else
        aliases.each do |s|
          System.out.println("  " + s + RJava.cast_to_string(@alias_map.get(s)))
        end
      end
    end
    
    typesig { [] }
    def check_write
      if (@write_disabled)
        raise KeyStoreException.new("This PKCS11KeyStore does not support write capabilities")
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:LONG0) { Array.typed(::Java::Long).new(0) { 0 } }
      const_attr_reader  :LONG0
      
      typesig { [Session, Array.typed(CK_ATTRIBUTE)] }
      def find_objects(session, attrs)
        token = session.attr_token
        handles = LONG0
        token.attr_p11._c_find_objects_init(session.id, attrs)
        while (true)
          h = token.attr_p11._c_find_objects(session.id, FINDOBJECTS_MAX)
          if ((h.attr_length).equal?(0))
            break
          end
          handles = P11Util.concat(handles, h)
        end
        token.attr_p11._c_find_objects_final(session.id)
        return handles
      end
    }
    
    private
    alias_method :initialize__p11key_store, :initialize
  end
  
end
