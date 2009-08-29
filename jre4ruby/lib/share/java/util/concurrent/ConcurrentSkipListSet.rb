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
  module ConcurrentSkipListSetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # A scalable concurrent {@link NavigableSet} implementation based on
  # a {@link ConcurrentSkipListMap}.  The elements of the set are kept
  # sorted according to their {@linkplain Comparable natural ordering},
  # or by a {@link Comparator} provided at set creation time, depending
  # on which constructor is used.
  # 
  # <p>This implementation provides expected average <i>log(n)</i> time
  # cost for the <tt>contains</tt>, <tt>add</tt>, and <tt>remove</tt>
  # operations and their variants.  Insertion, removal, and access
  # operations safely execute concurrently by multiple threads.
  # Iterators are <i>weakly consistent</i>, returning elements
  # reflecting the state of the set at some point at or since the
  # creation of the iterator.  They do <em>not</em> throw {@link
  # ConcurrentModificationException}, and may proceed concurrently with
  # other operations.  Ascending ordered views and their iterators are
  # faster than descending ones.
  # 
  # <p>Beware that, unlike in most collections, the <tt>size</tt>
  # method is <em>not</em> a constant-time operation. Because of the
  # asynchronous nature of these sets, determining the current number
  # of elements requires a traversal of the elements. Additionally, the
  # bulk operations <tt>addAll</tt>, <tt>removeAll</tt>,
  # <tt>retainAll</tt>, and <tt>containsAll</tt> are <em>not</em>
  # guaranteed to be performed atomically. For example, an iterator
  # operating concurrently with an <tt>addAll</tt> operation might view
  # only some of the added elements.
  # 
  # <p>This class and its iterators implement all of the
  # <em>optional</em> methods of the {@link Set} and {@link Iterator}
  # interfaces. Like most other concurrent collection implementations,
  # this class does not permit the use of <tt>null</tt> elements,
  # because <tt>null</tt> arguments and return values cannot be reliably
  # distinguished from the absence of elements.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author Doug Lea
  # @param <E> the type of elements maintained by this set
  # @since 1.6
  class ConcurrentSkipListSet < ConcurrentSkipListSetImports.const_get :AbstractSet
    include_class_members ConcurrentSkipListSetImports
    overload_protected {
      include NavigableSet
      include Cloneable
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2479143111061671589 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The underlying map. Uses Boolean.TRUE as value for each
    # element.  This field is declared final for the sake of thread
    # safety, which entails some ugliness in clone()
    attr_accessor :m
    alias_method :attr_m, :m
    undef_method :m
    alias_method :attr_m=, :m=
    undef_method :m=
    
    typesig { [] }
    # Constructs a new, empty set that orders its elements according to
    # their {@linkplain Comparable natural ordering}.
    def initialize
      @m = nil
      super()
      @m = ConcurrentSkipListMap.new
    end
    
    typesig { [Comparator] }
    # Constructs a new, empty set that orders its elements according to
    # the specified comparator.
    # 
    # @param comparator the comparator that will be used to order this set.
    # If <tt>null</tt>, the {@linkplain Comparable natural
    # ordering} of the elements will be used.
    def initialize(comparator)
      @m = nil
      super()
      @m = ConcurrentSkipListMap.new(comparator)
    end
    
    typesig { [Collection] }
    # Constructs a new set containing the elements in the specified
    # collection, that orders its elements according to their
    # {@linkplain Comparable natural ordering}.
    # 
    # @param c The elements that will comprise the new set
    # @throws ClassCastException if the elements in <tt>c</tt> are
    # not {@link Comparable}, or are not mutually comparable
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def initialize(c)
      @m = nil
      super()
      @m = ConcurrentSkipListMap.new
      add_all(c)
    end
    
    typesig { [SortedSet] }
    # Constructs a new set containing the same elements and using the
    # same ordering as the specified sorted set.
    # 
    # @param s sorted set whose elements will comprise the new set
    # @throws NullPointerException if the specified sorted set or any
    # of its elements are null
    def initialize(s)
      @m = nil
      super()
      @m = ConcurrentSkipListMap.new(s.comparator)
      add_all(s)
    end
    
    typesig { [ConcurrentNavigableMap] }
    # For use by submaps
    def initialize(m)
      @m = nil
      super()
      @m = m
    end
    
    typesig { [] }
    # Returns a shallow copy of this <tt>ConcurrentSkipListSet</tt>
    # instance. (The elements themselves are not cloned.)
    # 
    # @return a shallow copy of this set
    def clone
      clone = nil
      begin
        clone = super
        clone.set_map(ConcurrentSkipListMap.new(@m))
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
      return clone
    end
    
    typesig { [] }
    # ---------------- Set operations --------------
    # 
    # Returns the number of elements in this set.  If this set
    # contains more than <tt>Integer.MAX_VALUE</tt> elements, it
    # returns <tt>Integer.MAX_VALUE</tt>.
    # 
    # <p>Beware that, unlike in most collections, this method is
    # <em>NOT</em> a constant-time operation. Because of the
    # asynchronous nature of these sets, determining the current
    # number of elements requires traversing them all to count them.
    # Additionally, it is possible for the size to change during
    # execution of this method, in which case the returned result
    # will be inaccurate. Thus, this method is typically not very
    # useful in concurrent applications.
    # 
    # @return the number of elements in this set
    def size
      return @m.size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this set contains no elements.
    # @return <tt>true</tt> if this set contains no elements
    def is_empty
      return @m.is_empty
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this set contains the specified element.
    # More formally, returns <tt>true</tt> if and only if this set
    # contains an element <tt>e</tt> such that <tt>o.equals(e)</tt>.
    # 
    # @param o object to be checked for containment in this set
    # @return <tt>true</tt> if this set contains the specified element
    # @throws ClassCastException if the specified element cannot be
    # compared with the elements currently in this set
    # @throws NullPointerException if the specified element is null
    def contains(o)
      return @m.contains_key(o)
    end
    
    typesig { [Object] }
    # Adds the specified element to this set if it is not already present.
    # More formally, adds the specified element <tt>e</tt> to this set if
    # the set contains no element <tt>e2</tt> such that <tt>e.equals(e2)</tt>.
    # If this set already contains the element, the call leaves the set
    # unchanged and returns <tt>false</tt>.
    # 
    # @param e element to be added to this set
    # @return <tt>true</tt> if this set did not already contain the
    # specified element
    # @throws ClassCastException if <tt>e</tt> cannot be compared
    # with the elements currently in this set
    # @throws NullPointerException if the specified element is null
    def add(e)
      return (@m.put_if_absent(e, Boolean::TRUE)).nil?
    end
    
    typesig { [Object] }
    # Removes the specified element from this set if it is present.
    # More formally, removes an element <tt>e</tt> such that
    # <tt>o.equals(e)</tt>, if this set contains such an element.
    # Returns <tt>true</tt> if this set contained the element (or
    # equivalently, if this set changed as a result of the call).
    # (This set will not contain the element once the call returns.)
    # 
    # @param o object to be removed from this set, if present
    # @return <tt>true</tt> if this set contained the specified element
    # @throws ClassCastException if <tt>o</tt> cannot be compared
    # with the elements currently in this set
    # @throws NullPointerException if the specified element is null
    def remove(o)
      return @m.remove(o, Boolean::TRUE)
    end
    
    typesig { [] }
    # Removes all of the elements from this set.
    def clear
      @m.clear
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this set in ascending order.
    # 
    # @return an iterator over the elements in this set in ascending order
    def iterator
      return @m.navigable_key_set.iterator
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this set in descending order.
    # 
    # @return an iterator over the elements in this set in descending order
    def descending_iterator
      return @m.descending_key_set.iterator
    end
    
    typesig { [Object] }
    # ---------------- AbstractSet Overrides --------------
    # 
    # Compares the specified object with this set for equality.  Returns
    # <tt>true</tt> if the specified object is also a set, the two sets
    # have the same size, and every member of the specified set is
    # contained in this set (or equivalently, every member of this set is
    # contained in the specified set).  This definition ensures that the
    # equals method works properly across different implementations of the
    # set interface.
    # 
    # @param o the object to be compared for equality with this set
    # @return <tt>true</tt> if the specified object is equal to this set
    def ==(o)
      # Override AbstractSet version to avoid calling size()
      if ((o).equal?(self))
        return true
      end
      if (!(o.is_a?(JavaSet)))
        return false
      end
      c = o
      begin
        return contains_all(c) && c.contains_all(self)
      rescue ClassCastException => unused
        return false
      rescue NullPointerException => unused
        return false
      end
    end
    
    typesig { [Collection] }
    # Removes from this set all of its elements that are contained in
    # the specified collection.  If the specified collection is also
    # a set, this operation effectively modifies this set so that its
    # value is the <i>asymmetric set difference</i> of the two sets.
    # 
    # @param  c collection containing elements to be removed from this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws ClassCastException if the types of one or more elements in this
    # set are incompatible with the specified collection
    # @throws NullPointerException if the specified collection or any
    # of its elements are null
    def remove_all(c)
      # Override AbstractSet version to avoid unnecessary call to size()
      modified = false
      i = c.iterator
      while i.has_next
        if (remove(i.next_))
          modified = true
        end
      end
      return modified
    end
    
    typesig { [Object] }
    # ---------------- Relational operations --------------
    # 
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    def lower(e)
      return @m.lower_key(e)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    def floor(e)
      return @m.floor_key(e)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    def ceiling(e)
      return @m.ceiling_key(e)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    def higher(e)
      return @m.higher_key(e)
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
    
    typesig { [] }
    # ---------------- SortedSet operations --------------
    def comparator
      return @m.comparator
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def first
      return @m.first_key
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def last
      return @m.last_key
    end
    
    typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} or
    # {@code toElement} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_set(from_element, from_inclusive, to_element, to_inclusive)
      return ConcurrentSkipListSet.new(@m.sub_map(from_element, from_inclusive, to_element, to_inclusive))
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code toElement} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def head_set(to_element, inclusive)
      return ConcurrentSkipListSet.new(@m.head_map(to_element, inclusive))
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_set(from_element, inclusive)
      return ConcurrentSkipListSet.new(@m.tail_map(from_element, inclusive))
    end
    
    typesig { [Object, Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} or
    # {@code toElement} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_set(from_element, to_element)
      return sub_set(from_element, true, to_element, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code toElement} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def head_set(to_element)
      return head_set(to_element, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_set(from_element)
      return tail_set(from_element, true)
    end
    
    typesig { [] }
    # Returns a reverse order view of the elements contained in this set.
    # The descending set is backed by this set, so changes to the set are
    # reflected in the descending set, and vice-versa.
    # 
    # <p>The returned set has an ordering equivalent to
    # <tt>{@link Collections#reverseOrder(Comparator) Collections.reverseOrder}(comparator())</tt>.
    # The expression {@code s.descendingSet().descendingSet()} returns a
    # view of {@code s} essentially equivalent to {@code s}.
    # 
    # @return a reverse order view of this set
    def descending_set
      return ConcurrentSkipListSet.new(@m.descending_map)
    end
    
    class_module.module_eval {
      # Support for resetting map in clone
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :MapOffset, UnsafeInstance.object_field_offset(ConcurrentSkipListSet.get_declared_field("m"))
        rescue JavaException => ex
          raise JavaError.new(ex)
        end
      end
    }
    
    typesig { [ConcurrentNavigableMap] }
    def set_map(map)
      UnsafeInstance.put_object_volatile(self, MapOffset, map)
    end
    
    private
    alias_method :initialize__concurrent_skip_list_set, :initialize
  end
  
end
