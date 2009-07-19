require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module ReflectImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Lang::Reflect
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  class Reflect 
    include_class_members ReflectImports
    
    typesig { [] }
    # package-private
    def initialize
    end
    
    class_module.module_eval {
      const_set_lazy(:ReflectionError) { Class.new(JavaError) do
        include_class_members Reflect
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -8659519328078164097 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [Exception] }
        def initialize(x)
          super(x)
        end
        
        private
        alias_method :initialize__reflection_error, :initialize
      end }
      
      typesig { [AccessibleObject] }
      def set_accessible(ao)
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Reflect
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            ao.set_accessible(true)
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [String, Array.typed(Class)] }
      def lookup_constructor(class_name, param_types)
        begin
          cl = Class.for_name(class_name)
          c = cl.get_declared_constructor(param_types)
          set_accessible(c)
          return c
        rescue ClassNotFoundException => x
          raise ReflectionError.new(x)
        rescue NoSuchMethodException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [Constructor, Array.typed(Object)] }
      def invoke(c, args)
        begin
          return c.new_instance(args)
        rescue InstantiationException => x
          raise ReflectionError.new(x)
        rescue IllegalAccessException => x
          raise ReflectionError.new(x)
        rescue InvocationTargetException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [String, String, Array.typed(Class)] }
      def lookup_method(class_name, method_name, param_types)
        begin
          cl = Class.for_name(class_name)
          m = cl.get_declared_method(method_name, param_types)
          set_accessible(m)
          return m
        rescue ClassNotFoundException => x
          raise ReflectionError.new(x)
        rescue NoSuchMethodException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [Method, Object, Array.typed(Object)] }
      def invoke(m, ob, args)
        begin
          return m.invoke(ob, args)
        rescue IllegalAccessException => x
          raise ReflectionError.new(x)
        rescue InvocationTargetException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [Method, Object, Array.typed(Object)] }
      def invoke_io(m, ob, args)
        begin
          return m.invoke(ob, args)
        rescue IllegalAccessException => x
          raise ReflectionError.new(x)
        rescue InvocationTargetException => x
          if (IOException.class.is_instance(x.get_cause))
            raise x.get_cause
          end
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [String, String] }
      def lookup_field(class_name, field_name)
        begin
          cl = Class.for_name(class_name)
          f = cl.get_declared_field(field_name)
          set_accessible(f)
          return f
        rescue ClassNotFoundException => x
          raise ReflectionError.new(x)
        rescue NoSuchFieldException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [Object, Field] }
      def get(ob, f)
        begin
          return f.get(ob)
        rescue IllegalAccessException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [Field] }
      def get(f)
        return get(nil, f)
      end
      
      typesig { [Object, Field, Object] }
      def set(ob, f, val)
        begin
          f.set(ob, val)
        rescue IllegalAccessException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [Object, Field, ::Java::Int] }
      def set_int(ob, f, val)
        begin
          f.set_int(ob, val)
        rescue IllegalAccessException => x
          raise ReflectionError.new(x)
        end
      end
      
      typesig { [Object, Field, ::Java::Boolean] }
      def set_boolean(ob, f, val)
        begin
          f.set_boolean(ob, val)
        rescue IllegalAccessException => x
          raise ReflectionError.new(x)
        end
      end
    }
    
    private
    alias_method :initialize__reflect, :initialize
  end
  
end
