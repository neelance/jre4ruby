require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module BitsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Utility methods for packing/unpacking primitive values in/out of byte arrays
  # using big-endian byte ordering.
  class Bits 
    include_class_members BitsImports
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # Methods for unpacking primitive values from byte arrays starting at
      # given offsets.
      def get_boolean(b, off)
        return !(b[off]).equal?(0)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_char(b, off)
        return RJava.cast_to_char((((b[off + 1] & 0xff) << 0) + ((b[off + 0]) << 8)))
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_short(b, off)
        return RJava.cast_to_short((((b[off + 1] & 0xff) << 0) + ((b[off + 0]) << 8)))
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_int(b, off)
        return ((b[off + 3] & 0xff) << 0) + ((b[off + 2] & 0xff) << 8) + ((b[off + 1] & 0xff) << 16) + ((b[off + 0]) << 24)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_float(b, off)
        i = ((b[off + 3] & 0xff) << 0) + ((b[off + 2] & 0xff) << 8) + ((b[off + 1] & 0xff) << 16) + ((b[off + 0]) << 24)
        return Float.int_bits_to_float(i)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_long(b, off)
        return ((b[off + 7] & 0xff) << 0) + ((b[off + 6] & 0xff) << 8) + ((b[off + 5] & 0xff) << 16) + ((b[off + 4] & 0xff) << 24) + ((b[off + 3] & 0xff) << 32) + ((b[off + 2] & 0xff) << 40) + ((b[off + 1] & 0xff) << 48) + ((b[off + 0]) << 56)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_double(b, off)
        j = ((b[off + 7] & 0xff) << 0) + ((b[off + 6] & 0xff) << 8) + ((b[off + 5] & 0xff) << 16) + ((b[off + 4] & 0xff) << 24) + ((b[off + 3] & 0xff) << 32) + ((b[off + 2] & 0xff) << 40) + ((b[off + 1] & 0xff) << 48) + ((b[off + 0]) << 56)
        return Double.long_bits_to_double(j)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Boolean] }
      # Methods for packing primitive values into byte arrays starting at given
      # offsets.
      def put_boolean(b, off, val)
        b[off] = (val ? 1 : 0)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Char] }
      def put_char(b, off, val)
        b[off + 1] = (val >> 0)
        b[off + 0] = (val >> 8)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Short] }
      def put_short(b, off, val)
        b[off + 1] = (val >> 0)
        b[off + 0] = (val >> 8)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def put_int(b, off, val)
        b[off + 3] = (val >> 0)
        b[off + 2] = (val >> 8)
        b[off + 1] = (val >> 16)
        b[off + 0] = (val >> 24)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Float] }
      def put_float(b, off, val)
        i = Float.float_to_int_bits(val)
        b[off + 3] = (i >> 0)
        b[off + 2] = (i >> 8)
        b[off + 1] = (i >> 16)
        b[off + 0] = (i >> 24)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Long] }
      def put_long(b, off, val)
        b[off + 7] = (val >> 0)
        b[off + 6] = (val >> 8)
        b[off + 5] = (val >> 16)
        b[off + 4] = (val >> 24)
        b[off + 3] = (val >> 32)
        b[off + 2] = (val >> 40)
        b[off + 1] = (val >> 48)
        b[off + 0] = (val >> 56)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Double] }
      def put_double(b, off, val)
        j = Double.double_to_long_bits(val)
        b[off + 7] = (j >> 0)
        b[off + 6] = (j >> 8)
        b[off + 5] = (j >> 16)
        b[off + 4] = (j >> 24)
        b[off + 3] = (j >> 32)
        b[off + 2] = (j >> 40)
        b[off + 1] = (j >> 48)
        b[off + 0] = (j >> 56)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__bits, :initialize
  end
  
end
