require "rjava"

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
module Sun::Nio::Cs::Ext
  module DoubleByteEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Sun::Nio::Cs, :Surrogate
    }
  end
  
  class DoubleByteEncoder < DoubleByteEncoderImports.const_get :CharsetEncoder
    include_class_members DoubleByteEncoderImports
    
    attr_accessor :index1
    alias_method :attr_index1, :index1
    undef_method :index1
    alias_method :attr_index1=, :index1=
    undef_method :index1=
    
    attr_accessor :index2
    alias_method :attr_index2, :index2
    undef_method :index2
    alias_method :attr_index2=, :index2=
    undef_method :index2=
    
    attr_accessor :sgp
    alias_method :attr_sgp, :sgp
    undef_method :sgp
    alias_method :attr_sgp=, :sgp=
    undef_method :sgp=
    
    typesig { [Charset, Array.typed(::Java::Short), Array.typed(String)] }
    def initialize(cs, index1, index2)
      @index1 = nil
      @index2 = nil
      @sgp = nil
      super(cs, 2.0, 2.0)
      @sgp = Surrogate::Parser.new
      @index1 = index1
      @index2 = index2
    end
    
    typesig { [Charset, Array.typed(::Java::Short), Array.typed(String), ::Java::Float, ::Java::Float] }
    def initialize(cs, index1, index2, avg, max)
      @index1 = nil
      @index2 = nil
      @sgp = nil
      super(cs, avg, max)
      @sgp = Surrogate::Parser.new
      @index1 = index1
      @index2 = index2
    end
    
    typesig { [Charset, Array.typed(::Java::Short), Array.typed(String), Array.typed(::Java::Byte)] }
    def initialize(cs, index1, index2, repl)
      @index1 = nil
      @index2 = nil
      @sgp = nil
      super(cs, 2.0, 2.0, repl)
      @sgp = Surrogate::Parser.new
      @index1 = index1
      @index2 = index2
    end
    
    typesig { [Charset, Array.typed(::Java::Short), Array.typed(String), Array.typed(::Java::Byte), ::Java::Float, ::Java::Float] }
    def initialize(cs, index1, index2, repl, avg, max)
      @index1 = nil
      @index2 = nil
      @sgp = nil
      super(cs, avg, max, repl)
      @sgp = Surrogate::Parser.new
      @index1 = index1
      @index2 = index2
    end
    
    typesig { [::Java::Char] }
    def can_encode(c)
      return (!(encode_single(c)).equal?(-1) || !(encode_double(c)).equal?(0))
    end
    
    typesig { [CharBuffer, ByteBuffer] }
    def encode_array_loop(src, dst)
      sa = src.array
      sp = src.array_offset + src.position
      sl = src.array_offset + src.limit
      da = dst.array
      dp = dst.array_offset + dst.position
      dl = dst.array_offset + dst.limit
      begin
        while (sp < sl)
          c = sa[sp]
          if (Surrogate.is(c))
            if (@sgp.parse(c, sa, sp, sl) < 0)
              return @sgp.error
            end
            if (sl - sp < 2)
              return CoderResult::UNDERFLOW
            end
            c2 = sa[sp + 1]
            output_bytes = Array.typed(::Java::Byte).new(2) { 0 }
            output_bytes = encode_surrogate(c, c2)
            if ((output_bytes).nil?)
              return @sgp.unmappable_result
            else
              if (dl - dp < 2)
                return CoderResult::OVERFLOW
              end
              da[((dp += 1) - 1)] = output_bytes[0]
              da[((dp += 1) - 1)] = output_bytes[1]
              sp += 2
              next
            end
          end
          if (c >= Character.new(0xFFFE))
            return CoderResult.unmappable_for_length(1)
          end
          b = encode_single(c)
          if (!(b).equal?(-1))
            # Single Byte
            if (dl - dp < 1)
              return CoderResult::OVERFLOW
            end
            da[((dp += 1) - 1)] = b
            sp += 1
            next
          end
          ncode = encode_double(c)
          if (!(ncode).equal?(0) && !(c).equal?(Character.new(0x0000)))
            if (dl - dp < 2)
              return CoderResult::OVERFLOW
            end
            da[((dp += 1) - 1)] = ((ncode & 0xff00) >> 8)
            da[((dp += 1) - 1)] = (ncode & 0xff)
            sp += 1
            next
          end
          return CoderResult.unmappable_for_length(1)
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
          if (Surrogate.is(c))
            surr = 0
            if ((surr = @sgp.parse(c, src)) < 0)
              return @sgp.error
            end
            c2 = Surrogate.low(surr)
            output_bytes = Array.typed(::Java::Byte).new(2) { 0 }
            output_bytes = encode_surrogate(c, c2)
            if ((output_bytes).nil?)
              return @sgp.unmappable_result
            else
              if (dst.remaining < 2)
                return CoderResult::OVERFLOW
              end
              mark += 2
              dst.put(output_bytes[0])
              dst.put(output_bytes[1])
              next
            end
          end
          if (c >= Character.new(0xFFFE))
            return CoderResult.unmappable_for_length(1)
          end
          b = encode_single(c)
          if (!(b).equal?(-1))
            # Single-byte character
            if (dst.remaining < 1)
              return CoderResult::OVERFLOW
            end
            mark += 1
            dst.put(b)
            next
          end
          # Double Byte character
          ncode = encode_double(c)
          if (!(ncode).equal?(0) && !(c).equal?(Character.new(0x0000)))
            if (dst.remaining < 2)
              return CoderResult::OVERFLOW
            end
            mark += 1
            dst.put(((ncode & 0xff00) >> 8))
            dst.put(ncode)
            next
          end
          return CoderResult.unmappable_for_length(1)
        end
        return CoderResult::UNDERFLOW
      ensure
        src.position(mark)
      end
    end
    
    typesig { [CharBuffer, ByteBuffer] }
    def encode_loop(src, dst)
      if (true && src.has_array && dst.has_array)
        return encode_array_loop(src, dst)
      else
        return encode_buffer_loop(src, dst)
      end
    end
    
    typesig { [::Java::Char] }
    # Can be changed by subclass
    def encode_double(ch)
      offset = @index1[((ch & 0xff00) >> 8)] << 8
      return @index2[offset >> 12].char_at((offset & 0xfff) + (ch & 0xff))
    end
    
    typesig { [::Java::Char] }
    # Can be changed by subclass
    def encode_single(input_char)
      if (input_char < 0x80)
        return input_char
      else
        return -1
      end
    end
    
    typesig { [::Java::Char, ::Java::Char] }
    # Protected method which should be overridden by concrete DBCS
    # CharsetEncoder classes which included supplementary characters
    # within their mapping coverage.
    # null return value indicates surrogate values could not be
    # handled or encoded.
    def encode_surrogate(high_surrogate, low_surrogate)
      return nil
    end
    
    private
    alias_method :initialize__double_byte_encoder, :initialize
  end
  
end
