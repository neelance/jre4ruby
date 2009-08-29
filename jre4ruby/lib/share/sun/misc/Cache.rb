require "rjava"

# Copyright 1995-1996 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module CacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Dictionary
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # Caches the collision list.
  class CacheEntry < CacheImports.const_get :Ref
    include_class_members CacheImports
    
    attr_accessor :hash
    alias_method :attr_hash, :hash
    undef_method :hash
    alias_method :attr_hash=, :hash=
    undef_method :hash=
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    typesig { [] }
    def reconstitute
      return nil
    end
    
    typesig { [] }
    def initialize
      @hash = 0
      @key = nil
      @next = nil
      super()
    end
    
    private
    alias_method :initialize__cache_entry, :initialize
  end
  
  # The Cache class. Maps keys to values. Any object can be used as
  # a key and/or value.  This is very similar to the Hashtable
  # class, except that after putting an object into the Cache,
  # it is not guaranteed that a subsequent get will return it.
  # The Cache will automatically remove entries if memory is
  # getting tight and if the entry is not referenced from outside
  # the Cache.<p>
  # 
  # To sucessfully store and retrieve objects from a hash table the
  # object used as the key must implement the hashCode() and equals()
  # methods.<p>
  # 
  # This example creates a Cache of numbers. It uses the names of
  # the numbers as keys:
  # <pre>
  # Cache numbers = new Cache();
  # numbers.put("one", new Integer(1));
  # numbers.put("two", new Integer(1));
  # numbers.put("three", new Integer(1));
  # </pre>
  # To retrieve a number use:
  # <pre>
  # Integer n = (Integer)numbers.get("two");
  # if (n != null) {
  # System.out.println("two = " + n);
  # }
  # </pre>
  # 
  # @see java.lang.Object#hashCode
  # @see java.lang.Object#equals
  # @see sun.misc.Ref
  class Cache < CacheImports.const_get :Dictionary
    include_class_members CacheImports
    
    # The hash table data.
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    # The total number of entries in the hash table.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # Rehashes the table when count exceeds this threshold.
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    # The load factor for the hashtable.
    attr_accessor :load_factor
    alias_method :attr_load_factor, :load_factor
    undef_method :load_factor
    alias_method :attr_load_factor=, :load_factor=
    undef_method :load_factor=
    
    typesig { [::Java::Int, ::Java::Float] }
    def init(initial_capacity, load_factor)
      if ((initial_capacity <= 0) || (load_factor <= 0.0))
        raise IllegalArgumentException.new
      end
      @load_factor = load_factor
      @table = Array.typed(CacheEntry).new(initial_capacity) { nil }
      @threshold = RJava.cast_to_int((initial_capacity * load_factor))
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # Constructs a new, empty Cache with the specified initial
    # capacity and the specified load factor.
    # @param initialCapacity the initial number of buckets
    # @param loadFactor a number between 0.0 and 1.0, it defines
    # the threshold for rehashing the Cache into
    # a bigger one.
    # @exception IllegalArgumentException If the initial capacity
    # is less than or equal to zero.
    # @exception IllegalArgumentException If the load factor is
    # less than or equal to zero.
    def initialize(initial_capacity, load_factor)
      @table = nil
      @count = 0
      @threshold = 0
      @load_factor = 0.0
      super()
      init(initial_capacity, load_factor)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new, empty Cache with the specified initial
    # capacity.
    # @param initialCapacity the initial number of buckets
    def initialize(initial_capacity)
      @table = nil
      @count = 0
      @threshold = 0
      @load_factor = 0.0
      super()
      init(initial_capacity, 0.75)
    end
    
    typesig { [] }
    # Constructs a new, empty Cache. A default capacity and load factor
    # is used. Note that the Cache will automatically grow when it gets
    # full.
    def initialize
      @table = nil
      @count = 0
      @threshold = 0
      @load_factor = 0.0
      super()
      begin
        init(101, 0.75)
      rescue IllegalArgumentException => ex
        # This should never happen
        raise JavaError.new("panic")
      end
    end
    
    typesig { [] }
    # Returns the number of elements contained within the Cache.
    def size
      return @count
    end
    
    typesig { [] }
    # Returns true if the Cache contains no elements.
    def is_empty
      return (@count).equal?(0)
    end
    
    typesig { [] }
    # Returns an enumeration of the Cache's keys.
    # @see Cache#elements
    # @see Enumeration
    def keys
      synchronized(self) do
        return CacheEnumerator.new(@table, true)
      end
    end
    
    typesig { [] }
    # Returns an enumeration of the elements. Use the Enumeration methods
    # on the returned object to fetch the elements sequentially.
    # @see Cache#keys
    # @see Enumeration
    def elements
      synchronized(self) do
        return CacheEnumerator.new(@table, false)
      end
    end
    
    typesig { [Object] }
    # Gets the object associated with the specified key in the Cache.
    # @param key the key in the hash table
    # @returns the element for the key or null if the key
    # is not defined in the hash table.
    # @see Cache#put
    def get(key)
      synchronized(self) do
        tab = @table
        hash = key.hash_code
        index = (hash & 0x7fffffff) % tab.attr_length
        e = tab[index]
        while !(e).nil?
          if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
            return e.check
          end
          e = e.attr_next
        end
        return nil
      end
    end
    
    typesig { [] }
    # Rehashes the contents of the table into a bigger table.
    # This is method is called automatically when the Cache's
    # size exceeds the threshold.
    def rehash
      old_capacity = @table.attr_length
      old_table = @table
      new_capacity = old_capacity * 2 + 1
      new_table = Array.typed(CacheEntry).new(new_capacity) { nil }
      @threshold = RJava.cast_to_int((new_capacity * @load_factor))
      @table = new_table
      # System.out.println("rehash old=" + oldCapacity + ", new=" +
      # newCapacity + ", thresh=" + threshold + ", count=" + count);
      i = old_capacity
      while ((i -= 1) + 1) > 0
        old = old_table[i]
        while !(old).nil?
          e = old
          old = old.attr_next
          if (!(e.check).nil?)
            index = (e.attr_hash & 0x7fffffff) % new_capacity
            e.attr_next = new_table[index]
            new_table[index] = e
          else
            @count -= 1
          end
        end
      end
    end
    
    typesig { [Object, Object] }
    # Puts the specified element into the Cache, using the specified
    # key.  The element may be retrieved by doing a get() with the same
    # key.  The key and the element cannot be null.
    # @param key the specified hashtable key
    # @param value the specified element
    # @return the old value of the key, or null if it did not have one.
    # @exception NullPointerException If the value of the specified
    # element is null.
    # @see Cache#get
    def put(key, value)
      synchronized(self) do
        # Make sure the value is not null
        if ((value).nil?)
          raise NullPointerException.new
        end
        # Makes sure the key is not already in the cache.
        tab = @table
        hash = key.hash_code
        index = (hash & 0x7fffffff) % tab.attr_length
        ne = nil
        e = tab[index]
        while !(e).nil?
          if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
            old = e.check
            e.set_thing(value)
            return old
          else
            if ((e.check).nil?)
              ne = e
            end
          end
          e = e.attr_next
        end
        if (@count >= @threshold)
          # Rehash the table if the threshold is exceeded
          rehash
          return put(key, value)
        end
        # Creates the new entry.
        if ((ne).nil?)
          ne = CacheEntry.new
          ne.attr_next = tab[index]
          tab[index] = ne
          @count += 1
        end
        ne.attr_hash = hash
        ne.attr_key = key
        ne.set_thing(value)
        return nil
      end
    end
    
    typesig { [Object] }
    # Removes the element corresponding to the key. Does nothing if the
    # key is not present.
    # @param key the key that needs to be removed
    # @return the value of key, or null if the key was not found.
    def remove(key)
      synchronized(self) do
        tab = @table
        hash = key.hash_code
        index = (hash & 0x7fffffff) % tab.attr_length
        e = tab[index]
        prev = nil
        while !(e).nil?
          if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
            if (!(prev).nil?)
              prev.attr_next = e.attr_next
            else
              tab[index] = e.attr_next
            end
            @count -= 1
            return e.check
          end
          prev = e
          e = e.attr_next
        end
        return nil
      end
    end
    
    private
    alias_method :initialize__cache, :initialize
  end
  
  # A Cache enumerator class.  This class should remain opaque
  # to the client. It will use the Enumeration interface.
  class CacheEnumerator 
    include_class_members CacheImports
    include Enumeration
    
    attr_accessor :keys
    alias_method :attr_keys, :keys
    undef_method :keys
    alias_method :attr_keys=, :keys=
    undef_method :keys=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    attr_accessor :entry
    alias_method :attr_entry, :entry
    undef_method :entry
    alias_method :attr_entry=, :entry=
    undef_method :entry=
    
    typesig { [Array.typed(CacheEntry), ::Java::Boolean] }
    def initialize(table, keys)
      @keys = false
      @index = 0
      @table = nil
      @entry = nil
      @table = table
      @keys = keys
      @index = table.attr_length
    end
    
    typesig { [] }
    def has_more_elements
      while (@index >= 0)
        while (!(@entry).nil?)
          if (!(@entry.check).nil?)
            return true
          else
            @entry = @entry.attr_next
          end
        end
        while ((@index -= 1) >= 0 && ((@entry = @table[@index])).nil?)
        end
      end
      return false
    end
    
    typesig { [] }
    def next_element
      while (@index >= 0)
        if ((@entry).nil?)
          while ((@index -= 1) >= 0 && ((@entry = @table[@index])).nil?)
          end
        end
        if (!(@entry).nil?)
          e = @entry
          @entry = e.attr_next
          if (!(e.check).nil?)
            return @keys ? e.attr_key : e.check
          end
        end
      end
      raise NoSuchElementException.new("CacheEnumerator")
    end
    
    private
    alias_method :initialize__cache_enumerator, :initialize
  end
  
end
