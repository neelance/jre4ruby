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
  module MulticastSocketImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InterruptedIOException
      include_const ::Java::Util, :Enumeration
    }
  end
  
  # method
  # 
  # The multicast datagram socket class is useful for sending
  # and receiving IP multicast packets.  A MulticastSocket is
  # a (UDP) DatagramSocket, with additional capabilities for
  # joining "groups" of other multicast hosts on the internet.
  # <P>
  # A multicast group is specified by a class D IP address
  # and by a standard UDP port number. Class D IP addresses
  # are in the range <CODE>224.0.0.0</CODE> to <CODE>239.255.255.255</CODE>,
  # inclusive. The address 224.0.0.0 is reserved and should not be used.
  # <P>
  # One would join a multicast group by first creating a MulticastSocket
  # with the desired port, then invoking the
  # <CODE>joinGroup(InetAddress groupAddr)</CODE>
  # method:
  # <PRE>
  # // join a Multicast group and send the group salutations
  # ...
  # String msg = "Hello";
  # InetAddress group = InetAddress.getByName("228.5.6.7");
  # MulticastSocket s = new MulticastSocket(6789);
  # s.joinGroup(group);
  # DatagramPacket hi = new DatagramPacket(msg.getBytes(), msg.length(),
  # group, 6789);
  # s.send(hi);
  # // get their responses!
  # byte[] buf = new byte[1000];
  # DatagramPacket recv = new DatagramPacket(buf, buf.length);
  # s.receive(recv);
  # ...
  # // OK, I'm done talking - leave the group...
  # s.leaveGroup(group);
  # </PRE>
  # 
  # When one sends a message to a multicast group, <B>all</B> subscribing
  # recipients to that host and port receive the message (within the
  # time-to-live range of the packet, see below).  The socket needn't
  # be a member of the multicast group to send messages to it.
  # <P>
  # When a socket subscribes to a multicast group/port, it receives
  # datagrams sent by other hosts to the group/port, as do all other
  # members of the group and port.  A socket relinquishes membership
  # in a group by the leaveGroup(InetAddress addr) method.  <B>
  # Multiple MulticastSocket's</B> may subscribe to a multicast group
  # and port concurrently, and they will all receive group datagrams.
  # <P>
  # Currently applets are not allowed to use multicast sockets.
  # 
  # @author Pavani Diwanji
  # @since  JDK1.1
  class MulticastSocket < MulticastSocketImports.const_get :DatagramSocket
    include_class_members MulticastSocketImports
    
    typesig { [] }
    # Create a multicast socket.
    # 
    # <p>If there is a security manager,
    # its <code>checkListen</code> method is first called
    # with 0 as its argument to ensure the operation is allowed.
    # This could result in a SecurityException.
    # <p>
    # When the socket is created the
    # {@link DatagramSocket#setReuseAddress(boolean)} method is
    # called to enable the SO_REUSEADDR socket option.
    # 
    # @exception IOException if an I/O exception occurs
    # while creating the MulticastSocket
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # @see SecurityManager#checkListen
    # @see java.net.DatagramSocket#setReuseAddress(boolean)
    def initialize
      initialize__multicast_socket(InetSocketAddress.new(0))
    end
    
    typesig { [::Java::Int] }
    # Create a multicast socket and bind it to a specific port.
    # 
    # <p>If there is a security manager,
    # its <code>checkListen</code> method is first called
    # with the <code>port</code> argument
    # as its argument to ensure the operation is allowed.
    # This could result in a SecurityException.
    # <p>
    # When the socket is created the
    # {@link DatagramSocket#setReuseAddress(boolean)} method is
    # called to enable the SO_REUSEADDR socket option.
    # 
    # @param port port to use
    # @exception IOException if an I/O exception occurs
    # while creating the MulticastSocket
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # @see SecurityManager#checkListen
    # @see java.net.DatagramSocket#setReuseAddress(boolean)
    def initialize(port)
      initialize__multicast_socket(InetSocketAddress.new(port))
    end
    
    typesig { [SocketAddress] }
    # Create a MulticastSocket bound to the specified socket address.
    # <p>
    # Or, if the address is <code>null</code>, create an unbound socket.
    # <p>
    # <p>If there is a security manager,
    # its <code>checkListen</code> method is first called
    # with the SocketAddress port as its argument to ensure the operation is allowed.
    # This could result in a SecurityException.
    # <p>
    # When the socket is created the
    # {@link DatagramSocket#setReuseAddress(boolean)} method is
    # called to enable the SO_REUSEADDR socket option.
    # 
    # @param bindaddr Socket address to bind to, or <code>null</code> for
    # an unbound socket.
    # @exception IOException if an I/O exception occurs
    # while creating the MulticastSocket
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkListen</code> method doesn't allow the operation.
    # @see SecurityManager#checkListen
    # @see java.net.DatagramSocket#setReuseAddress(boolean)
    # 
    # @since 1.4
    def initialize(bindaddr)
      @ttl_lock = nil
      @inf_lock = nil
      @inf_address = nil
      super(nil)
      @ttl_lock = Object.new
      @inf_lock = Object.new
      @inf_address = nil
      # Enable SO_REUSEADDR before binding
      set_reuse_address(true)
      if (!(bindaddr).nil?)
        bind(bindaddr)
      end
    end
    
    # The lock on the socket's TTL. This is for set/getTTL and
    # send(packet,ttl).
    attr_accessor :ttl_lock
    alias_method :attr_ttl_lock, :ttl_lock
    undef_method :ttl_lock
    alias_method :attr_ttl_lock=, :ttl_lock=
    undef_method :ttl_lock=
    
    # The lock on the socket's interface - used by setInterface
    # and getInterface
    attr_accessor :inf_lock
    alias_method :attr_inf_lock, :inf_lock
    undef_method :inf_lock
    alias_method :attr_inf_lock=, :inf_lock=
    undef_method :inf_lock=
    
    # The "last" interface set by setInterface on this MulticastSocket
    attr_accessor :inf_address
    alias_method :attr_inf_address, :inf_address
    undef_method :inf_address
    alias_method :attr_inf_address=, :inf_address=
    undef_method :inf_address=
    
    typesig { [::Java::Byte] }
    # Set the default time-to-live for multicast packets sent out
    # on this <code>MulticastSocket</code> in order to control the
    # scope of the multicasts.
    # 
    # <p>The ttl is an <b>unsigned</b> 8-bit quantity, and so <B>must</B> be
    # in the range <code> 0 <= ttl <= 0xFF </code>.
    # 
    # @param ttl the time-to-live
    # @exception IOException if an I/O exception occurs
    # while setting the default time-to-live value
    # @deprecated use the setTimeToLive method instead, which uses
    # <b>int</b> instead of <b>byte</b> as the type for ttl.
    # @see #getTTL()
    def set_ttl(ttl)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      get_impl.set_ttl(ttl)
    end
    
    typesig { [::Java::Int] }
    # Set the default time-to-live for multicast packets sent out
    # on this {@code MulticastSocket} in order to control the
    # scope of the multicasts.
    # 
    # <P> The ttl <B>must</B> be in the range {@code  0 <= ttl <=
    # 255} or an {@code IllegalArgumentException} will be thrown.
    # 
    # @param  ttl
    # the time-to-live
    # 
    # @throws  IOException
    # if an I/O exception occurs while setting the
    # default time-to-live value
    # 
    # @see #getTimeToLive()
    def set_time_to_live(ttl)
      if (ttl < 0 || ttl > 255)
        raise IllegalArgumentException.new("ttl out of range")
      end
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      get_impl.set_time_to_live(ttl)
    end
    
    typesig { [] }
    # Get the default time-to-live for multicast packets sent out on
    # the socket.
    # 
    # @exception IOException if an I/O exception occurs
    # while getting the default time-to-live value
    # @return the default time-to-live value
    # @deprecated use the getTimeToLive method instead, which returns
    # an <b>int</b> instead of a <b>byte</b>.
    # @see #setTTL(byte)
    def get_ttl
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      return get_impl.get_ttl
    end
    
    typesig { [] }
    # Get the default time-to-live for multicast packets sent out on
    # the socket.
    # @exception IOException if an I/O exception occurs while
    # getting the default time-to-live value
    # @return the default time-to-live value
    # @see #setTimeToLive(int)
    def get_time_to_live
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      return get_impl.get_time_to_live
    end
    
    typesig { [InetAddress] }
    # Joins a multicast group. Its behavior may be affected by
    # <code>setInterface</code> or <code>setNetworkInterface</code>.
    # 
    # <p>If there is a security manager, this method first
    # calls its <code>checkMulticast</code> method
    # with the <code>mcastaddr</code> argument
    # as its argument.
    # 
    # @param mcastaddr is the multicast address to join
    # 
    # @exception IOException if there is an error joining
    # or when the address is not a multicast address.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkMulticast</code> method doesn't allow the join.
    # 
    # @see SecurityManager#checkMulticast(InetAddress)
    def join_group(mcastaddr)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_multicast(mcastaddr)
      end
      if (!mcastaddr.is_multicast_address)
        raise SocketException.new("Not a multicast address")
      end
      get_impl.join(mcastaddr)
    end
    
    typesig { [InetAddress] }
    # Leave a multicast group. Its behavior may be affected by
    # <code>setInterface</code> or <code>setNetworkInterface</code>.
    # 
    # <p>If there is a security manager, this method first
    # calls its <code>checkMulticast</code> method
    # with the <code>mcastaddr</code> argument
    # as its argument.
    # 
    # @param mcastaddr is the multicast address to leave
    # @exception IOException if there is an error leaving
    # or when the address is not a multicast address.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkMulticast</code> method doesn't allow the operation.
    # 
    # @see SecurityManager#checkMulticast(InetAddress)
    def leave_group(mcastaddr)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_multicast(mcastaddr)
      end
      if (!mcastaddr.is_multicast_address)
        raise SocketException.new("Not a multicast address")
      end
      get_impl.leave(mcastaddr)
    end
    
    typesig { [SocketAddress, NetworkInterface] }
    # Joins the specified multicast group at the specified interface.
    # 
    # <p>If there is a security manager, this method first
    # calls its <code>checkMulticast</code> method
    # with the <code>mcastaddr</code> argument
    # as its argument.
    # 
    # @param mcastaddr is the multicast address to join
    # @param netIf specifies the local interface to receive multicast
    # datagram packets, or <i>null</i> to defer to the interface set by
    # {@link MulticastSocket#setInterface(InetAddress)} or
    # {@link MulticastSocket#setNetworkInterface(NetworkInterface)}
    # 
    # @exception IOException if there is an error joining
    # or when the address is not a multicast address.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkMulticast</code> method doesn't allow the join.
    # @throws  IllegalArgumentException if mcastaddr is null or is a
    # SocketAddress subclass not supported by this socket
    # 
    # @see SecurityManager#checkMulticast(InetAddress)
    # @since 1.4
    def join_group(mcastaddr, net_if)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if ((mcastaddr).nil? || !(mcastaddr.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      if (self.attr_old_impl)
        raise UnsupportedOperationException.new
      end
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_multicast((mcastaddr).get_address)
      end
      if (!(mcastaddr).get_address.is_multicast_address)
        raise SocketException.new("Not a multicast address")
      end
      get_impl.join_group(mcastaddr, net_if)
    end
    
    typesig { [SocketAddress, NetworkInterface] }
    # Leave a multicast group on a specified local interface.
    # 
    # <p>If there is a security manager, this method first
    # calls its <code>checkMulticast</code> method
    # with the <code>mcastaddr</code> argument
    # as its argument.
    # 
    # @param mcastaddr is the multicast address to leave
    # @param netIf specifies the local interface or <i>null</i> to defer
    # to the interface set by
    # {@link MulticastSocket#setInterface(InetAddress)} or
    # {@link MulticastSocket#setNetworkInterface(NetworkInterface)}
    # @exception IOException if there is an error leaving
    # or when the address is not a multicast address.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkMulticast</code> method doesn't allow the operation.
    # @throws  IllegalArgumentException if mcastaddr is null or is a
    # SocketAddress subclass not supported by this socket
    # 
    # @see SecurityManager#checkMulticast(InetAddress)
    # @since 1.4
    def leave_group(mcastaddr, net_if)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      if ((mcastaddr).nil? || !(mcastaddr.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      if (self.attr_old_impl)
        raise UnsupportedOperationException.new
      end
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_multicast((mcastaddr).get_address)
      end
      if (!(mcastaddr).get_address.is_multicast_address)
        raise SocketException.new("Not a multicast address")
      end
      get_impl.leave_group(mcastaddr, net_if)
    end
    
    typesig { [InetAddress] }
    # Set the multicast network interface used by methods
    # whose behavior would be affected by the value of the
    # network interface. Useful for multihomed hosts.
    # @param inf the InetAddress
    # @exception SocketException if there is an error in
    # the underlying protocol, such as a TCP error.
    # @see #getInterface()
    def set_interface(inf)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      synchronized((@inf_lock)) do
        get_impl.set_option(SocketOptions::IP_MULTICAST_IF, inf)
        @inf_address = inf
      end
    end
    
    typesig { [] }
    # Retrieve the address of the network interface used for
    # multicast packets.
    # 
    # @return An <code>InetAddress</code> representing
    # the address of the network interface used for
    # multicast packets.
    # 
    # @exception SocketException if there is an error in
    # the underlying protocol, such as a TCP error.
    # 
    # @see #setInterface(java.net.InetAddress)
    def get_interface
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      synchronized((@inf_lock)) do
        ia = get_impl.get_option(SocketOptions::IP_MULTICAST_IF)
        # No previous setInterface or interface can be
        # set using setNetworkInterface
        if ((@inf_address).nil?)
          return ia
        end
        # Same interface set with setInterface?
        if ((ia == @inf_address))
          return ia
        end
        # Different InetAddress from what we set with setInterface
        # so enumerate the current interface to see if the
        # address set by setInterface is bound to this interface.
        begin
          ni = NetworkInterface.get_by_inet_address(ia)
          addrs = ni.get_inet_addresses
          while (addrs.has_more_elements)
            addr = (addrs.next_element)
            if ((addr == @inf_address))
              return @inf_address
            end
          end
          # No match so reset infAddress to indicate that the
          # interface has changed via means
          @inf_address = nil
          return ia
        rescue JavaException => e
          return ia
        end
      end
    end
    
    typesig { [NetworkInterface] }
    # Specify the network interface for outgoing multicast datagrams
    # sent on this socket.
    # 
    # @param netIf the interface
    # @exception SocketException if there is an error in
    # the underlying protocol, such as a TCP error.
    # @see #getNetworkInterface()
    # @since 1.4
    def set_network_interface(net_if)
      synchronized((@inf_lock)) do
        get_impl.set_option(SocketOptions::IP_MULTICAST_IF2, net_if)
        @inf_address = nil
      end
    end
    
    typesig { [] }
    # Get the multicast network interface set.
    # 
    # @exception SocketException if there is an error in
    # the underlying protocol, such as a TCP error.
    # @return the multicast <code>NetworkInterface</code> currently set
    # @see #setNetworkInterface(NetworkInterface)
    # @since 1.4
    def get_network_interface
      ni = get_impl.get_option(SocketOptions::IP_MULTICAST_IF2)
      if ((ni.get_index).equal?(0))
        addrs = Array.typed(InetAddress).new(1) { nil }
        addrs[0] = InetAddress.any_local_address
        return NetworkInterface.new(addrs[0].get_host_name, 0, addrs)
      else
        return ni
      end
    end
    
    typesig { [::Java::Boolean] }
    # Disable/Enable local loopback of multicast datagrams
    # The option is used by the platform's networking code as a hint
    # for setting whether multicast data will be looped back to
    # the local socket.
    # 
    # <p>Because this option is a hint, applications that want to
    # verify what loopback mode is set to should call
    # {@link #getLoopbackMode()}
    # @param disable <code>true</code> to disable the LoopbackMode
    # @throws SocketException if an error occurs while setting the value
    # @since 1.4
    # @see #getLoopbackMode
    def set_loopback_mode(disable)
      get_impl.set_option(SocketOptions::IP_MULTICAST_LOOP, Boolean.value_of(disable))
    end
    
    typesig { [] }
    # Get the setting for local loopback of multicast datagrams.
    # 
    # @throws SocketException  if an error occurs while getting the value
    # @return true if the LoopbackMode has been disabled
    # @since 1.4
    # @see #setLoopbackMode
    def get_loopback_mode
      return (get_impl.get_option(SocketOptions::IP_MULTICAST_LOOP)).boolean_value
    end
    
    typesig { [DatagramPacket, ::Java::Byte] }
    # Sends a datagram packet to the destination, with a TTL (time-
    # to-live) other than the default for the socket.  This method
    # need only be used in instances where a particular TTL is desired;
    # otherwise it is preferable to set a TTL once on the socket, and
    # use that default TTL for all packets.  This method does <B>not
    # </B> alter the default TTL for the socket. Its behavior may be
    # affected by <code>setInterface</code>.
    # 
    # <p>If there is a security manager, this method first performs some
    # security checks. First, if <code>p.getAddress().isMulticastAddress()</code>
    # is true, this method calls the
    # security manager's <code>checkMulticast</code> method
    # with <code>p.getAddress()</code> and <code>ttl</code> as its arguments.
    # If the evaluation of that expression is false,
    # this method instead calls the security manager's
    # <code>checkConnect</code> method with arguments
    # <code>p.getAddress().getHostAddress()</code> and
    # <code>p.getPort()</code>. Each call to a security manager method
    # could result in a SecurityException if the operation is not allowed.
    # 
    # @param p is the packet to be sent. The packet should contain
    # the destination multicast ip address and the data to be sent.
    # One does not need to be the member of the group to send
    # packets to a destination multicast address.
    # @param ttl optional time to live for multicast packet.
    # default ttl is 1.
    # 
    # @exception IOException is raised if an error occurs i.e
    # error while setting ttl.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkMulticast</code> or <code>checkConnect</code>
    # method doesn't allow the send.
    # 
    # @deprecated Use the following code or its equivalent instead:
    # ......
    # int ttl = mcastSocket.getTimeToLive();
    # mcastSocket.setTimeToLive(newttl);
    # mcastSocket.send(p);
    # mcastSocket.setTimeToLive(ttl);
    # ......
    # 
    # @see DatagramSocket#send
    # @see DatagramSocket#receive
    # @see SecurityManager#checkMulticast(java.net.InetAddress, byte)
    # @see SecurityManager#checkConnect
    def send(p, ttl)
      if (is_closed)
        raise SocketException.new("Socket is closed")
      end
      synchronized((@ttl_lock)) do
        synchronized((p)) do
          if ((self.attr_connect_state).equal?(ST_NOT_CONNECTED))
            # Security manager makes sure that the multicast address
            # is allowed one and that the ttl used is less
            # than the allowed maxttl.
            security = System.get_security_manager
            if (!(security).nil?)
              if (p.get_address.is_multicast_address)
                security.check_multicast(p.get_address, ttl)
              else
                security.check_connect(p.get_address.get_host_address, p.get_port)
              end
            end
          else
            # we're connected
            packet_address = nil
            packet_address = p.get_address
            if ((packet_address).nil?)
              p.set_address(self.attr_connected_address)
              p.set_port(self.attr_connected_port)
            else
              if ((!(packet_address == self.attr_connected_address)) || !(p.get_port).equal?(self.attr_connected_port))
                raise SecurityException.new("connected address and packet address" + " differ")
              end
            end
          end
          dttl = get_ttl
          begin
            if (!(ttl).equal?(dttl))
              # set the ttl
              get_impl.set_ttl(ttl)
            end
            # call the datagram method to send
            get_impl.send(p)
          ensure
            # set it back to default
            if (!(ttl).equal?(dttl))
              get_impl.set_ttl(dttl)
            end
          end
        end # synch p
      end # synch ttl
    end
    
    private
    alias_method :initialize__multicast_socket, :initialize
  end
  
end
