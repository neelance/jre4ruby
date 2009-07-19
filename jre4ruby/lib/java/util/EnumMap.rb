require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EnumMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Util::Map, :Entry
      include_const ::Sun::Misc, :SharedSecrets
    }
  end
  
  # A specialized {@link Map} implementation for use with enum type keys.  All
  # of the keys in an enum map must come from a single enum type that is
  # specified, explicitly or implicitly, when the map is created.  Enum maps
  # are represented internally as arrays.  This representation is extremely
  # compact and efficient.
  # 
  # <p>Enum maps are maintained in the <i>natural order</i> of their keys
  # (the order in which the enum constants are declared).  This is reflected
  # in the iterators returned by the collections views ({@link #keySet()},
  # {@link #entrySet()}, and {@link #values()}).
  # 
  # <p>Iterators returned by the collection views are <i>weakly consistent</i>:
  # they will never throw {@link ConcurrentModificationException} and they may
  # or may not show the effects of any modifications to the map that occur while
  # the iteration is in progress.
  # 
  # <p>Null keys are not permitted.  Attempts to insert a null key will
  # throw {@link NullPointerException}.  Attempts to test for the
  # presence of a null key or to remove one will, however, function properly.
  # Null values are permitted.
  # 
  # <P>Like most collection implementations <tt>EnumMap</tt> is not
  # synchronized. If multiple threads access an enum map concurrently, and at
  # least one of the threads modifies the map, it should be synchronized
  # externally.  This is typically accomplished by synchronizing on some
  # object that naturally encapsulates the enum map.  If no such object exists,
  # the map should be "wrapped" using the {@link Collections#synchronizedMap}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access:
  # 
  # <pre>
  # Map&lt;EnumKey, V&gt; m
  # = Collections.synchronizedMap(new EnumMap&lt;EnumKey, V&gt;(...));
  # </pre>
  # 
  # <p>Implementation note: All basic operations execute in constant time.
  # They are likely (though not guaranteed) to be faster than their
  # {@link HashMap} counterparts.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author Josh Bloch
  # @see EnumSet
  # @since 1.5
  class EnumMap < EnumMapImports.const_get :AbstractMap
    include_class_members EnumMapImports
    include Java::Io::Serializable
    include Cloneable
    
    # The <tt>Class</tt> object for the enum type of all the keys of this map.
    # 
    # @serial
    attr_accessor :key_type
    alias_method :attr_key_type, :key_type
    undef_method :key_type
    alias_method :attr_key_type=, :key_type=
    undef_method :key_type=
    
    # All of the values comprising K.  (Cached for performance.)
    attr_accessor :key_universe
    alias_method :attr_key_universe, :key_universe
    undef_method :key_universe
    alias_method :attr_key_universe=, :key_universe=
    undef_method :key_universe=
    
    # Array representation of this map.  The ith element is the value
    # to which universe[i] is currently mapped, or null if it isn't
    # mapped to anything, or NULL if it's mapped to null.
    attr_accessor :vals
    alias_method :attr_vals, :vals
    undef_method :vals
    alias_method :attr_vals=, :vals=
    undef_method :vals=
    
    # The number of mappings in this map.
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    class_module.module_eval {
      # Distinguished non-null value for representing null values.
      const_set_lazy(:NULL) { Object.new }
      const_attr_reader  :NULL
    }
    
    typesig { [Object] }
    def mask_null(value)
      return ((value).nil? ? NULL : value)
    end
    
    typesig { [Object] }
    def unmask_null(value)
      return ((value).equal?(NULL) ? nil : value)
    end
    
    class_module.module_eval {
      
      def zero_length_enum_array
        defined?(@@zero_length_enum_array) ? @@zero_length_enum_array : @@zero_length_enum_array= Array.typed(Enum).new(0) { nil }
      end
      alias_method :attr_zero_length_enum_array, :zero_length_enum_array
      
      def zero_length_enum_array=(value)
        @@zero_length_enum_array = value
      end
      alias_method :attr_zero_length_enum_array=, :zero_length_enum_array=
    }
    
    typesig { [Class] }
    # Creates an empty enum map with the specified key type.
    # 
    # @param keyType the class object of the key type for this enum map
    # @throws NullPointerException if <tt>keyType</tt> is null
    def initialize(key_type)
      @key_type = nil
      @key_universe = nil
      @vals = nil
      @size = 0
      @entry_set = nil
      super()
      @size = 0
      @entry_set = nil
      @key_type = key_type
      @key_universe = get_key_universe(key_type)
      @vals = Array.typed(Object).new(@key_universe.attr_length) { nil }
    end
    
    typesig { [EnumMap] }
    # Creates an enum map with the same key type as the specified enum
    # map, initially containing the same mappings (if any).
    # 
    # @param m the enum map from which to initialize this enum map
    # @throws NullPointerException if <tt>m</tt> is null
    def initialize(m)
      @key_type = nil
      @key_universe = nil
      @vals = nil
      @size = 0
      @entry_set = nil
      super()
      @size = 0
      @entry_set = nil
      @key_type = m.attr_key_type
      @key_universe = m.attr_key_universe
      @vals = m.attr_vals.clone
      @size = m.attr_size
    end
    
    typesig { [Map] }
    # Creates an enum map initialized from the specified map.  If the
    # specified map is an <tt>EnumMap</tt> instance, this constructor behaves
    # identically to {@link #EnumMap(EnumMap)}.  Otherwise, the specified map
    # must contain at least one mapping (in order to determine the new
    # enum map's key type).
    # 
    # @param m the map from which to initialize this enum map
    # @throws IllegalArgumentException if <tt>m</tt> is not an
    # <tt>EnumMap</tt> instance and contains no mappings
    # @throws NullPointerException if <tt>m</tt> is null
    def initialize(m)
      @key_type = nil
      @key_universe = nil
      @vals = nil
      @size = 0
      @entry_set = nil
      super()
      @size = 0
      @entry_set = nil
      if (m.is_a?(EnumMap))
        em = m
        @key_type = em.attr_key_type
        @key_universe = em.attr_key_universe
        @vals = em.attr_vals.clone
        @size = em.attr_size
      else
        if (m.is_empty)
          raise IllegalArgumentException.new("Specified map is empty")
        end
        @key_type = m.key_set.iterator.next.get_declaring_class
        @key_universe = get_key_universe(@key_type)
        @vals = Array.typed(Object).new(@key_universe.attr_length) { nil }
        put_all(m)
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
    # Returns <tt>true</tt> if this map maps one or more keys to the
    # specified value.
    # 
    # @param value the value whose presence in this map is to be tested
    # @return <tt>true</tt> if this map maps one or more keys to this value
    def contains_value(value)
      value = mask_null(value)
      @vals.each do |val|
        if ((value == val))
          return true
        end
      end
      return false
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map contains a mapping for the specified
    # key.
    # 
    # @param key the key whose presence in this map is to be tested
    # @return <tt>true</tt> if this map contains a mapping for the specified
    # key
    def contains_key(key)
      return is_valid_key(key) && !(@vals[(key).ordinal]).nil?
    end
    
    typesig { [Object, Object] }
    def contains_mapping(key, value)
      return is_valid_key(key) && (mask_null(value) == @vals[(key).ordinal])
    end
    
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
    def get(key)
      return (is_valid_key(key) ? unmask_null(@vals[(key).ordinal]) : nil)
    end
    
    typesig { [Object, Object] }
    # Modification Operations
    # 
    # Associates the specified value with the specified key in this map.
    # If the map previously contained a mapping for this key, the old
    # value is replaced.
    # 
    # @param key the key with which the specified value is to be associated
    # @param value the value to be associated with the specified key
    # 
    # @return the previous value associated with specified key, or
    # <tt>null</tt> if there was no mapping for key.  (A <tt>null</tt>
    # return can also indicate that the map previously associated
    # <tt>null</tt> with the specified key.)
    # @throws NullPointerException if the specified key is null
    def put(key, value)
      type_check(key)
      index = (key).ordinal
      old_value = @vals[index]
      @vals[index] = mask_null(value)
      if ((old_value).nil?)
        ((@size += 1) - 1)
      end
      return unmask_null(old_value)
    end
    
    typesig { [Object] }
    # Removes the mapping for this key from this map if present.
    # 
    # @param key the key whose mapping is to be removed from the map
    # @return the previous value associated with specified key, or
    # <tt>null</tt> if there was no entry for key.  (A <tt>null</tt>
    # return can also indicate that the map previously associated
    # <tt>null</tt> with the specified key.)
    def remove(key)
      if (!is_valid_key(key))
        return nil
      end
      index = (key).ordinal
      old_value = @vals[index]
      @vals[index] = nil
      if (!(old_value).nil?)
        ((@size -= 1) + 1)
      end
      return unmask_null(old_value)
    end
    
    typesig { [Object, Object] }
    def remove_mapping(key, value)
      if (!is_valid_key(key))
        return false
      end
      index = (key).ordinal
      if ((mask_null(value) == @vals[index]))
        @vals[index] = nil
        ((@size -= 1) + 1)
        return true
      end
      return false
    end
    
    typesig { [Object] }
    # Returns true if key is of the proper type to be a key in this
    # enum map.
    def is_valid_key(key)
      if ((key).nil?)
        return false
      end
      # Cheaper than instanceof Enum followed by getDeclaringClass
      key_class = key.get_class
      return (key_class).equal?(@key_type) || (key_class.get_superclass).equal?(@key_type)
    end
    
    typesig { [Map] }
    # Bulk Operations
    # 
    # Copies all of the mappings from the specified map to this map.
    # These mappings will replace any mappings that this map had for
    # any of the keys currently in the specified map.
    # 
    # @param m the mappings to be stored in this map
    # @throws NullPointerException the specified map is null, or if
    # one or more keys in the specified map are null
    def put_all(m)
      if (m.is_a?(EnumMap))
        em = m
        if (!(em.attr_key_type).equal?(@key_type))
          if (em.is_empty)
            return
          end
          raise ClassCastException.new((em.attr_key_type).to_s + " != " + (@key_type).to_s)
        end
        i = 0
        while i < @key_universe.attr_length
          em_value = em.attr_vals[i]
          if (!(em_value).nil?)
            if ((@vals[i]).nil?)
              ((@size += 1) - 1)
            end
            @vals[i] = em_value
          end
          ((i += 1) - 1)
        end
      else
        super(m)
      end
    end
    
    typesig { [] }
    # Removes all mappings from this map.
    def clear
      Arrays.fill(@vals, nil)
      @size = 0
    end
    
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
    # Returns a {@link Set} view of the keys contained in this map.
    # The returned set obeys the general contract outlined in
    # {@link Map#keySet()}.  The set's iterator will return the keys
    # in their natural order (the order in which the enum constants
    # are declared).
    # 
    # @return a set view of the keys contained in this enum map
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
        include_class_members EnumMap
        
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
    # The returned collection obeys the general contract outlined in
    # {@link Map#values()}.  The collection's iterator will return the
    # values in the order their corresponding keys appear in map,
    # which is their natural order (the order in which the enum constants
    # are declared).
    # 
    # @return a collection view of the values contained in this map
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
        include_class_members EnumMap
        
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
          o = mask_null(o)
          i = 0
          while i < self.attr_vals.attr_length
            if ((o == self.attr_vals[i]))
              self.attr_vals[i] = nil
              ((self.attr_size -= 1) + 1)
              return true
            end
            ((i += 1) - 1)
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
    # The returned set obeys the general contract outlined in
    # {@link Map#keySet()}.  The set's iterator will return the
    # mappings in the order their keys appear in map, which is their
    # natural order (the order in which the enum constants are declared).
    # 
    # @return a set view of the mappings contained in this enum map
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
        include_class_members EnumMap
        
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
        
        typesig { [] }
        def to_array
          return fill_entry_array(Array.typed(Object).new(self.attr_size) { nil })
        end
        
        typesig { [Array.typed(T)] }
        def to_array(a)
          size_ = size
          if (a.attr_length < size_)
            a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, size_)
          end
          if (a.attr_length > size_)
            a[size_] = nil
          end
          return fill_entry_array(a)
        end
        
        typesig { [Array.typed(Object)] }
        def fill_entry_array(a)
          j = 0
          i = 0
          while i < self.attr_vals.attr_length
            if (!(self.attr_vals[i]).nil?)
              a[((j += 1) - 1)] = AbstractMap::SimpleEntry.new(self.attr_key_universe[i], unmask_null(self.attr_vals[i]))
            end
            ((i += 1) - 1)
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
      
      const_set_lazy(:EnumMapIterator) { Class.new do
        extend LocalClass
        include_class_members EnumMap
        include Iterator
        
        # Lower bound on index of next element to return
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        # Index of last returned element, or -1 if none
        attr_accessor :last_returned_index
        alias_method :attr_last_returned_index, :last_returned_index
        undef_method :last_returned_index
        alias_method :attr_last_returned_index=, :last_returned_index=
        undef_method :last_returned_index=
        
        typesig { [] }
        def has_next
          while (@index < self.attr_vals.attr_length && (self.attr_vals[@index]).nil?)
            ((@index += 1) - 1)
          end
          return !(@index).equal?(self.attr_vals.attr_length)
        end
        
        typesig { [] }
        def remove
          check_last_returned_index
          if (!(self.attr_vals[@last_returned_index]).nil?)
            self.attr_vals[@last_returned_index] = nil
            ((self.attr_size -= 1) + 1)
          end
          @last_returned_index = -1
        end
        
        typesig { [] }
        def check_last_returned_index
          if (@last_returned_index < 0)
            raise IllegalStateException.new
          end
        end
        
        typesig { [] }
        def initialize
          @index = 0
          @last_returned_index = -1
        end
        
        private
        alias_method :initialize__enum_map_iterator, :initialize
      end }
      
      const_set_lazy(:KeyIterator) { Class.new(EnumMapIterator) do
        extend LocalClass
        include_class_members EnumMap
        
        typesig { [] }
        def next
          if (!has_next)
            raise NoSuchElementException.new
          end
          self.attr_last_returned_index = ((self.attr_index += 1) - 1)
          return self.attr_key_universe[self.attr_last_returned_index]
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__key_iterator, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(EnumMapIterator) do
        extend LocalClass
        include_class_members EnumMap
        
        typesig { [] }
        def next
          if (!has_next)
            raise NoSuchElementException.new
          end
          self.attr_last_returned_index = ((self.attr_index += 1) - 1)
          return unmask_null(self.attr_vals[self.attr_last_returned_index])
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__value_iterator, :initialize
      end }
      
      # Since we don't use Entry objects, we use the Iterator itself as entry.
      const_set_lazy(:EntryIterator) { Class.new(EnumMapIterator) do
        extend LocalClass
        include_class_members EnumMap
        include Map::Entry
        
        typesig { [] }
        def next
          if (!has_next)
            raise NoSuchElementException.new
          end
          self.attr_last_returned_index = ((self.attr_index += 1) - 1)
          return self
        end
        
        typesig { [] }
        def get_key
          check_last_returned_index_for_entry_use
          return self.attr_key_universe[self.attr_last_returned_index]
        end
        
        typesig { [] }
        def get_value
          check_last_returned_index_for_entry_use
          return unmask_null(self.attr_vals[self.attr_last_returned_index])
        end
        
        typesig { [V] }
        def set_value(value)
          check_last_returned_index_for_entry_use
          old_value = unmask_null(self.attr_vals[self.attr_last_returned_index])
          self.attr_vals[self.attr_last_returned_index] = mask_null(value)
          return old_value
        end
        
        typesig { [Object] }
        def equals(o)
          if (self.attr_last_returned_index < 0)
            return (o).equal?(self)
          end
          if (!(o.is_a?(Map::Entry)))
            return false
          end
          e = o
          our_value = unmask_null(self.attr_vals[self.attr_last_returned_index])
          his_value = e.get_value
          return (e.get_key).equal?(self.attr_key_universe[self.attr_last_returned_index]) && ((our_value).equal?(his_value) || (!(our_value).nil? && (our_value == his_value)))
        end
        
        typesig { [] }
        def hash_code
          if (self.attr_last_returned_index < 0)
            return super
          end
          value = self.attr_vals[self.attr_last_returned_index]
          return self.attr_key_universe[self.attr_last_returned_index].hash_code ^ ((value).equal?(NULL) ? 0 : value.hash_code)
        end
        
        typesig { [] }
        def to_s
          if (self.attr_last_returned_index < 0)
            return super
          end
          return (self.attr_key_universe[self.attr_last_returned_index]).to_s + "=" + (unmask_null(self.attr_vals[self.attr_last_returned_index])).to_s
        end
        
        typesig { [] }
        def check_last_returned_index_for_entry_use
          if (self.attr_last_returned_index < 0)
            raise IllegalStateException.new("Entry was removed")
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_iterator, :initialize
      end }
    }
    
    typesig { [Object] }
    # Comparison and hashing
    # 
    # Compares the specified object with this map for equality.  Returns
    # <tt>true</tt> if the given object is also a map and the two maps
    # represent the same mappings, as specified in the {@link
    # Map#equals(Object)} contract.
    # 
    # @param o the object to be compared for equality with this map
    # @return <tt>true</tt> if the specified object is equal to this map
    def equals(o)
      if (!(o.is_a?(EnumMap)))
        return super(o)
      end
      em = o
      if (!(em.attr_key_type).equal?(@key_type))
        return (@size).equal?(0) && (em.attr_size).equal?(0)
      end
      # Key types match, compare each value
      i = 0
      while i < @key_universe.attr_length
        our_value = @vals[i]
        his_value = em.attr_vals[i]
        if (!(his_value).equal?(our_value) && ((his_value).nil? || !(his_value == our_value)))
          return false
        end
        ((i += 1) - 1)
      end
      return true
    end
    
    typesig { [] }
    # Returns a shallow copy of this enum map.  (The values themselves
    # are not cloned.
    # 
    # @return a shallow copy of this enum map
    def clone
      result = nil
      begin
        result = super
      rescue CloneNotSupportedException => e
        raise AssertionError.new
      end
      result.attr_vals = result.attr_vals.clone
      return result
    end
    
    typesig { [Object] }
    # Throws an exception if e is not of the correct type for this enum set.
    def type_check(key)
      key_class = key.get_class
      if (!(key_class).equal?(@key_type) && !(key_class.get_superclass).equal?(@key_type))
        raise ClassCastException.new((key_class).to_s + " != " + (@key_type).to_s)
      end
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # Returns all of the values comprising K.
      # The result is uncloned, cached, and shared by all callers.
      def get_key_universe(key_type)
        return SharedSecrets.get_java_lang_access.get_enum_constants_shared(key_type)
      end
      
      const_set_lazy(:SerialVersionUID) { 458661240069192865 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the <tt>EnumMap</tt> instance to a stream (i.e.,
    # serialize it).
    # 
    # @serialData The <i>size</i> of the enum map (the number of key-value
    # mappings) is emitted (int), followed by the key (Object)
    # and value (Object) for each key-value mapping represented
    # by the enum map.
    def write_object(s)
      # Write out the key type and any hidden stuff
      s.default_write_object
      # Write out size (number of Mappings)
      s.write_int(@size)
      # Write out keys and values (alternating)
      entry_set.each do |e|
        s.write_object(e.get_key)
        s.write_object(e.get_value)
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the <tt>EnumMap</tt> instance from a stream (i.e.,
    # deserialize it).
    def read_object(s)
      # Read in the key type and any hidden stuff
      s.default_read_object
      @key_universe = get_key_universe(@key_type)
      @vals = Array.typed(Object).new(@key_universe.attr_length) { nil }
      # Read in size (number of Mappings)
      size = s.read_int
      # Read the keys and values, and put the mappings in the HashMap
      i = 0
      while i < size
        key = s.read_object
        value = s.read_object
        put(key, value)
        ((i += 1) - 1)
      end
    end
    
    private
    alias_method :initialize__enum_map, :initialize
  end
  
end
