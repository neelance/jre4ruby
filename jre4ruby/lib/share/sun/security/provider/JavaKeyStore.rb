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
  module JavaKeyStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Io
      include ::Java::Security
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include ::Java::Util
      include_const ::Sun::Security::Pkcs, :EncryptedPrivateKeyInfo
    }
  end
  
  # This class provides the keystore implementation referred to as "JKS".
  # 
  # @author Jan Luehe
  # @author David Brownell
  # 
  # 
  # @see KeyProtector
  # @see java.security.KeyStoreSpi
  # @see KeyTool
  # 
  # @since 1.2
  class JavaKeyStore < JavaKeyStoreImports.const_get :KeyStoreSpi
    include_class_members JavaKeyStoreImports
    
    class_module.module_eval {
      # regular JKS
      const_set_lazy(:JKS) { Class.new(JavaKeyStore) do
        include_class_members JavaKeyStore
        
        typesig { [String] }
        def convert_alias(alias_)
          return alias_.to_lower_case
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__jks, :initialize
      end }
      
      # special JKS that uses case sensitive aliases
      const_set_lazy(:CaseExactJKS) { Class.new(JavaKeyStore) do
        include_class_members JavaKeyStore
        
        typesig { [String] }
        def convert_alias(alias_)
          return alias_
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__case_exact_jks, :initialize
      end }
      
      const_set_lazy(:MAGIC) { -0x1120113 }
      const_attr_reader  :MAGIC
      
      const_set_lazy(:VERSION_1) { 0x1 }
      const_attr_reader  :VERSION_1
      
      const_set_lazy(:VERSION_2) { 0x2 }
      const_attr_reader  :VERSION_2
      
      # Private keys and their supporting certificate chains
      const_set_lazy(:KeyEntry) { Class.new do
        include_class_members JavaKeyStore
        
        attr_accessor :date
        alias_method :attr_date, :date
        undef_method :date
        alias_method :attr_date=, :date=
        undef_method :date=
        
        # the creation date of this entry
        attr_accessor :protected_priv_key
        alias_method :attr_protected_priv_key, :protected_priv_key
        undef_method :protected_priv_key
        alias_method :attr_protected_priv_key=, :protected_priv_key=
        undef_method :protected_priv_key=
        
        attr_accessor :chain
        alias_method :attr_chain, :chain
        undef_method :chain
        alias_method :attr_chain=, :chain=
        undef_method :chain=
        
        typesig { [] }
        def initialize
          @date = nil
          @protected_priv_key = nil
          @chain = nil
        end
        
        private
        alias_method :initialize__key_entry, :initialize
      end }
      
      # Trusted certificates
      const_set_lazy(:TrustedCertEntry) { Class.new do
        include_class_members JavaKeyStore
        
        attr_accessor :date
        alias_method :attr_date, :date
        undef_method :date
        alias_method :attr_date=, :date=
        undef_method :date=
        
        # the creation date of this entry
        attr_accessor :cert
        alias_method :attr_cert, :cert
        undef_method :cert
        alias_method :attr_cert=, :cert=
        undef_method :cert=
        
        typesig { [] }
        def initialize
          @date = nil
          @cert = nil
        end
        
        private
        alias_method :initialize__trusted_cert_entry, :initialize
      end }
    }
    
    # Private keys and certificates are stored in a hashtable.
    # Hash entries are keyed by alias names.
    attr_accessor :entries
    alias_method :attr_entries, :entries
    undef_method :entries
    alias_method :attr_entries=, :entries=
    undef_method :entries=
    
    typesig { [] }
    def initialize
      @entries = nil
      super()
      @entries = Hashtable.new
    end
    
    typesig { [String] }
    # convert an alias to internal form, overridden in subclasses:
    # lower case for regular JKS
    # original string for CaseExactJKS
    def convert_alias(alias_)
      raise NotImplementedError
    end
    
    typesig { [String, Array.typed(::Java::Char)] }
    # Returns the key associated with the given alias, using the given
    # password to recover it.
    # 
    # @param alias the alias name
    # @param password the password for recovering the key
    # 
    # @return the requested key, or null if the given alias does not exist
    # or does not identify a <i>key entry</i>.
    # 
    # @exception NoSuchAlgorithmException if the algorithm for recovering the
    # key cannot be found
    # @exception UnrecoverableKeyException if the key cannot be recovered
    # (e.g., the given password is wrong).
    def engine_get_key(alias_, password)
      entry = @entries.get(convert_alias(alias_))
      if ((entry).nil? || !(entry.is_a?(KeyEntry)))
        return nil
      end
      if ((password).nil?)
        raise UnrecoverableKeyException.new("Password must not be null")
      end
      key_protector = KeyProtector.new(password)
      encr_bytes = (entry).attr_protected_priv_key
      encr_info = nil
      plain = nil
      begin
        encr_info = EncryptedPrivateKeyInfo.new(encr_bytes)
      rescue IOException => ioe
        raise UnrecoverableKeyException.new("Private key not stored as " + "PKCS #8 " + "EncryptedPrivateKeyInfo")
      end
      return key_protector.recover(encr_info)
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
      entry = @entries.get(convert_alias(alias_))
      if (!(entry).nil? && entry.is_a?(KeyEntry))
        if (((entry).attr_chain).nil?)
          return nil
        else
          return (entry).attr_chain.clone
        end
      else
        return nil
      end
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
      entry = @entries.get(convert_alias(alias_))
      if (!(entry).nil?)
        if (entry.is_a?(TrustedCertEntry))
          return (entry).attr_cert
        else
          if (((entry).attr_chain).nil?)
            return nil
          else
            return (entry).attr_chain[0]
          end
        end
      else
        return nil
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
      entry = @entries.get(convert_alias(alias_))
      if (!(entry).nil?)
        if (entry.is_a?(TrustedCertEntry))
          return JavaDate.new((entry).attr_date.get_time)
        else
          return JavaDate.new((entry).attr_date.get_time)
        end
      else
        return nil
      end
    end
    
    typesig { [String, Key, Array.typed(::Java::Char), Array.typed(Certificate)] }
    # Assigns the given private key to the given alias, protecting
    # it with the given password as defined in PKCS8.
    # 
    # <p>The given java.security.PrivateKey <code>key</code> must
    # be accompanied by a certificate chain certifying the
    # corresponding public key.
    # 
    # <p>If the given alias already exists, the keystore information
    # associated with it is overridden by the given key and certificate
    # chain.
    # 
    # @param alias the alias name
    # @param key the private key to be associated with the alias
    # @param password the password to protect the key
    # @param chain the certificate chain for the corresponding public
    # key (only required if the given key is of type
    # <code>java.security.PrivateKey</code>).
    # 
    # @exception KeyStoreException if the given key is not a private key,
    # cannot be protected, or this operation fails for some other reason
    def engine_set_key_entry(alias_, key, password, chain)
      key_protector = nil
      if (!(key.is_a?(Java::Security::PrivateKey)))
        raise KeyStoreException.new("Cannot store non-PrivateKeys")
      end
      begin
        synchronized((@entries)) do
          entry = KeyEntry.new
          entry.attr_date = JavaDate.new
          # Protect the encoding of the key
          key_protector = KeyProtector.new(password)
          entry.attr_protected_priv_key = key_protector.protect(key)
          # clone the chain
          if ((!(chain).nil?) && (!(chain.attr_length).equal?(0)))
            entry.attr_chain = chain.clone
          else
            entry.attr_chain = nil
          end
          @entries.put(convert_alias(alias_), entry)
        end
      rescue NoSuchAlgorithmException => nsae
        raise KeyStoreException.new("Key protection algorithm not found")
      ensure
        key_protector = nil
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
      synchronized((@entries)) do
        # key must be encoded as EncryptedPrivateKeyInfo as defined in
        # PKCS#8
        begin
          EncryptedPrivateKeyInfo.new(key)
        rescue IOException => ioe
          raise KeyStoreException.new("key is not encoded as " + "EncryptedPrivateKeyInfo")
        end
        entry = KeyEntry.new
        entry.attr_date = JavaDate.new
        entry.attr_protected_priv_key = key.clone
        if ((!(chain).nil?) && (!(chain.attr_length).equal?(0)))
          entry.attr_chain = chain.clone
        else
          entry.attr_chain = nil
        end
        @entries.put(convert_alias(alias_), entry)
      end
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
      synchronized((@entries)) do
        entry = @entries.get(convert_alias(alias_))
        if ((!(entry).nil?) && (entry.is_a?(KeyEntry)))
          raise KeyStoreException.new("Cannot overwrite own certificate")
        end
        trusted_cert_entry = TrustedCertEntry.new
        trusted_cert_entry.attr_cert = cert
        trusted_cert_entry.attr_date = JavaDate.new
        @entries.put(convert_alias(alias_), trusted_cert_entry)
      end
    end
    
    typesig { [String] }
    # Deletes the entry identified by the given alias from this keystore.
    # 
    # @param alias the alias name
    # 
    # @exception KeyStoreException if the entry cannot be removed.
    def engine_delete_entry(alias_)
      synchronized((@entries)) do
        @entries.remove(convert_alias(alias_))
      end
    end
    
    typesig { [] }
    # Lists all the alias names of this keystore.
    # 
    # @return enumeration of the alias names
    def engine_aliases
      return @entries.keys
    end
    
    typesig { [String] }
    # Checks if the given alias exists in this keystore.
    # 
    # @param alias the alias name
    # 
    # @return true if the alias exists, false otherwise
    def engine_contains_alias(alias_)
      return @entries.contains_key(convert_alias(alias_))
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
      entry = @entries.get(convert_alias(alias_))
      if ((!(entry).nil?) && (entry.is_a?(KeyEntry)))
        return true
      else
        return false
      end
    end
    
    typesig { [String] }
    # Returns true if the entry identified by the given alias is a
    # <i>trusted certificate entry</i>, and false otherwise.
    # 
    # @return true if the entry identified by the given alias is a
    # <i>trusted certificate entry</i>, false otherwise.
    def engine_is_certificate_entry(alias_)
      entry = @entries.get(convert_alias(alias_))
      if ((!(entry).nil?) && (entry.is_a?(TrustedCertEntry)))
        return true
      else
        return false
      end
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
      cert_elem = nil
      e = @entries.keys
      while e.has_more_elements
        alias_ = e.next_element
        entry = @entries.get(alias_)
        if (entry.is_a?(TrustedCertEntry))
          cert_elem = (entry).attr_cert
        else
          if (!((entry).attr_chain).nil?)
            cert_elem = (entry).attr_chain[0]
          else
            next
          end
        end
        if ((cert_elem == cert))
          return alias_
        end
      end
      return nil
    end
    
    typesig { [OutputStream, Array.typed(::Java::Char)] }
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
      synchronized((@entries)) do
        # KEYSTORE FORMAT:
        # 
        # Magic number (big-endian integer),
        # Version of this file format (big-endian integer),
        # 
        # Count (big-endian integer),
        # followed by "count" instances of either:
        # 
        #     {
        #      tag=1 (big-endian integer),
        #      alias (UTF string)
        #      timestamp
        #      encrypted private-key info according to PKCS #8
        #          (integer length followed by encoding)
        #      cert chain (integer count, then certs; for each cert,
        #          integer length followed by encoding)
        #     }
        # 
        # or:
        # 
        #     {
        #      tag=2 (big-endian integer)
        #      alias (UTF string)
        #      timestamp
        #      cert (integer length followed by encoding)
        #     }
        # 
        # ended by a keyed SHA1 hash (bytes only) of
        #     { password + whitener + preceding body }
        # password is mandatory when storing
        if ((password).nil?)
          raise IllegalArgumentException.new("password can't be null")
        end
        encoded = nil # the certificate encoding
        md = get_pre_keyed_hash(password)
        dos = DataOutputStream.new(DigestOutputStream.new(stream, md))
        dos.write_int(MAGIC)
        # always write the latest version
        dos.write_int(VERSION_2)
        dos.write_int(@entries.size)
        e = @entries.keys
        while e.has_more_elements
          alias_ = e.next_element
          entry = @entries.get(alias_)
          if (entry.is_a?(KeyEntry))
            # Store this entry as a KeyEntry
            dos.write_int(1)
            # Write the alias
            dos.write_utf(alias_)
            # Write the (entry creation) date
            dos.write_long((entry).attr_date.get_time)
            # Write the protected private key
            dos.write_int((entry).attr_protected_priv_key.attr_length)
            dos.write((entry).attr_protected_priv_key)
            # Write the certificate chain
            chain_len = 0
            if (((entry).attr_chain).nil?)
              chain_len = 0
            else
              chain_len = (entry).attr_chain.attr_length
            end
            dos.write_int(chain_len)
            i = 0
            while i < chain_len
              encoded = (entry).attr_chain[i].get_encoded
              dos.write_utf((entry).attr_chain[i].get_type)
              dos.write_int(encoded.attr_length)
              dos.write(encoded)
              i += 1
            end
          else
            # Store this entry as a certificate
            dos.write_int(2)
            # Write the alias
            dos.write_utf(alias_)
            # Write the (entry creation) date
            dos.write_long((entry).attr_date.get_time)
            # Write the trusted certificate
            encoded = (entry).attr_cert.get_encoded
            dos.write_utf((entry).attr_cert.get_type)
            dos.write_int(encoded.attr_length)
            dos.write(encoded)
          end
        end
        # Write the keyed hash which is used to detect tampering with
        # the keystore (such as deleting or modifying key or
        # certificate entries).
        digest_ = md.digest
        dos.write(digest_)
        dos.flush
      end
    end
    
    typesig { [InputStream, Array.typed(::Java::Char)] }
    # Loads the keystore from the given input stream.
    # 
    # <p>If a password is given, it is used to check the integrity of the
    # keystore data. Otherwise, the integrity of the keystore is not checked.
    # 
    # @param stream the input stream from which the keystore is loaded
    # @param password the (optional) password used to check the integrity of
    # the keystore.
    # 
    # @exception IOException if there is an I/O or format problem with the
    # keystore data
    # @exception NoSuchAlgorithmException if the algorithm used to check
    # the integrity of the keystore cannot be found
    # @exception CertificateException if any of the certificates in the
    # keystore could not be loaded
    def engine_load(stream, password)
      synchronized((@entries)) do
        dis = nil
        md = nil
        cf = nil
        cfs = nil
        bais = nil
        encoded = nil
        if ((stream).nil?)
          return
        end
        if (!(password).nil?)
          md = get_pre_keyed_hash(password)
          dis = DataInputStream.new(DigestInputStream.new(stream, md))
        else
          dis = DataInputStream.new(stream)
        end
        # Body format: see store method
        x_magic = dis.read_int
        x_version = dis.read_int
        if (!(x_magic).equal?(MAGIC) || (!(x_version).equal?(VERSION_1) && !(x_version).equal?(VERSION_2)))
          raise IOException.new("Invalid keystore format")
        end
        if ((x_version).equal?(VERSION_1))
          cf = CertificateFactory.get_instance("X509")
        else
          # version 2
          cfs = Hashtable.new(3)
        end
        @entries.clear
        count = dis.read_int
        i = 0
        while i < count
          tag = 0
          alias_ = nil
          tag = dis.read_int
          if ((tag).equal?(1))
            # private key entry
            entry = KeyEntry.new
            # Read the alias
            alias_ = RJava.cast_to_string(dis.read_utf)
            # Read the (entry creation) date
            entry.attr_date = JavaDate.new(dis.read_long)
            # Read the private key
            begin
              entry.attr_protected_priv_key = Array.typed(::Java::Byte).new(dis.read_int) { 0 }
            rescue OutOfMemoryError => e
              raise IOException.new("Keysize too big")
            end
            dis.read_fully(entry.attr_protected_priv_key)
            # Read the certificate chain
            num_of_certs = dis.read_int
            begin
              if (num_of_certs > 0)
                entry.attr_chain = Array.typed(Certificate).new(num_of_certs) { nil }
              end
            rescue OutOfMemoryError => e
              raise IOException.new("Too many certificates in chain")
            end
            j = 0
            while j < num_of_certs
              if ((x_version).equal?(2))
                # read the certificate type, and instantiate a
                # certificate factory of that type (reuse
                # existing factory if possible)
                cert_type = dis.read_utf
                if (cfs.contains_key(cert_type))
                  # reuse certificate factory
                  cf = cfs.get(cert_type)
                else
                  # create new certificate factory
                  cf = CertificateFactory.get_instance(cert_type)
                  # store the certificate factory so we can
                  # reuse it later
                  cfs.put(cert_type, cf)
                end
              end
              # instantiate the certificate
              begin
                encoded = Array.typed(::Java::Byte).new(dis.read_int) { 0 }
              rescue OutOfMemoryError => e
                raise IOException.new("Certificate too big")
              end
              dis.read_fully(encoded)
              bais = ByteArrayInputStream.new(encoded)
              entry.attr_chain[j] = cf.generate_certificate(bais)
              bais.close
              j += 1
            end
            # Add the entry to the list
            @entries.put(alias_, entry)
          else
            if ((tag).equal?(2))
              # trusted certificate entry
              entry = TrustedCertEntry.new
              # Read the alias
              alias_ = RJava.cast_to_string(dis.read_utf)
              # Read the (entry creation) date
              entry.attr_date = JavaDate.new(dis.read_long)
              # Read the trusted certificate
              if ((x_version).equal?(2))
                # read the certificate type, and instantiate a
                # certificate factory of that type (reuse
                # existing factory if possible)
                cert_type = dis.read_utf
                if (cfs.contains_key(cert_type))
                  # reuse certificate factory
                  cf = cfs.get(cert_type)
                else
                  # create new certificate factory
                  cf = CertificateFactory.get_instance(cert_type)
                  # store the certificate factory so we can
                  # reuse it later
                  cfs.put(cert_type, cf)
                end
              end
              begin
                encoded = Array.typed(::Java::Byte).new(dis.read_int) { 0 }
              rescue OutOfMemoryError => e
                raise IOException.new("Certificate too big")
              end
              dis.read_fully(encoded)
              bais = ByteArrayInputStream.new(encoded)
              entry.attr_cert = cf.generate_certificate(bais)
              bais.close
              # Add the entry to the list
              @entries.put(alias_, entry)
            else
              raise IOException.new("Unrecognized keystore entry")
            end
          end
          i += 1
        end
        # If a password has been provided, we check the keyed digest
        # at the end. If this check fails, the store has been tampered
        # with
        if (!(password).nil?)
          computed = nil
          actual = nil
          computed = md.digest
          actual = Array.typed(::Java::Byte).new(computed.attr_length) { 0 }
          dis.read_fully(actual)
          i_ = 0
          while i_ < computed.attr_length
            if (!(computed[i_]).equal?(actual[i_]))
              t = UnrecoverableKeyException.new("Password verification failed")
              raise IOException.new("Keystore was tampered with, or " + "password was incorrect").init_cause(t)
            end
            i_ += 1
          end
        end
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # To guard against tampering with the keystore, we append a keyed
    # hash with a bit of whitener.
    def get_pre_keyed_hash(password)
      i = 0
      j = 0
      md = MessageDigest.get_instance("SHA")
      passwd_bytes = Array.typed(::Java::Byte).new(password.attr_length * 2) { 0 }
      i = 0
      j = 0
      while i < password.attr_length
        passwd_bytes[((j += 1) - 1)] = (password[i] >> 8)
        passwd_bytes[((j += 1) - 1)] = password[i]
        i += 1
      end
      md.update(passwd_bytes)
      i = 0
      while i < passwd_bytes.attr_length
        passwd_bytes[i] = 0
        i += 1
      end
      md.update("Mighty Aphrodite".get_bytes("UTF8"))
      return md
    end
    
    private
    alias_method :initialize__java_key_store, :initialize
  end
  
end
