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
  module PipedOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include ::Java::Io
    }
  end
  
  # 
  # A piped output stream can be connected to a piped input stream
  # to create a communications pipe. The piped output stream is the
  # sending end of the pipe. Typically, data is written to a
  # <code>PipedOutputStream</code> object by one thread and data is
  # read from the connected <code>PipedInputStream</code> by some
  # other thread. Attempting to use both objects from a single thread
  # is not recommended as it may deadlock the thread.
  # The pipe is said to be <a name=BROKEN> <i>broken</i> </a> if a
  # thread that was reading data bytes from the connected piped input
  # stream is no longer alive.
  # 
  # @author  James Gosling
  # @see     java.io.PipedInputStream
  # @since   JDK1.0
  class PipedOutputStream < PipedOutputStreamImports.const_get :OutputStream
    include_class_members PipedOutputStreamImports
    
    # REMIND: identification of the read and write sides needs to be
    # more sophisticated.  Either using thread groups (but what about
    # pipes within a thread?) or using finalization (but it may be a
    # long time until the next GC).
    attr_accessor :sink
    alias_method :attr_sink, :sink
    undef_method :sink
    alias_method :attr_sink=, :sink=
    undef_method :sink=
    
    typesig { [PipedInputStream] }
    # 
    # Creates a piped output stream connected to the specified piped
    # input stream. Data bytes written to this stream will then be
    # available as input from <code>snk</code>.
    # 
    # @param      snk   The piped input stream to connect to.
    # @exception  IOException  if an I/O error occurs.
    def initialize(snk)
      @sink = nil
      super()
      connect(snk)
    end
    
    typesig { [] }
    # 
    # Creates a piped output stream that is not yet connected to a
    # piped input stream. It must be connected to a piped input stream,
    # either by the receiver or the sender, before being used.
    # 
    # @see     java.io.PipedInputStream#connect(java.io.PipedOutputStream)
    # @see     java.io.PipedOutputStream#connect(java.io.PipedInputStream)
    def initialize
      @sink = nil
      super()
    end
    
    typesig { [PipedInputStream] }
    # 
    # Connects this piped output stream to a receiver. If this object
    # is already connected to some other piped input stream, an
    # <code>IOException</code> is thrown.
    # <p>
    # If <code>snk</code> is an unconnected piped input stream and
    # <code>src</code> is an unconnected piped output stream, they may
    # be connected by either the call:
    # <blockquote><pre>
    # src.connect(snk)</pre></blockquote>
    # or the call:
    # <blockquote><pre>
    # snk.connect(src)</pre></blockquote>
    # The two calls have the same effect.
    # 
    # @param      snk   the piped input stream to connect to.
    # @exception  IOException  if an I/O error occurs.
    def connect(snk)
      synchronized(self) do
        if ((snk).nil?)
          raise NullPointerException.new
        else
          if (!(@sink).nil? || snk.attr_connected)
            raise IOException.new("Already connected")
          end
        end
        @sink = snk
        snk.attr_in = -1
        snk.attr_out = 0
        snk.attr_connected = true
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Writes the specified <code>byte</code> to the piped output stream.
    # <p>
    # Implements the <code>write</code> method of <code>OutputStream</code>.
    # 
    # @param      b   the <code>byte</code> to be written.
    # @exception IOException if the pipe is <a href=#BROKEN> broken</a>,
    # {@link #connect(java.io.PipedInputStream) unconnected},
    # closed, or if an I/O error occurs.
    def write(b)
      if ((@sink).nil?)
        raise IOException.new("Pipe not connected")
      end
      @sink.receive(b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Writes <code>len</code> bytes from the specified byte array
    # starting at offset <code>off</code> to this piped output stream.
    # This method blocks until all the bytes are written to the output
    # stream.
    # 
    # @param      b     the data.
    # @param      off   the start offset in the data.
    # @param      len   the number of bytes to write.
    # @exception IOException if the pipe is <a href=#BROKEN> broken</a>,
    # {@link #connect(java.io.PipedInputStream) unconnected},
    # closed, or if an I/O error occurs.
    def write(b, off, len)
      if ((@sink).nil?)
        raise IOException.new("Pipe not connected")
      else
        if ((b).nil?)
          raise NullPointerException.new
        else
          if ((off < 0) || (off > b.attr_length) || (len < 0) || ((off + len) > b.attr_length) || ((off + len) < 0))
            raise IndexOutOfBoundsException.new
          else
            if ((len).equal?(0))
              return
            end
          end
        end
      end
      @sink.receive(b, off, len)
    end
    
    typesig { [] }
    # 
    # Flushes this output stream and forces any buffered output bytes
    # to be written out.
    # This will notify any readers that bytes are waiting in the pipe.
    # 
    # @exception IOException if an I/O error occurs.
    def flush
      synchronized(self) do
        if (!(@sink).nil?)
          synchronized((@sink)) do
            @sink.notify_all
          end
        end
      end
    end
    
    typesig { [] }
    # 
    # Closes this piped output stream and releases any system resources
    # associated with this stream. This stream may no longer be used for
    # writing bytes.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      if (!(@sink).nil?)
        @sink.received_last
      end
    end
    
    private
    alias_method :initialize__piped_output_stream, :initialize
  end
  
end
