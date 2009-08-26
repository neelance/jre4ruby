require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SJISImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class SJIS < SJISImports.const_get :Charset
    include_class_members SJISImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("Shift_JIS", ExtendedCharsets.aliases_for("Shift_JIS"))
    end
    
    typesig { [] }
    def historical_name
      return "SJIS"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(JIS_X_0201)) || (cs.is_a?(SJIS)) || (cs.is_a?(JIS_X_0208)))
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
      const_set_lazy(:Decoder) { Class.new(JIS_X_0208_Decoder) do
        include_class_members SJIS
        overload_protected {
          include DelegatableDecoder
        }
        
        attr_accessor :jis0201
        alias_method :attr_jis0201, :jis0201
        undef_method :jis0201
        alias_method :attr_jis0201=, :jis0201=
        undef_method :jis0201=
        
        typesig { [self::Charset] }
        def initialize(cs)
          @jis0201 = nil
          super(cs)
          @jis0201 = self.class::JIS_X_0201::Decoder.new(cs)
        end
        
        typesig { [::Java::Int] }
        def decode_single(b)
          # If the high bits are all off, it's ASCII == Unicode
          if (((b & 0xff80)).equal?(0))
            return RJava.cast_to_char(b)
          end
          return @jis0201.decode(b)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode_double(c1, c2)
          adjust = c2 < 0x9f ? 1 : 0
          row_offset = c1 < 0xa0 ? 0x70 : 0xb0
          cell_offset = ((adjust).equal?(1)) ? (c2 > 0x7f ? 0x20 : 0x1f) : 0x7e
          b1 = ((c1 - row_offset) << 1) - adjust
          b2 = c2 - cell_offset
          return super(b1, b2)
        end
        
        typesig { [self::ByteBuffer, self::CharBuffer] }
        # Make some protected methods public for use by JISAutoDetect
        def decode_loop(src, dst)
          return super(src, dst)
        end
        
        typesig { [] }
        def impl_reset
          super
        end
        
        typesig { [self::CharBuffer] }
        def impl_flush(out)
          return super(out)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(JIS_X_0208_Encoder) do
        include_class_members SJIS
        
        attr_accessor :jis0201
        alias_method :attr_jis0201, :jis0201
        undef_method :jis0201
        alias_method :attr_jis0201=, :jis0201=
        undef_method :jis0201=
        
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
        
        typesig { [self::Charset] }
        def initialize(cs)
          @jis0201 = nil
          @j0208index1 = nil
          @j0208index2 = nil
          super(cs)
          @jis0201 = self.class::JIS_X_0201::Encoder.new(cs)
          @j0208index1 = JIS_X_0208_Encoder.instance_method(:get_index1).bind(self).call
          @j0208index2 = JIS_X_0208_Encoder.instance_method(:get_index2).bind(self).call
        end
        
        typesig { [::Java::Char] }
        def encode_single(input_char)
          b = 0
          # \u0000 - \u007F map straight through
          if (((input_char & 0xff80)).equal?(0))
            return input_char
          end
          if (((b = @jis0201.encode(input_char))).equal?(0))
            return -1
          else
            return b
          end
        end
        
        typesig { [::Java::Char] }
        def encode_double(ch)
          offset = @j0208index1[ch >> 8] << 8
          pos = @j0208index2[offset >> 12].char_at((offset & 0xfff) + (ch & 0xff))
          if ((pos).equal?(0))
            # Zero value indicates this Unicode has no mapping to
            # JIS0208.
            # We bail here because the JIS -> SJIS algorithm produces
            # bogus SJIS values for invalid JIS input.  Zero should be
            # the only invalid JIS value in our table.
            return 0
          end
          # This algorithm for converting from JIS to SJIS comes from
          # Ken Lunde's "Understanding Japanese Information Processing",
          # pg 163.
          c1 = (pos >> 8) & 0xff
          c2 = pos & 0xff
          row_offset = c1 < 0x5f ? 0x70 : 0xb0
          cell_offset = ((c1 % 2).equal?(1)) ? (c2 > 0x5f ? 0x20 : 0x1f) : 0x7e
          return ((((c1 + 1) >> 1) + row_offset) << 8) | (c2 + cell_offset)
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__sjis, :initialize
  end
  
end
