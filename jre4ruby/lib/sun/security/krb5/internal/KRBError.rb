require "rjava"

# 
# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KRBErrorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Security::Krb5, :Checksum
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5, :Realm
      include_const ::Sun::Security::Krb5, :RealmException
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Arrays
    }
  end
  
  # 
  # Implements the ASN.1 KRBError type.
  # 
  # <xmp>
  # KRB-ERROR       ::= [APPLICATION 30] SEQUENCE {
  # pvno            [0] INTEGER (5),
  # msg-type        [1] INTEGER (30),
  # ctime           [2] KerberosTime OPTIONAL,
  # cusec           [3] Microseconds OPTIONAL,
  # stime           [4] KerberosTime,
  # susec           [5] Microseconds,
  # error-code      [6] Int32,
  # crealm          [7] Realm OPTIONAL,
  # cname           [8] PrincipalName OPTIONAL,
  # realm           [9] Realm -- service realm --,
  # sname           [10] PrincipalName -- service name --,
  # e-text          [11] KerberosString OPTIONAL,
  # e-data          [12] OCTET STRING OPTIONAL
  # }
  # 
  # METHOD-DATA     ::= SEQUENCE OF PA-DATA
  # 
  # TYPED-DATA      ::= SEQUENCE SIZE (1..MAX) OF SEQUENCE {
  # data-type       [0] Int32,
  # data-value      [1] OCTET STRING OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KRBError 
    include_class_members KRBErrorImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 3643809337475284503 }
      const_attr_reader  :SerialVersionUID
    }
    
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
    
    attr_accessor :c_time
    alias_method :attr_c_time, :c_time
    undef_method :c_time
    alias_method :attr_c_time=, :c_time=
    undef_method :c_time=
    
    # optional
    attr_accessor :cu_sec
    alias_method :attr_cu_sec, :cu_sec
    undef_method :cu_sec
    alias_method :attr_cu_sec=, :cu_sec=
    undef_method :cu_sec=
    
    # optional
    attr_accessor :s_time
    alias_method :attr_s_time, :s_time
    undef_method :s_time
    alias_method :attr_s_time=, :s_time=
    undef_method :s_time=
    
    attr_accessor :su_sec
    alias_method :attr_su_sec, :su_sec
    undef_method :su_sec
    alias_method :attr_su_sec=, :su_sec=
    undef_method :su_sec=
    
    attr_accessor :error_code
    alias_method :attr_error_code, :error_code
    undef_method :error_code
    alias_method :attr_error_code=, :error_code=
    undef_method :error_code=
    
    attr_accessor :crealm
    alias_method :attr_crealm, :crealm
    undef_method :crealm
    alias_method :attr_crealm=, :crealm=
    undef_method :crealm=
    
    # optional
    attr_accessor :cname
    alias_method :attr_cname, :cname
    undef_method :cname
    alias_method :attr_cname=, :cname=
    undef_method :cname=
    
    # optional
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
    
    attr_accessor :e_text
    alias_method :attr_e_text, :e_text
    undef_method :e_text
    alias_method :attr_e_text=, :e_text=
    undef_method :e_text=
    
    # optional
    attr_accessor :e_data
    alias_method :attr_e_data, :e_data
    undef_method :e_data
    alias_method :attr_e_data=, :e_data=
    undef_method :e_data=
    
    # optional
    attr_accessor :e_cksum
    alias_method :attr_e_cksum, :e_cksum
    undef_method :e_cksum
    alias_method :attr_e_cksum=, :e_cksum=
    undef_method :e_cksum=
    
    # optional
    # pre-auth info
    attr_accessor :etype
    alias_method :attr_etype, :etype
    undef_method :etype
    alias_method :attr_etype=, :etype=
    undef_method :etype=
    
    attr_accessor :salt
    alias_method :attr_salt, :salt
    undef_method :salt
    alias_method :attr_salt=, :salt=
    undef_method :salt=
    
    attr_accessor :s2kparams
    alias_method :attr_s2kparams, :s2kparams
    undef_method :s2kparams
    alias_method :attr_s2kparams=, :s2kparams=
    undef_method :s2kparams=
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    typesig { [ObjectInputStream] }
    def read_object(is)
      begin
        init(DerValue.new(is.read_object))
        parse_edata(@e_data)
      rescue Exception => e
        raise IOException.new(e)
      end
    end
    
    typesig { [ObjectOutputStream] }
    def write_object(os)
      begin
        os.write_object(asn1_encode)
      rescue Exception => e
        raise IOException.new(e)
      end
    end
    
    typesig { [APOptions, KerberosTime, JavaInteger, KerberosTime, JavaInteger, ::Java::Int, Realm, PrincipalName, Realm, PrincipalName, String, Array.typed(::Java::Byte)] }
    def initialize(new_ap_options, new_c_time, new_cu_sec, new_s_time, new_su_sec, new_error_code, new_crealm, new_cname, new_realm, new_sname, new_e_text, new_e_data)
      @pvno = 0
      @msg_type = 0
      @c_time = nil
      @cu_sec = nil
      @s_time = nil
      @su_sec = nil
      @error_code = 0
      @crealm = nil
      @cname = nil
      @realm = nil
      @sname = nil
      @e_text = nil
      @e_data = nil
      @e_cksum = nil
      @etype = 0
      @salt = nil
      @s2kparams = nil
      @pvno = Krb5::PVNO
      @msg_type = Krb5::KRB_ERROR
      @c_time = new_c_time
      @cu_sec = new_cu_sec
      @s_time = new_s_time
      @su_sec = new_su_sec
      @error_code = new_error_code
      @crealm = new_crealm
      @cname = new_cname
      @realm = new_realm
      @sname = new_sname
      @e_text = new_e_text
      @e_data = new_e_data
      parse_edata(@e_data)
    end
    
    typesig { [APOptions, KerberosTime, JavaInteger, KerberosTime, JavaInteger, ::Java::Int, Realm, PrincipalName, Realm, PrincipalName, String, Array.typed(::Java::Byte), Checksum] }
    def initialize(new_ap_options, new_c_time, new_cu_sec, new_s_time, new_su_sec, new_error_code, new_crealm, new_cname, new_realm, new_sname, new_e_text, new_e_data, new_e_cksum)
      @pvno = 0
      @msg_type = 0
      @c_time = nil
      @cu_sec = nil
      @s_time = nil
      @su_sec = nil
      @error_code = 0
      @crealm = nil
      @cname = nil
      @realm = nil
      @sname = nil
      @e_text = nil
      @e_data = nil
      @e_cksum = nil
      @etype = 0
      @salt = nil
      @s2kparams = nil
      @pvno = Krb5::PVNO
      @msg_type = Krb5::KRB_ERROR
      @c_time = new_c_time
      @cu_sec = new_cu_sec
      @s_time = new_s_time
      @su_sec = new_su_sec
      @error_code = new_error_code
      @crealm = new_crealm
      @cname = new_cname
      @realm = new_realm
      @sname = new_sname
      @e_text = new_e_text
      @e_data = new_e_data
      @e_cksum = new_e_cksum
      parse_edata(@e_data)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      @pvno = 0
      @msg_type = 0
      @c_time = nil
      @cu_sec = nil
      @s_time = nil
      @su_sec = nil
      @error_code = 0
      @crealm = nil
      @cname = nil
      @realm = nil
      @sname = nil
      @e_text = nil
      @e_data = nil
      @e_cksum = nil
      @etype = 0
      @salt = nil
      @s2kparams = nil
      init(DerValue.new(data))
      parse_edata(@e_data)
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      @pvno = 0
      @msg_type = 0
      @c_time = nil
      @cu_sec = nil
      @s_time = nil
      @su_sec = nil
      @error_code = 0
      @crealm = nil
      @cname = nil
      @realm = nil
      @sname = nil
      @e_text = nil
      @e_data = nil
      @e_cksum = nil
      @etype = 0
      @salt = nil
      @s2kparams = nil
      init(encoding)
      show_debug
      parse_edata(@e_data)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Attention:
    # 
    # According to RFC 4120, e-data field in a KRB-ERROR message is
    # a METHOD-DATA when errorCode is KDC_ERR_PREAUTH_REQUIRED,
    # and application-specific otherwise (The RFC suggests using
    # TYPED-DATA).
    # 
    # Hence, the ideal procedure to parse e-data should look like:
    # 
    # if (errorCode is KDC_ERR_PREAUTH_REQUIRED) {
    # parse as METHOD-DATA
    # } else {
    # try parsing as TYPED-DATA
    # }
    # 
    # Unfortunately, we know that some implementations also use the
    # METHOD-DATA format for errorcode KDC_ERR_PREAUTH_FAILED, and
    # do not use the TYPED-DATA for other errorcodes (say,
    # KDC_ERR_CLIENT_REVOKED).
    # 
    # parse the edata field
    def parse_edata(data)
      if ((data).nil?)
        return
      end
      # We need to parse eData as METHOD-DATA for both errorcodes.
      if ((@error_code).equal?(Krb5::KDC_ERR_PREAUTH_REQUIRED) || (@error_code).equal?(Krb5::KDC_ERR_PREAUTH_FAILED))
        begin
          # RFC 4120 does not guarantee that eData is METHOD-DATA when
          # errorCode is KDC_ERR_PREAUTH_FAILED. Therefore, the parse
          # may fail.
          parse_padata(data)
        rescue Exception => e
          if (self.attr_debug)
            System.out.println("Unable to parse eData field of KRB-ERROR:\n" + (Sun::Misc::HexDumpEncoder.new.encode_buffer(data)).to_s)
          end
          ioe = IOException.new("Unable to parse eData field of KRB-ERROR")
          ioe.init_cause(e)
          raise ioe
        end
      else
        if (self.attr_debug)
          System.out.println("Unknown eData field of KRB-ERROR:\n" + (Sun::Misc::HexDumpEncoder.new.encode_buffer(data)).to_s)
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Try parsing the data as a sequence of PA-DATA.
    # @param data the data block
    def parse_padata(data)
      der_pa = DerValue.new(data)
      while (der_pa.attr_data.available > 0)
        # read the PA-DATA
        tmp = der_pa.attr_data.get_der_value
        pa_data = PAData.new(tmp)
        pa_type = pa_data.get_type
        pa_value = pa_data.get_value
        if (self.attr_debug)
          System.out.println(">>>Pre-Authentication Data:")
          System.out.println("\t PA-DATA type = " + (pa_type).to_s)
        end
        case (pa_type)
        when Krb5::PA_ENC_TIMESTAMP
          if (self.attr_debug)
            System.out.println("\t PA-ENC-TIMESTAMP")
          end
        when Krb5::PA_ETYPE_INFO
          if (!(pa_value).nil?)
            der = DerValue.new(pa_value)
            value = der.attr_data.get_der_value
            info = ETypeInfo.new(value)
            @etype = info.get_etype
            @salt = info.get_salt
            if (self.attr_debug)
              System.out.println("\t PA-ETYPE-INFO etype = " + (@etype).to_s)
            end
          end
        when Krb5::PA_ETYPE_INFO2
          if (!(pa_value).nil?)
            der_ = DerValue.new(pa_value)
            value_ = der_.attr_data.get_der_value
            info2 = ETypeInfo2.new(value_)
            @etype = info2.get_etype
            @salt = info2.get_salt
            @s2kparams = info2.get_params
            if (self.attr_debug)
              System.out.println("\t PA-ETYPE-INFO2 etype = " + (@etype).to_s)
            end
          end
        else
          # Unknown Pre-auth type
        end
      end
    end
    
    typesig { [] }
    def get_server_time
      return @s_time
    end
    
    typesig { [] }
    def get_client_time
      return @c_time
    end
    
    typesig { [] }
    def get_server_micro_seconds
      return @su_sec
    end
    
    typesig { [] }
    def get_client_micro_seconds
      return @cu_sec
    end
    
    typesig { [] }
    def get_error_code
      return @error_code
    end
    
    typesig { [] }
    # access pre-auth info
    def get_etype
      return @etype
    end
    
    typesig { [] }
    # access pre-auth info
    def get_salt
      return (((@salt).nil?) ? nil : @salt.clone)
    end
    
    typesig { [] }
    # access pre-auth info
    def get_params
      return (((@s2kparams).nil?) ? nil : @s2kparams.clone)
    end
    
    typesig { [] }
    def get_error_string
      return @e_text
    end
    
    typesig { [DerValue] }
    # 
    # Initializes a KRBError object.
    # @param encoding a DER-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception KrbApErrException if the value read from the DER-encoded data
    # stream does not match the pre-defined value.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def init(encoding)
      der = nil
      sub_der = nil
      if ((!((encoding.get_tag & 0x1f)).equal?(0x1e)) || (!(encoding.is_application).equal?(true)) || (!(encoding.is_constructed).equal?(true)))
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
        if (!(@msg_type).equal?(Krb5::KRB_ERROR))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MSG_TYPE)
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @c_time = KerberosTime.parse(der.get_data, 0x2, true)
      if (((der.get_data.peek_byte & 0x1f)).equal?(0x3))
        sub_der = der.get_data.get_der_value
        @cu_sec = sub_der.get_data.get_big_integer.int_value
      else
        @cu_sec = nil
      end
      @s_time = KerberosTime.parse(der.get_data, 0x4, false)
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x5))
        @su_sec = sub_der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      sub_der = der.get_data.get_der_value
      if (((sub_der.get_tag & 0x1f)).equal?(0x6))
        @error_code = sub_der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @crealm = Realm.parse(der.get_data, 0x7, true)
      @cname = PrincipalName.parse(der.get_data, 0x8, true)
      @realm = Realm.parse(der.get_data, 0x9, false)
      @sname = PrincipalName.parse(der.get_data, 0xa, false)
      @e_text = (nil).to_s
      @e_data = nil
      @e_cksum = nil
      if (der.get_data.available > 0)
        if (((der.get_data.peek_byte & 0x1f)).equal?(0xb))
          sub_der = der.get_data.get_der_value
          @e_text = (sub_der.get_data.get_general_string).to_s
        end
      end
      if (der.get_data.available > 0)
        if (((der.get_data.peek_byte & 0x1f)).equal?(0xc))
          sub_der = der.get_data.get_der_value
          @e_data = sub_der.get_data.get_octet_string
        end
      end
      if (der.get_data.available > 0)
        @e_cksum = Checksum.parse(der.get_data, 0xd, true)
      end
      if (der.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # 
    # For debug use only
    def show_debug
      if (self.attr_debug)
        System.out.println(">>>KRBError:")
        if (!(@c_time).nil?)
          System.out.println("\t cTime is " + (@c_time.to_date.to_s).to_s + " " + (@c_time.to_date.get_time).to_s)
        end
        if (!(@cu_sec).nil?)
          System.out.println("\t cuSec is " + (@cu_sec.int_value).to_s)
        end
        System.out.println("\t sTime is " + (@s_time.to_date.to_s).to_s + " " + (@s_time.to_date.get_time).to_s)
        System.out.println("\t suSec is " + (@su_sec).to_s)
        System.out.println("\t error code is " + (@error_code).to_s)
        System.out.println("\t error Message is " + (Krb5.get_error_message(@error_code)).to_s)
        if (!(@crealm).nil?)
          System.out.println("\t crealm is " + (@crealm.to_s).to_s)
        end
        if (!(@cname).nil?)
          System.out.println("\t cname is " + (@cname.to_s).to_s)
        end
        if (!(@realm).nil?)
          System.out.println("\t realm is " + (@realm.to_s).to_s)
        end
        if (!(@sname).nil?)
          System.out.println("\t sname is " + (@sname.to_s).to_s)
        end
        if (!(@e_data).nil?)
          System.out.println("\t eData provided.")
        end
        if (!(@e_cksum).nil?)
          System.out.println("\t checksum provided.")
        end
        System.out.println("\t msgType is " + (@msg_type).to_s)
      end
    end
    
    typesig { [] }
    # 
    # Encodes an KRBError object.
    # @return the byte array of encoded KRBError object.
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
      if (!(@c_time).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @c_time.asn1_encode)
      end
      if (!(@cu_sec).nil?)
        temp = DerOutputStream.new
        temp.put_integer(BigInteger.value_of(@cu_sec.int_value))
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), temp)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @s_time.asn1_encode)
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@su_sec.int_value))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), temp)
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@error_code))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x6), temp)
      if (!(@crealm).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x7), @crealm.asn1_encode)
      end
      if (!(@cname).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x8), @cname.asn1_encode)
      end
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x9), @realm.asn1_encode)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xa), @sname.asn1_encode)
      if (!(@e_text).nil?)
        temp = DerOutputStream.new
        temp.put_general_string(@e_text)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xb), temp)
      end
      if (!(@e_data).nil?)
        temp = DerOutputStream.new
        temp.put_octet_string(@e_data)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xc), temp)
      end
      if (!(@e_cksum).nil?)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xd), @e_cksum.asn1_encode)
      end
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      bytes = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_APPLICATION, true, 0x1e), temp)
      return bytes.to_byte_array
    end
    
    typesig { [Object] }
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(KRBError)))
        return false
      end
      other = obj
      return (@pvno).equal?(other.attr_pvno) && (@msg_type).equal?(other.attr_msg_type) && is_equal(@c_time, other.attr_c_time) && is_equal(@cu_sec, other.attr_cu_sec) && is_equal(@s_time, other.attr_s_time) && is_equal(@su_sec, other.attr_su_sec) && (@error_code).equal?(other.attr_error_code) && is_equal(@crealm, other.attr_crealm) && is_equal(@cname, other.attr_cname) && is_equal(@realm, other.attr_realm) && is_equal(@sname, other.attr_sname) && is_equal(@e_text, other.attr_e_text) && (Java::Util::Arrays == @e_data) && is_equal(@e_cksum, other.attr_e_cksum)
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      def is_equal(a, b)
        return ((a).nil?) ? ((b).nil?) : ((a == b))
      end
    }
    
    typesig { [] }
    def hash_code
      result = 17
      result = 37 * result + @pvno
      result = 37 * result + @msg_type
      if (!(@c_time).nil?)
        result = 37 * result + @c_time.hash_code
      end
      if (!(@cu_sec).nil?)
        result = 37 * result + @cu_sec.hash_code
      end
      if (!(@s_time).nil?)
        result = 37 * result + @s_time.hash_code
      end
      if (!(@su_sec).nil?)
        result = 37 * result + @su_sec.hash_code
      end
      result = 37 * result + @error_code
      if (!(@crealm).nil?)
        result = 37 * result + @crealm.hash_code
      end
      if (!(@cname).nil?)
        result = 37 * result + @cname.hash_code
      end
      if (!(@realm).nil?)
        result = 37 * result + @realm.hash_code
      end
      if (!(@sname).nil?)
        result = 37 * result + @sname.hash_code
      end
      if (!(@e_text).nil?)
        result = 37 * result + @e_text.hash_code
      end
      result = 37 * result + Arrays.hash_code(@e_data)
      if (!(@e_cksum).nil?)
        result = 37 * result + @e_cksum.hash_code
      end
      return result
    end
    
    private
    alias_method :initialize__krberror, :initialize
  end
  
end
