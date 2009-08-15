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
  module CollationData_isImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_is < CollationData_isImports.const_get :ListResourceBundle
    include_class_members CollationData_isImports
    
    typesig { [] }
    def get_contents
      # for is, accents sorted backwards plus the following:
      # sort accents bkwd
      # assuming that in the default collation we add:
      # thorn, ae ligature, o-diaeresis, and o-slash
      # ....in this order...and ditto for the uppercase of these....
      # to be treated as characters (not accented characters) after z
      # then we don't have to add anything here. I've just added it here
      # just in case it gets overlooked.
      # nt : A < a-acute
      # nt : d < eth
      # nt : e < e-acute
      # nt : i < i-acute
      # nt : o < o-acute
      # nt : u < u-acute
      # nt : y < y-acute
      # nt : z < thron < a-e-ligature
      # nt : o-umlaut ; o-stroke
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", "@" + ("& A < a".to_u << 0x0301 << ", A".to_u << 0x0301 << " ") + ("& D < ".to_u << 0x00f0 << ", ".to_u << 0x00d0 << "") + ("& E < e".to_u << 0x0301 << ", E".to_u << 0x0301 << " ") + ("& I < i".to_u << 0x0301 << ", I".to_u << 0x0301 << " ") + ("& O < o".to_u << 0x0301 << ", O".to_u << 0x0301 << " ") + ("& U < u".to_u << 0x0301 << ", U".to_u << 0x0301 << " ") + ("& Y < y".to_u << 0x0301 << ", Y".to_u << 0x0301 << " ") + ("& Z < ".to_u << 0x00fe << ", ".to_u << 0x00de << " < ".to_u << 0x00e6 << ", ".to_u << 0x00c6 << "") + ("< o".to_u << 0x0308 << ", O".to_u << 0x0308 << " ; ".to_u << 0x00f8 << ", ".to_u << 0x00d8 << "")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_is, :initialize
  end
  
end
