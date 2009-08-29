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
  module KDCReqImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include_const ::Java::Util, :Vector
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 KRB_KDC_REQ type.
  # 
  # <xmp>
  # KDC-REQ              ::= SEQUENCE {
  # -- NOTE: first tag is [1], not [0]
  # pvno            [1] INTEGER (5) ,
  # msg-type        [2] INTEGER (10 -- AS -- | 12 -- TGS --),
  # padata          [3] SEQUENCE OF PA-DATA OPTIONAL
  # -- NOTE: not empty --,
  # req-body        [4] KDC-REQ-BODY
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KDCReq 
    include_class_members KDCReqImports
    
    attr_accessor :req_body
    alias_method :attr_req_body, :req_body
    undef_method :req_body
    alias_method :attr_req_body=, :req_body=
    undef_method :req_body=
    
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
    
    attr_accessor :p_adata
    alias_method :attr_p_adata, :p_adata
    undef_method :p_adata
    alias_method :attr_p_adata=, :p_adata=
    undef_method :p_adata=
    
    typesig { [Array.typed(PAData), KDCReqBody, ::Java::Int] }
    # optional
    def initialize(new_p_adata, new_req_body, req_type)
      @req_body = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
      @pvno = Krb5::PVNO
      @msg_type = req_type
      if (!(new_p_adata).nil?)
        @p_adata = Array.typed(PAData).new(new_p_adata.attr_length) { nil }
        i = 0
        while i < new_p_adata.attr_length
          if ((new_p_adata[i]).nil?)
            raise IOException.new("Cannot create a KDCRep")
          else
            @p_adata[i] = new_p_adata[i].clone
          end
          i += 1
        end
      end
      @req_body = new_req_body
    end
    
    typesig { [] }
    def initialize
      @req_body = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def initialize(data, req_type)
      @req_body = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
      init(DerValue.new(data), req_type)
    end
    
    typesig { [DerValue, ::Java::Int] }
    # Creates an KDCReq object from a DerValue object and asn1 type.
    # 
    # @param der a DER value of an KDCReq object.
    # @param req_type a encoded asn1 type value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exceptoin KrbErrException
    def initialize(der, req_type)
      @req_body = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
      init(der, req_type)
    end
    
    typesig { [DerValue, ::Java::Int] }
    # Initializes a KDCReq object from a DerValue.  The DER encoding
    # must be in the format specified by the KRB_KDC_REQ ASN.1 notation.
    # 
    # @param encoding a DER-encoded KDCReq object.
    # @param req_type an int indicating whether it's KRB_AS_REQ or KRB_TGS_REQ type
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception KrbException if an error occurs while constructing a Realm object,
    # or a Krb object from DER-encoded data.
    def init(encoding, req_type)
      der = nil
      sub_der = nil
      bint = nil
      if (!((encoding.get_tag & 0x1f)).equal?(req_type))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x1))
        bint = sub_der.get_data.get_big_integer
        @pvno = bint.int_value
        if (!(@pvno).equal?(Krb5::PVNO))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADVERSION)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x2))
        bint = sub_der.get_data.get_big_integer
        @msg_type = bint.int_value
        if (!(@msg_type).equal?(req_type))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MSG_TYPE)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x3))
        subsub_der = sub_der.get_data.get_der_value
        if (!(subsub_der.get_tag).equal?(DerValue.attr_tag_sequence_of))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
        v = Vector.new
        while (subsub_der.get_data.available > 0)
          v.add_element(PAData.new(subsub_der.get_data.get_der_value))
        end
        if (v.size > 0)
          @p_adata = Array.typed(PAData).new(v.size) { nil }
          v.copy_into(@p_adata)
        end
      else
        @p_adata = nil
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x4))
        subsub_der = sub_der.get_data.get_der_value
        @req_body = KDCReqBody.new(subsub_der, @msg_type)
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes this object to a byte array.
    # 
    # @return an byte array of encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      temp = nil
      bytes = nil
      out = nil
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@pvno))
      out = DerOutputStream.new
      out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@msg_type))
      out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), temp)
      if (!(@p_adata).nil? && @p_adata.attr_length > 0)
        temp = DerOutputStream.new
        i = 0
        while i < @p_adata.attr_length
          temp.write(@p_adata[i].asn1_encode)
          i += 1
        end
        bytes = DerOutputStream.new
        bytes.write(DerValue.attr_tag_sequence_of, temp)
        out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), bytes)
      end
      out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @req_body.asn1_encode(@msg_type))
      bytes = DerOutputStream.new
      bytes.write(DerValue.attr_tag_sequence, out)
      out = DerOutputStream.new
      out.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, @msg_type), bytes)
      return out.to_byte_array
    end
    
    typesig { [] }
    def asn1_encode_req_body
      return @req_body.asn1_encode(@msg_type)
    end
    
    private
    alias_method :initialize__kdcreq, :initialize
  end
  
end
