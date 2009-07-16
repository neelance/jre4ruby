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
  module NativeConstructorAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include ::Java::Lang::Reflect
    }
  end
  
  # Used only for the first few invocations of a Constructor;
  # afterward, switches to bytecode-based implementation
  class NativeConstructorAccessorImpl < NativeConstructorAccessorImplImports.const_get :ConstructorAccessorImpl
    include_class_members NativeConstructorAccessorImplImports
    
    attr_accessor :c
    alias_method :attr_c, :c
    undef_method :c
    alias_method :attr_c=, :c=
    undef_method :c=
    
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
    
    typesig { [Constructor] }
    def initialize(c)
      @c = nil
      @parent = nil
      @num_invocations = 0
      super()
      @c = c
    end
    
    typesig { [Array.typed(Object)] }
    def new_instance(args)
      if ((@num_invocations += 1) > ReflectionFactory.inflation_threshold)
        acc = MethodAccessorGenerator.new.generate_constructor(@c.get_declaring_class, @c.get_parameter_types, @c.get_exception_types, @c.get_modifiers)
        @parent.set_delegate(acc)
      end
      return new_instance0(@c, args)
    end
    
    typesig { [DelegatingConstructorAccessorImpl] }
    def set_parent(parent)
      @parent = parent
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_reflect_NativeConstructorAccessorImpl_newInstance0, [:pointer, :long, :long, :long], :long
      typesig { [Constructor, Array.typed(Object)] }
      def new_instance0(c, args)
        JNI.__send__(:Java_sun_reflect_NativeConstructorAccessorImpl_newInstance0, JNI.env, self.jni_id, c.jni_id, args.jni_id)
      end
    }
    
    private
    alias_method :initialize__native_constructor_accessor_impl, :initialize
  end
  
end
