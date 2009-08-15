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
  module CollationData_hrImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_hr < CollationData_hrImports.const_get :ListResourceBundle
    include_class_members CollationData_hrImports
    
    typesig { [] }
    def get_contents
      # for hr, default sorting except for the following:
      # add dz "ligature" between d and d<stroke>.
      # add d<stroke> between d and e.
      # add lj "ligature" between l and l<stroke>.
      # add l<stroke> between l and m.
      # add nj "ligature" between n and o.
      # add z<abovedot> after z.
      # C < c-caron
      # c-acute
      # dz
      # dz ligature
      # dz-caron
      # d-stroke
      # l < lj ligature
      # n < nj ligature
      # s < s-caron
      # z < z-caron
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", ("& ".to_u << 0x200f << " = ".to_u << 0x030c << " ") + ("& ".to_u << 0x0306 << " = ".to_u << 0x030d << " ") + ("& C < c".to_u << 0x030c << " , C".to_u << 0x030c << " ") + ("< c".to_u << 0x0301 << " , C".to_u << 0x0301 << " ") + ("& D < ".to_u << 0x01f3 << " , ".to_u << 0x01f2 << " , ".to_u << 0x01f1 << " ") + "< dz , dZ , Dz , DZ " + ("< ".to_u << 0x01c6 << " , ".to_u << 0x01c5 << " , ".to_u << 0x01c4 << " ") + ("< ".to_u << 0x0111 << " , ".to_u << 0x0110 << " ") + "& L < lj , lJ , Lj , LJ " + "& N < nj , nJ , Nj , NJ " + ("& S < s".to_u << 0x030c << " , S".to_u << 0x030c << " ") + ("& Z < z".to_u << 0x030c << " , Z".to_u << 0x030c << " ")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_hr, :initialize
  end
  
end
