require "rjava"

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
# Copyright (C) 2003-2004, International Business Machines Corporation and    *
# others. All Rights Reserved.                                                *
# 
# 
# 
# CHANGELOG
# 2005-05-19 Edward Wang
# - copy this file from icu4jsrc_3_2/src/com/ibm/icu/text/Punycode.java
# - move from package com.ibm.icu.text to package sun.net.idn
# - use ParseException instead of StringPrepParseException
# 2007-08-14 Martin Buchholz
# - remove redundant casts
module Sun::Net::Idn
  module PunycodeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Idn
      include_const ::Java::Text, :ParseException
      include_const ::Sun::Text::Normalizer, :UCharacter
      include_const ::Sun::Text::Normalizer, :UTF16
    }
  end
  
  # Ported code from ICU punycode.c
  # @author ram
  # 
  # Package Private class
  class Punycode 
    include_class_members PunycodeImports
    
    class_module.module_eval {
      # Punycode parameters for Bootstring
      const_set_lazy(:BASE) { 36 }
      const_attr_reader  :BASE
      
      const_set_lazy(:TMIN) { 1 }
      const_attr_reader  :TMIN
      
      const_set_lazy(:TMAX) { 26 }
      const_attr_reader  :TMAX
      
      const_set_lazy(:SKEW) { 38 }
      const_attr_reader  :SKEW
      
      const_set_lazy(:DAMP) { 700 }
      const_attr_reader  :DAMP
      
      const_set_lazy(:INITIAL_BIAS) { 72 }
      const_attr_reader  :INITIAL_BIAS
      
      const_set_lazy(:INITIAL_N) { 0x80 }
      const_attr_reader  :INITIAL_N
      
      # "Basic" Unicode/ASCII code points
      const_set_lazy(:HYPHEN) { 0x2d }
      const_attr_reader  :HYPHEN
      
      const_set_lazy(:DELIMITER) { HYPHEN }
      const_attr_reader  :DELIMITER
      
      const_set_lazy(:ZERO) { 0x30 }
      const_attr_reader  :ZERO
      
      const_set_lazy(:NINE) { 0x39 }
      const_attr_reader  :NINE
      
      const_set_lazy(:SMALL_A) { 0x61 }
      const_attr_reader  :SMALL_A
      
      const_set_lazy(:SMALL_Z) { 0x7a }
      const_attr_reader  :SMALL_Z
      
      const_set_lazy(:CAPITAL_A) { 0x41 }
      const_attr_reader  :CAPITAL_A
      
      const_set_lazy(:CAPITAL_Z) { 0x5a }
      const_attr_reader  :CAPITAL_Z
      
      # TODO: eliminate the 256 limitation
      const_set_lazy(:MAX_CP_COUNT) { 256 }
      const_attr_reader  :MAX_CP_COUNT
      
      const_set_lazy(:UINT_MAGIC) { -0x80000000 }
      const_attr_reader  :UINT_MAGIC
      
      const_set_lazy(:ULONG_MAGIC) { -0x8000000000000000 }
      const_attr_reader  :ULONG_MAGIC
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
      def adapt_bias(delta, length, first_time)
        if (first_time)
          delta /= DAMP
        else
          delta /= 2
        end
        delta += delta / length
        count = 0
        while delta > ((BASE - TMIN) * TMAX) / 2
          delta /= (BASE - TMIN)
          count += BASE
        end
        return count + (((BASE - TMIN + 1) * delta) / (delta + SKEW))
      end
      
      # basicToDigit[] contains the numeric value of a basic code
      # point (for use in representing integers) in the range 0 to
      # BASE-1, or -1 if b is does not represent a value.
      const_set_lazy(:BasicToDigit) { Array.typed(::Java::Int).new([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]) }
      const_attr_reader  :BasicToDigit
      
      typesig { [::Java::Char, ::Java::Boolean] }
      def ascii_case_map(b, uppercase)
        if (uppercase)
          if (SMALL_A <= b && b <= SMALL_Z)
            b -= (SMALL_A - CAPITAL_A)
          end
        else
          if (CAPITAL_A <= b && b <= CAPITAL_Z)
            b += (SMALL_A - CAPITAL_A)
          end
        end
        return b
      end
      
      typesig { [::Java::Int, ::Java::Boolean] }
      # digitToBasic() returns the basic code point whose value
      # (when used for representing integers) is d, which must be in the
      # range 0 to BASE-1. The lowercase form is used unless the uppercase flag is
      # nonzero, in which case the uppercase form is used.
      def digit_to_basic(digit, uppercase)
        # 0..25 map to ASCII a..z or A..Z
        # 26..35 map to ASCII 0..9
        if (digit < 26)
          if (uppercase)
            return RJava.cast_to_char((CAPITAL_A + digit))
          else
            return RJava.cast_to_char((SMALL_A + digit))
          end
        else
          return RJava.cast_to_char(((ZERO - 26) + digit))
        end
      end
      
      typesig { [StringBuffer, Array.typed(::Java::Boolean)] }
      # Converts Unicode to Punycode.
      # The input string must not contain single, unpaired surrogates.
      # The output will be represented as an array of ASCII code points.
      # 
      # @param src
      # @param caseFlags
      # @return
      # @throws ParseException
      def encode(src, case_flags)
        cp_buffer = Array.typed(::Java::Int).new(MAX_CP_COUNT) { 0 }
        n = 0
        delta = 0
        handled_cpcount = 0
        basic_length = 0
        dest_length = 0
        bias = 0
        j = 0
        m = 0
        q = 0
        k = 0
        t = 0
        src_cpcount = 0
        c = 0
        c2 = 0
        src_length = src.length
        dest_capacity = MAX_CP_COUNT
        dest = CharArray.new(dest_capacity)
        result = StringBuffer.new
        # Handle the basic code points and
        # convert extended ones to UTF-32 in cpBuffer (caseFlag in sign bit):
        src_cpcount = dest_length = 0
        j = 0
        while j < src_length
          if ((src_cpcount).equal?(MAX_CP_COUNT))
            # too many input code points
            raise IndexOutOfBoundsException.new
          end
          c = src.char_at(j)
          if (is_basic(c))
            if (dest_length < dest_capacity)
              cp_buffer[((src_cpcount += 1) - 1)] = 0
              dest[dest_length] = !(case_flags).nil? ? ascii_case_map(c, case_flags[j]) : c
            end
            (dest_length += 1)
          else
            n = ((!(case_flags).nil? && case_flags[j]) ? 1 : 0) << 31
            if (!UTF16.is_surrogate(c))
              n |= c
            else
              if (UTF16.is_lead_surrogate(c) && (j + 1) < src_length && UTF16.is_trail_surrogate(c2 = src.char_at(j + 1)))
                (j += 1)
                n |= UCharacter.get_code_point(c, c2)
              else
                # error: unmatched surrogate
                raise ParseException.new("Illegal char found", -1)
              end
            end
            cp_buffer[((src_cpcount += 1) - 1)] = n
          end
          (j += 1)
        end
        # Finish the basic string - if it is not empty - with a delimiter.
        basic_length = dest_length
        if (basic_length > 0)
          if (dest_length < dest_capacity)
            dest[dest_length] = DELIMITER
          end
          (dest_length += 1)
        end
        # handledCPCount is the number of code points that have been handled
        # basicLength is the number of basic code points
        # destLength is the number of chars that have been output
        # 
        # Initialize the state:
        n = INITIAL_N
        delta = 0
        bias = INITIAL_BIAS
        # Main encoding loop:
        # no op
        handled_cpcount = basic_length
        while handled_cpcount < src_cpcount
          # All non-basic code points < n have been handled already.
          # Find the next larger one:
          m = 0x7fffffff
          j = 0
          while j < src_cpcount
            q = cp_buffer[j] & 0x7fffffff
            # remove case flag from the sign bit
            if (n <= q && q < m)
              m = q
            end
            (j += 1)
          end
          # Increase delta enough to advance the decoder's
          # <n,i> state to <m,0>, but guard against overflow:
          if (m - n > (0x7fffffff - MAX_CP_COUNT - delta) / (handled_cpcount + 1))
            raise RuntimeException.new("Internal program error")
          end
          delta += (m - n) * (handled_cpcount + 1)
          n = m
          # Encode a sequence of same code points n
          j = 0
          while j < src_cpcount
            q = cp_buffer[j] & 0x7fffffff
            # remove case flag from the sign bit
            if (q < n)
              (delta += 1)
            else
              if ((q).equal?(n))
                # Represent delta as a generalized variable-length integer:
                # no condition
                q = delta
                k = BASE
                loop do
                  # RAM: comment out the old code for conformance with draft-ietf-idn-punycode-03.txt
                  # 
                  # t=k-bias;
                  # if(t<TMIN) {
                  # t=TMIN;
                  # } else if(t>TMAX) {
                  # t=TMAX;
                  # }
                  t = k - bias
                  if (t < TMIN)
                    t = TMIN
                  else
                    if (k >= (bias + TMAX))
                      t = TMAX
                    end
                  end
                  if (q < t)
                    break
                  end
                  if (dest_length < dest_capacity)
                    dest[((dest_length += 1) - 1)] = digit_to_basic(t + (q - t) % (BASE - t), false)
                  end
                  q = (q - t) / (BASE - t)
                  k += BASE
                end
                if (dest_length < dest_capacity)
                  dest[((dest_length += 1) - 1)] = digit_to_basic(q, (cp_buffer[j] < 0))
                end
                bias = adapt_bias(delta, handled_cpcount + 1, ((handled_cpcount).equal?(basic_length)))
                delta = 0
                (handled_cpcount += 1)
              end
            end
            (j += 1)
          end
          (delta += 1)
          (n += 1)
        end
        return result.append(dest, 0, dest_length)
      end
      
      typesig { [::Java::Int] }
      def is_basic(ch)
        return (ch < INITIAL_N)
      end
      
      typesig { [::Java::Int] }
      def is_basic_upper_case(ch)
        return (CAPITAL_A <= ch && ch <= CAPITAL_Z)
      end
      
      typesig { [::Java::Int] }
      def is_surrogate(ch)
        return ((((ch) & -0x800)).equal?(0xd800))
      end
      
      typesig { [StringBuffer, Array.typed(::Java::Boolean)] }
      # Converts Punycode to Unicode.
      # The Unicode string will be at most as long as the Punycode string.
      # 
      # @param src
      # @param caseFlags
      # @return
      # @throws ParseException
      def decode(src, case_flags)
        src_length = src.length
        result = StringBuffer.new
        n = 0
        dest_length = 0
        i = 0
        bias = 0
        basic_length = 0
        j = 0
        in_ = 0
        oldi = 0
        w = 0
        k = 0
        digit = 0
        t = 0
        dest_cpcount = 0
        first_supplementary_index = 0
        cp_length = 0
        b = 0
        dest_capacity = MAX_CP_COUNT
        dest = CharArray.new(dest_capacity)
        # Handle the basic code points:
        # Let basicLength be the number of input code points
        # before the last delimiter, or 0 if there is none,
        # then copy the first basicLength code points to the output.
        # 
        # The two following loops iterate backward.
        j = src_length
        while j > 0
          if ((src.char_at((j -= 1))).equal?(DELIMITER))
            break
          end
        end
        dest_length = basic_length = dest_cpcount = j
        while (j > 0)
          b = src.char_at((j -= 1))
          if (!is_basic(b))
            raise ParseException.new("Illegal char found", -1)
          end
          if (j < dest_capacity)
            dest[j] = b
            if (!(case_flags).nil?)
              case_flags[j] = is_basic_upper_case(b)
            end
          end
        end
        # Initialize the state:
        n = INITIAL_N
        i = 0
        bias = INITIAL_BIAS
        first_supplementary_index = 1000000000
        # Main decoding loop:
        # Start just after the last delimiter if any
        # basic code points were copied; start at the beginning otherwise.
        # 
        # no op
        in_ = basic_length > 0 ? basic_length + 1 : 0
        while in_ < src_length
          # in is the index of the next character to be consumed, and
          # destCPCount is the number of code points in the output array.
          # 
          # Decode a generalized variable-length integer into delta,
          # which gets added to i.  The overflow checking is easier
          # if we increase i as we go, then subtract off its starting
          # value at the end to obtain delta.
          # 
          # no condition
          oldi = i
          w = 1
          k = BASE
          loop do
            if (in_ >= src_length)
              raise ParseException.new("Illegal char found", -1)
            end
            digit = BasicToDigit[src.char_at(((in_ += 1) - 1))]
            if (digit < 0)
              raise ParseException.new("Invalid char found", -1)
            end
            if (digit > (0x7fffffff - i) / w)
              # integer overflow
              raise ParseException.new("Illegal char found", -1)
            end
            i += digit * w
            t = k - bias
            if (t < TMIN)
              t = TMIN
            else
              if (k >= (bias + TMAX))
                t = TMAX
              end
            end
            if (digit < t)
              break
            end
            if (w > 0x7fffffff / (BASE - t))
              # integer overflow
              raise ParseException.new("Illegal char found", -1)
            end
            w *= BASE - t
            k += BASE
          end
          # Modification from sample code:
          # Increments destCPCount here,
          # where needed instead of in for() loop tail.
          (dest_cpcount += 1)
          bias = adapt_bias(i - oldi, dest_cpcount, ((oldi).equal?(0)))
          # i was supposed to wrap around from (incremented) destCPCount to 0,
          # incrementing n each time, so we'll fix that now:
          if (i / dest_cpcount > (0x7fffffff - n))
            # integer overflow
            raise ParseException.new("Illegal char found", -1)
          end
          n += i / dest_cpcount
          i %= dest_cpcount
          # not needed for Punycode:
          # if (decode_digit(n) <= BASE) return punycode_invalid_input;
          if (n > 0x10ffff || is_surrogate(n))
            # Unicode code point overflow
            raise ParseException.new("Illegal char found", -1)
          end
          # Insert n at position i of the output:
          cp_length = UTF16.get_char_count(n)
          if ((dest_length + cp_length) < dest_capacity)
            code_unit_index = 0
            # Handle indexes when supplementary code points are present.
            # 
            # In almost all cases, there will be only BMP code points before i
            # and even in the entire string.
            # This is handled with the same efficiency as with UTF-32.
            # 
            # Only the rare cases with supplementary code points are handled
            # more slowly - but not too bad since this is an insertion anyway.
            if (i <= first_supplementary_index)
              code_unit_index = i
              if (cp_length > 1)
                first_supplementary_index = code_unit_index
              else
                (first_supplementary_index += 1)
              end
            else
              code_unit_index = first_supplementary_index
              code_unit_index = UTF16.move_code_point_offset(dest, 0, dest_length, code_unit_index, i - code_unit_index)
            end
            # use the UChar index codeUnitIndex instead of the code point index i
            if (code_unit_index < dest_length)
              System.arraycopy(dest, code_unit_index, dest, code_unit_index + cp_length, (dest_length - code_unit_index))
              if (!(case_flags).nil?)
                System.arraycopy(case_flags, code_unit_index, case_flags, code_unit_index + cp_length, dest_length - code_unit_index)
              end
            end
            if ((cp_length).equal?(1))
              # BMP, insert one code unit
              dest[code_unit_index] = RJava.cast_to_char(n)
            else
              # supplementary character, insert two code units
              dest[code_unit_index] = UTF16.get_lead_surrogate(n)
              dest[code_unit_index + 1] = UTF16.get_trail_surrogate(n)
            end
            if (!(case_flags).nil?)
              # Case of last character determines uppercase flag:
              case_flags[code_unit_index] = is_basic_upper_case(src.char_at(in_ - 1))
              if ((cp_length).equal?(2))
                case_flags[code_unit_index + 1] = false
              end
            end
          end
          dest_length += cp_length
          (i += 1)
        end
        result.append(dest, 0, dest_length)
        return result
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__punycode, :initialize
  end
  
end
