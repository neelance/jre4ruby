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
  module AtomicStampedReferenceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
    }
  end
  
  # 
  # An {@code AtomicStampedReference} maintains an object reference
  # along with an integer "stamp", that can be updated atomically.
  # 
  # <p> Implementation note. This implementation maintains stamped
  # references by creating internal objects representing "boxed"
  # [reference, integer] pairs.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <V> The type of object referred to by this reference
  class AtomicStampedReference 
    include_class_members AtomicStampedReferenceImports
    
    class_module.module_eval {
      const_set_lazy(:ReferenceIntegerPair) { Class.new do
        include_class_members AtomicStampedReference
        
        attr_accessor :reference
        alias_method :attr_reference, :reference
        undef_method :reference
        alias_method :attr_reference=, :reference=
        undef_method :reference=
        
        attr_accessor :integer
        alias_method :attr_integer, :integer
        undef_method :integer
        alias_method :attr_integer=, :integer=
        undef_method :integer=
        
        typesig { [Object, ::Java::Int] }
        def initialize(r, i)
          @reference = nil
          @integer = 0
          @reference = r
          @integer = i
        end
        
        private
        alias_method :initialize__reference_integer_pair, :initialize
      end }
    }
    
    attr_accessor :atomic_ref
    alias_method :attr_atomic_ref, :atomic_ref
    undef_method :atomic_ref
    alias_method :attr_atomic_ref=, :atomic_ref=
    undef_method :atomic_ref=
    
    typesig { [Object, ::Java::Int] }
    # 
    # Creates a new {@code AtomicStampedReference} with the given
    # initial values.
    # 
    # @param initialRef the initial reference
    # @param initialStamp the initial stamp
    def initialize(initial_ref, initial_stamp)
      @atomic_ref = nil
      @atomic_ref = AtomicReference.new(ReferenceIntegerPair.new(initial_ref, initial_stamp))
    end
    
    typesig { [] }
    # 
    # Returns the current value of the reference.
    # 
    # @return the current value of the reference
    def get_reference
      return @atomic_ref.get.attr_reference
    end
    
    typesig { [] }
    # 
    # Returns the current value of the stamp.
    # 
    # @return the current value of the stamp
    def get_stamp
      return @atomic_ref.get.attr_integer
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # 
    # Returns the current values of both the reference and the stamp.
    # Typical usage is {@code int[1] holder; ref = v.get(holder); }.
    # 
    # @param stampHolder an array of size of at least one.  On return,
    # {@code stampholder[0]} will hold the value of the stamp.
    # @return the current value of the reference
    def get(stamp_holder)
      p = @atomic_ref.get
      stamp_holder[0] = p.attr_integer
      return p.attr_reference
    end
    
    typesig { [Object, Object, ::Java::Int, ::Java::Int] }
    # 
    # Atomically sets the value of both the reference and stamp
    # to the given update values if the
    # current reference is {@code ==} to the expected reference
    # and the current stamp is equal to the expected stamp.
    # 
    # <p>May <a href="package-summary.html#Spurious">fail spuriously</a>
    # and does not provide ordering guarantees, so is only rarely an
    # appropriate alternative to {@code compareAndSet}.
    # 
    # @param expectedReference the expected value of the reference
    # @param newReference the new value for the reference
    # @param expectedStamp the expected value of the stamp
    # @param newStamp the new value for the stamp
    # @return true if successful
    def weak_compare_and_set(expected_reference, new_reference, expected_stamp, new_stamp)
      current = @atomic_ref.get
      return (expected_reference).equal?(current.attr_reference) && (expected_stamp).equal?(current.attr_integer) && (((new_reference).equal?(current.attr_reference) && (new_stamp).equal?(current.attr_integer)) || @atomic_ref.weak_compare_and_set(current, ReferenceIntegerPair.new(new_reference, new_stamp)))
    end
    
    typesig { [Object, Object, ::Java::Int, ::Java::Int] }
    # 
    # Atomically sets the value of both the reference and stamp
    # to the given update values if the
    # current reference is {@code ==} to the expected reference
    # and the current stamp is equal to the expected stamp.
    # 
    # @param expectedReference the expected value of the reference
    # @param newReference the new value for the reference
    # @param expectedStamp the expected value of the stamp
    # @param newStamp the new value for the stamp
    # @return true if successful
    def compare_and_set(expected_reference, new_reference, expected_stamp, new_stamp)
      current = @atomic_ref.get
      return (expected_reference).equal?(current.attr_reference) && (expected_stamp).equal?(current.attr_integer) && (((new_reference).equal?(current.attr_reference) && (new_stamp).equal?(current.attr_integer)) || @atomic_ref.compare_and_set(current, ReferenceIntegerPair.new(new_reference, new_stamp)))
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # Unconditionally sets the value of both the reference and stamp.
    # 
    # @param newReference the new value for the reference
    # @param newStamp the new value for the stamp
    def set(new_reference, new_stamp)
      current = @atomic_ref.get
      if (!(new_reference).equal?(current.attr_reference) || !(new_stamp).equal?(current.attr_integer))
        @atomic_ref.set(ReferenceIntegerPair.new(new_reference, new_stamp))
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # Atomically sets the value of the stamp to the given update value
    # if the current reference is {@code ==} to the expected
    # reference.  Any given invocation of this operation may fail
    # (return {@code false}) spuriously, but repeated invocation
    # when the current value holds the expected value and no other
    # thread is also attempting to set the value will eventually
    # succeed.
    # 
    # @param expectedReference the expected value of the reference
    # @param newStamp the new value for the stamp
    # @return true if successful
    def attempt_stamp(expected_reference, new_stamp)
      current = @atomic_ref.get
      return (expected_reference).equal?(current.attr_reference) && ((new_stamp).equal?(current.attr_integer) || @atomic_ref.compare_and_set(current, ReferenceIntegerPair.new(expected_reference, new_stamp)))
    end
    
    private
    alias_method :initialize__atomic_stamped_reference, :initialize
  end
  
end
