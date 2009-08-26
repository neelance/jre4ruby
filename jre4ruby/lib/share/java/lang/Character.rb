require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CharacterImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Locale
    }
  end
  
  # The <code>Character</code> class wraps a value of the primitive
  # type <code>char</code> in an object. An object of type
  # <code>Character</code> contains a single field whose type is
  # <code>char</code>.
  # <p>
  # In addition, this class provides several methods for determining
  # a character's category (lowercase letter, digit, etc.) and for converting
  # characters from uppercase to lowercase and vice versa.
  # <p>
  # Character information is based on the Unicode Standard, version 4.0.
  # <p>
  # The methods and data of class <code>Character</code> are defined by
  # the information in the <i>UnicodeData</i> file that is part of the
  # Unicode Character Database maintained by the Unicode
  # Consortium. This file specifies various properties including name
  # and general category for every defined Unicode code point or
  # character range.
  # <p>
  # The file and its description are available from the Unicode Consortium at:
  # <ul>
  # <li><a href="http://www.unicode.org">http://www.unicode.org</a>
  # </ul>
  # 
  # <h4><a name="unicode">Unicode Character Representations</a></h4>
  # 
  # <p>The <code>char</code> data type (and therefore the value that a
  # <code>Character</code> object encapsulates) are based on the
  # original Unicode specification, which defined characters as
  # fixed-width 16-bit entities. The Unicode standard has since been
  # changed to allow for characters whose representation requires more
  # than 16 bits.  The range of legal <em>code point</em>s is now
  # U+0000 to U+10FFFF, known as <em>Unicode scalar value</em>.
  # (Refer to the <a
  # href="http://www.unicode.org/reports/tr27/#notation"><i>
  # definition</i></a> of the U+<i>n</i> notation in the Unicode
  # standard.)
  # 
  # <p>The set of characters from U+0000 to U+FFFF is sometimes
  # referred to as the <em>Basic Multilingual Plane (BMP)</em>. <a
  # name="supplementary">Characters</a> whose code points are greater
  # than U+FFFF are called <em>supplementary character</em>s.  The Java
  # 2 platform uses the UTF-16 representation in <code>char</code>
  # arrays and in the <code>String</code> and <code>StringBuffer</code>
  # classes. In this representation, supplementary characters are
  # represented as a pair of <code>char</code> values, the first from
  # the <em>high-surrogates</em> range, (&#92;uD800-&#92;uDBFF), the
  # second from the <em>low-surrogates</em> range
  # (&#92;uDC00-&#92;uDFFF).
  # 
  # <p>A <code>char</code> value, therefore, represents Basic
  # Multilingual Plane (BMP) code points, including the surrogate
  # code points, or code units of the UTF-16 encoding. An
  # <code>int</code> value represents all Unicode code points,
  # including supplementary code points. The lower (least significant)
  # 21 bits of <code>int</code> are used to represent Unicode code
  # points and the upper (most significant) 11 bits must be zero.
  # Unless otherwise specified, the behavior with respect to
  # supplementary characters and surrogate <code>char</code> values is
  # as follows:
  # 
  # <ul>
  # <li>The methods that only accept a <code>char</code> value cannot support
  # supplementary characters. They treat <code>char</code> values from the
  # surrogate ranges as undefined characters. For example,
  # <code>Character.isLetter('&#92;uD840')</code> returns <code>false</code>, even though
  # this specific value if followed by any low-surrogate value in a string
  # would represent a letter.
  # 
  # <li>The methods that accept an <code>int</code> value support all
  # Unicode characters, including supplementary characters. For
  # example, <code>Character.isLetter(0x2F81A)</code> returns
  # <code>true</code> because the code point value represents a letter
  # (a CJK ideograph).
  # </ul>
  # 
  # <p>In the Java SE API documentation, <em>Unicode code point</em> is
  # used for character values in the range between U+0000 and U+10FFFF,
  # and <em>Unicode code unit</em> is used for 16-bit
  # <code>char</code> values that are code units of the <em>UTF-16</em>
  # encoding. For more information on Unicode terminology, refer to the
  # <a href="http://www.unicode.org/glossary/">Unicode Glossary</a>.
  # 
  # @author  Lee Boynton
  # @author  Guy Steele
  # @author  Akira Tanaka
  # @since   1.0
  class Character < CharacterImports.const_get :Object
    include_class_members CharacterImports
    overload_protected {
      include Java::Io::Serializable
      include JavaComparable
    }
    
    class_module.module_eval {
      # The minimum radix available for conversion to and from strings.
      # The constant value of this field is the smallest value permitted
      # for the radix argument in radix-conversion methods such as the
      # <code>digit</code> method, the <code>forDigit</code>
      # method, and the <code>toString</code> method of class
      # <code>Integer</code>.
      # 
      # @see     java.lang.Character#digit(char, int)
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Integer#toString(int, int)
      # @see     java.lang.Integer#valueOf(java.lang.String)
      const_set_lazy(:MIN_RADIX) { 2 }
      const_attr_reader  :MIN_RADIX
      
      # The maximum radix available for conversion to and from strings.
      # The constant value of this field is the largest value permitted
      # for the radix argument in radix-conversion methods such as the
      # <code>digit</code> method, the <code>forDigit</code>
      # method, and the <code>toString</code> method of class
      # <code>Integer</code>.
      # 
      # @see     java.lang.Character#digit(char, int)
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Integer#toString(int, int)
      # @see     java.lang.Integer#valueOf(java.lang.String)
      const_set_lazy(:MAX_RADIX) { 36 }
      const_attr_reader  :MAX_RADIX
      
      # The constant value of this field is the smallest value of type
      # <code>char</code>, <code>'&#92;u0000'</code>.
      # 
      # @since   1.0.2
      const_set_lazy(:MIN_VALUE) { Character.new(0x0000) }
      const_attr_reader  :MIN_VALUE
      
      # The constant value of this field is the largest value of type
      # <code>char</code>, <code>'&#92;uFFFF'</code>.
      # 
      # @since   1.0.2
      const_set_lazy(:MAX_VALUE) { Character.new(0xffff) }
      const_attr_reader  :MAX_VALUE
      
      # The <code>Class</code> instance representing the primitive type
      # <code>char</code>.
      # 
      # @since   1.1
      const_set_lazy(:TYPE) { Class.get_primitive_class("char") }
      const_attr_reader  :TYPE
      
      # Normative general types
      # 
      # 
      # General character types
      # 
      # 
      # General category "Cn" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:UNASSIGNED) { 0 }
      const_attr_reader  :UNASSIGNED
      
      # General category "Lu" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:UPPERCASE_LETTER) { 1 }
      const_attr_reader  :UPPERCASE_LETTER
      
      # General category "Ll" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:LOWERCASE_LETTER) { 2 }
      const_attr_reader  :LOWERCASE_LETTER
      
      # General category "Lt" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:TITLECASE_LETTER) { 3 }
      const_attr_reader  :TITLECASE_LETTER
      
      # General category "Lm" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:MODIFIER_LETTER) { 4 }
      const_attr_reader  :MODIFIER_LETTER
      
      # General category "Lo" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:OTHER_LETTER) { 5 }
      const_attr_reader  :OTHER_LETTER
      
      # General category "Mn" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:NON_SPACING_MARK) { 6 }
      const_attr_reader  :NON_SPACING_MARK
      
      # General category "Me" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:ENCLOSING_MARK) { 7 }
      const_attr_reader  :ENCLOSING_MARK
      
      # General category "Mc" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:COMBINING_SPACING_MARK) { 8 }
      const_attr_reader  :COMBINING_SPACING_MARK
      
      # General category "Nd" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:DECIMAL_DIGIT_NUMBER) { 9 }
      const_attr_reader  :DECIMAL_DIGIT_NUMBER
      
      # General category "Nl" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:LETTER_NUMBER) { 10 }
      const_attr_reader  :LETTER_NUMBER
      
      # General category "No" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:OTHER_NUMBER) { 11 }
      const_attr_reader  :OTHER_NUMBER
      
      # General category "Zs" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:SPACE_SEPARATOR) { 12 }
      const_attr_reader  :SPACE_SEPARATOR
      
      # General category "Zl" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:LINE_SEPARATOR) { 13 }
      const_attr_reader  :LINE_SEPARATOR
      
      # General category "Zp" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:PARAGRAPH_SEPARATOR) { 14 }
      const_attr_reader  :PARAGRAPH_SEPARATOR
      
      # General category "Cc" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:CONTROL) { 15 }
      const_attr_reader  :CONTROL
      
      # General category "Cf" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:FORMAT) { 16 }
      const_attr_reader  :FORMAT
      
      # General category "Co" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:PRIVATE_USE) { 18 }
      const_attr_reader  :PRIVATE_USE
      
      # General category "Cs" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:SURROGATE) { 19 }
      const_attr_reader  :SURROGATE
      
      # General category "Pd" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:DASH_PUNCTUATION) { 20 }
      const_attr_reader  :DASH_PUNCTUATION
      
      # General category "Ps" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:START_PUNCTUATION) { 21 }
      const_attr_reader  :START_PUNCTUATION
      
      # General category "Pe" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:END_PUNCTUATION) { 22 }
      const_attr_reader  :END_PUNCTUATION
      
      # General category "Pc" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:CONNECTOR_PUNCTUATION) { 23 }
      const_attr_reader  :CONNECTOR_PUNCTUATION
      
      # General category "Po" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:OTHER_PUNCTUATION) { 24 }
      const_attr_reader  :OTHER_PUNCTUATION
      
      # General category "Sm" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:MATH_SYMBOL) { 25 }
      const_attr_reader  :MATH_SYMBOL
      
      # General category "Sc" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:CURRENCY_SYMBOL) { 26 }
      const_attr_reader  :CURRENCY_SYMBOL
      
      # General category "Sk" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:MODIFIER_SYMBOL) { 27 }
      const_attr_reader  :MODIFIER_SYMBOL
      
      # General category "So" in the Unicode specification.
      # @since   1.1
      const_set_lazy(:OTHER_SYMBOL) { 28 }
      const_attr_reader  :OTHER_SYMBOL
      
      # General category "Pi" in the Unicode specification.
      # @since   1.4
      const_set_lazy(:INITIAL_QUOTE_PUNCTUATION) { 29 }
      const_attr_reader  :INITIAL_QUOTE_PUNCTUATION
      
      # General category "Pf" in the Unicode specification.
      # @since   1.4
      const_set_lazy(:FINAL_QUOTE_PUNCTUATION) { 30 }
      const_attr_reader  :FINAL_QUOTE_PUNCTUATION
      
      # Error flag. Use int (code point) to avoid confusion with U+FFFF.
      const_set_lazy(:ERROR) { -0x1 }
      const_attr_reader  :ERROR
      
      # Undefined bidirectional character type. Undefined <code>char</code>
      # values have undefined directionality in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_UNDEFINED) { -1 }
      const_attr_reader  :DIRECTIONALITY_UNDEFINED
      
      # Strong bidirectional character type "L" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_LEFT_TO_RIGHT) { 0 }
      const_attr_reader  :DIRECTIONALITY_LEFT_TO_RIGHT
      
      # Strong bidirectional character type "R" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT) { 1 }
      const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT
      
      # Strong bidirectional character type "AL" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC) { 2 }
      const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC
      
      # Weak bidirectional character type "EN" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_EUROPEAN_NUMBER) { 3 }
      const_attr_reader  :DIRECTIONALITY_EUROPEAN_NUMBER
      
      # Weak bidirectional character type "ES" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR) { 4 }
      const_attr_reader  :DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR
      
      # Weak bidirectional character type "ET" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR) { 5 }
      const_attr_reader  :DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR
      
      # Weak bidirectional character type "AN" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_ARABIC_NUMBER) { 6 }
      const_attr_reader  :DIRECTIONALITY_ARABIC_NUMBER
      
      # Weak bidirectional character type "CS" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_COMMON_NUMBER_SEPARATOR) { 7 }
      const_attr_reader  :DIRECTIONALITY_COMMON_NUMBER_SEPARATOR
      
      # Weak bidirectional character type "NSM" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_NONSPACING_MARK) { 8 }
      const_attr_reader  :DIRECTIONALITY_NONSPACING_MARK
      
      # Weak bidirectional character type "BN" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_BOUNDARY_NEUTRAL) { 9 }
      const_attr_reader  :DIRECTIONALITY_BOUNDARY_NEUTRAL
      
      # Neutral bidirectional character type "B" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_PARAGRAPH_SEPARATOR) { 10 }
      const_attr_reader  :DIRECTIONALITY_PARAGRAPH_SEPARATOR
      
      # Neutral bidirectional character type "S" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_SEGMENT_SEPARATOR) { 11 }
      const_attr_reader  :DIRECTIONALITY_SEGMENT_SEPARATOR
      
      # Neutral bidirectional character type "WS" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_WHITESPACE) { 12 }
      const_attr_reader  :DIRECTIONALITY_WHITESPACE
      
      # Neutral bidirectional character type "ON" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_OTHER_NEUTRALS) { 13 }
      const_attr_reader  :DIRECTIONALITY_OTHER_NEUTRALS
      
      # Strong bidirectional character type "LRE" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING) { 14 }
      const_attr_reader  :DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING
      
      # Strong bidirectional character type "LRO" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE) { 15 }
      const_attr_reader  :DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE
      
      # Strong bidirectional character type "RLE" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING) { 16 }
      const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING
      
      # Strong bidirectional character type "RLO" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE) { 17 }
      const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE
      
      # Weak bidirectional character type "PDF" in the Unicode specification.
      # @since 1.4
      const_set_lazy(:DIRECTIONALITY_POP_DIRECTIONAL_FORMAT) { 18 }
      const_attr_reader  :DIRECTIONALITY_POP_DIRECTIONAL_FORMAT
      
      # The minimum value of a Unicode high-surrogate code unit in the
      # UTF-16 encoding. A high-surrogate is also known as a
      # <i>leading-surrogate</i>.
      # 
      # @since 1.5
      const_set_lazy(:MIN_HIGH_SURROGATE) { Character.new(0xD800) }
      const_attr_reader  :MIN_HIGH_SURROGATE
      
      # The maximum value of a Unicode high-surrogate code unit in the
      # UTF-16 encoding. A high-surrogate is also known as a
      # <i>leading-surrogate</i>.
      # 
      # @since 1.5
      const_set_lazy(:MAX_HIGH_SURROGATE) { Character.new(0xDBFF) }
      const_attr_reader  :MAX_HIGH_SURROGATE
      
      # The minimum value of a Unicode low-surrogate code unit in the
      # UTF-16 encoding. A low-surrogate is also known as a
      # <i>trailing-surrogate</i>.
      # 
      # @since 1.5
      const_set_lazy(:MIN_LOW_SURROGATE) { Character.new(0xDC00) }
      const_attr_reader  :MIN_LOW_SURROGATE
      
      # The maximum value of a Unicode low-surrogate code unit in the
      # UTF-16 encoding. A low-surrogate is also known as a
      # <i>trailing-surrogate</i>.
      # 
      # @since 1.5
      const_set_lazy(:MAX_LOW_SURROGATE) { Character.new(0xDFFF) }
      const_attr_reader  :MAX_LOW_SURROGATE
      
      # The minimum value of a Unicode surrogate code unit in the UTF-16 encoding.
      # 
      # @since 1.5
      const_set_lazy(:MIN_SURROGATE) { MIN_HIGH_SURROGATE }
      const_attr_reader  :MIN_SURROGATE
      
      # The maximum value of a Unicode surrogate code unit in the UTF-16 encoding.
      # 
      # @since 1.5
      const_set_lazy(:MAX_SURROGATE) { MAX_LOW_SURROGATE }
      const_attr_reader  :MAX_SURROGATE
      
      # The minimum value of a supplementary code point.
      # 
      # @since 1.5
      const_set_lazy(:MIN_SUPPLEMENTARY_CODE_POINT) { 0x10000 }
      const_attr_reader  :MIN_SUPPLEMENTARY_CODE_POINT
      
      # The minimum value of a Unicode code point.
      # 
      # @since 1.5
      const_set_lazy(:MIN_CODE_POINT) { 0x0 }
      const_attr_reader  :MIN_CODE_POINT
      
      # The maximum value of a Unicode code point.
      # 
      # @since 1.5
      const_set_lazy(:MAX_CODE_POINT) { 0x10ffff }
      const_attr_reader  :MAX_CODE_POINT
      
      # Instances of this class represent particular subsets of the Unicode
      # character set.  The only family of subsets defined in the
      # <code>Character</code> class is <code>{@link Character.UnicodeBlock
      # UnicodeBlock}</code>.  Other portions of the Java API may define other
      # subsets for their own purposes.
      # 
      # @since 1.2
      const_set_lazy(:Subset) { Class.new do
        include_class_members Character
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        typesig { [self::String] }
        # Constructs a new <code>Subset</code> instance.
        # 
        # @exception NullPointerException if name is <code>null</code>
        # @param  name  The name of this subset
        def initialize(name)
          @name = nil
          if ((name).nil?)
            raise self.class::NullPointerException.new("name")
          end
          @name = name
        end
        
        typesig { [Object] }
        # Compares two <code>Subset</code> objects for equality.
        # This method returns <code>true</code> if and only if
        # <code>this</code> and the argument refer to the same
        # object; since this method is <code>final</code>, this
        # guarantee holds for all subclasses.
        def ==(obj)
          return ((self).equal?(obj))
        end
        
        typesig { [] }
        # Returns the standard hash code as defined by the
        # <code>{@link Object#hashCode}</code> method.  This method
        # is <code>final</code> in order to ensure that the
        # <code>equals</code> and <code>hashCode</code> methods will
        # be consistent in all subclasses.
        def hash_code
          return super
        end
        
        typesig { [] }
        # Returns the name of this subset.
        def to_s
          return @name
        end
        
        private
        alias_method :initialize__subset, :initialize
      end }
      
      # A family of character subsets representing the character blocks in the
      # Unicode specification. Character blocks generally define characters
      # used for a specific script or purpose. A character is contained by
      # at most one Unicode block.
      # 
      # @since 1.2
      const_set_lazy(:UnicodeBlock) { Class.new(Subset) do
        include_class_members Character
        
        class_module.module_eval {
          
          def map
            defined?(@@map) ? @@map : @@map= self.class::HashMap.new
          end
          alias_method :attr_map, :map
          
          def map=(value)
            @@map = value
          end
          alias_method :attr_map=, :map=
        }
        
        typesig { [self::String] }
        # Create a UnicodeBlock with the given identifier name.
        # This name must be the same as the block identifier.
        def initialize(id_name)
          super(id_name)
          self.attr_map.put(id_name.to_upper_case(Locale::US), self)
        end
        
        typesig { [self::String, self::String] }
        # Create a UnicodeBlock with the given identifier name and
        # alias name.
        def initialize(id_name, alias_)
          initialize__unicode_block(id_name)
          self.attr_map.put(alias_.to_upper_case(Locale::US), self)
        end
        
        typesig { [self::String, Array.typed(self::String)] }
        # Create a UnicodeBlock with the given identifier name and
        # alias names.
        def initialize(id_name, alias_name)
          initialize__unicode_block(id_name)
          if (!(alias_name).nil?)
            x = 0
            while x < alias_name.attr_length
              self.attr_map.put(alias_name[x].to_upper_case(Locale::US), self)
              (x += 1)
            end
          end
        end
        
        class_module.module_eval {
          # Constant for the "Basic Latin" Unicode character block.
          # @since 1.2
          const_set_lazy(:BASIC_LATIN) { self.class::UnicodeBlock.new("BASIC_LATIN", Array.typed(self.class::String).new(["Basic Latin", "BasicLatin"])) }
          const_attr_reader  :BASIC_LATIN
          
          # Constant for the "Latin-1 Supplement" Unicode character block.
          # @since 1.2
          const_set_lazy(:LATIN_1_SUPPLEMENT) { self.class::UnicodeBlock.new("LATIN_1_SUPPLEMENT", Array.typed(self.class::String).new(["Latin-1 Supplement", "Latin-1Supplement"])) }
          const_attr_reader  :LATIN_1_SUPPLEMENT
          
          # Constant for the "Latin Extended-A" Unicode character block.
          # @since 1.2
          const_set_lazy(:LATIN_EXTENDED_A) { self.class::UnicodeBlock.new("LATIN_EXTENDED_A", Array.typed(self.class::String).new(["Latin Extended-A", "LatinExtended-A"])) }
          const_attr_reader  :LATIN_EXTENDED_A
          
          # Constant for the "Latin Extended-B" Unicode character block.
          # @since 1.2
          const_set_lazy(:LATIN_EXTENDED_B) { self.class::UnicodeBlock.new("LATIN_EXTENDED_B", Array.typed(self.class::String).new(["Latin Extended-B", "LatinExtended-B"])) }
          const_attr_reader  :LATIN_EXTENDED_B
          
          # Constant for the "IPA Extensions" Unicode character block.
          # @since 1.2
          const_set_lazy(:IPA_EXTENSIONS) { self.class::UnicodeBlock.new("IPA_EXTENSIONS", Array.typed(self.class::String).new(["IPA Extensions", "IPAExtensions"])) }
          const_attr_reader  :IPA_EXTENSIONS
          
          # Constant for the "Spacing Modifier Letters" Unicode character block.
          # @since 1.2
          const_set_lazy(:SPACING_MODIFIER_LETTERS) { self.class::UnicodeBlock.new("SPACING_MODIFIER_LETTERS", Array.typed(self.class::String).new(["Spacing Modifier Letters", "SpacingModifierLetters"])) }
          const_attr_reader  :SPACING_MODIFIER_LETTERS
          
          # Constant for the "Combining Diacritical Marks" Unicode character block.
          # @since 1.2
          const_set_lazy(:COMBINING_DIACRITICAL_MARKS) { self.class::UnicodeBlock.new("COMBINING_DIACRITICAL_MARKS", Array.typed(self.class::String).new(["Combining Diacritical Marks", "CombiningDiacriticalMarks"])) }
          const_attr_reader  :COMBINING_DIACRITICAL_MARKS
          
          # Constant for the "Greek and Coptic" Unicode character block.
          # <p>
          # This block was previously known as the "Greek" block.
          # 
          # @since 1.2
          const_set_lazy(:GREEK) { self.class::UnicodeBlock.new("GREEK", Array.typed(self.class::String).new(["Greek and Coptic", "GreekandCoptic"])) }
          const_attr_reader  :GREEK
          
          # Constant for the "Cyrillic" Unicode character block.
          # @since 1.2
          const_set_lazy(:CYRILLIC) { self.class::UnicodeBlock.new("CYRILLIC") }
          const_attr_reader  :CYRILLIC
          
          # Constant for the "Armenian" Unicode character block.
          # @since 1.2
          const_set_lazy(:ARMENIAN) { self.class::UnicodeBlock.new("ARMENIAN") }
          const_attr_reader  :ARMENIAN
          
          # Constant for the "Hebrew" Unicode character block.
          # @since 1.2
          const_set_lazy(:HEBREW) { self.class::UnicodeBlock.new("HEBREW") }
          const_attr_reader  :HEBREW
          
          # Constant for the "Arabic" Unicode character block.
          # @since 1.2
          const_set_lazy(:ARABIC) { self.class::UnicodeBlock.new("ARABIC") }
          const_attr_reader  :ARABIC
          
          # Constant for the "Devanagari" Unicode character block.
          # @since 1.2
          const_set_lazy(:DEVANAGARI) { self.class::UnicodeBlock.new("DEVANAGARI") }
          const_attr_reader  :DEVANAGARI
          
          # Constant for the "Bengali" Unicode character block.
          # @since 1.2
          const_set_lazy(:BENGALI) { self.class::UnicodeBlock.new("BENGALI") }
          const_attr_reader  :BENGALI
          
          # Constant for the "Gurmukhi" Unicode character block.
          # @since 1.2
          const_set_lazy(:GURMUKHI) { self.class::UnicodeBlock.new("GURMUKHI") }
          const_attr_reader  :GURMUKHI
          
          # Constant for the "Gujarati" Unicode character block.
          # @since 1.2
          const_set_lazy(:GUJARATI) { self.class::UnicodeBlock.new("GUJARATI") }
          const_attr_reader  :GUJARATI
          
          # Constant for the "Oriya" Unicode character block.
          # @since 1.2
          const_set_lazy(:ORIYA) { self.class::UnicodeBlock.new("ORIYA") }
          const_attr_reader  :ORIYA
          
          # Constant for the "Tamil" Unicode character block.
          # @since 1.2
          const_set_lazy(:TAMIL) { self.class::UnicodeBlock.new("TAMIL") }
          const_attr_reader  :TAMIL
          
          # Constant for the "Telugu" Unicode character block.
          # @since 1.2
          const_set_lazy(:TELUGU) { self.class::UnicodeBlock.new("TELUGU") }
          const_attr_reader  :TELUGU
          
          # Constant for the "Kannada" Unicode character block.
          # @since 1.2
          const_set_lazy(:KANNADA) { self.class::UnicodeBlock.new("KANNADA") }
          const_attr_reader  :KANNADA
          
          # Constant for the "Malayalam" Unicode character block.
          # @since 1.2
          const_set_lazy(:MALAYALAM) { self.class::UnicodeBlock.new("MALAYALAM") }
          const_attr_reader  :MALAYALAM
          
          # Constant for the "Thai" Unicode character block.
          # @since 1.2
          const_set_lazy(:THAI) { self.class::UnicodeBlock.new("THAI") }
          const_attr_reader  :THAI
          
          # Constant for the "Lao" Unicode character block.
          # @since 1.2
          const_set_lazy(:LAO) { self.class::UnicodeBlock.new("LAO") }
          const_attr_reader  :LAO
          
          # Constant for the "Tibetan" Unicode character block.
          # @since 1.2
          const_set_lazy(:TIBETAN) { self.class::UnicodeBlock.new("TIBETAN") }
          const_attr_reader  :TIBETAN
          
          # Constant for the "Georgian" Unicode character block.
          # @since 1.2
          const_set_lazy(:GEORGIAN) { self.class::UnicodeBlock.new("GEORGIAN") }
          const_attr_reader  :GEORGIAN
          
          # Constant for the "Hangul Jamo" Unicode character block.
          # @since 1.2
          const_set_lazy(:HANGUL_JAMO) { self.class::UnicodeBlock.new("HANGUL_JAMO", Array.typed(self.class::String).new(["Hangul Jamo", "HangulJamo"])) }
          const_attr_reader  :HANGUL_JAMO
          
          # Constant for the "Latin Extended Additional" Unicode character block.
          # @since 1.2
          const_set_lazy(:LATIN_EXTENDED_ADDITIONAL) { self.class::UnicodeBlock.new("LATIN_EXTENDED_ADDITIONAL", Array.typed(self.class::String).new(["Latin Extended Additional", "LatinExtendedAdditional"])) }
          const_attr_reader  :LATIN_EXTENDED_ADDITIONAL
          
          # Constant for the "Greek Extended" Unicode character block.
          # @since 1.2
          const_set_lazy(:GREEK_EXTENDED) { self.class::UnicodeBlock.new("GREEK_EXTENDED", Array.typed(self.class::String).new(["Greek Extended", "GreekExtended"])) }
          const_attr_reader  :GREEK_EXTENDED
          
          # Constant for the "General Punctuation" Unicode character block.
          # @since 1.2
          const_set_lazy(:GENERAL_PUNCTUATION) { self.class::UnicodeBlock.new("GENERAL_PUNCTUATION", Array.typed(self.class::String).new(["General Punctuation", "GeneralPunctuation"])) }
          const_attr_reader  :GENERAL_PUNCTUATION
          
          # Constant for the "Superscripts and Subscripts" Unicode character block.
          # @since 1.2
          const_set_lazy(:SUPERSCRIPTS_AND_SUBSCRIPTS) { self.class::UnicodeBlock.new("SUPERSCRIPTS_AND_SUBSCRIPTS", Array.typed(self.class::String).new(["Superscripts and Subscripts", "SuperscriptsandSubscripts"])) }
          const_attr_reader  :SUPERSCRIPTS_AND_SUBSCRIPTS
          
          # Constant for the "Currency Symbols" Unicode character block.
          # @since 1.2
          const_set_lazy(:CURRENCY_SYMBOLS) { self.class::UnicodeBlock.new("CURRENCY_SYMBOLS", Array.typed(self.class::String).new(["Currency Symbols", "CurrencySymbols"])) }
          const_attr_reader  :CURRENCY_SYMBOLS
          
          # Constant for the "Combining Diacritical Marks for Symbols" Unicode character block.
          # <p>
          # This block was previously known as "Combining Marks for Symbols".
          # @since 1.2
          const_set_lazy(:COMBINING_MARKS_FOR_SYMBOLS) { self.class::UnicodeBlock.new("COMBINING_MARKS_FOR_SYMBOLS", Array.typed(self.class::String).new(["Combining Diacritical Marks for Symbols", "CombiningDiacriticalMarksforSymbols", "Combining Marks for Symbols", "CombiningMarksforSymbols"])) }
          const_attr_reader  :COMBINING_MARKS_FOR_SYMBOLS
          
          # Constant for the "Letterlike Symbols" Unicode character block.
          # @since 1.2
          const_set_lazy(:LETTERLIKE_SYMBOLS) { self.class::UnicodeBlock.new("LETTERLIKE_SYMBOLS", Array.typed(self.class::String).new(["Letterlike Symbols", "LetterlikeSymbols"])) }
          const_attr_reader  :LETTERLIKE_SYMBOLS
          
          # Constant for the "Number Forms" Unicode character block.
          # @since 1.2
          const_set_lazy(:NUMBER_FORMS) { self.class::UnicodeBlock.new("NUMBER_FORMS", Array.typed(self.class::String).new(["Number Forms", "NumberForms"])) }
          const_attr_reader  :NUMBER_FORMS
          
          # Constant for the "Arrows" Unicode character block.
          # @since 1.2
          const_set_lazy(:ARROWS) { self.class::UnicodeBlock.new("ARROWS") }
          const_attr_reader  :ARROWS
          
          # Constant for the "Mathematical Operators" Unicode character block.
          # @since 1.2
          const_set_lazy(:MATHEMATICAL_OPERATORS) { self.class::UnicodeBlock.new("MATHEMATICAL_OPERATORS", Array.typed(self.class::String).new(["Mathematical Operators", "MathematicalOperators"])) }
          const_attr_reader  :MATHEMATICAL_OPERATORS
          
          # Constant for the "Miscellaneous Technical" Unicode character block.
          # @since 1.2
          const_set_lazy(:MISCELLANEOUS_TECHNICAL) { self.class::UnicodeBlock.new("MISCELLANEOUS_TECHNICAL", Array.typed(self.class::String).new(["Miscellaneous Technical", "MiscellaneousTechnical"])) }
          const_attr_reader  :MISCELLANEOUS_TECHNICAL
          
          # Constant for the "Control Pictures" Unicode character block.
          # @since 1.2
          const_set_lazy(:CONTROL_PICTURES) { self.class::UnicodeBlock.new("CONTROL_PICTURES", Array.typed(self.class::String).new(["Control Pictures", "ControlPictures"])) }
          const_attr_reader  :CONTROL_PICTURES
          
          # Constant for the "Optical Character Recognition" Unicode character block.
          # @since 1.2
          const_set_lazy(:OPTICAL_CHARACTER_RECOGNITION) { self.class::UnicodeBlock.new("OPTICAL_CHARACTER_RECOGNITION", Array.typed(self.class::String).new(["Optical Character Recognition", "OpticalCharacterRecognition"])) }
          const_attr_reader  :OPTICAL_CHARACTER_RECOGNITION
          
          # Constant for the "Enclosed Alphanumerics" Unicode character block.
          # @since 1.2
          const_set_lazy(:ENCLOSED_ALPHANUMERICS) { self.class::UnicodeBlock.new("ENCLOSED_ALPHANUMERICS", Array.typed(self.class::String).new(["Enclosed Alphanumerics", "EnclosedAlphanumerics"])) }
          const_attr_reader  :ENCLOSED_ALPHANUMERICS
          
          # Constant for the "Box Drawing" Unicode character block.
          # @since 1.2
          const_set_lazy(:BOX_DRAWING) { self.class::UnicodeBlock.new("BOX_DRAWING", Array.typed(self.class::String).new(["Box Drawing", "BoxDrawing"])) }
          const_attr_reader  :BOX_DRAWING
          
          # Constant for the "Block Elements" Unicode character block.
          # @since 1.2
          const_set_lazy(:BLOCK_ELEMENTS) { self.class::UnicodeBlock.new("BLOCK_ELEMENTS", Array.typed(self.class::String).new(["Block Elements", "BlockElements"])) }
          const_attr_reader  :BLOCK_ELEMENTS
          
          # Constant for the "Geometric Shapes" Unicode character block.
          # @since 1.2
          const_set_lazy(:GEOMETRIC_SHAPES) { self.class::UnicodeBlock.new("GEOMETRIC_SHAPES", Array.typed(self.class::String).new(["Geometric Shapes", "GeometricShapes"])) }
          const_attr_reader  :GEOMETRIC_SHAPES
          
          # Constant for the "Miscellaneous Symbols" Unicode character block.
          # @since 1.2
          const_set_lazy(:MISCELLANEOUS_SYMBOLS) { self.class::UnicodeBlock.new("MISCELLANEOUS_SYMBOLS", Array.typed(self.class::String).new(["Miscellaneous Symbols", "MiscellaneousSymbols"])) }
          const_attr_reader  :MISCELLANEOUS_SYMBOLS
          
          # Constant for the "Dingbats" Unicode character block.
          # @since 1.2
          const_set_lazy(:DINGBATS) { self.class::UnicodeBlock.new("DINGBATS") }
          const_attr_reader  :DINGBATS
          
          # Constant for the "CJK Symbols and Punctuation" Unicode character block.
          # @since 1.2
          const_set_lazy(:CJK_SYMBOLS_AND_PUNCTUATION) { self.class::UnicodeBlock.new("CJK_SYMBOLS_AND_PUNCTUATION", Array.typed(self.class::String).new(["CJK Symbols and Punctuation", "CJKSymbolsandPunctuation"])) }
          const_attr_reader  :CJK_SYMBOLS_AND_PUNCTUATION
          
          # Constant for the "Hiragana" Unicode character block.
          # @since 1.2
          const_set_lazy(:HIRAGANA) { self.class::UnicodeBlock.new("HIRAGANA") }
          const_attr_reader  :HIRAGANA
          
          # Constant for the "Katakana" Unicode character block.
          # @since 1.2
          const_set_lazy(:KATAKANA) { self.class::UnicodeBlock.new("KATAKANA") }
          const_attr_reader  :KATAKANA
          
          # Constant for the "Bopomofo" Unicode character block.
          # @since 1.2
          const_set_lazy(:BOPOMOFO) { self.class::UnicodeBlock.new("BOPOMOFO") }
          const_attr_reader  :BOPOMOFO
          
          # Constant for the "Hangul Compatibility Jamo" Unicode character block.
          # @since 1.2
          const_set_lazy(:HANGUL_COMPATIBILITY_JAMO) { self.class::UnicodeBlock.new("HANGUL_COMPATIBILITY_JAMO", Array.typed(self.class::String).new(["Hangul Compatibility Jamo", "HangulCompatibilityJamo"])) }
          const_attr_reader  :HANGUL_COMPATIBILITY_JAMO
          
          # Constant for the "Kanbun" Unicode character block.
          # @since 1.2
          const_set_lazy(:KANBUN) { self.class::UnicodeBlock.new("KANBUN") }
          const_attr_reader  :KANBUN
          
          # Constant for the "Enclosed CJK Letters and Months" Unicode character block.
          # @since 1.2
          const_set_lazy(:ENCLOSED_CJK_LETTERS_AND_MONTHS) { self.class::UnicodeBlock.new("ENCLOSED_CJK_LETTERS_AND_MONTHS", Array.typed(self.class::String).new(["Enclosed CJK Letters and Months", "EnclosedCJKLettersandMonths"])) }
          const_attr_reader  :ENCLOSED_CJK_LETTERS_AND_MONTHS
          
          # Constant for the "CJK Compatibility" Unicode character block.
          # @since 1.2
          const_set_lazy(:CJK_COMPATIBILITY) { self.class::UnicodeBlock.new("CJK_COMPATIBILITY", Array.typed(self.class::String).new(["CJK Compatibility", "CJKCompatibility"])) }
          const_attr_reader  :CJK_COMPATIBILITY
          
          # Constant for the "CJK Unified Ideographs" Unicode character block.
          # @since 1.2
          const_set_lazy(:CJK_UNIFIED_IDEOGRAPHS) { self.class::UnicodeBlock.new("CJK_UNIFIED_IDEOGRAPHS", Array.typed(self.class::String).new(["CJK Unified Ideographs", "CJKUnifiedIdeographs"])) }
          const_attr_reader  :CJK_UNIFIED_IDEOGRAPHS
          
          # Constant for the "Hangul Syllables" Unicode character block.
          # @since 1.2
          const_set_lazy(:HANGUL_SYLLABLES) { self.class::UnicodeBlock.new("HANGUL_SYLLABLES", Array.typed(self.class::String).new(["Hangul Syllables", "HangulSyllables"])) }
          const_attr_reader  :HANGUL_SYLLABLES
          
          # Constant for the "Private Use Area" Unicode character block.
          # @since 1.2
          const_set_lazy(:PRIVATE_USE_AREA) { self.class::UnicodeBlock.new("PRIVATE_USE_AREA", Array.typed(self.class::String).new(["Private Use Area", "PrivateUseArea"])) }
          const_attr_reader  :PRIVATE_USE_AREA
          
          # Constant for the "CJK Compatibility Ideographs" Unicode character block.
          # @since 1.2
          const_set_lazy(:CJK_COMPATIBILITY_IDEOGRAPHS) { self.class::UnicodeBlock.new("CJK_COMPATIBILITY_IDEOGRAPHS", Array.typed(self.class::String).new(["CJK Compatibility Ideographs", "CJKCompatibilityIdeographs"])) }
          const_attr_reader  :CJK_COMPATIBILITY_IDEOGRAPHS
          
          # Constant for the "Alphabetic Presentation Forms" Unicode character block.
          # @since 1.2
          const_set_lazy(:ALPHABETIC_PRESENTATION_FORMS) { self.class::UnicodeBlock.new("ALPHABETIC_PRESENTATION_FORMS", Array.typed(self.class::String).new(["Alphabetic Presentation Forms", "AlphabeticPresentationForms"])) }
          const_attr_reader  :ALPHABETIC_PRESENTATION_FORMS
          
          # Constant for the "Arabic Presentation Forms-A" Unicode character block.
          # @since 1.2
          const_set_lazy(:ARABIC_PRESENTATION_FORMS_A) { self.class::UnicodeBlock.new("ARABIC_PRESENTATION_FORMS_A", Array.typed(self.class::String).new(["Arabic Presentation Forms-A", "ArabicPresentationForms-A"])) }
          const_attr_reader  :ARABIC_PRESENTATION_FORMS_A
          
          # Constant for the "Combining Half Marks" Unicode character block.
          # @since 1.2
          const_set_lazy(:COMBINING_HALF_MARKS) { self.class::UnicodeBlock.new("COMBINING_HALF_MARKS", Array.typed(self.class::String).new(["Combining Half Marks", "CombiningHalfMarks"])) }
          const_attr_reader  :COMBINING_HALF_MARKS
          
          # Constant for the "CJK Compatibility Forms" Unicode character block.
          # @since 1.2
          const_set_lazy(:CJK_COMPATIBILITY_FORMS) { self.class::UnicodeBlock.new("CJK_COMPATIBILITY_FORMS", Array.typed(self.class::String).new(["CJK Compatibility Forms", "CJKCompatibilityForms"])) }
          const_attr_reader  :CJK_COMPATIBILITY_FORMS
          
          # Constant for the "Small Form Variants" Unicode character block.
          # @since 1.2
          const_set_lazy(:SMALL_FORM_VARIANTS) { self.class::UnicodeBlock.new("SMALL_FORM_VARIANTS", Array.typed(self.class::String).new(["Small Form Variants", "SmallFormVariants"])) }
          const_attr_reader  :SMALL_FORM_VARIANTS
          
          # Constant for the "Arabic Presentation Forms-B" Unicode character block.
          # @since 1.2
          const_set_lazy(:ARABIC_PRESENTATION_FORMS_B) { self.class::UnicodeBlock.new("ARABIC_PRESENTATION_FORMS_B", Array.typed(self.class::String).new(["Arabic Presentation Forms-B", "ArabicPresentationForms-B"])) }
          const_attr_reader  :ARABIC_PRESENTATION_FORMS_B
          
          # Constant for the "Halfwidth and Fullwidth Forms" Unicode character block.
          # @since 1.2
          const_set_lazy(:HALFWIDTH_AND_FULLWIDTH_FORMS) { self.class::UnicodeBlock.new("HALFWIDTH_AND_FULLWIDTH_FORMS", Array.typed(self.class::String).new(["Halfwidth and Fullwidth Forms", "HalfwidthandFullwidthForms"])) }
          const_attr_reader  :HALFWIDTH_AND_FULLWIDTH_FORMS
          
          # Constant for the "Specials" Unicode character block.
          # @since 1.2
          const_set_lazy(:SPECIALS) { self.class::UnicodeBlock.new("SPECIALS") }
          const_attr_reader  :SPECIALS
          
          # @deprecated As of J2SE 5, use {@link #HIGH_SURROGATES},
          # {@link #HIGH_PRIVATE_USE_SURROGATES}, and
          # {@link #LOW_SURROGATES}. These new constants match
          # the block definitions of the Unicode Standard.
          # The {@link #of(char)} and {@link #of(int)} methods
          # return the new constants, not SURROGATES_AREA.
          const_set_lazy(:SURROGATES_AREA) { self.class::UnicodeBlock.new("SURROGATES_AREA") }
          const_attr_reader  :SURROGATES_AREA
          
          # Constant for the "Syriac" Unicode character block.
          # @since 1.4
          const_set_lazy(:SYRIAC) { self.class::UnicodeBlock.new("SYRIAC") }
          const_attr_reader  :SYRIAC
          
          # Constant for the "Thaana" Unicode character block.
          # @since 1.4
          const_set_lazy(:THAANA) { self.class::UnicodeBlock.new("THAANA") }
          const_attr_reader  :THAANA
          
          # Constant for the "Sinhala" Unicode character block.
          # @since 1.4
          const_set_lazy(:SINHALA) { self.class::UnicodeBlock.new("SINHALA") }
          const_attr_reader  :SINHALA
          
          # Constant for the "Myanmar" Unicode character block.
          # @since 1.4
          const_set_lazy(:MYANMAR) { self.class::UnicodeBlock.new("MYANMAR") }
          const_attr_reader  :MYANMAR
          
          # Constant for the "Ethiopic" Unicode character block.
          # @since 1.4
          const_set_lazy(:ETHIOPIC) { self.class::UnicodeBlock.new("ETHIOPIC") }
          const_attr_reader  :ETHIOPIC
          
          # Constant for the "Cherokee" Unicode character block.
          # @since 1.4
          const_set_lazy(:CHEROKEE) { self.class::UnicodeBlock.new("CHEROKEE") }
          const_attr_reader  :CHEROKEE
          
          # Constant for the "Unified Canadian Aboriginal Syllabics" Unicode character block.
          # @since 1.4
          const_set_lazy(:UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS) { self.class::UnicodeBlock.new("UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS", Array.typed(self.class::String).new(["Unified Canadian Aboriginal Syllabics", "UnifiedCanadianAboriginalSyllabics"])) }
          const_attr_reader  :UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS
          
          # Constant for the "Ogham" Unicode character block.
          # @since 1.4
          const_set_lazy(:OGHAM) { self.class::UnicodeBlock.new("OGHAM") }
          const_attr_reader  :OGHAM
          
          # Constant for the "Runic" Unicode character block.
          # @since 1.4
          const_set_lazy(:RUNIC) { self.class::UnicodeBlock.new("RUNIC") }
          const_attr_reader  :RUNIC
          
          # Constant for the "Khmer" Unicode character block.
          # @since 1.4
          const_set_lazy(:KHMER) { self.class::UnicodeBlock.new("KHMER") }
          const_attr_reader  :KHMER
          
          # Constant for the "Mongolian" Unicode character block.
          # @since 1.4
          const_set_lazy(:MONGOLIAN) { self.class::UnicodeBlock.new("MONGOLIAN") }
          const_attr_reader  :MONGOLIAN
          
          # Constant for the "Braille Patterns" Unicode character block.
          # @since 1.4
          const_set_lazy(:BRAILLE_PATTERNS) { self.class::UnicodeBlock.new("BRAILLE_PATTERNS", Array.typed(self.class::String).new(["Braille Patterns", "BraillePatterns"])) }
          const_attr_reader  :BRAILLE_PATTERNS
          
          # Constant for the "CJK Radicals Supplement" Unicode character block.
          # @since 1.4
          const_set_lazy(:CJK_RADICALS_SUPPLEMENT) { self.class::UnicodeBlock.new("CJK_RADICALS_SUPPLEMENT", Array.typed(self.class::String).new(["CJK Radicals Supplement", "CJKRadicalsSupplement"])) }
          const_attr_reader  :CJK_RADICALS_SUPPLEMENT
          
          # Constant for the "Kangxi Radicals" Unicode character block.
          # @since 1.4
          const_set_lazy(:KANGXI_RADICALS) { self.class::UnicodeBlock.new("KANGXI_RADICALS", Array.typed(self.class::String).new(["Kangxi Radicals", "KangxiRadicals"])) }
          const_attr_reader  :KANGXI_RADICALS
          
          # Constant for the "Ideographic Description Characters" Unicode character block.
          # @since 1.4
          const_set_lazy(:IDEOGRAPHIC_DESCRIPTION_CHARACTERS) { self.class::UnicodeBlock.new("IDEOGRAPHIC_DESCRIPTION_CHARACTERS", Array.typed(self.class::String).new(["Ideographic Description Characters", "IdeographicDescriptionCharacters"])) }
          const_attr_reader  :IDEOGRAPHIC_DESCRIPTION_CHARACTERS
          
          # Constant for the "Bopomofo Extended" Unicode character block.
          # @since 1.4
          const_set_lazy(:BOPOMOFO_EXTENDED) { self.class::UnicodeBlock.new("BOPOMOFO_EXTENDED", Array.typed(self.class::String).new(["Bopomofo Extended", "BopomofoExtended"])) }
          const_attr_reader  :BOPOMOFO_EXTENDED
          
          # Constant for the "CJK Unified Ideographs Extension A" Unicode character block.
          # @since 1.4
          const_set_lazy(:CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A) { self.class::UnicodeBlock.new("CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A", Array.typed(self.class::String).new(["CJK Unified Ideographs Extension A", "CJKUnifiedIdeographsExtensionA"])) }
          const_attr_reader  :CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
          
          # Constant for the "Yi Syllables" Unicode character block.
          # @since 1.4
          const_set_lazy(:YI_SYLLABLES) { self.class::UnicodeBlock.new("YI_SYLLABLES", Array.typed(self.class::String).new(["Yi Syllables", "YiSyllables"])) }
          const_attr_reader  :YI_SYLLABLES
          
          # Constant for the "Yi Radicals" Unicode character block.
          # @since 1.4
          const_set_lazy(:YI_RADICALS) { self.class::UnicodeBlock.new("YI_RADICALS", Array.typed(self.class::String).new(["Yi Radicals", "YiRadicals"])) }
          const_attr_reader  :YI_RADICALS
          
          # Constant for the "Cyrillic Supplementary" Unicode character block.
          # @since 1.5
          const_set_lazy(:CYRILLIC_SUPPLEMENTARY) { self.class::UnicodeBlock.new("CYRILLIC_SUPPLEMENTARY", Array.typed(self.class::String).new(["Cyrillic Supplementary", "CyrillicSupplementary"])) }
          const_attr_reader  :CYRILLIC_SUPPLEMENTARY
          
          # Constant for the "Tagalog" Unicode character block.
          # @since 1.5
          const_set_lazy(:TAGALOG) { self.class::UnicodeBlock.new("TAGALOG") }
          const_attr_reader  :TAGALOG
          
          # Constant for the "Hanunoo" Unicode character block.
          # @since 1.5
          const_set_lazy(:HANUNOO) { self.class::UnicodeBlock.new("HANUNOO") }
          const_attr_reader  :HANUNOO
          
          # Constant for the "Buhid" Unicode character block.
          # @since 1.5
          const_set_lazy(:BUHID) { self.class::UnicodeBlock.new("BUHID") }
          const_attr_reader  :BUHID
          
          # Constant for the "Tagbanwa" Unicode character block.
          # @since 1.5
          const_set_lazy(:TAGBANWA) { self.class::UnicodeBlock.new("TAGBANWA") }
          const_attr_reader  :TAGBANWA
          
          # Constant for the "Limbu" Unicode character block.
          # @since 1.5
          const_set_lazy(:LIMBU) { self.class::UnicodeBlock.new("LIMBU") }
          const_attr_reader  :LIMBU
          
          # Constant for the "Tai Le" Unicode character block.
          # @since 1.5
          const_set_lazy(:TAI_LE) { self.class::UnicodeBlock.new("TAI_LE", Array.typed(self.class::String).new(["Tai Le", "TaiLe"])) }
          const_attr_reader  :TAI_LE
          
          # Constant for the "Khmer Symbols" Unicode character block.
          # @since 1.5
          const_set_lazy(:KHMER_SYMBOLS) { self.class::UnicodeBlock.new("KHMER_SYMBOLS", Array.typed(self.class::String).new(["Khmer Symbols", "KhmerSymbols"])) }
          const_attr_reader  :KHMER_SYMBOLS
          
          # Constant for the "Phonetic Extensions" Unicode character block.
          # @since 1.5
          const_set_lazy(:PHONETIC_EXTENSIONS) { self.class::UnicodeBlock.new("PHONETIC_EXTENSIONS", Array.typed(self.class::String).new(["Phonetic Extensions", "PhoneticExtensions"])) }
          const_attr_reader  :PHONETIC_EXTENSIONS
          
          # Constant for the "Miscellaneous Mathematical Symbols-A" Unicode character block.
          # @since 1.5
          const_set_lazy(:MISCELLANEOUS_MATHEMATICAL_SYMBOLS_A) { self.class::UnicodeBlock.new("MISCELLANEOUS_MATHEMATICAL_SYMBOLS_A", Array.typed(self.class::String).new(["Miscellaneous Mathematical Symbols-A", "MiscellaneousMathematicalSymbols-A"])) }
          const_attr_reader  :MISCELLANEOUS_MATHEMATICAL_SYMBOLS_A
          
          # Constant for the "Supplemental Arrows-A" Unicode character block.
          # @since 1.5
          const_set_lazy(:SUPPLEMENTAL_ARROWS_A) { self.class::UnicodeBlock.new("SUPPLEMENTAL_ARROWS_A", Array.typed(self.class::String).new(["Supplemental Arrows-A", "SupplementalArrows-A"])) }
          const_attr_reader  :SUPPLEMENTAL_ARROWS_A
          
          # Constant for the "Supplemental Arrows-B" Unicode character block.
          # @since 1.5
          const_set_lazy(:SUPPLEMENTAL_ARROWS_B) { self.class::UnicodeBlock.new("SUPPLEMENTAL_ARROWS_B", Array.typed(self.class::String).new(["Supplemental Arrows-B", "SupplementalArrows-B"])) }
          const_attr_reader  :SUPPLEMENTAL_ARROWS_B
          
          # Constant for the "Miscellaneous Mathematical Symbols-B" Unicode character block.
          # @since 1.5
          const_set_lazy(:MISCELLANEOUS_MATHEMATICAL_SYMBOLS_B) { self.class::UnicodeBlock.new("MISCELLANEOUS_MATHEMATICAL_SYMBOLS_B", Array.typed(self.class::String).new(["Miscellaneous Mathematical Symbols-B", "MiscellaneousMathematicalSymbols-B"])) }
          const_attr_reader  :MISCELLANEOUS_MATHEMATICAL_SYMBOLS_B
          
          # Constant for the "Supplemental Mathematical Operators" Unicode character block.
          # @since 1.5
          const_set_lazy(:SUPPLEMENTAL_MATHEMATICAL_OPERATORS) { self.class::UnicodeBlock.new("SUPPLEMENTAL_MATHEMATICAL_OPERATORS", Array.typed(self.class::String).new(["Supplemental Mathematical Operators", "SupplementalMathematicalOperators"])) }
          const_attr_reader  :SUPPLEMENTAL_MATHEMATICAL_OPERATORS
          
          # Constant for the "Miscellaneous Symbols and Arrows" Unicode character block.
          # @since 1.5
          const_set_lazy(:MISCELLANEOUS_SYMBOLS_AND_ARROWS) { self.class::UnicodeBlock.new("MISCELLANEOUS_SYMBOLS_AND_ARROWS", Array.typed(self.class::String).new(["Miscellaneous Symbols and Arrows", "MiscellaneousSymbolsandArrows"])) }
          const_attr_reader  :MISCELLANEOUS_SYMBOLS_AND_ARROWS
          
          # Constant for the "Katakana Phonetic Extensions" Unicode character block.
          # @since 1.5
          const_set_lazy(:KATAKANA_PHONETIC_EXTENSIONS) { self.class::UnicodeBlock.new("KATAKANA_PHONETIC_EXTENSIONS", Array.typed(self.class::String).new(["Katakana Phonetic Extensions", "KatakanaPhoneticExtensions"])) }
          const_attr_reader  :KATAKANA_PHONETIC_EXTENSIONS
          
          # Constant for the "Yijing Hexagram Symbols" Unicode character block.
          # @since 1.5
          const_set_lazy(:YIJING_HEXAGRAM_SYMBOLS) { self.class::UnicodeBlock.new("YIJING_HEXAGRAM_SYMBOLS", Array.typed(self.class::String).new(["Yijing Hexagram Symbols", "YijingHexagramSymbols"])) }
          const_attr_reader  :YIJING_HEXAGRAM_SYMBOLS
          
          # Constant for the "Variation Selectors" Unicode character block.
          # @since 1.5
          const_set_lazy(:VARIATION_SELECTORS) { self.class::UnicodeBlock.new("VARIATION_SELECTORS", Array.typed(self.class::String).new(["Variation Selectors", "VariationSelectors"])) }
          const_attr_reader  :VARIATION_SELECTORS
          
          # Constant for the "Linear B Syllabary" Unicode character block.
          # @since 1.5
          const_set_lazy(:LINEAR_B_SYLLABARY) { self.class::UnicodeBlock.new("LINEAR_B_SYLLABARY", Array.typed(self.class::String).new(["Linear B Syllabary", "LinearBSyllabary"])) }
          const_attr_reader  :LINEAR_B_SYLLABARY
          
          # Constant for the "Linear B Ideograms" Unicode character block.
          # @since 1.5
          const_set_lazy(:LINEAR_B_IDEOGRAMS) { self.class::UnicodeBlock.new("LINEAR_B_IDEOGRAMS", Array.typed(self.class::String).new(["Linear B Ideograms", "LinearBIdeograms"])) }
          const_attr_reader  :LINEAR_B_IDEOGRAMS
          
          # Constant for the "Aegean Numbers" Unicode character block.
          # @since 1.5
          const_set_lazy(:AEGEAN_NUMBERS) { self.class::UnicodeBlock.new("AEGEAN_NUMBERS", Array.typed(self.class::String).new(["Aegean Numbers", "AegeanNumbers"])) }
          const_attr_reader  :AEGEAN_NUMBERS
          
          # Constant for the "Old Italic" Unicode character block.
          # @since 1.5
          const_set_lazy(:OLD_ITALIC) { self.class::UnicodeBlock.new("OLD_ITALIC", Array.typed(self.class::String).new(["Old Italic", "OldItalic"])) }
          const_attr_reader  :OLD_ITALIC
          
          # Constant for the "Gothic" Unicode character block.
          # @since 1.5
          const_set_lazy(:GOTHIC) { self.class::UnicodeBlock.new("GOTHIC") }
          const_attr_reader  :GOTHIC
          
          # Constant for the "Ugaritic" Unicode character block.
          # @since 1.5
          const_set_lazy(:UGARITIC) { self.class::UnicodeBlock.new("UGARITIC") }
          const_attr_reader  :UGARITIC
          
          # Constant for the "Deseret" Unicode character block.
          # @since 1.5
          const_set_lazy(:DESERET) { self.class::UnicodeBlock.new("DESERET") }
          const_attr_reader  :DESERET
          
          # Constant for the "Shavian" Unicode character block.
          # @since 1.5
          const_set_lazy(:SHAVIAN) { self.class::UnicodeBlock.new("SHAVIAN") }
          const_attr_reader  :SHAVIAN
          
          # Constant for the "Osmanya" Unicode character block.
          # @since 1.5
          const_set_lazy(:OSMANYA) { self.class::UnicodeBlock.new("OSMANYA") }
          const_attr_reader  :OSMANYA
          
          # Constant for the "Cypriot Syllabary" Unicode character block.
          # @since 1.5
          const_set_lazy(:CYPRIOT_SYLLABARY) { self.class::UnicodeBlock.new("CYPRIOT_SYLLABARY", Array.typed(self.class::String).new(["Cypriot Syllabary", "CypriotSyllabary"])) }
          const_attr_reader  :CYPRIOT_SYLLABARY
          
          # Constant for the "Byzantine Musical Symbols" Unicode character block.
          # @since 1.5
          const_set_lazy(:BYZANTINE_MUSICAL_SYMBOLS) { self.class::UnicodeBlock.new("BYZANTINE_MUSICAL_SYMBOLS", Array.typed(self.class::String).new(["Byzantine Musical Symbols", "ByzantineMusicalSymbols"])) }
          const_attr_reader  :BYZANTINE_MUSICAL_SYMBOLS
          
          # Constant for the "Musical Symbols" Unicode character block.
          # @since 1.5
          const_set_lazy(:MUSICAL_SYMBOLS) { self.class::UnicodeBlock.new("MUSICAL_SYMBOLS", Array.typed(self.class::String).new(["Musical Symbols", "MusicalSymbols"])) }
          const_attr_reader  :MUSICAL_SYMBOLS
          
          # Constant for the "Tai Xuan Jing Symbols" Unicode character block.
          # @since 1.5
          const_set_lazy(:TAI_XUAN_JING_SYMBOLS) { self.class::UnicodeBlock.new("TAI_XUAN_JING_SYMBOLS", Array.typed(self.class::String).new(["Tai Xuan Jing Symbols", "TaiXuanJingSymbols"])) }
          const_attr_reader  :TAI_XUAN_JING_SYMBOLS
          
          # Constant for the "Mathematical Alphanumeric Symbols" Unicode character block.
          # @since 1.5
          const_set_lazy(:MATHEMATICAL_ALPHANUMERIC_SYMBOLS) { self.class::UnicodeBlock.new("MATHEMATICAL_ALPHANUMERIC_SYMBOLS", Array.typed(self.class::String).new(["Mathematical Alphanumeric Symbols", "MathematicalAlphanumericSymbols"])) }
          const_attr_reader  :MATHEMATICAL_ALPHANUMERIC_SYMBOLS
          
          # Constant for the "CJK Unified Ideographs Extension B" Unicode character block.
          # @since 1.5
          const_set_lazy(:CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B) { self.class::UnicodeBlock.new("CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B", Array.typed(self.class::String).new(["CJK Unified Ideographs Extension B", "CJKUnifiedIdeographsExtensionB"])) }
          const_attr_reader  :CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B
          
          # Constant for the "CJK Compatibility Ideographs Supplement" Unicode character block.
          # @since 1.5
          const_set_lazy(:CJK_COMPATIBILITY_IDEOGRAPHS_SUPPLEMENT) { self.class::UnicodeBlock.new("CJK_COMPATIBILITY_IDEOGRAPHS_SUPPLEMENT", Array.typed(self.class::String).new(["CJK Compatibility Ideographs Supplement", "CJKCompatibilityIdeographsSupplement"])) }
          const_attr_reader  :CJK_COMPATIBILITY_IDEOGRAPHS_SUPPLEMENT
          
          # Constant for the "Tags" Unicode character block.
          # @since 1.5
          const_set_lazy(:TAGS) { self.class::UnicodeBlock.new("TAGS") }
          const_attr_reader  :TAGS
          
          # Constant for the "Variation Selectors Supplement" Unicode character block.
          # @since 1.5
          const_set_lazy(:VARIATION_SELECTORS_SUPPLEMENT) { self.class::UnicodeBlock.new("VARIATION_SELECTORS_SUPPLEMENT", Array.typed(self.class::String).new(["Variation Selectors Supplement", "VariationSelectorsSupplement"])) }
          const_attr_reader  :VARIATION_SELECTORS_SUPPLEMENT
          
          # Constant for the "Supplementary Private Use Area-A" Unicode character block.
          # @since 1.5
          const_set_lazy(:SUPPLEMENTARY_PRIVATE_USE_AREA_A) { self.class::UnicodeBlock.new("SUPPLEMENTARY_PRIVATE_USE_AREA_A", Array.typed(self.class::String).new(["Supplementary Private Use Area-A", "SupplementaryPrivateUseArea-A"])) }
          const_attr_reader  :SUPPLEMENTARY_PRIVATE_USE_AREA_A
          
          # Constant for the "Supplementary Private Use Area-B" Unicode character block.
          # @since 1.5
          const_set_lazy(:SUPPLEMENTARY_PRIVATE_USE_AREA_B) { self.class::UnicodeBlock.new("SUPPLEMENTARY_PRIVATE_USE_AREA_B", Array.typed(self.class::String).new(["Supplementary Private Use Area-B", "SupplementaryPrivateUseArea-B"])) }
          const_attr_reader  :SUPPLEMENTARY_PRIVATE_USE_AREA_B
          
          # Constant for the "High Surrogates" Unicode character block.
          # This block represents codepoint values in the high surrogate
          # range: 0xD800 through 0xDB7F
          # 
          # @since 1.5
          const_set_lazy(:HIGH_SURROGATES) { self.class::UnicodeBlock.new("HIGH_SURROGATES", Array.typed(self.class::String).new(["High Surrogates", "HighSurrogates"])) }
          const_attr_reader  :HIGH_SURROGATES
          
          # Constant for the "High Private Use Surrogates" Unicode character block.
          # This block represents codepoint values in the high surrogate
          # range: 0xDB80 through 0xDBFF
          # 
          # @since 1.5
          const_set_lazy(:HIGH_PRIVATE_USE_SURROGATES) { self.class::UnicodeBlock.new("HIGH_PRIVATE_USE_SURROGATES", Array.typed(self.class::String).new(["High Private Use Surrogates", "HighPrivateUseSurrogates"])) }
          const_attr_reader  :HIGH_PRIVATE_USE_SURROGATES
          
          # Constant for the "Low Surrogates" Unicode character block.
          # This block represents codepoint values in the high surrogate
          # range: 0xDC00 through 0xDFFF
          # 
          # @since 1.5
          const_set_lazy(:LOW_SURROGATES) { self.class::UnicodeBlock.new("LOW_SURROGATES", Array.typed(self.class::String).new(["Low Surrogates", "LowSurrogates"])) }
          const_attr_reader  :LOW_SURROGATES
          
          # Basic Latin
          # Latin-1 Supplement
          # Latin Extended-A
          # Latin Extended-B
          # IPA Extensions
          # Spacing Modifier Letters
          # Combining Diacritical Marks
          # Greek and Coptic
          # Cyrillic
          # Cyrillic Supplementary
          # Armenian
          # Hebrew
          # Arabic
          # Syriac
          # unassigned
          # Thaana
          # unassigned
          # Devanagari
          # Bengali
          # Gurmukhi
          # Gujarati
          # Oriya
          # Tamil
          # Telugu
          # Kannada
          # Malayalam
          # Sinhala
          # Thai
          # Lao
          # Tibetan
          # Myanmar
          # Georgian
          # Hangul Jamo
          # Ethiopic
          # unassigned
          # Cherokee
          # Unified Canadian Aboriginal Syllabics
          # Ogham
          # Runic
          # Tagalog
          # Hanunoo
          # Buhid
          # Tagbanwa
          # Khmer
          # Mongolian
          # unassigned
          # Limbu
          # Tai Le
          # unassigned
          # Khmer Symbols
          # unassigned
          # Phonetic Extensions
          # unassigned
          # Latin Extended Additional
          # Greek Extended
          # General Punctuation
          # Superscripts and Subscripts
          # Currency Symbols
          # Combining Diacritical Marks for Symbols
          # Letterlike Symbols
          # Number Forms
          # Arrows
          # Mathematical Operators
          # Miscellaneous Technical
          # Control Pictures
          # Optical Character Recognition
          # Enclosed Alphanumerics
          # Box Drawing
          # Block Elements
          # Geometric Shapes
          # Miscellaneous Symbols
          # Dingbats
          # Miscellaneous Mathematical Symbols-A
          # Supplemental Arrows-A
          # Braille Patterns
          # Supplemental Arrows-B
          # Miscellaneous Mathematical Symbols-B
          # Supplemental Mathematical Operators
          # Miscellaneous Symbols and Arrows
          # unassigned
          # CJK Radicals Supplement
          # Kangxi Radicals
          # unassigned
          # Ideographic Description Characters
          # CJK Symbols and Punctuation
          # Hiragana
          # Katakana
          # Bopomofo
          # Hangul Compatibility Jamo
          # Kanbun
          # Bopomofo Extended
          # unassigned
          # Katakana Phonetic Extensions
          # Enclosed CJK Letters and Months
          # CJK Compatibility
          # CJK Unified Ideographs Extension A
          # Yijing Hexagram Symbols
          # CJK Unified Ideographs
          # Yi Syllables
          # Yi Radicals
          # unassigned
          # Hangul Syllables
          # unassigned
          # High Surrogates
          # High Private Use Surrogates
          # Low Surrogates
          # Private Use
          # CJK Compatibility Ideographs
          # Alphabetic Presentation Forms
          # Arabic Presentation Forms-A
          # Variation Selectors
          # unassigned
          # Combining Half Marks
          # CJK Compatibility Forms
          # Small Form Variants
          # Arabic Presentation Forms-B
          # Halfwidth and Fullwidth Forms
          # Specials
          # Linear B Syllabary
          # Linear B Ideograms
          # Aegean Numbers
          # unassigned
          # Old Italic
          # Gothic
          # unassigned
          # Ugaritic
          # unassigned
          # Deseret
          # Shavian
          # Osmanya
          # unassigned
          # Cypriot Syllabary
          # unassigned
          # Byzantine Musical Symbols
          # Musical Symbols
          # unassigned
          # Tai Xuan Jing Symbols
          # unassigned
          # Mathematical Alphanumeric Symbols
          # unassigned
          # CJK Unified Ideographs Extension B
          # unassigned
          # CJK Compatibility Ideographs Supplement
          # unassigned
          # Tags
          # unassigned
          # Variation Selectors Supplement
          # unassigned
          # Supplementary Private Use Area-A
          # Supplementary Private Use Area-B
          const_set_lazy(:BlockStarts) { Array.typed(::Java::Int).new([0x0, 0x80, 0x100, 0x180, 0x250, 0x2b0, 0x300, 0x370, 0x400, 0x500, 0x530, 0x590, 0x600, 0x700, 0x750, 0x780, 0x7c0, 0x900, 0x980, 0xa00, 0xa80, 0xb00, 0xb80, 0xc00, 0xc80, 0xd00, 0xd80, 0xe00, 0xe80, 0xf00, 0x1000, 0x10a0, 0x1100, 0x1200, 0x1380, 0x13a0, 0x1400, 0x1680, 0x16a0, 0x1700, 0x1720, 0x1740, 0x1760, 0x1780, 0x1800, 0x18b0, 0x1900, 0x1950, 0x1980, 0x19e0, 0x1a00, 0x1d00, 0x1d80, 0x1e00, 0x1f00, 0x2000, 0x2070, 0x20a0, 0x20d0, 0x2100, 0x2150, 0x2190, 0x2200, 0x2300, 0x2400, 0x2440, 0x2460, 0x2500, 0x2580, 0x25a0, 0x2600, 0x2700, 0x27c0, 0x27f0, 0x2800, 0x2900, 0x2980, 0x2a00, 0x2b00, 0x2c00, 0x2e80, 0x2f00, 0x2fe0, 0x2ff0, 0x3000, 0x3040, 0x30a0, 0x3100, 0x3130, 0x3190, 0x31a0, 0x31c0, 0x31f0, 0x3200, 0x3300, 0x3400, 0x4dc0, 0x4e00, 0xa000, 0xa490, 0xa4d0, 0xac00, 0xd7b0, 0xd800, 0xdb80, 0xdc00, 0xe000, 0xf900, 0xfb00, 0xfb50, 0xfe00, 0xfe10, 0xfe20, 0xfe30, 0xfe50, 0xfe70, 0xff00, 0xfff0, 0x10000, 0x10080, 0x10100, 0x10140, 0x10300, 0x10330, 0x10350, 0x10380, 0x103a0, 0x10400, 0x10450, 0x10480, 0x104b0, 0x10800, 0x10840, 0x1d000, 0x1d100, 0x1d200, 0x1d300, 0x1d360, 0x1d400, 0x1d800, 0x20000, 0x2a6e0, 0x2f800, 0x2fa20, 0xe0000, 0xe0080, 0xe0100, 0xe01f0, 0xf0000, 0x100000, ]) }
          const_attr_reader  :BlockStarts
          
          const_set_lazy(:Blocks) { Array.typed(self.class::UnicodeBlock).new([self.class::BASIC_LATIN, self.class::LATIN_1_SUPPLEMENT, self.class::LATIN_EXTENDED_A, self.class::LATIN_EXTENDED_B, self.class::IPA_EXTENSIONS, self.class::SPACING_MODIFIER_LETTERS, self.class::COMBINING_DIACRITICAL_MARKS, self.class::GREEK, self.class::CYRILLIC, self.class::CYRILLIC_SUPPLEMENTARY, self.class::ARMENIAN, self.class::HEBREW, self.class::ARABIC, self.class::SYRIAC, nil, self.class::THAANA, nil, self.class::DEVANAGARI, self.class::BENGALI, self.class::GURMUKHI, self.class::GUJARATI, self.class::ORIYA, self.class::TAMIL, self.class::TELUGU, self.class::KANNADA, self.class::MALAYALAM, self.class::SINHALA, self.class::THAI, self.class::LAO, self.class::TIBETAN, self.class::MYANMAR, self.class::GEORGIAN, self.class::HANGUL_JAMO, self.class::ETHIOPIC, nil, self.class::CHEROKEE, self.class::UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS, self.class::OGHAM, self.class::RUNIC, self.class::TAGALOG, self.class::HANUNOO, self.class::BUHID, self.class::TAGBANWA, self.class::KHMER, self.class::MONGOLIAN, nil, self.class::LIMBU, self.class::TAI_LE, nil, self.class::KHMER_SYMBOLS, nil, self.class::PHONETIC_EXTENSIONS, nil, self.class::LATIN_EXTENDED_ADDITIONAL, self.class::GREEK_EXTENDED, self.class::GENERAL_PUNCTUATION, self.class::SUPERSCRIPTS_AND_SUBSCRIPTS, self.class::CURRENCY_SYMBOLS, self.class::COMBINING_MARKS_FOR_SYMBOLS, self.class::LETTERLIKE_SYMBOLS, self.class::NUMBER_FORMS, self.class::ARROWS, self.class::MATHEMATICAL_OPERATORS, self.class::MISCELLANEOUS_TECHNICAL, self.class::CONTROL_PICTURES, self.class::OPTICAL_CHARACTER_RECOGNITION, self.class::ENCLOSED_ALPHANUMERICS, self.class::BOX_DRAWING, self.class::BLOCK_ELEMENTS, self.class::GEOMETRIC_SHAPES, self.class::MISCELLANEOUS_SYMBOLS, self.class::DINGBATS, self.class::MISCELLANEOUS_MATHEMATICAL_SYMBOLS_A, self.class::SUPPLEMENTAL_ARROWS_A, self.class::BRAILLE_PATTERNS, self.class::SUPPLEMENTAL_ARROWS_B, self.class::MISCELLANEOUS_MATHEMATICAL_SYMBOLS_B, self.class::SUPPLEMENTAL_MATHEMATICAL_OPERATORS, self.class::MISCELLANEOUS_SYMBOLS_AND_ARROWS, nil, self.class::CJK_RADICALS_SUPPLEMENT, self.class::KANGXI_RADICALS, nil, self.class::IDEOGRAPHIC_DESCRIPTION_CHARACTERS, self.class::CJK_SYMBOLS_AND_PUNCTUATION, self.class::HIRAGANA, self.class::KATAKANA, self.class::BOPOMOFO, self.class::HANGUL_COMPATIBILITY_JAMO, self.class::KANBUN, self.class::BOPOMOFO_EXTENDED, nil, self.class::KATAKANA_PHONETIC_EXTENSIONS, self.class::ENCLOSED_CJK_LETTERS_AND_MONTHS, self.class::CJK_COMPATIBILITY, self.class::CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A, self.class::YIJING_HEXAGRAM_SYMBOLS, self.class::CJK_UNIFIED_IDEOGRAPHS, self.class::YI_SYLLABLES, self.class::YI_RADICALS, nil, self.class::HANGUL_SYLLABLES, nil, self.class::HIGH_SURROGATES, self.class::HIGH_PRIVATE_USE_SURROGATES, self.class::LOW_SURROGATES, self.class::PRIVATE_USE_AREA, self.class::CJK_COMPATIBILITY_IDEOGRAPHS, self.class::ALPHABETIC_PRESENTATION_FORMS, self.class::ARABIC_PRESENTATION_FORMS_A, self.class::VARIATION_SELECTORS, nil, self.class::COMBINING_HALF_MARKS, self.class::CJK_COMPATIBILITY_FORMS, self.class::SMALL_FORM_VARIANTS, self.class::ARABIC_PRESENTATION_FORMS_B, self.class::HALFWIDTH_AND_FULLWIDTH_FORMS, self.class::SPECIALS, self.class::LINEAR_B_SYLLABARY, self.class::LINEAR_B_IDEOGRAMS, self.class::AEGEAN_NUMBERS, nil, self.class::OLD_ITALIC, self.class::GOTHIC, nil, self.class::UGARITIC, nil, self.class::DESERET, self.class::SHAVIAN, self.class::OSMANYA, nil, self.class::CYPRIOT_SYLLABARY, nil, self.class::BYZANTINE_MUSICAL_SYMBOLS, self.class::MUSICAL_SYMBOLS, nil, self.class::TAI_XUAN_JING_SYMBOLS, nil, self.class::MATHEMATICAL_ALPHANUMERIC_SYMBOLS, nil, self.class::CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B, nil, self.class::CJK_COMPATIBILITY_IDEOGRAPHS_SUPPLEMENT, nil, self.class::TAGS, nil, self.class::VARIATION_SELECTORS_SUPPLEMENT, nil, self.class::SUPPLEMENTARY_PRIVATE_USE_AREA_A, self.class::SUPPLEMENTARY_PRIVATE_USE_AREA_B]) }
          const_attr_reader  :Blocks
          
          typesig { [::Java::Char] }
          # Returns the object representing the Unicode block containing the
          # given character, or <code>null</code> if the character is not a
          # member of a defined block.
          # 
          # <p><b>Note:</b> This method cannot handle <a
          # href="Character.html#supplementary"> supplementary
          # characters</a>. To support all Unicode characters,
          # including supplementary characters, use the {@link
          # #of(int)} method.
          # 
          # @param   c  The character in question
          # @return  The <code>UnicodeBlock</code> instance representing the
          # Unicode block of which this character is a member, or
          # <code>null</code> if the character is not a member of any
          # Unicode block
          def of(c)
            return of(RJava.cast_to_int(c))
          end
          
          typesig { [::Java::Int] }
          # Returns the object representing the Unicode block
          # containing the given character (Unicode code point), or
          # <code>null</code> if the character is not a member of a
          # defined block.
          # 
          # @param   codePoint the character (Unicode code point) in question.
          # @return  The <code>UnicodeBlock</code> instance representing the
          # Unicode block of which this character is a member, or
          # <code>null</code> if the character is not a member of any
          # Unicode block
          # @exception IllegalArgumentException if the specified
          # <code>codePoint</code> is an invalid Unicode code point.
          # @see Character#isValidCodePoint(int)
          # @since   1.5
          def of(code_point)
            if (!is_valid_code_point(code_point))
              raise self.class::IllegalArgumentException.new
            end
            top = 0
            bottom = 0
            current = 0
            bottom = 0
            top = self.class::BlockStarts.attr_length
            current = top / 2
            # invariant: top > current >= bottom && codePoint >= unicodeBlockStarts[bottom]
            while (top - bottom > 1)
              if (code_point >= self.class::BlockStarts[current])
                bottom = current
              else
                top = current
              end
              current = (top + bottom) / 2
            end
            return self.class::Blocks[current]
          end
          
          typesig { [self::String] }
          # Returns the UnicodeBlock with the given name. Block
          # names are determined by The Unicode Standard. The file
          # Blocks-&lt;version&gt;.txt defines blocks for a particular
          # version of the standard. The {@link Character} class specifies
          # the version of the standard that it supports.
          # <p>
          # This method accepts block names in the following forms:
          # <ol>
          # <li> Canonical block names as defined by the Unicode Standard.
          # For example, the standard defines a "Basic Latin" block. Therefore, this
          # method accepts "Basic Latin" as a valid block name. The documentation of
          # each UnicodeBlock provides the canonical name.
          # <li>Canonical block names with all spaces removed. For example, "BasicLatin"
          # is a valid block name for the "Basic Latin" block.
          # <li>The text representation of each constant UnicodeBlock identifier.
          # For example, this method will return the {@link #BASIC_LATIN} block if
          # provided with the "BASIC_LATIN" name. This form replaces all spaces and
          # hyphens in the canonical name with underscores.
          # </ol>
          # Finally, character case is ignored for all of the valid block name forms.
          # For example, "BASIC_LATIN" and "basic_latin" are both valid block names.
          # The en_US locale's case mapping rules are used to provide case-insensitive
          # string comparisons for block name validation.
          # <p>
          # If the Unicode Standard changes block names, both the previous and
          # current names will be accepted.
          # 
          # @param blockName A <code>UnicodeBlock</code> name.
          # @return The <code>UnicodeBlock</code> instance identified
          # by <code>blockName</code>
          # @throws IllegalArgumentException if <code>blockName</code> is an
          # invalid name
          # @throws NullPointerException if <code>blockName</code> is null
          # @since 1.5
          def for_name(block_name)
            block = self.attr_map.get(block_name.to_upper_case(Locale::US))
            if ((block).nil?)
              raise self.class::IllegalArgumentException.new
            end
            return block
          end
        }
        
        private
        alias_method :initialize__unicode_block, :initialize
      end }
    }
    
    # The value of the <code>Character</code>.
    # 
    # @serial
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 3786198910865385080 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Char] }
    # Constructs a newly allocated <code>Character</code> object that
    # represents the specified <code>char</code> value.
    # 
    # @param  value   the value to be represented by the
    # <code>Character</code> object.
    def initialize(value)
      @value = 0
      super()
      @value = value
    end
    
    class_module.module_eval {
      const_set_lazy(:CharacterCache) { Class.new do
        include_class_members Character
        
        typesig { [] }
        def initialize
        end
        
        class_module.module_eval {
          const_set_lazy(:Cache) { Array.typed(self.class::Character).new(127 + 1) { nil } }
          const_attr_reader  :Cache
          
          when_class_loaded do
            i = 0
            while i < self.class::Cache.attr_length
              self.class::Cache[i] = self.class::Character.new(RJava.cast_to_char(i))
              i += 1
            end
          end
        }
        
        private
        alias_method :initialize__character_cache, :initialize
      end }
      
      typesig { [::Java::Char] }
      # Returns a <tt>Character</tt> instance representing the specified
      # <tt>char</tt> value.
      # If a new <tt>Character</tt> instance is not required, this method
      # should generally be used in preference to the constructor
      # {@link #Character(char)}, as this method is likely to yield
      # significantly better space and time performance by caching
      # frequently requested values.
      # 
      # @param  c a char value.
      # @return a <tt>Character</tt> instance representing <tt>c</tt>.
      # @since  1.5
      def value_of(c)
        if (c <= 127)
          # must cache
          return CharacterCache.attr_cache[RJava.cast_to_int(c)]
        end
        return Character.new(c)
      end
    }
    
    typesig { [] }
    # Returns the value of this <code>Character</code> object.
    # @return  the primitive <code>char</code> value represented by
    # this object.
    def char_value
      return @value
    end
    
    typesig { [] }
    # Returns a hash code for this <code>Character</code>.
    # @return  a hash code value for this object.
    def hash_code
      return RJava.cast_to_int(@value)
    end
    
    typesig { [Object] }
    # Compares this object against the specified object.
    # The result is <code>true</code> if and only if the argument is not
    # <code>null</code> and is a <code>Character</code> object that
    # represents the same <code>char</code> value as this object.
    # 
    # @param   obj   the object to compare with.
    # @return  <code>true</code> if the objects are the same;
    # <code>false</code> otherwise.
    def ==(obj)
      if (obj.is_a?(Character))
        return (@value).equal?((obj).char_value)
      end
      return false
    end
    
    typesig { [] }
    # Returns a <code>String</code> object representing this
    # <code>Character</code>'s value.  The result is a string of
    # length 1 whose sole component is the primitive
    # <code>char</code> value represented by this
    # <code>Character</code> object.
    # 
    # @return  a string representation of this object.
    def to_s
      buf = Array.typed(::Java::Char).new([@value])
      return String.value_of(buf)
    end
    
    class_module.module_eval {
      typesig { [::Java::Char] }
      # Returns a <code>String</code> object representing the
      # specified <code>char</code>.  The result is a string of length
      # 1 consisting solely of the specified <code>char</code>.
      # 
      # @param c the <code>char</code> to be converted
      # @return the string representation of the specified <code>char</code>
      # @since 1.4
      def to_s(c)
        return String.value_of(c)
      end
      
      typesig { [::Java::Int] }
      # Determines whether the specified code point is a valid Unicode
      # code point value in the range of <code>0x0000</code> to
      # <code>0x10FFFF</code> inclusive. This method is equivalent to
      # the expression:
      # 
      # <blockquote><pre>
      # codePoint >= 0x0000 && codePoint <= 0x10FFFF
      # </pre></blockquote>
      # 
      # @param  codePoint the Unicode code point to be tested
      # @return <code>true</code> if the specified code point value
      # is a valid code point value;
      # <code>false</code> otherwise.
      # @since  1.5
      def is_valid_code_point(code_point)
        return code_point >= MIN_CODE_POINT && code_point <= MAX_CODE_POINT
      end
      
      typesig { [::Java::Int] }
      # Determines whether the specified character (Unicode code point)
      # is in the supplementary character range. The method call is
      # equivalent to the expression:
      # <blockquote><pre>
      # codePoint >= 0x10000 && codePoint <= 0x10FFFF
      # </pre></blockquote>
      # 
      # @param  codePoint the character (Unicode code point) to be tested
      # @return <code>true</code> if the specified character is in the Unicode
      # supplementary character range; <code>false</code> otherwise.
      # @since  1.5
      def is_supplementary_code_point(code_point)
        return code_point >= MIN_SUPPLEMENTARY_CODE_POINT && code_point <= MAX_CODE_POINT
      end
      
      typesig { [::Java::Char] }
      # Determines if the given <code>char</code> value is a
      # high-surrogate code unit (also known as <i>leading-surrogate
      # code unit</i>). Such values do not represent characters by
      # themselves, but are used in the representation of <a
      # href="#supplementary">supplementary characters</a> in the
      # UTF-16 encoding.
      # 
      # <p>This method returns <code>true</code> if and only if
      # <blockquote><pre>ch >= '&#92;uD800' && ch <= '&#92;uDBFF'
      # </pre></blockquote>
      # is <code>true</code>.
      # 
      # @param   ch   the <code>char</code> value to be tested.
      # @return  <code>true</code> if the <code>char</code> value
      # is between '&#92;uD800' and '&#92;uDBFF' inclusive;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isLowSurrogate(char)
      # @see     Character.UnicodeBlock#of(int)
      # @since   1.5
      def is_high_surrogate(ch)
        return ch >= MIN_HIGH_SURROGATE && ch <= MAX_HIGH_SURROGATE
      end
      
      typesig { [::Java::Char] }
      # Determines if the given <code>char</code> value is a
      # low-surrogate code unit (also known as <i>trailing-surrogate code
      # unit</i>). Such values do not represent characters by themselves,
      # but are used in the representation of <a
      # href="#supplementary">supplementary characters</a> in the UTF-16 encoding.
      # 
      # <p> This method returns <code>true</code> if and only if
      # <blockquote><pre>ch >= '&#92;uDC00' && ch <= '&#92;uDFFF'
      # </pre></blockquote> is <code>true</code>.
      # 
      # @param   ch   the <code>char</code> value to be tested.
      # @return  <code>true</code> if the <code>char</code> value
      # is between '&#92;uDC00' and '&#92;uDFFF' inclusive;
      # <code>false</code> otherwise.
      # @see java.lang.Character#isHighSurrogate(char)
      # @since   1.5
      def is_low_surrogate(ch)
        return ch >= MIN_LOW_SURROGATE && ch <= MAX_LOW_SURROGATE
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # Determines whether the specified pair of <code>char</code>
      # values is a valid surrogate pair. This method is equivalent to
      # the expression:
      # <blockquote><pre>
      # isHighSurrogate(high) && isLowSurrogate(low)
      # </pre></blockquote>
      # 
      # @param  high the high-surrogate code value to be tested
      # @param  low the low-surrogate code value to be tested
      # @return <code>true</code> if the specified high and
      # low-surrogate code values represent a valid surrogate pair;
      # <code>false</code> otherwise.
      # @since  1.5
      def is_surrogate_pair(high, low)
        return is_high_surrogate(high) && is_low_surrogate(low)
      end
      
      typesig { [::Java::Int] }
      # Determines the number of <code>char</code> values needed to
      # represent the specified character (Unicode code point). If the
      # specified character is equal to or greater than 0x10000, then
      # the method returns 2. Otherwise, the method returns 1.
      # 
      # <p>This method doesn't validate the specified character to be a
      # valid Unicode code point. The caller must validate the
      # character value using {@link #isValidCodePoint(int) isValidCodePoint}
      # if necessary.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  2 if the character is a valid supplementary character; 1 otherwise.
      # @see     #isSupplementaryCodePoint(int)
      # @since   1.5
      def char_count(code_point)
        return code_point >= MIN_SUPPLEMENTARY_CODE_POINT ? 2 : 1
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # Converts the specified surrogate pair to its supplementary code
      # point value. This method does not validate the specified
      # surrogate pair. The caller must validate it using {@link
      # #isSurrogatePair(char, char) isSurrogatePair} if necessary.
      # 
      # @param  high the high-surrogate code unit
      # @param  low the low-surrogate code unit
      # @return the supplementary code point composed from the
      # specified surrogate pair.
      # @since  1.5
      def to_code_point(high, low)
        return ((high - MIN_HIGH_SURROGATE) << 10) + (low - MIN_LOW_SURROGATE) + MIN_SUPPLEMENTARY_CODE_POINT
      end
      
      typesig { [CharSequence, ::Java::Int] }
      # Returns the code point at the given index of the
      # <code>CharSequence</code>. If the <code>char</code> value at
      # the given index in the <code>CharSequence</code> is in the
      # high-surrogate range, the following index is less than the
      # length of the <code>CharSequence</code>, and the
      # <code>char</code> value at the following index is in the
      # low-surrogate range, then the supplementary code point
      # corresponding to this surrogate pair is returned. Otherwise,
      # the <code>char</code> value at the given index is returned.
      # 
      # @param seq a sequence of <code>char</code> values (Unicode code
      # units)
      # @param index the index to the <code>char</code> values (Unicode
      # code units) in <code>seq</code> to be converted
      # @return the Unicode code point at the given index
      # @exception NullPointerException if <code>seq</code> is null.
      # @exception IndexOutOfBoundsException if the value
      # <code>index</code> is negative or not less than
      # {@link CharSequence#length() seq.length()}.
      # @since  1.5
      def code_point_at(seq, index)
        c1 = seq.char_at(((index += 1) - 1))
        if (is_high_surrogate(c1))
          if (index < seq.length)
            c2 = seq.char_at(index)
            if (is_low_surrogate(c2))
              return to_code_point(c1, c2)
            end
          end
        end
        return c1
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int] }
      # Returns the code point at the given index of the
      # <code>char</code> array. If the <code>char</code> value at
      # the given index in the <code>char</code> array is in the
      # high-surrogate range, the following index is less than the
      # length of the <code>char</code> array, and the
      # <code>char</code> value at the following index is in the
      # low-surrogate range, then the supplementary code point
      # corresponding to this surrogate pair is returned. Otherwise,
      # the <code>char</code> value at the given index is returned.
      # 
      # @param a the <code>char</code> array
      # @param index the index to the <code>char</code> values (Unicode
      # code units) in the <code>char</code> array to be converted
      # @return the Unicode code point at the given index
      # @exception NullPointerException if <code>a</code> is null.
      # @exception IndexOutOfBoundsException if the value
      # <code>index</code> is negative or not less than
      # the length of the <code>char</code> array.
      # @since  1.5
      def code_point_at(a, index)
        return code_point_at_impl(a, index, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Returns the code point at the given index of the
      # <code>char</code> array, where only array elements with
      # <code>index</code> less than <code>limit</code> can be used. If
      # the <code>char</code> value at the given index in the
      # <code>char</code> array is in the high-surrogate range, the
      # following index is less than the <code>limit</code>, and the
      # <code>char</code> value at the following index is in the
      # low-surrogate range, then the supplementary code point
      # corresponding to this surrogate pair is returned. Otherwise,
      # the <code>char</code> value at the given index is returned.
      # 
      # @param a the <code>char</code> array
      # @param index the index to the <code>char</code> values (Unicode
      # code units) in the <code>char</code> array to be converted
      # @param limit the index after the last array element that can be used in the
      # <code>char</code> array
      # @return the Unicode code point at the given index
      # @exception NullPointerException if <code>a</code> is null.
      # @exception IndexOutOfBoundsException if the <code>index</code>
      # argument is negative or not less than the <code>limit</code>
      # argument, or if the <code>limit</code> argument is negative or
      # greater than the length of the <code>char</code> array.
      # @since  1.5
      def code_point_at(a, index, limit)
        if (index >= limit || limit < 0 || limit > a.attr_length)
          raise IndexOutOfBoundsException.new
        end
        return code_point_at_impl(a, index, limit)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def code_point_at_impl(a, index, limit)
        c1 = a[((index += 1) - 1)]
        if (is_high_surrogate(c1))
          if (index < limit)
            c2 = a[index]
            if (is_low_surrogate(c2))
              return to_code_point(c1, c2)
            end
          end
        end
        return c1
      end
      
      typesig { [CharSequence, ::Java::Int] }
      # Returns the code point preceding the given index of the
      # <code>CharSequence</code>. If the <code>char</code> value at
      # <code>(index - 1)</code> in the <code>CharSequence</code> is in
      # the low-surrogate range, <code>(index - 2)</code> is not
      # negative, and the <code>char</code> value at <code>(index -
      # 2)</code> in the <code>CharSequence</code> is in the
      # high-surrogate range, then the supplementary code point
      # corresponding to this surrogate pair is returned. Otherwise,
      # the <code>char</code> value at <code>(index - 1)</code> is
      # returned.
      # 
      # @param seq the <code>CharSequence</code> instance
      # @param index the index following the code point that should be returned
      # @return the Unicode code point value before the given index.
      # @exception NullPointerException if <code>seq</code> is null.
      # @exception IndexOutOfBoundsException if the <code>index</code>
      # argument is less than 1 or greater than {@link
      # CharSequence#length() seq.length()}.
      # @since  1.5
      def code_point_before(seq, index)
        c2 = seq.char_at((index -= 1))
        if (is_low_surrogate(c2))
          if (index > 0)
            c1 = seq.char_at((index -= 1))
            if (is_high_surrogate(c1))
              return to_code_point(c1, c2)
            end
          end
        end
        return c2
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int] }
      # Returns the code point preceding the given index of the
      # <code>char</code> array. If the <code>char</code> value at
      # <code>(index - 1)</code> in the <code>char</code> array is in
      # the low-surrogate range, <code>(index - 2)</code> is not
      # negative, and the <code>char</code> value at <code>(index -
      # 2)</code> in the <code>char</code> array is in the
      # high-surrogate range, then the supplementary code point
      # corresponding to this surrogate pair is returned. Otherwise,
      # the <code>char</code> value at <code>(index - 1)</code> is
      # returned.
      # 
      # @param a the <code>char</code> array
      # @param index the index following the code point that should be returned
      # @return the Unicode code point value before the given index.
      # @exception NullPointerException if <code>a</code> is null.
      # @exception IndexOutOfBoundsException if the <code>index</code>
      # argument is less than 1 or greater than the length of the
      # <code>char</code> array
      # @since  1.5
      def code_point_before(a, index)
        return code_point_before_impl(a, index, 0)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Returns the code point preceding the given index of the
      # <code>char</code> array, where only array elements with
      # <code>index</code> greater than or equal to <code>start</code>
      # can be used. If the <code>char</code> value at <code>(index -
      # 1)</code> in the <code>char</code> array is in the
      # low-surrogate range, <code>(index - 2)</code> is not less than
      # <code>start</code>, and the <code>char</code> value at
      # <code>(index - 2)</code> in the <code>char</code> array is in
      # the high-surrogate range, then the supplementary code point
      # corresponding to this surrogate pair is returned. Otherwise,
      # the <code>char</code> value at <code>(index - 1)</code> is
      # returned.
      # 
      # @param a the <code>char</code> array
      # @param index the index following the code point that should be returned
      # @param start the index of the first array element in the
      # <code>char</code> array
      # @return the Unicode code point value before the given index.
      # @exception NullPointerException if <code>a</code> is null.
      # @exception IndexOutOfBoundsException if the <code>index</code>
      # argument is not greater than the <code>start</code> argument or
      # is greater than the length of the <code>char</code> array, or
      # if the <code>start</code> argument is negative or not less than
      # the length of the <code>char</code> array.
      # @since  1.5
      def code_point_before(a, index, start)
        if (index <= start || start < 0 || start >= a.attr_length)
          raise IndexOutOfBoundsException.new
        end
        return code_point_before_impl(a, index, start)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def code_point_before_impl(a, index, start)
        c2 = a[(index -= 1)]
        if (is_low_surrogate(c2))
          if (index > start)
            c1 = a[(index -= 1)]
            if (is_high_surrogate(c1))
              return to_code_point(c1, c2)
            end
          end
        end
        return c2
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Char), ::Java::Int] }
      # Converts the specified character (Unicode code point) to its
      # UTF-16 representation. If the specified code point is a BMP
      # (Basic Multilingual Plane or Plane 0) value, the same value is
      # stored in <code>dst[dstIndex]</code>, and 1 is returned. If the
      # specified code point is a supplementary character, its
      # surrogate values are stored in <code>dst[dstIndex]</code>
      # (high-surrogate) and <code>dst[dstIndex+1]</code>
      # (low-surrogate), and 2 is returned.
      # 
      # @param  codePoint the character (Unicode code point) to be converted.
      # @param  dst an array of <code>char</code> in which the
      # <code>codePoint</code>'s UTF-16 value is stored.
      # @param dstIndex the start index into the <code>dst</code>
      # array where the converted value is stored.
      # @return 1 if the code point is a BMP code point, 2 if the
      # code point is a supplementary code point.
      # @exception IllegalArgumentException if the specified
      # <code>codePoint</code> is not a valid Unicode code point.
      # @exception NullPointerException if the specified <code>dst</code> is null.
      # @exception IndexOutOfBoundsException if <code>dstIndex</code>
      # is negative or not less than <code>dst.length</code>, or if
      # <code>dst</code> at <code>dstIndex</code> doesn't have enough
      # array element(s) to store the resulting <code>char</code>
      # value(s). (If <code>dstIndex</code> is equal to
      # <code>dst.length-1</code> and the specified
      # <code>codePoint</code> is a supplementary character, the
      # high-surrogate value is not stored in
      # <code>dst[dstIndex]</code>.)
      # @since  1.5
      def to_chars(code_point, dst, dst_index)
        if (code_point < 0 || code_point > MAX_CODE_POINT)
          raise IllegalArgumentException.new
        end
        if (code_point < MIN_SUPPLEMENTARY_CODE_POINT)
          dst[dst_index] = RJava.cast_to_char(code_point)
          return 1
        end
        to_surrogates(code_point, dst, dst_index)
        return 2
      end
      
      typesig { [::Java::Int] }
      # Converts the specified character (Unicode code point) to its
      # UTF-16 representation stored in a <code>char</code> array. If
      # the specified code point is a BMP (Basic Multilingual Plane or
      # Plane 0) value, the resulting <code>char</code> array has
      # the same value as <code>codePoint</code>. If the specified code
      # point is a supplementary code point, the resulting
      # <code>char</code> array has the corresponding surrogate pair.
      # 
      # @param  codePoint a Unicode code point
      # @return a <code>char</code> array having
      # <code>codePoint</code>'s UTF-16 representation.
      # @exception IllegalArgumentException if the specified
      # <code>codePoint</code> is not a valid Unicode code point.
      # @since  1.5
      def to_chars(code_point)
        if (code_point < 0 || code_point > MAX_CODE_POINT)
          raise IllegalArgumentException.new
        end
        if (code_point < MIN_SUPPLEMENTARY_CODE_POINT)
          return Array.typed(::Java::Char).new([RJava.cast_to_char(code_point)])
        end
        result = CharArray.new(2)
        to_surrogates(code_point, result, 0)
        return result
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Char), ::Java::Int] }
      def to_surrogates(code_point, dst, index)
        offset = code_point - MIN_SUPPLEMENTARY_CODE_POINT
        dst[index + 1] = RJava.cast_to_char(((offset & 0x3ff) + MIN_LOW_SURROGATE))
        dst[index] = RJava.cast_to_char(((offset >> 10) + MIN_HIGH_SURROGATE))
      end
      
      typesig { [CharSequence, ::Java::Int, ::Java::Int] }
      # Returns the number of Unicode code points in the text range of
      # the specified char sequence. The text range begins at the
      # specified <code>beginIndex</code> and extends to the
      # <code>char</code> at index <code>endIndex - 1</code>. Thus the
      # length (in <code>char</code>s) of the text range is
      # <code>endIndex-beginIndex</code>. Unpaired surrogates within
      # the text range count as one code point each.
      # 
      # @param seq the char sequence
      # @param beginIndex the index to the first <code>char</code> of
      # the text range.
      # @param endIndex the index after the last <code>char</code> of
      # the text range.
      # @return the number of Unicode code points in the specified text
      # range
      # @exception NullPointerException if <code>seq</code> is null.
      # @exception IndexOutOfBoundsException if the
      # <code>beginIndex</code> is negative, or <code>endIndex</code>
      # is larger than the length of the given sequence, or
      # <code>beginIndex</code> is larger than <code>endIndex</code>.
      # @since  1.5
      def code_point_count(seq, begin_index, end_index)
        length_ = seq.length
        if (begin_index < 0 || end_index > length_ || begin_index > end_index)
          raise IndexOutOfBoundsException.new
        end
        n = 0
        i = begin_index
        while i < end_index
          n += 1
          if (is_high_surrogate(seq.char_at(((i += 1) - 1))))
            if (i < end_index && is_low_surrogate(seq.char_at(i)))
              i += 1
            end
          end
        end
        return n
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Returns the number of Unicode code points in a subarray of the
      # <code>char</code> array argument. The <code>offset</code>
      # argument is the index of the first <code>char</code> of the
      # subarray and the <code>count</code> argument specifies the
      # length of the subarray in <code>char</code>s. Unpaired
      # surrogates within the subarray count as one code point each.
      # 
      # @param a the <code>char</code> array
      # @param offset the index of the first <code>char</code> in the
      # given <code>char</code> array
      # @param count the length of the subarray in <code>char</code>s
      # @return the number of Unicode code points in the specified subarray
      # @exception NullPointerException if <code>a</code> is null.
      # @exception IndexOutOfBoundsException if <code>offset</code> or
      # <code>count</code> is negative, or if <code>offset +
      # count</code> is larger than the length of the given array.
      # @since  1.5
      def code_point_count(a, offset, count)
        if (count > a.attr_length - offset || offset < 0 || count < 0)
          raise IndexOutOfBoundsException.new
        end
        return code_point_count_impl(a, offset, count)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def code_point_count_impl(a, offset, count)
        end_index = offset + count
        n = 0
        i = offset
        while i < end_index
          n += 1
          if (is_high_surrogate(a[((i += 1) - 1)]))
            if (i < end_index && is_low_surrogate(a[i]))
              i += 1
            end
          end
        end
        return n
      end
      
      typesig { [CharSequence, ::Java::Int, ::Java::Int] }
      # Returns the index within the given char sequence that is offset
      # from the given <code>index</code> by <code>codePointOffset</code>
      # code points. Unpaired surrogates within the text range given by
      # <code>index</code> and <code>codePointOffset</code> count as
      # one code point each.
      # 
      # @param seq the char sequence
      # @param index the index to be offset
      # @param codePointOffset the offset in code points
      # @return the index within the char sequence
      # @exception NullPointerException if <code>seq</code> is null.
      # @exception IndexOutOfBoundsException if <code>index</code>
      # is negative or larger then the length of the char sequence,
      # or if <code>codePointOffset</code> is positive and the
      # subsequence starting with <code>index</code> has fewer than
      # <code>codePointOffset</code> code points, or if
      # <code>codePointOffset</code> is negative and the subsequence
      # before <code>index</code> has fewer than the absolute value
      # of <code>codePointOffset</code> code points.
      # @since 1.5
      def offset_by_code_points(seq, index, code_point_offset)
        length_ = seq.length
        if (index < 0 || index > length_)
          raise IndexOutOfBoundsException.new
        end
        x = index
        if (code_point_offset >= 0)
          i = 0
          i = 0
          while x < length_ && i < code_point_offset
            if (is_high_surrogate(seq.char_at(((x += 1) - 1))))
              if (x < length_ && is_low_surrogate(seq.char_at(x)))
                x += 1
              end
            end
            i += 1
          end
          if (i < code_point_offset)
            raise IndexOutOfBoundsException.new
          end
        else
          i = 0
          i = code_point_offset
          while x > 0 && i < 0
            if (is_low_surrogate(seq.char_at((x -= 1))))
              if (x > 0 && is_high_surrogate(seq.char_at(x - 1)))
                x -= 1
              end
            end
            i += 1
          end
          if (i < 0)
            raise IndexOutOfBoundsException.new
          end
        end
        return x
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index within the given <code>char</code> subarray
      # that is offset from the given <code>index</code> by
      # <code>codePointOffset</code> code points. The
      # <code>start</code> and <code>count</code> arguments specify a
      # subarray of the <code>char</code> array. Unpaired surrogates
      # within the text range given by <code>index</code> and
      # <code>codePointOffset</code> count as one code point each.
      # 
      # @param a the <code>char</code> array
      # @param start the index of the first <code>char</code> of the
      # subarray
      # @param count the length of the subarray in <code>char</code>s
      # @param index the index to be offset
      # @param codePointOffset the offset in code points
      # @return the index within the subarray
      # @exception NullPointerException if <code>a</code> is null.
      # @exception IndexOutOfBoundsException
      # if <code>start</code> or <code>count</code> is negative,
      # or if <code>start + count</code> is larger than the length of
      # the given array,
      # or if <code>index</code> is less than <code>start</code> or
      # larger then <code>start + count</code>,
      # or if <code>codePointOffset</code> is positive and the text range
      # starting with <code>index</code> and ending with <code>start
      # + count - 1</code> has fewer than <code>codePointOffset</code> code
      # points,
      # or if <code>codePointOffset</code> is negative and the text range
      # starting with <code>start</code> and ending with <code>index
      # - 1</code> has fewer than the absolute value of
      # <code>codePointOffset</code> code points.
      # @since 1.5
      def offset_by_code_points(a, start, count, index, code_point_offset)
        if (count > a.attr_length - start || start < 0 || count < 0 || index < start || index > start + count)
          raise IndexOutOfBoundsException.new
        end
        return offset_by_code_points_impl(a, start, count, index, code_point_offset)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      def offset_by_code_points_impl(a, start, count, index, code_point_offset)
        x = index
        if (code_point_offset >= 0)
          limit = start + count
          i = 0
          i = 0
          while x < limit && i < code_point_offset
            if (is_high_surrogate(a[((x += 1) - 1)]))
              if (x < limit && is_low_surrogate(a[x]))
                x += 1
              end
            end
            i += 1
          end
          if (i < code_point_offset)
            raise IndexOutOfBoundsException.new
          end
        else
          i = 0
          i = code_point_offset
          while x > start && i < 0
            if (is_low_surrogate(a[(x -= 1)]))
              if (x > start && is_high_surrogate(a[x - 1]))
                x -= 1
              end
            end
            i += 1
          end
          if (i < 0)
            raise IndexOutOfBoundsException.new
          end
        end
        return x
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is a lowercase character.
      # <p>
      # A character is lowercase if its general category type, provided
      # by <code>Character.getType(ch)</code>, is
      # <code>LOWERCASE_LETTER</code>.
      # <p>
      # The following are examples of lowercase characters:
      # <p><blockquote><pre>
      # a b c d e f g h i j k l m n o p q r s t u v w x y z
      # '&#92;u00DF' '&#92;u00E0' '&#92;u00E1' '&#92;u00E2' '&#92;u00E3' '&#92;u00E4' '&#92;u00E5' '&#92;u00E6'
      # '&#92;u00E7' '&#92;u00E8' '&#92;u00E9' '&#92;u00EA' '&#92;u00EB' '&#92;u00EC' '&#92;u00ED' '&#92;u00EE'
      # '&#92;u00EF' '&#92;u00F0' '&#92;u00F1' '&#92;u00F2' '&#92;u00F3' '&#92;u00F4' '&#92;u00F5' '&#92;u00F6'
      # '&#92;u00F8' '&#92;u00F9' '&#92;u00FA' '&#92;u00FB' '&#92;u00FC' '&#92;u00FD' '&#92;u00FE' '&#92;u00FF'
      # </pre></blockquote>
      # <p> Many other Unicode characters are lowercase too.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isLowerCase(int)} method.
      # 
      # @param   ch   the character to be tested.
      # @return  <code>true</code> if the character is lowercase;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isLowerCase(char)
      # @see     java.lang.Character#isTitleCase(char)
      # @see     java.lang.Character#toLowerCase(char)
      # @see     java.lang.Character#getType(char)
      def is_lower_case(ch)
        return is_lower_case(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is a
      # lowercase character.
      # <p>
      # A character is lowercase if its general category type, provided
      # by {@link Character#getType getType(codePoint)}, is
      # <code>LOWERCASE_LETTER</code>.
      # <p>
      # The following are examples of lowercase characters:
      # <p><blockquote><pre>
      # a b c d e f g h i j k l m n o p q r s t u v w x y z
      # '&#92;u00DF' '&#92;u00E0' '&#92;u00E1' '&#92;u00E2' '&#92;u00E3' '&#92;u00E4' '&#92;u00E5' '&#92;u00E6'
      # '&#92;u00E7' '&#92;u00E8' '&#92;u00E9' '&#92;u00EA' '&#92;u00EB' '&#92;u00EC' '&#92;u00ED' '&#92;u00EE'
      # '&#92;u00EF' '&#92;u00F0' '&#92;u00F1' '&#92;u00F2' '&#92;u00F3' '&#92;u00F4' '&#92;u00F5' '&#92;u00F6'
      # '&#92;u00F8' '&#92;u00F9' '&#92;u00FA' '&#92;u00FB' '&#92;u00FC' '&#92;u00FD' '&#92;u00FE' '&#92;u00FF'
      # </pre></blockquote>
      # <p> Many other Unicode characters are lowercase too.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is lowercase;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isLowerCase(int)
      # @see     java.lang.Character#isTitleCase(int)
      # @see     java.lang.Character#toLowerCase(int)
      # @see     java.lang.Character#getType(int)
      # @since   1.5
      def is_lower_case(code_point)
        return (get_type(code_point)).equal?(Character::LOWERCASE_LETTER)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is an uppercase character.
      # <p>
      # A character is uppercase if its general category type, provided by
      # <code>Character.getType(ch)</code>, is <code>UPPERCASE_LETTER</code>.
      # <p>
      # The following are examples of uppercase characters:
      # <p><blockquote><pre>
      # A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
      # '&#92;u00C0' '&#92;u00C1' '&#92;u00C2' '&#92;u00C3' '&#92;u00C4' '&#92;u00C5' '&#92;u00C6' '&#92;u00C7'
      # '&#92;u00C8' '&#92;u00C9' '&#92;u00CA' '&#92;u00CB' '&#92;u00CC' '&#92;u00CD' '&#92;u00CE' '&#92;u00CF'
      # '&#92;u00D0' '&#92;u00D1' '&#92;u00D2' '&#92;u00D3' '&#92;u00D4' '&#92;u00D5' '&#92;u00D6' '&#92;u00D8'
      # '&#92;u00D9' '&#92;u00DA' '&#92;u00DB' '&#92;u00DC' '&#92;u00DD' '&#92;u00DE'
      # </pre></blockquote>
      # <p> Many other Unicode characters are uppercase too.<p>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isUpperCase(int)} method.
      # 
      # @param   ch   the character to be tested.
      # @return  <code>true</code> if the character is uppercase;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isLowerCase(char)
      # @see     java.lang.Character#isTitleCase(char)
      # @see     java.lang.Character#toUpperCase(char)
      # @see     java.lang.Character#getType(char)
      # @since   1.0
      def is_upper_case(ch)
        return is_upper_case(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is an uppercase character.
      # <p>
      # A character is uppercase if its general category type, provided by
      # {@link Character#getType(int) getType(codePoint)}, is <code>UPPERCASE_LETTER</code>.
      # <p>
      # The following are examples of uppercase characters:
      # <p><blockquote><pre>
      # A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
      # '&#92;u00C0' '&#92;u00C1' '&#92;u00C2' '&#92;u00C3' '&#92;u00C4' '&#92;u00C5' '&#92;u00C6' '&#92;u00C7'
      # '&#92;u00C8' '&#92;u00C9' '&#92;u00CA' '&#92;u00CB' '&#92;u00CC' '&#92;u00CD' '&#92;u00CE' '&#92;u00CF'
      # '&#92;u00D0' '&#92;u00D1' '&#92;u00D2' '&#92;u00D3' '&#92;u00D4' '&#92;u00D5' '&#92;u00D6' '&#92;u00D8'
      # '&#92;u00D9' '&#92;u00DA' '&#92;u00DB' '&#92;u00DC' '&#92;u00DD' '&#92;u00DE'
      # </pre></blockquote>
      # <p> Many other Unicode characters are uppercase too.<p>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is uppercase;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isLowerCase(int)
      # @see     java.lang.Character#isTitleCase(int)
      # @see     java.lang.Character#toUpperCase(int)
      # @see     java.lang.Character#getType(int)
      # @since   1.5
      def is_upper_case(code_point)
        return (get_type(code_point)).equal?(Character::UPPERCASE_LETTER)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is a titlecase character.
      # <p>
      # A character is a titlecase character if its general
      # category type, provided by <code>Character.getType(ch)</code>,
      # is <code>TITLECASE_LETTER</code>.
      # <p>
      # Some characters look like pairs of Latin letters. For example, there
      # is an uppercase letter that looks like "LJ" and has a corresponding
      # lowercase letter that looks like "lj". A third form, which looks like "Lj",
      # is the appropriate form to use when rendering a word in lowercase
      # with initial capitals, as for a book title.
      # <p>
      # These are some of the Unicode characters for which this method returns
      # <code>true</code>:
      # <ul>
      # <li><code>LATIN CAPITAL LETTER D WITH SMALL LETTER Z WITH CARON</code>
      # <li><code>LATIN CAPITAL LETTER L WITH SMALL LETTER J</code>
      # <li><code>LATIN CAPITAL LETTER N WITH SMALL LETTER J</code>
      # <li><code>LATIN CAPITAL LETTER D WITH SMALL LETTER Z</code>
      # </ul>
      # <p> Many other Unicode characters are titlecase too.<p>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isTitleCase(int)} method.
      # 
      # @param   ch   the character to be tested.
      # @return  <code>true</code> if the character is titlecase;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isLowerCase(char)
      # @see     java.lang.Character#isUpperCase(char)
      # @see     java.lang.Character#toTitleCase(char)
      # @see     java.lang.Character#getType(char)
      # @since   1.0.2
      def is_title_case(ch)
        return is_title_case(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is a titlecase character.
      # <p>
      # A character is a titlecase character if its general
      # category type, provided by {@link Character#getType(int) getType(codePoint)},
      # is <code>TITLECASE_LETTER</code>.
      # <p>
      # Some characters look like pairs of Latin letters. For example, there
      # is an uppercase letter that looks like "LJ" and has a corresponding
      # lowercase letter that looks like "lj". A third form, which looks like "Lj",
      # is the appropriate form to use when rendering a word in lowercase
      # with initial capitals, as for a book title.
      # <p>
      # These are some of the Unicode characters for which this method returns
      # <code>true</code>:
      # <ul>
      # <li><code>LATIN CAPITAL LETTER D WITH SMALL LETTER Z WITH CARON</code>
      # <li><code>LATIN CAPITAL LETTER L WITH SMALL LETTER J</code>
      # <li><code>LATIN CAPITAL LETTER N WITH SMALL LETTER J</code>
      # <li><code>LATIN CAPITAL LETTER D WITH SMALL LETTER Z</code>
      # </ul>
      # <p> Many other Unicode characters are titlecase too.<p>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is titlecase;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isLowerCase(int)
      # @see     java.lang.Character#isUpperCase(int)
      # @see     java.lang.Character#toTitleCase(int)
      # @see     java.lang.Character#getType(int)
      # @since   1.5
      def is_title_case(code_point)
        return (get_type(code_point)).equal?(Character::TITLECASE_LETTER)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is a digit.
      # <p>
      # A character is a digit if its general category type, provided
      # by <code>Character.getType(ch)</code>, is
      # <code>DECIMAL_DIGIT_NUMBER</code>.
      # <p>
      # Some Unicode character ranges that contain digits:
      # <ul>
      # <li><code>'&#92;u0030'</code> through <code>'&#92;u0039'</code>,
      # ISO-LATIN-1 digits (<code>'0'</code> through <code>'9'</code>)
      # <li><code>'&#92;u0660'</code> through <code>'&#92;u0669'</code>,
      # Arabic-Indic digits
      # <li><code>'&#92;u06F0'</code> through <code>'&#92;u06F9'</code>,
      # Extended Arabic-Indic digits
      # <li><code>'&#92;u0966'</code> through <code>'&#92;u096F'</code>,
      # Devanagari digits
      # <li><code>'&#92;uFF10'</code> through <code>'&#92;uFF19'</code>,
      # Fullwidth digits
      # </ul>
      # 
      # Many other character ranges contain digits as well.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isDigit(int)} method.
      # 
      # @param   ch   the character to be tested.
      # @return  <code>true</code> if the character is a digit;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#digit(char, int)
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Character#getType(char)
      def is_digit(ch)
        return is_digit(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is a digit.
      # <p>
      # A character is a digit if its general category type, provided
      # by {@link Character#getType(int) getType(codePoint)}, is
      # <code>DECIMAL_DIGIT_NUMBER</code>.
      # <p>
      # Some Unicode character ranges that contain digits:
      # <ul>
      # <li><code>'&#92;u0030'</code> through <code>'&#92;u0039'</code>,
      # ISO-LATIN-1 digits (<code>'0'</code> through <code>'9'</code>)
      # <li><code>'&#92;u0660'</code> through <code>'&#92;u0669'</code>,
      # Arabic-Indic digits
      # <li><code>'&#92;u06F0'</code> through <code>'&#92;u06F9'</code>,
      # Extended Arabic-Indic digits
      # <li><code>'&#92;u0966'</code> through <code>'&#92;u096F'</code>,
      # Devanagari digits
      # <li><code>'&#92;uFF10'</code> through <code>'&#92;uFF19'</code>,
      # Fullwidth digits
      # </ul>
      # 
      # Many other character ranges contain digits as well.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is a digit;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Character#getType(int)
      # @since   1.5
      def is_digit(code_point)
        return (get_type(code_point)).equal?(Character::DECIMAL_DIGIT_NUMBER)
      end
      
      typesig { [::Java::Char] }
      # Determines if a character is defined in Unicode.
      # <p>
      # A character is defined if at least one of the following is true:
      # <ul>
      # <li>It has an entry in the UnicodeData file.
      # <li>It has a value in a range defined by the UnicodeData file.
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isDefined(int)} method.
      # 
      # @param   ch   the character to be tested
      # @return  <code>true</code> if the character has a defined meaning
      # in Unicode; <code>false</code> otherwise.
      # @see     java.lang.Character#isDigit(char)
      # @see     java.lang.Character#isLetter(char)
      # @see     java.lang.Character#isLetterOrDigit(char)
      # @see     java.lang.Character#isLowerCase(char)
      # @see     java.lang.Character#isTitleCase(char)
      # @see     java.lang.Character#isUpperCase(char)
      # @since   1.0.2
      def is_defined(ch)
        return is_defined(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if a character (Unicode code point) is defined in Unicode.
      # <p>
      # A character is defined if at least one of the following is true:
      # <ul>
      # <li>It has an entry in the UnicodeData file.
      # <li>It has a value in a range defined by the UnicodeData file.
      # </ul>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character has a defined meaning
      # in Unicode; <code>false</code> otherwise.
      # @see     java.lang.Character#isDigit(int)
      # @see     java.lang.Character#isLetter(int)
      # @see     java.lang.Character#isLetterOrDigit(int)
      # @see     java.lang.Character#isLowerCase(int)
      # @see     java.lang.Character#isTitleCase(int)
      # @see     java.lang.Character#isUpperCase(int)
      # @since   1.5
      def is_defined(code_point)
        return !(get_type(code_point)).equal?(Character::UNASSIGNED)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is a letter.
      # <p>
      # A character is considered to be a letter if its general
      # category type, provided by <code>Character.getType(ch)</code>,
      # is any of the following:
      # <ul>
      # <li> <code>UPPERCASE_LETTER</code>
      # <li> <code>LOWERCASE_LETTER</code>
      # <li> <code>TITLECASE_LETTER</code>
      # <li> <code>MODIFIER_LETTER</code>
      # <li> <code>OTHER_LETTER</code>
      # </ul>
      # 
      # Not all letters have case. Many characters are
      # letters but are neither uppercase nor lowercase nor titlecase.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isLetter(int)} method.
      # 
      # @param   ch   the character to be tested.
      # @return  <code>true</code> if the character is a letter;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isDigit(char)
      # @see     java.lang.Character#isJavaIdentifierStart(char)
      # @see     java.lang.Character#isJavaLetter(char)
      # @see     java.lang.Character#isJavaLetterOrDigit(char)
      # @see     java.lang.Character#isLetterOrDigit(char)
      # @see     java.lang.Character#isLowerCase(char)
      # @see     java.lang.Character#isTitleCase(char)
      # @see     java.lang.Character#isUnicodeIdentifierStart(char)
      # @see     java.lang.Character#isUpperCase(char)
      def is_letter(ch)
        return is_letter(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is a letter.
      # <p>
      # A character is considered to be a letter if its general
      # category type, provided by {@link Character#getType(int) getType(codePoint)},
      # is any of the following:
      # <ul>
      # <li> <code>UPPERCASE_LETTER</code>
      # <li> <code>LOWERCASE_LETTER</code>
      # <li> <code>TITLECASE_LETTER</code>
      # <li> <code>MODIFIER_LETTER</code>
      # <li> <code>OTHER_LETTER</code>
      # </ul>
      # 
      # Not all letters have case. Many characters are
      # letters but are neither uppercase nor lowercase nor titlecase.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is a letter;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isDigit(int)
      # @see     java.lang.Character#isJavaIdentifierStart(int)
      # @see     java.lang.Character#isLetterOrDigit(int)
      # @see     java.lang.Character#isLowerCase(int)
      # @see     java.lang.Character#isTitleCase(int)
      # @see     java.lang.Character#isUnicodeIdentifierStart(int)
      # @see     java.lang.Character#isUpperCase(int)
      # @since   1.5
      def is_letter(code_point)
        return !(((((1 << Character::UPPERCASE_LETTER) | (1 << Character::LOWERCASE_LETTER) | (1 << Character::TITLECASE_LETTER) | (1 << Character::MODIFIER_LETTER) | (1 << Character::OTHER_LETTER)) >> get_type(code_point)) & 1)).equal?(0)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is a letter or digit.
      # <p>
      # A character is considered to be a letter or digit if either
      # <code>Character.isLetter(char ch)</code> or
      # <code>Character.isDigit(char ch)</code> returns
      # <code>true</code> for the character.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isLetterOrDigit(int)} method.
      # 
      # @param   ch   the character to be tested.
      # @return  <code>true</code> if the character is a letter or digit;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isDigit(char)
      # @see     java.lang.Character#isJavaIdentifierPart(char)
      # @see     java.lang.Character#isJavaLetter(char)
      # @see     java.lang.Character#isJavaLetterOrDigit(char)
      # @see     java.lang.Character#isLetter(char)
      # @see     java.lang.Character#isUnicodeIdentifierPart(char)
      # @since   1.0.2
      def is_letter_or_digit(ch)
        return is_letter_or_digit(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is a letter or digit.
      # <p>
      # A character is considered to be a letter or digit if either
      # {@link #isLetter(int) isLetter(codePoint)} or
      # {@link #isDigit(int) isDigit(codePoint)} returns
      # <code>true</code> for the character.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is a letter or digit;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isDigit(int)
      # @see     java.lang.Character#isJavaIdentifierPart(int)
      # @see     java.lang.Character#isLetter(int)
      # @see     java.lang.Character#isUnicodeIdentifierPart(int)
      # @since   1.5
      def is_letter_or_digit(code_point)
        return !(((((1 << Character::UPPERCASE_LETTER) | (1 << Character::LOWERCASE_LETTER) | (1 << Character::TITLECASE_LETTER) | (1 << Character::MODIFIER_LETTER) | (1 << Character::OTHER_LETTER) | (1 << Character::DECIMAL_DIGIT_NUMBER)) >> get_type(code_point)) & 1)).equal?(0)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is permissible as the first
      # character in a Java identifier.
      # <p>
      # A character may start a Java identifier if and only if
      # one of the following is true:
      # <ul>
      # <li> {@link #isLetter(char) isLetter(ch)} returns <code>true</code>
      # <li> {@link #getType(char) getType(ch)} returns <code>LETTER_NUMBER</code>
      # <li> ch is a currency symbol (such as "$")
      # <li> ch is a connecting punctuation character (such as "_").
      # </ul>
      # 
      # @param   ch the character to be tested.
      # @return  <code>true</code> if the character may start a Java
      # identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaLetterOrDigit(char)
      # @see     java.lang.Character#isJavaIdentifierStart(char)
      # @see     java.lang.Character#isJavaIdentifierPart(char)
      # @see     java.lang.Character#isLetter(char)
      # @see     java.lang.Character#isLetterOrDigit(char)
      # @see     java.lang.Character#isUnicodeIdentifierStart(char)
      # @since   1.02
      # @deprecated Replaced by isJavaIdentifierStart(char).
      def is_java_letter(ch)
        return is_java_identifier_start(ch)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character may be part of a Java
      # identifier as other than the first character.
      # <p>
      # A character may be part of a Java identifier if and only if any
      # of the following are true:
      # <ul>
      # <li>  it is a letter
      # <li>  it is a currency symbol (such as <code>'$'</code>)
      # <li>  it is a connecting punctuation character (such as <code>'_'</code>)
      # <li>  it is a digit
      # <li>  it is a numeric letter (such as a Roman numeral character)
      # <li>  it is a combining mark
      # <li>  it is a non-spacing mark
      # <li> <code>isIdentifierIgnorable</code> returns
      # <code>true</code> for the character.
      # </ul>
      # 
      # @param   ch the character to be tested.
      # @return  <code>true</code> if the character may be part of a
      # Java identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaLetter(char)
      # @see     java.lang.Character#isJavaIdentifierStart(char)
      # @see     java.lang.Character#isJavaIdentifierPart(char)
      # @see     java.lang.Character#isLetter(char)
      # @see     java.lang.Character#isLetterOrDigit(char)
      # @see     java.lang.Character#isUnicodeIdentifierPart(char)
      # @see     java.lang.Character#isIdentifierIgnorable(char)
      # @since   1.02
      # @deprecated Replaced by isJavaIdentifierPart(char).
      def is_java_letter_or_digit(ch)
        return is_java_identifier_part(ch)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is
      # permissible as the first character in a Java identifier.
      # <p>
      # A character may start a Java identifier if and only if
      # one of the following conditions is true:
      # <ul>
      # <li> {@link #isLetter(char) isLetter(ch)} returns <code>true</code>
      # <li> {@link #getType(char) getType(ch)} returns <code>LETTER_NUMBER</code>
      # <li> ch is a currency symbol (such as "$")
      # <li> ch is a connecting punctuation character (such as "_").
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isJavaIdentifierStart(int)} method.
      # 
      # @param   ch the character to be tested.
      # @return  <code>true</code> if the character may start a Java identifier;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaIdentifierPart(char)
      # @see     java.lang.Character#isLetter(char)
      # @see     java.lang.Character#isUnicodeIdentifierStart(char)
      # @see     javax.lang.model.SourceVersion#isIdentifier(CharSequence)
      # @since   1.1
      def is_java_identifier_start(ch)
        return is_java_identifier_start(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the character (Unicode code point) is
      # permissible as the first character in a Java identifier.
      # <p>
      # A character may start a Java identifier if and only if
      # one of the following conditions is true:
      # <ul>
      # <li> {@link #isLetter(int) isLetter(codePoint)}
      # returns <code>true</code>
      # <li> {@link #getType(int) getType(codePoint)}
      # returns <code>LETTER_NUMBER</code>
      # <li> the referenced character is a currency symbol (such as "$")
      # <li> the referenced character is a connecting punctuation character
      # (such as "_").
      # </ul>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character may start a Java identifier;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaIdentifierPart(int)
      # @see     java.lang.Character#isLetter(int)
      # @see     java.lang.Character#isUnicodeIdentifierStart(int)
      # @see     javax.lang.model.SourceVersion#isIdentifier(CharSequence)
      # @since   1.5
      def is_java_identifier_start(code_point)
        return CharacterData.of(code_point).is_java_identifier_start(code_point)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character may be part of a Java
      # identifier as other than the first character.
      # <p>
      # A character may be part of a Java identifier if any of the following
      # are true:
      # <ul>
      # <li>  it is a letter
      # <li>  it is a currency symbol (such as <code>'$'</code>)
      # <li>  it is a connecting punctuation character (such as <code>'_'</code>)
      # <li>  it is a digit
      # <li>  it is a numeric letter (such as a Roman numeral character)
      # <li>  it is a combining mark
      # <li>  it is a non-spacing mark
      # <li> <code>isIdentifierIgnorable</code> returns
      # <code>true</code> for the character
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isJavaIdentifierPart(int)} method.
      # 
      # @param   ch      the character to be tested.
      # @return <code>true</code> if the character may be part of a
      # Java identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isIdentifierIgnorable(char)
      # @see     java.lang.Character#isJavaIdentifierStart(char)
      # @see     java.lang.Character#isLetterOrDigit(char)
      # @see     java.lang.Character#isUnicodeIdentifierPart(char)
      # @see     javax.lang.model.SourceVersion#isIdentifier(CharSequence)
      # @since   1.1
      def is_java_identifier_part(ch)
        return is_java_identifier_part(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the character (Unicode code point) may be part of a Java
      # identifier as other than the first character.
      # <p>
      # A character may be part of a Java identifier if any of the following
      # are true:
      # <ul>
      # <li>  it is a letter
      # <li>  it is a currency symbol (such as <code>'$'</code>)
      # <li>  it is a connecting punctuation character (such as <code>'_'</code>)
      # <li>  it is a digit
      # <li>  it is a numeric letter (such as a Roman numeral character)
      # <li>  it is a combining mark
      # <li>  it is a non-spacing mark
      # <li> {@link #isIdentifierIgnorable(int)
      # isIdentifierIgnorable(codePoint)} returns <code>true</code> for
      # the character
      # </ul>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return <code>true</code> if the character may be part of a
      # Java identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isIdentifierIgnorable(int)
      # @see     java.lang.Character#isJavaIdentifierStart(int)
      # @see     java.lang.Character#isLetterOrDigit(int)
      # @see     java.lang.Character#isUnicodeIdentifierPart(int)
      # @see     javax.lang.model.SourceVersion#isIdentifier(CharSequence)
      # @since   1.5
      def is_java_identifier_part(code_point)
        return CharacterData.of(code_point).is_java_identifier_part(code_point)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is permissible as the
      # first character in a Unicode identifier.
      # <p>
      # A character may start a Unicode identifier if and only if
      # one of the following conditions is true:
      # <ul>
      # <li> {@link #isLetter(char) isLetter(ch)} returns <code>true</code>
      # <li> {@link #getType(char) getType(ch)} returns
      # <code>LETTER_NUMBER</code>.
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isUnicodeIdentifierStart(int)} method.
      # 
      # @param   ch      the character to be tested.
      # @return  <code>true</code> if the character may start a Unicode
      # identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaIdentifierStart(char)
      # @see     java.lang.Character#isLetter(char)
      # @see     java.lang.Character#isUnicodeIdentifierPart(char)
      # @since   1.1
      def is_unicode_identifier_start(ch)
        return is_unicode_identifier_start(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is permissible as the
      # first character in a Unicode identifier.
      # <p>
      # A character may start a Unicode identifier if and only if
      # one of the following conditions is true:
      # <ul>
      # <li> {@link #isLetter(int) isLetter(codePoint)}
      # returns <code>true</code>
      # <li> {@link #getType(int) getType(codePoint)}
      # returns <code>LETTER_NUMBER</code>.
      # </ul>
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character may start a Unicode
      # identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaIdentifierStart(int)
      # @see     java.lang.Character#isLetter(int)
      # @see     java.lang.Character#isUnicodeIdentifierPart(int)
      # @since   1.5
      def is_unicode_identifier_start(code_point)
        return CharacterData.of(code_point).is_unicode_identifier_start(code_point)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character may be part of a Unicode
      # identifier as other than the first character.
      # <p>
      # A character may be part of a Unicode identifier if and only if
      # one of the following statements is true:
      # <ul>
      # <li>  it is a letter
      # <li>  it is a connecting punctuation character (such as <code>'_'</code>)
      # <li>  it is a digit
      # <li>  it is a numeric letter (such as a Roman numeral character)
      # <li>  it is a combining mark
      # <li>  it is a non-spacing mark
      # <li> <code>isIdentifierIgnorable</code> returns
      # <code>true</code> for this character.
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isUnicodeIdentifierPart(int)} method.
      # 
      # @param   ch      the character to be tested.
      # @return  <code>true</code> if the character may be part of a
      # Unicode identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isIdentifierIgnorable(char)
      # @see     java.lang.Character#isJavaIdentifierPart(char)
      # @see     java.lang.Character#isLetterOrDigit(char)
      # @see     java.lang.Character#isUnicodeIdentifierStart(char)
      # @since   1.1
      def is_unicode_identifier_part(ch)
        return is_unicode_identifier_part(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) may be part of a Unicode
      # identifier as other than the first character.
      # <p>
      # A character may be part of a Unicode identifier if and only if
      # one of the following statements is true:
      # <ul>
      # <li>  it is a letter
      # <li>  it is a connecting punctuation character (such as <code>'_'</code>)
      # <li>  it is a digit
      # <li>  it is a numeric letter (such as a Roman numeral character)
      # <li>  it is a combining mark
      # <li>  it is a non-spacing mark
      # <li> <code>isIdentifierIgnorable</code> returns
      # <code>true</code> for this character.
      # </ul>
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character may be part of a
      # Unicode identifier; <code>false</code> otherwise.
      # @see     java.lang.Character#isIdentifierIgnorable(int)
      # @see     java.lang.Character#isJavaIdentifierPart(int)
      # @see     java.lang.Character#isLetterOrDigit(int)
      # @see     java.lang.Character#isUnicodeIdentifierStart(int)
      # @since   1.5
      def is_unicode_identifier_part(code_point)
        return CharacterData.of(code_point).is_unicode_identifier_part(code_point)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character should be regarded as
      # an ignorable character in a Java identifier or a Unicode identifier.
      # <p>
      # The following Unicode characters are ignorable in a Java identifier
      # or a Unicode identifier:
      # <ul>
      # <li>ISO control characters that are not whitespace
      # <ul>
      # <li><code>'&#92;u0000'</code> through <code>'&#92;u0008'</code>
      # <li><code>'&#92;u000E'</code> through <code>'&#92;u001B'</code>
      # <li><code>'&#92;u007F'</code> through <code>'&#92;u009F'</code>
      # </ul>
      # 
      # <li>all characters that have the <code>FORMAT</code> general
      # category value
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isIdentifierIgnorable(int)} method.
      # 
      # @param   ch      the character to be tested.
      # @return  <code>true</code> if the character is an ignorable control
      # character that may be part of a Java or Unicode identifier;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaIdentifierPart(char)
      # @see     java.lang.Character#isUnicodeIdentifierPart(char)
      # @since   1.1
      def is_identifier_ignorable(ch)
        return is_identifier_ignorable(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) should be regarded as
      # an ignorable character in a Java identifier or a Unicode identifier.
      # <p>
      # The following Unicode characters are ignorable in a Java identifier
      # or a Unicode identifier:
      # <ul>
      # <li>ISO control characters that are not whitespace
      # <ul>
      # <li><code>'&#92;u0000'</code> through <code>'&#92;u0008'</code>
      # <li><code>'&#92;u000E'</code> through <code>'&#92;u001B'</code>
      # <li><code>'&#92;u007F'</code> through <code>'&#92;u009F'</code>
      # </ul>
      # 
      # <li>all characters that have the <code>FORMAT</code> general
      # category value
      # </ul>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is an ignorable control
      # character that may be part of a Java or Unicode identifier;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isJavaIdentifierPart(int)
      # @see     java.lang.Character#isUnicodeIdentifierPart(int)
      # @since   1.5
      def is_identifier_ignorable(code_point)
        return CharacterData.of(code_point).is_identifier_ignorable(code_point)
      end
      
      typesig { [::Java::Char] }
      # Converts the character argument to lowercase using case
      # mapping information from the UnicodeData file.
      # <p>
      # Note that
      # <code>Character.isLowerCase(Character.toLowerCase(ch))</code>
      # does not always return <code>true</code> for some ranges of
      # characters, particularly those that are symbols or ideographs.
      # 
      # <p>In general, {@link java.lang.String#toLowerCase()} should be used to map
      # characters to lowercase. <code>String</code> case mapping methods
      # have several benefits over <code>Character</code> case mapping methods.
      # <code>String</code> case mapping methods can perform locale-sensitive
      # mappings, context-sensitive mappings, and 1:M character mappings, whereas
      # the <code>Character</code> case mapping methods cannot.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #toLowerCase(int)} method.
      # 
      # @param   ch   the character to be converted.
      # @return  the lowercase equivalent of the character, if any;
      # otherwise, the character itself.
      # @see     java.lang.Character#isLowerCase(char)
      # @see     java.lang.String#toLowerCase()
      def to_lower_case(ch)
        return RJava.cast_to_char(to_lower_case(RJava.cast_to_int(ch)))
      end
      
      typesig { [::Java::Int] }
      # Converts the character (Unicode code point) argument to
      # lowercase using case mapping information from the UnicodeData
      # file.
      # 
      # <p> Note that
      # <code>Character.isLowerCase(Character.toLowerCase(codePoint))</code>
      # does not always return <code>true</code> for some ranges of
      # characters, particularly those that are symbols or ideographs.
      # 
      # <p>In general, {@link java.lang.String#toLowerCase()} should be used to map
      # characters to lowercase. <code>String</code> case mapping methods
      # have several benefits over <code>Character</code> case mapping methods.
      # <code>String</code> case mapping methods can perform locale-sensitive
      # mappings, context-sensitive mappings, and 1:M character mappings, whereas
      # the <code>Character</code> case mapping methods cannot.
      # 
      # @param   codePoint   the character (Unicode code point) to be converted.
      # @return  the lowercase equivalent of the character (Unicode code
      # point), if any; otherwise, the character itself.
      # @see     java.lang.Character#isLowerCase(int)
      # @see     java.lang.String#toLowerCase()
      # 
      # @since   1.5
      def to_lower_case(code_point)
        return CharacterData.of(code_point).to_lower_case(code_point)
      end
      
      typesig { [::Java::Char] }
      # Converts the character argument to uppercase using case mapping
      # information from the UnicodeData file.
      # <p>
      # Note that
      # <code>Character.isUpperCase(Character.toUpperCase(ch))</code>
      # does not always return <code>true</code> for some ranges of
      # characters, particularly those that are symbols or ideographs.
      # 
      # <p>In general, {@link java.lang.String#toUpperCase()} should be used to map
      # characters to uppercase. <code>String</code> case mapping methods
      # have several benefits over <code>Character</code> case mapping methods.
      # <code>String</code> case mapping methods can perform locale-sensitive
      # mappings, context-sensitive mappings, and 1:M character mappings, whereas
      # the <code>Character</code> case mapping methods cannot.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #toUpperCase(int)} method.
      # 
      # @param   ch   the character to be converted.
      # @return  the uppercase equivalent of the character, if any;
      # otherwise, the character itself.
      # @see     java.lang.Character#isUpperCase(char)
      # @see     java.lang.String#toUpperCase()
      def to_upper_case(ch)
        return RJava.cast_to_char(to_upper_case(RJava.cast_to_int(ch)))
      end
      
      typesig { [::Java::Int] }
      # Converts the character (Unicode code point) argument to
      # uppercase using case mapping information from the UnicodeData
      # file.
      # 
      # <p>Note that
      # <code>Character.isUpperCase(Character.toUpperCase(codePoint))</code>
      # does not always return <code>true</code> for some ranges of
      # characters, particularly those that are symbols or ideographs.
      # 
      # <p>In general, {@link java.lang.String#toUpperCase()} should be used to map
      # characters to uppercase. <code>String</code> case mapping methods
      # have several benefits over <code>Character</code> case mapping methods.
      # <code>String</code> case mapping methods can perform locale-sensitive
      # mappings, context-sensitive mappings, and 1:M character mappings, whereas
      # the <code>Character</code> case mapping methods cannot.
      # 
      # @param   codePoint   the character (Unicode code point) to be converted.
      # @return  the uppercase equivalent of the character, if any;
      # otherwise, the character itself.
      # @see     java.lang.Character#isUpperCase(int)
      # @see     java.lang.String#toUpperCase()
      # 
      # @since   1.5
      def to_upper_case(code_point)
        return CharacterData.of(code_point).to_upper_case(code_point)
      end
      
      typesig { [::Java::Char] }
      # Converts the character argument to titlecase using case mapping
      # information from the UnicodeData file. If a character has no
      # explicit titlecase mapping and is not itself a titlecase char
      # according to UnicodeData, then the uppercase mapping is
      # returned as an equivalent titlecase mapping. If the
      # <code>char</code> argument is already a titlecase
      # <code>char</code>, the same <code>char</code> value will be
      # returned.
      # <p>
      # Note that
      # <code>Character.isTitleCase(Character.toTitleCase(ch))</code>
      # does not always return <code>true</code> for some ranges of
      # characters.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #toTitleCase(int)} method.
      # 
      # @param   ch   the character to be converted.
      # @return  the titlecase equivalent of the character, if any;
      # otherwise, the character itself.
      # @see     java.lang.Character#isTitleCase(char)
      # @see     java.lang.Character#toLowerCase(char)
      # @see     java.lang.Character#toUpperCase(char)
      # @since   1.0.2
      def to_title_case(ch)
        return RJava.cast_to_char(to_title_case(RJava.cast_to_int(ch)))
      end
      
      typesig { [::Java::Int] }
      # Converts the character (Unicode code point) argument to titlecase using case mapping
      # information from the UnicodeData file. If a character has no
      # explicit titlecase mapping and is not itself a titlecase char
      # according to UnicodeData, then the uppercase mapping is
      # returned as an equivalent titlecase mapping. If the
      # character argument is already a titlecase
      # character, the same character value will be
      # returned.
      # 
      # <p>Note that
      # <code>Character.isTitleCase(Character.toTitleCase(codePoint))</code>
      # does not always return <code>true</code> for some ranges of
      # characters.
      # 
      # @param   codePoint   the character (Unicode code point) to be converted.
      # @return  the titlecase equivalent of the character, if any;
      # otherwise, the character itself.
      # @see     java.lang.Character#isTitleCase(int)
      # @see     java.lang.Character#toLowerCase(int)
      # @see     java.lang.Character#toUpperCase(int)
      # @since   1.5
      def to_title_case(code_point)
        return CharacterData.of(code_point).to_title_case(code_point)
      end
      
      typesig { [::Java::Char, ::Java::Int] }
      # Returns the numeric value of the character <code>ch</code> in the
      # specified radix.
      # <p>
      # If the radix is not in the range <code>MIN_RADIX</code>&nbsp;&lt;=
      # <code>radix</code>&nbsp;&lt;= <code>MAX_RADIX</code> or if the
      # value of <code>ch</code> is not a valid digit in the specified
      # radix, <code>-1</code> is returned. A character is a valid digit
      # if at least one of the following is true:
      # <ul>
      # <li>The method <code>isDigit</code> is <code>true</code> of the character
      # and the Unicode decimal digit value of the character (or its
      # single-character decomposition) is less than the specified radix.
      # In this case the decimal digit value is returned.
      # <li>The character is one of the uppercase Latin letters
      # <code>'A'</code> through <code>'Z'</code> and its code is less than
      # <code>radix&nbsp;+ 'A'&nbsp;-&nbsp;10</code>.
      # In this case, <code>ch&nbsp;- 'A'&nbsp;+&nbsp;10</code>
      # is returned.
      # <li>The character is one of the lowercase Latin letters
      # <code>'a'</code> through <code>'z'</code> and its code is less than
      # <code>radix&nbsp;+ 'a'&nbsp;-&nbsp;10</code>.
      # In this case, <code>ch&nbsp;- 'a'&nbsp;+&nbsp;10</code>
      # is returned.
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #digit(int, int)} method.
      # 
      # @param   ch      the character to be converted.
      # @param   radix   the radix.
      # @return  the numeric value represented by the character in the
      # specified radix.
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Character#isDigit(char)
      def digit(ch, radix)
        return digit(RJava.cast_to_int(ch), radix)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns the numeric value of the specified character (Unicode
      # code point) in the specified radix.
      # 
      # <p>If the radix is not in the range <code>MIN_RADIX</code>&nbsp;&lt;=
      # <code>radix</code>&nbsp;&lt;= <code>MAX_RADIX</code> or if the
      # character is not a valid digit in the specified
      # radix, <code>-1</code> is returned. A character is a valid digit
      # if at least one of the following is true:
      # <ul>
      # <li>The method {@link #isDigit(int) isDigit(codePoint)} is <code>true</code> of the character
      # and the Unicode decimal digit value of the character (or its
      # single-character decomposition) is less than the specified radix.
      # In this case the decimal digit value is returned.
      # <li>The character is one of the uppercase Latin letters
      # <code>'A'</code> through <code>'Z'</code> and its code is less than
      # <code>radix&nbsp;+ 'A'&nbsp;-&nbsp;10</code>.
      # In this case, <code>ch&nbsp;- 'A'&nbsp;+&nbsp;10</code>
      # is returned.
      # <li>The character is one of the lowercase Latin letters
      # <code>'a'</code> through <code>'z'</code> and its code is less than
      # <code>radix&nbsp;+ 'a'&nbsp;-&nbsp;10</code>.
      # In this case, <code>ch&nbsp;- 'a'&nbsp;+&nbsp;10</code>
      # is returned.
      # </ul>
      # 
      # @param   codePoint the character (Unicode code point) to be converted.
      # @param   radix   the radix.
      # @return  the numeric value represented by the character in the
      # specified radix.
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Character#isDigit(int)
      # @since   1.5
      def digit(code_point, radix)
        return CharacterData.of(code_point).digit(code_point, radix)
      end
      
      typesig { [::Java::Char] }
      # Returns the <code>int</code> value that the specified Unicode
      # character represents. For example, the character
      # <code>'&#92;u216C'</code> (the roman numeral fifty) will return
      # an int with a value of 50.
      # <p>
      # The letters A-Z in their uppercase (<code>'&#92;u0041'</code> through
      # <code>'&#92;u005A'</code>), lowercase
      # (<code>'&#92;u0061'</code> through <code>'&#92;u007A'</code>), and
      # full width variant (<code>'&#92;uFF21'</code> through
      # <code>'&#92;uFF3A'</code> and <code>'&#92;uFF41'</code> through
      # <code>'&#92;uFF5A'</code>) forms have numeric values from 10
      # through 35. This is independent of the Unicode specification,
      # which does not assign numeric values to these <code>char</code>
      # values.
      # <p>
      # If the character does not have a numeric value, then -1 is returned.
      # If the character has a numeric value that cannot be represented as a
      # nonnegative integer (for example, a fractional value), then -2
      # is returned.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #getNumericValue(int)} method.
      # 
      # @param   ch      the character to be converted.
      # @return  the numeric value of the character, as a nonnegative <code>int</code>
      # value; -2 if the character has a numeric value that is not a
      # nonnegative integer; -1 if the character has no numeric value.
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Character#isDigit(char)
      # @since   1.1
      def get_numeric_value(ch)
        return get_numeric_value(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Returns the <code>int</code> value that the specified
      # character (Unicode code point) represents. For example, the character
      # <code>'&#92;u216C'</code> (the Roman numeral fifty) will return
      # an <code>int</code> with a value of 50.
      # <p>
      # The letters A-Z in their uppercase (<code>'&#92;u0041'</code> through
      # <code>'&#92;u005A'</code>), lowercase
      # (<code>'&#92;u0061'</code> through <code>'&#92;u007A'</code>), and
      # full width variant (<code>'&#92;uFF21'</code> through
      # <code>'&#92;uFF3A'</code> and <code>'&#92;uFF41'</code> through
      # <code>'&#92;uFF5A'</code>) forms have numeric values from 10
      # through 35. This is independent of the Unicode specification,
      # which does not assign numeric values to these <code>char</code>
      # values.
      # <p>
      # If the character does not have a numeric value, then -1 is returned.
      # If the character has a numeric value that cannot be represented as a
      # nonnegative integer (for example, a fractional value), then -2
      # is returned.
      # 
      # @param   codePoint the character (Unicode code point) to be converted.
      # @return  the numeric value of the character, as a nonnegative <code>int</code>
      # value; -2 if the character has a numeric value that is not a
      # nonnegative integer; -1 if the character has no numeric value.
      # @see     java.lang.Character#forDigit(int, int)
      # @see     java.lang.Character#isDigit(int)
      # @since   1.5
      def get_numeric_value(code_point)
        return CharacterData.of(code_point).get_numeric_value(code_point)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is ISO-LATIN-1 white space.
      # This method returns <code>true</code> for the following five
      # characters only:
      # <table>
      # <tr><td><code>'\t'</code></td>            <td><code>'&#92;u0009'</code></td>
      # <td><code>HORIZONTAL TABULATION</code></td></tr>
      # <tr><td><code>'\n'</code></td>            <td><code>'&#92;u000A'</code></td>
      # <td><code>NEW LINE</code></td></tr>
      # <tr><td><code>'\f'</code></td>            <td><code>'&#92;u000C'</code></td>
      # <td><code>FORM FEED</code></td></tr>
      # <tr><td><code>'\r'</code></td>            <td><code>'&#92;u000D'</code></td>
      # <td><code>CARRIAGE RETURN</code></td></tr>
      # <tr><td><code>'&nbsp;'</code></td>  <td><code>'&#92;u0020'</code></td>
      # <td><code>SPACE</code></td></tr>
      # </table>
      # 
      # @param      ch   the character to be tested.
      # @return     <code>true</code> if the character is ISO-LATIN-1 white
      # space; <code>false</code> otherwise.
      # @see        java.lang.Character#isSpaceChar(char)
      # @see        java.lang.Character#isWhitespace(char)
      # @deprecated Replaced by isWhitespace(char).
      def is_space(ch)
        return (ch <= 0x20) && (!(((((1 << 0x9) | (1 << 0xa) | (1 << 0xc) | (1 << 0xd) | (1 << 0x20)) >> ch) & 1)).equal?(0))
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is a Unicode space character.
      # A character is considered to be a space character if and only if
      # it is specified to be a space character by the Unicode standard. This
      # method returns true if the character's general category type is any of
      # the following:
      # <ul>
      # <li> <code>SPACE_SEPARATOR</code>
      # <li> <code>LINE_SEPARATOR</code>
      # <li> <code>PARAGRAPH_SEPARATOR</code>
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isSpaceChar(int)} method.
      # 
      # @param   ch      the character to be tested.
      # @return  <code>true</code> if the character is a space character;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isWhitespace(char)
      # @since   1.1
      def is_space_char(ch)
        return is_space_char(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is a
      # Unicode space character.  A character is considered to be a
      # space character if and only if it is specified to be a space
      # character by the Unicode standard. This method returns true if
      # the character's general category type is any of the following:
      # 
      # <ul>
      # <li> {@link #SPACE_SEPARATOR}
      # <li> {@link #LINE_SEPARATOR}
      # <li> {@link #PARAGRAPH_SEPARATOR}
      # </ul>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is a space character;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isWhitespace(int)
      # @since   1.5
      def is_space_char(code_point)
        return !(((((1 << Character::SPACE_SEPARATOR) | (1 << Character::LINE_SEPARATOR) | (1 << Character::PARAGRAPH_SEPARATOR)) >> get_type(code_point)) & 1)).equal?(0)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is white space according to Java.
      # A character is a Java whitespace character if and only if it satisfies
      # one of the following criteria:
      # <ul>
      # <li> It is a Unicode space character (<code>SPACE_SEPARATOR</code>,
      # <code>LINE_SEPARATOR</code>, or <code>PARAGRAPH_SEPARATOR</code>)
      # but is not also a non-breaking space (<code>'&#92;u00A0'</code>,
      # <code>'&#92;u2007'</code>, <code>'&#92;u202F'</code>).
      # <li> It is <code>'&#92;u0009'</code>, HORIZONTAL TABULATION.
      # <li> It is <code>'&#92;u000A'</code>, LINE FEED.
      # <li> It is <code>'&#92;u000B'</code>, VERTICAL TABULATION.
      # <li> It is <code>'&#92;u000C'</code>, FORM FEED.
      # <li> It is <code>'&#92;u000D'</code>, CARRIAGE RETURN.
      # <li> It is <code>'&#92;u001C'</code>, FILE SEPARATOR.
      # <li> It is <code>'&#92;u001D'</code>, GROUP SEPARATOR.
      # <li> It is <code>'&#92;u001E'</code>, RECORD SEPARATOR.
      # <li> It is <code>'&#92;u001F'</code>, UNIT SEPARATOR.
      # </ul>
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isWhitespace(int)} method.
      # 
      # @param   ch the character to be tested.
      # @return  <code>true</code> if the character is a Java whitespace
      # character; <code>false</code> otherwise.
      # @see     java.lang.Character#isSpaceChar(char)
      # @since   1.1
      def is_whitespace(ch)
        return is_whitespace(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the specified character (Unicode code point) is
      # white space according to Java.  A character is a Java
      # whitespace character if and only if it satisfies one of the
      # following criteria:
      # <ul>
      # <li> It is a Unicode space character ({@link #SPACE_SEPARATOR},
      # {@link #LINE_SEPARATOR}, or {@link #PARAGRAPH_SEPARATOR})
      # but is not also a non-breaking space (<code>'&#92;u00A0'</code>,
      # <code>'&#92;u2007'</code>, <code>'&#92;u202F'</code>).
      # <li> It is <code>'&#92;u0009'</code>, HORIZONTAL TABULATION.
      # <li> It is <code>'&#92;u000A'</code>, LINE FEED.
      # <li> It is <code>'&#92;u000B'</code>, VERTICAL TABULATION.
      # <li> It is <code>'&#92;u000C'</code>, FORM FEED.
      # <li> It is <code>'&#92;u000D'</code>, CARRIAGE RETURN.
      # <li> It is <code>'&#92;u001C'</code>, FILE SEPARATOR.
      # <li> It is <code>'&#92;u001D'</code>, GROUP SEPARATOR.
      # <li> It is <code>'&#92;u001E'</code>, RECORD SEPARATOR.
      # <li> It is <code>'&#92;u001F'</code>, UNIT SEPARATOR.
      # </ul>
      # <p>
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is a Java whitespace
      # character; <code>false</code> otherwise.
      # @see     java.lang.Character#isSpaceChar(int)
      # @since   1.5
      def is_whitespace(code_point)
        return CharacterData.of(code_point).is_whitespace(code_point)
      end
      
      typesig { [::Java::Char] }
      # Determines if the specified character is an ISO control
      # character.  A character is considered to be an ISO control
      # character if its code is in the range <code>'&#92;u0000'</code>
      # through <code>'&#92;u001F'</code> or in the range
      # <code>'&#92;u007F'</code> through <code>'&#92;u009F'</code>.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isISOControl(int)} method.
      # 
      # @param   ch      the character to be tested.
      # @return  <code>true</code> if the character is an ISO control character;
      # <code>false</code> otherwise.
      # 
      # @see     java.lang.Character#isSpaceChar(char)
      # @see     java.lang.Character#isWhitespace(char)
      # @since   1.1
      def is_isocontrol(ch)
        return is_isocontrol(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines if the referenced character (Unicode code point) is an ISO control
      # character.  A character is considered to be an ISO control
      # character if its code is in the range <code>'&#92;u0000'</code>
      # through <code>'&#92;u001F'</code> or in the range
      # <code>'&#92;u007F'</code> through <code>'&#92;u009F'</code>.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is an ISO control character;
      # <code>false</code> otherwise.
      # @see     java.lang.Character#isSpaceChar(int)
      # @see     java.lang.Character#isWhitespace(int)
      # @since   1.5
      def is_isocontrol(code_point)
        return (code_point >= 0x0 && code_point <= 0x1f) || (code_point >= 0x7f && code_point <= 0x9f)
      end
      
      typesig { [::Java::Char] }
      # Returns a value indicating a character's general category.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #getType(int)} method.
      # 
      # @param   ch      the character to be tested.
      # @return  a value of type <code>int</code> representing the
      # character's general category.
      # @see     java.lang.Character#COMBINING_SPACING_MARK
      # @see     java.lang.Character#CONNECTOR_PUNCTUATION
      # @see     java.lang.Character#CONTROL
      # @see     java.lang.Character#CURRENCY_SYMBOL
      # @see     java.lang.Character#DASH_PUNCTUATION
      # @see     java.lang.Character#DECIMAL_DIGIT_NUMBER
      # @see     java.lang.Character#ENCLOSING_MARK
      # @see     java.lang.Character#END_PUNCTUATION
      # @see     java.lang.Character#FINAL_QUOTE_PUNCTUATION
      # @see     java.lang.Character#FORMAT
      # @see     java.lang.Character#INITIAL_QUOTE_PUNCTUATION
      # @see     java.lang.Character#LETTER_NUMBER
      # @see     java.lang.Character#LINE_SEPARATOR
      # @see     java.lang.Character#LOWERCASE_LETTER
      # @see     java.lang.Character#MATH_SYMBOL
      # @see     java.lang.Character#MODIFIER_LETTER
      # @see     java.lang.Character#MODIFIER_SYMBOL
      # @see     java.lang.Character#NON_SPACING_MARK
      # @see     java.lang.Character#OTHER_LETTER
      # @see     java.lang.Character#OTHER_NUMBER
      # @see     java.lang.Character#OTHER_PUNCTUATION
      # @see     java.lang.Character#OTHER_SYMBOL
      # @see     java.lang.Character#PARAGRAPH_SEPARATOR
      # @see     java.lang.Character#PRIVATE_USE
      # @see     java.lang.Character#SPACE_SEPARATOR
      # @see     java.lang.Character#START_PUNCTUATION
      # @see     java.lang.Character#SURROGATE
      # @see     java.lang.Character#TITLECASE_LETTER
      # @see     java.lang.Character#UNASSIGNED
      # @see     java.lang.Character#UPPERCASE_LETTER
      # @since   1.1
      def get_type(ch)
        return get_type(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Returns a value indicating a character's general category.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  a value of type <code>int</code> representing the
      # character's general category.
      # @see     Character#COMBINING_SPACING_MARK COMBINING_SPACING_MARK
      # @see     Character#CONNECTOR_PUNCTUATION CONNECTOR_PUNCTUATION
      # @see     Character#CONTROL CONTROL
      # @see     Character#CURRENCY_SYMBOL CURRENCY_SYMBOL
      # @see     Character#DASH_PUNCTUATION DASH_PUNCTUATION
      # @see     Character#DECIMAL_DIGIT_NUMBER DECIMAL_DIGIT_NUMBER
      # @see     Character#ENCLOSING_MARK ENCLOSING_MARK
      # @see     Character#END_PUNCTUATION END_PUNCTUATION
      # @see     Character#FINAL_QUOTE_PUNCTUATION FINAL_QUOTE_PUNCTUATION
      # @see     Character#FORMAT FORMAT
      # @see     Character#INITIAL_QUOTE_PUNCTUATION INITIAL_QUOTE_PUNCTUATION
      # @see     Character#LETTER_NUMBER LETTER_NUMBER
      # @see     Character#LINE_SEPARATOR LINE_SEPARATOR
      # @see     Character#LOWERCASE_LETTER LOWERCASE_LETTER
      # @see     Character#MATH_SYMBOL MATH_SYMBOL
      # @see     Character#MODIFIER_LETTER MODIFIER_LETTER
      # @see     Character#MODIFIER_SYMBOL MODIFIER_SYMBOL
      # @see     Character#NON_SPACING_MARK NON_SPACING_MARK
      # @see     Character#OTHER_LETTER OTHER_LETTER
      # @see     Character#OTHER_NUMBER OTHER_NUMBER
      # @see     Character#OTHER_PUNCTUATION OTHER_PUNCTUATION
      # @see     Character#OTHER_SYMBOL OTHER_SYMBOL
      # @see     Character#PARAGRAPH_SEPARATOR PARAGRAPH_SEPARATOR
      # @see     Character#PRIVATE_USE PRIVATE_USE
      # @see     Character#SPACE_SEPARATOR SPACE_SEPARATOR
      # @see     Character#START_PUNCTUATION START_PUNCTUATION
      # @see     Character#SURROGATE SURROGATE
      # @see     Character#TITLECASE_LETTER TITLECASE_LETTER
      # @see     Character#UNASSIGNED UNASSIGNED
      # @see     Character#UPPERCASE_LETTER UPPERCASE_LETTER
      # @since   1.5
      def get_type(code_point)
        return CharacterData.of(code_point).get_type(code_point)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Determines the character representation for a specific digit in
      # the specified radix. If the value of <code>radix</code> is not a
      # valid radix, or the value of <code>digit</code> is not a valid
      # digit in the specified radix, the null character
      # (<code>'&#92;u0000'</code>) is returned.
      # <p>
      # The <code>radix</code> argument is valid if it is greater than or
      # equal to <code>MIN_RADIX</code> and less than or equal to
      # <code>MAX_RADIX</code>. The <code>digit</code> argument is valid if
      # <code>0&nbsp;&lt;=digit&nbsp;&lt;&nbsp;radix</code>.
      # <p>
      # If the digit is less than 10, then
      # <code>'0'&nbsp;+ digit</code> is returned. Otherwise, the value
      # <code>'a'&nbsp;+ digit&nbsp;-&nbsp;10</code> is returned.
      # 
      # @param   digit   the number to convert to a character.
      # @param   radix   the radix.
      # @return  the <code>char</code> representation of the specified digit
      # in the specified radix.
      # @see     java.lang.Character#MIN_RADIX
      # @see     java.lang.Character#MAX_RADIX
      # @see     java.lang.Character#digit(char, int)
      def for_digit(digit_, radix)
        if ((digit_ >= radix) || (digit_ < 0))
          return Character.new(?\0.ord)
        end
        if ((radix < Character::MIN_RADIX) || (radix > Character::MAX_RADIX))
          return Character.new(?\0.ord)
        end
        if (digit_ < 10)
          return RJava.cast_to_char((Character.new(?0.ord) + digit_))
        end
        return RJava.cast_to_char((Character.new(?a.ord) - 10 + digit_))
      end
      
      typesig { [::Java::Char] }
      # Returns the Unicode directionality property for the given
      # character.  Character directionality is used to calculate the
      # visual ordering of text. The directionality value of undefined
      # <code>char</code> values is <code>DIRECTIONALITY_UNDEFINED</code>.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #getDirectionality(int)} method.
      # 
      # @param  ch <code>char</code> for which the directionality property
      # is requested.
      # @return the directionality property of the <code>char</code> value.
      # 
      # @see Character#DIRECTIONALITY_UNDEFINED
      # @see Character#DIRECTIONALITY_LEFT_TO_RIGHT
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC
      # @see Character#DIRECTIONALITY_EUROPEAN_NUMBER
      # @see Character#DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR
      # @see Character#DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR
      # @see Character#DIRECTIONALITY_ARABIC_NUMBER
      # @see Character#DIRECTIONALITY_COMMON_NUMBER_SEPARATOR
      # @see Character#DIRECTIONALITY_NONSPACING_MARK
      # @see Character#DIRECTIONALITY_BOUNDARY_NEUTRAL
      # @see Character#DIRECTIONALITY_PARAGRAPH_SEPARATOR
      # @see Character#DIRECTIONALITY_SEGMENT_SEPARATOR
      # @see Character#DIRECTIONALITY_WHITESPACE
      # @see Character#DIRECTIONALITY_OTHER_NEUTRALS
      # @see Character#DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING
      # @see Character#DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE
      # @see Character#DIRECTIONALITY_POP_DIRECTIONAL_FORMAT
      # @since 1.4
      def get_directionality(ch)
        return get_directionality(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Returns the Unicode directionality property for the given
      # character (Unicode code point).  Character directionality is
      # used to calculate the visual ordering of text. The
      # directionality value of undefined character is {@link
      # #DIRECTIONALITY_UNDEFINED}.
      # 
      # @param   codePoint the character (Unicode code point) for which
      # the directionality property is requested.
      # @return the directionality property of the character.
      # 
      # @see Character#DIRECTIONALITY_UNDEFINED DIRECTIONALITY_UNDEFINED
      # @see Character#DIRECTIONALITY_LEFT_TO_RIGHT DIRECTIONALITY_LEFT_TO_RIGHT
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT DIRECTIONALITY_RIGHT_TO_LEFT
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC
      # @see Character#DIRECTIONALITY_EUROPEAN_NUMBER DIRECTIONALITY_EUROPEAN_NUMBER
      # @see Character#DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR
      # @see Character#DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR
      # @see Character#DIRECTIONALITY_ARABIC_NUMBER DIRECTIONALITY_ARABIC_NUMBER
      # @see Character#DIRECTIONALITY_COMMON_NUMBER_SEPARATOR DIRECTIONALITY_COMMON_NUMBER_SEPARATOR
      # @see Character#DIRECTIONALITY_NONSPACING_MARK DIRECTIONALITY_NONSPACING_MARK
      # @see Character#DIRECTIONALITY_BOUNDARY_NEUTRAL DIRECTIONALITY_BOUNDARY_NEUTRAL
      # @see Character#DIRECTIONALITY_PARAGRAPH_SEPARATOR DIRECTIONALITY_PARAGRAPH_SEPARATOR
      # @see Character#DIRECTIONALITY_SEGMENT_SEPARATOR DIRECTIONALITY_SEGMENT_SEPARATOR
      # @see Character#DIRECTIONALITY_WHITESPACE DIRECTIONALITY_WHITESPACE
      # @see Character#DIRECTIONALITY_OTHER_NEUTRALS DIRECTIONALITY_OTHER_NEUTRALS
      # @see Character#DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING
      # @see Character#DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING
      # @see Character#DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE
      # @see Character#DIRECTIONALITY_POP_DIRECTIONAL_FORMAT DIRECTIONALITY_POP_DIRECTIONAL_FORMAT
      # @since    1.5
      def get_directionality(code_point)
        return CharacterData.of(code_point).get_directionality(code_point)
      end
      
      typesig { [::Java::Char] }
      # Determines whether the character is mirrored according to the
      # Unicode specification.  Mirrored characters should have their
      # glyphs horizontally mirrored when displayed in text that is
      # right-to-left.  For example, <code>'&#92;u0028'</code> LEFT
      # PARENTHESIS is semantically defined to be an <i>opening
      # parenthesis</i>.  This will appear as a "(" in text that is
      # left-to-right but as a ")" in text that is right-to-left.
      # 
      # <p><b>Note:</b> This method cannot handle <a
      # href="#supplementary"> supplementary characters</a>. To support
      # all Unicode characters, including supplementary characters, use
      # the {@link #isMirrored(int)} method.
      # 
      # @param  ch <code>char</code> for which the mirrored property is requested
      # @return <code>true</code> if the char is mirrored, <code>false</code>
      # if the <code>char</code> is not mirrored or is not defined.
      # @since 1.4
      def is_mirrored(ch)
        return is_mirrored(RJava.cast_to_int(ch))
      end
      
      typesig { [::Java::Int] }
      # Determines whether the specified character (Unicode code point)
      # is mirrored according to the Unicode specification.  Mirrored
      # characters should have their glyphs horizontally mirrored when
      # displayed in text that is right-to-left.  For example,
      # <code>'&#92;u0028'</code> LEFT PARENTHESIS is semantically
      # defined to be an <i>opening parenthesis</i>.  This will appear
      # as a "(" in text that is left-to-right but as a ")" in text
      # that is right-to-left.
      # 
      # @param   codePoint the character (Unicode code point) to be tested.
      # @return  <code>true</code> if the character is mirrored, <code>false</code>
      # if the character is not mirrored or is not defined.
      # @since   1.5
      def is_mirrored(code_point)
        return CharacterData.of(code_point).is_mirrored(code_point)
      end
    }
    
    typesig { [Character] }
    # Compares two <code>Character</code> objects numerically.
    # 
    # @param   anotherCharacter   the <code>Character</code> to be compared.
    # 
    # @return  the value <code>0</code> if the argument <code>Character</code>
    # is equal to this <code>Character</code>; a value less than
    # <code>0</code> if this <code>Character</code> is numerically less
    # than the <code>Character</code> argument; and a value greater than
    # <code>0</code> if this <code>Character</code> is numerically greater
    # than the <code>Character</code> argument (unsigned comparison).
    # Note that this is strictly a numerical comparison; it is not
    # locale-dependent.
    # @since   1.2
    def compare_to(another_character)
      return @value - another_character.attr_value
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Converts the character (Unicode code point) argument to uppercase using
      # information from the UnicodeData file.
      # <p>
      # 
      # @param   codePoint   the character (Unicode code point) to be converted.
      # @return  either the uppercase equivalent of the character, if
      # any, or an error flag (<code>Character.ERROR</code>)
      # that indicates that a 1:M <code>char</code> mapping exists.
      # @see     java.lang.Character#isLowerCase(char)
      # @see     java.lang.Character#isUpperCase(char)
      # @see     java.lang.Character#toLowerCase(char)
      # @see     java.lang.Character#toTitleCase(char)
      # @since 1.4
      def to_upper_case_ex(code_point)
        raise AssertError if not (is_valid_code_point(code_point))
        return CharacterData.of(code_point).to_upper_case_ex(code_point)
      end
      
      typesig { [::Java::Int] }
      # Converts the character (Unicode code point) argument to uppercase using case
      # mapping information from the SpecialCasing file in the Unicode
      # specification. If a character has no explicit uppercase
      # mapping, then the <code>char</code> itself is returned in the
      # <code>char[]</code>.
      # 
      # @param   codePoint   the character (Unicode code point) to be converted.
      # @return a <code>char[]</code> with the uppercased character.
      # @since 1.4
      def to_upper_case_char_array(code_point)
        # As of Unicode 4.0, 1:M uppercasings only happen in the BMP.
        raise AssertError if not (is_valid_code_point(code_point) && !is_supplementary_code_point(code_point))
        return CharacterData.of(code_point).to_upper_case_char_array(code_point)
      end
      
      # The number of bits used to represent a <tt>char</tt> value in unsigned
      # binary form.
      # 
      # @since 1.5
      const_set_lazy(:SIZE) { 16 }
      const_attr_reader  :SIZE
      
      typesig { [::Java::Char] }
      # Returns the value obtained by reversing the order of the bytes in the
      # specified <tt>char</tt> value.
      # 
      # @return the value obtained by reversing (or, equivalently, swapping)
      # the bytes in the specified <tt>char</tt> value.
      # @since 1.5
      def reverse_bytes(ch)
        return RJava.cast_to_char((((ch & 0xff00) >> 8) | (ch << 8)))
      end
    }
    
    private
    alias_method :initialize__character, :initialize
  end
  
end
