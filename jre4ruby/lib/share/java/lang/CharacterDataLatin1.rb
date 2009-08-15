require "rjava"
 # This file was generated AUTOMATICALLY from a template file Thu May 07 16:22:36 CEST 2009
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
  module CharacterDataLatin1Imports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The CharacterData class encapsulates the large tables found in
  # Java.lang.Character.
  class CharacterDataLatin1 < CharacterDataLatin1Imports.const_get :CharacterData
    include_class_members CharacterDataLatin1Imports
    
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
      props = A[offset]
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
      if ((!((val & 0x20000)).equal?(0)) && (!((val & 0x7fc0000)).equal?(0x7fc0000)))
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
        if (!((val & 0x7fc0000)).equal?(0x7fc0000))
          offset = val << 5 >> (5 + 18)
          map_char = ch - offset
        else
          if ((ch).equal?(0xb5))
            map_char = 0x39c
          end
        end
      end
      return map_char
    end
    
    typesig { [::Java::Int] }
    def to_title_case(ch)
      return to_upper_case(ch)
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
        directionality = -1
      end
      return directionality
    end
    
    typesig { [::Java::Int] }
    def is_mirrored(ch)
      props = get_properties(ch)
      return (!((props & -0x80000000)).equal?(0))
    end
    
    typesig { [::Java::Int] }
    def to_upper_case_ex(ch)
      map_char = ch
      val = get_properties(ch)
      if (!((val & 0x10000)).equal?(0))
        if (!((val & 0x7fc0000)).equal?(0x7fc0000))
          offset = val << 5 >> (5 + 18)
          map_char = ch - offset
        else
          case (ch)
          # map overflow characters
          when 0xb5
            map_char = 0x39c
          else
            map_char = Character::ERROR
          end
        end
      end
      return map_char
    end
    
    class_module.module_eval {
      
      def sharps_map
        defined?(@@sharps_map) ? @@sharps_map : @@sharps_map= Array.typed(::Java::Char).new([Character.new(?S.ord), Character.new(?S.ord)])
      end
      alias_method :attr_sharps_map, :sharps_map
      
      def sharps_map=(value)
        @@sharps_map = value
      end
      alias_method :attr_sharps_map=, :sharps_map=
    }
    
    typesig { [::Java::Int] }
    def to_upper_case_char_array(ch)
      upper_map = Array.typed(::Java::Char).new([RJava.cast_to_char(ch)])
      if ((ch).equal?(0xdf))
        upper_map = self.attr_sharps_map
      end
      return upper_map
    end
    
    class_module.module_eval {
      const_set_lazy(:Instance) { CharacterDataLatin1.new }
      const_attr_reader  :Instance
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    class_module.module_eval {
      # The following tables and code generated using:
      # java GenerateCharacter -template ../../tools/GenerateCharacter/CharacterDataLatin1.java.template -spec ../../tools/UnicodeData/UnicodeData.txt -specialcasing ../../tools/UnicodeData/SpecialCasing.txt -o ../../../build/linux-amd64/gensrc/java/lang/CharacterDataLatin1.java -string -usecharforbyte -latin1 8
      # The A table has 256 entries for a total of 1024 bytes.
      const_set_lazy(:A) { Array.typed(::Java::Int).new(256) { 0 } }
      const_attr_reader  :A
      
      const_set_lazy(:A_DATA) { ("".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "") + ("".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x5800 << "".to_u << 0x400F << "".to_u << 0x5000 << "".to_u << 0x400F << "".to_u << 0x5800 << "".to_u << 0x400F << "".to_u << 0x6000 << "".to_u << 0x400F << "") + ("".to_u << 0x5000 << "".to_u << 0x400F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "") + ("".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "") + ("".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x5000 << "".to_u << 0x400F << "".to_u << 0x5000 << "".to_u << 0x400F << "".to_u << 0x5000 << "".to_u << 0x400F << "".to_u << 0x5800 << "".to_u << 0x400F << "".to_u << 0x6000 << "") + ("".to_u << 0x400C << "".to_u << 0x6800 << "\030".to_u << 0x6800 << "\030".to_u << 0x2800 << "\030".to_u << 0x2800 << "".to_u << 0x601A << "".to_u << 0x2800 << "\030".to_u << 0x6800 << "\030".to_u << 0x6800 << "") + ("\030".to_u << 0xE800 << "\025".to_u << 0xE800 << "\026".to_u << 0x6800 << "\030".to_u << 0x2800 << "\031".to_u << 0x3800 << "\030".to_u << 0x2800 << "\024".to_u << 0x3800 << "\030") + ("".to_u << 0x2000 << "\030".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "") + ("".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x1800 << "".to_u << 0x3609 << "".to_u << 0x3800 << "\030".to_u << 0x6800 << "\030") + ("".to_u << 0xE800 << "\031".to_u << 0x6800 << "\031".to_u << 0xE800 << "\031".to_u << 0x6800 << "\030".to_u << 0x6800 << "\030\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202") + ("".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "") + ("\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202") + ("".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "\202".to_u << 0x7FE1 << "") + ("\202".to_u << 0x7FE1 << "".to_u << 0xE800 << "\025".to_u << 0x6800 << "\030".to_u << 0xE800 << "\026".to_u << 0x6800 << "\033".to_u << 0x6800 << "".to_u << 0x5017 << "".to_u << 0x6800 << "\033\201") + ("".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "") + ("\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201") + ("".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "") + ("\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "\201".to_u << 0x7FE2 << "".to_u << 0xE800 << "\025".to_u << 0x6800 << "\031".to_u << 0xE800 << "\026".to_u << 0x6800 << "\031".to_u << 0x4800 << "") + ("".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x5000 << "".to_u << 0x100F << "") + ("".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "") + ("".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "") + ("".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "") + ("".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "".to_u << 0x4800 << "".to_u << 0x100F << "") + ("".to_u << 0x3800 << "\014".to_u << 0x6800 << "\030".to_u << 0x2800 << "".to_u << 0x601A << "".to_u << 0x2800 << "".to_u << 0x601A << "".to_u << 0x2800 << "".to_u << 0x601A << "".to_u << 0x2800 << "".to_u << 0x601A << "".to_u << 0x6800 << "") + ("\034".to_u << 0x6800 << "\034".to_u << 0x6800 << "\033".to_u << 0x6800 << "\034\000".to_u << 0x7002 << "".to_u << 0xE800 << "\035".to_u << 0x6800 << "\031".to_u << 0x6800 << "".to_u << 0x1010 << "") + ("".to_u << 0x6800 << "\034".to_u << 0x6800 << "\033".to_u << 0x2800 << "\034".to_u << 0x2800 << "\031".to_u << 0x1800 << "".to_u << 0x060B << "".to_u << 0x1800 << "".to_u << 0x060B << "".to_u << 0x6800 << "\033") + ("".to_u << 0x07FD << "".to_u << 0x7002 << "".to_u << 0x6800 << "\034".to_u << 0x6800 << "\030".to_u << 0x6800 << "\033".to_u << 0x1800 << "".to_u << 0x050B << "\000".to_u << 0x7002 << "".to_u << 0xE800 << "\036") + ("".to_u << 0x6800 << "".to_u << 0x080B << "".to_u << 0x6800 << "".to_u << 0x080B << "".to_u << 0x6800 << "".to_u << 0x080B << "".to_u << 0x6800 << "\030\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "") + ("\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202") + ("".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "") + ("\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "".to_u << 0x6800 << "\031\202".to_u << 0x7001 << "\202") + ("".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "\202".to_u << 0x7001 << "".to_u << 0x07FD << "".to_u << 0x7002 << "\201".to_u << 0x7002 << "") + ("\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201") + ("".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "") + ("\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "".to_u << 0x6800 << "") + ("\031\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "\201".to_u << 0x7002 << "") + ("".to_u << 0x061D << "".to_u << 0x7002 << "") }
      const_attr_reader  :A_DATA
      
      # In all, the character property tables require 1024 bytes.
      when_class_loaded do
        # THIS CODE WAS AUTOMATICALLY CREATED BY GenerateCharacter:
        data = A_DATA.to_char_array
        raise AssertError if not (((data.attr_length).equal?((256 * 2))))
        i = 0
        j = 0
        while (i < (256 * 2))
          entry = data[((i += 1) - 1)] << 16
          A[((j += 1) - 1)] = entry | data[((i += 1) - 1)]
        end
      end
    }
    
    private
    alias_method :initialize__character_data_latin1, :initialize
  end
  
end
