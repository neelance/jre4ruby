require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module Big5_SolarisImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class Big5_Solaris < Big5_SolarisImports.const_get :Charset
    include_class_members Big5_SolarisImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("x-Big5-Solaris", ExtendedCharsets.aliases_for("x-Big5-Solaris"))
    end
    
    typesig { [] }
    def historical_name
      return "Big5_Solaris"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(Big5)) || (cs.is_a?(Big5_Solaris)))
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
      const_set_lazy(:Decoder) { Class.new(Big5::Decoder) do
        include_class_members Big5_Solaris
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode_double(byte1, byte2)
          c = super(byte1, byte2)
          # Big5 Solaris implementation has 7 additional mappings
          if ((c).equal?(REPLACE_CHAR))
            if ((byte1).equal?(0xf9))
              case (byte2)
              when 0xd6
                c = RJava.cast_to_char(0x7881)
              when 0xd7
                c = RJava.cast_to_char(0x92b9)
              when 0xd8
                c = RJava.cast_to_char(0x88cf)
              when 0xd9
                c = RJava.cast_to_char(0x58bb)
              when 0xda
                c = RJava.cast_to_char(0x6052)
              when 0xdb
                c = RJava.cast_to_char(0x7ca7)
              when 0xdc
                c = RJava.cast_to_char(0x5afa)
              end
            end
          end
          return c
        end
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          super(cs)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(Big5::Encoder) do
        include_class_members Big5_Solaris
        
        typesig { [::Java::Char] }
        def encode_double(ch)
          r = super(ch)
          if ((r).equal?(0))
            case (ch)
            when 0x7881
              r = 0xf9d6
            when 0x92b9
              r = 0xf9d7
            when 0x88cf
              r = 0xf9d8
            when 0x58bb
              r = 0xf9d9
            when 0x6052
              r = 0xf9da
            when 0x7ca7
              r = 0xf9db
            when 0x5afa
              r = 0xf9dc
            end
          end
          return r
        end
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          super(cs)
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__big5_solaris, :initialize
  end
  
end
