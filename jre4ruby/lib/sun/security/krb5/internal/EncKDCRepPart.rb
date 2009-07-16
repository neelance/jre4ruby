require "rjava"

# 
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
module Sun::Security::Krb5::Internal
  module EncKDCRepPartImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include ::Sun::Security::Util
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # 
  # Implements the ASN.1 EncKDCRepPart type.
  # 
  # <xmp>
  # EncKDCRepPart        ::= SEQUENCE {
  # key             [0] EncryptionKey,
  # last-req        [1] LastReq,
  # nonce           [2] UInt32,
  # key-expiration  [3] KerberosTime OPTIONAL,
  # flags           [4] TicketFlags,
  # authtime        [5] KerberosTime,
  # starttime       [6] KerberosTime OPTIONAL,
  # endtime         [7] KerberosTime,
  # renew-till      [8] KerberosTime OPTIONAL,
  # srealm          [9] Realm,
  # sname           [10] PrincipalName,
  # caddr           [11] HostAddresses OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class EncKDCRepPart 
    include_class_members EncKDCRepPartImports
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :last_req
    alias_method :attr_last_req, :last_req
    undef_method :last_req
    alias_method :attr_last_req=, :last_req=
    undef_method :last_req=
    
    attr_accessor :nonce
    alias_method :attr_nonce, :nonce
    undef_method :nonce
    alias_method :attr_nonce=, :nonce=
    undef_method :nonce=
    
    attr_accessor :key_expiration
    alias_method :attr_key_expiration, :key_expiration
    undef_method :key_expiration
    alias_method :attr_key_expiration=, :key_expiration=
    undef_method :key_expiration=
    
    # optional
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    attr_accessor :authtime
    alias_method :attr_authtime, :authtime
    undef_method :authtime
    alias_method :attr_authtime=, :authtime=
    undef_method :authtime=
    
    attr_accessor :starttime
    alias_method :attr_starttime, :starttime
    undef_method :starttime
    alias_method :attr_starttime=, :starttime=
    undef_method :starttime=
    
    # optional
    attr_accessor :endtime
    alias_method :attr_endtime, :endtime
    undef_method :endtime
    alias_method :attr_endtime=, :endtime=
    undef_method :endtime=
    
    attr_accessor :renew_till
    alias_method :attr_renew_till, :renew_till
    undef_method :renew_till
    alias_method :attr_renew_till=, :renew_till=
    undef_method :renew_till=
    
    # optional
    attr_accessor :srealm
    alias_method :attr_srealm, :srealm
    undef_method :srealm
    alias_method :attr_srealm=, :srealm=
    undef_method :srealm=
    
    attr_accessor :sname
    alias_method :attr_sname, :sname
    undef_method :sname
    alias_method :attr_sname=, :sname=
    undef_method :sname=
    
    attr_accessor :caddr
    alias_method :attr_caddr, :caddr
    undef_method :caddr
    alias_method :attr_caddr=, :caddr=
    undef_method :caddr=
    
    # optional
    attr_accessor :msg_type
    alias_method :attr_msg_type, :msg_type
    undef_method :msg_type
    alias_method :attr_msg_type=, :msg_type=
    undef_method :msg_type=
    
    typesig { [EncryptionKey, LastReq, ::Java::Int, KerberosTime, TicketFlags, KerberosTime, KerberosTime, KerberosTime, KerberosTime, Realm, PrincipalName, HostAddresses, ::Java::Int] }
    # not included in sequence
    def initialize(new_key, new_last_req, new_nonce, new_key_expiration, new_flags, new_authtime, new_starttime, new_endtime, new_renew_till, new_srealm, new_sname, new_caddr, new_msg_type)
      @key = nil
      @last_req = nil
      @nonce = 0
      @key_expiration = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
      @msg_type = 0
      @key = new_key
      @last_req = new_last_req
      @nonce = new_nonce
      @key_expiration = new_key_expiration
      @flags = new_flags
      @authtime = new_authtime
      @starttime = new_starttime
      @endtime = new_endtime
      @renew_till = new_renew_till
      @srealm = new_srealm
      @sname = new_sname
      @caddr = new_caddr
      @msg_type = new_msg_type
    end
    
    typesig { [] }
    def initialize
      @key = nil
      @last_req = nil
      @nonce = 0
      @key_expiration = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
      @msg_type = 0
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def initialize(data, rep_type)
      @key = nil
      @last_req = nil
      @nonce = 0
      @key_expiration = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
      @msg_type = 0
      init(DerValue.new(data), rep_type)
    end
    
    typesig { [DerValue, ::Java::Int] }
    def initialize(encoding, rep_type)
      @key = nil
      @last_req = nil
      @nonce = 0
      @key_expiration = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
      @msg_type = 0
      init(encoding, rep_type)
    end
    
    typesig { [DerValue, ::Java::Int] }
    # 
    # Initializes an EncKDCRepPart object.
    # 
    # @param encoding a single DER-encoded value.
    # @param rep_type type of the encrypted reply message.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception RealmException if an error occurs while decoding an Realm object.
    def init(encoding, rep_type)
      der = nil
      sub_der = nil
      # implementations return the incorrect tag value, so
      # we don't use the above line; instead we use the following
      @msg_type = (encoding.get_tag & 0x1f)
      if (!(@msg_type).equal?(Krb5::KRB_ENC_AS_REP_PART) && !(@msg_type).equal?(Krb5::KRB_ENC_TGS_REP_PART))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @key = EncryptionKey.parse(der.get_data, 0x0, false)
      @last_req = LastReq.parse(der.get_data, 0x1, false)
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x2))
        @nonce = sub_der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @key_expiration = KerberosTime.parse(der.get_data, 0x3, true)
      @flags = TicketFlags.parse(der.get_data, 0x4, false)
      @authtime = KerberosTime.parse(der.get_data, 0x5, false)
      @starttime = KerberosTime.parse(der.get_data, 0x6, true)
      @endtime = KerberosTime.parse(der.get_data, 0x7, false)
      @renew_till = KerberosTime.parse(der.get_data, 0x8, true)
      @srealm = Realm.parse(der.get_data, 0x9, false)
      @sname = PrincipalName.parse(der.get_data, 0xa, false)
      if (der.get_data.available > 0)
        @caddr = HostAddresses.parse(der.get_data, 0xb, true)
      end
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Encodes an EncKDCRepPart object.
    # @param rep_type type of encrypted reply message.
    # @return byte array of encoded EncKDCRepPart object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode(rep_type)
      temp = DerOutputStream.new
      bytes = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), @key.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @last_req.asn1_encode)
      temp.put_integer(BigInteger.value_of(@nonce))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), temp)
      if (!(@key_expiration).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @key_expiration.asn1_encode)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @flags.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), @authtime.asn1_encode)
      if (!(@starttime).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x6), @starttime.asn1_encode)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x7), @endtime.asn1_encode)
      if (!(@renew_till).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x8), @renew_till.asn1_encode)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x9), @srealm.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xa), @sname.asn1_encode)
      if (!(@caddr).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xb), @caddr.asn1_encode)
      end
      # should use the rep_type to build the encoding
      # but other implementations do not; it is ignored and
      # the cached msgType is used instead
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      bytes = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, @msg_type), temp)
      return bytes.to_byte_array
    end
    
    private
    alias_method :initialize__enc_kdcrep_part, :initialize
  end
  
end
