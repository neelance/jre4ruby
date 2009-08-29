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
  module ISO2022_CN_CNSImports #:nodoc:
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
    }
  end
  
  class ISO2022_CN_CNS < ISO2022_CN_CNSImports.const_get :ISO2022
    include_class_members ISO2022_CN_CNSImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("x-ISO-2022-CN-CNS", ExtendedCharsets.aliases_for("x-ISO-2022-CN-CNS"))
    end
    
    typesig { [Charset] }
    def contains(cs)
      # overlapping repertoire of EUC_TW, CNS11643
      return ((cs.is_a?(EUC_TW)) || ((cs.name == "US-ASCII")) || (cs.is_a?(ISO2022_CN_CNS)))
    end
    
    typesig { [] }
    def historical_name
      return "ISO2022CN_CNS"
    end
    
    typesig { [] }
    def new_decoder
      return ISO2022_CN::Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      return Encoder.new(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:Encoder) { Class.new(ISO2022::Encoder) do
        include_class_members ISO2022_CN_CNS
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          super(cs)
          SODesig = "$)G"
          SS2Desig = "$*H"
          SS3Desig = "$+I"
          begin
            cset = Charset.for_name("EUC_TW") # CNS11643
            ISOEncoder = cset.new_encoder
          rescue self.class::JavaException => e
          end
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        # Since ISO2022-CN-CNS possesses a CharsetEncoder
        # without the corresponding CharsetDecoder half the
        # default replacement check needs to be overridden
        # since the parent class version attempts to
        # decode 0x3f (?).
        def is_legal_replacement(repl)
          # 0x3f is OK as the replacement byte
          return ((repl.attr_length).equal?(1) && (repl[0]).equal?(0x3f))
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__iso2022_cn_cns, :initialize
  end
  
end
