require "rjava"

# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module ReflectionFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # <P> The master factory for all reflective objects, both those in
  # java.lang.reflect (Fields, Methods, Constructors) as well as their
  # delegates (FieldAccessors, MethodAccessors, ConstructorAccessors).
  # </P>
  # 
  # <P> The methods in this class are extremely unsafe and can cause
  # subversion of both the language and the verifier. For this reason,
  # they are all instance methods, and access to the constructor of
  # this factory is guarded by a security check, in similar style to
  # {@link sun.misc.Unsafe}. </P>
  class ReflectionFactory 
    include_class_members ReflectionFactoryImports
    
    class_module.module_eval {
      
      def initted
        defined?(@@initted) ? @@initted : @@initted= false
      end
      alias_method :attr_initted, :initted
      
      def initted=(value)
        @@initted = value
      end
      alias_method :attr_initted=, :initted=
      
      
      def reflection_factory_access_perm
        defined?(@@reflection_factory_access_perm) ? @@reflection_factory_access_perm : @@reflection_factory_access_perm= RuntimePermission.new("reflectionFactoryAccess")
      end
      alias_method :attr_reflection_factory_access_perm, :reflection_factory_access_perm
      
      def reflection_factory_access_perm=(value)
        @@reflection_factory_access_perm = value
      end
      alias_method :attr_reflection_factory_access_perm=, :reflection_factory_access_perm=
      
      
      def sole_instance
        defined?(@@sole_instance) ? @@sole_instance : @@sole_instance= ReflectionFactory.new
      end
      alias_method :attr_sole_instance, :sole_instance
      
      def sole_instance=(value)
        @@sole_instance = value
      end
      alias_method :attr_sole_instance=, :sole_instance=
      
      # Provides access to package-private mechanisms in java.lang.reflect
      
      def lang_reflect_access
        defined?(@@lang_reflect_access) ? @@lang_reflect_access : @@lang_reflect_access= nil
      end
      alias_method :attr_lang_reflect_access, :lang_reflect_access
      
      def lang_reflect_access=(value)
        @@lang_reflect_access = value
      end
      alias_method :attr_lang_reflect_access=, :lang_reflect_access=
      
      # "Inflation" mechanism. Loading bytecodes to implement
      # Method.invoke() and Constructor.newInstance() currently costs
      # 3-4x more than an invocation via native code for the first
      # invocation (though subsequent invocations have been benchmarked
      # to be over 20x faster). Unfortunately this cost increases
      # startup time for certain applications that use reflection
      # intensively (but only once per class) to bootstrap themselves.
      # To avoid this penalty we reuse the existing JVM entry points
      # for the first few invocations of Methods and Constructors and
      # then switch to the bytecode-based implementations.
      # 
      # Package-private to be accessible to NativeMethodAccessorImpl
      # and NativeConstructorAccessorImpl
      
      def no_inflation
        defined?(@@no_inflation) ? @@no_inflation : @@no_inflation= false
      end
      alias_method :attr_no_inflation, :no_inflation
      
      def no_inflation=(value)
        @@no_inflation = value
      end
      alias_method :attr_no_inflation=, :no_inflation=
      
      
      def inflation_threshold
        defined?(@@inflation_threshold) ? @@inflation_threshold : @@inflation_threshold= 15
      end
      alias_method :attr_inflation_threshold, :inflation_threshold
      
      def inflation_threshold=(value)
        @@inflation_threshold = value
      end
      alias_method :attr_inflation_threshold=, :inflation_threshold=
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      # A convenience class for acquiring the capability to instantiate
      # reflective objects.  Use this instead of a raw call to {@link
      # #getReflectionFactory} in order to avoid being limited by the
      # permissions of your callers.
      # 
      # <p>An instance of this class can be used as the argument of
      # <code>AccessController.doPrivileged</code>.
      const_set_lazy(:GetReflectionFactoryAction) { Class.new do
        include_class_members ReflectionFactory
        include PrivilegedAction
        
        typesig { [] }
        def run
          return get_reflection_factory
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__get_reflection_factory_action, :initialize
      end }
      
      typesig { [] }
      # Provides the caller with the capability to instantiate reflective
      # objects.
      # 
      # <p> First, if there is a security manager, its
      # <code>checkPermission</code> method is called with a {@link
      # java.lang.RuntimePermission} with target
      # <code>"reflectionFactoryAccess"</code>.  This may result in a
      # security exception.
      # 
      # <p> The returned <code>ReflectionFactory</code> object should be
      # carefully guarded by the caller, since it can be used to read and
      # write private data and invoke private methods, as well as to load
      # unverified bytecodes.  It must never be passed to untrusted code.
      # 
      # @exception SecurityException if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow
      # access to the RuntimePermission "reflectionFactoryAccess".
      def get_reflection_factory
        security = System.get_security_manager
        if (!(security).nil?)
          # TO DO: security.checkReflectionFactoryAccess();
          security.check_permission(self.attr_reflection_factory_access_perm)
        end
        return self.attr_sole_instance
      end
    }
    
    typesig { [LangReflectAccess] }
    # --------------------------------------------------------------------------
    # 
    # Routines used by java.lang.reflect
    # 
    # 
    # Called only by java.lang.reflect.Modifier's static initializer
    def set_lang_reflect_access(access)
      self.attr_lang_reflect_access = access
    end
    
    typesig { [Field, ::Java::Boolean] }
    # Note: this routine can cause the declaring class for the field
    # be initialized and therefore must not be called until the
    # first get/set of this field.
    # @param field the field
    # @param override true if caller has overridden aaccessibility
    def new_field_accessor(field, override)
      check_initted
      return UnsafeFieldAccessorFactory.new_field_accessor(field, override)
    end
    
    typesig { [Method] }
    def new_method_accessor(method)
      check_initted
      if (self.attr_no_inflation)
        return MethodAccessorGenerator.new.generate_method(method.get_declaring_class, method.get_name, method.get_parameter_types, method.get_return_type, method.get_exception_types, method.get_modifiers)
      else
        acc = NativeMethodAccessorImpl.new(method)
        res = DelegatingMethodAccessorImpl.new(acc)
        acc.set_parent(res)
        return res
      end
    end
    
    typesig { [Constructor] }
    def new_constructor_accessor(c)
      check_initted
      declaring_class = c.get_declaring_class
      if (Modifier.is_abstract(declaring_class.get_modifiers))
        return InstantiationExceptionConstructorAccessorImpl.new(nil)
      end
      if ((declaring_class).equal?(Class))
        return InstantiationExceptionConstructorAccessorImpl.new("Can not instantiate java.lang.Class")
      end
      # Bootstrapping issue: since we use Class.newInstance() in
      # the ConstructorAccessor generation process, we have to
      # break the cycle here.
      if (Reflection.is_subclass_of(declaring_class, ConstructorAccessorImpl))
        return BootstrapConstructorAccessorImpl.new(c)
      end
      if (self.attr_no_inflation)
        return MethodAccessorGenerator.new.generate_constructor(c.get_declaring_class, c.get_parameter_types, c.get_exception_types, c.get_modifiers)
      else
        acc = NativeConstructorAccessorImpl.new(c)
        res = DelegatingConstructorAccessorImpl.new(acc)
        acc.set_parent(res)
        return res
      end
    end
    
    typesig { [Class, String, Class, ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte)] }
    # --------------------------------------------------------------------------
    # 
    # Routines used by java.lang
    # 
    # 
    # Creates a new java.lang.reflect.Field. Access checks as per
    # java.lang.reflect.AccessibleObject are not overridden.
    def new_field(declaring_class, name, type, modifiers, slot, signature, annotations)
      return lang_reflect_access.new_field(declaring_class, name, type, modifiers, slot, signature, annotations)
    end
    
    typesig { [Class, String, Array.typed(Class), Class, Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Creates a new java.lang.reflect.Method. Access checks as per
    # java.lang.reflect.AccessibleObject are not overridden.
    def new_method(declaring_class, name, parameter_types, return_type, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations, annotation_default)
      return lang_reflect_access.new_method(declaring_class, name, parameter_types, return_type, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations, annotation_default)
    end
    
    typesig { [Class, Array.typed(Class), Array.typed(Class), ::Java::Int, ::Java::Int, String, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Creates a new java.lang.reflect.Constructor. Access checks as
    # per java.lang.reflect.AccessibleObject are not overridden.
    def new_constructor(declaring_class, parameter_types, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations)
      return lang_reflect_access.new_constructor(declaring_class, parameter_types, checked_exceptions, modifiers, slot, signature, annotations, parameter_annotations)
    end
    
    typesig { [Method] }
    # Gets the MethodAccessor object for a java.lang.reflect.Method
    def get_method_accessor(m)
      return lang_reflect_access.get_method_accessor(m)
    end
    
    typesig { [Method, MethodAccessor] }
    # Sets the MethodAccessor object for a java.lang.reflect.Method
    def set_method_accessor(m, accessor)
      lang_reflect_access.set_method_accessor(m, accessor)
    end
    
    typesig { [Constructor] }
    # Gets the ConstructorAccessor object for a
    # java.lang.reflect.Constructor
    def get_constructor_accessor(c)
      return lang_reflect_access.get_constructor_accessor(c)
    end
    
    typesig { [Constructor, ConstructorAccessor] }
    # Sets the ConstructorAccessor object for a
    # java.lang.reflect.Constructor
    def set_constructor_accessor(c, accessor)
      lang_reflect_access.set_constructor_accessor(c, accessor)
    end
    
    typesig { [Method] }
    # Makes a copy of the passed method. The returned method is a
    # "child" of the passed one; see the comments in Method.java for
    # details.
    def copy_method(arg)
      return lang_reflect_access.copy_method(arg)
    end
    
    typesig { [Field] }
    # Makes a copy of the passed field. The returned field is a
    # "child" of the passed one; see the comments in Field.java for
    # details.
    def copy_field(arg)
      return lang_reflect_access.copy_field(arg)
    end
    
    typesig { [Constructor] }
    # Makes a copy of the passed constructor. The returned
    # constructor is a "child" of the passed one; see the comments
    # in Constructor.java for details.
    def copy_constructor(arg)
      return lang_reflect_access.copy_constructor(arg)
    end
    
    typesig { [Class, Constructor] }
    # --------------------------------------------------------------------------
    # 
    # Routines used by serialization
    def new_constructor_for_serialization(class_to_instantiate, constructor_to_call)
      # Fast path
      if ((constructor_to_call.get_declaring_class).equal?(class_to_instantiate))
        return constructor_to_call
      end
      acc = MethodAccessorGenerator.new.generate_serialization_constructor(class_to_instantiate, constructor_to_call.get_parameter_types, constructor_to_call.get_exception_types, constructor_to_call.get_modifiers, constructor_to_call.get_declaring_class)
      c = new_constructor(constructor_to_call.get_declaring_class, constructor_to_call.get_parameter_types, constructor_to_call.get_exception_types, constructor_to_call.get_modifiers, lang_reflect_access.get_constructor_slot(constructor_to_call), lang_reflect_access.get_constructor_signature(constructor_to_call), lang_reflect_access.get_constructor_annotations(constructor_to_call), lang_reflect_access.get_constructor_parameter_annotations(constructor_to_call))
      set_constructor_accessor(c, acc)
      return c
    end
    
    class_module.module_eval {
      typesig { [] }
      # --------------------------------------------------------------------------
      # 
      # Internals only below this point
      def inflation_threshold
        return self.attr_inflation_threshold
      end
      
      typesig { [] }
      # We have to defer full initialization of this class until after
      # the static initializer is run since java.lang.reflect.Method's
      # static initializer (more properly, that for
      # java.lang.reflect.AccessibleObject) causes this class's to be
      # run, before the system properties are set up.
      def check_initted
        if (self.attr_initted)
          return
        end
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ReflectionFactory
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
            val = System.get_property("sun.reflect.noInflation")
            if (!(val).nil? && (val == "true"))
              self.attr_no_inflation = true
            end
            val = RJava.cast_to_string(System.get_property("sun.reflect.inflationThreshold"))
            if (!(val).nil?)
              begin
                self.attr_inflation_threshold = JavaInteger.parse_int(val)
              rescue self.class::NumberFormatException => e
                raise self.class::RuntimeException.new("Unable to parse property sun.reflect.inflationThreshold").init_cause(e)
              end
            end
            self.attr_initted = true
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [] }
      def lang_reflect_access
        if ((self.attr_lang_reflect_access).nil?)
          # Call a static method to get class java.lang.reflect.Modifier
          # initialized. Its static initializer will cause
          # setLangReflectAccess() to be called from the context of the
          # java.lang.reflect package.
          Modifier.is_public(Modifier::PUBLIC)
        end
        return self.attr_lang_reflect_access
      end
    }
    
    private
    alias_method :initialize__reflection_factory, :initialize
  end
  
end
