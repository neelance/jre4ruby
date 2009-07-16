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
  module PADataImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Io, :IOException
    }
  end
  
  # 
  # Implements the ASN.1 PA-DATA type.
  # 
  # <xmp>
  # PA-DATA         ::= SEQUENCE {
  # -- NOTE: first tag is [1], not [0]
  # padata-type     [1] Int32,
  # padata-value    [2] OCTET STRING -- might be encoded AP-REQ
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class PAData 
    include_class_members PADataImports
    
    attr_accessor :p_adata_type
    alias_method :attr_p_adata_type, :p_adata_type
    undef_method :p_adata_type
    alias_method :attr_p_adata_type=, :p_adata_type=
    undef_method :p_adata_type=
    
    attr_accessor :p_adata_value
    alias_method :attr_p_adata_value, :p_adata_value
    undef_method :p_adata_value
    alias_method :attr_p_adata_value=, :p_adata_value=
    undef_method :p_adata_value=
    
    class_module.module_eval {
      const_set_lazy(:TAG_PATYPE) { 1 }
      const_attr_reader  :TAG_PATYPE
      
      const_set_lazy(:TAG_PAVALUE) { 2 }
      const_attr_reader  :TAG_PAVALUE
    }
    
    typesig { [] }
    def initialize
      @p_adata_type = 0
      @p_adata_value = nil
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(new_p_adata_type, new_p_adata_value)
      @p_adata_type = 0
      @p_adata_value = nil
      @p_adata_type = new_p_adata_type
      if (!(new_p_adata_value).nil?)
        @p_adata_value = new_p_adata_value.clone
      end
    end
    
    typesig { [] }
    def clone
      new_p_adata = PAData.new
      new_p_adata.attr_p_adata_type = @p_adata_type
      if (!(@p_adata_value).nil?)
        new_p_adata.attr_p_adata_value = Array.typed(::Java::Byte).new(@p_adata_value.attr_length) { 0 }
        System.arraycopy(@p_adata_value, 0, new_p_adata.attr_p_adata_value, 0, @p_adata_value.attr_length)
      end
      return new_p_adata
    end
    
    typesig { [DerValue] }
    # 
    # Constructs a PAData object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @p_adata_type = 0
      @p_adata_value = nil
      der = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x1))
        @p_adata_type = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x2))
        @p_adata_value = der.get_data.get_octet_string
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # 
    # Encodes this object to an OutputStream.
    # 
    # @return byte array of the encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception Asn1Exception on encoding errors.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(@p_adata_type)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_PATYPE), temp)
      temp = DerOutputStream.new
      temp.put_octet_string(@p_adata_value)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_PAVALUE), temp)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    typesig { [] }
    # accessor methods
    def get_type
      return @p_adata_type
    end
    
    typesig { [] }
    def get_value
      return (((@p_adata_value).nil?) ? nil : @p_adata_value.clone)
    end
    
    private
    alias_method :initialize__padata, :initialize
  end
  
end
