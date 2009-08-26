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
module Java::Net
  module SocketOptionsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # Interface of methods to get/set socket options.  This interface is
  # implemented by: <B>SocketImpl</B> and  <B>DatagramSocketImpl</B>.
  # Subclasses of these should override the methods
  # of this interface in order to support their own options.
  # <P>
  # The methods and constants which specify options in this interface are
  # for implementation only.  If you're not subclassing SocketImpl or
  # DatagramSocketImpl, <B>you won't use these directly.</B> There are
  # type-safe methods to get/set each of these options in Socket, ServerSocket,
  # DatagramSocket and MulticastSocket.
  # <P>
  # @author David Brown
  module SocketOptions
    include_class_members SocketOptionsImports
    
    typesig { [::Java::Int, Object] }
    # Enable/disable the option specified by <I>optID</I>.  If the option
    # is to be enabled, and it takes an option-specific "value",  this is
    # passed in <I>value</I>.  The actual type of value is option-specific,
    # and it is an error to pass something that isn't of the expected type:
    # <BR><PRE>
    # SocketImpl s;
    # ...
    # s.setOption(SO_LINGER, new Integer(10));
    # // OK - set SO_LINGER w/ timeout of 10 sec.
    # s.setOption(SO_LINGER, new Double(10));
    # // ERROR - expects java.lang.Integer
    # </PRE>
    # If the requested option is binary, it can be set using this method by
    # a java.lang.Boolean:
    # <BR><PRE>
    # s.setOption(TCP_NODELAY, new Boolean(true));
    # // OK - enables TCP_NODELAY, a binary option
    # </PRE>
    # <BR>
    # Any option can be disabled using this method with a Boolean(false):
    # <BR><PRE>
    # s.setOption(TCP_NODELAY, new Boolean(false));
    # // OK - disables TCP_NODELAY
    # s.setOption(SO_LINGER, new Boolean(false));
    # // OK - disables SO_LINGER
    # </PRE>
    # <BR>
    # For an option that has a notion of on and off, and requires
    # a non-boolean parameter, setting its value to anything other than
    # <I>Boolean(false)</I> implicitly enables it.
    # <BR>
    # Throws SocketException if the option is unrecognized,
    # the socket is closed, or some low-level error occurred
    # <BR>
    # @param optID identifies the option
    # @param value the parameter of the socket option
    # @throws SocketException if the option is unrecognized,
    # the socket is closed, or some low-level error occurred
    # @see #getOption(int)
    def set_option(opt_id, value)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Fetch the value of an option.
    # Binary options will return java.lang.Boolean(true)
    # if enabled, java.lang.Boolean(false) if disabled, e.g.:
    # <BR><PRE>
    # SocketImpl s;
    # ...
    # Boolean noDelay = (Boolean)(s.getOption(TCP_NODELAY));
    # if (noDelay.booleanValue()) {
    # // true if TCP_NODELAY is enabled...
    # ...
    # }
    # </PRE>
    # <P>
    # For options that take a particular type as a parameter,
    # getOption(int) will return the parameter's value, else
    # it will return java.lang.Boolean(false):
    # <PRE>
    # Object o = s.getOption(SO_LINGER);
    # if (o instanceof Integer) {
    # System.out.print("Linger time is " + ((Integer)o).intValue());
    # } else {
    # // the true type of o is java.lang.Boolean(false);
    # }
    # </PRE>
    # 
    # @param optID an <code>int</code> identifying the option to fetch
    # @return the value of the option
    # @throws SocketException if the socket is closed
    # @throws SocketException if <I>optID</I> is unknown along the
    # protocol stack (including the SocketImpl)
    # @see #setOption(int, java.lang.Object)
    def get_option(opt_id)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # The java-supported BSD-style options.
      # 
      # 
      # Disable Nagle's algorithm for this connection.  Written data
      # to the network is not buffered pending acknowledgement of
      # previously written data.
      # <P>
      # Valid for TCP only: SocketImpl.
      # <P>
      # @see Socket#setTcpNoDelay
      # @see Socket#getTcpNoDelay
      const_set_lazy(:TCP_NODELAY) { 0x1 }
      const_attr_reader  :TCP_NODELAY
      
      # Fetch the local address binding of a socket (this option cannot
      # be "set" only "gotten", since sockets are bound at creation time,
      # and so the locally bound address cannot be changed).  The default local
      # address of a socket is INADDR_ANY, meaning any local address on a
      # multi-homed host.  A multi-homed host can use this option to accept
      # connections to only one of its addresses (in the case of a
      # ServerSocket or DatagramSocket), or to specify its return address
      # to the peer (for a Socket or DatagramSocket).  The parameter of
      # this option is an InetAddress.
      # <P>
      # This option <B>must</B> be specified in the constructor.
      # <P>
      # Valid for: SocketImpl, DatagramSocketImpl
      # <P>
      # @see Socket#getLocalAddress
      # @see DatagramSocket#getLocalAddress
      const_set_lazy(:SO_BINDADDR) { 0xf }
      const_attr_reader  :SO_BINDADDR
      
      # Sets SO_REUSEADDR for a socket.  This is used only for MulticastSockets
      # in java, and it is set by default for MulticastSockets.
      # <P>
      # Valid for: DatagramSocketImpl
      const_set_lazy(:SO_REUSEADDR) { 0x4 }
      const_attr_reader  :SO_REUSEADDR
      
      # Sets SO_BROADCAST for a socket. This option enables and disables
      # the ability of the process to send broadcast messages. It is supported
      # for only datagram sockets and only on networks that support
      # the concept of a broadcast message (e.g. Ethernet, token ring, etc.),
      # and it is set by default for DatagramSockets.
      # @since 1.4
      const_set_lazy(:SO_BROADCAST) { 0x20 }
      const_attr_reader  :SO_BROADCAST
      
      # Set which outgoing interface on which to send multicast packets.
      # Useful on hosts with multiple network interfaces, where applications
      # want to use other than the system default.  Takes/returns an InetAddress.
      # <P>
      # Valid for Multicast: DatagramSocketImpl
      # <P>
      # @see MulticastSocket#setInterface(InetAddress)
      # @see MulticastSocket#getInterface()
      const_set_lazy(:IP_MULTICAST_IF) { 0x10 }
      const_attr_reader  :IP_MULTICAST_IF
      
      # Same as above. This option is introduced so that the behaviour
      # with IP_MULTICAST_IF will be kept the same as before, while
      # this new option can support setting outgoing interfaces with either
      # IPv4 and IPv6 addresses.
      # 
      # NOTE: make sure there is no conflict with this
      # @see MulticastSocket#setNetworkInterface(NetworkInterface)
      # @see MulticastSocket#getNetworkInterface()
      # @since 1.4
      const_set_lazy(:IP_MULTICAST_IF2) { 0x1f }
      const_attr_reader  :IP_MULTICAST_IF2
      
      # This option enables or disables local loopback of multicast datagrams.
      # This option is enabled by default for Multicast Sockets.
      # @since 1.4
      const_set_lazy(:IP_MULTICAST_LOOP) { 0x12 }
      const_attr_reader  :IP_MULTICAST_LOOP
      
      # This option sets the type-of-service or traffic class field
      # in the IP header for a TCP or UDP socket.
      # @since 1.4
      const_set_lazy(:IP_TOS) { 0x3 }
      const_attr_reader  :IP_TOS
      
      # Specify a linger-on-close timeout.  This option disables/enables
      # immediate return from a <B>close()</B> of a TCP Socket.  Enabling
      # this option with a non-zero Integer <I>timeout</I> means that a
      # <B>close()</B> will block pending the transmission and acknowledgement
      # of all data written to the peer, at which point the socket is closed
      # <I>gracefully</I>.  Upon reaching the linger timeout, the socket is
      # closed <I>forcefully</I>, with a TCP RST. Enabling the option with a
      # timeout of zero does a forceful close immediately. If the specified
      # timeout value exceeds 65,535 it will be reduced to 65,535.
      # <P>
      # Valid only for TCP: SocketImpl
      # 
      # @see Socket#setSoLinger
      # @see Socket#getSoLinger
      const_set_lazy(:SO_LINGER) { 0x80 }
      const_attr_reader  :SO_LINGER
      
      # Set a timeout on blocking Socket operations:
      # <PRE>
      # ServerSocket.accept();
      # SocketInputStream.read();
      # DatagramSocket.receive();
      # </PRE>
      # 
      # <P> The option must be set prior to entering a blocking
      # operation to take effect.  If the timeout expires and the
      # operation would continue to block,
      # <B>java.io.InterruptedIOException</B> is raised.  The Socket is
      # not closed in this case.
      # 
      # <P> Valid for all sockets: SocketImpl, DatagramSocketImpl
      # 
      # @see Socket#setSoTimeout
      # @see ServerSocket#setSoTimeout
      # @see DatagramSocket#setSoTimeout
      const_set_lazy(:SO_TIMEOUT) { 0x1006 }
      const_attr_reader  :SO_TIMEOUT
      
      # Set a hint the size of the underlying buffers used by the
      # platform for outgoing network I/O. When used in set, this is a
      # suggestion to the kernel from the application about the size of
      # buffers to use for the data to be sent over the socket. When
      # used in get, this must return the size of the buffer actually
      # used by the platform when sending out data on this socket.
      # 
      # Valid for all sockets: SocketImpl, DatagramSocketImpl
      # 
      # @see Socket#setSendBufferSize
      # @see Socket#getSendBufferSize
      # @see DatagramSocket#setSendBufferSize
      # @see DatagramSocket#getSendBufferSize
      const_set_lazy(:SO_SNDBUF) { 0x1001 }
      const_attr_reader  :SO_SNDBUF
      
      # Set a hint the size of the underlying buffers used by the
      # platform for incoming network I/O. When used in set, this is a
      # suggestion to the kernel from the application about the size of
      # buffers to use for the data to be received over the
      # socket. When used in get, this must return the size of the
      # buffer actually used by the platform when receiving in data on
      # this socket.
      # 
      # Valid for all sockets: SocketImpl, DatagramSocketImpl
      # 
      # @see Socket#setReceiveBufferSize
      # @see Socket#getReceiveBufferSize
      # @see DatagramSocket#setReceiveBufferSize
      # @see DatagramSocket#getReceiveBufferSize
      const_set_lazy(:SO_RCVBUF) { 0x1002 }
      const_attr_reader  :SO_RCVBUF
      
      # When the keepalive option is set for a TCP socket and no data
      # has been exchanged across the socket in either direction for
      # 2 hours (NOTE: the actual value is implementation dependent),
      # TCP automatically sends a keepalive probe to the peer. This probe is a
      # TCP segment to which the peer must respond.
      # One of three responses is expected:
      # 1. The peer responds with the expected ACK. The application is not
      # notified (since everything is OK). TCP will send another probe
      # following another 2 hours of inactivity.
      # 2. The peer responds with an RST, which tells the local TCP that
      # the peer host has crashed and rebooted. The socket is closed.
      # 3. There is no response from the peer. The socket is closed.
      # 
      # The purpose of this option is to detect if the peer host crashes.
      # 
      # Valid only for TCP socket: SocketImpl
      # 
      # @see Socket#setKeepAlive
      # @see Socket#getKeepAlive
      const_set_lazy(:SO_KEEPALIVE) { 0x8 }
      const_attr_reader  :SO_KEEPALIVE
      
      # When the OOBINLINE option is set, any TCP urgent data received on
      # the socket will be received through the socket input stream.
      # When the option is disabled (which is the default) urgent data
      # is silently discarded.
      # 
      # @see Socket#setOOBInline
      # @see Socket#getOOBInline
      const_set_lazy(:SO_OOBINLINE) { 0x1003 }
      const_attr_reader  :SO_OOBINLINE
    }
  end
  
end