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
  module CollationData_svImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_sv < CollationData_svImports.const_get :ListResourceBundle
    include_class_members CollationData_svImports
    
    typesig { [] }
    def get_contents
      # a-ring, aa ligaure
      # a-umlaut, a-double-acute
      # ae ligature
      # o-umlaut
      # o-double-acute < o-stroke
      # u-double-acute
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", ("& Z < a".to_u << 0x030a << " , A".to_u << 0x030a << "") + ("< a".to_u << 0x0308 << " , A".to_u << 0x0308 << " < a".to_u << 0x030b << ", A".to_u << 0x030b << " ") + ("< ".to_u << 0x00e6 << " , ".to_u << 0x00c6 << " ") + ("< o".to_u << 0x0308 << " , O".to_u << 0x0308 << " ") + ("< o".to_u << 0x030b << " , O".to_u << 0x030b << " ; ".to_u << 0x00f8 << " , ".to_u << 0x00d8 << " ") + "& V ; w , W" + ("& Y, u".to_u << 0x0308 << " , U".to_u << 0x0308 << "") + ("; u".to_u << 0x030b << ", U".to_u << 0x030b << " ")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_sv, :initialize
  end
  
end