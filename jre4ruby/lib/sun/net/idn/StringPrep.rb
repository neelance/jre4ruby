require "rjava"

# 
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
# 
# Copyright (C) 2003-2004, International Business Machines Corporation and         *
# others. All Rights Reserved.                                                *
# 
# 
# 
# CHANGELOG
# 2005-05-19 Edward Wang
# - copy this file from icu4jsrc_3_2/src/com/ibm/icu/text/StringPrep.java
# - move from package com.ibm.icu.text to package sun.net.idn
# - use ParseException instead of StringPrepParseException
# - change 'Normalizer.getUnicodeVersion()' to 'NormalizerImpl.getUnicodeVersion()'
# - remove all @deprecated tag to make compiler happy
# 2007-08-14 Martin Buchholz
# - remove redundant casts
module Sun::Net::Idn
  module StringPrepImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Idn
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Text, :ParseException
      include_const ::Sun::Text, :Normalizer
      include_const ::Sun::Text::Normalizer, :CharTrie
      include_const ::Sun::Text::Normalizer, :Trie
      include_const ::Sun::Text::Normalizer, :NormalizerImpl
      include_const ::Sun::Text::Normalizer, :VersionInfo
      include_const ::Sun::Text::Normalizer, :UCharacter
      include_const ::Sun::Text::Normalizer, :UCharacterIterator
      include_const ::Sun::Text::Normalizer, :UTF16
      include_const ::Sun::Net::Idn, :UCharacterDirection
      include_const ::Sun::Net::Idn, :StringPrepDataReader
    }
  end
  
  # 
  # StringPrep API implements the StingPrep framework as described by
  # <a href="http://www.ietf.org/rfc/rfc3454.txt">RFC 3454</a>.
  # StringPrep prepares Unicode strings for use in network protocols.
  # Profiles of StingPrep are set of rules and data according to which the
  # Unicode Strings are prepared. Each profiles contains tables which describe
  # how a code point should be treated. The tables are broadly classied into
  # <ul>
  # <li> Unassigned Table: Contains code points that are unassigned
  # in the Unicode Version supported by StringPrep. Currently
  # RFC 3454 supports Unicode 3.2. </li>
  # <li> Prohibited Table: Contains code points that are prohibted from
  # the output of the StringPrep processing function. </li>
  # <li> Mapping Table: Contains code ponts that are deleted from the output or case mapped. </li>
  # </ul>
  # 
  # The procedure for preparing Unicode strings:
  # <ol>
  # <li> Map: For each character in the input, check if it has a mapping
  # and, if so, replace it with its mapping. </li>
  # <li> Normalize: Possibly normalize the result of step 1 using Unicode
  # normalization. </li>
  # <li> Prohibit: Check for any characters that are not allowed in the
  # output.  If any are found, return an error.</li>
  # <li> Check bidi: Possibly check for right-to-left characters, and if
  # any are found, make sure that the whole string satisfies the
  # requirements for bidirectional strings.  If the string does not
  # satisfy the requirements for bidirectional strings, return an
  # error.  </li>
  # </ol>
  # @author Ram Viswanadha
  # @draft ICU 2.8
  class StringPrep 
    include_class_members StringPrepImports
    
    class_module.module_eval {
      # 
      # Option to prohibit processing of unassigned code points in the input
      # 
      # @see   #prepare
      # @draft ICU 2.8
      const_set_lazy(:DEFAULT) { 0x0 }
      const_attr_reader  :DEFAULT
      
      # 
      # Option to allow processing of unassigned code points in the input
      # 
      # @see   #prepare
      # @draft ICU 2.8
      const_set_lazy(:ALLOW_UNASSIGNED) { 0x1 }
      const_attr_reader  :ALLOW_UNASSIGNED
      
      const_set_lazy(:UNASSIGNED) { 0x0 }
      const_attr_reader  :UNASSIGNED
      
      const_set_lazy(:MAP) { 0x1 }
      const_attr_reader  :MAP
      
      const_set_lazy(:PROHIBITED) { 0x2 }
      const_attr_reader  :PROHIBITED
      
      const_set_lazy(:DELETE) { 0x3 }
      const_attr_reader  :DELETE
      
      const_set_lazy(:TYPE_LIMIT) { 0x4 }
      const_attr_reader  :TYPE_LIMIT
      
      const_set_lazy(:NORMALIZATION_ON) { 0x1 }
      const_attr_reader  :NORMALIZATION_ON
      
      const_set_lazy(:CHECK_BIDI_ON) { 0x2 }
      const_attr_reader  :CHECK_BIDI_ON
      
      const_set_lazy(:TYPE_THRESHOLD) { 0xfff0 }
      const_attr_reader  :TYPE_THRESHOLD
      
      const_set_lazy(:MAX_INDEX_VALUE) { 0x3fbf }
      const_attr_reader  :MAX_INDEX_VALUE
      
      # 16139
      const_set_lazy(:MAX_INDEX_TOP_LENGTH) { 0x3 }
      const_attr_reader  :MAX_INDEX_TOP_LENGTH
      
      # indexes[] value names
      const_set_lazy(:INDEX_TRIE_SIZE) { 0 }
      const_attr_reader  :INDEX_TRIE_SIZE
      
      # number of bytes in normalization trie
      const_set_lazy(:INDEX_MAPPING_DATA_SIZE) { 1 }
      const_attr_reader  :INDEX_MAPPING_DATA_SIZE
      
      # The array that contains the mapping
      const_set_lazy(:NORM_CORRECTNS_LAST_UNI_VERSION) { 2 }
      const_attr_reader  :NORM_CORRECTNS_LAST_UNI_VERSION
      
      # The index of Unicode version of last entry in NormalizationCorrections.txt
      const_set_lazy(:ONE_UCHAR_MAPPING_INDEX_START) { 3 }
      const_attr_reader  :ONE_UCHAR_MAPPING_INDEX_START
      
      # The starting index of 1 UChar mapping index in the mapping data array
      const_set_lazy(:TWO_UCHARS_MAPPING_INDEX_START) { 4 }
      const_attr_reader  :TWO_UCHARS_MAPPING_INDEX_START
      
      # The starting index of 2 UChars mapping index in the mapping data array
      const_set_lazy(:THREE_UCHARS_MAPPING_INDEX_START) { 5 }
      const_attr_reader  :THREE_UCHARS_MAPPING_INDEX_START
      
      const_set_lazy(:FOUR_UCHARS_MAPPING_INDEX_START) { 6 }
      const_attr_reader  :FOUR_UCHARS_MAPPING_INDEX_START
      
      const_set_lazy(:OPTIONS) { 7 }
      const_attr_reader  :OPTIONS
      
      # Bit set of options to turn on in the profile
      const_set_lazy(:INDEX_TOP) { 16 }
      const_attr_reader  :INDEX_TOP
      
      # changing this requires a new formatVersion
      # 
      # Default buffer size of datafile
      const_set_lazy(:DATA_BUFFER_SIZE) { 25000 }
      const_attr_reader  :DATA_BUFFER_SIZE
      
      # Wrappers for Trie implementations
      const_set_lazy(:StringPrepTrieImpl) { Class.new do
        include_class_members StringPrep
        include Trie::DataManipulate
        
        attr_accessor :sprep_trie
        alias_method :attr_sprep_trie, :sprep_trie
        undef_method :sprep_trie
        alias_method :attr_sprep_trie=, :sprep_trie=
        undef_method :sprep_trie=
        
        typesig { [::Java::Int] }
        # 
        # Called by com.ibm.icu.util.Trie to extract from a lead surrogate's
        # data the index array offset of the indexes for that lead surrogate.
        # @param property data value for a surrogate from the trie, including
        # the folding offset
        # @return data offset or 0 if there is no data for the lead surrogate
        def get_folding_offset(value)
          return value
        end
        
        typesig { [] }
        def initialize
          @sprep_trie = nil
        end
        
        private
        alias_method :initialize__string_prep_trie_impl, :initialize
      end }
    }
    
    # CharTrie implmentation for reading the trie data
    attr_accessor :sprep_trie_impl
    alias_method :attr_sprep_trie_impl, :sprep_trie_impl
    undef_method :sprep_trie_impl
    alias_method :attr_sprep_trie_impl=, :sprep_trie_impl=
    undef_method :sprep_trie_impl=
    
    # Indexes read from the data file
    attr_accessor :indexes
    alias_method :attr_indexes, :indexes
    undef_method :indexes
    alias_method :attr_indexes=, :indexes=
    undef_method :indexes=
    
    # mapping data read from the data file
    attr_accessor :mapping_data
    alias_method :attr_mapping_data, :mapping_data
    undef_method :mapping_data
    alias_method :attr_mapping_data=, :mapping_data=
    undef_method :mapping_data=
    
    # format version of the data file
    attr_accessor :format_version
    alias_method :attr_format_version, :format_version
    undef_method :format_version
    alias_method :attr_format_version=, :format_version=
    undef_method :format_version=
    
    # the version of Unicode supported by the data file
    attr_accessor :sprep_uni_ver
    alias_method :attr_sprep_uni_ver, :sprep_uni_ver
    undef_method :sprep_uni_ver
    alias_method :attr_sprep_uni_ver=, :sprep_uni_ver=
    undef_method :sprep_uni_ver=
    
    # the Unicode version of last entry in the
    # NormalizationCorrections.txt file if normalization
    # is turned on
    attr_accessor :norm_corr_ver
    alias_method :attr_norm_corr_ver, :norm_corr_ver
    undef_method :norm_corr_ver
    alias_method :attr_norm_corr_ver=, :norm_corr_ver=
    undef_method :norm_corr_ver=
    
    # Option to turn on Normalization
    attr_accessor :do_nfkc
    alias_method :attr_do_nfkc, :do_nfkc
    undef_method :do_nfkc
    alias_method :attr_do_nfkc=, :do_nfkc=
    undef_method :do_nfkc=
    
    # Option to turn on checking for BiDi rules
    attr_accessor :check_bi_di
    alias_method :attr_check_bi_di, :check_bi_di
    undef_method :check_bi_di
    alias_method :attr_check_bi_di=, :check_bi_di=
    undef_method :check_bi_di=
    
    typesig { [::Java::Int] }
    def get_code_point_value(ch)
      return @sprep_trie_impl.attr_sprep_trie.get_code_point_value(ch)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def get_version_info(comp)
        micro = comp & 0xff
        milli = (comp >> 8) & 0xff
        minor = (comp >> 16) & 0xff
        major = (comp >> 24) & 0xff
        return VersionInfo.get_instance(major, minor, milli, micro)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def get_version_info(version)
        if (!(version.attr_length).equal?(4))
          return nil
        end
        return VersionInfo.get_instance(RJava.cast_to_int(version[0]), RJava.cast_to_int(version[1]), RJava.cast_to_int(version[2]), RJava.cast_to_int(version[3]))
      end
    }
    
    typesig { [InputStream] }
    # 
    # Creates an StringPrep object after reading the input stream.
    # The object does not hold a reference to the input steam, so the stream can be
    # closed after the method returns.
    # 
    # @param inputStream The stream for reading the StringPrep profile binarySun
    # @throws IOException
    # @draft ICU 2.8
    def initialize(input_stream)
      @sprep_trie_impl = nil
      @indexes = nil
      @mapping_data = nil
      @format_version = nil
      @sprep_uni_ver = nil
      @norm_corr_ver = nil
      @do_nfkc = false
      @check_bi_di = false
      b = BufferedInputStream.new(input_stream, DATA_BUFFER_SIZE)
      reader = StringPrepDataReader.new(b)
      # read the indexes
      @indexes = reader.read_indexes(INDEX_TOP)
      sprep_bytes = Array.typed(::Java::Byte).new(@indexes[INDEX_TRIE_SIZE]) { 0 }
      # indexes[INDEX_MAPPING_DATA_SIZE] store the size of mappingData in bytes
      @mapping_data = CharArray.new(@indexes[INDEX_MAPPING_DATA_SIZE] / 2)
      # load the rest of the data data and initialize the data members
      reader.read(sprep_bytes, @mapping_data)
      @sprep_trie_impl = StringPrepTrieImpl.new
      @sprep_trie_impl.attr_sprep_trie = CharTrie.new(ByteArrayInputStream.new(sprep_bytes), @sprep_trie_impl)
      # get the data format version
      @format_version = reader.get_data_format_version
      # get the options
      @do_nfkc = ((@indexes[OPTIONS] & NORMALIZATION_ON) > 0)
      @check_bi_di = ((@indexes[OPTIONS] & CHECK_BIDI_ON) > 0)
      @sprep_uni_ver = get_version_info(reader.get_unicode_version)
      @norm_corr_ver = get_version_info(@indexes[NORM_CORRECTNS_LAST_UNI_VERSION])
      norm_uni_ver = NormalizerImpl.get_unicode_version
      # the Unicode version of SPREP file must be less than the Unicode Vesion of the normalization data
      # the Unicode version of the NormalizationCorrections.txt file should be less than the Unicode Vesion of the normalization data
      # normalization turned on
      if ((norm_uni_ver <=> @sprep_uni_ver) < 0 && (norm_uni_ver <=> @norm_corr_ver) < 0 && ((@indexes[OPTIONS] & NORMALIZATION_ON) > 0))
        raise IOException.new("Normalization Correction version not supported")
      end
      b.close
    end
    
    class_module.module_eval {
      const_set_lazy(:Values) { Class.new do
        include_class_members StringPrep
        
        attr_accessor :is_index
        alias_method :attr_is_index, :is_index
        undef_method :is_index
        alias_method :attr_is_index=, :is_index=
        undef_method :is_index=
        
        attr_accessor :value
        alias_method :attr_value, :value
        undef_method :value
        alias_method :attr_value=, :value=
        undef_method :value=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        typesig { [] }
        def reset
          @is_index = false
          @value = 0
          @type = -1
        end
        
        typesig { [] }
        def initialize
          @is_index = false
          @value = 0
          @type = 0
        end
        
        private
        alias_method :initialize__values, :initialize
      end }
      
      typesig { [::Java::Char, Values] }
      def get_values(trie_word, values)
        values.reset
        if ((trie_word).equal?(0))
          # 
          # Initial value stored in the mapping table
          # just return TYPE_LIMIT .. so that
          # the source codepoint is copied to the destination
          values.attr_type = TYPE_LIMIT
        else
          if (trie_word >= TYPE_THRESHOLD)
            values.attr_type = (trie_word - TYPE_THRESHOLD)
          else
            # get the type
            values.attr_type = MAP
            # ascertain if the value is index or delta
            if ((trie_word & 0x2) > 0)
              values.attr_is_index = true
              values.attr_value = trie_word >> 2 # mask off the lower 2 bits and shift
            else
              values.attr_is_index = false
              values.attr_value = (trie_word << 16) >> 16
              values.attr_value = (values.attr_value >> 2)
            end
            if (((trie_word >> 2)).equal?(MAX_INDEX_VALUE))
              values.attr_type = DELETE
              values.attr_is_index = false
              values.attr_value = 0
            end
          end
        end
      end
    }
    
    typesig { [UCharacterIterator, ::Java::Int] }
    def map(iter, options)
      val = Values.new
      result = 0
      ch = UCharacterIterator::DONE
      dest = StringBuffer.new
      allow_unassigned = ((options & ALLOW_UNASSIGNED) > 0)
      while (!((ch = iter.next_code_point)).equal?(UCharacterIterator::DONE))
        result = get_code_point_value(ch)
        get_values(result, val)
        # check if the source codepoint is unassigned
        if ((val.attr_type).equal?(UNASSIGNED) && (allow_unassigned).equal?(false))
          raise ParseException.new("An unassigned code point was found in the input " + (iter.get_text).to_s, iter.get_index)
        else
          if (((val.attr_type).equal?(MAP)))
            index = 0
            length = 0
            if (val.attr_is_index)
              index = val.attr_value
              if (index >= @indexes[ONE_UCHAR_MAPPING_INDEX_START] && index < @indexes[TWO_UCHARS_MAPPING_INDEX_START])
                length = 1
              else
                if (index >= @indexes[TWO_UCHARS_MAPPING_INDEX_START] && index < @indexes[THREE_UCHARS_MAPPING_INDEX_START])
                  length = 2
                else
                  if (index >= @indexes[THREE_UCHARS_MAPPING_INDEX_START] && index < @indexes[FOUR_UCHARS_MAPPING_INDEX_START])
                    length = 3
                  else
                    length = @mapping_data[((index += 1) - 1)]
                  end
                end
              end
              # copy mapping to destination
              dest.append(@mapping_data, index, length)
              next
            else
              ch -= val.attr_value
            end
          else
            if ((val.attr_type).equal?(DELETE))
              # just consume the codepoint and contine
              next
            end
          end
        end
        # copy the source into destination
        UTF16.append(dest, ch)
      end
      return dest
    end
    
    typesig { [StringBuffer] }
    def normalize(src)
      # 
      # Option UNORM_BEFORE_PRI_29:
      # 
      # IDNA as interpreted by IETF members (see unicode mailing list 2004H1)
      # requires strict adherence to Unicode 3.2 normalization,
      # including buggy composition from before fixing Public Review Issue #29.
      # Note that this results in some valid but nonsensical text to be
      # either corrupted or rejected, depending on the text.
      # See http://www.unicode.org/review/resolved-pri.html#pri29
      # See unorm.cpp and cnormtst.c
      return StringBuffer.new(Normalizer.normalize(src.to_s, Java::Text::Normalizer::Form::NFKC, Normalizer::UNICODE_3_2 | NormalizerImpl::BEFORE_PRI_29))
    end
    
    typesig { [UCharacterIterator, ::Java::Int] }
    # 
    # boolean isLabelSeparator(int ch){
    # int result = getCodePointValue(ch);
    # if( (result & 0x07)  == LABEL_SEPARATOR){
    # return true;
    # }
    # return false;
    # }
    # 
    # 
    # 1) Map -- For each character in the input, check if it has a mapping
    # and, if so, replace it with its mapping.
    # 
    # 2) Normalize -- Possibly normalize the result of step 1 using Unicode
    # normalization.
    # 
    # 3) Prohibit -- Check for any characters that are not allowed in the
    # output.  If any are found, return an error.
    # 
    # 4) Check bidi -- Possibly check for right-to-left characters, and if
    # any are found, make sure that the whole string satisfies the
    # requirements for bidirectional strings.  If the string does not
    # satisfy the requirements for bidirectional strings, return an
    # error.
    # [Unicode3.2] defines several bidirectional categories; each character
    # has one bidirectional category assigned to it.  For the purposes of
    # the requirements below, an "RandALCat character" is a character that
    # has Unicode bidirectional categories "R" or "AL"; an "LCat character"
    # is a character that has Unicode bidirectional category "L".  Note
    # 
    # 
    # that there are many characters which fall in neither of the above
    # definitions; Latin digits (<U+0030> through <U+0039>) are examples of
    # this because they have bidirectional category "EN".
    # 
    # In any profile that specifies bidirectional character handling, all
    # three of the following requirements MUST be met:
    # 
    # 1) The characters in section 5.8 MUST be prohibited.
    # 
    # 2) If a string contains any RandALCat character, the string MUST NOT
    # contain any LCat character.
    # 
    # 3) If a string contains any RandALCat character, a RandALCat
    # character MUST be the first character of the string, and a
    # RandALCat character MUST be the last character of the string.
    # 
    # 
    # Prepare the input buffer for use in applications with the given profile. This operation maps, normalizes(NFKC),
    # checks for prohited and BiDi characters in the order defined by RFC 3454
    # depending on the options specified in the profile.
    # 
    # @param src           A UCharacterIterator object containing the source string
    # @param options       A bit set of options:
    # 
    # - StringPrep.NONE               Prohibit processing of unassigned code points in the input
    # 
    # - StringPrep.ALLOW_UNASSIGNED   Treat the unassigned code points are in the input
    # as normal Unicode code points.
    # 
    # @return StringBuffer A StringBuffer containing the output
    # @throws ParseException
    # @draft ICU 2.8
    def prepare(src, options)
      # map
      map_out = map(src, options)
      norm_out = map_out # initialize
      if (@do_nfkc)
        # normalize
        norm_out = normalize(map_out)
      end
      ch = 0
      result = 0
      iter = UCharacterIterator.get_instance(norm_out)
      val = Values.new
      direction = UCharacterDirection::CHAR_DIRECTION_COUNT
      first_char_dir = UCharacterDirection::CHAR_DIRECTION_COUNT
      rtl_pos = -1
      ltr_pos = -1
      right_to_left = false
      left_to_right = false
      while (!((ch = iter.next_code_point)).equal?(UCharacterIterator::DONE))
        result = get_code_point_value(ch)
        get_values(result, val)
        if ((val.attr_type).equal?(PROHIBITED))
          raise ParseException.new("A prohibited code point was found in the input" + (iter.get_text).to_s, val.attr_value)
        end
        direction = UCharacter.get_direction(ch)
        if ((first_char_dir).equal?(UCharacterDirection::CHAR_DIRECTION_COUNT))
          first_char_dir = direction
        end
        if ((direction).equal?(UCharacterDirection::LEFT_TO_RIGHT))
          left_to_right = true
          ltr_pos = iter.get_index - 1
        end
        if ((direction).equal?(UCharacterDirection::RIGHT_TO_LEFT) || (direction).equal?(UCharacterDirection::RIGHT_TO_LEFT_ARABIC))
          right_to_left = true
          rtl_pos = iter.get_index - 1
        end
      end
      if ((@check_bi_di).equal?(true))
        # satisfy 2
        if ((left_to_right).equal?(true) && (right_to_left).equal?(true))
          raise ParseException.new("The input does not conform to the rules for BiDi code points." + (iter.get_text).to_s, (rtl_pos > ltr_pos) ? rtl_pos : ltr_pos)
        end
        # satisfy 3
        if ((right_to_left).equal?(true) && !(((first_char_dir).equal?(UCharacterDirection::RIGHT_TO_LEFT) || (first_char_dir).equal?(UCharacterDirection::RIGHT_TO_LEFT_ARABIC)) && ((direction).equal?(UCharacterDirection::RIGHT_TO_LEFT) || (direction).equal?(UCharacterDirection::RIGHT_TO_LEFT_ARABIC))))
          raise ParseException.new("The input does not conform to the rules for BiDi code points." + (iter.get_text).to_s, (rtl_pos > ltr_pos) ? rtl_pos : ltr_pos)
        end
      end
      return norm_out
    end
    
    private
    alias_method :initialize__string_prep, :initialize
  end
  
end
