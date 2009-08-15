require "rjava"

# Portions Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# Portions Copyright (c) 1995  Colin Plumb.  All rights reserved.
module Java::Math
  module BigIntegerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Math
      include_const ::Java::Util, :Random
      include ::Java::Io
    }
  end
  
  # Immutable arbitrary-precision integers.  All operations behave as if
  # BigIntegers were represented in two's-complement notation (like Java's
  # primitive integer types).  BigInteger provides analogues to all of Java's
  # primitive integer operators, and all relevant methods from java.lang.Math.
  # Additionally, BigInteger provides operations for modular arithmetic, GCD
  # calculation, primality testing, prime generation, bit manipulation,
  # and a few other miscellaneous operations.
  # 
  # <p>Semantics of arithmetic operations exactly mimic those of Java's integer
  # arithmetic operators, as defined in <i>The Java Language Specification</i>.
  # For example, division by zero throws an {@code ArithmeticException}, and
  # division of a negative by a positive yields a negative (or zero) remainder.
  # All of the details in the Spec concerning overflow are ignored, as
  # BigIntegers are made as large as necessary to accommodate the results of an
  # operation.
  # 
  # <p>Semantics of shift operations extend those of Java's shift operators
  # to allow for negative shift distances.  A right-shift with a negative
  # shift distance results in a left shift, and vice-versa.  The unsigned
  # right shift operator ({@code >>>}) is omitted, as this operation makes
  # little sense in combination with the "infinite word size" abstraction
  # provided by this class.
  # 
  # <p>Semantics of bitwise logical operations exactly mimic those of Java's
  # bitwise integer operators.  The binary operators ({@code and},
  # {@code or}, {@code xor}) implicitly perform sign extension on the shorter
  # of the two operands prior to performing the operation.
  # 
  # <p>Comparison operations perform signed integer comparisons, analogous to
  # those performed by Java's relational and equality operators.
  # 
  # <p>Modular arithmetic operations are provided to compute residues, perform
  # exponentiation, and compute multiplicative inverses.  These methods always
  # return a non-negative result, between {@code 0} and {@code (modulus - 1)},
  # inclusive.
  # 
  # <p>Bit operations operate on a single bit of the two's-complement
  # representation of their operand.  If necessary, the operand is sign-
  # extended so that it contains the designated bit.  None of the single-bit
  # operations can produce a BigInteger with a different sign from the
  # BigInteger being operated on, as they affect only a single bit, and the
  # "infinite word size" abstraction provided by this class ensures that there
  # are infinitely many "virtual sign bits" preceding each BigInteger.
  # 
  # <p>For the sake of brevity and clarity, pseudo-code is used throughout the
  # descriptions of BigInteger methods.  The pseudo-code expression
  # {@code (i + j)} is shorthand for "a BigInteger whose value is
  # that of the BigInteger {@code i} plus that of the BigInteger {@code j}."
  # The pseudo-code expression {@code (i == j)} is shorthand for
  # "{@code true} if and only if the BigInteger {@code i} represents the same
  # value as the BigInteger {@code j}."  Other pseudo-code expressions are
  # interpreted similarly.
  # 
  # <p>All methods and constructors in this class throw
  # {@code NullPointerException} when passed
  # a null object reference for any input parameter.
  # 
  # @see     BigDecimal
  # @author  Josh Bloch
  # @author  Michael McCloskey
  # @since JDK1.1
  class BigInteger < BigIntegerImports.const_get :Numeric
    include_class_members BigIntegerImports
    overload_protected {
      include JavaComparable
    }
    
    # The signum of this BigInteger: -1 for negative, 0 for zero, or
    # 1 for positive.  Note that the BigInteger zero <i>must</i> have
    # a signum of 0.  This is necessary to ensures that there is exactly one
    # representation for each BigInteger value.
    # 
    # @serial
    attr_accessor :signum
    alias_method :attr_signum, :signum
    undef_method :signum
    alias_method :attr_signum=, :signum=
    undef_method :signum=
    
    # The magnitude of this BigInteger, in <i>big-endian</i> order: the
    # zeroth element of this array is the most-significant int of the
    # magnitude.  The magnitude must be "minimal" in that the most-significant
    # int ({@code mag[0]}) must be non-zero.  This is necessary to
    # ensure that there is exactly one representation for each BigInteger
    # value.  Note that this implies that the BigInteger zero has a
    # zero-length mag array.
    attr_accessor :mag
    alias_method :attr_mag, :mag
    undef_method :mag
    alias_method :attr_mag=, :mag=
    undef_method :mag=
    
    # These "redundant fields" are initialized with recognizable nonsense
    # values, and cached the first time they are needed (or never, if they
    # aren't needed).
    # 
    # The bitCount of this BigInteger, as returned by bitCount(), or -1
    # (either value is acceptable).
    # 
    # @serial
    # @see #bitCount
    attr_accessor :bit_count
    alias_method :attr_bit_count, :bit_count
    undef_method :bit_count
    alias_method :attr_bit_count=, :bit_count=
    undef_method :bit_count=
    
    # The bitLength of this BigInteger, as returned by bitLength(), or -1
    # (either value is acceptable).
    # 
    # @serial
    # @see #bitLength()
    attr_accessor :bit_length
    alias_method :attr_bit_length, :bit_length
    undef_method :bit_length
    alias_method :attr_bit_length=, :bit_length=
    undef_method :bit_length=
    
    # The lowest set bit of this BigInteger, as returned by getLowestSetBit(),
    # or -2 (either value is acceptable).
    # 
    # @serial
    # @see #getLowestSetBit
    attr_accessor :lowest_set_bit
    alias_method :attr_lowest_set_bit, :lowest_set_bit
    undef_method :lowest_set_bit
    alias_method :attr_lowest_set_bit=, :lowest_set_bit=
    undef_method :lowest_set_bit=
    
    # The index of the lowest-order byte in the magnitude of this BigInteger
    # that contains a nonzero byte, or -2 (either value is acceptable).  The
    # least significant byte has int-number 0, the next byte in order of
    # increasing significance has byte-number 1, and so forth.
    # 
    # @serial
    attr_accessor :first_nonzero_byte_num
    alias_method :attr_first_nonzero_byte_num, :first_nonzero_byte_num
    undef_method :first_nonzero_byte_num
    alias_method :attr_first_nonzero_byte_num=, :first_nonzero_byte_num=
    undef_method :first_nonzero_byte_num=
    
    # The index of the lowest-order int in the magnitude of this BigInteger
    # that contains a nonzero int, or -2 (either value is acceptable).  The
    # least significant int has int-number 0, the next int in order of
    # increasing significance has int-number 1, and so forth.
    attr_accessor :first_nonzero_int_num
    alias_method :attr_first_nonzero_int_num, :first_nonzero_int_num
    undef_method :first_nonzero_int_num
    alias_method :attr_first_nonzero_int_num=, :first_nonzero_int_num=
    undef_method :first_nonzero_int_num=
    
    class_module.module_eval {
      # This mask is used to obtain the value of an int as if it were unsigned.
      const_set_lazy(:LONG_MASK) { 0xffffffff }
      const_attr_reader  :LONG_MASK
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructors
    # 
    # Translates a byte array containing the two's-complement binary
    # representation of a BigInteger into a BigInteger.  The input array is
    # assumed to be in <i>big-endian</i> byte-order: the most significant
    # byte is in the zeroth element.
    # 
    # @param  val big-endian two's-complement binary representation of
    # BigInteger.
    # @throws NumberFormatException {@code val} is zero bytes long.
    def initialize(val)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      if ((val.attr_length).equal?(0))
        raise NumberFormatException.new("Zero length BigInteger")
      end
      if (val[0] < 0)
        @mag = make_positive(val)
        @signum = -1
      else
        @mag = strip_leading_zero_bytes(val)
        @signum = ((@mag.attr_length).equal?(0) ? 0 : 1)
      end
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # This private constructor translates an int array containing the
    # two's-complement binary representation of a BigInteger into a
    # BigInteger. The input array is assumed to be in <i>big-endian</i>
    # int-order: the most significant int is in the zeroth element.
    def initialize(val)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      if ((val.attr_length).equal?(0))
        raise NumberFormatException.new("Zero length BigInteger")
      end
      if (val[0] < 0)
        @mag = make_positive(val)
        @signum = -1
      else
        @mag = trusted_strip_leading_zero_ints(val)
        @signum = ((@mag.attr_length).equal?(0) ? 0 : 1)
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Translates the sign-magnitude representation of a BigInteger into a
    # BigInteger.  The sign is represented as an integer signum value: -1 for
    # negative, 0 for zero, or 1 for positive.  The magnitude is a byte array
    # in <i>big-endian</i> byte-order: the most significant byte is in the
    # zeroth element.  A zero-length magnitude array is permissible, and will
    # result in a BigInteger value of 0, whether signum is -1, 0 or 1.
    # 
    # @param  signum signum of the number (-1 for negative, 0 for zero, 1
    # for positive).
    # @param  magnitude big-endian binary representation of the magnitude of
    # the number.
    # @throws NumberFormatException {@code signum} is not one of the three
    # legal values (-1, 0, and 1), or {@code signum} is 0 and
    # {@code magnitude} contains one or more non-zero bytes.
    def initialize(signum, magnitude)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      @mag = strip_leading_zero_bytes(magnitude)
      if (signum < -1 || signum > 1)
        raise (NumberFormatException.new("Invalid signum value"))
      end
      if ((@mag.attr_length).equal?(0))
        @signum = 0
      else
        if ((signum).equal?(0))
          raise (NumberFormatException.new("signum-magnitude mismatch"))
        end
        @signum = signum
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Int)] }
    # A constructor for internal use that translates the sign-magnitude
    # representation of a BigInteger into a BigInteger. It checks the
    # arguments and copies the magnitude so this constructor would be
    # safe for external use.
    def initialize(signum, magnitude)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      @mag = strip_leading_zero_ints(magnitude)
      if (signum < -1 || signum > 1)
        raise (NumberFormatException.new("Invalid signum value"))
      end
      if ((@mag.attr_length).equal?(0))
        @signum = 0
      else
        if ((signum).equal?(0))
          raise (NumberFormatException.new("signum-magnitude mismatch"))
        end
        @signum = signum
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Translates the String representation of a BigInteger in the
    # specified radix into a BigInteger.  The String representation
    # consists of an optional minus followed by a sequence of one or
    # more digits in the specified radix.  The character-to-digit
    # mapping is provided by {@code Character.digit}.  The String may
    # not contain any extraneous characters (whitespace, for
    # example).
    # 
    # @param val String representation of BigInteger.
    # @param radix radix to be used in interpreting {@code val}.
    # @throws NumberFormatException {@code val} is not a valid representation
    # of a BigInteger in the specified radix, or {@code radix} is
    # outside the range from {@link Character#MIN_RADIX} to
    # {@link Character#MAX_RADIX}, inclusive.
    # @see    Character#digit
    def initialize(val, radix)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      cursor = 0
      num_digits = 0
      len = val.length
      if (radix < Character::MIN_RADIX || radix > Character::MAX_RADIX)
        raise NumberFormatException.new("Radix out of range")
      end
      if ((val.length).equal?(0))
        raise NumberFormatException.new("Zero length BigInteger")
      end
      # Check for at most one leading sign
      @signum = 1
      index = val.last_index_of(Character.new(?-.ord))
      if (!(index).equal?(-1))
        if ((index).equal?(0))
          if ((val.length).equal?(1))
            raise NumberFormatException.new("Zero length BigInteger")
          end
          @signum = -1
          cursor = 1
        else
          raise NumberFormatException.new("Illegal embedded sign character")
        end
      end
      # Skip leading zeros and compute number of digits in magnitude
      while (cursor < len && (Character.digit(val.char_at(cursor), radix)).equal?(0))
        cursor += 1
      end
      if ((cursor).equal?(len))
        @signum = 0
        @mag = ZERO.attr_mag
        return
      else
        num_digits = len - cursor
      end
      # Pre-allocate array of expected size. May be too large but can
      # never be too small. Typically exact.
      num_bits = RJava.cast_to_int((((num_digits * self.attr_bits_per_digit[radix]) >> 10) + 1))
      num_words = (num_bits + 31) / 32
      @mag = Array.typed(::Java::Int).new(num_words) { 0 }
      # Process first (potentially short) digit group
      first_group_len = num_digits % self.attr_digits_per_int[radix]
      if ((first_group_len).equal?(0))
        first_group_len = self.attr_digits_per_int[radix]
      end
      group = val.substring(cursor, cursor += first_group_len)
      @mag[@mag.attr_length - 1] = JavaInteger.parse_int(group, radix)
      if (@mag[@mag.attr_length - 1] < 0)
        raise NumberFormatException.new("Illegal digit")
      end
      # Process remaining digit groups
      super_radix = self.attr_int_radix[radix]
      group_val = 0
      while (cursor < val.length)
        group = RJava.cast_to_string(val.substring(cursor, cursor += self.attr_digits_per_int[radix]))
        group_val = JavaInteger.parse_int(group, radix)
        if (group_val < 0)
          raise NumberFormatException.new("Illegal digit")
        end
        destructive_mul_add(@mag, super_radix, group_val)
      end
      # Required for cases where the array was overallocated.
      @mag = trusted_strip_leading_zero_ints(@mag)
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Constructs a new BigInteger using a char array with radix=10
    def initialize(val)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      cursor = 0
      num_digits = 0
      len = val.attr_length
      # Check for leading minus sign
      @signum = 1
      if ((val[0]).equal?(Character.new(?-.ord)))
        if ((len).equal?(1))
          raise NumberFormatException.new("Zero length BigInteger")
        end
        @signum = -1
        cursor = 1
      end
      # Skip leading zeros and compute number of digits in magnitude
      while (cursor < len && (Character.digit(val[cursor], 10)).equal?(0))
        cursor += 1
      end
      if ((cursor).equal?(len))
        @signum = 0
        @mag = ZERO.attr_mag
        return
      else
        num_digits = len - cursor
      end
      # Pre-allocate array of expected size
      num_words = 0
      if (len < 10)
        num_words = 1
      else
        num_bits = RJava.cast_to_int((((num_digits * self.attr_bits_per_digit[10]) >> 10) + 1))
        num_words = (num_bits + 31) / 32
      end
      @mag = Array.typed(::Java::Int).new(num_words) { 0 }
      # Process first (potentially short) digit group
      first_group_len = num_digits % self.attr_digits_per_int[10]
      if ((first_group_len).equal?(0))
        first_group_len = self.attr_digits_per_int[10]
      end
      @mag[@mag.attr_length - 1] = parse_int(val, cursor, cursor += first_group_len)
      # Process remaining digit groups
      while (cursor < len)
        group_val = parse_int(val, cursor, cursor += self.attr_digits_per_int[10])
        destructive_mul_add(@mag, self.attr_int_radix[10], group_val)
      end
      @mag = trusted_strip_leading_zero_ints(@mag)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Create an integer with the digits between the two indexes
    # Assumes start < end. The result may be negative, but it
    # is to be treated as an unsigned value.
    def parse_int(source, start, end_)
      result = Character.digit(source[((start += 1) - 1)], 10)
      if ((result).equal?(-1))
        raise NumberFormatException.new(String.new(source))
      end
      index = start
      while index < end_
        next_val = Character.digit(source[index], 10)
        if ((next_val).equal?(-1))
          raise NumberFormatException.new(String.new(source))
        end
        result = 10 * result + next_val
        index += 1
      end
      return result
    end
    
    class_module.module_eval {
      # bitsPerDigit in the given radix times 1024
      # Rounded up to avoid underallocation.
      
      def bits_per_digit
        defined?(@@bits_per_digit) ? @@bits_per_digit : @@bits_per_digit= Array.typed(::Java::Long).new([0, 0, 1024, 1624, 2048, 2378, 2648, 2875, 3072, 3247, 3402, 3543, 3672, 3790, 3899, 4001, 4096, 4186, 4271, 4350, 4426, 4498, 4567, 4633, 4696, 4756, 4814, 4870, 4923, 4975, 5025, 5074, 5120, 5166, 5210, 5253, 5295])
      end
      alias_method :attr_bits_per_digit, :bits_per_digit
      
      def bits_per_digit=(value)
        @@bits_per_digit = value
      end
      alias_method :attr_bits_per_digit=, :bits_per_digit=
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # Multiply x array times word y in place, and add word z
      def destructive_mul_add(x, y, z)
        # Perform the multiplication word by word
        ylong = y & LONG_MASK
        zlong = z & LONG_MASK
        len = x.attr_length
        product = 0
        carry = 0
        i = len - 1
        while i >= 0
          product = ylong * (x[i] & LONG_MASK) + carry
          x[i] = RJava.cast_to_int(product)
          carry = product >> 32
          i -= 1
        end
        # Perform the addition
        sum = (x[len - 1] & LONG_MASK) + zlong
        x[len - 1] = RJava.cast_to_int(sum)
        carry = sum >> 32
        i_ = len - 2
        while i_ >= 0
          sum = (x[i_] & LONG_MASK) + carry
          x[i_] = RJava.cast_to_int(sum)
          carry = sum >> 32
          i_ -= 1
        end
      end
    }
    
    typesig { [String] }
    # Translates the decimal String representation of a BigInteger into a
    # BigInteger.  The String representation consists of an optional minus
    # sign followed by a sequence of one or more decimal digits.  The
    # character-to-digit mapping is provided by {@code Character.digit}.
    # The String may not contain any extraneous characters (whitespace, for
    # example).
    # 
    # @param val decimal String representation of BigInteger.
    # @throws NumberFormatException {@code val} is not a valid representation
    # of a BigInteger.
    # @see    Character#digit
    def initialize(val)
      initialize__big_integer(val, 10)
    end
    
    typesig { [::Java::Int, Random] }
    # Constructs a randomly generated BigInteger, uniformly distributed over
    # the range {@code 0} to (2<sup>{@code numBits}</sup> - 1), inclusive.
    # The uniformity of the distribution assumes that a fair source of random
    # bits is provided in {@code rnd}.  Note that this constructor always
    # constructs a non-negative BigInteger.
    # 
    # @param  numBits maximum bitLength of the new BigInteger.
    # @param  rnd source of randomness to be used in computing the new
    # BigInteger.
    # @throws IllegalArgumentException {@code numBits} is negative.
    # @see #bitLength()
    def initialize(num_bits, rnd)
      initialize__big_integer(1, random_bits(num_bits, rnd))
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Random] }
      def random_bits(num_bits, rnd)
        if (num_bits < 0)
          raise IllegalArgumentException.new("numBits must be non-negative")
        end
        num_bytes = RJava.cast_to_int(((num_bits + 7) / 8)) # avoid overflow
        random_bits_ = Array.typed(::Java::Byte).new(num_bytes) { 0 }
        # Generate random bytes and mask out any excess bits
        if (num_bytes > 0)
          rnd.next_bytes(random_bits_)
          excess_bits = 8 * num_bytes - num_bits
          random_bits_[0] &= (1 << (8 - excess_bits)) - 1
        end
        return random_bits_
      end
    }
    
    typesig { [::Java::Int, ::Java::Int, Random] }
    # Constructs a randomly generated positive BigInteger that is probably
    # prime, with the specified bitLength.
    # 
    # <p>It is recommended that the {@link #probablePrime probablePrime}
    # method be used in preference to this constructor unless there
    # is a compelling need to specify a certainty.
    # 
    # @param  bitLength bitLength of the returned BigInteger.
    # @param  certainty a measure of the uncertainty that the caller is
    # willing to tolerate.  The probability that the new BigInteger
    # represents a prime number will exceed
    # (1 - 1/2<sup>{@code certainty}</sup>).  The execution time of
    # this constructor is proportional to the value of this parameter.
    # @param  rnd source of random bits used to select candidates to be
    # tested for primality.
    # @throws ArithmeticException {@code bitLength < 2}.
    # @see    #bitLength()
    def initialize(bit_length, certainty, rnd)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      prime = nil
      if (bit_length < 2)
        raise ArithmeticException.new("bitLength < 2")
      end
      # The cutoff of 95 was chosen empirically for best performance
      prime = (bit_length < 95 ? small_prime(bit_length, certainty, rnd) : large_prime(bit_length, certainty, rnd))
      @signum = 1
      @mag = prime.attr_mag
    end
    
    class_module.module_eval {
      # Minimum size in bits that the requested prime number has
      # before we use the large prime number generating algorithms
      const_set_lazy(:SMALL_PRIME_THRESHOLD) { 95 }
      const_attr_reader  :SMALL_PRIME_THRESHOLD
      
      # Certainty required to meet the spec of probablePrime
      const_set_lazy(:DEFAULT_PRIME_CERTAINTY) { 100 }
      const_attr_reader  :DEFAULT_PRIME_CERTAINTY
      
      typesig { [::Java::Int, Random] }
      # Returns a positive BigInteger that is probably prime, with the
      # specified bitLength. The probability that a BigInteger returned
      # by this method is composite does not exceed 2<sup>-100</sup>.
      # 
      # @param  bitLength bitLength of the returned BigInteger.
      # @param  rnd source of random bits used to select candidates to be
      # tested for primality.
      # @return a BigInteger of {@code bitLength} bits that is probably prime
      # @throws ArithmeticException {@code bitLength < 2}.
      # @see    #bitLength()
      # @since 1.4
      def probable_prime(bit_length, rnd)
        if (bit_length < 2)
          raise ArithmeticException.new("bitLength < 2")
        end
        # The cutoff of 95 was chosen empirically for best performance
        return (bit_length < SMALL_PRIME_THRESHOLD ? small_prime(bit_length, DEFAULT_PRIME_CERTAINTY, rnd) : large_prime(bit_length, DEFAULT_PRIME_CERTAINTY, rnd))
      end
      
      typesig { [::Java::Int, ::Java::Int, Random] }
      # Find a random number of the specified bitLength that is probably prime.
      # This method is used for smaller primes, its performance degrades on
      # larger bitlengths.
      # 
      # This method assumes bitLength > 1.
      def small_prime(bit_length, certainty, rnd)
        mag_len = (bit_length + 31) >> 5
        temp = Array.typed(::Java::Int).new(mag_len) { 0 }
        high_bit = 1 << ((bit_length + 31) & 0x1f) # High bit of high int
        high_mask = (high_bit << 1) - 1 # Bits to keep in high int
        while (true)
          # Construct a candidate
          i = 0
          while i < mag_len
            temp[i] = rnd.next_int
            i += 1
          end
          temp[0] = (temp[0] & high_mask) | high_bit # Ensure exact length
          if (bit_length > 2)
            temp[mag_len - 1] |= 1
          end # Make odd if bitlen > 2
          p = BigInteger.new(temp, 1)
          # Do cheap "pre-test" if applicable
          if (bit_length > 6)
            r = p.remainder(SMALL_PRIME_PRODUCT).long_value
            if (((r % 3).equal?(0)) || ((r % 5).equal?(0)) || ((r % 7).equal?(0)) || ((r % 11).equal?(0)) || ((r % 13).equal?(0)) || ((r % 17).equal?(0)) || ((r % 19).equal?(0)) || ((r % 23).equal?(0)) || ((r % 29).equal?(0)) || ((r % 31).equal?(0)) || ((r % 37).equal?(0)) || ((r % 41).equal?(0)))
              next
            end # Candidate is composite; try another
          end
          # All candidates of bitLength 2 and 3 are prime by this point
          if (bit_length < 4)
            return p
          end
          # Do expensive test if we survive pre-test (or it's inapplicable)
          if (p.prime_to_certainty(certainty, rnd))
            return p
          end
        end
      end
      
      const_set_lazy(:SMALL_PRIME_PRODUCT) { value_of(3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 37 * 41) }
      const_attr_reader  :SMALL_PRIME_PRODUCT
      
      typesig { [::Java::Int, ::Java::Int, Random] }
      # Find a random number of the specified bitLength that is probably prime.
      # This method is more appropriate for larger bitlengths since it uses
      # a sieve to eliminate most composites before using a more expensive
      # test.
      def large_prime(bit_length, certainty, rnd)
        p = nil
        p = BigInteger.new(bit_length, rnd).set_bit(bit_length - 1)
        p.attr_mag[p.attr_mag.attr_length - 1] &= -0x2
        # Use a sieve length likely to contain the next prime number
        search_len = (bit_length / 20) * 64
        search_sieve = BitSieve.new(p, search_len)
        candidate = search_sieve.retrieve(p, certainty, rnd)
        while (((candidate).nil?) || (!(candidate.bit_length).equal?(bit_length)))
          p = p.add(BigInteger.value_of(2 * search_len))
          if (!(p.bit_length).equal?(bit_length))
            p = BigInteger.new(bit_length, rnd).set_bit(bit_length - 1)
          end
          p.attr_mag[p.attr_mag.attr_length - 1] &= -0x2
          search_sieve = BitSieve.new(p, search_len)
          candidate = search_sieve.retrieve(p, certainty, rnd)
        end
        return candidate
      end
    }
    
    typesig { [] }
    # Returns the first integer greater than this {@code BigInteger} that
    # is probably prime.  The probability that the number returned by this
    # method is composite does not exceed 2<sup>-100</sup>. This method will
    # never skip over a prime when searching: if it returns {@code p}, there
    # is no prime {@code q} such that {@code this < q < p}.
    # 
    # @return the first integer greater than this {@code BigInteger} that
    # is probably prime.
    # @throws ArithmeticException {@code this < 0}.
    # @since 1.5
    def next_probable_prime
      if (@signum < 0)
        raise ArithmeticException.new("start < 0: " + RJava.cast_to_string(self))
      end
      # Handle trivial cases
      if (((@signum).equal?(0)) || (self == ONE))
        return TWO
      end
      result = self.add(ONE)
      # Fastpath for small numbers
      if (result.bit_length < SMALL_PRIME_THRESHOLD)
        # Ensure an odd number
        if (!result.test_bit(0))
          result = result.add(ONE)
        end
        while (true)
          # Do cheap "pre-test" if applicable
          if (result.bit_length > 6)
            r = result.remainder(SMALL_PRIME_PRODUCT).long_value
            if (((r % 3).equal?(0)) || ((r % 5).equal?(0)) || ((r % 7).equal?(0)) || ((r % 11).equal?(0)) || ((r % 13).equal?(0)) || ((r % 17).equal?(0)) || ((r % 19).equal?(0)) || ((r % 23).equal?(0)) || ((r % 29).equal?(0)) || ((r % 31).equal?(0)) || ((r % 37).equal?(0)) || ((r % 41).equal?(0)))
              result = result.add(TWO)
              next # Candidate is composite; try another
            end
          end
          # All candidates of bitLength 2 and 3 are prime by this point
          if (result.bit_length < 4)
            return result
          end
          # The expensive test
          if (result.prime_to_certainty(DEFAULT_PRIME_CERTAINTY, nil))
            return result
          end
          result = result.add(TWO)
        end
      end
      # Start at previous even number
      if (result.test_bit(0))
        result = result.subtract(ONE)
      end
      # Looking for the next large prime
      search_len = (result.bit_length / 20) * 64
      while (true)
        search_sieve = BitSieve.new(result, search_len)
        candidate = search_sieve.retrieve(result, DEFAULT_PRIME_CERTAINTY, nil)
        if (!(candidate).nil?)
          return candidate
        end
        result = result.add(BigInteger.value_of(2 * search_len))
      end
    end
    
    typesig { [::Java::Int, Random] }
    # Returns {@code true} if this BigInteger is probably prime,
    # {@code false} if it's definitely composite.
    # 
    # This method assumes bitLength > 2.
    # 
    # @param  certainty a measure of the uncertainty that the caller is
    # willing to tolerate: if the call returns {@code true}
    # the probability that this BigInteger is prime exceeds
    # {@code (1 - 1/2<sup>certainty</sup>)}.  The execution time of
    # this method is proportional to the value of this parameter.
    # @return {@code true} if this BigInteger is probably prime,
    # {@code false} if it's definitely composite.
    def prime_to_certainty(certainty, random)
      rounds = 0
      n = (Math.min(certainty, JavaInteger::MAX_VALUE - 1) + 1) / 2
      # The relationship between the certainty and the number of rounds
      # we perform is given in the draft standard ANSI X9.80, "PRIME
      # NUMBER GENERATION, PRIMALITY TESTING, AND PRIMALITY CERTIFICATES".
      size_in_bits = self.bit_length
      if (size_in_bits < 100)
        rounds = 50
        rounds = n < rounds ? n : rounds
        return passes_miller_rabin(rounds, random)
      end
      if (size_in_bits < 256)
        rounds = 27
      else
        if (size_in_bits < 512)
          rounds = 15
        else
          if (size_in_bits < 768)
            rounds = 8
          else
            if (size_in_bits < 1024)
              rounds = 4
            else
              rounds = 2
            end
          end
        end
      end
      rounds = n < rounds ? n : rounds
      return passes_miller_rabin(rounds, random) && passes_lucas_lehmer
    end
    
    typesig { [] }
    # Returns true iff this BigInteger is a Lucas-Lehmer probable prime.
    # 
    # The following assumptions are made:
    # This BigInteger is a positive, odd number.
    def passes_lucas_lehmer
      this_plus_one = self.add(ONE)
      # Step 1
      d = 5
      while (!(jacobi_symbol(d, self)).equal?(-1))
        # 5, -7, 9, -11, ...
        d = (d < 0) ? Math.abs(d) + 2 : -(d + 2)
      end
      # Step 2
      u = lucas_lehmer_sequence(d, this_plus_one, self)
      # Step 3
      return (u.mod(self) == ZERO)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, BigInteger] }
      # Computes Jacobi(p,n).
      # Assumes n positive, odd, n>=3.
      def jacobi_symbol(p, n)
        if ((p).equal?(0))
          return 0
        end
        # Algorithm and comments adapted from Colin Plumb's C library.
        j = 1
        u = n.attr_mag[n.attr_mag.attr_length - 1]
        # Make p positive
        if (p < 0)
          p = -p
          n8 = u & 7
          if (((n8).equal?(3)) || ((n8).equal?(7)))
            j = -j
          end # 3 (011) or 7 (111) mod 8
        end
        # Get rid of factors of 2 in p
        while (((p & 3)).equal?(0))
          p >>= 2
        end
        if (((p & 1)).equal?(0))
          p >>= 1
          if (!(((u ^ (u >> 1)) & 2)).equal?(0))
            j = -j
          end # 3 (011) or 5 (101) mod 8
        end
        if ((p).equal?(1))
          return j
        end
        # Then, apply quadratic reciprocity
        if (!((p & u & 2)).equal?(0))
          # p = u = 3 (mod 4)?
          j = -j
        end
        # And reduce u mod p
        u = n.mod(BigInteger.value_of(p)).int_value
        # Now compute Jacobi(u,p), u < p
        while (!(u).equal?(0))
          while (((u & 3)).equal?(0))
            u >>= 2
          end
          if (((u & 1)).equal?(0))
            u >>= 1
            if (!(((p ^ (p >> 1)) & 2)).equal?(0))
              j = -j
            end # 3 (011) or 5 (101) mod 8
          end
          if ((u).equal?(1))
            return j
          end
          # Now both u and p are odd, so use quadratic reciprocity
          raise AssertError if not ((u < p))
          t = u
          u = p
          p = t
          if (!((u & p & 2)).equal?(0))
            # u = p = 3 (mod 4)?
            j = -j
          end
          # Now u >= p, so it can be reduced
          u %= p
        end
        return 0
      end
      
      typesig { [::Java::Int, BigInteger, BigInteger] }
      def lucas_lehmer_sequence(z, k, n)
        d = BigInteger.value_of(z)
        u = ONE
        u2 = nil
        v = ONE
        v2 = nil
        i = k.bit_length - 2
        while i >= 0
          u2 = u.multiply(v).mod(n)
          v2 = v.square.add(d.multiply(u.square)).mod(n)
          if (v2.test_bit(0))
            v2 = n.subtract(v2)
            v2.attr_signum = -v2.attr_signum
          end
          v2 = v2.shift_right(1)
          u = u2
          v = v2
          if (k.test_bit(i))
            u2 = u.add(v).mod(n)
            if (u2.test_bit(0))
              u2 = n.subtract(u2)
              u2.attr_signum = -u2.attr_signum
            end
            u2 = u2.shift_right(1)
            v2 = v.add(d.multiply(u)).mod(n)
            if (v2.test_bit(0))
              v2 = n.subtract(v2)
              v2.attr_signum = -v2.attr_signum
            end
            v2 = v2.shift_right(1)
            u = u2
            v = v2
          end
          i -= 1
        end
        return u
      end
      
      
      def static_random
        defined?(@@static_random) ? @@static_random : @@static_random= nil
      end
      alias_method :attr_static_random, :static_random
      
      def static_random=(value)
        @@static_random = value
      end
      alias_method :attr_static_random=, :static_random=
      
      typesig { [] }
      def get_secure_random
        if ((self.attr_static_random).nil?)
          self.attr_static_random = Java::Security::SecureRandom.new
        end
        return self.attr_static_random
      end
    }
    
    typesig { [::Java::Int, Random] }
    # Returns true iff this BigInteger passes the specified number of
    # Miller-Rabin tests. This test is taken from the DSA spec (NIST FIPS
    # 186-2).
    # 
    # The following assumptions are made:
    # This BigInteger is a positive, odd number greater than 2.
    # iterations<=50.
    def passes_miller_rabin(iterations, rnd)
      # Find a and m such that m is odd and this == 1 + 2**a * m
      this_minus_one = self.subtract(ONE)
      m = this_minus_one
      a = m.get_lowest_set_bit
      m = m.shift_right(a)
      # Do the tests
      if ((rnd).nil?)
        rnd = get_secure_random
      end
      i = 0
      while i < iterations
        # Generate a uniform random on (1, this)
        b = nil
        begin
          b = BigInteger.new(self.bit_length, rnd)
        end while ((b <=> ONE) <= 0 || (b <=> self) >= 0)
        j = 0
        z = b.mod_pow(m, self)
        while (!(((j).equal?(0) && (z == ONE)) || (z == this_minus_one)))
          if (j > 0 && (z == ONE) || ((j += 1)).equal?(a))
            return false
          end
          z = z.mod_pow(TWO, self)
        end
        i += 1
      end
      return true
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int] }
    # This private constructor differs from its public cousin
    # with the arguments reversed in two ways: it assumes that its
    # arguments are correct, and it doesn't copy the magnitude array.
    def initialize(magnitude, signum)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      @signum = ((magnitude.attr_length).equal?(0) ? 0 : signum)
      @mag = magnitude
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # This private constructor is for internal use and assumes that its
    # arguments are correct.
    def initialize(magnitude, signum)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      @signum = ((magnitude.attr_length).equal?(0) ? 0 : signum)
      @mag = strip_leading_zero_bytes(magnitude)
    end
    
    typesig { [MutableBigInteger, ::Java::Int] }
    # This private constructor is for internal use in converting
    # from a MutableBigInteger object into a BigInteger.
    def initialize(val, sign)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      if (val.attr_offset > 0 || !(val.attr_value.attr_length).equal?(val.attr_int_len))
        @mag = Array.typed(::Java::Int).new(val.attr_int_len) { 0 }
        i = 0
        while i < val.attr_int_len
          @mag[i] = val.attr_value[val.attr_offset + i]
          i += 1
        end
      else
        @mag = val.attr_value
      end
      @signum = ((val.attr_int_len).equal?(0)) ? 0 : sign
    end
    
    class_module.module_eval {
      typesig { [::Java::Long] }
      # Static Factory Methods
      # 
      # Returns a BigInteger whose value is equal to that of the
      # specified {@code long}.  This "static factory method" is
      # provided in preference to a ({@code long}) constructor
      # because it allows for reuse of frequently used BigIntegers.
      # 
      # @param  val value of the BigInteger to return.
      # @return a BigInteger with the specified value.
      def value_of(val)
        # If -MAX_CONSTANT < val < MAX_CONSTANT, return stashed constant
        if ((val).equal?(0))
          return ZERO
        end
        if (val > 0 && val <= MAX_CONSTANT)
          return self.attr_pos_const[RJava.cast_to_int(val)]
        else
          if (val < 0 && val >= -MAX_CONSTANT)
            return self.attr_neg_const[RJava.cast_to_int(-val)]
          end
        end
        return BigInteger.new(val)
      end
    }
    
    typesig { [::Java::Long] }
    # Constructs a BigInteger with the specified value, which may not be zero.
    def initialize(val)
      @signum = 0
      @mag = nil
      @bit_count = 0
      @bit_length = 0
      @lowest_set_bit = 0
      @first_nonzero_byte_num = 0
      @first_nonzero_int_num = 0
      super()
      @bit_count = -1
      @bit_length = -1
      @lowest_set_bit = -2
      @first_nonzero_byte_num = -2
      @first_nonzero_int_num = -2
      if (val < 0)
        @signum = -1
        val = -val
      else
        @signum = 1
      end
      high_word = RJava.cast_to_int((val >> 32))
      if ((high_word).equal?(0))
        @mag = Array.typed(::Java::Int).new(1) { 0 }
        @mag[0] = RJava.cast_to_int(val)
      else
        @mag = Array.typed(::Java::Int).new(2) { 0 }
        @mag[0] = high_word
        @mag[1] = RJava.cast_to_int(val)
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int)] }
      # Returns a BigInteger with the given two's complement representation.
      # Assumes that the input array will not be modified (the returned
      # BigInteger will reference the input array if feasible).
      def value_of(val)
        return (val[0] > 0 ? BigInteger.new(val, 1) : BigInteger.new(val))
      end
      
      # Constants
      # 
      # Initialize static constant array when class is loaded.
      const_set_lazy(:MAX_CONSTANT) { 16 }
      const_attr_reader  :MAX_CONSTANT
      
      
      def pos_const
        defined?(@@pos_const) ? @@pos_const : @@pos_const= Array.typed(BigInteger).new(MAX_CONSTANT + 1) { nil }
      end
      alias_method :attr_pos_const, :pos_const
      
      def pos_const=(value)
        @@pos_const = value
      end
      alias_method :attr_pos_const=, :pos_const=
      
      
      def neg_const
        defined?(@@neg_const) ? @@neg_const : @@neg_const= Array.typed(BigInteger).new(MAX_CONSTANT + 1) { nil }
      end
      alias_method :attr_neg_const, :neg_const
      
      def neg_const=(value)
        @@neg_const = value
      end
      alias_method :attr_neg_const=, :neg_const=
      
      when_class_loaded do
        i = 1
        while i <= MAX_CONSTANT
          magnitude = Array.typed(::Java::Int).new(1) { 0 }
          magnitude[0] = i
          self.attr_pos_const[i] = BigInteger.new(magnitude, 1)
          self.attr_neg_const[i] = BigInteger.new(magnitude, -1)
          i += 1
        end
      end
      
      # The BigInteger constant zero.
      # 
      # @since   1.2
      const_set_lazy(:ZERO) { BigInteger.new(Array.typed(::Java::Int).new(0) { 0 }, 0) }
      const_attr_reader  :ZERO
      
      # The BigInteger constant one.
      # 
      # @since   1.2
      const_set_lazy(:ONE) { value_of(1) }
      const_attr_reader  :ONE
      
      # The BigInteger constant two.  (Not exported.)
      const_set_lazy(:TWO) { value_of(2) }
      const_attr_reader  :TWO
      
      # The BigInteger constant ten.
      # 
      # @since   1.5
      const_set_lazy(:TEN) { value_of(10) }
      const_attr_reader  :TEN
    }
    
    typesig { [BigInteger] }
    # Arithmetic Operations
    # 
    # Returns a BigInteger whose value is {@code (this + val)}.
    # 
    # @param  val value to be added to this BigInteger.
    # @return {@code this + val}
    def add(val)
      result_mag = nil
      if ((val.attr_signum).equal?(0))
        return self
      end
      if ((@signum).equal?(0))
        return val
      end
      if ((val.attr_signum).equal?(@signum))
        return BigInteger.new(add(@mag, val.attr_mag), @signum)
      end
      cmp = int_array_cmp(@mag, val.attr_mag)
      if ((cmp).equal?(0))
        return ZERO
      end
      result_mag = (cmp > 0 ? subtract(@mag, val.attr_mag) : subtract(val.attr_mag, @mag))
      result_mag = trusted_strip_leading_zero_ints(result_mag)
      return BigInteger.new(result_mag, cmp * @signum)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int)] }
      # Adds the contents of the int arrays x and y. This method allocates
      # a new int array to hold the answer and returns a reference to that
      # array.
      def add(x, y)
        # If x is shorter, swap the two arrays
        if (x.attr_length < y.attr_length)
          tmp = x
          x = y
          y = tmp
        end
        x_index = x.attr_length
        y_index = y.attr_length
        result = Array.typed(::Java::Int).new(x_index) { 0 }
        sum = 0
        # Add common parts of both numbers
        while (y_index > 0)
          sum = (x[(x_index -= 1)] & LONG_MASK) + (y[(y_index -= 1)] & LONG_MASK) + (sum >> 32)
          result[x_index] = RJava.cast_to_int(sum)
        end
        # Copy remainder of longer number while carry propagation is required
        carry = (!(sum >> 32).equal?(0))
        while (x_index > 0 && carry)
          carry = (((result[(x_index -= 1)] = x[x_index] + 1)).equal?(0))
        end
        # Copy remainder of longer number
        while (x_index > 0)
          result[(x_index -= 1)] = x[x_index]
        end
        # Grow result if necessary
        if (carry)
          new_len = result.attr_length + 1
          temp = Array.typed(::Java::Int).new(new_len) { 0 }
          i = 1
          while i < new_len
            temp[i] = result[i - 1]
            i += 1
          end
          temp[0] = 0x1
          result = temp
        end
        return result
      end
    }
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this - val)}.
    # 
    # @param  val value to be subtracted from this BigInteger.
    # @return {@code this - val}
    def subtract(val)
      result_mag = nil
      if ((val.attr_signum).equal?(0))
        return self
      end
      if ((@signum).equal?(0))
        return val.negate
      end
      if (!(val.attr_signum).equal?(@signum))
        return BigInteger.new(add(@mag, val.attr_mag), @signum)
      end
      cmp = int_array_cmp(@mag, val.attr_mag)
      if ((cmp).equal?(0))
        return ZERO
      end
      result_mag = (cmp > 0 ? subtract(@mag, val.attr_mag) : subtract(val.attr_mag, @mag))
      result_mag = trusted_strip_leading_zero_ints(result_mag)
      return BigInteger.new(result_mag, cmp * @signum)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int)] }
      # Subtracts the contents of the second int arrays (little) from the
      # first (big).  The first int array (big) must represent a larger number
      # than the second.  This method allocates the space necessary to hold the
      # answer.
      def subtract(big, little)
        big_index = big.attr_length
        result = Array.typed(::Java::Int).new(big_index) { 0 }
        little_index = little.attr_length
        difference = 0
        # Subtract common parts of both numbers
        while (little_index > 0)
          difference = (big[(big_index -= 1)] & LONG_MASK) - (little[(little_index -= 1)] & LONG_MASK) + (difference >> 32)
          result[big_index] = RJava.cast_to_int(difference)
        end
        # Subtract remainder of longer number while borrow propagates
        borrow = (!(difference >> 32).equal?(0))
        while (big_index > 0 && borrow)
          borrow = (((result[(big_index -= 1)] = big[big_index] - 1)).equal?(-1))
        end
        # Copy remainder of longer number
        while (big_index > 0)
          result[(big_index -= 1)] = big[big_index]
        end
        return result
      end
    }
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this * val)}.
    # 
    # @param  val value to be multiplied by this BigInteger.
    # @return {@code this * val}
    def multiply(val)
      if ((val.attr_signum).equal?(0) || (@signum).equal?(0))
        return ZERO
      end
      result = multiply_to_len(@mag, @mag.attr_length, val.attr_mag, val.attr_mag.attr_length, nil)
      result = trusted_strip_leading_zero_ints(result)
      return BigInteger.new(result, @signum * val.attr_signum)
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int, Array.typed(::Java::Int), ::Java::Int, Array.typed(::Java::Int)] }
    # Multiplies int arrays x and y to the specified lengths and places
    # the result into z.
    def multiply_to_len(x, xlen, y, ylen, z)
      xstart = xlen - 1
      ystart = ylen - 1
      if ((z).nil? || z.attr_length < (xlen + ylen))
        z = Array.typed(::Java::Int).new(xlen + ylen) { 0 }
      end
      carry = 0
      j = ystart
      k = ystart + 1 + xstart
      while j >= 0
        product = (y[j] & LONG_MASK) * (x[xstart] & LONG_MASK) + carry
        z[k] = RJava.cast_to_int(product)
        carry = product >> 32
        j -= 1
        k -= 1
      end
      z[xstart] = RJava.cast_to_int(carry)
      i = xstart - 1
      while i >= 0
        carry = 0
        j_ = ystart
        k_ = ystart + 1 + i
        while j_ >= 0
          product = (y[j_] & LONG_MASK) * (x[i] & LONG_MASK) + (z[k_] & LONG_MASK) + carry
          z[k_] = RJava.cast_to_int(product)
          carry = product >> 32
          j_ -= 1
          k_ -= 1
        end
        z[i] = RJava.cast_to_int(carry)
        i -= 1
      end
      return z
    end
    
    typesig { [] }
    # Returns a BigInteger whose value is {@code (this<sup>2</sup>)}.
    # 
    # @return {@code this<sup>2</sup>}
    def square
      if ((@signum).equal?(0))
        return ZERO
      end
      z = square_to_len(@mag, @mag.attr_length, nil)
      return BigInteger.new(trusted_strip_leading_zero_ints(z), 1)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int), ::Java::Int, Array.typed(::Java::Int)] }
      # Squares the contents of the int array x. The result is placed into the
      # int array z.  The contents of x are not changed.
      def square_to_len(x, len, z)
        # The algorithm used here is adapted from Colin Plumb's C library.
        # Technique: Consider the partial products in the multiplication
        # of "abcde" by itself:
        # 
        # a  b  c  d  e
        # *  a  b  c  d  e
        # ==================
        # ae be ce de ee
        # ad bd cd dd de
        # ac bc cc cd ce
        # ab bb bc bd be
        # aa ab ac ad ae
        # 
        # Note that everything above the main diagonal:
        # ae be ce de = (abcd) * e
        # ad bd cd       = (abc) * d
        # ac bc             = (ab) * c
        # ab                   = (a) * b
        # 
        # is a copy of everything below the main diagonal:
        # de
        # cd ce
        # bc bd be
        # ab ac ad ae
        # 
        # Thus, the sum is 2 * (off the diagonal) + diagonal.
        # 
        # This is accumulated beginning with the diagonal (which
        # consist of the squares of the digits of the input), which is then
        # divided by two, the off-diagonal added, and multiplied by two
        # again.  The low bit is simply a copy of the low bit of the
        # input, so it doesn't need special care.
        zlen = len << 1
        if ((z).nil? || z.attr_length < zlen)
          z = Array.typed(::Java::Int).new(zlen) { 0 }
        end
        # Store the squares, right shifted one bit (i.e., divided by 2)
        last_product_low_word = 0
        j = 0
        i = 0
        while j < len
          piece = (x[j] & LONG_MASK)
          product = piece * piece
          z[((i += 1) - 1)] = (last_product_low_word << 31) | RJava.cast_to_int((product >> 33))
          z[((i += 1) - 1)] = RJava.cast_to_int((product >> 1))
          last_product_low_word = RJava.cast_to_int(product)
          j += 1
        end
        # Add in off-diagonal sums
        i_ = len
        offset = 1
        while i_ > 0
          t = x[i_ - 1]
          t = mul_add(z, x, offset, i_ - 1, t)
          add_one(z, offset - 1, i_, t)
          i_ -= 1
          offset += 2
        end
        # Shift back up and set low bit
        primitive_left_shift(z, zlen, 1)
        z[zlen - 1] |= x[len - 1] & 1
        return z
      end
    }
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this / val)}.
    # 
    # @param  val value by which this BigInteger is to be divided.
    # @return {@code this / val}
    # @throws ArithmeticException {@code val==0}
    def divide(val)
      q = MutableBigInteger.new
      r = MutableBigInteger.new
      a = MutableBigInteger.new(@mag)
      b = MutableBigInteger.new(val.attr_mag)
      a.divide(b, q, r)
      return BigInteger.new(q, @signum * val.attr_signum)
    end
    
    typesig { [BigInteger] }
    # Returns an array of two BigIntegers containing {@code (this / val)}
    # followed by {@code (this % val)}.
    # 
    # @param  val value by which this BigInteger is to be divided, and the
    # remainder computed.
    # @return an array of two BigIntegers: the quotient {@code (this / val)}
    # is the initial element, and the remainder {@code (this % val)}
    # is the final element.
    # @throws ArithmeticException {@code val==0}
    def divide_and_remainder(val)
      result = Array.typed(BigInteger).new(2) { nil }
      q = MutableBigInteger.new
      r = MutableBigInteger.new
      a = MutableBigInteger.new(@mag)
      b = MutableBigInteger.new(val.attr_mag)
      a.divide(b, q, r)
      result[0] = BigInteger.new(q, @signum * val.attr_signum)
      result[1] = BigInteger.new(r, @signum)
      return result
    end
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this % val)}.
    # 
    # @param  val value by which this BigInteger is to be divided, and the
    # remainder computed.
    # @return {@code this % val}
    # @throws ArithmeticException {@code val==0}
    def remainder(val)
      q = MutableBigInteger.new
      r = MutableBigInteger.new
      a = MutableBigInteger.new(@mag)
      b = MutableBigInteger.new(val.attr_mag)
      a.divide(b, q, r)
      return BigInteger.new(r, @signum)
    end
    
    typesig { [::Java::Int] }
    # Returns a BigInteger whose value is <tt>(this<sup>exponent</sup>)</tt>.
    # Note that {@code exponent} is an integer rather than a BigInteger.
    # 
    # @param  exponent exponent to which this BigInteger is to be raised.
    # @return <tt>this<sup>exponent</sup></tt>
    # @throws ArithmeticException {@code exponent} is negative.  (This would
    # cause the operation to yield a non-integer value.)
    def pow(exponent)
      if (exponent < 0)
        raise ArithmeticException.new("Negative exponent")
      end
      if ((@signum).equal?(0))
        return ((exponent).equal?(0) ? ONE : self)
      end
      # Perform exponentiation using repeated squaring trick
      new_sign = (@signum < 0 && ((exponent & 1)).equal?(1) ? -1 : 1)
      base_to_pow2 = @mag
      result = Array.typed(::Java::Int).new([1])
      while (!(exponent).equal?(0))
        if (((exponent & 1)).equal?(1))
          result = multiply_to_len(result, result.attr_length, base_to_pow2, base_to_pow2.attr_length, nil)
          result = trusted_strip_leading_zero_ints(result)
        end
        if (!((exponent >>= 1)).equal?(0))
          base_to_pow2 = square_to_len(base_to_pow2, base_to_pow2.attr_length, nil)
          base_to_pow2 = trusted_strip_leading_zero_ints(base_to_pow2)
        end
      end
      return BigInteger.new(result, new_sign)
    end
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is the greatest common divisor of
    # {@code abs(this)} and {@code abs(val)}.  Returns 0 if
    # {@code this==0 && val==0}.
    # 
    # @param  val value with which the GCD is to be computed.
    # @return {@code GCD(abs(this), abs(val))}
    def gcd(val)
      if ((val.attr_signum).equal?(0))
        return self.abs
      else
        if ((@signum).equal?(0))
          return val.abs
        end
      end
      a = MutableBigInteger.new(self)
      b = MutableBigInteger.new(val)
      result = a.hybrid_gcd(b)
      return BigInteger.new(result, 1)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # Left shift int array a up to len by n bits. Returns the array that
      # results from the shift since space may have to be reallocated.
      def left_shift(a, len, n)
        n_ints = n >> 5
        n_bits = n & 0x1f
        bits_in_high_word = bit_len(a[0])
        # If shift can be done without recopy, do so
        if (n <= (32 - bits_in_high_word))
          primitive_left_shift(a, len, n_bits)
          return a
        else
          # Array must be resized
          if (n_bits <= (32 - bits_in_high_word))
            result = Array.typed(::Java::Int).new(n_ints + len) { 0 }
            i = 0
            while i < len
              result[i] = a[i]
              i += 1
            end
            primitive_left_shift(result, result.attr_length, n_bits)
            return result
          else
            result = Array.typed(::Java::Int).new(n_ints + len + 1) { 0 }
            i = 0
            while i < len
              result[i] = a[i]
              i += 1
            end
            primitive_right_shift(result, result.attr_length, 32 - n_bits)
            return result
          end
        end
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # shifts a up to len right n bits assumes no leading zeros, 0<n<32
      def primitive_right_shift(a, len, n)
        n2 = 32 - n
        i = len - 1
        c = a[i]
        while i > 0
          b = c
          c = a[i - 1]
          a[i] = (c << n2) | (b >> n)
          i -= 1
        end
        a[0] >>= n
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # shifts a up to len left n bits assumes no leading zeros, 0<=n<32
      def primitive_left_shift(a, len, n)
        if ((len).equal?(0) || (n).equal?(0))
          return
        end
        n2 = 32 - n
        i = 0
        c = a[i]
        m = i + len - 1
        while i < m
          b = c
          c = a[i + 1]
          a[i] = (b << n) | (c >> n2)
          i += 1
        end
        a[len - 1] <<= n
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int] }
      # Calculate bitlength of contents of the first len elements an int array,
      # assuming there are no leading zero ints.
      def bit_length(val, len)
        if ((len).equal?(0))
          return 0
        end
        return ((len - 1) << 5) + bit_len(val[0])
      end
    }
    
    typesig { [] }
    # Returns a BigInteger whose value is the absolute value of this
    # BigInteger.
    # 
    # @return {@code abs(this)}
    def abs
      return (@signum >= 0 ? self : self.negate)
    end
    
    typesig { [] }
    # Returns a BigInteger whose value is {@code (-this)}.
    # 
    # @return {@code -this}
    def negate
      return BigInteger.new(@mag, -@signum)
    end
    
    typesig { [] }
    # Returns the signum function of this BigInteger.
    # 
    # @return -1, 0 or 1 as the value of this BigInteger is negative, zero or
    # positive.
    def signum
      return @signum
    end
    
    typesig { [BigInteger] }
    # Modular Arithmetic Operations
    # 
    # Returns a BigInteger whose value is {@code (this mod m}).  This method
    # differs from {@code remainder} in that it always returns a
    # <i>non-negative</i> BigInteger.
    # 
    # @param  m the modulus.
    # @return {@code this mod m}
    # @throws ArithmeticException {@code m <= 0}
    # @see    #remainder
    def mod(m)
      if (m.attr_signum <= 0)
        raise ArithmeticException.new("BigInteger: modulus not positive")
      end
      result = self.remainder(m)
      return (result.attr_signum >= 0 ? result : result.add(m))
    end
    
    typesig { [BigInteger, BigInteger] }
    # Returns a BigInteger whose value is
    # <tt>(this<sup>exponent</sup> mod m)</tt>.  (Unlike {@code pow}, this
    # method permits negative exponents.)
    # 
    # @param  exponent the exponent.
    # @param  m the modulus.
    # @return <tt>this<sup>exponent</sup> mod m</tt>
    # @throws ArithmeticException {@code m <= 0}
    # @see    #modInverse
    def mod_pow(exponent, m)
      if (m.attr_signum <= 0)
        raise ArithmeticException.new("BigInteger: modulus not positive")
      end
      # Trivial cases
      if ((exponent.attr_signum).equal?(0))
        return ((m == ONE) ? ZERO : ONE)
      end
      if ((self == ONE))
        return ((m == ONE) ? ZERO : ONE)
      end
      if ((self == ZERO) && exponent.attr_signum >= 0)
        return ZERO
      end
      if ((self == self.attr_neg_const[1]) && (!exponent.test_bit(0)))
        return ((m == ONE) ? ZERO : ONE)
      end
      invert_result = false
      if ((invert_result = (exponent.attr_signum < 0)))
        exponent = exponent.negate
      end
      base = (@signum < 0 || (self <=> m) >= 0 ? self.mod(m) : self)
      result = nil
      if (m.test_bit(0))
        # odd modulus
        result = base.odd_mod_pow(exponent, m)
      else
        # Even modulus.  Tear it into an "odd part" (m1) and power of two
        # (m2), exponentiate mod m1, manually exponentiate mod m2, and
        # use Chinese Remainder Theorem to combine results.
        # 
        # Tear m apart into odd part (m1) and power of 2 (m2)
        p = m.get_lowest_set_bit # Max pow of 2 that divides m
        m1 = m.shift_right(p) # m/2**p
        m2 = ONE.shift_left(p) # 2**p
        # Calculate new base from m1
        base2 = (@signum < 0 || (self <=> m1) >= 0 ? self.mod(m1) : self)
        # Caculate (base ** exponent) mod m1.
        a1 = ((m1 == ONE) ? ZERO : base2.odd_mod_pow(exponent, m1))
        # Calculate (this ** exponent) mod m2
        a2 = base.mod_pow2(exponent, p)
        # Combine results using Chinese Remainder Theorem
        y1 = m2.mod_inverse(m1)
        y2 = m1.mod_inverse(m2)
        result = a1.multiply(m2).multiply(y1).add(a2.multiply(m1).multiply(y2)).mod(m)
      end
      return (invert_result ? result.mod_inverse(m) : result)
    end
    
    class_module.module_eval {
      
      def bn_exp_mod_thresh_table
        defined?(@@bn_exp_mod_thresh_table) ? @@bn_exp_mod_thresh_table : @@bn_exp_mod_thresh_table= Array.typed(::Java::Int).new([7, 25, 81, 241, 673, 1793, JavaInteger::MAX_VALUE])
      end
      alias_method :attr_bn_exp_mod_thresh_table, :bn_exp_mod_thresh_table
      
      def bn_exp_mod_thresh_table=(value)
        @@bn_exp_mod_thresh_table = value
      end
      alias_method :attr_bn_exp_mod_thresh_table=, :bn_exp_mod_thresh_table=
    }
    
    typesig { [BigInteger, BigInteger] }
    # Sentinel
    # 
    # Returns a BigInteger whose value is x to the power of y mod z.
    # Assumes: z is odd && x < z.
    def odd_mod_pow(y, z)
      # The algorithm is adapted from Colin Plumb's C library.
      # 
      # The window algorithm:
      # The idea is to keep a running product of b1 = n^(high-order bits of exp)
      # and then keep appending exponent bits to it.  The following patterns
      # apply to a 3-bit window (k = 3):
      # To append   0: square
      # To append   1: square, multiply by n^1
      # To append  10: square, multiply by n^1, square
      # To append  11: square, square, multiply by n^3
      # To append 100: square, multiply by n^1, square, square
      # To append 101: square, square, square, multiply by n^5
      # To append 110: square, square, multiply by n^3, square
      # To append 111: square, square, square, multiply by n^7
      # 
      # Since each pattern involves only one multiply, the longer the pattern
      # the better, except that a 0 (no multiplies) can be appended directly.
      # We precompute a table of odd powers of n, up to 2^k, and can then
      # multiply k bits of exponent at a time.  Actually, assuming random
      # exponents, there is on average one zero bit between needs to
      # multiply (1/2 of the time there's none, 1/4 of the time there's 1,
      # 1/8 of the time, there's 2, 1/32 of the time, there's 3, etc.), so
      # you have to do one multiply per k+1 bits of exponent.
      # 
      # The loop walks down the exponent, squaring the result buffer as
      # it goes.  There is a wbits+1 bit lookahead buffer, buf, that is
      # filled with the upcoming exponent bits.  (What is read after the
      # end of the exponent is unimportant, but it is filled with zero here.)
      # When the most-significant bit of this buffer becomes set, i.e.
      # (buf & tblmask) != 0, we have to decide what pattern to multiply
      # by, and when to do it.  We decide, remember to do it in future
      # after a suitable number of squarings have passed (e.g. a pattern
      # of "100" in the buffer requires that we multiply by n^1 immediately;
      # a pattern of "110" calls for multiplying by n^3 after one more
      # squaring), clear the buffer, and continue.
      # 
      # When we start, there is one more optimization: the result buffer
      # is implcitly one, so squaring it or multiplying by it can be
      # optimized away.  Further, if we start with a pattern like "100"
      # in the lookahead window, rather than placing n into the buffer
      # and then starting to square it, we have already computed n^2
      # to compute the odd-powers table, so we can place that into
      # the buffer and save a squaring.
      # 
      # This means that if you have a k-bit window, to compute n^z,
      # where z is the high k bits of the exponent, 1/2 of the time
      # it requires no squarings.  1/4 of the time, it requires 1
      # squaring, ... 1/2^(k-1) of the time, it reqires k-2 squarings.
      # And the remaining 1/2^(k-1) of the time, the top k bits are a
      # 1 followed by k-1 0 bits, so it again only requires k-2
      # squarings, not k-1.  The average of these is 1.  Add that
      # to the one squaring we have to do to compute the table,
      # and you'll see that a k-bit window saves k-2 squarings
      # as well as reducing the multiplies.  (It actually doesn't
      # hurt in the case k = 1, either.)
      # 
      # Special case for exponent of one
      if ((y == ONE))
        return self
      end
      # Special case for base of zero
      if ((@signum).equal?(0))
        return ZERO
      end
      base = @mag.clone
      exp = y.attr_mag
      mod_ = z.attr_mag
      mod_len = mod_.attr_length
      # Select an appropriate window size
      wbits = 0
      ebits = bit_length(exp, exp.attr_length)
      # if exponent is 65537 (0x10001), use minimum window size
      if ((!(ebits).equal?(17)) || (!(exp[0]).equal?(65537)))
        while (ebits > self.attr_bn_exp_mod_thresh_table[wbits])
          wbits += 1
        end
      end
      # Calculate appropriate table size
      tblmask = 1 << wbits
      # Allocate table for precomputed odd powers of base in Montgomery form
      table = Array.typed(Array.typed(::Java::Int)).new(tblmask) { nil }
      i = 0
      while i < tblmask
        table[i] = Array.typed(::Java::Int).new(mod_len) { 0 }
        i += 1
      end
      # Compute the modular inverse
      inv = -MutableBigInteger.inverse_mod32(mod_[mod_len - 1])
      # Convert base to Montgomery form
      a = left_shift(base, base.attr_length, mod_len << 5)
      q = MutableBigInteger.new
      r = MutableBigInteger.new
      a2 = MutableBigInteger.new(a)
      b2 = MutableBigInteger.new(mod_)
      a2.divide(b2, q, r)
      table[0] = r.to_int_array
      # Pad table[0] with leading zeros so its length is at least modLen
      if (table[0].attr_length < mod_len)
        offset = mod_len - table[0].attr_length
        t2 = Array.typed(::Java::Int).new(mod_len) { 0 }
        i_ = 0
        while i_ < table[0].attr_length
          t2[i_ + offset] = table[0][i_]
          i_ += 1
        end
        table[0] = t2
      end
      # Set b to the square of the base
      b = square_to_len(table[0], mod_len, nil)
      b = mont_reduce(b, mod_, mod_len, inv)
      # Set t to high half of b
      t = Array.typed(::Java::Int).new(mod_len) { 0 }
      i_ = 0
      while i_ < mod_len
        t[i_] = b[i_]
        i_ += 1
      end
      # Fill in the table with odd powers of the base
      i__ = 1
      while i__ < tblmask
        prod = multiply_to_len(t, mod_len, table[i__ - 1], mod_len, nil)
        table[i__] = mont_reduce(prod, mod_, mod_len, inv)
        i__ += 1
      end
      # Pre load the window that slides over the exponent
      bitpos = 1 << ((ebits - 1) & (32 - 1))
      buf = 0
      elen = exp.attr_length
      e_index = 0
      i___ = 0
      while i___ <= wbits
        buf = (buf << 1) | ((!((exp[e_index] & bitpos)).equal?(0)) ? 1 : 0)
        bitpos >>= 1
        if ((bitpos).equal?(0))
          e_index += 1
          bitpos = 1 << (32 - 1)
          elen -= 1
        end
        i___ += 1
      end
      multpos = ebits
      # The first iteration, which is hoisted out of the main loop
      ebits -= 1
      isone = true
      multpos = ebits - wbits
      while (((buf & 1)).equal?(0))
        buf >>= 1
        multpos += 1
      end
      mult = table[buf >> 1]
      buf = 0
      if ((multpos).equal?(ebits))
        isone = false
      end
      # The main loop
      while (true)
        ebits -= 1
        # Advance the window
        buf <<= 1
        if (!(elen).equal?(0))
          buf |= (!((exp[e_index] & bitpos)).equal?(0)) ? 1 : 0
          bitpos >>= 1
          if ((bitpos).equal?(0))
            e_index += 1
            bitpos = 1 << (32 - 1)
            elen -= 1
          end
        end
        # Examine the window for pending multiplies
        if (!((buf & tblmask)).equal?(0))
          multpos = ebits - wbits
          while (((buf & 1)).equal?(0))
            buf >>= 1
            multpos += 1
          end
          mult = table[buf >> 1]
          buf = 0
        end
        # Perform multiply
        if ((ebits).equal?(multpos))
          if (isone)
            b = mult.clone
            isone = false
          else
            t = b
            a = multiply_to_len(t, mod_len, mult, mod_len, a)
            a = mont_reduce(a, mod_, mod_len, inv)
            t = a
            a = b
            b = t
          end
        end
        # Check if done
        if ((ebits).equal?(0))
          break
        end
        # Square the input
        if (!isone)
          t = b
          a = square_to_len(t, mod_len, a)
          a = mont_reduce(a, mod_, mod_len, inv)
          t = a
          a = b
          b = t
        end
      end
      # Convert result out of Montgomery form and return
      t2 = Array.typed(::Java::Int).new(2 * mod_len) { 0 }
      i____ = 0
      while i____ < mod_len
        t2[i____ + mod_len] = b[i____]
        i____ += 1
      end
      b = mont_reduce(t2, mod_, mod_len, inv)
      t2 = Array.typed(::Java::Int).new(mod_len) { 0 }
      i_____ = 0
      while i_____ < mod_len
        t2[i_____] = b[i_____]
        i_____ += 1
      end
      return BigInteger.new(1, t2)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # Montgomery reduce n, modulo mod.  This reduces modulo mod and divides
      # by 2^(32*mlen). Adapted from Colin Plumb's C library.
      def mont_reduce(n, mod_, mlen, inv)
        c = 0
        len = mlen
        offset = 0
        begin
          n_end = n[n.attr_length - 1 - offset]
          carry = mul_add(n, mod_, offset, mlen, inv * n_end)
          c += add_one(n, offset, mlen, carry)
          offset += 1
        end while ((len -= 1) > 0)
        while (c > 0)
          c += sub_n(n, mod_, mlen)
        end
        while (int_array_cmp_to_len(n, mod_, mlen) >= 0)
          sub_n(n, mod_, mlen)
        end
        return n
      end
      
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Int] }
      # Returns -1, 0 or +1 as big-endian unsigned int array arg1 is less than,
      # equal to, or greater than arg2 up to length len.
      def int_array_cmp_to_len(arg1, arg2, len)
        i = 0
        while i < len
          b1 = arg1[i] & LONG_MASK
          b2 = arg2[i] & LONG_MASK
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
      
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Int] }
      # Subtracts two numbers of same length, returning borrow.
      def sub_n(a, b, len)
        sum = 0
        while ((len -= 1) >= 0)
          sum = (a[len] & LONG_MASK) - (b[len] & LONG_MASK) + (sum >> 32)
          a[len] = RJava.cast_to_int(sum)
        end
        return RJava.cast_to_int((sum >> 32))
      end
      
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Multiply an array by one word k and add to result, return the carry
      def mul_add(out, in_, offset, len, k)
        k_long = k & LONG_MASK
        carry = 0
        offset = out.attr_length - offset - 1
        j = len - 1
        while j >= 0
          product = (in_[j] & LONG_MASK) * k_long + (out[offset] & LONG_MASK) + carry
          out[((offset -= 1) + 1)] = RJava.cast_to_int(product)
          carry = product >> 32
          j -= 1
        end
        return RJava.cast_to_int(carry)
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Add one word to the number a mlen words into a. Return the resulting
      # carry.
      def add_one(a, offset, mlen, carry)
        offset = a.attr_length - 1 - mlen - offset
        t = (a[offset] & LONG_MASK) + (carry & LONG_MASK)
        a[offset] = RJava.cast_to_int(t)
        if (((t >> 32)).equal?(0))
          return 0
        end
        while ((mlen -= 1) >= 0)
          if ((offset -= 1) < 0)
            # Carry out of number
            return 1
          else
            a[offset] += 1
            if (!(a[offset]).equal?(0))
              return 0
            end
          end
        end
        return 1
      end
    }
    
    typesig { [BigInteger, ::Java::Int] }
    # Returns a BigInteger whose value is (this ** exponent) mod (2**p)
    def mod_pow2(exponent, p)
      # Perform exponentiation using repeated squaring trick, chopping off
      # high order bits as indicated by modulus.
      result = value_of(1)
      base_to_pow2 = self.mod2(p)
      exp_offset = 0
      limit = exponent.bit_length
      if (self.test_bit(0))
        limit = (p - 1) < limit ? (p - 1) : limit
      end
      while (exp_offset < limit)
        if (exponent.test_bit(exp_offset))
          result = result.multiply(base_to_pow2).mod2(p)
        end
        exp_offset += 1
        if (exp_offset < limit)
          base_to_pow2 = base_to_pow2.square.mod2(p)
        end
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # Returns a BigInteger whose value is this mod(2**p).
    # Assumes that this {@code BigInteger >= 0} and {@code p > 0}.
    def mod2(p)
      if (bit_length <= p)
        return self
      end
      # Copy remaining ints of mag
      num_ints = (p + 31) / 32
      mag = Array.typed(::Java::Int).new(num_ints) { 0 }
      i = 0
      while i < num_ints
        mag[i] = @mag[i + (@mag.attr_length - num_ints)]
        i += 1
      end
      # Mask out any excess bits
      excess_bits = (num_ints << 5) - p
      mag[0] &= (1 << (32 - excess_bits)) - 1
      return ((mag[0]).equal?(0) ? BigInteger.new(1, mag) : BigInteger.new(mag, 1))
    end
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this}<sup>-1</sup> {@code mod m)}.
    # 
    # @param  m the modulus.
    # @return {@code this}<sup>-1</sup> {@code mod m}.
    # @throws ArithmeticException {@code  m <= 0}, or this BigInteger
    # has no multiplicative inverse mod m (that is, this BigInteger
    # is not <i>relatively prime</i> to m).
    def mod_inverse(m)
      if (!(m.attr_signum).equal?(1))
        raise ArithmeticException.new("BigInteger: modulus not positive")
      end
      if ((m == ONE))
        return ZERO
      end
      # Calculate (this mod m)
      mod_val = self
      if (@signum < 0 || (int_array_cmp(@mag, m.attr_mag) >= 0))
        mod_val = self.mod(m)
      end
      if ((mod_val == ONE))
        return ONE
      end
      a = MutableBigInteger.new(mod_val)
      b = MutableBigInteger.new(m)
      result = a.mutable_mod_inverse(b)
      return BigInteger.new(result, 1)
    end
    
    typesig { [::Java::Int] }
    # Shift Operations
    # 
    # Returns a BigInteger whose value is {@code (this << n)}.
    # The shift distance, {@code n}, may be negative, in which case
    # this method performs a right shift.
    # (Computes <tt>floor(this * 2<sup>n</sup>)</tt>.)
    # 
    # @param  n shift distance, in bits.
    # @return {@code this << n}
    # @see #shiftRight
    def shift_left(n)
      if ((@signum).equal?(0))
        return ZERO
      end
      if ((n).equal?(0))
        return self
      end
      if (n < 0)
        return shift_right(-n)
      end
      n_ints = n >> 5
      n_bits = n & 0x1f
      mag_len = @mag.attr_length
      new_mag = nil
      if ((n_bits).equal?(0))
        new_mag = Array.typed(::Java::Int).new(mag_len + n_ints) { 0 }
        i = 0
        while i < mag_len
          new_mag[i] = @mag[i]
          i += 1
        end
      else
        i = 0
        n_bits2 = 32 - n_bits
        high_bits = @mag[0] >> n_bits2
        if (!(high_bits).equal?(0))
          new_mag = Array.typed(::Java::Int).new(mag_len + n_ints + 1) { 0 }
          new_mag[((i += 1) - 1)] = high_bits
        else
          new_mag = Array.typed(::Java::Int).new(mag_len + n_ints) { 0 }
        end
        j = 0
        while (j < mag_len - 1)
          new_mag[((i += 1) - 1)] = @mag[((j += 1) - 1)] << n_bits | @mag[j] >> n_bits2
        end
        new_mag[i] = @mag[j] << n_bits
      end
      return BigInteger.new(new_mag, @signum)
    end
    
    typesig { [::Java::Int] }
    # Returns a BigInteger whose value is {@code (this >> n)}.  Sign
    # extension is performed.  The shift distance, {@code n}, may be
    # negative, in which case this method performs a left shift.
    # (Computes <tt>floor(this / 2<sup>n</sup>)</tt>.)
    # 
    # @param  n shift distance, in bits.
    # @return {@code this >> n}
    # @see #shiftLeft
    def shift_right(n)
      if ((n).equal?(0))
        return self
      end
      if (n < 0)
        return shift_left(-n)
      end
      n_ints = n >> 5
      n_bits = n & 0x1f
      mag_len = @mag.attr_length
      new_mag = nil
      # Special case: entire contents shifted off the end
      if (n_ints >= mag_len)
        return (@signum >= 0 ? ZERO : self.attr_neg_const[1])
      end
      if ((n_bits).equal?(0))
        new_mag_len = mag_len - n_ints
        new_mag = Array.typed(::Java::Int).new(new_mag_len) { 0 }
        i = 0
        while i < new_mag_len
          new_mag[i] = @mag[i]
          i += 1
        end
      else
        i = 0
        high_bits = @mag[0] >> n_bits
        if (!(high_bits).equal?(0))
          new_mag = Array.typed(::Java::Int).new(mag_len - n_ints) { 0 }
          new_mag[((i += 1) - 1)] = high_bits
        else
          new_mag = Array.typed(::Java::Int).new(mag_len - n_ints - 1) { 0 }
        end
        n_bits2 = 32 - n_bits
        j = 0
        while (j < mag_len - n_ints - 1)
          new_mag[((i += 1) - 1)] = (@mag[((j += 1) - 1)] << n_bits2) | (@mag[j] >> n_bits)
        end
      end
      if (@signum < 0)
        # Find out whether any one-bits were shifted off the end.
        ones_lost = false
        i = mag_len - 1
        j = mag_len - n_ints
        while i >= j && !ones_lost
          ones_lost = (!(@mag[i]).equal?(0))
          i -= 1
        end
        if (!ones_lost && !(n_bits).equal?(0))
          ones_lost = (!(@mag[mag_len - n_ints - 1] << (32 - n_bits)).equal?(0))
        end
        if (ones_lost)
          new_mag = java_increment(new_mag)
        end
      end
      return BigInteger.new(new_mag, @signum)
    end
    
    typesig { [Array.typed(::Java::Int)] }
    def java_increment(val)
      last_sum = 0
      i = val.attr_length - 1
      while i >= 0 && (last_sum).equal?(0)
        last_sum = (val[i] += 1)
        i -= 1
      end
      if ((last_sum).equal?(0))
        val = Array.typed(::Java::Int).new(val.attr_length + 1) { 0 }
        val[0] = 1
      end
      return val
    end
    
    typesig { [BigInteger] }
    # Bitwise Operations
    # 
    # Returns a BigInteger whose value is {@code (this & val)}.  (This
    # method returns a negative BigInteger if and only if this and val are
    # both negative.)
    # 
    # @param val value to be AND'ed with this BigInteger.
    # @return {@code this & val}
    def and_(val)
      result = Array.typed(::Java::Int).new(Math.max(int_length, val.int_length)) { 0 }
      i = 0
      while i < result.attr_length
        result[i] = (get_int(result.attr_length - i - 1) & val.get_int(result.attr_length - i - 1))
        i += 1
      end
      return value_of(result)
    end
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this | val)}.  (This method
    # returns a negative BigInteger if and only if either this or val is
    # negative.)
    # 
    # @param val value to be OR'ed with this BigInteger.
    # @return {@code this | val}
    def or_(val)
      result = Array.typed(::Java::Int).new(Math.max(int_length, val.int_length)) { 0 }
      i = 0
      while i < result.attr_length
        result[i] = (get_int(result.attr_length - i - 1) | val.get_int(result.attr_length - i - 1))
        i += 1
      end
      return value_of(result)
    end
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this ^ val)}.  (This method
    # returns a negative BigInteger if and only if exactly one of this and
    # val are negative.)
    # 
    # @param val value to be XOR'ed with this BigInteger.
    # @return {@code this ^ val}
    def xor(val)
      result = Array.typed(::Java::Int).new(Math.max(int_length, val.int_length)) { 0 }
      i = 0
      while i < result.attr_length
        result[i] = (get_int(result.attr_length - i - 1) ^ val.get_int(result.attr_length - i - 1))
        i += 1
      end
      return value_of(result)
    end
    
    typesig { [] }
    # Returns a BigInteger whose value is {@code (~this)}.  (This method
    # returns a negative value if and only if this BigInteger is
    # non-negative.)
    # 
    # @return {@code ~this}
    def not_
      result = Array.typed(::Java::Int).new(int_length) { 0 }
      i = 0
      while i < result.attr_length
        result[i] = ~get_int(result.attr_length - i - 1)
        i += 1
      end
      return value_of(result)
    end
    
    typesig { [BigInteger] }
    # Returns a BigInteger whose value is {@code (this & ~val)}.  This
    # method, which is equivalent to {@code and(val.not())}, is provided as
    # a convenience for masking operations.  (This method returns a negative
    # BigInteger if and only if {@code this} is negative and {@code val} is
    # positive.)
    # 
    # @param val value to be complemented and AND'ed with this BigInteger.
    # @return {@code this & ~val}
    def and_not(val)
      result = Array.typed(::Java::Int).new(Math.max(int_length, val.int_length)) { 0 }
      i = 0
      while i < result.attr_length
        result[i] = (get_int(result.attr_length - i - 1) & ~val.get_int(result.attr_length - i - 1))
        i += 1
      end
      return value_of(result)
    end
    
    typesig { [::Java::Int] }
    # Single Bit Operations
    # 
    # Returns {@code true} if and only if the designated bit is set.
    # (Computes {@code ((this & (1<<n)) != 0)}.)
    # 
    # @param  n index of bit to test.
    # @return {@code true} if and only if the designated bit is set.
    # @throws ArithmeticException {@code n} is negative.
    def test_bit(n)
      if (n < 0)
        raise ArithmeticException.new("Negative bit address")
      end
      return !((get_int(n / 32) & (1 << (n % 32)))).equal?(0)
    end
    
    typesig { [::Java::Int] }
    # Returns a BigInteger whose value is equivalent to this BigInteger
    # with the designated bit set.  (Computes {@code (this | (1<<n))}.)
    # 
    # @param  n index of bit to set.
    # @return {@code this | (1<<n)}
    # @throws ArithmeticException {@code n} is negative.
    def set_bit(n)
      if (n < 0)
        raise ArithmeticException.new("Negative bit address")
      end
      int_num = n / 32
      result = Array.typed(::Java::Int).new(Math.max(int_length, int_num + 2)) { 0 }
      i = 0
      while i < result.attr_length
        result[result.attr_length - i - 1] = get_int(i)
        i += 1
      end
      result[result.attr_length - int_num - 1] |= (1 << (n % 32))
      return value_of(result)
    end
    
    typesig { [::Java::Int] }
    # Returns a BigInteger whose value is equivalent to this BigInteger
    # with the designated bit cleared.
    # (Computes {@code (this & ~(1<<n))}.)
    # 
    # @param  n index of bit to clear.
    # @return {@code this & ~(1<<n)}
    # @throws ArithmeticException {@code n} is negative.
    def clear_bit(n)
      if (n < 0)
        raise ArithmeticException.new("Negative bit address")
      end
      int_num = n / 32
      result = Array.typed(::Java::Int).new(Math.max(int_length, (n + 1) / 32 + 1)) { 0 }
      i = 0
      while i < result.attr_length
        result[result.attr_length - i - 1] = get_int(i)
        i += 1
      end
      result[result.attr_length - int_num - 1] &= ~(1 << (n % 32))
      return value_of(result)
    end
    
    typesig { [::Java::Int] }
    # Returns a BigInteger whose value is equivalent to this BigInteger
    # with the designated bit flipped.
    # (Computes {@code (this ^ (1<<n))}.)
    # 
    # @param  n index of bit to flip.
    # @return {@code this ^ (1<<n)}
    # @throws ArithmeticException {@code n} is negative.
    def flip_bit(n)
      if (n < 0)
        raise ArithmeticException.new("Negative bit address")
      end
      int_num = n / 32
      result = Array.typed(::Java::Int).new(Math.max(int_length, int_num + 2)) { 0 }
      i = 0
      while i < result.attr_length
        result[result.attr_length - i - 1] = get_int(i)
        i += 1
      end
      result[result.attr_length - int_num - 1] ^= (1 << (n % 32))
      return value_of(result)
    end
    
    typesig { [] }
    # Returns the index of the rightmost (lowest-order) one bit in this
    # BigInteger (the number of zero bits to the right of the rightmost
    # one bit).  Returns -1 if this BigInteger contains no one bits.
    # (Computes {@code (this==0? -1 : log2(this & -this))}.)
    # 
    # @return index of the rightmost one bit in this BigInteger.
    def get_lowest_set_bit
      # Initialize lowestSetBit field the first time this method is
      # executed. This method depends on the atomicity of int modifies;
      # without this guarantee, it would have to be synchronized.
      if ((@lowest_set_bit).equal?(-2))
        if ((@signum).equal?(0))
          @lowest_set_bit = -1
        else
          # Search for lowest order nonzero int
          i = 0
          b = 0
          i = 0
          while ((b = get_int(i))).equal?(0)
            i += 1
          end
          @lowest_set_bit = (i << 5) + trailing_zero_cnt(b)
        end
      end
      return @lowest_set_bit
    end
    
    typesig { [] }
    # Miscellaneous Bit Operations
    # 
    # Returns the number of bits in the minimal two's-complement
    # representation of this BigInteger, <i>excluding</i> a sign bit.
    # For positive BigIntegers, this is equivalent to the number of bits in
    # the ordinary binary representation.  (Computes
    # {@code (ceil(log2(this < 0 ? -this : this+1)))}.)
    # 
    # @return number of bits in the minimal two's-complement
    # representation of this BigInteger, <i>excluding</i> a sign bit.
    def bit_length
      # Initialize bitLength field the first time this method is executed.
      # This method depends on the atomicity of int modifies; without
      # this guarantee, it would have to be synchronized.
      if ((@bit_length).equal?(-1))
        if ((@signum).equal?(0))
          @bit_length = 0
        else
          # Calculate the bit length of the magnitude
          mag_bit_length = ((@mag.attr_length - 1) << 5) + bit_len(@mag[0])
          if (@signum < 0)
            # Check if magnitude is a power of two
            pow2 = ((bit_cnt(@mag[0])).equal?(1))
            i = 1
            while i < @mag.attr_length && pow2
              pow2 = ((@mag[i]).equal?(0))
              i += 1
            end
            @bit_length = (pow2 ? mag_bit_length - 1 : mag_bit_length)
          else
            @bit_length = mag_bit_length
          end
        end
      end
      return @bit_length
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # bitLen(val) is the number of bits in val.
      def bit_len(w)
        # Binary search - decision tree (5 tests, rarely 6)
        return (w < 1 << 15 ? (w < 1 << 7 ? (w < 1 << 3 ? (w < 1 << 1 ? (w < 1 << 0 ? (w < 0 ? 32 : 0) : 1) : (w < 1 << 2 ? 2 : 3)) : (w < 1 << 5 ? (w < 1 << 4 ? 4 : 5) : (w < 1 << 6 ? 6 : 7))) : (w < 1 << 11 ? (w < 1 << 9 ? (w < 1 << 8 ? 8 : 9) : (w < 1 << 10 ? 10 : 11)) : (w < 1 << 13 ? (w < 1 << 12 ? 12 : 13) : (w < 1 << 14 ? 14 : 15)))) : (w < 1 << 23 ? (w < 1 << 19 ? (w < 1 << 17 ? (w < 1 << 16 ? 16 : 17) : (w < 1 << 18 ? 18 : 19)) : (w < 1 << 21 ? (w < 1 << 20 ? 20 : 21) : (w < 1 << 22 ? 22 : 23))) : (w < 1 << 27 ? (w < 1 << 25 ? (w < 1 << 24 ? 24 : 25) : (w < 1 << 26 ? 26 : 27)) : (w < 1 << 29 ? (w < 1 << 28 ? 28 : 29) : (w < 1 << 30 ? 30 : 31)))))
      end
      
      # trailingZeroTable[i] is the number of trailing zero bits in the binary
      # representation of i.
      const_set_lazy(:TrailingZeroTable) { Array.typed(::Java::Byte).new([-25, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 5, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 6, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 5, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 7, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 5, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 6, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 5, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0, 4, 0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 2, 0, 1, 0]) }
      const_attr_reader  :TrailingZeroTable
    }
    
    typesig { [] }
    # Returns the number of bits in the two's complement representation
    # of this BigInteger that differ from its sign bit.  This method is
    # useful when implementing bit-vector style sets atop BigIntegers.
    # 
    # @return number of bits in the two's complement representation
    # of this BigInteger that differ from its sign bit.
    def bit_count
      # Initialize bitCount field the first time this method is executed.
      # This method depends on the atomicity of int modifies; without
      # this guarantee, it would have to be synchronized.
      if ((@bit_count).equal?(-1))
        # Count the bits in the magnitude
        mag_bit_count = 0
        i = 0
        while i < @mag.attr_length
          mag_bit_count += bit_cnt(@mag[i])
          i += 1
        end
        if (@signum < 0)
          # Count the trailing zeros in the magnitude
          mag_trailing_zero_count = 0
          j = 0
          j = @mag.attr_length - 1
          while (@mag[j]).equal?(0)
            mag_trailing_zero_count += 32
            j -= 1
          end
          mag_trailing_zero_count += trailing_zero_cnt(@mag[j])
          @bit_count = mag_bit_count + mag_trailing_zero_count - 1
        else
          @bit_count = mag_bit_count
        end
      end
      return @bit_count
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def bit_cnt(val)
        val -= (-0x55555556 & val) >> 1
        val = (val & 0x33333333) + ((val >> 2) & 0x33333333)
        val = val + (val >> 4) & 0xf0f0f0f
        val += val >> 8
        val += val >> 16
        return val & 0xff
      end
      
      typesig { [::Java::Int] }
      def trailing_zero_cnt(val)
        # Loop unrolled for performance
        byte_val = val & 0xff
        if (!(byte_val).equal?(0))
          return TrailingZeroTable[byte_val]
        end
        byte_val = (val >> 8) & 0xff
        if (!(byte_val).equal?(0))
          return TrailingZeroTable[byte_val] + 8
        end
        byte_val = (val >> 16) & 0xff
        if (!(byte_val).equal?(0))
          return TrailingZeroTable[byte_val] + 16
        end
        byte_val = (val >> 24) & 0xff
        return TrailingZeroTable[byte_val] + 24
      end
    }
    
    typesig { [::Java::Int] }
    # Primality Testing
    # 
    # Returns {@code true} if this BigInteger is probably prime,
    # {@code false} if it's definitely composite.  If
    # {@code certainty} is {@code  <= 0}, {@code true} is
    # returned.
    # 
    # @param  certainty a measure of the uncertainty that the caller is
    # willing to tolerate: if the call returns {@code true}
    # the probability that this BigInteger is prime exceeds
    # (1 - 1/2<sup>{@code certainty}</sup>).  The execution time of
    # this method is proportional to the value of this parameter.
    # @return {@code true} if this BigInteger is probably prime,
    # {@code false} if it's definitely composite.
    def is_probable_prime(certainty)
      if (certainty <= 0)
        return true
      end
      w = self.abs
      if ((w == TWO))
        return true
      end
      if (!w.test_bit(0) || (w == ONE))
        return false
      end
      return w.prime_to_certainty(certainty, nil)
    end
    
    typesig { [BigInteger] }
    # Comparison Operations
    # 
    # Compares this BigInteger with the specified BigInteger.  This
    # method is provided in preference to individual methods for each
    # of the six boolean comparison operators ({@literal <}, ==,
    # {@literal >}, {@literal >=}, !=, {@literal <=}).  The suggested
    # idiom for performing these comparisons is: {@code
    # (x.compareTo(y)} &lt;<i>op</i>&gt; {@code 0)}, where
    # &lt;<i>op</i>&gt; is one of the six comparison operators.
    # 
    # @param  val BigInteger to which this BigInteger is to be compared.
    # @return -1, 0 or 1 as this BigInteger is numerically less than, equal
    # to, or greater than {@code val}.
    def compare_to(val)
      return ((@signum).equal?(val.attr_signum) ? @signum * int_array_cmp(@mag, val.attr_mag) : (@signum > val.attr_signum ? 1 : -1))
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int)] }
      # Returns -1, 0 or +1 as big-endian unsigned int array arg1 is
      # less than, equal to, or greater than arg2.
      def int_array_cmp(arg1, arg2)
        if (arg1.attr_length < arg2.attr_length)
          return -1
        end
        if (arg1.attr_length > arg2.attr_length)
          return 1
        end
        # Argument lengths are equal; compare the values
        i = 0
        while i < arg1.attr_length
          b1 = arg1[i] & LONG_MASK
          b2 = arg2[i] & LONG_MASK
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
    }
    
    typesig { [Object] }
    # Compares this BigInteger with the specified Object for equality.
    # 
    # @param  x Object to which this BigInteger is to be compared.
    # @return {@code true} if and only if the specified Object is a
    # BigInteger whose value is numerically equal to this BigInteger.
    def ==(x)
      # This test is just an optimization, which may or may not help
      if ((x).equal?(self))
        return true
      end
      if (!(x.is_a?(BigInteger)))
        return false
      end
      x_int = x
      if (!(x_int.attr_signum).equal?(@signum) || !(x_int.attr_mag.attr_length).equal?(@mag.attr_length))
        return false
      end
      i = 0
      while i < @mag.attr_length
        if (!(x_int.attr_mag[i]).equal?(@mag[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [BigInteger] }
    # Returns the minimum of this BigInteger and {@code val}.
    # 
    # @param  val value with which the minimum is to be computed.
    # @return the BigInteger whose value is the lesser of this BigInteger and
    # {@code val}.  If they are equal, either may be returned.
    def min(val)
      return (compare_to(val) < 0 ? self : val)
    end
    
    typesig { [BigInteger] }
    # Returns the maximum of this BigInteger and {@code val}.
    # 
    # @param  val value with which the maximum is to be computed.
    # @return the BigInteger whose value is the greater of this and
    # {@code val}.  If they are equal, either may be returned.
    def max(val)
      return (compare_to(val) > 0 ? self : val)
    end
    
    typesig { [] }
    # Hash Function
    # 
    # Returns the hash code for this BigInteger.
    # 
    # @return hash code for this BigInteger.
    def hash_code
      hash_code = 0
      i = 0
      while i < @mag.attr_length
        hash_code = RJava.cast_to_int((31 * hash_code + (@mag[i] & LONG_MASK)))
        i += 1
      end
      return hash_code * @signum
    end
    
    typesig { [::Java::Int] }
    # Returns the String representation of this BigInteger in the
    # given radix.  If the radix is outside the range from {@link
    # Character#MIN_RADIX} to {@link Character#MAX_RADIX} inclusive,
    # it will default to 10 (as is the case for
    # {@code Integer.toString}).  The digit-to-character mapping
    # provided by {@code Character.forDigit} is used, and a minus
    # sign is prepended if appropriate.  (This representation is
    # compatible with the {@link #BigInteger(String, int) (String,
    # int)} constructor.)
    # 
    # @param  radix  radix of the String representation.
    # @return String representation of this BigInteger in the given radix.
    # @see    Integer#toString
    # @see    Character#forDigit
    # @see    #BigInteger(java.lang.String, int)
    def to_s(radix)
      if ((@signum).equal?(0))
        return "0"
      end
      if (radix < Character::MIN_RADIX || radix > Character::MAX_RADIX)
        radix = 10
      end
      # Compute upper bound on number of digit groups and allocate space
      max_num_digit_groups = (4 * @mag.attr_length + 6) / 7
      digit_group = Array.typed(String).new(max_num_digit_groups) { nil }
      # Translate number to string, a digit group at a time
      tmp = self.abs
      num_groups = 0
      while (!(tmp.attr_signum).equal?(0))
        d = self.attr_long_radix[radix]
        q = MutableBigInteger.new
        r = MutableBigInteger.new
        a = MutableBigInteger.new(tmp.attr_mag)
        b = MutableBigInteger.new(d.attr_mag)
        a.divide(b, q, r)
        q2 = BigInteger.new(q, tmp.attr_signum * d.attr_signum)
        r2 = BigInteger.new(r, tmp.attr_signum * d.attr_signum)
        digit_group[((num_groups += 1) - 1)] = Long.to_s(r2.long_value, radix)
        tmp = q2
      end
      # Put sign (if any) and first digit group into result buffer
      buf = StringBuilder.new(num_groups * self.attr_digits_per_long[radix] + 1)
      if (@signum < 0)
        buf.append(Character.new(?-.ord))
      end
      buf.append(digit_group[num_groups - 1])
      # Append remaining digit groups padded with leading zeros
      i = num_groups - 2
      while i >= 0
        # Prepend (any) leading zeros for this digit group
        num_leading_zeros = self.attr_digits_per_long[radix] - digit_group[i].length
        if (!(num_leading_zeros).equal?(0))
          buf.append(self.attr_zeros[num_leading_zeros])
        end
        buf.append(digit_group[i])
        i -= 1
      end
      return buf.to_s
    end
    
    class_module.module_eval {
      # zero[i] is a string of i consecutive zeros.
      
      def zeros
        defined?(@@zeros) ? @@zeros : @@zeros= Array.typed(String).new(64) { nil }
      end
      alias_method :attr_zeros, :zeros
      
      def zeros=(value)
        @@zeros = value
      end
      alias_method :attr_zeros=, :zeros=
      
      when_class_loaded do
        self.attr_zeros[63] = "000000000000000000000000000000000000000000000000000000000000000"
        i = 0
        while i < 63
          self.attr_zeros[i] = self.attr_zeros[63].substring(0, i)
          i += 1
        end
      end
    }
    
    typesig { [] }
    # Returns the decimal String representation of this BigInteger.
    # The digit-to-character mapping provided by
    # {@code Character.forDigit} is used, and a minus sign is
    # prepended if appropriate.  (This representation is compatible
    # with the {@link #BigInteger(String) (String)} constructor, and
    # allows for String concatenation with Java's + operator.)
    # 
    # @return decimal String representation of this BigInteger.
    # @see    Character#forDigit
    # @see    #BigInteger(java.lang.String)
    def to_s
      return to_s(10)
    end
    
    typesig { [] }
    # Returns a byte array containing the two's-complement
    # representation of this BigInteger.  The byte array will be in
    # <i>big-endian</i> byte-order: the most significant byte is in
    # the zeroth element.  The array will contain the minimum number
    # of bytes required to represent this BigInteger, including at
    # least one sign bit, which is {@code (ceil((this.bitLength() +
    # 1)/8))}.  (This representation is compatible with the
    # {@link #BigInteger(byte[]) (byte[])} constructor.)
    # 
    # @return a byte array containing the two's-complement representation of
    # this BigInteger.
    # @see    #BigInteger(byte[])
    def to_byte_array
      byte_len = bit_length / 8 + 1
      byte_array = Array.typed(::Java::Byte).new(byte_len) { 0 }
      i = byte_len - 1
      bytes_copied = 4
      next_int_ = 0
      int_index = 0
      while i >= 0
        if ((bytes_copied).equal?(4))
          next_int_ = get_int(((int_index += 1) - 1))
          bytes_copied = 1
        else
          next_int_ >>= 8
          bytes_copied += 1
        end
        byte_array[i] = next_int_
        i -= 1
      end
      return byte_array
    end
    
    typesig { [] }
    # Converts this BigInteger to an {@code int}.  This
    # conversion is analogous to a <a
    # href="http://java.sun.com/docs/books/jls/second_edition/html/conversions.doc.html#25363"><i>narrowing
    # primitive conversion</i></a> from {@code long} to
    # {@code int} as defined in the <a
    # href="http://java.sun.com/docs/books/jls/html/">Java Language
    # Specification</a>: if this BigInteger is too big to fit in an
    # {@code int}, only the low-order 32 bits are returned.
    # Note that this conversion can lose information about the
    # overall magnitude of the BigInteger value as well as return a
    # result with the opposite sign.
    # 
    # @return this BigInteger converted to an {@code int}.
    def int_value
      result = 0
      result = get_int(0)
      return result
    end
    
    typesig { [] }
    # Converts this BigInteger to a {@code long}.  This
    # conversion is analogous to a <a
    # href="http://java.sun.com/docs/books/jls/second_edition/html/conversions.doc.html#25363"><i>narrowing
    # primitive conversion</i></a> from {@code long} to
    # {@code int} as defined in the <a
    # href="http://java.sun.com/docs/books/jls/html/">Java Language
    # Specification</a>: if this BigInteger is too big to fit in a
    # {@code long}, only the low-order 64 bits are returned.
    # Note that this conversion can lose information about the
    # overall magnitude of the BigInteger value as well as return a
    # result with the opposite sign.
    # 
    # @return this BigInteger converted to a {@code long}.
    def long_value
      result = 0
      i = 1
      while i >= 0
        result = (result << 32) + (get_int(i) & LONG_MASK)
        i -= 1
      end
      return result
    end
    
    typesig { [] }
    # Converts this BigInteger to a {@code float}.  This
    # conversion is similar to the <a
    # href="http://java.sun.com/docs/books/jls/second_edition/html/conversions.doc.html#25363"><i>narrowing
    # primitive conversion</i></a> from {@code double} to
    # {@code float} defined in the <a
    # href="http://java.sun.com/docs/books/jls/html/">Java Language
    # Specification</a>: if this BigInteger has too great a magnitude
    # to represent as a {@code float}, it will be converted to
    # {@link Float#NEGATIVE_INFINITY} or {@link
    # Float#POSITIVE_INFINITY} as appropriate.  Note that even when
    # the return value is finite, this conversion can lose
    # information about the precision of the BigInteger value.
    # 
    # @return this BigInteger converted to a {@code float}.
    def float_value
      # Somewhat inefficient, but guaranteed to work.
      return Float.parse_float(self.to_s)
    end
    
    typesig { [] }
    # Converts this BigInteger to a {@code double}.  This
    # conversion is similar to the <a
    # href="http://java.sun.com/docs/books/jls/second_edition/html/conversions.doc.html#25363"><i>narrowing
    # primitive conversion</i></a> from {@code double} to
    # {@code float} defined in the <a
    # href="http://java.sun.com/docs/books/jls/html/">Java Language
    # Specification</a>: if this BigInteger has too great a magnitude
    # to represent as a {@code double}, it will be converted to
    # {@link Double#NEGATIVE_INFINITY} or {@link
    # Double#POSITIVE_INFINITY} as appropriate.  Note that even when
    # the return value is finite, this conversion can lose
    # information about the precision of the BigInteger value.
    # 
    # @return this BigInteger converted to a {@code double}.
    def double_value
      # Somewhat inefficient, but guaranteed to work.
      return Double.parse_double(self.to_s)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int)] }
      # Returns a copy of the input array stripped of any leading zero bytes.
      def strip_leading_zero_ints(val)
        byte_length = val.attr_length
        keep = 0
        # Find first nonzero byte
        keep = 0
        while keep < val.attr_length && (val[keep]).equal?(0)
          keep += 1
        end
        result = Array.typed(::Java::Int).new(val.attr_length - keep) { 0 }
        i = 0
        while i < val.attr_length - keep
          result[i] = val[keep + i]
          i += 1
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Int)] }
      # Returns the input array stripped of any leading zero bytes.
      # Since the source is trusted the copying may be skipped.
      def trusted_strip_leading_zero_ints(val)
        byte_length = val.attr_length
        keep = 0
        # Find first nonzero byte
        keep = 0
        while keep < val.attr_length && (val[keep]).equal?(0)
          keep += 1
        end
        # Only perform copy if necessary
        if (keep > 0)
          result = Array.typed(::Java::Int).new(val.attr_length - keep) { 0 }
          i = 0
          while i < val.attr_length - keep
            result[i] = val[keep + i]
            i += 1
          end
          return result
        end
        return val
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Returns a copy of the input array stripped of any leading zero bytes.
      def strip_leading_zero_bytes(a)
        byte_length = a.attr_length
        keep = 0
        # Find first nonzero byte
        keep = 0
        while keep < a.attr_length && (a[keep]).equal?(0)
          keep += 1
        end
        # Allocate new array and copy relevant part of input array
        int_length_ = ((byte_length - keep) + 3) / 4
        result = Array.typed(::Java::Int).new(int_length_) { 0 }
        b = byte_length - 1
        i = int_length_ - 1
        while i >= 0
          result[i] = a[((b -= 1) + 1)] & 0xff
          bytes_remaining = b - keep + 1
          bytes_to_transfer = Math.min(3, bytes_remaining)
          j = 8
          while j <= 8 * bytes_to_transfer
            result[i] |= ((a[((b -= 1) + 1)] & 0xff) << j)
            j += 8
          end
          i -= 1
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Takes an array a representing a negative 2's-complement number and
      # returns the minimal (no leading zero bytes) unsigned whose value is -a.
      def make_positive(a)
        keep = 0
        k = 0
        byte_length = a.attr_length
        # Find first non-sign (0xff) byte of input
        keep = 0
        while keep < byte_length && (a[keep]).equal?(-1)
          keep += 1
        end
        # Allocate output array.  If all non-sign bytes are 0x00, we must
        # allocate space for one extra output byte.
        k = keep
        while k < byte_length && (a[k]).equal?(0)
          k += 1
        end
        extra_byte = ((k).equal?(byte_length)) ? 1 : 0
        int_length_ = ((byte_length - keep + extra_byte) + 3) / 4
        result = Array.typed(::Java::Int).new(int_length_) { 0 }
        # Copy one's complement of input into output, leaving extra
        # byte (if it exists) == 0x00
        b = byte_length - 1
        i = int_length_ - 1
        while i >= 0
          result[i] = a[((b -= 1) + 1)] & 0xff
          num_bytes_to_transfer = Math.min(3, b - keep + 1)
          if (num_bytes_to_transfer < 0)
            num_bytes_to_transfer = 0
          end
          j = 8
          while j <= 8 * num_bytes_to_transfer
            result[i] |= ((a[((b -= 1) + 1)] & 0xff) << j)
            j += 8
          end
          # Mask indicates which bits must be complemented
          mask = -1 >> (8 * (3 - num_bytes_to_transfer))
          result[i] = ~result[i] & mask
          i -= 1
        end
        # Add one to one's complement to generate two's complement
        i_ = result.attr_length - 1
        while i_ >= 0
          result[i_] = RJava.cast_to_int(((result[i_] & LONG_MASK) + 1))
          if (!(result[i_]).equal?(0))
            break
          end
          i_ -= 1
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Int)] }
      # Takes an array a representing a negative 2's-complement number and
      # returns the minimal (no leading zero ints) unsigned whose value is -a.
      def make_positive(a)
        keep = 0
        j = 0
        # Find first non-sign (0xffffffff) int of input
        keep = 0
        while keep < a.attr_length && (a[keep]).equal?(-1)
          keep += 1
        end
        # Allocate output array.  If all non-sign ints are 0x00, we must
        # allocate space for one extra output int.
        j = keep
        while j < a.attr_length && (a[j]).equal?(0)
          j += 1
        end
        extra_int = ((j).equal?(a.attr_length) ? 1 : 0)
        result = Array.typed(::Java::Int).new(a.attr_length - keep + extra_int) { 0 }
        # Copy one's complement of input into output, leaving extra
        # int (if it exists) == 0x00
        i = keep
        while i < a.attr_length
          result[i - keep + extra_int] = ~a[i]
          i += 1
        end
        # Add one to one's complement to generate two's complement
        i_ = result.attr_length - 1
        while ((result[i_] += 1)).equal?(0)
          i_ -= 1
        end
        return result
      end
      
      # The following two arrays are used for fast String conversions.  Both
      # are indexed by radix.  The first is the number of digits of the given
      # radix that can fit in a Java long without "going negative", i.e., the
      # highest integer n such that radix**n < 2**63.  The second is the
      # "long radix" that tears each number into "long digits", each of which
      # consists of the number of digits in the corresponding element in
      # digitsPerLong (longRadix[i] = i**digitPerLong[i]).  Both arrays have
      # nonsense values in their 0 and 1 elements, as radixes 0 and 1 are not
      # used.
      
      def digits_per_long
        defined?(@@digits_per_long) ? @@digits_per_long : @@digits_per_long= Array.typed(::Java::Int).new([0, 0, 62, 39, 31, 27, 24, 22, 20, 19, 18, 18, 17, 17, 16, 16, 15, 15, 15, 14, 14, 14, 14, 13, 13, 13, 13, 13, 13, 12, 12, 12, 12, 12, 12, 12, 12])
      end
      alias_method :attr_digits_per_long, :digits_per_long
      
      def digits_per_long=(value)
        @@digits_per_long = value
      end
      alias_method :attr_digits_per_long=, :digits_per_long=
      
      
      def long_radix
        defined?(@@long_radix) ? @@long_radix : @@long_radix= Array.typed(BigInteger).new([nil, nil, value_of(0x4000000000000000), value_of(0x383d9170b85ff80b), value_of(0x4000000000000000), value_of(0x6765c793fa10079d), value_of(0x41c21cb8e1000000), value_of(0x3642798750226111), value_of(0x1000000000000000), value_of(0x12bf307ae81ffd59), value_of(0xde0b6b3a7640000), value_of(0x4d28cb56c33fa539), value_of(0x1eca170c00000000), value_of(0x780c7372621bd74d), value_of(0x1e39a5057d810000), value_of(0x5b27ac993df97701), value_of(0x1000000000000000), value_of(0x27b95e997e21d9f1), value_of(0x5da0e1e53c5c8000), value_of(0xb16a458ef403f19), value_of(0x16bcc41e90000000), value_of(0x2d04b7fdd9c0ef49), value_of(0x5658597bcaa24000), value_of(0x6feb266931a75b7), value_of(0xc29e98000000000), value_of(0x14adf4b7320334b9), value_of(0x226ed36478bfa000), value_of(0x383d9170b85ff80b), value_of(0x5a3c23e39c000000), value_of(0x4e900abb53e6b71), value_of(0x7600ec618141000), value_of(0xaee5720ee830681), value_of(0x1000000000000000), value_of(0x172588ad4f5f0981), value_of(0x211e44f7d02c1000), value_of(0x2ee56725f06e5c71), value_of(0x41c21cb8e1000000)])
      end
      alias_method :attr_long_radix, :long_radix
      
      def long_radix=(value)
        @@long_radix = value
      end
      alias_method :attr_long_radix=, :long_radix=
      
      # These two arrays are the integer analogue of above.
      
      def digits_per_int
        defined?(@@digits_per_int) ? @@digits_per_int : @@digits_per_int= Array.typed(::Java::Int).new([0, 0, 30, 19, 15, 13, 11, 11, 10, 9, 9, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5])
      end
      alias_method :attr_digits_per_int, :digits_per_int
      
      def digits_per_int=(value)
        @@digits_per_int = value
      end
      alias_method :attr_digits_per_int=, :digits_per_int=
      
      
      def int_radix
        defined?(@@int_radix) ? @@int_radix : @@int_radix= Array.typed(::Java::Int).new([0, 0, 0x40000000, 0x4546b3db, 0x40000000, 0x48c27395, 0x159fd800, 0x75db9c97, 0x40000000, 0x17179149, 0x3b9aca00, 0xcc6db61, 0x19a10000, 0x309f1021, 0x57f6c100, 0xa2f1b6f, 0x10000000, 0x18754571, 0x247dbc80, 0x3547667b, 0x4c4b4000, 0x6b5a6e1d, 0x6c20a40, 0x8d2d931, 0xb640000, 0xe8d4a51, 0x1269ae40, 0x17179149, 0x1cb91000, 0x23744899, 0x2b73a840, 0x34e63b41, 0x40000000, 0x4cfa3cc1, 0x5c13d840, 0x6d91b519, 0x39aa400])
      end
      alias_method :attr_int_radix, :int_radix
      
      def int_radix=(value)
        @@int_radix = value
      end
      alias_method :attr_int_radix=, :int_radix=
    }
    
    typesig { [] }
    # These routines provide access to the two's complement representation
    # of BigIntegers.
    # 
    # 
    # Returns the length of the two's complement representation in ints,
    # including space for at least one sign bit.
    def int_length
      return bit_length / 32 + 1
    end
    
    typesig { [] }
    # Returns sign bit
    def sign_bit
      return @signum < 0 ? 1 : 0
    end
    
    typesig { [] }
    # Returns an int of sign bits
    def sign_int
      return @signum < 0 ? -1 : 0
    end
    
    typesig { [::Java::Int] }
    # Returns the specified int of the little-endian two's complement
    # representation (int 0 is the least significant).  The int number can
    # be arbitrarily high (values are logically preceded by infinitely many
    # sign ints).
    def get_int(n)
      if (n < 0)
        return 0
      end
      if (n >= @mag.attr_length)
        return sign_int
      end
      mag_int = @mag[@mag.attr_length - n - 1]
      return (@signum >= 0 ? mag_int : (n <= first_nonzero_int_num ? -mag_int : ~mag_int))
    end
    
    typesig { [] }
    # Returns the index of the int that contains the first nonzero int in the
    # little-endian binary representation of the magnitude (int 0 is the
    # least significant). If the magnitude is zero, return value is undefined.
    def first_nonzero_int_num
      # Initialize firstNonzeroIntNum field the first time this method is
      # executed. This method depends on the atomicity of int modifies;
      # without this guarantee, it would have to be synchronized.
      if ((@first_nonzero_int_num).equal?(-2))
        # Search for the first nonzero int
        i = 0
        i = @mag.attr_length - 1
        while i >= 0 && (@mag[i]).equal?(0)
          i -= 1
        end
        @first_nonzero_int_num = @mag.attr_length - i - 1
      end
      return @first_nonzero_int_num
    end
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { -8287574255936472291 }
      const_attr_reader  :SerialVersionUID
      
      # Serializable fields for BigInteger.
      # 
      # @serialField signum  int
      # signum of this BigInteger.
      # @serialField magnitude int[]
      # magnitude array of this BigInteger.
      # @serialField bitCount  int
      # number of bits in this BigInteger
      # @serialField bitLength int
      # the number of bits in the minimal two's-complement
      # representation of this BigInteger
      # @serialField lowestSetBit int
      # lowest set bit in the twos complement representation
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("signum", JavaInteger::TYPE), ObjectStreamField.new("magnitude", Array), ObjectStreamField.new("bitCount", JavaInteger::TYPE), ObjectStreamField.new("bitLength", JavaInteger::TYPE), ObjectStreamField.new("firstNonzeroByteNum", JavaInteger::TYPE), ObjectStreamField.new("lowestSetBit", JavaInteger::TYPE)]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the {@code BigInteger} instance from a stream (that is,
    # deserialize it). The magnitude is read in as an array of bytes
    # for historical reasons, but it is converted to an array of ints
    # and the byte array is discarded.
    def read_object(s)
      # In order to maintain compatibility with previous serialized forms,
      # the magnitude of a BigInteger is serialized as an array of bytes.
      # The magnitude field is used as a temporary store for the byte array
      # that is deserialized. The cached computation fields should be
      # transient but are serialized for compatibility reasons.
      # 
      # prepare to read the alternate persistent fields
      fields = s.read_fields
      # Read the alternate persistent fields that we care about
      @signum = fields.get("signum", -2)
      magnitude = fields.get("magnitude", nil)
      # Validate signum
      if (@signum < -1 || @signum > 1)
        message = "BigInteger: Invalid signum value"
        if (fields.defaulted("signum"))
          message = "BigInteger: Signum not present in stream"
        end
        raise Java::Io::StreamCorruptedException.new(message)
      end
      if (!(((magnitude.attr_length).equal?(0))).equal?(((@signum).equal?(0))))
        message = "BigInteger: signum-magnitude mismatch"
        if (fields.defaulted("magnitude"))
          message = "BigInteger: Magnitude not present in stream"
        end
        raise Java::Io::StreamCorruptedException.new(message)
      end
      # Set "cached computation" fields to their initial values
      @bit_count = @bit_length = -1
      @lowest_set_bit = @first_nonzero_byte_num = @first_nonzero_int_num = -2
      # Calculate mag field from magnitude and discard magnitude
      @mag = strip_leading_zero_bytes(magnitude)
    end
    
    typesig { [ObjectOutputStream] }
    # Save the {@code BigInteger} instance to a stream.
    # The magnitude of a BigInteger is serialized as a byte array for
    # historical reasons.
    # 
    # @serialData two necessary fields are written as well as obsolete
    # fields for compatibility with older versions.
    def write_object(s)
      # set the values of the Serializable fields
      fields = s.put_fields
      fields.put("signum", @signum)
      fields.put("magnitude", mag_serialized_form)
      fields.put("bitCount", -1)
      fields.put("bitLength", -1)
      fields.put("lowestSetBit", -2)
      fields.put("firstNonzeroByteNum", -2)
      # save them
      s.write_fields
    end
    
    typesig { [] }
    # Returns the mag array as an array of bytes.
    def mag_serialized_form
      bit_len_ = ((@mag.attr_length).equal?(0) ? 0 : ((@mag.attr_length - 1) << 5) + bit_len(@mag[0]))
      byte_len = (bit_len_ + 7) / 8
      result = Array.typed(::Java::Byte).new(byte_len) { 0 }
      i = byte_len - 1
      bytes_copied = 4
      int_index = @mag.attr_length - 1
      next_int_ = 0
      while i >= 0
        if ((bytes_copied).equal?(4))
          next_int_ = @mag[((int_index -= 1) + 1)]
          bytes_copied = 1
        else
          next_int_ >>= 8
          bytes_copied += 1
        end
        result[i] = next_int_
        i -= 1
      end
      return result
    end
    
    private
    alias_method :initialize__big_integer, :initialize
  end
  
end
