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
  module AtomicIntegerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # 
  # An {@code int} value that may be updated atomically.  See the
  # {@link java.util.concurrent.atomic} package specification for
  # description of the properties of atomic variables. An
  # {@code AtomicInteger} is used in applications such as atomically
  # incremented counters, and cannot be used as a replacement for an
  # {@link java.lang.Integer}. However, this class does extend
  # {@code Number} to allow uniform access by tools and utilities that
  # deal with numerically-based classes.
  # 
  # @since 1.5
  # @author Doug Lea
  class AtomicInteger < AtomicIntegerImports.const_get :Numeric
    include_class_members AtomicIntegerImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6214790243416807050 }
      const_attr_reader  :SerialVersionUID
      
      # setup to use Unsafe.compareAndSwapInt for updates
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :ValueOffset, UnsafeInstance.object_field_offset(AtomicInteger.class.get_declared_field("value"))
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
    
    typesig { [::Java::Int] }
    # 
    # Creates a new AtomicInteger with the given initial value.
    # 
    # @param initialValue the initial value
    def initialize(initial_value)
      @value = 0
      super()
      @value = initial_value
    end
    
    typesig { [] }
    # 
    # Creates a new AtomicInteger with initial value {@code 0}.
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
    
    typesig { [::Java::Int] }
    # 
    # Sets to the given value.
    # 
    # @param newValue the new value
    def set(new_value)
      @value = new_value
    end
    
    typesig { [::Java::Int] }
    # 
    # Eventually sets to the given value.
    # 
    # @param newValue the new value
    # @since 1.6
    def lazy_set(new_value)
      UnsafeInstance.put_ordered_int(self, ValueOffset, new_value)
    end
    
    typesig { [::Java::Int] }
    # 
    # Atomically sets to the given value and returns the old value.
    # 
    # @param newValue the new value
    # @return the previous value
    def get_and_set(new_value)
      loop do
        current = get
        if (compare_and_set(current, new_value))
          return current
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Atomically sets the value to the given updated value
    # if the current value {@code ==} the expected value.
    # 
    # @param expect the expected value
    # @param update the new value
    # @return true if successful. False return indicates that
    # the actual value was not equal to the expected value.
    def compare_and_set(expect, update)
      return UnsafeInstance.compare_and_swap_int(self, ValueOffset, expect, update)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
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
      return UnsafeInstance.compare_and_swap_int(self, ValueOffset, expect, update)
    end
    
    typesig { [] }
    # 
    # Atomically increments by one the current value.
    # 
    # @return the previous value
    def get_and_increment
      loop do
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
      loop do
        current = get
        next_ = current - 1
        if (compare_and_set(current, next_))
          return current
        end
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Atomically adds the given value to the current value.
    # 
    # @param delta the value to add
    # @return the previous value
    def get_and_add(delta)
      loop do
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
    
    typesig { [::Java::Int] }
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
      return JavaInteger.to_s(get)
    end
    
    typesig { [] }
    def int_value
      return get
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
    alias_method :initialize__atomic_integer, :initialize
  end
  
end
