require "rjava"

# Copyright 1994-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module VectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # The {@code Vector} class implements a growable array of
  # objects. Like an array, it contains components that can be
  # accessed using an integer index. However, the size of a
  # {@code Vector} can grow or shrink as needed to accommodate
  # adding and removing items after the {@code Vector} has been created.
  # 
  # <p>Each vector tries to optimize storage management by maintaining a
  # {@code capacity} and a {@code capacityIncrement}. The
  # {@code capacity} is always at least as large as the vector
  # size; it is usually larger because as components are added to the
  # vector, the vector's storage increases in chunks the size of
  # {@code capacityIncrement}. An application can increase the
  # capacity of a vector before inserting a large number of
  # components; this reduces the amount of incremental reallocation.
  # 
  # <p><a name="fail-fast"/>
  # The iterators returned by this class's {@link #iterator() iterator} and
  # {@link #listIterator(int) listIterator} methods are <em>fail-fast</em>:
  # if the vector is structurally modified at any time after the iterator is
  # created, in any way except through the iterator's own
  # {@link ListIterator#remove() remove} or
  # {@link ListIterator#add(Object) add} methods, the iterator will throw a
  # {@link ConcurrentModificationException}.  Thus, in the face of
  # concurrent modification, the iterator fails quickly and cleanly, rather
  # than risking arbitrary, non-deterministic behavior at an undetermined
  # time in the future.  The {@link Enumeration Enumerations} returned by
  # the {@link #elements() elements} method are <em>not</em> fail-fast.
  # 
  # <p>Note that the fail-fast behavior of an iterator cannot be guaranteed
  # as it is, generally speaking, impossible to make any hard guarantees in the
  # presence of unsynchronized concurrent modification.  Fail-fast iterators
  # throw {@code ConcurrentModificationException} on a best-effort basis.
  # Therefore, it would be wrong to write a program that depended on this
  # exception for its correctness:  <i>the fail-fast behavior of iterators
  # should be used only to detect bugs.</i>
  # 
  # <p>As of the Java 2 platform v1.2, this class was retrofitted to
  # implement the {@link List} interface, making it a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html"> Java
  # Collections Framework</a>.  Unlike the new collection
  # implementations, {@code Vector} is synchronized.
  # 
  # @author  Lee Boynton
  # @author  Jonathan Payne
  # @see Collection
  # @see List
  # @see ArrayList
  # @see LinkedList
  # @since   JDK1.0
  class Vector < VectorImports.const_get :AbstractList
    include_class_members VectorImports
    overload_protected {
      include JavaList
      include RandomAccess
      include Cloneable
      include Java::Io::Serializable
    }
    
    # The array buffer into which the components of the vector are
    # stored. The capacity of the vector is the length of this array buffer,
    # and is at least large enough to contain all the vector's elements.
    # 
    # <p>Any array elements following the last element in the Vector are null.
    # 
    # @serial
    attr_accessor :element_data
    alias_method :attr_element_data, :element_data
    undef_method :element_data
    alias_method :attr_element_data=, :element_data=
    undef_method :element_data=
    
    # The number of valid components in this {@code Vector} object.
    # Components {@code elementData[0]} through
    # {@code elementData[elementCount-1]} are the actual items.
    # 
    # @serial
    attr_accessor :element_count
    alias_method :attr_element_count, :element_count
    undef_method :element_count
    alias_method :attr_element_count=, :element_count=
    undef_method :element_count=
    
    # The amount by which the capacity of the vector is automatically
    # incremented when its size becomes greater than its capacity.  If
    # the capacity increment is less than or equal to zero, the capacity
    # of the vector is doubled each time it needs to grow.
    # 
    # @serial
    attr_accessor :capacity_increment
    alias_method :attr_capacity_increment, :capacity_increment
    undef_method :capacity_increment
    alias_method :attr_capacity_increment=, :capacity_increment=
    undef_method :capacity_increment=
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { -2767605614048989439 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Constructs an empty vector with the specified initial capacity and
    # capacity increment.
    # 
    # @param   initialCapacity     the initial capacity of the vector
    # @param   capacityIncrement   the amount by which the capacity is
    # increased when the vector overflows
    # @throws IllegalArgumentException if the specified initial capacity
    # is negative
    def initialize(initial_capacity, capacity_increment)
      @element_data = nil
      @element_count = 0
      @capacity_increment = 0
      super()
      if (initial_capacity < 0)
        raise IllegalArgumentException.new("Illegal Capacity: " + RJava.cast_to_string(initial_capacity))
      end
      @element_data = Array.typed(Object).new(initial_capacity) { nil }
      @capacity_increment = capacity_increment
    end
    
    typesig { [::Java::Int] }
    # Constructs an empty vector with the specified initial capacity and
    # with its capacity increment equal to zero.
    # 
    # @param   initialCapacity   the initial capacity of the vector
    # @throws IllegalArgumentException if the specified initial capacity
    # is negative
    def initialize(initial_capacity)
      initialize__vector(initial_capacity, 0)
    end
    
    typesig { [] }
    # Constructs an empty vector so that its internal data array
    # has size {@code 10} and its standard capacity increment is
    # zero.
    def initialize
      initialize__vector(10)
    end
    
    typesig { [Collection] }
    # Constructs a vector containing the elements of the specified
    # collection, in the order they are returned by the collection's
    # iterator.
    # 
    # @param c the collection whose elements are to be placed into this
    # vector
    # @throws NullPointerException if the specified collection is null
    # @since   1.2
    def initialize(c)
      @element_data = nil
      @element_count = 0
      @capacity_increment = 0
      super()
      @element_data = c.to_array
      @element_count = @element_data.attr_length
      # c.toArray might (incorrectly) not return Object[] (see 6260652)
      if (!(@element_data.get_class).equal?(Array[]))
        @element_data = Arrays.copy_of(@element_data, @element_count, Array[])
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Copies the components of this vector into the specified array.
    # The item at index {@code k} in this vector is copied into
    # component {@code k} of {@code anArray}.
    # 
    # @param  anArray the array into which the components get copied
    # @throws NullPointerException if the given array is null
    # @throws IndexOutOfBoundsException if the specified array is not
    # large enough to hold all the components of this vector
    # @throws ArrayStoreException if a component of this vector is not of
    # a runtime type that can be stored in the specified array
    # @see #toArray(Object[])
    def copy_into(an_array)
      synchronized(self) do
        System.arraycopy(@element_data, 0, an_array, 0, @element_count)
      end
    end
    
    typesig { [] }
    # Trims the capacity of this vector to be the vector's current
    # size. If the capacity of this vector is larger than its current
    # size, then the capacity is changed to equal the size by replacing
    # its internal data array, kept in the field {@code elementData},
    # with a smaller one. An application can use this operation to
    # minimize the storage of a vector.
    def trim_to_size
      synchronized(self) do
        self.attr_mod_count += 1
        old_capacity = @element_data.attr_length
        if (@element_count < old_capacity)
          @element_data = Arrays.copy_of(@element_data, @element_count)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Increases the capacity of this vector, if necessary, to ensure
    # that it can hold at least the number of components specified by
    # the minimum capacity argument.
    # 
    # <p>If the current capacity of this vector is less than
    # {@code minCapacity}, then its capacity is increased by replacing its
    # internal data array, kept in the field {@code elementData}, with a
    # larger one.  The size of the new data array will be the old size plus
    # {@code capacityIncrement}, unless the value of
    # {@code capacityIncrement} is less than or equal to zero, in which case
    # the new capacity will be twice the old capacity; but if this new size
    # is still smaller than {@code minCapacity}, then the new capacity will
    # be {@code minCapacity}.
    # 
    # @param minCapacity the desired minimum capacity
    def ensure_capacity(min_capacity)
      synchronized(self) do
        self.attr_mod_count += 1
        ensure_capacity_helper(min_capacity)
      end
    end
    
    typesig { [::Java::Int] }
    # This implements the unsynchronized semantics of ensureCapacity.
    # Synchronized methods in this class can internally call this
    # method for ensuring capacity without incurring the cost of an
    # extra synchronization.
    # 
    # @see #ensureCapacity(int)
    def ensure_capacity_helper(min_capacity)
      old_capacity = @element_data.attr_length
      if (min_capacity > old_capacity)
        old_data = @element_data
        new_capacity = (@capacity_increment > 0) ? (old_capacity + @capacity_increment) : (old_capacity * 2)
        if (new_capacity < min_capacity)
          new_capacity = min_capacity
        end
        @element_data = Arrays.copy_of(@element_data, new_capacity)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the size of this vector. If the new size is greater than the
    # current size, new {@code null} items are added to the end of
    # the vector. If the new size is less than the current size, all
    # components at index {@code newSize} and greater are discarded.
    # 
    # @param  newSize   the new size of this vector
    # @throws ArrayIndexOutOfBoundsException if the new size is negative
    def set_size(new_size)
      synchronized(self) do
        self.attr_mod_count += 1
        if (new_size > @element_count)
          ensure_capacity_helper(new_size)
        else
          i = new_size
          while i < @element_count
            @element_data[i] = nil
            i += 1
          end
        end
        @element_count = new_size
      end
    end
    
    typesig { [] }
    # Returns the current capacity of this vector.
    # 
    # @return  the current capacity (the length of its internal
    # data array, kept in the field {@code elementData}
    # of this vector)
    def capacity
      synchronized(self) do
        return @element_data.attr_length
      end
    end
    
    typesig { [] }
    # Returns the number of components in this vector.
    # 
    # @return  the number of components in this vector
    def size
      synchronized(self) do
        return @element_count
      end
    end
    
    typesig { [] }
    # Tests if this vector has no components.
    # 
    # @return  {@code true} if and only if this vector has
    # no components, that is, its size is zero;
    # {@code false} otherwise.
    def is_empty
      synchronized(self) do
        return (@element_count).equal?(0)
      end
    end
    
    typesig { [] }
    # Returns an enumeration of the components of this vector. The
    # returned {@code Enumeration} object will generate all items in
    # this vector. The first item generated is the item at index {@code 0},
    # then the item at index {@code 1}, and so on.
    # 
    # @return  an enumeration of the components of this vector
    # @see     Iterator
    def elements
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members Vector
        include Enumeration if Enumeration.class == Module
        
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        typesig { [] }
        define_method :has_more_elements do
          return @count < self.attr_element_count
        end
        
        typesig { [] }
        define_method :next_element do
          synchronized((@local_class_parent)) do
            if (@count < self.attr_element_count)
              return element_data(((@count += 1) - 1))
            end
          end
          raise self.class::NoSuchElementException.new("Vector Enumeration")
        end
        
        typesig { [] }
        define_method :initialize do
          @count = 0
          super()
          @count = 0
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [Object] }
    # Returns {@code true} if this vector contains the specified element.
    # More formally, returns {@code true} if and only if this vector
    # contains at least one element {@code e} such that
    # <tt>(o==null&nbsp;?&nbsp;e==null&nbsp;:&nbsp;o.equals(e))</tt>.
    # 
    # @param o element whose presence in this vector is to be tested
    # @return {@code true} if this vector contains the specified element
    def contains(o)
      return index_of(o, 0) >= 0
    end
    
    typesig { [Object] }
    # Returns the index of the first occurrence of the specified element
    # in this vector, or -1 if this vector does not contain the element.
    # More formally, returns the lowest index {@code i} such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>,
    # or -1 if there is no such index.
    # 
    # @param o element to search for
    # @return the index of the first occurrence of the specified element in
    # this vector, or -1 if this vector does not contain the element
    def index_of(o)
      return index_of(o, 0)
    end
    
    typesig { [Object, ::Java::Int] }
    # Returns the index of the first occurrence of the specified element in
    # this vector, searching forwards from {@code index}, or returns -1 if
    # the element is not found.
    # More formally, returns the lowest index {@code i} such that
    # <tt>(i&nbsp;&gt;=&nbsp;index&nbsp;&amp;&amp;&nbsp;(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i))))</tt>,
    # or -1 if there is no such index.
    # 
    # @param o element to search for
    # @param index index to start searching from
    # @return the index of the first occurrence of the element in
    # this vector at position {@code index} or later in the vector;
    # {@code -1} if the element is not found.
    # @throws IndexOutOfBoundsException if the specified index is negative
    # @see     Object#equals(Object)
    def index_of(o, index)
      synchronized(self) do
        if ((o).nil?)
          i = index
          while i < @element_count
            if ((@element_data[i]).nil?)
              return i
            end
            i += 1
          end
        else
          i = index
          while i < @element_count
            if ((o == @element_data[i]))
              return i
            end
            i += 1
          end
        end
        return -1
      end
    end
    
    typesig { [Object] }
    # Returns the index of the last occurrence of the specified element
    # in this vector, or -1 if this vector does not contain the element.
    # More formally, returns the highest index {@code i} such that
    # <tt>(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i)))</tt>,
    # or -1 if there is no such index.
    # 
    # @param o element to search for
    # @return the index of the last occurrence of the specified element in
    # this vector, or -1 if this vector does not contain the element
    def last_index_of(o)
      synchronized(self) do
        return last_index_of(o, @element_count - 1)
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Returns the index of the last occurrence of the specified element in
    # this vector, searching backwards from {@code index}, or returns -1 if
    # the element is not found.
    # More formally, returns the highest index {@code i} such that
    # <tt>(i&nbsp;&lt;=&nbsp;index&nbsp;&amp;&amp;&nbsp;(o==null&nbsp;?&nbsp;get(i)==null&nbsp;:&nbsp;o.equals(get(i))))</tt>,
    # or -1 if there is no such index.
    # 
    # @param o element to search for
    # @param index index to start searching backwards from
    # @return the index of the last occurrence of the element at position
    # less than or equal to {@code index} in this vector;
    # -1 if the element is not found.
    # @throws IndexOutOfBoundsException if the specified index is greater
    # than or equal to the current size of this vector
    def last_index_of(o, index)
      synchronized(self) do
        if (index >= @element_count)
          raise IndexOutOfBoundsException.new(RJava.cast_to_string(index) + " >= " + RJava.cast_to_string(@element_count))
        end
        if ((o).nil?)
          i = index
          while i >= 0
            if ((@element_data[i]).nil?)
              return i
            end
            i -= 1
          end
        else
          i = index
          while i >= 0
            if ((o == @element_data[i]))
              return i
            end
            i -= 1
          end
        end
        return -1
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the component at the specified index.
    # 
    # <p>This method is identical in functionality to the {@link #get(int)}
    # method (which is part of the {@link List} interface).
    # 
    # @param      index   an index into this vector
    # @return     the component at the specified index
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index >= size()})
    def element_at(index)
      synchronized(self) do
        if (index >= @element_count)
          raise ArrayIndexOutOfBoundsException.new(RJava.cast_to_string(index) + " >= " + RJava.cast_to_string(@element_count))
        end
        return element_data(index)
      end
    end
    
    typesig { [] }
    # Returns the first component (the item at index {@code 0}) of
    # this vector.
    # 
    # @return     the first component of this vector
    # @throws NoSuchElementException if this vector has no components
    def first_element
      synchronized(self) do
        if ((@element_count).equal?(0))
          raise NoSuchElementException.new
        end
        return element_data(0)
      end
    end
    
    typesig { [] }
    # Returns the last component of the vector.
    # 
    # @return  the last component of the vector, i.e., the component at index
    # <code>size()&nbsp;-&nbsp;1</code>.
    # @throws NoSuchElementException if this vector is empty
    def last_element
      synchronized(self) do
        if ((@element_count).equal?(0))
          raise NoSuchElementException.new
        end
        return element_data(@element_count - 1)
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Sets the component at the specified {@code index} of this
    # vector to be the specified object. The previous component at that
    # position is discarded.
    # 
    # <p>The index must be a value greater than or equal to {@code 0}
    # and less than the current size of the vector.
    # 
    # <p>This method is identical in functionality to the
    # {@link #set(int, Object) set(int, E)}
    # method (which is part of the {@link List} interface). Note that the
    # {@code set} method reverses the order of the parameters, to more closely
    # match array usage.  Note also that the {@code set} method returns the
    # old value that was stored at the specified position.
    # 
    # @param      obj     what the component is to be set to
    # @param      index   the specified index
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index >= size()})
    def set_element_at(obj, index)
      synchronized(self) do
        if (index >= @element_count)
          raise ArrayIndexOutOfBoundsException.new(RJava.cast_to_string(index) + " >= " + RJava.cast_to_string(@element_count))
        end
        @element_data[index] = obj
      end
    end
    
    typesig { [::Java::Int] }
    # Deletes the component at the specified index. Each component in
    # this vector with an index greater or equal to the specified
    # {@code index} is shifted downward to have an index one
    # smaller than the value it had previously. The size of this vector
    # is decreased by {@code 1}.
    # 
    # <p>The index must be a value greater than or equal to {@code 0}
    # and less than the current size of the vector.
    # 
    # <p>This method is identical in functionality to the {@link #remove(int)}
    # method (which is part of the {@link List} interface).  Note that the
    # {@code remove} method returns the old value that was stored at the
    # specified position.
    # 
    # @param      index   the index of the object to remove
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index >= size()})
    def remove_element_at(index)
      synchronized(self) do
        self.attr_mod_count += 1
        if (index >= @element_count)
          raise ArrayIndexOutOfBoundsException.new(RJava.cast_to_string(index) + " >= " + RJava.cast_to_string(@element_count))
        else
          if (index < 0)
            raise ArrayIndexOutOfBoundsException.new(index)
          end
        end
        j = @element_count - index - 1
        if (j > 0)
          System.arraycopy(@element_data, index + 1, @element_data, index, j)
        end
        @element_count -= 1
        @element_data[@element_count] = nil
      end
      # to let gc do its work
    end
    
    typesig { [Object, ::Java::Int] }
    # Inserts the specified object as a component in this vector at the
    # specified {@code index}. Each component in this vector with
    # an index greater or equal to the specified {@code index} is
    # shifted upward to have an index one greater than the value it had
    # previously.
    # 
    # <p>The index must be a value greater than or equal to {@code 0}
    # and less than or equal to the current size of the vector. (If the
    # index is equal to the current size of the vector, the new element
    # is appended to the Vector.)
    # 
    # <p>This method is identical in functionality to the
    # {@link #add(int, Object) add(int, E)}
    # method (which is part of the {@link List} interface).  Note that the
    # {@code add} method reverses the order of the parameters, to more closely
    # match array usage.
    # 
    # @param      obj     the component to insert
    # @param      index   where to insert the new component
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index > size()})
    def insert_element_at(obj, index)
      synchronized(self) do
        self.attr_mod_count += 1
        if (index > @element_count)
          raise ArrayIndexOutOfBoundsException.new(RJava.cast_to_string(index) + " > " + RJava.cast_to_string(@element_count))
        end
        ensure_capacity_helper(@element_count + 1)
        System.arraycopy(@element_data, index, @element_data, index + 1, @element_count - index)
        @element_data[index] = obj
        @element_count += 1
      end
    end
    
    typesig { [Object] }
    # Adds the specified component to the end of this vector,
    # increasing its size by one. The capacity of this vector is
    # increased if its size becomes greater than its capacity.
    # 
    # <p>This method is identical in functionality to the
    # {@link #add(Object) add(E)}
    # method (which is part of the {@link List} interface).
    # 
    # @param   obj   the component to be added
    def add_element(obj)
      synchronized(self) do
        self.attr_mod_count += 1
        ensure_capacity_helper(@element_count + 1)
        @element_data[((@element_count += 1) - 1)] = obj
      end
    end
    
    typesig { [Object] }
    # Removes the first (lowest-indexed) occurrence of the argument
    # from this vector. If the object is found in this vector, each
    # component in the vector with an index greater or equal to the
    # object's index is shifted downward to have an index one smaller
    # than the value it had previously.
    # 
    # <p>This method is identical in functionality to the
    # {@link #remove(Object)} method (which is part of the
    # {@link List} interface).
    # 
    # @param   obj   the component to be removed
    # @return  {@code true} if the argument was a component of this
    # vector; {@code false} otherwise.
    def remove_element(obj)
      synchronized(self) do
        self.attr_mod_count += 1
        i = index_of(obj)
        if (i >= 0)
          remove_element_at(i)
          return true
        end
        return false
      end
    end
    
    typesig { [] }
    # Removes all components from this vector and sets its size to zero.
    # 
    # <p>This method is identical in functionality to the {@link #clear}
    # method (which is part of the {@link List} interface).
    def remove_all_elements
      synchronized(self) do
        self.attr_mod_count += 1
        # Let gc do its work
        i = 0
        while i < @element_count
          @element_data[i] = nil
          i += 1
        end
        @element_count = 0
      end
    end
    
    typesig { [] }
    # Returns a clone of this vector. The copy will contain a
    # reference to a clone of the internal data array, not a reference
    # to the original internal data array of this {@code Vector} object.
    # 
    # @return  a clone of this vector
    def clone
      synchronized(self) do
        begin
          v = super
          v.attr_element_data = Arrays.copy_of(@element_data, @element_count)
          v.attr_mod_count = 0
          return v
        rescue CloneNotSupportedException => e
          # this shouldn't happen, since we are Cloneable
          raise InternalError.new
        end
      end
    end
    
    typesig { [] }
    # Returns an array containing all of the elements in this Vector
    # in the correct order.
    # 
    # @since 1.2
    def to_array
      synchronized(self) do
        return Arrays.copy_of(@element_data, @element_count)
      end
    end
    
    typesig { [Array.typed(T)] }
    # Returns an array containing all of the elements in this Vector in the
    # correct order; the runtime type of the returned array is that of the
    # specified array.  If the Vector fits in the specified array, it is
    # returned therein.  Otherwise, a new array is allocated with the runtime
    # type of the specified array and the size of this Vector.
    # 
    # <p>If the Vector fits in the specified array with room to spare
    # (i.e., the array has more elements than the Vector),
    # the element in the array immediately following the end of the
    # Vector is set to null.  (This is useful in determining the length
    # of the Vector <em>only</em> if the caller knows that the Vector
    # does not contain any null elements.)
    # 
    # @param a the array into which the elements of the Vector are to
    # be stored, if it is big enough; otherwise, a new array of the
    # same runtime type is allocated for this purpose.
    # @return an array containing the elements of the Vector
    # @throws ArrayStoreException if the runtime type of a is not a supertype
    # of the runtime type of every element in this Vector
    # @throws NullPointerException if the given array is null
    # @since 1.2
    def to_array(a)
      synchronized(self) do
        if (a.attr_length < @element_count)
          return Arrays.copy_of(@element_data, @element_count, a.get_class)
        end
        System.arraycopy(@element_data, 0, a, 0, @element_count)
        if (a.attr_length > @element_count)
          a[@element_count] = nil
        end
        return a
      end
    end
    
    typesig { [::Java::Int] }
    # Positional Access Operations
    def element_data(index)
      return @element_data[index]
    end
    
    typesig { [::Java::Int] }
    # Returns the element at the specified position in this Vector.
    # 
    # @param index index of the element to return
    # @return object at the specified index
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index >= size()})
    # @since 1.2
    def get(index)
      synchronized(self) do
        if (index >= @element_count)
          raise ArrayIndexOutOfBoundsException.new(index)
        end
        return element_data(index)
      end
    end
    
    typesig { [::Java::Int, Object] }
    # Replaces the element at the specified position in this Vector with the
    # specified element.
    # 
    # @param index index of the element to replace
    # @param element element to be stored at the specified position
    # @return the element previously at the specified position
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index >= size()})
    # @since 1.2
    def set(index, element)
      synchronized(self) do
        if (index >= @element_count)
          raise ArrayIndexOutOfBoundsException.new(index)
        end
        old_value = element_data(index)
        @element_data[index] = element
        return old_value
      end
    end
    
    typesig { [Object] }
    # Appends the specified element to the end of this Vector.
    # 
    # @param e element to be appended to this Vector
    # @return {@code true} (as specified by {@link Collection#add})
    # @since 1.2
    def add(e)
      synchronized(self) do
        self.attr_mod_count += 1
        ensure_capacity_helper(@element_count + 1)
        @element_data[((@element_count += 1) - 1)] = e
        return true
      end
    end
    
    typesig { [Object] }
    # Removes the first occurrence of the specified element in this Vector
    # If the Vector does not contain the element, it is unchanged.  More
    # formally, removes the element with the lowest index i such that
    # {@code (o==null ? get(i)==null : o.equals(get(i)))} (if such
    # an element exists).
    # 
    # @param o element to be removed from this Vector, if present
    # @return true if the Vector contained the specified element
    # @since 1.2
    def remove(o)
      return remove_element(o)
    end
    
    typesig { [::Java::Int, Object] }
    # Inserts the specified element at the specified position in this Vector.
    # Shifts the element currently at that position (if any) and any
    # subsequent elements to the right (adds one to their indices).
    # 
    # @param index index at which the specified element is to be inserted
    # @param element element to be inserted
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index > size()})
    # @since 1.2
    def add(index, element)
      insert_element_at(element, index)
    end
    
    typesig { [::Java::Int] }
    # Removes the element at the specified position in this Vector.
    # Shifts any subsequent elements to the left (subtracts one from their
    # indices).  Returns the element that was removed from the Vector.
    # 
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index >= size()})
    # @param index the index of the element to be removed
    # @return element that was removed
    # @since 1.2
    def remove(index)
      synchronized(self) do
        self.attr_mod_count += 1
        if (index >= @element_count)
          raise ArrayIndexOutOfBoundsException.new(index)
        end
        old_value = element_data(index)
        num_moved = @element_count - index - 1
        if (num_moved > 0)
          System.arraycopy(@element_data, index + 1, @element_data, index, num_moved)
        end
        @element_data[(@element_count -= 1)] = nil # Let gc do its work
        return old_value
      end
    end
    
    typesig { [] }
    # Removes all of the elements from this Vector.  The Vector will
    # be empty after this call returns (unless it throws an exception).
    # 
    # @since 1.2
    def clear
      remove_all_elements
    end
    
    typesig { [Collection] }
    # Bulk Operations
    # 
    # Returns true if this Vector contains all of the elements in the
    # specified Collection.
    # 
    # @param   c a collection whose elements will be tested for containment
    # in this Vector
    # @return true if this Vector contains all of the elements in the
    # specified collection
    # @throws NullPointerException if the specified collection is null
    def contains_all(c)
      synchronized(self) do
        return super(c)
      end
    end
    
    typesig { [Collection] }
    # Appends all of the elements in the specified Collection to the end of
    # this Vector, in the order that they are returned by the specified
    # Collection's Iterator.  The behavior of this operation is undefined if
    # the specified Collection is modified while the operation is in progress.
    # (This implies that the behavior of this call is undefined if the
    # specified Collection is this Vector, and this Vector is nonempty.)
    # 
    # @param c elements to be inserted into this Vector
    # @return {@code true} if this Vector changed as a result of the call
    # @throws NullPointerException if the specified collection is null
    # @since 1.2
    def add_all(c)
      synchronized(self) do
        self.attr_mod_count += 1
        a = c.to_array
        num_new = a.attr_length
        ensure_capacity_helper(@element_count + num_new)
        System.arraycopy(a, 0, @element_data, @element_count, num_new)
        @element_count += num_new
        return !(num_new).equal?(0)
      end
    end
    
    typesig { [Collection] }
    # Removes from this Vector all of its elements that are contained in the
    # specified Collection.
    # 
    # @param c a collection of elements to be removed from the Vector
    # @return true if this Vector changed as a result of the call
    # @throws ClassCastException if the types of one or more elements
    # in this vector are incompatible with the specified
    # collection (optional)
    # @throws NullPointerException if this vector contains one or more null
    # elements and the specified collection does not support null
    # elements (optional), or if the specified collection is null
    # @since 1.2
    def remove_all(c)
      synchronized(self) do
        return super(c)
      end
    end
    
    typesig { [Collection] }
    # Retains only the elements in this Vector that are contained in the
    # specified Collection.  In other words, removes from this Vector all
    # of its elements that are not contained in the specified Collection.
    # 
    # @param c a collection of elements to be retained in this Vector
    # (all other elements are removed)
    # @return true if this Vector changed as a result of the call
    # @throws ClassCastException if the types of one or more elements
    # in this vector are incompatible with the specified
    # collection (optional)
    # @throws NullPointerException if this vector contains one or more null
    # elements and the specified collection does not support null
    # elements (optional), or if the specified collection is null
    # @since 1.2
    def retain_all(c)
      synchronized(self) do
        return super(c)
      end
    end
    
    typesig { [::Java::Int, Collection] }
    # Inserts all of the elements in the specified Collection into this
    # Vector at the specified position.  Shifts the element currently at
    # that position (if any) and any subsequent elements to the right
    # (increases their indices).  The new elements will appear in the Vector
    # in the order that they are returned by the specified Collection's
    # iterator.
    # 
    # @param index index at which to insert the first element from the
    # specified collection
    # @param c elements to be inserted into this Vector
    # @return {@code true} if this Vector changed as a result of the call
    # @throws ArrayIndexOutOfBoundsException if the index is out of range
    # ({@code index < 0 || index > size()})
    # @throws NullPointerException if the specified collection is null
    # @since 1.2
    def add_all(index, c)
      synchronized(self) do
        self.attr_mod_count += 1
        if (index < 0 || index > @element_count)
          raise ArrayIndexOutOfBoundsException.new(index)
        end
        a = c.to_array
        num_new = a.attr_length
        ensure_capacity_helper(@element_count + num_new)
        num_moved = @element_count - index
        if (num_moved > 0)
          System.arraycopy(@element_data, index, @element_data, index + num_new, num_moved)
        end
        System.arraycopy(a, 0, @element_data, index, num_new)
        @element_count += num_new
        return !(num_new).equal?(0)
      end
    end
    
    typesig { [Object] }
    # Compares the specified Object with this Vector for equality.  Returns
    # true if and only if the specified Object is also a List, both Lists
    # have the same size, and all corresponding pairs of elements in the two
    # Lists are <em>equal</em>.  (Two elements {@code e1} and
    # {@code e2} are <em>equal</em> if {@code (e1==null ? e2==null :
    # e1.equals(e2))}.)  In other words, two Lists are defined to be
    # equal if they contain the same elements in the same order.
    # 
    # @param o the Object to be compared for equality with this Vector
    # @return true if the specified Object is equal to this Vector
    def ==(o)
      synchronized(self) do
        return super(o)
      end
    end
    
    typesig { [] }
    # Returns the hash code value for this Vector.
    def hash_code
      synchronized(self) do
        return super
      end
    end
    
    typesig { [] }
    # Returns a string representation of this Vector, containing
    # the String representation of each element.
    def to_s
      synchronized(self) do
        return super
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns a view of the portion of this List between fromIndex,
    # inclusive, and toIndex, exclusive.  (If fromIndex and toIndex are
    # equal, the returned List is empty.)  The returned List is backed by this
    # List, so changes in the returned List are reflected in this List, and
    # vice-versa.  The returned List supports all of the optional List
    # operations supported by this List.
    # 
    # <p>This method eliminates the need for explicit range operations (of
    # the sort that commonly exist for arrays).  Any operation that expects
    # a List can be used as a range operation by operating on a subList view
    # instead of a whole List.  For example, the following idiom
    # removes a range of elements from a List:
    # <pre>
    # list.subList(from, to).clear();
    # </pre>
    # Similar idioms may be constructed for indexOf and lastIndexOf,
    # and all of the algorithms in the Collections class can be applied to
    # a subList.
    # 
    # <p>The semantics of the List returned by this method become undefined if
    # the backing list (i.e., this List) is <i>structurally modified</i> in
    # any way other than via the returned List.  (Structural modifications are
    # those that change the size of the List, or otherwise perturb it in such
    # a fashion that iterations in progress may yield incorrect results.)
    # 
    # @param fromIndex low endpoint (inclusive) of the subList
    # @param toIndex high endpoint (exclusive) of the subList
    # @return a view of the specified range within this List
    # @throws IndexOutOfBoundsException if an endpoint index value is out of range
    # {@code (fromIndex < 0 || toIndex > size)}
    # @throws IllegalArgumentException if the endpoint indices are out of order
    # {@code (fromIndex > toIndex)}
    def sub_list(from_index, to_index)
      synchronized(self) do
        return Collections.synchronized_list(super(from_index, to_index), self)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes from this list all of the elements whose index is between
    # {@code fromIndex}, inclusive, and {@code toIndex}, exclusive.
    # Shifts any succeeding elements to the left (reduces their index).
    # This call shortens the list by {@code (toIndex - fromIndex)} elements.
    # (If {@code toIndex==fromIndex}, this operation has no effect.)
    def remove_range(from_index, to_index)
      synchronized(self) do
        self.attr_mod_count += 1
        num_moved = @element_count - to_index
        System.arraycopy(@element_data, to_index, @element_data, from_index, num_moved)
        # Let gc do its work
        new_element_count = @element_count - (to_index - from_index)
        while (!(@element_count).equal?(new_element_count))
          @element_data[(@element_count -= 1)] = nil
        end
      end
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the {@code Vector} instance to a stream (that
    # is, serialize it).  This method is present merely for synchronization.
    # It just calls the default writeObject method.
    def write_object(s)
      synchronized(self) do
        s.default_write_object
      end
    end
    
    typesig { [::Java::Int] }
    # Returns a list iterator over the elements in this list (in proper
    # sequence), starting at the specified position in the list.
    # The specified index indicates the first element that would be
    # returned by an initial call to {@link ListIterator#next next}.
    # An initial call to {@link ListIterator#previous previous} would
    # return the element with the specified index minus one.
    # 
    # <p>The returned list iterator is <a href="#fail-fast"><i>fail-fast</i></a>.
    # 
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def list_iterator(index)
      synchronized(self) do
        if (index < 0 || index > @element_count)
          raise IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index))
        end
        return ListItr.new_local(self, index)
      end
    end
    
    typesig { [] }
    # Returns a list iterator over the elements in this list (in proper
    # sequence).
    # 
    # <p>The returned list iterator is <a href="#fail-fast"><i>fail-fast</i></a>.
    # 
    # @see #listIterator(int)
    def list_iterator
      synchronized(self) do
        return ListItr.new_local(self, 0)
      end
    end
    
    typesig { [] }
    # Returns an iterator over the elements in this list in proper sequence.
    # 
    # <p>The returned iterator is <a href="#fail-fast"><i>fail-fast</i></a>.
    # 
    # @return an iterator over the elements in this list in proper sequence
    def iterator
      synchronized(self) do
        return Itr.new_local(self)
      end
    end
    
    class_module.module_eval {
      # An optimized version of AbstractList.Itr
      const_set_lazy(:Itr) { Class.new do
        extend LocalClass
        include_class_members Vector
        include Iterator
        
        attr_accessor :cursor
        alias_method :attr_cursor, :cursor
        undef_method :cursor
        alias_method :attr_cursor=, :cursor=
        undef_method :cursor=
        
        # index of next element to return
        attr_accessor :last_ret
        alias_method :attr_last_ret, :last_ret
        undef_method :last_ret
        alias_method :attr_last_ret=, :last_ret=
        undef_method :last_ret=
        
        # index of last element returned; -1 if no such
        attr_accessor :expected_mod_count
        alias_method :attr_expected_mod_count, :expected_mod_count
        undef_method :expected_mod_count
        alias_method :attr_expected_mod_count=, :expected_mod_count=
        undef_method :expected_mod_count=
        
        typesig { [] }
        def has_next
          # Racy but within spec, since modifications are checked
          # within or after synchronization in next/previous
          return !(@cursor).equal?(self.attr_element_count)
        end
        
        typesig { [] }
        def next_
          synchronized((@local_class_parent)) do
            check_for_comodification
            i = @cursor
            if (i >= self.attr_element_count)
              raise self.class::NoSuchElementException.new
            end
            @cursor = i + 1
            return element_data(@last_ret = i)
          end
        end
        
        typesig { [] }
        def remove
          if ((@last_ret).equal?(-1))
            raise self.class::IllegalStateException.new
          end
          synchronized((@local_class_parent)) do
            check_for_comodification
            @local_class_parent.remove(@last_ret)
            @expected_mod_count = self.attr_mod_count
          end
          @cursor = @last_ret
          @last_ret = -1
        end
        
        typesig { [] }
        def check_for_comodification
          if (!(self.attr_mod_count).equal?(@expected_mod_count))
            raise self.class::ConcurrentModificationException.new
          end
        end
        
        typesig { [] }
        def initialize
          @cursor = 0
          @last_ret = -1
          @expected_mod_count = self.attr_mod_count
        end
        
        private
        alias_method :initialize__itr, :initialize
      end }
      
      # An optimized version of AbstractList.ListItr
      const_set_lazy(:ListItr) { Class.new(Itr) do
        extend LocalClass
        include_class_members Vector
        overload_protected {
          include ListIterator
        }
        
        typesig { [::Java::Int] }
        def initialize(index)
          super()
          self.attr_cursor = index
        end
        
        typesig { [] }
        def has_previous
          return !(self.attr_cursor).equal?(0)
        end
        
        typesig { [] }
        def next_index
          return self.attr_cursor
        end
        
        typesig { [] }
        def previous_index
          return self.attr_cursor - 1
        end
        
        typesig { [] }
        def previous
          synchronized((@local_class_parent)) do
            check_for_comodification
            i = self.attr_cursor - 1
            if (i < 0)
              raise self.class::NoSuchElementException.new
            end
            self.attr_cursor = i
            return element_data(self.attr_last_ret = i)
          end
        end
        
        typesig { [class_self::E] }
        def set(e)
          if ((self.attr_last_ret).equal?(-1))
            raise self.class::IllegalStateException.new
          end
          synchronized((@local_class_parent)) do
            check_for_comodification
            @local_class_parent.set(self.attr_last_ret, e)
          end
        end
        
        typesig { [class_self::E] }
        def add(e)
          i = self.attr_cursor
          synchronized((@local_class_parent)) do
            check_for_comodification
            @local_class_parent.add(i, e)
            self.attr_expected_mod_count = self.attr_mod_count
          end
          self.attr_cursor = i + 1
          self.attr_last_ret = -1
        end
        
        private
        alias_method :initialize__list_itr, :initialize
      end }
    }
    
    private
    alias_method :initialize__vector, :initialize
  end
  
end
