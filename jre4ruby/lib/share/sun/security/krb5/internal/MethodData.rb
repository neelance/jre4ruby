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
  module MethodDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Implements the ASN.1 EncKrbPrivPart type.
  # 
  # <xmp>
  # METHOD-DATA ::=    SEQUENCE {
  # method-type[0]   INTEGER,
  # method-data[1]   OCTET STRING OPTIONAL
  # }
  # </xmp>
  class MethodData 
    include_class_members MethodDataImports
    
    attr_accessor :method_type
    alias_method :attr_method_type, :method_type
    undef_method :method_type
    alias_method :attr_method_type=, :method_type=
    undef_method :method_type=
    
    attr_accessor :method_data
    alias_method :attr_method_data, :method_data
    undef_method :method_data
    alias_method :attr_method_data=, :method_data=
    undef_method :method_data=
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # optional
    def initialize(type, data)
      @method_type = 0
      @method_data = nil
      @method_type = type
      if (!(data).nil?)
        @method_data = data.clone
      end
    end
    
    typesig { [DerValue] }
    # Constructs a MethodData object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @method_type = 0
      @method_data = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        bint = der.get_data.get_big_integer
        @method_type = bint.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (encoding.get_data.available > 0)
        der = encoding.get_data.get_der_value
        if (((der.get_tag & 0x1f)).equal?(0x1))
          @method_data = der.get_data.get_octet_string
        else
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an MethodData object.
    # @return the byte array of encoded MethodData object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(BigInteger.value_of(@method_type))
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      if (!(@method_data).nil?)
        temp = DerOutputStream.new
        temp.put_octet_string(@method_data)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      end
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    private
    alias_method :initialize__method_data, :initialize
  end
  
end
