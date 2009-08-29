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
module Sun::Security::Krb5::Internal
  module KDCReqBodyImports #:nodoc:
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
  
  # Implements the ASN.1 KDC-REQ-BODY type.
  # 
  # <xmp>
  # KDC-REQ-BODY ::= SEQUENCE {
  # kdc-options             [0] KDCOptions,
  # cname                   [1] PrincipalName OPTIONAL
  # -- Used only in AS-REQ --,
  # realm                   [2] Realm
  # -- Server's realm
  # -- Also client's in AS-REQ --,
  # sname                   [3] PrincipalName OPTIONAL,
  # from                    [4] KerberosTime OPTIONAL,
  # till                    [5] KerberosTime,
  # rtime                   [6] KerberosTime OPTIONAL,
  # nonce                   [7] UInt32,
  # etype                   [8] SEQUENCE OF Int32 -- EncryptionType
  # -- in preference order --,
  # addresses               [9] HostAddresses OPTIONAL,
  # enc-authorization-data  [10] EncryptedData OPTIONAL
  # -- AuthorizationData --,
  # additional-tickets      [11] SEQUENCE OF Ticket OPTIONAL
  # -- NOTE: not empty
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KDCReqBody 
    include_class_members KDCReqBodyImports
    
    attr_accessor :kdc_options
    alias_method :attr_kdc_options, :kdc_options
    undef_method :kdc_options
    alias_method :attr_kdc_options=, :kdc_options=
    undef_method :kdc_options=
    
    attr_accessor :cname
    alias_method :attr_cname, :cname
    undef_method :cname
    alias_method :attr_cname=, :cname=
    undef_method :cname=
    
    # optional in ASReq only
    attr_accessor :crealm
    alias_method :attr_crealm, :crealm
    undef_method :crealm
    alias_method :attr_crealm=, :crealm=
    undef_method :crealm=
    
    attr_accessor :sname
    alias_method :attr_sname, :sname
    undef_method :sname
    alias_method :attr_sname=, :sname=
    undef_method :sname=
    
    # optional
    attr_accessor :from
    alias_method :attr_from, :from
    undef_method :from
    alias_method :attr_from=, :from=
    undef_method :from=
    
    # optional
    attr_accessor :till
    alias_method :attr_till, :till
    undef_method :till
    alias_method :attr_till=, :till=
    undef_method :till=
    
    attr_accessor :rtime
    alias_method :attr_rtime, :rtime
    undef_method :rtime
    alias_method :attr_rtime=, :rtime=
    undef_method :rtime=
    
    # optional
    attr_accessor :addresses
    alias_method :attr_addresses, :addresses
    undef_method :addresses
    alias_method :attr_addresses=, :addresses=
    undef_method :addresses=
    
    # optional
    attr_accessor :nonce
    alias_method :attr_nonce, :nonce
    undef_method :nonce
    alias_method :attr_nonce=, :nonce=
    undef_method :nonce=
    
    attr_accessor :e_type
    alias_method :attr_e_type, :e_type
    undef_method :e_type
    alias_method :attr_e_type=, :e_type=
    undef_method :e_type=
    
    # a sequence; not optional
    attr_accessor :enc_authorization_data
    alias_method :attr_enc_authorization_data, :enc_authorization_data
    undef_method :enc_authorization_data
    alias_method :attr_enc_authorization_data=, :enc_authorization_data=
    undef_method :enc_authorization_data=
    
    # optional
    attr_accessor :additional_tickets
    alias_method :attr_additional_tickets, :additional_tickets
    undef_method :additional_tickets
    alias_method :attr_additional_tickets=, :additional_tickets=
    undef_method :additional_tickets=
    
    typesig { [KDCOptions, PrincipalName, Realm, PrincipalName, KerberosTime, KerberosTime, KerberosTime, ::Java::Int, Array.typed(::Java::Int), HostAddresses, EncryptedData, Array.typed(Ticket)] }
    # optional
    # optional in ASReq only
    # optional
    # optional
    # optional
    # a sequence; not optional
    # optional
    # optional
    # optional
    def initialize(new_kdc_options, new_cname, new_crealm, new_sname, new_from, new_till, new_rtime, new_nonce, new_e_type, new_addresses, new_enc_authorization_data, new_additional_tickets)
      @kdc_options = nil
      @cname = nil
      @crealm = nil
      @sname = nil
      @from = nil
      @till = nil
      @rtime = nil
      @addresses = nil
      @nonce = 0
      @e_type = nil
      @enc_authorization_data = nil
      @additional_tickets = nil
      @kdc_options = new_kdc_options
      @cname = new_cname
      @crealm = new_crealm
      @sname = new_sname
      @from = new_from
      @till = new_till
      @rtime = new_rtime
      @nonce = new_nonce
      if (!(new_e_type).nil?)
        @e_type = new_e_type.clone
      end
      @addresses = new_addresses
      @enc_authorization_data = new_enc_authorization_data
      if (!(new_additional_tickets).nil?)
        @additional_tickets = Array.typed(Ticket).new(new_additional_tickets.attr_length) { nil }
        i = 0
        while i < new_additional_tickets.attr_length
          if ((new_additional_tickets[i]).nil?)
            raise IOException.new("Cannot create a KDCReqBody")
          else
            @additional_tickets[i] = new_additional_tickets[i].clone
          end
          i += 1
        end
      end
    end
    
    typesig { [DerValue, ::Java::Int] }
    # Constructs a KDCReqBody object.
    # @param encoding a DER-encoded data.
    # @param msgType an int indicating whether it's KRB_AS_REQ or KRB_TGS_REQ type.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception RealmException if an error occurs while constructing a Realm object from the encoded data.
    def initialize(encoding, msg_type)
      @kdc_options = nil
      @cname = nil
      @crealm = nil
      @sname = nil
      @from = nil
      @till = nil
      @rtime = nil
      @addresses = nil
      @nonce = 0
      @e_type = nil
      @enc_authorization_data = nil
      @additional_tickets = nil
      der = nil
      sub_der = nil
      @addresses = nil
      @enc_authorization_data = nil
      @additional_tickets = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @kdc_options = KDCOptions.parse(encoding.get_data, 0x0, false)
      @cname = PrincipalName.parse(encoding.get_data, 0x1, true)
      if ((!(msg_type).equal?(Krb5::KRB_AS_REQ)) && (!(@cname).nil?))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @crealm = Realm.parse(encoding.get_data, 0x2, false)
      @sname = PrincipalName.parse(encoding.get_data, 0x3, true)
      @from = KerberosTime.parse(encoding.get_data, 0x4, true)
      @till = KerberosTime.parse(encoding.get_data, 0x5, false)
      @rtime = KerberosTime.parse(encoding.get_data, 0x6, true)
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x7))
        @nonce = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      v = Vector.new
      if (((der.get_tag & 0x1f)).equal?(0x8))
        sub_der = der.get_data.get_der_value
        if ((sub_der.get_tag).equal?(DerValue.attr_tag_sequence_of))
          while (sub_der.get_data.available > 0)
            v.add_element(sub_der.get_data.get_big_integer.int_value)
          end
          @e_type = Array.typed(::Java::Int).new(v.size) { 0 }
          i = 0
          while i < v.size
            @e_type[i] = v.element_at(i)
            i += 1
          end
        else
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (encoding.get_data.available > 0)
        @addresses = HostAddresses.parse(encoding.get_data, 0x9, true)
      end
      if (encoding.get_data.available > 0)
        @enc_authorization_data = EncryptedData.parse(encoding.get_data, 0xa, true)
      end
      if (encoding.get_data.available > 0)
        temp_tickets = Vector.new
        der = encoding.get_data.get_der_value
        if (((der.get_tag & 0x1f)).equal?(0xb))
          sub_der = der.get_data.get_der_value
          if ((sub_der.get_tag).equal?(DerValue.attr_tag_sequence_of))
            while (sub_der.get_data.available > 0)
              temp_tickets.add_element(Ticket.new(sub_der.get_data.get_der_value))
            end
          else
            raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
          end
          if (temp_tickets.size > 0)
            @additional_tickets = Array.typed(Ticket).new(temp_tickets.size) { nil }
            temp_tickets.copy_into(@additional_tickets)
          end
        else
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [::Java::Int] }
    # Encodes this object to an OutputStream.
    # 
    # @return an byte array of encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode(msg_type)
      v = Vector.new
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), @kdc_options.asn1_encode))
      if ((msg_type).equal?(Krb5::KRB_AS_REQ))
        if (!(@cname).nil?)
          v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @cname.asn1_encode))
        end
      end
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @crealm.asn1_encode))
      if (!(@sname).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @sname.asn1_encode))
      end
      if (!(@from).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @from.asn1_encode))
      end
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), @till.asn1_encode))
      if (!(@rtime).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x6), @rtime.asn1_encode))
      end
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@nonce))
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x7), temp.to_byte_array))
      # revisit, if empty eType sequences are allowed
      temp = DerOutputStream.new
      i = 0
      while i < @e_type.attr_length
        temp.put_integer(BigInteger.value_of(@e_type[i]))
        i += 1
      end
      e_typetemp = DerOutputStream.new
      e_typetemp.write(DerValue.attr_tag_sequence_of, temp)
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x8), e_typetemp.to_byte_array))
      if (!(@addresses).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x9), @addresses.asn1_encode))
      end
      if (!(@enc_authorization_data).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xa), @enc_authorization_data.asn1_encode))
      end
      if (!(@additional_tickets).nil? && @additional_tickets.attr_length > 0)
        temp = DerOutputStream.new
        i_ = 0
        while i_ < @additional_tickets.attr_length
          temp.write(@additional_tickets[i_].asn1_encode)
          i_ += 1
        end
        tickets_temp = DerOutputStream.new
        tickets_temp.write(DerValue.attr_tag_sequence_of, temp)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xb), tickets_temp.to_byte_array))
      end
      der = Array.typed(DerValue).new(v.size) { nil }
      v.copy_into(der)
      temp = DerOutputStream.new
      temp.put_sequence(der)
      return temp.to_byte_array
    end
    
    typesig { [] }
    def get_nonce
      return @nonce
    end
    
    private
    alias_method :initialize__kdcreq_body, :initialize
  end
  
end
