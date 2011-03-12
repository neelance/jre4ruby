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
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio
  module ByteBufferAsCharBufferRBImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  class ByteBufferAsCharBufferRB < ByteBufferAsCharBufferRBImports.const_get :ByteBufferAsCharBufferB
    include_class_members ByteBufferAsCharBufferRBImports
    
    typesig { [ByteBuffer] }
    # package-private
    def initialize(bb)
      super(bb) # package-private
    end
    
    typesig { [ByteBuffer, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(bb, mark, pos, lim, cap, off)
      super(bb, mark, pos, lim, cap, off)
    end
    
    typesig { [] }
    def slice
      pos = self.position
      lim = self.limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      off = (pos << 1) + self.attr_offset
      raise AssertError if not ((off >= 0))
      return ByteBufferAsCharBufferRB.new(self.attr_bb, -1, 0, rem, rem, off)
    end
    
    typesig { [] }
    def duplicate
      return ByteBufferAsCharBufferRB.new(self.attr_bb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return duplicate
    end
    
    typesig { [::Java::Char] }
    def put(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    def put(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def compact
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def is_direct
      return self.attr_bb.is_direct
    end
    
    typesig { [] }
    def is_read_only
      return true
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def to_s(start, end_)
      if ((end_ > limit) || (start > end_))
        raise IndexOutOfBoundsException.new
      end
      begin
        len = end_ - start
        ca = CharArray.new(len)
        cb = CharBuffer.wrap(ca)
        db = self.duplicate
        db.position(start)
        db.limit(end_)
        cb.put(db)
        return String.new(ca)
      rescue StringIndexOutOfBoundsException => x
        raise IndexOutOfBoundsException.new
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # --- Methods to support CharSequence ---
    def sub_sequence(start, end_)
      pos = position
      lim = limit
      raise AssertError if not ((pos <= lim))
      pos = (pos <= lim ? pos : lim)
      len = lim - pos
      if ((start < 0) || (end_ > len) || (start > end_))
        raise IndexOutOfBoundsException.new
      end
      sublen = end_ - start
      off = self.attr_offset + ((pos + start) << 1)
      raise AssertError if not ((off >= 0))
      return ByteBufferAsCharBufferRB.new(self.attr_bb, -1, 0, sublen, sublen, off)
    end
    
    typesig { [] }
    def order
      return ByteOrder::BIG_ENDIAN
    end
    
    private
    alias_method :initialize__byte_buffer_as_char_buffer_rb, :initialize
  end
  
end
