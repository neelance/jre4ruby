require "rjava"

# 
# Copyright 1994-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module ByteArrayInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # A <code>ByteArrayInputStream</code> contains
  # an internal buffer that contains bytes that
  # may be read from the stream. An internal
  # counter keeps track of the next byte to
  # be supplied by the <code>read</code> method.
  # <p>
  # Closing a <tt>ByteArrayInputStream</tt> has no effect. The methods in
  # this class can be called after the stream has been closed without
  # generating an <tt>IOException</tt>.
  # 
  # @author  Arthur van Hoff
  # @see     java.io.StringBufferInputStream
  # @since   JDK1.0
  class ByteArrayInputStream < ByteArrayInputStreamImports.const_get :InputStream
    include_class_members ByteArrayInputStreamImports
    
    # 
    # An array of bytes that was provided
    # by the creator of the stream. Elements <code>buf[0]</code>
    # through <code>buf[count-1]</code> are the
    # only bytes that can ever be read from the
    # stream;  element <code>buf[pos]</code> is
    # the next byte to be read.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # 
    # The index of the next character to read from the input stream buffer.
    # This value should always be nonnegative
    # and not larger than the value of <code>count</code>.
    # The next byte to be read from the input stream buffer
    # will be <code>buf[pos]</code>.
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    # 
    # The currently marked position in the stream.
    # ByteArrayInputStream objects are marked at position zero by
    # default when constructed.  They may be marked at another
    # position within the buffer by the <code>mark()</code> method.
    # The current buffer position is set to this point by the
    # <code>reset()</code> method.
    # <p>
    # If no mark has been set, then the value of mark is the offset
    # passed to the constructor (or 0 if the offset was not supplied).
    # 
    # @since   JDK1.1
    attr_accessor :mark
    alias_method :attr_mark, :mark
    undef_method :mark
    alias_method :attr_mark=, :mark=
    undef_method :mark=
    
    # 
    # The index one greater than the last valid character in the input
    # stream buffer.
    # This value should always be nonnegative
    # and not larger than the length of <code>buf</code>.
    # It  is one greater than the position of
    # the last byte within <code>buf</code> that
    # can ever be read  from the input stream buffer.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Creates a <code>ByteArrayInputStream</code>
    # so that it  uses <code>buf</code> as its
    # buffer array.
    # The buffer array is not copied.
    # The initial value of <code>pos</code>
    # is <code>0</code> and the initial value
    # of  <code>count</code> is the length of
    # <code>buf</code>.
    # 
    # @param   buf   the input buffer.
    def initialize(buf)
      @buf = nil
      @pos = 0
      @mark = 0
      @count = 0
      super()
      @mark = 0
      @buf = buf
      @pos = 0
      @count = buf.attr_length
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Creates <code>ByteArrayInputStream</code>
    # that uses <code>buf</code> as its
    # buffer array. The initial value of <code>pos</code>
    # is <code>offset</code> and the initial value
    # of <code>count</code> is the minimum of <code>offset+length</code>
    # and <code>buf.length</code>.
    # The buffer array is not copied. The buffer's mark is
    # set to the specified offset.
    # 
    # @param   buf      the input buffer.
    # @param   offset   the offset in the buffer of the first byte to read.
    # @param   length   the maximum number of bytes to read from the buffer.
    def initialize(buf, offset, length)
      @buf = nil
      @pos = 0
      @mark = 0
      @count = 0
      super()
      @mark = 0
      @buf = buf
      @pos = offset
      @count = Math.min(offset + length, buf.attr_length)
      @mark = offset
    end
    
    typesig { [] }
    # 
    # Reads the next byte of data from this input stream. The value
    # byte is returned as an <code>int</code> in the range
    # <code>0</code> to <code>255</code>. If no byte is available
    # because the end of the stream has been reached, the value
    # <code>-1</code> is returned.
    # <p>
    # This <code>read</code> method
    # cannot block.
    # 
    # @return  the next byte of data, or <code>-1</code> if the end of the
    # stream has been reached.
    def read
      synchronized(self) do
        return (@pos < @count) ? (@buf[((@pos += 1) - 1)] & 0xff) : -1
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Reads up to <code>len</code> bytes of data into an array of bytes
    # from this input stream.
    # If <code>pos</code> equals <code>count</code>,
    # then <code>-1</code> is returned to indicate
    # end of file. Otherwise, the  number <code>k</code>
    # of bytes read is equal to the smaller of
    # <code>len</code> and <code>count-pos</code>.
    # If <code>k</code> is positive, then bytes
    # <code>buf[pos]</code> through <code>buf[pos+k-1]</code>
    # are copied into <code>b[off]</code>  through
    # <code>b[off+k-1]</code> in the manner performed
    # by <code>System.arraycopy</code>. The
    # value <code>k</code> is added into <code>pos</code>
    # and <code>k</code> is returned.
    # <p>
    # This <code>read</code> method cannot block.
    # 
    # @param   b     the buffer into which the data is read.
    # @param   off   the start offset in the destination array <code>b</code>
    # @param   len   the maximum number of bytes read.
    # @return  the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end of
    # the stream has been reached.
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    def read(b, off, len)
      synchronized(self) do
        if ((b).nil?)
          raise NullPointerException.new
        else
          if (off < 0 || len < 0 || len > b.attr_length - off)
            raise IndexOutOfBoundsException.new
          end
        end
        if (@pos >= @count)
          return -1
        end
        if (@pos + len > @count)
          len = @count - @pos
        end
        if (len <= 0)
          return 0
        end
        System.arraycopy(@buf, @pos, b, off, len)
        @pos += len
        return len
      end
    end
    
    typesig { [::Java::Long] }
    # 
    # Skips <code>n</code> bytes of input from this input stream. Fewer
    # bytes might be skipped if the end of the input stream is reached.
    # The actual number <code>k</code>
    # of bytes to be skipped is equal to the smaller
    # of <code>n</code> and  <code>count-pos</code>.
    # The value <code>k</code> is added into <code>pos</code>
    # and <code>k</code> is returned.
    # 
    # @param   n   the number of bytes to be skipped.
    # @return  the actual number of bytes skipped.
    def skip(n)
      synchronized(self) do
        if (@pos + n > @count)
          n = @count - @pos
        end
        if (n < 0)
          return 0
        end
        @pos += n
        return n
      end
    end
    
    typesig { [] }
    # 
    # Returns the number of remaining bytes that can be read (or skipped over)
    # from this input stream.
    # <p>
    # The value returned is <code>count&nbsp;- pos</code>,
    # which is the number of bytes remaining to be read from the input buffer.
    # 
    # @return  the number of remaining bytes that can be read (or skipped
    # over) from this input stream without blocking.
    def available
      synchronized(self) do
        return @count - @pos
      end
    end
    
    typesig { [] }
    # 
    # Tests if this <code>InputStream</code> supports mark/reset. The
    # <code>markSupported</code> method of <code>ByteArrayInputStream</code>
    # always returns <code>true</code>.
    # 
    # @since   JDK1.1
    def mark_supported
      return true
    end
    
    typesig { [::Java::Int] }
    # 
    # Set the current marked position in the stream.
    # ByteArrayInputStream objects are marked at position zero by
    # default when constructed.  They may be marked at another
    # position within the buffer by this method.
    # <p>
    # If no mark has been set, then the value of the mark is the
    # offset passed to the constructor (or 0 if the offset was not
    # supplied).
    # 
    # <p> Note: The <code>readAheadLimit</code> for this class
    # has no meaning.
    # 
    # @since   JDK1.1
    def mark(read_ahead_limit)
      @mark = @pos
    end
    
    typesig { [] }
    # 
    # Resets the buffer to the marked position.  The marked position
    # is 0 unless another position was marked or an offset was specified
    # in the constructor.
    def reset
      synchronized(self) do
        @pos = @mark
      end
    end
    
    typesig { [] }
    # 
    # Closing a <tt>ByteArrayInputStream</tt> has no effect. The methods in
    # this class can be called after the stream has been closed without
    # generating an <tt>IOException</tt>.
    # <p>
    def close
    end
    
    private
    alias_method :initialize__byte_array_input_stream, :initialize
  end
  
end
