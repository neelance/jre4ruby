require "rjava"

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
  module BootstrapConstructorAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Lang::Reflect, :Constructor
    }
  end
  
  # Uses Unsafe.allocateObject() to instantiate classes; only used for
  # bootstrapping.
  class BootstrapConstructorAccessorImpl < BootstrapConstructorAccessorImplImports.const_get :ConstructorAccessorImpl
    include_class_members BootstrapConstructorAccessorImplImports
    
    attr_accessor :constructor
    alias_method :attr_constructor, :constructor
    undef_method :constructor
    alias_method :attr_constructor=, :constructor=
    undef_method :constructor=
    
    typesig { [Constructor] }
    def initialize(c)
      @constructor = nil
      super()
      @constructor = c
    end
    
    typesig { [Array.typed(Object)] }
    def new_instance(args)
      begin
        return UnsafeFieldAccessorImpl.attr_unsafe.allocate_instance(@constructor.get_declaring_class)
      rescue InstantiationException => e
        raise InvocationTargetException.new(e)
      end
    end
    
    private
    alias_method :initialize__bootstrap_constructor_accessor_impl, :initialize
  end
  
end
