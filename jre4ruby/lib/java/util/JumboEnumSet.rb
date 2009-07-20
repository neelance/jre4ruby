require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module JumboEnumSetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Private implementation class for EnumSet, for "jumbo" enum types
  # (i.e., those with more than 64 elements).
  # 
  # @author Josh Bloch
  # @since 1.5
  # @serial exclude
  class JumboEnumSet < JumboEnumSetImports.const_get :EnumSet
    include_class_members JumboEnumSetImports
    
    # Bit vector representation of this set.  The ith bit of the jth
    # element of this array represents the  presence of universe[64*j +i]
    # in this set.
    attr_accessor :elements
    alias_method :attr_elements, :elements
    undef_method :elements
    alias_method :attr_elements=, :elements=
    undef_method :elements=
    
    # Redundant - maintained for performance
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [Class, Array.typed(Enum)] }
    def initialize(element_type, universe)
      @elements = nil
      @size = 0
      super(element_type, universe)
      @size = 0
      @elements = Array.typed(::Java::Long).new((universe.attr_length + 63) >> 6) { 0 }
    end
    
    typesig { [Object, Object] }
    def add_range(from, to)
      from_index = from.ordinal >> 6
      to_index = to.ordinal >> 6
      if ((from_index).equal?(to_index))
        @elements[from_index] = (-1 >> (from.ordinal - to.ordinal - 1)) << from.ordinal
      else
        @elements[from_index] = (-1 << from.ordinal)
        i = from_index + 1
        while i < to_index
          @elements[i] = -1
          i += 1
        end
        @elements[to_index] = -1 >> (63 - to.ordinal)
      end
      @size = to.ordinal - from.ordinal + 1
    end
    
    typesig { [] }
    def add_all
      i = 0
      while i < @elements.attr_length
        @elements[i] = -1
        i += 1
      end
      @elements[@elements.attr_length - 1] >>= -self.attr_universe.attr_length
      @size = self.attr_universe.attr_length
    end
    
    typesig { [] }
    def complement
      i = 0
      while i < @elements.attr_length
        @elements[i] = ~@elements[i]
        i += 1
      end
      @elements[@elements.attr_length - 1] &= (-1 >> -self.attr_universe.attr_length)
      @size = self.attr_universe.attr_length - @size
    end
    
    typesig { [] }
    # Returns an iterator over the elements contained in this set.  The
    # iterator traverses the elements in their <i>natural order</i> (which is
    # the order in which the enum constants are declared). The returned
    # Iterator is a "weakly consistent" iterator that will never throw {@link
    # ConcurrentModificationException}.
    # 
    # @return an iterator over the elements contained in this set
    def iterator
      return EnumSetIterator.new_local(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:EnumSetIterator) { Class.new do
        extend LocalClass
        include_class_members JumboEnumSet
        include Iterator
        
        # A bit vector representing the elements in the current "word"
        # of the set not yet returned by this iterator.
        attr_accessor :unseen
        alias_method :attr_unseen, :unseen
        undef_method :unseen
        alias_method :attr_unseen=, :unseen=
        undef_method :unseen=
        
        # The index corresponding to unseen in the elements array.
        attr_accessor :unseen_index
        alias_method :attr_unseen_index, :unseen_index
        undef_method :unseen_index
        alias_method :attr_unseen_index=, :unseen_index=
        undef_method :unseen_index=
        
        # The bit representing the last element returned by this iterator
        # but not removed, or zero if no such element exists.
        attr_accessor :last_returned
        alias_method :attr_last_returned, :last_returned
        undef_method :last_returned
        alias_method :attr_last_returned=, :last_returned=
        undef_method :last_returned=
        
        # The index corresponding to lastReturned in the elements array.
        attr_accessor :last_returned_index
        alias_method :attr_last_returned_index, :last_returned_index
        undef_method :last_returned_index
        alias_method :attr_last_returned_index=, :last_returned_index=
        undef_method :last_returned_index=
        
        typesig { [] }
        def initialize
          @unseen = 0
          @unseen_index = 0
          @last_returned = 0
          @last_returned_index = 0
          @unseen = self.attr_elements[0]
        end
        
        typesig { [] }
        def has_next
          while ((@unseen).equal?(0) && @unseen_index < self.attr_elements.attr_length - 1)
            @unseen = self.attr_elements[(@unseen_index += 1)]
          end
          return !(@unseen).equal?(0)
        end
        
        typesig { [] }
        def next
          if (!has_next)
            raise NoSuchElementException.new
          end
          @last_returned = @unseen & -@unseen
          @last_returned_index = @unseen_index
          @unseen -= @last_returned
          return self.attr_universe[(@last_returned_index << 6) + Long.number_of_trailing_zeros(@last_returned)]
        end
        
        typesig { [] }
        def remove
          if ((@last_returned).equal?(0))
            raise IllegalStateException.new
          end
          self.attr_elements[@last_returned_index] -= @last_returned
          self.attr_size -= 1
          @last_returned = 0
        end
        
        private
        alias_method :initialize__enum_set_iterator, :initialize
      end }
    }
    
    typesig { [] }
    # Returns the number of elements in this set.
    # 
    # @return the number of elements in this set
    def size
      return @size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this set contains no elements.
    # 
    # @return <tt>true</tt> if this set contains no elements
    def is_empty
      return (@size).equal?(0)
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this set contains the specified element.
    # 
    # @param e element to be checked for containment in this collection
    # @return <tt>true</tt> if this set contains the specified element
    def contains(e)
      if ((e).nil?)
        return false
      end
      e_class = e.get_class
      if (!(e_class).equal?(self.attr_element_type) && !(e_class.get_superclass).equal?(self.attr_element_type))
        return false
      end
      e_ordinal = (e).ordinal
      return !((@elements[e_ordinal >> 6] & (1 << e_ordinal))).equal?(0)
    end
    
    typesig { [Object] }
    # Modification Operations
    # 
    # Adds the specified element to this set if it is not already present.
    # 
    # @param e element to be added to this set
    # @return <tt>true</tt> if the set changed as a result of the call
    # 
    # @throws NullPointerException if <tt>e</tt> is null
    def add(e)
      type_check(e)
      e_ordinal = e.ordinal
      e_word_num = e_ordinal >> 6
      old_elements = @elements[e_word_num]
      @elements[e_word_num] |= (1 << e_ordinal)
      result = (!(@elements[e_word_num]).equal?(old_elements))
      if (result)
        @size += 1
      end
      return result
    end
    
    typesig { [Object] }
    # Removes the specified element from this set if it is present.
    # 
    # @param e element to be removed from this set, if present
    # @return <tt>true</tt> if the set contained the specified element
    def remove(e)
      if ((e).nil?)
        return false
      end
      e_class = e.get_class
      if (!(e_class).equal?(self.attr_element_type) && !(e_class.get_superclass).equal?(self.attr_element_type))
        return false
      end
      e_ordinal = (e).ordinal
      e_word_num = e_ordinal >> 6
      old_elements = @elements[e_word_num]
      @elements[e_word_num] &= ~(1 << e_ordinal)
      result = (!(@elements[e_word_num]).equal?(old_elements))
      if (result)
        @size -= 1
      end
      return result
    end
    
    typesig { [Collection] }
    # Bulk Operations
    # 
    # Returns <tt>true</tt> if this set contains all of the elements
    # in the specified collection.
    # 
    # @param c collection to be checked for containment in this set
    # @return <tt>true</tt> if this set contains all of the elements
    # in the specified collection
    # @throws NullPointerException if the specified collection is null
    def contains_all(c)
      if (!(c.is_a?(JumboEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        return es.is_empty
      end
      i = 0
      while i < @elements.attr_length
        if (!((es.attr_elements[i] & ~@elements[i])).equal?(0))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [Collection] }
    # Adds all of the elements in the specified collection to this set.
    # 
    # @param c collection whose elements are to be added to this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws NullPointerException if the specified collection or any of
    # its elements are null
    def add_all(c)
      if (!(c.is_a?(JumboEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        if (es.is_empty)
          return false
        else
          raise ClassCastException.new((es.attr_element_type).to_s + " != " + (self.attr_element_type).to_s)
        end
      end
      i = 0
      while i < @elements.attr_length
        @elements[i] |= es.attr_elements[i]
        i += 1
      end
      return recalculate_size
    end
    
    typesig { [Collection] }
    # Removes from this set all of its elements that are contained in
    # the specified collection.
    # 
    # @param c elements to be removed from this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    def remove_all(c)
      if (!(c.is_a?(JumboEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        return false
      end
      i = 0
      while i < @elements.attr_length
        @elements[i] &= ~es.attr_elements[i]
        i += 1
      end
      return recalculate_size
    end
    
    typesig { [Collection] }
    # Retains only the elements in this set that are contained in the
    # specified collection.
    # 
    # @param c elements to be retained in this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    def retain_all(c)
      if (!(c.is_a?(JumboEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        changed = (!(@size).equal?(0))
        clear
        return changed
      end
      i = 0
      while i < @elements.attr_length
        @elements[i] &= es.attr_elements[i]
        i += 1
      end
      return recalculate_size
    end
    
    typesig { [] }
    # Removes all of the elements from this set.
    def clear
      Arrays.fill(@elements, 0)
      @size = 0
    end
    
    typesig { [Object] }
    # Compares the specified object with this set for equality.  Returns
    # <tt>true</tt> if the given object is also a set, the two sets have
    # the same size, and every member of the given set is contained in
    # this set.
    # 
    # @param e object to be compared for equality with this set
    # @return <tt>true</tt> if the specified object is equal to this set
    def equals(o)
      if (!(o.is_a?(JumboEnumSet)))
        return super(o)
      end
      es = o
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        return (@size).equal?(0) && (es.attr_size).equal?(0)
      end
      return (Arrays == es.attr_elements)
    end
    
    typesig { [] }
    # Recalculates the size of the set.  Returns true if it's changed.
    def recalculate_size
      old_size = @size
      @size = 0
      @elements.each do |elt|
        @size += Long.bit_count(elt)
      end
      return !(@size).equal?(old_size)
    end
    
    typesig { [] }
    def clone
      result = super
      result.attr_elements = result.attr_elements.clone
      return result
    end
    
    private
    alias_method :initialize__jumbo_enum_set, :initialize
  end
  
end
