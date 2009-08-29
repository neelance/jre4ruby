require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UTF_32CoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
    }
  end
  
  class UTF_32Coder 
    include_class_members UTF_32CoderImports
    
    class_module.module_eval {
      const_set_lazy(:BOM_BIG) { 0xfeff }
      const_attr_reader  :BOM_BIG
      
      const_set_lazy(:BOM_LITTLE) { -0x20000 }
      const_attr_reader  :BOM_LITTLE
      
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      const_set_lazy(:BIG) { 1 }
      const_attr_reader  :BIG
      
      const_set_lazy(:LITTLE) { 2 }
      const_attr_reader  :LITTLE
      
      const_set_lazy(:Decoder) { Class.new(CharsetDecoder) do
        include_class_members UTF_32Coder
        
        attr_accessor :current_bo
        alias_method :attr_current_bo, :current_bo
        undef_method :current_bo
        alias_method :attr_current_bo=, :current_bo=
        undef_method :current_bo=
        
        attr_accessor :expected_bo
        alias_method :attr_expected_bo, :expected_bo
        undef_method :expected_bo
        alias_method :attr_expected_bo=, :expected_bo=
        undef_method :expected_bo=
        
        typesig { [class_self::Charset, ::Java::Int] }
        def initialize(cs, bo)
          @current_bo = 0
          @expected_bo = 0
          super(cs, 0.25, 1.0)
          @expected_bo = bo
          @current_bo = NONE
        end
        
        typesig { [class_self::ByteBuffer] }
        def get_cp(src)
          return ((@current_bo).equal?(BIG)) ? (((src.get & 0xff) << 24) | ((src.get & 0xff) << 16) | ((src.get & 0xff) << 8) | (src.get & 0xff)) : ((src.get & 0xff) | ((src.get & 0xff) << 8) | ((src.get & 0xff) << 16) | ((src.get & 0xff) << 24))
        end
        
        typesig { [class_self::ByteBuffer, class_self::CharBuffer] }
        def decode_loop(src, dst)
          if (src.remaining < 4)
            return CoderResult::UNDERFLOW
          end
          mark = src.position
          cp = 0
          begin
            if ((@current_bo).equal?(NONE))
              cp = ((src.get & 0xff) << 24) | ((src.get & 0xff) << 16) | ((src.get & 0xff) << 8) | (src.get & 0xff)
              if ((cp).equal?(BOM_BIG) && !(@expected_bo).equal?(LITTLE))
                @current_bo = BIG
                mark += 4
              else
                if ((cp).equal?(BOM_LITTLE) && !(@expected_bo).equal?(BIG))
                  @current_bo = LITTLE
                  mark += 4
                else
                  if ((@expected_bo).equal?(NONE))
                    @current_bo = BIG
                  else
                    @current_bo = @expected_bo
                  end
                  src.position(mark)
                end
              end
            end
            while (src.remaining > 3)
              cp = get_cp(src)
              if (cp < 0 || cp > Surrogate::UCS4_MAX)
                return CoderResult.malformed_for_length(4)
              end
              if (cp < Surrogate::UCS4_MIN)
                if (!dst.has_remaining)
                  return CoderResult::OVERFLOW
                end
                mark += 4
                dst.put(RJava.cast_to_char(cp))
              else
                if (dst.remaining < 2)
                  return CoderResult::OVERFLOW
                end
                mark += 4
                dst.put(Surrogate.high(cp))
                dst.put(Surrogate.low(cp))
              end
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [] }
        def impl_reset
          @current_bo = NONE
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(CharsetEncoder) do
        include_class_members UTF_32Coder
        
        attr_accessor :do_bom
        alias_method :attr_do_bom, :do_bom
        undef_method :do_bom
        alias_method :attr_do_bom=, :do_bom=
        undef_method :do_bom=
        
        attr_accessor :done_bom
        alias_method :attr_done_bom, :done_bom
        undef_method :done_bom
        alias_method :attr_done_bom=, :done_bom=
        undef_method :done_bom=
        
        attr_accessor :byte_order
        alias_method :attr_byte_order, :byte_order
        undef_method :byte_order
        alias_method :attr_byte_order=, :byte_order=
        undef_method :byte_order=
        
        typesig { [::Java::Int, class_self::ByteBuffer] }
        def put(cp, dst)
          if ((@byte_order).equal?(BIG))
            dst.put((cp >> 24))
            dst.put((cp >> 16))
            dst.put((cp >> 8))
            dst.put(cp)
          else
            dst.put(cp)
            dst.put((cp >> 8))
            dst.put((cp >> 16))
            dst.put((cp >> 24))
          end
        end
        
        typesig { [class_self::Charset, ::Java::Int, ::Java::Boolean] }
        def initialize(cs, byte_order, do_bom)
          @do_bom = false
          @done_bom = false
          @byte_order = 0
          super(cs, 4.0, do_bom ? 8.0 : 4.0, ((byte_order).equal?(BIG)) ? Array.typed(::Java::Byte).new([0, 0, 0xff, 0xfd]) : Array.typed(::Java::Byte).new([0xfd, 0xff, 0, 0]))
          @do_bom = false
          @done_bom = true
          @byte_order = byte_order
          @do_bom = do_bom
          @done_bom = !do_bom
        end
        
        typesig { [class_self::CharBuffer, class_self::ByteBuffer] }
        def encode_loop(src, dst)
          mark = src.position
          if (!@done_bom)
            if (dst.remaining < 4)
              return CoderResult::OVERFLOW
            end
            put(BOM_BIG, dst)
            @done_bom = true
          end
          begin
            while (src.has_remaining)
              c = src.get
              if (Surrogate.is_high(c))
                if (!src.has_remaining)
                  return CoderResult::UNDERFLOW
                end
                low = src.get
                if (Surrogate.is_low(low))
                  if (dst.remaining < 4)
                    return CoderResult::OVERFLOW
                  end
                  mark += 2
                  put(Surrogate.to_ucs4(c, low), dst)
                else
                  return CoderResult.malformed_for_length(1)
                end
              else
                if (Surrogate.is_low(c))
                  return CoderResult.malformed_for_length(1)
                else
                  if (dst.remaining < 4)
                    return CoderResult::OVERFLOW
                  end
                  mark += 1
                  put(c, dst)
                end
              end
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [] }
        def impl_reset
          @done_bom = !@do_bom
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__utf_32coder, :initialize
  end
  
end
