require "rjava"

# Copyright 1999-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Regex
  module ASCIIImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Regex
    }
  end
  
  # Utility class that implements the standard C ctype functionality.
  # 
  # @author Hong Zhang
  class ASCII 
    include_class_members ASCIIImports
    
    class_module.module_eval {
      const_set_lazy(:UPPER) { 0x100 }
      const_attr_reader  :UPPER
      
      const_set_lazy(:LOWER) { 0x200 }
      const_attr_reader  :LOWER
      
      const_set_lazy(:DIGIT) { 0x400 }
      const_attr_reader  :DIGIT
      
      const_set_lazy(:SPACE) { 0x800 }
      const_attr_reader  :SPACE
      
      const_set_lazy(:PUNCT) { 0x1000 }
      const_attr_reader  :PUNCT
      
      const_set_lazy(:CNTRL) { 0x2000 }
      const_attr_reader  :CNTRL
      
      const_set_lazy(:BLANK) { 0x4000 }
      const_attr_reader  :BLANK
      
      const_set_lazy(:HEX) { 0x8000 }
      const_attr_reader  :HEX
      
      const_set_lazy(:UNDER) { 0x10000 }
      const_attr_reader  :UNDER
      
      const_set_lazy(:ASCII) { 0xff00 }
      const_attr_reader  :ASCII
      
      const_set_lazy(:ALPHA) { (UPPER | LOWER) }
      const_attr_reader  :ALPHA
      
      const_set_lazy(:ALNUM) { (UPPER | LOWER | DIGIT) }
      const_attr_reader  :ALNUM
      
      const_set_lazy(:GRAPH) { (PUNCT | UPPER | LOWER | DIGIT) }
      const_attr_reader  :GRAPH
      
      const_set_lazy(:WORD) { (UPPER | LOWER | UNDER | DIGIT) }
      const_attr_reader  :WORD
      
      const_set_lazy(:XDIGIT) { (HEX) }
      const_attr_reader  :XDIGIT
      
      # 00 (NUL)
      # 01 (SOH)
      # 02 (STX)
      # 03 (ETX)
      # 04 (EOT)
      # 05 (ENQ)
      # 06 (ACK)
      # 07 (BEL)
      # 08 (BS)
      # 09 (HT)
      # 0A (LF)
      # 0B (VT)
      # 0C (FF)
      # 0D (CR)
      # 0E (SI)
      # 0F (SO)
      # 10 (DLE)
      # 11 (DC1)
      # 12 (DC2)
      # 13 (DC3)
      # 14 (DC4)
      # 15 (NAK)
      # 16 (SYN)
      # 17 (ETB)
      # 18 (CAN)
      # 19 (EM)
      # 1A (SUB)
      # 1B (ESC)
      # 1C (FS)
      # 1D (GS)
      # 1E (RS)
      # 1F (US)
      # 20 SPACE
      # 21 !
      # 22 "
      # 23 #
      # 24 $
      # 25 %
      # 26 &
      # 27 '
      # 28 (
      # 29 )
      # 2A *
      # 2B +
      # 2C ,
      # 2D -
      # 2E .
      # 2F /
      # 30 0
      # 31 1
      # 32 2
      # 33 3
      # 34 4
      # 35 5
      # 36 6
      # 37 7
      # 38 8
      # 39 9
      # 3A :
      # 3B ;
      # 3C <
      # 3D =
      # 3E >
      # 3F ?
      # 40 @
      # 41 A
      # 42 B
      # 43 C
      # 44 D
      # 45 E
      # 46 F
      # 47 G
      # 48 H
      # 49 I
      # 4A J
      # 4B K
      # 4C L
      # 4D M
      # 4E N
      # 4F O
      # 50 P
      # 51 Q
      # 52 R
      # 53 S
      # 54 T
      # 55 U
      # 56 V
      # 57 W
      # 58 X
      # 59 Y
      # 5A Z
      # 5B [
      # 5C \
      # 5D ]
      # 5E ^
      # 5F _
      # 60 `
      # 61 a
      # 62 b
      # 63 c
      # 64 d
      # 65 e
      # 66 f
      # 67 g
      # 68 h
      # 69 i
      # 6A j
      # 6B k
      # 6C l
      # 6D m
      # 6E n
      # 6F o
      # 70 p
      # 71 q
      # 72 r
      # 73 s
      # 74 t
      # 75 u
      # 76 v
      # 77 w
      # 78 x
      # 79 y
      # 7A z
      # 7B {
      # 7C |
      # 7D }
      # 7E ~
      # 7F (DEL)
      const_set_lazy(:Ctype) { Array.typed(::Java::Int).new([CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, SPACE + CNTRL + BLANK, SPACE + CNTRL, SPACE + CNTRL, SPACE + CNTRL, SPACE + CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, CNTRL, SPACE + BLANK, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, DIGIT + HEX + 0, DIGIT + HEX + 1, DIGIT + HEX + 2, DIGIT + HEX + 3, DIGIT + HEX + 4, DIGIT + HEX + 5, DIGIT + HEX + 6, DIGIT + HEX + 7, DIGIT + HEX + 8, DIGIT + HEX + 9, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT, UPPER + HEX + 10, UPPER + HEX + 11, UPPER + HEX + 12, UPPER + HEX + 13, UPPER + HEX + 14, UPPER + HEX + 15, UPPER + 16, UPPER + 17, UPPER + 18, UPPER + 19, UPPER + 20, UPPER + 21, UPPER + 22, UPPER + 23, UPPER + 24, UPPER + 25, UPPER + 26, UPPER + 27, UPPER + 28, UPPER + 29, UPPER + 30, UPPER + 31, UPPER + 32, UPPER + 33, UPPER + 34, UPPER + 35, PUNCT, PUNCT, PUNCT, PUNCT, PUNCT | UNDER, PUNCT, LOWER + HEX + 10, LOWER + HEX + 11, LOWER + HEX + 12, LOWER + HEX + 13, LOWER + HEX + 14, LOWER + HEX + 15, LOWER + 16, LOWER + 17, LOWER + 18, LOWER + 19, LOWER + 20, LOWER + 21, LOWER + 22, LOWER + 23, LOWER + 24, LOWER + 25, LOWER + 26, LOWER + 27, LOWER + 28, LOWER + 29, LOWER + 30, LOWER + 31, LOWER + 32, LOWER + 33, LOWER + 34, LOWER + 35, PUNCT, PUNCT, PUNCT, PUNCT, CNTRL, ]) }
      const_attr_reader  :Ctype
      
      typesig { [::Java::Int] }
      def get_type(ch)
        return (((ch & -0x80)).equal?(0) ? Ctype[ch] : 0)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def is_type(ch, type)
        return !((get_type(ch) & type)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      def is_ascii(ch)
        return (((ch & -0x80)).equal?(0))
      end
      
      typesig { [::Java::Int] }
      def is_alpha(ch)
        return is_type(ch, ALPHA)
      end
      
      typesig { [::Java::Int] }
      def is_digit(ch)
        return ((ch - Character.new(?0.ord)) | (Character.new(?9.ord) - ch)) >= 0
      end
      
      typesig { [::Java::Int] }
      def is_alnum(ch)
        return is_type(ch, ALNUM)
      end
      
      typesig { [::Java::Int] }
      def is_graph(ch)
        return is_type(ch, GRAPH)
      end
      
      typesig { [::Java::Int] }
      def is_print(ch)
        return ((ch - 0x20) | (0x7e - ch)) >= 0
      end
      
      typesig { [::Java::Int] }
      def is_punct(ch)
        return is_type(ch, PUNCT)
      end
      
      typesig { [::Java::Int] }
      def is_space(ch)
        return is_type(ch, SPACE)
      end
      
      typesig { [::Java::Int] }
      def is_hex_digit(ch)
        return is_type(ch, HEX)
      end
      
      typesig { [::Java::Int] }
      def is_oct_digit(ch)
        return ((ch - Character.new(?0.ord)) | (Character.new(?7.ord) - ch)) >= 0
      end
      
      typesig { [::Java::Int] }
      def is_cntrl(ch)
        return is_type(ch, CNTRL)
      end
      
      typesig { [::Java::Int] }
      def is_lower(ch)
        return ((ch - Character.new(?a.ord)) | (Character.new(?z.ord) - ch)) >= 0
      end
      
      typesig { [::Java::Int] }
      def is_upper(ch)
        return ((ch - Character.new(?A.ord)) | (Character.new(?Z.ord) - ch)) >= 0
      end
      
      typesig { [::Java::Int] }
      def is_word(ch)
        return is_type(ch, WORD)
      end
      
      typesig { [::Java::Int] }
      def to_digit(ch)
        return (Ctype[ch & 0x7f] & 0x3f)
      end
      
      typesig { [::Java::Int] }
      def to_lower(ch)
        return is_upper(ch) ? (ch + 0x20) : ch
      end
      
      typesig { [::Java::Int] }
      def to_upper(ch)
        return is_lower(ch) ? (ch - 0x20) : ch
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__ascii, :initialize
  end
  
end
