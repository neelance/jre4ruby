require "rjava"

# 
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
  module ByteBufferAsLongBufferRBImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  class ByteBufferAsLongBufferRB < ByteBufferAsLongBufferRBImports.const_get :ByteBufferAsLongBufferB
    include_class_members ByteBufferAsLongBufferRBImports
    
    typesig { [ByteBuffer] }
    def initialize(bb)
      # package-private
      super(bb)
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
      off = (pos << 3) + self.attr_offset
      raise AssertError if not ((off >= 0))
      return ByteBufferAsLongBufferRB.new(self.attr_bb, -1, 0, rem, rem, off)
    end
    
    typesig { [] }
    def duplicate
      return ByteBufferAsLongBufferRB.new(self.attr_bb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return duplicate
    end
    
    typesig { [::Java::Long] }
    def put(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Long] }
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
    
    typesig { [] }
    def order
      return ByteOrder::BIG_ENDIAN
    end
    
    private
    alias_method :initialize__byte_buffer_as_long_buffer_rb, :initialize
  end
  
end
