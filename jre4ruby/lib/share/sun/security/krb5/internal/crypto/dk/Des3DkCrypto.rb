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
  module Des3DkCryptoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto::Dk
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto, :Mac
      include_const ::Javax::Crypto, :SecretKeyFactory
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include_const ::Javax::Crypto::Spec, :DESKeySpec
      include_const ::Javax::Crypto::Spec, :DESedeKeySpec
      include_const ::Javax::Crypto::Spec, :IvParameterSpec
      include_const ::Java::Security::Spec, :KeySpec
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Util, :Arrays
    }
  end
  
  class Des3DkCrypto < Des3DkCryptoImports.const_get :DkCrypto
    include_class_members Des3DkCryptoImports
    
    class_module.module_eval {
      const_set_lazy(:ZERO_IV) { Array.typed(::Java::Byte).new([0, 0, 0, 0, 0, 0, 0, 0]) }
      const_attr_reader  :ZERO_IV
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [] }
    def get_key_seed_length
      return 168 # bits; 3DES key material has 21 bytes
    end
    
    typesig { [Array.typed(::Java::Char)] }
    def string_to_key(salt)
      salt_utf8 = nil
      begin
        salt_utf8 = char_to_utf8(salt)
        return string_to_key(salt_utf8, nil)
      ensure
        if (!(salt_utf8).nil?)
          Arrays.fill(salt_utf8, 0)
        end
        # Caller responsible for clearing its own salt
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def string_to_key(secret_and_salt, opaque)
      if (!(opaque).nil? && opaque.attr_length > 0)
        raise RuntimeException.new("Invalid parameter to stringToKey")
      end
      tmp_key = random_to_key(nfold(secret_and_salt, get_key_seed_length))
      return dk(tmp_key, KERBEROS_CONSTANT)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def parity_fix(value)
      # fix key parity
      set_parity_bit(value)
      return value
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # From RFC 3961.
    # 
    # The 168 bits of random key data are converted to a protocol key value
    # as follows.  First, the 168 bits are divided into three groups of 56
    # bits, which are expanded individually into 64 bits as in des3Expand().
    # Result is a 24 byte (192-bit) key.
    def random_to_key(in_)
      if (!(in_.attr_length).equal?(21))
        raise IllegalArgumentException.new("input must be 168 bits")
      end
      one = key_correction(des3_expand(in_, 0, 7))
      two = key_correction(des3_expand(in_, 7, 14))
      three = key_correction(des3_expand(in_, 14, 21))
      key = Array.typed(::Java::Byte).new(24) { 0 }
      System.arraycopy(one, 0, key, 0, 8)
      System.arraycopy(two, 0, key, 8, 8)
      System.arraycopy(three, 0, key, 16, 8)
      return key
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      def key_correction(key)
        # check for weak key
        begin
          if (DESKeySpec.is_weak(key, 0))
            key[7] = (key[7] ^ 0xf0)
          end
        rescue InvalidKeyException => ex
          # swallow, since it should never happen
        end
        return key
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # From RFC 3961.
      # 
      # Expands a 7-byte array into an 8-byte array that contains parity bits.
      # The 56 bits are expanded into 64 bits as follows:
      # 1  2  3  4  5  6  7  p
      # 9 10 11 12 13 14 15  p
      # 17 18 19 20 21 22 23  p
      # 25 26 27 28 29 30 31  p
      # 33 34 35 36 37 38 39  p
      # 41 42 43 44 45 46 47  p
      # 49 50 51 52 53 54 55  p
      # 56 48 40 32 24 16  8  p
      # 
      # (PI,P2,...,P8) are reserved for parity bits computed on the preceding
      # seven independent bits and set so that the parity of the octet is odd,
      # i.e., there is an odd number of "1" bits in the octet.
      # 
      # @param start index of starting byte (inclusive)
      # @param end index of ending byte (exclusive)
      def des3_expand(input, start, end_)
        if (!((end_ - start)).equal?(7))
          raise IllegalArgumentException.new("Invalid length of DES Key Value:" + RJava.cast_to_string(start) + "," + RJava.cast_to_string(end_))
        end
        result = Array.typed(::Java::Byte).new(8) { 0 }
        last = 0
        System.arraycopy(input, start, result, 0, 7)
        posn = 0
        # Fill in last row
        i = start
        while i < end_
          bit = (input[i] & 0x1)
          if (self.attr_debug)
            System.out.println(RJava.cast_to_string(i) + ": " + RJava.cast_to_string(JavaInteger.to_hex_string(input[i])) + " bit= " + RJava.cast_to_string(JavaInteger.to_hex_string(bit)))
          end
          (posn += 1)
          if (!(bit).equal?(0))
            last |= (bit << posn)
          end
          i += 1
        end
        if (self.attr_debug)
          System.out.println("last: " + RJava.cast_to_string(JavaInteger.to_hex_string(last)))
        end
        result[7] = last
        set_parity_bit(result)
        return result
      end
      
      # Mask used to check for parity adjustment
      const_set_lazy(:PARITY_BIT_MASK) { Array.typed(::Java::Byte).new([0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2]) }
      const_attr_reader  :PARITY_BIT_MASK
      
      typesig { [Array.typed(::Java::Byte)] }
      # Sets the parity bit (0th bit) in each byte so that each byte
      # contains an odd number of 1's.
      def set_parity_bit(key)
        i = 0
        while i < key.attr_length
          bit_count = 0
          mask_index = 0
          while mask_index < PARITY_BIT_MASK.attr_length
            if (((key[i] & PARITY_BIT_MASK[mask_index])).equal?(PARITY_BIT_MASK[mask_index]))
              bit_count += 1
            end
            mask_index += 1
          end
          if (((bit_count & 0x1)).equal?(1))
            # Odd number of 1 bits in the top 7 bits. Set parity bit to 0
            key[i] = (key[i] & 0xfe)
          else
            # Even number of 1 bits in the top 7 bits. Set parity bit to 1
            key[i] = (key[i] | 1)
          end
          i += 1
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def get_cipher(key, ivec, mode)
      # NoSuchAlgorithException
      factory = SecretKeyFactory.get_instance("desede")
      # InvalidKeyException
      spec = DESedeKeySpec.new(key, 0)
      # InvalidKeySpecException
      secret_key = factory.generate_secret(spec)
      # IV
      if ((ivec).nil?)
        ivec = ZERO_IV
      end
      # NoSuchAlgorithmException, NoSuchPaddingException
      # NoSuchProviderException
      cipher = Cipher.get_instance("DESede/CBC/NoPadding")
      enc_iv = IvParameterSpec.new(ivec, 0, ivec.attr_length)
      # InvalidKeyException, InvalidAlgorithParameterException
      cipher.init(mode, secret_key, enc_iv)
      return cipher
    end
    
    typesig { [] }
    def get_checksum_length
      return 20 # bytes
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def get_hmac(key, msg)
      key_ki = SecretKeySpec.new(key, "HmacSHA1")
      m = Mac.get_instance("HmacSHA1")
      m.init(key_ki)
      return m.do_final(msg)
    end
    
    private
    alias_method :initialize__des3dk_crypto, :initialize
  end
  
end
