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
module Java::Security
  module KeyStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include ::Java::Util
      include_const ::Javax::Crypto, :SecretKey
      include ::Javax::Security::Auth::Callback
    }
  end
  
  # This class represents a storage facility for cryptographic
  # keys and certificates.
  # 
  # <p> A <code>KeyStore</code> manages different types of entries.
  # Each type of entry implements the <code>KeyStore.Entry</code> interface.
  # Three basic <code>KeyStore.Entry</code> implementations are provided:
  # 
  # <ul>
  # <li><b>KeyStore.PrivateKeyEntry</b>
  # <p> This type of entry holds a cryptographic <code>PrivateKey</code>,
  # which is optionally stored in a protected format to prevent
  # unauthorized access.  It is also accompanied by a certificate chain
  # for the corresponding public key.
  # 
  # <p> Private keys and certificate chains are used by a given entity for
  # self-authentication. Applications for this authentication include software
  # distribution organizations which sign JAR files as part of releasing
  # and/or licensing software.
  # 
  # <li><b>KeyStore.SecretKeyEntry</b>
  # <p> This type of entry holds a cryptographic <code>SecretKey</code>,
  # which is optionally stored in a protected format to prevent
  # unauthorized access.
  # 
  # <li><b>KeyStore.TrustedCertificateEntry</b>
  # <p> This type of entry contains a single public key <code>Certificate</code>
  # belonging to another party. It is called a <i>trusted certificate</i>
  # because the keystore owner trusts that the public key in the certificate
  # indeed belongs to the identity identified by the <i>subject</i> (owner)
  # of the certificate.
  # 
  # <p>This type of entry can be used to authenticate other parties.
  # </ul>
  # 
  # <p> Each entry in a keystore is identified by an "alias" string. In the
  # case of private keys and their associated certificate chains, these strings
  # distinguish among the different ways in which the entity may authenticate
  # itself. For example, the entity may authenticate itself using different
  # certificate authorities, or using different public key algorithms.
  # 
  # <p> Whether aliases are case sensitive is implementation dependent. In order
  # to avoid problems, it is recommended not to use aliases in a KeyStore that
  # only differ in case.
  # 
  # <p> Whether keystores are persistent, and the mechanisms used by the
  # keystore if it is persistent, are not specified here. This allows
  # use of a variety of techniques for protecting sensitive (e.g., private or
  # secret) keys. Smart cards or other integrated cryptographic engines
  # (SafeKeyper) are one option, and simpler mechanisms such as files may also
  # be used (in a variety of formats).
  # 
  # <p> Typical ways to request a KeyStore object include
  # relying on the default type and providing a specific keystore type.
  # 
  # <ul>
  # <li>To rely on the default type:
  # <pre>
  # KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
  # </pre>
  # The system will return a keystore implementation for the default type.
  # <p>
  # 
  # <li>To provide a specific keystore type:
  # <pre>
  # KeyStore ks = KeyStore.getInstance("JKS");
  # </pre>
  # The system will return the most preferred implementation of the
  # specified keystore type available in the environment. <p>
  # </ul>
  # 
  # <p> Before a keystore can be accessed, it must be
  # {@link #load(java.io.InputStream, char[]) loaded}.
  # <pre>
  # KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
  # 
  # // get user password and file input stream
  # char[] password = getPassword();
  # 
  # java.io.FileInputStream fis = null;
  # try {
  # fis = new java.io.FileInputStream("keyStoreName");
  # ks.load(fis, password);
  # } finally {
  # if (fis != null) {
  # fis.close();
  # }
  # }
  # </pre>
  # 
  # To create an empty keystore using the above <code>load</code> method,
  # pass <code>null</code> as the <code>InputStream</code> argument.
  # 
  # <p> Once the keystore has been loaded, it is possible
  # to read existing entries from the keystore, or to write new entries
  # into the keystore:
  # <pre>
  # // get my private key
  # KeyStore.PrivateKeyEntry pkEntry = (KeyStore.PrivateKeyEntry)
  # ks.getEntry("privateKeyAlias", password);
  # PrivateKey myPrivateKey = pkEntry.getPrivateKey();
  # 
  # // save my secret key
  # javax.crypto.SecretKey mySecretKey;
  # KeyStore.SecretKeyEntry skEntry =
  # new KeyStore.SecretKeyEntry(mySecretKey);
  # ks.setEntry("secretKeyAlias", skEntry,
  # new KeyStore.PasswordProtection(password));
  # 
  # // store away the keystore
  # java.io.FileOutputStream fos = null;
  # try {
  # fos = new java.io.FileOutputStream("newKeyStoreName");
  # ks.store(fos, password);
  # } finally {
  # if (fos != null) {
  # fos.close();
  # }
  # }
  # </pre>
  # 
  # Note that although the same password may be used to
  # load the keystore, to protect the private key entry,
  # to protect the secret key entry, and to store the keystore
  # (as is shown in the sample code above),
  # different passwords or other protection parameters
  # may also be used.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.PrivateKey
  # @see javax.crypto.SecretKey
  # @see java.security.cert.Certificate
  # 
  # @since 1.2
  class KeyStore 
    include_class_members KeyStoreImports
    
    class_module.module_eval {
      # Constant to lookup in the Security properties file to determine
      # the default keystore type.
      # In the Security properties file, the default keystore type is given as:
      # <pre>
      # keystore.type=jks
      # </pre>
      const_set_lazy(:KEYSTORE_TYPE) { "keystore.type" }
      const_attr_reader  :KEYSTORE_TYPE
    }
    
    # The keystore type
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # The provider
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    # The provider implementation
    attr_accessor :key_store_spi
    alias_method :attr_key_store_spi, :key_store_spi
    undef_method :key_store_spi
    alias_method :attr_key_store_spi=, :key_store_spi=
    undef_method :key_store_spi=
    
    # Has this keystore been initialized (loaded)?
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    class_module.module_eval {
      # A marker interface for <code>KeyStore</code>
      # {@link #load(KeyStore.LoadStoreParameter) load}
      # and
      # {@link #store(KeyStore.LoadStoreParameter) store}
      # parameters.
      # 
      # @since 1.5
      const_set_lazy(:LoadStoreParameter) { Module.new do
        include_class_members KeyStore
        
        typesig { [] }
        # Gets the parameter used to protect keystore data.
        # 
        # @return the parameter used to protect keystore data, or null
        def get_protection_parameter
          raise NotImplementedError
        end
      end }
      
      # A marker interface for keystore protection parameters.
      # 
      # <p> The information stored in a <code>ProtectionParameter</code>
      # object protects the contents of a keystore.
      # For example, protection parameters may be used to check
      # the integrity of keystore data, or to protect the
      # confidentiality of sensitive keystore data
      # (such as a <code>PrivateKey</code>).
      # 
      # @since 1.5
      const_set_lazy(:ProtectionParameter) { Module.new do
        include_class_members KeyStore
      end }
      
      # A password-based implementation of <code>ProtectionParameter</code>.
      # 
      # @since 1.5
      const_set_lazy(:PasswordProtection) { Class.new do
        include_class_members KeyStore
        include ProtectionParameter
        include Javax::Security::Auth::Destroyable
        
        attr_accessor :password
        alias_method :attr_password, :password
        undef_method :password
        alias_method :attr_password=, :password=
        undef_method :password=
        
        attr_accessor :destroyed
        alias_method :attr_destroyed, :destroyed
        undef_method :destroyed
        alias_method :attr_destroyed=, :destroyed=
        undef_method :destroyed=
        
        typesig { [Array.typed(::Java::Char)] }
        # Creates a password parameter.
        # 
        # <p> The specified <code>password</code> is cloned before it is stored
        # in the new <code>PasswordProtection</code> object.
        # 
        # @param password the password, which may be <code>null</code>
        def initialize(password)
          @password = nil
          @destroyed = false
          @password = ((password).nil?) ? nil : password.clone
        end
        
        typesig { [] }
        # Gets the password.
        # 
        # <p>Note that this method returns a reference to the password.
        # If a clone of the array is created it is the caller's
        # responsibility to zero out the password information
        # after it is no longer needed.
        # 
        # @see #destroy()
        # @return the password, which may be <code>null</code>
        # @exception IllegalStateException if the password has
        # been cleared (destroyed)
        def get_password
          synchronized(self) do
            if (@destroyed)
              raise self.class::IllegalStateException.new("password has been cleared")
            end
            return @password
          end
        end
        
        typesig { [] }
        # Clears the password.
        # 
        # @exception DestroyFailedException if this method was unable
        # to clear the password
        def destroy
          synchronized(self) do
            @destroyed = true
            if (!(@password).nil?)
              Arrays.fill(@password, Character.new(?\s.ord))
            end
          end
        end
        
        typesig { [] }
        # Determines if password has been cleared.
        # 
        # @return true if the password has been cleared, false otherwise
        def is_destroyed
          synchronized(self) do
            return @destroyed
          end
        end
        
        private
        alias_method :initialize__password_protection, :initialize
      end }
      
      # A ProtectionParameter encapsulating a CallbackHandler.
      # 
      # @since 1.5
      const_set_lazy(:CallbackHandlerProtection) { Class.new do
        include_class_members KeyStore
        include ProtectionParameter
        
        attr_accessor :handler
        alias_method :attr_handler, :handler
        undef_method :handler
        alias_method :attr_handler=, :handler=
        undef_method :handler=
        
        typesig { [class_self::CallbackHandler] }
        # Constructs a new CallbackHandlerProtection from a
        # CallbackHandler.
        # 
        # @param handler the CallbackHandler
        # @exception NullPointerException if handler is null
        def initialize(handler)
          @handler = nil
          if ((handler).nil?)
            raise self.class::NullPointerException.new("handler must not be null")
          end
          @handler = handler
        end
        
        typesig { [] }
        # Returns the CallbackHandler.
        # 
        # @return the CallbackHandler.
        def get_callback_handler
          return @handler
        end
        
        private
        alias_method :initialize__callback_handler_protection, :initialize
      end }
      
      # A marker interface for <code>KeyStore</code> entry types.
      # 
      # @since 1.5
      const_set_lazy(:Entry) { Module.new do
        include_class_members KeyStore
      end }
      
      # A <code>KeyStore</code> entry that holds a <code>PrivateKey</code>
      # and corresponding certificate chain.
      # 
      # @since 1.5
      const_set_lazy(:PrivateKeyEntry) { Class.new do
        include_class_members KeyStore
        include Entry
        
        attr_accessor :priv_key
        alias_method :attr_priv_key, :priv_key
        undef_method :priv_key
        alias_method :attr_priv_key=, :priv_key=
        undef_method :priv_key=
        
        attr_accessor :chain
        alias_method :attr_chain, :chain
        undef_method :chain
        alias_method :attr_chain=, :chain=
        undef_method :chain=
        
        typesig { [class_self::PrivateKey, Array.typed(class_self::Certificate)] }
        # Constructs a <code>PrivateKeyEntry</code> with a
        # <code>PrivateKey</code> and corresponding certificate chain.
        # 
        # <p> The specified <code>chain</code> is cloned before it is stored
        # in the new <code>PrivateKeyEntry</code> object.
        # 
        # @param privateKey the <code>PrivateKey</code>
        # @param chain an array of <code>Certificate</code>s
        # representing the certificate chain.
        # The chain must be ordered and contain a
        # <code>Certificate</code> at index 0
        # corresponding to the private key.
        # 
        # @exception NullPointerException if
        # <code>privateKey</code> or <code>chain</code>
        # is <code>null</code>
        # @exception IllegalArgumentException if the specified chain has a
        # length of 0, if the specified chain does not contain
        # <code>Certificate</code>s of the same type,
        # or if the <code>PrivateKey</code> algorithm
        # does not match the algorithm of the <code>PublicKey</code>
        # in the end entity <code>Certificate</code> (at index 0)
        def initialize(private_key, chain)
          @priv_key = nil
          @chain = nil
          if ((private_key).nil? || (chain).nil?)
            raise self.class::NullPointerException.new("invalid null input")
          end
          if ((chain.attr_length).equal?(0))
            raise self.class::IllegalArgumentException.new("invalid zero-length input chain")
          end
          cloned_chain = chain.clone
          cert_type = cloned_chain[0].get_type
          i = 1
          while i < cloned_chain.attr_length
            if (!(cert_type == cloned_chain[i].get_type))
              raise self.class::IllegalArgumentException.new("chain does not contain certificates " + "of the same type")
            end
            i += 1
          end
          if (!(private_key.get_algorithm == cloned_chain[0].get_public_key.get_algorithm))
            raise self.class::IllegalArgumentException.new("private key algorithm does not match " + "algorithm of public key in end entity " + "certificate (at index 0)")
          end
          @priv_key = private_key
          if (cloned_chain[0].is_a?(self.class::X509Certificate) && !(cloned_chain.is_a?(Array.typed(self.class::X509Certificate))))
            @chain = Array.typed(self.class::X509Certificate).new(cloned_chain.attr_length) { nil }
            System.arraycopy(cloned_chain, 0, @chain, 0, cloned_chain.attr_length)
          else
            @chain = cloned_chain
          end
        end
        
        typesig { [] }
        # Gets the <code>PrivateKey</code> from this entry.
        # 
        # @return the <code>PrivateKey</code> from this entry
        def get_private_key
          return @priv_key
        end
        
        typesig { [] }
        # Gets the <code>Certificate</code> chain from this entry.
        # 
        # <p> The stored chain is cloned before being returned.
        # 
        # @return an array of <code>Certificate</code>s corresponding
        # to the certificate chain for the public key.
        # If the certificates are of type X.509,
        # the runtime type of the returned array is
        # <code>X509Certificate[]</code>.
        def get_certificate_chain
          return @chain.clone
        end
        
        typesig { [] }
        # Gets the end entity <code>Certificate</code>
        # from the certificate chain in this entry.
        # 
        # @return the end entity <code>Certificate</code> (at index 0)
        # from the certificate chain in this entry.
        # If the certificate is of type X.509,
        # the runtime type of the returned certificate is
        # <code>X509Certificate</code>.
        def get_certificate
          return @chain[0]
        end
        
        typesig { [] }
        # Returns a string representation of this PrivateKeyEntry.
        # @return a string representation of this PrivateKeyEntry.
        def to_s
          sb = self.class::StringBuilder.new
          sb.append("Private key entry and certificate chain with " + RJava.cast_to_string(@chain.attr_length) + " elements:\r\n")
          @chain.each do |cert|
            sb.append(cert)
            sb.append("\r\n")
          end
          return sb.to_s
        end
        
        private
        alias_method :initialize__private_key_entry, :initialize
      end }
      
      # A <code>KeyStore</code> entry that holds a <code>SecretKey</code>.
      # 
      # @since 1.5
      const_set_lazy(:SecretKeyEntry) { Class.new do
        include_class_members KeyStore
        include Entry
        
        attr_accessor :s_key
        alias_method :attr_s_key, :s_key
        undef_method :s_key
        alias_method :attr_s_key=, :s_key=
        undef_method :s_key=
        
        typesig { [class_self::SecretKey] }
        # Constructs a <code>SecretKeyEntry</code> with a
        # <code>SecretKey</code>.
        # 
        # @param secretKey the <code>SecretKey</code>
        # 
        # @exception NullPointerException if <code>secretKey</code>
        # is <code>null</code>
        def initialize(secret_key)
          @s_key = nil
          if ((secret_key).nil?)
            raise self.class::NullPointerException.new("invalid null input")
          end
          @s_key = secret_key
        end
        
        typesig { [] }
        # Gets the <code>SecretKey</code> from this entry.
        # 
        # @return the <code>SecretKey</code> from this entry
        def get_secret_key
          return @s_key
        end
        
        typesig { [] }
        # Returns a string representation of this SecretKeyEntry.
        # @return a string representation of this SecretKeyEntry.
        def to_s
          return "Secret key entry with algorithm " + RJava.cast_to_string(@s_key.get_algorithm)
        end
        
        private
        alias_method :initialize__secret_key_entry, :initialize
      end }
      
      # A <code>KeyStore</code> entry that holds a trusted
      # <code>Certificate</code>.
      # 
      # @since 1.5
      const_set_lazy(:TrustedCertificateEntry) { Class.new do
        include_class_members KeyStore
        include Entry
        
        attr_accessor :cert
        alias_method :attr_cert, :cert
        undef_method :cert
        alias_method :attr_cert=, :cert=
        undef_method :cert=
        
        typesig { [class_self::Certificate] }
        # Constructs a <code>TrustedCertificateEntry</code> with a
        # trusted <code>Certificate</code>.
        # 
        # @param trustedCert the trusted <code>Certificate</code>
        # 
        # @exception NullPointerException if
        # <code>trustedCert</code> is <code>null</code>
        def initialize(trusted_cert)
          @cert = nil
          if ((trusted_cert).nil?)
            raise self.class::NullPointerException.new("invalid null input")
          end
          @cert = trusted_cert
        end
        
        typesig { [] }
        # Gets the trusted <code>Certficate</code> from this entry.
        # 
        # @return the trusted <code>Certificate</code> from this entry
        def get_trusted_certificate
          return @cert
        end
        
        typesig { [] }
        # Returns a string representation of this TrustedCertificateEntry.
        # @return a string representation of this TrustedCertificateEntry.
        def to_s
          return "Trusted certificate entry:\r\n" + RJava.cast_to_string(@cert.to_s)
        end
        
        private
        alias_method :initialize__trusted_certificate_entry, :initialize
      end }
    }
    
    typesig { [KeyStoreSpi, Provider, String] }
    # Creates a KeyStore object of the given type, and encapsulates the given
    # provider implementation (SPI object) in it.
    # 
    # @param keyStoreSpi the provider implementation.
    # @param provider the provider.
    # @param type the keystore type.
    def initialize(key_store_spi, provider, type)
      @type = nil
      @provider = nil
      @key_store_spi = nil
      @initialized = false
      @key_store_spi = key_store_spi
      @provider = provider
      @type = type
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns a keystore object of the specified type.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new KeyStore object encapsulating the
      # KeyStoreSpi implementation from the first
      # Provider that supports the specified type is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param type the type of keystore.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard keystore types.
      # 
      # @return a keystore object of the specified type.
      # 
      # @exception KeyStoreException if no Provider supports a
      # KeyStoreSpi implementation for the
      # specified type.
      # 
      # @see Provider
      def get_instance(type)
        begin
          objs = Security.get_impl(type, "KeyStore", nil)
          return KeyStore.new(objs[0], objs[1], type)
        rescue NoSuchAlgorithmException => nsae
          raise KeyStoreException.new(type + " not found", nsae)
        rescue NoSuchProviderException => nspe
          raise KeyStoreException.new(type + " not found", nspe)
        end
      end
      
      typesig { [String, String] }
      # Returns a keystore object of the specified type.
      # 
      # <p> A new KeyStore object encapsulating the
      # KeyStoreSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param type the type of keystore.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard keystore types.
      # 
      # @param provider the name of the provider.
      # 
      # @return a keystore object of the specified type.
      # 
      # @exception KeyStoreException if a KeyStoreSpi
      # implementation for the specified type is not
      # available from the specified provider.
      # 
      # @exception NoSuchProviderException if the specified provider is not
      # registered in the security provider list.
      # 
      # @exception IllegalArgumentException if the provider name is null
      # or empty.
      # 
      # @see Provider
      def get_instance(type, provider)
        if ((provider).nil? || (provider.length).equal?(0))
          raise IllegalArgumentException.new("missing provider")
        end
        begin
          objs = Security.get_impl(type, "KeyStore", provider)
          return KeyStore.new(objs[0], objs[1], type)
        rescue NoSuchAlgorithmException => nsae
          raise KeyStoreException.new(type + " not found", nsae)
        end
      end
      
      typesig { [String, Provider] }
      # Returns a keystore object of the specified type.
      # 
      # <p> A new KeyStore object encapsulating the
      # KeyStoreSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param type the type of keystore.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard keystore types.
      # 
      # @param provider the provider.
      # 
      # @return a keystore object of the specified type.
      # 
      # @exception KeyStoreException if KeyStoreSpi
      # implementation for the specified type is not available
      # from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the specified provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(type, provider)
        if ((provider).nil?)
          raise IllegalArgumentException.new("missing provider")
        end
        begin
          objs = Security.get_impl(type, "KeyStore", provider)
          return KeyStore.new(objs[0], objs[1], type)
        rescue NoSuchAlgorithmException => nsae
          raise KeyStoreException.new(type + " not found", nsae)
        end
      end
      
      typesig { [] }
      # Returns the default keystore type as specified in the Java security
      # properties file, or the string
      # &quot;jks&quot; (acronym for &quot;Java keystore&quot;)
      # if no such property exists.
      # The Java security properties file is located in the file named
      # &lt;JAVA_HOME&gt;/lib/security/java.security.
      # &lt;JAVA_HOME&gt; refers to the value of the java.home system property,
      # and specifies the directory where the JRE is installed.
      # 
      # <p>The default keystore type can be used by applications that do not
      # want to use a hard-coded keystore type when calling one of the
      # <code>getInstance</code> methods, and want to provide a default keystore
      # type in case a user does not specify its own.
      # 
      # <p>The default keystore type can be changed by setting the value of the
      # "keystore.type" security property (in the Java security properties
      # file) to the desired keystore type.
      # 
      # @return the default keystore type as specified in the
      # Java security properties file, or the string &quot;jks&quot;
      # if no such property exists.
      def get_default_type
        kstype = nil
        kstype = RJava.cast_to_string(AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members KeyStore
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Security.get_property(KEYSTORE_TYPE)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)))
        if ((kstype).nil?)
          kstype = "jks"
        end
        return kstype
      end
    }
    
    typesig { [] }
    # Returns the provider of this keystore.
    # 
    # @return the provider of this keystore.
    def get_provider
      return @provider
    end
    
    typesig { [] }
    # Returns the type of this keystore.
    # 
    # @return the type of this keystore.
    def get_type
      return @type
    end
    
    typesig { [String, Array.typed(::Java::Char)] }
    # Returns the key associated with the given alias, using the given
    # password to recover it.  The key must have been associated with
    # the alias by a call to <code>setKeyEntry</code>,
    # or by a call to <code>setEntry</code> with a
    # <code>PrivateKeyEntry</code> or <code>SecretKeyEntry</code>.
    # 
    # @param alias the alias name
    # @param password the password for recovering the key
    # 
    # @return the requested key, or null if the given alias does not exist
    # or does not identify a key-related entry.
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # key cannot be found
    # @exception UnrecoverableKeyException if the key cannot be recovered
    # (e.g., the given password is wrong).
    def get_key(alias_, password)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_get_key(alias_, password)
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
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def get_certificate_chain(alias_)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_get_certificate_chain(alias_)
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
    # is returned.
    # 
    # @param alias the alias name
    # 
    # @return the certificate, or null if the given alias does not exist or
    # does not contain a certificate.
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def get_certificate(alias_)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_get_certificate(alias_)
    end
    
    typesig { [String] }
    # Returns the creation date of the entry identified by the given alias.
    # 
    # @param alias the alias name
    # 
    # @return the creation date of this entry, or null if the given alias does
    # not exist
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def get_creation_date(alias_)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_get_creation_date(alias_)
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
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded), the given key cannot be protected, or this operation fails
    # for some other reason
    def set_key_entry(alias_, key, password, chain)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      if ((key.is_a?(PrivateKey)) && ((chain).nil? || (chain.attr_length).equal?(0)))
        raise IllegalArgumentException.new("Private key must be " + "accompanied by certificate " + "chain")
      end
      @key_store_spi.engine_set_key_entry(alias_, key, password, chain)
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
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded), or if this operation fails for some other reason.
    def set_key_entry(alias_, key, chain)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      @key_store_spi.engine_set_key_entry(alias_, key, chain)
    end
    
    typesig { [String, Certificate] }
    # Assigns the given trusted certificate to the given alias.
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
    # @exception KeyStoreException if the keystore has not been initialized,
    # or the given alias already exists and does not identify an
    # entry containing a trusted certificate,
    # or this operation fails for some other reason.
    def set_certificate_entry(alias_, cert)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      @key_store_spi.engine_set_certificate_entry(alias_, cert)
    end
    
    typesig { [String] }
    # Deletes the entry identified by the given alias from this keystore.
    # 
    # @param alias the alias name
    # 
    # @exception KeyStoreException if the keystore has not been initialized,
    # or if the entry cannot be removed.
    def delete_entry(alias_)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      @key_store_spi.engine_delete_entry(alias_)
    end
    
    typesig { [] }
    # Lists all the alias names of this keystore.
    # 
    # @return enumeration of the alias names
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def aliases
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_aliases
    end
    
    typesig { [String] }
    # Checks if the given alias exists in this keystore.
    # 
    # @param alias the alias name
    # 
    # @return true if the alias exists, false otherwise
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def contains_alias(alias_)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_contains_alias(alias_)
    end
    
    typesig { [] }
    # Retrieves the number of entries in this keystore.
    # 
    # @return the number of entries in this keystore
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def size
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_size
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
    # key-related entry, false otherwise.
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def is_key_entry(alias_)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_is_key_entry(alias_)
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
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def is_certificate_entry(alias_)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_is_certificate_entry(alias_)
    end
    
    typesig { [Certificate] }
    # Returns the (alias) name of the first keystore entry whose certificate
    # matches the given certificate.
    # 
    # <p> This method attempts to match the given certificate with each
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
    # @return the alias name of the first entry with a matching certificate,
    # or null if no such entry exists in this keystore.
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    def get_certificate_alias(cert)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_get_certificate_alias(cert)
    end
    
    typesig { [OutputStream, Array.typed(::Java::Char)] }
    # Stores this keystore to the given output stream, and protects its
    # integrity with the given password.
    # 
    # @param stream the output stream to which this keystore is written.
    # @param password the password to generate the keystore integrity check
    # 
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    # @exception IOException if there was an I/O problem with data
    # @exception NoSuchAlgorithmException if the appropriate data integrity
    # algorithm could not be found
    # @exception CertificateException if any of the certificates included in
    # the keystore data could not be stored
    def store(stream, password)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      @key_store_spi.engine_store(stream, password)
    end
    
    typesig { [LoadStoreParameter] }
    # Stores this keystore using the given <code>LoadStoreParameter</code>.
    # 
    # @param param the <code>LoadStoreParameter</code>
    # that specifies how to store the keystore,
    # which may be <code>null</code>
    # 
    # @exception IllegalArgumentException if the given
    # <code>LoadStoreParameter</code>
    # input is not recognized
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded)
    # @exception IOException if there was an I/O problem with data
    # @exception NoSuchAlgorithmException if the appropriate data integrity
    # algorithm could not be found
    # @exception CertificateException if any of the certificates included in
    # the keystore data could not be stored
    # 
    # @since 1.5
    def store(param)
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      @key_store_spi.engine_store(param)
    end
    
    typesig { [InputStream, Array.typed(::Java::Char)] }
    # Loads this KeyStore from the given input stream.
    # 
    # <p>A password may be given to unlock the keystore
    # (e.g. the keystore resides on a hardware token device),
    # or to check the integrity of the keystore data.
    # If a password is not given for integrity checking,
    # then integrity checking is not performed.
    # 
    # <p>In order to create an empty keystore, or if the keystore cannot
    # be initialized from a stream, pass <code>null</code>
    # as the <code>stream</code> argument.
    # 
    # <p> Note that if this keystore has already been loaded, it is
    # reinitialized and loaded again from the given input stream.
    # 
    # @param stream the input stream from which the keystore is loaded,
    # or <code>null</code>
    # @param password the password used to check the integrity of
    # the keystore, the password used to unlock the keystore,
    # or <code>null</code>
    # 
    # @exception IOException if there is an I/O or format problem with the
    # keystore data, if a password is required but not given,
    # or if the given password was incorrect. If the error is due to a
    # wrong password, the {@link Throwable#getCause cause} of the
    # <code>IOException</code> should be an
    # <code>UnrecoverableKeyException</code>
    # @exception NoSuchAlgorithmException if the algorithm used to check
    # the integrity of the keystore cannot be found
    # @exception CertificateException if any of the certificates in the
    # keystore could not be loaded
    def load(stream, password)
      @key_store_spi.engine_load(stream, password)
      @initialized = true
    end
    
    typesig { [LoadStoreParameter] }
    # Loads this keystore using the given <code>LoadStoreParameter</code>.
    # 
    # <p> Note that if this KeyStore has already been loaded, it is
    # reinitialized and loaded again from the given parameter.
    # 
    # @param param the <code>LoadStoreParameter</code>
    # that specifies how to load the keystore,
    # which may be <code>null</code>
    # 
    # @exception IllegalArgumentException if the given
    # <code>LoadStoreParameter</code>
    # input is not recognized
    # @exception IOException if there is an I/O or format problem with the
    # keystore data. If the error is due to an incorrect
    # <code>ProtectionParameter</code> (e.g. wrong password)
    # the {@link Throwable#getCause cause} of the
    # <code>IOException</code> should be an
    # <code>UnrecoverableKeyException</code>
    # @exception NoSuchAlgorithmException if the algorithm used to check
    # the integrity of the keystore cannot be found
    # @exception CertificateException if any of the certificates in the
    # keystore could not be loaded
    # 
    # @since 1.5
    def load(param)
      @key_store_spi.engine_load(param)
      @initialized = true
    end
    
    typesig { [String, ProtectionParameter] }
    # Gets a keystore <code>Entry</code> for the specified alias
    # with the specified protection parameter.
    # 
    # @param alias get the keystore <code>Entry</code> for this alias
    # @param protParam the <code>ProtectionParameter</code>
    # used to protect the <code>Entry</code>,
    # which may be <code>null</code>
    # 
    # @return the keystore <code>Entry</code> for the specified alias,
    # or <code>null</code> if there is no such entry
    # 
    # @exception NullPointerException if
    # <code>alias</code> is <code>null</code>
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # entry cannot be found
    # @exception UnrecoverableEntryException if the specified
    # <code>protParam</code> were insufficient or invalid
    # @exception UnrecoverableKeyException if the entry is a
    # <code>PrivateKeyEntry</code> or <code>SecretKeyEntry</code>
    # and the specified <code>protParam</code> does not contain
    # the information needed to recover the key (e.g. wrong password)
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded).
    # @see #setEntry(String, KeyStore.Entry, KeyStore.ProtectionParameter)
    # 
    # @since 1.5
    def get_entry(alias_, prot_param)
      if ((alias_).nil?)
        raise NullPointerException.new("invalid null input")
      end
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_get_entry(alias_, prot_param)
    end
    
    typesig { [String, Entry, ProtectionParameter] }
    # Saves a keystore <code>Entry</code> under the specified alias.
    # The protection parameter is used to protect the
    # <code>Entry</code>.
    # 
    # <p> If an entry already exists for the specified alias,
    # it is overridden.
    # 
    # @param alias save the keystore <code>Entry</code> under this alias
    # @param entry the <code>Entry</code> to save
    # @param protParam the <code>ProtectionParameter</code>
    # used to protect the <code>Entry</code>,
    # which may be <code>null</code>
    # 
    # @exception NullPointerException if
    # <code>alias</code> or <code>entry</code>
    # is <code>null</code>
    # @exception KeyStoreException if the keystore has not been initialized
    # (loaded), or if this operation fails for some other reason
    # 
    # @see #getEntry(String, KeyStore.ProtectionParameter)
    # 
    # @since 1.5
    def set_entry(alias_, entry, prot_param)
      if ((alias_).nil? || (entry).nil?)
        raise NullPointerException.new("invalid null input")
      end
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      @key_store_spi.engine_set_entry(alias_, entry, prot_param)
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
    # 
    # @exception NullPointerException if
    # <code>alias</code> or <code>entryClass</code>
    # is <code>null</code>
    # @exception KeyStoreException if the keystore has not been
    # initialized (loaded)
    # 
    # @since 1.5
    def entry_instance_of(alias_, entry_class)
      if ((alias_).nil? || (entry_class).nil?)
        raise NullPointerException.new("invalid null input")
      end
      if (!@initialized)
        raise KeyStoreException.new("Uninitialized keystore")
      end
      return @key_store_spi.engine_entry_instance_of(alias_, entry_class)
    end
    
    class_module.module_eval {
      # A description of a to-be-instantiated KeyStore object.
      # 
      # <p>An instance of this class encapsulates the information needed to
      # instantiate and initialize a KeyStore object. That process is
      # triggered when the {@linkplain #getKeyStore} method is called.
      # 
      # <p>This makes it possible to decouple configuration from KeyStore
      # object creation and e.g. delay a password prompt until it is
      # needed.
      # 
      # @see KeyStore
      # @see javax.net.ssl.KeyStoreBuilderParameters
      # @since 1.5
      const_set_lazy(:Builder) { Class.new do
        include_class_members KeyStore
        
        class_module.module_eval {
          # maximum times to try the callbackhandler if the password is wrong
          const_set_lazy(:MAX_CALLBACK_TRIES) { 3 }
          const_attr_reader  :MAX_CALLBACK_TRIES
        }
        
        typesig { [] }
        # Construct a new Builder.
        def initialize
          # empty
        end
        
        typesig { [] }
        # Returns the KeyStore described by this object.
        # 
        # @exception KeyStoreException if an error occured during the
        # operation, for example if the KeyStore could not be
        # instantiated or loaded
        def get_key_store
          raise NotImplementedError
        end
        
        typesig { [String] }
        # Returns the ProtectionParameters that should be used to obtain
        # the {@link KeyStore.Entry Entry} with the given alias.
        # The <code>getKeyStore</code> method must be invoked before this
        # method may be called.
        # 
        # @return the ProtectionParameters that should be used to obtain
        # the {@link KeyStore.Entry Entry} with the given alias.
        # @param alias the alias of the KeyStore entry
        # @throws NullPointerException if alias is null
        # @throws KeyStoreException if an error occured during the
        # operation
        # @throws IllegalStateException if the getKeyStore method has
        # not been invoked prior to calling this method
        def get_protection_parameter(alias_)
          raise NotImplementedError
        end
        
        class_module.module_eval {
          typesig { [class_self::KeyStore, class_self::ProtectionParameter] }
          # Returns a new Builder that encapsulates the given KeyStore.
          # The {@linkplain #getKeyStore} method of the returned object
          # will return <code>keyStore</code>, the {@linkplain
          # #getProtectionParameter getProtectionParameter()} method will
          # return <code>protectionParameters</code>.
          # 
          # <p> This is useful if an existing KeyStore object needs to be
          # used with Builder-based APIs.
          # 
          # @return a new Builder object
          # @param keyStore the KeyStore to be encapsulated
          # @param protectionParameter the ProtectionParameter used to
          # protect the KeyStore entries
          # @throws NullPointerException if keyStore or
          # protectionParameters is null
          # @throws IllegalArgumentException if the keyStore has not been
          # initialized
          def new_instance(key_store, protection_parameter)
            if (((key_store).nil?) || ((protection_parameter).nil?))
              raise class_self::NullPointerException.new
            end
            if ((key_store.attr_initialized).equal?(false))
              raise class_self::IllegalArgumentException.new("KeyStore not initialized")
            end
            return Class.new(class_self::Builder.class == Class ? class_self::Builder : Object) do
              extend LocalClass
              include_class_members Builder
              include class_self::Builder if class_self::Builder.class == Module
              
              attr_accessor :get_called
              alias_method :attr_get_called, :get_called
              undef_method :get_called
              alias_method :attr_get_called=, :get_called=
              undef_method :get_called=
              
              typesig { [] }
              define_method :get_key_store do
                @get_called = true
                return key_store
              end
              
              typesig { [String] }
              define_method :get_protection_parameter do |alias_|
                if ((alias_).nil?)
                  raise self.class::NullPointerException.new
                end
                if ((@get_called).equal?(false))
                  raise self.class::IllegalStateException.new("getKeyStore() must be called first")
                end
                return protection_parameter
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                @get_called = false
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
          
          typesig { [String, class_self::Provider, class_self::JavaFile, class_self::ProtectionParameter] }
          # Returns a new Builder object.
          # 
          # <p>The first call to the {@link #getKeyStore} method on the returned
          # builder will create a KeyStore of type <code>type</code> and call
          # its {@link KeyStore#load load()} method.
          # The <code>inputStream</code> argument is constructed from
          # <code>file</code>.
          # If <code>protection</code> is a
          # <code>PasswordProtection</code>, the password is obtained by
          # calling the <code>getPassword</code> method.
          # Otherwise, if <code>protection</code> is a
          # <code>CallbackHandlerProtection</code>, the password is obtained
          # by invoking the CallbackHandler.
          # 
          # <p>Subsequent calls to {@link #getKeyStore} return the same object
          # as the initial call. If the initial call to failed with a
          # KeyStoreException, subsequent calls also throw a
          # KeyStoreException.
          # 
          # <p>The KeyStore is instantiated from <code>provider</code> if
          # non-null. Otherwise, all installed providers are searched.
          # 
          # <p>Calls to {@link #getProtectionParameter getProtectionParameter()}
          # will return a {@link KeyStore.PasswordProtection PasswordProtection}
          # object encapsulating the password that was used to invoke the
          # <code>load</code> method.
          # 
          # <p><em>Note</em> that the {@link #getKeyStore} method is executed
          # within the {@link AccessControlContext} of the code invoking this
          # method.
          # 
          # @return a new Builder object
          # @param type the type of KeyStore to be constructed
          # @param provider the provider from which the KeyStore is to
          # be instantiated (or null)
          # @param file the File that contains the KeyStore data
          # @param protection the ProtectionParameter securing the KeyStore data
          # @throws NullPointerException if type, file or protection is null
          # @throws IllegalArgumentException if protection is not an instance
          # of either PasswordProtection or CallbackHandlerProtection; or
          # if file does not exist or does not refer to a normal file
          def new_instance(type, provider, file, protection)
            if (((type).nil?) || ((file).nil?) || ((protection).nil?))
              raise class_self::NullPointerException.new
            end
            if (((protection.is_a?(class_self::PasswordProtection)).equal?(false)) && ((protection.is_a?(class_self::CallbackHandlerProtection)).equal?(false)))
              raise class_self::IllegalArgumentException.new("Protection must be PasswordProtection or " + "CallbackHandlerProtection")
            end
            if ((file.is_file).equal?(false))
              raise class_self::IllegalArgumentException.new("File does not exist or it does not refer " + "to a normal file: " + RJava.cast_to_string(file))
            end
            return class_self::FileBuilder.new(type, provider, file, protection, AccessController.get_context)
          end
          
          const_set_lazy(:FileBuilder) { Class.new(class_self::Builder) do
            include_class_members Builder
            
            attr_accessor :type
            alias_method :attr_type, :type
            undef_method :type
            alias_method :attr_type=, :type=
            undef_method :type=
            
            attr_accessor :provider
            alias_method :attr_provider, :provider
            undef_method :provider
            alias_method :attr_provider=, :provider=
            undef_method :provider=
            
            attr_accessor :file
            alias_method :attr_file, :file
            undef_method :file
            alias_method :attr_file=, :file=
            undef_method :file=
            
            attr_accessor :protection
            alias_method :attr_protection, :protection
            undef_method :protection
            alias_method :attr_protection=, :protection=
            undef_method :protection=
            
            attr_accessor :key_protection
            alias_method :attr_key_protection, :key_protection
            undef_method :key_protection
            alias_method :attr_key_protection=, :key_protection=
            undef_method :key_protection=
            
            attr_accessor :context
            alias_method :attr_context, :context
            undef_method :context
            alias_method :attr_context=, :context=
            undef_method :context=
            
            attr_accessor :key_store
            alias_method :attr_key_store, :key_store
            undef_method :key_store
            alias_method :attr_key_store=, :key_store=
            undef_method :key_store=
            
            attr_accessor :old_exception
            alias_method :attr_old_exception, :old_exception
            undef_method :old_exception
            alias_method :attr_old_exception=, :old_exception=
            undef_method :old_exception=
            
            typesig { [String, class_self::Provider, class_self::JavaFile, class_self::ProtectionParameter, class_self::AccessControlContext] }
            def initialize(type, provider, file, protection, context)
              @type = nil
              @provider = nil
              @file = nil
              @protection = nil
              @key_protection = nil
              @context = nil
              @key_store = nil
              @old_exception = nil
              super()
              @type = type
              @provider = provider
              @file = file
              @protection = protection
              @context = context
            end
            
            typesig { [] }
            def get_key_store
              synchronized(self) do
                if (!(@key_store).nil?)
                  return @key_store
                end
                if (!(@old_exception).nil?)
                  raise self.class::KeyStoreException.new("Previous KeyStore instantiation failed", @old_exception)
                end
                action = Class.new(self.class::PrivilegedExceptionAction.class == Class ? self.class::PrivilegedExceptionAction : Object) do
                  extend LocalClass
                  include_class_members FileBuilder
                  include class_self::PrivilegedExceptionAction if class_self::PrivilegedExceptionAction.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    if ((self.attr_protection.is_a?(self.class::CallbackHandlerProtection)).equal?(false))
                      return run0
                    end
                    # when using a CallbackHandler,
                    # reprompt if the password is wrong
                    tries = 0
                    while (true)
                      tries += 1
                      begin
                        return run0
                      rescue self.class::IOException => e
                        if ((tries < self.class::MAX_CALLBACK_TRIES) && (e.get_cause.is_a?(self.class::UnrecoverableKeyException)))
                          next
                        end
                        raise e
                      end
                    end
                  end
                  
                  typesig { [] }
                  define_method :run0 do
                    ks = nil
                    if ((self.attr_provider).nil?)
                      ks = KeyStore.get_instance(self.attr_type)
                    else
                      ks = KeyStore.get_instance(self.attr_type, self.attr_provider)
                    end
                    in_ = nil
                    password = nil
                    begin
                      in_ = self.class::FileInputStream.new(self.attr_file)
                      if (self.attr_protection.is_a?(self.class::PasswordProtection))
                        password = (self.attr_protection).get_password
                        self.attr_key_protection = self.attr_protection
                      else
                        handler = (self.attr_protection).get_callback_handler
                        callback = self.class::PasswordCallback.new("Password for keystore " + RJava.cast_to_string(self.attr_file.get_name), false)
                        handler.handle(Array.typed(self.class::Callback).new([callback]))
                        password = callback.get_password
                        if ((password).nil?)
                          raise self.class::KeyStoreException.new("No password" + " provided")
                        end
                        callback.clear_password
                        self.attr_key_protection = self.class::PasswordProtection.new(password)
                      end
                      ks.load(in_, password)
                      return ks
                    ensure
                      if (!(in_).nil?)
                        in_.close
                      end
                    end
                  end
                  
                  typesig { [Vararg.new(Object)] }
                  define_method :initialize do |*args|
                    super(*args)
                  end
                  
                  private
                  alias_method :initialize_anonymous, :initialize
                end.new_local(self)
                begin
                  @key_store = AccessController.do_privileged(action, @context)
                  return @key_store
                rescue self.class::PrivilegedActionException => e
                  @old_exception = e.get_cause
                  raise self.class::KeyStoreException.new("KeyStore instantiation failed", @old_exception)
                end
              end
            end
            
            typesig { [String] }
            def get_protection_parameter(alias_)
              synchronized(self) do
                if ((alias_).nil?)
                  raise self.class::NullPointerException.new
                end
                if ((@key_store).nil?)
                  raise self.class::IllegalStateException.new("getKeyStore() must be called first")
                end
                return @key_protection
              end
            end
            
            private
            alias_method :initialize__file_builder, :initialize
          end }
          
          typesig { [String, class_self::Provider, class_self::ProtectionParameter] }
          # Returns a new Builder object.
          # 
          # <p>Each call to the {@link #getKeyStore} method on the returned
          # builder will return a new KeyStore object of type <code>type</code>.
          # Its {@link KeyStore#load(KeyStore.LoadStoreParameter) load()}
          # method is invoked using a
          # <code>LoadStoreParameter</code> that encapsulates
          # <code>protection</code>.
          # 
          # <p>The KeyStore is instantiated from <code>provider</code> if
          # non-null. Otherwise, all installed providers are searched.
          # 
          # <p>Calls to {@link #getProtectionParameter getProtectionParameter()}
          # will return <code>protection</code>.
          # 
          # <p><em>Note</em> that the {@link #getKeyStore} method is executed
          # within the {@link AccessControlContext} of the code invoking this
          # method.
          # 
          # @return a new Builder object
          # @param type the type of KeyStore to be constructed
          # @param provider the provider from which the KeyStore is to
          # be instantiated (or null)
          # @param protection the ProtectionParameter securing the Keystore
          # @throws NullPointerException if type or protection is null
          def new_instance(type, provider, protection)
            if (((type).nil?) || ((protection).nil?))
              raise class_self::NullPointerException.new
            end
            context = AccessController.get_context
            return Class.new(class_self::Builder.class == Class ? class_self::Builder : Object) do
              extend LocalClass
              include_class_members Builder
              include class_self::Builder if class_self::Builder.class == Module
              
              attr_accessor :get_called
              alias_method :attr_get_called, :get_called
              undef_method :get_called
              alias_method :attr_get_called=, :get_called=
              undef_method :get_called=
              
              attr_accessor :old_exception
              alias_method :attr_old_exception, :old_exception
              undef_method :old_exception
              alias_method :attr_old_exception=, :old_exception=
              undef_method :old_exception=
              
              attr_accessor :action
              alias_method :attr_action, :action
              undef_method :action
              alias_method :attr_action=, :action=
              undef_method :action=
              
              typesig { [] }
              define_method :get_key_store do
                synchronized(self) do
                  if (!(@old_exception).nil?)
                    raise self.class::KeyStoreException.new("Previous KeyStore instantiation failed", @old_exception)
                  end
                  begin
                    return AccessController.do_privileged(@action)
                  rescue self.class::PrivilegedActionException => e
                    cause = e.get_cause
                    raise self.class::KeyStoreException.new("KeyStore instantiation failed", cause)
                  end
                end
              end
              
              typesig { [String] }
              define_method :get_protection_parameter do |alias_|
                if ((alias_).nil?)
                  raise self.class::NullPointerException.new
                end
                if ((@get_called).equal?(false))
                  raise self.class::IllegalStateException.new("getKeyStore() must be called first")
                end
                return protection
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                @get_called = false
                @old_exception = nil
                @action = nil
                super(*args)
                builder_class = self.class
                @action = Class.new(self.class::PrivilegedExceptionAction.class == Class ? self.class::PrivilegedExceptionAction : Object) do
                  extend LocalClass
                  include_class_members builder_class
                  include class_self::PrivilegedExceptionAction if class_self::PrivilegedExceptionAction.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    ks = nil
                    if ((provider).nil?)
                      ks = KeyStore.get_instance(type)
                    else
                      ks = KeyStore.get_instance(type, provider)
                    end
                    param = self.class::SimpleLoadStoreParameter.new(protection)
                    if ((protection.is_a?(self.class::CallbackHandlerProtection)).equal?(false))
                      ks.load(param)
                    else
                      # when using a CallbackHandler,
                      # reprompt if the password is wrong
                      tries = 0
                      while (true)
                        tries += 1
                        begin
                          ks.load(param)
                          break
                        rescue self.class::IOException => e
                          if (e.get_cause.is_a?(self.class::UnrecoverableKeyException))
                            if (tries < self.class::MAX_CALLBACK_TRIES)
                              next
                            else
                              self.attr_old_exception = e
                            end
                          end
                          raise e
                        end
                      end
                    end
                    self.attr_get_called = true
                    return ks
                  end
                  
                  typesig { [Vararg.new(Object)] }
                  define_method :initialize do |*args|
                    super(*args)
                  end
                  
                  private
                  alias_method :initialize_anonymous, :initialize
                end.new_local(self)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
        }
        
        private
        alias_method :initialize__builder, :initialize
      end }
      
      const_set_lazy(:SimpleLoadStoreParameter) { Class.new do
        include_class_members KeyStore
        include LoadStoreParameter
        
        attr_accessor :protection
        alias_method :attr_protection, :protection
        undef_method :protection
        alias_method :attr_protection=, :protection=
        undef_method :protection=
        
        typesig { [class_self::ProtectionParameter] }
        def initialize(protection)
          @protection = nil
          @protection = protection
        end
        
        typesig { [] }
        def get_protection_parameter
          return @protection
        end
        
        private
        alias_method :initialize__simple_load_store_parameter, :initialize
      end }
    }
    
    private
    alias_method :initialize__key_store, :initialize
  end
  
end
