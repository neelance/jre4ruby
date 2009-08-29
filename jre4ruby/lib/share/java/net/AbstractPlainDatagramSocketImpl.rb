require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AbstractPlainDatagramSocketImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InterruptedIOException
      include_const ::Java::Util, :Enumeration
    }
  end
  
  # Abstract datagram and multicast socket implementation base class.
  # Note: This is not a public class, so that applets cannot call
  # into the implementation directly and hence cannot bypass the
  # security checks present in the DatagramSocket and MulticastSocket
  # classes.
  # 
  # @author Pavani Diwanji
  class AbstractPlainDatagramSocketImpl < AbstractPlainDatagramSocketImplImports.const_get :DatagramSocketImpl
    include_class_members AbstractPlainDatagramSocketImplImports
    
    # timeout value for receive()
    attr_accessor :timeout
    alias_method :attr_timeout, :timeout
    undef_method :timeout
    alias_method :attr_timeout=, :timeout=
    undef_method :timeout=
    
    attr_accessor :connected
    alias_method :attr_connected, :connected
    undef_method :connected
    alias_method :attr_connected=, :connected=
    undef_method :connected=
    
    attr_accessor :traffic_class
    alias_method :attr_traffic_class, :traffic_class
    undef_method :traffic_class
    alias_method :attr_traffic_class=, :traffic_class=
    undef_method :traffic_class=
    
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
    
    # cached socket options
    attr_accessor :multicast_interface
    alias_method :attr_multicast_interface, :multicast_interface
    undef_method :multicast_interface
    alias_method :attr_multicast_interface=, :multicast_interface=
    undef_method :multicast_interface=
    
    attr_accessor :loopback_mode
    alias_method :attr_loopback_mode, :loopback_mode
    undef_method :loopback_mode
    alias_method :attr_loopback_mode=, :loopback_mode=
    undef_method :loopback_mode=
    
    attr_accessor :ttl
    alias_method :attr_ttl, :ttl
    undef_method :ttl
    alias_method :attr_ttl=, :ttl=
    undef_method :ttl=
    
    class_module.module_eval {
      # Load net library into runtime.
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("net"))
      end
    }
    
    typesig { [] }
    # Creates a datagram socket
    def create
      synchronized(self) do
        self.attr_fd = FileDescriptor.new
        datagram_socket_create
      end
    end
    
    typesig { [::Java::Int, InetAddress] }
    # Binds a datagram socket to a local port.
    def bind(lport, laddr)
      synchronized(self) do
        bind0(lport, laddr)
      end
    end
    
    typesig { [::Java::Int, InetAddress] }
    def bind0(lport, laddr)
      raise NotImplementedError
    end
    
    typesig { [DatagramPacket] }
    # Sends a datagram packet. The packet contains the data and the
    # destination address to send the packet to.
    # @param packet to be sent.
    def send(p)
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Connects a datagram socket to a remote destination. This associates the remote
    # address with the local socket so that datagrams may only be sent to this destination
    # and received from this destination.
    # @param address the remote InetAddress to connect to
    # @param port the remote port number
    def connect(address, port)
      connect0(address, port)
      @connected_address = address
      @connected_port = port
      @connected = true
    end
    
    typesig { [] }
    # Disconnects a previously connected socket. Does nothing if the socket was
    # not connected already.
    def disconnect
      disconnect0(@connected_address.attr_family)
      @connected = false
      @connected_address = nil
      @connected_port = -1
    end
    
    typesig { [InetAddress] }
    # Peek at the packet to see who it is from.
    # @param return the address which the packet came from.
    def peek(i)
      raise NotImplementedError
    end
    
    typesig { [DatagramPacket] }
    def peek_data(p)
      raise NotImplementedError
    end
    
    typesig { [DatagramPacket] }
    # Receive the datagram packet.
    # @param Packet Received.
    def receive(p)
      synchronized(self) do
        receive0(p)
      end
    end
    
    typesig { [DatagramPacket] }
    def receive0(p)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Set the TTL (time-to-live) option.
    # @param TTL to be set.
    def set_time_to_live(ttl)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Get the TTL (time-to-live) option.
    def get_time_to_live
      raise NotImplementedError
    end
    
    typesig { [::Java::Byte] }
    # Set the TTL (time-to-live) option.
    # @param TTL to be set.
    def set_ttl(ttl)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Get the TTL (time-to-live) option.
    def get_ttl
      raise NotImplementedError
    end
    
    typesig { [InetAddress] }
    # Join the multicast group.
    # @param multicast address to join.
    def join(inetaddr)
      join(inetaddr, nil)
    end
    
    typesig { [InetAddress] }
    # Leave the multicast group.
    # @param multicast address to leave.
    def leave(inetaddr)
      leave(inetaddr, nil)
    end
    
    typesig { [SocketAddress, NetworkInterface] }
    # Join the multicast group.
    # @param multicast address to join.
    # @param netIf specifies the local interface to receive multicast
    # datagram packets
    # @throws  IllegalArgumentException if mcastaddr is null or is a
    # SocketAddress subclass not supported by this socket
    # @since 1.4
    def join_group(mcastaddr, net_if)
      if ((mcastaddr).nil? || !(mcastaddr.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      join((mcastaddr).get_address, net_if)
    end
    
    typesig { [InetAddress, NetworkInterface] }
    def join(inetaddr, net_if)
      raise NotImplementedError
    end
    
    typesig { [SocketAddress, NetworkInterface] }
    # Leave the multicast group.
    # @param multicast address to leave.
    # @param netIf specified the local interface to leave the group at
    # @throws  IllegalArgumentException if mcastaddr is null or is a
    # SocketAddress subclass not supported by this socket
    # @since 1.4
    def leave_group(mcastaddr, net_if)
      if ((mcastaddr).nil? || !(mcastaddr.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      leave((mcastaddr).get_address, net_if)
    end
    
    typesig { [InetAddress, NetworkInterface] }
    def leave(inetaddr, net_if)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Close the socket.
    def close
      if (!(self.attr_fd).nil?)
        datagram_socket_close
        self.attr_fd = nil
      end
    end
    
    typesig { [] }
    def is_closed
      return ((self.attr_fd).nil?) ? true : false
    end
    
    typesig { [] }
    def finalize
      close
    end
    
    typesig { [::Java::Int, Object] }
    # set a value - since we only support (setting) binary options
    # here, o must be a Boolean
    def set_option(opt_id, o)
      if (is_closed)
        raise SocketException.new("Socket Closed")
      end
      case (opt_id)
      # check type safety b4 going native.  These should never
      # fail, since only java.Socket* has access to
      # PlainSocketImpl.setOption().
      when SO_TIMEOUT
        if ((o).nil? || !(o.is_a?(JavaInteger)))
          raise SocketException.new("bad argument for SO_TIMEOUT")
        end
        tmp = (o).int_value
        if (tmp < 0)
          raise IllegalArgumentException.new("timeout < 0")
        end
        @timeout = tmp
        return
      when IP_TOS
        if ((o).nil? || !(o.is_a?(JavaInteger)))
          raise SocketException.new("bad argument for IP_TOS")
        end
        @traffic_class = (o).int_value
      when SO_REUSEADDR
        if ((o).nil? || !(o.is_a?(Boolean)))
          raise SocketException.new("bad argument for SO_REUSEADDR")
        end
      when SO_BROADCAST
        if ((o).nil? || !(o.is_a?(Boolean)))
          raise SocketException.new("bad argument for SO_BROADCAST")
        end
      when SO_BINDADDR
        raise SocketException.new("Cannot re-bind Socket")
      when SO_RCVBUF, SO_SNDBUF
        if ((o).nil? || !(o.is_a?(JavaInteger)) || (o).int_value < 0)
          raise SocketException.new("bad argument for SO_SNDBUF or " + "SO_RCVBUF")
        end
      when IP_MULTICAST_IF
        if ((o).nil? || !(o.is_a?(InetAddress)))
          raise SocketException.new("bad argument for IP_MULTICAST_IF")
        end
      when IP_MULTICAST_IF2
        if ((o).nil? || !(o.is_a?(NetworkInterface)))
          raise SocketException.new("bad argument for IP_MULTICAST_IF2")
        end
      when IP_MULTICAST_LOOP
        if ((o).nil? || !(o.is_a?(Boolean)))
          raise SocketException.new("bad argument for IP_MULTICAST_LOOP")
        end
      else
        raise SocketException.new("invalid option: " + RJava.cast_to_string(opt_id))
      end
      socket_set_option(opt_id, o)
    end
    
    typesig { [::Java::Int] }
    # get option's state - set or not
    def get_option(opt_id)
      if (is_closed)
        raise SocketException.new("Socket Closed")
      end
      result = nil
      case (opt_id)
      when SO_TIMEOUT
        result = @timeout
      when IP_TOS
        result = socket_get_option(opt_id)
        if (((result).int_value).equal?(-1))
          result = @traffic_class
        end
      when SO_BINDADDR, IP_MULTICAST_IF, IP_MULTICAST_IF2, SO_RCVBUF, SO_SNDBUF, IP_MULTICAST_LOOP, SO_REUSEADDR, SO_BROADCAST
        result = socket_get_option(opt_id)
      else
        raise SocketException.new("invalid option: " + RJava.cast_to_string(opt_id))
      end
      return result
    end
    
    typesig { [] }
    def datagram_socket_create
      raise NotImplementedError
    end
    
    typesig { [] }
    def datagram_socket_close
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Object] }
    def socket_set_option(opt, val)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def socket_get_option(opt)
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def connect0(address, port)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def disconnect0(family)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
      @timeout = 0
      @connected = false
      @traffic_class = 0
      @connected_address = nil
      @connected_port = 0
      @multicast_interface = 0
      @loopback_mode = false
      @ttl = 0
      super()
      @timeout = 0
      @connected = false
      @traffic_class = 0
      @connected_address = nil
      @connected_port = -1
      @multicast_interface = 0
      @loopback_mode = true
      @ttl = -1
    end
    
    private
    alias_method :initialize__abstract_plain_datagram_socket_impl, :initialize
  end
  
end
