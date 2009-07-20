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
module Sun::Security::Pkcs12
  module PKCS12KeyStoreImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs12
      include ::Java::Io
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :Key
      include_const ::Java::Security, :KeyFactory
      include_const ::Java::Security, :PrivateKey
      include_const ::Java::Security, :KeyStoreSpi
      include_const ::Java::Security, :KeyStoreException
      include_const ::Java::Security, :UnrecoverableKeyException
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Spec, :PKCS8EncodedKeySpec
      include ::Java::Util
      include ::Java::Math
      include_const ::Java::Security, :AlgorithmParameters
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Javax::Crypto::Spec, :PBEParameterSpec
      include_const ::Javax::Crypto::Spec, :PBEKeySpec
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include_const ::Javax::Crypto, :SecretKeyFactory
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto, :Mac
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Security::Pkcs, :ContentInfo
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::Pkcs, :EncryptedPrivateKeyInfo
    }
  end
  
  # This class provides the keystore implementation referred to as "PKCS12".
  # Implements the PKCS#12 PFX protected using the Password privacy mode.
  # The contents are protected using Password integrity mode.
  # 
  # Currently we support following PBE algorithms:
  # - pbeWithSHAAnd3KeyTripleDESCBC to encrypt private keys
  # - pbeWithSHAAnd40BitRC2CBC to encrypt certificates
  # 
  # Supported encryption of various implementations :
  # 
  # Software and mode.     Certificate encryption  Private key encryption
  # ---------------------------------------------------------------------
  # MSIE4 (domestic            40 bit RC2.            40 bit RC2
  # and xport versions)
  # PKCS#12 export.
  # 
  # MSIE4, 5 (domestic         40 bit RC2,            40 bit RC2,
  # and export versions)       3 key triple DES       3 key triple DES
  # PKCS#12 import.
  # 
  # MSIE5                      40 bit RC2             3 key triple DES,
  # PKCS#12 export.                                   with SHA1 (168 bits)
  # 
  # Netscape Communicator      40 bit RC2             3 key triple DES,
  # (domestic and export                              with SHA1 (168 bits)
  # versions) PKCS#12 export
  # 
  # Netscape Communicator      40 bit ciphers only    All.
  # (export version)
  # PKCS#12 import.
  # 
  # Netscape Communicator      All.                   All.
  # (domestic or fortified
  # version) PKCS#12 import.
  # 
  # OpenSSL PKCS#12 code.      All.                   All.
  # ---------------------------------------------------------------------
  # 
  # NOTE: Currently PKCS12 KeyStore does not support TrustedCertEntries.
  # PKCS#12 is mainly used to deliver private keys with their associated
  # certificate chain and aliases. In a PKCS12 keystore, entries are
  # identified by the alias, and a localKeyId is required to match the
  # private key with the certificate.
  # 
  # @author Seema Malkani
  # @author Jeff Nisewanger
  # @author Jan Luehe
  # 
  # @see KeyProtector
  # @see java.security.KeyStoreSpi
  # @see KeyTool
  class PKCS12KeyStore < PKCS12KeyStoreImports.const_get :KeyStoreSpi
    include_class_members PKCS12KeyStoreImports
    
    class_module.module_eval {
      const_set_lazy(:VERSION_3) { 3 }
      const_attr_reader  :VERSION_3
      
      const_set_lazy(:KeyBag) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 12, 10, 1, 2]) }
      const_attr_reader  :KeyBag
      
      const_set_lazy(:CertBag) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 12, 10, 1, 3]) }
      const_attr_reader  :CertBag
      
      const_set_lazy(:Pkcs9Name) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 9, 20]) }
      const_attr_reader  :Pkcs9Name
      
      const_set_lazy(:Pkcs9KeyId) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 9, 21]) }
      const_attr_reader  :Pkcs9KeyId
      
      const_set_lazy(:Pkcs9certType) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 9, 22, 1]) }
      const_attr_reader  :Pkcs9certType
      
      const_set_lazy(:PbeWithSHAAnd40BitRC2CBC) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 12, 1, 6]) }
      const_attr_reader  :PbeWithSHAAnd40BitRC2CBC
      
      const_set_lazy(:PbeWithSHAAnd3KeyTripleDESCBC) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 12, 1, 3]) }
      const_attr_reader  :PbeWithSHAAnd3KeyTripleDESCBC
      
      
      def pkcs8shrouded_key_bag_oid
        defined?(@@pkcs8shrouded_key_bag_oid) ? @@pkcs8shrouded_key_bag_oid : @@pkcs8shrouded_key_bag_oid= nil
      end
      alias_method :attr_pkcs8shrouded_key_bag_oid, :pkcs8shrouded_key_bag_oid
      
      def pkcs8shrouded_key_bag_oid=(value)
        @@pkcs8shrouded_key_bag_oid = value
      end
      alias_method :attr_pkcs8shrouded_key_bag_oid=, :pkcs8shrouded_key_bag_oid=
      
      
      def cert_bag_oid
        defined?(@@cert_bag_oid) ? @@cert_bag_oid : @@cert_bag_oid= nil
      end
      alias_method :attr_cert_bag_oid, :cert_bag_oid
      
      def cert_bag_oid=(value)
        @@cert_bag_oid = value
      end
      alias_method :attr_cert_bag_oid=, :cert_bag_oid=
      
      
      def pkcs9friendly_name_oid
        defined?(@@pkcs9friendly_name_oid) ? @@pkcs9friendly_name_oid : @@pkcs9friendly_name_oid= nil
      end
      alias_method :attr_pkcs9friendly_name_oid, :pkcs9friendly_name_oid
      
      def pkcs9friendly_name_oid=(value)
        @@pkcs9friendly_name_oid = value
      end
      alias_method :attr_pkcs9friendly_name_oid=, :pkcs9friendly_name_oid=
      
      
      def pkcs9local_key_id_oid
        defined?(@@pkcs9local_key_id_oid) ? @@pkcs9local_key_id_oid : @@pkcs9local_key_id_oid= nil
      end
      alias_method :attr_pkcs9local_key_id_oid, :pkcs9local_key_id_oid
      
      def pkcs9local_key_id_oid=(value)
        @@pkcs9local_key_id_oid = value
      end
      alias_method :attr_pkcs9local_key_id_oid=, :pkcs9local_key_id_oid=
      
      
      def pkcs9cert_type_oid
        defined?(@@pkcs9cert_type_oid) ? @@pkcs9cert_type_oid : @@pkcs9cert_type_oid= nil
      end
      alias_method :attr_pkcs9cert_type_oid, :pkcs9cert_type_oid
      
      def pkcs9cert_type_oid=(value)
        @@pkcs9cert_type_oid = value
      end
      alias_method :attr_pkcs9cert_type_oid=, :pkcs9cert_type_oid=
      
      
      def pbe_with_shaand40bit_rc2cbc_oid
        defined?(@@pbe_with_shaand40bit_rc2cbc_oid) ? @@pbe_with_shaand40bit_rc2cbc_oid : @@pbe_with_shaand40bit_rc2cbc_oid= nil
      end
      alias_method :attr_pbe_with_shaand40bit_rc2cbc_oid, :pbe_with_shaand40bit_rc2cbc_oid
      
      def pbe_with_shaand40bit_rc2cbc_oid=(value)
        @@pbe_with_shaand40bit_rc2cbc_oid = value
      end
      alias_method :attr_pbe_with_shaand40bit_rc2cbc_oid=, :pbe_with_shaand40bit_rc2cbc_oid=
      
      
      def pbe_with_shaand3key_triple_descbc_oid
        defined?(@@pbe_with_shaand3key_triple_descbc_oid) ? @@pbe_with_shaand3key_triple_descbc_oid : @@pbe_with_shaand3key_triple_descbc_oid= nil
      end
      alias_method :attr_pbe_with_shaand3key_triple_descbc_oid, :pbe_with_shaand3key_triple_descbc_oid
      
      def pbe_with_shaand3key_triple_descbc_oid=(value)
        @@pbe_with_shaand3key_triple_descbc_oid = value
      end
      alias_method :attr_pbe_with_shaand3key_triple_descbc_oid=, :pbe_with_shaand3key_triple_descbc_oid=
    }
    
    attr_accessor :counter
    alias_method :attr_counter, :counter
    undef_method :counter
    alias_method :attr_counter=, :counter=
    undef_method :counter=
    
    class_module.module_eval {
      const_set_lazy(:IterationCount) { 1024 }
      const_attr_reader  :IterationCount
      
      const_set_lazy(:SALT_LEN) { 20 }
      const_attr_reader  :SALT_LEN
    }
    
    # private key count
    # Note: This is a workaround to allow null localKeyID attribute
    # in pkcs12 with one private key entry and associated cert-chain
    attr_accessor :private_key_count
    alias_method :attr_private_key_count, :private_key_count
    undef_method :private_key_count
    alias_method :attr_private_key_count=, :private_key_count=
    undef_method :private_key_count=
    
    # the source of randomness
    attr_accessor :random
    alias_method :attr_random, :random
    undef_method :random
    alias_method :attr_random=, :random=
    undef_method :random=
    
    class_module.module_eval {
      when_class_loaded do
        begin
          self.attr_pkcs8shrouded_key_bag_oid = ObjectIdentifier.new(KeyBag)
          self.attr_cert_bag_oid = ObjectIdentifier.new(CertBag)
          self.attr_pkcs9friendly_name_oid = ObjectIdentifier.new(Pkcs9Name)
          self.attr_pkcs9local_key_id_oid = ObjectIdentifier.new(Pkcs9KeyId)
          self.attr_pkcs9cert_type_oid = ObjectIdentifier.new(Pkcs9certType)
          self.attr_pbe_with_shaand40bit_rc2cbc_oid = ObjectIdentifier.new(PbeWithSHAAnd40BitRC2CBC)
          self.attr_pbe_with_shaand3key_triple_descbc_oid = ObjectIdentifier.new(PbeWithSHAAnd3KeyTripleDESCBC)
        rescue IOException => ioe
          # should not happen
        end
      end
      
      # Private keys and their supporting certificate chains
      const_set_lazy(:KeyEntry) { Class.new do
        include_class_members PKCS12KeyStore
        
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
        
        attr_accessor :key_id
        alias_method :attr_key_id, :key_id
        undef_method :key_id
        alias_method :attr_key_id=, :key_id=
        undef_method :key_id=
        
        attr_accessor :alias
        alias_method :attr_alias, :alias
        undef_method :alias
        alias_method :attr_alias=, :alias=
        undef_method :alias=
        
        typesig { [] }
        def initialize
          @date = nil
          @protected_priv_key = nil
          @chain = nil
          @key_id = nil
          @alias = nil
        end
        
        private
        alias_method :initialize__key_entry, :initialize
      end }
      
      const_set_lazy(:KeyId) { Class.new do
        include_class_members PKCS12KeyStore
        
        attr_accessor :key_id
        alias_method :attr_key_id, :key_id
        undef_method :key_id
        alias_method :attr_key_id=, :key_id=
        undef_method :key_id=
        
        typesig { [Array.typed(::Java::Byte)] }
        def initialize(key_id)
          @key_id = nil
          @key_id = key_id
        end
        
        typesig { [] }
        def hash_code
          hash = 0
          i = 0
          while i < @key_id.attr_length
            hash += @key_id[i]
            i += 1
          end
          return hash
        end
        
        typesig { [Object] }
        def equals(obj)
          if (!(obj.is_a?(KeyId)))
            return false
          end
          that = obj
          return ((Arrays == @key_id))
        end
        
        private
        alias_method :initialize__key_id, :initialize
      end }
    }
    
    # Private keys and certificates are stored in a hashtable.
    # Hash entries are keyed by alias names.
    attr_accessor :entries
    alias_method :attr_entries, :entries
    undef_method :entries
    alias_method :attr_entries=, :entries=
    undef_method :entries=
    
    attr_accessor :key_list
    alias_method :attr_key_list, :key_list
    undef_method :key_list
    alias_method :attr_key_list=, :key_list=
    undef_method :key_list=
    
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
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
      entry = @entries.get(alias_.to_lower_case)
      key = nil
      if ((entry).nil?)
        return nil
      end
      # get the encoded private key
      encr_bytes = entry.attr_protected_priv_key
      encrypted_key = nil
      alg_params = nil
      alg_oid = nil
      begin
        # get the encrypted private key
        encr_info = EncryptedPrivateKeyInfo.new(encr_bytes)
        encrypted_key = encr_info.get_encrypted_data
        # parse Algorithm parameters
        val = DerValue.new(encr_info.get_algorithm.encode)
        in_ = val.to_der_input_stream
        alg_oid = in_.get_oid
        alg_params = parse_alg_parameters(in_)
      rescue IOException => ioe
        uke = UnrecoverableKeyException.new("Private key not stored as " + "PKCS#8 EncryptedPrivateKeyInfo: " + (ioe).to_s)
        uke.init_cause(ioe)
        raise uke
      end
      begin
        # Use JCE
        skey = get_pbekey(password)
        cipher = Cipher.get_instance(alg_oid.to_s)
        cipher.init(Cipher::DECRYPT_MODE, skey, alg_params)
        private_key_info = cipher.do_final(encrypted_key)
        kspec = PKCS8EncodedKeySpec.new(private_key_info)
        # Parse the key algorithm and then use a JCA key factory
        # to create the private key.
        val_ = DerValue.new(private_key_info)
        in__ = val_.to_der_input_stream
        i = in__.get_integer
        value = in__.get_sequence(2)
        alg_id = AlgorithmId.new(value[0].get_oid)
        alg_name = alg_id.get_name
        kfac = KeyFactory.get_instance(alg_name)
        key = kfac.generate_private(kspec)
      rescue Exception => e
        uke = UnrecoverableKeyException.new("Get Key failed: " + (e.get_message).to_s)
        uke.init_cause(e)
        raise uke
      end
      return key
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
      entry = @entries.get(alias_.to_lower_case)
      if (!(entry).nil?)
        if ((entry.attr_chain).nil?)
          return nil
        else
          return entry.attr_chain.clone
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
      entry = @entries.get(alias_.to_lower_case)
      if (!(entry).nil?)
        if ((entry.attr_chain).nil?)
          return nil
        else
          return entry.attr_chain[0]
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
      entry = @entries.get(alias_.to_lower_case)
      if (!(entry).nil?)
        return Date.new(entry.attr_date.get_time)
      else
        return nil
      end
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
        begin
          entry = KeyEntry.new
          entry.attr_date = Date.new
          if (key.is_a?(PrivateKey))
            if (((key.get_format == "PKCS#8")) || ((key.get_format == "PKCS8")))
              # Encrypt the private key
              entry.attr_protected_priv_key = encrypt_private_key(key.get_encoded, password)
            else
              raise KeyStoreException.new("Private key is not encoded" + "as PKCS#8")
            end
          else
            raise KeyStoreException.new("Key is not a PrivateKey")
          end
          # clone the chain
          if (!(chain).nil?)
            # validate cert-chain
            if ((chain.attr_length > 1) && (!validate_chain(chain)))
              raise KeyStoreException.new("Certificate chain is " + "not validate")
            end
            entry.attr_chain = chain.clone
          end
          # set the keyId to current date
          entry.attr_key_id = ("Time " + ((entry.attr_date).get_time).to_s).get_bytes("UTF8")
          # set the alias
          entry.attr_alias = alias_.to_lower_case
          # add the entry
          @entries.put(alias_.to_lower_case, entry)
        rescue Exception => nsae
          ke = KeyStoreException.new("Key protection " + " algorithm not found: " + (nsae).to_s)
          ke.init_cause(nsae)
          raise ke
        end
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
      synchronized(self) do
        # key must be encoded as EncryptedPrivateKeyInfo
        # as defined in PKCS#8
        begin
          EncryptedPrivateKeyInfo.new(key)
        rescue IOException => ioe
          ke = KeyStoreException.new("Private key is not" + " stored as PKCS#8 EncryptedPrivateKeyInfo: " + (ioe).to_s)
          ke.init_cause(ioe)
          raise ke
        end
        entry = KeyEntry.new
        entry.attr_date = Date.new
        entry.attr_protected_priv_key = key.clone
        if (!(chain).nil?)
          entry.attr_chain = chain.clone
        end
        # add the entry
        @entries.put(alias_.to_lower_case, entry)
      end
    end
    
    typesig { [] }
    # Generate random salt
    def get_salt
      # Generate a random salt.
      salt = Array.typed(::Java::Byte).new(SALT_LEN) { 0 }
      if ((@random).nil?)
        @random = SecureRandom.new
      end
      @random.next_bytes(salt)
      return salt
    end
    
    typesig { [String] }
    # Generate PBE Algorithm Parameters
    def get_algorithm_parameters(algorithm)
      alg_params = nil
      # create PBE parameters from salt and iteration count
      param_spec = PBEParameterSpec.new(get_salt, IterationCount)
      begin
        alg_params = AlgorithmParameters.get_instance(algorithm)
        alg_params.init(param_spec)
      rescue Exception => e
        ioe = IOException.new("getAlgorithmParameters failed: " + (e.get_message).to_s)
        ioe.init_cause(e)
        raise ioe
      end
      return alg_params
    end
    
    typesig { [DerInputStream] }
    # parse Algorithm Parameters
    def parse_alg_parameters(in_)
      alg_params = nil
      begin
        params = nil
        if ((in_.available).equal?(0))
          params = nil
        else
          params = in_.get_der_value
          if ((params.attr_tag).equal?(DerValue.attr_tag_null))
            params = nil
          end
        end
        if (!(params).nil?)
          alg_params = AlgorithmParameters.get_instance("PBE")
          alg_params.init(params.to_byte_array)
        end
      rescue Exception => e
        ioe = IOException.new("parseAlgParameters failed: " + (e.get_message).to_s)
        ioe.init_cause(e)
        raise ioe
      end
      return alg_params
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Generate PBE key
    def get_pbekey(password)
      skey = nil
      begin
        key_spec = PBEKeySpec.new(password)
        sk_fac = SecretKeyFactory.get_instance("PBE")
        skey = sk_fac.generate_secret(key_spec)
      rescue Exception => e
        ioe = IOException.new("getSecretKey failed: " + (e.get_message).to_s)
        ioe.init_cause(e)
        raise ioe
      end
      return skey
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Char)] }
    # Encrypt private key using Password-based encryption (PBE)
    # as defined in PKCS#5.
    # 
    # NOTE: Currently pbeWithSHAAnd3-KeyTripleDES-CBC algorithmID is
    # used to derive the key and IV.
    # 
    # @return encrypted private key encoded as EncryptedPrivateKeyInfo
    def encrypt_private_key(data, password)
      key = nil
      begin
        # create AlgorithmParameters
        alg_params = get_algorithm_parameters("PBEWithSHA1AndDESede")
        # Use JCE
        skey = get_pbekey(password)
        cipher = Cipher.get_instance("PBEWithSHA1AndDESede")
        cipher.init(Cipher::ENCRYPT_MODE, skey, alg_params)
        encrypted_key = cipher.do_final(data)
        # wrap encrypted private key in EncryptedPrivateKeyInfo
        # as defined in PKCS#8
        algid = AlgorithmId.new(self.attr_pbe_with_shaand3key_triple_descbc_oid, alg_params)
        encr_info = EncryptedPrivateKeyInfo.new(algid, encrypted_key)
        key = encr_info.get_encoded
      rescue Exception => e
        uke = UnrecoverableKeyException.new("Encrypt Private Key failed: " + (e.get_message).to_s)
        uke.init_cause(e)
        raise uke
      end
      return key
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
    # identify a <i>key entry</i>, or on an attempt to create a
    # <i>trusted cert entry</i> which is currently not supported.
    def engine_set_certificate_entry(alias_, cert)
      synchronized(self) do
        entry = @entries.get(alias_.to_lower_case)
        if (!(entry).nil?)
          raise KeyStoreException.new("Cannot overwrite own certificate")
        else
          raise KeyStoreException.new("TrustedCertEntry not supported")
        end
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
        @entries.remove(alias_.to_lower_case)
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
      return @entries.contains_key(alias_.to_lower_case)
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
      entry = @entries.get(alias_.to_lower_case)
      if (!(entry).nil?)
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
      # TrustedCertEntry is not supported
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
      cert_elem = nil
      e = @entries.keys
      while e.has_more_elements
        alias_ = e.next_element
        entry = @entries.get(alias_)
        if (!(entry.attr_chain).nil?)
          cert_elem = entry.attr_chain[0]
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
      synchronized(self) do
        # password is mandatory when storing
        if ((password).nil?)
          raise IllegalArgumentException.new("password can't be null")
        end
        # -- Create PFX
        pfx = DerOutputStream.new
        # PFX version (always write the latest version)
        version = DerOutputStream.new
        version.put_integer(VERSION_3)
        pfx_version = version.to_byte_array
        pfx.write(pfx_version)
        # -- Create AuthSafe
        auth_safe = DerOutputStream.new
        # -- Create ContentInfos
        auth_safe_content_info = DerOutputStream.new
        # -- create safeContent Data ContentInfo
        safe_content_data = create_safe_content
        data_content_info = ContentInfo.new(safe_content_data)
        data_content_info.encode(auth_safe_content_info)
        # -- create EncryptedContentInfo
        encr_data = create_encrypted_data(password)
        encr_content_info = ContentInfo.new(ContentInfo::ENCRYPTED_DATA_OID, DerValue.new(encr_data))
        encr_content_info.encode(auth_safe_content_info)
        # wrap as SequenceOf ContentInfos
        c_info = DerOutputStream.new
        c_info.write(DerValue.attr_tag_sequence_of, auth_safe_content_info)
        authenticated_safe = c_info.to_byte_array
        # Create Encapsulated ContentInfo
        content_info = ContentInfo.new(authenticated_safe)
        content_info.encode(auth_safe)
        auth_safe_data = auth_safe.to_byte_array
        pfx.write(auth_safe_data)
        # -- MAC
        mac_data = calculate_mac(password, authenticated_safe)
        pfx.write(mac_data)
        # write PFX to output stream
        pfxout = DerOutputStream.new
        pfxout.write(DerValue.attr_tag_sequence, pfx)
        pfx_data = pfxout.to_byte_array
        stream.write(pfx_data)
        stream.flush
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Generate Hash.
    def generate_hash(data)
      digest = nil
      begin
        md = MessageDigest.get_instance("SHA1")
        md.update(data)
        digest = md.digest
      rescue Exception => e
        ioe = IOException.new("generateHash failed: " + (e).to_s)
        ioe.init_cause(e)
        raise ioe
      end
      return digest
    end
    
    typesig { [Array.typed(::Java::Char), Array.typed(::Java::Byte)] }
    # Calculate MAC using HMAC algorithm (required for password integrity)
    # 
    # Hash-based MAC algorithm combines secret key with message digest to
    # create a message authentication code (MAC)
    def calculate_mac(passwd, data)
      m_data = nil
      alg_name = "SHA1"
      begin
        # Generate a random salt.
        salt = get_salt
        # generate MAC (MAC key is generated within JCE)
        m = Mac.get_instance("HmacPBESHA1")
        params = PBEParameterSpec.new(salt, IterationCount)
        key = get_pbekey(passwd)
        m.init(key, params)
        m.update(data)
        mac_result = m.do_final
        # encode as MacData
        mac_data = MacData.new(alg_name, mac_result, salt, IterationCount)
        bytes = DerOutputStream.new
        bytes.write(mac_data.get_encoded)
        m_data = bytes.to_byte_array
      rescue Exception => e
        ioe = IOException.new("calculateMac failed: " + (e).to_s)
        ioe.init_cause(e)
        raise ioe
      end
      return m_data
    end
    
    typesig { [Array.typed(Certificate)] }
    # Validate Certificate Chain
    def validate_chain(cert_chain)
      i = 0
      while i < cert_chain.attr_length - 1
        issuer_dn = (cert_chain[i]).get_issuer_x500principal
        subject_dn = (cert_chain[i + 1]).get_subject_x500principal
        if (!((issuer_dn == subject_dn)))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    # Create PKCS#12 Attributes, friendlyName and localKeyId.
    # 
    # Although attributes are optional, they could be required.
    # For e.g. localKeyId attribute is required to match the
    # private key with the associated end-entity certificate.
    # 
    # PKCS8ShroudedKeyBags include unique localKeyID and friendlyName.
    # CertBags may or may not include attributes depending on the type
    # of Certificate. In end-entity certificates, localKeyID should be
    # unique, and the corresponding private key should have the same
    # localKeyID. For trusted CA certs in the cert-chain, localKeyID
    # attribute is not required, hence most vendors don't include it.
    # NSS/Netscape require it to be unique or null, where as IE/OpenSSL
    # ignore it.
    # 
    # Here is a list of pkcs12 attribute values in CertBags.
    # 
    # PKCS12 Attribute       NSS/Netscape    IE     OpenSSL    J2SE
    # --------------------------------------------------------------
    # LocalKeyId
    # (In EE cert only,
    # NULL in CA certs)      true          true     true      true
    # 
    # friendlyName            unique        same/    same/     unique
    # unique   unique/
    # null
    # 
    # Note: OpenSSL adds friendlyName for end-entity cert only, and
    # removes the localKeyID and friendlyName for CA certs.
    # If the CertBag did not have a friendlyName, most vendors will
    # add it, and assign it to the DN of the cert.
    def get_bag_attributes(alias_, key_id)
      local_key_id = nil
      friendly_name = nil
      # return null if both attributes are null
      if (((alias_).nil?) && ((key_id).nil?))
        return nil
      end
      # SafeBag Attributes
      bag_attrs = DerOutputStream.new
      # Encode the friendlyname oid.
      if (!(alias_).nil?)
        bag_attr1 = DerOutputStream.new
        bag_attr1.put_oid(self.attr_pkcs9friendly_name_oid)
        bag_attr_content1 = DerOutputStream.new
        bag_attr_value1 = DerOutputStream.new
        bag_attr_content1.put_bmpstring(alias_)
        bag_attr1.write(DerValue.attr_tag_set, bag_attr_content1)
        bag_attr_value1.write(DerValue.attr_tag_sequence, bag_attr1)
        friendly_name = bag_attr_value1.to_byte_array
      end
      # Encode the localkeyId oid.
      if (!(key_id).nil?)
        bag_attr2 = DerOutputStream.new
        bag_attr2.put_oid(self.attr_pkcs9local_key_id_oid)
        bag_attr_content2 = DerOutputStream.new
        bag_attr_value2 = DerOutputStream.new
        bag_attr_content2.put_octet_string(key_id)
        bag_attr2.write(DerValue.attr_tag_set, bag_attr_content2)
        bag_attr_value2.write(DerValue.attr_tag_sequence, bag_attr2)
        local_key_id = bag_attr_value2.to_byte_array
      end
      attrs = DerOutputStream.new
      if (!(friendly_name).nil?)
        attrs.write(friendly_name)
      end
      if (!(local_key_id).nil?)
        attrs.write(local_key_id)
      end
      bag_attrs.write(DerValue.attr_tag_set, attrs)
      return bag_attrs.to_byte_array
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Create EncryptedData content type, that contains EncryptedContentInfo.
    # Includes certificates in individual SafeBags of type CertBag.
    # Each CertBag may include pkcs12 attributes
    # (see comments in getBagAttributes)
    def create_encrypted_data(password)
      out = DerOutputStream.new
      e = @entries.keys
      while e.has_more_elements
        alias_ = e.next_element
        entry = @entries.get(alias_)
        # certificate chain
        chain_len = 0
        if ((entry.attr_chain).nil?)
          chain_len = 0
        else
          chain_len = entry.attr_chain.attr_length
        end
        i = 0
        while i < chain_len
          # create SafeBag of Type CertBag
          safe_bag = DerOutputStream.new
          safe_bag.put_oid(self.attr_cert_bag_oid)
          # create a CertBag
          cert_bag = DerOutputStream.new
          cert_bag.put_oid(self.attr_pkcs9cert_type_oid)
          # write encoded certs in a context-specific tag
          cert_value = DerOutputStream.new
          cert = entry.attr_chain[i]
          cert_value.put_octet_string(cert.get_encoded)
          cert_bag.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0), cert_value)
          # wrap CertBag in a Sequence
          certout = DerOutputStream.new
          certout.write(DerValue.attr_tag_sequence, cert_bag)
          cert_bag_value = certout.to_byte_array
          # Wrap the CertBag encoding in a context-specific tag.
          bag_value = DerOutputStream.new
          bag_value.write(cert_bag_value)
          # write SafeBag Value
          safe_bag.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0), bag_value)
          # write SafeBag Attributes
          # All Certs should have a unique friendlyName.
          # This change is made to meet NSS requirements.
          bag_attrs = nil
          friendly_name = cert.get_subject_x500principal.get_name
          if ((i).equal?(0))
            # Only End-Entity Cert should have a localKeyId.
            bag_attrs = get_bag_attributes(friendly_name, entry.attr_key_id)
          else
            # Trusted root CA certs and Intermediate CA certs do not
            # need to have a localKeyId, and hence localKeyId is null
            # This change is made to meet NSS/Netscape requirements.
            # NSS pkcs12 library requires trusted CA certs in the
            # certificate chain to have unique or null localKeyID.
            # However, IE/OpenSSL do not impose this restriction.
            bag_attrs = get_bag_attributes(friendly_name, nil)
          end
          if (!(bag_attrs).nil?)
            safe_bag.write(bag_attrs)
          end
          # wrap as Sequence
          out.write(DerValue.attr_tag_sequence, safe_bag)
          i += 1
        end # for cert-chain
      end
      # wrap as SequenceOf SafeBag
      safe_bag_value = DerOutputStream.new
      safe_bag_value.write(DerValue.attr_tag_sequence_of, out)
      safe_bag_data = safe_bag_value.to_byte_array
      # encrypt the content (EncryptedContentInfo)
      encr_content_info = encrypt_content(safe_bag_data, password)
      # -- SEQUENCE of EncryptedData
      encr_data = DerOutputStream.new
      encr_data_content = DerOutputStream.new
      encr_data.put_integer(0)
      encr_data.write(encr_content_info)
      encr_data_content.write(DerValue.attr_tag_sequence, encr_data)
      return encr_data_content.to_byte_array
    end
    
    typesig { [] }
    # Create SafeContent Data content type.
    # Includes encrypted private key in a SafeBag of type PKCS8ShroudedKeyBag.
    # Each PKCS8ShroudedKeyBag includes pkcs12 attributes
    # (see comments in getBagAttributes)
    def create_safe_content
      out = DerOutputStream.new
      e = @entries.keys
      while e.has_more_elements
        alias_ = e.next_element
        entry = @entries.get(alias_)
        # Create SafeBag of type pkcs8ShroudedKeyBag
        safe_bag = DerOutputStream.new
        safe_bag.put_oid(self.attr_pkcs8shrouded_key_bag_oid)
        # get the encrypted private key
        encr_bytes = entry.attr_protected_priv_key
        encr_info = nil
        begin
          encr_info = EncryptedPrivateKeyInfo.new(encr_bytes)
        rescue IOException => ioe
          raise IOException.new("Private key not stored as " + "PKCS#8 EncryptedPrivateKeyInfo" + (ioe.get_message).to_s)
        end
        # Wrap the EncryptedPrivateKeyInfo in a context-specific tag.
        bag_value = DerOutputStream.new
        bag_value.write(encr_info.get_encoded)
        safe_bag.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0), bag_value)
        # write SafeBag Attributes
        bag_attrs = get_bag_attributes(alias_, entry.attr_key_id)
        safe_bag.write(bag_attrs)
        # wrap as Sequence
        out.write(DerValue.attr_tag_sequence, safe_bag)
      end
      # wrap as Sequence
      safe_bag_value = DerOutputStream.new
      safe_bag_value.write(DerValue.attr_tag_sequence, out)
      return safe_bag_value.to_byte_array
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Char)] }
    # Encrypt the contents using Password-based (PBE) encryption
    # as defined in PKCS #5.
    # 
    # NOTE: Currently pbeWithSHAAnd40BiteRC2-CBC algorithmID is used
    # to derive the key and IV.
    # 
    # @return encrypted contents encoded as EncryptedContentInfo
    def encrypt_content(data, password)
      encrypted_data = nil
      # create AlgorithmParameters
      alg_params = get_algorithm_parameters("PBEWithSHA1AndRC2_40")
      bytes = DerOutputStream.new
      alg_id = AlgorithmId.new(self.attr_pbe_with_shaand40bit_rc2cbc_oid, alg_params)
      alg_id.encode(bytes)
      encoded_alg_id = bytes.to_byte_array
      begin
        # Use JCE
        skey = get_pbekey(password)
        cipher = Cipher.get_instance("PBEWithSHA1AndRC2_40")
        cipher.init(Cipher::ENCRYPT_MODE, skey, alg_params)
        encrypted_data = cipher.do_final(data)
      rescue Exception => e
        ioe = IOException.new("Failed to encrypt" + " safe contents entry: " + (e).to_s)
        ioe.init_cause(e)
        raise ioe
      end
      # create EncryptedContentInfo
      bytes2 = DerOutputStream.new
      bytes2.put_oid(ContentInfo::DATA_OID)
      bytes2.write(encoded_alg_id)
      # Wrap encrypted data in a context-specific tag.
      tmpout2 = DerOutputStream.new
      tmpout2.put_octet_string(encrypted_data)
      bytes2.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, 0), tmpout2)
      # wrap EncryptedContentInfo in a Sequence
      out = DerOutputStream.new
      out.write(DerValue.attr_tag_sequence, bytes2)
      return out.to_byte_array
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
      synchronized(self) do
        dis = nil
        cf = nil
        bais = nil
        encoded = nil
        if ((stream).nil?)
          return
        end
        # reset the counter
        @counter = 0
        val = DerValue.new(stream)
        s = val.to_der_input_stream
        version = s.get_integer
        if (!(version).equal?(VERSION_3))
          raise IOException.new("PKCS12 keystore not in version 3 format")
        end
        @entries.clear
        # Read the authSafe.
        auth_safe_data = nil
        auth_safe = ContentInfo.new(s)
        content_type = auth_safe.get_content_type
        if ((content_type == ContentInfo::DATA_OID))
          auth_safe_data = auth_safe.get_data
        else
          # signed data
          raise IOException.new("public key protected PKCS12 not supported")
        end
        as = DerInputStream.new(auth_safe_data)
        safe_contents_array = as.get_sequence(2)
        count = safe_contents_array.attr_length
        # reset the count at the start
        @private_key_count = 0
        # Spin over the ContentInfos.
        i = 0
        while i < count
          safe_contents_data = nil
          safe_contents = nil
          sci = nil
          e_alg_id = nil
          sci = DerInputStream.new(safe_contents_array[i].to_byte_array)
          safe_contents = ContentInfo.new(sci)
          content_type = safe_contents.get_content_type
          safe_contents_data = nil
          if ((content_type == ContentInfo::DATA_OID))
            safe_contents_data = safe_contents.get_data
          else
            if ((content_type == ContentInfo::ENCRYPTED_DATA_OID))
              if ((password).nil?)
                i += 1
                next
              end
              edi = safe_contents.get_content.to_der_input_stream
              ed_version = edi.get_integer
              seq = edi.get_sequence(2)
              ed_content_type = seq[0].get_oid
              e_alg_id = seq[1].to_byte_array
              if (!seq[2].is_context_specific(0))
                raise IOException.new("encrypted content not present!")
              end
              new_tag = DerValue.attr_tag_octet_string
              if (seq[2].is_constructed)
                new_tag |= 0x20
              end
              seq[2].reset_tag(new_tag)
              safe_contents_data = seq[2].get_octet_string
              # parse Algorithm parameters
              in_ = seq[1].to_der_input_stream
              alg_oid = in_.get_oid
              alg_params = parse_alg_parameters(in_)
              begin
                # Use JCE
                skey = get_pbekey(password)
                cipher = Cipher.get_instance(alg_oid.to_s)
                cipher.init(Cipher::DECRYPT_MODE, skey, alg_params)
                safe_contents_data = cipher.do_final(safe_contents_data)
              rescue Exception => e
                ioe = IOException.new("failed to decrypt safe" + " contents entry: " + (e).to_s)
                ioe.init_cause(e)
                raise ioe
              end
            else
              raise IOException.new("public key protected PKCS12" + " not supported")
            end
          end
          sc = DerInputStream.new(safe_contents_data)
          load_safe_contents(sc, password)
          i += 1
        end
        # The MacData is optional.
        if (!(password).nil? && s.available > 0)
          mac_data = MacData.new(s)
          begin
            alg_name = mac_data.get_digest_alg_name.to_upper_case
            if ((alg_name == "SHA") || (alg_name == "SHA1") || (alg_name == "SHA-1"))
              alg_name = "SHA1"
            end
            # generate MAC (MAC key is created within JCE)
            m = Mac.get_instance("HmacPBE" + alg_name)
            params = PBEParameterSpec.new(mac_data.get_salt, mac_data.get_iterations)
            key = get_pbekey(password)
            m.init(key, params)
            m.update(auth_safe_data)
            mac_result = m.do_final
            if (!(Arrays == mac_data.get_digest))
              raise SecurityException.new("Failed PKCS12" + " integrity checking")
            end
          rescue Exception => e
            ioe = IOException.new("Integrity check failed: " + (e).to_s)
            ioe.init_cause(e)
            raise ioe
          end
        end
        # Match up private keys with certificate chains.
        list = @key_list.to_array(Array.typed(KeyEntry).new(@key_list.size) { nil })
        m = 0
        while m < list.attr_length
          entry = list[m]
          if (!(entry.attr_key_id).nil?)
            chain = ArrayList.new
            cert = @certs.get(KeyId.new(entry.attr_key_id))
            while (!(cert).nil?)
              chain.add(cert)
              issuer_dn = cert.get_issuer_x500principal
              if ((issuer_dn == cert.get_subject_x500principal))
                break
              end
              cert = @certs.get(issuer_dn)
            end
            # Update existing KeyEntry in entries table
            if (chain.size > 0)
              entry.attr_chain = chain.to_array(Array.typed(Certificate).new(chain.size) { nil })
            end
          end
          m += 1
        end
        @certs.clear
        @key_list.clear
      end
    end
    
    typesig { [DerInputStream, Array.typed(::Java::Char)] }
    def load_safe_contents(stream, password)
      safe_bags = stream.get_sequence(2)
      count = safe_bags.attr_length
      # Spin over the SafeBags.
      i = 0
      while i < count
        bag_id = nil
        sbi = nil
        bag_value = nil
        bag_item = nil
        sbi = safe_bags[i].to_der_input_stream
        bag_id = sbi.get_oid
        bag_value = sbi.get_der_value
        if (!bag_value.is_context_specific(0))
          raise IOException.new("unsupported PKCS12 bag value type " + (bag_value.attr_tag).to_s)
        end
        bag_value = bag_value.attr_data.get_der_value
        if ((bag_id == self.attr_pkcs8shrouded_key_bag_oid))
          k_entry = KeyEntry.new
          k_entry.attr_protected_priv_key = bag_value.to_byte_array
          bag_item = k_entry
          @private_key_count += 1
        else
          if ((bag_id == self.attr_cert_bag_oid))
            cs = DerInputStream.new(bag_value.to_byte_array)
            cert_values = cs.get_sequence(2)
            cert_id = cert_values[0].get_oid
            if (!cert_values[1].is_context_specific(0))
              raise IOException.new("unsupported PKCS12 cert value type " + (cert_values[1].attr_tag).to_s)
            end
            cert_value = cert_values[1].attr_data.get_der_value
            cf = CertificateFactory.get_instance("X509")
            cert = nil
            cert = cf.generate_certificate(ByteArrayInputStream.new(cert_value.get_octet_string))
            bag_item = cert
          else
            # log error message for "unsupported PKCS12 bag type"
          end
        end
        attr_set = nil
        begin
          attr_set = sbi.get_set(2)
        rescue IOException => e
          # entry does not have attributes
          # Note: CA certs can have no attributes
          # OpenSSL generates pkcs12 with no attr for CA certs.
          attr_set = nil
        end
        alias_ = nil
        key_id = nil
        if (!(attr_set).nil?)
          j = 0
          while j < attr_set.attr_length
            as = DerInputStream.new(attr_set[j].to_byte_array)
            attr_seq = as.get_sequence(2)
            attr_id = attr_seq[0].get_oid
            vs = DerInputStream.new(attr_seq[1].to_byte_array)
            val_set = nil
            begin
              val_set = vs.get_set(1)
            rescue IOException => e
              raise IOException.new("Attribute " + (attr_id).to_s + " should have a value " + (e.get_message).to_s)
            end
            if ((attr_id == self.attr_pkcs9friendly_name_oid))
              alias_ = (val_set[0].get_bmpstring).to_s
            else
              if ((attr_id == self.attr_pkcs9local_key_id_oid))
                key_id = val_set[0].get_octet_string
              else
                # log error message for "unknown attr"
              end
            end
            j += 1
          end
        end
        # As per PKCS12 v1.0 friendlyname (alias) and localKeyId (keyId)
        # are optional PKCS12 bagAttributes. But entries in the keyStore
        # are identified by their alias. Hence we need to have an
        # Unfriendlyname in the alias, if alias is null. The keyId
        # attribute is required to match the private key with the
        # certificate. If we get a bagItem of type KeyEntry with a
        # null keyId, we should skip it entirely.
        if (bag_item.is_a?(KeyEntry))
          entry = bag_item
          if ((key_id).nil?)
            # Insert a localKeyID for the privateKey
            # Note: This is a workaround to allow null localKeyID
            # attribute in pkcs12 with one private key entry and
            # associated cert-chain
            if ((@private_key_count).equal?(1))
              key_id = "01".get_bytes("UTF8")
            else
              i += 1
              next
            end
          end
          entry.attr_key_id = key_id
          # restore date if it exists
          key_id_str = String.new(key_id, "UTF8")
          date = nil
          if (key_id_str.starts_with("Time "))
            begin
              date = Date.new(Long.parse_long(key_id_str.substring(5)))
            rescue Exception => e
              date = nil
            end
          end
          if ((date).nil?)
            date = Date.new
          end
          entry.attr_date = date
          @key_list.add(entry)
          if ((alias_).nil?)
            alias_ = (get_unfriendly_name).to_s
          end
          entry.attr_alias = alias_
          @entries.put(alias_.to_lower_case, entry)
        else
          if (bag_item.is_a?(X509Certificate))
            cert = bag_item
            # Insert a localKeyID for the corresponding cert
            # Note: This is a workaround to allow null localKeyID
            # attribute in pkcs12 with one private key entry and
            # associated cert-chain
            if (((key_id).nil?) && ((@private_key_count).equal?(1)))
              # insert localKeyID only for EE cert or self-signed cert
              if ((i).equal?(0))
                key_id = "01".get_bytes("UTF8")
              end
            end
            if (!(key_id).nil?)
              keyid = KeyId.new(key_id)
              if (!@certs.contains_key(keyid))
                @certs.put(keyid, cert)
              end
            end
            if (!(alias_).nil?)
              if (!@certs.contains_key(alias_))
                @certs.put(alias_, cert)
              end
            end
            subject_dn = cert.get_subject_x500principal
            if (!(subject_dn).nil?)
              if (!@certs.contains_key(subject_dn))
                @certs.put(subject_dn, cert)
              end
            end
          end
        end
        i += 1
      end
    end
    
    typesig { [] }
    def get_unfriendly_name
      @counter += 1
      return (String.value_of(@counter))
    end
    
    typesig { [] }
    def initialize
      @counter = 0
      @private_key_count = 0
      @random = nil
      @entries = nil
      @key_list = nil
      @certs = nil
      super()
      @counter = 0
      @private_key_count = 0
      @entries = Hashtable.new
      @key_list = ArrayList.new
      @certs = LinkedHashMap.new
    end
    
    private
    alias_method :initialize__pkcs12key_store, :initialize
  end
  
end
