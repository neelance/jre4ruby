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
  module StringReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # A character stream whose source is a string.
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class StringReader < StringReaderImports.const_get :Reader
    include_class_members StringReaderImports
    
    attr_accessor :str
    alias_method :attr_str, :str
    undef_method :str
    alias_method :attr_str=, :str=
    undef_method :str=
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    attr_accessor :mark
    alias_method :attr_mark, :mark
    undef_method :mark
    alias_method :attr_mark=, :mark=
    undef_method :mark=
    
    typesig { [String] }
    # Creates a new string reader.
    # 
    # @param s  String providing the character stream.
    def initialize(s)
      @str = nil
      @length = 0
      @next = 0
      @mark = 0
      super()
      @next = 0
      @mark = 0
      @str = s
      @length = s.length
    end
    
    typesig { [] }
    # Check to make sure that the stream has not been closed
    def ensure_open
      if ((@str).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [] }
    # Reads a single character.
    # 
    # @return     The character read, or -1 if the end of the stream has been
    # reached
    # 
    # @exception  IOException  If an I/O error occurs
    def read
      synchronized((self.attr_lock)) do
        ensure_open
        if (@next >= @length)
          return -1
        end
        return @str.char_at(((@next += 1) - 1))
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
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
        if ((off < 0) || (off > cbuf.attr_length) || (len < 0) || ((off + len) > cbuf.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
        if (@next >= @length)
          return -1
        end
        n = Math.min(@length - @next, len)
        @str.get_chars(@next, @next + n, cbuf, off)
        @next += n
        return n
      end
    end
    
    typesig { [::Java::Long] }
    # Skips the specified number of characters in the stream. Returns
    # the number of characters that were skipped.
    # 
    # <p>The <code>ns</code> parameter may be negative, even though the
    # <code>skip</code> method of the {@link Reader} superclass throws
    # an exception in this case. Negative values of <code>ns</code> cause the
    # stream to skip backwards. Negative return values indicate a skip
    # backwards. It is not possible to skip backwards past the beginning of
    # the string.
    # 
    # <p>If the entire string has been read or skipped, then this method has
    # no effect and always returns 0.
    # 
    # @exception  IOException  If an I/O error occurs
    def skip(ns)
      synchronized((self.attr_lock)) do
        ensure_open
        if (@next >= @length)
          return 0
        end
        # Bound skip by beginning and end of the source
        n = Math.min(@length - @next, ns)
        n = Math.max(-@next, n)
        @next += n
        return n
      end
    end
    
    typesig { [] }
    # Tells whether this stream is ready to be read.
    # 
    # @return True if the next read() is guaranteed not to block for input
    # 
    # @exception  IOException  If the stream is closed
    def ready
      synchronized((self.attr_lock)) do
        ensure_open
        return true
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
    # the stream's input comes from a string, there
    # is no actual limit, so this argument must not
    # be negative, but is otherwise ignored.
    # 
    # @exception  IllegalArgumentException  If readAheadLimit is < 0
    # @exception  IOException  If an I/O error occurs
    def mark(read_ahead_limit)
      if (read_ahead_limit < 0)
        raise IllegalArgumentException.new("Read-ahead limit < 0")
      end
      synchronized((self.attr_lock)) do
        ensure_open
        @mark = @next
      end
    end
    
    typesig { [] }
    # Resets the stream to the most recent mark, or to the beginning of the
    # string if it has never been marked.
    # 
    # @exception  IOException  If an I/O error occurs
    def reset
      synchronized((self.attr_lock)) do
        ensure_open
        @next = @mark
      end
    end
    
    typesig { [] }
    # Closes the stream and releases any system resources associated with
    # it. Once the stream has been closed, further read(),
    # ready(), mark(), or reset() invocations will throw an IOException.
    # Closing a previously closed stream has no effect.
    def close
      @str = RJava.cast_to_string(nil)
    end
    
    private
    alias_method :initialize__string_reader, :initialize
  end
  
end
