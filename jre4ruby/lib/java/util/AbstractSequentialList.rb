require "rjava"

# 
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
  module AbstractSequentialListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # 
  # This class provides a skeletal implementation of the <tt>List</tt>
  # interface to minimize the effort required to implement this interface
  # backed by a "sequential access" data store (such as a linked list).  For
  # random access data (such as an array), <tt>AbstractList</tt> should be used
  # in preference to this class.<p>
  # 
  # This class is the opposite of the <tt>AbstractList</tt> class in the sense
  # that it implements the "random access" methods (<tt>get(int index)</tt>,
  # <tt>set(int index, E element)</tt>, <tt>add(int index, E element)</tt> and
  # <tt>remove(int index)</tt>) on top of the list's list iterator, instead of
  # the other way around.<p>
  # 
  # To implement a list the programmer needs only to extend this class and
  # provide implementations for the <tt>listIterator</tt> and <tt>size</tt>
  # methods.  For an unmodifiable list, the programmer need only implement the
  # list iterator's <tt>hasNext</tt>, <tt>next</tt>, <tt>hasPrevious</tt>,
  # <tt>previous</tt> and <tt>index</tt> methods.<p>
  # 
  # For a modifiable list the programmer should additionally implement the list
  # iterator's <tt>set</tt> method.  For a variable-size list the programmer
  # should additionally implement the list iterator's <tt>remove</tt> and
  # <tt>add</tt> methods.<p>
  # 
  # The programmer should generally provide a void (no argument) and collection
  # constructor, as per the recommendation in the <tt>Collection</tt> interface
  # specification.<p>
  # 
  # This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see Collection
  # @see List
  # @see AbstractList
  # @see AbstractCollection
  # @since 1.2
  class AbstractSequentialList < AbstractSequentialListImports.const_get :AbstractList
    include_class_members AbstractSequentialListImports
    
    typesig { [] }
    # 
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      super()
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the element at the specified position in this list.
    # 
    # <p>This implementation first gets a list iterator pointing to the
    # indexed element (with <tt>listIterator(index)</tt>).  Then, it gets
    # the element using <tt>ListIterator.next</tt> and returns it.
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def get(index)
      begin
        return list_iterator(index).next
      rescue NoSuchElementException => exc
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s)
      end
    end
    
    typesig { [::Java::Int, Object] }
    # 
    # Replaces the element at the specified position in this list with the
    # specified element (optional operation).
    # 
    # <p>This implementation first gets a list iterator pointing to the
    # indexed element (with <tt>listIterator(index)</tt>).  Then, it gets
    # the current element using <tt>ListIterator.next</tt> and replaces it
    # with <tt>ListIterator.set</tt>.
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> if the list iterator does not
    # implement the <tt>set</tt> operation.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def set(index, element)
      begin
        e = list_iterator(index)
        old_val = e.next
        e.set(element)
        return old_val
      rescue NoSuchElementException => exc
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s)
      end
    end
    
    typesig { [::Java::Int, Object] }
    # 
    # Inserts the specified element at the specified position in this list
    # (optional operation).  Shifts the element currently at that position
    # (if any) and any subsequent elements to the right (adds one to their
    # indices).
    # 
    # <p>This implementation first gets a list iterator pointing to the
    # indexed element (with <tt>listIterator(index)</tt>).  Then, it
    # inserts the specified element with <tt>ListIterator.add</tt>.
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> if the list iterator does not
    # implement the <tt>add</tt> operation.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def add(index, element)
      begin
        list_iterator(index).add(element)
      rescue NoSuchElementException => exc
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s)
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Removes the element at the specified position in this list (optional
    # operation).  Shifts any subsequent elements to the left (subtracts one
    # from their indices).  Returns the element that was removed from the
    # list.
    # 
    # <p>This implementation first gets a list iterator pointing to the
    # indexed element (with <tt>listIterator(index)</tt>).  Then, it removes
    # the element with <tt>ListIterator.remove</tt>.
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> if the list iterator does not
    # implement the <tt>remove</tt> operation.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def remove(index)
      begin
        e = list_iterator(index)
        out_cast = e.next
        e.remove
        return out_cast
      rescue NoSuchElementException => exc
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s)
      end
    end
    
    typesig { [::Java::Int, Collection] }
    # Bulk Operations
    # 
    # Inserts all of the elements in the specified collection into this
    # list at the specified position (optional operation).  Shifts the
    # element currently at that position (if any) and any subsequent
    # elements to the right (increases their indices).  The new elements
    # will appear in this list in the order that they are returned by the
    # specified collection's iterator.  The behavior of this operation is
    # undefined if the specified collection is modified while the
    # operation is in progress.  (Note that this will occur if the specified
    # collection is this list, and it's nonempty.)
    # 
    # <p>This implementation gets an iterator over the specified collection and
    # a list iterator over this list pointing to the indexed element (with
    # <tt>listIterator(index)</tt>).  Then, it iterates over the specified
    # collection, inserting the elements obtained from the iterator into this
    # list, one at a time, using <tt>ListIterator.add</tt> followed by
    # <tt>ListIterator.next</tt> (to skip over the added element).
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> if the list iterator returned by
    # the <tt>listIterator</tt> method does not implement the <tt>add</tt>
    # operation.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    # @throws IndexOutOfBoundsException     {@inheritDoc}
    def add_all(index, c)
      begin
        modified = false
        e1 = list_iterator(index)
        e2 = c.iterator
        while (e2.has_next)
          e1.add(e2.next)
          modified = true
        end
        return modified
      rescue NoSuchElementException => exc
        raise IndexOutOfBoundsException.new("Index: " + (index).to_s)
      end
    end
    
    typesig { [] }
    # Iterators
    # 
    # Returns an iterator over the elements in this list (in proper
    # sequence).<p>
    # 
    # This implementation merely returns a list iterator over the list.
    # 
    # @return an iterator over the elements in this list (in proper sequence)
    def iterator
      return list_iterator
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns a list iterator over the elements in this list (in proper
    # sequence).
    # 
    # @param  index index of first element to be returned from the list
    # iterator (by a call to the <code>next</code> method)
    # @return a list iterator over the elements in this list (in proper
    # sequence)
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def list_iterator(index)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__abstract_sequential_list, :initialize
  end
  
end
