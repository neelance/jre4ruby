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
  module RsaMd5CksumTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Security
    }
  end
  
  class RsaMd5CksumType < RsaMd5CksumTypeImports.const_get :CksumType
    include_class_members RsaMd5CksumTypeImports
    
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
      return Checksum::CKSUMTYPE_RSA_MD5
    end
    
    typesig { [] }
    def is_safe
      return false
    end
    
    typesig { [] }
    def cksum_size
      return 16
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
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_keyed_checksum(data, size, key, usage)
      return nil
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def verify_keyed_checksum(data, size, key, checksum, usage)
      return false
    end
    
    private
    alias_method :initialize__rsa_md5cksum_type, :initialize
  end
  
end
