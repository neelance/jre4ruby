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
  module TreeSetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # A {@link NavigableSet} implementation based on a {@link TreeMap}.
  # The elements are ordered using their {@linkplain Comparable natural
  # ordering}, or by a {@link Comparator} provided at set creation
  # time, depending on which constructor is used.
  # 
  # <p>This implementation provides guaranteed log(n) time cost for the basic
  # operations ({@code add}, {@code remove} and {@code contains}).
  # 
  # <p>Note that the ordering maintained by a set (whether or not an explicit
  # comparator is provided) must be <i>consistent with equals</i> if it is to
  # correctly implement the {@code Set} interface.  (See {@code Comparable}
  # or {@code Comparator} for a precise definition of <i>consistent with
  # equals</i>.)  This is so because the {@code Set} interface is defined in
  # terms of the {@code equals} operation, but a {@code TreeSet} instance
  # performs all element comparisons using its {@code compareTo} (or
  # {@code compare}) method, so two elements that are deemed equal by this method
  # are, from the standpoint of the set, equal.  The behavior of a set
  # <i>is</i> well-defined even if its ordering is inconsistent with equals; it
  # just fails to obey the general contract of the {@code Set} interface.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access a tree set concurrently, and at least one
  # of the threads modifies the set, it <i>must</i> be synchronized
  # externally.  This is typically accomplished by synchronizing on some
  # object that naturally encapsulates the set.
  # If no such object exists, the set should be "wrapped" using the
  # {@link Collections#synchronizedSortedSet Collections.synchronizedSortedSet}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the set: <pre>
  # SortedSet s = Collections.synchronizedSortedSet(new TreeSet(...));</pre>
  # 
  # <p>The iterators returned by this class's {@code iterator} method are
  # <i>fail-fast</i>: if the set is modified at any time after the iterator is
  # created, in any way except through the iterator's own {@code remove}
  # method, the iterator will throw a {@link ConcurrentModificationException}.
  # Thus, in the face of concurrent modification, the iterator fails quickly
  # and cleanly, rather than risking arbitrary, non-deterministic behavior at
  # an undetermined time in the future.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw {@code ConcurrentModificationException} on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness:   <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @param <E> the type of elements maintained by this set
  # 
  # @author  Josh Bloch
  # @see     Collection
  # @see     Set
  # @see     HashSet
  # @see     Comparable
  # @see     Comparator
  # @see     TreeMap
  # @since   1.2
  class TreeSet < TreeSetImports.const_get :AbstractSet
    include_class_members TreeSetImports
    overload_protected {
      include NavigableSet
      include Cloneable
      include Java::Io::Serializable
    }
    
    # The backing map.
    attr_accessor :m
    alias_method :attr_m, :m
    undef_method :m
    alias_method :attr_m=, :m=
    undef_method :m=
    
    class_module.module_eval {
      # Dummy value to associate with an Object in the backing Map
      const_set_lazy(:PRESENT) { Object.new }
      const_attr_reader  :PRESENT
    }
    
    typesig { [NavigableMap] }
    # Constructs a set backed by the specified navigable map.
    def initialize(m)
      @m = nil
      super()
      @m = m
    end
    
    typesig { [] }
    # Constructs a new, empty tree set, sorted according to the
    # natural ordering of its elements.  All elements inserted into
    # the set must implement the {@link Comparable} interface.
    # Furthermore, all such elements must be <i>mutually
    # comparable</i>: {@code e1.compareTo(e2)} must not throw a
    # {@code ClassCastException} for any elements {@code e1} and
    # {@code e2} in the set.  If the user attempts to add an element
    # to the set that violates this constraint (for example, the user
    # attempts to add a string element to a set whose elements are
    # integers), the {@code add} call will throw a
    # {@code ClassCastException}.
    def initialize
      initialize__tree_set(TreeMap.new)
    end
    
    typesig { [Comparator] }
    # Constructs a new, empty tree set, sorted according to the specified
    # comparator.  All elements inserted into the set must be <i>mutually
    # comparable</i> by the specified comparator: {@code comparator.compare(e1,
    # e2)} must not throw a {@code ClassCastException} for any elements
    # {@code e1} and {@code e2} in the set.  If the user attempts to add
    # an element to the set that violates this constraint, the
    # {@code add} call will throw a {@code ClassCastException}.
    # 
    # @param comparator the comparator that will be used to order this set.
    # If {@code null}, the {@linkplain Comparable natural
    # ordering} of the elements will be used.
    def initialize(comparator)
      initialize__tree_set(TreeMap.new(comparator))
    end
    
    typesig { [Collection] }
    # Constructs a new tree set containing the elements in the specified
    # collection, sorted according to the <i>natural ordering</i> of its
    # elements.  All elements inserted into the set must implement the
    # {@link Comparable} interface.  Furthermore, all such elements must be
    # <i>mutually comparable</i>: {@code e1.compareTo(e2)} must not throw a
    # {@code ClassCastException} for any elements {@code e1} and
    # {@code e2} in the set.
    # 
    # @param c collection whose elements will comprise the new set
    # @throws ClassCastException if the elements in {@code c} are
    # not {@link Comparable}, or are not mutually comparable
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      initialize__tree_set()
      add_all(c)
    end
    
    typesig { [SortedSet] }
    # Constructs a new tree set containing the same elements and
    # using the same ordering as the specified sorted set.
    # 
    # @param s sorted set whose elements will comprise the new set
    # @throws NullPointerException if the specified sorted set is null
    def initialize(s)
      initialize__tree_set(s.comparator)
      add_all(s)
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
    # @since 1.6
    def descending_iterator
      return @m.descending_key_set.iterator
    end
    
    typesig { [] }
    # @since 1.6
    def descending_set
      return TreeSet.new(@m.descending_map)
    end
    
    typesig { [] }
    # Returns the number of elements in this set (its cardinality).
    # 
    # @return the number of elements in this set (its cardinality)
    def size
      return @m.size
    end
    
    typesig { [] }
    # Returns {@code true} if this set contains no elements.
    # 
    # @return {@code true} if this set contains no elements
    def is_empty
      return @m.is_empty
    end
    
    typesig { [Object] }
    # Returns {@code true} if this set contains the specified element.
    # More formally, returns {@code true} if and only if this set
    # contains an element {@code e} such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>.
    # 
    # @param o object to be checked for containment in this set
    # @return {@code true} if this set contains the specified element
    # @throws ClassCastException if the specified object cannot be compared
    # with the elements currently in the set
    # @throws NullPointerException if the specified element is null
    # and this set uses natural ordering, or its comparator
    # does not permit null elements
    def contains(o)
      return @m.contains_key(o)
    end
    
    typesig { [Object] }
    # Adds the specified element to this set if it is not already present.
    # More formally, adds the specified element {@code e} to this set if
    # the set contains no element {@code e2} such that
    # <tt>(e==null&nbsp;?&nbsp;e2==null&nbsp;:&nbsp;e.equals(e2))</tt>.
    # If this set already contains the element, the call leaves the set
    # unchanged and returns {@code false}.
    # 
    # @param e element to be added to this set
    # @return {@code true} if this set did not already contain the specified
    # element
    # @throws ClassCastException if the specified object cannot be compared
    # with the elements currently in this set
    # @throws NullPointerException if the specified element is null
    # and this set uses natural ordering, or its comparator
    # does not permit null elements
    def add(e)
      return (@m.put(e, PRESENT)).nil?
    end
    
    typesig { [Object] }
    # Removes the specified element from this set if it is present.
    # More formally, removes an element {@code e} such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>,
    # if this set contains such an element.  Returns {@code true} if
    # this set contained the element (or equivalently, if this set
    # changed as a result of the call).  (This set will not contain the
    # element once the call returns.)
    # 
    # @param o object to be removed from this set, if present
    # @return {@code true} if this set contained the specified element
    # @throws ClassCastException if the specified object cannot be compared
    # with the elements currently in this set
    # @throws NullPointerException if the specified element is null
    # and this set uses natural ordering, or its comparator
    # does not permit null elements
    def remove(o)
      return (@m.remove(o)).equal?(PRESENT)
    end
    
    typesig { [] }
    # Removes all of the elements from this set.
    # The set will be empty after this call returns.
    def clear
      @m.clear
    end
    
    typesig { [Collection] }
    # Adds all of the elements in the specified collection to this set.
    # 
    # @param c collection containing elements to be added to this set
    # @return {@code true} if this set changed as a result of the call
    # @throws ClassCastException if the elements provided cannot be compared
    # with the elements currently in the set
    # @throws NullPointerException if the specified collection is null or
    # if any element is null and this set uses natural ordering, or
    # its comparator does not permit null elements
    def add_all(c)
      # Use linear-time version if applicable
      if ((@m.size).equal?(0) && c.size > 0 && c.is_a?(SortedSet) && @m.is_a?(TreeMap))
        set = c
        map = @m
        cc = set.comparator
        mc = map.comparator
        if ((cc).equal?(mc) || (!(cc).nil? && (cc == mc)))
          map.add_all_for_tree_set(set, PRESENT)
          return true
        end
      end
      return super(c)
    end
    
    typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} or {@code toElement}
    # is null and this set uses natural ordering, or its comparator
    # does not permit null elements
    # @throws IllegalArgumentException {@inheritDoc}
    # @since 1.6
    def sub_set(from_element, from_inclusive, to_element, to_inclusive)
      return TreeSet.new(@m.sub_map(from_element, from_inclusive, to_element, to_inclusive))
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code toElement} is null and
    # this set uses natural ordering, or its comparator does
    # not permit null elements
    # @throws IllegalArgumentException {@inheritDoc}
    # @since 1.6
    def head_set(to_element, inclusive)
      return TreeSet.new(@m.head_map(to_element, inclusive))
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} is null and
    # this set uses natural ordering, or its comparator does
    # not permit null elements
    # @throws IllegalArgumentException {@inheritDoc}
    # @since 1.6
    def tail_set(from_element, inclusive)
      return TreeSet.new(@m.tail_map(from_element, inclusive))
    end
    
    typesig { [Object, Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} or
    # {@code toElement} is null and this set uses natural ordering,
    # or its comparator does not permit null elements
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_set(from_element, to_element)
      return sub_set(from_element, true, to_element, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code toElement} is null
    # and this set uses natural ordering, or its comparator does
    # not permit null elements
    # @throws IllegalArgumentException {@inheritDoc}
    def head_set(to_element)
      return head_set(to_element, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromElement} is null
    # and this set uses natural ordering, or its comparator does
    # not permit null elements
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_set(from_element)
      return tail_set(from_element, true)
    end
    
    typesig { [] }
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
    
    typesig { [Object] }
    # NavigableSet API methods
    # 
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    # and this set uses natural ordering, or its comparator
    # does not permit null elements
    # @since 1.6
    def lower(e)
      return @m.lower_key(e)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    # and this set uses natural ordering, or its comparator
    # does not permit null elements
    # @since 1.6
    def floor(e)
      return @m.floor_key(e)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    # and this set uses natural ordering, or its comparator
    # does not permit null elements
    # @since 1.6
    def ceiling(e)
      return @m.ceiling_key(e)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified element is null
    # and this set uses natural ordering, or its comparator
    # does not permit null elements
    # @since 1.6
    def higher(e)
      return @m.higher_key(e)
    end
    
    typesig { [] }
    # @since 1.6
    def poll_first
      e = @m.poll_first_entry
      return ((e).nil?) ? nil : e.get_key
    end
    
    typesig { [] }
    # @since 1.6
    def poll_last
      e = @m.poll_last_entry
      return ((e).nil?) ? nil : e.get_key
    end
    
    typesig { [] }
    # Returns a shallow copy of this {@code TreeSet} instance. (The elements
    # themselves are not cloned.)
    # 
    # @return a shallow copy of this set
    def clone
      clone = nil
      begin
        clone = super
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
      clone.attr_m = TreeMap.new(@m)
      return clone
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the {@code TreeSet} instance to a stream (that is,
    # serialize it).
    # 
    # @serialData Emits the comparator used to order this set, or
    # {@code null} if it obeys its elements' natural ordering
    # (Object), followed by the size of the set (the number of
    # elements it contains) (int), followed by all of its
    # elements (each an Object) in order (as determined by the
    # set's Comparator, or by the elements' natural ordering if
    # the set has no Comparator).
    def write_object(s)
      # Write out any hidden stuff
      s.default_write_object
      # Write out Comparator
      s.write_object(@m.comparator)
      # Write out size
      s.write_int(@m.size)
      # Write out all elements in the proper order.
      i = @m.key_set.iterator
      while i.has_next
        s.write_object(i.next_)
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the {@code TreeSet} instance from a stream (that is,
    # deserialize it).
    def read_object(s)
      # Read in any hidden stuff
      s.default_read_object
      # Read in Comparator
      c = s.read_object
      # Create backing TreeMap
      tm = nil
      if ((c).nil?)
        tm = TreeMap.new
      else
        tm = TreeMap.new(c)
      end
      @m = tm
      # Read in size
      size_ = s.read_int
      tm.read_tree_set(size_, s, PRESENT)
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2479143000061671589 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__tree_set, :initialize
  end
  
end
