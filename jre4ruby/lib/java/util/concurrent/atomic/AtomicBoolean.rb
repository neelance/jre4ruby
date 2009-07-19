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
  module AtomicBooleanImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # A {@code boolean} value that may be updated atomically. See the
  # {@link java.util.concurrent.atomic} package specification for
  # description of the properties of atomic variables. An
  # {@code AtomicBoolean} is used in applications such as atomically
  # updated flags, and cannot be used as a replacement for a
  # {@link java.lang.Boolean}.
  # 
  # @since 1.5
  # @author Doug Lea
  class AtomicBoolean 
    include_class_members AtomicBooleanImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 4654671469794556979 }
      const_attr_reader  :SerialVersionUID
      
      # setup to use Unsafe.compareAndSwapInt for updates
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :ValueOffset, UnsafeInstance.object_field_offset(AtomicBoolean.class.get_declared_field("value"))
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
    
    typesig { [::Java::Boolean] }
    # Creates a new {@code AtomicBoolean} with the given initial value.
    # 
    # @param initialValue the initial value
    def initialize(initial_value)
      @value = 0
      @value = initial_value ? 1 : 0
    end
    
    typesig { [] }
    # Creates a new {@code AtomicBoolean} with initial value {@code false}.
    def initialize
      @value = 0
    end
    
    typesig { [] }
    # Returns the current value.
    # 
    # @return the current value
    def get
      return !(@value).equal?(0)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Atomically sets the value to the given updated value
    # if the current value {@code ==} the expected value.
    # 
    # @param expect the expected value
    # @param update the new value
    # @return true if successful. False return indicates that
    # the actual value was not equal to the expected value.
    def compare_and_set(expect, update)
      e = expect ? 1 : 0
      u = update ? 1 : 0
      return UnsafeInstance.compare_and_swap_int(self, ValueOffset, e, u)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
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
      e = expect ? 1 : 0
      u = update ? 1 : 0
      return UnsafeInstance.compare_and_swap_int(self, ValueOffset, e, u)
    end
    
    typesig { [::Java::Boolean] }
    # Unconditionally sets to the given value.
    # 
    # @param newValue the new value
    def set(new_value)
      @value = new_value ? 1 : 0
    end
    
    typesig { [::Java::Boolean] }
    # Eventually sets to the given value.
    # 
    # @param newValue the new value
    # @since 1.6
    def lazy_set(new_value)
      v = new_value ? 1 : 0
      UnsafeInstance.put_ordered_int(self, ValueOffset, v)
    end
    
    typesig { [::Java::Boolean] }
    # Atomically sets to the given value and returns the previous value.
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
    
    typesig { [] }
    # Returns the String representation of the current value.
    # @return the String representation of the current value.
    def to_s
      return Boolean.to_s(get)
    end
    
    private
    alias_method :initialize__atomic_boolean, :initialize
  end
  
end
