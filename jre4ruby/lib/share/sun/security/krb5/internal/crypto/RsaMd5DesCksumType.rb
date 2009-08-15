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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Crypto
  module RsaMd5DesCksumTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :Confounder
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :DESKeySpec
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Security
      include_const ::Java::Security, :InvalidKeyException
    }
  end
  
  class RsaMd5DesCksumType < RsaMd5DesCksumTypeImports.const_get :CksumType
    include_class_members RsaMd5DesCksumTypeImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [] }
    def confounder_size
      return 8
    end
    
    typesig { [] }
    def cksum_type
      return Checksum::CKSUMTYPE_RSA_MD5_DES
    end
    
    typesig { [] }
    def is_safe
      return true
    end
    
    typesig { [] }
    def cksum_size
      return 24
    end
    
    typesig { [] }
    def key_type
      return Krb5::KEYTYPE_DES
    end
    
    typesig { [] }
    def key_size
      return 8
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # Calculates keyed checksum.
    # @param data the data used to generate the checksum.
    # @param size length of the data.
    # @param key the key used to encrypt the checksum.
    # @return keyed checksum.
    # 
    # @modified by Yanni Zhang, 12/08/99.
    def calculate_keyed_checksum(data, size, key, usage)
      # prepend confounder
      new_data = Array.typed(::Java::Byte).new(size + confounder_size) { 0 }
      conf = Confounder.bytes(confounder_size)
      System.arraycopy(conf, 0, new_data, 0, confounder_size)
      System.arraycopy(data, 0, new_data, confounder_size, size)
      # calculate md5 cksum
      mdc_cksum = calculate_checksum(new_data, new_data.attr_length)
      cksum = Array.typed(::Java::Byte).new(cksum_size) { 0 }
      System.arraycopy(conf, 0, cksum, 0, confounder_size)
      System.arraycopy(mdc_cksum, 0, cksum, confounder_size, cksum_size - confounder_size)
      # compute modified key
      new_key = Array.typed(::Java::Byte).new(key_size) { 0 }
      System.arraycopy(key, 0, new_key, 0, key.attr_length)
      i = 0
      while i < new_key.attr_length
        new_key[i] = (new_key[i] ^ 0xf0)
        i += 1
      end
      # check for weak keys
      begin
        if (DESKeySpec.is_weak(new_key, 0))
          new_key[7] = (new_key[7] ^ 0xf0)
        end
      rescue InvalidKeyException => ex
        # swallow, since it should never happen
      end
      ivec = Array.typed(::Java::Byte).new(new_key.attr_length) { 0 }
      # des-cbc encrypt
      enc_cksum = Array.typed(::Java::Byte).new(cksum.attr_length) { 0 }
      Des.cbc_encrypt(cksum, enc_cksum, new_key, ivec, true)
      return enc_cksum
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # Verifies keyed checksum.
    # @param data the data.
    # @param size the length of data.
    # @param key the key used to encrypt the checksum.
    # @param checksum
    # @return true if verification is successful.
    # 
    # @modified by Yanni Zhang, 12/08/99.
    def verify_keyed_checksum(data, size, key, checksum, usage)
      # decrypt checksum
      cksum = decrypt_keyed_checksum(checksum, key)
      # prepend confounder
      new_data = Array.typed(::Java::Byte).new(size + confounder_size) { 0 }
      System.arraycopy(cksum, 0, new_data, 0, confounder_size)
      System.arraycopy(data, 0, new_data, confounder_size, size)
      new_cksum = calculate_checksum(new_data, new_data.attr_length)
      # extract original cksum value
      orig_cksum = Array.typed(::Java::Byte).new(cksum_size - confounder_size) { 0 }
      System.arraycopy(cksum, confounder_size, orig_cksum, 0, cksum_size - confounder_size)
      return is_checksum_equal(orig_cksum, new_cksum)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Decrypts keyed checksum.
    # @param enc_cksum the buffer for encrypted checksum.
    # @param key the key.
    # @return the checksum.
    # 
    # @modified by Yanni Zhang, 12/08/99.
    def decrypt_keyed_checksum(enc_cksum, key)
      # compute modified key
      new_key = Array.typed(::Java::Byte).new(key_size) { 0 }
      System.arraycopy(key, 0, new_key, 0, key.attr_length)
      i = 0
      while i < new_key.attr_length
        new_key[i] = (new_key[i] ^ 0xf0)
        i += 1
      end
      # check for weak keys
      begin
        if (DESKeySpec.is_weak(new_key, 0))
          new_key[7] = (new_key[7] ^ 0xf0)
        end
      rescue InvalidKeyException => ex
        # swallow, since it should never happen
      end
      ivec = Array.typed(::Java::Byte).new(new_key.attr_length) { 0 }
      cksum = Array.typed(::Java::Byte).new(enc_cksum.attr_length) { 0 }
      Des.cbc_encrypt(enc_cksum, cksum, new_key, ivec, false)
      return cksum
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Calculates checksum using MD5.
    # @param data the data used to generate the checksum.
    # @param size length of the data.
    # @return the checksum.
    # 
    # @modified by Yanni Zhang, 12/08/99.
    def calculate_checksum(data, size)
      md5 = nil
      result = nil
      begin
        md5 = MessageDigest.get_instance("MD5")
      rescue JavaException => e
        raise KrbCryptoException.new("JCE provider may not be installed. " + RJava.cast_to_string(e.get_message))
      end
      begin
        md5.update(data)
        result = md5.digest
      rescue JavaException => e
        raise KrbCryptoException.new(e.get_message)
      end
      return result
    end
    
    private
    alias_method :initialize__rsa_md5des_cksum_type, :initialize
  end
  
end
