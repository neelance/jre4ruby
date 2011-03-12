require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group.  Adapted and released, under explicit permission,
# from JDK ArrayList.java which carries the following copyright:
# 
# Copyright 1997 by Sun Microsystems, Inc.,
# 901 San Antonio Road, Palo Alto, California, 94303, U.S.A.
# All rights reserved.
module Java::Util::Concurrent
  module CopyOnWriteArrayListImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
      include ::Java::Util::Concurrent::Locks
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # A thread-safe variant of {@link java.util.ArrayList} in which all mutative
  # operations (<tt>add</tt>, <tt>set</tt>, and so on) are implemented by
  # making a fresh copy of the underlying array.
  # 
  # <p> This is ordinarily too costly, but may be <em>more</em> efficient
  # than alternatives when traversal operations vastly outnumber
  # mutations, and is useful when you cannot or don't want to
  # synchronize traversals, yet need to preclude interference among
  # concurrent threads.  The "snapshot" style iterator method uses a
  # reference to the state of the array at the point that the iterator
  # was created. This array never changes during the lifetime of the
  # iterator, so interference is impossible and the iterator is
  # guaranteed not to throw <tt>ConcurrentModificationException</tt>.
  # The iterator will not reflect additions, removals, or changes to
  # the list since the iterator was created.  Element-changing
  # operations on iterators themselves (<tt>remove</tt>, <tt>set</tt>, and
  # <tt>add</tt>) are not supported. These methods throw
  # <tt>UnsupportedOperationException</tt>.
  # 
  # <p>All elements are permitted, including <tt>null</tt>.
  # 
  # <p>Memory consistency effects: As with other concurrent
  # collections, actions in a thread prior to placing an object into a
  # {@code CopyOnWriteArrayList}
  # <a href="package-summary.html#MemoryVisibility"><i>happen-before</i></a>
  # actions subsequent to the access or removal of that element from
  # the {@code CopyOnWriteArrayList} in another thread.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <E> the type of elements held in this collection
  class CopyOnWriteArrayList 
    include_class_members CopyOnWriteArrayListImports
    include JavaList
    include RandomAccess
    include Cloneable
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 8673264195747942595 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The lock protecting all mutators
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    # The array, accessed only via getArray/setArray.
    attr_accessor :array
    alias_method :attr_array, :array
    undef_method :array
    alias_method :attr_array=, :array=
    undef_method :array=
    
    typesig { [] }
    # Gets the array.  Non-private so as to also be accessible
    # from CopyOnWriteArraySet class.
    def get_array
      return @array
    end
    
    typesig { [Array.typed(Object)] }
    # Sets the array.
    def set_array(a)
      @array = a
    end
    
    typesig { [] }
    # Creates an empty list.
    def initialize
      @lock = ReentrantLock.new
      @array = nil
      set_array(Array.typed(Object).new(0) { nil })
    end
    
    typesig { [Collection] }
    # Creates a list containing the elements of the specified
    # collection, in the order they are returned by the collection's
    # iterator.
    # 
    # @param c the collection of initially held elements
    # @throws NullPointerException if the specified collection is null
    def initialize(c)
      @lock = ReentrantLock.new
      @array = nil
      elements = c.to_array
      # c.toArray might (incorrectly) not return Object[] (see 6260652)
      if (!(elements.get_class).equal?(Array[]))
        elements = Arrays.copy_of(elements, elements.attr_length, Array[])
      end
      set_array(elements)
    end
    
    typesig { [Array.typed(Object)] }
    # Creates a list holding a copy of the given array.
    # 
    # @param toCopyIn the array (a copy of this array is used as the
    #        internal array)
    # @throws NullPointerException if the specified array is null
    def initialize(to_copy_in)
      @lock = ReentrantLock.new
      @array = nil
      set_array(Arrays.copy_of(to_copy_in, to_copy_in.attr_length, Array[]))
    end
    
    typesig { [] }
    # Returns the number of elements in this list.
    # 
    # @return the number of elements in this list
    def size
      return get_array.attr_length
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this list contains no elements.
    # 
    # @return <tt>true</tt> if this list contains no elements
    def is_empty
      return (size).equal?(0)
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # Test for equality, coping with nulls.
      def eq(o1, o2)
        return ((o1).nil? ? (o2).nil? : (o1 == o2))
      end
      
      typesig { [Object, Array.typed(Object), ::Java::Int, ::Java::Int] }
      # static version of indexOf, to allow repeated calls without
      # needing to re-acquire array each time.
      # @param o element to search for
      # @param elements the array
      # @param index first index to search
      # @param fence one past last index to search
      # @return index of element, or -1 if absent
      def index_of(o, elements, index, fence)
        if ((o).nil?)
          i = index
          while i < fence
            if ((elements[i]).nil?)
              return i
            end
            i += 1
          end
        else
          i = index
          while i < fence
            if ((o == elements[i]))
              return i
            end
            i += 1
          end
        end
        return -1
      end
      
      typesig { [Object, Array.typed(Object), ::Java::Int] }
      # static version of lastIndexOf.
      # @param o element to search for
      # @param elements the array
      # @param index first index to search
      # @return index of element, or -1 if absent
      def last_index_of(o, elements, index)
        if ((o).nil?)
          i = index
          while i >= 0
            if ((elements[i]).nil?)
              return i
            end
            i -= 1
          end
        else
          i = index
          while i >= 0
            if ((o == elements[i]))
              return i
            end
            i -= 1
          end
        end
        return -1
      end
    }
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this list contains the specified element.
    # More formally, returns <tt>true</tt> if and only if this list contains
    # at least one element <tt>e</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>.
    # 
    # @param o element whose presence in this list is to be tested
    # @return <tt>true</tt> if this list contains the specified element
    def contains(o)
      elements = get_array
      return index_of(o, elements, 0, elements.attr_length) >= 0
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    def index_of(o)
      elements = get_array
      return index_of(o, elements, 0, elements.attr_length)
    end
    
    typesig { [Object, ::Java::Int] }
    # Returns the index of the first occurrence of the specified element in
    # this list, searching forwards from <tt>index</tt>, or returns -1 if
    # the element is not found.
    # More formally, returns the lowest index <tt>i</tt> such that
    # <tt>(i&nbsp;&gt;=&nbsp;index&nbsp;&amp;&amp;&nbsp;(e==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;e.equals(get(i))))</tt>,
    # or -1 if there is no such index.
    # 
    # @param e element to search for
    # @param index index to start searching from
    # @return the index of the first occurrence of the element in
    #         this list at position <tt>index</tt> or later in the list;
    #         <tt>-1</tt> if the element is not found.
    # @throws IndexOutOfBoundsException if the specified index is negative
    def index_of(e, index)
      elements = get_array
      return index_of(e, elements, index, elements.attr_length)
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    def last_index_of(o)
      elements = get_array
      return last_index_of(o, elements, elements.attr_length - 1)
    end
    
    typesig { [Object, ::Java::Int] }
    # Returns the index of the last occurrence of the specified element in
    # this list, searching backwards from <tt>index</tt>, or returns -1 if
    # the element is not found.
    # More formally, returns the highest index <tt>i</tt> such that
    # <tt>(i&nbsp;&lt;=&nbsp;index&nbsp;&amp;&amp;&nbsp;(e==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;e.equals(get(i))))</tt>,
    # or -1 if there is no such index.
    # 
    # @param e element to search for
    # @param index index to start searching backwards from
    # @return the index of the last occurrence of the element at position
    #         less than or equal to <tt>index</tt> in this list;
    #         -1 if the element is not found.
    # @throws IndexOutOfBoundsException if the specified index is greater
    #         than or equal to the current size of this list
    def last_index_of(e, index)
      elements = get_array
      return last_index_of(e, elements, index)
    end
    
    typesig { [] }
    # Returns a shallow copy of this list.  (The elements themselves
    # are not copied.)
    # 
    # @return a clone of this list
    def clone
      begin
        c = (super)
        c.reset_lock
        return c
      rescue CloneNotSupportedException => e
        # this shouldn't happen, since we are Cloneable
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this list
    # in proper sequence (from first to last element).
    # 
    # <p>The returned array will be "safe" in that no references to it are
    # maintained by this list.  (In other words, this method must allocate
    # a new array).  The caller is thus free to modify the returned array.
    # 
    # <p>This method acts as bridge between array-based and collection-based
    # APIs.
    # 
    # @return an array containing all the elements in this list
    def to_array
      elements = get_array
      return Arrays.copy_of(elements, elements.attr_length)
    end
    
    typesig { [Array.typed(Object)] }
    # Returns an array containing all of the elements in this list in
    # proper sequence (from first to last element); the runtime type of
    # the returned array is that of the specified array.  If the list fits
    # in the specified array, it is returned therein.  Otherwise, a new
    # array is allocated with the runtime type of the specified array and
    # the size of this list.
    # 
    # <p>If this list fits in the specified array with room to spare
    # (i.e., the array has more elements than this list), the element in
    # the array immediately following the end of the list is set to
    # <tt>null</tt>.  (This is useful in determining the length of this
    # list <i>only</i> if the caller knows that this list does not contain
    # any null elements.)
    # 
    # <p>Like the {@link #toArray()} method, this method acts as bridge between
    # array-based and collection-based APIs.  Further, this method allows
    # precise control over the runtime type of the output array, and may,
    # under certain circumstances, be used to save allocation costs.
    # 
    # <p>Suppose <tt>x</tt> is a list known to contain only strings.
    # The following code can be used to dump the list into a newly
    # allocated array of <tt>String</tt>:
    # 
    # <pre>
    #     String[] y = x.toArray(new String[0]);</pre>
    # 
    # Note that <tt>toArray(new Object[0])</tt> is identical in function to
    # <tt>toArray()</tt>.
    # 
    # @param a the array into which the elements of the list are to
    #          be stored, if it is big enough; otherwise, a new array of the
    #          same runtime type is allocated for this purpose.
    # @return an array containing all the elements in this list
    # @throws ArrayStoreException if the runtime type of the specified array
    #         is not a supertype of the runtime type of every element in
    #         this list
    # @throws NullPointerException if the specified array is null
    def to_array(a)
      elements = get_array
      len = elements.attr_length
      if (a.attr_length < len)
        return Arrays.copy_of(elements, len, a.get_class)
      else
        System.arraycopy(elements, 0, a, 0, len)
        if (a.attr_length > len)
          a[len] = nil
        end
        return a
      end
    end
    
    typesig { [Array.typed(Object), ::Java::Int] }
    # Positional Access Operations
    def get(a, index)
      return a[index]
    end
    
    typesig { [::Java::Int] }
    # {@inheritDoc}
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def get(index)
      return get(get_array, index)
    end
    
    typesig { [::Java::Int, Object] }
    # Replaces the element at the specified position in this list with the
    # specified element.
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def set(index, element)
      lock = @lock
      lock.lock
      begin
        elements = get_array
        old_value = get(elements, index)
        if (!(old_value).equal?(element))
          len = elements.attr_length
          new_elements = Arrays.copy_of(elements, len)
          new_elements[index] = element
          set_array(new_elements)
        else
          # Not quite a no-op; ensures volatile write semantics
          set_array(elements)
        end
        return old_value
      ensure
        lock.unlock
      end
    end
    
    typesig { [Object] }
    # Appends the specified element to the end of this list.
    # 
    # @param e element to be appended to this list
    # @return <tt>true</tt> (as specified by {@link Collection#add})
    def add(e)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        new_elements = Arrays.copy_of(elements, len + 1)
        new_elements[len] = e
        set_array(new_elements)
        return true
      ensure
        lock_.unlock
      end
    end
    
    typesig { [::Java::Int, Object] }
    # Inserts the specified element at the specified position in this
    # list. Shifts the element currently at that position (if any) and
    # any subsequent elements to the right (adds one to their indices).
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def add(index, element)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        if (index > len || index < 0)
          raise IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index) + ", Size: " + RJava.cast_to_string(len))
        end
        new_elements = nil
        num_moved = len - index
        if ((num_moved).equal?(0))
          new_elements = Arrays.copy_of(elements, len + 1)
        else
          new_elements = Array.typed(Object).new(len + 1) { nil }
          System.arraycopy(elements, 0, new_elements, 0, index)
          System.arraycopy(elements, index, new_elements, index + 1, num_moved)
        end
        new_elements[index] = element
        set_array(new_elements)
      ensure
        lock_.unlock
      end
    end
    
    typesig { [::Java::Int] }
    # Removes the element at the specified position in this list.
    # Shifts any subsequent elements to the left (subtracts one from their
    # indices).  Returns the element that was removed from the list.
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def remove(index)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        old_value = get(elements, index)
        num_moved = len - index - 1
        if ((num_moved).equal?(0))
          set_array(Arrays.copy_of(elements, len - 1))
        else
          new_elements = Array.typed(Object).new(len - 1) { nil }
          System.arraycopy(elements, 0, new_elements, 0, index)
          System.arraycopy(elements, index + 1, new_elements, index, num_moved)
          set_array(new_elements)
        end
        return old_value
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Object] }
    # Removes the first occurrence of the specified element from this list,
    # if it is present.  If this list does not contain the element, it is
    # unchanged.  More formally, removes the element with the lowest index
    # <tt>i</tt> such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>
    # (if such an element exists).  Returns <tt>true</tt> if this list
    # contained the specified element (or equivalently, if this list
    # changed as a result of the call).
    # 
    # @param o element to be removed from this list, if present
    # @return <tt>true</tt> if this list contained the specified element
    def remove(o)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        if (!(len).equal?(0))
          # Copy while searching for element to remove
          # This wins in the normal case of element being present
          newlen = len - 1
          new_elements = Array.typed(Object).new(newlen) { nil }
          i = 0
          while i < newlen
            if (eq(o, elements[i]))
              # found one;  copy remaining and exit
              k = i + 1
              while k < len
                new_elements[k - 1] = elements[k]
                (k += 1)
              end
              set_array(new_elements)
              return true
            else
              new_elements[i] = elements[i]
            end
            (i += 1)
          end
          # special handling for last cell
          if (eq(o, elements[newlen]))
            set_array(new_elements)
            return true
          end
        end
        return false
      ensure
        lock_.unlock
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes from this list all of the elements whose index is between
    # <tt>fromIndex</tt>, inclusive, and <tt>toIndex</tt>, exclusive.
    # Shifts any succeeding elements to the left (reduces their index).
    # This call shortens the list by <tt>(toIndex - fromIndex)</tt> elements.
    # (If <tt>toIndex==fromIndex</tt>, this operation has no effect.)
    # 
    # @param fromIndex index of first element to be removed
    # @param toIndex index after last element to be removed
    # @throws IndexOutOfBoundsException if fromIndex or toIndex out of range
    #         (@code{fromIndex < 0 || toIndex > size() || toIndex < fromIndex})
    def remove_range(from_index, to_index)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        if (from_index < 0 || to_index > len || to_index < from_index)
          raise IndexOutOfBoundsException.new
        end
        newlen = len - (to_index - from_index)
        num_moved = len - to_index
        if ((num_moved).equal?(0))
          set_array(Arrays.copy_of(elements, newlen))
        else
          new_elements = Array.typed(Object).new(newlen) { nil }
          System.arraycopy(elements, 0, new_elements, 0, from_index)
          System.arraycopy(elements, to_index, new_elements, from_index, num_moved)
          set_array(new_elements)
        end
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Object] }
    # Append the element if not present.
    # 
    # @param e element to be added to this list, if absent
    # @return <tt>true</tt> if the element was added
    def add_if_absent(e)
      lock_ = @lock
      lock_.lock
      begin
        # Copy while checking if already present.
        # This wins in the most common case where it is not present
        elements = get_array
        len = elements.attr_length
        new_elements = Array.typed(Object).new(len + 1) { nil }
        i = 0
        while i < len
          if (eq(e, elements[i]))
            return false # exit, throwing away copy
          else
            new_elements[i] = elements[i]
          end
          (i += 1)
        end
        new_elements[len] = e
        set_array(new_elements)
        return true
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Collection] }
    # Returns <tt>true</tt> if this list contains all of the elements of the
    # specified collection.
    # 
    # @param c collection to be checked for containment in this list
    # @return <tt>true</tt> if this list contains all of the elements of the
    #         specified collection
    # @throws NullPointerException if the specified collection is null
    # @see #contains(Object)
    def contains_all(c)
      elements = get_array
      len = elements.attr_length
      c.each do |e|
        if (index_of(e, elements, 0, len) < 0)
          return false
        end
      end
      return true
    end
    
    typesig { [Collection] }
    # Removes from this list all of its elements that are contained in
    # the specified collection. This is a particularly expensive operation
    # in this class because of the need for an internal temporary array.
    # 
    # @param c collection containing elements to be removed from this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws ClassCastException if the class of an element of this list
    #         is incompatible with the specified collection (optional)
    # @throws NullPointerException if this list contains a null element and the
    #         specified collection does not permit null elements (optional),
    #         or if the specified collection is null
    # @see #remove(Object)
    def remove_all(c)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        if (!(len).equal?(0))
          # temp array holds those elements we know we want to keep
          newlen = 0
          temp = Array.typed(Object).new(len) { nil }
          i = 0
          while i < len
            element = elements[i]
            if (!c.contains(element))
              temp[((newlen += 1) - 1)] = element
            end
            (i += 1)
          end
          if (!(newlen).equal?(len))
            set_array(Arrays.copy_of(temp, newlen))
            return true
          end
        end
        return false
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Collection] }
    # Retains only the elements in this list that are contained in the
    # specified collection.  In other words, removes from this list all of
    # its elements that are not contained in the specified collection.
    # 
    # @param c collection containing elements to be retained in this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws ClassCastException if the class of an element of this list
    #         is incompatible with the specified collection (optional)
    # @throws NullPointerException if this list contains a null element and the
    #         specified collection does not permit null elements (optional),
    #         or if the specified collection is null
    # @see #remove(Object)
    def retain_all(c)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        if (!(len).equal?(0))
          # temp array holds those elements we know we want to keep
          newlen = 0
          temp = Array.typed(Object).new(len) { nil }
          i = 0
          while i < len
            element = elements[i]
            if (c.contains(element))
              temp[((newlen += 1) - 1)] = element
            end
            (i += 1)
          end
          if (!(newlen).equal?(len))
            set_array(Arrays.copy_of(temp, newlen))
            return true
          end
        end
        return false
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Collection] }
    # Appends all of the elements in the specified collection that
    # are not already contained in this list, to the end of
    # this list, in the order that they are returned by the
    # specified collection's iterator.
    # 
    # @param c collection containing elements to be added to this list
    # @return the number of elements added
    # @throws NullPointerException if the specified collection is null
    # @see #addIfAbsent(Object)
    def add_all_absent(c)
      cs = c.to_array
      if ((cs.attr_length).equal?(0))
        return 0
      end
      uniq = Array.typed(Object).new(cs.attr_length) { nil }
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        added = 0
        i = 0
        while i < cs.attr_length
          # scan for duplicates
          e = cs[i]
          if (index_of(e, elements, 0, len) < 0 && index_of(e, uniq, 0, added) < 0)
            uniq[((added += 1) - 1)] = e
          end
          (i += 1)
        end
        if (added > 0)
          new_elements = Arrays.copy_of(elements, len + added)
          System.arraycopy(uniq, 0, new_elements, len, added)
          set_array(new_elements)
        end
        return added
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Removes all of the elements from this list.
    # The list will be empty after this call returns.
    def clear
      lock_ = @lock
      lock_.lock
      begin
        set_array(Array.typed(Object).new(0) { nil })
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Collection] }
    # Appends all of the elements in the specified collection to the end
    # of this list, in the order that they are returned by the specified
    # collection's iterator.
    # 
    # @param c collection containing elements to be added to this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    # @see #add(Object)
    def add_all(c)
      cs = c.to_array
      if ((cs.attr_length).equal?(0))
        return false
      end
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        new_elements = Arrays.copy_of(elements, len + cs.attr_length)
        System.arraycopy(cs, 0, new_elements, len, cs.attr_length)
        set_array(new_elements)
        return true
      ensure
        lock_.unlock
      end
    end
    
    typesig { [::Java::Int, Collection] }
    # Inserts all of the elements in the specified collection into this
    # list, starting at the specified position.  Shifts the element
    # currently at that position (if any) and any subsequent elements to
    # the right (increases their indices).  The new elements will appear
    # in this list in the order that they are returned by the
    # specified collection's iterator.
    # 
    # @param index index at which to insert the first element
    #        from the specified collection
    # @param c collection containing elements to be added to this list
    # @return <tt>true</tt> if this list changed as a result of the call
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @throws NullPointerException if the specified collection is null
    # @see #add(int,Object)
    def add_all(index, c)
      cs = c.to_array
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        if (index > len || index < 0)
          raise IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index) + ", Size: " + RJava.cast_to_string(len))
        end
        if ((cs.attr_length).equal?(0))
          return false
        end
        num_moved = len - index
        new_elements = nil
        if ((num_moved).equal?(0))
          new_elements = Arrays.copy_of(elements, len + cs.attr_length)
        else
          new_elements = Array.typed(Object).new(len + cs.attr_length) { nil }
          System.arraycopy(elements, 0, new_elements, 0, index)
          System.arraycopy(elements, index, new_elements, index + cs.attr_length, num_moved)
        end
        System.arraycopy(cs, 0, new_elements, index, cs.attr_length)
        set_array(new_elements)
        return true
      ensure
        lock_.unlock
      end
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the list to a stream (i.e., serialize it).
    # 
    # @serialData The length of the array backing the list is emitted
    #               (int), followed by all of its elements (each an Object)
    #               in the proper order.
    # @param s the stream
    def write_object(s)
      # Write out element count, and any hidden stuff
      s.default_write_object
      elements = get_array
      len = elements.attr_length
      # Write out array length
      s.write_int(len)
      # Write out all elements in the proper order.
      i = 0
      while i < len
        s.write_object(elements[i])
        i += 1
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the list from a stream (i.e., deserialize it).
    # @param s the stream
    def read_object(s)
      # Read in size, and any hidden stuff
      s.default_read_object
      # bind to new lock
      reset_lock
      # Read in array length and allocate array
      len = s.read_int
      elements = Array.typed(Object).new(len) { nil }
      # Read in all elements in the proper order.
      i = 0
      while i < len
        elements[i] = s.read_object
        i += 1
      end
      set_array(elements)
    end
    
    typesig { [] }
    # Returns a string representation of this list.  The string
    # representation consists of the string representations of the list's
    # elements in the order they are returned by its iterator, enclosed in
    # square brackets (<tt>"[]"</tt>).  Adjacent elements are separated by
    # the characters <tt>", "</tt> (comma and space).  Elements are
    # converted to strings as by {@link String#valueOf(Object)}.
    # 
    # @return a string representation of this list
    def to_s
      return Arrays.to_s(get_array)
    end
    
    typesig { [Object] }
    # Compares the specified object with this list for equality.
    # Returns {@code true} if the specified object is the same object
    # as this object, or if it is also a {@link List} and the sequence
    # of elements returned by an {@linkplain List#iterator() iterator}
    # over the specified list is the same as the sequence returned by
    # an iterator over this list.  The two sequences are considered to
    # be the same if they have the same length and corresponding
    # elements at the same position in the sequence are <em>equal</em>.
    # Two elements {@code e1} and {@code e2} are considered
    # <em>equal</em> if {@code (e1==null ? e2==null : e1.equals(e2))}.
    # 
    # @param o the object to be compared for equality with this list
    # @return {@code true} if the specified object is equal to this list
    def ==(o)
      if ((o).equal?(self))
        return true
      end
      if (!(o.is_a?(JavaList)))
        return false
      end
      list = (o)
      it = list.iterator
      elements = get_array
      len = elements.attr_length
      i = 0
      while i < len
        if (!it.has_next || !eq(elements[i], it.next_))
          return false
        end
        (i += 1)
      end
      if (it.has_next)
        return false
      end
      return true
    end
    
    typesig { [] }
    # Returns the hash code value for this list.
    # 
    # <p>This implementation uses the definition in {@link List#hashCode}.
    # 
    # @return the hash code value for this list
    def hash_code
      hash_code = 1
      elements = get_array
      len = elements.attr_length
      i = 0
      while i < len
        obj = elements[i]
        hash_code = 31 * hash_code + ((obj).nil? ? 0 : obj.hash_code)
        (i += 1)
      end
      return hash_code
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this list in proper sequence.
    # 
    # <p>The returned iterator provides a snapshot of the state of the list
    # when the iterator was constructed. No synchronization is needed while
    # traversing the iterator. The iterator does <em>NOT</em> support the
    # <tt>remove</tt> method.
    # 
    # @return an iterator over the elements in this list in proper sequence
    def iterator
      return COWIterator.new(get_array, 0)
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>The returned iterator provides a snapshot of the state of the list
    # when the iterator was constructed. No synchronization is needed while
    # traversing the iterator. The iterator does <em>NOT</em> support the
    # <tt>remove</tt>, <tt>set</tt> or <tt>add</tt> methods.
    def list_iterator
      return COWIterator.new(get_array, 0)
    end
    
    typesig { [::Java::Int] }
    # {@inheritDoc}
    # 
    # <p>The returned iterator provides a snapshot of the state of the list
    # when the iterator was constructed. No synchronization is needed while
    # traversing the iterator. The iterator does <em>NOT</em> support the
    # <tt>remove</tt>, <tt>set</tt> or <tt>add</tt> methods.
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def list_iterator(index)
      elements = get_array
      len = elements.attr_length
      if (index < 0 || index > len)
        raise IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index))
      end
      return COWIterator.new(elements, index)
    end
    
    class_module.module_eval {
      const_set_lazy(:COWIterator) { Class.new do
        include_class_members CopyOnWriteArrayList
        include ListIterator
        
        # Snapshot of the array *
        attr_accessor :snapshot
        alias_method :attr_snapshot, :snapshot
        undef_method :snapshot
        alias_method :attr_snapshot=, :snapshot=
        undef_method :snapshot=
        
        # Index of element to be returned by subsequent call to next.
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        typesig { [Array.typed(Object), ::Java::Int] }
        def initialize(elements, initial_cursor)
          @snapshot = nil
          @cursor = 0
          @cursor = initial_cursor
          @snapshot = elements
        end
        
        typesig { [] }
        def has_next
          return @cursor < @snapshot.attr_length
        end
        
        typesig { [] }
        def has_previous
          return @cursor > 0
        end
        
        typesig { [] }
        def next_
          if (!has_next)
            raise self.class::NoSuchElementException.new
          end
          return @snapshot[((@cursor += 1) - 1)]
        end
        
        typesig { [] }
        def previous
          if (!has_previous)
            raise self.class::NoSuchElementException.new
          end
          return @snapshot[(@cursor -= 1)]
        end
        
        typesig { [] }
        def next_index
          return @cursor
        end
        
        typesig { [] }
        def previous_index
          return @cursor - 1
        end
        
        typesig { [] }
        # Not supported. Always throws UnsupportedOperationException.
        # @throws UnsupportedOperationException always; <tt>remove</tt>
        #         is not supported by this iterator.
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        # Not supported. Always throws UnsupportedOperationException.
        # @throws UnsupportedOperationException always; <tt>set</tt>
        #         is not supported by this iterator.
        def set(e)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        # Not supported. Always throws UnsupportedOperationException.
        # @throws UnsupportedOperationException always; <tt>add</tt>
        #         is not supported by this iterator.
        def add(e)
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__cowiterator, :initialize
      end }
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns a view of the portion of this list between
    # <tt>fromIndex</tt>, inclusive, and <tt>toIndex</tt>, exclusive.
    # The returned list is backed by this list, so changes in the
    # returned list are reflected in this list, and vice-versa.
    # While mutative operations are supported, they are probably not
    # very useful for CopyOnWriteArrayLists.
    # 
    # <p>The semantics of the list returned by this method become
    # undefined if the backing list (i.e., this list) is
    # <i>structurally modified</i> in any way other than via the
    # returned list.  (Structural modifications are those that change
    # the size of the list, or otherwise perturb it in such a fashion
    # that iterations in progress may yield incorrect results.)
    # 
    # @param fromIndex low endpoint (inclusive) of the subList
    # @param toIndex high endpoint (exclusive) of the subList
    # @return a view of the specified range within this list
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def sub_list(from_index, to_index)
      lock_ = @lock
      lock_.lock
      begin
        elements = get_array
        len = elements.attr_length
        if (from_index < 0 || to_index > len || from_index > to_index)
          raise IndexOutOfBoundsException.new
        end
        return COWSubList.new(self, from_index, to_index)
      ensure
        lock_.unlock
      end
    end
    
    class_module.module_eval {
      # Sublist for CopyOnWriteArrayList.
      # This class extends AbstractList merely for convenience, to
      # avoid having to define addAll, etc. This doesn't hurt, but
      # is wasteful.  This class does not need or use modCount
      # mechanics in AbstractList, but does need to check for
      # concurrent modification using similar mechanics.  On each
      # operation, the array that we expect the backing list to use
      # is checked and updated.  Since we do this for all of the
      # base operations invoked by those defined in AbstractList,
      # all is well.  While inefficient, this is not worth
      # improving.  The kinds of list operations inherited from
      # AbstractList are already so slow on COW sublists that
      # adding a bit more space/time doesn't seem even noticeable.
      const_set_lazy(:COWSubList) { Class.new(AbstractList) do
        include_class_members CopyOnWriteArrayList
        overload_protected {
          include RandomAccess
        }
        
        attr_accessor :l
        alias_method :attr_l, :l
        undef_method :l
        alias_method :attr_l=, :l=
        undef_method :l=
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        attr_accessor :expected_array
        alias_method :attr_expected_array, :expected_array
        undef_method :expected_array
        alias_method :attr_expected_array=, :expected_array=
        undef_method :expected_array=
        
        typesig { [class_self::CopyOnWriteArrayList, ::Java::Int, ::Java::Int] }
        # only call this holding l's lock
        def initialize(list, from_index, to_index)
          @l = nil
          @offset = 0
          @size = 0
          @expected_array = nil
          super()
          @l = list
          @expected_array = @l.get_array
          @offset = from_index
          @size = to_index - from_index
        end
        
        typesig { [] }
        # only call this holding l's lock
        def check_for_comodification
          if (!(@l.get_array).equal?(@expected_array))
            raise self.class::ConcurrentModificationException.new
          end
        end
        
        typesig { [::Java::Int] }
        # only call this holding l's lock
        def range_check(index)
          if (index < 0 || index >= @size)
            raise self.class::IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index) + ",Size: " + RJava.cast_to_string(@size))
          end
        end
        
        typesig { [::Java::Int, Object] }
        def set(index, element)
          lock = @l.attr_lock
          lock.lock
          begin
            range_check(index)
            check_for_comodification
            x = @l.set(index + @offset, element)
            @expected_array = @l.get_array
            return x
          ensure
            lock.unlock
          end
        end
        
        typesig { [::Java::Int] }
        def get(index)
          lock_ = @l.attr_lock
          lock_.lock
          begin
            range_check(index)
            check_for_comodification
            return @l.get(index + @offset)
          ensure
            lock_.unlock
          end
        end
        
        typesig { [] }
        def size
          lock_ = @l.attr_lock
          lock_.lock
          begin
            check_for_comodification
            return @size
          ensure
            lock_.unlock
          end
        end
        
        typesig { [::Java::Int, Object] }
        def add(index, element)
          lock_ = @l.attr_lock
          lock_.lock
          begin
            check_for_comodification
            if (index < 0 || index > @size)
              raise self.class::IndexOutOfBoundsException.new
            end
            @l.add(index + @offset, element)
            @expected_array = @l.get_array
            @size += 1
          ensure
            lock_.unlock
          end
        end
        
        typesig { [] }
        def clear
          lock_ = @l.attr_lock
          lock_.lock
          begin
            check_for_comodification
            @l.remove_range(@offset, @offset + @size)
            @expected_array = @l.get_array
            @size = 0
          ensure
            lock_.unlock
          end
        end
        
        typesig { [::Java::Int] }
        def remove(index)
          lock_ = @l.attr_lock
          lock_.lock
          begin
            range_check(index)
            check_for_comodification
            result = @l.remove(index + @offset)
            @expected_array = @l.get_array
            @size -= 1
            return result
          ensure
            lock_.unlock
          end
        end
        
        typesig { [Object] }
        def remove(o)
          index = index_of(o)
          if ((index).equal?(-1))
            return false
          end
          remove(index)
          return true
        end
        
        typesig { [] }
        def iterator
          lock_ = @l.attr_lock
          lock_.lock
          begin
            check_for_comodification
            return self.class::COWSubListIterator.new(@l, 0, @offset, @size)
          ensure
            lock_.unlock
          end
        end
        
        typesig { [::Java::Int] }
        def list_iterator(index)
          lock_ = @l.attr_lock
          lock_.lock
          begin
            check_for_comodification
            if (index < 0 || index > @size)
              raise self.class::IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index) + ", Size: " + RJava.cast_to_string(@size))
            end
            return self.class::COWSubListIterator.new(@l, index, @offset, @size)
          ensure
            lock_.unlock
          end
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def sub_list(from_index, to_index)
          lock_ = @l.attr_lock
          lock_.lock
          begin
            check_for_comodification
            if (from_index < 0 || to_index > @size)
              raise self.class::IndexOutOfBoundsException.new
            end
            return self.class::COWSubList.new(@l, from_index + @offset, to_index + @offset)
          ensure
            lock_.unlock
          end
        end
        
        private
        alias_method :initialize__cowsub_list, :initialize
      end }
      
      const_set_lazy(:COWSubListIterator) { Class.new do
        include_class_members CopyOnWriteArrayList
        include ListIterator
        
        attr_accessor :i
        alias_method :attr_i, :i
        undef_method :i
        alias_method :attr_i=, :i=
        undef_method :i=
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        typesig { [class_self::JavaList, ::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(l, index, offset, size)
          @i = nil
          @index = 0
          @offset = 0
          @size = 0
          @index = index
          @offset = offset
          @size = size
          @i = l.list_iterator(index + offset)
        end
        
        typesig { [] }
        def has_next
          return next_index < @size
        end
        
        typesig { [] }
        def next_
          if (has_next)
            return @i.next_
          else
            raise self.class::NoSuchElementException.new
          end
        end
        
        typesig { [] }
        def has_previous
          return previous_index >= 0
        end
        
        typesig { [] }
        def previous
          if (has_previous)
            return @i.previous
          else
            raise self.class::NoSuchElementException.new
          end
        end
        
        typesig { [] }
        def next_index
          return @i.next_index - @offset
        end
        
        typesig { [] }
        def previous_index
          return @i.previous_index - @offset
        end
        
        typesig { [] }
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        def set(e)
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        def add(e)
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__cowsub_list_iterator, :initialize
      end }
      
      # Support for resetting lock while deserializing
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :LockOffset, UnsafeInstance.object_field_offset(CopyOnWriteArrayList.get_declared_field("lock"))
        rescue JavaException => ex
          raise JavaError.new(ex)
        end
      end
    }
    
    typesig { [] }
    def reset_lock
      UnsafeInstance.put_object_volatile(self, LockOffset, ReentrantLock.new)
    end
    
    private
    alias_method :initialize__copy_on_write_array_list, :initialize
  end
  
end
