require "rjava"

# Portions Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CollationData_iwImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_iw < CollationData_iwImports.const_get :ListResourceBundle
    include_class_members CollationData_iwImports
    
    typesig { [] }
    def get_contents
      # Points
      # Punctuations
      # Hebrew letters sort after Z's
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", ("& ".to_u << 0x0361 << " = ".to_u << 0x05c4 << " ") + ("& ".to_u << 0x030d << " = ".to_u << 0x0591 << " ") + ("; ".to_u << 0x0592 << " ") + ("; ".to_u << 0x0593 << " ") + ("; ".to_u << 0x0594 << " ") + ("; ".to_u << 0x0595 << " ") + ("; ".to_u << 0x0596 << " ") + ("; ".to_u << 0x0597 << " ") + ("; ".to_u << 0x0598 << " ") + ("; ".to_u << 0x0599 << " ") + ("& ".to_u << 0x0301 << " = ".to_u << 0x059a << " ") + ("& ".to_u << 0x0300 << " = ".to_u << 0x059b << " ") + ("& ".to_u << 0x0307 << " = ".to_u << 0x059c << " ; ".to_u << 0x059d << " ") + ("& ".to_u << 0x0302 << " = ".to_u << 0x059e << " ") + ("& ".to_u << 0x0308 << " = ".to_u << 0x059f << " ") + ("& ".to_u << 0x030c << " = ".to_u << 0x05a0 << " ") + ("& ".to_u << 0x0306 << " = ".to_u << 0x05a1 << " ") + ("& ".to_u << 0x0304 << " = ".to_u << 0x05a3 << " ; ".to_u << 0x05a4 << " ") + ("& ".to_u << 0x0303 << " = ".to_u << 0x05a5 << " ") + ("& ".to_u << 0x030a << " = ".to_u << 0x05a6 << " ") + ("& ".to_u << 0x0328 << " = ".to_u << 0x05a7 << " ") + ("& ".to_u << 0x0327 << " = ".to_u << 0x05a8 << " ") + ("& ".to_u << 0x030b << " = ".to_u << 0x05a9 << " ") + ("& ".to_u << 0x0336 << " = ".to_u << 0x05aa << " ") + ("& ".to_u << 0x0337 << " = ".to_u << 0x05ab << " ") + ("& ".to_u << 0x0338 << " = ".to_u << 0x05ac << " ; ".to_u << 0x05ad << " ; ".to_u << 0x05ae << " ") + ("; ".to_u << 0x05af << " ") + ("; ".to_u << 0x05b0 << " ") + ("; ".to_u << 0x05b1 << " ") + ("; ".to_u << 0x05b2 << " ") + ("; ".to_u << 0x05b3 << " ") + ("; ".to_u << 0x05b4 << " ") + ("; ".to_u << 0x05b5 << " ") + ("; ".to_u << 0x05b6 << " ") + ("; ".to_u << 0x05b7 << " ") + ("; ".to_u << 0x05b8 << " ") + ("; ".to_u << 0x05b9 << " ") + ("; ".to_u << 0x05bb << " ") + ("; ".to_u << 0x05bc << " ") + ("; ".to_u << 0x05bd << " ") + ("; ".to_u << 0x05bf << " ") + ("; ".to_u << 0x05c0 << " ") + ("; ".to_u << 0x05c1 << " ") + ("; ".to_u << 0x05c2 << " ") + ("& ".to_u << 0x00b5 << " < ".to_u << 0x05be << " ") + ("< ".to_u << 0x05c3 << " ") + ("< ".to_u << 0x05f3 << " ") + ("< ".to_u << 0x05f4 << " ") + ("& Z < ".to_u << 0x05d0 << " ") + ("< ".to_u << 0x05d1 << " ") + ("< ".to_u << 0x05d2 << " ") + ("< ".to_u << 0x05d3 << " ") + ("< ".to_u << 0x05d4 << " ") + ("< ".to_u << 0x05d5 << " ") + ("< ".to_u << 0x05f0 << " ") + ("< ".to_u << 0x05f1 << " ") + ("< ".to_u << 0x05d6 << " ") + ("< ".to_u << 0x05d7 << " ") + ("< ".to_u << 0x05d8 << " ") + ("< ".to_u << 0x05d9 << " ") + ("< ".to_u << 0x05f2 << " ") + ("< ".to_u << 0x05da << " , ".to_u << 0x05db << " ") + ("< ".to_u << 0x05dc << " ") + ("< ".to_u << 0x05dd << " , ".to_u << 0x05de << " ") + ("< ".to_u << 0x05df << " , ".to_u << 0x05e0 << " ") + ("< ".to_u << 0x05e1 << " ") + ("< ".to_u << 0x05e2 << " ") + ("< ".to_u << 0x05e3 << " , ".to_u << 0x05e4 << " ") + ("< ".to_u << 0x05e5 << " , ".to_u << 0x05e6 << " ") + ("< ".to_u << 0x05e7 << " ") + ("< ".to_u << 0x05e8 << " ") + ("< ".to_u << 0x05e9 << " ") + ("< ".to_u << 0x05ea << " ")]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_iw, :initialize
  end
  
end
