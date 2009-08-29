require "rjava"

# Copyright 2004-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Krb5
  module CipherHelperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :IvParameterSpec
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include_const ::Javax::Crypto, :CipherInputStream
      include_const ::Javax::Crypto, :CipherOutputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5::Internal::Crypto, :Des3
      include_const ::Sun::Security::Krb5::Internal::Crypto, :Aes128
      include_const ::Sun::Security::Krb5::Internal::Crypto, :Aes256
      include_const ::Sun::Security::Krb5::Internal::Crypto, :ArcFourHmac
    }
  end
  
  class CipherHelper 
    include_class_members CipherHelperImports
    
    class_module.module_eval {
      # From draft-raeburn-cat-gssapi-krb5-3des-00
      # Key usage values when deriving keys
      const_set_lazy(:KG_USAGE_SEAL) { 22 }
      const_attr_reader  :KG_USAGE_SEAL
      
      const_set_lazy(:KG_USAGE_SIGN) { 23 }
      const_attr_reader  :KG_USAGE_SIGN
      
      const_set_lazy(:KG_USAGE_SEQ) { 24 }
      const_attr_reader  :KG_USAGE_SEQ
      
      const_set_lazy(:DES_CHECKSUM_SIZE) { 8 }
      const_attr_reader  :DES_CHECKSUM_SIZE
      
      const_set_lazy(:DES_IV_SIZE) { 8 }
      const_attr_reader  :DES_IV_SIZE
      
      const_set_lazy(:AES_IV_SIZE) { 16 }
      const_attr_reader  :AES_IV_SIZE
      
      # ARCFOUR-HMAC
      # Save first 8 octets of HMAC Sgn_Cksum
      const_set_lazy(:HMAC_CHECKSUM_SIZE) { 8 }
      const_attr_reader  :HMAC_CHECKSUM_SIZE
      
      # key usage for MIC tokens used by MS
      const_set_lazy(:KG_USAGE_SIGN_MS) { 15 }
      const_attr_reader  :KG_USAGE_SIGN_MS
      
      # debug flag
      const_set_lazy(:DEBUG) { Krb5Util::DEBUG }
      const_attr_reader  :DEBUG
      
      # A zero initial vector to be used for checksum calculation and for
      # DesCbc application data encryption/decryption.
      const_set_lazy(:ZERO_IV) { Array.typed(::Java::Byte).new(DES_IV_SIZE) { 0 } }
      const_attr_reader  :ZERO_IV
      
      const_set_lazy(:ZERO_IV_AES) { Array.typed(::Java::Byte).new(AES_IV_SIZE) { 0 } }
      const_attr_reader  :ZERO_IV_AES
    }
    
    attr_accessor :etype
    alias_method :attr_etype, :etype
    undef_method :etype
    alias_method :attr_etype=, :etype=
    undef_method :etype=
    
    attr_accessor :sgn_alg
    alias_method :attr_sgn_alg, :sgn_alg
    undef_method :sgn_alg
    alias_method :attr_sgn_alg=, :sgn_alg=
    undef_method :sgn_alg=
    
    attr_accessor :seal_alg
    alias_method :attr_seal_alg, :seal_alg
    undef_method :seal_alg
    alias_method :attr_seal_alg=, :seal_alg=
    undef_method :seal_alg=
    
    attr_accessor :keybytes
    alias_method :attr_keybytes, :keybytes
    undef_method :keybytes
    alias_method :attr_keybytes=, :keybytes=
    undef_method :keybytes=
    
    # new token format from draft-ietf-krb-wg-gssapi-cfx-07
    # proto is used to determine new GSS token format for "newer" etypes
    attr_accessor :proto
    alias_method :attr_proto, :proto
    undef_method :proto
    alias_method :attr_proto=, :proto=
    undef_method :proto=
    
    typesig { [EncryptionKey] }
    def initialize(key)
      @etype = 0
      @sgn_alg = 0
      @seal_alg = 0
      @keybytes = nil
      @proto = 0
      @etype = key.get_etype
      @keybytes = key.get_bytes
      case (@etype)
      when EncryptedData::ETYPE_DES_CBC_CRC, EncryptedData::ETYPE_DES_CBC_MD5
        @sgn_alg = MessageToken::SGN_ALG_DES_MAC_MD5
        @seal_alg = MessageToken::SEAL_ALG_DES
      when EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD
        @sgn_alg = MessageToken::SGN_ALG_HMAC_SHA1_DES3_KD
        @seal_alg = MessageToken::SEAL_ALG_DES3_KD
      when EncryptedData::ETYPE_ARCFOUR_HMAC
        @sgn_alg = MessageToken::SGN_ALG_HMAC_MD5_ARCFOUR
        @seal_alg = MessageToken::SEAL_ALG_ARCFOUR_HMAC
      when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96, EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
        @sgn_alg = -1
        @seal_alg = -1
        @proto = 1
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported encryption type: " + RJava.cast_to_string(@etype))
      end
    end
    
    typesig { [] }
    def get_sgn_alg
      return @sgn_alg
    end
    
    typesig { [] }
    def get_seal_alg
      return @seal_alg
    end
    
    typesig { [] }
    def get_proto
      return @proto
    end
    
    typesig { [] }
    def get_etype
      return @etype
    end
    
    typesig { [] }
    def is_arc_four
      flag = false
      if ((@etype).equal?(EncryptedData::ETYPE_ARCFOUR_HMAC))
        flag = true
      end
      return flag
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
    def calculate_checksum(alg, header, trailer, data, start, len, token_id)
      case (alg)
      # fall through to encrypt checksum
      when MessageToken::SGN_ALG_DES_MAC_MD5
        # With this sign algorithm, first an MD5 hash is computed on the
        # application data. The 16 byte hash is then DesCbc encrypted.
        begin
          md5 = MessageDigest.get_instance("MD5")
          # debug("\t\tdata=[");
          # debug(getHexBytes(checksumDataHeader,
          # checksumDataHeader.length) + " ");
          md5.update(header)
          # debug(getHexBytes(data, start, len));
          md5.update(data, start, len)
          if (!(trailer).nil?)
            # debug(" " +
            # getHexBytes(trailer,
            # optionalTrailer.length));
            md5.update(trailer)
          end
          # debug("]\n");
          data = md5.digest
          start = 0
          len = data.attr_length
          # System.out.println("\tMD5 Checksum is [" +
          # getHexBytes(data) + "]\n");
          header = nil
          trailer = nil
        rescue NoSuchAlgorithmException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not get MD5 Message Digest - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        return get_des_cbc_checksum(@keybytes, header, data, start, len)
      when MessageToken::SGN_ALG_DES_MAC
        return get_des_cbc_checksum(@keybytes, header, data, start, len)
      when MessageToken::SGN_ALG_HMAC_SHA1_DES3_KD
        buf = nil
        offset = 0
        total = 0
        if ((header).nil? && (trailer).nil?)
          buf = data
          total = len
          offset = start
        else
          total = ((!(header).nil? ? header.attr_length : 0) + len + (!(trailer).nil? ? trailer.attr_length : 0))
          buf = Array.typed(::Java::Byte).new(total) { 0 }
          pos = 0
          if (!(header).nil?)
            System.arraycopy(header, 0, buf, 0, header.attr_length)
            pos = header.attr_length
          end
          System.arraycopy(data, start, buf, pos, len)
          pos += len
          if (!(trailer).nil?)
            System.arraycopy(trailer, 0, buf, pos, trailer.attr_length)
          end
          offset = 0
        end
        begin
          # Krb5Token.debug("\nkeybytes: " +
          # Krb5Token.getHexBytes(keybytes));
          # Krb5Token.debug("\nheader: " + (header == null ? "NONE" :
          # Krb5Token.getHexBytes(header)));
          # Krb5Token.debug("\ntrailer: " + (trailer == null ? "NONE" :
          # Krb5Token.getHexBytes(trailer)));
          # Krb5Token.debug("\ndata: " +
          # Krb5Token.getHexBytes(data, start, len));
          # Krb5Token.debug("\nbuf: " + Krb5Token.getHexBytes(buf, offset,
          # total));
          answer = Des3.calculate_checksum(@keybytes, KG_USAGE_SIGN, buf, offset, total)
          # Krb5Token.debug("\nanswer: " +
          # Krb5Token.getHexBytes(answer));
          return answer
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not use HMAC-SHA1-DES3-KD signing algorithm - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        buffer = nil
        off = 0
        tot = 0
        if ((header).nil? && (trailer).nil?)
          buffer = data
          tot = len
          off = start
        else
          tot = ((!(header).nil? ? header.attr_length : 0) + len + (!(trailer).nil? ? trailer.attr_length : 0))
          buffer = Array.typed(::Java::Byte).new(tot) { 0 }
          pos = 0
          if (!(header).nil?)
            System.arraycopy(header, 0, buffer, 0, header.attr_length)
            pos = header.attr_length
          end
          System.arraycopy(data, start, buffer, pos, len)
          pos += len
          if (!(trailer).nil?)
            System.arraycopy(trailer, 0, buffer, pos, trailer.attr_length)
          end
          off = 0
        end
        begin
          # Krb5Token.debug("\nkeybytes: " +
          # Krb5Token.getHexBytes(keybytes));
          # Krb5Token.debug("\nheader: " + (header == null ? "NONE" :
          # Krb5Token.getHexBytes(header)));
          # Krb5Token.debug("\ntrailer: " + (trailer == null ? "NONE" :
          # Krb5Token.getHexBytes(trailer)));
          # Krb5Token.debug("\ndata: " +
          # Krb5Token.getHexBytes(data, start, len));
          # Krb5Token.debug("\nbuffer: " +
          # Krb5Token.getHexBytes(buffer, off, tot));
          # 
          # for MIC tokens, key derivation salt is 15
          # NOTE: Required for interoperability. The RC4-HMAC spec
          # defines key_usage of 23, however all Kerberos impl.
          # MS/Solaris/MIT all use key_usage of 15 for MIC tokens
          key_usage = KG_USAGE_SIGN
          if ((token_id).equal?(Krb5Token::MIC_ID))
            key_usage = KG_USAGE_SIGN_MS
          end
          answer_ = ArcFourHmac.calculate_checksum(@keybytes, key_usage, buffer, off, tot)
          # Krb5Token.debug("\nanswer: " +
          # Krb5Token.getHexBytes(answer));
          # Save first 8 octets of HMAC Sgn_Cksum
          output = Array.typed(::Java::Byte).new(get_checksum_length) { 0 }
          System.arraycopy(answer_, 0, output, 0, output.attr_length)
          # Krb5Token.debug("\nanswer (trimmed): " +
          # Krb5Token.getHexBytes(output));
          return output
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not use HMAC_MD5_ARCFOUR signing algorithm - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      when MessageToken::SGN_ALG_HMAC_MD5_ARCFOUR
        buffer = nil
        off = 0
        tot = 0
        if ((header).nil? && (trailer).nil?)
          buffer = data
          tot = len
          off = start
        else
          tot = ((!(header).nil? ? header.attr_length : 0) + len + (!(trailer).nil? ? trailer.attr_length : 0))
          buffer = Array.typed(::Java::Byte).new(tot) { 0 }
          pos = 0
          if (!(header).nil?)
            System.arraycopy(header, 0, buffer, 0, header.attr_length)
            pos = header.attr_length
          end
          System.arraycopy(data, start, buffer, pos, len)
          pos += len
          if (!(trailer).nil?)
            System.arraycopy(trailer, 0, buffer, pos, trailer.attr_length)
          end
          off = 0
        end
        begin
          # Krb5Token.debug("\nkeybytes: " +
          # Krb5Token.getHexBytes(keybytes));
          # Krb5Token.debug("\nheader: " + (header == null ? "NONE" :
          # Krb5Token.getHexBytes(header)));
          # Krb5Token.debug("\ntrailer: " + (trailer == null ? "NONE" :
          # Krb5Token.getHexBytes(trailer)));
          # Krb5Token.debug("\ndata: " +
          # Krb5Token.getHexBytes(data, start, len));
          # Krb5Token.debug("\nbuffer: " +
          # Krb5Token.getHexBytes(buffer, off, tot));
          # 
          # for MIC tokens, key derivation salt is 15
          # NOTE: Required for interoperability. The RC4-HMAC spec
          # defines key_usage of 23, however all Kerberos impl.
          # MS/Solaris/MIT all use key_usage of 15 for MIC tokens
          key_usage = KG_USAGE_SIGN
          if ((token_id).equal?(Krb5Token::MIC_ID))
            key_usage = KG_USAGE_SIGN_MS
          end
          answer = ArcFourHmac.calculate_checksum(@keybytes, key_usage, buffer, off, tot)
          # Krb5Token.debug("\nanswer: " +
          # Krb5Token.getHexBytes(answer));
          # Save first 8 octets of HMAC Sgn_Cksum
          output = Array.typed(::Java::Byte).new(get_checksum_length) { 0 }
          System.arraycopy(answer, 0, output, 0, output.attr_length)
          # Krb5Token.debug("\nanswer (trimmed): " +
          # Krb5Token.getHexBytes(output));
          return output
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not use HMAC_MD5_ARCFOUR signing algorithm - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
    # calculate Checksum for the new GSS tokens
    def calculate_checksum(header, data, start, len, key_usage)
      # total length
      total = ((!(header).nil? ? header.attr_length : 0) + len)
      # get_mic("plaintext-data" | "header")
      buf = Array.typed(::Java::Byte).new(total) { 0 }
      # data
      System.arraycopy(data, start, buf, 0, len)
      # token header
      if (!(header).nil?)
        System.arraycopy(header, 0, buf, len, header.attr_length)
      end
      # Krb5Token.debug("\nAES calculate checksum on: " +
      # Krb5Token.getHexBytes(buf));
      case (@etype)
      when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
        begin
          answer = Aes128.calculate_checksum(@keybytes, key_usage, buf, 0, total)
          # Krb5Token.debug("\nAES128 checksum: " +
          # Krb5Token.getHexBytes(answer));
          return answer
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not use AES128 signing algorithm - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        begin
          answer_ = Aes256.calculate_checksum(@keybytes, key_usage, buf, 0, total)
          # Krb5Token.debug("\nAES256 checksum: " +
          # Krb5Token.getHexBytes(answer));
          return answer_
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not use AES256 signing algorithm - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported encryption type: " + RJava.cast_to_string(@etype))
      when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
        begin
          answer = Aes256.calculate_checksum(@keybytes, key_usage, buf, 0, total)
          # Krb5Token.debug("\nAES256 checksum: " +
          # Krb5Token.getHexBytes(answer));
          return answer
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not use AES256 signing algorithm - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported encryption type: " + RJava.cast_to_string(@etype))
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported encryption type: " + RJava.cast_to_string(@etype))
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def encrypt_seq(ivec, plaintext, start, len)
      case (@sgn_alg)
      when MessageToken::SGN_ALG_DES_MAC_MD5, MessageToken::SGN_ALG_DES_MAC
        begin
          des = get_initialized_des(true, @keybytes, ivec)
          return des.do_final(plaintext, start, len)
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not encrypt sequence number using DES - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        iv = nil
        if ((ivec.attr_length).equal?(DES_IV_SIZE))
          iv = ivec
        else
          iv = Array.typed(::Java::Byte).new(DES_IV_SIZE) { 0 }
          System.arraycopy(ivec, 0, iv, 0, DES_IV_SIZE)
        end
        begin
          return Des3.encrypt_raw(@keybytes, KG_USAGE_SEQ, iv, plaintext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not encrypt sequence number using DES3-KD - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        # ivec passed is the checksum
        checksum = nil
        if ((ivec.attr_length).equal?(HMAC_CHECKSUM_SIZE))
          checksum = ivec
        else
          checksum = Array.typed(::Java::Byte).new(HMAC_CHECKSUM_SIZE) { 0 }
          System.arraycopy(ivec, 0, checksum, 0, HMAC_CHECKSUM_SIZE)
        end
        begin
          return ArcFourHmac.encrypt_seq(@keybytes, KG_USAGE_SEQ, checksum, plaintext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not encrypt sequence number using RC4-HMAC - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      when MessageToken::SGN_ALG_HMAC_SHA1_DES3_KD
        iv = nil
        if ((ivec.attr_length).equal?(DES_IV_SIZE))
          iv = ivec
        else
          iv = Array.typed(::Java::Byte).new(DES_IV_SIZE) { 0 }
          System.arraycopy(ivec, 0, iv, 0, DES_IV_SIZE)
        end
        begin
          return Des3.encrypt_raw(@keybytes, KG_USAGE_SEQ, iv, plaintext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not encrypt sequence number using DES3-KD - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        # ivec passed is the checksum
        checksum = nil
        if ((ivec.attr_length).equal?(HMAC_CHECKSUM_SIZE))
          checksum = ivec
        else
          checksum = Array.typed(::Java::Byte).new(HMAC_CHECKSUM_SIZE) { 0 }
          System.arraycopy(ivec, 0, checksum, 0, HMAC_CHECKSUM_SIZE)
        end
        begin
          return ArcFourHmac.encrypt_seq(@keybytes, KG_USAGE_SEQ, checksum, plaintext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not encrypt sequence number using RC4-HMAC - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      when MessageToken::SGN_ALG_HMAC_MD5_ARCFOUR
        # ivec passed is the checksum
        checksum = nil
        if ((ivec.attr_length).equal?(HMAC_CHECKSUM_SIZE))
          checksum = ivec
        else
          checksum = Array.typed(::Java::Byte).new(HMAC_CHECKSUM_SIZE) { 0 }
          System.arraycopy(ivec, 0, checksum, 0, HMAC_CHECKSUM_SIZE)
        end
        begin
          return ArcFourHmac.encrypt_seq(@keybytes, KG_USAGE_SEQ, checksum, plaintext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not encrypt sequence number using RC4-HMAC - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def decrypt_seq(ivec, ciphertext, start, len)
      case (@sgn_alg)
      when MessageToken::SGN_ALG_DES_MAC_MD5, MessageToken::SGN_ALG_DES_MAC
        begin
          des = get_initialized_des(false, @keybytes, ivec)
          return des.do_final(ciphertext, start, len)
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not decrypt sequence number using DES - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        iv = nil
        if ((ivec.attr_length).equal?(DES_IV_SIZE))
          iv = ivec
        else
          iv = Array.typed(::Java::Byte).new(8) { 0 }
          System.arraycopy(ivec, 0, iv, 0, DES_IV_SIZE)
        end
        begin
          return Des3.decrypt_raw(@keybytes, KG_USAGE_SEQ, iv, ciphertext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not decrypt sequence number using DES3-KD - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        # ivec passed is the checksum
        checksum = nil
        if ((ivec.attr_length).equal?(HMAC_CHECKSUM_SIZE))
          checksum = ivec
        else
          checksum = Array.typed(::Java::Byte).new(HMAC_CHECKSUM_SIZE) { 0 }
          System.arraycopy(ivec, 0, checksum, 0, HMAC_CHECKSUM_SIZE)
        end
        begin
          return ArcFourHmac.decrypt_seq(@keybytes, KG_USAGE_SEQ, checksum, ciphertext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not decrypt sequence number using RC4-HMAC - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      when MessageToken::SGN_ALG_HMAC_SHA1_DES3_KD
        iv = nil
        if ((ivec.attr_length).equal?(DES_IV_SIZE))
          iv = ivec
        else
          iv = Array.typed(::Java::Byte).new(8) { 0 }
          System.arraycopy(ivec, 0, iv, 0, DES_IV_SIZE)
        end
        begin
          return Des3.decrypt_raw(@keybytes, KG_USAGE_SEQ, iv, ciphertext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not decrypt sequence number using DES3-KD - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        # ivec passed is the checksum
        checksum = nil
        if ((ivec.attr_length).equal?(HMAC_CHECKSUM_SIZE))
          checksum = ivec
        else
          checksum = Array.typed(::Java::Byte).new(HMAC_CHECKSUM_SIZE) { 0 }
          System.arraycopy(ivec, 0, checksum, 0, HMAC_CHECKSUM_SIZE)
        end
        begin
          return ArcFourHmac.decrypt_seq(@keybytes, KG_USAGE_SEQ, checksum, ciphertext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not decrypt sequence number using RC4-HMAC - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      when MessageToken::SGN_ALG_HMAC_MD5_ARCFOUR
        # ivec passed is the checksum
        checksum = nil
        if ((ivec.attr_length).equal?(HMAC_CHECKSUM_SIZE))
          checksum = ivec
        else
          checksum = Array.typed(::Java::Byte).new(HMAC_CHECKSUM_SIZE) { 0 }
          System.arraycopy(ivec, 0, checksum, 0, HMAC_CHECKSUM_SIZE)
        end
        begin
          return ArcFourHmac.decrypt_seq(@keybytes, KG_USAGE_SEQ, checksum, ciphertext, start, len)
        rescue JavaException => e
          # GeneralSecurityException, KrbCryptoException
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not decrypt sequence number using RC4-HMAC - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported signing algorithm: " + RJava.cast_to_string(@sgn_alg))
      end
    end
    
    typesig { [] }
    def get_checksum_length
      case (@etype)
      when EncryptedData::ETYPE_DES_CBC_CRC, EncryptedData::ETYPE_DES_CBC_MD5
        return DES_CHECKSUM_SIZE
      when EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD
        return Des3.get_checksum_length
      when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
        return Aes128.get_checksum_length
      when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
        return Aes256.get_checksum_length
      when EncryptedData::ETYPE_ARCFOUR_HMAC
        # only first 8 octets of HMAC Sgn_Cksum are used
        return HMAC_CHECKSUM_SIZE
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported encryption type: " + RJava.cast_to_string(@etype))
      end
    end
    
    typesig { [WrapToken, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt_data(token, ciphertext, c_start, c_len, plaintext, p_start)
      # Krb5Token.debug("decryptData : ciphertext =  " +
      # Krb5Token.getHexBytes(ciphertext));
      case (@seal_alg)
      when MessageToken::SEAL_ALG_DES
        des_cbc_decrypt(token, get_des_encryption_key(@keybytes), ciphertext, c_start, c_len, plaintext, p_start)
      when MessageToken::SEAL_ALG_DES3_KD
        des3_kd_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start)
      when MessageToken::SEAL_ALG_ARCFOUR_HMAC
        arc_four_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported seal algorithm: " + RJava.cast_to_string(@seal_alg))
      end
    end
    
    typesig { [WrapToken_v2, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # decrypt data in the new GSS tokens
    def decrypt_data(token, ciphertext, c_start, c_len, plaintext, p_start, key_usage)
      # Krb5Token.debug("decryptData : ciphertext =  " +
      # Krb5Token.getHexBytes(ciphertext));
      case (@etype)
      when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
        aes128_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start, key_usage)
      when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
        aes256_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start, key_usage)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported etype: " + RJava.cast_to_string(@etype))
      end
    end
    
    typesig { [WrapToken, InputStream, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    def decrypt_data(token, cipher_stream, c_len, plaintext, p_start)
      case (@seal_alg)
      when MessageToken::SEAL_ALG_DES
        des_cbc_decrypt(token, get_des_encryption_key(@keybytes), cipher_stream, c_len, plaintext, p_start)
      when MessageToken::SEAL_ALG_DES3_KD
        # Read encrypted data from stream
        ciphertext = Array.typed(::Java::Byte).new(c_len) { 0 }
        begin
          Krb5Token.read_fully(cipher_stream, ciphertext, 0, c_len)
        rescue IOException => e
          ge = GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Cannot read complete token")
          ge.init_cause(e)
          raise ge
        end
        des3_kd_decrypt(token, ciphertext, 0, c_len, plaintext, p_start)
      when MessageToken::SEAL_ALG_ARCFOUR_HMAC
        # Read encrypted data from stream
        ctext = Array.typed(::Java::Byte).new(c_len) { 0 }
        begin
          Krb5Token.read_fully(cipher_stream, ctext, 0, c_len)
        rescue IOException => e
          ge = GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Cannot read complete token")
          ge.init_cause(e)
          raise ge
        end
        arc_four_decrypt(token, ctext, 0, c_len, plaintext, p_start)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported seal algorithm: " + RJava.cast_to_string(@seal_alg))
      end
    end
    
    typesig { [WrapToken_v2, InputStream, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def decrypt_data(token, cipher_stream, c_len, plaintext, p_start, key_usage)
      # Read encrypted data from stream
      ciphertext = Array.typed(::Java::Byte).new(c_len) { 0 }
      begin
        Krb5Token.read_fully(cipher_stream, ciphertext, 0, c_len)
      rescue IOException => e
        ge = GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Cannot read complete token")
        ge.init_cause(e)
        raise ge
      end
      case (@etype)
      when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
        aes128_decrypt(token, ciphertext, 0, c_len, plaintext, p_start, key_usage)
      when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
        aes256_decrypt(token, ciphertext, 0, c_len, plaintext, p_start, key_usage)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported etype: " + RJava.cast_to_string(@etype))
      end
    end
    
    typesig { [WrapToken, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), OutputStream] }
    def encrypt_data(token, confounder, plaintext, start, len, padding, os)
      case (@seal_alg)
      when MessageToken::SEAL_ALG_DES
        # Encrypt on the fly and write
        des = get_initialized_des(true, get_des_encryption_key(@keybytes), ZERO_IV)
        cos = CipherOutputStream.new(os, des)
        # debug(getHexBytes(confounder, confounder.length));
        cos.write(confounder)
        # debug(" " + getHexBytes(plaintext, start, len));
        cos.write(plaintext, start, len)
        # debug(" " + getHexBytes(padding, padding.length));
        cos.write(padding)
      when MessageToken::SEAL_ALG_DES3_KD
        ctext = des3_kd_encrypt(confounder, plaintext, start, len, padding)
        # Write to stream
        os.write(ctext)
      when MessageToken::SEAL_ALG_ARCFOUR_HMAC
        ciphertext = arc_four_encrypt(token, confounder, plaintext, start, len, padding)
        # Write to stream
        os.write(ciphertext)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported seal algorithm: " + RJava.cast_to_string(@seal_alg))
      end
    end
    
    typesig { [WrapToken_v2, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int, OutputStream] }
    # Encrypt data in the new GSS tokens
    # 
    # Wrap Tokens (with confidentiality)
    # { Encrypt(16-byte confounder | plaintext | 16-byte token_header) |
    # 12-byte HMAC }
    # where HMAC is on {16-byte confounder | plaintext | 16-byte token_header}
    # HMAC is not encrypted; it is appended at the end.
    def encrypt_data(token, confounder, token_header, plaintext, start, len, key_usage, os)
      ctext = nil
      case (@etype)
      when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
        ctext = aes128_encrypt(confounder, token_header, plaintext, start, len, key_usage)
      when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
        ctext = aes256_encrypt(confounder, token_header, plaintext, start, len, key_usage)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported etype: " + RJava.cast_to_string(@etype))
      end
      # Krb5Token.debug("EncryptedData = " +
      # Krb5Token.getHexBytes(ctext) + "\n");
      # Write to stream
      os.write(ctext)
    end
    
    typesig { [WrapToken, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def encrypt_data(token, confounder, plaintext, p_start, p_len, padding, ciphertext, c_start)
      case (@seal_alg)
      when MessageToken::SEAL_ALG_DES
        pos = c_start
        # Encrypt and write
        des = get_initialized_des(true, get_des_encryption_key(@keybytes), ZERO_IV)
        begin
          # debug(getHexBytes(confounder, confounder.length));
          pos += des.update(confounder, 0, confounder.attr_length, ciphertext, pos)
          # debug(" " + getHexBytes(dataBytes, dataOffset, dataLen));
          pos += des.update(plaintext, p_start, p_len, ciphertext, pos)
          # debug(" " + getHexBytes(padding, padding.length));
          des.update(padding, 0, padding.attr_length, ciphertext, pos)
          des.do_final
        rescue GeneralSecurityException => e
          ge = GSSException.new(GSSException::FAILURE, -1, "Could not use DES Cipher - " + RJava.cast_to_string(e.get_message))
          ge.init_cause(e)
          raise ge
        end
      when MessageToken::SEAL_ALG_DES3_KD
        ctext = des3_kd_encrypt(confounder, plaintext, p_start, p_len, padding)
        System.arraycopy(ctext, 0, ciphertext, c_start, ctext.attr_length)
      when MessageToken::SEAL_ALG_ARCFOUR_HMAC
        ctext2 = arc_four_encrypt(token, confounder, plaintext, p_start, p_len, padding)
        System.arraycopy(ctext2, 0, ciphertext, c_start, ctext2.attr_length)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported seal algorithm: " + RJava.cast_to_string(@seal_alg))
      end
    end
    
    typesig { [WrapToken_v2, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Encrypt data in the new GSS tokens
    # 
    # Wrap Tokens (with confidentiality)
    # { Encrypt(16-byte confounder | plaintext | 16-byte token_header) |
    # 12-byte HMAC }
    # where HMAC is on {16-byte confounder | plaintext | 16-byte token_header}
    # HMAC is not encrypted; it is appended at the end.
    def encrypt_data(token, confounder, token_header, plaintext, p_start, p_len, ciphertext, c_start, key_usage)
      ctext = nil
      case (@etype)
      when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
        ctext = aes128_encrypt(confounder, token_header, plaintext, p_start, p_len, key_usage)
      when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
        ctext = aes256_encrypt(confounder, token_header, plaintext, p_start, p_len, key_usage)
      else
        raise GSSException.new(GSSException::FAILURE, -1, "Unsupported etype: " + RJava.cast_to_string(@etype))
      end
      System.arraycopy(ctext, 0, ciphertext, c_start, ctext.attr_length)
      return ctext.attr_length
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # --------------------- DES methods
    # 
    # Computes the DesCbc checksum based on the algorithm published in FIPS
    # Publication 113. This involves applying padding to the data passed
    # in, then performing DesCbc encryption on the data with a zero initial
    # vector, and finally returning the last 8 bytes of the encryption
    # result.
    # 
    # @param key the bytes for the DES key
    # @param header a header to process first before the data is.
    # @param data the data to checksum
    # @param offset the offset where the data begins
    # @param len the length of the data
    # @throws GSSException when an error occuse in the encryption
    def get_des_cbc_checksum(key, header, data, offset, len)
      des = get_initialized_des(true, key, ZERO_IV)
      block_size = des.get_block_size
      # Here the data need not be a multiple of the blocksize
      # (8). Encrypt and throw away results for all blocks except for
      # the very last block.
      final_block = Array.typed(::Java::Byte).new(block_size) { 0 }
      num_blocks = len / block_size
      last_bytes = len % block_size
      if ((last_bytes).equal?(0))
        # No need for padding. Save last block from application data
        num_blocks -= 1
        System.arraycopy(data, offset + num_blocks * block_size, final_block, 0, block_size)
      else
        System.arraycopy(data, offset + num_blocks * block_size, final_block, 0, last_bytes)
        # Zero padding automatically done
      end
      begin
        temp = Array.typed(::Java::Byte).new(Math.max(block_size, ((header).nil? ? block_size : header.attr_length))) { 0 }
        if (!(header).nil?)
          # header will be null when doing DES-MD5 Checksum
          des.update(header, 0, header.attr_length, temp, 0)
        end
        # Iterate over all but the last block
        i = 0
        while i < num_blocks
          des.update(data, offset, block_size, temp, 0)
          offset += block_size
          i += 1
        end
        # Now process the final block
        ret_val = Array.typed(::Java::Byte).new(block_size) { 0 }
        des.update(final_block, 0, block_size, ret_val, 0)
        des.do_final
        return ret_val
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use DES Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
    end
    
    typesig { [::Java::Boolean, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Obtains an initialized DES cipher.
    # 
    # @param encryptMode true if encryption is desired, false is decryption
    # is desired.
    # @param key the bytes for the DES key
    # @param ivBytes the initial vector bytes
    def get_initialized_des(encrypt_mode, key, iv_bytes)
      begin
        iv = IvParameterSpec.new(iv_bytes)
        jce_key = (SecretKeySpec.new(key, "DES"))
        des_cipher = Cipher.get_instance("DES/CBC/NoPadding")
        des_cipher.init((encrypt_mode ? Cipher::ENCRYPT_MODE : Cipher::DECRYPT_MODE), jce_key, iv)
        return des_cipher
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        ge.init_cause(e)
        raise ge
      end
    end
    
    typesig { [WrapToken, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # Helper routine to decrypt fromm a byte array and write the
    # application data straight to an output array with minimal
    # buffer copies. The confounder and the padding are stored
    # separately and not copied into this output array.
    # @param key the DES key to use
    # @param cipherText the encrypted data
    # @param offset the offset for the encrypted data
    # @param len the length of the encrypted data
    # @param dataOutBuf the output buffer where the application data
    # should be writte
    # @param dataOffset the offser where the application data should
    # be written.
    # @throws GSSException is an error occurs while decrypting the
    # data
    def des_cbc_decrypt(token, key, cipher_text, offset, len, data_out_buf, data_offset)
      begin
        temp = 0
        des = get_initialized_des(false, key, ZERO_IV)
        # Remove the counfounder first.
        # CONFOUNDER_SIZE is one DES block ie 8 bytes.
        temp = des.update(cipher_text, offset, WrapToken::CONFOUNDER_SIZE, token.attr_confounder)
        # temp should be CONFOUNDER_SIZE
        # debug("\n\ttemp is " + temp + " and CONFOUNDER_SIZE is "
        # + CONFOUNDER_SIZE);
        offset += WrapToken::CONFOUNDER_SIZE
        len -= WrapToken::CONFOUNDER_SIZE
        # len is a multiple of 8 due to padding.
        # Decrypt all blocks directly into the output buffer except for
        # the very last block. Remove the trailing padding bytes from the
        # very last block and copy that into the output buffer.
        block_size = des.get_block_size
        num_blocks = len / block_size - 1
        # Iterate over all but the last block
        i = 0
        while i < num_blocks
          temp = des.update(cipher_text, offset, block_size, data_out_buf, data_offset)
          # temp should be blockSize
          # debug("\n\ttemp is " + temp + " and blockSize is "
          # + blockSize);
          offset += block_size
          data_offset += block_size
          i += 1
        end
        # Now process the last block
        final_block = Array.typed(::Java::Byte).new(block_size) { 0 }
        des.update(cipher_text, offset, block_size, final_block)
        des.do_final
        # There is always at least one padding byte. The padding bytes
        # are all the value of the number of padding bytes.
        pad_size = final_block[block_size - 1]
        if (pad_size < 1 || pad_size > 8)
          raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid padding on Wrap Token")
        end
        token.attr_padding = WrapToken.attr_pads[pad_size]
        block_size -= pad_size
        # Copy this last block into the output buffer
        System.arraycopy(final_block, 0, data_out_buf, data_offset, block_size)
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use DES cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
    end
    
    typesig { [WrapToken, Array.typed(::Java::Byte), InputStream, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # Helper routine to decrypt from an InputStream and write the
    # application data straight to an output array with minimal
    # buffer copies. The confounder and the padding are stored
    # separately and not copied into this output array.
    # @param key the DES key to use
    # @param is the InputStream from which the cipher text should be
    # read
    # @param len the length of the ciphertext data
    # @param dataOutBuf the output buffer where the application data
    # should be writte
    # @param dataOffset the offser where the application data should
    # be written.
    # @throws GSSException is an error occurs while decrypting the
    # data
    def des_cbc_decrypt(token, key, is, len, data_out_buf, data_offset)
      temp = 0
      des = get_initialized_des(false, key, ZERO_IV)
      truncated_input_stream = WrapTokenInputStream.new_local(self, is, len)
      cis = CipherInputStream.new(truncated_input_stream, des)
      # Remove the counfounder first.
      # CONFOUNDER_SIZE is one DES block ie 8 bytes.
      temp = cis.read(token.attr_confounder)
      len -= temp
      # temp should be CONFOUNDER_SIZE
      # debug("Got " + temp + " bytes; CONFOUNDER_SIZE is "
      # + CONFOUNDER_SIZE + "\n");
      # debug("Confounder is " + getHexBytes(confounder) + "\n");
      # 
      # len is a multiple of 8 due to padding.
      # Decrypt all blocks directly into the output buffer except for
      # the very last block. Remove the trailing padding bytes from the
      # very last block and copy that into the output buffer.
      block_size = des.get_block_size
      num_blocks = len / block_size - 1
      # Iterate over all but the last block
      i = 0
      while i < num_blocks
        # debug("dataOffset is " + dataOffset + "\n");
        temp = cis.read(data_out_buf, data_offset, block_size)
        # temp should be blockSize
        # debug("Got " + temp + " bytes and blockSize is "
        # + blockSize + "\n");
        # debug("Bytes are: "
        # + getHexBytes(dataOutBuf, dataOffset, temp) + "\n");
        data_offset += block_size
        i += 1
      end
      # Now process the last block
      final_block = Array.typed(::Java::Byte).new(block_size) { 0 }
      # debug("Will call read on finalBlock" + "\n");
      temp = cis.read(final_block)
      # temp should be blockSize
      # 
      # debug("Got " + temp + " bytes and blockSize is "
      # + blockSize + "\n");
      # debug("Bytes are: "
      # + getHexBytes(finalBlock, 0, temp) + "\n");
      # debug("Will call doFinal" + "\n");
      begin
        des.do_final
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use DES cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
      # There is always at least one padding byte. The padding bytes
      # are all the value of the number of padding bytes.
      pad_size = final_block[block_size - 1]
      if (pad_size < 1 || pad_size > 8)
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid padding on Wrap Token")
      end
      token.attr_padding = WrapToken.attr_pads[pad_size]
      block_size -= pad_size
      # Copy this last block into the output buffer
      System.arraycopy(final_block, 0, data_out_buf, data_offset, block_size)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      def get_des_encryption_key(key)
        # To meet export control requirements, double check that the
        # key being used is no longer than 64 bits.
        # 
        # Note that from a protocol point of view, an
        # algorithm that is not DES will be rejected before this
        # point. Also, a DES key that is not 64 bits will be
        # rejected by a good JCE provider.
        if (key.attr_length > 8)
          raise GSSException.new(GSSException::FAILURE, -100, "Invalid DES Key!")
        end
        ret_val = Array.typed(::Java::Byte).new(key.attr_length) { 0 }
        i = 0
        while i < key.attr_length
          ret_val[i] = (key[i] ^ 0xf0)
          i += 1
        end # RFC 1964, Section 1.2.2
        return ret_val
      end
    }
    
    typesig { [WrapToken, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # ---- DES3-KD methods
    def des3_kd_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start)
      ptext = nil
      begin
        ptext = Des3.decrypt_raw(@keybytes, KG_USAGE_SEAL, ZERO_IV, ciphertext, c_start, c_len)
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use DES3-KD Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
      # Krb5Token.debug("\ndes3KdDecrypt in: " +
      # Krb5Token.getHexBytes(ciphertext, cStart, cLen));
      # Krb5Token.debug("\ndes3KdDecrypt plain: " +
      # Krb5Token.getHexBytes(ptext));
      # 
      # Strip out confounder and padding
      # 
      # There is always at least one padding byte. The padding bytes
      # are all the value of the number of padding bytes.
      pad_size = ptext[ptext.attr_length - 1]
      if (pad_size < 1 || pad_size > 8)
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid padding on Wrap Token")
      end
      token.attr_padding = WrapToken.attr_pads[pad_size]
      len = ptext.attr_length - WrapToken::CONFOUNDER_SIZE - pad_size
      System.arraycopy(ptext, WrapToken::CONFOUNDER_SIZE, plaintext, p_start, len)
      # Needed to calculate checksum
      System.arraycopy(ptext, 0, token.attr_confounder, 0, WrapToken::CONFOUNDER_SIZE)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
    def des3_kd_encrypt(confounder, plaintext, start, len, padding)
      # [confounder | plaintext | padding]
      all = Array.typed(::Java::Byte).new(confounder.attr_length + len + padding.attr_length) { 0 }
      System.arraycopy(confounder, 0, all, 0, confounder.attr_length)
      System.arraycopy(plaintext, start, all, confounder.attr_length, len)
      System.arraycopy(padding, 0, all, confounder.attr_length + len, padding.attr_length)
      # Krb5Token.debug("\ndes3KdEncrypt:" + Krb5Token.getHexBytes(all));
      # Encrypt
      begin
        answer = Des3.encrypt_raw(@keybytes, KG_USAGE_SEAL, ZERO_IV, all, 0, all.attr_length)
        # Krb5Token.debug("\ndes3KdEncrypt encrypted:" +
        # Krb5Token.getHexBytes(answer));
        return answer
      rescue JavaException => e
        # GeneralSecurityException, KrbCryptoException
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use DES3-KD Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
    end
    
    typesig { [WrapToken, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # ---- RC4-HMAC methods
    def arc_four_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start)
      # obtain Sequence number needed for decryption
      # first decrypt the Sequence Number using checksum
      seq_num = decrypt_seq(token.get_checksum, token.get_enc_seq_number, 0, 8)
      ptext = nil
      begin
        ptext = ArcFourHmac.decrypt_raw(@keybytes, KG_USAGE_SEAL, ZERO_IV, ciphertext, c_start, c_len, seq_num)
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use ArcFour Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
      # Krb5Token.debug("\narcFourDecrypt in: " +
      # Krb5Token.getHexBytes(ciphertext, cStart, cLen));
      # Krb5Token.debug("\narcFourDecrypt plain: " +
      # Krb5Token.getHexBytes(ptext));
      # 
      # Strip out confounder and padding
      # 
      # There is always at least one padding byte. The padding bytes
      # are all the value of the number of padding bytes.
      pad_size = ptext[ptext.attr_length - 1]
      if (pad_size < 1)
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid padding on Wrap Token")
      end
      token.attr_padding = WrapToken.attr_pads[pad_size]
      len = ptext.attr_length - WrapToken::CONFOUNDER_SIZE - pad_size
      System.arraycopy(ptext, WrapToken::CONFOUNDER_SIZE, plaintext, p_start, len)
      # Krb5Token.debug("\narcFourDecrypt plaintext: " +
      # Krb5Token.getHexBytes(plaintext));
      # Needed to calculate checksum
      System.arraycopy(ptext, 0, token.attr_confounder, 0, WrapToken::CONFOUNDER_SIZE)
    end
    
    typesig { [WrapToken, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
    def arc_four_encrypt(token, confounder, plaintext, start, len, padding)
      # [confounder | plaintext | padding]
      all = Array.typed(::Java::Byte).new(confounder.attr_length + len + padding.attr_length) { 0 }
      System.arraycopy(confounder, 0, all, 0, confounder.attr_length)
      System.arraycopy(plaintext, start, all, confounder.attr_length, len)
      System.arraycopy(padding, 0, all, confounder.attr_length + len, padding.attr_length)
      # get the token Sequence Number required for encryption
      # Note: When using this RC4 based encryption type, the sequence number
      # is always sent in big-endian rather than little-endian order.
      seq_num = Array.typed(::Java::Byte).new(4) { 0 }
      token.write_big_endian(token.get_sequence_number, seq_num)
      # Krb5Token.debug("\narcFourEncrypt:" + Krb5Token.getHexBytes(all));
      # Encrypt
      begin
        answer = ArcFourHmac.encrypt_raw(@keybytes, KG_USAGE_SEAL, seq_num, all, 0, all.attr_length)
        # Krb5Token.debug("\narcFourEncrypt encrypted:" +
        # Krb5Token.getHexBytes(answer));
        return answer
      rescue JavaException => e
        # GeneralSecurityException, KrbCryptoException
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use ArcFour Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
    # ---- AES methods
    def aes128_encrypt(confounder, token_header, plaintext, start, len, key_usage)
      # encrypt { AES-plaintext-data | filler | header }
      # AES-plaintext-data { confounder | plaintext }
      # WrapToken = { tokenHeader |
      # Encrypt (confounder | plaintext | tokenHeader ) | HMAC }
      all = Array.typed(::Java::Byte).new(confounder.attr_length + len + token_header.attr_length) { 0 }
      System.arraycopy(confounder, 0, all, 0, confounder.attr_length)
      System.arraycopy(plaintext, start, all, confounder.attr_length, len)
      System.arraycopy(token_header, 0, all, confounder.attr_length + len, token_header.attr_length)
      # Krb5Token.debug("\naes128Encrypt:" + Krb5Token.getHexBytes(all));
      begin
        answer = Aes128.encrypt_raw(@keybytes, key_usage, ZERO_IV_AES, all, 0, all.attr_length)
        # Krb5Token.debug("\naes128Encrypt encrypted:" +
        # Krb5Token.getHexBytes(answer));
        return answer
      rescue JavaException => e
        # GeneralSecurityException, KrbCryptoException
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use AES128 Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
    end
    
    typesig { [WrapToken_v2, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def aes128_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start, key_usage)
      ptext = nil
      begin
        ptext = Aes128.decrypt_raw(@keybytes, key_usage, ZERO_IV_AES, ciphertext, c_start, c_len)
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use AES128 Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
      # Krb5Token.debug("\naes128Decrypt in: " +
      # Krb5Token.getHexBytes(ciphertext, cStart, cLen));
      # Krb5Token.debug("\naes128Decrypt plain: " +
      # Krb5Token.getHexBytes(ptext));
      # Krb5Token.debug("\naes128Decrypt ptext: " +
      # Krb5Token.getHexBytes(ptext));
      # 
      # Strip out confounder and token header
      len = ptext.attr_length - WrapToken_v2::CONFOUNDER_SIZE - WrapToken_v2::TOKEN_HEADER_SIZE
      System.arraycopy(ptext, WrapToken_v2::CONFOUNDER_SIZE, plaintext, p_start, len)
      # Krb5Token.debug("\naes128Decrypt plaintext: " +
      # Krb5Token.getHexBytes(plaintext, pStart, len));
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
    def aes256_encrypt(confounder, token_header, plaintext, start, len, key_usage)
      # encrypt { AES-plaintext-data | filler | header }
      # AES-plaintext-data { confounder | plaintext }
      # WrapToken = { tokenHeader |
      # Encrypt (confounder | plaintext | tokenHeader ) | HMAC }
      all = Array.typed(::Java::Byte).new(confounder.attr_length + len + token_header.attr_length) { 0 }
      System.arraycopy(confounder, 0, all, 0, confounder.attr_length)
      System.arraycopy(plaintext, start, all, confounder.attr_length, len)
      System.arraycopy(token_header, 0, all, confounder.attr_length + len, token_header.attr_length)
      # Krb5Token.debug("\naes256Encrypt:" + Krb5Token.getHexBytes(all));
      begin
        answer = Aes256.encrypt_raw(@keybytes, key_usage, ZERO_IV_AES, all, 0, all.attr_length)
        # Krb5Token.debug("\naes256Encrypt encrypted:" +
        # Krb5Token.getHexBytes(answer));
        return answer
      rescue JavaException => e
        # GeneralSecurityException, KrbCryptoException
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use AES256 Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
    end
    
    typesig { [WrapToken_v2, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def aes256_decrypt(token, ciphertext, c_start, c_len, plaintext, p_start, key_usage)
      ptext = nil
      begin
        ptext = Aes256.decrypt_raw(@keybytes, key_usage, ZERO_IV_AES, ciphertext, c_start, c_len)
      rescue GeneralSecurityException => e
        ge = GSSException.new(GSSException::FAILURE, -1, "Could not use AES128 Cipher - " + RJava.cast_to_string(e.get_message))
        ge.init_cause(e)
        raise ge
      end
      # Krb5Token.debug("\naes256Decrypt in: " +
      # Krb5Token.getHexBytes(ciphertext, cStart, cLen));
      # Krb5Token.debug("\naes256Decrypt plain: " +
      # Krb5Token.getHexBytes(ptext));
      # Krb5Token.debug("\naes256Decrypt ptext: " +
      # Krb5Token.getHexBytes(ptext));
      # 
      # Strip out confounder and token header
      len = ptext.attr_length - WrapToken_v2::CONFOUNDER_SIZE - WrapToken_v2::TOKEN_HEADER_SIZE
      System.arraycopy(ptext, WrapToken_v2::CONFOUNDER_SIZE, plaintext, p_start, len)
      # Krb5Token.debug("\naes128Decrypt plaintext: " +
      # Krb5Token.getHexBytes(plaintext, pStart, len));
    end
    
    class_module.module_eval {
      # This class provides a truncated inputstream needed by WrapToken. The
      # truncated inputstream is passed to CipherInputStream. It prevents
      # the CipherInputStream from treating the bytes of the following token
      # as part fo the ciphertext for this token.
      const_set_lazy(:WrapTokenInputStream) { Class.new(InputStream) do
        extend LocalClass
        include_class_members CipherHelper
        
        attr_accessor :is
        alias_method :attr_is, :is
        undef_method :is
        alias_method :attr_is=, :is=
        undef_method :is=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        attr_accessor :remaining
        alias_method :attr_remaining, :remaining
        undef_method :remaining
        alias_method :attr_remaining=, :remaining=
        undef_method :remaining=
        
        attr_accessor :temp
        alias_method :attr_temp, :temp
        undef_method :temp
        alias_method :attr_temp=, :temp=
        undef_method :temp=
        
        typesig { [class_self::InputStream, ::Java::Int] }
        def initialize(is, length)
          @is = nil
          @length = 0
          @remaining = 0
          @temp = 0
          super()
          @is = is
          @length = length
          @remaining = length
        end
        
        typesig { [] }
        def read
          if ((@remaining).equal?(0))
            return -1
          else
            @temp = @is.read
            if (!(@temp).equal?(-1))
              @remaining -= @temp
            end
            return @temp
          end
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def read(b)
          if ((@remaining).equal?(0))
            return -1
          else
            @temp = Math.min(@remaining, b.attr_length)
            @temp = @is.read(b, 0, @temp)
            if (!(@temp).equal?(-1))
              @remaining -= @temp
            end
            return @temp
          end
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          if ((@remaining).equal?(0))
            return -1
          else
            @temp = Math.min(@remaining, len)
            @temp = @is.read(b, off, @temp)
            if (!(@temp).equal?(-1))
              @remaining -= @temp
            end
            return @temp
          end
        end
        
        typesig { [::Java::Long] }
        def skip(n)
          if ((@remaining).equal?(0))
            return 0
          else
            @temp = RJava.cast_to_int(Math.min(@remaining, n))
            @temp = RJava.cast_to_int(@is.skip(@temp))
            @remaining -= @temp
            return @temp
          end
        end
        
        typesig { [] }
        def available
          return Math.min(@remaining, @is.available)
        end
        
        typesig { [] }
        def close
          @remaining = 0
        end
        
        private
        alias_method :initialize__wrap_token_input_stream, :initialize
      end }
    }
    
    private
    alias_method :initialize__cipher_helper, :initialize
  end
  
end
