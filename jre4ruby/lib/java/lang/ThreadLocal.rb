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
module Java::Lang
  module ThreadLocalImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Ref
      include_const ::Java::Util::Concurrent::Atomic, :AtomicInteger
    }
  end
  
  # This class provides thread-local variables.  These variables differ from
  # their normal counterparts in that each thread that accesses one (via its
  # <tt>get</tt> or <tt>set</tt> method) has its own, independently initialized
  # copy of the variable.  <tt>ThreadLocal</tt> instances are typically private
  # static fields in classes that wish to associate state with a thread (e.g.,
  # a user ID or Transaction ID).
  # 
  # <p>For example, the class below generates unique identifiers local to each
  # thread.
  # A thread's id is assigned the first time it invokes <tt>ThreadId.get()</tt>
  # and remains unchanged on subsequent calls.
  # <pre>
  # import java.util.concurrent.atomic.AtomicInteger;
  # 
  # public class ThreadId {
  # // Atomic integer containing the next thread ID to be assigned
  # private static final AtomicInteger nextId = new AtomicInteger(0);
  # 
  # // Thread local variable containing each thread's ID
  # private static final ThreadLocal&lt;Integer> threadId =
  # new ThreadLocal&lt;Integer>() {
  # &#64;Override protected Integer initialValue() {
  # return nextId.getAndIncrement();
  # }
  # };
  # 
  # // Returns the current thread's unique ID, assigning it if necessary
  # public static int get() {
  # return threadId.get();
  # }
  # }
  # </pre>
  # <p>Each thread holds an implicit reference to its copy of a thread-local
  # variable as long as the thread is alive and the <tt>ThreadLocal</tt>
  # instance is accessible; after a thread goes away, all of its copies of
  # thread-local instances are subject to garbage collection (unless other
  # references to these copies exist).
  # 
  # @author  Josh Bloch and Doug Lea
  # @since   1.2
  class ThreadLocal 
    include_class_members ThreadLocalImports
    
    # ThreadLocals rely on per-thread linear-probe hash maps attached
    # to each thread (Thread.threadLocals and
    # inheritableThreadLocals).  The ThreadLocal objects act as keys,
    # searched via threadLocalHashCode.  This is a custom hash code
    # (useful only within ThreadLocalMaps) that eliminates collisions
    # in the common case where consecutively constructed ThreadLocals
    # are used by the same threads, while remaining well-behaved in
    # less common cases.
    attr_accessor :thread_local_hash_code
    alias_method :attr_thread_local_hash_code, :thread_local_hash_code
    undef_method :thread_local_hash_code
    alias_method :attr_thread_local_hash_code=, :thread_local_hash_code=
    undef_method :thread_local_hash_code=
    
    class_module.module_eval {
      # The next hash code to be given out. Updated atomically. Starts at
      # zero.
      
      def next_hash_code
        defined?(@@next_hash_code) ? @@next_hash_code : @@next_hash_code= AtomicInteger.new
      end
      alias_method :attr_next_hash_code, :next_hash_code
      
      def next_hash_code=(value)
        @@next_hash_code = value
      end
      alias_method :attr_next_hash_code=, :next_hash_code=
      
      # The difference between successively generated hash codes - turns
      # implicit sequential thread-local IDs into near-optimally spread
      # multiplicative hash values for power-of-two-sized tables.
      const_set_lazy(:HASH_INCREMENT) { 0x61c88647 }
      const_attr_reader  :HASH_INCREMENT
      
      typesig { [] }
      # Returns the next hash code.
      def next_hash_code
        return self.attr_next_hash_code.get_and_add(HASH_INCREMENT)
      end
    }
    
    typesig { [] }
    # Returns the current thread's "initial value" for this
    # thread-local variable.  This method will be invoked the first
    # time a thread accesses the variable with the {@link #get}
    # method, unless the thread previously invoked the {@link #set}
    # method, in which case the <tt>initialValue</tt> method will not
    # be invoked for the thread.  Normally, this method is invoked at
    # most once per thread, but it may be invoked again in case of
    # subsequent invocations of {@link #remove} followed by {@link #get}.
    # 
    # <p>This implementation simply returns <tt>null</tt>; if the
    # programmer desires thread-local variables to have an initial
    # value other than <tt>null</tt>, <tt>ThreadLocal</tt> must be
    # subclassed, and this method overridden.  Typically, an
    # anonymous inner class will be used.
    # 
    # @return the initial value for this thread-local
    def initial_value
      return nil
    end
    
    typesig { [] }
    # Creates a thread local variable.
    def initialize
      @thread_local_hash_code = next_hash_code
    end
    
    typesig { [] }
    # Returns the value in the current thread's copy of this
    # thread-local variable.  If the variable has no value for the
    # current thread, it is first initialized to the value returned
    # by an invocation of the {@link #initialValue} method.
    # 
    # @return the current thread's value of this thread-local
    def get
      t = JavaThread.current_thread
      map = get_map(t)
      if (!(map).nil?)
        e = map.get_entry(self)
        if (!(e).nil?)
          return e.attr_value
        end
      end
      return set_initial_value
    end
    
    typesig { [] }
    # Variant of set() to establish initialValue. Used instead
    # of set() in case user has overridden the set() method.
    # 
    # @return the initial value
    def set_initial_value
      value = initial_value
      t = JavaThread.current_thread
      map = get_map(t)
      if (!(map).nil?)
        map.set(self, value)
      else
        create_map(t, value)
      end
      return value
    end
    
    typesig { [Object] }
    # Sets the current thread's copy of this thread-local variable
    # to the specified value.  Most subclasses will have no need to
    # override this method, relying solely on the {@link #initialValue}
    # method to set the values of thread-locals.
    # 
    # @param value the value to be stored in the current thread's copy of
    # this thread-local.
    def set(value)
      t = JavaThread.current_thread
      map = get_map(t)
      if (!(map).nil?)
        map.set(self, value)
      else
        create_map(t, value)
      end
    end
    
    typesig { [] }
    # Removes the current thread's value for this thread-local
    # variable.  If this thread-local variable is subsequently
    # {@linkplain #get read} by the current thread, its value will be
    # reinitialized by invoking its {@link #initialValue} method,
    # unless its value is {@linkplain #set set} by the current thread
    # in the interim.  This may result in multiple invocations of the
    # <tt>initialValue</tt> method in the current thread.
    # 
    # @since 1.5
    def remove
      m = get_map(JavaThread.current_thread)
      if (!(m).nil?)
        m.remove(self)
      end
    end
    
    typesig { [JavaThread] }
    # Get the map associated with a ThreadLocal. Overridden in
    # InheritableThreadLocal.
    # 
    # @param  t the current thread
    # @return the map
    def get_map(t)
      return t.attr_thread_locals
    end
    
    typesig { [JavaThread, Object] }
    # Create the map associated with a ThreadLocal. Overridden in
    # InheritableThreadLocal.
    # 
    # @param t the current thread
    # @param firstValue value for the initial entry of the map
    # @param map the map to store.
    def create_map(t, first_value)
      t.attr_thread_locals = ThreadLocalMap.new(self, first_value)
    end
    
    class_module.module_eval {
      typesig { [ThreadLocalMap] }
      # Factory method to create map of inherited thread locals.
      # Designed to be called only from Thread constructor.
      # 
      # @param  parentMap the map associated with parent thread
      # @return a map containing the parent's inheritable bindings
      def create_inherited_map(parent_map)
        return ThreadLocalMap.new(parent_map)
      end
    }
    
    typesig { [Object] }
    # Method childValue is visibly defined in subclass
    # InheritableThreadLocal, but is internally defined here for the
    # sake of providing createInheritedMap factory method without
    # needing to subclass the map class in InheritableThreadLocal.
    # This technique is preferable to the alternative of embedding
    # instanceof tests in methods.
    def child_value(parent_value)
      raise UnsupportedOperationException.new
    end
    
    class_module.module_eval {
      # ThreadLocalMap is a customized hash map suitable only for
      # maintaining thread local values. No operations are exported
      # outside of the ThreadLocal class. The class is package private to
      # allow declaration of fields in class Thread.  To help deal with
      # very large and long-lived usages, the hash table entries use
      # WeakReferences for keys. However, since reference queues are not
      # used, stale entries are guaranteed to be removed only when
      # the table starts running out of space.
      const_set_lazy(:ThreadLocalMap) { Class.new do
        include_class_members ThreadLocal
        
        class_module.module_eval {
          # The entries in this hash map extend WeakReference, using
          # its main ref field as the key (which is always a
          # ThreadLocal object).  Note that null keys (i.e. entry.get()
          # == null) mean that the key is no longer referenced, so the
          # entry can be expunged from table.  Such entries are referred to
          # as "stale entries" in the code that follows.
          const_set_lazy(:Entry) { Class.new(WeakReference) do
            include_class_members ThreadLocalMap
            
            # The value associated with this ThreadLocal.
            attr_accessor :value
            alias_method :attr_value, :value
            undef_method :value
            alias_method :attr_value=, :value=
            undef_method :value=
            
            typesig { [ThreadLocal, Object] }
            def initialize(k, v)
              @value = nil
              super(k)
              @value = v
            end
            
            private
            alias_method :initialize__entry, :initialize
          end }
          
          # The initial capacity -- MUST be a power of two.
          const_set_lazy(:INITIAL_CAPACITY) { 16 }
          const_attr_reader  :INITIAL_CAPACITY
        }
        
        # The table, resized as necessary.
        # table.length MUST always be a power of two.
        attr_accessor :table
        alias_method :attr_table, :table
        undef_method :table
        alias_method :attr_table=, :table=
        undef_method :table=
        
        # The number of entries in the table.
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        # The next size value at which to resize.
        attr_accessor :threshold
        alias_method :attr_threshold, :threshold
        undef_method :threshold
        alias_method :attr_threshold=, :threshold=
        undef_method :threshold=
        
        typesig { [::Java::Int] }
        # Default to 0
        # 
        # Set the resize threshold to maintain at worst a 2/3 load factor.
        def set_threshold(len)
          @threshold = len * 2 / 3
        end
        
        class_module.module_eval {
          typesig { [::Java::Int, ::Java::Int] }
          # Increment i modulo len.
          def next_index(i, len)
            return ((i + 1 < len) ? i + 1 : 0)
          end
          
          typesig { [::Java::Int, ::Java::Int] }
          # Decrement i modulo len.
          def prev_index(i, len)
            return ((i - 1 >= 0) ? i - 1 : len - 1)
          end
        }
        
        typesig { [ThreadLocal, Object] }
        # Construct a new map initially containing (firstKey, firstValue).
        # ThreadLocalMaps are constructed lazily, so we only create
        # one when we have at least one entry to put in it.
        def initialize(first_key, first_value)
          @table = nil
          @size = 0
          @threshold = 0
          @table = Array.typed(Entry).new(self.class::INITIAL_CAPACITY) { nil }
          i = first_key.attr_thread_local_hash_code & (self.class::INITIAL_CAPACITY - 1)
          @table[i] = Entry.new(first_key, first_value)
          @size = 1
          set_threshold(self.class::INITIAL_CAPACITY)
        end
        
        typesig { [ThreadLocalMap] }
        # Construct a new map including all Inheritable ThreadLocals
        # from given parent map. Called only by createInheritedMap.
        # 
        # @param parentMap the map associated with parent thread.
        def initialize(parent_map)
          @table = nil
          @size = 0
          @threshold = 0
          parent_table = parent_map.attr_table
          len = parent_table.attr_length
          set_threshold(len)
          @table = Array.typed(Entry).new(len) { nil }
          j = 0
          while j < len
            e = parent_table[j]
            if (!(e).nil?)
              key = e.get
              if (!(key).nil?)
                value = key.child_value(e.attr_value)
                c = Entry.new(key, value)
                h = key.attr_thread_local_hash_code & (len - 1)
                while (!(@table[h]).nil?)
                  h = next_index(h, len)
                end
                @table[h] = c
                @size += 1
              end
            end
            j += 1
          end
        end
        
        typesig { [ThreadLocal] }
        # Get the entry associated with key.  This method
        # itself handles only the fast path: a direct hit of existing
        # key. It otherwise relays to getEntryAfterMiss.  This is
        # designed to maximize performance for direct hits, in part
        # by making this method readily inlinable.
        # 
        # @param  key the thread local object
        # @return the entry associated with key, or null if no such
        def get_entry(key)
          i = key.attr_thread_local_hash_code & (@table.attr_length - 1)
          e = @table[i]
          if (!(e).nil? && (e.get).equal?(key))
            return e
          else
            return get_entry_after_miss(key, i, e)
          end
        end
        
        typesig { [ThreadLocal, ::Java::Int, Entry] }
        # Version of getEntry method for use when key is not found in
        # its direct hash slot.
        # 
        # @param  key the thread local object
        # @param  i the table index for key's hash code
        # @param  e the entry at table[i]
        # @return the entry associated with key, or null if no such
        def get_entry_after_miss(key, i, e)
          tab = @table
          len = tab.attr_length
          while (!(e).nil?)
            k = e.get
            if ((k).equal?(key))
              return e
            end
            if ((k).nil?)
              expunge_stale_entry(i)
            else
              i = next_index(i, len)
            end
            e = tab[i]
          end
          return nil
        end
        
        typesig { [ThreadLocal, Object] }
        # Set the value associated with key.
        # 
        # @param key the thread local object
        # @param value the value to be set
        def set(key, value)
          # We don't use a fast path as with get() because it is at
          # least as common to use set() to create new entries as
          # it is to replace existing ones, in which case, a fast
          # path would fail more often than not.
          tab = @table
          len = tab.attr_length
          i = key.attr_thread_local_hash_code & (len - 1)
          e = tab[i]
          while !(e).nil?
            k = e.get
            if ((k).equal?(key))
              e.attr_value = value
              return
            end
            if ((k).nil?)
              replace_stale_entry(key, value, i)
              return
            end
            e = tab[i = next_index(i, len)]
          end
          tab[i] = Entry.new(key, value)
          sz = (@size += 1)
          if (!clean_some_slots(i, sz) && sz >= @threshold)
            rehash
          end
        end
        
        typesig { [ThreadLocal] }
        # Remove the entry for key.
        def remove(key)
          tab = @table
          len = tab.attr_length
          i = key.attr_thread_local_hash_code & (len - 1)
          e = tab[i]
          while !(e).nil?
            if ((e.get).equal?(key))
              e.clear
              expunge_stale_entry(i)
              return
            end
            e = tab[i = next_index(i, len)]
          end
        end
        
        typesig { [ThreadLocal, Object, ::Java::Int] }
        # Replace a stale entry encountered during a set operation
        # with an entry for the specified key.  The value passed in
        # the value parameter is stored in the entry, whether or not
        # an entry already exists for the specified key.
        # 
        # As a side effect, this method expunges all stale entries in the
        # "run" containing the stale entry.  (A run is a sequence of entries
        # between two null slots.)
        # 
        # @param  key the key
        # @param  value the value to be associated with key
        # @param  staleSlot index of the first stale entry encountered while
        # searching for key.
        def replace_stale_entry(key, value, stale_slot)
          tab = @table
          len = tab.attr_length
          e = nil
          # Back up to check for prior stale entry in current run.
          # We clean out whole runs at a time to avoid continual
          # incremental rehashing due to garbage collector freeing
          # up refs in bunches (i.e., whenever the collector runs).
          slot_to_expunge = stale_slot
          i = prev_index(stale_slot, len)
          while !((e = tab[i])).nil?
            if ((e.get).nil?)
              slot_to_expunge = i
            end
            i = prev_index(i, len)
          end
          # Find either the key or trailing null slot of run, whichever
          # occurs first
          i_ = next_index(stale_slot, len)
          while !((e = tab[i_])).nil?
            k = e.get
            # If we find key, then we need to swap it
            # with the stale entry to maintain hash table order.
            # The newly stale slot, or any other stale slot
            # encountered above it, can then be sent to expungeStaleEntry
            # to remove or rehash all of the other entries in run.
            if ((k).equal?(key))
              e.attr_value = value
              tab[i_] = tab[stale_slot]
              tab[stale_slot] = e
              # Start expunge at preceding stale entry if it exists
              if ((slot_to_expunge).equal?(stale_slot))
                slot_to_expunge = i_
              end
              clean_some_slots(expunge_stale_entry(slot_to_expunge), len)
              return
            end
            # If we didn't find stale entry on backward scan, the
            # first stale entry seen while scanning for key is the
            # first still present in the run.
            if ((k).nil? && (slot_to_expunge).equal?(stale_slot))
              slot_to_expunge = i_
            end
            i_ = next_index(i_, len)
          end
          # If key not found, put new entry in stale slot
          tab[stale_slot].attr_value = nil
          tab[stale_slot] = Entry.new(key, value)
          # If there are any other stale entries in run, expunge them
          if (!(slot_to_expunge).equal?(stale_slot))
            clean_some_slots(expunge_stale_entry(slot_to_expunge), len)
          end
        end
        
        typesig { [::Java::Int] }
        # Expunge a stale entry by rehashing any possibly colliding entries
        # lying between staleSlot and the next null slot.  This also expunges
        # any other stale entries encountered before the trailing null.  See
        # Knuth, Section 6.4
        # 
        # @param staleSlot index of slot known to have null key
        # @return the index of the next null slot after staleSlot
        # (all between staleSlot and this slot will have been checked
        # for expunging).
        def expunge_stale_entry(stale_slot)
          tab = @table
          len = tab.attr_length
          # expunge entry at staleSlot
          tab[stale_slot].attr_value = nil
          tab[stale_slot] = nil
          @size -= 1
          # Rehash until we encounter null
          e = nil
          i = 0
          i = next_index(stale_slot, len)
          while !((e = tab[i])).nil?
            k = e.get
            if ((k).nil?)
              e.attr_value = nil
              tab[i] = nil
              @size -= 1
            else
              h = k.attr_thread_local_hash_code & (len - 1)
              if (!(h).equal?(i))
                tab[i] = nil
                # Unlike Knuth 6.4 Algorithm R, we must scan until
                # null because multiple entries could have been stale.
                while (!(tab[h]).nil?)
                  h = next_index(h, len)
                end
                tab[h] = e
              end
            end
            i = next_index(i, len)
          end
          return i
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Heuristically scan some cells looking for stale entries.
        # This is invoked when either a new element is added, or
        # another stale one has been expunged. It performs a
        # logarithmic number of scans, as a balance between no
        # scanning (fast but retains garbage) and a number of scans
        # proportional to number of elements, that would find all
        # garbage but would cause some insertions to take O(n) time.
        # 
        # @param i a position known NOT to hold a stale entry. The
        # scan starts at the element after i.
        # 
        # @param n scan control: <tt>log2(n)</tt> cells are scanned,
        # unless a stale entry is found, in which case
        # <tt>log2(table.length)-1</tt> additional cells are scanned.
        # When called from insertions, this parameter is the number
        # of elements, but when from replaceStaleEntry, it is the
        # table length. (Note: all this could be changed to be either
        # more or less aggressive by weighting n instead of just
        # using straight log n. But this version is simple, fast, and
        # seems to work well.)
        # 
        # @return true if any stale entries have been removed.
        def clean_some_slots(i, n)
          removed = false
          tab = @table
          len = tab.attr_length
          begin
            i = next_index(i, len)
            e = tab[i]
            if (!(e).nil? && (e.get).nil?)
              n = len
              removed = true
              i = expunge_stale_entry(i)
            end
          end while (!((n >>= 1)).equal?(0))
          return removed
        end
        
        typesig { [] }
        # Re-pack and/or re-size the table. First scan the entire
        # table removing stale entries. If this doesn't sufficiently
        # shrink the size of the table, double the table size.
        def rehash
          expunge_stale_entries
          # Use lower threshold for doubling to avoid hysteresis
          if (@size >= @threshold - @threshold / 4)
            resize
          end
        end
        
        typesig { [] }
        # Double the capacity of the table.
        def resize
          old_tab = @table
          old_len = old_tab.attr_length
          new_len = old_len * 2
          new_tab = Array.typed(Entry).new(new_len) { nil }
          count = 0
          j = 0
          while j < old_len
            e = old_tab[j]
            if (!(e).nil?)
              k = e.get
              if ((k).nil?)
                e.attr_value = nil # Help the GC
              else
                h = k.attr_thread_local_hash_code & (new_len - 1)
                while (!(new_tab[h]).nil?)
                  h = next_index(h, new_len)
                end
                new_tab[h] = e
                count += 1
              end
            end
            (j += 1)
          end
          set_threshold(new_len)
          @size = count
          @table = new_tab
        end
        
        typesig { [] }
        # Expunge all stale entries in the table.
        def expunge_stale_entries
          tab = @table
          len = tab.attr_length
          j = 0
          while j < len
            e = tab[j]
            if (!(e).nil? && (e.get).nil?)
              expunge_stale_entry(j)
            end
            j += 1
          end
        end
        
        private
        alias_method :initialize__thread_local_map, :initialize
      end }
    }
    
    private
    alias_method :initialize__thread_local, :initialize
  end
  
end
