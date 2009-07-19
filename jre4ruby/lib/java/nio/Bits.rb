require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio
  module BitsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Misc, :VM
    }
  end
  
  # Access to bits, native and otherwise.
  class Bits 
    include_class_members BitsImports
    
    typesig { [] }
    # package-private
    def initialize
    end
    
    class_module.module_eval {
      typesig { [::Java::Short] }
      # -- Swapping --
      def swap(x)
        return RJava.cast_to_short(((x << 8) | (RJava.cast_to_char(x) >> 8)))
      end
      
      typesig { [::Java::Char] }
      def swap(x)
        return RJava.cast_to_char(((x << 8) | (x >> 8)))
      end
      
      typesig { [::Java::Int] }
      def swap(x)
        return ((x << 24) | ((x & 0xff00) << 8) | ((x & 0xff0000) >> 8) | (x >> 24))
      end
      
      typesig { [::Java::Long] }
      def swap(x)
        return ((swap(RJava.cast_to_int(x)) << 32) | (swap(RJava.cast_to_int((x >> 32))) & 0xffffffff))
      end
      
      typesig { [::Java::Byte, ::Java::Byte] }
      # -- get/put char --
      def make_char(b1, b0)
        return RJava.cast_to_char(((b1 << 8) | (b0 & 0xff)))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_char_l(bb, bi)
        return make_char(bb.__get(bi + 1), bb.__get(bi + 0))
      end
      
      typesig { [::Java::Long] }
      def get_char_l(a)
        return make_char(__get(a + 1), __get(a + 0))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_char_b(bb, bi)
        return make_char(bb.__get(bi + 0), bb.__get(bi + 1))
      end
      
      typesig { [::Java::Long] }
      def get_char_b(a)
        return make_char(__get(a + 0), __get(a + 1))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Boolean] }
      def get_char(bb, bi, big_endian)
        return (big_endian ? get_char_b(bb, bi) : get_char_l(bb, bi))
      end
      
      typesig { [::Java::Long, ::Java::Boolean] }
      def get_char(a, big_endian)
        return (big_endian ? get_char_b(a) : get_char_l(a))
      end
      
      typesig { [::Java::Char] }
      def char1(x)
        return (x >> 8)
      end
      
      typesig { [::Java::Char] }
      def char0(x)
        return (x >> 0)
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Char] }
      def put_char_l(bb, bi, x)
        bb.__put(bi + 0, char0(x))
        bb.__put(bi + 1, char1(x))
      end
      
      typesig { [::Java::Long, ::Java::Char] }
      def put_char_l(a, x)
        __put(a + 0, char0(x))
        __put(a + 1, char1(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Char] }
      def put_char_b(bb, bi, x)
        bb.__put(bi + 0, char1(x))
        bb.__put(bi + 1, char0(x))
      end
      
      typesig { [::Java::Long, ::Java::Char] }
      def put_char_b(a, x)
        __put(a + 0, char1(x))
        __put(a + 1, char0(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Char, ::Java::Boolean] }
      def put_char(bb, bi, x, big_endian)
        if (big_endian)
          put_char_b(bb, bi, x)
        else
          put_char_l(bb, bi, x)
        end
      end
      
      typesig { [::Java::Long, ::Java::Char, ::Java::Boolean] }
      def put_char(a, x, big_endian)
        if (big_endian)
          put_char_b(a, x)
        else
          put_char_l(a, x)
        end
      end
      
      typesig { [::Java::Byte, ::Java::Byte] }
      # -- get/put short --
      def make_short(b1, b0)
        return RJava.cast_to_short(((b1 << 8) | (b0 & 0xff)))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_short_l(bb, bi)
        return make_short(bb.__get(bi + 1), bb.__get(bi + 0))
      end
      
      typesig { [::Java::Long] }
      def get_short_l(a)
        return make_short(__get(a + 1), __get(a))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_short_b(bb, bi)
        return make_short(bb.__get(bi + 0), bb.__get(bi + 1))
      end
      
      typesig { [::Java::Long] }
      def get_short_b(a)
        return make_short(__get(a), __get(a + 1))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Boolean] }
      def get_short(bb, bi, big_endian)
        return (big_endian ? get_short_b(bb, bi) : get_short_l(bb, bi))
      end
      
      typesig { [::Java::Long, ::Java::Boolean] }
      def get_short(a, big_endian)
        return (big_endian ? get_short_b(a) : get_short_l(a))
      end
      
      typesig { [::Java::Short] }
      def short1(x)
        return (x >> 8)
      end
      
      typesig { [::Java::Short] }
      def short0(x)
        return (x >> 0)
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Short] }
      def put_short_l(bb, bi, x)
        bb.__put(bi + 0, short0(x))
        bb.__put(bi + 1, short1(x))
      end
      
      typesig { [::Java::Long, ::Java::Short] }
      def put_short_l(a, x)
        __put(a, short0(x))
        __put(a + 1, short1(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Short] }
      def put_short_b(bb, bi, x)
        bb.__put(bi + 0, short1(x))
        bb.__put(bi + 1, short0(x))
      end
      
      typesig { [::Java::Long, ::Java::Short] }
      def put_short_b(a, x)
        __put(a, short1(x))
        __put(a + 1, short0(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Short, ::Java::Boolean] }
      def put_short(bb, bi, x, big_endian)
        if (big_endian)
          put_short_b(bb, bi, x)
        else
          put_short_l(bb, bi, x)
        end
      end
      
      typesig { [::Java::Long, ::Java::Short, ::Java::Boolean] }
      def put_short(a, x, big_endian)
        if (big_endian)
          put_short_b(a, x)
        else
          put_short_l(a, x)
        end
      end
      
      typesig { [::Java::Byte, ::Java::Byte, ::Java::Byte, ::Java::Byte] }
      # -- get/put int --
      def make_int(b3, b2, b1, b0)
        return (((b3 & 0xff) << 24) | ((b2 & 0xff) << 16) | ((b1 & 0xff) << 8) | ((b0 & 0xff) << 0))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_int_l(bb, bi)
        return make_int(bb.__get(bi + 3), bb.__get(bi + 2), bb.__get(bi + 1), bb.__get(bi + 0))
      end
      
      typesig { [::Java::Long] }
      def get_int_l(a)
        return make_int(__get(a + 3), __get(a + 2), __get(a + 1), __get(a + 0))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_int_b(bb, bi)
        return make_int(bb.__get(bi + 0), bb.__get(bi + 1), bb.__get(bi + 2), bb.__get(bi + 3))
      end
      
      typesig { [::Java::Long] }
      def get_int_b(a)
        return make_int(__get(a + 0), __get(a + 1), __get(a + 2), __get(a + 3))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Boolean] }
      def get_int(bb, bi, big_endian)
        return (big_endian ? get_int_b(bb, bi) : get_int_l(bb, bi))
      end
      
      typesig { [::Java::Long, ::Java::Boolean] }
      def get_int(a, big_endian)
        return (big_endian ? get_int_b(a) : get_int_l(a))
      end
      
      typesig { [::Java::Int] }
      def int3(x)
        return (x >> 24)
      end
      
      typesig { [::Java::Int] }
      def int2(x)
        return (x >> 16)
      end
      
      typesig { [::Java::Int] }
      def int1(x)
        return (x >> 8)
      end
      
      typesig { [::Java::Int] }
      def int0(x)
        return (x >> 0)
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Int] }
      def put_int_l(bb, bi, x)
        bb.__put(bi + 3, int3(x))
        bb.__put(bi + 2, int2(x))
        bb.__put(bi + 1, int1(x))
        bb.__put(bi + 0, int0(x))
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      def put_int_l(a, x)
        __put(a + 3, int3(x))
        __put(a + 2, int2(x))
        __put(a + 1, int1(x))
        __put(a + 0, int0(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Int] }
      def put_int_b(bb, bi, x)
        bb.__put(bi + 0, int3(x))
        bb.__put(bi + 1, int2(x))
        bb.__put(bi + 2, int1(x))
        bb.__put(bi + 3, int0(x))
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      def put_int_b(a, x)
        __put(a + 0, int3(x))
        __put(a + 1, int2(x))
        __put(a + 2, int1(x))
        __put(a + 3, int0(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Int, ::Java::Boolean] }
      def put_int(bb, bi, x, big_endian)
        if (big_endian)
          put_int_b(bb, bi, x)
        else
          put_int_l(bb, bi, x)
        end
      end
      
      typesig { [::Java::Long, ::Java::Int, ::Java::Boolean] }
      def put_int(a, x, big_endian)
        if (big_endian)
          put_int_b(a, x)
        else
          put_int_l(a, x)
        end
      end
      
      typesig { [::Java::Byte, ::Java::Byte, ::Java::Byte, ::Java::Byte, ::Java::Byte, ::Java::Byte, ::Java::Byte, ::Java::Byte] }
      # -- get/put long --
      def make_long(b7, b6, b5, b4, b3, b2, b1, b0)
        return (((b7 & 0xff) << 56) | ((b6 & 0xff) << 48) | ((b5 & 0xff) << 40) | ((b4 & 0xff) << 32) | ((b3 & 0xff) << 24) | ((b2 & 0xff) << 16) | ((b1 & 0xff) << 8) | ((b0 & 0xff) << 0))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_long_l(bb, bi)
        return make_long(bb.__get(bi + 7), bb.__get(bi + 6), bb.__get(bi + 5), bb.__get(bi + 4), bb.__get(bi + 3), bb.__get(bi + 2), bb.__get(bi + 1), bb.__get(bi + 0))
      end
      
      typesig { [::Java::Long] }
      def get_long_l(a)
        return make_long(__get(a + 7), __get(a + 6), __get(a + 5), __get(a + 4), __get(a + 3), __get(a + 2), __get(a + 1), __get(a + 0))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_long_b(bb, bi)
        return make_long(bb.__get(bi + 0), bb.__get(bi + 1), bb.__get(bi + 2), bb.__get(bi + 3), bb.__get(bi + 4), bb.__get(bi + 5), bb.__get(bi + 6), bb.__get(bi + 7))
      end
      
      typesig { [::Java::Long] }
      def get_long_b(a)
        return make_long(__get(a + 0), __get(a + 1), __get(a + 2), __get(a + 3), __get(a + 4), __get(a + 5), __get(a + 6), __get(a + 7))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Boolean] }
      def get_long(bb, bi, big_endian)
        return (big_endian ? get_long_b(bb, bi) : get_long_l(bb, bi))
      end
      
      typesig { [::Java::Long, ::Java::Boolean] }
      def get_long(a, big_endian)
        return (big_endian ? get_long_b(a) : get_long_l(a))
      end
      
      typesig { [::Java::Long] }
      def long7(x)
        return (x >> 56)
      end
      
      typesig { [::Java::Long] }
      def long6(x)
        return (x >> 48)
      end
      
      typesig { [::Java::Long] }
      def long5(x)
        return (x >> 40)
      end
      
      typesig { [::Java::Long] }
      def long4(x)
        return (x >> 32)
      end
      
      typesig { [::Java::Long] }
      def long3(x)
        return (x >> 24)
      end
      
      typesig { [::Java::Long] }
      def long2(x)
        return (x >> 16)
      end
      
      typesig { [::Java::Long] }
      def long1(x)
        return (x >> 8)
      end
      
      typesig { [::Java::Long] }
      def long0(x)
        return (x >> 0)
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Long] }
      def put_long_l(bb, bi, x)
        bb.__put(bi + 7, long7(x))
        bb.__put(bi + 6, long6(x))
        bb.__put(bi + 5, long5(x))
        bb.__put(bi + 4, long4(x))
        bb.__put(bi + 3, long3(x))
        bb.__put(bi + 2, long2(x))
        bb.__put(bi + 1, long1(x))
        bb.__put(bi + 0, long0(x))
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      def put_long_l(a, x)
        __put(a + 7, long7(x))
        __put(a + 6, long6(x))
        __put(a + 5, long5(x))
        __put(a + 4, long4(x))
        __put(a + 3, long3(x))
        __put(a + 2, long2(x))
        __put(a + 1, long1(x))
        __put(a + 0, long0(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Long] }
      def put_long_b(bb, bi, x)
        bb.__put(bi + 0, long7(x))
        bb.__put(bi + 1, long6(x))
        bb.__put(bi + 2, long5(x))
        bb.__put(bi + 3, long4(x))
        bb.__put(bi + 4, long3(x))
        bb.__put(bi + 5, long2(x))
        bb.__put(bi + 6, long1(x))
        bb.__put(bi + 7, long0(x))
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      def put_long_b(a, x)
        __put(a + 0, long7(x))
        __put(a + 1, long6(x))
        __put(a + 2, long5(x))
        __put(a + 3, long4(x))
        __put(a + 4, long3(x))
        __put(a + 5, long2(x))
        __put(a + 6, long1(x))
        __put(a + 7, long0(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Long, ::Java::Boolean] }
      def put_long(bb, bi, x, big_endian)
        if (big_endian)
          put_long_b(bb, bi, x)
        else
          put_long_l(bb, bi, x)
        end
      end
      
      typesig { [::Java::Long, ::Java::Long, ::Java::Boolean] }
      def put_long(a, x, big_endian)
        if (big_endian)
          put_long_b(a, x)
        else
          put_long_l(a, x)
        end
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      # -- get/put float --
      def get_float_l(bb, bi)
        return Float.int_bits_to_float(get_int_l(bb, bi))
      end
      
      typesig { [::Java::Long] }
      def get_float_l(a)
        return Float.int_bits_to_float(get_int_l(a))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_float_b(bb, bi)
        return Float.int_bits_to_float(get_int_b(bb, bi))
      end
      
      typesig { [::Java::Long] }
      def get_float_b(a)
        return Float.int_bits_to_float(get_int_b(a))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Boolean] }
      def get_float(bb, bi, big_endian)
        return (big_endian ? get_float_b(bb, bi) : get_float_l(bb, bi))
      end
      
      typesig { [::Java::Long, ::Java::Boolean] }
      def get_float(a, big_endian)
        return (big_endian ? get_float_b(a) : get_float_l(a))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Float] }
      def put_float_l(bb, bi, x)
        put_int_l(bb, bi, Float.float_to_raw_int_bits(x))
      end
      
      typesig { [::Java::Long, ::Java::Float] }
      def put_float_l(a, x)
        put_int_l(a, Float.float_to_raw_int_bits(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Float] }
      def put_float_b(bb, bi, x)
        put_int_b(bb, bi, Float.float_to_raw_int_bits(x))
      end
      
      typesig { [::Java::Long, ::Java::Float] }
      def put_float_b(a, x)
        put_int_b(a, Float.float_to_raw_int_bits(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Float, ::Java::Boolean] }
      def put_float(bb, bi, x, big_endian)
        if (big_endian)
          put_float_b(bb, bi, x)
        else
          put_float_l(bb, bi, x)
        end
      end
      
      typesig { [::Java::Long, ::Java::Float, ::Java::Boolean] }
      def put_float(a, x, big_endian)
        if (big_endian)
          put_float_b(a, x)
        else
          put_float_l(a, x)
        end
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      # -- get/put double --
      def get_double_l(bb, bi)
        return Double.long_bits_to_double(get_long_l(bb, bi))
      end
      
      typesig { [::Java::Long] }
      def get_double_l(a)
        return Double.long_bits_to_double(get_long_l(a))
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      def get_double_b(bb, bi)
        return Double.long_bits_to_double(get_long_b(bb, bi))
      end
      
      typesig { [::Java::Long] }
      def get_double_b(a)
        return Double.long_bits_to_double(get_long_b(a))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Boolean] }
      def get_double(bb, bi, big_endian)
        return (big_endian ? get_double_b(bb, bi) : get_double_l(bb, bi))
      end
      
      typesig { [::Java::Long, ::Java::Boolean] }
      def get_double(a, big_endian)
        return (big_endian ? get_double_b(a) : get_double_l(a))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Double] }
      def put_double_l(bb, bi, x)
        put_long_l(bb, bi, Double.double_to_raw_long_bits(x))
      end
      
      typesig { [::Java::Long, ::Java::Double] }
      def put_double_l(a, x)
        put_long_l(a, Double.double_to_raw_long_bits(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Double] }
      def put_double_b(bb, bi, x)
        put_long_b(bb, bi, Double.double_to_raw_long_bits(x))
      end
      
      typesig { [::Java::Long, ::Java::Double] }
      def put_double_b(a, x)
        put_long_b(a, Double.double_to_raw_long_bits(x))
      end
      
      typesig { [ByteBuffer, ::Java::Int, ::Java::Double, ::Java::Boolean] }
      def put_double(bb, bi, x, big_endian)
        if (big_endian)
          put_double_b(bb, bi, x)
        else
          put_double_l(bb, bi, x)
        end
      end
      
      typesig { [::Java::Long, ::Java::Double, ::Java::Boolean] }
      def put_double(a, x, big_endian)
        if (big_endian)
          put_double_b(a, x)
        else
          put_double_l(a, x)
        end
      end
      
      # -- Unsafe access --
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      typesig { [::Java::Long] }
      def __get(a)
        return UnsafeInstance.get_byte(a)
      end
      
      typesig { [::Java::Long, ::Java::Byte] }
      def __put(a, b)
        UnsafeInstance.put_byte(a, b)
      end
      
      typesig { [] }
      def unsafe
        return UnsafeInstance
      end
      
      typesig { [] }
      def byte_order
        if ((ByteOrder).nil?)
          raise JavaError.new("Unknown byte order")
        end
        return ByteOrder
      end
      
      when_class_loaded do
        a = UnsafeInstance.allocate_memory(8)
        begin
          UnsafeInstance.put_long(a, 0x102030405060708)
          b = UnsafeInstance.get_byte(a)
          case (b)
          when 0x1
            const_set :ByteOrder, ByteOrder::BIG_ENDIAN
          when 0x8
            const_set :ByteOrder, ByteOrder::LITTLE_ENDIAN
          else
            raise AssertError if not (false)
            const_set :ByteOrder, nil
          end
        ensure
          UnsafeInstance.free_memory(a)
        end
      end
      
      
      def page_size
        defined?(@@page_size) ? @@page_size : @@page_size= -1
      end
      alias_method :attr_page_size, :page_size
      
      def page_size=(value)
        @@page_size = value
      end
      alias_method :attr_page_size=, :page_size=
      
      typesig { [] }
      def page_size
        if ((self.attr_page_size).equal?(-1))
          self.attr_page_size = unsafe.page_size
        end
        return self.attr_page_size
      end
      
      
      def unaligned
        defined?(@@unaligned) ? @@unaligned : @@unaligned= false
      end
      alias_method :attr_unaligned, :unaligned
      
      def unaligned=(value)
        @@unaligned = value
      end
      alias_method :attr_unaligned=, :unaligned=
      
      
      def unaligned_known
        defined?(@@unaligned_known) ? @@unaligned_known : @@unaligned_known= false
      end
      alias_method :attr_unaligned_known, :unaligned_known
      
      def unaligned_known=(value)
        @@unaligned_known = value
      end
      alias_method :attr_unaligned_known=, :unaligned_known=
      
      typesig { [] }
      def unaligned
        if (self.attr_unaligned_known)
          return self.attr_unaligned
        end
        arch = AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("os.arch"))
        self.attr_unaligned = (arch == "i386") || (arch == "x86") || (arch == "amd64")
        self.attr_unaligned_known = true
        return self.attr_unaligned
      end
      
      # -- Direct memory management --
      # A user-settable upper limit on the maximum amount of allocatable
      # direct buffer memory.  This value may be changed during VM
      # initialization if it is launched with "-XX:MaxDirectMemorySize=<size>".
      
      def max_memory
        defined?(@@max_memory) ? @@max_memory : @@max_memory= VM.max_direct_memory
      end
      alias_method :attr_max_memory, :max_memory
      
      def max_memory=(value)
        @@max_memory = value
      end
      alias_method :attr_max_memory=, :max_memory=
      
      
      def reserved_memory
        defined?(@@reserved_memory) ? @@reserved_memory : @@reserved_memory= 0
      end
      alias_method :attr_reserved_memory, :reserved_memory
      
      def reserved_memory=(value)
        @@reserved_memory = value
      end
      alias_method :attr_reserved_memory=, :reserved_memory=
      
      
      def memory_limit_set
        defined?(@@memory_limit_set) ? @@memory_limit_set : @@memory_limit_set= false
      end
      alias_method :attr_memory_limit_set, :memory_limit_set
      
      def memory_limit_set=(value)
        @@memory_limit_set = value
      end
      alias_method :attr_memory_limit_set=, :memory_limit_set=
      
      typesig { [::Java::Long] }
      # These methods should be called whenever direct memory is allocated or
      # freed.  They allow the user to control the amount of direct memory
      # which a process may access.  All sizes are specified in bytes.
      def reserve_memory(size)
        synchronized((Bits.class)) do
          if (!self.attr_memory_limit_set && VM.is_booted)
            self.attr_max_memory = VM.max_direct_memory
            self.attr_memory_limit_set = true
          end
          if (size <= self.attr_max_memory - self.attr_reserved_memory)
            self.attr_reserved_memory += size
            return
          end
        end
        System.gc
        begin
          JavaThread.sleep(100)
        rescue InterruptedException => x
          # Restore interrupt status
          JavaThread.current_thread.interrupt
        end
        synchronized((Bits.class)) do
          if (self.attr_reserved_memory + size > self.attr_max_memory)
            raise OutOfMemoryError.new("Direct buffer memory")
          end
          self.attr_reserved_memory += size
        end
      end
      
      typesig { [::Java::Long] }
      def unreserve_memory(size)
        synchronized(self) do
          if (self.attr_reserved_memory > 0)
            self.attr_reserved_memory -= size
            raise AssertError if not ((self.attr_reserved_memory > -1))
          end
        end
      end
      
      # -- Bulk get/put acceleration --
      # These numbers represent the point at which we have empirically
      # determined that the average cost of a JNI call exceeds the expense
      # of an element by element copy.  These numbers may change over time.
      const_set_lazy(:JNI_COPY_TO_ARRAY_THRESHOLD) { 6 }
      const_attr_reader  :JNI_COPY_TO_ARRAY_THRESHOLD
      
      const_set_lazy(:JNI_COPY_FROM_ARRAY_THRESHOLD) { 6 }
      const_attr_reader  :JNI_COPY_FROM_ARRAY_THRESHOLD
      
      JNI.native_method :Java_java_nio_Bits_copyFromByteArray, [:pointer, :long, :long, :int64, :int64, :int64], :void
      typesig { [Object, ::Java::Long, ::Java::Long, ::Java::Long] }
      # These methods do no bounds checking.  Verification that the copy will not
      # result in memory corruption should be done prior to invocation.
      # All positions and lengths are specified in bytes.
      def copy_from_byte_array(src, src_pos, dst_addr, length)
        JNI.__send__(:Java_java_nio_Bits_copyFromByteArray, JNI.env, self.jni_id, src.jni_id, src_pos.to_int, dst_addr.to_int, length.to_int)
      end
      
      JNI.native_method :Java_java_nio_Bits_copyToByteArray, [:pointer, :long, :int64, :long, :int64, :int64], :void
      typesig { [::Java::Long, Object, ::Java::Long, ::Java::Long] }
      def copy_to_byte_array(src_addr, dst, dst_pos, length)
        JNI.__send__(:Java_java_nio_Bits_copyToByteArray, JNI.env, self.jni_id, src_addr.to_int, dst.jni_id, dst_pos.to_int, length.to_int)
      end
      
      typesig { [Object, ::Java::Long, ::Java::Long, ::Java::Long] }
      def copy_from_char_array(src, src_pos, dst_addr, length)
        copy_from_short_array(src, src_pos, dst_addr, length)
      end
      
      typesig { [::Java::Long, Object, ::Java::Long, ::Java::Long] }
      def copy_to_char_array(src_addr, dst, dst_pos, length)
        copy_to_short_array(src_addr, dst, dst_pos, length)
      end
      
      JNI.native_method :Java_java_nio_Bits_copyFromShortArray, [:pointer, :long, :long, :int64, :int64, :int64], :void
      typesig { [Object, ::Java::Long, ::Java::Long, ::Java::Long] }
      def copy_from_short_array(src, src_pos, dst_addr, length)
        JNI.__send__(:Java_java_nio_Bits_copyFromShortArray, JNI.env, self.jni_id, src.jni_id, src_pos.to_int, dst_addr.to_int, length.to_int)
      end
      
      JNI.native_method :Java_java_nio_Bits_copyToShortArray, [:pointer, :long, :int64, :long, :int64, :int64], :void
      typesig { [::Java::Long, Object, ::Java::Long, ::Java::Long] }
      def copy_to_short_array(src_addr, dst, dst_pos, length)
        JNI.__send__(:Java_java_nio_Bits_copyToShortArray, JNI.env, self.jni_id, src_addr.to_int, dst.jni_id, dst_pos.to_int, length.to_int)
      end
      
      JNI.native_method :Java_java_nio_Bits_copyFromIntArray, [:pointer, :long, :long, :int64, :int64, :int64], :void
      typesig { [Object, ::Java::Long, ::Java::Long, ::Java::Long] }
      def copy_from_int_array(src, src_pos, dst_addr, length)
        JNI.__send__(:Java_java_nio_Bits_copyFromIntArray, JNI.env, self.jni_id, src.jni_id, src_pos.to_int, dst_addr.to_int, length.to_int)
      end
      
      JNI.native_method :Java_java_nio_Bits_copyToIntArray, [:pointer, :long, :int64, :long, :int64, :int64], :void
      typesig { [::Java::Long, Object, ::Java::Long, ::Java::Long] }
      def copy_to_int_array(src_addr, dst, dst_pos, length)
        JNI.__send__(:Java_java_nio_Bits_copyToIntArray, JNI.env, self.jni_id, src_addr.to_int, dst.jni_id, dst_pos.to_int, length.to_int)
      end
      
      JNI.native_method :Java_java_nio_Bits_copyFromLongArray, [:pointer, :long, :long, :int64, :int64, :int64], :void
      typesig { [Object, ::Java::Long, ::Java::Long, ::Java::Long] }
      def copy_from_long_array(src, src_pos, dst_addr, length)
        JNI.__send__(:Java_java_nio_Bits_copyFromLongArray, JNI.env, self.jni_id, src.jni_id, src_pos.to_int, dst_addr.to_int, length.to_int)
      end
      
      JNI.native_method :Java_java_nio_Bits_copyToLongArray, [:pointer, :long, :int64, :long, :int64, :int64], :void
      typesig { [::Java::Long, Object, ::Java::Long, ::Java::Long] }
      def copy_to_long_array(src_addr, dst, dst_pos, length)
        JNI.__send__(:Java_java_nio_Bits_copyToLongArray, JNI.env, self.jni_id, src_addr.to_int, dst.jni_id, dst_pos.to_int, length.to_int)
      end
    }
    
    private
    alias_method :initialize__bits, :initialize
  end
  
end
