require "rjava"

# 
# Portions Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Crypto
  module DesCbcETypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Confounder
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  class DesCbcEType < DesCbcETypeImports.const_get :EType
    include_class_members DesCbcETypeImports
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_checksum(data, size)
      raise NotImplementedError
    end
    
    typesig { [] }
    def block_size
      return 8
    end
    
    typesig { [] }
    def key_type
      return Krb5::KEYTYPE_DES
    end
    
    typesig { [] }
    def key_size
      return 8
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Encrypts the data using DES in CBC mode.
    # @param data the buffer for plain text.
    # @param key the key to encrypt the data.
    # @return the buffer for encrypted data.
    # 
    # @written by Yanni Zhang, Dec 6 99.
    def encrypt(data, key, usage)
      ivec = Array.typed(::Java::Byte).new(key_size) { 0 }
      return encrypt(data, key, ivec, usage)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Encrypts the data using DES in CBC mode.
    # @param data the buffer for plain text.
    # @param key the key to encrypt the data.
    # @param ivec initialization vector.
    # @return buffer for encrypted data.
    # 
    # @modified by Yanni Zhang, Feb 24 00.
    def encrypt(data, key, ivec, usage)
      # 
      # To meet export control requirements, double check that the
      # key being used is no longer than 64 bits.
      # 
      # Note that from a protocol point of view, an
      # algorithm that is not DES will be rejected before this
      # point. Also, a  DES key that is not 64 bits will be
      # rejected by a good implementations of JCE.
      if (key.attr_length > 8)
        raise KrbCryptoException.new("Invalid DES Key!")
      end
      new_size = data.attr_length + confounder_size + checksum_size
      new_data = nil
      pad = 0
      # Data padding: using Kerberos 5 GSS-API mechanism (1.2.2.3), Jun 1996.
      # Before encryption, plaintext data is padded to the next higest multiple of blocksize.
      # by appending between 1 and 8 bytes, the value of each such byte being the total number
      # of pad bytes. For example, if new_size = 10, blockSize is 8, we should pad 2 bytes,
      # and the value of each byte is 2.
      # If plaintext data is a multiple of blocksize, we pad a 8 bytes of 8.
      if ((new_size % block_size).equal?(0))
        new_data = Array.typed(::Java::Byte).new(new_size + block_size) { 0 }
        pad = 8
      else
        new_data = Array.typed(::Java::Byte).new(new_size + block_size - new_size % block_size) { 0 }
        pad = (block_size - new_size % block_size)
      end
      i = new_size
      while i < new_data.attr_length
        new_data[i] = pad
        ((i += 1) - 1)
      end
      conf = Confounder.bytes(confounder_size)
      System.arraycopy(conf, 0, new_data, 0, confounder_size)
      System.arraycopy(data, 0, new_data, start_of_data, data.attr_length)
      cksum = calculate_checksum(new_data, new_data.attr_length)
      System.arraycopy(cksum, 0, new_data, start_of_checksum, checksum_size)
      cipher = Array.typed(::Java::Byte).new(new_data.attr_length) { 0 }
      Des.cbc_encrypt(new_data, cipher, key, ivec, true)
      return cipher
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Decrypts the data using DES in CBC mode.
    # @param cipher the input buffer.
    # @param key the key to decrypt the data.
    # 
    # @written by Yanni Zhang, Dec 6 99.
    def decrypt(cipher, key, usage)
      ivec = Array.typed(::Java::Byte).new(key_size) { 0 }
      return decrypt(cipher, key, ivec, usage)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Decrypts the data using DES in CBC mode.
    # @param cipher the input buffer.
    # @param key the key to decrypt the data.
    # @param ivec initialization vector.
    # 
    # @modified by Yanni Zhang, Dec 6 99.
    def decrypt(cipher, key, ivec, usage)
      # 
      # To meet export control requirements, double check that the
      # key being used is no longer than 64 bits.
      # 
      # Note that from a protocol point of view, an
      # algorithm that is not DES will be rejected before this
      # point. Also, a DES key that is not 64 bits will be
      # rejected by a good JCE provider.
      if (key.attr_length > 8)
        raise KrbCryptoException.new("Invalid DES Key!")
      end
      data = Array.typed(::Java::Byte).new(cipher.attr_length) { 0 }
      Des.cbc_encrypt(cipher, data, key, ivec, false)
      if (!is_checksum_valid(data))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_BAD_INTEGRITY)
      end
      return data
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def copy_checksum_field(data, cksum)
      i = 0
      while i < checksum_size
        data[start_of_checksum + i] = cksum[i]
        ((i += 1) - 1)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def checksum_field(data)
      result = Array.typed(::Java::Byte).new(checksum_size) { 0 }
      i = 0
      while i < checksum_size
        result[i] = data[start_of_checksum + i]
        ((i += 1) - 1)
      end
      return result
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def reset_checksum_field(data)
      i = start_of_checksum
      while i < start_of_checksum + checksum_size
        data[i] = 0
        ((i += 1) - 1)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # // Not used.
    # public void setChecksum(byte[] data, int size) throws KrbCryptoException{
    # resetChecksumField(data);
    # byte[] cksum = calculateChecksum(data, size);
    # copyChecksumField(data, cksum);
    # }
    def generate_checksum(data)
      cksum1 = checksum_field(data)
      reset_checksum_field(data)
      cksum2 = calculate_checksum(data, data.attr_length)
      copy_checksum_field(data, cksum1)
      return cksum2
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def is_checksum_equal(cksum1, cksum2)
      if ((cksum1).equal?(cksum2))
        return true
      end
      if (((cksum1).nil? && !(cksum2).nil?) || (!(cksum1).nil? && (cksum2).nil?))
        return false
      end
      if (!(cksum1.attr_length).equal?(cksum2.attr_length))
        return false
      end
      i = 0
      while i < cksum1.attr_length
        if (!(cksum1[i]).equal?(cksum2[i]))
          return false
        end
        ((i += 1) - 1)
      end
      return true
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def is_checksum_valid(data)
      cksum1 = checksum_field(data)
      cksum2 = generate_checksum(data)
      return is_checksum_equal(cksum1, cksum2)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__des_cbc_etype, :initialize
  end
  
end
