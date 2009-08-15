require "rjava"

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
  module UnicodeDecoderImports
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
    }
  end
  
  class UnicodeDecoder < UnicodeDecoderImports.const_get :CharsetDecoder
    include_class_members UnicodeDecoderImports
    
    class_module.module_eval {
      const_set_lazy(:BYTE_ORDER_MARK) { RJava.cast_to_char(0xfeff) }
      const_attr_reader  :BYTE_ORDER_MARK
      
      const_set_lazy(:REVERSED_MARK) { RJava.cast_to_char(0xfffe) }
      const_attr_reader  :REVERSED_MARK
      
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      const_set_lazy(:BIG) { 1 }
      const_attr_reader  :BIG
      
      const_set_lazy(:LITTLE) { 2 }
      const_attr_reader  :LITTLE
    }
    
    attr_accessor :expected_byte_order
    alias_method :attr_expected_byte_order, :expected_byte_order
    undef_method :expected_byte_order
    alias_method :attr_expected_byte_order=, :expected_byte_order=
    undef_method :expected_byte_order=
    
    attr_accessor :current_byte_order
    alias_method :attr_current_byte_order, :current_byte_order
    undef_method :current_byte_order
    alias_method :attr_current_byte_order=, :current_byte_order=
    undef_method :current_byte_order=
    
    attr_accessor :default_byte_order
    alias_method :attr_default_byte_order, :default_byte_order
    undef_method :default_byte_order
    alias_method :attr_default_byte_order=, :default_byte_order=
    undef_method :default_byte_order=
    
    typesig { [Charset, ::Java::Int] }
    def initialize(cs, bo)
      @expected_byte_order = 0
      @current_byte_order = 0
      @default_byte_order = 0
      super(cs, 0.5, 1.0)
      @default_byte_order = BIG
      @expected_byte_order = @current_byte_order = bo
    end
    
    typesig { [Charset, ::Java::Int, ::Java::Int] }
    def initialize(cs, bo, default_bo)
      initialize__unicode_decoder(cs, bo)
      @default_byte_order = default_bo
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def decode(b1, b2)
      if ((@current_byte_order).equal?(BIG))
        return RJava.cast_to_char(((b1 << 8) | b2))
      else
        return RJava.cast_to_char(((b2 << 8) | b1))
      end
    end
    
    typesig { [ByteBuffer, CharBuffer] }
    def decode_loop(src, dst)
      mark = src.position
      begin
        while (src.remaining > 1)
          b1 = src.get & 0xff
          b2 = src.get & 0xff
          # Byte Order Mark interpretation
          if ((@current_byte_order).equal?(NONE))
            c = RJava.cast_to_char(((b1 << 8) | b2))
            if ((c).equal?(BYTE_ORDER_MARK))
              @current_byte_order = BIG
              mark += 2
              next
            else
              if ((c).equal?(REVERSED_MARK))
                @current_byte_order = LITTLE
                mark += 2
                next
              else
                @current_byte_order = @default_byte_order
                # FALL THROUGH to process b1, b2 normally
              end
            end
          end
          c = decode(b1, b2)
          if ((c).equal?(REVERSED_MARK))
            # A reversed BOM cannot occur within middle of stream
            return CoderResult.malformed_for_length(2)
          end
          # Surrogates
          if (Surrogate.is(c))
            if (Surrogate.is_high(c))
              if (src.remaining < 2)
                return CoderResult::UNDERFLOW
              end
              c2 = decode(src.get & 0xff, src.get & 0xff)
              if (!Surrogate.is_low(c2))
                return CoderResult.malformed_for_length(4)
              end
              if (dst.remaining < 2)
                return CoderResult::OVERFLOW
              end
              mark += 4
              dst.put(c)
              dst.put(c2)
              next
            end
            # Unpaired low surrogate
            return CoderResult.malformed_for_length(2)
          end
          if (!dst.has_remaining)
            return CoderResult::OVERFLOW
          end
          mark += 2
          dst.put(c)
        end
        return CoderResult::UNDERFLOW
      ensure
        src.position(mark)
      end
    end
    
    typesig { [] }
    def impl_reset
      @current_byte_order = @expected_byte_order
    end
    
    private
    alias_method :initialize__unicode_decoder, :initialize
  end
  
end
