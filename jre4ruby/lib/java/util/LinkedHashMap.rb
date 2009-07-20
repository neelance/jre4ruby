require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LinkedHashMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
    }
  end
  
  # <p>Hash table and linked list implementation of the <tt>Map</tt> interface,
  # with predictable iteration order.  This implementation differs from
  # <tt>HashMap</tt> in that it maintains a doubly-linked list running through
  # all of its entries.  This linked list defines the iteration ordering,
  # which is normally the order in which keys were inserted into the map
  # (<i>insertion-order</i>).  Note that insertion order is not affected
  # if a key is <i>re-inserted</i> into the map.  (A key <tt>k</tt> is
  # reinserted into a map <tt>m</tt> if <tt>m.put(k, v)</tt> is invoked when
  # <tt>m.containsKey(k)</tt> would return <tt>true</tt> immediately prior to
  # the invocation.)
  # 
  # <p>This implementation spares its clients from the unspecified, generally
  # chaotic ordering provided by {@link HashMap} (and {@link Hashtable}),
  # without incurring the increased cost associated with {@link TreeMap}.  It
  # can be used to produce a copy of a map that has the same order as the
  # original, regardless of the original map's implementation:
  # <pre>
  # void foo(Map m) {
  # Map copy = new LinkedHashMap(m);
  # ...
  # }
  # </pre>
  # This technique is particularly useful if a module takes a map on input,
  # copies it, and later returns results whose order is determined by that of
  # the copy.  (Clients generally appreciate having things returned in the same
  # order they were presented.)
  # 
  # <p>A special {@link #LinkedHashMap(int,float,boolean) constructor} is
  # provided to create a linked hash map whose order of iteration is the order
  # in which its entries were last accessed, from least-recently accessed to
  # most-recently (<i>access-order</i>).  This kind of map is well-suited to
  # building LRU caches.  Invoking the <tt>put</tt> or <tt>get</tt> method
  # results in an access to the corresponding entry (assuming it exists after
  # the invocation completes).  The <tt>putAll</tt> method generates one entry
  # access for each mapping in the specified map, in the order that key-value
  # mappings are provided by the specified map's entry set iterator.  <i>No
  # other methods generate entry accesses.</i> In particular, operations on
  # collection-views do <i>not</i> affect the order of iteration of the backing
  # map.
  # 
  # <p>The {@link #removeEldestEntry(Map.Entry)} method may be overridden to
  # impose a policy for removing stale mappings automatically when new mappings
  # are added to the map.
  # 
  # <p>This class provides all of the optional <tt>Map</tt> operations, and
  # permits null elements.  Like <tt>HashMap</tt>, it provides constant-time
  # performance for the basic operations (<tt>add</tt>, <tt>contains</tt> and
  # <tt>remove</tt>), assuming the hash function disperses elements
  # properly among the buckets.  Performance is likely to be just slightly
  # below that of <tt>HashMap</tt>, due to the added expense of maintaining the
  # linked list, with one exception: Iteration over the collection-views
  # of a <tt>LinkedHashMap</tt> requires time proportional to the <i>size</i>
  # of the map, regardless of its capacity.  Iteration over a <tt>HashMap</tt>
  # is likely to be more expensive, requiring time proportional to its
  # <i>capacity</i>.
  # 
  # <p>A linked hash map has two parameters that affect its performance:
  # <i>initial capacity</i> and <i>load factor</i>.  They are defined precisely
  # as for <tt>HashMap</tt>.  Note, however, that the penalty for choosing an
  # excessively high value for initial capacity is less severe for this class
  # than for <tt>HashMap</tt>, as iteration times for this class are unaffected
  # by capacity.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access a linked hash map concurrently, and at least
  # one of the threads modifies the map structurally, it <em>must</em> be
  # synchronized externally.  This is typically accomplished by
  # synchronizing on some object that naturally encapsulates the map.
  # 
  # If no such object exists, the map should be "wrapped" using the
  # {@link Collections#synchronizedMap Collections.synchronizedMap}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the map:<pre>
  # Map m = Collections.synchronizedMap(new LinkedHashMap(...));</pre>
  # 
  # A structural modification is any operation that adds or deletes one or more
  # mappings or, in the case of access-ordered linked hash maps, affects
  # iteration order.  In insertion-ordered linked hash maps, merely changing
  # the value associated with a key that is already contained in the map is not
  # a structural modification.  <strong>In access-ordered linked hash maps,
  # merely querying the map with <tt>get</tt> is a structural
  # modification.</strong>)
  # 
  # <p>The iterators returned by the <tt>iterator</tt> method of the collections
  # returned by all of this class's collection view methods are
  # <em>fail-fast</em>: if the map is structurally modified at any time after
  # the iterator is created, in any way except through the iterator's own
  # <tt>remove</tt> method, the iterator will throw a {@link
  # ConcurrentModificationException}.  Thus, in the face of concurrent
  # modification, the iterator fails quickly and cleanly, rather than risking
  # arbitrary, non-deterministic behavior at an undetermined time in the future.
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
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # 
  # @author  Josh Bloch
  # @see     Object#hashCode()
  # @see     Collection
  # @see     Map
  # @see     HashMap
  # @see     TreeMap
  # @see     Hashtable
  # @since   1.4
  class LinkedHashMap < LinkedHashMapImports.const_get :HashMap
    include_class_members LinkedHashMapImports
    include Map
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 3801124242820219131 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The head of the doubly linked list.
    attr_accessor :header
    alias_method :attr_header, :header
    undef_method :header
    alias_method :attr_header=, :header=
    undef_method :header=
    
    # The iteration ordering method for this linked hash map: <tt>true</tt>
    # for access-order, <tt>false</tt> for insertion-order.
    # 
    # @serial
    attr_accessor :access_order
    alias_method :attr_access_order, :access_order
    undef_method :access_order
    alias_method :attr_access_order=, :access_order=
    undef_method :access_order=
    
    typesig { [::Java::Int, ::Java::Float] }
    # Constructs an empty insertion-ordered <tt>LinkedHashMap</tt> instance
    # with the specified initial capacity and load factor.
    # 
    # @param  initialCapacity the initial capacity
    # @param  loadFactor      the load factor
    # @throws IllegalArgumentException if the initial capacity is negative
    # or the load factor is nonpositive
    def initialize(initial_capacity, load_factor)
      @header = nil
      @access_order = false
      super(initial_capacity, load_factor)
      @access_order = false
    end
    
    typesig { [::Java::Int] }
    # Constructs an empty insertion-ordered <tt>LinkedHashMap</tt> instance
    # with the specified initial capacity and a default load factor (0.75).
    # 
    # @param  initialCapacity the initial capacity
    # @throws IllegalArgumentException if the initial capacity is negative
    def initialize(initial_capacity)
      @header = nil
      @access_order = false
      super(initial_capacity)
      @access_order = false
    end
    
    typesig { [] }
    # Constructs an empty insertion-ordered <tt>LinkedHashMap</tt> instance
    # with the default initial capacity (16) and load factor (0.75).
    def initialize
      @header = nil
      @access_order = false
      super()
      @access_order = false
    end
    
    typesig { [Map] }
    # Constructs an insertion-ordered <tt>LinkedHashMap</tt> instance with
    # the same mappings as the specified map.  The <tt>LinkedHashMap</tt>
    # instance is created with a default load factor (0.75) and an initial
    # capacity sufficient to hold the mappings in the specified map.
    # 
    # @param  m the map whose mappings are to be placed in this map
    # @throws NullPointerException if the specified map is null
    def initialize(m)
      @header = nil
      @access_order = false
      super(m)
      @access_order = false
    end
    
    typesig { [::Java::Int, ::Java::Float, ::Java::Boolean] }
    # Constructs an empty <tt>LinkedHashMap</tt> instance with the
    # specified initial capacity, load factor and ordering mode.
    # 
    # @param  initialCapacity the initial capacity
    # @param  loadFactor      the load factor
    # @param  accessOrder     the ordering mode - <tt>true</tt> for
    # access-order, <tt>false</tt> for insertion-order
    # @throws IllegalArgumentException if the initial capacity is negative
    # or the load factor is nonpositive
    def initialize(initial_capacity, load_factor, access_order)
      @header = nil
      @access_order = false
      super(initial_capacity, load_factor)
      @access_order = access_order
    end
    
    typesig { [] }
    # Called by superclass constructors and pseudoconstructors (clone,
    # readObject) before any entries are inserted into the map.  Initializes
    # the chain.
    def init
      @header = Entry.new(-1, nil, nil, nil)
      @header.attr_before = @header.attr_after = @header
    end
    
    typesig { [Array.typed(HashMap::Entry)] }
    # Transfers all entries to new table array.  This method is called
    # by superclass resize.  It is overridden for performance, as it is
    # faster to iterate using our linked list.
    def transfer(new_table)
      new_capacity = new_table.attr_length
      e = @header.attr_after
      while !(e).equal?(@header)
        index = index_for(e.attr_hash, new_capacity)
        e.attr_next = new_table[index]
        new_table[index] = e
        e = e.attr_after
      end
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map maps one or more keys to the
    # specified value.
    # 
    # @param value value whose presence in this map is to be tested
    # @return <tt>true</tt> if this map maps one or more keys to the
    # specified value
    def contains_value(value)
      # Overridden to take advantage of faster iterator
      if ((value).nil?)
        e = @header.attr_after
        while !(e).equal?(@header)
          if ((e.attr_value).nil?)
            return true
          end
          e = e.attr_after
        end
      else
        e = @header.attr_after
        while !(e).equal?(@header)
          if ((value == e.attr_value))
            return true
          end
          e = e.attr_after
        end
      end
      return false
    end
    
    typesig { [Object] }
    # Returns the value to which the specified key is mapped,
    # or {@code null} if this map contains no mapping for the key.
    # 
    # <p>More formally, if this map contains a mapping from a key
    # {@code k} to a value {@code v} such that {@code (key==null ? k==null :
    # key.equals(k))}, then this method returns {@code v}; otherwise
    # it returns {@code null}.  (There can be at most one such mapping.)
    # 
    # <p>A return value of {@code null} does not <i>necessarily</i>
    # indicate that the map contains no mapping for the key; it's also
    # possible that the map explicitly maps the key to {@code null}.
    # The {@link #containsKey containsKey} operation may be used to
    # distinguish these two cases.
    def get(key)
      e = get_entry(key)
      if ((e).nil?)
        return nil
      end
      e.record_access(self)
      return e.attr_value
    end
    
    typesig { [] }
    # Removes all of the mappings from this map.
    # The map will be empty after this call returns.
    def clear
      super
      @header.attr_before = @header.attr_after = @header
    end
    
    class_module.module_eval {
      # LinkedHashMap entry.
      const_set_lazy(:Entry) { Class.new(HashMap::Entry) do
        include_class_members LinkedHashMap
        
        # These fields comprise the doubly linked list used for iteration.
        attr_accessor :before
        alias_method :attr_before, :before
        undef_method :before
        alias_method :attr_before=, :before=
        undef_method :before=
        
        attr_accessor :after
        alias_method :attr_after, :after
        undef_method :after
        alias_method :attr_after=, :after=
        undef_method :after=
        
        typesig { [::Java::Int, Object, Object, HashMap::Entry] }
        def initialize(hash, key, value, next_)
          @before = nil
          @after = nil
          super(hash, key, value, next_)
        end
        
        typesig { [] }
        # Removes this entry from the linked list.
        def remove
          @before.attr_after = @after
          @after.attr_before = @before
        end
        
        typesig { [Entry] }
        # Inserts this entry before the specified existing entry in the list.
        def add_before(existing_entry)
          @after = existing_entry
          @before = existing_entry.attr_before
          @before.attr_after = self
          @after.attr_before = self
        end
        
        typesig { [HashMap] }
        # This method is invoked by the superclass whenever the value
        # of a pre-existing entry is read by Map.get or modified by Map.set.
        # If the enclosing Map is access-ordered, it moves the entry
        # to the end of the list; otherwise, it does nothing.
        def record_access(m)
          lm = m
          if (lm.attr_access_order)
            lm.attr_mod_count += 1
            remove
            add_before(lm.attr_header)
          end
        end
        
        typesig { [HashMap] }
        def record_removal(m)
          remove
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
      
      const_set_lazy(:LinkedHashIterator) { Class.new do
        extend LocalClass
        include_class_members LinkedHashMap
        include Iterator
        
        attr_accessor :next_entry
        alias_method :attr_next_entry, :next_entry
        undef_method :next_entry
        alias_method :attr_next_entry=, :next_entry=
        undef_method :next_entry=
        
        attr_accessor :last_returned
        alias_method :attr_last_returned, :last_returned
        undef_method :last_returned
        alias_method :attr_last_returned=, :last_returned=
        undef_method :last_returned=
        
        # The modCount value that the iterator believes that the backing
        # List should have.  If this expectation is violated, the iterator
        # has detected concurrent modification.
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        typesig { [] }
        def has_next
          return !(@next_entry).equal?(self.attr_header)
        end
        
        typesig { [] }
        def remove
          if ((@last_returned).nil?)
            raise IllegalStateException.new
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          @local_class_parent.remove(@last_returned.attr_key)
          @last_returned = nil
          @expected_mod_count = self.attr_mod_count
        end
        
        typesig { [] }
        def next_entry
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          if ((@next_entry).equal?(self.attr_header))
            raise NoSuchElementException.new
          end
          e = @last_returned = @next_entry
          @next_entry = e.attr_after
          return e
        end
        
        typesig { [] }
        def initialize
          @next_entry = self.attr_header.attr_after
          @last_returned = nil
          @expected_mod_count = self.attr_mod_count
        end
        
        private
        alias_method :initialize__linked_hash_iterator, :initialize
      end }
      
      const_set_lazy(:KeyIterator) { Class.new(LinkedHashIterator) do
        extend LocalClass
        include_class_members LinkedHashMap
        
        typesig { [] }
        def next
          return next_entry.get_key
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__key_iterator, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(LinkedHashIterator) do
        extend LocalClass
        include_class_members LinkedHashMap
        
        typesig { [] }
        def next
          return next_entry.attr_value
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__value_iterator, :initialize
      end }
      
      const_set_lazy(:EntryIterator) { Class.new(LinkedHashIterator) do
        extend LocalClass
        include_class_members LinkedHashMap
        
        typesig { [] }
        def next
          return next_entry
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_iterator, :initialize
      end }
    }
    
    typesig { [] }
    # These Overrides alter the behavior of superclass view iterator() methods
    def new_key_iterator
      return KeyIterator.new_local(self)
    end
    
    typesig { [] }
    def new_value_iterator
      return ValueIterator.new_local(self)
    end
    
    typesig { [] }
    def new_entry_iterator
      return EntryIterator.new_local(self)
    end
    
    typesig { [::Java::Int, Object, Object, ::Java::Int] }
    # This override alters behavior of superclass put method. It causes newly
    # allocated entry to get inserted at the end of the linked list and
    # removes the eldest entry if appropriate.
    def add_entry(hash, key, value, bucket_index)
      create_entry(hash, key, value, bucket_index)
      # Remove eldest entry if instructed, else grow capacity if appropriate
      eldest = @header.attr_after
      if (remove_eldest_entry(eldest))
        remove_entry_for_key(eldest.attr_key)
      else
        if (self.attr_size >= self.attr_threshold)
          resize(2 * self.attr_table.attr_length)
        end
      end
    end
    
    typesig { [::Java::Int, Object, Object, ::Java::Int] }
    # This override differs from addEntry in that it doesn't resize the
    # table or remove the eldest entry.
    def create_entry(hash, key, value, bucket_index)
      old = self.attr_table[bucket_index]
      e = Entry.new(hash, key, value, old)
      self.attr_table[bucket_index] = e
      e.add_before(@header)
      self.attr_size += 1
    end
    
    typesig { [Map::Entry] }
    # Returns <tt>true</tt> if this map should remove its eldest entry.
    # This method is invoked by <tt>put</tt> and <tt>putAll</tt> after
    # inserting a new entry into the map.  It provides the implementor
    # with the opportunity to remove the eldest entry each time a new one
    # is added.  This is useful if the map represents a cache: it allows
    # the map to reduce memory consumption by deleting stale entries.
    # 
    # <p>Sample use: this override will allow the map to grow up to 100
    # entries and then delete the eldest entry each time a new entry is
    # added, maintaining a steady state of 100 entries.
    # <pre>
    # private static final int MAX_ENTRIES = 100;
    # 
    # protected boolean removeEldestEntry(Map.Entry eldest) {
    # return size() > MAX_ENTRIES;
    # }
    # </pre>
    # 
    # <p>This method typically does not modify the map in any way,
    # instead allowing the map to modify itself as directed by its
    # return value.  It <i>is</i> permitted for this method to modify
    # the map directly, but if it does so, it <i>must</i> return
    # <tt>false</tt> (indicating that the map should not attempt any
    # further modification).  The effects of returning <tt>true</tt>
    # after modifying the map from within this method are unspecified.
    # 
    # <p>This implementation merely returns <tt>false</tt> (so that this
    # map acts like a normal map - the eldest element is never removed).
    # 
    # @param    eldest The least recently inserted entry in the map, or if
    # this is an access-ordered map, the least recently accessed
    # entry.  This is the entry that will be removed it this
    # method returns <tt>true</tt>.  If the map was empty prior
    # to the <tt>put</tt> or <tt>putAll</tt> invocation resulting
    # in this invocation, this will be the entry that was just
    # inserted; in other words, if the map contains a single
    # entry, the eldest entry is also the newest.
    # @return   <tt>true</tt> if the eldest entry should be removed
    # from the map; <tt>false</tt> if it should be retained.
    def remove_eldest_entry(eldest)
      return false
    end
    
    private
    alias_method :initialize__linked_hash_map, :initialize
  end
  
end
