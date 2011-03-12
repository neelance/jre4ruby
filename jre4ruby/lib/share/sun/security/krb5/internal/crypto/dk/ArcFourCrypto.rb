require "rjava"

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
module Sun::Security::Krb5::Internal::Crypto::Dk
  module ArcFourCryptoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto::Dk
      include ::Java::Security
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include ::Java::Util
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Sun::Security::Krb5, :Confounder
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
    }
  end
  
  # Support for ArcFour in Kerberos
  # as defined in RFC 4757.
  # http://www.ietf.org/rfc/rfc4757.txt
  # 
  # @author Seema Malkani
  class ArcFourCrypto < ArcFourCryptoImports.const_get :DkCrypto
    include_class_members ArcFourCryptoImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
      
      const_set_lazy(:ConfounderSize) { 8 }
      const_attr_reader  :ConfounderSize
      
      const_set_lazy(:ZERO_IV) { Array.typed(::Java::Byte).new([0, 0, 0, 0, 0, 0, 0, 0]) }
      const_attr_reader  :ZERO_IV
      
      const_set_lazy(:HashSize) { 16 }
      const_attr_reader  :HashSize
    }
    
    attr_accessor :key_length
    alias_method :attr_key_length, :key_length
    undef_method :key_length
    alias_method :attr_key_length=, :key_length=
    undef_method :key_length=
    
    typesig { [::Java::Int] }
    def initialize(length)
      @key_length = 0
      super()
      @key_length = length
    end
    
    typesig { [] }
    def get_key_seed_length
      return @key_length # bits; RC4 key material
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def random_to_key(in_)
      # simple identity operation
      return in_
    end
    
    typesig { [Array.typed(::Java::Char)] }
    def string_to_key(passwd)
      return string_to_key(passwd, nil)
    end
    
    typesig { [Array.typed(::Java::Char), Array.typed(::Java::Byte)] }
    # String2Key(Password)
    # K = MD4(UNICODE(password))
    def string_to_key(secret, opaque)
      if (!(opaque).nil? && opaque.attr_length > 0)
        raise RuntimeException.new("Invalid parameter to stringToKey")
      end
      passwd = nil
      digest = nil
      begin
        # convert ascii to unicode
        passwd = char_to_utf16(secret)
        # provider for MD4
        md = Sun::Security::Provider::MD4.get_instance
        md.update(passwd)
        digest = md.digest
      rescue JavaException => e
        return nil
      ensure
        if (!(passwd).nil?)
          Arrays.fill(passwd, 0)
        end
      end
      return digest
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def get_cipher(key, ivec, mode)
      # IV
      if ((ivec).nil?)
        ivec = ZERO_IV
      end
      secret_key = SecretKeySpec.new(key, "ARCFOUR")
      cipher = Cipher.get_instance("ARCFOUR")
      enc_iv = IvParameterSpec.new(ivec, 0, ivec.attr_length)
      cipher.init(mode, secret_key, enc_iv)
      return cipher
    end
    
    typesig { [] }
    def get_checksum_length
      return HashSize # bytes
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Get the HMAC-MD5
    def get_hmac(key, msg)
      key_ki = SecretKeySpec.new(key, "HmacMD5")
      m = Mac.get_instance("HmacMD5")
      m.init(key_ki)
      # generate hash
      hash = m.do_final(msg)
      return hash
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Calculate the checksum
    def calculate_checksum(base_key, usage, input, start, len)
      if (Debug)
        System.out.println("ARCFOUR: calculateChecksum with usage = " + RJava.cast_to_string(usage))
      end
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      ksign = nil
      # Derive signing key from session key
      begin
        ss = "signaturekey".get_bytes
        # need to append end-of-string 00
        new_ss = Array.typed(::Java::Byte).new(ss.attr_length + 1) { 0 }
        System.arraycopy(ss, 0, new_ss, 0, ss.attr_length)
        ksign = get_hmac(base_key, new_ss)
      rescue JavaException => e
        gse = GeneralSecurityException.new("Calculate Checkum Failed!")
        gse.init_cause(e)
        raise gse
      end
      # get the salt using key usage
      salt = get_salt(usage)
      # Generate checksum of message
      message_digest = nil
      begin
        message_digest = MessageDigest.get_instance("MD5")
      rescue NoSuchAlgorithmException => e
        gse = GeneralSecurityException.new("Calculate Checkum Failed!")
        gse.init_cause(e)
        raise gse
      end
      message_digest.update(salt)
      message_digest.update(input, start, len)
      md5tmp = message_digest.digest
      # Generate checksum
      hmac = get_hmac(ksign, md5tmp)
      if (Debug)
        trace_output("hmac", hmac, 0, hmac.attr_length)
      end
      if ((hmac.attr_length).equal?(get_checksum_length))
        return hmac
      else
        if (hmac.attr_length > get_checksum_length)
          buf = Array.typed(::Java::Byte).new(get_checksum_length) { 0 }
          System.arraycopy(hmac, 0, buf, 0, buf.attr_length)
          return buf
        else
          raise GeneralSecurityException.new("checksum size too short: " + RJava.cast_to_string(hmac.attr_length) + "; expecting : " + RJava.cast_to_string(get_checksum_length))
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Performs encryption of Sequence Number using derived key.
    def encrypt_seq(base_key, usage, checksum, plaintext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      # derive encryption for sequence number
      salt = Array.typed(::Java::Byte).new(4) { 0 }
      k_seq = get_hmac(base_key, salt)
      # derive new encryption key salted with sequence number
      k_seq = get_hmac(k_seq, checksum)
      cipher = Cipher.get_instance("ARCFOUR")
      secret_key = SecretKeySpec.new(k_seq, "ARCFOUR")
      cipher.init(Cipher::ENCRYPT_MODE, secret_key)
      output = cipher.do_final(plaintext, start, len)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Performs decryption of Sequence Number using derived key.
    def decrypt_seq(base_key, usage, checksum, ciphertext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      # derive decryption for sequence number
      salt = Array.typed(::Java::Byte).new(4) { 0 }
      k_seq = get_hmac(base_key, salt)
      # derive new encryption key salted with sequence number
      k_seq = get_hmac(k_seq, checksum)
      cipher = Cipher.get_instance("ARCFOUR")
      secret_key = SecretKeySpec.new(k_seq, "ARCFOUR")
      cipher.init(Cipher::DECRYPT_MODE, secret_key)
      output = cipher.do_final(ciphertext, start, len)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Performs encryption using derived key; adds confounder.
    def encrypt(base_key, usage, ivec, new_ivec, plaintext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      if (Debug)
        System.out.println("ArcFour: ENCRYPT with key usage = " + RJava.cast_to_string(usage))
      end
      # get the confounder
      confounder = Confounder.bytes(ConfounderSize)
      # add confounder to the plaintext for encryption
      plain_size = roundup(confounder.attr_length + len, 1)
      to_be_encrypted = Array.typed(::Java::Byte).new(plain_size) { 0 }
      System.arraycopy(confounder, 0, to_be_encrypted, 0, confounder.attr_length)
      System.arraycopy(plaintext, start, to_be_encrypted, confounder.attr_length, len)
      # begin the encryption, compute K1
      k1 = Array.typed(::Java::Byte).new(base_key.attr_length) { 0 }
      System.arraycopy(base_key, 0, k1, 0, base_key.attr_length)
      # get the salt using key usage
      salt = get_salt(usage)
      # compute K2 using K1
      k2 = get_hmac(k1, salt)
      # generate checksum using K2
      checksum = get_hmac(k2, to_be_encrypted)
      # compute K3 using K2 and checksum
      k3 = get_hmac(k2, checksum)
      cipher = Cipher.get_instance("ARCFOUR")
      secret_key = SecretKeySpec.new(k3, "ARCFOUR")
      cipher.init(Cipher::ENCRYPT_MODE, secret_key)
      output = cipher.do_final(to_be_encrypted, 0, to_be_encrypted.attr_length)
      # encryptedData + HMAC
      result = Array.typed(::Java::Byte).new(HashSize + output.attr_length) { 0 }
      System.arraycopy(checksum, 0, result, 0, HashSize)
      System.arraycopy(output, 0, result, HashSize, output.attr_length)
      return result
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Performs encryption using derived key; does not add confounder.
    def encrypt_raw(base_key, usage, seq_num, plaintext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      if (Debug)
        System.out.println("\nARCFOUR: encryptRaw with usage = " + RJava.cast_to_string(usage))
      end
      # Derive encryption key for data
      #   Key derivation salt = 0
      klocal = Array.typed(::Java::Byte).new(base_key.attr_length) { 0 }
      i = 0
      while i <= 15
        klocal[i] = (base_key[i] ^ 0xf0)
        i += 1
      end
      salt = Array.typed(::Java::Byte).new(4) { 0 }
      kcrypt = get_hmac(klocal, salt)
      # Note: When using this RC4 based encryption type, the sequence number
      # is always sent in big-endian rather than little-endian order.
      # new encryption key salted with sequence number
      kcrypt = get_hmac(kcrypt, seq_num)
      cipher = Cipher.get_instance("ARCFOUR")
      secret_key = SecretKeySpec.new(kcrypt, "ARCFOUR")
      cipher.init(Cipher::ENCRYPT_MODE, secret_key)
      output = cipher.do_final(plaintext, start, len)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # @param baseKey key from which keys are to be derived using usage
    # @param ciphertext  E(Ke, conf | plaintext | padding, ivec) | H1[1..h]
    def decrypt(base_key, usage, ivec, ciphertext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      if (Debug)
        System.out.println("\nARCFOUR: DECRYPT using key usage = " + RJava.cast_to_string(usage))
      end
      # compute K1
      k1 = Array.typed(::Java::Byte).new(base_key.attr_length) { 0 }
      System.arraycopy(base_key, 0, k1, 0, base_key.attr_length)
      # get the salt using key usage
      salt = get_salt(usage)
      # compute K2 using K1
      k2 = get_hmac(k1, salt)
      # compute K3 using K2 and checksum
      checksum = Array.typed(::Java::Byte).new(HashSize) { 0 }
      System.arraycopy(ciphertext, start, checksum, 0, HashSize)
      k3 = get_hmac(k2, checksum)
      # Decrypt [confounder | plaintext ] (without checksum)
      cipher = Cipher.get_instance("ARCFOUR")
      secret_key = SecretKeySpec.new(k3, "ARCFOUR")
      cipher.init(Cipher::DECRYPT_MODE, secret_key)
      plaintext = cipher.do_final(ciphertext, start + HashSize, len - HashSize)
      # Verify checksum
      calculated_hmac = get_hmac(k2, plaintext)
      if (Debug)
        trace_output("calculated Hmac", calculated_hmac, 0, calculated_hmac.attr_length)
        trace_output("message Hmac", ciphertext, 0, HashSize)
      end
      cksum_failed = false
      if (calculated_hmac.attr_length >= HashSize)
        i = 0
        while i < HashSize
          if (!(calculated_hmac[i]).equal?(ciphertext[i]))
            cksum_failed = true
            System.err.println("Checksum failed !")
            break
          end
          i += 1
        end
      end
      if (cksum_failed)
        raise GeneralSecurityException.new("Checksum failed")
      end
      # Get rid of confounder
      # [ confounder | plaintext ]
      output = Array.typed(::Java::Byte).new(plaintext.attr_length - ConfounderSize) { 0 }
      System.arraycopy(plaintext, ConfounderSize, output, 0, output.attr_length)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
    # Decrypts data using specified key and initial vector.
    # @param baseKey encryption key to use
    # @param ciphertext  encrypted data to be decrypted
    # @param usage ignored
    def decrypt_raw(base_key, usage, ivec, ciphertext, start, len, seq_num)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      if (Debug)
        System.out.println("\nARCFOUR: decryptRaw with usage = " + RJava.cast_to_string(usage))
      end
      # Derive encryption key for data
      #   Key derivation salt = 0
      klocal = Array.typed(::Java::Byte).new(base_key.attr_length) { 0 }
      i = 0
      while i <= 15
        klocal[i] = (base_key[i] ^ 0xf0)
        i += 1
      end
      salt = Array.typed(::Java::Byte).new(4) { 0 }
      kcrypt = get_hmac(klocal, salt)
      # need only first 4 bytes of sequence number
      sequence_num = Array.typed(::Java::Byte).new(4) { 0 }
      System.arraycopy(seq_num, 0, sequence_num, 0, sequence_num.attr_length)
      # new encryption key salted with sequence number
      kcrypt = get_hmac(kcrypt, sequence_num)
      cipher = Cipher.get_instance("ARCFOUR")
      secret_key = SecretKeySpec.new(kcrypt, "ARCFOUR")
      cipher.init(Cipher::DECRYPT_MODE, secret_key)
      output = cipher.do_final(ciphertext, start, len)
      return output
    end
    
    typesig { [::Java::Int] }
    # get the salt using key usage
    def get_salt(usage)
      ms_usage = arcfour_translate_usage(usage)
      salt = Array.typed(::Java::Byte).new(4) { 0 }
      salt[0] = (ms_usage & 0xff)
      salt[1] = ((ms_usage >> 8) & 0xff)
      salt[2] = ((ms_usage >> 16) & 0xff)
      salt[3] = ((ms_usage >> 24) & 0xff)
      return salt
    end
    
    typesig { [::Java::Int] }
    # Key usage translation for MS
    def arcfour_translate_usage(usage)
      case (usage)
      when 3
        return 8
      when 9
        return 8
      when 23
        return 13
      else
        return usage
      end
    end
    
    private
    alias_method :initialize__arc_four_crypto, :initialize
  end
  
end
