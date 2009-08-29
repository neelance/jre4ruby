require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DBCS_ONLY_IBM_EBCDIC_DecoderImports #:nodoc:
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
  # IBM double byte only ebcdic host encodings such as ibm
  # code pages 834 835 837 300,... etc
  # 
  # The structure of IBM DBCS-only charsets is defined by the
  # IBM Character Data Representation Architecture (CDRA) document
  # 
  # http://www-306.ibm.com/software/globalization/cdra/appendix_a.jsp#HDRHEBDBST
  class DBCS_ONLY_IBM_EBCDIC_Decoder < DBCS_ONLY_IBM_EBCDIC_DecoderImports.const_get :CharsetDecoder
    include_class_members DBCS_ONLY_IBM_EBCDIC_DecoderImports
    
    class_module.module_eval {
      const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
      const_attr_reader  :REPLACE_CHAR
    }
    
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
    
    typesig { [Charset] }
    def initialize(cs)
      @index1 = nil
      @index2 = nil
      @mask1 = 0
      @mask2 = 0
      @shift = 0
      super(cs, 0.5, 1.0)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int] }
      # Check validity of dbcs ebcdic byte pair values
      def is_valid_double_byte(b1, b2)
        # DBCS-HOST SPACE
        return ((b1).equal?(0x40) && (b2).equal?(0x40)) || (0x41 <= b1 && b1 <= 0xfe && 0x41 <= b2 && b2 <= 0xfe)
      end
    }
    
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
        while (sp + 1 < sl)
          b1 = sa[sp] & 0xff
          b2 = sa[sp + 1] & 0xff
          if (!is_valid_double_byte(b1, b2))
            return CoderResult.malformed_for_length(2)
          end
          # Lookup in the two level index
          v = b1 * 256 + b2
          output_char = @index2.char_at(@index1[((v & @mask1) >> @shift)] + (v & @mask2))
          if ((output_char).equal?(REPLACE_CHAR))
            return CoderResult.unmappable_for_length(2)
          end
          if (dl - dp < 1)
            return CoderResult::OVERFLOW
          end
          da[((dp += 1) - 1)] = output_char
          sp += 2
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
        while (src.remaining > 1)
          b1 = src.get & 0xff
          b2 = src.get & 0xff
          if (!is_valid_double_byte(b1, b2))
            return CoderResult.malformed_for_length(2)
          end
          # Lookup in the two level index
          v = b1 * 256 + b2
          output_char = @index2.char_at(@index1[((v & @mask1) >> @shift)] + (v & @mask2))
          if ((output_char).equal?(REPLACE_CHAR))
            return CoderResult.unmappable_for_length(2)
          end
          if (!dst.has_remaining)
            return CoderResult::OVERFLOW
          end
          dst.put(output_char)
          mark += 2
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
    alias_method :initialize__dbcs_only_ibm_ebcdic_decoder, :initialize
  end
  
end
