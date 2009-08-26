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
  module ConcurrentHashMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util
      include_const ::Java::Io, :Serializable
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :ObjectOutputStream
    }
  end
  
  # A hash table supporting full concurrency of retrievals and
  # adjustable expected concurrency for updates. This class obeys the
  # same functional specification as {@link java.util.Hashtable}, and
  # includes versions of methods corresponding to each method of
  # <tt>Hashtable</tt>. However, even though all operations are
  # thread-safe, retrieval operations do <em>not</em> entail locking,
  # and there is <em>not</em> any support for locking the entire table
  # in a way that prevents all access.  This class is fully
  # interoperable with <tt>Hashtable</tt> in programs that rely on its
  # thread safety but not on its synchronization details.
  # 
  # <p> Retrieval operations (including <tt>get</tt>) generally do not
  # block, so may overlap with update operations (including
  # <tt>put</tt> and <tt>remove</tt>). Retrievals reflect the results
  # of the most recently <em>completed</em> update operations holding
  # upon their onset.  For aggregate operations such as <tt>putAll</tt>
  # and <tt>clear</tt>, concurrent retrievals may reflect insertion or
  # removal of only some entries.  Similarly, Iterators and
  # Enumerations return elements reflecting the state of the hash table
  # at some point at or since the creation of the iterator/enumeration.
  # They do <em>not</em> throw {@link ConcurrentModificationException}.
  # However, iterators are designed to be used by only one thread at a time.
  # 
  # <p> The allowed concurrency among update operations is guided by
  # the optional <tt>concurrencyLevel</tt> constructor argument
  # (default <tt>16</tt>), which is used as a hint for internal sizing.  The
  # table is internally partitioned to try to permit the indicated
  # number of concurrent updates without contention. Because placement
  # in hash tables is essentially random, the actual concurrency will
  # vary.  Ideally, you should choose a value to accommodate as many
  # threads as will ever concurrently modify the table. Using a
  # significantly higher value than you need can waste space and time,
  # and a significantly lower value can lead to thread contention. But
  # overestimates and underestimates within an order of magnitude do
  # not usually have much noticeable impact. A value of one is
  # appropriate when it is known that only one thread will modify and
  # all others will only read. Also, resizing this or any other kind of
  # hash table is a relatively slow operation, so, when possible, it is
  # a good idea to provide estimates of expected table sizes in
  # constructors.
  # 
  # <p>This class and its views and iterators implement all of the
  # <em>optional</em> methods of the {@link Map} and {@link Iterator}
  # interfaces.
  # 
  # <p> Like {@link Hashtable} but unlike {@link HashMap}, this class
  # does <em>not</em> allow <tt>null</tt> to be used as a key or value.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  class ConcurrentHashMap < ConcurrentHashMapImports.const_get :AbstractMap
    include_class_members ConcurrentHashMapImports
    overload_protected {
      include ConcurrentMap
      include Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7249069246763182397 }
      const_attr_reader  :SerialVersionUID
      
      # The basic strategy is to subdivide the table among Segments,
      # each of which itself is a concurrently readable hash table.
      # 
      # ---------------- Constants --------------
      # 
      # The default initial capacity for this table,
      # used when not otherwise specified in a constructor.
      const_set_lazy(:DEFAULT_INITIAL_CAPACITY) { 16 }
      const_attr_reader  :DEFAULT_INITIAL_CAPACITY
      
      # The default load factor for this table, used when not
      # otherwise specified in a constructor.
      const_set_lazy(:DEFAULT_LOAD_FACTOR) { 0.75 }
      const_attr_reader  :DEFAULT_LOAD_FACTOR
      
      # The default concurrency level for this table, used when not
      # otherwise specified in a constructor.
      const_set_lazy(:DEFAULT_CONCURRENCY_LEVEL) { 16 }
      const_attr_reader  :DEFAULT_CONCURRENCY_LEVEL
      
      # The maximum capacity, used if a higher value is implicitly
      # specified by either of the constructors with arguments.  MUST
      # be a power of two <= 1<<30 to ensure that entries are indexable
      # using ints.
      const_set_lazy(:MAXIMUM_CAPACITY) { 1 << 30 }
      const_attr_reader  :MAXIMUM_CAPACITY
      
      # The maximum number of segments to allow; used to bound
      # constructor arguments.
      const_set_lazy(:MAX_SEGMENTS) { 1 << 16 }
      const_attr_reader  :MAX_SEGMENTS
      
      # slightly conservative
      # 
      # Number of unsynchronized retries in size and containsValue
      # methods before resorting to locking. This is used to avoid
      # unbounded retries if tables undergo continuous modification
      # which would make it impossible to obtain an accurate result.
      const_set_lazy(:RETRIES_BEFORE_LOCK) { 2 }
      const_attr_reader  :RETRIES_BEFORE_LOCK
    }
    
    # ---------------- Fields --------------
    # 
    # Mask value for indexing into segments. The upper bits of a
    # key's hash code are used to choose the segment.
    attr_accessor :segment_mask
    alias_method :attr_segment_mask, :segment_mask
    undef_method :segment_mask
    alias_method :attr_segment_mask=, :segment_mask=
    undef_method :segment_mask=
    
    # Shift value for indexing within segments.
    attr_accessor :segment_shift
    alias_method :attr_segment_shift, :segment_shift
    undef_method :segment_shift
    alias_method :attr_segment_shift=, :segment_shift=
    undef_method :segment_shift=
    
    # The segments, each of which is a specialized hash table
    attr_accessor :segments
    alias_method :attr_segments, :segments
    undef_method :segments
    alias_method :attr_segments=, :segments=
    undef_method :segments=
    
    attr_accessor :key_set
    alias_method :attr_key_set, :key_set
    undef_method :key_set
    alias_method :attr_key_set=, :key_set=
    undef_method :key_set=
    
    attr_accessor :entry_set
    alias_method :attr_entry_set, :entry_set
    undef_method :entry_set
    alias_method :attr_entry_set=, :entry_set=
    undef_method :entry_set=
    
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # ---------------- Small Utilities --------------
      # 
      # Applies a supplemental hash function to a given hashCode, which
      # defends against poor quality hash functions.  This is critical
      # because ConcurrentHashMap uses power-of-two length hash tables,
      # that otherwise encounter collisions for hashCodes that do not
      # differ in lower or upper bits.
      def hash(h)
        # Spread bits to regularize both segment and index locations,
        # using variant of single-word Wang/Jenkins hash.
        h += (h << 15) ^ -0x3283
        h ^= (h >> 10)
        h += (h << 3)
        h ^= (h >> 6)
        h += (h << 2) + (h << 14)
        return h ^ (h >> 16)
      end
    }
    
    typesig { [::Java::Int] }
    # Returns the segment that should be used for key with given hash
    # @param hash the hash code for the key
    # @return the segment
    def segment_for(hash)
      return @segments[(hash >> @segment_shift) & @segment_mask]
    end
    
    class_module.module_eval {
      # ---------------- Inner Classes --------------
      # 
      # ConcurrentHashMap list entry. Note that this is never exported
      # out as a user-visible Map.Entry.
      # 
      # Because the value field is volatile, not final, it is legal wrt
      # the Java Memory Model for an unsynchronized reader to see null
      # instead of initial value when read via a data race.  Although a
      # reordering leading to this is not likely to ever actually
      # occur, the Segment.readValueUnderLock method is used as a
      # backup in case a null (pre-initialized) value is ever seen in
      # an unsynchronized access method.
      const_set_lazy(:HashEntry) { Class.new do
        include_class_members ConcurrentHashMap
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :hash
        alias_method :attr_hash, :hash
        undef_method :hash
        alias_method :attr_hash=, :hash=
        undef_method :hash=
        
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
        
        typesig { [Object, ::Java::Int, class_self::HashEntry, Object] }
        def initialize(key, hash, next_, value)
          @key = nil
          @hash = 0
          @value = nil
          @next = nil
          @key = key
          @hash = hash
          @next = next_
          @value = value
        end
        
        class_module.module_eval {
          typesig { [::Java::Int] }
          def new_array(i)
            return Array.typed(class_self::HashEntry).new(i) { nil }
          end
        }
        
        private
        alias_method :initialize__hash_entry, :initialize
      end }
      
      # Segments are specialized versions of hash tables.  This
      # subclasses from ReentrantLock opportunistically, just to
      # simplify some locking and avoid separate construction.
      const_set_lazy(:Segment) { Class.new(ReentrantLock) do
        include_class_members ConcurrentHashMap
        overload_protected {
          include Serializable
        }
        
        class_module.module_eval {
          # Segments maintain a table of entry lists that are ALWAYS
          # kept in a consistent state, so can be read without locking.
          # Next fields of nodes are immutable (final).  All list
          # additions are performed at the front of each bin. This
          # makes it easy to check changes, and also fast to traverse.
          # When nodes would otherwise be changed, new nodes are
          # created to replace them. This works well for hash tables
          # since the bin lists tend to be short. (The average length
          # is less than two for the default load factor threshold.)
          # 
          # Read operations can thus proceed without locking, but rely
          # on selected uses of volatiles to ensure that completed
          # write operations performed by other threads are
          # noticed. For most purposes, the "count" field, tracking the
          # number of elements, serves as that volatile variable
          # ensuring visibility.  This is convenient because this field
          # needs to be read in many read operations anyway:
          # 
          # - All (unsynchronized) read operations must first read the
          # "count" field, and should not look at table entries if
          # it is 0.
          # 
          # - All (synchronized) write operations should write to
          # the "count" field after structurally changing any bin.
          # The operations must not take any action that could even
          # momentarily cause a concurrent read operation to see
          # inconsistent data. This is made easier by the nature of
          # the read operations in Map. For example, no operation
          # can reveal that the table has grown but the threshold
          # has not yet been updated, so there are no atomicity
          # requirements for this with respect to reads.
          # 
          # As a guide, all critical volatile reads and writes to the
          # count field are marked in code comments.
          const_set_lazy(:SerialVersionUID) { 2249069246763182397 }
          const_attr_reader  :SerialVersionUID
        }
        
        # The number of elements in this segment's region.
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        # Number of updates that alter the size of the table. This is
        # used during bulk-read methods to make sure they see a
        # consistent snapshot: If modCounts change during a traversal
        # of segments computing size or checking containsValue, then
        # we might have an inconsistent view of state so (usually)
        # must retry.
        attr_accessor :mod_count
        alias_method :attr_mod_count, :mod_count
        undef_method :mod_count
        alias_method :attr_mod_count=, :mod_count=
        undef_method :mod_count=
        
        # The table is rehashed when its size exceeds this threshold.
        # (The value of this field is always <tt>(int)(capacity *
        # loadFactor)</tt>.)
        attr_accessor :threshold
        alias_method :attr_threshold, :threshold
        undef_method :threshold
        alias_method :attr_threshold=, :threshold=
        undef_method :threshold=
        
        # The per-segment table.
        attr_accessor :table
        alias_method :attr_table, :table
        undef_method :table
        alias_method :attr_table=, :table=
        undef_method :table=
        
        # The load factor for the hash table.  Even though this value
        # is same for all segments, it is replicated to avoid needing
        # links to outer object.
        # @serial
        attr_accessor :load_factor
        alias_method :attr_load_factor, :load_factor
        undef_method :load_factor
        alias_method :attr_load_factor=, :load_factor=
        undef_method :load_factor=
        
        typesig { [::Java::Int, ::Java::Float] }
        def initialize(initial_capacity, lf)
          @count = 0
          @mod_count = 0
          @threshold = 0
          @table = nil
          @load_factor = 0.0
          super()
          @load_factor = lf
          set_table(HashEntry.new_array(initial_capacity))
        end
        
        class_module.module_eval {
          typesig { [::Java::Int] }
          def new_array(i)
            return Array.typed(class_self::Segment).new(i) { nil }
          end
        }
        
        typesig { [Array.typed(class_self::HashEntry)] }
        # Sets table to new HashEntry array.
        # Call only while holding lock or in constructor.
        def set_table(new_table)
          @threshold = RJava.cast_to_int((new_table.attr_length * @load_factor))
          @table = new_table
        end
        
        typesig { [::Java::Int] }
        # Returns properly casted first entry of bin for given hash.
        def get_first(hash)
          tab = @table
          return tab[hash & (tab.attr_length - 1)]
        end
        
        typesig { [class_self::HashEntry] }
        # Reads value field of an entry under lock. Called if value
        # field ever appears to be null. This is possible only if a
        # compiler happens to reorder a HashEntry initialization with
        # its table assignment, which is legal under memory model
        # but is not known to ever occur.
        def read_value_under_lock(e)
          lock
          begin
            return e.attr_value
          ensure
            unlock
          end
        end
        
        typesig { [Object, ::Java::Int] }
        # Specialized implementations of map methods
        def get(key, hash)
          if (!(@count).equal?(0))
            # read-volatile
            e = get_first(hash)
            while (!(e).nil?)
              if ((e.attr_hash).equal?(hash) && (key == e.attr_key))
                v = e.attr_value
                if (!(v).nil?)
                  return v
                end
                return read_value_under_lock(e) # recheck
              end
              e = e.attr_next
            end
          end
          return nil
        end
        
        typesig { [Object, ::Java::Int] }
        def contains_key(key, hash)
          if (!(@count).equal?(0))
            # read-volatile
            e = get_first(hash)
            while (!(e).nil?)
              if ((e.attr_hash).equal?(hash) && (key == e.attr_key))
                return true
              end
              e = e.attr_next
            end
          end
          return false
        end
        
        typesig { [Object] }
        def contains_value(value)
          if (!(@count).equal?(0))
            # read-volatile
            tab = @table
            len = tab.attr_length
            i = 0
            while i < len
              e = tab[i]
              while !(e).nil?
                v = e.attr_value
                if ((v).nil?)
                  # recheck
                  v = read_value_under_lock(e)
                end
                if ((value == v))
                  return true
                end
                e = e.attr_next
              end
              i += 1
            end
          end
          return false
        end
        
        typesig { [Object, ::Java::Int, Object, Object] }
        def replace(key, hash, old_value, new_value)
          lock
          begin
            e = get_first(hash)
            while (!(e).nil? && (!(e.attr_hash).equal?(hash) || !(key == e.attr_key)))
              e = e.attr_next
            end
            replaced = false
            if (!(e).nil? && (old_value == e.attr_value))
              replaced = true
              e.attr_value = new_value
            end
            return replaced
          ensure
            unlock
          end
        end
        
        typesig { [Object, ::Java::Int, Object] }
        def replace(key, hash, new_value)
          lock
          begin
            e = get_first(hash)
            while (!(e).nil? && (!(e.attr_hash).equal?(hash) || !(key == e.attr_key)))
              e = e.attr_next
            end
            old_value = nil
            if (!(e).nil?)
              old_value = e.attr_value
              e.attr_value = new_value
            end
            return old_value
          ensure
            unlock
          end
        end
        
        typesig { [Object, ::Java::Int, Object, ::Java::Boolean] }
        def put(key, hash, value, only_if_absent)
          lock
          begin
            c = @count
            if (((c += 1) - 1) > @threshold)
              # ensure capacity
              rehash
            end
            tab = @table
            index = hash & (tab.attr_length - 1)
            first = tab[index]
            e = first
            while (!(e).nil? && (!(e.attr_hash).equal?(hash) || !(key == e.attr_key)))
              e = e.attr_next
            end
            old_value = nil
            if (!(e).nil?)
              old_value = e.attr_value
              if (!only_if_absent)
                e.attr_value = value
              end
            else
              old_value = nil
              (@mod_count += 1)
              tab[index] = self.class::HashEntry.new(key, hash, first, value)
              @count = c # write-volatile
            end
            return old_value
          ensure
            unlock
          end
        end
        
        typesig { [] }
        def rehash
          old_table = @table
          old_capacity = old_table.attr_length
          if (old_capacity >= MAXIMUM_CAPACITY)
            return
          end
          # Reclassify nodes in each list to new Map.  Because we are
          # using power-of-two expansion, the elements from each bin
          # must either stay at same index, or move with a power of two
          # offset. We eliminate unnecessary node creation by catching
          # cases where old nodes can be reused because their next
          # fields won't change. Statistically, at the default
          # threshold, only about one-sixth of them need cloning when
          # a table doubles. The nodes they replace will be garbage
          # collectable as soon as they are no longer referenced by any
          # reader thread that may be in the midst of traversing table
          # right now.
          new_table = HashEntry.new_array(old_capacity << 1)
          @threshold = RJava.cast_to_int((new_table.attr_length * @load_factor))
          size_mask = new_table.attr_length - 1
          i = 0
          while i < old_capacity
            # We need to guarantee that any existing reads of old Map can
            # proceed. So we cannot yet null out each bin.
            e = old_table[i]
            if (!(e).nil?)
              next_ = e.attr_next
              idx = e.attr_hash & size_mask
              # Single node on list
              if ((next_).nil?)
                new_table[idx] = e
              else
                # Reuse trailing consecutive sequence at same slot
                last_run = e
                last_idx = idx
                last = next_
                while !(last).nil?
                  k = last.attr_hash & size_mask
                  if (!(k).equal?(last_idx))
                    last_idx = k
                    last_run = last
                  end
                  last = last.attr_next
                end
                new_table[last_idx] = last_run
                # Clone all remaining nodes
                p = e
                while !(p).equal?(last_run)
                  k = p.attr_hash & size_mask
                  n = new_table[k]
                  new_table[k] = self.class::HashEntry.new(p.attr_key, p.attr_hash, n, p.attr_value)
                  p = p.attr_next
                end
              end
            end
            i += 1
          end
          @table = new_table
        end
        
        typesig { [Object, ::Java::Int, Object] }
        # Remove; match on key only if value null, else match both.
        def remove(key, hash, value)
          lock
          begin
            c = @count - 1
            tab = @table
            index = hash & (tab.attr_length - 1)
            first = tab[index]
            e = first
            while (!(e).nil? && (!(e.attr_hash).equal?(hash) || !(key == e.attr_key)))
              e = e.attr_next
            end
            old_value = nil
            if (!(e).nil?)
              v = e.attr_value
              if ((value).nil? || (value == v))
                old_value = v
                # All entries following removed node can stay
                # in list, but all preceding ones need to be
                # cloned.
                (@mod_count += 1)
                new_first = e.attr_next
                p = first
                while !(p).equal?(e)
                  new_first = self.class::HashEntry.new(p.attr_key, p.attr_hash, new_first, p.attr_value)
                  p = p.attr_next
                end
                tab[index] = new_first
                @count = c # write-volatile
              end
            end
            return old_value
          ensure
            unlock
          end
        end
        
        typesig { [] }
        def clear
          if (!(@count).equal?(0))
            lock
            begin
              tab = @table
              i = 0
              while i < tab.attr_length
                tab[i] = nil
                i += 1
              end
              (@mod_count += 1)
              @count = 0 # write-volatile
            ensure
              unlock
            end
          end
        end
        
        private
        alias_method :initialize__segment, :initialize
      end }
    }
    
    typesig { [::Java::Int, ::Java::Float, ::Java::Int] }
    # ---------------- Public operations --------------
    # 
    # Creates a new, empty map with the specified initial
    # capacity, load factor and concurrency level.
    # 
    # @param initialCapacity the initial capacity. The implementation
    # performs internal sizing to accommodate this many elements.
    # @param loadFactor  the load factor threshold, used to control resizing.
    # Resizing may be performed when the average number of elements per
    # bin exceeds this threshold.
    # @param concurrencyLevel the estimated number of concurrently
    # updating threads. The implementation performs internal sizing
    # to try to accommodate this many threads.
    # @throws IllegalArgumentException if the initial capacity is
    # negative or the load factor or concurrencyLevel are
    # nonpositive.
    def initialize(initial_capacity, load_factor, concurrency_level)
      @segment_mask = 0
      @segment_shift = 0
      @segments = nil
      @key_set = nil
      @entry_set = nil
      @values = nil
      super()
      if (!(load_factor > 0) || initial_capacity < 0 || concurrency_level <= 0)
        raise IllegalArgumentException.new
      end
      if (concurrency_level > MAX_SEGMENTS)
        concurrency_level = MAX_SEGMENTS
      end
      # Find power-of-two sizes best matching arguments
      sshift = 0
      ssize = 1
      while (ssize < concurrency_level)
        (sshift += 1)
        ssize <<= 1
      end
      @segment_shift = 32 - sshift
      @segment_mask = ssize - 1
      @segments = Segment.new_array(ssize)
      if (initial_capacity > MAXIMUM_CAPACITY)
        initial_capacity = MAXIMUM_CAPACITY
      end
      c = initial_capacity / ssize
      if (c * ssize < initial_capacity)
        (c += 1)
      end
      cap = 1
      while (cap < c)
        cap <<= 1
      end
      i = 0
      while i < @segments.attr_length
        @segments[i] = Segment.new(cap, load_factor)
        (i += 1)
      end
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # Creates a new, empty map with the specified initial capacity
    # and load factor and with the default concurrencyLevel (16).
    # 
    # @param initialCapacity The implementation performs internal
    # sizing to accommodate this many elements.
    # @param loadFactor  the load factor threshold, used to control resizing.
    # Resizing may be performed when the average number of elements per
    # bin exceeds this threshold.
    # @throws IllegalArgumentException if the initial capacity of
    # elements is negative or the load factor is nonpositive
    # 
    # @since 1.6
    def initialize(initial_capacity, load_factor)
      initialize__concurrent_hash_map(initial_capacity, load_factor, DEFAULT_CONCURRENCY_LEVEL)
    end
    
    typesig { [::Java::Int] }
    # Creates a new, empty map with the specified initial capacity,
    # and with default load factor (0.75) and concurrencyLevel (16).
    # 
    # @param initialCapacity the initial capacity. The implementation
    # performs internal sizing to accommodate this many elements.
    # @throws IllegalArgumentException if the initial capacity of
    # elements is negative.
    def initialize(initial_capacity)
      initialize__concurrent_hash_map(initial_capacity, DEFAULT_LOAD_FACTOR, DEFAULT_CONCURRENCY_LEVEL)
    end
    
    typesig { [] }
    # Creates a new, empty map with a default initial capacity (16),
    # load factor (0.75) and concurrencyLevel (16).
    def initialize
      initialize__concurrent_hash_map(DEFAULT_INITIAL_CAPACITY, DEFAULT_LOAD_FACTOR, DEFAULT_CONCURRENCY_LEVEL)
    end
    
    typesig { [Map] }
    # Creates a new map with the same mappings as the given map.
    # The map is created with a capacity of 1.5 times the number
    # of mappings in the given map or 16 (whichever is greater),
    # and a default load factor (0.75) and concurrencyLevel (16).
    # 
    # @param m the map
    def initialize(m)
      initialize__concurrent_hash_map(Math.max(RJava.cast_to_int((m.size / DEFAULT_LOAD_FACTOR)) + 1, DEFAULT_INITIAL_CAPACITY), DEFAULT_LOAD_FACTOR, DEFAULT_CONCURRENCY_LEVEL)
      put_all(m)
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this map contains no key-value mappings.
    # 
    # @return <tt>true</tt> if this map contains no key-value mappings
    def is_empty
      segments = @segments
      # We keep track of per-segment modCounts to avoid ABA
      # problems in which an element in one segment was added and
      # in another removed during traversal, in which case the
      # table was never actually empty at any point. Note the
      # similar use of modCounts in the size() and containsValue()
      # methods, which are the only other methods also susceptible
      # to ABA problems.
      mc = Array.typed(::Java::Int).new(segments.attr_length) { 0 }
      mcsum = 0
      i = 0
      while i < segments.attr_length
        if (!(segments[i].attr_count).equal?(0))
          return false
        else
          mcsum += mc[i] = segments[i].attr_mod_count
        end
        (i += 1)
      end
      # If mcsum happens to be zero, then we know we got a snapshot
      # before any modifications at all were made.  This is
      # probably common enough to bother tracking.
      if (!(mcsum).equal?(0))
        i_ = 0
        while i_ < segments.attr_length
          if (!(segments[i_].attr_count).equal?(0) || !(mc[i_]).equal?(segments[i_].attr_mod_count))
            return false
          end
          (i_ += 1)
        end
      end
      return true
    end
    
    typesig { [] }
    # Returns the number of key-value mappings in this map.  If the
    # map contains more than <tt>Integer.MAX_VALUE</tt> elements, returns
    # <tt>Integer.MAX_VALUE</tt>.
    # 
    # @return the number of key-value mappings in this map
    def size
      segments = @segments
      sum = 0
      check = 0
      mc = Array.typed(::Java::Int).new(segments.attr_length) { 0 }
      # Try a few times to get accurate count. On failure due to
      # continuous async changes in table, resort to locking.
      k = 0
      while k < RETRIES_BEFORE_LOCK
        check = 0
        sum = 0
        mcsum = 0
        i = 0
        while i < segments.attr_length
          sum += segments[i].attr_count
          mcsum += mc[i] = segments[i].attr_mod_count
          (i += 1)
        end
        if (!(mcsum).equal?(0))
          i_ = 0
          while i_ < segments.attr_length
            check += segments[i_].attr_count
            if (!(mc[i_]).equal?(segments[i_].attr_mod_count))
              check = -1 # force retry
              break
            end
            (i_ += 1)
          end
        end
        if ((check).equal?(sum))
          break
        end
        (k += 1)
      end
      if (!(check).equal?(sum))
        # Resort to locking all segments
        sum = 0
        i = 0
        while i < segments.attr_length
          segments[i].lock
          (i += 1)
        end
        i_ = 0
        while i_ < segments.attr_length
          sum += segments[i_].attr_count
          (i_ += 1)
        end
        i__ = 0
        while i__ < segments.attr_length
          segments[i__].unlock
          (i__ += 1)
        end
      end
      if (sum > JavaInteger::MAX_VALUE)
        return JavaInteger::MAX_VALUE
      else
        return RJava.cast_to_int(sum)
      end
    end
    
    typesig { [Object] }
    # Returns the value to which the specified key is mapped,
    # or {@code null} if this map contains no mapping for the key.
    # 
    # <p>More formally, if this map contains a mapping from a key
    # {@code k} to a value {@code v} such that {@code key.equals(k)},
    # then this method returns {@code v}; otherwise it returns
    # {@code null}.  (There can be at most one such mapping.)
    # 
    # @throws NullPointerException if the specified key is null
    def get(key)
      hash_ = hash(key.hash_code)
      return segment_for(hash_).get(key, hash_)
    end
    
    typesig { [Object] }
    # Tests if the specified object is a key in this table.
    # 
    # @param  key   possible key
    # @return <tt>true</tt> if and only if the specified object
    # is a key in this table, as determined by the
    # <tt>equals</tt> method; <tt>false</tt> otherwise.
    # @throws NullPointerException if the specified key is null
    def contains_key(key)
      hash_ = hash(key.hash_code)
      return segment_for(hash_).contains_key(key, hash_)
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map maps one or more keys to the
    # specified value. Note: This method requires a full internal
    # traversal of the hash table, and so is much slower than
    # method <tt>containsKey</tt>.
    # 
    # @param value value whose presence in this map is to be tested
    # @return <tt>true</tt> if this map maps one or more keys to the
    # specified value
    # @throws NullPointerException if the specified value is null
    def contains_value(value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      # See explanation of modCount use above
      segments = @segments
      mc = Array.typed(::Java::Int).new(segments.attr_length) { 0 }
      # Try a few times without locking
      k = 0
      while k < RETRIES_BEFORE_LOCK
        sum = 0
        mcsum = 0
        i = 0
        while i < segments.attr_length
          c = segments[i].attr_count
          mcsum += mc[i] = segments[i].attr_mod_count
          if (segments[i].contains_value(value))
            return true
          end
          (i += 1)
        end
        clean_sweep = true
        if (!(mcsum).equal?(0))
          i_ = 0
          while i_ < segments.attr_length
            c = segments[i_].attr_count
            if (!(mc[i_]).equal?(segments[i_].attr_mod_count))
              clean_sweep = false
              break
            end
            (i_ += 1)
          end
        end
        if (clean_sweep)
          return false
        end
        (k += 1)
      end
      # Resort to locking all segments
      i = 0
      while i < segments.attr_length
        segments[i].lock
        (i += 1)
      end
      found = false
      begin
        i_ = 0
        while i_ < segments.attr_length
          if (segments[i_].contains_value(value))
            found = true
            break
          end
          (i_ += 1)
        end
      ensure
        i__ = 0
        while i__ < segments.attr_length
          segments[i__].unlock
          (i__ += 1)
        end
      end
      return found
    end
    
    typesig { [Object] }
    # Legacy method testing if some key maps into the specified value
    # in this table.  This method is identical in functionality to
    # {@link #containsValue}, and exists solely to ensure
    # full compatibility with class {@link java.util.Hashtable},
    # which supported this method prior to introduction of the
    # Java Collections framework.
    # 
    # @param  value a value to search for
    # @return <tt>true</tt> if and only if some key maps to the
    # <tt>value</tt> argument in this table as
    # determined by the <tt>equals</tt> method;
    # <tt>false</tt> otherwise
    # @throws NullPointerException if the specified value is null
    def contains(value)
      return contains_value(value)
    end
    
    typesig { [Object, Object] }
    # Maps the specified key to the specified value in this table.
    # Neither the key nor the value can be null.
    # 
    # <p> The value can be retrieved by calling the <tt>get</tt> method
    # with a key that is equal to the original key.
    # 
    # @param key key with which the specified value is to be associated
    # @param value value to be associated with the specified key
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>
    # @throws NullPointerException if the specified key or value is null
    def put(key, value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      hash_ = hash(key.hash_code)
      return segment_for(hash_).put(key, hash_, value, false)
    end
    
    typesig { [Object, Object] }
    # {@inheritDoc}
    # 
    # @return the previous value associated with the specified key,
    # or <tt>null</tt> if there was no mapping for the key
    # @throws NullPointerException if the specified key or value is null
    def put_if_absent(key, value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      hash_ = hash(key.hash_code)
      return segment_for(hash_).put(key, hash_, value, true)
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified map to this one.
    # These mappings replace any mappings that this map had for any of the
    # keys currently in the specified map.
    # 
    # @param m mappings to be stored in this map
    def put_all(m)
      m.entry_set.each do |e|
        put(e.get_key, e.get_value)
      end
    end
    
    typesig { [Object] }
    # Removes the key (and its corresponding value) from this map.
    # This method does nothing if the key is not in the map.
    # 
    # @param  key the key that needs to be removed
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>
    # @throws NullPointerException if the specified key is null
    def remove(key)
      hash_ = hash(key.hash_code)
      return segment_for(hash_).remove(key, hash_, nil)
    end
    
    typesig { [Object, Object] }
    # {@inheritDoc}
    # 
    # @throws NullPointerException if the specified key is null
    def remove(key, value)
      hash_ = hash(key.hash_code)
      if ((value).nil?)
        return false
      end
      return !(segment_for(hash_).remove(key, hash_, value)).nil?
    end
    
    typesig { [Object, Object, Object] }
    # {@inheritDoc}
    # 
    # @throws NullPointerException if any of the arguments are null
    def replace(key, old_value, new_value)
      if ((old_value).nil? || (new_value).nil?)
        raise NullPointerException.new
      end
      hash_ = hash(key.hash_code)
      return segment_for(hash_).replace(key, hash_, old_value, new_value)
    end
    
    typesig { [Object, Object] }
    # {@inheritDoc}
    # 
    # @return the previous value associated with the specified key,
    # or <tt>null</tt> if there was no mapping for the key
    # @throws NullPointerException if the specified key or value is null
    def replace(key, value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      hash_ = hash(key.hash_code)
      return segment_for(hash_).replace(key, hash_, value)
    end
    
    typesig { [] }
    # Removes all of the mappings from this map.
    def clear
      i = 0
      while i < @segments.attr_length
        @segments[i].clear
        (i += 1)
      end
    end
    
    typesig { [] }
    # Returns a {@link Set} view of the keys contained in this map.
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  The set supports element
    # removal, which removes the corresponding mapping from this map,
    # via the <tt>Iterator.remove</tt>, <tt>Set.remove</tt>,
    # <tt>removeAll</tt>, <tt>retainAll</tt>, and <tt>clear</tt>
    # operations.  It does not support the <tt>add</tt> or
    # <tt>addAll</tt> operations.
    # 
    # <p>The view's <tt>iterator</tt> is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    def key_set
      ks = @key_set
      return (!(ks).nil?) ? ks : (@key_set = KeySet.new_local(self))
    end
    
    typesig { [] }
    # Returns a {@link Collection} view of the values contained in this map.
    # The collection is backed by the map, so changes to the map are
    # reflected in the collection, and vice-versa.  The collection
    # supports element removal, which removes the corresponding
    # mapping from this map, via the <tt>Iterator.remove</tt>,
    # <tt>Collection.remove</tt>, <tt>removeAll</tt>,
    # <tt>retainAll</tt>, and <tt>clear</tt> operations.  It does not
    # support the <tt>add</tt> or <tt>addAll</tt> operations.
    # 
    # <p>The view's <tt>iterator</tt> is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    def values
      vs = @values
      return (!(vs).nil?) ? vs : (@values = Values.new_local(self))
    end
    
    typesig { [] }
    # Returns a {@link Set} view of the mappings contained in this map.
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  The set supports element
    # removal, which removes the corresponding mapping from the map,
    # via the <tt>Iterator.remove</tt>, <tt>Set.remove</tt>,
    # <tt>removeAll</tt>, <tt>retainAll</tt>, and <tt>clear</tt>
    # operations.  It does not support the <tt>add</tt> or
    # <tt>addAll</tt> operations.
    # 
    # <p>The view's <tt>iterator</tt> is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    def entry_set
      es = @entry_set
      return (!(es).nil?) ? es : (@entry_set = EntrySet.new_local(self))
    end
    
    typesig { [] }
    # Returns an enumeration of the keys in this table.
    # 
    # @return an enumeration of the keys in this table
    # @see #keySet()
    def keys
      return KeyIterator.new_local(self)
    end
    
    typesig { [] }
    # Returns an enumeration of the values in this table.
    # 
    # @return an enumeration of the values in this table
    # @see #values()
    def elements
      return ValueIterator.new_local(self)
    end
    
    class_module.module_eval {
      # ---------------- Iterator Support --------------
      const_set_lazy(:HashIterator) { Class.new do
        extend LocalClass
        include_class_members ConcurrentHashMap
        
        attr_accessor :next_segment_index
        alias_method :attr_next_segment_index, :next_segment_index
        undef_method :next_segment_index
        alias_method :attr_next_segment_index=, :next_segment_index=
        undef_method :next_segment_index=
        
        attr_accessor :next_table_index
        alias_method :attr_next_table_index, :next_table_index
        undef_method :next_table_index
        alias_method :attr_next_table_index=, :next_table_index=
        undef_method :next_table_index=
        
        attr_accessor :current_table
        alias_method :attr_current_table, :current_table
        undef_method :current_table
        alias_method :attr_current_table=, :current_table=
        undef_method :current_table=
        
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
        
        typesig { [] }
        def initialize
          @next_segment_index = 0
          @next_table_index = 0
          @current_table = nil
          @next_entry = nil
          @last_returned = nil
          @next_segment_index = self.attr_segments.attr_length - 1
          @next_table_index = -1
          advance
        end
        
        typesig { [] }
        def has_more_elements
          return has_next
        end
        
        typesig { [] }
        def advance
          if (!(@next_entry).nil? && !((@next_entry = @next_entry.attr_next)).nil?)
            return
          end
          while (@next_table_index >= 0)
            if (!((@next_entry = @current_table[((@next_table_index -= 1) + 1)])).nil?)
              return
            end
          end
          while (@next_segment_index >= 0)
            seg = self.attr_segments[((@next_segment_index -= 1) + 1)]
            if (!(seg.attr_count).equal?(0))
              @current_table = seg.attr_table
              j = @current_table.attr_length - 1
              while j >= 0
                if (!((@next_entry = @current_table[j])).nil?)
                  @next_table_index = j - 1
                  return
                end
                (j -= 1)
              end
            end
          end
        end
        
        typesig { [] }
        def has_next
          return !(@next_entry).nil?
        end
        
        typesig { [] }
        def next_entry
          if ((@next_entry).nil?)
            raise self.class::NoSuchElementException.new
          end
          @last_returned = @next_entry
          advance
          return @last_returned
        end
        
        typesig { [] }
        def remove
          if ((@last_returned).nil?)
            raise self.class::IllegalStateException.new
          end
          @local_class_parent.remove(@last_returned.attr_key)
          @last_returned = nil
        end
        
        private
        alias_method :initialize__hash_iterator, :initialize
      end }
      
      const_set_lazy(:KeyIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members ConcurrentHashMap
        overload_protected {
          include Iterator
          include Enumeration
        }
        
        typesig { [] }
        def next_
          return HashIterator.instance_method(:next_entry).bind(self).call.attr_key
        end
        
        typesig { [] }
        def next_element
          return HashIterator.instance_method(:next_entry).bind(self).call.attr_key
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__key_iterator, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members ConcurrentHashMap
        overload_protected {
          include Iterator
          include Enumeration
        }
        
        typesig { [] }
        def next_
          return HashIterator.instance_method(:next_entry).bind(self).call.attr_value
        end
        
        typesig { [] }
        def next_element
          return HashIterator.instance_method(:next_entry).bind(self).call.attr_value
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__value_iterator, :initialize
      end }
      
      # Custom Entry class used by EntryIterator.next(), that relays
      # setValue changes to the underlying map.
      const_set_lazy(:WriteThroughEntry) { Class.new(AbstractMap::SimpleEntry) do
        extend LocalClass
        include_class_members ConcurrentHashMap
        
        typesig { [class_self::K, class_self::V] }
        def initialize(k, v)
          super(k, v)
        end
        
        typesig { [class_self::V] }
        # Set our entry's value and write through to the map. The
        # value to return is somewhat arbitrary here. Since a
        # WriteThroughEntry does not necessarily track asynchronous
        # changes, the most recent "previous" value could be
        # different from what we return (or could even have been
        # removed in which case the put will re-establish). We do not
        # and cannot guarantee more.
        def set_value(value)
          if ((value).nil?)
            raise self.class::NullPointerException.new
          end
          v = super(value)
          @local_class_parent.put(get_key, value)
          return v
        end
        
        private
        alias_method :initialize__write_through_entry, :initialize
      end }
      
      const_set_lazy(:EntryIterator) { Class.new(HashIterator) do
        extend LocalClass
        include_class_members ConcurrentHashMap
        overload_protected {
          include Iterator
        }
        
        typesig { [] }
        def next_
          e = HashIterator.instance_method(:next_entry).bind(self).call
          return self.class::WriteThroughEntry.new(e.attr_key, e.attr_value)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_iterator, :initialize
      end }
      
      const_set_lazy(:KeySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members ConcurrentHashMap
        
        typesig { [] }
        def iterator
          return self.class::KeyIterator.new
        end
        
        typesig { [] }
        def size
          return @local_class_parent.size
        end
        
        typesig { [] }
        def is_empty
          return @local_class_parent.is_empty
        end
        
        typesig { [Object] }
        def contains(o)
          return @local_class_parent.contains_key(o)
        end
        
        typesig { [Object] }
        def remove(o)
          return !(@local_class_parent.remove(o)).nil?
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
      
      const_set_lazy(:Values) { Class.new(AbstractCollection) do
        extend LocalClass
        include_class_members ConcurrentHashMap
        
        typesig { [] }
        def iterator
          return self.class::ValueIterator.new
        end
        
        typesig { [] }
        def size
          return @local_class_parent.size
        end
        
        typesig { [] }
        def is_empty
          return @local_class_parent.is_empty
        end
        
        typesig { [Object] }
        def contains(o)
          return @local_class_parent.contains_value(o)
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
      
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members ConcurrentHashMap
        
        typesig { [] }
        def iterator
          return self.class::EntryIterator.new
        end
        
        typesig { [Object] }
        def contains(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          v = @local_class_parent.get(e.get_key)
          return !(v).nil? && (v == e.get_value)
        end
        
        typesig { [Object] }
        def remove(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          return @local_class_parent.remove(e.get_key, e.get_value)
        end
        
        typesig { [] }
        def size
          return @local_class_parent.size
        end
        
        typesig { [] }
        def is_empty
          return @local_class_parent.is_empty
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
    # ---------------- Serialization Support --------------
    # 
    # Save the state of the <tt>ConcurrentHashMap</tt> instance to a
    # stream (i.e., serialize it).
    # @param s the stream
    # @serialData
    # the key (Object) and value (Object)
    # for each key-value mapping, followed by a null pair.
    # The key-value mappings are emitted in no particular order.
    def write_object(s)
      s.default_write_object
      k = 0
      while k < @segments.attr_length
        seg = @segments[k]
        seg.lock
        begin
          tab = seg.attr_table
          i = 0
          while i < tab.attr_length
            e = tab[i]
            while !(e).nil?
              s.write_object(e.attr_key)
              s.write_object(e.attr_value)
              e = e.attr_next
            end
            (i += 1)
          end
        ensure
          seg.unlock
        end
        (k += 1)
      end
      s.write_object(nil)
      s.write_object(nil)
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the <tt>ConcurrentHashMap</tt> instance from a
    # stream (i.e., deserialize it).
    # @param s the stream
    def read_object(s)
      s.default_read_object
      # Initialize each segment to be minimally sized, and let grow.
      i = 0
      while i < @segments.attr_length
        @segments[i].set_table(Array.typed(HashEntry).new(1) { nil })
        (i += 1)
      end
      # Read the keys and values, and put the mappings in the table
      loop do
        key = s.read_object
        value = s.read_object
        if ((key).nil?)
          break
        end
        put(key, value)
      end
    end
    
    private
    alias_method :initialize__concurrent_hash_map, :initialize
  end
  
end
