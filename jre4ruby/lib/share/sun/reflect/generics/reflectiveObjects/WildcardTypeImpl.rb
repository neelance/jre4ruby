require "rjava"

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
  module WildcardTypeImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::ReflectiveObjects
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Java::Lang::Reflect, :WildcardType
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Tree, :FieldTypeSignature
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
      include_const ::Java::Util, :Arrays
    }
  end
  
  # Implementation of WildcardType interface for core reflection.
  class WildcardTypeImpl < WildcardTypeImplImports.const_get :LazyReflectiveObjectGenerator
    include_class_members WildcardTypeImplImports
    overload_protected {
      include WildcardType
    }
    
    # upper bounds - evaluated lazily
    attr_accessor :upper_bounds
    alias_method :attr_upper_bounds, :upper_bounds
    undef_method :upper_bounds
    alias_method :attr_upper_bounds=, :upper_bounds=
    undef_method :upper_bounds=
    
    # lower bounds - evaluated lazily
    attr_accessor :lower_bounds
    alias_method :attr_lower_bounds, :lower_bounds
    undef_method :lower_bounds
    alias_method :attr_lower_bounds=, :lower_bounds=
    undef_method :lower_bounds=
    
    # The ASTs for the bounds. We are required to evaluate the bounds
    # lazily, so we store these at least until we are first asked
    # for the bounds. This also neatly solves the
    # problem with F-bounds - you can't reify them before the formal
    # is defined.
    attr_accessor :upper_bound_asts
    alias_method :attr_upper_bound_asts, :upper_bound_asts
    undef_method :upper_bound_asts
    alias_method :attr_upper_bound_asts=, :upper_bound_asts=
    undef_method :upper_bound_asts=
    
    attr_accessor :lower_bound_asts
    alias_method :attr_lower_bound_asts, :lower_bound_asts
    undef_method :lower_bound_asts
    alias_method :attr_lower_bound_asts=, :lower_bound_asts=
    undef_method :lower_bound_asts=
    
    typesig { [Array.typed(FieldTypeSignature), Array.typed(FieldTypeSignature), GenericsFactory] }
    # constructor is private to enforce access through static factory
    def initialize(ubs, lbs, f)
      @upper_bounds = nil
      @lower_bounds = nil
      @upper_bound_asts = nil
      @lower_bound_asts = nil
      super(f)
      @upper_bound_asts = ubs
      @lower_bound_asts = lbs
    end
    
    class_module.module_eval {
      typesig { [Array.typed(FieldTypeSignature), Array.typed(FieldTypeSignature), GenericsFactory] }
      # Factory method.
      # @param ubs - an array of ASTs representing the upper bounds for the type
      # variable to be created
      # @param lbs - an array of ASTs representing the lower bounds for the type
      # variable to be created
      # @param f - a factory that can be used to manufacture reflective
      # objects that represent the bounds of this wildcard type
      # @return a wild card type with the requested bounds and factory
      def make(ubs, lbs, f)
        return WildcardTypeImpl.new(ubs, lbs, f)
      end
    }
    
    typesig { [] }
    # Accessors
    # accessor for ASTs for upper bounds. Must not be called after upper
    # bounds have been evaluated, because we might throw the ASTs
    # away (but that is not thread-safe, is it?)
    def get_upper_bound_asts
      # check that upper bounds were not evaluated yet
      raise AssertError if not (((@upper_bounds).nil?))
      return @upper_bound_asts
    end
    
    typesig { [] }
    # accessor for ASTs for lower bounds. Must not be called after lower
    # bounds have been evaluated, because we might throw the ASTs
    # away (but that is not thread-safe, is it?)
    def get_lower_bound_asts
      # check that lower bounds were not evaluated yet
      raise AssertError if not (((@lower_bounds).nil?))
      return @lower_bound_asts
    end
    
    typesig { [] }
    # Returns an array of <tt>Type</tt> objects representing the  upper
    # bound(s) of this type variable.  Note that if no upper bound is
    # explicitly declared, the upper bound is <tt>Object</tt>.
    # 
    # <p>For each upper bound B :
    # <ul>
    #  <li>if B is a parameterized type or a type variable, it is created,
    #  (see {@link #ParameterizedType} for the details of the creation
    #  process for parameterized types).
    #  <li>Otherwise, B is resolved.
    # </ul>
    # 
    # @return an array of Types representing the upper bound(s) of this
    #     type variable
    # @throws <tt>TypeNotPresentException</tt> if any of the
    #     bounds refers to a non-existent type declaration
    # @throws <tt>MalformedParameterizedTypeException</tt> if any of the
    #     bounds refer to a parameterized type that cannot be instantiated
    #     for any reason
    def get_upper_bounds
      # lazily initialize bounds if necessary
      if ((@upper_bounds).nil?)
        fts = get_upper_bound_asts # get AST
        # allocate result array; note that
        # keeping ts and bounds separate helps with threads
        ts = Array.typed(Type).new(fts.attr_length) { nil }
        # iterate over bound trees, reifying each in turn
        j = 0
        while j < fts.attr_length
          r = get_reifier
          fts[j].accept(r)
          ts[j] = r.get_result
          j += 1
        end
        # cache result
        @upper_bounds = ts
        # could throw away upper bound ASTs here; thread safety?
      end
      return @upper_bounds.clone # return cached bounds
    end
    
    typesig { [] }
    # Returns an array of <tt>Type</tt> objects representing the
    # lower bound(s) of this type variable.  Note that if no lower bound is
    # explicitly declared, the lower bound is the type of <tt>null</tt>.
    # In this case, a zero length array is returned.
    # 
    # <p>For each lower bound B :
    # <ul>
    #   <li>if B is a parameterized type or a type variable, it is created,
    #   (see {@link #ParameterizedType} for the details of the creation
    #   process for parameterized types).
    #   <li>Otherwise, B is resolved.
    # </ul>
    # 
    # @return an array of Types representing the lower bound(s) of this
    #     type variable
    # @throws <tt>TypeNotPresentException</tt> if any of the
    #     bounds refers to a non-existent type declaration
    # @throws <tt>MalformedParameterizedTypeException</tt> if any of the
    #     bounds refer to a parameterized type that cannot be instantiated
    #     for any reason
    def get_lower_bounds
      # lazily initialize bounds if necessary
      if ((@lower_bounds).nil?)
        fts = get_lower_bound_asts # get AST
        # allocate result array; note that
        # keeping ts and bounds separate helps with threads
        ts = Array.typed(Type).new(fts.attr_length) { nil }
        # iterate over bound trees, reifying each in turn
        j = 0
        while j < fts.attr_length
          r = get_reifier
          fts[j].accept(r)
          ts[j] = r.get_result
          j += 1
        end
        # cache result
        @lower_bounds = ts
        # could throw away lower bound ASTs here; thread safety?
      end
      return @lower_bounds.clone # return cached bounds
    end
    
    typesig { [] }
    def to_s
      lower_bounds = get_lower_bounds
      bounds = lower_bounds
      sb = StringBuilder.new
      if (lower_bounds.attr_length > 0)
        sb.append("? super ")
      else
        upper_bounds = get_upper_bounds
        if (upper_bounds.attr_length > 0 && !(upper_bounds[0] == Object))
          bounds = upper_bounds
          sb.append("? extends ")
        else
          return "?"
        end
      end
      raise AssertError if not (bounds.attr_length > 0)
      first = true
      bounds.each do |bound|
        if (!first)
          sb.append(" & ")
        end
        first = false
        if (bound.is_a?(Class))
          sb.append((bound).get_name)
        else
          sb.append(bound.to_s)
        end
      end
      return sb.to_s
    end
    
    typesig { [Object] }
    def ==(o)
      if (o.is_a?(WildcardType))
        that = o
        return Arrays.==(self.get_lower_bounds, that.get_lower_bounds) && Arrays.==(self.get_upper_bounds, that.get_upper_bounds)
      else
        return false
      end
    end
    
    typesig { [] }
    def hash_code
      lower_bounds = get_lower_bounds
      upper_bounds = get_upper_bounds
      return Arrays.hash_code(lower_bounds) ^ Arrays.hash_code(upper_bounds)
    end
    
    private
    alias_method :initialize__wildcard_type_impl, :initialize
  end
  
end
