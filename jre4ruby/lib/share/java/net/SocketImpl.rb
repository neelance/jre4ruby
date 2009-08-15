require "rjava"

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
module Java::Net
  module SocketImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :FileDescriptor
    }
  end
  
  # The abstract class <code>SocketImpl</code> is a common superclass
  # of all classes that actually implement sockets. It is used to
  # create both client and server sockets.
  # <p>
  # A "plain" socket implements these methods exactly as
  # described, without attempting to go through a firewall or proxy.
  # 
  # @author  unascribed
  # @since   JDK1.0
  class SocketImpl 
    include_class_members SocketImplImports
    include SocketOptions
    
    # The actual Socket object.
    attr_accessor :socket
    alias_method :attr_socket, :socket
    undef_method :socket
    alias_method :attr_socket=, :socket=
    undef_method :socket=
    
    attr_accessor :server_socket
    alias_method :attr_server_socket, :server_socket
    undef_method :server_socket
    alias_method :attr_server_socket=, :server_socket=
    undef_method :server_socket=
    
    # The file descriptor object for this socket.
    attr_accessor :fd
    alias_method :attr_fd, :fd
    undef_method :fd
    alias_method :attr_fd=, :fd=
    undef_method :fd=
    
    # The IP address of the remote end of this socket.
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    # The port number on the remote host to which this socket is connected.
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    # The local port number to which this socket is connected.
    attr_accessor :localport
    alias_method :attr_localport, :localport
    undef_method :localport
    alias_method :attr_localport=, :localport=
    undef_method :localport=
    
    typesig { [::Java::Boolean] }
    # Creates either a stream or a datagram socket.
    # 
    # @param      stream   if <code>true</code>, create a stream socket;
    # otherwise, create a datagram socket.
    # @exception  IOException  if an I/O error occurs while creating the
    # socket.
    def create(stream)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Int] }
    # Connects this socket to the specified port on the named host.
    # 
    # @param      host   the name of the remote host.
    # @param      port   the port number.
    # @exception  IOException  if an I/O error occurs when connecting to the
    # remote host.
    def connect(host, port)
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Connects this socket to the specified port number on the specified host.
    # 
    # @param      address   the IP address of the remote host.
    # @param      port      the port number.
    # @exception  IOException  if an I/O error occurs when attempting a
    # connection.
    def connect(address, port)
      raise NotImplementedError
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    # Connects this socket to the specified port number on the specified host.
    # A timeout of zero is interpreted as an infinite timeout. The connection
    # will then block until established or an error occurs.
    # 
    # @param      address   the Socket address of the remote host.
    # @param     timeout  the timeout value, in milliseconds, or zero for no timeout.
    # @exception  IOException  if an I/O error occurs when attempting a
    # connection.
    # @since 1.4
    def connect(address, timeout)
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Binds this socket to the specified local IP address and port number.
    # 
    # @param      host   an IP address that belongs to a local interface.
    # @param      port   the port number.
    # @exception  IOException  if an I/O error occurs when binding this socket.
    def bind(host, port)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum queue length for incoming connection indications
    # (a request to connect) to the <code>count</code> argument. If a
    # connection indication arrives when the queue is full, the
    # connection is refused.
    # 
    # @param      backlog   the maximum length of the queue.
    # @exception  IOException  if an I/O error occurs when creating the queue.
    def listen(backlog)
      raise NotImplementedError
    end
    
    typesig { [SocketImpl] }
    # Accepts a connection.
    # 
    # @param      s   the accepted connection.
    # @exception  IOException  if an I/O error occurs when accepting the
    # connection.
    def accept(s)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an input stream for this socket.
    # 
    # @return     a stream for reading from this socket.
    # @exception  IOException  if an I/O error occurs when creating the
    # input stream.
    def get_input_stream
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an output stream for this socket.
    # 
    # @return     an output stream for writing to this socket.
    # @exception  IOException  if an I/O error occurs when creating the
    # output stream.
    def get_output_stream
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of bytes that can be read from this socket
    # without blocking.
    # 
    # @return     the number of bytes that can be read from this socket
    # without blocking.
    # @exception  IOException  if an I/O error occurs when determining the
    # number of bytes available.
    def available
      raise NotImplementedError
    end
    
    typesig { [] }
    # Closes this socket.
    # 
    # @exception  IOException  if an I/O error occurs when closing this socket.
    def close
      raise NotImplementedError
    end
    
    typesig { [] }
    # Places the input stream for this socket at "end of stream".
    # Any data sent to this socket is acknowledged and then
    # silently discarded.
    # 
    # If you read from a socket input stream after invoking
    # shutdownInput() on the socket, the stream will return EOF.
    # 
    # @exception IOException if an I/O error occurs when shutting down this
    # socket.
    # @see java.net.Socket#shutdownOutput()
    # @see java.net.Socket#close()
    # @see java.net.Socket#setSoLinger(boolean, int)
    # @since 1.3
    def shutdown_input
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [] }
    # Disables the output stream for this socket.
    # For a TCP socket, any previously written data will be sent
    # followed by TCP's normal connection termination sequence.
    # 
    # If you write to a socket output stream after invoking
    # shutdownOutput() on the socket, the stream will throw
    # an IOException.
    # 
    # @exception IOException if an I/O error occurs when shutting down this
    # socket.
    # @see java.net.Socket#shutdownInput()
    # @see java.net.Socket#close()
    # @see java.net.Socket#setSoLinger(boolean, int)
    # @since 1.3
    def shutdown_output
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [] }
    # Returns the value of this socket's <code>fd</code> field.
    # 
    # @return  the value of this socket's <code>fd</code> field.
    # @see     java.net.SocketImpl#fd
    def get_file_descriptor
      return @fd
    end
    
    typesig { [] }
    # Returns the value of this socket's <code>address</code> field.
    # 
    # @return  the value of this socket's <code>address</code> field.
    # @see     java.net.SocketImpl#address
    def get_inet_address
      return @address
    end
    
    typesig { [] }
    # Returns the value of this socket's <code>port</code> field.
    # 
    # @return  the value of this socket's <code>port</code> field.
    # @see     java.net.SocketImpl#port
    def get_port
      return @port
    end
    
    typesig { [] }
    # Returns whether or not this SocketImpl supports sending
    # urgent data. By default, false is returned
    # unless the method is overridden in a sub-class
    # 
    # @return  true if urgent data supported
    # @see     java.net.SocketImpl#address
    # @since 1.4
    def supports_urgent_data
      return false # must be overridden in sub-class
    end
    
    typesig { [::Java::Int] }
    # Send one byte of urgent data on the socket.
    # The byte to be sent is the low eight bits of the parameter
    # @param data The byte of data to send
    # @exception IOException if there is an error
    # sending the data.
    # @since 1.4
    def send_urgent_data(data)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the value of this socket's <code>localport</code> field.
    # 
    # @return  the value of this socket's <code>localport</code> field.
    # @see     java.net.SocketImpl#localport
    def get_local_port
      return @localport
    end
    
    typesig { [Socket] }
    def set_socket(soc)
      @socket = soc
    end
    
    typesig { [] }
    def get_socket
      return @socket
    end
    
    typesig { [ServerSocket] }
    def set_server_socket(soc)
      @server_socket = soc
    end
    
    typesig { [] }
    def get_server_socket
      return @server_socket
    end
    
    typesig { [] }
    # Returns the address and port of this socket as a <code>String</code>.
    # 
    # @return  a string representation of this socket.
    def to_s
      return "Socket[addr=" + RJava.cast_to_string(get_inet_address) + ",port=" + RJava.cast_to_string(get_port) + ",localport=" + RJava.cast_to_string(get_local_port) + "]"
    end
    
    typesig { [] }
    def reset
      @address = nil
      @port = 0
      @localport = 0
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets performance preferences for this socket.
    # 
    # <p> Sockets use the TCP/IP protocol by default.  Some implementations
    # may offer alternative protocols which have different performance
    # characteristics than TCP/IP.  This method allows the application to
    # express its own preferences as to how these tradeoffs should be made
    # when the implementation chooses from the available protocols.
    # 
    # <p> Performance preferences are described by three integers
    # whose values indicate the relative importance of short connection time,
    # low latency, and high bandwidth.  The absolute values of the integers
    # are irrelevant; in order to choose a protocol the values are simply
    # compared, with larger values indicating stronger preferences. Negative
    # values represent a lower priority than positive values. If the
    # application prefers short connection time over both low latency and high
    # bandwidth, for example, then it could invoke this method with the values
    # <tt>(1, 0, 0)</tt>.  If the application prefers high bandwidth above low
    # latency, and low latency above short connection time, then it could
    # invoke this method with the values <tt>(0, 1, 2)</tt>.
    # 
    # By default, this method does nothing, unless it is overridden in a
    # a sub-class.
    # 
    # @param  connectionTime
    # An <tt>int</tt> expressing the relative importance of a short
    # connection time
    # 
    # @param  latency
    # An <tt>int</tt> expressing the relative importance of low
    # latency
    # 
    # @param  bandwidth
    # An <tt>int</tt> expressing the relative importance of high
    # bandwidth
    # 
    # @since 1.5
    def set_performance_preferences(connection_time, latency, bandwidth)
      # Not implemented yet
    end
    
    typesig { [] }
    def initialize
      @socket = nil
      @server_socket = nil
      @fd = nil
      @address = nil
      @port = 0
      @localport = 0
    end
    
    private
    alias_method :initialize__socket_impl, :initialize
  end
  
end
