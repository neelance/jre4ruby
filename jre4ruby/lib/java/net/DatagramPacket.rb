require "rjava"

# 
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
  module DatagramPacketImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # 
  # This class represents a datagram packet.
  # <p>
  # Datagram packets are used to implement a connectionless packet
  # delivery service. Each message is routed from one machine to
  # another based solely on information contained within that packet.
  # Multiple packets sent from one machine to another might be routed
  # differently, and might arrive in any order. Packet delivery is
  # not guaranteed.
  # 
  # @author  Pavani Diwanji
  # @author  Benjamin Renaud
  # @since   JDK1.0
  class DatagramPacket 
    include_class_members DatagramPacketImports
    
    class_module.module_eval {
      # 
      # Perform class initialization
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("net"))
        init
      end
    }
    
    # 
    # The fields of this class are package-private since DatagramSocketImpl
    # classes needs to access them.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    attr_accessor :buf_length
    alias_method :attr_buf_length, :buf_length
    undef_method :buf_length
    alias_method :attr_buf_length=, :buf_length=
    undef_method :buf_length=
    
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Constructs a <code>DatagramPacket</code> for receiving packets of
    # length <code>length</code>, specifying an offset into the buffer.
    # <p>
    # The <code>length</code> argument must be less than or equal to
    # <code>buf.length</code>.
    # 
    # @param   buf      buffer for holding the incoming datagram.
    # @param   offset   the offset for the buffer
    # @param   length   the number of bytes to read.
    # 
    # @since 1.2
    def initialize(buf, offset, length)
      @buf = nil
      @offset = 0
      @length = 0
      @buf_length = 0
      @address = nil
      @port = 0
      set_data(buf, offset, length)
      @address = nil
      @port = -1
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Constructs a <code>DatagramPacket</code> for receiving packets of
    # length <code>length</code>.
    # <p>
    # The <code>length</code> argument must be less than or equal to
    # <code>buf.length</code>.
    # 
    # @param   buf      buffer for holding the incoming datagram.
    # @param   length   the number of bytes to read.
    def initialize(buf, length)
      initialize__datagram_packet(buf, 0, length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, InetAddress, ::Java::Int] }
    # 
    # Constructs a datagram packet for sending packets of length
    # <code>length</code> with offset <code>ioffset</code>to the
    # specified port number on the specified host. The
    # <code>length</code> argument must be less than or equal to
    # <code>buf.length</code>.
    # 
    # @param   buf      the packet data.
    # @param   offset   the packet data offset.
    # @param   length   the packet data length.
    # @param   address  the destination address.
    # @param   port     the destination port number.
    # @see java.net.InetAddress
    # 
    # @since 1.2
    def initialize(buf, offset, length, address, port)
      @buf = nil
      @offset = 0
      @length = 0
      @buf_length = 0
      @address = nil
      @port = 0
      set_data(buf, offset, length)
      set_address(address)
      set_port(port)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, SocketAddress] }
    # 
    # Constructs a datagram packet for sending packets of length
    # <code>length</code> with offset <code>ioffset</code>to the
    # specified port number on the specified host. The
    # <code>length</code> argument must be less than or equal to
    # <code>buf.length</code>.
    # 
    # @param   buf      the packet data.
    # @param   offset   the packet data offset.
    # @param   length   the packet data length.
    # @param   address  the destination socket address.
    # @throws  IllegalArgumentException if address type is not supported
    # @see java.net.InetAddress
    # 
    # @since 1.4
    def initialize(buf, offset, length, address)
      @buf = nil
      @offset = 0
      @length = 0
      @buf_length = 0
      @address = nil
      @port = 0
      set_data(buf, offset, length)
      set_socket_address(address)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, InetAddress, ::Java::Int] }
    # 
    # Constructs a datagram packet for sending packets of length
    # <code>length</code> to the specified port number on the specified
    # host. The <code>length</code> argument must be less than or equal
    # to <code>buf.length</code>.
    # 
    # @param   buf      the packet data.
    # @param   length   the packet length.
    # @param   address  the destination address.
    # @param   port     the destination port number.
    # @see     java.net.InetAddress
    def initialize(buf, length, address, port)
      initialize__datagram_packet(buf, 0, length, address, port)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, SocketAddress] }
    # 
    # Constructs a datagram packet for sending packets of length
    # <code>length</code> to the specified port number on the specified
    # host. The <code>length</code> argument must be less than or equal
    # to <code>buf.length</code>.
    # 
    # @param   buf      the packet data.
    # @param   length   the packet length.
    # @param   address  the destination address.
    # @throws  IllegalArgumentException if address type is not supported
    # @since 1.4
    # @see     java.net.InetAddress
    def initialize(buf, length, address)
      initialize__datagram_packet(buf, 0, length, address)
    end
    
    typesig { [] }
    # 
    # Returns the IP address of the machine to which this datagram is being
    # sent or from which the datagram was received.
    # 
    # @return  the IP address of the machine to which this datagram is being
    # sent or from which the datagram was received.
    # @see     java.net.InetAddress
    # @see #setAddress(java.net.InetAddress)
    def get_address
      synchronized(self) do
        return @address
      end
    end
    
    typesig { [] }
    # 
    # Returns the port number on the remote host to which this datagram is
    # being sent or from which the datagram was received.
    # 
    # @return  the port number on the remote host to which this datagram is
    # being sent or from which the datagram was received.
    # @see #setPort(int)
    def get_port
      synchronized(self) do
        return @port
      end
    end
    
    typesig { [] }
    # 
    # Returns the data buffer. The data received or the data to be sent
    # starts from the <code>offset</code> in the buffer,
    # and runs for <code>length</code> long.
    # 
    # @return  the buffer used to receive or  send data
    # @see #setData(byte[], int, int)
    def get_data
      synchronized(self) do
        return @buf
      end
    end
    
    typesig { [] }
    # 
    # Returns the offset of the data to be sent or the offset of the
    # data received.
    # 
    # @return  the offset of the data to be sent or the offset of the
    # data received.
    # 
    # @since 1.2
    def get_offset
      synchronized(self) do
        return @offset
      end
    end
    
    typesig { [] }
    # 
    # Returns the length of the data to be sent or the length of the
    # data received.
    # 
    # @return  the length of the data to be sent or the length of the
    # data received.
    # @see #setLength(int)
    def get_length
      synchronized(self) do
        return @length
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Set the data buffer for this packet. This sets the
    # data, length and offset of the packet.
    # 
    # @param buf the buffer to set for this packet
    # 
    # @param offset the offset into the data
    # 
    # @param length the length of the data
    # and/or the length of the buffer used to receive data
    # 
    # @exception NullPointerException if the argument is null
    # 
    # @see #getData
    # @see #getOffset
    # @see #getLength
    # 
    # @since 1.2
    def set_data(buf, offset, length)
      synchronized(self) do
        # this will check to see if buf is null
        if (length < 0 || offset < 0 || (length + offset) < 0 || ((length + offset) > buf.attr_length))
          raise IllegalArgumentException.new("illegal length or offset")
        end
        @buf = buf
        @length = length
        @buf_length = length
        @offset = offset
      end
    end
    
    typesig { [InetAddress] }
    # 
    # Sets the IP address of the machine to which this datagram
    # is being sent.
    # @param iaddr the <code>InetAddress</code>
    # @since   JDK1.1
    # @see #getAddress()
    def set_address(iaddr)
      synchronized(self) do
        @address = iaddr
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Sets the port number on the remote host to which this datagram
    # is being sent.
    # @param iport the port number
    # @since   JDK1.1
    # @see #getPort()
    def set_port(iport)
      synchronized(self) do
        if (iport < 0 || iport > 0xffff)
          raise IllegalArgumentException.new("Port out of range:" + (iport).to_s)
        end
        @port = iport
      end
    end
    
    typesig { [SocketAddress] }
    # 
    # Sets the SocketAddress (usually IP address + port number) of the remote
    # host to which this datagram is being sent.
    # 
    # @param address the <code>SocketAddress</code>
    # @throws  IllegalArgumentException if address is null or is a
    # SocketAddress subclass not supported by this socket
    # 
    # @since 1.4
    # @see #getSocketAddress
    def set_socket_address(address)
      synchronized(self) do
        if ((address).nil? || !(address.is_a?(InetSocketAddress)))
          raise IllegalArgumentException.new("unsupported address type")
        end
        addr = address
        if (addr.is_unresolved)
          raise IllegalArgumentException.new("unresolved address")
        end
        set_address(addr.get_address)
        set_port(addr.get_port)
      end
    end
    
    typesig { [] }
    # 
    # Gets the SocketAddress (usually IP address + port number) of the remote
    # host that this packet is being sent to or is coming from.
    # 
    # @return the <code>SocketAddress</code>
    # @since 1.4
    # @see #setSocketAddress
    def get_socket_address
      synchronized(self) do
        return InetSocketAddress.new(get_address, get_port)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Set the data buffer for this packet. With the offset of
    # this DatagramPacket set to 0, and the length set to
    # the length of <code>buf</code>.
    # 
    # @param buf the buffer to set for this packet.
    # 
    # @exception NullPointerException if the argument is null.
    # 
    # @see #getLength
    # @see #getData
    # 
    # @since JDK1.1
    def set_data(buf)
      synchronized(self) do
        if ((buf).nil?)
          raise NullPointerException.new("null packet buffer")
        end
        @buf = buf
        @offset = 0
        @length = buf.attr_length
        @buf_length = buf.attr_length
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Set the length for this packet. The length of the packet is
    # the number of bytes from the packet's data buffer that will be
    # sent, or the number of bytes of the packet's data buffer that
    # will be used for receiving data. The length must be lesser or
    # equal to the offset plus the length of the packet's buffer.
    # 
    # @param length the length to set for this packet.
    # 
    # @exception IllegalArgumentException if the length is negative
    # of if the length is greater than the packet's data buffer
    # length.
    # 
    # @see #getLength
    # @see #setData
    # 
    # @since JDK1.1
    def set_length(length)
      synchronized(self) do
        if ((length + @offset) > @buf.attr_length || length < 0 || (length + @offset) < 0)
          raise IllegalArgumentException.new("illegal length")
        end
        @length = length
        @buf_length = @length
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_net_DatagramPacket_init, [:pointer, :long], :void
      typesig { [] }
      # 
      # Perform class load-time initializations.
      def init
        JNI.__send__(:Java_java_net_DatagramPacket_init, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__datagram_packet, :initialize
  end
  
end
