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
  module DirectFloatBufferRSImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
      include_const ::Sun::Misc, :Cleaner
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include_const ::Sun::Nio::Ch, :FileChannelImpl
    }
  end
  
  class DirectFloatBufferRS < DirectFloatBufferRSImports.const_get :DirectFloatBufferS
    include_class_members DirectFloatBufferRSImports
    overload_protected {
      include DirectBuffer
    }
    
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
      off = (pos << 2)
      raise AssertError if not ((off >= 0))
      return DirectFloatBufferRS.new(self, -1, 0, rem, rem, off)
    end
    
    typesig { [] }
    def duplicate
      return DirectFloatBufferRS.new(self, self.mark_value, self.position, self.limit, self.capacity, 0)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return duplicate
    end
    
    typesig { [::Java::Float] }
    def put(x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    def put(i, x)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [FloatBuffer] }
    def put(src)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
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
    
    typesig { [] }
    def order
      return (((ByteOrder.native_order).equal?(ByteOrder::BIG_ENDIAN)) ? ByteOrder::LITTLE_ENDIAN : ByteOrder::BIG_ENDIAN)
    end
    
    private
    alias_method :initialize__direct_float_buffer_rs, :initialize
  end
  
end
