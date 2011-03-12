require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio
  module HeapByteBufferImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  # A read/write HeapByteBuffer.
  class HeapByteBuffer < HeapByteBufferImports.const_get :ByteBuffer
    include_class_members HeapByteBufferImports
    
    typesig { [::Java::Int, ::Java::Int] }
    # For speed these fields are actually declared in X-Buffer;
    # these declarations are here as documentation
    # protected final byte[] hb;
    # protected final int offset;
    def initialize(cap, lim)
      super(-1, 0, lim, cap, Array.typed(::Java::Byte).new(cap) { 0 }, 0) # package-private
      # hb = new byte[cap];
      # offset = 0;
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def initialize(buf, off, len)
      super(-1, off, off + len, buf.attr_length, buf, 0) # package-private
      # hb = buf;
      # offset = 0;
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(buf, mark, pos, lim, cap, off)
      super(mark, pos, lim, cap, buf, off)
      # hb = buf;
      # offset = off;
    end
    
    typesig { [] }
    def slice
      return HeapByteBuffer.new(self.attr_hb, -1, 0, self.remaining, self.remaining, self.position + self.attr_offset)
    end
    
    typesig { [] }
    def duplicate
      return HeapByteBuffer.new(self.attr_hb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return HeapByteBufferR.new(self.attr_hb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
    end
    
    typesig { [::Java::Int] }
    def ix(i)
      return i + self.attr_offset
    end
    
    typesig { [] }
    def get
      return self.attr_hb[ix(next_get_index)]
    end
    
    typesig { [::Java::Int] }
    def get(i)
      return self.attr_hb[ix(check_index(i))]
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def get(dst, offset, length)
      check_bounds(offset, length, dst.attr_length)
      if (length > remaining)
        raise BufferUnderflowException.new
      end
      System.arraycopy(self.attr_hb, ix(position), dst, offset, length)
      position(position + length)
      return self
    end
    
    typesig { [] }
    def is_direct
      return false
    end
    
    typesig { [] }
    def is_read_only
      return false
    end
    
    typesig { [::Java::Byte] }
    def put(x)
      self.attr_hb[ix(next_put_index)] = x
      return self
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def put(i, x)
      self.attr_hb[ix(check_index(i))] = x
      return self
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def put(src, offset, length)
      check_bounds(offset, length, src.attr_length)
      if (length > remaining)
        raise BufferOverflowException.new
      end
      System.arraycopy(src, offset, self.attr_hb, ix(position), length)
      position(position + length)
      return self
    end
    
    typesig { [ByteBuffer] }
    def put(src)
      if (src.is_a?(HeapByteBuffer))
        if ((src).equal?(self))
          raise IllegalArgumentException.new
        end
        sb = src
        n = sb.remaining
        if (n > remaining)
          raise BufferOverflowException.new
        end
        System.arraycopy(sb.attr_hb, sb.ix(sb.position), self.attr_hb, ix(position), n)
        sb.position(sb.position + n)
        position(position + n)
      else
        if (src.is_direct)
          n = src.remaining
          if (n > remaining)
            raise BufferOverflowException.new
          end
          src.get(self.attr_hb, ix(position), n)
          position(position + n)
        else
          super(src)
        end
      end
      return self
    end
    
    typesig { [] }
    def compact
      System.arraycopy(self.attr_hb, ix(position), self.attr_hb, ix(0), remaining)
      position(remaining)
      limit(capacity)
      discard_mark
      return self
    end
    
    typesig { [::Java::Int] }
    def __get(i)
      # package-private
      return self.attr_hb[i]
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def __put(i, b)
      # package-private
      self.attr_hb[i] = b
    end
    
    typesig { [] }
    # char
    def get_char
      return Bits.get_char(self, ix(next_get_index(2)), self.attr_big_endian)
    end
    
    typesig { [::Java::Int] }
    def get_char(i)
      return Bits.get_char(self, ix(check_index(i, 2)), self.attr_big_endian)
    end
    
    typesig { [::Java::Char] }
    def put_char(x)
      Bits.put_char(self, ix(next_put_index(2)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    def put_char(i, x)
      Bits.put_char(self, ix(check_index(i, 2)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [] }
    def as_char_buffer
      size = self.remaining >> 1
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsCharBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsCharBufferL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [] }
    # short
    def get_short
      return Bits.get_short(self, ix(next_get_index(2)), self.attr_big_endian)
    end
    
    typesig { [::Java::Int] }
    def get_short(i)
      return Bits.get_short(self, ix(check_index(i, 2)), self.attr_big_endian)
    end
    
    typesig { [::Java::Short] }
    def put_short(x)
      Bits.put_short(self, ix(next_put_index(2)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Short] }
    def put_short(i, x)
      Bits.put_short(self, ix(check_index(i, 2)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [] }
    def as_short_buffer
      size = self.remaining >> 1
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsShortBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsShortBufferL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [] }
    # int
    def get_int
      return Bits.get_int(self, ix(next_get_index(4)), self.attr_big_endian)
    end
    
    typesig { [::Java::Int] }
    def get_int(i)
      return Bits.get_int(self, ix(check_index(i, 4)), self.attr_big_endian)
    end
    
    typesig { [::Java::Int] }
    def put_int(x)
      Bits.put_int(self, ix(next_put_index(4)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_int(i, x)
      Bits.put_int(self, ix(check_index(i, 4)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [] }
    def as_int_buffer
      size = self.remaining >> 2
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsIntBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsIntBufferL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [] }
    # long
    def get_long
      return Bits.get_long(self, ix(next_get_index(8)), self.attr_big_endian)
    end
    
    typesig { [::Java::Int] }
    def get_long(i)
      return Bits.get_long(self, ix(check_index(i, 8)), self.attr_big_endian)
    end
    
    typesig { [::Java::Long] }
    def put_long(x)
      Bits.put_long(self, ix(next_put_index(8)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put_long(i, x)
      Bits.put_long(self, ix(check_index(i, 8)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [] }
    def as_long_buffer
      size = self.remaining >> 3
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsLongBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsLongBufferL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [] }
    # float
    def get_float
      return Bits.get_float(self, ix(next_get_index(4)), self.attr_big_endian)
    end
    
    typesig { [::Java::Int] }
    def get_float(i)
      return Bits.get_float(self, ix(check_index(i, 4)), self.attr_big_endian)
    end
    
    typesig { [::Java::Float] }
    def put_float(x)
      Bits.put_float(self, ix(next_put_index(4)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    def put_float(i, x)
      Bits.put_float(self, ix(check_index(i, 4)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [] }
    def as_float_buffer
      size = self.remaining >> 2
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsFloatBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsFloatBufferL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [] }
    # double
    def get_double
      return Bits.get_double(self, ix(next_get_index(8)), self.attr_big_endian)
    end
    
    typesig { [::Java::Int] }
    def get_double(i)
      return Bits.get_double(self, ix(check_index(i, 8)), self.attr_big_endian)
    end
    
    typesig { [::Java::Double] }
    def put_double(x)
      Bits.put_double(self, ix(next_put_index(8)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Double] }
    def put_double(i, x)
      Bits.put_double(self, ix(check_index(i, 8)), x, self.attr_big_endian)
      return self
    end
    
    typesig { [] }
    def as_double_buffer
      size = self.remaining >> 3
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsDoubleBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsDoubleBufferL.new(self, -1, 0, size, size, off)))
    end
    
    private
    alias_method :initialize__heap_byte_buffer, :initialize
  end
  
end
