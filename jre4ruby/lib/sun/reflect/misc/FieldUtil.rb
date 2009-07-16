require "rjava"

# 
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
module Sun::Reflect::Misc
  module FieldUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Misc
      include_const ::Java::Lang::Reflect, :Field
    }
  end
  
  # 
  # Create a trampoline class.
  class FieldUtil 
    include_class_members FieldUtilImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [Class, String] }
      def get_field(cls, name)
        ReflectUtil.check_package_access(cls)
        return cls.get_field(name)
      end
      
      typesig { [Class] }
      def get_fields(cls)
        ReflectUtil.check_package_access(cls)
        return cls.get_fields
      end
      
      typesig { [Class] }
      def get_declared_fields(cls)
        ReflectUtil.check_package_access(cls)
        return cls.get_declared_fields
      end
    }
    
    private
    alias_method :initialize__field_util, :initialize
  end
  
end
