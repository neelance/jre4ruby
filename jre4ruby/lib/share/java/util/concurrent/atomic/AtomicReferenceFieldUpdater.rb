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
  module AtomicReferenceFieldUpdaterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
      include ::Java::Lang::Reflect
    }
  end
  
  # A reflection-based utility that enables atomic updates to
  # designated {@code volatile} reference fields of designated
  # classes.  This class is designed for use in atomic data structures
  # in which several reference fields of the same node are
  # independently subject to atomic updates. For example, a tree node
  # might be declared as
  # 
  # <pre>
  # class Node {
  # private volatile Node left, right;
  # 
  # private static final AtomicReferenceFieldUpdater&lt;Node, Node&gt; leftUpdater =
  # AtomicReferenceFieldUpdater.newUpdater(Node.class, Node.class, "left");
  # private static AtomicReferenceFieldUpdater&lt;Node, Node&gt; rightUpdater =
  # AtomicReferenceFieldUpdater.newUpdater(Node.class, Node.class, "right");
  # 
  # Node getLeft() { return left;  }
  # boolean compareAndSetLeft(Node expect, Node update) {
  # return leftUpdater.compareAndSet(this, expect, update);
  # }
  # // ... and so on
  # }
  # </pre>
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
  # @param <V> The type of the field
  class AtomicReferenceFieldUpdater 
    include_class_members AtomicReferenceFieldUpdaterImports
    
    class_module.module_eval {
      typesig { [Class, Class, String] }
      # Creates and returns an updater for objects with the given field.
      # The Class arguments are needed to check that reflective types and
      # generic types match.
      # 
      # @param tclass the class of the objects holding the field.
      # @param vclass the class of the field
      # @param fieldName the name of the field to be updated.
      # @return the updater
      # @throws IllegalArgumentException if the field is not a volatile reference type.
      # @throws RuntimeException with a nested reflection-based
      # exception if the class does not hold field or is the wrong type.
      def new_updater(tclass, vclass, field_name)
        return AtomicReferenceFieldUpdaterImpl.new(tclass, vclass, field_name)
      end
    }
    
    typesig { [] }
    # Protected do-nothing constructor for use by subclasses.
    def initialize
    end
    
    typesig { [Object, Object, Object] }
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
    def compare_and_set(obj, expect, update)
      raise NotImplementedError
    end
    
    typesig { [Object, Object, Object] }
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
    def weak_compare_and_set(obj, expect, update)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Sets the field of the given object managed by this updater to the
    # given updated value. This operation is guaranteed to act as a volatile
    # store with respect to subsequent invocations of {@code compareAndSet}.
    # 
    # @param obj An object whose field to set
    # @param newValue the new value
    def set(obj, new_value)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
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
    
    typesig { [Object, Object] }
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
    
    class_module.module_eval {
      const_set_lazy(:AtomicReferenceFieldUpdaterImpl) { Class.new(AtomicReferenceFieldUpdater) do
        include_class_members AtomicReferenceFieldUpdater
        
        class_module.module_eval {
          const_set_lazy(:Unsafe) { Unsafe.get_unsafe }
          const_attr_reader  :Unsafe
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
        
        attr_accessor :vclass
        alias_method :attr_vclass, :vclass
        undef_method :vclass
        alias_method :attr_vclass=, :vclass=
        undef_method :vclass=
        
        attr_accessor :cclass
        alias_method :attr_cclass, :cclass
        undef_method :cclass
        alias_method :attr_cclass=, :cclass=
        undef_method :cclass=
        
        typesig { [self::Class, self::Class, String] }
        # Internal type checks within all update methods contain
        # internal inlined optimizations checking for the common
        # cases where the class is final (in which case a simple
        # getClass comparison suffices) or is of type Object (in
        # which case no check is needed because all objects are
        # instances of Object). The Object case is handled simply by
        # setting vclass to null in constructor.  The targetCheck and
        # updateCheck methods are invoked when these faster
        # screenings fail.
        def initialize(tclass, vclass, field_name)
          @offset = 0
          @tclass = nil
          @vclass = nil
          @cclass = nil
          super()
          field = nil
          field_class = nil
          caller = nil
          modifiers = 0
          begin
            field = tclass.get_declared_field(field_name)
            caller = Sun::Reflect::Reflection.get_caller_class(3)
            modifiers = field.get_modifiers
            Sun::Reflect::Misc::ReflectUtil.ensure_member_access(caller, tclass, nil, modifiers)
            Sun::Reflect::Misc::ReflectUtil.check_package_access(tclass)
            field_class = field.get_type
          rescue self.class::JavaException => ex
            raise self.class::RuntimeException.new(ex)
          end
          if (!(vclass).equal?(field_class))
            raise self.class::ClassCastException.new
          end
          if (!Modifier.is_volatile(modifiers))
            raise self.class::IllegalArgumentException.new("Must be volatile type")
          end
          @cclass = (Modifier.is_protected(modifiers) && !(caller).equal?(tclass)) ? caller : nil
          @tclass = tclass
          if ((vclass).equal?(Object))
            @vclass = nil
          else
            @vclass = vclass
          end
          @offset = self.class::Unsafe.object_field_offset(field)
        end
        
        typesig { [Object] }
        def target_check(obj)
          if (!@tclass.is_instance(obj))
            raise self.class::ClassCastException.new
          end
          if (!(@cclass).nil?)
            ensure_protected_access(obj)
          end
        end
        
        typesig { [Object, Object] }
        def update_check(obj, update)
          if (!@tclass.is_instance(obj) || (!(update).nil? && !(@vclass).nil? && !@vclass.is_instance(update)))
            raise self.class::ClassCastException.new
          end
          if (!(@cclass).nil?)
            ensure_protected_access(obj)
          end
        end
        
        typesig { [Object, Object, Object] }
        def compare_and_set(obj, expect, update)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil? || (!(update).nil? && !(@vclass).nil? && !(@vclass).equal?(update.get_class)))
            update_check(obj, update)
          end
          return self.class::Unsafe.compare_and_swap_object(obj, @offset, expect, update)
        end
        
        typesig { [Object, Object, Object] }
        def weak_compare_and_set(obj, expect, update)
          # same implementation as strong form for now
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil? || (!(update).nil? && !(@vclass).nil? && !(@vclass).equal?(update.get_class)))
            update_check(obj, update)
          end
          return self.class::Unsafe.compare_and_swap_object(obj, @offset, expect, update)
        end
        
        typesig { [Object, Object] }
        def set(obj, new_value)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil? || (!(new_value).nil? && !(@vclass).nil? && !(@vclass).equal?(new_value.get_class)))
            update_check(obj, new_value)
          end
          self.class::Unsafe.put_object_volatile(obj, @offset, new_value)
        end
        
        typesig { [Object, Object] }
        def lazy_set(obj, new_value)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil? || (!(new_value).nil? && !(@vclass).nil? && !(@vclass).equal?(new_value.get_class)))
            update_check(obj, new_value)
          end
          self.class::Unsafe.put_ordered_object(obj, @offset, new_value)
        end
        
        typesig { [Object] }
        def get(obj)
          if ((obj).nil? || !(obj.get_class).equal?(@tclass) || !(@cclass).nil?)
            target_check(obj)
          end
          return self.class::Unsafe.get_object_volatile(obj, @offset)
        end
        
        typesig { [Object] }
        def ensure_protected_access(obj)
          if (@cclass.is_instance(obj))
            return
          end
          raise self.class::RuntimeException.new(self.class::IllegalAccessException.new("Class " + RJava.cast_to_string(@cclass.get_name) + " can not access a protected member of class " + RJava.cast_to_string(@tclass.get_name) + " using an instance of " + RJava.cast_to_string(obj.get_class.get_name)))
        end
        
        private
        alias_method :initialize__atomic_reference_field_updater_impl, :initialize
      end }
    }
    
    private
    alias_method :initialize__atomic_reference_field_updater, :initialize
  end
  
end
