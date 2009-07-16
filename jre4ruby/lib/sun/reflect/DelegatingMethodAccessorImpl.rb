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
  module DelegatingMethodAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :InvocationTargetException
    }
  end
  
  # Delegates its invocation to another MethodAccessorImpl and can
  # change its delegate at run time.
  class DelegatingMethodAccessorImpl < DelegatingMethodAccessorImplImports.const_get :MethodAccessorImpl
    include_class_members DelegatingMethodAccessorImplImports
    
    attr_accessor :delegate
    alias_method :attr_delegate, :delegate
    undef_method :delegate
    alias_method :attr_delegate=, :delegate=
    undef_method :delegate=
    
    typesig { [MethodAccessorImpl] }
    def initialize(delegate)
      @delegate = nil
      super()
      set_delegate(delegate)
    end
    
    typesig { [Object, Array.typed(Object)] }
    def invoke(obj, args)
      return @delegate.invoke(obj, args)
    end
    
    typesig { [MethodAccessorImpl] }
    def set_delegate(delegate)
      @delegate = delegate
    end
    
    private
    alias_method :initialize__delegating_method_accessor_impl, :initialize
  end
  
end
