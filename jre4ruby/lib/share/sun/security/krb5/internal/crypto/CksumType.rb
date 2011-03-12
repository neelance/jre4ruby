require "rjava"

# Portions Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CksumTypeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  class CksumType 
    include_class_members CksumTypeImports
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [::Java::Int] }
      def get_instance(cksum_type_const)
        cksum_type = nil
        cksum_type_name = nil
        case (cksum_type_const)
        when Checksum::CKSUMTYPE_CRC32
          cksum_type = Crc32CksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.Crc32CksumType"
        when Checksum::CKSUMTYPE_DES_MAC
          cksum_type = DesMacCksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.DesMacCksumType"
        when Checksum::CKSUMTYPE_DES_MAC_K
          cksum_type = DesMacKCksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.DesMacKCksumType"
        when Checksum::CKSUMTYPE_RSA_MD5
          cksum_type = RsaMd5CksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.RsaMd5CksumType"
        when Checksum::CKSUMTYPE_RSA_MD5_DES
          cksum_type = RsaMd5DesCksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.RsaMd5DesCksumType"
        when Checksum::CKSUMTYPE_HMAC_SHA1_DES3_KD
          cksum_type = HmacSha1Des3KdCksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.HmacSha1Des3KdCksumType"
        when Checksum::CKSUMTYPE_HMAC_SHA1_96_AES128
          cksum_type = HmacSha1Aes128CksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.HmacSha1Aes128CksumType"
        when Checksum::CKSUMTYPE_HMAC_SHA1_96_AES256
          cksum_type = HmacSha1Aes256CksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.HmacSha1Aes256CksumType"
        when Checksum::CKSUMTYPE_HMAC_MD5_ARCFOUR
          cksum_type = HmacMd5ArcFourCksumType.new
          cksum_type_name = "sun.security.krb5.internal.crypto.HmacMd5ArcFourCksumType"
        when Checksum::CKSUMTYPE_RSA_MD4_DES_K, Checksum::CKSUMTYPE_RSA_MD4, Checksum::CKSUMTYPE_RSA_MD4_DES
          # currently we don't support MD4.
          # cksumType = new RsaMd4DesKCksumType();
          # cksumTypeName =
          #          "sun.security.krb5.internal.crypto.RsaMd4DesKCksumType";
          # cksumType = new RsaMd4CksumType();
          # linux box support rsamd4, how to solve conflict?
          # cksumTypeName =
          #          "sun.security.krb5.internal.crypto.RsaMd4CksumType";
          # cksumType = new RsaMd4DesCksumType();
          # cksumTypeName =
          #          "sun.security.krb5.internal.crypto.RsaMd4DesCksumType";
          raise KdcErrException.new(Krb5::KDC_ERR_SUMTYPE_NOSUPP)
        else
          # currently we don't support MD4.
          # cksumType = new RsaMd4DesKCksumType();
          # cksumTypeName =
          #          "sun.security.krb5.internal.crypto.RsaMd4DesKCksumType";
          # cksumType = new RsaMd4CksumType();
          # linux box support rsamd4, how to solve conflict?
          # cksumTypeName =
          #          "sun.security.krb5.internal.crypto.RsaMd4CksumType";
          # cksumType = new RsaMd4DesCksumType();
          # cksumTypeName =
          #          "sun.security.krb5.internal.crypto.RsaMd4DesCksumType";
          raise KdcErrException.new(Krb5::KDC_ERR_SUMTYPE_NOSUPP)
        end
        if (self.attr_debug)
          System.out.println(">>> CksumType: " + cksum_type_name)
        end
        return cksum_type
      end
      
      typesig { [] }
      # Returns default checksum type.
      def get_instance
        # this method provided for Kerberos applications.
        cksum_type = Checksum::CKSUMTYPE_RSA_MD5 # default
        begin
          c = Config.get_instance
          if (((cksum_type = (c.get_type(c.get_default("ap_req_checksum_type", "libdefaults"))))).equal?(-1))
            if (((cksum_type = c.get_type(c.get_default("checksum_type", "libdefaults")))).equal?(-1))
              cksum_type = Checksum::CKSUMTYPE_RSA_MD5 # default
            end
          end
        rescue KrbException => e
        end
        return get_instance(cksum_type)
      end
    }
    
    typesig { [] }
    def confounder_size
      raise NotImplementedError
    end
    
    typesig { [] }
    def cksum_type
      raise NotImplementedError
    end
    
    typesig { [] }
    def is_safe
      raise NotImplementedError
    end
    
    typesig { [] }
    def cksum_size
      raise NotImplementedError
    end
    
    typesig { [] }
    def key_type
      raise NotImplementedError
    end
    
    typesig { [] }
    def key_size
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_checksum(data, size)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    def calculate_keyed_checksum(data, size, key, usage)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def verify_keyed_checksum(data, size, key, checksum, usage)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      def is_checksum_equal(cksum1, cksum2)
        if ((cksum1).equal?(cksum2))
          return true
        end
        if (((cksum1).nil? && !(cksum2).nil?) || (!(cksum1).nil? && (cksum2).nil?))
          return false
        end
        if (!(cksum1.attr_length).equal?(cksum2.attr_length))
          return false
        end
        i = 0
        while i < cksum1.attr_length
          if (!(cksum1[i]).equal?(cksum2[i]))
            return false
          end
          i += 1
        end
        return true
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__cksum_type, :initialize
  end
  
end
