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
module Sun::Security::Krb5::Internal::Util
  module KerberosFlagsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Security::Krb5::Internal, :Krb5
      include_const ::Sun::Security::Util, :BitArray
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # A wrapper class around sun.security.util.BitArray, so that KDCOptions,
  # TicketFlags and ApOptions in krb5 classes can utilize some functions
  # in BitArray classes.
  # 
  # The data type is defined in RFC 4120 as:
  # 
  # 5.2.8.  KerberosFlags
  # 
  # For several message types, a specific constrained bit string type,
  # KerberosFlags, is used.
  # 
  # KerberosFlags   ::= BIT STRING (SIZE (32..MAX))
  # -- minimum number of bits shall be sent,
  # -- but no fewer than 32
  # 
  # @author Yanni Zhang
  class KerberosFlags 
    include_class_members KerberosFlagsImports
    
    attr_accessor :bits
    alias_method :attr_bits, :bits
    undef_method :bits
    alias_method :attr_bits=, :bits=
    undef_method :bits=
    
    class_module.module_eval {
      # This constant is used by child classes.
      const_set_lazy(:BITS_PER_UNIT) { 8 }
      const_attr_reader  :BITS_PER_UNIT
    }
    
    typesig { [::Java::Int] }
    def initialize(length)
      @bits = nil
      @bits = BitArray.new(length)
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(length, a)
      @bits = nil
      @bits = BitArray.new(length, a)
      if (!(length).equal?(Krb5::KRB_FLAGS_MAX + 1))
        @bits = BitArray.new(Arrays.copy_of(@bits.to_boolean_array, Krb5::KRB_FLAGS_MAX + 1))
      end
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    def initialize(bools)
      @bits = nil
      @bits = BitArray.new(((bools.attr_length).equal?(Krb5::KRB_FLAGS_MAX + 1)) ? bools : Arrays.copy_of(bools, Krb5::KRB_FLAGS_MAX + 1))
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def set(index, value)
      @bits.set(index, value)
    end
    
    typesig { [::Java::Int] }
    def get(index)
      return @bits.get(index)
    end
    
    typesig { [] }
    def to_boolean_array
      return @bits.to_boolean_array
    end
    
    typesig { [] }
    # Writes the encoded data.
    # 
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @return an byte array of encoded KDCOptions.
    def asn1_encode
      out = DerOutputStream.new
      out.put_unaligned_bit_string(@bits)
      return out.to_byte_array
    end
    
    typesig { [] }
    def to_s
      return @bits.to_s
    end
    
    private
    alias_method :initialize__kerberos_flags, :initialize
  end
  
end
