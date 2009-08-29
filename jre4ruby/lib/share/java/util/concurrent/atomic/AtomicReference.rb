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
  module AtomicReferenceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # An object reference that may be updated atomically. See the {@link
  # java.util.concurrent.atomic} package specification for description
  # of the properties of atomic variables.
  # @since 1.5
  # @author Doug Lea
  # @param <V> The type of object referred to by this reference
  class AtomicReference 
    include_class_members AtomicReferenceImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -1848883965231344442 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :ValueOffset, UnsafeInstance.object_field_offset(AtomicReference.get_declared_field("value"))
        rescue JavaException => ex
          raise JavaError.new(ex)
        end
      end
    }
    
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [Object] }
    # Creates a new AtomicReference with the given initial value.
    # 
    # @param initialValue the initial value
    def initialize(initial_value)
      @value = nil
      @value = initial_value
    end
    
    typesig { [] }
    # Creates a new AtomicReference with null initial value.
    def initialize
      @value = nil
    end
    
    typesig { [] }
    # Gets the current value.
    # 
    # @return the current value
    def get
      return @value
    end
    
    typesig { [Object] }
    # Sets to the given value.
    # 
    # @param newValue the new value
    def set(new_value)
      @value = new_value
    end
    
    typesig { [Object] }
    # Eventually sets to the given value.
    # 
    # @param newValue the new value
    # @since 1.6
    def lazy_set(new_value)
      UnsafeInstance.put_ordered_object(self, ValueOffset, new_value)
    end
    
    typesig { [Object, Object] }
    # Atomically sets the value to the given updated value
    # if the current value {@code ==} the expected value.
    # @param expect the expected value
    # @param update the new value
    # @return true if successful. False return indicates that
    # the actual value was not equal to the expected value.
    def compare_and_set(expect, update)
      return UnsafeInstance.compare_and_swap_object(self, ValueOffset, expect, update)
    end
    
    typesig { [Object, Object] }
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
      return UnsafeInstance.compare_and_swap_object(self, ValueOffset, expect, update)
    end
    
    typesig { [Object] }
    # Atomically sets to the given value and returns the old value.
    # 
    # @param newValue the new value
    # @return the previous value
    def get_and_set(new_value)
      while (true)
        x = get
        if (compare_and_set(x, new_value))
          return x
        end
      end
    end
    
    typesig { [] }
    # Returns the String representation of the current value.
    # @return the String representation of the current value.
    def to_s
      return String.value_of(get)
    end
    
    private
    alias_method :initialize__atomic_reference, :initialize
  end
  
end
