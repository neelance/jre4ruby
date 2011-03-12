require "rjava"

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
module Sun::Nio::Cs::Ext
  module ISO2022_CNImports #:nodoc:
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
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
      include_const ::Sun::Nio::Cs, :US_ASCII
    }
  end
  
  class ISO2022_CN < ISO2022_CNImports.const_get :Charset
    include_class_members ISO2022_CNImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    class_module.module_eval {
      const_set_lazy(:ISO_ESC) { 0x1b }
      const_attr_reader  :ISO_ESC
      
      const_set_lazy(:ISO_SI) { 0xf }
      const_attr_reader  :ISO_SI
      
      const_set_lazy(:ISO_SO) { 0xe }
      const_attr_reader  :ISO_SO
      
      const_set_lazy(:ISO_SS2_7) { 0x4e }
      const_attr_reader  :ISO_SS2_7
      
      const_set_lazy(:ISO_SS3_7) { 0x4f }
      const_attr_reader  :ISO_SS3_7
      
      const_set_lazy(:MSB) { 0x80 }
      const_attr_reader  :MSB
      
      const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
      const_attr_reader  :REPLACE_CHAR
      
      const_set_lazy(:SODesigGB) { 0 }
      const_attr_reader  :SODesigGB
      
      const_set_lazy(:SODesigCNS) { 1 }
      const_attr_reader  :SODesigCNS
    }
    
    typesig { [] }
    def initialize
      super("ISO-2022-CN", ExtendedCharsets.aliases_for("ISO-2022-CN"))
    end
    
    typesig { [] }
    def historical_name
      return "ISO2022CN"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return ((cs.is_a?(EUC_CN)) || (cs.is_a?(US_ASCII)) || (cs.is_a?(EUC_TW)) || (cs.is_a?(ISO2022_CN)))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def can_encode
      return false
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(CharsetDecoder) do
        include_class_members ISO2022_CN
        
        attr_accessor :shift_out
        alias_method :attr_shift_out, :shift_out
        undef_method :shift_out
        alias_method :attr_shift_out=, :shift_out=
        undef_method :shift_out=
        
        attr_accessor :current_sodesig
        alias_method :attr_current_sodesig, :current_sodesig
        undef_method :current_sodesig
        alias_method :attr_current_sodesig=, :current_sodesig=
        undef_method :current_sodesig=
        
        class_module.module_eval {
          const_set_lazy(:Gb2312) { class_self::EUC_CN.new }
          const_attr_reader  :Gb2312
          
          const_set_lazy(:Cns) { class_self::EUC_TW.new }
          const_attr_reader  :Cns
        }
        
        attr_accessor :gb2312decoder
        alias_method :attr_gb2312decoder, :gb2312decoder
        undef_method :gb2312decoder
        alias_method :attr_gb2312decoder=, :gb2312decoder=
        undef_method :gb2312decoder=
        
        attr_accessor :cns_decoder
        alias_method :attr_cns_decoder, :cns_decoder
        undef_method :cns_decoder
        alias_method :attr_cns_decoder=, :cns_decoder=
        undef_method :cns_decoder=
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          @shift_out = false
          @current_sodesig = 0
          @gb2312decoder = nil
          @cns_decoder = nil
          super(cs, 1.0, 1.0)
          @shift_out = false
          @current_sodesig = SODesigGB
          @gb2312decoder = self.class::Gb2312.new_decoder
          @cns_decoder = self.class::Cns.new_decoder
        end
        
        typesig { [] }
        def impl_reset
          @shift_out = false
          @current_sodesig = SODesigGB
        end
        
        typesig { [::Java::Byte, ::Java::Byte, ::Java::Byte] }
        def cns_decode(byte1, byte2, ss)
          byte1 |= MSB
          byte2 |= MSB
          if ((ss).equal?(ISO_SS2_7))
            return @cns_decoder.conv_to_unicode(byte1, byte2, @cns_decoder.attr_unicode_cns2)
          else
            # SS == ISO_SS3_7
            out_surr = @cns_decoder.conv_to_surrogate(byte1, byte2, @cns_decoder.attr_unicode_cns3)
            if ((out_surr).nil? || !(out_surr[0]).equal?(Character.new(0x0000)))
              return REPLACE_CHAR
            end
            return out_surr[1]
          end
        end
        
        typesig { [::Java::Byte, ::Java::Byte, ::Java::Byte] }
        def _sodecode(byte1, byte2, sod)
          byte1 |= MSB
          byte2 |= MSB
          if ((sod).equal?(SODesigGB))
            return @gb2312decoder.decode_double(byte1 & 0xff, byte2 & 0xff)
          else
            # SOD == SODesigCNS
            return @cns_decoder.conv_to_unicode(byte1, byte2, @cns_decoder.attr_unicode_cns1)
          end
        end
        
        typesig { [class_self::ByteBuffer, class_self::CharBuffer] }
        def decode_buffer_loop(src, dst)
          mark = src.position
          b1 = 0
          b2 = 0
          b3 = 0
          b4 = 0
          input_size = 0
          c = REPLACE_CHAR
          begin
            while (src.has_remaining)
              b1 = src.get
              input_size = 1
              while ((b1).equal?(ISO_ESC) || (b1).equal?(ISO_SO) || (b1).equal?(ISO_SI))
                if ((b1).equal?(ISO_ESC))
                  # ESC
                  @current_sodesig = SODesigGB
                  if (src.remaining < 1)
                    return CoderResult::UNDERFLOW
                  end
                  b2 = src.get
                  input_size += 1
                  if (!((b2 & 0x80)).equal?(0))
                    return CoderResult.malformed_for_length(input_size)
                  end
                  if ((b2).equal?(0x24))
                    if (src.remaining < 1)
                      return CoderResult::UNDERFLOW
                    end
                    b3 = src.get
                    input_size += 1
                    if (!((b3 & 0x80)).equal?(0))
                      return CoderResult.malformed_for_length(input_size)
                    end
                    if ((b3).equal?(Character.new(?A.ord)))
                      # "$A"
                      @current_sodesig = SODesigGB
                    else
                      if ((b3).equal?(Character.new(?).ord)))
                        if (src.remaining < 1)
                          return CoderResult::UNDERFLOW
                        end
                        b4 = src.get
                        input_size += 1
                        if ((b4).equal?(Character.new(?A.ord)))
                          # "$)A"
                          @current_sodesig = SODesigGB
                        else
                          if ((b4).equal?(Character.new(?G.ord)))
                            # "$)G"
                            @current_sodesig = SODesigCNS
                          else
                            return CoderResult.malformed_for_length(input_size)
                          end
                        end
                      else
                        if ((b3).equal?(Character.new(?*.ord)))
                          if (src.remaining < 1)
                            return CoderResult::UNDERFLOW
                          end
                          b4 = src.get
                          input_size += 1
                          if (!(b4).equal?(Character.new(?H.ord)))
                            # "$*H"
                            # SS2Desig -> CNS-P1
                            return CoderResult.malformed_for_length(input_size)
                          end
                        else
                          if ((b3).equal?(Character.new(?+.ord)))
                            if (src.remaining < 1)
                              return CoderResult::UNDERFLOW
                            end
                            b4 = src.get
                            input_size += 1
                            if (!(b4).equal?(Character.new(?I.ord)))
                              # "$+I"
                              # SS3Desig -> CNS-P2.
                              return CoderResult.malformed_for_length(input_size)
                            end
                          else
                            return CoderResult.malformed_for_length(input_size)
                          end
                        end
                      end
                    end
                  else
                    if ((b2).equal?(ISO_SS2_7) || (b2).equal?(ISO_SS3_7))
                      if (src.remaining < 2)
                        return CoderResult::UNDERFLOW
                      end
                      b3 = src.get
                      b4 = src.get
                      input_size += 2
                      if (dst.remaining < 1)
                        return CoderResult::OVERFLOW
                      end
                      # SS2->CNS-P2, SS3->CNS-P3
                      c = cns_decode(b3, b4, b2)
                      if ((c).equal?(REPLACE_CHAR))
                        return CoderResult.unmappable_for_length(input_size)
                      end
                      dst.put(c)
                    else
                      return CoderResult.malformed_for_length(input_size)
                    end
                  end
                else
                  if ((b1).equal?(ISO_SO))
                    @shift_out = true
                  else
                    if ((b1).equal?(ISO_SI))
                      # shift back in
                      @shift_out = false
                    end
                  end
                end
                mark += input_size
                if (src.remaining < 1)
                  return CoderResult::UNDERFLOW
                end
                b1 = src.get
                input_size = 1
              end
              if (dst.remaining < 1)
                return CoderResult::OVERFLOW
              end
              if (!@shift_out)
                dst.put(RJava.cast_to_char((b1 & 0xff))) # clear the upper byte
                mark += input_size
              else
                if (src.remaining < 1)
                  return CoderResult::UNDERFLOW
                end
                b2 = src.get
                input_size += 1
                c = _sodecode(b1, b2, @current_sodesig)
                if ((c).equal?(REPLACE_CHAR))
                  return CoderResult.unmappable_for_length(input_size)
                end
                dst.put(c)
                mark += input_size
              end
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [class_self::ByteBuffer, class_self::CharBuffer] }
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
              b1 = sa[sp]
              input_size = 1
              while ((b1).equal?(ISO_ESC) || (b1).equal?(ISO_SO) || (b1).equal?(ISO_SI))
                if ((b1).equal?(ISO_ESC))
                  # ESC
                  @current_sodesig = SODesigGB
                  if (sp + 2 > sl)
                    return CoderResult::UNDERFLOW
                  end
                  b2 = sa[sp + 1]
                  input_size += 1
                  if (!((b2 & 0x80)).equal?(0))
                    return CoderResult.malformed_for_length(input_size)
                  end
                  if ((b2).equal?(0x24))
                    if (sp + 3 > sl)
                      return CoderResult::UNDERFLOW
                    end
                    b3 = sa[sp + 2]
                    input_size += 1
                    if (!((b3 & 0x80)).equal?(0))
                      return CoderResult.malformed_for_length(input_size)
                    end
                    if ((b3).equal?(Character.new(?A.ord)))
                      # "$A"
                      # <ESC>$A is not a legal designator sequence for
                      # ISO2022_CN, it is listed as an escape sequence
                      # for GB2312 in ISO2022-JP-2. Keep it here just for
                      # the sake of "compatibility".
                      @current_sodesig = SODesigGB
                    else
                      if ((b3).equal?(Character.new(?).ord)))
                        if (sp + 4 > sl)
                          return CoderResult::UNDERFLOW
                        end
                        b4 = sa[sp + 3]
                        input_size += 1
                        if ((b4).equal?(Character.new(?A.ord)))
                          # "$)A"
                          @current_sodesig = SODesigGB
                        else
                          if ((b4).equal?(Character.new(?G.ord)))
                            # "$)G"
                            @current_sodesig = SODesigCNS
                          else
                            return CoderResult.malformed_for_length(input_size)
                          end
                        end
                      else
                        if ((b3).equal?(Character.new(?*.ord)))
                          if (sp + 4 > sl)
                            return CoderResult::UNDERFLOW
                          end
                          b4 = sa[sp + 3]
                          input_size += 1
                          if (!(b4).equal?(Character.new(?H.ord)))
                            # "$*H"
                            return CoderResult.malformed_for_length(input_size)
                          end
                        else
                          if ((b3).equal?(Character.new(?+.ord)))
                            if (sp + 4 > sl)
                              return CoderResult::UNDERFLOW
                            end
                            b4 = sa[sp + 3]
                            input_size += 1
                            if (!(b4).equal?(Character.new(?I.ord)))
                              # "$+I"
                              return CoderResult.malformed_for_length(input_size)
                            end
                          else
                            return CoderResult.malformed_for_length(input_size)
                          end
                        end
                      end
                    end
                  else
                    if ((b2).equal?(ISO_SS2_7) || (b2).equal?(ISO_SS3_7))
                      if (sp + 4 > sl)
                        return CoderResult::UNDERFLOW
                      end
                      b3 = sa[sp + 2]
                      b4 = sa[sp + 3]
                      if (dl - dp < 1)
                        return CoderResult::OVERFLOW
                      end
                      input_size += 2
                      c = cns_decode(b3, b4, b2)
                      if ((c).equal?(REPLACE_CHAR))
                        return CoderResult.unmappable_for_length(input_size)
                      end
                      da[((dp += 1) - 1)] = c
                    else
                      return CoderResult.malformed_for_length(input_size)
                    end
                  end
                else
                  if ((b1).equal?(ISO_SO))
                    @shift_out = true
                  else
                    if ((b1).equal?(ISO_SI))
                      # shift back in
                      @shift_out = false
                    end
                  end
                end
                sp += input_size
                if (sp + 1 > sl)
                  return CoderResult::UNDERFLOW
                end
                b1 = sa[sp]
                input_size = 1
              end
              if (dl - dp < 1)
                return CoderResult::OVERFLOW
              end
              if (!@shift_out)
                da[((dp += 1) - 1)] = RJava.cast_to_char((b1 & 0xff)) # clear the upper byte
              else
                if (sp + 2 > sl)
                  return CoderResult::UNDERFLOW
                end
                b2 = sa[sp + 1]
                input_size += 1
                c = _sodecode(b1, b2, @current_sodesig)
                if ((c).equal?(REPLACE_CHAR))
                  return CoderResult.unmappable_for_length(input_size)
                end
                da[((dp += 1) - 1)] = c
              end
              sp += input_size
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(sp - src.array_offset)
            dst.position(dp - dst.array_offset)
          end
        end
        
        typesig { [class_self::ByteBuffer, class_self::CharBuffer] }
        def decode_loop(src, dst)
          if (src.has_array && dst.has_array)
            return decode_array_loop(src, dst)
          else
            return decode_buffer_loop(src, dst)
          end
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__iso2022_cn, :initialize
  end
  
end
