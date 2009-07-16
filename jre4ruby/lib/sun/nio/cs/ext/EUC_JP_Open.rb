require "rjava"

# 
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
  module EUC_JP_OpenImports
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
      include_const ::Sun::Nio::Cs, :Surrogate
    }
  end
  
  class EUC_JP_Open < EUC_JP_OpenImports.const_get :Charset
    include_class_members EUC_JP_OpenImports
    include HistoricallyNamedCharset
    
    typesig { [] }
    def initialize
      super("x-eucJP-Open", ExtendedCharsets.aliases_for("x-eucJP-Open"))
    end
    
    typesig { [] }
    def historical_name
      return "EUC_JP_Solaris"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(JIS_X_0201)) || (cs.is_a?(EUC_JP)))
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
      const_set_lazy(:Decoder) { Class.new(EUC_JP::Decoder) do
        include_class_members EUC_JP_Open
        
        attr_accessor :decoder_j0201
        alias_method :attr_decoder_j0201, :decoder_j0201
        undef_method :decoder_j0201
        alias_method :attr_decoder_j0201=, :decoder_j0201=
        undef_method :decoder_j0201=
        
        attr_accessor :decode_mapping_j0212
        alias_method :attr_decode_mapping_j0212, :decode_mapping_j0212
        undef_method :decode_mapping_j0212
        alias_method :attr_decode_mapping_j0212=, :decode_mapping_j0212=
        undef_method :decode_mapping_j0212=
        
        attr_accessor :decode_mapping_j0208
        alias_method :attr_decode_mapping_j0208, :decode_mapping_j0208
        undef_method :decode_mapping_j0208
        alias_method :attr_decode_mapping_j0208=, :decode_mapping_j0208=
        undef_method :decode_mapping_j0208=
        
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
        
        attr_accessor :replace_char
        alias_method :attr_replace_char, :replace_char
        undef_method :replace_char
        alias_method :attr_replace_char=, :replace_char=
        undef_method :replace_char=
        
        typesig { [Charset] }
        def initialize(cs)
          @decoder_j0201 = nil
          @decode_mapping_j0212 = nil
          @decode_mapping_j0208 = nil
          @j0208index1 = nil
          @j0208index2 = nil
          @replace_char = 0
          super(cs)
          @replace_char = Character.new(0xFFFD)
          @decoder_j0201 = JIS_X_0201::Decoder.new(cs)
          @decode_mapping_j0212 = JIS_X_0212_Solaris_Decoder.new(cs)
          @decode_mapping_j0208 = JIS_X_0208_Solaris_Decoder.new(cs)
          @decode_mapping_j0208.attr_start = 0xa1
          @decode_mapping_j0208.attr_end = 0xfe
          @j0208index1 = @decode_mapping_j0208.get_index1
          @j0208index2 = @decode_mapping_j0208.get_index2
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode0212(byte1, byte2)
          return @decode_mapping_j0212.decode_double(byte1, byte2)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode_double(byte1, byte2)
          if ((byte1).equal?(0x8e))
            return @decoder_j0201.decode(byte2 - 256)
          end
          if (((byte1 < 0) || (byte1 > @decode_mapping_j0208.get_index1.attr_length)) || ((byte2 < @decode_mapping_j0208.attr_start) || (byte2 > @decode_mapping_j0208.attr_end)))
            return @replace_char
          end
          result = super(byte1, byte2)
          if (!(result).equal?(Character.new(0xFFFD)))
            return result
          else
            n = (@j0208index1[byte1 - 0x80] & 0xf) * (@decode_mapping_j0208.attr_end - @decode_mapping_j0208.attr_start + 1) + (byte2 - @decode_mapping_j0208.attr_start)
            return @j0208index2[@j0208index1[byte1 - 0x80] >> 4].char_at(n)
          end
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(EUC_JP::Encoder) do
        include_class_members EUC_JP_Open
        
        attr_accessor :encoder_j0201
        alias_method :attr_encoder_j0201, :encoder_j0201
        undef_method :encoder_j0201
        alias_method :attr_encoder_j0201=, :encoder_j0201=
        undef_method :encoder_j0201=
        
        attr_accessor :encoder_j0212
        alias_method :attr_encoder_j0212, :encoder_j0212
        undef_method :encoder_j0212
        alias_method :attr_encoder_j0212=, :encoder_j0212=
        undef_method :encoder_j0212=
        
        attr_accessor :encoder_j0208
        alias_method :attr_encoder_j0208, :encoder_j0208
        undef_method :encoder_j0208
        alias_method :attr_encoder_j0208=, :encoder_j0208=
        undef_method :encoder_j0208=
        
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
        
        attr_accessor :sgp
        alias_method :attr_sgp, :sgp
        undef_method :sgp
        alias_method :attr_sgp=, :sgp=
        undef_method :sgp=
        
        typesig { [Charset] }
        def initialize(cs)
          @encoder_j0201 = nil
          @encoder_j0212 = nil
          @encoder_j0208 = nil
          @j0208index1 = nil
          @j0208index2 = nil
          @sgp = nil
          super(cs)
          @sgp = Surrogate::Parser.new
          @encoder_j0201 = JIS_X_0201::Encoder.new(cs)
          @encoder_j0212 = JIS_X_0212_Solaris_Encoder.new(cs)
          @encoder_j0208 = JIS_X_0208_Solaris_Encoder.new(cs)
          @j0208index1 = @encoder_j0208.get_index1
          @j0208index2 = @encoder_j0208.get_index2
        end
        
        typesig { [::Java::Char, Array.typed(::Java::Byte)] }
        def encode_single(input_char, output_byte)
          b = 0
          if ((input_char).equal?(0))
            output_byte[0] = 0
            return 1
          end
          if (((b = @encoder_j0201.encode(input_char))).equal?(0))
            return 0
          end
          if (b > 0 && b < 128)
            output_byte[0] = b
            return 1
          end
          output_byte[0] = 0x8e
          output_byte[1] = b
          return 2
        end
        
        typesig { [::Java::Char] }
        def encode_double(ch)
          r = super(ch)
          if (!(r).equal?(0))
            return r
          else
            offset = @j0208index1[((ch & 0xff00) >> 8)] << 8
            r = @j0208index2[offset >> 12].char_at((offset & 0xfff) + (ch & 0xff))
            if (r > 0x7500)
              return 0x8f8080 + @encoder_j0212.encode_double(ch)
            end
          end
          return ((r).equal?(0) ? 0 : r + 0x8080)
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__euc_jp_open, :initialize
  end
  
end
