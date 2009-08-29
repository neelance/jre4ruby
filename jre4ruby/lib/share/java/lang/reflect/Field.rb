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
  module FieldImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
      include_const ::Sun::Reflect, :FieldAccessor
      include_const ::Sun::Reflect, :Reflection
      include_const ::Sun::Reflect::Generics::Repository, :FieldRepository
      include_const ::Sun::Reflect::Generics::Factory, :CoreReflectionFactory
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Scope, :ClassScope
      include_const ::Java::Lang::Annotation, :Annotation
      include_const ::Java::Util, :Map
      include_const ::Sun::Reflect::Annotation, :AnnotationParser
    }
  end
  
  # A {@code Field} provides information about, and dynamic access to, a
  # single field of a class or an interface.  The reflected field may
  # be a class (static) field or an instance field.
  # 
  # <p>A {@code Field} permits widening conversions to occur during a get or
  # set access operation, but throws an {@code IllegalArgumentException} if a
  # narrowing conversion would occur.
  # 
  # @see Member
  # @see java.lang.Class
  # @see java.lang.Class#getFields()
  # @see java.lang.Class#getField(String)
  # @see java.lang.Class#getDeclaredFields()
  # @see java.lang.Class#getDeclaredField(String)
  # 
  # @author Kenneth Russell
  # @author Nakul Saraiya
  class Field < FieldImports.const_get :AccessibleObject
    include_class_members FieldImports
    overload_protected {
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
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
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
    
    # Cached field accessor created without override
    attr_accessor :field_accessor
    alias_method :attr_field_accessor, :field_accessor
    undef_method :field_accessor
    alias_method :attr_field_accessor=, :field_accessor=
    undef_method :field_accessor=
    
    # Cached field accessor created with override
    attr_accessor :override_field_accessor
    alias_method :attr_override_field_accessor, :override_field_accessor
    undef_method :override_field_accessor
    alias_method :attr_override_field_accessor=, :override_field_accessor=
    undef_method :override_field_accessor=
    
    # For sharing of FieldAccessors. This branching structure is
    # currently only two levels deep (i.e., one root Field and
    # potentially many Field objects pointing to it.)
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
    
    typesig { [] }
    # Generics infrastructure
    def get_generic_signature
      return @signature
    end
    
    typesig { [] }
    # Accessor for factory
    def get_factory
      c = get_declaring_class
      # create scope and factory
      return CoreReflectionFactory.make(c, ClassScope.make(c))
    end
    
    typesig { [] }
    # Accessor for generic info repository
    def get_generic_info
      # lazily initialize repository if necessary
      if ((@generic_info).nil?)
        # create and cache generic info repository
        @generic_info = FieldRepository.make(get_generic_signature, get_factory)
      end
      return @generic_info # return cached repository
    end
    
    typesig { [Class, String, Class, ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte)] }
    # Package-private constructor used by ReflectAccess to enable
    # instantiation of these objects in Java code from the java.lang
    # package via sun.reflect.LangReflectAccess.
    def initialize(declaring_class, name, type, modifiers, slot, signature, annotations)
      @clazz = nil
      @slot = 0
      @name = nil
      @type = nil
      @modifiers = 0
      @signature = nil
      @generic_info = nil
      @annotations = nil
      @field_accessor = nil
      @override_field_accessor = nil
      @root = nil
      @security_check_cache = nil
      @security_check_target_class_cache = nil
      @declared_annotations = nil
      super()
      @clazz = declaring_class
      @name = name
      @type = type
      @modifiers = modifiers
      @slot = slot
      @signature = signature
      @annotations = annotations
    end
    
    typesig { [] }
    # Package-private routine (exposed to java.lang.Class via
    # ReflectAccess) which returns a copy of this Field. The copy's
    # "root" field points to this Field.
    def copy
      # This routine enables sharing of FieldAccessor objects
      # among Field objects which refer to the same underlying
      # method in the VM. (All of this contortion is only necessary
      # because of the "accessibility" bit in AccessibleObject,
      # which implicitly requires that new java.lang.reflect
      # objects be fabricated for each reflective call on Class
      # objects.)
      res = Field.new(@clazz, @name, @type, @modifiers, @slot, @signature, @annotations)
      res.attr_root = self
      # Might as well eagerly propagate this if already present
      res.attr_field_accessor = @field_accessor
      res.attr_override_field_accessor = @override_field_accessor
      return res
    end
    
    typesig { [] }
    # Returns the {@code Class} object representing the class or interface
    # that declares the field represented by this {@code Field} object.
    def get_declaring_class
      return @clazz
    end
    
    typesig { [] }
    # Returns the name of the field represented by this {@code Field} object.
    def get_name
      return @name
    end
    
    typesig { [] }
    # Returns the Java language modifiers for the field represented
    # by this {@code Field} object, as an integer. The {@code Modifier} class should
    # be used to decode the modifiers.
    # 
    # @see Modifier
    def get_modifiers
      return @modifiers
    end
    
    typesig { [] }
    # Returns {@code true} if this field represents an element of
    # an enumerated type; returns {@code false} otherwise.
    # 
    # @return {@code true} if and only if this field represents an element of
    # an enumerated type.
    # @since 1.5
    def is_enum_constant
      return !((get_modifiers & Modifier::ENUM)).equal?(0)
    end
    
    typesig { [] }
    # Returns {@code true} if this field is a synthetic
    # field; returns {@code false} otherwise.
    # 
    # @return true if and only if this field is a synthetic
    # field as defined by the Java Language Specification.
    # @since 1.5
    def is_synthetic
      return Modifier.is_synthetic(get_modifiers)
    end
    
    typesig { [] }
    # Returns a {@code Class} object that identifies the
    # declared type for the field represented by this
    # {@code Field} object.
    # 
    # @return a {@code Class} object identifying the declared
    # type of the field represented by this object
    def get_type
      return @type
    end
    
    typesig { [] }
    # Returns a {@code Type} object that represents the declared type for
    # the field represented by this {@code Field} object.
    # 
    # <p>If the {@code Type} is a parameterized type, the
    # {@code Type} object returned must accurately reflect the
    # actual type parameters used in the source code.
    # 
    # <p>If the type of the underlying field is a type variable or a
    # parameterized type, it is created. Otherwise, it is resolved.
    # 
    # @return a {@code Type} object that represents the declared type for
    # the field represented by this {@code Field} object
    # @throws GenericSignatureFormatError if the generic field
    # signature does not conform to the format specified in the Java
    # Virtual Machine Specification, 3rd edition
    # @throws TypeNotPresentException if the generic type
    # signature of the underlying field refers to a non-existent
    # type declaration
    # @throws MalformedParameterizedTypeException if the generic
    # signature of the underlying field refers to a parameterized type
    # that cannot be instantiated for any reason
    # @since 1.5
    def get_generic_type
      if (!(get_generic_signature).nil?)
        return get_generic_info.get_generic_type
      else
        return get_type
      end
    end
    
    typesig { [Object] }
    # Compares this {@code Field} against the specified object.  Returns
    # true if the objects are the same.  Two {@code Field} objects are the same if
    # they were declared by the same class and have the same name
    # and type.
    def ==(obj)
      if (!(obj).nil? && obj.is_a?(Field))
        other = obj
        return ((get_declaring_class).equal?(other.get_declaring_class)) && ((get_name).equal?(other.get_name)) && ((get_type).equal?(other.get_type))
      end
      return false
    end
    
    typesig { [] }
    # Returns a hashcode for this {@code Field}.  This is computed as the
    # exclusive-or of the hashcodes for the underlying field's
    # declaring class name and its name.
    def hash_code
      return get_declaring_class.get_name.hash_code ^ get_name.hash_code
    end
    
    typesig { [] }
    # Returns a string describing this {@code Field}.  The format is
    # the access modifiers for the field, if any, followed
    # by the field type, followed by a space, followed by
    # the fully-qualified name of the class declaring the field,
    # followed by a period, followed by the name of the field.
    # For example:
    # <pre>
    # public static final int java.lang.Thread.MIN_PRIORITY
    # private int java.io.FileDescriptor.fd
    # </pre>
    # 
    # <p>The modifiers are placed in canonical order as specified by
    # "The Java Language Specification".  This is {@code public},
    # {@code protected} or {@code private} first, and then other
    # modifiers in the following order: {@code static}, {@code final},
    # {@code transient}, {@code volatile}.
    def to_s
      mod = get_modifiers
      return (RJava.cast_to_string((((mod).equal?(0)) ? "" : (RJava.cast_to_string(Modifier.to_s(mod)) + " ")) + get_type_name(get_type)) + " " + RJava.cast_to_string(get_type_name(get_declaring_class)) + "." + RJava.cast_to_string(get_name))
    end
    
    typesig { [] }
    # Returns a string describing this {@code Field}, including
    # its generic type.  The format is the access modifiers for the
    # field, if any, followed by the generic field type, followed by
    # a space, followed by the fully-qualified name of the class
    # declaring the field, followed by a period, followed by the name
    # of the field.
    # 
    # <p>The modifiers are placed in canonical order as specified by
    # "The Java Language Specification".  This is {@code public},
    # {@code protected} or {@code private} first, and then other
    # modifiers in the following order: {@code static}, {@code final},
    # {@code transient}, {@code volatile}.
    # 
    # @return a string describing this {@code Field}, including
    # its generic type
    # 
    # @since 1.5
    def to_generic_string
      mod = get_modifiers
      field_type = get_generic_type
      return (RJava.cast_to_string((((mod).equal?(0)) ? "" : (RJava.cast_to_string(Modifier.to_s(mod)) + " ")) + ((field_type.is_a?(Class)) ? get_type_name(field_type) : field_type.to_s)) + " " + RJava.cast_to_string(get_type_name(get_declaring_class)) + "." + RJava.cast_to_string(get_name))
    end
    
    typesig { [Object] }
    # Returns the value of the field represented by this {@code Field}, on
    # the specified object. The value is automatically wrapped in an
    # object if it has a primitive type.
    # 
    # <p>The underlying field's value is obtained as follows:
    # 
    # <p>If the underlying field is a static field, the {@code obj} argument
    # is ignored; it may be null.
    # 
    # <p>Otherwise, the underlying field is an instance field.  If the
    # specified {@code obj} argument is null, the method throws a
    # {@code NullPointerException}. If the specified object is not an
    # instance of the class or interface declaring the underlying
    # field, the method throws an {@code IllegalArgumentException}.
    # 
    # <p>If this {@code Field} object enforces Java language access control, and
    # the underlying field is inaccessible, the method throws an
    # {@code IllegalAccessException}.
    # If the underlying field is static, the class that declared the
    # field is initialized if it has not already been initialized.
    # 
    # <p>Otherwise, the value is retrieved from the underlying instance
    # or static field.  If the field has a primitive type, the value
    # is wrapped in an object before being returned, otherwise it is
    # returned as is.
    # 
    # <p>If the field is hidden in the type of {@code obj},
    # the field's value is obtained according to the preceding rules.
    # 
    # @param obj object from which the represented field's value is
    # to be extracted
    # @return the value of the represented field in object
    # {@code obj}; primitive values are wrapped in an appropriate
    # object before being returned
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof).
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    def get(obj)
      return get_field_accessor(obj).get(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance {@code boolean} field.
    # 
    # @param obj the object to extract the {@code boolean} value
    # from
    # @return the value of the {@code boolean} field
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code boolean} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#get
    def get_boolean(obj)
      return get_field_accessor(obj).get_boolean(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance {@code byte} field.
    # 
    # @param obj the object to extract the {@code byte} value
    # from
    # @return the value of the {@code byte} field
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code byte} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#get
    def get_byte(obj)
      return get_field_accessor(obj).get_byte(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance field of type
    # {@code char} or of another primitive type convertible to
    # type {@code char} via a widening conversion.
    # 
    # @param obj the object to extract the {@code char} value
    # from
    # @return the value of the field converted to type {@code char}
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code char} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see Field#get
    def get_char(obj)
      return get_field_accessor(obj).get_char(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance field of type
    # {@code short} or of another primitive type convertible to
    # type {@code short} via a widening conversion.
    # 
    # @param obj the object to extract the {@code short} value
    # from
    # @return the value of the field converted to type {@code short}
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code short} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#get
    def get_short(obj)
      return get_field_accessor(obj).get_short(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance field of type
    # {@code int} or of another primitive type convertible to
    # type {@code int} via a widening conversion.
    # 
    # @param obj the object to extract the {@code int} value
    # from
    # @return the value of the field converted to type {@code int}
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code int} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#get
    def get_int(obj)
      return get_field_accessor(obj).get_int(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance field of type
    # {@code long} or of another primitive type convertible to
    # type {@code long} via a widening conversion.
    # 
    # @param obj the object to extract the {@code long} value
    # from
    # @return the value of the field converted to type {@code long}
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code long} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#get
    def get_long(obj)
      return get_field_accessor(obj).get_long(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance field of type
    # {@code float} or of another primitive type convertible to
    # type {@code float} via a widening conversion.
    # 
    # @param obj the object to extract the {@code float} value
    # from
    # @return the value of the field converted to type {@code float}
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code float} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see Field#get
    def get_float(obj)
      return get_field_accessor(obj).get_float(obj)
    end
    
    typesig { [Object] }
    # Gets the value of a static or instance field of type
    # {@code double} or of another primitive type convertible to
    # type {@code double} via a widening conversion.
    # 
    # @param obj the object to extract the {@code double} value
    # from
    # @return the value of the field converted to type {@code double}
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not
    # an instance of the class or interface declaring the
    # underlying field (or a subclass or implementor
    # thereof), or if the field value cannot be
    # converted to the type {@code double} by a
    # widening conversion.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#get
    def get_double(obj)
      return get_field_accessor(obj).get_double(obj)
    end
    
    typesig { [Object, Object] }
    # Sets the field represented by this {@code Field} object on the
    # specified object argument to the specified new value. The new
    # value is automatically unwrapped if the underlying field has a
    # primitive type.
    # 
    # <p>The operation proceeds as follows:
    # 
    # <p>If the underlying field is static, the {@code obj} argument is
    # ignored; it may be null.
    # 
    # <p>Otherwise the underlying field is an instance field.  If the
    # specified object argument is null, the method throws a
    # {@code NullPointerException}.  If the specified object argument is not
    # an instance of the class or interface declaring the underlying
    # field, the method throws an {@code IllegalArgumentException}.
    # 
    # <p>If this {@code Field} object enforces Java language access control, and
    # the underlying field is inaccessible, the method throws an
    # {@code IllegalAccessException}.
    # 
    # <p>If the underlying field is final, the method throws an
    # {@code IllegalAccessException} unless
    # {@code setAccessible(true)} has succeeded for this field
    # and this field is non-static. Setting a final field in this way
    # is meaningful only during deserialization or reconstruction of
    # instances of classes with blank final fields, before they are
    # made available for access by other parts of a program. Use in
    # any other context may have unpredictable effects, including cases
    # in which other parts of a program continue to use the original
    # value of this field.
    # 
    # <p>If the underlying field is of a primitive type, an unwrapping
    # conversion is attempted to convert the new value to a value of
    # a primitive type.  If this attempt fails, the method throws an
    # {@code IllegalArgumentException}.
    # 
    # <p>If, after possible unwrapping, the new value cannot be
    # converted to the type of the underlying field by an identity or
    # widening conversion, the method throws an
    # {@code IllegalArgumentException}.
    # 
    # <p>If the underlying field is static, the class that declared the
    # field is initialized if it has not already been initialized.
    # 
    # <p>The field is set to the possibly unwrapped and widened new value.
    # 
    # <p>If the field is hidden in the type of {@code obj},
    # the field's value is set according to the preceding rules.
    # 
    # @param obj the object whose field should be modified
    # @param value the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    def set(obj, value)
      get_field_accessor(obj).set(obj, value)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Sets the value of a field as a {@code boolean} on the specified object.
    # This method is equivalent to
    # {@code set(obj, zObj)},
    # where {@code zObj} is a {@code Boolean} object and
    # {@code zObj.booleanValue() == z}.
    # 
    # @param obj the object whose field should be modified
    # @param z   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_boolean(obj, z)
      get_field_accessor(obj).set_boolean(obj, z)
    end
    
    typesig { [Object, ::Java::Byte] }
    # Sets the value of a field as a {@code byte} on the specified object.
    # This method is equivalent to
    # {@code set(obj, bObj)},
    # where {@code bObj} is a {@code Byte} object and
    # {@code bObj.byteValue() == b}.
    # 
    # @param obj the object whose field should be modified
    # @param b   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_byte(obj, b)
      get_field_accessor(obj).set_byte(obj, b)
    end
    
    typesig { [Object, ::Java::Char] }
    # Sets the value of a field as a {@code char} on the specified object.
    # This method is equivalent to
    # {@code set(obj, cObj)},
    # where {@code cObj} is a {@code Character} object and
    # {@code cObj.charValue() == c}.
    # 
    # @param obj the object whose field should be modified
    # @param c   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_char(obj, c)
      get_field_accessor(obj).set_char(obj, c)
    end
    
    typesig { [Object, ::Java::Short] }
    # Sets the value of a field as a {@code short} on the specified object.
    # This method is equivalent to
    # {@code set(obj, sObj)},
    # where {@code sObj} is a {@code Short} object and
    # {@code sObj.shortValue() == s}.
    # 
    # @param obj the object whose field should be modified
    # @param s   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_short(obj, s)
      get_field_accessor(obj).set_short(obj, s)
    end
    
    typesig { [Object, ::Java::Int] }
    # Sets the value of a field as an {@code int} on the specified object.
    # This method is equivalent to
    # {@code set(obj, iObj)},
    # where {@code iObj} is a {@code Integer} object and
    # {@code iObj.intValue() == i}.
    # 
    # @param obj the object whose field should be modified
    # @param i   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_int(obj, i)
      get_field_accessor(obj).set_int(obj, i)
    end
    
    typesig { [Object, ::Java::Long] }
    # Sets the value of a field as a {@code long} on the specified object.
    # This method is equivalent to
    # {@code set(obj, lObj)},
    # where {@code lObj} is a {@code Long} object and
    # {@code lObj.longValue() == l}.
    # 
    # @param obj the object whose field should be modified
    # @param l   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_long(obj, l)
      get_field_accessor(obj).set_long(obj, l)
    end
    
    typesig { [Object, ::Java::Float] }
    # Sets the value of a field as a {@code float} on the specified object.
    # This method is equivalent to
    # {@code set(obj, fObj)},
    # where {@code fObj} is a {@code Float} object and
    # {@code fObj.floatValue() == f}.
    # 
    # @param obj the object whose field should be modified
    # @param f   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_float(obj, f)
      get_field_accessor(obj).set_float(obj, f)
    end
    
    typesig { [Object, ::Java::Double] }
    # Sets the value of a field as a {@code double} on the specified object.
    # This method is equivalent to
    # {@code set(obj, dObj)},
    # where {@code dObj} is a {@code Double} object and
    # {@code dObj.doubleValue() == d}.
    # 
    # @param obj the object whose field should be modified
    # @param d   the new value for the field of {@code obj}
    # being modified
    # 
    # @exception IllegalAccessException    if the underlying field
    # is inaccessible.
    # @exception IllegalArgumentException  if the specified object is not an
    # instance of the class or interface declaring the underlying
    # field (or a subclass or implementor thereof),
    # or if an unwrapping conversion fails.
    # @exception NullPointerException      if the specified object is null
    # and the field is an instance field.
    # @exception ExceptionInInitializerError if the initialization provoked
    # by this method fails.
    # @see       Field#set
    def set_double(obj, d)
      get_field_accessor(obj).set_double(obj, d)
    end
    
    typesig { [Object] }
    # Convenience routine which performs security checks
    def get_field_accessor(obj)
      do_security_check(obj)
      ov = self.attr_override
      a = (ov) ? @override_field_accessor : @field_accessor
      return (!(a).nil?) ? a : acquire_field_accessor(ov)
    end
    
    typesig { [::Java::Boolean] }
    # NOTE that there is no synchronization used here. It is correct
    # (though not efficient) to generate more than one FieldAccessor
    # for a given Field. However, avoiding synchronization will
    # probably make the implementation more scalable.
    def acquire_field_accessor(override_final_check)
      # First check to see if one has been created yet, and take it
      # if so
      tmp = nil
      if (!(@root).nil?)
        tmp = @root.get_field_accessor(override_final_check)
      end
      if (!(tmp).nil?)
        if (override_final_check)
          @override_field_accessor = tmp
        else
          @field_accessor = tmp
        end
      else
        # Otherwise fabricate one and propagate it up to the root
        tmp = self.attr_reflection_factory.new_field_accessor(self, override_final_check)
        set_field_accessor(tmp, override_final_check)
      end
      return tmp
    end
    
    typesig { [::Java::Boolean] }
    # Returns FieldAccessor for this Field object, not looking up
    # the chain to the root
    def get_field_accessor(override_final_check)
      return (override_final_check) ? @override_field_accessor : @field_accessor
    end
    
    typesig { [FieldAccessor, ::Java::Boolean] }
    # Sets the FieldAccessor for this Field object and
    # (recursively) its root
    def set_field_accessor(accessor, override_final_check)
      if (override_final_check)
        @override_field_accessor = accessor
      else
        @field_accessor = accessor
      end
      # Propagate up
      if (!(@root).nil?)
        @root.set_field_accessor(accessor, override_final_check)
      end
    end
    
    typesig { [Object] }
    # NOTE: be very careful if you change the stack depth of this
    # routine. The depth of the "getCallerClass" call is hardwired so
    # that the compiler can have an easier time if this gets inlined.
    def do_security_check(obj)
      if (!self.attr_override)
        if (!Reflection.quick_check_member_access(@clazz, @modifiers))
          caller = Reflection.get_caller_class(4)
          target_class = (((obj).nil? || !Modifier.is_protected(@modifiers)) ? @clazz : obj.get_class)
          synchronized((self)) do
            if (((@security_check_cache).equal?(caller)) && ((@security_check_target_class_cache).equal?(target_class)))
              return
            end
          end
          Reflection.ensure_member_access(caller, @clazz, obj, @modifiers)
          synchronized((self)) do
            @security_check_cache = caller
            @security_check_target_class_cache = target_class
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # Utility routine to paper over array type names
      def get_type_name(type)
        if (type.is_array)
          begin
            cl = type
            dimensions = 0
            while (cl.is_array)
              dimensions += 1
              cl = cl.get_component_type
            end
            sb = StringBuffer.new
            sb.append(cl.get_name)
            i = 0
            while i < dimensions
              sb.append("[]")
              i += 1
            end
            return sb.to_s
          rescue JavaThrowable => e
            # FALLTHRU
          end
        end
        return type.get_name
      end
    }
    
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
    
    private
    alias_method :initialize__field, :initialize
  end
  
end
