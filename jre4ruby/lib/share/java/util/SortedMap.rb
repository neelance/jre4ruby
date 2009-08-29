require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SortedMapImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # A {@link Map} that further provides a <i>total ordering</i> on its keys.
  # The map is ordered according to the {@linkplain Comparable natural
  # ordering} of its keys, or by a {@link Comparator} typically
  # provided at sorted map creation time.  This order is reflected when
  # iterating over the sorted map's collection views (returned by the
  # <tt>entrySet</tt>, <tt>keySet</tt> and <tt>values</tt> methods).
  # Several additional operations are provided to take advantage of the
  # ordering.  (This interface is the map analogue of {@link
  # SortedSet}.)
  # 
  # <p>All keys inserted into a sorted map must implement the <tt>Comparable</tt>
  # interface (or be accepted by the specified comparator).  Furthermore, all
  # such keys must be <i>mutually comparable</i>: <tt>k1.compareTo(k2)</tt> (or
  # <tt>comparator.compare(k1, k2)</tt>) must not throw a
  # <tt>ClassCastException</tt> for any keys <tt>k1</tt> and <tt>k2</tt> in
  # the sorted map.  Attempts to violate this restriction will cause the
  # offending method or constructor invocation to throw a
  # <tt>ClassCastException</tt>.
  # 
  # <p>Note that the ordering maintained by a sorted map (whether or not an
  # explicit comparator is provided) must be <i>consistent with equals</i> if
  # the sorted map is to correctly implement the <tt>Map</tt> interface.  (See
  # the <tt>Comparable</tt> interface or <tt>Comparator</tt> interface for a
  # precise definition of <i>consistent with equals</i>.)  This is so because
  # the <tt>Map</tt> interface is defined in terms of the <tt>equals</tt>
  # operation, but a sorted map performs all key comparisons using its
  # <tt>compareTo</tt> (or <tt>compare</tt>) method, so two keys that are
  # deemed equal by this method are, from the standpoint of the sorted map,
  # equal.  The behavior of a tree map <i>is</i> well-defined even if its
  # ordering is inconsistent with equals; it just fails to obey the general
  # contract of the <tt>Map</tt> interface.
  # 
  # <p>All general-purpose sorted map implementation classes should
  # provide four "standard" constructors: 1) A void (no arguments)
  # constructor, which creates an empty sorted map sorted according to
  # the natural ordering of its keys.  2) A constructor with a
  # single argument of type <tt>Comparator</tt>, which creates an empty
  # sorted map sorted according to the specified comparator.  3) A
  # constructor with a single argument of type <tt>Map</tt>, which
  # creates a new map with the same key-value mappings as its argument,
  # sorted according to the keys' natural ordering.  4) A constructor
  # with a single argument of type <tt>SortedMap</tt>,
  # which creates a new sorted map with the same key-value mappings and
  # the same ordering as the input sorted map.  There is no way to
  # enforce this recommendation, as interfaces cannot contain
  # constructors.
  # 
  # <p>Note: several methods return submaps with restricted key ranges.
  # Such ranges are <i>half-open</i>, that is, they include their low
  # endpoint but not their high endpoint (where applicable).  If you need a
  # <i>closed range</i> (which includes both endpoints), and the key type
  # allows for calculation of the successor of a given key, merely request
  # the subrange from <tt>lowEndpoint</tt> to
  # <tt>successor(highEndpoint)</tt>.  For example, suppose that <tt>m</tt>
  # is a map whose keys are strings.  The following idiom obtains a view
  # containing all of the key-value mappings in <tt>m</tt> whose keys are
  # between <tt>low</tt> and <tt>high</tt>, inclusive:<pre>
  # SortedMap&lt;String, V&gt; sub = m.subMap(low, high+"\0");</pre>
  # 
  # A similar technique can be used to generate an <i>open range</i>
  # (which contains neither endpoint).  The following idiom obtains a
  # view containing all of the key-value mappings in <tt>m</tt> whose keys
  # are between <tt>low</tt> and <tt>high</tt>, exclusive:<pre>
  # SortedMap&lt;String, V&gt; sub = m.subMap(low+"\0", high);</pre>
  # 
  # <p>This interface is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # 
  # @author  Josh Bloch
  # @see Map
  # @see TreeMap
  # @see SortedSet
  # @see Comparator
  # @see Comparable
  # @see Collection
  # @see ClassCastException
  # @since 1.2
  module SortedMap
    include_class_members SortedMapImports
    include Map
    
    typesig { [] }
    # Returns the comparator used to order the keys in this map, or
    # <tt>null</tt> if this map uses the {@linkplain Comparable
    # natural ordering} of its keys.
    # 
    # @return the comparator used to order the keys in this map,
    # or <tt>null</tt> if this map uses the natural ordering
    # of its keys
    def comparator
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Returns a view of the portion of this map whose keys range from
    # <tt>fromKey</tt>, inclusive, to <tt>toKey</tt>, exclusive.  (If
    # <tt>fromKey</tt> and <tt>toKey</tt> are equal, the returned map
    # is empty.)  The returned map is backed by this map, so changes
    # in the returned map are reflected in this map, and vice-versa.
    # The returned map supports all optional map operations that this
    # map supports.
    # 
    # <p>The returned map will throw an <tt>IllegalArgumentException</tt>
    # on an attempt to insert a key outside its range.
    # 
    # @param fromKey low endpoint (inclusive) of the keys in the returned map
    # @param toKey high endpoint (exclusive) of the keys in the returned map
    # @return a view of the portion of this map whose keys range from
    # <tt>fromKey</tt>, inclusive, to <tt>toKey</tt>, exclusive
    # @throws ClassCastException if <tt>fromKey</tt> and <tt>toKey</tt>
    # cannot be compared to one another using this map's comparator
    # (or, if the map has no comparator, using natural ordering).
    # Implementations may, but are not required to, throw this
    # exception if <tt>fromKey</tt> or <tt>toKey</tt>
    # cannot be compared to keys currently in the map.
    # @throws NullPointerException if <tt>fromKey</tt> or <tt>toKey</tt>
    # is null and this map does not permit null keys
    # @throws IllegalArgumentException if <tt>fromKey</tt> is greater than
    # <tt>toKey</tt>; or if this map itself has a restricted
    # range, and <tt>fromKey</tt> or <tt>toKey</tt> lies
    # outside the bounds of the range
    def sub_map(from_key, to_key)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns a view of the portion of this map whose keys are
    # strictly less than <tt>toKey</tt>.  The returned map is backed
    # by this map, so changes in the returned map are reflected in
    # this map, and vice-versa.  The returned map supports all
    # optional map operations that this map supports.
    # 
    # <p>The returned map will throw an <tt>IllegalArgumentException</tt>
    # on an attempt to insert a key outside its range.
    # 
    # @param toKey high endpoint (exclusive) of the keys in the returned map
    # @return a view of the portion of this map whose keys are strictly
    # less than <tt>toKey</tt>
    # @throws ClassCastException if <tt>toKey</tt> is not compatible
    # with this map's comparator (or, if the map has no comparator,
    # if <tt>toKey</tt> does not implement {@link Comparable}).
    # Implementations may, but are not required to, throw this
    # exception if <tt>toKey</tt> cannot be compared to keys
    # currently in the map.
    # @throws NullPointerException if <tt>toKey</tt> is null and
    # this map does not permit null keys
    # @throws IllegalArgumentException if this map itself has a
    # restricted range, and <tt>toKey</tt> lies outside the
    # bounds of the range
    def head_map(to_key)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns a view of the portion of this map whose keys are
    # greater than or equal to <tt>fromKey</tt>.  The returned map is
    # backed by this map, so changes in the returned map are
    # reflected in this map, and vice-versa.  The returned map
    # supports all optional map operations that this map supports.
    # 
    # <p>The returned map will throw an <tt>IllegalArgumentException</tt>
    # on an attempt to insert a key outside its range.
    # 
    # @param fromKey low endpoint (inclusive) of the keys in the returned map
    # @return a view of the portion of this map whose keys are greater
    # than or equal to <tt>fromKey</tt>
    # @throws ClassCastException if <tt>fromKey</tt> is not compatible
    # with this map's comparator (or, if the map has no comparator,
    # if <tt>fromKey</tt> does not implement {@link Comparable}).
    # Implementations may, but are not required to, throw this
    # exception if <tt>fromKey</tt> cannot be compared to keys
    # currently in the map.
    # @throws NullPointerException if <tt>fromKey</tt> is null and
    # this map does not permit null keys
    # @throws IllegalArgumentException if this map itself has a
    # restricted range, and <tt>fromKey</tt> lies outside the
    # bounds of the range
    def tail_map(from_key)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the first (lowest) key currently in this map.
    # 
    # @return the first (lowest) key currently in this map
    # @throws NoSuchElementException if this map is empty
    def first_key
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the last (highest) key currently in this map.
    # 
    # @return the last (highest) key currently in this map
    # @throws NoSuchElementException if this map is empty
    def last_key
      raise NotImplementedError
    end
    
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
    # 
    # @return a set view of the keys contained in this map, sorted in
    # ascending order
    def key_set
      raise NotImplementedError
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
    # 
    # @return a collection view of the values contained in this map,
    # sorted in ascending key order
    def values
      raise NotImplementedError
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
    # 
    # @return a set view of the mappings contained in this map,
    # sorted in ascending key order
    def entry_set
      raise NotImplementedError
    end
  end
  
end
