require "rjava"

# Copyright 1997-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TreeMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # A Red-Black tree based {@link NavigableMap} implementation.
  # The map is sorted according to the {@linkplain Comparable natural
  # ordering} of its keys, or by a {@link Comparator} provided at map
  # creation time, depending on which constructor is used.
  # 
  # <p>This implementation provides guaranteed log(n) time cost for the
  # <tt>containsKey</tt>, <tt>get</tt>, <tt>put</tt> and <tt>remove</tt>
  # operations.  Algorithms are adaptations of those in Cormen, Leiserson, and
  # Rivest's <I>Introduction to Algorithms</I>.
  # 
  # <p>Note that the ordering maintained by a sorted map (whether or not an
  # explicit comparator is provided) must be <i>consistent with equals</i> if
  # this sorted map is to correctly implement the <tt>Map</tt> interface.  (See
  # <tt>Comparable</tt> or <tt>Comparator</tt> for a precise definition of
  # <i>consistent with equals</i>.)  This is so because the <tt>Map</tt>
  # interface is defined in terms of the equals operation, but a map performs
  # all key comparisons using its <tt>compareTo</tt> (or <tt>compare</tt>)
  # method, so two keys that are deemed equal by this method are, from the
  # standpoint of the sorted map, equal.  The behavior of a sorted map
  # <i>is</i> well-defined even if its ordering is inconsistent with equals; it
  # just fails to obey the general contract of the <tt>Map</tt> interface.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access a map concurrently, and at least one of the
  # threads modifies the map structurally, it <i>must</i> be synchronized
  # externally.  (A structural modification is any operation that adds or
  # deletes one or more mappings; merely changing the value associated
  # with an existing key is not a structural modification.)  This is
  # typically accomplished by synchronizing on some object that naturally
  # encapsulates the map.
  # If no such object exists, the map should be "wrapped" using the
  # {@link Collections#synchronizedSortedMap Collections.synchronizedSortedMap}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the map: <pre>
  # SortedMap m = Collections.synchronizedSortedMap(new TreeMap(...));</pre>
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
  # exception for its correctness:   <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>All <tt>Map.Entry</tt> pairs returned by methods in this class
  # and its views represent snapshots of mappings at the time they were
  # produced. They do <em>not</em> support the <tt>Entry.setValue</tt>
  # method. (Note however that it is possible to change mappings in the
  # associated map using <tt>put</tt>.)
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # 
  # @author  Josh Bloch and Doug Lea
  # @see Map
  # @see HashMap
  # @see Hashtable
  # @see Comparable
  # @see Comparator
  # @see Collection
  # @since 1.2
  class TreeMap < TreeMapImports.const_get :AbstractMap
    include_class_members TreeMapImports
    include NavigableMap
    include Cloneable
    include Java::Io::Serializable
    
    # The comparator used to maintain order in this tree map, or
    # null if it uses the natural ordering of its keys.
    # 
    # @serial
    attr_accessor :comparator
    alias_method :attr_comparator, :comparator
    undef_method :comparator
    alias_method :attr_comparator=, :comparator=
    undef_method :comparator=
    
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    # The number of entries in the tree
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    # The number of structural modifications to the tree.
    attr_accessor :mod_count
    alias_method :attr_mod_count, :mod_count
    undef_method :mod_count
    alias_method :attr_mod_count=, :mod_count=
    undef_method :mod_count=
    
    typesig { [] }
    # Constructs a new, empty tree map, using the natural ordering of its
    # keys.  All keys inserted into the map must implement the {@link
    # Comparable} interface.  Furthermore, all such keys must be
    # <i>mutually comparable</i>: <tt>k1.compareTo(k2)</tt> must not throw
    # a <tt>ClassCastException</tt> for any keys <tt>k1</tt> and
    # <tt>k2</tt> in the map.  If the user attempts to put a key into the
    # map that violates this constraint (for example, the user attempts to
    # put a string key into a map whose keys are integers), the
    # <tt>put(Object key, Object value)</tt> call will throw a
    # <tt>ClassCastException</tt>.
    def initialize
      @comparator = nil
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      super()
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      @comparator = nil
    end
    
    typesig { [Comparator] }
    # Constructs a new, empty tree map, ordered according to the given
    # comparator.  All keys inserted into the map must be <i>mutually
    # comparable</i> by the given comparator: <tt>comparator.compare(k1,
    # k2)</tt> must not throw a <tt>ClassCastException</tt> for any keys
    # <tt>k1</tt> and <tt>k2</tt> in the map.  If the user attempts to put
    # a key into the map that violates this constraint, the <tt>put(Object
    # key, Object value)</tt> call will throw a
    # <tt>ClassCastException</tt>.
    # 
    # @param comparator the comparator that will be used to order this map.
    # If <tt>null</tt>, the {@linkplain Comparable natural
    # ordering} of the keys will be used.
    def initialize(comparator)
      @comparator = nil
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      super()
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      @comparator = comparator
    end
    
    typesig { [Map] }
    # Constructs a new tree map containing the same mappings as the given
    # map, ordered according to the <i>natural ordering</i> of its keys.
    # All keys inserted into the new map must implement the {@link
    # Comparable} interface.  Furthermore, all such keys must be
    # <i>mutually comparable</i>: <tt>k1.compareTo(k2)</tt> must not throw
    # a <tt>ClassCastException</tt> for any keys <tt>k1</tt> and
    # <tt>k2</tt> in the map.  This method runs in n*log(n) time.
    # 
    # @param  m the map whose mappings are to be placed in this map
    # @throws ClassCastException if the keys in m are not {@link Comparable},
    # or are not mutually comparable
    # @throws NullPointerException if the specified map is null
    def initialize(m)
      @comparator = nil
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      super()
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      @comparator = nil
      put_all(m)
    end
    
    typesig { [SortedMap] }
    # Constructs a new tree map containing the same mappings and
    # using the same ordering as the specified sorted map.  This
    # method runs in linear time.
    # 
    # @param  m the sorted map whose mappings are to be placed in this map,
    # and whose comparator is to be used to sort this map
    # @throws NullPointerException if the specified map is null
    def initialize(m)
      @comparator = nil
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      super()
      @root = nil
      @size = 0
      @mod_count = 0
      @entry_set = nil
      @navigable_key_set = nil
      @descending_map = nil
      @comparator = m.comparator
      begin
        build_from_sorted(m.size, m.entry_set.iterator, nil, nil)
      rescue Java::Io::IOException => cannot_happen
      rescue ClassNotFoundException => cannot_happen
      end
    end
    
    typesig { [] }
    # Query Operations
    # 
    # Returns the number of key-value mappings in this map.
    # 
    # @return the number of key-value mappings in this map
    def size
      return @size
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map contains a mapping for the specified
    # key.
    # 
    # @param key key whose presence in this map is to be tested
    # @return <tt>true</tt> if this map contains a mapping for the
    # specified key
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    def contains_key(key)
      return !(get_entry(key)).nil?
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map maps one or more keys to the
    # specified value.  More formally, returns <tt>true</tt> if and only if
    # this map contains at least one mapping to a value <tt>v</tt> such
    # that <tt>(value==null ? v==null : value.equals(v))</tt>.  This
    # operation will probably require time linear in the map size for
    # most implementations.
    # 
    # @param value value whose presence in this map is to be tested
    # @return <tt>true</tt> if a mapping to <tt>value</tt> exists;
    # <tt>false</tt> otherwise
    # @since 1.2
    def contains_value(value)
      e = get_first_entry
      while !(e).nil?
        if (val_equals(value, e.attr_value))
          return true
        end
        e = successor(e)
      end
      return false
    end
    
    typesig { [Object] }
    # Returns the value to which the specified key is mapped,
    # or {@code null} if this map contains no mapping for the key.
    # 
    # <p>More formally, if this map contains a mapping from a key
    # {@code k} to a value {@code v} such that {@code key} compares
    # equal to {@code k} according to the map's ordering, then this
    # method returns {@code v}; otherwise it returns {@code null}.
    # (There can be at most one such mapping.)
    # 
    # <p>A return value of {@code null} does not <i>necessarily</i>
    # indicate that the map contains no mapping for the key; it's also
    # possible that the map explicitly maps the key to {@code null}.
    # The {@link #containsKey containsKey} operation may be used to
    # distinguish these two cases.
    # 
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    def get(key)
      p = get_entry(key)
      return ((p).nil? ? nil : p.attr_value)
    end
    
    typesig { [] }
    def comparator
      return @comparator
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def first_key
      return key(get_first_entry)
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def last_key
      return key(get_last_entry)
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified map to this map.
    # These mappings replace any mappings that this map had for any
    # of the keys currently in the specified map.
    # 
    # @param  map mappings to be stored in this map
    # @throws ClassCastException if the class of a key or value in
    # the specified map prevents it from being stored in this map
    # @throws NullPointerException if the specified map is null or
    # the specified map contains a null key and this map does not
    # permit null keys
    def put_all(map)
      map_size = map.size
      if ((@size).equal?(0) && !(map_size).equal?(0) && map.is_a?(SortedMap))
        c = (map).comparator
        if ((c).equal?(@comparator) || (!(c).nil? && (c == @comparator)))
          (@mod_count += 1)
          begin
            build_from_sorted(map_size, map.entry_set.iterator, nil, nil)
          rescue Java::Io::IOException => cannot_happen
          rescue ClassNotFoundException => cannot_happen
          end
          return
        end
      end
      super(map)
    end
    
    typesig { [Object] }
    # Returns this map's entry for the given key, or <tt>null</tt> if the map
    # does not contain an entry for the key.
    # 
    # @return this map's entry for the given key, or <tt>null</tt> if the map
    # does not contain an entry for the key
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    def get_entry(key_)
      # Offload comparator-based version for sake of performance
      if (!(@comparator).nil?)
        return get_entry_using_comparator(key_)
      end
      if ((key_).nil?)
        raise NullPointerException.new
      end
      k = key_
      p = @root
      while (!(p).nil?)
        cmp = (k <=> p.attr_key)
        if (cmp < 0)
          p = p.attr_left
        else
          if (cmp > 0)
            p = p.attr_right
          else
            return p
          end
        end
      end
      return nil
    end
    
    typesig { [Object] }
    # Version of getEntry using comparator. Split off from getEntry
    # for performance. (This is not worth doing for most methods,
    # that are less dependent on comparator performance, but is
    # worthwhile here.)
    def get_entry_using_comparator(key_)
      k = key_
      cpr = @comparator
      if (!(cpr).nil?)
        p = @root
        while (!(p).nil?)
          cmp = cpr.compare(k, p.attr_key)
          if (cmp < 0)
            p = p.attr_left
          else
            if (cmp > 0)
              p = p.attr_right
            else
              return p
            end
          end
        end
      end
      return nil
    end
    
    typesig { [Object] }
    # Gets the entry corresponding to the specified key; if no such entry
    # exists, returns the entry for the least key greater than the specified
    # key; if no such entry exists (i.e., the greatest key in the Tree is less
    # than the specified key), returns <tt>null</tt>.
    def get_ceiling_entry(key_)
      p = @root
      while (!(p).nil?)
        cmp = compare(key_, p.attr_key)
        if (cmp < 0)
          if (!(p.attr_left).nil?)
            p = p.attr_left
          else
            return p
          end
        else
          if (cmp > 0)
            if (!(p.attr_right).nil?)
              p = p.attr_right
            else
              parent = p.attr_parent
              ch = p
              while (!(parent).nil? && (ch).equal?(parent.attr_right))
                ch = parent
                parent = parent.attr_parent
              end
              return parent
            end
          else
            return p
          end
        end
      end
      return nil
    end
    
    typesig { [Object] }
    # Gets the entry corresponding to the specified key; if no such entry
    # exists, returns the entry for the greatest key less than the specified
    # key; if no such entry exists, returns <tt>null</tt>.
    def get_floor_entry(key_)
      p = @root
      while (!(p).nil?)
        cmp = compare(key_, p.attr_key)
        if (cmp > 0)
          if (!(p.attr_right).nil?)
            p = p.attr_right
          else
            return p
          end
        else
          if (cmp < 0)
            if (!(p.attr_left).nil?)
              p = p.attr_left
            else
              parent = p.attr_parent
              ch = p
              while (!(parent).nil? && (ch).equal?(parent.attr_left))
                ch = parent
                parent = parent.attr_parent
              end
              return parent
            end
          else
            return p
          end
        end
      end
      return nil
    end
    
    typesig { [Object] }
    # Gets the entry for the least key greater than the specified
    # key; if no such entry exists, returns the entry for the least
    # key greater than the specified key; if no such entry exists
    # returns <tt>null</tt>.
    def get_higher_entry(key_)
      p = @root
      while (!(p).nil?)
        cmp = compare(key_, p.attr_key)
        if (cmp < 0)
          if (!(p.attr_left).nil?)
            p = p.attr_left
          else
            return p
          end
        else
          if (!(p.attr_right).nil?)
            p = p.attr_right
          else
            parent = p.attr_parent
            ch = p
            while (!(parent).nil? && (ch).equal?(parent.attr_right))
              ch = parent
              parent = parent.attr_parent
            end
            return parent
          end
        end
      end
      return nil
    end
    
    typesig { [Object] }
    # Returns the entry for the greatest key less than the specified key; if
    # no such entry exists (i.e., the least key in the Tree is greater than
    # the specified key), returns <tt>null</tt>.
    def get_lower_entry(key_)
      p = @root
      while (!(p).nil?)
        cmp = compare(key_, p.attr_key)
        if (cmp > 0)
          if (!(p.attr_right).nil?)
            p = p.attr_right
          else
            return p
          end
        else
          if (!(p.attr_left).nil?)
            p = p.attr_left
          else
            parent = p.attr_parent
            ch = p
            while (!(parent).nil? && (ch).equal?(parent.attr_left))
              ch = parent
              parent = parent.attr_parent
            end
            return parent
          end
        end
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
    # 
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>.
    # (A <tt>null</tt> return can also indicate that the map
    # previously associated <tt>null</tt> with <tt>key</tt>.)
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    def put(key_, value)
      t = @root
      if ((t).nil?)
        # TBD:
        # 5045147: (coll) Adding null to an empty TreeSet should
        # throw NullPointerException
        # 
        # compare(key, key); // type check
        @root = Entry.new(key_, value, nil)
        @size = 1
        @mod_count += 1
        return nil
      end
      cmp = 0
      parent = nil
      # split comparator and comparable paths
      cpr = @comparator
      if (!(cpr).nil?)
        begin
          parent = t
          cmp = cpr.compare(key_, t.attr_key)
          if (cmp < 0)
            t = t.attr_left
          else
            if (cmp > 0)
              t = t.attr_right
            else
              return t.set_value(value)
            end
          end
        end while (!(t).nil?)
      else
        if ((key_).nil?)
          raise NullPointerException.new
        end
        k = key_
        begin
          parent = t
          cmp = (k <=> t.attr_key)
          if (cmp < 0)
            t = t.attr_left
          else
            if (cmp > 0)
              t = t.attr_right
            else
              return t.set_value(value)
            end
          end
        end while (!(t).nil?)
      end
      e = Entry.new(key_, value, parent)
      if (cmp < 0)
        parent.attr_left = e
      else
        parent.attr_right = e
      end
      fix_after_insertion(e)
      @size += 1
      @mod_count += 1
      return nil
    end
    
    typesig { [Object] }
    # Removes the mapping for this key from this TreeMap if present.
    # 
    # @param  key key for which mapping should be removed
    # @return the previous value associated with <tt>key</tt>, or
    # <tt>null</tt> if there was no mapping for <tt>key</tt>.
    # (A <tt>null</tt> return can also indicate that the map
    # previously associated <tt>null</tt> with <tt>key</tt>.)
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    def remove(key_)
      p = get_entry(key_)
      if ((p).nil?)
        return nil
      end
      old_value = p.attr_value
      delete_entry(p)
      return old_value
    end
    
    typesig { [] }
    # Removes all of the mappings from this map.
    # The map will be empty after this call returns.
    def clear
      @mod_count += 1
      @size = 0
      @root = nil
    end
    
    typesig { [] }
    # Returns a shallow copy of this <tt>TreeMap</tt> instance. (The keys and
    # values themselves are not cloned.)
    # 
    # @return a shallow copy of this map
    def clone
      clone = nil
      begin
        clone = super
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
      # Put clone into "virgin" state (except for comparator)
      clone.attr_root = nil
      clone.attr_size = 0
      clone.attr_mod_count = 0
      clone.attr_entry_set = nil
      clone.attr_navigable_key_set = nil
      clone.attr_descending_map = nil
      # Initialize clone with our mappings
      begin
        clone.build_from_sorted(@size, entry_set.iterator, nil, nil)
      rescue Java::Io::IOException => cannot_happen
      rescue ClassNotFoundException => cannot_happen
      end
      return clone
    end
    
    typesig { [] }
    # NavigableMap API methods
    # 
    # @since 1.6
    def first_entry
      return export_entry(get_first_entry)
    end
    
    typesig { [] }
    # @since 1.6
    def last_entry
      return export_entry(get_last_entry)
    end
    
    typesig { [] }
    # @since 1.6
    def poll_first_entry
      p = get_first_entry
      result = export_entry(p)
      if (!(p).nil?)
        delete_entry(p)
      end
      return result
    end
    
    typesig { [] }
    # @since 1.6
    def poll_last_entry
      p = get_last_entry
      result = export_entry(p)
      if (!(p).nil?)
        delete_entry(p)
      end
      return result
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def lower_entry(key_)
      return export_entry(get_lower_entry(key_))
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def lower_key(key_)
      return key_or_null(get_lower_entry(key_))
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def floor_entry(key_)
      return export_entry(get_floor_entry(key_))
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def floor_key(key_)
      return key_or_null(get_floor_entry(key_))
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def ceiling_entry(key_)
      return export_entry(get_ceiling_entry(key_))
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def ceiling_key(key_)
      return key_or_null(get_ceiling_entry(key_))
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def higher_entry(key_)
      return export_entry(get_higher_entry(key_))
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @since 1.6
    def higher_key(key_)
      return key_or_null(get_higher_entry(key_))
    end
    
    # Views
    # 
    # Fields initialized to contain an instance of the entry set view
    # the first time this view is requested.  Views are stateless, so
    # there's no reason to create more than one.
    attr_accessor :entry_set
    alias_method :attr_entry_set, :entry_set
    undef_method :entry_set
    alias_method :attr_entry_set=, :entry_set=
    undef_method :entry_set=
    
    attr_accessor :navigable_key_set
    alias_method :attr_navigable_key_set, :navigable_key_set
    undef_method :navigable_key_set
    alias_method :attr_navigable_key_set=, :navigable_key_set=
    undef_method :navigable_key_set=
    
    attr_accessor :descending_map
    alias_method :attr_descending_map, :descending_map
    undef_method :descending_map
    alias_method :attr_descending_map=, :descending_map=
    undef_method :descending_map=
    
    typesig { [] }
    # Returns a {@link Set} view of the keys contained in this map.
    # The set's iterator returns the keys in ascending order.
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
      return navigable_key_set
    end
    
    typesig { [] }
    # @since 1.6
    def navigable_key_set
      nks = @navigable_key_set
      return (!(nks).nil?) ? nks : (@navigable_key_set = KeySet.new(self))
    end
    
    typesig { [] }
    # @since 1.6
    def descending_key_set
      return descending_map.navigable_key_set
    end
    
    typesig { [] }
    # Returns a {@link Collection} view of the values contained in this map.
    # The collection's iterator returns the values in ascending order
    # of the corresponding keys.
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
    
    typesig { [] }
    # Returns a {@link Set} view of the mappings contained in this map.
    # The set's iterator returns the entries in ascending key order.
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
      return (!(es).nil?) ? es : (@entry_set = EntrySet.new_local(self))
    end
    
    typesig { [] }
    # @since 1.6
    def descending_map
      km = @descending_map
      return (!(km).nil?) ? km : (@descending_map = DescendingSubMap.new(self, true, nil, true, true, nil, true))
    end
    
    typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException if <tt>fromKey</tt> or <tt>toKey</tt> is
    # null and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @throws IllegalArgumentException {@inheritDoc}
    # @since 1.6
    def sub_map(from_key, from_inclusive, to_key, to_inclusive)
      return AscendingSubMap.new(self, false, from_key, from_inclusive, false, to_key, to_inclusive)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException if <tt>toKey</tt> is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @throws IllegalArgumentException {@inheritDoc}
    # @since 1.6
    def head_map(to_key, inclusive)
      return AscendingSubMap.new(self, true, nil, true, false, to_key, inclusive)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException if <tt>fromKey</tt> is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @throws IllegalArgumentException {@inheritDoc}
    # @since 1.6
    def tail_map(from_key, inclusive)
      return AscendingSubMap.new(self, false, from_key, inclusive, true, nil, true)
    end
    
    typesig { [Object, Object] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException if <tt>fromKey</tt> or <tt>toKey</tt> is
    # null and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_map(from_key, to_key)
      return sub_map(from_key, true, to_key, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException if <tt>toKey</tt> is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @throws IllegalArgumentException {@inheritDoc}
    def head_map(to_key)
      return head_map(to_key, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException if <tt>fromKey</tt> is null
    # and this map uses natural ordering, or its comparator
    # does not permit null keys
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_map(from_key)
      return tail_map(from_key, true)
    end
    
    class_module.module_eval {
      # View class support
      const_set_lazy(:Values) { Class.new(AbstractCollection) do
        extend LocalClass
        include_class_members TreeMap
        
        typesig { [] }
        def iterator
          return ValueIterator.new(get_first_entry)
        end
        
        typesig { [] }
        def size
          return @local_class_parent.size
        end
        
        typesig { [Object] }
        def contains(o)
          return @local_class_parent.contains_value(o)
        end
        
        typesig { [Object] }
        def remove(o)
          e = get_first_entry
          while !(e).nil?
            if (val_equals(e.get_value, o))
              delete_entry(e)
              return true
            end
            e = successor(e)
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
      
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        extend LocalClass
        include_class_members TreeMap
        
        typesig { [] }
        def iterator
          return EntryIterator.new(get_first_entry)
        end
        
        typesig { [Object] }
        def contains(o)
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          entry = o
          value = entry.get_value
          p = get_entry(entry.get_key)
          return !(p).nil? && val_equals(p.get_value, value)
        end
        
        typesig { [Object] }
        def remove(o)
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          entry = o
          value = entry.get_value
          p = get_entry(entry.get_key)
          if (!(p).nil? && val_equals(p.get_value, value))
            delete_entry(p)
            return true
          end
          return false
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
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_set, :initialize
      end }
    }
    
    typesig { [] }
    # Unlike Values and EntrySet, the KeySet class is static,
    # delegating to a NavigableMap to allow use by SubMaps, which
    # outweighs the ugliness of needing type-tests for the following
    # Iterator methods that are defined appropriately in main versus
    # submap classes.
    def key_iterator
      return KeyIterator.new_local(self, get_first_entry)
    end
    
    typesig { [] }
    def descending_key_iterator
      return DescendingKeyIterator.new_local(self, get_last_entry)
    end
    
    class_module.module_eval {
      const_set_lazy(:KeySet) { Class.new(AbstractSet) do
        include_class_members TreeMap
        include NavigableSet
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        typesig { [NavigableMap] }
        def initialize(map)
          @m = nil
          super()
          @m = map
        end
        
        typesig { [] }
        def iterator
          if (@m.is_a?(TreeMap))
            return (@m).key_iterator
          else
            return ((@m).key_iterator)
          end
        end
        
        typesig { [] }
        def descending_iterator
          if (@m.is_a?(TreeMap))
            return (@m).descending_key_iterator
          else
            return ((@m).descending_key_iterator)
          end
        end
        
        typesig { [] }
        def size
          return @m.size
        end
        
        typesig { [] }
        def is_empty
          return @m.is_empty
        end
        
        typesig { [Object] }
        def contains(o)
          return @m.contains_key(o)
        end
        
        typesig { [] }
        def clear
          @m.clear
        end
        
        typesig { [Object] }
        def lower(e)
          return @m.lower_key(e)
        end
        
        typesig { [Object] }
        def floor(e)
          return @m.floor_key(e)
        end
        
        typesig { [Object] }
        def ceiling(e)
          return @m.ceiling_key(e)
        end
        
        typesig { [Object] }
        def higher(e)
          return @m.higher_key(e)
        end
        
        typesig { [] }
        def first
          return @m.first_key
        end
        
        typesig { [] }
        def last
          return @m.last_key
        end
        
        typesig { [] }
        def comparator
          return @m.comparator
        end
        
        typesig { [] }
        def poll_first
          e = @m.poll_first_entry
          return (e).nil? ? nil : e.get_key
        end
        
        typesig { [] }
        def poll_last
          e = @m.poll_last_entry
          return (e).nil? ? nil : e.get_key
        end
        
        typesig { [Object] }
        def remove(o)
          old_size = size
          @m.remove(o)
          return !(size).equal?(old_size)
        end
        
        typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
        def sub_set(from_element, from_inclusive, to_element, to_inclusive)
          return KeySet.new(@m.sub_map(from_element, from_inclusive, to_element, to_inclusive))
        end
        
        typesig { [Object, ::Java::Boolean] }
        def head_set(to_element, inclusive)
          return KeySet.new(@m.head_map(to_element, inclusive))
        end
        
        typesig { [Object, ::Java::Boolean] }
        def tail_set(from_element, inclusive)
          return KeySet.new(@m.tail_map(from_element, inclusive))
        end
        
        typesig { [Object, Object] }
        def sub_set(from_element, to_element)
          return sub_set(from_element, true, to_element, false)
        end
        
        typesig { [Object] }
        def head_set(to_element)
          return head_set(to_element, false)
        end
        
        typesig { [Object] }
        def tail_set(from_element)
          return tail_set(from_element, true)
        end
        
        typesig { [] }
        def descending_set
          return KeySet.new(@m.descending_map)
        end
        
        private
        alias_method :initialize__key_set, :initialize
      end }
      
      # Base class for TreeMap Iterators
      const_set_lazy(:PrivateEntryIterator) { Class.new do
        extend LocalClass
        include_class_members TreeMap
        include Iterator
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
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
        
        typesig { [Entry] }
        def initialize(first)
          @next = nil
          @last_returned = nil
          @expected_mod_count = 0
          @expected_mod_count = self.attr_mod_count
          @last_returned = nil
          @next = first
        end
        
        typesig { [] }
        def has_next
          return !(@next).nil?
        end
        
        typesig { [] }
        def next_entry
          e = @next
          if ((e).nil?)
            raise NoSuchElementException.new
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          @next = successor(e)
          @last_returned = e
          return e
        end
        
        typesig { [] }
        def prev_entry
          e = @next
          if ((e).nil?)
            raise NoSuchElementException.new
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          @next = predecessor(e)
          @last_returned = e
          return e
        end
        
        typesig { [] }
        def remove
          if ((@last_returned).nil?)
            raise IllegalStateException.new
          end
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise ConcurrentModificationException.new
          end
          # deleted entries are replaced by their successors
          if (!(@last_returned.attr_left).nil? && !(@last_returned.attr_right).nil?)
            @next = @last_returned
          end
          delete_entry(@last_returned)
          @expected_mod_count = self.attr_mod_count
          @last_returned = nil
        end
        
        private
        alias_method :initialize__private_entry_iterator, :initialize
      end }
      
      const_set_lazy(:EntryIterator) { Class.new(PrivateEntryIterator) do
        extend LocalClass
        include_class_members TreeMap
        
        typesig { [Entry] }
        def initialize(first)
          super(first)
        end
        
        typesig { [] }
        def next
          return next_entry
        end
        
        private
        alias_method :initialize__entry_iterator, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(PrivateEntryIterator) do
        extend LocalClass
        include_class_members TreeMap
        
        typesig { [Entry] }
        def initialize(first)
          super(first)
        end
        
        typesig { [] }
        def next
          return next_entry.attr_value
        end
        
        private
        alias_method :initialize__value_iterator, :initialize
      end }
      
      const_set_lazy(:KeyIterator) { Class.new(PrivateEntryIterator) do
        extend LocalClass
        include_class_members TreeMap
        
        typesig { [Entry] }
        def initialize(first)
          super(first)
        end
        
        typesig { [] }
        def next
          return next_entry.attr_key
        end
        
        private
        alias_method :initialize__key_iterator, :initialize
      end }
      
      const_set_lazy(:DescendingKeyIterator) { Class.new(PrivateEntryIterator) do
        extend LocalClass
        include_class_members TreeMap
        
        typesig { [Entry] }
        def initialize(first)
          super(first)
        end
        
        typesig { [] }
        def next
          return prev_entry.attr_key
        end
        
        private
        alias_method :initialize__descending_key_iterator, :initialize
      end }
    }
    
    typesig { [Object, Object] }
    # Little utilities
    # 
    # Compares two keys using the correct comparison method for this TreeMap.
    def compare(k1, k2)
      return (@comparator).nil? ? ((k1) <=> k2) : @comparator.compare(k1, k2)
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # Test two values for equality.  Differs from o1.equals(o2) only in
      # that it copes with <tt>null</tt> o1 properly.
      def val_equals(o1, o2)
        return ((o1).nil? ? (o2).nil? : (o1 == o2))
      end
      
      typesig { [TreeMap::Entry] }
      # Return SimpleImmutableEntry for entry, or null if null
      def export_entry(e)
        return (e).nil? ? nil : AbstractMap::SimpleImmutableEntry.new(e)
      end
      
      typesig { [TreeMap::Entry] }
      # Return key for entry, or null if null
      def key_or_null(e)
        return (e).nil? ? nil : e.attr_key
      end
      
      typesig { [Entry] }
      # Returns the key corresponding to the specified Entry.
      # @throws NoSuchElementException if the Entry is null
      def key(e)
        if ((e).nil?)
          raise NoSuchElementException.new
        end
        return e.attr_key
      end
      
      # SubMaps
      # 
      # Dummy value serving as unmatchable fence key for unbounded
      # SubMapIterators
      const_set_lazy(:UNBOUNDED) { Object.new }
      const_attr_reader  :UNBOUNDED
      
      # @serial include
      const_set_lazy(:NavigableSubMap) { Class.new(AbstractMap) do
        include_class_members TreeMap
        include NavigableMap
        include Java::Io::Serializable
        
        # The backing map.
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        # Endpoints are represented as triples (fromStart, lo,
        # loInclusive) and (toEnd, hi, hiInclusive). If fromStart is
        # true, then the low (absolute) bound is the start of the
        # backing map, and the other values are ignored. Otherwise,
        # if loInclusive is true, lo is the inclusive bound, else lo
        # is the exclusive bound. Similarly for the upper bound.
        attr_accessor :lo
        alias_method :attr_lo, :lo
        undef_method :lo
        alias_method :attr_lo=, :lo=
        undef_method :lo=
        
        attr_accessor :hi
        alias_method :attr_hi, :hi
        undef_method :hi
        alias_method :attr_hi=, :hi=
        undef_method :hi=
        
        attr_accessor :from_start
        alias_method :attr_from_start, :from_start
        undef_method :from_start
        alias_method :attr_from_start=, :from_start=
        undef_method :from_start=
        
        attr_accessor :to_end
        alias_method :attr_to_end, :to_end
        undef_method :to_end
        alias_method :attr_to_end=, :to_end=
        undef_method :to_end=
        
        attr_accessor :lo_inclusive
        alias_method :attr_lo_inclusive, :lo_inclusive
        undef_method :lo_inclusive
        alias_method :attr_lo_inclusive=, :lo_inclusive=
        undef_method :lo_inclusive=
        
        attr_accessor :hi_inclusive
        alias_method :attr_hi_inclusive, :hi_inclusive
        undef_method :hi_inclusive
        alias_method :attr_hi_inclusive=, :hi_inclusive=
        undef_method :hi_inclusive=
        
        typesig { [TreeMap, ::Java::Boolean, Object, ::Java::Boolean, ::Java::Boolean, Object, ::Java::Boolean] }
        def initialize(m, from_start, lo, lo_inclusive, to_end, hi, hi_inclusive)
          @m = nil
          @lo = nil
          @hi = nil
          @from_start = false
          @to_end = false
          @lo_inclusive = false
          @hi_inclusive = false
          @descending_map_view = nil
          @entry_set_view = nil
          @navigable_key_set_view = nil
          super()
          @descending_map_view = nil
          @entry_set_view = nil
          @navigable_key_set_view = nil
          if (!from_start && !to_end)
            if (m.compare(lo, hi) > 0)
              raise IllegalArgumentException.new("fromKey > toKey")
            end
          else
            if (!from_start)
              # type check
              m.compare(lo, lo)
            end
            if (!to_end)
              m.compare(hi, hi)
            end
          end
          @m = m
          @from_start = from_start
          @lo = lo
          @lo_inclusive = lo_inclusive
          @to_end = to_end
          @hi = hi
          @hi_inclusive = hi_inclusive
        end
        
        typesig { [Object] }
        # internal utilities
        def too_low(key)
          if (!@from_start)
            c = @m.compare(key, @lo)
            if (c < 0 || ((c).equal?(0) && !@lo_inclusive))
              return true
            end
          end
          return false
        end
        
        typesig { [Object] }
        def too_high(key)
          if (!@to_end)
            c = @m.compare(key, @hi)
            if (c > 0 || ((c).equal?(0) && !@hi_inclusive))
              return true
            end
          end
          return false
        end
        
        typesig { [Object] }
        def in_range(key)
          return !too_low(key) && !too_high(key)
        end
        
        typesig { [Object] }
        def in_closed_range(key)
          return (@from_start || @m.compare(key, @lo) >= 0) && (@to_end || @m.compare(@hi, key) >= 0)
        end
        
        typesig { [Object, ::Java::Boolean] }
        def in_range(key, inclusive)
          return inclusive ? in_range(key) : in_closed_range(key)
        end
        
        typesig { [] }
        # Absolute versions of relation operations.
        # Subclasses map to these using like-named "sub"
        # versions that invert senses for descending maps
        def abs_lowest
          e = (@from_start ? @m.get_first_entry : (@lo_inclusive ? @m.get_ceiling_entry(@lo) : @m.get_higher_entry(@lo)))
          return ((e).nil? || too_high(e.attr_key)) ? nil : e
        end
        
        typesig { [] }
        def abs_highest
          e = (@to_end ? @m.get_last_entry : (@hi_inclusive ? @m.get_floor_entry(@hi) : @m.get_lower_entry(@hi)))
          return ((e).nil? || too_low(e.attr_key)) ? nil : e
        end
        
        typesig { [Object] }
        def abs_ceiling(key)
          if (too_low(key))
            return abs_lowest
          end
          e = @m.get_ceiling_entry(key)
          return ((e).nil? || too_high(e.attr_key)) ? nil : e
        end
        
        typesig { [Object] }
        def abs_higher(key)
          if (too_low(key))
            return abs_lowest
          end
          e = @m.get_higher_entry(key)
          return ((e).nil? || too_high(e.attr_key)) ? nil : e
        end
        
        typesig { [Object] }
        def abs_floor(key)
          if (too_high(key))
            return abs_highest
          end
          e = @m.get_floor_entry(key)
          return ((e).nil? || too_low(e.attr_key)) ? nil : e
        end
        
        typesig { [Object] }
        def abs_lower(key)
          if (too_high(key))
            return abs_highest
          end
          e = @m.get_lower_entry(key)
          return ((e).nil? || too_low(e.attr_key)) ? nil : e
        end
        
        typesig { [] }
        # Returns the absolute high fence for ascending traversal
        def abs_high_fence
          return (@to_end ? nil : (@hi_inclusive ? @m.get_higher_entry(@hi) : @m.get_ceiling_entry(@hi)))
        end
        
        typesig { [] }
        # Return the absolute low fence for descending traversal
        def abs_low_fence
          return (@from_start ? nil : (@lo_inclusive ? @m.get_lower_entry(@lo) : @m.get_floor_entry(@lo)))
        end
        
        typesig { [] }
        # Abstract methods defined in ascending vs descending classes
        # These relay to the appropriate absolute versions
        def sub_lowest
          raise NotImplementedError
        end
        
        typesig { [] }
        def sub_highest
          raise NotImplementedError
        end
        
        typesig { [Object] }
        def sub_ceiling(key)
          raise NotImplementedError
        end
        
        typesig { [Object] }
        def sub_higher(key)
          raise NotImplementedError
        end
        
        typesig { [Object] }
        def sub_floor(key)
          raise NotImplementedError
        end
        
        typesig { [Object] }
        def sub_lower(key)
          raise NotImplementedError
        end
        
        typesig { [] }
        # Returns ascending iterator from the perspective of this submap
        def key_iterator
          raise NotImplementedError
        end
        
        typesig { [] }
        # Returns descending iterator from the perspective of this submap
        def descending_key_iterator
          raise NotImplementedError
        end
        
        typesig { [] }
        # public methods
        def is_empty
          return (@from_start && @to_end) ? @m.is_empty : entry_set.is_empty
        end
        
        typesig { [] }
        def size
          return (@from_start && @to_end) ? @m.size : entry_set.size
        end
        
        typesig { [Object] }
        def contains_key(key)
          return in_range(key) && @m.contains_key(key)
        end
        
        typesig { [Object, Object] }
        def put(key, value)
          if (!in_range(key))
            raise IllegalArgumentException.new("key out of range")
          end
          return @m.put(key, value)
        end
        
        typesig { [Object] }
        def get(key)
          return !in_range(key) ? nil : @m.get(key)
        end
        
        typesig { [Object] }
        def remove(key)
          return !in_range(key) ? nil : @m.remove(key)
        end
        
        typesig { [Object] }
        def ceiling_entry(key)
          return export_entry(sub_ceiling(key))
        end
        
        typesig { [Object] }
        def ceiling_key(key)
          return key_or_null(sub_ceiling(key))
        end
        
        typesig { [Object] }
        def higher_entry(key)
          return export_entry(sub_higher(key))
        end
        
        typesig { [Object] }
        def higher_key(key)
          return key_or_null(sub_higher(key))
        end
        
        typesig { [Object] }
        def floor_entry(key)
          return export_entry(sub_floor(key))
        end
        
        typesig { [Object] }
        def floor_key(key)
          return key_or_null(sub_floor(key))
        end
        
        typesig { [Object] }
        def lower_entry(key)
          return export_entry(sub_lower(key))
        end
        
        typesig { [Object] }
        def lower_key(key)
          return key_or_null(sub_lower(key))
        end
        
        typesig { [] }
        def first_key
          return key(sub_lowest)
        end
        
        typesig { [] }
        def last_key
          return key(sub_highest)
        end
        
        typesig { [] }
        def first_entry
          return export_entry(sub_lowest)
        end
        
        typesig { [] }
        def last_entry
          return export_entry(sub_highest)
        end
        
        typesig { [] }
        def poll_first_entry
          e = sub_lowest
          result = export_entry(e)
          if (!(e).nil?)
            @m.delete_entry(e)
          end
          return result
        end
        
        typesig { [] }
        def poll_last_entry
          e = sub_highest
          result = export_entry(e)
          if (!(e).nil?)
            @m.delete_entry(e)
          end
          return result
        end
        
        # Views
        attr_accessor :descending_map_view
        alias_method :attr_descending_map_view, :descending_map_view
        undef_method :descending_map_view
        alias_method :attr_descending_map_view=, :descending_map_view=
        undef_method :descending_map_view=
        
        attr_accessor :entry_set_view
        alias_method :attr_entry_set_view, :entry_set_view
        undef_method :entry_set_view
        alias_method :attr_entry_set_view=, :entry_set_view=
        undef_method :entry_set_view=
        
        attr_accessor :navigable_key_set_view
        alias_method :attr_navigable_key_set_view, :navigable_key_set_view
        undef_method :navigable_key_set_view
        alias_method :attr_navigable_key_set_view=, :navigable_key_set_view=
        undef_method :navigable_key_set_view=
        
        typesig { [] }
        def navigable_key_set
          nksv = @navigable_key_set_view
          return (!(nksv).nil?) ? nksv : (@navigable_key_set_view = TreeMap::KeySet.new(self))
        end
        
        typesig { [] }
        def key_set
          return navigable_key_set
        end
        
        typesig { [] }
        def descending_key_set
          return descending_map.navigable_key_set
        end
        
        typesig { [Object, Object] }
        def sub_map(from_key, to_key)
          return sub_map(from_key, true, to_key, false)
        end
        
        typesig { [Object] }
        def head_map(to_key)
          return head_map(to_key, false)
        end
        
        typesig { [Object] }
        def tail_map(from_key)
          return tail_map(from_key, true)
        end
        
        class_module.module_eval {
          # View classes
          const_set_lazy(:EntrySetView) { Class.new(AbstractSet) do
            extend LocalClass
            include_class_members NavigableSubMap
            
            attr_accessor :size
            alias_method :attr_size, :size
            undef_method :size
            alias_method :attr_size=, :size=
            undef_method :size=
            
            attr_accessor :size_mod_count
            alias_method :attr_size_mod_count, :size_mod_count
            undef_method :size_mod_count
            alias_method :attr_size_mod_count=, :size_mod_count=
            undef_method :size_mod_count=
            
            typesig { [] }
            def size
              if (self.attr_from_start && self.attr_to_end)
                return self.attr_m.size
              end
              if ((@size).equal?(-1) || !(@size_mod_count).equal?(self.attr_m.attr_mod_count))
                @size_mod_count = self.attr_m.attr_mod_count
                @size = 0
                i = iterator
                while (i.has_next)
                  @size += 1
                  i.next
                end
              end
              return @size
            end
            
            typesig { [] }
            def is_empty
              n = abs_lowest
              return (n).nil? || too_high(n.attr_key)
            end
            
            typesig { [Object] }
            def contains(o)
              if (!(o.is_a?(Map::Entry)))
                return false
              end
              entry = o
              key = entry.get_key
              if (!in_range(key))
                return false
              end
              node = self.attr_m.get_entry(key)
              return !(node).nil? && val_equals(node.get_value, entry.get_value)
            end
            
            typesig { [Object] }
            def remove(o)
              if (!(o.is_a?(Map::Entry)))
                return false
              end
              entry = o
              key = entry.get_key
              if (!in_range(key))
                return false
              end
              node = self.attr_m.get_entry(key)
              if (!(node).nil? && val_equals(node.get_value, entry.get_value))
                self.attr_m.delete_entry(node)
                return true
              end
              return false
            end
            
            typesig { [] }
            def initialize
              @size = 0
              @size_mod_count = 0
              super()
              @size = -1
            end
            
            private
            alias_method :initialize__entry_set_view, :initialize
          end }
          
          # Iterators for SubMaps
          const_set_lazy(:SubMapIterator) { Class.new do
            extend LocalClass
            include_class_members NavigableSubMap
            include Iterator
            
            attr_accessor :last_returned
            alias_method :attr_last_returned, :last_returned
            undef_method :last_returned
            alias_method :attr_last_returned=, :last_returned=
            undef_method :last_returned=
            
            attr_accessor :next
            alias_method :attr_next, :next
            undef_method :next
            alias_method :attr_next=, :next=
            undef_method :next=
            
            attr_accessor :fence_key
            alias_method :attr_fence_key, :fence_key
            undef_method :fence_key
            alias_method :attr_fence_key=, :fence_key=
            undef_method :fence_key=
            
            attr_accessor :expected_mod_count
            alias_method :attr_expected_mod_count, :expected_mod_count
            undef_method :expected_mod_count
            alias_method :attr_expected_mod_count=, :expected_mod_count=
            undef_method :expected_mod_count=
            
            typesig { [TreeMap::Entry, TreeMap::Entry] }
            def initialize(first, fence)
              @last_returned = nil
              @next = nil
              @fence_key = nil
              @expected_mod_count = 0
              @expected_mod_count = self.attr_m.attr_mod_count
              @last_returned = nil
              @next = first
              @fence_key = (fence).nil? ? UNBOUNDED : fence.attr_key
            end
            
            typesig { [] }
            def has_next
              return !(@next).nil? && !(@next.attr_key).equal?(@fence_key)
            end
            
            typesig { [] }
            def next_entry
              e = @next
              if ((e).nil? || (e.attr_key).equal?(@fence_key))
                raise NoSuchElementException.new
              end
              if (!(self.attr_m.attr_mod_count).equal?(@expected_mod_count))
                raise ConcurrentModificationException.new
              end
              @next = successor(e)
              @last_returned = e
              return e
            end
            
            typesig { [] }
            def prev_entry
              e = @next
              if ((e).nil? || (e.attr_key).equal?(@fence_key))
                raise NoSuchElementException.new
              end
              if (!(self.attr_m.attr_mod_count).equal?(@expected_mod_count))
                raise ConcurrentModificationException.new
              end
              @next = predecessor(e)
              @last_returned = e
              return e
            end
            
            typesig { [] }
            def remove_ascending
              if ((@last_returned).nil?)
                raise IllegalStateException.new
              end
              if (!(self.attr_m.attr_mod_count).equal?(@expected_mod_count))
                raise ConcurrentModificationException.new
              end
              # deleted entries are replaced by their successors
              if (!(@last_returned.attr_left).nil? && !(@last_returned.attr_right).nil?)
                @next = @last_returned
              end
              self.attr_m.delete_entry(@last_returned)
              @last_returned = nil
              @expected_mod_count = self.attr_m.attr_mod_count
            end
            
            typesig { [] }
            def remove_descending
              if ((@last_returned).nil?)
                raise IllegalStateException.new
              end
              if (!(self.attr_m.attr_mod_count).equal?(@expected_mod_count))
                raise ConcurrentModificationException.new
              end
              self.attr_m.delete_entry(@last_returned)
              @last_returned = nil
              @expected_mod_count = self.attr_m.attr_mod_count
            end
            
            private
            alias_method :initialize__sub_map_iterator, :initialize
          end }
          
          const_set_lazy(:SubMapEntryIterator) { Class.new(SubMapIterator) do
            extend LocalClass
            include_class_members NavigableSubMap
            
            typesig { [TreeMap::Entry, TreeMap::Entry] }
            def initialize(first, fence)
              super(first, fence)
            end
            
            typesig { [] }
            def next
              return next_entry
            end
            
            typesig { [] }
            def remove
              remove_ascending
            end
            
            private
            alias_method :initialize__sub_map_entry_iterator, :initialize
          end }
          
          const_set_lazy(:SubMapKeyIterator) { Class.new(SubMapIterator) do
            extend LocalClass
            include_class_members NavigableSubMap
            
            typesig { [TreeMap::Entry, TreeMap::Entry] }
            def initialize(first, fence)
              super(first, fence)
            end
            
            typesig { [] }
            def next
              return next_entry.attr_key
            end
            
            typesig { [] }
            def remove
              remove_ascending
            end
            
            private
            alias_method :initialize__sub_map_key_iterator, :initialize
          end }
          
          const_set_lazy(:DescendingSubMapEntryIterator) { Class.new(SubMapIterator) do
            extend LocalClass
            include_class_members NavigableSubMap
            
            typesig { [TreeMap::Entry, TreeMap::Entry] }
            def initialize(last, fence)
              super(last, fence)
            end
            
            typesig { [] }
            def next
              return prev_entry
            end
            
            typesig { [] }
            def remove
              remove_descending
            end
            
            private
            alias_method :initialize__descending_sub_map_entry_iterator, :initialize
          end }
          
          const_set_lazy(:DescendingSubMapKeyIterator) { Class.new(SubMapIterator) do
            extend LocalClass
            include_class_members NavigableSubMap
            
            typesig { [TreeMap::Entry, TreeMap::Entry] }
            def initialize(last, fence)
              super(last, fence)
            end
            
            typesig { [] }
            def next
              return prev_entry.attr_key
            end
            
            typesig { [] }
            def remove
              remove_descending
            end
            
            private
            alias_method :initialize__descending_sub_map_key_iterator, :initialize
          end }
        }
        
        private
        alias_method :initialize__navigable_sub_map, :initialize
      end }
      
      # @serial include
      const_set_lazy(:AscendingSubMap) { Class.new(NavigableSubMap) do
        include_class_members TreeMap
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 912986545866124060 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [TreeMap, ::Java::Boolean, Object, ::Java::Boolean, ::Java::Boolean, Object, ::Java::Boolean] }
        def initialize(m, from_start, lo, lo_inclusive, to_end, hi, hi_inclusive)
          super(m, from_start, lo, lo_inclusive, to_end, hi, hi_inclusive)
        end
        
        typesig { [] }
        def comparator
          return self.attr_m.comparator
        end
        
        typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
        def sub_map(from_key, from_inclusive, to_key, to_inclusive)
          if (!in_range(from_key, from_inclusive))
            raise IllegalArgumentException.new("fromKey out of range")
          end
          if (!in_range(to_key, to_inclusive))
            raise IllegalArgumentException.new("toKey out of range")
          end
          return AscendingSubMap.new(self.attr_m, false, from_key, from_inclusive, false, to_key, to_inclusive)
        end
        
        typesig { [Object, ::Java::Boolean] }
        def head_map(to_key, inclusive)
          if (!in_range(to_key, inclusive))
            raise IllegalArgumentException.new("toKey out of range")
          end
          return AscendingSubMap.new(self.attr_m, self.attr_from_start, self.attr_lo, self.attr_lo_inclusive, false, to_key, inclusive)
        end
        
        typesig { [Object, ::Java::Boolean] }
        def tail_map(from_key, inclusive)
          if (!in_range(from_key, inclusive))
            raise IllegalArgumentException.new("fromKey out of range")
          end
          return AscendingSubMap.new(self.attr_m, false, from_key, inclusive, self.attr_to_end, self.attr_hi, self.attr_hi_inclusive)
        end
        
        typesig { [] }
        def descending_map
          mv = self.attr_descending_map_view
          return (!(mv).nil?) ? mv : (self.attr_descending_map_view = DescendingSubMap.new(self.attr_m, self.attr_from_start, self.attr_lo, self.attr_lo_inclusive, self.attr_to_end, self.attr_hi, self.attr_hi_inclusive))
        end
        
        typesig { [] }
        def key_iterator
          return SubMapKeyIterator.new(abs_lowest, abs_high_fence)
        end
        
        typesig { [] }
        def descending_key_iterator
          return DescendingSubMapKeyIterator.new(abs_highest, abs_low_fence)
        end
        
        class_module.module_eval {
          const_set_lazy(:AscendingEntrySetView) { Class.new(EntrySetView) do
            extend LocalClass
            include_class_members AscendingSubMap
            
            typesig { [] }
            def iterator
              return SubMapEntryIterator.new(abs_lowest, abs_high_fence)
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__ascending_entry_set_view, :initialize
          end }
        }
        
        typesig { [] }
        def entry_set
          es = self.attr_entry_set_view
          return (!(es).nil?) ? es : AscendingEntrySetView.new_local(self)
        end
        
        typesig { [] }
        def sub_lowest
          return abs_lowest
        end
        
        typesig { [] }
        def sub_highest
          return abs_highest
        end
        
        typesig { [Object] }
        def sub_ceiling(key)
          return abs_ceiling(key)
        end
        
        typesig { [Object] }
        def sub_higher(key)
          return abs_higher(key)
        end
        
        typesig { [Object] }
        def sub_floor(key)
          return abs_floor(key)
        end
        
        typesig { [Object] }
        def sub_lower(key)
          return abs_lower(key)
        end
        
        private
        alias_method :initialize__ascending_sub_map, :initialize
      end }
      
      # @serial include
      const_set_lazy(:DescendingSubMap) { Class.new(NavigableSubMap) do
        include_class_members TreeMap
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 912986545866120460 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [TreeMap, ::Java::Boolean, Object, ::Java::Boolean, ::Java::Boolean, Object, ::Java::Boolean] }
        def initialize(m, from_start, lo, lo_inclusive, to_end, hi, hi_inclusive)
          @reverse_comparator = nil
          super(m, from_start, lo, lo_inclusive, to_end, hi, hi_inclusive)
          @reverse_comparator = Collections.reverse_order(m.attr_comparator)
        end
        
        attr_accessor :reverse_comparator
        alias_method :attr_reverse_comparator, :reverse_comparator
        undef_method :reverse_comparator
        alias_method :attr_reverse_comparator=, :reverse_comparator=
        undef_method :reverse_comparator=
        
        typesig { [] }
        def comparator
          return @reverse_comparator
        end
        
        typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
        def sub_map(from_key, from_inclusive, to_key, to_inclusive)
          if (!in_range(from_key, from_inclusive))
            raise IllegalArgumentException.new("fromKey out of range")
          end
          if (!in_range(to_key, to_inclusive))
            raise IllegalArgumentException.new("toKey out of range")
          end
          return DescendingSubMap.new(self.attr_m, false, to_key, to_inclusive, false, from_key, from_inclusive)
        end
        
        typesig { [Object, ::Java::Boolean] }
        def head_map(to_key, inclusive)
          if (!in_range(to_key, inclusive))
            raise IllegalArgumentException.new("toKey out of range")
          end
          return DescendingSubMap.new(self.attr_m, false, to_key, inclusive, self.attr_to_end, self.attr_hi, self.attr_hi_inclusive)
        end
        
        typesig { [Object, ::Java::Boolean] }
        def tail_map(from_key, inclusive)
          if (!in_range(from_key, inclusive))
            raise IllegalArgumentException.new("fromKey out of range")
          end
          return DescendingSubMap.new(self.attr_m, self.attr_from_start, self.attr_lo, self.attr_lo_inclusive, false, from_key, inclusive)
        end
        
        typesig { [] }
        def descending_map
          mv = self.attr_descending_map_view
          return (!(mv).nil?) ? mv : (self.attr_descending_map_view = AscendingSubMap.new(self.attr_m, self.attr_from_start, self.attr_lo, self.attr_lo_inclusive, self.attr_to_end, self.attr_hi, self.attr_hi_inclusive))
        end
        
        typesig { [] }
        def key_iterator
          return DescendingSubMapKeyIterator.new(abs_highest, abs_low_fence)
        end
        
        typesig { [] }
        def descending_key_iterator
          return SubMapKeyIterator.new(abs_lowest, abs_high_fence)
        end
        
        class_module.module_eval {
          const_set_lazy(:DescendingEntrySetView) { Class.new(EntrySetView) do
            extend LocalClass
            include_class_members DescendingSubMap
            
            typesig { [] }
            def iterator
              return DescendingSubMapEntryIterator.new(abs_highest, abs_low_fence)
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__descending_entry_set_view, :initialize
          end }
        }
        
        typesig { [] }
        def entry_set
          es = self.attr_entry_set_view
          return (!(es).nil?) ? es : DescendingEntrySetView.new_local(self)
        end
        
        typesig { [] }
        def sub_lowest
          return abs_highest
        end
        
        typesig { [] }
        def sub_highest
          return abs_lowest
        end
        
        typesig { [Object] }
        def sub_ceiling(key)
          return abs_floor(key)
        end
        
        typesig { [Object] }
        def sub_higher(key)
          return abs_lower(key)
        end
        
        typesig { [Object] }
        def sub_floor(key)
          return abs_ceiling(key)
        end
        
        typesig { [Object] }
        def sub_lower(key)
          return abs_higher(key)
        end
        
        private
        alias_method :initialize__descending_sub_map, :initialize
      end }
      
      # This class exists solely for the sake of serialization
      # compatibility with previous releases of TreeMap that did not
      # support NavigableMap.  It translates an old-version SubMap into
      # a new-version AscendingSubMap. This class is never otherwise
      # used.
      # 
      # @serial include
      const_set_lazy(:SubMap) { Class.new(AbstractMap) do
        extend LocalClass
        include_class_members TreeMap
        include SortedMap
        include Java::Io::Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -6520786458950516097 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :from_start
        alias_method :attr_from_start, :from_start
        undef_method :from_start
        alias_method :attr_from_start=, :from_start=
        undef_method :from_start=
        
        attr_accessor :to_end
        alias_method :attr_to_end, :to_end
        undef_method :to_end
        alias_method :attr_to_end=, :to_end=
        undef_method :to_end=
        
        attr_accessor :from_key
        alias_method :attr_from_key, :from_key
        undef_method :from_key
        alias_method :attr_from_key=, :from_key=
        undef_method :from_key=
        
        attr_accessor :to_key
        alias_method :attr_to_key, :to_key
        undef_method :to_key
        alias_method :attr_to_key=, :to_key=
        undef_method :to_key=
        
        typesig { [] }
        def read_resolve
          return AscendingSubMap.new(@local_class_parent, @from_start, @from_key, true, @to_end, @to_key, false)
        end
        
        typesig { [] }
        def entry_set
          raise InternalError.new
        end
        
        typesig { [] }
        def last_key
          raise InternalError.new
        end
        
        typesig { [] }
        def first_key
          raise InternalError.new
        end
        
        typesig { [K, K] }
        def sub_map(from_key, to_key)
          raise InternalError.new
        end
        
        typesig { [K] }
        def head_map(to_key)
          raise InternalError.new
        end
        
        typesig { [K] }
        def tail_map(from_key)
          raise InternalError.new
        end
        
        typesig { [] }
        def comparator
          raise InternalError.new
        end
        
        typesig { [] }
        def initialize
          @from_start = false
          @to_end = false
          @from_key = nil
          @to_key = nil
          super()
          @from_start = false
          @to_end = false
        end
        
        private
        alias_method :initialize__sub_map, :initialize
      end }
      
      # Red-black mechanics
      const_set_lazy(:RED) { false }
      const_attr_reader  :RED
      
      const_set_lazy(:BLACK) { true }
      const_attr_reader  :BLACK
      
      # Node in the Tree.  Doubles as a means to pass key-value pairs back to
      # user (see Map.Entry).
      const_set_lazy(:Entry) { Class.new do
        include_class_members TreeMap
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
        
        attr_accessor :left
        alias_method :attr_left, :left
        undef_method :left
        alias_method :attr_left=, :left=
        undef_method :left=
        
        attr_accessor :right
        alias_method :attr_right, :right
        undef_method :right
        alias_method :attr_right=, :right=
        undef_method :right=
        
        attr_accessor :parent
        alias_method :attr_parent, :parent
        undef_method :parent
        alias_method :attr_parent=, :parent=
        undef_method :parent=
        
        attr_accessor :color
        alias_method :attr_color, :color
        undef_method :color
        alias_method :attr_color=, :color=
        undef_method :color=
        
        typesig { [Object, Object, Entry] }
        # Make a new cell with given key, value, and parent, and with
        # <tt>null</tt> child links, and BLACK color.
        def initialize(key, value, parent)
          @key = nil
          @value = nil
          @left = nil
          @right = nil
          @parent = nil
          @color = BLACK
          @key = key
          @value = value
          @parent = parent
        end
        
        typesig { [] }
        # Returns the key.
        # 
        # @return the key
        def get_key
          return @key
        end
        
        typesig { [] }
        # Returns the value associated with the key.
        # 
        # @return the value associated with the key
        def get_value
          return @value
        end
        
        typesig { [Object] }
        # Replaces the value currently associated with the key with the given
        # value.
        # 
        # @return the value associated with the key before this method was
        # called
        def set_value(value)
          old_value = @value
          @value = value
          return old_value
        end
        
        typesig { [Object] }
        def equals(o)
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          e = o
          return val_equals(@key, e.get_key) && val_equals(@value, e.get_value)
        end
        
        typesig { [] }
        def hash_code
          key_hash = ((@key).nil? ? 0 : @key.hash_code)
          value_hash = ((@value).nil? ? 0 : @value.hash_code)
          return key_hash ^ value_hash
        end
        
        typesig { [] }
        def to_s
          return (@key).to_s + "=" + (@value).to_s
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
    }
    
    typesig { [] }
    # Returns the first Entry in the TreeMap (according to the TreeMap's
    # key-sort function).  Returns null if the TreeMap is empty.
    def get_first_entry
      p = @root
      if (!(p).nil?)
        while (!(p.attr_left).nil?)
          p = p.attr_left
        end
      end
      return p
    end
    
    typesig { [] }
    # Returns the last Entry in the TreeMap (according to the TreeMap's
    # key-sort function).  Returns null if the TreeMap is empty.
    def get_last_entry
      p = @root
      if (!(p).nil?)
        while (!(p.attr_right).nil?)
          p = p.attr_right
        end
      end
      return p
    end
    
    class_module.module_eval {
      typesig { [Entry] }
      # Returns the successor of the specified Entry, or null if no such.
      def successor(t)
        if ((t).nil?)
          return nil
        else
          if (!(t.attr_right).nil?)
            p = t.attr_right
            while (!(p.attr_left).nil?)
              p = p.attr_left
            end
            return p
          else
            p = t.attr_parent
            ch = t
            while (!(p).nil? && (ch).equal?(p.attr_right))
              ch = p
              p = p.attr_parent
            end
            return p
          end
        end
      end
      
      typesig { [Entry] }
      # Returns the predecessor of the specified Entry, or null if no such.
      def predecessor(t)
        if ((t).nil?)
          return nil
        else
          if (!(t.attr_left).nil?)
            p = t.attr_left
            while (!(p.attr_right).nil?)
              p = p.attr_right
            end
            return p
          else
            p = t.attr_parent
            ch = t
            while (!(p).nil? && (ch).equal?(p.attr_left))
              ch = p
              p = p.attr_parent
            end
            return p
          end
        end
      end
      
      typesig { [Entry] }
      # Balancing operations.
      # 
      # Implementations of rebalancings during insertion and deletion are
      # slightly different than the CLR version.  Rather than using dummy
      # nilnodes, we use a set of accessors that deal properly with null.  They
      # are used to avoid messiness surrounding nullness checks in the main
      # algorithms.
      def color_of(p)
        return ((p).nil? ? BLACK : p.attr_color)
      end
      
      typesig { [Entry] }
      def parent_of(p)
        return ((p).nil? ? nil : p.attr_parent)
      end
      
      typesig { [Entry, ::Java::Boolean] }
      def set_color(p, c)
        if (!(p).nil?)
          p.attr_color = c
        end
      end
      
      typesig { [Entry] }
      def left_of(p)
        return ((p).nil?) ? nil : p.attr_left
      end
      
      typesig { [Entry] }
      def right_of(p)
        return ((p).nil?) ? nil : p.attr_right
      end
    }
    
    typesig { [Entry] }
    # From CLR
    def rotate_left(p)
      if (!(p).nil?)
        r = p.attr_right
        p.attr_right = r.attr_left
        if (!(r.attr_left).nil?)
          r.attr_left.attr_parent = p
        end
        r.attr_parent = p.attr_parent
        if ((p.attr_parent).nil?)
          @root = r
        else
          if ((p.attr_parent.attr_left).equal?(p))
            p.attr_parent.attr_left = r
          else
            p.attr_parent.attr_right = r
          end
        end
        r.attr_left = p
        p.attr_parent = r
      end
    end
    
    typesig { [Entry] }
    # From CLR
    def rotate_right(p)
      if (!(p).nil?)
        l = p.attr_left
        p.attr_left = l.attr_right
        if (!(l.attr_right).nil?)
          l.attr_right.attr_parent = p
        end
        l.attr_parent = p.attr_parent
        if ((p.attr_parent).nil?)
          @root = l
        else
          if ((p.attr_parent.attr_right).equal?(p))
            p.attr_parent.attr_right = l
          else
            p.attr_parent.attr_left = l
          end
        end
        l.attr_right = p
        p.attr_parent = l
      end
    end
    
    typesig { [Entry] }
    # From CLR
    def fix_after_insertion(x)
      x.attr_color = RED
      while (!(x).nil? && !(x).equal?(@root) && (x.attr_parent.attr_color).equal?(RED))
        if ((parent_of(x)).equal?(left_of(parent_of(parent_of(x)))))
          y = right_of(parent_of(parent_of(x)))
          if ((color_of(y)).equal?(RED))
            set_color(parent_of(x), BLACK)
            set_color(y, BLACK)
            set_color(parent_of(parent_of(x)), RED)
            x = parent_of(parent_of(x))
          else
            if ((x).equal?(right_of(parent_of(x))))
              x = parent_of(x)
              rotate_left(x)
            end
            set_color(parent_of(x), BLACK)
            set_color(parent_of(parent_of(x)), RED)
            rotate_right(parent_of(parent_of(x)))
          end
        else
          y = left_of(parent_of(parent_of(x)))
          if ((color_of(y)).equal?(RED))
            set_color(parent_of(x), BLACK)
            set_color(y, BLACK)
            set_color(parent_of(parent_of(x)), RED)
            x = parent_of(parent_of(x))
          else
            if ((x).equal?(left_of(parent_of(x))))
              x = parent_of(x)
              rotate_right(x)
            end
            set_color(parent_of(x), BLACK)
            set_color(parent_of(parent_of(x)), RED)
            rotate_left(parent_of(parent_of(x)))
          end
        end
      end
      @root.attr_color = BLACK
    end
    
    typesig { [Entry] }
    # Delete node p, and then rebalance the tree.
    def delete_entry(p)
      @mod_count += 1
      @size -= 1
      # If strictly internal, copy successor's element to p and then make p
      # point to successor.
      if (!(p.attr_left).nil? && !(p.attr_right).nil?)
        s = successor(p)
        p.attr_key = s.attr_key
        p.attr_value = s.attr_value
        p = s
      end # p has 2 children
      # Start fixup at replacement node, if it exists.
      replacement = (!(p.attr_left).nil? ? p.attr_left : p.attr_right)
      if (!(replacement).nil?)
        # Link replacement to parent
        replacement.attr_parent = p.attr_parent
        if ((p.attr_parent).nil?)
          @root = replacement
        else
          if ((p).equal?(p.attr_parent.attr_left))
            p.attr_parent.attr_left = replacement
          else
            p.attr_parent.attr_right = replacement
          end
        end
        # Null out links so they are OK to use by fixAfterDeletion.
        p.attr_left = p.attr_right = p.attr_parent = nil
        # Fix replacement
        if ((p.attr_color).equal?(BLACK))
          fix_after_deletion(replacement)
        end
      else
        if ((p.attr_parent).nil?)
          # return if we are the only node.
          @root = nil
        else
          # No children. Use self as phantom replacement and unlink.
          if ((p.attr_color).equal?(BLACK))
            fix_after_deletion(p)
          end
          if (!(p.attr_parent).nil?)
            if ((p).equal?(p.attr_parent.attr_left))
              p.attr_parent.attr_left = nil
            else
              if ((p).equal?(p.attr_parent.attr_right))
                p.attr_parent.attr_right = nil
              end
            end
            p.attr_parent = nil
          end
        end
      end
    end
    
    typesig { [Entry] }
    # From CLR
    def fix_after_deletion(x)
      while (!(x).equal?(@root) && (color_of(x)).equal?(BLACK))
        if ((x).equal?(left_of(parent_of(x))))
          sib = right_of(parent_of(x))
          if ((color_of(sib)).equal?(RED))
            set_color(sib, BLACK)
            set_color(parent_of(x), RED)
            rotate_left(parent_of(x))
            sib = right_of(parent_of(x))
          end
          if ((color_of(left_of(sib))).equal?(BLACK) && (color_of(right_of(sib))).equal?(BLACK))
            set_color(sib, RED)
            x = parent_of(x)
          else
            if ((color_of(right_of(sib))).equal?(BLACK))
              set_color(left_of(sib), BLACK)
              set_color(sib, RED)
              rotate_right(sib)
              sib = right_of(parent_of(x))
            end
            set_color(sib, color_of(parent_of(x)))
            set_color(parent_of(x), BLACK)
            set_color(right_of(sib), BLACK)
            rotate_left(parent_of(x))
            x = @root
          end
        else
          # symmetric
          sib = left_of(parent_of(x))
          if ((color_of(sib)).equal?(RED))
            set_color(sib, BLACK)
            set_color(parent_of(x), RED)
            rotate_right(parent_of(x))
            sib = left_of(parent_of(x))
          end
          if ((color_of(right_of(sib))).equal?(BLACK) && (color_of(left_of(sib))).equal?(BLACK))
            set_color(sib, RED)
            x = parent_of(x)
          else
            if ((color_of(left_of(sib))).equal?(BLACK))
              set_color(right_of(sib), BLACK)
              set_color(sib, RED)
              rotate_left(sib)
              sib = left_of(parent_of(x))
            end
            set_color(sib, color_of(parent_of(x)))
            set_color(parent_of(x), BLACK)
            set_color(left_of(sib), BLACK)
            rotate_right(parent_of(x))
            x = @root
          end
        end
      end
      set_color(x, BLACK)
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 919286545866124006 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the <tt>TreeMap</tt> instance to a stream (i.e.,
    # serialize it).
    # 
    # @serialData The <i>size</i> of the TreeMap (the number of key-value
    # mappings) is emitted (int), followed by the key (Object)
    # and value (Object) for each key-value mapping represented
    # by the TreeMap. The key-value mappings are emitted in
    # key-order (as determined by the TreeMap's Comparator,
    # or by the keys' natural ordering if the TreeMap has no
    # Comparator).
    def write_object(s)
      # Write out the Comparator and any hidden stuff
      s.default_write_object
      # Write out size (number of Mappings)
      s.write_int(@size)
      # Write out keys and values (alternating)
      i = entry_set.iterator
      while i.has_next
        e = i.next
        s.write_object(e.get_key)
        s.write_object(e.get_value)
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the <tt>TreeMap</tt> instance from a stream (i.e.,
    # deserialize it).
    def read_object(s)
      # Read in the Comparator and any hidden stuff
      s.default_read_object
      # Read in size
      size_ = s.read_int
      build_from_sorted(size_, nil, s, nil)
    end
    
    typesig { [::Java::Int, Java::Io::ObjectInputStream, Object] }
    # Intended to be called only from TreeSet.readObject
    def read_tree_set(size_, s, default_val)
      build_from_sorted(size_, nil, s, default_val)
    end
    
    typesig { [SortedSet, Object] }
    # Intended to be called only from TreeSet.addAll
    def add_all_for_tree_set(set, default_val)
      begin
        build_from_sorted(set.size, set.iterator, nil, default_val)
      rescue Java::Io::IOException => cannot_happen
      rescue ClassNotFoundException => cannot_happen
      end
    end
    
    typesig { [::Java::Int, Iterator, Java::Io::ObjectInputStream, Object] }
    # Linear time tree building algorithm from sorted data.  Can accept keys
    # and/or values from iterator or stream. This leads to too many
    # parameters, but seems better than alternatives.  The four formats
    # that this method accepts are:
    # 
    # 1) An iterator of Map.Entries.  (it != null, defaultVal == null).
    # 2) An iterator of keys.         (it != null, defaultVal != null).
    # 3) A stream of alternating serialized keys and values.
    # (it == null, defaultVal == null).
    # 4) A stream of serialized keys. (it == null, defaultVal != null).
    # 
    # It is assumed that the comparator of the TreeMap is already set prior
    # to calling this method.
    # 
    # @param size the number of keys (or key-value pairs) to be read from
    # the iterator or stream
    # @param it If non-null, new entries are created from entries
    # or keys read from this iterator.
    # @param str If non-null, new entries are created from keys and
    # possibly values read from this stream in serialized form.
    # Exactly one of it and str should be non-null.
    # @param defaultVal if non-null, this default value is used for
    # each value in the map.  If null, each value is read from
    # iterator or stream, as described above.
    # @throws IOException propagated from stream reads. This cannot
    # occur if str is null.
    # @throws ClassNotFoundException propagated from readObject.
    # This cannot occur if str is null.
    def build_from_sorted(size_, it, str, default_val)
      @size = size_
      @root = build_from_sorted(0, 0, size_ - 1, compute_red_level(size_), it, str, default_val)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, Iterator, Java::Io::ObjectInputStream, Object] }
    # Recursive "helper method" that does the real work of the
    # previous method.  Identically named parameters have
    # identical definitions.  Additional parameters are documented below.
    # It is assumed that the comparator and size fields of the TreeMap are
    # already set prior to calling this method.  (It ignores both fields.)
    # 
    # @param level the current level of tree. Initial call should be 0.
    # @param lo the first element index of this subtree. Initial should be 0.
    # @param hi the last element index of this subtree.  Initial should be
    # size-1.
    # @param redLevel the level at which nodes should be red.
    # Must be equal to computeRedLevel for tree of this size.
    def build_from_sorted(level, lo, hi, red_level, it, str, default_val)
      # Strategy: The root is the middlemost element. To get to it, we
      # have to first recursively construct the entire left subtree,
      # so as to grab all of its elements. We can then proceed with right
      # subtree.
      # 
      # The lo and hi arguments are the minimum and maximum
      # indices to pull out of the iterator or stream for current subtree.
      # They are not actually indexed, we just proceed sequentially,
      # ensuring that items are extracted in corresponding order.
      if (hi < lo)
        return nil
      end
      mid = (lo + hi) >> 1
      left = nil
      if (lo < mid)
        left = build_from_sorted(level + 1, lo, mid - 1, red_level, it, str, default_val)
      end
      # extract key and/or value from iterator or stream
      key_ = nil
      value = nil
      if (!(it).nil?)
        if ((default_val).nil?)
          entry = it.next
          key_ = entry.get_key
          value = entry.get_value
        else
          key_ = it.next
          value = default_val
        end
      else
        # use stream
        key_ = str.read_object
        value = (!(default_val).nil? ? default_val : str.read_object)
      end
      middle = Entry.new(key_, value, nil)
      # color nodes in non-full bottommost level red
      if ((level).equal?(red_level))
        middle.attr_color = RED
      end
      if (!(left).nil?)
        middle.attr_left = left
        left.attr_parent = middle
      end
      if (mid < hi)
        right = build_from_sorted(level + 1, mid + 1, hi, red_level, it, str, default_val)
        middle.attr_right = right
        right.attr_parent = middle
      end
      return middle
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Find the level down to which to assign all nodes BLACK.  This is the
      # last `full' level of the complete binary tree produced by
      # buildTree. The remaining nodes are colored RED. (This makes a `nice'
      # set of color assignments wrt future insertions.) This level number is
      # computed by finding the number of splits needed to reach the zeroeth
      # node.  (The answer is ~lg(N), but in any case must be computed by same
      # quick O(lg(N)) loop.)
      def compute_red_level(sz)
        level = 0
        m = sz - 1
        while m >= 0
          level += 1
          m = m / 2 - 1
        end
        return level
      end
    }
    
    private
    alias_method :initialize__tree_map, :initialize
  end
  
end
