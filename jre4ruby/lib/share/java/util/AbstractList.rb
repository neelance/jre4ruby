require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AbstractListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # This class provides a skeletal implementation of the {@link List}
  # interface to minimize the effort required to implement this interface
  # backed by a "random access" data store (such as an array).  For sequential
  # access data (such as a linked list), {@link AbstractSequentialList} should
  # be used in preference to this class.
  # 
  # <p>To implement an unmodifiable list, the programmer needs only to extend
  # this class and provide implementations for the {@link #get(int)} and
  # {@link List#size() size()} methods.
  # 
  # <p>To implement a modifiable list, the programmer must additionally
  # override the {@link #set(int, Object) set(int, E)} method (which otherwise
  # throws an {@code UnsupportedOperationException}).  If the list is
  # variable-size the programmer must additionally override the
  # {@link #add(int, Object) add(int, E)} and {@link #remove(int)} methods.
  # 
  # <p>The programmer should generally provide a void (no argument) and collection
  # constructor, as per the recommendation in the {@link Collection} interface
  # specification.
  # 
  # <p>Unlike the other abstract collection implementations, the programmer does
  # <i>not</i> have to provide an iterator implementation; the iterator and
  # list iterator are implemented by this class, on top of the "random access"
  # methods:
  # {@link #get(int)},
  # {@link #set(int, Object) set(int, E)},
  # {@link #add(int, Object) add(int, E)} and
  # {@link #remove(int)}.
  # 
  # <p>The documentation for each non-abstract method in this class describes its
  # implementation in detail.  Each of these methods may be overridden if the
  # collection being implemented admits a more efficient implementation.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @since 1.2
  class AbstractList < AbstractListImports.const_get :AbstractCollection
    include_class_members AbstractListImports
    overload_protected {
      include JavaList
    }
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      @mod_count = 0
      super()
      @mod_count = 0
    end
    
    typesig { [Object] }
    # Appends the specified element to the end of this list (optional
    # operation).
    # 
    # <p>Lists that support this operation may place limitations on what
    # elements may be added to this list.  In particular, some
    # lists will refuse to add null elements, and others will impose
    # restrictions on the type of elements that may be added.  List
    # classes should clearly specify in their documentation any restrictions
    # on what elements may be added.
    # 
    # <p>This implementation calls {@code add(size(), e)}.
    # 
    # <p>Note that this implementation throws an
    # {@code UnsupportedOperationException} unless
    # {@link #add(int, Object) add(int, E)} is overridden.
    # 
    # @param e element to be appended to this list
    # @return {@code true} (as specified by {@link Collection#add})
    # @throws UnsupportedOperationException if the {@code add} operation
    # is not supported by this list
    # @throws ClassCastException if the class of the specified element
    # prevents it from being added to this list
    # @throws NullPointerException if the specified element is null and this
    # list does not permit null elements
    # @throws IllegalArgumentException if some property of this element
    # prevents it from being added to this list
    def add(e)
      add(size, e)
      return true
    end
    
    typesig { [::Java::Int] }
    # {@inheritDoc}
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def get(index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation always throws an
    # {@code UnsupportedOperationException}.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def set(index, element)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int, Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation always throws an
    # {@code UnsupportedOperationException}.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def add(index, element)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    # {@inheritDoc}
    # 
    # <p>This implementation always throws an
    # {@code UnsupportedOperationException}.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def remove(index)
      raise UnsupportedOperationException.new
    end
    
    typesig { [Object] }
    # Search Operations
    # 
    # {@inheritDoc}
    # 
    # <p>This implementation first gets a list iterator (with
    # {@code listIterator()}).  Then, it iterates over the list until the
    # specified element is found or the end of the list is reached.
    # 
    # @throws ClassCastException   {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def index_of(o)
      e = list_iterator
      if ((o).nil?)
        while (e.has_next)
          if ((e.next_).nil?)
            return e.previous_index
          end
        end
      else
        while (e.has_next)
          if ((o == e.next_))
            return e.previous_index
          end
        end
      end
      return -1
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation first gets a list iterator that points to the end
    # of the list (with {@code listIterator(size())}).  Then, it iterates
    # backwards over the list until the specified element is found, or the
    # beginning of the list is reached.
    # 
    # @throws ClassCastException   {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def last_index_of(o)
      e = list_iterator(size)
      if ((o).nil?)
        while (e.has_previous)
          if ((e.previous).nil?)
            return e.next_index
          end
        end
      else
        while (e.has_previous)
          if ((o == e.previous))
            return e.next_index
          end
        end
      end
      return -1
    end
    
    typesig { [] }
    # Bulk Operations
    # 
    # Removes all of the elements from this list (optional operation).
    # The list will be empty after this call returns.
    # 
    # <p>This implementation calls {@code removeRange(0, size())}.
    # 
    # <p>Note that this implementation throws an
    # {@code UnsupportedOperationException} unless {@code remove(int
    # index)} or {@code removeRange(int fromIndex, int toIndex)} is
    # overridden.
    # 
    # @throws UnsupportedOperationException if the {@code clear} operation
    # is not supported by this list
    def clear
      remove_range(0, size)
    end
    
    typesig { [::Java::Int, Collection] }
    # {@inheritDoc}
    # 
    # <p>This implementation gets an iterator over the specified collection
    # and iterates over it, inserting the elements obtained from the
    # iterator into this list at the appropriate position, one at a time,
    # using {@code add(int, E)}.
    # Many implementations will override this method for efficiency.
    # 
    # <p>Note that this implementation throws an
    # {@code UnsupportedOperationException} unless
    # {@link #add(int, Object) add(int, E)} is overridden.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def add_all(index, c)
      range_check_for_add(index)
      modified = false
      e = c.iterator
      while (e.has_next)
        add(((index += 1) - 1), e.next_)
        modified = true
      end
      return modified
    end
    
    typesig { [] }
    # Iterators
    # 
    # Returns an iterator over the elements in this list in proper sequence.
    # 
    # <p>This implementation returns a straightforward implementation of the
    # iterator interface, relying on the backing list's {@code size()},
    # {@code get(int)}, and {@code remove(int)} methods.
    # 
    # <p>Note that the iterator returned by this method will throw an
    # {@link UnsupportedOperationException} in response to its
    # {@code remove} method unless the list's {@code remove(int)} method is
    # overridden.
    # 
    # <p>This implementation can be made to throw runtime exceptions in the
    # face of concurrent modification, as described in the specification
    # for the (protected) {@link #modCount} field.
    # 
    # @return an iterator over the elements in this list in proper sequence
    def iterator
      return Itr.new_local(self)
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns {@code listIterator(0)}.
    # 
    # @see #listIterator(int)
    def list_iterator
      return list_iterator(0)
    end
    
    typesig { [::Java::Int] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns a straightforward implementation of the
    # {@code ListIterator} interface that extends the implementation of the
    # {@code Iterator} interface returned by the {@code iterator()} method.
    # The {@code ListIterator} implementation relies on the backing list's
    # {@code get(int)}, {@code set(int, E)}, {@code add(int, E)}
    # and {@code remove(int)} methods.
    # 
    # <p>Note that the list iterator returned by this implementation will
    # throw an {@link UnsupportedOperationException} in response to its
    # {@code remove}, {@code set} and {@code add} methods unless the
    # list's {@code remove(int)}, {@code set(int, E)}, and
    # {@code add(int, E)} methods are overridden.
    # 
    # <p>This implementation can be made to throw runtime exceptions in the
    # face of concurrent modification, as described in the specification for
    # the (protected) {@link #modCount} field.
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def list_iterator(index)
      range_check_for_add(index)
      return ListItr.new_local(self, index)
    end
    
    class_module.module_eval {
      const_set_lazy(:Itr) { Class.new do
        extend LocalClass
        include_class_members AbstractList
        include Iterator
        
        # Index of element to be returned by subsequent call to next.
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        # Index of element returned by most recent call to next or
        # previous.  Reset to -1 if this element is deleted by a call
        # to remove.
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        # The modCount value that the iterator believes that the backing
        # List should have.  If this expectation is violated, the iterator
        # has detected concurrent modification.
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        typesig { [] }
        def has_next
          return !(@cursor).equal?(size)
        end
        
        typesig { [] }
        def next_
          check_for_comodification
          begin
            i = @cursor
            next_ = get(i)
            @last_ret = i
            @cursor = i + 1
            return next_
          rescue IndexOutOfBoundsException => e
            check_for_comodification
            raise NoSuchElementException.new
          end
        end
        
        typesig { [] }
        def remove
          if (@last_ret < 0)
            raise IllegalStateException.new
          end
          check_for_comodification
          begin
            @local_class_parent.remove(@last_ret)
            if (@last_ret < @cursor)
              @cursor -= 1
            end
            @last_ret = -1
            @expected_mod_count = self.attr_mod_count
          rescue IndexOutOfBoundsException => e
            raise ConcurrentModificationException.new
          end
        end
        
        typesig { [] }
        def check_for_comodification
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
        end
        
        typesig { [] }
        def initialize
          @cursor = 0
          @last_ret = -1
          @expected_mod_count = self.attr_mod_count
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
      
      const_set_lazy(:ListItr) { Class.new(Itr) do
        extend LocalClass
        include_class_members AbstractList
        overload_protected {
          include ListIterator
        }
        
        typesig { [::Java::Int] }
        def initialize(index)
          super()
          self.attr_cursor = index
        end
        
        typesig { [] }
        def has_previous
          return !(self.attr_cursor).equal?(0)
        end
        
        typesig { [] }
        def previous
          check_for_comodification
          begin
            i = self.attr_cursor - 1
            previous = get(i)
            self.attr_last_ret = self.attr_cursor = i
            return previous
          rescue IndexOutOfBoundsException => e
            check_for_comodification
            raise NoSuchElementException.new
          end
        end
        
        typesig { [] }
        def next_index
          return self.attr_cursor
        end
        
        typesig { [] }
        def previous_index
          return self.attr_cursor - 1
        end
        
        typesig { [E] }
        def set(e)
          if (self.attr_last_ret < 0)
            raise IllegalStateException.new
          end
          check_for_comodification
          begin
            @local_class_parent.set(self.attr_last_ret, e)
            self.attr_expected_mod_count = self.attr_mod_count
          rescue IndexOutOfBoundsException => ex
            raise ConcurrentModificationException.new
          end
        end
        
        typesig { [E] }
        def add(e)
          check_for_comodification
          begin
            i = self.attr_cursor
            @local_class_parent.add(i, e)
            self.attr_last_ret = -1
            self.attr_cursor = i + 1
            self.attr_expected_mod_count = self.attr_mod_count
          rescue IndexOutOfBoundsException => ex
            raise ConcurrentModificationException.new
          end
        end
        
        private
        alias_method :initialize__list_itr, :initialize
      end }
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns a list that subclasses
    # {@code AbstractList}.  The subclass stores, in private fields, the
    # offset of the subList within the backing list, the size of the subList
    # (which can change over its lifetime), and the expected
    # {@code modCount} value of the backing list.  There are two variants
    # of the subclass, one of which implements {@code RandomAccess}.
    # If this list implements {@code RandomAccess} the returned list will
    # be an instance of the subclass that implements {@code RandomAccess}.
    # 
    # <p>The subclass's {@code set(int, E)}, {@code get(int)},
    # {@code add(int, E)}, {@code remove(int)}, {@code addAll(int,
    # Collection)} and {@code removeRange(int, int)} methods all
    # delegate to the corresponding methods on the backing abstract list,
    # after bounds-checking the index and adjusting for the offset.  The
    # {@code addAll(Collection c)} method merely returns {@code addAll(size,
    # c)}.
    # 
    # <p>The {@code listIterator(int)} method returns a "wrapper object"
    # over a list iterator on the backing list, which is created with the
    # corresponding method on the backing list.  The {@code iterator} method
    # merely returns {@code listIterator()}, and the {@code size} method
    # merely returns the subclass's {@code size} field.
    # 
    # <p>All methods first check to see if the actual {@code modCount} of
    # the backing list is equal to its expected value, and throw a
    # {@code ConcurrentModificationException} if it is not.
    # 
    # @throws IndexOutOfBoundsException if an endpoint index value is out of range
    # {@code (fromIndex < 0 || toIndex > size)}
    # @throws IllegalArgumentException if the endpoint indices are out of order
    # {@code (fromIndex > toIndex)}
    def sub_list(from_index, to_index)
      return (self.is_a?(RandomAccess) ? RandomAccessSubList.new(self, from_index, to_index) : SubList.new(self, from_index, to_index))
    end
    
    typesig { [Object] }
    # Comparison and hashing
    # 
    # Compares the specified object with this list for equality.  Returns
    # {@code true} if and only if the specified object is also a list, both
    # lists have the same size, and all corresponding pairs of elements in
    # the two lists are <i>equal</i>.  (Two elements {@code e1} and
    # {@code e2} are <i>equal</i> if {@code (e1==null ? e2==null :
    # e1.equals(e2))}.)  In other words, two lists are defined to be
    # equal if they contain the same elements in the same order.<p>
    # 
    # This implementation first checks if the specified object is this
    # list. If so, it returns {@code true}; if not, it checks if the
    # specified object is a list. If not, it returns {@code false}; if so,
    # it iterates over both lists, comparing corresponding pairs of elements.
    # If any comparison returns {@code false}, this method returns
    # {@code false}.  If either iterator runs out of elements before the
    # other it returns {@code false} (as the lists are of unequal length);
    # otherwise it returns {@code true} when the iterations complete.
    # 
    # @param o the object to be compared for equality with this list
    # @return {@code true} if the specified object is equal to this list
    def ==(o)
      if ((o).equal?(self))
        return true
      end
      if (!(o.is_a?(JavaList)))
        return false
      end
      e1 = list_iterator
      e2 = (o).list_iterator
      while (e1.has_next && e2.has_next)
        o1 = e1.next_
        o2 = e2.next_
        if (!((o1).nil? ? (o2).nil? : (o1 == o2)))
          return false
        end
      end
      return !(e1.has_next || e2.has_next)
    end
    
    typesig { [] }
    # Returns the hash code value for this list.
    # 
    # <p>This implementation uses exactly the code that is used to define the
    # list hash function in the documentation for the {@link List#hashCode}
    # method.
    # 
    # @return the hash code value for this list
    def hash_code
      hash_code = 1
      self.each do |e|
        hash_code = 31 * hash_code + ((e).nil? ? 0 : e.hash_code)
      end
      return hash_code
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes from this list all of the elements whose index is between
    # {@code fromIndex}, inclusive, and {@code toIndex}, exclusive.
    # Shifts any succeeding elements to the left (reduces their index).
    # This call shortens the list by {@code (toIndex - fromIndex)} elements.
    # (If {@code toIndex==fromIndex}, this operation has no effect.)
    # 
    # <p>This method is called by the {@code clear} operation on this list
    # and its subLists.  Overriding this method to take advantage of
    # the internals of the list implementation can <i>substantially</i>
    # improve the performance of the {@code clear} operation on this list
    # and its subLists.
    # 
    # <p>This implementation gets a list iterator positioned before
    # {@code fromIndex}, and repeatedly calls {@code ListIterator.next}
    # followed by {@code ListIterator.remove} until the entire range has
    # been removed.  <b>Note: if {@code ListIterator.remove} requires linear
    # time, this implementation requires quadratic time.</b>
    # 
    # @param fromIndex index of first element to be removed
    # @param toIndex index after last element to be removed
    def remove_range(from_index, to_index)
      it = list_iterator(from_index)
      i = 0
      n = to_index - from_index
      while i < n
        it.next_
        it.remove
        i += 1
      end
    end
    
    # The number of times this list has been <i>structurally modified</i>.
    # Structural modifications are those that change the size of the
    # list, or otherwise perturb it in such a fashion that iterations in
    # progress may yield incorrect results.
    # 
    # <p>This field is used by the iterator and list iterator implementation
    # returned by the {@code iterator} and {@code listIterator} methods.
    # If the value of this field changes unexpectedly, the iterator (or list
    # iterator) will throw a {@code ConcurrentModificationException} in
    # response to the {@code next}, {@code remove}, {@code previous},
    # {@code set} or {@code add} operations.  This provides
    # <i>fail-fast</i> behavior, rather than non-deterministic behavior in
    # the face of concurrent modification during iteration.
    # 
    # <p><b>Use of this field by subclasses is optional.</b> If a subclass
    # wishes to provide fail-fast iterators (and list iterators), then it
    # merely has to increment this field in its {@code add(int, E)} and
    # {@code remove(int)} methods (and any other methods that it overrides
    # that result in structural modifications to the list).  A single call to
    # {@code add(int, E)} or {@code remove(int)} must add no more than
    # one to this field, or the iterators (and list iterators) will throw
    # bogus {@code ConcurrentModificationExceptions}.  If an implementation
    # does not wish to provide fail-fast iterators, this field may be
    # ignored.
    attr_accessor :mod_count
    alias_method :attr_mod_count, :mod_count
    undef_method :mod_count
    alias_method :attr_mod_count=, :mod_count=
    undef_method :mod_count=
    
    typesig { [::Java::Int] }
    def range_check_for_add(index)
      if (index < 0 || index > size)
        raise IndexOutOfBoundsException.new(out_of_bounds_msg(index))
      end
    end
    
    typesig { [::Java::Int] }
    def out_of_bounds_msg(index)
      return "Index: " + RJava.cast_to_string(index) + ", Size: " + RJava.cast_to_string(size)
    end
    
    private
    alias_method :initialize__abstract_list, :initialize
  end
  
  class SubList < AbstractListImports.const_get :AbstractList
    include_class_members AbstractListImports
    
    attr_accessor :l
    alias_method :attr_l, :l
    undef_method :l
    alias_method :attr_l=, :l=
    undef_method :l=
    
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [AbstractList, ::Java::Int, ::Java::Int] }
    def initialize(list, from_index, to_index)
      @l = nil
      @offset = 0
      @size = 0
      super()
      if (from_index < 0)
        raise IndexOutOfBoundsException.new("fromIndex = " + RJava.cast_to_string(from_index))
      end
      if (to_index > list.size)
        raise IndexOutOfBoundsException.new("toIndex = " + RJava.cast_to_string(to_index))
      end
      if (from_index > to_index)
        raise IllegalArgumentException.new("fromIndex(" + RJava.cast_to_string(from_index) + ") > toIndex(" + RJava.cast_to_string(to_index) + ")")
      end
      @l = list
      @offset = from_index
      @size = to_index - from_index
      self.attr_mod_count = @l.attr_mod_count
    end
    
    typesig { [::Java::Int, Object] }
    def set(index, element)
      range_check(index)
      check_for_comodification
      return @l.set(index + @offset, element)
    end
    
    typesig { [::Java::Int] }
    def get(index)
      range_check(index)
      check_for_comodification
      return @l.get(index + @offset)
    end
    
    typesig { [] }
    def size
      check_for_comodification
      return @size
    end
    
    typesig { [::Java::Int, Object] }
    def add(index, element)
      range_check_for_add(index)
      check_for_comodification
      @l.add(index + @offset, element)
      self.attr_mod_count = @l.attr_mod_count
      @size += 1
    end
    
    typesig { [::Java::Int] }
    def remove(index)
      range_check(index)
      check_for_comodification
      result = @l.remove(index + @offset)
      self.attr_mod_count = @l.attr_mod_count
      @size -= 1
      return result
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def remove_range(from_index, to_index)
      check_for_comodification
      @l.remove_range(from_index + @offset, to_index + @offset)
      self.attr_mod_count = @l.attr_mod_count
      @size -= (to_index - from_index)
    end
    
    typesig { [Collection] }
    def add_all(c)
      return add_all(@size, c)
    end
    
    typesig { [::Java::Int, Collection] }
    def add_all(index, c)
      range_check_for_add(index)
      c_size = c.size
      if ((c_size).equal?(0))
        return false
      end
      check_for_comodification
      @l.add_all(@offset + index, c)
      self.attr_mod_count = @l.attr_mod_count
      @size += c_size
      return true
    end
    
    typesig { [] }
    def iterator
      return list_iterator
    end
    
    typesig { [::Java::Int] }
    def list_iterator(index)
      check_for_comodification
      range_check_for_add(index)
      return Class.new(ListIterator.class == Class ? ListIterator : Object) do
        extend LocalClass
        include_class_members SubList
        include ListIterator if ListIterator.class == Module
        
        attr_accessor :i
        alias_method :attr_i, :i
        undef_method :i
        alias_method :attr_i=, :i=
        undef_method :i=
        
        typesig { [] }
        define_method :has_next do
          return next_index < self.attr_size
        end
        
        typesig { [] }
        define_method :next_ do
          if (has_next)
            return @i.next_
          else
            raise NoSuchElementException.new
          end
        end
        
        typesig { [] }
        define_method :has_previous do
          return previous_index >= 0
        end
        
        typesig { [] }
        define_method :previous do
          if (has_previous)
            return @i.previous
          else
            raise NoSuchElementException.new
          end
        end
        
        typesig { [] }
        define_method :next_index do
          return @i.next_index - self.attr_offset
        end
        
        typesig { [] }
        define_method :previous_index do
          return @i.previous_index - self.attr_offset
        end
        
        typesig { [] }
        define_method :remove do
          @i.remove
          @local_class_parent.attr_mod_count = self.attr_l.attr_mod_count
          self.attr_size -= 1
        end
        
        typesig { [Object] }
        define_method :set do |e|
          @i.set(e)
        end
        
        typesig { [Object] }
        define_method :add do |e|
          @i.add(e)
          @local_class_parent.attr_mod_count = self.attr_l.attr_mod_count
          self.attr_size += 1
        end
        
        typesig { [] }
        define_method :initialize do
          @i = nil
          super()
          @i = self.attr_l.list_iterator(index + self.attr_offset)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def sub_list(from_index, to_index)
      return SubList.new(self, from_index, to_index)
    end
    
    typesig { [::Java::Int] }
    def range_check(index)
      if (index < 0 || index >= @size)
        raise IndexOutOfBoundsException.new(out_of_bounds_msg(index))
      end
    end
    
    typesig { [::Java::Int] }
    def range_check_for_add(index)
      if (index < 0 || index > @size)
        raise IndexOutOfBoundsException.new(out_of_bounds_msg(index))
      end
    end
    
    typesig { [::Java::Int] }
    def out_of_bounds_msg(index)
      return "Index: " + RJava.cast_to_string(index) + ", Size: " + RJava.cast_to_string(@size)
    end
    
    typesig { [] }
    def check_for_comodification
      if (!(self.attr_mod_count).equal?(@l.attr_mod_count))
        raise ConcurrentModificationException.new
      end
    end
    
    private
    alias_method :initialize__sub_list, :initialize
  end
  
  class RandomAccessSubList < AbstractListImports.const_get :SubList
    include_class_members AbstractListImports
    overload_protected {
      include RandomAccess
    }
    
    typesig { [AbstractList, ::Java::Int, ::Java::Int] }
    def initialize(list, from_index, to_index)
      super(list, from_index, to_index)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def sub_list(from_index, to_index)
      return RandomAccessSubList.new(self, from_index, to_index)
    end
    
    private
    alias_method :initialize__random_access_sub_list, :initialize
  end
  
end
