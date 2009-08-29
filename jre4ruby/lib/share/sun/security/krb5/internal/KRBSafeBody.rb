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
  module KRBSafeBodyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 KRBSafeBody type.
  # 
  # <xmp>
  # KRB-SAFE-BODY   ::= SEQUENCE {
  # user-data       [0] OCTET STRING,
  # timestamp       [1] KerberosTime OPTIONAL,
  # usec            [2] Microseconds OPTIONAL,
  # seq-number      [3] UInt32 OPTIONAL,
  # s-address       [4] HostAddress,
  # r-address       [5] HostAddress OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KRBSafeBody 
    include_class_members KRBSafeBodyImports
    
    attr_accessor :user_data
    alias_method :attr_user_data, :user_data
    undef_method :user_data
    alias_method :attr_user_data=, :user_data=
    undef_method :user_data=
    
    attr_accessor :timestamp
    alias_method :attr_timestamp, :timestamp
    undef_method :timestamp
    alias_method :attr_timestamp=, :timestamp=
    undef_method :timestamp=
    
    # optional
    attr_accessor :usec
    alias_method :attr_usec, :usec
    undef_method :usec
    alias_method :attr_usec=, :usec=
    undef_method :usec=
    
    # optional
    attr_accessor :seq_number
    alias_method :attr_seq_number, :seq_number
    undef_method :seq_number
    alias_method :attr_seq_number=, :seq_number=
    undef_method :seq_number=
    
    # optional
    attr_accessor :s_address
    alias_method :attr_s_address, :s_address
    undef_method :s_address
    alias_method :attr_s_address=, :s_address=
    undef_method :s_address=
    
    attr_accessor :r_address
    alias_method :attr_r_address, :r_address
    undef_method :r_address
    alias_method :attr_r_address=, :r_address=
    undef_method :r_address=
    
    typesig { [Array.typed(::Java::Byte), KerberosTime, JavaInteger, JavaInteger, HostAddress, HostAddress] }
    # optional
    def initialize(new_user_data, new_timestamp, new_usec, new_seq_number, new_s_address, new_r_address)
      @user_data = nil
      @timestamp = nil
      @usec = nil
      @seq_number = nil
      @s_address = nil
      @r_address = nil
      if (!(new_user_data).nil?)
        @user_data = new_user_data.clone
      end
      @timestamp = new_timestamp
      @usec = new_usec
      @seq_number = new_seq_number
      @s_address = new_s_address
      @r_address = new_r_address
    end
    
    typesig { [DerValue] }
    # Constructs a KRBSafeBody object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @user_data = nil
      @timestamp = nil
      @usec = nil
      @seq_number = nil
      @s_address = nil
      @r_address = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @user_data = der.get_data.get_octet_string
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @timestamp = KerberosTime.parse(encoding.get_data, 0x1, true)
      if (((encoding.get_data.peek_byte & 0x1f)).equal?(0x2))
        der = encoding.get_data.get_der_value
        @usec = der.get_data.get_big_integer.int_value
      end
      if (((encoding.get_data.peek_byte & 0x1f)).equal?(0x3))
        der = encoding.get_data.get_der_value
        @seq_number = der.get_data.get_big_integer.int_value
      end
      @s_address = HostAddress.parse(encoding.get_data, 0x4, false)
      if (encoding.get_data.available > 0)
        @r_address = HostAddress.parse(encoding.get_data, 0x5, true)
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an KRBSafeBody object.
    # @return the byte array of encoded KRBSafeBody object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_octet_string(@user_data)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      if (!(@timestamp).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @timestamp.asn1_encode)
      end
      if (!(@usec).nil?)
        temp = DerOutputStream.new
        temp.put_integer(BigInteger.value_of(@usec.int_value))
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), temp)
      end
      if (!(@seq_number).nil?)
        temp = DerOutputStream.new
        # encode as an unsigned integer (UInt32)
        temp.put_integer(BigInteger.value_of(@seq_number.long_value))
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), temp)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @s_address.asn1_encode)
      if (!(@r_address).nil?)
        temp = DerOutputStream.new
      end
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a KRBSafeBody from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicates if this data field is optional
      # @return an instance of KRBSafeBody.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return KRBSafeBody.new(sub_der)
        end
      end
    }
    
    private
    alias_method :initialize__krbsafe_body, :initialize
  end
  
end
