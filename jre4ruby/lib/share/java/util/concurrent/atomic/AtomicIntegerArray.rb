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
  module AtomicIntegerArrayImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
      include ::Java::Util
    }
  end
  
  # An {@code int} array in which elements may be updated atomically.
  # See the {@link java.util.concurrent.atomic} package
  # specification for description of the properties of atomic
  # variables.
  # @since 1.5
  # @author Doug Lea
  class AtomicIntegerArray 
    include_class_members AtomicIntegerArrayImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 2862133569453604235 }
      const_attr_reader  :SerialVersionUID
      
      # setup to use Unsafe.compareAndSwapInt for updates
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      const_set_lazy(:Base) { UnsafeInstance.array_base_offset(Array) }
      const_attr_reader  :Base
      
      const_set_lazy(:Scale) { UnsafeInstance.array_index_scale(Array) }
      const_attr_reader  :Scale
    }
    
    attr_accessor :array
    alias_method :attr_array, :array
    undef_method :array
    alias_method :attr_array=, :array=
    undef_method :array=
    
    typesig { [::Java::Int] }
    def raw_index(i)
      if (i < 0 || i >= @array.attr_length)
        raise IndexOutOfBoundsException.new("index " + RJava.cast_to_string(i))
      end
      return Base + i * Scale
    end
    
    typesig { [::Java::Int] }
    # Creates a new AtomicIntegerArray of given length.
    # 
    # @param length the length of the array
    def initialize(length)
      @array = nil
      @array = Array.typed(::Java::Int).new(length) { 0 }
      # must perform at least one volatile write to conform to JMM
      if (length > 0)
        UnsafeInstance.put_int_volatile(@array, raw_index(0), 0)
      end
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Creates a new AtomicIntegerArray with the same length as, and
    # all elements copied from, the given array.
    # 
    # @param array the array to copy elements from
    # @throws NullPointerException if array is null
    def initialize(array)
      @array = nil
      if ((array).nil?)
        raise NullPointerException.new
      end
      length = array.attr_length
      @array = Array.typed(::Java::Int).new(length) { 0 }
      if (length > 0)
        last = length - 1
        i = 0
        while i < last
          @array[i] = array[i]
          (i += 1)
        end
        # Do the last write as volatile
        UnsafeInstance.put_int_volatile(@array, raw_index(last), array[last])
      end
    end
    
    typesig { [] }
    # Returns the length of the array.
    # 
    # @return the length of the array
    def length
      return @array.attr_length
    end
    
    typesig { [::Java::Int] }
    # Gets the current value at position {@code i}.
    # 
    # @param i the index
    # @return the current value
    def get(i)
      return UnsafeInstance.get_int_volatile(@array, raw_index(i))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the element at position {@code i} to the given value.
    # 
    # @param i the index
    # @param newValue the new value
    def set(i, new_value)
      UnsafeInstance.put_int_volatile(@array, raw_index(i), new_value)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Eventually sets the element at position {@code i} to the given value.
    # 
    # @param i the index
    # @param newValue the new value
    # @since 1.6
    def lazy_set(i, new_value)
      UnsafeInstance.put_ordered_int(@array, raw_index(i), new_value)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Atomically sets the element at position {@code i} to the given
    # value and returns the old value.
    # 
    # @param i the index
    # @param newValue the new value
    # @return the previous value
    def get_and_set(i, new_value)
      while (true)
        current = get(i)
        if (compare_and_set(i, current, new_value))
          return current
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Atomically sets the element at position {@code i} to the given
    # updated value if the current value {@code ==} the expected value.
    # 
    # @param i the index
    # @param expect the expected value
    # @param update the new value
    # @return true if successful. False return indicates that
    # the actual value was not equal to the expected value.
    def compare_and_set(i, expect, update)
      return UnsafeInstance.compare_and_swap_int(@array, raw_index(i), expect, update)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Atomically sets the element at position {@code i} to the given
    # updated value if the current value {@code ==} the expected value.
    # 
    # <p>May <a href="package-summary.html#Spurious">fail spuriously</a>
    # and does not provide ordering guarantees, so is only rarely an
    # appropriate alternative to {@code compareAndSet}.
    # 
    # @param i the index
    # @param expect the expected value
    # @param update the new value
    # @return true if successful.
    def weak_compare_and_set(i, expect, update)
      return compare_and_set(i, expect, update)
    end
    
    typesig { [::Java::Int] }
    # Atomically increments by one the element at index {@code i}.
    # 
    # @param i the index
    # @return the previous value
    def get_and_increment(i)
      while (true)
        current = get(i)
        next_ = current + 1
        if (compare_and_set(i, current, next_))
          return current
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Atomically decrements by one the element at index {@code i}.
    # 
    # @param i the index
    # @return the previous value
    def get_and_decrement(i)
      while (true)
        current = get(i)
        next_ = current - 1
        if (compare_and_set(i, current, next_))
          return current
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Atomically adds the given value to the element at index {@code i}.
    # 
    # @param i the index
    # @param delta the value to add
    # @return the previous value
    def get_and_add(i, delta)
      while (true)
        current = get(i)
        next_ = current + delta
        if (compare_and_set(i, current, next_))
          return current
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Atomically increments by one the element at index {@code i}.
    # 
    # @param i the index
    # @return the updated value
    def increment_and_get(i)
      while (true)
        current = get(i)
        next_ = current + 1
        if (compare_and_set(i, current, next_))
          return next_
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Atomically decrements by one the element at index {@code i}.
    # 
    # @param i the index
    # @return the updated value
    def decrement_and_get(i)
      while (true)
        current = get(i)
        next_ = current - 1
        if (compare_and_set(i, current, next_))
          return next_
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Atomically adds the given value to the element at index {@code i}.
    # 
    # @param i the index
    # @param delta the value to add
    # @return the updated value
    def add_and_get(i, delta)
      while (true)
        current = get(i)
        next_ = current + delta
        if (compare_and_set(i, current, next_))
          return next_
        end
      end
    end
    
    typesig { [] }
    # Returns the String representation of the current values of array.
    # @return the String representation of the current values of array.
    def to_s
      if (@array.attr_length > 0)
        # force volatile read
        get(0)
      end
      return Arrays.to_s(@array)
    end
    
    private
    alias_method :initialize__atomic_integer_array, :initialize
  end
  
end
