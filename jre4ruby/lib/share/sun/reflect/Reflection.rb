require "rjava"

# Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ReflectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include ::Java::Lang::Reflect
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
    }
  end
  
  # Common utility routines used by both java.lang and
  # java.lang.reflect
  class Reflection 
    include_class_members ReflectionImports
    
    class_module.module_eval {
      # Used to filter out fields and methods from certain classes from public
      # view, where they are sensitive or they may contain VM-internal objects.
      # These Maps are updated very rarely. Rather than synchronize on
      # each access, we use copy-on-write
      
      def field_filter_map
        defined?(@@field_filter_map) ? @@field_filter_map : @@field_filter_map= nil
      end
      alias_method :attr_field_filter_map, :field_filter_map
      
      def field_filter_map=(value)
        @@field_filter_map = value
      end
      alias_method :attr_field_filter_map=, :field_filter_map=
      
      
      def method_filter_map
        defined?(@@method_filter_map) ? @@method_filter_map : @@method_filter_map= nil
      end
      alias_method :attr_method_filter_map, :method_filter_map
      
      def method_filter_map=(value)
        @@method_filter_map = value
      end
      alias_method :attr_method_filter_map=, :method_filter_map=
      
      when_class_loaded do
        map = HashMap.new
        map.put(Reflection, Array.typed(String).new(["fieldFilterMap", "methodFilterMap"]))
        map.put(System, Array.typed(String).new(["security"]))
        self.attr_field_filter_map = map
        self.attr_method_filter_map = HashMap.new
      end
      
      JNI.native_method :Java_sun_reflect_Reflection_getCallerClass, [:pointer, :long, :int32], :long
      typesig { [::Java::Int] }
      # Returns the class of the method <code>realFramesToSkip</code>
      # frames up the stack (zero-based), ignoring frames associated
      # with java.lang.reflect.Method.invoke() and its implementation.
      # The first frame is that associated with this method, so
      # <code>getCallerClass(0)</code> returns the Class object for
      # sun.reflect.Reflection. Frames associated with
      # java.lang.reflect.Method.invoke() and its implementation are
      # completely ignored and do not count toward the number of "real"
      # frames skipped.
      def get_caller_class(real_frames_to_skip)
        JNI.__send__(:Java_sun_reflect_Reflection_getCallerClass, JNI.env, self.jni_id, real_frames_to_skip.to_int)
      end
      
      JNI.native_method :Java_sun_reflect_Reflection_getClassAccessFlags, [:pointer, :long, :long], :int32
      typesig { [Class] }
      # Retrieves the access flags written to the class file. For
      # inner classes these flags may differ from those returned by
      # Class.getModifiers(), which searches the InnerClasses
      # attribute to find the source-level access flags. This is used
      # instead of Class.getModifiers() for run-time access checks due
      # to compatibility reasons; see 4471811. Only the values of the
      # low 13 bits (i.e., a mask of 0x1FFF) are guaranteed to be
      # valid.
      def get_class_access_flags(c)
        JNI.__send__(:Java_sun_reflect_Reflection_getClassAccessFlags, JNI.env, self.jni_id, c.jni_id)
      end
      
      typesig { [Class, ::Java::Int] }
      # A quick "fast-path" check to try to avoid getCallerClass()
      # calls.
      def quick_check_member_access(member_class, modifiers)
        return Modifier.is_public(get_class_access_flags(member_class) & modifiers)
      end
      
      typesig { [Class, Class, Object, ::Java::Int] }
      def ensure_member_access(current_class, member_class, target, modifiers)
        if ((current_class).nil? || (member_class).nil?)
          raise InternalError.new
        end
        if (!verify_member_access(current_class, member_class, target, modifiers))
          raise IllegalAccessException.new("Class " + RJava.cast_to_string(current_class.get_name) + " can not access a member of class " + RJava.cast_to_string(member_class.get_name) + " with modifiers \"" + RJava.cast_to_string(Modifier.to_s(modifiers)) + "\"")
        end
      end
      
      typesig { [Class, Class, Object, ::Java::Int] }
      # Declaring class of field
      # or method
      # May be NULL in case of statics
      def verify_member_access(current_class, member_class, target, modifiers)
        # Verify that currentClass can access a field, method, or
        # constructor of memberClass, where that member's access bits are
        # "modifiers".
        got_is_same_class_package = false
        is_same_class_package = false
        if ((current_class).equal?(member_class))
          # Always succeeds
          return true
        end
        if (!Modifier.is_public(get_class_access_flags(member_class)))
          is_same_class_package = is_same_class_package(current_class, member_class)
          got_is_same_class_package = true
          if (!is_same_class_package)
            return false
          end
        end
        # At this point we know that currentClass can access memberClass.
        if (Modifier.is_public(modifiers))
          return true
        end
        success_so_far = false
        if (Modifier.is_protected(modifiers))
          # See if currentClass is a subclass of memberClass
          if (is_subclass_of(current_class, member_class))
            success_so_far = true
          end
        end
        if (!success_so_far && !Modifier.is_private(modifiers))
          if (!got_is_same_class_package)
            is_same_class_package = is_same_class_package(current_class, member_class)
            got_is_same_class_package = true
          end
          if (is_same_class_package)
            success_so_far = true
          end
        end
        if (!success_so_far)
          return false
        end
        if (Modifier.is_protected(modifiers))
          # Additional test for protected members: JLS 6.6.2
          target_class = ((target).nil? ? member_class : target.get_class)
          if (!(target_class).equal?(current_class))
            if (!got_is_same_class_package)
              is_same_class_package = is_same_class_package(current_class, member_class)
              got_is_same_class_package = true
            end
            if (!is_same_class_package)
              if (!is_subclass_of(target_class, current_class))
                return false
              end
            end
          end
        end
        return true
      end
      
      typesig { [Class, Class] }
      def is_same_class_package(c1, c2)
        return is_same_class_package(c1.get_class_loader, c1.get_name, c2.get_class_loader, c2.get_name)
      end
      
      typesig { [ClassLoader, String, ClassLoader, String] }
      # Returns true if two classes are in the same package; classloader
      # and classname information is enough to determine a class's package
      def is_same_class_package(loader1, name1, loader2, name2)
        if (!(loader1).equal?(loader2))
          return false
        else
          last_dot1 = name1.last_index_of(Character.new(?..ord))
          last_dot2 = name2.last_index_of(Character.new(?..ord))
          if (((last_dot1).equal?(-1)) || ((last_dot2).equal?(-1)))
            # One of the two doesn't have a package.  Only return true
            # if the other one also doesn't have a package.
            return ((last_dot1).equal?(last_dot2))
          else
            idx1 = 0
            idx2 = 0
            # Skip over '['s
            if ((name1.char_at(idx1)).equal?(Character.new(?[.ord)))
              begin
                idx1 += 1
              end while ((name1.char_at(idx1)).equal?(Character.new(?[.ord)))
              if (!(name1.char_at(idx1)).equal?(Character.new(?L.ord)))
                # Something is terribly wrong.  Shouldn't be here.
                raise InternalError.new("Illegal class name " + name1)
              end
            end
            if ((name2.char_at(idx2)).equal?(Character.new(?[.ord)))
              begin
                idx2 += 1
              end while ((name2.char_at(idx2)).equal?(Character.new(?[.ord)))
              if (!(name2.char_at(idx2)).equal?(Character.new(?L.ord)))
                # Something is terribly wrong.  Shouldn't be here.
                raise InternalError.new("Illegal class name " + name2)
              end
            end
            # Check that package part is identical
            length1 = last_dot1 - idx1
            length2 = last_dot2 - idx2
            if (!(length1).equal?(length2))
              return false
            end
            return name1.region_matches(false, idx1, name2, idx2, length1)
          end
        end
      end
      
      typesig { [Class, Class] }
      def is_subclass_of(query_class, of_class)
        while (!(query_class).nil?)
          if ((query_class).equal?(of_class))
            return true
          end
          query_class = query_class.get_superclass
        end
        return false
      end
      
      typesig { [Class, String] }
      # fieldNames must contain only interned Strings
      def register_fields_to_filter(containing_class, *field_names)
        synchronized(self) do
          self.attr_field_filter_map = register_filter(self.attr_field_filter_map, containing_class, field_names)
        end
      end
      
      typesig { [Class, String] }
      # methodNames must contain only interned Strings
      def register_methods_to_filter(containing_class, *method_names)
        synchronized(self) do
          self.attr_method_filter_map = register_filter(self.attr_method_filter_map, containing_class, method_names)
        end
      end
      
      typesig { [Map, Class, String] }
      def register_filter(map, containing_class, *names)
        if (!(map.get(containing_class)).nil?)
          raise IllegalArgumentException.new("Filter already registered: " + RJava.cast_to_string(containing_class))
        end
        map = HashMap.new(map)
        map.put(containing_class, names)
        return map
      end
      
      typesig { [Class, Array.typed(Field)] }
      def filter_fields(containing_class, fields)
        if ((self.attr_field_filter_map).nil?)
          # Bootstrapping
          return fields
        end
        return filter(fields, self.attr_field_filter_map.get(containing_class))
      end
      
      typesig { [Class, Array.typed(Method)] }
      def filter_methods(containing_class, methods)
        if ((self.attr_method_filter_map).nil?)
          # Bootstrapping
          return methods
        end
        return filter(methods, self.attr_method_filter_map.get(containing_class))
      end
      
      typesig { [Array.typed(Member), Array.typed(String)] }
      def filter(members, filtered_names)
        if (((filtered_names).nil?) || ((members.attr_length).equal?(0)))
          return members
        end
        num_new_members = 0
        members.each do |member|
          should_skip = false
          filtered_names.each do |filteredName|
            if ((member.get_name).equal?(filtered_name))
              should_skip = true
              break
            end
          end
          if (!should_skip)
            (num_new_members += 1)
          end
        end
        new_members = Array.new_instance(members[0].get_class, num_new_members)
        dest_idx = 0
        members.each do |member|
          should_skip = false
          filtered_names.each do |filteredName|
            if ((member.get_name).equal?(filtered_name))
              should_skip = true
              break
            end
          end
          if (!should_skip)
            new_members[((dest_idx += 1) - 1)] = member
          end
        end
        return new_members
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__reflection, :initialize
  end
  
end
