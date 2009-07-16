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
  module HeapByteBufferRImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  # 
  # 
  # 
  # 
  # A read-only HeapByteBuffer.  This class extends the corresponding
  # read/write class, overriding the mutation methods to throw a {@link
  # ReadOnlyBufferException} and overriding the view-buffer methods to return an
  # instance of this class rather than of the superclass.
  class HeapByteBufferR < HeapByteBufferRImports.const_get :HeapByteBuffer
    include_class_members HeapByteBufferRImports
    
    typesig { [::Java::Int, ::Java::Int] }
    # For speed these fields are actually declared in X-Buffer;
    # these declarations are here as documentation
    def initialize(cap, lim)
      # package-private
      super(cap, lim)
      self.attr_is_read_only = true
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def initialize(buf, off, len)
      # package-private
      super(buf, off, len)
      self.attr_is_read_only = true
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(buf, mark, pos, lim, cap, off)
      super(buf, mark, pos, lim, cap, off)
      self.attr_is_read_only = true
    end
    
    typesig { [] }
    def slice
      return HeapByteBufferR.new(self.attr_hb, -1, 0, self.remaining, self.remaining, self.position + self.attr_offset)
    end
    
    typesig { [] }
    def duplicate
      return HeapByteBufferR.new(self.attr_hb, self.mark_value, self.position, self.limit, self.capacity, self.attr_offset)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return duplicate
    end
    
    typesig { [] }
    def is_read_only
      return true
    end
    
    typesig { [::Java::Byte] }
    def put(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def put(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def put(src, offset, length)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [ByteBuffer] }
    def put(src)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def compact
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int] }
    def __get(i)
      # package-private
      return self.attr_hb[i]
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def __put(i, b)
      # package-private
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Char] }
    # char
    def put_char(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    def put_char(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_char_buffer
      size = self.remaining >> 1
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsCharBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsCharBufferRL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [::Java::Short] }
    # short
    def put_short(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Short] }
    def put_short(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_short_buffer
      size = self.remaining >> 1
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsShortBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsShortBufferRL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [::Java::Int] }
    # int
    def put_int(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_int(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_int_buffer
      size = self.remaining >> 2
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsIntBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsIntBufferRL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [::Java::Long] }
    # long
    def put_long(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put_long(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_long_buffer
      size = self.remaining >> 3
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsLongBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsLongBufferRL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [::Java::Float] }
    # float
    def put_float(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    def put_float(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_float_buffer
      size = self.remaining >> 2
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsFloatBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsFloatBufferRL.new(self, -1, 0, size, size, off)))
    end
    
    typesig { [::Java::Double] }
    # double
    def put_double(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Double] }
    def put_double(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def as_double_buffer
      size = self.remaining >> 3
      off = self.attr_offset + position
      return (self.attr_big_endian ? (ByteBufferAsDoubleBufferRB.new(self, -1, 0, size, size, off)) : (ByteBufferAsDoubleBufferRL.new(self, -1, 0, size, size, off)))
    end
    
    private
    alias_method :initialize__heap_byte_buffer_r, :initialize
  end
  
end
