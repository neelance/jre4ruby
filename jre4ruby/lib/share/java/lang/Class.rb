require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module ClassImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Lang::Reflect, :Array
      include_const ::Java::Lang::Reflect, :GenericArrayType
      include_const ::Java::Lang::Reflect, :Member
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :GenericDeclaration
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Java::Lang::Reflect, :TypeVariable
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :LinkedHashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Reflect, :ConstantPool
      include_const ::Sun::Reflect, :Reflection
      include_const ::Sun::Reflect, :ReflectionFactory
      include_const ::Sun::Reflect, :SignatureIterator
      include_const ::Sun::Reflect::Generics::Factory, :CoreReflectionFactory
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Repository, :ClassRepository
      include_const ::Sun::Reflect::Generics::Repository, :MethodRepository
      include_const ::Sun::Reflect::Generics::Repository, :ConstructorRepository
      include_const ::Sun::Reflect::Generics::Scope, :ClassScope
      include_const ::Sun::Security::Util, :SecurityConstants
      include_const ::Java::Lang::Annotation, :Annotation
      include ::Sun::Reflect::Annotation
    }
  end
  
  # Instances of the class {@code Class} represent classes and
  # interfaces in a running Java application.  An enum is a kind of
  # class and an annotation is a kind of interface.  Every array also
  # belongs to a class that is reflected as a {@code Class} object
  # that is shared by all arrays with the same element type and number
  # of dimensions.  The primitive Java types ({@code boolean},
  # {@code byte}, {@code char}, {@code short},
  # {@code int}, {@code long}, {@code float}, and
  # {@code double}), and the keyword {@code void} are also
  # represented as {@code Class} objects.
  # 
  # <p> {@code Class} has no public constructor. Instead {@code Class}
  # objects are constructed automatically by the Java Virtual Machine as classes
  # are loaded and by calls to the {@code defineClass} method in the class
  # loader.
  # 
  # <p> The following example uses a {@code Class} object to print the
  # class name of an object:
  # 
  # <p> <blockquote><pre>
  # void printClassName(Object obj) {
  # System.out.println("The class of " + obj +
  # " is " + obj.getClass().getName());
  # }
  # </pre></blockquote>
  # 
  # <p> It is also possible to get the {@code Class} object for a named
  # type (or for void) using a class literal
  # (JLS Section <A HREF="http://java.sun.com/docs/books/jls/second_edition/html/expressions.doc.html#251530">15.8.2</A>).
  # For example:
  # 
  # <p> <blockquote>
  # {@code System.out.println("The name of class Foo is: "+Foo.class.getName());}
  # </blockquote>
  # 
  # @param <T> the type of the class modeled by this {@code Class}
  # object.  For example, the type of {@code String.class} is {@code
  # Class<String>}.  Use {@code Class<?>} if the class being modeled is
  # unknown.
  # 
  # @author  unascribed
  # @see     java.lang.ClassLoader#defineClass(byte[], int, int)
  # @since   JDK1.0
  class Class 
    include_class_members ClassImports
    include Java::Io::Serializable
    include Java::Lang::Reflect::GenericDeclaration
    include Java::Lang::Reflect::Type
    include Java::Lang::Reflect::AnnotatedElement
    
    class_module.module_eval {
      const_set_lazy(:ANNOTATION) { 0x2000 }
      const_attr_reader  :ANNOTATION
      
      const_set_lazy(:ENUM) { 0x4000 }
      const_attr_reader  :ENUM
      
      const_set_lazy(:SYNTHETIC) { 0x1000 }
      const_attr_reader  :SYNTHETIC
      
      JNI.native_method :Java_java_lang_Class_registerNatives, [:pointer, :long], :void
      typesig { [] }
      def register_natives
        JNI.__send__(:Java_java_lang_Class_registerNatives, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        register_natives
      end
    }
    
    typesig { [] }
    # Constructor. Only the Java Virtual Machine creates Class
    # objects.
    def initialize
      @cached_constructor = nil
      @new_instance_caller_cache = nil
      @name = nil
      @declared_fields = nil
      @public_fields = nil
      @declared_methods = nil
      @public_methods = nil
      @declared_constructors = nil
      @public_constructors = nil
      @declared_public_fields = nil
      @declared_public_methods = nil
      @class_redefined_count = 0
      @last_redefined_count = 0
      @generic_info = nil
      @enum_constants = nil
      @enum_constant_directory = nil
      @annotations = nil
      @declared_annotations = nil
      @annotation_type = nil
    end
    
    typesig { [] }
    # Converts the object to a string. The string representation is the
    # string "class" or "interface", followed by a space, and then by the
    # fully qualified name of the class in the format returned by
    # {@code getName}.  If this {@code Class} object represents a
    # primitive type, this method returns the name of the primitive type.  If
    # this {@code Class} object represents void this method returns
    # "void".
    # 
    # @return a string representation of this class object.
    def to_s
      return (is_interface ? "interface " : (is_primitive ? "" : "class ")) + get_name
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns the {@code Class} object associated with the class or
      # interface with the given string name.  Invoking this method is
      # equivalent to:
      # 
      # <blockquote>
      # {@code Class.forName(className, true, currentLoader)}
      # </blockquote>
      # 
      # where {@code currentLoader} denotes the defining class loader of
      # the current class.
      # 
      # <p> For example, the following code fragment returns the
      # runtime {@code Class} descriptor for the class named
      # {@code java.lang.Thread}:
      # 
      # <blockquote>
      # {@code Class t = Class.forName("java.lang.Thread")}
      # </blockquote>
      # <p>
      # A call to {@code forName("X")} causes the class named
      # {@code X} to be initialized.
      # 
      # @param      className   the fully qualified name of the desired class.
      # @return     the {@code Class} object for the class with the
      # specified name.
      # @exception LinkageError if the linkage fails
      # @exception ExceptionInInitializerError if the initialization provoked
      # by this method fails
      # @exception ClassNotFoundException if the class cannot be located
      def for_name(class_name)
        return for_name0(class_name, true, ClassLoader.get_caller_class_loader)
      end
      
      typesig { [String, ::Java::Boolean, ClassLoader] }
      # Returns the {@code Class} object associated with the class or
      # interface with the given string name, using the given class loader.
      # Given the fully qualified name for a class or interface (in the same
      # format returned by {@code getName}) this method attempts to
      # locate, load, and link the class or interface.  The specified class
      # loader is used to load the class or interface.  If the parameter
      # {@code loader} is null, the class is loaded through the bootstrap
      # class loader.  The class is initialized only if the
      # {@code initialize} parameter is {@code true} and if it has
      # not been initialized earlier.
      # 
      # <p> If {@code name} denotes a primitive type or void, an attempt
      # will be made to locate a user-defined class in the unnamed package whose
      # name is {@code name}. Therefore, this method cannot be used to
      # obtain any of the {@code Class} objects representing primitive
      # types or void.
      # 
      # <p> If {@code name} denotes an array class, the component type of
      # the array class is loaded but not initialized.
      # 
      # <p> For example, in an instance method the expression:
      # 
      # <blockquote>
      # {@code Class.forName("Foo")}
      # </blockquote>
      # 
      # is equivalent to:
      # 
      # <blockquote>
      # {@code Class.forName("Foo", true, this.getClass().getClassLoader())}
      # </blockquote>
      # 
      # Note that this method throws errors related to loading, linking or
      # initializing as specified in Sections 12.2, 12.3 and 12.4 of <em>The
      # Java Language Specification</em>.
      # Note that this method does not check whether the requested class
      # is accessible to its caller.
      # 
      # <p> If the {@code loader} is {@code null}, and a security
      # manager is present, and the caller's class loader is not null, then this
      # method calls the security manager's {@code checkPermission} method
      # with a {@code RuntimePermission("getClassLoader")} permission to
      # ensure it's ok to access the bootstrap class loader.
      # 
      # @param name       fully qualified name of the desired class
      # @param initialize whether the class must be initialized
      # @param loader     class loader from which the class must be loaded
      # @return           class object representing the desired class
      # 
      # @exception LinkageError if the linkage fails
      # @exception ExceptionInInitializerError if the initialization provoked
      # by this method fails
      # @exception ClassNotFoundException if the class cannot be located by
      # the specified class loader
      # 
      # @see       java.lang.Class#forName(String)
      # @see       java.lang.ClassLoader
      # @since     1.2
      def for_name(name, initialize, loader)
        if ((loader).nil?)
          sm = System.get_security_manager
          if (!(sm).nil?)
            ccl = ClassLoader.get_caller_class_loader
            if (!(ccl).nil?)
              sm.check_permission(SecurityConstants::GET_CLASSLOADER_PERMISSION)
            end
          end
        end
        return for_name0(name, initialize, loader)
      end
      
      JNI.native_method :Java_java_lang_Class_forName0, [:pointer, :long, :long, :int8, :long], :long
      typesig { [String, ::Java::Boolean, ClassLoader] }
      # Called after security checks have been made.
      def for_name0(name, initialize, loader)
        JNI.__send__(:Java_java_lang_Class_forName0, JNI.env, self.jni_id, name.jni_id, initialize ? 1 : 0, loader.jni_id)
      end
    }
    
    typesig { [] }
    # Creates a new instance of the class represented by this {@code Class}
    # object.  The class is instantiated as if by a {@code new}
    # expression with an empty argument list.  The class is initialized if it
    # has not already been initialized.
    # 
    # <p>Note that this method propagates any exception thrown by the
    # nullary constructor, including a checked exception.  Use of
    # this method effectively bypasses the compile-time exception
    # checking that would otherwise be performed by the compiler.
    # The {@link
    # java.lang.reflect.Constructor#newInstance(java.lang.Object...)
    # Constructor.newInstance} method avoids this problem by wrapping
    # any exception thrown by the constructor in a (checked) {@link
    # java.lang.reflect.InvocationTargetException}.
    # 
    # @return     a newly allocated instance of the class represented by this
    # object.
    # @exception  IllegalAccessException  if the class or its nullary
    # constructor is not accessible.
    # @exception  InstantiationException
    # if this {@code Class} represents an abstract class,
    # an interface, an array class, a primitive type, or void;
    # or if the class has no nullary constructor;
    # or if the instantiation fails for some other reason.
    # @exception  ExceptionInInitializerError if the initialization
    # provoked by this method fails.
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} denies
    # creation of new instances of this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    def new_instance
      if (!(System.get_security_manager).nil?)
        check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      end
      return new_instance0
    end
    
    typesig { [] }
    def new_instance0
      # NOTE: the following code may not be strictly correct under
      # the current Java memory model.
      # Constructor lookup
      if ((@cached_constructor).nil?)
        if ((self).equal?(Class))
          raise IllegalAccessException.new("Can not call newInstance() on the Class for java.lang.Class")
        end
        begin
          empty = Array.typed(Class).new([])
          c = get_constructor0(empty, Member::DECLARED)
          Java::Security::AccessController.do_privileged(# Disable accessibility checks on the constructor
          # since we have to do the security check here anyway
          # (the stack depth is wrong for the Constructor's
          # security check to work)
          Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members Class
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              c.set_accessible(true)
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @cached_constructor = c
        rescue NoSuchMethodException => e
          raise InstantiationException.new(get_name)
        end
      end
      tmp_constructor = @cached_constructor
      # Security check (same as in java.lang.reflect.Constructor)
      modifiers = tmp_constructor.get_modifiers
      if (!Reflection.quick_check_member_access(self, modifiers))
        caller = Reflection.get_caller_class(3)
        if (!(@new_instance_caller_cache).equal?(caller))
          Reflection.ensure_member_access(caller, self, nil, modifiers)
          @new_instance_caller_cache = caller
        end
      end
      # Run constructor
      begin
        return tmp_constructor.new_instance(nil)
      rescue InvocationTargetException => e
        Unsafe.get_unsafe.throw_exception(e.get_target_exception)
        # Not reached
        return nil
      end
    end
    
    attr_accessor :cached_constructor
    alias_method :attr_cached_constructor, :cached_constructor
    undef_method :cached_constructor
    alias_method :attr_cached_constructor=, :cached_constructor=
    undef_method :cached_constructor=
    
    attr_accessor :new_instance_caller_cache
    alias_method :attr_new_instance_caller_cache, :new_instance_caller_cache
    undef_method :new_instance_caller_cache
    alias_method :attr_new_instance_caller_cache=, :new_instance_caller_cache=
    undef_method :new_instance_caller_cache=
    
    JNI.native_method :Java_java_lang_Class_isInstance, [:pointer, :long, :long], :int8
    typesig { [Object] }
    # Determines if the specified {@code Object} is assignment-compatible
    # with the object represented by this {@code Class}.  This method is
    # the dynamic equivalent of the Java language {@code instanceof}
    # operator. The method returns {@code true} if the specified
    # {@code Object} argument is non-null and can be cast to the
    # reference type represented by this {@code Class} object without
    # raising a {@code ClassCastException.} It returns {@code false}
    # otherwise.
    # 
    # <p> Specifically, if this {@code Class} object represents a
    # declared class, this method returns {@code true} if the specified
    # {@code Object} argument is an instance of the represented class (or
    # of any of its subclasses); it returns {@code false} otherwise. If
    # this {@code Class} object represents an array class, this method
    # returns {@code true} if the specified {@code Object} argument
    # can be converted to an object of the array class by an identity
    # conversion or by a widening reference conversion; it returns
    # {@code false} otherwise. If this {@code Class} object
    # represents an interface, this method returns {@code true} if the
    # class or any superclass of the specified {@code Object} argument
    # implements this interface; it returns {@code false} otherwise. If
    # this {@code Class} object represents a primitive type, this method
    # returns {@code false}.
    # 
    # @param   obj the object to check
    # @return  true if {@code obj} is an instance of this class
    # 
    # @since JDK1.1
    def is_instance(obj)
      JNI.__send__(:Java_java_lang_Class_isInstance, JNI.env, self.jni_id, obj.jni_id) != 0
    end
    
    JNI.native_method :Java_java_lang_Class_isAssignableFrom, [:pointer, :long, :long], :int8
    typesig { [Class] }
    # Determines if the class or interface represented by this
    # {@code Class} object is either the same as, or is a superclass or
    # superinterface of, the class or interface represented by the specified
    # {@code Class} parameter. It returns {@code true} if so;
    # otherwise it returns {@code false}. If this {@code Class}
    # object represents a primitive type, this method returns
    # {@code true} if the specified {@code Class} parameter is
    # exactly this {@code Class} object; otherwise it returns
    # {@code false}.
    # 
    # <p> Specifically, this method tests whether the type represented by the
    # specified {@code Class} parameter can be converted to the type
    # represented by this {@code Class} object via an identity conversion
    # or via a widening reference conversion. See <em>The Java Language
    # Specification</em>, sections 5.1.1 and 5.1.4 , for details.
    # 
    # @param cls the {@code Class} object to be checked
    # @return the {@code boolean} value indicating whether objects of the
    # type {@code cls} can be assigned to objects of this class
    # @exception NullPointerException if the specified Class parameter is
    # null.
    # @since JDK1.1
    def is_assignable_from(cls)
      JNI.__send__(:Java_java_lang_Class_isAssignableFrom, JNI.env, self.jni_id, cls.jni_id) != 0
    end
    
    JNI.native_method :Java_java_lang_Class_isInterface, [:pointer, :long], :int8
    typesig { [] }
    # Determines if the specified {@code Class} object represents an
    # interface type.
    # 
    # @return  {@code true} if this object represents an interface;
    # {@code false} otherwise.
    def is_interface
      JNI.__send__(:Java_java_lang_Class_isInterface, JNI.env, self.jni_id) != 0
    end
    
    JNI.native_method :Java_java_lang_Class_isArray, [:pointer, :long], :int8
    typesig { [] }
    # Determines if this {@code Class} object represents an array class.
    # 
    # @return  {@code true} if this object represents an array class;
    # {@code false} otherwise.
    # @since   JDK1.1
    def is_array
      JNI.__send__(:Java_java_lang_Class_isArray, JNI.env, self.jni_id) != 0
    end
    
    JNI.native_method :Java_java_lang_Class_isPrimitive, [:pointer, :long], :int8
    typesig { [] }
    # Determines if the specified {@code Class} object represents a
    # primitive type.
    # 
    # <p> There are nine predefined {@code Class} objects to represent
    # the eight primitive types and void.  These are created by the Java
    # Virtual Machine, and have the same names as the primitive types that
    # they represent, namely {@code boolean}, {@code byte},
    # {@code char}, {@code short}, {@code int},
    # {@code long}, {@code float}, and {@code double}.
    # 
    # <p> These objects may only be accessed via the following public static
    # final variables, and are the only {@code Class} objects for which
    # this method returns {@code true}.
    # 
    # @return true if and only if this class represents a primitive type
    # 
    # @see     java.lang.Boolean#TYPE
    # @see     java.lang.Character#TYPE
    # @see     java.lang.Byte#TYPE
    # @see     java.lang.Short#TYPE
    # @see     java.lang.Integer#TYPE
    # @see     java.lang.Long#TYPE
    # @see     java.lang.Float#TYPE
    # @see     java.lang.Double#TYPE
    # @see     java.lang.Void#TYPE
    # @since JDK1.1
    def is_primitive
      JNI.__send__(:Java_java_lang_Class_isPrimitive, JNI.env, self.jni_id) != 0
    end
    
    typesig { [] }
    # Returns true if this {@code Class} object represents an annotation
    # type.  Note that if this method returns true, {@link #isInterface()}
    # would also return true, as all annotation types are also interfaces.
    # 
    # @return {@code true} if this class object represents an annotation
    # type; {@code false} otherwise
    # @since 1.5
    def is_annotation
      return !((get_modifiers & ANNOTATION)).equal?(0)
    end
    
    typesig { [] }
    # Returns {@code true} if this class is a synthetic class;
    # returns {@code false} otherwise.
    # @return {@code true} if and only if this class is a synthetic class as
    # defined by the Java Language Specification.
    # @since 1.5
    def is_synthetic
      return !((get_modifiers & SYNTHETIC)).equal?(0)
    end
    
    typesig { [] }
    # Returns the  name of the entity (class, interface, array class,
    # primitive type, or void) represented by this {@code Class} object,
    # as a {@code String}.
    # 
    # <p> If this class object represents a reference type that is not an
    # array type then the binary name of the class is returned, as specified
    # by the Java Language Specification, Second Edition.
    # 
    # <p> If this class object represents a primitive type or void, then the
    # name returned is a {@code String} equal to the Java language
    # keyword corresponding to the primitive type or void.
    # 
    # <p> If this class object represents a class of arrays, then the internal
    # form of the name consists of the name of the element type preceded by
    # one or more '{@code [}' characters representing the depth of the array
    # nesting.  The encoding of element type names is as follows:
    # 
    # <blockquote><table summary="Element types and encodings">
    # <tr><th> Element Type <th> &nbsp;&nbsp;&nbsp; <th> Encoding
    # <tr><td> boolean      <td> &nbsp;&nbsp;&nbsp; <td align=center> Z
    # <tr><td> byte         <td> &nbsp;&nbsp;&nbsp; <td align=center> B
    # <tr><td> char         <td> &nbsp;&nbsp;&nbsp; <td align=center> C
    # <tr><td> class or interface
    # <td> &nbsp;&nbsp;&nbsp; <td align=center> L<i>classname</i>;
    # <tr><td> double       <td> &nbsp;&nbsp;&nbsp; <td align=center> D
    # <tr><td> float        <td> &nbsp;&nbsp;&nbsp; <td align=center> F
    # <tr><td> int          <td> &nbsp;&nbsp;&nbsp; <td align=center> I
    # <tr><td> long         <td> &nbsp;&nbsp;&nbsp; <td align=center> J
    # <tr><td> short        <td> &nbsp;&nbsp;&nbsp; <td align=center> S
    # </table></blockquote>
    # 
    # <p> The class or interface name <i>classname</i> is the binary name of
    # the class specified above.
    # 
    # <p> Examples:
    # <blockquote><pre>
    # String.class.getName()
    # returns "java.lang.String"
    # byte.class.getName()
    # returns "byte"
    # (new Object[3]).getClass().getName()
    # returns "[Ljava.lang.Object;"
    # (new int[3][4][5][6][7][8][9]).getClass().getName()
    # returns "[[[[[[[I"
    # </pre></blockquote>
    # 
    # @return  the name of the class or interface
    # represented by this object.
    def get_name
      if ((@name).nil?)
        @name = RJava.cast_to_string(get_name0)
      end
      return @name
    end
    
    # cache the name to reduce the number of calls into the VM
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    JNI.native_method :Java_java_lang_Class_getName0, [:pointer, :long], :long
    typesig { [] }
    def get_name0
      JNI.__send__(:Java_java_lang_Class_getName0, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Returns the class loader for the class.  Some implementations may use
    # null to represent the bootstrap class loader. This method will return
    # null in such implementations if this class was loaded by the bootstrap
    # class loader.
    # 
    # <p> If a security manager is present, and the caller's class loader is
    # not null and the caller's class loader is not the same as or an ancestor of
    # the class loader for the class whose class loader is requested, then
    # this method calls the security manager's {@code checkPermission}
    # method with a {@code RuntimePermission("getClassLoader")}
    # permission to ensure it's ok to access the class loader for the class.
    # 
    # <p>If this object
    # represents a primitive type or void, null is returned.
    # 
    # @return  the class loader that loaded the class or interface
    # represented by this object.
    # @throws SecurityException
    # if a security manager exists and its
    # {@code checkPermission} method denies
    # access to the class loader for the class.
    # @see java.lang.ClassLoader
    # @see SecurityManager#checkPermission
    # @see java.lang.RuntimePermission
    def get_class_loader
      cl = get_class_loader0
      if ((cl).nil?)
        return nil
      end
      sm = System.get_security_manager
      if (!(sm).nil?)
        ccl = ClassLoader.get_caller_class_loader
        if (!(ccl).nil? && !(ccl).equal?(cl) && !cl.is_ancestor(ccl))
          sm.check_permission(SecurityConstants::GET_CLASSLOADER_PERMISSION)
        end
      end
      return cl
    end
    
    JNI.native_method :Java_java_lang_Class_getClassLoader0, [:pointer, :long], :long
    typesig { [] }
    # Package-private to allow ClassLoader access
    def get_class_loader0
      JNI.__send__(:Java_java_lang_Class_getClassLoader0, JNI.env, self.jni_id)
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
    
    JNI.native_method :Java_java_lang_Class_getSuperclass, [:pointer, :long], :long
    typesig { [] }
    # Returns the {@code Class} representing the superclass of the entity
    # (class, interface, primitive type or void) represented by this
    # {@code Class}.  If this {@code Class} represents either the
    # {@code Object} class, an interface, a primitive type, or void, then
    # null is returned.  If this object represents an array class then the
    # {@code Class} object representing the {@code Object} class is
    # returned.
    # 
    # @return the superclass of the class represented by this object.
    def get_superclass
      JNI.__send__(:Java_java_lang_Class_getSuperclass, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Returns the {@code Type} representing the direct superclass of
    # the entity (class, interface, primitive type or void) represented by
    # this {@code Class}.
    # 
    # <p>If the superclass is a parameterized type, the {@code Type}
    # object returned must accurately reflect the actual type
    # parameters used in the source code. The parameterized type
    # representing the superclass is created if it had not been
    # created before. See the declaration of {@link
    # java.lang.reflect.ParameterizedType ParameterizedType} for the
    # semantics of the creation process for parameterized types.  If
    # this {@code Class} represents either the {@code Object}
    # class, an interface, a primitive type, or void, then null is
    # returned.  If this object represents an array class then the
    # {@code Class} object representing the {@code Object} class is
    # returned.
    # 
    # @throws GenericSignatureFormatError if the generic
    # class signature does not conform to the format specified in the
    # Java Virtual Machine Specification, 3rd edition
    # @throws TypeNotPresentException if the generic superclass
    # refers to a non-existent type declaration
    # @throws MalformedParameterizedTypeException if the
    # generic superclass refers to a parameterized type that cannot be
    # instantiated  for any reason
    # @return the superclass of the class represented by this object
    # @since 1.5
    def get_generic_superclass
      if (!(get_generic_signature).nil?)
        # Historical irregularity:
        # Generic signature marks interfaces with superclass = Object
        # but this API returns null for interfaces
        if (is_interface)
          return nil
        end
        return get_generic_info.get_superclass
      else
        return get_superclass
      end
    end
    
    typesig { [] }
    # Gets the package for this class.  The class loader of this class is used
    # to find the package.  If the class was loaded by the bootstrap class
    # loader the set of packages loaded from CLASSPATH is searched to find the
    # package of the class. Null is returned if no package object was created
    # by the class loader of this class.
    # 
    # <p> Packages have attributes for versions and specifications only if the
    # information was defined in the manifests that accompany the classes, and
    # if the class loader created the package instance with the attributes
    # from the manifest.
    # 
    # @return the package of the class, or null if no package
    # information is available from the archive or codebase.
    def get_package
      return Package.get_package(self)
    end
    
    JNI.native_method :Java_java_lang_Class_getInterfaces, [:pointer, :long], :long
    typesig { [] }
    # Determines the interfaces implemented by the class or interface
    # represented by this object.
    # 
    # <p> If this object represents a class, the return value is an array
    # containing objects representing all interfaces implemented by the
    # class. The order of the interface objects in the array corresponds to
    # the order of the interface names in the {@code implements} clause
    # of the declaration of the class represented by this object. For
    # example, given the declaration:
    # <blockquote>
    # {@code class Shimmer implements FloorWax, DessertTopping { ... }}
    # </blockquote>
    # suppose the value of {@code s} is an instance of
    # {@code Shimmer}; the value of the expression:
    # <blockquote>
    # {@code s.getClass().getInterfaces()[0]}
    # </blockquote>
    # is the {@code Class} object that represents interface
    # {@code FloorWax}; and the value of:
    # <blockquote>
    # {@code s.getClass().getInterfaces()[1]}
    # </blockquote>
    # is the {@code Class} object that represents interface
    # {@code DessertTopping}.
    # 
    # <p> If this object represents an interface, the array contains objects
    # representing all interfaces extended by the interface. The order of the
    # interface objects in the array corresponds to the order of the interface
    # names in the {@code extends} clause of the declaration of the
    # interface represented by this object.
    # 
    # <p> If this object represents a class or interface that implements no
    # interfaces, the method returns an array of length 0.
    # 
    # <p> If this object represents a primitive type or void, the method
    # returns an array of length 0.
    # 
    # @return an array of interfaces implemented by this class.
    def get_interfaces
      JNI.__send__(:Java_java_lang_Class_getInterfaces, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Returns the {@code Type}s representing the interfaces
    # directly implemented by the class or interface represented by
    # this object.
    # 
    # <p>If a superinterface is a parameterized type, the
    # {@code Type} object returned for it must accurately reflect
    # the actual type parameters used in the source code. The
    # parameterized type representing each superinterface is created
    # if it had not been created before. See the declaration of
    # {@link java.lang.reflect.ParameterizedType ParameterizedType}
    # for the semantics of the creation process for parameterized
    # types.
    # 
    # <p> If this object represents a class, the return value is an
    # array containing objects representing all interfaces
    # implemented by the class. The order of the interface objects in
    # the array corresponds to the order of the interface names in
    # the {@code implements} clause of the declaration of the class
    # represented by this object.  In the case of an array class, the
    # interfaces {@code Cloneable} and {@code Serializable} are
    # returned in that order.
    # 
    # <p>If this object represents an interface, the array contains
    # objects representing all interfaces directly extended by the
    # interface.  The order of the interface objects in the array
    # corresponds to the order of the interface names in the
    # {@code extends} clause of the declaration of the interface
    # represented by this object.
    # 
    # <p>If this object represents a class or interface that
    # implements no interfaces, the method returns an array of length
    # 0.
    # 
    # <p>If this object represents a primitive type or void, the
    # method returns an array of length 0.
    # 
    # @throws GenericSignatureFormatError
    # if the generic class signature does not conform to the format
    # specified in the Java Virtual Machine Specification, 3rd edition
    # @throws TypeNotPresentException if any of the generic
    # superinterfaces refers to a non-existent type declaration
    # @throws MalformedParameterizedTypeException if any of the
    # generic superinterfaces refer to a parameterized type that cannot
    # be instantiated  for any reason
    # @return an array of interfaces implemented by this class
    # @since 1.5
    def get_generic_interfaces
      if (!(get_generic_signature).nil?)
        return get_generic_info.get_super_interfaces
      else
        return get_interfaces
      end
    end
    
    JNI.native_method :Java_java_lang_Class_getComponentType, [:pointer, :long], :long
    typesig { [] }
    # Returns the {@code Class} representing the component type of an
    # array.  If this class does not represent an array class this method
    # returns null.
    # 
    # @return the {@code Class} representing the component type of this
    # class if this class is an array
    # @see     java.lang.reflect.Array
    # @since JDK1.1
    def get_component_type
      JNI.__send__(:Java_java_lang_Class_getComponentType, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Class_getModifiers, [:pointer, :long], :int32
    typesig { [] }
    # Returns the Java language modifiers for this class or interface, encoded
    # in an integer. The modifiers consist of the Java Virtual Machine's
    # constants for {@code public}, {@code protected},
    # {@code private}, {@code final}, {@code static},
    # {@code abstract} and {@code interface}; they should be decoded
    # using the methods of class {@code Modifier}.
    # 
    # <p> If the underlying class is an array class, then its
    # {@code public}, {@code private} and {@code protected}
    # modifiers are the same as those of its component type.  If this
    # {@code Class} represents a primitive type or void, its
    # {@code public} modifier is always {@code true}, and its
    # {@code protected} and {@code private} modifiers are always
    # {@code false}. If this object represents an array class, a
    # primitive type or void, then its {@code final} modifier is always
    # {@code true} and its interface modifier is always
    # {@code false}. The values of its other modifiers are not determined
    # by this specification.
    # 
    # <p> The modifier encodings are defined in <em>The Java Virtual Machine
    # Specification</em>, table 4.1.
    # 
    # @return the {@code int} representing the modifiers for this class
    # @see     java.lang.reflect.Modifier
    # @since JDK1.1
    def get_modifiers
      JNI.__send__(:Java_java_lang_Class_getModifiers, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Class_getSigners, [:pointer, :long], :long
    typesig { [] }
    # Gets the signers of this class.
    # 
    # @return  the signers of this class, or null if there are no signers.  In
    # particular, this method returns null if this object represents
    # a primitive type or void.
    # @since   JDK1.1
    def get_signers
      JNI.__send__(:Java_java_lang_Class_getSigners, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Class_setSigners, [:pointer, :long, :long], :void
    typesig { [Array.typed(Object)] }
    # Set the signers of this class.
    def set_signers(signers)
      JNI.__send__(:Java_java_lang_Class_setSigners, JNI.env, self.jni_id, signers.jni_id)
    end
    
    typesig { [] }
    # If this {@code Class} object represents a local or anonymous
    # class within a method, returns a {@link
    # java.lang.reflect.Method Method} object representing the
    # immediately enclosing method of the underlying class. Returns
    # {@code null} otherwise.
    # 
    # In particular, this method returns {@code null} if the underlying
    # class is a local or anonymous class immediately enclosed by a type
    # declaration, instance initializer or static initializer.
    # 
    # @return the immediately enclosing method of the underlying class, if
    # that class is a local or anonymous class; otherwise {@code null}.
    # @since 1.5
    def get_enclosing_method
      enclosing_info = get_enclosing_method_info
      if ((enclosing_info).nil?)
        return nil
      else
        if (!enclosing_info.is_method)
          return nil
        end
        type_info = MethodRepository.make(enclosing_info.get_descriptor, get_factory)
        return_type = to_class(type_info.get_return_type)
        parameter_types = type_info.get_parameter_types
        parameter_classes = Array.typed(Class).new(parameter_types.attr_length) { nil }
        # Convert Types to Classes; returned types *should*
        # be class objects since the methodDescriptor's used
        # don't have generics information
        i = 0
        while i < parameter_classes.attr_length
          parameter_classes[i] = to_class(parameter_types[i])
          i += 1
        end
        # Loop over all declared methods; match method name,
        # number of and type of parameters, *and* return
        # type.  Matching return type is also necessary
        # because of covariant returns, etc.
        enclosing_info.get_enclosing_class.get_declared_methods.each do |m|
          if ((m.get_name == enclosing_info.get_name))
            candidate_param_classes = m.get_parameter_types
            if ((candidate_param_classes.attr_length).equal?(parameter_classes.attr_length))
              matches = true
              i_ = 0
              while i_ < candidate_param_classes.attr_length
                if (!(candidate_param_classes[i_] == parameter_classes[i_]))
                  matches = false
                  break
                end
                i_ += 1
              end
              if (matches)
                # finally, check return type
                if ((m.get_return_type == return_type))
                  return m
                end
              end
            end
          end
        end
        raise InternalError.new("Enclosing method not found")
      end
    end
    
    JNI.native_method :Java_java_lang_Class_getEnclosingMethod0, [:pointer, :long], :long
    typesig { [] }
    def get_enclosing_method0
      JNI.__send__(:Java_java_lang_Class_getEnclosingMethod0, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    def get_enclosing_method_info
      enclosing_info = get_enclosing_method0
      if ((enclosing_info).nil?)
        return nil
      else
        return EnclosingMethodInfo.new(enclosing_info)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:EnclosingMethodInfo) { Class.new do
        include_class_members Class
        
        attr_accessor :enclosing_class
        alias_method :attr_enclosing_class, :enclosing_class
        undef_method :enclosing_class
        alias_method :attr_enclosing_class=, :enclosing_class=
        undef_method :enclosing_class=
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :descriptor
        alias_method :attr_descriptor, :descriptor
        undef_method :descriptor
        alias_method :attr_descriptor=, :descriptor=
        undef_method :descriptor=
        
        typesig { [Array.typed(Object)] }
        def initialize(enclosing_info)
          @enclosing_class = nil
          @name = nil
          @descriptor = nil
          if (!(enclosing_info.attr_length).equal?(3))
            raise self.class::InternalError.new("Malformed enclosing method information")
          end
          begin
            # The array is expected to have three elements:
            # the immediately enclosing class
            @enclosing_class = enclosing_info[0]
            raise AssertError if not ((!(@enclosing_class).nil?))
            # the immediately enclosing method or constructor's
            # name (can be null).
            @name = RJava.cast_to_string(enclosing_info[1])
            # the immediately enclosing method or constructor's
            # descriptor (null iff name is).
            @descriptor = RJava.cast_to_string(enclosing_info[2])
            raise AssertError if not (((!(@name).nil? && !(@descriptor).nil?) || (@name).equal?(@descriptor)))
          rescue self.class::ClassCastException => cce
            raise self.class::InternalError.new("Invalid type in enclosing method information")
          end
        end
        
        typesig { [] }
        def is_partial
          return (@enclosing_class).nil? || (@name).nil? || (@descriptor).nil?
        end
        
        typesig { [] }
        def is_constructor
          return !is_partial && ("<init>" == @name)
        end
        
        typesig { [] }
        def is_method
          return !is_partial && !is_constructor && !("<clinit>" == @name)
        end
        
        typesig { [] }
        def get_enclosing_class
          return @enclosing_class
        end
        
        typesig { [] }
        def get_name
          return @name
        end
        
        typesig { [] }
        def get_descriptor
          return @descriptor
        end
        
        private
        alias_method :initialize__enclosing_method_info, :initialize
      end }
      
      typesig { [Type] }
      def to_class(o)
        if (o.is_a?(GenericArrayType))
          return Array.new_instance(to_class((o).get_generic_component_type), 0).get_class
        end
        return o
      end
    }
    
    typesig { [] }
    # If this {@code Class} object represents a local or anonymous
    # class within a constructor, returns a {@link
    # java.lang.reflect.Constructor Constructor} object representing
    # the immediately enclosing constructor of the underlying
    # class. Returns {@code null} otherwise.  In particular, this
    # method returns {@code null} if the underlying class is a local
    # or anonymous class immediately enclosed by a type declaration,
    # instance initializer or static initializer.
    # 
    # @return the immediately enclosing constructor of the underlying class, if
    # that class is a local or anonymous class; otherwise {@code null}.
    # @since 1.5
    def get_enclosing_constructor
      enclosing_info = get_enclosing_method_info
      if ((enclosing_info).nil?)
        return nil
      else
        if (!enclosing_info.is_constructor)
          return nil
        end
        type_info = ConstructorRepository.make(enclosing_info.get_descriptor, get_factory)
        parameter_types = type_info.get_parameter_types
        parameter_classes = Array.typed(Class).new(parameter_types.attr_length) { nil }
        # Convert Types to Classes; returned types *should*
        # be class objects since the methodDescriptor's used
        # don't have generics information
        i = 0
        while i < parameter_classes.attr_length
          parameter_classes[i] = to_class(parameter_types[i])
          i += 1
        end
        # Loop over all declared constructors; match number
        # of and type of parameters.
        enclosing_info.get_enclosing_class.get_declared_constructors.each do |c|
          candidate_param_classes = c.get_parameter_types
          if ((candidate_param_classes.attr_length).equal?(parameter_classes.attr_length))
            matches = true
            i_ = 0
            while i_ < candidate_param_classes.attr_length
              if (!(candidate_param_classes[i_] == parameter_classes[i_]))
                matches = false
                break
              end
              i_ += 1
            end
            if (matches)
              return c
            end
          end
        end
        raise InternalError.new("Enclosing constructor not found")
      end
    end
    
    JNI.native_method :Java_java_lang_Class_getDeclaringClass, [:pointer, :long], :long
    typesig { [] }
    # If the class or interface represented by this {@code Class} object
    # is a member of another class, returns the {@code Class} object
    # representing the class in which it was declared.  This method returns
    # null if this class or interface is not a member of any other class.  If
    # this {@code Class} object represents an array class, a primitive
    # type, or void,then this method returns null.
    # 
    # @return the declaring class for this class
    # @since JDK1.1
    def get_declaring_class
      JNI.__send__(:Java_java_lang_Class_getDeclaringClass, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Returns the immediately enclosing class of the underlying
    # class.  If the underlying class is a top level class this
    # method returns {@code null}.
    # @return the immediately enclosing class of the underlying class
    # @since 1.5
    def get_enclosing_class
      # There are five kinds of classes (or interfaces):
      # a) Top level classes
      # b) Nested classes (static member classes)
      # c) Inner classes (non-static member classes)
      # d) Local classes (named classes declared within a method)
      # e) Anonymous classes
      # JVM Spec 4.8.6: A class must have an EnclosingMethod
      # attribute if and only if it is a local class or an
      # anonymous class.
      enclosing_info = get_enclosing_method_info
      if ((enclosing_info).nil?)
        # This is a top level or a nested class or an inner class (a, b, or c)
        return get_declaring_class
      else
        enclosing_class = enclosing_info.get_enclosing_class
        # This is a local class or an anonymous class (d or e)
        if ((enclosing_class).equal?(self) || (enclosing_class).nil?)
          raise InternalError.new("Malformed enclosing method information")
        else
          return enclosing_class
        end
      end
    end
    
    typesig { [] }
    # Returns the simple name of the underlying class as given in the
    # source code. Returns an empty string if the underlying class is
    # anonymous.
    # 
    # <p>The simple name of an array is the simple name of the
    # component type with "[]" appended.  In particular the simple
    # name of an array whose component type is anonymous is "[]".
    # 
    # @return the simple name of the underlying class
    # @since 1.5
    def get_simple_name
      if (is_array)
        return RJava.cast_to_string(get_component_type.get_simple_name) + "[]"
      end
      simple_name = get_simple_binary_name
      if ((simple_name).nil?)
        # top level class
        simple_name = RJava.cast_to_string(get_name)
        return simple_name.substring(simple_name.last_index_of(".") + 1) # strip the package name
      end
      # According to JLS3 "Binary Compatibility" (13.1) the binary
      # name of non-package classes (not top level) is the binary
      # name of the immediately enclosing class followed by a '$' followed by:
      # (for nested and inner classes): the simple name.
      # (for local classes): 1 or more digits followed by the simple name.
      # (for anonymous classes): 1 or more digits.
      # Since getSimpleBinaryName() will strip the binary name of
      # the immediatly enclosing class, we are now looking at a
      # string that matches the regular expression "\$[0-9]*"
      # followed by a simple name (considering the simple of an
      # anonymous class to be the empty string).
      # Remove leading "\$[0-9]*" from the name
      length_ = simple_name.length
      if (length_ < 1 || !(simple_name.char_at(0)).equal?(Character.new(?$.ord)))
        raise InternalError.new("Malformed class name")
      end
      index = 1
      while (index < length_ && is_ascii_digit(simple_name.char_at(index)))
        index += 1
      end
      # Eventually, this is the empty string iff this is an anonymous class
      return simple_name.substring(index)
    end
    
    class_module.module_eval {
      typesig { [::Java::Char] }
      # Character.isDigit answers {@code true} to some non-ascii
      # digits.  This one does not.
      def is_ascii_digit(c)
        return Character.new(?0.ord) <= c && c <= Character.new(?9.ord)
      end
    }
    
    typesig { [] }
    # Returns the canonical name of the underlying class as
    # defined by the Java Language Specification.  Returns null if
    # the underlying class does not have a canonical name (i.e., if
    # it is a local or anonymous class or an array whose component
    # type does not have a canonical name).
    # @return the canonical name of the underlying class if it exists, and
    # {@code null} otherwise.
    # @since 1.5
    def get_canonical_name
      if (is_array)
        canonical_name = get_component_type.get_canonical_name
        if (!(canonical_name).nil?)
          return canonical_name + "[]"
        else
          return nil
        end
      end
      if (is_local_or_anonymous_class)
        return nil
      end
      enclosing_class = get_enclosing_class
      if ((enclosing_class).nil?)
        # top level class
        return get_name
      else
        enclosing_name = enclosing_class.get_canonical_name
        if ((enclosing_name).nil?)
          return nil
        end
        return enclosing_name + "." + RJava.cast_to_string(get_simple_name)
      end
    end
    
    typesig { [] }
    # Returns {@code true} if and only if the underlying class
    # is an anonymous class.
    # 
    # @return {@code true} if and only if this class is an anonymous class.
    # @since 1.5
    def is_anonymous_class
      return ("" == get_simple_name)
    end
    
    typesig { [] }
    # Returns {@code true} if and only if the underlying class
    # is a local class.
    # 
    # @return {@code true} if and only if this class is a local class.
    # @since 1.5
    def is_local_class
      return is_local_or_anonymous_class && !is_anonymous_class
    end
    
    typesig { [] }
    # Returns {@code true} if and only if the underlying class
    # is a member class.
    # 
    # @return {@code true} if and only if this class is a member class.
    # @since 1.5
    def is_member_class
      return !(get_simple_binary_name).nil? && !is_local_or_anonymous_class
    end
    
    typesig { [] }
    # Returns the "simple binary name" of the underlying class, i.e.,
    # the binary name without the leading enclosing class name.
    # Returns {@code null} if the underlying class is a top level
    # class.
    def get_simple_binary_name
      enclosing_class = get_enclosing_class
      if ((enclosing_class).nil?)
        # top level class
        return nil
      end
      # Otherwise, strip the enclosing class' name
      begin
        return get_name.substring(enclosing_class.get_name.length)
      rescue IndexOutOfBoundsException => ex
        raise InternalError.new("Malformed class name")
      end
    end
    
    typesig { [] }
    # Returns {@code true} if this is a local class or an anonymous
    # class.  Returns {@code false} otherwise.
    def is_local_or_anonymous_class
      # JVM Spec 4.8.6: A class must have an EnclosingMethod
      # attribute if and only if it is a local class or an
      # anonymous class.
      return !(get_enclosing_method_info).nil?
    end
    
    typesig { [] }
    # Returns an array containing {@code Class} objects representing all
    # the public classes and interfaces that are members of the class
    # represented by this {@code Class} object.  This includes public
    # class and interface members inherited from superclasses and public class
    # and interface members declared by the class.  This method returns an
    # array of length 0 if this {@code Class} object has no public member
    # classes or interfaces.  This method also returns an array of length 0 if
    # this {@code Class} object represents a primitive type, an array
    # class, or void.
    # 
    # @return the array of {@code Class} objects representing the public
    # members of this class
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} method
    # denies access to the classes within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_classes
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      result = Java::Security::AccessController.do_privileged(# Privileged so this implementation can look at DECLARED classes,
      # something the caller might not have privilege to do.  The code here
      # is allowed to look at DECLARED classes because (1) it does not hand
      # out anything other than public members and (2) public member access
      # has already been ok'd by the SecurityManager.
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members Class
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          list = Java::Util::ArrayList.new
          current_class = @local_class_parent
          while (!(current_class).nil?)
            members = current_class.get_declared_classes
            i = 0
            while i < members.attr_length
              if (Modifier.is_public(members[i].get_modifiers))
                list.add(members[i])
              end
              i += 1
            end
            current_class = current_class.get_superclass
          end
          empty = Array.typed(self.class::Class).new([])
          return list.to_array(empty)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return result
    end
    
    typesig { [] }
    # Returns an array containing {@code Field} objects reflecting all
    # the accessible public fields of the class or interface represented by
    # this {@code Class} object.  The elements in the array returned are
    # not sorted and are not in any particular order.  This method returns an
    # array of length 0 if the class or interface has no accessible public
    # fields, or if it represents an array class, a primitive type, or void.
    # 
    # <p> Specifically, if this {@code Class} object represents a class,
    # this method returns the public fields of this class and of all its
    # superclasses.  If this {@code Class} object represents an
    # interface, this method returns the fields of this interface and of all
    # its superinterfaces.
    # 
    # <p> The implicit length field for array class is not reflected by this
    # method. User code should use the methods of class {@code Array} to
    # manipulate arrays.
    # 
    # <p> See <em>The Java Language Specification</em>, sections 8.2 and 8.3.
    # 
    # @return the array of {@code Field} objects representing the
    # public fields
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} denies
    # access to the fields within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_fields
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      return copy_fields(private_get_public_fields(nil))
    end
    
    typesig { [] }
    # Returns an array containing {@code Method} objects reflecting all
    # the public <em>member</em> methods of the class or interface represented
    # by this {@code Class} object, including those declared by the class
    # or interface and those inherited from superclasses and
    # superinterfaces.  Array classes return all the (public) member methods
    # inherited from the {@code Object} class.  The elements in the array
    # returned are not sorted and are not in any particular order.  This
    # method returns an array of length 0 if this {@code Class} object
    # represents a class or interface that has no public member methods, or if
    # this {@code Class} object represents a primitive type or void.
    # 
    # <p> The class initialization method {@code <clinit>} is not
    # included in the returned array. If the class declares multiple public
    # member methods with the same parameter types, they are all included in
    # the returned array.
    # 
    # <p> See <em>The Java Language Specification</em>, sections 8.2 and 8.4.
    # 
    # @return the array of {@code Method} objects representing the
    # public methods of this class
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} denies
    # access to the methods within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_methods
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      return copy_methods(private_get_public_methods)
    end
    
    typesig { [] }
    # Returns an array containing {@code Constructor} objects reflecting
    # all the public constructors of the class represented by this
    # {@code Class} object.  An array of length 0 is returned if the
    # class has no public constructors, or if the class is an array class, or
    # if the class reflects a primitive type or void.
    # 
    # Note that while this method returns an array of {@code
    # Constructor<T>} objects (that is an array of constructors from
    # this class), the return type of this method is {@code
    # Constructor<?>[]} and <em>not</em> {@code Constructor<T>[]} as
    # might be expected.  This less informative return type is
    # necessary since after being returned from this method, the
    # array could be modified to hold {@code Constructor} objects for
    # different classes, which would violate the type guarantees of
    # {@code Constructor<T>[]}.
    # 
    # @return the array of {@code Constructor} objects representing the
    # public constructors of this class
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} denies
    # access to the constructors within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_constructors
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      return copy_constructors(private_get_declared_constructors(true))
    end
    
    typesig { [String] }
    # Returns a {@code Field} object that reflects the specified public
    # member field of the class or interface represented by this
    # {@code Class} object. The {@code name} parameter is a
    # {@code String} specifying the simple name of the desired field.
    # 
    # <p> The field to be reflected is determined by the algorithm that
    # follows.  Let C be the class represented by this object:
    # <OL>
    # <LI> If C declares a public field with the name specified, that is the
    # field to be reflected.</LI>
    # <LI> If no field was found in step 1 above, this algorithm is applied
    # recursively to each direct superinterface of C. The direct
    # superinterfaces are searched in the order they were declared.</LI>
    # <LI> If no field was found in steps 1 and 2 above, and C has a
    # superclass S, then this algorithm is invoked recursively upon S.
    # If C has no superclass, then a {@code NoSuchFieldException}
    # is thrown.</LI>
    # </OL>
    # 
    # <p> See <em>The Java Language Specification</em>, sections 8.2 and 8.3.
    # 
    # @param name the field name
    # @return  the {@code Field} object of this class specified by
    # {@code name}
    # @exception NoSuchFieldException if a field with the specified name is
    # not found.
    # @exception NullPointerException if {@code name} is {@code null}
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} denies
    # access to the field
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_field(name)
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      field = get_field0(name)
      if ((field).nil?)
        raise NoSuchFieldException.new(name)
      end
      return field
    end
    
    typesig { [String, Class] }
    # Returns a {@code Method} object that reflects the specified public
    # member method of the class or interface represented by this
    # {@code Class} object. The {@code name} parameter is a
    # {@code String} specifying the simple name of the desired method. The
    # {@code parameterTypes} parameter is an array of {@code Class}
    # objects that identify the method's formal parameter types, in declared
    # order. If {@code parameterTypes} is {@code null}, it is
    # treated as if it were an empty array.
    # 
    # <p> If the {@code name} is "{@code <init>};"or "{@code <clinit>}" a
    # {@code NoSuchMethodException} is raised. Otherwise, the method to
    # be reflected is determined by the algorithm that follows.  Let C be the
    # class represented by this object:
    # <OL>
    # <LI> C is searched for any <I>matching methods</I>. If no matching
    # method is found, the algorithm of step 1 is invoked recursively on
    # the superclass of C.</LI>
    # <LI> If no method was found in step 1 above, the superinterfaces of C
    # are searched for a matching method. If any such method is found, it
    # is reflected.</LI>
    # </OL>
    # 
    # To find a matching method in a class C:&nbsp; If C declares exactly one
    # public method with the specified name and exactly the same formal
    # parameter types, that is the method reflected. If more than one such
    # method is found in C, and one of these methods has a return type that is
    # more specific than any of the others, that method is reflected;
    # otherwise one of the methods is chosen arbitrarily.
    # 
    # <p>Note that there may be more than one matching method in a
    # class because while the Java language forbids a class to
    # declare multiple methods with the same signature but different
    # return types, the Java virtual machine does not.  This
    # increased flexibility in the virtual machine can be used to
    # implement various language features.  For example, covariant
    # returns can be implemented with {@linkplain
    # java.lang.reflect.Method#isBridge bridge methods}; the bridge
    # method and the method being overridden would have the same
    # signature but different return types.
    # 
    # <p> See <em>The Java Language Specification</em>, sections 8.2 and 8.4.
    # 
    # @param name the name of the method
    # @param parameterTypes the list of parameters
    # @return the {@code Method} object that matches the specified
    # {@code name} and {@code parameterTypes}
    # @exception NoSuchMethodException if a matching method is not found
    # or if the name is "&lt;init&gt;"or "&lt;clinit&gt;".
    # @exception NullPointerException if {@code name} is {@code null}
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} denies
    # access to the method
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_method(name, *parameter_types)
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      method = get_method0(name, parameter_types)
      if ((method).nil?)
        raise NoSuchMethodException.new(RJava.cast_to_string(get_name) + "." + name + RJava.cast_to_string(argument_types_to_string(parameter_types)))
      end
      return method
    end
    
    typesig { [Class] }
    # Returns a {@code Constructor} object that reflects the specified
    # public constructor of the class represented by this {@code Class}
    # object. The {@code parameterTypes} parameter is an array of
    # {@code Class} objects that identify the constructor's formal
    # parameter types, in declared order.
    # 
    # If this {@code Class} object represents an inner class
    # declared in a non-static context, the formal parameter types
    # include the explicit enclosing instance as the first parameter.
    # 
    # <p> The constructor to reflect is the public constructor of the class
    # represented by this {@code Class} object whose formal parameter
    # types match those specified by {@code parameterTypes}.
    # 
    # @param parameterTypes the parameter array
    # @return the {@code Constructor} object of the public constructor that
    # matches the specified {@code parameterTypes}
    # @exception NoSuchMethodException if a matching method is not found.
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.PUBLIC)} denies
    # access to the constructor
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_constructor(*parameter_types)
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::PUBLIC, ClassLoader.get_caller_class_loader)
      return get_constructor0(parameter_types, Member::PUBLIC)
    end
    
    typesig { [] }
    # Returns an array of {@code Class} objects reflecting all the
    # classes and interfaces declared as members of the class represented by
    # this {@code Class} object. This includes public, protected, default
    # (package) access, and private classes and interfaces declared by the
    # class, but excludes inherited classes and interfaces.  This method
    # returns an array of length 0 if the class declares no classes or
    # interfaces as members, or if this {@code Class} object represents a
    # primitive type, an array class, or void.
    # 
    # @return the array of {@code Class} objects representing all the
    # declared members of this class
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.DECLARED)} denies
    # access to the declared classes within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_declared_classes
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::DECLARED, ClassLoader.get_caller_class_loader)
      return get_declared_classes0
    end
    
    typesig { [] }
    # Returns an array of {@code Field} objects reflecting all the fields
    # declared by the class or interface represented by this
    # {@code Class} object. This includes public, protected, default
    # (package) access, and private fields, but excludes inherited fields.
    # The elements in the array returned are not sorted and are not in any
    # particular order.  This method returns an array of length 0 if the class
    # or interface declares no fields, or if this {@code Class} object
    # represents a primitive type, an array class, or void.
    # 
    # <p> See <em>The Java Language Specification</em>, sections 8.2 and 8.3.
    # 
    # @return    the array of {@code Field} objects representing all the
    # declared fields of this class
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.DECLARED)} denies
    # access to the declared fields within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_declared_fields
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::DECLARED, ClassLoader.get_caller_class_loader)
      return copy_fields(private_get_declared_fields(false))
    end
    
    typesig { [] }
    # Returns an array of {@code Method} objects reflecting all the
    # methods declared by the class or interface represented by this
    # {@code Class} object. This includes public, protected, default
    # (package) access, and private methods, but excludes inherited methods.
    # The elements in the array returned are not sorted and are not in any
    # particular order.  This method returns an array of length 0 if the class
    # or interface declares no methods, or if this {@code Class} object
    # represents a primitive type, an array class, or void.  The class
    # initialization method {@code <clinit>} is not included in the
    # returned array. If the class declares multiple public member methods
    # with the same parameter types, they are all included in the returned
    # array.
    # 
    # <p> See <em>The Java Language Specification</em>, section 8.2.
    # 
    # @return    the array of {@code Method} objects representing all the
    # declared methods of this class
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.DECLARED)} denies
    # access to the declared methods within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_declared_methods
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::DECLARED, ClassLoader.get_caller_class_loader)
      return copy_methods(private_get_declared_methods(false))
    end
    
    typesig { [] }
    # Returns an array of {@code Constructor} objects reflecting all the
    # constructors declared by the class represented by this
    # {@code Class} object. These are public, protected, default
    # (package) access, and private constructors.  The elements in the array
    # returned are not sorted and are not in any particular order.  If the
    # class has a default constructor, it is included in the returned array.
    # This method returns an array of length 0 if this {@code Class}
    # object represents an interface, a primitive type, an array class, or
    # void.
    # 
    # <p> See <em>The Java Language Specification</em>, section 8.2.
    # 
    # @return    the array of {@code Constructor} objects representing all the
    # declared constructors of this class
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.DECLARED)} denies
    # access to the declared constructors within this class
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_declared_constructors
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::DECLARED, ClassLoader.get_caller_class_loader)
      return copy_constructors(private_get_declared_constructors(false))
    end
    
    typesig { [String] }
    # Returns a {@code Field} object that reflects the specified declared
    # field of the class or interface represented by this {@code Class}
    # object. The {@code name} parameter is a {@code String} that
    # specifies the simple name of the desired field.  Note that this method
    # will not reflect the {@code length} field of an array class.
    # 
    # @param name the name of the field
    # @return the {@code Field} object for the specified field in this
    # class
    # @exception NoSuchFieldException if a field with the specified name is
    # not found.
    # @exception NullPointerException if {@code name} is {@code null}
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.DECLARED)} denies
    # access to the declared field
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_declared_field(name)
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::DECLARED, ClassLoader.get_caller_class_loader)
      field = search_fields(private_get_declared_fields(false), name)
      if ((field).nil?)
        raise NoSuchFieldException.new(name)
      end
      return field
    end
    
    typesig { [String, Class] }
    # Returns a {@code Method} object that reflects the specified
    # declared method of the class or interface represented by this
    # {@code Class} object. The {@code name} parameter is a
    # {@code String} that specifies the simple name of the desired
    # method, and the {@code parameterTypes} parameter is an array of
    # {@code Class} objects that identify the method's formal parameter
    # types, in declared order.  If more than one method with the same
    # parameter types is declared in a class, and one of these methods has a
    # return type that is more specific than any of the others, that method is
    # returned; otherwise one of the methods is chosen arbitrarily.  If the
    # name is "&lt;init&gt;"or "&lt;clinit&gt;" a {@code NoSuchMethodException}
    # is raised.
    # 
    # @param name the name of the method
    # @param parameterTypes the parameter array
    # @return    the {@code Method} object for the method of this class
    # matching the specified name and parameters
    # @exception NoSuchMethodException if a matching method is not found.
    # @exception NullPointerException if {@code name} is {@code null}
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.DECLARED)} denies
    # access to the declared method
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_declared_method(name, *parameter_types)
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::DECLARED, ClassLoader.get_caller_class_loader)
      method = search_methods(private_get_declared_methods(false), name, parameter_types)
      if ((method).nil?)
        raise NoSuchMethodException.new(RJava.cast_to_string(get_name) + "." + name + RJava.cast_to_string(argument_types_to_string(parameter_types)))
      end
      return method
    end
    
    typesig { [Class] }
    # Returns a {@code Constructor} object that reflects the specified
    # constructor of the class or interface represented by this
    # {@code Class} object.  The {@code parameterTypes} parameter is
    # an array of {@code Class} objects that identify the constructor's
    # formal parameter types, in declared order.
    # 
    # If this {@code Class} object represents an inner class
    # declared in a non-static context, the formal parameter types
    # include the explicit enclosing instance as the first parameter.
    # 
    # @param parameterTypes the parameter array
    # @return    The {@code Constructor} object for the constructor with the
    # specified parameter list
    # @exception NoSuchMethodException if a matching method is not found.
    # @exception  SecurityException
    # If a security manager, <i>s</i>, is present and any of the
    # following conditions is met:
    # 
    # <ul>
    # 
    # <li> invocation of
    # {@link SecurityManager#checkMemberAccess
    # s.checkMemberAccess(this, Member.DECLARED)} denies
    # access to the declared constructor
    # 
    # <li> the caller's class loader is not the same as or an
    # ancestor of the class loader for the current class and
    # invocation of {@link SecurityManager#checkPackageAccess
    # s.checkPackageAccess()} denies access to the package
    # of this class
    # 
    # </ul>
    # 
    # @since JDK1.1
    def get_declared_constructor(*parameter_types)
      # be very careful not to change the stack depth of this
      # checkMemberAccess call for security reasons
      # see java.lang.SecurityManager.checkMemberAccess
      check_member_access(Member::DECLARED, ClassLoader.get_caller_class_loader)
      return get_constructor0(parameter_types, Member::DECLARED)
    end
    
    typesig { [String] }
    # Finds a resource with a given name.  The rules for searching resources
    # associated with a given class are implemented by the defining
    # {@linkplain ClassLoader class loader} of the class.  This method
    # delegates to this object's class loader.  If this object was loaded by
    # the bootstrap class loader, the method delegates to {@link
    # ClassLoader#getSystemResourceAsStream}.
    # 
    # <p> Before delegation, an absolute resource name is constructed from the
    # given resource name using this algorithm:
    # 
    # <ul>
    # 
    # <li> If the {@code name} begins with a {@code '/'}
    # (<tt>'&#92;u002f'</tt>), then the absolute name of the resource is the
    # portion of the {@code name} following the {@code '/'}.
    # 
    # <li> Otherwise, the absolute name is of the following form:
    # 
    # <blockquote>
    # {@code modified_package_name/name}
    # </blockquote>
    # 
    # <p> Where the {@code modified_package_name} is the package name of this
    # object with {@code '/'} substituted for {@code '.'}
    # (<tt>'&#92;u002e'</tt>).
    # 
    # </ul>
    # 
    # @param  name name of the desired resource
    # @return      A {@link java.io.InputStream} object or {@code null} if
    # no resource with this name is found
    # @throws  NullPointerException If {@code name} is {@code null}
    # @since  JDK1.1
    def get_resource_as_stream(name)
      name = RJava.cast_to_string(resolve_name(name))
      cl = get_class_loader0
      if ((cl).nil?)
        # A system class.
        return ClassLoader.get_system_resource_as_stream(name)
      end
      return cl.get_resource_as_stream(name)
    end
    
    typesig { [String] }
    # Finds a resource with a given name.  The rules for searching resources
    # associated with a given class are implemented by the defining
    # {@linkplain ClassLoader class loader} of the class.  This method
    # delegates to this object's class loader.  If this object was loaded by
    # the bootstrap class loader, the method delegates to {@link
    # ClassLoader#getSystemResource}.
    # 
    # <p> Before delegation, an absolute resource name is constructed from the
    # given resource name using this algorithm:
    # 
    # <ul>
    # 
    # <li> If the {@code name} begins with a {@code '/'}
    # (<tt>'&#92;u002f'</tt>), then the absolute name of the resource is the
    # portion of the {@code name} following the {@code '/'}.
    # 
    # <li> Otherwise, the absolute name is of the following form:
    # 
    # <blockquote>
    # {@code modified_package_name/name}
    # </blockquote>
    # 
    # <p> Where the {@code modified_package_name} is the package name of this
    # object with {@code '/'} substituted for {@code '.'}
    # (<tt>'&#92;u002e'</tt>).
    # 
    # </ul>
    # 
    # @param  name name of the desired resource
    # @return      A  {@link java.net.URL} object or {@code null} if no
    # resource with this name is found
    # @since  JDK1.1
    def get_resource(name)
      name = RJava.cast_to_string(resolve_name(name))
      cl = get_class_loader0
      if ((cl).nil?)
        # A system class.
        return ClassLoader.get_system_resource(name)
      end
      return cl.get_resource(name)
    end
    
    class_module.module_eval {
      # protection domain returned when the internal domain is null
      
      def all_perm_domain
        defined?(@@all_perm_domain) ? @@all_perm_domain : @@all_perm_domain= nil
      end
      alias_method :attr_all_perm_domain, :all_perm_domain
      
      def all_perm_domain=(value)
        @@all_perm_domain = value
      end
      alias_method :attr_all_perm_domain=, :all_perm_domain=
    }
    
    typesig { [] }
    # Returns the {@code ProtectionDomain} of this class.  If there is a
    # security manager installed, this method first calls the security
    # manager's {@code checkPermission} method with a
    # {@code RuntimePermission("getProtectionDomain")} permission to
    # ensure it's ok to get the
    # {@code ProtectionDomain}.
    # 
    # @return the ProtectionDomain of this class
    # 
    # @throws SecurityException
    # if a security manager exists and its
    # {@code checkPermission} method doesn't allow
    # getting the ProtectionDomain.
    # 
    # @see java.security.ProtectionDomain
    # @see SecurityManager#checkPermission
    # @see java.lang.RuntimePermission
    # @since 1.2
    def get_protection_domain
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SecurityConstants::GET_PD_PERMISSION)
      end
      pd = get_protection_domain0
      if ((pd).nil?)
        if ((self.attr_all_perm_domain).nil?)
          perms = Java::Security::Permissions.new
          perms.add(SecurityConstants::ALL_PERMISSION)
          self.attr_all_perm_domain = Java::Security::ProtectionDomain.new(nil, perms)
        end
        pd = self.attr_all_perm_domain
      end
      return pd
    end
    
    JNI.native_method :Java_java_lang_Class_getProtectionDomain0, [:pointer, :long], :long
    typesig { [] }
    # Returns the ProtectionDomain of this class.
    def get_protection_domain0
      JNI.__send__(:Java_java_lang_Class_getProtectionDomain0, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Class_setProtectionDomain0, [:pointer, :long, :long], :void
    typesig { [Java::Security::ProtectionDomain] }
    # Set the ProtectionDomain for this class. Called by
    # ClassLoader.defineClass.
    def set_protection_domain0(pd)
      JNI.__send__(:Java_java_lang_Class_setProtectionDomain0, JNI.env, self.jni_id, pd.jni_id)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_Class_getPrimitiveClass, [:pointer, :long, :long], :long
      typesig { [String] }
      # Return the Virtual Machine's Class object for the named
      # primitive type.
      def get_primitive_class(name)
        JNI.__send__(:Java_java_lang_Class_getPrimitiveClass, JNI.env, self.jni_id, name.jni_id)
      end
    }
    
    typesig { [::Java::Int, ClassLoader] }
    # Check if client is allowed to access members.  If access is denied,
    # throw a SecurityException.
    # 
    # Be very careful not to change the stack depth of this checkMemberAccess
    # call for security reasons.
    # See java.lang.SecurityManager.checkMemberAccess.
    # 
    # <p> Default policy: allow all clients access with normal Java access
    # control.
    def check_member_access(which, ccl)
      s = System.get_security_manager
      if (!(s).nil?)
        s.check_member_access(self, which)
        cl = get_class_loader0
        if ((!(ccl).nil?) && (!(ccl).equal?(cl)) && (((cl).nil?) || !cl.is_ancestor(ccl)))
          name = self.get_name
          i = name.last_index_of(Character.new(?..ord))
          if (!(i).equal?(-1))
            s.check_package_access(name.substring(0, i))
          end
        end
      end
    end
    
    typesig { [String] }
    # Add a package name prefix if the name is not absolute Remove leading "/"
    # if name is absolute
    def resolve_name(name)
      if ((name).nil?)
        return name
      end
      if (!name.starts_with("/"))
        c = self
        while (c.is_array)
          c = c.get_component_type
        end
        base_name = c.get_name
        index = base_name.last_index_of(Character.new(?..ord))
        if (!(index).equal?(-1))
          name = RJava.cast_to_string(base_name.substring(0, index).replace(Character.new(?..ord), Character.new(?/.ord))) + "/" + name
        end
      else
        name = RJava.cast_to_string(name.substring(1))
      end
      return name
    end
    
    class_module.module_eval {
      # Reflection support.
      # 
      # Caches for certain reflective results
      
      def use_caches
        defined?(@@use_caches) ? @@use_caches : @@use_caches= true
      end
      alias_method :attr_use_caches, :use_caches
      
      def use_caches=(value)
        @@use_caches = value
      end
      alias_method :attr_use_caches=, :use_caches=
    }
    
    attr_accessor :declared_fields
    alias_method :attr_declared_fields, :declared_fields
    undef_method :declared_fields
    alias_method :attr_declared_fields=, :declared_fields=
    undef_method :declared_fields=
    
    attr_accessor :public_fields
    alias_method :attr_public_fields, :public_fields
    undef_method :public_fields
    alias_method :attr_public_fields=, :public_fields=
    undef_method :public_fields=
    
    attr_accessor :declared_methods
    alias_method :attr_declared_methods, :declared_methods
    undef_method :declared_methods
    alias_method :attr_declared_methods=, :declared_methods=
    undef_method :declared_methods=
    
    attr_accessor :public_methods
    alias_method :attr_public_methods, :public_methods
    undef_method :public_methods
    alias_method :attr_public_methods=, :public_methods=
    undef_method :public_methods=
    
    attr_accessor :declared_constructors
    alias_method :attr_declared_constructors, :declared_constructors
    undef_method :declared_constructors
    alias_method :attr_declared_constructors=, :declared_constructors=
    undef_method :declared_constructors=
    
    attr_accessor :public_constructors
    alias_method :attr_public_constructors, :public_constructors
    undef_method :public_constructors
    alias_method :attr_public_constructors=, :public_constructors=
    undef_method :public_constructors=
    
    # Intermediate results for getFields and getMethods
    attr_accessor :declared_public_fields
    alias_method :attr_declared_public_fields, :declared_public_fields
    undef_method :declared_public_fields
    alias_method :attr_declared_public_fields=, :declared_public_fields=
    undef_method :declared_public_fields=
    
    attr_accessor :declared_public_methods
    alias_method :attr_declared_public_methods, :declared_public_methods
    undef_method :declared_public_methods
    alias_method :attr_declared_public_methods=, :declared_public_methods=
    undef_method :declared_public_methods=
    
    # Incremented by the VM on each call to JVM TI RedefineClasses()
    # that redefines this class or a superclass.
    attr_accessor :class_redefined_count
    alias_method :attr_class_redefined_count, :class_redefined_count
    undef_method :class_redefined_count
    alias_method :attr_class_redefined_count=, :class_redefined_count=
    undef_method :class_redefined_count=
    
    # Value of classRedefinedCount when we last cleared the cached values
    # that are sensitive to class redefinition.
    attr_accessor :last_redefined_count
    alias_method :attr_last_redefined_count, :last_redefined_count
    undef_method :last_redefined_count
    alias_method :attr_last_redefined_count=, :last_redefined_count=
    undef_method :last_redefined_count=
    
    typesig { [] }
    # Clears cached values that might possibly have been obsoleted by
    # a class redefinition.
    def clear_caches_on_class_redefinition
      if (!(@last_redefined_count).equal?(@class_redefined_count))
        @declared_fields = @public_fields = @declared_public_fields = nil
        @declared_methods = @public_methods = @declared_public_methods = nil
        @declared_constructors = @public_constructors = nil
        @annotations = @declared_annotations = nil
        # Use of "volatile" (and synchronization by caller in the case
        # of annotations) ensures that no thread sees the update to
        # lastRedefinedCount before seeing the caches cleared.
        # We do not guard against brief windows during which multiple
        # threads might redundantly work to fill an empty cache.
        @last_redefined_count = @class_redefined_count
      end
    end
    
    JNI.native_method :Java_java_lang_Class_getGenericSignature, [:pointer, :long], :long
    typesig { [] }
    # Generic signature handling
    def get_generic_signature
      JNI.__send__(:Java_java_lang_Class_getGenericSignature, JNI.env, self.jni_id)
    end
    
    # Generic info repository; lazily initialized
    attr_accessor :generic_info
    alias_method :attr_generic_info, :generic_info
    undef_method :generic_info
    alias_method :attr_generic_info=, :generic_info=
    undef_method :generic_info=
    
    typesig { [] }
    # accessor for factory
    def get_factory
      # create scope and factory
      return CoreReflectionFactory.make(self, ClassScope.make(self))
    end
    
    typesig { [] }
    # accessor for generic info repository
    def get_generic_info
      # lazily initialize repository if necessary
      if ((@generic_info).nil?)
        # create and cache generic info repository
        @generic_info = ClassRepository.make(get_generic_signature, get_factory)
      end
      return @generic_info # return cached repository
    end
    
    JNI.native_method :Java_java_lang_Class_getRawAnnotations, [:pointer, :long], :long
    typesig { [] }
    # Annotations handling
    def get_raw_annotations
      JNI.__send__(:Java_java_lang_Class_getRawAnnotations, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Class_getConstantPool, [:pointer, :long], :long
    typesig { [] }
    def get_constant_pool
      JNI.__send__(:Java_java_lang_Class_getConstantPool, JNI.env, self.jni_id)
    end
    
    typesig { [::Java::Boolean] }
    # java.lang.reflect.Field handling
    # 
    # 
    # Returns an array of "root" fields. These Field objects must NOT
    # be propagated to the outside world, but must instead be copied
    # via ReflectionFactory.copyField.
    def private_get_declared_fields(public_only)
      check_initted
      res = nil
      if (self.attr_use_caches)
        clear_caches_on_class_redefinition
        if (public_only)
          if (!(@declared_public_fields).nil?)
            res = @declared_public_fields.get
          end
        else
          if (!(@declared_fields).nil?)
            res = @declared_fields.get
          end
        end
        if (!(res).nil?)
          return res
        end
      end
      # No cached value available; request value from VM
      res = Reflection.filter_fields(self, get_declared_fields0(public_only))
      if (self.attr_use_caches)
        if (public_only)
          @declared_public_fields = SoftReference.new(res)
        else
          @declared_fields = SoftReference.new(res)
        end
      end
      return res
    end
    
    typesig { [JavaSet] }
    # Returns an array of "root" fields. These Field objects must NOT
    # be propagated to the outside world, but must instead be copied
    # via ReflectionFactory.copyField.
    def private_get_public_fields(traversed_interfaces)
      check_initted
      res = nil
      if (self.attr_use_caches)
        clear_caches_on_class_redefinition
        if (!(@public_fields).nil?)
          res = @public_fields.get
        end
        if (!(res).nil?)
          return res
        end
      end
      # No cached value available; compute value recursively.
      # Traverse in correct order for getField().
      fields = ArrayList.new
      if ((traversed_interfaces).nil?)
        traversed_interfaces = HashSet.new
      end
      # Local fields
      tmp = private_get_declared_fields(true)
      add_all(fields, tmp)
      # Direct superinterfaces, recursively
      interfaces = get_interfaces
      i = 0
      while i < interfaces.attr_length
        c = interfaces[i]
        if (!traversed_interfaces.contains(c))
          traversed_interfaces.add(c)
          add_all(fields, c.private_get_public_fields(traversed_interfaces))
        end
        i += 1
      end
      # Direct superclass, recursively
      if (!is_interface)
        c = get_superclass
        if (!(c).nil?)
          add_all(fields, c.private_get_public_fields(traversed_interfaces))
        end
      end
      res = Array.typed(Field).new(fields.size) { nil }
      fields.to_array(res)
      if (self.attr_use_caches)
        @public_fields = SoftReference.new(res)
      end
      return res
    end
    
    class_module.module_eval {
      typesig { [Collection, Array.typed(Field)] }
      def add_all(c, o)
        i = 0
        while i < o.attr_length
          c.add(o[i])
          i += 1
        end
      end
    }
    
    typesig { [::Java::Boolean] }
    # java.lang.reflect.Constructor handling
    # 
    # 
    # Returns an array of "root" constructors. These Constructor
    # objects must NOT be propagated to the outside world, but must
    # instead be copied via ReflectionFactory.copyConstructor.
    def private_get_declared_constructors(public_only)
      check_initted
      res = nil
      if (self.attr_use_caches)
        clear_caches_on_class_redefinition
        if (public_only)
          if (!(@public_constructors).nil?)
            res = @public_constructors.get
          end
        else
          if (!(@declared_constructors).nil?)
            res = @declared_constructors.get
          end
        end
        if (!(res).nil?)
          return res
        end
      end
      # No cached value available; request value from VM
      if (is_interface)
        res = Array.typed(Constructor).new(0) { nil }
      else
        res = get_declared_constructors0(public_only)
      end
      if (self.attr_use_caches)
        if (public_only)
          @public_constructors = SoftReference.new(res)
        else
          @declared_constructors = SoftReference.new(res)
        end
      end
      return res
    end
    
    typesig { [::Java::Boolean] }
    # java.lang.reflect.Method handling
    # 
    # 
    # Returns an array of "root" methods. These Method objects must NOT
    # be propagated to the outside world, but must instead be copied
    # via ReflectionFactory.copyMethod.
    def private_get_declared_methods(public_only)
      check_initted
      res = nil
      if (self.attr_use_caches)
        clear_caches_on_class_redefinition
        if (public_only)
          if (!(@declared_public_methods).nil?)
            res = @declared_public_methods.get
          end
        else
          if (!(@declared_methods).nil?)
            res = @declared_methods.get
          end
        end
        if (!(res).nil?)
          return res
        end
      end
      # No cached value available; request value from VM
      res = Reflection.filter_methods(self, get_declared_methods0(public_only))
      if (self.attr_use_caches)
        if (public_only)
          @declared_public_methods = SoftReference.new(res)
        else
          @declared_methods = SoftReference.new(res)
        end
      end
      return res
    end
    
    class_module.module_eval {
      const_set_lazy(:MethodArray) { Class.new do
        include_class_members Class
        
        attr_accessor :methods
        alias_method :attr_methods, :methods
        undef_method :methods
        alias_method :attr_methods=, :methods=
        undef_method :methods=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        typesig { [] }
        def initialize
          @methods = nil
          @length = 0
          @methods = Array.typed(self.class::Method).new(20) { nil }
          @length = 0
        end
        
        typesig { [class_self::Method] }
        def add(m)
          if ((@length).equal?(@methods.attr_length))
            @methods = Arrays.copy_of(@methods, 2 * @methods.attr_length)
          end
          @methods[((@length += 1) - 1)] = m
        end
        
        typesig { [Array.typed(class_self::Method)] }
        def add_all(ma)
          i = 0
          while i < ma.attr_length
            add(ma[i])
            i += 1
          end
        end
        
        typesig { [class_self::MethodArray] }
        def add_all(ma)
          i = 0
          while i < ma.length
            add(ma.get(i))
            i += 1
          end
        end
        
        typesig { [class_self::Method] }
        def add_if_not_present(new_method)
          i = 0
          while i < @length
            m = @methods[i]
            if ((m).equal?(new_method) || (!(m).nil? && (m == new_method)))
              return
            end
            i += 1
          end
          add(new_method)
        end
        
        typesig { [class_self::MethodArray] }
        def add_all_if_not_present(new_methods)
          i = 0
          while i < new_methods.length
            m = new_methods.get(i)
            if (!(m).nil?)
              add_if_not_present(m)
            end
            i += 1
          end
        end
        
        typesig { [] }
        def length
          return @length
        end
        
        typesig { [::Java::Int] }
        def get(i)
          return @methods[i]
        end
        
        typesig { [class_self::Method] }
        def remove_by_name_and_signature(to_remove)
          i = 0
          while i < @length
            m = @methods[i]
            if (!(m).nil? && (m.get_return_type).equal?(to_remove.get_return_type) && (m.get_name).equal?(to_remove.get_name) && array_contents_eq(m.get_parameter_types, to_remove.get_parameter_types))
              @methods[i] = nil
            end
            i += 1
          end
        end
        
        typesig { [] }
        def compact_and_trim
          new_pos = 0
          # Get rid of null slots
          pos = 0
          while pos < @length
            m = @methods[pos]
            if (!(m).nil?)
              if (!(pos).equal?(new_pos))
                @methods[new_pos] = m
              end
              new_pos += 1
            end
            pos += 1
          end
          if (!(new_pos).equal?(@methods.attr_length))
            @methods = Arrays.copy_of(@methods, new_pos)
          end
        end
        
        typesig { [] }
        def get_array
          return @methods
        end
        
        private
        alias_method :initialize__method_array, :initialize
      end }
    }
    
    typesig { [] }
    # Returns an array of "root" methods. These Method objects must NOT
    # be propagated to the outside world, but must instead be copied
    # via ReflectionFactory.copyMethod.
    def private_get_public_methods
      check_initted
      res = nil
      if (self.attr_use_caches)
        clear_caches_on_class_redefinition
        if (!(@public_methods).nil?)
          res = @public_methods.get
        end
        if (!(res).nil?)
          return res
        end
      end
      # No cached value available; compute value recursively.
      # Start by fetching public declared methods
      methods = MethodArray.new
      tmp = private_get_declared_methods(true)
      methods.add_all(tmp)
      # Now recur over superclass and direct superinterfaces.
      # Go over superinterfaces first so we can more easily filter
      # out concrete implementations inherited from superclasses at
      # the end.
      inherited_methods = MethodArray.new
      interfaces = get_interfaces
      i = 0
      while i < interfaces.attr_length
        inherited_methods.add_all(interfaces[i].private_get_public_methods)
        i += 1
      end
      if (!is_interface)
        c = get_superclass
        if (!(c).nil?)
          supers = MethodArray.new
          supers.add_all(c.private_get_public_methods)
          # Filter out concrete implementations of any
          # interface methods
          i_ = 0
          while i_ < supers.length
            m = supers.get(i_)
            if (!(m).nil? && !Modifier.is_abstract(m.get_modifiers))
              inherited_methods.remove_by_name_and_signature(m)
            end
            i_ += 1
          end
          # Insert superclass's inherited methods before
          # superinterfaces' to satisfy getMethod's search
          # order
          supers.add_all(inherited_methods)
          inherited_methods = supers
        end
      end
      # Filter out all local methods from inherited ones
      i_ = 0
      while i_ < methods.length
        m = methods.get(i_)
        inherited_methods.remove_by_name_and_signature(m)
        i_ += 1
      end
      methods.add_all_if_not_present(inherited_methods)
      methods.compact_and_trim
      res = methods.get_array
      if (self.attr_use_caches)
        @public_methods = SoftReference.new(res)
      end
      return res
    end
    
    typesig { [Array.typed(Field), String] }
    # Helpers for fetchers of one field, method, or constructor
    def search_fields(fields, name)
      interned_name = name.intern
      i = 0
      while i < fields.attr_length
        if ((fields[i].get_name).equal?(interned_name))
          return get_reflection_factory.copy_field(fields[i])
        end
        i += 1
      end
      return nil
    end
    
    typesig { [String] }
    def get_field0(name)
      # Note: the intent is that the search algorithm this routine
      # uses be equivalent to the ordering imposed by
      # privateGetPublicFields(). It fetches only the declared
      # public fields for each class, however, to reduce the number
      # of Field objects which have to be created for the common
      # case where the field being requested is declared in the
      # class which is being queried.
      res = nil
      # Search declared public fields
      if (!((res = search_fields(private_get_declared_fields(true), name))).nil?)
        return res
      end
      # Direct superinterfaces, recursively
      interfaces = get_interfaces
      i = 0
      while i < interfaces.attr_length
        c = interfaces[i]
        if (!((res = c.get_field0(name))).nil?)
          return res
        end
        i += 1
      end
      # Direct superclass, recursively
      if (!is_interface)
        c = get_superclass
        if (!(c).nil?)
          if (!((res = c.get_field0(name))).nil?)
            return res
          end
        end
      end
      return nil
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Method), String, Array.typed(Class)] }
      def search_methods(methods, name, parameter_types)
        res = nil
        interned_name = name.intern
        i = 0
        while i < methods.attr_length
          m = methods[i]
          if ((m.get_name).equal?(interned_name) && array_contents_eq(parameter_types, m.get_parameter_types) && ((res).nil? || res.get_return_type.is_assignable_from(m.get_return_type)))
            res = m
          end
          i += 1
        end
        return ((res).nil? ? res : get_reflection_factory.copy_method(res))
      end
    }
    
    typesig { [String, Array.typed(Class)] }
    def get_method0(name, parameter_types)
      # Note: the intent is that the search algorithm this routine
      # uses be equivalent to the ordering imposed by
      # privateGetPublicMethods(). It fetches only the declared
      # public methods for each class, however, to reduce the
      # number of Method objects which have to be created for the
      # common case where the method being requested is declared in
      # the class which is being queried.
      res = nil
      # Search declared public methods
      if (!((res = search_methods(private_get_declared_methods(true), name, parameter_types))).nil?)
        return res
      end
      # Search superclass's methods
      if (!is_interface)
        c = get_superclass
        if (!(c).nil?)
          if (!((res = c.get_method0(name, parameter_types))).nil?)
            return res
          end
        end
      end
      # Search superinterfaces' methods
      interfaces = get_interfaces
      i = 0
      while i < interfaces.attr_length
        c = interfaces[i]
        if (!((res = c.get_method0(name, parameter_types))).nil?)
          return res
        end
        i += 1
      end
      # Not found
      return nil
    end
    
    typesig { [Array.typed(Class), ::Java::Int] }
    def get_constructor0(parameter_types, which)
      constructors = private_get_declared_constructors(((which).equal?(Member::PUBLIC)))
      i = 0
      while i < constructors.attr_length
        if (array_contents_eq(parameter_types, constructors[i].get_parameter_types))
          return get_reflection_factory.copy_constructor(constructors[i])
        end
        i += 1
      end
      raise NoSuchMethodException.new(RJava.cast_to_string(get_name) + ".<init>" + RJava.cast_to_string(argument_types_to_string(parameter_types)))
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Object), Array.typed(Object)] }
      # Other helpers and base implementation
      def array_contents_eq(a1, a2)
        if ((a1).nil?)
          return (a2).nil? || (a2.attr_length).equal?(0)
        end
        if ((a2).nil?)
          return (a1.attr_length).equal?(0)
        end
        if (!(a1.attr_length).equal?(a2.attr_length))
          return false
        end
        i = 0
        while i < a1.attr_length
          if (!(a1[i]).equal?(a2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(Field)] }
      def copy_fields(arg)
        out = Array.typed(Field).new(arg.attr_length) { nil }
        fact = get_reflection_factory
        i = 0
        while i < arg.attr_length
          out[i] = fact.copy_field(arg[i])
          i += 1
        end
        return out
      end
      
      typesig { [Array.typed(Method)] }
      def copy_methods(arg)
        out = Array.typed(Method).new(arg.attr_length) { nil }
        fact = get_reflection_factory
        i = 0
        while i < arg.attr_length
          out[i] = fact.copy_method(arg[i])
          i += 1
        end
        return out
      end
      
      typesig { [Array.typed(Constructor)] }
      def copy_constructors(arg)
        out = Array.typed(Constructor).new(arg.attr_length) { nil }
        fact = get_reflection_factory
        i = 0
        while i < arg.attr_length
          out[i] = fact.copy_constructor(arg[i])
          i += 1
        end
        return out
      end
    }
    
    JNI.native_method :Java_java_lang_Class_getDeclaredFields0, [:pointer, :long, :int8], :long
    typesig { [::Java::Boolean] }
    def get_declared_fields0(public_only)
      JNI.__send__(:Java_java_lang_Class_getDeclaredFields0, JNI.env, self.jni_id, public_only ? 1 : 0)
    end
    
    JNI.native_method :Java_java_lang_Class_getDeclaredMethods0, [:pointer, :long, :int8], :long
    typesig { [::Java::Boolean] }
    def get_declared_methods0(public_only)
      JNI.__send__(:Java_java_lang_Class_getDeclaredMethods0, JNI.env, self.jni_id, public_only ? 1 : 0)
    end
    
    JNI.native_method :Java_java_lang_Class_getDeclaredConstructors0, [:pointer, :long, :int8], :long
    typesig { [::Java::Boolean] }
    def get_declared_constructors0(public_only)
      JNI.__send__(:Java_java_lang_Class_getDeclaredConstructors0, JNI.env, self.jni_id, public_only ? 1 : 0)
    end
    
    JNI.native_method :Java_java_lang_Class_getDeclaredClasses0, [:pointer, :long], :long
    typesig { [] }
    def get_declared_classes0
      JNI.__send__(:Java_java_lang_Class_getDeclaredClasses0, JNI.env, self.jni_id)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Class)] }
      def argument_types_to_string(arg_types)
        buf = StringBuilder.new
        buf.append("(")
        if (!(arg_types).nil?)
          i = 0
          while i < arg_types.attr_length
            if (i > 0)
              buf.append(", ")
            end
            c = arg_types[i]
            buf.append(((c).nil?) ? "null" : c.get_name)
            i += 1
          end
        end
        buf.append(")")
        return buf.to_s
      end
      
      # use serialVersionUID from JDK 1.1 for interoperability
      const_set_lazy(:SerialVersionUID) { 3206093459760846163 }
      const_attr_reader  :SerialVersionUID
      
      # Class Class is special cased within the Serialization Stream Protocol.
      # 
      # A Class instance is written initially into an ObjectOutputStream in the
      # following format:
      # <pre>
      # {@code TC_CLASS} ClassDescriptor
      # A ClassDescriptor is a special cased serialization of
      # a {@code java.io.ObjectStreamClass} instance.
      # </pre>
      # A new handle is generated for the initial time the class descriptor
      # is written into the stream. Future references to the class descriptor
      # are written as references to the initial class descriptor instance.
      # 
      # @see java.io.ObjectStreamClass
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new(0) { nil } }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [] }
    # Returns the assertion status that would be assigned to this
    # class if it were to be initialized at the time this method is invoked.
    # If this class has had its assertion status set, the most recent
    # setting will be returned; otherwise, if any package default assertion
    # status pertains to this class, the most recent setting for the most
    # specific pertinent package default assertion status is returned;
    # otherwise, if this class is not a system class (i.e., it has a
    # class loader) its class loader's default assertion status is returned;
    # otherwise, the system class default assertion status is returned.
    # <p>
    # Few programmers will have any need for this method; it is provided
    # for the benefit of the JRE itself.  (It allows a class to determine at
    # the time that it is initialized whether assertions should be enabled.)
    # Note that this method is not guaranteed to return the actual
    # assertion status that was (or will be) associated with the specified
    # class when it was (or will be) initialized.
    # 
    # @return the desired assertion status of the specified class.
    # @see    java.lang.ClassLoader#setClassAssertionStatus
    # @see    java.lang.ClassLoader#setPackageAssertionStatus
    # @see    java.lang.ClassLoader#setDefaultAssertionStatus
    # @since  1.4
    def desired_assertion_status
      loader = get_class_loader
      # If the loader is null this is a system class, so ask the VM
      if ((loader).nil?)
        return desired_assertion_status0(self)
      end
      synchronized((loader)) do
        # If the classloader has been initialized with
        # the assertion directives, ask it. Otherwise,
        # ask the VM.
        return ((loader.attr_class_assertion_status).nil? ? desired_assertion_status0(self) : loader.desired_assertion_status(get_name))
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_Class_desiredAssertionStatus0, [:pointer, :long, :long], :int8
      typesig { [Class] }
      # Retrieves the desired assertion status of this class from the VM
      def desired_assertion_status0(clazz)
        JNI.__send__(:Java_java_lang_Class_desiredAssertionStatus0, JNI.env, self.jni_id, clazz.jni_id) != 0
      end
    }
    
    typesig { [] }
    # Returns true if and only if this class was declared as an enum in the
    # source code.
    # 
    # @return true if and only if this class was declared as an enum in the
    # source code
    # @since 1.5
    def is_enum
      # An enum must both directly extend java.lang.Enum and have
      # the ENUM bit set; classes for specialized enum constants
      # don't do the former.
      return !((self.get_modifiers & ENUM)).equal?(0) && (self.get_superclass).equal?(Java::Lang::Enum)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Fetches the factory for reflective objects
      def get_reflection_factory
        if ((self.attr_reflection_factory).nil?)
          self.attr_reflection_factory = Java::Security::AccessController.do_privileged(Sun::Reflect::ReflectionFactory::GetReflectionFactoryAction.new)
        end
        return self.attr_reflection_factory
      end
      
      
      def reflection_factory
        defined?(@@reflection_factory) ? @@reflection_factory : @@reflection_factory= nil
      end
      alias_method :attr_reflection_factory, :reflection_factory
      
      def reflection_factory=(value)
        @@reflection_factory = value
      end
      alias_method :attr_reflection_factory=, :reflection_factory=
      
      # To be able to query system properties as soon as they're available
      
      def initted
        defined?(@@initted) ? @@initted : @@initted= false
      end
      alias_method :attr_initted, :initted
      
      def initted=(value)
        @@initted = value
      end
      alias_method :attr_initted=, :initted=
      
      typesig { [] }
      def check_initted
        if (self.attr_initted)
          return
        end
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Class
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            # Tests to ensure the system properties table is fully
            # initialized. This is needed because reflection code is
            # called very early in the initialization process (before
            # command-line arguments have been parsed and therefore
            # these user-settable properties installed.) We assume that
            # if System.out is non-null then the System class has been
            # fully initialized and that the bulk of the startup code
            # has been run.
            if ((System.out).nil?)
              # java.lang.System not yet fully initialized
              return nil
            end
            val = System.get_property("sun.reflect.noCaches")
            if (!(val).nil? && (val == "true"))
              self.attr_use_caches = false
            end
            self.attr_initted = true
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    }
    
    typesig { [] }
    # Returns the elements of this enum class or null if this
    # Class object does not represent an enum type.
    # 
    # @return an array containing the values comprising the enum class
    # represented by this Class object in the order they're
    # declared, or null if this Class object does not
    # represent an enum type
    # @since 1.5
    def get_enum_constants
      values = get_enum_constants_shared
      return (!(values).nil?) ? values.clone : nil
    end
    
    typesig { [] }
    # Returns the elements of this enum class or null if this
    # Class object does not represent an enum type;
    # identical to getEnumConstantsShared except that
    # the result is uncloned, cached, and shared by all callers.
    def get_enum_constants_shared
      if ((@enum_constants).nil?)
        if (!is_enum)
          return nil
        end
        begin
          values = get_method("values")
          Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members Class
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              values.set_accessible(true)
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @enum_constants = values.invoke(nil)
        # These can happen when users concoct enum-like classes
        # that don't comply with the enum spec.
        rescue InvocationTargetException => ex
          return nil
        rescue NoSuchMethodException => ex
          return nil
        rescue IllegalAccessException => ex
          return nil
        end
      end
      return @enum_constants
    end
    
    attr_accessor :enum_constants
    alias_method :attr_enum_constants, :enum_constants
    undef_method :enum_constants
    alias_method :attr_enum_constants=, :enum_constants=
    undef_method :enum_constants=
    
    typesig { [] }
    # Returns a map from simple name to enum constant.  This package-private
    # method is used internally by Enum to implement
    # public static <T extends Enum<T>> T valueOf(Class<T>, String)
    # efficiently.  Note that the map is returned by this method is
    # created lazily on first use.  Typically it won't ever get created.
    def enum_constant_directory
      if ((@enum_constant_directory).nil?)
        universe = get_enum_constants_shared
        if ((universe).nil?)
          raise IllegalArgumentException.new(RJava.cast_to_string(get_name) + " is not an enum type")
        end
        m = HashMap.new(2 * universe.attr_length)
        universe.each do |constant|
          m.put((constant).name, constant)
        end
        @enum_constant_directory = m
      end
      return @enum_constant_directory
    end
    
    attr_accessor :enum_constant_directory
    alias_method :attr_enum_constant_directory, :enum_constant_directory
    undef_method :enum_constant_directory
    alias_method :attr_enum_constant_directory=, :enum_constant_directory=
    undef_method :enum_constant_directory=
    
    typesig { [Object] }
    # Casts an object to the class or interface represented
    # by this {@code Class} object.
    # 
    # @param obj the object to be cast
    # @return the object after casting, or null if obj is null
    # 
    # @throws ClassCastException if the object is not
    # null and is not assignable to the type T.
    # 
    # @since 1.5
    def cast(obj)
      if (!(obj).nil? && !is_instance(obj))
        raise ClassCastException.new(cannot_cast_msg(obj))
      end
      return obj
    end
    
    typesig { [Object] }
    def cannot_cast_msg(obj)
      return "Cannot cast " + RJava.cast_to_string(obj.get_class.get_name) + " to " + RJava.cast_to_string(get_name)
    end
    
    typesig { [Class] }
    # Casts this {@code Class} object to represent a subclass of the class
    # represented by the specified class object.  Checks that that the cast
    # is valid, and throws a {@code ClassCastException} if it is not.  If
    # this method succeeds, it always returns a reference to this class object.
    # 
    # <p>This method is useful when a client needs to "narrow" the type of
    # a {@code Class} object to pass it to an API that restricts the
    # {@code Class} objects that it is willing to accept.  A cast would
    # generate a compile-time warning, as the correctness of the cast
    # could not be checked at runtime (because generic types are implemented
    # by erasure).
    # 
    # @return this {@code Class} object, cast to represent a subclass of
    # the specified class object.
    # @throws ClassCastException if this {@code Class} object does not
    # represent a subclass of the specified class (here "subclass" includes
    # the class itself).
    # @since 1.5
    def as_subclass(clazz)
      if (clazz.is_assignable_from(self))
        return self
      else
        raise ClassCastException.new(self.to_s)
      end
    end
    
    typesig { [Class] }
    # @throws NullPointerException {@inheritDoc}
    # @since 1.5
    def get_annotation(annotation_class)
      if ((annotation_class).nil?)
        raise NullPointerException.new
      end
      init_annotations_if_necessary
      return @annotations.get(annotation_class)
    end
    
    typesig { [Class] }
    # @throws NullPointerException {@inheritDoc}
    # @since 1.5
    def is_annotation_present(annotation_class)
      if ((annotation_class).nil?)
        raise NullPointerException.new
      end
      return !(get_annotation(annotation_class)).nil?
    end
    
    class_module.module_eval {
      
      def empty_annotations_array
        defined?(@@empty_annotations_array) ? @@empty_annotations_array : @@empty_annotations_array= Array.typed(Annotation).new(0) { nil }
      end
      alias_method :attr_empty_annotations_array, :empty_annotations_array
      
      def empty_annotations_array=(value)
        @@empty_annotations_array = value
      end
      alias_method :attr_empty_annotations_array=, :empty_annotations_array=
    }
    
    typesig { [] }
    # @since 1.5
    def get_annotations
      init_annotations_if_necessary
      return @annotations.values.to_array(self.attr_empty_annotations_array)
    end
    
    typesig { [] }
    # @since 1.5
    def get_declared_annotations
      init_annotations_if_necessary
      return @declared_annotations.values.to_array(self.attr_empty_annotations_array)
    end
    
    # Annotations cache
    attr_accessor :annotations
    alias_method :attr_annotations, :annotations
    undef_method :annotations
    alias_method :attr_annotations=, :annotations=
    undef_method :annotations=
    
    attr_accessor :declared_annotations
    alias_method :attr_declared_annotations, :declared_annotations
    undef_method :declared_annotations
    alias_method :attr_declared_annotations=, :declared_annotations=
    undef_method :declared_annotations=
    
    typesig { [] }
    def init_annotations_if_necessary
      synchronized(self) do
        clear_caches_on_class_redefinition
        if (!(@annotations).nil?)
          return
        end
        @declared_annotations = AnnotationParser.parse_annotations(get_raw_annotations, get_constant_pool, self)
        super_class = get_superclass
        if ((super_class).nil?)
          @annotations = @declared_annotations
        else
          @annotations = HashMap.new
          super_class.init_annotations_if_necessary
          super_class.attr_annotations.entry_set.each do |e|
            annotation_class = e.get_key
            if (AnnotationType.get_instance(annotation_class).is_inherited)
              @annotations.put(annotation_class, e.get_value)
            end
          end
          @annotations.put_all(@declared_annotations)
        end
      end
    end
    
    # Annotation types cache their internal (AnnotationType) form
    attr_accessor :annotation_type
    alias_method :attr_annotation_type, :annotation_type
    undef_method :annotation_type
    alias_method :attr_annotation_type=, :annotation_type=
    undef_method :annotation_type=
    
    typesig { [AnnotationType] }
    def set_annotation_type(type)
      @annotation_type = type
    end
    
    typesig { [] }
    def get_annotation_type
      return @annotation_type
    end
    
    private
    alias_method :initialize__class, :initialize
  end
  
end
