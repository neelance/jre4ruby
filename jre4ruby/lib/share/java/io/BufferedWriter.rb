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
  module BufferedWriterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Writes text to a character-output stream, buffering characters so as to
  # provide for the efficient writing of single characters, arrays, and strings.
  # 
  # <p> The buffer size may be specified, or the default size may be accepted.
  # The default is large enough for most purposes.
  # 
  # <p> A newLine() method is provided, which uses the platform's own notion of
  # line separator as defined by the system property <tt>line.separator</tt>.
  # Not all platforms use the newline character ('\n') to terminate lines.
  # Calling this method to terminate each output line is therefore preferred to
  # writing a newline character directly.
  # 
  # <p> In general, a Writer sends its output immediately to the underlying
  # character or byte stream.  Unless prompt output is required, it is advisable
  # to wrap a BufferedWriter around any Writer whose write() operations may be
  # costly, such as FileWriters and OutputStreamWriters.  For example,
  # 
  # <pre>
  # PrintWriter out
  # = new PrintWriter(new BufferedWriter(new FileWriter("foo.out")));
  # </pre>
  # 
  # will buffer the PrintWriter's output to the file.  Without buffering, each
  # invocation of a print() method would cause characters to be converted into
  # bytes that would then be written immediately to the file, which can be very
  # inefficient.
  # 
  # @see PrintWriter
  # @see FileWriter
  # @see OutputStreamWriter
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class BufferedWriter < BufferedWriterImports.const_get :Writer
    include_class_members BufferedWriterImports
    
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    attr_accessor :cb
    alias_method :attr_cb, :cb
    undef_method :cb
    alias_method :attr_cb=, :cb=
    undef_method :cb=
    
    attr_accessor :n_chars
    alias_method :attr_n_chars, :n_chars
    undef_method :n_chars
    alias_method :attr_n_chars=, :n_chars=
    undef_method :n_chars=
    
    attr_accessor :next_char
    alias_method :attr_next_char, :next_char
    undef_method :next_char
    alias_method :attr_next_char=, :next_char=
    undef_method :next_char=
    
    class_module.module_eval {
      
      def default_char_buffer_size
        defined?(@@default_char_buffer_size) ? @@default_char_buffer_size : @@default_char_buffer_size= 8192
      end
      alias_method :attr_default_char_buffer_size, :default_char_buffer_size
      
      def default_char_buffer_size=(value)
        @@default_char_buffer_size = value
      end
      alias_method :attr_default_char_buffer_size=, :default_char_buffer_size=
    }
    
    # Line separator string.  This is the value of the line.separator
    # property at the moment that the stream was created.
    attr_accessor :line_separator
    alias_method :attr_line_separator, :line_separator
    undef_method :line_separator
    alias_method :attr_line_separator=, :line_separator=
    undef_method :line_separator=
    
    typesig { [Writer] }
    # Creates a buffered character-output stream that uses a default-sized
    # output buffer.
    # 
    # @param  out  A Writer
    def initialize(out)
      initialize__buffered_writer(out, self.attr_default_char_buffer_size)
    end
    
    typesig { [Writer, ::Java::Int] }
    # Creates a new buffered character-output stream that uses an output
    # buffer of the given size.
    # 
    # @param  out  A Writer
    # @param  sz   Output-buffer size, a positive integer
    # 
    # @exception  IllegalArgumentException  If sz is <= 0
    def initialize(out, sz)
      @out = nil
      @cb = nil
      @n_chars = 0
      @next_char = 0
      @line_separator = nil
      super(out)
      if (sz <= 0)
        raise IllegalArgumentException.new("Buffer size <= 0")
      end
      @out = out
      @cb = CharArray.new(sz)
      @n_chars = sz
      @next_char = 0
      @line_separator = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("line.separator")))
    end
    
    typesig { [] }
    # Checks to make sure that the stream has not been closed
    def ensure_open
      if ((@out).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [] }
    # Flushes the output buffer to the underlying character stream, without
    # flushing the stream itself.  This method is non-private only so that it
    # may be invoked by PrintStream.
    def flush_buffer
      synchronized((self.attr_lock)) do
        ensure_open
        if ((@next_char).equal?(0))
          return
        end
        @out.write(@cb, 0, @next_char)
        @next_char = 0
      end
    end
    
    typesig { [::Java::Int] }
    # Writes a single character.
    # 
    # @exception  IOException  If an I/O error occurs
    def write(c)
      synchronized((self.attr_lock)) do
        ensure_open
        if (@next_char >= @n_chars)
          flush_buffer
        end
        @cb[((@next_char += 1) - 1)] = RJava.cast_to_char(c)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Our own little min method, to avoid loading java.lang.Math if we've run
    # out of file descriptors and we're trying to print a stack trace.
    def min(a, b)
      if (a < b)
        return a
      end
      return b
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Writes a portion of an array of characters.
    # 
    # <p> Ordinarily this method stores characters from the given array into
    # this stream's buffer, flushing the buffer to the underlying stream as
    # needed.  If the requested length is at least as large as the buffer,
    # however, then this method will flush the buffer and write the characters
    # directly to the underlying stream.  Thus redundant
    # <code>BufferedWriter</code>s will not copy data unnecessarily.
    # 
    # @param  cbuf  A character array
    # @param  off   Offset from which to start reading characters
    # @param  len   Number of characters to write
    # 
    # @exception  IOException  If an I/O error occurs
    def write(cbuf, off, len)
      synchronized((self.attr_lock)) do
        ensure_open
        if ((off < 0) || (off > cbuf.attr_length) || (len < 0) || ((off + len) > cbuf.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return
          end
        end
        if (len >= @n_chars)
          # If the request length exceeds the size of the output buffer,
          # flush the buffer and then write the data directly.  In this
          # way buffered streams will cascade harmlessly.
          flush_buffer
          @out.write(cbuf, off, len)
          return
        end
        b = off
        t = off + len
        while (b < t)
          d = min(@n_chars - @next_char, t - b)
          System.arraycopy(cbuf, b, @cb, @next_char, d)
          b += d
          @next_char += d
          if (@next_char >= @n_chars)
            flush_buffer
          end
        end
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Writes a portion of a String.
    # 
    # <p> If the value of the <tt>len</tt> parameter is negative then no
    # characters are written.  This is contrary to the specification of this
    # method in the {@linkplain java.io.Writer#write(java.lang.String,int,int)
    # superclass}, which requires that an {@link IndexOutOfBoundsException} be
    # thrown.
    # 
    # @param  s     String to be written
    # @param  off   Offset from which to start reading characters
    # @param  len   Number of characters to be written
    # 
    # @exception  IOException  If an I/O error occurs
    def write(s, off, len)
      synchronized((self.attr_lock)) do
        ensure_open
        b = off
        t = off + len
        while (b < t)
          d = min(@n_chars - @next_char, t - b)
          s.get_chars(b, b + d, @cb, @next_char)
          b += d
          @next_char += d
          if (@next_char >= @n_chars)
            flush_buffer
          end
        end
      end
    end
    
    typesig { [] }
    # Writes a line separator.  The line separator string is defined by the
    # system property <tt>line.separator</tt>, and is not necessarily a single
    # newline ('\n') character.
    # 
    # @exception  IOException  If an I/O error occurs
    def new_line
      write(@line_separator)
    end
    
    typesig { [] }
    # Flushes the stream.
    # 
    # @exception  IOException  If an I/O error occurs
    def flush
      synchronized((self.attr_lock)) do
        flush_buffer
        @out.flush
      end
    end
    
    typesig { [] }
    def close
      synchronized((self.attr_lock)) do
        if ((@out).nil?)
          return
        end
        begin
          flush_buffer
        ensure
          @out.close
          @out = nil
          @cb = nil
        end
      end
    end
    
    private
    alias_method :initialize__buffered_writer, :initialize
  end
  
end
