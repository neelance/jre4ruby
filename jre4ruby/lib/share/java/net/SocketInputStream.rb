require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module SocketInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio::Channels, :FileChannel
      include_const ::Sun::Net, :ConnectionResetException
    }
  end
  
  # This stream extends FileInputStream to implement a
  # SocketInputStream. Note that this class should <b>NOT</b> be
  # public.
  # 
  # @author      Jonathan Payne
  # @author      Arthur van Hoff
  class SocketInputStream < SocketInputStreamImports.const_get :FileInputStream
    include_class_members SocketInputStreamImports
    
    class_module.module_eval {
      when_class_loaded do
        init
      end
    }
    
    attr_accessor :eof
    alias_method :attr_eof, :eof
    undef_method :eof
    alias_method :attr_eof=, :eof=
    undef_method :eof=
    
    attr_accessor :impl
    alias_method :attr_impl, :impl
    undef_method :impl
    alias_method :attr_impl=, :impl=
    undef_method :impl=
    
    attr_accessor :temp
    alias_method :attr_temp, :temp
    undef_method :temp
    alias_method :attr_temp=, :temp=
    undef_method :temp=
    
    attr_accessor :socket
    alias_method :attr_socket, :socket
    undef_method :socket
    alias_method :attr_socket=, :socket=
    undef_method :socket=
    
    typesig { [AbstractPlainSocketImpl] }
    # Creates a new SocketInputStream. Can only be called
    # by a Socket. This method needs to hang on to the owner Socket so
    # that the fd will not be closed.
    # @param impl the implemented socket input stream
    def initialize(impl)
      @eof = false
      @impl = nil
      @temp = nil
      @socket = nil
      @closing = false
      super(impl.get_file_descriptor)
      @impl = nil
      @socket = nil
      @closing = false
      @impl = impl
      @socket = impl.get_socket
    end
    
    typesig { [] }
    # Returns the unique {@link java.nio.channels.FileChannel FileChannel}
    # object associated with this file input stream.</p>
    # 
    # The <code>getChannel</code> method of <code>SocketInputStream</code>
    # returns <code>null</code> since it is a socket based stream.</p>
    # 
    # @return  the file channel associated with this file input stream
    # 
    # @since 1.4
    # @spec JSR-51
    def get_channel
      return nil
    end
    
    JNI.load_native_method :Java_java_net_SocketInputStream_socketRead0, [:pointer, :long, :long, :long, :int32, :int32, :int32], :int32
    typesig { [FileDescriptor, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
    # Reads into an array of bytes at the specified offset using
    # the received socket primitive.
    # @param fd the FileDescriptor
    # @param b the buffer into which the data is read
    # @param off the start offset of the data
    # @param len the maximum number of bytes read
    # @param timeout the read timeout in ms
    # @return the actual number of bytes read, -1 is
    # returned when the end of the stream is reached.
    # @exception IOException If an I/O error has occurred.
    def socket_read0(fd, b, off, len, timeout)
      JNI.call_native_method(:Java_java_net_SocketInputStream_socketRead0, JNI.env, self.jni_id, fd.jni_id, b.jni_id, off.to_int, len.to_int, timeout.to_int)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reads into a byte array data from the socket.
    # @param b the buffer into which the data is read
    # @return the actual number of bytes read, -1 is
    # returned when the end of the stream is reached.
    # @exception IOException If an I/O error has occurred.
    def read(b)
      return read(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads into a byte array <i>b</i> at offset <i>off</i>,
    # <i>length</i> bytes of data.
    # @param b the buffer into which the data is read
    # @param off the start offset of the data
    # @param len the maximum number of bytes read
    # @return the actual number of bytes read, -1 is
    # returned when the end of the stream is reached.
    # @exception IOException If an I/O error has occurred.
    def read(b, off, length)
      n = 0
      # EOF already encountered
      if (@eof)
        return -1
      end
      # connection reset
      if (@impl.is_connection_reset)
        raise SocketException.new("Connection reset")
      end
      # bounds check
      if (length <= 0 || off < 0 || off + length > b.attr_length)
        if ((length).equal?(0))
          return 0
        end
        raise ArrayIndexOutOfBoundsException.new
      end
      got_reset = false
      # acquire file descriptor and do the read
      fd = @impl.acquire_fd
      begin
        n = socket_read0(fd, b, off, length, @impl.get_timeout)
        if (n > 0)
          return n
        end
      rescue ConnectionResetException => rst_exc
        got_reset = true
      ensure
        @impl.release_fd
      end
      # We receive a "connection reset" but there may be bytes still
      # buffered on the socket
      if (got_reset)
        @impl.set_connection_reset_pending
        @impl.acquire_fd
        begin
          n = socket_read0(fd, b, off, length, @impl.get_timeout)
          if (n > 0)
            return n
          end
        rescue ConnectionResetException => rst_exc
        ensure
          @impl.release_fd
        end
      end
      # If we get here we are at EOF, the socket has been closed,
      # or the connection has been reset.
      if (@impl.is_closed_or_pending)
        raise SocketException.new("Socket closed")
      end
      if (@impl.is_connection_reset_pending)
        @impl.set_connection_reset
      end
      if (@impl.is_connection_reset)
        raise SocketException.new("Connection reset")
      end
      @eof = true
      return -1
    end
    
    typesig { [] }
    # Reads a single byte from the socket.
    def read
      if (@eof)
        return -1
      end
      @temp = Array.typed(::Java::Byte).new(1) { 0 }
      n = read(@temp, 0, 1)
      if (n <= 0)
        return -1
      end
      return @temp[0] & 0xff
    end
    
    typesig { [::Java::Long] }
    # Skips n bytes of input.
    # @param n the number of bytes to skip
    # @return  the actual number of bytes skipped.
    # @exception IOException If an I/O error has occurred.
    def skip(numbytes)
      if (numbytes <= 0)
        return 0
      end
      n = numbytes
      buflen = RJava.cast_to_int(Math.min(1024, n))
      data = Array.typed(::Java::Byte).new(buflen) { 0 }
      while (n > 0)
        r = read(data, 0, RJava.cast_to_int(Math.min(buflen, n)))
        if (r < 0)
          break
        end
        n -= r
      end
      return numbytes - n
    end
    
    typesig { [] }
    # Returns the number of bytes that can be read without blocking.
    # @return the number of immediately available bytes
    def available
      return @impl.available
    end
    
    # Closes the stream.
    attr_accessor :closing
    alias_method :attr_closing, :closing
    undef_method :closing
    alias_method :attr_closing=, :closing=
    undef_method :closing=
    
    typesig { [] }
    def close
      # Prevent recursion. See BugId 4484411
      if (@closing)
        return
      end
      @closing = true
      if (!(@socket).nil?)
        if (!@socket.is_closed)
          @socket.close
        end
      else
        @impl.close
      end
      @closing = false
    end
    
    typesig { [::Java::Boolean] }
    def set_eof(eof)
      @eof = eof
    end
    
    typesig { [] }
    # Overrides finalize, the fd is closed by the Socket.
    def finalize
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_net_SocketInputStream_init, [:pointer, :long], :void
      typesig { [] }
      # Perform class load-time initializations.
      def init
        JNI.call_native_method(:Java_java_net_SocketInputStream_init, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__socket_input_stream, :initialize
  end
  
end
