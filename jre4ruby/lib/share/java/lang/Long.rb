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
  module LongImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The {@code Long} class wraps a value of the primitive type {@code
  # long} in an object. An object of type {@code Long} contains a
  # single field whose type is {@code long}.
  # 
  # <p> In addition, this class provides several methods for converting
  # a {@code long} to a {@code String} and a {@code String} to a {@code
  # long}, as well as other constants and methods useful when dealing
  # with a {@code long}.
  # 
  # <p>Implementation note: The implementations of the "bit twiddling"
  # methods (such as {@link #highestOneBit(long) highestOneBit} and
  # {@link #numberOfTrailingZeros(long) numberOfTrailingZeros}) are
  # based on material from Henry S. Warren, Jr.'s <i>Hacker's
  # Delight</i>, (Addison Wesley, 2002).
  # 
  # @author  Lee Boynton
  # @author  Arthur van Hoff
  # @author  Josh Bloch
  # @author  Joseph D. Darcy
  # @since   JDK1.0
  class Long < LongImports.const_get :Numeric
    include_class_members LongImports
    overload_protected {
      include JavaComparable
    }
    
    class_module.module_eval {
      # A constant holding the minimum value a {@code long} can
      # have, -2<sup>63</sup>.
      const_set_lazy(:MIN_VALUE) { -0x8000000000000000 }
      const_attr_reader  :MIN_VALUE
      
      # A constant holding the maximum value a {@code long} can
      # have, 2<sup>63</sup>-1.
      const_set_lazy(:MAX_VALUE) { 0x7fffffffffffffff }
      const_attr_reader  :MAX_VALUE
      
      # The {@code Class} instance representing the primitive type
      # {@code long}.
      # 
      # @since   JDK1.1
      const_set_lazy(:TYPE) { Class.get_primitive_class("long") }
      const_attr_reader  :TYPE
      
      typesig { [::Java::Long, ::Java::Int] }
      # Returns a string representation of the first argument in the
      # radix specified by the second argument.
      # 
      # <p>If the radix is smaller than {@code Character.MIN_RADIX}
      # or larger than {@code Character.MAX_RADIX}, then the radix
      # {@code 10} is used instead.
      # 
      # <p>If the first argument is negative, the first element of the
      # result is the ASCII minus sign {@code '-'}
      # (<code>'&#92;u002d'</code>). If the first argument is not
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
      # <code>'&#92;u007a'</code>. If {@code radix} is
      # <var>N</var>, then the first <var>N</var> of these characters
      # are used as radix-<var>N</var> digits in the order shown. Thus,
      # the digits for hexadecimal (radix 16) are
      # {@code 0123456789abcdef}. If uppercase letters are
      # desired, the {@link java.lang.String#toUpperCase()} method may
      # be called on the result:
      # 
      # <blockquote>
      # {@code Long.toString(n, 16).toUpperCase()}
      # </blockquote>
      # 
      # @param   i       a {@code long} to be converted to a string.
      # @param   radix   the radix to use in the string representation.
      # @return  a string representation of the argument in the specified radix.
      # @see     java.lang.Character#MAX_RADIX
      # @see     java.lang.Character#MIN_RADIX
      def to_s(i, radix)
        if (radix < Character::MIN_RADIX || radix > Character::MAX_RADIX)
          radix = 10
        end
        if ((radix).equal?(10))
          return to_s(i)
        end
        buf = CharArray.new(65)
        char_pos = 64
        negative = (i < 0)
        if (!negative)
          i = -i
        end
        while (i <= -radix)
          buf[((char_pos -= 1) + 1)] = JavaInteger.attr_digits[RJava.cast_to_int((-(i % radix)))]
          i = i / radix
        end
        buf[char_pos] = JavaInteger.attr_digits[RJava.cast_to_int((-i))]
        if (negative)
          buf[(char_pos -= 1)] = Character.new(?-.ord)
        end
        return String.new(buf, char_pos, (65 - char_pos))
      end
      
      typesig { [::Java::Long] }
      # Returns a string representation of the {@code long}
      # argument as an unsigned integer in base&nbsp;16.
      # 
      # <p>The unsigned {@code long} value is the argument plus
      # 2<sup>64</sup> if the argument is negative; otherwise, it is
      # equal to the argument.  This value is converted to a string of
      # ASCII digits in hexadecimal (base&nbsp;16) with no extra
      # leading {@code 0}s.  If the unsigned magnitude is zero, it
      # is represented by a single zero character {@code '0'}
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
      # <code>'&#92;u0039'</code> and  <code>'&#92;u0061'</code> through
      # <code>'&#92;u0066'</code>.  If uppercase letters are desired,
      # the {@link java.lang.String#toUpperCase()} method may be called
      # on the result:
      # 
      # <blockquote>
      # {@code Long.toHexString(n).toUpperCase()}
      # </blockquote>
      # 
      # @param   i   a {@code long} to be converted to a string.
      # @return  the string representation of the unsigned {@code long}
      # value represented by the argument in hexadecimal
      # (base&nbsp;16).
      # @since   JDK 1.0.2
      def to_hex_string(i)
        return to_unsigned_string(i, 4)
      end
      
      typesig { [::Java::Long] }
      # Returns a string representation of the {@code long}
      # argument as an unsigned integer in base&nbsp;8.
      # 
      # <p>The unsigned {@code long} value is the argument plus
      # 2<sup>64</sup> if the argument is negative; otherwise, it is
      # equal to the argument.  This value is converted to a string of
      # ASCII digits in octal (base&nbsp;8) with no extra leading
      # {@code 0}s.
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
      # @param   i   a {@code long} to be converted to a string.
      # @return  the string representation of the unsigned {@code long}
      # value represented by the argument in octal (base&nbsp;8).
      # @since   JDK 1.0.2
      def to_octal_string(i)
        return to_unsigned_string(i, 3)
      end
      
      typesig { [::Java::Long] }
      # Returns a string representation of the {@code long}
      # argument as an unsigned integer in base&nbsp;2.
      # 
      # <p>The unsigned {@code long} value is the argument plus
      # 2<sup>64</sup> if the argument is negative; otherwise, it is
      # equal to the argument.  This value is converted to a string of
      # ASCII digits in binary (base&nbsp;2) with no extra leading
      # {@code 0}s.  If the unsigned magnitude is zero, it is
      # represented by a single zero character {@code '0'}
      # (<code>'&#92;u0030'</code>); otherwise, the first character of
      # the representation of the unsigned magnitude will not be the
      # zero character. The characters {@code '0'}
      # (<code>'&#92;u0030'</code>) and {@code '1'}
      # (<code>'&#92;u0031'</code>) are used as binary digits.
      # 
      # @param   i   a {@code long} to be converted to a string.
      # @return  the string representation of the unsigned {@code long}
      # value represented by the argument in binary (base&nbsp;2).
      # @since   JDK 1.0.2
      def to_binary_string(i)
        return to_unsigned_string(i, 1)
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # Convert the integer to an unsigned number.
      def to_unsigned_string(i, shift)
        buf = CharArray.new(64)
        char_pos = 64
        radix = 1 << shift
        mask = radix - 1
        begin
          buf[(char_pos -= 1)] = JavaInteger.attr_digits[RJava.cast_to_int((i & mask))]
          i >>= shift
        end while (!(i).equal?(0))
        return String.new(buf, char_pos, (64 - char_pos))
      end
      
      typesig { [::Java::Long] }
      # Returns a {@code String} object representing the specified
      # {@code long}.  The argument is converted to signed decimal
      # representation and returned as a string, exactly as if the
      # argument and the radix 10 were given as arguments to the {@link
      # #toString(long, int)} method.
      # 
      # @param   i   a {@code long} to be converted.
      # @return  a string representation of the argument in base&nbsp;10.
      def to_s(i)
        if ((i).equal?(Long::MIN_VALUE))
          return "-9223372036854775808"
        end
        size = (i < 0) ? string_size(-i) + 1 : string_size(i)
        buf = CharArray.new(size)
        get_chars(i, size, buf)
        return String.new(0, size, buf)
      end
      
      typesig { [::Java::Long, ::Java::Int, Array.typed(::Java::Char)] }
      # Places characters representing the integer i into the
      # character array buf. The characters are placed into
      # the buffer backwards starting with the least significant
      # digit at the specified index (exclusive), and working
      # backwards from there.
      # 
      # Will fail if i == Long.MIN_VALUE
      def get_chars(i, index, buf)
        q = 0
        r = 0
        char_pos = index
        sign = 0
        if (i < 0)
          sign = Character.new(?-.ord)
          i = -i
        end
        # Get 2 digits/iteration using longs until quotient fits into an int
        while (i > JavaInteger::MAX_VALUE)
          q = i / 100
          # really: r = i - (q * 100);
          r = RJava.cast_to_int((i - ((q << 6) + (q << 5) + (q << 2))))
          i = q
          buf[(char_pos -= 1)] = JavaInteger::DigitOnes[r]
          buf[(char_pos -= 1)] = JavaInteger::DigitTens[r]
        end
        # Get 2 digits/iteration using ints
        q2 = 0
        i2 = RJava.cast_to_int(i)
        while (i2 >= 65536)
          q2 = i2 / 100
          # really: r = i2 - (q * 100);
          r = i2 - ((q2 << 6) + (q2 << 5) + (q2 << 2))
          i2 = q2
          buf[(char_pos -= 1)] = JavaInteger::DigitOnes[r]
          buf[(char_pos -= 1)] = JavaInteger::DigitTens[r]
        end
        # Fall thru to fast mode for smaller numbers
        # assert(i2 <= 65536, i2);
        loop do
          q2 = (i2 * 52429) >> (16 + 3)
          r = i2 - ((q2 << 3) + (q2 << 1)) # r = i2-(q2*10) ...
          buf[(char_pos -= 1)] = JavaInteger.attr_digits[r]
          i2 = q2
          if ((i2).equal?(0))
            break
          end
        end
        if (!(sign).equal?(0))
          buf[(char_pos -= 1)] = sign
        end
      end
      
      typesig { [::Java::Long] }
      # Requires positive x
      def string_size(x)
        p = 10
        i = 1
        while i < 19
          if (x < p)
            return i
          end
          p = 10 * p
          i += 1
        end
        return 19
      end
      
      typesig { [String, ::Java::Int] }
      # Parses the string argument as a signed {@code long} in the
      # radix specified by the second argument. The characters in the
      # string must all be digits of the specified radix (as determined
      # by whether {@link java.lang.Character#digit(char, int)} returns
      # a nonnegative value), except that the first character may be an
      # ASCII minus sign {@code '-'} (<code>'&#92;u002D'</code>) to
      # indicate a negative value. The resulting {@code long} value is
      # returned.
      # 
      # <p>Note that neither the character {@code L}
      # (<code>'&#92;u004C'</code>) nor {@code l}
      # (<code>'&#92;u006C'</code>) is permitted to appear at the end
      # of the string as a type indicator, as would be permitted in
      # Java programming language source code - except that either
      # {@code L} or {@code l} may appear as a digit for a
      # radix greater than 22.
      # 
      # <p>An exception of type {@code NumberFormatException} is
      # thrown if any of the following situations occurs:
      # <ul>
      # 
      # <li>The first argument is {@code null} or is a string of
      # length zero.
      # 
      # <li>The {@code radix} is either smaller than {@link
      # java.lang.Character#MIN_RADIX} or larger than {@link
      # java.lang.Character#MAX_RADIX}.
      # 
      # <li>Any character of the string is not a digit of the specified
      # radix, except that the first character may be a minus sign
      # {@code '-'} (<code>'&#92;u002d'</code>) provided that the
      # string is longer than length 1.
      # 
      # <li>The value represented by the string is not a value of type
      # {@code long}.
      # </ul>
      # 
      # <p>Examples:
      # <blockquote><pre>
      # parseLong("0", 10) returns 0L
      # parseLong("473", 10) returns 473L
      # parseLong("-0", 10) returns 0L
      # parseLong("-FF", 16) returns -255L
      # parseLong("1100110", 2) returns 102L
      # parseLong("99", 8) throws a NumberFormatException
      # parseLong("Hazelnut", 10) throws a NumberFormatException
      # parseLong("Hazelnut", 36) returns 1356099454469L
      # </pre></blockquote>
      # 
      # @param      s       the {@code String} containing the
      # {@code long} representation to be parsed.
      # @param      radix   the radix to be used while parsing {@code s}.
      # @return     the {@code long} represented by the string argument in
      # the specified radix.
      # @throws     NumberFormatException  if the string does not contain a
      # parsable {@code long}.
      def parse_long(s, radix)
        if ((s).nil?)
          raise NumberFormatException.new("null")
        end
        if (radix < Character::MIN_RADIX)
          raise NumberFormatException.new("radix " + RJava.cast_to_string(radix) + " less than Character.MIN_RADIX")
        end
        if (radix > Character::MAX_RADIX)
          raise NumberFormatException.new("radix " + RJava.cast_to_string(radix) + " greater than Character.MAX_RADIX")
        end
        result = 0
        negative = false
        i = 0
        len = s.length
        limit = -Long::MAX_VALUE
        multmin = 0
        digit = 0
        if (len > 0)
          first_char = s.char_at(0)
          if (first_char < Character.new(?0.ord))
            # Possible leading "-"
            if ((first_char).equal?(Character.new(?-.ord)))
              negative = true
              limit = Long::MIN_VALUE
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
      # Parses the string argument as a signed decimal {@code long}.
      # The characters in the string must all be decimal digits, except
      # that the first character may be an ASCII minus sign {@code '-'}
      # (<code>&#92;u002D'</code>) to indicate a negative value.  The
      # resulting {@code long} value is returned, exactly as if the
      # argument and the radix {@code 10} were given as arguments to
      # the {@link #parseLong(java.lang.String, int)} method.
      # 
      # <p>Note that neither the character {@code L}
      # (<code>'&#92;u004C'</code>) nor {@code l}
      # (<code>'&#92;u006C'</code>) is permitted to appear at the end
      # of the string as a type indicator, as would be permitted in
      # Java programming language source code.
      # 
      # @param      s   a {@code String} containing the {@code long}
      # representation to be parsed
      # @return     the {@code long} represented by the argument in
      # decimal.
      # @throws     NumberFormatException  if the string does not contain a
      # parsable {@code long}.
      def parse_long(s)
        return parse_long(s, 10)
      end
      
      typesig { [String, ::Java::Int] }
      # Returns a {@code Long} object holding the value
      # extracted from the specified {@code String} when parsed
      # with the radix given by the second argument.  The first
      # argument is interpreted as representing a signed
      # {@code long} in the radix specified by the second
      # argument, exactly as if the arguments were given to the {@link
      # #parseLong(java.lang.String, int)} method. The result is a
      # {@code Long} object that represents the {@code long}
      # value specified by the string.
      # 
      # <p>In other words, this method returns a {@code Long} object equal
      # to the value of:
      # 
      # <blockquote>
      # {@code new Long(Long.parseLong(s, radix))}
      # </blockquote>
      # 
      # @param      s       the string to be parsed
      # @param      radix   the radix to be used in interpreting {@code s}
      # @return     a {@code Long} object holding the value
      # represented by the string argument in the specified
      # radix.
      # @throws     NumberFormatException  If the {@code String} does not
      # contain a parsable {@code long}.
      def value_of(s, radix)
        return Long.new(parse_long(s, radix))
      end
      
      typesig { [String] }
      # Returns a {@code Long} object holding the value
      # of the specified {@code String}. The argument is
      # interpreted as representing a signed decimal {@code long},
      # exactly as if the argument were given to the {@link
      # #parseLong(java.lang.String)} method. The result is a
      # {@code Long} object that represents the integer value
      # specified by the string.
      # 
      # <p>In other words, this method returns a {@code Long} object
      # equal to the value of:
      # 
      # <blockquote>
      # {@code new Long(Long.parseLong(s))}
      # </blockquote>
      # 
      # @param      s   the string to be parsed.
      # @return     a {@code Long} object holding the value
      # represented by the string argument.
      # @throws     NumberFormatException  If the string cannot be parsed
      # as a {@code long}.
      def value_of(s)
        return Long.new(parse_long(s, 10))
      end
      
      const_set_lazy(:LongCache) { Class.new do
        include_class_members Long
        
        typesig { [] }
        def initialize
        end
        
        class_module.module_eval {
          const_set_lazy(:Cache) { Array.typed(class_self::Long).new(-(-128) + 127 + 1) { nil } }
          const_attr_reader  :Cache
          
          when_class_loaded do
            i = 0
            while i < self.class::Cache.attr_length
              self.class::Cache[i] = class_self::Long.new(i - 128)
              i += 1
            end
          end
        }
        
        private
        alias_method :initialize__long_cache, :initialize
      end }
      
      typesig { [::Java::Long] }
      # Returns a {@code Long} instance representing the specified
      # {@code long} value.
      # If a new {@code Long} instance is not required, this method
      # should generally be used in preference to the constructor
      # {@link #Long(long)}, as this method is likely to yield
      # significantly better space and time performance by caching
      # frequently requested values.
      # 
      # @param  l a long value.
      # @return a {@code Long} instance representing {@code l}.
      # @since  1.5
      def value_of(l)
        offset = 128
        if (l >= -128 && l <= 127)
          # will cache
          return LongCache.attr_cache[RJava.cast_to_int(l) + offset]
        end
        return Long.new(l)
      end
      
      typesig { [String] }
      # Decodes a {@code String} into a {@code Long}.
      # Accepts decimal, hexadecimal, and octal numbers given by the
      # following grammar:
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
      # Long.parseLong} method with the indicated radix (10, 16, or 8).
      # This sequence of characters must represent a positive value or
      # a {@link NumberFormatException} will be thrown.  The result is
      # negated if first character of the specified {@code String} is
      # the minus sign.  No whitespace characters are permitted in the
      # {@code String}.
      # 
      # @param     nm the {@code String} to decode.
      # @return    a {@code Long} object holding the {@code long}
      # value represented by {@code nm}
      # @throws    NumberFormatException  if the {@code String} does not
      # contain a parsable {@code long}.
      # @see java.lang.Long#parseLong(String, int)
      # @since 1.2
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
          result = Long.value_of(nm.substring(index), radix)
          result = negative ? Long.new(-result.long_value) : result
        rescue NumberFormatException => e
          # If number is Long.MIN_VALUE, we'll end up here. The next line
          # handles this case, and causes any genuine format error to be
          # rethrown.
          constant = negative ? ("-" + RJava.cast_to_string(nm.substring(index))) : nm.substring(index)
          result = Long.value_of(constant, radix)
        end
        return result
      end
    }
    
    # The value of the {@code Long}.
    # 
    # @serial
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [::Java::Long] }
    # Constructs a newly allocated {@code Long} object that
    # represents the specified {@code long} argument.
    # 
    # @param   value   the value to be represented by the
    # {@code Long} object.
    def initialize(value)
      @value = 0
      super()
      @value = value
    end
    
    typesig { [String] }
    # Constructs a newly allocated {@code Long} object that
    # represents the {@code long} value indicated by the
    # {@code String} parameter. The string is converted to a
    # {@code long} value in exactly the manner used by the
    # {@code parseLong} method for radix 10.
    # 
    # @param      s   the {@code String} to be converted to a
    # {@code Long}.
    # @throws     NumberFormatException  if the {@code String} does not
    # contain a parsable {@code long}.
    # @see        java.lang.Long#parseLong(java.lang.String, int)
    def initialize(s)
      @value = 0
      super()
      @value = parse_long(s, 10)
    end
    
    typesig { [] }
    # Returns the value of this {@code Long} as a
    # {@code byte}.
    def byte_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Long} as a
    # {@code short}.
    def short_value
      return RJava.cast_to_short(@value)
    end
    
    typesig { [] }
    # Returns the value of this {@code Long} as an
    # {@code int}.
    def int_value
      return RJava.cast_to_int(@value)
    end
    
    typesig { [] }
    # Returns the value of this {@code Long} as a
    # {@code long} value.
    def long_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Long} as a
    # {@code float}.
    def float_value
      return (@value).to_f
    end
    
    typesig { [] }
    # Returns the value of this {@code Long} as a
    # {@code double}.
    def double_value
      return (@value).to_f
    end
    
    typesig { [] }
    # Returns a {@code String} object representing this
    # {@code Long}'s value.  The value is converted to signed
    # decimal representation and returned as a string, exactly as if
    # the {@code long} value were given as an argument to the
    # {@link java.lang.Long#toString(long)} method.
    # 
    # @return  a string representation of the value of this object in
    # base&nbsp;10.
    def to_s
      return String.value_of(@value)
    end
    
    typesig { [] }
    # Returns a hash code for this {@code Long}. The result is
    # the exclusive OR of the two halves of the primitive
    # {@code long} value held by this {@code Long}
    # object. That is, the hashcode is the value of the expression:
    # 
    # <blockquote>
    # {@code (int)(this.longValue()^(this.longValue()>>>32))}
    # </blockquote>
    # 
    # @return  a hash code value for this object.
    def hash_code
      return RJava.cast_to_int((@value ^ (@value >> 32)))
    end
    
    typesig { [Object] }
    # Compares this object to the specified object.  The result is
    # {@code true} if and only if the argument is not
    # {@code null} and is a {@code Long} object that
    # contains the same {@code long} value as this object.
    # 
    # @param   obj   the object to compare with.
    # @return  {@code true} if the objects are the same;
    # {@code false} otherwise.
    def ==(obj)
      if (obj.is_a?(Long))
        return (@value).equal?((obj).long_value)
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Determines the {@code long} value of the system property
      # with the specified name.
      # 
      # <p>The first argument is treated as the name of a system property.
      # System properties are accessible through the {@link
      # java.lang.System#getProperty(java.lang.String)} method. The
      # string value of this property is then interpreted as a
      # {@code long} value and a {@code Long} object
      # representing this value is returned.  Details of possible
      # numeric formats can be found with the definition of
      # {@code getProperty}.
      # 
      # <p>If there is no property with the specified name, if the
      # specified name is empty or {@code null}, or if the
      # property does not have the correct numeric format, then
      # {@code null} is returned.
      # 
      # <p>In other words, this method returns a {@code Long} object equal to
      # the value of:
      # 
      # <blockquote>
      # {@code getLong(nm, null)}
      # </blockquote>
      # 
      # @param   nm   property name.
      # @return  the {@code Long} value of the property.
      # @see     java.lang.System#getProperty(java.lang.String)
      # @see     java.lang.System#getProperty(java.lang.String, java.lang.String)
      def get_long(nm)
        return get_long(nm, nil)
      end
      
      typesig { [String, ::Java::Long] }
      # Determines the {@code long} value of the system property
      # with the specified name.
      # 
      # <p>The first argument is treated as the name of a system property.
      # System properties are accessible through the {@link
      # java.lang.System#getProperty(java.lang.String)} method. The
      # string value of this property is then interpreted as a
      # {@code long} value and a {@code Long} object
      # representing this value is returned.  Details of possible
      # numeric formats can be found with the definition of
      # {@code getProperty}.
      # 
      # <p>The second argument is the default value. A {@code Long} object
      # that represents the value of the second argument is returned if there
      # is no property of the specified name, if the property does not have
      # the correct numeric format, or if the specified name is empty or null.
      # 
      # <p>In other words, this method returns a {@code Long} object equal
      # to the value of:
      # 
      # <blockquote>
      # {@code getLong(nm, new Long(val))}
      # </blockquote>
      # 
      # but in practice it may be implemented in a manner such as:
      # 
      # <blockquote><pre>
      # Long result = getLong(nm, null);
      # return (result == null) ? new Long(val) : result;
      # </pre></blockquote>
      # 
      # to avoid the unnecessary allocation of a {@code Long} object when
      # the default value is not needed.
      # 
      # @param   nm    property name.
      # @param   val   default value.
      # @return  the {@code Long} value of the property.
      # @see     java.lang.System#getProperty(java.lang.String)
      # @see     java.lang.System#getProperty(java.lang.String, java.lang.String)
      def get_long(nm, val)
        result = Long.get_long(nm, nil)
        return ((result).nil?) ? Long.new(val) : result
      end
      
      typesig { [String, Long] }
      # Returns the {@code long} value of the system property with
      # the specified name.  The first argument is treated as the name
      # of a system property.  System properties are accessible through
      # the {@link java.lang.System#getProperty(java.lang.String)}
      # method. The string value of this property is then interpreted
      # as a {@code long} value, as per the
      # {@code Long.decode} method, and a {@code Long} object
      # representing this value is returned.
      # 
      # <ul>
      # <li>If the property value begins with the two ASCII characters
      # {@code 0x} or the ASCII character {@code #}, not followed by
      # a minus sign, then the rest of it is parsed as a hexadecimal integer
      # exactly as for the method {@link #valueOf(java.lang.String, int)}
      # with radix 16.
      # <li>If the property value begins with the ASCII character
      # {@code 0} followed by another character, it is parsed as
      # an octal integer exactly as by the method {@link
      # #valueOf(java.lang.String, int)} with radix 8.
      # <li>Otherwise the property value is parsed as a decimal
      # integer exactly as by the method
      # {@link #valueOf(java.lang.String, int)} with radix 10.
      # </ul>
      # 
      # <p>Note that, in every case, neither {@code L}
      # (<code>'&#92;u004C'</code>) nor {@code l}
      # (<code>'&#92;u006C'</code>) is permitted to appear at the end
      # of the property value as a type indicator, as would be
      # permitted in Java programming language source code.
      # 
      # <p>The second argument is the default value. The default value is
      # returned if there is no property of the specified name, if the
      # property does not have the correct numeric format, or if the
      # specified name is empty or {@code null}.
      # 
      # @param   nm   property name.
      # @param   val   default value.
      # @return  the {@code Long} value of the property.
      # @see     java.lang.System#getProperty(java.lang.String)
      # @see java.lang.System#getProperty(java.lang.String, java.lang.String)
      # @see java.lang.Long#decode
      def get_long(nm, val)
        v = nil
        begin
          v = RJava.cast_to_string(System.get_property(nm))
        rescue IllegalArgumentException => e
        rescue NullPointerException => e
        end
        if (!(v).nil?)
          begin
            return Long.decode(v)
          rescue NumberFormatException => e
          end
        end
        return val
      end
    }
    
    typesig { [Long] }
    # Compares two {@code Long} objects numerically.
    # 
    # @param   anotherLong   the {@code Long} to be compared.
    # @return  the value {@code 0} if this {@code Long} is
    # equal to the argument {@code Long}; a value less than
    # {@code 0} if this {@code Long} is numerically less
    # than the argument {@code Long}; and a value greater
    # than {@code 0} if this {@code Long} is numerically
    # greater than the argument {@code Long} (signed
    # comparison).
    # @since   1.2
    def compare_to(another_long)
      this_val = @value
      another_val = another_long.attr_value
      return (this_val < another_val ? -1 : ((this_val).equal?(another_val) ? 0 : 1))
    end
    
    class_module.module_eval {
      # Bit Twiddling
      # 
      # The number of bits used to represent a {@code long} value in two's
      # complement binary form.
      # 
      # @since 1.5
      const_set_lazy(:SIZE) { 64 }
      const_attr_reader  :SIZE
      
      typesig { [::Java::Long] }
      # Returns a {@code long} value with at most a single one-bit, in the
      # position of the highest-order ("leftmost") one-bit in the specified
      # {@code long} value.  Returns zero if the specified value has no
      # one-bits in its two's complement binary representation, that is, if it
      # is equal to zero.
      # 
      # @return a {@code long} value with a single one-bit, in the position
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
        i |= (i >> 32)
        return i - (i >> 1)
      end
      
      typesig { [::Java::Long] }
      # Returns a {@code long} value with at most a single one-bit, in the
      # position of the lowest-order ("rightmost") one-bit in the specified
      # {@code long} value.  Returns zero if the specified value has no
      # one-bits in its two's complement binary representation, that is, if it
      # is equal to zero.
      # 
      # @return a {@code long} value with a single one-bit, in the position
      # of the lowest-order one-bit in the specified value, or zero if
      # the specified value is itself equal to zero.
      # @since 1.5
      def lowest_one_bit(i)
        # HD, Section 2-1
        return i & -i
      end
      
      typesig { [::Java::Long] }
      # Returns the number of zero bits preceding the highest-order
      # ("leftmost") one-bit in the two's complement binary representation
      # of the specified {@code long} value.  Returns 64 if the
      # specified value has no one-bits in its two's complement representation,
      # in other words if it is equal to zero.
      # 
      # <p>Note that this method is closely related to the logarithm base 2.
      # For all positive {@code long} values x:
      # <ul>
      # <li>floor(log<sub>2</sub>(x)) = {@code 63 - numberOfLeadingZeros(x)}
      # <li>ceil(log<sub>2</sub>(x)) = {@code 64 - numberOfLeadingZeros(x - 1)}
      # </ul>
      # 
      # @return the number of zero bits preceding the highest-order
      # ("leftmost") one-bit in the two's complement binary representation
      # of the specified {@code long} value, or 64 if the value
      # is equal to zero.
      # @since 1.5
      def number_of_leading_zeros(i)
        # HD, Figure 5-6
        if ((i).equal?(0))
          return 64
        end
        n = 1
        x = RJava.cast_to_int((i >> 32))
        if ((x).equal?(0))
          n += 32
          x = RJava.cast_to_int(i)
        end
        if ((x >> 16).equal?(0))
          n += 16
          x <<= 16
        end
        if ((x >> 24).equal?(0))
          n += 8
          x <<= 8
        end
        if ((x >> 28).equal?(0))
          n += 4
          x <<= 4
        end
        if ((x >> 30).equal?(0))
          n += 2
          x <<= 2
        end
        n -= x >> 31
        return n
      end
      
      typesig { [::Java::Long] }
      # Returns the number of zero bits following the lowest-order ("rightmost")
      # one-bit in the two's complement binary representation of the specified
      # {@code long} value.  Returns 64 if the specified value has no
      # one-bits in its two's complement representation, in other words if it is
      # equal to zero.
      # 
      # @return the number of zero bits following the lowest-order ("rightmost")
      # one-bit in the two's complement binary representation of the
      # specified {@code long} value, or 64 if the value is equal
      # to zero.
      # @since 1.5
      def number_of_trailing_zeros(i)
        # HD, Figure 5-14
        x = 0
        y = 0
        if ((i).equal?(0))
          return 64
        end
        n = 63
        y = RJava.cast_to_int(i)
        if (!(y).equal?(0))
          n = n - 32
          x = y
        else
          x = RJava.cast_to_int((i >> 32))
        end
        y = x << 16
        if (!(y).equal?(0))
          n = n - 16
          x = y
        end
        y = x << 8
        if (!(y).equal?(0))
          n = n - 8
          x = y
        end
        y = x << 4
        if (!(y).equal?(0))
          n = n - 4
          x = y
        end
        y = x << 2
        if (!(y).equal?(0))
          n = n - 2
          x = y
        end
        return n - ((x << 1) >> 31)
      end
      
      typesig { [::Java::Long] }
      # Returns the number of one-bits in the two's complement binary
      # representation of the specified {@code long} value.  This function is
      # sometimes referred to as the <i>population count</i>.
      # 
      # @return the number of one-bits in the two's complement binary
      # representation of the specified {@code long} value.
      # @since 1.5
      def bit_count(i)
        # HD, Figure 5-14
        i = i - ((i >> 1) & 0x5555555555555555)
        i = (i & 0x3333333333333333) + ((i >> 2) & 0x3333333333333333)
        i = (i + (i >> 4)) & 0xf0f0f0f0f0f0f0f
        i = i + (i >> 8)
        i = i + (i >> 16)
        i = i + (i >> 32)
        return RJava.cast_to_int(i) & 0x7f
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # Returns the value obtained by rotating the two's complement binary
      # representation of the specified {@code long} value left by the
      # specified number of bits.  (Bits shifted out of the left hand, or
      # high-order, side reenter on the right, or low-order.)
      # 
      # <p>Note that left rotation with a negative distance is equivalent to
      # right rotation: {@code rotateLeft(val, -distance) == rotateRight(val,
      # distance)}.  Note also that rotation by any multiple of 64 is a
      # no-op, so all but the last six bits of the rotation distance can be
      # ignored, even if the distance is negative: {@code rotateLeft(val,
      # distance) == rotateLeft(val, distance & 0x3F)}.
      # 
      # @return the value obtained by rotating the two's complement binary
      # representation of the specified {@code long} value left by the
      # specified number of bits.
      # @since 1.5
      def rotate_left(i, distance)
        return (i << distance) | (i >> -distance)
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # Returns the value obtained by rotating the two's complement binary
      # representation of the specified {@code long} value right by the
      # specified number of bits.  (Bits shifted out of the right hand, or
      # low-order, side reenter on the left, or high-order.)
      # 
      # <p>Note that right rotation with a negative distance is equivalent to
      # left rotation: {@code rotateRight(val, -distance) == rotateLeft(val,
      # distance)}.  Note also that rotation by any multiple of 64 is a
      # no-op, so all but the last six bits of the rotation distance can be
      # ignored, even if the distance is negative: {@code rotateRight(val,
      # distance) == rotateRight(val, distance & 0x3F)}.
      # 
      # @return the value obtained by rotating the two's complement binary
      # representation of the specified {@code long} value right by the
      # specified number of bits.
      # @since 1.5
      def rotate_right(i, distance)
        return (i >> distance) | (i << -distance)
      end
      
      typesig { [::Java::Long] }
      # Returns the value obtained by reversing the order of the bits in the
      # two's complement binary representation of the specified {@code long}
      # value.
      # 
      # @return the value obtained by reversing order of the bits in the
      # specified {@code long} value.
      # @since 1.5
      def reverse(i)
        # HD, Figure 7-1
        i = (i & 0x5555555555555555) << 1 | (i >> 1) & 0x5555555555555555
        i = (i & 0x3333333333333333) << 2 | (i >> 2) & 0x3333333333333333
        i = (i & 0xf0f0f0f0f0f0f0f) << 4 | (i >> 4) & 0xf0f0f0f0f0f0f0f
        i = (i & 0xff00ff00ff00ff) << 8 | (i >> 8) & 0xff00ff00ff00ff
        i = (i << 48) | ((i & 0xffff0000) << 16) | ((i >> 16) & 0xffff0000) | (i >> 48)
        return i
      end
      
      typesig { [::Java::Long] }
      # Returns the signum function of the specified {@code long} value.  (The
      # return value is -1 if the specified value is negative; 0 if the
      # specified value is zero; and 1 if the specified value is positive.)
      # 
      # @return the signum function of the specified {@code long} value.
      # @since 1.5
      def signum(i)
        # HD, Section 2-7
        return RJava.cast_to_int(((i >> 63) | (-i >> 63)))
      end
      
      typesig { [::Java::Long] }
      # Returns the value obtained by reversing the order of the bytes in the
      # two's complement representation of the specified {@code long} value.
      # 
      # @return the value obtained by reversing the bytes in the specified
      # {@code long} value.
      # @since 1.5
      def reverse_bytes(i)
        i = (i & 0xff00ff00ff00ff) << 8 | (i >> 8) & 0xff00ff00ff00ff
        return (i << 48) | ((i & 0xffff0000) << 16) | ((i >> 16) & 0xffff0000) | (i >> 48)
      end
      
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 4290774380558885855 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__long, :initialize
  end
  
end
