require "rjava"

# 
# Copyright 2002-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DoubleByteDecoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CoderResult
    }
  end
  
  class DoubleByteDecoder < DoubleByteDecoderImports.const_get :CharsetDecoder
    include_class_members DoubleByteDecoderImports
    
    attr_accessor :index1
    alias_method :attr_index1, :index1
    undef_method :index1
    alias_method :attr_index1=, :index1=
    undef_method :index1=
    
    # 
    # 2nd level index, provided by subclass
    # every string has 0x10*(end-start+1) characters.
    attr_accessor :index2
    alias_method :attr_index2, :index2
    undef_method :index2
    alias_method :attr_index2=, :index2=
    undef_method :index2=
    
    attr_accessor :start
    alias_method :attr_start, :start
    undef_method :start
    alias_method :attr_start=, :start=
    undef_method :start=
    
    attr_accessor :end
    alias_method :attr_end, :end
    undef_method :end
    alias_method :attr_end=, :end=
    undef_method :end=
    
    class_module.module_eval {
      const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
      const_attr_reader  :REPLACE_CHAR
    }
    
    attr_accessor :high_surrogate
    alias_method :attr_high_surrogate, :high_surrogate
    undef_method :high_surrogate
    alias_method :attr_high_surrogate=, :high_surrogate=
    undef_method :high_surrogate=
    
    attr_accessor :low_surrogate
    alias_method :attr_low_surrogate, :low_surrogate
    undef_method :low_surrogate
    alias_method :attr_low_surrogate=, :low_surrogate=
    undef_method :low_surrogate=
    
    typesig { [Charset, Array.typed(::Java::Short), Array.typed(String), ::Java::Int, ::Java::Int] }
    def initialize(cs, index1, index2, start, end_)
      @index1 = nil
      @index2 = nil
      @start = 0
      @end = 0
      @high_surrogate = 0
      @low_surrogate = 0
      super(cs, 0.5, 1.0)
      @index1 = index1
      @index2 = index2
      @start = start
      @end = end_
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
          b1 = 0
          b2 = 0
          b1 = sa[sp]
          input_size = 1
          output_size = 1
          @high_surrogate = @low_surrogate = 0
          c = decode_single(b1)
          if ((c).equal?(REPLACE_CHAR))
            b1 &= 0xff
            if (sl - sp < 2)
              return CoderResult::UNDERFLOW
            end
            b2 = sa[sp + 1] & 0xff
            c = decode_double(b1, b2)
            input_size = 2
            if ((c).equal?(REPLACE_CHAR))
              return CoderResult.unmappable_for_length(input_size)
            end
            output_size = (@high_surrogate > 0) ? 2 : 1
          end
          if (dl - dp < output_size)
            return CoderResult::OVERFLOW
          end
          if ((output_size).equal?(2))
            da[((dp += 1) - 1)] = @high_surrogate
            da[((dp += 1) - 1)] = @low_surrogate
          else
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
    
    typesig { [ByteBuffer, CharBuffer] }
    def decode_buffer_loop(src, dst)
      mark = src.position
      input_size = 0
      output_size = 0
      begin
        while (src.has_remaining)
          b1 = src.get
          input_size = 1
          output_size = 1
          @high_surrogate = @low_surrogate = 0
          c = decode_single(b1)
          if ((c).equal?(REPLACE_CHAR))
            if (src.remaining < 1)
              return CoderResult::UNDERFLOW
            end
            b1 &= 0xff
            b2 = src.get & 0xff
            input_size = 2
            c = decode_double(b1, b2)
            if ((c).equal?(REPLACE_CHAR))
              return CoderResult.unmappable_for_length(2)
            end
            output_size = (@high_surrogate > 0) ? 2 : 1
          end
          if (dst.remaining < output_size)
            return CoderResult::OVERFLOW
          end
          mark += input_size
          if ((output_size).equal?(2))
            dst.put(@high_surrogate)
            dst.put(@low_surrogate)
          else
            dst.put(c)
          end
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
    
    typesig { [::Java::Int] }
    # 
    # Can be changed by subclass
    def decode_single(b)
      if (b >= 0)
        return RJava.cast_to_char(b)
      end
      return REPLACE_CHAR
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def decode_double(byte1, byte2)
      if (((byte1 < 0) || (byte1 > @index1.attr_length)) || ((byte2 < @start) || (byte2 > @end)))
        return REPLACE_CHAR
      end
      n = (@index1[byte1] & 0xf) * (@end - @start + 1) + (byte2 - @start)
      return @index2[@index1[byte1] >> 4].char_at(n)
    end
    
    private
    alias_method :initialize__double_byte_decoder, :initialize
  end
  
end
