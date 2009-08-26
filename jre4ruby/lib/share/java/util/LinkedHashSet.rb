require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LinkedHashSetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # <p>Hash table and linked list implementation of the <tt>Set</tt> interface,
  # with predictable iteration order.  This implementation differs from
  # <tt>HashSet</tt> in that it maintains a doubly-linked list running through
  # all of its entries.  This linked list defines the iteration ordering,
  # which is the order in which elements were inserted into the set
  # (<i>insertion-order</i>).  Note that insertion order is <i>not</i> affected
  # if an element is <i>re-inserted</i> into the set.  (An element <tt>e</tt>
  # is reinserted into a set <tt>s</tt> if <tt>s.add(e)</tt> is invoked when
  # <tt>s.contains(e)</tt> would return <tt>true</tt> immediately prior to
  # the invocation.)
  # 
  # <p>This implementation spares its clients from the unspecified, generally
  # chaotic ordering provided by {@link HashSet}, without incurring the
  # increased cost associated with {@link TreeSet}.  It can be used to
  # produce a copy of a set that has the same order as the original, regardless
  # of the original set's implementation:
  # <pre>
  # void foo(Set s) {
  # Set copy = new LinkedHashSet(s);
  # ...
  # }
  # </pre>
  # This technique is particularly useful if a module takes a set on input,
  # copies it, and later returns results whose order is determined by that of
  # the copy.  (Clients generally appreciate having things returned in the same
  # order they were presented.)
  # 
  # <p>This class provides all of the optional <tt>Set</tt> operations, and
  # permits null elements.  Like <tt>HashSet</tt>, it provides constant-time
  # performance for the basic operations (<tt>add</tt>, <tt>contains</tt> and
  # <tt>remove</tt>), assuming the hash function disperses elements
  # properly among the buckets.  Performance is likely to be just slightly
  # below that of <tt>HashSet</tt>, due to the added expense of maintaining the
  # linked list, with one exception: Iteration over a <tt>LinkedHashSet</tt>
  # requires time proportional to the <i>size</i> of the set, regardless of
  # its capacity.  Iteration over a <tt>HashSet</tt> is likely to be more
  # expensive, requiring time proportional to its <i>capacity</i>.
  # 
  # <p>A linked hash set has two parameters that affect its performance:
  # <i>initial capacity</i> and <i>load factor</i>.  They are defined precisely
  # as for <tt>HashSet</tt>.  Note, however, that the penalty for choosing an
  # excessively high value for initial capacity is less severe for this class
  # than for <tt>HashSet</tt>, as iteration times for this class are unaffected
  # by capacity.
  # 
  # <p><strong>Note that this implementation is not synchronized.</strong>
  # If multiple threads access a linked hash set concurrently, and at least
  # one of the threads modifies the set, it <em>must</em> be synchronized
  # externally.  This is typically accomplished by synchronizing on some
  # object that naturally encapsulates the set.
  # 
  # If no such object exists, the set should be "wrapped" using the
  # {@link Collections#synchronizedSet Collections.synchronizedSet}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access to the set: <pre>
  # Set s = Collections.synchronizedSet(new LinkedHashSet(...));</pre>
  # 
  # <p>The iterators returned by this class's <tt>iterator</tt> method are
  # <em>fail-fast</em>: if the set is modified at any time after the iterator
  # is created, in any way except through the iterator's own <tt>remove</tt>
  # method, the iterator will throw a {@link ConcurrentModificationException}.
  # Thus, in the face of concurrent modification, the iterator fails quickly
  # and cleanly, rather than risking arbitrary, non-deterministic behavior at
  # an undetermined time in the future.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw <tt>ConcurrentModificationException</tt> on a best-effort basis.
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
  # @see     Object#hashCode()
  # @see     Collection
  # @see     Set
  # @see     HashSet
  # @see     TreeSet
  # @see     Hashtable
  # @since   1.4
  class LinkedHashSet < LinkedHashSetImports.const_get :HashSet
    include_class_members LinkedHashSetImports
    overload_protected {
      include JavaSet
      include Cloneable
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2851667679971038690 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Int, ::Java::Float] }
    # Constructs a new, empty linked hash set with the specified initial
    # capacity and load factor.
    # 
    # @param      initialCapacity the initial capacity of the linked hash set
    # @param      loadFactor      the load factor of the linked hash set
    # @throws     IllegalArgumentException  if the initial capacity is less
    # than zero, or if the load factor is nonpositive
    def initialize(initial_capacity, load_factor)
      super(initial_capacity, load_factor, true)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new, empty linked hash set with the specified initial
    # capacity and the default load factor (0.75).
    # 
    # @param   initialCapacity   the initial capacity of the LinkedHashSet
    # @throws  IllegalArgumentException if the initial capacity is less
    # than zero
    def initialize(initial_capacity)
      super(initial_capacity, 0.75, true)
    end
    
    typesig { [] }
    # Constructs a new, empty linked hash set with the default initial
    # capacity (16) and load factor (0.75).
    def initialize
      super(16, 0.75, true)
    end
    
    typesig { [Collection] }
    # Constructs a new linked hash set with the same elements as the
    # specified collection.  The linked hash set is created with an initial
    # capacity sufficient to hold the elements in the specified collection
    # and the default load factor (0.75).
    # 
    # @param c  the collection whose elements are to be placed into
    # this set
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      super(Math.max(2 * c.size, 11), 0.75, true)
      add_all(c)
    end
    
    private
    alias_method :initialize__linked_hash_set, :initialize
  end
  
end