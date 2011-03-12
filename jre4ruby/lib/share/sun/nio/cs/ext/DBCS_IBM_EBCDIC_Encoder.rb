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
  module DBCS_IBM_EBCDIC_EncoderImports #:nodoc:
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
  
  # An abstract base class for subclasses which encodes
  # IBM double byte host encodings such as ibm code
  # pages 942,943,948, etc.
  class DBCS_IBM_EBCDIC_Encoder < DBCS_IBM_EBCDIC_EncoderImports.const_get :CharsetEncoder
    include_class_members DBCS_IBM_EBCDIC_EncoderImports
    
    class_module.module_eval {
      const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
      const_attr_reader  :REPLACE_CHAR
    }
    
    attr_accessor :b1
    alias_method :attr_b1, :b1
    undef_method :b1
    alias_method :attr_b1=, :b1=
    undef_method :b1=
    
    attr_accessor :b2
    alias_method :attr_b2, :b2
    undef_method :b2
    alias_method :attr_b2=, :b2=
    undef_method :b2=
    
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
    
    attr_accessor :sgp
    alias_method :attr_sgp, :sgp
    undef_method :sgp
    alias_method :attr_sgp=, :sgp=
    undef_method :sgp=
    
    typesig { [Charset] }
    def initialize(cs)
      @b1 = 0
      @b2 = 0
      @index1 = nil
      @index2 = nil
      @index2a = nil
      @mask1 = 0
      @mask2 = 0
      @shift = 0
      @current_state = 0
      @sgp = nil
      super(cs, 4.0, 5.0, Array.typed(::Java::Byte).new([0x6f]))
      @sgp = Surrogate::Parser.new
    end
    
    typesig { [] }
    def impl_reset
      @current_state = SBCS
    end
    
    typesig { [ByteBuffer] }
    def impl_flush(out)
      if ((@current_state).equal?(DBCS))
        if (out.remaining < 1)
          return CoderResult::OVERFLOW
        end
        out.put(SI)
      end
      impl_reset
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Char] }
    # Returns true if the given character can be converted to the
    # target character encoding.
    def can_encode(ch)
      index = 0
      the_bytes = 0
      index = @index1[((ch & @mask1) >> @shift)] + (ch & @mask2)
      if (index < 15000)
        the_bytes = ((@index2.char_at(index))).to_int
      else
        the_bytes = ((@index2a.char_at(index - 15000))).to_int
      end
      if (!(the_bytes).equal?(0))
        return (true)
      end
      # only return true if input char was unicode null - all others are
      #     undefined
      return ((ch).equal?(Character.new(0x0000)))
    end
    
    typesig { [CharBuffer, ByteBuffer] }
    def encode_array_loop(src, dst)
      sa = src.array
      sp = src.array_offset + src.position
      sl = src.array_offset + src.limit
      da = dst.array
      dp = dst.array_offset + dst.position
      dl = dst.array_offset + dst.limit
      output_size = 0 # size of output
      space_needed = 0
      begin
        while (sp < sl)
          index = 0
          the_bytes = 0
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
          index = @index1[((c & @mask1) >> @shift)] + (c & @mask2)
          if (index < 15000)
            the_bytes = ((@index2.char_at(index))).to_int
          else
            the_bytes = ((@index2a.char_at(index - 15000))).to_int
          end
          @b1 = ((the_bytes & 0xff00) >> 8)
          @b2 = (the_bytes & 0xff)
          if ((@b1).equal?(0x0) && (@b2).equal?(0x0) && !(c).equal?(Character.new(0x0000)))
            return CoderResult.unmappable_for_length(1)
          end
          if ((@current_state).equal?(DBCS) && (@b1).equal?(0x0))
            if (dl - dp < 1)
              return CoderResult::OVERFLOW
            end
            @current_state = SBCS
            da[((dp += 1) - 1)] = SI
          else
            if ((@current_state).equal?(SBCS) && !(@b1).equal?(0x0))
              if (dl - dp < 1)
                return CoderResult::OVERFLOW
              end
              @current_state = DBCS
              da[((dp += 1) - 1)] = SO
            end
          end
          if ((@current_state).equal?(DBCS))
            space_needed = 2
          else
            space_needed = 1
          end
          if (dl - dp < space_needed)
            return CoderResult::OVERFLOW
          end
          if ((@current_state).equal?(SBCS))
            da[((dp += 1) - 1)] = @b2
          else
            da[((dp += 1) - 1)] = @b1
            da[((dp += 1) - 1)] = @b2
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
      mark = src.position
      output_size = 0 # size of output
      space_needed = 0
      begin
        while (src.has_remaining)
          index = 0
          the_bytes = 0
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
          index = @index1[((c & @mask1) >> @shift)] + (c & @mask2)
          if (index < 15000)
            the_bytes = ((@index2.char_at(index))).to_int
          else
            the_bytes = ((@index2a.char_at(index - 15000))).to_int
          end
          @b1 = ((the_bytes & 0xff00) >> 8)
          @b2 = (the_bytes & 0xff)
          if ((@b1).equal?(0x0) && (@b2).equal?(0x0) && !(c).equal?(Character.new(0x0000)))
            return CoderResult.unmappable_for_length(1)
          end
          if ((@current_state).equal?(DBCS) && (@b1).equal?(0x0))
            if (dst.remaining < 1)
              return CoderResult::OVERFLOW
            end
            @current_state = SBCS
            dst.put(SI)
          else
            if ((@current_state).equal?(SBCS) && !(@b1).equal?(0x0))
              if (dst.remaining < 1)
                return CoderResult::OVERFLOW
              end
              @current_state = DBCS
              dst.put(SO)
            end
          end
          if ((@current_state).equal?(DBCS))
            space_needed = 2
          else
            space_needed = 1
          end
          if (dst.remaining < space_needed)
            return CoderResult::OVERFLOW
          end
          if ((@current_state).equal?(SBCS))
            dst.put(@b2)
          else
            dst.put(@b1)
            dst.put(@b2)
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
    
    private
    alias_method :initialize__dbcs_ibm_ebcdic_encoder, :initialize
  end
  
end
