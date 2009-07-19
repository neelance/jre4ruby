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
# 
# 
# Simple EUC-like decoder used by IBM01383 and IBM970
# supports G1 - no support for G2 or G3
module Sun::Nio::Cs::Ext
  module SimpleEUCDecoderImports
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
  
  class SimpleEUCDecoder < SimpleEUCDecoderImports.const_get :CharsetDecoder
    include_class_members SimpleEUCDecoderImports
    
    attr_accessor :ss2
    alias_method :attr_ss2, :ss2
    undef_method :ss2
    alias_method :attr_ss2=, :ss2=
    undef_method :ss2=
    
    attr_accessor :ss3
    alias_method :attr_ss3, :ss3
    undef_method :ss3
    alias_method :attr_ss3=, :ss3=
    undef_method :ss3=
    
    class_module.module_eval {
      
      def mapping_table_g1
        defined?(@@mapping_table_g1) ? @@mapping_table_g1 : @@mapping_table_g1= nil
      end
      alias_method :attr_mapping_table_g1, :mapping_table_g1
      
      def mapping_table_g1=(value)
        @@mapping_table_g1 = value
      end
      alias_method :attr_mapping_table_g1=, :mapping_table_g1=
      
      
      def byte_to_char_table
        defined?(@@byte_to_char_table) ? @@byte_to_char_table : @@byte_to_char_table= nil
      end
      alias_method :attr_byte_to_char_table, :byte_to_char_table
      
      def byte_to_char_table=(value)
        @@byte_to_char_table = value
      end
      alias_method :attr_byte_to_char_table=, :byte_to_char_table=
    }
    
    typesig { [Charset] }
    def initialize(cs)
      @ss2 = 0
      @ss3 = 0
      super(cs, 0.5, 1.0)
      @ss2 = 0x8e
      @ss3 = 0x8f
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
          byte1 = 0
          byte2 = 0
          input_size = 1
          output_char = Character.new(0xFFFD)
          byte1 = sa[sp] & 0xff
          if (byte1 <= 0x9f)
            # < 0x9f has its own table (G0)
            if ((byte1).equal?(@ss2) || (byte1).equal?(@ss3))
              # No support provided for G2/G3 at this time.
              return CoderResult.malformed_for_length(1)
            end
            output_char = self.attr_byte_to_char_table.char_at(byte1)
          else
            if (byte1 < 0xa1 || byte1 > 0xfe)
              # invalid range?
              return CoderResult.malformed_for_length(1)
            else
              # (G1)
              if (sl - sp < 2)
                return CoderResult::UNDERFLOW
              end
              byte2 = sa[sp + 1] & 0xff
              ((input_size += 1) - 1)
              if (byte2 < 0xa1 || byte2 > 0xfe)
                return CoderResult.malformed_for_length(2)
              end
              output_char = self.attr_mapping_table_g1.char_at(((byte1 - 0xa1) * 94) + byte2 - 0xa1)
            end
          end
          if ((output_char).equal?(Character.new(0xFFFD)))
            return CoderResult.unmappable_for_length(input_size)
          end
          if (dl - dp < 1)
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
      begin
        while (src.has_remaining)
          output_char = Character.new(0xFFFD)
          input_size = 1
          byte1 = 0
          byte2 = 0
          byte1 = src.get & 0xff
          if (byte1 <= 0x9f)
            if ((byte1).equal?(@ss2) || (byte1).equal?(@ss3))
              return CoderResult.malformed_for_length(1)
            end
            output_char = self.attr_byte_to_char_table.char_at(byte1)
          else
            if (byte1 < 0xa1 || byte1 > 0xfe)
              return CoderResult.malformed_for_length(1)
            else
              if (!src.has_remaining)
                return CoderResult::UNDERFLOW
              end
              byte2 = src.get & 0xff
              ((input_size += 1) - 1)
              if (byte2 < 0xa1 || byte2 > 0xfe)
                return CoderResult.malformed_for_length(2)
              end
              output_char = self.attr_mapping_table_g1.char_at(((byte1 - 0xa1) * 94) + byte2 - 0xa1)
            end
          end
          if ((output_char).equal?(Character.new(0xFFFD)))
            return CoderResult.unmappable_for_length(input_size)
          end
          if (!dst.has_remaining)
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
    def decode_loop(src, dst)
      if (src.has_array && dst.has_array)
        return decode_array_loop(src, dst)
      else
        return decode_buffer_loop(src, dst)
      end
    end
    
    private
    alias_method :initialize__simple_eucdecoder, :initialize
  end
  
end
