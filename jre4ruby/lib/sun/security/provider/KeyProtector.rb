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
  module KeyProtectorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Security, :Key
      include_const ::Java::Security, :KeyStoreException
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Security, :UnrecoverableKeyException
      include ::Java::Util
      include_const ::Sun::Security::Pkcs, :PKCS8Key
      include_const ::Sun::Security::Pkcs, :EncryptedPrivateKeyInfo
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Security::Util, :DerValue
    }
  end
  
  # This is an implementation of a Sun proprietary, exportable algorithm
  # intended for use when protecting (or recovering the cleartext version of)
  # sensitive keys.
  # This algorithm is not intended as a general purpose cipher.
  # 
  # This is how the algorithm works for key protection:
  # 
  # p - user password
  # s - random salt
  # X - xor key
  # P - to-be-protected key
  # Y - protected key
  # R - what gets stored in the keystore
  # 
  # Step 1:
  # Take the user's password, append a random salt (of fixed size) to it,
  # and hash it: d1 = digest(p, s)
  # Store d1 in X.
  # 
  # Step 2:
  # Take the user's password, append the digest result from the previous step,
  # and hash it: dn = digest(p, dn-1).
  # Store dn in X (append it to the previously stored digests).
  # Repeat this step until the length of X matches the length of the private key
  # P.
  # 
  # Step 3:
  # XOR X and P, and store the result in Y: Y = X XOR P.
  # 
  # Step 4:
  # Store s, Y, and digest(p, P) in the result buffer R:
  # R = s + Y + digest(p, P), where "+" denotes concatenation.
  # (NOTE: digest(p, P) is stored in the result buffer, so that when the key is
  # recovered, we can check if the recovered key indeed matches the original
  # key.) R is stored in the keystore.
  # 
  # The protected key is recovered as follows:
  # 
  # Step1 and Step2 are the same as above, except that the salt is not randomly
  # generated, but taken from the result R of step 4 (the first length(s)
  # bytes).
  # 
  # Step 3 (XOR operation) yields the plaintext key.
  # 
  # Then concatenate the password with the recovered key, and compare with the
  # last length(digest(p, P)) bytes of R. If they match, the recovered key is
  # indeed the same key as the original key.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.KeyStore
  # @see JavaKeyStore
  # @see KeyTool
  # 
  # @since 1.2
  class KeyProtector 
    include_class_members KeyProtectorImports
    
    class_module.module_eval {
      const_set_lazy(:SALT_LEN) { 20 }
      const_attr_reader  :SALT_LEN
      
      # the salt length
      const_set_lazy(:DIGEST_ALG) { "SHA" }
      const_attr_reader  :DIGEST_ALG
      
      const_set_lazy(:DIGEST_LEN) { 20 }
      const_attr_reader  :DIGEST_LEN
      
      # defined by JavaSoft
      const_set_lazy(:KEY_PROTECTOR_OID) { "1.3.6.1.4.1.42.2.17.1.1" }
      const_attr_reader  :KEY_PROTECTOR_OID
    }
    
    # The password used for protecting/recovering keys passed through this
    # key protector. We store it as a byte array, so that we can digest it.
    attr_accessor :passwd_bytes
    alias_method :attr_passwd_bytes, :passwd_bytes
    undef_method :passwd_bytes
    alias_method :attr_passwd_bytes=, :passwd_bytes=
    undef_method :passwd_bytes=
    
    attr_accessor :md
    alias_method :attr_md, :md
    undef_method :md
    alias_method :attr_md=, :md=
    undef_method :md=
    
    typesig { [Array.typed(::Java::Char)] }
    # Creates an instance of this class, and initializes it with the given
    # password.
    # 
    # <p>The password is expected to be in printable ASCII.
    # Normal rules for good password selection apply: at least
    # seven characters, mixed case, with punctuation encouraged.
    # Phrases or words which are easily guessed, for example by
    # being found in dictionaries, are bad.
    def initialize(password)
      @passwd_bytes = nil
      @md = nil
      i = 0
      j = 0
      if ((password).nil?)
        raise IllegalArgumentException.new("password can't be null")
      end
      @md = MessageDigest.get_instance(DIGEST_ALG)
      # Convert password to byte array, so that it can be digested
      @passwd_bytes = Array.typed(::Java::Byte).new(password.attr_length * 2) { 0 }
      i = 0
      j = 0
      while i < password.attr_length
        @passwd_bytes[((j += 1) - 1)] = (password[i] >> 8)
        @passwd_bytes[((j += 1) - 1)] = password[i]
        ((i += 1) - 1)
      end
    end
    
    typesig { [] }
    # Ensures that the password bytes of this key protector are
    # set to zero when there are no more references to it.
    def finalize
      if (!(@passwd_bytes).nil?)
        Arrays.fill(@passwd_bytes, 0x0)
        @passwd_bytes = nil
      end
    end
    
    typesig { [Key] }
    # Protects the given plaintext key, using the password provided at
    # construction time.
    def protect(key)
      i = 0
      num_rounds = 0
      digest = nil
      xor_offset = 0 # offset in xorKey where next digest will be stored
      encr_key_offset = 0
      if ((key).nil?)
        raise IllegalArgumentException.new("plaintext key can't be null")
      end
      if (!"PKCS#8".equals_ignore_case(key.get_format))
        raise KeyStoreException.new("Cannot get key bytes, not PKCS#8 encoded")
      end
      plain_key = key.get_encoded
      if ((plain_key).nil?)
        raise KeyStoreException.new("Cannot get key bytes, encoding not supported")
      end
      # Determine the number of digest rounds
      num_rounds = plain_key.attr_length / DIGEST_LEN
      if (!((plain_key.attr_length % DIGEST_LEN)).equal?(0))
        ((num_rounds += 1) - 1)
      end
      # Create a random salt
      salt = Array.typed(::Java::Byte).new(SALT_LEN) { 0 }
      random = SecureRandom.new
      random.next_bytes(salt)
      # Set up the byte array which will be XORed with "plainKey"
      xor_key = Array.typed(::Java::Byte).new(plain_key.attr_length) { 0 }
      # Compute the digests, and store them in "xorKey"
      i = 0
      xor_offset = 0
      digest = salt
      while i < num_rounds
        @md.update(@passwd_bytes)
        @md.update(digest)
        digest = @md.digest
        @md.reset
        # Copy the digest into "xorKey"
        if (i < num_rounds - 1)
          System.arraycopy(digest, 0, xor_key, xor_offset, digest.attr_length)
        else
          System.arraycopy(digest, 0, xor_key, xor_offset, xor_key.attr_length - xor_offset)
        end
        ((i += 1) - 1)
        xor_offset += DIGEST_LEN
      end
      # XOR "plainKey" with "xorKey", and store the result in "tmpKey"
      tmp_key = Array.typed(::Java::Byte).new(plain_key.attr_length) { 0 }
      i = 0
      while i < tmp_key.attr_length
        tmp_key[i] = (plain_key[i] ^ xor_key[i])
        ((i += 1) - 1)
      end
      # Store salt and "tmpKey" in "encrKey"
      encr_key = Array.typed(::Java::Byte).new(salt.attr_length + tmp_key.attr_length + DIGEST_LEN) { 0 }
      System.arraycopy(salt, 0, encr_key, encr_key_offset, salt.attr_length)
      encr_key_offset += salt.attr_length
      System.arraycopy(tmp_key, 0, encr_key, encr_key_offset, tmp_key.attr_length)
      encr_key_offset += tmp_key.attr_length
      # Append digest(password, plainKey) as an integrity check to "encrKey"
      @md.update(@passwd_bytes)
      Arrays.fill(@passwd_bytes, 0x0)
      @passwd_bytes = nil
      @md.update(plain_key)
      digest = @md.digest
      @md.reset
      System.arraycopy(digest, 0, encr_key, encr_key_offset, digest.attr_length)
      # wrap the protected private key in a PKCS#8-style
      # EncryptedPrivateKeyInfo, and returns its encoding
      encr_alg = nil
      begin
        encr_alg = AlgorithmId.new(ObjectIdentifier.new(KEY_PROTECTOR_OID))
        return EncryptedPrivateKeyInfo.new(encr_alg, encr_key).get_encoded
      rescue IOException => ioe
        raise KeyStoreException.new(ioe.get_message)
      end
    end
    
    typesig { [EncryptedPrivateKeyInfo] }
    # Recovers the plaintext version of the given key (in protected format),
    # using the password provided at construction time.
    def recover(encr_info)
      i = 0
      digest_ = nil
      num_rounds = 0
      xor_offset = 0 # offset in xorKey where next digest will be stored
      encr_key_len = 0 # the length of the encrpyted key
      # do we support the algorithm?
      encr_alg = encr_info.get_algorithm
      if (!((encr_alg.get_oid.to_s == KEY_PROTECTOR_OID)))
        raise UnrecoverableKeyException.new("Unsupported key protection " + "algorithm")
      end
      protected_key = encr_info.get_encrypted_data
      # Get the salt associated with this key (the first SALT_LEN bytes of
      # <code>protectedKey</code>)
      salt = Array.typed(::Java::Byte).new(SALT_LEN) { 0 }
      System.arraycopy(protected_key, 0, salt, 0, SALT_LEN)
      # Determine the number of digest rounds
      encr_key_len = protected_key.attr_length - SALT_LEN - DIGEST_LEN
      num_rounds = encr_key_len / DIGEST_LEN
      if (!((encr_key_len % DIGEST_LEN)).equal?(0))
        ((num_rounds += 1) - 1)
      end
      # Get the encrypted key portion and store it in "encrKey"
      encr_key = Array.typed(::Java::Byte).new(encr_key_len) { 0 }
      System.arraycopy(protected_key, SALT_LEN, encr_key, 0, encr_key_len)
      # Set up the byte array which will be XORed with "encrKey"
      xor_key = Array.typed(::Java::Byte).new(encr_key.attr_length) { 0 }
      # Compute the digests, and store them in "xorKey"
      i = 0
      xor_offset = 0
      digest_ = salt
      while i < num_rounds
        @md.update(@passwd_bytes)
        @md.update(digest_)
        digest_ = @md.digest
        @md.reset
        # Copy the digest into "xorKey"
        if (i < num_rounds - 1)
          System.arraycopy(digest_, 0, xor_key, xor_offset, digest_.attr_length)
        else
          System.arraycopy(digest_, 0, xor_key, xor_offset, xor_key.attr_length - xor_offset)
        end
        ((i += 1) - 1)
        xor_offset += DIGEST_LEN
      end
      # XOR "encrKey" with "xorKey", and store the result in "plainKey"
      plain_key = Array.typed(::Java::Byte).new(encr_key.attr_length) { 0 }
      i = 0
      while i < plain_key.attr_length
        plain_key[i] = (encr_key[i] ^ xor_key[i])
        ((i += 1) - 1)
      end
      # Check the integrity of the recovered key by concatenating it with
      # the password, digesting the concatenation, and comparing the
      # result of the digest operation with the digest provided at the end
      # of <code>protectedKey</code>. If the two digest values are
      # different, throw an exception.
      @md.update(@passwd_bytes)
      Arrays.fill(@passwd_bytes, 0x0)
      @passwd_bytes = nil
      @md.update(plain_key)
      digest_ = @md.digest
      @md.reset
      i = 0
      while i < digest_.attr_length
        if (!(digest_[i]).equal?(protected_key[SALT_LEN + encr_key_len + i]))
          raise UnrecoverableKeyException.new("Cannot recover key")
        end
        ((i += 1) - 1)
      end
      # The parseKey() method of PKCS8Key parses the key
      # algorithm and instantiates the appropriate key factory,
      # which in turn parses the key material.
      begin
        return PKCS8Key.parse_key(DerValue.new(plain_key))
      rescue IOException => ioe
        raise UnrecoverableKeyException.new(ioe.get_message)
      end
    end
    
    private
    alias_method :initialize__key_protector, :initialize
  end
  
end
