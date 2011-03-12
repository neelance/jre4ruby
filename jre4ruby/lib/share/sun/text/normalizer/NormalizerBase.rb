require "rjava"

# Portions Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NormalizerBaseImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Text, :CharacterIterator
      include_const ::Java::Text, :Normalizer
    }
  end
  
  # Unicode Normalization
  # 
  # <h2>Unicode normalization API</h2>
  # 
  # <code>normalize</code> transforms Unicode text into an equivalent composed or
  # decomposed form, allowing for easier sorting and searching of text.
  # <code>normalize</code> supports the standard normalization forms described in
  # <a href="http://www.unicode.org/unicode/reports/tr15/" target="unicode">
  # Unicode Standard Annex #15 &mdash; Unicode Normalization Forms</a>.
  # 
  # Characters with accents or other adornments can be encoded in
  # several different ways in Unicode.  For example, take the character A-acute.
  # In Unicode, this can be encoded as a single character (the
  # "composed" form):
  # 
  # <p>
  #      00C1    LATIN CAPITAL LETTER A WITH ACUTE
  # </p>
  # 
  # or as two separate characters (the "decomposed" form):
  # 
  # <p>
  #      0041    LATIN CAPITAL LETTER A
  #      0301    COMBINING ACUTE ACCENT
  # </p>
  # 
  # To a user of your program, however, both of these sequences should be
  # treated as the same "user-level" character "A with acute accent".  When you
  # are searching or comparing text, you must ensure that these two sequences are
  # treated equivalently.  In addition, you must handle characters with more than
  # one accent.  Sometimes the order of a character's combining accents is
  # significant, while in other cases accent sequences in different orders are
  # really equivalent.
  # 
  # Similarly, the string "ffi" can be encoded as three separate letters:
  # 
  # <p>
  #      0066    LATIN SMALL LETTER F
  #      0066    LATIN SMALL LETTER F
  #      0069    LATIN SMALL LETTER I
  # </p>
  # 
  # or as the single character
  # 
  # <p>
  #      FB03    LATIN SMALL LIGATURE FFI
  # </p>
  # 
  # The ffi ligature is not a distinct semantic character, and strictly speaking
  # it shouldn't be in Unicode at all, but it was included for compatibility
  # with existing character sets that already provided it.  The Unicode standard
  # identifies such characters by giving them "compatibility" decompositions
  # into the corresponding semantic characters.  When sorting and searching, you
  # will often want to use these mappings.
  # 
  # <code>normalize</code> helps solve these problems by transforming text into
  # the canonical composed and decomposed forms as shown in the first example
  # above. In addition, you can have it perform compatibility decompositions so
  # that you can treat compatibility characters the same as their equivalents.
  # Finally, <code>normalize</code> rearranges accents into the proper canonical
  # order, so that you do not have to worry about accent rearrangement on your
  # own.
  # 
  # Form FCD, "Fast C or D", is also designed for collation.
  # It allows to work on strings that are not necessarily normalized
  # with an algorithm (like in collation) that works under "canonical closure",
  # i.e., it treats precomposed characters and their decomposed equivalents the
  # same.
  # 
  # It is not a normalization form because it does not provide for uniqueness of
  # representation. Multiple strings may be canonically equivalent (their NFDs
  # are identical) and may all conform to FCD without being identical themselves.
  # 
  # The form is defined such that the "raw decomposition", the recursive
  # canonical decomposition of each character, results in a string that is
  # canonically ordered. This means that precomposed characters are allowed for
  # as long as their decompositions do not need canonical reordering.
  # 
  # Its advantage for a process like collation is that all NFD and most NFC texts
  # - and many unnormalized texts - already conform to FCD and do not need to be
  # normalized (NFD) for such a process. The FCD quick check will return YES for
  # most strings in practice.
  # 
  # normalize(FCD) may be implemented with NFD.
  # 
  # For more details on FCD see the collation design document:
  # http://oss.software.ibm.com/cvs/icu/~checkout~/icuhtml/design/collation/ICU_collation_design.htm
  # 
  # ICU collation performs either NFD or FCD normalization automatically if
  # normalization is turned on for the collator object. Beyond collation and
  # string search, normalized strings may be useful for string equivalence
  # comparisons, transliteration/transcription, unique representations, etc.
  # 
  # The W3C generally recommends to exchange texts in NFC.
  # Note also that most legacy character encodings use only precomposed forms and
  # often do not encode any combining marks by themselves. For conversion to such
  # character encodings the Unicode text needs to be normalized to NFC.
  # For more usage examples, see the Unicode Standard Annex.
  # @stable ICU 2.8
  class NormalizerBase 
    include_class_members NormalizerBaseImports
    include Cloneable
    
    # -------------------------------------------------------------------------
    # Private data
    # -------------------------------------------------------------------------
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    attr_accessor :buffer_start
    alias_method :attr_buffer_start, :buffer_start
    undef_method :buffer_start
    alias_method :attr_buffer_start=, :buffer_start=
    undef_method :buffer_start=
    
    attr_accessor :buffer_pos
    alias_method :attr_buffer_pos, :buffer_pos
    undef_method :buffer_pos
    alias_method :attr_buffer_pos=, :buffer_pos=
    undef_method :buffer_pos=
    
    attr_accessor :buffer_limit
    alias_method :attr_buffer_limit, :buffer_limit
    undef_method :buffer_limit
    alias_method :attr_buffer_limit=, :buffer_limit=
    undef_method :buffer_limit=
    
    # The input text and our position in it
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :mode
    alias_method :attr_mode, :mode
    undef_method :mode
    alias_method :attr_mode=, :mode=
    undef_method :mode=
    
    attr_accessor :options
    alias_method :attr_options, :options
    undef_method :options
    alias_method :attr_options=, :options=
    undef_method :options=
    
    attr_accessor :current_index
    alias_method :attr_current_index, :current_index
    undef_method :current_index
    alias_method :attr_current_index=, :current_index=
    undef_method :current_index=
    
    attr_accessor :next_index
    alias_method :attr_next_index, :next_index
    undef_method :next_index
    alias_method :attr_next_index=, :next_index=
    undef_method :next_index=
    
    class_module.module_eval {
      # Options bit set value to select Unicode 3.2 normalization
      # (except NormalizationCorrections).
      # At most one Unicode version can be selected at a time.
      # @stable ICU 2.6
      const_set_lazy(:UNICODE_3_2) { 0x20 }
      const_attr_reader  :UNICODE_3_2
      
      # Constant indicating that the end of the iteration has been reached.
      # This is guaranteed to have the same value as {@link UCharacterIterator#DONE}.
      # @stable ICU 2.8
      const_set_lazy(:DONE) { UCharacterIterator::DONE }
      const_attr_reader  :DONE
      
      # Constants for normalization modes.
      # @stable ICU 2.8
      const_set_lazy(:Mode) { Class.new do
        include_class_members NormalizerBase
        
        attr_accessor :mode_value
        alias_method :attr_mode_value, :mode_value
        undef_method :mode_value
        alias_method :attr_mode_value=, :mode_value=
        undef_method :mode_value=
        
        typesig { [::Java::Int] }
        def initialize(value)
          @mode_value = 0
          @mode_value = value
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, class_self::UnicodeSet] }
        # This method is used for method dispatch
        # @stable ICU 2.6
        def normalize(src, src_start, src_limit, dest, dest_start, dest_limit, nx)
          src_len = (src_limit - src_start)
          dest_len = (dest_limit - dest_start)
          if (src_len > dest_len)
            return src_len
          end
          System.arraycopy(src, src_start, dest, dest_start, src_len)
          return src_len
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int] }
        # This method is used for method dispatch
        # @stable ICU 2.6
        def normalize(src, src_start, src_limit, dest, dest_start, dest_limit, options)
          return normalize(src, src_start, src_limit, dest, dest_start, dest_limit, NormalizerImpl.get_nx(options))
        end
        
        typesig { [String, ::Java::Int] }
        # This method is used for method dispatch
        # @stable ICU 2.6
        def normalize(src, options)
          return src
        end
        
        typesig { [] }
        # This method is used for method dispatch
        # @stable ICU 2.8
        def get_min_c
          return -1
        end
        
        typesig { [] }
        # This method is used for method dispatch
        # @stable ICU 2.8
        def get_mask
          return -1
        end
        
        typesig { [] }
        # This method is used for method dispatch
        # @stable ICU 2.8
        def get_prev_boundary
          return nil
        end
        
        typesig { [] }
        # This method is used for method dispatch
        # @stable ICU 2.8
        def get_next_boundary
          return nil
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean, class_self::UnicodeSet] }
        # This method is used for method dispatch
        # @stable ICU 2.6
        def quick_check(src, start, limit, allow_maybe, nx)
          if (allow_maybe)
            return MAYBE
          end
          return NO
        end
        
        typesig { [::Java::Int] }
        # This method is used for method dispatch
        # @stable ICU 2.8
        def is_nfskippable(c)
          return true
        end
        
        private
        alias_method :initialize__mode, :initialize
      end }
      
      # No decomposition/composition.
      # @stable ICU 2.8
      const_set_lazy(:NONE) { Mode.new(1) }
      const_attr_reader  :NONE
      
      # Canonical decomposition.
      # @stable ICU 2.8
      const_set_lazy(:NFD) { NFDMode.new(2) }
      const_attr_reader  :NFD
      
      const_set_lazy(:NFDMode) { Class.new(Mode) do
        include_class_members NormalizerBase
        
        typesig { [::Java::Int] }
        def initialize(value)
          super(value)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, class_self::UnicodeSet] }
        def normalize(src, src_start, src_limit, dest, dest_start, dest_limit, nx)
          trail_cc = Array.typed(::Java::Int).new(1) { 0 }
          return NormalizerImpl.decompose(src, src_start, src_limit, dest, dest_start, dest_limit, false, trail_cc, nx)
        end
        
        typesig { [String, ::Java::Int] }
        def normalize(src, options)
          return decompose(src, false, options)
        end
        
        typesig { [] }
        def get_min_c
          return NormalizerImpl::MIN_WITH_LEAD_CC
        end
        
        typesig { [] }
        def get_prev_boundary
          return self.class::IsPrevNFDSafe.new
        end
        
        typesig { [] }
        def get_next_boundary
          return self.class::IsNextNFDSafe.new
        end
        
        typesig { [] }
        def get_mask
          return (NormalizerImpl::CC_MASK | NormalizerImpl::QC_NFD)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean, class_self::UnicodeSet] }
        def quick_check(src, start, limit, allow_maybe, nx)
          return NormalizerImpl.quick_check(src, start, limit, NormalizerImpl.get_from_indexes_arr(NormalizerImpl::INDEX_MIN_NFD_NO_MAYBE), NormalizerImpl::QC_NFD, 0, allow_maybe, nx)
        end
        
        typesig { [::Java::Int] }
        def is_nfskippable(c)
          return NormalizerImpl.is_nfskippable(c, self, (NormalizerImpl::CC_MASK | NormalizerImpl::QC_NFD))
        end
        
        private
        alias_method :initialize__nfdmode, :initialize
      end }
      
      # Compatibility decomposition.
      # @stable ICU 2.8
      const_set_lazy(:NFKD) { NFKDMode.new(3) }
      const_attr_reader  :NFKD
      
      const_set_lazy(:NFKDMode) { Class.new(Mode) do
        include_class_members NormalizerBase
        
        typesig { [::Java::Int] }
        def initialize(value)
          super(value)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, class_self::UnicodeSet] }
        def normalize(src, src_start, src_limit, dest, dest_start, dest_limit, nx)
          trail_cc = Array.typed(::Java::Int).new(1) { 0 }
          return NormalizerImpl.decompose(src, src_start, src_limit, dest, dest_start, dest_limit, true, trail_cc, nx)
        end
        
        typesig { [String, ::Java::Int] }
        def normalize(src, options)
          return decompose(src, true, options)
        end
        
        typesig { [] }
        def get_min_c
          return NormalizerImpl::MIN_WITH_LEAD_CC
        end
        
        typesig { [] }
        def get_prev_boundary
          return self.class::IsPrevNFDSafe.new
        end
        
        typesig { [] }
        def get_next_boundary
          return self.class::IsNextNFDSafe.new
        end
        
        typesig { [] }
        def get_mask
          return (NormalizerImpl::CC_MASK | NormalizerImpl::QC_NFKD)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean, class_self::UnicodeSet] }
        def quick_check(src, start, limit, allow_maybe, nx)
          return NormalizerImpl.quick_check(src, start, limit, NormalizerImpl.get_from_indexes_arr(NormalizerImpl::INDEX_MIN_NFKD_NO_MAYBE), NormalizerImpl::QC_NFKD, NormalizerImpl::OPTIONS_COMPAT, allow_maybe, nx)
        end
        
        typesig { [::Java::Int] }
        def is_nfskippable(c)
          return NormalizerImpl.is_nfskippable(c, self, (NormalizerImpl::CC_MASK | NormalizerImpl::QC_NFKD))
        end
        
        private
        alias_method :initialize__nfkdmode, :initialize
      end }
      
      # Canonical decomposition followed by canonical composition.
      # @stable ICU 2.8
      const_set_lazy(:NFC) { NFCMode.new(4) }
      const_attr_reader  :NFC
      
      const_set_lazy(:NFCMode) { Class.new(Mode) do
        include_class_members NormalizerBase
        
        typesig { [::Java::Int] }
        def initialize(value)
          super(value)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, class_self::UnicodeSet] }
        def normalize(src, src_start, src_limit, dest, dest_start, dest_limit, nx)
          return NormalizerImpl.compose(src, src_start, src_limit, dest, dest_start, dest_limit, 0, nx)
        end
        
        typesig { [String, ::Java::Int] }
        def normalize(src, options)
          return compose(src, false, options)
        end
        
        typesig { [] }
        def get_min_c
          return NormalizerImpl.get_from_indexes_arr(NormalizerImpl::INDEX_MIN_NFC_NO_MAYBE)
        end
        
        typesig { [] }
        def get_prev_boundary
          return self.class::IsPrevTrueStarter.new
        end
        
        typesig { [] }
        def get_next_boundary
          return self.class::IsNextTrueStarter.new
        end
        
        typesig { [] }
        def get_mask
          return (NormalizerImpl::CC_MASK | NormalizerImpl::QC_NFC)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean, class_self::UnicodeSet] }
        def quick_check(src, start, limit, allow_maybe, nx)
          return NormalizerImpl.quick_check(src, start, limit, NormalizerImpl.get_from_indexes_arr(NormalizerImpl::INDEX_MIN_NFC_NO_MAYBE), NormalizerImpl::QC_NFC, 0, allow_maybe, nx)
        end
        
        typesig { [::Java::Int] }
        def is_nfskippable(c)
          return NormalizerImpl.is_nfskippable(c, self, (NormalizerImpl::CC_MASK | NormalizerImpl::COMBINES_ANY | (NormalizerImpl::QC_NFC & NormalizerImpl::QC_ANY_NO)))
        end
        
        private
        alias_method :initialize__nfcmode, :initialize
      end }
      
      # Compatibility decomposition followed by canonical composition.
      # @stable ICU 2.8
      const_set_lazy(:NFKC) { NFKCMode.new(5) }
      const_attr_reader  :NFKC
      
      const_set_lazy(:NFKCMode) { Class.new(Mode) do
        include_class_members NormalizerBase
        
        typesig { [::Java::Int] }
        def initialize(value)
          super(value)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, class_self::UnicodeSet] }
        def normalize(src, src_start, src_limit, dest, dest_start, dest_limit, nx)
          return NormalizerImpl.compose(src, src_start, src_limit, dest, dest_start, dest_limit, NormalizerImpl::OPTIONS_COMPAT, nx)
        end
        
        typesig { [String, ::Java::Int] }
        def normalize(src, options)
          return compose(src, true, options)
        end
        
        typesig { [] }
        def get_min_c
          return NormalizerImpl.get_from_indexes_arr(NormalizerImpl::INDEX_MIN_NFKC_NO_MAYBE)
        end
        
        typesig { [] }
        def get_prev_boundary
          return self.class::IsPrevTrueStarter.new
        end
        
        typesig { [] }
        def get_next_boundary
          return self.class::IsNextTrueStarter.new
        end
        
        typesig { [] }
        def get_mask
          return (NormalizerImpl::CC_MASK | NormalizerImpl::QC_NFKC)
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Boolean, class_self::UnicodeSet] }
        def quick_check(src, start, limit, allow_maybe, nx)
          return NormalizerImpl.quick_check(src, start, limit, NormalizerImpl.get_from_indexes_arr(NormalizerImpl::INDEX_MIN_NFKC_NO_MAYBE), NormalizerImpl::QC_NFKC, NormalizerImpl::OPTIONS_COMPAT, allow_maybe, nx)
        end
        
        typesig { [::Java::Int] }
        def is_nfskippable(c)
          return NormalizerImpl.is_nfskippable(c, self, (NormalizerImpl::CC_MASK | NormalizerImpl::COMBINES_ANY | (NormalizerImpl::QC_NFKC & NormalizerImpl::QC_ANY_NO)))
        end
        
        private
        alias_method :initialize__nfkcmode, :initialize
      end }
      
      # Result values for quickCheck().
      # For details see Unicode Technical Report 15.
      # @stable ICU 2.8
      const_set_lazy(:QuickCheckResult) { Class.new do
        include_class_members NormalizerBase
        
        attr_accessor :result_value
        alias_method :attr_result_value, :result_value
        undef_method :result_value
        alias_method :attr_result_value=, :result_value=
        undef_method :result_value=
        
        typesig { [::Java::Int] }
        def initialize(value)
          @result_value = 0
          @result_value = value
        end
        
        private
        alias_method :initialize__quick_check_result, :initialize
      end }
      
      # Indicates that string is not in the normalized format
      # @stable ICU 2.8
      const_set_lazy(:NO) { QuickCheckResult.new(0) }
      const_attr_reader  :NO
      
      # Indicates that string is in the normalized format
      # @stable ICU 2.8
      const_set_lazy(:YES) { QuickCheckResult.new(1) }
      const_attr_reader  :YES
      
      # Indicates it cannot be determined if string is in the normalized
      # format without further thorough checks.
      # @stable ICU 2.8
      const_set_lazy(:MAYBE) { QuickCheckResult.new(2) }
      const_attr_reader  :MAYBE
    }
    
    typesig { [String, Mode, ::Java::Int] }
    # -------------------------------------------------------------------------
    # Constructors
    # -------------------------------------------------------------------------
    # Creates a new <tt>Normalizer</tt> object for iterating over the
    # normalized form of a given string.
    # <p>
    # The <tt>options</tt> parameter specifies which optional
    # <tt>Normalizer</tt> features are to be enabled for this object.
    # <p>
    # @param str  The string to be normalized.  The normalization
    #              will start at the beginning of the string.
    # 
    # @param mode The normalization mode.
    # 
    # @param opt Any optional features to be enabled.
    #            Currently the only available option is {@link #UNICODE_3_2}.
    #            If you want the default behavior corresponding to one of the
    #            standard Unicode Normalization Forms, use 0 for this argument.
    # @stable ICU 2.6
    def initialize(str, mode, opt)
      @buffer = CharArray.new(100)
      @buffer_start = 0
      @buffer_pos = 0
      @buffer_limit = 0
      @text = nil
      @mode = NFC
      @options = 0
      @current_index = 0
      @next_index = 0
      @text = UCharacterIterator.get_instance(str)
      @mode = mode
      @options = opt
    end
    
    typesig { [CharacterIterator, Mode] }
    # Creates a new <tt>Normalizer</tt> object for iterating over the
    # normalized form of the given text.
    # <p>
    # @param iter  The input text to be normalized.  The normalization
    #              will start at the beginning of the string.
    # 
    # @param mode  The normalization mode.
    def initialize(iter, mode)
      initialize__normalizer_base(iter, mode, UNICODE_LATEST)
    end
    
    typesig { [CharacterIterator, Mode, ::Java::Int] }
    # Creates a new <tt>Normalizer</tt> object for iterating over the
    # normalized form of the given text.
    # <p>
    # @param iter  The input text to be normalized.  The normalization
    #              will start at the beginning of the string.
    # 
    # @param mode  The normalization mode.
    # 
    # @param opt Any optional features to be enabled.
    #            Currently the only available option is {@link #UNICODE_3_2}.
    #            If you want the default behavior corresponding to one of the
    #            standard Unicode Normalization Forms, use 0 for this argument.
    # @stable ICU 2.6
    def initialize(iter, mode, opt)
      @buffer = CharArray.new(100)
      @buffer_start = 0
      @buffer_pos = 0
      @buffer_limit = 0
      @text = nil
      @mode = NFC
      @options = 0
      @current_index = 0
      @next_index = 0
      @text = UCharacterIterator.get_instance(iter.clone)
      @mode = mode
      @options = opt
    end
    
    typesig { [] }
    # Clones this <tt>Normalizer</tt> object.  All properties of this
    # object are duplicated in the new object, including the cloning of any
    # {@link CharacterIterator} that was passed in to the constructor
    # or to {@link #setText(CharacterIterator) setText}.
    # However, the text storage underlying
    # the <tt>CharacterIterator</tt> is not duplicated unless the
    # iterator's <tt>clone</tt> method does so.
    # @stable ICU 2.8
    def clone
      begin
        copy = super
        copy.attr_text = @text.clone
        # clone the internal buffer
        if (!(@buffer).nil?)
          copy.attr_buffer = CharArray.new(@buffer.attr_length)
          System.arraycopy(@buffer, 0, copy.attr_buffer, 0, @buffer.attr_length)
        end
        return copy
      rescue CloneNotSupportedException => e
        raise InternalError.new(e.to_s)
      end
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Boolean, ::Java::Int] }
      # --------------------------------------------------------------------------
      # Static Utility methods
      # --------------------------------------------------------------------------
      # Compose a string.
      # The string will be composed to according the the specified mode.
      # @param str        The string to compose.
      # @param compat     If true the string will be composed accoding to
      #                    NFKC rules and if false will be composed according to
      #                    NFC rules.
      # @param options    The only recognized option is UNICODE_3_2
      # @return String    The composed string
      # @stable ICU 2.6
      def compose(str, compat, options)
        dest = nil
        src = nil
        if ((options).equal?(UNICODE_3_2_0_ORIGINAL))
          mapped_str = NormalizerImpl.convert(str)
          dest = CharArray.new(mapped_str.length * MAX_BUF_SIZE_COMPOSE)
          src = mapped_str.to_char_array
        else
          dest = CharArray.new(str.length * MAX_BUF_SIZE_COMPOSE)
          src = str.to_char_array
        end
        dest_size = 0
        nx = NormalizerImpl.get_nx(options)
        # reset options bits that should only be set here or inside compose()
        options &= ~(NormalizerImpl::OPTIONS_SETS_MASK | NormalizerImpl::OPTIONS_COMPAT | NormalizerImpl::OPTIONS_COMPOSE_CONTIGUOUS)
        if (compat)
          options |= NormalizerImpl::OPTIONS_COMPAT
        end
        loop do
          dest_size = NormalizerImpl.compose(src, 0, src.attr_length, dest, 0, dest.attr_length, options, nx)
          if (dest_size <= dest.attr_length)
            return String.new(dest, 0, dest_size)
          else
            dest = CharArray.new(dest_size)
          end
        end
      end
      
      const_set_lazy(:MAX_BUF_SIZE_COMPOSE) { 2 }
      const_attr_reader  :MAX_BUF_SIZE_COMPOSE
      
      const_set_lazy(:MAX_BUF_SIZE_DECOMPOSE) { 3 }
      const_attr_reader  :MAX_BUF_SIZE_DECOMPOSE
      
      typesig { [String, ::Java::Boolean] }
      # Decompose a string.
      # The string will be decomposed to according the the specified mode.
      # @param str       The string to decompose.
      # @param compat    If true the string will be decomposed accoding to NFKD
      #                   rules and if false will be decomposed according to NFD
      #                   rules.
      # @return String   The decomposed string
      # @stable ICU 2.8
      def decompose(str, compat)
        return decompose(str, compat, UNICODE_LATEST)
      end
      
      typesig { [String, ::Java::Boolean, ::Java::Int] }
      # Decompose a string.
      # The string will be decomposed to according the the specified mode.
      # @param str     The string to decompose.
      # @param compat  If true the string will be decomposed accoding to NFKD
      #                 rules and if false will be decomposed according to NFD
      #                 rules.
      # @param options The normalization options, ORed together (0 for no options).
      # @return String The decomposed string
      # @stable ICU 2.6
      def decompose(str, compat, options)
        trail_cc = Array.typed(::Java::Int).new(1) { 0 }
        dest_size = 0
        nx = NormalizerImpl.get_nx(options)
        dest = nil
        if ((options).equal?(UNICODE_3_2_0_ORIGINAL))
          mapped_str = NormalizerImpl.convert(str)
          dest = CharArray.new(mapped_str.length * MAX_BUF_SIZE_DECOMPOSE)
          loop do
            dest_size = NormalizerImpl.decompose(mapped_str.to_char_array, 0, mapped_str.length, dest, 0, dest.attr_length, compat, trail_cc, nx)
            if (dest_size <= dest.attr_length)
              return String.new(dest, 0, dest_size)
            else
              dest = CharArray.new(dest_size)
            end
          end
        else
          dest = CharArray.new(str.length * MAX_BUF_SIZE_DECOMPOSE)
          loop do
            dest_size = NormalizerImpl.decompose(str.to_char_array, 0, str.length, dest, 0, dest.attr_length, compat, trail_cc, nx)
            if (dest_size <= dest.attr_length)
              return String.new(dest, 0, dest_size)
            else
              dest = CharArray.new(dest_size)
            end
          end
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Mode, ::Java::Int] }
      # Normalize a string.
      # The string will be normalized according the the specified normalization
      # mode and options.
      # @param src       The char array to compose.
      # @param srcStart  Start index of the source
      # @param srcLimit  Limit index of the source
      # @param dest      The char buffer to fill in
      # @param destStart Start index of the destination buffer
      # @param destLimit End index of the destination buffer
      # @param mode      The normalization mode; one of Normalizer.NONE,
      #                   Normalizer.NFD, Normalizer.NFC, Normalizer.NFKC,
      #                   Normalizer.NFKD, Normalizer.DEFAULT
      # @param options The normalization options, ORed together (0 for no options).
      # @return int      The total buffer size needed;if greater than length of
      #                   result, the output was truncated.
      # @exception       IndexOutOfBoundsException if the target capacity is
      #                   less than the required length
      # @stable ICU 2.6
      def normalize(src, src_start, src_limit, dest, dest_start, dest_limit, mode, options)
        length_ = mode.normalize(src, src_start, src_limit, dest, dest_start, dest_limit, options)
        if (length_ <= (dest_limit - dest_start))
          return length_
        else
          raise IndexOutOfBoundsException.new(JavaInteger.to_s(length_))
        end
      end
    }
    
    typesig { [] }
    # -------------------------------------------------------------------------
    # Iteration API
    # -------------------------------------------------------------------------
    # Return the current character in the normalized text->
    # @return The codepoint as an int
    # @stable ICU 2.8
    def current
      if (@buffer_pos < @buffer_limit || next_normalize)
        return get_code_point_at(@buffer_pos)
      else
        return DONE
      end
    end
    
    typesig { [] }
    # Return the next character in the normalized text and advance
    # the iteration position by one.  If the end
    # of the text has already been reached, {@link #DONE} is returned.
    # @return The codepoint as an int
    # @stable ICU 2.8
    def next_
      if (@buffer_pos < @buffer_limit || next_normalize)
        c = get_code_point_at(@buffer_pos)
        @buffer_pos += (c > 0xffff) ? 2 : 1
        return c
      else
        return DONE
      end
    end
    
    typesig { [] }
    # Return the previous character in the normalized text and decrement
    # the iteration position by one.  If the beginning
    # of the text has already been reached, {@link #DONE} is returned.
    # @return The codepoint as an int
    # @stable ICU 2.8
    def previous
      if (@buffer_pos > 0 || previous_normalize)
        c = get_code_point_at(@buffer_pos - 1)
        @buffer_pos -= (c > 0xffff) ? 2 : 1
        return c
      else
        return DONE
      end
    end
    
    typesig { [] }
    # Reset the index to the beginning of the text.
    # This is equivalent to setIndexOnly(startIndex)).
    # @stable ICU 2.8
    def reset
      @text.set_index(0)
      @current_index = @next_index = 0
      clear_buffer
    end
    
    typesig { [::Java::Int] }
    # Set the iteration position in the input text that is being normalized,
    # without any immediate normalization.
    # After setIndexOnly(), getIndex() will return the same index that is
    # specified here.
    # 
    # @param index the desired index in the input text.
    # @stable ICU 2.8
    def set_index_only(index)
      @text.set_index(index)
      @current_index = @next_index = index # validates index
      clear_buffer
    end
    
    typesig { [::Java::Int] }
    # Set the iteration position in the input text that is being normalized
    # and return the first normalized character at that position.
    # <p>
    # <b>Note:</b> This method sets the position in the <em>input</em> text,
    # while {@link #next} and {@link #previous} iterate through characters
    # in the normalized <em>output</em>.  This means that there is not
    # necessarily a one-to-one correspondence between characters returned
    # by <tt>next</tt> and <tt>previous</tt> and the indices passed to and
    # returned from <tt>setIndex</tt> and {@link #getIndex}.
    # <p>
    # @param index the desired index in the input text->
    # 
    # @return   the first normalized character that is the result of iterating
    #            forward starting at the given index.
    # 
    # @throws IllegalArgumentException if the given index is less than
    #          {@link #getBeginIndex} or greater than {@link #getEndIndex}.
    # @return The codepoint as an int
    # @deprecated ICU 3.2
    # @obsolete ICU 3.2
    def set_index(index)
      set_index_only(index)
      return current
    end
    
    typesig { [] }
    # Retrieve the index of the start of the input text. This is the begin
    # index of the <tt>CharacterIterator</tt> or the start (i.e. 0) of the
    # <tt>String</tt> over which this <tt>Normalizer</tt> is iterating
    # @deprecated ICU 2.2. Use startIndex() instead.
    # @return The codepoint as an int
    # @see #startIndex
    def get_begin_index
      return 0
    end
    
    typesig { [] }
    # Retrieve the index of the end of the input text.  This is the end index
    # of the <tt>CharacterIterator</tt> or the length of the <tt>String</tt>
    # over which this <tt>Normalizer</tt> is iterating
    # @deprecated ICU 2.2. Use endIndex() instead.
    # @return The codepoint as an int
    # @see #endIndex
    def get_end_index
      return end_index
    end
    
    typesig { [] }
    # Retrieve the current iteration position in the input text that is
    # being normalized.  This method is useful in applications such as
    # searching, where you need to be able to determine the position in
    # the input text that corresponds to a given normalized output character.
    # <p>
    # <b>Note:</b> This method sets the position in the <em>input</em>, while
    # {@link #next} and {@link #previous} iterate through characters in the
    # <em>output</em>.  This means that there is not necessarily a one-to-one
    # correspondence between characters returned by <tt>next</tt> and
    # <tt>previous</tt> and the indices passed to and returned from
    # <tt>setIndex</tt> and {@link #getIndex}.
    # @return The current iteration position
    # @stable ICU 2.8
    def get_index
      if (@buffer_pos < @buffer_limit)
        return @current_index
      else
        return @next_index
      end
    end
    
    typesig { [] }
    # Retrieve the index of the end of the input text->  This is the end index
    # of the <tt>CharacterIterator</tt> or the length of the <tt>String</tt>
    # over which this <tt>Normalizer</tt> is iterating
    # @return The current iteration position
    # @stable ICU 2.8
    def end_index
      return @text.get_length
    end
    
    typesig { [Mode] }
    # -------------------------------------------------------------------------
    # Property access methods
    # -------------------------------------------------------------------------
    # Set the normalization mode for this object.
    # <p>
    # <b>Note:</b>If the normalization mode is changed while iterating
    # over a string, calls to {@link #next} and {@link #previous} may
    # return previously buffers characters in the old normalization mode
    # until the iteration is able to re-sync at the next base character.
    # It is safest to call {@link #setText setText()}, {@link #first},
    # {@link #last}, etc. after calling <tt>setMode</tt>.
    # <p>
    # @param newMode the new mode for this <tt>Normalizer</tt>.
    # The supported modes are:
    # <ul>
    #  <li>{@link #COMPOSE}        - Unicode canonical decompositiion
    #                                  followed by canonical composition.
    #  <li>{@link #COMPOSE_COMPAT} - Unicode compatibility decompositiion
    #                                  follwed by canonical composition.
    #  <li>{@link #DECOMP}         - Unicode canonical decomposition
    #  <li>{@link #DECOMP_COMPAT}  - Unicode compatibility decomposition.
    #  <li>{@link #NO_OP}          - Do nothing but return characters
    #                                  from the underlying input text.
    # </ul>
    # 
    # @see #getMode
    # @stable ICU 2.8
    def set_mode(new_mode)
      @mode = new_mode
    end
    
    typesig { [] }
    # Return the basic operation performed by this <tt>Normalizer</tt>
    # 
    # @see #setMode
    # @stable ICU 2.8
    def get_mode
      return @mode
    end
    
    typesig { [String] }
    # Set the input text over which this <tt>Normalizer</tt> will iterate.
    # The iteration position is set to the beginning of the input text->
    # @param newText   The new string to be normalized.
    # @stable ICU 2.8
    def set_text(new_text)
      new_iter = UCharacterIterator.get_instance(new_text)
      if ((new_iter).nil?)
        raise InternalError.new("Could not create a new UCharacterIterator")
      end
      @text = new_iter
      reset
    end
    
    typesig { [CharacterIterator] }
    # Set the input text over which this <tt>Normalizer</tt> will iterate.
    # The iteration position is set to the beginning of the input text->
    # @param newText   The new string to be normalized.
    # @stable ICU 2.8
    def set_text(new_text)
      new_iter = UCharacterIterator.get_instance(new_text)
      if ((new_iter).nil?)
        raise InternalError.new("Could not create a new UCharacterIterator")
      end
      @text = new_iter
      @current_index = @next_index = 0
      clear_buffer
    end
    
    class_module.module_eval {
      typesig { [UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
      # -------------------------------------------------------------------------
      # Private utility methods
      # -------------------------------------------------------------------------
      # backward iteration ---------------------------------------------------
      # read backwards and get norm32
      # return 0 if the character is <minC
      # if c2!=0 then (c2, c) is a surrogate pair (reversed - c2 is first
      # surrogate but read second!)
      def get_prev_norm32(src, min_c, mask, chars)
        # unsigned
        # unsigned
        norm32 = 0
        ch = 0
        # need src.hasPrevious()
        if (((ch = src.previous)).equal?(UCharacterIterator::DONE))
          return 0
        end
        chars[0] = RJava.cast_to_char(ch)
        chars[1] = 0
        # check for a surrogate before getting norm32 to see if we need to
        # predecrement further
        if (chars[0] < min_c)
          return 0
        else
          if (!UTF16.is_surrogate(chars[0]))
            return NormalizerImpl.get_norm32(chars[0])
          else
            if (UTF16.is_lead_surrogate(chars[0]) || ((src.get_index).equal?(0)))
              # unpaired surrogate
              chars[1] = RJava.cast_to_char(src.current)
              return 0
            else
              if (UTF16.is_lead_surrogate(chars[1] = RJava.cast_to_char(src.previous)))
                norm32 = NormalizerImpl.get_norm32(chars[1])
                if (((norm32 & mask)).equal?(0))
                  # all surrogate pairs with this lead surrogate have irrelevant
                  # data
                  return 0
                else
                  # norm32 must be a surrogate special
                  return NormalizerImpl.get_norm32from_surrogate_pair(norm32, chars[0])
                end
              else
                # unpaired second surrogate, undo the c2=src.previous() movement
                src.move_index(1)
                return 0
              end
            end
          end
        end
      end
      
      const_set_lazy(:IsPrevBoundary) { Module.new do
        include_class_members NormalizerBase
        
        typesig { [UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
        def is_prev_boundary(src, min_c, mask, chars)
          raise NotImplementedError
        end
      end }
      
      const_set_lazy(:IsPrevNFDSafe) { Class.new do
        include_class_members NormalizerBase
        include IsPrevBoundary
        
        typesig { [class_self::UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
        # for NF*D:
        # read backwards and check if the lead combining class is 0
        # if c2!=0 then (c2, c) is a surrogate pair (reversed - c2 is first
        # surrogate but read second!)
        def is_prev_boundary(src, min_c, cc_or_qcmask, chars)
          # unsigned
          # unsigned
          return NormalizerImpl.is_nfdsafe(get_prev_norm32(src, min_c, cc_or_qcmask, chars), cc_or_qcmask, cc_or_qcmask & NormalizerImpl::QC_MASK)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__is_prev_nfdsafe, :initialize
      end }
      
      const_set_lazy(:IsPrevTrueStarter) { Class.new do
        include_class_members NormalizerBase
        include IsPrevBoundary
        
        typesig { [class_self::UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
        # read backwards and check if the character is (or its decomposition
        # begins with) a "true starter" (cc==0 and NF*C_YES)
        # if c2!=0 then (c2, c) is a surrogate pair (reversed - c2 is first
        # surrogate but read second!)
        def is_prev_boundary(src, min_c, cc_or_qcmask, chars)
          # unsigned
          # unsigned
          norm32 = 0 # unsigned
          decomp_qcmask = 0
          decomp_qcmask = (cc_or_qcmask << 2) & 0xf # decomposition quick check mask
          norm32 = get_prev_norm32(src, min_c, cc_or_qcmask | decomp_qcmask, chars)
          return NormalizerImpl.is_true_starter(norm32, cc_or_qcmask, decomp_qcmask)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__is_prev_true_starter, :initialize
      end }
      
      typesig { [UCharacterIterator, IsPrevBoundary, ::Java::Int, ::Java::Int, Array.typed(::Java::Char), Array.typed(::Java::Int)] }
      def find_previous_iteration_boundary(src, obj, min_c, mask, buffer, start_index)
        # unsigned
        # mask
        chars = CharArray.new(2)
        is_boundary = false
        # fill the buffer from the end backwards
        start_index[0] = buffer.attr_length
        chars[0] = 0
        while (src.get_index > 0 && !(chars[0]).equal?(UCharacterIterator::DONE))
          is_boundary = obj.is_prev_boundary(src, min_c, mask, chars)
          # always write this character to the front of the buffer
          # make sure there is enough space in the buffer
          if (start_index[0] < ((chars[1]).equal?(0) ? 1 : 2))
            # grow the buffer
            new_buf = CharArray.new(buffer.attr_length * 2)
            # move the current buffer contents up
            System.arraycopy(buffer, start_index[0], new_buf, new_buf.attr_length - (buffer.attr_length - start_index[0]), buffer.attr_length - start_index[0])
            # adjust the startIndex
            start_index[0] += new_buf.attr_length - buffer.attr_length
            buffer = new_buf
            new_buf = nil
          end
          buffer[(start_index[0] -= 1)] = chars[0]
          if (!(chars[1]).equal?(0))
            buffer[(start_index[0] -= 1)] = chars[1]
          end
          # stop if this just-copied character is a boundary
          if (is_boundary)
            break
          end
        end
        # return the length of the buffer contents
        return buffer.attr_length - start_index[0]
      end
      
      typesig { [UCharacterIterator, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Mode, ::Java::Boolean, Array.typed(::Java::Boolean), ::Java::Int] }
      def previous(src, dest, dest_start, dest_limit, mode, do_normalize, p_needed_to_normalize, options)
        is_previous_boundary = nil
        dest_length = 0
        buffer_length = 0 # unsigned
        mask = 0
        c = 0
        c2 = 0
        min_c = 0
        dest_capacity = dest_limit - dest_start
        dest_length = 0
        if (!(p_needed_to_normalize).nil?)
          p_needed_to_normalize[0] = false
        end
        min_c = RJava.cast_to_char(mode.get_min_c)
        mask = mode.get_mask
        is_previous_boundary = mode.get_prev_boundary
        if ((is_previous_boundary).nil?)
          dest_length = 0
          if ((c = src.previous) >= 0)
            dest_length = 1
            if (UTF16.is_trail_surrogate(RJava.cast_to_char(c)))
              c2 = src.previous
              if (!(c2).equal?(UCharacterIterator::DONE))
                if (UTF16.is_lead_surrogate(RJava.cast_to_char(c2)))
                  if (dest_capacity >= 2)
                    dest[1] = RJava.cast_to_char(c) # trail surrogate
                    dest_length = 2
                  end
                  # lead surrogate to be written below
                  c = c2
                else
                  src.move_index(1)
                end
              end
            end
            if (dest_capacity > 0)
              dest[0] = RJava.cast_to_char(c)
            end
          end
          return dest_length
        end
        buffer = CharArray.new(100)
        start_index = Array.typed(::Java::Int).new(1) { 0 }
        buffer_length = find_previous_iteration_boundary(src, is_previous_boundary, min_c, mask, buffer, start_index)
        if (buffer_length > 0)
          if (do_normalize)
            dest_length = NormalizerBase.normalize(buffer, start_index[0], start_index[0] + buffer_length, dest, dest_start, dest_limit, mode, options)
            if (!(p_needed_to_normalize).nil?)
              p_needed_to_normalize[0] = (!(dest_length).equal?(buffer_length) || Utility.array_region_matches(buffer, 0, dest, dest_start, dest_limit))
            end
          else
            # just copy the source characters
            if (dest_capacity > 0)
              System.arraycopy(buffer, start_index[0], dest, 0, (buffer_length < dest_capacity) ? buffer_length : dest_capacity)
            end
          end
        end
        return dest_length
      end
      
      # forward iteration ----------------------------------------------------
      # read forward and check if the character is a next-iteration boundary
      # if c2!=0 then (c, c2) is a surrogate pair
      const_set_lazy(:IsNextBoundary) { Module.new do
        include_class_members NormalizerBase
        
        typesig { [UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Int)] }
        def is_next_boundary(src, min_c, mask, chars)
          raise NotImplementedError
        end
      end }
      
      typesig { [UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Int)] }
      # read forward and get norm32
      # return 0 if the character is <minC
      # if c2!=0 then (c2, c) is a surrogate pair
      # always reads complete characters
      # unsigned
      def get_next_norm32(src, min_c, mask, chars)
        # unsigned
        # unsigned
        norm32 = 0
        # need src.hasNext() to be true
        chars[0] = src.next_
        chars[1] = 0
        if (chars[0] < min_c)
          return 0
        end
        norm32 = NormalizerImpl.get_norm32(RJava.cast_to_char(chars[0]))
        if (UTF16.is_lead_surrogate(RJava.cast_to_char(chars[0])))
          if (!(src.current).equal?(UCharacterIterator::DONE) && UTF16.is_trail_surrogate(RJava.cast_to_char((chars[1] = src.current))))
            src.move_index(1) # skip the c2 surrogate
            if (((norm32 & mask)).equal?(0))
              # irrelevant data
              return 0
            else
              # norm32 must be a surrogate special
              return NormalizerImpl.get_norm32from_surrogate_pair(norm32, RJava.cast_to_char(chars[1]))
            end
          else
            # unmatched surrogate
            return 0
          end
        end
        return norm32
      end
      
      # for NF*D:
      # read forward and check if the lead combining class is 0
      # if c2!=0 then (c, c2) is a surrogate pair
      const_set_lazy(:IsNextNFDSafe) { Class.new do
        include_class_members NormalizerBase
        include IsNextBoundary
        
        typesig { [class_self::UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Int)] }
        def is_next_boundary(src, min_c, cc_or_qcmask, chars)
          # unsigned
          # unsigned
          return NormalizerImpl.is_nfdsafe(get_next_norm32(src, min_c, cc_or_qcmask, chars), cc_or_qcmask, cc_or_qcmask & NormalizerImpl::QC_MASK)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__is_next_nfdsafe, :initialize
      end }
      
      # for NF*C:
      # read forward and check if the character is (or its decomposition begins
      # with) a "true starter" (cc==0 and NF*C_YES)
      # if c2!=0 then (c, c2) is a surrogate pair
      const_set_lazy(:IsNextTrueStarter) { Class.new do
        include_class_members NormalizerBase
        include IsNextBoundary
        
        typesig { [class_self::UCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(::Java::Int)] }
        def is_next_boundary(src, min_c, cc_or_qcmask, chars)
          # unsigned
          # unsigned
          norm32 = 0 # unsigned
          decomp_qcmask = 0
          decomp_qcmask = (cc_or_qcmask << 2) & 0xf # decomposition quick check mask
          norm32 = get_next_norm32(src, min_c, cc_or_qcmask | decomp_qcmask, chars)
          return NormalizerImpl.is_true_starter(norm32, cc_or_qcmask, decomp_qcmask)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__is_next_true_starter, :initialize
      end }
      
      typesig { [UCharacterIterator, IsNextBoundary, ::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
      def find_next_iteration_boundary(src, obj, min_c, mask, buffer)
        # unsigned
        # unsigned
        if ((src.current).equal?(UCharacterIterator::DONE))
          return 0
        end
        # get one character and ignore its properties
        chars = Array.typed(::Java::Int).new(2) { 0 }
        chars[0] = src.next_
        buffer[0] = RJava.cast_to_char(chars[0])
        buffer_index = 1
        if (UTF16.is_lead_surrogate(RJava.cast_to_char(chars[0])) && !(src.current).equal?(UCharacterIterator::DONE))
          if (UTF16.is_trail_surrogate(RJava.cast_to_char((chars[1] = src.next_))))
            buffer[((buffer_index += 1) - 1)] = RJava.cast_to_char(chars[1])
          else
            src.move_index(-1) # back out the non-trail-surrogate
          end
        end
        # get all following characters until we see a boundary
        # checking hasNext() instead of c!=DONE on the off-chance that U+ffff
        # is part of the string
        while (!(src.current).equal?(UCharacterIterator::DONE))
          if (obj.is_next_boundary(src, min_c, mask, chars))
            # back out the latest movement to stop at the boundary
            src.move_index((chars[1]).equal?(0) ? -1 : -2)
            break
          else
            if (buffer_index + ((chars[1]).equal?(0) ? 1 : 2) <= buffer.attr_length)
              buffer[((buffer_index += 1) - 1)] = RJava.cast_to_char(chars[0])
              if (!(chars[1]).equal?(0))
                buffer[((buffer_index += 1) - 1)] = RJava.cast_to_char(chars[1])
              end
            else
              new_buf = CharArray.new(buffer.attr_length * 2)
              System.arraycopy(buffer, 0, new_buf, 0, buffer_index)
              buffer = new_buf
              buffer[((buffer_index += 1) - 1)] = RJava.cast_to_char(chars[0])
              if (!(chars[1]).equal?(0))
                buffer[((buffer_index += 1) - 1)] = RJava.cast_to_char(chars[1])
              end
            end
          end
        end
        # return the length of the buffer contents
        return buffer_index
      end
      
      typesig { [UCharacterIterator, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, NormalizerBase::Mode, ::Java::Boolean, Array.typed(::Java::Boolean), ::Java::Int] }
      def next_(src, dest, dest_start, dest_limit, mode, do_normalize, p_needed_to_normalize, options)
        is_next_boundary_ = nil # unsigned
        mask = 0 # unsigned
        buffer_length = 0
        c = 0
        c2 = 0
        min_c = 0
        dest_capacity = dest_limit - dest_start
        dest_length = 0
        if (!(p_needed_to_normalize).nil?)
          p_needed_to_normalize[0] = false
        end
        min_c = RJava.cast_to_char(mode.get_min_c)
        mask = mode.get_mask
        is_next_boundary_ = mode.get_next_boundary
        if ((is_next_boundary_).nil?)
          dest_length = 0
          c = src.next_
          if (!(c).equal?(UCharacterIterator::DONE))
            dest_length = 1
            if (UTF16.is_lead_surrogate(RJava.cast_to_char(c)))
              c2 = src.next_
              if (!(c2).equal?(UCharacterIterator::DONE))
                if (UTF16.is_trail_surrogate(RJava.cast_to_char(c2)))
                  if (dest_capacity >= 2)
                    dest[1] = RJava.cast_to_char(c2) # trail surrogate
                    dest_length = 2
                  end
                  # lead surrogate to be written below
                else
                  src.move_index(-1)
                end
              end
            end
            if (dest_capacity > 0)
              dest[0] = RJava.cast_to_char(c)
            end
          end
          return dest_length
        end
        buffer = CharArray.new(100)
        start_index = Array.typed(::Java::Int).new(1) { 0 }
        buffer_length = find_next_iteration_boundary(src, is_next_boundary_, min_c, mask, buffer)
        if (buffer_length > 0)
          if (do_normalize)
            dest_length = mode.normalize(buffer, start_index[0], buffer_length, dest, dest_start, dest_limit, options)
            if (!(p_needed_to_normalize).nil?)
              p_needed_to_normalize[0] = (!(dest_length).equal?(buffer_length) || Utility.array_region_matches(buffer, start_index[0], dest, dest_start, dest_length))
            end
          else
            # just copy the source characters
            if (dest_capacity > 0)
              System.arraycopy(buffer, 0, dest, dest_start, Math.min(buffer_length, dest_capacity))
            end
          end
        end
        return dest_length
      end
    }
    
    typesig { [] }
    def clear_buffer
      @buffer_limit = @buffer_start = @buffer_pos = 0
    end
    
    typesig { [] }
    def next_normalize
      clear_buffer
      @current_index = @next_index
      @text.set_index(@next_index)
      @buffer_limit = next_(@text, @buffer, @buffer_start, @buffer.attr_length, @mode, true, nil, @options)
      @next_index = @text.get_index
      return (@buffer_limit > 0)
    end
    
    typesig { [] }
    def previous_normalize
      clear_buffer
      @next_index = @current_index
      @text.set_index(@current_index)
      @buffer_limit = previous(@text, @buffer, @buffer_start, @buffer.attr_length, @mode, true, nil, @options)
      @current_index = @text.get_index
      @buffer_pos = @buffer_limit
      return @buffer_limit > 0
    end
    
    typesig { [::Java::Int] }
    def get_code_point_at(index)
      if (UTF16.is_surrogate(@buffer[index]))
        if (UTF16.is_lead_surrogate(@buffer[index]))
          if ((index + 1) < @buffer_limit && UTF16.is_trail_surrogate(@buffer[index + 1]))
            return UCharacterProperty.get_raw_supplementary(@buffer[index], @buffer[index + 1])
          end
        else
          if (UTF16.is_trail_surrogate(@buffer[index]))
            if (index > 0 && UTF16.is_lead_surrogate(@buffer[index - 1]))
              return UCharacterProperty.get_raw_supplementary(@buffer[index - 1], @buffer[index])
            end
          end
        end
      end
      return @buffer[index]
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Mode] }
      # Internal API
      # @internal
      def is_nfskippable(c, mode)
        return mode.is_nfskippable(c)
      end
      
      # 
      # Options
      # 
      # Default option for Unicode 3.2.0 normalization.
      # Corrigendum 4 was fixed in Unicode 3.2.0 but isn't supported in
      # IDNA/StringPrep.
      # The public review issue #29 was fixed in Unicode 4.1.0. Corrigendum 5
      # allowed Unicode 3.2 to 4.0.1 to apply the fix for PRI #29, but it isn't
      # supported by IDNA/StringPrep as well as Corrigendum 4.
      const_set_lazy(:UNICODE_3_2_0_ORIGINAL) { UNICODE_3_2 | NormalizerImpl::WITHOUT_CORRIGENDUM4_CORRECTIONS | NormalizerImpl::BEFORE_PRI_29 }
      const_attr_reader  :UNICODE_3_2_0_ORIGINAL
      
      # Default option for the latest Unicode normalization. This option is
      # provided mainly for testing.
      # The value zero means that normalization is done with the fixes for
      #   - Corrigendum 4 (Five CJK Canonical Mapping Errors)
      #   - Corrigendum 5 (Normalization Idempotency)
      const_set_lazy(:UNICODE_LATEST) { 0x0 }
      const_attr_reader  :UNICODE_LATEST
    }
    
    typesig { [String, Mode] }
    # 
    # public constructor and methods for java.text.Normalizer and
    # sun.text.Normalizer
    # 
    # Creates a new <tt>Normalizer</tt> object for iterating over the
    # normalized form of a given string.
    # 
    # @param str  The string to be normalized.  The normalization
    #              will start at the beginning of the string.
    # 
    # @param mode The normalization mode.
    def initialize(str, mode)
      initialize__normalizer_base(str, mode, UNICODE_LATEST)
    end
    
    class_module.module_eval {
      typesig { [String, Normalizer::Form] }
      # Normalizes a <code>String</code> using the given normalization form.
      # 
      # @param str      the input string to be normalized.
      # @param form     the normalization form
      def normalize(str, form)
        return normalize(str, form, UNICODE_LATEST)
      end
      
      typesig { [String, Normalizer::Form, ::Java::Int] }
      # Normalizes a <code>String</code> using the given normalization form.
      # 
      # @param str      the input string to be normalized.
      # @param form     the normalization form
      # @param options   the optional features to be enabled.
      def normalize(str, form, options)
        case (form)
        when NFC
          return NFC.normalize(str, options)
        when NFD
          return NFD.normalize(str, options)
        when NFKC
          return NFKC.normalize(str, options)
        when NFKD
          return NFKD.normalize(str, options)
        end
        raise IllegalArgumentException.new("Unexpected normalization form: " + RJava.cast_to_string(form))
      end
      
      typesig { [String, Normalizer::Form] }
      # Test if a string is in a given normalization form.
      # This is semantically equivalent to source.equals(normalize(source, mode)).
      # 
      # Unlike quickCheck(), this function returns a definitive result,
      # never a "maybe".
      # For NFD, NFKD, and FCD, both functions work exactly the same.
      # For NFC and NFKC where quickCheck may return "maybe", this function will
      # perform further tests to arrive at a true/false result.
      # @param str       the input string to be checked to see if it is normalized
      # @param form      the normalization form
      # @param options   the optional features to be enabled.
      def is_normalized(str, form)
        return is_normalized(str, form, UNICODE_LATEST)
      end
      
      typesig { [String, Normalizer::Form, ::Java::Int] }
      # Test if a string is in a given normalization form.
      # This is semantically equivalent to source.equals(normalize(source, mode)).
      # 
      # Unlike quickCheck(), this function returns a definitive result,
      # never a "maybe".
      # For NFD, NFKD, and FCD, both functions work exactly the same.
      # For NFC and NFKC where quickCheck may return "maybe", this function will
      # perform further tests to arrive at a true/false result.
      # @param str       the input string to be checked to see if it is normalized
      # @param form      the normalization form
      # @param options   the optional features to be enabled.
      def is_normalized(str, form, options)
        case (form)
        when NFC
          return ((NFC.quick_check(str.to_char_array, 0, str.length, false, NormalizerImpl.get_nx(options))).equal?(YES))
        when NFD
          return ((NFD.quick_check(str.to_char_array, 0, str.length, false, NormalizerImpl.get_nx(options))).equal?(YES))
        when NFKC
          return ((NFKC.quick_check(str.to_char_array, 0, str.length, false, NormalizerImpl.get_nx(options))).equal?(YES))
        when NFKD
          return ((NFKD.quick_check(str.to_char_array, 0, str.length, false, NormalizerImpl.get_nx(options))).equal?(YES))
        end
        raise IllegalArgumentException.new("Unexpected normalization form: " + RJava.cast_to_string(form))
      end
    }
    
    private
    alias_method :initialize__normalizer_base, :initialize
  end
  
end
