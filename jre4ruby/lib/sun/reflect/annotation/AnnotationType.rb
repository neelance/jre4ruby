require "rjava"

# 
# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AnnotationTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Annotation
      include ::Java::Lang::Annotation
      include ::Java::Lang::Reflect
      include ::Java::Util
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # 
  # Represents an annotation type at run time.  Used to type-check annotations
  # and apply member defaults.
  # 
  # @author  Josh Bloch
  # @since   1.5
  class AnnotationType 
    include_class_members AnnotationTypeImports
    
    # 
    # Member name -> type mapping. Note that primitive types
    # are represented by the class objects for the corresponding wrapper
    # types.  This matches the return value that must be used for a
    # dynamic proxy, allowing for a simple isInstance test.
    attr_accessor :member_types
    alias_method :attr_member_types, :member_types
    undef_method :member_types
    alias_method :attr_member_types=, :member_types=
    undef_method :member_types=
    
    # 
    # Member name -> default value mapping.
    attr_accessor :member_defaults
    alias_method :attr_member_defaults, :member_defaults
    undef_method :member_defaults
    alias_method :attr_member_defaults=, :member_defaults=
    undef_method :member_defaults=
    
    # 
    # Member name -> Method object mapping. This (and its assoicated
    # accessor) are used only to generate AnnotationTypeMismatchExceptions.
    attr_accessor :members
    alias_method :attr_members, :members
    undef_method :members
    alias_method :attr_members=, :members=
    undef_method :members=
    
    # 
    # The retention policy for this annotation type.
    attr_accessor :retention
    alias_method :attr_retention, :retention
    undef_method :retention
    alias_method :attr_retention=, :retention=
    undef_method :retention=
    
    # 
    # Whether this annotation type is inherited.
    attr_accessor :inherited
    alias_method :attr_inherited, :inherited
    undef_method :inherited
    alias_method :attr_inherited=, :inherited=
    undef_method :inherited=
    
    class_module.module_eval {
      typesig { [Class] }
      # 
      # Returns an AnnotationType instance for the specified annotation type.
      # 
      # @throw IllegalArgumentException if the specified class object for
      # does not represent a valid annotation type
      def get_instance(annotation_class)
        synchronized(self) do
          result = Sun::Misc::SharedSecrets.get_java_lang_access.get_annotation_type(annotation_class)
          if ((result).nil?)
            result = AnnotationType.new(annotation_class)
          end
          return result
        end
      end
    }
    
    typesig { [Class] }
    # 
    # Sole constructor.
    # 
    # @param annotationClass the class object for the annotation type
    # @throw IllegalArgumentException if the specified class object for
    # does not represent a valid annotation type
    def initialize(annotation_class)
      @member_types = HashMap.new
      @member_defaults = HashMap.new
      @members = HashMap.new
      @retention = RetentionPolicy::RUNTIME
      @inherited = false
      if (!annotation_class.is_annotation)
        raise IllegalArgumentException.new("Not an annotation type")
      end
      methods = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members AnnotationType
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          # Initialize memberTypes and defaultValues
          return annotation_class.get_declared_methods
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      methods.each do |method|
        if (!(method.get_parameter_types.attr_length).equal?(0))
          raise IllegalArgumentException.new((method).to_s + " has params")
        end
        name = method.get_name
        type = method.get_return_type
        @member_types.put(name, invocation_handler_return_type(type))
        @members.put(name, method)
        default_value = method.get_default_value
        if (!(default_value).nil?)
          @member_defaults.put(name, default_value)
        end
        @members.put(name, method)
      end
      Sun::Misc::SharedSecrets.get_java_lang_access.set_annotation_type(annotation_class, self)
      # Initialize retention, & inherited fields.  Special treatment
      # of the corresponding annotation types breaks infinite recursion.
      if (!(annotation_class).equal?(Retention.class) && !(annotation_class).equal?(Inherited.class))
        ret = annotation_class.get_annotation(Retention.class)
        @retention = ((ret).nil? ? RetentionPolicy::CLASS : ret.value)
        @inherited = annotation_class.is_annotation_present(Inherited.class)
      end
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # 
      # Returns the type that must be returned by the invocation handler
      # of a dynamic proxy in order to have the dynamic proxy return
      # the specified type (which is assumed to be a legal member type
      # for an annotation).
      def invocation_handler_return_type(type)
        # Translate primitives to wrappers
        if ((type).equal?(Array))
          return Byte.class
        end
        if ((type).equal?(Array))
          return Character.class
        end
        if ((type).equal?(Array))
          return Double.class
        end
        if ((type).equal?(Array))
          return Float.class
        end
        if ((type).equal?(Array))
          return JavaInteger.class
        end
        if ((type).equal?(Array))
          return Long.class
        end
        if ((type).equal?(Array))
          return Short.class
        end
        if ((type).equal?(Array))
          return Boolean.class
        end
        # Otherwise, just return declared type
        return type
      end
    }
    
    typesig { [] }
    # 
    # Returns member types for this annotation type
    # (member name -> type mapping).
    def member_types
      return @member_types
    end
    
    typesig { [] }
    # 
    # Returns members of this annotation type
    # (member name -> associated Method object mapping).
    def members
      return @members
    end
    
    typesig { [] }
    # 
    # Returns the default values for this annotation type
    # (Member name -> default value mapping).
    def member_defaults
      return @member_defaults
    end
    
    typesig { [] }
    # 
    # Returns the retention policy for this annotation type.
    def retention
      return @retention
    end
    
    typesig { [] }
    # 
    # Returns true if this this annotation type is inherited.
    def is_inherited
      return @inherited
    end
    
    typesig { [] }
    # 
    # For debugging.
    def to_s
      s = StringBuffer.new("Annotation Type:" + "\n")
      s.append("   Member types: " + (@member_types).to_s + "\n")
      s.append("   Member defaults: " + (@member_defaults).to_s + "\n")
      s.append("   Retention policy: " + (@retention).to_s + "\n")
      s.append("   Inherited: " + (@inherited).to_s)
      return s.to_s
    end
    
    private
    alias_method :initialize__annotation_type, :initialize
  end
  
end
