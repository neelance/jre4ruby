require "rjava"

# 
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
  module LastReqEntryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Io, :IOException
    }
  end
  
  class LastReqEntry 
    include_class_members LastReqEntryImports
    
    attr_accessor :lr_type
    alias_method :attr_lr_type, :lr_type
    undef_method :lr_type
    alias_method :attr_lr_type=, :lr_type=
    undef_method :lr_type=
    
    attr_accessor :lr_value
    alias_method :attr_lr_value, :lr_value
    undef_method :lr_value
    alias_method :attr_lr_value=, :lr_value=
    undef_method :lr_value=
    
    typesig { [] }
    def initialize
      @lr_type = 0
      @lr_value = nil
    end
    
    typesig { [::Java::Int, KerberosTime] }
    def initialize(type, time)
      @lr_type = 0
      @lr_value = nil
      @lr_type = type
      @lr_value = time
      # XXX check the type and time.
    end
    
    typesig { [DerValue] }
    # 
    # Constructs a LastReqEntry object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @lr_type = 0
      @lr_value = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = nil
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @lr_type = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @lr_value = KerberosTime.parse(encoding.get_data, 0x1, false)
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # 
    # Encodes an LastReqEntry object.
    # @return the byte array of encoded LastReqEntry object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(@lr_type)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @lr_value.asn1_encode)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    typesig { [] }
    def clone
      new_entry = LastReqEntry.new
      new_entry.attr_lr_type = @lr_type
      new_entry.attr_lr_value = @lr_value.clone
      return new_entry
    end
    
    private
    alias_method :initialize__last_req_entry, :initialize
  end
  
end
