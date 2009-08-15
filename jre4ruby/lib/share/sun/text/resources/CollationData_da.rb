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
  module CollationData_daImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_da < CollationData_daImports.const_get :ListResourceBundle
    include_class_members CollationData_daImports
    
    typesig { [] }
    def get_contents
      # A; A-acute; A-grave; A-circ, a; a-acute, a-grave, a-circ
      # c-cedill
      # eth(icelandic), d-stroke (sami); they looks identically
      # E; E-acute; E-grave; E-circ; E-diaeresis, e-acute, e-grave; e-circ; e-diaeresis
      # i-acute
      # o-acute, o-circ
      # y-acute, u-diaeresis
      # ae-ligature and variants
      # ae-ligature
      # ae-acute
      # a-diaeresis
      # o-stroke and variant
      # o-slash
      # o-slash-acute
      # ; o-diaeresis
      # nt :  o-double-acute
      # a-ring and variants
      # a-ring
      # a-ring-acute
      # after a-ring
      # s-zet
      # thorn
      # oe-ligature
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", ("& A;".to_u << 0x00C1 << ";".to_u << 0x00C0 << ";".to_u << 0x00C2 << ",a;".to_u << 0x00E1 << ";".to_u << 0x00E0 << ";".to_u << 0x00E2 << "") + "<B,b" + ("<C;".to_u << 0x00c7 << ",c;".to_u << 0x00e7 << "") + ("<D;".to_u << 0x00D0 << ";".to_u << 0x0110 << ",d;".to_u << 0x00F0 << ";".to_u << 0x0111 << "") + ("<E;".to_u << 0x00C9 << ";".to_u << 0x00C8 << ";".to_u << 0x00CA << ";".to_u << 0x00CB << ",e;".to_u << 0x00E9 << ";".to_u << 0x00E8 << ";".to_u << 0x00EA << ";".to_u << 0x00EB << "") + "<F,f <G,g <H,h" + ("<I;".to_u << 0x00CD << ",i;".to_u << 0x00ED << "") + "<J,j <K,k <L,l <M,m <N,n" + ("<O;".to_u << 0x00D3 << ";".to_u << 0x00d4 << ",o;".to_u << 0x00F3 << ";".to_u << 0x00f4 << "") + "<P,p <Q,q <R,r <S,s <T,t" + "<U,u <V,v <W,w <X,x" + ("<Y;".to_u << 0x00DD << ";U".to_u << 0x0308 << ",y;".to_u << 0x00FD << ";u".to_u << 0x0308 << "") + "<Z,z" + ("<".to_u << 0x00c6 << ",".to_u << 0x00e6 << "") + (";".to_u << 0x00c6 << "".to_u << 0x0301 << ",".to_u << 0x00e6 << "".to_u << 0x0301 << "") + (";A".to_u << 0x0308 << ",a".to_u << 0x0308 << " ") + ("<".to_u << 0x00d8 << ",".to_u << 0x00f8 << " ") + (";".to_u << 0x00d8 << "".to_u << 0x0301 << ",".to_u << 0x00f8 << "".to_u << 0x0301 << "") + (";O".to_u << 0x0308 << ",o".to_u << 0x0308 << " ") + (";O".to_u << 0x030b << ",o".to_u << 0x030b << "") + ("< ".to_u << 0x00c5 << " , ".to_u << 0x00e5 << "") + (";".to_u << 0x00c5 << "".to_u << 0x0301 << ",".to_u << 0x00e5 << "".to_u << 0x0301 << "") + ", AA , Aa , aA , aa " + ("& ss;".to_u << 0x00DF << "") + ("& th, ".to_u << 0x00FE << " & th, ".to_u << 0x00DE << " ") + ("& oe, ".to_u << 0x0153 << " & oe, ".to_u << 0x0152 << " ")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_da, :initialize
  end
  
end
