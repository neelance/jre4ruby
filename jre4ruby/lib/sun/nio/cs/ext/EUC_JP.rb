require "rjava"

# Copyright 2002-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EUC_JPImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
      include_const ::Sun::Nio::Cs, :Surrogate
    }
  end
  
  class EUC_JP < EUC_JPImports.const_get :Charset
    include_class_members EUC_JPImports
    include HistoricallyNamedCharset
    
    typesig { [] }
    def initialize
      super("EUC-JP", ExtendedCharsets.aliases_for("EUC-JP"))
    end
    
    typesig { [] }
    def historical_name
      return "EUC_JP"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(JIS_X_0201)) || (cs.is_a?(JIS_X_0208)) || (cs.is_a?(JIS_X_0212)) || (cs.is_a?(EUC_JP)))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      # Need to force the replacement byte to 0x3f
      # because JIS_X_0208_Encoder defines its own
      # alternative 2 byte substitution to permit it
      # to exist as a self-standing Encoder
      replacement_bytes = Array.typed(::Java::Byte).new([0x3f])
      return Encoder.new(self).replace_with(replacement_bytes)
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(JIS_X_0208_Decoder) do
        include_class_members EUC_JP
        include DelegatableDecoder
        
        attr_accessor :decoder_j0201
        alias_method :attr_decoder_j0201, :decoder_j0201
        undef_method :decoder_j0201
        alias_method :attr_decoder_j0201=, :decoder_j0201=
        undef_method :decoder_j0201=
        
        attr_accessor :decoder_j0212
        alias_method :attr_decoder_j0212, :decoder_j0212
        undef_method :decoder_j0212
        alias_method :attr_decoder_j0212=, :decoder_j0212=
        undef_method :decoder_j0212=
        
        attr_accessor :j0208index1
        alias_method :attr_j0208index1, :j0208index1
        undef_method :j0208index1
        alias_method :attr_j0208index1=, :j0208index1=
        undef_method :j0208index1=
        
        attr_accessor :j0208index2
        alias_method :attr_j0208index2, :j0208index2
        undef_method :j0208index2
        alias_method :attr_j0208index2=, :j0208index2=
        undef_method :j0208index2=
        
        typesig { [Charset] }
        def initialize(cs)
          @decoder_j0201 = nil
          @decoder_j0212 = nil
          @j0208index1 = nil
          @j0208index2 = nil
          super(cs)
          @decoder_j0201 = JIS_X_0201::Decoder.new(cs)
          @decoder_j0212 = JIS_X_0212_Decoder.new(cs)
          self.attr_start = 0xa1
          self.attr_end = 0xfe
          @j0208index1 = JIS_X_0208_Decoder.instance_method(:get_index1).bind(self).call
          @j0208index2 = JIS_X_0208_Decoder.instance_method(:get_index2).bind(self).call
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode0212(byte1, byte2)
          return @decoder_j0212.decode_double(byte1, byte2)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode_double(byte1, byte2)
          if ((byte1).equal?(0x8e))
            return @decoder_j0201.decode(byte2 - 256)
          end
          # Fix for bug 4121358 - similar fix for bug 4117820 put
          # into ByteToCharDoubleByte.getUnicode()
          if (((byte1 < 0) || (byte1 > get_index1.attr_length)) || ((byte2 < self.attr_start) || (byte2 > self.attr_end)))
            return REPLACE_CHAR
          end
          n = (@j0208index1[byte1 - 0x80] & 0xf) * (self.attr_end - self.attr_start + 1) + (byte2 - self.attr_start)
          return @j0208index2[@j0208index1[byte1 - 0x80] >> 4].char_at(n)
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_array_loop(src, dst)
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
          b1 = 0
          b2 = 0
          input_size = 0
          output_char = REPLACE_CHAR # U+FFFD;
          begin
            while (sp < sl)
              b1 = sa[sp] & 0xff
              input_size = 1
              if (((b1 & 0x80)).equal?(0))
                output_char = RJava.cast_to_char(b1)
              else
                # Multibyte char
                if (((b1 & 0xff)).equal?(0x8f))
                  # JIS0212
                  if (sp + 3 > sl)
                    return CoderResult::UNDERFLOW
                  end
                  b1 = sa[sp + 1] & 0xff
                  b2 = sa[sp + 2] & 0xff
                  input_size += 2
                  output_char = decode0212(b1 - 0x80, b2 - 0x80)
                else
                  # JIS0208
                  if (sp + 2 > sl)
                    return CoderResult::UNDERFLOW
                  end
                  b2 = sa[sp + 1] & 0xff
                  input_size += 1
                  output_char = decode_double(b1, b2)
                end
              end
              if ((output_char).equal?(REPLACE_CHAR))
                # can't be decoded
                return CoderResult.unmappable_for_length(input_size)
              end
              if (dp + 1 > dl)
                return CoderResult::OVERFLOW
              end
              da[((dp += 1) - 1)] = output_char
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
          input_size = 0
          output_char = REPLACE_CHAR # U+FFFD;
          begin
            while (src.has_remaining)
              b1 = src.get & 0xff
              input_size = 1
              if (((b1 & 0x80)).equal?(0))
                output_char = RJava.cast_to_char(b1)
              else
                # Multibyte char
                if (((b1 & 0xff)).equal?(0x8f))
                  # JIS0212
                  if (src.remaining < 2)
                    return CoderResult::UNDERFLOW
                  end
                  b1 = src.get & 0xff
                  b2 = src.get & 0xff
                  input_size += 2
                  output_char = decode0212(b1 - 0x80, b2 - 0x80)
                else
                  # JIS0208
                  if (src.remaining < 1)
                    return CoderResult::UNDERFLOW
                  end
                  b2 = src.get & 0xff
                  input_size += 1
                  output_char = decode_double(b1, b2)
                end
              end
              if ((output_char).equal?(REPLACE_CHAR))
                return CoderResult.unmappable_for_length(input_size)
              end
              if (dst.remaining < 1)
                return CoderResult::OVERFLOW
              end
              dst.put(output_char)
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
        
        typesig { [] }
        def impl_reset
          super
        end
        
        typesig { [CharBuffer] }
        def impl_flush(out)
          return super(out)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(JIS_X_0208_Encoder) do
        include_class_members EUC_JP
        
        attr_accessor :encoder_j0201
        alias_method :attr_encoder_j0201, :encoder_j0201
        undef_method :encoder_j0201
        alias_method :attr_encoder_j0201=, :encoder_j0201=
        undef_method :encoder_j0201=
        
        attr_accessor :encoder_j0212
        alias_method :attr_encoder_j0212, :encoder_j0212
        undef_method :encoder_j0212
        alias_method :attr_encoder_j0212=, :encoder_j0212=
        undef_method :encoder_j0212=
        
        attr_accessor :j0208index1
        alias_method :attr_j0208index1, :j0208index1
        undef_method :j0208index1
        alias_method :attr_j0208index1=, :j0208index1=
        undef_method :j0208index1=
        
        attr_accessor :j0208index2
        alias_method :attr_j0208index2, :j0208index2
        undef_method :j0208index2
        alias_method :attr_j0208index2=, :j0208index2=
        undef_method :j0208index2=
        
        attr_accessor :sgp
        alias_method :attr_sgp, :sgp
        undef_method :sgp
        alias_method :attr_sgp=, :sgp=
        undef_method :sgp=
        
        typesig { [Charset] }
        def initialize(cs)
          @encoder_j0201 = nil
          @encoder_j0212 = nil
          @j0208index1 = nil
          @j0208index2 = nil
          @sgp = nil
          super(cs, 3.0, 3.0)
          @sgp = Surrogate::Parser.new
          @encoder_j0201 = JIS_X_0201::Encoder.new(cs)
          @encoder_j0212 = JIS_X_0212_Encoder.new(cs)
          @j0208index1 = JIS_X_0208_Encoder.instance_method(:get_index1).bind(self).call
          @j0208index2 = JIS_X_0208_Encoder.instance_method(:get_index2).bind(self).call
        end
        
        typesig { [::Java::Char] }
        def can_encode(c)
          encoded_bytes = Array.typed(::Java::Byte).new(3) { 0 }
          if ((encode_single(c, encoded_bytes)).equal?(0))
            # doublebyte
            if ((encode_double(c)).equal?(0))
              return false
            end
          end
          return true
        end
        
        typesig { [::Java::Char, Array.typed(::Java::Byte)] }
        def encode_single(input_char, output_byte)
          b = 0
          if ((input_char).equal?(0))
            output_byte[0] = 0
            return 1
          end
          if (((b = @encoder_j0201.encode(input_char))).equal?(0))
            return 0
          end
          if (b > 0 && b < 128)
            output_byte[0] = b
            return 1
          end
          output_byte[0] = 0x8e
          output_byte[1] = b
          return 2
        end
        
        typesig { [::Java::Char] }
        def encode_double(ch)
          offset = @j0208index1[((ch & 0xff00) >> 8)] << 8
          r = @j0208index2[offset >> 12].char_at((offset & 0xfff) + (ch & 0xff))
          if (!(r).equal?(0))
            return r + 0x8080
          end
          r = @encoder_j0212.encode_double(ch)
          if ((r).equal?(0))
            return r
          end
          return r + 0x8f8080
        end
        
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
          output_size = 0
          output_byte = nil
          input_size = 0 # Size of input
          tmp_buf = Array.typed(::Java::Byte).new(3) { 0 }
          begin
            while (sp < sl)
              output_byte = tmp_buf
              c = sa[sp]
              if (Surrogate.is(c))
                if (@sgp.parse(c, sa, sp, sl) < 0)
                  return @sgp.error
                end
                return @sgp.unmappable_result
              end
              output_size = encode_single(c, output_byte)
              if ((output_size).equal?(0))
                # DoubleByte
                ncode = encode_double(c)
                if (!(ncode).equal?(0))
                  if (((ncode & 0xff0000)).equal?(0))
                    output_byte[0] = ((ncode & 0xff00) >> 8)
                    output_byte[1] = (ncode & 0xff)
                    output_size = 2
                  else
                    output_byte[0] = 0x8f
                    output_byte[1] = ((ncode & 0xff00) >> 8)
                    output_byte[2] = (ncode & 0xff)
                    output_size = 3
                  end
                else
                  return CoderResult.unmappable_for_length(1)
                end
              end
              if (dl - dp < output_size)
                return CoderResult::OVERFLOW
              end
              # Put the byte in the output buffer
              i = 0
              while i < output_size
                da[((dp += 1) - 1)] = output_byte[i]
                i += 1
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
          output_size = 0
          output_byte = nil
          input_size = 0 # Size of input
          tmp_buf = Array.typed(::Java::Byte).new(3) { 0 }
          mark = src.position
          begin
            while (src.has_remaining)
              output_byte = tmp_buf
              c = src.get
              if (Surrogate.is(c))
                if (@sgp.parse(c, src) < 0)
                  return @sgp.error
                end
                return @sgp.unmappable_result
              end
              output_size = encode_single(c, output_byte)
              if ((output_size).equal?(0))
                # DoubleByte
                ncode = encode_double(c)
                if (!(ncode).equal?(0))
                  if (((ncode & 0xff0000)).equal?(0))
                    output_byte[0] = ((ncode & 0xff00) >> 8)
                    output_byte[1] = (ncode & 0xff)
                    output_size = 2
                  else
                    output_byte[0] = 0x8f
                    output_byte[1] = ((ncode & 0xff00) >> 8)
                    output_byte[2] = (ncode & 0xff)
                    output_size = 3
                  end
                else
                  return CoderResult.unmappable_for_length(1)
                end
              end
              if (dst.remaining < output_size)
                return CoderResult::OVERFLOW
              end
              # Put the byte in the output buffer
              i = 0
              while i < output_size
                dst.put(output_byte[i])
                i += 1
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
    alias_method :initialize__euc_jp, :initialize
  end
  
end
