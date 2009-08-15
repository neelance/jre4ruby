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
  module DesCbcCrcETypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  class DesCbcCrcEType < DesCbcCrcETypeImports.const_get :DesCbcEType
    include_class_members DesCbcCrcETypeImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [] }
    def e_type
      return EncryptedData::ETYPE_DES_CBC_CRC
    end
    
    typesig { [] }
    def minimum_pad_size
      return 4
    end
    
    typesig { [] }
    def confounder_size
      return 8
    end
    
    typesig { [] }
    def checksum_type
      return Checksum::CKSUMTYPE_CRC32
    end
    
    typesig { [] }
    def checksum_size
      return 4
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # Encrypts data using DES in CBC mode with CRC32.
    # @param data the data to be encrypted.
    # @param key  the secret key to encrypt the data. It is also used as initialization vector during cipher block chaining.
    # @return the buffer for cipher text.
    # 
    # @written by Yanni Zhang, Dec 10, 1999
    def encrypt(data, key, usage)
      return encrypt(data, key, key, usage)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # Decrypts data with provided key using DES in CBC mode with CRC32.
    # @param cipher the cipher text to be decrypted.
    # @param key  the secret key to decrypt the data.
    # 
    # @written by Yanni Zhang, Dec 10, 1999
    def decrypt(cipher, key, usage)
      return decrypt(cipher, key, key, usage)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_checksum(data, size)
      return self.attr_crc32.byte2crc32sum_bytes(data, size)
    end
    
    private
    alias_method :initialize__des_cbc_crc_etype, :initialize
  end
  
end
