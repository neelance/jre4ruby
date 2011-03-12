require "rjava"
 # This file was generated AUTOMATICALLY from a template file Thu May 07 16:22:37 CEST 2009
# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CharacterData01Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The CharacterData class encapsulates the large tables once found in
  # java.lang.Character.
  class CharacterData01 < CharacterData01Imports.const_get :CharacterData
    include_class_members CharacterData01Imports
    
    typesig { [::Java::Int] }
    # The character properties are currently encoded into 32 bits in the following manner:
    #  1 bit   mirrored property
    #  4 bits  directionality property
    #  9 bits  signed offset used for converting case
    #  1 bit   if 1, adding the signed offset converts the character to lowercase
    #  1 bit   if 1, subtracting the signed offset converts the character to uppercase
    #  1 bit   if 1, this character has a titlecase equivalent (possibly itself)
    #  3 bits  0  may not be part of an identifier
    #          1  ignorable control; may continue a Unicode identifier or Java identifier
    #          2  may continue a Java identifier but not a Unicode identifier (unused)
    #          3  may continue a Unicode identifier or Java identifier
    #          4  is a Java whitespace character
    #          5  may start or continue a Java identifier;
    #             may continue but not start a Unicode identifier (underscores)
    #          6  may start or continue a Java identifier but not a Unicode identifier ($)
    #          7  may start or continue a Unicode identifier or Java identifier
    #          Thus:
    #             5, 6, 7 may start a Java identifier
    #             1, 2, 3, 5, 6, 7 may continue a Java identifier
    #             7 may start a Unicode identifier
    #             1, 3, 5, 7 may continue a Unicode identifier
    #             1 is ignorable within an identifier
    #             4 is Java whitespace
    #  2 bits  0  this character has no numeric property
    #          1  adding the digit offset to the character code and then
    #             masking with 0x1F will produce the desired numeric value
    #          2  this character has a "strange" numeric value
    #          3  a Java supradecimal digit: adding the digit offset to the
    #             character code, then masking with 0x1F, then adding 10
    #             will produce the desired numeric value
    #  5 bits  digit offset
    #  5 bits  character type
    # 
    #  The encoding of character properties is subject to change at any time.
    def get_properties(ch)
      offset = RJava.cast_to_char(ch)
      props = A[Y[(X[offset >> 5] << 4) | ((offset >> 1) & 0xf)] | (offset & 0x1)]
      return props
    end
    
    typesig { [::Java::Int] }
    def get_type(ch)
      props = get_properties(ch)
      return (props & 0x1f)
    end
    
    typesig { [::Java::Int] }
    def is_java_identifier_start(ch)
      props = get_properties(ch)
      return ((props & 0x7000) >= 0x5000)
    end
    
    typesig { [::Java::Int] }
    def is_java_identifier_part(ch)
      props = get_properties(ch)
      return (!((props & 0x3000)).equal?(0))
    end
    
    typesig { [::Java::Int] }
    def is_unicode_identifier_start(ch)
      props = get_properties(ch)
      return (((props & 0x7000)).equal?(0x7000))
    end
    
    typesig { [::Java::Int] }
    def is_unicode_identifier_part(ch)
      props = get_properties(ch)
      return (!((props & 0x1000)).equal?(0))
    end
    
    typesig { [::Java::Int] }
    def is_identifier_ignorable(ch)
      props = get_properties(ch)
      return (((props & 0x7000)).equal?(0x1000))
    end
    
    typesig { [::Java::Int] }
    def to_lower_case(ch)
      map_char = ch
      val = get_properties(ch)
      if (!((val & 0x20000)).equal?(0))
        offset = val << 5 >> (5 + 18)
        map_char = ch + offset
      end
      return map_char
    end
    
    typesig { [::Java::Int] }
    def to_upper_case(ch)
      map_char = ch
      val = get_properties(ch)
      if (!((val & 0x10000)).equal?(0))
        offset = val << 5 >> (5 + 18)
        map_char = ch - offset
      end
      return map_char
    end
    
    typesig { [::Java::Int] }
    def to_title_case(ch)
      map_char = ch
      val = get_properties(ch)
      if (!((val & 0x8000)).equal?(0))
        # There is a titlecase equivalent.  Perform further checks:
        if (((val & 0x10000)).equal?(0))
          # The character does not have an uppercase equivalent, so it must
          # already be uppercase; so add 1 to get the titlecase form.
          map_char = ch + 1
        else
          if (((val & 0x20000)).equal?(0))
            # The character does not have a lowercase equivalent, so it must
            # already be lowercase; so subtract 1 to get the titlecase form.
            map_char = ch - 1
          end
        end
        # else {
        # The character has both an uppercase equivalent and a lowercase
        # equivalent, so it must itself be a titlecase form; return it.
        # return ch;
        # }
      else
        if (!((val & 0x10000)).equal?(0))
          # This character has no titlecase equivalent but it does have an
          # uppercase equivalent, so use that (subtract the signed case offset).
          map_char = to_upper_case(ch)
        end
      end
      return map_char
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def digit(ch, radix)
      value = -1
      if (radix >= Character::MIN_RADIX && radix <= Character::MAX_RADIX)
        val = get_properties(ch)
        kind = val & 0x1f
        if ((kind).equal?(Character::DECIMAL_DIGIT_NUMBER))
          value = ch + ((val & 0x3e0) >> 5) & 0x1f
        else
          if (((val & 0xc00)).equal?(0xc00))
            # Java supradecimal digit
            value = (ch + ((val & 0x3e0) >> 5) & 0x1f) + 10
          end
        end
      end
      return (value < radix) ? value : -1
    end
    
    typesig { [::Java::Int] }
    def get_numeric_value(ch)
      val = get_properties(ch)
      retval = -1
      case (val & 0xc00)
      when (0x0)
        # cannot occur
        # not numeric
        retval = -1
      when (0x400)
        # simple numeric
        retval = ch + ((val & 0x3e0) >> 5) & 0x1f
      when (0x800)
        # "strange" numeric
        case (ch)
        when 0x10113
          retval = 40
        when 0x10114
          # AEGEAN NUMBER FORTY
          retval = 50
        when 0x10115
          # AEGEAN NUMBER FIFTY
          retval = 60
        when 0x10116
          # AEGEAN NUMBER SIXTY
          retval = 70
        when 0x10117
          # AEGEAN NUMBER SEVENTY
          retval = 80
        when 0x10118
          # AEGEAN NUMBER EIGHTY
          retval = 90
        when 0x10119
          # AEGEAN NUMBER NINETY
          retval = 100
        when 0x1011a
          # AEGEAN NUMBER ONE HUNDRED
          retval = 200
        when 0x1011b
          # AEGEAN NUMBER TWO HUNDRED
          retval = 300
        when 0x1011c
          # AEGEAN NUMBER THREE HUNDRED
          retval = 400
        when 0x1011d
          # AEGEAN NUMBER FOUR HUNDRED
          retval = 500
        when 0x1011e
          # AEGEAN NUMBER FIVE HUNDRED
          retval = 600
        when 0x1011f
          # AEGEAN NUMBER SIX HUNDRED
          retval = 700
        when 0x10120
          # AEGEAN NUMBER SEVEN HUNDRED
          retval = 800
        when 0x10121
          # AEGEAN NUMBER EIGHT HUNDRED
          retval = 900
        when 0x10122
          # AEGEAN NUMBER NINE HUNDRED
          retval = 1000
        when 0x10123
          # AEGEAN NUMBER ONE THOUSAND
          retval = 2000
        when 0x10124
          # AEGEAN NUMBER TWO THOUSAND
          retval = 3000
        when 0x10125
          # AEGEAN NUMBER THREE THOUSAND
          retval = 4000
        when 0x10126
          # AEGEAN NUMBER FOUR THOUSAND
          retval = 5000
        when 0x10127
          # AEGEAN NUMBER FIVE THOUSAND
          retval = 6000
        when 0x10128
          # AEGEAN NUMBER SIX THOUSAND
          retval = 7000
        when 0x10129
          # AEGEAN NUMBER SEVEN THOUSAND
          retval = 8000
        when 0x1012a
          # AEGEAN NUMBER EIGHT THOUSAND
          retval = 9000
        when 0x1012b
          # AEGEAN NUMBER NINE THOUSAND
          retval = 10000
        when 0x1012c
          # AEGEAN NUMBER TEN THOUSAND
          retval = 20000
        when 0x1012d
          # AEGEAN NUMBER TWENTY THOUSAND
          retval = 30000
        when 0x1012e
          # AEGEAN NUMBER THIRTY THOUSAND
          retval = 40000
        when 0x1012f
          # AEGEAN NUMBER FORTY THOUSAND
          retval = 50000
        when 0x10130
          # AEGEAN NUMBER FIFTY THOUSAND
          retval = 60000
        when 0x10131
          # AEGEAN NUMBER SIXTY THOUSAND
          retval = 70000
        when 0x10132
          # AEGEAN NUMBER SEVENTY THOUSAND
          retval = 80000
        when 0x10133
          # AEGEAN NUMBER EIGHTY THOUSAND
          retval = 90000
        when 0x10323
          # AEGEAN NUMBER NINETY THOUSAND
          retval = 50
        else
          # OLD ITALIC NUMERAL FIFTY
          retval = -2
        end
      when (0xc00)
        # Java supradecimal
        retval = (ch + ((val & 0x3e0) >> 5) & 0x1f) + 10
      else
        # cannot occur
        # not numeric
        retval = -1
      end
      return retval
    end
    
    typesig { [::Java::Int] }
    def is_whitespace(ch)
      props = get_properties(ch)
      return (((props & 0x7000)).equal?(0x4000))
    end
    
    typesig { [::Java::Int] }
    def get_directionality(ch)
      val = get_properties(ch)
      directionality = ((val & 0x78000000) >> 27)
      if ((directionality).equal?(0xf))
        directionality = Character::DIRECTIONALITY_UNDEFINED
      end
      return directionality
    end
    
    typesig { [::Java::Int] }
    def is_mirrored(ch)
      props = get_properties(ch)
      return (!((props & -0x80000000)).equal?(0))
    end
    
    class_module.module_eval {
      const_set_lazy(:Instance) { CharacterData01.new }
      const_attr_reader  :Instance
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    class_module.module_eval {
      # The following tables and code generated using:
      # java GenerateCharacter -plane 1 -template ../../tools/GenerateCharacter/CharacterData01.java.template -spec ../../tools/UnicodeData/UnicodeData.txt -specialcasing ../../tools/UnicodeData/SpecialCasing.txt -o ../../../build/linux-amd64/gensrc/java/lang/CharacterData01.java -string -usecharforbyte 11 4 1
      # The X table has 2048 entries for a total of 4096 bytes.
      const_set_lazy(:X) { ("\000\001\002\003\004\004\004\005\006\007\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\010\011\012\003\013\003\003\003\014\015\016\004\017\020" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\021\022\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\023\023\023\023\023\023\023\024" + "\023\025\023\026\027\030\031\003\003\003\003\003\003\003\003\003\032\032\033" + "\003\003\003\003\003\034\035\036\037\040\041\042\043\044\045\046\047\050\034" + "\035\051\037\052\053\054\043\055\056\057\060\061\062\063\064\065\066\067\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003" + "\003\003\003\003\003\003\003\003\003\003\003\003\003\003\003").to_char_array }
      const_attr_reader  :X
      
      # The Y table has 896 entries for a total of 1792 bytes.
      const_set_lazy(:Y) { ("\000\000\000\000\000\000\002\000\000\000\000\000\000\000\000\000\000\000\000" + "\004\000\000\000\000\000\000\000\000\000\004\000\002\000\000\000\000\000\000" + "\000\006\000\000\000\000\000\000\000\006\006\006\006\006\006\006\006\006\006" + "\006\006\006\006\006\006\006\000\000\000\000\000\000\000\000\000\000\000\000" + "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\004\006" + "\006\010\012\006\014\016\016\016\016\020\022\024\024\024\024\024\024\024\024" + "\024\024\024\024\024\024\024\024\006\026\030\030\030\030\000\000\000\000\000" + "\000\000\000\000\000\000\000\000\000\000\004\032\034\006\006\006\006\006\006" + "\000\000\000\000\000\000\000\000\000\000\000\000\000\036\006\006\006\006\006" + "\006\006\006\006\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000" + "\000\040\042\042\042\042\042\042\042\042\042\042\042\042\042\042\042\042\042" + "\042\042\042\044\044\044\044\044\044\044\044\044\044\044\044\044\044\044\044" + "\044\044\044\044\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000" + "\000\000\000\000\000\000\000\000\006\046\046\046\046\046\006\006\006\006\006" + "\006\006\006\006\006\006\050\050\050\006\052\050\050\050\050\050\050\050\050" + "\050\050\050\050\050\050\050\050\050\050\050\050\050\050\054\052\006\052\054" + "\030\030\030\030\030\030\030\030\030\030\030\030\030\030\030\030\030\030\030" + "\030\030\030\030\030\030\030\030\006\006\006\006\006\030\030\030\012\006\030" + "\030\030\030\030\030\030\030\030\030\030\030\030\056\060\062\030\056\064\064" + "\066\070\070\070\072\062\062\062\074\076\062\062\062\030\030\030\030\030\030" + "\030\030\030\030\030\030\030\030\030\062\062\030\030\030\030\030\030\030\030" + "\030\030\030\030\030\030\030\030\030\030\030\030\030\030\030\030\006\100\100" + "\100\100\100\100\100\100\100\100\100\100\100\100\100\100\100\100\100\100\100" + "\100\100\100\100\100\100\102\006\006\006\006\104\104\104\104\104\104\104\104" + "\104\104\104\104\104\106\106\106\106\106\106\106\106\106\106\106\106\106\104" + "\104\104\104\104\104\104\104\104\104\104\104\104\106\106\106\110\106\106\106" + "\106\106\106\106\106\106\104\104\104\104\104\104\104\104\104\104\104\104\104" + "\106\106\106\106\106\106\106\106\106\106\106\106\106\112\104\006\112\114\112" + "\114\104\112\104\104\104\104\106\106\116\116\106\106\106\116\106\106\106\106" + "\106\104\104\104\104\104\104\104\104\104\104\104\104\104\106\106\106\106\106" + "\106\106\106\106\106\106\106\106\104\114\104\112\114\104\104\104\112\104\104" + "\104\112\106\106\106\106\106\106\106\106\106\106\106\106\106\104\114\104\112" + "\104\104\112\112\006\104\104\104\112\106\106\106\106\106\106\106\106\106\106" + "\106\106\106\104\104\104\104\104\104\104\104\104\104\104\104\104\106\106\106" + "\106\106\106\106\106\106\106\106\106\106\104\104\104\104\104\104\104\106\106" + "\106\106\106\106\106\106\106\104\106\106\106\106\106\106\106\106\106\106\106" + "\106\106\104\104\104\104\104\104\104\104\104\104\104\104\104\106\106\106\106" + "\106\106\106\106\106\106\106\106\106\104\104\104\104\104\104\104\104\106\106" + "\006\006\104\104\104\104\104\104\104\104\104\104\104\104\120\106\106\106\106" + "\106\106\106\106\106\106\106\106\122\106\106\106\104\104\104\104\104\104\104" + "\104\104\104\104\104\120\106\106\106\106\106\106\106\106\106\106\106\106\122" + "\106\106\106\104\104\104\104\104\104\104\104\104\104\104\104\120\106\106\106" + "\106\106\106\106\106\106\106\106\106\122\106\106\106\104\104\104\104\104\104" + "\104\104\104\104\104\104\120\106\106\106\106\106\106\106\106\106\106\106\106" + "\122\106\106\106\104\104\104\104\104\104\104\104\104\104\104\104\120\106\106" + "\106\106\106\106\106\106\106\106\106\106\122\106\106\106\006\006\124\124\124" + "\124\124\126\126\126\126\126\130\130\130\130\130\132\132\132\132\132\134\134" + "\134\134\134").to_char_array }
      const_attr_reader  :Y
      
      # The A table has 94 entries for a total of 376 bytes.
      const_set_lazy(:A) { Array.typed(::Java::Int).new(94) { 0 } }
      const_attr_reader  :A
      
      const_set_lazy(:A_DATA) { ("\000".to_u << 0x7005 << "\000".to_u << 0x7005 << "".to_u << 0x7800 << "\000\000".to_u << 0x7005 << "\000".to_u << 0x7005 << "".to_u << 0x7800 << "\000".to_u << 0x7800 << "\000".to_u << 0x7800 << "") + ("\000\000\030".to_u << 0x6800 << "\030\000\034".to_u << 0x7800 << "\000".to_u << 0x7800 << "\000\000".to_u << 0x074B << "\000".to_u << 0x074B << "\000") + ("".to_u << 0x074B << "\000".to_u << 0x074B << "\000".to_u << 0x046B << "\000".to_u << 0x058B << "\000".to_u << 0x080B << "\000".to_u << 0x080B << "\000".to_u << 0x080B << "".to_u << 0x7800 << "\000") + ("\000\034\000\034\000\034\000".to_u << 0x042B << "\000".to_u << 0x048B << "\000".to_u << 0x050B << "\000".to_u << 0x080B << "\000".to_u << 0x700A << "") + ("".to_u << 0x7800 << "\000".to_u << 0x7800 << "\000\000\030\242".to_u << 0x7001 << "\242".to_u << 0x7001 << "\241".to_u << 0x7002 << "\241".to_u << 0x7002 << "\000".to_u << 0x3409 << "") + ("\000".to_u << 0x3409 << "".to_u << 0x0800 << "".to_u << 0x7005 << "".to_u << 0x0800 << "".to_u << 0x7005 << "".to_u << 0x0800 << "".to_u << 0x7005 << "".to_u << 0x7800 << "\000".to_u << 0x7800 << "\000".to_u << 0x0800 << "".to_u << 0x7005 << "") + ("\000\034\000".to_u << 0x3008 << "\000".to_u << 0x3008 << "".to_u << 0x4000 << "".to_u << 0x3006 << "".to_u << 0x4000 << "".to_u << 0x3006 << "".to_u << 0x4000 << "".to_u << 0x3006 << "\000".to_u << 0x3008 << "") + ("\000".to_u << 0x3008 << "\000".to_u << 0x3008 << "".to_u << 0x4800 << "".to_u << 0x1010 << "".to_u << 0x4800 << "".to_u << 0x1010 << "".to_u << 0x4800 << "".to_u << 0x1010 << "".to_u << 0x4800 << "".to_u << 0x1010 << "".to_u << 0x4000 << "") + ("".to_u << 0x3006 << "".to_u << 0x4000 << "".to_u << 0x3006 << "\000\034\000\034".to_u << 0x4000 << "".to_u << 0x3006 << "".to_u << 0x6800 << "\034".to_u << 0x6800 << "\034".to_u << 0x6800 << "\034") + ("".to_u << 0x7800 << "\000\000".to_u << 0x7001 << "\000".to_u << 0x7001 << "\000".to_u << 0x7002 << "\000".to_u << 0x7002 << "\000".to_u << 0x7002 << "".to_u << 0x7800 << "\000\000") + ("".to_u << 0x7001 << "".to_u << 0x7800 << "\000".to_u << 0x7800 << "\000\000".to_u << 0x7001 << "".to_u << 0x7800 << "\000\000".to_u << 0x7002 << "\000".to_u << 0x7001 << "\000\031") + ("\000".to_u << 0x7002 << "\000\031".to_u << 0x1800 << "".to_u << 0x3649 << "".to_u << 0x1800 << "".to_u << 0x3649 << "".to_u << 0x1800 << "".to_u << 0x3509 << "".to_u << 0x1800 << "".to_u << 0x3509 << "".to_u << 0x1800 << "".to_u << 0x37C9 << "") + ("".to_u << 0x1800 << "".to_u << 0x37C9 << "".to_u << 0x1800 << "".to_u << 0x3689 << "".to_u << 0x1800 << "".to_u << 0x3689 << "".to_u << 0x1800 << "".to_u << 0x3549 << "".to_u << 0x1800 << "".to_u << 0x3549 << "") }
      const_attr_reader  :A_DATA
      
      # In all, the character property tables require 6264 bytes.
      when_class_loaded do
        # THIS CODE WAS AUTOMATICALLY CREATED BY GenerateCharacter:
        data = A_DATA.to_char_array
        raise AssertError if not (((data.attr_length).equal?((94 * 2))))
        i = 0
        j = 0
        while (i < (94 * 2))
          entry = data[((i += 1) - 1)] << 16
          A[((j += 1) - 1)] = entry | data[((i += 1) - 1)]
        end
      end
    }
    
    private
    alias_method :initialize__character_data01, :initialize
  end
  
end
