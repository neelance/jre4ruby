require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module DigitListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Math, :BigDecimal
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Math, :RoundingMode
    }
  end
  
  # Digit List. Private to DecimalFormat.
  # Handles the transcoding
  # between numeric values and strings of characters.  Only handles
  # non-negative numbers.  The division of labor between DigitList and
  # DecimalFormat is that DigitList handles the radix 10 representation
  # issues; DecimalFormat handles the locale-specific issues such as
  # positive/negative, grouping, decimal point, currency, and so on.
  # 
  # A DigitList is really a representation of a floating point value.
  # It may be an integer value; we assume that a double has sufficient
  # precision to represent all digits of a long.
  # 
  # The DigitList representation consists of a string of characters,
  # which are the digits radix 10, from '0' to '9'.  It also has a radix
  # 10 exponent associated with it.  The value represented by a DigitList
  # object can be computed by mulitplying the fraction f, where 0 <= f < 1,
  # derived by placing all the digits of the list to the right of the
  # decimal point, by 10^exponent.
  # 
  # @see  Locale
  # @see  Format
  # @see  NumberFormat
  # @see  DecimalFormat
  # @see  ChoiceFormat
  # @see  MessageFormat
  # @author       Mark Davis, Alan Liu
  class DigitList 
    include_class_members DigitListImports
    include Cloneable
    
    class_module.module_eval {
      # The maximum number of significant digits in an IEEE 754 double, that
      # is, in a Java double.  This must not be increased, or garbage digits
      # will be generated, and should not be decreased, or accuracy will be lost.
      const_set_lazy(:MAX_COUNT) { 19 }
      const_attr_reader  :MAX_COUNT
    }
    
    # == Long.toString(Long.MAX_VALUE).length()
    # 
    # These data members are intentionally public and can be set directly.
    # 
    # The value represented is given by placing the decimal point before
    # digits[decimalAt].  If decimalAt is < 0, then leading zeros between
    # the decimal point and the first nonzero digit are implied.  If decimalAt
    # is > count, then trailing zeros between the digits[count-1] and the
    # decimal point are implied.
    # 
    # Equivalently, the represented value is given by f * 10^decimalAt.  Here
    # f is a value 0.1 <= f < 1 arrived at by placing the digits in Digits to
    # the right of the decimal.
    # 
    # DigitList is normalized, so if it is non-zero, figits[0] is non-zero.  We
    # don't allow denormalized numbers because our exponent is effectively of
    # unlimited magnitude.  The count value contains the number of significant
    # digits present in digits[].
    # 
    # Zero is represented by any DigitList with count == 0 or with each digits[i]
    # for all i <= count == '0'.
    attr_accessor :decimal_at
    alias_method :attr_decimal_at, :decimal_at
    undef_method :decimal_at
    alias_method :attr_decimal_at=, :decimal_at=
    undef_method :decimal_at=
    
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    attr_accessor :digits
    alias_method :attr_digits, :digits
    undef_method :digits
    alias_method :attr_digits=, :digits=
    undef_method :digits=
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    attr_accessor :rounding_mode
    alias_method :attr_rounding_mode, :rounding_mode
    undef_method :rounding_mode
    alias_method :attr_rounding_mode=, :rounding_mode=
    undef_method :rounding_mode=
    
    attr_accessor :is_negative
    alias_method :attr_is_negative, :is_negative
    undef_method :is_negative
    alias_method :attr_is_negative=, :is_negative=
    undef_method :is_negative=
    
    typesig { [] }
    # Return true if the represented number is zero.
    def is_zero
      i = 0
      while i < @count
        if (!(@digits[i]).equal?(Character.new(?0.ord)))
          return false
        end
        (i += 1)
      end
      return true
    end
    
    typesig { [RoundingMode] }
    # Set the rounding mode
    def set_rounding_mode(r)
      @rounding_mode = r
    end
    
    typesig { [] }
    # Clears out the digits.
    # Use before appending them.
    # Typically, you set a series of digits with append, then at the point
    # you hit the decimal point, you set myDigitList.decimalAt = myDigitList.count;
    # then go on appending digits.
    def clear
      @decimal_at = 0
      @count = 0
    end
    
    typesig { [::Java::Char] }
    # Appends a digit to the list, extending the list when necessary.
    def append(digit)
      if ((@count).equal?(@digits.attr_length))
        data = CharArray.new(@count + 100)
        System.arraycopy(@digits, 0, data, 0, @count)
        @digits = data
      end
      @digits[((@count += 1) - 1)] = digit
    end
    
    typesig { [] }
    # Utility routine to get the value of the digit list
    # If (count == 0) this throws a NumberFormatException, which
    # mimics Long.parseLong().
    def get_double
      if ((@count).equal?(0))
        return 0.0
      end
      temp = get_string_buffer
      temp.append(Character.new(?..ord))
      temp.append(@digits, 0, @count)
      temp.append(Character.new(?E.ord))
      temp.append(@decimal_at)
      return Double.parse_double(temp.to_s)
    end
    
    typesig { [] }
    # Utility routine to get the value of the digit list.
    # If (count == 0) this returns 0, unlike Long.parseLong().
    def get_long
      # for now, simple implementation; later, do proper IEEE native stuff
      if ((@count).equal?(0))
        return 0
      end
      # We have to check for this, because this is the one NEGATIVE value
      # we represent.  If we tried to just pass the digits off to parseLong,
      # we'd get a parse failure.
      if (is_long_min_value)
        return Long::MIN_VALUE
      end
      temp = get_string_buffer
      temp.append(@digits, 0, @count)
      i = @count
      while i < @decimal_at
        temp.append(Character.new(?0.ord))
        (i += 1)
      end
      return Long.parse_long(temp.to_s)
    end
    
    typesig { [] }
    def get_big_decimal
      if ((@count).equal?(0))
        if ((@decimal_at).equal?(0))
          return BigDecimal::ZERO
        else
          return BigDecimal.new("0E" + RJava.cast_to_string(@decimal_at))
        end
      end
      if ((@decimal_at).equal?(@count))
        return BigDecimal.new(@digits, 0, @count)
      else
        return BigDecimal.new(@digits, 0, @count).scale_by_power_of_ten(@decimal_at - @count)
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Return true if the number represented by this object can fit into
    # a long.
    # @param isPositive true if this number should be regarded as positive
    # @param ignoreNegativeZero true if -0 should be regarded as identical to
    # +0; otherwise they are considered distinct
    # @return true if this number fits into a Java long
    def fits_into_long(is_positive, ignore_negative_zero)
      # Figure out if the result will fit in a long.  We have to
      # first look for nonzero digits after the decimal point;
      # then check the size.  If the digit count is 18 or less, then
      # the value can definitely be represented as a long.  If it is 19
      # then it may be too large.
      # Trim trailing zeros.  This does not change the represented value.
      while (@count > 0 && (@digits[@count - 1]).equal?(Character.new(?0.ord)))
        (@count -= 1)
      end
      if ((@count).equal?(0))
        # Positive zero fits into a long, but negative zero can only
        # be represented as a double. - bug 4162852
        return is_positive || ignore_negative_zero
      end
      if (@decimal_at < @count || @decimal_at > MAX_COUNT)
        return false
      end
      if (@decimal_at < MAX_COUNT)
        return true
      end
      # At this point we have decimalAt == count, and count == MAX_COUNT.
      # The number will overflow if it is larger than 9223372036854775807
      # or smaller than -9223372036854775808.
      i = 0
      while i < @count
        dig = @digits[i]
        max = LONG_MIN_REP[i]
        if (dig > max)
          return false
        end
        if (dig < max)
          return true
        end
        (i += 1)
      end
      # At this point the first count digits match.  If decimalAt is less
      # than count, then the remaining digits are zero, and we return true.
      if (@count < @decimal_at)
        return true
      end
      # Now we have a representation of Long.MIN_VALUE, without the leading
      # negative sign.  If this represents a positive value, then it does
      # not fit; otherwise it fits.
      return !is_positive
    end
    
    typesig { [::Java::Boolean, ::Java::Double, ::Java::Int] }
    # Set the digit list to a representation of the given double value.
    # This method supports fixed-point notation.
    # @param isNegative Boolean value indicating whether the number is negative.
    # @param source Value to be converted; must not be Inf, -Inf, Nan,
    # or a value <= 0.
    # @param maximumFractionDigits The most fractional digits which should
    # be converted.
    def set(is_negative, source, maximum_fraction_digits)
      set(is_negative, source, maximum_fraction_digits, true)
    end
    
    typesig { [::Java::Boolean, ::Java::Double, ::Java::Int, ::Java::Boolean] }
    # Set the digit list to a representation of the given double value.
    # This method supports both fixed-point and exponential notation.
    # @param isNegative Boolean value indicating whether the number is negative.
    # @param source Value to be converted; must not be Inf, -Inf, Nan,
    # or a value <= 0.
    # @param maximumDigits The most fractional or total digits which should
    # be converted.
    # @param fixedPoint If true, then maximumDigits is the maximum
    # fractional digits to be converted.  If false, total digits.
    def set(is_negative, source, maximum_digits, fixed_point)
      set(is_negative, Double.to_s(source), maximum_digits, fixed_point)
    end
    
    typesig { [::Java::Boolean, String, ::Java::Int, ::Java::Boolean] }
    # Generate a representation of the form DDDDD, DDDDD.DDDDD, or
    # DDDDDE+/-DDDDD.
    def set(is_negative, s, maximum_digits, fixed_point)
      @is_negative = is_negative
      len = s.length
      source = get_data_chars(len)
      s.get_chars(0, len, source, 0)
      @decimal_at = -1
      @count = 0
      exponent = 0
      # Number of zeros between decimal point and first non-zero digit after
      # decimal point, for numbers < 1.
      leading_zeros_after_decimal = 0
      non_zero_digit_seen = false
      i = 0
      while i < len
        c = source[((i += 1) - 1)]
        if ((c).equal?(Character.new(?..ord)))
          @decimal_at = @count
        else
          if ((c).equal?(Character.new(?e.ord)) || (c).equal?(Character.new(?E.ord)))
            exponent = parse_int(source, i, len)
            break
          else
            if (!non_zero_digit_seen)
              non_zero_digit_seen = (!(c).equal?(Character.new(?0.ord)))
              if (!non_zero_digit_seen && !(@decimal_at).equal?(-1))
                (leading_zeros_after_decimal += 1)
              end
            end
            if (non_zero_digit_seen)
              @digits[((@count += 1) - 1)] = c
            end
          end
        end
      end
      if ((@decimal_at).equal?(-1))
        @decimal_at = @count
      end
      if (non_zero_digit_seen)
        @decimal_at += exponent - leading_zeros_after_decimal
      end
      if (fixed_point)
        # The negative of the exponent represents the number of leading
        # zeros between the decimal and the first non-zero digit, for
        # a value < 0.1 (e.g., for 0.00123, -decimalAt == 2).  If this
        # is more than the maximum fraction digits, then we have an underflow
        # for the printed representation.
        if (-@decimal_at > maximum_digits)
          # Handle an underflow to zero when we round something like
          # 0.0009 to 2 fractional digits.
          @count = 0
          return
        else
          if ((-@decimal_at).equal?(maximum_digits))
            # If we round 0.0009 to 3 fractional digits, then we have to
            # create a new one digit in the least significant location.
            if (should_round_up(0))
              @count = 1
              (@decimal_at += 1)
              @digits[0] = Character.new(?1.ord)
            else
              @count = 0
            end
            return
          end
        end
        # else fall through
      end
      # Eliminate trailing zeros.
      while (@count > 1 && (@digits[@count - 1]).equal?(Character.new(?0.ord)))
        (@count -= 1)
      end
      # Eliminate digits beyond maximum digits to be displayed.
      # Round up if appropriate.
      round(fixed_point ? (maximum_digits + @decimal_at) : maximum_digits)
    end
    
    typesig { [::Java::Int] }
    # Round the representation to the given number of digits.
    # @param maximumDigits The maximum number of digits to be shown.
    # Upon return, count will be less than or equal to maximumDigits.
    def round(maximum_digits)
      # Eliminate digits beyond maximum digits to be displayed.
      # Round up if appropriate.
      if (maximum_digits >= 0 && maximum_digits < @count)
        if (should_round_up(maximum_digits))
          # Rounding up involved incrementing digits from LSD to MSD.
          # In most cases this is simple, but in a worst case situation
          # (9999..99) we have to adjust the decimalAt value.
          loop do
            (maximum_digits -= 1)
            if (maximum_digits < 0)
              # We have all 9's, so we increment to a single digit
              # of one and adjust the exponent.
              @digits[0] = Character.new(?1.ord)
              (@decimal_at += 1)
              maximum_digits = 0 # Adjust the count
              break
            end
            (@digits[maximum_digits] += 1)
            if (@digits[maximum_digits] <= Character.new(?9.ord))
              break
            end
          end
          (maximum_digits += 1) # Increment for use as count
        end
        @count = maximum_digits
        # Eliminate trailing zeros.
        while (@count > 1 && (@digits[@count - 1]).equal?(Character.new(?0.ord)))
          (@count -= 1)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Return true if truncating the representation to the given number
    # of digits will result in an increment to the last digit.  This
    # method implements the rounding modes defined in the
    # java.math.RoundingMode class.
    # [bnf]
    # @param maximumDigits the number of digits to keep, from 0 to
    # <code>count-1</code>.  If 0, then all digits are rounded away, and
    # this method returns true if a one should be generated (e.g., formatting
    # 0.09 with "#.#").
    # @exception ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @return true if digit <code>maximumDigits-1</code> should be
    # incremented
    def should_round_up(maximum_digits)
      if (maximum_digits < @count)
        case (@rounding_mode)
        when UP
          i = maximum_digits
          while i < @count
            if (!(@digits[i]).equal?(Character.new(?0.ord)))
              return true
            end
            (i += 1)
          end
        when DOWN
        when CEILING
          i = maximum_digits
          while i < @count
            if (!(@digits[i]).equal?(Character.new(?0.ord)))
              return !@is_negative
            end
            (i += 1)
          end
        when FLOOR
          i = maximum_digits
          while i < @count
            if (!(@digits[i]).equal?(Character.new(?0.ord)))
              return @is_negative
            end
            (i += 1)
          end
        when HALF_UP
          if (@digits[maximum_digits] >= Character.new(?5.ord))
            return true
          end
        when HALF_DOWN
          if (@digits[maximum_digits] > Character.new(?5.ord))
            return true
          else
            if ((@digits[maximum_digits]).equal?(Character.new(?5.ord)))
              i = maximum_digits + 1
              while i < @count
                if (!(@digits[i]).equal?(Character.new(?0.ord)))
                  return true
                end
                (i += 1)
              end
            end
          end
        when HALF_EVEN
          # Implement IEEE half-even rounding
          if (@digits[maximum_digits] > Character.new(?5.ord))
            return true
          else
            if ((@digits[maximum_digits]).equal?(Character.new(?5.ord)))
              i = maximum_digits + 1
              while i < @count
                if (!(@digits[i]).equal?(Character.new(?0.ord)))
                  return true
                end
                (i += 1)
              end
              return maximum_digits > 0 && (!(@digits[maximum_digits - 1] % 2).equal?(0))
            end
          end
        when UNNECESSARY
          i = maximum_digits
          while i < @count
            if (!(@digits[i]).equal?(Character.new(?0.ord)))
              raise ArithmeticException.new("Rounding needed with the rounding mode being set to RoundingMode.UNNECESSARY")
            end
            (i += 1)
          end
        else
          raise AssertError if not (false)
        end
      end
      return false
    end
    
    typesig { [::Java::Boolean, ::Java::Long] }
    # Utility routine to set the value of the digit list from a long
    def set(is_negative, source)
      set(is_negative, source, 0)
    end
    
    typesig { [::Java::Boolean, ::Java::Long, ::Java::Int] }
    # Set the digit list to a representation of the given long value.
    # @param isNegative Boolean value indicating whether the number is negative.
    # @param source Value to be converted; must be >= 0 or ==
    # Long.MIN_VALUE.
    # @param maximumDigits The most digits which should be converted.
    # If maximumDigits is lower than the number of significant digits
    # in source, the representation will be rounded.  Ignored if <= 0.
    def set(is_negative, source, maximum_digits)
      @is_negative = is_negative
      # This method does not expect a negative number. However,
      # "source" can be a Long.MIN_VALUE (-9223372036854775808),
      # if the number being formatted is a Long.MIN_VALUE.  In that
      # case, it will be formatted as -Long.MIN_VALUE, a number
      # which is outside the legal range of a long, but which can
      # be represented by DigitList.
      if (source <= 0)
        if ((source).equal?(Long::MIN_VALUE))
          @decimal_at = @count = MAX_COUNT
          System.arraycopy(LONG_MIN_REP, 0, @digits, 0, @count)
        else
          @decimal_at = @count = 0 # Values <= 0 format as zero
        end
      else
        # Rewritten to improve performance.  I used to call
        # Long.toString(), which was about 4x slower than this code.
        left = MAX_COUNT
        right = 0
        while (source > 0)
          @digits[(left -= 1)] = RJava.cast_to_char((Character.new(?0.ord) + (source % 10)))
          source /= 10
        end
        @decimal_at = MAX_COUNT - left
        # Don't copy trailing zeros.  We are guaranteed that there is at
        # least one non-zero digit, so we don't have to check lower bounds.
        right = MAX_COUNT - 1
        while (@digits[right]).equal?(Character.new(?0.ord))
          (right -= 1)
        end
        @count = right - left + 1
        System.arraycopy(@digits, left, @digits, 0, @count)
      end
      if (maximum_digits > 0)
        round(maximum_digits)
      end
    end
    
    typesig { [::Java::Boolean, BigDecimal, ::Java::Int, ::Java::Boolean] }
    # Set the digit list to a representation of the given BigDecimal value.
    # This method supports both fixed-point and exponential notation.
    # @param isNegative Boolean value indicating whether the number is negative.
    # @param source Value to be converted; must not be a value <= 0.
    # @param maximumDigits The most fractional or total digits which should
    # be converted.
    # @param fixedPoint If true, then maximumDigits is the maximum
    # fractional digits to be converted.  If false, total digits.
    def set(is_negative, source, maximum_digits, fixed_point)
      s = source.to_s
      extend_digits(s.length)
      set(is_negative, s, maximum_digits, fixed_point)
    end
    
    typesig { [::Java::Boolean, BigInteger, ::Java::Int] }
    # Set the digit list to a representation of the given BigInteger value.
    # @param isNegative Boolean value indicating whether the number is negative.
    # @param source Value to be converted; must be >= 0.
    # @param maximumDigits The most digits which should be converted.
    # If maximumDigits is lower than the number of significant digits
    # in source, the representation will be rounded.  Ignored if <= 0.
    def set(is_negative, source, maximum_digits)
      @is_negative = is_negative
      s = source.to_s
      len = s.length
      extend_digits(len)
      s.get_chars(0, len, @digits, 0)
      @decimal_at = len
      right = 0
      right = len - 1
      while right >= 0 && (@digits[right]).equal?(Character.new(?0.ord))
        (right -= 1)
      end
      @count = right + 1
      if (maximum_digits > 0)
        round(maximum_digits)
      end
    end
    
    typesig { [Object] }
    # equality test between two digit lists.
    def ==(obj)
      if ((self).equal?(obj))
        # quick check
        return true
      end
      if (!(obj.is_a?(DigitList)))
        # (1) same object?
        return false
      end
      other = obj
      if (!(@count).equal?(other.attr_count) || !(@decimal_at).equal?(other.attr_decimal_at))
        return false
      end
      i = 0
      while i < @count
        if (!(@digits[i]).equal?(other.attr_digits[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Generates the hash code for the digit list.
    def hash_code
      hashcode = @decimal_at
      i = 0
      while i < @count
        hashcode = hashcode * 37 + @digits[i]
        i += 1
      end
      return hashcode
    end
    
    typesig { [] }
    # Creates a copy of this object.
    # @return a clone of this instance.
    def clone
      begin
        other = super
        new_digits = CharArray.new(@digits.attr_length)
        System.arraycopy(@digits, 0, new_digits, 0, @digits.attr_length)
        other.attr_digits = new_digits
        other.attr_temp_buffer = nil
        return other
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # Returns true if this DigitList represents Long.MIN_VALUE;
    # false, otherwise.  This is required so that getLong() works.
    def is_long_min_value
      if (!(@decimal_at).equal?(@count) || !(@count).equal?(MAX_COUNT))
        return false
      end
      i = 0
      while i < @count
        if (!(@digits[i]).equal?(LONG_MIN_REP[i]))
          return false
        end
        (i += 1)
      end
      return true
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def parse_int(str, offset, str_len)
        c = 0
        positive = true
        if (((c = str[offset])).equal?(Character.new(?-.ord)))
          positive = false
          offset += 1
        else
          if ((c).equal?(Character.new(?+.ord)))
            offset += 1
          end
        end
        value = 0
        while (offset < str_len)
          c = str[((offset += 1) - 1)]
          if (c >= Character.new(?0.ord) && c <= Character.new(?9.ord))
            value = value * 10 + (c - Character.new(?0.ord))
          else
            break
          end
        end
        return positive ? value : -value
      end
      
      # The digit part of -9223372036854775808L
      const_set_lazy(:LONG_MIN_REP) { "9223372036854775808".to_char_array }
      const_attr_reader  :LONG_MIN_REP
    }
    
    typesig { [] }
    def to_s
      if (is_zero)
        return "0"
      end
      buf = get_string_buffer
      buf.append("0.")
      buf.append(@digits, 0, @count)
      buf.append("x10^")
      buf.append(@decimal_at)
      return buf.to_s
    end
    
    attr_accessor :temp_buffer
    alias_method :attr_temp_buffer, :temp_buffer
    undef_method :temp_buffer
    alias_method :attr_temp_buffer=, :temp_buffer=
    undef_method :temp_buffer=
    
    typesig { [] }
    def get_string_buffer
      if ((@temp_buffer).nil?)
        @temp_buffer = StringBuffer.new(MAX_COUNT)
      else
        @temp_buffer.set_length(0)
      end
      return @temp_buffer
    end
    
    typesig { [::Java::Int] }
    def extend_digits(len)
      if (len > @digits.attr_length)
        @digits = CharArray.new(len)
      end
    end
    
    typesig { [::Java::Int] }
    def get_data_chars(length_)
      if ((@data).nil? || @data.attr_length < length_)
        @data = CharArray.new(length_)
      end
      return @data
    end
    
    typesig { [] }
    def initialize
      @decimal_at = 0
      @count = 0
      @digits = CharArray.new(MAX_COUNT)
      @data = nil
      @rounding_mode = RoundingMode::HALF_EVEN
      @is_negative = false
      @temp_buffer = nil
    end
    
    private
    alias_method :initialize__digit_list, :initialize
  end
  
end
