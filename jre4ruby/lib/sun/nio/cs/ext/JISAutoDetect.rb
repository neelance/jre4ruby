require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs::Ext
  module JISAutoDetectImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Java::Nio::Charset, :MalformedInputException
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Java::Lang::Character, :UnicodeBlock
    }
  end
  
  class JISAutoDetect < JISAutoDetectImports.const_get :Charset
    include_class_members JISAutoDetectImports
    include HistoricallyNamedCharset
    
    class_module.module_eval {
      const_set_lazy(:EUCJP_MASK) { 0x1 }
      const_attr_reader  :EUCJP_MASK
      
      const_set_lazy(:SJIS2B_MASK) { 0x2 }
      const_attr_reader  :SJIS2B_MASK
      
      const_set_lazy(:SJIS1B_MASK) { 0x4 }
      const_attr_reader  :SJIS1B_MASK
      
      const_set_lazy(:EUCJP_KANA1_MASK) { 0x8 }
      const_attr_reader  :EUCJP_KANA1_MASK
      
      const_set_lazy(:EUCJP_KANA2_MASK) { 0x10 }
      const_attr_reader  :EUCJP_KANA2_MASK
    }
    
    typesig { [] }
    def initialize
      super("x-JISAutoDetect", ExtendedCharsets.aliases_for("x-JISAutoDetect"))
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(SJIS)) || (cs.is_a?(EUC_JP)) || (cs.is_a?(ISO2022_JP)))
    end
    
    typesig { [] }
    def can_encode
      return false
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def historical_name
      return "JISAutoDetect"
    end
    
    typesig { [] }
    def new_encoder
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    # accessor methods used to share byte masking tables
    # with the sun.io JISAutoDetect implementation
    def get_byte_mask1
      return Decoder.attr_mask_table1
    end
    
    typesig { [] }
    def get_byte_mask2
      return Decoder.attr_mask_table2
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def can_be_sjis1b(mask)
        return !((mask & SJIS1B_MASK)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      def can_be_eucjp(mask)
        return !((mask & EUCJP_MASK)).equal?(0)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def can_be_euckana(mask1, mask2)
        return (!((mask1 & EUCJP_KANA1_MASK)).equal?(0)) && (!((mask2 & EUCJP_KANA2_MASK)).equal?(0))
      end
      
      typesig { [CharBuffer] }
      # A heuristic algorithm for guessing if EUC-decoded text really
      # might be Japanese text.  Better heuristics are possible...
      def looks_like_japanese(cb)
        hiragana = 0 # Fullwidth Hiragana
        katakana = 0 # Halfwidth Katakana
        while (cb.has_remaining)
          c = cb.get
          if (0x3040 <= c && c <= 0x309f && (hiragana += 1) > 1)
            return true
          end
          if (0xff65 <= c && c <= 0xff9f && (katakana += 1) > 1)
            return true
          end
        end
        return false
      end
      
      const_set_lazy(:Decoder) { Class.new(CharsetDecoder) do
        include_class_members JISAutoDetect
        
        class_module.module_eval {
          const_set_lazy(:SJISName) { get_sjisname }
          const_attr_reader  :SJISName
          
          const_set_lazy(:EUCJPName) { get_eucjpname }
          const_attr_reader  :EUCJPName
        }
        
        attr_accessor :detected_decoder
        alias_method :attr_detected_decoder, :detected_decoder
        undef_method :detected_decoder
        alias_method :attr_detected_decoder=, :detected_decoder=
        undef_method :detected_decoder=
        
        typesig { [Charset] }
        def initialize(cs)
          @detected_decoder = nil
          super(cs, 0.5, 1.0)
          @detected_decoder = nil
        end
        
        class_module.module_eval {
          typesig { [::Java::Byte] }
          def is_plain_ascii(b)
            return b >= 0 && !(b).equal?(0x1b)
          end
          
          typesig { [ByteBuffer, CharBuffer] }
          def copy_leading_ascii(src, dst)
            start = src.position
            limit = start + Math.min(src.remaining, dst.remaining)
            p = 0
            b = 0
            p = start
            while p < limit && is_plain_ascii(b = src.get(p))
              dst.put(RJava.cast_to_char((b & 0xff)))
              p += 1
            end
            src.position(p)
          end
        }
        
        typesig { [Charset, ByteBuffer, CharBuffer] }
        def decode_loop(cs, src, dst)
          @detected_decoder = cs.new_decoder
          return @detected_decoder.decode_loop(src, dst)
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_loop(src, dst)
          if ((@detected_decoder).nil?)
            copy_leading_ascii(src, dst)
            # All ASCII?
            if (!src.has_remaining)
              return CoderResult::UNDERFLOW
            end
            if (!dst.has_remaining)
              return CoderResult::OVERFLOW
            end
            # We need to perform double, not float, arithmetic; otherwise
            # we lose low order bits when src is larger than 2**24.
            cbufsiz = RJava.cast_to_int((src.limit * (max_chars_per_byte).to_f))
            sandbox = CharBuffer.allocate(cbufsiz)
            # First try ISO-2022-JP, since there is no ambiguity
            cs2022 = Charset.for_name("ISO-2022-JP")
            dd2022 = cs2022.new_decoder
            src2022 = src.as_read_only_buffer
            res2022 = dd2022.decode_loop(src2022, sandbox)
            if (!res2022.is_error)
              return decode_loop(cs2022, src, dst)
            end
            # We must choose between EUC and SJIS
            cs_eucj = Charset.for_name(self.class::EUCJPName)
            cs_sjis = Charset.for_name(self.class::SJISName)
            dd_eucj = cs_eucj.new_decoder
            src_eucj = src.as_read_only_buffer
            sandbox.clear
            res_eucj = dd_eucj.decode_loop(src_eucj, sandbox)
            # If EUC decoding fails, must be SJIS
            if (res_eucj.is_error)
              return decode_loop(cs_sjis, src, dst)
            end
            dd_sjis = cs_sjis.new_decoder
            src_sjis = src.as_read_only_buffer
            sandbox_sjis = CharBuffer.allocate(cbufsiz)
            res_sjis = dd_sjis.decode_loop(src_sjis, sandbox_sjis)
            # If SJIS decoding fails, must be EUC
            if (res_sjis.is_error)
              return decode_loop(cs_eucj, src, dst)
            end
            # From here on, we have some ambiguity, and must guess.
            # We prefer input that does not appear to end mid-character.
            if (src_eucj.position > src_sjis.position)
              return decode_loop(cs_eucj, src, dst)
            end
            if (src_eucj.position < src_sjis.position)
              return decode_loop(cs_sjis, src, dst)
            end
            # end-of-input is after the first byte of the first char?
            if ((src.position).equal?(src_eucj.position))
              return CoderResult::UNDERFLOW
            end
            # Use heuristic knowledge of typical Japanese text
            sandbox.flip
            guess = looks_like_japanese(sandbox) ? cs_eucj : cs_sjis
            return decode_loop(guess, src, dst)
          end
          return @detected_decoder.decode_loop(src, dst)
        end
        
        typesig { [] }
        def impl_reset
          @detected_decoder = nil
        end
        
        typesig { [CharBuffer] }
        def impl_flush(out)
          if (!(@detected_decoder).nil?)
            return @detected_decoder.impl_flush(out)
          else
            return super(out)
          end
        end
        
        typesig { [] }
        def is_auto_detecting
          return true
        end
        
        typesig { [] }
        def is_charset_detected
          return !(@detected_decoder).nil?
        end
        
        typesig { [] }
        def detected_charset
          if ((@detected_decoder).nil?)
            raise IllegalStateException.new("charset not yet detected")
          end
          return (@detected_decoder).charset
        end
        
        class_module.module_eval {
          typesig { [] }
          # Returned Shift_JIS Charset name is OS dependent
          def get_sjisname
            os_name = AccessController.do_privileged(GetPropertyAction.new("os.name"))
            if ((os_name == "Solaris") || (os_name == "SunOS"))
              return ("PCK")
            else
              if (os_name.starts_with("Windows"))
                return ("windows-31J")
              else
                return ("Shift_JIS")
              end
            end
          end
          
          typesig { [] }
          # Returned EUC-JP Charset name is OS dependent
          def get_eucjpname
            os_name = AccessController.do_privileged(GetPropertyAction.new("os.name"))
            if ((os_name == "Solaris") || (os_name == "SunOS"))
              return ("x-eucjp-open")
            else
              return ("EUC_JP")
            end
          end
          
          # Mask tables - each entry indicates possibility of first or
          # second byte being SJIS or EUC_JP
          # 0x00 - 0x03
          # 0x04 - 0x07
          # 0x08 - 0x0b
          # 0x0c - 0x0f
          # 0x10 - 0x13
          # 0x14 - 0x17
          # 0x18 - 0x1b
          # 0x1c - 0x1f
          # 0x20 - 0x23
          # 0x24 - 0x27
          # 0x28 - 0x2b
          # 0x2c - 0x2f
          # 0x30 - 0x33
          # 0x34 - 0x37
          # 0x38 - 0x3b
          # 0x3c - 0x3f
          # 0x40 - 0x43
          # 0x44 - 0x47
          # 0x48 - 0x4b
          # 0x4c - 0x4f
          # 0x50 - 0x53
          # 0x54 - 0x57
          # 0x58 - 0x5b
          # 0x5c - 0x5f
          # 0x60 - 0x63
          # 0x64 - 0x67
          # 0x68 - 0x6b
          # 0x6c - 0x6f
          # 0x70 - 0x73
          # 0x74 - 0x77
          # 0x78 - 0x7b
          # 0x7c - 0x7f
          # 0x80 - 0x83
          # 0x84 - 0x87
          # 0x88 - 0x8b
          # 0x8c - 0x8f
          # 0x90 - 0x93
          # 0x94 - 0x97
          # 0x98 - 0x9b
          # 0x9c - 0x9f
          # 0xa0 - 0xa3
          # 0xa4 - 0xa7
          # 0xa8 - 0xab
          # 0xac - 0xaf
          # 0xb0 - 0xb3
          # 0xb4 - 0xb7
          # 0xb8 - 0xbb
          # 0xbc - 0xbf
          # 0xc0 - 0xc3
          # 0xc4 - 0xc7
          # 0xc8 - 0xcb
          # 0xcc - 0xcf
          # 0xd0 - 0xd3
          # 0xd4 - 0xd7
          # 0xd8 - 0xdb
          # 0xdc - 0xdf
          # 0xe0 - 0xe3
          # 0xe4 - 0xe7
          # 0xe8 - 0xeb
          # 0xec - 0xef
          # 0xf0 - 0xf3
          # 0xf4 - 0xf7
          # 0xf8 - 0xfb
          # 0xfc - 0xff
          const_set_lazy(:MaskTable1) { Array.typed(::Java::Byte).new([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, 0, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK | EUCJP_KANA1_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS1B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, EUCJP_MASK, EUCJP_MASK, 0]) }
          const_attr_reader  :MaskTable1
          
          # 0x00 - 0x03
          # 0x04 - 0x07
          # 0x08 - 0x0b
          # 0x0c - 0x0f
          # 0x10 - 0x13
          # 0x14 - 0x17
          # 0x18 - 0x1b
          # 0x1c - 0x1f
          # 0x20 - 0x23
          # 0x24 - 0x27
          # 0x28 - 0x2b
          # 0x2c - 0x2f
          # 0x30 - 0x33
          # 0x34 - 0x37
          # 0x38 - 0x3b
          # 0x3c - 0x3f
          # 0x40 - 0x43
          # 0x44 - 0x47
          # 0x48 - 0x4b
          # 0x4c - 0x4f
          # 0x50 - 0x53
          # 0x54 - 0x57
          # 0x58 - 0x5b
          # 0x5c - 0x5f
          # 0x60 - 0x63
          # 0x64 - 0x67
          # 0x68 - 0x6b
          # 0x6c - 0x6f
          # 0x70 - 0x73
          # 0x74 - 0x77
          # 0x78 - 0x7b
          # 0x7c - 0x7f
          # 0x80 - 0x83
          # 0x84 - 0x87
          # 0x88 - 0x8b
          # 0x8c - 0x8f
          # 0x90 - 0x93
          # 0x94 - 0x97
          # 0x98 - 0x9b
          # 0x9c - 0x9f
          # 0xa0 - 0xa3
          # 0xa4 - 0xa7
          # 0xa8 - 0xab
          # 0xac - 0xaf
          # 0xb0 - 0xb3
          # 0xb4 - 0xb7
          # 0xb8 - 0xbb
          # 0xbc - 0xbf
          # 0xc0 - 0xc3
          # 0xc4 - 0xc7
          # 0xc8 - 0xcb
          # 0xcc - 0xcf
          # 0xd0 - 0xd3
          # 0xd4 - 0xd7
          # 0xd8 - 0xdb
          # 0xdc - 0xdf
          # 0xe0 - 0xe3
          # 0xe4 - 0xe7
          # 0xe8 - 0xeb
          # 0xec - 0xef
          # 0xf0 - 0xf3
          # 0xf4 - 0xf7
          # 0xf8 - 0xfb
          # 0xfc - 0xff
          const_set_lazy(:MaskTable2) { Array.typed(::Java::Byte).new([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, 0, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS2B_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS1B_MASK | SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK | EUCJP_KANA2_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, SJIS2B_MASK | EUCJP_MASK, EUCJP_MASK, EUCJP_MASK, 0]) }
          const_attr_reader  :MaskTable2
        }
        
        private
        alias_method :initialize__decoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__jisauto_detect, :initialize
  end
  
end
