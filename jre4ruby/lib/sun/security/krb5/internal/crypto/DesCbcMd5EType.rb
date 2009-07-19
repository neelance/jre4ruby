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
  module DesCbcMd5ETypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Security
    }
  end
  
  class DesCbcMd5EType < DesCbcMd5ETypeImports.const_get :DesCbcEType
    include_class_members DesCbcMd5ETypeImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [] }
    def e_type
      return EncryptedData::ETYPE_DES_CBC_MD5
    end
    
    typesig { [] }
    def minimum_pad_size
      return 0
    end
    
    typesig { [] }
    def confounder_size
      return 8
    end
    
    typesig { [] }
    def checksum_type
      return Checksum::CKSUMTYPE_RSA_MD5
    end
    
    typesig { [] }
    def checksum_size
      return 16
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Calculates checksum using MD5.
    # @param data the input data.
    # @param size the length of data.
    # @return the checksum.
    # 
    # @modified by Yanni Zhang, 12/06/99.
    def calculate_checksum(data, size)
      md5 = nil
      begin
        md5 = MessageDigest.get_instance("MD5")
      rescue Exception => e
        raise KrbCryptoException.new("JCE provider may not be installed. " + (e.get_message).to_s)
      end
      begin
        md5.update(data)
        return (md5.digest)
      rescue Exception => e
        raise KrbCryptoException.new(e.get_message)
      end
    end
    
    private
    alias_method :initialize__des_cbc_md5etype, :initialize
  end
  
end
