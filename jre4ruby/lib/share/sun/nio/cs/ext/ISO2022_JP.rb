require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ISO2022_JPImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CodingErrorAction
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
      include_const ::Sun::Nio::Cs, :Surrogate
      include_const ::Sun::Nio::Cs, :US_ASCII
    }
  end
  
  # Implementation notes:
  # 
  # (1)"Standard based" (ASCII, JIS_X_0201 and JIS_X_0208) ISO2022-JP charset
  # is provided by the base implementation of this class.
  # 
  # Three Microsoft ISO2022-JP variants, MS50220, MS50221 and MSISO2022JP
  # are provided via subclasses.
  # 
  # (2)MS50220 and MS50221 are assumed to work the same way as Microsoft
  # CP50220 and CP50221's 7-bit implementation works by using CP5022X
  # specific JIS0208 and JIS0212 mapping tables (generated via Microsoft's
  # MultiByteToWideChar/WideCharToMultiByte APIs). The only difference
  # between these 2 classes is that MS50220 does not support singlebyte
  # halfwidth kana (Uff61-Uff9f) shiftin mechanism when "encoding", instead
  # these halfwidth kana characters are converted to their fullwidth JIS0208
  # counterparts.
  # 
  # The difference between the standard JIS_X_0208 and JIS_X_0212 mappings
  # and the CP50220/50221 specific are
  # 
  # 0208 mapping:
  # 1)0x213d <-> U2015 (compared to U2014)
  # 2)One way mappings for 5 characters below
  # u2225 (ms) -> 0x2142 <-> u2016 (jis)
  # uff0d (ms) -> 0x215d <-> u2212 (jis)
  # uffe0 (ms) -> 0x2171 <-> u00a2 (jis)
  # uffe1 (ms) -> 0x2172 <-> u00a3 (jis)
  # uffe2 (ms) -> 0x224c <-> u00ac (jis)
  # //should consider 0xff5e -> 0x2141 <-> U301c?
  # 3)NEC Row13 0x2d21-0x2d79
  # 4)85-94 ku <-> UE000,UE3AB (includes NEC selected
  # IBM kanji in 89-92ku)
  # 5)UFF61-UFF9f -> Fullwidth 0208 KANA
  # 
  # 0212 mapping:
  # 1)0x2237 <-> UFF5E (Fullwidth Tilde)
  # 2)0x2271 <-> U2116 (Numero Sign)
  # 3)85-94 ku <-> UE3AC - UE757
  # 
  # (3)MSISO2022JP uses a JIS0208 mapping generated from MS932DB.b2c
  # and MS932DB.c2b by converting the SJIS codepoints back to their
  # JIS0208 counterparts. With the exception of
  # 
  # (a)Codepoints with a resulting JIS0208 codepoints beyond 0x7e00 are
  # dropped (this includs the IBM Extended Kanji/Non-kanji from 0x9321
  # to 0x972c)
  # (b)The Unicode codepoints that the IBM Extended Kanji/Non-kanji are
  # mapped to (in MS932) are mapped back to NEC selected IBM Kanji/
  # Non-kanji area at 0x7921-0x7c7e.
  # 
  # Compared to JIS_X_0208 mapping, this MS932 based mapping has
  # 
  # (a)different mappings for 7 JIS codepoints
  # 0x213d <-> U2015
  # 0x2141 <-> UFF5E
  # 0x2142 <-> U2225
  # 0x215d <-> Uff0d
  # 0x2171 <-> Uffe0
  # 0x2172 <-> Uffe1
  # 0x224c <-> Uffe2
  # (b)added one-way c2b mappings for
  # U00b8 -> 0x2124
  # U00b7 -> 0x2126
  # U00af -> 0x2131
  # U00ab -> 0x2263
  # U00bb -> 0x2264
  # U3094 -> 0x2574
  # U00b5 -> 0x264c
  # (c)NEC Row 13
  # (d)NEC selected IBM extended Kanji/Non-kanji
  # These codepoints are mapped to the same Unicode codepoints as
  # the MS932 does, while MS50220/50221 maps them to the Unicode
  # private area.
  # 
  # # There is also an interesting difference when compared to MS5022X
  # 0208 mapping for JIS codepoint "0x2D60", MS932 maps it to U301d
  # but MS5022X maps it to U301e, obvious MS5022X is wrong, but...
  class ISO2022_JP < ISO2022_JPImports.const_get :Charset
    include_class_members ISO2022_JPImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    class_module.module_eval {
      const_set_lazy(:ASCII) { 0 }
      const_attr_reader  :ASCII
      
      # ESC ( B
      const_set_lazy(:JISX0201_1976) { 1 }
      const_attr_reader  :JISX0201_1976
      
      # ESC ( J
      const_set_lazy(:JISX0208_1978) { 2 }
      const_attr_reader  :JISX0208_1978
      
      # ESC $ @
      const_set_lazy(:JISX0208_1983) { 3 }
      const_attr_reader  :JISX0208_1983
      
      # ESC $ B
      const_set_lazy(:JISX0212_1990) { 4 }
      const_attr_reader  :JISX0212_1990
      
      # ESC $ ( D
      const_set_lazy(:JISX0201_1976_KANA) { 5 }
      const_attr_reader  :JISX0201_1976_KANA
      
      # ESC ( I
      const_set_lazy(:SHIFTOUT) { 6 }
      const_attr_reader  :SHIFTOUT
      
      const_set_lazy(:ESC) { 0x1b }
      const_attr_reader  :ESC
      
      const_set_lazy(:SO) { 0xe }
      const_attr_reader  :SO
      
      const_set_lazy(:SI) { 0xf }
      const_attr_reader  :SI
    }
    
    typesig { [] }
    def initialize
      super("ISO-2022-JP", ExtendedCharsets.aliases_for("ISO-2022-JP"))
    end
    
    typesig { [String, Array.typed(String)] }
    def initialize(canonical_name, aliases)
      super(canonical_name, aliases)
    end
    
    typesig { [] }
    def historical_name
      return "ISO2022JP"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return ((cs.is_a?(JIS_X_0201)) || (cs.is_a?(US_ASCII)) || (cs.is_a?(JIS_X_0208)) || (cs.is_a?(ISO2022_JP)))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self, get_dec_index1, get_dec_index2, get0212_decoder)
    end
    
    typesig { [] }
    def new_encoder
      return Encoder.new(self, get_enc_index1, get_enc_index2, get0212_encoder, do_sbkana)
    end
    
    typesig { [] }
    def get_dec_index1
      return JIS_X_0208_Decoder.get_index1
    end
    
    typesig { [] }
    def get_dec_index2
      return JIS_X_0208_Decoder.get_index2
    end
    
    typesig { [] }
    def get0212_decoder
      return nil
    end
    
    typesig { [] }
    def get_enc_index1
      return JIS_X_0208_Encoder.get_index1
    end
    
    typesig { [] }
    def get_enc_index2
      return JIS_X_0208_Encoder.get_index2
    end
    
    typesig { [] }
    def get0212_encoder
      return nil
    end
    
    typesig { [] }
    def do_sbkana
      return true
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(DoubleByteDecoder) do
        include_class_members ISO2022_JP
        overload_protected {
          include DelegatableDecoder
        }
        
        attr_accessor :current_state
        alias_method :attr_current_state, :current_state
        undef_method :current_state
        alias_method :attr_current_state=, :current_state=
        undef_method :current_state=
        
        attr_accessor :previous_state
        alias_method :attr_previous_state, :previous_state
        undef_method :previous_state
        alias_method :attr_previous_state=, :previous_state=
        undef_method :previous_state=
        
        attr_accessor :decoder0212
        alias_method :attr_decoder0212, :decoder0212
        undef_method :decoder0212
        alias_method :attr_decoder0212=, :decoder0212=
        undef_method :decoder0212=
        
        typesig { [Charset, Array.typed(::Java::Short), Array.typed(String), DoubleByteDecoder] }
        def initialize(cs, index1, index2, decoder0212)
          @current_state = 0
          @previous_state = 0
          @decoder0212 = nil
          super(cs, index1, index2, 0x21, 0x7e)
          @decoder0212 = decoder0212
          @current_state = ASCII
          @previous_state = ASCII
        end
        
        typesig { [::Java::Int] }
        def conv_single_byte(b)
          return REPLACE_CHAR
        end
        
        typesig { [] }
        def impl_reset
          @current_state = ASCII
          @previous_state = ASCII
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_array_loop(src, dst)
          input_size = 0
          b1 = 0
          b2 = 0
          b3 = 0
          b4 = 0
          c = REPLACE_CHAR
          sa = src.array
          sp = src.array_offset + src.position
          sl = src.array_offset + src.limit
          raise AssertError if not ((sp <= sl))
          sp = (sp <= sl ? sp : sl)
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          raise AssertError if not ((dp <= dl))
          dp = (dp <= dl ? dp : dl)
          begin
            while (sp < sl)
              b1 = sa[sp] & 0xff
              input_size = 1
              if (!((b1 & 0x80)).equal?(0))
                return CoderResult.malformed_for_length(input_size)
              end
              if ((b1).equal?(ESC) || (b1).equal?(SO) || (b1).equal?(SI))
                if ((b1).equal?(ESC))
                  if (sp + input_size + 2 > sl)
                    return CoderResult::UNDERFLOW
                  end
                  b2 = sa[sp + ((input_size += 1) - 1)] & 0xff
                  if ((b2).equal?(Character.new(?(.ord)))
                    b3 = sa[sp + ((input_size += 1) - 1)] & 0xff
                    if ((b3).equal?(Character.new(?B.ord)))
                      @current_state = ASCII
                    else
                      if ((b3).equal?(Character.new(?J.ord)))
                        @current_state = JISX0201_1976
                      else
                        if ((b3).equal?(Character.new(?I.ord)))
                          @current_state = JISX0201_1976_KANA
                        else
                          return CoderResult.malformed_for_length(input_size)
                        end
                      end
                    end
                  else
                    if ((b2).equal?(Character.new(?$.ord)))
                      b3 = sa[sp + ((input_size += 1) - 1)] & 0xff
                      if ((b3).equal?(Character.new(?@.ord)))
                        @current_state = JISX0208_1978
                      else
                        if ((b3).equal?(Character.new(?B.ord)))
                          @current_state = JISX0208_1983
                        else
                          if ((b3).equal?(Character.new(?(.ord)) && !(@decoder0212).nil?)
                            if (sp + input_size + 1 > sl)
                              return CoderResult::UNDERFLOW
                            end
                            b4 = sa[sp + ((input_size += 1) - 1)] & 0xff
                            if ((b4).equal?(Character.new(?D.ord)))
                              @current_state = JISX0212_1990
                            else
                              return CoderResult.malformed_for_length(input_size)
                            end
                          else
                            return CoderResult.malformed_for_length(input_size)
                          end
                        end
                      end
                    else
                      return CoderResult.malformed_for_length(input_size)
                    end
                  end
                else
                  if ((b1).equal?(SO))
                    @previous_state = @current_state
                    @current_state = SHIFTOUT
                  else
                    if ((b1).equal?(SI))
                      @current_state = @previous_state
                    end
                  end
                end
                sp += input_size
                next
              end
              if (dp + 1 > dl)
                return CoderResult::OVERFLOW
              end
              case (@current_state)
              when ASCII
                da[((dp += 1) - 1)] = RJava.cast_to_char((b1 & 0xff))
              when JISX0201_1976
                case (b1)
                when 0x5c
                  # Yen/tilde substitution
                  da[((dp += 1) - 1)] = Character.new(0x00a5)
                when 0x7e
                  da[((dp += 1) - 1)] = Character.new(0x203e)
                else
                  da[((dp += 1) - 1)] = RJava.cast_to_char(b1)
                end
              when JISX0208_1978, JISX0208_1983
                if (sp + input_size + 1 > sl)
                  return CoderResult::UNDERFLOW
                end
                b2 = sa[sp + ((input_size += 1) - 1)] & 0xff
                c = decode_double(b1, b2)
                if ((c).equal?(REPLACE_CHAR))
                  return CoderResult.unmappable_for_length(input_size)
                end
                da[((dp += 1) - 1)] = c
              when JISX0212_1990
                if (sp + input_size + 1 > sl)
                  return CoderResult::UNDERFLOW
                end
                b2 = sa[sp + ((input_size += 1) - 1)] & 0xff
                c = @decoder0212.decode_double(b1, b2)
                if ((c).equal?(REPLACE_CHAR))
                  return CoderResult.unmappable_for_length(input_size)
                end
                da[((dp += 1) - 1)] = c
              when JISX0201_1976_KANA, SHIFTOUT
                if (b1 > 0x60)
                  return CoderResult.malformed_for_length(input_size)
                end
                da[((dp += 1) - 1)] = RJava.cast_to_char((b1 + 0xff40))
              end
              sp += input_size
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(sp - src.array_offset)
            dst.position(dp - dst.array_offset)
          end
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_buffer_loop(src, dst)
          mark = src.position
          b1 = 0
          b2 = 0
          b3 = 0
          b4 = 0
          c = REPLACE_CHAR
          input_size = 0
          begin
            while (src.has_remaining)
              b1 = src.get & 0xff
              input_size = 1
              if (!((b1 & 0x80)).equal?(0))
                return CoderResult.malformed_for_length(input_size)
              end
              if ((b1).equal?(ESC) || (b1).equal?(SO) || (b1).equal?(SI))
                if ((b1).equal?(ESC))
                  # ESC
                  if (src.remaining < 2)
                    return CoderResult::UNDERFLOW
                  end
                  b2 = src.get & 0xff
                  input_size += 1
                  if ((b2).equal?(Character.new(?(.ord)))
                    b3 = src.get & 0xff
                    input_size += 1
                    if ((b3).equal?(Character.new(?B.ord)))
                      @current_state = ASCII
                    else
                      if ((b3).equal?(Character.new(?J.ord)))
                        @current_state = JISX0201_1976
                      else
                        if ((b3).equal?(Character.new(?I.ord)))
                          @current_state = JISX0201_1976_KANA
                        else
                          return CoderResult.malformed_for_length(input_size)
                        end
                      end
                    end
                  else
                    if ((b2).equal?(Character.new(?$.ord)))
                      b3 = src.get & 0xff
                      input_size += 1
                      if ((b3).equal?(Character.new(?@.ord)))
                        @current_state = JISX0208_1978
                      else
                        if ((b3).equal?(Character.new(?B.ord)))
                          @current_state = JISX0208_1983
                        else
                          if ((b3).equal?(Character.new(?(.ord)) && !(@decoder0212).nil?)
                            if (!src.has_remaining)
                              return CoderResult::UNDERFLOW
                            end
                            b4 = src.get & 0xff
                            input_size += 1
                            if ((b4).equal?(Character.new(?D.ord)))
                              @current_state = JISX0212_1990
                            else
                              return CoderResult.malformed_for_length(input_size)
                            end
                          else
                            return CoderResult.malformed_for_length(input_size)
                          end
                        end
                      end
                    else
                      return CoderResult.malformed_for_length(input_size)
                    end
                  end
                else
                  if ((b1).equal?(SO))
                    @previous_state = @current_state
                    @current_state = SHIFTOUT
                  else
                    if ((b1).equal?(SI))
                      # shift back in
                      @current_state = @previous_state
                    end
                  end
                end
                mark += input_size
                next
              end
              if (!dst.has_remaining)
                return CoderResult::OVERFLOW
              end
              case (@current_state)
              when ASCII
                dst.put(RJava.cast_to_char((b1 & 0xff)))
              when JISX0201_1976
                case (b1)
                when 0x5c
                  # Yen/tilde substitution
                  dst.put(Character.new(0x00a5))
                when 0x7e
                  dst.put(Character.new(0x203e))
                else
                  dst.put(RJava.cast_to_char(b1))
                end
              when JISX0208_1978, JISX0208_1983
                if (!src.has_remaining)
                  return CoderResult::UNDERFLOW
                end
                b2 = src.get & 0xff
                input_size += 1
                c = decode_double(b1, b2)
                if ((c).equal?(REPLACE_CHAR))
                  return CoderResult.unmappable_for_length(input_size)
                end
                dst.put(c)
              when JISX0212_1990
                if (!src.has_remaining)
                  return CoderResult::UNDERFLOW
                end
                b2 = src.get & 0xff
                input_size += 1
                c = @decoder0212.decode_double(b1, b2)
                if ((c).equal?(REPLACE_CHAR))
                  return CoderResult.unmappable_for_length(input_size)
                end
                dst.put(c)
              when JISX0201_1976_KANA, SHIFTOUT
                if (b1 > 0x60)
                  return CoderResult.malformed_for_length(input_size)
                end
                dst.put(RJava.cast_to_char((b1 + 0xff40)))
              end
              mark += input_size
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        # Make some protected methods public for use by JISAutoDetect
        def decode_loop(src, dst)
          if (src.has_array && dst.has_array)
            return decode_array_loop(src, dst)
          else
            return decode_buffer_loop(src, dst)
          end
        end
        
        typesig { [CharBuffer] }
        def impl_flush(out)
          return super(out)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(DoubleByteEncoder) do
        include_class_members ISO2022_JP
        
        class_module.module_eval {
          
          def repl
            defined?(@@repl) ? @@repl : @@repl= Array.typed(::Java::Byte).new([0x21, 0x29])
          end
          alias_method :attr_repl, :repl
          
          def repl=(value)
            @@repl = value
          end
          alias_method :attr_repl=, :repl=
        }
        
        attr_accessor :current_mode
        alias_method :attr_current_mode, :current_mode
        undef_method :current_mode
        alias_method :attr_current_mode=, :current_mode=
        undef_method :current_mode=
        
        attr_accessor :replace_mode
        alias_method :attr_replace_mode, :replace_mode
        undef_method :replace_mode
        alias_method :attr_replace_mode=, :replace_mode=
        undef_method :replace_mode=
        
        attr_accessor :encoder0212
        alias_method :attr_encoder0212, :encoder0212
        undef_method :encoder0212
        alias_method :attr_encoder0212=, :encoder0212=
        undef_method :encoder0212=
        
        attr_accessor :do_sbkana
        alias_method :attr_do_sbkana, :do_sbkana
        undef_method :do_sbkana
        alias_method :attr_do_sbkana=, :do_sbkana=
        undef_method :do_sbkana=
        
        typesig { [Charset, Array.typed(::Java::Short), Array.typed(String), DoubleByteEncoder, ::Java::Boolean] }
        def initialize(cs, index1, index2, encoder0212, do_sbkana)
          @current_mode = 0
          @replace_mode = 0
          @encoder0212 = nil
          @do_sbkana = false
          @sgp = nil
          super(cs, index1, index2, self.attr_repl, 4.0, (!(encoder0212).nil?) ? 9.0 : 8.0)
          @current_mode = ASCII
          @replace_mode = JISX0208_1983
          @encoder0212 = nil
          @sgp = Surrogate::Parser.new
          @encoder0212 = encoder0212
          @do_sbkana = do_sbkana
        end
        
        typesig { [::Java::Char] }
        def encode_single(input_char)
          return -1
        end
        
        typesig { [] }
        def impl_reset
          @current_mode = ASCII
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def impl_replace_with(new_replacement)
          # It's almost impossible to decide which charset they belong
          # to. The best thing we can do here is to "guess" based on
          # the length of newReplacement.
          if ((new_replacement.attr_length).equal?(1))
            @replace_mode = ASCII
          else
            if ((new_replacement.attr_length).equal?(2))
              @replace_mode = JISX0208_1983
            end
          end
        end
        
        typesig { [ByteBuffer] }
        def impl_flush(out)
          if (!(@current_mode).equal?(ASCII))
            if (out.remaining < 3)
              return CoderResult::OVERFLOW
            end
            out.put(0x1b)
            out.put(0x28)
            out.put(0x42)
            @current_mode = ASCII
          end
          return CoderResult::UNDERFLOW
        end
        
        typesig { [::Java::Char] }
        def can_encode(c)
          return ((c <= Character.new(0x007F)) || (c >= 0xff61 && c <= 0xff9f) || ((c).equal?(Character.new(0x00A5))) || ((c).equal?(Character.new(0x203E))) || super(c) || (!(@encoder0212).nil? && @encoder0212.can_encode(c)))
        end
        
        attr_accessor :sgp
        alias_method :attr_sgp, :sgp
        undef_method :sgp
        alias_method :attr_sgp=, :sgp=
        undef_method :sgp=
        
        typesig { [CharBuffer, ByteBuffer] }
        def encode_array_loop(src, dst)
          sa = src.array
          sp = src.array_offset + src.position
          sl = src.array_offset + src.limit
          raise AssertError if not ((sp <= sl))
          sp = (sp <= sl ? sp : sl)
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          raise AssertError if not ((dp <= dl))
          dp = (dp <= dl ? dp : dl)
          begin
            while (sp < sl)
              c = sa[sp]
              if (c <= Character.new(0x007F))
                if (!(@current_mode).equal?(ASCII))
                  if (dl - dp < 3)
                    return CoderResult::OVERFLOW
                  end
                  da[((dp += 1) - 1)] = 0x1b
                  da[((dp += 1) - 1)] = 0x28
                  da[((dp += 1) - 1)] = 0x42
                  @current_mode = ASCII
                end
                if (dl - dp < 1)
                  return CoderResult::OVERFLOW
                end
                da[((dp += 1) - 1)] = c
              else
                if (c >= 0xff61 && c <= 0xff9f && @do_sbkana)
                  # a single byte kana
                  if (!(@current_mode).equal?(JISX0201_1976_KANA))
                    if (dl - dp < 3)
                      return CoderResult::OVERFLOW
                    end
                    da[((dp += 1) - 1)] = 0x1b
                    da[((dp += 1) - 1)] = 0x28
                    da[((dp += 1) - 1)] = 0x49
                    @current_mode = JISX0201_1976_KANA
                  end
                  if (dl - dp < 1)
                    return CoderResult::OVERFLOW
                  end
                  da[((dp += 1) - 1)] = (c - 0xff40)
                else
                  if ((c).equal?(Character.new(0x00A5)) || (c).equal?(Character.new(0x203E)))
                    # backslash or tilde
                    if (!(@current_mode).equal?(JISX0201_1976))
                      if (dl - dp < 3)
                        return CoderResult::OVERFLOW
                      end
                      da[((dp += 1) - 1)] = 0x1b
                      da[((dp += 1) - 1)] = 0x28
                      da[((dp += 1) - 1)] = 0x4a
                      @current_mode = JISX0201_1976
                    end
                    if (dl - dp < 1)
                      return CoderResult::OVERFLOW
                    end
                    da[((dp += 1) - 1)] = ((c).equal?(Character.new(0x00A5))) ? 0x5c : 0x7e
                  else
                    index = encode_double(c)
                    if (!(index).equal?(0))
                      if (!(@current_mode).equal?(JISX0208_1983))
                        if (dl - dp < 3)
                          return CoderResult::OVERFLOW
                        end
                        da[((dp += 1) - 1)] = 0x1b
                        da[((dp += 1) - 1)] = 0x24
                        da[((dp += 1) - 1)] = 0x42
                        @current_mode = JISX0208_1983
                      end
                      if (dl - dp < 2)
                        return CoderResult::OVERFLOW
                      end
                      da[((dp += 1) - 1)] = (index >> 8)
                      da[((dp += 1) - 1)] = (index & 0xff)
                    else
                      if (!(@encoder0212).nil? && !((index = @encoder0212.encode_double(c))).equal?(0))
                        if (!(@current_mode).equal?(JISX0212_1990))
                          if (dl - dp < 4)
                            return CoderResult::OVERFLOW
                          end
                          da[((dp += 1) - 1)] = 0x1b
                          da[((dp += 1) - 1)] = 0x24
                          da[((dp += 1) - 1)] = 0x28
                          da[((dp += 1) - 1)] = 0x44
                          @current_mode = JISX0212_1990
                        end
                        if (dl - dp < 2)
                          return CoderResult::OVERFLOW
                        end
                        da[((dp += 1) - 1)] = (index >> 8)
                        da[((dp += 1) - 1)] = (index & 0xff)
                      else
                        if (Surrogate.is(c) && @sgp.parse(c, sa, sp, sl) < 0)
                          return @sgp.error
                        end
                        if ((unmappable_character_action).equal?(CodingErrorAction::REPLACE) && !(@current_mode).equal?(@replace_mode))
                          if (dl - dp < 3)
                            return CoderResult::OVERFLOW
                          end
                          if ((@replace_mode).equal?(ASCII))
                            da[((dp += 1) - 1)] = 0x1b
                            da[((dp += 1) - 1)] = 0x28
                            da[((dp += 1) - 1)] = 0x42
                          else
                            da[((dp += 1) - 1)] = 0x1b
                            da[((dp += 1) - 1)] = 0x24
                            da[((dp += 1) - 1)] = 0x42
                          end
                          @current_mode = @replace_mode
                        end
                        if (Surrogate.is(c))
                          return @sgp.unmappable_result
                        end
                        return CoderResult.unmappable_for_length(1)
                      end
                    end
                  end
                end
              end
              sp += 1
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(sp - src.array_offset)
            dst.position(dp - dst.array_offset)
          end
        end
        
        typesig { [CharBuffer, ByteBuffer] }
        def encode_buffer_loop(src, dst)
          mark = src.position
          begin
            while (src.has_remaining)
              c = src.get
              if (c <= Character.new(0x007F))
                if (!(@current_mode).equal?(ASCII))
                  if (dst.remaining < 3)
                    return CoderResult::OVERFLOW
                  end
                  dst.put(0x1b)
                  dst.put(0x28)
                  dst.put(0x42)
                  @current_mode = ASCII
                end
                if (dst.remaining < 1)
                  return CoderResult::OVERFLOW
                end
                dst.put(c)
              else
                if (c >= 0xff61 && c <= 0xff9f && @do_sbkana)
                  # Is it a single byte kana?
                  if (!(@current_mode).equal?(JISX0201_1976_KANA))
                    if (dst.remaining < 3)
                      return CoderResult::OVERFLOW
                    end
                    dst.put(0x1b)
                    dst.put(0x28)
                    dst.put(0x49)
                    @current_mode = JISX0201_1976_KANA
                  end
                  if (dst.remaining < 1)
                    return CoderResult::OVERFLOW
                  end
                  dst.put((c - 0xff40))
                else
                  if ((c).equal?(Character.new(0x00a5)) || (c).equal?(Character.new(0x203E)))
                    if (!(@current_mode).equal?(JISX0201_1976))
                      if (dst.remaining < 3)
                        return CoderResult::OVERFLOW
                      end
                      dst.put(0x1b)
                      dst.put(0x28)
                      dst.put(0x4a)
                      @current_mode = JISX0201_1976
                    end
                    if (dst.remaining < 1)
                      return CoderResult::OVERFLOW
                    end
                    dst.put(((c).equal?(Character.new(0x00A5))) ? 0x5c : 0x7e)
                  else
                    index = encode_double(c)
                    if (!(index).equal?(0))
                      if (!(@current_mode).equal?(JISX0208_1983))
                        if (dst.remaining < 3)
                          return CoderResult::OVERFLOW
                        end
                        dst.put(0x1b)
                        dst.put(0x24)
                        dst.put(0x42)
                        @current_mode = JISX0208_1983
                      end
                      if (dst.remaining < 2)
                        return CoderResult::OVERFLOW
                      end
                      dst.put((index >> 8))
                      dst.put((index & 0xff))
                    else
                      if (!(@encoder0212).nil? && !((index = @encoder0212.encode_double(c))).equal?(0))
                        if (!(@current_mode).equal?(JISX0212_1990))
                          if (dst.remaining < 4)
                            return CoderResult::OVERFLOW
                          end
                          dst.put(0x1b)
                          dst.put(0x24)
                          dst.put(0x28)
                          dst.put(0x44)
                          @current_mode = JISX0212_1990
                        end
                        if (dst.remaining < 2)
                          return CoderResult::OVERFLOW
                        end
                        dst.put((index >> 8))
                        dst.put((index & 0xff))
                      else
                        if (Surrogate.is(c) && @sgp.parse(c, src) < 0)
                          return @sgp.error
                        end
                        if ((unmappable_character_action).equal?(CodingErrorAction::REPLACE) && !(@current_mode).equal?(@replace_mode))
                          if (dst.remaining < 3)
                            return CoderResult::OVERFLOW
                          end
                          if ((@replace_mode).equal?(ASCII))
                            dst.put(0x1b)
                            dst.put(0x28)
                            dst.put(0x42)
                          else
                            dst.put(0x1b)
                            dst.put(0x24)
                            dst.put(0x42)
                          end
                          @current_mode = @replace_mode
                        end
                        if (Surrogate.is(c))
                          return @sgp.unmappable_result
                        end
                        return CoderResult.unmappable_for_length(1)
                      end
                    end
                  end
                end
              end
              mark += 1
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [CharBuffer, ByteBuffer] }
        def encode_loop(src, dst)
          if (src.has_array && dst.has_array)
            return encode_array_loop(src, dst)
          else
            return encode_buffer_loop(src, dst)
          end
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__iso2022_jp, :initialize
  end
  
end
