require "rjava"

# 
# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AccessibleObjectImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Reflect, :ReflectionFactory
      include_const ::Java::Lang::Annotation, :Annotation
    }
  end
  
  # 
  # The AccessibleObject class is the base class for Field, Method and
  # Constructor objects.  It provides the ability to flag a reflected
  # object as suppressing default Java language access control checks
  # when it is used.  The access checks--for public, default (package)
  # access, protected, and private members--are performed when Fields,
  # Methods or Constructors are used to set or get fields, to invoke
  # methods, or to create and initialize new instances of classes,
  # respectively.
  # 
  # <p>Setting the {@code accessible} flag in a reflected object
  # permits sophisticated applications with sufficient privilege, such
  # as Java Object Serialization or other persistence mechanisms, to
  # manipulate objects in a manner that would normally be prohibited.
  # 
  # @see Field
  # @see Method
  # @see Constructor
  # @see ReflectPermission
  # 
  # @since 1.2
  class AccessibleObject 
    include_class_members AccessibleObjectImports
    include AnnotatedElement
    
    class_module.module_eval {
      # 
      # The Permission object that is used to check whether a client
      # has sufficient privilege to defeat Java language access
      # control checks.
      const_set_lazy(:ACCESS_PERMISSION) { ReflectPermission.new("suppressAccessChecks") }
      const_attr_reader  :ACCESS_PERMISSION
      
      typesig { [Array.typed(AccessibleObject), ::Java::Boolean] }
      # 
      # Convenience method to set the {@code accessible} flag for an
      # array of objects with a single security check (for efficiency).
      # 
      # <p>First, if there is a security manager, its
      # {@code checkPermission} method is called with a
      # {@code ReflectPermission("suppressAccessChecks")} permission.
      # 
      # <p>A {@code SecurityException} is raised if {@code flag} is
      # {@code true} but accessibility of any of the elements of the input
      # {@code array} may not be changed (for example, if the element
      # object is a {@link Constructor} object for the class {@link
      # java.lang.Class}).  In the event of such a SecurityException, the
      # accessibility of objects is set to {@code flag} for array elements
      # upto (and excluding) the element for which the exception occurred; the
      # accessibility of elements beyond (and including) the element for which
      # the exception occurred is unchanged.
      # 
      # @param array the array of AccessibleObjects
      # @param flag  the new value for the {@code accessible} flag
      # in each object
      # @throws SecurityException if the request is denied.
      # @see SecurityManager#checkPermission
      # @see java.lang.RuntimePermission
      def set_accessible(array, flag)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(ACCESS_PERMISSION)
        end
        i = 0
        while i < array.attr_length
          set_accessible0(array[i], flag)
          ((i += 1) - 1)
        end
      end
    }
    
    typesig { [::Java::Boolean] }
    # 
    # Set the {@code accessible} flag for this object to
    # the indicated boolean value.  A value of {@code true} indicates that
    # the reflected object should suppress Java language access
    # checking when it is used.  A value of {@code false} indicates
    # that the reflected object should enforce Java language access checks.
    # 
    # <p>First, if there is a security manager, its
    # {@code checkPermission} method is called with a
    # {@code ReflectPermission("suppressAccessChecks")} permission.
    # 
    # <p>A {@code SecurityException} is raised if {@code flag} is
    # {@code true} but accessibility of this object may not be changed
    # (for example, if this element object is a {@link Constructor} object for
    # the class {@link java.lang.Class}).
    # 
    # <p>A {@code SecurityException} is raised if this object is a {@link
    # java.lang.reflect.Constructor} object for the class
    # {@code java.lang.Class}, and {@code flag} is true.
    # 
    # @param flag the new value for the {@code accessible} flag
    # @throws SecurityException if the request is denied.
    # @see SecurityManager#checkPermission
    # @see java.lang.RuntimePermission
    def set_accessible(flag)
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(ACCESS_PERMISSION)
      end
      set_accessible0(self, flag)
    end
    
    class_module.module_eval {
      typesig { [AccessibleObject, ::Java::Boolean] }
      # Check that you aren't exposing java.lang.Class.<init>.
      def set_accessible0(obj, flag)
        if (obj.is_a?(Constructor) && (flag).equal?(true))
          c = obj
          if ((c.get_declaring_class).equal?(Class.class))
            raise SecurityException.new("Can not make a java.lang.Class" + " constructor accessible")
          end
        end
        obj.attr_override = flag
      end
    }
    
    typesig { [] }
    # 
    # Get the value of the {@code accessible} flag for this object.
    # 
    # @return the value of the object's {@code accessible} flag
    def is_accessible
      return @override
    end
    
    typesig { [] }
    # 
    # Constructor: only used by the Java Virtual Machine.
    def initialize
      @override = false
    end
    
    # Indicates whether language-level access checks are overridden
    # by this object. Initializes to "false". This field is used by
    # Field, Method, and Constructor.
    # 
    # NOTE: for security purposes, this field must not be visible
    # outside this package.
    attr_accessor :override
    alias_method :attr_override, :override
    undef_method :override
    alias_method :attr_override=, :override=
    undef_method :override=
    
    class_module.module_eval {
      # Reflection factory used by subclasses for creating field,
      # method, and constructor accessors. Note that this is called
      # very early in the bootstrapping process.
      const_set_lazy(:ReflectionFactory) { AccessController.do_privileged(Sun::Reflect::ReflectionFactory::GetReflectionFactoryAction.new) }
      const_attr_reader  :ReflectionFactory
    }
    
    typesig { [Class] }
    # 
    # @throws NullPointerException {@inheritDoc}
    # @since 1.5
    def get_annotation(annotation_class)
      raise AssertionError.new("All subclasses should override this method")
    end
    
    typesig { [Class] }
    # 
    # @throws NullPointerException {@inheritDoc}
    # @since 1.5
    def is_annotation_present(annotation_class)
      return !(get_annotation(annotation_class)).nil?
    end
    
    typesig { [] }
    # 
    # @since 1.5
    def get_annotations
      return get_declared_annotations
    end
    
    typesig { [] }
    # 
    # @since 1.5
    def get_declared_annotations
      raise AssertionError.new("All subclasses should override this method")
    end
    
    private
    alias_method :initialize__accessible_object, :initialize
  end
  
end
