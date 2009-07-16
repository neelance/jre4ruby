require "rjava"

# 
# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal::Crypto
  module ArcFourHmacETypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :Checksum
    }
  end
  
  # 
  # This class encapsulates the encryption type for RC4-HMAC
  # 
  # @author Seema Malkani
  class ArcFourHmacEType < ArcFourHmacETypeImports.const_get :EType
    include_class_members ArcFourHmacETypeImports
    
    typesig { [] }
    def e_type
      return EncryptedData::ETYPE_ARCFOUR_HMAC
    end
    
    typesig { [] }
    def minimum_pad_size
      return 1
    end
    
    typesig { [] }
    def confounder_size
      return 8
    end
    
    typesig { [] }
    def checksum_type
      return Checksum::CKSUMTYPE_HMAC_MD5_ARCFOUR
    end
    
    typesig { [] }
    def checksum_size
      return ArcFourHmac.get_checksum_length
    end
    
    typesig { [] }
    def block_size
      return 1
    end
    
    typesig { [] }
    def key_type
      return Krb5::KEYTYPE_ARCFOUR_HMAC
    end
    
    typesig { [] }
    def key_size
      return 16 # bytes
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def encrypt(data, key, usage)
      ivec = Array.typed(::Java::Byte).new(block_size) { 0 }
      return encrypt(data, key, ivec, usage)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def encrypt(data, key, ivec, usage)
      begin
        return ArcFourHmac.encrypt(key, usage, ivec, data, 0, data.attr_length)
      rescue GeneralSecurityException => e
        ke = KrbCryptoException.new(e.get_message)
        ke.init_cause(e)
        raise ke
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt(cipher, key, usage)
      ivec = Array.typed(::Java::Byte).new(block_size) { 0 }
      return decrypt(cipher, key, ivec, usage)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt(cipher, key, ivec, usage)
      begin
        return ArcFourHmac.decrypt(key, usage, ivec, cipher, 0, cipher.attr_length)
      rescue GeneralSecurityException => e
        ke = KrbCryptoException.new(e.get_message)
        ke.init_cause(e)
        raise ke
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Override default, because our decrypted data does not return confounder
    # Should eventually get rid of EType.decryptedData and
    # EncryptedData.decryptedData altogether
    def decrypted_data(data)
      return data
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__arc_four_hmac_etype, :initialize
  end
  
end
