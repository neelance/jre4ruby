require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module BitArrayImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Util, :Arrays
    }
  end
  
  # A packed array of booleans.
  # 
  # @author Joshua Bloch
  # @author Douglas Hoover
  class BitArray 
    include_class_members BitArrayImports
    
    attr_accessor :repn
    alias_method :attr_repn, :repn
    undef_method :repn
    alias_method :attr_repn=, :repn=
    undef_method :repn=
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    class_module.module_eval {
      const_set_lazy(:BITS_PER_UNIT) { 8 }
      const_attr_reader  :BITS_PER_UNIT
      
      typesig { [::Java::Int] }
      def subscript(idx)
        return idx / BITS_PER_UNIT
      end
      
      typesig { [::Java::Int] }
      def position(idx)
        # bits big-endian in each unit
        return 1 << (BITS_PER_UNIT - 1 - (idx % BITS_PER_UNIT))
      end
    }
    
    typesig { [::Java::Int] }
    # Creates a BitArray of the specified size, initialized to zeros.
    def initialize(length)
      @repn = nil
      @length = 0
      if (length < 0)
        raise IllegalArgumentException.new("Negative length for BitArray")
      end
      @length = length
      @repn = Array.typed(::Java::Byte).new((length + BITS_PER_UNIT - 1) / BITS_PER_UNIT) { 0 }
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Creates a BitArray of the specified size, initialized from the
    # specified byte array.  The most significant bit of a[0] gets
    # index zero in the BitArray.  The array a must be large enough
    # to specify a value for every bit in the BitArray.  In other words,
    # 8*a.length <= length.
    def initialize(length, a)
      @repn = nil
      @length = 0
      if (length < 0)
        raise IllegalArgumentException.new("Negative length for BitArray")
      end
      if (a.attr_length * BITS_PER_UNIT < length)
        raise IllegalArgumentException.new("Byte array too short to represent " + "bit array of given length")
      end
      @length = length
      rep_length = ((length + BITS_PER_UNIT - 1) / BITS_PER_UNIT)
      unused_bits = rep_length * BITS_PER_UNIT - length
      bit_mask = (0xff << unused_bits)
      # normalize the representation:
      # 1. discard extra bytes
      # 2. zero out extra bits in the last byte
      @repn = Array.typed(::Java::Byte).new(rep_length) { 0 }
      System.arraycopy(a, 0, @repn, 0, rep_length)
      if (rep_length > 0)
        @repn[rep_length - 1] &= bit_mask
      end
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    # Create a BitArray whose bits are those of the given array
    # of Booleans.
    def initialize(bits)
      @repn = nil
      @length = 0
      @length = bits.attr_length
      @repn = Array.typed(::Java::Byte).new((@length + 7) / 8) { 0 }
      i = 0
      while i < @length
        set(i, bits[i])
        i += 1
      end
    end
    
    typesig { [BitArray] }
    # Copy constructor (for cloning).
    def initialize(ba)
      @repn = nil
      @length = 0
      @length = ba.attr_length
      @repn = ba.attr_repn.clone
    end
    
    typesig { [::Java::Int] }
    # Returns the indexed bit in this BitArray.
    def get(index)
      if (index < 0 || index >= @length)
        raise ArrayIndexOutOfBoundsException.new(JavaInteger.to_s(index))
      end
      return !((@repn[subscript(index)] & position(index))).equal?(0)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Sets the indexed bit in this BitArray.
    def set(index, value)
      if (index < 0 || index >= @length)
        raise ArrayIndexOutOfBoundsException.new(JavaInteger.to_s(index))
      end
      idx = subscript(index)
      bit = position(index)
      if (value)
        @repn[idx] |= bit
      else
        @repn[idx] &= ~bit
      end
    end
    
    typesig { [] }
    # Returns the length of this BitArray.
    def length
      return @length
    end
    
    typesig { [] }
    # Returns a Byte array containing the contents of this BitArray.
    # The bit stored at index zero in this BitArray will be copied
    # into the most significant bit of the zeroth element of the
    # returned byte array.  The last byte of the returned byte array
    # will be contain zeros in any bits that do not have corresponding
    # bits in the BitArray.  (This matters only if the BitArray's size
    # is not a multiple of 8.)
    def to_byte_array
      return @repn.clone
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if ((obj).nil? || !(obj.is_a?(BitArray)))
        return false
      end
      ba = obj
      if (!(ba.attr_length).equal?(@length))
        return false
      end
      i = 0
      while i < @repn.attr_length
        if (!(@repn[i]).equal?(ba.attr_repn[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Return a boolean array with the same bit values a this BitArray.
    def to_boolean_array
      bits = Array.typed(::Java::Boolean).new(@length) { false }
      i = 0
      while i < @length
        bits[i] = get(i)
        i += 1
      end
      return bits
    end
    
    typesig { [] }
    # Returns a hash code value for this bit array.
    # 
    # @return  a hash code value for this bit array.
    def hash_code
      hash_code = 0
      i = 0
      while i < @repn.attr_length
        hash_code = 31 * hash_code + @repn[i]
        i += 1
      end
      return hash_code ^ @length
    end
    
    typesig { [] }
    def clone
      return BitArray.new(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:NYBBLE) { Array.typed(Array.typed(::Java::Byte)).new([Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?1.ord)]), Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?1.ord)]), Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?0.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?0.ord), Character.new(?1.ord)]), Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?1.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?1.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?1.ord), Character.new(?0.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?1.ord), Character.new(?0.ord), Character.new(?1.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?0.ord)]), Array.typed(::Java::Byte).new([Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord)])]) }
      const_attr_reader  :NYBBLE
      
      const_set_lazy(:BYTES_PER_LINE) { 8 }
      const_attr_reader  :BYTES_PER_LINE
    }
    
    typesig { [] }
    # Returns a string representation of this BitArray.
    def to_s
      out = ByteArrayOutputStream.new
      i = 0
      while i < @repn.attr_length - 1
        out.write(NYBBLE[(@repn[i] >> 4) & 0xf], 0, 4)
        out.write(NYBBLE[@repn[i] & 0xf], 0, 4)
        if ((i % BYTES_PER_LINE).equal?(BYTES_PER_LINE - 1))
          out.write(Character.new(?\n.ord))
        else
          out.write(Character.new(?\s.ord))
        end
        i += 1
      end
      # in last byte of repn, use only the valid bits
      i_ = BITS_PER_UNIT * (@repn.attr_length - 1)
      while i_ < @length
        out.write(get(i_) ? Character.new(?1.ord) : Character.new(?0.ord))
        i_ += 1
      end
      return String.new(out.to_byte_array)
    end
    
    typesig { [] }
    def truncate
      i = @length - 1
      while i >= 0
        if (get(i))
          return BitArray.new(i + 1, Arrays.copy_of(@repn, (i + BITS_PER_UNIT) / BITS_PER_UNIT))
        end
        i -= 1
      end
      return BitArray.new(1)
    end
    
    private
    alias_method :initialize__bit_array, :initialize
  end
  
end
