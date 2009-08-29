require "rjava"

# Copyright 2004-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AesDkCryptoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto::Dk
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto, :Mac
      include_const ::Javax::Crypto, :SecretKeyFactory
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include_const ::Javax::Crypto::Spec, :DESedeKeySpec
      include_const ::Javax::Crypto::Spec, :IvParameterSpec
      include_const ::Javax::Crypto::Spec, :PBEKeySpec
      include_const ::Java::Security::Spec, :KeySpec
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Sun::Security::Krb5, :Confounder
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include_const ::Java::Util, :Arrays
    }
  end
  
  # This class provides the implementation of AES Encryption for Kerberos
  # as defined RFC 3962.
  # http://www.ietf.org/rfc/rfc3962.txt
  # 
  # Algorithm profile described in [KCRYPTO]:
  # +--------------------------------------------------------------------+
  # |               protocol key format          128- or 256-bit string  |
  # |                                                                    |
  # |            string-to-key function          PBKDF2+DK with variable |
  # |                                          iteration count (see      |
  # |                                          above)                    |
  # |                                                                    |
  # |  default string-to-key parameters          00 00 10 00             |
  # |                                                                    |
  # |        key-generation seed length          key size                |
  # |                                                                    |
  # |            random-to-key function          identity function       |
  # |                                                                    |
  # |                    hash function, H                SHA-1           |
  # |                                                                    |
  # |               HMAC output size, h          12 octets (96 bits)     |
  # |                                                                    |
  # |             message block size, m          1 octet                 |
  # |                                                                    |
  # |  encryption/decryption functions,          AES in CBC-CTS mode     |
  # |  E and D                                 (cipher block size 16     |
  # |                                          octets), with next to     |
  # |                                          last block as CBC-style   |
  # |                                          ivec                      |
  # +--------------------------------------------------------------------+
  # 
  # Supports AES128 and AES256
  # 
  # @author Seema Malkani
  class AesDkCrypto < AesDkCryptoImports.const_get :DkCrypto
    include_class_members AesDkCryptoImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
      
      const_set_lazy(:BLOCK_SIZE) { 16 }
      const_attr_reader  :BLOCK_SIZE
      
      const_set_lazy(:DEFAULT_ITERATION_COUNT) { 4096 }
      const_attr_reader  :DEFAULT_ITERATION_COUNT
      
      const_set_lazy(:ZERO_IV) { Array.typed(::Java::Byte).new([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]) }
      const_attr_reader  :ZERO_IV
      
      const_set_lazy(:HashSize) { 96 / 8 }
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
      return @key_length # bits; AES key material
    end
    
    typesig { [Array.typed(::Java::Char), String, Array.typed(::Java::Byte)] }
    def string_to_key(password, salt, s2kparams)
      salt_utf8 = nil
      begin
        salt_utf8 = salt.get_bytes("UTF-8")
        return string_to_key(password, salt_utf8, s2kparams)
      rescue JavaException => e
        return nil
      ensure
        if (!(salt_utf8).nil?)
          Arrays.fill(salt_utf8, 0)
        end
      end
    end
    
    typesig { [Array.typed(::Java::Char), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def string_to_key(secret, salt, params)
      iter_count = DEFAULT_ITERATION_COUNT
      if (!(params).nil?)
        if (!(params.attr_length).equal?(4))
          raise RuntimeException.new("Invalid parameter to stringToKey")
        end
        iter_count = read_big_endian(params, 0, 4)
      end
      tmp_key = random_to_key(_pbkdf2(secret, salt, iter_count, get_key_seed_length))
      result = dk(tmp_key, KERBEROS_CONSTANT)
      return result
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def random_to_key(in_)
      # simple identity operation
      return in_
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def get_cipher(key, ivec, mode)
      # IV
      if ((ivec).nil?)
        ivec = ZERO_IV
      end
      secret_key = SecretKeySpec.new(key, "AES")
      cipher = Cipher.get_instance("AES/CBC/NoPadding")
      enc_iv = IvParameterSpec.new(ivec, 0, ivec.attr_length)
      cipher.init(mode, secret_key, enc_iv)
      return cipher
    end
    
    typesig { [] }
    # get an instance of the AES Cipher in CTS mode
    def get_checksum_length
      return HashSize # bytes
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Get the truncated HMAC
    def get_hmac(key, msg)
      key_ki = SecretKeySpec.new(key, "HMAC")
      m = Mac.get_instance("HmacSHA1")
      m.init(key_ki)
      # generate hash
      hash = m.do_final(msg)
      # truncate hash
      output = Array.typed(::Java::Byte).new(HashSize) { 0 }
      System.arraycopy(hash, 0, output, 0, HashSize)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Calculate the checksum
    def calculate_checksum(base_key, usage, input, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      # Derive keys
      constant = Array.typed(::Java::Byte).new(5) { 0 }
      constant[0] = ((usage >> 24) & 0xff)
      constant[1] = ((usage >> 16) & 0xff)
      constant[2] = ((usage >> 8) & 0xff)
      constant[3] = (usage & 0xff)
      constant[4] = 0x99
      kc = dk(base_key, constant) # Checksum key
      if (Debug)
        System.err.println("usage: " + RJava.cast_to_string(usage))
        trace_output("input", input, start, Math.min(len, 32))
        trace_output("constant", constant, 0, constant.attr_length)
        trace_output("baseKey", base_key, 0, base_key.attr_length)
        trace_output("Kc", kc, 0, kc.attr_length)
      end
      begin
        # Generate checksum
        # H1 = HMAC(Kc, input)
        hmac = get_hmac(kc, input)
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
      ensure
        Arrays.fill(kc, 0, kc.attr_length, 0)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Performs encryption using derived key; adds confounder.
    def encrypt(base_key, usage, ivec, new_ivec, plaintext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      output = encrypt_cts(base_key, usage, ivec, new_ivec, plaintext, start, len, true)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Performs encryption using derived key; does not add confounder.
    def encrypt_raw(base_key, usage, ivec, plaintext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      output = encrypt_cts(base_key, usage, ivec, nil, plaintext, start, len, false)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # @param baseKey key from which keys are to be derived using usage
    # @param ciphertext  E(Ke, conf | plaintext | padding, ivec) | H1[1..h]
    def decrypt(base_key, usage, ivec, ciphertext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      output = decrypt_cts(base_key, usage, ivec, ciphertext, start, len, true)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Decrypts data using specified key and initial vector.
    # @param baseKey encryption key to use
    # @param ciphertext  encrypted data to be decrypted
    # @param usage ignored
    def decrypt_raw(base_key, usage, ivec, ciphertext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
      output = decrypt_cts(base_key, usage, ivec, ciphertext, start, len, false)
      return output
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Encrypt AES in CBC-CTS mode using derived keys.
    def encrypt_cts(base_key, usage, ivec, new_ivec, plaintext, start, len, confounder_exists)
      ke = nil
      ki = nil
      if (Debug)
        System.err.println("usage: " + RJava.cast_to_string(usage))
        if (!(ivec).nil?)
          trace_output("old_state.ivec", ivec, 0, ivec.attr_length)
        end
        trace_output("plaintext", plaintext, start, Math.min(len, 32))
        trace_output("baseKey", base_key, 0, base_key.attr_length)
      end
      begin
        # derive Encryption key
        constant = Array.typed(::Java::Byte).new(5) { 0 }
        constant[0] = ((usage >> 24) & 0xff)
        constant[1] = ((usage >> 16) & 0xff)
        constant[2] = ((usage >> 8) & 0xff)
        constant[3] = (usage & 0xff)
        constant[4] = 0xaa
        ke = dk(base_key, constant) # Encryption key
        to_be_encrypted = nil
        if (confounder_exists)
          confounder = Confounder.bytes(BLOCK_SIZE)
          to_be_encrypted = Array.typed(::Java::Byte).new(confounder.attr_length + len) { 0 }
          System.arraycopy(confounder, 0, to_be_encrypted, 0, confounder.attr_length)
          System.arraycopy(plaintext, start, to_be_encrypted, confounder.attr_length, len)
        else
          to_be_encrypted = Array.typed(::Java::Byte).new(len) { 0 }
          System.arraycopy(plaintext, start, to_be_encrypted, 0, len)
        end
        # encryptedData + HMAC
        output = Array.typed(::Java::Byte).new(to_be_encrypted.attr_length + HashSize) { 0 }
        # AES in JCE
        cipher = Cipher.get_instance("AES/CTS/NoPadding")
        secret_key = SecretKeySpec.new(ke, "AES")
        enc_iv = IvParameterSpec.new(ivec, 0, ivec.attr_length)
        cipher.init(Cipher::ENCRYPT_MODE, secret_key, enc_iv)
        cipher.do_final(to_be_encrypted, 0, to_be_encrypted.attr_length, output)
        # Derive integrity key
        constant[4] = 0x55
        ki = dk(base_key, constant)
        if (Debug)
          trace_output("constant", constant, 0, constant.attr_length)
          trace_output("Ki", ki, 0, ke.attr_length)
        end
        # Generate checksum
        # H1 = HMAC(Ki, conf | plaintext | pad)
        hmac = get_hmac(ki, to_be_encrypted)
        # encryptedData + HMAC
        System.arraycopy(hmac, 0, output, to_be_encrypted.attr_length, hmac.attr_length)
        return output
      ensure
        if (!(ke).nil?)
          Arrays.fill(ke, 0, ke.attr_length, 0)
        end
        if (!(ki).nil?)
          Arrays.fill(ki, 0, ki.attr_length, 0)
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Decrypt AES in CBC-CTS mode using derived keys.
    def decrypt_cts(base_key, usage, ivec, ciphertext, start, len, confounder_exists)
      ke = nil
      ki = nil
      begin
        # Derive encryption key
        constant = Array.typed(::Java::Byte).new(5) { 0 }
        constant[0] = ((usage >> 24) & 0xff)
        constant[1] = ((usage >> 16) & 0xff)
        constant[2] = ((usage >> 8) & 0xff)
        constant[3] = (usage & 0xff)
        constant[4] = 0xaa
        ke = dk(base_key, constant) # Encryption key
        if (Debug)
          System.err.println("usage: " + RJava.cast_to_string(usage))
          if (!(ivec).nil?)
            trace_output("old_state.ivec", ivec, 0, ivec.attr_length)
          end
          trace_output("ciphertext", ciphertext, start, Math.min(len, 32))
          trace_output("constant", constant, 0, constant.attr_length)
          trace_output("baseKey", base_key, 0, base_key.attr_length)
          trace_output("Ke", ke, 0, ke.attr_length)
        end
        # Decrypt [confounder | plaintext ] (without checksum)
        # AES in JCE
        cipher = Cipher.get_instance("AES/CTS/NoPadding")
        secret_key = SecretKeySpec.new(ke, "AES")
        enc_iv = IvParameterSpec.new(ivec, 0, ivec.attr_length)
        cipher.init(Cipher::DECRYPT_MODE, secret_key, enc_iv)
        plaintext = cipher.do_final(ciphertext, start, len - HashSize)
        if (Debug)
          trace_output("AES PlainText", plaintext, 0, Math.min(plaintext.attr_length, 32))
        end
        # Derive integrity key
        constant[4] = 0x55
        ki = dk(base_key, constant) # Integrity key
        if (Debug)
          trace_output("constant", constant, 0, constant.attr_length)
          trace_output("Ki", ki, 0, ke.attr_length)
        end
        # Verify checksum
        # H1 = HMAC(Ki, conf | plaintext | pad)
        calculated_hmac = get_hmac(ki, plaintext)
        hmac_offset = start + len - HashSize
        if (Debug)
          trace_output("calculated Hmac", calculated_hmac, 0, calculated_hmac.attr_length)
          trace_output("message Hmac", ciphertext, hmac_offset, HashSize)
        end
        cksum_failed = false
        if (calculated_hmac.attr_length >= HashSize)
          i = 0
          while i < HashSize
            if (!(calculated_hmac[i]).equal?(ciphertext[hmac_offset + i]))
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
        if (confounder_exists)
          # Get rid of confounder
          # [ confounder | plaintext ]
          output = Array.typed(::Java::Byte).new(plaintext.attr_length - BLOCK_SIZE) { 0 }
          System.arraycopy(plaintext, BLOCK_SIZE, output, 0, output.attr_length)
          return output
        else
          return plaintext
        end
      ensure
        if (!(ke).nil?)
          Arrays.fill(ke, 0, ke.attr_length, 0)
        end
        if (!(ki).nil?)
          Arrays.fill(ki, 0, ki.attr_length, 0)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Invoke the PKCS#5 PBKDF2 algorithm
      def _pbkdf2(secret, salt, count, key_length)
        key_spec = PBEKeySpec.new(secret, salt, count, key_length)
        skf = SecretKeyFactory.get_instance("PBKDF2WithHmacSHA1")
        key = skf.generate_secret(key_spec)
        result = key.get_encoded
        return result
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def read_big_endian(data, pos, size)
        ret_val = 0
        shifter = (size - 1) * 8
        while (size > 0)
          ret_val += (data[pos] & 0xff) << shifter
          shifter -= 8
          pos += 1
          size -= 1
        end
        return ret_val
      end
    }
    
    private
    alias_method :initialize__aes_dk_crypto, :initialize
  end
  
end
