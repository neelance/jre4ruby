require "rjava"
 # * Portions Copyright 2004-2007 Sun Microsystems, Inc.  All Rights Reserved.
# Copyright (C) 1998 by the FundsXpress, INC.
# 
# All rights reserved.
# 
# Export of this software from the United States of America may require
# a specific license from the United States Government.  It is the
# responsibility of any person or organization contemplating export to
# obtain such a license before exporting.
# 
# WITHIN THAT CONSTRAINT, permission to use, copy, modify, and
# distribute this software and its documentation for any purpose and
# without fee is hereby granted, provided that the above copyright
# notice appear in all copies and that both that copyright notice and
# this permission notice appear in supporting documentation, and that
# the name of FundsXpress. not be used in advertising or publicity pertaining
# to distribution of the software without specific, written prior
# permission.  FundsXpress makes no representations about the suitability of
# this software for any purpose.  It is provided "as is" without express
# or implied warranty.
# 
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
module Sun::Security::Krb5::Internal::Crypto::Dk
  module DkCryptoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto::Dk
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto, :Mac
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Util, :Arrays
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Security::Krb5, :Confounder
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include_const ::Sun::Security::Krb5, :KrbCryptoException
    }
  end
  
  # Implements Derive Key cryptography functionality as defined in RFC 3961.
  # http://www.ietf.org/rfc/rfc3961.txt
  # 
  # This is an abstract class. Concrete subclasses need to implement
  # the abstract methods.
  class DkCrypto 
    include_class_members DkCryptoImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
      
      # These values correspond to the ASCII encoding for the string "kerberos"
      const_set_lazy(:KERBEROS_CONSTANT) { Array.typed(::Java::Byte).new([0x6b, 0x65, 0x72, 0x62, 0x65, 0x72, 0x6f, 0x73]) }
      const_attr_reader  :KERBEROS_CONSTANT
    }
    
    typesig { [] }
    def get_key_seed_length
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # in bits
    def random_to_key(in_)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def get_cipher(key, ivec, mode)
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_checksum_length
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # in bytes
    def get_hmac(key, plaintext)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # From RFC 3961.
    # 
    # encryption function       conf = random string of length c
    #                     pad = shortest string to bring confounder
    #                           and plaintext to a length that's a
    #                           multiple of m
    #                     (C1, newIV) = E(Ke, conf | plaintext | pad,
    #                                     oldstate.ivec)
    #                    H1 = HMAC(Ki, conf | plaintext | pad)
    #                     ciphertext =  C1 | H1[1..h]
    #                     newstate.ivec = newIV
    # 
    # @param ivec initial vector to use when initializing the cipher; if null,
    #     then blocksize number of zeros are used,
    # @param new_ivec if non-null, it is updated upon return to be the
    #       new ivec to use when calling encrypt next time
    def encrypt(base_key, usage, ivec, new_ivec, plaintext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
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
        ke = dk(base_key, constant)
        if (Debug)
          System.err.println("usage: " + RJava.cast_to_string(usage))
          if (!(ivec).nil?)
            trace_output("old_state.ivec", ivec, 0, ivec.attr_length)
          end
          trace_output("plaintext", plaintext, start, Math.min(len, 32))
          trace_output("constant", constant, 0, constant.attr_length)
          trace_output("baseKey", base_key, 0, base_key.attr_length)
          trace_output("Ke", ke, 0, ke.attr_length)
        end
        # Encrypt
        # C1 = E(Ke, conf | plaintext | pad, oldivec)
        enc_cipher = get_cipher(ke, ivec, Cipher::ENCRYPT_MODE)
        block_size = enc_cipher.get_block_size
        confounder = Confounder.bytes(block_size)
        plain_size = roundup(confounder.attr_length + len, block_size)
        if (Debug)
          System.err.println("confounder = " + RJava.cast_to_string(confounder.attr_length) + "; plaintext = " + RJava.cast_to_string(len) + "; padding = " + RJava.cast_to_string((plain_size - confounder.attr_length - len)) + "; total = " + RJava.cast_to_string(plain_size))
          trace_output("confounder", confounder, 0, confounder.attr_length)
        end
        to_be_encrypted = Array.typed(::Java::Byte).new(plain_size) { 0 }
        System.arraycopy(confounder, 0, to_be_encrypted, 0, confounder.attr_length)
        System.arraycopy(plaintext, start, to_be_encrypted, confounder.attr_length, len)
        # Set padding bytes to zero
        Arrays.fill(to_be_encrypted, confounder.attr_length + len, plain_size, 0)
        cipher_size = enc_cipher.get_output_size(plain_size)
        cc_size = cipher_size + get_checksum_length # cipher | hmac
        ciphertext = Array.typed(::Java::Byte).new(cc_size) { 0 }
        enc_cipher.do_final(to_be_encrypted, 0, plain_size, ciphertext, 0)
        # Update ivec for next operation
        # (last blockSize bytes of ciphertext)
        # newstate.ivec = newIV
        if (!(new_ivec).nil? && (new_ivec.attr_length).equal?(block_size))
          System.arraycopy(ciphertext, cipher_size - block_size, new_ivec, 0, block_size)
          if (Debug)
            trace_output("new_ivec", new_ivec, 0, new_ivec.attr_length)
          end
        end
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
        if (Debug)
          trace_output("hmac", hmac, 0, hmac.attr_length)
          trace_output("ciphertext", ciphertext, 0, Math.min(ciphertext.attr_length, 32))
        end
        # C1 | H1[1..h]
        System.arraycopy(hmac, 0, ciphertext, cipher_size, get_checksum_length)
        return ciphertext
      ensure
        if (!(ke).nil?)
          Arrays.fill(ke, 0, ke.attr_length, 0)
        end
        if (!(ki).nil?)
          Arrays.fill(ki, 0, ki.attr_length, 0)
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Performs encryption using given key only; does not add
    # confounder, padding, or checksum. Incoming data to be encrypted
    # assumed to have the correct blocksize.
    # Ignore key usage.
    def encrypt_raw(base_key, usage, ivec, plaintext, start, len)
      if (Debug)
        System.err.println("usage: " + RJava.cast_to_string(usage))
        if (!(ivec).nil?)
          trace_output("old_state.ivec", ivec, 0, ivec.attr_length)
        end
        trace_output("plaintext", plaintext, start, Math.min(len, 32))
        trace_output("baseKey", base_key, 0, base_key.attr_length)
      end
      # Encrypt
      enc_cipher = get_cipher(base_key, ivec, Cipher::ENCRYPT_MODE)
      block_size = enc_cipher.get_block_size
      if (!((len % block_size)).equal?(0))
        raise GeneralSecurityException.new("length of data to be encrypted (" + RJava.cast_to_string(len) + ") is not a multiple of the blocksize (" + RJava.cast_to_string(block_size) + ")")
      end
      cipher_size = enc_cipher.get_output_size(len)
      ciphertext = Array.typed(::Java::Byte).new(cipher_size) { 0 }
      enc_cipher.do_final(plaintext, 0, len, ciphertext, 0)
      return ciphertext
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Decrypts data using specified key and initial vector.
    # @param baseKey encryption key to use
    # @param ciphertext  encrypted data to be decrypted
    # @param usage ignored
    def decrypt_raw(base_key, usage, ivec, ciphertext, start, len)
      if (Debug)
        System.err.println("usage: " + RJava.cast_to_string(usage))
        if (!(ivec).nil?)
          trace_output("old_state.ivec", ivec, 0, ivec.attr_length)
        end
        trace_output("ciphertext", ciphertext, start, Math.min(len, 32))
        trace_output("baseKey", base_key, 0, base_key.attr_length)
      end
      dec_cipher = get_cipher(base_key, ivec, Cipher::DECRYPT_MODE)
      block_size = dec_cipher.get_block_size
      if (!((len % block_size)).equal?(0))
        raise GeneralSecurityException.new("length of data to be decrypted (" + RJava.cast_to_string(len) + ") is not a multiple of the blocksize (" + RJava.cast_to_string(block_size) + ")")
      end
      decrypted = dec_cipher.do_final(ciphertext, start, len)
      if (Debug)
        trace_output("decrypted", decrypted, 0, Math.min(decrypted.attr_length, 32))
      end
      return decrypted
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # @param baseKey key from which keys are to be derived using usage
    # @param ciphertext  E(Ke, conf | plaintext | padding, ivec) | H1[1..h]
    def decrypt(base_key, usage, ivec, ciphertext, start, len)
      if (!KeyUsage.is_valid(usage))
        raise GeneralSecurityException.new("Invalid key usage number: " + RJava.cast_to_string(usage))
      end
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
        dec_cipher = get_cipher(ke, ivec, Cipher::DECRYPT_MODE)
        block_size = dec_cipher.get_block_size
        # Decrypt [confounder | plaintext | padding] (without checksum)
        cksum_size = get_checksum_length
        cipher_size = len - cksum_size
        decrypted = dec_cipher.do_final(ciphertext, start, cipher_size)
        if (Debug)
          trace_output("decrypted", decrypted, 0, Math.min(decrypted.attr_length, 32))
        end
        # decrypted = [confounder | plaintext | padding]
        # Derive integrity key
        constant[4] = 0x55
        ki = dk(base_key, constant) # Integrity key
        if (Debug)
          trace_output("constant", constant, 0, constant.attr_length)
          trace_output("Ki", ki, 0, ke.attr_length)
        end
        # Verify checksum
        # H1 = HMAC(Ki, conf | plaintext | pad)
        calculated_hmac = get_hmac(ki, decrypted)
        if (Debug)
          trace_output("calculated Hmac", calculated_hmac, 0, calculated_hmac.attr_length)
          trace_output("message Hmac", ciphertext, cipher_size, cksum_size)
        end
        cksum_failed = false
        if (calculated_hmac.attr_length >= cksum_size)
          i = 0
          while i < cksum_size
            if (!(calculated_hmac[i]).equal?(ciphertext[cipher_size + i]))
              cksum_failed = true
              break
            end
            i += 1
          end
        end
        if (cksum_failed)
          raise GeneralSecurityException.new("Checksum failed")
        end
        # Prepare decrypted msg and ivec to be returned
        # Last blockSize bytes of ciphertext without checksum
        if (!(ivec).nil? && (ivec.attr_length).equal?(block_size))
          System.arraycopy(ciphertext, start + cipher_size - block_size, ivec, 0, block_size)
          if (Debug)
            trace_output("new_state.ivec", ivec, 0, ivec.attr_length)
          end
        end
        # Get rid of confounder
        # [plaintext | padding]
        plaintext = Array.typed(::Java::Byte).new(decrypted.attr_length - block_size) { 0 }
        System.arraycopy(decrypted, block_size, plaintext, 0, plaintext.attr_length)
        return plaintext # padding still there
      ensure
        if (!(ke).nil?)
          Arrays.fill(ke, 0, ke.attr_length, 0)
        end
        if (!(ki).nil?)
          Arrays.fill(ki, 0, ki.attr_length, 0)
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Round up to the next blocksize
    def roundup(n, blocksize)
      return (((n + blocksize - 1) / blocksize) * blocksize)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
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
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # DK(Key, Constant) = random-to-key(DR(Key, Constant))
    def dk(key, constant)
      return random_to_key(dr(key, constant))
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # From RFC 3961.
    # 
    # DR(Key, Constant) = k-truncate(E(Key, Constant,
    #                                  initial-cipher-state))
    # 
    # Here DR is the random-octet generation function described below, and
    # DK is the key-derivation function produced from it.  In this
    # construction, E(Key, Plaintext, CipherState) is a cipher, Constant is
    # a well-known constant determined by the specific usage of this
    # function, and k-truncate truncates its argument by taking the first k
    # bits.  Here, k is the key generation seed length needed for the
    # encryption system.
    # 
    # The output of the DR function is a string of bits; the actual key is
    # produced by applying the cryptosystem's random-to-key operation on
    # this bitstring.
    # 
    # If the Constant is smaller than the cipher block size of E, then it
    # must be expanded with n-fold() so it can be encrypted.  If the output
    # of E is shorter than k bits it is fed back into the encryption as
    # many times as necessary.  The construct is as follows (where |
    # indicates concatentation):
    # 
    # K1 = E(Key, n-fold(Constant), initial-cipher-state)
    # K2 = E(Key, K1, initial-cipher-state)
    # K3 = E(Key, K2, initial-cipher-state)
    # K4 = ...
    # 
    # DR(Key, Constant) = k-truncate(K1 | K2 | K3 | K4 ...)
    def dr(key, constant)
      enc_cipher = get_cipher(key, nil, Cipher::ENCRYPT_MODE)
      blocksize = enc_cipher.get_block_size
      if (!(constant.attr_length).equal?(blocksize))
        constant = nfold(constant, blocksize * 8)
      end
      to_be_encrypted = constant
      keybytes = (get_key_seed_length >> 3) # from bits to bytes
      rawkey = Array.typed(::Java::Byte).new(keybytes) { 0 }
      posn = 0
      # loop encrypting the blocks until enough key bytes are generated
      n = 0
      len = 0
      while (n < keybytes)
        if (Debug)
          System.err.println("Encrypting: " + RJava.cast_to_string(bytes_to_string(to_be_encrypted)))
        end
        cipher_block = enc_cipher.do_final(to_be_encrypted)
        if (Debug)
          System.err.println("K: " + RJava.cast_to_string((posn += 1)) + " = " + RJava.cast_to_string(bytes_to_string(cipher_block)))
        end
        len = (keybytes - n <= cipher_block.attr_length ? (keybytes - n) : cipher_block.attr_length)
        if (Debug)
          System.err.println("copying " + RJava.cast_to_string(len) + " key bytes")
        end
        System.arraycopy(cipher_block, 0, rawkey, n, len)
        n += len
        to_be_encrypted = cipher_block
      end
      return rawkey
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # ---------------------------------
      # From MIT-1.3.1 distribution
      # n-fold(k-bits):
      #   l = lcm(n,k)
      #   r = l/k
      # s = k-bits | k-bits rot 13 | k-bits rot 13*2 | ... | k-bits rot 13*(r-1)
      # compute the 1's complement sum:
      # n-fold = s[0..n-1]+s[n..2n-1]+s[2n..3n-1]+..+s[(k-1)*n..k*n-1]
      # representation: msb first, assume n and k are multiples of 8, and
      #  that k>=16.  this is the case of all the cryptosystems which are
      #  likely to be used.  this function can be replaced if that
      #  assumption ever fails.
      # input length is in bits
      def nfold(in_, outbits)
        inbits = in_.attr_length
        outbits >>= 3 # count in bytes
        # first compute lcm(n,k)
        a = 0
        b = 0
        c = 0
        lcm = 0
        a = outbits # n
        b = inbits # k
        while (!(b).equal?(0))
          c = b
          b = a % b
          a = c
        end
        lcm = outbits * inbits / a
        if (Debug)
          System.err.println("k: " + RJava.cast_to_string(inbits))
          System.err.println("n: " + RJava.cast_to_string(outbits))
          System.err.println("lcm: " + RJava.cast_to_string(lcm))
        end
        # now do the real work
        out = Array.typed(::Java::Byte).new(outbits) { 0 }
        Arrays.fill(out, 0)
        thisbyte = 0
        msbit = 0
        i = 0
        bval = 0
        oval = 0
        # this will end up cycling through k lcm(k,n)/k times, which
        # is correct
        i = lcm - 1
        while i >= 0
          # compute the msbit in k which gets added into this byte
          # first, start with msbit in the first, unrotated byte
          # then, for each byte, shift to right for each repetition
          # last, pick out correct byte within that shifted repetition
          msbit = (((inbits << 3) - 1) + (((inbits << 3) + 13) * (i / inbits)) + ((inbits - (i % inbits)) << 3)) % (inbits << 3)
          # pull out the byte value itself
          # Mask off values using &0xff to get only the lower byte
          # Use >>> to avoid sign extension
          bval = ((((in_[((inbits - 1) - (msbit >> 3)) % inbits] & 0xff) << 8) | (in_[((inbits) - (msbit >> 3)) % inbits] & 0xff)) >> ((msbit & 7) + 1)) & 0xff
          # System.err.println("((" +
          #     ((in[((inbits-1)-(msbit>>>3))%inbits]&0xff)<<8)
          #     + "|" + (in[((inbits)-(msbit>>>3))%inbits]&0xff) + ")"
          #     + ">>>" + ((msbit&7)+1) + ")&0xff = " + bval);
          thisbyte += bval
          # do the addition
          # Mask off values using &0xff to get only the lower byte
          oval = (out[i % outbits] & 0xff)
          thisbyte += oval
          out[i % outbits] = (thisbyte & 0xff)
          if (Debug)
            System.err.println("msbit[" + RJava.cast_to_string(i) + "] = " + RJava.cast_to_string(msbit) + "\tbval=" + RJava.cast_to_string(JavaInteger.to_hex_string(bval)) + "\toval=" + RJava.cast_to_string(JavaInteger.to_hex_string(oval)) + "\tsum = " + RJava.cast_to_string(JavaInteger.to_hex_string(thisbyte)))
          end
          # keep around the carry bit, if any
          thisbyte >>= 8
          if (Debug)
            System.err.println("carry=" + RJava.cast_to_string(thisbyte))
          end
          i -= 1
        end
        # if there's a carry bit left over, add it back in
        if (!(thisbyte).equal?(0))
          i = outbits - 1
          while i >= 0
            # do the addition
            thisbyte += (out[i] & 0xff)
            out[i] = (thisbyte & 0xff)
            # keep around the carry bit, if any
            thisbyte >>= 8
            i -= 1
          end
        end
        return out
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Routines used for debugging
      def bytes_to_string(digest)
        # Get character representation of digest
        digest_string = StringBuffer.new
        i = 0
        while i < digest.attr_length
          if ((digest[i] & 0xff) < 0x10)
            digest_string.append("0" + RJava.cast_to_string(JavaInteger.to_hex_string(digest[i] & 0xff)))
          else
            digest_string.append(JavaInteger.to_hex_string(digest[i] & 0xff))
          end
          i += 1
        end
        return digest_string.to_s
      end
      
      typesig { [String] }
      def binary_string_to_bytes(str)
        usage_str = str.to_char_array
        usage = Array.typed(::Java::Byte).new(usage_str.attr_length / 2) { 0 }
        i = 0
        while i < usage.attr_length
          a = Byte.parse_byte(String.new(usage_str, i * 2, 1), 16)
          b = Byte.parse_byte(String.new(usage_str, i * 2 + 1, 1), 16)
          usage[i] = ((a << 4) | b)
          i += 1
        end
        return usage
      end
      
      typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def trace_output(trace_tag, output, offset, len)
        begin
          out = ByteArrayOutputStream.new(len)
          HexDumpEncoder.new.encode_buffer(ByteArrayInputStream.new(output, offset, len), out)
          System.err.println(trace_tag + ":" + RJava.cast_to_string(out.to_s))
        rescue JavaException => e
        end
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # String.getBytes("UTF-8");
      # Do this instead of using String to avoid making password immutable
      def char_to_utf8(chars)
        utf8 = Charset.for_name("UTF-8")
        cb = CharBuffer.wrap(chars)
        bb = utf8.encode(cb)
        len = bb.limit
        answer = Array.typed(::Java::Byte).new(len) { 0 }
        bb.get(answer, 0, len)
        return answer
      end
      
      typesig { [Array.typed(::Java::Char)] }
      def char_to_utf16(chars)
        utf8 = Charset.for_name("UTF-16LE")
        cb = CharBuffer.wrap(chars)
        bb = utf8.encode(cb)
        len = bb.limit
        answer = Array.typed(::Java::Byte).new(len) { 0 }
        bb.get(answer, 0, len)
        return answer
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__dk_crypto, :initialize
  end
  
end
