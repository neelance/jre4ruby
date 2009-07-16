require "rjava"

# 
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
  module HeapLongBufferRImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  # 
  # 
  # 
  # 
  # A read-only HeapLongBuffer.  This class extends the corresponding
  # read/write class, overriding the mutation methods to throw a {@link
  # ReadOnlyBufferException} and overriding the view-buffer methods to return an
  # instance of this class rather than of the superclass.
  class HeapLongBufferR < HeapLongBufferRImports.const_get :HeapLongBuffer
    include_class_members HeapLongBufferRImports
    
    typesig { [::Java::Int, ::Java::Int] }
    # For speed these fields are actually declared in X-Buffer;
    # these declarations are here as documentation
    def initialize(cap, lim)
      # package-private
      super(cap, lim)
      self.attr_is_read_only = true
    end
    
    typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
    def initialize(buf, off, len)
      # package-private
      super(buf, off, len)
      self.attr_is_read_only = true
    end
    
    typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(buf, mark, pos, lim, cap, off)
      super(buf, mark, pos, lim, cap, off)
      self.attr_is_read_only = true
    end
    
    typesig { [] }
    def slice
      return HeapLongBufferR.new(self.attr_hb, -1, 0, self.remaining, self.remaining, self.position + self.attr_offset)
    end
    
    typesig { [] }
    def duplicate
      return HeapLongBufferR.new(self.attr_hb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return duplicate
    end
    
    typesig { [] }
    def is_read_only
      return true
    end
    
    typesig { [::Java::Long] }
    def put(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
    def put(src, offset, length)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [LongBuffer] }
    def put(src)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def compact
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def order
      return ByteOrder.native_order
    end
    
    private
    alias_method :initialize__heap_long_buffer_r, :initialize
  end
  
end
