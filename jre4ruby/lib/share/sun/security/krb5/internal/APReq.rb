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
  module APReqImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 AP-REQ type.
  # 
  # <xmp>
  # AP-REQ               ::= [APPLICATION 14] SEQUENCE {
  #      pvno            [0] INTEGER (5),
  #      msg-type        [1] INTEGER (14),
  #      ap-options      [2] APOptions,
  #      ticket          [3] Ticket,
  #      authenticator   [4] EncryptedData -- Authenticator
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class APReq 
    include_class_members APReqImports
    
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
    
    attr_accessor :ap_options
    alias_method :attr_ap_options, :ap_options
    undef_method :ap_options
    alias_method :attr_ap_options=, :ap_options=
    undef_method :ap_options=
    
    attr_accessor :ticket
    alias_method :attr_ticket, :ticket
    undef_method :ticket
    alias_method :attr_ticket=, :ticket=
    undef_method :ticket=
    
    attr_accessor :authenticator
    alias_method :attr_authenticator, :authenticator
    undef_method :authenticator
    alias_method :attr_authenticator=, :authenticator=
    undef_method :authenticator=
    
    typesig { [APOptions, Ticket, EncryptedData] }
    def initialize(new_ap_options, new_ticket, new_authenticator)
      @pvno = 0
      @msg_type = 0
      @ap_options = nil
      @ticket = nil
      @authenticator = nil
      @pvno = Krb5::PVNO
      @msg_type = Krb5::KRB_AP_REQ
      @ap_options = new_ap_options
      @ticket = new_ticket
      @authenticator = new_authenticator
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @pvno = 0
      @msg_type = 0
      @ap_options = nil
      @ticket = nil
      @authenticator = nil
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @pvno = 0
      @msg_type = 0
      @ap_options = nil
      @ticket = nil
      @authenticator = nil
      init(encoding)
    end
    
    typesig { [DerValue] }
    # Initializes an APReq object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception KrbApErrException if the value read from the DER-encoded data stream does not match the pre-defined value.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def init(encoding)
      der = nil
      sub_der = nil
      if ((!((encoding.get_tag & 0x1f)).equal?(Krb5::KRB_AP_REQ)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
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
      @pvno = sub_der.get_data.get_big_integer.int_value
      if (!(@pvno).equal?(Krb5::PVNO))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADVERSION)
      end
      sub_der = der.get_data.get_der_value
      if (!((sub_der.get_tag & 0x1f)).equal?(0x1))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @msg_type = sub_der.get_data.get_big_integer.int_value
      if (!(@msg_type).equal?(Krb5::KRB_AP_REQ))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_MSG_TYPE)
      end
      @ap_options = APOptions.parse(der.get_data, 0x2, false)
      @ticket = Ticket.parse(der.get_data, 0x3, false)
      @authenticator = EncryptedData.parse(der.get_data, 0x4, false)
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an APReq object.
    # @return byte array of encoded APReq object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@pvno))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@msg_type))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @ap_options.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @ticket.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @authenticator.asn1_encode)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      apreq = DerOutputStream.new
      apreq.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0xe), temp)
      return apreq.to_byte_array
    end
    
    private
    alias_method :initialize__apreq, :initialize
  end
  
end
