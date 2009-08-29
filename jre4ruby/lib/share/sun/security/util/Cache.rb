require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module CacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include ::Java::Util
      include ::Java::Lang::Ref
    }
  end
  
  # Abstract base class and factory for caches. A cache is a key-value mapping.
  # It has properties that make it more suitable for caching than a Map.
  # 
  # The factory methods can be used to obtain two different implementations.
  # They have the following properties:
  # 
  # . keys and values reside in memory
  # 
  # . keys and values must be non-null
  # 
  # . maximum size. Replacements are made in LRU order.
  # 
  # . optional lifetime, specified in seconds.
  # 
  # . save for concurrent use by multiple threads
  # 
  # . values are held by either standard references or via SoftReferences.
  # SoftReferences have the advantage that they are automatically cleared
  # by the garbage collector in response to memory demand. This makes it
  # possible to simple set the maximum size to a very large value and let
  # the GC automatically size the cache dynamically depending on the
  # amount of available memory.
  # 
  # However, note that because of the way SoftReferences are implemented in
  # HotSpot at the moment, this may not work perfectly as it clears them fairly
  # eagerly. Performance may be improved if the Java heap size is set to larger
  # value using e.g. java -ms64M -mx128M foo.Test
  # 
  # Cache sizing: the memory cache is implemented on top of a LinkedHashMap.
  # In its current implementation, the number of buckets (NOT entries) in
  # (Linked)HashMaps is always a power of two. It is recommended to set the
  # maximum cache size to value that uses those buckets fully. For example,
  # if a cache with somewhere between 500 and 1000 entries is desired, a
  # maximum size of 750 would be a good choice: try 1024 buckets, with a
  # load factor of 0.75f, the number of entries can be calculated as
  # buckets / 4 * 3. As mentioned above, with a SoftReference cache, it is
  # generally reasonable to set the size to a fairly large value.
  # 
  # @author Andreas Sterbenz
  class Cache 
    include_class_members CacheImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    typesig { [] }
    # Return the number of currently valid entries in the cache.
    def size
      raise NotImplementedError
    end
    
    typesig { [] }
    # Remove all entries from the cache.
    def clear
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Add an entry to the cache.
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Get a value from the cache.
    def get(key)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Remove an entry from the cache.
    def remove(key)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Return a new memory cache with the specified maximum size, unlimited
      # lifetime for entries, with the values held by SoftReferences.
      def new_soft_memory_cache(size)
        return MemoryCache.new(true, size)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Return a new memory cache with the specified maximum size, the
      # specified maximum lifetime (in seconds), with the values held
      # by SoftReferences.
      def new_soft_memory_cache(size, timeout)
        return MemoryCache.new(true, size, timeout)
      end
      
      typesig { [::Java::Int] }
      # Return a new memory cache with the specified maximum size, unlimited
      # lifetime for entries, with the values held by standard references.
      def new_hard_memory_cache(size)
        return MemoryCache.new(false, size)
      end
      
      typesig { [] }
      # Return a dummy cache that does nothing.
      def new_null_cache
        return NullCache::INSTANCE
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Return a new memory cache with the specified maximum size, the
      # specified maximum lifetime (in seconds), with the values held
      # by standard references.
      def new_hard_memory_cache(size, timeout)
        return MemoryCache.new(false, size, timeout)
      end
      
      # Utility class that wraps a byte array and implements the equals()
      # and hashCode() contract in a way suitable for Maps and caches.
      const_set_lazy(:EqualByteArray) { Class.new do
        include_class_members Cache
        
        attr_accessor :b
        alias_method :attr_b, :b
        undef_method :b
        alias_method :attr_b=, :b=
        undef_method :b=
        
        attr_accessor :hash
        alias_method :attr_hash, :hash
        undef_method :hash
        alias_method :attr_hash=, :hash=
        undef_method :hash=
        
        typesig { [Array.typed(::Java::Byte)] }
        def initialize(b)
          @b = nil
          @hash = 0
          @b = b
        end
        
        typesig { [] }
        def hash_code
          h = @hash
          if ((h).equal?(0))
            h = @b.attr_length + 1
            i = 0
            while i < @b.attr_length
              h += (@b[i] & 0xff) * 37
              i += 1
            end
            @hash = h
          end
          return h
        end
        
        typesig { [Object] }
        def ==(obj)
          if ((self).equal?(obj))
            return true
          end
          if ((obj.is_a?(self.class::EqualByteArray)).equal?(false))
            return false
          end
          other = obj
          return (Arrays == @b)
        end
        
        private
        alias_method :initialize__equal_byte_array, :initialize
      end }
    }
    
    private
    alias_method :initialize__cache, :initialize
  end
  
  class NullCache < CacheImports.const_get :Cache
    include_class_members CacheImports
    
    class_module.module_eval {
      const_set_lazy(:INSTANCE) { NullCache.new }
      const_attr_reader  :INSTANCE
    }
    
    typesig { [] }
    def initialize
      super()
      # empty
    end
    
    typesig { [] }
    def size
      return 0
    end
    
    typesig { [] }
    def clear
      # empty
    end
    
    typesig { [Object, Object] }
    def put(key, value)
      # empty
    end
    
    typesig { [Object] }
    def get(key)
      return nil
    end
    
    typesig { [Object] }
    def remove(key)
      # empty
    end
    
    private
    alias_method :initialize__null_cache, :initialize
  end
  
  class MemoryCache < CacheImports.const_get :Cache
    include_class_members CacheImports
    
    class_module.module_eval {
      const_set_lazy(:LOAD_FACTOR) { 0.75 }
      const_attr_reader  :LOAD_FACTOR
      
      # XXXX
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
    }
    
    attr_accessor :cache_map
    alias_method :attr_cache_map, :cache_map
    undef_method :cache_map
    alias_method :attr_cache_map=, :cache_map=
    undef_method :cache_map=
    
    attr_accessor :max_size
    alias_method :attr_max_size, :max_size
    undef_method :max_size
    alias_method :attr_max_size=, :max_size=
    undef_method :max_size=
    
    attr_accessor :lifetime
    alias_method :attr_lifetime, :lifetime
    undef_method :lifetime
    alias_method :attr_lifetime=, :lifetime=
    undef_method :lifetime=
    
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    typesig { [::Java::Boolean, ::Java::Int] }
    def initialize(soft, max_size)
      initialize__memory_cache(soft, max_size, 0)
    end
    
    typesig { [::Java::Boolean, ::Java::Int, ::Java::Int] }
    def initialize(soft, max_size, lifetime)
      @cache_map = nil
      @max_size = 0
      @lifetime = 0
      @queue = nil
      super()
      @max_size = max_size
      @lifetime = lifetime * 1000
      @queue = soft ? ReferenceQueue.new : nil
      buckets = RJava.cast_to_int((max_size / LOAD_FACTOR)) + 1
      @cache_map = LinkedHashMap.new(buckets, LOAD_FACTOR, true)
    end
    
    typesig { [] }
    # Empty the reference queue and remove all corresponding entries
    # from the cache.
    # 
    # This method should be called at the beginning of each public
    # method.
    def empty_queue
      if ((@queue).nil?)
        return
      end
      start_size = @cache_map.size
      while (true)
        entry = @queue.poll
        if ((entry).nil?)
          break
        end
        key = entry.get_key
        if ((key).nil?)
          # key is null, entry has already been removed
          next
        end
        current_entry = @cache_map.remove(key)
        # check if the entry in the map corresponds to the expired
        # entry. If not, readd the entry
        if ((!(current_entry).nil?) && (!(entry).equal?(current_entry)))
          @cache_map.put(key, current_entry)
        end
      end
      if (DEBUG)
        end_size = @cache_map.size
        if (!(start_size).equal?(end_size))
          System.out.println("*** Expunged " + RJava.cast_to_string((start_size - end_size)) + " entries, " + RJava.cast_to_string(end_size) + " entries left")
        end
      end
    end
    
    typesig { [] }
    # Scan all entries and remove all expired ones.
    def expunge_expired_entries
      empty_queue
      if ((@lifetime).equal?(0))
        return
      end
      cnt = 0
      time = System.current_time_millis
      t = @cache_map.values.iterator
      while t.has_next
        entry = t.next_
        if ((entry.is_valid(time)).equal?(false))
          t.remove
          cnt += 1
        end
      end
      if (DEBUG)
        if (!(cnt).equal?(0))
          System.out.println("Removed " + RJava.cast_to_string(cnt) + " expired entries, remaining " + RJava.cast_to_string(@cache_map.size))
        end
      end
    end
    
    typesig { [] }
    def size
      synchronized(self) do
        expunge_expired_entries
        return @cache_map.size
      end
    end
    
    typesig { [] }
    def clear
      synchronized(self) do
        if (!(@queue).nil?)
          # if this is a SoftReference cache, first invalidate() all
          # entries so that GC does not have to enqueue them
          @cache_map.values.each do |entry|
            entry.invalidate
          end
          while (!(@queue.poll).nil?)
          end
        end
        @cache_map.clear
      end
    end
    
    typesig { [Object, Object] }
    def put(key, value)
      synchronized(self) do
        empty_queue
        expiration_time = ((@lifetime).equal?(0)) ? 0 : System.current_time_millis + @lifetime
        new_entry_ = new_entry(key, value, expiration_time, @queue)
        old_entry = @cache_map.put(key, new_entry_)
        if (!(old_entry).nil?)
          old_entry.invalidate
          return
        end
        if (@cache_map.size > @max_size)
          expunge_expired_entries
          if (@cache_map.size > @max_size)
            # still too large?
            t = @cache_map.values.iterator
            lru_entry = t.next_
            if (DEBUG)
              System.out.println("** Overflow removal " + RJava.cast_to_string(lru_entry.get_key) + " | " + RJava.cast_to_string(lru_entry.get_value))
            end
            t.remove
            lru_entry.invalidate
          end
        end
      end
    end
    
    typesig { [Object] }
    def get(key)
      synchronized(self) do
        empty_queue
        entry = @cache_map.get(key)
        if ((entry).nil?)
          return nil
        end
        time = ((@lifetime).equal?(0)) ? 0 : System.current_time_millis
        if ((entry.is_valid(time)).equal?(false))
          if (DEBUG)
            System.out.println("Ignoring expired entry")
          end
          @cache_map.remove(key)
          return nil
        end
        return entry.get_value
      end
    end
    
    typesig { [Object] }
    def remove(key)
      synchronized(self) do
        empty_queue
        entry = @cache_map.remove(key)
        if (!(entry).nil?)
          entry.invalidate
        end
      end
    end
    
    typesig { [Object, Object, ::Java::Long, ReferenceQueue] }
    def new_entry(key, value, expiration_time, queue)
      if (!(queue).nil?)
        return SoftCacheEntry.new(key, value, expiration_time, queue)
      else
        return HardCacheEntry.new(key, value, expiration_time)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:CacheEntry) { Module.new do
        include_class_members MemoryCache
        
        typesig { [::Java::Long] }
        def is_valid(current_time)
          raise NotImplementedError
        end
        
        typesig { [] }
        def invalidate
          raise NotImplementedError
        end
        
        typesig { [] }
        def get_key
          raise NotImplementedError
        end
        
        typesig { [] }
        def get_value
          raise NotImplementedError
        end
      end }
      
      const_set_lazy(:HardCacheEntry) { Class.new do
        include_class_members MemoryCache
        include CacheEntry
        
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
        
        attr_accessor :expiration_time
        alias_method :attr_expiration_time, :expiration_time
        undef_method :expiration_time
        alias_method :attr_expiration_time=, :expiration_time=
        undef_method :expiration_time=
        
        typesig { [Object, Object, ::Java::Long] }
        def initialize(key, value, expiration_time)
          @key = nil
          @value = nil
          @expiration_time = 0
          @key = key
          @value = value
          @expiration_time = expiration_time
        end
        
        typesig { [] }
        def get_key
          return @key
        end
        
        typesig { [] }
        def get_value
          return @value
        end
        
        typesig { [::Java::Long] }
        def is_valid(current_time)
          valid = (current_time <= @expiration_time)
          if ((valid).equal?(false))
            invalidate
          end
          return valid
        end
        
        typesig { [] }
        def invalidate
          @key = nil
          @value = nil
          @expiration_time = -1
        end
        
        private
        alias_method :initialize__hard_cache_entry, :initialize
      end }
      
      const_set_lazy(:SoftCacheEntry) { Class.new(SoftReference) do
        include_class_members MemoryCache
        overload_protected {
          include CacheEntry
        }
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :expiration_time
        alias_method :attr_expiration_time, :expiration_time
        undef_method :expiration_time
        alias_method :attr_expiration_time=, :expiration_time=
        undef_method :expiration_time=
        
        typesig { [Object, Object, ::Java::Long, class_self::ReferenceQueue] }
        def initialize(key, value, expiration_time, queue)
          @key = nil
          @expiration_time = 0
          super(value, queue)
          @key = key
          @expiration_time = expiration_time
        end
        
        typesig { [] }
        def get_key
          return @key
        end
        
        typesig { [] }
        def get_value
          return get
        end
        
        typesig { [::Java::Long] }
        def is_valid(current_time)
          valid = (current_time <= @expiration_time) && (!(get).nil?)
          if ((valid).equal?(false))
            invalidate
          end
          return valid
        end
        
        typesig { [] }
        def invalidate
          clear
          @key = nil
          @expiration_time = -1
        end
        
        private
        alias_method :initialize__soft_cache_entry, :initialize
      end }
    }
    
    private
    alias_method :initialize__memory_cache, :initialize
  end
  
end
