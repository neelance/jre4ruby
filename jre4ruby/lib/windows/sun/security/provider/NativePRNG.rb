require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module NativePRNGImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
    }
  end
  
  # Native PRNG implementation for Windows. Currently a dummy, we do
  # not support a fully native PRNG on Windows.
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class NativePRNG 
    include_class_members NativePRNGImports
    
    class_module.module_eval {
      typesig { [] }
      # return whether the NativePRNG is available
      def is_available
        return false
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__native_prng, :initialize
  end
  
end
