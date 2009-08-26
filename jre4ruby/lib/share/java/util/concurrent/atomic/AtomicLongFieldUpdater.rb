require "rjava"

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
# 
# 
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent::Atomic
  module AtomicLongFieldUpdaterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
      include ::Java::Lang::Reflect
    }
  end
  
  # A reflection-based utility that enables atomic updates to
  # designated {@code volatile long} fields of designated classes.
  # This class is designed for use in atomic data structures in which
  # several fields of the same node are independently subject to atomic
  # updates.
  # 
  # <p>Note that the guarantees of the {@code compareAndSet}
  # method in this class are weaker than in other atomic classes.
  # Because this class cannot ensure that all uses of the field
  # are appropriate for purposes of atomic access, it can
  # guarantee atomicity only with respect to other invocations of
  # {@code compareAndSet} and {@code set} on the same updater.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <T> The type of the object holding the updatable field
  class AtomicLongFieldUpdater 
    include_class_members AtomicLongFieldUpdaterImports
    
    class_module.module_eval {
      typesig { [Class, String] }
      # Creates and returns an updater for objects with the given field.
      # The Class argument is needed to check that reflective types and
      # generic types match.
      # 
      # @param tclass the class of the objects holding the field
      # @param fieldName the name of the field to be updated.
      # @return the updater
      # @throws IllegalArgumentException if the field is not a
      # volatile long type.
      # @throws RuntimeException with a nested reflection-based
      # exception if the class does not hold field or is the wrong type.
      def new_updater(tclass, field_name)
        if (AtomicLong::VM_SUPPORTS_LONG_CAS)
          return CASUpdater.new(tclass, field_name)
        else
          return LockedUpdater.new(tclass, field_name)
        end
      end
    }
    
    typesig { [] }
    # Protected do-nothing constructor for use by subclasses.
    def initialize
    end
    
    typesig { [Object, ::Java::Long, ::Java::Long] }
    # Atomically sets the field of the given object managed by this updater
    # to the given updated value if the current value {@code ==} the
    # expected value. This method is guaranteed to be atomic with respect to
    # other calls to {@code compareAndSet} and {@code set}, but not
    # necessarily with respect to other changes in the field.
    # 
    # @param obj An object whose field to conditionally set
    # @param expect the expected value
    # @param update the new value
    # @return true if successful.
    # @throws ClassCastException if {@code obj} is not an instance
    # of the class possessing the field established in the constructor.
    def compare_and_set(obj, expect, update)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Long, ::Java::Long] }
    # Atomically sets the field of the given object managed by this updater
    # to the given updated value if the current value {@code ==} the
    # expected value. This method is guaranteed to be atomic with respect to
    # other calls to {@code compareAndSet} and {@code set}, but not
    # necessarily with respect to other changes in the field.
    # 
    # <p>May <a href="package-summary.html#Spurious">fail spuriously</a>
    # and does not provide ordering guarantees, so is only rarely an
    # appropriate alternative to {@code compareAndSet}.
    # 
    # @param obj An object whose field to conditionally set
    # @param expect the expected value
    # @param update the new value
    # @return true if successful.
    # @throws ClassCastException if {@code obj} is not an instance
    # of the class possessing the field established in the constructor.
    def weak_compare_and_set(obj, expect, update)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Long] }
    # Sets the field of the given object managed by this updater to the
    # given updated value. This operation is guaranteed to act as a volatile
    # store with respect to subsequent invocations of {@code compareAndSet}.
    # 
    # @param obj An object whose field to set
    # @param newValue the new value
    def set(obj, new_value)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Long] }
    # Eventually sets the field of the given object managed by this
    # updater to the given updated value.
    # 
    # @param obj An object whose field to set
    # @param newValue the new value
    # @since 1.6
    def lazy_set(obj, new_value)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Gets the current value held in the field of the given object managed
    # by this updater.
    # 
    # @param obj An object whose field to get
    # @return the current value
    def get(obj)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Long] }
    # Atomically sets the field of the given object managed by this updater
    # to the given value and returns the old value.
    # 
    # @param obj An object whose field to get and set
    # @param newValue the new value
    # @return the previous value
    def get_and_set(obj, new_value)
      loop do
        current = get(obj)
        if (compare_and_set(obj, current, new_value))
          return current
        end
      end
    end
    
    typesig { [Object] }
    # Atomically increments by one the current value of the field of the
    # given object managed by this updater.
    # 
    # @param obj An object whose field to get and set
    # @return the previous value
    def get_and_increment(obj)
      loop do
        current = get(obj)
        next_ = current + 1
        if (compare_and_set(obj, current, next_))
          return current
        end
      end
    end
    
    typesig { [Object] }
    # Atomically decrements by one the current value of the field of the
    # given object managed by this updater.
    # 
    # @param obj An object whose field to get and set
    # @return the previous value
    def get_and_decrement(obj)
      loop do
        current = get(obj)
        next_ = current - 1
        if (compare_and_set(obj, current, next_))
          return current
        end
      end
    end
    
    typesig { [Object, ::Java::Long] }
    # Atomically adds the given value to the current value of the field of
    # the given object managed by this updater.
    # 
    # @param obj An object whose field to get and set
    # @param delta the value to add
    # @return the previous value
    def get_and_add(obj, delta)
      loop do
        current = get(obj)
        next_ = current + delta
        if (compare_and_set(obj, current, next_))
          return current
        end
      end
    end
    
    typesig { [Object] }
    # Atomically increments by one the current value of the field of the
    # given object managed by this updater.
    # 
    # @param obj An object whose field to get and set
    # @return the updated value
    def increment_and_get(obj)
      loop do
        current = get(obj)
        next_ = current + 1
        if (compare_and_set(obj, current, next_))
          return next_
        end
      end
    end
    
    typesig { [Object] }
    # Atomically decrements by one the current value of the field of the
    # given object managed by this updater.
    # 
    # @param obj An object whose field to get and set
    # @return the updated value
    def decrement_and_get(obj)
      loop do
        current = get(obj)
        next_ = current - 1
        if (compare_and_set(obj, current, next_))
          return next_
        end
      end
    end
    
    typesig { [Object, ::Java::Long] }
    # Atomically adds the given value to the current value of the field of
    # the given object managed by this updater.
    # 
    # @param obj An object whose field to get and set
    # @param delta the value to add
    # @return the updated value
    def add_and_get(obj, delta)
      loop do
        current = get(obj)
        next_ = current + delta
        if (compare_and_set(obj, current, next_))
          return next_
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:CASUpdater) { Class.new(AtomicLongFieldUpdater) do
        include_class_members AtomicLongFieldUpdater
        
        class_module.module_eval {
          const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
          const_attr_reader  :UnsafeInstance
        }
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :tclass
        alias_method :attr_tclass, :tclass
        undef_method :tclass
        alias_method :attr_tclass=, :tclass=
        undef_method :tclass=
        
        attr_accessor :cclass
        alias_method :attr_cclass, :cclass
        undef_method :cclass
        alias_method :attr_cclass=, :cclass=
        undef_method :cclass=
        
        typesig { [self::Class, self::String] }
        def initialize(tclass, field_name)
          @offset = 0
          @tclass = nil
          @cclass = nil
          super()
          field = nil
          caller = nil
          modifiers = 0
          begin
            field = tclass.get_declared_field(field_name)
            caller = Sun::Reflect::Reflection.get_caller_class(3)
            modifiers = field.get_modifiers
            Sun::Reflect::Misc::ReflectUtil.ensure_member_access(caller, tclass, nil, modifiers)
            Sun::Reflect::Misc::ReflectUtil.check_package_access(tclass)
          rescue self.class::JavaException => ex
            raise self.class::RuntimeException.new(ex)
          end
          fieldt = field.get_type
          if (!(fieldt).equal?(Array))
            raise self.class::IllegalArgumentException.new("Must be long type")
          end
          if (!Modifier.is_volatile(modifiers))
            raise self.class::IllegalArgumentException.new("Must be volatile type")
          end
          @cclass = (Modifier.is_protected(modifiers) && !(caller).equal?(tclass)) ? caller : nil
          @tclass = tclass
          @offset = self.class::UnsafeInstance.object_field_offset(field)
        end
        
        typesig { [Object] }
        def full_check(obj)
          if (!@tclass.is_instance(obj))
            raise self.class::ClassCastException.new
          end
          if (!(@cclass).nil?)
            ensure_protected_access(obj)
          end
        end
        
        typesig { [Object, ::Java::Long, ::Java::Long] }
        def compare_and_set(obj, expect, update)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          return self.class::UnsafeInstance.compare_and_swap_long(obj, @offset, expect, update)
        end
        
        typesig { [Object, ::Java::Long, ::Java::Long] }
        def weak_compare_and_set(obj, expect, update)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          return self.class::UnsafeInstance.compare_and_swap_long(obj, @offset, expect, update)
        end
        
        typesig { [Object, ::Java::Long] }
        def set(obj, new_value)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          self.class::UnsafeInstance.put_long_volatile(obj, @offset, new_value)
        end
        
        typesig { [Object, ::Java::Long] }
        def lazy_set(obj, new_value)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          self.class::UnsafeInstance.put_ordered_long(obj, @offset, new_value)
        end
        
        typesig { [Object] }
        def get(obj)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          return self.class::UnsafeInstance.get_long_volatile(obj, @offset)
        end
        
        typesig { [Object] }
        def ensure_protected_access(obj)
          if (@cclass.is_instance(obj))
            return
          end
          raise self.class::RuntimeException.new(self.class::IllegalAccessException.new("Class " + RJava.cast_to_string(@cclass.get_name) + " can not access a protected member of class " + RJava.cast_to_string(@tclass.get_name) + " using an instance of " + RJava.cast_to_string(obj.get_class.get_name)))
        end
        
        private
        alias_method :initialize__casupdater, :initialize
      end }
      
      const_set_lazy(:LockedUpdater) { Class.new(AtomicLongFieldUpdater) do
        include_class_members AtomicLongFieldUpdater
        
        class_module.module_eval {
          const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
          const_attr_reader  :UnsafeInstance
        }
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :tclass
        alias_method :attr_tclass, :tclass
        undef_method :tclass
        alias_method :attr_tclass=, :tclass=
        undef_method :tclass=
        
        attr_accessor :cclass
        alias_method :attr_cclass, :cclass
        undef_method :cclass
        alias_method :attr_cclass=, :cclass=
        undef_method :cclass=
        
        typesig { [self::Class, self::String] }
        def initialize(tclass, field_name)
          @offset = 0
          @tclass = nil
          @cclass = nil
          super()
          field = nil
          caller = nil
          modifiers = 0
          begin
            field = tclass.get_declared_field(field_name)
            caller = Sun::Reflect::Reflection.get_caller_class(3)
            modifiers = field.get_modifiers
            Sun::Reflect::Misc::ReflectUtil.ensure_member_access(caller, tclass, nil, modifiers)
            Sun::Reflect::Misc::ReflectUtil.check_package_access(tclass)
          rescue self.class::JavaException => ex
            raise self.class::RuntimeException.new(ex)
          end
          fieldt = field.get_type
          if (!(fieldt).equal?(Array))
            raise self.class::IllegalArgumentException.new("Must be long type")
          end
          if (!Modifier.is_volatile(modifiers))
            raise self.class::IllegalArgumentException.new("Must be volatile type")
          end
          @cclass = (Modifier.is_protected(modifiers) && !(caller).equal?(tclass)) ? caller : nil
          @tclass = tclass
          @offset = self.class::UnsafeInstance.object_field_offset(field)
        end
        
        typesig { [Object] }
        def full_check(obj)
          if (!@tclass.is_instance(obj))
            raise self.class::ClassCastException.new
          end
          if (!(@cclass).nil?)
            ensure_protected_access(obj)
          end
        end
        
        typesig { [Object, ::Java::Long, ::Java::Long] }
        def compare_and_set(obj, expect, update)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          synchronized((self)) do
            v = self.class::UnsafeInstance.get_long(obj, @offset)
            if (!(v).equal?(expect))
              return false
            end
            self.class::UnsafeInstance.put_long(obj, @offset, update)
            return true
          end
        end
        
        typesig { [Object, ::Java::Long, ::Java::Long] }
        def weak_compare_and_set(obj, expect, update)
          return compare_and_set(obj, expect, update)
        end
        
        typesig { [Object, ::Java::Long] }
        def set(obj, new_value)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          synchronized((self)) do
            self.class::UnsafeInstance.put_long(obj, @offset, new_value)
          end
        end
        
        typesig { [Object, ::Java::Long] }
        def lazy_set(obj, new_value)
          set(obj, new_value)
        end
        
        typesig { [Object] }
        def get(obj)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            full_check(obj)
          end
          synchronized((self)) do
            return self.class::UnsafeInstance.get_long(obj, @offset)
          end
        end
        
        typesig { [Object] }
        def ensure_protected_access(obj)
          if (@cclass.is_instance(obj))
            return
          end
          raise self.class::RuntimeException.new(self.class::IllegalAccessException.new("Class " + RJava.cast_to_string(@cclass.get_name) + " can not access a protected member of class " + RJava.cast_to_string(@tclass.get_name) + " using an instance of " + RJava.cast_to_string(obj.get_class.get_name)))
        end
        
        private
        alias_method :initialize__locked_updater, :initialize
      end }
    }
    
    private
    alias_method :initialize__atomic_long_field_updater, :initialize
  end
  
end
