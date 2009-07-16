require "rjava"

# 
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
  module ConstructorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
      include_const ::Sun::Reflect, :ConstructorAccessor
      include_const ::Sun::Reflect, :Reflection
      include_const ::Sun::Reflect::Generics::Repository, :ConstructorRepository
      include_const ::Sun::Reflect::Generics::Factory, :CoreReflectionFactory
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Scope, :ConstructorScope
      include_const ::Java::Lang::Annotation, :Annotation
      include_const ::Java::Util, :Map
      include_const ::Sun::Reflect::Annotation, :AnnotationParser
      include_const ::Java::Lang::Annotation, :AnnotationFormatError
      include_const ::Java::Lang::Reflect, :Modifier
    }
  end
  
  # 
  # {@code Constructor} provides information about, and access to, a single
  # constructor for a class.
  # 
  # <p>{@code Constructor} permits widening conversions to occur when matching the
  # actual parameters to newInstance() with the underlying
  # constructor's formal parameters, but throws an
  # {@code IllegalArgumentException} if a narrowing conversion would occur.
  # 
  # @param <T> the class in which the constructor is declared
  # 
  # @see Member
  # @see java.lang.Class
  # @see java.lang.Class#getConstructors()
  # @see java.lang.Class#getConstructor(Class[])
  # @see java.lang.Class#getDeclaredConstructors()
  # 
  # @author      Kenneth Russell
  # @author      Nakul Saraiya
  class Constructor < ConstructorImports.const_get :AccessibleObject
    include_class_members ConstructorImports
    include GenericDeclaration
    include Member
    
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
    
    # For non-public members or members in package-private classes,
    # it is necessary to perform somewhat expensive security checks.
    # If the security check succeeds for a given class, it will
    # always succeed (it is not affected by the granting or revoking
    # of permissions); we speed up the check in the common case by
    # remembering the last Class for which the check succeeded.
    attr_accessor :security_check_cache
    alias_method :attr_security_check_cache, :security_check_cache
    undef_method :security_check_cache
    alias_method :attr_security_check_cache=, :security_check_cache=
    undef_method :security_check_cache=
    
    class_module.module_eval {
      # Modifiers that can be applied to a constructor in source code
      const_set_lazy(:LANGUAGE_MODIFIERS) { Modifier::PUBLIC | Modifier::PROTECTED | Modifier::PRIVATE }
      const_attr_reader  :LANGUAGE_MODIFIERS
    }
    
    typesig { [] }
    # Generics infrastructure
    # Accessor for factory
    def get_factory
      # create scope and factory
      return CoreReflectionFactory.make(self, ConstructorScope.make(self))
    end
    
    typesig { [] }
    # Accessor for generic info repository
    def get_generic_info
      # lazily initialize repository if necessary
      if ((@generic_info).nil?)
        # create and cache generic info repository
        @generic_info = ConstructorRepository.make(get_signature, get_factory)
      end
      return @generic_info # return cached repository
    end
    
    attr_accessor :constructor_accessor
    alias_method :attr_constructor_accessor, :constructor_accessor
    undef_method :constructor_accessor
    alias_method :attr_constructor_accessor=, :constructor_accessor=
    undef_method :constructor_accessor=
    
    # For sharing of ConstructorAccessors. This branching structure
    # is currently only two levels deep (i.e., one root Constructor
    # and potentially many Constructor objects pointing to it.)
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    typesig { [Class, Array.typed(Class), Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # 
    # Package-private constructor used by ReflectAccess to enable
    # instantiation of these objects in Java code from the java.lang
    # package via sun.reflect.LangReflectAccess.
    def initialize(declaring_class, parameter_types, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations)
      @clazz = nil
      @slot = 0
      @parameter_types = nil
      @exception_types = nil
      @modifiers = 0
      @signature = nil
      @generic_info = nil
      @annotations = nil
      @parameter_annotations = nil
      @security_check_cache = nil
      @constructor_accessor = nil
      @root = nil
      @declared_annotations = nil
      super()
      @clazz = declaring_class
      @parameter_types = parameter_types
      @exception_types = checked_exceptions
      @modifiers = modifiers
      @slot = slot
      @signature = signature
      @annotations = annotations
      @parameter_annotations = parameter_annotations
    end
    
    typesig { [] }
    # 
    # Package-private routine (exposed to java.lang.Class via
    # ReflectAccess) which returns a copy of this Constructor. The copy's
    # "root" field points to this Constructor.
    def copy
      # This routine enables sharing of ConstructorAccessor objects
      # among Constructor objects which refer to the same underlying
      # method in the VM. (All of this contortion is only necessary
      # because of the "accessibility" bit in AccessibleObject,
      # which implicitly requires that new java.lang.reflect
      # objects be fabricated for each reflective call on Class
      # objects.)
      res = Constructor.new(@clazz, @parameter_types, @exception_types, @modifiers, @slot, @signature, @annotations, @parameter_annotations)
      res.attr_root = self
      # Might as well eagerly propagate this if already present
      res.attr_constructor_accessor = @constructor_accessor
      return res
    end
    
    typesig { [] }
    # 
    # Returns the {@code Class} object representing the class that declares
    # the constructor represented by this {@code Constructor} object.
    def get_declaring_class
      return @clazz
    end
    
    typesig { [] }
    # 
    # Returns the name of this constructor, as a string.  This is
    # always the same as the simple name of the constructor's declaring
    # class.
    def get_name
      return get_declaring_class.get_name
    end
    
    typesig { [] }
    # 
    # Returns the Java language modifiers for the constructor
    # represented by this {@code Constructor} object, as an integer. The
    # {@code Modifier} class should be used to decode the modifiers.
    # 
    # @see Modifier
    def get_modifiers
      return @modifiers
    end
    
    typesig { [] }
    # 
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
      if (!(get_signature).nil?)
        return get_generic_info.get_type_parameters
      else
        return Array.typed(TypeVariable).new(0) { nil }
      end
    end
    
    typesig { [] }
    # 
    # Returns an array of {@code Class} objects that represent the formal
    # parameter types, in declaration order, of the constructor
    # represented by this {@code Constructor} object.  Returns an array of
    # length 0 if the underlying constructor takes no parameters.
    # 
    # @return the parameter types for the constructor this object
    # represents
    def get_parameter_types
      return @parameter_types.clone
    end
    
    typesig { [] }
    # 
    # Returns an array of {@code Type} objects that represent the formal
    # parameter types, in declaration order, of the method represented by
    # this {@code Constructor} object. Returns an array of length 0 if the
    # underlying method takes no parameters.
    # 
    # <p>If a formal parameter type is a parameterized type,
    # the {@code Type} object returned for it must accurately reflect
    # the actual type parameters used in the source code.
    # 
    # <p>If a formal parameter type is a type variable or a parameterized
    # type, it is created. Otherwise, it is resolved.
    # 
    # @return an array of {@code Type}s that represent the formal
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
      if (!(get_signature).nil?)
        return get_generic_info.get_parameter_types
      else
        return get_parameter_types
      end
    end
    
    typesig { [] }
    # 
    # Returns an array of {@code Class} objects that represent the types
    # of exceptions declared to be thrown by the underlying constructor
    # represented by this {@code Constructor} object.  Returns an array of
    # length 0 if the constructor declares no exceptions in its {@code throws} clause.
    # 
    # @return the exception types declared as being thrown by the
    # constructor this object represents
    def get_exception_types
      return @exception_types.clone
    end
    
    typesig { [] }
    # 
    # Returns an array of {@code Type} objects that represent the
    # exceptions declared to be thrown by this {@code Constructor} object.
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
      if (!(get_signature).nil? && ((result = get_generic_info.get_exception_types).attr_length > 0))
        return result
      else
        return get_exception_types
      end
    end
    
    typesig { [Object] }
    # 
    # Compares this {@code Constructor} against the specified object.
    # Returns true if the objects are the same.  Two {@code Constructor} objects are
    # the same if they were declared by the same class and have the
    # same formal parameter types.
    def equals(obj)
      if (!(obj).nil? && obj.is_a?(Constructor))
        other = obj
        if ((get_declaring_class).equal?(other.get_declaring_class))
          # Avoid unnecessary cloning
          params1 = @parameter_types
          params2 = other.attr_parameter_types
          if ((params1.attr_length).equal?(params2.attr_length))
            i = 0
            while i < params1.attr_length
              if (!(params1[i]).equal?(params2[i]))
                return false
              end
              ((i += 1) - 1)
            end
            return true
          end
        end
      end
      return false
    end
    
    typesig { [] }
    # 
    # Returns a hashcode for this {@code Constructor}. The hashcode is
    # the same as the hashcode for the underlying constructor's
    # declaring class name.
    def hash_code
      return get_declaring_class.get_name.hash_code
    end
    
    typesig { [] }
    # 
    # Returns a string describing this {@code Constructor}.  The string is
    # formatted as the constructor access modifiers, if any,
    # followed by the fully-qualified name of the declaring class,
    # followed by a parenthesized, comma-separated list of the
    # constructor's formal parameter types.  For example:
    # <pre>
    # public java.util.Hashtable(int,float)
    # </pre>
    # 
    # <p>The only possible modifiers for constructors are the access
    # modifiers {@code public}, {@code protected} or
    # {@code private}.  Only one of these may appear, or none if the
    # constructor has default (package) access.
    def to_s
      begin
        sb = StringBuffer.new
        mod = get_modifiers & LANGUAGE_MODIFIERS
        if (!(mod).equal?(0))
          sb.append((Modifier.to_s(mod)).to_s + " ")
        end
        sb.append(Field.get_type_name(get_declaring_class))
        sb.append("(")
        params = @parameter_types # avoid clone
        j = 0
        while j < params.attr_length
          sb.append(Field.get_type_name(params[j]))
          if (j < (params.attr_length - 1))
            sb.append(",")
          end
          ((j += 1) - 1)
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
            ((k += 1) - 1)
          end
        end
        return sb.to_s
      rescue Exception => e
        return "<" + (e).to_s + ">"
      end
    end
    
    typesig { [] }
    # 
    # Returns a string describing this {@code Constructor},
    # including type parameters.  The string is formatted as the
    # constructor access modifiers, if any, followed by an
    # angle-bracketed comma separated list of the constructor's type
    # parameters, if any, followed by the fully-qualified name of the
    # declaring class, followed by a parenthesized, comma-separated
    # list of the constructor's generic formal parameter types.
    # 
    # A space is used to separate access modifiers from one another
    # and from the type parameters or return type.  If there are no
    # type parameters, the type parameter list is elided; if the type
    # parameter list is present, a space separates the list from the
    # class name.  If the constructor is declared to throw
    # exceptions, the parameter list is followed by a space, followed
    # by the word "{@code throws}" followed by a
    # comma-separated list of the thrown exception types.
    # 
    # <p>The only possible modifiers for constructors are the access
    # modifiers {@code public}, {@code protected} or
    # {@code private}.  Only one of these may appear, or none if the
    # constructor has default (package) access.
    # 
    # @return a string describing this {@code Constructor},
    # include type parameters
    # 
    # @since 1.5
    def to_generic_string
      begin
        sb = StringBuilder.new
        mod = get_modifiers & LANGUAGE_MODIFIERS
        if (!(mod).equal?(0))
          sb.append((Modifier.to_s(mod)).to_s + " ")
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
        sb.append(Field.get_type_name(get_declaring_class))
        sb.append("(")
        params = get_generic_parameter_types
        j = 0
        while j < params.attr_length
          param = (params[j].is_a?(Class)) ? Field.get_type_name(params[j]) : (params[j].to_s)
          sb.append(param)
          if (j < (params.attr_length - 1))
            sb.append(",")
          end
          ((j += 1) - 1)
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
            ((k += 1) - 1)
          end
        end
        return sb.to_s
      rescue Exception => e
        return "<" + (e).to_s + ">"
      end
    end
    
    typesig { [Object] }
    # 
    # Uses the constructor represented by this {@code Constructor} object to
    # create and initialize a new instance of the constructor's
    # declaring class, with the specified initialization parameters.
    # Individual parameters are automatically unwrapped to match
    # primitive formal parameters, and both primitive and reference
    # parameters are subject to method invocation conversions as necessary.
    # 
    # <p>If the number of formal parameters required by the underlying constructor
    # is 0, the supplied {@code initargs} array may be of length 0 or null.
    # 
    # <p>If the constructor's declaring class is an inner class in a
    # non-static context, the first argument to the constructor needs
    # to be the enclosing instance; see <i>The Java Language
    # Specification</i>, section 15.9.3.
    # 
    # <p>If the required access and argument checks succeed and the
    # instantiation will proceed, the constructor's declaring class
    # is initialized if it has not already been initialized.
    # 
    # <p>If the constructor completes normally, returns the newly
    # created and initialized instance.
    # 
    # @param initargs array of objects to be passed as arguments to
    # the constructor call; values of primitive types are wrapped in
    # a wrapper object of the appropriate type (e.g. a {@code float}
    # in a {@link java.lang.Float Float})
    # 
    # @return a new object created by calling the constructor
    # this object represents
    # 
    # @exception IllegalAccessException    if this {@code Constructor} object
    # enforces Java language access control and the underlying
    # constructor is inaccessible.
    # @exception IllegalArgumentException  if the number of actual
    # and formal parameters differ; if an unwrapping
    # conversion for primitive arguments fails; or if,
    # after possible unwrapping, a parameter value
    # cannot be converted to the corresponding formal
    # parameter type by a method invocation conversion; if
    # this constructor pertains to an enum type.
    # @exception InstantiationException    if the class that declares the
    # underlying constructor represents an abstract class.
    # @exception InvocationTargetException if the underlying constructor
    # throws an exception.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    def new_instance(*initargs)
      if (!self.attr_override)
        if (!Reflection.quick_check_member_access(@clazz, @modifiers))
          caller = Reflection.get_caller_class(2)
          if (!(@security_check_cache).equal?(caller))
            Reflection.ensure_member_access(caller, @clazz, nil, @modifiers)
            @security_check_cache = caller
          end
        end
      end
      if (!((@clazz.get_modifiers & Modifier::ENUM)).equal?(0))
        raise IllegalArgumentException.new("Cannot reflectively create enum objects")
      end
      if ((@constructor_accessor).nil?)
        acquire_constructor_accessor
      end
      return @constructor_accessor.new_instance(initargs)
    end
    
    typesig { [] }
    # 
    # Returns {@code true} if this constructor was declared to take
    # a variable number of arguments; returns {@code false}
    # otherwise.
    # 
    # @return {@code true} if an only if this constructor was declared to
    # take a variable number of arguments.
    # @since 1.5
    def is_var_args
      return !((get_modifiers & Modifier::VARARGS)).equal?(0)
    end
    
    typesig { [] }
    # 
    # Returns {@code true} if this constructor is a synthetic
    # constructor; returns {@code false} otherwise.
    # 
    # @return true if and only if this constructor is a synthetic
    # constructor as defined by the Java Language Specification.
    # @since 1.5
    def is_synthetic
      return Modifier.is_synthetic(get_modifiers)
    end
    
    typesig { [] }
    # NOTE that there is no synchronization used here. It is correct
    # (though not efficient) to generate more than one
    # ConstructorAccessor for a given Constructor. However, avoiding
    # synchronization will probably make the implementation more
    # scalable.
    def acquire_constructor_accessor
      # First check to see if one has been created yet, and take it
      # if so.
      tmp = nil
      if (!(@root).nil?)
        tmp = @root.get_constructor_accessor
      end
      if (!(tmp).nil?)
        @constructor_accessor = tmp
        return
      end
      # Otherwise fabricate one and propagate it up to the root
      tmp = self.attr_reflection_factory.new_constructor_accessor(self)
      set_constructor_accessor(tmp)
    end
    
    typesig { [] }
    # Returns ConstructorAccessor for this Constructor object, not
    # looking up the chain to the root
    def get_constructor_accessor
      return @constructor_accessor
    end
    
    typesig { [ConstructorAccessor] }
    # Sets the ConstructorAccessor for this Constructor object and
    # (recursively) its root
    def set_constructor_accessor(accessor)
      @constructor_accessor = accessor
      # Propagate up
      if (!(@root).nil?)
        @root.set_constructor_accessor(accessor)
      end
    end
    
    typesig { [] }
    def get_slot
      return @slot
    end
    
    typesig { [] }
    def get_signature
      return @signature
    end
    
    typesig { [] }
    def get_raw_annotations
      return @annotations
    end
    
    typesig { [] }
    def get_raw_parameter_annotations
      return @parameter_annotations
    end
    
    typesig { [Class] }
    # 
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
    # 
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
    # 
    # Returns an array of arrays that represent the annotations on the formal
    # parameters, in declaration order, of the method represented by
    # this {@code Constructor} object. (Returns an array of length zero if the
    # underlying method is parameterless.  If the method has one or more
    # parameters, a nested array of length zero is returned for each parameter
    # with no annotations.) The annotation objects contained in the returned
    # arrays are serializable.  The caller of this method is free to modify
    # the returned arrays; it will have no effect on the arrays returned to
    # other callers.
    # 
    # @return an array of arrays that represent the annotations on the formal
    # parameters, in declaration order, of the method represented by this
    # Constructor object
    # @since 1.5
    def get_parameter_annotations
      num_parameters = @parameter_types.attr_length
      if ((@parameter_annotations).nil?)
        return Array.typed(Annotation).new(num_parameters) { Array.typed(Annotation).new(0) { nil } }
      end
      result = AnnotationParser.parse_parameter_annotations(@parameter_annotations, Sun::Misc::SharedSecrets.get_java_lang_access.get_constant_pool(get_declaring_class), get_declaring_class)
      if (!(result.attr_length).equal?(num_parameters))
        declaring_class = get_declaring_class
        if (declaring_class.is_enum || declaring_class.is_anonymous_class || declaring_class.is_local_class)
        # Can't do reliable parameter counting
        else
          # top-level
          # Check for the enclosing instance parameter for
          # non-static member classes
          if (!declaring_class.is_member_class || (declaring_class.is_member_class && (((declaring_class.get_modifiers & Modifier::STATIC)).equal?(0)) && !(result.attr_length + 1).equal?(num_parameters)))
            raise AnnotationFormatError.new("Parameter annotations don't match number of parameters")
          end
        end
      end
      return result
    end
    
    private
    alias_method :initialize__constructor, :initialize
  end
  
end
