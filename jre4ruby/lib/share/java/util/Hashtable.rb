require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module HashtableImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
    }
  end
  
  # This class implements a hashtable, which maps keys to values. Any
  # non-<code>null</code> object can be used as a key or as a value. <p>
  # 
  # To successfully store and retrieve objects from a hashtable, the
  # objects used as keys must implement the <code>hashCode</code>
  # method and the <code>equals</code> method. <p>
  # 
  # An instance of <code>Hashtable</code> has two parameters that affect its
  # performance: <i>initial capacity</i> and <i>load factor</i>.  The
  # <i>capacity</i> is the number of <i>buckets</i> in the hash table, and the
  # <i>initial capacity</i> is simply the capacity at the time the hash table
  # is created.  Note that the hash table is <i>open</i>: in the case of a "hash
  # collision", a single bucket stores multiple entries, which must be searched
  # sequentially.  The <i>load factor</i> is a measure of how full the hash
  # table is allowed to get before its capacity is automatically increased.
  # The initial capacity and load factor parameters are merely hints to
  # the implementation.  The exact details as to when and whether the rehash
  # method is invoked are implementation-dependent.<p>
  # 
  # Generally, the default load factor (.75) offers a good tradeoff between
  # time and space costs.  Higher values decrease the space overhead but
  # increase the time cost to look up an entry (which is reflected in most
  # <tt>Hashtable</tt> operations, including <tt>get</tt> and <tt>put</tt>).<p>
  # 
  # The initial capacity controls a tradeoff between wasted space and the
  # need for <code>rehash</code> operations, which are time-consuming.
  # No <code>rehash</code> operations will <i>ever</i> occur if the initial
  # capacity is greater than the maximum number of entries the
  # <tt>Hashtable</tt> will contain divided by its load factor.  However,
  # setting the initial capacity too high can waste space.<p>
  # 
  # If many entries are to be made into a <code>Hashtable</code>,
  # creating it with a sufficiently large capacity may allow the
  # entries to be inserted more efficiently than letting it perform
  # automatic rehashing as needed to grow the table. <p>
  # 
  # This example creates a hashtable of numbers. It uses the names of
  # the numbers as keys:
  # <pre>   {@code
  # Hashtable<String, Integer> numbers
  # = new Hashtable<String, Integer>();
  # numbers.put("one", 1);
  # numbers.put("two", 2);
  # numbers.put("three", 3);}</pre>
  # 
  # <p>To retrieve a number, use the following code:
  # <pre>   {@code
  # Integer n = numbers.get("two");
  # if (n != null) {
  # System.out.println("two = " + n);
  # }}</pre>
  # 
  # <p>The iterators returned by the <tt>iterator</tt> method of the collections
  # returned by all of this class's "collection view methods" are
  # <em>fail-fast</em>: if the Hashtable is structurally modified at any time
  # after the iterator is created, in any way except through the iterator's own
  # <tt>remove</tt> method, the iterator will throw a {@link
  # ConcurrentModificationException}.  Thus, in the face of concurrent
  # modification, the iterator fails quickly and cleanly, rather than risking
  # arbitrary, non-deterministic behavior at an undetermined time in the future.
  # The Enumerations returned by Hashtable's keys and elements methods are
  # <em>not</em> fail-fast.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw <tt>ConcurrentModificationException</tt> on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness: <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>As of the Java 2 platform v1.2, this class was retrofitted to
  # implement the {@link Map} interface, making it a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html"> Java
  # Collections Framework</a>.  Unlike the new collection
  # implementations, {@code Hashtable} is synchronized.
  # 
  # @author  Arthur van Hoff
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see     Object#equals(java.lang.Object)
  # @see     Object#hashCode()
  # @see     Hashtable#rehash()
  # @see     Collection
  # @see     Map
  # @see     HashMap
  # @see     TreeMap
  # @since JDK1.0
  class Hashtable < HashtableImports.const_get :Dictionary
    include_class_members HashtableImports
    overload_protected {
      include Map
      include Cloneable
      include Java::Io::Serializable
    }
    
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
    
    # The table is rehashed when its size exceeds this threshold.  (The
    # value of this field is (int)(capacity * loadFactor).)
    # 
    # @serial
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    # The load factor for the hashtable.
    # 
    # @serial
    attr_accessor :load_factor
    alias_method :attr_load_factor, :load_factor
    undef_method :load_factor
    alias_method :attr_load_factor=, :load_factor=
    undef_method :load_factor=
    
    # The number of times this Hashtable has been structurally modified
    # Structural modifications are those that change the number of entries in
    # the Hashtable or otherwise modify its internal structure (e.g.,
    # rehash).  This field is used to make iterators on Collection-views of
    # the Hashtable fail-fast.  (See ConcurrentModificationException).
    attr_accessor :mod_count
    alias_method :attr_mod_count, :mod_count
    undef_method :mod_count
    alias_method :attr_mod_count=, :mod_count=
    undef_method :mod_count=
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 1421746759512286392 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Int, ::Java::Float] }
    # Constructs a new, empty hashtable with the specified initial
    # capacity and the specified load factor.
    # 
    # @param      initialCapacity   the initial capacity of the hashtable.
    # @param      loadFactor        the load factor of the hashtable.
    # @exception  IllegalArgumentException  if the initial capacity is less
    # than zero, or if the load factor is nonpositive.
    def initialize(initial_capacity, load_factor)
      @table = nil
      @count = 0
      @threshold = 0
      @load_factor = 0.0
      @mod_count = 0
      @key_set = nil
      @entry_set = nil
      @values = nil
      super()
      @mod_count = 0
      @key_set = nil
      @entry_set = nil
      @values = nil
      if (initial_capacity < 0)
        raise IllegalArgumentException.new("Illegal Capacity: " + RJava.cast_to_string(initial_capacity))
      end
      if (load_factor <= 0 || Float.is_na_n(load_factor))
        raise IllegalArgumentException.new("Illegal Load: " + RJava.cast_to_string(load_factor))
      end
      if ((initial_capacity).equal?(0))
        initial_capacity = 1
      end
      @load_factor = load_factor
      @table = Array.typed(Entry).new(initial_capacity) { nil }
      @threshold = RJava.cast_to_int((initial_capacity * load_factor))
    end
    
    typesig { [::Java::Int] }
    # Constructs a new, empty hashtable with the specified initial capacity
    # and default load factor (0.75).
    # 
    # @param     initialCapacity   the initial capacity of the hashtable.
    # @exception IllegalArgumentException if the initial capacity is less
    # than zero.
    def initialize(initial_capacity)
      initialize__hashtable(initial_capacity, 0.75)
    end
    
    typesig { [] }
    # Constructs a new, empty hashtable with a default initial capacity (11)
    # and load factor (0.75).
    def initialize
      initialize__hashtable(11, 0.75)
    end
    
    typesig { [Map] }
    # Constructs a new hashtable with the same mappings as the given
    # Map.  The hashtable is created with an initial capacity sufficient to
    # hold the mappings in the given Map and a default load factor (0.75).
    # 
    # @param t the map whose mappings are to be placed in this map.
    # @throws NullPointerException if the specified map is null.
    # @since   1.2
    def initialize(t)
      initialize__hashtable(Math.max(2 * t.size, 11), 0.75)
      put_all(t)
    end
    
    typesig { [] }
    # Returns the number of keys in this hashtable.
    # 
    # @return  the number of keys in this hashtable.
    def size
      synchronized(self) do
        return @count
      end
    end
    
    typesig { [] }
    # Tests if this hashtable maps no keys to values.
    # 
    # @return  <code>true</code> if this hashtable maps no keys to values;
    # <code>false</code> otherwise.
    def is_empty
      synchronized(self) do
        return (@count).equal?(0)
      end
    end
    
    typesig { [] }
    # Returns an enumeration of the keys in this hashtable.
    # 
    # @return  an enumeration of the keys in this hashtable.
    # @see     Enumeration
    # @see     #elements()
    # @see     #keySet()
    # @see     Map
    def keys
      synchronized(self) do
        return self.get_enumeration(KEYS)
      end
    end
    
    typesig { [] }
    # Returns an enumeration of the values in this hashtable.
    # Use the Enumeration methods on the returned object to fetch the elements
    # sequentially.
    # 
    # @return  an enumeration of the values in this hashtable.
    # @see     java.util.Enumeration
    # @see     #keys()
    # @see     #values()
    # @see     Map
    def elements
      synchronized(self) do
        return self.get_enumeration(VALUES)
      end
    end
    
    typesig { [Object] }
    # Tests if some key maps into the specified value in this hashtable.
    # This operation is more expensive than the {@link #containsKey
    # containsKey} method.
    # 
    # <p>Note that this method is identical in functionality to
    # {@link #containsValue containsValue}, (which is part of the
    # {@link Map} interface in the collections framework).
    # 
    # @param      value   a value to search for
    # @return     <code>true</code> if and only if some key maps to the
    # <code>value</code> argument in this hashtable as
    # determined by the <tt>equals</tt> method;
    # <code>false</code> otherwise.
    # @exception  NullPointerException  if the value is <code>null</code>
    def contains(value)
      synchronized(self) do
        if ((value).nil?)
          raise NullPointerException.new
        end
        tab = @table
        i = tab.attr_length
        while ((i -= 1) + 1) > 0
          e = tab[i]
          while !(e).nil?
            if ((e.attr_value == value))
              return true
            end
            e = e.attr_next
          end
        end
        return false
      end
    end
    
    typesig { [Object] }
    # Returns true if this hashtable maps one or more keys to this value.
    # 
    # <p>Note that this method is identical in functionality to {@link
    # #contains contains} (which predates the {@link Map} interface).
    # 
    # @param value value whose presence in this hashtable is to be tested
    # @return <tt>true</tt> if this map maps one or more keys to the
    # specified value
    # @throws NullPointerException  if the value is <code>null</code>
    # @since 1.2
    def contains_value(value)
      return contains(value)
    end
    
    typesig { [Object] }
    # Tests if the specified object is a key in this hashtable.
    # 
    # @param   key   possible key
    # @return  <code>true</code> if and only if the specified object
    # is a key in this hashtable, as determined by the
    # <tt>equals</tt> method; <code>false</code> otherwise.
    # @throws  NullPointerException  if the key is <code>null</code>
    # @see     #contains(Object)
    def contains_key(key)
      synchronized(self) do
        tab = @table
        hash = key.hash_code
        index = (hash & 0x7fffffff) % tab.attr_length
        e = tab[index]
        while !(e).nil?
          if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
            return true
          end
          e = e.attr_next
        end
        return false
      end
    end
    
    typesig { [Object] }
    # Returns the value to which the specified key is mapped,
    # or {@code null} if this map contains no mapping for the key.
    # 
    # <p>More formally, if this map contains a mapping from a key
    # {@code k} to a value {@code v} such that {@code (key.equals(k))},
    # then this method returns {@code v}; otherwise it returns
    # {@code null}.  (There can be at most one such mapping.)
    # 
    # @param key the key whose associated value is to be returned
    # @return the value to which the specified key is mapped, or
    # {@code null} if this map contains no mapping for the key
    # @throws NullPointerException if the specified key is null
    # @see     #put(Object, Object)
    def get(key)
      synchronized(self) do
        tab = @table
        hash = key.hash_code
        index = (hash & 0x7fffffff) % tab.attr_length
        e = tab[index]
        while !(e).nil?
          if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
            return e.attr_value
          end
          e = e.attr_next
        end
        return nil
      end
    end
    
    typesig { [] }
    # Increases the capacity of and internally reorganizes this
    # hashtable, in order to accommodate and access its entries more
    # efficiently.  This method is called automatically when the
    # number of keys in the hashtable exceeds this hashtable's capacity
    # and load factor.
    def rehash
      old_capacity = @table.attr_length
      old_map = @table
      new_capacity = old_capacity * 2 + 1
      new_map = Array.typed(Entry).new(new_capacity) { nil }
      @mod_count += 1
      @threshold = RJava.cast_to_int((new_capacity * @load_factor))
      @table = new_map
      i = old_capacity
      while ((i -= 1) + 1) > 0
        old = old_map[i]
        while !(old).nil?
          e = old
          old = old.attr_next
          index = (e.attr_hash & 0x7fffffff) % new_capacity
          e.attr_next = new_map[index]
          new_map[index] = e
        end
      end
    end
    
    typesig { [Object, Object] }
    # Maps the specified <code>key</code> to the specified
    # <code>value</code> in this hashtable. Neither the key nor the
    # value can be <code>null</code>. <p>
    # 
    # The value can be retrieved by calling the <code>get</code> method
    # with a key that is equal to the original key.
    # 
    # @param      key     the hashtable key
    # @param      value   the value
    # @return     the previous value of the specified key in this hashtable,
    # or <code>null</code> if it did not have one
    # @exception  NullPointerException  if the key or value is
    # <code>null</code>
    # @see     Object#equals(Object)
    # @see     #get(Object)
    def put(key, value)
      synchronized(self) do
        # Make sure the value is not null
        if ((value).nil?)
          raise NullPointerException.new
        end
        # Makes sure the key is not already in the hashtable.
        tab = @table
        hash = key.hash_code
        index = (hash & 0x7fffffff) % tab.attr_length
        e = tab[index]
        while !(e).nil?
          if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
            old = e.attr_value
            e.attr_value = value
            return old
          end
          e = e.attr_next
        end
        @mod_count += 1
        if (@count >= @threshold)
          # Rehash the table if the threshold is exceeded
          rehash
          tab = @table
          index = (hash & 0x7fffffff) % tab.attr_length
        end
        # Creates the new entry.
        e_ = tab[index]
        tab[index] = Entry.new(hash, key, value, e_)
        @count += 1
        return nil
      end
    end
    
    typesig { [Object] }
    # Removes the key (and its corresponding value) from this
    # hashtable. This method does nothing if the key is not in the hashtable.
    # 
    # @param   key   the key that needs to be removed
    # @return  the value to which the key had been mapped in this hashtable,
    # or <code>null</code> if the key did not have a mapping
    # @throws  NullPointerException  if the key is <code>null</code>
    def remove(key)
      synchronized(self) do
        tab = @table
        hash = key.hash_code
        index = (hash & 0x7fffffff) % tab.attr_length
        e = tab[index]
        prev = nil
        while !(e).nil?
          if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
            @mod_count += 1
            if (!(prev).nil?)
              prev.attr_next = e.attr_next
            else
              tab[index] = e.attr_next
            end
            @count -= 1
            old_value = e.attr_value
            e.attr_value = nil
            return old_value
          end
          prev = e
          e = e.attr_next
        end
        return nil
      end
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified map to this hashtable.
    # These mappings will replace any mappings that this hashtable had for any
    # of the keys currently in the specified map.
    # 
    # @param t mappings to be stored in this map
    # @throws NullPointerException if the specified map is null
    # @since 1.2
    def put_all(t)
      synchronized(self) do
        t.entry_set.each do |e|
          put(e.get_key, e.get_value)
        end
      end
    end
    
    typesig { [] }
    # Clears this hashtable so that it contains no keys.
    def clear
      synchronized(self) do
        tab = @table
        @mod_count += 1
        index = tab.attr_length
        while (index -= 1) >= 0
          tab[index] = nil
        end
        @count = 0
      end
    end
    
    typesig { [] }
    # Creates a shallow copy of this hashtable. All the structure of the
    # hashtable itself is copied, but the keys and values are not cloned.
    # This is a relatively expensive operation.
    # 
    # @return  a clone of the hashtable
    def clone
      synchronized(self) do
        begin
          t = super
          t.attr_table = Array.typed(Entry).new(@table.attr_length) { nil }
          i = @table.attr_length
          while ((i -= 1) + 1) > 0
            t.attr_table[i] = (!(@table[i]).nil?) ? @table[i].clone : nil
          end
          t.attr_key_set = nil
          t.attr_entry_set = nil
          t.attr_values = nil
          t.attr_mod_count = 0
          return t
        rescue CloneNotSupportedException => e
          # this shouldn't happen, since we are Cloneable
          raise InternalError.new
        end
      end
    end
    
    typesig { [] }
    # Returns a string representation of this <tt>Hashtable</tt> object
    # in the form of a set of entries, enclosed in braces and separated
    # by the ASCII characters "<tt>,&nbsp;</tt>" (comma and space). Each
    # entry is rendered as the key, an equals sign <tt>=</tt>, and the
    # associated element, where the <tt>toString</tt> method is used to
    # convert the key and element to strings.
    # 
    # @return  a string representation of this hashtable
    def to_s
      synchronized(self) do
        max_ = size - 1
        if ((max_).equal?(-1))
          return "{}"
        end
        sb = StringBuilder.new
        it = entry_set.iterator
        sb.append(Character.new(?{.ord))
        i = 0
        loop do
          e = it.next_
          key = e.get_key
          value = e.get_value
          sb.append((key).equal?(self) ? "(this Map)" : key.to_s)
          sb.append(Character.new(?=.ord))
          sb.append((value).equal?(self) ? "(this Map)" : value.to_s)
          if ((i).equal?(max_))
            return sb.append(Character.new(?}.ord)).to_s
          end
          sb.append(", ")
          i += 1
        end
      end
    end
    
    typesig { [::Java::Int] }
    def get_enumeration(type)
      if ((@count).equal?(0))
        return Collections.empty_enumeration
      else
        return Enumerator.new_local(self, type, false)
      end
    end
    
    typesig { [::Java::Int] }
    def get_iterator(type)
      if ((@count).equal?(0))
        return Collections.empty_iterator
      else
        return Enumerator.new_local(self, type, true)
      end
    end
    
    # Views
    # 
    # Each of these fields are initialized to contain an instance of the
    # appropriate view the first time this view is requested.  The views are
    # stateless, so there's no reason to create more than one of each.
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
    # 
    # @since 1.2
    def key_set
      if ((@key_set).nil?)
        @key_set = Collections.synchronized_set(KeySet.new_local(self), self)
      end
      return @key_set
    end
    
    class_module.module_eval {
      const_set_lazy(:KeySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members Hashtable
        
        typesig { [] }
        def iterator
          return get_iterator(KEYS)
        end
        
        typesig { [] }
        def size
          return self.attr_count
        end
        
        typesig { [Object] }
        def contains(o)
          return contains_key(o)
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
    # @since 1.2
    def entry_set
      if ((@entry_set).nil?)
        @entry_set = Collections.synchronized_set(EntrySet.new_local(self), self)
      end
      return @entry_set
    end
    
    class_module.module_eval {
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members Hashtable
        
        typesig { [] }
        def iterator
          return get_iterator(ENTRIES)
        end
        
        typesig { [self::Map::Entry] }
        def add(o)
          return super(o)
        end
        
        typesig { [Object] }
        def contains(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          entry = o
          key = entry.get_key
          tab = self.attr_table
          hash = key.hash_code
          index = (hash & 0x7fffffff) % tab.attr_length
          e = tab[index]
          while !(e).nil?
            if ((e.attr_hash).equal?(hash) && (e == entry))
              return true
            end
            e = e.attr_next
          end
          return false
        end
        
        typesig { [Object] }
        def remove(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          entry = o
          key = entry.get_key
          tab = self.attr_table
          hash = key.hash_code
          index = (hash & 0x7fffffff) % tab.attr_length
          e = tab[index]
          prev = nil
          while !(e).nil?
            if ((e.attr_hash).equal?(hash) && (e == entry))
              self.attr_mod_count += 1
              if (!(prev).nil?)
                prev.attr_next = e.attr_next
              else
                tab[index] = e.attr_next
              end
              self.attr_count -= 1
              e.attr_value = nil
              return true
            end
            prev = e
            e = e.attr_next
          end
          return false
        end
        
        typesig { [] }
        def size
          return self.attr_count
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
    # 
    # @since 1.2
    def values
      if ((@values).nil?)
        @values = Collections.synchronized_collection(ValueCollection.new_local(self), self)
      end
      return @values
    end
    
    class_module.module_eval {
      const_set_lazy(:ValueCollection) { Class.new(AbstractCollection) do
        extend LocalClass
        include_class_members Hashtable
        
        typesig { [] }
        def iterator
          return get_iterator(VALUES)
        end
        
        typesig { [] }
        def size
          return self.attr_count
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
        alias_method :initialize__value_collection, :initialize
      end }
    }
    
    typesig { [Object] }
    # Comparison and hashing
    # 
    # Compares the specified Object with this Map for equality,
    # as per the definition in the Map interface.
    # 
    # @param  o object to be compared for equality with this hashtable
    # @return true if the specified Object is equal to this Map
    # @see Map#equals(Object)
    # @since 1.2
    def ==(o)
      synchronized(self) do
        if ((o).equal?(self))
          return true
        end
        if (!(o.is_a?(Map)))
          return false
        end
        t = o
        if (!(t.size).equal?(size))
          return false
        end
        begin
          i = entry_set.iterator
          while (i.has_next)
            e = i.next_
            key = e.get_key
            value = e.get_value
            if ((value).nil?)
              if (!((t.get(key)).nil? && t.contains_key(key)))
                return false
              end
            else
              if (!(value == t.get(key)))
                return false
              end
            end
          end
        rescue ClassCastException => unused
          return false
        rescue NullPointerException => unused
          return false
        end
        return true
      end
    end
    
    typesig { [] }
    # Returns the hash code value for this Map as per the definition in the
    # Map interface.
    # 
    # @see Map#hashCode()
    # @since 1.2
    def hash_code
      synchronized(self) do
        # This code detects the recursion caused by computing the hash code
        # of a self-referential hash table and prevents the stack overflow
        # that would otherwise result.  This allows certain 1.1-era
        # applets with self-referential hash tables to work.  This code
        # abuses the loadFactor field to do double-duty as a hashCode
        # in progress flag, so as not to worsen the space performance.
        # A negative load factor indicates that hash code computation is
        # in progress.
        h = 0
        if ((@count).equal?(0) || @load_factor < 0)
          return h
        end # Returns zero
        @load_factor = -@load_factor # Mark hashCode computation in progress
        tab = @table
        i = 0
        while i < tab.attr_length
          e = tab[i]
          while !(e).nil?
            h += e.attr_key.hash_code ^ e.attr_value.hash_code
            e = e.attr_next
          end
          i += 1
        end
        @load_factor = -@load_factor # Mark hashCode computation complete
        return h
      end
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the Hashtable to a stream (i.e., serialize it).
    # 
    # @serialData The <i>capacity</i> of the Hashtable (the length of the
    # bucket array) is emitted (int), followed by the
    # <i>size</i> of the Hashtable (the number of key-value
    # mappings), followed by the key (Object) and value (Object)
    # for each key-value mapping represented by the Hashtable
    # The key-value mappings are emitted in no particular order.
    def write_object(s)
      synchronized(self) do
        # Write out the length, threshold, loadfactor
        s.default_write_object
        # Write out length, count of elements and then the key/value objects
        s.write_int(@table.attr_length)
        s.write_int(@count)
        index = @table.attr_length - 1
        while index >= 0
          entry = @table[index]
          while (!(entry).nil?)
            s.write_object(entry.attr_key)
            s.write_object(entry.attr_value)
            entry = entry.attr_next
          end
          index -= 1
        end
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the Hashtable from a stream (i.e., deserialize it).
    def read_object(s)
      # Read in the length, threshold, and loadfactor
      s.default_read_object
      # Read the original length of the array and number of elements
      origlength = s.read_int
      elements = s.read_int
      # Compute new size with a bit of room 5% to grow but
      # no larger than the original size.  Make the length
      # odd if it's large enough, this helps distribute the entries.
      # Guard against the length ending up zero, that's not valid.
      length = RJava.cast_to_int((elements * @load_factor)) + (elements / 20) + 3
      if (length > elements && ((length & 1)).equal?(0))
        length -= 1
      end
      if (origlength > 0 && length > origlength)
        length = origlength
      end
      table = Array.typed(Entry).new(length) { nil }
      @count = 0
      # Read the number of elements and then all the key/value objects
      while elements > 0
        key = s.read_object
        value = s.read_object
        # synch could be eliminated for performance
        reconstitution_put(table, key, value)
        elements -= 1
      end
      @table = table
    end
    
    typesig { [Array.typed(Entry), Object, Object] }
    # The put method used by readObject. This is provided because put
    # is overridable and should not be called in readObject since the
    # subclass will not yet be initialized.
    # 
    # <p>This differs from the regular put method in several ways. No
    # checking for rehashing is necessary since the number of elements
    # initially in the table is known. The modCount is not incremented
    # because we are creating a new instance. Also, no return value
    # is needed.
    def reconstitution_put(tab, key, value)
      if ((value).nil?)
        raise Java::Io::StreamCorruptedException.new
      end
      # Makes sure the key is not already in the hashtable.
      # This should not happen in deserialized version.
      hash = key.hash_code
      index = (hash & 0x7fffffff) % tab.attr_length
      e = tab[index]
      while !(e).nil?
        if (((e.attr_hash).equal?(hash)) && (e.attr_key == key))
          raise Java::Io::StreamCorruptedException.new
        end
        e = e.attr_next
      end
      # Creates the new entry.
      e_ = tab[index]
      tab[index] = Entry.new(hash, key, value, e_)
      @count += 1
    end
    
    class_module.module_eval {
      # Hashtable collision list.
      const_set_lazy(:Entry) { Class.new do
        include_class_members Hashtable
        include Map::Entry
        
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
        
        typesig { [::Java::Int, Object, Object, self::Entry] }
        def initialize(hash, key, value, next_)
          @hash = 0
          @key = nil
          @value = nil
          @next = nil
          @hash = hash
          @key = key
          @value = value
          @next = next_
        end
        
        typesig { [] }
        def clone
          return self.class::Entry.new(@hash, @key, @value, ((@next).nil? ? nil : @next.clone))
        end
        
        typesig { [] }
        # Map.Entry Ops
        def get_key
          return @key
        end
        
        typesig { [] }
        def get_value
          return @value
        end
        
        typesig { [Object] }
        def set_value(value)
          if ((value).nil?)
            raise self.class::NullPointerException.new
          end
          old_value = @value
          @value = value
          return old_value
        end
        
        typesig { [Object] }
        def ==(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          return ((@key).nil? ? (e.get_key).nil? : (@key == e.get_key)) && ((@value).nil? ? (e.get_value).nil? : (@value == e.get_value))
        end
        
        typesig { [] }
        def hash_code
          return @hash ^ ((@value).nil? ? 0 : @value.hash_code)
        end
        
        typesig { [] }
        def to_s
          return RJava.cast_to_string(@key.to_s) + "=" + RJava.cast_to_string(@value.to_s)
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
      
      # Types of Enumerations/Iterations
      const_set_lazy(:KEYS) { 0 }
      const_attr_reader  :KEYS
      
      const_set_lazy(:VALUES) { 1 }
      const_attr_reader  :VALUES
      
      const_set_lazy(:ENTRIES) { 2 }
      const_attr_reader  :ENTRIES
      
      # A hashtable enumerator class.  This class implements both the
      # Enumeration and Iterator interfaces, but individual instances
      # can be created with the Iterator methods disabled.  This is necessary
      # to avoid unintentionally increasing the capabilities granted a user
      # by passing an Enumeration.
      const_set_lazy(:Enumerator) { Class.new do
        extend LocalClass
        include_class_members Hashtable
        include Enumeration
        include Iterator
        
        attr_accessor :table
        alias_method :attr_table, :table
        undef_method :table
        alias_method :attr_table=, :table=
        undef_method :table=
        
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
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        # Indicates whether this Enumerator is serving as an Iterator
        # or an Enumeration.  (true -> Iterator).
        attr_accessor :iterator
        alias_method :attr_iterator, :iterator
        undef_method :iterator
        alias_method :attr_iterator=, :iterator=
        undef_method :iterator=
        
        # The modCount value that the iterator believes that the backing
        # Hashtable should have.  If this expectation is violated, the iterator
        # has detected concurrent modification.
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        typesig { [::Java::Int, ::Java::Boolean] }
        def initialize(type, iterator)
          @table = @local_class_parent.attr_table
          @index = @table.attr_length
          @entry = nil
          @last_returned = nil
          @type = 0
          @iterator = false
          @expected_mod_count = self.attr_mod_count
          @type = type
          @iterator = iterator
        end
        
        typesig { [] }
        def has_more_elements
          e = @entry
          i = @index
          t = @table
          # Use locals for faster loop iteration
          while ((e).nil? && i > 0)
            e = t[(i -= 1)]
          end
          @entry = e
          @index = i
          return !(e).nil?
        end
        
        typesig { [] }
        def next_element
          et = @entry
          i = @index
          t = @table
          # Use locals for faster loop iteration
          while ((et).nil? && i > 0)
            et = t[(i -= 1)]
          end
          @entry = et
          @index = i
          if (!(et).nil?)
            e = @last_returned = @entry
            @entry = e.attr_next
            return (@type).equal?(KEYS) ? e.attr_key : ((@type).equal?(VALUES) ? e.attr_value : e)
          end
          raise self.class::NoSuchElementException.new("Hashtable Enumerator")
        end
        
        typesig { [] }
        # Iterator methods
        def has_next
          return has_more_elements
        end
        
        typesig { [] }
        def next_
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise self.class::ConcurrentModificationException.new
          end
          return next_element
        end
        
        typesig { [] }
        def remove
          if (!@iterator)
            raise self.class::UnsupportedOperationException.new
          end
          if ((@last_returned).nil?)
            raise self.class::IllegalStateException.new("Hashtable Enumerator")
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise self.class::ConcurrentModificationException.new
          end
          synchronized((@local_class_parent)) do
            tab = @local_class_parent.attr_table
            index = (@last_returned.attr_hash & 0x7fffffff) % tab.attr_length
            e = tab[index]
            prev = nil
            while !(e).nil?
              if ((e).equal?(@last_returned))
                self.attr_mod_count += 1
                @expected_mod_count += 1
                if ((prev).nil?)
                  tab[index] = e.attr_next
                else
                  prev.attr_next = e.attr_next
                end
                self.attr_count -= 1
                @last_returned = nil
                return
              end
              prev = e
              e = e.attr_next
            end
            raise self.class::ConcurrentModificationException.new
          end
        end
        
        private
        alias_method :initialize__enumerator, :initialize
      end }
    }
    
    private
    alias_method :initialize__hashtable, :initialize
  end
  
end
