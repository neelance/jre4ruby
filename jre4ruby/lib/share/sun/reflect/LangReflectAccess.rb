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
module Sun::Reflect
  module LangReflectAccessImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include ::Java::Lang::Reflect
    }
  end
  
  # An interface which gives privileged packages Java-level access to
  # internals of java.lang.reflect.
  module LangReflectAccess
    include_class_members LangReflectAccessImports
    
    typesig { [Class, String, Class, ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte)] }
    # Creates a new java.lang.reflect.Field. Access checks as per
    # java.lang.reflect.AccessibleObject are not overridden.
    def new_field(declaring_class, name, type, modifiers, slot, signature, annotations)
      raise NotImplementedError
    end
    
    typesig { [Class, String, Array.typed(Class), Class, Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Creates a new java.lang.reflect.Method. Access checks as per
    # java.lang.reflect.AccessibleObject are not overridden.
    def new_method(declaring_class, name, parameter_types, return_type, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations, annotation_default)
      raise NotImplementedError
    end
    
    typesig { [Class, Array.typed(Class), Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Creates a new java.lang.reflect.Constructor. Access checks as
    # per java.lang.reflect.AccessibleObject are not overridden.
    def new_constructor(declaring_class, parameter_types, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations)
      raise NotImplementedError
    end
    
    typesig { [Method] }
    # Gets the MethodAccessor object for a java.lang.reflect.Method
    def get_method_accessor(m)
      raise NotImplementedError
    end
    
    typesig { [Method, MethodAccessor] }
    # Sets the MethodAccessor object for a java.lang.reflect.Method
    def set_method_accessor(m, accessor)
      raise NotImplementedError
    end
    
    typesig { [Constructor] }
    # Gets the ConstructorAccessor object for a
    # java.lang.reflect.Constructor
    def get_constructor_accessor(c)
      raise NotImplementedError
    end
    
    typesig { [Constructor, ConstructorAccessor] }
    # Sets the ConstructorAccessor object for a
    # java.lang.reflect.Constructor
    def set_constructor_accessor(c, accessor)
      raise NotImplementedError
    end
    
    typesig { [Constructor] }
    # Gets the "slot" field from a Constructor (used for serialization)
    def get_constructor_slot(c)
      raise NotImplementedError
    end
    
    typesig { [Constructor] }
    # Gets the "signature" field from a Constructor (used for serialization)
    def get_constructor_signature(c)
      raise NotImplementedError
    end
    
    typesig { [Constructor] }
    # Gets the "annotations" field from a Constructor (used for serialization)
    def get_constructor_annotations(c)
      raise NotImplementedError
    end
    
    typesig { [Constructor] }
    # Gets the "parameterAnnotations" field from a Constructor (used for serialization)
    def get_constructor_parameter_annotations(c)
      raise NotImplementedError
    end
    
    typesig { [Method] }
    # Copying routines, needed to quickly fabricate new Field,
    # Method, and Constructor objects from templates
    # 
    # Makes a "child" copy of a Method
    def copy_method(arg)
      raise NotImplementedError
    end
    
    typesig { [Field] }
    # Makes a "child" copy of a Field
    def copy_field(arg)
      raise NotImplementedError
    end
    
    typesig { [Constructor] }
    # Makes a "child" copy of a Constructor
    def copy_constructor(arg)
      raise NotImplementedError
    end
  end
  
end
