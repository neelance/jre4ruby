require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module HashSetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # This class implements the <tt>Set</tt> interface, backed by a hash table
  # (actually a <tt>HashMap</tt> instance).  It makes no guarantees as to the
  # iteration order of the set; in particular, it does not guarantee that the
  # order will remain constant over time.  This class permits the <tt>null</tt>
  # element.
  # 
  # <p>This class offers constant time performance for the basic operations
  # (<tt>add</tt>, <tt>remove</tt>, <tt>contains</tt> and <tt>size</tt>),
  # assuming the hash function disperses the elements properly among the
  # buckets.  Iterating over this set requires time proportional to the sum of
  # the <tt>HashSet</tt> instance's size (the number of elements) plus the
  # "capacity" of the backing <tt>HashMap</tt> instance (the number of
  # buckets).  Thus, it's very important not to set the initial capacity too
  # high (or the load factor too low) if iteration performance is important.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access a hash set concurrently, and at least one of
  # the threads modifies the set, it <i>must</i> be synchronized externally.
  # This is typically accomplished by synchronizing on some object that
  # naturally encapsulates the set.
  # 
  # If no such object exists, the set should be "wrapped" using the
  # {@link Collections#synchronizedSet Collections.synchronizedSet}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the set:<pre>
  #   Set s = Collections.synchronizedSet(new HashSet(...));</pre>
  # 
  # <p>The iterators returned by this class's <tt>iterator</tt> method are
  # <i>fail-fast</i>: if the set is modified at any time after the iterator is
  # created, in any way except through the iterator's own <tt>remove</tt>
  # method, the Iterator throws a {@link ConcurrentModificationException}.
  # Thus, in the face of concurrent modification, the iterator fails quickly
  # and cleanly, rather than risking arbitrary, non-deterministic behavior at
  # an undetermined time in the future.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw <tt>ConcurrentModificationException</tt> on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness: <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @param <E> the type of elements maintained by this set
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see     Collection
  # @see     Set
  # @see     TreeSet
  # @see     HashMap
  # @since   1.2
  class HashSet < HashSetImports.const_get :AbstractSet
    include_class_members HashSetImports
    overload_protected {
      include JavaSet
      include Cloneable
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -5024744406713321676 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    class_module.module_eval {
      # Dummy value to associate with an Object in the backing Map
      const_set_lazy(:PRESENT) { Object.new }
      const_attr_reader  :PRESENT
    }
    
    typesig { [] }
    # Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
    # default initial capacity (16) and load factor (0.75).
    def initialize
      @map = nil
      super()
      @map = HashMap.new
    end
    
    typesig { [Collection] }
    # Constructs a new set containing the elements in the specified
    # collection.  The <tt>HashMap</tt> is created with default load factor
    # (0.75) and an initial capacity sufficient to contain the elements in
    # the specified collection.
    # 
    # @param c the collection whose elements are to be placed into this set
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      @map = nil
      super()
      @map = HashMap.new(Math.max(((c.size / 0.75)).to_int + 1, 16))
      add_all(c)
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
    # the specified initial capacity and the specified load factor.
    # 
    # @param      initialCapacity   the initial capacity of the hash map
    # @param      loadFactor        the load factor of the hash map
    # @throws     IllegalArgumentException if the initial capacity is less
    #             than zero, or if the load factor is nonpositive
    def initialize(initial_capacity, load_factor)
      @map = nil
      super()
      @map = HashMap.new(initial_capacity, load_factor)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
    # the specified initial capacity and default load factor (0.75).
    # 
    # @param      initialCapacity   the initial capacity of the hash table
    # @throws     IllegalArgumentException if the initial capacity is less
    #             than zero
    def initialize(initial_capacity)
      @map = nil
      super()
      @map = HashMap.new(initial_capacity)
    end
    
    typesig { [::Java::Int, ::Java::Float, ::Java::Boolean] }
    # Constructs a new, empty linked hash set.  (This package private
    # constructor is only used by LinkedHashSet.) The backing
    # HashMap instance is a LinkedHashMap with the specified initial
    # capacity and the specified load factor.
    # 
    # @param      initialCapacity   the initial capacity of the hash map
    # @param      loadFactor        the load factor of the hash map
    # @param      dummy             ignored (distinguishes this
    #             constructor from other int, float constructor.)
    # @throws     IllegalArgumentException if the initial capacity is less
    #             than zero, or if the load factor is nonpositive
    def initialize(initial_capacity, load_factor, dummy)
      @map = nil
      super()
      @map = LinkedHashMap.new(initial_capacity, load_factor)
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this set.  The elements
    # are returned in no particular order.
    # 
    # @return an Iterator over the elements in this set
    # @see ConcurrentModificationException
    def iterator
      return @map.key_set.iterator
    end
    
    typesig { [] }
    # Returns the number of elements in this set (its cardinality).
    # 
    # @return the number of elements in this set (its cardinality)
    def size
      return @map.size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this set contains no elements.
    # 
    # @return <tt>true</tt> if this set contains no elements
    def is_empty
      return @map.is_empty
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this set contains the specified element.
    # More formally, returns <tt>true</tt> if and only if this set
    # contains an element <tt>e</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>.
    # 
    # @param o element whose presence in this set is to be tested
    # @return <tt>true</tt> if this set contains the specified element
    def contains(o)
      return @map.contains_key(o)
    end
    
    typesig { [Object] }
    # Adds the specified element to this set if it is not already present.
    # More formally, adds the specified element <tt>e</tt> to this set if
    # this set contains no element <tt>e2</tt> such that
    # <tt>(e==null&nbsp;?&nbsp;e2==null&nbsp;:&nbsp;e.equals(e2))</tt>.
    # If this set already contains the element, the call leaves the set
    # unchanged and returns <tt>false</tt>.
    # 
    # @param e element to be added to this set
    # @return <tt>true</tt> if this set did not already contain the specified
    # element
    def add(e)
      return (@map.put(e, PRESENT)).nil?
    end
    
    typesig { [Object] }
    # Removes the specified element from this set if it is present.
    # More formally, removes an element <tt>e</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>,
    # if this set contains such an element.  Returns <tt>true</tt> if
    # this set contained the element (or equivalently, if this set
    # changed as a result of the call).  (This set will not contain the
    # element once the call returns.)
    # 
    # @param o object to be removed from this set, if present
    # @return <tt>true</tt> if the set contained the specified element
    def remove(o)
      return (@map.remove(o)).equal?(PRESENT)
    end
    
    typesig { [] }
    # Removes all of the elements from this set.
    # The set will be empty after this call returns.
    def clear
      @map.clear
    end
    
    typesig { [] }
    # Returns a shallow copy of this <tt>HashSet</tt> instance: the elements
    # themselves are not cloned.
    # 
    # @return a shallow copy of this set
    def clone
      begin
        new_set = super
        new_set.attr_map = @map.clone
        return new_set
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of this <tt>HashSet</tt> instance to a stream (that is,
    # serialize it).
    # 
    # @serialData The capacity of the backing <tt>HashMap</tt> instance
    #             (int), and its load factor (float) are emitted, followed by
    #             the size of the set (the number of elements it contains)
    #             (int), followed by all of its elements (each an Object) in
    #             no particular order.
    def write_object(s)
      # Write out any hidden serialization magic
      s.default_write_object
      # Write out HashMap capacity and load factor
      s.write_int(@map.capacity)
      s.write_float(@map.load_factor)
      # Write out size
      s.write_int(@map.size)
      # Write out all elements in the proper order.
      i = @map.key_set.iterator
      while i.has_next
        s.write_object(i.next_)
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the <tt>HashSet</tt> instance from a stream (that is,
    # deserialize it).
    def read_object(s)
      # Read in any hidden serialization magic
      s.default_read_object
      # Read in HashMap capacity and load factor and create backing HashMap
      capacity_ = s.read_int
      load_factor_ = s.read_float
      @map = ((self).is_a?(LinkedHashSet) ? LinkedHashMap.new(capacity_, load_factor_) : HashMap.new(capacity_, load_factor_))
      # Read in size
      size_ = s.read_int
      # Read in all elements in the proper order.
      i = 0
      while i < size_
        e = s.read_object
        @map.put(e, PRESENT)
        i += 1
      end
    end
    
    private
    alias_method :initialize__hash_set, :initialize
  end
  
end
