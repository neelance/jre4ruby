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
module Sun::Security::Krb5
  module EncryptedDataImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include ::Sun::Security::Krb5::Internal::Crypto
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class encapsulates Kerberos encrypted data. It allows
  # callers access to both the ASN.1 encoded form of the EncryptedData
  # type as well as the raw cipher text.
  class EncryptedData 
    include_class_members EncryptedDataImports
    include Cloneable
    
    attr_accessor :e_type
    alias_method :attr_e_type, :e_type
    undef_method :e_type
    alias_method :attr_e_type=, :e_type=
    undef_method :e_type=
    
    attr_accessor :kvno
    alias_method :attr_kvno, :kvno
    undef_method :kvno
    alias_method :attr_kvno=, :kvno=
    undef_method :kvno=
    
    # optional
    attr_accessor :cipher
    alias_method :attr_cipher, :cipher
    undef_method :cipher
    alias_method :attr_cipher=, :cipher=
    undef_method :cipher=
    
    attr_accessor :plain
    alias_method :attr_plain, :plain
    undef_method :plain
    alias_method :attr_plain=, :plain=
    undef_method :plain=
    
    class_module.module_eval {
      # not part of ASN.1 encoding
      # ----------------+-----------+----------+----------------+---------------
      # Encryption type |etype value|block size|minimum pad size|confounder size
      # ----------------+-----------+----------+----------------+---------------
      const_set_lazy(:ETYPE_NULL) { 0 }
      const_attr_reader  :ETYPE_NULL
      
      # 1          0                0
      const_set_lazy(:ETYPE_DES_CBC_CRC) { 1 }
      const_attr_reader  :ETYPE_DES_CBC_CRC
      
      # 8          4                8
      const_set_lazy(:ETYPE_DES_CBC_MD4) { 2 }
      const_attr_reader  :ETYPE_DES_CBC_MD4
      
      # 8          0                8
      const_set_lazy(:ETYPE_DES_CBC_MD5) { 3 }
      const_attr_reader  :ETYPE_DES_CBC_MD5
      
      # 8          0                8
      # draft-brezak-win2k-krb-rc4-hmac-04.txt
      const_set_lazy(:ETYPE_ARCFOUR_HMAC) { 23 }
      const_attr_reader  :ETYPE_ARCFOUR_HMAC
      
      # 1
      # NOTE: the exportable RC4-HMAC is not supported;
      # it is no longer a usable encryption type
      const_set_lazy(:ETYPE_ARCFOUR_HMAC_EXP) { 24 }
      const_attr_reader  :ETYPE_ARCFOUR_HMAC_EXP
      
      # 1
      # draft-ietf-krb-wg-crypto-07.txt
      const_set_lazy(:ETYPE_DES3_CBC_HMAC_SHA1_KD) { 16 }
      const_attr_reader  :ETYPE_DES3_CBC_HMAC_SHA1_KD
      
      # 8     0                8
      # draft-raeburn-krb-rijndael-krb-07.txt
      const_set_lazy(:ETYPE_AES128_CTS_HMAC_SHA1_96) { 17 }
      const_attr_reader  :ETYPE_AES128_CTS_HMAC_SHA1_96
      
      # 16      0           16
      const_set_lazy(:ETYPE_AES256_CTS_HMAC_SHA1_96) { 18 }
      const_attr_reader  :ETYPE_AES256_CTS_HMAC_SHA1_96
    }
    
    typesig { [] }
    # 16      0           16
    # used by self
    def initialize
      @e_type = 0
      @kvno = nil
      @cipher = nil
      @plain = nil
    end
    
    typesig { [] }
    def clone
      new_encrypted_data = EncryptedData.new
      new_encrypted_data.attr_e_type = @e_type
      if (!(@kvno).nil?)
        new_encrypted_data.attr_kvno = @kvno.int_value
      end
      if (!(@cipher).nil?)
        new_encrypted_data.attr_cipher = Array.typed(::Java::Byte).new(@cipher.attr_length) { 0 }
        System.arraycopy(@cipher, 0, new_encrypted_data.attr_cipher, 0, @cipher.attr_length)
      end
      return new_encrypted_data
    end
    
    typesig { [::Java::Int, JavaInteger, Array.typed(::Java::Byte)] }
    # Used in JSSE (com.sun.net.ssl.internal.KerberosPreMasterSecret)
    def initialize(new_e_type, new_kvno, new_cipher)
      @e_type = 0
      @kvno = nil
      @cipher = nil
      @plain = nil
      @e_type = new_e_type
      @kvno = new_kvno
      @cipher = new_cipher
    end
    
    typesig { [EncryptionKey, Array.typed(::Java::Byte), ::Java::Int] }
    # // Not used.
    # public EncryptedData(
    # EncryptionKey key,
    # byte[] plaintext)
    # throws KdcErrException, KrbCryptoException {
    # EType etypeEngine = EType.getInstance(key.getEType());
    # cipher = etypeEngine.encrypt(plaintext, key.getBytes());
    # eType = key.getEType();
    # kvno = key.getKeyVersionNumber();
    # }
    # 
    # used in KrbApRep, KrbApReq, KrbAsReq, KrbCred, KrbPriv
    # Used in JSSE (com.sun.net.ssl.internal.KerberosPreMasterSecret)
    def initialize(key, plaintext, usage)
      @e_type = 0
      @kvno = nil
      @cipher = nil
      @plain = nil
      etype_engine = EType.get_instance(key.get_etype)
      @cipher = etype_engine.encrypt(plaintext, key.get_bytes, usage)
      @e_type = key.get_etype
      @kvno = key.get_key_version_number
    end
    
    typesig { [EncryptionKey, ::Java::Int] }
    # // Not used.
    # public EncryptedData(
    # EncryptionKey key,
    # byte[] ivec,
    # byte[] plaintext)
    # throws KdcErrException, KrbCryptoException {
    # EType etypeEngine = EType.getInstance(key.getEType());
    # cipher = etypeEngine.encrypt(plaintext, key.getBytes(), ivec);
    # eType = key.getEType();
    # kvno = key.getKeyVersionNumber();
    # }
    # 
    # 
    # // Not used.
    # EncryptedData(
    # StringBuffer password,
    # byte[] plaintext)
    # throws KdcErrException, KrbCryptoException {
    # EncryptionKey key = new EncryptionKey(password);
    # EType etypeEngine = EType.getInstance(key.getEType());
    # cipher = etypeEngine.encrypt(plaintext, key.getBytes());
    # eType = key.getEType();
    # kvno = key.getKeyVersionNumber();
    # }
    # 
    # currently destructive on cipher
    def decrypt(key, usage)
      if (!(@e_type).equal?(key.get_etype))
        raise KrbCryptoException.new("EncryptedData is encrypted using keytype " + RJava.cast_to_string(EType.to_s(@e_type)) + " but decryption key is of type " + RJava.cast_to_string(EType.to_s(key.get_etype)))
      end
      etype_engine = EType.get_instance(@e_type)
      @plain = etype_engine.decrypt(@cipher, key.get_bytes, usage)
      @cipher = nil
      return etype_engine.decrypted_data(@plain)
    end
    
    typesig { [] }
    # // currently destructive on cipher
    # // Not used.
    # public byte[] decrypt(
    # EncryptionKey key,
    # byte[] ivec, int usage)
    # throws KdcErrException, KrbApErrException, KrbCryptoException {
    # // XXX check for matching eType and kvno here
    # EType etypeEngine = EType.getInstance(eType);
    # plain = etypeEngine.decrypt(cipher, key.getBytes(), ivec, usage);
    # cipher = null;
    # return etypeEngine.decryptedData(plain);
    # }
    # 
    # // currently destructive on cipher
    # // Not used.
    # byte[] decrypt(StringBuffer password)
    # throws KdcErrException, KrbApErrException, KrbCryptoException {
    # EncryptionKey key = new EncryptionKey(password);
    # // XXX check for matching eType here
    # EType etypeEngine = EType.getInstance(eType);
    # plain = etypeEngine.decrypt(cipher, key.getBytes());
    # cipher = null;
    # return etypeEngine.decryptedData(plain);
    # }
    def decrypted_data
      if (!(@plain).nil?)
        etype_engine = EType.get_instance(@e_type)
        return etype_engine.decrypted_data(@plain)
      end
      return nil
    end
    
    typesig { [DerValue] }
    # Constructs an instance of EncryptedData type.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an
    # ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded
    # data.
    # 
    # 
    # Used by self
    def initialize(encoding)
      @e_type = 0
      @kvno = nil
      @cipher = nil
      @plain = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @e_type = (der.get_data.get_big_integer).int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (((encoding.get_data.peek_byte & 0x1f)).equal?(1))
        der = encoding.get_data.get_der_value
        i = (der.get_data.get_big_integer).int_value
        @kvno = i
      else
        @kvno = nil
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x2))
        @cipher = der.get_data.get_octet_string
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Returns an ASN.1 encoded EncryptedData type.
    # 
    # <xmp>
    # EncryptedData   ::= SEQUENCE {
    # etype   [0] Int32 -- EncryptionType --,
    # kvno    [1] UInt32 OPTIONAL,
    # cipher  [2] OCTET STRING -- ciphertext
    # }
    # </xmp>
    # 
    # <p>
    # This definition reflects the Network Working Group RFC 4120
    # specification available at
    # <a href="http://www.ietf.org/rfc/rfc4120.txt">
    # http://www.ietf.org/rfc/rfc4120.txt</a>.
    # <p>
    # @return byte array of encoded EncryptedData object.
    # @exception Asn1Exception if an error occurs while decoding an
    # ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading
    # encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@e_type))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      if (!(@kvno).nil?)
        # encode as an unsigned integer (UInt32)
        temp.put_integer(BigInteger.value_of(@kvno.long_value))
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
        temp = DerOutputStream.new
      end
      temp.put_octet_string(@cipher)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), temp)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) an EncryptedData from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @param data the Der input stream value, which contains one or more
      # marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional
      # @exception Asn1Exception if an error occurs while decoding an
      # ASN1 encoded data.
      # @exception IOException if an I/O error occurs while reading
      # encoded data.
      # @return an instance of EncryptedData.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return EncryptedData.new(sub_der)
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Boolean] }
    # Reset data stream after decryption, remove redundant bytes.
    # @param data the decrypted data from decrypt().
    # @param encoded true if the encrypted data is ASN1 encoded data,
    # false if the encrypted data is not ASN1 encoded data.
    # @return the reset byte array which holds exactly one asn1 datum
    # including its tag and length.
    def reset(data, encoded)
      bytes = nil
      # if it is encoded data, we use length field to
      # determine the data length and remove redundant paddings.
      if (encoded)
        if ((data[1] & 0xff) < 128)
          bytes = Array.typed(::Java::Byte).new(data[1] + 2) { 0 }
          System.arraycopy(data, 0, bytes, 0, data[1] + 2)
        else
          if ((data[1] & 0xff) > 128)
            len = data[1] & 0x7f
            result = 0
            i = 0
            while i < len
              result |= (data[i + 2] & 0xff) << (8 * (len - i - 1))
              i += 1
            end
            bytes = Array.typed(::Java::Byte).new(result + len + 2) { 0 }
            System.arraycopy(data, 0, bytes, 0, result + len + 2)
          end
        end
      else
        # if it is not encoded, which happens in GSS tokens,
        # we remove padding data according to padding pattern.
        bytes = Array.typed(::Java::Byte).new(data.attr_length - data[data.attr_length - 1]) { 0 }
        System.arraycopy(data, 0, bytes, 0, data.attr_length - data[data.attr_length - 1])
      end
      return bytes
    end
    
    typesig { [] }
    def get_etype
      return @e_type
    end
    
    typesig { [] }
    def get_key_version_number
      return @kvno
    end
    
    typesig { [] }
    # Returns the raw cipher text bytes, not in ASN.1 encoding.
    def get_bytes
      return @cipher
    end
    
    private
    alias_method :initialize__encrypted_data, :initialize
  end
  
end
