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
  module Crc32CksumTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Util::Zip, :CRC32
    }
  end
  
  class Crc32CksumType < Crc32CksumTypeImports.const_get :CksumType
    include_class_members Crc32CksumTypeImports
    
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
      return Checksum::CKSUMTYPE_CRC32
    end
    
    typesig { [] }
    def is_safe
      return false
    end
    
    typesig { [] }
    def cksum_size
      return 4
    end
    
    typesig { [] }
    def key_type
      return Krb5::KEYTYPE_NULL
    end
    
    typesig { [] }
    def key_size
      return 0
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_checksum(data, size)
      return self.attr_crc32.byte2crc32sum_bytes(data, size)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_keyed_checksum(data, size, key, usage)
      return nil
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def verify_keyed_checksum(data, size, key, checksum, usage)
      return false
    end
    
    class_module.module_eval {
      typesig { [::Java::Long] }
      def int2quad(input)
        output = Array.typed(::Java::Byte).new(4) { 0 }
        i = 0
        while i < 4
          output[i] = ((input >> (i * 8)) & 0xff)
          i += 1
        end
        return output
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def bytes2long(input)
        result = 0
        result |= ((input[0]) & 0xff) << 24
        result |= ((input[1]) & 0xff) << 16
        result |= ((input[2]) & 0xff) << 8
        result |= ((input[3]) & 0xff)
        return result
      end
    }
    
    private
    alias_method :initialize__crc32cksum_type, :initialize
  end
  
end
