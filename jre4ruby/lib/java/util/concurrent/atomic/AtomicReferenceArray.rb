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
  module AtomicReferenceArrayImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
      include ::Java::Util
    }
  end
  
  # 
  # An array of object references in which elements may be updated
  # atomically.  See the {@link java.util.concurrent.atomic} package
  # specification for description of the properties of atomic
  # variables.
  # @since 1.5
  # @author Doug Lea
  # @param <E> The base class of elements held in this array
  class AtomicReferenceArray 
    include_class_members AtomicReferenceArrayImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -6209656149925076980 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      const_set_lazy(:Base) { UnsafeInstance.array_base_offset(Array[]) }
      const_attr_reader  :Base
      
      const_set_lazy(:Scale) { UnsafeInstance.array_index_scale(Array[]) }
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
        raise IndexOutOfBoundsException.new("index " + (i).to_s)
      end
      return Base + i * Scale
    end
    
    typesig { [::Java::Int] }
    # 
    # Creates a new AtomicReferenceArray of given length.
    # @param length the length of the array
    def initialize(length)
      @array = nil
      @array = Array.typed(Object).new(length) { nil }
      # must perform at least one volatile write to conform to JMM
      if (length > 0)
        UnsafeInstance.put_object_volatile(@array, raw_index(0), nil)
      end
    end
    
    typesig { [Array.typed(Object)] }
    # 
    # Creates a new AtomicReferenceArray with the same length as, and
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
      @array = Array.typed(Object).new(length) { nil }
      if (length > 0)
        last = length - 1
        i = 0
        while i < last
          @array[i] = array[i]
          (i += 1)
        end
        # Do the last write as volatile
        e = array[last]
        UnsafeInstance.put_object_volatile(@array, raw_index(last), e)
      end
    end
    
    typesig { [] }
    # 
    # Returns the length of the array.
    # 
    # @return the length of the array
    def length
      return @array.attr_length
    end
    
    typesig { [::Java::Int] }
    # 
    # Gets the current value at position {@code i}.
    # 
    # @param i the index
    # @return the current value
    def get(i)
      return UnsafeInstance.get_object_volatile(@array, raw_index(i))
    end
    
    typesig { [::Java::Int, Object] }
    # 
    # Sets the element at position {@code i} to the given value.
    # 
    # @param i the index
    # @param newValue the new value
    def set(i, new_value)
      UnsafeInstance.put_object_volatile(@array, raw_index(i), new_value)
    end
    
    typesig { [::Java::Int, Object] }
    # 
    # Eventually sets the element at position {@code i} to the given value.
    # 
    # @param i the index
    # @param newValue the new value
    # @since 1.6
    def lazy_set(i, new_value)
      UnsafeInstance.put_ordered_object(@array, raw_index(i), new_value)
    end
    
    typesig { [::Java::Int, Object] }
    # 
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
    
    typesig { [::Java::Int, Object, Object] }
    # 
    # Atomically sets the element at position {@code i} to the given
    # updated value if the current value {@code ==} the expected value.
    # @param i the index
    # @param expect the expected value
    # @param update the new value
    # @return true if successful. False return indicates that
    # the actual value was not equal to the expected value.
    def compare_and_set(i, expect, update)
      return UnsafeInstance.compare_and_swap_object(@array, raw_index(i), expect, update)
    end
    
    typesig { [::Java::Int, Object, Object] }
    # 
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
    
    typesig { [] }
    # 
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
    alias_method :initialize__atomic_reference_array, :initialize
  end
  
end
