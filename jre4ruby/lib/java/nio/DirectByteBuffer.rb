require "rjava"

# 
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
  module DirectByteBufferImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
      include_const ::Sun::Misc, :Cleaner
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include_const ::Sun::Nio::Ch, :FileChannelImpl
    }
  end
  
  class DirectByteBuffer < DirectByteBufferImports.const_get :MappedByteBuffer
    include_class_members DirectByteBufferImports
    include DirectBuffer
    
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
    # protected long address;
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
    
    class_module.module_eval {
      const_set_lazy(:Deallocator) { Class.new do
        include_class_members DirectByteBuffer
        include Runnable
        
        class_module.module_eval {
          
          def unsafe
            defined?(@@unsafe) ? @@unsafe : @@unsafe= Unsafe.get_unsafe
          end
          alias_method :attr_unsafe, :unsafe
          
          def unsafe=(value)
            @@unsafe = value
          end
          alias_method :attr_unsafe=, :unsafe=
        }
        
        attr_accessor :address
        alias_method :attr_address, :address
        undef_method :address
        alias_method :attr_address=, :address=
        undef_method :address=
        
        attr_accessor :capacity
        alias_method :attr_capacity, :capacity
        undef_method :capacity
        alias_method :attr_capacity=, :capacity=
        undef_method :capacity=
        
        typesig { [::Java::Long, ::Java::Int] }
        def initialize(address, capacity)
          @address = 0
          @capacity = 0
          raise AssertError if not ((!(address).equal?(0)))
          @address = address
          @capacity = capacity
        end
        
        typesig { [] }
        def run
          if ((@address).equal?(0))
            # Paranoia
            return
          end
          self.attr_unsafe.free_memory(@address)
          @address = 0
          Bits.unreserve_memory(@capacity)
        end
        
        private
        alias_method :initialize__deallocator, :initialize
      end }
    }
    
    attr_accessor :cleaner
    alias_method :attr_cleaner, :cleaner
    undef_method :cleaner
    alias_method :attr_cleaner=, :cleaner=
    undef_method :cleaner=
    
    typesig { [] }
    def cleaner
      return @cleaner
    end
    
    typesig { [::Java::Int] }
    # Primary constructor
    def initialize(cap)
      # package-private
      @viewed_buffer = nil
      @cleaner = nil
      super(-1, 0, cap, cap, false)
      @viewed_buffer = nil
      Bits.reserve_memory(cap)
      ps = Bits.page_size
      base = 0
      begin
        base = UnsafeInstance.allocate_memory(cap + ps)
      rescue OutOfMemoryError => x
        Bits.unreserve_memory(cap)
        raise x
      end
      UnsafeInstance.set_memory(base, cap + ps, 0)
      if (!(base % ps).equal?(0))
        # Round up to page boundary
        self.attr_address = base + ps - (base & (ps - 1))
      else
        self.attr_address = base
      end
      @cleaner = Cleaner.create(self, Deallocator.new(base, cap))
    end
    
    typesig { [::Java::Long, ::Java::Int] }
    # Invoked only by JNI: NewDirectByteBuffer(void*, long)
    def initialize(addr, cap)
      @viewed_buffer = nil
      @cleaner = nil
      super(-1, 0, cap, cap, false)
      @viewed_buffer = nil
      self.attr_address = addr
      @cleaner = nil
    end
    
    typesig { [::Java::Int, ::Java::Long, Runnable] }
    # For memory-mapped buffers -- invoked by FileChannelImpl via reflection
    def initialize(cap, addr, unmapper)
      @viewed_buffer = nil
      @cleaner = nil
      super(-1, 0, cap, cap, true)
      @viewed_buffer = nil
      self.attr_address = addr
      @viewed_buffer = nil
      @cleaner = Cleaner.create(self, unmapper)
    end
    
    typesig { [DirectBuffer, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # For duplicates and slices
    # 
    # package-private
    def initialize(db, mark, pos, lim, cap, off)
      @viewed_buffer = nil
      @cleaner = nil
      super(mark, pos, lim, cap)
      @viewed_buffer = nil
      self.attr_address = db.address + off
      @viewed_buffer = db
      @cleaner = nil
    end
    
    typesig { [] }
    def slice
      pos = self.position
      lim = self.limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      off = (pos << 0)
      raise AssertError if not ((off >= 0))
      return DirectByteBuffer.new(self, -1, 0, rem, rem, off)
    end
    
    typesig { [] }
    def duplicate
      return DirectByteBuffer.new(self, self.mark_value, self.position, self.limit, self.capacity, 0)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return DirectByteBufferR.new(self, self.mark_value, self.position, self.limit, self.capacity, 0)
    end
    
    typesig { [] }
    def address
      return self.attr_address
    end
    
    typesig { [::Java::Int] }
    def ix(i)
      return self.attr_address + (i << 0)
    end
    
    typesig { [] }
    def get
      return ((UnsafeInstance.get_byte(ix(next_get_index))))
    end
    
    typesig { [::Java::Int] }
    def get(i)
      return ((UnsafeInstance.get_byte(ix(check_index(i)))))
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def get(dst, offset, length)
      if ((length << 0) > Bits::JNI_COPY_TO_ARRAY_THRESHOLD)
        check_bounds(offset, length, dst.attr_length)
        pos = position
        lim = limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        if (length > rem)
          raise BufferUnderflowException.new
        end
        if (!(order).equal?(ByteOrder.native_order))
          Bits.copy_to_byte_array(ix(pos), dst, offset << 0, length << 0)
        else
          Bits.copy_to_byte_array(ix(pos), dst, offset << 0, length << 0)
        end
        position(pos + length)
      else
        super(dst, offset, length)
      end
      return self
    end
    
    typesig { [::Java::Byte] }
    def put(x)
      UnsafeInstance.put_byte(ix(next_put_index), ((x)))
      return self
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def put(i, x)
      UnsafeInstance.put_byte(ix(check_index(i)), ((x)))
      return self
    end
    
    typesig { [ByteBuffer] }
    def put(src)
      if (src.is_a?(DirectByteBuffer))
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
        UnsafeInstance.copy_memory(sb.ix(spos), ix(pos), srem << 0)
        sb.position(spos + srem)
        position(pos + srem)
      else
        if (!(src.attr_hb).nil?)
          spos_ = src.position
          slim_ = src.limit
          raise AssertError if not ((spos_ <= slim_))
          srem_ = (spos_ <= slim_ ? slim_ - spos_ : 0)
          put(src.attr_hb, src.attr_offset + spos_, srem_)
          src.position(spos_ + srem_)
        else
          super(src)
        end
      end
      return self
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def put(src, offset, length)
      if ((length << 0) > Bits::JNI_COPY_FROM_ARRAY_THRESHOLD)
        check_bounds(offset, length, src.attr_length)
        pos = position
        lim = limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        if (length > rem)
          raise BufferOverflowException.new
        end
        if (!(order).equal?(ByteOrder.native_order))
          Bits.copy_from_byte_array(src, offset << 0, ix(pos), length << 0)
        else
          Bits.copy_from_byte_array(src, offset << 0, ix(pos), length << 0)
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
      UnsafeInstance.copy_memory(ix(pos), ix(0), rem << 0)
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
    
    typesig { [::Java::Int] }
    def __get(i)
      # package-private
      return UnsafeInstance.get_byte(self.attr_address + i)
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def __put(i, b)
      # package-private
      UnsafeInstance.put_byte(self.attr_address + i, b)
    end
    
    typesig { [::Java::Long] }
    def get_char(a)
      if (Unaligned)
        x = UnsafeInstance.get_char(a)
        return (self.attr_native_byte_order ? x : Bits.swap(x))
      end
      return Bits.get_char(a, self.attr_big_endian)
    end
    
    typesig { [] }
    def get_char
      return get_char(ix(next_get_index((1 << 1))))
    end
    
    typesig { [::Java::Int] }
    def get_char(i)
      return get_char(ix(check_index(i, (1 << 1))))
    end
    
    typesig { [::Java::Long, ::Java::Char] }
    def put_char(a, x)
      if (Unaligned)
        y = (x)
        UnsafeInstance.put_char(a, (self.attr_native_byte_order ? y : Bits.swap(y)))
      else
        Bits.put_char(a, x, self.attr_big_endian)
      end
      return self
    end
    
    typesig { [::Java::Char] }
    def put_char(x)
      put_char(ix(next_put_index((1 << 1))), x)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    def put_char(i, x)
      put_char(ix(check_index(i, (1 << 1))), x)
      return self
    end
    
    typesig { [] }
    def as_char_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 1
      if (!Unaligned && (!((self.attr_address + off) % (1 << 1)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsCharBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsCharBufferL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectCharBufferU.new(self, -1, 0, size, size, off)) : (DirectCharBufferS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long] }
    def get_short(a)
      if (Unaligned)
        x = UnsafeInstance.get_short(a)
        return (self.attr_native_byte_order ? x : Bits.swap(x))
      end
      return Bits.get_short(a, self.attr_big_endian)
    end
    
    typesig { [] }
    def get_short
      return get_short(ix(next_get_index((1 << 1))))
    end
    
    typesig { [::Java::Int] }
    def get_short(i)
      return get_short(ix(check_index(i, (1 << 1))))
    end
    
    typesig { [::Java::Long, ::Java::Short] }
    def put_short(a, x)
      if (Unaligned)
        y = (x)
        UnsafeInstance.put_short(a, (self.attr_native_byte_order ? y : Bits.swap(y)))
      else
        Bits.put_short(a, x, self.attr_big_endian)
      end
      return self
    end
    
    typesig { [::Java::Short] }
    def put_short(x)
      put_short(ix(next_put_index((1 << 1))), x)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Short] }
    def put_short(i, x)
      put_short(ix(check_index(i, (1 << 1))), x)
      return self
    end
    
    typesig { [] }
    def as_short_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 1
      if (!Unaligned && (!((self.attr_address + off) % (1 << 1)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsShortBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsShortBufferL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectShortBufferU.new(self, -1, 0, size, size, off)) : (DirectShortBufferS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long] }
    def get_int(a)
      if (Unaligned)
        x = UnsafeInstance.get_int(a)
        return (self.attr_native_byte_order ? x : Bits.swap(x))
      end
      return Bits.get_int(a, self.attr_big_endian)
    end
    
    typesig { [] }
    def get_int
      return get_int(ix(next_get_index((1 << 2))))
    end
    
    typesig { [::Java::Int] }
    def get_int(i)
      return get_int(ix(check_index(i, (1 << 2))))
    end
    
    typesig { [::Java::Long, ::Java::Int] }
    def put_int(a, x)
      if (Unaligned)
        y = (x)
        UnsafeInstance.put_int(a, (self.attr_native_byte_order ? y : Bits.swap(y)))
      else
        Bits.put_int(a, x, self.attr_big_endian)
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def put_int(x)
      put_int(ix(next_put_index((1 << 2))), x)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_int(i, x)
      put_int(ix(check_index(i, (1 << 2))), x)
      return self
    end
    
    typesig { [] }
    def as_int_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 2
      if (!Unaligned && (!((self.attr_address + off) % (1 << 2)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsIntBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsIntBufferL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectIntBufferU.new(self, -1, 0, size, size, off)) : (DirectIntBufferS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long] }
    def get_long(a)
      if (Unaligned)
        x = UnsafeInstance.get_long(a)
        return (self.attr_native_byte_order ? x : Bits.swap(x))
      end
      return Bits.get_long(a, self.attr_big_endian)
    end
    
    typesig { [] }
    def get_long
      return get_long(ix(next_get_index((1 << 3))))
    end
    
    typesig { [::Java::Int] }
    def get_long(i)
      return get_long(ix(check_index(i, (1 << 3))))
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    def put_long(a, x)
      if (Unaligned)
        y = (x)
        UnsafeInstance.put_long(a, (self.attr_native_byte_order ? y : Bits.swap(y)))
      else
        Bits.put_long(a, x, self.attr_big_endian)
      end
      return self
    end
    
    typesig { [::Java::Long] }
    def put_long(x)
      put_long(ix(next_put_index((1 << 3))), x)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put_long(i, x)
      put_long(ix(check_index(i, (1 << 3))), x)
      return self
    end
    
    typesig { [] }
    def as_long_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 3
      if (!Unaligned && (!((self.attr_address + off) % (1 << 3)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsLongBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsLongBufferL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectLongBufferU.new(self, -1, 0, size, size, off)) : (DirectLongBufferS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long] }
    def get_float(a)
      if (Unaligned)
        x = UnsafeInstance.get_int(a)
        return Float.int_bits_to_float(self.attr_native_byte_order ? x : Bits.swap(x))
      end
      return Bits.get_float(a, self.attr_big_endian)
    end
    
    typesig { [] }
    def get_float
      return get_float(ix(next_get_index((1 << 2))))
    end
    
    typesig { [::Java::Int] }
    def get_float(i)
      return get_float(ix(check_index(i, (1 << 2))))
    end
    
    typesig { [::Java::Long, ::Java::Float] }
    def put_float(a, x)
      if (Unaligned)
        y = Float.float_to_raw_int_bits(x)
        UnsafeInstance.put_int(a, (self.attr_native_byte_order ? y : Bits.swap(y)))
      else
        Bits.put_float(a, x, self.attr_big_endian)
      end
      return self
    end
    
    typesig { [::Java::Float] }
    def put_float(x)
      put_float(ix(next_put_index((1 << 2))), x)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    def put_float(i, x)
      put_float(ix(check_index(i, (1 << 2))), x)
      return self
    end
    
    typesig { [] }
    def as_float_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 2
      if (!Unaligned && (!((self.attr_address + off) % (1 << 2)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsFloatBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsFloatBufferL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectFloatBufferU.new(self, -1, 0, size, size, off)) : (DirectFloatBufferS.new(self, -1, 0, size, size, off)))
      end
    end
    
    typesig { [::Java::Long] }
    def get_double(a)
      if (Unaligned)
        x = UnsafeInstance.get_long(a)
        return Double.long_bits_to_double(self.attr_native_byte_order ? x : Bits.swap(x))
      end
      return Bits.get_double(a, self.attr_big_endian)
    end
    
    typesig { [] }
    def get_double
      return get_double(ix(next_get_index((1 << 3))))
    end
    
    typesig { [::Java::Int] }
    def get_double(i)
      return get_double(ix(check_index(i, (1 << 3))))
    end
    
    typesig { [::Java::Long, ::Java::Double] }
    def put_double(a, x)
      if (Unaligned)
        y = Double.double_to_raw_long_bits(x)
        UnsafeInstance.put_long(a, (self.attr_native_byte_order ? y : Bits.swap(y)))
      else
        Bits.put_double(a, x, self.attr_big_endian)
      end
      return self
    end
    
    typesig { [::Java::Double] }
    def put_double(x)
      put_double(ix(next_put_index((1 << 3))), x)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Double] }
    def put_double(i, x)
      put_double(ix(check_index(i, (1 << 3))), x)
      return self
    end
    
    typesig { [] }
    def as_double_buffer
      off = self.position
      lim = self.limit
      raise AssertError if not ((off <= lim))
      rem = (off <= lim ? lim - off : 0)
      size = rem >> 3
      if (!Unaligned && (!((self.attr_address + off) % (1 << 3)).equal?(0)))
        return (self.attr_big_endian ? (ByteBufferAsDoubleBufferB.new(self, -1, 0, size, size, off)) : (ByteBufferAsDoubleBufferL.new(self, -1, 0, size, size, off)))
      else
        return (self.attr_native_byte_order ? (DirectDoubleBufferU.new(self, -1, 0, size, size, off)) : (DirectDoubleBufferS.new(self, -1, 0, size, size, off)))
      end
    end
    
    private
    alias_method :initialize__direct_byte_buffer, :initialize
  end
  
end
