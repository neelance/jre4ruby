require "rjava"

# 
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
  module Big5_HKSCSImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class Big5_HKSCS < Big5_HKSCSImports.const_get :Charset
    include_class_members Big5_HKSCSImports
    include HistoricallyNamedCharset
    
    typesig { [] }
    def initialize
      super("Big5-HKSCS", ExtendedCharsets.aliases_for("Big5-HKSCS"))
    end
    
    typesig { [] }
    def historical_name
      return "Big5_HKSCS"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(Big5)) || (cs.is_a?(Big5_HKSCS)))
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
      const_set_lazy(:Decoder) { Class.new(HKSCS_2001::Decoder) do
        include_class_members Big5_HKSCS
        
        attr_accessor :big5dec
        alias_method :attr_big5dec, :big5dec
        undef_method :big5dec
        alias_method :attr_big5dec=, :big5dec=
        undef_method :big5dec=
        
        typesig { [::Java::Int, ::Java::Int] }
        def decode_double(byte1, byte2)
          c = super(byte1, byte2)
          return (!(c).equal?(REPLACE_CHAR)) ? c : @big5dec.decode_double(byte1, byte2)
        end
        
        typesig { [Charset] }
        def initialize(cs)
          @big5dec = nil
          super(cs)
          @big5dec = Big5::Decoder.new(cs)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(HKSCS_2001::Encoder) do
        include_class_members Big5_HKSCS
        
        attr_accessor :big5enc
        alias_method :attr_big5enc, :big5enc
        undef_method :big5enc
        alias_method :attr_big5enc=, :big5enc=
        undef_method :big5enc=
        
        typesig { [::Java::Char] }
        def encode_double(ch)
          r = super(ch)
          return (!(r).equal?(0)) ? r : @big5enc.encode_double(ch)
        end
        
        typesig { [Charset] }
        def initialize(cs)
          @big5enc = nil
          super(cs)
          @big5enc = Big5::Encoder.new(cs)
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__big5_hkscs, :initialize
  end
  
end
