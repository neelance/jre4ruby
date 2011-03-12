require "rjava"

# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Reflect
  module ReflectAccessImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
      include_const ::Sun::Reflect, :MethodAccessor
      include_const ::Sun::Reflect, :ConstructorAccessor
    }
  end
  
  # Package-private class implementing the
  # sun.reflect.LangReflectAccess interface, allowing the java.lang
  # package to instantiate objects in this package.
  class ReflectAccess 
    include_class_members ReflectAccessImports
    include Sun::Reflect::LangReflectAccess
    
    typesig { [Class, String, Class, ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte)] }
    def new_field(declaring_class, name, type, modifiers, slot, signature, annotations)
      return Field.new(declaring_class, name, type, modifiers, slot, signature, annotations)
    end
    
    typesig { [Class, String, Array.typed(Class), Class, Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def new_method(declaring_class, name, parameter_types, return_type, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations, annotation_default)
      return Method.new(declaring_class, name, parameter_types, return_type, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations, annotation_default)
    end
    
    typesig { [Class, Array.typed(Class), Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def new_constructor(declaring_class, parameter_types, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations)
      return Constructor.new(declaring_class, parameter_types, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations)
    end
    
    typesig { [Method] }
    def get_method_accessor(m)
      return m.get_method_accessor
    end
    
    typesig { [Method, MethodAccessor] }
    def set_method_accessor(m, accessor)
      m.set_method_accessor(accessor)
    end
    
    typesig { [Constructor] }
    def get_constructor_accessor(c)
      return c.get_constructor_accessor
    end
    
    typesig { [Constructor, ConstructorAccessor] }
    def set_constructor_accessor(c, accessor)
      c.set_constructor_accessor(accessor)
    end
    
    typesig { [Constructor] }
    def get_constructor_slot(c)
      return c.get_slot
    end
    
    typesig { [Constructor] }
    def get_constructor_signature(c)
      return c.get_signature
    end
    
    typesig { [Constructor] }
    def get_constructor_annotations(c)
      return c.get_raw_annotations
    end
    
    typesig { [Constructor] }
    def get_constructor_parameter_annotations(c)
      return c.get_raw_parameter_annotations
    end
    
    typesig { [Method] }
    # 
    # Copying routines, needed to quickly fabricate new Field,
    # Method, and Constructor objects from templates
    # 
    def copy_method(arg)
      return arg.copy
    end
    
    typesig { [Field] }
    def copy_field(arg)
      return arg.copy
    end
    
    typesig { [Constructor] }
    def copy_constructor(arg)
      return arg.copy
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__reflect_access, :initialize
  end
  
end
