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
module Java::Util::Concurrent
  module PriorityBlockingQueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util
    }
  end
  
  # An unbounded {@linkplain BlockingQueue blocking queue} that uses
  # the same ordering rules as class {@link PriorityQueue} and supplies
  # blocking retrieval operations.  While this queue is logically
  # unbounded, attempted additions may fail due to resource exhaustion
  # (causing <tt>OutOfMemoryError</tt>). This class does not permit
  # <tt>null</tt> elements.  A priority queue relying on {@linkplain
  # Comparable natural ordering} also does not permit insertion of
  # non-comparable objects (doing so results in
  # <tt>ClassCastException</tt>).
  # 
  # <p>This class and its iterator implement all of the
  # <em>optional</em> methods of the {@link Collection} and {@link
  # Iterator} interfaces.  The Iterator provided in method {@link
  # #iterator()} is <em>not</em> guaranteed to traverse the elements of
  # the PriorityBlockingQueue in any particular order. If you need
  # ordered traversal, consider using
  # <tt>Arrays.sort(pq.toArray())</tt>.  Also, method <tt>drainTo</tt>
  # can be used to <em>remove</em> some or all elements in priority
  # order and place them in another collection.
  # 
  # <p>Operations on this class make no guarantees about the ordering
  # of elements with equal priority. If you need to enforce an
  # ordering, you can define custom classes or comparators that use a
  # secondary key to break ties in primary priority values.  For
  # example, here is a class that applies first-in-first-out
  # tie-breaking to comparable elements. To use it, you would insert a
  # <tt>new FIFOEntry(anEntry)</tt> instead of a plain entry object.
  # 
  # <pre>
  # class FIFOEntry&lt;E extends Comparable&lt;? super E&gt;&gt;
  # implements Comparable&lt;FIFOEntry&lt;E&gt;&gt; {
  # final static AtomicLong seq = new AtomicLong();
  # final long seqNum;
  # final E entry;
  # public FIFOEntry(E entry) {
  # seqNum = seq.getAndIncrement();
  # this.entry = entry;
  # }
  # public E getEntry() { return entry; }
  # public int compareTo(FIFOEntry&lt;E&gt; other) {
  # int res = entry.compareTo(other.entry);
  # if (res == 0 &amp;&amp; other.entry != this.entry)
  # res = (seqNum &lt; other.seqNum ? -1 : 1);
  # return res;
  # }
  # }</pre>
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <E> the type of elements held in this collection
  class PriorityBlockingQueue < PriorityBlockingQueueImports.const_get :AbstractQueue
    include_class_members PriorityBlockingQueueImports
    overload_protected {
      include BlockingQueue
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5595510919245408276 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :q
    alias_method :attr_q, :q
    undef_method :q
    alias_method :attr_q=, :q=
    undef_method :q=
    
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    attr_accessor :not_empty
    alias_method :attr_not_empty, :not_empty
    undef_method :not_empty
    alias_method :attr_not_empty=, :not_empty=
    undef_method :not_empty=
    
    typesig { [] }
    # Creates a <tt>PriorityBlockingQueue</tt> with the default
    # initial capacity (11) that orders its elements according to
    # their {@linkplain Comparable natural ordering}.
    def initialize
      @q = nil
      @lock = nil
      @not_empty = nil
      super()
      @lock = ReentrantLock.new(true)
      @not_empty = @lock.new_condition
      @q = PriorityQueue.new
    end
    
    typesig { [::Java::Int] }
    # Creates a <tt>PriorityBlockingQueue</tt> with the specified
    # initial capacity that orders its elements according to their
    # {@linkplain Comparable natural ordering}.
    # 
    # @param initialCapacity the initial capacity for this priority queue
    # @throws IllegalArgumentException if <tt>initialCapacity</tt> is less
    # than 1
    def initialize(initial_capacity)
      @q = nil
      @lock = nil
      @not_empty = nil
      super()
      @lock = ReentrantLock.new(true)
      @not_empty = @lock.new_condition
      @q = PriorityQueue.new(initial_capacity, nil)
    end
    
    typesig { [::Java::Int, Comparator] }
    # Creates a <tt>PriorityBlockingQueue</tt> with the specified initial
    # capacity that orders its elements according to the specified
    # comparator.
    # 
    # @param initialCapacity the initial capacity for this priority queue
    # @param  comparator the comparator that will be used to order this
    # priority queue.  If {@code null}, the {@linkplain Comparable
    # natural ordering} of the elements will be used.
    # @throws IllegalArgumentException if <tt>initialCapacity</tt> is less
    # than 1
    def initialize(initial_capacity, comparator)
      @q = nil
      @lock = nil
      @not_empty = nil
      super()
      @lock = ReentrantLock.new(true)
      @not_empty = @lock.new_condition
      @q = PriorityQueue.new(initial_capacity, comparator)
    end
    
    typesig { [Collection] }
    # Creates a <tt>PriorityBlockingQueue</tt> containing the elements
    # in the specified collection.  If the specified collection is a
    # {@link SortedSet} or a {@link PriorityQueue},  this
    # priority queue will be ordered according to the same ordering.
    # Otherwise, this priority queue will be ordered according to the
    # {@linkplain Comparable natural ordering} of its elements.
    # 
    # @param  c the collection whose elements are to be placed
    # into this priority queue
    # @throws ClassCastException if elements of the specified collection
    # cannot be compared to one another according to the priority
    # queue's ordering
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def initialize(c)
      @q = nil
      @lock = nil
      @not_empty = nil
      super()
      @lock = ReentrantLock.new(true)
      @not_empty = @lock.new_condition
      @q = PriorityQueue.new(c)
    end
    
    typesig { [Object] }
    # Inserts the specified element into this priority queue.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    # @throws ClassCastException if the specified element cannot be compared
    # with elements currently in the priority queue according to the
    # priority queue's ordering
    # @throws NullPointerException if the specified element is null
    def add(e)
      return offer(e)
    end
    
    typesig { [Object] }
    # Inserts the specified element into this priority queue.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Queue#offer})
    # @throws ClassCastException if the specified element cannot be compared
    # with elements currently in the priority queue according to the
    # priority queue's ordering
    # @throws NullPointerException if the specified element is null
    def offer(e)
      lock = @lock
      lock.lock
      begin
        ok = @q.offer(e)
        raise AssertError if not (ok)
        @not_empty.signal
        return true
      ensure
        lock.unlock
      end
    end
    
    typesig { [Object] }
    # Inserts the specified element into this priority queue. As the queue is
    # unbounded this method will never block.
    # 
    # @param e the element to add
    # @throws ClassCastException if the specified element cannot be compared
    # with elements currently in the priority queue according to the
    # priority queue's ordering
    # @throws NullPointerException if the specified element is null
    def put(e)
      offer(e) # never need to block
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # Inserts the specified element into this priority queue. As the queue is
    # unbounded this method will never block.
    # 
    # @param e the element to add
    # @param timeout This parameter is ignored as the method never blocks
    # @param unit This parameter is ignored as the method never blocks
    # @return <tt>true</tt>
    # @throws ClassCastException if the specified element cannot be compared
    # with elements currently in the priority queue according to the
    # priority queue's ordering
    # @throws NullPointerException if the specified element is null
    def offer(e, timeout, unit)
      return offer(e) # never need to block
    end
    
    typesig { [] }
    def poll
      lock_ = @lock
      lock_.lock
      begin
        return @q.poll
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    def take
      lock_ = @lock
      lock_.lock_interruptibly
      begin
        begin
          while ((@q.size).equal?(0))
            @not_empty.await
          end
        rescue InterruptedException => ie
          @not_empty.signal # propagate to non-interrupted thread
          raise ie
        end
        x = @q.poll
        raise AssertError if not (!(x).nil?)
        return x
      ensure
        lock_.unlock
      end
    end
    
    typesig { [::Java::Long, TimeUnit] }
    def poll(timeout, unit)
      nanos = unit.to_nanos(timeout)
      lock_ = @lock
      lock_.lock_interruptibly
      begin
        loop do
          x = @q.poll
          if (!(x).nil?)
            return x
          end
          if (nanos <= 0)
            return nil
          end
          begin
            nanos = @not_empty.await_nanos(nanos)
          rescue InterruptedException => ie
            @not_empty.signal # propagate to non-interrupted thread
            raise ie
          end
        end
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    def peek
      lock_ = @lock
      lock_.lock
      begin
        return @q.peek
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Returns the comparator used to order the elements in this queue,
    # or <tt>null</tt> if this queue uses the {@linkplain Comparable
    # natural ordering} of its elements.
    # 
    # @return the comparator used to order the elements in this queue,
    # or <tt>null</tt> if this queue uses the natural
    # ordering of its elements
    def comparator
      return @q.comparator
    end
    
    typesig { [] }
    def size
      lock_ = @lock
      lock_.lock
      begin
        return @q.size
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Always returns <tt>Integer.MAX_VALUE</tt> because
    # a <tt>PriorityBlockingQueue</tt> is not capacity constrained.
    # @return <tt>Integer.MAX_VALUE</tt>
    def remaining_capacity
      return JavaInteger::MAX_VALUE
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
    # @return <tt>true</tt> if this queue changed as a result of the call
    def remove(o)
      lock_ = @lock
      lock_.lock
      begin
        return @q.remove(o)
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Object] }
    # Returns {@code true} if this queue contains the specified element.
    # More formally, returns {@code true} if and only if this queue contains
    # at least one element {@code e} such that {@code o.equals(e)}.
    # 
    # @param o object to be checked for containment in this queue
    # @return <tt>true</tt> if this queue contains the specified element
    def contains(o)
      lock_ = @lock
      lock_.lock
      begin
        return @q.contains(o)
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this queue.
    # The returned array elements are in no particular order.
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
      lock_ = @lock
      lock_.lock
      begin
        return @q.to_array
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    def to_s
      lock_ = @lock
      lock_.lock
      begin
        return @q.to_s
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Collection] }
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    def drain_to(c)
      if ((c).nil?)
        raise NullPointerException.new
      end
      if ((c).equal?(self))
        raise IllegalArgumentException.new
      end
      lock_ = @lock
      lock_.lock
      begin
        n = 0
        e = nil
        while (!((e = @q.poll)).nil?)
          c.add(e)
          (n += 1)
        end
        return n
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Collection, ::Java::Int] }
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    def drain_to(c, max_elements)
      if ((c).nil?)
        raise NullPointerException.new
      end
      if ((c).equal?(self))
        raise IllegalArgumentException.new
      end
      if (max_elements <= 0)
        return 0
      end
      lock_ = @lock
      lock_.lock
      begin
        n = 0
        e = nil
        while (n < max_elements && !((e = @q.poll)).nil?)
          c.add(e)
          (n += 1)
        end
        return n
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Atomically removes all of the elements from this queue.
    # The queue will be empty after this call returns.
    def clear
      lock_ = @lock
      lock_.lock
      begin
        @q.clear
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Returns an array containing all of the elements in this queue; the
    # runtime type of the returned array is that of the specified array.
    # The returned array elements are in no particular order.
    # If the queue fits in the specified array, it is returned therein.
    # Otherwise, a new array is allocated with the runtime type of the
    # specified array and the size of this queue.
    # 
    # <p>If this queue fits in the specified array with room to spare
    # (i.e., the array has more elements than this queue), the element in
    # the array immediately following the end of the queue is set to
    # <tt>null</tt>.
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
    # String[] y = x.toArray(new String[0]);</pre>
    # 
    # Note that <tt>toArray(new Object[0])</tt> is identical in function to
    # <tt>toArray()</tt>.
    # 
    # @param a the array into which the elements of the queue are to
    # be stored, if it is big enough; otherwise, a new array of the
    # same runtime type is allocated for this purpose
    # @return an array containing all of the elements in this queue
    # @throws ArrayStoreException if the runtime type of the specified array
    # is not a supertype of the runtime type of every element in
    # this queue
    # @throws NullPointerException if the specified array is null
    def to_array(a)
      lock_ = @lock
      lock_.lock
      begin
        return @q.to_array(a)
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this queue. The
    # iterator does not return the elements in any particular order.
    # The returned <tt>Iterator</tt> is a "weakly consistent"
    # iterator that will never throw {@link
    # ConcurrentModificationException}, and guarantees to traverse
    # elements as they existed upon construction of the iterator, and
    # may (but is not guaranteed to) reflect any modifications
    # subsequent to construction.
    # 
    # @return an iterator over the elements in this queue
    def iterator
      return Itr.new_local(self, to_array)
    end
    
    class_module.module_eval {
      # Snapshot iterator that works off copy of underlying q array.
      const_set_lazy(:Itr) { Class.new do
        extend LocalClass
        include_class_members PriorityBlockingQueue
        include Iterator
        
        attr_accessor :array
        alias_method :attr_array, :array
        undef_method :array
        alias_method :attr_array=, :array=
        undef_method :array=
        
        # Array of all elements
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        # index of next element to return;
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        typesig { [Array.typed(Object)] }
        # index of last element, or -1 if no such
        def initialize(array)
          @array = nil
          @cursor = 0
          @last_ret = 0
          @last_ret = -1
          @array = array
        end
        
        typesig { [] }
        def has_next
          return @cursor < @array.attr_length
        end
        
        typesig { [] }
        def next_
          if (@cursor >= @array.attr_length)
            raise self.class::NoSuchElementException.new
          end
          @last_ret = @cursor
          return @array[((@cursor += 1) - 1)]
        end
        
        typesig { [] }
        def remove
          if (@last_ret < 0)
            raise self.class::IllegalStateException.new
          end
          x = @array[@last_ret]
          @last_ret = -1
          # Traverse underlying queue to find == element,
          # not just a .equals element.
          self.attr_lock.lock
          begin
            it = self.attr_q.iterator
            while it.has_next
              if ((it.next_).equal?(x))
                it.remove
                return
              end
            end
          ensure
            self.attr_lock.unlock
          end
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Saves the state to a stream (that is, serializes it).  This
    # merely wraps default serialization within lock.  The
    # serialization strategy for items is left to underlying
    # Queue. Note that locking is not needed on deserialization, so
    # readObject is not defined, just relying on default.
    def write_object(s)
      @lock.lock
      begin
        s.default_write_object
      ensure
        @lock.unlock
      end
    end
    
    private
    alias_method :initialize__priority_blocking_queue, :initialize
  end
  
end
