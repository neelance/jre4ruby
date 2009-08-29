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
  module AtomicMarkableReferenceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Atomic
    }
  end
  
  # An {@code AtomicMarkableReference} maintains an object reference
  # along with a mark bit, that can be updated atomically.
  # <p>
  # <p> Implementation note. This implementation maintains markable
  # references by creating internal objects representing "boxed"
  # [reference, boolean] pairs.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <V> The type of object referred to by this reference
  class AtomicMarkableReference 
    include_class_members AtomicMarkableReferenceImports
    
    class_module.module_eval {
      const_set_lazy(:ReferenceBooleanPair) { Class.new do
        include_class_members AtomicMarkableReference
        
        attr_accessor :reference
        alias_method :attr_reference, :reference
        undef_method :reference
        alias_method :attr_reference=, :reference=
        undef_method :reference=
        
        attr_accessor :bit
        alias_method :attr_bit, :bit
        undef_method :bit
        alias_method :attr_bit=, :bit=
        undef_method :bit=
        
        typesig { [Object, ::Java::Boolean] }
        def initialize(r, i)
          @reference = nil
          @bit = false
          @reference = r
          @bit = i
        end
        
        private
        alias_method :initialize__reference_boolean_pair, :initialize
      end }
    }
    
    attr_accessor :atomic_ref
    alias_method :attr_atomic_ref, :atomic_ref
    undef_method :atomic_ref
    alias_method :attr_atomic_ref=, :atomic_ref=
    undef_method :atomic_ref=
    
    typesig { [Object, ::Java::Boolean] }
    # Creates a new {@code AtomicMarkableReference} with the given
    # initial values.
    # 
    # @param initialRef the initial reference
    # @param initialMark the initial mark
    def initialize(initial_ref, initial_mark)
      @atomic_ref = nil
      @atomic_ref = AtomicReference.new(ReferenceBooleanPair.new(initial_ref, initial_mark))
    end
    
    typesig { [] }
    # Returns the current value of the reference.
    # 
    # @return the current value of the reference
    def get_reference
      return @atomic_ref.get.attr_reference
    end
    
    typesig { [] }
    # Returns the current value of the mark.
    # 
    # @return the current value of the mark
    def is_marked
      return @atomic_ref.get.attr_bit
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    # Returns the current values of both the reference and the mark.
    # Typical usage is {@code boolean[1] holder; ref = v.get(holder); }.
    # 
    # @param markHolder an array of size of at least one. On return,
    # {@code markholder[0]} will hold the value of the mark.
    # @return the current value of the reference
    def get(mark_holder)
      p = @atomic_ref.get
      mark_holder[0] = p.attr_bit
      return p.attr_reference
    end
    
    typesig { [Object, Object, ::Java::Boolean, ::Java::Boolean] }
    # Atomically sets the value of both the reference and mark
    # to the given update values if the
    # current reference is {@code ==} to the expected reference
    # and the current mark is equal to the expected mark.
    # 
    # <p>May <a href="package-summary.html#Spurious">fail spuriously</a>
    # and does not provide ordering guarantees, so is only rarely an
    # appropriate alternative to {@code compareAndSet}.
    # 
    # @param expectedReference the expected value of the reference
    # @param newReference the new value for the reference
    # @param expectedMark the expected value of the mark
    # @param newMark the new value for the mark
    # @return true if successful
    def weak_compare_and_set(expected_reference, new_reference, expected_mark, new_mark)
      current = @atomic_ref.get
      return (expected_reference).equal?(current.attr_reference) && (expected_mark).equal?(current.attr_bit) && (((new_reference).equal?(current.attr_reference) && (new_mark).equal?(current.attr_bit)) || @atomic_ref.weak_compare_and_set(current, ReferenceBooleanPair.new(new_reference, new_mark)))
    end
    
    typesig { [Object, Object, ::Java::Boolean, ::Java::Boolean] }
    # Atomically sets the value of both the reference and mark
    # to the given update values if the
    # current reference is {@code ==} to the expected reference
    # and the current mark is equal to the expected mark.
    # 
    # @param expectedReference the expected value of the reference
    # @param newReference the new value for the reference
    # @param expectedMark the expected value of the mark
    # @param newMark the new value for the mark
    # @return true if successful
    def compare_and_set(expected_reference, new_reference, expected_mark, new_mark)
      current = @atomic_ref.get
      return (expected_reference).equal?(current.attr_reference) && (expected_mark).equal?(current.attr_bit) && (((new_reference).equal?(current.attr_reference) && (new_mark).equal?(current.attr_bit)) || @atomic_ref.compare_and_set(current, ReferenceBooleanPair.new(new_reference, new_mark)))
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Unconditionally sets the value of both the reference and mark.
    # 
    # @param newReference the new value for the reference
    # @param newMark the new value for the mark
    def set(new_reference, new_mark)
      current = @atomic_ref.get
      if (!(new_reference).equal?(current.attr_reference) || !(new_mark).equal?(current.attr_bit))
        @atomic_ref.set(ReferenceBooleanPair.new(new_reference, new_mark))
      end
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Atomically sets the value of the mark to the given update value
    # if the current reference is {@code ==} to the expected
    # reference.  Any given invocation of this operation may fail
    # (return {@code false}) spuriously, but repeated invocation
    # when the current value holds the expected value and no other
    # thread is also attempting to set the value will eventually
    # succeed.
    # 
    # @param expectedReference the expected value of the reference
    # @param newMark the new value for the mark
    # @return true if successful
    def attempt_mark(expected_reference, new_mark)
      current = @atomic_ref.get
      return (expected_reference).equal?(current.attr_reference) && ((new_mark).equal?(current.attr_bit) || @atomic_ref.compare_and_set(current, ReferenceBooleanPair.new(expected_reference, new_mark)))
    end
    
    private
    alias_method :initialize__atomic_markable_reference, :initialize
  end
  
end
