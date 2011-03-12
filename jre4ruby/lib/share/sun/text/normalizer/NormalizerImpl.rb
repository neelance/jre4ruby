require "rjava"

# Portions Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NormalizerImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :InputStream
    }
  end
  
  # @author  Ram Viswanadha
  class NormalizerImpl 
    include_class_members NormalizerImplImports
    
    class_module.module_eval {
      when_class_loaded do
        begin
          const_set :IMPL, NormalizerImpl.new
        rescue JavaException => e
          raise RuntimeException.new(e.get_message)
        end
      end
      
      const_set_lazy(:UNSIGNED_BYTE_MASK) { 0xff }
      const_attr_reader  :UNSIGNED_BYTE_MASK
      
      const_set_lazy(:UNSIGNED_INT_MASK) { 0xffffffff }
      const_attr_reader  :UNSIGNED_INT_MASK
      
      # This new implementation of the normalization code loads its data from
      # unorm.icu, which is generated with the gennorm tool.
      # The format of that file is described at the end of this file.
      const_set_lazy(:DATA_FILE_NAME) { "/sun/text/resources/unorm.icu" }
      const_attr_reader  :DATA_FILE_NAME
      
      # norm32 value constants
      # quick check flags 0..3 set mean "no" for their forms
      const_set_lazy(:QC_NFC) { 0x11 }
      const_attr_reader  :QC_NFC
      
      # no|maybe
      const_set_lazy(:QC_NFKC) { 0x22 }
      const_attr_reader  :QC_NFKC
      
      # no|maybe
      const_set_lazy(:QC_NFD) { 4 }
      const_attr_reader  :QC_NFD
      
      # no
      const_set_lazy(:QC_NFKD) { 8 }
      const_attr_reader  :QC_NFKD
      
      # no
      const_set_lazy(:QC_ANY_NO) { 0xf }
      const_attr_reader  :QC_ANY_NO
      
      # quick check flags 4..5 mean "maybe" for their forms;
      # test flags>=QC_MAYBE
      const_set_lazy(:QC_MAYBE) { 0x10 }
      const_attr_reader  :QC_MAYBE
      
      const_set_lazy(:QC_ANY_MAYBE) { 0x30 }
      const_attr_reader  :QC_ANY_MAYBE
      
      const_set_lazy(:QC_MASK) { 0x3f }
      const_attr_reader  :QC_MASK
      
      const_set_lazy(:COMBINES_FWD) { 0x40 }
      const_attr_reader  :COMBINES_FWD
      
      const_set_lazy(:COMBINES_BACK) { 0x80 }
      const_attr_reader  :COMBINES_BACK
      
      const_set_lazy(:COMBINES_ANY) { 0xc0 }
      const_attr_reader  :COMBINES_ANY
      
      # UnicodeData.txt combining class in bits 15.
      const_set_lazy(:CC_SHIFT) { 8 }
      const_attr_reader  :CC_SHIFT
      
      const_set_lazy(:CC_MASK) { 0xff00 }
      const_attr_reader  :CC_MASK
      
      # 16 bits for the index to UChars and other extra data
      const_set_lazy(:EXTRA_SHIFT) { 16 }
      const_attr_reader  :EXTRA_SHIFT
      
      # norm32 value constants using >16 bits
      const_set_lazy(:MIN_SPECIAL) { (-0x4000000 & UNSIGNED_INT_MASK) }
      const_attr_reader  :MIN_SPECIAL
      
      const_set_lazy(:SURROGATES_TOP) { (-0x100000 & UNSIGNED_INT_MASK) }
      const_attr_reader  :SURROGATES_TOP
      
      const_set_lazy(:MIN_HANGUL) { (-0x100000 & UNSIGNED_INT_MASK) }
      const_attr_reader  :MIN_HANGUL
      
      const_set_lazy(:MIN_JAMO_V) { (-0xe0000 & UNSIGNED_INT_MASK) }
      const_attr_reader  :MIN_JAMO_V
      
      const_set_lazy(:JAMO_V_TOP) { (-0xd0000 & UNSIGNED_INT_MASK) }
      const_attr_reader  :JAMO_V_TOP
      
      # indexes[] value names
      # number of bytes in normalization trie
      const_set_lazy(:INDEX_TRIE_SIZE) { 0 }
      const_attr_reader  :INDEX_TRIE_SIZE
      
      # number of chars in extra data
      const_set_lazy(:INDEX_CHAR_COUNT) { 1 }
      const_attr_reader  :INDEX_CHAR_COUNT
      
      # number of uint16_t words for combining data
      const_set_lazy(:INDEX_COMBINE_DATA_COUNT) { 2 }
      const_attr_reader  :INDEX_COMBINE_DATA_COUNT
      
      # first code point with quick check NFC NO/MAYBE
      const_set_lazy(:INDEX_MIN_NFC_NO_MAYBE) { 6 }
      const_attr_reader  :INDEX_MIN_NFC_NO_MAYBE
      
      # first code point with quick check NFKC NO/MAYBE
      const_set_lazy(:INDEX_MIN_NFKC_NO_MAYBE) { 7 }
      const_attr_reader  :INDEX_MIN_NFKC_NO_MAYBE
      
      # first code point with quick check NFD NO/MAYBE
      const_set_lazy(:INDEX_MIN_NFD_NO_MAYBE) { 8 }
      const_attr_reader  :INDEX_MIN_NFD_NO_MAYBE
      
      # first code point with quick check NFKD NO/MAYBE
      const_set_lazy(:INDEX_MIN_NFKD_NO_MAYBE) { 9 }
      const_attr_reader  :INDEX_MIN_NFKD_NO_MAYBE
      
      # number of bytes in FCD trie
      const_set_lazy(:INDEX_FCD_TRIE_SIZE) { 10 }
      const_attr_reader  :INDEX_FCD_TRIE_SIZE
      
      # number of bytes in the auxiliary trie
      const_set_lazy(:INDEX_AUX_TRIE_SIZE) { 11 }
      const_attr_reader  :INDEX_AUX_TRIE_SIZE
      
      # changing this requires a new formatVersion
      const_set_lazy(:INDEX_TOP) { 32 }
      const_attr_reader  :INDEX_TOP
      
      # AUX constants
      # value constants for auxTrie
      const_set_lazy(:AUX_UNSAFE_SHIFT) { 11 }
      const_attr_reader  :AUX_UNSAFE_SHIFT
      
      const_set_lazy(:AUX_COMP_EX_SHIFT) { 10 }
      const_attr_reader  :AUX_COMP_EX_SHIFT
      
      const_set_lazy(:AUX_NFC_SKIPPABLE_F_SHIFT) { 12 }
      const_attr_reader  :AUX_NFC_SKIPPABLE_F_SHIFT
      
      const_set_lazy(:AUX_MAX_FNC) { ((1).to_int << AUX_COMP_EX_SHIFT) }
      const_attr_reader  :AUX_MAX_FNC
      
      const_set_lazy(:AUX_UNSAFE_MASK) { (((1 << AUX_UNSAFE_SHIFT) & UNSIGNED_INT_MASK)).to_int }
      const_attr_reader  :AUX_UNSAFE_MASK
      
      const_set_lazy(:AUX_FNC_MASK) { (((AUX_MAX_FNC - 1) & UNSIGNED_INT_MASK)).to_int }
      const_attr_reader  :AUX_FNC_MASK
      
      const_set_lazy(:AUX_COMP_EX_MASK) { (((1 << AUX_COMP_EX_SHIFT) & UNSIGNED_INT_MASK)).to_int }
      const_attr_reader  :AUX_COMP_EX_MASK
      
      const_set_lazy(:AUX_NFC_SKIP_F_MASK) { ((UNSIGNED_INT_MASK & 1) << AUX_NFC_SKIPPABLE_F_SHIFT) }
      const_attr_reader  :AUX_NFC_SKIP_F_MASK
      
      const_set_lazy(:MAX_BUFFER_SIZE) { 20 }
      const_attr_reader  :MAX_BUFFER_SIZE
      
      # Wrappers for Trie implementations
      const_set_lazy(:NormTrieImpl) { Class.new do
        include_class_members NormalizerImpl
        include Trie::DataManipulate
        
        class_module.module_eval {
          
          def norm_trie
            defined?(@@norm_trie) ? @@norm_trie : @@norm_trie= nil
          end
          alias_method :attr_norm_trie, :norm_trie
          
          def norm_trie=(value)
            @@norm_trie = value
          end
          alias_method :attr_norm_trie=, :norm_trie=
        }
        
        typesig { [::Java::Int] }
        # Called by com.ibm.icu.util.Trie to extract from a lead surrogate's
        # data the index array offset of the indexes for that lead surrogate.
        # @param property data value for a surrogate from the trie, including
        #         the folding offset
        # @return data offset or 0 if there is no data for the lead surrogate
        # normTrie: 32-bit trie result may contain a special extraData index with the folding offset
        def get_folding_offset(value)
          return BMP_INDEX_LENGTH + ((value >> (EXTRA_SHIFT - SURROGATE_BLOCK_BITS)) & (0x3ff << SURROGATE_BLOCK_BITS))
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__norm_trie_impl, :initialize
      end }
      
      const_set_lazy(:FCDTrieImpl) { Class.new do
        include_class_members NormalizerImpl
        include Trie::DataManipulate
        
        class_module.module_eval {
          
          def fcd_trie
            defined?(@@fcd_trie) ? @@fcd_trie : @@fcd_trie= nil
          end
          alias_method :attr_fcd_trie, :fcd_trie
          
          def fcd_trie=(value)
            @@fcd_trie = value
          end
          alias_method :attr_fcd_trie=, :fcd_trie=
        }
        
        typesig { [::Java::Int] }
        # Called by com.ibm.icu.util.Trie to extract from a lead surrogate's
        # data the index array offset of the indexes for that lead surrogate.
        # @param property data value for a surrogate from the trie, including
        #         the folding offset
        # @return data offset or 0 if there is no data for the lead surrogate
        # fcdTrie: the folding offset is the lead FCD value itself
        def get_folding_offset(value)
          return value
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__fcdtrie_impl, :initialize
      end }
      
      const_set_lazy(:AuxTrieImpl) { Class.new do
        include_class_members NormalizerImpl
        include Trie::DataManipulate
        
        class_module.module_eval {
          
          def aux_trie
            defined?(@@aux_trie) ? @@aux_trie : @@aux_trie= nil
          end
          alias_method :attr_aux_trie, :aux_trie
          
          def aux_trie=(value)
            @@aux_trie = value
          end
          alias_method :attr_aux_trie=, :aux_trie=
        }
        
        typesig { [::Java::Int] }
        # Called by com.ibm.icu.util.Trie to extract from a lead surrogate's
        # data the index array offset of the indexes for that lead surrogate.
        # @param property data value for a surrogate from the trie, including
        #        the folding offset
        # @return data offset or 0 if there is no data for the lead surrogate
        # auxTrie: the folding offset is in bits 9..0 of the 16-bit trie result
        def get_folding_offset(value)
          return ((value & AUX_FNC_MASK)).to_int << SURROGATE_BLOCK_BITS
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__aux_trie_impl, :initialize
      end }
      
      
      def fcd_trie_impl
        defined?(@@fcd_trie_impl) ? @@fcd_trie_impl : @@fcd_trie_impl= nil
      end
      alias_method :attr_fcd_trie_impl, :fcd_trie_impl
      
      def fcd_trie_impl=(value)
        @@fcd_trie_impl = value
      end
      alias_method :attr_fcd_trie_impl=, :fcd_trie_impl=
      
      
      def norm_trie_impl
        defined?(@@norm_trie_impl) ? @@norm_trie_impl : @@norm_trie_impl= nil
      end
      alias_method :attr_norm_trie_impl, :norm_trie_impl
      
      def norm_trie_impl=(value)
        @@norm_trie_impl = value
      end
      alias_method :attr_norm_trie_impl=, :norm_trie_impl=
      
      
      def aux_trie_impl
        defined?(@@aux_trie_impl) ? @@aux_trie_impl : @@aux_trie_impl= nil
      end
      alias_method :attr_aux_trie_impl, :aux_trie_impl
      
      def aux_trie_impl=(value)
        @@aux_trie_impl = value
      end
      alias_method :attr_aux_trie_impl=, :aux_trie_impl=
      
      
      def indexes
        defined?(@@indexes) ? @@indexes : @@indexes= nil
      end
      alias_method :attr_indexes, :indexes
      
      def indexes=(value)
        @@indexes = value
      end
      alias_method :attr_indexes=, :indexes=
      
      
      def combining_table
        defined?(@@combining_table) ? @@combining_table : @@combining_table= nil
      end
      alias_method :attr_combining_table, :combining_table
      
      def combining_table=(value)
        @@combining_table = value
      end
      alias_method :attr_combining_table=, :combining_table=
      
      
      def extra_data
        defined?(@@extra_data) ? @@extra_data : @@extra_data= nil
      end
      alias_method :attr_extra_data, :extra_data
      
      def extra_data=(value)
        @@extra_data = value
      end
      alias_method :attr_extra_data=, :extra_data=
      
      
      def is_data_loaded
        defined?(@@is_data_loaded) ? @@is_data_loaded : @@is_data_loaded= false
      end
      alias_method :attr_is_data_loaded, :is_data_loaded
      
      def is_data_loaded=(value)
        @@is_data_loaded = value
      end
      alias_method :attr_is_data_loaded=, :is_data_loaded=
      
      
      def is_format_version_2_1
        defined?(@@is_format_version_2_1) ? @@is_format_version_2_1 : @@is_format_version_2_1= false
      end
      alias_method :attr_is_format_version_2_1, :is_format_version_2_1
      
      def is_format_version_2_1=(value)
        @@is_format_version_2_1 = value
      end
      alias_method :attr_is_format_version_2_1=, :is_format_version_2_1=
      
      
      def is_format_version_2_2
        defined?(@@is_format_version_2_2) ? @@is_format_version_2_2 : @@is_format_version_2_2= false
      end
      alias_method :attr_is_format_version_2_2, :is_format_version_2_2
      
      def is_format_version_2_2=(value)
        @@is_format_version_2_2 = value
      end
      alias_method :attr_is_format_version_2_2=, :is_format_version_2_2=
      
      
      def unicode_version
        defined?(@@unicode_version) ? @@unicode_version : @@unicode_version= nil
      end
      alias_method :attr_unicode_version, :unicode_version
      
      def unicode_version=(value)
        @@unicode_version = value
      end
      alias_method :attr_unicode_version=, :unicode_version=
      
      # Default buffer size of datafile
      const_set_lazy(:DATA_BUFFER_SIZE) { 25000 }
      const_attr_reader  :DATA_BUFFER_SIZE
      
      # FCD check: everything below this code point is known to have a 0
      # lead combining class
      const_set_lazy(:MIN_WITH_LEAD_CC) { 0x300 }
      const_attr_reader  :MIN_WITH_LEAD_CC
      
      # Bit 7 of the length byte for a decomposition string in extra data is
      # a flag indicating whether the decomposition string is
      # preceded by a 16-bit word with the leading and trailing cc
      # of the decomposition (like for A-umlaut);
      # if not, then both cc's are zero (like for compatibility ideographs).
      const_set_lazy(:DECOMP_FLAG_LENGTH_HAS_CC) { 0x80 }
      const_attr_reader  :DECOMP_FLAG_LENGTH_HAS_CC
      
      # Bits 6..0 of the length byte contain the actual length.
      const_set_lazy(:DECOMP_LENGTH_MASK) { 0x7f }
      const_attr_reader  :DECOMP_LENGTH_MASK
      
      # Length of the BMP portion of the index (stage 1) array.
      const_set_lazy(:BMP_INDEX_LENGTH) { 0x10000 >> Trie::INDEX_STAGE_1_SHIFT_ }
      const_attr_reader  :BMP_INDEX_LENGTH
      
      #  Number of bits of a trail surrogate that are used in index table
      # lookups.
      const_set_lazy(:SURROGATE_BLOCK_BITS) { 10 - Trie::INDEX_STAGE_1_SHIFT_ }
      const_attr_reader  :SURROGATE_BLOCK_BITS
      
      typesig { [::Java::Int] }
      # public utility
      def get_from_indexes_arr(index)
        return self.attr_indexes[index]
      end
    }
    
    typesig { [] }
    # protected constructor ---------------------------------------------
    # Constructor
    # @exception thrown when data reading fails or data corrupted
    def initialize
      # data should be loaded only once
      if (!self.attr_is_data_loaded)
        # jar access
        i = ICUData.get_required_stream(DATA_FILE_NAME)
        b = BufferedInputStream.new(i, DATA_BUFFER_SIZE)
        reader = NormalizerDataReader.new(b)
        # read the indexes
        self.attr_indexes = reader.read_indexes(NormalizerImpl::INDEX_TOP)
        norm_bytes = Array.typed(::Java::Byte).new(self.attr_indexes[NormalizerImpl::INDEX_TRIE_SIZE]) { 0 }
        combining_table_top = self.attr_indexes[NormalizerImpl::INDEX_COMBINE_DATA_COUNT]
        self.attr_combining_table = CharArray.new(combining_table_top)
        extra_data_top = self.attr_indexes[NormalizerImpl::INDEX_CHAR_COUNT]
        self.attr_extra_data = CharArray.new(extra_data_top)
        fcd_bytes = Array.typed(::Java::Byte).new(self.attr_indexes[NormalizerImpl::INDEX_FCD_TRIE_SIZE]) { 0 }
        aux_bytes = Array.typed(::Java::Byte).new(self.attr_indexes[NormalizerImpl::INDEX_AUX_TRIE_SIZE]) { 0 }
        self.attr_fcd_trie_impl = FCDTrieImpl.new
        self.attr_norm_trie_impl = NormTrieImpl.new
        self.attr_aux_trie_impl = AuxTrieImpl.new
        # load the rest of the data data and initialize the data members
        reader.read(norm_bytes, fcd_bytes, aux_bytes, self.attr_extra_data, self.attr_combining_table)
        NormTrieImpl.attr_norm_trie = IntTrie.new(ByteArrayInputStream.new(norm_bytes), self.attr_norm_trie_impl)
        FCDTrieImpl.attr_fcd_trie = CharTrie.new(ByteArrayInputStream.new(fcd_bytes), self.attr_fcd_trie_impl)
        AuxTrieImpl.attr_aux_trie = CharTrie.new(ByteArrayInputStream.new(aux_bytes), self.attr_aux_trie_impl)
        # we reached here without any exceptions so the data is fully
        # loaded set the variable to true
        self.attr_is_data_loaded = true
        # get the data format version
        format_version = reader.get_data_format_version
        self.attr_is_format_version_2_1 = (format_version[0] > 2 || ((format_version[0]).equal?(2) && format_version[1] >= 1))
        self.attr_is_format_version_2_2 = (format_version[0] > 2 || ((format_version[0]).equal?(2) && format_version[1] >= 2))
        self.attr_unicode_version = reader.get_unicode_version
        b.close
      end
    end
    
    class_module.module_eval {
      # ----------------------------------------------------------------------
      # Korean Hangul and Jamo constants
      const_set_lazy(:JAMO_L_BASE) { 0x1100 }
      const_attr_reader  :JAMO_L_BASE
      
      # "lead" jamo
      const_set_lazy(:JAMO_V_BASE) { 0x1161 }
      const_attr_reader  :JAMO_V_BASE
      
      # "vowel" jamo
      const_set_lazy(:JAMO_T_BASE) { 0x11a7 }
      const_attr_reader  :JAMO_T_BASE
      
      # "trail" jamo
      const_set_lazy(:HANGUL_BASE) { 0xac00 }
      const_attr_reader  :HANGUL_BASE
      
      const_set_lazy(:JAMO_L_COUNT) { 19 }
      const_attr_reader  :JAMO_L_COUNT
      
      const_set_lazy(:JAMO_V_COUNT) { 21 }
      const_attr_reader  :JAMO_V_COUNT
      
      const_set_lazy(:JAMO_T_COUNT) { 28 }
      const_attr_reader  :JAMO_T_COUNT
      
      const_set_lazy(:HANGUL_COUNT) { JAMO_L_COUNT * JAMO_V_COUNT * JAMO_T_COUNT }
      const_attr_reader  :HANGUL_COUNT
      
      typesig { [::Java::Char] }
      def is_hangul_without_jamo_t(c)
        c -= HANGUL_BASE
        return c < HANGUL_COUNT && (c % JAMO_T_COUNT).equal?(0)
      end
      
      typesig { [::Java::Long] }
      # norm32 helpers
      # is this a norm32 with a regular index?
      def is_norm32regular(norm32)
        return norm32 < MIN_SPECIAL
      end
      
      typesig { [::Java::Long] }
      # is this a norm32 with a special index for a lead surrogate?
      def is_norm32lead_surrogate(norm32)
        return MIN_SPECIAL <= norm32 && norm32 < SURROGATES_TOP
      end
      
      typesig { [::Java::Long] }
      # is this a norm32 with a special index for a Hangul syllable or a Jamo?
      def is_norm32hangul_or_jamo(norm32)
        return norm32 >= MIN_HANGUL
      end
      
      typesig { [::Java::Long] }
      # Given norm32 for Jamo V or T,
      # is this a Jamo V?
      def is_jamo_vtnorm32jamo_v(norm32)
        return norm32 < JAMO_V_TOP
      end
      
      typesig { [::Java::Char] }
      # data access primitives -----------------------------------------------
      # unsigned
      def get_norm32(c)
        return ((UNSIGNED_INT_MASK) & (NormTrieImpl.attr_norm_trie.get_lead_value(c)))
      end
      
      typesig { [::Java::Long, ::Java::Char] }
      # unsigned
      def get_norm32from_surrogate_pair(norm32, c2)
        # the surrogate index in norm32 stores only the number of the surrogate
        # index block see gennorm/store.c/getFoldedNormValue()
        return ((UNSIGNED_INT_MASK) & NormTrieImpl.attr_norm_trie.get_trail_value((norm32).to_int, c2))
      end
      
      typesig { [::Java::Int] }
      # /CLOVER:OFF
      def get_norm32(c)
        return (UNSIGNED_INT_MASK & (NormTrieImpl.attr_norm_trie.get_code_point_value(c)))
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # get a norm32 from text with complete code points
      # (like from decompositions)
      # unsigned
      def get_norm32(p, start, mask)
        # unsigned
        # unsigned
        norm32 = get_norm32(p[start])
        if (((norm32 & mask) > 0) && is_norm32lead_surrogate(norm32))
          # p is a lead surrogate, get the real norm32
          norm32 = get_norm32from_surrogate_pair(norm32, p[start + 1])
        end
        return norm32
      end
      
      typesig { [] }
      # // for StringPrep
      def get_unicode_version
        return VersionInfo.get_instance(self.attr_unicode_version[0], self.attr_unicode_version[1], self.attr_unicode_version[2], self.attr_unicode_version[3])
      end
      
      typesig { [::Java::Char] }
      def get_fcd16(c)
        return FCDTrieImpl.attr_fcd_trie.get_lead_value(c)
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      def get_fcd16from_surrogate_pair(fcd16, c2)
        # the surrogate index in fcd16 is an absolute offset over the
        # start of stage 1
        return FCDTrieImpl.attr_fcd_trie.get_trail_value(fcd16, c2)
      end
      
      typesig { [::Java::Int] }
      def get_fcd16(c)
        return FCDTrieImpl.attr_fcd_trie.get_code_point_value(c)
      end
      
      typesig { [::Java::Long] }
      def get_extra_data_index(norm32)
        return ((norm32 >> EXTRA_SHIFT)).to_int
      end
      
      const_set_lazy(:DecomposeArgs) { Class.new do
        include_class_members NormalizerImpl
        
        # unsigned byte
        attr_accessor :cc
        alias_method :attr_cc, :cc
        undef_method :cc
        alias_method :attr_cc=, :cc=
        undef_method :cc=
        
        # unsigned byte
        attr_accessor :trail_cc
        alias_method :attr_trail_cc, :trail_cc
        undef_method :trail_cc
        alias_method :attr_trail_cc=, :trail_cc=
        undef_method :trail_cc=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        typesig { [] }
        def initialize
          @cc = 0
          @trail_cc = 0
          @length = 0
        end
        
        private
        alias_method :initialize__decompose_args, :initialize
      end }
      
      typesig { [::Java::Long, ::Java::Int, DecomposeArgs] }
      # get the canonical or compatibility decomposition for one character
      # 
      # @return index into the extraData array
      # index
      def decompose(norm32, qc_mask, args)
        # unsigned
        # unsigned
        p = get_extra_data_index(norm32)
        args.attr_length = self.attr_extra_data[((p += 1) - 1)]
        if (!((norm32 & qc_mask & QC_NFKD)).equal?(0) && args.attr_length >= 0x100)
          # use compatibility decomposition, skip canonical data
          p += ((args.attr_length >> 7) & 1) + (args.attr_length & DECOMP_LENGTH_MASK)
          args.attr_length >>= 8
        end
        if ((args.attr_length & DECOMP_FLAG_LENGTH_HAS_CC) > 0)
          # get the lead and trail cc's
          both_ccs = self.attr_extra_data[((p += 1) - 1)]
          args.attr_cc = (UNSIGNED_BYTE_MASK) & (both_ccs >> 8)
          args.attr_trail_cc = (UNSIGNED_BYTE_MASK) & both_ccs
        else
          # lead and trail cc's are both 0
          args.attr_cc = args.attr_trail_cc = 0
        end
        args.attr_length &= DECOMP_LENGTH_MASK
        return p
      end
      
      typesig { [::Java::Long, DecomposeArgs] }
      # get the canonical decomposition for one character
      # @return index into the extraData array
      def decompose(norm32, args)
        # unsigned
        p = get_extra_data_index(norm32)
        args.attr_length = self.attr_extra_data[((p += 1) - 1)]
        if ((args.attr_length & DECOMP_FLAG_LENGTH_HAS_CC) > 0)
          # get the lead and trail cc's
          both_ccs = self.attr_extra_data[((p += 1) - 1)]
          args.attr_cc = (UNSIGNED_BYTE_MASK) & (both_ccs >> 8)
          args.attr_trail_cc = (UNSIGNED_BYTE_MASK) & both_ccs
        else
          # lead and trail cc's are both 0
          args.attr_cc = args.attr_trail_cc = 0
        end
        args.attr_length &= DECOMP_LENGTH_MASK
        return p
      end
      
      const_set_lazy(:NextCCArgs) { Class.new do
        include_class_members NormalizerImpl
        
        attr_accessor :source
        alias_method :attr_source, :source
        undef_method :source
        alias_method :attr_source=, :source=
        undef_method :source=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        attr_accessor :limit
        alias_method :attr_limit, :limit
        undef_method :limit
        alias_method :attr_limit=, :limit=
        undef_method :limit=
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        attr_accessor :c2
        alias_method :attr_c2, :c2
        undef_method :c2
        alias_method :attr_c2=, :c2=
        undef_method :c2=
        
        typesig { [] }
        def initialize
          @source = nil
          @next = 0
          @limit = 0
          @c = 0
          @c2 = 0
        end
        
        private
        alias_method :initialize__next_ccargs, :initialize
      end }
      
      typesig { [NextCCArgs] }
      # get the combining class of (c, c2)= args.source[args.next++]
      # before: args.next<args.limit  after: args.next<=args.limit
      # if only one code unit is used, then c2==0
      # unsigned byte
      def get_next_cc(args)
        # unsigned
        norm32 = 0
        args.attr_c = args.attr_source[((args.attr_next += 1) - 1)]
        norm32 = get_norm32(args.attr_c)
        if (((norm32 & CC_MASK)).equal?(0))
          args.attr_c2 = 0
          return 0
        else
          if (!is_norm32lead_surrogate(norm32))
            args.attr_c2 = 0
          else
            # c is a lead surrogate, get the real norm32
            if (!(args.attr_next).equal?(args.attr_limit) && UTF16.is_trail_surrogate(args.attr_c2 = args.attr_source[args.attr_next]))
              (args.attr_next += 1)
              norm32 = get_norm32from_surrogate_pair(norm32, args.attr_c2)
            else
              args.attr_c2 = 0
              return 0
            end
          end
          return (((UNSIGNED_BYTE_MASK) & (norm32 >> CC_SHIFT))).to_int
        end
      end
      
      const_set_lazy(:PrevArgs) { Class.new do
        include_class_members NormalizerImpl
        
        attr_accessor :src
        alias_method :attr_src, :src
        undef_method :src
        alias_method :attr_src=, :src=
        undef_method :src=
        
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        attr_accessor :current
        alias_method :attr_current, :current
        undef_method :current
        alias_method :attr_current=, :current=
        undef_method :current=
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        attr_accessor :c2
        alias_method :attr_c2, :c2
        undef_method :c2
        alias_method :attr_c2=, :c2=
        undef_method :c2=
        
        typesig { [] }
        def initialize
          @src = nil
          @start = 0
          @current = 0
          @c = 0
          @c2 = 0
        end
        
        private
        alias_method :initialize__prev_args, :initialize
      end }
      
      typesig { [PrevArgs, ::Java::Int, ::Java::Int] }
      # read backwards and get norm32
      # return 0 if the character is <minC
      # if c2!=0 then (c2, c) is a surrogate pair (reversed - c2 is first
      # surrogate but read second!)
      # unsigned
      def get_prev_norm32(args, min_c, mask)
        # unsigned
        # unsigned
        # unsigned
        norm32 = 0
        args.attr_c = args.attr_src[(args.attr_current -= 1)]
        args.attr_c2 = 0
        # check for a surrogate before getting norm32 to see if we need to
        # predecrement further
        if (args.attr_c < min_c)
          return 0
        else
          if (!UTF16.is_surrogate(args.attr_c))
            return get_norm32(args.attr_c)
          else
            if (UTF16.is_lead_surrogate(args.attr_c))
              # unpaired first surrogate
              return 0
            else
              if (!(args.attr_current).equal?(args.attr_start) && UTF16.is_lead_surrogate(args.attr_c2 = args.attr_src[args.attr_current - 1]))
                (args.attr_current -= 1)
                norm32 = get_norm32(args.attr_c2)
                if (((norm32 & mask)).equal?(0))
                  # all surrogate pairs with this lead surrogate have
                  # only irrelevant data
                  return 0
                else
                  # norm32 must be a surrogate special
                  return get_norm32from_surrogate_pair(norm32, args.attr_c)
                end
              else
                # unpaired second surrogate
                args.attr_c2 = 0
                return 0
              end
            end
          end
        end
      end
      
      typesig { [PrevArgs] }
      # get the combining class of (c, c2)=*--p
      # before: start<p  after: start<=p
      # unsigned byte
      def get_prev_cc(args)
        return (((UNSIGNED_BYTE_MASK) & (get_prev_norm32(args, MIN_WITH_LEAD_CC, CC_MASK) >> CC_SHIFT))).to_int
      end
      
      typesig { [::Java::Long, ::Java::Int, ::Java::Int] }
      # is this a safe boundary character for NF*D?
      # (lead cc==0)
      def is_nfdsafe(norm32, cc_or_qcmask, decomp_qcmask)
        # unsigned
        # unsigned
        # unsigned
        if (((norm32 & cc_or_qcmask)).equal?(0))
          return true # cc==0 and no decomposition: this is NF*D safe
        end
        # inspect its decomposition - maybe a Hangul but not a surrogate here
        if (is_norm32regular(norm32) && !((norm32 & decomp_qcmask)).equal?(0))
          args = DecomposeArgs.new
          # decomposes, get everything from the variable-length extra data
          decompose(norm32, decomp_qcmask, args)
          return (args.attr_cc).equal?(0)
        else
          # no decomposition (or Hangul), test the cc directly
          return ((norm32 & CC_MASK)).equal?(0)
        end
      end
      
      typesig { [::Java::Long, ::Java::Int, ::Java::Int] }
      # is this (or does its decomposition begin with) a "true starter"?
      # (cc==0 and NF*C_YES)
      def is_true_starter(norm32, cc_or_qcmask, decomp_qcmask)
        # unsigned
        # unsigned
        # unsigned
        if (((norm32 & cc_or_qcmask)).equal?(0))
          return true # this is a true starter (could be Hangul or Jamo L)
        end
        # inspect its decomposition - not a Hangul or a surrogate here
        if (!((norm32 & decomp_qcmask)).equal?(0))
          p = 0 # index into extra data array
          args = DecomposeArgs.new
          # decomposes, get everything from the variable-length extra data
          p = decompose(norm32, decomp_qcmask, args)
          if ((args.attr_cc).equal?(0))
            # unsigned
            qc_mask = cc_or_qcmask & QC_MASK
            # does it begin with NFC_YES?
            if (((get_norm32(self.attr_extra_data, p, qc_mask) & qc_mask)).equal?(0))
              # yes, the decomposition begins with a true starter
              return true
            end
          end
        end
        return false
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Char, ::Java::Char, ::Java::Int] }
      # reorder UTF-16 in-place ----------------------------------------------
      # simpler, single-character version of mergeOrdered() -
      # bubble-insert one single code point into the preceding string
      # which is already canonically ordered
      # (c, c2) may or may not yet have been inserted at src[current]..src[p]
      # 
      # it must be p=current+lengthof(c, c2) i.e. p=current+(c2==0 ? 1 : 2)
      # 
      # before: src[start]..src[current] is already ordered, and
      #         src[current]..src[p]     may or may not hold (c, c2) but
      #                          must be exactly the same length as (c, c2)
      # after: src[start]..src[p] is ordered
      # 
      # @return the trailing combining class
      # unsigned byte
      def insert_ordered(source, start, current, p, c, c2, cc)
        # unsigned byte
        back = 0
        pre_back = 0
        r = 0
        prev_cc = 0
        trail_cc = cc
        if (start < current && !(cc).equal?(0))
          # search for the insertion point where cc>=prevCC
          pre_back = back = current
          prev_args = PrevArgs.new
          prev_args.attr_current = current
          prev_args.attr_start = start
          prev_args.attr_src = source
          # get the prevCC
          prev_cc = get_prev_cc(prev_args)
          pre_back = prev_args.attr_current
          if (cc < prev_cc)
            # this will be the last code point, so keep its cc
            trail_cc = prev_cc
            back = pre_back
            while (start < pre_back)
              prev_cc = get_prev_cc(prev_args)
              pre_back = prev_args.attr_current
              if (cc >= prev_cc)
                break
              end
              back = pre_back
            end
            # this is where we are right now with all these indicies:
            # [start]..[pPreBack] 0..? code points that we can ignore
            # [pPreBack]..[pBack] 0..1 code points with prevCC<=cc
            # [pBack]..[current] 0..n code points with >cc, move up to insert (c, c2)
            # [current]..[p]         1 code point (c, c2) with cc
            # move the code units in between up
            r = p
            begin
              source[(r -= 1)] = source[(current -= 1)]
            end while (!(back).equal?(current))
          end
        end
        # insert (c, c2)
        source[current] = c
        if (!(c2).equal?(0))
          source[(current + 1)] = c2
        end
        # we know the cc of the last code point
        return trail_cc
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean] }
      # merge two UTF-16 string parts together
      # to canonically order (order by combining classes) their concatenation
      # 
      # the two strings may already be adjacent, so that the merging is done
      # in-place if the two strings are not adjacent, then the buffer holding the
      # first one must be large enough
      # the second string may or may not be ordered in itself
      # 
      # before: [start]..[current] is already ordered, and
      #         [next]..[limit]    may be ordered in itself, but
      #                          is not in relation to [start..current[
      # after: [start..current+(limit-next)[ is ordered
      # 
      # the algorithm is a simple bubble-sort that takes the characters from
      # src[next++] and inserts them in correct combining class order into the
      # preceding part of the string
      # 
      # since this function is called much less often than the single-code point
      # insertOrdered(), it just uses that for easier maintenance
      # 
      # @return the trailing combining class
      # unsigned byte
      def merge_ordered(source, start, current, data, next_, limit, is_ordered)
        r = 0 # unsigned byte
        cc = 0
        trail_cc = 0
        adjacent = false
        adjacent = (current).equal?(next_)
        nc_args = NextCCArgs.new
        nc_args.attr_source = data
        nc_args.attr_next = next_
        nc_args.attr_limit = limit
        if (!(start).equal?(current) || !is_ordered)
          while (nc_args.attr_next < nc_args.attr_limit)
            cc = get_next_cc(nc_args)
            if ((cc).equal?(0))
              # does not bubble back
              trail_cc = 0
              if (adjacent)
                current = nc_args.attr_next
              else
                data[((current += 1) - 1)] = nc_args.attr_c
                if (!(nc_args.attr_c2).equal?(0))
                  data[((current += 1) - 1)] = nc_args.attr_c2
                end
              end
              if (is_ordered)
                break
              else
                start = current
              end
            else
              r = current + ((nc_args.attr_c2).equal?(0) ? 1 : 2)
              trail_cc = insert_ordered(source, start, current, r, nc_args.attr_c, nc_args.attr_c2, cc)
              current = r
            end
          end
        end
        if ((nc_args.attr_next).equal?(nc_args.attr_limit))
          # we know the cc of the last code point
          return trail_cc
        else
          if (!adjacent)
            # copy the second string part
            begin
              source[((current += 1) - 1)] = data[((nc_args.attr_next += 1) - 1)]
            end while (!(nc_args.attr_next).equal?(nc_args.attr_limit))
            nc_args.attr_limit = current
          end
          prev_args = PrevArgs.new
          prev_args.attr_src = data
          prev_args.attr_start = start
          prev_args.attr_current = nc_args.attr_limit
          return get_prev_cc(prev_args)
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # unsigned byte
      def merge_ordered(source, start, current, data, next_, limit)
        return merge_ordered(source, start, current, data, next_, limit, true)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean, UnicodeSet] }
      def quick_check(src, src_start, src_limit, min_no_maybe, qc_mask, options, allow_maybe, nx)
        cc_or_qcmask = 0
        norm32 = 0
        c = 0
        c2 = 0
        cc = 0
        prev_cc = 0
        qc_norm32 = 0
        result = nil
        args = ComposePartArgs.new
        buffer = nil
        start = src_start
        if (!self.attr_is_data_loaded)
          return NormalizerBase::MAYBE
        end
        # initialize
        cc_or_qcmask = CC_MASK | qc_mask
        result = NormalizerBase::YES
        prev_cc = 0
        loop do
          loop do
            if ((src_start).equal?(src_limit))
              return result
            else
              if ((c = src[((src_start += 1) - 1)]) >= min_no_maybe && !(((norm32 = get_norm32(c)) & cc_or_qcmask)).equal?(0))
                break
              end
            end
            prev_cc = 0
          end
          # check one above-minimum, relevant code unit
          if (is_norm32lead_surrogate(norm32))
            # c is a lead surrogate, get the real norm32
            if (!(src_start).equal?(src_limit) && UTF16.is_trail_surrogate(c2 = src[src_start]))
              (src_start += 1)
              norm32 = get_norm32from_surrogate_pair(norm32, c2)
            else
              norm32 = 0
              c2 = 0
            end
          else
            c2 = 0
          end
          if (nx_contains(nx, c, c2))
            # excluded: norm32==0
            norm32 = 0
          end
          # check the combining order
          cc = RJava.cast_to_char(((norm32 >> CC_SHIFT) & 0xff))
          if (!(cc).equal?(0) && cc < prev_cc)
            return NormalizerBase::NO
          end
          prev_cc = cc
          # check for "no" or "maybe" quick check flags
          qc_norm32 = norm32 & qc_mask
          if ((qc_norm32 & QC_ANY_NO) >= 1)
            result = NormalizerBase::NO
            break
          else
            if (!(qc_norm32).equal?(0))
              # "maybe" can only occur for NFC and NFKC
              if (allow_maybe)
                result = NormalizerBase::MAYBE
              else
                # normalize a section around here to see if it is really
                # normalized or not
                prev_starter = 0 # unsigned
                decomp_qcmask = 0
                decomp_qcmask = (qc_mask << 2) & 0xf # decomposition quick check mask
                # find the previous starter
                # set prevStarter to the beginning of the current character
                prev_starter = src_start - 1
                if (UTF16.is_trail_surrogate(src[prev_starter]))
                  # safe because unpaired surrogates do not result
                  # in "maybe"
                  (prev_starter -= 1)
                end
                prev_starter = find_previous_starter(src, start, prev_starter, cc_or_qcmask, decomp_qcmask, RJava.cast_to_char(min_no_maybe))
                # find the next true starter in [src..limit[ - modifies
                # src to point to the next starter
                src_start = find_next_starter(src, src_start, src_limit, qc_mask, decomp_qcmask, RJava.cast_to_char(min_no_maybe))
                # set the args for compose part
                args.attr_prev_cc = prev_cc
                # decompose and recompose [prevStarter..src[
                buffer = compose_part(args, prev_starter, src, src_start, src_limit, options, nx)
                # compare the normalized version with the original
                if (!(0).equal?(str_compare(buffer, 0, args.attr_length, src, prev_starter, (src_start - prev_starter), false)))
                  result = NormalizerBase::NO # normalization differs
                  break
                end
                # continue after the next starter
              end
            end
          end
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean, Array.typed(::Java::Int), UnicodeSet] }
      # ------------------------------------------------------
      # make NFD & NFKD
      # ------------------------------------------------------
      def decompose(src, src_start, src_limit, dest, dest_start, dest_limit, compat, out_trail_cc, nx)
        buffer = CharArray.new(3)
        prev_src = 0
        norm32 = 0
        cc_or_qcmask = 0
        qc_mask = 0
        reorder_start_index = 0
        length = 0
        c = 0
        c2 = 0
        min_no_maybe = 0 # unsigned byte
        cc = 0
        prev_cc = 0
        trail_cc = 0
        p = nil
        p_start = 0
        dest_index = dest_start
        src_index = src_start
        if (!compat)
          min_no_maybe = RJava.cast_to_char(self.attr_indexes[INDEX_MIN_NFD_NO_MAYBE])
          qc_mask = QC_NFD
        else
          min_no_maybe = RJava.cast_to_char(self.attr_indexes[INDEX_MIN_NFKD_NO_MAYBE])
          qc_mask = QC_NFKD
        end
        # initialize
        cc_or_qcmask = CC_MASK | qc_mask
        reorder_start_index = 0
        prev_cc = 0
        norm32 = 0
        c = 0
        p_start = 0
        cc = trail_cc = -1 # initialize to bogus value
        loop do
          # count code units below the minimum or with irrelevant data for
          # the quick check
          prev_src = src_index
          while (!(src_index).equal?(src_limit) && ((c = src[src_index]) < min_no_maybe || (((norm32 = get_norm32(c)) & cc_or_qcmask)).equal?(0)))
            prev_cc = 0
            (src_index += 1)
          end
          # copy these code units all at once
          if (!(src_index).equal?(prev_src))
            length = ((src_index - prev_src)).to_int
            if ((dest_index + length) <= dest_limit)
              System.arraycopy(src, prev_src, dest, dest_index, length)
            end
            dest_index += length
            reorder_start_index = dest_index
          end
          # end of source reached?
          if ((src_index).equal?(src_limit))
            break
          end
          # c already contains *src and norm32 is set for it, increment src
          (src_index += 1)
          # check one above-minimum, relevant code unit
          # generally, set p and length to the decomposition string
          # in simple cases, p==NULL and (c, c2) will hold the length code
          # units to append in all cases, set cc to the lead and trailCC to
          # the trail combining class
          # 
          # the following merge-sort of the current character into the
          # preceding, canonically ordered result text will use the
          # optimized insertOrdered()
          # if there is only one single code point to process;
          # this is indicated with p==NULL, and (c, c2) is the character to
          # insert
          # ((c, 0) for a BMP character and (lead surrogate, trail surrogate)
          # for a supplementary character)
          # otherwise, p[length] is merged in with _mergeOrdered()
          if (is_norm32hangul_or_jamo(norm32))
            if (nx_contains(nx, c))
              c2 = 0
              p = nil
              length = 1
            else
              # Hangul syllable: decompose algorithmically
              p = buffer
              p_start = 0
              cc = trail_cc = 0
              c -= HANGUL_BASE
              c2 = RJava.cast_to_char((c % JAMO_T_COUNT))
              c /= JAMO_T_COUNT
              if (c2 > 0)
                buffer[2] = RJava.cast_to_char((JAMO_T_BASE + c2))
                length = 3
              else
                length = 2
              end
              buffer[1] = RJava.cast_to_char((JAMO_V_BASE + c % JAMO_V_COUNT))
              buffer[0] = RJava.cast_to_char((JAMO_L_BASE + c / JAMO_V_COUNT))
            end
          else
            if (is_norm32regular(norm32))
              c2 = 0
              length = 1
            else
              # c is a lead surrogate, get the real norm32
              if (!(src_index).equal?(src_limit) && UTF16.is_trail_surrogate(c2 = src[src_index]))
                (src_index += 1)
                length = 2
                norm32 = get_norm32from_surrogate_pair(norm32, c2)
              else
                c2 = 0
                length = 1
                norm32 = 0
              end
            end
            # get the decomposition and the lead and trail cc's
            if (nx_contains(nx, c, c2))
              # excluded: norm32==0
              cc = trail_cc = 0
              p = nil
            else
              if (((norm32 & qc_mask)).equal?(0))
                # c does not decompose
                cc = trail_cc = (((UNSIGNED_BYTE_MASK) & (norm32 >> CC_SHIFT))).to_int
                p = nil
                p_start = -1
              else
                arg = DecomposeArgs.new
                # c decomposes, get everything from the variable-length
                # extra data
                p_start = decompose(norm32, qc_mask, arg)
                p = self.attr_extra_data
                length = arg.attr_length
                cc = arg.attr_cc
                trail_cc = arg.attr_trail_cc
                if ((length).equal?(1))
                  # fastpath a single code unit from decomposition
                  c = p[p_start]
                  c2 = 0
                  p = nil
                  p_start = -1
                end
              end
            end
          end
          # append the decomposition to the destination buffer, assume
          # length>0
          if ((dest_index + length) <= dest_limit)
            reorder_split = dest_index
            if ((p).nil?)
              # fastpath: single code point
              if (!(cc).equal?(0) && cc < prev_cc)
                # (c, c2) is out of order with respect to the preceding
                #  text
                dest_index += length
                trail_cc = insert_ordered(dest, reorder_start_index, reorder_split, dest_index, c, c2, cc)
              else
                # just append (c, c2)
                dest[((dest_index += 1) - 1)] = c
                if (!(c2).equal?(0))
                  dest[((dest_index += 1) - 1)] = c2
                end
              end
            else
              # general: multiple code points (ordered by themselves)
              # from decomposition
              if (!(cc).equal?(0) && cc < prev_cc)
                # the decomposition is out of order with respect to the
                #  preceding text
                dest_index += length
                trail_cc = merge_ordered(dest, reorder_start_index, reorder_split, p, p_start, p_start + length)
              else
                # just append the decomposition
                begin
                  dest[((dest_index += 1) - 1)] = p[((p_start += 1) - 1)]
                end while ((length -= 1) > 0)
              end
            end
          else
            # buffer overflow
            # keep incrementing the destIndex for preflighting
            dest_index += length
          end
          prev_cc = trail_cc
          if ((prev_cc).equal?(0))
            reorder_start_index = dest_index
          end
        end
        out_trail_cc[0] = prev_cc
        return dest_index - dest_start
      end
      
      # make NFC & NFKC ------------------------------------------------------
      const_set_lazy(:NextCombiningArgs) { Class.new do
        include_class_members NormalizerImpl
        
        attr_accessor :source
        alias_method :attr_source, :source
        undef_method :source
        alias_method :attr_source=, :source=
        undef_method :source=
        
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        # int limit;
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        attr_accessor :c2
        alias_method :attr_c2, :c2
        undef_method :c2
        alias_method :attr_c2=, :c2=
        undef_method :c2=
        
        # unsigned
        attr_accessor :combining_index
        alias_method :attr_combining_index, :combining_index
        undef_method :combining_index
        alias_method :attr_combining_index=, :combining_index=
        undef_method :combining_index=
        
        # unsigned byte
        attr_accessor :cc
        alias_method :attr_cc, :cc
        undef_method :cc
        alias_method :attr_cc=, :cc=
        undef_method :cc=
        
        typesig { [] }
        def initialize
          @source = nil
          @start = 0
          @c = 0
          @c2 = 0
          @combining_index = 0
          @cc = 0
        end
        
        private
        alias_method :initialize__next_combining_args, :initialize
      end }
      
      typesig { [NextCombiningArgs, ::Java::Int, UnicodeSet] }
      # get the composition properties of the next character
      # unsigned
      def get_next_combining(args, limit, nx)
        # unsigned
        norm32 = 0
        combine_flags = 0
        # get properties
        args.attr_c = args.attr_source[((args.attr_start += 1) - 1)]
        norm32 = get_norm32(args.attr_c)
        # preset output values for most characters
        args.attr_c2 = 0
        args.attr_combining_index = 0
        args.attr_cc = 0
        if (((norm32 & (CC_MASK | COMBINES_ANY))).equal?(0))
          return 0
        else
          if (is_norm32regular(norm32))
            # set cc etc. below
          else
            if (is_norm32hangul_or_jamo(norm32))
              # a compatibility decomposition contained Jamos
              args.attr_combining_index = (((UNSIGNED_INT_MASK) & (0xfff0 | (norm32 >> EXTRA_SHIFT)))).to_int
              return ((norm32 & COMBINES_ANY)).to_int
            else
              # c is a lead surrogate, get the real norm32
              if (!(args.attr_start).equal?(limit) && UTF16.is_trail_surrogate(args.attr_c2 = args.attr_source[args.attr_start]))
                (args.attr_start += 1)
                norm32 = get_norm32from_surrogate_pair(norm32, args.attr_c2)
              else
                args.attr_c2 = 0
                return 0
              end
            end
          end
          if (nx_contains(nx, args.attr_c, args.attr_c2))
            return 0 # excluded: norm32==0
          end
          args.attr_cc = RJava.cast_to_char(((norm32 >> CC_SHIFT) & 0xff))
          combine_flags = ((norm32 & COMBINES_ANY)).to_int
          if (!(combine_flags).equal?(0))
            index = get_extra_data_index(norm32)
            args.attr_combining_index = index > 0 ? self.attr_extra_data[(index - 1)] : 0
          end
          return combine_flags
        end
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # given a composition-result starter (c, c2) - which means its cc==0,
      # it combines forward, it has extra data, its norm32!=0,
      # it is not a Hangul or Jamo,
      # get just its combineFwdIndex
      # 
      # norm32(c) is special if and only if c2!=0
      # unsigned
      def get_combining_index_from_starter(c, c2)
        # unsigned
        norm32 = 0
        norm32 = get_norm32(c)
        if (!(c2).equal?(0))
          norm32 = get_norm32from_surrogate_pair(norm32, c2)
        end
        return self.attr_extra_data[(get_extra_data_index(norm32) - 1)]
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Int)] }
      # Find the recomposition result for
      # a forward-combining character
      # (specified with a pointer to its part of the combiningTable[])
      # and a backward-combining character
      # (specified with its combineBackIndex).
      # 
      # If these two characters combine, then set (value, value2)
      # with the code unit(s) of the composition character.
      # 
      # Return value:
      # 0    do not combine
      # 1    combine
      # >1   combine, and the composition is a forward-combining starter
      # 
      # See unormimp.h for a description of the composition table format.
      # unsigned
      def combine(table, table_start, combine_back_index, out_values)
        # unsinged
        # unsigned
        key = 0
        value = 0
        value2 = 0
        if (out_values.attr_length < 2)
          raise IllegalArgumentException.new
        end
        # search in the starter's composition table
        loop do
          key = table[((table_start += 1) - 1)]
          if (key >= combine_back_index)
            break
          end
          table_start += (!((table[table_start] & 0x8000)).equal?(0)) ? 2 : 1
        end
        # mask off bit 15, the last-entry-in-the-list flag
        if (((key & 0x7fff)).equal?(combine_back_index))
          # found! combine!
          value = table[table_start]
          # is the composition a starter that combines forward?
          key = (((UNSIGNED_INT_MASK) & ((value & 0x2000) + 1))).to_int
          # get the composition result code point from the variable-length
          # result value
          if (!((value & 0x8000)).equal?(0))
            if (!((value & 0x4000)).equal?(0))
              # surrogate pair composition result
              value = (((UNSIGNED_INT_MASK) & ((value & 0x3ff) | 0xd800))).to_int
              value2 = table[table_start + 1]
            else
              # BMP composition result U+2000..U+ffff
              value = table[table_start + 1]
              value2 = 0
            end
          else
            # BMP composition result U+0000..U+1fff
            value &= 0x1fff
            value2 = 0
          end
          out_values[0] = value
          out_values[1] = value2
          return key
        else
          # not found
          return 0
        end
      end
      
      const_set_lazy(:RecomposeArgs) { Class.new do
        include_class_members NormalizerImpl
        
        attr_accessor :source
        alias_method :attr_source, :source
        undef_method :source
        alias_method :attr_source=, :source=
        undef_method :source=
        
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        attr_accessor :limit
        alias_method :attr_limit, :limit
        undef_method :limit
        alias_method :attr_limit=, :limit=
        undef_method :limit=
        
        typesig { [] }
        def initialize
          @source = nil
          @start = 0
          @limit = 0
        end
        
        private
        alias_method :initialize__recompose_args, :initialize
      end }
      
      typesig { [RecomposeArgs, ::Java::Int, UnicodeSet] }
      # recompose the characters in [p..limit[
      # (which is in NFD - decomposed and canonically ordered),
      # adjust limit, and return the trailing cc
      # 
      # since for NFKC we may get Jamos in decompositions, we need to
      # recompose those too
      # 
      # note that recomposition never lengthens the text:
      # any character consists of either one or two code units;
      # a composition may contain at most one more code unit than the original
      # starter, while the combining mark that is removed has at least one code
      # unit
      # unsigned byte
      def recompose(args, options, nx)
        remove = 0
        q = 0
        r = 0 # unsigned
        combine_flags = 0 # unsigned
        combine_fwd_index = 0
        combine_back_index = 0 # unsigned
        result = 0
        value = 0
        value2 = 0 # unsigned byte
        prev_cc = 0
        starter_is_supplementary = false
        starter = 0
        out_values = Array.typed(::Java::Int).new(2) { 0 }
        starter = -1 # no starter
        combine_fwd_index = 0 # will not be used until starter!=NULL
        starter_is_supplementary = false # will not be used until starter!=NULL
        prev_cc = 0
        nc_arg = NextCombiningArgs.new
        nc_arg.attr_source = args.attr_source
        nc_arg.attr_cc = 0
        nc_arg.attr_c2 = 0
        loop do
          nc_arg.attr_start = args.attr_start
          combine_flags = get_next_combining(nc_arg, args.attr_limit, nx)
          combine_back_index = nc_arg.attr_combining_index
          args.attr_start = nc_arg.attr_start
          if ((!((combine_flags & COMBINES_BACK)).equal?(0)) && !(starter).equal?(-1))
            if (!((combine_back_index & 0x8000)).equal?(0))
              # c is a Jamo V/T, see if we can compose it with the
              # previous character
              # for the PRI #29 fix, check that there is no intervening combining mark
              if (!((options & BEFORE_PRI_29)).equal?(0) || (prev_cc).equal?(0))
                remove = -1 # NULL while no Hangul composition
                combine_flags = 0
                nc_arg.attr_c2 = args.attr_source[starter]
                if ((combine_back_index).equal?(0xfff2))
                  # Jamo V, compose with previous Jamo L and following
                  # Jamo T
                  nc_arg.attr_c2 = RJava.cast_to_char((nc_arg.attr_c2 - JAMO_L_BASE))
                  if (nc_arg.attr_c2 < JAMO_L_COUNT)
                    remove = args.attr_start - 1
                    nc_arg.attr_c = RJava.cast_to_char((HANGUL_BASE + (nc_arg.attr_c2 * JAMO_V_COUNT + (nc_arg.attr_c - JAMO_V_BASE)) * JAMO_T_COUNT))
                    if (!(args.attr_start).equal?(args.attr_limit) && (nc_arg.attr_c2 = RJava.cast_to_char((args.attr_source[args.attr_start] - JAMO_T_BASE))) < JAMO_T_COUNT)
                      (args.attr_start += 1)
                      nc_arg.attr_c += nc_arg.attr_c2
                    else
                      # the result is an LV syllable, which is a starter (unlike LVT)
                      combine_flags = COMBINES_FWD
                    end
                    if (!nx_contains(nx, nc_arg.attr_c))
                      args.attr_source[starter] = nc_arg.attr_c
                    else
                      # excluded
                      if (!is_hangul_without_jamo_t(nc_arg.attr_c))
                        (args.attr_start -= 1) # undo the ++args.start from reading the Jamo T
                      end
                      # c is modified but not used any more -- c=*(p-1); -- re-read the Jamo V/T
                      remove = args.attr_start
                    end
                  end
                  # Normally, the following can not occur:
                  # Since the input is in NFD, there are no Hangul LV syllables that
                  # a Jamo T could combine with.
                  # All Jamo Ts are combined above when handling Jamo Vs.
                  # 
                  # However, before the PRI #29 fix, this can occur due to
                  # an intervening combining mark between the Hangul LV and the Jamo T.
                else
                  # Jamo T, compose with previous Hangul that does not have a Jamo T
                  if (is_hangul_without_jamo_t(nc_arg.attr_c2))
                    nc_arg.attr_c2 += nc_arg.attr_c - JAMO_T_BASE
                    if (!nx_contains(nx, nc_arg.attr_c2))
                      remove = args.attr_start - 1
                      args.attr_source[starter] = nc_arg.attr_c2
                    end
                  end
                end
                if (!(remove).equal?(-1))
                  # remove the Jamo(s)
                  q = remove
                  r = args.attr_start
                  while (r < args.attr_limit)
                    args.attr_source[((q += 1) - 1)] = args.attr_source[((r += 1) - 1)]
                  end
                  args.attr_start = remove
                  args.attr_limit = q
                end
                nc_arg.attr_c2 = 0 # c2 held *starter temporarily
                if (!(combine_flags).equal?(0))
                  # not starter=NULL because the composition is a Hangul LV syllable
                  # and might combine once more (but only before the PRI #29 fix)
                  # done?
                  if ((args.attr_start).equal?(args.attr_limit))
                    return RJava.cast_to_char(prev_cc)
                  end
                  # the composition is a Hangul LV syllable which is a starter that combines forward
                  combine_fwd_index = 0xfff0
                  # we combined; continue with looking for compositions
                  next
                end
              end
              # now: cc==0 and the combining index does not include
              # "forward" -> the rest of the loop body will reset starter
              # to NULL; technically, a composed Hangul syllable is a
              # starter, but it does not combine forward now that we have
              # consumed all eligible Jamos; for Jamo V/T, combineFlags
              # does not contain _NORM_COMBINES_FWD
            else
              # the starter is not a Hangul LV or Jamo V/T and
              # the combining mark is not blocked and
              # the starter and the combining mark (c, c2) do combine
              # the composition result is not excluded
              if (!(!((combine_fwd_index & 0x8000)).equal?(0)) && (!((options & BEFORE_PRI_29)).equal?(0) ? (!(prev_cc).equal?(nc_arg.attr_cc) || (prev_cc).equal?(0)) : (prev_cc < nc_arg.attr_cc || (prev_cc).equal?(0))) && !(0).equal?((result = combine(self.attr_combining_table, combine_fwd_index, combine_back_index, out_values))) && !nx_contains(nx, RJava.cast_to_char(value), RJava.cast_to_char(value2)))
                value = out_values[0]
                value2 = out_values[1]
                # replace the starter with the composition, remove the
                # combining mark
                remove = (nc_arg.attr_c2).equal?(0) ? args.attr_start - 1 : args.attr_start - 2 # index to the combining mark
                # replace the starter with the composition
                args.attr_source[starter] = RJava.cast_to_char(value)
                if (starter_is_supplementary)
                  if (!(value2).equal?(0))
                    # both are supplementary
                    args.attr_source[starter + 1] = RJava.cast_to_char(value2)
                  else
                    # the composition is shorter than the starter,
                    # move the intermediate characters forward one
                    starter_is_supplementary = false
                    q = starter + 1
                    r = q + 1
                    while (r < remove)
                      args.attr_source[((q += 1) - 1)] = args.attr_source[((r += 1) - 1)]
                    end
                    (remove -= 1)
                  end
                else
                  if (!(value2).equal?(0))
                    # the composition is longer than the starter,
                    # move the intermediate characters back one
                    starter_is_supplementary = true
                    # temporarily increment for the loop boundary
                    (starter += 1)
                    q = remove
                    r = (remove += 1)
                    while (starter < q)
                      args.attr_source[(r -= 1)] = args.attr_source[(q -= 1)]
                    end
                    args.attr_source[starter] = RJava.cast_to_char(value2)
                    (starter -= 1) # undo the temporary increment
                    # } else { both are on the BMP, nothing more to do
                  end
                end
                # remove the combining mark by moving the following text
                # over it
                if (remove < args.attr_start)
                  q = remove
                  r = args.attr_start
                  while (r < args.attr_limit)
                    args.attr_source[((q += 1) - 1)] = args.attr_source[((r += 1) - 1)]
                  end
                  args.attr_start = remove
                  args.attr_limit = q
                end
                # keep prevCC because we removed the combining mark
                # done?
                if ((args.attr_start).equal?(args.attr_limit))
                  return RJava.cast_to_char(prev_cc)
                end
                # is the composition a starter that combines forward?
                if (result > 1)
                  combine_fwd_index = get_combining_index_from_starter(RJava.cast_to_char(value), RJava.cast_to_char(value2))
                else
                  starter = -1
                end
                # we combined; continue with looking for compositions
                next
              end
            end
          end
          # no combination this time
          prev_cc = nc_arg.attr_cc
          if ((args.attr_start).equal?(args.attr_limit))
            return RJava.cast_to_char(prev_cc)
          end
          # if (c, c2) did not combine, then check if it is a starter
          if ((nc_arg.attr_cc).equal?(0))
            # found a new starter; combineFlags==0 if (c, c2) is excluded
            if (!((combine_flags & COMBINES_FWD)).equal?(0))
              # it may combine with something, prepare for it
              if ((nc_arg.attr_c2).equal?(0))
                starter_is_supplementary = false
                starter = args.attr_start - 1
              else
                starter_is_supplementary = false
                starter = args.attr_start - 2
              end
              combine_fwd_index = combine_back_index
            else
              # it will not combine with anything
              starter = -1
            end
          else
            if (!((options & OPTIONS_COMPOSE_CONTIGUOUS)).equal?(0))
              # FCC: no discontiguous compositions; any intervening character blocks
              starter = -1
            end
          end
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Char] }
      # find the last true starter between src[start]....src[current] going
      # backwards and return its index
      def find_previous_starter(src, src_start, current, cc_or_qcmask, decomp_qcmask, min_no_maybe)
        # unsigned
        # unsigned
        norm32 = 0
        args = PrevArgs.new
        args.attr_src = src
        args.attr_start = src_start
        args.attr_current = current
        while (args.attr_start < args.attr_current)
          norm32 = get_prev_norm32(args, min_no_maybe, cc_or_qcmask | decomp_qcmask)
          if (is_true_starter(norm32, cc_or_qcmask, decomp_qcmask))
            break
          end
        end
        return args.attr_current
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Char] }
      # find the first true starter in [src..limit[ and return the
      # pointer to it
      # index
      def find_next_starter(src, start, limit, qc_mask, decomp_qcmask, min_no_maybe)
        # unsigned
        # unsigned
        p = 0 # unsigned
        norm32 = 0
        cc_or_qcmask = 0
        c = 0
        c2 = 0
        cc_or_qcmask = CC_MASK | qc_mask
        decomp_args = DecomposeArgs.new
        loop do
          if ((start).equal?(limit))
            break # end of string
          end
          c = src[start]
          if (c < min_no_maybe)
            break # catches NUL terminater, too
          end
          norm32 = get_norm32(c)
          if (((norm32 & cc_or_qcmask)).equal?(0))
            break # true starter
          end
          if (is_norm32lead_surrogate(norm32))
            # c is a lead surrogate, get the real norm32
            if (((start + 1)).equal?(limit) || !UTF16.is_trail_surrogate(c2 = (src[start + 1])))
              # unmatched first surrogate: counts as a true starter
              break
            end
            norm32 = get_norm32from_surrogate_pair(norm32, c2)
            if (((norm32 & cc_or_qcmask)).equal?(0))
              break # true starter
            end
          else
            c2 = 0
          end
          # (c, c2) is not a true starter but its decomposition may be
          if (!((norm32 & decomp_qcmask)).equal?(0))
            # (c, c2) decomposes, get everything from the variable-length
            #  extra data
            p = decompose(norm32, decomp_qcmask, decomp_args)
            # get the first character's norm32 to check if it is a true
            # starter
            if ((decomp_args.attr_cc).equal?(0) && ((get_norm32(self.attr_extra_data, p, qc_mask) & qc_mask)).equal?(0))
              break # true starter
            end
          end
          start += (c2).equal?(0) ? 1 : 2 # not a true starter, continue
        end
        return start
      end
      
      # length of decomposed part
      const_set_lazy(:ComposePartArgs) { Class.new do
        include_class_members NormalizerImpl
        
        attr_accessor :prev_cc
        alias_method :attr_prev_cc, :prev_cc
        undef_method :prev_cc
        alias_method :attr_prev_cc=, :prev_cc=
        undef_method :prev_cc=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        typesig { [] }
        def initialize
          @prev_cc = 0
          @length = 0
        end
        
        private
        alias_method :initialize__compose_part_args, :initialize
      end }
      
      typesig { [ComposePartArgs, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, UnicodeSet] }
      # decompose and recompose [prevStarter..src[
      def compose_part(args, prev_starter, src, start, limit, options, nx)
        recompose_limit = 0
        compat = (!((options & OPTIONS_COMPAT)).equal?(0))
        # decompose [prevStarter..src[
        out_trail_cc = Array.typed(::Java::Int).new(1) { 0 }
        buffer = CharArray.new((limit - prev_starter) * MAX_BUFFER_SIZE)
        loop do
          args.attr_length = decompose(src, prev_starter, (start), buffer, 0, buffer.attr_length, compat, out_trail_cc, nx)
          if (args.attr_length <= buffer.attr_length)
            break
          else
            buffer = CharArray.new(args.attr_length)
          end
        end
        # recompose the decomposition
        recompose_limit = args.attr_length
        if (args.attr_length >= 2)
          rc_args = RecomposeArgs.new
          rc_args.attr_source = buffer
          rc_args.attr_start = 0
          rc_args.attr_limit = recompose_limit
          args.attr_prev_cc = recompose(rc_args, options, nx)
          recompose_limit = rc_args.attr_limit
        end
        # return with a pointer to the recomposition and its length
        args.attr_length = recompose_limit
        return buffer
      end
      
      typesig { [::Java::Char, ::Java::Char, ::Java::Long, Array.typed(::Java::Char), Array.typed(::Java::Int), ::Java::Int, ::Java::Boolean, Array.typed(::Java::Char), ::Java::Int, UnicodeSet] }
      def compose_hangul(prev, c, norm32, src, src_index, limit, compat, dest, dest_index, nx)
        # unsigned
        start = src_index[0]
        if (is_jamo_vtnorm32jamo_v(norm32))
          # c is a Jamo V, compose with previous Jamo L and
          # following Jamo T
          prev = RJava.cast_to_char((prev - JAMO_L_BASE))
          if (prev < JAMO_L_COUNT)
            c = RJava.cast_to_char((HANGUL_BASE + (prev * JAMO_V_COUNT + (c - JAMO_V_BASE)) * JAMO_T_COUNT))
            # check if the next character is a Jamo T (normal or
            # compatibility)
            if (!(start).equal?(limit))
              next_ = 0
              t = 0
              next_ = src[start]
              if ((t = RJava.cast_to_char((next_ - JAMO_T_BASE))) < JAMO_T_COUNT)
                # normal Jamo T
                (start += 1)
                c += t
              else
                if (compat)
                  # if NFKC, then check for compatibility Jamo T
                  # (BMP only)
                  norm32 = get_norm32(next_)
                  if (is_norm32regular(norm32) && (!((norm32 & QC_NFKD)).equal?(0)))
                    p = 0 # index into extra data array
                    dc_args = DecomposeArgs.new
                    p = decompose(norm32, QC_NFKD, dc_args)
                    if ((dc_args.attr_length).equal?(1) && (t = RJava.cast_to_char((self.attr_extra_data[p] - JAMO_T_BASE))) < JAMO_T_COUNT)
                      # compatibility Jamo T
                      (start += 1)
                      c += t
                    end
                  end
                end
              end
            end
            if (nx_contains(nx, c))
              if (!is_hangul_without_jamo_t(c))
                (start -= 1) # undo ++start from reading the Jamo T
              end
              return false
            end
            dest[dest_index] = c
            src_index[0] = start
            return true
          end
        else
          if (is_hangul_without_jamo_t(prev))
            # c is a Jamo T, compose with previous Hangul LV that does not
            # contain a Jamo T
            c = RJava.cast_to_char((prev + (c - JAMO_T_BASE)))
            if (nx_contains(nx, c))
              return false
            end
            dest[dest_index] = c
            src_index[0] = start
            return true
          end
        end
        return false
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, UnicodeSet] }
      # public static int compose(char[] src, char[] dest,boolean compat, UnicodeSet nx){
      #     return compose(src,0,src.length,dest,0,dest.length,compat, nx);
      # }
      def compose(src, src_start, src_limit, dest, dest_start, dest_limit, options, nx)
        prev_src = 0
        prev_starter = 0 # unsigned
        norm32 = 0
        cc_or_qcmask = 0
        qc_mask = 0
        reorder_start_index = 0
        length = 0
        c = 0
        c2 = 0
        min_no_maybe = 0 # unsigned byte
        cc = 0
        prev_cc = 0
        io_index = Array.typed(::Java::Int).new(1) { 0 }
        dest_index = dest_start
        src_index = src_start
        if (!((options & OPTIONS_COMPAT)).equal?(0))
          min_no_maybe = RJava.cast_to_char(self.attr_indexes[INDEX_MIN_NFKC_NO_MAYBE])
          qc_mask = QC_NFKC
        else
          min_no_maybe = RJava.cast_to_char(self.attr_indexes[INDEX_MIN_NFC_NO_MAYBE])
          qc_mask = QC_NFC
        end
        # prevStarter points to the last character before the current one
        # that is a "true" starter with cc==0 and quick check "yes".
        # 
        # prevStarter will be used instead of looking for a true starter
        # while incrementally decomposing [prevStarter..prevSrc[
        # in _composePart(). Having a good prevStarter allows to just decompose
        # the entire [prevStarter..prevSrc[.
        # 
        # When _composePart() backs out from prevSrc back to prevStarter,
        # then it also backs out destIndex by the same amount.
        # Therefore, at all times, the (prevSrc-prevStarter) source units
        # must correspond 1:1 to destination units counted with destIndex,
        # except for reordering.
        # This is true for the qc "yes" characters copied in the fast loop,
        # and for pure reordering.
        # prevStarter must be set forward to src when this is not true:
        # In _composePart() and after composing a Hangul syllable.
        # 
        # This mechanism relies on the assumption that the decomposition of a
        # true starter also begins with a true starter. gennorm/store.c checks
        # for this.
        prev_starter = src_index
        cc_or_qcmask = CC_MASK | qc_mask
        # destIndex=
        reorder_start_index = 0 # ####TODO#### check this *
        prev_cc = 0
        # avoid compiler warnings
        norm32 = 0
        c = 0
        loop do
          # count code units below the minimum or with irrelevant data for
          # the quick check
          prev_src = src_index
          while (!(src_index).equal?(src_limit) && ((c = src[src_index]) < min_no_maybe || (((norm32 = get_norm32(c)) & cc_or_qcmask)).equal?(0)))
            prev_cc = 0
            (src_index += 1)
          end
          # copy these code units all at once
          if (!(src_index).equal?(prev_src))
            length = ((src_index - prev_src)).to_int
            if ((dest_index + length) <= dest_limit)
              System.arraycopy(src, prev_src, dest, dest_index, length)
            end
            dest_index += length
            reorder_start_index = dest_index
            # set prevStarter to the last character in the quick check
            # loop
            prev_starter = src_index - 1
            if (UTF16.is_trail_surrogate(src[prev_starter]) && prev_src < prev_starter && UTF16.is_lead_surrogate(src[(prev_starter - 1)]))
              (prev_starter -= 1)
            end
            prev_src = src_index
          end
          # end of source reached?
          if ((src_index).equal?(src_limit))
            break
          end
          # c already contains *src and norm32 is set for it, increment src
          (src_index += 1)
          # source buffer pointers:
          # 
          #  all done      quick check   current char  not yet
          #                "yes" but     (c, c2)       processed
          #                may combine
          #                forward
          # [-------------[-------------[-------------[-------------[
          # |             |             |             |             |
          # start         prevStarter   prevSrc       src           limit
          # 
          # 
          # destination buffer pointers and indexes:
          # 
          #  all done      might take    not filled yet
          #                characters for
          #                reordering
          # [-------------[-------------[-------------[
          # |             |             |             |
          # dest      reorderStartIndex destIndex     destCapacity
          # check one above-minimum, relevant code unit
          # norm32 is for c=*(src-1), and the quick check flag is "no" or
          # "maybe", and/or cc!=0
          # check for Jamo V/T, then for surrogates and regular characters
          # c is not a Hangul syllable or Jamo L because
          # they are not marked with no/maybe for NFC & NFKC(and their cc==0)
          if (is_norm32hangul_or_jamo(norm32))
            # c is a Jamo V/T:
            # try to compose with the previous character, Jamo V also with
            # a following Jamo T, and set values here right now in case we
            # just continue with the main loop
            prev_cc = cc = 0
            reorder_start_index = dest_index
            io_index[0] = src_index
            if (dest_index > 0 && compose_hangul(src[(prev_src - 1)], c, norm32, src, io_index, src_limit, !((options & OPTIONS_COMPAT)).equal?(0), dest, dest_index <= dest_limit ? dest_index - 1 : 0, nx))
              src_index = io_index[0]
              prev_starter = src_index
              next
            end
            src_index = io_index[0]
            # the Jamo V/T did not compose into a Hangul syllable, just
            # append to dest
            c2 = 0
            length = 1
            prev_starter = prev_src
          else
            if (is_norm32regular(norm32))
              c2 = 0
              length = 1
            else
              # c is a lead surrogate, get the real norm32
              if (!(src_index).equal?(src_limit) && UTF16.is_trail_surrogate(c2 = src[src_index]))
                (src_index += 1)
                length = 2
                norm32 = get_norm32from_surrogate_pair(norm32, c2)
              else
                # c is an unpaired lead surrogate, nothing to do
                c2 = 0
                length = 1
                norm32 = 0
              end
            end
            args = ComposePartArgs.new
            # we are looking at the character (c, c2) at [prevSrc..src[
            if (nx_contains(nx, c, c2))
              # excluded: norm32==0
              cc = 0
            else
              if (((norm32 & qc_mask)).equal?(0))
                cc = (((UNSIGNED_BYTE_MASK) & (norm32 >> CC_SHIFT))).to_int
              else
                p = nil
                # find appropriate boundaries around this character,
                # decompose the source text from between the boundaries,
                # and recompose it
                # 
                # this puts the intermediate text into the side buffer because
                # it might be longer than the recomposition end result,
                # or the destination buffer may be too short or missing
                # 
                # note that destIndex may be adjusted backwards to account
                # for source text that passed the quick check but needed to
                # take part in the recomposition
                decomp_qcmask = (qc_mask << 2) & 0xf # decomposition quick check mask
                # find the last true starter in [prevStarter..src[
                # it is either the decomposition of the current character (at prevSrc),
                # or prevStarter
                if (is_true_starter(norm32, CC_MASK | qc_mask, decomp_qcmask))
                  prev_starter = prev_src
                else
                  # adjust destIndex: back out what had been copied with qc "yes"
                  dest_index -= prev_src - prev_starter
                end
                # find the next true starter in [src..limit[
                src_index = find_next_starter(src, src_index, src_limit, qc_mask, decomp_qcmask, min_no_maybe)
                # args.prevStarter = prevStarter;
                args.attr_prev_cc = prev_cc
                # args.destIndex = destIndex;
                args.attr_length = length
                p = compose_part(args, prev_starter, src, src_index, src_limit, options, nx)
                if ((p).nil?)
                  # an error occurred (out of memory)
                  break
                end
                prev_cc = args.attr_prev_cc
                length = args.attr_length
                # append the recomposed buffer contents to the destination
                # buffer
                if ((dest_index + args.attr_length) <= dest_limit)
                  i = 0
                  while (i < args.attr_length)
                    dest[((dest_index += 1) - 1)] = p[((i += 1) - 1)]
                    (length -= 1)
                  end
                else
                  # buffer overflow
                  # keep incrementing the destIndex for preflighting
                  dest_index += length
                end
                prev_starter = src_index
                next
              end
            end
          end
          # append the single code point (c, c2) to the destination buffer
          if ((dest_index + length) <= dest_limit)
            if (!(cc).equal?(0) && cc < prev_cc)
              # (c, c2) is out of order with respect to the preceding
              # text
              reorder_split = dest_index
              dest_index += length
              prev_cc = insert_ordered(dest, reorder_start_index, reorder_split, dest_index, c, c2, cc)
            else
              # just append (c, c2)
              dest[((dest_index += 1) - 1)] = c
              if (!(c2).equal?(0))
                dest[((dest_index += 1) - 1)] = c2
              end
              prev_cc = cc
            end
          else
            # buffer overflow
            # keep incrementing the destIndex for preflighting
            dest_index += length
            prev_cc = cc
          end
        end
        return dest_index - dest_start
      end
      
      typesig { [::Java::Int] }
      def get_combining_class(c)
        norm32 = 0
        norm32 = get_norm32(c)
        return RJava.cast_to_char(((norm32 >> CC_SHIFT) & 0xff))
      end
      
      typesig { [::Java::Int] }
      def is_full_composition_exclusion(c)
        if (self.attr_is_format_version_2_1)
          aux = AuxTrieImpl.attr_aux_trie.get_code_point_value(c)
          return (!((aux & AUX_COMP_EX_MASK)).equal?(0))
        else
          return false
        end
      end
      
      typesig { [::Java::Int] }
      def is_canon_safe_start(c)
        if (self.attr_is_format_version_2_1)
          aux = AuxTrieImpl.attr_aux_trie.get_code_point_value(c)
          return (((aux & AUX_UNSAFE_MASK)).equal?(0))
        else
          return false
        end
      end
      
      typesig { [::Java::Int, NormalizerBase::Mode, ::Java::Long] }
      # Is c an NF<mode>-skippable code point? See unormimp.h.
      def is_nfskippable(c, mode, mask)
        # unsigned int
        norm32 = 0
        mask = mask & UNSIGNED_INT_MASK
        aux = 0
        # check conditions (a)..(e), see unormimp.h
        norm32 = get_norm32(c)
        if (!((norm32 & mask)).equal?(0))
          return false # fails (a)..(e), not skippable
        end
        if ((mode).equal?(NormalizerBase::NFD) || (mode).equal?(NormalizerBase::NFKD) || (mode).equal?(NormalizerBase::NONE))
          return true # NF*D, passed (a)..(c), is skippable
        end
        # check conditions (a)..(e), see unormimp.h
        # NF*C/FCC, passed (a)..(e)
        if (((norm32 & QC_NFD)).equal?(0))
          return true # no canonical decomposition, is skippable
        end
        # check Hangul syllables algorithmically
        if (is_norm32hangul_or_jamo(norm32))
          # Jamo passed (a)..(e) above, must be Hangul
          return !is_hangul_without_jamo_t(RJava.cast_to_char(c)) # LVT are skippable, LV are not
        end
        # if(mode<=UNORM_NFKC) { -- enable when implementing FCC
        # NF*C, test (f) flag
        if (!self.attr_is_format_version_2_2)
          return false # no (f) data, say not skippable to be safe
        end
        aux = AuxTrieImpl.attr_aux_trie.get_code_point_value(c)
        return ((aux & AUX_NFC_SKIP_F_MASK)).equal?(0) # TRUE=skippable if the (f) flag is not set
        # } else { FCC, test fcd<=1 instead of the above }
      end
      
      typesig { [UnicodeSet] }
      def add_property_starts(set)
        c = 0
        # add the start code point of each same-value range of each trie
        # utrie_enum(&normTrie, NULL, _enumPropertyStartsRange, set);
        norm_iter = TrieIterator.new(NormTrieImpl.attr_norm_trie)
        norm_result = RangeValueIterator::Element.new
        while (norm_iter.next_(norm_result))
          set.add(norm_result.attr_start)
        end
        # utrie_enum(&fcdTrie, NULL, _enumPropertyStartsRange, set);
        fcd_iter = TrieIterator.new(FCDTrieImpl.attr_fcd_trie)
        fcd_result = RangeValueIterator::Element.new
        while (fcd_iter.next_(fcd_result))
          set.add(fcd_result.attr_start)
        end
        if (self.attr_is_format_version_2_1)
          # utrie_enum(&auxTrie, NULL, _enumPropertyStartsRange, set);
          aux_iter = TrieIterator.new(AuxTrieImpl.attr_aux_trie)
          aux_result = RangeValueIterator::Element.new
          while (aux_iter.next_(aux_result))
            set.add(aux_result.attr_start)
          end
        end
        # add Hangul LV syllables and LV+1 because of skippables
        c = HANGUL_BASE
        while c < HANGUL_BASE + HANGUL_COUNT
          set.add(c)
          set.add(c + 1)
          c += JAMO_T_COUNT
        end
        set.add(HANGUL_BASE + HANGUL_COUNT) # add Hangul+1 to continue with other properties
        return set # for chaining
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Internal API, used in UCharacter.getIntPropertyValue().
      # @internal
      # @param c code point
      # @param modeValue numeric value compatible with Mode
      # @return numeric value compatible with QuickCheck
      def quick_check(c, mode_value)
        # UNORM_MODE_COUNT
        qc_mask = Array.typed(::Java::Int).new([0, 0, QC_NFD, QC_NFKD, QC_NFC, QC_NFKC])
        norm32 = (get_norm32(c)).to_int & qc_mask[mode_value]
        if ((norm32).equal?(0))
          return 1 # YES
        else
          if (!((norm32 & QC_ANY_NO)).equal?(0))
            return 0 # NO
          else
            # _NORM_QC_ANY_MAYBE
            return 2 # MAYBE;
          end
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean] }
      def str_compare(s1, s1start, s1limit, s2, s2start, s2limit, code_point_order)
        start1 = 0
        start2 = 0
        limit1 = 0
        limit2 = 0
        c1 = 0
        c2 = 0
        # setup for fix-up
        start1 = s1start
        start2 = s2start
        length1 = 0
        length2 = 0
        length1 = s1limit - s1start
        length2 = s2limit - s2start
        length_result = 0
        if (length1 < length2)
          length_result = -1
          limit1 = start1 + length1
        else
          if ((length1).equal?(length2))
            length_result = 0
            limit1 = start1 + length1
          else
            # length1>length2
            length_result = 1
            limit1 = start1 + length2
          end
        end
        if ((s1).equal?(s2))
          return length_result
        end
        loop do
          # check pseudo-limit
          if ((s1start).equal?(limit1))
            return length_result
          end
          c1 = s1[s1start]
          c2 = s2[s2start]
          if (!(c1).equal?(c2))
            break
          end
          (s1start += 1)
          (s2start += 1)
        end
        # setup for fix-up
        limit1 = start1 + length1
        limit2 = start2 + length2
        # if both values are in or above the surrogate range, fix them up
        if (c1 >= 0xd800 && c2 >= 0xd800 && code_point_order)
          # subtract 0x2800 from BMP code points to make them smaller than
          #  supplementary ones
          if ((c1 <= 0xdbff && !((s1start + 1)).equal?(limit1) && UTF16.is_trail_surrogate(s1[(s1start + 1)])) || (UTF16.is_trail_surrogate(c1) && !(start1).equal?(s1start) && UTF16.is_lead_surrogate(s1[(s1start - 1)])))
            # part of a surrogate pair, leave >=d800
          else
            # BMP code point - may be surrogate code point - make <d800
            c1 -= 0x2800
          end
          if ((c2 <= 0xdbff && !((s2start + 1)).equal?(limit2) && UTF16.is_trail_surrogate(s2[(s2start + 1)])) || (UTF16.is_trail_surrogate(c2) && !(start2).equal?(s2start) && UTF16.is_lead_surrogate(s2[(s2start - 1)])))
            # part of a surrogate pair, leave >=d800
          else
            # BMP code point - may be surrogate code point - make <d800
            c2 -= 0x2800
          end
        end
        # now c1 and c2 are in UTF-32-compatible order
        return (c1).to_int - (c2).to_int
      end
      
      # Status of tailored normalization
      # 
      # This was done initially for investigation on Unicode public review issue 7
      # (http://www.unicode.org/review/). See Jitterbug 2481.
      # While the UTC at meeting #94 (2003mar) did not take up the issue, this is
      # a permanent feature in ICU 2.6 in support of IDNA which requires true
      # Unicode 3.2 normalization.
      # (NormalizationCorrections are rolled into IDNA mapping tables.)
      # 
      # Tailored normalization as implemented here allows to "normalize less"
      # than full Unicode normalization would.
      # Based internally on a UnicodeSet of code points that are
      # "excluded from normalization", the normalization functions leave those
      # code points alone ("inert"). This means that tailored normalization
      # still transforms text into a canonically equivalent form.
      # It does not add decompositions to code points that do not have any or
      # change decomposition results.
      # 
      # Any function that searches for a safe boundary has not been touched,
      # which means that these functions will be over-pessimistic when
      # exclusions are applied.
      # This should not matter because subsequent checks and normalizations
      # do apply the exclusions; only a little more of the text may be processed
      # than necessary under exclusions.
      # 
      # Normalization exclusions have the following effect on excluded code points c:
      # - c is not decomposed
      # - c is not a composition target
      # - c does not combine forward or backward for composition
      #   except that this is not implemented for Jamo
      # - c is treated as having a combining class of 0
      # Constants for the bit fields in the options bit set parameter.
      # These need not be public.
      # A user only needs to know the currently assigned values.
      # The number and positions of reserved bits per field can remain private.
      const_set_lazy(:OPTIONS_NX_MASK) { 0x1f }
      const_attr_reader  :OPTIONS_NX_MASK
      
      const_set_lazy(:OPTIONS_UNICODE_MASK) { 0xe0 }
      const_attr_reader  :OPTIONS_UNICODE_MASK
      
      const_set_lazy(:OPTIONS_SETS_MASK) { 0xff }
      const_attr_reader  :OPTIONS_SETS_MASK
      
      const_set_lazy(:OPTIONS_UNICODE_SHIFT) { 5 }
      const_attr_reader  :OPTIONS_UNICODE_SHIFT
      
      const_set_lazy(:NxCache) { Array.typed(UnicodeSet).new(OPTIONS_SETS_MASK + 1) { nil } }
      const_attr_reader  :NxCache
      
      # Constants for options flags for normalization.
      # Options bit 0, do not decompose Hangul syllables.
      # @draft ICU 2.6
      const_set_lazy(:NX_HANGUL) { 1 }
      const_attr_reader  :NX_HANGUL
      
      # Options bit 1, do not decompose CJK compatibility characters.
      # @draft ICU 2.6
      const_set_lazy(:NX_CJK_COMPAT) { 2 }
      const_attr_reader  :NX_CJK_COMPAT
      
      # Options bit 8, use buggy recomposition described in
      # Unicode Public Review Issue #29
      # at http://www.unicode.org/review/resolved-pri.html#pri29
      # 
      # Used in IDNA implementation according to strict interpretation
      # of IDNA definition based on Unicode 3.2 which predates PRI #29.
      # 
      # See ICU4C unormimp.h
      # 
      # @draft ICU 3.2
      const_set_lazy(:BEFORE_PRI_29) { 0x100 }
      const_attr_reader  :BEFORE_PRI_29
      
      # The following options are used only in some composition functions.
      # They use bits 12 and up to preserve lower bits for the available options
      # space in unorm_compare() -
      # see documentation for UNORM_COMPARE_NORM_OPTIONS_SHIFT.
      # Options bit 12, for compatibility vs. canonical decomposition.
      const_set_lazy(:OPTIONS_COMPAT) { 0x1000 }
      const_attr_reader  :OPTIONS_COMPAT
      
      # Options bit 13, no discontiguous composition (FCC vs. NFC).
      const_set_lazy(:OPTIONS_COMPOSE_CONTIGUOUS) { 0x2000 }
      const_attr_reader  :OPTIONS_COMPOSE_CONTIGUOUS
      
      typesig { [] }
      # normalization exclusion sets ---------------------------------------------
      # Normalization exclusion UnicodeSets are used for tailored normalization;
      # see the comment near the beginning of this file.
      # 
      # By specifying one or several sets of code points,
      # those code points become inert for normalization.
      def internal_get_nxhangul
        synchronized(self) do
          # internal function, does not check for incoming U_FAILURE
          if ((NxCache[NX_HANGUL]).nil?)
            NxCache[NX_HANGUL] = UnicodeSet.new(0xac00, 0xd7a3)
          end
          return NxCache[NX_HANGUL]
        end
      end
      
      typesig { [] }
      def internal_get_nxcjkcompat
        synchronized(self) do
          # internal function, does not check for incoming U_FAILURE
          if ((NxCache[NX_CJK_COMPAT]).nil?)
            # build a set from [CJK Ideographs]&[has canonical decomposition]
            set = nil
            has_decomp = nil
            set = UnicodeSet.new("[:Ideographic:]")
            # start with an empty set for [has canonical decomposition]
            has_decomp = UnicodeSet.new
            # iterate over all ideographs and remember which canonically decompose
            it = UnicodeSetIterator.new(set)
            start = 0
            end_ = 0
            norm32 = 0
            while (it.next_range && (!(it.attr_codepoint).equal?(UnicodeSetIterator::IS_STRING)))
              start = it.attr_codepoint
              end_ = it.attr_codepoint_end
              while (start <= end_)
                norm32 = get_norm32(start)
                if ((norm32 & QC_NFD) > 0)
                  has_decomp.add(start)
                end
                (start += 1)
              end
            end
            # hasDecomp now contains all ideographs that decompose canonically
            NxCache[NX_CJK_COMPAT] = has_decomp
          end
          return NxCache[NX_CJK_COMPAT]
        end
      end
      
      typesig { [::Java::Int] }
      def internal_get_nxunicode(options)
        synchronized(self) do
          options &= OPTIONS_UNICODE_MASK
          if ((options).equal?(0))
            return nil
          end
          if ((NxCache[options]).nil?)
            # build a set with all code points that were not designated by the specified Unicode version
            set = UnicodeSet.new
            case (options)
            when NormalizerBase::UNICODE_3_2
              set.apply_pattern("[:^Age=3.2:]")
            else
              return nil
            end
            NxCache[options] = set
          end
          return NxCache[options]
        end
      end
      
      typesig { [::Java::Int] }
      # Get a decomposition exclusion set. The data must be loaded.
      def internal_get_nx(options)
        synchronized(self) do
          options &= OPTIONS_SETS_MASK
          if ((NxCache[options]).nil?)
            # return basic sets
            if ((options).equal?(NX_HANGUL))
              return internal_get_nxhangul
            end
            if ((options).equal?(NX_CJK_COMPAT))
              return internal_get_nxcjkcompat
            end
            if (!((options & OPTIONS_UNICODE_MASK)).equal?(0) && ((options & OPTIONS_NX_MASK)).equal?(0))
              return internal_get_nxunicode(options)
            end
            # build a set from multiple subsets
            set = nil
            other = nil
            set = UnicodeSet.new
            if (!((options & NX_HANGUL)).equal?(0) && !(nil).equal?((other = internal_get_nxhangul)))
              set.add_all(other)
            end
            if (!((options & NX_CJK_COMPAT)).equal?(0) && !(nil).equal?((other = internal_get_nxcjkcompat)))
              set.add_all(other)
            end
            if (!((options & OPTIONS_UNICODE_MASK)).equal?(0) && !(nil).equal?((other = internal_get_nxunicode(options))))
              set.add_all(other)
            end
            NxCache[options] = set
          end
          return NxCache[options]
        end
      end
      
      typesig { [::Java::Int] }
      def get_nx(options)
        if (((options &= OPTIONS_SETS_MASK)).equal?(0))
          # incoming failure, or no decomposition exclusions requested
          return nil
        else
          return internal_get_nx(options)
        end
      end
      
      typesig { [UnicodeSet, ::Java::Int] }
      def nx_contains(nx, c)
        return !(nx).nil? && nx.contains(c)
      end
      
      typesig { [UnicodeSet, ::Java::Char, ::Java::Char] }
      def nx_contains(nx, c, c2)
        return !(nx).nil? && nx.contains((c2).equal?(0) ? c : UCharacterProperty.get_raw_supplementary(c, c2))
      end
      
      typesig { [Array.typed(::Java::Int), Array.typed(String)] }
      # Get the canonical decomposition
      # sherman  for ComposedCharIter
      def get_decompose(chars, decomps)
        args = DecomposeArgs.new
        length = 0
        norm32 = 0
        ch = -1
        index = 0
        i = 0
        while ((ch += 1) < 0x2fa1e)
          # no cannoical above 0x3ffff
          # TBD !!!! the hack code heres save us about 50ms for startup
          # need a better solution/lookup
          if ((ch).equal?(0x30ff))
            ch = 0xf900
          else
            if ((ch).equal?(0x10000))
              ch = 0x1d15e
            else
              if ((ch).equal?(0x1d1c1))
                ch = 0x2f800
              end
            end
          end
          norm32 = NormalizerImpl.get_norm32(ch)
          if (!((norm32 & QC_NFD)).equal?(0) && i < chars.attr_length)
            chars[i] = ch
            index = decompose(norm32, args)
            decomps[((i += 1) - 1)] = String.new(self.attr_extra_data, index, args.attr_length)
          end
        end
        return i
      end
      
      typesig { [::Java::Char] }
      # ------------------------------------------------------
      # special method for Collation
      # ------------------------------------------------------
      def need_single_quotation(c)
        return (c >= 0x9 && c <= 0xd) || (c >= 0x20 && c <= 0x2f) || (c >= 0x3a && c <= 0x40) || (c >= 0x5b && c <= 0x60) || (c >= 0x7b && c <= 0x7e)
      end
      
      typesig { [String] }
      def canonical_decompose_with_single_quotation(string)
        src = string.to_char_array
        src_index = 0
        src_limit = src.attr_length
        dest = CharArray.new(src.attr_length * 3) # MAX_BUF_SIZE_DECOMPOSE = 3
        dest_index = 0
        dest_limit = dest.attr_length
        buffer = CharArray.new(3)
        prev_src = 0
        norm32 = 0
        cc_or_qcmask = 0
        qc_mask = QC_NFD
        reorder_start_index = 0
        length = 0
        c = 0
        c2 = 0
        min_no_maybe = RJava.cast_to_char(self.attr_indexes[INDEX_MIN_NFD_NO_MAYBE])
        cc = 0
        prev_cc = 0
        trail_cc = 0
        p = nil
        p_start = 0
        # initialize
        cc_or_qcmask = CC_MASK | qc_mask
        reorder_start_index = 0
        prev_cc = 0
        norm32 = 0
        c = 0
        p_start = 0
        cc = trail_cc = -1 # initialize to bogus value
        loop do
          prev_src = src_index
          # quick check (1)less than minNoMaybe (2)no decomp (3)hangual
          while (!(src_index).equal?(src_limit) && ((c = src[src_index]) < min_no_maybe || (((norm32 = get_norm32(c)) & cc_or_qcmask)).equal?(0) || (c >= Character.new(0xac00) && c <= Character.new(0xd7a3))))
            prev_cc = 0
            (src_index += 1)
          end
          # copy these code units all at once
          if (!(src_index).equal?(prev_src))
            length = ((src_index - prev_src)).to_int
            if ((dest_index + length) <= dest_limit)
              System.arraycopy(src, prev_src, dest, dest_index, length)
            end
            dest_index += length
            reorder_start_index = dest_index
          end
          # end of source reached?
          if ((src_index).equal?(src_limit))
            break
          end
          # c already contains *src and norm32 is set for it, increment src
          (src_index += 1)
          if (is_norm32regular(norm32))
            c2 = 0
            length = 1
          else
            # c is a lead surrogate, get the real norm32
            if (!(src_index).equal?(src_limit) && Character.is_low_surrogate(c2 = src[src_index]))
              (src_index += 1)
              length = 2
              norm32 = get_norm32from_surrogate_pair(norm32, c2)
            else
              c2 = 0
              length = 1
              norm32 = 0
            end
          end
          # get the decomposition and the lead and trail cc's
          if (((norm32 & qc_mask)).equal?(0))
            # c does not decompose
            cc = trail_cc = (((UNSIGNED_BYTE_MASK) & (norm32 >> CC_SHIFT))).to_int
            p = nil
            p_start = -1
          else
            arg = DecomposeArgs.new
            # c decomposes, get everything from the variable-length
            # extra data
            p_start = decompose(norm32, qc_mask, arg)
            p = self.attr_extra_data
            length = arg.attr_length
            cc = arg.attr_cc
            trail_cc = arg.attr_trail_cc
            if ((length).equal?(1))
              # fastpath a single code unit from decomposition
              c = p[p_start]
              c2 = 0
              p = nil
              p_start = -1
            end
          end
          if ((dest_index + length * 3) >= dest_limit)
            # 2 SingleQuotations
            # buffer overflow
            tmp_buf = CharArray.new(dest_limit * 2)
            System.arraycopy(dest, 0, tmp_buf, 0, dest_index)
            dest = tmp_buf
            dest_limit = dest.attr_length
          end
          # append the decomposition to the destination buffer, assume length>0
          reorder_split = dest_index
          if ((p).nil?)
            # fastpath: single code point
            if (need_single_quotation(c))
              # if we need single quotation, no need to consider "prevCC"
              # and it must NOT be a supplementary pair
              dest[((dest_index += 1) - 1)] = Character.new(?\'.ord)
              dest[((dest_index += 1) - 1)] = c
              dest[((dest_index += 1) - 1)] = Character.new(?\'.ord)
              trail_cc = 0
            else
              if (!(cc).equal?(0) && cc < prev_cc)
                # (c, c2) is out of order with respect to the preceding
                #  text
                dest_index += length
                trail_cc = insert_ordered(dest, reorder_start_index, reorder_split, dest_index, c, c2, cc)
              else
                # just append (c, c2)
                dest[((dest_index += 1) - 1)] = c
                if (!(c2).equal?(0))
                  dest[((dest_index += 1) - 1)] = c2
                end
              end
            end
          else
            # general: multiple code points (ordered by themselves)
            # from decomposition
            if (need_single_quotation(p[p_start]))
              dest[((dest_index += 1) - 1)] = Character.new(?\'.ord)
              dest[((dest_index += 1) - 1)] = p[((p_start += 1) - 1)]
              dest[((dest_index += 1) - 1)] = Character.new(?\'.ord)
              length -= 1
              begin
                dest[((dest_index += 1) - 1)] = p[((p_start += 1) - 1)]
              end while ((length -= 1) > 0)
            else
              if (!(cc).equal?(0) && cc < prev_cc)
                dest_index += length
                trail_cc = merge_ordered(dest, reorder_start_index, reorder_split, p, p_start, p_start + length)
              else
                # just append the decomposition
                begin
                  dest[((dest_index += 1) - 1)] = p[((p_start += 1) - 1)]
                end while ((length -= 1) > 0)
              end
            end
          end
          prev_cc = trail_cc
          if ((prev_cc).equal?(0))
            reorder_start_index = dest_index
          end
        end
        return String.new(dest, 0, dest_index)
      end
      
      # ------------------------------------------------------
      # mapping method for IDNA/StringPrep
      # ------------------------------------------------------
      # Normalization using NormalizerBase.UNICODE_3_2 option supports Unicode
      # 3.2 normalization with Corrigendum 4 corrections. However, normalization
      # without the corrections is necessary for IDNA/StringPrep support.
      # This method is called when NormalizerBase.UNICODE_3_2_0_ORIGINAL option
      # (= sun.text.Normalizer.UNICODE_3_2) is used and normalizes five
      # characters in Corrigendum 4 before normalization in order to avoid
      # incorrect normalization.
      # For the Corrigendum 4 issue, refer
      #   http://www.unicode.org/versions/corrigendum4.html
      # Option used in NormalizerBase.UNICODE_3_2_0_ORIGINAL.
      const_set_lazy(:WITHOUT_CORRIGENDUM4_CORRECTIONS) { 0x40000 }
      const_attr_reader  :WITHOUT_CORRIGENDUM4_CORRECTIONS
      
      # 0x2F868
      # 0x2F874
      # 0x2F91F
      # 0x2F95F
      const_set_lazy(:Corrigendum4MappingTable) { Array.typed(Array.typed(::Java::Char)).new([Array.typed(::Java::Char).new([Character.new(0xD844), Character.new(0xDF6A)]), Array.typed(::Java::Char).new([Character.new(0x5F33)]), Array.typed(::Java::Char).new([Character.new(0x43AB)]), Array.typed(::Java::Char).new([Character.new(0x7AAE)]), Array.typed(::Java::Char).new([Character.new(0x4D57)])]) }
      const_attr_reader  :Corrigendum4MappingTable
      
      typesig { [String] }
      # 0x2F9BF
      # Removing Corrigendum 4 fix
      # @return normalized text
      def convert(str)
        if ((str).nil?)
          return nil
        end
        ch = UCharacterIterator::DONE
        dest = StringBuffer.new
        iter = UCharacterIterator.get_instance(str)
        while (!((ch = iter.next_code_point)).equal?(UCharacterIterator::DONE))
          case (ch)
          when 0x2f868
            dest.append(Corrigendum4MappingTable[0])
          when 0x2f874
            dest.append(Corrigendum4MappingTable[1])
          when 0x2f91f
            dest.append(Corrigendum4MappingTable[2])
          when 0x2f95f
            dest.append(Corrigendum4MappingTable[3])
          when 0x2f9bf
            dest.append(Corrigendum4MappingTable[4])
          else
            UTF16.append(dest, ch)
          end
        end
        return dest.to_s
      end
    }
    
    private
    alias_method :initialize__normalizer_impl, :initialize
  end
  
end
