require "rjava"

# Copyright 2000-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UTF_8Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio, :Buffer
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
    }
  end
  
  # Legal UTF-8 Byte Sequences
  # 
  # #    Code Points      Bits   Bit/Byte pattern
  # 1                     7      0xxxxxxx
  # U+0000..U+007F          00..7F
  # 
  # 2                     11     110xxxxx    10xxxxxx
  # U+0080..U+07FF          C2..DF      80..BF
  # 
  # 3                     16     1110xxxx    10xxxxxx    10xxxxxx
  # U+0800..U+0FFF          E0          A0..BF      80..BF
  # U+1000..U+FFFF          E1..EF      80..BF      80..BF
  # 
  # 4                     21     11110xxx    10xxxxxx    10xxxxxx    10xxxxxx
  # U+10000..U+3FFFF         F0          90..BF      80..BF      80..BF
  # U+40000..U+FFFFF         F1..F3      80..BF      80..BF      80..BF
  # U+100000..U10FFFF         F4          80..8F      80..BF      80..BF
  class UTF_8 < UTF_8Imports.const_get :Unicode
    include_class_members UTF_8Imports
    
    typesig { [] }
    def initialize
      super("UTF-8", StandardCharsets.attr_aliases_utf_8)
    end
    
    typesig { [] }
    def historical_name
      return "UTF8"
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
      typesig { [Buffer, ::Java::Int, Buffer, ::Java::Int] }
      def update_positions(src, sp, dst, dp)
        src.position(sp - src.array_offset)
        dst.position(dp - dst.array_offset)
      end
      
      const_set_lazy(:Decoder) { Class.new(CharsetDecoder) do
        include_class_members UTF_8
        
        typesig { [Charset] }
        def initialize(cs)
          super(cs, 1.0, 1.0)
        end
        
        class_module.module_eval {
          typesig { [::Java::Int] }
          def is_not_continuation(b)
            return !((b & 0xc0)).equal?(0x80)
          end
          
          typesig { [::Java::Int, ::Java::Int] }
          # [C2..DF] [80..BF]
          def is_malformed2(b1, b2)
            return ((b1 & 0x1e)).equal?(0x0) || !((b2 & 0xc0)).equal?(0x80)
          end
          
          typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
          # [E0]     [A0..BF] [80..BF]
          # [E1..EF] [80..BF] [80..BF]
          def is_malformed3(b1, b2, b3)
            return ((b1).equal?(0xe0) && ((b2 & 0xe0)).equal?(0x80)) || !((b2 & 0xc0)).equal?(0x80) || !((b3 & 0xc0)).equal?(0x80)
          end
          
          typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
          # [F0]     [90..BF] [80..BF] [80..BF]
          # [F1..F3] [80..BF] [80..BF] [80..BF]
          # [F4]     [80..8F] [80..BF] [80..BF]
          # only check 80-be range here, the [0xf0,0x80...] and [0xf4,0x90-...]
          # will be checked by Surrogate.neededFor(uc)
          def is_malformed4(b2, b3, b4)
            return !((b2 & 0xc0)).equal?(0x80) || !((b3 & 0xc0)).equal?(0x80) || !((b4 & 0xc0)).equal?(0x80)
          end
          
          typesig { [ByteBuffer, ::Java::Int] }
          def lookup_n(src, n)
            i = 1
            while i < n
              if (is_not_continuation(src.get))
                return CoderResult.malformed_for_length(i)
              end
              ((i += 1) - 1)
            end
            return CoderResult.malformed_for_length(n)
          end
          
          typesig { [ByteBuffer, ::Java::Int] }
          def malformed_n(src, nb)
            case (nb)
            when 1
              b1 = src.get
              if (((b1 >> 2)).equal?(-2))
                # 5 bytes 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
                if (src.remaining < 4)
                  return CoderResult::UNDERFLOW
                end
                return lookup_n(src, 5)
              end
              if (((b1 >> 1)).equal?(-2))
                # 6 bytes 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
                if (src.remaining < 5)
                  return CoderResult::UNDERFLOW
                end
                return lookup_n(src, 6)
              end
              return CoderResult.malformed_for_length(1)
            when 2
              # always 1
              return CoderResult.malformed_for_length(1)
            when 3
              self.attr_b1 = src.get
              b2 = src.get # no need to lookup b3
              return CoderResult.malformed_for_length((((self.attr_b1).equal?(0xe0) && ((b2 & 0xe0)).equal?(0x80)) || is_not_continuation(b2)) ? 1 : 2)
            when 4
              # we don't care the speed here
              self.attr_b1 = src.get & 0xff
              self.attr_b2 = src.get & 0xff
              if (self.attr_b1 > 0xf4 || ((self.attr_b1).equal?(0xf0) && (self.attr_b2 < 0x90 || self.attr_b2 > 0xbf)) || ((self.attr_b1).equal?(0xf4) && !((self.attr_b2 & 0xf0)).equal?(0x80)) || is_not_continuation(self.attr_b2))
                return CoderResult.malformed_for_length(1)
              end
              if (is_not_continuation(src.get))
                return CoderResult.malformed_for_length(2)
              end
              return CoderResult.malformed_for_length(3)
            else
              raise AssertError if not (false)
              return nil
            end
          end
          
          typesig { [ByteBuffer, ::Java::Int, CharBuffer, ::Java::Int, ::Java::Int] }
          def malformed(src, sp, dst, dp, nb)
            src.position(sp - src.array_offset)
            cr = malformed_n(src, nb)
            update_positions(src, sp, dst, dp)
            return cr
          end
          
          typesig { [ByteBuffer, ::Java::Int, ::Java::Int] }
          def malformed(src, mark, nb)
            src.position(mark)
            cr = malformed_n(src, nb)
            src.position(mark)
            return cr
          end
          
          typesig { [Buffer, ::Java::Int, ::Java::Int, Buffer, ::Java::Int, ::Java::Int] }
          def xflow(src, sp, sl, dst, dp, nb)
            update_positions(src, sp, dst, dp)
            return ((nb).equal?(0) || sl - sp < nb) ? CoderResult::UNDERFLOW : CoderResult::OVERFLOW
          end
          
          typesig { [Buffer, ::Java::Int, ::Java::Int] }
          def xflow(src, mark, nb)
            cr = ((nb).equal?(0) || src.remaining < (nb - 1)) ? CoderResult::UNDERFLOW : CoderResult::OVERFLOW
            src.position(mark)
            return cr
          end
        }
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_array_loop(src, dst)
          # This method is optimized for ASCII input.
          sa = src.array
          sp = src.array_offset + src.position
          sl = src.array_offset + src.limit
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          dl_ascii = dp + Math.min(sl - sp, dl - dp)
          # ASCII only loop
          while (dp < dl_ascii && sa[sp] >= 0)
            da[((dp += 1) - 1)] = RJava.cast_to_char(sa[((sp += 1) - 1)])
          end
          while (sp < sl)
            b1 = sa[sp]
            if (b1 >= 0)
              # 1 byte, 7 bits: 0xxxxxxx
              if (dp >= dl)
                return xflow(src, sp, sl, dst, dp, 1)
              end
              da[((dp += 1) - 1)] = RJava.cast_to_char(b1)
              ((sp += 1) - 1)
            else
              if (((b1 >> 5)).equal?(-2))
                # 2 bytes, 11 bits: 110xxxxx 10xxxxxx
                if (sl - sp < 2 || dp >= dl)
                  return xflow(src, sp, sl, dst, dp, 2)
                end
                b2 = sa[sp + 1]
                if (is_malformed2(b1, b2))
                  return malformed(src, sp, dst, dp, 2)
                end
                da[((dp += 1) - 1)] = RJava.cast_to_char((((b1 << 6) ^ b2) ^ 0xf80))
                sp += 2
              else
                if (((b1 >> 4)).equal?(-2))
                  # 3 bytes, 16 bits: 1110xxxx 10xxxxxx 10xxxxxx
                  if (sl - sp < 3 || dp >= dl)
                    return xflow(src, sp, sl, dst, dp, 3)
                  end
                  b2 = sa[sp + 1]
                  b3 = sa[sp + 2]
                  if (is_malformed3(b1, b2, b3))
                    return malformed(src, sp, dst, dp, 3)
                  end
                  da[((dp += 1) - 1)] = RJava.cast_to_char((((b1 << 12) ^ (b2 << 6) ^ b3) ^ 0x1f80))
                  sp += 3
                else
                  if (((b1 >> 3)).equal?(-2))
                    # 4 bytes, 21 bits: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
                    if (sl - sp < 4 || dl - dp < 2)
                      return xflow(src, sp, sl, dst, dp, 4)
                    end
                    b2 = sa[sp + 1]
                    b3 = sa[sp + 2]
                    b4 = sa[sp + 3]
                    uc = ((b1 & 0x7) << 18) | ((b2 & 0x3f) << 12) | ((b3 & 0x3f) << 6) | (b4 & 0x3f)
                    if (is_malformed4(b2, b3, b4) || !Surrogate.needed_for(uc))
                      return malformed(src, sp, dst, dp, 4)
                    end
                    da[((dp += 1) - 1)] = Surrogate.high(uc)
                    da[((dp += 1) - 1)] = Surrogate.low(uc)
                    sp += 4
                  else
                    return malformed(src, sp, dst, dp, 1)
                  end
                end
              end
            end
          end
          return xflow(src, sp, sl, dst, dp, 0)
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_buffer_loop(src, dst)
          mark = src.position
          limit_ = src.limit
          while (mark < limit_)
            b1 = src.get
            if (b1 >= 0)
              # 1 byte, 7 bits: 0xxxxxxx
              if (dst.remaining < 1)
                return xflow(src, mark, 1)
              end # overflow
              dst.put(RJava.cast_to_char(b1))
              ((mark += 1) - 1)
            else
              if (((b1 >> 5)).equal?(-2))
                # 2 bytes, 11 bits: 110xxxxx 10xxxxxx
                if (limit_ - mark < 2 || dst.remaining < 1)
                  return xflow(src, mark, 2)
                end
                b2 = src.get
                if (is_malformed2(b1, b2))
                  return malformed(src, mark, 2)
                end
                dst.put(RJava.cast_to_char((((b1 << 6) ^ b2) ^ 0xf80)))
                mark += 2
              else
                if (((b1 >> 4)).equal?(-2))
                  # 3 bytes, 16 bits: 1110xxxx 10xxxxxx 10xxxxxx
                  if (limit_ - mark < 3 || dst.remaining < 1)
                    return xflow(src, mark, 3)
                  end
                  b2 = src.get
                  b3 = src.get
                  if (is_malformed3(b1, b2, b3))
                    return malformed(src, mark, 3)
                  end
                  dst.put(RJava.cast_to_char((((b1 << 12) ^ (b2 << 6) ^ b3) ^ 0x1f80)))
                  mark += 3
                else
                  if (((b1 >> 3)).equal?(-2))
                    # 4 bytes, 21 bits: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
                    if (limit_ - mark < 4 || dst.remaining < 2)
                      return xflow(src, mark, 4)
                    end
                    b2 = src.get
                    b3 = src.get
                    b4 = src.get
                    uc = ((b1 & 0x7) << 18) | ((b2 & 0x3f) << 12) | ((b3 & 0x3f) << 6) | (b4 & 0x3f)
                    if (is_malformed4(b2, b3, b4) || !Surrogate.needed_for(uc))
                      # shortest form check
                      return malformed(src, mark, 4)
                    end
                    dst.put(Surrogate.high(uc))
                    dst.put(Surrogate.low(uc))
                    mark += 4
                  else
                    return malformed(src, mark, 1)
                  end
                end
              end
            end
          end
          return xflow(src, mark, 0)
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
        include_class_members UTF_8
        
        typesig { [Charset] }
        def initialize(cs)
          @sgp = nil
          super(cs, 1.1, 4.0)
        end
        
        typesig { [::Java::Char] }
        def can_encode(c)
          return !Surrogate.is(c)
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def is_legal_replacement(repl)
          return (((repl.attr_length).equal?(1) && repl[0] >= 0) || super(repl))
        end
        
        class_module.module_eval {
          typesig { [CharBuffer, ::Java::Int, ByteBuffer, ::Java::Int] }
          def overflow(src, sp, dst, dp)
            update_positions(src, sp, dst, dp)
            return CoderResult::OVERFLOW
          end
          
          typesig { [CharBuffer, ::Java::Int] }
          def overflow(src, mark)
            src.position(mark)
            return CoderResult::OVERFLOW
          end
        }
        
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
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          dl_ascii = dp + Math.min(sl - sp, dl - dp)
          # ASCII only loop
          while (dp < dl_ascii && sa[sp] < Character.new(0x0080))
            da[((dp += 1) - 1)] = sa[((sp += 1) - 1)]
          end
          while (sp < sl)
            c = sa[sp]
            if (c < 0x80)
              # Have at most seven bits
              if (dp >= dl)
                return overflow(src, sp, dst, dp)
              end
              da[((dp += 1) - 1)] = c
            else
              if (c < 0x800)
                # 2 bytes, 11 bits
                if (dl - dp < 2)
                  return overflow(src, sp, dst, dp)
                end
                da[((dp += 1) - 1)] = (0xc0 | ((c >> 6)))
                da[((dp += 1) - 1)] = (0x80 | (c & 0x3f))
              else
                if (Surrogate.is(c))
                  # Have a surrogate pair
                  if ((@sgp).nil?)
                    @sgp = Surrogate::Parser.new
                  end
                  uc = @sgp.parse(RJava.cast_to_char(c), sa, sp, sl)
                  if (uc < 0)
                    update_positions(src, sp, dst, dp)
                    return @sgp.error
                  end
                  if (dl - dp < 4)
                    return overflow(src, sp, dst, dp)
                  end
                  da[((dp += 1) - 1)] = (0xf0 | ((uc >> 18)))
                  da[((dp += 1) - 1)] = (0x80 | ((uc >> 12) & 0x3f))
                  da[((dp += 1) - 1)] = (0x80 | ((uc >> 6) & 0x3f))
                  da[((dp += 1) - 1)] = (0x80 | (uc & 0x3f))
                  ((sp += 1) - 1) # 2 chars
                else
                  # 3 bytes, 16 bits
                  if (dl - dp < 3)
                    return overflow(src, sp, dst, dp)
                  end
                  da[((dp += 1) - 1)] = (0xe0 | ((c >> 12)))
                  da[((dp += 1) - 1)] = (0x80 | ((c >> 6) & 0x3f))
                  da[((dp += 1) - 1)] = (0x80 | (c & 0x3f))
                end
              end
            end
            ((sp += 1) - 1)
          end
          update_positions(src, sp, dst, dp)
          return CoderResult::UNDERFLOW
        end
        
        typesig { [CharBuffer, ByteBuffer] }
        def encode_buffer_loop(src, dst)
          mark = src.position
          while (src.has_remaining)
            c = src.get
            if (c < 0x80)
              # Have at most seven bits
              if (!dst.has_remaining)
                return overflow(src, mark)
              end
              dst.put(c)
            else
              if (c < 0x800)
                # 2 bytes, 11 bits
                if (dst.remaining < 2)
                  return overflow(src, mark)
                end
                dst.put((0xc0 | ((c >> 6))))
                dst.put((0x80 | (c & 0x3f)))
              else
                if (Surrogate.is(c))
                  # Have a surrogate pair
                  if ((@sgp).nil?)
                    @sgp = Surrogate::Parser.new
                  end
                  uc = @sgp.parse(RJava.cast_to_char(c), src)
                  if (uc < 0)
                    src.position(mark)
                    return @sgp.error
                  end
                  if (dst.remaining < 4)
                    return overflow(src, mark)
                  end
                  dst.put((0xf0 | ((uc >> 18))))
                  dst.put((0x80 | ((uc >> 12) & 0x3f)))
                  dst.put((0x80 | ((uc >> 6) & 0x3f)))
                  dst.put((0x80 | (uc & 0x3f)))
                  ((mark += 1) - 1) # 2 chars
                else
                  # 3 bytes, 16 bits
                  if (dst.remaining < 3)
                    return overflow(src, mark)
                  end
                  dst.put((0xe0 | ((c >> 12))))
                  dst.put((0x80 | ((c >> 6) & 0x3f)))
                  dst.put((0x80 | (c & 0x3f)))
                end
              end
            end
            ((mark += 1) - 1)
          end
          src.position(mark)
          return CoderResult::UNDERFLOW
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
    alias_method :initialize__utf_8, :initialize
  end
  
end
