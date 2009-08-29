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
  module AbstractMapImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Util::Map, :Entry
    }
  end
  
  # This class provides a skeletal implementation of the <tt>Map</tt>
  # interface, to minimize the effort required to implement this interface.
  # 
  # <p>To implement an unmodifiable map, the programmer needs only to extend this
  # class and provide an implementation for the <tt>entrySet</tt> method, which
  # returns a set-view of the map's mappings.  Typically, the returned set
  # will, in turn, be implemented atop <tt>AbstractSet</tt>.  This set should
  # not support the <tt>add</tt> or <tt>remove</tt> methods, and its iterator
  # should not support the <tt>remove</tt> method.
  # 
  # <p>To implement a modifiable map, the programmer must additionally override
  # this class's <tt>put</tt> method (which otherwise throws an
  # <tt>UnsupportedOperationException</tt>), and the iterator returned by
  # <tt>entrySet().iterator()</tt> must additionally implement its
  # <tt>remove</tt> method.
  # 
  # <p>The programmer should generally provide a void (no argument) and map
  # constructor, as per the recommendation in the <tt>Map</tt> interface
  # specification.
  # 
  # <p>The documentation for each non-abstract method in this class describes its
  # implementation in detail.  Each of these methods may be overridden if the
  # map being implemented admits a more efficient implementation.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see Map
  # @see Collection
  # @since 1.2
  class AbstractMap 
    include_class_members AbstractMapImports
    include Map
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      @key_set = nil
      @values = nil
    end
    
    typesig { [] }
    # Query Operations
    # 
    # {@inheritDoc}
    # 
    # <p>This implementation returns <tt>entrySet().size()</tt>.
    def size
      return entry_set.size
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns <tt>size() == 0</tt>.
    def is_empty
      return (size).equal?(0)
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over <tt>entrySet()</tt> searching
    # for an entry with the specified value.  If such an entry is found,
    # <tt>true</tt> is returned.  If the iteration terminates without
    # finding such an entry, <tt>false</tt> is returned.  Note that this
    # implementation requires linear time in the size of the map.
    # 
    # @throws ClassCastException   {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def contains_value(value)
      i = entry_set.iterator
      if ((value).nil?)
        while (i.has_next)
          e = i.next_
          if ((e.get_value).nil?)
            return true
          end
        end
      else
        while (i.has_next)
          e = i.next_
          if ((value == e.get_value))
            return true
          end
        end
      end
      return false
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over <tt>entrySet()</tt> searching
    # for an entry with the specified key.  If such an entry is found,
    # <tt>true</tt> is returned.  If the iteration terminates without
    # finding such an entry, <tt>false</tt> is returned.  Note that this
    # implementation requires linear time in the size of the map; many
    # implementations will override this method.
    # 
    # @throws ClassCastException   {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def contains_key(key)
      i = entry_set.iterator
      if ((key).nil?)
        while (i.has_next)
          e = i.next_
          if ((e.get_key).nil?)
            return true
          end
        end
      else
        while (i.has_next)
          e = i.next_
          if ((key == e.get_key))
            return true
          end
        end
      end
      return false
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over <tt>entrySet()</tt> searching
    # for an entry with the specified key.  If such an entry is found,
    # the entry's value is returned.  If the iteration terminates without
    # finding such an entry, <tt>null</tt> is returned.  Note that this
    # implementation requires linear time in the size of the map; many
    # implementations will override this method.
    # 
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    def get(key)
      i = entry_set.iterator
      if ((key).nil?)
        while (i.has_next)
          e = i.next_
          if ((e.get_key).nil?)
            return e.get_value
          end
        end
      else
        while (i.has_next)
          e = i.next_
          if ((key == e.get_key))
            return e.get_value
          end
        end
      end
      return nil
    end
    
    typesig { [Object, Object] }
    # Modification Operations
    # 
    # {@inheritDoc}
    # 
    # <p>This implementation always throws an
    # <tt>UnsupportedOperationException</tt>.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    def put(key, value)
      raise UnsupportedOperationException.new
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over <tt>entrySet()</tt> searching for an
    # entry with the specified key.  If such an entry is found, its value is
    # obtained with its <tt>getValue</tt> operation, the entry is removed
    # from the collection (and the backing map) with the iterator's
    # <tt>remove</tt> operation, and the saved value is returned.  If the
    # iteration terminates without finding such an entry, <tt>null</tt> is
    # returned.  Note that this implementation requires linear time in the
    # size of the map; many implementations will override this method.
    # 
    # <p>Note that this implementation throws an
    # <tt>UnsupportedOperationException</tt> if the <tt>entrySet</tt>
    # iterator does not support the <tt>remove</tt> method and this map
    # contains a mapping for the specified key.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    def remove(key)
      i = entry_set.iterator
      correct_entry = nil
      if ((key).nil?)
        while ((correct_entry).nil? && i.has_next)
          e = i.next_
          if ((e.get_key).nil?)
            correct_entry = e
          end
        end
      else
        while ((correct_entry).nil? && i.has_next)
          e = i.next_
          if ((key == e.get_key))
            correct_entry = e
          end
        end
      end
      old_value = nil
      if (!(correct_entry).nil?)
        old_value = correct_entry.get_value
        i.remove
      end
      return old_value
    end
    
    typesig { [Map] }
    # Bulk Operations
    # 
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over the specified map's
    # <tt>entrySet()</tt> collection, and calls this map's <tt>put</tt>
    # operation once for each entry returned by the iteration.
    # 
    # <p>Note that this implementation throws an
    # <tt>UnsupportedOperationException</tt> if this map does not support
    # the <tt>put</tt> operation and the specified map is nonempty.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    def put_all(m)
      m.entry_set.each do |e|
        put(e.get_key, e.get_value)
      end
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>This implementation calls <tt>entrySet().clear()</tt>.
    # 
    # <p>Note that this implementation throws an
    # <tt>UnsupportedOperationException</tt> if the <tt>entrySet</tt>
    # does not support the <tt>clear</tt> operation.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    def clear
      entry_set.clear
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
    
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns a set that subclasses {@link AbstractSet}.
    # The subclass's iterator method returns a "wrapper object" over this
    # map's <tt>entrySet()</tt> iterator.  The <tt>size</tt> method
    # delegates to this map's <tt>size</tt> method and the
    # <tt>contains</tt> method delegates to this map's
    # <tt>containsKey</tt> method.
    # 
    # <p>The set is created the first time this method is called,
    # and returned in response to all subsequent calls.  No synchronization
    # is performed, so there is a slight chance that multiple calls to this
    # method will not all return the same set.
    def key_set
      if ((@key_set).nil?)
        @key_set = Class.new(AbstractSet.class == Class ? AbstractSet : Object) do
          extend LocalClass
          include_class_members AbstractMap
          include AbstractSet if AbstractSet.class == Module
          
          typesig { [] }
          define_method :iterator do
            abstract_set_class = self.class
            return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
              extend LocalClass
              include_class_members abstract_set_class
              include class_self::Iterator if class_self::Iterator.class == Module
              
              attr_accessor :i
              alias_method :attr_i, :i
              undef_method :i
              alias_method :attr_i=, :i=
              undef_method :i=
              
              typesig { [] }
              define_method :has_next do
                return @i.has_next
              end
              
              typesig { [] }
              define_method :next_ do
                return @i.next_.get_key
              end
              
              typesig { [] }
              define_method :remove do
                @i.remove
              end
              
              typesig { [] }
              define_method :initialize do
                @i = nil
                super()
                @i = entry_set.iterator
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
          
          typesig { [] }
          define_method :size do
            return @local_class_parent.size
          end
          
          typesig { [] }
          define_method :is_empty do
            return @local_class_parent.is_empty
          end
          
          typesig { [] }
          define_method :clear do
            @local_class_parent.clear
          end
          
          typesig { [Object] }
          define_method :contains do |k|
            return @local_class_parent.contains_key(k)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @key_set
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns a collection that subclasses {@link
    # AbstractCollection}.  The subclass's iterator method returns a
    # "wrapper object" over this map's <tt>entrySet()</tt> iterator.
    # The <tt>size</tt> method delegates to this map's <tt>size</tt>
    # method and the <tt>contains</tt> method delegates to this map's
    # <tt>containsValue</tt> method.
    # 
    # <p>The collection is created the first time this method is called, and
    # returned in response to all subsequent calls.  No synchronization is
    # performed, so there is a slight chance that multiple calls to this
    # method will not all return the same collection.
    def values
      if ((@values).nil?)
        @values = Class.new(AbstractCollection.class == Class ? AbstractCollection : Object) do
          extend LocalClass
          include_class_members AbstractMap
          include AbstractCollection if AbstractCollection.class == Module
          
          typesig { [] }
          define_method :iterator do
            abstract_collection_class = self.class
            return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
              extend LocalClass
              include_class_members abstract_collection_class
              include class_self::Iterator if class_self::Iterator.class == Module
              
              attr_accessor :i
              alias_method :attr_i, :i
              undef_method :i
              alias_method :attr_i=, :i=
              undef_method :i=
              
              typesig { [] }
              define_method :has_next do
                return @i.has_next
              end
              
              typesig { [] }
              define_method :next_ do
                return @i.next_.get_value
              end
              
              typesig { [] }
              define_method :remove do
                @i.remove
              end
              
              typesig { [] }
              define_method :initialize do
                @i = nil
                super()
                @i = entry_set.iterator
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
          
          typesig { [] }
          define_method :size do
            return @local_class_parent.size
          end
          
          typesig { [] }
          define_method :is_empty do
            return @local_class_parent.is_empty
          end
          
          typesig { [] }
          define_method :clear do
            @local_class_parent.clear
          end
          
          typesig { [Object] }
          define_method :contains do |v|
            return @local_class_parent.contains_value(v)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @values
    end
    
    typesig { [] }
    def entry_set
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Comparison and hashing
    # 
    # Compares the specified object with this map for equality.  Returns
    # <tt>true</tt> if the given object is also a map and the two maps
    # represent the same mappings.  More formally, two maps <tt>m1</tt> and
    # <tt>m2</tt> represent the same mappings if
    # <tt>m1.entrySet().equals(m2.entrySet())</tt>.  This ensures that the
    # <tt>equals</tt> method works properly across different implementations
    # of the <tt>Map</tt> interface.
    # 
    # <p>This implementation first checks if the specified object is this map;
    # if so it returns <tt>true</tt>.  Then, it checks if the specified
    # object is a map whose size is identical to the size of this map; if
    # not, it returns <tt>false</tt>.  If so, it iterates over this map's
    # <tt>entrySet</tt> collection, and checks that the specified map
    # contains each mapping that this map contains.  If the specified map
    # fails to contain such a mapping, <tt>false</tt> is returned.  If the
    # iteration completes, <tt>true</tt> is returned.
    # 
    # @param o object to be compared for equality with this map
    # @return <tt>true</tt> if the specified object is equal to this map
    def ==(o)
      if ((o).equal?(self))
        return true
      end
      if (!(o.is_a?(Map)))
        return false
      end
      m = o
      if (!(m.size).equal?(size))
        return false
      end
      begin
        i = entry_set.iterator
        while (i.has_next)
          e = i.next_
          key = e.get_key
          value = e.get_value
          if ((value).nil?)
            if (!((m.get(key)).nil? && m.contains_key(key)))
              return false
            end
          else
            if (!(value == m.get(key)))
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
    
    typesig { [] }
    # Returns the hash code value for this map.  The hash code of a map is
    # defined to be the sum of the hash codes of each entry in the map's
    # <tt>entrySet()</tt> view.  This ensures that <tt>m1.equals(m2)</tt>
    # implies that <tt>m1.hashCode()==m2.hashCode()</tt> for any two maps
    # <tt>m1</tt> and <tt>m2</tt>, as required by the general contract of
    # {@link Object#hashCode}.
    # 
    # <p>This implementation iterates over <tt>entrySet()</tt>, calling
    # {@link Map.Entry#hashCode hashCode()} on each element (entry) in the
    # set, and adding up the results.
    # 
    # @return the hash code value for this map
    # @see Map.Entry#hashCode()
    # @see Object#equals(Object)
    # @see Set#equals(Object)
    def hash_code
      h = 0
      i = entry_set.iterator
      while (i.has_next)
        h += i.next_.hash_code
      end
      return h
    end
    
    typesig { [] }
    # Returns a string representation of this map.  The string representation
    # consists of a list of key-value mappings in the order returned by the
    # map's <tt>entrySet</tt> view's iterator, enclosed in braces
    # (<tt>"{}"</tt>).  Adjacent mappings are separated by the characters
    # <tt>", "</tt> (comma and space).  Each key-value mapping is rendered as
    # the key followed by an equals sign (<tt>"="</tt>) followed by the
    # associated value.  Keys and values are converted to strings as by
    # {@link String#valueOf(Object)}.
    # 
    # @return a string representation of this map
    def to_s
      i = entry_set.iterator
      if (!i.has_next)
        return "{}"
      end
      sb = StringBuilder.new
      sb.append(Character.new(?{.ord))
      loop do
        e = i.next_
        key = e.get_key
        value = e.get_value
        sb.append((key).equal?(self) ? "(this Map)" : key)
        sb.append(Character.new(?=.ord))
        sb.append((value).equal?(self) ? "(this Map)" : value)
        if (!i.has_next)
          return sb.append(Character.new(?}.ord)).to_s
        end
        sb.append(", ")
      end
    end
    
    typesig { [] }
    # Returns a shallow copy of this <tt>AbstractMap</tt> instance: the keys
    # and values themselves are not cloned.
    # 
    # @return a shallow copy of this map
    def clone
      result = super
      result.attr_key_set = nil
      result.attr_values = nil
      return result
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # Utility method for SimpleEntry and SimpleImmutableEntry.
      # Test for equality, checking for nulls.
      def eq(o1, o2)
        return (o1).nil? ? (o2).nil? : (o1 == o2)
      end
      
      # Implementation Note: SimpleEntry and SimpleImmutableEntry
      # are distinct unrelated classes, even though they share
      # some code. Since you can't add or subtract final-ness
      # of a field in a subclass, they can't share representations,
      # and the amount of duplicated code is too small to warrant
      # exposing a common abstract class.
      # 
      # An Entry maintaining a key and a value.  The value may be
      # changed using the <tt>setValue</tt> method.  This class
      # facilitates the process of building custom map
      # implementations. For example, it may be convenient to return
      # arrays of <tt>SimpleEntry</tt> instances in method
      # <tt>Map.entrySet().toArray</tt>.
      # 
      # @since 1.6
      const_set_lazy(:SimpleEntry) { Class.new do
        include_class_members AbstractMap
        include Entry
        include Java::Io::Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -8499721149061103585 }
          const_attr_reader  :SerialVersionUID
        }
        
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
        
        typesig { [Object, Object] }
        # Creates an entry representing a mapping from the specified
        # key to the specified value.
        # 
        # @param key the key represented by this entry
        # @param value the value represented by this entry
        def initialize(key, value)
          @key = nil
          @value = nil
          @key = key
          @value = value
        end
        
        typesig { [class_self::Entry] }
        # Creates an entry representing the same mapping as the
        # specified entry.
        # 
        # @param entry the entry to copy
        def initialize(entry)
          @key = nil
          @value = nil
          @key = entry.get_key
          @value = entry.get_value
        end
        
        typesig { [] }
        # Returns the key corresponding to this entry.
        # 
        # @return the key corresponding to this entry
        def get_key
          return @key
        end
        
        typesig { [] }
        # Returns the value corresponding to this entry.
        # 
        # @return the value corresponding to this entry
        def get_value
          return @value
        end
        
        typesig { [Object] }
        # Replaces the value corresponding to this entry with the specified
        # value.
        # 
        # @param value new value to be stored in this entry
        # @return the old value corresponding to the entry
        def set_value(value)
          old_value = @value
          @value = value
          return old_value
        end
        
        typesig { [Object] }
        # Compares the specified object with this entry for equality.
        # Returns {@code true} if the given object is also a map entry and
        # the two entries represent the same mapping.  More formally, two
        # entries {@code e1} and {@code e2} represent the same mapping
        # if<pre>
        # (e1.getKey()==null ?
        # e2.getKey()==null :
        # e1.getKey().equals(e2.getKey()))
        # &amp;&amp;
        # (e1.getValue()==null ?
        # e2.getValue()==null :
        # e1.getValue().equals(e2.getValue()))</pre>
        # This ensures that the {@code equals} method works properly across
        # different implementations of the {@code Map.Entry} interface.
        # 
        # @param o object to be compared for equality with this map entry
        # @return {@code true} if the specified object is equal to this map
        # entry
        # @see    #hashCode
        def ==(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          return eq(@key, e.get_key) && eq(@value, e.get_value)
        end
        
        typesig { [] }
        # Returns the hash code value for this map entry.  The hash code
        # of a map entry {@code e} is defined to be: <pre>
        # (e.getKey()==null   ? 0 : e.getKey().hashCode()) ^
        # (e.getValue()==null ? 0 : e.getValue().hashCode())</pre>
        # This ensures that {@code e1.equals(e2)} implies that
        # {@code e1.hashCode()==e2.hashCode()} for any two Entries
        # {@code e1} and {@code e2}, as required by the general
        # contract of {@link Object#hashCode}.
        # 
        # @return the hash code value for this map entry
        # @see    #equals
        def hash_code
          return ((@key).nil? ? 0 : @key.hash_code) ^ ((@value).nil? ? 0 : @value.hash_code)
        end
        
        typesig { [] }
        # Returns a String representation of this map entry.  This
        # implementation returns the string representation of this
        # entry's key followed by the equals character ("<tt>=</tt>")
        # followed by the string representation of this entry's value.
        # 
        # @return a String representation of this map entry
        def to_s
          return RJava.cast_to_string(@key) + "=" + RJava.cast_to_string(@value)
        end
        
        private
        alias_method :initialize__simple_entry, :initialize
      end }
      
      # An Entry maintaining an immutable key and value.  This class
      # does not support method <tt>setValue</tt>.  This class may be
      # convenient in methods that return thread-safe snapshots of
      # key-value mappings.
      # 
      # @since 1.6
      const_set_lazy(:SimpleImmutableEntry) { Class.new do
        include_class_members AbstractMap
        include Entry
        include Java::Io::Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 7138329143949025153 }
          const_attr_reader  :SerialVersionUID
        }
        
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
        
        typesig { [Object, Object] }
        # Creates an entry representing a mapping from the specified
        # key to the specified value.
        # 
        # @param key the key represented by this entry
        # @param value the value represented by this entry
        def initialize(key, value)
          @key = nil
          @value = nil
          @key = key
          @value = value
        end
        
        typesig { [class_self::Entry] }
        # Creates an entry representing the same mapping as the
        # specified entry.
        # 
        # @param entry the entry to copy
        def initialize(entry)
          @key = nil
          @value = nil
          @key = entry.get_key
          @value = entry.get_value
        end
        
        typesig { [] }
        # Returns the key corresponding to this entry.
        # 
        # @return the key corresponding to this entry
        def get_key
          return @key
        end
        
        typesig { [] }
        # Returns the value corresponding to this entry.
        # 
        # @return the value corresponding to this entry
        def get_value
          return @value
        end
        
        typesig { [Object] }
        # Replaces the value corresponding to this entry with the specified
        # value (optional operation).  This implementation simply throws
        # <tt>UnsupportedOperationException</tt>, as this class implements
        # an <i>immutable</i> map entry.
        # 
        # @param value new value to be stored in this entry
        # @return (Does not return)
        # @throws UnsupportedOperationException always
        def set_value(value)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        # Compares the specified object with this entry for equality.
        # Returns {@code true} if the given object is also a map entry and
        # the two entries represent the same mapping.  More formally, two
        # entries {@code e1} and {@code e2} represent the same mapping
        # if<pre>
        # (e1.getKey()==null ?
        # e2.getKey()==null :
        # e1.getKey().equals(e2.getKey()))
        # &amp;&amp;
        # (e1.getValue()==null ?
        # e2.getValue()==null :
        # e1.getValue().equals(e2.getValue()))</pre>
        # This ensures that the {@code equals} method works properly across
        # different implementations of the {@code Map.Entry} interface.
        # 
        # @param o object to be compared for equality with this map entry
        # @return {@code true} if the specified object is equal to this map
        # entry
        # @see    #hashCode
        def ==(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          return eq(@key, e.get_key) && eq(@value, e.get_value)
        end
        
        typesig { [] }
        # Returns the hash code value for this map entry.  The hash code
        # of a map entry {@code e} is defined to be: <pre>
        # (e.getKey()==null   ? 0 : e.getKey().hashCode()) ^
        # (e.getValue()==null ? 0 : e.getValue().hashCode())</pre>
        # This ensures that {@code e1.equals(e2)} implies that
        # {@code e1.hashCode()==e2.hashCode()} for any two Entries
        # {@code e1} and {@code e2}, as required by the general
        # contract of {@link Object#hashCode}.
        # 
        # @return the hash code value for this map entry
        # @see    #equals
        def hash_code
          return ((@key).nil? ? 0 : @key.hash_code) ^ ((@value).nil? ? 0 : @value.hash_code)
        end
        
        typesig { [] }
        # Returns a String representation of this map entry.  This
        # implementation returns the string representation of this
        # entry's key followed by the equals character ("<tt>=</tt>")
        # followed by the string representation of this entry's value.
        # 
        # @return a String representation of this map entry
        def to_s
          return RJava.cast_to_string(@key) + "=" + RJava.cast_to_string(@value)
        end
        
        private
        alias_method :initialize__simple_immutable_entry, :initialize
      end }
    }
    
    private
    alias_method :initialize__abstract_map, :initialize
  end
  
end
