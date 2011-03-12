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
  module PipedWriterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Piped character-output streams.
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class PipedWriter < PipedWriterImports.const_get :Writer
    include_class_members PipedWriterImports
    
    # REMIND: identification of the read and write sides needs to be
    # more sophisticated.  Either using thread groups (but what about
    # pipes within a thread?) or using finalization (but it may be a
    # long time until the next GC).
    attr_accessor :sink
    alias_method :attr_sink, :sink
    undef_method :sink
    alias_method :attr_sink=, :sink=
    undef_method :sink=
    
    # This flag records the open status of this particular writer. It
    # is independent of the status flags defined in PipedReader. It is
    # used to do a sanity check on connect.
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    typesig { [PipedReader] }
    # Creates a piped writer connected to the specified piped
    # reader. Data characters written to this stream will then be
    # available as input from <code>snk</code>.
    # 
    # @param      snk   The piped reader to connect to.
    # @exception  IOException  if an I/O error occurs.
    def initialize(snk)
      @sink = nil
      @closed = false
      super()
      @closed = false
      connect(snk)
    end
    
    typesig { [] }
    # Creates a piped writer that is not yet connected to a
    # piped reader. It must be connected to a piped reader,
    # either by the receiver or the sender, before being used.
    # 
    # @see     java.io.PipedReader#connect(java.io.PipedWriter)
    # @see     java.io.PipedWriter#connect(java.io.PipedReader)
    def initialize
      @sink = nil
      @closed = false
      super()
      @closed = false
    end
    
    typesig { [PipedReader] }
    # Connects this piped writer to a receiver. If this object
    # is already connected to some other piped reader, an
    # <code>IOException</code> is thrown.
    # <p>
    # If <code>snk</code> is an unconnected piped reader and
    # <code>src</code> is an unconnected piped writer, they may
    # be connected by either the call:
    # <blockquote><pre>
    # src.connect(snk)</pre></blockquote>
    # or the call:
    # <blockquote><pre>
    # snk.connect(src)</pre></blockquote>
    # The two calls have the same effect.
    # 
    # @param      snk   the piped reader to connect to.
    # @exception  IOException  if an I/O error occurs.
    def connect(snk)
      synchronized(self) do
        if ((snk).nil?)
          raise NullPointerException.new
        else
          if (!(@sink).nil? || snk.attr_connected)
            raise IOException.new("Already connected")
          else
            if (snk.attr_closed_by_reader || @closed)
              raise IOException.new("Pipe closed")
            end
          end
        end
        @sink = snk
        snk.attr_in = -1
        snk.attr_out = 0
        snk.attr_connected = true
      end
    end
    
    typesig { [::Java::Int] }
    # Writes the specified <code>char</code> to the piped output stream.
    # If a thread was reading data characters from the connected piped input
    # stream, but the thread is no longer alive, then an
    # <code>IOException</code> is thrown.
    # <p>
    # Implements the <code>write</code> method of <code>Writer</code>.
    # 
    # @param      c   the <code>char</code> to be written.
    # @exception  IOException  if the pipe is
    #          <a href=PipedOutputStream.html#BROKEN> <code>broken</code></a>,
    #          {@link #connect(java.io.PipedReader) unconnected}, closed
    #          or an I/O error occurs.
    def write(c)
      if ((@sink).nil?)
        raise IOException.new("Pipe not connected")
      end
      @sink.receive(c)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Writes <code>len</code> characters from the specified character array
    # starting at offset <code>off</code> to this piped output stream.
    # This method blocks until all the characters are written to the output
    # stream.
    # If a thread was reading data characters from the connected piped input
    # stream, but the thread is no longer alive, then an
    # <code>IOException</code> is thrown.
    # 
    # @param      cbuf  the data.
    # @param      off   the start offset in the data.
    # @param      len   the number of characters to write.
    # @exception  IOException  if the pipe is
    #          <a href=PipedOutputStream.html#BROKEN> <code>broken</code></a>,
    #          {@link #connect(java.io.PipedReader) unconnected}, closed
    #          or an I/O error occurs.
    def write(cbuf, off, len)
      if ((@sink).nil?)
        raise IOException.new("Pipe not connected")
      else
        if ((off | len | (off + len) | (cbuf.attr_length - (off + len))) < 0)
          raise IndexOutOfBoundsException.new
        end
      end
      @sink.receive(cbuf, off, len)
    end
    
    typesig { [] }
    # Flushes this output stream and forces any buffered output characters
    # to be written out.
    # This will notify any readers that characters are waiting in the pipe.
    # 
    # @exception  IOException  if the pipe is closed, or an I/O error occurs.
    def flush
      synchronized(self) do
        if (!(@sink).nil?)
          if (@sink.attr_closed_by_reader || @closed)
            raise IOException.new("Pipe closed")
          end
          synchronized((@sink)) do
            @sink.notify_all
          end
        end
      end
    end
    
    typesig { [] }
    # Closes this piped output stream and releases any system resources
    # associated with this stream. This stream may no longer be used for
    # writing characters.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      @closed = true
      if (!(@sink).nil?)
        @sink.received_last
      end
    end
    
    private
    alias_method :initialize__piped_writer, :initialize
  end
  
end
