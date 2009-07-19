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
  module DelegatingConstructorAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :InvocationTargetException
    }
  end
  
  # Delegates its invocation to another ConstructorAccessorImpl and can
  # change its delegate at run time.
  class DelegatingConstructorAccessorImpl < DelegatingConstructorAccessorImplImports.const_get :ConstructorAccessorImpl
    include_class_members DelegatingConstructorAccessorImplImports
    
    attr_accessor :delegate
    alias_method :attr_delegate, :delegate
    undef_method :delegate
    alias_method :attr_delegate=, :delegate=
    undef_method :delegate=
    
    typesig { [ConstructorAccessorImpl] }
    def initialize(delegate)
      @delegate = nil
      super()
      set_delegate(delegate)
    end
    
    typesig { [Array.typed(Object)] }
    def new_instance(args)
      return @delegate.new_instance(args)
    end
    
    typesig { [ConstructorAccessorImpl] }
    def set_delegate(delegate)
      @delegate = delegate
    end
    
    private
    alias_method :initialize__delegating_constructor_accessor_impl, :initialize
  end
  
end
