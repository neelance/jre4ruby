require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio
  module DirectByteBufferRImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
      include_const ::Sun::Misc, :Cleaner
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include_const ::Sun::Nio::Ch, :FileChannelImpl
    }
  end
  
  class DirectByteBufferR < DirectByteBufferRImports.const_get :DirectByteBuffer
    include_class_members DirectByteBufferRImports
    overload_protected {
      include DirectBuffer
    }
    
    typesig { [::Java::Int] }
    # Primary constructor
    def initialize(cap)
      # package-private
      super(cap)
    end
    
    typesig { [::Java::Int, ::Java::Long, Runnable] }
    # For memory-mapped buffers -- invoked by FileChannelImpl via reflection
    def initialize(cap, addr, unmapper)
      super(cap, addr, unmapper)
    end
    
    typesig { [DirectBuffer, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # For duplicates and slices
    # 
    # package-private
    def initialize(db, mark, pos, lim, cap, off)
      super(db, mark, pos, lim, cap, off)
    end
    
    typesig { [] }
    def slice
      pos = self.position
      lim = self.limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      off = (pos << 0)
      raise AssertError if not ((off >= 0))
      return DirectByteBufferR.new(self, -1, 0, rem, rem, off)
    end
    
    typesig { [] }
    def duplicate
      return DirectByteBufferR.new(self, self.mark_value, self.position, self.limit, self.capacity, 0)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return duplicate
    end
    
    typesig { [::Java::Byte] }
    def put(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def put(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [ByteBuffer] }
    def put(src)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def put(src, offset, length)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def compact
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def is_direct
      return true
    end
    
    typesig { [] }
    def is_read_only
      return true
    end
    
    typesig { [::Java::Int] }
    def __get(i)
      # package-private
      return self.attr_unsafe.get_byte(self.attr_address + i)
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def __put(i, b)
      # package-private
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Long, ::Java::Char] }
    def put_char(a, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Char] }
    def put_char(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    def put_char(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_char_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 1
      if (!self.attr_unaligned && (!((self.attr_address + off) % (1 << 1)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsCharBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsCharBufferRL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectCharBufferRU.new(self, -1, 0, size, size, off)) : (DirectCharBufferRS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long, ::Java::Short] }
    def put_short(a, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Short] }
    def put_short(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Short] }
    def put_short(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_short_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 1
      if (!self.attr_unaligned && (!((self.attr_address + off) % (1 << 1)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsShortBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsShortBufferRL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectShortBufferRU.new(self, -1, 0, size, size, off)) : (DirectShortBufferRS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long, ::Java::Int] }
    def put_int(a, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int] }
    def put_int(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_int(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_int_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 2
      if (!self.attr_unaligned && (!((self.attr_address + off) % (1 << 2)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsIntBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsIntBufferRL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectIntBufferRU.new(self, -1, 0, size, size, off)) : (DirectIntBufferRS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    def put_long(a, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Long] }
    def put_long(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put_long(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_long_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 3
      if (!self.attr_unaligned && (!((self.attr_address + off) % (1 << 3)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsLongBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsLongBufferRL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectLongBufferRU.new(self, -1, 0, size, size, off)) : (DirectLongBufferRS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long, ::Java::Float] }
    def put_float(a, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Float] }
    def put_float(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    def put_float(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_float_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 2
      if (!self.attr_unaligned && (!((self.attr_address + off) % (1 << 2)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsFloatBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsFloatBufferRL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectFloatBufferRU.new(self, -1, 0, size, size, off)) : (DirectFloatBufferRS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long, ::Java::Double] }
    def put_double(a, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Double] }
    def put_double(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Double] }
    def put_double(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_double_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 3
      if (!self.attr_unaligned && (!((self.attr_address + off) % (1 << 3)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsDoubleBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsDoubleBufferRL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectDoubleBufferRU.new(self, -1, 0, size, size, off)) : (DirectDoubleBufferRS.new(self, -1, 0, size, size, off)))
      end
    end
    
    private
    alias_method :initialize__direct_byte_buffer_r, :initialize
  end
  
end
