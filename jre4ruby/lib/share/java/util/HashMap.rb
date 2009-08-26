require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module HashMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
    }
  end
  
  # Hash table based implementation of the <tt>Map</tt> interface.  This
  # implementation provides all of the optional map operations, and permits
  # <tt>null</tt> values and the <tt>null</tt> key.  (The <tt>HashMap</tt>
  # class is roughly equivalent to <tt>Hashtable</tt>, except that it is
  # unsynchronized and permits nulls.)  This class makes no guarantees as to
  # the order of the map; in particular, it does not guarantee that the order
  # will remain constant over time.
  # 
  # <p>This implementation provides constant-time performance for the basic
  # operations (<tt>get</tt> and <tt>put</tt>), assuming the hash function
  # disperses the elements properly among the buckets.  Iteration over
  # collection views requires time proportional to the "capacity" of the
  # <tt>HashMap</tt> instance (the number of buckets) plus its size (the number
  # of key-value mappings).  Thus, it's very important not to set the initial
  # capacity too high (or the load factor too low) if iteration performance is
  # important.
  # 
  # <p>An instance of <tt>HashMap</tt> has two parameters that affect its
  # performance: <i>initial capacity</i> and <i>load factor</i>.  The
  # <i>capacity</i> is the number of buckets in the hash table, and the initial
  # capacity is simply the capacity at the time the hash table is created.  The
  # <i>load factor</i> is a measure of how full the hash table is allowed to
  # get before its capacity is automatically increased.  When the number of
  # entries in the hash table exceeds the product of the load factor and the
  # current capacity, the hash table is <i>rehashed</i> (that is, internal data
  # structures are rebuilt) so that the hash table has approximately twice the
  # number of buckets.
  # 
  # <p>As a general rule, the default load factor (.75) offers a good tradeoff
  # between time and space costs.  Higher values decrease the space overhead
  # but increase the lookup cost (reflected in most of the operations of the
  # <tt>HashMap</tt> class, including <tt>get</tt> and <tt>put</tt>).  The
  # expected number of entries in the map and its load factor should be taken
  # into account when setting its initial capacity, so as to minimize the
  # number of rehash operations.  If the initial capacity is greater
  # than the maximum number of entries divided by the load factor, no
  # rehash operations will ever occur.
  # 
  # <p>If many mappings are to be stored in a <tt>HashMap</tt> instance,
  # creating it with a sufficiently large capacity will allow the mappings to
  # be stored more efficiently than letting it perform automatic rehashing as
  # needed to grow the table.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access a hash map concurrently, and at least one of
  # the threads modifies the map structurally, it <i>must</i> be
  # synchronized externally.  (A structural modification is any operation
  # that adds or deletes one or more mappings; merely changing the value
  # associated with a key that an instance already contains is not a
  # structural modification.)  This is typically accomplished by
  # synchronizing on some object that naturally encapsulates the map.
  # 
  # If no such object exists, the map should be "wrapped" using the
  # {@link Collections#synchronizedMap Collections.synchronizedMap}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the map:<pre>
  # Map m = Collections.synchronizedMap(new HashMap(...));</pre>
  # 
  # <p>The iterators returned by all of this class's "collection view methods"
  # are <i>fail-fast</i>: if the map is structurally modified at any time after
  # the iterator is created, in any way except through the iterator's own
  # <tt>remove</tt> method, the iterator will throw a
  # {@link ConcurrentModificationException}.  Thus, in the face of concurrent
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
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # 
  # @author  Doug Lea
  # @author  Josh Bloch
  # @author  Arthur van Hoff
  # @author  Neal Gafter
  # @see     Object#hashCode()
  # @see     Collection
  # @see     Map
  # @see     TreeMap
  # @see     Hashtable
  # @since   1.2
  class HashMap < HashMapImports.const_get :AbstractMap
    include_class_members HashMapImports
    overload_protected {
      include Map
      include Cloneable
      include Serializable
    }
    
    class_module.module_eval {
      # The default initial capacity - MUST be a power of two.
      const_set_lazy(:DEFAULT_INITIAL_CAPACITY) { 16 }
      const_attr_reader  :DEFAULT_INITIAL_CAPACITY
      
      # The maximum capacity, used if a higher value is implicitly specified
      # by either of the constructors with arguments.
      # MUST be a power of two <= 1<<30.
      const_set_lazy(:MAXIMUM_CAPACITY) { 1 << 30 }
      const_attr_reader  :MAXIMUM_CAPACITY
      
      # The load factor used when none specified in constructor.
      const_set_lazy(:DEFAULT_LOAD_FACTOR) { 0.75 }
      const_attr_reader  :DEFAULT_LOAD_FACTOR
    }
    
    # The table, resized as necessary. Length MUST Always be a power of two.
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    # The number of key-value mappings contained in this map.
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    # The next size value at which to resize (capacity * load factor).
    # @serial
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    # The load factor for the hash table.
    # 
    # @serial
    attr_accessor :load_factor
    alias_method :attr_load_factor, :load_factor
    undef_method :load_factor
    alias_method :attr_load_factor=, :load_factor=
    undef_method :load_factor=
    
    # The number of times this HashMap has been structurally modified
    # Structural modifications are those that change the number of mappings in
    # the HashMap or otherwise modify its internal structure (e.g.,
    # rehash).  This field is used to make iterators on Collection-views of
    # the HashMap fail-fast.  (See ConcurrentModificationException).
    attr_accessor :mod_count
    alias_method :attr_mod_count, :mod_count
    undef_method :mod_count
    alias_method :attr_mod_count=, :mod_count=
    undef_method :mod_count=
    
    typesig { [::Java::Int, ::Java::Float] }
    # Constructs an empty <tt>HashMap</tt> with the specified initial
    # capacity and load factor.
    # 
    # @param  initialCapacity the initial capacity
    # @param  loadFactor      the load factor
    # @throws IllegalArgumentException if the initial capacity is negative
    # or the load factor is nonpositive
    def initialize(initial_capacity, load_factor)
      @table = nil
      @size = 0
      @threshold = 0
      @load_factor = 0.0
      @mod_count = 0
      @entry_set = nil
      super()
      @entry_set = nil
      if (initial_capacity < 0)
        raise IllegalArgumentException.new("Illegal initial capacity: " + RJava.cast_to_string(initial_capacity))
      end
      if (initial_capacity > MAXIMUM_CAPACITY)
        initial_capacity = MAXIMUM_CAPACITY
      end
      if (load_factor <= 0 || Float.is_na_n(load_factor))
        raise IllegalArgumentException.new("Illegal load factor: " + RJava.cast_to_string(load_factor))
      end
      # Find a power of 2 >= initialCapacity
      capacity = 1
      while (capacity < initial_capacity)
        capacity <<= 1
      end
      @load_factor = load_factor
      @threshold = RJava.cast_to_int((capacity * load_factor))
      @table = Array.typed(Entry).new(capacity) { nil }
      init
    end
    
    typesig { [::Java::Int] }
    # Constructs an empty <tt>HashMap</tt> with the specified initial
    # capacity and the default load factor (0.75).
    # 
    # @param  initialCapacity the initial capacity.
    # @throws IllegalArgumentException if the initial capacity is negative.
    def initialize(initial_capacity)
      initialize__hash_map(initial_capacity, DEFAULT_LOAD_FACTOR)
    end
    
    typesig { [] }
    # Constructs an empty <tt>HashMap</tt> with the default initial capacity
    # (16) and the default load factor (0.75).
    def initialize
      @table = nil
      @size = 0
      @threshold = 0
      @load_factor = 0.0
      @mod_count = 0
      @entry_set = nil
      super()
      @entry_set = nil
      @load_factor = DEFAULT_LOAD_FACTOR
      @threshold = RJava.cast_to_int((DEFAULT_INITIAL_CAPACITY * DEFAULT_LOAD_FACTOR))
      @table = Array.typed(Entry).new(DEFAULT_INITIAL_CAPACITY) { nil }
      init
    end
    
    typesig { [Map] }
    # Constructs a new <tt>HashMap</tt> with the same mappings as the
    # specified <tt>Map</tt>.  The <tt>HashMap</tt> is created with
    # default load factor (0.75) and an initial capacity sufficient to
    # hold the mappings in the specified <tt>Map</tt>.
    # 
    # @param   m the map whose mappings are to be placed in this map
    # @throws  NullPointerException if the specified map is null
    def initialize(m)
      initialize__hash_map(Math.max(RJava.cast_to_int((m.size / DEFAULT_LOAD_FACTOR)) + 1, DEFAULT_INITIAL_CAPACITY), DEFAULT_LOAD_FACTOR)
      put_all_for_create(m)
    end
    
    typesig { [] }
    # internal utilities
    # 
    # Initialization hook for subclasses. This method is called
    # in all constructors and pseudo-constructors (clone, readObject)
    # after HashMap has been initialized but before any entries have
    # been inserted.  (In the absence of this method, readObject would
    # require explicit knowledge of subclasses.)
    def init
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Applies a supplemental hash function to a given hashCode, which
      # defends against poor quality hash functions.  This is critical
      # because HashMap uses power-of-two length hash tables, that
      # otherwise encounter collisions for hashCodes that do not differ
      # in lower bits. Note: Null keys always map to hash 0, thus index 0.
      def hash(h)
        # This function ensures that hashCodes that differ only by
        # constant multiples at each bit position have a bounded
        # number of collisions (approximately 8 at default load factor).
        h ^= (h >> 20) ^ (h >> 12)
        return h ^ (h >> 7) ^ (h >> 4)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns index for hash code h.
      def index_for(h, length)
        return h & (length - 1)
      end
    }
    
    typesig { [] }
    # Returns the number of key-value mappings in this map.
    # 
    # @return the number of key-value mappings in this map
    def size
      return @size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this map contains no key-value mappings.
    # 
    # @return <tt>true</tt> if this map contains no key-value mappings
    def is_empty
      return (@size).equal?(0)
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
    # 
    # @see #put(Object, Object)
    def get(key)
      if ((key).nil?)
        return get_for_null_key
      end
      hash_ = hash(key.hash_code)
      e = @table[index_for(hash_, @table.attr_length)]
      while !(e).nil?
        k = nil
        if ((e.attr_hash).equal?(hash_) && (((k = e.attr_key)).equal?(key) || (key == k)))
          return e.attr_value
        end
        e = e.attr_next
      end
      return nil
    end
    
    typesig { [] }
    # Offloaded version of get() to look up null keys.  Null keys map
    # to index 0.  This null case is split out into separate methods
    # for the sake of performance in the two most commonly used
    # operations (get and put), but incorporated with conditionals in
    # others.
    def get_for_null_key
      e = @table[0]
      while !(e).nil?
        if ((e.attr_key).nil?)
          return e.attr_value
        end
        e = e.attr_next
      end
      return nil
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map contains a mapping for the
    # specified key.
    # 
    # @param   key   The key whose presence in this map is to be tested
    # @return <tt>true</tt> if this map contains a mapping for the specified
    # key.
    def contains_key(key)
      return !(get_entry(key)).nil?
    end
    
    typesig { [Object] }
    # Returns the entry associated with the specified key in the
    # HashMap.  Returns null if the HashMap contains no mapping
    # for the key.
    def get_entry(key)
      hash_ = ((key).nil?) ? 0 : hash(key.hash_code)
      e = @table[index_for(hash_, @table.attr_length)]
      while !(e).nil?
        k = nil
        if ((e.attr_hash).equal?(hash_) && (((k = e.attr_key)).equal?(key) || (!(key).nil? && (key == k))))
          return e
        end
        e = e.attr_next
      end
      return nil
    end
    
    typesig { [Object, Object] }
    # Associates the specified value with the specified key in this map.
    # If the map previously contained a mapping for the key, the old
    # value is replaced.
    # 
    # @param key key with which the specified value is to be associated
    # @param value value to be associated with the specified key
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>.
    # (A <tt>null</tt> return can also indicate that the map
    # previously associated <tt>null</tt> with <tt>key</tt>.)
    def put(key, value)
      if ((key).nil?)
        return put_for_null_key(value)
      end
      hash_ = hash(key.hash_code)
      i = index_for(hash_, @table.attr_length)
      e = @table[i]
      while !(e).nil?
        k = nil
        if ((e.attr_hash).equal?(hash_) && (((k = e.attr_key)).equal?(key) || (key == k)))
          old_value = e.attr_value
          e.attr_value = value
          e.record_access(self)
          return old_value
        end
        e = e.attr_next
      end
      @mod_count += 1
      add_entry(hash_, key, value, i)
      return nil
    end
    
    typesig { [Object] }
    # Offloaded version of put for null keys
    def put_for_null_key(value)
      e = @table[0]
      while !(e).nil?
        if ((e.attr_key).nil?)
          old_value = e.attr_value
          e.attr_value = value
          e.record_access(self)
          return old_value
        end
        e = e.attr_next
      end
      @mod_count += 1
      add_entry(0, nil, value, 0)
      return nil
    end
    
    typesig { [Object, Object] }
    # This method is used instead of put by constructors and
    # pseudoconstructors (clone, readObject).  It does not resize the table,
    # check for comodification, etc.  It calls createEntry rather than
    # addEntry.
    def put_for_create(key, value)
      hash_ = ((key).nil?) ? 0 : hash(key.hash_code)
      i = index_for(hash_, @table.attr_length)
      # Look for preexisting entry for key.  This will never happen for
      # clone or deserialize.  It will only happen for construction if the
      # input Map is a sorted map whose ordering is inconsistent w/ equals.
      e = @table[i]
      while !(e).nil?
        k = nil
        if ((e.attr_hash).equal?(hash_) && (((k = e.attr_key)).equal?(key) || (!(key).nil? && (key == k))))
          e.attr_value = value
          return
        end
        e = e.attr_next
      end
      create_entry(hash_, key, value, i)
    end
    
    typesig { [Map] }
    def put_all_for_create(m)
      i = m.entry_set.iterator
      while i.has_next
        e = i.next_
        put_for_create(e.get_key, e.get_value)
      end
    end
    
    typesig { [::Java::Int] }
    # Rehashes the contents of this map into a new array with a
    # larger capacity.  This method is called automatically when the
    # number of keys in this map reaches its threshold.
    # 
    # If current capacity is MAXIMUM_CAPACITY, this method does not
    # resize the map, but sets threshold to Integer.MAX_VALUE.
    # This has the effect of preventing future calls.
    # 
    # @param newCapacity the new capacity, MUST be a power of two;
    # must be greater than current capacity unless current
    # capacity is MAXIMUM_CAPACITY (in which case value
    # is irrelevant).
    def resize(new_capacity)
      old_table = @table
      old_capacity = old_table.attr_length
      if ((old_capacity).equal?(MAXIMUM_CAPACITY))
        @threshold = JavaInteger::MAX_VALUE
        return
      end
      new_table = Array.typed(Entry).new(new_capacity) { nil }
      transfer(new_table)
      @table = new_table
      @threshold = RJava.cast_to_int((new_capacity * @load_factor))
    end
    
    typesig { [Array.typed(Entry)] }
    # Transfers all entries from current table to newTable.
    def transfer(new_table)
      src = @table
      new_capacity = new_table.attr_length
      j = 0
      while j < src.attr_length
        e = src[j]
        if (!(e).nil?)
          src[j] = nil
          begin
            next__ = e.attr_next
            i = index_for(e.attr_hash, new_capacity)
            e.attr_next = new_table[i]
            new_table[i] = e
            e = next__
          end while (!(e).nil?)
        end
        j += 1
      end
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified map to this map.
    # These mappings will replace any mappings that this map had for
    # any of the keys currently in the specified map.
    # 
    # @param m mappings to be stored in this map
    # @throws NullPointerException if the specified map is null
    def put_all(m)
      num_keys_to_be_added = m.size
      if ((num_keys_to_be_added).equal?(0))
        return
      end
      # Expand the map if the map if the number of mappings to be added
      # is greater than or equal to threshold.  This is conservative; the
      # obvious condition is (m.size() + size) >= threshold, but this
      # condition could result in a map with twice the appropriate capacity,
      # if the keys to be added overlap with the keys already in this map.
      # By using the conservative calculation, we subject ourself
      # to at most one extra resize.
      if (num_keys_to_be_added > @threshold)
        target_capacity = RJava.cast_to_int((num_keys_to_be_added / @load_factor + 1))
        if (target_capacity > MAXIMUM_CAPACITY)
          target_capacity = MAXIMUM_CAPACITY
        end
        new_capacity = @table.attr_length
        while (new_capacity < target_capacity)
          new_capacity <<= 1
        end
        if (new_capacity > @table.attr_length)
          resize(new_capacity)
        end
      end
      i = m.entry_set.iterator
      while i.has_next
        e = i.next_
        put(e.get_key, e.get_value)
      end
    end
    
    typesig { [Object] }
    # Removes the mapping for the specified key from this map if present.
    # 
    # @param  key key whose mapping is to be removed from the map
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>.
    # (A <tt>null</tt> return can also indicate that the map
    # previously associated <tt>null</tt> with <tt>key</tt>.)
    def remove(key)
      e = remove_entry_for_key(key)
      return ((e).nil? ? nil : e.attr_value)
    end
    
    typesig { [Object] }
    # Removes and returns the entry associated with the specified key
    # in the HashMap.  Returns null if the HashMap contains no mapping
    # for this key.
    def remove_entry_for_key(key)
      hash_ = ((key).nil?) ? 0 : hash(key.hash_code)
      i = index_for(hash_, @table.attr_length)
      prev = @table[i]
      e = prev
      while (!(e).nil?)
        next__ = e.attr_next
        k = nil
        if ((e.attr_hash).equal?(hash_) && (((k = e.attr_key)).equal?(key) || (!(key).nil? && (key == k))))
          @mod_count += 1
          @size -= 1
          if ((prev).equal?(e))
            @table[i] = next__
          else
            prev.attr_next = next__
          end
          e.record_removal(self)
          return e
        end
        prev = e
        e = next__
      end
      return e
    end
    
    typesig { [Object] }
    # Special version of remove for EntrySet.
    def remove_mapping(o)
      if (!(o.is_a?(Map::Entry)))
        return nil
      end
      entry = o
      key = entry.get_key
      hash_ = ((key).nil?) ? 0 : hash(key.hash_code)
      i = index_for(hash_, @table.attr_length)
      prev = @table[i]
      e = prev
      while (!(e).nil?)
        next__ = e.attr_next
        if ((e.attr_hash).equal?(hash_) && (e == entry))
          @mod_count += 1
          @size -= 1
          if ((prev).equal?(e))
            @table[i] = next__
          else
            prev.attr_next = next__
          end
          e.record_removal(self)
          return e
        end
        prev = e
        e = next__
      end
      return e
    end
    
    typesig { [] }
    # Removes all of the mappings from this map.
    # The map will be empty after this call returns.
    def clear
      @mod_count += 1
      tab = @table
      i = 0
      while i < tab.attr_length
        tab[i] = nil
        i += 1
      end
      @size = 0
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map maps one or more keys to the
    # specified value.
    # 
    # @param value value whose presence in this map is to be tested
    # @return <tt>true</tt> if this map maps one or more keys to the
    # specified value
    def contains_value(value)
      if ((value).nil?)
        return contains_null_value
      end
      tab = @table
      i = 0
      while i < tab.attr_length
        e = tab[i]
        while !(e).nil?
          if ((value == e.attr_value))
            return true
          end
          e = e.attr_next
        end
        i += 1
      end
      return false
    end
    
    typesig { [] }
    # Special-case code for containsValue with null argument
    def contains_null_value
      tab = @table
      i = 0
      while i < tab.attr_length
        e = tab[i]
        while !(e).nil?
          if ((e.attr_value).nil?)
            return true
          end
          e = e.attr_next
        end
        i += 1
      end
      return false
    end
    
    typesig { [] }
    # Returns a shallow copy of this <tt>HashMap</tt> instance: the keys and
    # values themselves are not cloned.
    # 
    # @return a shallow copy of this map
    def clone
      result = nil
      begin
        result = super
      rescue CloneNotSupportedException => e
        # assert false;
      end
      result.attr_table = Array.typed(Entry).new(@table.attr_length) { nil }
      result.attr_entry_set = nil
      result.attr_mod_count = 0
      result.attr_size = 0
      result.init
      result.put_all_for_create(self)
      return result
    end
    
    class_module.module_eval {
      const_set_lazy(:Entry) { Class.new do
        include_class_members HashMap
        include Map::Entry
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :value
        alias_method :attr_value, :value
        undef_method :value
        alias_method :attr_value=, :value=
        undef_method :value=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        attr_accessor :hash
        alias_method :attr_hash, :hash
        undef_method :hash
        alias_method :attr_hash=, :hash=
        undef_method :hash=
        
        typesig { [::Java::Int, Object, Object, self::Entry] }
        # Creates new entry.
        def initialize(h, k, v, n)
          @key = nil
          @value = nil
          @next = nil
          @hash = 0
          @value = v
          @next = n
          @key = k
          @hash = h
        end
        
        typesig { [] }
        def get_key
          return @key
        end
        
        typesig { [] }
        def get_value
          return @value
        end
        
        typesig { [Object] }
        def set_value(new_value)
          old_value = @value
          @value = new_value
          return old_value
        end
        
        typesig { [self::Object] }
        def ==(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          k1 = get_key
          k2 = e.get_key
          if ((k1).equal?(k2) || (!(k1).nil? && (k1 == k2)))
            v1 = get_value
            v2 = e.get_value
            if ((v1).equal?(v2) || (!(v1).nil? && (v1 == v2)))
              return true
            end
          end
          return false
        end
        
        typesig { [] }
        def hash_code
          return ((@key).nil? ? 0 : @key.hash_code) ^ ((@value).nil? ? 0 : @value.hash_code)
        end
        
        typesig { [] }
        def to_s
          return RJava.cast_to_string(get_key) + "=" + RJava.cast_to_string(get_value)
        end
        
        typesig { [self::HashMap] }
        # This method is invoked whenever the value in an entry is
        # overwritten by an invocation of put(k,v) for a key k that's already
        # in the HashMap.
        def record_access(m)
        end
        
        typesig { [self::HashMap] }
        # This method is invoked whenever the entry is
        # removed from the table.
        def record_removal(m)
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
    }
    
    typesig { [::Java::Int, Object, Object, ::Java::Int] }
    # Adds a new entry with the specified key, value and hash code to
    # the specified bucket.  It is the responsibility of this
    # method to resize the table if appropriate.
    # 
    # Subclass overrides this to alter the behavior of put method.
    def add_entry(hash_, key, value, bucket_index)
      e = @table[bucket_index]
      @table[bucket_index] = Entry.new(hash_, key, value, e)
      if (((@size += 1) - 1) >= @threshold)
        resize(2 * @table.attr_length)
      end
    end
    
    typesig { [::Java::Int, Object, Object, ::Java::Int] }
    # Like addEntry except that this version is used when creating entries
    # as part of Map construction or "pseudo-construction" (cloning,
    # deserialization).  This version needn't worry about resizing the table.
    # 
    # Subclass overrides this to alter the behavior of HashMap(Map),
    # clone, and readObject.
    def create_entry(hash_, key, value, bucket_index)
      e = @table[bucket_index]
      @table[bucket_index] = Entry.new(hash_, key, value, e)
      @size += 1
    end
    
    class_module.module_eval {
      const_set_lazy(:HashIterator) { Class.new do
        extend LocalClass
        include_class_members HashMap
        include Iterator
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        # next entry to return
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        # For fast-fail
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        # current slot
        attr_accessor :current
        alias_method :attr_current, :current
        undef_method :current
        alias_method :attr_current=, :current=
        undef_method :current=
        
        typesig { [] }
        # current entry
        def initialize
          @next = nil
          @expected_mod_count = 0
          @index = 0
          @current = nil
          @expected_mod_count = self.attr_mod_count
          if (self.attr_size > 0)
            # advance to first entry
            t = self.attr_table
            while (@index < t.attr_length && ((@next = t[((@index += 1) - 1)])).nil?)
            end
          end
        end
        
        typesig { [] }
        def has_next
          return !(@next).nil?
        end
        
        typesig { [] }
        def next_entry
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise self.class::ConcurrentModificationException.new
          end
          e = @next
          if ((e).nil?)
            raise self.class::NoSuchElementException.new
          end
          if (((@next = e.attr_next)).nil?)
            t = self.attr_table
            while (@index < t.attr_length && ((@next = t[((@index += 1) - 1)])).nil?)
            end
          end
          @current = e
          return e
        end
        
        typesig { [] }
        def remove
          if ((@current).nil?)
            raise self.class::IllegalStateException.new
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise self.class::ConcurrentModificationException.new
          end
          k = @current.attr_key
          @current = nil
          @local_class_parent.remove_entry_for_key(k)
          @expected_mod_count = self.attr_mod_count
        end
        
        private
        alias_method :initialize__hash_iterator, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members HashMap
        
        typesig { [] }
        def next_
          return next_entry.attr_value
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__value_iterator, :initialize
      end }
      
      const_set_lazy(:KeyIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members HashMap
        
        typesig { [] }
        def next_
          return next_entry.get_key
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__key_iterator, :initialize
      end }
      
      const_set_lazy(:EntryIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members HashMap
        
        typesig { [] }
        def next_
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
    # Subclass overrides these to alter behavior of views' iterator() method
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
    
    # Views
    attr_accessor :entry_set
    alias_method :attr_entry_set, :entry_set
    undef_method :entry_set
    alias_method :attr_entry_set=, :entry_set=
    undef_method :entry_set=
    
    typesig { [] }
    # Returns a {@link Set} view of the keys contained in this map.
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  If the map is modified
    # while an iteration over the set is in progress (except through
    # the iterator's own <tt>remove</tt> operation), the results of
    # the iteration are undefined.  The set supports element removal,
    # which removes the corresponding mapping from the map, via the
    # <tt>Iterator.remove</tt>, <tt>Set.remove</tt>,
    # <tt>removeAll</tt>, <tt>retainAll</tt>, and <tt>clear</tt>
    # operations.  It does not support the <tt>add</tt> or <tt>addAll</tt>
    # operations.
    def key_set
      ks = self.attr_key_set
      return (!(ks).nil? ? ks : (self.attr_key_set = KeySet.new_local(self)))
    end
    
    class_module.module_eval {
      const_set_lazy(:KeySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members HashMap
        
        typesig { [] }
        def iterator
          return new_key_iterator
        end
        
        typesig { [] }
        def size
          return self.attr_size
        end
        
        typesig { [self::Object] }
        def contains(o)
          return contains_key(o)
        end
        
        typesig { [self::Object] }
        def remove(o)
          return !(@local_class_parent.remove_entry_for_key(o)).nil?
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
        alias_method :initialize__key_set, :initialize
      end }
    }
    
    typesig { [] }
    # Returns a {@link Collection} view of the values contained in this map.
    # The collection is backed by the map, so changes to the map are
    # reflected in the collection, and vice-versa.  If the map is
    # modified while an iteration over the collection is in progress
    # (except through the iterator's own <tt>remove</tt> operation),
    # the results of the iteration are undefined.  The collection
    # supports element removal, which removes the corresponding
    # mapping from the map, via the <tt>Iterator.remove</tt>,
    # <tt>Collection.remove</tt>, <tt>removeAll</tt>,
    # <tt>retainAll</tt> and <tt>clear</tt> operations.  It does not
    # support the <tt>add</tt> or <tt>addAll</tt> operations.
    def values
      vs = self.attr_values
      return (!(vs).nil? ? vs : (self.attr_values = Values.new_local(self)))
    end
    
    class_module.module_eval {
      const_set_lazy(:Values) { Class.new(AbstractCollection) do
        extend LocalClass
        include_class_members HashMap
        
        typesig { [] }
        def iterator
          return new_value_iterator
        end
        
        typesig { [] }
        def size
          return self.attr_size
        end
        
        typesig { [self::Object] }
        def contains(o)
          return contains_value(o)
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
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  If the map is modified
    # while an iteration over the set is in progress (except through
    # the iterator's own <tt>remove</tt> operation, or through the
    # <tt>setValue</tt> operation on a map entry returned by the
    # iterator) the results of the iteration are undefined.  The set
    # supports element removal, which removes the corresponding
    # mapping from the map, via the <tt>Iterator.remove</tt>,
    # <tt>Set.remove</tt>, <tt>removeAll</tt>, <tt>retainAll</tt> and
    # <tt>clear</tt> operations.  It does not support the
    # <tt>add</tt> or <tt>addAll</tt> operations.
    # 
    # @return a set view of the mappings contained in this map
    def entry_set
      return entry_set0
    end
    
    typesig { [] }
    def entry_set0
      es = @entry_set
      return !(es).nil? ? es : (@entry_set = EntrySet.new_local(self))
    end
    
    class_module.module_eval {
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members HashMap
        
        typesig { [] }
        def iterator
          return new_entry_iterator
        end
        
        typesig { [self::Object] }
        def contains(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          candidate = get_entry(e.get_key)
          return !(candidate).nil? && (candidate == e)
        end
        
        typesig { [self::Object] }
        def remove(o)
          return !(remove_mapping(o)).nil?
        end
        
        typesig { [] }
        def size
          return self.attr_size
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
        alias_method :initialize__entry_set, :initialize
      end }
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the <tt>HashMap</tt> instance to a stream (i.e.,
    # serialize it).
    # 
    # @serialData The <i>capacity</i> of the HashMap (the length of the
    # bucket array) is emitted (int), followed by the
    # <i>size</i> (an int, the number of key-value
    # mappings), followed by the key (Object) and value (Object)
    # for each key-value mapping.  The key-value mappings are
    # emitted in no particular order.
    def write_object(s)
      i = (@size > 0) ? entry_set0.iterator : nil
      # Write out the threshold, loadfactor, and any hidden stuff
      s.default_write_object
      # Write out number of buckets
      s.write_int(@table.attr_length)
      # Write out size (number of Mappings)
      s.write_int(@size)
      # Write out keys and values (alternating)
      if (!(i).nil?)
        while (i.has_next)
          e = i.next_
          s.write_object(e.get_key)
          s.write_object(e.get_value)
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 362498820763181265 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the <tt>HashMap</tt> instance from a stream (i.e.,
    # deserialize it).
    def read_object(s)
      # Read in the threshold, loadfactor, and any hidden stuff
      s.default_read_object
      # Read in number of buckets and allocate the bucket array;
      num_buckets = s.read_int
      @table = Array.typed(Entry).new(num_buckets) { nil }
      init # Give subclass a chance to do its thing.
      # Read in size (number of Mappings)
      size_ = s.read_int
      # Read the keys and values, and put the mappings in the HashMap
      i = 0
      while i < size_
        key = s.read_object
        value = s.read_object
        put_for_create(key, value)
        i += 1
      end
    end
    
    typesig { [] }
    # These methods are used when serializing HashSets
    def capacity
      return @table.attr_length
    end
    
    typesig { [] }
    def load_factor
      return @load_factor
    end
    
    private
    alias_method :initialize__hash_map, :initialize
  end
  
end
