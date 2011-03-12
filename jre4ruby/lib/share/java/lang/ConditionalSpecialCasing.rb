require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ConditionalSpecialCasingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Text, :BreakIterator
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Locale
      include_const ::Sun::Text, :Normalizer
    }
  end
  
  # This is a utility class for <code>String.toLowerCase()</code> and
  # <code>String.toUpperCase()</code>, that handles special casing with
  # conditions.  In other words, it handles the mappings with conditions
  # that are defined in
  # <a href="http://www.unicode.org/Public/UNIDATA/SpecialCasing.txt">Special
  # Casing Properties</a> file.
  # <p>
  # Note that the unconditional case mappings (including 1:M mappings)
  # are handled in <code>Character.toLower/UpperCase()</code>.
  class ConditionalSpecialCasing 
    include_class_members ConditionalSpecialCasingImports
    
    class_module.module_eval {
      # context conditions.
      const_set_lazy(:FINAL_CASED) { 1 }
      const_attr_reader  :FINAL_CASED
      
      const_set_lazy(:AFTER_SOFT_DOTTED) { 2 }
      const_attr_reader  :AFTER_SOFT_DOTTED
      
      const_set_lazy(:MORE_ABOVE) { 3 }
      const_attr_reader  :MORE_ABOVE
      
      const_set_lazy(:AFTER_I) { 4 }
      const_attr_reader  :AFTER_I
      
      const_set_lazy(:NOT_BEFORE_DOT) { 5 }
      const_attr_reader  :NOT_BEFORE_DOT
      
      # combining class definitions
      const_set_lazy(:COMBINING_CLASS_ABOVE) { 230 }
      const_attr_reader  :COMBINING_CLASS_ABOVE
      
      # Special case mapping entries
      # # ================================================================================
      # # Conditional mappings
      # # ================================================================================
      # # GREEK CAPITAL LETTER SIGMA
      # # ================================================================================
      # # Locale-sensitive mappings
      # # ================================================================================
      # # Lithuanian
      # # COMBINING DOT ABOVE
      # # LATIN CAPITAL LETTER I
      # # LATIN CAPITAL LETTER J
      # # LATIN CAPITAL LETTER I WITH OGONEK
      # # LATIN CAPITAL LETTER I WITH GRAVE
      # # LATIN CAPITAL LETTER I WITH ACUTE
      # # LATIN CAPITAL LETTER I WITH TILDE
      # # ================================================================================
      # # Turkish and Azeri
      #      new Entry(0x0130, new char[]{0x0069}, new char[]{0x0130}, "tr", 0), // # LATIN CAPITAL LETTER I WITH DOT ABOVE
      #      new Entry(0x0130, new char[]{0x0069}, new char[]{0x0130}, "az", 0), // # LATIN CAPITAL LETTER I WITH DOT ABOVE
      # # COMBINING DOT ABOVE
      # # COMBINING DOT ABOVE
      # # LATIN CAPITAL LETTER I
      # # LATIN CAPITAL LETTER I
      # # LATIN SMALL LETTER I
      # # LATIN SMALL LETTER I
      
      def entry
        defined?(@@entry) ? @@entry : @@entry= Array.typed(Entry).new([Entry.new(0x3a3, Array.typed(::Java::Char).new([0x3c2]), Array.typed(::Java::Char).new([0x3a3]), nil, FINAL_CASED), Entry.new(0x307, Array.typed(::Java::Char).new([0x307]), Array.typed(::Java::Char).new([]), "lt", AFTER_SOFT_DOTTED), Entry.new(0x49, Array.typed(::Java::Char).new([0x69, 0x307]), Array.typed(::Java::Char).new([0x49]), "lt", MORE_ABOVE), Entry.new(0x4a, Array.typed(::Java::Char).new([0x6a, 0x307]), Array.typed(::Java::Char).new([0x4a]), "lt", MORE_ABOVE), Entry.new(0x12e, Array.typed(::Java::Char).new([0x12f, 0x307]), Array.typed(::Java::Char).new([0x12e]), "lt", MORE_ABOVE), Entry.new(0xcc, Array.typed(::Java::Char).new([0x69, 0x307, 0x300]), Array.typed(::Java::Char).new([0xcc]), "lt", 0), Entry.new(0xcd, Array.typed(::Java::Char).new([0x69, 0x307, 0x301]), Array.typed(::Java::Char).new([0xcd]), "lt", 0), Entry.new(0x128, Array.typed(::Java::Char).new([0x69, 0x307, 0x303]), Array.typed(::Java::Char).new([0x128]), "lt", 0), Entry.new(0x307, Array.typed(::Java::Char).new([]), Array.typed(::Java::Char).new([0x307]), "tr", AFTER_I), Entry.new(0x307, Array.typed(::Java::Char).new([]), Array.typed(::Java::Char).new([0x307]), "az", AFTER_I), Entry.new(0x49, Array.typed(::Java::Char).new([0x131]), Array.typed(::Java::Char).new([0x49]), "tr", NOT_BEFORE_DOT), Entry.new(0x49, Array.typed(::Java::Char).new([0x131]), Array.typed(::Java::Char).new([0x49]), "az", NOT_BEFORE_DOT), Entry.new(0x69, Array.typed(::Java::Char).new([0x69]), Array.typed(::Java::Char).new([0x130]), "tr", 0), Entry.new(0x69, Array.typed(::Java::Char).new([0x69]), Array.typed(::Java::Char).new([0x130]), "az", 0)])
      end
      alias_method :attr_entry, :entry
      
      def entry=(value)
        @@entry = value
      end
      alias_method :attr_entry=, :entry=
      
      # A hash table that contains the above entries
      
      def entry_table
        defined?(@@entry_table) ? @@entry_table : @@entry_table= Hashtable.new
      end
      alias_method :attr_entry_table, :entry_table
      
      def entry_table=(value)
        @@entry_table = value
      end
      alias_method :attr_entry_table=, :entry_table=
      
      when_class_loaded do
        # create hashtable from the entry
        i = 0
        while i < self.attr_entry.attr_length
          cur = self.attr_entry[i]
          cp = cur.get_code_point
          set = self.attr_entry_table.get(cp)
          if ((set).nil?)
            set = HashSet.new
          end
          set.add(cur)
          self.attr_entry_table.put(cp, set)
          i += 1
        end
      end
      
      typesig { [String, ::Java::Int, Locale] }
      def to_lower_case_ex(src, index, locale)
        result = look_up_table(src, index, locale, true)
        if (!(result).nil?)
          if ((result.attr_length).equal?(1))
            return result[0]
          else
            return Character::ERROR
          end
        else
          # default to Character class' one
          return Character.to_lower_case(src.code_point_at(index))
        end
      end
      
      typesig { [String, ::Java::Int, Locale] }
      def to_upper_case_ex(src, index, locale)
        result = look_up_table(src, index, locale, false)
        if (!(result).nil?)
          if ((result.attr_length).equal?(1))
            return result[0]
          else
            return Character::ERROR
          end
        else
          # default to Character class' one
          return Character.to_upper_case_ex(src.code_point_at(index))
        end
      end
      
      typesig { [String, ::Java::Int, Locale] }
      def to_lower_case_char_array(src, index, locale)
        return look_up_table(src, index, locale, true)
      end
      
      typesig { [String, ::Java::Int, Locale] }
      def to_upper_case_char_array(src, index, locale)
        result = look_up_table(src, index, locale, false)
        if (!(result).nil?)
          return result
        else
          return Character.to_upper_case_char_array(src.code_point_at(index))
        end
      end
      
      typesig { [String, ::Java::Int, Locale, ::Java::Boolean] }
      def look_up_table(src, index, locale, b_lower_casing)
        set = self.attr_entry_table.get(src.code_point_at(index))
        if (!(set).nil?)
          iter = set.iterator
          current_lang = locale.get_language
          while (iter.has_next)
            entry = iter.next_
            condition_lang = entry.get_language
            if ((((condition_lang).nil?) || ((condition_lang == current_lang))) && is_condition_met(src, index, locale, entry.get_condition))
              return (b_lower_casing ? entry.get_lower_case : entry.get_upper_case)
            end
          end
        end
        return nil
      end
      
      typesig { [String, ::Java::Int, Locale, ::Java::Int] }
      def is_condition_met(src, index, locale, condition)
        case (condition)
        when FINAL_CASED
          return is_final_cased(src, index, locale)
        when AFTER_SOFT_DOTTED
          return is_after_soft_dotted(src, index)
        when MORE_ABOVE
          return is_more_above(src, index)
        when AFTER_I
          return is_after_i(src, index)
        when NOT_BEFORE_DOT
          return !is_before_dot(src, index)
        else
          return true
        end
      end
      
      typesig { [String, ::Java::Int, Locale] }
      # Implements the "Final_Cased" condition
      # 
      # Specification: Within the closest word boundaries containing C, there is a cased
      # letter before C, and there is no cased letter after C.
      # 
      # Regular Expression:
      #   Before C: [{cased==true}][{wordBoundary!=true}]*
      #   After C: !([{wordBoundary!=true}]*[{cased}])
      def is_final_cased(src, index, locale)
        word_boundary = BreakIterator.get_word_instance(locale)
        word_boundary.set_text(src)
        ch = 0
        # Look for a preceding 'cased' letter
        i = index
        while (i >= 0) && !word_boundary.is_boundary(i)
          ch = src.code_point_before(i)
          if (is_cased(ch))
            len = src.length
            # Check that there is no 'cased' letter after the index
            i = index + Character.char_count(src.code_point_at(index))
            while (i < len) && !word_boundary.is_boundary(i)
              ch = src.code_point_at(i)
              if (is_cased(ch))
                return false
              end
              i += Character.char_count(ch)
            end
            return true
          end
          i -= Character.char_count(ch)
        end
        return false
      end
      
      typesig { [String, ::Java::Int] }
      # Implements the "After_I" condition
      # 
      # Specification: The last preceding base character was an uppercase I,
      # and there is no intervening combining character class 230 (ABOVE).
      # 
      # Regular Expression:
      #   Before C: [I]([{cc!=230}&{cc!=0}])*
      def is_after_i(src, index)
        ch = 0
        cc = 0
        # Look for the last preceding base character
        i = index
        while i > 0
          ch = src.code_point_before(i)
          if ((ch).equal?(Character.new(?I.ord)))
            return true
          else
            cc = Normalizer.get_combining_class(ch)
            if (((cc).equal?(0)) || ((cc).equal?(COMBINING_CLASS_ABOVE)))
              return false
            end
          end
          i -= Character.char_count(ch)
        end
        return false
      end
      
      typesig { [String, ::Java::Int] }
      # Implements the "After_Soft_Dotted" condition
      # 
      # Specification: The last preceding character with combining class
      # of zero before C was Soft_Dotted, and there is no intervening
      # combining character class 230 (ABOVE).
      # 
      # Regular Expression:
      #   Before C: [{Soft_Dotted==true}]([{cc!=230}&{cc!=0}])*
      def is_after_soft_dotted(src, index)
        ch = 0
        cc = 0
        # Look for the last preceding character
        i = index
        while i > 0
          ch = src.code_point_before(i)
          if (is_soft_dotted(ch))
            return true
          else
            cc = Normalizer.get_combining_class(ch)
            if (((cc).equal?(0)) || ((cc).equal?(COMBINING_CLASS_ABOVE)))
              return false
            end
          end
          i -= Character.char_count(ch)
        end
        return false
      end
      
      typesig { [String, ::Java::Int] }
      # Implements the "More_Above" condition
      # 
      # Specification: C is followed by one or more characters of combining
      # class 230 (ABOVE) in the combining character sequence.
      # 
      # Regular Expression:
      #   After C: [{cc!=0}]*[{cc==230}]
      def is_more_above(src, index)
        ch = 0
        cc = 0
        len = src.length
        # Look for a following ABOVE combining class character
        i = index + Character.char_count(src.code_point_at(index))
        while i < len
          ch = src.code_point_at(i)
          cc = Normalizer.get_combining_class(ch)
          if ((cc).equal?(COMBINING_CLASS_ABOVE))
            return true
          else
            if ((cc).equal?(0))
              return false
            end
          end
          i += Character.char_count(ch)
        end
        return false
      end
      
      typesig { [String, ::Java::Int] }
      # Implements the "Before_Dot" condition
      # 
      # Specification: C is followed by <code>U+0307 COMBINING DOT ABOVE</code>.
      # Any sequence of characters with a combining class that is
      # neither 0 nor 230 may intervene between the current character
      # and the combining dot above.
      # 
      # Regular Expression:
      #   After C: ([{cc!=230}&{cc!=0}])*[\u0307]
      def is_before_dot(src, index)
        ch = 0
        cc = 0
        len = src.length
        # Look for a following COMBINING DOT ABOVE
        i = index + Character.char_count(src.code_point_at(index))
        while i < len
          ch = src.code_point_at(i)
          if ((ch).equal?(Character.new(0x0307)))
            return true
          else
            cc = Normalizer.get_combining_class(ch)
            if (((cc).equal?(0)) || ((cc).equal?(COMBINING_CLASS_ABOVE)))
              return false
            end
          end
          i += Character.char_count(ch)
        end
        return false
      end
      
      typesig { [::Java::Int] }
      # Examines whether a character is 'cased'.
      # 
      # A character C is defined to be 'cased' if and only if at least one of
      # following are true for C: uppercase==true, or lowercase==true, or
      # general_category==titlecase_letter.
      # 
      # The uppercase and lowercase property values are specified in the data
      # file DerivedCoreProperties.txt in the Unicode Character Database.
      def is_cased(ch)
        type = Character.get_type(ch)
        if ((type).equal?(Character::LOWERCASE_LETTER) || (type).equal?(Character::UPPERCASE_LETTER) || (type).equal?(Character::TITLECASE_LETTER))
          return true
        else
          # Check for Other_Lowercase and Other_Uppercase
          # 
          if ((ch >= 0x2b0) && (ch <= 0x2b8))
            # MODIFIER LETTER SMALL H..MODIFIER LETTER SMALL Y
            return true
          else
            if ((ch >= 0x2c0) && (ch <= 0x2c1))
              # MODIFIER LETTER GLOTTAL STOP..MODIFIER LETTER REVERSED GLOTTAL STOP
              return true
            else
              if ((ch >= 0x2e0) && (ch <= 0x2e4))
                # MODIFIER LETTER SMALL GAMMA..MODIFIER LETTER SMALL REVERSED GLOTTAL STOP
                return true
              else
                if ((ch).equal?(0x345))
                  # COMBINING GREEK YPOGEGRAMMENI
                  return true
                else
                  if ((ch).equal?(0x37a))
                    # GREEK YPOGEGRAMMENI
                    return true
                  else
                    if ((ch >= 0x1d2c) && (ch <= 0x1d61))
                      # MODIFIER LETTER CAPITAL A..MODIFIER LETTER SMALL CHI
                      return true
                    else
                      if ((ch >= 0x2160) && (ch <= 0x217f))
                        # ROMAN NUMERAL ONE..ROMAN NUMERAL ONE THOUSAND
                        # SMALL ROMAN NUMERAL ONE..SMALL ROMAN NUMERAL ONE THOUSAND
                        return true
                      else
                        if ((ch >= 0x24b6) && (ch <= 0x24e9))
                          # CIRCLED LATIN CAPITAL LETTER A..CIRCLED LATIN CAPITAL LETTER Z
                          # CIRCLED LATIN SMALL LETTER A..CIRCLED LATIN SMALL LETTER Z
                          return true
                        else
                          return false
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      
      typesig { [::Java::Int] }
      def is_soft_dotted(ch)
        case (ch)
        when 0x69, 0x6a, 0x12f, 0x268, 0x456, 0x458, 0x1d62, 0x1e2d, 0x1ecb, 0x2071
          # Soft_Dotted # L&       LATIN SMALL LETTER I
          # Soft_Dotted # L&       LATIN SMALL LETTER J
          # Soft_Dotted # L&       LATIN SMALL LETTER I WITH OGONEK
          # Soft_Dotted # L&       LATIN SMALL LETTER I WITH STROKE
          # Soft_Dotted # L&       CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
          # Soft_Dotted # L&       CYRILLIC SMALL LETTER JE
          # Soft_Dotted # L&       LATIN SUBSCRIPT SMALL LETTER I
          # Soft_Dotted # L&       LATIN SMALL LETTER I WITH TILDE BELOW
          # Soft_Dotted # L&       LATIN SMALL LETTER I WITH DOT BELOW
          # Soft_Dotted # L&       SUPERSCRIPT LATIN SMALL LETTER I
          return true
        else
          return false
        end
      end
      
      # An internal class that represents an entry in the Special Casing Properties.
      const_set_lazy(:Entry) { Class.new do
        include_class_members ConditionalSpecialCasing
        
        attr_accessor :ch
        alias_method :attr_ch, :ch
        undef_method :ch
        alias_method :attr_ch=, :ch=
        undef_method :ch=
        
        attr_accessor :lower
        alias_method :attr_lower, :lower
        undef_method :lower
        alias_method :attr_lower=, :lower=
        undef_method :lower=
        
        attr_accessor :upper
        alias_method :attr_upper, :upper
        undef_method :upper
        alias_method :attr_upper=, :upper=
        undef_method :upper=
        
        attr_accessor :lang
        alias_method :attr_lang, :lang
        undef_method :lang
        alias_method :attr_lang=, :lang=
        undef_method :lang=
        
        attr_accessor :condition
        alias_method :attr_condition, :condition
        undef_method :condition
        alias_method :attr_condition=, :condition=
        undef_method :condition=
        
        typesig { [::Java::Int, Array.typed(::Java::Char), Array.typed(::Java::Char), String, ::Java::Int] }
        def initialize(ch, lower, upper, lang, condition)
          @ch = 0
          @lower = nil
          @upper = nil
          @lang = nil
          @condition = 0
          @ch = ch
          @lower = lower
          @upper = upper
          @lang = lang
          @condition = condition
        end
        
        typesig { [] }
        def get_code_point
          return @ch
        end
        
        typesig { [] }
        def get_lower_case
          return @lower
        end
        
        typesig { [] }
        def get_upper_case
          return @upper
        end
        
        typesig { [] }
        def get_language
          return @lang
        end
        
        typesig { [] }
        def get_condition
          return @condition
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__conditional_special_casing, :initialize
  end
  
end
