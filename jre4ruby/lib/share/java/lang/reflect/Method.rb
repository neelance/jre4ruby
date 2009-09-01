require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MethodImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
      include_const ::Sun::Reflect, :MethodAccessor
      include_const ::Sun::Reflect, :Reflection
      include_const ::Sun::Reflect::Generics::Repository, :MethodRepository
      include_const ::Sun::Reflect::Generics::Factory, :CoreReflectionFactory
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Scope, :MethodScope
      include_const ::Sun::Reflect::Annotation, :AnnotationType
      include_const ::Sun::Reflect::Annotation, :AnnotationParser
      include_const ::Java::Lang::Annotation, :Annotation
      include_const ::Java::Lang::Annotation, :AnnotationFormatError
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Util, :Map
    }
  end
  
  # A {@code Method} provides information about, and access to, a single method
  # on a class or interface.  The reflected method may be a class method
  # or an instance method (including an abstract method).
  # 
  # <p>A {@code Method} permits widening conversions to occur when matching the
  # actual parameters to invoke with the underlying method's formal
  # parameters, but it throws an {@code IllegalArgumentException} if a
  # narrowing conversion would occur.
  # 
  # @see Member
  # @see java.lang.Class
  # @see java.lang.Class#getMethods()
  # @see java.lang.Class#getMethod(String, Class[])
  # @see java.lang.Class#getDeclaredMethods()
  # @see java.lang.Class#getDeclaredMethod(String, Class[])
  # 
  # @author Kenneth Russell
  # @author Nakul Saraiya
  class Method < MethodImports.const_get :AccessibleObject
    include_class_members MethodImports
    overload_protected {
      include GenericDeclaration
      include Member
    }
    
    attr_accessor :clazz
    alias_method :attr_clazz, :clazz
    undef_method :clazz
    alias_method :attr_clazz=, :clazz=
    undef_method :clazz=
    
    attr_accessor :slot
    alias_method :attr_slot, :slot
    undef_method :slot
    alias_method :attr_slot=, :slot=
    undef_method :slot=
    
    # This is guaranteed to be interned by the VM in the 1.4
    # reflection implementation
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :return_type
    alias_method :attr_return_type, :return_type
    undef_method :return_type
    alias_method :attr_return_type=, :return_type=
    undef_method :return_type=
    
    attr_accessor :parameter_types
    alias_method :attr_parameter_types, :parameter_types
    undef_method :parameter_types
    alias_method :attr_parameter_types=, :parameter_types=
    undef_method :parameter_types=
    
    attr_accessor :exception_types
    alias_method :attr_exception_types, :exception_types
    undef_method :exception_types
    alias_method :attr_exception_types=, :exception_types=
    undef_method :exception_types=
    
    attr_accessor :modifiers
    alias_method :attr_modifiers, :modifiers
    undef_method :modifiers
    alias_method :attr_modifiers=, :modifiers=
    undef_method :modifiers=
    
    # Generics and annotations support
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    # generic info repository; lazily initialized
    attr_accessor :generic_info
    alias_method :attr_generic_info, :generic_info
    undef_method :generic_info
    alias_method :attr_generic_info=, :generic_info=
    undef_method :generic_info=
    
    attr_accessor :annotations
    alias_method :attr_annotations, :annotations
    undef_method :annotations
    alias_method :attr_annotations=, :annotations=
    undef_method :annotations=
    
    attr_accessor :parameter_annotations
    alias_method :attr_parameter_annotations, :parameter_annotations
    undef_method :parameter_annotations
    alias_method :attr_parameter_annotations=, :parameter_annotations=
    undef_method :parameter_annotations=
    
    attr_accessor :annotation_default
    alias_method :attr_annotation_default, :annotation_default
    undef_method :annotation_default
    alias_method :attr_annotation_default=, :annotation_default=
    undef_method :annotation_default=
    
    attr_accessor :method_accessor
    alias_method :attr_method_accessor, :method_accessor
    undef_method :method_accessor
    alias_method :attr_method_accessor=, :method_accessor=
    undef_method :method_accessor=
    
    # For sharing of MethodAccessors. This branching structure is
    # currently only two levels deep (i.e., one root Method and
    # potentially many Method objects pointing to it.)
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    # More complicated security check cache needed here than for
    # Class.newInstance() and Constructor.newInstance()
    attr_accessor :security_check_cache
    alias_method :attr_security_check_cache, :security_check_cache
    undef_method :security_check_cache
    alias_method :attr_security_check_cache=, :security_check_cache=
    undef_method :security_check_cache=
    
    attr_accessor :security_check_target_class_cache
    alias_method :attr_security_check_target_class_cache, :security_check_target_class_cache
    undef_method :security_check_target_class_cache
    alias_method :attr_security_check_target_class_cache=, :security_check_target_class_cache=
    undef_method :security_check_target_class_cache=
    
    class_module.module_eval {
      # Modifiers that can be applied to a method in source code
      const_set_lazy(:LANGUAGE_MODIFIERS) { Modifier::PUBLIC | Modifier::PROTECTED | Modifier::PRIVATE | Modifier::ABSTRACT | Modifier::STATIC | Modifier::FINAL | Modifier::SYNCHRONIZED | Modifier::NATIVE }
      const_attr_reader  :LANGUAGE_MODIFIERS
    }
    
    typesig { [] }
    # Generics infrastructure
    def get_generic_signature
      return @signature
    end
    
    typesig { [] }
    # Accessor for factory
    def get_factory
      # create scope and factory
      return CoreReflectionFactory.make(self, MethodScope.make(self))
    end
    
    typesig { [] }
    # Accessor for generic info repository
    def get_generic_info
      # lazily initialize repository if necessary
      if ((@generic_info).nil?)
        # create and cache generic info repository
        @generic_info = MethodRepository.make(get_generic_signature, get_factory)
      end
      return @generic_info # return cached repository
    end
    
    typesig { [Class, String, Array.typed(Class), Class, Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Package-private constructor used by ReflectAccess to enable
    # instantiation of these objects in Java code from the java.lang
    # package via sun.reflect.LangReflectAccess.
    def initialize(declaring_class, name, parameter_types, return_type, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations, annotation_default)
      @clazz = nil
      @slot = 0
      @name = nil
      @return_type = nil
      @parameter_types = nil
      @exception_types = nil
      @modifiers = 0
      @signature = nil
      @generic_info = nil
      @annotations = nil
      @parameter_annotations = nil
      @annotation_default = nil
      @method_accessor = nil
      @root = nil
      @security_check_cache = nil
      @security_check_target_class_cache = nil
      @declared_annotations = nil
      super()
      @clazz = declaring_class
      @name = name
      @parameter_types = parameter_types
      @return_type = return_type
      @exception_types = checked_exceptions
      @modifiers = modifiers
      @slot = slot
      @signature = signature
      @annotations = annotations
      @parameter_annotations = parameter_annotations
      @annotation_default = annotation_default
    end
    
    typesig { [] }
    # Package-private routine (exposed to java.lang.Class via
    # ReflectAccess) which returns a copy of this Method. The copy's
    # "root" field points to this Method.
    def copy
      # This routine enables sharing of MethodAccessor objects
      # among Method objects which refer to the same underlying
      # method in the VM. (All of this contortion is only necessary
      # because of the "accessibility" bit in AccessibleObject,
      # which implicitly requires that new java.lang.reflect
      # objects be fabricated for each reflective call on Class
      # objects.)
      res = Method.new(@clazz, @name, @parameter_types, @return_type, @exception_types, @modifiers, @slot, @signature, @annotations, @parameter_annotations, @annotation_default)
      res.attr_root = self
      # Might as well eagerly propagate this if already present
      res.attr_method_accessor = @method_accessor
      return res
    end
    
    typesig { [] }
    # Returns the {@code Class} object representing the class or interface
    # that declares the method represented by this {@code Method} object.
    def get_declaring_class
      return @clazz
    end
    
    typesig { [] }
    # Returns the name of the method represented by this {@code Method}
    # object, as a {@code String}.
    def get_name
      return @name
    end
    
    typesig { [] }
    # Returns the Java language modifiers for the method represented
    # by this {@code Method} object, as an integer. The {@code Modifier} class should
    # be used to decode the modifiers.
    # 
    # @see Modifier
    def get_modifiers
      return @modifiers
    end
    
    typesig { [] }
    # Returns an array of {@code TypeVariable} objects that represent the
    # type variables declared by the generic declaration represented by this
    # {@code GenericDeclaration} object, in declaration order.  Returns an
    # array of length 0 if the underlying generic declaration declares no type
    # variables.
    # 
    # @return an array of {@code TypeVariable} objects that represent
    # the type variables declared by this generic declaration
    # @throws GenericSignatureFormatError if the generic
    # signature of this generic declaration does not conform to
    # the format specified in the Java Virtual Machine Specification,
    # 3rd edition
    # @since 1.5
    def get_type_parameters
      if (!(get_generic_signature).nil?)
        return get_generic_info.get_type_parameters
      else
        return Array.typed(TypeVariable).new(0) { nil }
      end
    end
    
    typesig { [] }
    # Returns a {@code Class} object that represents the formal return type
    # of the method represented by this {@code Method} object.
    # 
    # @return the return type for the method this object represents
    def get_return_type
      return @return_type
    end
    
    typesig { [] }
    # Returns a {@code Type} object that represents the formal return
    # type of the method represented by this {@code Method} object.
    # 
    # <p>If the return type is a parameterized type,
    # the {@code Type} object returned must accurately reflect
    # the actual type parameters used in the source code.
    # 
    # <p>If the return type is a type variable or a parameterized type, it
    # is created. Otherwise, it is resolved.
    # 
    # @return  a {@code Type} object that represents the formal return
    # type of the underlying  method
    # @throws GenericSignatureFormatError
    # if the generic method signature does not conform to the format
    # specified in the Java Virtual Machine Specification, 3rd edition
    # @throws TypeNotPresentException if the underlying method's
    # return type refers to a non-existent type declaration
    # @throws MalformedParameterizedTypeException if the
    # underlying method's return typed refers to a parameterized
    # type that cannot be instantiated for any reason
    # @since 1.5
    def get_generic_return_type
      if (!(get_generic_signature).nil?)
        return get_generic_info.get_return_type
      else
        return get_return_type
      end
    end
    
    typesig { [] }
    # Returns an array of {@code Class} objects that represent the formal
    # parameter types, in declaration order, of the method
    # represented by this {@code Method} object.  Returns an array of length
    # 0 if the underlying method takes no parameters.
    # 
    # @return the parameter types for the method this object
    # represents
    def get_parameter_types
      return @parameter_types.clone
    end
    
    typesig { [] }
    # Returns an array of {@code Type} objects that represent the formal
    # parameter types, in declaration order, of the method represented by
    # this {@code Method} object. Returns an array of length 0 if the
    # underlying method takes no parameters.
    # 
    # <p>If a formal parameter type is a parameterized type,
    # the {@code Type} object returned for it must accurately reflect
    # the actual type parameters used in the source code.
    # 
    # <p>If a formal parameter type is a type variable or a parameterized
    # type, it is created. Otherwise, it is resolved.
    # 
    # @return an array of Types that represent the formal
    # parameter types of the underlying method, in declaration order
    # @throws GenericSignatureFormatError
    # if the generic method signature does not conform to the format
    # specified in the Java Virtual Machine Specification, 3rd edition
    # @throws TypeNotPresentException if any of the parameter
    # types of the underlying method refers to a non-existent type
    # declaration
    # @throws MalformedParameterizedTypeException if any of
    # the underlying method's parameter types refer to a parameterized
    # type that cannot be instantiated for any reason
    # @since 1.5
    def get_generic_parameter_types
      if (!(get_generic_signature).nil?)
        return get_generic_info.get_parameter_types
      else
        return get_parameter_types
      end
    end
    
    typesig { [] }
    # Returns an array of {@code Class} objects that represent
    # the types of the exceptions declared to be thrown
    # by the underlying method
    # represented by this {@code Method} object.  Returns an array of length
    # 0 if the method declares no exceptions in its {@code throws} clause.
    # 
    # @return the exception types declared as being thrown by the
    # method this object represents
    def get_exception_types
      return @exception_types.clone
    end
    
    typesig { [] }
    # Returns an array of {@code Type} objects that represent the
    # exceptions declared to be thrown by this {@code Method} object.
    # Returns an array of length 0 if the underlying method declares
    # no exceptions in its {@code throws} clause.
    # 
    # <p>If an exception type is a parameterized type, the {@code Type}
    # object returned for it must accurately reflect the actual type
    # parameters used in the source code.
    # 
    # <p>If an exception type is a type variable or a parameterized
    # type, it is created. Otherwise, it is resolved.
    # 
    # @return an array of Types that represent the exception types
    # thrown by the underlying method
    # @throws GenericSignatureFormatError
    # if the generic method signature does not conform to the format
    # specified in the Java Virtual Machine Specification, 3rd edition
    # @throws TypeNotPresentException if the underlying method's
    # {@code throws} clause refers to a non-existent type declaration
    # @throws MalformedParameterizedTypeException if
    # the underlying method's {@code throws} clause refers to a
    # parameterized type that cannot be instantiated for any reason
    # @since 1.5
    def get_generic_exception_types
      result = nil
      if (!(get_generic_signature).nil? && ((result = get_generic_info.get_exception_types).attr_length > 0))
        return result
      else
        return get_exception_types
      end
    end
    
    typesig { [Object] }
    # Compares this {@code Method} against the specified object.  Returns
    # true if the objects are the same.  Two {@code Methods} are the same if
    # they were declared by the same class and have the same name
    # and formal parameter types and return type.
    def ==(obj)
      if (!(obj).nil? && obj.is_a?(Method))
        other = obj
        if (((get_declaring_class).equal?(other.get_declaring_class)) && ((get_name).equal?(other.get_name)))
          if (!(@return_type == other.get_return_type))
            return false
          end
          # Avoid unnecessary cloning
          params1 = @parameter_types
          params2 = other.attr_parameter_types
          if ((params1.attr_length).equal?(params2.attr_length))
            i = 0
            while i < params1.attr_length
              if (!(params1[i]).equal?(params2[i]))
                return false
              end
              i += 1
            end
            return true
          end
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns a hashcode for this {@code Method}.  The hashcode is computed
    # as the exclusive-or of the hashcodes for the underlying
    # method's declaring class name and the method's name.
    def hash_code
      return get_declaring_class.get_name.hash_code ^ get_name.hash_code
    end
    
    typesig { [] }
    # Returns a string describing this {@code Method}.  The string is
    # formatted as the method access modifiers, if any, followed by
    # the method return type, followed by a space, followed by the
    # class declaring the method, followed by a period, followed by
    # the method name, followed by a parenthesized, comma-separated
    # list of the method's formal parameter types. If the method
    # throws checked exceptions, the parameter list is followed by a
    # space, followed by the word throws followed by a
    # comma-separated list of the thrown exception types.
    # For example:
    # <pre>
    # public boolean java.lang.Object.equals(java.lang.Object)
    # </pre>
    # 
    # <p>The access modifiers are placed in canonical order as
    # specified by "The Java Language Specification".  This is
    # {@code public}, {@code protected} or {@code private} first,
    # and then other modifiers in the following order:
    # {@code abstract}, {@code static}, {@code final},
    # {@code synchronized}, {@code native}.
    def to_s
      begin
        sb = StringBuffer.new
        mod = get_modifiers & LANGUAGE_MODIFIERS
        if (!(mod).equal?(0))
          sb.append(RJava.cast_to_string(Modifier.to_s(mod)) + " ")
        end
        sb.append(RJava.cast_to_string(Field.get_type_name(get_return_type)) + " ")
        sb.append(RJava.cast_to_string(Field.get_type_name(get_declaring_class)) + ".")
        sb.append(RJava.cast_to_string(get_name) + "(")
        params = @parameter_types # avoid clone
        j = 0
        while j < params.attr_length
          sb.append(Field.get_type_name(params[j]))
          if (j < (params.attr_length - 1))
            sb.append(",")
          end
          j += 1
        end
        sb.append(")")
        exceptions = @exception_types # avoid clone
        if (exceptions.attr_length > 0)
          sb.append(" throws ")
          k = 0
          while k < exceptions.attr_length
            sb.append(exceptions[k].get_name)
            if (k < (exceptions.attr_length - 1))
              sb.append(",")
            end
            k += 1
          end
        end
        return sb.to_s
      rescue JavaException => e
        return "<" + RJava.cast_to_string(e) + ">"
      end
    end
    
    typesig { [] }
    # Returns a string describing this {@code Method}, including
    # type parameters.  The string is formatted as the method access
    # modifiers, if any, followed by an angle-bracketed
    # comma-separated list of the method's type parameters, if any,
    # followed by the method's generic return type, followed by a
    # space, followed by the class declaring the method, followed by
    # a period, followed by the method name, followed by a
    # parenthesized, comma-separated list of the method's generic
    # formal parameter types.
    # 
    # A space is used to separate access modifiers from one another
    # and from the type parameters or return type.  If there are no
    # type parameters, the type parameter list is elided; if the type
    # parameter list is present, a space separates the list from the
    # class name.  If the method is declared to throw exceptions, the
    # parameter list is followed by a space, followed by the word
    # throws followed by a comma-separated list of the generic thrown
    # exception types.  If there are no type parameters, the type
    # parameter list is elided.
    # 
    # <p>The access modifiers are placed in canonical order as
    # specified by "The Java Language Specification".  This is
    # {@code public}, {@code protected} or {@code private} first,
    # and then other modifiers in the following order:
    # {@code abstract}, {@code static}, {@code final},
    # {@code synchronized} {@code native}.
    # 
    # @return a string describing this {@code Method},
    # include type parameters
    # 
    # @since 1.5
    def to_generic_string
      begin
        sb = StringBuilder.new
        mod = get_modifiers & LANGUAGE_MODIFIERS
        if (!(mod).equal?(0))
          sb.append(RJava.cast_to_string(Modifier.to_s(mod)) + " ")
        end
        typeparms = get_type_parameters
        if (typeparms.attr_length > 0)
          first = true
          sb.append("<")
          typeparms.each do |typeparm|
            if (!first)
              sb.append(",")
            end
            # Class objects can't occur here; no need to test
            # and call Class.getName().
            sb.append(typeparm.to_s)
            first = false
          end
          sb.append("> ")
        end
        gen_ret_type = get_generic_return_type
        sb.append(RJava.cast_to_string(((gen_ret_type.is_a?(Class)) ? Field.get_type_name(gen_ret_type) : gen_ret_type.to_s)) + " ")
        sb.append(RJava.cast_to_string(Field.get_type_name(get_declaring_class)) + ".")
        sb.append(RJava.cast_to_string(get_name) + "(")
        params = get_generic_parameter_types
        j = 0
        while j < params.attr_length
          param = (params[j].is_a?(Class)) ? Field.get_type_name(params[j]) : (params[j].to_s)
          sb.append(param)
          if (j < (params.attr_length - 1))
            sb.append(",")
          end
          j += 1
        end
        sb.append(")")
        exceptions = get_generic_exception_types
        if (exceptions.attr_length > 0)
          sb.append(" throws ")
          k = 0
          while k < exceptions.attr_length
            sb.append((exceptions[k].is_a?(Class)) ? (exceptions[k]).get_name : exceptions[k].to_s)
            if (k < (exceptions.attr_length - 1))
              sb.append(",")
            end
            k += 1
          end
        end
        return sb.to_s
      rescue JavaException => e
        return "<" + RJava.cast_to_string(e) + ">"
      end
    end
    
    typesig { [Object, Vararg.new(Object)] }
    # Invokes the underlying method represented by this {@code Method}
    # object, on the specified object with the specified parameters.
    # Individual parameters are automatically unwrapped to match
    # primitive formal parameters, and both primitive and reference
    # parameters are subject to method invocation conversions as
    # necessary.
    # 
    # <p>If the underlying method is static, then the specified {@code obj}
    # argument is ignored. It may be null.
    # 
    # <p>If the number of formal parameters required by the underlying method is
    # 0, the supplied {@code args} array may be of length 0 or null.
    # 
    # <p>If the underlying method is an instance method, it is invoked
    # using dynamic method lookup as documented in The Java Language
    # Specification, Second Edition, section 15.12.4.4; in particular,
    # overriding based on the runtime type of the target object will occur.
    # 
    # <p>If the underlying method is static, the class that declared
    # the method is initialized if it has not already been initialized.
    # 
    # <p>If the method completes normally, the value it returns is
    # returned to the caller of invoke; if the value has a primitive
    # type, it is first appropriately wrapped in an object. However,
    # if the value has the type of an array of a primitive type, the
    # elements of the array are <i>not</i> wrapped in objects; in
    # other words, an array of primitive type is returned.  If the
    # underlying method return type is void, the invocation returns
    # null.
    # 
    # @param obj  the object the underlying method is invoked from
    # @param args the arguments used for the method call
    # @return the result of dispatching the method represented by
    # this object on {@code obj} with parameters
    # {@code args}
    # 
    # @exception IllegalAccessException    if this {@code Method} object
    # enforces Java language access control and the underlying
    # method is inaccessible.
    # @exception IllegalArgumentException  if the method is an
    # instance method and the specified object argument
    # is not an instance of the class or interface
    # declaring the underlying method (or of a subclass
    # or implementor thereof); if the number of actual
    # and formal parameters differ; if an unwrapping
    # conversion for primitive arguments fails; or if,
    # after possible unwrapping, a parameter value
    # cannot be converted to the corresponding formal
    # parameter type by a method invocation conversion.
    # @exception InvocationTargetException if the underlying method
    # throws an exception.
    # @exception NullPointerException      if the specified object is null
    # and the method is an instance method.
    # @exception ExceptionInInitializerError if the initialization
    # provoked by this method fails.
    def invoke(obj, *args)
      if (!self.attr_override)
        if (!Reflection.quick_check_member_access(@clazz, @modifiers))
          caller = Reflection.get_caller_class(1)
          target_class = (((obj).nil? || !Modifier.is_protected(@modifiers)) ? @clazz : obj.get_class)
          cached = false
          synchronized((self)) do
            cached = ((@security_check_cache).equal?(caller)) && ((@security_check_target_class_cache).equal?(target_class))
          end
          if (!cached)
            Reflection.ensure_member_access(caller, @clazz, obj, @modifiers)
            synchronized((self)) do
              @security_check_cache = caller
              @security_check_target_class_cache = target_class
            end
          end
        end
      end
      if ((@method_accessor).nil?)
        acquire_method_accessor
      end
      return @method_accessor.invoke(obj, args)
    end
    
    typesig { [Object, Array.typed(Object)] }
    def invoke(obj, args)
      invoke(obj, *args)
    end
    
    typesig { [] }
    # Returns {@code true} if this method is a bridge
    # method; returns {@code false} otherwise.
    # 
    # @return true if and only if this method is a bridge
    # method as defined by the Java Language Specification.
    # @since 1.5
    def is_bridge
      return !((get_modifiers & Modifier::BRIDGE)).equal?(0)
    end
    
    typesig { [] }
    # Returns {@code true} if this method was declared to take
    # a variable number of arguments; returns {@code false}
    # otherwise.
    # 
    # @return {@code true} if an only if this method was declared to
    # take a variable number of arguments.
    # @since 1.5
    def is_var_args
      return !((get_modifiers & Modifier::VARARGS)).equal?(0)
    end
    
    typesig { [] }
    # Returns {@code true} if this method is a synthetic
    # method; returns {@code false} otherwise.
    # 
    # @return true if and only if this method is a synthetic
    # method as defined by the Java Language Specification.
    # @since 1.5
    def is_synthetic
      return Modifier.is_synthetic(get_modifiers)
    end
    
    typesig { [] }
    # NOTE that there is no synchronization used here. It is correct
    # (though not efficient) to generate more than one MethodAccessor
    # for a given Method. However, avoiding synchronization will
    # probably make the implementation more scalable.
    def acquire_method_accessor
      # First check to see if one has been created yet, and take it
      # if so
      tmp = nil
      if (!(@root).nil?)
        tmp = @root.get_method_accessor
      end
      if (!(tmp).nil?)
        @method_accessor = tmp
        return
      end
      # Otherwise fabricate one and propagate it up to the root
      tmp = self.attr_reflection_factory.new_method_accessor(self)
      set_method_accessor(tmp)
    end
    
    typesig { [] }
    # Returns MethodAccessor for this Method object, not looking up
    # the chain to the root
    def get_method_accessor
      return @method_accessor
    end
    
    typesig { [MethodAccessor] }
    # Sets the MethodAccessor for this Method object and
    # (recursively) its root
    def set_method_accessor(accessor)
      @method_accessor = accessor
      # Propagate up
      if (!(@root).nil?)
        @root.set_method_accessor(accessor)
      end
    end
    
    typesig { [Class] }
    # @throws NullPointerException {@inheritDoc}
    # @since 1.5
    def get_annotation(annotation_class)
      if ((annotation_class).nil?)
        raise NullPointerException.new
      end
      return declared_annotations.get(annotation_class)
    end
    
    class_module.module_eval {
      const_set_lazy(:EMPTY_ANNOTATION_ARRAY) { Array.typed(Annotation).new(0) { nil } }
      const_attr_reader  :EMPTY_ANNOTATION_ARRAY
    }
    
    typesig { [] }
    # @since 1.5
    def get_declared_annotations
      return declared_annotations.values.to_array(EMPTY_ANNOTATION_ARRAY)
    end
    
    attr_accessor :declared_annotations
    alias_method :attr_declared_annotations, :declared_annotations
    undef_method :declared_annotations
    alias_method :attr_declared_annotations=, :declared_annotations=
    undef_method :declared_annotations=
    
    typesig { [] }
    def declared_annotations
      synchronized(self) do
        if ((@declared_annotations).nil?)
          @declared_annotations = AnnotationParser.parse_annotations(@annotations, Sun::Misc::SharedSecrets.get_java_lang_access.get_constant_pool(get_declaring_class), get_declaring_class)
        end
        return @declared_annotations
      end
    end
    
    typesig { [] }
    # Returns the default value for the annotation member represented by
    # this {@code Method} instance.  If the member is of a primitive type,
    # an instance of the corresponding wrapper type is returned. Returns
    # null if no default is associated with the member, or if the method
    # instance does not represent a declared member of an annotation type.
    # 
    # @return the default value for the annotation member represented
    # by this {@code Method} instance.
    # @throws TypeNotPresentException if the annotation is of type
    # {@link Class} and no definition can be found for the
    # default class value.
    # @since  1.5
    def get_default_value
      if ((@annotation_default).nil?)
        return nil
      end
      member_type = AnnotationType.invocation_handler_return_type(get_return_type)
      result = AnnotationParser.parse_member_value(member_type, ByteBuffer.wrap(@annotation_default), Sun::Misc::SharedSecrets.get_java_lang_access.get_constant_pool(get_declaring_class), get_declaring_class)
      if (result.is_a?(Sun::Reflect::Annotation::ExceptionProxy))
        raise AnnotationFormatError.new("Invalid default: " + RJava.cast_to_string(self))
      end
      return result
    end
    
    typesig { [] }
    # Returns an array of arrays that represent the annotations on the formal
    # parameters, in declaration order, of the method represented by
    # this {@code Method} object. (Returns an array of length zero if the
    # underlying method is parameterless.  If the method has one or more
    # parameters, a nested array of length zero is returned for each parameter
    # with no annotations.) The annotation objects contained in the returned
    # arrays are serializable.  The caller of this method is free to modify
    # the returned arrays; it will have no effect on the arrays returned to
    # other callers.
    # 
    # @return an array of arrays that represent the annotations on the formal
    # parameters, in declaration order, of the method represented by this
    # Method object
    # @since 1.5
    def get_parameter_annotations
      num_parameters = @parameter_types.attr_length
      if ((@parameter_annotations).nil?)
        return Array.typed(Array.typed(Annotation)).new(num_parameters) { Array.typed(Annotation).new(0) { nil } }
      end
      result = AnnotationParser.parse_parameter_annotations(@parameter_annotations, Sun::Misc::SharedSecrets.get_java_lang_access.get_constant_pool(get_declaring_class), get_declaring_class)
      if (!(result.attr_length).equal?(num_parameters))
        raise Java::Lang::Annotation::AnnotationFormatError.new("Parameter annotations don't match number of parameters")
      end
      return result
    end
    
    private
    alias_method :initialize__method, :initialize
  end
  
end
