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
  module SocketImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InterruptedIOException
      include_const ::Java::Nio::Channels, :SocketChannel
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This class implements client sockets (also called just
  # "sockets"). A socket is an endpoint for communication
  # between two machines.
  # <p>
  # The actual work of the socket is performed by an instance of the
  # <code>SocketImpl</code> class. An application, by changing
  # the socket factory that creates the socket implementation,
  # can configure itself to create sockets appropriate to the local
  # firewall.
  # 
  # @author  unascribed
  # @see     java.net.Socket#setSocketImplFactory(java.net.SocketImplFactory)
  # @see     java.net.SocketImpl
  # @see     java.nio.channels.SocketChannel
  # @since   JDK1.0
  class Socket 
    include_class_members SocketImports
    
    # Various states of this socket.
    attr_accessor :created
    alias_method :attr_created, :created
    undef_method :created
    alias_method :attr_created=, :created=
    undef_method :created=
    
    attr_accessor :bound
    alias_method :attr_bound, :bound
    undef_method :bound
    alias_method :attr_bound=, :bound=
    undef_method :bound=
    
    attr_accessor :connected
    alias_method :attr_connected, :connected
    undef_method :connected
    alias_method :attr_connected=, :connected=
    undef_method :connected=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    attr_accessor :close_lock
    alias_method :attr_close_lock, :close_lock
    undef_method :close_lock
    alias_method :attr_close_lock=, :close_lock=
    undef_method :close_lock=
    
    attr_accessor :shut_in
    alias_method :attr_shut_in, :shut_in
    undef_method :shut_in
    alias_method :attr_shut_in=, :shut_in=
    undef_method :shut_in=
    
    attr_accessor :shut_out
    alias_method :attr_shut_out, :shut_out
    undef_method :shut_out
    alias_method :attr_shut_out=, :shut_out=
    undef_method :shut_out=
    
    # The implementation of this Socket.
    attr_accessor :impl
    alias_method :attr_impl, :impl
    undef_method :impl
    alias_method :attr_impl=, :impl=
    undef_method :impl=
    
    # Are we using an older SocketImpl?
    attr_accessor :old_impl
    alias_method :attr_old_impl, :old_impl
    undef_method :old_impl
    alias_method :attr_old_impl=, :old_impl=
    undef_method :old_impl=
    
    typesig { [] }
    # Creates an unconnected socket, with the
    # system-default type of SocketImpl.
    # 
    # @since   JDK1.1
    # @revised 1.4
    def initialize
      @created = false
      @bound = false
      @connected = false
      @closed = false
      @close_lock = Object.new
      @shut_in = false
      @shut_out = false
      @impl = nil
      @old_impl = false
      set_impl
    end
    
    typesig { [Proxy] }
    # Creates an unconnected socket, specifying the type of proxy, if any,
    # that should be used regardless of any other settings.
    # <P>
    # If there is a security manager, its <code>checkConnect</code> method
    # is called with the proxy host address and port number
    # as its arguments. This could result in a SecurityException.
    # <P>
    # Examples:
    # <UL> <LI><code>Socket s = new Socket(Proxy.NO_PROXY);</code> will create
    # a plain socket ignoring any other proxy configuration.</LI>
    # <LI><code>Socket s = new Socket(new Proxy(Proxy.Type.SOCKS, new InetSocketAddress("socks.mydom.com", 1080)));</code>
    # will create a socket connecting through the specified SOCKS proxy
    # server.</LI>
    # </UL>
    # 
    # @param proxy a {@link java.net.Proxy Proxy} object specifying what kind
    # of proxying should be used.
    # @throws IllegalArgumentException if the proxy is of an invalid type
    # or <code>null</code>.
    # @throws SecurityException if a security manager is present and
    # permission to connect to the proxy is
    # denied.
    # @see java.net.ProxySelector
    # @see java.net.Proxy
    # 
    # @since   1.5
    def initialize(proxy)
      @created = false
      @bound = false
      @connected = false
      @closed = false
      @close_lock = Object.new
      @shut_in = false
      @shut_out = false
      @impl = nil
      @old_impl = false
      if (!(proxy).nil? && (proxy.type).equal?(Proxy::Type::SOCKS))
        security = System.get_security_manager
        epoint = proxy.address
        if (!(security).nil?)
          if (epoint.is_unresolved)
            epoint = InetSocketAddress.new(epoint.get_host_name, epoint.get_port)
          end
          if (epoint.is_unresolved)
            security.check_connect(epoint.get_host_name, epoint.get_port)
          else
            security.check_connect(epoint.get_address.get_host_address, epoint.get_port)
          end
        end
        @impl = SocksSocketImpl.new(proxy)
        @impl.set_socket(self)
      else
        if ((proxy).equal?(Proxy::NO_PROXY))
          if ((self.attr_factory).nil?)
            @impl = PlainSocketImpl.new
            @impl.set_socket(self)
          else
            set_impl
          end
        else
          raise IllegalArgumentException.new("Invalid Proxy")
        end
      end
    end
    
    typesig { [SocketImpl] }
    # Creates an unconnected Socket with a user-specified
    # SocketImpl.
    # <P>
    # @param impl an instance of a <B>SocketImpl</B>
    # the subclass wishes to use on the Socket.
    # 
    # @exception SocketException if there is an error in the underlying protocol,
    # such as a TCP error.
    # @since   JDK1.1
    def initialize(impl)
      @created = false
      @bound = false
      @connected = false
      @closed = false
      @close_lock = Object.new
      @shut_in = false
      @shut_out = false
      @impl = nil
      @old_impl = false
      @impl = impl
      if (!(impl).nil?)
        check_old_impl
        @impl.set_socket(self)
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Creates a stream socket and connects it to the specified port
    # number on the named host.
    # <p>
    # If the specified host is <tt>null</tt> it is the equivalent of
    # specifying the address as <tt>{@link java.net.InetAddress#getByName InetAddress.getByName}(null)</tt>.
    # In other words, it is equivalent to specifying an address of the
    # loopback interface. </p>
    # <p>
    # If the application has specified a server socket factory, that
    # factory's <code>createSocketImpl</code> method is called to create
    # the actual socket implementation. Otherwise a "plain" socket is created.
    # <p>
    # If there is a security manager, its
    # <code>checkConnect</code> method is called
    # with the host address and <code>port</code>
    # as its arguments. This could result in a SecurityException.
    # 
    # @param      host   the host name, or <code>null</code> for the loopback address.
    # @param      port   the port number.
    # 
    # @exception  UnknownHostException if the IP address of
    # the host could not be determined.
    # 
    # @exception  IOException  if an I/O error occurs when creating the socket.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkConnect</code> method doesn't allow the operation.
    # @see        java.net.Socket#setSocketImplFactory(java.net.SocketImplFactory)
    # @see        java.net.SocketImpl
    # @see        java.net.SocketImplFactory#createSocketImpl()
    # @see        SecurityManager#checkConnect
    def initialize(host, port)
      initialize__socket(!(host).nil? ? InetSocketAddress.new(host, port) : InetSocketAddress.new(InetAddress.get_by_name(nil), port), nil, true)
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Creates a stream socket and connects it to the specified port
    # number at the specified IP address.
    # <p>
    # If the application has specified a socket factory, that factory's
    # <code>createSocketImpl</code> method is called to create the
    # actual socket implementation. Otherwise a "plain" socket is created.
    # <p>
    # If there is a security manager, its
    # <code>checkConnect</code> method is called
    # with the host address and <code>port</code>
    # as its arguments. This could result in a SecurityException.
    # 
    # @param      address   the IP address.
    # @param      port      the port number.
    # @exception  IOException  if an I/O error occurs when creating the socket.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkConnect</code> method doesn't allow the operation.
    # @see        java.net.Socket#setSocketImplFactory(java.net.SocketImplFactory)
    # @see        java.net.SocketImpl
    # @see        java.net.SocketImplFactory#createSocketImpl()
    # @see        SecurityManager#checkConnect
    def initialize(address_, port)
      initialize__socket(!(address_).nil? ? InetSocketAddress.new(address_, port) : nil, nil, true)
    end
    
    typesig { [String, ::Java::Int, InetAddress, ::Java::Int] }
    # Creates a socket and connects it to the specified remote host on
    # the specified remote port. The Socket will also bind() to the local
    # address and port supplied.
    # <p>
    # If the specified host is <tt>null</tt> it is the equivalent of
    # specifying the address as <tt>{@link java.net.InetAddress#getByName InetAddress.getByName}(null)</tt>.
    # In other words, it is equivalent to specifying an address of the
    # loopback interface. </p>
    # <p>
    # If there is a security manager, its
    # <code>checkConnect</code> method is called
    # with the host address and <code>port</code>
    # as its arguments. This could result in a SecurityException.
    # 
    # @param host the name of the remote host, or <code>null</code> for the loopback address.
    # @param port the remote port
    # @param localAddr the local address the socket is bound to
    # @param localPort the local port the socket is bound to
    # @exception  IOException  if an I/O error occurs when creating the socket.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkConnect</code> method doesn't allow the operation.
    # @see        SecurityManager#checkConnect
    # @since   JDK1.1
    def initialize(host, port, local_addr, local_port)
      initialize__socket(!(host).nil? ? InetSocketAddress.new(host, port) : InetSocketAddress.new(InetAddress.get_by_name(nil), port), InetSocketAddress.new(local_addr, local_port), true)
    end
    
    typesig { [InetAddress, ::Java::Int, InetAddress, ::Java::Int] }
    # Creates a socket and connects it to the specified remote address on
    # the specified remote port. The Socket will also bind() to the local
    # address and port supplied.
    # <p>
    # If there is a security manager, its
    # <code>checkConnect</code> method is called
    # with the host address and <code>port</code>
    # as its arguments. This could result in a SecurityException.
    # 
    # @param address the remote address
    # @param port the remote port
    # @param localAddr the local address the socket is bound to
    # @param localPort the local port the socket is bound to
    # @exception  IOException  if an I/O error occurs when creating the socket.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkConnect</code> method doesn't allow the operation.
    # @see        SecurityManager#checkConnect
    # @since   JDK1.1
    def initialize(address_, port, local_addr, local_port)
      initialize__socket(!(address_).nil? ? InetSocketAddress.new(address_, port) : nil, InetSocketAddress.new(local_addr, local_port), true)
    end
    
    typesig { [String, ::Java::Int, ::Java::Boolean] }
    # Creates a stream socket and connects it to the specified port
    # number on the named host.
    # <p>
    # If the specified host is <tt>null</tt> it is the equivalent of
    # specifying the address as <tt>{@link java.net.InetAddress#getByName InetAddress.getByName}(null)</tt>.
    # In other words, it is equivalent to specifying an address of the
    # loopback interface. </p>
    # <p>
    # If the stream argument is <code>true</code>, this creates a
    # stream socket. If the stream argument is <code>false</code>, it
    # creates a datagram socket.
    # <p>
    # If the application has specified a server socket factory, that
    # factory's <code>createSocketImpl</code> method is called to create
    # the actual socket implementation. Otherwise a "plain" socket is created.
    # <p>
    # If there is a security manager, its
    # <code>checkConnect</code> method is called
    # with the host address and <code>port</code>
    # as its arguments. This could result in a SecurityException.
    # <p>
    # If a UDP socket is used, TCP/IP related socket options will not apply.
    # 
    # @param      host     the host name, or <code>null</code> for the loopback address.
    # @param      port     the port number.
    # @param      stream   a <code>boolean</code> indicating whether this is
    # a stream socket or a datagram socket.
    # @exception  IOException  if an I/O error occurs when creating the socket.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkConnect</code> method doesn't allow the operation.
    # @see        java.net.Socket#setSocketImplFactory(java.net.SocketImplFactory)
    # @see        java.net.SocketImpl
    # @see        java.net.SocketImplFactory#createSocketImpl()
    # @see        SecurityManager#checkConnect
    # @deprecated Use DatagramSocket instead for UDP transport.
    def initialize(host, port, stream)
      initialize__socket(!(host).nil? ? InetSocketAddress.new(host, port) : InetSocketAddress.new(InetAddress.get_by_name(nil), port), nil, stream)
    end
    
    typesig { [InetAddress, ::Java::Int, ::Java::Boolean] }
    # Creates a socket and connects it to the specified port number at
    # the specified IP address.
    # <p>
    # If the stream argument is <code>true</code>, this creates a
    # stream socket. If the stream argument is <code>false</code>, it
    # creates a datagram socket.
    # <p>
    # If the application has specified a server socket factory, that
    # factory's <code>createSocketImpl</code> method is called to create
    # the actual socket implementation. Otherwise a "plain" socket is created.
    # 
    # <p>If there is a security manager, its
    # <code>checkConnect</code> method is called
    # with <code>host.getHostAddress()</code> and <code>port</code>
    # as its arguments. This could result in a SecurityException.
    # <p>
    # If UDP socket is used, TCP/IP related socket options will not apply.
    # 
    # @param      host     the IP address.
    # @param      port      the port number.
    # @param      stream    if <code>true</code>, create a stream socket;
    # otherwise, create a datagram socket.
    # @exception  IOException  if an I/O error occurs when creating the socket.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkConnect</code> method doesn't allow the operation.
    # @see        java.net.Socket#setSocketImplFactory(java.net.SocketImplFactory)
    # @see        java.net.SocketImpl
    # @see        java.net.SocketImplFactory#createSocketImpl()
    # @see        SecurityManager#checkConnect
    # @deprecated Use DatagramSocket instead for UDP transport.
    def initialize(host, port, stream)
      initialize__socket(!(host).nil? ? InetSocketAddress.new(host, port) : nil, InetSocketAddress.new(0), stream)
    end
    
    typesig { [SocketAddress, SocketAddress, ::Java::Boolean] }
    def initialize(address_, local_addr, stream)
      @created = false
      @bound = false
      @connected = false
      @closed = false
      @close_lock = Object.new
      @shut_in = false
      @shut_out = false
      @impl = nil
      @old_impl = false
      set_impl
      # backward compatibility
      if ((address_).nil?)
        raise NullPointerException.new
      end
      begin
        create_impl(stream)
        if (!(local_addr).nil?)
          bind(local_addr)
        end
        if (!(address_).nil?)
          connect(address_)
        end
      rescue IOException => e
        close
        raise e
      end
    end
    
    typesig { [::Java::Boolean] }
    # Creates the socket implementation.
    # 
    # @param stream a <code>boolean</code> value : <code>true</code> for a TCP socket,
    # <code>false</code> for UDP.
    # @throws IOException if creation fails
    # @since 1.4
    def create_impl(stream)
      if ((@impl).nil?)
        set_impl
      end
      begin
        @impl.create(stream)
        @created = true
      rescue IOException => e
        raise SocketException.new(e.get_message)
      end
    end
    
    typesig { [] }
    def check_old_impl
      if ((@impl).nil?)
        return
      end
      @old_impl = AccessController.do_privileged(# SocketImpl.connect() is a protected method, therefore we need to use
      # getDeclaredMethod, therefore we need permission to access the member
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members Socket
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          cl = Array.typed(self.class::Class).new(2) { nil }
          cl[0] = SocketAddress
          cl[1] = JavaInteger::TYPE
          clazz = self.attr_impl.get_class
          while (true)
            begin
              clazz.get_declared_method("connect", cl)
              return Boolean::FALSE
            rescue self.class::NoSuchMethodException => e
              clazz = clazz.get_superclass
              # java.net.SocketImpl class will always have this abstract method.
              # If we have not found it by now in the hierarchy then it does not
              # exist, we are an old style impl.
              if ((clazz == Java::Net::SocketImpl))
                return Boolean::TRUE
              end
            end
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # Sets impl to the system-default type of SocketImpl.
    # @since 1.4
    def set_impl
      if (!(self.attr_factory).nil?)
        @impl = self.attr_factory.create_socket_impl
        check_old_impl
      else
        # No need to do a checkOldImpl() here, we know it's an up to date
        # SocketImpl!
        @impl = SocksSocketImpl.new
      end
      if (!(@impl).nil?)
        @impl.set_socket(self)
      end
    end
    
    typesig { [] }
    # Get the <code>SocketImpl</code> attached to this socket, creating
    # it if necessary.
    # 
    # @return  the <code>SocketImpl</code> attached to that ServerSocket.
    # @throws SocketException if creation fails
    # @since 1.4
    def get_impl
      if (!@created)
        create_impl(true)
      end
      return @impl
    end
    
    typesig { [SocketAddress] }
    # Connects this socket to the server.
    # 
    # @param   endpoint the <code>SocketAddress</code>
    # @throws  IOException if an error occurs during the connection
    # @throws  java.nio.channels.IllegalBlockingModeException
    # if this socket has an associated channel,
    # and the channel is in non-blocking mode
    # @throws  IllegalArgumentException if endpoint is null or is a
    # SocketAddress subclass not supported by this socket
    # @since 1.4
    # @spec JSR-51
    def connect(endpoint)
      connect(endpoint, 0)
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    # Connects this socket to the server with a specified timeout value.
    # A timeout of zero is interpreted as an infinite timeout. The connection
    # will then block until established or an error occurs.
    # 
    # @param   endpoint the <code>SocketAddress</code>
    # @param   timeout  the timeout value to be used in milliseconds.
    # @throws  IOException if an error occurs during the connection
    # @throws  SocketTimeoutException if timeout expires before connecting
    # @throws  java.nio.channels.IllegalBlockingModeException
    # if this socket has an associated channel,
    # and the channel is in non-blocking mode
    # @throws  IllegalArgumentException if endpoint is null or is a
    # SocketAddress subclass not supported by this socket
    # @since 1.4
    # @spec JSR-51
    def connect(endpoint, timeout)
      if ((endpoint).nil?)
        raise IllegalArgumentException.new("connect: The address can't be null")
      end
      if (timeout < 0)
        raise IllegalArgumentException.new("connect: timeout can't be negative")
      end
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if (!@old_impl && is_connected)
        raise SocketException.new("already connected")
      end
      if (!(endpoint.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      epoint = endpoint
      security = System.get_security_manager
      if (!(security).nil?)
        if (epoint.is_unresolved)
          security.check_connect(epoint.get_host_name, epoint.get_port)
        else
          security.check_connect(epoint.get_address.get_host_address, epoint.get_port)
        end
      end
      if (!@created)
        create_impl(true)
      end
      if (!@old_impl)
        @impl.connect(epoint, timeout)
      else
        if ((timeout).equal?(0))
          if (epoint.is_unresolved)
            @impl.connect(epoint.get_address.get_host_name, epoint.get_port)
          else
            @impl.connect(epoint.get_address, epoint.get_port)
          end
        else
          raise UnsupportedOperationException.new("SocketImpl.connect(addr, timeout)")
        end
      end
      @connected = true
      # If the socket was not bound before the connect, it is now because
      # the kernel will have picked an ephemeral port & a local address
      @bound = true
    end
    
    typesig { [SocketAddress] }
    # Binds the socket to a local address.
    # <P>
    # If the address is <code>null</code>, then the system will pick up
    # an ephemeral port and a valid local address to bind the socket.
    # 
    # @param   bindpoint the <code>SocketAddress</code> to bind to
    # @throws  IOException if the bind operation fails, or if the socket
    # is already bound.
    # @throws  IllegalArgumentException if bindpoint is a
    # SocketAddress subclass not supported by this socket
    # 
    # @since   1.4
    # @see #isBound
    def bind(bindpoint)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if (!@old_impl && is_bound)
        raise SocketException.new("Already bound")
      end
      if (!(bindpoint).nil? && (!(bindpoint.is_a?(InetSocketAddress))))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      epoint = bindpoint
      if (!(epoint).nil? && epoint.is_unresolved)
        raise SocketException.new("Unresolved address")
      end
      if ((bindpoint).nil?)
        get_impl.bind(InetAddress.any_local_address, 0)
      else
        get_impl.bind(epoint.get_address, epoint.get_port)
      end
      @bound = true
    end
    
    typesig { [] }
    # set the flags after an accept() call.
    def post_accept
      @connected = true
      @created = true
      @bound = true
    end
    
    typesig { [] }
    def set_created
      @created = true
    end
    
    typesig { [] }
    def set_bound
      @bound = true
    end
    
    typesig { [] }
    def set_connected
      @connected = true
    end
    
    typesig { [] }
    # Returns the address to which the socket is connected.
    # 
    # @return  the remote IP address to which this socket is connected,
    # or <code>null</code> if the socket is not connected.
    def get_inet_address
      if (!is_connected)
        return nil
      end
      begin
        return get_impl.get_inet_address
      rescue SocketException => e
      end
      return nil
    end
    
    typesig { [] }
    # Gets the local address to which the socket is bound.
    # 
    # @return the local address to which the socket is bound or
    # <code>InetAddress.anyLocalAddress()</code>
    # if the socket is not bound yet.
    # @since   JDK1.1
    def get_local_address
      # This is for backward compatibility
      if (!is_bound)
        return InetAddress.any_local_address
      end
      in_ = nil
      begin
        in_ = get_impl.get_option(SocketOptions::SO_BINDADDR)
        if (in_.is_any_local_address)
          in_ = InetAddress.any_local_address
        end
      rescue JavaException => e
        in_ = InetAddress.any_local_address # "0.0.0.0"
      end
      return in_
    end
    
    typesig { [] }
    # Returns the remote port number to which this socket is connected.
    # 
    # @return  the remote port number to which this socket is connected, or
    # 0 if the socket is not connected yet.
    def get_port
      if (!is_connected)
        return 0
      end
      begin
        return get_impl.get_port
      rescue SocketException => e
        # Shouldn't happen as we're connected
      end
      return -1
    end
    
    typesig { [] }
    # Returns the local port number to which this socket is bound.
    # 
    # @return  the local port number to which this socket is bound or -1
    # if the socket is not bound yet.
    def get_local_port
      if (!is_bound)
        return -1
      end
      begin
        return get_impl.get_local_port
      rescue SocketException => e
        # shouldn't happen as we're bound
      end
      return -1
    end
    
    typesig { [] }
    # Returns the address of the endpoint this socket is connected to, or
    # <code>null</code> if it is unconnected.
    # 
    # @return a <code>SocketAddress</code> reprensenting the remote endpoint of this
    # socket, or <code>null</code> if it is not connected yet.
    # @see #getInetAddress()
    # @see #getPort()
    # @see #connect(SocketAddress, int)
    # @see #connect(SocketAddress)
    # @since 1.4
    def get_remote_socket_address
      if (!is_connected)
        return nil
      end
      return InetSocketAddress.new(get_inet_address, get_port)
    end
    
    typesig { [] }
    # Returns the address of the endpoint this socket is bound to, or
    # <code>null</code> if it is not bound yet.
    # 
    # @return a <code>SocketAddress</code> representing the local endpoint of this
    # socket, or <code>null</code> if it is not bound yet.
    # @see #getLocalAddress()
    # @see #getLocalPort()
    # @see #bind(SocketAddress)
    # @since 1.4
    def get_local_socket_address
      if (!is_bound)
        return nil
      end
      return InetSocketAddress.new(get_local_address, get_local_port)
    end
    
    typesig { [] }
    # Returns the unique {@link java.nio.channels.SocketChannel SocketChannel}
    # object associated with this socket, if any.
    # 
    # <p> A socket will have a channel if, and only if, the channel itself was
    # created via the {@link java.nio.channels.SocketChannel#open
    # SocketChannel.open} or {@link
    # java.nio.channels.ServerSocketChannel#accept ServerSocketChannel.accept}
    # methods.
    # 
    # @return  the socket channel associated with this socket,
    # or <tt>null</tt> if this socket was not created
    # for a channel
    # 
    # @since 1.4
    # @spec JSR-51
    def get_channel
      return nil
    end
    
    typesig { [] }
    # Returns an input stream for this socket.
    # 
    # <p> If this socket has an associated channel then the resulting input
    # stream delegates all of its operations to the channel.  If the channel
    # is in non-blocking mode then the input stream's <tt>read</tt> operations
    # will throw an {@link java.nio.channels.IllegalBlockingModeException}.
    # 
    # <p>Under abnormal conditions the underlying connection may be
    # broken by the remote host or the network software (for example
    # a connection reset in the case of TCP connections). When a
    # broken connection is detected by the network software the
    # following applies to the returned input stream :-
    # 
    # <ul>
    # 
    # <li><p>The network software may discard bytes that are buffered
    # by the socket. Bytes that aren't discarded by the network
    # software can be read using {@link java.io.InputStream#read read}.
    # 
    # <li><p>If there are no bytes buffered on the socket, or all
    # buffered bytes have been consumed by
    # {@link java.io.InputStream#read read}, then all subsequent
    # calls to {@link java.io.InputStream#read read} will throw an
    # {@link java.io.IOException IOException}.
    # 
    # <li><p>If there are no bytes buffered on the socket, and the
    # socket has not been closed using {@link #close close}, then
    # {@link java.io.InputStream#available available} will
    # return <code>0</code>.
    # 
    # </ul>
    # 
    # <p> Closing the returned {@link java.io.InputStream InputStream}
    # will close the associated socket.
    # 
    # @return     an input stream for reading bytes from this socket.
    # @exception  IOException  if an I/O error occurs when creating the
    # input stream, the socket is closed, the socket is
    # not connected, or the socket input has been shutdown
    # using {@link #shutdownInput()}
    # 
    # @revised 1.4
    # @spec JSR-51
    def get_input_stream
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if (!is_connected)
        raise SocketException.new("Socket is not connected")
      end
      if (is_input_shutdown)
        raise SocketException.new("Socket input is shutdown")
      end
      s = self
      is = nil
      begin
        is = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members Socket
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.attr_impl.get_input_stream
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue Java::Security::PrivilegedActionException => e
        raise e.get_exception
      end
      return is
    end
    
    typesig { [] }
    # Returns an output stream for this socket.
    # 
    # <p> If this socket has an associated channel then the resulting output
    # stream delegates all of its operations to the channel.  If the channel
    # is in non-blocking mode then the output stream's <tt>write</tt>
    # operations will throw an {@link
    # java.nio.channels.IllegalBlockingModeException}.
    # 
    # <p> Closing the returned {@link java.io.OutputStream OutputStream}
    # will close the associated socket.
    # 
    # @return     an output stream for writing bytes to this socket.
    # @exception  IOException  if an I/O error occurs when creating the
    # output stream or if the socket is not connected.
    # @revised 1.4
    # @spec JSR-51
    def get_output_stream
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if (!is_connected)
        raise SocketException.new("Socket is not connected")
      end
      if (is_output_shutdown)
        raise SocketException.new("Socket output is shutdown")
      end
      s = self
      os = nil
      begin
        os = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members Socket
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.attr_impl.get_output_stream
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue Java::Security::PrivilegedActionException => e
        raise e.get_exception
      end
      return os
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable TCP_NODELAY (disable/enable Nagle's algorithm).
    # 
    # @param on <code>true</code> to enable TCP_NODELAY,
    # <code>false</code> to disable.
    # 
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # 
    # @since   JDK1.1
    # 
    # @see #getTcpNoDelay()
    def set_tcp_no_delay(on)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      get_impl.set_option(SocketOptions::TCP_NODELAY, Boolean.value_of(on))
    end
    
    typesig { [] }
    # Tests if TCP_NODELAY is enabled.
    # 
    # @return a <code>boolean</code> indicating whether or not TCP_NODELAY is enabled.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since   JDK1.1
    # @see #setTcpNoDelay(boolean)
    def get_tcp_no_delay
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      return (get_impl.get_option(SocketOptions::TCP_NODELAY)).boolean_value
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    # Enable/disable SO_LINGER with the specified linger time in seconds.
    # The maximum timeout value is platform specific.
    # 
    # The setting only affects socket close.
    # 
    # @param on     whether or not to linger on.
    # @param linger how long to linger for, if on is true.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @exception IllegalArgumentException if the linger value is negative.
    # @since JDK1.1
    # @see #getSoLinger()
    def set_so_linger(on, linger)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if (!on)
        get_impl.set_option(SocketOptions::SO_LINGER, Boolean.new(on))
      else
        if (linger < 0)
          raise IllegalArgumentException.new("invalid value for SO_LINGER")
        end
        if (linger > 65535)
          linger = 65535
        end
        get_impl.set_option(SocketOptions::SO_LINGER, linger)
      end
    end
    
    typesig { [] }
    # Returns setting for SO_LINGER. -1 returns implies that the
    # option is disabled.
    # 
    # The setting only affects socket close.
    # 
    # @return the setting for SO_LINGER.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since   JDK1.1
    # @see #setSoLinger(boolean, int)
    def get_so_linger
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      o = get_impl.get_option(SocketOptions::SO_LINGER)
      if (o.is_a?(JavaInteger))
        return (o).int_value
      else
        return -1
      end
    end
    
    typesig { [::Java::Int] }
    # Send one byte of urgent data on the socket. The byte to be sent is the lowest eight
    # bits of the data parameter. The urgent byte is
    # sent after any preceding writes to the socket OutputStream
    # and before any future writes to the OutputStream.
    # @param data The byte of data to send
    # @exception IOException if there is an error
    # sending the data.
    # @since 1.4
    def send_urgent_data(data)
      if (!get_impl.supports_urgent_data)
        raise SocketException.new("Urgent data not supported")
      end
      get_impl.send_urgent_data(data)
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable OOBINLINE (receipt of TCP urgent data)
    # 
    # By default, this option is disabled and TCP urgent data received on a
    # socket is silently discarded. If the user wishes to receive urgent data, then
    # this option must be enabled. When enabled, urgent data is received
    # inline with normal data.
    # <p>
    # Note, only limited support is provided for handling incoming urgent
    # data. In particular, no notification of incoming urgent data is provided
    # and there is no capability to distinguish between normal data and urgent
    # data unless provided by a higher level protocol.
    # 
    # @param on <code>true</code> to enable OOBINLINE,
    # <code>false</code> to disable.
    # 
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # 
    # @since   1.4
    # 
    # @see #getOOBInline()
    def set_oobinline(on)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      get_impl.set_option(SocketOptions::SO_OOBINLINE, Boolean.value_of(on))
    end
    
    typesig { [] }
    # Tests if OOBINLINE is enabled.
    # 
    # @return a <code>boolean</code> indicating whether or not OOBINLINE is enabled.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since   1.4
    # @see #setOOBInline(boolean)
    def get_oobinline
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      return (get_impl.get_option(SocketOptions::SO_OOBINLINE)).boolean_value
    end
    
    typesig { [::Java::Int] }
    # Enable/disable SO_TIMEOUT with the specified timeout, in
    # milliseconds.  With this option set to a non-zero timeout,
    # a read() call on the InputStream associated with this Socket
    # will block for only this amount of time.  If the timeout expires,
    # a <B>java.net.SocketTimeoutException</B> is raised, though the
    # Socket is still valid. The option <B>must</B> be enabled
    # prior to entering the blocking operation to have effect. The
    # timeout must be > 0.
    # A timeout of zero is interpreted as an infinite timeout.
    # @param timeout the specified timeout, in milliseconds.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since   JDK 1.1
    # @see #getSoTimeout()
    def set_so_timeout(timeout)
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        if (timeout < 0)
          raise IllegalArgumentException.new("timeout can't be negative")
        end
        get_impl.set_option(SocketOptions::SO_TIMEOUT, timeout)
      end
    end
    
    typesig { [] }
    # Returns setting for SO_TIMEOUT.  0 returns implies that the
    # option is disabled (i.e., timeout of infinity).
    # @return the setting for SO_TIMEOUT
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since   JDK1.1
    # @see #setSoTimeout(int)
    def get_so_timeout
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        o = get_impl.get_option(SocketOptions::SO_TIMEOUT)
        # extra type safety
        if (o.is_a?(JavaInteger))
          return (o).int_value
        else
          return 0
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the SO_SNDBUF option to the specified value for this
    # <tt>Socket</tt>. The SO_SNDBUF option is used by the platform's
    # networking code as a hint for the size to set
    # the underlying network I/O buffers.
    # 
    # <p>Because SO_SNDBUF is a hint, applications that want to
    # verify what size the buffers were set to should call
    # {@link #getSendBufferSize()}.
    # 
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # 
    # @param size the size to which to set the send buffer
    # size. This value must be greater than 0.
    # 
    # @exception IllegalArgumentException if the
    # value is 0 or is negative.
    # 
    # @see #getSendBufferSize()
    # @since 1.2
    def set_send_buffer_size(size)
      synchronized(self) do
        if (!(size > 0))
          raise IllegalArgumentException.new("negative send size")
        end
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        get_impl.set_option(SocketOptions::SO_SNDBUF, size)
      end
    end
    
    typesig { [] }
    # Get value of the SO_SNDBUF option for this <tt>Socket</tt>,
    # that is the buffer size used by the platform
    # for output on this <tt>Socket</tt>.
    # @return the value of the SO_SNDBUF option for this <tt>Socket</tt>.
    # 
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # 
    # @see #setSendBufferSize(int)
    # @since 1.2
    def get_send_buffer_size
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        result = 0
        o = get_impl.get_option(SocketOptions::SO_SNDBUF)
        if (o.is_a?(JavaInteger))
          result = (o).int_value
        end
        return result
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the SO_RCVBUF option to the specified value for this
    # <tt>Socket</tt>. The SO_RCVBUF option is used by the platform's
    # networking code as a hint for the size to set
    # the underlying network I/O buffers.
    # 
    # <p>Increasing the receive buffer size can increase the performance of
    # network I/O for high-volume connection, while decreasing it can
    # help reduce the backlog of incoming data.
    # 
    # <p>Because SO_RCVBUF is a hint, applications that want to
    # verify what size the buffers were set to should call
    # {@link #getReceiveBufferSize()}.
    # 
    # <p>The value of SO_RCVBUF is also used to set the TCP receive window
    # that is advertized to the remote peer. Generally, the window size
    # can be modified at any time when a socket is connected. However, if
    # a receive window larger than 64K is required then this must be requested
    # <B>before</B> the socket is connected to the remote peer. There are two
    # cases to be aware of:<p>
    # <ol>
    # <li>For sockets accepted from a ServerSocket, this must be done by calling
    # {@link ServerSocket#setReceiveBufferSize(int)} before the ServerSocket
    # is bound to a local address.<p></li>
    # <li>For client sockets, setReceiveBufferSize() must be called before
    # connecting the socket to its remote peer.<p></li></ol>
    # @param size the size to which to set the receive buffer
    # size. This value must be greater than 0.
    # 
    # @exception IllegalArgumentException if the value is 0 or is
    # negative.
    # 
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # 
    # @see #getReceiveBufferSize()
    # @see ServerSocket#setReceiveBufferSize(int)
    # @since 1.2
    def set_receive_buffer_size(size)
      synchronized(self) do
        if (size <= 0)
          raise IllegalArgumentException.new("invalid receive size")
        end
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        get_impl.set_option(SocketOptions::SO_RCVBUF, size)
      end
    end
    
    typesig { [] }
    # Gets the value of the SO_RCVBUF option for this <tt>Socket</tt>,
    # that is the buffer size used by the platform for
    # input on this <tt>Socket</tt>.
    # 
    # @return the value of the SO_RCVBUF option for this <tt>Socket</tt>.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @see #setReceiveBufferSize(int)
    # @since 1.2
    def get_receive_buffer_size
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        result = 0
        o = get_impl.get_option(SocketOptions::SO_RCVBUF)
        if (o.is_a?(JavaInteger))
          result = (o).int_value
        end
        return result
      end
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable SO_KEEPALIVE.
    # 
    # @param on     whether or not to have socket keep alive turned on.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since 1.3
    # @see #getKeepAlive()
    def set_keep_alive(on)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      get_impl.set_option(SocketOptions::SO_KEEPALIVE, Boolean.value_of(on))
    end
    
    typesig { [] }
    # Tests if SO_KEEPALIVE is enabled.
    # 
    # @return a <code>boolean</code> indicating whether or not SO_KEEPALIVE is enabled.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since   1.3
    # @see #setKeepAlive(boolean)
    def get_keep_alive
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      return (get_impl.get_option(SocketOptions::SO_KEEPALIVE)).boolean_value
    end
    
    typesig { [::Java::Int] }
    # Sets traffic class or type-of-service octet in the IP
    # header for packets sent from this Socket.
    # As the underlying network implementation may ignore this
    # value applications should consider it a hint.
    # 
    # <P> The tc <B>must</B> be in the range <code> 0 <= tc <=
    # 255</code> or an IllegalArgumentException will be thrown.
    # <p>Notes:
    # <p> For Internet Protocol v4 the value consists of an octet
    # with precedence and TOS fields as detailed in RFC 1349. The
    # TOS field is bitset created by bitwise-or'ing values such
    # the following :-
    # <p>
    # <UL>
    # <LI><CODE>IPTOS_LOWCOST (0x02)</CODE></LI>
    # <LI><CODE>IPTOS_RELIABILITY (0x04)</CODE></LI>
    # <LI><CODE>IPTOS_THROUGHPUT (0x08)</CODE></LI>
    # <LI><CODE>IPTOS_LOWDELAY (0x10)</CODE></LI>
    # </UL>
    # The last low order bit is always ignored as this
    # corresponds to the MBZ (must be zero) bit.
    # <p>
    # Setting bits in the precedence field may result in a
    # SocketException indicating that the operation is not
    # permitted.
    # <p>
    # As RFC 1122 section 4.2.4.2 indicates, a compliant TCP
    # implementation should, but is not required to, let application
    # change the TOS field during the lifetime of a connection.
    # So whether the type-of-service field can be changed after the
    # TCP connection has been established depends on the implementation
    # in the underlying platform. Applications should not assume that
    # they can change the TOS field after the connection.
    # <p>
    # For Internet Protocol v6 <code>tc</code> is the value that
    # would be placed into the sin6_flowinfo field of the IP header.
    # 
    # @param tc        an <code>int</code> value for the bitset.
    # @throws SocketException if there is an error setting the
    # traffic class or type-of-service
    # @since 1.4
    # @see #getTrafficClass
    def set_traffic_class(tc)
      if (tc < 0 || tc > 255)
        raise IllegalArgumentException.new("tc is not in range 0 -- 255")
      end
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      get_impl.set_option(SocketOptions::IP_TOS, tc)
    end
    
    typesig { [] }
    # Gets traffic class or type-of-service in the IP header
    # for packets sent from this Socket
    # <p>
    # As the underlying network implementation may ignore the
    # traffic class or type-of-service set using {@link #setTrafficClass(int)}
    # this method may return a different value than was previously
    # set using the {@link #setTrafficClass(int)} method on this Socket.
    # 
    # @return the traffic class or type-of-service already set
    # @throws SocketException if there is an error obtaining the
    # traffic class or type-of-service value.
    # @since 1.4
    # @see #setTrafficClass(int)
    def get_traffic_class
      return ((get_impl.get_option(SocketOptions::IP_TOS))).int_value
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable the SO_REUSEADDR socket option.
    # <p>
    # When a TCP connection is closed the connection may remain
    # in a timeout state for a period of time after the connection
    # is closed (typically known as the <tt>TIME_WAIT</tt> state
    # or <tt>2MSL</tt> wait state).
    # For applications using a well known socket address or port
    # it may not be possible to bind a socket to the required
    # <tt>SocketAddress</tt> if there is a connection in the
    # timeout state involving the socket address or port.
    # <p>
    # Enabling <tt>SO_REUSEADDR</tt> prior to binding the socket
    # using {@link #bind(SocketAddress)} allows the socket to be
    # bound even though a previous connection is in a timeout
    # state.
    # <p>
    # When a <tt>Socket</tt> is created the initial setting
    # of <tt>SO_REUSEADDR</tt> is disabled.
    # <p>
    # The behaviour when <tt>SO_REUSEADDR</tt> is enabled or
    # disabled after a socket is bound (See {@link #isBound()})
    # is not defined.
    # 
    # @param on  whether to enable or disable the socket option
    # @exception SocketException if an error occurs enabling or
    # disabling the <tt>SO_RESUEADDR</tt> socket option,
    # or the socket is closed.
    # @since 1.4
    # @see #getReuseAddress()
    # @see #bind(SocketAddress)
    # @see #isClosed()
    # @see #isBound()
    def set_reuse_address(on)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      get_impl.set_option(SocketOptions::SO_REUSEADDR, Boolean.value_of(on))
    end
    
    typesig { [] }
    # Tests if SO_REUSEADDR is enabled.
    # 
    # @return a <code>boolean</code> indicating whether or not SO_REUSEADDR is enabled.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as a TCP error.
    # @since   1.4
    # @see #setReuseAddress(boolean)
    def get_reuse_address
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      return ((get_impl.get_option(SocketOptions::SO_REUSEADDR))).boolean_value
    end
    
    typesig { [] }
    # Closes this socket.
    # <p>
    # Any thread currently blocked in an I/O operation upon this socket
    # will throw a {@link SocketException}.
    # <p>
    # Once a socket has been closed, it is not available for further networking
    # use (i.e. can't be reconnected or rebound). A new socket needs to be
    # created.
    # 
    # <p> Closing this socket will also close the socket's
    # {@link java.io.InputStream InputStream} and
    # {@link java.io.OutputStream OutputStream}.
    # 
    # <p> If this socket has an associated channel then the channel is closed
    # as well.
    # 
    # @exception  IOException  if an I/O error occurs when closing this socket.
    # @revised 1.4
    # @spec JSR-51
    # @see #isClosed
    def close
      synchronized(self) do
        synchronized((@close_lock)) do
          if (is_closed)
            return
          end
          if (@created)
            @impl.close
          end
          @closed = true
        end
      end
    end
    
    typesig { [] }
    # Places the input stream for this socket at "end of stream".
    # Any data sent to the input stream side of the socket is acknowledged
    # and then silently discarded.
    # <p>
    # If you read from a socket input stream after invoking
    # shutdownInput() on the socket, the stream will return EOF.
    # 
    # @exception IOException if an I/O error occurs when shutting down this
    # socket.
    # 
    # @since 1.3
    # @see java.net.Socket#shutdownOutput()
    # @see java.net.Socket#close()
    # @see java.net.Socket#setSoLinger(boolean, int)
    # @see #isInputShutdown
    def shutdown_input
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if (!is_connected)
        raise SocketException.new("Socket is not connected")
      end
      if (is_input_shutdown)
        raise SocketException.new("Socket input is already shutdown")
      end
      get_impl.shutdown_input
      @shut_in = true
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
    # 
    # @since 1.3
    # @see java.net.Socket#shutdownInput()
    # @see java.net.Socket#close()
    # @see java.net.Socket#setSoLinger(boolean, int)
    # @see #isOutputShutdown
    def shutdown_output
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if (!is_connected)
        raise SocketException.new("Socket is not connected")
      end
      if (is_output_shutdown)
        raise SocketException.new("Socket output is already shutdown")
      end
      get_impl.shutdown_output
      @shut_out = true
    end
    
    typesig { [] }
    # Converts this socket to a <code>String</code>.
    # 
    # @return  a string representation of this socket.
    def to_s
      begin
        if (is_connected)
          return "Socket[addr=" + RJava.cast_to_string(get_impl.get_inet_address) + ",port=" + RJava.cast_to_string(get_impl.get_port) + ",localport=" + RJava.cast_to_string(get_impl.get_local_port) + "]"
        end
      rescue SocketException => e
      end
      return "Socket[unconnected]"
    end
    
    typesig { [] }
    # Returns the connection state of the socket.
    # 
    # @return true if the socket successfuly connected to a server
    # @since 1.4
    def is_connected
      # Before 1.3 Sockets were always connected during creation
      return @connected || @old_impl
    end
    
    typesig { [] }
    # Returns the binding state of the socket.
    # 
    # @return true if the socket successfuly bound to an address
    # @since 1.4
    # @see #bind
    def is_bound
      # Before 1.3 Sockets were always bound during creation
      return @bound || @old_impl
    end
    
    typesig { [] }
    # Returns the closed state of the socket.
    # 
    # @return true if the socket has been closed
    # @since 1.4
    # @see #close
    def is_closed
      synchronized((@close_lock)) do
        return @closed
      end
    end
    
    typesig { [] }
    # Returns whether the read-half of the socket connection is closed.
    # 
    # @return true if the input of the socket has been shutdown
    # @since 1.4
    # @see #shutdownInput
    def is_input_shutdown
      return @shut_in
    end
    
    typesig { [] }
    # Returns whether the write-half of the socket connection is closed.
    # 
    # @return true if the output of the socket has been shutdown
    # @since 1.4
    # @see #shutdownOutput
    def is_output_shutdown
      return @shut_out
    end
    
    class_module.module_eval {
      # The factory for all client sockets.
      
      def factory
        defined?(@@factory) ? @@factory : @@factory= nil
      end
      alias_method :attr_factory, :factory
      
      def factory=(value)
        @@factory = value
      end
      alias_method :attr_factory=, :factory=
      
      typesig { [SocketImplFactory] }
      # Sets the client socket implementation factory for the
      # application. The factory can be specified only once.
      # <p>
      # When an application creates a new client socket, the socket
      # implementation factory's <code>createSocketImpl</code> method is
      # called to create the actual socket implementation.
      # <p>
      # Passing <code>null</code> to the method is a no-op unless the factory
      # was already set.
      # <p>If there is a security manager, this method first calls
      # the security manager's <code>checkSetFactory</code> method
      # to ensure the operation is allowed.
      # This could result in a SecurityException.
      # 
      # @param      fac   the desired factory.
      # @exception  IOException  if an I/O error occurs when setting the
      # socket factory.
      # @exception  SocketException  if the factory is already defined.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkSetFactory</code> method doesn't allow the operation.
      # @see        java.net.SocketImplFactory#createSocketImpl()
      # @see        SecurityManager#checkSetFactory
      def set_socket_impl_factory(fac)
        synchronized(self) do
          if (!(self.attr_factory).nil?)
            raise SocketException.new("factory already defined")
          end
          security = System.get_security_manager
          if (!(security).nil?)
            security.check_set_factory
          end
          self.attr_factory = fac
        end
      end
    }
    
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
    # <p> Invoking this method after this socket has been connected
    # will have no effect.
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
    
    private
    alias_method :initialize__socket, :initialize
  end
  
end
