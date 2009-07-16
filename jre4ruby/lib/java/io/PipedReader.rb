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
  module PipedReaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # Piped character-input streams.
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class PipedReader < PipedReaderImports.const_get :Reader
    include_class_members PipedReaderImports
    
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
      # 
      # The size of the pipe's circular input buffer.
      const_set_lazy(:DEFAULT_PIPE_SIZE) { 1024 }
      const_attr_reader  :DEFAULT_PIPE_SIZE
    }
    
    # 
    # The circular buffer into which incoming data is placed.
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # 
    # The index of the position in the circular buffer at which the
    # next character of data will be stored when received from the connected
    # piped writer. <code>in&lt;0</code> implies the buffer is empty,
    # <code>in==out</code> implies the buffer is full
    attr_accessor :in
    alias_method :attr_in, :in
    undef_method :in
    alias_method :attr_in=, :in=
    undef_method :in=
    
    # 
    # The index of the position in the circular buffer at which the next
    # character of data will be read by this piped reader.
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    typesig { [PipedWriter] }
    # 
    # Creates a <code>PipedReader</code> so
    # that it is connected to the piped writer
    # <code>src</code>. Data written to <code>src</code>
    # will then be available as input from this stream.
    # 
    # @param      src   the stream to connect to.
    # @exception  IOException  if an I/O error occurs.
    def initialize(src)
      initialize__piped_reader(src, DEFAULT_PIPE_SIZE)
    end
    
    typesig { [PipedWriter, ::Java::Int] }
    # 
    # Creates a <code>PipedReader</code> so that it is connected
    # to the piped writer <code>src</code> and uses the specified
    # pipe size for the pipe's buffer. Data written to <code>src</code>
    # will then be  available as input from this stream.
    # 
    # @param      src       the stream to connect to.
    # @param      pipeSize  the size of the pipe's buffer.
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
    # Creates a <code>PipedReader</code> so
    # that it is not yet {@linkplain #connect(java.io.PipedWriter)
    # connected}. It must be {@linkplain java.io.PipedWriter#connect(
    # java.io.PipedReader) connected} to a <code>PipedWriter</code>
    # before being used.
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
    # Creates a <code>PipedReader</code> so that it is not yet
    # {@link #connect(java.io.PipedWriter) connected} and uses
    # the specified pipe size for the pipe's buffer.
    # It must be  {@linkplain java.io.PipedWriter#connect(
    # java.io.PipedReader) connected} to a <code>PipedWriter</code>
    # before being used.
    # 
    # @param   pipeSize the size of the pipe's buffer.
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
        raise IllegalArgumentException.new("Pipe size <= 0")
      end
      @buffer = CharArray.new(pipe_size)
    end
    
    typesig { [PipedWriter] }
    # 
    # Causes this piped reader to be connected
    # to the piped  writer <code>src</code>.
    # If this object is already connected to some
    # other piped writer, an <code>IOException</code>
    # is thrown.
    # <p>
    # If <code>src</code> is an
    # unconnected piped writer and <code>snk</code>
    # is an unconnected piped reader, they
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
    # @param      src   The piped writer to connect to.
    # @exception  IOException  if an I/O error occurs.
    def connect(src)
      src.connect(self)
    end
    
    typesig { [::Java::Int] }
    # 
    # Receives a char of data. This method will block if no input is
    # available.
    def receive(c)
      synchronized(self) do
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
        @write_side = JavaThread.current_thread
        while ((@in).equal?(@out))
          if ((!(@read_side).nil?) && !@read_side.is_alive)
            raise IOException.new("Pipe broken")
          end
          # full: kick any waiting readers
          notify_all
          begin
            wait(1000)
          rescue InterruptedException => ex
            raise Java::Io::InterruptedIOException.new
          end
        end
        if (@in < 0)
          @in = 0
          @out = 0
        end
        @buffer[((@in += 1) - 1)] = RJava.cast_to_char(c)
        if (@in >= @buffer.attr_length)
          @in = 0
        end
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # 
    # Receives data into an array of characters.  This method will
    # block until some input is available.
    def receive(c, off, len)
      synchronized(self) do
        while ((len -= 1) >= 0)
          receive(c[((off += 1) - 1)])
        end
      end
    end
    
    typesig { [] }
    # 
    # Notifies all waiting threads that the last character of data has been
    # received.
    def received_last
      synchronized(self) do
        @closed_by_writer = true
        notify_all
      end
    end
    
    typesig { [] }
    # 
    # Reads the next character of data from this piped stream.
    # If no character is available because the end of the stream
    # has been reached, the value <code>-1</code> is returned.
    # This method blocks until input data is available, the end of
    # the stream is detected, or an exception is thrown.
    # 
    # @return     the next character of data, or <code>-1</code> if the end of the
    # stream is reached.
    # @exception  IOException  if the pipe is
    # <a href=PipedInputStream.html#BROKEN> <code>broken</code></a>,
    # {@link #connect(java.io.PipedWriter) unconnected}, closed,
    # or an I/O error occurs.
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
        ret = @buffer[((@out += 1) - 1)]
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
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # 
    # Reads up to <code>len</code> characters of data from this piped
    # stream into an array of characters. Less than <code>len</code> characters
    # will be read if the end of the data stream is reached or if
    # <code>len</code> exceeds the pipe's buffer size. This method
    # blocks until at least one character of input is available.
    # 
    # @param      cbuf     the buffer into which the data is read.
    # @param      off   the start offset of the data.
    # @param      len   the maximum number of characters read.
    # @return     the total number of characters read into the buffer, or
    # <code>-1</code> if there is no more data because the end of
    # the stream has been reached.
    # @exception  IOException  if the pipe is
    # <a href=PipedInputStream.html#BROKEN> <code>broken</code></a>,
    # {@link #connect(java.io.PipedWriter) unconnected}, closed,
    # or an I/O error occurs.
    def read(cbuf, off, len)
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
        if ((off < 0) || (off > cbuf.attr_length) || (len < 0) || ((off + len) > cbuf.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
        # possibly wait on the first character
        c = read
        if (c < 0)
          return -1
        end
        cbuf[off] = RJava.cast_to_char(c)
        rlen = 1
        while ((@in >= 0) && ((len -= 1) > 0))
          cbuf[off + rlen] = @buffer[((@out += 1) - 1)]
          ((rlen += 1) - 1)
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
    # Tell whether this stream is ready to be read.  A piped character
    # stream is ready if the circular buffer is not empty.
    # 
    # @exception  IOException  if the pipe is
    # <a href=PipedInputStream.html#BROKEN> <code>broken</code></a>,
    # {@link #connect(java.io.PipedWriter) unconnected}, or closed.
    def ready
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
        if (@in < 0)
          return false
        else
          return true
        end
      end
    end
    
    typesig { [] }
    # 
    # Closes this piped stream and releases any system resources
    # associated with the stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      @in = -1
      @closed_by_reader = true
    end
    
    private
    alias_method :initialize__piped_reader, :initialize
  end
  
end
