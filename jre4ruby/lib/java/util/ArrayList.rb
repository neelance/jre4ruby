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
  module ArrayListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Resizable-array implementation of the <tt>List</tt> interface.  Implements
  # all optional list operations, and permits all elements, including
  # <tt>null</tt>.  In addition to implementing the <tt>List</tt> interface,
  # this class provides methods to manipulate the size of the array that is
  # used internally to store the list.  (This class is roughly equivalent to
  # <tt>Vector</tt>, except that it is unsynchronized.)
  # 
  # <p>The <tt>size</tt>, <tt>isEmpty</tt>, <tt>get</tt>, <tt>set</tt>,
  # <tt>iterator</tt>, and <tt>listIterator</tt> operations run in constant
  # time.  The <tt>add</tt> operation runs in <i>amortized constant time</i>,
  # that is, adding n elements requires O(n) time.  All of the other operations
  # run in linear time (roughly speaking).  The constant factor is low compared
  # to that for the <tt>LinkedList</tt> implementation.
  # 
  # <p>Each <tt>ArrayList</tt> instance has a <i>capacity</i>.  The capacity is
  # the size of the array used to store the elements in the list.  It is always
  # at least as large as the list size.  As elements are added to an ArrayList,
  # its capacity grows automatically.  The details of the growth policy are not
  # specified beyond the fact that adding an element has constant amortized
  # time cost.
  # 
  # <p>An application can increase the capacity of an <tt>ArrayList</tt> instance
  # before adding a large number of elements using the <tt>ensureCapacity</tt>
  # operation.  This may reduce the amount of incremental reallocation.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access an <tt>ArrayList</tt> instance concurrently,
  # and at least one of the threads modifies the list structurally, it
  # <i>must</i> be synchronized externally.  (A structural modification is
  # any operation that adds or deletes one or more elements, or explicitly
  # resizes the backing array; merely setting the value of an element is not
  # a structural modification.)  This is typically accomplished by
  # synchronizing on some object that naturally encapsulates the list.
  # 
  # If no such object exists, the list should be "wrapped" using the
  # {@link Collections#synchronizedList Collections.synchronizedList}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the list:<pre>
  # List list = Collections.synchronizedList(new ArrayList(...));</pre>
  # 
  # <p><a name="fail-fast"/>
  # The iterators returned by this class's {@link #iterator() iterator} and
  # {@link #listIterator(int) listIterator} methods are <em>fail-fast</em>:
  # if the list is structurally modified at any time after the iterator is
  # created, in any way except through the iterator's own
  # {@link ListIterator#remove() remove} or
  # {@link ListIterator#add(Object) add} methods, the iterator will throw a
  # {@link ConcurrentModificationException}.  Thus, in the face of
  # concurrent modification, the iterator fails quickly and cleanly, rather
  # than risking arbitrary, non-deterministic behavior at an undetermined
  # time in the future.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw {@code ConcurrentModificationException} on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness:  <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see     Collection
  # @see     List
  # @see     LinkedList
  # @see     Vector
  # @since   1.2
  class ArrayList < ArrayListImports.const_get :AbstractList
    include_class_members ArrayListImports
    include JavaList
    include RandomAccess
    include Cloneable
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 8683452581122892189 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The array buffer into which the elements of the ArrayList are stored.
    # The capacity of the ArrayList is the length of this array buffer.
    attr_accessor :element_data
    alias_method :attr_element_data, :element_data
    undef_method :element_data
    alias_method :attr_element_data=, :element_data=
    undef_method :element_data=
    
    # The size of the ArrayList (the number of elements it contains).
    # 
    # @serial
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [::Java::Int] }
    # Constructs an empty list with the specified initial capacity.
    # 
    # @param   initialCapacity   the initial capacity of the list
    # @exception IllegalArgumentException if the specified initial capacity
    # is negative
    def initialize(initial_capacity)
      @element_data = nil
      @size = 0
      super()
      if (initial_capacity < 0)
        raise IllegalArgumentException.new("Illegal Capacity: " + (initial_capacity).to_s)
      end
      @element_data = Array.typed(Object).new(initial_capacity) { nil }
    end
    
    typesig { [] }
    # Constructs an empty list with an initial capacity of ten.
    def initialize
      initialize__array_list(10)
    end
    
    typesig { [Collection] }
    # Constructs a list containing the elements of the specified
    # collection, in the order they are returned by the collection's
    # iterator.
    # 
    # @param c the collection whose elements are to be placed into this list
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      @element_data = nil
      @size = 0
      super()
      @element_data = c.to_array
      @size = @element_data.attr_length
      # c.toArray might (incorrectly) not return Object[] (see 6260652)
      if (!(@element_data.get_class).equal?(Array[]))
        @element_data = Arrays.copy_of(@element_data, @size, Array[])
      end
    end
    
    typesig { [] }
    # Trims the capacity of this <tt>ArrayList</tt> instance to be the
    # list's current size.  An application can use this operation to minimize
    # the storage of an <tt>ArrayList</tt> instance.
    def trim_to_size
      ((self.attr_mod_count += 1) - 1)
      old_capacity = @element_data.attr_length
      if (@size < old_capacity)
        @element_data = Arrays.copy_of(@element_data, @size)
      end
    end
    
    typesig { [::Java::Int] }
    # Increases the capacity of this <tt>ArrayList</tt> instance, if
    # necessary, to ensure that it can hold at least the number of elements
    # specified by the minimum capacity argument.
    # 
    # @param   minCapacity   the desired minimum capacity
    def ensure_capacity(min_capacity)
      ((self.attr_mod_count += 1) - 1)
      old_capacity = @element_data.attr_length
      if (min_capacity > old_capacity)
        old_data = @element_data
        new_capacity = (old_capacity * 3) / 2 + 1
        if (new_capacity < min_capacity)
          new_capacity = min_capacity
        end
        # minCapacity is usually close to size, so this is a win:
        @element_data = Arrays.copy_of(@element_data, new_capacity)
      end
    end
    
    typesig { [] }
    # Returns the number of elements in this list.
    # 
    # @return the number of elements in this list
    def size
      return @size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this list contains no elements.
    # 
    # @return <tt>true</tt> if this list contains no elements
    def is_empty
      return (@size).equal?(0)
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this list contains the specified element.
    # More formally, returns <tt>true</tt> if and only if this list contains
    # at least one element <tt>e</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>.
    # 
    # @param o element whose presence in this list is to be tested
    # @return <tt>true</tt> if this list contains the specified element
    def contains(o)
      return index_of(o) >= 0
    end
    
    typesig { [Object] }
    # Returns the index of the first occurrence of the specified element
    # in this list, or -1 if this list does not contain the element.
    # More formally, returns the lowest index <tt>i</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>,
    # or -1 if there is no such index.
    def index_of(o)
      if ((o).nil?)
        i = 0
        while i < @size
          if ((@element_data[i]).nil?)
            return i
          end
          ((i += 1) - 1)
        end
      else
        i = 0
        while i < @size
          if ((o == @element_data[i]))
            return i
          end
          ((i += 1) - 1)
        end
      end
      return -1
    end
    
    typesig { [Object] }
    # Returns the index of the last occurrence of the specified element
    # in this list, or -1 if this list does not contain the element.
    # More formally, returns the highest index <tt>i</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>,
    # or -1 if there is no such index.
    def last_index_of(o)
      if ((o).nil?)
        i = @size - 1
        while i >= 0
          if ((@element_data[i]).nil?)
            return i
          end
          ((i -= 1) + 1)
        end
      else
        i = @size - 1
        while i >= 0
          if ((o == @element_data[i]))
            return i
          end
          ((i -= 1) + 1)
        end
      end
      return -1
    end
    
    typesig { [] }
    # Returns a shallow copy of this <tt>ArrayList</tt> instance.  (The
    # elements themselves are not copied.)
    # 
    # @return a clone of this <tt>ArrayList</tt> instance
    def clone
      begin
        v = super
        v.attr_element_data = Arrays.copy_of(@element_data, @size)
        v.attr_mod_count = 0
        return v
      rescue CloneNotSupportedException => e
        # this shouldn't happen, since we are Cloneable
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this list
    # in proper sequence (from first to last element).
    # 
    # <p>The returned array will be "safe" in that no references to it are
    # maintained by this list.  (In other words, this method must allocate
    # a new array).  The caller is thus free to modify the returned array.
    # 
    # <p>This method acts as bridge between array-based and collection-based
    # APIs.
    # 
    # @return an array containing all of the elements in this list in
    # proper sequence
    def to_array
      return Arrays.copy_of(@element_data, @size)
    end
    
    typesig { [Array.typed(T)] }
    # Returns an array containing all of the elements in this list in proper
    # sequence (from first to last element); the runtime type of the returned
    # array is that of the specified array.  If the list fits in the
    # specified array, it is returned therein.  Otherwise, a new array is
    # allocated with the runtime type of the specified array and the size of
    # this list.
    # 
    # <p>If the list fits in the specified array with room to spare
    # (i.e., the array has more elements than the list), the element in
    # the array immediately following the end of the collection is set to
    # <tt>null</tt>.  (This is useful in determining the length of the
    # list <i>only</i> if the caller knows that the list does not contain
    # any null elements.)
    # 
    # @param a the array into which the elements of the list are to
    # be stored, if it is big enough; otherwise, a new array of the
    # same runtime type is allocated for this purpose.
    # @return an array containing the elements of the list
    # @throws ArrayStoreException if the runtime type of the specified array
    # is not a supertype of the runtime type of every element in
    # this list
    # @throws NullPointerException if the specified array is null
    def to_array(a)
      if (a.attr_length < @size)
        # Make a new array of a's runtime type, but my contents:
        return Arrays.copy_of(@element_data, @size, a.get_class)
      end
      System.arraycopy(@element_data, 0, a, 0, @size)
      if (a.attr_length > @size)
        a[@size] = nil
      end
      return a
    end
    
    typesig { [::Java::Int] }
    # Positional Access Operations
    def element_data(index)
      return @element_data[index]
    end
    
    typesig { [::Java::Int] }
    # Returns the element at the specified position in this list.
    # 
    # @param  index index of the element to return
    # @return the element at the specified position in this list
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def get(index)
      range_check(index)
      return element_data(index)
    end
    
    typesig { [::Java::Int, Object] }
    # Replaces the element at the specified position in this list with
    # the specified element.
    # 
    # @param index index of the element to replace
    # @param element element to be stored at the specified position
    # @return the element previously at the specified position
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def set(index, element)
      range_check(index)
      old_value = element_data(index)
      @element_data[index] = element
      return old_value
    end
    
    typesig { [Object] }
    # Appends the specified element to the end of this list.
    # 
    # @param e element to be appended to this list
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    def add(e)
      ensure_capacity(@size + 1) # Increments modCount!!
      @element_data[((@size += 1) - 1)] = e
      return true
    end
    
    typesig { [::Java::Int, Object] }
    # Inserts the specified element at the specified position in this
    # list. Shifts the element currently at that position (if any) and
    # any subsequent elements to the right (adds one to their indices).
    # 
    # @param index index at which the specified element is to be inserted
    # @param element element to be inserted
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def add(index, element)
      range_check_for_add(index)
      ensure_capacity(@size + 1) # Increments modCount!!
      System.arraycopy(@element_data, index, @element_data, index + 1, @size - index)
      @element_data[index] = element
      ((@size += 1) - 1)
    end
    
    typesig { [::Java::Int] }
    # Removes the element at the specified position in this list.
    # Shifts any subsequent elements to the left (subtracts one from their
    # indices).
    # 
    # @param index the index of the element to be removed
    # @return the element that was removed from the list
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def remove(index)
      range_check(index)
      ((self.attr_mod_count += 1) - 1)
      old_value = element_data(index)
      num_moved = @size - index - 1
      if (num_moved > 0)
        System.arraycopy(@element_data, index + 1, @element_data, index, num_moved)
      end
      @element_data[(@size -= 1)] = nil # Let gc do its work
      return old_value
    end
    
    typesig { [Object] }
    # Removes the first occurrence of the specified element from this list,
    # if it is present.  If the list does not contain the element, it is
    # unchanged.  More formally, removes the element with the lowest index
    # <tt>i</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>
    # (if such an element exists).  Returns <tt>true</tt> if this list
    # contained the specified element (or equivalently, if this list
    # changed as a result of the call).
    # 
    # @param o element to be removed from this list, if present
    # @return <tt>true</tt> if this list contained the specified element
    def remove(o)
      if ((o).nil?)
        index = 0
        while index < @size
          if ((@element_data[index]).nil?)
            fast_remove(index)
            return true
          end
          ((index += 1) - 1)
        end
      else
        index = 0
        while index < @size
          if ((o == @element_data[index]))
            fast_remove(index)
            return true
          end
          ((index += 1) - 1)
        end
      end
      return false
    end
    
    typesig { [::Java::Int] }
    # Private remove method that skips bounds checking and does not
    # return the value removed.
    def fast_remove(index)
      ((self.attr_mod_count += 1) - 1)
      num_moved = @size - index - 1
      if (num_moved > 0)
        System.arraycopy(@element_data, index + 1, @element_data, index, num_moved)
      end
      @element_data[(@size -= 1)] = nil # Let gc do its work
    end
    
    typesig { [] }
    # Removes all of the elements from this list.  The list will
    # be empty after this call returns.
    def clear
      ((self.attr_mod_count += 1) - 1)
      # Let gc do its work
      i = 0
      while i < @size
        @element_data[i] = nil
        ((i += 1) - 1)
      end
      @size = 0
    end
    
    typesig { [Collection] }
    # Appends all of the elements in the specified collection to the end of
    # this list, in the order that they are returned by the
    # specified collection's Iterator.  The behavior of this operation is
    # undefined if the specified collection is modified while the operation
    # is in progress.  (This implies that the behavior of this call is
    # undefined if the specified collection is this list, and this
    # list is nonempty.)
    # 
    # @param c collection containing elements to be added to this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    def add_all(c)
      a = c.to_array
      num_new = a.attr_length
      ensure_capacity(@size + num_new) # Increments modCount
      System.arraycopy(a, 0, @element_data, @size, num_new)
      @size += num_new
      return !(num_new).equal?(0)
    end
    
    typesig { [::Java::Int, Collection] }
    # Inserts all of the elements in the specified collection into this
    # list, starting at the specified position.  Shifts the element
    # currently at that position (if any) and any subsequent elements to
    # the right (increases their indices).  The new elements will appear
    # in the list in the order that they are returned by the
    # specified collection's iterator.
    # 
    # @param index index at which to insert the first element from the
    # specified collection
    # @param c collection containing elements to be added to this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @throws NullPointerException if the specified collection is null
    def add_all(index, c)
      range_check_for_add(index)
      a = c.to_array
      num_new = a.attr_length
      ensure_capacity(@size + num_new) # Increments modCount
      num_moved = @size - index
      if (num_moved > 0)
        System.arraycopy(@element_data, index, @element_data, index + num_new, num_moved)
      end
      System.arraycopy(a, 0, @element_data, index, num_new)
      @size += num_new
      return !(num_new).equal?(0)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes from this list all of the elements whose index is between
    # {@code fromIndex}, inclusive, and {@code toIndex}, exclusive.
    # Shifts any succeeding elements to the left (reduces their index).
    # This call shortens the list by {@code (toIndex - fromIndex)} elements.
    # (If {@code toIndex==fromIndex}, this operation has no effect.)
    # 
    # @throws IndexOutOfBoundsException if {@code fromIndex} or
    # {@code toIndex} is out of range
    # ({@code fromIndex < 0 ||
    # fromIndex >= size() ||
    # toIndex > size() ||
    # toIndex < fromIndex})
    def remove_range(from_index, to_index)
      ((self.attr_mod_count += 1) - 1)
      num_moved = @size - to_index
      System.arraycopy(@element_data, to_index, @element_data, from_index, num_moved)
      # Let gc do its work
      new_size = @size - (to_index - from_index)
      while (!(@size).equal?(new_size))
        @element_data[(@size -= 1)] = nil
      end
    end
    
    typesig { [::Java::Int] }
    # Checks if the given index is in range.  If not, throws an appropriate
    # runtime exception.  This method does *not* check if the index is
    # negative: It is always used immediately prior to an array access,
    # which throws an ArrayIndexOutOfBoundsException if index is negative.
    def range_check(index)
      if (index >= @size)
        raise IndexOutOfBoundsException.new(out_of_bounds_msg(index))
      end
    end
    
    typesig { [::Java::Int] }
    # A version of rangeCheck used by add and addAll.
    def range_check_for_add(index)
      if (index > @size || index < 0)
        raise IndexOutOfBoundsException.new(out_of_bounds_msg(index))
      end
    end
    
    typesig { [::Java::Int] }
    # Constructs an IndexOutOfBoundsException detail message.
    # Of the many possible refactorings of the error handling code,
    # this "outlining" performs best with both server and client VMs.
    def out_of_bounds_msg(index)
      return "Index: " + (index).to_s + ", Size: " + (@size).to_s
    end
    
    typesig { [Collection] }
    # Removes from this list all of its elements that are contained in the
    # specified collection.
    # 
    # @param c collection containing elements to be removed from this list
    # @return {@code true} if this list changed as a result of the call
    # @throws ClassCastException if the class of an element of this list
    # is incompatible with the specified collection (optional)
    # @throws NullPointerException if this list contains a null element and the
    # specified collection does not permit null elements (optional),
    # or if the specified collection is null
    # @see Collection#contains(Object)
    def remove_all(c)
      return batch_remove(c, false)
    end
    
    typesig { [Collection] }
    # Retains only the elements in this list that are contained in the
    # specified collection.  In other words, removes from this list all
    # of its elements that are not contained in the specified collection.
    # 
    # @param c collection containing elements to be retained in this list
    # @return {@code true} if this list changed as a result of the call
    # @throws ClassCastException if the class of an element of this list
    # is incompatible with the specified collection (optional)
    # @throws NullPointerException if this list contains a null element and the
    # specified collection does not permit null elements (optional),
    # or if the specified collection is null
    # @see Collection#contains(Object)
    def retain_all(c)
      return batch_remove(c, true)
    end
    
    typesig { [Collection, ::Java::Boolean] }
    def batch_remove(c, complement)
      element_data_ = @element_data
      r = 0
      w = 0
      modified = false
      begin
        while r < @size
          if ((c.contains(element_data_[r])).equal?(complement))
            element_data_[((w += 1) - 1)] = element_data_[r]
          end
          ((r += 1) - 1)
        end
      ensure
        # Preserve behavioral compatibility with AbstractCollection,
        # even if c.contains() throws.
        if (!(r).equal?(@size))
          System.arraycopy(element_data_, r, element_data_, w, @size - r)
          w += @size - r
        end
        if (!(w).equal?(@size))
          i = w
          while i < @size
            element_data_[i] = nil
            ((i += 1) - 1)
          end
          self.attr_mod_count += @size - w
          @size = w
          modified = true
        end
      end
      return modified
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the <tt>ArrayList</tt> instance to a stream (that
    # is, serialize it).
    # 
    # @serialData The length of the array backing the <tt>ArrayList</tt>
    # instance is emitted (int), followed by all of its elements
    # (each an <tt>Object</tt>) in the proper order.
    def write_object(s)
      # Write out element count, and any hidden stuff
      expected_mod_count = self.attr_mod_count
      s.default_write_object
      # Write out array length
      s.write_int(@element_data.attr_length)
      # Write out all elements in the proper order.
      i = 0
      while i < @size
        s.write_object(@element_data[i])
        ((i += 1) - 1)
      end
      if (!(self.attr_mod_count).equal?(expected_mod_count))
        raise ConcurrentModificationException.new
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the <tt>ArrayList</tt> instance from a stream (that is,
    # deserialize it).
    def read_object(s)
      # Read in size, and any hidden stuff
      s.default_read_object
      # Read in array length and allocate array
      array_length = s.read_int
      a = @element_data = Array.typed(Object).new(array_length) { nil }
      # Read in all elements in the proper order.
      i = 0
      while i < @size
        a[i] = s.read_object
        ((i += 1) - 1)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns a list iterator over the elements in this list (in proper
    # sequence), starting at the specified position in the list.
    # The specified index indicates the first element that would be
    # returned by an initial call to {@link ListIterator#next next}.
    # An initial call to {@link ListIterator#previous previous} would
    # return the element with the specified index minus one.
    # 
    # <p>The returned list iterator is <a href="#fail-fast"><i>fail-fast</i></a>.
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def list_iterator(index)
      if (index < 0 || index > @size)
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s)
      end
      return ListItr.new_local(self, index)
    end
    
    typesig { [] }
    # Returns a list iterator over the elements in this list (in proper
    # sequence).
    # 
    # <p>The returned list iterator is <a href="#fail-fast"><i>fail-fast</i></a>.
    # 
    # @see #listIterator(int)
    def list_iterator
      return ListItr.new_local(self, 0)
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this list in proper sequence.
    # 
    # <p>The returned iterator is <a href="#fail-fast"><i>fail-fast</i></a>.
    # 
    # @return an iterator over the elements in this list in proper sequence
    def iterator
      return Itr.new_local(self)
    end
    
    class_module.module_eval {
      # An optimized version of AbstractList.Itr
      const_set_lazy(:Itr) { Class.new do
        extend LocalClass
        include_class_members ArrayList
        include Iterator
        
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        # index of next element to return
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        # index of last element returned; -1 if no such
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        typesig { [] }
        def has_next
          return !(@cursor).equal?(self.attr_size)
        end
        
        typesig { [] }
        def next
          check_for_comodification
          i = @cursor
          if (i >= self.attr_size)
            raise NoSuchElementException.new
          end
          element_data = @local_class_parent.attr_element_data
          if (i >= element_data.attr_length)
            raise ConcurrentModificationException.new
          end
          @cursor = i + 1
          return element_data[@last_ret = i]
        end
        
        typesig { [] }
        def remove
          if (@last_ret < 0)
            raise IllegalStateException.new
          end
          check_for_comodification
          begin
            @local_class_parent.remove(@last_ret)
            @cursor = @last_ret
            @last_ret = -1
            @expected_mod_count = self.attr_mod_count
          rescue IndexOutOfBoundsException => ex
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
      
      # An optimized version of AbstractList.ListItr
      const_set_lazy(:ListItr) { Class.new(Itr) do
        extend LocalClass
        include_class_members ArrayList
        include ListIterator
        
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
        def next_index
          return self.attr_cursor
        end
        
        typesig { [] }
        def previous_index
          return self.attr_cursor - 1
        end
        
        typesig { [] }
        def previous
          check_for_comodification
          i = self.attr_cursor - 1
          if (i < 0)
            raise NoSuchElementException.new
          end
          element_data = @local_class_parent.attr_element_data
          if (i >= element_data.attr_length)
            raise ConcurrentModificationException.new
          end
          self.attr_cursor = i
          return element_data[self.attr_last_ret = i]
        end
        
        typesig { [E] }
        def set(e)
          if (self.attr_last_ret < 0)
            raise IllegalStateException.new
          end
          check_for_comodification
          begin
            @local_class_parent.set(self.attr_last_ret, e)
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
            self.attr_cursor = i + 1
            self.attr_last_ret = -1
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
    # Returns a view of the portion of this list between the specified
    # {@code fromIndex}, inclusive, and {@code toIndex}, exclusive.  (If
    # {@code fromIndex} and {@code toIndex} are equal, the returned list is
    # empty.)  The returned list is backed by this list, so non-structural
    # changes in the returned list are reflected in this list, and vice-versa.
    # The returned list supports all of the optional list operations.
    # 
    # <p>This method eliminates the need for explicit range operations (of
    # the sort that commonly exist for arrays).  Any operation that expects
    # a list can be used as a range operation by passing a subList view
    # instead of a whole list.  For example, the following idiom
    # removes a range of elements from a list:
    # <pre>
    # list.subList(from, to).clear();
    # </pre>
    # Similar idioms may be constructed for {@link #indexOf(Object)} and
    # {@link #lastIndexOf(Object)}, and all of the algorithms in the
    # {@link Collections} class can be applied to a subList.
    # 
    # <p>The semantics of the list returned by this method become undefined if
    # the backing list (i.e., this list) is <i>structurally modified</i> in
    # any way other than via the returned list.  (Structural modifications are
    # those that change the size of this list, or otherwise perturb it in such
    # a fashion that iterations in progress may yield incorrect results.)
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_list(from_index, to_index)
      sub_list_range_check(from_index, to_index, @size)
      return SubList.new_local(self, self, 0, from_index, to_index)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      def sub_list_range_check(from_index, to_index, size)
        if (from_index < 0)
          raise IndexOutOfBoundsException.new("fromIndex = " + (from_index).to_s)
        end
        if (to_index > size)
          raise IndexOutOfBoundsException.new("toIndex = " + (to_index).to_s)
        end
        if (from_index > to_index)
          raise IllegalArgumentException.new("fromIndex(" + (from_index).to_s + ") > toIndex(" + (to_index).to_s + ")")
        end
      end
      
      const_set_lazy(:SubList) { Class.new(AbstractList) do
        extend LocalClass
        include_class_members ArrayList
        include RandomAccess
        
        attr_accessor :parent
        alias_method :attr_parent, :parent
        undef_method :parent
        alias_method :attr_parent=, :parent=
        undef_method :parent=
        
        attr_accessor :parent_offset
        alias_method :attr_parent_offset, :parent_offset
        undef_method :parent_offset
        alias_method :attr_parent_offset=, :parent_offset=
        undef_method :parent_offset=
        
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
        
        typesig { [AbstractList, ::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(parent, offset, from_index, to_index)
          @parent = nil
          @parent_offset = 0
          @offset = 0
          @size = 0
          super()
          @parent = parent
          @parent_offset = from_index
          @offset = offset + from_index
          @size = to_index - from_index
          self.attr_mod_count = @local_class_parent.attr_mod_count
        end
        
        typesig { [::Java::Int, E] }
        def set(index, e)
          range_check(index)
          check_for_comodification
          old_value = @local_class_parent.element_data(@offset + index)
          @local_class_parent.attr_element_data[@offset + index] = e
          return old_value
        end
        
        typesig { [::Java::Int] }
        def get(index)
          range_check(index)
          check_for_comodification
          return @local_class_parent.element_data(@offset + index)
        end
        
        typesig { [] }
        def size
          check_for_comodification
          return @size
        end
        
        typesig { [::Java::Int, E] }
        def add(index, e)
          range_check_for_add(index)
          check_for_comodification
          @parent.add(@parent_offset + index, e)
          self.attr_mod_count = @parent.attr_mod_count
          ((@size += 1) - 1)
        end
        
        typesig { [::Java::Int] }
        def remove(index)
          range_check(index)
          check_for_comodification
          result = @parent.remove(@parent_offset + index)
          self.attr_mod_count = @parent.attr_mod_count
          ((@size -= 1) + 1)
          return result
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def remove_range(from_index, to_index)
          check_for_comodification
          @parent.remove_range(@parent_offset + from_index, @parent_offset + to_index)
          self.attr_mod_count = @parent.attr_mod_count
          @size -= to_index - from_index
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
          @parent.add_all(@parent_offset + index, c)
          self.attr_mod_count = @parent.attr_mod_count
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
            
            attr_accessor :cursor
            alias_method :attr_cursor, :cursor
            undef_method :cursor
            alias_method :attr_cursor=, :cursor=
            undef_method :cursor=
            
            attr_accessor :last_ret
            alias_method :attr_last_ret, :last_ret
            undef_method :last_ret
            alias_method :attr_last_ret=, :last_ret=
            undef_method :last_ret=
            
            attr_accessor :expected_mod_count
            alias_method :attr_expected_mod_count, :expected_mod_count
            undef_method :expected_mod_count
            alias_method :attr_expected_mod_count=, :expected_mod_count=
            undef_method :expected_mod_count=
            
            typesig { [] }
            define_method :has_next do
              return !(@cursor).equal?(@local_class_parent.attr_size)
            end
            
            typesig { [] }
            define_method :next do
              check_for_comodification
              i = @cursor
              if (i >= @local_class_parent.attr_size)
                raise NoSuchElementException.new
              end
              element_data = @local_class_parent.local_class_parent.attr_element_data
              if (self.attr_offset + i >= element_data.attr_length)
                raise ConcurrentModificationException.new
              end
              @cursor = i + 1
              return element_data[self.attr_offset + (@last_ret = i)]
            end
            
            typesig { [] }
            define_method :has_previous do
              return !(@cursor).equal?(0)
            end
            
            typesig { [] }
            define_method :previous do
              check_for_comodification
              i = @cursor - 1
              if (i < 0)
                raise NoSuchElementException.new
              end
              element_data = @local_class_parent.local_class_parent.attr_element_data
              if (self.attr_offset + i >= element_data.attr_length)
                raise ConcurrentModificationException.new
              end
              @cursor = i
              return element_data[self.attr_offset + (@last_ret = i)]
            end
            
            typesig { [] }
            define_method :next_index do
              return @cursor
            end
            
            typesig { [] }
            define_method :previous_index do
              return @cursor - 1
            end
            
            typesig { [] }
            define_method :remove do
              if (@last_ret < 0)
                raise IllegalStateException.new
              end
              check_for_comodification
              begin
                @local_class_parent.remove(@last_ret)
                @cursor = @last_ret
                @last_ret = -1
                @expected_mod_count = @local_class_parent.local_class_parent.attr_mod_count
              rescue IndexOutOfBoundsException => ex
                raise ConcurrentModificationException.new
              end
            end
            
            typesig { [E] }
            define_method :set do |e|
              if (@last_ret < 0)
                raise IllegalStateException.new
              end
              check_for_comodification
              begin
                @local_class_parent.local_class_parent.set(self.attr_offset + @last_ret, e)
              rescue IndexOutOfBoundsException => ex
                raise ConcurrentModificationException.new
              end
            end
            
            typesig { [E] }
            define_method :add do |e|
              check_for_comodification
              begin
                i = @cursor
                @local_class_parent.add(i, e)
                @cursor = i + 1
                @last_ret = -1
                @expected_mod_count = @local_class_parent.local_class_parent.attr_mod_count
              rescue IndexOutOfBoundsException => ex
                raise ConcurrentModificationException.new
              end
            end
            
            typesig { [] }
            define_method :check_for_comodification do
              if (!(@expected_mod_count).equal?(@local_class_parent.local_class_parent.attr_mod_count))
                raise ConcurrentModificationException.new
              end
            end
            
            typesig { [] }
            define_method :initialize do
              @cursor = 0
              @last_ret = 0
              @expected_mod_count = 0
              super()
              @cursor = index
              @last_ret = -1
              @expected_mod_count = @local_class_parent.local_class_parent.attr_mod_count
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          sub_list_range_check(from_index, to_index, @size)
          return SubList.new(self, @offset, from_index, to_index)
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
          return "Index: " + (index).to_s + ", Size: " + (@size).to_s
        end
        
        typesig { [] }
        def check_for_comodification
          if (!(@local_class_parent.attr_mod_count).equal?(self.attr_mod_count))
            raise ConcurrentModificationException.new
          end
        end
        
        private
        alias_method :initialize__sub_list, :initialize
      end }
    }
    
    private
    alias_method :initialize__array_list, :initialize
  end
  
end
