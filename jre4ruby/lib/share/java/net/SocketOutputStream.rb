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
  module SocketOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio::Channels, :FileChannel
    }
  end
  
  # This stream extends FileOutputStream to implement a
  # SocketOutputStream. Note that this class should <b>NOT</b> be
  # public.
  # 
  # @author      Jonathan Payne
  # @author      Arthur van Hoff
  class SocketOutputStream < SocketOutputStreamImports.const_get :FileOutputStream
    include_class_members SocketOutputStreamImports
    
    class_module.module_eval {
      when_class_loaded do
        init
      end
    }
    
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
    # Creates a new SocketOutputStream. Can only be called
    # by a Socket. This method needs to hang on to the owner Socket so
    # that the fd will not be closed.
    # @param impl the socket output stream inplemented
    def initialize(impl)
      @impl = nil
      @temp = nil
      @socket = nil
      @closing = false
      super(impl.get_file_descriptor)
      @impl = nil
      @temp = Array.typed(::Java::Byte).new(1) { 0 }
      @socket = nil
      @closing = false
      @impl = impl
      @socket = impl.get_socket
    end
    
    typesig { [] }
    # Returns the unique {@link java.nio.channels.FileChannel FileChannel}
    # object associated with this file output stream. </p>
    # 
    # The <code>getChannel</code> method of <code>SocketOutputStream</code>
    # returns <code>null</code> since it is a socket based stream.</p>
    # 
    # @return  the file channel associated with this file output stream
    # 
    # @since 1.4
    # @spec JSR-51
    def get_channel
      return nil
    end
    
    JNI.native_method :Java_java_net_SocketOutputStream_socketWrite0, [:pointer, :long, :long, :long, :int32, :int32], :void
    typesig { [FileDescriptor, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes to the socket.
    # @param fd the FileDescriptor
    # @param b the data to be written
    # @param off the start offset in the data
    # @param len the number of bytes that are written
    # @exception IOException If an I/O error has occurred.
    def socket_write0(fd, b, off, len)
      JNI.__send__(:Java_java_net_SocketOutputStream_socketWrite0, JNI.env, self.jni_id, fd.jni_id, b.jni_id, off.to_int, len.to_int)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes to the socket with appropriate locking of the
    # FileDescriptor.
    # @param b the data to be written
    # @param off the start offset in the data
    # @param len the number of bytes that are written
    # @exception IOException If an I/O error has occurred.
    def socket_write(b, off, len)
      if (len <= 0 || off < 0 || off + len > b.attr_length)
        if ((len).equal?(0))
          return
        end
        raise ArrayIndexOutOfBoundsException.new
      end
      fd = @impl.acquire_fd
      begin
        socket_write0(fd, b, off, len)
      rescue SocketException => se
        if (se.is_a?(Sun::Net::ConnectionResetException))
          @impl.set_connection_reset_pending
          se = SocketException.new("Connection reset")
        end
        if (@impl.is_closed_or_pending)
          raise SocketException.new("Socket closed")
        else
          raise se
        end
      ensure
        @impl.release_fd
      end
    end
    
    typesig { [::Java::Int] }
    # Writes a byte to the socket.
    # @param b the data to be written
    # @exception IOException If an I/O error has occurred.
    def write(b)
      @temp[0] = b
      socket_write(@temp, 0, 1)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Writes the contents of the buffer <i>b</i> to the socket.
    # @param b the data to be written
    # @exception SocketException If an I/O error has occurred.
    def write(b)
      socket_write(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes <i>length</i> bytes from buffer <i>b</i> starting at
    # offset <i>len</i>.
    # @param b the data to be written
    # @param off the start offset in the data
    # @param len the number of bytes that are written
    # @exception SocketException If an I/O error has occurred.
    def write(b, off, len)
      socket_write(b, off, len)
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
    
    typesig { [] }
    # Overrides finalize, the fd is closed by the Socket.
    def finalize
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_net_SocketOutputStream_init, [:pointer, :long], :void
      typesig { [] }
      # Perform class load-time initializations.
      def init
        JNI.__send__(:Java_java_net_SocketOutputStream_init, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__socket_output_stream, :initialize
  end
  
end
