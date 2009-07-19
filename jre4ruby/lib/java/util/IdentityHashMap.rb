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
  module IdentityHashMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
    }
  end
  
  # This class implements the <tt>Map</tt> interface with a hash table, using
  # reference-equality in place of object-equality when comparing keys (and
  # values).  In other words, in an <tt>IdentityHashMap</tt>, two keys
  # <tt>k1</tt> and <tt>k2</tt> are considered equal if and only if
  # <tt>(k1==k2)</tt>.  (In normal <tt>Map</tt> implementations (like
  # <tt>HashMap</tt>) two keys <tt>k1</tt> and <tt>k2</tt> are considered equal
  # if and only if <tt>(k1==null ? k2==null : k1.equals(k2))</tt>.)
  # 
  # <p><b>This class is <i>not</i> a general-purpose <tt>Map</tt>
  # implementation!  While this class implements the <tt>Map</tt> interface, it
  # intentionally violates <tt>Map's</tt> general contract, which mandates the
  # use of the <tt>equals</tt> method when comparing objects.  This class is
  # designed for use only in the rare cases wherein reference-equality
  # semantics are required.</b>
  # 
  # <p>A typical use of this class is <i>topology-preserving object graph
  # transformations</i>, such as serialization or deep-copying.  To perform such
  # a transformation, a program must maintain a "node table" that keeps track
  # of all the object references that have already been processed.  The node
  # table must not equate distinct objects even if they happen to be equal.
  # Another typical use of this class is to maintain <i>proxy objects</i>.  For
  # example, a debugging facility might wish to maintain a proxy object for
  # each object in the program being debugged.
  # 
  # <p>This class provides all of the optional map operations, and permits
  # <tt>null</tt> values and the <tt>null</tt> key.  This class makes no
  # guarantees as to the order of the map; in particular, it does not guarantee
  # that the order will remain constant over time.
  # 
  # <p>This class provides constant-time performance for the basic
  # operations (<tt>get</tt> and <tt>put</tt>), assuming the system
  # identity hash function ({@link System#identityHashCode(Object)})
  # disperses elements properly among the buckets.
  # 
  # <p>This class has one tuning parameter (which affects performance but not
  # semantics): <i>expected maximum size</i>.  This parameter is the maximum
  # number of key-value mappings that the map is expected to hold.  Internally,
  # this parameter is used to determine the number of buckets initially
  # comprising the hash table.  The precise relationship between the expected
  # maximum size and the number of buckets is unspecified.
  # 
  # <p>If the size of the map (the number of key-value mappings) sufficiently
  # exceeds the expected maximum size, the number of buckets is increased
  # Increasing the number of buckets ("rehashing") may be fairly expensive, so
  # it pays to create identity hash maps with a sufficiently large expected
  # maximum size.  On the other hand, iteration over collection views requires
  # time proportional to the number of buckets in the hash table, so it
  # pays not to set the expected maximum size too high if you are especially
  # concerned with iteration performance or memory usage.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access an identity hash map concurrently, and at
  # least one of the threads modifies the map structurally, it <i>must</i>
  # be synchronized externally.  (A structural modification is any operation
  # that adds or deletes one or more mappings; merely changing the value
  # associated with a key that an instance already contains is not a
  # structural modification.)  This is typically accomplished by
  # synchronizing on some object that naturally encapsulates the map.
  # 
  # If no such object exists, the map should be "wrapped" using the
  # {@link Collections#synchronizedMap Collections.synchronizedMap}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the map:<pre>
  # Map m = Collections.synchronizedMap(new IdentityHashMap(...));</pre>
  # 
  # <p>The iterators returned by the <tt>iterator</tt> method of the
  # collections returned by all of this class's "collection view
  # methods" are <i>fail-fast</i>: if the map is structurally modified
  # at any time after the iterator is created, in any way except
  # through the iterator's own <tt>remove</tt> method, the iterator
  # will throw a {@link ConcurrentModificationException}.  Thus, in the
  # face of concurrent modification, the iterator fails quickly and
  # cleanly, rather than risking arbitrary, non-deterministic behavior
  # at an undetermined time in the future.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw <tt>ConcurrentModificationException</tt> on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness: <i>fail-fast iterators should be used only
  # to detect bugs.</i>
  # 
  # <p>Implementation note: This is a simple <i>linear-probe</i> hash table,
  # as described for example in texts by Sedgewick and Knuth.  The array
  # alternates holding keys and values.  (This has better locality for large
  # tables than does using separate arrays.)  For many JRE implementations
  # and operation mixes, this class will yield better performance than
  # {@link HashMap} (which uses <i>chaining</i> rather than linear-probing).
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @see     System#identityHashCode(Object)
  # @see     Object#hashCode()
  # @see     Collection
  # @see     Map
  # @see     HashMap
  # @see     TreeMap
  # @author  Doug Lea and Josh Bloch
  # @since   1.4
  class IdentityHashMap < IdentityHashMapImports.const_get :AbstractMap
    include_class_members IdentityHashMapImports
    include Map
    include Java::Io::Serializable
    include Cloneable
    
    class_module.module_eval {
      # The initial capacity used by the no-args constructor.
      # MUST be a power of two.  The value 32 corresponds to the
      # (specified) expected maximum size of 21, given a load factor
      # of 2/3.
      const_set_lazy(:DEFAULT_CAPACITY) { 32 }
      const_attr_reader  :DEFAULT_CAPACITY
      
      # The minimum capacity, used if a lower value is implicitly specified
      # by either of the constructors with arguments.  The value 4 corresponds
      # to an expected maximum size of 2, given a load factor of 2/3.
      # MUST be a power of two.
      const_set_lazy(:MINIMUM_CAPACITY) { 4 }
      const_attr_reader  :MINIMUM_CAPACITY
      
      # The maximum capacity, used if a higher value is implicitly specified
      # by either of the constructors with arguments.
      # MUST be a power of two <= 1<<29.
      const_set_lazy(:MAXIMUM_CAPACITY) { 1 << 29 }
      const_attr_reader  :MAXIMUM_CAPACITY
    }
    
    # The table, resized as necessary. Length MUST always be a power of two.
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    # The number of key-value mappings contained in this identity hash map.
    # 
    # @serial
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    # The number of modifications, to support fast-fail iterators
    attr_accessor :mod_count
    alias_method :attr_mod_count, :mod_count
    undef_method :mod_count
    alias_method :attr_mod_count=, :mod_count=
    undef_method :mod_count=
    
    # The next size value at which to resize (capacity * load factor).
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    class_module.module_eval {
      # Value representing null keys inside tables.
      const_set_lazy(:NULL_KEY) { Object.new }
      const_attr_reader  :NULL_KEY
      
      typesig { [Object] }
      # Use NULL_KEY for key if it is null.
      def mask_null(key)
        return ((key).nil? ? NULL_KEY : key)
      end
      
      typesig { [Object] }
      # Returns internal representation of null key back to caller as null.
      def unmask_null(key)
        return ((key).equal?(NULL_KEY) ? nil : key)
      end
    }
    
    typesig { [] }
    # Constructs a new, empty identity hash map with a default expected
    # maximum size (21).
    def initialize
      @table = nil
      @size = 0
      @mod_count = 0
      @threshold = 0
      @entry_set = nil
      super()
      @entry_set = nil
      init(DEFAULT_CAPACITY)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new, empty map with the specified expected maximum size.
    # Putting more than the expected number of key-value mappings into
    # the map may cause the internal data structure to grow, which may be
    # somewhat time-consuming.
    # 
    # @param expectedMaxSize the expected maximum size of the map
    # @throws IllegalArgumentException if <tt>expectedMaxSize</tt> is negative
    def initialize(expected_max_size)
      @table = nil
      @size = 0
      @mod_count = 0
      @threshold = 0
      @entry_set = nil
      super()
      @entry_set = nil
      if (expected_max_size < 0)
        raise IllegalArgumentException.new("expectedMaxSize is negative: " + (expected_max_size).to_s)
      end
      init(capacity(expected_max_size))
    end
    
    typesig { [::Java::Int] }
    # Returns the appropriate capacity for the specified expected maximum
    # size.  Returns the smallest power of two between MINIMUM_CAPACITY
    # and MAXIMUM_CAPACITY, inclusive, that is greater than
    # (3 * expectedMaxSize)/2, if such a number exists.  Otherwise
    # returns MAXIMUM_CAPACITY.  If (3 * expectedMaxSize)/2 is negative, it
    # is assumed that overflow has occurred, and MAXIMUM_CAPACITY is returned.
    def capacity(expected_max_size)
      # Compute min capacity for expectedMaxSize given a load factor of 2/3
      min_capacity = (3 * expected_max_size) / 2
      # Compute the appropriate capacity
      result = 0
      if (min_capacity > MAXIMUM_CAPACITY || min_capacity < 0)
        result = MAXIMUM_CAPACITY
      else
        result = MINIMUM_CAPACITY
        while (result < min_capacity)
          result <<= 1
        end
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # Initializes object to be an empty map with the specified initial
    # capacity, which is assumed to be a power of two between
    # MINIMUM_CAPACITY and MAXIMUM_CAPACITY inclusive.
    def init(init_capacity)
      # assert (initCapacity & -initCapacity) == initCapacity; // power of 2
      # assert initCapacity >= MINIMUM_CAPACITY;
      # assert initCapacity <= MAXIMUM_CAPACITY;
      @threshold = (init_capacity * 2) / 3
      @table = Array.typed(Object).new(2 * init_capacity) { nil }
    end
    
    typesig { [Map] }
    # Constructs a new identity hash map containing the keys-value mappings
    # in the specified map.
    # 
    # @param m the map whose mappings are to be placed into this map
    # @throws NullPointerException if the specified map is null
    def initialize(m)
      # Allow for a bit of growth
      initialize__identity_hash_map(RJava.cast_to_int(((1 + m.size) * 1.1)))
      put_all(m)
    end
    
    typesig { [] }
    # Returns the number of key-value mappings in this identity hash map.
    # 
    # @return the number of key-value mappings in this map
    def size
      return @size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this identity hash map contains no key-value
    # mappings.
    # 
    # @return <tt>true</tt> if this identity hash map contains no key-value
    # mappings
    def is_empty
      return (@size).equal?(0)
    end
    
    class_module.module_eval {
      typesig { [Object, ::Java::Int] }
      # Returns index for Object x.
      def hash(x, length)
        h = System.identity_hash_code(x)
        # Multiply by -127, and left-shift to use least bit as part of hash
        return ((h << 1) - (h << 8)) & (length - 1)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Circularly traverses table of size len.
      def next_key_index(i, len)
        return (i + 2 < len ? i + 2 : 0)
      end
    }
    
    typesig { [Object] }
    # Returns the value to which the specified key is mapped,
    # or {@code null} if this map contains no mapping for the key.
    # 
    # <p>More formally, if this map contains a mapping from a key
    # {@code k} to a value {@code v} such that {@code (key == k)},
    # then this method returns {@code v}; otherwise it returns
    # {@code null}.  (There can be at most one such mapping.)
    # 
    # <p>A return value of {@code null} does not <i>necessarily</i>
    # indicate that the map contains no mapping for the key; it's also
    # possible that the map explicitly maps the key to {@code null}.
    # The {@link #containsKey containsKey} operation may be used to
    # distinguish these two cases.
    # 
    # @see #put(Object, Object)
    def get(key)
      k = mask_null(key)
      tab = @table
      len = tab.attr_length
      i = hash(k, len)
      while (true)
        item = tab[i]
        if ((item).equal?(k))
          return tab[i + 1]
        end
        if ((item).nil?)
          return nil
        end
        i = next_key_index(i, len)
      end
    end
    
    typesig { [Object] }
    # Tests whether the specified object reference is a key in this identity
    # hash map.
    # 
    # @param   key   possible key
    # @return  <code>true</code> if the specified object reference is a key
    # in this map
    # @see     #containsValue(Object)
    def contains_key(key)
      k = mask_null(key)
      tab = @table
      len = tab.attr_length
      i = hash(k, len)
      while (true)
        item = tab[i]
        if ((item).equal?(k))
          return true
        end
        if ((item).nil?)
          return false
        end
        i = next_key_index(i, len)
      end
    end
    
    typesig { [Object] }
    # Tests whether the specified object reference is a value in this identity
    # hash map.
    # 
    # @param value value whose presence in this map is to be tested
    # @return <tt>true</tt> if this map maps one or more keys to the
    # specified object reference
    # @see     #containsKey(Object)
    def contains_value(value)
      tab = @table
      i = 1
      while i < tab.attr_length
        if ((tab[i]).equal?(value) && !(tab[i - 1]).nil?)
          return true
        end
        i += 2
      end
      return false
    end
    
    typesig { [Object, Object] }
    # Tests if the specified key-value mapping is in the map.
    # 
    # @param   key   possible key
    # @param   value possible value
    # @return  <code>true</code> if and only if the specified key-value
    # mapping is in the map
    def contains_mapping(key, value)
      k = mask_null(key)
      tab = @table
      len = tab.attr_length
      i = hash(k, len)
      while (true)
        item = tab[i]
        if ((item).equal?(k))
          return (tab[i + 1]).equal?(value)
        end
        if ((item).nil?)
          return false
        end
        i = next_key_index(i, len)
      end
    end
    
    typesig { [Object, Object] }
    # Associates the specified value with the specified key in this identity
    # hash map.  If the map previously contained a mapping for the key, the
    # old value is replaced.
    # 
    # @param key the key with which the specified value is to be associated
    # @param value the value to be associated with the specified key
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>.
    # (A <tt>null</tt> return can also indicate that the map
    # previously associated <tt>null</tt> with <tt>key</tt>.)
    # @see     Object#equals(Object)
    # @see     #get(Object)
    # @see     #containsKey(Object)
    def put(key, value)
      k = mask_null(key)
      tab = @table
      len = tab.attr_length
      i = hash(k, len)
      item = nil
      while (!((item = tab[i])).nil?)
        if ((item).equal?(k))
          old_value = tab[i + 1]
          tab[i + 1] = value
          return old_value
        end
        i = next_key_index(i, len)
      end
      ((@mod_count += 1) - 1)
      tab[i] = k
      tab[i + 1] = value
      if ((@size += 1) >= @threshold)
        resize(len)
      end # len == 2 * current capacity.
      return nil
    end
    
    typesig { [::Java::Int] }
    # Resize the table to hold given capacity.
    # 
    # @param newCapacity the new capacity, must be a power of two.
    def resize(new_capacity)
      # assert (newCapacity & -newCapacity) == newCapacity; // power of 2
      new_length = new_capacity * 2
      old_table = @table
      old_length = old_table.attr_length
      if ((old_length).equal?(2 * MAXIMUM_CAPACITY))
        # can't expand any further
        if ((@threshold).equal?(MAXIMUM_CAPACITY - 1))
          raise IllegalStateException.new("Capacity exhausted.")
        end
        @threshold = MAXIMUM_CAPACITY - 1 # Gigantic map!
        return
      end
      if (old_length >= new_length)
        return
      end
      new_table = Array.typed(Object).new(new_length) { nil }
      @threshold = new_length / 3
      j = 0
      while j < old_length
        key = old_table[j]
        if (!(key).nil?)
          value = old_table[j + 1]
          old_table[j] = nil
          old_table[j + 1] = nil
          i = hash(key, new_length)
          while (!(new_table[i]).nil?)
            i = next_key_index(i, new_length)
          end
          new_table[i] = key
          new_table[i + 1] = value
        end
        j += 2
      end
      @table = new_table
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified map to this map.
    # These mappings will replace any mappings that this map had for
    # any of the keys currently in the specified map.
    # 
    # @param m mappings to be stored in this map
    # @throws NullPointerException if the specified map is null
    def put_all(m)
      n = m.size
      if ((n).equal?(0))
        return
      end
      if (n > @threshold)
        # conservatively pre-expand
        resize(capacity(n))
      end
      m.entry_set.each do |e|
        put(e.get_key, e.get_value)
      end
    end
    
    typesig { [Object] }
    # Removes the mapping for this key from this map if present.
    # 
    # @param key key whose mapping is to be removed from the map
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>.
    # (A <tt>null</tt> return can also indicate that the map
    # previously associated <tt>null</tt> with <tt>key</tt>.)
    def remove(key)
      k = mask_null(key)
      tab = @table
      len = tab.attr_length
      i = hash(k, len)
      while (true)
        item = tab[i]
        if ((item).equal?(k))
          ((@mod_count += 1) - 1)
          ((@size -= 1) + 1)
          old_value = tab[i + 1]
          tab[i + 1] = nil
          tab[i] = nil
          close_deletion(i)
          return old_value
        end
        if ((item).nil?)
          return nil
        end
        i = next_key_index(i, len)
      end
    end
    
    typesig { [Object, Object] }
    # Removes the specified key-value mapping from the map if it is present.
    # 
    # @param   key   possible key
    # @param   value possible value
    # @return  <code>true</code> if and only if the specified key-value
    # mapping was in the map
    def remove_mapping(key, value)
      k = mask_null(key)
      tab = @table
      len = tab.attr_length
      i = hash(k, len)
      while (true)
        item = tab[i]
        if ((item).equal?(k))
          if (!(tab[i + 1]).equal?(value))
            return false
          end
          ((@mod_count += 1) - 1)
          ((@size -= 1) + 1)
          tab[i] = nil
          tab[i + 1] = nil
          close_deletion(i)
          return true
        end
        if ((item).nil?)
          return false
        end
        i = next_key_index(i, len)
      end
    end
    
    typesig { [::Java::Int] }
    # Rehash all possibly-colliding entries following a
    # deletion. This preserves the linear-probe
    # collision properties required by get, put, etc.
    # 
    # @param d the index of a newly empty deleted slot
    def close_deletion(d)
      # Adapted from Knuth Section 6.4 Algorithm R
      tab = @table
      len = tab.attr_length
      # Look for items to swap into newly vacated slot
      # starting at index immediately following deletion,
      # and continuing until a null slot is seen, indicating
      # the end of a run of possibly-colliding keys.
      item = nil
      i = next_key_index(d, len)
      while !((item = tab[i])).nil?
        # The following test triggers if the item at slot i (which
        # hashes to be at slot r) should take the spot vacated by d.
        # If so, we swap it in, and then continue with d now at the
        # newly vacated i.  This process will terminate when we hit
        # the null slot at the end of this run.
        # The test is messy because we are using a circular table.
        r = hash(item, len)
        if ((i < r && (r <= d || d <= i)) || (r <= d && d <= i))
          tab[d] = item
          tab[d + 1] = tab[i + 1]
          tab[i] = nil
          tab[i + 1] = nil
          d = i
        end
        i = next_key_index(i, len)
      end
    end
    
    typesig { [] }
    # Removes all of the mappings from this map.
    # The map will be empty after this call returns.
    def clear
      ((@mod_count += 1) - 1)
      tab = @table
      i = 0
      while i < tab.attr_length
        tab[i] = nil
        ((i += 1) - 1)
      end
      @size = 0
    end
    
    typesig { [Object] }
    # Compares the specified object with this map for equality.  Returns
    # <tt>true</tt> if the given object is also a map and the two maps
    # represent identical object-reference mappings.  More formally, this
    # map is equal to another map <tt>m</tt> if and only if
    # <tt>this.entrySet().equals(m.entrySet())</tt>.
    # 
    # <p><b>Owing to the reference-equality-based semantics of this map it is
    # possible that the symmetry and transitivity requirements of the
    # <tt>Object.equals</tt> contract may be violated if this map is compared
    # to a normal map.  However, the <tt>Object.equals</tt> contract is
    # guaranteed to hold among <tt>IdentityHashMap</tt> instances.</b>
    # 
    # @param  o object to be compared for equality with this map
    # @return <tt>true</tt> if the specified object is equal to this map
    # @see Object#equals(Object)
    def equals(o)
      if ((o).equal?(self))
        return true
      else
        if (o.is_a?(IdentityHashMap))
          m = o
          if (!(m.size).equal?(@size))
            return false
          end
          tab = m.attr_table
          i = 0
          while i < tab.attr_length
            k = tab[i]
            if (!(k).nil? && !contains_mapping(k, tab[i + 1]))
              return false
            end
            i += 2
          end
          return true
        else
          if (o.is_a?(Map))
            m = o
            return (entry_set == m.entry_set)
          else
            return false # o is not a Map
          end
        end
      end
    end
    
    typesig { [] }
    # Returns the hash code value for this map.  The hash code of a map is
    # defined to be the sum of the hash codes of each entry in the map's
    # <tt>entrySet()</tt> view.  This ensures that <tt>m1.equals(m2)</tt>
    # implies that <tt>m1.hashCode()==m2.hashCode()</tt> for any two
    # <tt>IdentityHashMap</tt> instances <tt>m1</tt> and <tt>m2</tt>, as
    # required by the general contract of {@link Object#hashCode}.
    # 
    # <p><b>Owing to the reference-equality-based semantics of the
    # <tt>Map.Entry</tt> instances in the set returned by this map's
    # <tt>entrySet</tt> method, it is possible that the contractual
    # requirement of <tt>Object.hashCode</tt> mentioned in the previous
    # paragraph will be violated if one of the two objects being compared is
    # an <tt>IdentityHashMap</tt> instance and the other is a normal map.</b>
    # 
    # @return the hash code value for this map
    # @see Object#equals(Object)
    # @see #equals(Object)
    def hash_code
      result = 0
      tab = @table
      i = 0
      while i < tab.attr_length
        key = tab[i]
        if (!(key).nil?)
          k = unmask_null(key)
          result += System.identity_hash_code(k) ^ System.identity_hash_code(tab[i + 1])
        end
        i += 2
      end
      return result
    end
    
    typesig { [] }
    # Returns a shallow copy of this identity hash map: the keys and values
    # themselves are not cloned.
    # 
    # @return a shallow copy of this map
    def clone
      begin
        m = super
        m.attr_entry_set = nil
        m.attr_table = @table.clone
        return m
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:IdentityHashMapIterator) { Class.new do
        extend LocalClass
        include_class_members IdentityHashMap
        include Iterator
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        # current slot.
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        # to support fast-fail
        attr_accessor :last_returned_index
        alias_method :attr_last_returned_index, :last_returned_index
        undef_method :last_returned_index
        alias_method :attr_last_returned_index=, :last_returned_index=
        undef_method :last_returned_index=
        
        # to allow remove()
        attr_accessor :index_valid
        alias_method :attr_index_valid, :index_valid
        undef_method :index_valid
        alias_method :attr_index_valid=, :index_valid=
        undef_method :index_valid=
        
        # To avoid unnecessary next computation
        attr_accessor :traversal_table
        alias_method :attr_traversal_table, :traversal_table
        undef_method :traversal_table
        alias_method :attr_traversal_table=, :traversal_table=
        undef_method :traversal_table=
        
        typesig { [] }
        # reference to main table or copy
        def has_next
          tab = @traversal_table
          i = @index
          while i < tab.attr_length
            key = tab[i]
            if (!(key).nil?)
              @index = i
              return @index_valid = true
            end
            i += 2
          end
          @index = tab.attr_length
          return false
        end
        
        typesig { [] }
        def next_index
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          if (!@index_valid && !has_next)
            raise NoSuchElementException.new
          end
          @index_valid = false
          @last_returned_index = @index
          @index += 2
          return @last_returned_index
        end
        
        typesig { [] }
        def remove
          if ((@last_returned_index).equal?(-1))
            raise IllegalStateException.new
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          @expected_mod_count = (self.attr_mod_count += 1)
          deleted_slot = @last_returned_index
          @last_returned_index = -1
          ((self.attr_size -= 1) + 1)
          # back up index to revisit new contents after deletion
          @index = deleted_slot
          @index_valid = false
          # Removal code proceeds as in closeDeletion except that
          # it must catch the rare case where an element already
          # seen is swapped into a vacant slot that will be later
          # traversed by this iterator. We cannot allow future
          # next() calls to return it again.  The likelihood of
          # this occurring under 2/3 load factor is very slim, but
          # when it does happen, we must make a copy of the rest of
          # the table to use for the rest of the traversal. Since
          # this can only happen when we are near the end of the table,
          # even in these rare cases, this is not very expensive in
          # time or space.
          tab = @traversal_table
          len = tab.attr_length
          d = deleted_slot
          key = tab[d]
          tab[d] = nil # vacate the slot
          tab[d + 1] = nil
          # If traversing a copy, remove in real table.
          # We can skip gap-closure on copy.
          if (!(tab).equal?(@local_class_parent.attr_table))
            @local_class_parent.remove(key)
            @expected_mod_count = self.attr_mod_count
            return
          end
          item = nil
          i = next_key_index(d, len)
          while !((item = tab[i])).nil?
            r = hash(item, len)
            # See closeDeletion for explanation of this conditional
            if ((i < r && (r <= d || d <= i)) || (r <= d && d <= i))
              # If we are about to swap an already-seen element
              # into a slot that may later be returned by next(),
              # then clone the rest of table for use in future
              # next() calls. It is OK that our copy will have
              # a gap in the "wrong" place, since it will never
              # be used for searching anyway.
              if (i < deleted_slot && d >= deleted_slot && (@traversal_table).equal?(@local_class_parent.attr_table))
                remaining = len - deleted_slot
                new_table = Array.typed(Object).new(remaining) { nil }
                System.arraycopy(tab, deleted_slot, new_table, 0, remaining)
                @traversal_table = new_table
                @index = 0
              end
              tab[d] = item
              tab[d + 1] = tab[i + 1]
              tab[i] = nil
              tab[i + 1] = nil
              d = i
            end
            i = next_key_index(i, len)
          end
        end
        
        typesig { [] }
        def initialize
          @index = (!(self.attr_size).equal?(0) ? 0 : self.attr_table.attr_length)
          @expected_mod_count = self.attr_mod_count
          @last_returned_index = -1
          @index_valid = false
          @traversal_table = self.attr_table
        end
        
        private
        alias_method :initialize__identity_hash_map_iterator, :initialize
      end }
      
      const_set_lazy(:KeyIterator) { Class.new(IdentityHashMapIterator) do
        extend LocalClass
        include_class_members IdentityHashMap
        
        typesig { [] }
        def next
          return unmask_null(self.attr_traversal_table[next_index])
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__key_iterator, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(IdentityHashMapIterator) do
        extend LocalClass
        include_class_members IdentityHashMap
        
        typesig { [] }
        def next
          return self.attr_traversal_table[next_index + 1]
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__value_iterator, :initialize
      end }
      
      # Since we don't use Entry objects, we use the Iterator
      # itself as an entry.
      const_set_lazy(:EntryIterator) { Class.new(IdentityHashMapIterator) do
        extend LocalClass
        include_class_members IdentityHashMap
        include Map::Entry
        
        typesig { [] }
        def next
          next_index
          return self
        end
        
        typesig { [] }
        def get_key
          # Provide a better exception than out of bounds index
          if (self.attr_last_returned_index < 0)
            raise IllegalStateException.new("Entry was removed")
          end
          return unmask_null(self.attr_traversal_table[self.attr_last_returned_index])
        end
        
        typesig { [] }
        def get_value
          # Provide a better exception than out of bounds index
          if (self.attr_last_returned_index < 0)
            raise IllegalStateException.new("Entry was removed")
          end
          return self.attr_traversal_table[self.attr_last_returned_index + 1]
        end
        
        typesig { [V] }
        def set_value(value)
          # It would be mean-spirited to proceed here if remove() called
          if (self.attr_last_returned_index < 0)
            raise IllegalStateException.new("Entry was removed")
          end
          old_value = self.attr_traversal_table[self.attr_last_returned_index + 1]
          self.attr_traversal_table[self.attr_last_returned_index + 1] = value
          # if shadowing, force into main table
          if (!(self.attr_traversal_table).equal?(@local_class_parent.attr_table))
            put(self.attr_traversal_table[self.attr_last_returned_index], value)
          end
          return old_value
        end
        
        typesig { [Object] }
        def equals(o)
          if (self.attr_last_returned_index < 0)
            return super(o)
          end
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          e = o
          return (e.get_key).equal?(get_key) && (e.get_value).equal?(get_value)
        end
        
        typesig { [] }
        def hash_code
          if (self.attr_last_returned_index < 0)
            return super
          end
          return System.identity_hash_code(get_key) ^ System.identity_hash_code(get_value)
        end
        
        typesig { [] }
        def to_s
          if (self.attr_last_returned_index < 0)
            return super
          end
          return (get_key).to_s + "=" + (get_value).to_s
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_iterator, :initialize
      end }
    }
    
    # Views
    # 
    # This field is initialized to contain an instance of the entry set
    # view the first time this view is requested.  The view is stateless,
    # so there's no reason to create more than one.
    attr_accessor :entry_set
    alias_method :attr_entry_set, :entry_set
    undef_method :entry_set
    alias_method :attr_entry_set=, :entry_set=
    undef_method :entry_set=
    
    typesig { [] }
    # Returns an identity-based set view of the keys contained in this map.
    # The set is backed by the map, so changes to the map are reflected in
    # the set, and vice-versa.  If the map is modified while an iteration
    # over the set is in progress, the results of the iteration are
    # undefined.  The set supports element removal, which removes the
    # corresponding mapping from the map, via the <tt>Iterator.remove</tt>,
    # <tt>Set.remove</tt>, <tt>removeAll</tt>, <tt>retainAll</tt>, and
    # <tt>clear</tt> methods.  It does not support the <tt>add</tt> or
    # <tt>addAll</tt> methods.
    # 
    # <p><b>While the object returned by this method implements the
    # <tt>Set</tt> interface, it does <i>not</i> obey <tt>Set's</tt> general
    # contract.  Like its backing map, the set returned by this method
    # defines element equality as reference-equality rather than
    # object-equality.  This affects the behavior of its <tt>contains</tt>,
    # <tt>remove</tt>, <tt>containsAll</tt>, <tt>equals</tt>, and
    # <tt>hashCode</tt> methods.</b>
    # 
    # <p><b>The <tt>equals</tt> method of the returned set returns <tt>true</tt>
    # only if the specified object is a set containing exactly the same
    # object references as the returned set.  The symmetry and transitivity
    # requirements of the <tt>Object.equals</tt> contract may be violated if
    # the set returned by this method is compared to a normal set.  However,
    # the <tt>Object.equals</tt> contract is guaranteed to hold among sets
    # returned by this method.</b>
    # 
    # <p>The <tt>hashCode</tt> method of the returned set returns the sum of
    # the <i>identity hashcodes</i> of the elements in the set, rather than
    # the sum of their hashcodes.  This is mandated by the change in the
    # semantics of the <tt>equals</tt> method, in order to enforce the
    # general contract of the <tt>Object.hashCode</tt> method among sets
    # returned by this method.
    # 
    # @return an identity-based set view of the keys contained in this map
    # @see Object#equals(Object)
    # @see System#identityHashCode(Object)
    def key_set
      ks = self.attr_key_set
      if (!(ks).nil?)
        return ks
      else
        return self.attr_key_set = KeySet.new_local(self)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:KeySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members IdentityHashMap
        
        typesig { [] }
        def iterator
          return KeyIterator.new
        end
        
        typesig { [] }
        def size
          return self.attr_size
        end
        
        typesig { [Object] }
        def contains(o)
          return contains_key(o)
        end
        
        typesig { [Object] }
        def remove(o)
          old_size = self.attr_size
          @local_class_parent.remove(o)
          return !(self.attr_size).equal?(old_size)
        end
        
        typesig { [Collection] }
        # Must revert from AbstractSet's impl to AbstractCollection's, as
        # the former contains an optimization that results in incorrect
        # behavior when c is a smaller "normal" (non-identity-based) Set.
        def remove_all(c)
          modified = false
          i = iterator
          while i.has_next
            if (c.contains(i.next))
              i.remove
              modified = true
            end
          end
          return modified
        end
        
        typesig { [] }
        def clear
          @local_class_parent.clear
        end
        
        typesig { [] }
        def hash_code
          result = 0
          self.each do |key|
            result += System.identity_hash_code(key)
          end
          return result
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__key_set, :initialize
      end }
    }
    
    typesig { [] }
    # Returns a {@link Collection} view of the values contained in this map.
    # The collection is backed by the map, so changes to the map are
    # reflected in the collection, and vice-versa.  If the map is
    # modified while an iteration over the collection is in progress,
    # the results of the iteration are undefined.  The collection
    # supports element removal, which removes the corresponding
    # mapping from the map, via the <tt>Iterator.remove</tt>,
    # <tt>Collection.remove</tt>, <tt>removeAll</tt>,
    # <tt>retainAll</tt> and <tt>clear</tt> methods.  It does not
    # support the <tt>add</tt> or <tt>addAll</tt> methods.
    # 
    # <p><b>While the object returned by this method implements the
    # <tt>Collection</tt> interface, it does <i>not</i> obey
    # <tt>Collection's</tt> general contract.  Like its backing map,
    # the collection returned by this method defines element equality as
    # reference-equality rather than object-equality.  This affects the
    # behavior of its <tt>contains</tt>, <tt>remove</tt> and
    # <tt>containsAll</tt> methods.</b>
    def values
      vs = self.attr_values
      if (!(vs).nil?)
        return vs
      else
        return self.attr_values = Values.new_local(self)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:Values) { Class.new(AbstractCollection) do
        extend LocalClass
        include_class_members IdentityHashMap
        
        typesig { [] }
        def iterator
          return ValueIterator.new
        end
        
        typesig { [] }
        def size
          return self.attr_size
        end
        
        typesig { [Object] }
        def contains(o)
          return contains_value(o)
        end
        
        typesig { [Object] }
        def remove(o)
          i = iterator
          while i.has_next
            if ((i.next).equal?(o))
              i.remove
              return true
            end
          end
          return false
        end
        
        typesig { [] }
        def clear
          @local_class_parent.clear
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__values, :initialize
      end }
    }
    
    typesig { [] }
    # Returns a {@link Set} view of the mappings contained in this map.
    # Each element in the returned set is a reference-equality-based
    # <tt>Map.Entry</tt>.  The set is backed by the map, so changes
    # to the map are reflected in the set, and vice-versa.  If the
    # map is modified while an iteration over the set is in progress,
    # the results of the iteration are undefined.  The set supports
    # element removal, which removes the corresponding mapping from
    # the map, via the <tt>Iterator.remove</tt>, <tt>Set.remove</tt>,
    # <tt>removeAll</tt>, <tt>retainAll</tt> and <tt>clear</tt>
    # methods.  It does not support the <tt>add</tt> or
    # <tt>addAll</tt> methods.
    # 
    # <p>Like the backing map, the <tt>Map.Entry</tt> objects in the set
    # returned by this method define key and value equality as
    # reference-equality rather than object-equality.  This affects the
    # behavior of the <tt>equals</tt> and <tt>hashCode</tt> methods of these
    # <tt>Map.Entry</tt> objects.  A reference-equality based <tt>Map.Entry
    # e</tt> is equal to an object <tt>o</tt> if and only if <tt>o</tt> is a
    # <tt>Map.Entry</tt> and <tt>e.getKey()==o.getKey() &amp;&amp;
    # e.getValue()==o.getValue()</tt>.  To accommodate these equals
    # semantics, the <tt>hashCode</tt> method returns
    # <tt>System.identityHashCode(e.getKey()) ^
    # System.identityHashCode(e.getValue())</tt>.
    # 
    # <p><b>Owing to the reference-equality-based semantics of the
    # <tt>Map.Entry</tt> instances in the set returned by this method,
    # it is possible that the symmetry and transitivity requirements of
    # the {@link Object#equals(Object)} contract may be violated if any of
    # the entries in the set is compared to a normal map entry, or if
    # the set returned by this method is compared to a set of normal map
    # entries (such as would be returned by a call to this method on a normal
    # map).  However, the <tt>Object.equals</tt> contract is guaranteed to
    # hold among identity-based map entries, and among sets of such entries.
    # </b>
    # 
    # @return a set view of the identity-mappings contained in this map
    def entry_set
      es = @entry_set
      if (!(es).nil?)
        return es
      else
        return @entry_set = EntrySet.new_local(self)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members IdentityHashMap
        
        typesig { [] }
        def iterator
          return EntryIterator.new
        end
        
        typesig { [Object] }
        def contains(o)
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          entry = o
          return contains_mapping(entry.get_key, entry.get_value)
        end
        
        typesig { [Object] }
        def remove(o)
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          entry = o
          return remove_mapping(entry.get_key, entry.get_value)
        end
        
        typesig { [] }
        def size
          return self.attr_size
        end
        
        typesig { [] }
        def clear
          @local_class_parent.clear
        end
        
        typesig { [Collection] }
        # Must revert from AbstractSet's impl to AbstractCollection's, as
        # the former contains an optimization that results in incorrect
        # behavior when c is a smaller "normal" (non-identity-based) Set.
        def remove_all(c)
          modified = false
          i = iterator
          while i.has_next
            if (c.contains(i.next))
              i.remove
              modified = true
            end
          end
          return modified
        end
        
        typesig { [] }
        def to_array
          size_ = size
          result = Array.typed(Object).new(size_) { nil }
          it = iterator
          i = 0
          while i < size_
            result[i] = AbstractMap::SimpleEntry.new(it.next)
            ((i += 1) - 1)
          end
          return result
        end
        
        typesig { [Array.typed(T)] }
        def to_array(a)
          size_ = size
          if (a.attr_length < size_)
            a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, size_)
          end
          it = iterator
          i = 0
          while i < size_
            a[i] = AbstractMap::SimpleEntry.new(it.next)
            ((i += 1) - 1)
          end
          if (a.attr_length > size_)
            a[size_] = nil
          end
          return a
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_set, :initialize
      end }
      
      const_set_lazy(:SerialVersionUID) { 8188218128353913216 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the <tt>IdentityHashMap</tt> instance to a stream
    # (i.e., serialize it).
    # 
    # @serialData The <i>size</i> of the HashMap (the number of key-value
    # mappings) (<tt>int</tt>), followed by the key (Object) and
    # value (Object) for each key-value mapping represented by the
    # IdentityHashMap.  The key-value mappings are emitted in no
    # particular order.
    def write_object(s)
      # Write out and any hidden stuff
      s.default_write_object
      # Write out size (number of Mappings)
      s.write_int(@size)
      # Write out keys and values (alternating)
      tab = @table
      i = 0
      while i < tab.attr_length
        key = tab[i]
        if (!(key).nil?)
          s.write_object(unmask_null(key))
          s.write_object(tab[i + 1])
        end
        i += 2
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the <tt>IdentityHashMap</tt> instance from a stream (i.e.,
    # deserialize it).
    def read_object(s)
      # Read in any hidden stuff
      s.default_read_object
      # Read in size (number of Mappings)
      size_ = s.read_int
      # Allow for 33% growth (i.e., capacity is >= 2* size()).
      init(capacity((size_ * 4) / 3))
      # Read the keys and values, and put the mappings in the table
      i = 0
      while i < size_
        key = s.read_object
        value = s.read_object
        put_for_create(key, value)
        ((i += 1) - 1)
      end
    end
    
    typesig { [Object, Object] }
    # The put method for readObject.  It does not resize the table,
    # update modCount, etc.
    def put_for_create(key, value)
      k = mask_null(key)
      tab = @table
      len = tab.attr_length
      i = hash(k, len)
      item = nil
      while (!((item = tab[i])).nil?)
        if ((item).equal?(k))
          raise Java::Io::StreamCorruptedException.new
        end
        i = next_key_index(i, len)
      end
      tab[i] = k
      tab[i + 1] = value
    end
    
    private
    alias_method :initialize__identity_hash_map, :initialize
  end
  
end
