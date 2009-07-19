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
  module AuthorizationDataEntryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5::Internal::Ccache, :CCacheOutputStream
    }
  end
  
  class AuthorizationDataEntry 
    include_class_members AuthorizationDataEntryImports
    include Cloneable
    
    attr_accessor :ad_type
    alias_method :attr_ad_type, :ad_type
    undef_method :ad_type
    alias_method :attr_ad_type=, :ad_type=
    undef_method :ad_type=
    
    attr_accessor :ad_data
    alias_method :attr_ad_data, :ad_data
    undef_method :ad_data
    alias_method :attr_ad_data=, :ad_data=
    undef_method :ad_data=
    
    typesig { [] }
    def initialize
      @ad_type = 0
      @ad_data = nil
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(new_ad_type, new_ad_data)
      @ad_type = 0
      @ad_data = nil
      @ad_type = new_ad_type
      @ad_data = new_ad_data
    end
    
    typesig { [] }
    def clone
      new_authorization_data_entry = AuthorizationDataEntry.new
      new_authorization_data_entry.attr_ad_type = @ad_type
      if (!(@ad_data).nil?)
        new_authorization_data_entry.attr_ad_data = Array.typed(::Java::Byte).new(@ad_data.attr_length) { 0 }
        System.arraycopy(@ad_data, 0, new_authorization_data_entry.attr_ad_data, 0, @ad_data.attr_length)
      end
      return new_authorization_data_entry
    end
    
    typesig { [DerValue] }
    # Constructs an instance of AuthorizationDataEntry.
    # @param encoding a single DER-encoded value.
    def initialize(encoding)
      @ad_type = 0
      @ad_data = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @ad_type = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x1))
        @ad_data = der.get_data.get_octet_string
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes an AuthorizationDataEntry object.
    # @return byte array of encoded AuthorizationDataEntry object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(@ad_type)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      temp.put_octet_string(@ad_data)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    typesig { [CCacheOutputStream] }
    # Writes the entry's data fields in FCC format to an output stream.
    # 
    # @param cos a <code>CCacheOutputStream</code>.
    # @exception IOException if an I/O exception occurs.
    def write_entry(cos)
      cos.write16(@ad_type)
      cos.write32(@ad_data.attr_length)
      cos.write(@ad_data, 0, @ad_data.attr_length)
    end
    
    typesig { [] }
    def to_s
      return ("adType=" + (@ad_type).to_s + " adData.length=" + (@ad_data.attr_length).to_s)
    end
    
    private
    alias_method :initialize__authorization_data_entry, :initialize
  end
  
end
