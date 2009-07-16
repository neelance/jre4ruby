require "rjava"

# 
# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module ObjectStreamExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # Superclass of all exceptions specific to Object Stream classes.
  # 
  # @author  unascribed
  # @since   JDK1.1
  class ObjectStreamException < ObjectStreamExceptionImports.const_get :IOException
    include_class_members ObjectStreamExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7260898174833392607 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # 
    # Create an ObjectStreamException with the specified argument.
    # 
    # @param classname the detailed message for the exception
    def initialize(classname)
      super(classname)
    end
    
    typesig { [] }
    # 
    # Create an ObjectStreamException.
    def initialize
      super()
    end
    
    private
    alias_method :initialize__object_stream_exception, :initialize
  end
  
end
