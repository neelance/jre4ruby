require "rjava"

# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ETypeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include ::Javax::Crypto
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # only needed if dataSize() implementation changes back to spec;
  # see dataSize() below
  class EType 
    include_class_members ETypeImports
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Krb5::DEBUG }
      const_attr_reader  :DEBUG
      
      typesig { [::Java::Int] }
      def get_instance(e_type_const)
        e_type = nil
        e_type_name = nil
        case (e_type_const)
        when EncryptedData::ETYPE_NULL
          e_type = NullEType.new
          e_type_name = "sun.security.krb5.internal.crypto.NullEType"
        when EncryptedData::ETYPE_DES_CBC_CRC
          e_type = DesCbcCrcEType.new
          e_type_name = "sun.security.krb5.internal.crypto.DesCbcCrcEType"
        when EncryptedData::ETYPE_DES_CBC_MD5
          e_type = DesCbcMd5EType.new
          e_type_name = "sun.security.krb5.internal.crypto.DesCbcMd5EType"
        when EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD
          e_type = Des3CbcHmacSha1KdEType.new
          e_type_name = "sun.security.krb5.internal.crypto.Des3CbcHmacSha1KdEType"
        when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
          e_type = Aes128CtsHmacSha1EType.new
          e_type_name = "sun.security.krb5.internal.crypto.Aes128CtsHmacSha1EType"
        when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
          e_type = Aes256CtsHmacSha1EType.new
          e_type_name = "sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType"
        when EncryptedData::ETYPE_ARCFOUR_HMAC
          e_type = ArcFourHmacEType.new
          e_type_name = "sun.security.krb5.internal.crypto.ArcFourHmacEType"
        else
          msg = "encryption type = " + RJava.cast_to_string(to_s(e_type_const)) + " (" + RJava.cast_to_string(e_type_const) + ")"
          raise KdcErrException.new(Krb5::KDC_ERR_ETYPE_NOSUPP, msg)
        end
        if (DEBUG)
          System.out.println(">>> EType: " + e_type_name)
        end
        return e_type
      end
    }
    
    typesig { [] }
    def e_type
      raise NotImplementedError
    end
    
    typesig { [] }
    def minimum_pad_size
      raise NotImplementedError
    end
    
    typesig { [] }
    def confounder_size
      raise NotImplementedError
    end
    
    typesig { [] }
    def checksum_type
      raise NotImplementedError
    end
    
    typesig { [] }
    def checksum_size
      raise NotImplementedError
    end
    
    typesig { [] }
    def block_size
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
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def encrypt(data, key, usage)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def encrypt(data, key, ivec, usage)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt(cipher, key, usage)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt(cipher, key, ivec, usage)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def data_size(data)
      # throws Asn1Exception
      # EncodeRef ref = new EncodeRef(data, startOfData());
      # return ref.end - startOfData();
      # should be the above according to spec, but in fact
      # implementations include the pad bytes in the data size
      return data.attr_length - start_of_data
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def pad_size(data)
      return data.attr_length - confounder_size - checksum_size - data_size(data)
    end
    
    typesig { [] }
    def start_of_checksum
      return confounder_size
    end
    
    typesig { [] }
    def start_of_data
      return confounder_size + checksum_size
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def start_of_pad(data)
      return confounder_size + checksum_size + data_size(data)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def decrypted_data(data)
      temp_size = data_size(data)
      result = Array.typed(::Java::Byte).new(temp_size) { 0 }
      System.arraycopy(data, start_of_data, result, 0, temp_size)
      return result
    end
    
    class_module.module_eval {
      const_set_lazy(:BUILTIN_ETYPES) { Array.typed(::Java::Int).new([EncryptedData::ETYPE_DES_CBC_MD5, EncryptedData::ETYPE_DES_CBC_CRC, EncryptedData::ETYPE_ARCFOUR_HMAC, EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD, EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96, EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96, ]) }
      const_attr_reader  :BUILTIN_ETYPES
      
      const_set_lazy(:BUILTIN_ETYPES_NOAES256) { Array.typed(::Java::Int).new([EncryptedData::ETYPE_DES_CBC_MD5, EncryptedData::ETYPE_DES_CBC_CRC, EncryptedData::ETYPE_ARCFOUR_HMAC, EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD, EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96, ]) }
      const_attr_reader  :BUILTIN_ETYPES_NOAES256
      
      typesig { [] }
      # used in Config
      def get_built_in_defaults
        allowed = 0
        begin
          allowed = Cipher.get_max_allowed_key_length("AES")
        rescue JavaException => e
          # should not happen
        end
        if (allowed < 256)
          return BUILTIN_ETYPES_NOAES256
        end
        return BUILTIN_ETYPES
      end
      
      typesig { [String] }
      # Retrieves the default etypes from the configuration file, or
      # if that's not available, return the built-in list of default etypes.
      # 
      # used in KrbAsReq, KeyTab
      def get_defaults(config_name)
        begin
          return Config.get_instance.default_etype(config_name)
        rescue KrbException => exc
          if (DEBUG)
            System.out.println("Exception while getting " + config_name + RJava.cast_to_string(exc.get_message))
            System.out.println("Using defaults " + "des-cbc-md5, des-cbc-crc, des3-cbc-sha1," + " aes128cts, aes256cts, rc4-hmac")
          end
          return get_built_in_defaults
        end
      end
      
      typesig { [String, Array.typed(EncryptionKey)] }
      # Retrieve the default etypes from the configuration file for
      # those etypes for which there are corresponding keys.
      # Used in scenario we have some keys from a keytab with etypes
      # different from those named in configName. Then, in order
      # to decrypt an AS-REP, we should only ask for etypes for which
      # we have keys.
      def get_defaults(config_name, keys)
        answer = get_defaults(config_name)
        if ((answer).nil?)
          raise KrbException.new("No supported encryption types listed in " + config_name)
        end
        list = ArrayList.new(answer.attr_length)
        i = 0
        while i < answer.attr_length
          if (!(EncryptionKey.find_key(answer[i], keys)).nil?)
            list.add(answer[i])
          end
          i += 1
        end
        len = list.size
        if (len <= 0)
          keystr = StringBuffer.new
          i_ = 0
          while i_ < keys.attr_length
            keystr.append(to_s(keys[i_].get_etype))
            keystr.append(" ")
            i_ += 1
          end
          raise KrbException.new("Do not have keys of types listed in " + config_name + " available; only have keys of following type: " + RJava.cast_to_string(keystr.to_s))
        else
          answer = Array.typed(::Java::Int).new(len) { 0 }
          i_ = 0
          while i_ < len
            answer[i_] = list.get(i_)
            i_ += 1
          end
          return answer
        end
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Int)] }
      def is_supported(e_type_const, config)
        i = 0
        while i < config.attr_length
          if ((e_type_const).equal?(config[i]))
            return true
          end
          i += 1
        end
        return false
      end
      
      typesig { [::Java::Int] }
      def is_supported(e_type_const)
        enabled_etypes = get_built_in_defaults
        return is_supported(e_type_const, enabled_etypes)
      end
      
      typesig { [::Java::Int] }
      def to_s(type)
        case (type)
        when 0
          return "NULL"
        when 1
          return "DES CBC mode with CRC-32"
        when 2
          return "DES CBC mode with MD4"
        when 3
          return "DES CBC mode with MD5"
        when 4
          return "reserved"
        when 5
          return "DES3 CBC mode with MD5"
        when 6
          return "reserved"
        when 7
          return "DES3 CBC mode with SHA1"
        when 9
          return "DSA with SHA1- Cms0ID"
        when 10
          return "MD5 with RSA encryption - Cms0ID"
        when 11
          return "SHA1 with RSA encryption - Cms0ID"
        when 12
          return "RC2 CBC mode with Env0ID"
        when 13
          return "RSA encryption with Env0ID"
        when 14
          return "RSAES-0AEP-ENV-0ID"
        when 15
          return "DES-EDE3-CBC-ENV-0ID"
        when 16
          return "DES3 CBC mode with SHA1-KD"
        when 17
          return "AES128 CTS mode with HMAC SHA1-96"
        when 18
          return "AES256 CTS mode with HMAC SHA1-96"
        when 23
          return "RC4 with HMAC"
        when 24
          return "RC4 with HMAC EXP"
        end
        return "Unknown (" + RJava.cast_to_string(type) + ")"
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__etype, :initialize
  end
  
end
