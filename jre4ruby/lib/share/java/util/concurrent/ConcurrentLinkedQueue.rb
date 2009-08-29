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
  module ConcurrentLinkedQueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
      include ::Java::Util::Concurrent::Atomic
    }
  end
  
  # An unbounded thread-safe {@linkplain Queue queue} based on linked nodes.
  # This queue orders elements FIFO (first-in-first-out).
  # The <em>head</em> of the queue is that element that has been on the
  # queue the longest time.
  # The <em>tail</em> of the queue is that element that has been on the
  # queue the shortest time. New elements
  # are inserted at the tail of the queue, and the queue retrieval
  # operations obtain elements at the head of the queue.
  # A <tt>ConcurrentLinkedQueue</tt> is an appropriate choice when
  # many threads will share access to a common collection.
  # This queue does not permit <tt>null</tt> elements.
  # 
  # <p>This implementation employs an efficient &quot;wait-free&quot;
  # algorithm based on one described in <a
  # href="http://www.cs.rochester.edu/u/michael/PODC96.html"> Simple,
  # Fast, and Practical Non-Blocking and Blocking Concurrent Queue
  # Algorithms</a> by Maged M. Michael and Michael L. Scott.
  # 
  # <p>Beware that, unlike in most collections, the <tt>size</tt> method
  # is <em>NOT</em> a constant-time operation. Because of the
  # asynchronous nature of these queues, determining the current number
  # of elements requires a traversal of the elements.
  # 
  # <p>This class and its iterator implement all of the
  # <em>optional</em> methods of the {@link Collection} and {@link
  # Iterator} interfaces.
  # 
  # <p>Memory consistency effects: As with other concurrent
  # collections, actions in a thread prior to placing an object into a
  # {@code ConcurrentLinkedQueue}
  # <a href="package-summary.html#MemoryVisibility"><i>happen-before</i></a>
  # actions subsequent to the access or removal of that element from
  # the {@code ConcurrentLinkedQueue} in another thread.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <E> the type of elements held in this collection
  class ConcurrentLinkedQueue < ConcurrentLinkedQueueImports.const_get :AbstractQueue
    include_class_members ConcurrentLinkedQueueImports
    overload_protected {
      include Queue
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 196745693267521676 }
      const_attr_reader  :SerialVersionUID
      
      # This is a straight adaptation of Michael & Scott algorithm.
      # For explanation, read the paper.  The only (minor) algorithmic
      # difference is that this version supports lazy deletion of
      # internal nodes (method remove(Object)) -- remove CAS'es item
      # fields to null. The normal queue operations unlink but then
      # pass over nodes with null item fields. Similarly, iteration
      # methods ignore those with nulls.
      # 
      # Also note that like most non-blocking algorithms in this
      # package, this implementation relies on the fact that in garbage
      # collected systems, there is no possibility of ABA problems due
      # to recycled nodes, so there is no need to use "counted
      # pointers" or related techniques seen in versions used in
      # non-GC'ed settings.
      const_set_lazy(:Node) { Class.new do
        include_class_members ConcurrentLinkedQueue
        
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
        
        class_module.module_eval {
          const_set_lazy(:NextUpdater) { AtomicReferenceFieldUpdater.new_updater(Node, Node, "next") }
          const_attr_reader  :NextUpdater
          
          const_set_lazy(:ItemUpdater) { AtomicReferenceFieldUpdater.new_updater(Node, Object, "item") }
          const_attr_reader  :ItemUpdater
        }
        
        typesig { [Object] }
        def initialize(x)
          @item = nil
          @next = nil
          @item = x
        end
        
        typesig { [Object, class_self::Node] }
        def initialize(x, n)
          @item = nil
          @next = nil
          @item = x
          @next = n
        end
        
        typesig { [] }
        def get_item
          return @item
        end
        
        typesig { [Object, Object] }
        def cas_item(cmp, val)
          return self.class::ItemUpdater.compare_and_set(self, cmp, val)
        end
        
        typesig { [Object] }
        def set_item(val)
          self.class::ItemUpdater.set(self, val)
        end
        
        typesig { [] }
        def get_next
          return @next
        end
        
        typesig { [class_self::Node, class_self::Node] }
        def cas_next(cmp, val)
          return self.class::NextUpdater.compare_and_set(self, cmp, val)
        end
        
        typesig { [class_self::Node] }
        def set_next(val)
          self.class::NextUpdater.set(self, val)
        end
        
        private
        alias_method :initialize__node, :initialize
      end }
      
      const_set_lazy(:TailUpdater) { AtomicReferenceFieldUpdater.new_updater(ConcurrentLinkedQueue, Node, "tail") }
      const_attr_reader  :TailUpdater
      
      const_set_lazy(:HeadUpdater) { AtomicReferenceFieldUpdater.new_updater(ConcurrentLinkedQueue, Node, "head") }
      const_attr_reader  :HeadUpdater
    }
    
    typesig { [Node, Node] }
    def cas_tail(cmp, val)
      return TailUpdater.compare_and_set(self, cmp, val)
    end
    
    typesig { [Node, Node] }
    def cas_head(cmp, val)
      return HeadUpdater.compare_and_set(self, cmp, val)
    end
    
    # Pointer to header node, initialized to a dummy node.  The first
    # actual node is at head.getNext().
    attr_accessor :head
    alias_method :attr_head, :head
    undef_method :head
    alias_method :attr_head=, :head=
    undef_method :head=
    
    # Pointer to last node on list *
    attr_accessor :tail
    alias_method :attr_tail, :tail
    undef_method :tail
    alias_method :attr_tail=, :tail=
    undef_method :tail=
    
    typesig { [] }
    # Creates a <tt>ConcurrentLinkedQueue</tt> that is initially empty.
    def initialize
      @head = nil
      @tail = nil
      super()
      @head = Node.new(nil, nil)
      @tail = @head
    end
    
    typesig { [Collection] }
    # Creates a <tt>ConcurrentLinkedQueue</tt>
    # initially containing the elements of the given collection,
    # added in traversal order of the collection's iterator.
    # @param c the collection of elements to initially contain
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def initialize(c)
      @head = nil
      @tail = nil
      super()
      @head = Node.new(nil, nil)
      @tail = @head
      it = c.iterator
      while it.has_next
        add(it.next_)
      end
    end
    
    typesig { [Object] }
    # Have to override just to update the javadoc
    # 
    # Inserts the specified element at the tail of this queue.
    # 
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    # @throws NullPointerException if the specified element is null
    def add(e)
      return offer(e)
    end
    
    typesig { [Object] }
    # Inserts the specified element at the tail of this queue.
    # 
    # @return <tt>true</tt> (as specified by {@link Queue#offer})
    # @throws NullPointerException if the specified element is null
    def offer(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      n = Node.new(e, nil)
      loop do
        t = @tail
        s = t.get_next
        if ((t).equal?(@tail))
          if ((s).nil?)
            if (t.cas_next(s, n))
              cas_tail(t, n)
              return true
            end
          else
            cas_tail(t, s)
          end
        end
      end
    end
    
    typesig { [] }
    def poll
      loop do
        h = @head
        t = @tail
        first = h.get_next
        if ((h).equal?(@head))
          if ((h).equal?(t))
            if ((first).nil?)
              return nil
            else
              cas_tail(t, first)
            end
          else
            if (cas_head(h, first))
              item = first.get_item
              if (!(item).nil?)
                first.set_item(nil)
                return item
              end
              # else skip over deleted item, continue loop,
            end
          end
        end
      end
    end
    
    typesig { [] }
    def peek
      # same as poll except don't remove item
      loop do
        h = @head
        t = @tail
        first = h.get_next
        if ((h).equal?(@head))
          if ((h).equal?(t))
            if ((first).nil?)
              return nil
            else
              cas_tail(t, first)
            end
          else
            item = first.get_item
            if (!(item).nil?)
              return item
            else
              # remove deleted node and continue
              cas_head(h, first)
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Returns the first actual (non-header) node on list.  This is yet
    # another variant of poll/peek; here returning out the first
    # node, not element (so we cannot collapse with peek() without
    # introducing race.)
    def first
      loop do
        h = @head
        t = @tail
        first = h.get_next
        if ((h).equal?(@head))
          if ((h).equal?(t))
            if ((first).nil?)
              return nil
            else
              cas_tail(t, first)
            end
          else
            if (!(first.get_item).nil?)
              return first
            else
              # remove deleted node and continue
              cas_head(h, first)
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this queue contains no elements.
    # 
    # @return <tt>true</tt> if this queue contains no elements
    def is_empty
      return (first).nil?
    end
    
    typesig { [] }
    # Returns the number of elements in this queue.  If this queue
    # contains more than <tt>Integer.MAX_VALUE</tt> elements, returns
    # <tt>Integer.MAX_VALUE</tt>.
    # 
    # <p>Beware that, unlike in most collections, this method is
    # <em>NOT</em> a constant-time operation. Because of the
    # asynchronous nature of these queues, determining the current
    # number of elements requires an O(n) traversal.
    # 
    # @return the number of elements in this queue
    def size
      count = 0
      p = first
      while !(p).nil?
        if (!(p.get_item).nil?)
          # Collections.size() spec says to max out
          if (((count += 1)).equal?(JavaInteger::MAX_VALUE))
            break
          end
        end
        p = p.get_next
      end
      return count
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
      p = first
      while !(p).nil?
        item = p.get_item
        if (!(item).nil? && (o == item))
          return true
        end
        p = p.get_next
      end
      return false
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
      p = first
      while !(p).nil?
        item = p.get_item
        if (!(item).nil? && (o == item) && p.cas_item(item, nil))
          return true
        end
        p = p.get_next
      end
      return false
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
      # Use ArrayList to deal with resizing.
      al = ArrayList.new
      p = first
      while !(p).nil?
        item = p.get_item
        if (!(item).nil?)
          al.add(item)
        end
        p = p.get_next
      end
      return al.to_array
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
      # try to use sent-in array
      k = 0
      p = nil
      p = first
      while !(p).nil? && k < a.attr_length
        item = p.get_item
        if (!(item).nil?)
          a[((k += 1) - 1)] = item
        end
        p = p.get_next
      end
      if ((p).nil?)
        if (k < a.attr_length)
          a[k] = nil
        end
        return a
      end
      # If won't fit, use ArrayList version
      al = ArrayList.new
      q = first
      while !(q).nil?
        item = q.get_item
        if (!(item).nil?)
          al.add(item)
        end
        q = q.get_next
      end
      return al.to_array(a)
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this queue in proper sequence.
    # The returned iterator is a "weakly consistent" iterator that
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
        include_class_members ConcurrentLinkedQueue
        include Iterator
        
        # Next node to return item for.
        attr_accessor :next_node
        alias_method :attr_next_node, :next_node
        undef_method :next_node
        alias_method :attr_next_node=, :next_node=
        undef_method :next_node=
        
        # nextItem holds on to item fields because once we claim
        # that an element exists in hasNext(), we must return it in
        # the following next() call even if it was in the process of
        # being removed when hasNext() was called.
        attr_accessor :next_item
        alias_method :attr_next_item, :next_item
        undef_method :next_item
        alias_method :attr_next_item=, :next_item=
        undef_method :next_item=
        
        # Node of the last returned item, to support remove.
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        typesig { [] }
        def initialize
          @next_node = nil
          @next_item = nil
          @last_ret = nil
          advance
        end
        
        typesig { [] }
        # Moves to next valid node and returns item to return for
        # next(), or null if no such.
        def advance
          @last_ret = @next_node
          x = @next_item
          p = ((@next_node).nil?) ? first : @next_node.get_next
          loop do
            if ((p).nil?)
              @next_node = nil
              @next_item = nil
              return x
            end
            item = p.get_item
            if (!(item).nil?)
              @next_node = p
              @next_item = item
              return x
            else
              # skip over nulls
              p = p.get_next
            end
          end
        end
        
        typesig { [] }
        def has_next
          return !(@next_node).nil?
        end
        
        typesig { [] }
        def next_
          if ((@next_node).nil?)
            raise self.class::NoSuchElementException.new
          end
          return advance
        end
        
        typesig { [] }
        def remove
          l = @last_ret
          if ((l).nil?)
            raise self.class::IllegalStateException.new
          end
          # rely on a future traversal to relink.
          l.set_item(nil)
          @last_ret = nil
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state to a stream (that is, serialize it).
    # 
    # @serialData All of the elements (each an <tt>E</tt>) in
    # the proper order, followed by a null
    # @param s the stream
    def write_object(s)
      # Write out any hidden stuff
      s.default_write_object
      # Write out all elements in the proper order.
      p = first
      while !(p).nil?
        item = p.get_item
        if (!(item).nil?)
          s.write_object(item)
        end
        p = p.get_next
      end
      # Use trailing null as sentinel
      s.write_object(nil)
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the Queue instance from a stream (that is,
    # deserialize it).
    # @param s the stream
    def read_object(s)
      # Read in capacity, and any hidden stuff
      s.default_read_object
      @head = Node.new(nil, nil)
      @tail = @head
      # Read in all elements and place in queue
      loop do
        item = s.read_object
        if ((item).nil?)
          break
        else
          offer(item)
        end
      end
    end
    
    private
    alias_method :initialize__concurrent_linked_queue, :initialize
  end
  
end
