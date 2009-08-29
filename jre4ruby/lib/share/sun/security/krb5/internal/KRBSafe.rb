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
  module KRBSafeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5, :RealmException
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 KRBSafe type.
  # 
  # <xmp>
  # KRB-SAFE        ::= [APPLICATION 20] SEQUENCE {
  # pvno            [0] INTEGER (5),
  # msg-type        [1] INTEGER (20),
  # safe-body       [2] KRB-SAFE-BODY,
  # cksum           [3] Checksum
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specifications available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KRBSafe 
    include_class_members KRBSafeImports
    
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
    
    attr_accessor :safe_body
    alias_method :attr_safe_body, :safe_body
    undef_method :safe_body
    alias_method :attr_safe_body=, :safe_body=
    undef_method :safe_body=
    
    attr_accessor :cksum
    alias_method :attr_cksum, :cksum
    undef_method :cksum
    alias_method :attr_cksum=, :cksum=
    undef_method :cksum=
    
    typesig { [KRBSafeBody, Checksum] }
    def initialize(new_safe_body, new_cksum)
      @pvno = 0
      @msg_type = 0
      @safe_body = nil
      @cksum = nil
      @pvno = Krb5::PVNO
      @msg_type = Krb5::KRB_SAFE
      @safe_body = new_safe_body
      @cksum = new_cksum
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @pvno = 0
      @msg_type = 0
      @safe_body = nil
      @cksum = nil
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @pvno = 0
      @msg_type = 0
      @safe_body = nil
      @cksum = nil
      init(encoding)
    end
    
    typesig { [DerValue] }
    # Initializes an KRBSafe object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception RealmException if an error occurs while parsing a Realm object.
    # @exception KrbApErrException if the value read from the DER-encoded data
    # stream does not match the pre-defined value.
    def init(encoding)
      der = nil
      sub_der = nil
      if ((!((encoding.get_tag & 0x1f)).equal?(0x14)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
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
        if (!(@msg_type).equal?(Krb5::KRB_SAFE))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MSG_TYPE)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @safe_body = KRBSafeBody.parse(der.get_data, 0x2, false)
      @cksum = Checksum.parse(der.get_data, 0x3, false)
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an KRBSafe object.
    # @return byte array of encoded KRBSafe object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      temp = DerOutputStream.new
      bytes = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@pvno))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@msg_type))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @safe_body.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @cksum.asn1_encode)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      bytes = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x14), temp)
      return bytes.to_byte_array
    end
    
    private
    alias_method :initialize__krbsafe, :initialize
  end
  
end
