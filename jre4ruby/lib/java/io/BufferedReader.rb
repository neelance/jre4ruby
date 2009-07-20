require "rjava"

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
  module BufferedReaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Reads text from a character-input stream, buffering characters so as to
  # provide for the efficient reading of characters, arrays, and lines.
  # 
  # <p> The buffer size may be specified, or the default size may be used.  The
  # default is large enough for most purposes.
  # 
  # <p> In general, each read request made of a Reader causes a corresponding
  # read request to be made of the underlying character or byte stream.  It is
  # therefore advisable to wrap a BufferedReader around any Reader whose read()
  # operations may be costly, such as FileReaders and InputStreamReaders.  For
  # example,
  # 
  # <pre>
  # BufferedReader in
  # = new BufferedReader(new FileReader("foo.in"));
  # </pre>
  # 
  # will buffer the input from the specified file.  Without buffering, each
  # invocation of read() or readLine() could cause bytes to be read from the
  # file, converted into characters, and then returned, which can be very
  # inefficient.
  # 
  # <p> Programs that use DataInputStreams for textual input can be localized by
  # replacing each DataInputStream with an appropriate BufferedReader.
  # 
  # @see FileReader
  # @see InputStreamReader
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class BufferedReader < BufferedReaderImports.const_get :Reader
    include_class_members BufferedReaderImports
    
    attr_accessor :in
    alias_method :attr_in, :in
    undef_method :in
    alias_method :attr_in=, :in=
    undef_method :in=
    
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
      const_set_lazy(:INVALIDATED) { -2 }
      const_attr_reader  :INVALIDATED
      
      const_set_lazy(:UNMARKED) { -1 }
      const_attr_reader  :UNMARKED
    }
    
    attr_accessor :marked_char
    alias_method :attr_marked_char, :marked_char
    undef_method :marked_char
    alias_method :attr_marked_char=, :marked_char=
    undef_method :marked_char=
    
    attr_accessor :read_ahead_limit
    alias_method :attr_read_ahead_limit, :read_ahead_limit
    undef_method :read_ahead_limit
    alias_method :attr_read_ahead_limit=, :read_ahead_limit=
    undef_method :read_ahead_limit=
    
    # Valid only when markedChar > 0
    # If the next character is a line feed, skip it
    attr_accessor :skip_lf
    alias_method :attr_skip_lf, :skip_lf
    undef_method :skip_lf
    alias_method :attr_skip_lf=, :skip_lf=
    undef_method :skip_lf=
    
    # The skipLF flag when the mark was set
    attr_accessor :marked_skip_lf
    alias_method :attr_marked_skip_lf, :marked_skip_lf
    undef_method :marked_skip_lf
    alias_method :attr_marked_skip_lf=, :marked_skip_lf=
    undef_method :marked_skip_lf=
    
    class_module.module_eval {
      
      def default_char_buffer_size
        defined?(@@default_char_buffer_size) ? @@default_char_buffer_size : @@default_char_buffer_size= 8192
      end
      alias_method :attr_default_char_buffer_size, :default_char_buffer_size
      
      def default_char_buffer_size=(value)
        @@default_char_buffer_size = value
      end
      alias_method :attr_default_char_buffer_size=, :default_char_buffer_size=
      
      
      def default_expected_line_length
        defined?(@@default_expected_line_length) ? @@default_expected_line_length : @@default_expected_line_length= 80
      end
      alias_method :attr_default_expected_line_length, :default_expected_line_length
      
      def default_expected_line_length=(value)
        @@default_expected_line_length = value
      end
      alias_method :attr_default_expected_line_length=, :default_expected_line_length=
    }
    
    typesig { [Reader, ::Java::Int] }
    # Creates a buffering character-input stream that uses an input buffer of
    # the specified size.
    # 
    # @param  in   A Reader
    # @param  sz   Input-buffer size
    # 
    # @exception  IllegalArgumentException  If sz is <= 0
    def initialize(in_, sz)
      @in = nil
      @cb = nil
      @n_chars = 0
      @next_char = 0
      @marked_char = 0
      @read_ahead_limit = 0
      @skip_lf = false
      @marked_skip_lf = false
      super(in_)
      @marked_char = UNMARKED
      @read_ahead_limit = 0
      @skip_lf = false
      @marked_skip_lf = false
      if (sz <= 0)
        raise IllegalArgumentException.new("Buffer size <= 0")
      end
      @in = in_
      @cb = CharArray.new(sz)
      @next_char = @n_chars = 0
    end
    
    typesig { [Reader] }
    # Creates a buffering character-input stream that uses a default-sized
    # input buffer.
    # 
    # @param  in   A Reader
    def initialize(in_)
      initialize__buffered_reader(in_, self.attr_default_char_buffer_size)
    end
    
    typesig { [] }
    # Checks to make sure that the stream has not been closed
    def ensure_open
      if ((@in).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [] }
    # Fills the input buffer, taking the mark into account if it is valid.
    def fill
      dst = 0
      if (@marked_char <= UNMARKED)
        # No mark
        dst = 0
      else
        # Marked
        delta = @next_char - @marked_char
        if (delta >= @read_ahead_limit)
          # Gone past read-ahead limit: Invalidate mark
          @marked_char = INVALIDATED
          @read_ahead_limit = 0
          dst = 0
        else
          if (@read_ahead_limit <= @cb.attr_length)
            # Shuffle in the current buffer
            System.arraycopy(@cb, @marked_char, @cb, 0, delta)
            @marked_char = 0
            dst = delta
          else
            # Reallocate buffer to accommodate read-ahead limit
            ncb = CharArray.new(@read_ahead_limit)
            System.arraycopy(@cb, @marked_char, ncb, 0, delta)
            @cb = ncb
            @marked_char = 0
            dst = delta
          end
          @next_char = @n_chars = delta
        end
      end
      n = 0
      begin
        n = @in.read(@cb, dst, @cb.attr_length - dst)
      end while ((n).equal?(0))
      if (n > 0)
        @n_chars = dst + n
        @next_char = dst
      end
    end
    
    typesig { [] }
    # Reads a single character.
    # 
    # @return The character read, as an integer in the range
    # 0 to 65535 (<tt>0x00-0xffff</tt>), or -1 if the
    # end of the stream has been reached
    # @exception  IOException  If an I/O error occurs
    def read
      synchronized((self.attr_lock)) do
        ensure_open
        loop do
          if (@next_char >= @n_chars)
            fill
            if (@next_char >= @n_chars)
              return -1
            end
          end
          if (@skip_lf)
            @skip_lf = false
            if ((@cb[@next_char]).equal?(Character.new(?\n.ord)))
              @next_char += 1
              next
            end
          end
          return @cb[((@next_char += 1) - 1)]
        end
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Reads characters into a portion of an array, reading from the underlying
    # stream if necessary.
    def read1(cbuf, off, len)
      if (@next_char >= @n_chars)
        # If the requested length is at least as large as the buffer, and
        # if there is no mark/reset activity, and if line feeds are not
        # being skipped, do not bother to copy the characters into the
        # local buffer.  In this way buffered streams will cascade
        # harmlessly.
        if (len >= @cb.attr_length && @marked_char <= UNMARKED && !@skip_lf)
          return @in.read(cbuf, off, len)
        end
        fill
      end
      if (@next_char >= @n_chars)
        return -1
      end
      if (@skip_lf)
        @skip_lf = false
        if ((@cb[@next_char]).equal?(Character.new(?\n.ord)))
          @next_char += 1
          if (@next_char >= @n_chars)
            fill
          end
          if (@next_char >= @n_chars)
            return -1
          end
        end
      end
      n = Math.min(len, @n_chars - @next_char)
      System.arraycopy(@cb, @next_char, cbuf, off, n)
      @next_char += n
      return n
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Reads characters into a portion of an array.
    # 
    # <p> This method implements the general contract of the corresponding
    # <code>{@link Reader#read(char[], int, int) read}</code> method of the
    # <code>{@link Reader}</code> class.  As an additional convenience, it
    # attempts to read as many characters as possible by repeatedly invoking
    # the <code>read</code> method of the underlying stream.  This iterated
    # <code>read</code> continues until one of the following conditions becomes
    # true: <ul>
    # 
    # <li> The specified number of characters have been read,
    # 
    # <li> The <code>read</code> method of the underlying stream returns
    # <code>-1</code>, indicating end-of-file, or
    # 
    # <li> The <code>ready</code> method of the underlying stream
    # returns <code>false</code>, indicating that further input requests
    # would block.
    # 
    # </ul> If the first <code>read</code> on the underlying stream returns
    # <code>-1</code> to indicate end-of-file then this method returns
    # <code>-1</code>.  Otherwise this method returns the number of characters
    # actually read.
    # 
    # <p> Subclasses of this class are encouraged, but not required, to
    # attempt to read as many characters as possible in the same fashion.
    # 
    # <p> Ordinarily this method takes characters from this stream's character
    # buffer, filling it from the underlying stream as necessary.  If,
    # however, the buffer is empty, the mark is not valid, and the requested
    # length is at least as large as the buffer, then this method will read
    # characters directly from the underlying stream into the given array.
    # Thus redundant <code>BufferedReader</code>s will not copy data
    # unnecessarily.
    # 
    # @param      cbuf  Destination buffer
    # @param      off   Offset at which to start storing characters
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
        n = read1(cbuf, off, len)
        if (n <= 0)
          return n
        end
        while ((n < len) && @in.ready)
          n1 = read1(cbuf, off + n, len - n)
          if (n1 <= 0)
            break
          end
          n += n1
        end
        return n
      end
    end
    
    typesig { [::Java::Boolean] }
    # Reads a line of text.  A line is considered to be terminated by any one
    # of a line feed ('\n'), a carriage return ('\r'), or a carriage return
    # followed immediately by a linefeed.
    # 
    # @param      ignoreLF  If true, the next '\n' will be skipped
    # 
    # @return     A String containing the contents of the line, not including
    # any line-termination characters, or null if the end of the
    # stream has been reached
    # 
    # @see        java.io.LineNumberReader#readLine()
    # 
    # @exception  IOException  If an I/O error occurs
    def read_line(ignore_lf)
      s = nil
      start_char = 0
      synchronized((self.attr_lock)) do
        ensure_open
        omit_lf = ignore_lf || @skip_lf
        loop do
          if (@next_char >= @n_chars)
            fill
          end
          if (@next_char >= @n_chars)
            # EOF
            if (!(s).nil? && s.length > 0)
              return s.to_s
            else
              return nil
            end
          end
          eol = false
          c = 0
          i = 0
          # Skip a leftover '\n', if necessary
          if (omit_lf && ((@cb[@next_char]).equal?(Character.new(?\n.ord))))
            @next_char += 1
          end
          @skip_lf = false
          omit_lf = false
          i = @next_char
          while i < @n_chars
            c = @cb[i]
            if (((c).equal?(Character.new(?\n.ord))) || ((c).equal?(Character.new(?\r.ord))))
              eol = true
              break
            end
            i += 1
          end
          start_char = @next_char
          @next_char = i
          if (eol)
            str = nil
            if ((s).nil?)
              str = (String.new(@cb, start_char, i - start_char)).to_s
            else
              s.append(@cb, start_char, i - start_char)
              str = (s.to_s).to_s
            end
            @next_char += 1
            if ((c).equal?(Character.new(?\r.ord)))
              @skip_lf = true
            end
            return str
          end
          if ((s).nil?)
            s = StringBuffer.new(self.attr_default_expected_line_length)
          end
          s.append(@cb, start_char, i - start_char)
        end
      end
    end
    
    typesig { [] }
    # Reads a line of text.  A line is considered to be terminated by any one
    # of a line feed ('\n'), a carriage return ('\r'), or a carriage return
    # followed immediately by a linefeed.
    # 
    # @return     A String containing the contents of the line, not including
    # any line-termination characters, or null if the end of the
    # stream has been reached
    # 
    # @exception  IOException  If an I/O error occurs
    def read_line
      return read_line(false)
    end
    
    typesig { [::Java::Long] }
    # Skips characters.
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
        r = n
        while (r > 0)
          if (@next_char >= @n_chars)
            fill
          end
          if (@next_char >= @n_chars)
            # EOF
            break
          end
          if (@skip_lf)
            @skip_lf = false
            if ((@cb[@next_char]).equal?(Character.new(?\n.ord)))
              @next_char += 1
            end
          end
          d = @n_chars - @next_char
          if (r <= d)
            @next_char += r
            r = 0
            break
          else
            r -= d
            @next_char = @n_chars
          end
        end
        return n - r
      end
    end
    
    typesig { [] }
    # Tells whether this stream is ready to be read.  A buffered character
    # stream is ready if the buffer is not empty, or if the underlying
    # character stream is ready.
    # 
    # @exception  IOException  If an I/O error occurs
    def ready
      synchronized((self.attr_lock)) do
        ensure_open
        # If newline needs to be skipped and the next char to be read
        # is a newline character, then just skip it right away.
        if (@skip_lf)
          # Note that in.ready() will return true if and only if the next
          # read on the stream will not block.
          if (@next_char >= @n_chars && @in.ready)
            fill
          end
          if (@next_char < @n_chars)
            if ((@cb[@next_char]).equal?(Character.new(?\n.ord)))
              @next_char += 1
            end
            @skip_lf = false
          end
        end
        return (@next_char < @n_chars) || @in.ready
      end
    end
    
    typesig { [] }
    # Tells whether this stream supports the mark() operation, which it does.
    def mark_supported
      return true
    end
    
    typesig { [::Java::Int] }
    # Marks the present position in the stream.  Subsequent calls to reset()
    # will attempt to reposition the stream to this point.
    # 
    # @param readAheadLimit   Limit on the number of characters that may be
    # read while still preserving the mark. An attempt
    # to reset the stream after reading characters
    # up to this limit or beyond may fail.
    # A limit value larger than the size of the input
    # buffer will cause a new buffer to be allocated
    # whose size is no smaller than limit.
    # Therefore large values should be used with care.
    # 
    # @exception  IllegalArgumentException  If readAheadLimit is < 0
    # @exception  IOException  If an I/O error occurs
    def mark(read_ahead_limit)
      if (read_ahead_limit < 0)
        raise IllegalArgumentException.new("Read-ahead limit < 0")
      end
      synchronized((self.attr_lock)) do
        ensure_open
        @read_ahead_limit = read_ahead_limit
        @marked_char = @next_char
        @marked_skip_lf = @skip_lf
      end
    end
    
    typesig { [] }
    # Resets the stream to the most recent mark.
    # 
    # @exception  IOException  If the stream has never been marked,
    # or if the mark has been invalidated
    def reset
      synchronized((self.attr_lock)) do
        ensure_open
        if (@marked_char < 0)
          raise IOException.new(((@marked_char).equal?(INVALIDATED)) ? "Mark invalid" : "Stream not marked")
        end
        @next_char = @marked_char
        @skip_lf = @marked_skip_lf
      end
    end
    
    typesig { [] }
    def close
      synchronized((self.attr_lock)) do
        if ((@in).nil?)
          return
        end
        @in.close
        @in = nil
        @cb = nil
      end
    end
    
    private
    alias_method :initialize__buffered_reader, :initialize
  end
  
end
