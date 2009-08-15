require "rjava"

# Portions Copyright 1998-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by IBM. These materials are provided under
# terms of a License Agreement between IBM and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to IBM may not be removed.
module Sun::Text::Resources
  module FormatData_fr_LUImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Sun::Util, :EmptyListResourceBundle
    }
  end
  
  class FormatData_fr_LU < FormatData_fr_LUImports.const_get :EmptyListResourceBundle
    include_class_members FormatData_fr_LUImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_fr_lu, :initialize
  end
  
end
