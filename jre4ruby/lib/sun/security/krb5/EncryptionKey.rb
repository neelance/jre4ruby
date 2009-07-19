require "rjava"

# Portions Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EncryptionKeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Security::Krb5::Internal::Ktab, :KeyTab
      include_const ::Sun::Security::Krb5::Internal::Ccache, :CCacheOutputStream
      include_const ::Javax::Crypto::Spec, :DESKeySpec
      include_const ::Javax::Crypto::Spec, :DESedeKeySpec
    }
  end
  
  # This class encapsulates the concept of an EncryptionKey. An encryption
  # key is defined in RFC 4120 as:
  # 
  # EncryptionKey   ::= SEQUENCE {
  # keytype         [0] Int32 -- actually encryption type --,
  # keyvalue        [1] OCTET STRING
  # }
  # 
  # keytype
  # This field specifies the encryption type of the encryption key
  # that follows in the keyvalue field.  Although its name is
  # "keytype", it actually specifies an encryption type.  Previously,
  # multiple cryptosystems that performed encryption differently but
  # were capable of using keys with the same characteristics were
  # permitted to share an assigned number to designate the type of
  # key; this usage is now deprecated.
  # 
  # keyvalue
  # This field contains the key itself, encoded as an octet string.
  class EncryptionKey 
    include_class_members EncryptionKeyImports
    include Cloneable
    
    class_module.module_eval {
      const_set_lazy(:NULL_KEY) { EncryptionKey.new(Array.typed(::Java::Byte).new([]), EncryptedData::ETYPE_NULL, nil) }
      const_attr_reader  :NULL_KEY
    }
    
    attr_accessor :key_type
    alias_method :attr_key_type, :key_type
    undef_method :key_type
    alias_method :attr_key_type=, :key_type=
    undef_method :key_type=
    
    attr_accessor :key_value
    alias_method :attr_key_value, :key_value
    undef_method :key_value
    alias_method :attr_key_value=, :key_value=
    undef_method :key_value=
    
    attr_accessor :kvno
    alias_method :attr_kvno, :kvno
    undef_method :kvno
    alias_method :attr_kvno=, :kvno=
    undef_method :kvno=
    
    class_module.module_eval {
      # not part of ASN1 encoding;
      const_set_lazy(:DEBUG) { Krb5::DEBUG }
      const_attr_reader  :DEBUG
    }
    
    typesig { [] }
    def get_etype
      synchronized(self) do
        return @key_type
      end
    end
    
    typesig { [] }
    def get_key_version_number
      return @kvno
    end
    
    typesig { [] }
    # Returns the raw key bytes, not in any ASN.1 encoding.
    def get_bytes
      # This method cannot be called outside sun.security, hence no
      # cloning. getEncoded() calls this method.
      return @key_value
    end
    
    typesig { [] }
    def clone
      synchronized(self) do
        return EncryptionKey.new(@key_value, @key_type, @kvno)
      end
    end
    
    class_module.module_eval {
      typesig { [PrincipalName, String] }
      # Obtains the latest version of the secret key of
      # the principal from a keytab.
      # 
      # @param princ the principal whose secret key is desired
      # @param keytab the path to the keytab file. A value of null
      # will be accepted to indicate that the default path should be
      # searched.
      # @returns the secret key or null if none was found.
      # 
      # 
      # // Replaced by acquireSecretKeys
      # public static EncryptionKey acquireSecretKey(PrincipalName princ,
      # String keytab)
      # throws KrbException, IOException {
      # 
      # if (princ == null) {
      # throw new IllegalArgumentException(
      # "Cannot have null pricipal name to look in keytab.");
      # }
      # 
      # KeyTab ktab = KeyTab.getInstance(keytab);
      # 
      # if (ktab == null)
      # return null;
      # 
      # return ktab.readServiceKey(princ);
      # }
      # 
      # 
      # Obtains all versions of the secret key of the principal from a
      # keytab.
      # 
      # @Param princ the principal whose secret key is desired
      # @param keytab the path to the keytab file. A value of null
      # will be accepted to indicate that the default path should be
      # searched.
      # @returns an array of secret keys or null if none were found.
      def acquire_secret_keys(princ, keytab)
        if ((princ).nil?)
          raise IllegalArgumentException.new("Cannot have null pricipal name to look in keytab.")
        end
        # KeyTab getInstance(keytab) will call KeyTab.getInstance()
        # if keytab is null
        ktab = KeyTab.get_instance(keytab)
        if ((ktab).nil?)
          return nil
        end
        return ktab.read_service_keys(princ)
      end
      
      typesig { [Array.typed(::Java::Char), String] }
      # Generate a list of keys using the given principal and password.
      # Construct a key for each configured etype.
      # Caller is responsible for clearing password.
      # 
      # 
      # Usually, when keyType is decoded from ASN.1 it will contain a
      # value indicating what the algorithm to be used is. However, when
      # converting from a password to a key for the AS-EXCHANGE, this
      # keyType will not be available. Use builtin list of default etypes
      # as the default in that case. If default_tkt_enctypes was set in
      # the libdefaults of krb5.conf, then use that sequence.
      # 
      # Used in Krb5LoginModule
      def acquire_secret_keys(password, salt)
        return (acquire_secret_keys(password, salt, false, 0, nil))
      end
      
      typesig { [Array.typed(::Java::Char), String, ::Java::Boolean, ::Java::Int, Array.typed(::Java::Byte)] }
      # Generates a list of keys using the given principal, password,
      # and the pre-authentication values.
      def acquire_secret_keys(password, salt, pa_exists, pa_etype, pa_s2kparams)
        etypes = EType.get_defaults("default_tkt_enctypes")
        if ((etypes).nil?)
          etypes = EType.get_built_in_defaults
        end
        # set the preferred etype for preauth
        if ((pa_exists) && (!(pa_etype).equal?(EncryptedData::ETYPE_NULL)))
          if (DEBUG)
            System.out.println("Pre-Authentication: " + "Set preferred etype = " + (pa_etype).to_s)
          end
          if (EType.is_supported(pa_etype))
            # reset etypes to preferred value
            etypes = Array.typed(::Java::Int).new(1) { 0 }
            etypes[0] = pa_etype
          end
        end
        enc_keys = Array.typed(EncryptionKey).new(etypes.attr_length) { nil }
        i = 0
        while i < etypes.attr_length
          if (EType.is_supported(etypes[i]))
            enc_keys[i] = EncryptionKey.new(string_to_key(password, salt, pa_s2kparams, etypes[i]), etypes[i], nil)
          else
            if (DEBUG)
              System.out.println("Encryption Type " + (EType.to_s(etypes[i])).to_s + " is not supported/enabled")
            end
          end
          ((i += 1) - 1)
        end
        return enc_keys
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, JavaInteger] }
    # Used in Krb5AcceptCredential, self
    def initialize(key_value, key_type, kvno)
      @key_type = 0
      @key_value = nil
      @kvno = nil
      if (!(key_value).nil?)
        @key_value = Array.typed(::Java::Byte).new(key_value.attr_length) { 0 }
        System.arraycopy(key_value, 0, @key_value, 0, key_value.attr_length)
      else
        raise IllegalArgumentException.new("EncryptionKey: " + "Key bytes cannot be null!")
      end
      @key_type = key_type
      @kvno = kvno
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Constructs an EncryptionKey by using the specified key type and key
    # value.  It is used to recover the key when retrieving data from
    # credential cache file.
    # 
    # 
    # Used in JSSE (KerberosWrapper), Credentials,
    # javax.security.auth.kerberos.KeyImpl
    def initialize(key_type, key_value)
      initialize__encryption_key(key_value, key_type, nil)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char), String, Array.typed(::Java::Byte), ::Java::Int] }
      def string_to_key(password, salt, s2kparams, key_type)
        slt = salt.to_char_array
        pwsalt = CharArray.new(password.attr_length + slt.attr_length)
        System.arraycopy(password, 0, pwsalt, 0, password.attr_length)
        System.arraycopy(slt, 0, pwsalt, password.attr_length, slt.attr_length)
        Arrays.fill(slt, Character.new(?0.ord))
        begin
          case (key_type)
          when EncryptedData::ETYPE_DES_CBC_CRC, EncryptedData::ETYPE_DES_CBC_MD5
            return Des.string_to_key_bytes(pwsalt)
          when EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD
            return Des3.string_to_key(pwsalt)
          when EncryptedData::ETYPE_ARCFOUR_HMAC
            return ArcFourHmac.string_to_key(password)
          when EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
            return Aes128.string_to_key(password, salt, s2kparams)
          when EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
            return Aes256.string_to_key(password, salt, s2kparams)
          else
            raise IllegalArgumentException.new("encryption type " + (EType.to_s(key_type)).to_s + " not supported")
          end
        rescue GeneralSecurityException => e
          ke = KrbCryptoException.new(e.get_message)
          ke.init_cause(e)
          raise ke
        ensure
          Arrays.fill(pwsalt, Character.new(?0.ord))
        end
      end
    }
    
    typesig { [Array.typed(::Java::Char), String, String] }
    # Used in javax.security.auth.kerberos.KeyImpl
    def initialize(password, salt, algorithm)
      @key_type = 0
      @key_value = nil
      @kvno = nil
      if ((algorithm).nil? || algorithm.equals_ignore_case("DES"))
        @key_type = EncryptedData::ETYPE_DES_CBC_MD5
      else
        if (algorithm.equals_ignore_case("DESede"))
          @key_type = EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD
        else
          if (algorithm.equals_ignore_case("AES128"))
            @key_type = EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
          else
            if (algorithm.equals_ignore_case("ArcFourHmac"))
              @key_type = EncryptedData::ETYPE_ARCFOUR_HMAC
            else
              if (algorithm.equals_ignore_case("AES256"))
                @key_type = EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
                # validate if AES256 is enabled
                if (!EType.is_supported(@key_type))
                  raise IllegalArgumentException.new("Algorithm " + algorithm + " not enabled")
                end
              else
                raise IllegalArgumentException.new("Algorithm " + algorithm + " not supported")
              end
            end
          end
        end
      end
      @key_value = string_to_key(password, salt, nil, @key_type)
      @kvno = nil
    end
    
    typesig { [EncryptionKey] }
    # Generates a sub-sessionkey from a given session key.
    # 
    # Used in KrbApRep, KrbApReq
    def initialize(key)
      @key_type = 0
      @key_value = nil
      @kvno = nil
      # generate random sub-session key
      @key_value = Confounder.bytes(key.attr_key_value.attr_length)
      i = 0
      while i < @key_value.attr_length
        @key_value[i] ^= key.attr_key_value[i]
        ((i += 1) - 1)
      end
      @key_type = key.attr_key_type
      # check for key parity and weak keys
      begin
        # check for DES key
        if (((@key_type).equal?(EncryptedData::ETYPE_DES_CBC_MD5)) || ((@key_type).equal?(EncryptedData::ETYPE_DES_CBC_CRC)))
          # fix DES key parity
          if (!DESKeySpec.is_parity_adjusted(@key_value, 0))
            @key_value = Des.set_parity(@key_value)
          end
          # check for weak key
          if (DESKeySpec.is_weak(@key_value, 0))
            @key_value[7] = (@key_value[7] ^ 0xf0)
          end
        end
        # check for 3DES key
        if ((@key_type).equal?(EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD))
          # fix 3DES key parity
          if (!DESedeKeySpec.is_parity_adjusted(@key_value, 0))
            @key_value = Des3.parity_fix(@key_value)
          end
          # check for weak keys
          one_key = Array.typed(::Java::Byte).new(8) { 0 }
          i_ = 0
          while i_ < @key_value.attr_length
            System.arraycopy(@key_value, i_, one_key, 0, 8)
            if (DESKeySpec.is_weak(one_key, 0))
              @key_value[i_ + 7] = (@key_value[i_ + 7] ^ 0xf0)
            end
            i_ += 8
          end
        end
      rescue GeneralSecurityException => e
        ke = KrbCryptoException.new(e.get_message)
        ke.init_cause(e)
        raise ke
      end
    end
    
    typesig { [DerValue] }
    # Constructs an instance of EncryptionKey type.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1
    # encoded data.
    # @exception IOException if an I/O error occurs while reading encoded
    # data.
    # 
    # 
    # 
    # Used in javax.security.auth.kerberos.KeyImpl
    def initialize(encoding)
      @key_type = 0
      @key_value = nil
      @kvno = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @key_type = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x1))
        @key_value = der.get_data.get_octet_string
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Returns the ASN.1 encoding of this EncryptionKey.
    # 
    # <xmp>
    # EncryptionKey ::=   SEQUENCE {
    # keytype[0]    INTEGER,
    # keyvalue[1]   OCTET STRING }
    # </xmp>
    # 
    # <p>
    # This definition reflects the Network Working Group RFC 4120
    # specification available at
    # <a href="http://www.ietf.org/rfc/rfc4120.txt">
    # http://www.ietf.org/rfc/rfc4120.txt</a>.
    # 
    # @return byte array of encoded EncryptionKey object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1
    # encoded data.
    # @exception IOException if an I/O error occurs while reading encoded
    # data.
    def asn1_encode
      synchronized(self) do
        bytes_ = DerOutputStream.new
        temp = DerOutputStream.new
        temp.put_integer(@key_type)
        bytes_.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
        temp = DerOutputStream.new
        temp.put_octet_string(@key_value)
        bytes_.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
        temp = DerOutputStream.new
        temp.write(DerValue.attr_tag_sequence, bytes_)
        return temp.to_byte_array
      end
    end
    
    typesig { [] }
    def destroy
      synchronized(self) do
        if (!(@key_value).nil?)
          i = 0
          while i < @key_value.attr_length
            @key_value[i] = 0
            ((i += 1) - 1)
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) an Encryption key from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @param data the Der input stream value, which contains one or more
      # marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional
      # @exception Asn1Exception if an error occurs while decoding an ASN1
      # encoded data.
      # @exception IOException if an I/O error occurs while reading encoded
      # data.
      # @return an instance of EncryptionKey.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return EncryptionKey.new(sub_der)
        end
      end
    }
    
    typesig { [CCacheOutputStream] }
    # Writes key value in FCC format to a <code>CCacheOutputStream</code>.
    # 
    # @param cos a <code>CCacheOutputStream</code> to be written to.
    # @exception IOException if an I/O exception occurs.
    # @see sun.security.krb5.internal.ccache.CCacheOutputStream
    def write_key(cos)
      synchronized(self) do
        cos.write16(@key_type)
        # we use KRB5_FCC_FVNO_3
        cos.write16(@key_type) # key type is recorded twice.
        cos.write32(@key_value.attr_length)
        i = 0
        while i < @key_value.attr_length
          cos.write8(@key_value[i])
          ((i += 1) - 1)
        end
      end
    end
    
    typesig { [] }
    def to_s
      return String.new("EncryptionKey: keyType=" + (@key_type).to_s + " kvno=" + (@kvno).to_s + " keyValue (hex dump)=" + (((@key_value).nil? || (@key_value.attr_length).equal?(0) ? " Empty Key" : Character.new(?\n.ord) + Krb5.attr_hex_dumper.encode(@key_value) + Character.new(?\n.ord))).to_s)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Array.typed(EncryptionKey)] }
      def find_key(etype, keys)
        # check if encryption type is supported
        if (!EType.is_supported(etype))
          raise KrbException.new("Encryption type " + (EType.to_s(etype)).to_s + " is not supported/enabled")
        end
        ktype = 0
        i = 0
        while i < keys.attr_length
          ktype = keys[i].get_etype
          if (EType.is_supported(ktype))
            if ((etype).equal?(ktype))
              return keys[i]
            end
          end
          ((i += 1) - 1)
        end
        # Key not found.
        # allow DES key to be used for the DES etypes
        if (((etype).equal?(EncryptedData::ETYPE_DES_CBC_CRC) || (etype).equal?(EncryptedData::ETYPE_DES_CBC_MD5)))
          i_ = 0
          while i_ < keys.attr_length
            ktype = keys[i_].get_etype
            if ((ktype).equal?(EncryptedData::ETYPE_DES_CBC_CRC) || (ktype).equal?(EncryptedData::ETYPE_DES_CBC_MD5))
              return EncryptionKey.new(etype, keys[i_].get_bytes)
            end
            ((i_ += 1) - 1)
          end
        end
        return nil
      end
    }
    
    private
    alias_method :initialize__encryption_key, :initialize
  end
  
end
