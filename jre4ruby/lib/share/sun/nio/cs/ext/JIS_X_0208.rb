require "rjava"

# Copyright 2002-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module JIS_X_0208Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
    }
  end
  
  class JIS_X_0208 < JIS_X_0208Imports.const_get :Charset
    include_class_members JIS_X_0208Imports
    
    typesig { [] }
    def initialize
      super("x-JIS0208", ExtendedCharsets.aliases_for("x-JIS0208"))
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (cs.is_a?(JIS_X_0208))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      return JIS_X_0208_Encoder.new(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(JIS_X_0208_Decoder) do
        include_class_members JIS_X_0208
        
        typesig { [::Java::Int] }
        def decode_single(b)
          return DoubleByteDecoder::REPLACE_CHAR
        end
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          super(cs)
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__jis_x_0208, :initialize
  end
  
end
