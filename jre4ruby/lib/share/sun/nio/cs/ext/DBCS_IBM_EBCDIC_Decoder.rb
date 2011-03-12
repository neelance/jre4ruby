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
  module DBCS_IBM_EBCDIC_DecoderImports #:nodoc:
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
  
  # An abstract base class for subclasses which decode
  # IBM double byte ebcdic host encodings such as ibm code
  # pages 933, 935, 937,... etc
  class DBCS_IBM_EBCDIC_Decoder < DBCS_IBM_EBCDIC_DecoderImports.const_get :CharsetDecoder
    include_class_members DBCS_IBM_EBCDIC_DecoderImports
    
    attr_accessor :decoder_mapping
    alias_method :attr_decoder_mapping, :decoder_mapping
    undef_method :decoder_mapping
    alias_method :attr_decoder_mapping=, :decoder_mapping=
    undef_method :decoder_mapping=
    
    class_module.module_eval {
      const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
      const_attr_reader  :REPLACE_CHAR
    }
    
    attr_accessor :single_byte_to_char
    alias_method :attr_single_byte_to_char, :single_byte_to_char
    undef_method :single_byte_to_char
    alias_method :attr_single_byte_to_char=, :single_byte_to_char=
    undef_method :single_byte_to_char=
    
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
    
    class_module.module_eval {
      const_set_lazy(:SBCS) { 0 }
      const_attr_reader  :SBCS
      
      const_set_lazy(:DBCS) { 1 }
      const_attr_reader  :DBCS
      
      const_set_lazy(:SO) { 0xe }
      const_attr_reader  :SO
      
      const_set_lazy(:SI) { 0xf }
      const_attr_reader  :SI
    }
    
    attr_accessor :current_state
    alias_method :attr_current_state, :current_state
    undef_method :current_state
    alias_method :attr_current_state=, :current_state=
    undef_method :current_state=
    
    typesig { [Charset] }
    def initialize(cs)
      @decoder_mapping = nil
      @single_byte_to_char = nil
      @index1 = nil
      @index2 = nil
      @mask1 = 0
      @mask2 = 0
      @shift = 0
      @current_state = 0
      super(cs, 0.5, 1.0)
    end
    
    typesig { [] }
    def impl_reset
      @current_state = SBCS
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
          v = 0
          output_char = REPLACE_CHAR
          if (b1 < 0)
            b1 += 256
          end
          if ((b1).equal?(SO))
            # Shift out
            # For SO characters - simply validate the state and if OK
            #    update the state and go to the next byte
            if (!(@current_state).equal?(SBCS))
              return CoderResult.malformed_for_length(1)
            else
              @current_state = DBCS
            end
          else
            if ((b1).equal?(SI))
              # For SI characters - simply validate the state and if OK
              #    update the state and go to the next byte
              if (!(@current_state).equal?(DBCS))
                return CoderResult.malformed_for_length(1)
              else
                @current_state = SBCS
              end
            else
              if ((@current_state).equal?(SBCS))
                output_char = @single_byte_to_char.char_at(b1)
              else
                if (sl - sp < 2)
                  return CoderResult::UNDERFLOW
                end
                b2 = sa[sp + 1]
                if (b2 < 0)
                  b2 += 256
                end
                input_size += 1
                # Check validity of dbcs ebcdic byte pair values
                if ((!(b1).equal?(0x40) || !(b2).equal?(0x40)) && (b2 < 0x41 || b2 > 0xfe))
                  return CoderResult.malformed_for_length(2)
                end
                # Lookup in the two level index
                v = b1 * 256 + b2
                output_char = @index2.char_at(@index1[((v & @mask1) >> @shift)] + (v & @mask2))
              end
              if ((output_char).equal?(Character.new(0xFFFD)))
                return CoderResult.unmappable_for_length(input_size)
              end
              if (dl - dp < 1)
                return CoderResult::OVERFLOW
              end
              da[((dp += 1) - 1)] = output_char
            end
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
      begin
        while (src.has_remaining)
          b1 = 0
          b2 = 0
          v = 0
          b1 = src.get
          input_size = 1
          output_char = REPLACE_CHAR
          if (b1 < 0)
            b1 += 256
          end
          if ((b1).equal?(SO))
            # Shift out
            # For SO characters - simply validate the state and if OK
            #    update the state and go to the next byte
            if (!(@current_state).equal?(SBCS))
              return CoderResult.malformed_for_length(1)
            else
              @current_state = DBCS
            end
          else
            if ((b1).equal?(SI))
              # For SI characters - simply validate the state and if OK
              #    update the state and go to the next byte
              if (!(@current_state).equal?(DBCS))
                return CoderResult.malformed_for_length(1)
              else
                @current_state = SBCS
              end
            else
              if ((@current_state).equal?(SBCS))
                output_char = @single_byte_to_char.char_at(b1)
              else
                if (src.remaining < 1)
                  return CoderResult::UNDERFLOW
                end
                b2 = src.get
                if (b2 < 0)
                  b2 += 256
                end
                input_size += 1
                # Check validity of dbcs ebcdic byte pair values
                if ((!(b1).equal?(0x40) || !(b2).equal?(0x40)) && (b2 < 0x41 || b2 > 0xfe))
                  return CoderResult.malformed_for_length(2)
                end
                # Lookup in the two level index
                v = b1 * 256 + b2
                output_char = @index2.char_at(@index1[((v & @mask1) >> @shift)] + (v & @mask2))
              end
              if ((output_char).equal?(REPLACE_CHAR))
                return CoderResult.unmappable_for_length(input_size)
              end
              if (!dst.has_remaining)
                return CoderResult::OVERFLOW
              end
              dst.put(output_char)
            end
          end
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
    alias_method :initialize__dbcs_ibm_ebcdic_decoder, :initialize
  end
  
end
