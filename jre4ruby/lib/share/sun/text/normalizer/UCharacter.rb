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
  module UCharacterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
    }
  end
  
  # <p>
  # The UCharacter class provides extensions to the
  # <a href=http://java.sun.com/j2se/1.3/docs/api/java/lang/Character.html>
  # java.lang.Character</a> class. These extensions provide support for
  # Unicode 3.2 properties and together with the <a href=../text/UTF16.html>UTF16</a>
  # class, provide support for supplementary characters (those with code
  # points above U+FFFF).
  # </p>
  # <p>
  # Code points are represented in these API using ints. While it would be
  # more convenient in Java to have a separate primitive datatype for them,
  # ints suffice in the meantime.
  # </p>
  # <p>
  # To use this class please add the jar file name icu4j.jar to the
  # class path, since it contains data files which supply the information used
  # by this file.<br>
  # E.g. In Windows <br>
  # <code>set CLASSPATH=%CLASSPATH%;$JAR_FILE_PATH/ucharacter.jar</code>.<br>
  # Otherwise, another method would be to copy the files uprops.dat and
  # unames.icu from the icu4j source subdirectory
  # <i>$ICU4J_SRC/src/com.ibm.icu.impl.data</i> to your class directory
  # <i>$ICU4J_CLASS/com.ibm.icu.impl.data</i>.
  # </p>
  # <p>
  # Aside from the additions for UTF-16 support, and the updated Unicode 3.1
  # properties, the main differences between UCharacter and Character are:
  # <ul>
  # <li> UCharacter is not designed to be a char wrapper and does not have
  # APIs to which involves management of that single char.<br>
  # These include:
  # <ul>
  # <li> char charValue(),
  # <li> int compareTo(java.lang.Character, java.lang.Character), etc.
  # </ul>
  # <li> UCharacter does not include Character APIs that are deprecated, not
  # does it include the Java-specific character information, such as
  # boolean isJavaIdentifierPart(char ch).
  # <li> Character maps characters 'A' - 'Z' and 'a' - 'z' to the numeric
  # values '10' - '35'. UCharacter also does this in digit and
  # getNumericValue, to adhere to the java semantics of these
  # methods.  New methods unicodeDigit, and
  # getUnicodeNumericValue do not treat the above code points
  # as having numeric values.  This is a semantic change from ICU4J 1.3.1.
  # </ul>
  # <p>
  # Further detail differences can be determined from the program
  # <a href = http://oss.software.ibm.com/developerworks/opensource/cvs/icu4j/~checkout~/icu4j/src/com/ibm/icu/dev/test/lang/UCharacterCompare.java>
  # com.ibm.icu.dev.test.lang.UCharacterCompare</a>
  # </p>
  # <p>
  # This class is not subclassable
  # </p>
  # @author Syn Wee Quek
  # @stable ICU 2.1
  # @see com.ibm.icu.lang.UCharacterEnums
  class UCharacter 
    include_class_members UCharacterImports
    
    class_module.module_eval {
      # Numeric Type constants.
      # @see UProperty#NUMERIC_TYPE
      # @stable ICU 2.4
      const_set_lazy(:NumericType) { Module.new do
        include_class_members UCharacter
        
        class_module.module_eval {
          # @stable ICU 2.4
          const_set_lazy(:NONE) { 0 }
          const_attr_reader  :NONE
          
          # @stable ICU 2.4
          const_set_lazy(:DECIMAL) { 1 }
          const_attr_reader  :DECIMAL
          
          # @stable ICU 2.4
          const_set_lazy(:DIGIT) { 2 }
          const_attr_reader  :DIGIT
          
          # @stable ICU 2.4
          const_set_lazy(:NUMERIC) { 3 }
          const_attr_reader  :NUMERIC
          
          # @stable ICU 2.4
          const_set_lazy(:COUNT) { 4 }
          const_attr_reader  :COUNT
        }
      end }
      
      # Hangul Syllable Type constants.
      # 
      # @see UProperty#HANGUL_SYLLABLE_TYPE
      # @stable ICU 2.6
      const_set_lazy(:HangulSyllableType) { Module.new do
        include_class_members UCharacter
        
        class_module.module_eval {
          # @stable ICU 2.6
          const_set_lazy(:NOT_APPLICABLE) { 0 }
          const_attr_reader  :NOT_APPLICABLE
          
          # [NA]
          # See note !!
          # 
          # @stable ICU 2.6
          const_set_lazy(:LEADING_JAMO) { 1 }
          const_attr_reader  :LEADING_JAMO
          
          # [L]
          # 
          # @stable ICU 2.6
          const_set_lazy(:VOWEL_JAMO) { 2 }
          const_attr_reader  :VOWEL_JAMO
          
          # [V]
          # 
          # @stable ICU 2.6
          const_set_lazy(:TRAILING_JAMO) { 3 }
          const_attr_reader  :TRAILING_JAMO
          
          # [T]
          # 
          # @stable ICU 2.6
          const_set_lazy(:LV_SYLLABLE) { 4 }
          const_attr_reader  :LV_SYLLABLE
          
          # [LV]
          # 
          # @stable ICU 2.6
          const_set_lazy(:LVT_SYLLABLE) { 5 }
          const_attr_reader  :LVT_SYLLABLE
          
          # [LVT]
          # 
          # @stable ICU 2.6
          const_set_lazy(:COUNT) { 6 }
          const_attr_reader  :COUNT
        }
      end }
      
      # [Sun] This interface moved from UCharacterEnums.java.
      # 
      # 'Enum' for the CharacterCategory constants.  These constants are
      # compatible in name <b>but not in value</b> with those defined in
      # <code>java.lang.Character</code>.
      # @see UCharacterCategory
      # @draft ICU 3.0
      # @deprecated This is a draft API and might change in a future release of ICU.
      const_set_lazy(:ECharacterCategory) { Module.new do
        include_class_members UCharacter
        
        class_module.module_eval {
          # Character type Lu
          # @stable ICU 2.1
          const_set_lazy(:UPPERCASE_LETTER) { 1 }
          const_attr_reader  :UPPERCASE_LETTER
          
          # Character type Lt
          # @stable ICU 2.1
          const_set_lazy(:TITLECASE_LETTER) { 3 }
          const_attr_reader  :TITLECASE_LETTER
          
          # Character type Lo
          # @stable ICU 2.1
          const_set_lazy(:OTHER_LETTER) { 5 }
          const_attr_reader  :OTHER_LETTER
        }
      end }
      
      # public data members -----------------------------------------------
      # 
      # The lowest Unicode code point value.
      # @stable ICU 2.1
      const_set_lazy(:MIN_VALUE) { UTF16::CODEPOINT_MIN_VALUE }
      const_attr_reader  :MIN_VALUE
      
      # The highest Unicode code point value (scalar value) according to the
      # Unicode Standard.
      # This is a 21-bit value (21 bits, rounded up).<br>
      # Up-to-date Unicode implementation of java.lang.Character.MIN_VALUE
      # @stable ICU 2.1
      const_set_lazy(:MAX_VALUE) { UTF16::CODEPOINT_MAX_VALUE }
      const_attr_reader  :MAX_VALUE
      
      # The minimum value for Supplementary code points
      # @stable ICU 2.1
      const_set_lazy(:SUPPLEMENTARY_MIN_VALUE) { UTF16::SUPPLEMENTARY_MIN_VALUE }
      const_attr_reader  :SUPPLEMENTARY_MIN_VALUE
      
      # Special value that is returned by getUnicodeNumericValue(int) when no
      # numeric value is defined for a code point.
      # @stable ICU 2.4
      # @see #getUnicodeNumericValue
      const_set_lazy(:NO_NUMERIC_VALUE) { -123456789 }
      const_attr_reader  :NO_NUMERIC_VALUE
      
      typesig { [::Java::Int, ::Java::Int] }
      # public methods ----------------------------------------------------
      # 
      # Retrieves the numeric value of a decimal digit code point.
      # <br>This method observes the semantics of
      # <code>java.lang.Character.digit()</code>.  Note that this
      # will return positive values for code points for which isDigit
      # returns false, just like java.lang.Character.
      # <br><em>Semantic Change:</em> In release 1.3.1 and
      # prior, this did not treat the European letters as having a
      # digit value, and also treated numeric letters and other numbers as
      # digits.
      # This has been changed to conform to the java semantics.
      # <br>A code point is a valid digit if and only if:
      # <ul>
      # <li>ch is a decimal digit or one of the european letters, and
      # <li>the value of ch is less than the specified radix.
      # </ul>
      # @param ch the code point to query
      # @param radix the radix
      # @return the numeric value represented by the code point in the
      # specified radix, or -1 if the code point is not a decimal digit
      # or if its value is too large for the radix
      # @stable ICU 2.1
      def digit(ch, radix)
        # when ch is out of bounds getProperty == 0
        props = get_property(ch)
        if (!(get_numeric_type(props)).equal?(NumericType::DECIMAL))
          return (radix <= 10) ? -1 : get_european_digit(ch)
        end
        # if props == 0, it will just fall through and return -1
        if (is_not_exception_indicator(props))
          # not contained in exception data
          # getSignedValue is just shifting so we can check for the sign
          # first
          # Optimization
          # int result = UCharacterProperty.getSignedValue(props);
          # if (result >= 0) {
          # return result;
          # }
          if (props >= 0)
            return UCharacterProperty.get_signed_value(props)
          end
        else
          index = UCharacterProperty.get_exception_index(props)
          if (PROPERTY_.has_exception_value(index, UCharacterProperty::EXC_NUMERIC_VALUE_))
            result = PROPERTY_.get_exception(index, UCharacterProperty::EXC_NUMERIC_VALUE_)
            if (result >= 0)
              return result
            end
          end
        end
        if (radix > 10)
          result = get_european_digit(ch)
          if (result >= 0 && result < radix)
            return result
          end
        end
        return -1
      end
      
      typesig { [::Java::Int] }
      # <p>Get the numeric value for a Unicode code point as defined in the
      # Unicode Character Database.</p>
      # <p>A "double" return type is necessary because some numeric values are
      # fractions, negative, or too large for int.</p>
      # <p>For characters without any numeric values in the Unicode Character
      # Database, this function will return NO_NUMERIC_VALUE.</p>
      # <p><em>API Change:</em> In release 2.2 and prior, this API has a
      # return type int and returns -1 when the argument ch does not have a
      # corresponding numeric value. This has been changed to synch with ICU4C
      # </p>
      # This corresponds to the ICU4C function u_getNumericValue.
      # @param ch Code point to get the numeric value for.
      # @return numeric value of ch, or NO_NUMERIC_VALUE if none is defined.
      # @stable ICU 2.4
      def get_unicode_numeric_value(ch)
        # equivalent to c version double u_getNumericValue(UChar32 c)
        props = PROPERTY_.get_property(ch)
        numeric_type = get_numeric_type(props)
        if (numeric_type > NumericType::NONE && numeric_type < NumericType::COUNT)
          if (is_not_exception_indicator(props))
            return UCharacterProperty.get_signed_value(props)
          else
            index = UCharacterProperty.get_exception_index(props)
            nex = false
            dex = false
            numerator = 0
            if (PROPERTY_.has_exception_value(index, UCharacterProperty::EXC_NUMERIC_VALUE_))
              num = PROPERTY_.get_exception(index, UCharacterProperty::EXC_NUMERIC_VALUE_)
              # There are special values for huge numbers that are
              # powers of ten. genprops/store.c documents:
              # if numericValue = 0x7fffff00 + x then
              # numericValue = 10 ^ x
              if (num >= NUMERATOR_POWER_LIMIT_)
                num &= 0xff
                # 10^x without math.h
                numerator = Math.pow(10, num)
              else
                numerator = num
              end
              nex = true
            end
            denominator = 0
            if (PROPERTY_.has_exception_value(index, UCharacterProperty::EXC_DENOMINATOR_VALUE_))
              denominator = PROPERTY_.get_exception(index, UCharacterProperty::EXC_DENOMINATOR_VALUE_)
              # faster path not in c
              if (!(numerator).equal?(0))
                return numerator / denominator
              end
              dex = true
            end
            if (nex)
              if (dex)
                return numerator / denominator
              end
              return numerator
            end
            if (dex)
              return 1 / denominator
            end
          end
        end
        return NO_NUMERIC_VALUE
      end
      
      typesig { [::Java::Int] }
      # Returns a value indicating a code point's Unicode category.
      # Up-to-date Unicode implementation of java.lang.Character.getType()
      # except for the above mentioned code points that had their category
      # changed.<br>
      # Return results are constants from the interface
      # <a href=UCharacterCategory.html>UCharacterCategory</a><br>
      # <em>NOTE:</em> the UCharacterCategory values are <em>not</em> compatible with
      # those returned by java.lang.Character.getType.  UCharacterCategory values
      # match the ones used in ICU4C, while java.lang.Character type
      # values, though similar, skip the value 17.</p>
      # @param ch code point whose type is to be determined
      # @return category which is a value of UCharacterCategory
      # @stable ICU 2.1
      def get_type(ch)
        return get_property(ch) & UCharacterProperty::TYPE_MASK
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # // for StringPrep
      # 
      # Returns a code point corresponding to the two UTF16 characters.
      # @param lead the lead char
      # @param trail the trail char
      # @return code point if surrogate characters are valid.
      # @exception IllegalArgumentException thrown when argument characters do
      # not form a valid codepoint
      # @stable ICU 2.1
      def get_code_point(lead, trail)
        if (lead >= UTF16::LEAD_SURROGATE_MIN_VALUE && lead <= UTF16::LEAD_SURROGATE_MAX_VALUE && trail >= UTF16::TRAIL_SURROGATE_MIN_VALUE && trail <= UTF16::TRAIL_SURROGATE_MAX_VALUE)
          return UCharacterProperty.get_raw_supplementary(lead, trail)
        end
        raise IllegalArgumentException.new("Illegal surrogate characters")
      end
      
      typesig { [::Java::Int] }
      # // for StringPrep
      # 
      # Returns the Bidirection property of a code point.
      # For example, 0x0041 (letter A) has the LEFT_TO_RIGHT directional
      # property.<br>
      # Result returned belongs to the interface
      # <a href=UCharacterDirection.html>UCharacterDirection</a>
      # @param ch the code point to be determined its direction
      # @return direction constant from UCharacterDirection.
      # @stable ICU 2.1
      def get_direction(ch)
        # when ch is out of bounds getProperty == 0
        return (get_property(ch) >> BIDI_SHIFT_) & BIDI_MASK_AFTER_SHIFT_
      end
      
      typesig { [String, ::Java::Boolean] }
      # The given string is mapped to its case folding equivalent according to
      # UnicodeData.txt and CaseFolding.txt; if any character has no case
      # folding equivalent, the character itself is returned.
      # "Full", multiple-code point case folding mappings are returned here.
      # For "simple" single-code point mappings use the API
      # foldCase(int ch, boolean defaultmapping).
      # @param str            the String to be converted
      # @param defaultmapping Indicates if all mappings defined in
      # CaseFolding.txt is to be used, otherwise the
      # mappings for dotted I and dotless i marked with
      # 'I' in CaseFolding.txt will be skipped.
      # @return               the case folding equivalent of the character, if
      # any; otherwise the character itself.
      # @see                  #foldCase(int, boolean)
      # @stable ICU 2.1
      def fold_case(str, defaultmapping)
        size = str.length
        result = StringBuffer.new(size)
        offset = 0
        ch = 0
        # case mapping loop
        while (offset < size)
          ch = UTF16.char_at(str, offset)
          offset += UTF16.get_char_count(ch)
          props = PROPERTY_.get_property(ch)
          if (is_not_exception_indicator(props))
            type = UCharacterProperty::TYPE_MASK & props
            if ((type).equal?(ECharacterCategory::UPPERCASE_LETTER) || (type).equal?(ECharacterCategory::TITLECASE_LETTER))
              ch += UCharacterProperty.get_signed_value(props)
            end
          else
            index = UCharacterProperty.get_exception_index(props)
            if (PROPERTY_.has_exception_value(index, UCharacterProperty::EXC_CASE_FOLDING_))
              exception = PROPERTY_.get_exception(index, UCharacterProperty::EXC_CASE_FOLDING_)
              if (!(exception).equal?(0))
                PROPERTY_.get_fold_case(exception & LAST_CHAR_MASK_, exception >> SHIFT_24_, result)
              else
                # special case folding mappings, hardcoded
                if (!(ch).equal?(0x49) && !(ch).equal?(0x130))
                  # return ch itself because there is no special
                  # mapping for it
                  UTF16.append(result, ch)
                  next
                end
                if (defaultmapping)
                  # default mappings
                  if ((ch).equal?(0x49))
                    # 0049; C; 0069; # LATIN CAPITAL LETTER I
                    result.append(UCharacterProperty::LATIN_SMALL_LETTER_I_)
                  else
                    if ((ch).equal?(0x130))
                      # 0130; F; 0069 0307;
                      # # LATIN CAPITAL LETTER I WITH DOT ABOVE
                      result.append(UCharacterProperty::LATIN_SMALL_LETTER_I_)
                      result.append(RJava.cast_to_char(0x307))
                    end
                  end
                else
                  # Turkic mappings
                  if ((ch).equal?(0x49))
                    # 0049; T; 0131; # LATIN CAPITAL LETTER I
                    result.append(RJava.cast_to_char(0x131))
                  else
                    if ((ch).equal?(0x130))
                      # 0130; T; 0069;
                      # # LATIN CAPITAL LETTER I WITH DOT ABOVE
                      result.append(UCharacterProperty::LATIN_SMALL_LETTER_I_)
                    end
                  end
                end
              end
              # do not fall through to the output of c
              next
            else
              if (PROPERTY_.has_exception_value(index, UCharacterProperty::EXC_LOWERCASE_))
                ch = PROPERTY_.get_exception(index, UCharacterProperty::EXC_LOWERCASE_)
              end
            end
          end
          # handle 1:1 code point mappings from UnicodeData.txt
          UTF16.append(result, ch)
        end
        return result.to_s
      end
      
      typesig { [::Java::Int] }
      # <p>Get the "age" of the code point.</p>
      # <p>The "age" is the Unicode version when the code point was first
      # designated (as a non-character or for Private Use) or assigned a
      # character.
      # <p>This can be useful to avoid emitting code points to receiving
      # processes that do not accept newer characters.</p>
      # <p>The data is from the UCD file DerivedAge.txt.</p>
      # @param ch The code point.
      # @return the Unicode version number
      # @stable ICU 2.6
      def get_age(ch)
        if (ch < MIN_VALUE || ch > MAX_VALUE)
          raise IllegalArgumentException.new("Codepoint out of bounds")
        end
        return PROPERTY_.get_age(ch)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # <p>Gets the property value for an Unicode property type of a code point.
      # Also returns binary and mask property values.</p>
      # <p>Unicode, especially in version 3.2, defines many more properties than
      # the original set in UnicodeData.txt.</p>
      # <p>The properties APIs are intended to reflect Unicode properties as
      # defined in the Unicode Character Database (UCD) and Unicode Technical
      # Reports (UTR). For details about the properties see
      # http://www.unicode.org/.</p>
      # <p>For names of Unicode properties see the UCD file PropertyAliases.txt.
      # </p>
      # <pre>
      # Sample usage:
      # int ea = UCharacter.getIntPropertyValue(c, UProperty.EAST_ASIAN_WIDTH);
      # int ideo = UCharacter.getIntPropertyValue(c, UProperty.IDEOGRAPHIC);
      # boolean b = (ideo == 1) ? true : false;
      # </pre>
      # @param ch code point to test.
      # @param type UProperty selector constant, identifies which binary
      # property to check. Must be
      # UProperty.BINARY_START &lt;= type &lt; UProperty.BINARY_LIMIT or
      # UProperty.INT_START &lt;= type &lt; UProperty.INT_LIMIT or
      # UProperty.MASK_START &lt;= type &lt; UProperty.MASK_LIMIT.
      # @return numeric value that is directly the property value or,
      # for enumerated properties, corresponds to the numeric value of
      # the enumerated constant of the respective property value
      # enumeration type (cast to enum type if necessary).
      # Returns 0 or 1 (for false / true) for binary Unicode properties.
      # Returns a bit-mask for mask properties.
      # Returns 0 if 'type' is out of bounds or if the Unicode version
      # does not have data for the property at all, or not for this code
      # point.
      # @see UProperty
      # @see #hasBinaryProperty
      # @see #getIntPropertyMinValue
      # @see #getIntPropertyMaxValue
      # @see #getUnicodeVersion
      # @stable ICU 2.4
      def get_int_property_value(ch, type)
        # For Normalizer with Unicode 3.2, this method is called only for
        # HANGUL_SYLLABLE_TYPE in UnicodeSet.addPropertyStarts().
        if ((type).equal?(UProperty::HANGUL_SYLLABLE_TYPE))
          # purely algorithmic; hardcode known characters, check for assigned new ones
          if (ch < NormalizerImpl::JAMO_L_BASE)
            # NA
          else
            if (ch <= 0x11ff)
              # Jamo range
              if (ch <= 0x115f)
                # Jamo L range, HANGUL CHOSEONG ...
                if ((ch).equal?(0x115f) || ch <= 0x1159 || (get_type(ch)).equal?(ECharacterCategory::OTHER_LETTER))
                  return HangulSyllableType::LEADING_JAMO
                end
              else
                if (ch <= 0x11a7)
                  # Jamo V range, HANGUL JUNGSEONG ...
                  if (ch <= 0x11a2 || (get_type(ch)).equal?(ECharacterCategory::OTHER_LETTER))
                    return HangulSyllableType::VOWEL_JAMO
                  end
                else
                  # Jamo T range
                  if (ch <= 0x11f9 || (get_type(ch)).equal?(ECharacterCategory::OTHER_LETTER))
                    return HangulSyllableType::TRAILING_JAMO
                  end
                end
              end
            else
              if ((ch -= NormalizerImpl::HANGUL_BASE) < 0)
                # NA
              else
                if (ch < NormalizerImpl::HANGUL_COUNT)
                  # Hangul syllable
                  return (ch % NormalizerImpl::JAMO_T_COUNT).equal?(0) ? HangulSyllableType::LV_SYLLABLE : HangulSyllableType::LVT_SYLLABLE
                end
              end
            end
          end
        end
        return 0
        # NA
      end
      
      # block to initialise character property database
      when_class_loaded do
        begin
          const_set :PROPERTY_, UCharacterProperty.get_instance
          const_set :PROPERTY_TRIE_INDEX_, PROPERTY_.attr_m_trie_index_
          const_set :PROPERTY_TRIE_DATA_, PROPERTY_.attr_m_trie_data_
          const_set :PROPERTY_DATA_, PROPERTY_.attr_m_property_
          const_set :PROPERTY_INITIAL_VALUE_, PROPERTY_DATA_[PROPERTY_.attr_m_trie_initial_value_]
        rescue JavaException => e
          raise RuntimeException.new(e.get_message)
        end
      end
      
      # To get the last character out from a data type
      const_set_lazy(:LAST_CHAR_MASK_) { 0xffff }
      const_attr_reader  :LAST_CHAR_MASK_
      
      # To get the last byte out from a data type
      # 
      # private static final int LAST_BYTE_MASK_ = 0xFF;
      # 
      # Shift 16 bits
      # 
      # private static final int SHIFT_16_ = 16;
      # 
      # Shift 24 bits
      const_set_lazy(:SHIFT_24_) { 24 }
      const_attr_reader  :SHIFT_24_
      
      # Shift to get numeric type
      const_set_lazy(:NUMERIC_TYPE_SHIFT_) { 12 }
      const_attr_reader  :NUMERIC_TYPE_SHIFT_
      
      # Mask to get numeric type
      const_set_lazy(:NUMERIC_TYPE_MASK_) { 0x7 << NUMERIC_TYPE_SHIFT_ }
      const_attr_reader  :NUMERIC_TYPE_MASK_
      
      # Shift to get bidi bits
      const_set_lazy(:BIDI_SHIFT_) { 6 }
      const_attr_reader  :BIDI_SHIFT_
      
      # Mask to be applied after shifting to get bidi bits
      const_set_lazy(:BIDI_MASK_AFTER_SHIFT_) { 0x1f }
      const_attr_reader  :BIDI_MASK_AFTER_SHIFT_
      
      # <p>Numerator power limit.
      # There are special values for huge numbers that are powers of ten.</p>
      # <p>c version genprops/store.c documents:
      # if numericValue = 0x7fffff00 + x then numericValue = 10 ^ x</p>
      const_set_lazy(:NUMERATOR_POWER_LIMIT_) { 0x7fffff00 }
      const_attr_reader  :NUMERATOR_POWER_LIMIT_
      
      # Integer properties mask and shift values for joining type.
      # Equivalent to icu4c UPROPS_JT_MASK.
      const_set_lazy(:JOINING_TYPE_MASK_) { 0x3800 }
      const_attr_reader  :JOINING_TYPE_MASK_
      
      # Integer properties mask and shift values for joining type.
      # Equivalent to icu4c UPROPS_JT_SHIFT.
      const_set_lazy(:JOINING_TYPE_SHIFT_) { 11 }
      const_attr_reader  :JOINING_TYPE_SHIFT_
      
      # Integer properties mask and shift values for joining group.
      # Equivalent to icu4c UPROPS_JG_MASK.
      const_set_lazy(:JOINING_GROUP_MASK_) { 0x7e0 }
      const_attr_reader  :JOINING_GROUP_MASK_
      
      # Integer properties mask and shift values for joining group.
      # Equivalent to icu4c UPROPS_JG_SHIFT.
      const_set_lazy(:JOINING_GROUP_SHIFT_) { 5 }
      const_attr_reader  :JOINING_GROUP_SHIFT_
      
      # Integer properties mask for decomposition type.
      # Equivalent to icu4c UPROPS_DT_MASK.
      const_set_lazy(:DECOMPOSITION_TYPE_MASK_) { 0x1f }
      const_attr_reader  :DECOMPOSITION_TYPE_MASK_
      
      # Integer properties mask and shift values for East Asian cell width.
      # Equivalent to icu4c UPROPS_EA_MASK
      const_set_lazy(:EAST_ASIAN_MASK_) { 0x38000 }
      const_attr_reader  :EAST_ASIAN_MASK_
      
      # Integer properties mask and shift values for East Asian cell width.
      # Equivalent to icu4c UPROPS_EA_SHIFT
      const_set_lazy(:EAST_ASIAN_SHIFT_) { 15 }
      const_attr_reader  :EAST_ASIAN_SHIFT_
      
      # Integer properties mask and shift values for line breaks.
      # Equivalent to icu4c UPROPS_LB_MASK
      const_set_lazy(:LINE_BREAK_MASK_) { 0x7c0000 }
      const_attr_reader  :LINE_BREAK_MASK_
      
      # Integer properties mask and shift values for line breaks.
      # Equivalent to icu4c UPROPS_LB_SHIFT
      const_set_lazy(:LINE_BREAK_SHIFT_) { 18 }
      const_attr_reader  :LINE_BREAK_SHIFT_
      
      # Integer properties mask and shift values for blocks.
      # Equivalent to icu4c UPROPS_BLOCK_MASK
      const_set_lazy(:BLOCK_MASK_) { 0x7f80 }
      const_attr_reader  :BLOCK_MASK_
      
      # Integer properties mask and shift values for blocks.
      # Equivalent to icu4c UPROPS_BLOCK_SHIFT
      const_set_lazy(:BLOCK_SHIFT_) { 7 }
      const_attr_reader  :BLOCK_SHIFT_
      
      # Integer properties mask and shift values for scripts.
      # Equivalent to icu4c UPROPS_SHIFT_MASK
      const_set_lazy(:SCRIPT_MASK_) { 0x7f }
      const_attr_reader  :SCRIPT_MASK_
    }
    
    typesig { [] }
    # private constructor -----------------------------------------------
    # /CLOVER:OFF
    # 
    # Private constructor to prevent instantiation
    def initialize
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # /CLOVER:ON
      # private methods ---------------------------------------------------
      # 
      # Getting the digit values of characters like 'A' - 'Z', normal,
      # half-width and full-width. This method assumes that the other digit
      # characters are checked by the calling method.
      # @param ch character to test
      # @return -1 if ch is not a character of the form 'A' - 'Z', otherwise
      # its corresponding digit will be returned.
      def get_european_digit(ch)
        if ((ch > 0x7a && ch < 0xff21) || ch < 0x41 || (ch > 0x5a && ch < 0x61) || ch > 0xff5a || (ch > 0xff31 && ch < 0xff41))
          return -1
        end
        if (ch <= 0x7a)
          # ch >= 0x41 or ch < 0x61
          return ch + 10 - ((ch <= 0x5a) ? 0x41 : 0x61)
        end
        # ch >= 0xff21
        if (ch <= 0xff3a)
          return ch + 10 - 0xff21
        end
        # ch >= 0xff41 && ch <= 0xff5a
        return ch + 10 - 0xff41
      end
      
      typesig { [::Java::Int] }
      # Gets the numeric type of the property argument
      # @param props 32 bit property
      # @return the numeric type
      def get_numeric_type(props)
        return (props & NUMERIC_TYPE_MASK_) >> NUMERIC_TYPE_SHIFT_
      end
      
      typesig { [::Java::Int] }
      # Checks if the property value has a exception indicator
      # @param props 32 bit property value
      # @return true if property does not have a exception indicator, false
      # otherwise
      def is_not_exception_indicator(props)
        return ((props & UCharacterProperty::EXCEPTION_MASK)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Gets the property value at the index.
      # This is optimized.
      # Note this is alittle different from CharTrie the index m_trieData_
      # is never negative.
      # This is a duplicate of UCharacterProperty.getProperty. For optimization
      # purposes, this method calls the trie data directly instead of through
      # UCharacterProperty.getProperty.
      # @param ch code point whose property value is to be retrieved
      # @return property value of code point
      # @stable ICU 2.6
      def get_property(ch)
        if (ch < UTF16::LEAD_SURROGATE_MIN_VALUE || (ch > UTF16::LEAD_SURROGATE_MAX_VALUE && ch < UTF16::SUPPLEMENTARY_MIN_VALUE))
          # BMP codepoint
          begin
            # using try for < 0 ch is faster than using an if statement
            return PROPERTY_DATA_[PROPERTY_TRIE_DATA_[(PROPERTY_TRIE_INDEX_[ch >> 5] << 2) + (ch & 0x1f)]]
          rescue ArrayIndexOutOfBoundsException => e
            return PROPERTY_INITIAL_VALUE_
          end
        end
        if (ch <= UTF16::LEAD_SURROGATE_MAX_VALUE)
          # surrogate
          return PROPERTY_DATA_[PROPERTY_TRIE_DATA_[(PROPERTY_TRIE_INDEX_[(0x2800 >> 5) + (ch >> 5)] << 2) + (ch & 0x1f)]]
        end
        # for optimization
        if (ch <= UTF16::CODEPOINT_MAX_VALUE)
          # look at the construction of supplementary characters
          # trail forms the ends of it.
          return PROPERTY_DATA_[PROPERTY_.attr_m_trie_.get_surrogate_value(UTF16.get_lead_surrogate(ch), RJava.cast_to_char((ch & 0x3ff)))]
        end
        # return m_dataOffset_ if there is an error, in this case we return
        # the default value: m_initialValue_
        # we cannot assume that m_initialValue_ is at offset 0
        # this is for optimization.
        return PROPERTY_INITIAL_VALUE_
      end
    }
    
    private
    alias_method :initialize__ucharacter, :initialize
  end
  
end
