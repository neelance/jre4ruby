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
  module APOptionsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5::Internal::Util, :KerberosFlags
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # Implements the ASN.1 APOptions type.
  # 
  # <xmp>
  # APOptions    ::= KerberosFlags
  # -- reserved(0),
  # -- use-session-key(1),
  # -- mutual-required(2)
  # </xmp>
  # 
  # KerberosFlags   ::= BIT STRING (SIZE (32..MAX))
  # -- minimum number of bits shall be sent,
  # -- but no fewer than 32
  # 
  # <p>
  # This definition reflects the Network Working Group RFC4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class APOptions < APOptionsImports.const_get :KerberosFlags
    include_class_members APOptionsImports
    
    typesig { [] }
    def initialize
      super(Krb5::AP_OPTS_MAX + 1)
    end
    
    typesig { [::Java::Int] }
    def initialize(one_bit)
      super(Krb5::AP_OPTS_MAX + 1)
      set(one_bit, true)
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(size, data)
      super(size, data)
      if ((size > data.attr_length * BITS_PER_UNIT) || (size > Krb5::AP_OPTS_MAX + 1))
        raise Asn1Exception.new(Krb5::BITSTRING_BAD_LENGTH)
      end
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    def initialize(data)
      super(data)
      if (data.attr_length > Krb5::AP_OPTS_MAX + 1)
        raise Asn1Exception.new(Krb5::BITSTRING_BAD_LENGTH)
      end
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      initialize__apoptions(encoding.get_unaligned_bit_string(true).to_boolean_array)
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) an APOptions from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional.
      # @return an instance of APOptions.
      # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
      # @exception IOException if an I/O error occurs while reading encoded data.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return APOptions.new(sub_der)
        end
      end
    }
    
    private
    alias_method :initialize__apoptions, :initialize
  end
  
end
