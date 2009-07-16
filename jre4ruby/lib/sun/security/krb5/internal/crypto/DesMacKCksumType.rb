require "rjava"

# 
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
  module DesMacKCksumTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
      include_const ::Javax::Crypto::Spec, :DESKeySpec
      include_const ::Java::Security, :InvalidKeyException
    }
  end
  
  class DesMacKCksumType < DesMacKCksumTypeImports.const_get :CksumType
    include_class_members DesMacKCksumTypeImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [] }
    def confounder_size
      return 0
    end
    
    typesig { [] }
    def cksum_type
      return Checksum::CKSUMTYPE_DES_MAC_K
    end
    
    typesig { [] }
    def is_safe
      return true
    end
    
    typesig { [] }
    def cksum_size
      return 16
    end
    
    typesig { [] }
    def key_type
      return Krb5::KEYTYPE_DES
    end
    
    typesig { [] }
    def key_size
      return 8
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_checksum(data, size)
      return nil
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Calculates keyed checksum.
    # @param data the data used to generate the checksum.
    # @param size length of the data.
    # @param key the key used to encrypt the checksum.
    # @return keyed checksum.
    # 
    # @modified by Yanni Zhang, 12/08/99.
    def calculate_keyed_checksum(data, size, key, usage)
      # check for weak keys
      begin
        if (DESKeySpec.is_weak(key, 0))
          key[7] = (key[7] ^ 0xf0)
        end
      rescue InvalidKeyException => ex
        # swallow, since it should never happen
      end
      ivec = Array.typed(::Java::Byte).new(key.attr_length) { 0 }
      System.arraycopy(key, 0, ivec, 0, key.attr_length)
      cksum = Des.des_cksum(ivec, data, key)
      return cksum
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def verify_keyed_checksum(data, size, key, checksum, usage)
      new_cksum = calculate_keyed_checksum(data, data.attr_length, key, usage)
      return is_checksum_equal(checksum, new_cksum)
    end
    
    private
    alias_method :initialize__des_mac_kcksum_type, :initialize
  end
  
end
