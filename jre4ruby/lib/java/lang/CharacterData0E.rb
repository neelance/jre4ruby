require "rjava"
 # This file was generated AUTOMATICALLY from a template file Thu May 07 16:22:38 CEST 2009
# 
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
  module CharacterData0EImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The CharacterData class encapsulates the large tables found in
  # Java.lang.Character.
  class CharacterData0E < CharacterData0EImports.const_get :CharacterData
    include_class_members CharacterData0EImports
    
    typesig { [::Java::Int] }
    # The character properties are currently encoded into 32 bits in the following manner:
    # 1 bit   mirrored property
    # 4 bits  directionality property
    # 9 bits  signed offset used for converting case
    # 1 bit   if 1, adding the signed offset converts the character to lowercase
    # 1 bit   if 1, subtracting the signed offset converts the character to uppercase
    # 1 bit   if 1, this character has a titlecase equivalent (possibly itself)
    # 3 bits  0  may not be part of an identifier
    # 1  ignorable control; may continue a Unicode identifier or Java identifier
    # 2  may continue a Java identifier but not a Unicode identifier (unused)
    # 3  may continue a Unicode identifier or Java identifier
    # 4  is a Java whitespace character
    # 5  may start or continue a Java identifier;
    # may continue but not start a Unicode identifier (underscores)
    # 6  may start or continue a Java identifier but not a Unicode identifier ($)
    # 7  may start or continue a Unicode identifier or Java identifier
    # Thus:
    # 5, 6, 7 may start a Java identifier
    # 1, 2, 3, 5, 6, 7 may continue a Java identifier
    # 7 may start a Unicode identifier
    # 1, 3, 5, 7 may continue a Unicode identifier
    # 1 is ignorable within an identifier
    # 4 is Java whitespace
    # 2 bits  0  this character has no numeric property
    # 1  adding the digit offset to the character code and then
    # masking with 0x1F will produce the desired numeric value
    # 2  this character has a "strange" numeric value
    # 3  a Java supradecimal digit: adding the digit offset to the
    # character code, then masking with 0x1F, then adding 10
    # will produce the desired numeric value
    # 5 bits  digit offset
    # 5 bits  character type
    # 
    # The encoding of character properties is subject to change at any time.
    def get_properties(ch)
      offset = RJava.cast_to_char(ch)
      props = A[Y[X[offset >> 5] | ((offset >> 1) & 0xf)] | (offset & 0x1)]
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
      # cannot occur
      when (0x0)
        # not numeric
        retval = -1
      when (0x400)
        # simple numeric
        retval = ch + ((val & 0x3e0) >> 5) & 0x1f
      when (0x800)
        # "strange" numeric
        retval = -2
      when (0xc00)
        # Java supradecimal
        retval = (ch + ((val & 0x3e0) >> 5) & 0x1f) + 10
      else
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
      const_set_lazy(:Instance) { CharacterData0E.new }
      const_attr_reader  :Instance
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    class_module.module_eval {
      # The following tables and code generated using:
      # java GenerateCharacter -plane 14 -template ../../tools/GenerateCharacter/CharacterData0E.java.template -spec ../../tools/UnicodeData/UnicodeData.txt -specialcasing ../../tools/UnicodeData/SpecialCasing.txt -o ../../../build/linux-amd64/gensrc/java/lang/CharacterData0E.java -string -usecharforbyte 11 4 1
      # The X table has 2048 entries for a total of 4096 bytes.
      const_set_lazy(:X) { ("\000\020\020\020\040\040\040\040\060\060\060\060\060\060\060\100\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040" + "\040\040\040\040\040\040\040\040\040\040\040\040\040\040\040").to_char_array }
      const_attr_reader  :X
      
      # The Y table has 80 entries for a total of 160 bytes.
      const_set_lazy(:Y) { ("\000\002\002\002\002\002\002\002\002\002\002\002\002\002\002\002\004\004\004" + "\004\004\004\004\004\004\004\004\004\004\004\004\004\002\002\002\002\002\002" + "\002\002\002\002\002\002\002\002\002\002\006\006\006\006\006\006\006\006\006" + "\006\006\006\006\006\006\006\006\006\006\006\006\006\006\006\002\002\002\002" + "\002\002\002\002").to_char_array }
      const_attr_reader  :Y
      
      # The A table has 8 entries for a total of 32 bytes.
      const_set_lazy(:A) { Array.typed(::Java::Int).new(8) { 0 } }
      const_attr_reader  :A
      
      const_set_lazy(:A_DATA) { ("".to_u << 0x7800 << "\000".to_u << 0x4800 << "".to_u << 0x1010 << "".to_u << 0x7800 << "\000".to_u << 0x7800 << "\000".to_u << 0x4800 << "".to_u << 0x1010 << "".to_u << 0x4800 << "".to_u << 0x1010 << "".to_u << 0x4000 << "".to_u << 0x3006 << "") + ("".to_u << 0x4000 << "".to_u << 0x3006 << "") }
      const_attr_reader  :A_DATA
      
      # In all, the character property tables require 4288 bytes.
      when_class_loaded do
        # THIS CODE WAS AUTOMATICALLY CREATED BY GenerateCharacter:
        data = A_DATA.to_char_array
        raise AssertError if not (((data.attr_length).equal?((8 * 2))))
        i = 0
        j = 0
        while (i < (8 * 2))
          entry = data[((i += 1) - 1)] << 16
          A[((j += 1) - 1)] = entry | data[((i += 1) - 1)]
        end
      end
    }
    
    private
    alias_method :initialize__character_data0e, :initialize
  end
  
end
