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
  module UCharacterPropertyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Text, :BreakIterator
      include_const ::Java::Util, :Locale
    }
  end
  
  # <p>Internal class used for Unicode character property database.</p>
  # <p>This classes store binary data read from uprops.icu.
  # It does not have the capability to parse the data into more high-level
  # information. It only returns bytes of information when required.</p>
  # <p>Due to the form most commonly used for retrieval, array of char is used
  # to store the binary data.</p>
  # <p>UCharacterPropertyDB also contains information on accessing indexes to
  # significant points in the binary data.</p>
  # <p>Responsibility for molding the binary data into more meaning form lies on
  # <a href=UCharacter.html>UCharacter</a>.</p>
  # @author Syn Wee Quek
  # @since release 2.1, february 1st 2002
  # @draft 2.1
  class UCharacterProperty 
    include_class_members UCharacterPropertyImports
    include Trie::DataManipulate
    
    # public data members -----------------------------------------------
    # 
    # Trie data
    attr_accessor :m_trie_
    alias_method :attr_m_trie_, :m_trie_
    undef_method :m_trie_
    alias_method :attr_m_trie_=, :m_trie_=
    undef_method :m_trie_=
    
    # Optimization
    # CharTrie index array
    attr_accessor :m_trie_index_
    alias_method :attr_m_trie_index_, :m_trie_index_
    undef_method :m_trie_index_
    alias_method :attr_m_trie_index_=, :m_trie_index_=
    undef_method :m_trie_index_=
    
    # Optimization
    # CharTrie data array
    attr_accessor :m_trie_data_
    alias_method :attr_m_trie_data_, :m_trie_data_
    undef_method :m_trie_data_
    alias_method :attr_m_trie_data_=, :m_trie_data_=
    undef_method :m_trie_data_=
    
    # Optimization
    # CharTrie data offset
    attr_accessor :m_trie_initial_value_
    alias_method :attr_m_trie_initial_value_, :m_trie_initial_value_
    undef_method :m_trie_initial_value_
    alias_method :attr_m_trie_initial_value_=, :m_trie_initial_value_=
    undef_method :m_trie_initial_value_=
    
    # Character property table
    attr_accessor :m_property_
    alias_method :attr_m_property_, :m_property_
    undef_method :m_property_
    alias_method :attr_m_property_=, :m_property_=
    undef_method :m_property_=
    
    # Unicode version
    attr_accessor :m_unicode_version_
    alias_method :attr_m_unicode_version_, :m_unicode_version_
    undef_method :m_unicode_version_
    alias_method :attr_m_unicode_version_=, :m_unicode_version_=
    undef_method :m_unicode_version_=
    
    class_module.module_eval {
      # Exception indicator for uppercase type
      const_set_lazy(:EXC_UPPERCASE_) { 0 }
      const_attr_reader  :EXC_UPPERCASE_
      
      # Exception indicator for lowercase type
      const_set_lazy(:EXC_LOWERCASE_) { 1 }
      const_attr_reader  :EXC_LOWERCASE_
      
      # Exception indicator for titlecase type
      const_set_lazy(:EXC_TITLECASE_) { 2 }
      const_attr_reader  :EXC_TITLECASE_
      
      # Exception indicator for digit type
      const_set_lazy(:EXC_UNUSED_) { 3 }
      const_attr_reader  :EXC_UNUSED_
      
      # Exception indicator for numeric type
      const_set_lazy(:EXC_NUMERIC_VALUE_) { 4 }
      const_attr_reader  :EXC_NUMERIC_VALUE_
      
      # Exception indicator for denominator type
      const_set_lazy(:EXC_DENOMINATOR_VALUE_) { 5 }
      const_attr_reader  :EXC_DENOMINATOR_VALUE_
      
      # Exception indicator for mirror type
      const_set_lazy(:EXC_MIRROR_MAPPING_) { 6 }
      const_attr_reader  :EXC_MIRROR_MAPPING_
      
      # Exception indicator for special casing type
      const_set_lazy(:EXC_SPECIAL_CASING_) { 7 }
      const_attr_reader  :EXC_SPECIAL_CASING_
      
      # Exception indicator for case folding type
      const_set_lazy(:EXC_CASE_FOLDING_) { 8 }
      const_attr_reader  :EXC_CASE_FOLDING_
      
      # EXC_COMBINING_CLASS_ is not found in ICU.
      # Used to retrieve the combining class of the character in the exception
      # value
      const_set_lazy(:EXC_COMBINING_CLASS_) { 9 }
      const_attr_reader  :EXC_COMBINING_CLASS_
      
      # Latin lowercase i
      const_set_lazy(:LATIN_SMALL_LETTER_I_) { 0x69 }
      const_attr_reader  :LATIN_SMALL_LETTER_I_
      
      # Character type mask
      const_set_lazy(:TYPE_MASK) { 0x1f }
      const_attr_reader  :TYPE_MASK
      
      # Exception test mask
      const_set_lazy(:EXCEPTION_MASK) { 0x20 }
      const_attr_reader  :EXCEPTION_MASK
    }
    
    typesig { [CharTrie::FriendAgent] }
    # public methods ----------------------------------------------------
    # 
    # Java friends implementation
    def set_index_data(friendagent)
      @m_trie_index_ = friendagent.get_private_index
      @m_trie_data_ = friendagent.get_private_data
      @m_trie_initial_value_ = friendagent.get_private_initial_value
    end
    
    typesig { [::Java::Int] }
    # Called by com.ibm.icu.util.Trie to extract from a lead surrogate's
    # data the index array offset of the indexes for that lead surrogate.
    # @param value data value for a surrogate from the trie, including the
    # folding offset
    # @return data offset or 0 if there is no data for the lead surrogate
    def get_folding_offset(value)
      if (!((value & SUPPLEMENTARY_FOLD_INDICATOR_MASK_)).equal?(0))
        return (value & SUPPLEMENTARY_FOLD_OFFSET_MASK_)
      else
        return 0
      end
    end
    
    typesig { [::Java::Int] }
    # Gets the property value at the index.
    # This is optimized.
    # Note this is alittle different from CharTrie the index m_trieData_
    # is never negative.
    # @param ch code point whose property value is to be retrieved
    # @return property value of code point
    def get_property(ch)
      if (ch < UTF16::LEAD_SURROGATE_MIN_VALUE || (ch > UTF16::LEAD_SURROGATE_MAX_VALUE && ch < UTF16::SUPPLEMENTARY_MIN_VALUE))
        # BMP codepoint
        # optimized
        begin
          return @m_property_[@m_trie_data_[(@m_trie_index_[ch >> Trie::INDEX_STAGE_1_SHIFT_] << Trie::INDEX_STAGE_2_SHIFT_) + (ch & Trie::INDEX_STAGE_3_MASK_)]]
        rescue ArrayIndexOutOfBoundsException => e
          return @m_property_[@m_trie_initial_value_]
        end
      end
      if (ch <= UTF16::LEAD_SURROGATE_MAX_VALUE)
        return @m_property_[@m_trie_data_[(@m_trie_index_[Trie::LEAD_INDEX_OFFSET_ + (ch >> Trie::INDEX_STAGE_1_SHIFT_)] << Trie::INDEX_STAGE_2_SHIFT_) + (ch & Trie::INDEX_STAGE_3_MASK_)]]
      end
      # for optimization
      if (ch <= UTF16::CODEPOINT_MAX_VALUE)
        # look at the construction of supplementary characters
        # trail forms the ends of it.
        return @m_property_[@m_trie_.get_surrogate_value(UTF16.get_lead_surrogate(ch), RJava.cast_to_char((ch & Trie::SURROGATE_MASK_)))]
      end
      # return m_dataOffset_ if there is an error, in this case we return
      # the default value: m_initialValue_
      # we cannot assume that m_initialValue_ is at offset 0
      # this is for optimization.
      return @m_property_[@m_trie_initial_value_]
      # return m_property_[m_trie_.getCodePointValue(ch)];
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Getting the signed numeric value of a character embedded in the property
      # argument
      # @param prop the character
      # @return signed numberic value
      def get_signed_value(prop)
        return (prop >> VALUE_SHIFT_)
      end
      
      typesig { [::Java::Int] }
      # Getting the exception index for argument property
      # @param prop character property
      # @return exception index
      def get_exception_index(prop)
        return (prop >> VALUE_SHIFT_) & UNSIGNED_VALUE_MASK_AFTER_SHIFT_
      end
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Determines if the exception value passed in has the kind of information
    # which the indicator wants, e.g if the exception value contains the digit
    # value of the character
    # @param index exception index
    # @param indicator type indicator
    # @return true if type value exist
    def has_exception_value(index, indicator)
      return !((@m_exception_[index] & (1 << indicator))).equal?(0)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Gets the exception value at the index, assuming that data type is
    # available. Result is undefined if data is not available. Use
    # hasExceptionValue() to determine data's availability.
    # @param index
    # @param etype exception data type
    # @return exception data type value at index
    def get_exception(index, etype)
      # contained in exception data
      if ((etype).equal?(EXC_COMBINING_CLASS_))
        return @m_exception_[index]
      end
      # contained in the exception digit address
      index = add_exception_offset(@m_exception_[index], etype, (index += 1))
      return @m_exception_[index]
    end
    
    typesig { [::Java::Int, ::Java::Int, StringBuffer] }
    # Gets the folded case value at the index
    # @param index of the case value to be retrieved
    # @param count number of characters to retrieve
    # @param str string buffer to which to append the result
    def get_fold_case(index, count, str)
      # first 2 chars are for the simple mappings
      index += 2
      while (count > 0)
        str.append(@m_case_[index])
        index += 1
        count -= 1
      end
    end
    
    typesig { [::Java::Int] }
    # Gets the unicode additional properties.
    # C version getUnicodeProperties.
    # @param codepoint codepoint whose additional properties is to be
    # retrieved
    # @return unicode properties
    def get_additional(codepoint)
      return @m_additional_vectors_[@m_additional_trie_.get_code_point_value(codepoint)]
    end
    
    typesig { [::Java::Int] }
    # <p>Get the "age" of the code point.</p>
    # <p>The "age" is the Unicode version when the code point was first
    # designated (as a non-character or for Private Use) or assigned a
    # character.</p>
    # <p>This can be useful to avoid emitting code points to receiving
    # processes that do not accept newer characters.</p>
    # <p>The data is from the UCD file DerivedAge.txt.</p>
    # <p>This API does not check the validity of the codepoint.</p>
    # @param codepoint The code point.
    # @return the Unicode version number
    # @draft ICU 2.1
    def get_age(codepoint)
      version = get_additional(codepoint) >> AGE_SHIFT_
      return VersionInfo.get_instance((version >> FIRST_NIBBLE_SHIFT_) & LAST_NIBBLE_MASK_, version & LAST_NIBBLE_MASK_, 0, 0)
    end
    
    class_module.module_eval {
      typesig { [::Java::Char, ::Java::Char] }
      # Forms a supplementary code point from the argument character<br>
      # Note this is for internal use hence no checks for the validity of the
      # surrogate characters are done
      # @param lead lead surrogate character
      # @param trail trailing surrogate character
      # @return code point of the supplementary character
      def get_raw_supplementary(lead, trail)
        return (lead << LEAD_SURROGATE_SHIFT_) + trail + SURROGATE_OFFSET_
      end
      
      typesig { [] }
      # Loads the property data and initialize the UCharacterProperty instance.
      # @throws RuntimeException when data is missing or data has been corrupted
      def get_instance
        if ((self.attr_instance_).nil?)
          begin
            self.attr_instance_ = UCharacterProperty.new
          rescue JavaException => e
            raise RuntimeException.new(e.get_message)
          end
        end
        return self.attr_instance_
      end
      
      typesig { [::Java::Int] }
      # Checks if the argument c is to be treated as a white space in ICU
      # rules. Usually ICU rule white spaces are ignored unless quoted.
      # @param c codepoint to check
      # @return true if c is a ICU white space
      def is_rule_white_space(c)
        # "white space" in the sense of ICU rule parsers
        # This is a FIXED LIST that is NOT DEPENDENT ON UNICODE PROPERTIES.
        # See UTR #31: http://www.unicode.org/reports/tr31/.
        # U+0009..U+000D, U+0020, U+0085, U+200E..U+200F, and U+2028..U+2029
        return (c >= 0x9 && c <= 0x2029 && (c <= 0xd || (c).equal?(0x20) || (c).equal?(0x85) || (c).equal?(0x200e) || (c).equal?(0x200f) || c >= 0x2028))
      end
    }
    
    # protected variables -----------------------------------------------
    # 
    # Case table
    attr_accessor :m_case_
    alias_method :attr_m_case_, :m_case_
    undef_method :m_case_
    alias_method :attr_m_case_=, :m_case_=
    undef_method :m_case_=
    
    # Exception property table
    attr_accessor :m_exception_
    alias_method :attr_m_exception_, :m_exception_
    undef_method :m_exception_
    alias_method :attr_m_exception_=, :m_exception_=
    undef_method :m_exception_=
    
    # Extra property trie
    attr_accessor :m_additional_trie_
    alias_method :attr_m_additional_trie_, :m_additional_trie_
    undef_method :m_additional_trie_
    alias_method :attr_m_additional_trie_=, :m_additional_trie_=
    undef_method :m_additional_trie_=
    
    # Extra property vectors, 1st column for age and second for binary
    # properties.
    attr_accessor :m_additional_vectors_
    alias_method :attr_m_additional_vectors_, :m_additional_vectors_
    undef_method :m_additional_vectors_
    alias_method :attr_m_additional_vectors_=, :m_additional_vectors_=
    undef_method :m_additional_vectors_=
    
    # Number of additional columns
    attr_accessor :m_additional_columns_count_
    alias_method :attr_m_additional_columns_count_, :m_additional_columns_count_
    undef_method :m_additional_columns_count_
    alias_method :attr_m_additional_columns_count_=, :m_additional_columns_count_=
    undef_method :m_additional_columns_count_=
    
    # Maximum values for block, bits used as in vector word
    # 0
    attr_accessor :m_max_block_script_value_
    alias_method :attr_m_max_block_script_value_, :m_max_block_script_value_
    undef_method :m_max_block_script_value_
    alias_method :attr_m_max_block_script_value_=, :m_max_block_script_value_=
    undef_method :m_max_block_script_value_=
    
    # Maximum values for script, bits used as in vector word
    # 0
    attr_accessor :m_max_jtgvalue_
    alias_method :attr_m_max_jtgvalue_, :m_max_jtgvalue_
    undef_method :m_max_jtgvalue_
    alias_method :attr_m_max_jtgvalue_=, :m_max_jtgvalue_=
    undef_method :m_max_jtgvalue_=
    
    class_module.module_eval {
      # private variables -------------------------------------------------
      # 
      # UnicodeData.txt property object
      
      def instance_
        defined?(@@instance_) ? @@instance_ : @@instance_= nil
      end
      alias_method :attr_instance_, :instance_
      
      def instance_=(value)
        @@instance_ = value
      end
      alias_method :attr_instance_=, :instance_=
      
      # Default name of the datafile
      const_set_lazy(:DATA_FILE_NAME_) { "/sun/text/resources/uprops.icu" }
      const_attr_reader  :DATA_FILE_NAME_
      
      # Default buffer size of datafile
      const_set_lazy(:DATA_BUFFER_SIZE_) { 25000 }
      const_attr_reader  :DATA_BUFFER_SIZE_
      
      # This, from what i infer is the max size of the indicators used for the
      # exception values.
      # Number of bits in an 8-bit integer value
      const_set_lazy(:EXC_GROUP_) { 8 }
      const_attr_reader  :EXC_GROUP_
      
      # Mask to get the group
      const_set_lazy(:EXC_GROUP_MASK_) { 255 }
      const_attr_reader  :EXC_GROUP_MASK_
      
      # Mask to get the digit value in the exception result
      const_set_lazy(:EXC_DIGIT_MASK_) { 0xffff }
      const_attr_reader  :EXC_DIGIT_MASK_
      
      # Offset table for data in exception block.<br>
      # Table formed by the number of bits used for the index, e.g. 0 = 0 bits,
      # 1 = 1 bits.
      const_set_lazy(:FLAGS_OFFSET_) { Array.typed(::Java::Byte).new([0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8]) }
      const_attr_reader  :FLAGS_OFFSET_
      
      # Numeric value shift
      const_set_lazy(:VALUE_SHIFT_) { 20 }
      const_attr_reader  :VALUE_SHIFT_
      
      # Mask to be applied after shifting to obtain an unsigned numeric value
      const_set_lazy(:UNSIGNED_VALUE_MASK_AFTER_SHIFT_) { 0x7ff }
      const_attr_reader  :UNSIGNED_VALUE_MASK_AFTER_SHIFT_
      
      const_set_lazy(:NUMERIC_TYPE_SHIFT) { 12 }
      const_attr_reader  :NUMERIC_TYPE_SHIFT
      
      # Folding indicator mask
      const_set_lazy(:SUPPLEMENTARY_FOLD_INDICATOR_MASK_) { 0x8000 }
      const_attr_reader  :SUPPLEMENTARY_FOLD_INDICATOR_MASK_
      
      # Folding offset mask
      const_set_lazy(:SUPPLEMENTARY_FOLD_OFFSET_MASK_) { 0x7fff }
      const_attr_reader  :SUPPLEMENTARY_FOLD_OFFSET_MASK_
      
      # Shift value for lead surrogate to form a supplementary character.
      const_set_lazy(:LEAD_SURROGATE_SHIFT_) { 10 }
      const_attr_reader  :LEAD_SURROGATE_SHIFT_
      
      # Offset to add to combined surrogate pair to avoid msking.
      const_set_lazy(:SURROGATE_OFFSET_) { UTF16::SUPPLEMENTARY_MIN_VALUE - (UTF16::SURROGATE_MIN_VALUE << LEAD_SURROGATE_SHIFT_) - UTF16::TRAIL_SURROGATE_MIN_VALUE }
      const_attr_reader  :SURROGATE_OFFSET_
      
      # To get the last character out from a data type
      const_set_lazy(:LAST_CHAR_MASK_) { 0xffff }
      const_attr_reader  :LAST_CHAR_MASK_
      
      # First nibble shift
      const_set_lazy(:FIRST_NIBBLE_SHIFT_) { 0x4 }
      const_attr_reader  :FIRST_NIBBLE_SHIFT_
      
      # Second nibble mask
      const_set_lazy(:LAST_NIBBLE_MASK_) { 0xf }
      const_attr_reader  :LAST_NIBBLE_MASK_
      
      # Age value shift
      const_set_lazy(:AGE_SHIFT_) { 24 }
      const_attr_reader  :AGE_SHIFT_
    }
    
    typesig { [] }
    # private constructors --------------------------------------------------
    # 
    # Constructor
    # @exception thrown when data reading fails or data corrupted
    def initialize
      @m_trie_ = nil
      @m_trie_index_ = nil
      @m_trie_data_ = nil
      @m_trie_initial_value_ = 0
      @m_property_ = nil
      @m_unicode_version_ = nil
      @m_case_ = nil
      @m_exception_ = nil
      @m_additional_trie_ = nil
      @m_additional_vectors_ = nil
      @m_additional_columns_count_ = 0
      @m_max_block_script_value_ = 0
      @m_max_jtgvalue_ = 0
      # jar access
      is = ICUData.get_required_stream(DATA_FILE_NAME_)
      b = BufferedInputStream.new(is, DATA_BUFFER_SIZE_)
      reader = UCharacterPropertyReader.new(b)
      reader.read(self)
      b.close
      @m_trie_.put_index_data(self)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Is followed by {case-ignorable}* cased  ?
    # 
    # Getting the correct address for data in the exception value
    # @param evalue exception value
    # @param indicator type of data to retrieve
    # @param address current address to move from
    # @return the correct address
    def add_exception_offset(evalue, indicator, address)
      result = address
      if (indicator >= EXC_GROUP_)
        result += FLAGS_OFFSET_[evalue & EXC_GROUP_MASK_]
        evalue >>= EXC_GROUP_
        indicator -= EXC_GROUP_
      end
      mask = (1 << indicator) - 1
      result += FLAGS_OFFSET_[evalue & mask]
      return result
    end
    
    class_module.module_eval {
      const_set_lazy(:TAB) { 0x9 }
      const_attr_reader  :TAB
      
      const_set_lazy(:LF) { 0xa }
      const_attr_reader  :LF
      
      const_set_lazy(:FF) { 0xc }
      const_attr_reader  :FF
      
      const_set_lazy(:CR) { 0xd }
      const_attr_reader  :CR
      
      const_set_lazy(:U_A) { 0x41 }
      const_attr_reader  :U_A
      
      const_set_lazy(:U_Z) { 0x5a }
      const_attr_reader  :U_Z
      
      const_set_lazy(:U_a) { 0x61 }
      const_attr_reader  :U_a
      
      const_set_lazy(:U_z) { 0x7a }
      const_attr_reader  :U_z
      
      const_set_lazy(:DEL) { 0x7f }
      const_attr_reader  :DEL
      
      const_set_lazy(:NL) { 0x85 }
      const_attr_reader  :NL
      
      const_set_lazy(:NBSP) { 0xa0 }
      const_attr_reader  :NBSP
      
      const_set_lazy(:CGJ) { 0x34f }
      const_attr_reader  :CGJ
      
      const_set_lazy(:FIGURESP) { 0x2007 }
      const_attr_reader  :FIGURESP
      
      const_set_lazy(:HAIRSP) { 0x200a }
      const_attr_reader  :HAIRSP
      
      const_set_lazy(:ZWNJ) { 0x200c }
      const_attr_reader  :ZWNJ
      
      const_set_lazy(:ZWJ) { 0x200d }
      const_attr_reader  :ZWJ
      
      const_set_lazy(:RLM) { 0x200f }
      const_attr_reader  :RLM
      
      const_set_lazy(:NNBSP) { 0x202f }
      const_attr_reader  :NNBSP
      
      const_set_lazy(:WJ) { 0x2060 }
      const_attr_reader  :WJ
      
      const_set_lazy(:INHSWAP) { 0x206a }
      const_attr_reader  :INHSWAP
      
      const_set_lazy(:NOMDIG) { 0x206f }
      const_attr_reader  :NOMDIG
      
      const_set_lazy(:ZWNBSP) { 0xfeff }
      const_attr_reader  :ZWNBSP
    }
    
    typesig { [UnicodeSet] }
    def add_property_starts(set)
      c = 0
      # add the start code point of each same-value range of each trie
      # utrie_enum(&normTrie, NULL, _enumPropertyStartsRange, set);
      props_iter = TrieIterator.new(@m_trie_)
      props_result = RangeValueIterator::Element.new
      while (props_iter.next_(props_result))
        set.add(props_result.attr_start)
      end
      # utrie_enum(&propsVectorsTrie, NULL, _enumPropertyStartsRange, set);
      props_vectors_iter = TrieIterator.new(@m_additional_trie_)
      props_vectors_result = RangeValueIterator::Element.new
      while (props_vectors_iter.next_(props_vectors_result))
        set.add(props_vectors_result.attr_start)
      end
      # add code points with hardcoded properties, plus the ones following them
      # add for IS_THAT_CONTROL_SPACE()
      set.add(TAB)
      # range TAB..CR
      set.add(CR + 1)
      set.add(0x1c)
      set.add(0x1f + 1)
      set.add(NL)
      set.add(NL + 1)
      # add for u_isIDIgnorable() what was not added above
      set.add(DEL)
      # range DEL..NBSP-1, NBSP added below
      set.add(HAIRSP)
      set.add(RLM + 1)
      set.add(INHSWAP)
      set.add(NOMDIG + 1)
      set.add(ZWNBSP)
      set.add(ZWNBSP + 1)
      # add no-break spaces for u_isWhitespace() what was not added above
      set.add(NBSP)
      set.add(NBSP + 1)
      set.add(FIGURESP)
      set.add(FIGURESP + 1)
      set.add(NNBSP)
      set.add(NNBSP + 1)
      # add for u_charDigitValue()
      set.add(0x3007)
      set.add(0x3008)
      set.add(0x4e00)
      set.add(0x4e01)
      set.add(0x4e8c)
      set.add(0x4e8d)
      set.add(0x4e09)
      set.add(0x4e0a)
      set.add(0x56db)
      set.add(0x56dc)
      set.add(0x4e94)
      set.add(0x4e95)
      set.add(0x516d)
      set.add(0x516e)
      set.add(0x4e03)
      set.add(0x4e04)
      set.add(0x516b)
      set.add(0x516c)
      set.add(0x4e5d)
      set.add(0x4e5e)
      # add for u_digit()
      set.add(U_a)
      set.add(U_z + 1)
      set.add(U_A)
      set.add(U_Z + 1)
      # add for UCHAR_DEFAULT_IGNORABLE_CODE_POINT what was not added above
      set.add(WJ)
      # range WJ..NOMDIG
      set.add(0xfff0)
      set.add(0xfffb + 1)
      set.add(0xe0000)
      set.add(0xe0fff + 1)
      # add for UCHAR_GRAPHEME_BASE and others
      set.add(CGJ)
      set.add(CGJ + 1)
      # add for UCHAR_JOINING_TYPE
      set.add(ZWNJ)
      # range ZWNJ..ZWJ
      set.add(ZWJ + 1)
      # add Jamo type boundaries for UCHAR_HANGUL_SYLLABLE_TYPE
      set.add(0x1100)
      value = UCharacter::HangulSyllableType::LEADING_JAMO
      value2 = 0
      c = 0x115a
      while c <= 0x115f
        value2 = UCharacter.get_int_property_value(c, UProperty::HANGUL_SYLLABLE_TYPE)
        if (!(value).equal?(value2))
          value = value2
          set.add(c)
        end
        (c += 1)
      end
      set.add(0x1160)
      value = UCharacter::HangulSyllableType::VOWEL_JAMO
      c = 0x11a3
      while c <= 0x11a7
        value2 = UCharacter.get_int_property_value(c, UProperty::HANGUL_SYLLABLE_TYPE)
        if (!(value).equal?(value2))
          value = value2
          set.add(c)
        end
        (c += 1)
      end
      set.add(0x11a8)
      value = UCharacter::HangulSyllableType::TRAILING_JAMO
      c = 0x11fa
      while c <= 0x11ff
        value2 = UCharacter.get_int_property_value(c, UProperty::HANGUL_SYLLABLE_TYPE)
        if (!(value).equal?(value2))
          value = value2
          set.add(c)
        end
        (c += 1)
      end
      # Omit code points for u_charCellWidth() because
      # - it is deprecated and not a real Unicode property
      # - they are probably already set from the trie enumeration
      # 
      # 
      # Omit code points with hardcoded specialcasing properties
      # because we do not build property UnicodeSets for them right now.
      return set # for chaining
    end
    
    typesig { [] }
    # ----------------------------------------------------------------
    # Inclusions list
    # ----------------------------------------------------------------
    # 
    # Return a set of characters for property enumeration.
    # The set implicitly contains 0x110000 as well, which is one more than the highest
    # Unicode code point.
    # 
    # This set is used as an ordered list - its code points are ordered, and
    # consecutive code points (in Unicode code point order) in the set define a range.
    # For each two consecutive characters (start, limit) in the set,
    # all of the UCD/normalization and related properties for
    # all code points start..limit-1 are all the same,
    # except for character names and ISO comments.
    # 
    # All Unicode code points U+0000..U+10ffff are covered by these ranges.
    # The ranges define a partition of the Unicode code space.
    # ICU uses the inclusions set to enumerate properties for generating
    # UnicodeSets containing all code points that have a certain property value.
    # 
    # The Inclusion List is generated from the UCD. It is generated
    # by enumerating the data tries, and code points for hardcoded properties
    # are added as well.
    # 
    # --------------------------------------------------------------------------
    # 
    # The following are ideas for getting properties-unique code point ranges,
    # with possible optimizations beyond the current implementation.
    # These optimizations would require more code and be more fragile.
    # The current implementation generates one single list (set) for all properties.
    # 
    # To enumerate properties efficiently, one needs to know ranges of
    # repetitive values, so that the value of only each start code point
    # can be applied to the whole range.
    # This information is in principle available in the uprops.icu/unorm.icu data.
    # 
    # There are two obstacles:
    # 
    # 1. Some properties are computed from multiple data structures,
    # making it necessary to get repetitive ranges by intersecting
    # ranges from multiple tries.
    # 
    # 2. It is not economical to write code for getting repetitive ranges
    # that are precise for each of some 50 properties.
    # 
    # Compromise ideas:
    # 
    # - Get ranges per trie, not per individual property.
    # Each range contains the same values for a whole group of properties.
    # This would generate currently five range sets, two for uprops.icu tries
    # and three for unorm.icu tries.
    # 
    # - Combine sets of ranges for multiple tries to get sufficient sets
    # for properties, e.g., the uprops.icu main and auxiliary tries
    # for all non-normalization properties.
    # 
    # Ideas for representing ranges and combining them:
    # 
    # - A UnicodeSet could hold just the start code points of ranges.
    # Multiple sets are easily combined by or-ing them together.
    # 
    # - Alternatively, a UnicodeSet could hold each even-numbered range.
    # All ranges could be enumerated by using each start code point
    # (for the even-numbered ranges) as well as each limit (end+1) code point
    # (for the odd-numbered ranges).
    # It should be possible to combine two such sets by xor-ing them,
    # but no more than two.
    # 
    # The second way to represent ranges may(?!) yield smaller UnicodeSet arrays,
    # but the first one is certainly simpler and applicable for combining more than
    # two range sets.
    # 
    # It is possible to combine all range sets for all uprops/unorm tries into one
    # set that can be used for all properties.
    # As an optimization, there could be less-combined range sets for certain
    # groups of properties.
    # The relationship of which less-combined range set to use for which property
    # depends on the implementation of the properties and must be hardcoded
    # - somewhat error-prone and higher maintenance but can be tested easily
    # by building property sets "the simple way" in test code.
    # 
    # ---
    # 
    # Do not use a UnicodeSet pattern because that causes infinite recursion;
    # UnicodeSet depends on the inclusions set.
    def get_inclusions
      set = UnicodeSet.new
      NormalizerImpl.add_property_starts(set)
      add_property_starts(set)
      return set
    end
    
    private
    alias_method :initialize__ucharacter_property, :initialize
  end
  
end
