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
  module IBM942CImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class IBM942C < IBM942CImports.const_get :Charset
    include_class_members IBM942CImports
    include HistoricallyNamedCharset
    
    typesig { [] }
    def initialize
      super("x-IBM942C", ExtendedCharsets.aliases_for("x-IBM942C"))
    end
    
    typesig { [] }
    def historical_name
      return "Cp942C"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(IBM942C)))
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
      const_set_lazy(:Decoder) { Class.new(IBM942::Decoder) do
        include_class_members IBM942C
        
        class_module.module_eval {
          when_class_loaded do
            indexs = ""
            c = Character.new(?\0.ord)
            while c < Character.new(0x0080)
              indexs += (c).to_s
              (c += 1)
            end
            const_set :SingleByteToChar, indexs + (IBM942::Decoder.attr_single_byte_to_char.substring(indexs.length)).to_s
          end
        }
        
        typesig { [Charset] }
        def initialize(cs)
          super(cs, self.class::SingleByteToChar)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(IBM942::Encoder) do
        include_class_members IBM942C
        
        class_module.module_eval {
          const_set_lazy(:Shift) { 5 }
          const_attr_reader  :Shift
          
          when_class_loaded do
            indexs = ""
            c = Character.new(?\0.ord)
            while c < Character.new(0x0080)
              indexs += (c).to_s
              (c += 1)
            end
            const_set :Index2a, (IBM942::Encoder.attr_index2a).to_s + indexs
            o = IBM942::Encoder.attr_index2a.length + 15000
            const_set :Index1, Array.typed(::Java::Short).new(IBM942::Encoder.attr_index1.attr_length) { 0 }
            System.arraycopy(IBM942::Encoder.attr_index1, 0, self.class::Index1, 0, IBM942::Encoder.attr_index1.attr_length)
            i = 0
            while i * (1 << self.class::Shift) < 128
              self.class::Index1[i] = RJava.cast_to_short((o + i * (1 << self.class::Shift)))
              (i += 1)
            end
          end
        }
        
        typesig { [Charset] }
        def initialize(cs)
          super(cs, self.class::Index1, self.class::Index2a)
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__ibm942c, :initialize
  end
  
end
