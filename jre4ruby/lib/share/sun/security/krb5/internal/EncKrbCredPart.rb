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
  module EncKrbCredPartImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5, :RealmException
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 EncKrbCredPart type.
  # 
  # <xmp>
  # EncKrbCredPart  ::= [APPLICATION 29] SEQUENCE {
  # ticket-info     [0] SEQUENCE OF KrbCredInfo,
  # nonce           [1] UInt32 OPTIONAL,
  # timestamp       [2] KerberosTime OPTIONAL,
  # usec            [3] Microseconds OPTIONAL,
  # s-address       [4] HostAddress OPTIONAL,
  # r-address       [5] HostAddress OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class EncKrbCredPart 
    include_class_members EncKrbCredPartImports
    
    attr_accessor :ticket_info
    alias_method :attr_ticket_info, :ticket_info
    undef_method :ticket_info
    alias_method :attr_ticket_info=, :ticket_info=
    undef_method :ticket_info=
    
    attr_accessor :time_stamp
    alias_method :attr_time_stamp, :time_stamp
    undef_method :time_stamp
    alias_method :attr_time_stamp=, :time_stamp=
    undef_method :time_stamp=
    
    # optional
    attr_accessor :nonce
    alias_method :attr_nonce, :nonce
    undef_method :nonce
    alias_method :attr_nonce=, :nonce=
    undef_method :nonce=
    
    # optional
    attr_accessor :usec
    alias_method :attr_usec, :usec
    undef_method :usec
    alias_method :attr_usec=, :usec=
    undef_method :usec=
    
    # optional
    attr_accessor :s_address
    alias_method :attr_s_address, :s_address
    undef_method :s_address
    alias_method :attr_s_address=, :s_address=
    undef_method :s_address=
    
    # optional
    attr_accessor :r_address
    alias_method :attr_r_address, :r_address
    undef_method :r_address
    alias_method :attr_r_address=, :r_address=
    undef_method :r_address=
    
    typesig { [Array.typed(KrbCredInfo), KerberosTime, JavaInteger, JavaInteger, HostAddress, HostAddresses] }
    # optional
    def initialize(new_ticket_info, new_time_stamp, new_usec, new_nonce, new_s_address, new_r_address)
      @ticket_info = nil
      @time_stamp = nil
      @nonce = nil
      @usec = nil
      @s_address = nil
      @r_address = nil
      if (!(new_ticket_info).nil?)
        @ticket_info = Array.typed(KrbCredInfo).new(new_ticket_info.attr_length) { nil }
        i = 0
        while i < new_ticket_info.attr_length
          if ((new_ticket_info[i]).nil?)
            raise IOException.new("Cannot create a EncKrbCredPart")
          else
            @ticket_info[i] = new_ticket_info[i].clone
          end
          i += 1
        end
      end
      @time_stamp = new_time_stamp
      @usec = new_usec
      @nonce = new_nonce
      @s_address = new_s_address
      @r_address = new_r_address
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @ticket_info = nil
      @time_stamp = nil
      @nonce = nil
      @usec = nil
      @s_address = nil
      @r_address = nil
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @ticket_info = nil
      @time_stamp = nil
      @nonce = nil
      @usec = nil
      @s_address = nil
      @r_address = nil
      init(encoding)
    end
    
    typesig { [DerValue] }
    # Initializes an EncKrbCredPart object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def init(encoding)
      der = nil
      sub_der = nil
      # may not be the correct error code for a tag
      # mismatch on an encrypted structure
      @nonce = nil
      @time_stamp = nil
      @usec = nil
      @s_address = nil
      @r_address = nil
      if ((!((encoding.get_tag & 0x1f)).equal?(0x1d)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x0))
        der_values = sub_der.get_data.get_sequence(1)
        @ticket_info = Array.typed(KrbCredInfo).new(der_values.attr_length) { nil }
        i = 0
        while i < der_values.attr_length
          @ticket_info[i] = KrbCredInfo.new(der_values[i])
          i += 1
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (der.get_data.available > 0)
        if ((((der.get_data.peek_byte) & 0x1f)).equal?(0x1))
          sub_der = der.get_data.get_der_value
          @nonce = sub_der.get_data.get_big_integer.int_value
        end
      end
      if (der.get_data.available > 0)
        @time_stamp = KerberosTime.parse(der.get_data, 0x2, true)
      end
      if (der.get_data.available > 0)
        if ((((der.get_data.peek_byte) & 0x1f)).equal?(0x3))
          sub_der = der.get_data.get_der_value
          @usec = sub_der.get_data.get_big_integer.int_value
        end
      end
      if (der.get_data.available > 0)
        @s_address = HostAddress.parse(der.get_data, 0x4, true)
      end
      if (der.get_data.available > 0)
        @r_address = HostAddresses.parse(der.get_data, 0x5, true)
      end
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an EncKrbCredPart object.
    # @return byte array of encoded EncKrbCredPart object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      tickets = Array.typed(DerValue).new(@ticket_info.attr_length) { nil }
      i = 0
      while i < @ticket_info.attr_length
        tickets[i] = DerValue.new(@ticket_info[i].asn1_encode)
        i += 1
      end
      temp.put_sequence(tickets)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      if (!(@nonce).nil?)
        temp = DerOutputStream.new
        temp.put_integer(BigInteger.value_of(@nonce.int_value))
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      end
      if (!(@time_stamp).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @time_stamp.asn1_encode)
      end
      if (!(@usec).nil?)
        temp = DerOutputStream.new
        temp.put_integer(BigInteger.value_of(@usec.int_value))
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), temp)
      end
      if (!(@s_address).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @s_address.asn1_encode)
      end
      if (!(@r_address).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), @r_address.asn1_encode)
      end
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      bytes = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x1d), temp)
      return bytes.to_byte_array
    end
    
    private
    alias_method :initialize__enc_krb_cred_part, :initialize
  end
  
end
