require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KeyStoreImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :KeyStoreSpi
      include_const ::Java::Security, :KeyStoreException
      include_const ::Java::Security, :UnrecoverableKeyException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :SecurityPermission
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateEncodingException
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Interfaces, :RSAPrivateCrtKey
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :UUID
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # Implementation of key store for Windows using the Microsoft Crypto API.
  # 
  # @since 1.6
  class KeyStore < KeyStoreImports.const_get :KeyStoreSpi
    include_class_members KeyStoreImports
    
    class_module.module_eval {
      const_set_lazy(:MY) { Class.new(KeyStore) do
        include_class_members KeyStore
        
        typesig { [] }
        def initialize
          super("MY")
        end
        
        private
        alias_method :initialize__my, :initialize
      end }
      
      const_set_lazy(:ROOT) { Class.new(KeyStore) do
        include_class_members KeyStore
        
        typesig { [] }
        def initialize
          super("ROOT")
        end
        
        private
        alias_method :initialize__root, :initialize
      end }
      
      const_set_lazy(:KeyEntry) { Class.new do
        extend LocalClass
        include_class_members KeyStore
        
        attr_accessor :private_key
        alias_method :attr_private_key, :private_key
        undef_method :private_key
        alias_method :attr_private_key=, :private_key=
        undef_method :private_key=
        
        attr_accessor :cert_chain
        alias_method :attr_cert_chain, :cert_chain
        undef_method :cert_chain
        alias_method :attr_cert_chain=, :cert_chain=
        undef_method :cert_chain=
        
        attr_accessor :alias
        alias_method :attr_alias, :alias
        undef_method :alias
        alias_method :attr_alias=, :alias=
        undef_method :alias=
        
        typesig { [self::Key, Array.typed(self::X509Certificate)] }
        def initialize(key, chain)
          initialize__key_entry(nil, key, chain)
        end
        
        typesig { [String, self::Key, Array.typed(self::X509Certificate)] }
        def initialize(alias_, key, chain)
          @private_key = nil
          @cert_chain = nil
          @alias = nil
          @private_key = key
          @cert_chain = chain
          # The default alias for both entry types is derived from a
          # hash value intrinsic to the first certificate in the chain.
          if ((alias_).nil?)
            @alias = JavaInteger.to_s(chain[0].hash_code)
          else
            @alias = alias_
          end
        end
        
        typesig { [] }
        # Gets the alias for the keystore entry.
        def get_alias
          return @alias
        end
        
        typesig { [String] }
        # Sets the alias for the keystore entry.
        def set_alias(alias_)
          # TODO - set friendly name prop in cert store
          @alias = alias_
        end
        
        typesig { [] }
        # Gets the private key for the keystore entry.
        def get_private_key
          return @private_key
        end
        
        typesig { [self::RSAPrivateCrtKey] }
        # Sets the private key for the keystore entry.
        def set_private_key(key)
          modulus_bytes = key.get_modulus.to_byte_array
          # Adjust key length due to sign bit
          key_bit_length = ((modulus_bytes[0]).equal?(0)) ? (modulus_bytes.attr_length - 1) * 8 : modulus_bytes.attr_length * 8
          key_blob = generate_private_key_blob(key_bit_length, modulus_bytes, key.get_public_exponent.to_byte_array, key.get_private_exponent.to_byte_array, key.get_prime_p.to_byte_array, key.get_prime_q.to_byte_array, key.get_prime_exponent_p.to_byte_array, key.get_prime_exponent_q.to_byte_array, key.get_crt_coefficient.to_byte_array)
          @private_key = store_private_key(key_blob, "{" + RJava.cast_to_string(UUID.random_uuid.to_s) + "}", key_bit_length)
        end
        
        typesig { [] }
        # Gets the certificate chain for the keystore entry.
        def get_certificate_chain
          return @cert_chain
        end
        
        typesig { [Array.typed(self::X509Certificate)] }
        # Sets the certificate chain for the keystore entry.
        def set_certificate_chain(chain)
          i = 0
          while i < chain.attr_length
            encoding = chain[i].get_encoded
            if ((i).equal?(0) && !(@private_key).nil?)
              store_certificate(get_name, @alias, encoding, encoding.attr_length, @private_key.get_hcrypt_provider, @private_key.get_hcrypt_key)
            else
              store_certificate(get_name, @alias, encoding, encoding.attr_length, 0, 0) # no private key to attach
            end
            i += 1
          end
          @cert_chain = chain
        end
        
        private
        alias_method :initialize__key_entry, :initialize
      end }
    }
    
    # An X.509 certificate factory.
    # Used to create an X.509 certificate from its DER-encoding.
    attr_accessor :certificate_factory
    alias_method :attr_certificate_factory, :certificate_factory
    undef_method :certificate_factory
    alias_method :attr_certificate_factory=, :certificate_factory=
    undef_method :certificate_factory=
    
    class_module.module_eval {
      # Compatibility mode: for applications that assume keystores are
      # stream-based this mode tolerates (but ignores) a non-null stream
      # or password parameter when passed to the load or store methods.
      # The mode is enabled by default.
      const_set_lazy(:KEYSTORE_COMPATIBILITY_MODE_PROP) { "sun.security.mscapi.keyStoreCompatibilityMode" }
      const_attr_reader  :KEYSTORE_COMPATIBILITY_MODE_PROP
    }
    
    attr_accessor :key_store_compatibility_mode
    alias_method :attr_key_store_compatibility_mode, :key_store_compatibility_mode
    undef_method :key_store_compatibility_mode
    alias_method :attr_key_store_compatibility_mode=, :key_store_compatibility_mode=
    undef_method :key_store_compatibility_mode=
    
    # The keystore entries.
    attr_accessor :entries
    alias_method :attr_entries, :entries
    undef_method :entries
    alias_method :attr_entries=, :entries=
    undef_method :entries=
    
    # The keystore name.
    # Case is not significant.
    attr_accessor :store_name
    alias_method :attr_store_name, :store_name
    undef_method :store_name
    alias_method :attr_store_name=, :store_name=
    undef_method :store_name=
    
    typesig { [String] }
    def initialize(store_name)
      @certificate_factory = nil
      @key_store_compatibility_mode = false
      @entries = nil
      @store_name = nil
      super()
      @certificate_factory = nil
      @entries = ArrayList.new
      # Get the compatibility mode
      prop = AccessController.do_privileged(GetPropertyAction.new(KEYSTORE_COMPATIBILITY_MODE_PROP))
      if ("false".equals_ignore_case(prop))
        @key_store_compatibility_mode = false
      else
        @key_store_compatibility_mode = true
      end
      @store_name = store_name
    end
    
    typesig { [String, Array.typed(::Java::Char)] }
    # Returns the key associated with the given alias.
    # <p>
    # A compatibility mode is supported for applications that assume
    # a password must be supplied. It permits (but ignores) a non-null
    # <code>password</code>.  The mode is enabled by default.
    # Set the
    # <code>sun.security.mscapi.keyStoreCompatibilityMode</code>
    # system property to <code>false</code> to disable compatibility mode
    # and reject a non-null <code>password</code>.
    # 
    # @param alias the alias name
    # @param password the password, which should be <code>null</code>
    # 
    # @return the requested key, or null if the given alias does not exist
    # or does not identify a <i>key entry</i>.
    # 
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # key cannot be found,
    # or if compatibility mode is disabled and <code>password</code> is
    # non-null.
    # @exception UnrecoverableKeyException if the key cannot be recovered.
    def engine_get_key(alias_, password)
      if ((alias_).nil?)
        return nil
      end
      if (!(password).nil? && !@key_store_compatibility_mode)
        raise UnrecoverableKeyException.new("Password must be null")
      end
      if ((engine_is_key_entry(alias_)).equal?(false))
        return nil
      end
      @entries.each do |entry|
        if ((alias_ == entry.get_alias))
          return entry.get_private_key
        end
      end
      return nil
    end
    
    typesig { [String] }
    # Returns the certificate chain associated with the given alias.
    # 
    # @param alias the alias name
    # 
    # @return the certificate chain (ordered with the user's certificate first
    # and the root certificate authority last), or null if the given alias
    # does not exist or does not contain a certificate chain (i.e., the given
    # alias identifies either a <i>trusted certificate entry</i> or a
    # <i>key entry</i> without a certificate chain).
    def engine_get_certificate_chain(alias_)
      if ((alias_).nil?)
        return nil
      end
      @entries.each do |entry|
        if ((alias_ == entry.get_alias))
          cert_chain = entry.get_certificate_chain
          return cert_chain.clone
        end
      end
      return nil
    end
    
    typesig { [String] }
    # Returns the certificate associated with the given alias.
    # 
    # <p>If the given alias name identifies a
    # <i>trusted certificate entry</i>, the certificate associated with that
    # entry is returned. If the given alias name identifies a
    # <i>key entry</i>, the first element of the certificate chain of that
    # entry is returned, or null if that entry does not have a certificate
    # chain.
    # 
    # @param alias the alias name
    # 
    # @return the certificate, or null if the given alias does not exist or
    # does not contain a certificate.
    def engine_get_certificate(alias_)
      if ((alias_).nil?)
        return nil
      end
      @entries.each do |entry|
        if ((alias_ == entry.get_alias))
          cert_chain = entry.get_certificate_chain
          return cert_chain[0]
        end
      end
      return nil
    end
    
    typesig { [String] }
    # Returns the creation date of the entry identified by the given alias.
    # 
    # @param alias the alias name
    # 
    # @return the creation date of this entry, or null if the given alias does
    # not exist
    def engine_get_creation_date(alias_)
      if ((alias_).nil?)
        return nil
      end
      return Date.new
    end
    
    typesig { [String, Java::Security::Key, Array.typed(::Java::Char), Array.typed(Certificate)] }
    # Stores the given private key and associated certificate chain in the
    # keystore.
    # 
    # <p>The given java.security.PrivateKey <code>key</code> must
    # be accompanied by a certificate chain certifying the
    # corresponding public key.
    # 
    # <p>If the given alias already exists, the keystore information
    # associated with it is overridden by the given key and certificate
    # chain. Otherwise, a new entry is created.
    # 
    # <p>
    # A compatibility mode is supported for applications that assume
    # a password must be supplied. It permits (but ignores) a non-null
    # <code>password</code>.  The mode is enabled by default.
    # Set the
    # <code>sun.security.mscapi.keyStoreCompatibilityMode</code>
    # system property to <code>false</code> to disable compatibility mode
    # and reject a non-null <code>password</code>.
    # 
    # @param alias the alias name
    # @param key the private key to be associated with the alias
    # @param password the password, which should be <code>null</code>
    # @param chain the certificate chain for the corresponding public
    # key (only required if the given key is of type
    # <code>java.security.PrivateKey</code>).
    # 
    # @exception KeyStoreException if the given key is not a private key,
    # cannot be protected, or if compatibility mode is disabled and
    # <code>password</code> is non-null, or if this operation fails for
    # some other reason.
    def engine_set_key_entry(alias_, key, password, chain)
      if ((alias_).nil?)
        raise KeyStoreException.new("alias must not be null")
      end
      if (!(password).nil? && !@key_store_compatibility_mode)
        raise KeyStoreException.new("Password must be null")
      end
      if (key.is_a?(RSAPrivateCrtKey))
        entry = nil
        found = false
        @entries.each do |e|
          if ((alias_ == e.get_alias))
            found = true
            entry = e
            break
          end
        end
        if (!found)
          # TODO new KeyEntry(alias, key, (X509Certificate[]) chain);
          entry = KeyEntry.new_local(self, alias_, nil, chain)
          @entries.add(entry)
        end
        entry.set_alias(alias_)
        entry.set_private_key(key)
        begin
          entry.set_certificate_chain(chain)
        rescue CertificateException => ce
          raise KeyStoreException.new(ce)
        end
      else
        raise UnsupportedOperationException.new("Cannot assign the key to the given alias.")
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte), Array.typed(Certificate)] }
    # Assigns the given key (that has already been protected) to the given
    # alias.
    # 
    # <p>If the protected key is of type
    # <code>java.security.PrivateKey</code>, it must be accompanied by a
    # certificate chain certifying the corresponding public key. If the
    # underlying keystore implementation is of type <code>jks</code>,
    # <code>key</code> must be encoded as an
    # <code>EncryptedPrivateKeyInfo</code> as defined in the PKCS #8 standard.
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
      raise UnsupportedOperationException.new("Cannot assign the encoded key to the given alias.")
    end
    
    typesig { [String, Certificate] }
    # Assigns the given certificate to the given alias.
    # 
    # <p>If the given alias already exists in this keystore and identifies a
    # <i>trusted certificate entry</i>, the certificate associated with it is
    # overridden by the given certificate.
    # 
    # @param alias the alias name
    # @param cert the certificate
    # 
    # @exception KeyStoreException if the given alias already exists and does
    # not identify a <i>trusted certificate entry</i>, or this operation
    # fails for some other reason.
    def engine_set_certificate_entry(alias_, cert)
      if ((alias_).nil?)
        raise KeyStoreException.new("alias must not be null")
      end
      if (cert.is_a?(X509Certificate))
        # TODO - build CryptoAPI chain?
        chain = Array.typed(X509Certificate).new([cert])
        entry = nil
        found = false
        @entries.each do |e|
          if ((alias_ == e.get_alias))
            found = true
            entry = e
            break
          end
        end
        if (!found)
          entry = KeyEntry.new_local(self, alias_, nil, chain)
          @entries.add(entry)
        end
        if ((entry.get_private_key).nil?)
          # trusted-cert entry
          entry.set_alias(alias_)
          begin
            entry.set_certificate_chain(chain)
          rescue CertificateException => ce
            raise KeyStoreException.new(ce)
          end
        end
      else
        raise UnsupportedOperationException.new("Cannot assign the certificate to the given alias.")
      end
    end
    
    typesig { [String] }
    # Deletes the entry identified by the given alias from this keystore.
    # 
    # @param alias the alias name
    # 
    # @exception KeyStoreException if the entry cannot be removed.
    def engine_delete_entry(alias_)
      if ((alias_).nil?)
        raise KeyStoreException.new("alias must not be null")
      end
      @entries.each do |entry|
        if ((alias_ == entry.get_alias))
          # Get end-entity certificate and remove from system cert store
          cert_chain = entry.get_certificate_chain
          if (!(cert_chain).nil?)
            begin
              encoding = cert_chain[0].get_encoded
              remove_certificate(get_name, alias_, encoding, encoding.attr_length)
            rescue CertificateEncodingException => e
              raise KeyStoreException.new("Cannot remove entry: " + RJava.cast_to_string(e))
            end
          end
          private_key = entry.get_private_key
          if (!(private_key).nil?)
            destroy_key_container(Key.get_container_name(private_key.get_hcrypt_provider))
          end
          @entries.remove(entry)
          break
        end
      end
    end
    
    typesig { [] }
    # Lists all the alias names of this keystore.
    # 
    # @return enumeration of the alias names
    def engine_aliases
      iter = @entries.iterator
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members KeyStore
        include Enumeration if Enumeration.class == Module
        
        typesig { [] }
        define_method :has_more_elements do
          return iter.has_next
        end
        
        typesig { [] }
        define_method :next_element do
          entry = iter.next_
          return entry.get_alias
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [String] }
    # Checks if the given alias exists in this keystore.
    # 
    # @param alias the alias name
    # 
    # @return true if the alias exists, false otherwise
    def engine_contains_alias(alias_)
      enumerator = engine_aliases
      while enumerator.has_more_elements
        a = enumerator.next_element
        if ((a == alias_))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # Retrieves the number of entries in this keystore.
    # 
    # @return the number of entries in this keystore
    def engine_size
      return @entries.size
    end
    
    typesig { [String] }
    # Returns true if the entry identified by the given alias is a
    # <i>key entry</i>, and false otherwise.
    # 
    # @return true if the entry identified by the given alias is a
    # <i>key entry</i>, false otherwise.
    def engine_is_key_entry(alias_)
      if ((alias_).nil?)
        return false
      end
      @entries.each do |entry|
        if ((alias_ == entry.get_alias))
          return !(entry.get_private_key).nil?
        end
      end
      return false
    end
    
    typesig { [String] }
    # Returns true if the entry identified by the given alias is a
    # <i>trusted certificate entry</i>, and false otherwise.
    # 
    # @return true if the entry identified by the given alias is a
    # <i>trusted certificate entry</i>, false otherwise.
    def engine_is_certificate_entry(alias_)
      @entries.each do |entry|
        if ((alias_ == entry.get_alias))
          return (entry.get_private_key).nil?
        end
      end
      return false
    end
    
    typesig { [Certificate] }
    # Returns the (alias) name of the first keystore entry whose certificate
    # matches the given certificate.
    # 
    # <p>This method attempts to match the given certificate with each
    # keystore entry. If the entry being considered
    # is a <i>trusted certificate entry</i>, the given certificate is
    # compared to that entry's certificate. If the entry being considered is
    # a <i>key entry</i>, the given certificate is compared to the first
    # element of that entry's certificate chain (if a chain exists).
    # 
    # @param cert the certificate to match with.
    # 
    # @return the (alias) name of the first entry with matching certificate,
    # or null if no such entry exists in this keystore.
    def engine_get_certificate_alias(cert)
      @entries.each do |entry|
        if (!(entry.attr_cert_chain).nil? && (entry.attr_cert_chain[0] == cert))
          return entry.get_alias
        end
      end
      return nil
    end
    
    typesig { [OutputStream, Array.typed(::Java::Char)] }
    # engineStore is currently a no-op.
    # Entries are stored during engineSetEntry.
    # 
    # A compatibility mode is supported for applications that assume
    # keystores are stream-based. It permits (but ignores) a non-null
    # <code>stream</code> or <code>password</code>.
    # The mode is enabled by default.
    # Set the
    # <code>sun.security.mscapi.keyStoreCompatibilityMode</code>
    # system property to <code>false</code> to disable compatibility mode
    # and reject a non-null <code>stream</code> or <code>password</code>.
    # 
    # @param stream the output stream, which should be <code>null</code>
    # @param password the password, which should be <code>null</code>
    # 
    # @exception IOException if compatibility mode is disabled and either
    # parameter is non-null.
    def engine_store(stream, password)
      if (!(stream).nil? && !@key_store_compatibility_mode)
        raise IOException.new("Keystore output stream must be null")
      end
      if (!(password).nil? && !@key_store_compatibility_mode)
        raise IOException.new("Keystore password must be null")
      end
    end
    
    typesig { [InputStream, Array.typed(::Java::Char)] }
    # Loads the keystore.
    # 
    # A compatibility mode is supported for applications that assume
    # keystores are stream-based. It permits (but ignores) a non-null
    # <code>stream</code> or <code>password</code>.
    # The mode is enabled by default.
    # Set the
    # <code>sun.security.mscapi.keyStoreCompatibilityMode</code>
    # system property to <code>false</code> to disable compatibility mode
    # and reject a non-null <code>stream</code> or <code>password</code>.
    # 
    # @param stream the input stream, which should be <code>null</code>.
    # @param password the password, which should be <code>null</code>.
    # 
    # @exception IOException if there is an I/O or format problem with the
    # keystore data. Or if compatibility mode is disabled and either
    # parameter is non-null.
    # @exception NoSuchAlgorithmException if the algorithm used to check
    # the integrity of the keystore cannot be found
    # @exception CertificateException if any of the certificates in the
    # keystore could not be loaded
    # @exception SecurityException if the security check for
    # <code>SecurityPermission("authProvider.<i>name</i>")</code> does not
    # pass, where <i>name</i> is the value returned by
    # this provider's <code>getName</code> method.
    def engine_load(stream, password)
      if (!(stream).nil? && !@key_store_compatibility_mode)
        raise IOException.new("Keystore input stream must be null")
      end
      if (!(password).nil? && !@key_store_compatibility_mode)
        raise IOException.new("Keystore password must be null")
      end
      # Use the same security check as AuthProvider.login
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SecurityPermission.new("authProvider.SunMSCAPI"))
      end
      # Clear all key entries
      @entries.clear
      # Load keys and/or certificate chains
      load_keys_or_certificate_chains(get_name, @entries)
    end
    
    typesig { [String, Collection, Collection] }
    # Generates a certificate chain from the collection of
    # certificates and stores the result into a key entry.
    def generate_certificate_chain(alias_, cert_collection, entries)
      begin
        cert_chain = Array.typed(X509Certificate).new(cert_collection.size) { nil }
        i = 0
        iter = cert_collection.iterator
        while iter.has_next
          cert_chain[i] = iter.next_
          i += 1
        end
        entry = KeyEntry.new_local(self, alias_, nil, cert_chain)
        # Add cert chain
        entries.add(entry)
      rescue JavaThrowable => e
        # Ignore the exception and skip this entry
        # TODO - throw CertificateException?
      end
    end
    
    typesig { [String, ::Java::Long, ::Java::Long, ::Java::Int, Collection, Collection] }
    # Generates RSA key and certificate chain from the private key handle,
    # collection of certificates and stores the result into key entries.
    def generate_rsakey_and_certificate_chain(alias_, h_crypt_prov, h_crypt_key, key_length, cert_collection, entries)
      begin
        cert_chain = Array.typed(X509Certificate).new(cert_collection.size) { nil }
        i = 0
        iter = cert_collection.iterator
        while iter.has_next
          cert_chain[i] = iter.next_
          i += 1
        end
        entry = KeyEntry.new_local(self, alias_, RSAPrivateKey.new(h_crypt_prov, h_crypt_key, key_length), cert_chain)
        # Add cert chain
        entries.add(entry)
      rescue JavaThrowable => e
        # Ignore the exception and skip this entry
        # TODO - throw CertificateException?
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Collection] }
    # Generates certificates from byte data and stores into cert collection.
    # 
    # @param data Byte data.
    # @param certCollection Collection of certificates.
    def generate_certificate(data, cert_collection)
      begin
        bis = ByteArrayInputStream.new(data)
        # Obtain certificate factory
        if ((@certificate_factory).nil?)
          @certificate_factory = CertificateFactory.get_instance("X.509")
        end
        # Generate certificate
        c = @certificate_factory.generate_certificates(bis)
        cert_collection.add_all(c)
      rescue CertificateException => e
        # Ignore the exception and skip this certificate
        # TODO - throw CertificateException?
      rescue JavaThrowable => te
        # Ignore the exception and skip this certificate
        # TODO - throw CertificateException?
      end
    end
    
    typesig { [] }
    # Returns the name of the keystore.
    def get_name
      return @store_name
    end
    
    JNI.native_method :Java_sun_security_mscapi_KeyStore_loadKeysOrCertificateChains, [:pointer, :long, :long, :long], :void
    typesig { [String, Collection] }
    # Load keys and/or certificates from keystore into Collection.
    # 
    # @param name Name of keystore.
    # @param entries Collection of key/certificate.
    def load_keys_or_certificate_chains(name, entries)
      JNI.__send__(:Java_sun_security_mscapi_KeyStore_loadKeysOrCertificateChains, JNI.env, self.jni_id, name.jni_id, entries.jni_id)
    end
    
    JNI.native_method :Java_sun_security_mscapi_KeyStore_storeCertificate, [:pointer, :long, :long, :long, :long, :int32, :int64, :int64], :void
    typesig { [String, String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Long, ::Java::Long] }
    # Stores a DER-encoded certificate into the certificate store
    # 
    # @param name Name of the keystore.
    # @param alias Name of the certificate.
    # @param encoding DER-encoded certificate.
    def store_certificate(name, alias_, encoding, encoding_length, h_crypt_provider, h_crypt_key)
      JNI.__send__(:Java_sun_security_mscapi_KeyStore_storeCertificate, JNI.env, self.jni_id, name.jni_id, alias_.jni_id, encoding.jni_id, encoding_length.to_int, h_crypt_provider.to_int, h_crypt_key.to_int)
    end
    
    JNI.native_method :Java_sun_security_mscapi_KeyStore_removeCertificate, [:pointer, :long, :long, :long, :long, :int32], :void
    typesig { [String, String, Array.typed(::Java::Byte), ::Java::Int] }
    # Removes the certificate from the certificate store
    # 
    # @param name Name of the keystore.
    # @param alias Name of the certificate.
    # @param encoding DER-encoded certificate.
    def remove_certificate(name, alias_, encoding, encoding_length)
      JNI.__send__(:Java_sun_security_mscapi_KeyStore_removeCertificate, JNI.env, self.jni_id, name.jni_id, alias_.jni_id, encoding.jni_id, encoding_length.to_int)
    end
    
    JNI.native_method :Java_sun_security_mscapi_KeyStore_destroyKeyContainer, [:pointer, :long, :long], :void
    typesig { [String] }
    # Destroys the key container.
    # 
    # @param keyContainerName The name of the key container.
    def destroy_key_container(key_container_name)
      JNI.__send__(:Java_sun_security_mscapi_KeyStore_destroyKeyContainer, JNI.env, self.jni_id, key_container_name.jni_id)
    end
    
    JNI.native_method :Java_sun_security_mscapi_KeyStore_generatePrivateKeyBlob, [:pointer, :long, :int32, :long, :long, :long, :long, :long, :long, :long, :long], :long
    typesig { [::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Generates a private-key BLOB from a key's components.
    def generate_private_key_blob(key_bit_length, modulus, public_exponent, private_exponent, prime_p, prime_q, exponent_p, exponent_q, crt_coefficient)
      JNI.__send__(:Java_sun_security_mscapi_KeyStore_generatePrivateKeyBlob, JNI.env, self.jni_id, key_bit_length.to_int, modulus.jni_id, public_exponent.jni_id, private_exponent.jni_id, prime_p.jni_id, prime_q.jni_id, exponent_p.jni_id, exponent_q.jni_id, crt_coefficient.jni_id)
    end
    
    JNI.native_method :Java_sun_security_mscapi_KeyStore_storePrivateKey, [:pointer, :long, :long, :long, :int32], :long
    typesig { [Array.typed(::Java::Byte), String, ::Java::Int] }
    def store_private_key(key_blob, key_container_name, key_size)
      JNI.__send__(:Java_sun_security_mscapi_KeyStore_storePrivateKey, JNI.env, self.jni_id, key_blob.jni_id, key_container_name.jni_id, key_size.to_int)
    end
    
    private
    alias_method :initialize__key_store, :initialize
  end
  
end
