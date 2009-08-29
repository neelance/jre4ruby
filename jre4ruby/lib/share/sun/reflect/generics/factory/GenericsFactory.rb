require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GenericsFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Factory
      include_const ::Java::Lang::Reflect, :ParameterizedType
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Java::Lang::Reflect, :TypeVariable
      include_const ::Java::Lang::Reflect, :WildcardType
      include_const ::Sun::Reflect::Generics::Tree, :FieldTypeSignature
    }
  end
  
  # A factory interface for reflective objects representing generic types.
  # Implementors (such as core reflection or JDI, or possibly javadoc
  # will manufacture instances of (potentially) different classes
  # in response to invocations of the methods described here.
  # <p> The intent is that reflective systems use these factories to
  # produce generic type information on demand.
  # Certain components of such reflective systems can be independent
  # of a specific implementation by using this interface. For example,
  # repositories of generic type information are initialized with a
  # factory conforming to this interface, and use it to generate the
  # tpe information they are required to provide. As a result, such
  # repository code can be shared across different reflective systems.
  module GenericsFactory
    include_class_members GenericsFactoryImports
    
    typesig { [String, Array.typed(FieldTypeSignature)] }
    # Returns a new type variable declaration. Note that <tt>name</tt>
    # may be empty (but not <tt>null</tt>). If <tt>bounds</tt> is
    # empty, a bound of <tt>java.lang.Object</tt> is used.
    # @param name The name of the type variable
    # @param bounds An array of abstract syntax trees representing
    # the upper bound(s) on the type variable being declared
    # @return a new type variable declaration
    # @throws NullPointerException - if any of the actual parameters
    # or any of the elements of <tt>bounds</tt> are <tt>null</tt>.
    def make_type_variable(name, bounds)
      raise NotImplementedError
    end
    
    typesig { [Type, Array.typed(Type), Type] }
    # Return an instance of the <tt>ParameterizedType</tt> interface
    # that corresponds to a generic type instantiation of the
    # generic declaration <tt>declaration</tt> with actual type arguments
    # <tt>typeArgs</tt>.
    # If <tt>owner</tt> is <tt>null</tt>, the declaring class of
    # <tt>declaration</tt> is used as the owner of this parameterized
    # type.
    # <p> This method throws a MalformedParameterizedTypeException
    # under the following circumstances:
    # If the type declaration does not represent a generic declaration
    # (i.e., it is not an instance of <tt>GenericDeclaration</tt>).
    # If the number of actual type arguments (i.e., the size of the
    # array <tt>typeArgs</tt>) does not correspond to the number of
    # formal type arguments.
    # If any of the actual type arguments is not an instance of the
    # bounds on the corresponding formal.
    # @param declaration - the generic type declaration that is to be
    # instantiated
    # @param typeArgs - the list of actual type arguments
    # @return - a parameterized type representing the instantiation
    # of the declaration with the actual type arguments
    # @throws MalformedParameterizedTypeException - if the instantiation
    # is invalid
    # @throws NullPointerException - if any of <tt>declaration</tt>
    # , <tt>typeArgs</tt>
    # or any of the elements of <tt>typeArgs</tt> are <tt>null</tt>
    def make_parameterized_type(declaration, type_args, owner)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the type variable with name <tt>name</tt>, if such
    # a type variable is declared in the
    # scope used to create this factory.
    # Returns <tt>null</tt> otherwise.
    # @param name - the name of the type variable to search for
    # @return - the type variable with name <tt>name</tt>, or <tt>null</tt>
    # @throws  NullPointerException - if any of actual parameters are
    # <tt>null</tt>
    def find_type_variable(name)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(FieldTypeSignature), Array.typed(FieldTypeSignature)] }
    # Returns a new wildcard type variable. If
    # <tt>ubs</tt> is empty, a bound of <tt>java.lang.Object</tt> is used.
    # @param ubs An array of abstract syntax trees representing
    # the upper bound(s) on the type variable being declared
    # @param lbs An array of abstract syntax trees representing
    # the lower bound(s) on the type variable being declared
    # @return a new wildcard type variable
    # @throws NullPointerException - if any of the actual parameters
    # or any of the elements of <tt>ubs</tt> or <tt>lbs</tt>are
    # <tt>null</tt>
    def make_wildcard(ubs, lbs)
      raise NotImplementedError
    end
    
    typesig { [String] }
    def make_named_type(name)
      raise NotImplementedError
    end
    
    typesig { [Type] }
    # Returns a (possibly generic) array type.
    # If the component type is a parameterized type, it must
    # only have unbounded wildcard arguemnts, otherwise
    # a MalformedParameterizedTypeException is thrown.
    # @param componentType - the component type of the array
    # @return a (possibly generic) array type.
    # @throws MalformedParameterizedTypeException if <tt>componentType</tt>
    # is a parameterized type with non-wildcard type arguments
    # @throws NullPointerException - if any of the actual parameters
    # are <tt>null</tt>
    def make_array_type(component_type)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>byte</tt>.
    # @return the reflective representation of type <tt>byte</tt>.
    def make_byte
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>boolean</tt>.
    # @return the reflective representation of type <tt>boolean</tt>.
    def make_bool
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>short</tt>.
    # @return the reflective representation of type <tt>short</tt>.
    def make_short
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>char</tt>.
    # @return the reflective representation of type <tt>char</tt>.
    def make_char
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>int</tt>.
    # @return the reflective representation of type <tt>int</tt>.
    def make_int
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>long</tt>.
    # @return the reflective representation of type <tt>long</tt>.
    def make_long
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>float</tt>.
    # @return the reflective representation of type <tt>float</tt>.
    def make_float
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of type <tt>double</tt>.
    # @return the reflective representation of type <tt>double</tt>.
    def make_double
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the reflective representation of <tt>void</tt>.
    # @return the reflective representation of <tt>void</tt>.
    def make_void
      raise NotImplementedError
    end
  end
  
end
