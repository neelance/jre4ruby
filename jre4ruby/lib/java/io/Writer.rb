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
  module WriterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Abstract class for writing to character streams.  The only methods that a
  # subclass must implement are write(char[], int, int), flush(), and close().
  # Most subclasses, however, will override some of the methods defined here in
  # order to provide higher efficiency, additional functionality, or both.
  # 
  # @see Writer
  # @see   BufferedWriter
  # @see   CharArrayWriter
  # @see   FilterWriter
  # @see   OutputStreamWriter
  # @see     FileWriter
  # @see   PipedWriter
  # @see   PrintWriter
  # @see   StringWriter
  # @see Reader
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class Writer 
    include_class_members WriterImports
    include Appendable
    include Closeable
    include Flushable
    
    # Temporary buffer used to hold writes of strings and single characters
    attr_accessor :write_buffer
    alias_method :attr_write_buffer, :write_buffer
    undef_method :write_buffer
    alias_method :attr_write_buffer=, :write_buffer=
    undef_method :write_buffer=
    
    # Size of writeBuffer, must be >= 1
    attr_accessor :write_buffer_size
    alias_method :attr_write_buffer_size, :write_buffer_size
    undef_method :write_buffer_size
    alias_method :attr_write_buffer_size=, :write_buffer_size=
    undef_method :write_buffer_size=
    
    # The object used to synchronize operations on this stream.  For
    # efficiency, a character-stream object may use an object other than
    # itself to protect critical sections.  A subclass should therefore use
    # the object in this field rather than <tt>this</tt> or a synchronized
    # method.
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    typesig { [] }
    # Creates a new character-stream writer whose critical sections will
    # synchronize on the writer itself.
    def initialize
      @write_buffer = nil
      @write_buffer_size = 1024
      @lock = nil
      @lock = self
    end
    
    typesig { [Object] }
    # Creates a new character-stream writer whose critical sections will
    # synchronize on the given object.
    # 
    # @param  lock
    # Object to synchronize on
    def initialize(lock)
      @write_buffer = nil
      @write_buffer_size = 1024
      @lock = nil
      if ((lock).nil?)
        raise NullPointerException.new
      end
      @lock = lock
    end
    
    typesig { [::Java::Int] }
    # Writes a single character.  The character to be written is contained in
    # the 16 low-order bits of the given integer value; the 16 high-order bits
    # are ignored.
    # 
    # <p> Subclasses that intend to support efficient single-character output
    # should override this method.
    # 
    # @param  c
    # int specifying a character to be written
    # 
    # @throws  IOException
    # If an I/O error occurs
    def write(c)
      synchronized((@lock)) do
        if ((@write_buffer).nil?)
          @write_buffer = CharArray.new(@write_buffer_size)
        end
        @write_buffer[0] = RJava.cast_to_char(c)
        write(@write_buffer, 0, 1)
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Writes an array of characters.
    # 
    # @param  cbuf
    # Array of characters to be written
    # 
    # @throws  IOException
    # If an I/O error occurs
    def write(cbuf)
      write(cbuf, 0, cbuf.attr_length)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Writes a portion of an array of characters.
    # 
    # @param  cbuf
    # Array of characters
    # 
    # @param  off
    # Offset from which to start writing characters
    # 
    # @param  len
    # Number of characters to write
    # 
    # @throws  IOException
    # If an I/O error occurs
    def write(cbuf, off, len)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Writes a string.
    # 
    # @param  str
    # String to be written
    # 
    # @throws  IOException
    # If an I/O error occurs
    def write(str)
      write(str, 0, str.length)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Writes a portion of a string.
    # 
    # @param  str
    # A String
    # 
    # @param  off
    # Offset from which to start writing characters
    # 
    # @param  len
    # Number of characters to write
    # 
    # @throws  IndexOutOfBoundsException
    # If <tt>off</tt> is negative, or <tt>len</tt> is negative,
    # or <tt>off+len</tt> is negative or greater than the length
    # of the given string
    # 
    # @throws  IOException
    # If an I/O error occurs
    def write(str, off, len)
      synchronized((@lock)) do
        cbuf = nil
        if (len <= @write_buffer_size)
          if ((@write_buffer).nil?)
            @write_buffer = CharArray.new(@write_buffer_size)
          end
          cbuf = @write_buffer
        else
          # Don't permanently allocate very large buffers.
          cbuf = CharArray.new(len)
        end
        str.get_chars(off, (off + len), cbuf, 0)
        write(cbuf, 0, len)
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
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @since  1.5
    def append(csq)
      if ((csq).nil?)
        write("null")
      else
        write(csq.to_s)
      end
      return self
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    # Appends a subsequence of the specified character sequence to this writer.
    # <tt>Appendable</tt>.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq, start,
    # end)</tt> when <tt>csq</tt> is not <tt>null</tt> behaves in exactly the
    # same way as the invocation
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
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @since  1.5
    def append(csq, start, end_)
      cs = ((csq).nil? ? "null" : csq)
      write(cs.sub_sequence(start, end_).to_s)
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
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @since 1.5
    def append(c)
      write(c)
      return self
    end
    
    typesig { [] }
    # Flushes the stream.  If the stream has saved any characters from the
    # various write() methods in a buffer, write them immediately to their
    # intended destination.  Then, if that destination is another character or
    # byte stream, flush it.  Thus one flush() invocation will flush all the
    # buffers in a chain of Writers and OutputStreams.
    # 
    # <p> If the intended destination of this stream is an abstraction provided
    # by the underlying operating system, for example a file, then flushing the
    # stream guarantees only that bytes previously written to the stream are
    # passed to the operating system for writing; it does not guarantee that
    # they are actually written to a physical device such as a disk drive.
    # 
    # @throws  IOException
    # If an I/O error occurs
    def flush
      raise NotImplementedError
    end
    
    typesig { [] }
    # Closes the stream, flushing it first. Once the stream has been closed,
    # further write() or flush() invocations will cause an IOException to be
    # thrown. Closing a previously closed stream has no effect.
    # 
    # @throws  IOException
    # If an I/O error occurs
    def close
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__writer, :initialize
  end
  
end
