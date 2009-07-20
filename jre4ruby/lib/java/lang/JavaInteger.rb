require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module IntegerImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The {@code Integer} class wraps a value of the primitive type
  # {@code int} in an object. An object of type {@code Integer}
  # contains a single field whose type is {@code int}.
  # 
  # <p>In addition, this class provides several methods for converting
  # an {@code int} to a {@code String} and a {@code String} to an
  # {@code int}, as well as other constants and methods useful when
  # dealing with an {@code int}.
  # 
  # <p>Implementation note: The implementations of the "bit twiddling"
  # methods (such as {@link #highestOneBit(int) highestOneBit} and
  # {@link #numberOfTrailingZeros(int) numberOfTrailingZeros}) are
  # based on material from Henry S. Warren, Jr.'s <i>Hacker's
  # Delight</i>, (Addison Wesley, 2002).
  # 
  # @author  Lee Boynton
  # @author  Arthur van Hoff
  # @author  Josh Bloch
  # @author  Joseph D. Darcy
  # @since JDK1.0
  class JavaInteger < IntegerImports.const_get :Numeric
    include_class_members IntegerImports
    include JavaComparable
    
    class_module.module_eval {
      # A constant holding the minimum value an {@code int} can
      # have, -2<sup>31</sup>.
      const_set_lazy(:MIN_VALUE) { -0x80000000 }
      const_attr_reader  :MIN_VALUE
      
      # A constant holding the maximum value an {@code int} can
      # have, 2<sup>31</sup>-1.
      const_set_lazy(:MAX_VALUE) { 0x7fffffff }
      const_attr_reader  :MAX_VALUE
      
      # The {@code Class} instance representing the primitive type
      # {@code int}.
      # 
      # @since   JDK1.1
      const_set_lazy(:TYPE) { Class.get_primitive_class("int") }
      const_attr_reader  :TYPE
      
      # All possible chars for representing a number as a String
      const_set_lazy(:Digits) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord), Character.new(?g.ord), Character.new(?h.ord), Character.new(?i.ord), Character.new(?j.ord), Character.new(?k.ord), Character.new(?l.ord), Character.new(?m.ord), Character.new(?n.ord), Character.new(?o.ord), Character.new(?p.ord), Character.new(?q.ord), Character.new(?r.ord), Character.new(?s.ord), Character.new(?t.ord), Character.new(?u.ord), Character.new(?v.ord), Character.new(?w.ord), Character.new(?x.ord), Character.new(?y.ord), Character.new(?z.ord)]) }
      const_attr_reader  :Digits
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns a string representation of the first argument in the
      # radix specified by the second argument.
      # 
      # <p>If the radix is smaller than {@code Character.MIN_RADIX}
      # or larger than {@code Character.MAX_RADIX}, then the radix
      # {@code 10} is used instead.
      # 
      # <p>If the first argument is negative, the first element of the
      # result is the ASCII minus character {@code '-'}
      # (<code>'&#92;u002D'</code>). If the first argument is not
      # negative, no sign character appears in the result.
      # 
      # <p>The remaining characters of the result represent the magnitude
      # of the first argument. If the magnitude is zero, it is
      # represented by a single zero character {@code '0'}
      # (<code>'&#92;u0030'</code>); otherwise, the first character of
      # the representation of the magnitude will not be the zero
      # character.  The following ASCII characters are used as digits:
      # 
      # <blockquote>
      # {@code 0123456789abcdefghijklmnopqrstuvwxyz}
      # </blockquote>
      # 
      # These are <code>'&#92;u0030'</code> through
      # <code>'&#92;u0039'</code> and <code>'&#92;u0061'</code> through
      # <code>'&#92;u007A'</code>. If {@code radix} is
      # <var>N</var>, then the first <var>N</var> of these characters
      # are used as radix-<var>N</var> digits in the order shown. Thus,
      # the digits for hexadecimal (radix 16) are
      # {@code 0123456789abcdef}. If uppercase letters are
      # desired, the {@link java.lang.String#toUpperCase()} method may
      # be called on the result:
      # 
      # <blockquote>
      # {@code Integer.toString(n, 16).toUpperCase()}
      # </blockquote>
      # 
      # @param   i       an integer to be converted to a string.
      # @param   radix   the radix to use in the string representation.
      # @return  a string representation of the argument in the specified radix.
      # @see     java.lang.Character#MAX_RADIX
      # @see     java.lang.Character#MIN_RADIX
      def to_s(i, radix)
        if (radix < Character::MIN_RADIX || radix > Character::MAX_RADIX)
          radix = 10
        end
        # Use the faster version
        if ((radix).equal?(10))
          return to_s(i)
        end
        buf = CharArray.new(33)
        negative = (i < 0)
        char_pos = 32
        if (!negative)
          i = -i
        end
        while (i <= -radix)
          buf[((char_pos -= 1) + 1)] = Digits[-(i % radix)]
          i = i / radix
        end
        buf[char_pos] = Digits[-i]
        if (negative)
          buf[(char_pos -= 1)] = Character.new(?-.ord)
        end
        return String.new(buf, char_pos, (33 - char_pos))
      end
      
      typesig { [::Java::Int] }
      # Returns a string representation of the integer argument as an
      # unsigned integer in base&nbsp;16.
      # 
      # <p>The unsigned integer value is the argument plus 2<sup>32</sup>
      # if the argument is negative; otherwise, it is equal to the
      # argument.  This value is converted to a string of ASCII digits
      # in hexadecimal (base&nbsp;16) with no extra leading
      # {@code 0}s. If the unsigned magnitude is zero, it is
      # represented by a single zero character {@code '0'}
      # (<code>'&#92;u0030'</code>); otherwise, the first character of
      # the representation of the unsigned magnitude will not be the
      # zero character. The following characters are used as
      # hexadecimal digits:
      # 
      # <blockquote>
      # {@code 0123456789abcdef}
      # </blockquote>
      # 
      # These are the characters <code>'&#92;u0030'</code> through
      # <code>'&#92;u0039'</code> and <code>'&#92;u0061'</code> through
      # <code>'&#92;u0066'</code>. If uppercase letters are
      # desired, the {@link java.lang.String#toUpperCase()} method may
      # be called on the result:
      # 
      # <blockquote>
      # {@code Integer.toHexString(n).toUpperCase()}
      # </blockquote>
      # 
      # @param   i   an integer to be converted to a string.
      # @return  the string representation of the unsigned integer value
      # represented by the argument in hexadecimal (base&nbsp;16).
      # @since   JDK1.0.2
      def to_hex_string(i)
        return to_unsigned_string(i, 4)
      end
      
      typesig { [::Java::Int] }
      # Returns a string representation of the integer argument as an
      # unsigned integer in base&nbsp;8.
      # 
      # <p>The unsigned integer value is the argument plus 2<sup>32</sup>
      # if the argument is negative; otherwise, it is equal to the
      # argument.  This value is converted to a string of ASCII digits
      # in octal (base&nbsp;8) with no extra leading {@code 0}s.
      # 
      # <p>If the unsigned magnitude is zero, it is represented by a
      # single zero character {@code '0'}
      # (<code>'&#92;u0030'</code>); otherwise, the first character of
      # the representation of the unsigned magnitude will not be the
      # zero character. The following characters are used as octal
      # digits:
      # 
      # <blockquote>
      # {@code 01234567}
      # </blockquote>
      # 
      # These are the characters <code>'&#92;u0030'</code> through
      # <code>'&#92;u0037'</code>.
      # 
      # @param   i   an integer to be converted to a string.
      # @return  the string representation of the unsigned integer value
      # represented by the argument in octal (base&nbsp;8).
      # @since   JDK1.0.2
      def to_octal_string(i)
        return to_unsigned_string(i, 3)
      end
      
      typesig { [::Java::Int] }
      # Returns a string representation of the integer argument as an
      # unsigned integer in base&nbsp;2.
      # 
      # <p>The unsigned integer value is the argument plus 2<sup>32</sup>
      # if the argument is negative; otherwise it is equal to the
      # argument.  This value is converted to a string of ASCII digits
      # in binary (base&nbsp;2) with no extra leading {@code 0}s.
      # If the unsigned magnitude is zero, it is represented by a
      # single zero character {@code '0'}
      # (<code>'&#92;u0030'</code>); otherwise, the first character of
      # the representation of the unsigned magnitude will not be the
      # zero character. The characters {@code '0'}
      # (<code>'&#92;u0030'</code>) and {@code '1'}
      # (<code>'&#92;u0031'</code>) are used as binary digits.
      # 
      # @param   i   an integer to be converted to a string.
      # @return  the string representation of the unsigned integer value
      # represented by the argument in binary (base&nbsp;2).
      # @since   JDK1.0.2
      def to_binary_string(i)
        return to_unsigned_string(i, 1)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Convert the integer to an unsigned number.
      def to_unsigned_string(i, shift)
        buf = CharArray.new(32)
        char_pos = 32
        radix = 1 << shift
        mask = radix - 1
        begin
          buf[(char_pos -= 1)] = Digits[i & mask]
          i >>= shift
        end while (!(i).equal?(0))
        return String.new(buf, char_pos, (32 - char_pos))
      end
      
      const_set_lazy(:DigitTens) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), Character.new(?9.ord), ]) }
      const_attr_reader  :DigitTens
      
      const_set_lazy(:DigitOnes) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), ]) }
      const_attr_reader  :DigitOnes
      
      typesig { [::Java::Int] }
      # I use the "invariant division by multiplication" trick to
      # accelerate Integer.toString.  In particular we want to
      # avoid division by 10.
      # 
      # The "trick" has roughly the same performance characteristics
      # as the "classic" Integer.toString code on a non-JIT VM.
      # The trick avoids .rem and .div calls but has a longer code
      # path and is thus dominated by dispatch overhead.  In the
      # JIT case the dispatch overhead doesn't exist and the
      # "trick" is considerably faster than the classic code.
      # 
      # TODO-FIXME: convert (x * 52429) into the equiv shift-add
      # sequence.
      # 
      # RE:  Division by Invariant Integers using Multiplication
      # T Gralund, P Montgomery
      # ACM PLDI 1994
      # 
      # 
      # Returns a {@code String} object representing the
      # specified integer. The argument is converted to signed decimal
      # representation and returned as a string, exactly as if the
      # argument and radix 10 were given as arguments to the {@link
      # #toString(int, int)} method.
      # 
      # @param   i   an integer to be converted.
      # @return  a string representation of the argument in base&nbsp;10.
      def to_s(i)
        if ((i).equal?(JavaInteger::MIN_VALUE))
          return "-2147483648"
        end
        size = (i < 0) ? string_size(-i) + 1 : string_size(i)
        buf = CharArray.new(size)
        get_chars(i, size, buf)
        return String.new(0, size, buf)
      end
      
      typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
      # Places characters representing the integer i into the
      # character array buf. The characters are placed into
      # the buffer backwards starting with the least significant
      # digit at the specified index (exclusive), and working
      # backwards from there.
      # 
      # Will fail if i == Integer.MIN_VALUE
      def get_chars(i, index, buf)
        q = 0
        r = 0
        char_pos = index
        sign = 0
        if (i < 0)
          sign = Character.new(?-.ord)
          i = -i
        end
        # Generate two digits per iteration
        while (i >= 65536)
          q = i / 100
          # really: r = i - (q * 100);
          r = i - ((q << 6) + (q << 5) + (q << 2))
          i = q
          buf[(char_pos -= 1)] = DigitOnes[r]
          buf[(char_pos -= 1)] = DigitTens[r]
        end
        # Fall thru to fast mode for smaller numbers
        # assert(i <= 65536, i);
        loop do
          q = (i * 52429) >> (16 + 3)
          r = i - ((q << 3) + (q << 1)) # r = i-(q*10) ...
          buf[(char_pos -= 1)] = Digits[r]
          i = q
          if ((i).equal?(0))
            break
          end
        end
        if (!(sign).equal?(0))
          buf[(char_pos -= 1)] = sign
        end
      end
      
      const_set_lazy(:SizeTable) { Array.typed(::Java::Int).new([9, 99, 999, 9999, 99999, 999999, 9999999, 99999999, 999999999, JavaInteger::MAX_VALUE]) }
      const_attr_reader  :SizeTable
      
      typesig { [::Java::Int] }
      # Requires positive x
      def string_size(x)
        i = 0
        loop do
          if (x <= SizeTable[i])
            return i + 1
          end
          i += 1
        end
      end
      
      typesig { [String, ::Java::Int] }
      # Parses the string argument as a signed integer in the radix
      # specified by the second argument. The characters in the string
      # must all be digits of the specified radix (as determined by
      # whether {@link java.lang.Character#digit(char, int)} returns a
      # nonnegative value), except that the first character may be an
      # ASCII minus sign {@code '-'} (<code>'&#92;u002D'</code>) to
      # indicate a negative value. The resulting integer value is
      # returned.
      # 
      # <p>An exception of type {@code NumberFormatException} is
      # thrown if any of the following situations occurs:
      # <ul>
      # <li>The first argument is {@code null} or is a string of
      # length zero.
      # 
      # <li>The radix is either smaller than
      # {@link java.lang.Character#MIN_RADIX} or
      # larger than {@link java.lang.Character#MAX_RADIX}.
      # 
      # <li>Any character of the string is not a digit of the specified
      # radix, except that the first character may be a minus sign
      # {@code '-'} (<code>'&#92;u002D'</code>) provided that the
      # string is longer than length 1.
      # 
      # <li>The value represented by the string is not a value of type
      # {@code int}.
      # </ul>
      # 
      # <p>Examples:
      # <blockquote><pre>
      # parseInt("0", 10) returns 0
      # parseInt("473", 10) returns 473
      # parseInt("-0", 10) returns 0
      # parseInt("-FF", 16) returns -255
      # parseInt("1100110", 2) returns 102
      # parseInt("2147483647", 10) returns 2147483647
      # parseInt("-2147483648", 10) returns -2147483648
      # parseInt("2147483648", 10) throws a NumberFormatException
      # parseInt("99", 8) throws a NumberFormatException
      # parseInt("Kona", 10) throws a NumberFormatException
      # parseInt("Kona", 27) returns 411787
      # </pre></blockquote>
      # 
      # @param      s   the {@code String} containing the integer
      # representation to be parsed
      # @param      radix   the radix to be used while parsing {@code s}.
      # @return     the integer represented by the string argument in the
      # specified radix.
      # @exception  NumberFormatException if the {@code String}
      # does not contain a parsable {@code int}.
      def parse_int(s, radix)
        if ((s).nil?)
          raise NumberFormatException.new("null")
        end
        if (radix < Character::MIN_RADIX)
          raise NumberFormatException.new("radix " + (radix).to_s + " less than Character.MIN_RADIX")
        end
        if (radix > Character::MAX_RADIX)
          raise NumberFormatException.new("radix " + (radix).to_s + " greater than Character.MAX_RADIX")
        end
        result = 0
        negative = false
        i = 0
        len = s.length
        limit = -JavaInteger::MAX_VALUE
        multmin = 0
        digit = 0
        if (len > 0)
          first_char = s.char_at(0)
          if (first_char < Character.new(?0.ord))
            # Possible leading "-"
            if ((first_char).equal?(Character.new(?-.ord)))
              negative = true
              limit = JavaInteger::MIN_VALUE
            else
              raise NumberFormatException.for_input_string(s)
            end
            if ((len).equal?(1))
              # Cannot have lone "-"
              raise NumberFormatException.for_input_string(s)
            end
            i += 1
          end
          multmin = limit / radix
          while (i < len)
            # Accumulating negatively avoids surprises near MAX_VALUE
            digit = Character.digit(s.char_at(((i += 1) - 1)), radix)
            if (digit < 0)
              raise NumberFormatException.for_input_string(s)
            end
            if (result < multmin)
              raise NumberFormatException.for_input_string(s)
            end
            result *= radix
            if (result < limit + digit)
              raise NumberFormatException.for_input_string(s)
            end
            result -= digit
          end
        else
          raise NumberFormatException.for_input_string(s)
        end
        return negative ? result : -result
      end
      
      typesig { [String] }
      # Parses the string argument as a signed decimal integer. The
      # characters in the string must all be decimal digits, except
      # that the first character may be an ASCII minus sign {@code '-'}
      # (<code>'&#92;u002D'</code>) to indicate a negative value.  The
      # resulting integer value is returned, exactly as if the argument
      # and the radix 10 were given as arguments to the {@link
      # #parseInt(java.lang.String, int)} method.
      # 
      # @param s    a {@code String} containing the {@code int}
      # representation to be parsed
      # @return     the integer value represented by the argument in decimal.
      # @exception  NumberFormatException  if the string does not contain a
      # parsable integer.
      def parse_int(s)
        return parse_int(s, 10)
      end
      
      typesig { [String, ::Java::Int] }
      # Returns an {@code Integer} object holding the value
      # extracted from the specified {@code String} when parsed
      # with the radix given by the second argument. The first argument
      # is interpreted as representing a signed integer in the radix
      # specified by the second argument, exactly as if the arguments
      # were given to the {@link #parseInt(java.lang.String, int)}
      # method. The result is an {@code Integer} object that
      # represents the integer value specified by the string.
      # 
      # <p>In other words, this method returns an {@code Integer}
      # object equal to the value of:
      # 
      # <blockquote>
      # {@code new Integer(Integer.parseInt(s, radix))}
      # </blockquote>
      # 
      # @param      s   the string to be parsed.
      # @param      radix the radix to be used in interpreting {@code s}
      # @return     an {@code Integer} object holding the value
      # represented by the string argument in the specified
      # radix.
      # @exception NumberFormatException if the {@code String}
      # does not contain a parsable {@code int}.
      def value_of(s, radix)
        return parse_int(s, radix)
      end
      
      typesig { [String] }
      # Returns an {@code Integer} object holding the
      # value of the specified {@code String}. The argument is
      # interpreted as representing a signed decimal integer, exactly
      # as if the argument were given to the {@link
      # #parseInt(java.lang.String)} method. The result is an
      # {@code Integer} object that represents the integer value
      # specified by the string.
      # 
      # <p>In other words, this method returns an {@code Integer}
      # object equal to the value of:
      # 
      # <blockquote>
      # {@code new Integer(Integer.parseInt(s))}
      # </blockquote>
      # 
      # @param      s   the string to be parsed.
      # @return     an {@code Integer} object holding the value
      # represented by the string argument.
      # @exception  NumberFormatException  if the string cannot be parsed
      # as an integer.
      def value_of(s)
        return parse_int(s, 10)
      end
      
      const_set_lazy(:IntegerCache) { Class.new do
        include_class_members JavaInteger
        
        typesig { [] }
        def initialize
        end
        
        class_module.module_eval {
          const_set_lazy(:Cache) { Array.typed(JavaInteger).new(-(-128) + 127 + 1) { nil } }
          const_attr_reader  :Cache
          
          when_class_loaded do
            i = 0
            while i < self.class::Cache.attr_length
              self.class::Cache[i] = i - 128
              i += 1
            end
          end
        }
        
        private
        alias_method :initialize__integer_cache, :initialize
      end }
      
      typesig { [::Java::Int] }
      # Returns an {@code Integer} instance representing the specified
      # {@code int} value.  If a new {@code Integer} instance is not
      # required, this method should generally be used in preference to
      # the constructor {@link #Integer(int)}, as this method is likely
      # to yield significantly better space and time performance by
      # caching frequently requested values.
      # 
      # @param  i an {@code int} value.
      # @return an {@code Integer} instance representing {@code i}.
      # @since  1.5
      def value_of(i)
        offset = 128
        if (i >= -128 && i <= 127)
          # must cache
          return IntegerCache.attr_cache[i + offset]
        end
        return i
      end
    }
    
    # The value of the {@code Integer}.
    # 
    # @serial
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [::Java::Int] }
    # Constructs a newly allocated {@code Integer} object that
    # represents the specified {@code int} value.
    # 
    # @param   value   the value to be represented by the
    # {@code Integer} object.
    def initialize(value)
      @value = 0
      super()
      @value = value
    end
    
    typesig { [String] }
    # Constructs a newly allocated {@code Integer} object that
    # represents the {@code int} value indicated by the
    # {@code String} parameter. The string is converted to an
    # {@code int} value in exactly the manner used by the
    # {@code parseInt} method for radix 10.
    # 
    # @param      s   the {@code String} to be converted to an
    # {@code Integer}.
    # @exception  NumberFormatException  if the {@code String} does not
    # contain a parsable integer.
    # @see        java.lang.Integer#parseInt(java.lang.String, int)
    def initialize(s)
      @value = 0
      super()
      @value = parse_int(s, 10)
    end
    
    typesig { [] }
    # Returns the value of this {@code Integer} as a
    # {@code byte}.
    def byte_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Integer} as a
    # {@code short}.
    def short_value
      return RJava.cast_to_short(@value)
    end
    
    typesig { [] }
    # Returns the value of this {@code Integer} as an
    # {@code int}.
    def int_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Integer} as a
    # {@code long}.
    def long_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Integer} as a
    # {@code float}.
    def float_value
      return (@value).to_f
    end
    
    typesig { [] }
    # Returns the value of this {@code Integer} as a
    # {@code double}.
    def double_value
      return (@value).to_f
    end
    
    typesig { [] }
    # Returns a {@code String} object representing this
    # {@code Integer}'s value. The value is converted to signed
    # decimal representation and returned as a string, exactly as if
    # the integer value were given as an argument to the {@link
    # java.lang.Integer#toString(int)} method.
    # 
    # @return  a string representation of the value of this object in
    # base&nbsp;10.
    def to_s
      return String.value_of(@value)
    end
    
    typesig { [] }
    # Returns a hash code for this {@code Integer}.
    # 
    # @return  a hash code value for this object, equal to the
    # primitive {@code int} value represented by this
    # {@code Integer} object.
    def hash_code
      return @value
    end
    
    typesig { [Object] }
    # Compares this object to the specified object.  The result is
    # {@code true} if and only if the argument is not
    # {@code null} and is an {@code Integer} object that
    # contains the same {@code int} value as this object.
    # 
    # @param   obj   the object to compare with.
    # @return  {@code true} if the objects are the same;
    # {@code false} otherwise.
    def equals(obj)
      if (obj.is_a?(JavaInteger))
        return (@value).equal?((obj).int_value)
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Determines the integer value of the system property with the
      # specified name.
      # 
      # <p>The first argument is treated as the name of a system property.
      # System properties are accessible through the
      # {@link java.lang.System#getProperty(java.lang.String)} method. The
      # string value of this property is then interpreted as an integer
      # value and an {@code Integer} object representing this value is
      # returned. Details of possible numeric formats can be found with
      # the definition of {@code getProperty}.
      # 
      # <p>If there is no property with the specified name, if the specified name
      # is empty or {@code null}, or if the property does not have
      # the correct numeric format, then {@code null} is returned.
      # 
      # <p>In other words, this method returns an {@code Integer}
      # object equal to the value of:
      # 
      # <blockquote>
      # {@code getInteger(nm, null)}
      # </blockquote>
      # 
      # @param   nm   property name.
      # @return  the {@code Integer} value of the property.
      # @see     java.lang.System#getProperty(java.lang.String)
      # @see     java.lang.System#getProperty(java.lang.String, java.lang.String)
      def get_integer(nm)
        return get_integer(nm, nil)
      end
      
      typesig { [String, ::Java::Int] }
      # Determines the integer value of the system property with the
      # specified name.
      # 
      # <p>The first argument is treated as the name of a system property.
      # System properties are accessible through the {@link
      # java.lang.System#getProperty(java.lang.String)} method. The
      # string value of this property is then interpreted as an integer
      # value and an {@code Integer} object representing this value is
      # returned. Details of possible numeric formats can be found with
      # the definition of {@code getProperty}.
      # 
      # <p>The second argument is the default value. An {@code Integer} object
      # that represents the value of the second argument is returned if there
      # is no property of the specified name, if the property does not have
      # the correct numeric format, or if the specified name is empty or
      # {@code null}.
      # 
      # <p>In other words, this method returns an {@code Integer} object
      # equal to the value of:
      # 
      # <blockquote>
      # {@code getInteger(nm, new Integer(val))}
      # </blockquote>
      # 
      # but in practice it may be implemented in a manner such as:
      # 
      # <blockquote><pre>
      # Integer result = getInteger(nm, null);
      # return (result == null) ? new Integer(val) : result;
      # </pre></blockquote>
      # 
      # to avoid the unnecessary allocation of an {@code Integer}
      # object when the default value is not needed.
      # 
      # @param   nm   property name.
      # @param   val   default value.
      # @return  the {@code Integer} value of the property.
      # @see     java.lang.System#getProperty(java.lang.String)
      # @see     java.lang.System#getProperty(java.lang.String, java.lang.String)
      def get_integer(nm, val)
        result = get_integer(nm, nil)
        return ((result).nil?) ? val : result
      end
      
      typesig { [String, JavaInteger] }
      # Returns the integer value of the system property with the
      # specified name.  The first argument is treated as the name of a
      # system property.  System properties are accessible through the
      # {@link java.lang.System#getProperty(java.lang.String)} method.
      # The string value of this property is then interpreted as an
      # integer value, as per the {@code Integer.decode} method,
      # and an {@code Integer} object representing this value is
      # returned.
      # 
      # <ul><li>If the property value begins with the two ASCII characters
      # {@code 0x} or the ASCII character {@code #}, not
      # followed by a minus sign, then the rest of it is parsed as a
      # hexadecimal integer exactly as by the method
      # {@link #valueOf(java.lang.String, int)} with radix 16.
      # <li>If the property value begins with the ASCII character
      # {@code 0} followed by another character, it is parsed as an
      # octal integer exactly as by the method
      # {@link #valueOf(java.lang.String, int)} with radix 8.
      # <li>Otherwise, the property value is parsed as a decimal integer
      # exactly as by the method {@link #valueOf(java.lang.String, int)}
      # with radix 10.
      # </ul>
      # 
      # <p>The second argument is the default value. The default value is
      # returned if there is no property of the specified name, if the
      # property does not have the correct numeric format, or if the
      # specified name is empty or {@code null}.
      # 
      # @param   nm   property name.
      # @param   val   default value.
      # @return  the {@code Integer} value of the property.
      # @see     java.lang.System#getProperty(java.lang.String)
      # @see java.lang.System#getProperty(java.lang.String, java.lang.String)
      # @see java.lang.Integer#decode
      def get_integer(nm, val)
        v = nil
        begin
          v = (System.get_property(nm)).to_s
        rescue IllegalArgumentException => e
        rescue NullPointerException => e
        end
        if (!(v).nil?)
          begin
            return JavaInteger.decode(v)
          rescue NumberFormatException => e
          end
        end
        return val
      end
      
      typesig { [String] }
      # Decodes a {@code String} into an {@code Integer}.
      # Accepts decimal, hexadecimal, and octal numbers given
      # by the following grammar:
      # 
      # <blockquote>
      # <dl>
      # <dt><i>DecodableString:</i>
      # <dd><i>Sign<sub>opt</sub> DecimalNumeral</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code 0x} <i>HexDigits</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code 0X} <i>HexDigits</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code #} <i>HexDigits</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code 0} <i>OctalDigits</i>
      # <p>
      # <dt><i>Sign:</i>
      # <dd>{@code -}
      # </dl>
      # </blockquote>
      # 
      # <i>DecimalNumeral</i>, <i>HexDigits</i>, and <i>OctalDigits</i>
      # are defined in <a href="http://java.sun.com/docs/books/jls/second_edition/html/lexical.doc.html#48282">&sect;3.10.1</a>
      # of the <a href="http://java.sun.com/docs/books/jls/html/">Java
      # Language Specification</a>.
      # 
      # <p>The sequence of characters following an (optional) negative
      # sign and/or radix specifier ("{@code 0x}", "{@code 0X}",
      # "{@code #}", or leading zero) is parsed as by the {@code
      # Integer.parseInt} method with the indicated radix (10, 16, or
      # 8).  This sequence of characters must represent a positive
      # value or a {@link NumberFormatException} will be thrown.  The
      # result is negated if first character of the specified {@code
      # String} is the minus sign.  No whitespace characters are
      # permitted in the {@code String}.
      # 
      # @param     nm the {@code String} to decode.
      # @return    an {@code Integer} object holding the {@code int}
      # value represented by {@code nm}
      # @exception NumberFormatException  if the {@code String} does not
      # contain a parsable integer.
      # @see java.lang.Integer#parseInt(java.lang.String, int)
      def decode(nm)
        radix = 10
        index = 0
        negative = false
        result = nil
        if ((nm.length).equal?(0))
          raise NumberFormatException.new("Zero length string")
        end
        first_char = nm.char_at(0)
        # Handle sign, if present
        if ((first_char).equal?(Character.new(?-.ord)))
          negative = true
          index += 1
        end
        # Handle radix specifier, if present
        if (nm.starts_with("0x", index) || nm.starts_with("0X", index))
          index += 2
          radix = 16
        else
          if (nm.starts_with("#", index))
            index += 1
            radix = 16
          else
            if (nm.starts_with("0", index) && nm.length > 1 + index)
              index += 1
              radix = 8
            end
          end
        end
        if (nm.starts_with("-", index))
          raise NumberFormatException.new("Sign character in wrong position")
        end
        begin
          result = JavaInteger.value_of(nm.substring(index), radix)
          result = negative ? -result.int_value : result
        rescue NumberFormatException => e
          # If number is Integer.MIN_VALUE, we'll end up here. The next line
          # handles this case, and causes any genuine format error to be
          # rethrown.
          constant = negative ? ("-" + (nm.substring(index)).to_s) : nm.substring(index)
          result = JavaInteger.value_of(constant, radix)
        end
        return result
      end
    }
    
    typesig { [JavaInteger] }
    # Compares two {@code Integer} objects numerically.
    # 
    # @param   anotherInteger   the {@code Integer} to be compared.
    # @return  the value {@code 0} if this {@code Integer} is
    # equal to the argument {@code Integer}; a value less than
    # {@code 0} if this {@code Integer} is numerically less
    # than the argument {@code Integer}; and a value greater
    # than {@code 0} if this {@code Integer} is numerically
    # greater than the argument {@code Integer} (signed
    # comparison).
    # @since   1.2
    def compare_to(another_integer)
      this_val = @value
      another_val = another_integer.attr_value
      return (this_val < another_val ? -1 : ((this_val).equal?(another_val) ? 0 : 1))
    end
    
    class_module.module_eval {
      # Bit twiddling
      # 
      # The number of bits used to represent an {@code int} value in two's
      # complement binary form.
      # 
      # @since 1.5
      const_set_lazy(:SIZE) { 32 }
      const_attr_reader  :SIZE
      
      typesig { [::Java::Int] }
      # Returns an {@code int} value with at most a single one-bit, in the
      # position of the highest-order ("leftmost") one-bit in the specified
      # {@code int} value.  Returns zero if the specified value has no
      # one-bits in its two's complement binary representation, that is, if it
      # is equal to zero.
      # 
      # @return an {@code int} value with a single one-bit, in the position
      # of the highest-order one-bit in the specified value, or zero if
      # the specified value is itself equal to zero.
      # @since 1.5
      def highest_one_bit(i)
        # HD, Figure 3-1
        i |= (i >> 1)
        i |= (i >> 2)
        i |= (i >> 4)
        i |= (i >> 8)
        i |= (i >> 16)
        return i - (i >> 1)
      end
      
      typesig { [::Java::Int] }
      # Returns an {@code int} value with at most a single one-bit, in the
      # position of the lowest-order ("rightmost") one-bit in the specified
      # {@code int} value.  Returns zero if the specified value has no
      # one-bits in its two's complement binary representation, that is, if it
      # is equal to zero.
      # 
      # @return an {@code int} value with a single one-bit, in the position
      # of the lowest-order one-bit in the specified value, or zero if
      # the specified value is itself equal to zero.
      # @since 1.5
      def lowest_one_bit(i)
        # HD, Section 2-1
        return i & -i
      end
      
      typesig { [::Java::Int] }
      # Returns the number of zero bits preceding the highest-order
      # ("leftmost") one-bit in the two's complement binary representation
      # of the specified {@code int} value.  Returns 32 if the
      # specified value has no one-bits in its two's complement representation,
      # in other words if it is equal to zero.
      # 
      # <p>Note that this method is closely related to the logarithm base 2.
      # For all positive {@code int} values x:
      # <ul>
      # <li>floor(log<sub>2</sub>(x)) = {@code 31 - numberOfLeadingZeros(x)}
      # <li>ceil(log<sub>2</sub>(x)) = {@code 32 - numberOfLeadingZeros(x - 1)}
      # </ul>
      # 
      # @return the number of zero bits preceding the highest-order
      # ("leftmost") one-bit in the two's complement binary representation
      # of the specified {@code int} value, or 32 if the value
      # is equal to zero.
      # @since 1.5
      def number_of_leading_zeros(i)
        # HD, Figure 5-6
        if ((i).equal?(0))
          return 32
        end
        n = 1
        if ((i >> 16).equal?(0))
          n += 16
          i <<= 16
        end
        if ((i >> 24).equal?(0))
          n += 8
          i <<= 8
        end
        if ((i >> 28).equal?(0))
          n += 4
          i <<= 4
        end
        if ((i >> 30).equal?(0))
          n += 2
          i <<= 2
        end
        n -= i >> 31
        return n
      end
      
      typesig { [::Java::Int] }
      # Returns the number of zero bits following the lowest-order ("rightmost")
      # one-bit in the two's complement binary representation of the specified
      # {@code int} value.  Returns 32 if the specified value has no
      # one-bits in its two's complement representation, in other words if it is
      # equal to zero.
      # 
      # @return the number of zero bits following the lowest-order ("rightmost")
      # one-bit in the two's complement binary representation of the
      # specified {@code int} value, or 32 if the value is equal
      # to zero.
      # @since 1.5
      def number_of_trailing_zeros(i)
        # HD, Figure 5-14
        y = 0
        if ((i).equal?(0))
          return 32
        end
        n = 31
        y = i << 16
        if (!(y).equal?(0))
          n = n - 16
          i = y
        end
        y = i << 8
        if (!(y).equal?(0))
          n = n - 8
          i = y
        end
        y = i << 4
        if (!(y).equal?(0))
          n = n - 4
          i = y
        end
        y = i << 2
        if (!(y).equal?(0))
          n = n - 2
          i = y
        end
        return n - ((i << 1) >> 31)
      end
      
      typesig { [::Java::Int] }
      # Returns the number of one-bits in the two's complement binary
      # representation of the specified {@code int} value.  This function is
      # sometimes referred to as the <i>population count</i>.
      # 
      # @return the number of one-bits in the two's complement binary
      # representation of the specified {@code int} value.
      # @since 1.5
      def bit_count(i)
        # HD, Figure 5-2
        i = i - ((i >> 1) & 0x55555555)
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333)
        i = (i + (i >> 4)) & 0xf0f0f0f
        i = i + (i >> 8)
        i = i + (i >> 16)
        return i & 0x3f
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns the value obtained by rotating the two's complement binary
      # representation of the specified {@code int} value left by the
      # specified number of bits.  (Bits shifted out of the left hand, or
      # high-order, side reenter on the right, or low-order.)
      # 
      # <p>Note that left rotation with a negative distance is equivalent to
      # right rotation: {@code rotateLeft(val, -distance) == rotateRight(val,
      # distance)}.  Note also that rotation by any multiple of 32 is a
      # no-op, so all but the last five bits of the rotation distance can be
      # ignored, even if the distance is negative: {@code rotateLeft(val,
      # distance) == rotateLeft(val, distance & 0x1F)}.
      # 
      # @return the value obtained by rotating the two's complement binary
      # representation of the specified {@code int} value left by the
      # specified number of bits.
      # @since 1.5
      def rotate_left(i, distance)
        return (i << distance) | (i >> -distance)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns the value obtained by rotating the two's complement binary
      # representation of the specified {@code int} value right by the
      # specified number of bits.  (Bits shifted out of the right hand, or
      # low-order, side reenter on the left, or high-order.)
      # 
      # <p>Note that right rotation with a negative distance is equivalent to
      # left rotation: {@code rotateRight(val, -distance) == rotateLeft(val,
      # distance)}.  Note also that rotation by any multiple of 32 is a
      # no-op, so all but the last five bits of the rotation distance can be
      # ignored, even if the distance is negative: {@code rotateRight(val,
      # distance) == rotateRight(val, distance & 0x1F)}.
      # 
      # @return the value obtained by rotating the two's complement binary
      # representation of the specified {@code int} value right by the
      # specified number of bits.
      # @since 1.5
      def rotate_right(i, distance)
        return (i >> distance) | (i << -distance)
      end
      
      typesig { [::Java::Int] }
      # Returns the value obtained by reversing the order of the bits in the
      # two's complement binary representation of the specified {@code int}
      # value.
      # 
      # @return the value obtained by reversing order of the bits in the
      # specified {@code int} value.
      # @since 1.5
      def reverse(i)
        # HD, Figure 7-1
        i = (i & 0x55555555) << 1 | (i >> 1) & 0x55555555
        i = (i & 0x33333333) << 2 | (i >> 2) & 0x33333333
        i = (i & 0xf0f0f0f) << 4 | (i >> 4) & 0xf0f0f0f
        i = (i << 24) | ((i & 0xff00) << 8) | ((i >> 8) & 0xff00) | (i >> 24)
        return i
      end
      
      typesig { [::Java::Int] }
      # Returns the signum function of the specified {@code int} value.  (The
      # return value is -1 if the specified value is negative; 0 if the
      # specified value is zero; and 1 if the specified value is positive.)
      # 
      # @return the signum function of the specified {@code int} value.
      # @since 1.5
      def signum(i)
        # HD, Section 2-7
        return (i >> 31) | (-i >> 31)
      end
      
      typesig { [::Java::Int] }
      # Returns the value obtained by reversing the order of the bytes in the
      # two's complement representation of the specified {@code int} value.
      # 
      # @return the value obtained by reversing the bytes in the specified
      # {@code int} value.
      # @since 1.5
      def reverse_bytes(i)
        return ((i >> 24)) | ((i >> 8) & 0xff00) | ((i << 8) & 0xff0000) | ((i << 24))
      end
      
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 1360826667806852920 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__integer, :initialize
  end
  
end
