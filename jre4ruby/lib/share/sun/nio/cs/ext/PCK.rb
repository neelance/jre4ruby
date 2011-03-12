require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PCKImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class PCK < PCKImports.const_get :Charset
    include_class_members PCKImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("x-PCK", ExtendedCharsets.aliases_for("x-PCK"))
    end
    
    typesig { [] }
    def historical_name
      return "PCK"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(JIS_X_0201)) || (cs.is_a?(PCK)))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      # Need to force the replacement byte to 0x3f
      # because JIS_X_0208_Encoder defines its own
      # alternative 2 byte substitution to permit it
      # to exist as a self-standing Encoder
      replacement_bytes = Array.typed(::Java::Byte).new([0x3f])
      return Encoder.new(self).replace_with(replacement_bytes)
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(SJIS::Decoder) do
        include_class_members PCK
        
        attr_accessor :jis0208
        alias_method :attr_jis0208, :jis0208
        undef_method :jis0208
        alias_method :attr_jis0208=, :jis0208=
        undef_method :jis0208=
        
        class_module.module_eval {
          const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
          const_attr_reader  :REPLACE_CHAR
        }
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          @jis0208 = nil
          super(cs)
          @jis0208 = self.class::JIS_X_0208_Solaris_Decoder.new(cs)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode_double(c1, c2)
          out_char = 0
          if (!((out_char = super(c1, c2))).equal?(Character.new(0xFFFD)))
            # Map JIS X 0208:1983 0x213D <--> U+2015
            return ((!(out_char).equal?(Character.new(0x2014))) ? out_char : Character.new(0x2015))
          else
            adjust = c2 < 0x9f ? 1 : 0
            row_offset = c1 < 0xa0 ? 0x70 : 0xb0
            cell_offset = ((adjust).equal?(1)) ? (c2 > 0x7f ? 0x20 : 0x1f) : 0x7e
            b1 = ((c1 - row_offset) << 1) - adjust
            b2 = c2 - cell_offset
            out_char2 = @jis0208.decode_double(b1, b2)
            return out_char2
          end
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(SJIS::Encoder) do
        include_class_members PCK
        
        attr_accessor :jis0201
        alias_method :attr_jis0201, :jis0201
        undef_method :jis0201
        alias_method :attr_jis0201=, :jis0201=
        undef_method :jis0201=
        
        attr_accessor :jis0208
        alias_method :attr_jis0208, :jis0208
        undef_method :jis0208
        alias_method :attr_jis0208=, :jis0208=
        undef_method :jis0208=
        
        attr_accessor :j0208index1
        alias_method :attr_j0208index1, :j0208index1
        undef_method :j0208index1
        alias_method :attr_j0208index1=, :j0208index1=
        undef_method :j0208index1=
        
        attr_accessor :j0208index2
        alias_method :attr_j0208index2, :j0208index2
        undef_method :j0208index2
        alias_method :attr_j0208index2=, :j0208index2=
        undef_method :j0208index2=
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          @jis0201 = nil
          @jis0208 = nil
          @j0208index1 = nil
          @j0208index2 = nil
          super(cs)
          @jis0201 = self.class::JIS_X_0201::Encoder.new(cs)
          @jis0208 = self.class::JIS_X_0208_Solaris_Encoder.new(cs)
          @j0208index1 = @jis0208.get_index1
          @j0208index2 = @jis0208.get_index2
        end
        
        typesig { [::Java::Char] }
        def encode_double(ch)
          result = 0
          # PCK uses JIS_X_0208:1983 rather than JIS_X_0208:1997
          case (ch)
          when Character.new(0x2015)
            return (0x815c).to_int
          when Character.new(0x2014)
            return 0
          else
          end
          if (!((result = super(ch))).equal?(0))
            return result
          else
            offset = @j0208index1[ch >> 8] << 8
            pos = @j0208index2[offset >> 12].char_at((offset & 0xfff) + (ch & 0xff))
            if (!(pos).equal?(0))
              c1 = (pos >> 8) & 0xff
              c2 = pos & 0xff
              row_offset = c1 < 0x5f ? 0x70 : 0xb0
              cell_offset = ((c1 % 2).equal?(1)) ? (c2 > 0x5f ? 0x20 : 0x1f) : 0x7e
              result = ((((c1 + 1) >> 1) + row_offset) << 8) | (c2 + cell_offset)
            end
          end
          return result
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__pck, :initialize
  end
  
end
