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
# Written by Josh Bloch of Google Inc. and released to the public domain,
# as explained at http://creativecommons.org/licenses/publicdomain.
module Java::Util
  module ArrayDequeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
    }
  end
  
  # 
  # Resizable-array implementation of the {@link Deque} interface.  Array
  # deques have no capacity restrictions; they grow as necessary to support
  # usage.  They are not thread-safe; in the absence of external
  # synchronization, they do not support concurrent access by multiple threads.
  # Null elements are prohibited.  This class is likely to be faster than
  # {@link Stack} when used as a stack, and faster than {@link LinkedList}
  # when used as a queue.
  # 
  # <p>Most <tt>ArrayDeque</tt> operations run in amortized constant time.
  # Exceptions include {@link #remove(Object) remove}, {@link
  # #removeFirstOccurrence removeFirstOccurrence}, {@link #removeLastOccurrence
  # removeLastOccurrence}, {@link #contains contains}, {@link #iterator
  # iterator.remove()}, and the bulk operations, all of which run in linear
  # time.
  # 
  # <p>The iterators returned by this class's <tt>iterator</tt> method are
  # <i>fail-fast</i>: If the deque is modified at any time after the iterator
  # is created, in any way except through the iterator's own <tt>remove</tt>
  # method, the iterator will generally throw a {@link
  # ConcurrentModificationException}.  Thus, in the face of concurrent
  # modification, the iterator fails quickly and cleanly, rather than risking
  # arbitrary, non-deterministic behavior at an undetermined time in the
  # future.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw <tt>ConcurrentModificationException</tt> on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness: <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>This class and its iterator implement all of the
  # <em>optional</em> methods of the {@link Collection} and {@link
  # Iterator} interfaces.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch and Doug Lea
  # @since   1.6
  # @param <E> the type of elements held in this collection
  class ArrayDeque < ArrayDequeImports.const_get :AbstractCollection
    include_class_members ArrayDequeImports
    include Deque
    include Cloneable
    include Serializable
    
    # 
    # The array in which the elements of the deque are stored.
    # The capacity of the deque is the length of this array, which is
    # always a power of two. The array is never allowed to become
    # full, except transiently within an addX method where it is
    # resized (see doubleCapacity) immediately upon becoming full,
    # thus avoiding head and tail wrapping around to equal each
    # other.  We also guarantee that all array cells not holding
    # deque elements are always null.
    attr_accessor :elements
    alias_method :attr_elements, :elements
    undef_method :elements
    alias_method :attr_elements=, :elements=
    undef_method :elements=
    
    # 
    # The index of the element at the head of the deque (which is the
    # element that would be removed by remove() or pop()); or an
    # arbitrary number equal to tail if the deque is empty.
    attr_accessor :head
    alias_method :attr_head, :head
    undef_method :head
    alias_method :attr_head=, :head=
    undef_method :head=
    
    # 
    # The index at which the next element would be added to the tail
    # of the deque (via addLast(E), add(E), or push(E)).
    attr_accessor :tail
    alias_method :attr_tail, :tail
    undef_method :tail
    alias_method :attr_tail=, :tail=
    undef_method :tail=
    
    class_module.module_eval {
      # 
      # The minimum capacity that we'll use for a newly created deque.
      # Must be a power of 2.
      const_set_lazy(:MIN_INITIAL_CAPACITY) { 8 }
      const_attr_reader  :MIN_INITIAL_CAPACITY
    }
    
    typesig { [::Java::Int] }
    # ******  Array allocation and resizing utilities ******
    # 
    # Allocate empty array to hold the given number of elements.
    # 
    # @param numElements  the number of elements to hold
    def allocate_elements(num_elements)
      initial_capacity = MIN_INITIAL_CAPACITY
      # Find the best power of two to hold elements.
      # Tests "<=" because arrays aren't kept full.
      if (num_elements >= initial_capacity)
        initial_capacity = num_elements
        initial_capacity |= (initial_capacity >> 1)
        initial_capacity |= (initial_capacity >> 2)
        initial_capacity |= (initial_capacity >> 4)
        initial_capacity |= (initial_capacity >> 8)
        initial_capacity |= (initial_capacity >> 16)
        ((initial_capacity += 1) - 1)
        if (initial_capacity < 0)
          # Too many elements, must back off
          initial_capacity >>= 1
        end # Good luck allocating 2 ^ 30 elements
      end
      @elements = Array.typed(Object).new(initial_capacity) { nil }
    end
    
    typesig { [] }
    # 
    # Double the capacity of this deque.  Call only when full, i.e.,
    # when head and tail have wrapped around to become equal.
    def double_capacity
      raise AssertError if not ((@head).equal?(@tail))
      p = @head
      n = @elements.attr_length
      r = n - p # number of elements to the right of p
      new_capacity = n << 1
      if (new_capacity < 0)
        raise IllegalStateException.new("Sorry, deque too big")
      end
      a = Array.typed(Object).new(new_capacity) { nil }
      System.arraycopy(@elements, p, a, 0, r)
      System.arraycopy(@elements, 0, a, r, p)
      @elements = a
      @head = 0
      @tail = n
    end
    
    typesig { [Array.typed(T)] }
    # 
    # Copies the elements from our element array into the specified array,
    # in order (from first to last element in the deque).  It is assumed
    # that the array is large enough to hold all elements in the deque.
    # 
    # @return its argument
    def copy_elements(a)
      if (@head < @tail)
        System.arraycopy(@elements, @head, a, 0, size)
      else
        if (@head > @tail)
          head_portion_len = @elements.attr_length - @head
          System.arraycopy(@elements, @head, a, 0, head_portion_len)
          System.arraycopy(@elements, 0, a, head_portion_len, @tail)
        end
      end
      return a
    end
    
    typesig { [] }
    # 
    # Constructs an empty array deque with an initial capacity
    # sufficient to hold 16 elements.
    def initialize
      @elements = nil
      @head = 0
      @tail = 0
      super()
      @elements = Array.typed(Object).new(16) { nil }
    end
    
    typesig { [::Java::Int] }
    # 
    # Constructs an empty array deque with an initial capacity
    # sufficient to hold the specified number of elements.
    # 
    # @param numElements  lower bound on initial capacity of the deque
    def initialize(num_elements)
      @elements = nil
      @head = 0
      @tail = 0
      super()
      allocate_elements(num_elements)
    end
    
    typesig { [Collection] }
    # 
    # Constructs a deque containing the elements of the specified
    # collection, in the order they are returned by the collection's
    # iterator.  (The first element returned by the collection's
    # iterator becomes the first element, or <i>front</i> of the
    # deque.)
    # 
    # @param c the collection whose elements are to be placed into the deque
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      @elements = nil
      @head = 0
      @tail = 0
      super()
      allocate_elements(c.size)
      add_all(c)
    end
    
    typesig { [Object] }
    # The main insertion and extraction methods are addFirst,
    # addLast, pollFirst, pollLast. The other methods are defined in
    # terms of these.
    # 
    # Inserts the specified element at the front of this deque.
    # 
    # @param e the element to add
    # @throws NullPointerException if the specified element is null
    def add_first(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      @elements[@head = (@head - 1) & (@elements.attr_length - 1)] = e
      if ((@head).equal?(@tail))
        double_capacity
      end
    end
    
    typesig { [Object] }
    # 
    # Inserts the specified element at the end of this deque.
    # 
    # <p>This method is equivalent to {@link #add}.
    # 
    # @param e the element to add
    # @throws NullPointerException if the specified element is null
    def add_last(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      @elements[@tail] = e
      if (((@tail = (@tail + 1) & (@elements.attr_length - 1))).equal?(@head))
        double_capacity
      end
    end
    
    typesig { [Object] }
    # 
    # Inserts the specified element at the front of this deque.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Deque#offerFirst})
    # @throws NullPointerException if the specified element is null
    def offer_first(e)
      add_first(e)
      return true
    end
    
    typesig { [Object] }
    # 
    # Inserts the specified element at the end of this deque.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Deque#offerLast})
    # @throws NullPointerException if the specified element is null
    def offer_last(e)
      add_last(e)
      return true
    end
    
    typesig { [] }
    # 
    # @throws NoSuchElementException {@inheritDoc}
    def remove_first
      x = poll_first
      if ((x).nil?)
        raise NoSuchElementException.new
      end
      return x
    end
    
    typesig { [] }
    # 
    # @throws NoSuchElementException {@inheritDoc}
    def remove_last
      x = poll_last
      if ((x).nil?)
        raise NoSuchElementException.new
      end
      return x
    end
    
    typesig { [] }
    def poll_first
      h = @head
      result = @elements[h] # Element is null if deque empty
      if ((result).nil?)
        return nil
      end
      @elements[h] = nil # Must null out slot
      @head = (h + 1) & (@elements.attr_length - 1)
      return result
    end
    
    typesig { [] }
    def poll_last
      t = (@tail - 1) & (@elements.attr_length - 1)
      result = @elements[t]
      if ((result).nil?)
        return nil
      end
      @elements[t] = nil
      @tail = t
      return result
    end
    
    typesig { [] }
    # 
    # @throws NoSuchElementException {@inheritDoc}
    def get_first
      x = @elements[@head]
      if ((x).nil?)
        raise NoSuchElementException.new
      end
      return x
    end
    
    typesig { [] }
    # 
    # @throws NoSuchElementException {@inheritDoc}
    def get_last
      x = @elements[(@tail - 1) & (@elements.attr_length - 1)]
      if ((x).nil?)
        raise NoSuchElementException.new
      end
      return x
    end
    
    typesig { [] }
    def peek_first
      return @elements[@head] # elements[head] is null if deque empty
    end
    
    typesig { [] }
    def peek_last
      return @elements[(@tail - 1) & (@elements.attr_length - 1)]
    end
    
    typesig { [Object] }
    # 
    # Removes the first occurrence of the specified element in this
    # deque (when traversing the deque from head to tail).
    # If the deque does not contain the element, it is unchanged.
    # More formally, removes the first element <tt>e</tt> such that
    # <tt>o.equals(e)</tt> (if such an element exists).
    # Returns <tt>true</tt> if this deque contained the specified element
    # (or equivalently, if this deque changed as a result of the call).
    # 
    # @param o element to be removed from this deque, if present
    # @return <tt>true</tt> if the deque contained the specified element
    def remove_first_occurrence(o)
      if ((o).nil?)
        return false
      end
      mask = @elements.attr_length - 1
      i = @head
      x = nil
      while (!((x = @elements[i])).nil?)
        if ((o == x))
          delete(i)
          return true
        end
        i = (i + 1) & mask
      end
      return false
    end
    
    typesig { [Object] }
    # 
    # Removes the last occurrence of the specified element in this
    # deque (when traversing the deque from head to tail).
    # If the deque does not contain the element, it is unchanged.
    # More formally, removes the last element <tt>e</tt> such that
    # <tt>o.equals(e)</tt> (if such an element exists).
    # Returns <tt>true</tt> if this deque contained the specified element
    # (or equivalently, if this deque changed as a result of the call).
    # 
    # @param o element to be removed from this deque, if present
    # @return <tt>true</tt> if the deque contained the specified element
    def remove_last_occurrence(o)
      if ((o).nil?)
        return false
      end
      mask = @elements.attr_length - 1
      i = (@tail - 1) & mask
      x = nil
      while (!((x = @elements[i])).nil?)
        if ((o == x))
          delete(i)
          return true
        end
        i = (i - 1) & mask
      end
      return false
    end
    
    typesig { [Object] }
    # *** Queue methods ***
    # 
    # Inserts the specified element at the end of this deque.
    # 
    # <p>This method is equivalent to {@link #addLast}.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    # @throws NullPointerException if the specified element is null
    def add(e)
      add_last(e)
      return true
    end
    
    typesig { [Object] }
    # 
    # Inserts the specified element at the end of this deque.
    # 
    # <p>This method is equivalent to {@link #offerLast}.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Queue#offer})
    # @throws NullPointerException if the specified element is null
    def offer(e)
      return offer_last(e)
    end
    
    typesig { [] }
    # 
    # Retrieves and removes the head of the queue represented by this deque.
    # 
    # This method differs from {@link #poll poll} only in that it throws an
    # exception if this deque is empty.
    # 
    # <p>This method is equivalent to {@link #removeFirst}.
    # 
    # @return the head of the queue represented by this deque
    # @throws NoSuchElementException {@inheritDoc}
    def remove
      return remove_first
    end
    
    typesig { [] }
    # 
    # Retrieves and removes the head of the queue represented by this deque
    # (in other words, the first element of this deque), or returns
    # <tt>null</tt> if this deque is empty.
    # 
    # <p>This method is equivalent to {@link #pollFirst}.
    # 
    # @return the head of the queue represented by this deque, or
    # <tt>null</tt> if this deque is empty
    def poll
      return poll_first
    end
    
    typesig { [] }
    # 
    # Retrieves, but does not remove, the head of the queue represented by
    # this deque.  This method differs from {@link #peek peek} only in
    # that it throws an exception if this deque is empty.
    # 
    # <p>This method is equivalent to {@link #getFirst}.
    # 
    # @return the head of the queue represented by this deque
    # @throws NoSuchElementException {@inheritDoc}
    def element
      return get_first
    end
    
    typesig { [] }
    # 
    # Retrieves, but does not remove, the head of the queue represented by
    # this deque, or returns <tt>null</tt> if this deque is empty.
    # 
    # <p>This method is equivalent to {@link #peekFirst}.
    # 
    # @return the head of the queue represented by this deque, or
    # <tt>null</tt> if this deque is empty
    def peek
      return peek_first
    end
    
    typesig { [Object] }
    # *** Stack methods ***
    # 
    # Pushes an element onto the stack represented by this deque.  In other
    # words, inserts the element at the front of this deque.
    # 
    # <p>This method is equivalent to {@link #addFirst}.
    # 
    # @param e the element to push
    # @throws NullPointerException if the specified element is null
    def push(e)
      add_first(e)
    end
    
    typesig { [] }
    # 
    # Pops an element from the stack represented by this deque.  In other
    # words, removes and returns the first element of this deque.
    # 
    # <p>This method is equivalent to {@link #removeFirst()}.
    # 
    # @return the element at the front of this deque (which is the top
    # of the stack represented by this deque)
    # @throws NoSuchElementException {@inheritDoc}
    def pop
      return remove_first
    end
    
    typesig { [] }
    def check_invariants
      raise AssertError if not ((@elements[@tail]).nil?)
      raise AssertError if not ((@head).equal?(@tail) ? (@elements[@head]).nil? : (!(@elements[@head]).nil? && !(@elements[(@tail - 1) & (@elements.attr_length - 1)]).nil?))
      raise AssertError if not ((@elements[(@head - 1) & (@elements.attr_length - 1)]).nil?)
    end
    
    typesig { [::Java::Int] }
    # 
    # Removes the element at the specified position in the elements array,
    # adjusting head and tail as necessary.  This can result in motion of
    # elements backwards or forwards in the array.
    # 
    # <p>This method is called delete rather than remove to emphasize
    # that its semantics differ from those of {@link List#remove(int)}.
    # 
    # @return true if elements moved backwards
    def delete(i)
      check_invariants
      elements = @elements
      mask = elements.attr_length - 1
      h = @head
      t = @tail
      front = (i - h) & mask
      back = (t - i) & mask
      # Invariant: head <= i < tail mod circularity
      if (front >= ((t - h) & mask))
        raise ConcurrentModificationException.new
      end
      # Optimize for least element motion
      if (front < back)
        if (h <= i)
          System.arraycopy(elements, h, elements, h + 1, front)
        else
          # Wrap around
          System.arraycopy(elements, 0, elements, 1, i)
          elements[0] = elements[mask]
          System.arraycopy(elements, h, elements, h + 1, mask - h)
        end
        elements[h] = nil
        @head = (h + 1) & mask
        return false
      else
        if (i < t)
          # Copy the null tail as well
          System.arraycopy(elements, i + 1, elements, i, back)
          @tail = t - 1
        else
          # Wrap around
          System.arraycopy(elements, i + 1, elements, i, mask - i)
          elements[mask] = elements[0]
          System.arraycopy(elements, 1, elements, 0, t)
          @tail = (t - 1) & mask
        end
        return true
      end
    end
    
    typesig { [] }
    # *** Collection Methods ***
    # 
    # Returns the number of elements in this deque.
    # 
    # @return the number of elements in this deque
    def size
      return (@tail - @head) & (@elements.attr_length - 1)
    end
    
    typesig { [] }
    # 
    # Returns <tt>true</tt> if this deque contains no elements.
    # 
    # @return <tt>true</tt> if this deque contains no elements
    def is_empty
      return (@head).equal?(@tail)
    end
    
    typesig { [] }
    # 
    # Returns an iterator over the elements in this deque.  The elements
    # will be ordered from first (head) to last (tail).  This is the same
    # order that elements would be dequeued (via successive calls to
    # {@link #remove} or popped (via successive calls to {@link #pop}).
    # 
    # @return an iterator over the elements in this deque
    def iterator
      return DeqIterator.new_local(self)
    end
    
    typesig { [] }
    def descending_iterator
      return DescendingIterator.new_local(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:DeqIterator) { Class.new do
        extend LocalClass
        include_class_members ArrayDeque
        include Iterator
        
        # 
        # Index of element to be returned by subsequent call to next.
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        # 
        # Tail recorded at construction (also in remove), to stop
        # iterator and also to check for comodification.
        attr_accessor :fence
        alias_method :attr_fence, :fence
        undef_method :fence
        alias_method :attr_fence=, :fence=
        undef_method :fence=
        
        # 
        # Index of element returned by most recent call to next.
        # Reset to -1 if element is deleted by a call to remove.
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        typesig { [] }
        def has_next
          return !(@cursor).equal?(@fence)
        end
        
        typesig { [] }
        def next
          if ((@cursor).equal?(@fence))
            raise NoSuchElementException.new
          end
          result = self.attr_elements[@cursor]
          # This check doesn't catch all possible comodifications,
          # but does catch the ones that corrupt traversal
          if (!(self.attr_tail).equal?(@fence) || (result).nil?)
            raise ConcurrentModificationException.new
          end
          @last_ret = @cursor
          @cursor = (@cursor + 1) & (self.attr_elements.attr_length - 1)
          return result
        end
        
        typesig { [] }
        def remove
          if (@last_ret < 0)
            raise IllegalStateException.new
          end
          if (delete(@last_ret))
            # if left-shifted, undo increment in next()
            @cursor = (@cursor - 1) & (self.attr_elements.attr_length - 1)
            @fence = self.attr_tail
          end
          @last_ret = -1
        end
        
        typesig { [] }
        def initialize
          @cursor = self.attr_head
          @fence = self.attr_tail
          @last_ret = -1
        end
        
        private
        alias_method :initialize__deq_iterator, :initialize
      end }
      
      const_set_lazy(:DescendingIterator) { Class.new do
        extend LocalClass
        include_class_members ArrayDeque
        include Iterator
        
        # 
        # This class is nearly a mirror-image of DeqIterator, using
        # tail instead of head for initial cursor, and head instead of
        # tail for fence.
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        attr_accessor :fence
        alias_method :attr_fence, :fence
        undef_method :fence
        alias_method :attr_fence=, :fence=
        undef_method :fence=
        
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        typesig { [] }
        def has_next
          return !(@cursor).equal?(@fence)
        end
        
        typesig { [] }
        def next
          if ((@cursor).equal?(@fence))
            raise NoSuchElementException.new
          end
          @cursor = (@cursor - 1) & (self.attr_elements.attr_length - 1)
          result = self.attr_elements[@cursor]
          if (!(self.attr_head).equal?(@fence) || (result).nil?)
            raise ConcurrentModificationException.new
          end
          @last_ret = @cursor
          return result
        end
        
        typesig { [] }
        def remove
          if (@last_ret < 0)
            raise IllegalStateException.new
          end
          if (!delete(@last_ret))
            @cursor = (@cursor + 1) & (self.attr_elements.attr_length - 1)
            @fence = self.attr_head
          end
          @last_ret = -1
        end
        
        typesig { [] }
        def initialize
          @cursor = self.attr_tail
          @fence = self.attr_head
          @last_ret = -1
        end
        
        private
        alias_method :initialize__descending_iterator, :initialize
      end }
    }
    
    typesig { [Object] }
    # 
    # Returns <tt>true</tt> if this deque contains the specified element.
    # More formally, returns <tt>true</tt> if and only if this deque contains
    # at least one element <tt>e</tt> such that <tt>o.equals(e)</tt>.
    # 
    # @param o object to be checked for containment in this deque
    # @return <tt>true</tt> if this deque contains the specified element
    def contains(o)
      if ((o).nil?)
        return false
      end
      mask = @elements.attr_length - 1
      i = @head
      x = nil
      while (!((x = @elements[i])).nil?)
        if ((o == x))
          return true
        end
        i = (i + 1) & mask
      end
      return false
    end
    
    typesig { [Object] }
    # 
    # Removes a single instance of the specified element from this deque.
    # If the deque does not contain the element, it is unchanged.
    # More formally, removes the first element <tt>e</tt> such that
    # <tt>o.equals(e)</tt> (if such an element exists).
    # Returns <tt>true</tt> if this deque contained the specified element
    # (or equivalently, if this deque changed as a result of the call).
    # 
    # <p>This method is equivalent to {@link #removeFirstOccurrence}.
    # 
    # @param o element to be removed from this deque, if present
    # @return <tt>true</tt> if this deque contained the specified element
    def remove(o)
      return remove_first_occurrence(o)
    end
    
    typesig { [] }
    # 
    # Removes all of the elements from this deque.
    # The deque will be empty after this call returns.
    def clear
      h = @head
      t = @tail
      if (!(h).equal?(t))
        # clear all cells
        @head = @tail = 0
        i = h
        mask = @elements.attr_length - 1
        begin
          @elements[i] = nil
          i = (i + 1) & mask
        end while (!(i).equal?(t))
      end
    end
    
    typesig { [] }
    # 
    # Returns an array containing all of the elements in this deque
    # in proper sequence (from first to last element).
    # 
    # <p>The returned array will be "safe" in that no references to it are
    # maintained by this deque.  (In other words, this method must allocate
    # a new array).  The caller is thus free to modify the returned array.
    # 
    # <p>This method acts as bridge between array-based and collection-based
    # APIs.
    # 
    # @return an array containing all of the elements in this deque
    def to_array
      return copy_elements(Array.typed(Object).new(size) { nil })
    end
    
    typesig { [Array.typed(T)] }
    # 
    # Returns an array containing all of the elements in this deque in
    # proper sequence (from first to last element); the runtime type of the
    # returned array is that of the specified array.  If the deque fits in
    # the specified array, it is returned therein.  Otherwise, a new array
    # is allocated with the runtime type of the specified array and the
    # size of this deque.
    # 
    # <p>If this deque fits in the specified array with room to spare
    # (i.e., the array has more elements than this deque), the element in
    # the array immediately following the end of the deque is set to
    # <tt>null</tt>.
    # 
    # <p>Like the {@link #toArray()} method, this method acts as bridge between
    # array-based and collection-based APIs.  Further, this method allows
    # precise control over the runtime type of the output array, and may,
    # under certain circumstances, be used to save allocation costs.
    # 
    # <p>Suppose <tt>x</tt> is a deque known to contain only strings.
    # The following code can be used to dump the deque into a newly
    # allocated array of <tt>String</tt>:
    # 
    # <pre>
    # String[] y = x.toArray(new String[0]);</pre>
    # 
    # Note that <tt>toArray(new Object[0])</tt> is identical in function to
    # <tt>toArray()</tt>.
    # 
    # @param a the array into which the elements of the deque are to
    # be stored, if it is big enough; otherwise, a new array of the
    # same runtime type is allocated for this purpose
    # @return an array containing all of the elements in this deque
    # @throws ArrayStoreException if the runtime type of the specified array
    # is not a supertype of the runtime type of every element in
    # this deque
    # @throws NullPointerException if the specified array is null
    def to_array(a)
      size_ = size
      if (a.attr_length < size_)
        a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, size_)
      end
      copy_elements(a)
      if (a.attr_length > size_)
        a[size_] = nil
      end
      return a
    end
    
    typesig { [] }
    # *** Object methods ***
    # 
    # Returns a copy of this deque.
    # 
    # @return a copy of this deque
    def clone
      begin
        result = super
        result.attr_elements = Arrays.copy_of(@elements, @elements.attr_length)
        return result
      rescue CloneNotSupportedException => e
        raise AssertionError.new
      end
    end
    
    class_module.module_eval {
      # 
      # Appease the serialization gods.
      const_set_lazy(:SerialVersionUID) { 2340985798034038923 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [ObjectOutputStream] }
    # 
    # Serialize this deque.
    # 
    # @serialData The current size (<tt>int</tt>) of the deque,
    # followed by all of its elements (each an object reference) in
    # first-to-last order.
    def write_object(s)
      s.default_write_object
      # Write out size
      s.write_int(size)
      # Write out elements in order.
      mask = @elements.attr_length - 1
      i = @head
      while !(i).equal?(@tail)
        s.write_object(@elements[i])
        i = (i + 1) & mask
      end
    end
    
    typesig { [ObjectInputStream] }
    # 
    # Deserialize this deque.
    def read_object(s)
      s.default_read_object
      # Read in size and allocate array
      size_ = s.read_int
      allocate_elements(size_)
      @head = 0
      @tail = size_
      # Read in all elements in the proper order.
      i = 0
      while i < size_
        @elements[i] = s.read_object
        ((i += 1) - 1)
      end
    end
    
    private
    alias_method :initialize__array_deque, :initialize
  end
  
end
