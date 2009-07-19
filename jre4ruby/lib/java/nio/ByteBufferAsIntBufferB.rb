require "rjava"

# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  # package-private
  module ByteBufferAsIntBufferBImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  class ByteBufferAsIntBufferB < ByteBufferAsIntBufferBImports.const_get :IntBuffer
    include_class_members ByteBufferAsIntBufferBImports
    
    attr_accessor :bb
    alias_method :attr_bb, :bb
    undef_method :bb
    alias_method :attr_bb=, :bb=
    undef_method :bb=
    
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    typesig { [ByteBuffer] }
    def initialize(bb)
      # package-private
      @bb = nil
      @offset = 0
      super(-1, 0, bb.remaining >> 2, bb.remaining >> 2)
      @bb = bb
      # enforce limit == capacity
      cap = self.capacity
      self.limit(cap)
      pos = self.position
      raise AssertError if not ((pos <= cap))
      @offset = pos
    end
    
    typesig { [ByteBuffer, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(bb, mark, pos, lim, cap, off)
      @bb = nil
      @offset = 0
      super(mark, pos, lim, cap)
      @bb = bb
      @offset = off
    end
    
    typesig { [] }
    def slice
      pos = self.position
      lim = self.limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      off = (pos << 2) + @offset
      raise AssertError if not ((off >= 0))
      return ByteBufferAsIntBufferB.new(@bb, -1, 0, rem, rem, off)
    end
    
    typesig { [] }
    def duplicate
      return ByteBufferAsIntBufferB.new(@bb, self.mark_value, self.position, self.limit, self.capacity, @offset)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return ByteBufferAsIntBufferRB.new(@bb, self.mark_value, self.position, self.limit, self.capacity, @offset)
    end
    
    typesig { [::Java::Int] }
    def ix(i)
      return (i << 2) + @offset
    end
    
    typesig { [] }
    def get
      return Bits.get_int_b(@bb, ix(next_get_index))
    end
    
    typesig { [::Java::Int] }
    def get(i)
      return Bits.get_int_b(@bb, ix(check_index(i)))
    end
    
    typesig { [::Java::Int] }
    def put(x)
      Bits.put_int_b(@bb, ix(next_put_index), x)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put(i, x)
      Bits.put_int_b(@bb, ix(check_index(i)), x)
      return self
    end
    
    typesig { [] }
    def compact
      pos = position
      lim = limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      db = @bb.duplicate
      db.limit(ix(lim))
      db.position(ix(0))
      sb = db.slice
      sb.position(pos << 2)
      sb.compact
      position(rem)
      limit(capacity)
      discard_mark
      return self
    end
    
    typesig { [] }
    def is_direct
      return @bb.is_direct
    end
    
    typesig { [] }
    def is_read_only
      return false
    end
    
    typesig { [] }
    def order
      return ByteOrder::BIG_ENDIAN
    end
    
    private
    alias_method :initialize__byte_buffer_as_int_buffer_b, :initialize
  end
  
end
