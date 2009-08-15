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
  module DatagramSocketImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InterruptedIOException
      include_const ::Java::Nio::Channels, :DatagramChannel
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedExceptionAction
    }
  end
  
  # This class represents a socket for sending and receiving datagram packets.
  # 
  # <p>A datagram socket is the sending or receiving point for a packet
  # delivery service. Each packet sent or received on a datagram socket
  # is individually addressed and routed. Multiple packets sent from
  # one machine to another may be routed differently, and may arrive in
  # any order.
  # 
  # <p>UDP broadcasts sends are always enabled on a DatagramSocket.
  # In order to receive broadcast packets a DatagramSocket
  # should be bound to the wildcard address. In some
  # implementations, broadcast packets may also be received when
  # a DatagramSocket is bound to a more specific address.
  # <p>
  # Example:
  # <code>
  # DatagramSocket s = new DatagramSocket(null);
  # s.bind(new InetSocketAddress(8888));
  # </code>
  # Which is equivalent to:
  # <code>
  # DatagramSocket s = new DatagramSocket(8888);
  # </code>
  # Both cases will create a DatagramSocket able to receive broadcasts on
  # UDP port 8888.
  # 
  # @author  Pavani Diwanji
  # @see     java.net.DatagramPacket
  # @see     java.nio.channels.DatagramChannel
  # @since JDK1.0
  class DatagramSocket 
    include_class_members DatagramSocketImports
    
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
    
    # The implementation of this DatagramSocket.
    attr_accessor :impl
    alias_method :attr_impl, :impl
    undef_method :impl
    alias_method :attr_impl=, :impl=
    undef_method :impl=
    
    # Are we using an older DatagramSocketImpl?
    attr_accessor :old_impl
    alias_method :attr_old_impl, :old_impl
    undef_method :old_impl
    alias_method :attr_old_impl=, :old_impl=
    undef_method :old_impl=
    
    class_module.module_eval {
      # Connection state:
      # ST_NOT_CONNECTED = socket not connected
      # ST_CONNECTED = socket connected
      # ST_CONNECTED_NO_IMPL = socket connected but not at impl level
      const_set_lazy(:ST_NOT_CONNECTED) { 0 }
      const_attr_reader  :ST_NOT_CONNECTED
      
      const_set_lazy(:ST_CONNECTED) { 1 }
      const_attr_reader  :ST_CONNECTED
      
      const_set_lazy(:ST_CONNECTED_NO_IMPL) { 2 }
      const_attr_reader  :ST_CONNECTED_NO_IMPL
    }
    
    attr_accessor :connect_state
    alias_method :attr_connect_state, :connect_state
    undef_method :connect_state
    alias_method :attr_connect_state=, :connect_state=
    undef_method :connect_state=
    
    # Connected address & port
    attr_accessor :connected_address
    alias_method :attr_connected_address, :connected_address
    undef_method :connected_address
    alias_method :attr_connected_address=, :connected_address=
    undef_method :connected_address=
    
    attr_accessor :connected_port
    alias_method :attr_connected_port, :connected_port
    undef_method :connected_port
    alias_method :attr_connected_port=, :connected_port=
    undef_method :connected_port=
    
    typesig { [InetAddress, ::Java::Int] }
    # Connects this socket to a remote socket address (IP address + port number).
    # Binds socket if not already bound.
    # <p>
    # @param   addr    The remote address.
    # @param   port    The remote port
    # @throws  SocketException if binding the socket fails.
    def connect_internal(address, port)
      synchronized(self) do
        if (port < 0 || port > 0xffff)
          raise IllegalArgumentException.new("connect: " + RJava.cast_to_string(port))
        end
        if ((address).nil?)
          raise IllegalArgumentException.new("connect: null address")
        end
        if (is_closed)
          return
        end
        security = System.get_security_manager
        if (!(security).nil?)
          if (address.is_multicast_address)
            security.check_multicast(address)
          else
            security.check_connect(address.get_host_address, port)
            security.check_accept(address.get_host_address, port)
          end
        end
        if (!is_bound)
          bind(InetSocketAddress.new(0))
        end
        # old impls do not support connect/disconnect
        if (@old_impl)
          @connect_state = ST_CONNECTED_NO_IMPL
        else
          begin
            get_impl.connect(address, port)
            # socket is now connected by the impl
            @connect_state = ST_CONNECTED
          rescue SocketException => se
            # connection will be emulated by DatagramSocket
            @connect_state = ST_CONNECTED_NO_IMPL
          end
        end
        @connected_address = address
        @connected_port = port
      end
    end
    
    typesig { [] }
    # Constructs a datagram socket and binds it to any available port
    # on the local host machine.  The socket will be bound to the
    # {@link InetAddress#isAnyLocalAddress wildcard} address,
    # an IP address chosen by the kernel.
    # 
    # <p>If there is a security manager,
    # its <code>checkListen</code> method is first called
    # with 0 as its argument to ensure the operation is allowed.
    # This could result in a SecurityException.
    # 
    # @exception  SocketException  if the socket could not be opened,
    # or the socket could not bind to the specified local port.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # 
    # @see SecurityManager#checkListen
    def initialize
      @created = false
      @bound = false
      @closed = false
      @close_lock = Object.new
      @impl = nil
      @old_impl = false
      @connect_state = ST_NOT_CONNECTED
      @connected_address = nil
      @connected_port = -1
      # create a datagram socket.
      create_impl
      begin
        bind(InetSocketAddress.new(0))
      rescue SocketException => se
        raise se
      rescue IOException => e
        raise SocketException.new(e.get_message)
      end
    end
    
    typesig { [DatagramSocketImpl] }
    # Creates an unbound datagram socket with the specified
    # DatagramSocketImpl.
    # 
    # @param impl an instance of a <B>DatagramSocketImpl</B>
    # the subclass wishes to use on the DatagramSocket.
    # @since   1.4
    def initialize(impl)
      @created = false
      @bound = false
      @closed = false
      @close_lock = Object.new
      @impl = nil
      @old_impl = false
      @connect_state = ST_NOT_CONNECTED
      @connected_address = nil
      @connected_port = -1
      if ((impl).nil?)
        raise NullPointerException.new
      end
      @impl = impl
      check_old_impl
    end
    
    typesig { [SocketAddress] }
    # Creates a datagram socket, bound to the specified local
    # socket address.
    # <p>
    # If, if the address is <code>null</code>, creates an unbound socket.
    # <p>
    # <p>If there is a security manager,
    # its <code>checkListen</code> method is first called
    # with the port from the socket address
    # as its argument to ensure the operation is allowed.
    # This could result in a SecurityException.
    # 
    # @param bindaddr local socket address to bind, or <code>null</code>
    # for an unbound socket.
    # 
    # @exception  SocketException  if the socket could not be opened,
    # or the socket could not bind to the specified local port.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # 
    # @see SecurityManager#checkListen
    # @since   1.4
    def initialize(bindaddr)
      @created = false
      @bound = false
      @closed = false
      @close_lock = Object.new
      @impl = nil
      @old_impl = false
      @connect_state = ST_NOT_CONNECTED
      @connected_address = nil
      @connected_port = -1
      # create a datagram socket.
      create_impl
      if (!(bindaddr).nil?)
        bind(bindaddr)
      end
    end
    
    typesig { [::Java::Int] }
    # Constructs a datagram socket and binds it to the specified port
    # on the local host machine.  The socket will be bound to the
    # {@link InetAddress#isAnyLocalAddress wildcard} address,
    # an IP address chosen by the kernel.
    # 
    # <p>If there is a security manager,
    # its <code>checkListen</code> method is first called
    # with the <code>port</code> argument
    # as its argument to ensure the operation is allowed.
    # This could result in a SecurityException.
    # 
    # @param      port port to use.
    # @exception  SocketException  if the socket could not be opened,
    # or the socket could not bind to the specified local port.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # 
    # @see SecurityManager#checkListen
    def initialize(port)
      initialize__datagram_socket(port, nil)
    end
    
    typesig { [::Java::Int, InetAddress] }
    # Creates a datagram socket, bound to the specified local
    # address.  The local port must be between 0 and 65535 inclusive.
    # If the IP address is 0.0.0.0, the socket will be bound to the
    # {@link InetAddress#isAnyLocalAddress wildcard} address,
    # an IP address chosen by the kernel.
    # 
    # <p>If there is a security manager,
    # its <code>checkListen</code> method is first called
    # with the <code>port</code> argument
    # as its argument to ensure the operation is allowed.
    # This could result in a SecurityException.
    # 
    # @param port local port to use
    # @param laddr local address to bind
    # 
    # @exception  SocketException  if the socket could not be opened,
    # or the socket could not bind to the specified local port.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # 
    # @see SecurityManager#checkListen
    # @since   JDK1.1
    def initialize(port, laddr)
      initialize__datagram_socket(InetSocketAddress.new(laddr, port))
    end
    
    typesig { [] }
    def check_old_impl
      if ((@impl).nil?)
        return
      end
      # DatagramSocketImpl.peekdata() is a protected method, therefore we need to use
      # getDeclaredMethod, therefore we need permission to access the member
      begin
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members DatagramSocket
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            cl = Array.typed(Class).new(1) { nil }
            cl[0] = DatagramPacket
            self.attr_impl.get_class.get_declared_method("peekData", cl)
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue Java::Security::PrivilegedActionException => e
        @old_impl = true
      end
    end
    
    class_module.module_eval {
      
      def impl_class
        defined?(@@impl_class) ? @@impl_class : @@impl_class= nil
      end
      alias_method :attr_impl_class, :impl_class
      
      def impl_class=(value)
        @@impl_class = value
      end
      alias_method :attr_impl_class=, :impl_class=
    }
    
    typesig { [] }
    def create_impl
      if ((@impl).nil?)
        if (!(self.attr_factory).nil?)
          @impl = self.attr_factory.create_datagram_socket_impl
          check_old_impl
        else
          is_multicast = (self.is_a?(MulticastSocket)) ? true : false
          @impl = DefaultDatagramSocketImplFactory.create_datagram_socket_impl(is_multicast)
          check_old_impl
        end
      end
      # creates a udp socket
      @impl.create
      @created = true
    end
    
    typesig { [] }
    # Get the <code>DatagramSocketImpl</code> attached to this socket,
    # creating it if necessary.
    # 
    # @return  the <code>DatagramSocketImpl</code> attached to that
    # DatagramSocket
    # @throws SocketException if creation fails.
    # @since 1.4
    def get_impl
      if (!@created)
        create_impl
      end
      return @impl
    end
    
    typesig { [SocketAddress] }
    # Binds this DatagramSocket to a specific address & port.
    # <p>
    # If the address is <code>null</code>, then the system will pick up
    # an ephemeral port and a valid local address to bind the socket.
    # <p>
    # @param   addr The address & port to bind to.
    # @throws  SocketException if any error happens during the bind, or if the
    # socket is already bound.
    # @throws  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # @throws IllegalArgumentException if addr is a SocketAddress subclass
    # not supported by this socket.
    # @since 1.4
    def bind(addr)
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        if (is_bound)
          raise SocketException.new("already bound")
        end
        if ((addr).nil?)
          addr = InetSocketAddress.new(0)
        end
        if (!(addr.is_a?(InetSocketAddress)))
          raise IllegalArgumentException.new("Unsupported address type!")
        end
        epoint = addr
        if (epoint.is_unresolved)
          raise SocketException.new("Unresolved address")
        end
        sec = System.get_security_manager
        if (!(sec).nil?)
          sec.check_listen(epoint.get_port)
        end
        begin
          get_impl.bind(epoint.get_port, epoint.get_address)
        rescue SocketException => e
          get_impl.close
          raise e
        end
        @bound = true
      end
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Connects the socket to a remote address for this socket. When a
    # socket is connected to a remote address, packets may only be
    # sent to or received from that address. By default a datagram
    # socket is not connected.
    # 
    # <p>If the remote destination to which the socket is connected does not
    # exist, or is otherwise unreachable, and if an ICMP destination unreachable
    # packet has been received for that address, then a subsequent call to
    # send or receive may throw a PortUnreachableException. Note, there is no
    # guarantee that the exception will be thrown.
    # 
    # <p>A caller's permission to send and receive datagrams to a
    # given host and port are checked at connect time. When a socket
    # is connected, receive and send <b>will not
    # perform any security checks</b> on incoming and outgoing
    # packets, other than matching the packet's and the socket's
    # address and port. On a send operation, if the packet's address
    # is set and the packet's address and the socket's address do not
    # match, an IllegalArgumentException will be thrown. A socket
    # connected to a multicast address may only be used to send packets.
    # 
    # @param address the remote address for the socket
    # 
    # @param port the remote port for the socket.
    # 
    # @exception IllegalArgumentException if the address is null,
    # or the port is out of range.
    # 
    # @exception SecurityException if the caller is not allowed to
    # send datagrams to and receive datagrams from the address and port.
    # 
    # @see #disconnect
    # @see #send
    # @see #receive
    def connect(address, port)
      begin
        connect_internal(address, port)
      rescue SocketException => se
        raise JavaError.new("connect failed", se)
      end
    end
    
    typesig { [SocketAddress] }
    # Connects this socket to a remote socket address (IP address + port number).
    # <p>
    # @param   addr    The remote address.
    # @throws  SocketException if the connect fails
    # @throws  IllegalArgumentException if addr is null or addr is a SocketAddress
    # subclass not supported by this socket
    # @since 1.4
    # @see #connect
    def connect(addr)
      if ((addr).nil?)
        raise IllegalArgumentException.new("Address can't be null")
      end
      if (!(addr.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      epoint = addr
      if (epoint.is_unresolved)
        raise SocketException.new("Unresolved address")
      end
      connect_internal(epoint.get_address, epoint.get_port)
    end
    
    typesig { [] }
    # Disconnects the socket. This does nothing if the socket is not
    # connected.
    # 
    # @see #connect
    def disconnect
      synchronized((self)) do
        if (is_closed)
          return
        end
        if ((@connect_state).equal?(ST_CONNECTED))
          @impl.disconnect
        end
        @connected_address = nil
        @connected_port = -1
        @connect_state = ST_NOT_CONNECTED
      end
    end
    
    typesig { [] }
    # Returns the binding state of the socket.
    # 
    # @return true if the socket successfully bound to an address
    # @since 1.4
    def is_bound
      return @bound
    end
    
    typesig { [] }
    # Returns the connection state of the socket.
    # 
    # @return true if the socket successfully connected to a server
    # @since 1.4
    def is_connected
      return !(@connect_state).equal?(ST_NOT_CONNECTED)
    end
    
    typesig { [] }
    # Returns the address to which this socket is connected. Returns
    # <code>null</code> if the socket is not connected.
    # 
    # @return the address to which this socket is connected.
    def get_inet_address
      return @connected_address
    end
    
    typesig { [] }
    # Returns the port number to which this socket is connected.
    # Returns <code>-1</code> if the socket is not connected.
    # 
    # @return the port number to which this socket is connected.
    def get_port
      return @connected_port
    end
    
    typesig { [] }
    # Returns the address of the endpoint this socket is connected to, or
    # <code>null</code> if it is unconnected.
    # 
    # @return a <code>SocketAddress</code> representing the remote
    # endpoint of this socket, or <code>null</code> if it is
    # not connected yet.
    # @see #getInetAddress()
    # @see #getPort()
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
      if (is_closed)
        return nil
      end
      if (!is_bound)
        return nil
      end
      return InetSocketAddress.new(get_local_address, get_local_port)
    end
    
    typesig { [DatagramPacket] }
    # Sends a datagram packet from this socket. The
    # <code>DatagramPacket</code> includes information indicating the
    # data to be sent, its length, the IP address of the remote host,
    # and the port number on the remote host.
    # 
    # <p>If there is a security manager, and the socket is not currently
    # connected to a remote address, this method first performs some
    # security checks. First, if <code>p.getAddress().isMulticastAddress()</code>
    # is true, this method calls the
    # security manager's <code>checkMulticast</code> method
    # with <code>p.getAddress()</code> as its argument.
    # If the evaluation of that expression is false,
    # this method instead calls the security manager's
    # <code>checkConnect</code> method with arguments
    # <code>p.getAddress().getHostAddress()</code> and
    # <code>p.getPort()</code>. Each call to a security manager method
    # could result in a SecurityException if the operation is not allowed.
    # 
    # @param      p   the <code>DatagramPacket</code> to be sent.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkMulticast</code> or <code>checkConnect</code>
    # method doesn't allow the send.
    # @exception  PortUnreachableException may be thrown if the socket is connected
    # to a currently unreachable destination. Note, there is no
    # guarantee that the exception will be thrown.
    # @exception  java.nio.channels.IllegalBlockingModeException
    # if this socket has an associated channel,
    # and the channel is in non-blocking mode.
    # 
    # @see        java.net.DatagramPacket
    # @see        SecurityManager#checkMulticast(InetAddress)
    # @see        SecurityManager#checkConnect
    # @revised 1.4
    # @spec JSR-51
    def send(p)
      packet_address = nil
      synchronized((p)) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        if ((@connect_state).equal?(ST_NOT_CONNECTED))
          # check the address is ok wiht the security manager on every send.
          security = System.get_security_manager
          # The reason you want to synchronize on datagram packet
          # is because you dont want an applet to change the address
          # while you are trying to send the packet for example
          # after the security check but before the send.
          if (!(security).nil?)
            if (p.get_address.is_multicast_address)
              security.check_multicast(p.get_address)
            else
              security.check_connect(p.get_address.get_host_address, p.get_port)
            end
          end
        else
          # we're connected
          packet_address = p.get_address
          if ((packet_address).nil?)
            p.set_address(@connected_address)
            p.set_port(@connected_port)
          else
            if ((!(packet_address == @connected_address)) || !(p.get_port).equal?(@connected_port))
              raise IllegalArgumentException.new("connected address " + "and packet address" + " differ")
            end
          end
        end
        # Check whether the socket is bound
        if (!is_bound)
          bind(InetSocketAddress.new(0))
        end
        # call the  method to send
        get_impl.send(p)
      end
    end
    
    typesig { [DatagramPacket] }
    # Receives a datagram packet from this socket. When this method
    # returns, the <code>DatagramPacket</code>'s buffer is filled with
    # the data received. The datagram packet also contains the sender's
    # IP address, and the port number on the sender's machine.
    # <p>
    # This method blocks until a datagram is received. The
    # <code>length</code> field of the datagram packet object contains
    # the length of the received message. If the message is longer than
    # the packet's length, the message is truncated.
    # <p>
    # If there is a security manager, a packet cannot be received if the
    # security manager's <code>checkAccept</code> method
    # does not allow it.
    # 
    # @param      p   the <code>DatagramPacket</code> into which to place
    # the incoming data.
    # @exception  IOException  if an I/O error occurs.
    # @exception  SocketTimeoutException  if setSoTimeout was previously called
    # and the timeout has expired.
    # @exception  PortUnreachableException may be thrown if the socket is connected
    # to a currently unreachable destination. Note, there is no guarantee that the
    # exception will be thrown.
    # @exception  java.nio.channels.IllegalBlockingModeException
    # if this socket has an associated channel,
    # and the channel is in non-blocking mode.
    # @see        java.net.DatagramPacket
    # @see        java.net.DatagramSocket
    # @revised 1.4
    # @spec JSR-51
    def receive(p)
      synchronized(self) do
        synchronized((p)) do
          if (!is_bound)
            bind(InetSocketAddress.new(0))
          end
          if ((@connect_state).equal?(ST_NOT_CONNECTED))
            # check the address is ok with the security manager before every recv.
            security = System.get_security_manager
            if (!(security).nil?)
              while (true)
                peek_ad = nil
                peek_port = 0
                # peek at the packet to see who it is from.
                if (!@old_impl)
                  # We can use the new peekData() API
                  peek_packet = DatagramPacket.new(Array.typed(::Java::Byte).new(1) { 0 }, 1)
                  peek_port = get_impl.peek_data(peek_packet)
                  peek_ad = RJava.cast_to_string(peek_packet.get_address.get_host_address)
                else
                  adr = InetAddress.new
                  peek_port = get_impl.peek(adr)
                  peek_ad = RJava.cast_to_string(adr.get_host_address)
                end
                begin
                  security.check_accept(peek_ad, peek_port)
                  # security check succeeded - so now break
                  # and recv the packet.
                  break
                rescue SecurityException => se
                  # Throw away the offending packet by consuming
                  # it in a tmp buffer.
                  tmp = DatagramPacket.new(Array.typed(::Java::Byte).new(1) { 0 }, 1)
                  get_impl.receive(tmp)
                  # silently discard the offending packet
                  # and continue: unknown/malicious
                  # entities on nets should not make
                  # runtime throw security exception and
                  # disrupt the applet by sending random
                  # datagram packets.
                  next
                end
              end # end of while
            end
          end
          if ((@connect_state).equal?(ST_CONNECTED_NO_IMPL))
            # We have to do the filtering the old fashioned way since
            # the native impl doesn't support connect or the connect
            # via the impl failed.
            stop = false
            while (!stop)
              # peek at the packet to see who it is from.
              peek_address = InetAddress.new
              peek_port = get_impl.peek(peek_address)
              if ((!(@connected_address == peek_address)) || (!(@connected_port).equal?(peek_port)))
                # throw the packet away and silently continue
                tmp = DatagramPacket.new(Array.typed(::Java::Byte).new(1) { 0 }, 1)
                get_impl.receive(tmp)
              else
                stop = true
              end
            end
          end
          # If the security check succeeds, or the datagram is
          # connected then receive the packet
          get_impl.receive(p)
        end
      end
    end
    
    typesig { [] }
    # Gets the local address to which the socket is bound.
    # 
    # <p>If there is a security manager, its
    # <code>checkConnect</code> method is first called
    # with the host address and <code>-1</code>
    # as its arguments to see if the operation is allowed.
    # 
    # @see SecurityManager#checkConnect
    # @return  the local address to which the socket is bound, or
    # an <code>InetAddress</code> representing any local
    # address if either the socket is not bound, or
    # the security manager <code>checkConnect</code>
    # method does not allow the operation
    # @since   1.1
    def get_local_address
      if (is_closed)
        return nil
      end
      in_ = nil
      begin
        in_ = get_impl.get_option(SocketOptions::SO_BINDADDR)
        if (in_.is_any_local_address)
          in_ = InetAddress.any_local_address
        end
        s = System.get_security_manager
        if (!(s).nil?)
          s.check_connect(in_.get_host_address, -1)
        end
      rescue JavaException => e
        in_ = InetAddress.any_local_address # "0.0.0.0"
      end
      return in_
    end
    
    typesig { [] }
    # Returns the port number on the local host to which this socket
    # is bound.
    # 
    # @return  the port number on the local host to which this socket is bound.
    def get_local_port
      if (is_closed)
        return -1
      end
      begin
        return get_impl.get_local_port
      rescue JavaException => e
        return 0
      end
    end
    
    typesig { [::Java::Int] }
    # Enable/disable SO_TIMEOUT with the specified timeout, in
    # milliseconds. With this option set to a non-zero timeout,
    # a call to receive() for this DatagramSocket
    # will block for only this amount of time.  If the timeout expires,
    # a <B>java.net.SocketTimeoutException</B> is raised, though the
    # DatagramSocket is still valid.  The option <B>must</B> be enabled
    # prior to entering the blocking operation to have effect.  The
    # timeout must be > 0.
    # A timeout of zero is interpreted as an infinite timeout.
    # 
    # @param timeout the specified timeout in milliseconds.
    # @throws SocketException if there is an error in the underlying protocol, such as an UDP error.
    # @since   JDK1.1
    # @see #getSoTimeout()
    def set_so_timeout(timeout)
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        get_impl.set_option(SocketOptions::SO_TIMEOUT, timeout)
      end
    end
    
    typesig { [] }
    # Retrieve setting for SO_TIMEOUT.  0 returns implies that the
    # option is disabled (i.e., timeout of infinity).
    # 
    # @return the setting for SO_TIMEOUT
    # @throws SocketException if there is an error in the underlying protocol, such as an UDP error.
    # @since   JDK1.1
    # @see #setSoTimeout(int)
    def get_so_timeout
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        if ((get_impl).nil?)
          return 0
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
    # <tt>DatagramSocket</tt>. The SO_SNDBUF option is used by the
    # network implementation as a hint to size the underlying
    # network I/O buffers. The SO_SNDBUF setting may also be used
    # by the network implementation to determine the maximum size
    # of the packet that can be sent on this socket.
    # <p>
    # As SO_SNDBUF is a hint, applications that want to verify
    # what size the buffer is should call {@link #getSendBufferSize()}.
    # <p>
    # Increasing the buffer size may allow multiple outgoing packets
    # to be queued by the network implementation when the send rate
    # is high.
    # <p>
    # Note: If {@link #send(DatagramPacket)} is used to send a
    # <code>DatagramPacket</code> that is larger than the setting
    # of SO_SNDBUF then it is implementation specific if the
    # packet is sent or discarded.
    # 
    # @param size the size to which to set the send buffer
    # size. This value must be greater than 0.
    # 
    # @exception SocketException if there is an error
    # in the underlying protocol, such as an UDP error.
    # @exception IllegalArgumentException if the value is 0 or is
    # negative.
    # @see #getSendBufferSize()
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
    # Get value of the SO_SNDBUF option for this <tt>DatagramSocket</tt>, that is the
    # buffer size used by the platform for output on this <tt>DatagramSocket</tt>.
    # 
    # @return the value of the SO_SNDBUF option for this <tt>DatagramSocket</tt>
    # @exception SocketException if there is an error in
    # the underlying protocol, such as an UDP error.
    # @see #setSendBufferSize
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
    # <tt>DatagramSocket</tt>. The SO_RCVBUF option is used by the
    # the network implementation as a hint to size the underlying
    # network I/O buffers. The SO_RCVBUF setting may also be used
    # by the network implementation to determine the maximum size
    # of the packet that can be received on this socket.
    # <p>
    # Because SO_RCVBUF is a hint, applications that want to
    # verify what size the buffers were set to should call
    # {@link #getReceiveBufferSize()}.
    # <p>
    # Increasing SO_RCVBUF may allow the network implementation
    # to buffer multiple packets when packets arrive faster than
    # are being received using {@link #receive(DatagramPacket)}.
    # <p>
    # Note: It is implementation specific if a packet larger
    # than SO_RCVBUF can be received.
    # 
    # @param size the size to which to set the receive buffer
    # size. This value must be greater than 0.
    # 
    # @exception SocketException if there is an error in
    # the underlying protocol, such as an UDP error.
    # @exception IllegalArgumentException if the value is 0 or is
    # negative.
    # @see #getReceiveBufferSize()
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
    # Get value of the SO_RCVBUF option for this <tt>DatagramSocket</tt>, that is the
    # buffer size used by the platform for input on this <tt>DatagramSocket</tt>.
    # 
    # @return the value of the SO_RCVBUF option for this <tt>DatagramSocket</tt>
    # @exception SocketException if there is an error in the underlying protocol, such as an UDP error.
    # @see #setReceiveBufferSize(int)
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
    # Enable/disable the SO_REUSEADDR socket option.
    # <p>
    # For UDP sockets it may be necessary to bind more than one
    # socket to the same socket address. This is typically for the
    # purpose of receiving multicast packets
    # (See {@link java.net.MulticastSocket}). The
    # <tt>SO_REUSEADDR</tt> socket option allows multiple
    # sockets to be bound to the same socket address if the
    # <tt>SO_REUSEADDR</tt> socket option is enabled prior
    # to binding the socket using {@link #bind(SocketAddress)}.
    # <p>
    # Note: This functionality is not supported by all existing platforms,
    # so it is implementation specific whether this option will be ignored
    # or not. However, if it is not supported then
    # {@link #getReuseAddress()} will always return <code>false</code>.
    # <p>
    # When a <tt>DatagramSocket</tt> is created the initial setting
    # of <tt>SO_REUSEADDR</tt> is disabled.
    # <p>
    # The behaviour when <tt>SO_REUSEADDR</tt> is enabled or
    # disabled after a socket is bound (See {@link #isBound()})
    # is not defined.
    # 
    # @param on  whether to enable or disable the
    # @exception SocketException if an error occurs enabling or
    # disabling the <tt>SO_RESUEADDR</tt> socket option,
    # or the socket is closed.
    # @since 1.4
    # @see #getReuseAddress()
    # @see #bind(SocketAddress)
    # @see #isBound()
    # @see #isClosed()
    def set_reuse_address(on)
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        # Integer instead of Boolean for compatibility with older DatagramSocketImpl
        if (@old_impl)
          get_impl.set_option(SocketOptions::SO_REUSEADDR, on ? -1 : 0)
        else
          get_impl.set_option(SocketOptions::SO_REUSEADDR, Boolean.value_of(on))
        end
      end
    end
    
    typesig { [] }
    # Tests if SO_REUSEADDR is enabled.
    # 
    # @return a <code>boolean</code> indicating whether or not SO_REUSEADDR is enabled.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as an UDP error.
    # @since   1.4
    # @see #setReuseAddress(boolean)
    def get_reuse_address
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        o = get_impl.get_option(SocketOptions::SO_REUSEADDR)
        return (o).boolean_value
      end
    end
    
    typesig { [::Java::Boolean] }
    # Enable/disable SO_BROADCAST.
    # @param on     whether or not to have broadcast turned on.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as an UDP error.
    # @since 1.4
    # @see #getBroadcast()
    def set_broadcast(on)
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        get_impl.set_option(SocketOptions::SO_BROADCAST, Boolean.value_of(on))
      end
    end
    
    typesig { [] }
    # Tests if SO_BROADCAST is enabled.
    # @return a <code>boolean</code> indicating whether or not SO_BROADCAST is enabled.
    # @exception SocketException if there is an error
    # in the underlying protocol, such as an UDP error.
    # @since 1.4
    # @see #setBroadcast(boolean)
    def get_broadcast
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        return ((get_impl.get_option(SocketOptions::SO_BROADCAST))).boolean_value
      end
    end
    
    typesig { [::Java::Int] }
    # Sets traffic class or type-of-service octet in the IP
    # datagram header for datagrams sent from this DatagramSocket.
    # As the underlying network implementation may ignore this
    # value applications should consider it a hint.
    # 
    # <P> The tc <B>must</B> be in the range <code> 0 <= tc <=
    # 255</code> or an IllegalArgumentException will be thrown.
    # <p>Notes:
    # <p> for Internet Protocol v4 the value consists of an octet
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
    # for Internet Protocol v6 <code>tc</code> is the value that
    # would be placed into the sin6_flowinfo field of the IP header.
    # 
    # @param tc        an <code>int</code> value for the bitset.
    # @throws SocketException if there is an error setting the
    # traffic class or type-of-service
    # @since 1.4
    # @see #getTrafficClass
    def set_traffic_class(tc)
      synchronized(self) do
        if (tc < 0 || tc > 255)
          raise IllegalArgumentException.new("tc is not in range 0 -- 255")
        end
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        get_impl.set_option(SocketOptions::IP_TOS, tc)
      end
    end
    
    typesig { [] }
    # Gets traffic class or type-of-service in the IP datagram
    # header for packets sent from this DatagramSocket.
    # <p>
    # As the underlying network implementation may ignore the
    # traffic class or type-of-service set using {@link #setTrafficClass(int)}
    # this method may return a different value than was previously
    # set using the {@link #setTrafficClass(int)} method on this
    # DatagramSocket.
    # 
    # @return the traffic class or type-of-service already set
    # @throws SocketException if there is an error obtaining the
    # traffic class or type-of-service value.
    # @since 1.4
    # @see #setTrafficClass(int)
    def get_traffic_class
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        return ((get_impl.get_option(SocketOptions::IP_TOS))).int_value
      end
    end
    
    typesig { [] }
    # Closes this datagram socket.
    # <p>
    # Any thread currently blocked in {@link #receive} upon this socket
    # will throw a {@link SocketException}.
    # 
    # <p> If this socket has an associated channel then the channel is closed
    # as well.
    # 
    # @revised 1.4
    # @spec JSR-51
    def close
      synchronized((@close_lock)) do
        if (is_closed)
          return
        end
        @impl.close
        @closed = true
      end
    end
    
    typesig { [] }
    # Returns whether the socket is closed or not.
    # 
    # @return true if the socket has been closed
    # @since 1.4
    def is_closed
      synchronized((@close_lock)) do
        return @closed
      end
    end
    
    typesig { [] }
    # Returns the unique {@link java.nio.channels.DatagramChannel} object
    # associated with this datagram socket, if any.
    # 
    # <p> A datagram socket will have a channel if, and only if, the channel
    # itself was created via the {@link java.nio.channels.DatagramChannel#open
    # DatagramChannel.open} method.
    # 
    # @return  the datagram channel associated with this datagram socket,
    # or <tt>null</tt> if this socket was not created for a channel
    # 
    # @since 1.4
    # @spec JSR-51
    def get_channel
      return nil
    end
    
    class_module.module_eval {
      # User defined factory for all datagram sockets.
      
      def factory
        defined?(@@factory) ? @@factory : @@factory= nil
      end
      alias_method :attr_factory, :factory
      
      def factory=(value)
        @@factory = value
      end
      alias_method :attr_factory=, :factory=
      
      typesig { [DatagramSocketImplFactory] }
      # Sets the datagram socket implementation factory for the
      # application. The factory can be specified only once.
      # <p>
      # When an application creates a new datagram socket, the socket
      # implementation factory's <code>createDatagramSocketImpl</code> method is
      # called to create the actual datagram socket implementation.
      # <p>
      # Passing <code>null</code> to the method is a no-op unless the factory
      # was already set.
      # 
      # <p>If there is a security manager, this method first calls
      # the security manager's <code>checkSetFactory</code> method
      # to ensure the operation is allowed.
      # This could result in a SecurityException.
      # 
      # @param      fac   the desired factory.
      # @exception  IOException  if an I/O error occurs when setting the
      # datagram socket factory.
      # @exception  SocketException  if the factory is already defined.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkSetFactory</code> method doesn't allow the
      # operation.
      # @see
      # java.net.DatagramSocketImplFactory#createDatagramSocketImpl()
      # @see       SecurityManager#checkSetFactory
      # @since 1.3
      def set_datagram_socket_impl_factory(fac)
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
    
    private
    alias_method :initialize__datagram_socket, :initialize
  end
  
end
