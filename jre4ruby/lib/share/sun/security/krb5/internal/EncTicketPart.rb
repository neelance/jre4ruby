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
  module EncTicketPartImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include ::Java::Io
    }
  end
  
  # Implements the ASN.1 EncTicketPart type.
  # 
  # <xmp>
  # EncTicketPart   ::= [APPLICATION 3] SEQUENCE {
  # flags                   [0] TicketFlags,
  # key                     [1] EncryptionKey,
  # crealm                  [2] Realm,
  # cname                   [3] PrincipalName,
  # transited               [4] TransitedEncoding,
  # authtime                [5] KerberosTime,
  # starttime               [6] KerberosTime OPTIONAL,
  # endtime                 [7] KerberosTime,
  # renew-till              [8] KerberosTime OPTIONAL,
  # caddr                   [9] HostAddresses OPTIONAL,
  # authorization-data      [10] AuthorizationData OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class EncTicketPart 
    include_class_members EncTicketPartImports
    
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
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
    
    attr_accessor :transited
    alias_method :attr_transited, :transited
    undef_method :transited
    alias_method :attr_transited=, :transited=
    undef_method :transited=
    
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
    attr_accessor :caddr
    alias_method :attr_caddr, :caddr
    undef_method :caddr
    alias_method :attr_caddr=, :caddr=
    undef_method :caddr=
    
    # optional
    attr_accessor :authorization_data
    alias_method :attr_authorization_data, :authorization_data
    undef_method :authorization_data
    alias_method :attr_authorization_data=, :authorization_data=
    undef_method :authorization_data=
    
    typesig { [TicketFlags, EncryptionKey, Realm, PrincipalName, TransitedEncoding, KerberosTime, KerberosTime, KerberosTime, KerberosTime, HostAddresses, AuthorizationData] }
    # optional
    def initialize(new_flags, new_key, new_crealm, new_cname, new_transited, new_authtime, new_starttime, new_endtime, new_renew_till, new_caddr, new_authorization_data)
      @flags = nil
      @key = nil
      @crealm = nil
      @cname = nil
      @transited = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @caddr = nil
      @authorization_data = nil
      @flags = new_flags
      @key = new_key
      @crealm = new_crealm
      @cname = new_cname
      @transited = new_transited
      @authtime = new_authtime
      @starttime = new_starttime
      @endtime = new_endtime
      @renew_till = new_renew_till
      @caddr = new_caddr
      @authorization_data = new_authorization_data
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @flags = nil
      @key = nil
      @crealm = nil
      @cname = nil
      @transited = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @caddr = nil
      @authorization_data = nil
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @flags = nil
      @key = nil
      @crealm = nil
      @cname = nil
      @transited = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @caddr = nil
      @authorization_data = nil
      init(encoding)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # Initializes an EncTicketPart object.
      # @param encoding a single DER-encoded value.
      # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
      # @exception IOException if an I/O error occurs while reading encoded data.
      # @exception RealmException if an error occurs while parsing a Realm object.
      def get_hex_bytes(bytes, len)
        sb = StringBuffer.new
        i = 0
        while i < len
          b1 = (bytes[i] >> 4) & 0xf
          b2 = bytes[i] & 0xf
          sb.append(JavaInteger.to_hex_string(b1))
          sb.append(JavaInteger.to_hex_string(b2))
          sb.append(Character.new(?\s.ord))
          i += 1
        end
        return sb.to_s
      end
    }
    
    typesig { [DerValue] }
    def init(encoding)
      der = nil
      sub_der = nil
      @renew_till = nil
      @caddr = nil
      @authorization_data = nil
      if ((!((encoding.get_tag & 0x1f)).equal?(0x3)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @flags = TicketFlags.parse(der.get_data, 0x0, false)
      @key = EncryptionKey.parse(der.get_data, 0x1, false)
      @crealm = Realm.parse(der.get_data, 0x2, false)
      @cname = PrincipalName.parse(der.get_data, 0x3, false)
      @transited = TransitedEncoding.parse(der.get_data, 0x4, false)
      @authtime = KerberosTime.parse(der.get_data, 0x5, false)
      @starttime = KerberosTime.parse(der.get_data, 0x6, true)
      @endtime = KerberosTime.parse(der.get_data, 0x7, false)
      if (der.get_data.available > 0)
        @renew_till = KerberosTime.parse(der.get_data, 0x8, true)
      end
      if (der.get_data.available > 0)
        @caddr = HostAddresses.parse(der.get_data, 0x9, true)
      end
      if (der.get_data.available > 0)
        @authorization_data = AuthorizationData.parse(der.get_data, 0xa, true)
      end
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an EncTicketPart object.
    # @return byte array of encoded EncTicketPart object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), @flags.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @key.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @crealm.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @cname.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @transited.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), @authtime.asn1_encode)
      if (!(@starttime).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x6), @starttime.asn1_encode)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x7), @endtime.asn1_encode)
      if (!(@renew_till).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x8), @renew_till.asn1_encode)
      end
      if (!(@caddr).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x9), @caddr.asn1_encode)
      end
      if (!(@authorization_data).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xa), @authorization_data.asn1_encode)
      end
      temp.write(DerValue.attr_tag_sequence, bytes)
      bytes = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x3), temp)
      return bytes.to_byte_array
    end
    
    private
    alias_method :initialize__enc_ticket_part, :initialize
  end
  
end
