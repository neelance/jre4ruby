require "rjava"

# 
# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module HmacSha1Des3KdCksumTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
      include_const ::Javax::Crypto::Spec, :DESKeySpec
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :GeneralSecurityException
    }
  end
  
  class HmacSha1Des3KdCksumType < HmacSha1Des3KdCksumTypeImports.const_get :CksumType
    include_class_members HmacSha1Des3KdCksumTypeImports
    
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
      return Checksum::CKSUMTYPE_HMAC_SHA1_DES3_KD
    end
    
    typesig { [] }
    def is_safe
      return true
    end
    
    typesig { [] }
    def cksum_size
      return 20 # bytes
    end
    
    typesig { [] }
    def key_type
      return Krb5::KEYTYPE_DES3
    end
    
    typesig { [] }
    def key_size
      return 24 # bytes
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
    def calculate_keyed_checksum(data, size, key, usage)
      begin
        return Des3.calculate_checksum(key, usage, data, 0, size)
      rescue GeneralSecurityException => e
        ke = KrbCryptoException.new(e.get_message)
        ke.init_cause(e)
        raise ke
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Verifies keyed checksum.
    # @param data the data.
    # @param size the length of data.
    # @param key the key used to encrypt the checksum.
    # @param checksum
    # @return true if verification is successful.
    def verify_keyed_checksum(data, size, key, checksum, usage)
      begin
        new_cksum = Des3.calculate_checksum(key, usage, data, 0, size)
        return is_checksum_equal(checksum, new_cksum)
      rescue GeneralSecurityException => e
        ke = KrbCryptoException.new(e.get_message)
        ke.init_cause(e)
        raise ke
      end
    end
    
    private
    alias_method :initialize__hmac_sha1des3kd_cksum_type, :initialize
  end
  
end
