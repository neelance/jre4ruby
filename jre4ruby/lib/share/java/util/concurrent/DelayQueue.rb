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
  module DelayQueueImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util
    }
  end
  
  # An unbounded {@linkplain BlockingQueue blocking queue} of
  # <tt>Delayed</tt> elements, in which an element can only be taken
  # when its delay has expired.  The <em>head</em> of the queue is that
  # <tt>Delayed</tt> element whose delay expired furthest in the
  # past.  If no delay has expired there is no head and <tt>poll</tt>
  # will return <tt>null</tt>. Expiration occurs when an element's
  # <tt>getDelay(TimeUnit.NANOSECONDS)</tt> method returns a value less
  # than or equal to zero.  Even though unexpired elements cannot be
  # removed using <tt>take</tt> or <tt>poll</tt>, they are otherwise
  # treated as normal elements. For example, the <tt>size</tt> method
  # returns the count of both expired and unexpired elements.
  # This queue does not permit null elements.
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
  class DelayQueue < DelayQueueImports.const_get :AbstractQueue
    include_class_members DelayQueueImports
    overload_protected {
      include BlockingQueue
    }
    
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    attr_accessor :available
    alias_method :attr_available, :available
    undef_method :available
    alias_method :attr_available=, :available=
    undef_method :available=
    
    attr_accessor :q
    alias_method :attr_q, :q
    undef_method :q
    alias_method :attr_q=, :q=
    undef_method :q=
    
    typesig { [] }
    # Creates a new <tt>DelayQueue</tt> that is initially empty.
    def initialize
      @lock = nil
      @available = nil
      @q = nil
      super()
      @lock = ReentrantLock.new
      @available = @lock.new_condition
      @q = PriorityQueue.new
    end
    
    typesig { [Collection] }
    # Creates a <tt>DelayQueue</tt> initially containing the elements of the
    # given collection of {@link Delayed} instances.
    # 
    # @param c the collection of elements to initially contain
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def initialize(c)
      @lock = nil
      @available = nil
      @q = nil
      super()
      @lock = ReentrantLock.new
      @available = @lock.new_condition
      @q = PriorityQueue.new
      self.add_all(c)
    end
    
    typesig { [Object] }
    # Inserts the specified element into this delay queue.
    # 
    # @param e the element to add
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    # @throws NullPointerException if the specified element is null
    def add(e)
      return offer(e)
    end
    
    typesig { [Object] }
    # Inserts the specified element into this delay queue.
    # 
    # @param e the element to add
    # @return <tt>true</tt>
    # @throws NullPointerException if the specified element is null
    def offer(e)
      lock = @lock
      lock.lock
      begin
        first = @q.peek
        @q.offer(e)
        if ((first).nil? || (e <=> first) < 0)
          @available.signal_all
        end
        return true
      ensure
        lock.unlock
      end
    end
    
    typesig { [Object] }
    # Inserts the specified element into this delay queue. As the queue is
    # unbounded this method will never block.
    # 
    # @param e the element to add
    # @throws NullPointerException {@inheritDoc}
    def put(e)
      offer(e)
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # Inserts the specified element into this delay queue. As the queue is
    # unbounded this method will never block.
    # 
    # @param e the element to add
    # @param timeout This parameter is ignored as the method never blocks
    # @param unit This parameter is ignored as the method never blocks
    # @return <tt>true</tt>
    # @throws NullPointerException {@inheritDoc}
    def offer(e, timeout, unit)
      return offer(e)
    end
    
    typesig { [] }
    # Retrieves and removes the head of this queue, or returns <tt>null</tt>
    # if this queue has no elements with an expired delay.
    # 
    # @return the head of this queue, or <tt>null</tt> if this
    # queue has no elements with an expired delay
    def poll
      lock_ = @lock
      lock_.lock
      begin
        first = @q.peek
        if ((first).nil? || first.get_delay(TimeUnit::NANOSECONDS) > 0)
          return nil
        else
          x = @q.poll
          raise AssertError if not (!(x).nil?)
          if (!(@q.size).equal?(0))
            @available.signal_all
          end
          return x
        end
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Retrieves and removes the head of this queue, waiting if necessary
    # until an element with an expired delay is available on this queue.
    # 
    # @return the head of this queue
    # @throws InterruptedException {@inheritDoc}
    def take
      lock_ = @lock
      lock_.lock_interruptibly
      begin
        loop do
          first = @q.peek
          if ((first).nil?)
            @available.await
          else
            delay = first.get_delay(TimeUnit::NANOSECONDS)
            if (delay > 0)
              tl = @available.await_nanos(delay)
            else
              x = @q.poll
              raise AssertError if not (!(x).nil?)
              if (!(@q.size).equal?(0))
                @available.signal_all
              end # wake up other takers
              return x
            end
          end
        end
      ensure
        lock_.unlock
      end
    end
    
    typesig { [::Java::Long, TimeUnit] }
    # Retrieves and removes the head of this queue, waiting if necessary
    # until an element with an expired delay is available on this queue,
    # or the specified wait time expires.
    # 
    # @return the head of this queue, or <tt>null</tt> if the
    # specified waiting time elapses before an element with
    # an expired delay becomes available
    # @throws InterruptedException {@inheritDoc}
    def poll(timeout, unit)
      nanos = unit.to_nanos(timeout)
      lock_ = @lock
      lock_.lock_interruptibly
      begin
        loop do
          first = @q.peek
          if ((first).nil?)
            if (nanos <= 0)
              return nil
            else
              nanos = @available.await_nanos(nanos)
            end
          else
            delay = first.get_delay(TimeUnit::NANOSECONDS)
            if (delay > 0)
              if (nanos <= 0)
                return nil
              end
              if (delay > nanos)
                delay = nanos
              end
              time_left = @available.await_nanos(delay)
              nanos -= delay - time_left
            else
              x = @q.poll
              raise AssertError if not (!(x).nil?)
              if (!(@q.size).equal?(0))
                @available.signal_all
              end
              return x
            end
          end
        end
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Retrieves, but does not remove, the head of this queue, or
    # returns <tt>null</tt> if this queue is empty.  Unlike
    # <tt>poll</tt>, if no expired elements are available in the queue,
    # this method returns the element that will expire next,
    # if one exists.
    # 
    # @return the head of this queue, or <tt>null</tt> if this
    # queue is empty.
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
    def size
      lock_ = @lock
      lock_.lock
      begin
        return @q.size
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
        loop do
          first = @q.peek
          if ((first).nil? || first.get_delay(TimeUnit::NANOSECONDS) > 0)
            break
          end
          c.add(@q.poll)
          (n += 1)
        end
        if (n > 0)
          @available.signal_all
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
        while (n < max_elements)
          first = @q.peek
          if ((first).nil? || first.get_delay(TimeUnit::NANOSECONDS) > 0)
            break
          end
          c.add(@q.poll)
          (n += 1)
        end
        if (n > 0)
          @available.signal_all
        end
        return n
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Atomically removes all of the elements from this delay queue.
    # The queue will be empty after this call returns.
    # Elements with an unexpired delay are not waited for; they are
    # simply discarded from the queue.
    def clear
      lock_ = @lock
      lock_.lock
      begin
        @q.clear
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Always returns <tt>Integer.MAX_VALUE</tt> because
    # a <tt>DelayQueue</tt> is not capacity constrained.
    # 
    # @return <tt>Integer.MAX_VALUE</tt>
    def remaining_capacity
      return JavaInteger::MAX_VALUE
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
    
    typesig { [Array.typed(T)] }
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
    # <p>The following code can be used to dump a delay queue into a newly
    # allocated array of <tt>Delayed</tt>:
    # 
    # <pre>
    # Delayed[] a = q.toArray(new Delayed[0]);</pre>
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
    
    typesig { [Object] }
    # Removes a single instance of the specified element from this
    # queue, if it is present, whether or not it has expired.
    def remove(o)
      lock_ = @lock
      lock_.lock
      begin
        return @q.remove(o)
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Returns an iterator over all the elements (both expired and
    # unexpired) in this queue. The iterator does not return the
    # elements in any particular order.  The returned
    # <tt>Iterator</tt> is a "weakly consistent" iterator that will
    # never throw {@link ConcurrentModificationException}, and
    # guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed
    # to) reflect any modifications subsequent to construction.
    # 
    # @return an iterator over the elements in this queue
    def iterator
      return Itr.new_local(self, to_array)
    end
    
    class_module.module_eval {
      # Snapshot iterator that works off copy of underlying q array.
      const_set_lazy(:Itr) { Class.new do
        extend LocalClass
        include_class_members DelayQueue
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
    
    private
    alias_method :initialize__delay_queue, :initialize
  end
  
end
