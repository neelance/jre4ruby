require "rjava"

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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Crypto
  module DesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include_const ::Javax::Crypto, :SecretKeyFactory
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Java::Security, :Security
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Javax::Crypto::Spec, :IvParameterSpec
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Sun::Security::Krb5::Internal, :Krb5
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Util, :Arrays
    }
  end
  
  class Des 
    include_class_members DesImports
    
    class_module.module_eval {
      const_set_lazy(:Bad_keys) { Array.typed(::Java::Long).new([0x101010101010101, -0x101010101010102, 0x1f1f1f1f1f1f1f1f, -0x1f1f1f1f1f1f1f20, 0x1fe01fe01fe01fe, -0x1fe01fe01fe01ff, 0x1fe01fe00ef10ef1, -0x1fe01fe00ef10ef2, 0x1e001e001f101f1, -0x1ffe1ffe0efe0eff, 0x1ffe1ffe0efe0efe, -0x1e001e001f101f2, 0x11f011f010e010e, 0x1f011f010e010e01, -0x1f011f010e010e02, -0x11f011f010e010f]) }
      const_attr_reader  :Bad_keys
      
      const_set_lazy(:Good_parity) { Array.typed(::Java::Byte).new([1, 1, 2, 2, 4, 4, 7, 7, 8, 8, 11, 11, 13, 13, 14, 14, 16, 16, 19, 19, 21, 21, 22, 22, 25, 25, 26, 26, 28, 28, 31, 31, 32, 32, 35, 35, 37, 37, 38, 38, 41, 41, 42, 42, 44, 44, 47, 47, 49, 49, 50, 50, 52, 52, 55, 55, 56, 56, 59, 59, 61, 61, 62, 62, 64, 64, 67, 67, 69, 69, 70, 70, 73, 73, 74, 74, 76, 76, 79, 79, 81, 81, 82, 82, 84, 84, 87, 87, 88, 88, 91, 91, 93, 93, 94, 94, 97, 97, 98, 98, 100, 100, 103, 103, 104, 104, 107, 107, 109, 109, 110, 110, 112, 112, 115, 115, 117, 117, 118, 118, 121, 121, 122, 122, 124, 124, 127, 127, 128, 128, 131, 131, 133, 133, 134, 134, 137, 137, 138, 138, 140, 140, 143, 143, 145, 145, 146, 146, 148, 148, 151, 151, 152, 152, 155, 155, 157, 157, 158, 158, 161, 161, 162, 162, 164, 164, 167, 167, 168, 168, 171, 171, 173, 173, 174, 174, 176, 176, 179, 179, 181, 181, 182, 182, 185, 185, 186, 186, 188, 188, 191, 191, 193, 193, 194, 194, 196, 196, 199, 199, 200, 200, 203, 203, 205, 205, 206, 206, 208, 208, 211, 211, 213, 213, 214, 214, 217, 217, 218, 218, 220, 220, 223, 223, 224, 224, 227, 227, 229, 229, 230, 230, 233, 233, 234, 234, 236, 236, 239, 239, 241, 241, 242, 242, 244, 244, 247, 247, 248, 248, 251, 251, 253, 253, 254, 254]) }
      const_attr_reader  :Good_parity
      
      typesig { [Array.typed(::Java::Byte)] }
      def set_parity(key)
        i = 0
        while i < 8
          key[i] = Good_parity[key[i] & 0xff]
          i += 1
        end
        return key
      end
      
      typesig { [::Java::Long] }
      def set_parity(key)
        return octet2long(set_parity(long2octet(key)))
      end
      
      typesig { [::Java::Long] }
      def bad_key(key)
        i = 0
        while i < Bad_keys.attr_length
          if ((Bad_keys[i]).equal?(key))
            return true
          end
          i += 1
        end
        return false
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def bad_key(key)
        return bad_key(octet2long(key))
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def octet2long(input)
        return octet2long(input, 0)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def octet2long(input, offset)
        # convert a 8-byte to a long
        result = 0
        i = 0
        while i < 8
          if (i + offset < input.attr_length)
            result |= ((input[i + offset]) & 0xff) << ((7 - i) * 8)
          end
          i += 1
        end
        return result
      end
      
      typesig { [::Java::Long] }
      def long2octet(input)
        output = Array.typed(::Java::Byte).new(8) { 0 }
        i = 0
        while i < 8
          output[i] = ((input >> ((7 - i) * 8)) & 0xff)
          i += 1
        end
        return output
      end
      
      typesig { [::Java::Long, Array.typed(::Java::Byte)] }
      def long2octet(input, output)
        long2octet(input, output, 0)
      end
      
      typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int] }
      def long2octet(input, output, offset)
        i = 0
        while i < 8
          if (i + offset < output.attr_length)
            output[i + offset] = ((input >> ((7 - i) * 8)) & 0xff)
          end
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Boolean] }
      # Creates a DES cipher in Electronic Codebook mode, with no padding.
      # @param input plain text.
      # @param output the buffer for the result.
      # @param key DES the key to encrypt the text.
      # @param ivec initialization vector.
      # 
      # @created by Yanni Zhang, Dec 6 99.
      def cbc_encrypt(input, output, key, ivec, encrypt)
        cipher = nil
        begin
          cipher = Cipher.get_instance("DES/CBC/NoPadding")
        rescue GeneralSecurityException => e
          ke = KrbCryptoException.new("JCE provider may not be installed. " + RJava.cast_to_string(e.get_message))
          ke.init_cause(e)
          raise ke
        end
        params = IvParameterSpec.new(ivec)
        sk_spec = SecretKeySpec.new(key, "DES")
        begin
          skf = SecretKeyFactory.get_instance("DES")
          #                  SecretKey sk = skf.generateSecret(skSpec);
          sk = sk_spec
          if (encrypt)
            cipher.init(Cipher::ENCRYPT_MODE, sk, params)
          else
            cipher.init(Cipher::DECRYPT_MODE, sk, params)
          end
          result = nil
          result = cipher.do_final(input)
          System.arraycopy(result, 0, output, 0, result.attr_length)
        rescue GeneralSecurityException => e
          ke = KrbCryptoException.new(e.get_message)
          ke.init_cause(e)
          raise ke
        end
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # Generates DES key from the password.
      # @param password a char[] used to create the key.
      # @return DES key.
      # 
      # @modified by Yanni Zhang, Dec 6, 99
      def char_to_key(passwd_chars)
        key = 0
        octet = 0
        octet1 = 0
        octet2 = 0
        cbytes = nil
        # Convert password to byte array
        begin
          cbytes = (String.new(passwd_chars)).get_bytes
        rescue JavaException => e
          # clear-up sensitive information
          if (!(cbytes).nil?)
            Arrays.fill(cbytes, 0, cbytes.attr_length, 0)
          end
          ce = KrbCryptoException.new("Unable to convert passwd, " + RJava.cast_to_string(e))
          ce.init_cause(e)
          raise ce
        end
        # pad data
        passwd_bytes = pad(cbytes)
        newkey = Array.typed(::Java::Byte).new(8) { 0 }
        length = (passwd_bytes.attr_length / 8) + ((passwd_bytes.attr_length % 8).equal?(0) ? 0 : 1)
        i = 0
        while i < length
          octet = octet2long(passwd_bytes, i * 8) & 0x7f7f7f7f7f7f7f7f
          if ((i % 2).equal?(1))
            octet1 = 0
            j = 0
            while j < 64
              octet1 |= ((octet & (1 << j)) >> j) << (63 - j)
              j += 1
            end
            octet = octet1 >> 1
          end
          key ^= (octet << 1)
          i += 1
        end
        key = set_parity(key)
        if (bad_key(key))
          temp = long2octet(key)
          temp[7] ^= 0xf0
          key = octet2long(temp)
        end
        newkey = des_cksum(long2octet(key), passwd_bytes, long2octet(key))
        key = octet2long(set_parity(newkey))
        if (bad_key(key))
          temp = long2octet(key)
          temp[7] ^= 0xf0
          key = octet2long(temp)
        end
        # clear-up sensitive information
        if (!(cbytes).nil?)
          Arrays.fill(cbytes, 0, cbytes.attr_length, 0)
        end
        if (!(passwd_bytes).nil?)
          Arrays.fill(passwd_bytes, 0, passwd_bytes.attr_length, 0)
        end
        return key
      end
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Encrypts the message blocks using DES CBC and output the
      # final block of 8-byte ciphertext.
      # @param ivec Initialization vector.
      # @param msg Input message as an byte array.
      # @param key DES key to encrypt the message.
      # @return the last block of ciphertext.
      # 
      # @created by Yanni Zhang, Dec 6, 99.
      def des_cksum(ivec, msg, key)
        cipher = nil
        result = Array.typed(::Java::Byte).new(8) { 0 }
        begin
          cipher = Cipher.get_instance("DES/CBC/NoPadding")
        rescue JavaException => e
          ke = KrbCryptoException.new("JCE provider may not be installed. " + RJava.cast_to_string(e.get_message))
          ke.init_cause(e)
          raise ke
        end
        params = IvParameterSpec.new(ivec)
        sk_spec = SecretKeySpec.new(key, "DES")
        begin
          skf = SecretKeyFactory.get_instance("DES")
          # SecretKey sk = skf.generateSecret(skSpec);
          sk = sk_spec
          cipher.init(Cipher::ENCRYPT_MODE, sk, params)
          i = 0
          while i < msg.attr_length / 8
            result = cipher.do_final(msg, i * 8, 8)
            cipher.init(Cipher::ENCRYPT_MODE, sk, (IvParameterSpec.new(result)))
            i += 1
          end
        rescue GeneralSecurityException => e
          ke = KrbCryptoException.new(e.get_message)
          ke.init_cause(e)
          raise ke
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Pads the data so that its length is a multiple of 8 bytes.
      # @param data the raw data.
      # @return the data being padded.
      # 
      # @created by Yanni Zhang, Dec 6 99. //Kerberos does not use PKCS5 padding.
      def pad(data)
        len = 0
        if (data.attr_length < 8)
          len = data.attr_length
        else
          len = data.attr_length % 8
        end
        if ((len).equal?(0))
          return data
        else
          padding = Array.typed(::Java::Byte).new(8 - len + data.attr_length) { 0 }
          i = padding.attr_length - 1
          while i > data.attr_length - 1
            padding[i] = 0
            i -= 1
          end
          System.arraycopy(data, 0, padding, 0, data.attr_length)
          return padding
        end
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # Caller is responsible for clearing password
      def string_to_key_bytes(passwd_chars)
        return long2octet(char_to_key(passwd_chars))
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__des, :initialize
  end
  
end
