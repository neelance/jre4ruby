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
  module ParameterizedTypeImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::ReflectiveObjects
      include_const ::Sun::Reflect::Generics::Tree, :FieldTypeSignature
      include_const ::Java::Lang::Reflect, :MalformedParameterizedTypeException
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :ParameterizedType
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Java::Lang::Reflect, :TypeVariable
      include_const ::Java::Util, :Arrays
    }
  end
  
  # Implementing class for ParameterizedType interface.
  class ParameterizedTypeImpl 
    include_class_members ParameterizedTypeImplImports
    include ParameterizedType
    
    attr_accessor :actual_type_arguments
    alias_method :attr_actual_type_arguments, :actual_type_arguments
    undef_method :actual_type_arguments
    alias_method :attr_actual_type_arguments=, :actual_type_arguments=
    undef_method :actual_type_arguments=
    
    attr_accessor :raw_type
    alias_method :attr_raw_type, :raw_type
    undef_method :raw_type
    alias_method :attr_raw_type=, :raw_type=
    undef_method :raw_type=
    
    attr_accessor :owner_type
    alias_method :attr_owner_type, :owner_type
    undef_method :owner_type
    alias_method :attr_owner_type=, :owner_type=
    undef_method :owner_type=
    
    typesig { [Class, Array.typed(Type), Type] }
    def initialize(raw_type, actual_type_arguments, owner_type)
      @actual_type_arguments = nil
      @raw_type = nil
      @owner_type = nil
      @actual_type_arguments = actual_type_arguments
      @raw_type = raw_type
      if (!(owner_type).nil?)
        @owner_type = owner_type
      else
        @owner_type = raw_type.get_declaring_class
      end
      validate_constructor_arguments
    end
    
    typesig { [] }
    def validate_constructor_arguments
      # <?>
      formals = @raw_type.get_type_parameters
      # check correct arity of actual type args
      if (!(formals.attr_length).equal?(@actual_type_arguments.attr_length))
        raise MalformedParameterizedTypeException.new
      end
      i = 0
      while i < @actual_type_arguments.attr_length
        i += 1
      end
    end
    
    class_module.module_eval {
      typesig { [Class, Array.typed(Type), Type] }
      # Static factory. Given a (generic) class, actual type arguments
      # and an owner type, creates a parameterized type.
      # This class can be instantiated with a a raw type that does not
      # represent a generic type, provided the list of actual type
      # arguments is empty.
      # If the ownerType argument is null, the declaring class of the
      # raw type is used as the owner type.
      # <p> This method throws a MalformedParameterizedTypeException
      # under the following circumstances:
      # If the number of actual type arguments (i.e., the size of the
      # array <tt>typeArgs</tt>) does not correspond to the number of
      # formal type arguments.
      # If any of the actual type arguments is not an instance of the
      # bounds on the corresponding formal.
      # @param rawType the Class representing the generic type declaration being
      # instantiated
      # @param actualTypeArguments - a (possibly empty) array of types
      # representing the actual type arguments to the parameterized type
      # @param ownerType - the enclosing type, if known.
      # @return An instance of <tt>ParameterizedType</tt>
      # @throws MalformedParameterizedTypeException - if the instantiation
      # is invalid
      def make(raw_type, actual_type_arguments, owner_type)
        return ParameterizedTypeImpl.new(raw_type, actual_type_arguments, owner_type)
      end
    }
    
    typesig { [] }
    # Returns an array of <tt>Type</tt> objects representing the actual type
    # arguments to this type.
    # 
    # <p>Note that in some cases, the returned array be empty. This can occur
    # if this type represents a non-parameterized type nested within
    # a parameterized type.
    # 
    # @return an array of <tt>Type</tt> objects representing the actual type
    # arguments to this type
    # @throws <tt>TypeNotPresentException</tt> if any of the
    # actual type arguments refers to a non-existent type declaration
    # @throws <tt>MalformedParameterizedTypeException</tt> if any of the
    # actual type parameters refer to a parameterized type that cannot
    # be instantiated for any reason
    # @since 1.5
    def get_actual_type_arguments
      return @actual_type_arguments.clone
    end
    
    typesig { [] }
    # Returns the <tt>Type</tt> object representing the class or interface
    # that declared this type.
    # 
    # @return the <tt>Type</tt> object representing the class or interface
    # that declared this type
    def get_raw_type
      return @raw_type
    end
    
    typesig { [] }
    # Returns a <tt>Type</tt> object representing the type that this type
    # is a member of.  For example, if this type is <tt>O<T>.I<S></tt>,
    # return a representation of <tt>O<T></tt>.
    # 
    # <p>If this type is a top-level type, <tt>null</tt> is returned.
    # 
    # @return a <tt>Type</tt> object representing the type that
    # this type is a member of. If this type is a top-level type,
    # <tt>null</tt> is returned
    # @throws <tt>TypeNotPresentException</tt> if the owner type
    # refers to a non-existent type declaration
    # @throws <tt>MalformedParameterizedTypeException</tt> if the owner type
    # refers to a parameterized type that cannot be instantiated
    # for any reason
    def get_owner_type
      return @owner_type
    end
    
    typesig { [Object] }
    # From the JavaDoc for java.lang.reflect.ParameterizedType
    # "Instances of classes that implement this interface must
    # implement an equals() method that equates any two instances
    # that share the same generic type declaration and have equal
    # type parameters."
    def ==(o)
      if (o.is_a?(ParameterizedType))
        # Check that information is equivalent
        that = o
        if ((self).equal?(that))
          return true
        end
        that_owner = that.get_owner_type
        that_raw_type = that.get_raw_type
        if (false)
          # Debugging
          owner_equality = ((@owner_type).nil? ? (that_owner).nil? : (@owner_type == that_owner))
          raw_equality = ((@raw_type).nil? ? (that_raw_type).nil? : (@raw_type == that_raw_type))
          # avoid clone
          type_arg_equality = (Arrays == @actual_type_arguments)
          @actual_type_arguments.each do |t|
            System.out.printf("\t\t%s%s%n", t, t.get_class)
          end
          System.out.printf("\towner %s\traw %s\ttypeArg %s%n", owner_equality, raw_equality, type_arg_equality)
          return owner_equality && raw_equality && type_arg_equality
        end
        # avoid clone
        return ((@owner_type).nil? ? (that_owner).nil? : (@owner_type == that_owner)) && ((@raw_type).nil? ? (that_raw_type).nil? : (@raw_type == that_raw_type)) && (Arrays == @actual_type_arguments)
      else
        return false
      end
    end
    
    typesig { [] }
    def hash_code
      return Arrays.hash_code(@actual_type_arguments) ^ ((@owner_type).nil? ? 0 : @owner_type.hash_code) ^ ((@raw_type).nil? ? 0 : @raw_type.hash_code)
    end
    
    typesig { [] }
    def to_s
      sb = StringBuilder.new
      if (!(@owner_type).nil?)
        if (@owner_type.is_a?(Class))
          sb.append((@owner_type).get_name)
        else
          sb.append(@owner_type.to_s)
        end
        sb.append(".")
        if (@owner_type.is_a?(ParameterizedTypeImpl))
          # Find simple name of nested type by removing the
          # shared prefix with owner.
          sb.append(@raw_type.get_name.replace(RJava.cast_to_string((@owner_type).attr_raw_type.get_name) + "$", ""))
        else
          sb.append(@raw_type.get_name)
        end
      else
        sb.append(@raw_type.get_name)
      end
      if (!(@actual_type_arguments).nil? && @actual_type_arguments.attr_length > 0)
        sb.append("<")
        first = true
        @actual_type_arguments.each do |t|
          if (!first)
            sb.append(", ")
          end
          if (t.is_a?(Class))
            sb.append((t).get_name)
          else
            sb.append(t.to_s)
          end
          first = false
        end
        sb.append(">")
      end
      return sb.to_s
    end
    
    private
    alias_method :initialize__parameterized_type_impl, :initialize
  end
  
end
