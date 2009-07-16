require "rjava"

# 
# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PushbackReaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # A character-stream reader that allows characters to be pushed back into the
  # stream.
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class PushbackReader < PushbackReaderImports.const_get :FilterReader
    include_class_members PushbackReaderImports
    
    # Pushback buffer
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # Current position in buffer
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    typesig { [Reader, ::Java::Int] }
    # 
    # Creates a new pushback reader with a pushback buffer of the given size.
    # 
    # @param   in   The reader from which characters will be read
    # @param   size The size of the pushback buffer
    # @exception IllegalArgumentException if size is <= 0
    def initialize(in_, size)
      @buf = nil
      @pos = 0
      super(in_)
      if (size <= 0)
        raise IllegalArgumentException.new("size <= 0")
      end
      @buf = CharArray.new(size)
      @pos = size
    end
    
    typesig { [Reader] }
    # 
    # Creates a new pushback reader with a one-character pushback buffer.
    # 
    # @param   in  The reader from which characters will be read
    def initialize(in_)
      initialize__pushback_reader(in_, 1)
    end
    
    typesig { [] }
    # Checks to make sure that the stream has not been closed.
    def ensure_open
      if ((@buf).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [] }
    # 
    # Reads a single character.
    # 
    # @return     The character read, or -1 if the end of the stream has been
    # reached
    # 
    # @exception  IOException  If an I/O error occurs
    def read
      synchronized((self.attr_lock)) do
        ensure_open
        if (@pos < @buf.attr_length)
          return @buf[((@pos += 1) - 1)]
        else
          return super
        end
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # 
    # Reads characters into a portion of an array.
    # 
    # @param      cbuf  Destination buffer
    # @param      off   Offset at which to start writing characters
    # @param      len   Maximum number of characters to read
    # 
    # @return     The number of characters read, or -1 if the end of the
    # stream has been reached
    # 
    # @exception  IOException  If an I/O error occurs
    def read(cbuf, off, len)
      synchronized((self.attr_lock)) do
        ensure_open
        begin
          if (len <= 0)
            if (len < 0)
              raise IndexOutOfBoundsException.new
            else
              if ((off < 0) || (off > cbuf.attr_length))
                raise IndexOutOfBoundsException.new
              end
            end
            return 0
          end
          avail = @buf.attr_length - @pos
          if (avail > 0)
            if (len < avail)
              avail = len
            end
            System.arraycopy(@buf, @pos, cbuf, off, avail)
            @pos += avail
            off += avail
            len -= avail
          end
          if (len > 0)
            len = super(cbuf, off, len)
            if ((len).equal?(-1))
              return ((avail).equal?(0)) ? -1 : avail
            end
            return avail + len
          end
          return avail
        rescue ArrayIndexOutOfBoundsException => e
          raise IndexOutOfBoundsException.new
        end
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Pushes back a single character by copying it to the front of the
    # pushback buffer. After this method returns, the next character to be read
    # will have the value <code>(char)c</code>.
    # 
    # @param  c  The int value representing a character to be pushed back
    # 
    # @exception  IOException  If the pushback buffer is full,
    # or if some other I/O error occurs
    def unread(c)
      synchronized((self.attr_lock)) do
        ensure_open
        if ((@pos).equal?(0))
          raise IOException.new("Pushback buffer overflow")
        end
        @buf[(@pos -= 1)] = RJava.cast_to_char(c)
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # 
    # Pushes back a portion of an array of characters by copying it to the
    # front of the pushback buffer.  After this method returns, the next
    # character to be read will have the value <code>cbuf[off]</code>, the
    # character after that will have the value <code>cbuf[off+1]</code>, and
    # so forth.
    # 
    # @param  cbuf  Character array
    # @param  off   Offset of first character to push back
    # @param  len   Number of characters to push back
    # 
    # @exception  IOException  If there is insufficient room in the pushback
    # buffer, or if some other I/O error occurs
    def unread(cbuf, off, len)
      synchronized((self.attr_lock)) do
        ensure_open
        if (len > @pos)
          raise IOException.new("Pushback buffer overflow")
        end
        @pos -= len
        System.arraycopy(cbuf, off, @buf, @pos, len)
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # 
    # Pushes back an array of characters by copying it to the front of the
    # pushback buffer.  After this method returns, the next character to be
    # read will have the value <code>cbuf[0]</code>, the character after that
    # will have the value <code>cbuf[1]</code>, and so forth.
    # 
    # @param  cbuf  Character array to push back
    # 
    # @exception  IOException  If there is insufficient room in the pushback
    # buffer, or if some other I/O error occurs
    def unread(cbuf)
      unread(cbuf, 0, cbuf.attr_length)
    end
    
    typesig { [] }
    # 
    # Tells whether this stream is ready to be read.
    # 
    # @exception  IOException  If an I/O error occurs
    def ready
      synchronized((self.attr_lock)) do
        ensure_open
        return (@pos < @buf.attr_length) || super
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Marks the present position in the stream. The <code>mark</code>
    # for class <code>PushbackReader</code> always throws an exception.
    # 
    # @exception  IOException  Always, since mark is not supported
    def mark(read_ahead_limit)
      raise IOException.new("mark/reset not supported")
    end
    
    typesig { [] }
    # 
    # Resets the stream. The <code>reset</code> method of
    # <code>PushbackReader</code> always throws an exception.
    # 
    # @exception  IOException  Always, since reset is not supported
    def reset
      raise IOException.new("mark/reset not supported")
    end
    
    typesig { [] }
    # 
    # Tells whether this stream supports the mark() operation, which it does
    # not.
    def mark_supported
      return false
    end
    
    typesig { [] }
    # 
    # Closes the stream and releases any system resources associated with
    # it. Once the stream has been closed, further read(),
    # unread(), ready(), or skip() invocations will throw an IOException.
    # Closing a previously closed stream has no effect.
    # 
    # @exception  IOException  If an I/O error occurs
    def close
      super
      @buf = nil
    end
    
    typesig { [::Java::Long] }
    # 
    # Skips characters.  This method will block until some characters are
    # available, an I/O error occurs, or the end of the stream is reached.
    # 
    # @param  n  The number of characters to skip
    # 
    # @return    The number of characters actually skipped
    # 
    # @exception  IllegalArgumentException  If <code>n</code> is negative.
    # @exception  IOException  If an I/O error occurs
    def skip(n)
      if (n < 0)
        raise IllegalArgumentException.new("skip value is negative")
      end
      synchronized((self.attr_lock)) do
        ensure_open
        avail = @buf.attr_length - @pos
        if (avail > 0)
          if (n <= avail)
            @pos += n
            return n
          else
            @pos = @buf.attr_length
            n -= avail
          end
        end
        return avail + super(n)
      end
    end
    
    private
    alias_method :initialize__pushback_reader, :initialize
  end
  
end
