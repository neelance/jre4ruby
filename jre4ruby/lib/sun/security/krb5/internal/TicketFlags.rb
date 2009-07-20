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
  module TicketFlagsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5::Internal::Util, :KerberosFlags
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # Implements the ASN.1TicketFlags type.
  # 
  # TicketFlags ::= BIT STRING
  # {
  # reserved(0),
  # forwardable(1),
  # forwarded(2),
  # proxiable(3),
  # proxy(4),
  # may-postdate(5),
  # postdated(6),
  # invalid(7),
  # renewable(8),
  # initial(9),
  # pre-authent(10),
  # hw-authent(11)
  # }
  class TicketFlags < TicketFlagsImports.const_get :KerberosFlags
    include_class_members TicketFlagsImports
    
    typesig { [] }
    def initialize
      super(Krb5::TKT_OPTS_MAX + 1)
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    def initialize(flags)
      super(flags)
      if (flags.attr_length > Krb5::TKT_OPTS_MAX + 1)
        raise Asn1Exception.new(Krb5::BITSTRING_BAD_LENGTH)
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(size, data)
      super(size, data)
      if ((size > data.attr_length * BITS_PER_UNIT) || (size > Krb5::TKT_OPTS_MAX + 1))
        raise Asn1Exception.new(Krb5::BITSTRING_BAD_LENGTH)
      end
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      initialize__ticket_flags(encoding.get_unaligned_bit_string(true).to_boolean_array)
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a ticket flag from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional
      # @return an instance of TicketFlags.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return TicketFlags.new(sub_der)
        end
      end
    }
    
    typesig { [] }
    def clone
      begin
        return TicketFlags.new(self.to_boolean_array)
      rescue Exception => e
        return nil
      end
    end
    
    typesig { [LoginOptions] }
    def match(options)
      matched = false
      # We currently only consider if forwardable renewable and proxiable are match
      if ((self.get(Krb5::TKT_OPTS_FORWARDABLE)).equal?((options.get(KDCOptions::FORWARDABLE))))
        if ((self.get(Krb5::TKT_OPTS_PROXIABLE)).equal?((options.get(KDCOptions::PROXIABLE))))
          if ((self.get(Krb5::TKT_OPTS_RENEWABLE)).equal?((options.get(KDCOptions::RENEWABLE))))
            matched = true
          end
        end
      end
      return matched
    end
    
    typesig { [TicketFlags] }
    def match(flags)
      matched = true
      i = 0
      while i <= Krb5::TKT_OPTS_MAX
        if (!(self.get(i)).equal?(flags.get(i)))
          return false
        end
        i += 1
      end
      return matched
    end
    
    typesig { [] }
    # Returns the string representative of ticket flags.
    def to_s
      sb = StringBuffer.new
      flags = to_boolean_array
      i = 0
      while i < flags.attr_length
        if ((flags[i]).equal?(true))
          case (i)
          when 0
            sb.append("RESERVED;")
          when 1
            sb.append("FORWARDABLE;")
          when 2
            sb.append("FORWARDED;")
          when 3
            sb.append("PROXIABLE;")
          when 4
            sb.append("PROXY;")
          when 5
            sb.append("MAY-POSTDATE;")
          when 6
            sb.append("POSTDATED;")
          when 7
            sb.append("INVALID;")
          when 8
            sb.append("RENEWABLE;")
          when 9
            sb.append("INITIAL;")
          when 10
            sb.append("PRE-AUTHENT;")
          when 11
            sb.append("HW-AUTHENT;")
          end
        end
        i += 1
      end
      result = sb.to_s
      if (result.length > 0)
        result = (result.substring(0, result.length - 1)).to_s
      end
      return result
    end
    
    private
    alias_method :initialize__ticket_flags, :initialize
  end
  
end
