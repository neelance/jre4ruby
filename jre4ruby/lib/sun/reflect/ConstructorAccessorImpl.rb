require "rjava"

# 
# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module ConstructorAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :InvocationTargetException
    }
  end
  
  # Package-private implementation of the ConstructorAccessor
  # interface which has access to all classes and all fields,
  # regardless of language restrictions. See MagicAccessorImpl.
  class ConstructorAccessorImpl < ConstructorAccessorImplImports.const_get :MagicAccessorImpl
    include_class_members ConstructorAccessorImplImports
    include ConstructorAccessor
    
    typesig { [Array.typed(Object)] }
    # Matches specification in {@link java.lang.reflect.Constructor}
    def new_instance(args)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__constructor_accessor_impl, :initialize
  end
  
end
