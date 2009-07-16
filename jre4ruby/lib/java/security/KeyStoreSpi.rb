require "rjava"

# 
# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KeyStoreSpiImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security::KeyStore
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Javax::Crypto, :SecretKey
      include ::Javax::Security::Auth::Callback
    }
  end
  
  # 
  # This class defines the <i>Service Provider Interface</i> (<b>SPI</b>)
  # for the <code>KeyStore</code> class.
  # All the abstract methods in this class must be implemented by each
  # cryptographic service provider who wishes to supply the implementation
  # of a keystore for a particular keystore type.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see KeyStore
  # 
  # @since 1.2
  class KeyStoreSpi 
    include_class_members KeyStoreSpiImports
    
    typesig { [String, Array.typed(::Java::Char)] }
    # 
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
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # key cannot be found
    # @exception UnrecoverableKeyException if the key cannot be recovered
    # (e.g., the given password is wrong).
    def engine_get_key(alias_, password)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
    # Returns the creation date of the entry identified by the given alias.
    # 
    # @param alias the alias name
    # 
    # @return the creation date of this entry, or null if the given alias does
    # not exist
    def engine_get_creation_date(alias_)
      raise NotImplementedError
    end
    
    typesig { [String, Key, Array.typed(::Java::Char), Array.typed(Certificate)] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [String, Array.typed(::Java::Byte), Array.typed(Certificate)] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [String, Certificate] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
    # Deletes the entry identified by the given alias from this keystore.
    # 
    # @param alias the alias name
    # 
    # @exception KeyStoreException if the entry cannot be removed.
    def engine_delete_entry(alias_)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Lists all the alias names of this keystore.
    # 
    # @return enumeration of the alias names
    def engine_aliases
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
    # Checks if the given alias exists in this keystore.
    # 
    # @param alias the alias name
    # 
    # @return true if the alias exists, false otherwise
    def engine_contains_alias(alias_)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Retrieves the number of entries in this keystore.
    # 
    # @return the number of entries in this keystore
    def engine_size
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [Certificate] }
    # 
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
      raise NotImplementedError
    end
    
    typesig { [OutputStream, Array.typed(::Java::Char)] }
    # 
    # Stores this keystore to the given output stream, and protects its
    # integrity with the given password.
    # 
    # @param stream the output stream to which this keystore is written.
    # @param password the password to generate the keystore integrity check
    # 
    # @exception IOException if there was an I/O problem with data
    # @exception NoSuchAlgorithmException if the appropriate data integrity
    # algorithm could not be found
    # @exception CertificateException if any of the certificates included in
    # the keystore data could not be stored
    def engine_store(stream, password)
      raise NotImplementedError
    end
    
    typesig { [KeyStore::LoadStoreParameter] }
    # 
    # Stores this keystore using the given
    # <code>KeyStore.LoadStoreParmeter</code>.
    # 
    # @param param the <code>KeyStore.LoadStoreParmeter</code>
    # that specifies how to store the keystore,
    # which may be <code>null</code>
    # 
    # @exception IllegalArgumentException if the given
    # <code>KeyStore.LoadStoreParmeter</code>
    # input is not recognized
    # @exception IOException if there was an I/O problem with data
    # @exception NoSuchAlgorithmException if the appropriate data integrity
    # algorithm could not be found
    # @exception CertificateException if any of the certificates included in
    # the keystore data could not be stored
    # 
    # @since 1.5
    def engine_store(param)
      raise UnsupportedOperationException.new
    end
    
    typesig { [InputStream, Array.typed(::Java::Char)] }
    # 
    # Loads the keystore from the given input stream.
    # 
    # <p>A password may be given to unlock the keystore
    # (e.g. the keystore resides on a hardware token device),
    # or to check the integrity of the keystore data.
    # If a password is not given for integrity checking,
    # then integrity checking is not performed.
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
    def engine_load(stream, password)
      raise NotImplementedError
    end
    
    typesig { [KeyStore::LoadStoreParameter] }
    # 
    # Loads the keystore using the given
    # <code>KeyStore.LoadStoreParameter</code>.
    # 
    # <p> Note that if this KeyStore has already been loaded, it is
    # reinitialized and loaded again from the given parameter.
    # 
    # @param param the <code>KeyStore.LoadStoreParameter</code>
    # that specifies how to load the keystore,
    # which may be <code>null</code>
    # 
    # @exception IllegalArgumentException if the given
    # <code>KeyStore.LoadStoreParameter</code>
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
    def engine_load(param)
      if ((param).nil?)
        engine_load(nil, nil)
        return
      end
      if (param.is_a?(KeyStore::SimpleLoadStoreParameter))
        protection = param.get_protection_parameter
        password = nil
        if (protection.is_a?(PasswordProtection))
          password = (protection).get_password
        else
          if (protection.is_a?(CallbackHandlerProtection))
            handler = (protection).get_callback_handler
            callback = PasswordCallback.new("Password: ", false)
            begin
              handler.handle(Array.typed(Callback).new([callback]))
            rescue UnsupportedCallbackException => e
              raise NoSuchAlgorithmException.new("Could not obtain password", e)
            end
            password = callback.get_password
            callback.clear_password
            if ((password).nil?)
              raise NoSuchAlgorithmException.new("No password provided")
            end
          else
            raise NoSuchAlgorithmException.new("ProtectionParameter must" + " be PasswordProtection or CallbackHandlerProtection")
          end
        end
        engine_load(nil, password)
        return
      end
      raise UnsupportedOperationException.new
    end
    
    typesig { [String, KeyStore::ProtectionParameter] }
    # 
    # Gets a <code>KeyStore.Entry</code> for the specified alias
    # with the specified protection parameter.
    # 
    # @param alias get the <code>KeyStore.Entry</code> for this alias
    # @param protParam the <code>ProtectionParameter</code>
    # used to protect the <code>Entry</code>,
    # which may be <code>null</code>
    # 
    # @return the <code>KeyStore.Entry</code> for the specified alias,
    # or <code>null</code> if there is no such entry
    # 
    # @exception KeyStoreException if the operation failed
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # entry cannot be found
    # @exception UnrecoverableEntryException if the specified
    # <code>protParam</code> were insufficient or invalid
    # @exception UnrecoverableKeyException if the entry is a
    # <code>PrivateKeyEntry</code> or <code>SecretKeyEntry</code>
    # and the specified <code>protParam</code> does not contain
    # the information needed to recover the key (e.g. wrong password)
    # 
    # @since 1.5
    def engine_get_entry(alias_, prot_param)
      if (!engine_contains_alias(alias_))
        return nil
      end
      if ((prot_param).nil?)
        if (engine_is_certificate_entry(alias_))
          return KeyStore::TrustedCertificateEntry.new(engine_get_certificate(alias_))
        else
          raise UnrecoverableKeyException.new("requested entry requires a password")
        end
      end
      if (prot_param.is_a?(KeyStore::PasswordProtection))
        if (engine_is_certificate_entry(alias_))
          raise UnsupportedOperationException.new("trusted certificate entries are not password-protected")
        else
          if (engine_is_key_entry(alias_))
            pp = prot_param
            password = pp.get_password
            key = engine_get_key(alias_, password)
            if (key.is_a?(PrivateKey))
              chain = engine_get_certificate_chain(alias_)
              return KeyStore::PrivateKeyEntry.new(key, chain)
            else
              if (key.is_a?(SecretKey))
                return KeyStore::SecretKeyEntry.new(key)
              end
            end
          end
        end
      end
      raise UnsupportedOperationException.new
    end
    
    typesig { [String, KeyStore::Entry, KeyStore::ProtectionParameter] }
    # 
    # Saves a <code>KeyStore.Entry</code> under the specified alias.
    # The specified protection parameter is used to protect the
    # <code>Entry</code>.
    # 
    # <p> If an entry already exists for the specified alias,
    # it is overridden.
    # 
    # @param alias save the <code>KeyStore.Entry</code> under this alias
    # @param entry the <code>Entry</code> to save
    # @param protParam the <code>ProtectionParameter</code>
    # used to protect the <code>Entry</code>,
    # which may be <code>null</code>
    # 
    # @exception KeyStoreException if this operation fails
    # 
    # @since 1.5
    def engine_set_entry(alias_, entry, prot_param)
      # get password
      if (!(prot_param).nil? && !(prot_param.is_a?(KeyStore::PasswordProtection)))
        raise KeyStoreException.new("unsupported protection parameter")
      end
      p_protect = nil
      if (!(prot_param).nil?)
        p_protect = prot_param
      end
      # set entry
      if (entry.is_a?(KeyStore::TrustedCertificateEntry))
        if (!(prot_param).nil? && !(p_protect.get_password).nil?)
          # pre-1.5 style setCertificateEntry did not allow password
          raise KeyStoreException.new("trusted certificate entries are not password-protected")
        else
          tce = entry
          engine_set_certificate_entry(alias_, tce.get_trusted_certificate)
          return
        end
      else
        if (entry.is_a?(KeyStore::PrivateKeyEntry))
          if ((p_protect).nil? || (p_protect.get_password).nil?)
            # pre-1.5 style setKeyEntry required password
            raise KeyStoreException.new("non-null password required to create PrivateKeyEntry")
          else
            engine_set_key_entry(alias_, (entry).get_private_key, p_protect.get_password, (entry).get_certificate_chain)
            return
          end
        else
          if (entry.is_a?(KeyStore::SecretKeyEntry))
            if ((p_protect).nil? || (p_protect.get_password).nil?)
              # pre-1.5 style setKeyEntry required password
              raise KeyStoreException.new("non-null password required to create SecretKeyEntry")
            else
              engine_set_key_entry(alias_, (entry).get_secret_key, p_protect.get_password, nil)
              return
            end
          end
        end
      end
      raise KeyStoreException.new("unsupported entry type: " + (entry.get_class.get_name).to_s)
    end
    
    typesig { [String, Class] }
    # 
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
    # @since 1.5
    def engine_entry_instance_of(alias_, entry_class)
      if ((entry_class).equal?(KeyStore::TrustedCertificateEntry.class))
        return engine_is_certificate_entry(alias_)
      end
      if ((entry_class).equal?(KeyStore::PrivateKeyEntry.class))
        return engine_is_key_entry(alias_) && !(engine_get_certificate(alias_)).nil?
      end
      if ((entry_class).equal?(KeyStore::SecretKeyEntry.class))
        return engine_is_key_entry(alias_) && (engine_get_certificate(alias_)).nil?
      end
      return false
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__key_store_spi, :initialize
  end
  
end
