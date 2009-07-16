require "rjava"

# 
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
  module AtomicLongImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # 
  # A {@code long} value that may be updated atomically.  See the
  # {@link java.util.concurrent.atomic} package specification for
  # description of the properties of atomic variables. An
  # {@code AtomicLong} is used in applications such as atomically
  # incremented sequence numbers, and cannot be used as a replacement
  # for a {@link java.lang.Long}. However, this class does extend
  # {@code Number} to allow uniform access by tools and utilities that
  # deal with numerically-based classes.
  # 
  # @since 1.5
  # @author Doug Lea
  class AtomicLong < AtomicLongImports.const_get :Numeric
    include_class_members AtomicLongImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 1927816293512124184 }
      const_attr_reader  :SerialVersionUID
      
      # setup to use Unsafe.compareAndSwapLong for updates
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      # 
      # Records whether the underlying JVM supports lockless
      # compareAndSwap for longs. While the Unsafe.compareAndSwapLong
      # method works in either case, some constructions should be
      # handled at Java level to avoid locking user-visible locks.
      const_set_lazy(:VM_SUPPORTS_LONG_CAS) { _vmsupports_cs8 }
      const_attr_reader  :VM_SUPPORTS_LONG_CAS
      
      JNI.native_method :Java_java_util_concurrent_atomic_AtomicLong_VMSupportsCS8, [:pointer, :long], :int8
      typesig { [] }
      # 
      # Returns whether underlying JVM supports lockless CompareAndSet
      # for longs. Called only once and cached in VM_SUPPORTS_LONG_CAS.
      def _vmsupports_cs8
        JNI.__send__(:Java_java_util_concurrent_atomic_AtomicLong_VMSupportsCS8, JNI.env, self.jni_id) != 0
      end
      
      when_class_loaded do
        begin
          const_set :ValueOffset, UnsafeInstance.object_field_offset(AtomicLong.class.get_declared_field("value"))
        rescue Exception => ex
          raise JavaError.new(ex)
        end
      end
    }
    
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [::Java::Long] }
    # 
    # Creates a new AtomicLong with the given initial value.
    # 
    # @param initialValue the initial value
    def initialize(initial_value)
      @value = 0
      super()
      @value = initial_value
    end
    
    typesig { [] }
    # 
    # Creates a new AtomicLong with initial value {@code 0}.
    def initialize
      @value = 0
      super()
    end
    
    typesig { [] }
    # 
    # Gets the current value.
    # 
    # @return the current value
    def get
      return @value
    end
    
    typesig { [::Java::Long] }
    # 
    # Sets to the given value.
    # 
    # @param newValue the new value
    def set(new_value)
      @value = new_value
    end
    
    typesig { [::Java::Long] }
    # 
    # Eventually sets to the given value.
    # 
    # @param newValue the new value
    # @since 1.6
    def lazy_set(new_value)
      UnsafeInstance.put_ordered_long(self, ValueOffset, new_value)
    end
    
    typesig { [::Java::Long] }
    # 
    # Atomically sets to the given value and returns the old value.
    # 
    # @param newValue the new value
    # @return the previous value
    def get_and_set(new_value)
      while (true)
        current = get
        if (compare_and_set(current, new_value))
          return current
        end
      end
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # 
    # Atomically sets the value to the given updated value
    # if the current value {@code ==} the expected value.
    # 
    # @param expect the expected value
    # @param update the new value
    # @return true if successful. False return indicates that
    # the actual value was not equal to the expected value.
    def compare_and_set(expect, update)
      return UnsafeInstance.compare_and_swap_long(self, ValueOffset, expect, update)
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # 
    # Atomically sets the value to the given updated value
    # if the current value {@code ==} the expected value.
    # 
    # <p>May <a href="package-summary.html#Spurious">fail spuriously</a>
    # and does not provide ordering guarantees, so is only rarely an
    # appropriate alternative to {@code compareAndSet}.
    # 
    # @param expect the expected value
    # @param update the new value
    # @return true if successful.
    def weak_compare_and_set(expect, update)
      return UnsafeInstance.compare_and_swap_long(self, ValueOffset, expect, update)
    end
    
    typesig { [] }
    # 
    # Atomically increments by one the current value.
    # 
    # @return the previous value
    def get_and_increment
      while (true)
        current = get
        next_ = current + 1
        if (compare_and_set(current, next_))
          return current
        end
      end
    end
    
    typesig { [] }
    # 
    # Atomically decrements by one the current value.
    # 
    # @return the previous value
    def get_and_decrement
      while (true)
        current = get
        next_ = current - 1
        if (compare_and_set(current, next_))
          return current
        end
      end
    end
    
    typesig { [::Java::Long] }
    # 
    # Atomically adds the given value to the current value.
    # 
    # @param delta the value to add
    # @return the previous value
    def get_and_add(delta)
      while (true)
        current = get
        next_ = current + delta
        if (compare_and_set(current, next_))
          return current
        end
      end
    end
    
    typesig { [] }
    # 
    # Atomically increments by one the current value.
    # 
    # @return the updated value
    def increment_and_get
      loop do
        current = get
        next_ = current + 1
        if (compare_and_set(current, next_))
          return next_
        end
      end
    end
    
    typesig { [] }
    # 
    # Atomically decrements by one the current value.
    # 
    # @return the updated value
    def decrement_and_get
      loop do
        current = get
        next_ = current - 1
        if (compare_and_set(current, next_))
          return next_
        end
      end
    end
    
    typesig { [::Java::Long] }
    # 
    # Atomically adds the given value to the current value.
    # 
    # @param delta the value to add
    # @return the updated value
    def add_and_get(delta)
      loop do
        current = get
        next_ = current + delta
        if (compare_and_set(current, next_))
          return next_
        end
      end
    end
    
    typesig { [] }
    # 
    # Returns the String representation of the current value.
    # @return the String representation of the current value.
    def to_s
      return Long.to_s(get)
    end
    
    typesig { [] }
    def int_value
      return RJava.cast_to_int(get)
    end
    
    typesig { [] }
    def long_value
      return get
    end
    
    typesig { [] }
    def float_value
      return (get).to_f
    end
    
    typesig { [] }
    def double_value
      return (get).to_f
    end
    
    private
    alias_method :initialize__atomic_long, :initialize
  end
  
end
