require "rjava"

# 
# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SingleByteDecoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Java::Nio::Charset, :MalformedInputException
      include_const ::Java::Nio::Charset, :UnmappableCharacterException
    }
  end
  
  class SingleByteDecoder < SingleByteDecoderImports.const_get :CharsetDecoder
    include_class_members SingleByteDecoderImports
    
    attr_accessor :byte_to_char_table
    alias_method :attr_byte_to_char_table, :byte_to_char_table
    undef_method :byte_to_char_table
    alias_method :attr_byte_to_char_table=, :byte_to_char_table=
    undef_method :byte_to_char_table=
    
    typesig { [Charset, String] }
    def initialize(cs, byte_to_char_table)
      @byte_to_char_table = nil
      super(cs, 1.0, 1.0)
      @byte_to_char_table = byte_to_char_table
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
          c = decode(b)
          if ((c).equal?(Character.new(0xFFFD)))
            return CoderResult.unmappable_for_length(1)
          end
          if (dl - dp < 1)
            return CoderResult::OVERFLOW
          end
          da[((dp += 1) - 1)] = c
          ((sp += 1) - 1)
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
          c = decode(b)
          if ((c).equal?(Character.new(0xFFFD)))
            return CoderResult.unmappable_for_length(1)
          end
          if (!dst.has_remaining)
            return CoderResult::OVERFLOW
          end
          ((mark += 1) - 1)
          dst.put(c)
        end
        return CoderResult::UNDERFLOW
      ensure
        src.position(mark)
      end
    end
    
    typesig { [ByteBuffer, CharBuffer] }
    def decode_loop(src, dst)
      if (true && src.has_array && dst.has_array)
        return decode_array_loop(src, dst)
      else
        return decode_buffer_loop(src, dst)
      end
    end
    
    typesig { [::Java::Int] }
    def decode(byte_index)
      n = byte_index + 128
      if (n >= @byte_to_char_table.length || n < 0)
        return Character.new(0xFFFD)
      end
      return @byte_to_char_table.char_at(n)
    end
    
    private
    alias_method :initialize__single_byte_decoder, :initialize
  end
  
end
