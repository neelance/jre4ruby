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
  module AbstractCollectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # This class provides a skeletal implementation of the <tt>Collection</tt>
  # interface, to minimize the effort required to implement this interface. <p>
  # 
  # To implement an unmodifiable collection, the programmer needs only to
  # extend this class and provide implementations for the <tt>iterator</tt> and
  # <tt>size</tt> methods.  (The iterator returned by the <tt>iterator</tt>
  # method must implement <tt>hasNext</tt> and <tt>next</tt>.)<p>
  # 
  # To implement a modifiable collection, the programmer must additionally
  # override this class's <tt>add</tt> method (which otherwise throws an
  # <tt>UnsupportedOperationException</tt>), and the iterator returned by the
  # <tt>iterator</tt> method must additionally implement its <tt>remove</tt>
  # method.<p>
  # 
  # The programmer should generally provide a void (no argument) and
  # <tt>Collection</tt> constructor, as per the recommendation in the
  # <tt>Collection</tt> interface specification.<p>
  # 
  # The documentation for each non-abstract method in this class describes its
  # implementation in detail.  Each of these methods may be overridden if
  # the collection being implemented admits a more efficient implementation.<p>
  # 
  # This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see Collection
  # @since 1.2
  class AbstractCollection 
    include_class_members AbstractCollectionImports
    include Collection
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
    end
    
    typesig { [] }
    # Query Operations
    # 
    # Returns an iterator over the elements contained in this collection.
    # 
    # @return an iterator over the elements contained in this collection
    def iterator
      raise NotImplementedError
    end
    
    typesig { [] }
    def size
      raise NotImplementedError
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
    # <p>This implementation iterates over the elements in the collection,
    # checking each element in turn for equality with the specified element.
    # 
    # @throws ClassCastException   {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def contains(o)
      e = iterator
      if ((o).nil?)
        while (e.has_next)
          if ((e.next).nil?)
            return true
          end
        end
      else
        while (e.has_next)
          if ((o == e.next))
            return true
          end
        end
      end
      return false
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns an array containing all the elements
    # returned by this collection's iterator, in the same order, stored in
    # consecutive elements of the array, starting with index {@code 0}.
    # The length of the returned array is equal to the number of elements
    # returned by the iterator, even if the size of this collection changes
    # during iteration, as might happen if the collection permits
    # concurrent modification during iteration.  The {@code size} method is
    # called only as an optimization hint; the correct result is returned
    # even if the iterator returns a different number of elements.
    # 
    # <p>This method is equivalent to:
    # 
    # <pre> {@code
    # List<E> list = new ArrayList<E>(size());
    # for (E e : this)
    # list.add(e);
    # return list.toArray();
    # }</pre>
    def to_array
      # Estimate size of array; be prepared to see more or fewer elements
      r = Array.typed(Object).new(size) { nil }
      it = iterator
      i = 0
      while i < r.attr_length
        if (!it.has_next)
          # fewer elements than expected
          return Arrays.copy_of(r, i)
        end
        r[i] = it.next
        ((i += 1) - 1)
      end
      return it.has_next ? finish_to_array(r, it) : r
    end
    
    typesig { [Array.typed(T)] }
    # {@inheritDoc}
    # 
    # <p>This implementation returns an array containing all the elements
    # returned by this collection's iterator in the same order, stored in
    # consecutive elements of the array, starting with index {@code 0}.
    # If the number of elements returned by the iterator is too large to
    # fit into the specified array, then the elements are returned in a
    # newly allocated array with length equal to the number of elements
    # returned by the iterator, even if the size of this collection
    # changes during iteration, as might happen if the collection permits
    # concurrent modification during iteration.  The {@code size} method is
    # called only as an optimization hint; the correct result is returned
    # even if the iterator returns a different number of elements.
    # 
    # <p>This method is equivalent to:
    # 
    # <pre> {@code
    # List<E> list = new ArrayList<E>(size());
    # for (E e : this)
    # list.add(e);
    # return list.toArray(a);
    # }</pre>
    # 
    # @throws ArrayStoreException  {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def to_array(a)
      # Estimate size of array; be prepared to see more or fewer elements
      size_ = size
      r = a.attr_length >= size_ ? a : Java::Lang::Reflect::Array.new_instance(a.get_class.get_component_type, size_)
      it = iterator
      i = 0
      while i < r.attr_length
        if (!it.has_next)
          # fewer elements than expected
          if (!(a).equal?(r))
            return Arrays.copy_of(r, i)
          end
          r[i] = nil # null-terminate
          return r
        end
        r[i] = it.next
        ((i += 1) - 1)
      end
      return it.has_next ? finish_to_array(r, it) : r
    end
    
    class_module.module_eval {
      typesig { [Array.typed(T), Iterator] }
      # Reallocates the array being used within toArray when the iterator
      # returned more elements than expected, and finishes filling it from
      # the iterator.
      # 
      # @param r the array, replete with previously stored elements
      # @param it the in-progress iterator over this collection
      # @return array containing the elements in the given array, plus any
      # further elements returned by the iterator, trimmed to size
      def finish_to_array(r, it)
        i = r.attr_length
        while (it.has_next)
          cap = r.attr_length
          if ((i).equal?(cap))
            new_cap = ((cap / 2) + 1) * 3
            if (new_cap <= cap)
              # integer overflow
              if ((cap).equal?(JavaInteger::MAX_VALUE))
                raise OutOfMemoryError.new("Required array size too large")
              end
              new_cap = JavaInteger::MAX_VALUE
            end
            r = Arrays.copy_of(r, new_cap)
          end
          r[((i += 1) - 1)] = it.next
        end
        # trim if overallocated
        return ((i).equal?(r.attr_length)) ? r : Arrays.copy_of(r, i)
      end
    }
    
    typesig { [Object] }
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
    # @throws IllegalStateException         {@inheritDoc}
    def add(e)
      raise UnsupportedOperationException.new
    end
    
    typesig { [Object] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over the collection looking for the
    # specified element.  If it finds the element, it removes the element
    # from the collection using the iterator's remove method.
    # 
    # <p>Note that this implementation throws an
    # <tt>UnsupportedOperationException</tt> if the iterator returned by this
    # collection's iterator method does not implement the <tt>remove</tt>
    # method and this collection contains the specified object.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    def remove(o)
      e = iterator
      if ((o).nil?)
        while (e.has_next)
          if ((e.next).nil?)
            e.remove
            return true
          end
        end
      else
        while (e.has_next)
          if ((o == e.next))
            e.remove
            return true
          end
        end
      end
      return false
    end
    
    typesig { [Collection] }
    # Bulk Operations
    # 
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over the specified collection,
    # checking each element returned by the iterator in turn to see
    # if it's contained in this collection.  If all elements are so
    # contained <tt>true</tt> is returned, otherwise <tt>false</tt>.
    # 
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @see #contains(Object)
    def contains_all(c)
      e = c.iterator
      while (e.has_next)
        if (!contains(e.next))
          return false
        end
      end
      return true
    end
    
    typesig { [Collection] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over the specified collection, and adds
    # each object returned by the iterator to this collection, in turn.
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> unless <tt>add</tt> is
    # overridden (assuming the specified collection is non-empty).
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    # @throws IllegalStateException         {@inheritDoc}
    # 
    # @see #add(Object)
    def add_all(c)
      modified = false
      e = c.iterator
      while (e.has_next)
        if (add(e.next))
          modified = true
        end
      end
      return modified
    end
    
    typesig { [Collection] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over this collection, checking each
    # element returned by the iterator in turn to see if it's contained
    # in the specified collection.  If it's so contained, it's removed from
    # this collection with the iterator's <tt>remove</tt> method.
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> if the iterator returned by the
    # <tt>iterator</tt> method does not implement the <tt>remove</tt> method
    # and this collection contains one or more elements in common with the
    # specified collection.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # 
    # @see #remove(Object)
    # @see #contains(Object)
    def remove_all(c)
      modified = false
      e = iterator
      while (e.has_next)
        if (c.contains(e.next))
          e.remove
          modified = true
        end
      end
      return modified
    end
    
    typesig { [Collection] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over this collection, checking each
    # element returned by the iterator in turn to see if it's contained
    # in the specified collection.  If it's not so contained, it's removed
    # from this collection with the iterator's <tt>remove</tt> method.
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> if the iterator returned by the
    # <tt>iterator</tt> method does not implement the <tt>remove</tt> method
    # and this collection contains one or more elements not present in the
    # specified collection.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # 
    # @see #remove(Object)
    # @see #contains(Object)
    def retain_all(c)
      modified = false
      e = iterator
      while (e.has_next)
        if (!c.contains(e.next))
          e.remove
          modified = true
        end
      end
      return modified
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # <p>This implementation iterates over this collection, removing each
    # element using the <tt>Iterator.remove</tt> operation.  Most
    # implementations will probably choose to override this method for
    # efficiency.
    # 
    # <p>Note that this implementation will throw an
    # <tt>UnsupportedOperationException</tt> if the iterator returned by this
    # collection's <tt>iterator</tt> method does not implement the
    # <tt>remove</tt> method and this collection is non-empty.
    # 
    # @throws UnsupportedOperationException {@inheritDoc}
    def clear
      e = iterator
      while (e.has_next)
        e.next
        e.remove
      end
    end
    
    typesig { [] }
    # String conversion
    # 
    # Returns a string representation of this collection.  The string
    # representation consists of a list of the collection's elements in the
    # order they are returned by its iterator, enclosed in square brackets
    # (<tt>"[]"</tt>).  Adjacent elements are separated by the characters
    # <tt>", "</tt> (comma and space).  Elements are converted to strings as
    # by {@link String#valueOf(Object)}.
    # 
    # @return a string representation of this collection
    def to_s
      i = iterator
      if (!i.has_next)
        return "[]"
      end
      sb = StringBuilder.new
      sb.append(Character.new(?[.ord))
      loop do
        e = i.next
        sb.append((e).equal?(self) ? "(this Collection)" : e)
        if (!i.has_next)
          return sb.append(Character.new(?].ord)).to_s
        end
        sb.append(", ")
      end
    end
    
    private
    alias_method :initialize__abstract_collection, :initialize
  end
  
end
