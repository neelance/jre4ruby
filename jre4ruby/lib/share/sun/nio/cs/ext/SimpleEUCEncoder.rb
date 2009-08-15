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
  module SimpleEUCEncoderImports
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
  
  class SimpleEUCEncoder < SimpleEUCEncoderImports.const_get :CharsetEncoder
    include_class_members SimpleEUCEncoderImports
    
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
    
    attr_accessor :index2a
    alias_method :attr_index2a, :index2a
    undef_method :index2a
    alias_method :attr_index2a=, :index2a=
    undef_method :index2a=
    
    attr_accessor :index2b
    alias_method :attr_index2b, :index2b
    undef_method :index2b
    alias_method :attr_index2b=, :index2b=
    undef_method :index2b=
    
    attr_accessor :index2c
    alias_method :attr_index2c, :index2c
    undef_method :index2c
    alias_method :attr_index2c=, :index2c=
    undef_method :index2c=
    
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
    
    attr_accessor :output_byte
    alias_method :attr_output_byte, :output_byte
    undef_method :output_byte
    alias_method :attr_output_byte=, :output_byte=
    undef_method :output_byte=
    
    attr_accessor :sgp
    alias_method :attr_sgp, :sgp
    undef_method :sgp
    alias_method :attr_sgp=, :sgp=
    undef_method :sgp=
    
    typesig { [Charset] }
    def initialize(cs)
      @index1 = nil
      @index2 = nil
      @index2a = nil
      @index2b = nil
      @index2c = nil
      @mask1 = 0
      @mask2 = 0
      @shift = 0
      @output_byte = nil
      @sgp = nil
      super(cs, 3.0, 4.0)
      @output_byte = Array.typed(::Java::Byte).new(4) { 0 }
      @sgp = Surrogate::Parser.new
    end
    
    typesig { [::Java::Char] }
    # Returns true if the given character can be converted to the
    # target character encoding.
    def can_encode(ch)
      index = 0
      the_chars = nil
      index = @index1[((ch & @mask1) >> @shift)] + (ch & @mask2)
      if (index < 7500)
        the_chars = @index2
      else
        if (index < 15000)
          index = index - 7500
          the_chars = @index2a
        else
          if (index < 22500)
            index = index - 15000
            the_chars = @index2b
          else
            index = index - 22500
            the_chars = @index2c
          end
        end
      end
      if (!(the_chars.char_at(2 * index)).equal?(Character.new(0x0000)) || !(the_chars.char_at(2 * index + 1)).equal?(Character.new(0x0000)))
        return (true)
      end
      # only return true if input char was unicode null - all others are
      # undefined
      return ((ch).equal?(Character.new(0x0000)))
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
      index = 0
      space_needed = 0
      i = 0
      begin
        while (sp < sl)
          all_zeroes = true
          input_char = sa[sp]
          if (Surrogate.is(input_char))
            if (@sgp.parse(input_char, sa, sp, sl) < 0)
              return @sgp.error
            end
            return @sgp.unmappable_result
          end
          if (input_char >= Character.new(0xFFFE))
            return CoderResult.unmappable_for_length(1)
          end
          the_chars = nil
          a_char = 0
          # We have a valid character, get the bytes for it
          index = @index1[((input_char & @mask1) >> @shift)] + (input_char & @mask2)
          if (index < 7500)
            the_chars = @index2
          else
            if (index < 15000)
              index = index - 7500
              the_chars = @index2a
            else
              if (index < 22500)
                index = index - 15000
                the_chars = @index2b
              else
                index = index - 22500
                the_chars = @index2c
              end
            end
          end
          a_char = the_chars.char_at(2 * index)
          @output_byte[0] = ((a_char & 0xff00) >> 8)
          @output_byte[1] = (a_char & 0xff)
          a_char = the_chars.char_at(2 * index + 1)
          @output_byte[2] = ((a_char & 0xff00) >> 8)
          @output_byte[3] = (a_char & 0xff)
          i = 0
          while i < @output_byte.attr_length
            if (!(@output_byte[i]).equal?(0x0))
              all_zeroes = false
              break
            end
            i += 1
          end
          if (all_zeroes && !(input_char).equal?(Character.new(0x0000)))
            return CoderResult.unmappable_for_length(1)
          end
          oindex = 0
          space_needed = @output_byte.attr_length
          while space_needed > 1
            if (!(@output_byte[((oindex += 1) - 1)]).equal?(0x0))
              break
            end
            space_needed -= 1
          end
          if (dp + space_needed > dl)
            return CoderResult::OVERFLOW
          end
          i = @output_byte.attr_length - space_needed
          while i < @output_byte.attr_length
            da[((dp += 1) - 1)] = @output_byte[i]
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
      index = 0
      space_needed = 0
      i = 0
      mark = src.position
      begin
        while (src.has_remaining)
          input_char = src.get
          all_zeroes = true
          if (Surrogate.is(input_char))
            if (@sgp.parse(input_char, src) < 0)
              return @sgp.error
            end
            return @sgp.unmappable_result
          end
          if (input_char >= Character.new(0xFFFE))
            return CoderResult.unmappable_for_length(1)
          end
          the_chars = nil
          a_char = 0
          # We have a valid character, get the bytes for it
          index = @index1[((input_char & @mask1) >> @shift)] + (input_char & @mask2)
          if (index < 7500)
            the_chars = @index2
          else
            if (index < 15000)
              index = index - 7500
              the_chars = @index2a
            else
              if (index < 22500)
                index = index - 15000
                the_chars = @index2b
              else
                index = index - 22500
                the_chars = @index2c
              end
            end
          end
          a_char = the_chars.char_at(2 * index)
          @output_byte[0] = ((a_char & 0xff00) >> 8)
          @output_byte[1] = (a_char & 0xff)
          a_char = the_chars.char_at(2 * index + 1)
          @output_byte[2] = ((a_char & 0xff00) >> 8)
          @output_byte[3] = (a_char & 0xff)
          i = 0
          while i < @output_byte.attr_length
            if (!(@output_byte[i]).equal?(0x0))
              all_zeroes = false
              break
            end
            i += 1
          end
          if (all_zeroes && !(input_char).equal?(Character.new(0x0000)))
            return CoderResult.unmappable_for_length(1)
          end
          oindex = 0
          space_needed = @output_byte.attr_length
          while space_needed > 1
            if (!(@output_byte[((oindex += 1) - 1)]).equal?(0x0))
              break
            end
            space_needed -= 1
          end
          if (dst.remaining < space_needed)
            return CoderResult::OVERFLOW
          end
          i = @output_byte.attr_length - space_needed
          while i < @output_byte.attr_length
            dst.put(@output_byte[i])
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
    alias_method :initialize__simple_eucencoder, :initialize
  end
  
end
