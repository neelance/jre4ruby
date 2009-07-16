require "rjava"

# 
# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LinkedListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # 
  # Linked list implementation of the <tt>List</tt> interface.  Implements all
  # optional list operations, and permits all elements (including
  # <tt>null</tt>).  In addition to implementing the <tt>List</tt> interface,
  # the <tt>LinkedList</tt> class provides uniformly named methods to
  # <tt>get</tt>, <tt>remove</tt> and <tt>insert</tt> an element at the
  # beginning and end of the list.  These operations allow linked lists to be
  # used as a stack, {@linkplain Queue queue}, or {@linkplain Deque
  # double-ended queue}. <p>
  # 
  # The class implements the <tt>Deque</tt> interface, providing
  # first-in-first-out queue operations for <tt>add</tt>,
  # <tt>poll</tt>, along with other stack and deque operations.<p>
  # 
  # All of the operations perform as could be expected for a doubly-linked
  # list.  Operations that index into the list will traverse the list from
  # the beginning or the end, whichever is closer to the specified index.<p>
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access a linked list concurrently, and at least
  # one of the threads modifies the list structurally, it <i>must</i> be
  # synchronized externally.  (A structural modification is any operation
  # that adds or deletes one or more elements; merely setting the value of
  # an element is not a structural modification.)  This is typically
  # accomplished by synchronizing on some object that naturally
  # encapsulates the list.
  # 
  # If no such object exists, the list should be "wrapped" using the
  # {@link Collections#synchronizedList Collections.synchronizedList}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the list:<pre>
  # List list = Collections.synchronizedList(new LinkedList(...));</pre>
  # 
  # <p>The iterators returned by this class's <tt>iterator</tt> and
  # <tt>listIterator</tt> methods are <i>fail-fast</i>: if the list is
  # structurally modified at any time after the iterator is created, in
  # any way except through the Iterator's own <tt>remove</tt> or
  # <tt>add</tt> methods, the iterator will throw a {@link
  # ConcurrentModificationException}.  Thus, in the face of concurrent
  # modification, the iterator fails quickly and cleanly, rather than
  # risking arbitrary, non-deterministic behavior at an undetermined
  # time in the future.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw <tt>ConcurrentModificationException</tt> on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness:   <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @see     List
  # @see     ArrayList
  # @see     Vector
  # @since 1.2
  # @param <E> the type of elements held in this collection
  class LinkedList < LinkedListImports.const_get :AbstractSequentialList
    include_class_members LinkedListImports
    include JavaList
    include Deque
    include Cloneable
    include Java::Io::Serializable
    
    attr_accessor :header
    alias_method :attr_header, :header
    undef_method :header
    alias_method :attr_header=, :header=
    undef_method :header=
    
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [] }
    # 
    # Constructs an empty list.
    def initialize
      @header = nil
      @size = 0
      super()
      @header = Entry.new(nil, nil, nil)
      @size = 0
      @header.attr_next = @header.attr_previous = @header
    end
    
    typesig { [Collection] }
    # 
    # Constructs a list containing the elements of the specified
    # collection, in the order they are returned by the collection's
    # iterator.
    # 
    # @param  c the collection whose elements are to be placed into this list
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      initialize__linked_list()
      add_all(c)
    end
    
    typesig { [] }
    # 
    # Returns the first element in this list.
    # 
    # @return the first element in this list
    # @throws NoSuchElementException if this list is empty
    def get_first
      if ((@size).equal?(0))
        raise NoSuchElementException.new
      end
      return @header.attr_next.attr_element
    end
    
    typesig { [] }
    # 
    # Returns the last element in this list.
    # 
    # @return the last element in this list
    # @throws NoSuchElementException if this list is empty
    def get_last
      if ((@size).equal?(0))
        raise NoSuchElementException.new
      end
      return @header.attr_previous.attr_element
    end
    
    typesig { [] }
    # 
    # Removes and returns the first element from this list.
    # 
    # @return the first element from this list
    # @throws NoSuchElementException if this list is empty
    def remove_first
      return remove(@header.attr_next)
    end
    
    typesig { [] }
    # 
    # Removes and returns the last element from this list.
    # 
    # @return the last element from this list
    # @throws NoSuchElementException if this list is empty
    def remove_last
      return remove(@header.attr_previous)
    end
    
    typesig { [Object] }
    # 
    # Inserts the specified element at the beginning of this list.
    # 
    # @param e the element to add
    def add_first(e)
      add_before(e, @header.attr_next)
    end
    
    typesig { [Object] }
    # 
    # Appends the specified element to the end of this list.
    # 
    # <p>This method is equivalent to {@link #add}.
    # 
    # @param e the element to add
    def add_last(e)
      add_before(e, @header)
    end
    
    typesig { [Object] }
    # 
    # Returns <tt>true</tt> if this list contains the specified element.
    # More formally, returns <tt>true</tt> if and only if this list contains
    # at least one element <tt>e</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>.
    # 
    # @param o element whose presence in this list is to be tested
    # @return <tt>true</tt> if this list contains the specified element
    def contains(o)
      return !(index_of(o)).equal?(-1)
    end
    
    typesig { [] }
    # 
    # Returns the number of elements in this list.
    # 
    # @return the number of elements in this list
    def size
      return @size
    end
    
    typesig { [Object] }
    # 
    # Appends the specified element to the end of this list.
    # 
    # <p>This method is equivalent to {@link #addLast}.
    # 
    # @param e element to be appended to this list
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    def add(e)
      add_before(e, @header)
      return true
    end
    
    typesig { [Object] }
    # 
    # Removes the first occurrence of the specified element from this list,
    # if it is present.  If this list does not contain the element, it is
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
        e = @header.attr_next
        while !(e).equal?(@header)
          if ((e.attr_element).nil?)
            remove(e)
            return true
          end
          e = e.attr_next
        end
      else
        e_ = @header.attr_next
        while !(e_).equal?(@header)
          if ((o == e_.attr_element))
            remove(e_)
            return true
          end
          e_ = e_.attr_next
        end
      end
      return false
    end
    
    typesig { [Collection] }
    # 
    # Appends all of the elements in the specified collection to the end of
    # this list, in the order that they are returned by the specified
    # collection's iterator.  The behavior of this operation is undefined if
    # the specified collection is modified while the operation is in
    # progress.  (Note that this will occur if the specified collection is
    # this list, and it's nonempty.)
    # 
    # @param c collection containing elements to be added to this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    def add_all(c)
      return add_all(@size, c)
    end
    
    typesig { [::Java::Int, Collection] }
    # 
    # Inserts all of the elements in the specified collection into this
    # list, starting at the specified position.  Shifts the element
    # currently at that position (if any) and any subsequent elements to
    # the right (increases their indices).  The new elements will appear
    # in the list in the order that they are returned by the
    # specified collection's iterator.
    # 
    # @param index index at which to insert the first element
    # from the specified collection
    # @param c collection containing elements to be added to this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @throws NullPointerException if the specified collection is null
    def add_all(index, c)
      if (index < 0 || index > @size)
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s + ", Size: " + (@size).to_s)
      end
      a = c.to_array
      num_new = a.attr_length
      if ((num_new).equal?(0))
        return false
      end
      ((self.attr_mod_count += 1) - 1)
      successor = ((index).equal?(@size) ? @header : entry(index))
      predecessor = successor.attr_previous
      i = 0
      while i < num_new
        e = Entry.new(a[i], successor, predecessor)
        predecessor.attr_next = e
        predecessor = e
        ((i += 1) - 1)
      end
      successor.attr_previous = predecessor
      @size += num_new
      return true
    end
    
    typesig { [] }
    # 
    # Removes all of the elements from this list.
    def clear
      e = @header.attr_next
      while (!(e).equal?(@header))
        next_ = e.attr_next
        e.attr_next = e.attr_previous = nil
        e.attr_element = nil
        e = next_
      end
      @header.attr_next = @header.attr_previous = @header
      @size = 0
      ((self.attr_mod_count += 1) - 1)
    end
    
    typesig { [::Java::Int] }
    # Positional Access Operations
    # 
    # Returns the element at the specified position in this list.
    # 
    # @param index index of the element to return
    # @return the element at the specified position in this list
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def get(index)
      return entry(index).attr_element
    end
    
    typesig { [::Java::Int, Object] }
    # 
    # Replaces the element at the specified position in this list with the
    # specified element.
    # 
    # @param index index of the element to replace
    # @param element element to be stored at the specified position
    # @return the element previously at the specified position
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def set(index, element)
      e = entry(index)
      old_val = e.attr_element
      e.attr_element = element
      return old_val
    end
    
    typesig { [::Java::Int, Object] }
    # 
    # Inserts the specified element at the specified position in this list.
    # Shifts the element currently at that position (if any) and any
    # subsequent elements to the right (adds one to their indices).
    # 
    # @param index index at which the specified element is to be inserted
    # @param element element to be inserted
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def add(index, element)
      add_before(element, ((index).equal?(@size) ? @header : entry(index)))
    end
    
    typesig { [::Java::Int] }
    # 
    # Removes the element at the specified position in this list.  Shifts any
    # subsequent elements to the left (subtracts one from their indices).
    # Returns the element that was removed from the list.
    # 
    # @param index the index of the element to be removed
    # @return the element previously at the specified position
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def remove(index)
      return remove(entry(index))
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the indexed entry.
    def entry(index)
      if (index < 0 || index >= @size)
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s + ", Size: " + (@size).to_s)
      end
      e = @header
      if (index < (@size >> 1))
        i = 0
        while i <= index
          e = e.attr_next
          ((i += 1) - 1)
        end
      else
        i_ = @size
        while i_ > index
          e = e.attr_previous
          ((i_ -= 1) + 1)
        end
      end
      return e
    end
    
    typesig { [Object] }
    # Search Operations
    # 
    # Returns the index of the first occurrence of the specified element
    # in this list, or -1 if this list does not contain the element.
    # More formally, returns the lowest index <tt>i</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>,
    # or -1 if there is no such index.
    # 
    # @param o element to search for
    # @return the index of the first occurrence of the specified element in
    # this list, or -1 if this list does not contain the element
    def index_of(o)
      index = 0
      if ((o).nil?)
        e = @header.attr_next
        while !(e).equal?(@header)
          if ((e.attr_element).nil?)
            return index
          end
          ((index += 1) - 1)
          e = e.attr_next
        end
      else
        e_ = @header.attr_next
        while !(e_).equal?(@header)
          if ((o == e_.attr_element))
            return index
          end
          ((index += 1) - 1)
          e_ = e_.attr_next
        end
      end
      return -1
    end
    
    typesig { [Object] }
    # 
    # Returns the index of the last occurrence of the specified element
    # in this list, or -1 if this list does not contain the element.
    # More formally, returns the highest index <tt>i</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>,
    # or -1 if there is no such index.
    # 
    # @param o element to search for
    # @return the index of the last occurrence of the specified element in
    # this list, or -1 if this list does not contain the element
    def last_index_of(o)
      index = @size
      if ((o).nil?)
        e = @header.attr_previous
        while !(e).equal?(@header)
          ((index -= 1) + 1)
          if ((e.attr_element).nil?)
            return index
          end
          e = e.attr_previous
        end
      else
        e_ = @header.attr_previous
        while !(e_).equal?(@header)
          ((index -= 1) + 1)
          if ((o == e_.attr_element))
            return index
          end
          e_ = e_.attr_previous
        end
      end
      return -1
    end
    
    typesig { [] }
    # Queue operations.
    # 
    # Retrieves, but does not remove, the head (first element) of this list.
    # @return the head of this list, or <tt>null</tt> if this list is empty
    # @since 1.5
    def peek
      if ((@size).equal?(0))
        return nil
      end
      return get_first
    end
    
    typesig { [] }
    # 
    # Retrieves, but does not remove, the head (first element) of this list.
    # @return the head of this list
    # @throws NoSuchElementException if this list is empty
    # @since 1.5
    def element
      return get_first
    end
    
    typesig { [] }
    # 
    # Retrieves and removes the head (first element) of this list
    # @return the head of this list, or <tt>null</tt> if this list is empty
    # @since 1.5
    def poll
      if ((@size).equal?(0))
        return nil
      end
      return remove_first
    end
    
    typesig { [] }
    # 
    # Retrieves and removes the head (first element) of this list.
    # 
    # @return the head of this list
    # @throws NoSuchElementException if this list is empty
    # @since 1.5
    def remove
      return remove_first
    end
    
    typesig { [Object] }
    # 
    # Adds the specified element as the tail (last element) of this list.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Queue#offer})
    # @since 1.5
    def offer(e)
      return add(e)
    end
    
    typesig { [Object] }
    # Deque operations
    # 
    # Inserts the specified element at the front of this list.
    # 
    # @param e the element to insert
    # @return <tt>true</tt> (as specified by {@link Deque#offerFirst})
    # @since 1.6
    def offer_first(e)
      add_first(e)
      return true
    end
    
    typesig { [Object] }
    # 
    # Inserts the specified element at the end of this list.
    # 
    # @param e the element to insert
    # @return <tt>true</tt> (as specified by {@link Deque#offerLast})
    # @since 1.6
    def offer_last(e)
      add_last(e)
      return true
    end
    
    typesig { [] }
    # 
    # Retrieves, but does not remove, the first element of this list,
    # or returns <tt>null</tt> if this list is empty.
    # 
    # @return the first element of this list, or <tt>null</tt>
    # if this list is empty
    # @since 1.6
    def peek_first
      if ((@size).equal?(0))
        return nil
      end
      return get_first
    end
    
    typesig { [] }
    # 
    # Retrieves, but does not remove, the last element of this list,
    # or returns <tt>null</tt> if this list is empty.
    # 
    # @return the last element of this list, or <tt>null</tt>
    # if this list is empty
    # @since 1.6
    def peek_last
      if ((@size).equal?(0))
        return nil
      end
      return get_last
    end
    
    typesig { [] }
    # 
    # Retrieves and removes the first element of this list,
    # or returns <tt>null</tt> if this list is empty.
    # 
    # @return the first element of this list, or <tt>null</tt> if
    # this list is empty
    # @since 1.6
    def poll_first
      if ((@size).equal?(0))
        return nil
      end
      return remove_first
    end
    
    typesig { [] }
    # 
    # Retrieves and removes the last element of this list,
    # or returns <tt>null</tt> if this list is empty.
    # 
    # @return the last element of this list, or <tt>null</tt> if
    # this list is empty
    # @since 1.6
    def poll_last
      if ((@size).equal?(0))
        return nil
      end
      return remove_last
    end
    
    typesig { [Object] }
    # 
    # Pushes an element onto the stack represented by this list.  In other
    # words, inserts the element at the front of this list.
    # 
    # <p>This method is equivalent to {@link #addFirst}.
    # 
    # @param e the element to push
    # @since 1.6
    def push(e)
      add_first(e)
    end
    
    typesig { [] }
    # 
    # Pops an element from the stack represented by this list.  In other
    # words, removes and returns the first element of this list.
    # 
    # <p>This method is equivalent to {@link #removeFirst()}.
    # 
    # @return the element at the front of this list (which is the top
    # of the stack represented by this list)
    # @throws NoSuchElementException if this list is empty
    # @since 1.6
    def pop
      return remove_first
    end
    
    typesig { [Object] }
    # 
    # Removes the first occurrence of the specified element in this
    # list (when traversing the list from head to tail).  If the list
    # does not contain the element, it is unchanged.
    # 
    # @param o element to be removed from this list, if present
    # @return <tt>true</tt> if the list contained the specified element
    # @since 1.6
    def remove_first_occurrence(o)
      return remove(o)
    end
    
    typesig { [Object] }
    # 
    # Removes the last occurrence of the specified element in this
    # list (when traversing the list from head to tail).  If the list
    # does not contain the element, it is unchanged.
    # 
    # @param o element to be removed from this list, if present
    # @return <tt>true</tt> if the list contained the specified element
    # @since 1.6
    def remove_last_occurrence(o)
      if ((o).nil?)
        e = @header.attr_previous
        while !(e).equal?(@header)
          if ((e.attr_element).nil?)
            remove(e)
            return true
          end
          e = e.attr_previous
        end
      else
        e_ = @header.attr_previous
        while !(e_).equal?(@header)
          if ((o == e_.attr_element))
            remove(e_)
            return true
          end
          e_ = e_.attr_previous
        end
      end
      return false
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns a list-iterator of the elements in this list (in proper
    # sequence), starting at the specified position in the list.
    # Obeys the general contract of <tt>List.listIterator(int)</tt>.<p>
    # 
    # The list-iterator is <i>fail-fast</i>: if the list is structurally
    # modified at any time after the Iterator is created, in any way except
    # through the list-iterator's own <tt>remove</tt> or <tt>add</tt>
    # methods, the list-iterator will throw a
    # <tt>ConcurrentModificationException</tt>.  Thus, in the face of
    # concurrent modification, the iterator fails quickly and cleanly, rather
    # than risking arbitrary, non-deterministic behavior at an undetermined
    # time in the future.
    # 
    # @param index index of the first element to be returned from the
    # list-iterator (by a call to <tt>next</tt>)
    # @return a ListIterator of the elements in this list (in proper
    # sequence), starting at the specified position in the list
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @see List#listIterator(int)
    def list_iterator(index)
      return ListItr.new_local(self, index)
    end
    
    class_module.module_eval {
      const_set_lazy(:ListItr) { Class.new do
        extend LocalClass
        include_class_members LinkedList
        include ListIterator
        
        attr_accessor :last_returned
        alias_method :attr_last_returned, :last_returned
        undef_method :last_returned
        alias_method :attr_last_returned=, :last_returned=
        undef_method :last_returned=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        attr_accessor :next_index
        alias_method :attr_next_index, :next_index
        undef_method :next_index
        alias_method :attr_next_index=, :next_index=
        undef_method :next_index=
        
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        typesig { [::Java::Int] }
        def initialize(index)
          @last_returned = self.attr_header
          @next = nil
          @next_index = 0
          @expected_mod_count = self.attr_mod_count
          if (index < 0 || index > self.attr_size)
            raise IndexOutOfBoundsException.new("Index: " + (index).to_s + ", Size: " + (self.attr_size).to_s)
          end
          if (index < (self.attr_size >> 1))
            @next = self.attr_header.attr_next
            @next_index = 0
            while @next_index < index
              @next = @next.attr_next
              ((@next_index += 1) - 1)
            end
          else
            @next = self.attr_header
            @next_index = self.attr_size
            while @next_index > index
              @next = @next.attr_previous
              ((@next_index -= 1) + 1)
            end
          end
        end
        
        typesig { [] }
        def has_next
          return !(@next_index).equal?(self.attr_size)
        end
        
        typesig { [] }
        def next
          check_for_comodification
          if ((@next_index).equal?(self.attr_size))
            raise NoSuchElementException.new
          end
          @last_returned = @next
          @next = @next.attr_next
          ((@next_index += 1) - 1)
          return @last_returned.attr_element
        end
        
        typesig { [] }
        def has_previous
          return !(@next_index).equal?(0)
        end
        
        typesig { [] }
        def previous
          if ((@next_index).equal?(0))
            raise NoSuchElementException.new
          end
          @last_returned = @next = @next.attr_previous
          ((@next_index -= 1) + 1)
          check_for_comodification
          return @last_returned.attr_element
        end
        
        typesig { [] }
        def next_index
          return @next_index
        end
        
        typesig { [] }
        def previous_index
          return @next_index - 1
        end
        
        typesig { [] }
        def remove
          check_for_comodification
          last_next = @last_returned.attr_next
          begin
            @local_class_parent.remove(@last_returned)
          rescue NoSuchElementException => e
            raise IllegalStateException.new
          end
          if ((@next).equal?(@last_returned))
            @next = last_next
          else
            ((@next_index -= 1) + 1)
          end
          @last_returned = self.attr_header
          ((@expected_mod_count += 1) - 1)
        end
        
        typesig { [E] }
        def set(e)
          if ((@last_returned).equal?(self.attr_header))
            raise IllegalStateException.new
          end
          check_for_comodification
          @last_returned.attr_element = e
        end
        
        typesig { [E] }
        def add(e)
          check_for_comodification
          @last_returned = self.attr_header
          add_before(e, @next)
          ((@next_index += 1) - 1)
          ((@expected_mod_count += 1) - 1)
        end
        
        typesig { [] }
        def check_for_comodification
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
        end
        
        private
        alias_method :initialize__list_itr, :initialize
      end }
      
      const_set_lazy(:Entry) { Class.new do
        include_class_members LinkedList
        
        attr_accessor :element
        alias_method :attr_element, :element
        undef_method :element
        alias_method :attr_element=, :element=
        undef_method :element=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        attr_accessor :previous
        alias_method :attr_previous, :previous
        undef_method :previous
        alias_method :attr_previous=, :previous=
        undef_method :previous=
        
        typesig { [Object, Entry, Entry] }
        def initialize(element, next_, previous)
          @element = nil
          @next = nil
          @previous = nil
          @element = element
          @next = next_
          @previous = previous
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
    }
    
    typesig { [Object, Entry] }
    def add_before(e, entry_)
      new_entry = Entry.new(e, entry_, entry_.attr_previous)
      new_entry.attr_previous.attr_next = new_entry
      new_entry.attr_next.attr_previous = new_entry
      ((@size += 1) - 1)
      ((self.attr_mod_count += 1) - 1)
      return new_entry
    end
    
    typesig { [Entry] }
    def remove(e)
      if ((e).equal?(@header))
        raise NoSuchElementException.new
      end
      result = e.attr_element
      e.attr_previous.attr_next = e.attr_next
      e.attr_next.attr_previous = e.attr_previous
      e.attr_next = e.attr_previous = nil
      e.attr_element = nil
      ((@size -= 1) + 1)
      ((self.attr_mod_count += 1) - 1)
      return result
    end
    
    typesig { [] }
    # 
    # @since 1.6
    def descending_iterator
      return DescendingIterator.new_local(self)
    end
    
    class_module.module_eval {
      # Adapter to provide descending iterators via ListItr.previous
      const_set_lazy(:DescendingIterator) { Class.new do
        extend LocalClass
        include_class_members LinkedList
        include Iterator
        
        attr_accessor :itr
        alias_method :attr_itr, :itr
        undef_method :itr
        alias_method :attr_itr=, :itr=
        undef_method :itr=
        
        typesig { [] }
        def has_next
          return @itr.has_previous
        end
        
        typesig { [] }
        def next
          return @itr.previous
        end
        
        typesig { [] }
        def remove
          @itr.remove
        end
        
        typesig { [] }
        def initialize
          @itr = ListItr.new(size)
        end
        
        private
        alias_method :initialize__descending_iterator, :initialize
      end }
    }
    
    typesig { [] }
    # 
    # Returns a shallow copy of this <tt>LinkedList</tt>. (The elements
    # themselves are not cloned.)
    # 
    # @return a shallow copy of this <tt>LinkedList</tt> instance
    def clone
      clone = nil
      begin
        clone = super
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
      # Put clone into "virgin" state
      clone.attr_header = Entry.new(nil, nil, nil)
      clone.attr_header.attr_next = clone.attr_header.attr_previous = clone.attr_header
      clone.attr_size = 0
      clone.attr_mod_count = 0
      # Initialize clone with our elements
      e_ = @header.attr_next
      while !(e_).equal?(@header)
        clone.add(e_.attr_element)
        e_ = e_.attr_next
      end
      return clone
    end
    
    typesig { [] }
    # 
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
    # @return an array containing all of the elements in this list
    # in proper sequence
    def to_array
      result = Array.typed(Object).new(@size) { nil }
      i = 0
      e = @header.attr_next
      while !(e).equal?(@header)
        result[((i += 1) - 1)] = e.attr_element
        e = e.attr_next
      end
      return result
    end
    
    typesig { [Array.typed(T)] }
    # 
    # Returns an array containing all of the elements in this list in
    # proper sequence (from first to last element); the runtime type of
    # the returned array is that of the specified array.  If the list fits
    # in the specified array, it is returned therein.  Otherwise, a new
    # array is allocated with the runtime type of the specified array and
    # the size of this list.
    # 
    # <p>If the list fits in the specified array with room to spare (i.e.,
    # the array has more elements than the list), the element in the array
    # immediately following the end of the list is set to <tt>null</tt>.
    # (This is useful in determining the length of the list <i>only</i> if
    # the caller knows that the list does not contain any null elements.)
    # 
    # <p>Like the {@link #toArray()} method, this method acts as bridge between
    # array-based and collection-based APIs.  Further, this method allows
    # precise control over the runtime type of the output array, and may,
    # under certain circumstances, be used to save allocation costs.
    # 
    # <p>Suppose <tt>x</tt> is a list known to contain only strings.
    # The following code can be used to dump the list into a newly
    # allocated array of <tt>String</tt>:
    # 
    # <pre>
    # String[] y = x.toArray(new String[0]);</pre>
    # 
    # Note that <tt>toArray(new Object[0])</tt> is identical in function to
    # <tt>toArray()</tt>.
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
        a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, @size)
      end
      i = 0
      result = a
      e = @header.attr_next
      while !(e).equal?(@header)
        result[((i += 1) - 1)] = e.attr_element
        e = e.attr_next
      end
      if (a.attr_length > @size)
        a[@size] = nil
      end
      return a
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 876323262645176354 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # 
    # Save the state of this <tt>LinkedList</tt> instance to a stream (that
    # is, serialize it).
    # 
    # @serialData The size of the list (the number of elements it
    # contains) is emitted (int), followed by all of its
    # elements (each an Object) in the proper order.
    def write_object(s)
      # Write out any hidden serialization magic
      s.default_write_object
      # Write out size
      s.write_int(@size)
      # Write out all elements in the proper order.
      e = @header.attr_next
      while !(e).equal?(@header)
        s.write_object(e.attr_element)
        e = e.attr_next
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # 
    # Reconstitute this <tt>LinkedList</tt> instance from a stream (that is
    # deserialize it).
    def read_object(s)
      # Read in any hidden serialization magic
      s.default_read_object
      # Read in size
      size = s.read_int
      # Initialize header
      @header = Entry.new(nil, nil, nil)
      @header.attr_next = @header.attr_previous = @header
      # Read in all elements in the proper order.
      i = 0
      while i < size
        add_before(s.read_object, @header)
        ((i += 1) - 1)
      end
    end
    
    private
    alias_method :initialize__linked_list, :initialize
  end
  
end
