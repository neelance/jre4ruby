require "rjava"

# Copyright 1998-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module WeakHashMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Lang::Ref, :WeakReference
      include_const ::Java::Lang::Ref, :ReferenceQueue
    }
  end
  
  # A hashtable-based <tt>Map</tt> implementation with <em>weak keys</em>.
  # An entry in a <tt>WeakHashMap</tt> will automatically be removed when
  # its key is no longer in ordinary use.  More precisely, the presence of a
  # mapping for a given key will not prevent the key from being discarded by the
  # garbage collector, that is, made finalizable, finalized, and then reclaimed.
  # When a key has been discarded its entry is effectively removed from the map,
  # so this class behaves somewhat differently from other <tt>Map</tt>
  # implementations.
  # 
  # <p> Both null values and the null key are supported. This class has
  # performance characteristics similar to those of the <tt>HashMap</tt>
  # class, and has the same efficiency parameters of <em>initial capacity</em>
  # and <em>load factor</em>.
  # 
  # <p> Like most collection classes, this class is not synchronized.
  # A synchronized <tt>WeakHashMap</tt> may be constructed using the
  # {@link Collections#synchronizedMap Collections.synchronizedMap}
  # method.
  # 
  # <p> This class is intended primarily for use with key objects whose
  # <tt>equals</tt> methods test for object identity using the
  # <tt>==</tt> operator.  Once such a key is discarded it can never be
  # recreated, so it is impossible to do a lookup of that key in a
  # <tt>WeakHashMap</tt> at some later time and be surprised that its entry
  # has been removed.  This class will work perfectly well with key objects
  # whose <tt>equals</tt> methods are not based upon object identity, such
  # as <tt>String</tt> instances.  With such recreatable key objects,
  # however, the automatic removal of <tt>WeakHashMap</tt> entries whose
  # keys have been discarded may prove to be confusing.
  # 
  # <p> The behavior of the <tt>WeakHashMap</tt> class depends in part upon
  # the actions of the garbage collector, so several familiar (though not
  # required) <tt>Map</tt> invariants do not hold for this class.  Because
  # the garbage collector may discard keys at any time, a
  # <tt>WeakHashMap</tt> may behave as though an unknown thread is silently
  # removing entries.  In particular, even if you synchronize on a
  # <tt>WeakHashMap</tt> instance and invoke none of its mutator methods, it
  # is possible for the <tt>size</tt> method to return smaller values over
  # time, for the <tt>isEmpty</tt> method to return <tt>false</tt> and
  # then <tt>true</tt>, for the <tt>containsKey</tt> method to return
  # <tt>true</tt> and later <tt>false</tt> for a given key, for the
  # <tt>get</tt> method to return a value for a given key but later return
  # <tt>null</tt>, for the <tt>put</tt> method to return
  # <tt>null</tt> and the <tt>remove</tt> method to return
  # <tt>false</tt> for a key that previously appeared to be in the map, and
  # for successive examinations of the key set, the value collection, and
  # the entry set to yield successively smaller numbers of elements.
  # 
  # <p> Each key object in a <tt>WeakHashMap</tt> is stored indirectly as
  # the referent of a weak reference.  Therefore a key will automatically be
  # removed only after the weak references to it, both inside and outside of the
  # map, have been cleared by the garbage collector.
  # 
  # <p> <strong>Implementation note:</strong> The value objects in a
  # <tt>WeakHashMap</tt> are held by ordinary strong references.  Thus care
  # should be taken to ensure that value objects do not strongly refer to their
  # own keys, either directly or indirectly, since that will prevent the keys
  # from being discarded.  Note that a value object may refer indirectly to its
  # key via the <tt>WeakHashMap</tt> itself; that is, a value object may
  # strongly refer to some other key object whose associated value object, in
  # turn, strongly refers to the key of the first value object.  One way
  # to deal with this is to wrap values themselves within
  # <tt>WeakReferences</tt> before
  # inserting, as in: <tt>m.put(key, new WeakReference(value))</tt>,
  # and then unwrapping upon each <tt>get</tt>.
  # 
  # <p>The iterators returned by the <tt>iterator</tt> method of the collections
  # returned by all of this class's "collection view methods" are
  # <i>fail-fast</i>: if the map is structurally modified at any time after the
  # iterator is created, in any way except through the iterator's own
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
  # exception for its correctness:  <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # 
  # @author      Doug Lea
  # @author      Josh Bloch
  # @author      Mark Reinhold
  # @since       1.2
  # @see         java.util.HashMap
  # @see         java.lang.ref.WeakReference
  class WeakHashMap < WeakHashMapImports.const_get :AbstractMap
    include_class_members WeakHashMapImports
    include Map
    
    class_module.module_eval {
      # The default initial capacity -- MUST be a power of two.
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
    
    # The number of key-value mappings contained in this weak hash map.
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    # The next size value at which to resize (capacity * load factor).
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    # The load factor for the hash table.
    attr_accessor :load_factor
    alias_method :attr_load_factor, :load_factor
    undef_method :load_factor
    alias_method :attr_load_factor=, :load_factor=
    undef_method :load_factor=
    
    # Reference queue for cleared WeakEntries
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    # The number of times this WeakHashMap has been structurally modified.
    # Structural modifications are those that change the number of
    # mappings in the map or otherwise modify its internal structure
    # (e.g., rehash).  This field is used to make iterators on
    # Collection-views of the map fail-fast.
    # 
    # @see ConcurrentModificationException
    attr_accessor :mod_count
    alias_method :attr_mod_count, :mod_count
    undef_method :mod_count
    alias_method :attr_mod_count=, :mod_count=
    undef_method :mod_count=
    
    typesig { [::Java::Int] }
    def new_table(n)
      return Array.typed(Entry).new(n) { nil }
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # Constructs a new, empty <tt>WeakHashMap</tt> with the given initial
    # capacity and the given load factor.
    # 
    # @param  initialCapacity The initial capacity of the <tt>WeakHashMap</tt>
    # @param  loadFactor      The load factor of the <tt>WeakHashMap</tt>
    # @throws IllegalArgumentException if the initial capacity is negative,
    # or if the load factor is nonpositive.
    def initialize(initial_capacity, load_factor)
      @table = nil
      @size = 0
      @threshold = 0
      @load_factor = 0.0
      @queue = nil
      @mod_count = 0
      @entry_set = nil
      super()
      @queue = ReferenceQueue.new
      @entry_set = nil
      if (initial_capacity < 0)
        raise IllegalArgumentException.new("Illegal Initial Capacity: " + (initial_capacity).to_s)
      end
      if (initial_capacity > MAXIMUM_CAPACITY)
        initial_capacity = MAXIMUM_CAPACITY
      end
      if (load_factor <= 0 || Float.is_na_n(load_factor))
        raise IllegalArgumentException.new("Illegal Load factor: " + (load_factor).to_s)
      end
      capacity = 1
      while (capacity < initial_capacity)
        capacity <<= 1
      end
      @table = new_table(capacity)
      @load_factor = load_factor
      @threshold = RJava.cast_to_int((capacity * load_factor))
    end
    
    typesig { [::Java::Int] }
    # Constructs a new, empty <tt>WeakHashMap</tt> with the given initial
    # capacity and the default load factor (0.75).
    # 
    # @param  initialCapacity The initial capacity of the <tt>WeakHashMap</tt>
    # @throws IllegalArgumentException if the initial capacity is negative
    def initialize(initial_capacity)
      initialize__weak_hash_map(initial_capacity, DEFAULT_LOAD_FACTOR)
    end
    
    typesig { [] }
    # Constructs a new, empty <tt>WeakHashMap</tt> with the default initial
    # capacity (16) and load factor (0.75).
    def initialize
      @table = nil
      @size = 0
      @threshold = 0
      @load_factor = 0.0
      @queue = nil
      @mod_count = 0
      @entry_set = nil
      super()
      @queue = ReferenceQueue.new
      @entry_set = nil
      @load_factor = DEFAULT_LOAD_FACTOR
      @threshold = DEFAULT_INITIAL_CAPACITY
      @table = new_table(DEFAULT_INITIAL_CAPACITY)
    end
    
    typesig { [Map] }
    # Constructs a new <tt>WeakHashMap</tt> with the same mappings as the
    # specified map.  The <tt>WeakHashMap</tt> is created with the default
    # load factor (0.75) and an initial capacity sufficient to hold the
    # mappings in the specified map.
    # 
    # @param   m the map whose mappings are to be placed in this map
    # @throws  NullPointerException if the specified map is null
    # @since   1.3
    def initialize(m)
      initialize__weak_hash_map(Math.max(RJava.cast_to_int((m.size / DEFAULT_LOAD_FACTOR)) + 1, 16), DEFAULT_LOAD_FACTOR)
      put_all(m)
    end
    
    class_module.module_eval {
      # internal utilities
      # 
      # Value representing null keys inside tables.
      const_set_lazy(:NULL_KEY) { Object.new }
      const_attr_reader  :NULL_KEY
      
      typesig { [Object] }
      # Use NULL_KEY for key if it is null.
      def mask_null(key)
        return ((key).nil?) ? NULL_KEY : key
      end
      
      typesig { [Object] }
      # Returns internal representation of null key back to caller as null.
      def unmask_null(key)
        return ((key).equal?(NULL_KEY)) ? nil : key
      end
      
      typesig { [Object, Object] }
      # Checks for equality of non-null reference x and possibly-null y.  By
      # default uses Object.equals.
      def eq(x, y)
        return (x).equal?(y) || (x == y)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns index for hash code h.
      def index_for(h, length)
        return h & (length - 1)
      end
    }
    
    typesig { [] }
    # Expunges stale entries from the table.
    def expunge_stale_entries
      x = nil
      while !((x = @queue.poll)).nil?
        synchronized((@queue)) do
          e = x
          i = index_for(e.attr_hash, @table.attr_length)
          prev = @table[i]
          p = prev
          while (!(p).nil?)
            next_ = p.attr_next
            if ((p).equal?(e))
              if ((prev).equal?(e))
                @table[i] = next_
              else
                prev.attr_next = next_
              end
              # Must not null out e.next;
              # stale entries may be in use by a HashIterator
              e.attr_value = nil # Help GC
              @size -= 1
              break
            end
            prev = p
            p = next_
          end
        end
      end
    end
    
    typesig { [] }
    # Returns the table after first expunging stale entries.
    def get_table
      expunge_stale_entries
      return @table
    end
    
    typesig { [] }
    # Returns the number of key-value mappings in this map.
    # This result is a snapshot, and may not reflect unprocessed
    # entries that will be removed before next attempted access
    # because they are no longer referenced.
    def size
      if ((@size).equal?(0))
        return 0
      end
      expunge_stale_entries
      return @size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this map contains no key-value mappings.
    # This result is a snapshot, and may not reflect unprocessed
    # entries that will be removed before next attempted access
    # because they are no longer referenced.
    def is_empty
      return (size).equal?(0)
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
      k = mask_null(key)
      h = HashMap.hash(k.hash_code)
      tab = get_table
      index = index_for(h, tab.attr_length)
      e = tab[index]
      while (!(e).nil?)
        if ((e.attr_hash).equal?(h) && eq(k, e.get))
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
    # @param  key   The key whose presence in this map is to be tested
    # @return <tt>true</tt> if there is a mapping for <tt>key</tt>;
    # <tt>false</tt> otherwise
    def contains_key(key)
      return !(get_entry(key)).nil?
    end
    
    typesig { [Object] }
    # Returns the entry associated with the specified key in this map.
    # Returns null if the map contains no mapping for this key.
    def get_entry(key)
      k = mask_null(key)
      h = HashMap.hash(k.hash_code)
      tab = get_table
      index = index_for(h, tab.attr_length)
      e = tab[index]
      while (!(e).nil? && !((e.attr_hash).equal?(h) && eq(k, e.get)))
        e = e.attr_next
      end
      return e
    end
    
    typesig { [Object, Object] }
    # Associates the specified value with the specified key in this map.
    # If the map previously contained a mapping for this key, the old
    # value is replaced.
    # 
    # @param key key with which the specified value is to be associated.
    # @param value value to be associated with the specified key.
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>.
    # (A <tt>null</tt> return can also indicate that the map
    # previously associated <tt>null</tt> with <tt>key</tt>.)
    def put(key, value)
      k = mask_null(key)
      h = HashMap.hash(k.hash_code)
      tab = get_table
      i = index_for(h, tab.attr_length)
      e = tab[i]
      while !(e).nil?
        if ((h).equal?(e.attr_hash) && eq(k, e.get))
          old_value = e.attr_value
          if (!(value).equal?(old_value))
            e.attr_value = value
          end
          return old_value
        end
        e = e.attr_next
      end
      @mod_count += 1
      e_ = tab[i]
      tab[i] = Entry.new(k, value, @queue, h, e_)
      if ((@size += 1) >= @threshold)
        resize(tab.attr_length * 2)
      end
      return nil
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
      old_table = get_table
      old_capacity = old_table.attr_length
      if ((old_capacity).equal?(MAXIMUM_CAPACITY))
        @threshold = JavaInteger::MAX_VALUE
        return
      end
      new_table_ = new_table(new_capacity)
      transfer(old_table, new_table_)
      @table = new_table_
      # If ignoring null elements and processing ref queue caused massive
      # shrinkage, then restore old table.  This should be rare, but avoids
      # unbounded expansion of garbage-filled tables.
      if (@size >= @threshold / 2)
        @threshold = RJava.cast_to_int((new_capacity * @load_factor))
      else
        expunge_stale_entries
        transfer(new_table_, old_table)
        @table = old_table
      end
    end
    
    typesig { [Array.typed(Entry), Array.typed(Entry)] }
    # Transfers all entries from src to dest tables
    def transfer(src, dest)
      j = 0
      while j < src.attr_length
        e = src[j]
        src[j] = nil
        while (!(e).nil?)
          next_ = e.attr_next
          key = e.get
          if ((key).nil?)
            e.attr_next = nil # Help GC
            e.attr_value = nil # "   "
            @size -= 1
          else
            i = index_for(e.attr_hash, dest.attr_length)
            e.attr_next = dest[i]
            dest[i] = e
          end
          e = next_
        end
        (j += 1)
      end
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified map to this map.
    # These mappings will replace any mappings that this map had for any
    # of the keys currently in the specified map.
    # 
    # @param m mappings to be stored in this map.
    # @throws  NullPointerException if the specified map is null.
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
      m.entry_set.each do |e|
        put(e.get_key, e.get_value)
      end
    end
    
    typesig { [Object] }
    # Removes the mapping for a key from this weak hash map if it is present.
    # More formally, if this map contains a mapping from key <tt>k</tt> to
    # value <tt>v</tt> such that <code>(key==null ?  k==null :
    # key.equals(k))</code>, that mapping is removed.  (The map can contain
    # at most one such mapping.)
    # 
    # <p>Returns the value to which this map previously associated the key,
    # or <tt>null</tt> if the map contained no mapping for the key.  A
    # return value of <tt>null</tt> does not <i>necessarily</i> indicate
    # that the map contained no mapping for the key; it's also possible
    # that the map explicitly mapped the key to <tt>null</tt>.
    # 
    # <p>The map will not contain a mapping for the specified key once the
    # call returns.
    # 
    # @param key key whose mapping is to be removed from the map
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>
    def remove(key)
      k = mask_null(key)
      h = HashMap.hash(k.hash_code)
      tab = get_table
      i = index_for(h, tab.attr_length)
      prev = tab[i]
      e = prev
      while (!(e).nil?)
        next_ = e.attr_next
        if ((h).equal?(e.attr_hash) && eq(k, e.get))
          @mod_count += 1
          @size -= 1
          if ((prev).equal?(e))
            tab[i] = next_
          else
            prev.attr_next = next_
          end
          return e.attr_value
        end
        prev = e
        e = next_
      end
      return nil
    end
    
    typesig { [Object] }
    # Special version of remove needed by Entry set
    def remove_mapping(o)
      if (!(o.is_a?(Map::Entry)))
        return false
      end
      tab = get_table
      entry = o
      k = mask_null(entry.get_key)
      h = HashMap.hash(k.hash_code)
      i = index_for(h, tab.attr_length)
      prev = tab[i]
      e = prev
      while (!(e).nil?)
        next_ = e.attr_next
        if ((h).equal?(e.attr_hash) && (e == entry))
          @mod_count += 1
          @size -= 1
          if ((prev).equal?(e))
            tab[i] = next_
          else
            prev.attr_next = next_
          end
          return true
        end
        prev = e
        e = next_
      end
      return false
    end
    
    typesig { [] }
    # Removes all of the mappings from this map.
    # The map will be empty after this call returns.
    def clear
      # clear out ref queue. We don't need to expunge entries
      # since table is getting cleared.
      while (!(@queue.poll).nil?)
      end
      @mod_count += 1
      Arrays.fill(@table, nil)
      @size = 0
      # Allocation of array may have caused GC, which may have caused
      # additional entries to go stale.  Removing these entries from the
      # reference queue will make them eligible for reclamation.
      while (!(@queue.poll).nil?)
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
      if ((value).nil?)
        return contains_null_value
      end
      tab = get_table
      i = tab.attr_length
      while ((i -= 1) + 1) > 0
        e = tab[i]
        while !(e).nil?
          if ((value == e.attr_value))
            return true
          end
          e = e.attr_next
        end
      end
      return false
    end
    
    typesig { [] }
    # Special-case code for containsValue with null argument
    def contains_null_value
      tab = get_table
      i = tab.attr_length
      while ((i -= 1) + 1) > 0
        e = tab[i]
        while !(e).nil?
          if ((e.attr_value).nil?)
            return true
          end
          e = e.attr_next
        end
      end
      return false
    end
    
    class_module.module_eval {
      # The entries in this hash table extend WeakReference, using its main ref
      # field as the key.
      const_set_lazy(:Entry) { Class.new(WeakReference) do
        include_class_members WeakHashMap
        include Map::Entry
        
        attr_accessor :value
        alias_method :attr_value, :value
        undef_method :value
        alias_method :attr_value=, :value=
        undef_method :value=
        
        attr_accessor :hash
        alias_method :attr_hash, :hash
        undef_method :hash
        alias_method :attr_hash=, :hash=
        undef_method :hash=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        typesig { [Object, Object, ReferenceQueue, ::Java::Int, Entry] }
        # Creates new entry.
        def initialize(key, value, queue, hash, next_)
          @value = nil
          @hash = 0
          @next = nil
          super(key, queue)
          @value = value
          @hash = hash
          @next = next_
        end
        
        typesig { [] }
        def get_key
          return WeakHashMap.unmask_null(get)
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
        
        typesig { [Object] }
        def equals(o)
          if (!(o.is_a?(Map::Entry)))
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
          k = get_key
          v = get_value
          return (((k).nil? ? 0 : k.hash_code) ^ ((v).nil? ? 0 : v.hash_code))
        end
        
        typesig { [] }
        def to_s
          return (get_key).to_s + "=" + (get_value).to_s
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
      
      const_set_lazy(:HashIterator) { Class.new do
        extend LocalClass
        include_class_members WeakHashMap
        include Iterator
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :entry
        alias_method :attr_entry, :entry
        undef_method :entry
        alias_method :attr_entry=, :entry=
        undef_method :entry=
        
        attr_accessor :last_returned
        alias_method :attr_last_returned, :last_returned
        undef_method :last_returned
        alias_method :attr_last_returned=, :last_returned=
        undef_method :last_returned=
        
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        # Strong reference needed to avoid disappearance of key
        # between hasNext and next
        attr_accessor :next_key
        alias_method :attr_next_key, :next_key
        undef_method :next_key
        alias_method :attr_next_key=, :next_key=
        undef_method :next_key=
        
        # Strong reference needed to avoid disappearance of key
        # between nextEntry() and any use of the entry
        attr_accessor :current_key
        alias_method :attr_current_key, :current_key
        undef_method :current_key
        alias_method :attr_current_key=, :current_key=
        undef_method :current_key=
        
        typesig { [] }
        def initialize
          @index = 0
          @entry = nil
          @last_returned = nil
          @expected_mod_count = self.attr_mod_count
          @next_key = nil
          @current_key = nil
          @index = is_empty ? 0 : self.attr_table.attr_length
        end
        
        typesig { [] }
        def has_next
          t = self.attr_table
          while ((@next_key).nil?)
            e = @entry
            i = @index
            while ((e).nil? && i > 0)
              e = t[(i -= 1)]
            end
            @entry = e
            @index = i
            if ((e).nil?)
              @current_key = nil
              return false
            end
            @next_key = e.get # hold on to key in strong ref
            if ((@next_key).nil?)
              @entry = @entry.attr_next
            end
          end
          return true
        end
        
        typesig { [] }
        # The common parts of next() across different types of iterators
        def next_entry
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          if ((@next_key).nil? && !has_next)
            raise NoSuchElementException.new
          end
          @last_returned = @entry
          @entry = @entry.attr_next
          @current_key = @next_key
          @next_key = nil
          return @last_returned
        end
        
        typesig { [] }
        def remove
          if ((@last_returned).nil?)
            raise IllegalStateException.new
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          @local_class_parent.remove(@current_key)
          @expected_mod_count = self.attr_mod_count
          @last_returned = nil
          @current_key = nil
        end
        
        private
        alias_method :initialize__hash_iterator, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members WeakHashMap
        
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
      
      const_set_lazy(:KeyIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members WeakHashMap
        
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
      
      const_set_lazy(:EntryIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members WeakHashMap
        
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
        include_class_members WeakHashMap
        
        typesig { [] }
        def iterator
          return KeyIterator.new
        end
        
        typesig { [] }
        def size
          return @local_class_parent.size
        end
        
        typesig { [Object] }
        def contains(o)
          return contains_key(o)
        end
        
        typesig { [Object] }
        def remove(o)
          if (contains_key(o))
            @local_class_parent.remove(o)
            return true
          else
            return false
          end
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
      return (!(vs).nil?) ? vs : (self.attr_values = Values.new_local(self))
    end
    
    class_module.module_eval {
      const_set_lazy(:Values) { Class.new(AbstractCollection) do
        extend LocalClass
        include_class_members WeakHashMap
        
        typesig { [] }
        def iterator
          return ValueIterator.new
        end
        
        typesig { [] }
        def size
          return @local_class_parent.size
        end
        
        typesig { [Object] }
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
    def entry_set
      es = @entry_set
      return !(es).nil? ? es : (@entry_set = EntrySet.new_local(self))
    end
    
    class_module.module_eval {
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members WeakHashMap
        
        typesig { [] }
        def iterator
          return EntryIterator.new
        end
        
        typesig { [Object] }
        def contains(o)
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          e = o
          candidate = get_entry(e.get_key)
          return !(candidate).nil? && (candidate == e)
        end
        
        typesig { [Object] }
        def remove(o)
          return remove_mapping(o)
        end
        
        typesig { [] }
        def size
          return @local_class_parent.size
        end
        
        typesig { [] }
        def clear
          @local_class_parent.clear
        end
        
        typesig { [] }
        def deep_copy
          list = ArrayList.new(size)
          self.each do |e|
            list.add(AbstractMap::SimpleEntry.new(e))
          end
          return list
        end
        
        typesig { [] }
        def to_array
          return deep_copy.to_array
        end
        
        typesig { [Array.typed(T)] }
        def to_array(a)
          return deep_copy.to_array(a)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_set, :initialize
      end }
    }
    
    private
    alias_method :initialize__weak_hash_map, :initialize
  end
  
end
