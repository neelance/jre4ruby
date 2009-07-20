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
  module SingleByteEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Java::Nio::Charset, :MalformedInputException
      include_const ::Java::Nio::Charset, :UnmappableCharacterException
      include_const ::Sun::Nio::Cs, :Surrogate
    }
  end
  
  class SingleByteEncoder < SingleByteEncoderImports.const_get :CharsetEncoder
    include_class_members SingleByteEncoderImports
    
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
    
    attr_accessor :mask1
    alias_method :attr_mask1, :mask1
    undef_method :mask1
    alias_method :attr_mask1=, :mask1=
    undef_method :mask1=
    
    attr_accessor :mask2
    alias_method :attr_mask2, :mask2
    undef_method :mask2
    alias_method :attr_mask2=, :mask2=
    undef_method :mask2=
    
    attr_accessor :shift
    alias_method :attr_shift, :shift
    undef_method :shift
    alias_method :attr_shift=, :shift=
    undef_method :shift=
    
    attr_accessor :sgp
    alias_method :attr_sgp, :sgp
    undef_method :sgp
    alias_method :attr_sgp=, :sgp=
    undef_method :sgp=
    
    typesig { [Charset, Array.typed(::Java::Short), String, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(cs, index1, index2, mask1, mask2, shift)
      @index1 = nil
      @index2 = nil
      @mask1 = 0
      @mask2 = 0
      @shift = 0
      @sgp = nil
      super(cs, 1.0, 1.0)
      @sgp = Surrogate::Parser.new
      @index1 = index1
      @index2 = index2
      @mask1 = mask1
      @mask2 = mask2
      @shift = shift
    end
    
    typesig { [::Java::Char] }
    def can_encode(c)
      test_encode = @index2.char_at(@index1[(c & @mask1) >> @shift] + (c & @mask2))
      return !(test_encode).equal?(Character.new(0x0000)) || (c).equal?(Character.new(0x0000))
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
      begin
        while (sp < sl)
          c = sa[sp]
          if (Surrogate.is(c))
            if (@sgp.parse(c, sa, sp, sl) < 0)
              return @sgp.error
            end
            return @sgp.unmappable_result
          end
          if (c >= Character.new(0xFFFE))
            return CoderResult.unmappable_for_length(1)
          end
          if (dl - dp < 1)
            return CoderResult::OVERFLOW
          end
          e = @index2.char_at(@index1[(c & @mask1) >> @shift] + (c & @mask2))
          # If output byte is zero because input char is zero
          # then character is mappable, o.w. fail
          if ((e).equal?(Character.new(0x0000)) && !(c).equal?(Character.new(0x0000)))
            return CoderResult.unmappable_for_length(1)
          end
          sp += 1
          da[((dp += 1) - 1)] = e
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
            if (@sgp.parse(c, src) < 0)
              return @sgp.error
            end
            return @sgp.unmappable_result
          end
          if (c >= Character.new(0xFFFE))
            return CoderResult.unmappable_for_length(1)
          end
          if (!dst.has_remaining)
            return CoderResult::OVERFLOW
          end
          e = @index2.char_at(@index1[(c & @mask1) >> @shift] + (c & @mask2))
          # If output byte is zero because input char is zero
          # then character is mappable, o.w. fail
          if ((e).equal?(Character.new(0x0000)) && !(c).equal?(Character.new(0x0000)))
            return CoderResult.unmappable_for_length(1)
          end
          mark += 1
          dst.put(e)
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
    def encode(input_char)
      return @index2.char_at(@index1[(input_char & @mask1) >> @shift] + (input_char & @mask2))
    end
    
    private
    alias_method :initialize__single_byte_encoder, :initialize
  end
  
end
