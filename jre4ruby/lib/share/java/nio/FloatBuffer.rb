require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio
  module FloatBufferImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  # A float buffer.
  # 
  # <p> This class defines four categories of operations upon
  # float buffers:
  # 
  # <ul>
  # 
  # <li><p> Absolute and relative {@link #get() </code><i>get</i><code>} and
  # {@link #put(float) </code><i>put</i><code>} methods that read and write
  # single floats; </p></li>
  # 
  # <li><p> Relative {@link #get(float[]) </code><i>bulk get</i><code>}
  # methods that transfer contiguous sequences of floats from this buffer
  # into an array; and</p></li>
  # 
  # <li><p> Relative {@link #put(float[]) </code><i>bulk put</i><code>}
  # methods that transfer contiguous sequences of floats from a
  # float array or some other float
  # buffer into this buffer;&#32;and </p></li>
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # <li><p> Methods for {@link #compact </code>compacting<code>}, {@link
  # #duplicate </code>duplicating<code>}, and {@link #slice
  # </code>slicing<code>} a float buffer.  </p></li>
  # 
  # </ul>
  # 
  # <p> Float buffers can be created either by {@link #allocate
  # </code><i>allocation</i><code>}, which allocates space for the buffer's
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # content, by {@link #wrap(float[]) </code><i>wrapping</i><code>} an existing
  # float array  into a buffer, or by creating a
  # <a href="ByteBuffer.html#views"><i>view</i></a> of an existing byte buffer.
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # <p> Like a byte buffer, a float buffer is either <a
  # href="ByteBuffer.html#direct"><i>direct</i> or <i>non-direct</i></a>.  A
  # float buffer created via the <tt>wrap</tt> methods of this class will
  # be non-direct.  A float buffer created as a view of a byte buffer will
  # be direct if, and only if, the byte buffer itself is direct.  Whether or not
  # a float buffer is direct may be determined by invoking the {@link
  # #isDirect isDirect} method.  </p>
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # <p> Methods in this class that do not otherwise have a value to return are
  # specified to return the buffer upon which they are invoked.  This allows
  # method invocations to be chained.
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class FloatBuffer < FloatBufferImports.const_get :Buffer
    include_class_members FloatBufferImports
    overload_protected {
      include JavaComparable
    }
    
    # These fields are declared here rather than in Heap-X-Buffer in order to
    # reduce the number of virtual method invocations needed to access these
    # values, which is especially costly when coding small buffers.
    attr_accessor :hb
    alias_method :attr_hb, :hb
    undef_method :hb
    alias_method :attr_hb=, :hb=
    undef_method :hb=
    
    # Non-null only for heap buffers
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    attr_accessor :is_read_only
    alias_method :attr_is_read_only, :is_read_only
    undef_method :is_read_only
    alias_method :attr_is_read_only=, :is_read_only=
    undef_method :is_read_only=
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, Array.typed(::Java::Float), ::Java::Int] }
    # Valid only for heap buffers
    # Creates a new buffer with the given mark, position, limit, capacity,
    # backing array, and array offset
    # 
    # package-private
    def initialize(mark, pos, lim, cap, hb, offset)
      @hb = nil
      @offset = 0
      @is_read_only = false
      super(mark, pos, lim, cap)
      @hb = hb
      @offset = offset
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a new buffer with the given mark, position, limit, and capacity
    def initialize(mark, pos, lim, cap)
      # package-private
      initialize__float_buffer(mark, pos, lim, cap, nil, 0)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Allocates a new float buffer.
      # 
      # <p> The new buffer's position will be zero, its limit will be its
      # capacity, and its mark will be undefined.  It will have a {@link #array
      # </code>backing array<code>}, and its {@link #arrayOffset </code>array
      # offset<code>} will be zero.
      # 
      # @param  capacity
      # The new buffer's capacity, in floats
      # 
      # @return  The new float buffer
      # 
      # @throws  IllegalArgumentException
      # If the <tt>capacity</tt> is a negative integer
      def allocate(capacity)
        if (capacity < 0)
          raise IllegalArgumentException.new
        end
        return HeapFloatBuffer.new(capacity, capacity)
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
      # Wraps a float array into a buffer.
      # 
      # <p> The new buffer will be backed by the given float array;
      # that is, modifications to the buffer will cause the array to be modified
      # and vice versa.  The new buffer's capacity will be
      # <tt>array.length</tt>, its position will be <tt>offset</tt>, its limit
      # will be <tt>offset + length</tt>, and its mark will be undefined.  Its
      # {@link #array </code>backing array<code>} will be the given array, and
      # its {@link #arrayOffset </code>array offset<code>} will be zero.  </p>
      # 
      # @param  array
      # The array that will back the new buffer
      # 
      # @param  offset
      # The offset of the subarray to be used; must be non-negative and
      # no larger than <tt>array.length</tt>.  The new buffer's position
      # will be set to this value.
      # 
      # @param  length
      # The length of the subarray to be used;
      # must be non-negative and no larger than
      # <tt>array.length - offset</tt>.
      # The new buffer's limit will be set to <tt>offset + length</tt>.
      # 
      # @return  The new float buffer
      # 
      # @throws  IndexOutOfBoundsException
      # If the preconditions on the <tt>offset</tt> and <tt>length</tt>
      # parameters do not hold
      def wrap(array, offset, length)
        begin
          return HeapFloatBuffer.new(array, offset, length)
        rescue IllegalArgumentException => x
          raise IndexOutOfBoundsException.new
        end
      end
      
      typesig { [Array.typed(::Java::Float)] }
      # Wraps a float array into a buffer.
      # 
      # <p> The new buffer will be backed by the given float array;
      # that is, modifications to the buffer will cause the array to be modified
      # and vice versa.  The new buffer's capacity and limit will be
      # <tt>array.length</tt>, its position will be zero, and its mark will be
      # undefined.  Its {@link #array </code>backing array<code>} will be the
      # given array, and its {@link #arrayOffset </code>array offset<code>} will
      # be zero.  </p>
      # 
      # @param  array
      # The array that will back this buffer
      # 
      # @return  The new float buffer
      def wrap(array)
        return wrap(array, 0, array.attr_length)
      end
    }
    
    typesig { [] }
    # Creates a new float buffer whose content is a shared subsequence of
    # this buffer's content.
    # 
    # <p> The content of the new buffer will start at this buffer's current
    # position.  Changes to this buffer's content will be visible in the new
    # buffer, and vice versa; the two buffers' position, limit, and mark
    # values will be independent.
    # 
    # <p> The new buffer's position will be zero, its capacity and its limit
    # will be the number of floats remaining in this buffer, and its mark
    # will be undefined.  The new buffer will be direct if, and only if, this
    # buffer is direct, and it will be read-only if, and only if, this buffer
    # is read-only.  </p>
    # 
    # @return  The new float buffer
    def slice
      raise NotImplementedError
    end
    
    typesig { [] }
    # Creates a new float buffer that shares this buffer's content.
    # 
    # <p> The content of the new buffer will be that of this buffer.  Changes
    # to this buffer's content will be visible in the new buffer, and vice
    # versa; the two buffers' position, limit, and mark values will be
    # independent.
    # 
    # <p> The new buffer's capacity, limit, position, and mark values will be
    # identical to those of this buffer.  The new buffer will be direct if,
    # and only if, this buffer is direct, and it will be read-only if, and
    # only if, this buffer is read-only.  </p>
    # 
    # @return  The new float buffer
    def duplicate
      raise NotImplementedError
    end
    
    typesig { [] }
    # Creates a new, read-only float buffer that shares this buffer's
    # content.
    # 
    # <p> The content of the new buffer will be that of this buffer.  Changes
    # to this buffer's content will be visible in the new buffer; the new
    # buffer itself, however, will be read-only and will not allow the shared
    # content to be modified.  The two buffers' position, limit, and mark
    # values will be independent.
    # 
    # <p> The new buffer's capacity, limit, position, and mark values will be
    # identical to those of this buffer.
    # 
    # <p> If this buffer is itself read-only then this method behaves in
    # exactly the same way as the {@link #duplicate duplicate} method.  </p>
    # 
    # @return  The new, read-only float buffer
    def as_read_only_buffer
      raise NotImplementedError
    end
    
    typesig { [] }
    # -- Singleton get/put methods --
    # 
    # Relative <i>get</i> method.  Reads the float at this buffer's
    # current position, and then increments the position. </p>
    # 
    # @return  The float at the buffer's current position
    # 
    # @throws  BufferUnderflowException
    # If the buffer's current position is not smaller than its limit
    def get
      raise NotImplementedError
    end
    
    typesig { [::Java::Float] }
    # Relative <i>put</i> method&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> Writes the given float into this buffer at the current
    # position, and then increments the position. </p>
    # 
    # @param  f
    # The float to be written
    # 
    # @return  This buffer
    # 
    # @throws  BufferOverflowException
    # If this buffer's current position is not smaller than its limit
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is read-only
    def put(f)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Absolute <i>get</i> method.  Reads the float at the given
    # index. </p>
    # 
    # @param  index
    # The index from which the float will be read
    # 
    # @return  The float at the given index
    # 
    # @throws  IndexOutOfBoundsException
    # If <tt>index</tt> is negative
    # or not smaller than the buffer's limit
    def get(index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # Absolute <i>put</i> method&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> Writes the given float into this buffer at the given
    # index. </p>
    # 
    # @param  index
    # The index at which the float will be written
    # 
    # @param  f
    # The float value to be written
    # 
    # @return  This buffer
    # 
    # @throws  IndexOutOfBoundsException
    # If <tt>index</tt> is negative
    # or not smaller than the buffer's limit
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is read-only
    def put(index, f)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
    # -- Bulk get operations --
    # 
    # Relative bulk <i>get</i> method.
    # 
    # <p> This method transfers floats from this buffer into the given
    # destination array.  If there are fewer floats remaining in the
    # buffer than are required to satisfy the request, that is, if
    # <tt>length</tt>&nbsp;<tt>&gt;</tt>&nbsp;<tt>remaining()</tt>, then no
    # floats are transferred and a {@link BufferUnderflowException} is
    # thrown.
    # 
    # <p> Otherwise, this method copies <tt>length</tt> floats from this
    # buffer into the given array, starting at the current position of this
    # buffer and at the given offset in the array.  The position of this
    # buffer is then incremented by <tt>length</tt>.
    # 
    # <p> In other words, an invocation of this method of the form
    # <tt>src.get(dst,&nbsp;off,&nbsp;len)</tt> has exactly the same effect as
    # the loop
    # 
    # <pre>
    # for (int i = off; i < off + len; i++)
    # dst[i] = src.get(); </pre>
    # 
    # except that it first checks that there are sufficient floats in
    # this buffer and it is potentially much more efficient. </p>
    # 
    # @param  dst
    # The array into which floats are to be written
    # 
    # @param  offset
    # The offset within the array of the first float to be
    # written; must be non-negative and no larger than
    # <tt>dst.length</tt>
    # 
    # @param  length
    # The maximum number of floats to be written to the given
    # array; must be non-negative and no larger than
    # <tt>dst.length - offset</tt>
    # 
    # @return  This buffer
    # 
    # @throws  BufferUnderflowException
    # If there are fewer than <tt>length</tt> floats
    # remaining in this buffer
    # 
    # @throws  IndexOutOfBoundsException
    # If the preconditions on the <tt>offset</tt> and <tt>length</tt>
    # parameters do not hold
    def get(dst, offset, length)
      check_bounds(offset, length, dst.attr_length)
      if (length > remaining)
        raise BufferUnderflowException.new
      end
      end_ = offset + length
      i = offset
      while i < end_
        dst[i] = get
        i += 1
      end
      return self
    end
    
    typesig { [Array.typed(::Java::Float)] }
    # Relative bulk <i>get</i> method.
    # 
    # <p> This method transfers floats from this buffer into the given
    # destination array.  An invocation of this method of the form
    # <tt>src.get(a)</tt> behaves in exactly the same way as the invocation
    # 
    # <pre>
    # src.get(a, 0, a.length) </pre>
    # 
    # @return  This buffer
    # 
    # @throws  BufferUnderflowException
    # If there are fewer than <tt>length</tt> floats
    # remaining in this buffer
    def get(dst)
      return get(dst, 0, dst.attr_length)
    end
    
    typesig { [FloatBuffer] }
    # -- Bulk put operations --
    # 
    # Relative bulk <i>put</i> method&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> This method transfers the floats remaining in the given source
    # buffer into this buffer.  If there are more floats remaining in the
    # source buffer than in this buffer, that is, if
    # <tt>src.remaining()</tt>&nbsp;<tt>&gt;</tt>&nbsp;<tt>remaining()</tt>,
    # then no floats are transferred and a {@link
    # BufferOverflowException} is thrown.
    # 
    # <p> Otherwise, this method copies
    # <i>n</i>&nbsp;=&nbsp;<tt>src.remaining()</tt> floats from the given
    # buffer into this buffer, starting at each buffer's current position.
    # The positions of both buffers are then incremented by <i>n</i>.
    # 
    # <p> In other words, an invocation of this method of the form
    # <tt>dst.put(src)</tt> has exactly the same effect as the loop
    # 
    # <pre>
    # while (src.hasRemaining())
    # dst.put(src.get()); </pre>
    # 
    # except that it first checks that there is sufficient space in this
    # buffer and it is potentially much more efficient. </p>
    # 
    # @param  src
    # The source buffer from which floats are to be read;
    # must not be this buffer
    # 
    # @return  This buffer
    # 
    # @throws  BufferOverflowException
    # If there is insufficient space in this buffer
    # for the remaining floats in the source buffer
    # 
    # @throws  IllegalArgumentException
    # If the source buffer is this buffer
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is read-only
    def put(src)
      if ((src).equal?(self))
        raise IllegalArgumentException.new
      end
      n = src.remaining
      if (n > remaining)
        raise BufferOverflowException.new
      end
      i = 0
      while i < n
        put(src.get)
        i += 1
      end
      return self
    end
    
    typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
    # Relative bulk <i>put</i> method&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> This method transfers floats into this buffer from the given
    # source array.  If there are more floats to be copied from the array
    # than remain in this buffer, that is, if
    # <tt>length</tt>&nbsp;<tt>&gt;</tt>&nbsp;<tt>remaining()</tt>, then no
    # floats are transferred and a {@link BufferOverflowException} is
    # thrown.
    # 
    # <p> Otherwise, this method copies <tt>length</tt> floats from the
    # given array into this buffer, starting at the given offset in the array
    # and at the current position of this buffer.  The position of this buffer
    # is then incremented by <tt>length</tt>.
    # 
    # <p> In other words, an invocation of this method of the form
    # <tt>dst.put(src,&nbsp;off,&nbsp;len)</tt> has exactly the same effect as
    # the loop
    # 
    # <pre>
    # for (int i = off; i < off + len; i++)
    # dst.put(a[i]); </pre>
    # 
    # except that it first checks that there is sufficient space in this
    # buffer and it is potentially much more efficient. </p>
    # 
    # @param  src
    # The array from which floats are to be read
    # 
    # @param  offset
    # The offset within the array of the first float to be read;
    # must be non-negative and no larger than <tt>array.length</tt>
    # 
    # @param  length
    # The number of floats to be read from the given array;
    # must be non-negative and no larger than
    # <tt>array.length - offset</tt>
    # 
    # @return  This buffer
    # 
    # @throws  BufferOverflowException
    # If there is insufficient space in this buffer
    # 
    # @throws  IndexOutOfBoundsException
    # If the preconditions on the <tt>offset</tt> and <tt>length</tt>
    # parameters do not hold
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is read-only
    def put(src, offset, length)
      check_bounds(offset, length, src.attr_length)
      if (length > remaining)
        raise BufferOverflowException.new
      end
      end_ = offset + length
      i = offset
      while i < end_
        self.put(src[i])
        i += 1
      end
      return self
    end
    
    typesig { [Array.typed(::Java::Float)] }
    # Relative bulk <i>put</i> method&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> This method transfers the entire content of the given source
    # float array into this buffer.  An invocation of this method of the
    # form <tt>dst.put(a)</tt> behaves in exactly the same way as the
    # invocation
    # 
    # <pre>
    # dst.put(a, 0, a.length) </pre>
    # 
    # @return  This buffer
    # 
    # @throws  BufferOverflowException
    # If there is insufficient space in this buffer
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is read-only
    def put(src)
      return put(src, 0, src.attr_length)
    end
    
    typesig { [] }
    # -- Other stuff --
    # 
    # Tells whether or not this buffer is backed by an accessible float
    # array.
    # 
    # <p> If this method returns <tt>true</tt> then the {@link #array() array}
    # and {@link #arrayOffset() arrayOffset} methods may safely be invoked.
    # </p>
    # 
    # @return  <tt>true</tt> if, and only if, this buffer
    # is backed by an array and is not read-only
    def has_array
      return (!(@hb).nil?) && !@is_read_only
    end
    
    typesig { [] }
    # Returns the float array that backs this
    # buffer&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> Modifications to this buffer's content will cause the returned
    # array's content to be modified, and vice versa.
    # 
    # <p> Invoke the {@link #hasArray hasArray} method before invoking this
    # method in order to ensure that this buffer has an accessible backing
    # array.  </p>
    # 
    # @return  The array that backs this buffer
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is backed by an array but is read-only
    # 
    # @throws  UnsupportedOperationException
    # If this buffer is not backed by an accessible array
    def array
      if ((@hb).nil?)
        raise UnsupportedOperationException.new
      end
      if (@is_read_only)
        raise ReadOnlyBufferException.new
      end
      return @hb
    end
    
    typesig { [] }
    # Returns the offset within this buffer's backing array of the first
    # element of the buffer&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> If this buffer is backed by an array then buffer position <i>p</i>
    # corresponds to array index <i>p</i>&nbsp;+&nbsp;<tt>arrayOffset()</tt>.
    # 
    # <p> Invoke the {@link #hasArray hasArray} method before invoking this
    # method in order to ensure that this buffer has an accessible backing
    # array.  </p>
    # 
    # @return  The offset within this buffer's array
    # of the first element of the buffer
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is backed by an array but is read-only
    # 
    # @throws  UnsupportedOperationException
    # If this buffer is not backed by an accessible array
    def array_offset
      if ((@hb).nil?)
        raise UnsupportedOperationException.new
      end
      if (@is_read_only)
        raise ReadOnlyBufferException.new
      end
      return @offset
    end
    
    typesig { [] }
    # Compacts this buffer&nbsp;&nbsp;<i>(optional operation)</i>.
    # 
    # <p> The floats between the buffer's current position and its limit,
    # if any, are copied to the beginning of the buffer.  That is, the
    # float at index <i>p</i>&nbsp;=&nbsp;<tt>position()</tt> is copied
    # to index zero, the float at index <i>p</i>&nbsp;+&nbsp;1 is copied
    # to index one, and so forth until the float at index
    # <tt>limit()</tt>&nbsp;-&nbsp;1 is copied to index
    # <i>n</i>&nbsp;=&nbsp;<tt>limit()</tt>&nbsp;-&nbsp;<tt>1</tt>&nbsp;-&nbsp;<i>p</i>.
    # The buffer's position is then set to <i>n+1</i> and its limit is set to
    # its capacity.  The mark, if defined, is discarded.
    # 
    # <p> The buffer's position is set to the number of floats copied,
    # rather than to zero, so that an invocation of this method can be
    # followed immediately by an invocation of another relative <i>put</i>
    # method. </p>
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # @return  This buffer
    # 
    # @throws  ReadOnlyBufferException
    # If this buffer is read-only
    def compact
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether or not this float buffer is direct. </p>
    # 
    # @return  <tt>true</tt> if, and only if, this buffer is direct
    def is_direct
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a string summarizing the state of this buffer.  </p>
    # 
    # @return  A summary string
    def to_s
      sb = StringBuffer.new
      sb.append(get_class.get_name)
      sb.append("[pos=")
      sb.append(position)
      sb.append(" lim=")
      sb.append(limit)
      sb.append(" cap=")
      sb.append(capacity)
      sb.append("]")
      return sb.to_s
    end
    
    typesig { [] }
    # Returns the current hash code of this buffer.
    # 
    # <p> The hash code of a float buffer depends only upon its remaining
    # elements; that is, upon the elements from <tt>position()</tt> up to, and
    # including, the element at <tt>limit()</tt>&nbsp;-&nbsp;<tt>1</tt>.
    # 
    # <p> Because buffer hash codes are content-dependent, it is inadvisable
    # to use buffers as keys in hash maps or similar data structures unless it
    # is known that their contents will not change.  </p>
    # 
    # @return  The current hash code of this buffer
    def hash_code
      h = 1
      p = position
      i = limit - 1
      while i >= p
        h = 31 * h + RJava.cast_to_int(get(i))
        i -= 1
      end
      return h
    end
    
    typesig { [Object] }
    # Tells whether or not this buffer is equal to another object.
    # 
    # <p> Two float buffers are equal if, and only if,
    # 
    # <p><ol>
    # 
    # <li><p> They have the same element type,  </p></li>
    # 
    # <li><p> They have the same number of remaining elements, and
    # </p></li>
    # 
    # <li><p> The two sequences of remaining elements, considered
    # independently of their starting positions, are pointwise equal.
    # </p></li>
    # 
    # </ol>
    # 
    # <p> A float buffer is not equal to any other type of object.  </p>
    # 
    # @param  ob  The object to which this buffer is to be compared
    # 
    # @return  <tt>true</tt> if, and only if, this buffer is equal to the
    # given object
    def ==(ob)
      if ((self).equal?(ob))
        return true
      end
      if (!(ob.is_a?(FloatBuffer)))
        return false
      end
      that = ob
      if (!(self.remaining).equal?(that.remaining))
        return false
      end
      p = self.position
      i = self.limit - 1
      j = that.limit - 1
      while i >= p
        v1 = self.get(i)
        v2 = that.get(j)
        if (!(v1).equal?(v2))
          if ((!(v1).equal?(v1)) && (!(v2).equal?(v2)))
            # For float and double
            i -= 1
            j -= 1
            next
          end
          return false
        end
        i -= 1
        j -= 1
      end
      return true
    end
    
    typesig { [FloatBuffer] }
    # Compares this buffer to another.
    # 
    # <p> Two float buffers are compared by comparing their sequences of
    # remaining elements lexicographically, without regard to the starting
    # position of each sequence within its corresponding buffer.
    # 
    # <p> A float buffer is not comparable to any other type of object.
    # 
    # @return  A negative integer, zero, or a positive integer as this buffer
    # is less than, equal to, or greater than the given buffer
    def compare_to(that)
      n = self.position + Math.min(self.remaining, that.remaining)
      i = self.position
      j = that.position
      while i < n
        v1 = self.get(i)
        v2 = that.get(j)
        if ((v1).equal?(v2))
          i += 1
          j += 1
          next
        end
        if ((!(v1).equal?(v1)) && (!(v2).equal?(v2)))
          # For float and double
          i += 1
          j += 1
          next
        end
        if (v1 < v2)
          return -1
        end
        return +1
        i += 1
        j += 1
      end
      return self.remaining - that.remaining
    end
    
    typesig { [] }
    # -- Other char stuff --
    # -- Other byte stuff: Access to binary data --
    # 
    # Retrieves this buffer's byte order.
    # 
    # <p> The byte order of a float buffer created by allocation or by
    # wrapping an existing <tt>float</tt> array is the {@link
    # ByteOrder#nativeOrder </code>native order<code>} of the underlying
    # hardware.  The byte order of a float buffer created as a <a
    # href="ByteBuffer.html#views">view</a> of a byte buffer is that of the
    # byte buffer at the moment that the view is created.  </p>
    # 
    # @return  This buffer's byte order
    def order
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__float_buffer, :initialize
  end
  
end
