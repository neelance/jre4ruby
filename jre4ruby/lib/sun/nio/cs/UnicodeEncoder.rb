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
  module UnicodeEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include ::Java::Nio
      include ::Java::Nio::Charset
    }
  end
  
  # Base class for different flavors of UTF-16 encoders
  class UnicodeEncoder < UnicodeEncoderImports.const_get :CharsetEncoder
    include_class_members UnicodeEncoderImports
    
    class_module.module_eval {
      const_set_lazy(:BYTE_ORDER_MARK) { Character.new(0xFEFF) }
      const_attr_reader  :BYTE_ORDER_MARK
      
      const_set_lazy(:REVERSED_MARK) { Character.new(0xFFFE) }
      const_attr_reader  :REVERSED_MARK
      
      const_set_lazy(:BIG) { 0 }
      const_attr_reader  :BIG
      
      const_set_lazy(:LITTLE) { 1 }
      const_attr_reader  :LITTLE
    }
    
    attr_accessor :byte_order
    alias_method :attr_byte_order, :byte_order
    undef_method :byte_order
    alias_method :attr_byte_order=, :byte_order=
    undef_method :byte_order=
    
    # Byte order in use
    attr_accessor :uses_mark
    alias_method :attr_uses_mark, :uses_mark
    undef_method :uses_mark
    alias_method :attr_uses_mark=, :uses_mark=
    undef_method :uses_mark=
    
    # Write an initial BOM
    attr_accessor :needs_mark
    alias_method :attr_needs_mark, :needs_mark
    undef_method :needs_mark
    alias_method :attr_needs_mark=, :needs_mark=
    undef_method :needs_mark=
    
    typesig { [Charset, ::Java::Int, ::Java::Boolean] }
    def initialize(cs, bo, m)
      # Four bytes max if you need a BOM
      # Replacement depends upon byte order
      @byte_order = 0
      @uses_mark = false
      @needs_mark = false
      @sgp = nil
      super(cs, 2.0, m ? 4.0 : 2.0, (((bo).equal?(BIG)) ? Array.typed(::Java::Byte).new([0xff, 0xfd]) : Array.typed(::Java::Byte).new([0xfd, 0xff])))
      @sgp = Surrogate::Parser.new
      @uses_mark = @needs_mark = m
      @byte_order = bo
    end
    
    typesig { [::Java::Char, ByteBuffer] }
    def put(c, dst)
      if ((@byte_order).equal?(BIG))
        dst.put((c >> 8))
        dst.put((c & 0xff))
      else
        dst.put((c & 0xff))
        dst.put((c >> 8))
      end
    end
    
    attr_accessor :sgp
    alias_method :attr_sgp, :sgp
    undef_method :sgp
    alias_method :attr_sgp=, :sgp=
    undef_method :sgp=
    
    typesig { [CharBuffer, ByteBuffer] }
    def encode_loop(src, dst)
      mark = src.position
      if (@needs_mark)
        if (dst.remaining < 2)
          return CoderResult::OVERFLOW
        end
        put(BYTE_ORDER_MARK, dst)
        @needs_mark = false
      end
      begin
        while (src.has_remaining)
          c = src.get
          if (!Surrogate.is(c))
            if (dst.remaining < 2)
              return CoderResult::OVERFLOW
            end
            mark += 1
            put(c, dst)
            next
          end
          d = @sgp.parse(c, src)
          if (d < 0)
            return @sgp.error
          end
          if (dst.remaining < 4)
            return CoderResult::OVERFLOW
          end
          mark += 2
          put(Surrogate.high(d), dst)
          put(Surrogate.low(d), dst)
        end
        return CoderResult::UNDERFLOW
      ensure
        src.position(mark)
      end
    end
    
    typesig { [] }
    def impl_reset
      @needs_mark = @uses_mark
    end
    
    typesig { [::Java::Char] }
    def can_encode(c)
      return !Surrogate.is(c)
    end
    
    private
    alias_method :initialize__unicode_encoder, :initialize
  end
  
end
