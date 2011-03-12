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
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio
  module DirectFloatBufferSImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
      include_const ::Sun::Misc, :Cleaner
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include_const ::Sun::Nio::Ch, :FileChannelImpl
    }
  end
  
  class DirectFloatBufferS < DirectFloatBufferSImports.const_get :FloatBuffer
    include_class_members DirectFloatBufferSImports
    overload_protected {
      include DirectBuffer
    }
    
    class_module.module_eval {
      # Cached unsafe-access object
      const_set_lazy(:UnsafeInstance) { Bits.unsafe }
      const_attr_reader  :UnsafeInstance
      
      # Cached unaligned-access capability
      const_set_lazy(:Unaligned) { Bits.unaligned }
      const_attr_reader  :Unaligned
    }
    
    # Base address, used in all indexing calculations
    # NOTE: moved up to Buffer.java for speed in JNI GetDirectBufferAddress
    #    protected long address;
    # If this buffer is a view of another buffer then we keep a reference to
    # that buffer so that its memory isn't freed before we're done with it
    attr_accessor :viewed_buffer
    alias_method :attr_viewed_buffer, :viewed_buffer
    undef_method :viewed_buffer
    alias_method :attr_viewed_buffer=, :viewed_buffer=
    undef_method :viewed_buffer=
    
    typesig { [] }
    def viewed_buffer
      return @viewed_buffer
    end
    
    typesig { [] }
    def cleaner
      return nil
    end
    
    typesig { [DirectBuffer, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # For duplicates and slices
    # 
    def initialize(db, mark, pos, lim, cap, off)
      @viewed_buffer = nil
      super(mark, pos, lim, cap)
      @viewed_buffer = nil # package-private
      self.attr_address = db.address + off
      @viewed_buffer = db
    end
    
    typesig { [] }
    def slice
      pos = self.position
      lim = self.limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      off = (pos << 2)
      raise AssertError if not ((off >= 0))
      return DirectFloatBufferS.new(self, -1, 0, rem, rem, off)
    end
    
    typesig { [] }
    def duplicate
      return DirectFloatBufferS.new(self, self.mark_value, self.position, self.limit, self.capacity, 0)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return DirectFloatBufferRS.new(self, self.mark_value, self.position, self.limit, self.capacity, 0)
    end
    
    typesig { [] }
    def address
      return self.attr_address
    end
    
    typesig { [::Java::Int] }
    def ix(i)
      return self.attr_address + (i << 2)
    end
    
    typesig { [] }
    def get
      return Float.int_bits_to_float(Bits.swap(UnsafeInstance.get_int(ix(next_get_index))))
    end
    
    typesig { [::Java::Int] }
    def get(i)
      return Float.int_bits_to_float(Bits.swap(UnsafeInstance.get_int(ix(check_index(i)))))
    end
    
    typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
    def get(dst, offset, length)
      if ((length << 2) > Bits::JNI_COPY_TO_ARRAY_THRESHOLD)
        check_bounds(offset, length, dst.attr_length)
        pos = position
        lim = limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        if (length > rem)
          raise BufferUnderflowException.new
        end
        if (!(order).equal?(ByteOrder.native_order))
          Bits.copy_to_int_array(ix(pos), dst, offset << 2, length << 2)
        else
          Bits.copy_to_byte_array(ix(pos), dst, offset << 2, length << 2)
        end
        position(pos + length)
      else
        super(dst, offset, length)
      end
      return self
    end
    
    typesig { [::Java::Float] }
    def put(x)
      UnsafeInstance.put_int(ix(next_put_index), Bits.swap(Float.float_to_raw_int_bits(x)))
      return self
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    def put(i, x)
      UnsafeInstance.put_int(ix(check_index(i)), Bits.swap(Float.float_to_raw_int_bits(x)))
      return self
    end
    
    typesig { [FloatBuffer] }
    def put(src)
      if (src.is_a?(DirectFloatBufferS))
        if ((src).equal?(self))
          raise IllegalArgumentException.new
        end
        sb = src
        spos = sb.position
        slim = sb.limit
        raise AssertError if not ((spos <= slim))
        srem = (spos <= slim ? slim - spos : 0)
        pos = position
        lim = limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        if (srem > rem)
          raise BufferOverflowException.new
        end
        UnsafeInstance.copy_memory(sb.ix(spos), ix(pos), srem << 2)
        sb.position(spos + srem)
        position(pos + srem)
      else
        if (!(src.attr_hb).nil?)
          spos = src.position
          slim = src.limit
          raise AssertError if not ((spos <= slim))
          srem = (spos <= slim ? slim - spos : 0)
          put(src.attr_hb, src.attr_offset + spos, srem)
          src.position(spos + srem)
        else
          super(src)
        end
      end
      return self
    end
    
    typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
    def put(src, offset, length)
      if ((length << 2) > Bits::JNI_COPY_FROM_ARRAY_THRESHOLD)
        check_bounds(offset, length, src.attr_length)
        pos = position
        lim = limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        if (length > rem)
          raise BufferOverflowException.new
        end
        if (!(order).equal?(ByteOrder.native_order))
          Bits.copy_from_int_array(src, offset << 2, ix(pos), length << 2)
        else
          Bits.copy_from_byte_array(src, offset << 2, ix(pos), length << 2)
        end
        position(pos + length)
      else
        super(src, offset, length)
      end
      return self
    end
    
    typesig { [] }
    def compact
      pos = position
      lim = limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      UnsafeInstance.copy_memory(ix(pos), ix(0), rem << 2)
      position(rem)
      limit(capacity)
      discard_mark
      return self
    end
    
    typesig { [] }
    def is_direct
      return true
    end
    
    typesig { [] }
    def is_read_only
      return false
    end
    
    typesig { [] }
    def order
      return (((ByteOrder.native_order).equal?(ByteOrder::BIG_ENDIAN)) ? ByteOrder::LITTLE_ENDIAN : ByteOrder::BIG_ENDIAN)
    end
    
    private
    alias_method :initialize__direct_float_buffer_s, :initialize
  end
  
end
