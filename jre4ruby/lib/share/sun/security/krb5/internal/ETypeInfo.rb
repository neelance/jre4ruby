require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal
  module ETypeInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Io, :IOException
    }
  end
  
  # Implements the ASN.1 ETYPE-INFO-ENTRY type.
  # 
  # ETYPE-INFO-ENTRY     ::= SEQUENCE {
  #         etype        [0] Int32,
  #         salt         [1] OCTET STRING OPTIONAL
  #   }
  # 
  # @author Seema Malkani
  class ETypeInfo 
    include_class_members ETypeInfoImports
    
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
    
    class_module.module_eval {
      const_set_lazy(:TAG_TYPE) { 0 }
      const_attr_reader  :TAG_TYPE
      
      const_set_lazy(:TAG_VALUE) { 1 }
      const_attr_reader  :TAG_VALUE
    }
    
    typesig { [] }
    def initialize
      @etype = 0
      @salt = nil
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(etype, salt)
      @etype = 0
      @salt = nil
      @etype = etype
      if (!(salt).nil?)
        @salt = salt.clone
      end
    end
    
    typesig { [] }
    def clone
      etype_info = ETypeInfo.new
      etype_info.attr_etype = @etype
      if (!(@salt).nil?)
        etype_info.attr_salt = Array.typed(::Java::Byte).new(@salt.attr_length) { 0 }
        System.arraycopy(@salt, 0, etype_info.attr_salt, 0, @salt.attr_length)
      end
      return etype_info
    end
    
    typesig { [DerValue] }
    # Constructs a ETypeInfo object.
    # @param encoding a DER-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an
    #            ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @etype = 0
      @salt = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      # etype
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @etype = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      # salt
      if (encoding.get_data.available > 0)
        der = encoding.get_data.get_der_value
        if (((der.get_tag & 0x1f)).equal?(0x1))
          @salt = der.get_data.get_octet_string
        end
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # Encodes this object to an OutputStream.
    # 
    # @return byte array of the encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception Asn1Exception on encoding errors.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(@etype)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_TYPE), temp)
      if (!(@salt).nil?)
        temp = DerOutputStream.new
        temp.put_octet_string(@salt)
        bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_VALUE), temp)
      end
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    typesig { [] }
    # accessor methods
    def get_etype
      return @etype
    end
    
    typesig { [] }
    def get_salt
      return (((@salt).nil?) ? nil : @salt.clone)
    end
    
    private
    alias_method :initialize__etype_info, :initialize
  end
  
end
