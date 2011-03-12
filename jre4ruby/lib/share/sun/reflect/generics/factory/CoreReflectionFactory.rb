require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Generics::Factory
  module CoreReflectionFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Factory
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :GenericDeclaration
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :ParameterizedType
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Java::Lang::Reflect, :TypeVariable
      include_const ::Java::Lang::Reflect, :WildcardType
      include ::Sun::Reflect::Generics::ReflectiveObjects
      include_const ::Sun::Reflect::Generics::Scope, :Scope
      include_const ::Sun::Reflect::Generics::Tree, :FieldTypeSignature
    }
  end
  
  # Factory for reflective generic type objects for use by
  # core reflection (java.lang.reflect).
  class CoreReflectionFactory 
    include_class_members CoreReflectionFactoryImports
    include GenericsFactory
    
    attr_accessor :decl
    alias_method :attr_decl, :decl
    undef_method :decl
    alias_method :attr_decl=, :decl=
    undef_method :decl=
    
    attr_accessor :scope
    alias_method :attr_scope, :scope
    undef_method :scope
    alias_method :attr_scope=, :scope=
    undef_method :scope=
    
    typesig { [GenericDeclaration, Scope] }
    def initialize(d, s)
      @decl = nil
      @scope = nil
      @decl = d
      @scope = s
    end
    
    typesig { [] }
    def get_decl
      return @decl
    end
    
    typesig { [] }
    def get_scope
      return @scope
    end
    
    typesig { [] }
    def get_decls_loader
      if (@decl.is_a?(Class))
        return (@decl).get_class_loader
      end
      if (@decl.is_a?(Method))
        return (@decl).get_declaring_class.get_class_loader
      end
      raise AssertError, "Constructor expected" if not (@decl.is_a?(Constructor))
      return (@decl).get_declaring_class.get_class_loader
    end
    
    class_module.module_eval {
      typesig { [GenericDeclaration, Scope] }
      # Factory for this class. Returns an instance of
      # <tt>CoreReflectionFactory</tt> for the declaration and scope
      # provided.
      # This factory will produce reflective objects of the appropriate
      # kind. Classes produced will be those that would be loaded by the
      # defining class loader of the declaration <tt>d</tt> (if <tt>d</tt>
      # is a type declaration, or by the defining loader of the declaring
      # class of <tt>d</tt>  otherwise.
      # <p> Type variables will be created or lookup as necessary in the
      # scope <tt> s</tt>.
      # @param d - the generic declaration (class, interface, method or
      # constructor) that thsi factory services
      # @param s  the scope in which the factory will allocate and search for
      # type variables
      # @return an instance of <tt>CoreReflectionFactory</tt>
      def make(d, s)
        return CoreReflectionFactory.new(d, s)
      end
    }
    
    typesig { [String, Array.typed(FieldTypeSignature)] }
    def make_type_variable(name, bounds)
      return TypeVariableImpl.make(get_decl, name, bounds, self)
    end
    
    typesig { [Array.typed(FieldTypeSignature), Array.typed(FieldTypeSignature)] }
    def make_wildcard(ubs, lbs)
      return WildcardTypeImpl.make(ubs, lbs, self)
    end
    
    typesig { [Type, Array.typed(Type), Type] }
    def make_parameterized_type(declaration, type_args, owner)
      return ParameterizedTypeImpl.make(declaration, type_args, owner)
    end
    
    typesig { [String] }
    def find_type_variable(name)
      return get_scope.lookup(name)
    end
    
    typesig { [String] }
    def make_named_type(name)
      begin
        return Class.for_name(name, false, get_decls_loader)
      rescue ClassNotFoundException => c
        raise TypeNotPresentException.new(name, c)
      end
    end
    
    typesig { [Type] }
    def make_array_type(component_type)
      return GenericArrayTypeImpl.make(component_type)
    end
    
    typesig { [] }
    def make_byte
      return Array
    end
    
    typesig { [] }
    def make_bool
      return Array
    end
    
    typesig { [] }
    def make_short
      return Array
    end
    
    typesig { [] }
    def make_char
      return Array
    end
    
    typesig { [] }
    def make_int
      return Array
    end
    
    typesig { [] }
    def make_long
      return Array
    end
    
    typesig { [] }
    def make_float
      return Array
    end
    
    typesig { [] }
    def make_double
      return Array
    end
    
    typesig { [] }
    def make_void
      return self.attr_void.attr_class
    end
    
    private
    alias_method :initialize__core_reflection_factory, :initialize
  end
  
end
