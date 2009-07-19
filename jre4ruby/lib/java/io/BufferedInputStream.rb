require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module BufferedInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util::Concurrent::Atomic, :AtomicReferenceFieldUpdater
    }
  end
  
  # A <code>BufferedInputStream</code> adds
  # functionality to another input stream-namely,
  # the ability to buffer the input and to
  # support the <code>mark</code> and <code>reset</code>
  # methods. When  the <code>BufferedInputStream</code>
  # is created, an internal buffer array is
  # created. As bytes  from the stream are read
  # or skipped, the internal buffer is refilled
  # as necessary  from the contained input stream,
  # many bytes at a time. The <code>mark</code>
  # operation  remembers a point in the input
  # stream and the <code>reset</code> operation
  # causes all the  bytes read since the most
  # recent <code>mark</code> operation to be
  # reread before new bytes are  taken from
  # the contained input stream.
  # 
  # @author  Arthur van Hoff
  # @since   JDK1.0
  class BufferedInputStream < BufferedInputStreamImports.const_get :FilterInputStream
    include_class_members BufferedInputStreamImports
    
    class_module.module_eval {
      
      def default_buffer_size
        defined?(@@default_buffer_size) ? @@default_buffer_size : @@default_buffer_size= 8192
      end
      alias_method :attr_default_buffer_size, :default_buffer_size
      
      def default_buffer_size=(value)
        @@default_buffer_size = value
      end
      alias_method :attr_default_buffer_size=, :default_buffer_size=
    }
    
    # The internal buffer array where the data is stored. When necessary,
    # it may be replaced by another array of
    # a different size.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    class_module.module_eval {
      # Atomic updater to provide compareAndSet for buf. This is
      # necessary because closes can be asynchronous. We use nullness
      # of buf[] as primary indicator that this stream is closed. (The
      # "in" field is also nulled out on close.)
      const_set_lazy(:BufUpdater) { AtomicReferenceFieldUpdater.new_updater(BufferedInputStream.class, Array, "buf") }
      const_attr_reader  :BufUpdater
    }
    
    # The index one greater than the index of the last valid byte in
    # the buffer.
    # This value is always
    # in the range <code>0</code> through <code>buf.length</code>;
    # elements <code>buf[0]</code>  through <code>buf[count-1]
    # </code>contain buffered input data obtained
    # from the underlying  input stream.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # The current position in the buffer. This is the index of the next
    # character to be read from the <code>buf</code> array.
    # <p>
    # This value is always in the range <code>0</code>
    # through <code>count</code>. If it is less
    # than <code>count</code>, then  <code>buf[pos]</code>
    # is the next byte to be supplied as input;
    # if it is equal to <code>count</code>, then
    # the  next <code>read</code> or <code>skip</code>
    # operation will require more bytes to be
    # read from the contained  input stream.
    # 
    # @see     java.io.BufferedInputStream#buf
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    # The value of the <code>pos</code> field at the time the last
    # <code>mark</code> method was called.
    # <p>
    # This value is always
    # in the range <code>-1</code> through <code>pos</code>.
    # If there is no marked position in  the input
    # stream, this field is <code>-1</code>. If
    # there is a marked position in the input
    # stream,  then <code>buf[markpos]</code>
    # is the first byte to be supplied as input
    # after a <code>reset</code> operation. If
    # <code>markpos</code> is not <code>-1</code>,
    # then all bytes from positions <code>buf[markpos]</code>
    # through  <code>buf[pos-1]</code> must remain
    # in the buffer array (though they may be
    # moved to  another place in the buffer array,
    # with suitable adjustments to the values
    # of <code>count</code>,  <code>pos</code>,
    # and <code>markpos</code>); they may not
    # be discarded unless and until the difference
    # between <code>pos</code> and <code>markpos</code>
    # exceeds <code>marklimit</code>.
    # 
    # @see     java.io.BufferedInputStream#mark(int)
    # @see     java.io.BufferedInputStream#pos
    attr_accessor :markpos
    alias_method :attr_markpos, :markpos
    undef_method :markpos
    alias_method :attr_markpos=, :markpos=
    undef_method :markpos=
    
    # The maximum read ahead allowed after a call to the
    # <code>mark</code> method before subsequent calls to the
    # <code>reset</code> method fail.
    # Whenever the difference between <code>pos</code>
    # and <code>markpos</code> exceeds <code>marklimit</code>,
    # then the  mark may be dropped by setting
    # <code>markpos</code> to <code>-1</code>.
    # 
    # @see     java.io.BufferedInputStream#mark(int)
    # @see     java.io.BufferedInputStream#reset()
    attr_accessor :marklimit
    alias_method :attr_marklimit, :marklimit
    undef_method :marklimit
    alias_method :attr_marklimit=, :marklimit=
    undef_method :marklimit=
    
    typesig { [] }
    # Check to make sure that underlying input stream has not been
    # nulled out due to close; if not return it;
    def get_in_if_open
      input = self.attr_in
      if ((input).nil?)
        raise IOException.new("Stream closed")
      end
      return input
    end
    
    typesig { [] }
    # Check to make sure that buffer has not been nulled out due to
    # close; if not return it;
    def get_buf_if_open
      buffer = @buf
      if ((buffer).nil?)
        raise IOException.new("Stream closed")
      end
      return buffer
    end
    
    typesig { [InputStream] }
    # Creates a <code>BufferedInputStream</code>
    # and saves its  argument, the input stream
    # <code>in</code>, for later use. An internal
    # buffer array is created and  stored in <code>buf</code>.
    # 
    # @param   in   the underlying input stream.
    def initialize(in_)
      initialize__buffered_input_stream(in_, self.attr_default_buffer_size)
    end
    
    typesig { [InputStream, ::Java::Int] }
    # Creates a <code>BufferedInputStream</code>
    # with the specified buffer size,
    # and saves its  argument, the input stream
    # <code>in</code>, for later use.  An internal
    # buffer array of length  <code>size</code>
    # is created and stored in <code>buf</code>.
    # 
    # @param   in     the underlying input stream.
    # @param   size   the buffer size.
    # @exception IllegalArgumentException if size <= 0.
    def initialize(in_, size)
      @buf = nil
      @count = 0
      @pos = 0
      @markpos = 0
      @marklimit = 0
      super(in_)
      @markpos = -1
      if (size <= 0)
        raise IllegalArgumentException.new("Buffer size <= 0")
      end
      @buf = Array.typed(::Java::Byte).new(size) { 0 }
    end
    
    typesig { [] }
    # Fills the buffer with more data, taking into account
    # shuffling and other tricks for dealing with marks.
    # Assumes that it is being called by a synchronized method.
    # This method also assumes that all data has already been read in,
    # hence pos > count.
    def fill
      buffer = get_buf_if_open
      if (@markpos < 0)
        @pos = 0
      # no mark: throw away the buffer
      else
        if (@pos >= buffer.attr_length)
          # no room left in buffer
          if (@markpos > 0)
            # can throw away early part of the buffer
            sz = @pos - @markpos
            System.arraycopy(buffer, @markpos, buffer, 0, sz)
            @pos = sz
            @markpos = 0
          else
            if (buffer.attr_length >= @marklimit)
              @markpos = -1
              # buffer got too big, invalidate mark
              @pos = 0
              # drop buffer contents
            else
              # grow buffer
              nsz = @pos * 2
              if (nsz > @marklimit)
                nsz = @marklimit
              end
              nbuf = Array.typed(::Java::Byte).new(nsz) { 0 }
              System.arraycopy(buffer, 0, nbuf, 0, @pos)
              if (!BufUpdater.compare_and_set(self, buffer, nbuf))
                # Can't replace buf if there was an async close.
                # Note: This would need to be changed if fill()
                # is ever made accessible to multiple threads.
                # But for now, the only way CAS can fail is via close.
                # assert buf == null;
                raise IOException.new("Stream closed")
              end
              buffer = nbuf
            end
          end
        end
      end
      @count = @pos
      n = get_in_if_open.read(buffer, @pos, buffer.attr_length - @pos)
      if (n > 0)
        @count = n + @pos
      end
    end
    
    typesig { [] }
    # See
    # the general contract of the <code>read</code>
    # method of <code>InputStream</code>.
    # 
    # @return     the next byte of data, or <code>-1</code> if the end of the
    # stream is reached.
    # @exception  IOException  if this input stream has been closed by
    # invoking its {@link #close()} method,
    # or an I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read
      synchronized(self) do
        if (@pos >= @count)
          fill
          if (@pos >= @count)
            return -1
          end
        end
        return get_buf_if_open[((@pos += 1) - 1)] & 0xff
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Read characters into a portion of an array, reading from the underlying
    # stream at most once if necessary.
    def read1(b, off, len)
      avail = @count - @pos
      if (avail <= 0)
        # If the requested length is at least as large as the buffer, and
        # if there is no mark/reset activity, do not bother to copy the
        # bytes into the local buffer.  In this way buffered streams will
        # cascade harmlessly.
        if (len >= get_buf_if_open.attr_length && @markpos < 0)
          return get_in_if_open.read(b, off, len)
        end
        fill
        avail = @count - @pos
        if (avail <= 0)
          return -1
        end
      end
      cnt = (avail < len) ? avail : len
      System.arraycopy(get_buf_if_open, @pos, b, off, cnt)
      @pos += cnt
      return cnt
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads bytes from this byte-input stream into the specified byte array,
    # starting at the given offset.
    # 
    # <p> This method implements the general contract of the corresponding
    # <code>{@link InputStream#read(byte[], int, int) read}</code> method of
    # the <code>{@link InputStream}</code> class.  As an additional
    # convenience, it attempts to read as many bytes as possible by repeatedly
    # invoking the <code>read</code> method of the underlying stream.  This
    # iterated <code>read</code> continues until one of the following
    # conditions becomes true: <ul>
    # 
    # <li> The specified number of bytes have been read,
    # 
    # <li> The <code>read</code> method of the underlying stream returns
    # <code>-1</code>, indicating end-of-file, or
    # 
    # <li> The <code>available</code> method of the underlying stream
    # returns zero, indicating that further input requests would block.
    # 
    # </ul> If the first <code>read</code> on the underlying stream returns
    # <code>-1</code> to indicate end-of-file then this method returns
    # <code>-1</code>.  Otherwise this method returns the number of bytes
    # actually read.
    # 
    # <p> Subclasses of this class are encouraged, but not required, to
    # attempt to read as many bytes as possible in the same fashion.
    # 
    # @param      b     destination buffer.
    # @param      off   offset at which to start storing bytes.
    # @param      len   maximum number of bytes to read.
    # @return     the number of bytes read, or <code>-1</code> if the end of
    # the stream has been reached.
    # @exception  IOException  if this input stream has been closed by
    # invoking its {@link #close()} method,
    # or an I/O error occurs.
    def read(b, off, len)
      synchronized(self) do
        get_buf_if_open # Check for closed stream
        if ((off | len | (off + len) | (b.attr_length - (off + len))) < 0)
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
        n = 0
        loop do
          nread = read1(b, off + n, len - n)
          if (nread <= 0)
            return ((n).equal?(0)) ? nread : n
          end
          n += nread
          if (n >= len)
            return n
          end
          # if not closed but no bytes available, return
          input = self.attr_in
          if (!(input).nil? && input.available <= 0)
            return n
          end
        end
      end
    end
    
    typesig { [::Java::Long] }
    # See the general contract of the <code>skip</code>
    # method of <code>InputStream</code>.
    # 
    # @exception  IOException  if the stream does not support seek,
    # or if this input stream has been closed by
    # invoking its {@link #close()} method, or an
    # I/O error occurs.
    def skip(n)
      synchronized(self) do
        get_buf_if_open # Check for closed stream
        if (n <= 0)
          return 0
        end
        avail = @count - @pos
        if (avail <= 0)
          # If no mark position set then don't keep in buffer
          if (@markpos < 0)
            return get_in_if_open.skip(n)
          end
          # Fill in buffer to save bytes for reset
          fill
          avail = @count - @pos
          if (avail <= 0)
            return 0
          end
        end
        skipped = (avail < n) ? avail : n
        @pos += skipped
        return skipped
      end
    end
    
    typesig { [] }
    # Returns an estimate of the number of bytes that can be read (or
    # skipped over) from this input stream without blocking by the next
    # invocation of a method for this input stream. The next invocation might be
    # the same thread or another thread.  A single read or skip of this
    # many bytes will not block, but may read or skip fewer bytes.
    # <p>
    # This method returns the sum of the number of bytes remaining to be read in
    # the buffer (<code>count&nbsp;- pos</code>) and the result of calling the
    # {@link java.io.FilterInputStream#in in}.available().
    # 
    # @return     an estimate of the number of bytes that can be read (or skipped
    # over) from this input stream without blocking.
    # @exception  IOException  if this input stream has been closed by
    # invoking its {@link #close()} method,
    # or an I/O error occurs.
    def available
      synchronized(self) do
        return get_in_if_open.available + (@count - @pos)
      end
    end
    
    typesig { [::Java::Int] }
    # See the general contract of the <code>mark</code>
    # method of <code>InputStream</code>.
    # 
    # @param   readlimit   the maximum limit of bytes that can be read before
    # the mark position becomes invalid.
    # @see     java.io.BufferedInputStream#reset()
    def mark(readlimit)
      synchronized(self) do
        @marklimit = readlimit
        @markpos = @pos
      end
    end
    
    typesig { [] }
    # See the general contract of the <code>reset</code>
    # method of <code>InputStream</code>.
    # <p>
    # If <code>markpos</code> is <code>-1</code>
    # (no mark has been set or the mark has been
    # invalidated), an <code>IOException</code>
    # is thrown. Otherwise, <code>pos</code> is
    # set equal to <code>markpos</code>.
    # 
    # @exception  IOException  if this stream has not been marked or,
    # if the mark has been invalidated, or the stream
    # has been closed by invoking its {@link #close()}
    # method, or an I/O error occurs.
    # @see        java.io.BufferedInputStream#mark(int)
    def reset
      synchronized(self) do
        get_buf_if_open # Cause exception if closed
        if (@markpos < 0)
          raise IOException.new("Resetting to invalid mark")
        end
        @pos = @markpos
      end
    end
    
    typesig { [] }
    # Tests if this input stream supports the <code>mark</code>
    # and <code>reset</code> methods. The <code>markSupported</code>
    # method of <code>BufferedInputStream</code> returns
    # <code>true</code>.
    # 
    # @return  a <code>boolean</code> indicating if this stream type supports
    # the <code>mark</code> and <code>reset</code> methods.
    # @see     java.io.InputStream#mark(int)
    # @see     java.io.InputStream#reset()
    def mark_supported
      return true
    end
    
    typesig { [] }
    # Closes this input stream and releases any system resources
    # associated with the stream.
    # Once the stream has been closed, further read(), available(), reset(),
    # or skip() invocations will throw an IOException.
    # Closing a previously closed stream has no effect.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      buffer = nil
      while (!((buffer = @buf)).nil?)
        if (BufUpdater.compare_and_set(self, buffer, nil))
          input = self.attr_in
          self.attr_in = nil
          if (!(input).nil?)
            input.close
          end
          return
        end
      end
    end
    
    private
    alias_method :initialize__buffered_input_stream, :initialize
  end
  
end
