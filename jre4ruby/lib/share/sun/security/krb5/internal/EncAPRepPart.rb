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
  module EncAPRepPartImports
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
  
  # Implements the ASN.1 EncAPRepPart type.
  # 
  # <xmp>
  # EncAPRepPart ::= [APPLICATION 27] SEQUENCE {
  # ctime           [0] KerberosTime,
  # cusec           [1] Microseconds,
  # subkey          [2] EncryptionKey OPTIONAL,
  # seq-number      [3] UInt32 OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class EncAPRepPart 
    include_class_members EncAPRepPartImports
    
    attr_accessor :ctime
    alias_method :attr_ctime, :ctime
    undef_method :ctime
    alias_method :attr_ctime=, :ctime=
    undef_method :ctime=
    
    attr_accessor :cusec
    alias_method :attr_cusec, :cusec
    undef_method :cusec
    alias_method :attr_cusec=, :cusec=
    undef_method :cusec=
    
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
    
    typesig { [KerberosTime, ::Java::Int, EncryptionKey, JavaInteger] }
    # optional
    def initialize(new_ctime, new_cusec, new_sub_key, new_seq_number)
      @ctime = nil
      @cusec = 0
      @sub_key = nil
      @seq_number = nil
      @ctime = new_ctime
      @cusec = new_cusec
      @sub_key = new_sub_key
      @seq_number = new_seq_number
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @ctime = nil
      @cusec = 0
      @sub_key = nil
      @seq_number = nil
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @ctime = nil
      @cusec = 0
      @sub_key = nil
      @seq_number = nil
      init(encoding)
    end
    
    typesig { [DerValue] }
    # Initializes an EncaPRepPart object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def init(encoding)
      der = nil
      sub_der = nil
      if ((!((encoding.get_tag & 0x1f)).equal?(0x1b)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @ctime = KerberosTime.parse(der.get_data, 0x0, true)
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x1))
        @cusec = sub_der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (der.get_data.available > 0)
        @sub_key = EncryptionKey.parse(der.get_data, 0x2, true)
      else
        @sub_key = nil
        @seq_number = nil
      end
      if (der.get_data.available > 0)
        sub_der = der.get_data.get_der_value
        if (!((sub_der.get_tag & 0x1f)).equal?(0x3))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
        @seq_number = sub_der.get_data.get_big_integer.int_value
      else
        @seq_number = nil
      end
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an EncAPRepPart object.
    # @return byte array of encoded EncAPRepPart object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      v = Vector.new
      temp = DerOutputStream.new
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), @ctime.asn1_encode))
      temp.put_integer(BigInteger.value_of(@cusec))
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp.to_byte_array))
      if (!(@sub_key).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @sub_key.asn1_encode))
      end
      if (!(@seq_number).nil?)
        temp = DerOutputStream.new
        # encode as an unsigned integer (UInt32)
        temp.put_integer(BigInteger.value_of(@seq_number.long_value))
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), temp.to_byte_array))
      end
      der = Array.typed(DerValue).new(v.size) { nil }
      v.copy_into(der)
      temp = DerOutputStream.new
      temp.put_sequence(der)
      out = DerOutputStream.new
      out.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x1b), temp)
      return out.to_byte_array
    end
    
    typesig { [] }
    def get_sub_key
      return @sub_key
    end
    
    typesig { [] }
    def get_seq_number
      return @seq_number
    end
    
    private
    alias_method :initialize__enc_aprep_part, :initialize
  end
  
end
