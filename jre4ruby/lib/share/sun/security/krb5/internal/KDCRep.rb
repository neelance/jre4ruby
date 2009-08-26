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
  module KDCRepImports
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
  
  # Implements the ASN.1 KDC-REP type.
  # 
  # <xmp>
  # KDC-REP         ::= SEQUENCE {
  # pvno            [0] INTEGER (5),
  # msg-type        [1] INTEGER (11 -- AS -- | 13 -- TGS --),
  # padata          [2] SEQUENCE OF PA-DATA OPTIONAL
  # -- NOTE: not empty --,
  # crealm          [3] Realm,
  # cname           [4] PrincipalName,
  # ticket          [5] Ticket,
  # enc-part        [6] EncryptedData
  # -- EncASRepPart or EncTGSRepPart,
  # -- as appropriate
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KDCRep 
    include_class_members KDCRepImports
    
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
    
    attr_accessor :ticket
    alias_method :attr_ticket, :ticket
    undef_method :ticket
    alias_method :attr_ticket=, :ticket=
    undef_method :ticket=
    
    attr_accessor :enc_part
    alias_method :attr_enc_part, :enc_part
    undef_method :enc_part
    alias_method :attr_enc_part=, :enc_part=
    undef_method :enc_part=
    
    attr_accessor :enc_kdcrep_part
    alias_method :attr_enc_kdcrep_part, :enc_kdcrep_part
    undef_method :enc_kdcrep_part
    alias_method :attr_enc_kdcrep_part=, :enc_kdcrep_part=
    undef_method :enc_kdcrep_part=
    
    # not part of ASN.1 encoding
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
    
    # optional
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    typesig { [Array.typed(PAData), Realm, PrincipalName, Ticket, EncryptedData, ::Java::Int] }
    def initialize(new_p_adata, new_crealm, new_cname, new_ticket, new_enc_part, req_type)
      @crealm = nil
      @cname = nil
      @ticket = nil
      @enc_part = nil
      @enc_kdcrep_part = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
      @debug = Krb5::DEBUG
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
      @crealm = new_crealm
      @cname = new_cname
      @ticket = new_ticket
      @enc_part = new_enc_part
    end
    
    typesig { [] }
    def initialize
      @crealm = nil
      @cname = nil
      @ticket = nil
      @enc_part = nil
      @enc_kdcrep_part = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
      @debug = Krb5::DEBUG
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def initialize(data, req_type)
      @crealm = nil
      @cname = nil
      @ticket = nil
      @enc_part = nil
      @enc_kdcrep_part = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
      @debug = Krb5::DEBUG
      init(DerValue.new(data), req_type)
    end
    
    typesig { [DerValue, ::Java::Int] }
    def initialize(encoding, req_type)
      @crealm = nil
      @cname = nil
      @ticket = nil
      @enc_part = nil
      @enc_kdcrep_part = nil
      @pvno = 0
      @msg_type = 0
      @p_adata = nil
      @debug = Krb5::DEBUG
      init(encoding, req_type)
    end
    
    typesig { [DerValue, ::Java::Int] }
    # // Not used? Don't know what keyusage to use here %%%
    # 
    # public void decrypt(EncryptionKey key) throws Asn1Exception,
    # IOException, KrbException, RealmException {
    # encKDCRepPart = new EncKDCRepPart(encPart.decrypt(key),
    # msgType);
    # }
    # 
    # 
    # Initializes an KDCRep object.
    # 
    # @param encoding a single DER-encoded value.
    # @param req_type reply message type.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception RealmException if an error occurs while constructing a Realm object from DER-encoded data.
    # @exception KrbApErrException if the value read from the DER-encoded data stream does not match the pre-defined value.
    def init(encoding, req_type)
      der = nil
      sub_der = nil
      if (!((encoding.get_tag & 0x1f)).equal?(req_type))
        if (@debug)
          System.out.println(">>> KDCRep: init() " + "encoding tag is " + RJava.cast_to_string(encoding.get_tag) + " req type is " + RJava.cast_to_string(req_type))
        end
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
        if (!(@msg_type).equal?(req_type))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MSG_TYPE)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (((der.get_data.peek_byte & 0x1f)).equal?(0x2))
        sub_der = der.get_data.get_der_value
        padata = sub_der.get_data.get_sequence(1)
        @p_adata = Array.typed(PAData).new(padata.attr_length) { nil }
        i = 0
        while i < padata.attr_length
          @p_adata[i] = PAData.new(padata[i])
          i += 1
        end
      else
        @p_adata = nil
      end
      @crealm = Realm.parse(der.get_data, 0x3, false)
      @cname = PrincipalName.parse(der.get_data, 0x4, false)
      @ticket = Ticket.parse(der.get_data, 0x5, false)
      @enc_part = EncryptedData.parse(der.get_data, 0x6, false)
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes this object to a byte array.
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
      if (!(@p_adata).nil? && @p_adata.attr_length > 0)
        padata_stream = DerOutputStream.new
        i = 0
        while i < @p_adata.attr_length
          padata_stream.write(@p_adata[i].asn1_encode)
          i += 1
        end
        temp = DerOutputStream.new
        temp.write(DerValue.attr_tag_sequence_of, padata_stream)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), temp)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @crealm.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @cname.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), @ticket.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x6), @enc_part.asn1_encode)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    private
    alias_method :initialize__kdcrep, :initialize
  end
  
end
