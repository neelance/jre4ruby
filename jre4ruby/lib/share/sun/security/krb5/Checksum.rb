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
  module ChecksumImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Java::Util, :Arrays
      include ::Sun::Security::Util
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class encapsulates the concept of a Kerberos checksum.
  class Checksum 
    include_class_members ChecksumImports
    
    attr_accessor :cksum_type
    alias_method :attr_cksum_type, :cksum_type
    undef_method :cksum_type
    alias_method :attr_cksum_type=, :cksum_type=
    undef_method :cksum_type=
    
    attr_accessor :checksum
    alias_method :attr_checksum, :checksum
    undef_method :checksum
    alias_method :attr_checksum=, :checksum=
    undef_method :checksum=
    
    class_module.module_eval {
      # ----------------------------------------------+-------------+-----------
      # Checksum type            |sumtype      |checksum
      # |value        | size
      # ----------------------------------------------+-------------+-----------
      const_set_lazy(:CKSUMTYPE_NULL) { 0 }
      const_attr_reader  :CKSUMTYPE_NULL
      
      # 0
      const_set_lazy(:CKSUMTYPE_CRC32) { 1 }
      const_attr_reader  :CKSUMTYPE_CRC32
      
      # 4
      const_set_lazy(:CKSUMTYPE_RSA_MD4) { 2 }
      const_attr_reader  :CKSUMTYPE_RSA_MD4
      
      # 16
      const_set_lazy(:CKSUMTYPE_RSA_MD4_DES) { 3 }
      const_attr_reader  :CKSUMTYPE_RSA_MD4_DES
      
      # 24
      const_set_lazy(:CKSUMTYPE_DES_MAC) { 4 }
      const_attr_reader  :CKSUMTYPE_DES_MAC
      
      # 16
      const_set_lazy(:CKSUMTYPE_DES_MAC_K) { 5 }
      const_attr_reader  :CKSUMTYPE_DES_MAC_K
      
      # 8
      const_set_lazy(:CKSUMTYPE_RSA_MD4_DES_K) { 6 }
      const_attr_reader  :CKSUMTYPE_RSA_MD4_DES_K
      
      # 16
      const_set_lazy(:CKSUMTYPE_RSA_MD5) { 7 }
      const_attr_reader  :CKSUMTYPE_RSA_MD5
      
      # 16
      const_set_lazy(:CKSUMTYPE_RSA_MD5_DES) { 8 }
      const_attr_reader  :CKSUMTYPE_RSA_MD5_DES
      
      # 24
      # draft-ietf-krb-wg-crypto-07.txt
      const_set_lazy(:CKSUMTYPE_HMAC_SHA1_DES3_KD) { 12 }
      const_attr_reader  :CKSUMTYPE_HMAC_SHA1_DES3_KD
      
      # 20
      # draft-raeburn-krb-rijndael-krb-07.txt
      const_set_lazy(:CKSUMTYPE_HMAC_SHA1_96_AES128) { 15 }
      const_attr_reader  :CKSUMTYPE_HMAC_SHA1_96_AES128
      
      # 96
      const_set_lazy(:CKSUMTYPE_HMAC_SHA1_96_AES256) { 16 }
      const_attr_reader  :CKSUMTYPE_HMAC_SHA1_96_AES256
      
      # 96
      # draft-brezak-win2k-krb-rc4-hmac-04.txt
      const_set_lazy(:CKSUMTYPE_HMAC_MD5_ARCFOUR) { -138 }
      const_attr_reader  :CKSUMTYPE_HMAC_MD5_ARCFOUR
      
      
      def cksumtype_default
        defined?(@@cksumtype_default) ? @@cksumtype_default : @@cksumtype_default= 0
      end
      alias_method :attr_cksumtype_default, :cksumtype_default
      
      def cksumtype_default=(value)
        @@cksumtype_default = value
      end
      alias_method :attr_cksumtype_default=, :cksumtype_default=
      
      
      def safecksumtype_default
        defined?(@@safecksumtype_default) ? @@safecksumtype_default : @@safecksumtype_default= 0
      end
      alias_method :attr_safecksumtype_default, :safecksumtype_default
      
      def safecksumtype_default=(value)
        @@safecksumtype_default = value
      end
      alias_method :attr_safecksumtype_default=, :safecksumtype_default=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      when_class_loaded do
        temp = nil
        cfg = nil
        begin
          cfg = Config.get_instance
          temp = RJava.cast_to_string(cfg.get_default("default_checksum", "libdefaults"))
          if (!(temp).nil?)
            self.attr_cksumtype_default = cfg.get_type(temp)
          else
            # If the default checksum is not
            # specified in the configuration we
            # set it to RSA_MD5. We follow the MIT and
            # SEAM implementation.
            self.attr_cksumtype_default = CKSUMTYPE_RSA_MD5
          end
        rescue JavaException => exc
          if (self.attr_debug)
            System.out.println("Exception in getting default checksum " + "value from the configuration " + "Setting default checksum to be RSA-MD5")
            exc.print_stack_trace
          end
          self.attr_cksumtype_default = CKSUMTYPE_RSA_MD5
        end
        begin
          temp = RJava.cast_to_string(cfg.get_default("safe_checksum_type", "libdefaults"))
          if (!(temp).nil?)
            self.attr_safecksumtype_default = cfg.get_type(temp)
          else
            self.attr_safecksumtype_default = CKSUMTYPE_RSA_MD5_DES
          end
        rescue JavaException => exc
          if (self.attr_debug)
            System.out.println("Exception in getting safe default " + "checksum value " + "from the configuration Setting  " + "safe default checksum to be RSA-MD5")
            exc.print_stack_trace
          end
          self.attr_safecksumtype_default = CKSUMTYPE_RSA_MD5_DES
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Constructs a new Checksum using the raw data and type.
    # @data the byte array of checksum.
    # @new_cksumType the type of checksum.
    # 
    # 
    # used in InitialToken
    def initialize(data, new_cksum_type)
      @cksum_type = 0
      @checksum = nil
      @cksum_type = new_cksum_type
      @checksum = data
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Constructs a new Checksum by calculating the checksum over the data
    # using specified checksum type.
    # @new_cksumType the type of checksum.
    # @data the data that needs to be performed a checksum calculation on.
    def initialize(new_cksum_type, data)
      @cksum_type = 0
      @checksum = nil
      @cksum_type = new_cksum_type
      cksum_engine = CksumType.get_instance(@cksum_type)
      if (!cksum_engine.is_safe)
        @checksum = cksum_engine.calculate_checksum(data, data.attr_length)
      else
        raise KdcErrException.new(Krb5::KRB_AP_ERR_INAPP_CKSUM)
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte), EncryptionKey, ::Java::Int] }
    # Constructs a new Checksum by calculating the keyed checksum
    # over the data using specified checksum type.
    # @new_cksumType the type of checksum.
    # @data the data that needs to be performed a checksum calculation on.
    # 
    # KrbSafe, KrbTgsReq
    def initialize(new_cksum_type, data, key, usage)
      @cksum_type = 0
      @checksum = nil
      @cksum_type = new_cksum_type
      cksum_engine = CksumType.get_instance(@cksum_type)
      if (!cksum_engine.is_safe)
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_INAPP_CKSUM)
      end
      @checksum = cksum_engine.calculate_keyed_checksum(data, data.attr_length, key.get_bytes, usage)
    end
    
    typesig { [Array.typed(::Java::Byte), EncryptionKey, ::Java::Int] }
    # Verifies the keyed checksum over the data passed in.
    def verify_keyed_checksum(data, key, usage)
      cksum_engine = CksumType.get_instance(@cksum_type)
      if (!cksum_engine.is_safe)
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_INAPP_CKSUM)
      end
      return cksum_engine.verify_keyed_checksum(data, data.attr_length, key.get_bytes, @checksum, usage)
    end
    
    typesig { [Checksum] }
    # public Checksum(byte[] data) throws KdcErrException, KrbCryptoException {
    # this(Checksum.CKSUMTYPE_DEFAULT, data);
    # }
    def is_equal(cksum)
      if (!(@cksum_type).equal?(cksum.attr_cksum_type))
        return false
      end
      cksum_engine = CksumType.get_instance(@cksum_type)
      return cksum_engine.is_checksum_equal(@checksum, cksum.attr_checksum)
    end
    
    typesig { [DerValue] }
    # Constructs an instance of Checksum from an ASN.1 encoded representation.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1
    # encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @cksum_type = 0
      @checksum = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @cksum_type = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x1))
        @checksum = der.get_data.get_octet_string
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes a Checksum object.
    # <xmp>
    # Checksum    ::= SEQUENCE {
    # cksumtype   [0] Int32,
    # checksum    [1] OCTET STRING
    # }
    # </xmp>
    # 
    # <p>
    # This definition reflects the Network Working Group RFC 4120
    # specification available at
    # <a href="http://www.ietf.org/rfc/rfc4120.txt">
    # http://www.ietf.org/rfc/rfc4120.txt</a>.
    # @return byte array of enocded Checksum.
    # @exception Asn1Exception if an error occurs while decoding an
    # ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading
    # encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@cksum_type))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      temp.put_octet_string(@checksum)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a checksum object from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception if an error occurs while decoding an
      # ASN1 encoded data.
      # @exception IOException if an I/O error occurs while reading
      # encoded data.
      # @param data the Der input stream value, which contains one or more
      # marshaled value.
      # @param explicitTag tag number.
      # @param optional indicates if this data field is optional
      # @return an instance of Checksum.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return Checksum.new(sub_der)
        end
      end
    }
    
    typesig { [] }
    # Returns the raw bytes of the checksum, not in ASN.1 encoded form.
    def get_bytes
      return @checksum
    end
    
    typesig { [] }
    def get_type
      return @cksum_type
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(Checksum)))
        return false
      end
      begin
        return is_equal(obj)
      rescue KdcErrException => kee
        return false
      end
    end
    
    typesig { [] }
    def hash_code
      result = 17
      result = 37 * result + @cksum_type
      if (!(@checksum).nil?)
        result = 37 * result + Arrays.hash_code(@checksum)
      end
      return result
    end
    
    private
    alias_method :initialize__checksum, :initialize
  end
  
end
