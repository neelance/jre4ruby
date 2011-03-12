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
  module PriorityQueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # An unbounded priority {@linkplain Queue queue} based on a priority heap.
  # The elements of the priority queue are ordered according to their
  # {@linkplain Comparable natural ordering}, or by a {@link Comparator}
  # provided at queue construction time, depending on which constructor is
  # used.  A priority queue does not permit {@code null} elements.
  # A priority queue relying on natural ordering also does not permit
  # insertion of non-comparable objects (doing so may result in
  # {@code ClassCastException}).
  # 
  # <p>The <em>head</em> of this queue is the <em>least</em> element
  # with respect to the specified ordering.  If multiple elements are
  # tied for least value, the head is one of those elements -- ties are
  # broken arbitrarily.  The queue retrieval operations {@code poll},
  # {@code remove}, {@code peek}, and {@code element} access the
  # element at the head of the queue.
  # 
  # <p>A priority queue is unbounded, but has an internal
  # <i>capacity</i> governing the size of an array used to store the
  # elements on the queue.  It is always at least as large as the queue
  # size.  As elements are added to a priority queue, its capacity
  # grows automatically.  The details of the growth policy are not
  # specified.
  # 
  # <p>This class and its iterator implement all of the
  # <em>optional</em> methods of the {@link Collection} and {@link
  # Iterator} interfaces.  The Iterator provided in method {@link
  # #iterator()} is <em>not</em> guaranteed to traverse the elements of
  # the priority queue in any particular order. If you need ordered
  # traversal, consider using {@code Arrays.sort(pq.toArray())}.
  # 
  # <p> <strong>Note that this implementation is not synchronized.</strong>
  # Multiple threads should not access a {@code PriorityQueue}
  # instance concurrently if any of the threads modifies the queue.
  # Instead, use the thread-safe {@link
  # java.util.concurrent.PriorityBlockingQueue} class.
  # 
  # <p>Implementation note: this implementation provides
  # O(log(n)) time for the enqueing and dequeing methods
  # ({@code offer}, {@code poll}, {@code remove()} and {@code add});
  # linear time for the {@code remove(Object)} and {@code contains(Object)}
  # methods; and constant time for the retrieval methods
  # ({@code peek}, {@code element}, and {@code size}).
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.5
  # @author Josh Bloch, Doug Lea
  # @param <E> the type of elements held in this collection
  class PriorityQueue < PriorityQueueImports.const_get :AbstractQueue
    include_class_members PriorityQueueImports
    overload_protected {
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7720805057305804111 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:DEFAULT_INITIAL_CAPACITY) { 11 }
      const_attr_reader  :DEFAULT_INITIAL_CAPACITY
    }
    
    # Priority queue represented as a balanced binary heap: the two
    # children of queue[n] are queue[2*n+1] and queue[2*(n+1)].  The
    # priority queue is ordered by comparator, or by the elements'
    # natural ordering, if comparator is null: For each node n in the
    # heap and each descendant d of n, n <= d.  The element with the
    # lowest value is in queue[0], assuming the queue is nonempty.
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    # The number of elements in the priority queue.
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    # The comparator, or null if priority queue uses elements'
    # natural ordering.
    attr_accessor :comparator
    alias_method :attr_comparator, :comparator
    undef_method :comparator
    alias_method :attr_comparator=, :comparator=
    undef_method :comparator=
    
    # The number of times this priority queue has been
    # <i>structurally modified</i>.  See AbstractList for gory details.
    attr_accessor :mod_count
    alias_method :attr_mod_count, :mod_count
    undef_method :mod_count
    alias_method :attr_mod_count=, :mod_count=
    undef_method :mod_count=
    
    typesig { [] }
    # Creates a {@code PriorityQueue} with the default initial
    # capacity (11) that orders its elements according to their
    # {@linkplain Comparable natural ordering}.
    def initialize
      initialize__priority_queue(DEFAULT_INITIAL_CAPACITY, nil)
    end
    
    typesig { [::Java::Int] }
    # Creates a {@code PriorityQueue} with the specified initial
    # capacity that orders its elements according to their
    # {@linkplain Comparable natural ordering}.
    # 
    # @param initialCapacity the initial capacity for this priority queue
    # @throws IllegalArgumentException if {@code initialCapacity} is less
    #         than 1
    def initialize(initial_capacity)
      initialize__priority_queue(initial_capacity, nil)
    end
    
    typesig { [::Java::Int, Comparator] }
    # Creates a {@code PriorityQueue} with the specified initial capacity
    # that orders its elements according to the specified comparator.
    # 
    # @param  initialCapacity the initial capacity for this priority queue
    # @param  comparator the comparator that will be used to order this
    #         priority queue.  If {@code null}, the {@linkplain Comparable
    #         natural ordering} of the elements will be used.
    # @throws IllegalArgumentException if {@code initialCapacity} is
    #         less than 1
    def initialize(initial_capacity, comparator)
      @queue = nil
      @size = 0
      @comparator = nil
      @mod_count = 0
      super()
      @size = 0
      @mod_count = 0
      # Note: This restriction of at least one is not actually needed,
      # but continues for 1.5 compatibility
      if (initial_capacity < 1)
        raise IllegalArgumentException.new
      end
      @queue = Array.typed(Object).new(initial_capacity) { nil }
      @comparator = comparator
    end
    
    typesig { [Collection] }
    # Creates a {@code PriorityQueue} containing the elements in the
    # specified collection.  If the specified collection is an instance of
    # a {@link SortedSet} or is another {@code PriorityQueue}, this
    # priority queue will be ordered according to the same ordering.
    # Otherwise, this priority queue will be ordered according to the
    # {@linkplain Comparable natural ordering} of its elements.
    # 
    # @param  c the collection whose elements are to be placed
    #         into this priority queue
    # @throws ClassCastException if elements of the specified collection
    #         cannot be compared to one another according to the priority
    #         queue's ordering
    # @throws NullPointerException if the specified collection or any
    #         of its elements are null
    def initialize(c)
      @queue = nil
      @size = 0
      @comparator = nil
      @mod_count = 0
      super()
      @size = 0
      @mod_count = 0
      init_from_collection(c)
      if (c.is_a?(SortedSet))
        @comparator = (c).comparator
      else
        if (c.is_a?(PriorityQueue))
          @comparator = (c).comparator
        else
          @comparator = nil
          heapify
        end
      end
    end
    
    typesig { [PriorityQueue] }
    # Creates a {@code PriorityQueue} containing the elements in the
    # specified priority queue.  This priority queue will be
    # ordered according to the same ordering as the given priority
    # queue.
    # 
    # @param  c the priority queue whose elements are to be placed
    #         into this priority queue
    # @throws ClassCastException if elements of {@code c} cannot be
    #         compared to one another according to {@code c}'s
    #         ordering
    # @throws NullPointerException if the specified priority queue or any
    #         of its elements are null
    def initialize(c)
      @queue = nil
      @size = 0
      @comparator = nil
      @mod_count = 0
      super()
      @size = 0
      @mod_count = 0
      @comparator = c.comparator
      init_from_collection(c)
    end
    
    typesig { [SortedSet] }
    # Creates a {@code PriorityQueue} containing the elements in the
    # specified sorted set.   This priority queue will be ordered
    # according to the same ordering as the given sorted set.
    # 
    # @param  c the sorted set whose elements are to be placed
    #         into this priority queue
    # @throws ClassCastException if elements of the specified sorted
    #         set cannot be compared to one another according to the
    #         sorted set's ordering
    # @throws NullPointerException if the specified sorted set or any
    #         of its elements are null
    def initialize(c)
      @queue = nil
      @size = 0
      @comparator = nil
      @mod_count = 0
      super()
      @size = 0
      @mod_count = 0
      @comparator = c.comparator
      init_from_collection(c)
    end
    
    typesig { [Collection] }
    # Initializes queue array with elements from the given Collection.
    # 
    # @param c the collection
    def init_from_collection(c)
      a = c.to_array
      # If c.toArray incorrectly doesn't return Object[], copy it.
      if (!(a.get_class).equal?(Array[]))
        a = Arrays.copy_of(a, a.attr_length, Array[])
      end
      @queue = a
      @size = a.attr_length
    end
    
    typesig { [::Java::Int] }
    # Increases the capacity of the array.
    # 
    # @param minCapacity the desired minimum capacity
    def grow(min_capacity)
      if (min_capacity < 0)
        # overflow
        raise OutOfMemoryError.new
      end
      old_capacity = @queue.attr_length
      # Double size if small; else grow by 50%
      new_capacity = ((old_capacity < 64) ? ((old_capacity + 1) * 2) : ((old_capacity / 2) * 3))
      if (new_capacity < 0)
        # overflow
        new_capacity = JavaInteger::MAX_VALUE
      end
      if (new_capacity < min_capacity)
        new_capacity = min_capacity
      end
      @queue = Arrays.copy_of(@queue, new_capacity)
    end
    
    typesig { [Object] }
    # Inserts the specified element into this priority queue.
    # 
    # @return {@code true} (as specified by {@link Collection#add})
    # @throws ClassCastException if the specified element cannot be
    #         compared with elements currently in this priority queue
    #         according to the priority queue's ordering
    # @throws NullPointerException if the specified element is null
    def add(e)
      return offer(e)
    end
    
    typesig { [Object] }
    # Inserts the specified element into this priority queue.
    # 
    # @return {@code true} (as specified by {@link Queue#offer})
    # @throws ClassCastException if the specified element cannot be
    #         compared with elements currently in this priority queue
    #         according to the priority queue's ordering
    # @throws NullPointerException if the specified element is null
    def offer(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      @mod_count += 1
      i = @size
      if (i >= @queue.attr_length)
        grow(i + 1)
      end
      @size = i + 1
      if ((i).equal?(0))
        @queue[0] = e
      else
        sift_up(i, e)
      end
      return true
    end
    
    typesig { [] }
    def peek
      if ((@size).equal?(0))
        return nil
      end
      return @queue[0]
    end
    
    typesig { [Object] }
    def index_of(o)
      if (!(o).nil?)
        i = 0
        while i < @size
          if ((o == @queue[i]))
            return i
          end
          i += 1
        end
      end
      return -1
    end
    
    typesig { [Object] }
    # Removes a single instance of the specified element from this queue,
    # if it is present.  More formally, removes an element {@code e} such
    # that {@code o.equals(e)}, if this queue contains one or more such
    # elements.  Returns {@code true} if and only if this queue contained
    # the specified element (or equivalently, if this queue changed as a
    # result of the call).
    # 
    # @param o element to be removed from this queue, if present
    # @return {@code true} if this queue changed as a result of the call
    def remove(o)
      i = index_of(o)
      if ((i).equal?(-1))
        return false
      else
        remove_at(i)
        return true
      end
    end
    
    typesig { [Object] }
    # Version of remove using reference equality, not equals.
    # Needed by iterator.remove.
    # 
    # @param o element to be removed from this queue, if present
    # @return {@code true} if removed
    def remove_eq(o)
      i = 0
      while i < @size
        if ((o).equal?(@queue[i]))
          remove_at(i)
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [Object] }
    # Returns {@code true} if this queue contains the specified element.
    # More formally, returns {@code true} if and only if this queue contains
    # at least one element {@code e} such that {@code o.equals(e)}.
    # 
    # @param o object to be checked for containment in this queue
    # @return {@code true} if this queue contains the specified element
    def contains(o)
      return !(index_of(o)).equal?(-1)
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this queue.
    # The elements are in no particular order.
    # 
    # <p>The returned array will be "safe" in that no references to it are
    # maintained by this queue.  (In other words, this method must allocate
    # a new array).  The caller is thus free to modify the returned array.
    # 
    # <p>This method acts as bridge between array-based and collection-based
    # APIs.
    # 
    # @return an array containing all of the elements in this queue
    def to_array
      return Arrays.copy_of(@queue, @size)
    end
    
    typesig { [Array.typed(Object)] }
    # Returns an array containing all of the elements in this queue; the
    # runtime type of the returned array is that of the specified array.
    # The returned array elements are in no particular order.
    # If the queue fits in the specified array, it is returned therein.
    # Otherwise, a new array is allocated with the runtime type of the
    # specified array and the size of this queue.
    # 
    # <p>If the queue fits in the specified array with room to spare
    # (i.e., the array has more elements than the queue), the element in
    # the array immediately following the end of the collection is set to
    # {@code null}.
    # 
    # <p>Like the {@link #toArray()} method, this method acts as bridge between
    # array-based and collection-based APIs.  Further, this method allows
    # precise control over the runtime type of the output array, and may,
    # under certain circumstances, be used to save allocation costs.
    # 
    # <p>Suppose <tt>x</tt> is a queue known to contain only strings.
    # The following code can be used to dump the queue into a newly
    # allocated array of <tt>String</tt>:
    # 
    # <pre>
    #     String[] y = x.toArray(new String[0]);</pre>
    # 
    # Note that <tt>toArray(new Object[0])</tt> is identical in function to
    # <tt>toArray()</tt>.
    # 
    # @param a the array into which the elements of the queue are to
    #          be stored, if it is big enough; otherwise, a new array of the
    #          same runtime type is allocated for this purpose.
    # @return an array containing all of the elements in this queue
    # @throws ArrayStoreException if the runtime type of the specified array
    #         is not a supertype of the runtime type of every element in
    #         this queue
    # @throws NullPointerException if the specified array is null
    def to_array(a)
      if (a.attr_length < @size)
        # Make a new array of a's runtime type, but my contents:
        return Arrays.copy_of(@queue, @size, a.get_class)
      end
      System.arraycopy(@queue, 0, a, 0, @size)
      if (a.attr_length > @size)
        a[@size] = nil
      end
      return a
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this queue. The iterator
    # does not return the elements in any particular order.
    # 
    # @return an iterator over the elements in this queue
    def iterator
      return Itr.new_local(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:Itr) { Class.new do
        local_class_in PriorityQueue
        include_class_members PriorityQueue
        include Iterator
        
        # Index (into queue array) of element to be returned by
        # subsequent call to next.
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        # Index of element returned by most recent call to next,
        # unless that element came from the forgetMeNot list.
        # Set to -1 if element is deleted by a call to remove.
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        # A queue of elements that were moved from the unvisited portion of
        # the heap into the visited portion as a result of "unlucky" element
        # removals during the iteration.  (Unlucky element removals are those
        # that require a siftup instead of a siftdown.)  We must visit all of
        # the elements in this list to complete the iteration.  We do this
        # after we've completed the "normal" iteration.
        # 
        # We expect that most iterations, even those involving removals,
        # will not need to store elements in this field.
        attr_accessor :forget_me_not
        alias_method :attr_forget_me_not, :forget_me_not
        undef_method :forget_me_not
        alias_method :attr_forget_me_not=, :forget_me_not=
        undef_method :forget_me_not=
        
        # Element returned by the most recent call to next iff that
        # element was drawn from the forgetMeNot list.
        attr_accessor :last_ret_elt
        alias_method :attr_last_ret_elt, :last_ret_elt
        undef_method :last_ret_elt
        alias_method :attr_last_ret_elt=, :last_ret_elt=
        undef_method :last_ret_elt=
        
        # The modCount value that the iterator believes that the backing
        # Queue should have.  If this expectation is violated, the iterator
        # has detected concurrent modification.
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        typesig { [] }
        def has_next
          return @cursor < self.attr_size || (!(@forget_me_not).nil? && !@forget_me_not.is_empty)
        end
        
        typesig { [] }
        def next_
          if (!(@expected_mod_count).equal?(self.attr_mod_count))
            raise self.class::ConcurrentModificationException.new
          end
          if (@cursor < self.attr_size)
            return self.attr_queue[@last_ret = ((@cursor += 1) - 1)]
          end
          if (!(@forget_me_not).nil?)
            @last_ret = -1
            @last_ret_elt = @forget_me_not.poll
            if (!(@last_ret_elt).nil?)
              return @last_ret_elt
            end
          end
          raise self.class::NoSuchElementException.new
        end
        
        typesig { [] }
        def remove
          if (!(@expected_mod_count).equal?(self.attr_mod_count))
            raise self.class::ConcurrentModificationException.new
          end
          if (!(@last_ret).equal?(-1))
            moved = @local_class_parent.remove_at(@last_ret)
            @last_ret = -1
            if ((moved).nil?)
              @cursor -= 1
            else
              if ((@forget_me_not).nil?)
                @forget_me_not = self.class::ArrayDeque.new
              end
              @forget_me_not.add(moved)
            end
          else
            if (!(@last_ret_elt).nil?)
              @local_class_parent.remove_eq(@last_ret_elt)
              @last_ret_elt = nil
            else
              raise self.class::IllegalStateException.new
            end
          end
          @expected_mod_count = self.attr_mod_count
        end
        
        typesig { [] }
        def initialize
          @cursor = 0
          @last_ret = -1
          @forget_me_not = nil
          @last_ret_elt = nil
          @expected_mod_count = self.attr_mod_count
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
    }
    
    typesig { [] }
    def size
      return @size
    end
    
    typesig { [] }
    # Removes all of the elements from this priority queue.
    # The queue will be empty after this call returns.
    def clear
      @mod_count += 1
      i = 0
      while i < @size
        @queue[i] = nil
        i += 1
      end
      @size = 0
    end
    
    typesig { [] }
    def poll
      if ((@size).equal?(0))
        return nil
      end
      s = (@size -= 1)
      @mod_count += 1
      result = @queue[0]
      x = @queue[s]
      @queue[s] = nil
      if (!(s).equal?(0))
        sift_down(0, x)
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # Removes the ith element from queue.
    # 
    # Normally this method leaves the elements at up to i-1,
    # inclusive, untouched.  Under these circumstances, it returns
    # null.  Occasionally, in order to maintain the heap invariant,
    # it must swap a later element of the list with one earlier than
    # i.  Under these circumstances, this method returns the element
    # that was previously at the end of the list and is now at some
    # position before i. This fact is used by iterator.remove so as to
    # avoid missing traversing elements.
    def remove_at(i)
      raise AssertError if not (i >= 0 && i < @size)
      @mod_count += 1
      s = (@size -= 1)
      if ((s).equal?(i))
        # removed last element
        @queue[i] = nil
      else
        moved = @queue[s]
        @queue[s] = nil
        sift_down(i, moved)
        if ((@queue[i]).equal?(moved))
          sift_up(i, moved)
          if (!(@queue[i]).equal?(moved))
            return moved
          end
        end
      end
      return nil
    end
    
    typesig { [::Java::Int, Object] }
    # Inserts item x at position k, maintaining heap invariant by
    # promoting x up the tree until it is greater than or equal to
    # its parent, or is the root.
    # 
    # To simplify and speed up coercions and comparisons. the
    # Comparable and Comparator versions are separated into different
    # methods that are otherwise identical. (Similarly for siftDown.)
    # 
    # @param k the position to fill
    # @param x the item to insert
    def sift_up(k, x)
      if (!(@comparator).nil?)
        sift_up_using_comparator(k, x)
      else
        sift_up_comparable(k, x)
      end
    end
    
    typesig { [::Java::Int, Object] }
    def sift_up_comparable(k, x)
      key = x
      while (k > 0)
        parent = (k - 1) >> 1
        e = @queue[parent]
        if ((key <=> e) >= 0)
          break
        end
        @queue[k] = e
        k = parent
      end
      @queue[k] = key
    end
    
    typesig { [::Java::Int, Object] }
    def sift_up_using_comparator(k, x)
      while (k > 0)
        parent = (k - 1) >> 1
        e = @queue[parent]
        if (@comparator.compare(x, e) >= 0)
          break
        end
        @queue[k] = e
        k = parent
      end
      @queue[k] = x
    end
    
    typesig { [::Java::Int, Object] }
    # Inserts item x at position k, maintaining heap invariant by
    # demoting x down the tree repeatedly until it is less than or
    # equal to its children or is a leaf.
    # 
    # @param k the position to fill
    # @param x the item to insert
    def sift_down(k, x)
      if (!(@comparator).nil?)
        sift_down_using_comparator(k, x)
      else
        sift_down_comparable(k, x)
      end
    end
    
    typesig { [::Java::Int, Object] }
    def sift_down_comparable(k, x)
      key = x
      half = @size >> 1 # loop while a non-leaf
      while (k < half)
        child = (k << 1) + 1 # assume left child is least
        c = @queue[child]
        right = child + 1
        if (right < @size && ((c) <=> @queue[right]) > 0)
          c = @queue[child = right]
        end
        if ((key <=> c) <= 0)
          break
        end
        @queue[k] = c
        k = child
      end
      @queue[k] = key
    end
    
    typesig { [::Java::Int, Object] }
    def sift_down_using_comparator(k, x)
      half = @size >> 1
      while (k < half)
        child = (k << 1) + 1
        c = @queue[child]
        right = child + 1
        if (right < @size && @comparator.compare(c, @queue[right]) > 0)
          c = @queue[child = right]
        end
        if (@comparator.compare(x, c) <= 0)
          break
        end
        @queue[k] = c
        k = child
      end
      @queue[k] = x
    end
    
    typesig { [] }
    # Establishes the heap invariant (described above) in the entire tree,
    # assuming nothing about the order of the elements prior to the call.
    def heapify
      i = (@size >> 1) - 1
      while i >= 0
        sift_down(i, @queue[i])
        i -= 1
      end
    end
    
    typesig { [] }
    # Returns the comparator used to order the elements in this
    # queue, or {@code null} if this queue is sorted according to
    # the {@linkplain Comparable natural ordering} of its elements.
    # 
    # @return the comparator used to order this queue, or
    #         {@code null} if this queue is sorted according to the
    #         natural ordering of its elements
    def comparator
      return @comparator
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Saves the state of the instance to a stream (that
    # is, serializes it).
    # 
    # @serialData The length of the array backing the instance is
    #             emitted (int), followed by all of its elements
    #             (each an {@code Object}) in the proper order.
    # @param s the stream
    def write_object(s)
      # Write out element count, and any hidden stuff
      s.default_write_object
      # Write out array length, for compatibility with 1.5 version
      s.write_int(Math.max(2, @size + 1))
      # Write out all elements in the "proper order".
      i = 0
      while i < @size
        s.write_object(@queue[i])
        i += 1
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitutes the {@code PriorityQueue} instance from a stream
    # (that is, deserializes it).
    # 
    # @param s the stream
    def read_object(s)
      # Read in size, and any hidden stuff
      s.default_read_object
      # Read in (and discard) array length
      s.read_int
      @queue = Array.typed(Object).new(@size) { nil }
      # Read in all elements.
      i = 0
      while i < @size
        @queue[i] = s.read_object
        i += 1
      end
      # Elements are guaranteed to be in "proper order", but the
      # spec has never explained what that might be.
      heapify
    end
    
    private
    alias_method :initialize__priority_queue, :initialize
  end
  
end
