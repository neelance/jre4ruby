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
  module KRBCredImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5, :RealmException
      include ::Sun::Security::Util
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 Authenticator type.
  # 
  # <xmp>
  # KRB-CRED     ::= [APPLICATION 22] SEQUENCE {
  #      pvno            [0] INTEGER (5),
  #      msg-type        [1] INTEGER (22),
  #      tickets         [2] SEQUENCE OF Ticket,
  #      enc-part        [3] EncryptedData -- EncKrbCredPart
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KRBCred 
    include_class_members KRBCredImports
    
    attr_accessor :tickets
    alias_method :attr_tickets, :tickets
    undef_method :tickets
    alias_method :attr_tickets=, :tickets=
    undef_method :tickets=
    
    attr_accessor :enc_part
    alias_method :attr_enc_part, :enc_part
    undef_method :enc_part
    alias_method :attr_enc_part=, :enc_part=
    undef_method :enc_part=
    
    attr_accessor :pvno
    alias_method :attr_pvno, :pvno
    undef_method :pvno
    alias_method :attr_pvno=, :pvno=
    undef_method :pvno=
    
    attr_accessor :msg_type
    alias_method :attr_msg_type, :msg_type
    undef_method :msg_type
    alias_method :attr_msg_type=, :msg_type=
    undef_method :msg_type=
    
    typesig { [Array.typed(Ticket), EncryptedData] }
    def initialize(new_tickets, new_enc_part)
      @tickets = nil
      @enc_part = nil
      @pvno = 0
      @msg_type = 0
      @pvno = Krb5::PVNO
      @msg_type = Krb5::KRB_CRED
      if (!(new_tickets).nil?)
        @tickets = Array.typed(Ticket).new(new_tickets.attr_length) { nil }
        i = 0
        while i < new_tickets.attr_length
          if ((new_tickets[i]).nil?)
            raise IOException.new("Cannot create a KRBCred")
          else
            @tickets[i] = new_tickets[i].clone
          end
          i += 1
        end
      end
      @enc_part = new_enc_part
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @tickets = nil
      @enc_part = nil
      @pvno = 0
      @msg_type = 0
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @tickets = nil
      @enc_part = nil
      @pvno = 0
      @msg_type = 0
      init(encoding)
    end
    
    typesig { [DerValue] }
    # Initializes an KRBCred object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception KrbApErrException if the value read from the DER-encoded data
    #  stream does not match the pre-defined value.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def init(encoding)
      if ((!((encoding.get_tag & 0x1f)).equal?(0x16)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = nil
      sub_der = nil
      der = encoding.get_data.get_der_value
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x0))
        @pvno = sub_der.get_data.get_big_integer.int_value
        if (!(@pvno).equal?(Krb5::PVNO))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADVERSION)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x1))
        @msg_type = sub_der.get_data.get_big_integer.int_value
        if (!(@msg_type).equal?(Krb5::KRB_CRED))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MSG_TYPE)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x2))
        subsub_der = sub_der.get_data.get_der_value
        if (!(subsub_der.get_tag).equal?(DerValue.attr_tag_sequence_of))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
        v = Vector.new
        while (subsub_der.get_data.available > 0)
          v.add_element(Ticket.new(subsub_der.get_data.get_der_value))
        end
        if (v.size > 0)
          @tickets = Array.typed(Ticket).new(v.size) { nil }
          v.copy_into(@tickets)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @enc_part = EncryptedData.parse(der.get_data, 0x3, false)
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an KRBCred object.
    # @return the data of encoded EncAPRepPart object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      temp = nil
      bytes = nil
      out = nil
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@pvno))
      out = DerOutputStream.new
      out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@msg_type))
      out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      temp = DerOutputStream.new
      i = 0
      while i < @tickets.attr_length
        temp.write(@tickets[i].asn1_encode)
        i += 1
      end
      bytes = DerOutputStream.new
      bytes.write(DerValue.attr_tag_sequence_of, temp)
      out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), bytes)
      out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @enc_part.asn1_encode)
      bytes = DerOutputStream.new
      bytes.write(DerValue.attr_tag_sequence, out)
      out = DerOutputStream.new
      out.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x16), bytes)
      return out.to_byte_array
    end
    
    private
    alias_method :initialize__krbcred, :initialize
  end
  
end
