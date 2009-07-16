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
  module AuthorizationDataImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Krb5::Internal::Ccache, :CCacheOutputStream
    }
  end
  
  # 
  # In RFC4120, the ASN.1 AuthorizationData is defined as:
  # 
  # AuthorizationData            ::= SEQUENCE OF SEQUENCE {
  # ad-type         [0] Int32,
  # ad-data         [1] OCTET STRING
  # }
  # 
  # Here, two classes are used to implement it and they can be represented as follows:
  # 
  # AuthorizationData ::= SEQUENCE OF AuthorizationDataEntry
  # AuthorizationDataEntry ::= SEQUENCE {
  # ad-type[0]  Int32,
  # ad-data[1]  OCTET STRING
  # }
  class AuthorizationData 
    include_class_members AuthorizationDataImports
    include Cloneable
    
    attr_accessor :entry
    alias_method :attr_entry, :entry
    undef_method :entry
    alias_method :attr_entry=, :entry=
    undef_method :entry=
    
    typesig { [] }
    def initialize
      @entry = nil
    end
    
    typesig { [Array.typed(AuthorizationDataEntry)] }
    def initialize(new_entries)
      @entry = nil
      if (!(new_entries).nil?)
        @entry = Array.typed(AuthorizationDataEntry).new(new_entries.attr_length) { nil }
        i = 0
        while i < new_entries.attr_length
          if ((new_entries[i]).nil?)
            raise IOException.new("Cannot create an AuthorizationData")
          else
            @entry[i] = new_entries[i].clone
          end
          ((i += 1) - 1)
        end
      end
    end
    
    typesig { [AuthorizationDataEntry] }
    def initialize(new_entry)
      @entry = nil
      @entry = Array.typed(AuthorizationDataEntry).new(1) { nil }
      @entry[0] = new_entry
    end
    
    typesig { [] }
    def clone
      new_authorization_data = AuthorizationData.new
      if (!(@entry).nil?)
        new_authorization_data.attr_entry = Array.typed(AuthorizationDataEntry).new(@entry.attr_length) { nil }
        i = 0
        while i < @entry.attr_length
          new_authorization_data.attr_entry[i] = @entry[i].clone
          ((i += 1) - 1)
        end
      end
      return new_authorization_data
    end
    
    typesig { [DerValue] }
    # 
    # Constructs a new <code>AuthorizationData,</code> instance.
    # @param der a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(der)
      @entry = nil
      v = Vector.new
      if (!(der.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      while (der.get_data.available > 0)
        v.add_element(AuthorizationDataEntry.new(der.get_data.get_der_value))
      end
      if (v.size > 0)
        @entry = Array.typed(AuthorizationDataEntry).new(v.size) { nil }
        v.copy_into(@entry)
      end
    end
    
    typesig { [] }
    # 
    # Encodes an <code>AuthorizationData</code> object.
    # @return byte array of encoded <code>AuthorizationData</code> object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      der = Array.typed(DerValue).new(@entry.attr_length) { nil }
      i = 0
      while i < @entry.attr_length
        der[i] = DerValue.new(@entry[i].asn1_encode)
        ((i += 1) - 1)
      end
      bytes.put_sequence(der)
      return bytes.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # 
      # Parse (unmarshal) an <code>AuthorizationData</code> object from a DER input stream.
      # This form of parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
      # @exception IOException if an I/O error occurs while reading encoded data.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicates if this data field is optional
      # @return an instance of AuthorizationData.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return AuthorizationData.new(sub_der)
        end
      end
    }
    
    typesig { [CCacheOutputStream] }
    # 
    # Writes <code>AuthorizationData</code> data fields to a output stream.
    # 
    # @param cos a <code>CCacheOutputStream</code> to be written to.
    # @exception IOException if an I/O exception occurs.
    def write_auth(cos)
      i = 0
      while i < @entry.attr_length
        @entry[i].write_entry(cos)
        ((i += 1) - 1)
      end
    end
    
    typesig { [] }
    def to_s
      ret_val = "AuthorizationData:\n"
      i = 0
      while i < @entry.attr_length
        ret_val += (@entry[i].to_s).to_s
        ((i += 1) - 1)
      end
      return ret_val
    end
    
    private
    alias_method :initialize__authorization_data, :initialize
  end
  
end
