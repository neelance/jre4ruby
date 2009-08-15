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
  module ISO2022_KRImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
      include_const ::Sun::Nio::Cs::Ext, :EUC_KR
    }
  end
  
  class ISO2022_KR < ISO2022_KRImports.const_get :ISO2022
    include_class_members ISO2022_KRImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    class_module.module_eval {
      
      def ksc5601_cs
        defined?(@@ksc5601_cs) ? @@ksc5601_cs : @@ksc5601_cs= nil
      end
      alias_method :attr_ksc5601_cs, :ksc5601_cs
      
      def ksc5601_cs=(value)
        @@ksc5601_cs = value
      end
      alias_method :attr_ksc5601_cs=, :ksc5601_cs=
    }
    
    typesig { [] }
    def initialize
      super("ISO-2022-KR", ExtendedCharsets.aliases_for("ISO-2022-KR"))
      self.attr_ksc5601_cs = EUC_KR.new
    end
    
    typesig { [Charset] }
    def contains(cs)
      # overlapping repertoire of EUC_KR, aka KSC5601
      return ((cs.is_a?(EUC_KR)) || ((cs.name == "US-ASCII")) || (cs.is_a?(ISO2022_KR)))
    end
    
    typesig { [] }
    def historical_name
      return "ISO2022KR"
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
      const_set_lazy(:Decoder) { Class.new(ISO2022::Decoder) do
        include_class_members ISO2022_KR
        
        typesig { [Charset] }
        def initialize(cs)
          super(cs)
          SODesig = Array.typed(Array.typed(::Java::Byte)).new([Array.typed(::Java::Byte).new([Character.new(?$.ord), Character.new(?).ord), Character.new(?C.ord)])])
          SODecoder = Array.typed(CharsetDecoder).new(1) { nil }
          begin
            SODecoder[0] = self.attr_ksc5601_cs.new_decoder
          rescue JavaException => e
          end
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(ISO2022::Encoder) do
        include_class_members ISO2022_KR
        
        typesig { [Charset] }
        def initialize(cs)
          super(cs)
          SODesig = "$)C"
          begin
            ISOEncoder = self.attr_ksc5601_cs.new_encoder
          rescue JavaException => e
          end
        end
        
        typesig { [::Java::Char] }
        def can_encode(c)
          return (ISOEncoder.can_encode(c))
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__iso2022_kr, :initialize
  end
  
end
