require "rjava"

# Copyright 2002-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MS950_HKSCSImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class MS950_HKSCS < MS950_HKSCSImports.const_get :Charset
    include_class_members MS950_HKSCSImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("x-MS950-HKSCS", ExtendedCharsets.aliases_for("x-MS950-HKSCS"))
    end
    
    typesig { [] }
    def historical_name
      return "MS950_HKSCS"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(MS950)) || (cs.is_a?(MS950_HKSCS)))
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
      const_set_lazy(:Decoder) { Class.new(HKSCS::Decoder) do
        include_class_members MS950_HKSCS
        
        attr_accessor :ms950dec
        alias_method :attr_ms950dec, :ms950dec
        undef_method :ms950dec
        alias_method :attr_ms950dec=, :ms950dec=
        undef_method :ms950dec=
        
        typesig { [::Java::Int, ::Java::Int] }
        # Note current decoder decodes 0x8BC2 --> U+F53A
        # ie. maps to Unicode PUA.
        # Unaccounted discrepancy between this mapping
        # inferred from MS950/windows-950 and the published
        # MS HKSCS mappings which maps 0x8BC2 --> U+5C22
        # a character defined with the Unified CJK block
        def decode_double(byte1, byte2)
          c = super(byte1, byte2)
          return (!(c).equal?(REPLACE_CHAR)) ? c : @ms950dec.decode_double(byte1, byte2)
        end
        
        typesig { [Charset] }
        def initialize(cs)
          @ms950dec = nil
          super(cs)
          @ms950dec = MS950::Decoder.new(cs)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(HKSCS::Encoder) do
        include_class_members MS950_HKSCS
        
        attr_accessor :ms950enc
        alias_method :attr_ms950enc, :ms950enc
        undef_method :ms950enc
        alias_method :attr_ms950enc=, :ms950enc=
        undef_method :ms950enc=
        
        typesig { [::Java::Char] }
        # Note current encoder encodes U+F53A --> 0x8BC2
        # Published MS HKSCS mappings show
        # U+5C22 <--> 0x8BC2
        def encode_double(ch)
          r = super(ch)
          return (!(r).equal?(0)) ? r : @ms950enc.encode_double(ch)
        end
        
        typesig { [Charset] }
        def initialize(cs)
          @ms950enc = nil
          super(cs)
          @ms950enc = MS950::Encoder.new(cs)
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__ms950_hkscs, :initialize
  end
  
end
