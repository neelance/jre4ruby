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
# 
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio
  module HeapLongBufferImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  # A read/write HeapLongBuffer.
  class HeapLongBuffer < HeapLongBufferImports.const_get :LongBuffer
    include_class_members HeapLongBufferImports
    
    typesig { [::Java::Int, ::Java::Int] }
    # For speed these fields are actually declared in X-Buffer;
    # these declarations are here as documentation
    # 
    # 
    # protected final long[] hb;
    # protected final int offset;
    def initialize(cap, lim)
      # package-private
      super(-1, 0, lim, cap, Array.typed(::Java::Long).new(cap) { 0 }, 0)
      # hb = new long[cap];
      # offset = 0;
    end
    
    typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
    def initialize(buf, off, len)
      # package-private
      super(-1, off, off + len, buf.attr_length, buf, 0)
      # hb = buf;
      # offset = 0;
    end
    
    typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(buf, mark, pos, lim, cap, off)
      super(mark, pos, lim, cap, buf, off)
      # hb = buf;
      # offset = off;
    end
    
    typesig { [] }
    def slice
      return HeapLongBuffer.new(self.attr_hb, -1, 0, self.remaining, self.remaining, self.position + self.attr_offset)
    end
    
    typesig { [] }
    def duplicate
      return HeapLongBuffer.new(self.attr_hb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return HeapLongBufferR.new(self.attr_hb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
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
    
    typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
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
    
    typesig { [::Java::Long] }
    def put(x)
      self.attr_hb[ix(next_put_index)] = x
      return self
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put(i, x)
      self.attr_hb[ix(check_index(i))] = x
      return self
    end
    
    typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
    def put(src, offset, length)
      check_bounds(offset, length, src.attr_length)
      if (length > remaining)
        raise BufferOverflowException.new
      end
      System.arraycopy(src, offset, self.attr_hb, ix(position), length)
      position(position + length)
      return self
    end
    
    typesig { [LongBuffer] }
    def put(src)
      if (src.is_a?(HeapLongBuffer))
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
    
    typesig { [] }
    def order
      return ByteOrder.native_order
    end
    
    private
    alias_method :initialize__heap_long_buffer, :initialize
  end
  
end
