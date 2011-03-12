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
# /**
#  *******************************************************************************
#  * Copyright (C) 2004, International Business Machines Corporation and         *
#  * others. All Rights Reserved.                                                *
# CHANGELOG
#      2005-05-19 Edward Wang
#          - copy this file from icu4jsrc_3_2/src/com/ibm/icu/lang/UCharacterEnums.java
#          - move from package com.ibm.icu.lang to package sun.net.idn
# 
module Sun::Net::Idn
  module UCharacterEnumsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Idn
    }
  end
  
  # A container for the different 'enumerated types' used by UCharacter.
  # @draft ICU 3.0
  # @deprecated This is a draft API and might change in a future release of ICU.
  class UCharacterEnums 
    include_class_members UCharacterEnumsImports
    
    typesig { [] }
    # This is just a namespace, it is not instantiatable.
    def initialize
    end
    
    class_module.module_eval {
      # 'Enum' for the CharacterCategory constants.  These constants are
      # compatible in name <b>but not in value</b> with those defined in
      # <code>java.lang.Character</code>.
      # @see UCharacterCategory
      # @draft ICU 3.0
      # @deprecated This is a draft API and might change in a future release of ICU.
      const_set_lazy(:ECharacterCategory) { Module.new do
        include_class_members UCharacterEnums
        
        class_module.module_eval {
          # Unassigned character type
          # @stable ICU 2.1
          const_set_lazy(:UNASSIGNED) { 0 }
          const_attr_reader  :UNASSIGNED
          
          # Character type Cn
          # Not Assigned (no characters in [UnicodeData.txt] have this property)
          # @stable ICU 2.6
          const_set_lazy(:GENERAL_OTHER_TYPES) { 0 }
          const_attr_reader  :GENERAL_OTHER_TYPES
          
          # Character type Lu
          # @stable ICU 2.1
          const_set_lazy(:UPPERCASE_LETTER) { 1 }
          const_attr_reader  :UPPERCASE_LETTER
          
          # Character type Ll
          # @stable ICU 2.1
          const_set_lazy(:LOWERCASE_LETTER) { 2 }
          const_attr_reader  :LOWERCASE_LETTER
          
          # Character type Lt
          # @stable ICU 2.1
          const_set_lazy(:TITLECASE_LETTER) { 3 }
          const_attr_reader  :TITLECASE_LETTER
          
          # Character type Lm
          # @stable ICU 2.1
          const_set_lazy(:MODIFIER_LETTER) { 4 }
          const_attr_reader  :MODIFIER_LETTER
          
          # Character type Lo
          # @stable ICU 2.1
          const_set_lazy(:OTHER_LETTER) { 5 }
          const_attr_reader  :OTHER_LETTER
          
          # Character type Mn
          # @stable ICU 2.1
          const_set_lazy(:NON_SPACING_MARK) { 6 }
          const_attr_reader  :NON_SPACING_MARK
          
          # Character type Me
          # @stable ICU 2.1
          const_set_lazy(:ENCLOSING_MARK) { 7 }
          const_attr_reader  :ENCLOSING_MARK
          
          # Character type Mc
          # @stable ICU 2.1
          const_set_lazy(:COMBINING_SPACING_MARK) { 8 }
          const_attr_reader  :COMBINING_SPACING_MARK
          
          # Character type Nd
          # @stable ICU 2.1
          const_set_lazy(:DECIMAL_DIGIT_NUMBER) { 9 }
          const_attr_reader  :DECIMAL_DIGIT_NUMBER
          
          # Character type Nl
          # @stable ICU 2.1
          const_set_lazy(:LETTER_NUMBER) { 10 }
          const_attr_reader  :LETTER_NUMBER
          
          # Character type No
          # @stable ICU 2.1
          const_set_lazy(:OTHER_NUMBER) { 11 }
          const_attr_reader  :OTHER_NUMBER
          
          # Character type Zs
          # @stable ICU 2.1
          const_set_lazy(:SPACE_SEPARATOR) { 12 }
          const_attr_reader  :SPACE_SEPARATOR
          
          # Character type Zl
          # @stable ICU 2.1
          const_set_lazy(:LINE_SEPARATOR) { 13 }
          const_attr_reader  :LINE_SEPARATOR
          
          # Character type Zp
          # @stable ICU 2.1
          const_set_lazy(:PARAGRAPH_SEPARATOR) { 14 }
          const_attr_reader  :PARAGRAPH_SEPARATOR
          
          # Character type Cc
          # @stable ICU 2.1
          const_set_lazy(:CONTROL) { 15 }
          const_attr_reader  :CONTROL
          
          # Character type Cf
          # @stable ICU 2.1
          const_set_lazy(:FORMAT) { 16 }
          const_attr_reader  :FORMAT
          
          # Character type Co
          # @stable ICU 2.1
          const_set_lazy(:PRIVATE_USE) { 17 }
          const_attr_reader  :PRIVATE_USE
          
          # Character type Cs
          # @stable ICU 2.1
          const_set_lazy(:SURROGATE) { 18 }
          const_attr_reader  :SURROGATE
          
          # Character type Pd
          # @stable ICU 2.1
          const_set_lazy(:DASH_PUNCTUATION) { 19 }
          const_attr_reader  :DASH_PUNCTUATION
          
          # Character type Ps
          # @stable ICU 2.1
          const_set_lazy(:START_PUNCTUATION) { 20 }
          const_attr_reader  :START_PUNCTUATION
          
          # Character type Pe
          # @stable ICU 2.1
          const_set_lazy(:END_PUNCTUATION) { 21 }
          const_attr_reader  :END_PUNCTUATION
          
          # Character type Pc
          # @stable ICU 2.1
          const_set_lazy(:CONNECTOR_PUNCTUATION) { 22 }
          const_attr_reader  :CONNECTOR_PUNCTUATION
          
          # Character type Po
          # @stable ICU 2.1
          const_set_lazy(:OTHER_PUNCTUATION) { 23 }
          const_attr_reader  :OTHER_PUNCTUATION
          
          # Character type Sm
          # @stable ICU 2.1
          const_set_lazy(:MATH_SYMBOL) { 24 }
          const_attr_reader  :MATH_SYMBOL
          
          # Character type Sc
          # @stable ICU 2.1
          const_set_lazy(:CURRENCY_SYMBOL) { 25 }
          const_attr_reader  :CURRENCY_SYMBOL
          
          # Character type Sk
          # @stable ICU 2.1
          const_set_lazy(:MODIFIER_SYMBOL) { 26 }
          const_attr_reader  :MODIFIER_SYMBOL
          
          # Character type So
          # @stable ICU 2.1
          const_set_lazy(:OTHER_SYMBOL) { 27 }
          const_attr_reader  :OTHER_SYMBOL
          
          # Character type Pi
          # @see #INITIAL_QUOTE_PUNCTUATION
          # @stable ICU 2.1
          const_set_lazy(:INITIAL_PUNCTUATION) { 28 }
          const_attr_reader  :INITIAL_PUNCTUATION
          
          #   * Character type Pi
          #   * This name is compatible with java.lang.Character's name for this type.
          #   * @see #INITIAL_PUNCTUATION
          #   * @draft ICU 2.8
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:INITIAL_QUOTE_PUNCTUATION) { 28 }
          const_attr_reader  :INITIAL_QUOTE_PUNCTUATION
          
          # Character type Pf
          # @see #FINAL_QUOTE_PUNCTUATION
          # @stable ICU 2.1
          const_set_lazy(:FINAL_PUNCTUATION) { 29 }
          const_attr_reader  :FINAL_PUNCTUATION
          
          #   * Character type Pf
          #   * This name is compatible with java.lang.Character's name for this type.
          #   * @see #FINAL_PUNCTUATION
          #   * @draft ICU 2.8
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:FINAL_QUOTE_PUNCTUATION) { 29 }
          const_attr_reader  :FINAL_QUOTE_PUNCTUATION
          
          # Character type count
          # @stable ICU 2.1
          const_set_lazy(:CHAR_CATEGORY_COUNT) { 30 }
          const_attr_reader  :CHAR_CATEGORY_COUNT
        }
      end }
      
      # 'Enum' for the CharacterDirection constants.  There are two sets
      # of names, those used in ICU, and those used in the JDK.  The
      # JDK constants are compatible in name <b>but not in value</b>
      # with those defined in <code>java.lang.Character</code>.
      # @see UCharacterDirection
      # @draft ICU 3.0
      # @deprecated This is a draft API and might change in a future release of ICU.
      const_set_lazy(:ECharacterDirection) { Module.new do
        include_class_members UCharacterEnums
        
        class_module.module_eval {
          # Directional type L
          # @stable ICU 2.1
          const_set_lazy(:LEFT_TO_RIGHT) { 0 }
          const_attr_reader  :LEFT_TO_RIGHT
          
          #   * JDK-compatible synonum for LEFT_TO_RIGHT.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_LEFT_TO_RIGHT) { LEFT_TO_RIGHT }
          const_attr_reader  :DIRECTIONALITY_LEFT_TO_RIGHT
          
          # Directional type R
          # @stable ICU 2.1
          const_set_lazy(:RIGHT_TO_LEFT) { 1 }
          const_attr_reader  :RIGHT_TO_LEFT
          
          #   * JDK-compatible synonum for RIGHT_TO_LEFT.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT) { RIGHT_TO_LEFT }
          const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT
          
          # Directional type EN
          # @stable ICU 2.1
          const_set_lazy(:EUROPEAN_NUMBER) { 2 }
          const_attr_reader  :EUROPEAN_NUMBER
          
          #   * JDK-compatible synonum for EUROPEAN_NUMBER.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_EUROPEAN_NUMBER) { EUROPEAN_NUMBER }
          const_attr_reader  :DIRECTIONALITY_EUROPEAN_NUMBER
          
          # Directional type ES
          # @stable ICU 2.1
          const_set_lazy(:EUROPEAN_NUMBER_SEPARATOR) { 3 }
          const_attr_reader  :EUROPEAN_NUMBER_SEPARATOR
          
          #   * JDK-compatible synonum for EUROPEAN_NUMBER_SEPARATOR.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR) { EUROPEAN_NUMBER_SEPARATOR }
          const_attr_reader  :DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR
          
          # Directional type ET
          # @stable ICU 2.1
          const_set_lazy(:EUROPEAN_NUMBER_TERMINATOR) { 4 }
          const_attr_reader  :EUROPEAN_NUMBER_TERMINATOR
          
          #   * JDK-compatible synonum for EUROPEAN_NUMBER_TERMINATOR.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR) { EUROPEAN_NUMBER_TERMINATOR }
          const_attr_reader  :DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR
          
          # Directional type AN
          # @stable ICU 2.1
          const_set_lazy(:ARABIC_NUMBER) { 5 }
          const_attr_reader  :ARABIC_NUMBER
          
          #   * JDK-compatible synonum for ARABIC_NUMBER.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_ARABIC_NUMBER) { ARABIC_NUMBER }
          const_attr_reader  :DIRECTIONALITY_ARABIC_NUMBER
          
          # Directional type CS
          # @stable ICU 2.1
          const_set_lazy(:COMMON_NUMBER_SEPARATOR) { 6 }
          const_attr_reader  :COMMON_NUMBER_SEPARATOR
          
          #   * JDK-compatible synonum for COMMON_NUMBER_SEPARATOR.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_COMMON_NUMBER_SEPARATOR) { COMMON_NUMBER_SEPARATOR }
          const_attr_reader  :DIRECTIONALITY_COMMON_NUMBER_SEPARATOR
          
          # Directional type B
          # @stable ICU 2.1
          const_set_lazy(:BLOCK_SEPARATOR) { 7 }
          const_attr_reader  :BLOCK_SEPARATOR
          
          #   * JDK-compatible synonum for BLOCK_SEPARATOR.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_PARAGRAPH_SEPARATOR) { BLOCK_SEPARATOR }
          const_attr_reader  :DIRECTIONALITY_PARAGRAPH_SEPARATOR
          
          # Directional type S
          # @stable ICU 2.1
          const_set_lazy(:SEGMENT_SEPARATOR) { 8 }
          const_attr_reader  :SEGMENT_SEPARATOR
          
          #   * JDK-compatible synonum for SEGMENT_SEPARATOR.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_SEGMENT_SEPARATOR) { SEGMENT_SEPARATOR }
          const_attr_reader  :DIRECTIONALITY_SEGMENT_SEPARATOR
          
          # Directional type WS
          # @stable ICU 2.1
          const_set_lazy(:WHITE_SPACE_NEUTRAL) { 9 }
          const_attr_reader  :WHITE_SPACE_NEUTRAL
          
          #   * JDK-compatible synonum for WHITE_SPACE_NEUTRAL.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_WHITESPACE) { WHITE_SPACE_NEUTRAL }
          const_attr_reader  :DIRECTIONALITY_WHITESPACE
          
          # Directional type ON
          # @stable ICU 2.1
          const_set_lazy(:OTHER_NEUTRAL) { 10 }
          const_attr_reader  :OTHER_NEUTRAL
          
          #   * JDK-compatible synonum for OTHER_NEUTRAL.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_OTHER_NEUTRALS) { OTHER_NEUTRAL }
          const_attr_reader  :DIRECTIONALITY_OTHER_NEUTRALS
          
          # Directional type LRE
          # @stable ICU 2.1
          const_set_lazy(:LEFT_TO_RIGHT_EMBEDDING) { 11 }
          const_attr_reader  :LEFT_TO_RIGHT_EMBEDDING
          
          #   * JDK-compatible synonum for LEFT_TO_RIGHT_EMBEDDING.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING) { LEFT_TO_RIGHT_EMBEDDING }
          const_attr_reader  :DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING
          
          # Directional type LRO
          # @stable ICU 2.1
          const_set_lazy(:LEFT_TO_RIGHT_OVERRIDE) { 12 }
          const_attr_reader  :LEFT_TO_RIGHT_OVERRIDE
          
          #   * JDK-compatible synonum for LEFT_TO_RIGHT_OVERRIDE.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE) { LEFT_TO_RIGHT_OVERRIDE }
          const_attr_reader  :DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE
          
          # Directional type AL
          # @stable ICU 2.1
          const_set_lazy(:RIGHT_TO_LEFT_ARABIC) { 13 }
          const_attr_reader  :RIGHT_TO_LEFT_ARABIC
          
          #   * JDK-compatible synonum for RIGHT_TO_LEFT_ARABIC.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC) { RIGHT_TO_LEFT_ARABIC }
          const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC
          
          # Directional type RLE
          # @stable ICU 2.1
          const_set_lazy(:RIGHT_TO_LEFT_EMBEDDING) { 14 }
          const_attr_reader  :RIGHT_TO_LEFT_EMBEDDING
          
          #   * JDK-compatible synonum for RIGHT_TO_LEFT_EMBEDDING.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING) { RIGHT_TO_LEFT_EMBEDDING }
          const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING
          
          # Directional type RLO
          # @stable ICU 2.1
          const_set_lazy(:RIGHT_TO_LEFT_OVERRIDE) { 15 }
          const_attr_reader  :RIGHT_TO_LEFT_OVERRIDE
          
          #   * JDK-compatible synonum for RIGHT_TO_LEFT_OVERRIDE.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE) { RIGHT_TO_LEFT_OVERRIDE }
          const_attr_reader  :DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE
          
          # Directional type PDF
          # @stable ICU 2.1
          const_set_lazy(:POP_DIRECTIONAL_FORMAT) { 16 }
          const_attr_reader  :POP_DIRECTIONAL_FORMAT
          
          #   * JDK-compatible synonum for POP_DIRECTIONAL_FORMAT.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_POP_DIRECTIONAL_FORMAT) { POP_DIRECTIONAL_FORMAT }
          const_attr_reader  :DIRECTIONALITY_POP_DIRECTIONAL_FORMAT
          
          # Directional type NSM
          # @stable ICU 2.1
          const_set_lazy(:DIR_NON_SPACING_MARK) { 17 }
          const_attr_reader  :DIR_NON_SPACING_MARK
          
          #   * JDK-compatible synonum for DIR_NON_SPACING_MARK.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_NON_SPACING_MARK) { DIR_NON_SPACING_MARK }
          const_attr_reader  :DIRECTIONALITY_NON_SPACING_MARK
          
          # Directional type BN
          # @stable ICU 2.1
          const_set_lazy(:BOUNDARY_NEUTRAL) { 18 }
          const_attr_reader  :BOUNDARY_NEUTRAL
          
          #   * JDK-compatible synonum for BOUNDARY_NEUTRAL.
          #   * @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_BOUNDARY_NEUTRAL) { BOUNDARY_NEUTRAL }
          const_attr_reader  :DIRECTIONALITY_BOUNDARY_NEUTRAL
          
          # Number of directional types
          # @stable ICU 2.1
          const_set_lazy(:CHAR_DIRECTION_COUNT) { 19 }
          const_attr_reader  :CHAR_DIRECTION_COUNT
          
          #   * Undefined bidirectional character type. Undefined <code>char</code>
          #   * values have undefined directionality in the Unicode specification.
          # @draft ICU 3.0
          # @deprecated This is a draft API and might change in a future release of ICU.
          const_set_lazy(:DIRECTIONALITY_UNDEFINED) { -1 }
          const_attr_reader  :DIRECTIONALITY_UNDEFINED
        }
      end }
    }
    
    private
    alias_method :initialize__ucharacter_enums, :initialize
  end
  
end
