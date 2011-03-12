require "rjava"

# Portions Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
#                                                                             *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module UTF16Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
    }
  end
  
  # <p>Standalone utility class providing UTF16 character conversions and
  # indexing conversions.</p>
  # <p>Code that uses strings alone rarely need modification.
  # By design, UTF-16 does not allow overlap, so searching for strings is a safe
  # operation. Similarly, concatenation is always safe. Substringing is safe if
  # the start and end are both on UTF-32 boundaries. In normal code, the values
  # for start and end are on those boundaries, since they arose from operations
  # like searching. If not, the nearest UTF-32 boundaries can be determined
  # using <code>bounds()</code>.</p>
  # <strong>Examples:</strong>
  # <p>The following examples illustrate use of some of these methods.
  # <pre>
  # // iteration forwards: Original
  # for (int i = 0; i &lt; s.length(); ++i) {
  #     char ch = s.charAt(i);
  #     doSomethingWith(ch);
  # }
  # 
  # // iteration forwards: Changes for UTF-32
  # int ch;
  # for (int i = 0; i &lt; s.length(); i+=UTF16.getCharCount(ch)) {
  #     ch = UTF16.charAt(s,i);
  #     doSomethingWith(ch);
  # }
  # 
  # // iteration backwards: Original
  # for (int i = s.length() -1; i >= 0; --i) {
  #     char ch = s.charAt(i);
  #     doSomethingWith(ch);
  # }
  # 
  # // iteration backwards: Changes for UTF-32
  # int ch;
  # for (int i = s.length() -1; i > 0; i-=UTF16.getCharCount(ch)) {
  #     ch = UTF16.charAt(s,i);
  #     doSomethingWith(ch);
  # }
  # </pre>
  # <strong>Notes:</strong>
  # <ul>
  #   <li>
  #   <strong>Naming:</strong> For clarity, High and Low surrogates are called
  #   <code>Lead</code> and <code>Trail</code> in the API, which gives a better
  #   sense of their ordering in a string. <code>offset16</code> and
  #   <code>offset32</code> are used to distinguish offsets to UTF-16
  #   boundaries vs offsets to UTF-32 boundaries. <code>int char32</code> is
  #   used to contain UTF-32 characters, as opposed to <code>char16</code>,
  #   which is a UTF-16 code unit.
  #   </li>
  #   <li>
  #   <strong>Roundtripping Offsets:</strong> You can always roundtrip from a
  #   UTF-32 offset to a UTF-16 offset and back. Because of the difference in
  #   structure, you can roundtrip from a UTF-16 offset to a UTF-32 offset and
  #   back if and only if <code>bounds(string, offset16) != TRAIL</code>.
  #   </li>
  #   <li>
  #    <strong>Exceptions:</strong> The error checking will throw an exception
  #   if indices are out of bounds. Other than than that, all methods will
  #   behave reasonably, even if unmatched surrogates or out-of-bounds UTF-32
  #   values are present. <code>UCharacter.isLegal()</code> can be used to check
  #   for validity if desired.
  #   </li>
  #   <li>
  #   <strong>Unmatched Surrogates:</strong> If the string contains unmatched
  #   surrogates, then these are counted as one UTF-32 value. This matches
  #   their iteration behavior, which is vital. It also matches common display
  #   practice as missing glyphs (see the Unicode Standard Section 5.4, 5.5).
  #   </li>
  #   <li>
  #     <strong>Optimization:</strong> The method implementations may need
  #     optimization if the compiler doesn't fold static final methods. Since
  #     surrogate pairs will form an exceeding small percentage of all the text
  #     in the world, the singleton case should always be optimized for.
  #   </li>
  # </ul>
  # @author Mark Davis, with help from Markus Scherer
  # @stable ICU 2.1
  class UTF16 
    include_class_members UTF16Imports
    
    class_module.module_eval {
      # public variables ---------------------------------------------------
      # The lowest Unicode code point value.
      # @stable ICU 2.1
      const_set_lazy(:CODEPOINT_MIN_VALUE) { 0 }
      const_attr_reader  :CODEPOINT_MIN_VALUE
      
      # The highest Unicode code point value (scalar value) according to the
      # Unicode Standard.
      # @stable ICU 2.1
      const_set_lazy(:CODEPOINT_MAX_VALUE) { 0x10ffff }
      const_attr_reader  :CODEPOINT_MAX_VALUE
      
      # The minimum value for Supplementary code points
      # @stable ICU 2.1
      const_set_lazy(:SUPPLEMENTARY_MIN_VALUE) { 0x10000 }
      const_attr_reader  :SUPPLEMENTARY_MIN_VALUE
      
      # Lead surrogate minimum value
      # @stable ICU 2.1
      const_set_lazy(:LEAD_SURROGATE_MIN_VALUE) { 0xd800 }
      const_attr_reader  :LEAD_SURROGATE_MIN_VALUE
      
      # Trail surrogate minimum value
      # @stable ICU 2.1
      const_set_lazy(:TRAIL_SURROGATE_MIN_VALUE) { 0xdc00 }
      const_attr_reader  :TRAIL_SURROGATE_MIN_VALUE
      
      # Lead surrogate maximum value
      # @stable ICU 2.1
      const_set_lazy(:LEAD_SURROGATE_MAX_VALUE) { 0xdbff }
      const_attr_reader  :LEAD_SURROGATE_MAX_VALUE
      
      # Trail surrogate maximum value
      # @stable ICU 2.1
      const_set_lazy(:TRAIL_SURROGATE_MAX_VALUE) { 0xdfff }
      const_attr_reader  :TRAIL_SURROGATE_MAX_VALUE
      
      # Surrogate minimum value
      # @stable ICU 2.1
      const_set_lazy(:SURROGATE_MIN_VALUE) { LEAD_SURROGATE_MIN_VALUE }
      const_attr_reader  :SURROGATE_MIN_VALUE
      
      typesig { [String, ::Java::Int] }
      # public method ------------------------------------------------------
      # Extract a single UTF-32 value from a string.
      # Used when iterating forwards or backwards (with
      # <code>UTF16.getCharCount()</code>, as well as random access. If a
      # validity check is required, use
      # <code><a href="../lang/UCharacter.html#isLegal(char)">
      # UCharacter.isLegal()</a></code> on the return value.
      # If the char retrieved is part of a surrogate pair, its supplementary
      # character will be returned. If a complete supplementary character is
      # not found the incomplete character will be returned
      # @param source array of UTF-16 chars
      # @param offset16 UTF-16 offset to the start of the character.
      # @return UTF-32 value for the UTF-32 value that contains the char at
      #         offset16. The boundaries of that codepoint are the same as in
      #         <code>bounds32()</code>.
      # @exception IndexOutOfBoundsException thrown if offset16 is out of
      #            bounds.
      # @stable ICU 2.1
      def char_at(source, offset16)
        if (offset16 < 0 || offset16 >= source.length)
          raise StringIndexOutOfBoundsException.new(offset16)
        end
        single = source.char_at(offset16)
        if (single < LEAD_SURROGATE_MIN_VALUE || single > TRAIL_SURROGATE_MAX_VALUE)
          return single
        end
        # Convert the UTF-16 surrogate pair if necessary.
        # For simplicity in usage, and because the frequency of pairs is
        # low, look both directions.
        if (single <= LEAD_SURROGATE_MAX_VALUE)
          (offset16 += 1)
          if (!(source.length).equal?(offset16))
            trail = source.char_at(offset16)
            if (trail >= TRAIL_SURROGATE_MIN_VALUE && trail <= TRAIL_SURROGATE_MAX_VALUE)
              return UCharacterProperty.get_raw_supplementary(single, trail)
            end
          end
        else
          (offset16 -= 1)
          if (offset16 >= 0)
            # single is a trail surrogate so
            lead = source.char_at(offset16)
            if (lead >= LEAD_SURROGATE_MIN_VALUE && lead <= LEAD_SURROGATE_MAX_VALUE)
              return UCharacterProperty.get_raw_supplementary(lead, single)
            end
          end
        end
        return single # return unmatched surrogate
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Extract a single UTF-32 value from a substring.
      # Used when iterating forwards or backwards (with
      # <code>UTF16.getCharCount()</code>, as well as random access. If a
      # validity check is required, use
      # <code><a href="../lang/UCharacter.html#isLegal(char)">UCharacter.isLegal()
      # </a></code> on the return value.
      # If the char retrieved is part of a surrogate pair, its supplementary
      # character will be returned. If a complete supplementary character is
      # not found the incomplete character will be returned
      # @param source array of UTF-16 chars
      # @param start offset to substring in the source array for analyzing
      # @param limit offset to substring in the source array for analyzing
      # @param offset16 UTF-16 offset relative to start
      # @return UTF-32 value for the UTF-32 value that contains the char at
      #         offset16. The boundaries of that codepoint are the same as in
      #         <code>bounds32()</code>.
      # @exception IndexOutOfBoundsException thrown if offset16 is not within
      #            the range of start and limit.
      # @stable ICU 2.1
      def char_at(source, start, limit, offset16)
        offset16 += start
        if (offset16 < start || offset16 >= limit)
          raise ArrayIndexOutOfBoundsException.new(offset16)
        end
        single = source[offset16]
        if (!is_surrogate(single))
          return single
        end
        # Convert the UTF-16 surrogate pair if necessary.
        # For simplicity in usage, and because the frequency of pairs is
        # low, look both directions.
        if (single <= LEAD_SURROGATE_MAX_VALUE)
          offset16 += 1
          if (offset16 >= limit)
            return single
          end
          trail = source[offset16]
          if (is_trail_surrogate(trail))
            return UCharacterProperty.get_raw_supplementary(single, trail)
          end
        else
          # isTrailSurrogate(single), so
          if ((offset16).equal?(start))
            return single
          end
          offset16 -= 1
          lead = source[offset16]
          if (is_lead_surrogate(lead))
            return UCharacterProperty.get_raw_supplementary(lead, single)
          end
        end
        return single # return unmatched surrogate
      end
      
      typesig { [::Java::Int] }
      # Determines how many chars this char32 requires.
      # If a validity check is required, use <code>
      # <a href="../lang/UCharacter.html#isLegal(char)">isLegal()</a></code> on
      # char32 before calling.
      # @param char32 the input codepoint.
      # @return 2 if is in supplementary space, otherwise 1.
      # @stable ICU 2.1
      def get_char_count(char32)
        if (char32 < SUPPLEMENTARY_MIN_VALUE)
          return 1
        end
        return 2
      end
      
      typesig { [::Java::Char] }
      # Determines whether the code value is a surrogate.
      # @param char16 the input character.
      # @return true iff the input character is a surrogate.
      # @stable ICU 2.1
      def is_surrogate(char16)
        return LEAD_SURROGATE_MIN_VALUE <= char16 && char16 <= TRAIL_SURROGATE_MAX_VALUE
      end
      
      typesig { [::Java::Char] }
      # Determines whether the character is a trail surrogate.
      # @param char16 the input character.
      # @return true iff the input character is a trail surrogate.
      # @stable ICU 2.1
      def is_trail_surrogate(char16)
        return (TRAIL_SURROGATE_MIN_VALUE <= char16 && char16 <= TRAIL_SURROGATE_MAX_VALUE)
      end
      
      typesig { [::Java::Char] }
      # Determines whether the character is a lead surrogate.
      # @param char16 the input character.
      # @return true iff the input character is a lead surrogate
      # @stable ICU 2.1
      def is_lead_surrogate(char16)
        return LEAD_SURROGATE_MIN_VALUE <= char16 && char16 <= LEAD_SURROGATE_MAX_VALUE
      end
      
      typesig { [::Java::Int] }
      # Returns the lead surrogate.
      # If a validity check is required, use
      # <code><a href="../lang/UCharacter.html#isLegal(char)">isLegal()</a></code>
      # on char32 before calling.
      # @param char32 the input character.
      # @return lead surrogate if the getCharCount(ch) is 2; <br>
      #         and 0 otherwise (note: 0 is not a valid lead surrogate).
      # @stable ICU 2.1
      def get_lead_surrogate(char32)
        if (char32 >= SUPPLEMENTARY_MIN_VALUE)
          return RJava.cast_to_char((LEAD_SURROGATE_OFFSET_ + (char32 >> LEAD_SURROGATE_SHIFT_)))
        end
        return 0
      end
      
      typesig { [::Java::Int] }
      # Returns the trail surrogate.
      # If a validity check is required, use
      # <code><a href="../lang/UCharacter.html#isLegal(char)">isLegal()</a></code>
      # on char32 before calling.
      # @param char32 the input character.
      # @return the trail surrogate if the getCharCount(ch) is 2; <br>otherwise
      #         the character itself
      # @stable ICU 2.1
      def get_trail_surrogate(char32)
        if (char32 >= SUPPLEMENTARY_MIN_VALUE)
          return RJava.cast_to_char((TRAIL_SURROGATE_MIN_VALUE + (char32 & TRAIL_SURROGATE_MASK_)))
        end
        return RJava.cast_to_char(char32)
      end
      
      typesig { [::Java::Int] }
      # Convenience method corresponding to String.valueOf(char). Returns a one
      # or two char string containing the UTF-32 value in UTF16 format. If a
      # validity check is required, use
      # <code><a href="../lang/UCharacter.html#isLegal(char)">isLegal()</a></code>
      # on char32 before calling.
      # @param char32 the input character.
      # @return string value of char32 in UTF16 format
      # @exception IllegalArgumentException thrown if char32 is a invalid
      #            codepoint.
      # @stable ICU 2.1
      def value_of(char32)
        if (char32 < CODEPOINT_MIN_VALUE || char32 > CODEPOINT_MAX_VALUE)
          raise IllegalArgumentException.new("Illegal codepoint")
        end
        return to_s(char32)
      end
      
      typesig { [StringBuffer, ::Java::Int] }
      # Append a single UTF-32 value to the end of a StringBuffer.
      # If a validity check is required, use
      # <code><a href="../lang/UCharacter.html#isLegal(char)">isLegal()</a></code>
      # on char32 before calling.
      # @param target the buffer to append to
      # @param char32 value to append.
      # @return the updated StringBuffer
      # @exception IllegalArgumentException thrown when char32 does not lie
      #            within the range of the Unicode codepoints
      # @stable ICU 2.1
      def append(target, char32)
        # Check for irregular values
        if (char32 < CODEPOINT_MIN_VALUE || char32 > CODEPOINT_MAX_VALUE)
          raise IllegalArgumentException.new("Illegal codepoint: " + RJava.cast_to_string(JavaInteger.to_hex_string(char32)))
        end
        # Write the UTF-16 values
        if (char32 >= SUPPLEMENTARY_MIN_VALUE)
          target.append(get_lead_surrogate(char32))
          target.append(get_trail_surrogate(char32))
        else
          target.append(RJava.cast_to_char(char32))
        end
        return target
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # // for StringPrep
      # Shifts offset16 by the argument number of codepoints within a subarray.
      # @param source char array
      # @param start position of the subarray to be performed on
      # @param limit position of the subarray to be performed on
      # @param offset16 UTF16 position to shift relative to start
      # @param shift32 number of codepoints to shift
      # @return new shifted offset16 relative to start
      # @exception IndexOutOfBoundsException if the new offset16 is out of
      #            bounds with respect to the subarray or the subarray bounds
      #            are out of range.
      # @stable ICU 2.1
      def move_code_point_offset(source, start, limit, offset16, shift32)
        size = source.attr_length
        count = 0
        ch = 0
        result = offset16 + start
        if (start < 0 || limit < start)
          raise StringIndexOutOfBoundsException.new(start)
        end
        if (limit > size)
          raise StringIndexOutOfBoundsException.new(limit)
        end
        if (offset16 < 0 || result > limit)
          raise StringIndexOutOfBoundsException.new(offset16)
        end
        if (shift32 > 0)
          if (shift32 + result > size)
            raise StringIndexOutOfBoundsException.new(result)
          end
          count = shift32
          while (result < limit && count > 0)
            ch = source[result]
            if (is_lead_surrogate(ch) && (result + 1 < limit) && is_trail_surrogate(source[result + 1]))
              result += 1
            end
            count -= 1
            result += 1
          end
        else
          if (result + shift32 < start)
            raise StringIndexOutOfBoundsException.new(result)
          end
          count = -shift32
          while count > 0
            result -= 1
            if (result < start)
              break
            end
            ch = source[result]
            if (is_trail_surrogate(ch) && result > start && is_lead_surrogate(source[result - 1]))
              result -= 1
            end
            count -= 1
          end
        end
        if (!(count).equal?(0))
          raise StringIndexOutOfBoundsException.new(shift32)
        end
        result -= start
        return result
      end
      
      # private data members -------------------------------------------------
      # Shift value for lead surrogate to form a supplementary character.
      const_set_lazy(:LEAD_SURROGATE_SHIFT_) { 10 }
      const_attr_reader  :LEAD_SURROGATE_SHIFT_
      
      # Mask to retrieve the significant value from a trail surrogate.
      const_set_lazy(:TRAIL_SURROGATE_MASK_) { 0x3ff }
      const_attr_reader  :TRAIL_SURROGATE_MASK_
      
      # Value that all lead surrogate starts with
      const_set_lazy(:LEAD_SURROGATE_OFFSET_) { LEAD_SURROGATE_MIN_VALUE - (SUPPLEMENTARY_MIN_VALUE >> LEAD_SURROGATE_SHIFT_) }
      const_attr_reader  :LEAD_SURROGATE_OFFSET_
      
      typesig { [::Java::Int] }
      # private methods ------------------------------------------------------
      # <p>Converts argument code point and returns a String object representing
      # the code point's value in UTF16 format.</p>
      # <p>This method does not check for the validity of the codepoint, the
      # results are not guaranteed if a invalid codepoint is passed as
      # argument.</p>
      # <p>The result is a string whose length is 1 for non-supplementary code
      # points, 2 otherwise.</p>
      # @param ch code point
      # @return string representation of the code point
      def to_s(ch)
        if (ch < SUPPLEMENTARY_MIN_VALUE)
          return String.value_of(RJava.cast_to_char(ch))
        end
        result = StringBuffer.new
        result.append(get_lead_surrogate(ch))
        result.append(get_trail_surrogate(ch))
        return result.to_s
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__utf16, :initialize
  end
  
end
