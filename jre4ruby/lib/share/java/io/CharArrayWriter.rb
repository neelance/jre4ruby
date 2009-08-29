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
  module CharArrayWriterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :Arrays
    }
  end
  
  # This class implements a character buffer that can be used as an Writer.
  # The buffer automatically grows when data is written to the stream.  The data
  # can be retrieved using toCharArray() and toString().
  # <P>
  # Note: Invoking close() on this class has no effect, and methods
  # of this class can be called after the stream has closed
  # without generating an IOException.
  # 
  # @author      Herb Jellinek
  # @since       JDK1.1
  class CharArrayWriter < CharArrayWriterImports.const_get :Writer
    include_class_members CharArrayWriterImports
    
    # The buffer where data is stored.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # The number of chars in the buffer.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [] }
    # Creates a new CharArrayWriter.
    def initialize
      initialize__char_array_writer(32)
    end
    
    typesig { [::Java::Int] }
    # Creates a new CharArrayWriter with the specified initial size.
    # 
    # @param initialSize  an int specifying the initial buffer size.
    # @exception IllegalArgumentException if initialSize is negative
    def initialize(initial_size)
      @buf = nil
      @count = 0
      super()
      if (initial_size < 0)
        raise IllegalArgumentException.new("Negative initial size: " + RJava.cast_to_string(initial_size))
      end
      @buf = CharArray.new(initial_size)
    end
    
    typesig { [::Java::Int] }
    # Writes a character to the buffer.
    def write(c)
      synchronized((self.attr_lock)) do
        newcount = @count + 1
        if (newcount > @buf.attr_length)
          @buf = Arrays.copy_of(@buf, Math.max(@buf.attr_length << 1, newcount))
        end
        @buf[@count] = RJava.cast_to_char(c)
        @count = newcount
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Writes characters to the buffer.
    # @param c the data to be written
    # @param off       the start offset in the data
    # @param len       the number of chars that are written
    def write(c, off, len)
      if ((off < 0) || (off > c.attr_length) || (len < 0) || ((off + len) > c.attr_length) || ((off + len) < 0))
        raise IndexOutOfBoundsException.new
      else
        if ((len).equal?(0))
          return
        end
      end
      synchronized((self.attr_lock)) do
        newcount = @count + len
        if (newcount > @buf.attr_length)
          @buf = Arrays.copy_of(@buf, Math.max(@buf.attr_length << 1, newcount))
        end
        System.arraycopy(c, off, @buf, @count, len)
        @count = newcount
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Write a portion of a string to the buffer.
    # @param  str  String to be written from
    # @param  off  Offset from which to start reading characters
    # @param  len  Number of characters to be written
    def write(str, off, len)
      synchronized((self.attr_lock)) do
        newcount = @count + len
        if (newcount > @buf.attr_length)
          @buf = Arrays.copy_of(@buf, Math.max(@buf.attr_length << 1, newcount))
        end
        str.get_chars(off, off + len, @buf, @count)
        @count = newcount
      end
    end
    
    typesig { [Writer] }
    # Writes the contents of the buffer to another character stream.
    # 
    # @param out       the output stream to write to
    # @throws IOException If an I/O error occurs.
    def write_to(out)
      synchronized((self.attr_lock)) do
        out.write(@buf, 0, @count)
      end
    end
    
    typesig { [CharSequence] }
    # Appends the specified character sequence to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.write(csq.toString()) </pre>
    # 
    # <p> Depending on the specification of <tt>toString</tt> for the
    # character sequence <tt>csq</tt>, the entire sequence may not be
    # appended. For instance, invoking the <tt>toString</tt> method of a
    # character buffer will return a subsequence whose content depends upon
    # the buffer's position and limit.
    # 
    # @param  csq
    # The character sequence to append.  If <tt>csq</tt> is
    # <tt>null</tt>, then the four characters <tt>"null"</tt> are
    # appended to this writer.
    # 
    # @return  This writer
    # 
    # @since  1.5
    def append(csq)
      s = ((csq).nil? ? "null" : csq.to_s)
      write(s, 0, s.length)
      return self
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    # Appends a subsequence of the specified character sequence to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq, start,
    # end)</tt> when <tt>csq</tt> is not <tt>null</tt>, behaves in
    # exactly the same way as the invocation
    # 
    # <pre>
    # out.write(csq.subSequence(start, end).toString()) </pre>
    # 
    # @param  csq
    # The character sequence from which a subsequence will be
    # appended.  If <tt>csq</tt> is <tt>null</tt>, then characters
    # will be appended as if <tt>csq</tt> contained the four
    # characters <tt>"null"</tt>.
    # 
    # @param  start
    # The index of the first character in the subsequence
    # 
    # @param  end
    # The index of the character following the last character in the
    # subsequence
    # 
    # @return  This writer
    # 
    # @throws  IndexOutOfBoundsException
    # If <tt>start</tt> or <tt>end</tt> are negative, <tt>start</tt>
    # is greater than <tt>end</tt>, or <tt>end</tt> is greater than
    # <tt>csq.length()</tt>
    # 
    # @since  1.5
    def append(csq, start, end_)
      s = ((csq).nil? ? "null" : csq).sub_sequence(start, end_).to_s
      write(s, 0, s.length)
      return self
    end
    
    typesig { [::Java::Char] }
    # Appends the specified character to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(c)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.write(c) </pre>
    # 
    # @param  c
    # The 16-bit character to append
    # 
    # @return  This writer
    # 
    # @since 1.5
    def append(c)
      write(c)
      return self
    end
    
    typesig { [] }
    # Resets the buffer so that you can use it again without
    # throwing away the already allocated buffer.
    def reset
      @count = 0
    end
    
    typesig { [] }
    # Returns a copy of the input data.
    # 
    # @return an array of chars copied from the input data.
    def to_char_array
      synchronized((self.attr_lock)) do
        return Arrays.copy_of(@buf, @count)
      end
    end
    
    typesig { [] }
    # Returns the current size of the buffer.
    # 
    # @return an int representing the current size of the buffer.
    def size
      return @count
    end
    
    typesig { [] }
    # Converts input data to a string.
    # @return the string.
    def to_s
      synchronized((self.attr_lock)) do
        return String.new(@buf, 0, @count)
      end
    end
    
    typesig { [] }
    # Flush the stream.
    def flush
    end
    
    typesig { [] }
    # Close the stream.  This method does not release the buffer, since its
    # contents might still be required. Note: Invoking this method in this class
    # will have no effect.
    def close
    end
    
    private
    alias_method :initialize__char_array_writer, :initialize
  end
  
end
