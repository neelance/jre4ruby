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
module Sun::Nio::Cs::Ext
  module MS50221Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
    }
  end
  
  class MS50221 < MS50221Imports.const_get :ISO2022_JP
    include_class_members MS50221Imports
    
    typesig { [] }
    def initialize
      super("x-windows-50221", ExtendedCharsets.aliases_for("x-windows-50221"))
    end
    
    typesig { [] }
    def historical_name
      return "MS50221"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return super(cs) || (cs.is_a?(JIS_X_0212)) || (cs.is_a?(MS50221))
    end
    
    typesig { [] }
    def get_dec_index1
      return JIS_X_0208_MS5022X_Decoder.attr_index1
    end
    
    typesig { [] }
    def get_dec_index2
      return JIS_X_0208_MS5022X_Decoder.attr_index2
    end
    
    typesig { [] }
    def get0212_decoder
      return JIS_X_0212_MS5022X_Decoder.new(self)
    end
    
    typesig { [] }
    def get_enc_index1
      return JIS_X_0208_MS5022X_Encoder.attr_index1
    end
    
    typesig { [] }
    def get_enc_index2
      return JIS_X_0208_MS5022X_Encoder.attr_index2
    end
    
    typesig { [] }
    def get0212_encoder
      return JIS_X_0212_MS5022X_Encoder.new(self)
    end
    
    typesig { [] }
    def do_sbkana
      return true
    end
    
    private
    alias_method :initialize__ms50221, :initialize
  end
  
end
