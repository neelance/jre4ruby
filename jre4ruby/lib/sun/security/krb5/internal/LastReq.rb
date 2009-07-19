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
  module LastReqImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
    }
  end
  
  # Implements the ASN.1 LastReq type.
  # 
  # <xmp>
  # LastReq         ::=     SEQUENCE OF SEQUENCE {
  # lr-type         [0] Int32,
  # lr-value        [1] KerberosTime
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class LastReq 
    include_class_members LastReqImports
    
    attr_accessor :entry
    alias_method :attr_entry, :entry
    undef_method :entry
    alias_method :attr_entry=, :entry=
    undef_method :entry=
    
    typesig { [Array.typed(LastReqEntry)] }
    def initialize(entries)
      @entry = nil
      if (!(entries).nil?)
        @entry = Array.typed(LastReqEntry).new(entries.attr_length) { nil }
        i = 0
        while i < entries.attr_length
          if ((entries[i]).nil?)
            raise IOException.new("Cannot create a LastReqEntry")
          else
            @entry[i] = entries[i].clone
          end
          ((i += 1) - 1)
        end
      end
    end
    
    typesig { [DerValue] }
    # Constructs a LastReq object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @entry = nil
      v = Vector.new
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      while (encoding.get_data.available > 0)
        v.add_element(LastReqEntry.new(encoding.get_data.get_der_value))
      end
      if (v.size > 0)
        @entry = Array.typed(LastReqEntry).new(v.size) { nil }
        v.copy_into(@entry)
      end
    end
    
    typesig { [] }
    # Encodes an LastReq object.
    # @return the byte array of encoded LastReq object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      if (!(@entry).nil? && @entry.attr_length > 0)
        temp = DerOutputStream.new
        i = 0
        while i < @entry.attr_length
          temp.write(@entry[i].asn1_encode)
          ((i += 1) - 1)
        end
        bytes.write(DerValue.attr_tag_sequence, temp)
        return bytes.to_byte_array
      end
      return nil
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a last request from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicates if this data field is optional
      # @return an instance of LastReq.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return LastReq.new(sub_der)
        end
      end
    }
    
    private
    alias_method :initialize__last_req, :initialize
  end
  
end
