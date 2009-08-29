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
  module CopyOnWriteArraySetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
    }
  end
  
  # A {@link java.util.Set} that uses an internal {@link CopyOnWriteArrayList}
  # for all of its operations.  Thus, it shares the same basic properties:
  # <ul>
  # <li>It is best suited for applications in which set sizes generally
  # stay small, read-only operations
  # vastly outnumber mutative operations, and you need
  # to prevent interference among threads during traversal.
  # <li>It is thread-safe.
  # <li>Mutative operations (<tt>add</tt>, <tt>set</tt>, <tt>remove</tt>, etc.)
  # are expensive since they usually entail copying the entire underlying
  # array.
  # <li>Iterators do not support the mutative <tt>remove</tt> operation.
  # <li>Traversal via iterators is fast and cannot encounter
  # interference from other threads. Iterators rely on
  # unchanging snapshots of the array at the time the iterators were
  # constructed.
  # </ul>
  # 
  # <p> <b>Sample Usage.</b> The following code sketch uses a
  # copy-on-write set to maintain a set of Handler objects that
  # perform some action upon state updates.
  # 
  # <pre>
  # class Handler { void handle(); ... }
  # 
  # class X {
  # private final CopyOnWriteArraySet&lt;Handler&gt; handlers
  # = new CopyOnWriteArraySet&lt;Handler&gt;();
  # public void addHandler(Handler h) { handlers.add(h); }
  # 
  # private long internalState;
  # private synchronized void changeState() { internalState = ...; }
  # 
  # public void update() {
  # changeState();
  # for (Handler handler : handlers)
  # handler.handle();
  # }
  # }
  # </pre>
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @see CopyOnWriteArrayList
  # @since 1.5
  # @author Doug Lea
  # @param <E> the type of elements held in this collection
  class CopyOnWriteArraySet < CopyOnWriteArraySetImports.const_get :AbstractSet
    include_class_members CopyOnWriteArraySetImports
    overload_protected {
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5457747651344034263 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :al
    alias_method :attr_al, :al
    undef_method :al
    alias_method :attr_al=, :al=
    undef_method :al=
    
    typesig { [] }
    # Creates an empty set.
    def initialize
      @al = nil
      super()
      @al = CopyOnWriteArrayList.new
    end
    
    typesig { [Collection] }
    # Creates a set containing all of the elements of the specified
    # collection.
    # 
    # @param c the collection of elements to initially contain
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      @al = nil
      super()
      @al = CopyOnWriteArrayList.new
      @al.add_all_absent(c)
    end
    
    typesig { [] }
    # Returns the number of elements in this set.
    # 
    # @return the number of elements in this set
    def size
      return @al.size
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this set contains no elements.
    # 
    # @return <tt>true</tt> if this set contains no elements
    def is_empty
      return @al.is_empty
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
      return @al.contains(o)
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this set.
    # If this set makes any guarantees as to what order its elements
    # are returned by its iterator, this method must return the
    # elements in the same order.
    # 
    # <p>The returned array will be "safe" in that no references to it
    # are maintained by this set.  (In other words, this method must
    # allocate a new array even if this set is backed by an array).
    # The caller is thus free to modify the returned array.
    # 
    # <p>This method acts as bridge between array-based and collection-based
    # APIs.
    # 
    # @return an array containing all the elements in this set
    def to_array
      return @al.to_array
    end
    
    typesig { [Array.typed(T)] }
    # Returns an array containing all of the elements in this set; the
    # runtime type of the returned array is that of the specified array.
    # If the set fits in the specified array, it is returned therein.
    # Otherwise, a new array is allocated with the runtime type of the
    # specified array and the size of this set.
    # 
    # <p>If this set fits in the specified array with room to spare
    # (i.e., the array has more elements than this set), the element in
    # the array immediately following the end of the set is set to
    # <tt>null</tt>.  (This is useful in determining the length of this
    # set <i>only</i> if the caller knows that this set does not contain
    # any null elements.)
    # 
    # <p>If this set makes any guarantees as to what order its elements
    # are returned by its iterator, this method must return the elements
    # in the same order.
    # 
    # <p>Like the {@link #toArray()} method, this method acts as bridge between
    # array-based and collection-based APIs.  Further, this method allows
    # precise control over the runtime type of the output array, and may,
    # under certain circumstances, be used to save allocation costs.
    # 
    # <p>Suppose <tt>x</tt> is a set known to contain only strings.
    # The following code can be used to dump the set into a newly allocated
    # array of <tt>String</tt>:
    # 
    # <pre>
    # String[] y = x.toArray(new String[0]);</pre>
    # 
    # Note that <tt>toArray(new Object[0])</tt> is identical in function to
    # <tt>toArray()</tt>.
    # 
    # @param a the array into which the elements of this set are to be
    # stored, if it is big enough; otherwise, a new array of the same
    # runtime type is allocated for this purpose.
    # @return an array containing all the elements in this set
    # @throws ArrayStoreException if the runtime type of the specified array
    # is not a supertype of the runtime type of every element in this
    # set
    # @throws NullPointerException if the specified array is null
    def to_array(a)
      return @al.to_array(a)
    end
    
    typesig { [] }
    # Removes all of the elements from this set.
    # The set will be empty after this call returns.
    def clear
      @al.clear
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
    # @return <tt>true</tt> if this set contained the specified element
    def remove(o)
      return @al.remove(o)
    end
    
    typesig { [Object] }
    # Adds the specified element to this set if it is not already present.
    # More formally, adds the specified element <tt>e</tt> to this set if
    # the set contains no element <tt>e2</tt> such that
    # <tt>(e==null&nbsp;?&nbsp;e2==null&nbsp;:&nbsp;e.equals(e2))</tt>.
    # If this set already contains the element, the call leaves the set
    # unchanged and returns <tt>false</tt>.
    # 
    # @param e element to be added to this set
    # @return <tt>true</tt> if this set did not already contain the specified
    # element
    def add(e)
      return @al.add_if_absent(e)
    end
    
    typesig { [Collection] }
    # Returns <tt>true</tt> if this set contains all of the elements of the
    # specified collection.  If the specified collection is also a set, this
    # method returns <tt>true</tt> if it is a <i>subset</i> of this set.
    # 
    # @param  c collection to be checked for containment in this set
    # @return <tt>true</tt> if this set contains all of the elements of the
    # specified collection
    # @throws NullPointerException if the specified collection is null
    # @see #contains(Object)
    def contains_all(c)
      return @al.contains_all(c)
    end
    
    typesig { [Collection] }
    # Adds all of the elements in the specified collection to this set if
    # they're not already present.  If the specified collection is also a
    # set, the <tt>addAll</tt> operation effectively modifies this set so
    # that its value is the <i>union</i> of the two sets.  The behavior of
    # this operation is undefined if the specified collection is modified
    # while the operation is in progress.
    # 
    # @param  c collection containing elements to be added to this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    # @see #add(Object)
    def add_all(c)
      return @al.add_all_absent(c) > 0
    end
    
    typesig { [Collection] }
    # Removes from this set all of its elements that are contained in the
    # specified collection.  If the specified collection is also a set,
    # this operation effectively modifies this set so that its value is the
    # <i>asymmetric set difference</i> of the two sets.
    # 
    # @param  c collection containing elements to be removed from this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws ClassCastException if the class of an element of this set
    # is incompatible with the specified collection (optional)
    # @throws NullPointerException if this set contains a null element and the
    # specified collection does not permit null elements (optional),
    # or if the specified collection is null
    # @see #remove(Object)
    def remove_all(c)
      return @al.remove_all(c)
    end
    
    typesig { [Collection] }
    # Retains only the elements in this set that are contained in the
    # specified collection.  In other words, removes from this set all of
    # its elements that are not contained in the specified collection.  If
    # the specified collection is also a set, this operation effectively
    # modifies this set so that its value is the <i>intersection</i> of the
    # two sets.
    # 
    # @param  c collection containing elements to be retained in this set
    # @return <tt>true</tt> if this set changed as a result of the call
    # @throws ClassCastException if the class of an element of this set
    # is incompatible with the specified collection (optional)
    # @throws NullPointerException if this set contains a null element and the
    # specified collection does not permit null elements (optional),
    # or if the specified collection is null
    # @see #remove(Object)
    def retain_all(c)
      return @al.retain_all(c)
    end
    
    typesig { [] }
    # Returns an iterator over the elements contained in this set
    # in the order in which these elements were added.
    # 
    # <p>The returned iterator provides a snapshot of the state of the set
    # when the iterator was constructed. No synchronization is needed while
    # traversing the iterator. The iterator does <em>NOT</em> support the
    # <tt>remove</tt> method.
    # 
    # @return an iterator over the elements in this set
    def iterator
      return @al.iterator
    end
    
    typesig { [Object] }
    # Compares the specified object with this set for equality.
    # Returns {@code true} if the specified object is the same object
    # as this object, or if it is also a {@link Set} and the elements
    # returned by an {@linkplain List#iterator() iterator} over the
    # specified set are the same as the elements returned by an
    # iterator over this set.  More formally, the two iterators are
    # considered to return the same elements if they return the same
    # number of elements and for every element {@code e1} returned by
    # the iterator over the specified set, there is an element
    # {@code e2} returned by the iterator over this set such that
    # {@code (e1==null ? e2==null : e1.equals(e2))}.
    # 
    # @param o object to be compared for equality with this set
    # @return {@code true} if the specified object is equal to this set
    def ==(o)
      if ((o).equal?(self))
        return true
      end
      if (!(o.is_a?(JavaSet)))
        return false
      end
      set = (o)
      it = set.iterator
      # Uses O(n^2) algorithm that is only appropriate
      # for small sets, which CopyOnWriteArraySets should be.
      # Use a single snapshot of underlying array
      elements = @al.get_array
      len = elements.attr_length
      # Mark matched elements to avoid re-checking
      matched = Array.typed(::Java::Boolean).new(len) { false }
      k = 0
      while (it.has_next)
        catch(:next_outer) do
          if ((k += 1) > len)
            return false
          end
          x = it.next_
          i = 0
          while i < len
            if (!matched[i] && eq(x, elements[i]))
              matched[i] = true
              throw :next_outer, :thrown
            end
            (i += 1)
          end
          return false
        end
      end
      return (k).equal?(len)
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # Test for equality, coping with nulls.
      def eq(o1, o2)
        return ((o1).nil? ? (o2).nil? : (o1 == o2))
      end
    }
    
    private
    alias_method :initialize__copy_on_write_array_set, :initialize
  end
  
end
