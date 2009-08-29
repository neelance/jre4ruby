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
  module TicketImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5, :Realm
      include_const ::Sun::Security::Krb5, :RealmException
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 Ticket type.
  # 
  # <xmp>
  # Ticket               ::= [APPLICATION 1] SEQUENCE {
  # tkt-vno         [0] INTEGER (5),
  # realm           [1] Realm,
  # sname           [2] PrincipalName,
  # enc-part        [3] EncryptedData -- EncTicketPart
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class Ticket 
    include_class_members TicketImports
    include Cloneable
    
    attr_accessor :tkt_vno
    alias_method :attr_tkt_vno, :tkt_vno
    undef_method :tkt_vno
    alias_method :attr_tkt_vno=, :tkt_vno=
    undef_method :tkt_vno=
    
    attr_accessor :realm
    alias_method :attr_realm, :realm
    undef_method :realm
    alias_method :attr_realm=, :realm=
    undef_method :realm=
    
    attr_accessor :sname
    alias_method :attr_sname, :sname
    undef_method :sname
    alias_method :attr_sname=, :sname=
    undef_method :sname=
    
    attr_accessor :enc_part
    alias_method :attr_enc_part, :enc_part
    undef_method :enc_part
    alias_method :attr_enc_part=, :enc_part=
    undef_method :enc_part=
    
    typesig { [] }
    def initialize
      @tkt_vno = 0
      @realm = nil
      @sname = nil
      @enc_part = nil
    end
    
    typesig { [] }
    def clone
      new_ticket = Ticket.new
      new_ticket.attr_realm = @realm.clone
      new_ticket.attr_sname = @sname.clone
      new_ticket.attr_enc_part = @enc_part.clone
      new_ticket.attr_tkt_vno = @tkt_vno
      return new_ticket
    end
    
    typesig { [Realm, PrincipalName, EncryptedData] }
    def initialize(new_realm, new_sname, new_enc_part)
      @tkt_vno = 0
      @realm = nil
      @sname = nil
      @enc_part = nil
      @tkt_vno = Krb5::TICKET_VNO
      @realm = new_realm
      @sname = new_sname
      @enc_part = new_enc_part
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @tkt_vno = 0
      @realm = nil
      @sname = nil
      @enc_part = nil
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @tkt_vno = 0
      @realm = nil
      @sname = nil
      @enc_part = nil
      init(encoding)
    end
    
    typesig { [DerValue] }
    # Initializes a Ticket object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception KrbApErrException if the value read from the DER-encoded data stream does not match the pre-defined value.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def init(encoding)
      der = nil
      sub_der = nil
      if ((!((encoding.get_tag & 0x1f)).equal?(Krb5::KRB_TKT)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
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
      @tkt_vno = sub_der.get_data.get_big_integer.int_value
      if (!(@tkt_vno).equal?(Krb5::TICKET_VNO))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADVERSION)
      end
      @realm = Realm.parse(der.get_data, 0x1, false)
      @sname = PrincipalName.parse(der.get_data, 0x2, false)
      @enc_part = EncryptedData.parse(der.get_data, 0x3, false)
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes a Ticket object.
    # @return byte array of encoded ticket object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      der = Array.typed(DerValue).new(4) { nil }
      temp.put_integer(BigInteger.value_of(@tkt_vno))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @realm.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @sname.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @enc_part.asn1_encode)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      ticket = DerOutputStream.new
      ticket.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x1), temp)
      return ticket.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a Ticket from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional
      # @return an instance of Ticket.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return Ticket.new(sub_der)
        end
      end
    }
    
    private
    alias_method :initialize__ticket, :initialize
  end
  
end
