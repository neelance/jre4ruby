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
  module CollectionsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :Serializable
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang::Reflect, :Array
    }
  end
  
  # This class consists exclusively of static methods that operate on or return
  # collections.  It contains polymorphic algorithms that operate on
  # collections, "wrappers", which return a new collection backed by a
  # specified collection, and a few other odds and ends.
  # 
  # <p>The methods of this class all throw a <tt>NullPointerException</tt>
  # if the collections or class objects provided to them are null.
  # 
  # <p>The documentation for the polymorphic algorithms contained in this class
  # generally includes a brief description of the <i>implementation</i>.  Such
  # descriptions should be regarded as <i>implementation notes</i>, rather than
  # parts of the <i>specification</i>.  Implementors should feel free to
  # substitute other algorithms, so long as the specification itself is adhered
  # to.  (For example, the algorithm used by <tt>sort</tt> does not have to be
  # a mergesort, but it does have to be <i>stable</i>.)
  # 
  # <p>The "destructive" algorithms contained in this class, that is, the
  # algorithms that modify the collection on which they operate, are specified
  # to throw <tt>UnsupportedOperationException</tt> if the collection does not
  # support the appropriate mutation primitive(s), such as the <tt>set</tt>
  # method.  These algorithms may, but are not required to, throw this
  # exception if an invocation would have no effect on the collection.  For
  # example, invoking the <tt>sort</tt> method on an unmodifiable list that is
  # already sorted may or may not throw <tt>UnsupportedOperationException</tt>.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see     Collection
  # @see     Set
  # @see     List
  # @see     Map
  # @since   1.2
  class Collections 
    include_class_members CollectionsImports
    
    typesig { [] }
    # Suppresses default constructor, ensuring non-instantiability.
    def initialize
    end
    
    class_module.module_eval {
      # Algorithms
      # 
      # Tuning parameters for algorithms - Many of the List algorithms have
      # two implementations, one of which is appropriate for RandomAccess
      # lists, the other for "sequential."  Often, the random access variant
      # yields better performance on small sequential access lists.  The
      # tuning parameters below determine the cutoff point for what constitutes
      # a "small" sequential access list for each algorithm.  The values below
      # were empirically determined to work well for LinkedList. Hopefully
      # they should be reasonable for other sequential access List
      # implementations.  Those doing performance work on this code would
      # do well to validate the values of these parameters from time to time.
      # (The first word of each tuning parameter name is the algorithm to which
      # it applies.)
      const_set_lazy(:BINARYSEARCH_THRESHOLD) { 5000 }
      const_attr_reader  :BINARYSEARCH_THRESHOLD
      
      const_set_lazy(:REVERSE_THRESHOLD) { 18 }
      const_attr_reader  :REVERSE_THRESHOLD
      
      const_set_lazy(:SHUFFLE_THRESHOLD) { 5 }
      const_attr_reader  :SHUFFLE_THRESHOLD
      
      const_set_lazy(:FILL_THRESHOLD) { 25 }
      const_attr_reader  :FILL_THRESHOLD
      
      const_set_lazy(:ROTATE_THRESHOLD) { 100 }
      const_attr_reader  :ROTATE_THRESHOLD
      
      const_set_lazy(:COPY_THRESHOLD) { 10 }
      const_attr_reader  :COPY_THRESHOLD
      
      const_set_lazy(:REPLACEALL_THRESHOLD) { 11 }
      const_attr_reader  :REPLACEALL_THRESHOLD
      
      const_set_lazy(:INDEXOFSUBLIST_THRESHOLD) { 35 }
      const_attr_reader  :INDEXOFSUBLIST_THRESHOLD
      
      typesig { [JavaList] }
      # Sorts the specified list into ascending order, according to the
      # <i>natural ordering</i> of its elements.  All elements in the list must
      # implement the <tt>Comparable</tt> interface.  Furthermore, all elements
      # in the list must be <i>mutually comparable</i> (that is,
      # <tt>e1.compareTo(e2)</tt> must not throw a <tt>ClassCastException</tt>
      # for any elements <tt>e1</tt> and <tt>e2</tt> in the list).<p>
      # 
      # This sort is guaranteed to be <i>stable</i>:  equal elements will
      # not be reordered as a result of the sort.<p>
      # 
      # The specified list must be modifiable, but need not be resizable.<p>
      # 
      # The sorting algorithm is a modified mergesort (in which the merge is
      # omitted if the highest element in the low sublist is less than the
      # lowest element in the high sublist).  This algorithm offers guaranteed
      # n log(n) performance.
      # 
      # This implementation dumps the specified list into an array, sorts
      # the array, and iterates over the list resetting each element
      # from the corresponding position in the array.  This avoids the
      # n<sup>2</sup> log(n) performance that would result from attempting
      # to sort a linked list in place.
      # 
      # @param  list the list to be sorted.
      # @throws ClassCastException if the list contains elements that are not
      # <i>mutually comparable</i> (for example, strings and integers).
      # @throws UnsupportedOperationException if the specified list's
      # list-iterator does not support the <tt>set</tt> operation.
      # @see Comparable
      def sort(list)
        a = list.to_array
        Arrays.sort(a)
        i = list.list_iterator
        j = 0
        while j < a.attr_length
          i.next_
          i.set(a[j])
          j += 1
        end
      end
      
      typesig { [JavaList, Comparator] }
      # Sorts the specified list according to the order induced by the
      # specified comparator.  All elements in the list must be <i>mutually
      # comparable</i> using the specified comparator (that is,
      # <tt>c.compare(e1, e2)</tt> must not throw a <tt>ClassCastException</tt>
      # for any elements <tt>e1</tt> and <tt>e2</tt> in the list).<p>
      # 
      # This sort is guaranteed to be <i>stable</i>:  equal elements will
      # not be reordered as a result of the sort.<p>
      # 
      # The sorting algorithm is a modified mergesort (in which the merge is
      # omitted if the highest element in the low sublist is less than the
      # lowest element in the high sublist).  This algorithm offers guaranteed
      # n log(n) performance.
      # 
      # The specified list must be modifiable, but need not be resizable.
      # This implementation dumps the specified list into an array, sorts
      # the array, and iterates over the list resetting each element
      # from the corresponding position in the array.  This avoids the
      # n<sup>2</sup> log(n) performance that would result from attempting
      # to sort a linked list in place.
      # 
      # @param  list the list to be sorted.
      # @param  c the comparator to determine the order of the list.  A
      # <tt>null</tt> value indicates that the elements' <i>natural
      # ordering</i> should be used.
      # @throws ClassCastException if the list contains elements that are not
      # <i>mutually comparable</i> using the specified comparator.
      # @throws UnsupportedOperationException if the specified list's
      # list-iterator does not support the <tt>set</tt> operation.
      # @see Comparator
      def sort(list, c)
        a = list.to_array
        Arrays.sort(a, c)
        i = list.list_iterator
        j = 0
        while j < a.attr_length
          i.next_
          i.set(a[j])
          j += 1
        end
      end
      
      typesig { [JavaList, T] }
      # Searches the specified list for the specified object using the binary
      # search algorithm.  The list must be sorted into ascending order
      # according to the {@linkplain Comparable natural ordering} of its
      # elements (as by the {@link #sort(List)} method) prior to making this
      # call.  If it is not sorted, the results are undefined.  If the list
      # contains multiple elements equal to the specified object, there is no
      # guarantee which one will be found.
      # 
      # <p>This method runs in log(n) time for a "random access" list (which
      # provides near-constant-time positional access).  If the specified list
      # does not implement the {@link RandomAccess} interface and is large,
      # this method will do an iterator-based binary search that performs
      # O(n) link traversals and O(log n) element comparisons.
      # 
      # @param  list the list to be searched.
      # @param  key the key to be searched for.
      # @return the index of the search key, if it is contained in the list;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the list: the index of the first
      # element greater than the key, or <tt>list.size()</tt> if all
      # elements in the list are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws ClassCastException if the list contains elements that are not
      # <i>mutually comparable</i> (for example, strings and
      # integers), or the search key is not mutually comparable
      # with the elements of the list.
      def binary_search(list, key)
        if (list.is_a?(RandomAccess) || list.size < BINARYSEARCH_THRESHOLD)
          return Collections.indexed_binary_search(list, key)
        else
          return Collections.iterator_binary_search(list, key)
        end
      end
      
      typesig { [JavaList, T] }
      def indexed_binary_search(list, key)
        low = 0
        high = list.size - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = list.get(mid)
          cmp = (mid_val <=> key)
          if (cmp < 0)
            low = mid + 1
          else
            if (cmp > 0)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found
      end
      
      typesig { [JavaList, T] }
      def iterator_binary_search(list, key)
        low = 0
        high = list.size - 1
        i = list.list_iterator
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = get(i, mid)
          cmp = (mid_val <=> key)
          if (cmp < 0)
            low = mid + 1
          else
            if (cmp > 0)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found
      end
      
      typesig { [ListIterator, ::Java::Int] }
      # Gets the ith element from the given list by repositioning the specified
      # list listIterator.
      def get(i, index)
        obj = nil
        pos = i.next_index
        if (pos <= index)
          begin
            obj = i.next_
          end while (((pos += 1) - 1) < index)
        else
          begin
            obj = i.previous
          end while ((pos -= 1) > index)
        end
        return obj
      end
      
      typesig { [JavaList, T, Comparator] }
      # Searches the specified list for the specified object using the binary
      # search algorithm.  The list must be sorted into ascending order
      # according to the specified comparator (as by the
      # {@link #sort(List, Comparator) sort(List, Comparator)}
      # method), prior to making this call.  If it is
      # not sorted, the results are undefined.  If the list contains multiple
      # elements equal to the specified object, there is no guarantee which one
      # will be found.
      # 
      # <p>This method runs in log(n) time for a "random access" list (which
      # provides near-constant-time positional access).  If the specified list
      # does not implement the {@link RandomAccess} interface and is large,
      # this method will do an iterator-based binary search that performs
      # O(n) link traversals and O(log n) element comparisons.
      # 
      # @param  list the list to be searched.
      # @param  key the key to be searched for.
      # @param  c the comparator by which the list is ordered.
      # A <tt>null</tt> value indicates that the elements'
      # {@linkplain Comparable natural ordering} should be used.
      # @return the index of the search key, if it is contained in the list;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the list: the index of the first
      # element greater than the key, or <tt>list.size()</tt> if all
      # elements in the list are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws ClassCastException if the list contains elements that are not
      # <i>mutually comparable</i> using the specified comparator,
      # or the search key is not mutually comparable with the
      # elements of the list using this comparator.
      def binary_search(list, key, c)
        if ((c).nil?)
          return binary_search(list, key)
        end
        if (list.is_a?(RandomAccess) || list.size < BINARYSEARCH_THRESHOLD)
          return Collections.indexed_binary_search(list, key, c)
        else
          return Collections.iterator_binary_search(list, key, c)
        end
      end
      
      typesig { [JavaList, T, Comparator] }
      def indexed_binary_search(l, key, c)
        low = 0
        high = l.size - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = l.get(mid)
          cmp = c.compare(mid_val, key)
          if (cmp < 0)
            low = mid + 1
          else
            if (cmp > 0)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found
      end
      
      typesig { [JavaList, T, Comparator] }
      def iterator_binary_search(l, key, c)
        low = 0
        high = l.size - 1
        i = l.list_iterator
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = get(i, mid)
          cmp = c.compare(mid_val, key)
          if (cmp < 0)
            low = mid + 1
          else
            if (cmp > 0)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found
      end
      
      const_set_lazy(:SelfComparable) { Module.new do
        include_class_members Collections
        include JavaComparable
      end }
      
      typesig { [JavaList] }
      # Reverses the order of the elements in the specified list.<p>
      # 
      # This method runs in linear time.
      # 
      # @param  list the list whose elements are to be reversed.
      # @throws UnsupportedOperationException if the specified list or
      # its list-iterator does not support the <tt>set</tt> operation.
      def reverse(list)
        size_ = list.size
        if (size_ < REVERSE_THRESHOLD || list.is_a?(RandomAccess))
          i = 0
          mid = size_ >> 1
          j = size_ - 1
          while i < mid
            swap(list, i, j)
            i += 1
            j -= 1
          end
        else
          fwd = list.list_iterator
          rev = list.list_iterator(size_)
          i = 0
          mid = list.size >> 1
          while i < mid
            tmp = fwd.next_
            fwd.set(rev.previous)
            rev.set(tmp)
            i += 1
          end
        end
      end
      
      typesig { [JavaList] }
      # Randomly permutes the specified list using a default source of
      # randomness.  All permutations occur with approximately equal
      # likelihood.<p>
      # 
      # The hedge "approximately" is used in the foregoing description because
      # default source of randomness is only approximately an unbiased source
      # of independently chosen bits. If it were a perfect source of randomly
      # chosen bits, then the algorithm would choose permutations with perfect
      # uniformity.<p>
      # 
      # This implementation traverses the list backwards, from the last element
      # up to the second, repeatedly swapping a randomly selected element into
      # the "current position".  Elements are randomly selected from the
      # portion of the list that runs from the first element to the current
      # position, inclusive.<p>
      # 
      # This method runs in linear time.  If the specified list does not
      # implement the {@link RandomAccess} interface and is large, this
      # implementation dumps the specified list into an array before shuffling
      # it, and dumps the shuffled array back into the list.  This avoids the
      # quadratic behavior that would result from shuffling a "sequential
      # access" list in place.
      # 
      # @param  list the list to be shuffled.
      # @throws UnsupportedOperationException if the specified list or
      # its list-iterator does not support the <tt>set</tt> operation.
      def shuffle(list)
        if ((self.attr_r).nil?)
          self.attr_r = Random.new
        end
        shuffle(list, self.attr_r)
      end
      
      
      def r
        defined?(@@r) ? @@r : @@r= nil
      end
      alias_method :attr_r, :r
      
      def r=(value)
        @@r = value
      end
      alias_method :attr_r=, :r=
      
      typesig { [JavaList, Random] }
      # Randomly permute the specified list using the specified source of
      # randomness.  All permutations occur with equal likelihood
      # assuming that the source of randomness is fair.<p>
      # 
      # This implementation traverses the list backwards, from the last element
      # up to the second, repeatedly swapping a randomly selected element into
      # the "current position".  Elements are randomly selected from the
      # portion of the list that runs from the first element to the current
      # position, inclusive.<p>
      # 
      # This method runs in linear time.  If the specified list does not
      # implement the {@link RandomAccess} interface and is large, this
      # implementation dumps the specified list into an array before shuffling
      # it, and dumps the shuffled array back into the list.  This avoids the
      # quadratic behavior that would result from shuffling a "sequential
      # access" list in place.
      # 
      # @param  list the list to be shuffled.
      # @param  rnd the source of randomness to use to shuffle the list.
      # @throws UnsupportedOperationException if the specified list or its
      # list-iterator does not support the <tt>set</tt> operation.
      def shuffle(list, rnd)
        size_ = list.size
        if (size_ < SHUFFLE_THRESHOLD || list.is_a?(RandomAccess))
          i = size_
          while i > 1
            swap(list, i - 1, rnd.next_int(i))
            i -= 1
          end
        else
          arr = list.to_array
          # Shuffle array
          i = size_
          while i > 1
            swap(arr, i - 1, rnd.next_int(i))
            i -= 1
          end
          # Dump array back into list
          it = list.list_iterator
          i_ = 0
          while i_ < arr.attr_length
            it.next_
            it.set(arr[i_])
            i_ += 1
          end
        end
      end
      
      typesig { [JavaList, ::Java::Int, ::Java::Int] }
      # Swaps the elements at the specified positions in the specified list.
      # (If the specified positions are equal, invoking this method leaves
      # the list unchanged.)
      # 
      # @param list The list in which to swap elements.
      # @param i the index of one element to be swapped.
      # @param j the index of the other element to be swapped.
      # @throws IndexOutOfBoundsException if either <tt>i</tt> or <tt>j</tt>
      # is out of range (i &lt; 0 || i &gt;= list.size()
      # || j &lt; 0 || j &gt;= list.size()).
      # @since 1.4
      def swap(list, i, j)
        l = list
        l.set(i, l.set(j, l.get(i)))
      end
      
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int] }
      # Swaps the two specified elements in the specified array.
      def swap(arr, i, j)
        tmp = arr[i]
        arr[i] = arr[j]
        arr[j] = tmp
      end
      
      typesig { [JavaList, T] }
      # Replaces all of the elements of the specified list with the specified
      # element. <p>
      # 
      # This method runs in linear time.
      # 
      # @param  list the list to be filled with the specified element.
      # @param  obj The element with which to fill the specified list.
      # @throws UnsupportedOperationException if the specified list or its
      # list-iterator does not support the <tt>set</tt> operation.
      def fill(list, obj)
        size_ = list.size
        if (size_ < FILL_THRESHOLD || list.is_a?(RandomAccess))
          i = 0
          while i < size_
            list.set(i, obj)
            i += 1
          end
        else
          itr = list.list_iterator
          i = 0
          while i < size_
            itr.next_
            itr.set(obj)
            i += 1
          end
        end
      end
      
      typesig { [JavaList, JavaList] }
      # Copies all of the elements from one list into another.  After the
      # operation, the index of each copied element in the destination list
      # will be identical to its index in the source list.  The destination
      # list must be at least as long as the source list.  If it is longer, the
      # remaining elements in the destination list are unaffected. <p>
      # 
      # This method runs in linear time.
      # 
      # @param  dest The destination list.
      # @param  src The source list.
      # @throws IndexOutOfBoundsException if the destination list is too small
      # to contain the entire source List.
      # @throws UnsupportedOperationException if the destination list's
      # list-iterator does not support the <tt>set</tt> operation.
      def copy(dest, src)
        src_size = src.size
        if (src_size > dest.size)
          raise IndexOutOfBoundsException.new("Source does not fit in dest")
        end
        if (src_size < COPY_THRESHOLD || (src.is_a?(RandomAccess) && dest.is_a?(RandomAccess)))
          i = 0
          while i < src_size
            dest.set(i, src.get(i))
            i += 1
          end
        else
          di = dest.list_iterator
          si = src.list_iterator
          i = 0
          while i < src_size
            di.next_
            di.set(si.next_)
            i += 1
          end
        end
      end
      
      typesig { [Collection] }
      # Returns the minimum element of the given collection, according to the
      # <i>natural ordering</i> of its elements.  All elements in the
      # collection must implement the <tt>Comparable</tt> interface.
      # Furthermore, all elements in the collection must be <i>mutually
      # comparable</i> (that is, <tt>e1.compareTo(e2)</tt> must not throw a
      # <tt>ClassCastException</tt> for any elements <tt>e1</tt> and
      # <tt>e2</tt> in the collection).<p>
      # 
      # This method iterates over the entire collection, hence it requires
      # time proportional to the size of the collection.
      # 
      # @param  coll the collection whose minimum element is to be determined.
      # @return the minimum element of the given collection, according
      # to the <i>natural ordering</i> of its elements.
      # @throws ClassCastException if the collection contains elements that are
      # not <i>mutually comparable</i> (for example, strings and
      # integers).
      # @throws NoSuchElementException if the collection is empty.
      # @see Comparable
      def min(coll)
        i = coll.iterator
        candidate = i.next_
        while (i.has_next)
          next__ = i.next_
          if ((next__ <=> candidate) < 0)
            candidate = next__
          end
        end
        return candidate
      end
      
      typesig { [Collection, Comparator] }
      # Returns the minimum element of the given collection, according to the
      # order induced by the specified comparator.  All elements in the
      # collection must be <i>mutually comparable</i> by the specified
      # comparator (that is, <tt>comp.compare(e1, e2)</tt> must not throw a
      # <tt>ClassCastException</tt> for any elements <tt>e1</tt> and
      # <tt>e2</tt> in the collection).<p>
      # 
      # This method iterates over the entire collection, hence it requires
      # time proportional to the size of the collection.
      # 
      # @param  coll the collection whose minimum element is to be determined.
      # @param  comp the comparator with which to determine the minimum element.
      # A <tt>null</tt> value indicates that the elements' <i>natural
      # ordering</i> should be used.
      # @return the minimum element of the given collection, according
      # to the specified comparator.
      # @throws ClassCastException if the collection contains elements that are
      # not <i>mutually comparable</i> using the specified comparator.
      # @throws NoSuchElementException if the collection is empty.
      # @see Comparable
      def min(coll, comp)
        if ((comp).nil?)
          return min(coll)
        end
        i = coll.iterator
        candidate = i.next_
        while (i.has_next)
          next__ = i.next_
          if (comp.compare(next__, candidate) < 0)
            candidate = next__
          end
        end
        return candidate
      end
      
      typesig { [Collection] }
      # Returns the maximum element of the given collection, according to the
      # <i>natural ordering</i> of its elements.  All elements in the
      # collection must implement the <tt>Comparable</tt> interface.
      # Furthermore, all elements in the collection must be <i>mutually
      # comparable</i> (that is, <tt>e1.compareTo(e2)</tt> must not throw a
      # <tt>ClassCastException</tt> for any elements <tt>e1</tt> and
      # <tt>e2</tt> in the collection).<p>
      # 
      # This method iterates over the entire collection, hence it requires
      # time proportional to the size of the collection.
      # 
      # @param  coll the collection whose maximum element is to be determined.
      # @return the maximum element of the given collection, according
      # to the <i>natural ordering</i> of its elements.
      # @throws ClassCastException if the collection contains elements that are
      # not <i>mutually comparable</i> (for example, strings and
      # integers).
      # @throws NoSuchElementException if the collection is empty.
      # @see Comparable
      def max(coll)
        i = coll.iterator
        candidate = i.next_
        while (i.has_next)
          next__ = i.next_
          if ((next__ <=> candidate) > 0)
            candidate = next__
          end
        end
        return candidate
      end
      
      typesig { [Collection, Comparator] }
      # Returns the maximum element of the given collection, according to the
      # order induced by the specified comparator.  All elements in the
      # collection must be <i>mutually comparable</i> by the specified
      # comparator (that is, <tt>comp.compare(e1, e2)</tt> must not throw a
      # <tt>ClassCastException</tt> for any elements <tt>e1</tt> and
      # <tt>e2</tt> in the collection).<p>
      # 
      # This method iterates over the entire collection, hence it requires
      # time proportional to the size of the collection.
      # 
      # @param  coll the collection whose maximum element is to be determined.
      # @param  comp the comparator with which to determine the maximum element.
      # A <tt>null</tt> value indicates that the elements' <i>natural
      # ordering</i> should be used.
      # @return the maximum element of the given collection, according
      # to the specified comparator.
      # @throws ClassCastException if the collection contains elements that are
      # not <i>mutually comparable</i> using the specified comparator.
      # @throws NoSuchElementException if the collection is empty.
      # @see Comparable
      def max(coll, comp)
        if ((comp).nil?)
          return max(coll)
        end
        i = coll.iterator
        candidate = i.next_
        while (i.has_next)
          next__ = i.next_
          if (comp.compare(next__, candidate) > 0)
            candidate = next__
          end
        end
        return candidate
      end
      
      typesig { [JavaList, ::Java::Int] }
      # Rotates the elements in the specified list by the specified distance.
      # After calling this method, the element at index <tt>i</tt> will be
      # the element previously at index <tt>(i - distance)</tt> mod
      # <tt>list.size()</tt>, for all values of <tt>i</tt> between <tt>0</tt>
      # and <tt>list.size()-1</tt>, inclusive.  (This method has no effect on
      # the size of the list.)
      # 
      # <p>For example, suppose <tt>list</tt> comprises<tt> [t, a, n, k, s]</tt>.
      # After invoking <tt>Collections.rotate(list, 1)</tt> (or
      # <tt>Collections.rotate(list, -4)</tt>), <tt>list</tt> will comprise
      # <tt>[s, t, a, n, k]</tt>.
      # 
      # <p>Note that this method can usefully be applied to sublists to
      # move one or more elements within a list while preserving the
      # order of the remaining elements.  For example, the following idiom
      # moves the element at index <tt>j</tt> forward to position
      # <tt>k</tt> (which must be greater than or equal to <tt>j</tt>):
      # <pre>
      # Collections.rotate(list.subList(j, k+1), -1);
      # </pre>
      # To make this concrete, suppose <tt>list</tt> comprises
      # <tt>[a, b, c, d, e]</tt>.  To move the element at index <tt>1</tt>
      # (<tt>b</tt>) forward two positions, perform the following invocation:
      # <pre>
      # Collections.rotate(l.subList(1, 4), -1);
      # </pre>
      # The resulting list is <tt>[a, c, d, b, e]</tt>.
      # 
      # <p>To move more than one element forward, increase the absolute value
      # of the rotation distance.  To move elements backward, use a positive
      # shift distance.
      # 
      # <p>If the specified list is small or implements the {@link
      # RandomAccess} interface, this implementation exchanges the first
      # element into the location it should go, and then repeatedly exchanges
      # the displaced element into the location it should go until a displaced
      # element is swapped into the first element.  If necessary, the process
      # is repeated on the second and successive elements, until the rotation
      # is complete.  If the specified list is large and doesn't implement the
      # <tt>RandomAccess</tt> interface, this implementation breaks the
      # list into two sublist views around index <tt>-distance mod size</tt>.
      # Then the {@link #reverse(List)} method is invoked on each sublist view,
      # and finally it is invoked on the entire list.  For a more complete
      # description of both algorithms, see Section 2.3 of Jon Bentley's
      # <i>Programming Pearls</i> (Addison-Wesley, 1986).
      # 
      # @param list the list to be rotated.
      # @param distance the distance to rotate the list.  There are no
      # constraints on this value; it may be zero, negative, or
      # greater than <tt>list.size()</tt>.
      # @throws UnsupportedOperationException if the specified list or
      # its list-iterator does not support the <tt>set</tt> operation.
      # @since 1.4
      def rotate(list, distance)
        if (list.is_a?(RandomAccess) || list.size < ROTATE_THRESHOLD)
          rotate1(list, distance)
        else
          rotate2(list, distance)
        end
      end
      
      typesig { [JavaList, ::Java::Int] }
      def rotate1(list, distance)
        size_ = list.size
        if ((size_).equal?(0))
          return
        end
        distance = distance % size_
        if (distance < 0)
          distance += size_
        end
        if ((distance).equal?(0))
          return
        end
        cycle_start = 0
        n_moved = 0
        while !(n_moved).equal?(size_)
          displaced = list.get(cycle_start)
          i = cycle_start
          begin
            i += distance
            if (i >= size_)
              i -= size_
            end
            displaced = list.set(i, displaced)
            n_moved += 1
          end while (!(i).equal?(cycle_start))
          cycle_start += 1
        end
      end
      
      typesig { [JavaList, ::Java::Int] }
      def rotate2(list, distance)
        size_ = list.size
        if ((size_).equal?(0))
          return
        end
        mid = -distance % size_
        if (mid < 0)
          mid += size_
        end
        if ((mid).equal?(0))
          return
        end
        reverse(list.sub_list(0, mid))
        reverse(list.sub_list(mid, size_))
        reverse(list)
      end
      
      typesig { [JavaList, T, T] }
      # Replaces all occurrences of one specified value in a list with another.
      # More formally, replaces with <tt>newVal</tt> each element <tt>e</tt>
      # in <tt>list</tt> such that
      # <tt>(oldVal==null ? e==null : oldVal.equals(e))</tt>.
      # (This method has no effect on the size of the list.)
      # 
      # @param list the list in which replacement is to occur.
      # @param oldVal the old value to be replaced.
      # @param newVal the new value with which <tt>oldVal</tt> is to be
      # replaced.
      # @return <tt>true</tt> if <tt>list</tt> contained one or more elements
      # <tt>e</tt> such that
      # <tt>(oldVal==null ?  e==null : oldVal.equals(e))</tt>.
      # @throws UnsupportedOperationException if the specified list or
      # its list-iterator does not support the <tt>set</tt> operation.
      # @since  1.4
      def replace_all(list, old_val, new_val)
        result = false
        size_ = list.size
        if (size_ < REPLACEALL_THRESHOLD || list.is_a?(RandomAccess))
          if ((old_val).nil?)
            i = 0
            while i < size_
              if ((list.get(i)).nil?)
                list.set(i, new_val)
                result = true
              end
              i += 1
            end
          else
            i = 0
            while i < size_
              if ((old_val == list.get(i)))
                list.set(i, new_val)
                result = true
              end
              i += 1
            end
          end
        else
          itr = list.list_iterator
          if ((old_val).nil?)
            i = 0
            while i < size_
              if ((itr.next_).nil?)
                itr.set(new_val)
                result = true
              end
              i += 1
            end
          else
            i = 0
            while i < size_
              if ((old_val == itr.next_))
                itr.set(new_val)
                result = true
              end
              i += 1
            end
          end
        end
        return result
      end
      
      typesig { [JavaList, JavaList] }
      # Returns the starting position of the first occurrence of the specified
      # target list within the specified source list, or -1 if there is no
      # such occurrence.  More formally, returns the lowest index <tt>i</tt>
      # such that <tt>source.subList(i, i+target.size()).equals(target)</tt>,
      # or -1 if there is no such index.  (Returns -1 if
      # <tt>target.size() > source.size()</tt>.)
      # 
      # <p>This implementation uses the "brute force" technique of scanning
      # over the source list, looking for a match with the target at each
      # location in turn.
      # 
      # @param source the list in which to search for the first occurrence
      # of <tt>target</tt>.
      # @param target the list to search for as a subList of <tt>source</tt>.
      # @return the starting position of the first occurrence of the specified
      # target list within the specified source list, or -1 if there
      # is no such occurrence.
      # @since  1.4
      def index_of_sub_list(source, target)
        source_size = source.size
        target_size = target.size
        max_candidate = source_size - target_size
        if (source_size < INDEXOFSUBLIST_THRESHOLD || (source.is_a?(RandomAccess) && target.is_a?(RandomAccess)))
          candidate = 0
          while candidate <= max_candidate
            catch(:next_next_cand) do
              i = 0
              j = candidate
              while i < target_size
                if (!eq(target.get(i), source.get(j)))
                  throw :next_next_cand, :thrown
                end
                i += 1
                j += 1
              end # Element mismatch, try next cand
              return candidate # All elements of candidate matched target
            end
            candidate += 1
          end
        else
          # Iterator version of above algorithm
          si = source.list_iterator
          candidate = 0
          while candidate <= max_candidate
            catch(:next_next_cand) do
              ti = target.list_iterator
              i = 0
              while i < target_size
                if (!eq(ti.next_, si.next_))
                  # Back up source iterator to next candidate
                  j = 0
                  while j < i
                    si.previous
                    j += 1
                  end
                  throw :next_next_cand, :thrown
                end
                i += 1
              end
              return candidate
            end
            candidate += 1
          end
        end
        return -1 # No candidate matched the target
      end
      
      typesig { [JavaList, JavaList] }
      # Returns the starting position of the last occurrence of the specified
      # target list within the specified source list, or -1 if there is no such
      # occurrence.  More formally, returns the highest index <tt>i</tt>
      # such that <tt>source.subList(i, i+target.size()).equals(target)</tt>,
      # or -1 if there is no such index.  (Returns -1 if
      # <tt>target.size() > source.size()</tt>.)
      # 
      # <p>This implementation uses the "brute force" technique of iterating
      # over the source list, looking for a match with the target at each
      # location in turn.
      # 
      # @param source the list in which to search for the last occurrence
      # of <tt>target</tt>.
      # @param target the list to search for as a subList of <tt>source</tt>.
      # @return the starting position of the last occurrence of the specified
      # target list within the specified source list, or -1 if there
      # is no such occurrence.
      # @since  1.4
      def last_index_of_sub_list(source, target)
        source_size = source.size
        target_size = target.size
        max_candidate = source_size - target_size
        if (source_size < INDEXOFSUBLIST_THRESHOLD || source.is_a?(RandomAccess))
          # Index access version
          candidate = max_candidate
          while candidate >= 0
            catch(:next_next_cand) do
              i = 0
              j = candidate
              while i < target_size
                if (!eq(target.get(i), source.get(j)))
                  throw :next_next_cand, :thrown
                end
                i += 1
                j += 1
              end # Element mismatch, try next cand
              return candidate # All elements of candidate matched target
            end
            candidate -= 1
          end
        else
          # Iterator version of above algorithm
          if (max_candidate < 0)
            return -1
          end
          si = source.list_iterator(max_candidate)
          candidate = max_candidate
          while candidate >= 0
            catch(:next_next_cand) do
              ti = target.list_iterator
              i = 0
              while i < target_size
                if (!eq(ti.next_, si.next_))
                  if (!(candidate).equal?(0))
                    # Back up source iterator to next candidate
                    j = 0
                    while j <= i + 1
                      si.previous
                      j += 1
                    end
                  end
                  throw :next_next_cand, :thrown
                end
                i += 1
              end
              return candidate
            end
            candidate -= 1
          end
        end
        return -1 # No candidate matched the target
      end
      
      typesig { [Collection] }
      # Unmodifiable Wrappers
      # 
      # Returns an unmodifiable view of the specified collection.  This method
      # allows modules to provide users with "read-only" access to internal
      # collections.  Query operations on the returned collection "read through"
      # to the specified collection, and attempts to modify the returned
      # collection, whether direct or via its iterator, result in an
      # <tt>UnsupportedOperationException</tt>.<p>
      # 
      # The returned collection does <i>not</i> pass the hashCode and equals
      # operations through to the backing collection, but relies on
      # <tt>Object</tt>'s <tt>equals</tt> and <tt>hashCode</tt> methods.  This
      # is necessary to preserve the contracts of these operations in the case
      # that the backing collection is a set or a list.<p>
      # 
      # The returned collection will be serializable if the specified collection
      # is serializable.
      # 
      # @param  c the collection for which an unmodifiable view is to be
      # returned.
      # @return an unmodifiable view of the specified collection.
      def unmodifiable_collection(c)
        return UnmodifiableCollection.new(c)
      end
      
      # @serial include
      const_set_lazy(:UnmodifiableCollection) { Class.new do
        include_class_members Collections
        include Collection
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1820017752578914078 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        typesig { [self::Collection] }
        def initialize(c)
          @c = nil
          if ((c).nil?)
            raise self.class::NullPointerException.new
          end
          @c = c
        end
        
        typesig { [] }
        def size
          return @c.size
        end
        
        typesig { [] }
        def is_empty
          return @c.is_empty
        end
        
        typesig { [Object] }
        def contains(o)
          return @c.contains(o)
        end
        
        typesig { [] }
        def to_array
          return @c.to_array
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          return @c.to_array(a)
        end
        
        typesig { [] }
        def to_s
          return @c.to_s
        end
        
        typesig { [] }
        def iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members UnmodifiableCollection
            include self::Iterator if self::Iterator.class == Module
            
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
              return @i.next_
            end
            
            typesig { [] }
            define_method :remove do
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [] }
            define_method :initialize do
              @i = nil
              super()
              @i = self.attr_c.iterator
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [Object] }
        def add(e)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        def remove(o)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [self::Collection] }
        def contains_all(coll)
          return @c.contains_all(coll)
        end
        
        typesig { [self::Collection] }
        def add_all(coll)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [self::Collection] }
        def remove_all(coll)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [self::Collection] }
        def retain_all(coll)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        def clear
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__unmodifiable_collection, :initialize
      end }
      
      typesig { [JavaSet] }
      # Returns an unmodifiable view of the specified set.  This method allows
      # modules to provide users with "read-only" access to internal sets.
      # Query operations on the returned set "read through" to the specified
      # set, and attempts to modify the returned set, whether direct or via its
      # iterator, result in an <tt>UnsupportedOperationException</tt>.<p>
      # 
      # The returned set will be serializable if the specified set
      # is serializable.
      # 
      # @param  s the set for which an unmodifiable view is to be returned.
      # @return an unmodifiable view of the specified set.
      def unmodifiable_set(s)
        return UnmodifiableSet.new(s)
      end
      
      # @serial include
      const_set_lazy(:UnmodifiableSet) { Class.new(UnmodifiableCollection) do
        include_class_members Collections
        overload_protected {
          include JavaSet
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -9215047833775013803 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [self::JavaSet] }
        def initialize(s)
          super(s)
        end
        
        typesig { [Object] }
        def ==(o)
          return (o).equal?(self) || (self.attr_c == o)
        end
        
        typesig { [] }
        def hash_code
          return self.attr_c.hash_code
        end
        
        private
        alias_method :initialize__unmodifiable_set, :initialize
      end }
      
      typesig { [SortedSet] }
      # Returns an unmodifiable view of the specified sorted set.  This method
      # allows modules to provide users with "read-only" access to internal
      # sorted sets.  Query operations on the returned sorted set "read
      # through" to the specified sorted set.  Attempts to modify the returned
      # sorted set, whether direct, via its iterator, or via its
      # <tt>subSet</tt>, <tt>headSet</tt>, or <tt>tailSet</tt> views, result in
      # an <tt>UnsupportedOperationException</tt>.<p>
      # 
      # The returned sorted set will be serializable if the specified sorted set
      # is serializable.
      # 
      # @param s the sorted set for which an unmodifiable view is to be
      # returned.
      # @return an unmodifiable view of the specified sorted set.
      def unmodifiable_sorted_set(s)
        return UnmodifiableSortedSet.new(s)
      end
      
      # @serial include
      const_set_lazy(:UnmodifiableSortedSet) { Class.new(UnmodifiableSet) do
        include_class_members Collections
        overload_protected {
          include SortedSet
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -4929149591599911165 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :ss
        alias_method :attr_ss, :ss
        undef_method :ss
        alias_method :attr_ss=, :ss=
        undef_method :ss=
        
        typesig { [self::SortedSet] }
        def initialize(s)
          @ss = nil
          super(s)
          @ss = s
        end
        
        typesig { [] }
        def comparator
          return @ss.comparator
        end
        
        typesig { [Object, Object] }
        def sub_set(from_element, to_element)
          return self.class::UnmodifiableSortedSet.new(@ss.sub_set(from_element, to_element))
        end
        
        typesig { [Object] }
        def head_set(to_element)
          return self.class::UnmodifiableSortedSet.new(@ss.head_set(to_element))
        end
        
        typesig { [Object] }
        def tail_set(from_element)
          return self.class::UnmodifiableSortedSet.new(@ss.tail_set(from_element))
        end
        
        typesig { [] }
        def first
          return @ss.first
        end
        
        typesig { [] }
        def last
          return @ss.last
        end
        
        private
        alias_method :initialize__unmodifiable_sorted_set, :initialize
      end }
      
      typesig { [JavaList] }
      # Returns an unmodifiable view of the specified list.  This method allows
      # modules to provide users with "read-only" access to internal
      # lists.  Query operations on the returned list "read through" to the
      # specified list, and attempts to modify the returned list, whether
      # direct or via its iterator, result in an
      # <tt>UnsupportedOperationException</tt>.<p>
      # 
      # The returned list will be serializable if the specified list
      # is serializable. Similarly, the returned list will implement
      # {@link RandomAccess} if the specified list does.
      # 
      # @param  list the list for which an unmodifiable view is to be returned.
      # @return an unmodifiable view of the specified list.
      def unmodifiable_list(list)
        return (list.is_a?(RandomAccess) ? UnmodifiableRandomAccessList.new(list) : UnmodifiableList.new(list))
      end
      
      # @serial include
      const_set_lazy(:UnmodifiableList) { Class.new(UnmodifiableCollection) do
        include_class_members Collections
        overload_protected {
          include JavaList
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -283967356065247728 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :list
        alias_method :attr_list, :list
        undef_method :list
        alias_method :attr_list=, :list=
        undef_method :list=
        
        typesig { [self::JavaList] }
        def initialize(list)
          @list = nil
          super(list)
          @list = list
        end
        
        typesig { [Object] }
        def ==(o)
          return (o).equal?(self) || (@list == o)
        end
        
        typesig { [] }
        def hash_code
          return @list.hash_code
        end
        
        typesig { [::Java::Int] }
        def get(index)
          return @list.get(index)
        end
        
        typesig { [::Java::Int, Object] }
        def set(index, element)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [::Java::Int, Object] }
        def add(index, element)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [::Java::Int] }
        def remove(index)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        def index_of(o)
          return @list.index_of(o)
        end
        
        typesig { [Object] }
        def last_index_of(o)
          return @list.last_index_of(o)
        end
        
        typesig { [::Java::Int, self::Collection] }
        def add_all(index, c)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        def list_iterator
          return list_iterator(0)
        end
        
        typesig { [::Java::Int] }
        def list_iterator(index)
          return Class.new(self.class::ListIterator.class == Class ? self.class::ListIterator : Object) do
            extend LocalClass
            include_class_members UnmodifiableList
            include self::ListIterator if self::ListIterator.class == Module
            
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
              return @i.next_
            end
            
            typesig { [] }
            define_method :has_previous do
              return @i.has_previous
            end
            
            typesig { [] }
            define_method :previous do
              return @i.previous
            end
            
            typesig { [] }
            define_method :next_index do
              return @i.next_index
            end
            
            typesig { [] }
            define_method :previous_index do
              return @i.previous_index
            end
            
            typesig { [] }
            define_method :remove do
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [Object] }
            define_method :set do |e|
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [Object] }
            define_method :add do |e|
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [] }
            define_method :initialize do
              @i = nil
              super()
              @i = self.attr_list.list_iterator(index)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          return self.class::UnmodifiableList.new(@list.sub_list(from_index, to_index))
        end
        
        typesig { [] }
        # UnmodifiableRandomAccessList instances are serialized as
        # UnmodifiableList instances to allow them to be deserialized
        # in pre-1.4 JREs (which do not have UnmodifiableRandomAccessList).
        # This method inverts the transformation.  As a beneficial
        # side-effect, it also grafts the RandomAccess marker onto
        # UnmodifiableList instances that were serialized in pre-1.4 JREs.
        # 
        # Note: Unfortunately, UnmodifiableRandomAccessList instances
        # serialized in 1.4.1 and deserialized in 1.4 will become
        # UnmodifiableList instances, as this method was missing in 1.4.
        def read_resolve
          return (@list.is_a?(self.class::RandomAccess) ? self.class::UnmodifiableRandomAccessList.new(@list) : self)
        end
        
        private
        alias_method :initialize__unmodifiable_list, :initialize
      end }
      
      # @serial include
      const_set_lazy(:UnmodifiableRandomAccessList) { Class.new(UnmodifiableList) do
        include_class_members Collections
        overload_protected {
          include RandomAccess
        }
        
        typesig { [self::JavaList] }
        def initialize(list)
          super(list)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          return self.class::UnmodifiableRandomAccessList.new(self.attr_list.sub_list(from_index, to_index))
        end
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -2542308836966382001 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        # Allows instances to be deserialized in pre-1.4 JREs (which do
        # not have UnmodifiableRandomAccessList).  UnmodifiableList has
        # a readResolve method that inverts this transformation upon
        # deserialization.
        def write_replace
          return self.class::UnmodifiableList.new(self.attr_list)
        end
        
        private
        alias_method :initialize__unmodifiable_random_access_list, :initialize
      end }
      
      typesig { [Map] }
      # Returns an unmodifiable view of the specified map.  This method
      # allows modules to provide users with "read-only" access to internal
      # maps.  Query operations on the returned map "read through"
      # to the specified map, and attempts to modify the returned
      # map, whether direct or via its collection views, result in an
      # <tt>UnsupportedOperationException</tt>.<p>
      # 
      # The returned map will be serializable if the specified map
      # is serializable.
      # 
      # @param  m the map for which an unmodifiable view is to be returned.
      # @return an unmodifiable view of the specified map.
      def unmodifiable_map(m)
        return UnmodifiableMap.new(m)
      end
      
      # @serial include
      const_set_lazy(:UnmodifiableMap) { Class.new do
        include_class_members Collections
        include Map
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -1034234728574286014 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        typesig { [self::Map] }
        def initialize(m)
          @m = nil
          @key_set = nil
          @entry_set = nil
          @values = nil
          if ((m).nil?)
            raise self.class::NullPointerException.new
          end
          @m = m
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
        def contains_key(key)
          return @m.contains_key(key)
        end
        
        typesig { [Object] }
        def contains_value(val)
          return @m.contains_value(val)
        end
        
        typesig { [Object] }
        def get(key)
          return @m.get(key)
        end
        
        typesig { [Object, Object] }
        def put(key, value)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        def remove(key)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [self::Map] }
        def put_all(m)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        def clear
          raise self.class::UnsupportedOperationException.new
        end
        
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
        def key_set
          if ((@key_set).nil?)
            @key_set = unmodifiable_set(@m.key_set)
          end
          return @key_set
        end
        
        typesig { [] }
        def entry_set
          if ((@entry_set).nil?)
            @entry_set = self.class::UnmodifiableEntrySet.new(@m.entry_set)
          end
          return @entry_set
        end
        
        typesig { [] }
        def values
          if ((@values).nil?)
            @values = unmodifiable_collection(@m.values)
          end
          return @values
        end
        
        typesig { [Object] }
        def ==(o)
          return (o).equal?(self) || (@m == o)
        end
        
        typesig { [] }
        def hash_code
          return @m.hash_code
        end
        
        typesig { [] }
        def to_s
          return @m.to_s
        end
        
        class_module.module_eval {
          # We need this class in addition to UnmodifiableSet as
          # Map.Entries themselves permit modification of the backing Map
          # via their setValue operation.  This class is subtle: there are
          # many possible attacks that must be thwarted.
          # 
          # @serial include
          const_set_lazy(:UnmodifiableEntrySet) { Class.new(self::UnmodifiableSet) do
            include_class_members UnmodifiableMap
            
            class_module.module_eval {
              const_set_lazy(:SerialVersionUID) { 7854390611657943733 }
              const_attr_reader  :SerialVersionUID
            }
            
            typesig { [self::JavaSet] }
            def initialize(s)
              super(s)
            end
            
            typesig { [] }
            def iterator
              return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
                extend LocalClass
                include_class_members UnmodifiableEntrySet
                include self::Iterator if self::Iterator.class == Module
                
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
                  return self.class::UnmodifiableEntry.new(@i.next_)
                end
                
                typesig { [] }
                define_method :remove do
                  raise self.class::UnsupportedOperationException.new
                end
                
                typesig { [] }
                define_method :initialize do
                  @i = nil
                  super()
                  @i = self.attr_c.iterator
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self)
            end
            
            typesig { [] }
            def to_array
              a = self.attr_c.to_array
              i = 0
              while i < a.attr_length
                a[i] = self.class::UnmodifiableEntry.new(a[i])
                i += 1
              end
              return a
            end
            
            typesig { [Array.typed(self::T)] }
            def to_array(a)
              # We don't pass a to c.toArray, to avoid window of
              # vulnerability wherein an unscrupulous multithreaded client
              # could get his hands on raw (unwrapped) Entries from c.
              arr = self.attr_c.to_array((a.attr_length).equal?(0) ? a : Arrays.copy_of(a, 0))
              i = 0
              while i < arr.attr_length
                arr[i] = self.class::UnmodifiableEntry.new(arr[i])
                i += 1
              end
              if (arr.attr_length > a.attr_length)
                return arr
              end
              System.arraycopy(arr, 0, a, 0, arr.attr_length)
              if (a.attr_length > arr.attr_length)
                a[arr.attr_length] = nil
              end
              return a
            end
            
            typesig { [Object] }
            # This method is overridden to protect the backing set against
            # an object with a nefarious equals function that senses
            # that the equality-candidate is Map.Entry and calls its
            # setValue method.
            def contains(o)
              if (!(o.is_a?(self.class::Map::Entry)))
                return false
              end
              return self.attr_c.contains(self.class::UnmodifiableEntry.new(o))
            end
            
            typesig { [self::Collection] }
            # The next two methods are overridden to protect against
            # an unscrupulous List whose contains(Object o) method senses
            # when o is a Map.Entry, and calls o.setValue.
            def contains_all(coll)
              e = coll.iterator
              while (e.has_next)
                if (!contains(e.next_))
                  # Invokes safe contains() above
                  return false
                end
              end
              return true
            end
            
            typesig { [Object] }
            def ==(o)
              if ((o).equal?(self))
                return true
              end
              if (!(o.is_a?(self.class::JavaSet)))
                return false
              end
              s = o
              if (!(s.size).equal?(self.attr_c.size))
                return false
              end
              return contains_all(s) # Invokes safe containsAll() above
            end
            
            class_module.module_eval {
              # This "wrapper class" serves two purposes: it prevents
              # the client from modifying the backing Map, by short-circuiting
              # the setValue method, and it protects the backing Map against
              # an ill-behaved Map.Entry that attempts to modify another
              # Map Entry when asked to perform an equality check.
              const_set_lazy(:UnmodifiableEntry) { Class.new do
                include_class_members UnmodifiableEntrySet
                include self::Map::Entry
                
                attr_accessor :e
                alias_method :attr_e, :e
                undef_method :e
                alias_method :attr_e=, :e=
                undef_method :e=
                
                typesig { [self::Map::Entry] }
                def initialize(e)
                  @e = nil
                  @e = e
                end
                
                typesig { [] }
                def get_key
                  return @e.get_key
                end
                
                typesig { [] }
                def get_value
                  return @e.get_value
                end
                
                typesig { [Object] }
                def set_value(value)
                  raise self.class::UnsupportedOperationException.new
                end
                
                typesig { [] }
                def hash_code
                  return @e.hash_code
                end
                
                typesig { [Object] }
                def ==(o)
                  if (!(o.is_a?(self.class::Map::Entry)))
                    return false
                  end
                  t = o
                  return eq(@e.get_key, t.get_key) && eq(@e.get_value, t.get_value)
                end
                
                typesig { [] }
                def to_s
                  return @e.to_s
                end
                
                private
                alias_method :initialize__unmodifiable_entry, :initialize
              end }
            }
            
            private
            alias_method :initialize__unmodifiable_entry_set, :initialize
          end }
        }
        
        private
        alias_method :initialize__unmodifiable_map, :initialize
      end }
      
      typesig { [SortedMap] }
      # Returns an unmodifiable view of the specified sorted map.  This method
      # allows modules to provide users with "read-only" access to internal
      # sorted maps.  Query operations on the returned sorted map "read through"
      # to the specified sorted map.  Attempts to modify the returned
      # sorted map, whether direct, via its collection views, or via its
      # <tt>subMap</tt>, <tt>headMap</tt>, or <tt>tailMap</tt> views, result in
      # an <tt>UnsupportedOperationException</tt>.<p>
      # 
      # The returned sorted map will be serializable if the specified sorted map
      # is serializable.
      # 
      # @param m the sorted map for which an unmodifiable view is to be
      # returned.
      # @return an unmodifiable view of the specified sorted map.
      def unmodifiable_sorted_map(m)
        return UnmodifiableSortedMap.new(m)
      end
      
      # @serial include
      const_set_lazy(:UnmodifiableSortedMap) { Class.new(UnmodifiableMap) do
        include_class_members Collections
        overload_protected {
          include SortedMap
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -8806743815996713206 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :sm
        alias_method :attr_sm, :sm
        undef_method :sm
        alias_method :attr_sm=, :sm=
        undef_method :sm=
        
        typesig { [self::SortedMap] }
        def initialize(m)
          @sm = nil
          super(m)
          @sm = m
        end
        
        typesig { [] }
        def comparator
          return @sm.comparator
        end
        
        typesig { [Object, Object] }
        def sub_map(from_key, to_key)
          return self.class::UnmodifiableSortedMap.new(@sm.sub_map(from_key, to_key))
        end
        
        typesig { [Object] }
        def head_map(to_key)
          return self.class::UnmodifiableSortedMap.new(@sm.head_map(to_key))
        end
        
        typesig { [Object] }
        def tail_map(from_key)
          return self.class::UnmodifiableSortedMap.new(@sm.tail_map(from_key))
        end
        
        typesig { [] }
        def first_key
          return @sm.first_key
        end
        
        typesig { [] }
        def last_key
          return @sm.last_key
        end
        
        private
        alias_method :initialize__unmodifiable_sorted_map, :initialize
      end }
      
      typesig { [Collection] }
      # Synch Wrappers
      # 
      # Returns a synchronized (thread-safe) collection backed by the specified
      # collection.  In order to guarantee serial access, it is critical that
      # <strong>all</strong> access to the backing collection is accomplished
      # through the returned collection.<p>
      # 
      # It is imperative that the user manually synchronize on the returned
      # collection when iterating over it:
      # <pre>
      # Collection c = Collections.synchronizedCollection(myCollection);
      # ...
      # synchronized(c) {
      # Iterator i = c.iterator(); // Must be in the synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # Failure to follow this advice may result in non-deterministic behavior.
      # 
      # <p>The returned collection does <i>not</i> pass the <tt>hashCode</tt>
      # and <tt>equals</tt> operations through to the backing collection, but
      # relies on <tt>Object</tt>'s equals and hashCode methods.  This is
      # necessary to preserve the contracts of these operations in the case
      # that the backing collection is a set or a list.<p>
      # 
      # The returned collection will be serializable if the specified collection
      # is serializable.
      # 
      # @param  c the collection to be "wrapped" in a synchronized collection.
      # @return a synchronized view of the specified collection.
      def synchronized_collection(c)
        return SynchronizedCollection.new(c)
      end
      
      typesig { [Collection, Object] }
      def synchronized_collection(c, mutex)
        return SynchronizedCollection.new(c, mutex)
      end
      
      # @serial include
      const_set_lazy(:SynchronizedCollection) { Class.new do
        include_class_members Collections
        include Collection
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 3053995032091335093 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        # Backing Collection
        attr_accessor :mutex
        alias_method :attr_mutex, :mutex
        undef_method :mutex
        alias_method :attr_mutex=, :mutex=
        undef_method :mutex=
        
        typesig { [self::Collection] }
        # Object on which to synchronize
        def initialize(c)
          @c = nil
          @mutex = nil
          if ((c).nil?)
            raise self.class::NullPointerException.new
          end
          @c = c
          @mutex = self
        end
        
        typesig { [self::Collection, Object] }
        def initialize(c, mutex)
          @c = nil
          @mutex = nil
          @c = c
          @mutex = mutex
        end
        
        typesig { [] }
        def size
          synchronized((@mutex)) do
            return @c.size
          end
        end
        
        typesig { [] }
        def is_empty
          synchronized((@mutex)) do
            return @c.is_empty
          end
        end
        
        typesig { [Object] }
        def contains(o)
          synchronized((@mutex)) do
            return @c.contains(o)
          end
        end
        
        typesig { [] }
        def to_array
          synchronized((@mutex)) do
            return @c.to_array
          end
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          synchronized((@mutex)) do
            return @c.to_array(a)
          end
        end
        
        typesig { [] }
        def iterator
          return @c.iterator # Must be manually synched by user!
        end
        
        typesig { [Object] }
        def add(e)
          synchronized((@mutex)) do
            return @c.add(e)
          end
        end
        
        typesig { [Object] }
        def remove(o)
          synchronized((@mutex)) do
            return @c.remove(o)
          end
        end
        
        typesig { [self::Collection] }
        def contains_all(coll)
          synchronized((@mutex)) do
            return @c.contains_all(coll)
          end
        end
        
        typesig { [self::Collection] }
        def add_all(coll)
          synchronized((@mutex)) do
            return @c.add_all(coll)
          end
        end
        
        typesig { [self::Collection] }
        def remove_all(coll)
          synchronized((@mutex)) do
            return @c.remove_all(coll)
          end
        end
        
        typesig { [self::Collection] }
        def retain_all(coll)
          synchronized((@mutex)) do
            return @c.retain_all(coll)
          end
        end
        
        typesig { [] }
        def clear
          synchronized((@mutex)) do
            @c.clear
          end
        end
        
        typesig { [] }
        def to_s
          synchronized((@mutex)) do
            return @c.to_s
          end
        end
        
        typesig { [self::ObjectOutputStream] }
        def write_object(s)
          synchronized((@mutex)) do
            s.default_write_object
          end
        end
        
        private
        alias_method :initialize__synchronized_collection, :initialize
      end }
      
      typesig { [JavaSet] }
      # Returns a synchronized (thread-safe) set backed by the specified
      # set.  In order to guarantee serial access, it is critical that
      # <strong>all</strong> access to the backing set is accomplished
      # through the returned set.<p>
      # 
      # It is imperative that the user manually synchronize on the returned
      # set when iterating over it:
      # <pre>
      # Set s = Collections.synchronizedSet(new HashSet());
      # ...
      # synchronized(s) {
      # Iterator i = s.iterator(); // Must be in the synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # Failure to follow this advice may result in non-deterministic behavior.
      # 
      # <p>The returned set will be serializable if the specified set is
      # serializable.
      # 
      # @param  s the set to be "wrapped" in a synchronized set.
      # @return a synchronized view of the specified set.
      def synchronized_set(s)
        return SynchronizedSet.new(s)
      end
      
      typesig { [JavaSet, Object] }
      def synchronized_set(s, mutex)
        return SynchronizedSet.new(s, mutex)
      end
      
      # @serial include
      const_set_lazy(:SynchronizedSet) { Class.new(SynchronizedCollection) do
        include_class_members Collections
        overload_protected {
          include JavaSet
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 487447009682186044 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [self::JavaSet] }
        def initialize(s)
          super(s)
        end
        
        typesig { [self::JavaSet, Object] }
        def initialize(s, mutex)
          super(s, mutex)
        end
        
        typesig { [Object] }
        def ==(o)
          synchronized((self.attr_mutex)) do
            return (self.attr_c == o)
          end
        end
        
        typesig { [] }
        def hash_code
          synchronized((self.attr_mutex)) do
            return self.attr_c.hash_code
          end
        end
        
        private
        alias_method :initialize__synchronized_set, :initialize
      end }
      
      typesig { [SortedSet] }
      # Returns a synchronized (thread-safe) sorted set backed by the specified
      # sorted set.  In order to guarantee serial access, it is critical that
      # <strong>all</strong> access to the backing sorted set is accomplished
      # through the returned sorted set (or its views).<p>
      # 
      # It is imperative that the user manually synchronize on the returned
      # sorted set when iterating over it or any of its <tt>subSet</tt>,
      # <tt>headSet</tt>, or <tt>tailSet</tt> views.
      # <pre>
      # SortedSet s = Collections.synchronizedSortedSet(new TreeSet());
      # ...
      # synchronized(s) {
      # Iterator i = s.iterator(); // Must be in the synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # or:
      # <pre>
      # SortedSet s = Collections.synchronizedSortedSet(new TreeSet());
      # SortedSet s2 = s.headSet(foo);
      # ...
      # synchronized(s) {  // Note: s, not s2!!!
      # Iterator i = s2.iterator(); // Must be in the synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # Failure to follow this advice may result in non-deterministic behavior.
      # 
      # <p>The returned sorted set will be serializable if the specified
      # sorted set is serializable.
      # 
      # @param  s the sorted set to be "wrapped" in a synchronized sorted set.
      # @return a synchronized view of the specified sorted set.
      def synchronized_sorted_set(s)
        return SynchronizedSortedSet.new(s)
      end
      
      # @serial include
      const_set_lazy(:SynchronizedSortedSet) { Class.new(SynchronizedSet) do
        include_class_members Collections
        overload_protected {
          include SortedSet
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 8695801310862127406 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :ss
        alias_method :attr_ss, :ss
        undef_method :ss
        alias_method :attr_ss=, :ss=
        undef_method :ss=
        
        typesig { [self::SortedSet] }
        def initialize(s)
          @ss = nil
          super(s)
          @ss = s
        end
        
        typesig { [self::SortedSet, Object] }
        def initialize(s, mutex)
          @ss = nil
          super(s, mutex)
          @ss = s
        end
        
        typesig { [] }
        def comparator
          synchronized((self.attr_mutex)) do
            return @ss.comparator
          end
        end
        
        typesig { [Object, Object] }
        def sub_set(from_element, to_element)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedSortedSet.new(@ss.sub_set(from_element, to_element), self.attr_mutex)
          end
        end
        
        typesig { [Object] }
        def head_set(to_element)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedSortedSet.new(@ss.head_set(to_element), self.attr_mutex)
          end
        end
        
        typesig { [Object] }
        def tail_set(from_element)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedSortedSet.new(@ss.tail_set(from_element), self.attr_mutex)
          end
        end
        
        typesig { [] }
        def first
          synchronized((self.attr_mutex)) do
            return @ss.first
          end
        end
        
        typesig { [] }
        def last
          synchronized((self.attr_mutex)) do
            return @ss.last
          end
        end
        
        private
        alias_method :initialize__synchronized_sorted_set, :initialize
      end }
      
      typesig { [JavaList] }
      # Returns a synchronized (thread-safe) list backed by the specified
      # list.  In order to guarantee serial access, it is critical that
      # <strong>all</strong> access to the backing list is accomplished
      # through the returned list.<p>
      # 
      # It is imperative that the user manually synchronize on the returned
      # list when iterating over it:
      # <pre>
      # List list = Collections.synchronizedList(new ArrayList());
      # ...
      # synchronized(list) {
      # Iterator i = list.iterator(); // Must be in synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # Failure to follow this advice may result in non-deterministic behavior.
      # 
      # <p>The returned list will be serializable if the specified list is
      # serializable.
      # 
      # @param  list the list to be "wrapped" in a synchronized list.
      # @return a synchronized view of the specified list.
      def synchronized_list(list)
        return (list.is_a?(RandomAccess) ? SynchronizedRandomAccessList.new(list) : SynchronizedList.new(list))
      end
      
      typesig { [JavaList, Object] }
      def synchronized_list(list, mutex)
        return (list.is_a?(RandomAccess) ? SynchronizedRandomAccessList.new(list, mutex) : SynchronizedList.new(list, mutex))
      end
      
      # @serial include
      const_set_lazy(:SynchronizedList) { Class.new(SynchronizedCollection) do
        include_class_members Collections
        overload_protected {
          include JavaList
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -7754090372962971524 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :list
        alias_method :attr_list, :list
        undef_method :list
        alias_method :attr_list=, :list=
        undef_method :list=
        
        typesig { [self::JavaList] }
        def initialize(list)
          @list = nil
          super(list)
          @list = list
        end
        
        typesig { [self::JavaList, Object] }
        def initialize(list, mutex)
          @list = nil
          super(list, mutex)
          @list = list
        end
        
        typesig { [Object] }
        def ==(o)
          synchronized((self.attr_mutex)) do
            return (@list == o)
          end
        end
        
        typesig { [] }
        def hash_code
          synchronized((self.attr_mutex)) do
            return @list.hash_code
          end
        end
        
        typesig { [::Java::Int] }
        def get(index)
          synchronized((self.attr_mutex)) do
            return @list.get(index)
          end
        end
        
        typesig { [::Java::Int, Object] }
        def set(index, element)
          synchronized((self.attr_mutex)) do
            return @list.set(index, element)
          end
        end
        
        typesig { [::Java::Int, Object] }
        def add(index, element)
          synchronized((self.attr_mutex)) do
            @list.add(index, element)
          end
        end
        
        typesig { [::Java::Int] }
        def remove(index)
          synchronized((self.attr_mutex)) do
            return @list.remove(index)
          end
        end
        
        typesig { [Object] }
        def index_of(o)
          synchronized((self.attr_mutex)) do
            return @list.index_of(o)
          end
        end
        
        typesig { [Object] }
        def last_index_of(o)
          synchronized((self.attr_mutex)) do
            return @list.last_index_of(o)
          end
        end
        
        typesig { [::Java::Int, self::Collection] }
        def add_all(index, c)
          synchronized((self.attr_mutex)) do
            return @list.add_all(index, c)
          end
        end
        
        typesig { [] }
        def list_iterator
          return @list.list_iterator # Must be manually synched by user
        end
        
        typesig { [::Java::Int] }
        def list_iterator(index)
          return @list.list_iterator(index) # Must be manually synched by user
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedList.new(@list.sub_list(from_index, to_index), self.attr_mutex)
          end
        end
        
        typesig { [] }
        # SynchronizedRandomAccessList instances are serialized as
        # SynchronizedList instances to allow them to be deserialized
        # in pre-1.4 JREs (which do not have SynchronizedRandomAccessList).
        # This method inverts the transformation.  As a beneficial
        # side-effect, it also grafts the RandomAccess marker onto
        # SynchronizedList instances that were serialized in pre-1.4 JREs.
        # 
        # Note: Unfortunately, SynchronizedRandomAccessList instances
        # serialized in 1.4.1 and deserialized in 1.4 will become
        # SynchronizedList instances, as this method was missing in 1.4.
        def read_resolve
          return (@list.is_a?(self.class::RandomAccess) ? self.class::SynchronizedRandomAccessList.new(@list) : self)
        end
        
        private
        alias_method :initialize__synchronized_list, :initialize
      end }
      
      # @serial include
      const_set_lazy(:SynchronizedRandomAccessList) { Class.new(SynchronizedList) do
        include_class_members Collections
        overload_protected {
          include RandomAccess
        }
        
        typesig { [self::JavaList] }
        def initialize(list)
          super(list)
        end
        
        typesig { [self::JavaList, Object] }
        def initialize(list, mutex)
          super(list, mutex)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedRandomAccessList.new(self.attr_list.sub_list(from_index, to_index), self.attr_mutex)
          end
        end
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1530674583602358482 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        # Allows instances to be deserialized in pre-1.4 JREs (which do
        # not have SynchronizedRandomAccessList).  SynchronizedList has
        # a readResolve method that inverts this transformation upon
        # deserialization.
        def write_replace
          return self.class::SynchronizedList.new(self.attr_list)
        end
        
        private
        alias_method :initialize__synchronized_random_access_list, :initialize
      end }
      
      typesig { [Map] }
      # Returns a synchronized (thread-safe) map backed by the specified
      # map.  In order to guarantee serial access, it is critical that
      # <strong>all</strong> access to the backing map is accomplished
      # through the returned map.<p>
      # 
      # It is imperative that the user manually synchronize on the returned
      # map when iterating over any of its collection views:
      # <pre>
      # Map m = Collections.synchronizedMap(new HashMap());
      # ...
      # Set s = m.keySet();  // Needn't be in synchronized block
      # ...
      # synchronized(m) {  // Synchronizing on m, not s!
      # Iterator i = s.iterator(); // Must be in synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # Failure to follow this advice may result in non-deterministic behavior.
      # 
      # <p>The returned map will be serializable if the specified map is
      # serializable.
      # 
      # @param  m the map to be "wrapped" in a synchronized map.
      # @return a synchronized view of the specified map.
      def synchronized_map(m)
        return SynchronizedMap.new(m)
      end
      
      # @serial include
      const_set_lazy(:SynchronizedMap) { Class.new do
        include_class_members Collections
        include Map
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1978198479659022715 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        # Backing Map
        attr_accessor :mutex
        alias_method :attr_mutex, :mutex
        undef_method :mutex
        alias_method :attr_mutex=, :mutex=
        undef_method :mutex=
        
        typesig { [self::Map] }
        # Object on which to synchronize
        def initialize(m)
          @m = nil
          @mutex = nil
          @key_set = nil
          @entry_set = nil
          @values = nil
          if ((m).nil?)
            raise self.class::NullPointerException.new
          end
          @m = m
          @mutex = self
        end
        
        typesig { [self::Map, Object] }
        def initialize(m, mutex)
          @m = nil
          @mutex = nil
          @key_set = nil
          @entry_set = nil
          @values = nil
          @m = m
          @mutex = mutex
        end
        
        typesig { [] }
        def size
          synchronized((@mutex)) do
            return @m.size
          end
        end
        
        typesig { [] }
        def is_empty
          synchronized((@mutex)) do
            return @m.is_empty
          end
        end
        
        typesig { [Object] }
        def contains_key(key)
          synchronized((@mutex)) do
            return @m.contains_key(key)
          end
        end
        
        typesig { [Object] }
        def contains_value(value)
          synchronized((@mutex)) do
            return @m.contains_value(value)
          end
        end
        
        typesig { [Object] }
        def get(key)
          synchronized((@mutex)) do
            return @m.get(key)
          end
        end
        
        typesig { [Object, Object] }
        def put(key, value)
          synchronized((@mutex)) do
            return @m.put(key, value)
          end
        end
        
        typesig { [Object] }
        def remove(key)
          synchronized((@mutex)) do
            return @m.remove(key)
          end
        end
        
        typesig { [self::Map] }
        def put_all(map)
          synchronized((@mutex)) do
            @m.put_all(map)
          end
        end
        
        typesig { [] }
        def clear
          synchronized((@mutex)) do
            @m.clear
          end
        end
        
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
        def key_set
          synchronized((@mutex)) do
            if ((@key_set).nil?)
              @key_set = self.class::SynchronizedSet.new(@m.key_set, @mutex)
            end
            return @key_set
          end
        end
        
        typesig { [] }
        def entry_set
          synchronized((@mutex)) do
            if ((@entry_set).nil?)
              @entry_set = self.class::SynchronizedSet.new(@m.entry_set, @mutex)
            end
            return @entry_set
          end
        end
        
        typesig { [] }
        def values
          synchronized((@mutex)) do
            if ((@values).nil?)
              @values = self.class::SynchronizedCollection.new(@m.values, @mutex)
            end
            return @values
          end
        end
        
        typesig { [Object] }
        def ==(o)
          synchronized((@mutex)) do
            return (@m == o)
          end
        end
        
        typesig { [] }
        def hash_code
          synchronized((@mutex)) do
            return @m.hash_code
          end
        end
        
        typesig { [] }
        def to_s
          synchronized((@mutex)) do
            return @m.to_s
          end
        end
        
        typesig { [self::ObjectOutputStream] }
        def write_object(s)
          synchronized((@mutex)) do
            s.default_write_object
          end
        end
        
        private
        alias_method :initialize__synchronized_map, :initialize
      end }
      
      typesig { [SortedMap] }
      # Returns a synchronized (thread-safe) sorted map backed by the specified
      # sorted map.  In order to guarantee serial access, it is critical that
      # <strong>all</strong> access to the backing sorted map is accomplished
      # through the returned sorted map (or its views).<p>
      # 
      # It is imperative that the user manually synchronize on the returned
      # sorted map when iterating over any of its collection views, or the
      # collections views of any of its <tt>subMap</tt>, <tt>headMap</tt> or
      # <tt>tailMap</tt> views.
      # <pre>
      # SortedMap m = Collections.synchronizedSortedMap(new TreeMap());
      # ...
      # Set s = m.keySet();  // Needn't be in synchronized block
      # ...
      # synchronized(m) {  // Synchronizing on m, not s!
      # Iterator i = s.iterator(); // Must be in synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # or:
      # <pre>
      # SortedMap m = Collections.synchronizedSortedMap(new TreeMap());
      # SortedMap m2 = m.subMap(foo, bar);
      # ...
      # Set s2 = m2.keySet();  // Needn't be in synchronized block
      # ...
      # synchronized(m) {  // Synchronizing on m, not m2 or s2!
      # Iterator i = s.iterator(); // Must be in synchronized block
      # while (i.hasNext())
      # foo(i.next());
      # }
      # </pre>
      # Failure to follow this advice may result in non-deterministic behavior.
      # 
      # <p>The returned sorted map will be serializable if the specified
      # sorted map is serializable.
      # 
      # @param  m the sorted map to be "wrapped" in a synchronized sorted map.
      # @return a synchronized view of the specified sorted map.
      def synchronized_sorted_map(m)
        return SynchronizedSortedMap.new(m)
      end
      
      # @serial include
      const_set_lazy(:SynchronizedSortedMap) { Class.new(SynchronizedMap) do
        include_class_members Collections
        overload_protected {
          include SortedMap
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -8798146769416483793 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :sm
        alias_method :attr_sm, :sm
        undef_method :sm
        alias_method :attr_sm=, :sm=
        undef_method :sm=
        
        typesig { [self::SortedMap] }
        def initialize(m)
          @sm = nil
          super(m)
          @sm = m
        end
        
        typesig { [self::SortedMap, Object] }
        def initialize(m, mutex)
          @sm = nil
          super(m, mutex)
          @sm = m
        end
        
        typesig { [] }
        def comparator
          synchronized((self.attr_mutex)) do
            return @sm.comparator
          end
        end
        
        typesig { [Object, Object] }
        def sub_map(from_key, to_key)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedSortedMap.new(@sm.sub_map(from_key, to_key), self.attr_mutex)
          end
        end
        
        typesig { [Object] }
        def head_map(to_key)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedSortedMap.new(@sm.head_map(to_key), self.attr_mutex)
          end
        end
        
        typesig { [Object] }
        def tail_map(from_key)
          synchronized((self.attr_mutex)) do
            return self.class::SynchronizedSortedMap.new(@sm.tail_map(from_key), self.attr_mutex)
          end
        end
        
        typesig { [] }
        def first_key
          synchronized((self.attr_mutex)) do
            return @sm.first_key
          end
        end
        
        typesig { [] }
        def last_key
          synchronized((self.attr_mutex)) do
            return @sm.last_key
          end
        end
        
        private
        alias_method :initialize__synchronized_sorted_map, :initialize
      end }
      
      typesig { [Collection, Class] }
      # Dynamically typesafe collection wrappers
      # 
      # Returns a dynamically typesafe view of the specified collection.
      # Any attempt to insert an element of the wrong type will result in an
      # immediate {@link ClassCastException}.  Assuming a collection
      # contains no incorrectly typed elements prior to the time a
      # dynamically typesafe view is generated, and that all subsequent
      # access to the collection takes place through the view, it is
      # <i>guaranteed</i> that the collection cannot contain an incorrectly
      # typed element.
      # 
      # <p>The generics mechanism in the language provides compile-time
      # (static) type checking, but it is possible to defeat this mechanism
      # with unchecked casts.  Usually this is not a problem, as the compiler
      # issues warnings on all such unchecked operations.  There are, however,
      # times when static type checking alone is not sufficient.  For example,
      # suppose a collection is passed to a third-party library and it is
      # imperative that the library code not corrupt the collection by
      # inserting an element of the wrong type.
      # 
      # <p>Another use of dynamically typesafe views is debugging.  Suppose a
      # program fails with a {@code ClassCastException}, indicating that an
      # incorrectly typed element was put into a parameterized collection.
      # Unfortunately, the exception can occur at any time after the erroneous
      # element is inserted, so it typically provides little or no information
      # as to the real source of the problem.  If the problem is reproducible,
      # one can quickly determine its source by temporarily modifying the
      # program to wrap the collection with a dynamically typesafe view.
      # For example, this declaration:
      # <pre> {@code
      # Collection<String> c = new HashSet<String>();
      # }</pre>
      # may be replaced temporarily by this one:
      # <pre> {@code
      # Collection<String> c = Collections.checkedCollection(
      # new HashSet<String>(), String.class);
      # }</pre>
      # Running the program again will cause it to fail at the point where
      # an incorrectly typed element is inserted into the collection, clearly
      # identifying the source of the problem.  Once the problem is fixed, the
      # modified declaration may be reverted back to the original.
      # 
      # <p>The returned collection does <i>not</i> pass the hashCode and equals
      # operations through to the backing collection, but relies on
      # {@code Object}'s {@code equals} and {@code hashCode} methods.  This
      # is necessary to preserve the contracts of these operations in the case
      # that the backing collection is a set or a list.
      # 
      # <p>The returned collection will be serializable if the specified
      # collection is serializable.
      # 
      # <p>Since {@code null} is considered to be a value of any reference
      # type, the returned collection permits insertion of null elements
      # whenever the backing collection does.
      # 
      # @param c the collection for which a dynamically typesafe view is to be
      # returned
      # @param type the type of element that {@code c} is permitted to hold
      # @return a dynamically typesafe view of the specified collection
      # @since 1.5
      def checked_collection(c, type)
        return CheckedCollection.new(c, type)
      end
      
      typesig { [Class] }
      def zero_length_array(type)
        return Array.new_instance(type, 0)
      end
      
      # @serial include
      const_set_lazy(:CheckedCollection) { Class.new do
        include_class_members Collections
        include Collection
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1578914078182001775 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        typesig { [Object] }
        def type_check(o)
          if (!(o).nil? && !@type.is_instance(o))
            raise self.class::ClassCastException.new(bad_element_msg(o))
          end
        end
        
        typesig { [Object] }
        def bad_element_msg(o)
          return "Attempt to insert " + RJava.cast_to_string(o.get_class) + " element into collection with element type " + RJava.cast_to_string(@type)
        end
        
        typesig { [self::Collection, self::Class] }
        def initialize(c, type)
          @c = nil
          @type = nil
          @zero_length_element_array = nil
          if ((c).nil? || (type).nil?)
            raise self.class::NullPointerException.new
          end
          @c = c
          @type = type
        end
        
        typesig { [] }
        def size
          return @c.size
        end
        
        typesig { [] }
        def is_empty
          return @c.is_empty
        end
        
        typesig { [Object] }
        def contains(o)
          return @c.contains(o)
        end
        
        typesig { [] }
        def to_array
          return @c.to_array
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          return @c.to_array(a)
        end
        
        typesig { [] }
        def to_s
          return @c.to_s
        end
        
        typesig { [Object] }
        def remove(o)
          return @c.remove(o)
        end
        
        typesig { [] }
        def clear
          @c.clear
        end
        
        typesig { [self::Collection] }
        def contains_all(coll)
          return @c.contains_all(coll)
        end
        
        typesig { [self::Collection] }
        def remove_all(coll)
          return @c.remove_all(coll)
        end
        
        typesig { [self::Collection] }
        def retain_all(coll)
          return @c.retain_all(coll)
        end
        
        typesig { [] }
        def iterator
          it = @c.iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members CheckedCollection
            include self::Iterator if self::Iterator.class == Module
            
            typesig { [] }
            define_method :has_next do
              return it.has_next
            end
            
            typesig { [] }
            define_method :next_ do
              return it.next_
            end
            
            typesig { [] }
            define_method :remove do
              it.remove
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [Object] }
        def add(e)
          type_check(e)
          return @c.add(e)
        end
        
        attr_accessor :zero_length_element_array
        alias_method :attr_zero_length_element_array, :zero_length_element_array
        undef_method :zero_length_element_array
        alias_method :attr_zero_length_element_array=, :zero_length_element_array=
        undef_method :zero_length_element_array=
        
        typesig { [] }
        # Lazily initialized
        def zero_length_element_array
          return !(@zero_length_element_array).nil? ? @zero_length_element_array : (@zero_length_element_array = zero_length_array(@type))
        end
        
        typesig { [self::Collection] }
        def checked_copy_of(coll)
          a = nil
          begin
            z = zero_length_element_array
            a = coll.to_array(z)
            # Defend against coll violating the toArray contract
            if (!(a.get_class).equal?(z.get_class))
              a = Arrays.copy_of(a, a.attr_length, z.get_class)
            end
          rescue self.class::ArrayStoreException => ignore
            # To get better and consistent diagnostics,
            # we call typeCheck explicitly on each element.
            # We call clone() to defend against coll retaining a
            # reference to the returned array and storing a bad
            # element into it after it has been type checked.
            a = coll.to_array.clone
            a.each do |o|
              type_check(o)
            end
          end
          # A slight abuse of the type system, but safe here.
          return Arrays.as_list(a)
        end
        
        typesig { [self::Collection] }
        def add_all(coll)
          # Doing things this way insulates us from concurrent changes
          # in the contents of coll and provides all-or-nothing
          # semantics (which we wouldn't get if we type-checked each
          # element as we added it)
          return @c.add_all(checked_copy_of(coll))
        end
        
        private
        alias_method :initialize__checked_collection, :initialize
      end }
      
      typesig { [JavaSet, Class] }
      # Returns a dynamically typesafe view of the specified set.
      # Any attempt to insert an element of the wrong type will result in
      # an immediate {@link ClassCastException}.  Assuming a set contains
      # no incorrectly typed elements prior to the time a dynamically typesafe
      # view is generated, and that all subsequent access to the set
      # takes place through the view, it is <i>guaranteed</i> that the
      # set cannot contain an incorrectly typed element.
      # 
      # <p>A discussion of the use of dynamically typesafe views may be
      # found in the documentation for the {@link #checkedCollection
      # checkedCollection} method.
      # 
      # <p>The returned set will be serializable if the specified set is
      # serializable.
      # 
      # <p>Since {@code null} is considered to be a value of any reference
      # type, the returned set permits insertion of null elements whenever
      # the backing set does.
      # 
      # @param s the set for which a dynamically typesafe view is to be
      # returned
      # @param type the type of element that {@code s} is permitted to hold
      # @return a dynamically typesafe view of the specified set
      # @since 1.5
      def checked_set(s, type)
        return CheckedSet.new(s, type)
      end
      
      # @serial include
      const_set_lazy(:CheckedSet) { Class.new(CheckedCollection) do
        include_class_members Collections
        overload_protected {
          include JavaSet
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 4694047833775013803 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [self::JavaSet, self::Class] }
        def initialize(s, element_type)
          super(s, element_type)
        end
        
        typesig { [Object] }
        def ==(o)
          return (o).equal?(self) || (self.attr_c == o)
        end
        
        typesig { [] }
        def hash_code
          return self.attr_c.hash_code
        end
        
        private
        alias_method :initialize__checked_set, :initialize
      end }
      
      typesig { [SortedSet, Class] }
      # Returns a dynamically typesafe view of the specified sorted set.
      # Any attempt to insert an element of the wrong type will result in an
      # immediate {@link ClassCastException}.  Assuming a sorted set
      # contains no incorrectly typed elements prior to the time a
      # dynamically typesafe view is generated, and that all subsequent
      # access to the sorted set takes place through the view, it is
      # <i>guaranteed</i> that the sorted set cannot contain an incorrectly
      # typed element.
      # 
      # <p>A discussion of the use of dynamically typesafe views may be
      # found in the documentation for the {@link #checkedCollection
      # checkedCollection} method.
      # 
      # <p>The returned sorted set will be serializable if the specified sorted
      # set is serializable.
      # 
      # <p>Since {@code null} is considered to be a value of any reference
      # type, the returned sorted set permits insertion of null elements
      # whenever the backing sorted set does.
      # 
      # @param s the sorted set for which a dynamically typesafe view is to be
      # returned
      # @param type the type of element that {@code s} is permitted to hold
      # @return a dynamically typesafe view of the specified sorted set
      # @since 1.5
      def checked_sorted_set(s, type)
        return CheckedSortedSet.new(s, type)
      end
      
      # @serial include
      const_set_lazy(:CheckedSortedSet) { Class.new(CheckedSet) do
        include_class_members Collections
        overload_protected {
          include SortedSet
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1599911165492914959 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :ss
        alias_method :attr_ss, :ss
        undef_method :ss
        alias_method :attr_ss=, :ss=
        undef_method :ss=
        
        typesig { [self::SortedSet, self::Class] }
        def initialize(s, type)
          @ss = nil
          super(s, type)
          @ss = s
        end
        
        typesig { [] }
        def comparator
          return @ss.comparator
        end
        
        typesig { [] }
        def first
          return @ss.first
        end
        
        typesig { [] }
        def last
          return @ss.last
        end
        
        typesig { [Object, Object] }
        def sub_set(from_element, to_element)
          return checked_sorted_set(@ss.sub_set(from_element, to_element), self.attr_type)
        end
        
        typesig { [Object] }
        def head_set(to_element)
          return checked_sorted_set(@ss.head_set(to_element), self.attr_type)
        end
        
        typesig { [Object] }
        def tail_set(from_element)
          return checked_sorted_set(@ss.tail_set(from_element), self.attr_type)
        end
        
        private
        alias_method :initialize__checked_sorted_set, :initialize
      end }
      
      typesig { [JavaList, Class] }
      # Returns a dynamically typesafe view of the specified list.
      # Any attempt to insert an element of the wrong type will result in
      # an immediate {@link ClassCastException}.  Assuming a list contains
      # no incorrectly typed elements prior to the time a dynamically typesafe
      # view is generated, and that all subsequent access to the list
      # takes place through the view, it is <i>guaranteed</i> that the
      # list cannot contain an incorrectly typed element.
      # 
      # <p>A discussion of the use of dynamically typesafe views may be
      # found in the documentation for the {@link #checkedCollection
      # checkedCollection} method.
      # 
      # <p>The returned list will be serializable if the specified list
      # is serializable.
      # 
      # <p>Since {@code null} is considered to be a value of any reference
      # type, the returned list permits insertion of null elements whenever
      # the backing list does.
      # 
      # @param list the list for which a dynamically typesafe view is to be
      # returned
      # @param type the type of element that {@code list} is permitted to hold
      # @return a dynamically typesafe view of the specified list
      # @since 1.5
      def checked_list(list, type)
        return (list.is_a?(RandomAccess) ? CheckedRandomAccessList.new(list, type) : CheckedList.new(list, type))
      end
      
      # @serial include
      const_set_lazy(:CheckedList) { Class.new(CheckedCollection) do
        include_class_members Collections
        overload_protected {
          include JavaList
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 65247728283967356 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :list
        alias_method :attr_list, :list
        undef_method :list
        alias_method :attr_list=, :list=
        undef_method :list=
        
        typesig { [self::JavaList, self::Class] }
        def initialize(list, type)
          @list = nil
          super(list, type)
          @list = list
        end
        
        typesig { [Object] }
        def ==(o)
          return (o).equal?(self) || (@list == o)
        end
        
        typesig { [] }
        def hash_code
          return @list.hash_code
        end
        
        typesig { [::Java::Int] }
        def get(index)
          return @list.get(index)
        end
        
        typesig { [::Java::Int] }
        def remove(index)
          return @list.remove(index)
        end
        
        typesig { [Object] }
        def index_of(o)
          return @list.index_of(o)
        end
        
        typesig { [Object] }
        def last_index_of(o)
          return @list.last_index_of(o)
        end
        
        typesig { [::Java::Int, Object] }
        def set(index, element)
          type_check(element)
          return @list.set(index, element)
        end
        
        typesig { [::Java::Int, Object] }
        def add(index, element)
          type_check(element)
          @list.add(index, element)
        end
        
        typesig { [::Java::Int, self::Collection] }
        def add_all(index, c)
          return @list.add_all(index, checked_copy_of(c))
        end
        
        typesig { [] }
        def list_iterator
          return list_iterator(0)
        end
        
        typesig { [::Java::Int] }
        def list_iterator(index)
          i = @list.list_iterator(index)
          return Class.new(self.class::ListIterator.class == Class ? self.class::ListIterator : Object) do
            extend LocalClass
            include_class_members CheckedList
            include self::ListIterator if self::ListIterator.class == Module
            
            typesig { [] }
            define_method :has_next do
              return i.has_next
            end
            
            typesig { [] }
            define_method :next_ do
              return i.next_
            end
            
            typesig { [] }
            define_method :has_previous do
              return i.has_previous
            end
            
            typesig { [] }
            define_method :previous do
              return i.previous
            end
            
            typesig { [] }
            define_method :next_index do
              return i.next_index
            end
            
            typesig { [] }
            define_method :previous_index do
              return i.previous_index
            end
            
            typesig { [] }
            define_method :remove do
              i.remove
            end
            
            typesig { [Object] }
            define_method :set do |e|
              type_check(e)
              i.set(e)
            end
            
            typesig { [Object] }
            define_method :add do |e|
              type_check(e)
              i.add(e)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          return self.class::CheckedList.new(@list.sub_list(from_index, to_index), self.attr_type)
        end
        
        private
        alias_method :initialize__checked_list, :initialize
      end }
      
      # @serial include
      const_set_lazy(:CheckedRandomAccessList) { Class.new(CheckedList) do
        include_class_members Collections
        overload_protected {
          include RandomAccess
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1638200125423088369 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [self::JavaList, self::Class] }
        def initialize(list, type)
          super(list, type)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          return self.class::CheckedRandomAccessList.new(self.attr_list.sub_list(from_index, to_index), self.attr_type)
        end
        
        private
        alias_method :initialize__checked_random_access_list, :initialize
      end }
      
      typesig { [Map, Class, Class] }
      # Returns a dynamically typesafe view of the specified map.
      # Any attempt to insert a mapping whose key or value have the wrong
      # type will result in an immediate {@link ClassCastException}.
      # Similarly, any attempt to modify the value currently associated with
      # a key will result in an immediate {@link ClassCastException},
      # whether the modification is attempted directly through the map
      # itself, or through a {@link Map.Entry} instance obtained from the
      # map's {@link Map#entrySet() entry set} view.
      # 
      # <p>Assuming a map contains no incorrectly typed keys or values
      # prior to the time a dynamically typesafe view is generated, and
      # that all subsequent access to the map takes place through the view
      # (or one of its collection views), it is <i>guaranteed</i> that the
      # map cannot contain an incorrectly typed key or value.
      # 
      # <p>A discussion of the use of dynamically typesafe views may be
      # found in the documentation for the {@link #checkedCollection
      # checkedCollection} method.
      # 
      # <p>The returned map will be serializable if the specified map is
      # serializable.
      # 
      # <p>Since {@code null} is considered to be a value of any reference
      # type, the returned map permits insertion of null keys or values
      # whenever the backing map does.
      # 
      # @param m the map for which a dynamically typesafe view is to be
      # returned
      # @param keyType the type of key that {@code m} is permitted to hold
      # @param valueType the type of value that {@code m} is permitted to hold
      # @return a dynamically typesafe view of the specified map
      # @since 1.5
      def checked_map(m, key_type, value_type)
        return CheckedMap.new(m, key_type, value_type)
      end
      
      # @serial include
      const_set_lazy(:CheckedMap) { Class.new do
        include_class_members Collections
        include Map
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 5742860141034234728 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        attr_accessor :key_type
        alias_method :attr_key_type, :key_type
        undef_method :key_type
        alias_method :attr_key_type=, :key_type=
        undef_method :key_type=
        
        attr_accessor :value_type
        alias_method :attr_value_type, :value_type
        undef_method :value_type
        alias_method :attr_value_type=, :value_type=
        undef_method :value_type=
        
        typesig { [Object, Object] }
        def type_check(key, value)
          if (!(key).nil? && !@key_type.is_instance(key))
            raise self.class::ClassCastException.new(bad_key_msg(key))
          end
          if (!(value).nil? && !@value_type.is_instance(value))
            raise self.class::ClassCastException.new(bad_value_msg(value))
          end
        end
        
        typesig { [Object] }
        def bad_key_msg(key)
          return "Attempt to insert " + RJava.cast_to_string(key.get_class) + " key into map with key type " + RJava.cast_to_string(@key_type)
        end
        
        typesig { [Object] }
        def bad_value_msg(value)
          return "Attempt to insert " + RJava.cast_to_string(value.get_class) + " value into map with value type " + RJava.cast_to_string(@value_type)
        end
        
        typesig { [self::Map, self::Class, self::Class] }
        def initialize(m, key_type, value_type)
          @m = nil
          @key_type = nil
          @value_type = nil
          @entry_set = nil
          if ((m).nil? || (key_type).nil? || (value_type).nil?)
            raise self.class::NullPointerException.new
          end
          @m = m
          @key_type = key_type
          @value_type = value_type
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
        def contains_key(key)
          return @m.contains_key(key)
        end
        
        typesig { [Object] }
        def contains_value(v)
          return @m.contains_value(v)
        end
        
        typesig { [Object] }
        def get(key)
          return @m.get(key)
        end
        
        typesig { [Object] }
        def remove(key)
          return @m.remove(key)
        end
        
        typesig { [] }
        def clear
          @m.clear
        end
        
        typesig { [] }
        def key_set
          return @m.key_set
        end
        
        typesig { [] }
        def values
          return @m.values
        end
        
        typesig { [Object] }
        def ==(o)
          return (o).equal?(self) || (@m == o)
        end
        
        typesig { [] }
        def hash_code
          return @m.hash_code
        end
        
        typesig { [] }
        def to_s
          return @m.to_s
        end
        
        typesig { [Object, Object] }
        def put(key, value)
          type_check(key, value)
          return @m.put(key, value)
        end
        
        typesig { [self::Map] }
        def put_all(t)
          # Satisfy the following goals:
          # - good diagnostics in case of type mismatch
          # - all-or-nothing semantics
          # - protection from malicious t
          # - correct behavior if t is a concurrent map
          entries = t.entry_set.to_array
          checked = self.class::ArrayList.new(entries.attr_length)
          entries.each do |o|
            e = o
            k = e.get_key
            v = e.get_value
            type_check(k, v)
            checked.add(self.class::AbstractMap::SimpleImmutableEntry.new(k, v))
          end
          checked.each do |e|
            @m.put(e.get_key, e.get_value)
          end
        end
        
        attr_accessor :entry_set
        alias_method :attr_entry_set, :entry_set
        undef_method :entry_set
        alias_method :attr_entry_set=, :entry_set=
        undef_method :entry_set=
        
        typesig { [] }
        def entry_set
          if ((@entry_set).nil?)
            @entry_set = self.class::CheckedEntrySet.new(@m.entry_set, @value_type)
          end
          return @entry_set
        end
        
        class_module.module_eval {
          # We need this class in addition to CheckedSet as Map.Entry permits
          # modification of the backing Map via the setValue operation.  This
          # class is subtle: there are many possible attacks that must be
          # thwarted.
          # 
          # @serial exclude
          const_set_lazy(:CheckedEntrySet) { Class.new do
            include_class_members CheckedMap
            include self::JavaSet
            
            attr_accessor :s
            alias_method :attr_s, :s
            undef_method :s
            alias_method :attr_s=, :s=
            undef_method :s=
            
            attr_accessor :value_type
            alias_method :attr_value_type, :value_type
            undef_method :value_type
            alias_method :attr_value_type=, :value_type=
            undef_method :value_type=
            
            typesig { [self::JavaSet, self::Class] }
            def initialize(s, value_type)
              @s = nil
              @value_type = nil
              @s = s
              @value_type = value_type
            end
            
            typesig { [] }
            def size
              return @s.size
            end
            
            typesig { [] }
            def is_empty
              return @s.is_empty
            end
            
            typesig { [] }
            def to_s
              return @s.to_s
            end
            
            typesig { [] }
            def hash_code
              return @s.hash_code
            end
            
            typesig { [] }
            def clear
              @s.clear
            end
            
            typesig { [self::Map::Entry] }
            def add(e)
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [self::Collection] }
            def add_all(coll)
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [] }
            def iterator
              i = @s.iterator
              value_type = @value_type
              return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
                extend LocalClass
                include_class_members CheckedEntrySet
                include self::Iterator if self::Iterator.class == Module
                
                typesig { [] }
                define_method :has_next do
                  return i.has_next
                end
                
                typesig { [] }
                define_method :remove do
                  i.remove
                end
                
                typesig { [] }
                define_method :next_ do
                  return checked_entry(i.next_, value_type)
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self)
            end
            
            typesig { [] }
            def to_array
              source = @s.to_array
              # Ensure that we don't get an ArrayStoreException even if
              # s.toArray returns an array of something other than Object
              dest = (CheckedEntry.is_instance(source.get_class.get_component_type) ? source : Array.typed(Object).new(source.attr_length) { nil })
              i = 0
              while i < source.attr_length
                dest[i] = checked_entry(source[i], @value_type)
                i += 1
              end
              return dest
            end
            
            typesig { [Array.typed(self::T)] }
            def to_array(a)
              # We don't pass a to s.toArray, to avoid window of
              # vulnerability wherein an unscrupulous multithreaded client
              # could get his hands on raw (unwrapped) Entries from s.
              arr = @s.to_array((a.attr_length).equal?(0) ? a : Arrays.copy_of(a, 0))
              i = 0
              while i < arr.attr_length
                arr[i] = checked_entry(arr[i], @value_type)
                i += 1
              end
              if (arr.attr_length > a.attr_length)
                return arr
              end
              System.arraycopy(arr, 0, a, 0, arr.attr_length)
              if (a.attr_length > arr.attr_length)
                a[arr.attr_length] = nil
              end
              return a
            end
            
            typesig { [Object] }
            # This method is overridden to protect the backing set against
            # an object with a nefarious equals function that senses
            # that the equality-candidate is Map.Entry and calls its
            # setValue method.
            def contains(o)
              if (!(o.is_a?(self.class::Map::Entry)))
                return false
              end
              e = o
              return @s.contains((e.is_a?(self.class::CheckedEntry)) ? e : checked_entry(e, @value_type))
            end
            
            typesig { [self::Collection] }
            # The bulk collection methods are overridden to protect
            # against an unscrupulous collection whose contains(Object o)
            # method senses when o is a Map.Entry, and calls o.setValue.
            def contains_all(c)
              c.each do |o|
                if (!contains(o))
                  # Invokes safe contains() above
                  return false
                end
              end
              return true
            end
            
            typesig { [Object] }
            def remove(o)
              if (!(o.is_a?(self.class::Map::Entry)))
                return false
              end
              return @s.remove(self.class::AbstractMap::SimpleImmutableEntry.new(o))
            end
            
            typesig { [self::Collection] }
            def remove_all(c)
              return batch_remove(c, false)
            end
            
            typesig { [self::Collection] }
            def retain_all(c)
              return batch_remove(c, true)
            end
            
            typesig { [self::Collection, ::Java::Boolean] }
            def batch_remove(c, complement)
              modified = false
              it = iterator
              while (it.has_next)
                if (!(c.contains(it.next_)).equal?(complement))
                  it.remove
                  modified = true
                end
              end
              return modified
            end
            
            typesig { [Object] }
            def ==(o)
              if ((o).equal?(self))
                return true
              end
              if (!(o.is_a?(self.class::JavaSet)))
                return false
              end
              that = o
              return (that.size).equal?(@s.size) && contains_all(that) # Invokes safe containsAll() above
            end
            
            class_module.module_eval {
              typesig { [self::Map::Entry, self::Class] }
              def checked_entry(e, value_type)
                return self::CheckedEntry.new(e, value_type)
              end
              
              # This "wrapper class" serves two purposes: it prevents
              # the client from modifying the backing Map, by short-circuiting
              # the setValue method, and it protects the backing Map against
              # an ill-behaved Map.Entry that attempts to modify another
              # Map.Entry when asked to perform an equality check.
              const_set_lazy(:CheckedEntry) { Class.new do
                include_class_members CheckedEntrySet
                include self::Map::Entry
                
                attr_accessor :e
                alias_method :attr_e, :e
                undef_method :e
                alias_method :attr_e=, :e=
                undef_method :e=
                
                attr_accessor :value_type
                alias_method :attr_value_type, :value_type
                undef_method :value_type
                alias_method :attr_value_type=, :value_type=
                undef_method :value_type=
                
                typesig { [self::Map::Entry, self::Class] }
                def initialize(e, value_type)
                  @e = nil
                  @value_type = nil
                  @e = e
                  @value_type = value_type
                end
                
                typesig { [] }
                def get_key
                  return @e.get_key
                end
                
                typesig { [] }
                def get_value
                  return @e.get_value
                end
                
                typesig { [] }
                def hash_code
                  return @e.hash_code
                end
                
                typesig { [] }
                def to_s
                  return @e.to_s
                end
                
                typesig { [Object] }
                def set_value(value)
                  if (!(value).nil? && !@value_type.is_instance(value))
                    raise self.class::ClassCastException.new(bad_value_msg(value))
                  end
                  return @e.set_value(value)
                end
                
                typesig { [Object] }
                def bad_value_msg(value)
                  return "Attempt to insert " + RJava.cast_to_string(value.get_class) + " value into map with value type " + RJava.cast_to_string(@value_type)
                end
                
                typesig { [Object] }
                def ==(o)
                  if ((o).equal?(self))
                    return true
                  end
                  if (!(o.is_a?(self.class::Map::Entry)))
                    return false
                  end
                  return (@e == self.class::AbstractMap::SimpleImmutableEntry.new(o))
                end
                
                private
                alias_method :initialize__checked_entry, :initialize
              end }
            }
            
            private
            alias_method :initialize__checked_entry_set, :initialize
          end }
        }
        
        private
        alias_method :initialize__checked_map, :initialize
      end }
      
      typesig { [SortedMap, Class, Class] }
      # Returns a dynamically typesafe view of the specified sorted map.
      # Any attempt to insert a mapping whose key or value have the wrong
      # type will result in an immediate {@link ClassCastException}.
      # Similarly, any attempt to modify the value currently associated with
      # a key will result in an immediate {@link ClassCastException},
      # whether the modification is attempted directly through the map
      # itself, or through a {@link Map.Entry} instance obtained from the
      # map's {@link Map#entrySet() entry set} view.
      # 
      # <p>Assuming a map contains no incorrectly typed keys or values
      # prior to the time a dynamically typesafe view is generated, and
      # that all subsequent access to the map takes place through the view
      # (or one of its collection views), it is <i>guaranteed</i> that the
      # map cannot contain an incorrectly typed key or value.
      # 
      # <p>A discussion of the use of dynamically typesafe views may be
      # found in the documentation for the {@link #checkedCollection
      # checkedCollection} method.
      # 
      # <p>The returned map will be serializable if the specified map is
      # serializable.
      # 
      # <p>Since {@code null} is considered to be a value of any reference
      # type, the returned map permits insertion of null keys or values
      # whenever the backing map does.
      # 
      # @param m the map for which a dynamically typesafe view is to be
      # returned
      # @param keyType the type of key that {@code m} is permitted to hold
      # @param valueType the type of value that {@code m} is permitted to hold
      # @return a dynamically typesafe view of the specified map
      # @since 1.5
      def checked_sorted_map(m, key_type, value_type)
        return CheckedSortedMap.new(m, key_type, value_type)
      end
      
      # @serial include
      const_set_lazy(:CheckedSortedMap) { Class.new(CheckedMap) do
        include_class_members Collections
        overload_protected {
          include SortedMap
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1599671320688067438 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :sm
        alias_method :attr_sm, :sm
        undef_method :sm
        alias_method :attr_sm=, :sm=
        undef_method :sm=
        
        typesig { [self::SortedMap, self::Class, self::Class] }
        def initialize(m, key_type, value_type)
          @sm = nil
          super(m, key_type, value_type)
          @sm = m
        end
        
        typesig { [] }
        def comparator
          return @sm.comparator
        end
        
        typesig { [] }
        def first_key
          return @sm.first_key
        end
        
        typesig { [] }
        def last_key
          return @sm.last_key
        end
        
        typesig { [Object, Object] }
        def sub_map(from_key, to_key)
          return checked_sorted_map(@sm.sub_map(from_key, to_key), self.attr_key_type, self.attr_value_type)
        end
        
        typesig { [Object] }
        def head_map(to_key)
          return checked_sorted_map(@sm.head_map(to_key), self.attr_key_type, self.attr_value_type)
        end
        
        typesig { [Object] }
        def tail_map(from_key)
          return checked_sorted_map(@sm.tail_map(from_key), self.attr_key_type, self.attr_value_type)
        end
        
        private
        alias_method :initialize__checked_sorted_map, :initialize
      end }
      
      typesig { [] }
      # Empty collections
      # 
      # Returns an iterator that has no elements.  More precisely,
      # 
      # <ul compact>
      # 
      # <li>{@link Iterator#hasNext hasNext} always returns {@code
      # false}.
      # 
      # <li>{@link Iterator#next next} always throws {@link
      # NoSuchElementException}.
      # 
      # <li>{@link Iterator#remove remove} always throws {@link
      # IllegalStateException}.
      # 
      # </ul>
      # 
      # <p>Implementations of this method are permitted, but not
      # required, to return the same object from multiple invocations.
      # 
      # @return an empty iterator
      # @since 1.7
      def empty_iterator
        return EmptyIterator::EMPTY_ITERATOR
      end
      
      const_set_lazy(:EmptyIterator) { Class.new do
        include_class_members Collections
        include Iterator
        
        class_module.module_eval {
          const_set_lazy(:EMPTY_ITERATOR) { self::EmptyIterator.new }
          const_attr_reader  :EMPTY_ITERATOR
        }
        
        typesig { [] }
        def has_next
          return false
        end
        
        typesig { [] }
        def next_
          raise self.class::NoSuchElementException.new
        end
        
        typesig { [] }
        def remove
          raise self.class::IllegalStateException.new
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__empty_iterator, :initialize
      end }
      
      typesig { [] }
      # Returns a list iterator that has no elements.  More precisely,
      # 
      # <ul compact>
      # 
      # <li>{@link Iterator#hasNext hasNext} and {@link
      # ListIterator#hasPrevious hasPrevious} always return {@code
      # false}.
      # 
      # <li>{@link Iterator#next next} and {@link ListIterator#previous
      # previous} always throw {@link NoSuchElementException}.
      # 
      # <li>{@link Iterator#remove remove} and {@link ListIterator#set
      # set} always throw {@link IllegalStateException}.
      # 
      # <li>{@link ListIterator#add add} always throws {@link
      # UnsupportedOperationException}.
      # 
      # <li>{@link ListIterator#nextIndex nextIndex} always returns
      # {@code 0} .
      # 
      # <li>{@link ListIterator#previousIndex previousIndex} always
      # returns {@code -1}.
      # 
      # </ul>
      # 
      # <p>Implementations of this method are permitted, but not
      # required, to return the same object from multiple invocations.
      # 
      # @return an empty list iterator
      # @since 1.7
      def empty_list_iterator
        return EmptyListIterator::EMPTY_ITERATOR
      end
      
      const_set_lazy(:EmptyListIterator) { Class.new(EmptyIterator) do
        include_class_members Collections
        overload_protected {
          include ListIterator
        }
        
        class_module.module_eval {
          const_set_lazy(:EMPTY_ITERATOR) { self::EmptyListIterator.new }
          const_attr_reader  :EMPTY_ITERATOR
        }
        
        typesig { [] }
        def has_previous
          return false
        end
        
        typesig { [] }
        def previous
          raise self.class::NoSuchElementException.new
        end
        
        typesig { [] }
        def next_index
          return 0
        end
        
        typesig { [] }
        def previous_index
          return -1
        end
        
        typesig { [Object] }
        def set(e)
          raise self.class::IllegalStateException.new
        end
        
        typesig { [Object] }
        def add(e)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__empty_list_iterator, :initialize
      end }
      
      typesig { [] }
      # Returns an enumeration that has no elements.  More precisely,
      # 
      # <ul compact>
      # 
      # <li>{@link Enumeration#hasMoreElements hasMoreElements} always
      # returns {@code false}.
      # 
      # <li> {@link Enumeration#nextElement nextElement} always throws
      # {@link NoSuchElementException}.
      # 
      # </ul>
      # 
      # <p>Implementations of this method are permitted, but not
      # required, to return the same object from multiple invocations.
      # 
      # @return an empty enumeration
      # @since 1.7
      def empty_enumeration
        return EmptyEnumeration::EMPTY_ENUMERATION
      end
      
      const_set_lazy(:EmptyEnumeration) { Class.new do
        include_class_members Collections
        include Enumeration
        
        class_module.module_eval {
          const_set_lazy(:EMPTY_ENUMERATION) { self::EmptyEnumeration.new }
          const_attr_reader  :EMPTY_ENUMERATION
        }
        
        typesig { [] }
        def has_more_elements
          return false
        end
        
        typesig { [] }
        def next_element
          raise self.class::NoSuchElementException.new
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__empty_enumeration, :initialize
      end }
      
      # The empty set (immutable).  This set is serializable.
      # 
      # @see #emptySet()
      const_set_lazy(:EMPTY_SET) { EmptySet.new }
      const_attr_reader  :EMPTY_SET
      
      typesig { [] }
      # Returns the empty set (immutable).  This set is serializable.
      # Unlike the like-named field, this method is parameterized.
      # 
      # <p>This example illustrates the type-safe way to obtain an empty set:
      # <pre>
      # Set&lt;String&gt; s = Collections.emptySet();
      # </pre>
      # Implementation note:  Implementations of this method need not
      # create a separate <tt>Set</tt> object for each call.   Using this
      # method is likely to have comparable cost to using the like-named
      # field.  (Unlike this method, the field does not provide type safety.)
      # 
      # @see #EMPTY_SET
      # @since 1.5
      def empty_set
        return EMPTY_SET
      end
      
      # @serial include
      const_set_lazy(:EmptySet) { Class.new(AbstractSet) do
        include_class_members Collections
        overload_protected {
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1582296315990362920 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def iterator
          return empty_iterator
        end
        
        typesig { [] }
        def size
          return 0
        end
        
        typesig { [] }
        def is_empty
          return true
        end
        
        typesig { [Object] }
        def contains(obj)
          return false
        end
        
        typesig { [self::Collection] }
        def contains_all(c)
          return c.is_empty
        end
        
        typesig { [] }
        def to_array
          return Array.typed(Object).new(0) { nil }
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          if (a.attr_length > 0)
            a[0] = nil
          end
          return a
        end
        
        typesig { [] }
        # Preserves singleton property
        def read_resolve
          return EMPTY_SET
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__empty_set, :initialize
      end }
      
      # The empty list (immutable).  This list is serializable.
      # 
      # @see #emptyList()
      const_set_lazy(:EMPTY_LIST) { EmptyList.new }
      const_attr_reader  :EMPTY_LIST
      
      typesig { [] }
      # Returns the empty list (immutable).  This list is serializable.
      # 
      # <p>This example illustrates the type-safe way to obtain an empty list:
      # <pre>
      # List&lt;String&gt; s = Collections.emptyList();
      # </pre>
      # Implementation note:  Implementations of this method need not
      # create a separate <tt>List</tt> object for each call.   Using this
      # method is likely to have comparable cost to using the like-named
      # field.  (Unlike this method, the field does not provide type safety.)
      # 
      # @see #EMPTY_LIST
      # @since 1.5
      def empty_list
        return EMPTY_LIST
      end
      
      # @serial include
      const_set_lazy(:EmptyList) { Class.new(AbstractList) do
        include_class_members Collections
        overload_protected {
          include RandomAccess
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 8842843931221139166 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def iterator
          return empty_iterator
        end
        
        typesig { [] }
        def list_iterator
          return empty_list_iterator
        end
        
        typesig { [] }
        def size
          return 0
        end
        
        typesig { [] }
        def is_empty
          return true
        end
        
        typesig { [Object] }
        def contains(obj)
          return false
        end
        
        typesig { [self::Collection] }
        def contains_all(c)
          return c.is_empty
        end
        
        typesig { [] }
        def to_array
          return Array.typed(Object).new(0) { nil }
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          if (a.attr_length > 0)
            a[0] = nil
          end
          return a
        end
        
        typesig { [::Java::Int] }
        def get(index)
          raise self.class::IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index))
        end
        
        typesig { [Object] }
        def ==(o)
          return (o.is_a?(self.class::JavaList)) && (o).is_empty
        end
        
        typesig { [] }
        def hash_code
          return 1
        end
        
        typesig { [] }
        # Preserves singleton property
        def read_resolve
          return EMPTY_LIST
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__empty_list, :initialize
      end }
      
      # The empty map (immutable).  This map is serializable.
      # 
      # @see #emptyMap()
      # @since 1.3
      const_set_lazy(:EMPTY_MAP) { EmptyMap.new }
      const_attr_reader  :EMPTY_MAP
      
      typesig { [] }
      # Returns the empty map (immutable).  This map is serializable.
      # 
      # <p>This example illustrates the type-safe way to obtain an empty set:
      # <pre>
      # Map&lt;String, Date&gt; s = Collections.emptyMap();
      # </pre>
      # Implementation note:  Implementations of this method need not
      # create a separate <tt>Map</tt> object for each call.   Using this
      # method is likely to have comparable cost to using the like-named
      # field.  (Unlike this method, the field does not provide type safety.)
      # 
      # @see #EMPTY_MAP
      # @since 1.5
      def empty_map
        return EMPTY_MAP
      end
      
      const_set_lazy(:EmptyMap) { Class.new(AbstractMap) do
        include_class_members Collections
        overload_protected {
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 6428348081105594320 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def size
          return 0
        end
        
        typesig { [] }
        def is_empty
          return true
        end
        
        typesig { [Object] }
        def contains_key(key)
          return false
        end
        
        typesig { [Object] }
        def contains_value(value)
          return false
        end
        
        typesig { [Object] }
        def get(key)
          return nil
        end
        
        typesig { [] }
        def key_set
          return empty_set
        end
        
        typesig { [] }
        def values
          return empty_set
        end
        
        typesig { [] }
        def entry_set
          return empty_set
        end
        
        typesig { [Object] }
        def ==(o)
          return (o.is_a?(self.class::Map)) && (o).is_empty
        end
        
        typesig { [] }
        def hash_code
          return 0
        end
        
        typesig { [] }
        # Preserves singleton property
        def read_resolve
          return EMPTY_MAP
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__empty_map, :initialize
      end }
      
      typesig { [T] }
      # Singleton collections
      # 
      # Returns an immutable set containing only the specified object.
      # The returned set is serializable.
      # 
      # @param o the sole object to be stored in the returned set.
      # @return an immutable set containing only the specified object.
      def singleton(o)
        return SingletonSet.new(o)
      end
      
      typesig { [E] }
      def singleton_iterator(e)
        return Class.new(Iterator.class == Class ? Iterator : Object) do
          extend LocalClass
          include_class_members Collections
          include Iterator if Iterator.class == Module
          
          attr_accessor :has_next
          alias_method :attr_has_next, :has_next
          undef_method :has_next
          alias_method :attr_has_next=, :has_next=
          undef_method :has_next=
          
          typesig { [] }
          define_method :has_next do
            return @has_next
          end
          
          typesig { [] }
          define_method :next_ do
            if (@has_next)
              @has_next = false
              return e
            end
            raise self.class::NoSuchElementException.new
          end
          
          typesig { [] }
          define_method :remove do
            raise self.class::UnsupportedOperationException.new
          end
          
          typesig { [] }
          define_method :initialize do
            @has_next = false
            super()
            @has_next = true
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      # @serial include
      const_set_lazy(:SingletonSet) { Class.new(AbstractSet) do
        include_class_members Collections
        overload_protected {
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 3193687207550431679 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :element
        alias_method :attr_element, :element
        undef_method :element
        alias_method :attr_element=, :element=
        undef_method :element=
        
        typesig { [Object] }
        def initialize(e)
          @element = nil
          super()
          @element = e
        end
        
        typesig { [] }
        def iterator
          return singleton_iterator(@element)
        end
        
        typesig { [] }
        def size
          return 1
        end
        
        typesig { [Object] }
        def contains(o)
          return eq(o, @element)
        end
        
        private
        alias_method :initialize__singleton_set, :initialize
      end }
      
      typesig { [T] }
      # Returns an immutable list containing only the specified object.
      # The returned list is serializable.
      # 
      # @param o the sole object to be stored in the returned list.
      # @return an immutable list containing only the specified object.
      # @since 1.3
      def singleton_list(o)
        return SingletonList.new(o)
      end
      
      const_set_lazy(:SingletonList) { Class.new(AbstractList) do
        include_class_members Collections
        overload_protected {
          include RandomAccess
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 3093736618740652951 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :element
        alias_method :attr_element, :element
        undef_method :element
        alias_method :attr_element=, :element=
        undef_method :element=
        
        typesig { [Object] }
        def initialize(obj)
          @element = nil
          super()
          @element = obj
        end
        
        typesig { [] }
        def iterator
          return singleton_iterator(@element)
        end
        
        typesig { [] }
        def size
          return 1
        end
        
        typesig { [Object] }
        def contains(obj)
          return eq(obj, @element)
        end
        
        typesig { [::Java::Int] }
        def get(index)
          if (!(index).equal?(0))
            raise self.class::IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index) + ", Size: 1")
          end
          return @element
        end
        
        private
        alias_method :initialize__singleton_list, :initialize
      end }
      
      typesig { [K, V] }
      # Returns an immutable map, mapping only the specified key to the
      # specified value.  The returned map is serializable.
      # 
      # @param key the sole key to be stored in the returned map.
      # @param value the value to which the returned map maps <tt>key</tt>.
      # @return an immutable map containing only the specified key-value
      # mapping.
      # @since 1.3
      def singleton_map(key, value)
        return SingletonMap.new(key, value)
      end
      
      const_set_lazy(:SingletonMap) { Class.new(AbstractMap) do
        include_class_members Collections
        overload_protected {
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -6979724477215052911 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :k
        alias_method :attr_k, :k
        undef_method :k
        alias_method :attr_k=, :k=
        undef_method :k=
        
        attr_accessor :v
        alias_method :attr_v, :v
        undef_method :v
        alias_method :attr_v=, :v=
        undef_method :v=
        
        typesig { [Object, Object] }
        def initialize(key, value)
          @k = nil
          @v = nil
          @key_set = nil
          @entry_set = nil
          @values = nil
          super()
          @key_set = nil
          @entry_set = nil
          @values = nil
          @k = key
          @v = value
        end
        
        typesig { [] }
        def size
          return 1
        end
        
        typesig { [] }
        def is_empty
          return false
        end
        
        typesig { [Object] }
        def contains_key(key)
          return eq(key, @k)
        end
        
        typesig { [Object] }
        def contains_value(value)
          return eq(value, @v)
        end
        
        typesig { [Object] }
        def get(key)
          return (eq(key, @k) ? @v : nil)
        end
        
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
        def key_set
          if ((@key_set).nil?)
            @key_set = singleton(@k)
          end
          return @key_set
        end
        
        typesig { [] }
        def entry_set
          if ((@entry_set).nil?)
            @entry_set = Collections.singleton(self.class::SimpleImmutableEntry.new(@k, @v))
          end
          return @entry_set
        end
        
        typesig { [] }
        def values
          if ((@values).nil?)
            @values = singleton(@v)
          end
          return @values
        end
        
        private
        alias_method :initialize__singleton_map, :initialize
      end }
      
      typesig { [::Java::Int, T] }
      # Miscellaneous
      # 
      # Returns an immutable list consisting of <tt>n</tt> copies of the
      # specified object.  The newly allocated data object is tiny (it contains
      # a single reference to the data object).  This method is useful in
      # combination with the <tt>List.addAll</tt> method to grow lists.
      # The returned list is serializable.
      # 
      # @param  n the number of elements in the returned list.
      # @param  o the element to appear repeatedly in the returned list.
      # @return an immutable list consisting of <tt>n</tt> copies of the
      # specified object.
      # @throws IllegalArgumentException if n &lt; 0.
      # @see    List#addAll(Collection)
      # @see    List#addAll(int, Collection)
      def n_copies(n, o)
        if (n < 0)
          raise IllegalArgumentException.new("List length = " + RJava.cast_to_string(n))
        end
        return CopiesList.new(n, o)
      end
      
      # @serial include
      const_set_lazy(:CopiesList) { Class.new(AbstractList) do
        include_class_members Collections
        overload_protected {
          include RandomAccess
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 2739099268398711800 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :n
        alias_method :attr_n, :n
        undef_method :n
        alias_method :attr_n=, :n=
        undef_method :n=
        
        attr_accessor :element
        alias_method :attr_element, :element
        undef_method :element
        alias_method :attr_element=, :element=
        undef_method :element=
        
        typesig { [::Java::Int, Object] }
        def initialize(n, e)
          @n = 0
          @element = nil
          super()
          raise AssertError if not (n >= 0)
          @n = n
          @element = e
        end
        
        typesig { [] }
        def size
          return @n
        end
        
        typesig { [Object] }
        def contains(obj)
          return !(@n).equal?(0) && eq(obj, @element)
        end
        
        typesig { [Object] }
        def index_of(o)
          return contains(o) ? 0 : -1
        end
        
        typesig { [Object] }
        def last_index_of(o)
          return contains(o) ? @n - 1 : -1
        end
        
        typesig { [::Java::Int] }
        def get(index)
          if (index < 0 || index >= @n)
            raise self.class::IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index) + ", Size: " + RJava.cast_to_string(@n))
          end
          return @element
        end
        
        typesig { [] }
        def to_array
          a = Array.typed(Object).new(@n) { nil }
          if (!(@element).nil?)
            Arrays.fill(a, 0, @n, @element)
          end
          return a
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          n = @n
          if (a.attr_length < n)
            a = Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, n)
            if (!(@element).nil?)
              Arrays.fill(a, 0, n, @element)
            end
          else
            Arrays.fill(a, 0, n, @element)
            if (a.attr_length > n)
              a[n] = nil
            end
          end
          return a
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          if (from_index < 0)
            raise self.class::IndexOutOfBoundsException.new("fromIndex = " + RJava.cast_to_string(from_index))
          end
          if (to_index > @n)
            raise self.class::IndexOutOfBoundsException.new("toIndex = " + RJava.cast_to_string(to_index))
          end
          if (from_index > to_index)
            raise self.class::IllegalArgumentException.new("fromIndex(" + RJava.cast_to_string(from_index) + ") > toIndex(" + RJava.cast_to_string(to_index) + ")")
          end
          return self.class::CopiesList.new(to_index - from_index, @element)
        end
        
        private
        alias_method :initialize__copies_list, :initialize
      end }
      
      typesig { [] }
      # Returns a comparator that imposes the reverse of the <i>natural
      # ordering</i> on a collection of objects that implement the
      # <tt>Comparable</tt> interface.  (The natural ordering is the ordering
      # imposed by the objects' own <tt>compareTo</tt> method.)  This enables a
      # simple idiom for sorting (or maintaining) collections (or arrays) of
      # objects that implement the <tt>Comparable</tt> interface in
      # reverse-natural-order.  For example, suppose a is an array of
      # strings. Then: <pre>
      # Arrays.sort(a, Collections.reverseOrder());
      # </pre> sorts the array in reverse-lexicographic (alphabetical) order.<p>
      # 
      # The returned comparator is serializable.
      # 
      # @return a comparator that imposes the reverse of the <i>natural
      # ordering</i> on a collection of objects that implement
      # the <tt>Comparable</tt> interface.
      # @see Comparable
      def reverse_order
        return ReverseComparator::REVERSE_ORDER
      end
      
      # @serial include
      const_set_lazy(:ReverseComparator) { Class.new do
        include_class_members Collections
        include Comparator
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 7207038068494060240 }
          const_attr_reader  :SerialVersionUID
          
          const_set_lazy(:REVERSE_ORDER) { self::ReverseComparator.new }
          const_attr_reader  :REVERSE_ORDER
        }
        
        typesig { [self::JavaComparable, self::JavaComparable] }
        def compare(c1, c2)
          return (c2 <=> c1)
        end
        
        typesig { [] }
        def read_resolve
          return reverse_order
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__reverse_comparator, :initialize
      end }
      
      typesig { [Comparator] }
      # Returns a comparator that imposes the reverse ordering of the specified
      # comparator.  If the specified comparator is null, this method is
      # equivalent to {@link #reverseOrder()} (in other words, it returns a
      # comparator that imposes the reverse of the <i>natural ordering</i> on a
      # collection of objects that implement the Comparable interface).
      # 
      # <p>The returned comparator is serializable (assuming the specified
      # comparator is also serializable or null).
      # 
      # @return a comparator that imposes the reverse ordering of the
      # specified comparator
      # @since 1.5
      def reverse_order(cmp)
        if ((cmp).nil?)
          return reverse_order
        end
        if (cmp.is_a?(ReverseComparator2))
          return (cmp).attr_cmp
        end
        return ReverseComparator2.new(cmp)
      end
      
      # @serial include
      const_set_lazy(:ReverseComparator2) { Class.new do
        include_class_members Collections
        include Comparator
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 4374092139857 }
          const_attr_reader  :SerialVersionUID
        }
        
        # The comparator specified in the static factory.  This will never
        # be null, as the static factory returns a ReverseComparator
        # instance if its argument is null.
        # 
        # @serial
        attr_accessor :cmp
        alias_method :attr_cmp, :cmp
        undef_method :cmp
        alias_method :attr_cmp=, :cmp=
        undef_method :cmp=
        
        typesig { [self::Comparator] }
        def initialize(cmp)
          @cmp = nil
          raise AssertError if not (!(cmp).nil?)
          @cmp = cmp
        end
        
        typesig { [Object, Object] }
        def compare(t1, t2)
          return @cmp.compare(t2, t1)
        end
        
        typesig { [Object] }
        def ==(o)
          return ((o).equal?(self)) || (o.is_a?(self.class::ReverseComparator2) && (@cmp == (o).attr_cmp))
        end
        
        typesig { [] }
        def hash_code
          return @cmp.hash_code ^ JavaInteger::MIN_VALUE
        end
        
        private
        alias_method :initialize__reverse_comparator2, :initialize
      end }
      
      typesig { [Collection] }
      # Returns an enumeration over the specified collection.  This provides
      # interoperability with legacy APIs that require an enumeration
      # as input.
      # 
      # @param c the collection for which an enumeration is to be returned.
      # @return an enumeration over the specified collection.
      # @see Enumeration
      def enumeration(c)
        return Class.new(Enumeration.class == Class ? Enumeration : Object) do
          extend LocalClass
          include_class_members Collections
          include Enumeration if Enumeration.class == Module
          
          attr_accessor :i
          alias_method :attr_i, :i
          undef_method :i
          alias_method :attr_i=, :i=
          undef_method :i=
          
          typesig { [] }
          define_method :has_more_elements do
            return @i.has_next
          end
          
          typesig { [] }
          define_method :next_element do
            return @i.next_
          end
          
          typesig { [] }
          define_method :initialize do
            @i = nil
            super()
            @i = c.iterator
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [Enumeration] }
      # Returns an array list containing the elements returned by the
      # specified enumeration in the order they are returned by the
      # enumeration.  This method provides interoperability between
      # legacy APIs that return enumerations and new APIs that require
      # collections.
      # 
      # @param e enumeration providing elements for the returned
      # array list
      # @return an array list containing the elements returned
      # by the specified enumeration.
      # @since 1.4
      # @see Enumeration
      # @see ArrayList
      def list(e)
        l = ArrayList.new
        while (e.has_more_elements)
          l.add(e.next_element)
        end
        return l
      end
      
      typesig { [Object, Object] }
      # Returns true if the specified arguments are equal, or both null.
      def eq(o1, o2)
        return (o1).nil? ? (o2).nil? : (o1 == o2)
      end
      
      typesig { [Collection, Object] }
      # Returns the number of elements in the specified collection equal to the
      # specified object.  More formally, returns the number of elements
      # <tt>e</tt> in the collection such that
      # <tt>(o == null ? e == null : o.equals(e))</tt>.
      # 
      # @param c the collection in which to determine the frequency
      # of <tt>o</tt>
      # @param o the object whose frequency is to be determined
      # @throws NullPointerException if <tt>c</tt> is null
      # @since 1.5
      def frequency(c, o)
        result = 0
        if ((o).nil?)
          c.each do |e|
            if ((e).nil?)
              result += 1
            end
          end
        else
          c.each do |e|
            if ((o == e))
              result += 1
            end
          end
        end
        return result
      end
      
      typesig { [Collection, Collection] }
      # Returns <tt>true</tt> if the two specified collections have no
      # elements in common.
      # 
      # <p>Care must be exercised if this method is used on collections that
      # do not comply with the general contract for <tt>Collection</tt>.
      # Implementations may elect to iterate over either collection and test
      # for containment in the other collection (or to perform any equivalent
      # computation).  If either collection uses a nonstandard equality test
      # (as does a {@link SortedSet} whose ordering is not <i>compatible with
      # equals</i>, or the key set of an {@link IdentityHashMap}), both
      # collections must use the same nonstandard equality test, or the
      # result of this method is undefined.
      # 
      # <p>Note that it is permissible to pass the same collection in both
      # parameters, in which case the method will return true if and only if
      # the collection is empty.
      # 
      # @param c1 a collection
      # @param c2 a collection
      # @throws NullPointerException if either collection is null
      # @since 1.5
      def disjoint(c1, c2)
        # We're going to iterate through c1 and test for inclusion in c2.
        # If c1 is a Set and c2 isn't, swap the collections.  Otherwise,
        # place the shorter collection in c1.  Hopefully this heuristic
        # will minimize the cost of the operation.
        if ((c1.is_a?(JavaSet)) && !(c2.is_a?(JavaSet)) || (c1.size > c2.size))
          tmp = c1
          c1 = c2
          c2 = tmp
        end
        c1.each do |e|
          if (c2.contains(e))
            return false
          end
        end
        return true
      end
      
      typesig { [Collection, T] }
      # Adds all of the specified elements to the specified collection.
      # Elements to be added may be specified individually or as an array.
      # The behavior of this convenience method is identical to that of
      # <tt>c.addAll(Arrays.asList(elements))</tt>, but this method is likely
      # to run significantly faster under most implementations.
      # 
      # <p>When elements are specified individually, this method provides a
      # convenient way to add a few elements to an existing collection:
      # <pre>
      # Collections.addAll(flavors, "Peaches 'n Plutonium", "Rocky Racoon");
      # </pre>
      # 
      # @param c the collection into which <tt>elements</tt> are to be inserted
      # @param elements the elements to insert into <tt>c</tt>
      # @return <tt>true</tt> if the collection changed as a result of the call
      # @throws UnsupportedOperationException if <tt>c</tt> does not support
      # the <tt>add</tt> operation
      # @throws NullPointerException if <tt>elements</tt> contains one or more
      # null values and <tt>c</tt> does not permit null elements, or
      # if <tt>c</tt> or <tt>elements</tt> are <tt>null</tt>
      # @throws IllegalArgumentException if some property of a value in
      # <tt>elements</tt> prevents it from being added to <tt>c</tt>
      # @see Collection#addAll(Collection)
      # @since 1.5
      def add_all(c, *elements)
        result = false
        elements.each do |element|
          result |= c.add(element)
        end
        return result
      end
      
      typesig { [Map] }
      # Returns a set backed by the specified map.  The resulting set displays
      # the same ordering, concurrency, and performance characteristics as the
      # backing map.  In essence, this factory method provides a {@link Set}
      # implementation corresponding to any {@link Map} implementation.  There
      # is no need to use this method on a {@link Map} implementation that
      # already has a corresponding {@link Set} implementation (such as {@link
      # HashMap} or {@link TreeMap}).
      # 
      # <p>Each method invocation on the set returned by this method results in
      # exactly one method invocation on the backing map or its <tt>keySet</tt>
      # view, with one exception.  The <tt>addAll</tt> method is implemented
      # as a sequence of <tt>put</tt> invocations on the backing map.
      # 
      # <p>The specified map must be empty at the time this method is invoked,
      # and should not be accessed directly after this method returns.  These
      # conditions are ensured if the map is created empty, passed directly
      # to this method, and no reference to the map is retained, as illustrated
      # in the following code fragment:
      # <pre>
      # Set&lt;Object&gt; weakHashSet = Collections.newSetFromMap(
      # new WeakHashMap&lt;Object, Boolean&gt;());
      # </pre>
      # 
      # @param map the backing map
      # @return the set backed by the map
      # @throws IllegalArgumentException if <tt>map</tt> is not empty
      # @since 1.6
      def new_set_from_map(map)
        return SetFromMap.new(map)
      end
      
      const_set_lazy(:SetFromMap) { Class.new(AbstractSet) do
        include_class_members Collections
        overload_protected {
          include JavaSet
          include Serializable
        }
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        # The backing map
        attr_accessor :s
        alias_method :attr_s, :s
        undef_method :s
        alias_method :attr_s=, :s=
        undef_method :s=
        
        typesig { [self::Map] }
        # Its keySet
        def initialize(map)
          @m = nil
          @s = nil
          super()
          if (!map.is_empty)
            raise self.class::IllegalArgumentException.new("Map is non-empty")
          end
          @m = map
          @s = map.key_set
        end
        
        typesig { [] }
        def clear
          @m.clear
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
        
        typesig { [Object] }
        def remove(o)
          return !(@m.remove(o)).nil?
        end
        
        typesig { [Object] }
        def add(e)
          return (@m.put(e, Boolean::TRUE)).nil?
        end
        
        typesig { [] }
        def iterator
          return @s.iterator
        end
        
        typesig { [] }
        def to_array
          return @s.to_array
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          return @s.to_array(a)
        end
        
        typesig { [] }
        def to_s
          return @s.to_s
        end
        
        typesig { [] }
        def hash_code
          return @s.hash_code
        end
        
        typesig { [Object] }
        def ==(o)
          return (o).equal?(self) || (@s == o)
        end
        
        typesig { [self::Collection] }
        def contains_all(c)
          return @s.contains_all(c)
        end
        
        typesig { [self::Collection] }
        def remove_all(c)
          return @s.remove_all(c)
        end
        
        typesig { [self::Collection] }
        def retain_all(c)
          return @s.retain_all(c)
        end
        
        class_module.module_eval {
          # addAll is the only inherited implementation
          const_set_lazy(:SerialVersionUID) { 2454657854757543876 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [Java::Io::ObjectInputStream] }
        def read_object(stream)
          stream.default_read_object
          @s = @m.key_set
        end
        
        private
        alias_method :initialize__set_from_map, :initialize
      end }
      
      typesig { [Deque] }
      # Returns a view of a {@link Deque} as a Last-in-first-out (Lifo)
      # {@link Queue}. Method <tt>add</tt> is mapped to <tt>push</tt>,
      # <tt>remove</tt> is mapped to <tt>pop</tt> and so on. This
      # view can be useful when you would like to use a method
      # requiring a <tt>Queue</tt> but you need Lifo ordering.
      # 
      # <p>Each method invocation on the queue returned by this method
      # results in exactly one method invocation on the backing deque, with
      # one exception.  The {@link Queue#addAll addAll} method is
      # implemented as a sequence of {@link Deque#addFirst addFirst}
      # invocations on the backing deque.
      # 
      # @param deque the deque
      # @return the queue
      # @since  1.6
      def as_lifo_queue(deque)
        return AsLIFOQueue.new(deque)
      end
      
      # We use inherited addAll; forwarding addAll would be wrong
      const_set_lazy(:AsLIFOQueue) { Class.new(AbstractQueue) do
        include_class_members Collections
        overload_protected {
          include Queue
          include Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1802017725587941708 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :q
        alias_method :attr_q, :q
        undef_method :q
        alias_method :attr_q=, :q=
        undef_method :q=
        
        typesig { [self::Deque] }
        def initialize(q)
          @q = nil
          super()
          @q = q
        end
        
        typesig { [Object] }
        def add(e)
          @q.add_first(e)
          return true
        end
        
        typesig { [Object] }
        def offer(e)
          return @q.offer_first(e)
        end
        
        typesig { [] }
        def poll
          return @q.poll_first
        end
        
        typesig { [] }
        def remove
          return @q.remove_first
        end
        
        typesig { [] }
        def peek
          return @q.peek_first
        end
        
        typesig { [] }
        def element
          return @q.get_first
        end
        
        typesig { [] }
        def clear
          @q.clear
        end
        
        typesig { [] }
        def size
          return @q.size
        end
        
        typesig { [] }
        def is_empty
          return @q.is_empty
        end
        
        typesig { [Object] }
        def contains(o)
          return @q.contains(o)
        end
        
        typesig { [Object] }
        def remove(o)
          return @q.remove(o)
        end
        
        typesig { [] }
        def iterator
          return @q.iterator
        end
        
        typesig { [] }
        def to_array
          return @q.to_array
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          return @q.to_array(a)
        end
        
        typesig { [] }
        def to_s
          return @q.to_s
        end
        
        typesig { [self::Collection] }
        def contains_all(c)
          return @q.contains_all(c)
        end
        
        typesig { [self::Collection] }
        def remove_all(c)
          return @q.remove_all(c)
        end
        
        typesig { [self::Collection] }
        def retain_all(c)
          return @q.retain_all(c)
        end
        
        private
        alias_method :initialize__as_lifoqueue, :initialize
      end }
    }
    
    private
    alias_method :initialize__collections, :initialize
  end
  
end
