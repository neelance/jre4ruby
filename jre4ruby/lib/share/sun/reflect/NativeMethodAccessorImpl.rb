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
  module NativeMethodAccessorImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include ::Java::Lang::Reflect
    }
  end
  
  # Used only for the first few invocations of a Method; afterward,
  # switches to bytecode-based implementation
  class NativeMethodAccessorImpl < NativeMethodAccessorImplImports.const_get :MethodAccessorImpl
    include_class_members NativeMethodAccessorImplImports
    
    attr_accessor :method
    alias_method :attr_method, :method
    undef_method :method
    alias_method :attr_method=, :method=
    undef_method :method=
    
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    attr_accessor :num_invocations
    alias_method :attr_num_invocations, :num_invocations
    undef_method :num_invocations
    alias_method :attr_num_invocations=, :num_invocations=
    undef_method :num_invocations=
    
    typesig { [Method] }
    def initialize(method)
      @method = nil
      @parent = nil
      @num_invocations = 0
      super()
      @method = method
    end
    
    typesig { [Object, Array.typed(Object)] }
    def invoke(obj, args)
      if ((@num_invocations += 1) > ReflectionFactory.inflation_threshold)
        acc = MethodAccessorGenerator.new.generate_method(@method.get_declaring_class, @method.get_name, @method.get_parameter_types, @method.get_return_type, @method.get_exception_types, @method.get_modifiers)
        @parent.set_delegate(acc)
      end
      return invoke0(@method, obj, args)
    end
    
    typesig { [DelegatingMethodAccessorImpl] }
    def set_parent(parent)
      @parent = parent
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_reflect_NativeMethodAccessorImpl_invoke0, [:pointer, :long, :long, :long, :long], :long
      typesig { [Method, Object, Array.typed(Object)] }
      def invoke0(m, obj, args)
        JNI.call_native_method(:Java_sun_reflect_NativeMethodAccessorImpl_invoke0, JNI.env, self.jni_id, m.jni_id, obj.jni_id, args.jni_id)
      end
    }
    
    private
    alias_method :initialize__native_method_accessor_impl, :initialize
  end
  
end
