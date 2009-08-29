require "rjava"

# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Math
  module MutableBigIntegerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Math
    }
  end
  
  # A class used to represent multiprecision integers that makes efficient
  # use of allocated space by allowing a number to occupy only part of
  # an array so that the arrays do not have to be reallocated as often.
  # When performing an operation with many iterations the array used to
  # hold a number is only reallocated when necessary and does not have to
  # be the same size as the number it represents. A mutable number allows
  # calculations to occur on the same number without having to create
  # a new number for every step of the calculation as occurs with
  # BigIntegers.
  # 
  # @see     BigInteger
  # @author  Michael McCloskey
  # @since   1.3
  class MutableBigInteger 
    include_class_members MutableBigIntegerImports
    
    # Holds the magnitude of this MutableBigInteger in big endian order.
    # The magnitude may start at an offset into the value array, and it may
    # end before the length of the value array.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    # The number of ints of the value array that are currently used
    # to hold the magnitude of this MutableBigInteger. The magnitude starts
    # at an offset and offset + intLen may be less than value.length.
    attr_accessor :int_len
    alias_method :attr_int_len, :int_len
    undef_method :int_len
    alias_method :attr_int_len=, :int_len=
    undef_method :int_len=
    
    # The offset into the value array where the magnitude of this
    # MutableBigInteger begins.
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    class_module.module_eval {
      # This mask is used to obtain the value of an int as if it were unsigned.
      const_set_lazy(:LONG_MASK) { 0xffffffff }
      const_attr_reader  :LONG_MASK
    }
    
    typesig { [] }
    # Constructors
    # 
    # The default constructor. An empty MutableBigInteger is created with
    # a one word capacity.
    def initialize
      @value = nil
      @int_len = 0
      @offset = 0
      @value = Array.typed(::Java::Int).new(1) { 0 }
      @int_len = 0
    end
    
    typesig { [::Java::Int] }
    # Construct a new MutableBigInteger with a magnitude specified by
    # the int val.
    def initialize(val)
      @value = nil
      @int_len = 0
      @offset = 0
      @value = Array.typed(::Java::Int).new(1) { 0 }
      @int_len = 1
      @value[0] = val
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int] }
    # Construct a new MutableBigInteger with the specified value array
    # up to the specified length.
    def initialize(val, len)
      @value = nil
      @int_len = 0
      @offset = 0
      @value = val
      @int_len = len
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Construct a new MutableBigInteger with the specified value array
    # up to the length of the array supplied.
    def initialize(val)
      @value = nil
      @int_len = 0
      @offset = 0
      @value = val
      @int_len = val.attr_length
    end
    
    typesig { [BigInteger] }
    # Construct a new MutableBigInteger with a magnitude equal to the
    # specified BigInteger.
    def initialize(b)
      @value = nil
      @int_len = 0
      @offset = 0
      @value = b.attr_mag.clone
      @int_len = @value.attr_length
    end
    
    typesig { [MutableBigInteger] }
    # Construct a new MutableBigInteger with a magnitude equal to the
    # specified MutableBigInteger.
    def initialize(val)
      @value = nil
      @int_len = 0
      @offset = 0
      @int_len = val.attr_int_len
      @value = Array.typed(::Java::Int).new(@int_len) { 0 }
      i = 0
      while i < @int_len
        @value[i] = val.attr_value[val.attr_offset + i]
        i += 1
      end
    end
    
    typesig { [] }
    # Clear out a MutableBigInteger for reuse.
    def clear
      @offset = @int_len = 0
      index = 0
      n = @value.attr_length
      while index < n
        @value[index] = 0
        index += 1
      end
    end
    
    typesig { [] }
    # Set a MutableBigInteger to zero, removing its offset.
    def reset
      @offset = @int_len = 0
    end
    
    typesig { [MutableBigInteger] }
    # Compare the magnitude of two MutableBigIntegers. Returns -1, 0 or 1
    # as this MutableBigInteger is numerically less than, equal to, or
    # greater than {@code b}.
    def compare(b)
      if (@int_len < b.attr_int_len)
        return -1
      end
      if (@int_len > b.attr_int_len)
        return 1
      end
      i = 0
      while i < @int_len
        b1 = @value[@offset + i] + -0x80000000
        b2 = b.attr_value[b.attr_offset + i] + -0x80000000
        if (b1 < b2)
          return -1
        end
        if (b1 > b2)
          return 1
        end
        i += 1
      end
      return 0
    end
    
    typesig { [] }
    # Return the index of the lowest set bit in this MutableBigInteger. If the
    # magnitude of this MutableBigInteger is zero, -1 is returned.
    def get_lowest_set_bit
      if ((@int_len).equal?(0))
        return -1
      end
      j = 0
      b = 0
      j = @int_len - 1
      while (j > 0) && ((@value[j + @offset]).equal?(0))
        j -= 1
      end
      b = @value[j + @offset]
      if ((b).equal?(0))
        return -1
      end
      return ((@int_len - 1 - j) << 5) + BigInteger.trailing_zero_cnt(b)
    end
    
    typesig { [::Java::Int] }
    # Return the int in use in this MutableBigInteger at the specified
    # index. This method is not used because it is not inlined on all
    # platforms.
    def get_int(index)
      return @value[@offset + index]
    end
    
    typesig { [::Java::Int] }
    # Return a long which is equal to the unsigned value of the int in
    # use in this MutableBigInteger at the specified index. This method is
    # not used because it is not inlined on all platforms.
    def get_long(index)
      return @value[@offset + index] & LONG_MASK
    end
    
    typesig { [] }
    # Ensure that the MutableBigInteger is in normal form, specifically
    # making sure that there are no leading zeros, and that if the
    # magnitude is zero, then intLen is zero.
    def normalize
      if ((@int_len).equal?(0))
        @offset = 0
        return
      end
      index = @offset
      if (!(@value[index]).equal?(0))
        return
      end
      index_bound = index + @int_len
      begin
        index += 1
      end while (index < index_bound && (@value[index]).equal?(0))
      num_zeros = index - @offset
      @int_len -= num_zeros
      @offset = ((@int_len).equal?(0) ? 0 : @offset + num_zeros)
    end
    
    typesig { [::Java::Int] }
    # If this MutableBigInteger cannot hold len words, increase the size
    # of the value array to len words.
    def ensure_capacity(len)
      if (@value.attr_length < len)
        @value = Array.typed(::Java::Int).new(len) { 0 }
        @offset = 0
        @int_len = len
      end
    end
    
    typesig { [] }
    # Convert this MutableBigInteger into an int array with no leading
    # zeros, of a length that is equal to this MutableBigInteger's intLen.
    def to_int_array
      result = Array.typed(::Java::Int).new(@int_len) { 0 }
      i = 0
      while i < @int_len
        result[i] = @value[@offset + i]
        i += 1
      end
      return result
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the int at index+offset in this MutableBigInteger to val.
    # This does not get inlined on all platforms so it is not used
    # as often as originally intended.
    def set_int(index, val)
      @value[@offset + index] = val
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int] }
    # Sets this MutableBigInteger's value array to the specified array.
    # The intLen is set to the specified length.
    def set_value(val, length)
      @value = val
      @int_len = length
      @offset = 0
    end
    
    typesig { [MutableBigInteger] }
    # Sets this MutableBigInteger's value array to a copy of the specified
    # array. The intLen is set to the length of the new array.
    def copy_value(val)
      len = val.attr_int_len
      if (@value.attr_length < len)
        @value = Array.typed(::Java::Int).new(len) { 0 }
      end
      i = 0
      while i < len
        @value[i] = val.attr_value[val.attr_offset + i]
        i += 1
      end
      @int_len = len
      @offset = 0
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Sets this MutableBigInteger's value array to a copy of the specified
    # array. The intLen is set to the length of the specified array.
    def copy_value(val)
      len = val.attr_length
      if (@value.attr_length < len)
        @value = Array.typed(::Java::Int).new(len) { 0 }
      end
      i = 0
      while i < len
        @value[i] = val[i]
        i += 1
      end
      @int_len = len
      @offset = 0
    end
    
    typesig { [] }
    # Returns true iff this MutableBigInteger has a value of one.
    def is_one
      return ((@int_len).equal?(1)) && ((@value[@offset]).equal?(1))
    end
    
    typesig { [] }
    # Returns true iff this MutableBigInteger has a value of zero.
    def is_zero
      return ((@int_len).equal?(0))
    end
    
    typesig { [] }
    # Returns true iff this MutableBigInteger is even.
    def is_even
      return ((@int_len).equal?(0)) || (((@value[@offset + @int_len - 1] & 1)).equal?(0))
    end
    
    typesig { [] }
    # Returns true iff this MutableBigInteger is odd.
    def is_odd
      return (((@value[@offset + @int_len - 1] & 1)).equal?(1))
    end
    
    typesig { [] }
    # Returns true iff this MutableBigInteger is in normal form. A
    # MutableBigInteger is in normal form if it has no leading zeros
    # after the offset, and intLen + offset <= value.length.
    def is_normal
      if (@int_len + @offset > @value.attr_length)
        return false
      end
      if ((@int_len).equal?(0))
        return true
      end
      return (!(@value[@offset]).equal?(0))
    end
    
    typesig { [] }
    # Returns a String representation of this MutableBigInteger in radix 10.
    def to_s
      b = BigInteger.new(self, 1)
      return b.to_s
    end
    
    typesig { [::Java::Int] }
    # Right shift this MutableBigInteger n bits. The MutableBigInteger is left
    # in normal form.
    def right_shift(n)
      if ((@int_len).equal?(0))
        return
      end
      n_ints = n >> 5
      n_bits = n & 0x1f
      @int_len -= n_ints
      if ((n_bits).equal?(0))
        return
      end
      bits_in_high_word = BigInteger.bit_len(@value[@offset])
      if (n_bits >= bits_in_high_word)
        self.primitive_left_shift(32 - n_bits)
        @int_len -= 1
      else
        primitive_right_shift(n_bits)
      end
    end
    
    typesig { [::Java::Int] }
    # Left shift this MutableBigInteger n bits.
    def left_shift(n)
      # If there is enough storage space in this MutableBigInteger already
      # the available space will be used. Space to the right of the used
      # ints in the value array is faster to utilize, so the extra space
      # will be taken from the right if possible.
      if ((@int_len).equal?(0))
        return
      end
      n_ints = n >> 5
      n_bits = n & 0x1f
      bits_in_high_word = BigInteger.bit_len(@value[@offset])
      # If shift can be done without moving words, do so
      if (n <= (32 - bits_in_high_word))
        primitive_left_shift(n_bits)
        return
      end
      new_len = @int_len + n_ints + 1
      if (n_bits <= (32 - bits_in_high_word))
        new_len -= 1
      end
      if (@value.attr_length < new_len)
        # The array must grow
        result = Array.typed(::Java::Int).new(new_len) { 0 }
        i = 0
        while i < @int_len
          result[i] = @value[@offset + i]
          i += 1
        end
        set_value(result, new_len)
      else
        if (@value.attr_length - @offset >= new_len)
          # Use space on right
          i = 0
          while i < new_len - @int_len
            @value[@offset + @int_len + i] = 0
            i += 1
          end
        else
          # Must use space on left
          i = 0
          while i < @int_len
            @value[i] = @value[@offset + i]
            i += 1
          end
          i_ = @int_len
          while i_ < new_len
            @value[i_] = 0
            i_ += 1
          end
          @offset = 0
        end
      end
      @int_len = new_len
      if ((n_bits).equal?(0))
        return
      end
      if (n_bits <= (32 - bits_in_high_word))
        primitive_left_shift(n_bits)
      else
        primitive_right_shift(32 - n_bits)
      end
    end
    
    typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Int] }
    # A primitive used for division. This method adds in one multiple of the
    # divisor a back to the dividend result at a specified offset. It is used
    # when qhat was estimated too large, and must be adjusted.
    def divadd(a, result, offset)
      carry = 0
      j = a.attr_length - 1
      while j >= 0
        sum = (a[j] & LONG_MASK) + (result[j + offset] & LONG_MASK) + carry
        result[j + offset] = RJava.cast_to_int(sum)
        carry = sum >> 32
        j -= 1
      end
      return RJava.cast_to_int(carry)
    end
    
    typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
    # This method is used for division. It multiplies an n word input a by one
    # word input x, and subtracts the n word product from q. This is needed
    # when subtracting qhat*divisor from dividend.
    def mulsub(q, a, x, len, offset)
      x_long = x & LONG_MASK
      carry = 0
      offset += len
      j = len - 1
      while j >= 0
        product = (a[j] & LONG_MASK) * x_long + carry
        difference = q[offset] - product
        q[((offset -= 1) + 1)] = RJava.cast_to_int(difference)
        carry = (product >> 32) + (((difference & LONG_MASK) > (((~RJava.cast_to_int(product)) & LONG_MASK))) ? 1 : 0)
        j -= 1
      end
      return RJava.cast_to_int(carry)
    end
    
    typesig { [::Java::Int] }
    # Right shift this MutableBigInteger n bits, where n is
    # less than 32.
    # Assumes that intLen > 0, n > 0 for speed
    def primitive_right_shift(n)
      val = @value
      n2 = 32 - n
      i = @offset + @int_len - 1
      c = val[i]
      while i > @offset
        b = c
        c = val[i - 1]
        val[i] = (c << n2) | (b >> n)
        i -= 1
      end
      val[@offset] >>= n
    end
    
    typesig { [::Java::Int] }
    # Left shift this MutableBigInteger n bits, where n is
    # less than 32.
    # Assumes that intLen > 0, n > 0 for speed
    def primitive_left_shift(n)
      val = @value
      n2 = 32 - n
      i = @offset
      c = val[i]
      m = i + @int_len - 1
      while i < m
        b = c
        c = val[i + 1]
        val[i] = (b << n) | (c >> n2)
        i += 1
      end
      val[@offset + @int_len - 1] <<= n
    end
    
    typesig { [MutableBigInteger] }
    # Adds the contents of two MutableBigInteger objects.The result
    # is placed within this MutableBigInteger.
    # The contents of the addend are not changed.
    def add(addend)
      x = @int_len
      y = addend.attr_int_len
      result_len = (@int_len > addend.attr_int_len ? @int_len : addend.attr_int_len)
      result = (@value.attr_length < result_len ? Array.typed(::Java::Int).new(result_len) { 0 } : @value)
      rstart = result.attr_length - 1
      sum = 0
      # Add common parts of both numbers
      while (x > 0 && y > 0)
        x -= 1
        y -= 1
        sum = (@value[x + @offset] & LONG_MASK) + (addend.attr_value[y + addend.attr_offset] & LONG_MASK) + (sum >> 32)
        result[((rstart -= 1) + 1)] = RJava.cast_to_int(sum)
      end
      # Add remainder of the longer number
      while (x > 0)
        x -= 1
        sum = (@value[x + @offset] & LONG_MASK) + (sum >> 32)
        result[((rstart -= 1) + 1)] = RJava.cast_to_int(sum)
      end
      while (y > 0)
        y -= 1
        sum = (addend.attr_value[y + addend.attr_offset] & LONG_MASK) + (sum >> 32)
        result[((rstart -= 1) + 1)] = RJava.cast_to_int(sum)
      end
      if ((sum >> 32) > 0)
        # Result must grow in length
        result_len += 1
        if (result.attr_length < result_len)
          temp = Array.typed(::Java::Int).new(result_len) { 0 }
          i = result_len - 1
          while i > 0
            temp[i] = result[i - 1]
            i -= 1
          end
          temp[0] = 1
          result = temp
        else
          result[((rstart -= 1) + 1)] = 1
        end
      end
      @value = result
      @int_len = result_len
      @offset = result.attr_length - result_len
    end
    
    typesig { [MutableBigInteger] }
    # Subtracts the smaller of this and b from the larger and places the
    # result into this MutableBigInteger.
    def subtract(b)
      a = self
      result = @value
      sign = a.compare(b)
      if ((sign).equal?(0))
        reset
        return 0
      end
      if (sign < 0)
        tmp = a
        a = b
        b = tmp
      end
      result_len = a.attr_int_len
      if (result.attr_length < result_len)
        result = Array.typed(::Java::Int).new(result_len) { 0 }
      end
      diff = 0
      x = a.attr_int_len
      y = b.attr_int_len
      rstart = result.attr_length - 1
      # Subtract common parts of both numbers
      while (y > 0)
        x -= 1
        y -= 1
        diff = (a.attr_value[x + a.attr_offset] & LONG_MASK) - (b.attr_value[y + b.attr_offset] & LONG_MASK) - (RJava.cast_to_int(-(diff >> 32)))
        result[((rstart -= 1) + 1)] = RJava.cast_to_int(diff)
      end
      # Subtract remainder of longer number
      while (x > 0)
        x -= 1
        diff = (a.attr_value[x + a.attr_offset] & LONG_MASK) - (RJava.cast_to_int(-(diff >> 32)))
        result[((rstart -= 1) + 1)] = RJava.cast_to_int(diff)
      end
      @value = result
      @int_len = result_len
      @offset = @value.attr_length - result_len
      normalize
      return sign
    end
    
    typesig { [MutableBigInteger] }
    # Subtracts the smaller of a and b from the larger and places the result
    # into the larger. Returns 1 if the answer is in a, -1 if in b, 0 if no
    # operation was performed.
    def difference(b)
      a = self
      sign = a.compare(b)
      if ((sign).equal?(0))
        return 0
      end
      if (sign < 0)
        tmp = a
        a = b
        b = tmp
      end
      diff = 0
      x = a.attr_int_len
      y = b.attr_int_len
      # Subtract common parts of both numbers
      while (y > 0)
        x -= 1
        y -= 1
        diff = (a.attr_value[a.attr_offset + x] & LONG_MASK) - (b.attr_value[b.attr_offset + y] & LONG_MASK) - (RJava.cast_to_int(-(diff >> 32)))
        a.attr_value[a.attr_offset + x] = RJava.cast_to_int(diff)
      end
      # Subtract remainder of longer number
      while (x > 0)
        x -= 1
        diff = (a.attr_value[a.attr_offset + x] & LONG_MASK) - (RJava.cast_to_int(-(diff >> 32)))
        a.attr_value[a.attr_offset + x] = RJava.cast_to_int(diff)
      end
      a.normalize
      return sign
    end
    
    typesig { [MutableBigInteger, MutableBigInteger] }
    # Multiply the contents of two MutableBigInteger objects. The result is
    # placed into MutableBigInteger z. The contents of y are not changed.
    def multiply(y, z)
      x_len = @int_len
      y_len = y.attr_int_len
      new_len = x_len + y_len
      # Put z into an appropriate state to receive product
      if (z.attr_value.attr_length < new_len)
        z.attr_value = Array.typed(::Java::Int).new(new_len) { 0 }
      end
      z.attr_offset = 0
      z.attr_int_len = new_len
      # The first iteration is hoisted out of the loop to avoid extra add
      carry = 0
      j = y_len - 1
      k = y_len + x_len - 1
      while j >= 0
        product = (y.attr_value[j + y.attr_offset] & LONG_MASK) * (@value[x_len - 1 + @offset] & LONG_MASK) + carry
        z.attr_value[k] = RJava.cast_to_int(product)
        carry = product >> 32
        j -= 1
        k -= 1
      end
      z.attr_value[x_len - 1] = RJava.cast_to_int(carry)
      # Perform the multiplication word by word
      i = x_len - 2
      while i >= 0
        carry = 0
        j_ = y_len - 1
        k_ = y_len + i
        while j_ >= 0
          product = (y.attr_value[j_ + y.attr_offset] & LONG_MASK) * (@value[i + @offset] & LONG_MASK) + (z.attr_value[k_] & LONG_MASK) + carry
          z.attr_value[k_] = RJava.cast_to_int(product)
          carry = product >> 32
          j_ -= 1
          k_ -= 1
        end
        z.attr_value[i] = RJava.cast_to_int(carry)
        i -= 1
      end
      # Remove leading zeros from product
      z.normalize
    end
    
    typesig { [::Java::Int, MutableBigInteger] }
    # Multiply the contents of this MutableBigInteger by the word y. The
    # result is placed into z.
    def mul(y, z)
      if ((y).equal?(1))
        z.copy_value(self)
        return
      end
      if ((y).equal?(0))
        z.clear
        return
      end
      # Perform the multiplication word by word
      ylong = y & LONG_MASK
      zval = (z.attr_value.attr_length < @int_len + 1 ? Array.typed(::Java::Int).new(@int_len + 1) { 0 } : z.attr_value)
      carry = 0
      i = @int_len - 1
      while i >= 0
        product = ylong * (@value[i + @offset] & LONG_MASK) + carry
        zval[i + 1] = RJava.cast_to_int(product)
        carry = product >> 32
        i -= 1
      end
      if ((carry).equal?(0))
        z.attr_offset = 1
        z.attr_int_len = @int_len
      else
        z.attr_offset = 0
        z.attr_int_len = @int_len + 1
        zval[0] = RJava.cast_to_int(carry)
      end
      z.attr_value = zval
    end
    
    typesig { [::Java::Int, MutableBigInteger] }
    # This method is used for division of an n word dividend by a one word
    # divisor. The quotient is placed into quotient. The one word divisor is
    # specified by divisor. The value of this MutableBigInteger is the
    # dividend at invocation but is replaced by the remainder.
    # 
    # NOTE: The value of this MutableBigInteger is modified by this method.
    def divide_one_word(divisor, quotient)
      div_long = divisor & LONG_MASK
      # Special case of one word dividend
      if ((@int_len).equal?(1))
        rem_value = @value[@offset] & LONG_MASK
        quotient.attr_value[0] = RJava.cast_to_int((rem_value / div_long))
        quotient.attr_int_len = ((quotient.attr_value[0]).equal?(0)) ? 0 : 1
        quotient.attr_offset = 0
        @value[0] = RJava.cast_to_int((rem_value - (quotient.attr_value[0] * div_long)))
        @offset = 0
        @int_len = ((@value[0]).equal?(0)) ? 0 : 1
        return
      end
      if (quotient.attr_value.attr_length < @int_len)
        quotient.attr_value = Array.typed(::Java::Int).new(@int_len) { 0 }
      end
      quotient.attr_offset = 0
      quotient.attr_int_len = @int_len
      # Normalize the divisor
      shift = 32 - BigInteger.bit_len(divisor)
      rem = @value[@offset]
      rem_long = rem & LONG_MASK
      if (rem_long < div_long)
        quotient.attr_value[0] = 0
      else
        quotient.attr_value[0] = RJava.cast_to_int((rem_long / div_long))
        rem = RJava.cast_to_int((rem_long - (quotient.attr_value[0] * div_long)))
        rem_long = rem & LONG_MASK
      end
      xlen = @int_len
      q_word = Array.typed(::Java::Int).new(2) { 0 }
      while ((xlen -= 1) > 0)
        dividend_estimate = (rem_long << 32) | (@value[@offset + @int_len - xlen] & LONG_MASK)
        if (dividend_estimate >= 0)
          q_word[0] = RJava.cast_to_int((dividend_estimate / div_long))
          q_word[1] = RJava.cast_to_int((dividend_estimate - (q_word[0] * div_long)))
        else
          div_word(q_word, dividend_estimate, divisor)
        end
        quotient.attr_value[@int_len - xlen] = q_word[0]
        rem = q_word[1]
        rem_long = rem & LONG_MASK
      end
      # Unnormalize
      if (shift > 0)
        @value[0] = rem %= divisor
      else
        @value[0] = rem
      end
      @int_len = ((@value[0]).equal?(0)) ? 0 : 1
      quotient.normalize
    end
    
    typesig { [MutableBigInteger, MutableBigInteger, MutableBigInteger] }
    # Calculates the quotient and remainder of this div b and places them
    # in the MutableBigInteger objects provided.
    # 
    # Uses Algorithm D in Knuth section 4.3.1.
    # Many optimizations to that algorithm have been adapted from the Colin
    # Plumb C library.
    # It special cases one word divisors for speed.
    # The contents of a and b are not changed.
    def divide(b, quotient, rem)
      if ((b.attr_int_len).equal?(0))
        raise ArithmeticException.new("BigInteger divide by zero")
      end
      # Dividend is zero
      if ((@int_len).equal?(0))
        quotient.attr_int_len = quotient.attr_offset = rem.attr_int_len = rem.attr_offset = 0
        return
      end
      cmp = compare(b)
      # Dividend less than divisor
      if (cmp < 0)
        quotient.attr_int_len = quotient.attr_offset = 0
        rem.copy_value(self)
        return
      end
      # Dividend equal to divisor
      if ((cmp).equal?(0))
        quotient.attr_value[0] = quotient.attr_int_len = 1
        quotient.attr_offset = rem.attr_int_len = rem.attr_offset = 0
        return
      end
      quotient.clear
      # Special case one word divisor
      if ((b.attr_int_len).equal?(1))
        rem.copy_value(self)
        rem.divide_one_word(b.attr_value[b.attr_offset], quotient)
        return
      end
      # Copy divisor value to protect divisor
      d = Array.typed(::Java::Int).new(b.attr_int_len) { 0 }
      i = 0
      while i < b.attr_int_len
        d[i] = b.attr_value[b.attr_offset + i]
        i += 1
      end
      dlen = b.attr_int_len
      # Remainder starts as dividend with space for a leading zero
      if (rem.attr_value.attr_length < @int_len + 1)
        rem.attr_value = Array.typed(::Java::Int).new(@int_len + 1) { 0 }
      end
      i_ = 0
      while i_ < @int_len
        rem.attr_value[i_ + 1] = @value[i_ + @offset]
        i_ += 1
      end
      rem.attr_int_len = @int_len
      rem.attr_offset = 1
      nlen = rem.attr_int_len
      # Set the quotient size
      limit = nlen - dlen + 1
      if (quotient.attr_value.attr_length < limit)
        quotient.attr_value = Array.typed(::Java::Int).new(limit) { 0 }
        quotient.attr_offset = 0
      end
      quotient.attr_int_len = limit
      q = quotient.attr_value
      # D1 normalize the divisor
      shift = 32 - BigInteger.bit_len(d[0])
      if (shift > 0)
        # First shift will not grow array
        BigInteger.primitive_left_shift(d, dlen, shift)
        # But this one might
        rem.left_shift(shift)
      end
      # Must insert leading 0 in rem if its length did not change
      if ((rem.attr_int_len).equal?(nlen))
        rem.attr_offset = 0
        rem.attr_value[0] = 0
        rem.attr_int_len += 1
      end
      dh = d[0]
      dh_long = dh & LONG_MASK
      dl = d[1]
      q_word = Array.typed(::Java::Int).new(2) { 0 }
      # D2 Initialize j
      j = 0
      while j < limit
        # D3 Calculate qhat
        # estimate qhat
        qhat = 0
        qrem = 0
        skip_correction = false
        nh = rem.attr_value[j + rem.attr_offset]
        nh2 = nh + -0x80000000
        nm = rem.attr_value[j + 1 + rem.attr_offset]
        if ((nh).equal?(dh))
          qhat = ~0
          qrem = nh + nm
          skip_correction = qrem + -0x80000000 < nh2
        else
          n_chunk = ((nh) << 32) | (nm & LONG_MASK)
          if (n_chunk >= 0)
            qhat = RJava.cast_to_int((n_chunk / dh_long))
            qrem = RJava.cast_to_int((n_chunk - (qhat * dh_long)))
          else
            div_word(q_word, n_chunk, dh)
            qhat = q_word[0]
            qrem = q_word[1]
          end
        end
        if ((qhat).equal?(0))
          j += 1
          next
        end
        if (!skip_correction)
          # Correct qhat
          nl = rem.attr_value[j + 2 + rem.attr_offset] & LONG_MASK
          rs = ((qrem & LONG_MASK) << 32) | nl
          est_product = (dl & LONG_MASK) * (qhat & LONG_MASK)
          if (unsigned_long_compare(est_product, rs))
            qhat -= 1
            qrem = RJava.cast_to_int(((qrem & LONG_MASK) + dh_long))
            if ((qrem & LONG_MASK) >= dh_long)
              est_product = (dl & LONG_MASK) * (qhat & LONG_MASK)
              rs = ((qrem & LONG_MASK) << 32) | nl
              if (unsigned_long_compare(est_product, rs))
                qhat -= 1
              end
            end
          end
        end
        # D4 Multiply and subtract
        rem.attr_value[j + rem.attr_offset] = 0
        borrow = mulsub(rem.attr_value, d, qhat, dlen, j + rem.attr_offset)
        # D5 Test remainder
        if (borrow + -0x80000000 > nh2)
          # D6 Add back
          divadd(d, rem.attr_value, j + 1 + rem.attr_offset)
          qhat -= 1
        end
        # Store the quotient digit
        q[j] = qhat
        j += 1
      end # D7 loop on j
      # D8 Unnormalize
      if (shift > 0)
        rem.right_shift(shift)
      end
      rem.normalize
      quotient.normalize
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # Compare two longs as if they were unsigned.
    # Returns true iff one is bigger than two.
    def unsigned_long_compare(one, two)
      return (one + Long::MIN_VALUE) > (two + Long::MIN_VALUE)
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Long, ::Java::Int] }
    # This method divides a long quantity by an int to estimate
    # qhat for two multi precision numbers. It is used when
    # the signed value of n is less than zero.
    def div_word(result, n, d)
      d_long = d & LONG_MASK
      if ((d_long).equal?(1))
        result[0] = RJava.cast_to_int(n)
        result[1] = 0
        return
      end
      # Approximate the quotient and remainder
      q = (n >> 1) / (d_long >> 1)
      r = n - q * d_long
      # Correct the approximation
      while (r < 0)
        r += d_long
        q -= 1
      end
      while (r >= d_long)
        r -= d_long
        q += 1
      end
      # n - q*dlong == r && 0 <= r <dLong, hence we're done.
      result[0] = RJava.cast_to_int(q)
      result[1] = RJava.cast_to_int(r)
    end
    
    typesig { [MutableBigInteger] }
    # Calculate GCD of this and b. This and b are changed by the computation.
    def hybrid_gcd(b)
      # Use Euclid's algorithm until the numbers are approximately the
      # same length, then use the binary GCD algorithm to find the GCD.
      a = self
      q = MutableBigInteger.new
      r = MutableBigInteger.new
      while (!(b.attr_int_len).equal?(0))
        if (Math.abs(a.attr_int_len - b.attr_int_len) < 2)
          return a.binary_gcd(b)
        end
        a.divide(b, q, r)
        swapper = a
        a = b
        b = r
        r = swapper
      end
      return a
    end
    
    typesig { [MutableBigInteger] }
    # Calculate GCD of this and v.
    # Assumes that this and v are not zero.
    def binary_gcd(v)
      # Algorithm B from Knuth section 4.5.2
      u = self
      r = MutableBigInteger.new
      # step B1
      s1 = u.get_lowest_set_bit
      s2 = v.get_lowest_set_bit
      k = (s1 < s2) ? s1 : s2
      if (!(k).equal?(0))
        u.right_shift(k)
        v.right_shift(k)
      end
      # step B2
      u_odd = ((k).equal?(s1))
      t = u_odd ? v : u
      tsign = u_odd ? -1 : 1
      lb = 0
      while ((lb = t.get_lowest_set_bit) >= 0)
        # steps B3 and B4
        t.right_shift(lb)
        # step B5
        if (tsign > 0)
          u = t
        else
          v = t
        end
        # Special case one word numbers
        if (u.attr_int_len < 2 && v.attr_int_len < 2)
          x = u.attr_value[u.attr_offset]
          y = v.attr_value[v.attr_offset]
          x = binary_gcd(x, y)
          r.attr_value[0] = x
          r.attr_int_len = 1
          r.attr_offset = 0
          if (k > 0)
            r.left_shift(k)
          end
          return r
        end
        # step B6
        if (((tsign = u.difference(v))).equal?(0))
          break
        end
        t = (tsign >= 0) ? u : v
      end
      if (k > 0)
        u.left_shift(k)
      end
      return u
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int] }
      # Calculate GCD of a and b interpreted as unsigned integers.
      def binary_gcd(a, b)
        if ((b).equal?(0))
          return a
        end
        if ((a).equal?(0))
          return b
        end
        x = 0
        a_zeros = 0
        while (((x = a & 0xff)).equal?(0))
          a >>= 8
          a_zeros += 8
        end
        y = BigInteger.attr_trailing_zero_table[x]
        a_zeros += y
        a >>= y
        b_zeros = 0
        while (((x = b & 0xff)).equal?(0))
          b >>= 8
          b_zeros += 8
        end
        y = BigInteger.attr_trailing_zero_table[x]
        b_zeros += y
        b >>= y
        t = (a_zeros < b_zeros ? a_zeros : b_zeros)
        while (!(a).equal?(b))
          if ((a + -0x80000000) > (b + -0x80000000))
            # a > b as unsigned
            a -= b
            while (((x = a & 0xff)).equal?(0))
              a >>= 8
            end
            a >>= BigInteger.attr_trailing_zero_table[x]
          else
            b -= a
            while (((x = b & 0xff)).equal?(0))
              b >>= 8
            end
            b >>= BigInteger.attr_trailing_zero_table[x]
          end
        end
        return a << t
      end
    }
    
    typesig { [MutableBigInteger] }
    # Returns the modInverse of this mod p. This and p are not affected by
    # the operation.
    def mutable_mod_inverse(p)
      # Modulus is odd, use Schroeppel's algorithm
      if (p.is_odd)
        return mod_inverse(p)
      end
      # Base and modulus are even, throw exception
      if (is_even)
        raise ArithmeticException.new("BigInteger not invertible.")
      end
      # Get even part of modulus expressed as a power of 2
      powers_of2 = p.get_lowest_set_bit
      # Construct odd part of modulus
      odd_mod = MutableBigInteger.new(p)
      odd_mod.right_shift(powers_of2)
      if (odd_mod.is_one)
        return mod_inverse_mp2(powers_of2)
      end
      # Calculate 1/a mod oddMod
      odd_part = mod_inverse(odd_mod)
      # Calculate 1/a mod evenMod
      even_part = mod_inverse_mp2(powers_of2)
      # Combine the results using Chinese Remainder Theorem
      y1 = mod_inverse_bp2(odd_mod, powers_of2)
      y2 = odd_mod.mod_inverse_mp2(powers_of2)
      temp1 = MutableBigInteger.new
      temp2 = MutableBigInteger.new
      result = MutableBigInteger.new
      odd_part.left_shift(powers_of2)
      odd_part.multiply(y1, result)
      even_part.multiply(odd_mod, temp1)
      temp1.multiply(y2, temp2)
      result.add(temp2)
      result.divide(p, temp1, temp2)
      return temp2
    end
    
    typesig { [::Java::Int] }
    # Calculate the multiplicative inverse of this mod 2^k.
    def mod_inverse_mp2(k)
      if (is_even)
        raise ArithmeticException.new("Non-invertible. (GCD != 1)")
      end
      if (k > 64)
        return euclid_mod_inverse(k)
      end
      t = inverse_mod32(@value[@offset + @int_len - 1])
      if (k < 33)
        t = ((k).equal?(32) ? t : t & ((1 << k) - 1))
        return MutableBigInteger.new(t)
      end
      p_long = (@value[@offset + @int_len - 1] & LONG_MASK)
      if (@int_len > 1)
        p_long |= (@value[@offset + @int_len - 2] << 32)
      end
      t_long = t & LONG_MASK
      t_long = t_long * (2 - p_long * t_long) # 1 more Newton iter step
      t_long = ((k).equal?(64) ? t_long : t_long & ((1 << k) - 1))
      result = MutableBigInteger.new(Array.typed(::Java::Int).new(2) { 0 })
      result.attr_value[0] = RJava.cast_to_int((t_long >> 32))
      result.attr_value[1] = RJava.cast_to_int(t_long)
      result.attr_int_len = 2
      result.normalize
      return result
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Returns the multiplicative inverse of val mod 2^32.  Assumes val is odd.
      def inverse_mod32(val)
        # Newton's iteration!
        t = val
        t *= 2 - val * t
        t *= 2 - val * t
        t *= 2 - val * t
        t *= 2 - val * t
        return t
      end
      
      typesig { [MutableBigInteger, ::Java::Int] }
      # Calculate the multiplicative inverse of 2^k mod mod, where mod is odd.
      def mod_inverse_bp2(mod, k)
        # Copy the mod to protect original
        return fixup(MutableBigInteger.new(1), MutableBigInteger.new(mod), k)
      end
    }
    
    typesig { [MutableBigInteger] }
    # Calculate the multiplicative inverse of this mod mod, where mod is odd.
    # This and mod are not changed by the calculation.
    # 
    # This method implements an algorithm due to Richard Schroeppel, that uses
    # the same intermediate representation as Montgomery Reduction
    # ("Montgomery Form").  The algorithm is described in an unpublished
    # manuscript entitled "Fast Modular Reciprocals."
    def mod_inverse(mod)
      p = MutableBigInteger.new(mod)
      f = MutableBigInteger.new(self)
      g = MutableBigInteger.new(p)
      c = SignedMutableBigInteger.new(1)
      d = SignedMutableBigInteger.new
      temp = nil
      s_temp = nil
      k = 0
      # Right shift f k times until odd, left shift d k times
      if (f.is_even)
        trailing_zeros = f.get_lowest_set_bit
        f.right_shift(trailing_zeros)
        d.left_shift(trailing_zeros)
        k = trailing_zeros
      end
      # The Almost Inverse Algorithm
      while (!f.is_one)
        # If gcd(f, g) != 1, number is not invertible modulo mod
        if (f.is_zero)
          raise ArithmeticException.new("BigInteger not invertible.")
        end
        # If f < g exchange f, g and c, d
        if (f.compare(g) < 0)
          temp = f
          f = g
          g = temp
          s_temp = d
          d = c
          c = s_temp
        end
        # If f == g (mod 4)
        if ((((f.attr_value[f.attr_offset + f.attr_int_len - 1] ^ g.attr_value[g.attr_offset + g.attr_int_len - 1]) & 3)).equal?(0))
          f.subtract(g)
          c.signed_subtract(d)
        else
          # If f != g (mod 4)
          f.add(g)
          c.signed_add(d)
        end
        # Right shift f k times until odd, left shift d k times
        trailing_zeros = f.get_lowest_set_bit
        f.right_shift(trailing_zeros)
        d.left_shift(trailing_zeros)
        k += trailing_zeros
      end
      while (c.attr_sign < 0)
        c.signed_add(p)
      end
      return fixup(c, p, k)
    end
    
    class_module.module_eval {
      typesig { [MutableBigInteger, MutableBigInteger, ::Java::Int] }
      # The Fixup Algorithm
      # Calculates X such that X = C * 2^(-k) (mod P)
      # Assumes C<P and P is odd.
      def fixup(c, p, k)
        temp = MutableBigInteger.new
        # Set r to the multiplicative inverse of p mod 2^32
        r = -inverse_mod32(p.attr_value[p.attr_offset + p.attr_int_len - 1])
        i = 0
        num_words = k >> 5
        while i < num_words
          # V = R * c (mod 2^j)
          v = r * c.attr_value[c.attr_offset + c.attr_int_len - 1]
          # c = c + (v * p)
          p.mul(v, temp)
          c.add(temp)
          # c = c / 2^j
          c.attr_int_len -= 1
          i += 1
        end
        num_bits = k & 0x1f
        if (!(num_bits).equal?(0))
          # V = R * c (mod 2^j)
          v = r * c.attr_value[c.attr_offset + c.attr_int_len - 1]
          v &= ((1 << num_bits) - 1)
          # c = c + (v * p)
          p.mul(v, temp)
          c.add(temp)
          # c = c / 2^j
          c.right_shift(num_bits)
        end
        # In theory, c may be greater than p at this point (Very rare!)
        while (c.compare(p) >= 0)
          c.subtract(p)
        end
        return c
      end
    }
    
    typesig { [::Java::Int] }
    # Uses the extended Euclidean algorithm to compute the modInverse of base
    # mod a modulus that is a power of 2. The modulus is 2^k.
    def euclid_mod_inverse(k)
      b = MutableBigInteger.new(1)
      b.left_shift(k)
      mod = MutableBigInteger.new(b)
      a = MutableBigInteger.new(self)
      q = MutableBigInteger.new
      r = MutableBigInteger.new
      b.divide(a, q, r)
      swapper = b
      b = r
      r = swapper
      t1 = MutableBigInteger.new(q)
      t0 = MutableBigInteger.new(1)
      temp = MutableBigInteger.new
      while (!b.is_one)
        a.divide(b, q, r)
        if ((r.attr_int_len).equal?(0))
          raise ArithmeticException.new("BigInteger not invertible.")
        end
        swapper = r
        r = a
        a = swapper
        if ((q.attr_int_len).equal?(1))
          t1.mul(q.attr_value[q.attr_offset], temp)
        else
          q.multiply(t1, temp)
        end
        swapper = q
        q = temp
        temp = swapper
        t0.add(q)
        if (a.is_one)
          return t0
        end
        b.divide(a, q, r)
        if ((r.attr_int_len).equal?(0))
          raise ArithmeticException.new("BigInteger not invertible.")
        end
        swapper = b
        b = r
        r = swapper
        if ((q.attr_int_len).equal?(1))
          t0.mul(q.attr_value[q.attr_offset], temp)
        else
          q.multiply(t0, temp)
        end
        swapper = q
        q = temp
        temp = swapper
        t1.add(q)
      end
      mod.subtract(t1)
      return mod
    end
    
    private
    alias_method :initialize__mutable_big_integer, :initialize
  end
  
end
