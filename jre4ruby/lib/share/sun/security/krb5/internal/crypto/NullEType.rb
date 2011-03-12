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
  module NullETypeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :EncryptedData
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  class NullEType < NullETypeImports.const_get :EType
    include_class_members NullETypeImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [] }
    def e_type
      return EncryptedData::ETYPE_NULL
    end
    
    typesig { [] }
    def minimum_pad_size
      return 0
    end
    
    typesig { [] }
    def confounder_size
      return 0
    end
    
    typesig { [] }
    def checksum_type
      return Checksum::CKSUMTYPE_NULL
    end
    
    typesig { [] }
    def checksum_size
      return 0
    end
    
    typesig { [] }
    def block_size
      return 1
    end
    
    typesig { [] }
    def key_type
      return Krb5::KEYTYPE_NULL
    end
    
    typesig { [] }
    def key_size
      return 0
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def encrypt(data, key, usage)
      cipher = Array.typed(::Java::Byte).new(data.attr_length) { 0 }
      System.arraycopy(data, 0, cipher, 0, data.attr_length)
      return cipher
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def encrypt(data, key, ivec, usage)
      cipher = Array.typed(::Java::Byte).new(data.attr_length) { 0 }
      System.arraycopy(data, 0, cipher, 0, data.attr_length)
      return cipher
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt(cipher, key, usage)
      return cipher.clone
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt(cipher, key, ivec, usage)
      return cipher.clone
    end
    
    private
    alias_method :initialize__null_etype, :initialize
  end
  
end
