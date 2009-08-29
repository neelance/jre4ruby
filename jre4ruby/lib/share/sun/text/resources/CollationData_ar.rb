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
  module CollationData_arImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_ar < CollationData_arImports.const_get :ListResourceBundle
    include_class_members CollationData_arImports
    
    typesig { [] }
    def get_contents
      # for ar, the following additions are needed:
      # Numerics
      # 0
      # 1
      # 2
      # 3
      # 4
      # 5
      # 6
      # 7
      # 8
      # 9
      # Punctuations
      # retroflex click < arabic comma
      # ar semicolon
      # ar question mark
      # ar percent sign
      # ar decimal separator
      # ar thousand separator
      # ar full stop
      # Arabic script sorts after Z's
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", ("& ".to_u << 0x0361 << " = ".to_u << 0x0640 << "") + ("= ".to_u << 0x064b << "") + ("= ".to_u << 0x064c << "") + ("= ".to_u << 0x064d << "") + ("= ".to_u << 0x064e << "") + ("= ".to_u << 0x064f << "") + ("= ".to_u << 0x0650 << "") + ("= ".to_u << 0x0652 << "") + ("= ".to_u << 0x066d << "") + ("= ".to_u << 0x06d6 << "") + ("= ".to_u << 0x06d7 << "") + ("= ".to_u << 0x06d8 << "") + ("= ".to_u << 0x06d9 << "") + ("= ".to_u << 0x06da << "") + ("= ".to_u << 0x06db << "") + ("= ".to_u << 0x06dc << "") + ("= ".to_u << 0x06dd << "") + ("= ".to_u << 0x06de << "") + ("= ".to_u << 0x06df << "") + ("= ".to_u << 0x06e0 << "") + ("= ".to_u << 0x06e1 << "") + ("= ".to_u << 0x06e2 << "") + ("= ".to_u << 0x06e3 << "") + ("= ".to_u << 0x06e4 << "") + ("= ".to_u << 0x06e5 << "") + ("= ".to_u << 0x06e6 << "") + ("= ".to_u << 0x06e7 << "") + ("= ".to_u << 0x06e8 << "") + ("= ".to_u << 0x06e9 << "") + ("= ".to_u << 0x06ea << "") + ("= ".to_u << 0x06eb << "") + ("= ".to_u << 0x06ec << "") + ("= ".to_u << 0x06ed << "") + ("& 0 < ".to_u << 0x0660 << " < ".to_u << 0x06f0 << "") + ("& 1 < ".to_u << 0x0661 << " < ".to_u << 0x06f1 << "") + ("& 2 < ".to_u << 0x0662 << " < ".to_u << 0x06f2 << "") + ("& 3 < ".to_u << 0x0663 << " < ".to_u << 0x06f3 << "") + ("& 4 < ".to_u << 0x0664 << " < ".to_u << 0x06f4 << "") + ("& 5 < ".to_u << 0x0665 << " < ".to_u << 0x06f5 << "") + ("& 6 < ".to_u << 0x0666 << " < ".to_u << 0x06f6 << "") + ("& 7 < ".to_u << 0x0667 << " < ".to_u << 0x06f7 << "") + ("& 8 < ".to_u << 0x0668 << " < ".to_u << 0x06f8 << "") + ("& 9 < ".to_u << 0x0669 << " < ".to_u << 0x06f9 << "") + ("& ".to_u << 0x00b5 << " < ".to_u << 0x060c << "") + ("< ".to_u << 0x061b << "") + ("< ".to_u << 0x061f << "") + ("< ".to_u << 0x066a << "") + ("< ".to_u << 0x066b << "") + ("< ".to_u << 0x066c << "") + ("< ".to_u << 0x06d4 << "") + ("&  Z <  ".to_u << 0x0621 << "") + ("; ".to_u << 0x0622 << "") + ("; ".to_u << 0x0623 << "") + ("; ".to_u << 0x0624 << "") + ("; ".to_u << 0x0625 << "") + ("; ".to_u << 0x0626 << "") + ("< ".to_u << 0x0627 << "") + ("< ".to_u << 0x0628 << "") + ("< ".to_u << 0x067e << "") + ("< ".to_u << 0x0629 << "") + ("= ".to_u << 0x062a << "") + ("< ".to_u << 0x062b << "") + ("< ".to_u << 0x062c << "") + ("< ".to_u << 0x0686 << "") + ("< ".to_u << 0x062d << "") + ("< ".to_u << 0x062e << "") + ("< ".to_u << 0x062f << "") + ("< ".to_u << 0x0630 << "") + ("< ".to_u << 0x0631 << "") + ("< ".to_u << 0x0632 << "") + ("< ".to_u << 0x0698 << "") + ("< ".to_u << 0x0633 << "") + ("< ".to_u << 0x0634 << "") + ("< ".to_u << 0x0635 << "") + ("< ".to_u << 0x0636 << "") + ("< ".to_u << 0x0637 << "") + ("< ".to_u << 0x0638 << "") + ("< ".to_u << 0x0639 << "") + ("< ".to_u << 0x063a << "") + ("< ".to_u << 0x0641 << "") + ("< ".to_u << 0x0642 << "") + ("< ".to_u << 0x0643 << "") + ("< ".to_u << 0x06af << "") + ("< ".to_u << 0x0644 << "") + ("< ".to_u << 0x0645 << "") + ("< ".to_u << 0x0646 << "") + ("< ".to_u << 0x0647 << "") + ("< ".to_u << 0x0648 << "") + ("< ".to_u << 0x0649 << "") + ("; ".to_u << 0x064a << "") + ("< ".to_u << 0x0670 << "") + ("< ".to_u << 0x0671 << "") + ("< ".to_u << 0x0672 << "") + ("< ".to_u << 0x0673 << "") + ("< ".to_u << 0x0674 << "") + ("< ".to_u << 0x0675 << "") + ("< ".to_u << 0x0676 << "") + ("< ".to_u << 0x0677 << "") + ("< ".to_u << 0x0678 << "") + ("< ".to_u << 0x0679 << "") + ("< ".to_u << 0x067a << "") + ("< ".to_u << 0x067b << "") + ("< ".to_u << 0x067c << "") + ("< ".to_u << 0x067d << "") + ("< ".to_u << 0x067f << "") + ("< ".to_u << 0x0680 << "") + ("< ".to_u << 0x0681 << "") + ("< ".to_u << 0x0682 << "") + ("< ".to_u << 0x0683 << "") + ("< ".to_u << 0x0684 << "") + ("< ".to_u << 0x0685 << "") + ("< ".to_u << 0x0687 << "") + ("< ".to_u << 0x0688 << "") + ("< ".to_u << 0x0689 << "") + ("< ".to_u << 0x068a << "") + ("< ".to_u << 0x068b << "") + ("< ".to_u << 0x068c << "") + ("< ".to_u << 0x068d << "") + ("< ".to_u << 0x068e << "") + ("< ".to_u << 0x068f << "") + ("< ".to_u << 0x0690 << "") + ("< ".to_u << 0x0691 << "") + ("< ".to_u << 0x0692 << "") + ("< ".to_u << 0x0693 << "") + ("< ".to_u << 0x0694 << "") + ("< ".to_u << 0x0695 << "") + ("< ".to_u << 0x0696 << "") + ("< ".to_u << 0x0697 << "") + ("< ".to_u << 0x0699 << "") + ("< ".to_u << 0x069a << "") + ("< ".to_u << 0x069b << "") + ("< ".to_u << 0x069c << "") + ("< ".to_u << 0x069d << "") + ("< ".to_u << 0x069e << "") + ("< ".to_u << 0x069f << "") + ("< ".to_u << 0x06a0 << "") + ("< ".to_u << 0x06a1 << "") + ("< ".to_u << 0x06a2 << "") + ("< ".to_u << 0x06a3 << "") + ("< ".to_u << 0x06a4 << "") + ("< ".to_u << 0x06a5 << "") + ("< ".to_u << 0x06a6 << "") + ("< ".to_u << 0x06a7 << "") + ("< ".to_u << 0x06a8 << "") + ("< ".to_u << 0x06a9 << "") + ("< ".to_u << 0x06aa << "") + ("< ".to_u << 0x06ab << "") + ("< ".to_u << 0x06ac << "") + ("< ".to_u << 0x06ad << "") + ("< ".to_u << 0x06ae << "") + ("< ".to_u << 0x06b0 << "") + ("< ".to_u << 0x06b1 << "") + ("< ".to_u << 0x06b2 << "") + ("< ".to_u << 0x06b3 << "") + ("< ".to_u << 0x06b4 << "") + ("< ".to_u << 0x06b5 << "") + ("< ".to_u << 0x06b6 << "") + ("< ".to_u << 0x06b7 << "") + ("< ".to_u << 0x06ba << "") + ("< ".to_u << 0x06bb << "") + ("< ".to_u << 0x06bc << "") + ("< ".to_u << 0x06bd << "") + ("< ".to_u << 0x06be << "") + ("< ".to_u << 0x06c0 << "") + ("< ".to_u << 0x06c1 << "") + ("< ".to_u << 0x06c2 << "") + ("< ".to_u << 0x06c3 << "") + ("< ".to_u << 0x06c4 << "") + ("< ".to_u << 0x06c5 << "") + ("< ".to_u << 0x06c6 << "") + ("< ".to_u << 0x06c7 << "") + ("< ".to_u << 0x06c8 << "") + ("< ".to_u << 0x06c9 << "") + ("< ".to_u << 0x06ca << "") + ("< ".to_u << 0x06cb << "") + ("< ".to_u << 0x06cc << "") + ("< ".to_u << 0x06cd << "") + ("< ".to_u << 0x06ce << "") + ("< ".to_u << 0x06d0 << "") + ("< ".to_u << 0x06d1 << "") + ("< ".to_u << 0x06d2 << "") + ("< ".to_u << 0x06d3 << "") + ("< ".to_u << 0x06d5 << "") + ("< ".to_u << 0x0651 << "")]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_ar, :initialize
  end
  
end
