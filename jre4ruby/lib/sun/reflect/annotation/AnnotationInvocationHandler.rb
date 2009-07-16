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
module Sun::Reflect::Annotation
  module AnnotationInvocationHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Annotation
      include ::Java::Lang::Annotation
      include ::Java::Lang::Reflect
      include_const ::Java::Io, :Serializable
      include ::Java::Util
      include ::Java::Lang::Annotation
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # 
  # InvocationHandler for dynamic proxy implementation of Annotation.
  # 
  # @author  Josh Bloch
  # @since   1.5
  class AnnotationInvocationHandler 
    include_class_members AnnotationInvocationHandlerImports
    include InvocationHandler
    include Serializable
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    attr_accessor :member_values
    alias_method :attr_member_values, :member_values
    undef_method :member_values
    alias_method :attr_member_values=, :member_values=
    undef_method :member_values=
    
    typesig { [Class, Map] }
    def initialize(type, member_values)
      @type = nil
      @member_values = nil
      @member_methods = nil
      @type = type
      @member_values = member_values
    end
    
    typesig { [Object, Method, Array.typed(Object)] }
    def invoke(proxy, method, args)
      member = method.get_name
      param_types = method.get_parameter_types
      # Handle Object and Annotation methods
      if ((member == "equals") && (param_types.attr_length).equal?(1) && (param_types[0]).equal?(Object.class))
        return equals_impl(args[0])
      end
      raise AssertError if not ((param_types.attr_length).equal?(0))
      if ((member == "toString"))
        return to_string_impl
      end
      if ((member == "hashCode"))
        return hash_code_impl
      end
      if ((member == "annotationType"))
        return @type
      end
      # Handle annotation member accessors
      result = @member_values.get(member)
      if ((result).nil?)
        raise IncompleteAnnotationException.new(@type, member)
      end
      if (result.is_a?(ExceptionProxy))
        raise (result).generate_exception
      end
      if (result.get_class.is_array && !(Array.get_length(result)).equal?(0))
        result = clone_array(result)
      end
      return result
    end
    
    typesig { [Object] }
    # 
    # This method, which clones its array argument, would not be necessary
    # if Cloneable had a public clone method.
    def clone_array(array)
      type = array.get_class
      if ((type).equal?(Array))
        byte_array = array
        return byte_array.clone
      end
      if ((type).equal?(Array))
        char_array = array
        return char_array.clone
      end
      if ((type).equal?(Array))
        double_array = array
        return double_array.clone
      end
      if ((type).equal?(Array))
        float_array = array
        return float_array.clone
      end
      if ((type).equal?(Array))
        int_array = array
        return int_array.clone
      end
      if ((type).equal?(Array))
        long_array = array
        return long_array.clone
      end
      if ((type).equal?(Array))
        short_array = array
        return short_array.clone
      end
      if ((type).equal?(Array))
        boolean_array = array
        return boolean_array.clone
      end
      object_array = array
      return object_array.clone
    end
    
    typesig { [] }
    # 
    # Implementation of dynamicProxy.toString()
    def to_string_impl
      result = StringBuffer.new(128)
      result.append(Character.new(?@.ord))
      result.append(@type.get_name)
      result.append(Character.new(?(.ord))
      first_member = true
      @member_values.entry_set.each do |e|
        if (first_member)
          first_member = false
        else
          result.append(", ")
        end
        result.append(e.get_key)
        result.append(Character.new(?=.ord))
        result.append(member_value_to_string(e.get_value))
      end
      result.append(Character.new(?).ord))
      return result.to_s
    end
    
    class_module.module_eval {
      typesig { [Object] }
      # 
      # Translates a member value (in "dynamic proxy return form") into a string
      def member_value_to_string(value)
        type = value.get_class
        if (!type.is_array)
          # primitive, string, class, enum const,
          # or annotation
          return value.to_s
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        if ((type).equal?(Array))
          return Arrays.to_s(value)
        end
        return Arrays.to_s(value)
      end
    }
    
    typesig { [Object] }
    # 
    # Implementation of dynamicProxy.equals(Object o)
    def equals_impl(o)
      if ((o).equal?(self))
        return true
      end
      if (!@type.is_instance(o))
        return false
      end
      get_member_methods.each do |memberMethod|
        member = member_method.get_name
        our_value = @member_values.get(member)
        his_value = nil
        his_handler = as_one_of_us(o)
        if (!(his_handler).nil?)
          his_value = his_handler.attr_member_values.get(member)
        else
          begin
            his_value = member_method.invoke(o)
          rescue InvocationTargetException => e
            return false
          rescue IllegalAccessException => e
            raise AssertionError.new(e_)
          end
        end
        if (!member_value_equals(our_value, his_value))
          return false
        end
      end
      return true
    end
    
    typesig { [Object] }
    # 
    # Returns an object's invocation handler if that object is a dynamic
    # proxy with a handler of type AnnotationInvocationHandler.
    # Returns null otherwise.
    def as_one_of_us(o)
      if (Proxy.is_proxy_class(o.get_class))
        handler = Proxy.get_invocation_handler(o)
        if (handler.is_a?(AnnotationInvocationHandler))
          return handler
        end
      end
      return nil
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # 
      # Returns true iff the two member values in "dynamic proxy return form"
      # are equal using the appropriate equality function depending on the
      # member type.  The two values will be of the same type unless one of
      # the containing annotations is ill-formed.  If one of the containing
      # annotations is ill-formed, this method will return false unless the
      # two members are identical object references.
      def member_value_equals(v1, v2)
        type = v1.get_class
        # Check for primitive, string, class, enum const, annotation,
        # or ExceptionProxy
        if (!type.is_array)
          return (v1 == v2)
        end
        # Check for array of string, class, enum const, annotation,
        # or ExceptionProxy
        if (v1.is_a?(Array.typed(Object)) && v2.is_a?(Array.typed(Object)))
          return (Arrays == v1)
        end
        # Check for ill formed annotation(s)
        if (!(v2.get_class).equal?(type))
          return false
        end
        # Deal with array of primitives
        if ((type).equal?(Array))
          return (Arrays == v1)
        end
        if ((type).equal?(Array))
          return (Arrays == v1)
        end
        if ((type).equal?(Array))
          return (Arrays == v1)
        end
        if ((type).equal?(Array))
          return (Arrays == v1)
        end
        if ((type).equal?(Array))
          return (Arrays == v1)
        end
        if ((type).equal?(Array))
          return (Arrays == v1)
        end
        if ((type).equal?(Array))
          return (Arrays == v1)
        end
        raise AssertError if not ((type).equal?(Array))
        return (Arrays == v1)
      end
    }
    
    typesig { [] }
    # 
    # Returns the member methods for our annotation type.  These are
    # obtained lazily and cached, as they're expensive to obtain
    # and we only need them if our equals method is invoked (which should
    # be rare).
    def get_member_methods
      if ((@member_methods).nil?)
        @member_methods = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members AnnotationInvocationHandler
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            mm = self.attr_type.get_declared_methods
            AccessibleObject.set_accessible(mm, true)
            return mm
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      return @member_methods
    end
    
    attr_accessor :member_methods
    alias_method :attr_member_methods, :member_methods
    undef_method :member_methods
    alias_method :attr_member_methods=, :member_methods=
    undef_method :member_methods=
    
    typesig { [] }
    # 
    # Implementation of dynamicProxy.hashCode()
    def hash_code_impl
      result = 0
      @member_values.entry_set.each do |e|
        result += (127 * e.get_key.hash_code) ^ member_value_hash_code(e.get_value)
      end
      return result
    end
    
    class_module.module_eval {
      typesig { [Object] }
      # 
      # Computes hashCode of a member value (in "dynamic proxy return form")
      def member_value_hash_code(value)
        type = value.get_class
        if (!type.is_array)
          # primitive, string, class, enum const,
          # or annotation
          return value.hash_code
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        if ((type).equal?(Array))
          return Arrays.hash_code(value)
        end
        return Arrays.hash_code(value)
      end
    }
    
    typesig { [Java::Io::ObjectInputStream] }
    def read_object(s)
      s.default_read_object
      # Check to make sure that types have not evolved incompatibly
      annotation_type = nil
      begin
        annotation_type = AnnotationType.get_instance(@type)
      rescue IllegalArgumentException => e
        # Class is no longer an annotation type; all bets are off
        return
      end
      member_types_ = annotation_type.member_types
      @member_values.entry_set.each do |memberValue|
        name = member_value.get_key
        member_type = member_types_.get(name)
        if (!(member_type).nil?)
          # i.e. member still exists
          value = member_value.get_value
          if (!(member_type.is_instance(value) || value.is_a?(ExceptionProxy)))
            member_value.set_value(AnnotationTypeMismatchExceptionProxy.new((value.get_class).to_s + "[" + (value).to_s + "]").set_member(annotation_type.members.get(name)))
          end
        end
      end
    end
    
    private
    alias_method :initialize__annotation_invocation_handler, :initialize
  end
  
end
