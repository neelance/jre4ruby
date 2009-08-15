require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Sun::Text::Resources
  module CollationData_thImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_th < CollationData_thImports.const_get :ListResourceBundle
    include_class_members CollationData_thImports
    
    typesig { [] }
    def get_contents
      # First turn on the SE Asian Vowel/Consonant
      # swapping rule
      # Put in all of the consonants, after Z
      # KO KAI
      # KHO KHAI
      # KHO KHUAT
      # KHO KHWAI
      # KHO KHON
      # KHO RAKHANG
      # NGO NGU
      # CHO CHAN
      # CHO CHING
      # CHO CHANG
      # SO SO
      # CHO CHOE
      # YO YING
      # DO CHADA
      # TO PATAK
      # THO THAN
      # THO NANGMONTHO
      # THO PHUTHAO
      # NO NEN
      # DO DEK
      # TO TAO
      # THO THUNG
      # THO THAHAN
      # THO THONG
      # NO NU
      # BO BAIMAI
      # PO PLA
      # PHO PHUNG
      # FO FA
      # PHO PHAN
      # FO FAN
      # PHO SAMPHAO
      # MO MA
      # YO YAK
      # RO RUA
      # RU
      # LO LING
      # LU
      # WO WAEN
      # SO SALA
      # SO RUSI
      # SO SUA
      # HO HIP
      # LO CHULA
      # O ANG
      # HO NOKHUK
      # 
      # Normal vowels
      # 
      # SARA A
      # MAI HAN-AKAT
      # SARA AA
      # Normalizer will decompose this character to \u0e4d\u0e32.  This is
      # a Bad Thing, because we want the separate characters to sort
      # differently than this individual one.  Since there's no public way to
      # set the decomposition to be used when creating a collator, there's
      # no way around this right now.
      # It's best to go ahead and leave the character in, because it occurs
      # this way a lot more often than it occurs as separate characters.
      # SARA AM
      # SARA I
      # SARA II
      # SARA UE
      # SARA UEE
      # SARA U
      # SARA UU
      # 
      # Preceding vowels
      # 
      # SARA E
      # SARA AE
      # SARA O
      # SARA AI MAIMUAN
      # SARA AI MAIMALAI
      # 
      # Digits
      # 
      # DIGIT ZERO
      # DIGIT ONE
      # DIGIT TWO
      # DIGIT THREE
      # DIGIT FOUR
      # DIGIT FIVE
      # DIGIT SIX
      # DIGIT SEVEN
      # DIGIT EIGHT
      # DIGIT NINE
      # Sorta tonal marks, but maybe not really
      # NIKHAHIT
      # 
      # Thai symbols are supposed to sort "after white space".
      # I'm treating this as making them sort just after the normal Latin-1
      # symbols, which are in turn after the white space.
      # 
      # right-brace
      # PAIYANNOI      (ellipsis, abbreviation)
      # MAIYAMOK
      # FONGMAN
      # ANGKHANKHU
      # KHOMUT
      # CURRENCY SYMBOL BAHT
      # These symbols are supposed to be "after all characters"
      # YAMAKKAN
      # This rare symbol also comes after all characters.  But when it is
      # used in combination with RU and LU, the combination is treated as
      # a separate letter, ala "CH" sorting after "C" in traditional Spanish.
      # LAKKHANGYAO
      # Tonal marks are primary ignorables but are treated as secondary
      # differences
      # acute accent
      # MAITAIKHU
      # MAI EK
      # MAI THO
      # MAI TRI
      # MAI CHATTAWA
      # THANTHAKHAT
      # These are supposed to be ignored, so I'm treating them as controls
      # PHINTHU
      # period
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", "! " + "& Z " + ("< ".to_u << 0x0E01 << " ") + ("< ".to_u << 0x0E02 << " ") + ("< ".to_u << 0x0E03 << " ") + ("< ".to_u << 0x0E04 << " ") + ("< ".to_u << 0x0E05 << " ") + ("< ".to_u << 0x0E06 << " ") + ("< ".to_u << 0x0E07 << " ") + ("< ".to_u << 0x0E08 << " ") + ("< ".to_u << 0x0E09 << " ") + ("< ".to_u << 0x0E0A << " ") + ("< ".to_u << 0x0E0B << " ") + ("< ".to_u << 0x0E0C << " ") + ("< ".to_u << 0x0E0D << " ") + ("< ".to_u << 0x0E0E << " ") + ("< ".to_u << 0x0E0F << " ") + ("< ".to_u << 0x0E10 << " ") + ("< ".to_u << 0x0E11 << " ") + ("< ".to_u << 0x0E12 << " ") + ("< ".to_u << 0x0E13 << " ") + ("< ".to_u << 0x0E14 << " ") + ("< ".to_u << 0x0E15 << " ") + ("< ".to_u << 0x0E16 << " ") + ("< ".to_u << 0x0E17 << " ") + ("< ".to_u << 0x0E18 << " ") + ("< ".to_u << 0x0E19 << " ") + ("< ".to_u << 0x0E1A << " ") + ("< ".to_u << 0x0E1B << " ") + ("< ".to_u << 0x0E1C << " ") + ("< ".to_u << 0x0E1D << " ") + ("< ".to_u << 0x0E1E << " ") + ("< ".to_u << 0x0E1F << " ") + ("< ".to_u << 0x0E20 << " ") + ("< ".to_u << 0x0E21 << " ") + ("< ".to_u << 0x0E22 << " ") + ("< ".to_u << 0x0E23 << " ") + ("< ".to_u << 0x0E24 << " ") + ("< ".to_u << 0x0E25 << " ") + ("< ".to_u << 0x0E26 << " ") + ("< ".to_u << 0x0E27 << " ") + ("< ".to_u << 0x0E28 << " ") + ("< ".to_u << 0x0E29 << " ") + ("< ".to_u << 0x0E2A << " ") + ("< ".to_u << 0x0E2B << " ") + ("< ".to_u << 0x0E2C << " ") + ("< ".to_u << 0x0E2D << " ") + ("< ".to_u << 0x0E2E << " ") + ("< ".to_u << 0x0E30 << " ") + ("< ".to_u << 0x0E31 << " ") + ("< ".to_u << 0x0E32 << " ") + ("< ".to_u << 0x0E33 << " ") + ("< ".to_u << 0x0E34 << " ") + ("< ".to_u << 0x0E35 << " ") + ("< ".to_u << 0x0E36 << " ") + ("< ".to_u << 0x0E37 << " ") + ("< ".to_u << 0x0E38 << " ") + ("< ".to_u << 0x0E39 << " ") + ("< ".to_u << 0x0E40 << " ") + ("< ".to_u << 0x0E41 << " ") + ("< ".to_u << 0x0E42 << " ") + ("< ".to_u << 0x0E43 << " ") + ("< ".to_u << 0x0E44 << " ") + ("< ".to_u << 0x0E50 << " ") + ("< ".to_u << 0x0E51 << " ") + ("< ".to_u << 0x0E52 << " ") + ("< ".to_u << 0x0E53 << " ") + ("< ".to_u << 0x0E54 << " ") + ("< ".to_u << 0x0E55 << " ") + ("< ".to_u << 0x0E56 << " ") + ("< ".to_u << 0x0E57 << " ") + ("< ".to_u << 0x0E58 << " ") + ("< ".to_u << 0x0E59 << " ") + ("< ".to_u << 0x0E4D << " ") + ("&'".to_u << 0x007d << "'") + ("< ".to_u << 0x0E2F << " ") + ("< ".to_u << 0x0E46 << " ") + ("< ".to_u << 0x0E4F << " ") + ("< ".to_u << 0x0E5A << " ") + ("< ".to_u << 0x0E5B << " ") + ("< ".to_u << 0x0E3F << " ") + ("< ".to_u << 0x0E4E << " ") + ("< ".to_u << 0x0E45 << " ") + ("& ".to_u << 0x0E24 << " < ".to_u << 0x0E24 << "".to_u << 0x0E45 << " ") + ("& ".to_u << 0x0E26 << " < ".to_u << 0x0E26 << "".to_u << 0x0E45 << " ") + ("& ".to_u << 0x0301 << " ") + ("; ".to_u << 0x0E47 << " ") + ("; ".to_u << 0x0E48 << " ") + ("; ".to_u << 0x0E49 << " ") + ("; ".to_u << 0x0E4A << " ") + ("; ".to_u << 0x0E4B << " ") + ("; ".to_u << 0x0E4C << " ") + ("& ".to_u << 0x0001 << " ") + ("= ".to_u << 0x0E3A << " ") + "= '.' "])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_th, :initialize
  end
  
end
