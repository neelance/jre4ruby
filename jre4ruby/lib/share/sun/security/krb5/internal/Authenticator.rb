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
module Sun::Security::Krb5::Internal
  module AuthenticatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 Authenticator type.
  # 
  # <xmp>
  # Authenticator   ::= [APPLICATION 2] SEQUENCE  {
  #         authenticator-vno       [0] INTEGER (5),
  #         crealm                  [1] Realm,
  #         cname                   [2] PrincipalName,
  #         cksum                   [3] Checksum OPTIONAL,
  #         cusec                   [4] Microseconds,
  #         ctime                   [5] KerberosTime,
  #         subkey                  [6] EncryptionKey OPTIONAL,
  #         seq-number              [7] UInt32 OPTIONAL,
  #         authorization-data      [8] AuthorizationData OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class Authenticator 
    include_class_members AuthenticatorImports
    
    attr_accessor :authenticator_vno
    alias_method :attr_authenticator_vno, :authenticator_vno
    undef_method :authenticator_vno
    alias_method :attr_authenticator_vno=, :authenticator_vno=
    undef_method :authenticator_vno=
    
    attr_accessor :crealm
    alias_method :attr_crealm, :crealm
    undef_method :crealm
    alias_method :attr_crealm=, :crealm=
    undef_method :crealm=
    
    attr_accessor :cname
    alias_method :attr_cname, :cname
    undef_method :cname
    alias_method :attr_cname=, :cname=
    undef_method :cname=
    
    attr_accessor :cksum
    alias_method :attr_cksum, :cksum
    undef_method :cksum
    alias_method :attr_cksum=, :cksum=
    undef_method :cksum=
    
    # optional
    attr_accessor :cusec
    alias_method :attr_cusec, :cusec
    undef_method :cusec
    alias_method :attr_cusec=, :cusec=
    undef_method :cusec=
    
    attr_accessor :ctime
    alias_method :attr_ctime, :ctime
    undef_method :ctime
    alias_method :attr_ctime=, :ctime=
    undef_method :ctime=
    
    attr_accessor :sub_key
    alias_method :attr_sub_key, :sub_key
    undef_method :sub_key
    alias_method :attr_sub_key=, :sub_key=
    undef_method :sub_key=
    
    # optional
    attr_accessor :seq_number
    alias_method :attr_seq_number, :seq_number
    undef_method :seq_number
    alias_method :attr_seq_number=, :seq_number=
    undef_method :seq_number=
    
    # optional
    attr_accessor :authorization_data
    alias_method :attr_authorization_data, :authorization_data
    undef_method :authorization_data
    alias_method :attr_authorization_data=, :authorization_data=
    undef_method :authorization_data=
    
    typesig { [Realm, PrincipalName, Checksum, ::Java::Int, KerberosTime, EncryptionKey, JavaInteger, AuthorizationData] }
    # optional
    def initialize(new_crealm, new_cname, new_cksum, new_cusec, new_ctime, new_sub_key, new_seq_number, new_authorization_data)
      @authenticator_vno = 0
      @crealm = nil
      @cname = nil
      @cksum = nil
      @cusec = 0
      @ctime = nil
      @sub_key = nil
      @seq_number = nil
      @authorization_data = nil
      @authenticator_vno = Krb5::AUTHNETICATOR_VNO
      @crealm = new_crealm
      @cname = new_cname
      @cksum = new_cksum
      @cusec = new_cusec
      @ctime = new_ctime
      @sub_key = new_sub_key
      @seq_number = new_seq_number
      @authorization_data = new_authorization_data
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @authenticator_vno = 0
      @crealm = nil
      @cname = nil
      @cksum = nil
      @cusec = 0
      @ctime = nil
      @sub_key = nil
      @seq_number = nil
      @authorization_data = nil
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @authenticator_vno = 0
      @crealm = nil
      @cname = nil
      @cksum = nil
      @cusec = 0
      @ctime = nil
      @sub_key = nil
      @seq_number = nil
      @authorization_data = nil
      init(encoding)
    end
    
    typesig { [DerValue] }
    # Initializes an Authenticator object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception KrbApErrException if the value read from the DER-encoded data
    #  stream does not match the pre-defined value.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def init(encoding)
      der = nil
      sub_der = nil
      # may not be the correct error code for a tag
      # mismatch on an encrypted structure
      if ((!((encoding.get_tag & 0x1f)).equal?(0x2)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (!((sub_der.get_tag & 0x1f)).equal?(0x0))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @authenticator_vno = sub_der.get_data.get_big_integer.int_value
      if (!(@authenticator_vno).equal?(5))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADVERSION)
      end
      @crealm = Realm.parse(der.get_data, 0x1, false)
      @cname = PrincipalName.parse(der.get_data, 0x2, false)
      @cksum = Checksum.parse(der.get_data, 0x3, true)
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x4))
        @cusec = sub_der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @ctime = KerberosTime.parse(der.get_data, 0x5, false)
      if (der.get_data.available > 0)
        @sub_key = EncryptionKey.parse(der.get_data, 0x6, true)
      else
        @sub_key = nil
        @seq_number = nil
        @authorization_data = nil
      end
      if (der.get_data.available > 0)
        if (((der.get_data.peek_byte & 0x1f)).equal?(0x7))
          sub_der = der.get_data.get_der_value
          if (((sub_der.get_tag & 0x1f)).equal?(0x7))
            @seq_number = sub_der.get_data.get_big_integer.int_value
          end
        end
      else
        @seq_number = nil
        @authorization_data = nil
      end
      if (der.get_data.available > 0)
        @authorization_data = AuthorizationData.parse(der.get_data, 0x8, true)
      else
        @authorization_data = nil
      end
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an Authenticator object.
    # @return byte array of encoded Authenticator object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      v = Vector.new
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@authenticator_vno))
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp.to_byte_array))
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @crealm.asn1_encode))
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @cname.asn1_encode))
      if (!(@cksum).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @cksum.asn1_encode))
      end
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@cusec))
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), temp.to_byte_array))
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), @ctime.asn1_encode))
      if (!(@sub_key).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x6), @sub_key.asn1_encode))
      end
      if (!(@seq_number).nil?)
        temp = DerOutputStream.new
        # encode as an unsigned integer (UInt32)
        temp.put_integer(BigInteger.value_of(@seq_number.long_value))
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x7), temp.to_byte_array))
      end
      if (!(@authorization_data).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x8), @authorization_data.asn1_encode))
      end
      der = Array.typed(DerValue).new(v.size) { nil }
      v.copy_into(der)
      temp = DerOutputStream.new
      temp.put_sequence(der)
      out = DerOutputStream.new
      out.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x2), temp)
      return out.to_byte_array
    end
    
    typesig { [] }
    def get_checksum
      return @cksum
    end
    
    typesig { [] }
    def get_seq_number
      return @seq_number
    end
    
    typesig { [] }
    def get_sub_key
      return @sub_key
    end
    
    private
    alias_method :initialize__authenticator, :initialize
  end
  
end
