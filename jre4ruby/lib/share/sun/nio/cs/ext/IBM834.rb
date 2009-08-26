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
  module IBM834Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
    }
  end
  
  # EBCDIC DBCS-only Korean
  class IBM834 < IBM834Imports.const_get :Charset
    include_class_members IBM834Imports
    
    typesig { [] }
    def initialize
      super("x-IBM834", ExtendedCharsets.aliases_for("x-IBM834"))
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (cs.is_a?(IBM834))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      return Encoder.new(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(DBCS_ONLY_IBM_EBCDIC_Decoder) do
        include_class_members IBM834
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          super(cs)
          @mask1 = 0xfff0
          @mask2 = 0xf
          @shift = 4
          @index1 = IBM933.get_decoder_index1
          @index2 = IBM933.get_decoder_index2
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(IBM933::Encoder) do
        include_class_members IBM834
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          super(cs, Array.typed(::Java::Byte).new([0xfe, 0xfe]), false)
        end
        
        typesig { [class_self::ByteBuffer] }
        def impl_flush(out)
          impl_reset
          return CoderResult::UNDERFLOW
        end
        
        typesig { [::Java::Char] }
        def encode_hangul(ch)
          bytes = super(ch)
          if ((bytes.attr_length).equal?(0))
            # Cp834 has 6 additional non-roundtrip char->bytes
            # mappings, see#6379808
            if ((ch).equal?(Character.new(0x00b7)))
              return Array.typed(::Java::Byte).new([0x41, 0x43])
            else
              if ((ch).equal?(Character.new(0x00ad)))
                return Array.typed(::Java::Byte).new([0x41, 0x48])
              else
                if ((ch).equal?(Character.new(0x2015)))
                  return Array.typed(::Java::Byte).new([0x41, 0x49])
                else
                  if ((ch).equal?(Character.new(0x223c)))
                    return Array.typed(::Java::Byte).new([0x42, 0xa1])
                  else
                    if ((ch).equal?(Character.new(0xff5e)))
                      return Array.typed(::Java::Byte).new([0x49, 0x54])
                    else
                      if ((ch).equal?(Character.new(0x2299)))
                        return Array.typed(::Java::Byte).new([0x49, 0x6f])
                      end
                    end
                  end
                end
              end
            end
          else
            if ((bytes[0]).equal?(0))
              return EMPTYBA
            end
          end
          return bytes
        end
        
        typesig { [::Java::Char] }
        def can_encode(ch)
          return !(encode_hangul(ch).attr_length).equal?(0)
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def is_legal_replacement(repl)
          if ((repl.attr_length).equal?(2) && (repl[0]).equal?(0xfe) && (repl[1]).equal?(0xfe))
            return true
          end
          return super(repl)
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__ibm834, :initialize
  end
  
end
