require "rjava"

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
  module ArcFourHmacImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5::Internal::Crypto::Dk, :ArcFourCrypto
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Java::Security, :GeneralSecurityException
    }
  end
  
  # Class with static methods for doing RC4-HMAC operations.
  # 
  # @author Seema Malkani
  class ArcFourHmac 
    include_class_members ArcFourHmacImports
    
    class_module.module_eval {
      const_set_lazy(:CRYPTO) { ArcFourCrypto.new(128) }
      const_attr_reader  :CRYPTO
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char)] }
      def string_to_key(password)
        return CRYPTO.string_to_key(password)
      end
      
      typesig { [] }
      # in bytes
      def get_checksum_length
        return CRYPTO.get_checksum_length
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def calculate_checksum(base_key, usage, input, start, len)
        return CRYPTO.calculate_checksum(base_key, usage, input, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Encrypt Sequence Number
      def encrypt_seq(base_key, usage, checksum, plaintext, start, len)
        return CRYPTO.encrypt_seq(base_key, usage, checksum, plaintext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Decrypt Sequence Number
      def decrypt_seq(base_key, usage, checksum, ciphertext, start, len)
        return CRYPTO.decrypt_seq(base_key, usage, checksum, ciphertext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def encrypt(base_key, usage, ivec, plaintext, start, len)
        return CRYPTO.encrypt(base_key, usage, ivec, nil, plaintext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Encrypt plaintext; do not add confounder, or checksum
      def encrypt_raw(base_key, usage, seq_num, plaintext, start, len)
        return CRYPTO.encrypt_raw(base_key, usage, seq_num, plaintext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def decrypt(base_key, usage, ivec, ciphertext, start, len)
        return CRYPTO.decrypt(base_key, usage, ivec, ciphertext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
      # Decrypt ciphertext; do not remove confounder, or check checksum
      def decrypt_raw(base_key, usage, ivec, ciphertext, start, len, seq_num)
        return CRYPTO.decrypt_raw(base_key, usage, ivec, ciphertext, start, len, seq_num)
      end
    }
    
    private
    alias_method :initialize__arc_four_hmac, :initialize
  end
  
end
