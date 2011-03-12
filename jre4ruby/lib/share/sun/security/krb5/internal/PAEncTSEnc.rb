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
  module PAEncTSEncImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 PAEncTSEnc type.
  # 
  # <xmp>
  # PA-ENC-TS-ENC                ::= SEQUENCE {
  #      patimestamp     [0] KerberosTime -- client's time --,
  #      pausec          [1] Microseconds OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class PAEncTSEnc 
    include_class_members PAEncTSEncImports
    
    attr_accessor :p_atime_stamp
    alias_method :attr_p_atime_stamp, :p_atime_stamp
    undef_method :p_atime_stamp
    alias_method :attr_p_atime_stamp=, :p_atime_stamp=
    undef_method :p_atime_stamp=
    
    attr_accessor :p_ausec
    alias_method :attr_p_ausec, :p_ausec
    undef_method :p_ausec
    alias_method :attr_p_ausec=, :p_ausec=
    undef_method :p_ausec=
    
    typesig { [KerberosTime, JavaInteger] }
    # optional
    def initialize(new_p_atime_stamp, new_p_ausec)
      @p_atime_stamp = nil
      @p_ausec = nil
      @p_atime_stamp = new_p_atime_stamp
      @p_ausec = new_p_ausec
    end
    
    typesig { [] }
    def initialize
      @p_atime_stamp = nil
      @p_ausec = nil
      now = KerberosTime.new(KerberosTime::NOW)
      @p_atime_stamp = now
      @p_ausec = now.get_micro_seconds
    end
    
    typesig { [DerValue] }
    # Constructs a PAEncTSEnc object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @p_atime_stamp = nil
      @p_ausec = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @p_atime_stamp = KerberosTime.parse(encoding.get_data, 0x0, false)
      if (encoding.get_data.available > 0)
        der = encoding.get_data.get_der_value
        if (((der.get_tag & 0x1f)).equal?(0x1))
          @p_ausec = der.get_data.get_big_integer.int_value
        else
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes a PAEncTSEnc object.
    # @return the byte array of encoded PAEncTSEnc object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), @p_atime_stamp.asn1_encode)
      if (!(@p_ausec).nil?)
        temp = DerOutputStream.new
        temp.put_integer(BigInteger.value_of(@p_ausec.int_value))
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      end
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    private
    alias_method :initialize__paenc_tsenc, :initialize
  end
  
end
