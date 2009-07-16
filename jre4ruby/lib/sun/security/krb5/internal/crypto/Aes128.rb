require "rjava"

# 
# Copyright 2004-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module Aes128Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5::Internal::Crypto::Dk, :AesDkCrypto
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Java::Security, :GeneralSecurityException
    }
  end
  
  # 
  # Class with static methods for doing AES operations.
  # 
  # @author Seema Malkani
  class Aes128 
    include_class_members Aes128Imports
    
    class_module.module_eval {
      const_set_lazy(:CRYPTO) { AesDkCrypto.new(128) }
      const_attr_reader  :CRYPTO
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char), String, Array.typed(::Java::Byte)] }
      def string_to_key(password, salt, params)
        return CRYPTO.string_to_key(password, salt, params)
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
      def encrypt(base_key, usage, ivec, plaintext, start, len)
        # new_ivec
        return CRYPTO.encrypt(base_key, usage, ivec, nil, plaintext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Encrypt plaintext; do not add confounder, or checksum
      def encrypt_raw(base_key, usage, ivec, plaintext, start, len)
        return CRYPTO.encrypt_raw(base_key, usage, ivec, plaintext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def decrypt(base_key, usage, ivec, ciphertext, start, len)
        return CRYPTO.decrypt(base_key, usage, ivec, ciphertext, start, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Decrypt ciphertext; do not remove confounder, or check checksum
      def decrypt_raw(base_key, usage, ivec, ciphertext, start, len)
        return CRYPTO.decrypt_raw(base_key, usage, ivec, ciphertext, start, len)
      end
    }
    
    private
    alias_method :initialize__aes128, :initialize
  end
  
end
