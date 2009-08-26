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
  module RegularEnumSetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Private implementation class for EnumSet, for "regular sized" enum types
  # (i.e., those with 64 or fewer enum constants).
  # 
  # @author Josh Bloch
  # @since 1.5
  # @serial exclude
  class RegularEnumSet < RegularEnumSetImports.const_get :EnumSet
    include_class_members RegularEnumSetImports
    
    # Bit vector representation of this set.  The 2^k bit indicates the
    # presence of universe[k] in this set.
    attr_accessor :elements
    alias_method :attr_elements, :elements
    undef_method :elements
    alias_method :attr_elements=, :elements=
    undef_method :elements=
    
    typesig { [Class, Array.typed(Enum)] }
    def initialize(element_type, universe)
      @elements = 0
      super(element_type, universe)
      @elements = 0
    end
    
    typesig { [Object, Object] }
    def add_range(from, to)
      @elements = (-1 >> (from.ordinal - to.ordinal - 1)) << from.ordinal
    end
    
    typesig { [] }
    def add_all
      if (!(self.attr_universe.attr_length).equal?(0))
        @elements = -1 >> -self.attr_universe.attr_length
      end
    end
    
    typesig { [] }
    def complement
      if (!(self.attr_universe.attr_length).equal?(0))
        @elements = ~@elements
        @elements &= -1 >> -self.attr_universe.attr_length # Mask unused bits
      end
    end
    
    typesig { [] }
    # Returns an iterator over the elements contained in this set.  The
    # iterator traverses the elements in their <i>natural order</i> (which is
    # the order in which the enum constants are declared). The returned
    # Iterator is a "snapshot" iterator that will never throw {@link
    # ConcurrentModificationException}; the elements are traversed as they
    # existed when this call was invoked.
    # 
    # @return an iterator over the elements contained in this set
    def iterator
      return EnumSetIterator.new_local(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:EnumSetIterator) { Class.new do
        extend LocalClass
        include_class_members RegularEnumSet
        include Iterator
        
        # A bit vector representing the elements in the set not yet
        # returned by this iterator.
        attr_accessor :unseen
        alias_method :attr_unseen, :unseen
        undef_method :unseen
        alias_method :attr_unseen=, :unseen=
        undef_method :unseen=
        
        # The bit representing the last element returned by this iterator
        # but not removed, or zero if no such element exists.
        attr_accessor :last_returned
        alias_method :attr_last_returned, :last_returned
        undef_method :last_returned
        alias_method :attr_last_returned=, :last_returned=
        undef_method :last_returned=
        
        typesig { [] }
        def initialize
          @unseen = 0
          @last_returned = 0
          @unseen = self.attr_elements
        end
        
        typesig { [] }
        def has_next
          return !(@unseen).equal?(0)
        end
        
        typesig { [] }
        def next_
          if ((@unseen).equal?(0))
            raise self.class::NoSuchElementException.new
          end
          @last_returned = @unseen & -@unseen
          @unseen -= @last_returned
          return self.attr_universe[Long.number_of_trailing_zeros(@last_returned)]
        end
        
        typesig { [] }
        def remove
          if ((@last_returned).equal?(0))
            raise self.class::IllegalStateException.new
          end
          self.attr_elements -= @last_returned
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
      return Long.bit_count(@elements)
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this set contains no elements.
    # 
    # @return <tt>true</tt> if this set contains no elements
    def is_empty
      return (@elements).equal?(0)
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
      return !((@elements & (1 << (e).ordinal))).equal?(0)
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
      old_elements = @elements
      @elements |= (1 << (e).ordinal)
      return !(@elements).equal?(old_elements)
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
      old_elements = @elements
      @elements &= ~(1 << (e).ordinal)
      return !(@elements).equal?(old_elements)
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
      if (!(c.is_a?(RegularEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        return es.is_empty
      end
      return ((es.attr_elements & ~@elements)).equal?(0)
    end
    
    typesig { [Collection] }
    # Adds all of the elements in the specified collection to this set.
    # 
    # @param c collection whose elements are to be added to this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def add_all(c)
      if (!(c.is_a?(RegularEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        if (es.is_empty)
          return false
        else
          raise ClassCastException.new(RJava.cast_to_string(es.attr_element_type) + " != " + RJava.cast_to_string(self.attr_element_type))
        end
      end
      old_elements = @elements
      @elements |= es.attr_elements
      return !(@elements).equal?(old_elements)
    end
    
    typesig { [Collection] }
    # Removes from this set all of its elements that are contained in
    # the specified collection.
    # 
    # @param c elements to be removed from this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    def remove_all(c)
      if (!(c.is_a?(RegularEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        return false
      end
      old_elements = @elements
      @elements &= ~es.attr_elements
      return !(@elements).equal?(old_elements)
    end
    
    typesig { [Collection] }
    # Retains only the elements in this set that are contained in the
    # specified collection.
    # 
    # @param c elements to be retained in this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    def retain_all(c)
      if (!(c.is_a?(RegularEnumSet)))
        return super(c)
      end
      es = c
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        changed = (!(@elements).equal?(0))
        @elements = 0
        return changed
      end
      old_elements = @elements
      @elements &= es.attr_elements
      return !(@elements).equal?(old_elements)
    end
    
    typesig { [] }
    # Removes all of the elements from this set.
    def clear
      @elements = 0
    end
    
    typesig { [Object] }
    # Compares the specified object with this set for equality.  Returns
    # <tt>true</tt> if the given object is also a set, the two sets have
    # the same size, and every member of the given set is contained in
    # this set.
    # 
    # @param e object to be compared for equality with this set
    # @return <tt>true</tt> if the specified object is equal to this set
    def ==(o)
      if (!(o.is_a?(RegularEnumSet)))
        return super(o)
      end
      es = o
      if (!(es.attr_element_type).equal?(self.attr_element_type))
        return (@elements).equal?(0) && (es.attr_elements).equal?(0)
      end
      return (es.attr_elements).equal?(@elements)
    end
    
    private
    alias_method :initialize__regular_enum_set, :initialize
  end
  
end
