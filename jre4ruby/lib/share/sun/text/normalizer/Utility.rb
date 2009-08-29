require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module UtilityImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
    }
  end
  
  # This class contains utility functions so testing not needed
  # /CLOVER:OFF
  class Utility 
    include_class_members UtilityImports
    
    class_module.module_eval {
      typesig { [String] }
      # Convert characters outside the range U+0020 to U+007F to
      # Unicode escapes, and convert backslash to a double backslash.
      def escape(s)
        buf = StringBuffer.new
        i = 0
        while i < s.length
          c = UTF16.char_at(s, i)
          i += UTF16.get_char_count(c)
          if (c >= Character.new(?\s.ord) && c <= 0x7f)
            if ((c).equal?(Character.new(?\\.ord)))
              buf.append("\\\\") # That is, "\\"
            else
              buf.append(RJava.cast_to_char(c))
            end
          else
            four = c <= 0xffff
            buf.append(four ? "\\u" : "\\U")
            hex(c, four ? 4 : 8, buf)
          end
        end
        return buf.to_s
      end
      
      # This map must be in ASCENDING ORDER OF THE ESCAPE CODE
      # "   0x22, 0x22
      # '   0x27, 0x27
      # ?   0x3F, 0x3F
      # \   0x5C, 0x5C
      # a
      # b
      # e
      # f
      # n
      # r
      # t
      # v
      const_set_lazy(:UNESCAPE_MAP) { Array.typed(::Java::Char).new([0x61, 0x7, 0x62, 0x8, 0x65, 0x1b, 0x66, 0xc, 0x6e, 0xa, 0x72, 0xd, 0x74, 0x9, 0x76, 0xb]) }
      const_attr_reader  :UNESCAPE_MAP
      
      typesig { [String, Array.typed(::Java::Int)] }
      # Convert an escape to a 32-bit code point value.  We attempt
      # to parallel the icu4c unescapeAt() function.
      # @param offset16 an array containing offset to the character
      # <em>after</em> the backslash.  Upon return offset16[0] will
      # be updated to point after the escape sequence.
      # @return character value from 0 to 10FFFF, or -1 on error.
      def unescape_at(s, offset16)
        c = 0
        result = 0
        n = 0
        min_dig = 0
        max_dig = 0
        bits_per_digit = 4
        dig = 0
        i = 0
        braces = false
        # Check that offset is in range
        offset = offset16[0]
        length_ = s.length
        if (offset < 0 || offset >= length_)
          return -1
        end
        # Fetch first UChar after '\\'
        c = UTF16.char_at(s, offset)
        offset += UTF16.get_char_count(c)
        # Convert hexadecimal and octal escapes
        case (c)
        when Character.new(?u.ord)
          min_dig = max_dig = 4
        when Character.new(?U.ord)
          min_dig = max_dig = 8
        when Character.new(?x.ord)
          min_dig = 1
          # {
          if (offset < length_ && (UTF16.char_at(s, offset)).equal?(0x7b))
            (offset += 1)
            braces = true
            max_dig = 8
          else
            max_dig = 2
          end
        else
          dig = UCharacter.digit(c, 8)
          if (dig >= 0)
            min_dig = 1
            max_dig = 3
            n = 1
            # Already have first octal digit
            bits_per_digit = 3
            result = dig
          end
        end
        if (!(min_dig).equal?(0))
          while (offset < length_ && n < max_dig)
            c = UTF16.char_at(s, offset)
            dig = UCharacter.digit(c, ((bits_per_digit).equal?(3)) ? 8 : 16)
            if (dig < 0)
              break
            end
            result = (result << bits_per_digit) | dig
            offset += UTF16.get_char_count(c)
            (n += 1)
          end
          if (n < min_dig)
            return -1
          end
          if (braces)
            # }
            if (!(c).equal?(0x7d))
              return -1
            end
            (offset += 1)
          end
          if (result < 0 || result >= 0x110000)
            return -1
          end
          # If an escape sequence specifies a lead surrogate, see
          # if there is a trail surrogate after it, either as an
          # escape or as a literal.  If so, join them up into a
          # supplementary.
          if (offset < length_ && UTF16.is_lead_surrogate(RJava.cast_to_char(result)))
            ahead = offset + 1
            c = s.char_at(offset) # [sic] get 16-bit code unit
            if ((c).equal?(Character.new(?\\.ord)) && ahead < length_)
              o = Array.typed(::Java::Int).new([ahead])
              c = unescape_at(s, o)
              ahead = o[0]
            end
            if (UTF16.is_trail_surrogate(RJava.cast_to_char(c)))
              offset = ahead
              result = UCharacterProperty.get_raw_supplementary(RJava.cast_to_char(result), RJava.cast_to_char(c))
            end
          end
          offset16[0] = offset
          return result
        end
        # Convert C-style escapes in table
        i = 0
        while i < UNESCAPE_MAP.attr_length
          if ((c).equal?(UNESCAPE_MAP[i]))
            offset16[0] = offset
            return UNESCAPE_MAP[i + 1]
          else
            if (c < UNESCAPE_MAP[i])
              break
            end
          end
          i += 2
        end
        # Map \cX to control-X: X & 0x1F
        if ((c).equal?(Character.new(?c.ord)) && offset < length_)
          c = UTF16.char_at(s, offset)
          offset16[0] = offset + UTF16.get_char_count(c)
          return 0x1f & c
        end
        # If no special forms are recognized, then consider
        # the backslash to generically escape the next character.
        offset16[0] = offset
        return c
      end
      
      typesig { [::Java::Int, ::Java::Int, StringBuffer] }
      # Convert a integer to size width hex uppercase digits.
      # E.g., hex('a', 4, str) => "0041".
      # Append the output to the given StringBuffer.
      # If width is too small to fit, nothing will be appended to output.
      def hex(ch, width, output)
        return append_number(output, ch, 16, width)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Convert a integer to size width (minimum) hex uppercase digits.
      # E.g., hex('a', 4, str) => "0041".  If the integer requires more
      # than width digits, more will be used.
      def hex(ch, width)
        buf = StringBuffer.new
        return append_number(buf, ch, 16, width).to_s
      end
      
      typesig { [String, ::Java::Int] }
      # Skip over a sequence of zero or more white space characters
      # at pos.  Return the index of the first non-white-space character
      # at or after pos, or str.length(), if there is none.
      def skip_whitespace(str, pos)
        while (pos < str.length)
          c = UTF16.char_at(str, pos)
          if (!UCharacterProperty.is_rule_white_space(c))
            break
          end
          pos += UTF16.get_char_count(c)
        end
        return pos
      end
      
      const_set_lazy(:DIGITS) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord), Character.new(?G.ord), Character.new(?H.ord), Character.new(?I.ord), Character.new(?J.ord), Character.new(?K.ord), Character.new(?L.ord), Character.new(?M.ord), Character.new(?N.ord), Character.new(?O.ord), Character.new(?P.ord), Character.new(?Q.ord), Character.new(?R.ord), Character.new(?S.ord), Character.new(?T.ord), Character.new(?U.ord), Character.new(?V.ord), Character.new(?W.ord), Character.new(?X.ord), Character.new(?Y.ord), Character.new(?Z.ord)]) }
      const_attr_reader  :DIGITS
      
      typesig { [StringBuffer, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Append the digits of a positive integer to the given
      # <code>StringBuffer</code> in the given radix. This is
      # done recursively since it is easiest to generate the low-
      # order digit first, but it must be appended last.
      # 
      # @param result is the <code>StringBuffer</code> to append to
      # @param n is the positive integer
      # @param radix is the radix, from 2 to 36 inclusive
      # @param minDigits is the minimum number of digits to append.
      def recursive_append_number(result, n, radix, min_digits)
        digit_ = n % radix
        if (n >= radix || min_digits > 1)
          recursive_append_number(result, n / radix, radix, min_digits - 1)
        end
        result.append(DIGITS[digit_])
      end
      
      typesig { [StringBuffer, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Append a number to the given StringBuffer in the given radix.
      # Standard digits '0'-'9' are used and letters 'A'-'Z' for
      # radices 11 through 36.
      # @param result the digits of the number are appended here
      # @param n the number to be converted to digits; may be negative.
      # If negative, a '-' is prepended to the digits.
      # @param radix a radix from 2 to 36 inclusive.
      # @param minDigits the minimum number of digits, not including
      # any '-', to produce.  Values less than 2 have no effect.  One
      # digit is always emitted regardless of this parameter.
      # @return a reference to result
      def append_number(result, n, radix, min_digits)
        if (radix < 2 || radix > 36)
          raise IllegalArgumentException.new("Illegal radix " + RJava.cast_to_string(radix))
        end
        abs = n
        if (n < 0)
          abs = -n
          result.append("-")
        end
        recursive_append_number(result, abs, radix, min_digits)
        return result
      end
      
      typesig { [::Java::Int] }
      # Return true if the character is NOT printable ASCII.  The tab,
      # newline and linefeed characters are considered unprintable.
      def is_unprintable(c)
        return !(c >= 0x20 && c <= 0x7e)
      end
      
      typesig { [StringBuffer, ::Java::Int] }
      # Escape unprintable characters using <backslash>uxxxx notation
      # for U+0000 to U+FFFF and <backslash>Uxxxxxxxx for U+10000 and
      # above.  If the character is printable ASCII, then do nothing
      # and return FALSE.  Otherwise, append the escaped notation and
      # return TRUE.
      def escape_unprintable(result, c)
        if (is_unprintable(c))
          result.append(Character.new(?\\.ord))
          if (!((c & ~0xffff)).equal?(0))
            result.append(Character.new(?U.ord))
            result.append(DIGITS[0xf & (c >> 28)])
            result.append(DIGITS[0xf & (c >> 24)])
            result.append(DIGITS[0xf & (c >> 20)])
            result.append(DIGITS[0xf & (c >> 16)])
          else
            result.append(Character.new(?u.ord))
          end
          result.append(DIGITS[0xf & (c >> 12)])
          result.append(DIGITS[0xf & (c >> 8)])
          result.append(DIGITS[0xf & (c >> 4)])
          result.append(DIGITS[0xf & c])
          return true
        end
        return false
      end
      
      typesig { [StringBuffer, ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int] }
      # // for StringPrep
      # 
      # Similar to StringBuffer.getChars, version 1.3.
      # Since JDK 1.2 implements StringBuffer.getChars differently, this method
      # is here to provide consistent results.
      # To be removed after JDK 1.2 ceased to be the reference platform.
      # @param src source string buffer
      # @param srcBegin offset to the start of the src to retrieve from
      # @param srcEnd offset to the end of the src to retrieve from
      # @param dst char array to store the retrieved chars
      # @param dstBegin offset to the start of the destination char array to
      # store the retrieved chars
      # @draft since ICU4J 2.0
      def get_chars(src, src_begin, src_end, dst, dst_begin)
        if ((src_begin).equal?(src_end))
          return
        end
        src.get_chars(src_begin, src_end, dst, dst_begin)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Convenience utility to compare two char[]s.
      # @param len the length to compare.
      # The start indices and start+len must be valid.
      def array_region_matches(source, source_start, target, target_start, len)
        source_end = source_start + len
        delta = target_start - source_start
        i = source_start
        while i < source_end
          if (!(source[i]).equal?(target[i + delta]))
            return false
          end
          i += 1
        end
        return true
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__utility, :initialize
  end
  
end
