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
  module DatagramSocketImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InterruptedIOException
    }
  end
  
  # Abstract datagram and multicast socket implementation base class.
  # @author Pavani Diwanji
  # @since  JDK1.1
  class DatagramSocketImpl 
    include_class_members DatagramSocketImplImports
    include SocketOptions
    
    # The local port number.
    attr_accessor :local_port
    alias_method :attr_local_port, :local_port
    undef_method :local_port
    alias_method :attr_local_port=, :local_port=
    undef_method :local_port=
    
    # The file descriptor object.
    attr_accessor :fd
    alias_method :attr_fd, :fd
    undef_method :fd
    alias_method :attr_fd=, :fd=
    undef_method :fd=
    
    typesig { [] }
    # Creates a datagram socket.
    # @exception SocketException if there is an error in the
    # underlying protocol, such as a TCP error.
    def create
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, InetAddress] }
    # Binds a datagram socket to a local port and address.
    # @param lport the local port
    # @param laddr the local address
    # @exception SocketException if there is an error in the
    # underlying protocol, such as a TCP error.
    def bind(lport, laddr)
      raise NotImplementedError
    end
    
    typesig { [DatagramPacket] }
    # Sends a datagram packet. The packet contains the data and the
    # destination address to send the packet to.
    # @param p the packet to be sent.
    # @exception IOException if an I/O exception occurs while sending the
    # datagram packet.
    # @exception  PortUnreachableException may be thrown if the socket is connected
    # to a currently unreachable destination. Note, there is no guarantee that
    # the exception will be thrown.
    def send(p)
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Connects a datagram socket to a remote destination. This associates the remote
    # address with the local socket so that datagrams may only be sent to this destination
    # and received from this destination. This may be overridden to call a native
    # system connect.
    # 
    # <p>If the remote destination to which the socket is connected does not
    # exist, or is otherwise unreachable, and if an ICMP destination unreachable
    # packet has been received for that address, then a subsequent call to
    # send or receive may throw a PortUnreachableException.
    # Note, there is no guarantee that the exception will be thrown.
    # @param address the remote InetAddress to connect to
    # @param port the remote port number
    # @exception   SocketException may be thrown if the socket cannot be
    # connected to the remote destination
    # @since 1.4
    def connect(address, port)
    end
    
    typesig { [] }
    # Disconnects a datagram socket from its remote destination.
    # @since 1.4
    def disconnect
    end
    
    typesig { [InetAddress] }
    # Peek at the packet to see who it is from. Updates the specified <code>InetAddress</code>
    # to the address which the packet came from.
    # @param i an InetAddress object
    # @return the port number which the packet came from.
    # @exception IOException if an I/O exception occurs
    # @exception  PortUnreachableException may be thrown if the socket is connected
    # to a currently unreachable destination. Note, there is no guarantee that the
    # exception will be thrown.
    def peek(i)
      raise NotImplementedError
    end
    
    typesig { [DatagramPacket] }
    # Peek at the packet to see who it is from. The data is copied into the specified
    # <code>DatagramPacket</code>. The data is returned,
    # but not consumed, so that a subsequent peekData/receive operation
    # will see the same data.
    # @param p the Packet Received.
    # @return the port number which the packet came from.
    # @exception IOException if an I/O exception occurs
    # @exception  PortUnreachableException may be thrown if the socket is connected
    # to a currently unreachable destination. Note, there is no guarantee that the
    # exception will be thrown.
    # @since 1.4
    def peek_data(p)
      raise NotImplementedError
    end
    
    typesig { [DatagramPacket] }
    # Receive the datagram packet.
    # @param p the Packet Received.
    # @exception IOException if an I/O exception occurs
    # while receiving the datagram packet.
    # @exception  PortUnreachableException may be thrown if the socket is connected
    # to a currently unreachable destination. Note, there is no guarantee that the
    # exception will be thrown.
    def receive(p)
      raise NotImplementedError
    end
    
    typesig { [::Java::Byte] }
    # Set the TTL (time-to-live) option.
    # @param ttl a byte specifying the TTL value
    # 
    # @deprecated use setTimeToLive instead.
    # @exception IOException if an I/O exception occurs while setting
    # the time-to-live option.
    # @see #getTTL()
    def set_ttl(ttl)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Retrieve the TTL (time-to-live) option.
    # 
    # @exception IOException if an I/O exception occurs
    # while retrieving the time-to-live option
    # @deprecated use getTimeToLive instead.
    # @return a byte representing the TTL value
    # @see #setTTL(byte)
    def get_ttl
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Set the TTL (time-to-live) option.
    # @param ttl an <tt>int</tt> specifying the time-to-live value
    # @exception IOException if an I/O exception occurs
    # while setting the time-to-live option.
    # @see #getTimeToLive()
    def set_time_to_live(ttl)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Retrieve the TTL (time-to-live) option.
    # @exception IOException if an I/O exception occurs
    # while retrieving the time-to-live option
    # @return an <tt>int</tt> representing the time-to-live value
    # @see #setTimeToLive(int)
    def get_time_to_live
      raise NotImplementedError
    end
    
    typesig { [InetAddress] }
    # Join the multicast group.
    # @param inetaddr multicast address to join.
    # @exception IOException if an I/O exception occurs
    # while joining the multicast group.
    def join(inetaddr)
      raise NotImplementedError
    end
    
    typesig { [InetAddress] }
    # Leave the multicast group.
    # @param inetaddr multicast address to leave.
    # @exception IOException if an I/O exception occurs
    # while leaving the multicast group.
    def leave(inetaddr)
      raise NotImplementedError
    end
    
    typesig { [SocketAddress, NetworkInterface] }
    # Join the multicast group.
    # @param mcastaddr address to join.
    # @param netIf specifies the local interface to receive multicast
    # datagram packets
    # @throws IOException if an I/O exception occurs while joining
    # the multicast group
    # @since 1.4
    def join_group(mcastaddr, net_if)
      raise NotImplementedError
    end
    
    typesig { [SocketAddress, NetworkInterface] }
    # Leave the multicast group.
    # @param mcastaddr address to leave.
    # @param netIf specified the local interface to leave the group at
    # @throws IOException if an I/O exception occurs while leaving
    # the multicast group
    # @since 1.4
    def leave_group(mcastaddr, net_if)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Close the socket.
    def close
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the local port.
    # @return an <tt>int</tt> representing the local port value
    def get_local_port
      return @local_port
    end
    
    typesig { [] }
    # Gets the datagram socket file descriptor.
    # @return a <tt>FileDescriptor</tt> object representing the datagram socket
    # file descriptor
    def get_file_descriptor
      return @fd
    end
    
    typesig { [] }
    def initialize
      @local_port = 0
      @fd = nil
    end
    
    private
    alias_method :initialize__datagram_socket_impl, :initialize
  end
  
end
