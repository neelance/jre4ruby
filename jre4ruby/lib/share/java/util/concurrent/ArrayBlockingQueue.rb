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
  module ArrayBlockingQueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util
    }
  end
  
  # A bounded {@linkplain BlockingQueue blocking queue} backed by an
  # array.  This queue orders elements FIFO (first-in-first-out).  The
  # <em>head</em> of the queue is that element that has been on the
  # queue the longest time.  The <em>tail</em> of the queue is that
  # element that has been on the queue the shortest time. New elements
  # are inserted at the tail of the queue, and the queue retrieval
  # operations obtain elements at the head of the queue.
  # 
  # <p>This is a classic &quot;bounded buffer&quot;, in which a
  # fixed-sized array holds elements inserted by producers and
  # extracted by consumers.  Once created, the capacity cannot be
  # increased.  Attempts to <tt>put</tt> an element into a full queue
  # will result in the operation blocking; attempts to <tt>take</tt> an
  # element from an empty queue will similarly block.
  # 
  # <p> This class supports an optional fairness policy for ordering
  # waiting producer and consumer threads.  By default, this ordering
  # is not guaranteed. However, a queue constructed with fairness set
  # to <tt>true</tt> grants threads access in FIFO order. Fairness
  # generally decreases throughput but reduces variability and avoids
  # starvation.
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
  class ArrayBlockingQueue < ArrayBlockingQueueImports.const_get :AbstractQueue
    include_class_members ArrayBlockingQueueImports
    overload_protected {
      include BlockingQueue
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      # Serialization ID. This class relies on default serialization
      # even for the items array, which is default-serialized, even if
      # it is empty. Otherwise it could not be declared final, which is
      # necessary here.
      const_set_lazy(:SerialVersionUID) { -817911632652898426 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The queued items
    attr_accessor :items
    alias_method :attr_items, :items
    undef_method :items
    alias_method :attr_items=, :items=
    undef_method :items=
    
    # items index for next take, poll or remove
    attr_accessor :take_index
    alias_method :attr_take_index, :take_index
    undef_method :take_index
    alias_method :attr_take_index=, :take_index=
    undef_method :take_index=
    
    # items index for next put, offer, or add.
    attr_accessor :put_index
    alias_method :attr_put_index, :put_index
    undef_method :put_index
    alias_method :attr_put_index=, :put_index=
    undef_method :put_index=
    
    # Number of items in the queue
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # Concurrency control uses the classic two-condition algorithm
    # found in any textbook.
    # 
    # Main lock guarding all access
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    # Condition for waiting takes
    attr_accessor :not_empty
    alias_method :attr_not_empty, :not_empty
    undef_method :not_empty
    alias_method :attr_not_empty=, :not_empty=
    undef_method :not_empty=
    
    # Condition for waiting puts
    attr_accessor :not_full
    alias_method :attr_not_full, :not_full
    undef_method :not_full
    alias_method :attr_not_full=, :not_full=
    undef_method :not_full=
    
    typesig { [::Java::Int] }
    # Internal helper methods
    # 
    # Circularly increment i.
    def inc(i)
      return (((i += 1)).equal?(@items.attr_length)) ? 0 : i
    end
    
    typesig { [Object] }
    # Inserts element at current put position, advances, and signals.
    # Call only when holding lock.
    def insert(x)
      @items[@put_index] = x
      @put_index = inc(@put_index)
      (@count += 1)
      @not_empty.signal
    end
    
    typesig { [] }
    # Extracts element at current take position, advances, and signals.
    # Call only when holding lock.
    def extract
      items = @items
      x = items[@take_index]
      items[@take_index] = nil
      @take_index = inc(@take_index)
      (@count -= 1)
      @not_full.signal
      return x
    end
    
    typesig { [::Java::Int] }
    # Utility for remove and iterator.remove: Delete item at position i.
    # Call only when holding lock.
    def remove_at(i)
      items = @items
      # if removing front item, just advance
      if ((i).equal?(@take_index))
        items[@take_index] = nil
        @take_index = inc(@take_index)
      else
        # slide over all others up through putIndex.
        loop do
          nexti = inc(i)
          if (!(nexti).equal?(@put_index))
            items[i] = items[nexti]
            i = nexti
          else
            items[i] = nil
            @put_index = i
            break
          end
        end
      end
      (@count -= 1)
      @not_full.signal
    end
    
    typesig { [::Java::Int] }
    # Creates an <tt>ArrayBlockingQueue</tt> with the given (fixed)
    # capacity and default access policy.
    # 
    # @param capacity the capacity of this queue
    # @throws IllegalArgumentException if <tt>capacity</tt> is less than 1
    def initialize(capacity)
      initialize__array_blocking_queue(capacity, false)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Creates an <tt>ArrayBlockingQueue</tt> with the given (fixed)
    # capacity and the specified access policy.
    # 
    # @param capacity the capacity of this queue
    # @param fair if <tt>true</tt> then queue accesses for threads blocked
    # on insertion or removal, are processed in FIFO order;
    # if <tt>false</tt> the access order is unspecified.
    # @throws IllegalArgumentException if <tt>capacity</tt> is less than 1
    def initialize(capacity, fair)
      @items = nil
      @take_index = 0
      @put_index = 0
      @count = 0
      @lock = nil
      @not_empty = nil
      @not_full = nil
      super()
      if (capacity <= 0)
        raise IllegalArgumentException.new
      end
      @items = Array.typed(Object).new(capacity) { nil }
      @lock = ReentrantLock.new(fair)
      @not_empty = @lock.new_condition
      @not_full = @lock.new_condition
    end
    
    typesig { [::Java::Int, ::Java::Boolean, Collection] }
    # Creates an <tt>ArrayBlockingQueue</tt> with the given (fixed)
    # capacity, the specified access policy and initially containing the
    # elements of the given collection,
    # added in traversal order of the collection's iterator.
    # 
    # @param capacity the capacity of this queue
    # @param fair if <tt>true</tt> then queue accesses for threads blocked
    # on insertion or removal, are processed in FIFO order;
    # if <tt>false</tt> the access order is unspecified.
    # @param c the collection of elements to initially contain
    # @throws IllegalArgumentException if <tt>capacity</tt> is less than
    # <tt>c.size()</tt>, or less than 1.
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def initialize(capacity, fair, c)
      initialize__array_blocking_queue(capacity, fair)
      if (capacity < c.size)
        raise IllegalArgumentException.new
      end
      it = c.iterator
      while it.has_next
        add(it.next_)
      end
    end
    
    typesig { [Object] }
    # Inserts the specified element at the tail of this queue if it is
    # possible to do so immediately without exceeding the queue's capacity,
    # returning <tt>true</tt> upon success and throwing an
    # <tt>IllegalStateException</tt> if this queue is full.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    # @throws IllegalStateException if this queue is full
    # @throws NullPointerException if the specified element is null
    def add(e)
      return super(e)
    end
    
    typesig { [Object] }
    # Inserts the specified element at the tail of this queue if it is
    # possible to do so immediately without exceeding the queue's capacity,
    # returning <tt>true</tt> upon success and <tt>false</tt> if this queue
    # is full.  This method is generally preferable to method {@link #add},
    # which can fail to insert an element only by throwing an exception.
    # 
    # @throws NullPointerException if the specified element is null
    def offer(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      lock = @lock
      lock.lock
      begin
        if ((@count).equal?(@items.attr_length))
          return false
        else
          insert(e)
          return true
        end
      ensure
        lock.unlock
      end
    end
    
    typesig { [Object] }
    # Inserts the specified element at the tail of this queue, waiting
    # for space to become available if the queue is full.
    # 
    # @throws InterruptedException {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def put(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      items = @items
      lock_ = @lock
      lock_.lock_interruptibly
      begin
        begin
          while ((@count).equal?(items.attr_length))
            @not_full.await
          end
        rescue InterruptedException => ie
          @not_full.signal # propagate to non-interrupted thread
          raise ie
        end
        insert(e)
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # Inserts the specified element at the tail of this queue, waiting
    # up to the specified wait time for space to become available if
    # the queue is full.
    # 
    # @throws InterruptedException {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def offer(e, timeout, unit)
      if ((e).nil?)
        raise NullPointerException.new
      end
      nanos = unit.to_nanos(timeout)
      lock_ = @lock
      lock_.lock_interruptibly
      begin
        loop do
          if (!(@count).equal?(@items.attr_length))
            insert(e)
            return true
          end
          if (nanos <= 0)
            return false
          end
          begin
            nanos = @not_full.await_nanos(nanos)
          rescue InterruptedException => ie
            @not_full.signal # propagate to non-interrupted thread
            raise ie
          end
        end
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    def poll
      lock_ = @lock
      lock_.lock
      begin
        if ((@count).equal?(0))
          return nil
        end
        x = extract
        return x
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
          while ((@count).equal?(0))
            @not_empty.await
          end
        rescue InterruptedException => ie
          @not_empty.signal # propagate to non-interrupted thread
          raise ie
        end
        x = extract
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
          if (!(@count).equal?(0))
            x = extract
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
        return ((@count).equal?(0)) ? nil : @items[@take_index]
      ensure
        lock_.unlock
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
      lock_ = @lock
      lock_.lock
      begin
        return @count
      ensure
        lock_.unlock
      end
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
      lock_ = @lock
      lock_.lock
      begin
        return @items.attr_length - @count
      ensure
        lock_.unlock
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
      items = @items
      lock_ = @lock
      lock_.lock
      begin
        i = @take_index
        k = 0
        loop do
          if (((k += 1) - 1) >= @count)
            return false
          end
          if ((o == items[i]))
            remove_at(i)
            return true
          end
          i = inc(i)
        end
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this queue contains the specified element.
    # More formally, returns <tt>true</tt> if and only if this queue contains
    # at least one element <tt>e</tt> such that <tt>o.equals(e)</tt>.
    # 
    # @param o object to be checked for containment in this queue
    # @return <tt>true</tt> if this queue contains the specified element
    def contains(o)
      if ((o).nil?)
        return false
      end
      items = @items
      lock_ = @lock
      lock_.lock
      begin
        i = @take_index
        k = 0
        while (((k += 1) - 1) < @count)
          if ((o == items[i]))
            return true
          end
          i = inc(i)
        end
        return false
      ensure
        lock_.unlock
      end
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
      items = @items
      lock_ = @lock
      lock_.lock
      begin
        a = Array.typed(Object).new(@count) { nil }
        k = 0
        i = @take_index
        while (k < @count)
          a[((k += 1) - 1)] = items[i]
          i = inc(i)
        end
        return a
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Array.typed(Object)] }
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
      items = @items
      lock_ = @lock
      lock_.lock
      begin
        if (a.attr_length < @count)
          a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, @count)
        end
        k = 0
        i = @take_index
        while (k < @count)
          a[((k += 1) - 1)] = items[i]
          i = inc(i)
        end
        if (a.attr_length > @count)
          a[@count] = nil
        end
        return a
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    def to_s
      lock_ = @lock
      lock_.lock
      begin
        return super
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Atomically removes all of the elements from this queue.
    # The queue will be empty after this call returns.
    def clear
      items = @items
      lock_ = @lock
      lock_.lock
      begin
        i = @take_index
        k = @count
        while (((k -= 1) + 1) > 0)
          items[i] = nil
          i = inc(i)
        end
        @count = 0
        @put_index = 0
        @take_index = 0
        @not_full.signal_all
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
      items = @items
      lock_ = @lock
      lock_.lock
      begin
        i = @take_index
        n = 0
        max = @count
        while (n < max)
          c.add(items[i])
          items[i] = nil
          i = inc(i)
          (n += 1)
        end
        if (n > 0)
          @count = 0
          @put_index = 0
          @take_index = 0
          @not_full.signal_all
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
      items = @items
      lock_ = @lock
      lock_.lock
      begin
        i = @take_index
        n = 0
        sz = @count
        max = (max_elements < @count) ? max_elements : @count
        while (n < max)
          c.add(items[i])
          items[i] = nil
          i = inc(i)
          (n += 1)
        end
        if (n > 0)
          @count -= n
          @take_index = i
          @not_full.signal_all
        end
        return n
      ensure
        lock_.unlock
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
      lock_ = @lock
      lock_.lock
      begin
        return Itr.new_local(self)
      ensure
        lock_.unlock
      end
    end
    
    class_module.module_eval {
      # Iterator for ArrayBlockingQueue
      const_set_lazy(:Itr) { Class.new do
        local_class_in ArrayBlockingQueue
        include_class_members ArrayBlockingQueue
        include Iterator
        
        # Index of element to be returned by next,
        # or a negative number if no such.
        attr_accessor :next_index
        alias_method :attr_next_index, :next_index
        undef_method :next_index
        alias_method :attr_next_index=, :next_index=
        undef_method :next_index=
        
        # nextItem holds on to item fields because once we claim
        # that an element exists in hasNext(), we must return it in
        # the following next() call even if it was in the process of
        # being removed when hasNext() was called.
        attr_accessor :next_item
        alias_method :attr_next_item, :next_item
        undef_method :next_item
        alias_method :attr_next_item=, :next_item=
        undef_method :next_item=
        
        # Index of element returned by most recent call to next.
        # Reset to -1 if this element is deleted by a call to remove.
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        typesig { [] }
        def initialize
          @next_index = 0
          @next_item = nil
          @last_ret = 0
          @last_ret = -1
          if ((self.attr_count).equal?(0))
            @next_index = -1
          else
            @next_index = self.attr_take_index
            @next_item = self.attr_items[self.attr_take_index]
          end
        end
        
        typesig { [] }
        def has_next
          # No sync. We can return true by mistake here
          # only if this iterator passed across threads,
          # which we don't support anyway.
          return @next_index >= 0
        end
        
        typesig { [] }
        # Checks whether nextIndex is valid; if so setting nextItem.
        # Stops iterator when either hits putIndex or sees null item.
        def check_next
          if ((@next_index).equal?(self.attr_put_index))
            @next_index = -1
            @next_item = nil
          else
            @next_item = self.attr_items[@next_index]
            if ((@next_item).nil?)
              @next_index = -1
            end
          end
        end
        
        typesig { [] }
        def next_
          lock = @local_class_parent.attr_lock
          lock.lock
          begin
            if (@next_index < 0)
              raise self.class::NoSuchElementException.new
            end
            @last_ret = @next_index
            x = @next_item
            @next_index = inc(@next_index)
            check_next
            return x
          ensure
            lock.unlock
          end
        end
        
        typesig { [] }
        def remove
          lock_ = @local_class_parent.attr_lock
          lock_.lock
          begin
            i = @last_ret
            if ((i).equal?(-1))
              raise self.class::IllegalStateException.new
            end
            @last_ret = -1
            ti = self.attr_take_index
            remove_at(i)
            # back up cursor (reset to front if was first element)
            @next_index = ((i).equal?(ti)) ? self.attr_take_index : i
            check_next
          ensure
            lock_.unlock
          end
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
    }
    
    private
    alias_method :initialize__array_blocking_queue, :initialize
  end
  
end
