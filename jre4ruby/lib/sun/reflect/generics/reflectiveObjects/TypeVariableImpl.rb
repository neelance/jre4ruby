require "rjava"

# 
# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Generics::ReflectiveObjects
  module TypeVariableImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::ReflectiveObjects
      include_const ::Java::Lang::Reflect, :GenericDeclaration
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Java::Lang::Reflect, :TypeVariable
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Tree, :FieldTypeSignature
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
    }
  end
  
  # 
  # Implementation of <tt>java.lang.reflect.TypeVariable</tt> interface
  # for core reflection.
  class TypeVariableImpl < TypeVariableImplImports.const_get :LazyReflectiveObjectGenerator
    include_class_members TypeVariableImplImports
    include TypeVariable
    
    attr_accessor :generic_declaration
    alias_method :attr_generic_declaration, :generic_declaration
    undef_method :generic_declaration
    alias_method :attr_generic_declaration=, :generic_declaration=
    undef_method :generic_declaration=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # upper bounds - evaluated lazily
    attr_accessor :bounds
    alias_method :attr_bounds, :bounds
    undef_method :bounds
    alias_method :attr_bounds=, :bounds=
    undef_method :bounds=
    
    # The ASTs for the bounds. We are required to evaluate the bounds
    # lazily, so we store these at least until we are first asked
    # for the bounds. This also neatly solves the
    # problem with F-bounds - you can't reify them before the formal
    # is defined.
    attr_accessor :bound_asts
    alias_method :attr_bound_asts, :bound_asts
    undef_method :bound_asts
    alias_method :attr_bound_asts=, :bound_asts=
    undef_method :bound_asts=
    
    typesig { [Object, String, Array.typed(FieldTypeSignature), GenericsFactory] }
    # constructor is private to enforce access through static factory
    def initialize(decl, n, bs, f)
      @generic_declaration = nil
      @name = nil
      @bounds = nil
      @bound_asts = nil
      super(f)
      @generic_declaration = decl
      @name = n
      @bound_asts = bs
    end
    
    typesig { [] }
    # Accessors
    # accessor for ASTs for bounds. Must not be called after
    # bounds have been evaluated, because we might throw the ASTs
    # away (but that is not thread-safe, is it?)
    def get_bound_asts
      # check that bounds were not evaluated yet
      raise AssertError if not (((@bounds).nil?))
      return @bound_asts
    end
    
    class_module.module_eval {
      typesig { [T, String, Array.typed(FieldTypeSignature), GenericsFactory] }
      # 
      # Factory method.
      # @param decl - the reflective object that declared the type variable
      # that this method should create
      # @param name - the name of the type variable to be returned
      # @param bs - an array of ASTs representing the bounds for the type
      # variable to be created
      # @param f - a factory that can be used to manufacture reflective
      # objects that represent the bounds of this type variable
      # @return A type variable with name, bounds, declaration and factory
      # specified
      def make(decl, name, bs, f)
        return TypeVariableImpl.new(decl, name, bs, f)
      end
    }
    
    typesig { [] }
    # 
    # Returns an array of <tt>Type</tt> objects representing the
    # upper bound(s) of this type variable.  Note that if no upper bound is
    # explicitly declared, the upper bound is <tt>Object</tt>.
    # 
    # <p>For each upper bound B:
    # <ul>
    # <li>if B is a parameterized type or a type variable, it is created,
    # (see {@link #ParameterizedType} for the details of the creation
    # process for parameterized types).
    # <li>Otherwise, B is resolved.
    # </ul>
    # 
    # @throws <tt>TypeNotPresentException</tt>  if any of the
    # bounds refers to a non-existent type declaration
    # @throws <tt>MalformedParameterizedTypeException</tt> if any of the
    # bounds refer to a parameterized type that cannot be instantiated
    # for any reason
    # @return an array of Types representing the upper bound(s) of this
    # type variable
    def get_bounds
      # lazily initialize bounds if necessary
      if ((@bounds).nil?)
        fts = get_bound_asts # get AST
        # allocate result array; note that
        # keeping ts and bounds separate helps with threads
        ts = Array.typed(Type).new(fts.attr_length) { nil }
        # iterate over bound trees, reifying each in turn
        j = 0
        while j < fts.attr_length
          r = get_reifier
          fts[j].accept(r)
          ts[j] = r.get_result
          ((j += 1) - 1)
        end
        # cache result
        @bounds = ts
        # could throw away bound ASTs here; thread safety?
      end
      return @bounds.clone # return cached bounds
    end
    
    typesig { [] }
    # 
    # Returns the <tt>GenericDeclaration</tt>  object representing the
    # generic declaration that declared this type variable.
    # 
    # @return the generic declaration that declared this type variable.
    # 
    # @since 1.5
    def get_generic_declaration
      return @generic_declaration
    end
    
    typesig { [] }
    # 
    # Returns the name of this type variable, as it occurs in the source code.
    # 
    # @return the name of this type variable, as it appears in the source code
    def get_name
      return @name
    end
    
    typesig { [] }
    def to_s
      return get_name
    end
    
    typesig { [Object] }
    def equals(o)
      if (o.is_a?(TypeVariable))
        that = o
        that_decl = that.get_generic_declaration
        that_name = that.get_name
        return ((@generic_declaration).nil? ? (that_decl).nil? : (@generic_declaration == that_decl)) && ((@name).nil? ? (that_name).nil? : (@name == that_name))
      else
        return false
      end
    end
    
    typesig { [] }
    def hash_code
      return @generic_declaration.hash_code ^ @name.hash_code
    end
    
    private
    alias_method :initialize__type_variable_impl, :initialize
  end
  
end
