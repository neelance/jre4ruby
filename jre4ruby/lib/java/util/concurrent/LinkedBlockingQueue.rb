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
  module LinkedBlockingQueueImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Atomic
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util
    }
  end
  
  # An optionally-bounded {@linkplain BlockingQueue blocking queue} based on
  # linked nodes.
  # This queue orders elements FIFO (first-in-first-out).
  # The <em>head</em> of the queue is that element that has been on the
  # queue the longest time.
  # The <em>tail</em> of the queue is that element that has been on the
  # queue the shortest time. New elements
  # are inserted at the tail of the queue, and the queue retrieval
  # operations obtain elements at the head of the queue.
  # Linked queues typically have higher throughput than array-based queues but
  # less predictable performance in most concurrent applications.
  # 
  # <p> The optional capacity bound constructor argument serves as a
  # way to prevent excessive queue expansion. The capacity, if unspecified,
  # is equal to {@link Integer#MAX_VALUE}.  Linked nodes are
  # dynamically created upon each insertion unless this would bring the
  # queue above capacity.
  # 
  # <p>This class and its iterator implement all of the
  # <em>optional</em> methods of the {@link Collection} and {@link
  # Iterator} interfaces.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <E> the type of elements held in this collection
  class LinkedBlockingQueue < LinkedBlockingQueueImports.const_get :AbstractQueue
    include_class_members LinkedBlockingQueueImports
    include BlockingQueue
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -6903933977591709194 }
      const_attr_reader  :SerialVersionUID
      
      # A variant of the "two lock queue" algorithm.  The putLock gates
      # entry to put (and offer), and has an associated condition for
      # waiting puts.  Similarly for the takeLock.  The "count" field
      # that they both rely on is maintained as an atomic to avoid
      # needing to get both locks in most cases. Also, to minimize need
      # for puts to get takeLock and vice-versa, cascading notifies are
      # used. When a put notices that it has enabled at least one take,
      # it signals taker. That taker in turn signals others if more
      # items have been entered since the signal. And symmetrically for
      # takes signalling puts. Operations such as remove(Object) and
      # iterators acquire both locks.
      # 
      # 
      # Linked list node class
      const_set_lazy(:Node) { Class.new do
        include_class_members LinkedBlockingQueue
        
        # The item, volatile to ensure barrier separating write and read
        attr_accessor :item
        alias_method :attr_item, :item
        undef_method :item
        alias_method :attr_item=, :item=
        undef_method :item=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        typesig { [Object] }
        def initialize(x)
          @item = nil
          @next = nil
          @item = x
        end
        
        private
        alias_method :initialize__node, :initialize
      end }
    }
    
    # The capacity bound, or Integer.MAX_VALUE if none
    attr_accessor :capacity
    alias_method :attr_capacity, :capacity
    undef_method :capacity
    alias_method :attr_capacity=, :capacity=
    undef_method :capacity=
    
    # Current number of elements
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # Head of linked list
    attr_accessor :head
    alias_method :attr_head, :head
    undef_method :head
    alias_method :attr_head=, :head=
    undef_method :head=
    
    # Tail of linked list
    attr_accessor :last
    alias_method :attr_last, :last
    undef_method :last
    alias_method :attr_last=, :last=
    undef_method :last=
    
    # Lock held by take, poll, etc
    attr_accessor :take_lock
    alias_method :attr_take_lock, :take_lock
    undef_method :take_lock
    alias_method :attr_take_lock=, :take_lock=
    undef_method :take_lock=
    
    # Wait queue for waiting takes
    attr_accessor :not_empty
    alias_method :attr_not_empty, :not_empty
    undef_method :not_empty
    alias_method :attr_not_empty=, :not_empty=
    undef_method :not_empty=
    
    # Lock held by put, offer, etc
    attr_accessor :put_lock
    alias_method :attr_put_lock, :put_lock
    undef_method :put_lock
    alias_method :attr_put_lock=, :put_lock=
    undef_method :put_lock=
    
    # Wait queue for waiting puts
    attr_accessor :not_full
    alias_method :attr_not_full, :not_full
    undef_method :not_full
    alias_method :attr_not_full=, :not_full=
    undef_method :not_full=
    
    typesig { [] }
    # Signals a waiting take. Called only from put/offer (which do not
    # otherwise ordinarily lock takeLock.)
    def signal_not_empty
      take_lock = @take_lock
      take_lock.lock
      begin
        @not_empty.signal
      ensure
        take_lock.unlock
      end
    end
    
    typesig { [] }
    # Signals a waiting put. Called only from take/poll.
    def signal_not_full
      put_lock = @put_lock
      put_lock.lock
      begin
        @not_full.signal
      ensure
        put_lock.unlock
      end
    end
    
    typesig { [Object] }
    # Creates a node and links it at end of queue.
    # @param x the item
    def insert(x)
      @last = @last.attr_next = Node.new(x)
    end
    
    typesig { [] }
    # Removes a node from head of queue,
    # @return the node
    def extract
      first = @head.attr_next
      @head = first
      x = first.attr_item
      first.attr_item = nil
      return x
    end
    
    typesig { [] }
    # Lock to prevent both puts and takes.
    def fully_lock
      @put_lock.lock
      @take_lock.lock
    end
    
    typesig { [] }
    # Unlock to allow both puts and takes.
    def fully_unlock
      @take_lock.unlock
      @put_lock.unlock
    end
    
    typesig { [] }
    # Creates a <tt>LinkedBlockingQueue</tt> with a capacity of
    # {@link Integer#MAX_VALUE}.
    def initialize
      initialize__linked_blocking_queue(JavaInteger::MAX_VALUE)
    end
    
    typesig { [::Java::Int] }
    # Creates a <tt>LinkedBlockingQueue</tt> with the given (fixed) capacity.
    # 
    # @param capacity the capacity of this queue
    # @throws IllegalArgumentException if <tt>capacity</tt> is not greater
    # than zero
    def initialize(capacity)
      @capacity = 0
      @count = nil
      @head = nil
      @last = nil
      @take_lock = nil
      @not_empty = nil
      @put_lock = nil
      @not_full = nil
      super()
      @count = AtomicInteger.new(0)
      @take_lock = ReentrantLock.new
      @not_empty = @take_lock.new_condition
      @put_lock = ReentrantLock.new
      @not_full = @put_lock.new_condition
      if (capacity <= 0)
        raise IllegalArgumentException.new
      end
      @capacity = capacity
      @last = @head = Node.new(nil)
    end
    
    typesig { [Collection] }
    # Creates a <tt>LinkedBlockingQueue</tt> with a capacity of
    # {@link Integer#MAX_VALUE}, initially containing the elements of the
    # given collection,
    # added in traversal order of the collection's iterator.
    # 
    # @param c the collection of elements to initially contain
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def initialize(c)
      initialize__linked_blocking_queue(JavaInteger::MAX_VALUE)
      c.each do |e|
        add(e)
      end
    end
    
    typesig { [] }
    # this doc comment is overridden to remove the reference to collections
    # greater in size than Integer.MAX_VALUE
    # 
    # Returns the number of elements in this queue.
    # 
    # @return the number of elements in this queue
    def size
      return @count.get
    end
    
    typesig { [] }
    # this doc comment is a modified copy of the inherited doc comment,
    # without the reference to unlimited queues.
    # 
    # Returns the number of additional elements that this queue can ideally
    # (in the absence of memory or resource constraints) accept without
    # blocking. This is always equal to the initial capacity of this queue
    # less the current <tt>size</tt> of this queue.
    # 
    # <p>Note that you <em>cannot</em> always tell if an attempt to insert
    # an element will succeed by inspecting <tt>remainingCapacity</tt>
    # because it may be the case that another thread is about to
    # insert or remove an element.
    def remaining_capacity
      return @capacity - @count.get
    end
    
    typesig { [Object] }
    # Inserts the specified element at the tail of this queue, waiting if
    # necessary for space to become available.
    # 
    # @throws InterruptedException {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def put(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      # Note: convention in all put/take/etc is to preset
      # local var holding count  negative to indicate failure unless set.
      c = -1
      put_lock = @put_lock
      count = @count
      put_lock.lock_interruptibly
      begin
        # Note that count is used in wait guard even though it is
        # not protected by lock. This works because count can
        # only decrease at this point (all other puts are shut
        # out by lock), and we (or some other waiting put) are
        # signalled if it ever changes from
        # capacity. Similarly for all other uses of count in
        # other wait guards.
        begin
          while ((count.get).equal?(@capacity))
            @not_full.await
          end
        rescue InterruptedException => ie
          @not_full.signal # propagate to a non-interrupted thread
          raise ie
        end
        insert(e)
        c = count.get_and_increment
        if (c + 1 < @capacity)
          @not_full.signal
        end
      ensure
        put_lock.unlock
      end
      if ((c).equal?(0))
        signal_not_empty
      end
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # Inserts the specified element at the tail of this queue, waiting if
    # necessary up to the specified wait time for space to become available.
    # 
    # @return <tt>true</tt> if successful, or <tt>false</tt> if
    # the specified waiting time elapses before space is available.
    # @throws InterruptedException {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def offer(e, timeout, unit)
      if ((e).nil?)
        raise NullPointerException.new
      end
      nanos = unit.to_nanos(timeout)
      c = -1
      put_lock = @put_lock
      count = @count
      put_lock.lock_interruptibly
      begin
        loop do
          if (count.get < @capacity)
            insert(e)
            c = count.get_and_increment
            if (c + 1 < @capacity)
              @not_full.signal
            end
            break
          end
          if (nanos <= 0)
            return false
          end
          begin
            nanos = @not_full.await_nanos(nanos)
          rescue InterruptedException => ie
            @not_full.signal # propagate to a non-interrupted thread
            raise ie
          end
        end
      ensure
        put_lock.unlock
      end
      if ((c).equal?(0))
        signal_not_empty
      end
      return true
    end
    
    typesig { [Object] }
    # Inserts the specified element at the tail of this queue if it is
    # possible to do so immediately without exceeding the queue's capacity,
    # returning <tt>true</tt> upon success and <tt>false</tt> if this queue
    # is full.
    # When using a capacity-restricted queue, this method is generally
    # preferable to method {@link BlockingQueue#add add}, which can fail to
    # insert an element only by throwing an exception.
    # 
    # @throws NullPointerException if the specified element is null
    def offer(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      count = @count
      if ((count.get).equal?(@capacity))
        return false
      end
      c = -1
      put_lock = @put_lock
      put_lock.lock
      begin
        if (count.get < @capacity)
          insert(e)
          c = count.get_and_increment
          if (c + 1 < @capacity)
            @not_full.signal
          end
        end
      ensure
        put_lock.unlock
      end
      if ((c).equal?(0))
        signal_not_empty
      end
      return c >= 0
    end
    
    typesig { [] }
    def take
      x = nil
      c = -1
      count = @count
      take_lock = @take_lock
      take_lock.lock_interruptibly
      begin
        begin
          while ((count.get).equal?(0))
            @not_empty.await
          end
        rescue InterruptedException => ie
          @not_empty.signal # propagate to a non-interrupted thread
          raise ie
        end
        x = extract
        c = count.get_and_decrement
        if (c > 1)
          @not_empty.signal
        end
      ensure
        take_lock.unlock
      end
      if ((c).equal?(@capacity))
        signal_not_full
      end
      return x
    end
    
    typesig { [::Java::Long, TimeUnit] }
    def poll(timeout, unit)
      x = nil
      c = -1
      nanos = unit.to_nanos(timeout)
      count = @count
      take_lock = @take_lock
      take_lock.lock_interruptibly
      begin
        loop do
          if (count.get > 0)
            x = extract
            c = count.get_and_decrement
            if (c > 1)
              @not_empty.signal
            end
            break
          end
          if (nanos <= 0)
            return nil
          end
          begin
            nanos = @not_empty.await_nanos(nanos)
          rescue InterruptedException => ie
            @not_empty.signal # propagate to a non-interrupted thread
            raise ie
          end
        end
      ensure
        take_lock.unlock
      end
      if ((c).equal?(@capacity))
        signal_not_full
      end
      return x
    end
    
    typesig { [] }
    def poll
      count = @count
      if ((count.get).equal?(0))
        return nil
      end
      x = nil
      c = -1
      take_lock = @take_lock
      take_lock.lock
      begin
        if (count.get > 0)
          x = extract
          c = count.get_and_decrement
          if (c > 1)
            @not_empty.signal
          end
        end
      ensure
        take_lock.unlock
      end
      if ((c).equal?(@capacity))
        signal_not_full
      end
      return x
    end
    
    typesig { [] }
    def peek
      if ((@count.get).equal?(0))
        return nil
      end
      take_lock = @take_lock
      take_lock.lock
      begin
        first = @head.attr_next
        if ((first).nil?)
          return nil
        else
          return first.attr_item
        end
      ensure
        take_lock.unlock
      end
    end
    
    typesig { [Object] }
    # Removes a single instance of the specified element from this queue,
    # if it is present.  More formally, removes an element <tt>e</tt> such
    # that <tt>o.equals(e)</tt>, if this queue contains one or more such
    # elements.
    # Returns <tt>true</tt> if this queue contained the specified element
    # (or equivalently, if this queue changed as a result of the call).
    # 
    # @param o element to be removed from this queue, if present
    # @return <tt>true</tt> if this queue changed as a result of the call
    def remove(o)
      if ((o).nil?)
        return false
      end
      removed = false
      fully_lock
      begin
        trail = @head
        p = @head.attr_next
        while (!(p).nil?)
          if ((o == p.attr_item))
            removed = true
            break
          end
          trail = p
          p = p.attr_next
        end
        if (removed)
          p.attr_item = nil
          trail.attr_next = p.attr_next
          if ((@last).equal?(p))
            @last = trail
          end
          if ((@count.get_and_decrement).equal?(@capacity))
            @not_full.signal_all
          end
        end
      ensure
        fully_unlock
      end
      return removed
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this queue, in
    # proper sequence.
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
      fully_lock
      begin
        size = @count.get
        a = Array.typed(Object).new(size) { nil }
        k = 0
        p = @head.attr_next
        while !(p).nil?
          a[((k += 1) - 1)] = p.attr_item
          p = p.attr_next
        end
        return a
      ensure
        fully_unlock
      end
    end
    
    typesig { [Array.typed(T)] }
    # Returns an array containing all of the elements in this queue, in
    # proper sequence; the runtime type of the returned array is that of
    # the specified array.  If the queue fits in the specified array, it
    # is returned therein.  Otherwise, a new array is allocated with the
    # runtime type of the specified array and the size of this queue.
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
      fully_lock
      begin
        size = @count.get
        if (a.attr_length < size)
          a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, size)
        end
        k = 0
        p = @head.attr_next
        while !(p).nil?
          a[((k += 1) - 1)] = p.attr_item
          p = p.attr_next
        end
        if (a.attr_length > k)
          a[k] = nil
        end
        return a
      ensure
        fully_unlock
      end
    end
    
    typesig { [] }
    def to_s
      fully_lock
      begin
        return super
      ensure
        fully_unlock
      end
    end
    
    typesig { [] }
    # Atomically removes all of the elements from this queue.
    # The queue will be empty after this call returns.
    def clear
      fully_lock
      begin
        @head.attr_next = nil
        raise AssertError if not ((@head.attr_item).nil?)
        @last = @head
        if ((@count.get_and_set(0)).equal?(@capacity))
          @not_full.signal_all
        end
      ensure
        fully_unlock
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
      first = nil
      fully_lock
      begin
        first = @head.attr_next
        @head.attr_next = nil
        raise AssertError if not ((@head.attr_item).nil?)
        @last = @head
        if ((@count.get_and_set(0)).equal?(@capacity))
          @not_full.signal_all
        end
      ensure
        fully_unlock
      end
      # Transfer the elements outside of locks
      n = 0
      p = first
      while !(p).nil?
        c.add(p.attr_item)
        p.attr_item = nil
        (n += 1)
        p = p.attr_next
      end
      return n
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
      fully_lock
      begin
        n = 0
        p = @head.attr_next
        while (!(p).nil? && n < max_elements)
          c.add(p.attr_item)
          p.attr_item = nil
          p = p.attr_next
          (n += 1)
        end
        if (!(n).equal?(0))
          @head.attr_next = p
          raise AssertError if not ((@head.attr_item).nil?)
          if ((p).nil?)
            @last = @head
          end
          if ((@count.get_and_add(-n)).equal?(@capacity))
            @not_full.signal_all
          end
        end
        return n
      ensure
        fully_unlock
      end
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this queue in proper sequence.
    # The returned <tt>Iterator</tt> is a "weakly consistent" iterator that
    # will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    # 
    # @return an iterator over the elements in this queue in proper sequence
    def iterator
      return Itr.new_local(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:Itr) { Class.new do
        extend LocalClass
        include_class_members LinkedBlockingQueue
        include Iterator
        
        # Basic weak-consistent iterator.  At all times hold the next
        # item to hand out so that if hasNext() reports true, we will
        # still have it to return even if lost race with a take etc.
        attr_accessor :current
        alias_method :attr_current, :current
        undef_method :current
        alias_method :attr_current=, :current=
        undef_method :current=
        
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        attr_accessor :current_element
        alias_method :attr_current_element, :current_element
        undef_method :current_element
        alias_method :attr_current_element=, :current_element=
        undef_method :current_element=
        
        typesig { [] }
        def initialize
          @current = nil
          @last_ret = nil
          @current_element = nil
          put_lock = @local_class_parent.attr_put_lock
          take_lock = @local_class_parent.attr_take_lock
          put_lock.lock
          take_lock.lock
          begin
            @current = self.attr_head.attr_next
            if (!(@current).nil?)
              @current_element = @current.attr_item
            end
          ensure
            take_lock.unlock
            put_lock.unlock
          end
        end
        
        typesig { [] }
        def has_next
          return !(@current).nil?
        end
        
        typesig { [] }
        def next
          put_lock = @local_class_parent.attr_put_lock
          take_lock = @local_class_parent.attr_take_lock
          put_lock.lock
          take_lock.lock
          begin
            if ((@current).nil?)
              raise NoSuchElementException.new
            end
            x = @current_element
            @last_ret = @current
            @current = @current.attr_next
            if (!(@current).nil?)
              @current_element = @current.attr_item
            end
            return x
          ensure
            take_lock.unlock
            put_lock.unlock
          end
        end
        
        typesig { [] }
        def remove
          if ((@last_ret).nil?)
            raise IllegalStateException.new
          end
          put_lock = @local_class_parent.attr_put_lock
          take_lock = @local_class_parent.attr_take_lock
          put_lock.lock
          take_lock.lock
          begin
            node = @last_ret
            @last_ret = nil
            trail = self.attr_head
            p = self.attr_head.attr_next
            while (!(p).nil? && !(p).equal?(node))
              trail = p
              p = p.attr_next
            end
            if ((p).equal?(node))
              p.attr_item = nil
              trail.attr_next = p.attr_next
              if ((self.attr_last).equal?(p))
                self.attr_last = trail
              end
              c = self.attr_count.get_and_decrement
              if ((c).equal?(self.attr_capacity))
                self.attr_not_full.signal_all
              end
            end
          ensure
            take_lock.unlock
            put_lock.unlock
          end
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state to a stream (that is, serialize it).
    # 
    # @serialData The capacity is emitted (int), followed by all of
    # its elements (each an <tt>Object</tt>) in the proper order,
    # followed by a null
    # @param s the stream
    def write_object(s)
      fully_lock
      begin
        # Write out any hidden stuff, plus capacity
        s.default_write_object
        # Write out all elements in the proper order.
        p = @head.attr_next
        while !(p).nil?
          s.write_object(p.attr_item)
          p = p.attr_next
        end
        # Use trailing null as sentinel
        s.write_object(nil)
      ensure
        fully_unlock
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute this queue instance from a stream (that is,
    # deserialize it).
    # @param s the stream
    def read_object(s)
      # Read in capacity, and any hidden stuff
      s.default_read_object
      @count.set(0)
      @last = @head = Node.new(nil)
      # Read in all elements and place in queue
      loop do
        item = s.read_object
        if ((item).nil?)
          break
        end
        add(item)
      end
    end
    
    private
    alias_method :initialize__linked_blocking_queue, :initialize
  end
  
end
