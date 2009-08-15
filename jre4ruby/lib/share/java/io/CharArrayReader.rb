require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CharArrayReaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # This class implements a character buffer that can be used as a
  # character-input stream.
  # 
  # @author      Herb Jellinek
  # @since       JDK1.1
  class CharArrayReader < CharArrayReaderImports.const_get :Reader
    include_class_members CharArrayReaderImports
    
    # The character buffer.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # The current buffer position.
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    # The position of mark in buffer.
    attr_accessor :marked_pos
    alias_method :attr_marked_pos, :marked_pos
    undef_method :marked_pos
    alias_method :attr_marked_pos=, :marked_pos=
    undef_method :marked_pos=
    
    # The index of the end of this buffer.  There is not valid
    # data at or beyond this index.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [Array.typed(::Java::Char)] }
    # Creates a CharArrayReader from the specified array of chars.
    # @param buf       Input buffer (not copied)
    def initialize(buf)
      @buf = nil
      @pos = 0
      @marked_pos = 0
      @count = 0
      super()
      @marked_pos = 0
      @buf = buf
      @pos = 0
      @count = buf.attr_length
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Creates a CharArrayReader from the specified array of chars.
    # 
    # <p> The resulting reader will start reading at the given
    # <tt>offset</tt>.  The total number of <tt>char</tt> values that can be
    # read from this reader will be either <tt>length</tt> or
    # <tt>buf.length-offset</tt>, whichever is smaller.
    # 
    # @throws IllegalArgumentException
    # If <tt>offset</tt> is negative or greater than
    # <tt>buf.length</tt>, or if <tt>length</tt> is negative, or if
    # the sum of these two values is negative.
    # 
    # @param buf       Input buffer (not copied)
    # @param offset    Offset of the first char to read
    # @param length    Number of chars to read
    def initialize(buf, offset, length)
      @buf = nil
      @pos = 0
      @marked_pos = 0
      @count = 0
      super()
      @marked_pos = 0
      if ((offset < 0) || (offset > buf.attr_length) || (length < 0) || ((offset + length) < 0))
        raise IllegalArgumentException.new
      end
      @buf = buf
      @pos = offset
      @count = Math.min(offset + length, buf.attr_length)
      @marked_pos = offset
    end
    
    typesig { [] }
    # Checks to make sure that the stream has not been closed
    def ensure_open
      if ((@buf).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [] }
    # Reads a single character.
    # 
    # @exception   IOException  If an I/O error occurs
    def read
      synchronized((self.attr_lock)) do
        ensure_open
        if (@pos >= @count)
          return -1
        else
          return @buf[((@pos += 1) - 1)]
        end
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Reads characters into a portion of an array.
    # @param b  Destination buffer
    # @param off  Offset at which to start storing characters
    # @param len   Maximum number of characters to read
    # @return  The actual number of characters read, or -1 if
    # the end of the stream has been reached
    # 
    # @exception   IOException  If an I/O error occurs
    def read(b, off, len)
      synchronized((self.attr_lock)) do
        ensure_open
        if ((off < 0) || (off > b.attr_length) || (len < 0) || ((off + len) > b.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
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
    # Skips characters.  Returns the number of characters that were skipped.
    # 
    # <p>The <code>n</code> parameter may be negative, even though the
    # <code>skip</code> method of the {@link Reader} superclass throws
    # an exception in this case. If <code>n</code> is negative, then
    # this method does nothing and returns <code>0</code>.
    # 
    # @param n The number of characters to skip
    # @return       The number of characters actually skipped
    # @exception  IOException If the stream is closed, or an I/O error occurs
    def skip(n)
      synchronized((self.attr_lock)) do
        ensure_open
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
    # Tells whether this stream is ready to be read.  Character-array readers
    # are always ready to be read.
    # 
    # @exception  IOException  If an I/O error occurs
    def ready
      synchronized((self.attr_lock)) do
        ensure_open
        return (@count - @pos) > 0
      end
    end
    
    typesig { [] }
    # Tells whether this stream supports the mark() operation, which it does.
    def mark_supported
      return true
    end
    
    typesig { [::Java::Int] }
    # Marks the present position in the stream.  Subsequent calls to reset()
    # will reposition the stream to this point.
    # 
    # @param  readAheadLimit  Limit on the number of characters that may be
    # read while still preserving the mark.  Because
    # the stream's input comes from a character array,
    # there is no actual limit; hence this argument is
    # ignored.
    # 
    # @exception  IOException  If an I/O error occurs
    def mark(read_ahead_limit)
      synchronized((self.attr_lock)) do
        ensure_open
        @marked_pos = @pos
      end
    end
    
    typesig { [] }
    # Resets the stream to the most recent mark, or to the beginning if it has
    # never been marked.
    # 
    # @exception  IOException  If an I/O error occurs
    def reset
      synchronized((self.attr_lock)) do
        ensure_open
        @pos = @marked_pos
      end
    end
    
    typesig { [] }
    # Closes the stream and releases any system resources associated with
    # it.  Once the stream has been closed, further read(), ready(),
    # mark(), reset(), or skip() invocations will throw an IOException.
    # Closing a previously closed stream has no effect.
    def close
      @buf = nil
    end
    
    private
    alias_method :initialize__char_array_reader, :initialize
  end
  
end
