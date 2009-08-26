require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Sun::Text::Resources
  module CollationData_lvImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_lv < CollationData_lvImports.const_get :ListResourceBundle
    include_class_members CollationData_lvImports
    
    typesig { [] }
    def get_contents
      # for lv, accents sorted backwards plus the following:
      # sort accents bkwd
      # C < c-caron
      # G < g-cedilla
      # tal : i < y
      # K < k-cedilla
      # L < l-cedilla
      # N < n-cedilla
      # S < s-caron
      # Z < z-caron
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", "@" + ("& C < c".to_u << 0x030c << " , C".to_u << 0x030c << " ") + ("& G < g".to_u << 0x0327 << " , G".to_u << 0x0327 << " ") + "& I < y, Y" + ("& K < k".to_u << 0x0327 << " , K".to_u << 0x0327 << " ") + ("& L < l".to_u << 0x0327 << " , L".to_u << 0x0327 << " ") + ("& N < n".to_u << 0x0327 << " , N".to_u << 0x0327 << " ") + ("& S < s".to_u << 0x030c << " , S".to_u << 0x030c << " ") + ("& Z < z".to_u << 0x030c << " , Z".to_u << 0x030c << " ")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_lv, :initialize
  end
  
end