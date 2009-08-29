require "rjava"

# Copyright 2002-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module BaseSSLSocketImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include_const ::Java::Nio::Channels, :SocketChannel
      include ::Java::Net
      include ::Javax::Net::Ssl
    }
  end
  
  # Abstract base class for SSLSocketImpl. Its purpose is to house code with
  # no SSL related logic (or no logic at all). This makes SSLSocketImpl shorter
  # and easier to read. It contains a few constants and static methods plus
  # overridden java.net.Socket methods.
  # 
  # Methods are defined final to ensure that they are not accidentally
  # overridden in SSLSocketImpl.
  # 
  # @see javax.net.ssl.SSLSocket
  # @see SSLSocketImpl
  class BaseSSLSocketImpl < BaseSSLSocketImplImports.const_get :SSLSocket
    include_class_members BaseSSLSocketImplImports
    
    # Normally "self" is "this" ... but not when this connection is
    # layered over a preexisting socket.  If we're using an existing
    # socket, we delegate some actions to it.  Else, we delegate
    # instead to "super".  This is important to ensure that we don't
    # recurse infinitely ... e.g. close() calling itself, or doing
    # I/O in terms of our own streams.
    attr_accessor :self
    alias_method :attr_self, :self
    undef_method :self
    alias_method :attr_self=, :self=
    undef_method :self=
    
    typesig { [] }
    def initialize
      @self = nil
      super()
      @self = self
    end
    
    typesig { [Socket] }
    def initialize(socket)
      @self = nil
      super()
      @self = socket
    end
    
    class_module.module_eval {
      # CONSTANTS AND STATIC METHODS
      # 
      # 
      # TLS requires that a close_notify warning alert is sent before the
      # connection is closed in order to avoid truncation attacks. Some
      # implementations (MS IIS and others) don't do that. The property
      # below controls whether we accept that or treat it as an error.
      # 
      # The default is "false", i.e. tolerate the broken behavior.
      const_set_lazy(:PROP_NAME) { "com.sun.net.ssl.requireCloseNotify" }
      const_attr_reader  :PROP_NAME
      
      const_set_lazy(:RequireCloseNotify) { Debug.get_boolean_property(PROP_NAME, false) }
      const_attr_reader  :RequireCloseNotify
    }
    
    typesig { [] }
    # MISC SOCKET METHODS
    # 
    # 
    # Returns the unique {@link java.nio.SocketChannel SocketChannel} object
    # associated with this socket, if any.
    # @see java.net.Socket#getChannel
    def get_channel
      if ((@self).equal?(self))
        return super
      else
        return @self.get_channel
      end
    end
    
    typesig { [SocketAddress] }
    # Binds the address to the socket.
    # @see java.net.Socket#bind
    def bind(bindpoint)
      # Bind to this socket
      if ((@self).equal?(self))
        super(bindpoint)
      else
        # If we're binding on a layered socket...
        raise IOException.new("Underlying socket should already be connected")
      end
    end
    
    typesig { [] }
    # Returns the address of the endpoint this socket is connected to
    # @see java.net.Socket#getLocalSocketAddress
    def get_local_socket_address
      if ((@self).equal?(self))
        return super
      else
        return @self.get_local_socket_address
      end
    end
    
    typesig { [] }
    # Returns the address of the endpoint this socket is connected to
    # @see java.net.Socket#getRemoteSocketAddress
    def get_remote_socket_address
      if ((@self).equal?(self))
        return super
      else
        return @self.get_remote_socket_address
      end
    end
    
    typesig { [SocketAddress] }
    # Connects this socket to the server.
    # 
    # This method is either called on an unconnected SSLSocketImpl by the
    # application, or it is called in the constructor of a regular
    # SSLSocketImpl. If we are layering on top on another socket, then
    # this method should not be called, because we assume that the
    # underlying socket is already connected by the time it is passed to
    # us.
    # 
    # @param   endpoint the <code>SocketAddress</code>
    # @throws  IOException if an error occurs during the connection
    def connect(endpoint)
      connect(endpoint, 0)
    end
    
    typesig { [] }
    # Returns the connection state of the socket.
    # @see java.net.Socket#isConnected
    def is_connected
      if ((@self).equal?(self))
        return super
      else
        return @self.is_connected
      end
    end
    
    typesig { [] }
    # Returns the binding state of the socket.
    # @see java.net.Socket#isBound
    def is_bound
      if ((@self).equal?(self))
        return super
      else
        return @self.is_bound
      end
    end
    
    typesig { [] }
    # CLOSE RELATED METHODS
    # 
    # 
    # The semantics of shutdownInput is not supported in TLS 1.0
    # spec. Thus when the method is called on an SSL socket, an
    # UnsupportedOperationException will be thrown.
    # 
    # @throws UnsupportedOperationException
    def shutdown_input
      raise UnsupportedOperationException.new("The method shutdownInput()" + " is not supported in SSLSocket")
    end
    
    typesig { [] }
    # The semantics of shutdownOutput is not supported in TLS 1.0
    # spec. Thus when the method is called on an SSL socket, an
    # UnsupportedOperationException will be thrown.
    # 
    # @throws UnsupportedOperationException
    def shutdown_output
      raise UnsupportedOperationException.new("The method shutdownOutput()" + " is not supported in SSLSocket")
    end
    
    typesig { [] }
    # Returns the input state of the socket
    # @see java.net.Socket#isInputShutdown
    def is_input_shutdown
      if ((@self).equal?(self))
        return super
      else
        return @self.is_input_shutdown
      end
    end
    
    typesig { [] }
    # Returns the output state of the socket
    # @see java.net.Socket#isOutputShutdown
    def is_output_shutdown
      if ((@self).equal?(self))
        return super
      else
        return @self.is_output_shutdown
      end
    end
    
    typesig { [] }
    # Ensures that the SSL connection is closed down as cleanly
    # as possible, in case the application forgets to do so.
    # This allows SSL connections to be implicitly reclaimed,
    # rather than forcing them to be explicitly reclaimed at
    # the penalty of prematurly killing SSL sessions.
    def finalize
      begin
        close
      rescue IOException => e1
        begin
          if ((@self).equal?(self))
            SSLSocket.instance_method(:close).bind(self).call
          end
        rescue IOException => e2
          # ignore
        end
      ensure
        # We called close on the underlying socket above to
        # make doubly sure all resources got released.  We
        # don't finalize self in the case of overlain sockets,
        # that's a different object which the GC will finalize
        # separately.
        super
      end
    end
    
    typesig { [] }
    # GET ADDRESS METHODS
    # 
    # 
    # Returns the address of the remote peer for this connection.
    def get_inet_address
      if ((@self).equal?(self))
        return super
      else
        return @self.get_inet_address
      end
    end
    
    typesig { [] }
    # Gets the local address to which the socket is bound.
    # 
    # @return the local address to which the socket is bound.
    # @since   JDK1.1
    def get_local_address
      if ((@self).equal?(self))
        return super
      else
        return @self.get_local_address
      end
    end
    
    typesig { [] }
    # Returns the number of the remote port that this connection uses.
    def get_port
      if ((@self).equal?(self))
        return super
      else
        return @self.get_port
      end
    end
    
    typesig { [] }
    # Returns the number of the local port that this connection uses.
    def get_local_port
      if ((@self).equal?(self))
        return super
      else
        return @self.get_local_port
      end
    end
    
    typesig { [::Java::Boolean] }
    # SOCKET OPTION METHODS
    # 
    # 
    # Enables or disables the Nagle optimization.
    # @see java.net.Socket#setTcpNoDelay
    def set_tcp_no_delay(value)
      if ((@self).equal?(self))
        super(value)
      else
        @self.set_tcp_no_delay(value)
      end
    end
    
    typesig { [] }
    # Returns true if the Nagle optimization is disabled.  This
    # relates to low-level buffering of TCP traffic, delaying the
    # traffic to promote better throughput.
    # 
    # @see java.net.Socket#getTcpNoDelay
    def get_tcp_no_delay
      if ((@self).equal?(self))
        return super
      else
        return @self.get_tcp_no_delay
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    # Assigns the socket's linger timeout.
    # @see java.net.Socket#setSoLinger
    def set_so_linger(flag, linger)
      if ((@self).equal?(self))
        super(flag, linger)
      else
        @self.set_so_linger(flag, linger)
      end
    end
    
    typesig { [] }
    # Returns the socket's linger timeout.
    # @see java.net.Socket#getSoLinger
    def get_so_linger
      if ((@self).equal?(self))
        return super
      else
        return @self.get_so_linger
      end
    end
    
    typesig { [::Java::Int] }
    # Send one byte of urgent data on the socket.
    # @see java.net.Socket#sendUrgentData
    # At this point, there seems to be no specific requirement to support
    # this for an SSLSocket. An implementation can be provided if a need
    # arises in future.
    def send_urgent_data(data)
      raise SocketException.new("This method is not supported " + "by SSLSockets")
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable OOBINLINE (receipt of TCP urgent data) By default, this
    # option is disabled and TCP urgent data received on a socket is silently
    # discarded.
    # @see java.net.Socket#setOOBInline
    # Setting OOBInline does not have any effect on SSLSocket,
    # since currently we don't support sending urgent data.
    def set_oobinline(on)
      raise SocketException.new("This method is ineffective, since" + " sending urgent data is not supported by SSLSockets")
    end
    
    typesig { [] }
    # Tests if OOBINLINE is enabled.
    # @see java.net.Socket#getOOBInline
    def get_oobinline
      raise SocketException.new("This method is ineffective, since" + " sending urgent data is not supported by SSLSockets")
    end
    
    typesig { [] }
    # Returns the socket timeout.
    # @see java.net.Socket#getSoTimeout
    def get_so_timeout
      if ((@self).equal?(self))
        return super
      else
        return @self.get_so_timeout
      end
    end
    
    typesig { [::Java::Int] }
    def set_send_buffer_size(size)
      if ((@self).equal?(self))
        super(size)
      else
        @self.set_send_buffer_size(size)
      end
    end
    
    typesig { [] }
    def get_send_buffer_size
      if ((@self).equal?(self))
        return super
      else
        return @self.get_send_buffer_size
      end
    end
    
    typesig { [::Java::Int] }
    def set_receive_buffer_size(size)
      if ((@self).equal?(self))
        super(size)
      else
        @self.set_receive_buffer_size(size)
      end
    end
    
    typesig { [] }
    def get_receive_buffer_size
      if ((@self).equal?(self))
        return super
      else
        return @self.get_receive_buffer_size
      end
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable SO_KEEPALIVE.
    # @see java.net.Socket#setKeepAlive
    def set_keep_alive(on)
      if ((@self).equal?(self))
        super(on)
      else
        @self.set_keep_alive(on)
      end
    end
    
    typesig { [] }
    # Tests if SO_KEEPALIVE is enabled.
    # @see java.net.Socket#getKeepAlive
    def get_keep_alive
      if ((@self).equal?(self))
        return super
      else
        return @self.get_keep_alive
      end
    end
    
    typesig { [::Java::Int] }
    # Sets traffic class or type-of-service octet in the IP header for
    # packets sent from this Socket.
    # @see java.net.Socket#setTrafficClass
    def set_traffic_class(tc)
      if ((@self).equal?(self))
        super(tc)
      else
        @self.set_traffic_class(tc)
      end
    end
    
    typesig { [] }
    # Gets traffic class or type-of-service in the IP header for packets
    # sent from this Socket.
    # @see java.net.Socket#getTrafficClass
    def get_traffic_class
      if ((@self).equal?(self))
        return super
      else
        return @self.get_traffic_class
      end
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable SO_REUSEADDR.
    # @see java.net.Socket#setReuseAddress
    def set_reuse_address(on)
      if ((@self).equal?(self))
        super(on)
      else
        @self.set_reuse_address(on)
      end
    end
    
    typesig { [] }
    # Tests if SO_REUSEADDR is enabled.
    # @see java.net.Socket#getReuseAddress
    def get_reuse_address
      if ((@self).equal?(self))
        return super
      else
        return @self.get_reuse_address
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets performance preferences for this socket.
    # 
    # @see java.net.Socket#setPerformancePreferences(int, int, int)
    def set_performance_preferences(connection_time, latency, bandwidth)
      if ((@self).equal?(self))
        super(connection_time, latency, bandwidth)
      else
        @self.set_performance_preferences(connection_time, latency, bandwidth)
      end
    end
    
    private
    alias_method :initialize__base_sslsocket_impl, :initialize
  end
  
end
