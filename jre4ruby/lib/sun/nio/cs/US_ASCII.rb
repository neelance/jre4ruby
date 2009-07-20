require "rjava"

# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module US_ASCIIImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Java::Nio::Charset, :MalformedInputException
      include_const ::Java::Nio::Charset, :UnmappableCharacterException
    }
  end
  
  class US_ASCII < US_ASCIIImports.const_get :Charset
    include_class_members US_ASCIIImports
    include HistoricallyNamedCharset
    
    typesig { [] }
    def initialize
      super("US-ASCII", StandardCharsets.attr_aliases_us_ascii)
    end
    
    typesig { [] }
    def historical_name
      return "ASCII"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (cs.is_a?(US_ASCII))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      return Encoder.new(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(CharsetDecoder) do
        include_class_members US_ASCII
        
        typesig { [Charset] }
        def initialize(cs)
          super(cs, 1.0, 1.0)
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
          begin
            while (sp < sl)
              b = sa[sp]
              if (b >= 0)
                if (dp >= dl)
                  return CoderResult::OVERFLOW
                end
                da[((dp += 1) - 1)] = RJava.cast_to_char(b)
                sp += 1
                next
              end
              return CoderResult.malformed_for_length(1)
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
          begin
            while (src.has_remaining)
              b = src.get
              if (b >= 0)
                if (!dst.has_remaining)
                  return CoderResult::OVERFLOW
                end
                dst.put(RJava.cast_to_char(b))
                mark += 1
                next
              end
              return CoderResult.malformed_for_length(1)
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [ByteBuffer, CharBuffer] }
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
      
      const_set_lazy(:Encoder) { Class.new(CharsetEncoder) do
        include_class_members US_ASCII
        
        typesig { [Charset] }
        def initialize(cs)
          @sgp = nil
          super(cs, 1.0, 1.0)
          @sgp = Surrogate::Parser.new
        end
        
        typesig { [::Java::Char] }
        def can_encode(c)
          return c < 0x80
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
              if (c < 0x80)
                if (dp >= dl)
                  return CoderResult::OVERFLOW
                end
                da[dp] = c
                sp += 1
                dp += 1
                next
              end
              if (@sgp.parse(c, sa, sp, sl) < 0)
                return @sgp.error
              end
              return @sgp.unmappable_result
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
              if (c < 0x80)
                if (!dst.has_remaining)
                  return CoderResult::OVERFLOW
                end
                dst.put(c)
                mark += 1
                next
              end
              if (@sgp.parse(c, src) < 0)
                return @sgp.error
              end
              return @sgp.unmappable_result
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
    alias_method :initialize__us_ascii, :initialize
  end
  
end
