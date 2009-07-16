require "rjava"

# 
# Copyright 1995-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module StringBufferInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # This class allows an application to create an input stream in
  # which the bytes read are supplied by the contents of a string.
  # Applications can also read bytes from a byte array by using a
  # <code>ByteArrayInputStream</code>.
  # <p>
  # Only the low eight bits of each character in the string are used by
  # this class.
  # 
  # @author     Arthur van Hoff
  # @see        java.io.ByteArrayInputStream
  # @see        java.io.StringReader
  # @since      JDK1.0
  # @deprecated This class does not properly convert characters into bytes.  As
  # of JDK&nbsp;1.1, the preferred way to create a stream from a
  # string is via the <code>StringReader</code> class.
  class StringBufferInputStream < StringBufferInputStreamImports.const_get :InputStream
    include_class_members StringBufferInputStreamImports
    
    # 
    # The string from which bytes are read.
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # 
    # The index of the next character to read from the input stream buffer.
    # 
    # @see        java.io.StringBufferInputStream#buffer
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    # 
    # The number of valid characters in the input stream buffer.
    # 
    # @see        java.io.StringBufferInputStream#buffer
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [String] }
    # 
    # Creates a string input stream to read data from the specified string.
    # 
    # @param      s   the underlying input buffer.
    def initialize(s)
      @buffer = nil
      @pos = 0
      @count = 0
      super()
      @buffer = s
      @count = s.length
    end
    
    typesig { [] }
    # 
    # Reads the next byte of data from this input stream. The value
    # byte is returned as an <code>int</code> in the range
    # <code>0</code> to <code>255</code>. If no byte is available
    # because the end of the stream has been reached, the value
    # <code>-1</code> is returned.
    # <p>
    # The <code>read</code> method of
    # <code>StringBufferInputStream</code> cannot block. It returns the
    # low eight bits of the next character in this input stream's buffer.
    # 
    # @return     the next byte of data, or <code>-1</code> if the end of the
    # stream is reached.
    def read
      synchronized(self) do
        return (@pos < @count) ? (@buffer.char_at(((@pos += 1) - 1)) & 0xff) : -1
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Reads up to <code>len</code> bytes of data from this input stream
    # into an array of bytes.
    # <p>
    # The <code>read</code> method of
    # <code>StringBufferInputStream</code> cannot block. It copies the
    # low eight bits from the characters in this input stream's buffer into
    # the byte array argument.
    # 
    # @param      b     the buffer into which the data is read.
    # @param      off   the start offset of the data.
    # @param      len   the maximum number of bytes read.
    # @return     the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end of
    # the stream has been reached.
    def read(b, off, len)
      synchronized(self) do
        if ((b).nil?)
          raise NullPointerException.new
        else
          if ((off < 0) || (off > b.attr_length) || (len < 0) || ((off + len) > b.attr_length) || ((off + len) < 0))
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
        s = @buffer
        cnt = len
        while ((cnt -= 1) >= 0)
          b[((off += 1) - 1)] = s.char_at(((@pos += 1) - 1))
        end
        return len
      end
    end
    
    typesig { [::Java::Long] }
    # 
    # Skips <code>n</code> bytes of input from this input stream. Fewer
    # bytes might be skipped if the end of the input stream is reached.
    # 
    # @param      n   the number of bytes to be skipped.
    # @return     the actual number of bytes skipped.
    def skip(n)
      synchronized(self) do
        if (n < 0)
          return 0
        end
        if (n > @count - @pos)
          n = @count - @pos
        end
        @pos += n
        return n
      end
    end
    
    typesig { [] }
    # 
    # Returns the number of bytes that can be read from the input
    # stream without blocking.
    # 
    # @return     the value of <code>count&nbsp;-&nbsp;pos</code>, which is the
    # number of bytes remaining to be read from the input buffer.
    def available
      synchronized(self) do
        return @count - @pos
      end
    end
    
    typesig { [] }
    # 
    # Resets the input stream to begin reading from the first character
    # of this input stream's underlying buffer.
    def reset
      synchronized(self) do
        @pos = 0
      end
    end
    
    private
    alias_method :initialize__string_buffer_input_stream, :initialize
  end
  
end
