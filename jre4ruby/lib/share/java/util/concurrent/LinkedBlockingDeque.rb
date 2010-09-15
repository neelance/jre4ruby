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
  module LinkedBlockingDequeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
      include ::Java::Util::Concurrent::Locks
    }
  end
  
  # An optionally-bounded {@linkplain BlockingDeque blocking deque} based on
  # linked nodes.
  # 
  # <p> The optional capacity bound constructor argument serves as a
  # way to prevent excessive expansion. The capacity, if unspecified,
  # is equal to {@link Integer#MAX_VALUE}.  Linked nodes are
  # dynamically created upon each insertion unless this would bring the
  # deque above capacity.
  # 
  # <p>Most operations run in constant time (ignoring time spent
  # blocking).  Exceptions include {@link #remove(Object) remove},
  # {@link #removeFirstOccurrence removeFirstOccurrence}, {@link
  # #removeLastOccurrence removeLastOccurrence}, {@link #contains
  # contains}, {@link #iterator iterator.remove()}, and the bulk
  # operations, all of which run in linear time.
  # 
  # <p>This class and its iterator implement all of the
  # <em>optional</em> methods of the {@link Collection} and {@link
  # Iterator} interfaces.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.6
  # @author  Doug Lea
  # @param <E> the type of elements held in this collection
  class LinkedBlockingDeque < LinkedBlockingDequeImports.const_get :AbstractQueue
    include_class_members LinkedBlockingDequeImports
    overload_protected {
      include BlockingDeque
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      # Implemented as a simple doubly-linked list protected by a
      # single lock and using conditions to manage blocking.
      # 
      # 
      # We have "diamond" multiple interface/abstract class inheritance
      # here, and that introduces ambiguities. Often we want the
      # BlockingDeque javadoc combined with the AbstractQueue
      # implementation, so a lot of method specs are duplicated here.
      const_set_lazy(:SerialVersionUID) { -387911632671998426 }
      const_attr_reader  :SerialVersionUID
      
      # Doubly-linked list node class
      const_set_lazy(:Node) { Class.new do
        include_class_members LinkedBlockingDeque
        
        attr_accessor :item
        alias_method :attr_item, :item
        undef_method :item
        alias_method :attr_item=, :item=
        undef_method :item=
        
        attr_accessor :prev
        alias_method :attr_prev, :prev
        undef_method :prev
        alias_method :attr_prev=, :prev=
        undef_method :prev=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        typesig { [Object, class_self::Node, class_self::Node] }
        def initialize(x, p, n)
          @item = nil
          @prev = nil
          @next = nil
          @item = x
          @prev = p
          @next = n
        end
        
        private
        alias_method :initialize__node, :initialize
      end }
    }
    
    # Pointer to first node
    attr_accessor :first
    alias_method :attr_first, :first
    undef_method :first
    alias_method :attr_first=, :first=
    undef_method :first=
    
    # Pointer to last node
    attr_accessor :last
    alias_method :attr_last, :last
    undef_method :last
    alias_method :attr_last=, :last=
    undef_method :last=
    
    # Number of items in the deque
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # Maximum number of items in the deque
    attr_accessor :capacity
    alias_method :attr_capacity, :capacity
    undef_method :capacity
    alias_method :attr_capacity=, :capacity=
    undef_method :capacity=
    
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
    
    typesig { [] }
    # Creates a <tt>LinkedBlockingDeque</tt> with a capacity of
    # {@link Integer#MAX_VALUE}.
    def initialize
      initialize__linked_blocking_deque(JavaInteger::MAX_VALUE)
    end
    
    typesig { [::Java::Int] }
    # Creates a <tt>LinkedBlockingDeque</tt> with the given (fixed) capacity.
    # 
    # @param capacity the capacity of this deque
    # @throws IllegalArgumentException if <tt>capacity</tt> is less than 1
    def initialize(capacity)
      @first = nil
      @last = nil
      @count = 0
      @capacity = 0
      @lock = nil
      @not_empty = nil
      @not_full = nil
      super()
      @lock = ReentrantLock.new
      @not_empty = @lock.new_condition
      @not_full = @lock.new_condition
      if (capacity <= 0)
        raise IllegalArgumentException.new
      end
      @capacity = capacity
    end
    
    typesig { [Collection] }
    # Creates a <tt>LinkedBlockingDeque</tt> with a capacity of
    # {@link Integer#MAX_VALUE}, initially containing the elements of
    # the given collection, added in traversal order of the
    # collection's iterator.
    # 
    # @param c the collection of elements to initially contain
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def initialize(c)
      initialize__linked_blocking_deque(JavaInteger::MAX_VALUE)
      c.each do |e|
        add(e)
      end
    end
    
    typesig { [Object] }
    # Basic linking and unlinking operations, called only while holding lock
    # 
    # Links e as first element, or returns false if full.
    def link_first(e)
      if (@count >= @capacity)
        return false
      end
      (@count += 1)
      f = @first
      x = Node.new(e, nil, f)
      @first = x
      if ((@last).nil?)
        @last = x
      else
        f.attr_prev = x
      end
      @not_empty.signal
      return true
    end
    
    typesig { [Object] }
    # Links e as last element, or returns false if full.
    def link_last(e)
      if (@count >= @capacity)
        return false
      end
      (@count += 1)
      l = @last
      x = Node.new(e, l, nil)
      @last = x
      if ((@first).nil?)
        @first = x
      else
        l.attr_next = x
      end
      @not_empty.signal
      return true
    end
    
    typesig { [] }
    # Removes and returns first element, or null if empty.
    def unlink_first
      f = @first
      if ((f).nil?)
        return nil
      end
      n = f.attr_next
      @first = n
      if ((n).nil?)
        @last = nil
      else
        n.attr_prev = nil
      end
      (@count -= 1)
      @not_full.signal
      return f.attr_item
    end
    
    typesig { [] }
    # Removes and returns last element, or null if empty.
    def unlink_last
      l = @last
      if ((l).nil?)
        return nil
      end
      p = l.attr_prev
      @last = p
      if ((p).nil?)
        @first = nil
      else
        p.attr_next = nil
      end
      (@count -= 1)
      @not_full.signal
      return l.attr_item
    end
    
    typesig { [Node] }
    # Unlink e
    def unlink(x)
      p = x.attr_prev
      n = x.attr_next
      if ((p).nil?)
        if ((n).nil?)
          @first = @last = nil
        else
          n.attr_prev = nil
          @first = n
        end
      else
        if ((n).nil?)
          p.attr_next = nil
          @last = p
        else
          p.attr_next = n
          n.attr_prev = p
        end
      end
      (@count -= 1)
      @not_full.signal_all
    end
    
    typesig { [Object] }
    # BlockingDeque methods
    # 
    # @throws IllegalStateException {@inheritDoc}
    # @throws NullPointerException  {@inheritDoc}
    def add_first(e)
      if (!offer_first(e))
        raise IllegalStateException.new("Deque full")
      end
    end
    
    typesig { [Object] }
    # @throws IllegalStateException {@inheritDoc}
    # @throws NullPointerException  {@inheritDoc}
    def add_last(e)
      if (!offer_last(e))
        raise IllegalStateException.new("Deque full")
      end
    end
    
    typesig { [Object] }
    # @throws NullPointerException {@inheritDoc}
    def offer_first(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      @lock.lock
      begin
        return link_first(e)
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
    # @throws NullPointerException {@inheritDoc}
    def offer_last(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      @lock.lock
      begin
        return link_last(e)
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
    # @throws NullPointerException {@inheritDoc}
    # @throws InterruptedException {@inheritDoc}
    def put_first(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      @lock.lock
      begin
        while (!link_first(e))
          @not_full.await
        end
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
    # @throws NullPointerException {@inheritDoc}
    # @throws InterruptedException {@inheritDoc}
    def put_last(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      @lock.lock
      begin
        while (!link_last(e))
          @not_full.await
        end
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # @throws NullPointerException {@inheritDoc}
    # @throws InterruptedException {@inheritDoc}
    def offer_first(e, timeout, unit)
      if ((e).nil?)
        raise NullPointerException.new
      end
      nanos = unit.to_nanos(timeout)
      @lock.lock_interruptibly
      begin
        loop do
          if (link_first(e))
            return true
          end
          if (nanos <= 0)
            return false
          end
          nanos = @not_full.await_nanos(nanos)
        end
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # @throws NullPointerException {@inheritDoc}
    # @throws InterruptedException {@inheritDoc}
    def offer_last(e, timeout, unit)
      if ((e).nil?)
        raise NullPointerException.new
      end
      nanos = unit.to_nanos(timeout)
      @lock.lock_interruptibly
      begin
        loop do
          if (link_last(e))
            return true
          end
          if (nanos <= 0)
            return false
          end
          nanos = @not_full.await_nanos(nanos)
        end
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def remove_first
      x = poll_first
      if ((x).nil?)
        raise NoSuchElementException.new
      end
      return x
    end
    
    typesig { [] }
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
      @lock.lock
      begin
        return unlink_first
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    def poll_last
      @lock.lock
      begin
        return unlink_last
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    def take_first
      @lock.lock
      begin
        x = nil
        while (((x = unlink_first)).nil?)
          @not_empty.await
        end
        return x
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    def take_last
      @lock.lock
      begin
        x = nil
        while (((x = unlink_last)).nil?)
          @not_empty.await
        end
        return x
      ensure
        @lock.unlock
      end
    end
    
    typesig { [::Java::Long, TimeUnit] }
    def poll_first(timeout, unit)
      nanos = unit.to_nanos(timeout)
      @lock.lock_interruptibly
      begin
        loop do
          x = unlink_first
          if (!(x).nil?)
            return x
          end
          if (nanos <= 0)
            return nil
          end
          nanos = @not_empty.await_nanos(nanos)
        end
      ensure
        @lock.unlock
      end
    end
    
    typesig { [::Java::Long, TimeUnit] }
    def poll_last(timeout, unit)
      nanos = unit.to_nanos(timeout)
      @lock.lock_interruptibly
      begin
        loop do
          x = unlink_last
          if (!(x).nil?)
            return x
          end
          if (nanos <= 0)
            return nil
          end
          nanos = @not_empty.await_nanos(nanos)
        end
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def get_first
      x = peek_first
      if ((x).nil?)
        raise NoSuchElementException.new
      end
      return x
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def get_last
      x = peek_last
      if ((x).nil?)
        raise NoSuchElementException.new
      end
      return x
    end
    
    typesig { [] }
    def peek_first
      @lock.lock
      begin
        return ((@first).nil?) ? nil : @first.attr_item
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    def peek_last
      @lock.lock
      begin
        return ((@last).nil?) ? nil : @last.attr_item
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
    def remove_first_occurrence(o)
      if ((o).nil?)
        return false
      end
      @lock.lock
      begin
        p = @first
        while !(p).nil?
          if ((o == p.attr_item))
            unlink(p)
            return true
          end
          p = p.attr_next
        end
        return false
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
    def remove_last_occurrence(o)
      if ((o).nil?)
        return false
      end
      @lock.lock
      begin
        p = @last
        while !(p).nil?
          if ((o == p.attr_item))
            unlink(p)
            return true
          end
          p = p.attr_prev
        end
        return false
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
    # BlockingQueue methods
    # 
    # Inserts the specified element at the end of this deque unless it would
    # violate capacity restrictions.  When using a capacity-restricted deque,
    # it is generally preferable to use method {@link #offer(Object) offer}.
    # 
    # <p>This method is equivalent to {@link #addLast}.
    # 
    # @throws IllegalStateException if the element cannot be added at this
    # time due to capacity restrictions
    # @throws NullPointerException if the specified element is null
    def add(e)
      add_last(e)
      return true
    end
    
    typesig { [Object] }
    # @throws NullPointerException if the specified element is null
    def offer(e)
      return offer_last(e)
    end
    
    typesig { [Object] }
    # @throws NullPointerException {@inheritDoc}
    # @throws InterruptedException {@inheritDoc}
    def put(e)
      put_last(e)
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # @throws NullPointerException {@inheritDoc}
    # @throws InterruptedException {@inheritDoc}
    def offer(e, timeout, unit)
      return offer_last(e, timeout, unit)
    end
    
    typesig { [] }
    # Retrieves and removes the head of the queue represented by this deque.
    # This method differs from {@link #poll poll} only in that it throws an
    # exception if this deque is empty.
    # 
    # <p>This method is equivalent to {@link #removeFirst() removeFirst}.
    # 
    # @return the head of the queue represented by this deque
    # @throws NoSuchElementException if this deque is empty
    def remove
      return remove_first
    end
    
    typesig { [] }
    def poll
      return poll_first
    end
    
    typesig { [] }
    def take
      return take_first
    end
    
    typesig { [::Java::Long, TimeUnit] }
    def poll(timeout, unit)
      return poll_first(timeout, unit)
    end
    
    typesig { [] }
    # Retrieves, but does not remove, the head of the queue represented by
    # this deque.  This method differs from {@link #peek peek} only in that
    # it throws an exception if this deque is empty.
    # 
    # <p>This method is equivalent to {@link #getFirst() getFirst}.
    # 
    # @return the head of the queue represented by this deque
    # @throws NoSuchElementException if this deque is empty
    def element
      return get_first
    end
    
    typesig { [] }
    def peek
      return peek_first
    end
    
    typesig { [] }
    # Returns the number of additional elements that this deque can ideally
    # (in the absence of memory or resource constraints) accept without
    # blocking. This is always equal to the initial capacity of this deque
    # less the current <tt>size</tt> of this deque.
    # 
    # <p>Note that you <em>cannot</em> always tell if an attempt to insert
    # an element will succeed by inspecting <tt>remainingCapacity</tt>
    # because it may be the case that another thread is about to
    # insert or remove an element.
    def remaining_capacity
      @lock.lock
      begin
        return @capacity - @count
      ensure
        @lock.unlock
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
      @lock.lock
      begin
        p = @first
        while !(p).nil?
          c.add(p.attr_item)
          p = p.attr_next
        end
        n = @count
        @count = 0
        @first = @last = nil
        @not_full.signal_all
        return n
      ensure
        @lock.unlock
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
      @lock.lock
      begin
        n = 0
        while (n < max_elements && !(@first).nil?)
          c.add(@first.attr_item)
          @first.attr_prev = nil
          @first = @first.attr_next
          (@count -= 1)
          (n += 1)
        end
        if ((@first).nil?)
          @last = nil
        end
        @not_full.signal_all
        return n
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
    # Stack methods
    # 
    # @throws IllegalStateException {@inheritDoc}
    # @throws NullPointerException  {@inheritDoc}
    def push(e)
      add_first(e)
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def pop
      return remove_first
    end
    
    typesig { [Object] }
    # Collection methods
    # 
    # Removes the first occurrence of the specified element from this deque.
    # If the deque does not contain the element, it is unchanged.
    # More formally, removes the first element <tt>e</tt> such that
    # <tt>o.equals(e)</tt> (if such an element exists).
    # Returns <tt>true</tt> if this deque contained the specified element
    # (or equivalently, if this deque changed as a result of the call).
    # 
    # <p>This method is equivalent to
    # {@link #removeFirstOccurrence(Object) removeFirstOccurrence}.
    # 
    # @param o element to be removed from this deque, if present
    # @return <tt>true</tt> if this deque changed as a result of the call
    def remove(o)
      return remove_first_occurrence(o)
    end
    
    typesig { [] }
    # Returns the number of elements in this deque.
    # 
    # @return the number of elements in this deque
    def size
      @lock.lock
      begin
        return @count
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Object] }
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
      @lock.lock
      begin
        p = @first
        while !(p).nil?
          if ((o == p.attr_item))
            return true
          end
          p = p.attr_next
        end
        return false
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Node] }
    # Variant of removeFirstOccurrence needed by iterator.remove.
    # Searches for the node, not its contents.
    def remove_node(e)
      @lock.lock
      begin
        p = @first
        while !(p).nil?
          if ((p).equal?(e))
            unlink(p)
            return true
          end
          p = p.attr_next
        end
        return false
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this deque, in
    # proper sequence (from first to last element).
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
      @lock.lock
      begin
        a = Array.typed(Object).new(@count) { nil }
        k = 0
        p = @first
        while !(p).nil?
          a[((k += 1) - 1)] = p.attr_item
          p = p.attr_next
        end
        return a
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Returns an array containing all of the elements in this deque, in
    # proper sequence; the runtime type of the returned array is that of
    # the specified array.  If the deque fits in the specified array, it
    # is returned therein.  Otherwise, a new array is allocated with the
    # runtime type of the specified array and the size of this deque.
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
      @lock.lock
      begin
        if (a.attr_length < @count)
          a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, @count)
        end
        k = 0
        p = @first
        while !(p).nil?
          a[((k += 1) - 1)] = p.attr_item
          p = p.attr_next
        end
        if (a.attr_length > k)
          a[k] = nil
        end
        return a
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    def to_s
      @lock.lock
      begin
        return super
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    # Atomically removes all of the elements from this deque.
    # The deque will be empty after this call returns.
    def clear
      @lock.lock
      begin
        @first = @last = nil
        @count = 0
        @not_full.signal_all
      ensure
        @lock.unlock
      end
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this deque in proper sequence.
    # The elements will be returned in order from first (head) to last (tail).
    # The returned <tt>Iterator</tt> is a "weakly consistent" iterator that
    # will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    # 
    # @return an iterator over the elements in this deque in proper sequence
    def iterator
      return Itr.new_local(self)
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this deque in reverse
    # sequential order.  The elements will be returned in order from
    # last (tail) to first (head).
    # The returned <tt>Iterator</tt> is a "weakly consistent" iterator that
    # will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    def descending_iterator
      return DescendingItr.new_local(self)
    end
    
    class_module.module_eval {
      # Base class for Iterators for LinkedBlockingDeque
      const_set_lazy(:AbstractItr) { Class.new do
        local_class_in LinkedBlockingDeque
        include_class_members LinkedBlockingDeque
        include Iterator
        
        # The next node to return in next
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        # nextItem holds on to item fields because once we claim that
        # an element exists in hasNext(), we must return item read
        # under lock (in advance()) even if it was in the process of
        # being removed when hasNext() was called.
        attr_accessor :next_item
        alias_method :attr_next_item, :next_item
        undef_method :next_item
        alias_method :attr_next_item=, :next_item=
        undef_method :next_item=
        
        # Node returned by most recent call to next. Needed by remove.
        # Reset to null if this element is deleted by a call to remove.
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        typesig { [] }
        def initialize
          @next = nil
          @next_item = nil
          @last_ret = nil
          advance # set to initial position
        end
        
        typesig { [] }
        # Advances next, or if not yet initialized, sets to first node.
        # Implemented to move forward vs backward in the two subclasses.
        def advance
          raise NotImplementedError
        end
        
        typesig { [] }
        def has_next
          return !(@next).nil?
        end
        
        typesig { [] }
        def next_
          if ((@next).nil?)
            raise self.class::NoSuchElementException.new
          end
          @last_ret = @next
          x = @next_item
          advance
          return x
        end
        
        typesig { [] }
        def remove
          n = @last_ret
          if ((n).nil?)
            raise self.class::IllegalStateException.new
          end
          @last_ret = nil
          # Note: removeNode rescans looking for this node to make
          # sure it was not already removed. Otherwise, trying to
          # re-remove could corrupt list.
          remove_node(n)
        end
        
        private
        alias_method :initialize__abstract_itr, :initialize
      end }
      
      # Forward iterator
      const_set_lazy(:Itr) { Class.new(AbstractItr) do
        local_class_in LinkedBlockingDeque
        include_class_members LinkedBlockingDeque
        
        typesig { [] }
        def advance
          lock = @local_class_parent.attr_lock
          lock.lock
          begin
            self.attr_next = ((self.attr_next).nil?) ? self.attr_first : self.attr_next.attr_next
            self.attr_next_item = ((self.attr_next).nil?) ? nil : self.attr_next.attr_item
          ensure
            lock.unlock
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
      
      # Descending iterator for LinkedBlockingDeque
      const_set_lazy(:DescendingItr) { Class.new(AbstractItr) do
        local_class_in LinkedBlockingDeque
        include_class_members LinkedBlockingDeque
        
        typesig { [] }
        def advance
          lock = @local_class_parent.attr_lock
          lock.lock
          begin
            self.attr_next = ((self.attr_next).nil?) ? self.attr_last : self.attr_next.attr_prev
            self.attr_next_item = ((self.attr_next).nil?) ? nil : self.attr_next.attr_item
          ensure
            lock.unlock
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__descending_itr, :initialize
      end }
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of this deque to a stream (that is, serialize it).
    # 
    # @serialData The capacity (int), followed by elements (each an
    # <tt>Object</tt>) in the proper order, followed by a null
    # @param s the stream
    def write_object(s)
      @lock.lock
      begin
        # Write out capacity and any hidden stuff
        s.default_write_object
        # Write out all elements in the proper order.
        p = @first
        while !(p).nil?
          s.write_object(p.attr_item)
          p = p.attr_next
        end
        # Use trailing null as sentinel
        s.write_object(nil)
      ensure
        @lock.unlock
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute this deque from a stream (that is,
    # deserialize it).
    # @param s the stream
    def read_object(s)
      s.default_read_object
      @count = 0
      @first = nil
      @last = nil
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
    alias_method :initialize__linked_blocking_deque, :initialize
  end
  
end
