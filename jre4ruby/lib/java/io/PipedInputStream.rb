require "rjava"

# 
# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PipedInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # A piped input stream should be connected
  # to a piped output stream; the piped  input
  # stream then provides whatever data bytes
  # are written to the piped output  stream.
  # Typically, data is read from a <code>PipedInputStream</code>
  # object by one thread  and data is written
  # to the corresponding <code>PipedOutputStream</code>
  # by some  other thread. Attempting to use
  # both objects from a single thread is not
  # recommended, as it may deadlock the thread.
  # The piped input stream contains a buffer,
  # decoupling read operations from write operations,
  # within limits.
  # A pipe is said to be <a name=BROKEN> <i>broken</i> </a> if a
  # thread that was providing data bytes to the connected
  # piped output stream is no longer alive.
  # 
  # @author  James Gosling
  # @see     java.io.PipedOutputStream
  # @since   JDK1.0
  class PipedInputStream < PipedInputStreamImports.const_get :InputStream
    include_class_members PipedInputStreamImports
    
    attr_accessor :closed_by_writer
    alias_method :attr_closed_by_writer, :closed_by_writer
    undef_method :closed_by_writer
    alias_method :attr_closed_by_writer=, :closed_by_writer=
    undef_method :closed_by_writer=
    
    attr_accessor :closed_by_reader
    alias_method :attr_closed_by_reader, :closed_by_reader
    undef_method :closed_by_reader
    alias_method :attr_closed_by_reader=, :closed_by_reader=
    undef_method :closed_by_reader=
    
    attr_accessor :connected
    alias_method :attr_connected, :connected
    undef_method :connected
    alias_method :attr_connected=, :connected=
    undef_method :connected=
    
    # REMIND: identification of the read and write sides needs to be
    # more sophisticated.  Either using thread groups (but what about
    # pipes within a thread?) or using finalization (but it may be a
    # long time until the next GC).
    attr_accessor :read_side
    alias_method :attr_read_side, :read_side
    undef_method :read_side
    alias_method :attr_read_side=, :read_side=
    undef_method :read_side=
    
    attr_accessor :write_side
    alias_method :attr_write_side, :write_side
    undef_method :write_side
    alias_method :attr_write_side=, :write_side=
    undef_method :write_side=
    
    class_module.module_eval {
      const_set_lazy(:DEFAULT_PIPE_SIZE) { 1024 }
      const_attr_reader  :DEFAULT_PIPE_SIZE
      
      # 
      # The default size of the pipe's circular input buffer.
      # @since   JDK1.1
      # 
      # This used to be a constant before the pipe size was allowed
      # to change. This field will continue to be maintained
      # for backward compatibility.
      const_set_lazy(:PIPE_SIZE) { DEFAULT_PIPE_SIZE }
      const_attr_reader  :PIPE_SIZE
    }
    
    # 
    # The circular buffer into which incoming data is placed.
    # @since   JDK1.1
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # 
    # The index of the position in the circular buffer at which the
    # next byte of data will be stored when received from the connected
    # piped output stream. <code>in&lt;0</code> implies the buffer is empty,
    # <code>in==out</code> implies the buffer is full
    # @since   JDK1.1
    attr_accessor :in
    alias_method :attr_in, :in
    undef_method :in
    alias_method :attr_in=, :in=
    undef_method :in=
    
    # 
    # The index of the position in the circular buffer at which the next
    # byte of data will be read by this piped input stream.
    # @since   JDK1.1
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    typesig { [PipedOutputStream] }
    # 
    # Creates a <code>PipedInputStream</code> so
    # that it is connected to the piped output
    # stream <code>src</code>. Data bytes written
    # to <code>src</code> will then be  available
    # as input from this stream.
    # 
    # @param      src   the stream to connect to.
    # @exception  IOException  if an I/O error occurs.
    def initialize(src)
      initialize__piped_input_stream(src, DEFAULT_PIPE_SIZE)
    end
    
    typesig { [PipedOutputStream, ::Java::Int] }
    # 
    # Creates a <code>PipedInputStream</code> so that it is
    # connected to the piped output stream
    # <code>src</code> and uses the specified pipe size for
    # the pipe's buffer.
    # Data bytes written to <code>src</code> will then
    # be available as input from this stream.
    # 
    # @param      src   the stream to connect to.
    # @param      pipeSize the size of the pipe's buffer.
    # @exception  IOException  if an I/O error occurs.
    # @exception  IllegalArgumentException if <code>pipeSize <= 0</code>.
    # @since      1.6
    def initialize(src, pipe_size)
      @closed_by_writer = false
      @closed_by_reader = false
      @connected = false
      @read_side = nil
      @write_side = nil
      @buffer = nil
      @in = 0
      @out = 0
      super()
      @closed_by_writer = false
      @closed_by_reader = false
      @connected = false
      @in = -1
      @out = 0
      init_pipe(pipe_size)
      connect(src)
    end
    
    typesig { [] }
    # 
    # Creates a <code>PipedInputStream</code> so
    # that it is not yet {@linkplain #connect(java.io.PipedOutputStream)
    # connected}.
    # It must be {@linkplain java.io.PipedOutputStream#connect(
    # java.io.PipedInputStream) connected} to a
    # <code>PipedOutputStream</code> before being used.
    def initialize
      @closed_by_writer = false
      @closed_by_reader = false
      @connected = false
      @read_side = nil
      @write_side = nil
      @buffer = nil
      @in = 0
      @out = 0
      super()
      @closed_by_writer = false
      @closed_by_reader = false
      @connected = false
      @in = -1
      @out = 0
      init_pipe(DEFAULT_PIPE_SIZE)
    end
    
    typesig { [::Java::Int] }
    # 
    # Creates a <code>PipedInputStream</code> so that it is not yet
    # {@linkplain #connect(java.io.PipedOutputStream) connected} and
    # uses the specified pipe size for the pipe's buffer.
    # It must be {@linkplain java.io.PipedOutputStream#connect(
    # java.io.PipedInputStream)
    # connected} to a <code>PipedOutputStream</code> before being used.
    # 
    # @param      pipeSize the size of the pipe's buffer.
    # @exception  IllegalArgumentException if <code>pipeSize <= 0</code>.
    # @since      1.6
    def initialize(pipe_size)
      @closed_by_writer = false
      @closed_by_reader = false
      @connected = false
      @read_side = nil
      @write_side = nil
      @buffer = nil
      @in = 0
      @out = 0
      super()
      @closed_by_writer = false
      @closed_by_reader = false
      @connected = false
      @in = -1
      @out = 0
      init_pipe(pipe_size)
    end
    
    typesig { [::Java::Int] }
    def init_pipe(pipe_size)
      if (pipe_size <= 0)
        raise IllegalArgumentException.new("Pipe Size <= 0")
      end
      @buffer = Array.typed(::Java::Byte).new(pipe_size) { 0 }
    end
    
    typesig { [PipedOutputStream] }
    # 
    # Causes this piped input stream to be connected
    # to the piped  output stream <code>src</code>.
    # If this object is already connected to some
    # other piped output  stream, an <code>IOException</code>
    # is thrown.
    # <p>
    # If <code>src</code> is an
    # unconnected piped output stream and <code>snk</code>
    # is an unconnected piped input stream, they
    # may be connected by either the call:
    # <p>
    # <pre><code>snk.connect(src)</code> </pre>
    # <p>
    # or the call:
    # <p>
    # <pre><code>src.connect(snk)</code> </pre>
    # <p>
    # The two
    # calls have the same effect.
    # 
    # @param      src   The piped output stream to connect to.
    # @exception  IOException  if an I/O error occurs.
    def connect(src)
      src.connect(self)
    end
    
    typesig { [::Java::Int] }
    # 
    # Receives a byte of data.  This method will block if no input is
    # available.
    # @param b the byte being received
    # @exception IOException If the pipe is <a href=#BROKEN> <code>broken</code></a>,
    # {@link #connect(java.io.PipedOutputStream) unconnected},
    # closed, or if an I/O error occurs.
    # @since     JDK1.1
    def receive(b)
      synchronized(self) do
        check_state_for_receive
        @write_side = JavaThread.current_thread
        if ((@in).equal?(@out))
          await_space
        end
        if (@in < 0)
          @in = 0
          @out = 0
        end
        @buffer[((@in += 1) - 1)] = (b & 0xff)
        if (@in >= @buffer.attr_length)
          @in = 0
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Receives data into an array of bytes.  This method will
    # block until some input is available.
    # @param b the buffer into which the data is received
    # @param off the start offset of the data
    # @param len the maximum number of bytes received
    # @exception IOException If the pipe is <a href=#BROKEN> broken</a>,
    # {@link #connect(java.io.PipedOutputStream) unconnected},
    # closed,or if an I/O error occurs.
    def receive(b, off, len)
      synchronized(self) do
        check_state_for_receive
        @write_side = JavaThread.current_thread
        bytes_to_transfer = len
        while (bytes_to_transfer > 0)
          if ((@in).equal?(@out))
            await_space
          end
          next_transfer_amount = 0
          if (@out < @in)
            next_transfer_amount = @buffer.attr_length - @in
          else
            if (@in < @out)
              if ((@in).equal?(-1))
                @in = @out = 0
                next_transfer_amount = @buffer.attr_length - @in
              else
                next_transfer_amount = @out - @in
              end
            end
          end
          if (next_transfer_amount > bytes_to_transfer)
            next_transfer_amount = bytes_to_transfer
          end
          raise AssertError if not ((next_transfer_amount > 0))
          System.arraycopy(b, off, @buffer, @in, next_transfer_amount)
          bytes_to_transfer -= next_transfer_amount
          off += next_transfer_amount
          @in += next_transfer_amount
          if (@in >= @buffer.attr_length)
            @in = 0
          end
        end
      end
    end
    
    typesig { [] }
    def check_state_for_receive
      if (!@connected)
        raise IOException.new("Pipe not connected")
      else
        if (@closed_by_writer || @closed_by_reader)
          raise IOException.new("Pipe closed")
        else
          if (!(@read_side).nil? && !@read_side.is_alive)
            raise IOException.new("Read end dead")
          end
        end
      end
    end
    
    typesig { [] }
    def await_space
      while ((@in).equal?(@out))
        check_state_for_receive
        # full: kick any waiting readers
        notify_all
        begin
          wait(1000)
        rescue InterruptedException => ex
          raise Java::Io::InterruptedIOException.new
        end
      end
    end
    
    typesig { [] }
    # 
    # Notifies all waiting threads that the last byte of data has been
    # received.
    def received_last
      synchronized(self) do
        @closed_by_writer = true
        notify_all
      end
    end
    
    typesig { [] }
    # 
    # Reads the next byte of data from this piped input stream. The
    # value byte is returned as an <code>int</code> in the range
    # <code>0</code> to <code>255</code>.
    # This method blocks until input data is available, the end of the
    # stream is detected, or an exception is thrown.
    # 
    # @return     the next byte of data, or <code>-1</code> if the end of the
    # stream is reached.
    # @exception  IOException  if the pipe is
    # {@link #connect(java.io.PipedOutputStream) unconnected},
    # <a href=#BROKEN> <code>broken</code></a>, closed,
    # or if an I/O error occurs.
    def read
      synchronized(self) do
        if (!@connected)
          raise IOException.new("Pipe not connected")
        else
          if (@closed_by_reader)
            raise IOException.new("Pipe closed")
          else
            if (!(@write_side).nil? && !@write_side.is_alive && !@closed_by_writer && (@in < 0))
              raise IOException.new("Write end dead")
            end
          end
        end
        @read_side = JavaThread.current_thread
        trials = 2
        while (@in < 0)
          if (@closed_by_writer)
            # closed by writer, return EOF
            return -1
          end
          if ((!(@write_side).nil?) && (!@write_side.is_alive) && ((trials -= 1) < 0))
            raise IOException.new("Pipe broken")
          end
          # might be a writer waiting
          notify_all
          begin
            wait(1000)
          rescue InterruptedException => ex
            raise Java::Io::InterruptedIOException.new
          end
        end
        ret = @buffer[((@out += 1) - 1)] & 0xff
        if (@out >= @buffer.attr_length)
          @out = 0
        end
        if ((@in).equal?(@out))
          # now empty
          @in = -1
        end
        return ret
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Reads up to <code>len</code> bytes of data from this piped input
    # stream into an array of bytes. Less than <code>len</code> bytes
    # will be read if the end of the data stream is reached or if
    # <code>len</code> exceeds the pipe's buffer size.
    # If <code>len </code> is zero, then no bytes are read and 0 is returned;
    # otherwise, the method blocks until at least 1 byte of input is
    # available, end of the stream has been detected, or an exception is
    # thrown.
    # 
    # @param      b     the buffer into which the data is read.
    # @param      off   the start offset in the destination array <code>b</code>
    # @param      len   the maximum number of bytes read.
    # @return     the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end of
    # the stream has been reached.
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    # @exception  IOException if the pipe is <a href=#BROKEN> <code>broken</code></a>,
    # {@link #connect(java.io.PipedOutputStream) unconnected},
    # closed, or if an I/O error occurs.
    def read(b, off, len)
      synchronized(self) do
        if ((b).nil?)
          raise NullPointerException.new
        else
          if (off < 0 || len < 0 || len > b.attr_length - off)
            raise IndexOutOfBoundsException.new
          else
            if ((len).equal?(0))
              return 0
            end
          end
        end
        # possibly wait on the first character
        c = read
        if (c < 0)
          return -1
        end
        b[off] = c
        rlen = 1
        while ((@in >= 0) && (len > 1))
          available = 0
          if (@in > @out)
            available = Math.min((@buffer.attr_length - @out), (@in - @out))
          else
            available = @buffer.attr_length - @out
          end
          # A byte is read beforehand outside the loop
          if (available > (len - 1))
            available = len - 1
          end
          System.arraycopy(@buffer, @out, b, off + rlen, available)
          @out += available
          rlen += available
          len -= available
          if (@out >= @buffer.attr_length)
            @out = 0
          end
          if ((@in).equal?(@out))
            # now empty
            @in = -1
          end
        end
        return rlen
      end
    end
    
    typesig { [] }
    # 
    # Returns the number of bytes that can be read from this input
    # stream without blocking.
    # 
    # @return the number of bytes that can be read from this input stream
    # without blocking, or {@code 0} if this input stream has been
    # closed by invoking its {@link #close()} method, or if the pipe
    # is {@link #connect(java.io.PipedOutputStream) unconnected}, or
    # <a href=#BROKEN> <code>broken</code></a>.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @since   JDK1.0.2
    def available
      synchronized(self) do
        if (@in < 0)
          return 0
        else
          if ((@in).equal?(@out))
            return @buffer.attr_length
          else
            if (@in > @out)
              return @in - @out
            else
              return @in + @buffer.attr_length - @out
            end
          end
        end
      end
    end
    
    typesig { [] }
    # 
    # Closes this piped input stream and releases any system resources
    # associated with the stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      @closed_by_reader = true
      synchronized((self)) do
        @in = -1
      end
    end
    
    private
    alias_method :initialize__piped_input_stream, :initialize
  end
  
end
