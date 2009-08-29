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
  module MS932Imports #:nodoc:
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
  
  class MS932 < MS932Imports.const_get :Charset
    include_class_members MS932Imports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("windows-31j", ExtendedCharsets.aliases_for("windows-31j"))
    end
    
    typesig { [] }
    def historical_name
      return "MS932"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(JIS_X_0201)) || (cs.is_a?(MS932)))
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
      const_set_lazy(:Decoder) { Class.new(MS932DB::Decoder) do
        include_class_members MS932
        overload_protected {
          include DelegatableDecoder
        }
        
        attr_accessor :jis_dec0201
        alias_method :attr_jis_dec0201, :jis_dec0201
        undef_method :jis_dec0201
        alias_method :attr_jis_dec0201=, :jis_dec0201=
        undef_method :jis_dec0201=
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          @jis_dec0201 = nil
          super(cs)
          @jis_dec0201 = self.class::JIS_X_0201::Decoder.new(cs)
        end
        
        typesig { [::Java::Int] }
        def decode_single(b)
          # If the high bits are all off, it's ASCII == Unicode
          if (((b & 0xff80)).equal?(0))
            return RJava.cast_to_char(b)
          end
          return @jis_dec0201.decode(b)
        end
        
        typesig { [class_self::ByteBuffer, class_self::CharBuffer] }
        # Make some protected methods public for use by JISAutoDetect
        def decode_loop(src, dst)
          return super(src, dst)
        end
        
        typesig { [] }
        def impl_reset
          super
        end
        
        typesig { [class_self::CharBuffer] }
        def impl_flush(out)
          return super(out)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(MS932DB::Encoder) do
        include_class_members MS932
        
        attr_accessor :jis_enc0201
        alias_method :attr_jis_enc0201, :jis_enc0201
        undef_method :jis_enc0201
        alias_method :attr_jis_enc0201=, :jis_enc0201=
        undef_method :jis_enc0201=
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          @jis_enc0201 = nil
          super(cs)
          @jis_enc0201 = self.class::JIS_X_0201::Encoder.new(cs)
        end
        
        typesig { [::Java::Char] }
        def encode_single(input_char)
          b = 0
          # \u0000 - \u007F map straight through
          if (((input_char & 0xff80)).equal?(0))
            return (input_char)
          end
          if (((b = @jis_enc0201.encode(input_char))).equal?(0))
            return -1
          else
            return b
          end
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__ms932, :initialize
  end
  
end
