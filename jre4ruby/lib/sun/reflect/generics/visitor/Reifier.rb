require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Generics::Visitor
  module ReifierImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Visitor
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Iterator
      include ::Sun::Reflect::Generics::Tree
      include ::Sun::Reflect::Generics::Factory
    }
  end
  
  # Visitor that converts AST to reified types.
  class Reifier 
    include_class_members ReifierImports
    include TypeTreeVisitor
    
    attr_accessor :result_type
    alias_method :attr_result_type, :result_type
    undef_method :result_type
    alias_method :attr_result_type=, :result_type=
    undef_method :result_type=
    
    attr_accessor :factory
    alias_method :attr_factory, :factory
    undef_method :factory
    alias_method :attr_factory=, :factory=
    undef_method :factory=
    
    typesig { [GenericsFactory] }
    def initialize(f)
      @result_type = nil
      @factory = nil
      @factory = f
    end
    
    typesig { [] }
    def get_factory
      return @factory
    end
    
    class_module.module_eval {
      typesig { [GenericsFactory] }
      # Factory method. The resulting visitor will convert an AST
      # representing generic signatures into corresponding reflective
      # objects, using the provided factory, <tt>f</tt>.
      # @param f - a factory that can be used to manufacture reflective
      # objects returned by this visitor
      # @return A visitor that can be used to reify ASTs representing
      # generic type information into reflective objects
      def make(f)
        return Reifier.new(f)
      end
    }
    
    typesig { [Array.typed(TypeArgument)] }
    # Helper method. Visits an array of TypeArgument and produces
    # reified Type array.
    def reify_type_arguments(tas)
      ts = Array.typed(Type).new(tas.attr_length) { nil }
      i = 0
      while i < tas.attr_length
        tas[i].accept(self)
        ts[i] = @result_type
        i += 1
      end
      return ts
    end
    
    typesig { [] }
    # Accessor for the result of the last visit by this visitor,
    # @return The type computed by this visitor based on its last
    # visit
    def get_result
      raise AssertError if not (!(@result_type).nil?)
      return @result_type
    end
    
    typesig { [FormalTypeParameter] }
    def visit_formal_type_parameter(ftp)
      @result_type = get_factory.make_type_variable(ftp.get_name, ftp.get_bounds)
    end
    
    typesig { [ClassTypeSignature] }
    def visit_class_type_signature(ct)
      # This method examines the pathname stored in ct, which has the form
      # n1.n2...nk<targs>....
      # where n1 ... nk-1 might not exist OR
      # nk might not exist (but not both). It may be that k equals 1.
      # The idea is that nk is the simple class type name that has
      # any type parameters associated with it.
      # We process this path in two phases.
      # First, we scan until we reach nk (if it exists).
      # If nk does not exist, this identifies a raw class n1 ... nk-1
      # which we can return.
      # if nk does exist, we begin the 2nd phase.
      # Here nk defines a parameterized type. Every further step nj (j > k)
      # down the path must also be represented as a parameterized type,
      # whose owner is the representation of the previous step in the path,
      # n{j-1}.
      # extract iterator on list of simple class type sigs
      scts = ct.get_path
      raise AssertError if not ((!scts.is_empty))
      iter = scts.iterator
      sc = iter.next
      n = StringBuilder.new(sc.get_name)
      dollar = sc.get_dollar
      # phase 1: iterate over simple class types until
      # we are either done or we hit one with non-empty type parameters
      while (iter.has_next && (sc.get_type_arguments.attr_length).equal?(0))
        sc = iter.next
        dollar = sc.get_dollar
        n.append(dollar ? "$" : ".").append(sc.get_name)
      end
      # Now, either sc is the last element of the list, or
      # it has type arguments (or both)
      raise AssertError if not ((!(iter.has_next) || (sc.get_type_arguments.attr_length > 0)))
      # Create the raw type
      c = get_factory.make_named_type(n.to_s)
      # if there are no type arguments
      if ((sc.get_type_arguments.attr_length).equal?(0))
        # we have surely reached the end of the path
        raise AssertError if not ((!iter.has_next))
        @result_type = c # the result is the raw type
      else
        raise AssertError if not ((sc.get_type_arguments.attr_length > 0))
        # otherwise, we have type arguments, so we create a parameterized
        # type, whose declaration is the raw type c, and whose owner is
        # the declaring class of c (if any). This latter fact is indicated
        # by passing null as the owner.
        # First, we reify the type arguments
        pts = reify_type_arguments(sc.get_type_arguments)
        owner = get_factory.make_parameterized_type(c, pts, nil)
        # phase 2: iterate over remaining simple class types
        dollar = false
        while (iter.has_next)
          sc = iter.next
          dollar = sc.get_dollar
          n.append(dollar ? "$" : ".").append(sc.get_name) # build up raw class name
          c = get_factory.make_named_type(n.to_s) # obtain raw class
          pts = reify_type_arguments(sc.get_type_arguments) # reify params
          # Create a parameterized type, based on type args, raw type
          # and previous owner
          owner = get_factory.make_parameterized_type(c, pts, owner)
        end
        @result_type = owner
      end
    end
    
    typesig { [ArrayTypeSignature] }
    def visit_array_type_signature(a)
      # extract and reify component type
      a.get_component_type.accept(self)
      ct = @result_type
      @result_type = get_factory.make_array_type(ct)
    end
    
    typesig { [TypeVariableSignature] }
    def visit_type_variable_signature(tv)
      @result_type = get_factory.find_type_variable(tv.get_identifier)
    end
    
    typesig { [Wildcard] }
    def visit_wildcard(w)
      @result_type = get_factory.make_wildcard(w.get_upper_bounds, w.get_lower_bounds)
    end
    
    typesig { [SimpleClassTypeSignature] }
    def visit_simple_class_type_signature(sct)
      @result_type = get_factory.make_named_type(sct.get_name)
    end
    
    typesig { [BottomSignature] }
    def visit_bottom_signature(b)
    end
    
    typesig { [ByteSignature] }
    def visit_byte_signature(b)
      @result_type = get_factory.make_byte
    end
    
    typesig { [BooleanSignature] }
    def visit_boolean_signature(b)
      @result_type = get_factory.make_bool
    end
    
    typesig { [ShortSignature] }
    def visit_short_signature(s)
      @result_type = get_factory.make_short
    end
    
    typesig { [CharSignature] }
    def visit_char_signature(c)
      @result_type = get_factory.make_char
    end
    
    typesig { [IntSignature] }
    def visit_int_signature(i)
      @result_type = get_factory.make_int
    end
    
    typesig { [LongSignature] }
    def visit_long_signature(l)
      @result_type = get_factory.make_long
    end
    
    typesig { [FloatSignature] }
    def visit_float_signature(f)
      @result_type = get_factory.make_float
    end
    
    typesig { [DoubleSignature] }
    def visit_double_signature(d)
      @result_type = get_factory.make_double
    end
    
    typesig { [VoidDescriptor] }
    def visit_void_descriptor(v)
      @result_type = get_factory.make_void
    end
    
    private
    alias_method :initialize__reifier, :initialize
  end
  
end
