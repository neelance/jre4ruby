require "rjava"

# Copyright 2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DualStackPlainDatagramSocketImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileDescriptor
      include_const ::Sun::Misc, :SharedSecrets
      include_const ::Sun::Misc, :JavaIOFileDescriptorAccess
    }
  end
  
  # This class defines the plain DatagramSocketImpl that is used on
  # Windows platforms greater than or equal to Windows Vista. These
  # platforms have a dual layer TCP/IP stack and can handle both IPv4
  # and IPV6 through a single file descriptor.
  # <p>
  # Note: Multicasting on a dual layer TCP/IP stack is always done with
  # TwoStacksPlainDatagramSocketImpl. This is to overcome the lack
  # of behavior defined for multicasting over a dual layer socket by the RFC.
  # 
  # @author Chris Hegarty
  class DualStackPlainDatagramSocketImpl < DualStackPlainDatagramSocketImplImports.const_get :AbstractPlainDatagramSocketImpl
    include_class_members DualStackPlainDatagramSocketImplImports
    
    class_module.module_eval {
      
      def fd_access
        defined?(@@fd_access) ? @@fd_access : @@fd_access= SharedSecrets.get_java_iofile_descriptor_access
      end
      alias_method :attr_fd_access, :fd_access
      
      def fd_access=(value)
        @@fd_access = value
      end
      alias_method :attr_fd_access=, :fd_access=
    }
    
    typesig { [] }
    def datagram_socket_create
      if ((self.attr_fd).nil?)
        raise SocketException.new("Socket closed")
      end
      # v6Only
      newfd = socket_create(false)
      self.attr_fd_access.set(self.attr_fd, newfd)
    end
    
    typesig { [::Java::Int, InetAddress] }
    def bind0(lport, laddr)
      synchronized(self) do
        nativefd = check_and_return_native_fd
        if ((laddr).nil?)
          raise NullPointerException.new("argument address")
        end
        socket_bind(nativefd, laddr, lport)
        if ((lport).equal?(0))
          self.attr_local_port = socket_local_port(nativefd)
        else
          self.attr_local_port = lport
        end
      end
    end
    
    typesig { [InetAddress] }
    def peek(address)
      synchronized(self) do
        nativefd = check_and_return_native_fd
        if ((address).nil?)
          raise NullPointerException.new("Null address in peek()")
        end
        # Use peekData()
        peek_packet = DatagramPacket.new(Array.typed(::Java::Byte).new(1) { 0 }, 1)
        peek_port = peek_data(peek_packet)
        address = peek_packet.get_address
        return peek_port
      end
    end
    
    typesig { [DatagramPacket] }
    def peek_data(p)
      synchronized(self) do
        nativefd = check_and_return_native_fd
        if ((p).nil?)
          raise NullPointerException.new("packet")
        end
        if ((p.get_data).nil?)
          raise NullPointerException.new("packet buffer")
        end
        # peek
        return socket_receive_or_peek_data(nativefd, p, self.attr_timeout, self.attr_connected, true)
      end
    end
    
    typesig { [DatagramPacket] }
    def receive0(p)
      synchronized(self) do
        nativefd = check_and_return_native_fd
        if ((p).nil?)
          raise NullPointerException.new("packet")
        end
        if ((p.get_data).nil?)
          raise NullPointerException.new("packet buffer")
        end
        # receive
        socket_receive_or_peek_data(nativefd, p, self.attr_timeout, self.attr_connected, false)
      end
    end
    
    typesig { [DatagramPacket] }
    def send(p)
      nativefd = check_and_return_native_fd
      if ((p).nil?)
        raise NullPointerException.new("null packet")
      end
      if ((p.get_address).nil? || (p.get_data).nil?)
        raise NullPointerException.new("null address || null buffer")
      end
      socket_send(nativefd, p.get_data, p.get_offset, p.get_length, p.get_address, p.get_port, self.attr_connected)
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def connect0(address, port)
      nativefd = check_and_return_native_fd
      if ((address).nil?)
        raise NullPointerException.new("address")
      end
      socket_connect(nativefd, address, port)
    end
    
    typesig { [::Java::Int] }
    # unused
    def disconnect0(family)
      if ((self.attr_fd).nil? || !self.attr_fd.valid)
        return
      end # disconnect doesn't throw any exceptions
      socket_disconnect(self.attr_fd_access.get(self.attr_fd))
    end
    
    typesig { [] }
    def datagram_socket_close
      if ((self.attr_fd).nil? || !self.attr_fd.valid)
        return
      end # close doesn't throw any exceptions
      socket_close(self.attr_fd_access.get(self.attr_fd))
      self.attr_fd_access.set(self.attr_fd, -1)
    end
    
    typesig { [::Java::Int, Object] }
    def socket_set_option(opt, val)
      nativefd = check_and_return_native_fd
      option_value = 0
      case (opt)
      when IP_TOS, SO_RCVBUF, SO_SNDBUF
        option_value = (val).int_value
      when SO_REUSEADDR, SO_BROADCAST
        option_value = (val).boolean_value ? 1 : 0
      else
        # shouldn't get here
        raise SocketException.new("Option not supported")
      end
      socket_set_int_option(nativefd, opt, option_value)
    end
    
    typesig { [::Java::Int] }
    def socket_get_option(opt)
      nativefd = check_and_return_native_fd
      # SO_BINDADDR is not a socket option.
      if ((opt).equal?(SO_BINDADDR))
        return socket_local_address(nativefd)
      end
      value = socket_get_int_option(nativefd, opt)
      return_value = nil
      case (opt)
      when SO_REUSEADDR, SO_BROADCAST
        return_value = ((value).equal?(0)) ? Boolean::FALSE : Boolean::TRUE
      when IP_TOS, SO_RCVBUF, SO_SNDBUF
        return_value = value
      else
        # shouldn't get here
        raise SocketException.new("Option not supported")
      end
      return return_value
    end
    
    typesig { [InetAddress, NetworkInterface] }
    # Multicast specific methods.
    # Multicasting on a dual layer TCP/IP stack is always done with
    # TwoStacksPlainDatagramSocketImpl. This is to overcome the lack
    # of behavior defined for multicasting over a dual layer socket by the RFC.
    def join(inetaddr, net_if)
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [InetAddress, NetworkInterface] }
    def leave(inetaddr, net_if)
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [::Java::Int] }
    def set_time_to_live(ttl)
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [] }
    def get_time_to_live
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [::Java::Byte] }
    def set_ttl(ttl)
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [] }
    def get_ttl
      raise IOException.new("Method not implemented!")
    end
    
    typesig { [] }
    # END Multicast specific methods
    def check_and_return_native_fd
      if ((self.attr_fd).nil? || !self.attr_fd.valid)
        raise SocketException.new("Socket closed")
      end
      return self.attr_fd_access.get(self.attr_fd)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_initIDs, [:pointer, :long], :void
      typesig { [] }
      # Native methods
      def init_ids
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_initIDs, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketCreate, [:pointer, :long, :int8], :int32
      typesig { [::Java::Boolean] }
      def socket_create(v6only)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketCreate, JNI.env, self.jni_id, v6only ? 1 : 0)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketBind, [:pointer, :long, :int32, :long, :int32], :void
      typesig { [::Java::Int, InetAddress, ::Java::Int] }
      def socket_bind(fd, local_address, localport)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketBind, JNI.env, self.jni_id, fd.to_int, local_address.jni_id, localport.to_int)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketConnect, [:pointer, :long, :int32, :long, :int32], :void
      typesig { [::Java::Int, InetAddress, ::Java::Int] }
      def socket_connect(fd, address, port)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketConnect, JNI.env, self.jni_id, fd.to_int, address.jni_id, port.to_int)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketDisconnect, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def socket_disconnect(fd)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketDisconnect, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketClose, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def socket_close(fd)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketClose, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketLocalPort, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      def socket_local_port(fd)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketLocalPort, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketLocalAddress, [:pointer, :long, :int32], :long
      typesig { [::Java::Int] }
      def socket_local_address(fd)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketLocalAddress, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketReceiveOrPeekData, [:pointer, :long, :int32, :long, :int32, :int8, :int8], :int32
      typesig { [::Java::Int, DatagramPacket, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
      def socket_receive_or_peek_data(fd, packet, timeout, connected, peek)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketReceiveOrPeekData, JNI.env, self.jni_id, fd.to_int, packet.jni_id, timeout.to_int, connected ? 1 : 0, peek ? 1 : 0)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketSend, [:pointer, :long, :int32, :long, :int32, :int32, :long, :int32, :int8], :void
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, InetAddress, ::Java::Int, ::Java::Boolean] }
      def socket_send(fd, data, offset, length, address, port, connected)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketSend, JNI.env, self.jni_id, fd.to_int, data.jni_id, offset.to_int, length.to_int, address.jni_id, port.to_int, connected ? 1 : 0)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketSetIntOption, [:pointer, :long, :int32, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      def socket_set_int_option(fd, cmd, option_value)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketSetIntOption, JNI.env, self.jni_id, fd.to_int, cmd.to_int, option_value.to_int)
      end
      
      JNI.native_method :Java_java_net_DualStackPlainDatagramSocketImpl_socketGetIntOption, [:pointer, :long, :int32, :int32], :int32
      typesig { [::Java::Int, ::Java::Int] }
      def socket_get_int_option(fd, cmd)
        JNI.__send__(:Java_java_net_DualStackPlainDatagramSocketImpl_socketGetIntOption, JNI.env, self.jni_id, fd.to_int, cmd.to_int)
      end
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__dual_stack_plain_datagram_socket_impl, :initialize
  end
  
end
