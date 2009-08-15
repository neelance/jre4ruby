require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module UTF_32BE_BOMImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
    }
  end
  
  class UTF_32BE_BOM < UTF_32BE_BOMImports.const_get :Unicode
    include_class_members UTF_32BE_BOMImports
    
    typesig { [] }
    def initialize
      super("X-UTF-32BE-BOM", StandardCharsets.attr_aliases_utf_32be_bom)
    end
    
    typesig { [] }
    def historical_name
      return "X-UTF-32BE-BOM"
    end
    
    typesig { [] }
    def new_decoder
      return UTF_32Coder::Decoder.new(self, UTF_32Coder::BIG)
    end
    
    typesig { [] }
    def new_encoder
      return UTF_32Coder::Encoder.new(self, UTF_32Coder::BIG, true)
    end
    
    private
    alias_method :initialize__utf_32be_bom, :initialize
  end
  
end
