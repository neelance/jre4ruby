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
  module DualStackPlainSocketImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileDescriptor
      include_const ::Sun::Misc, :SharedSecrets
      include_const ::Sun::Misc, :JavaIOFileDescriptorAccess
    }
  end
  
  # This class defines the plain SocketImpl that is used on Windows platforms
  # greater or equal to Windows Vista. These platforms have a dual
  # layer TCP/IP stack and can handle both IPv4 and IPV6 through a
  # single file descriptor.
  # 
  # @author Chris Hegarty
  class DualStackPlainSocketImpl < DualStackPlainSocketImplImports.const_get :AbstractPlainSocketImpl
    include_class_members DualStackPlainSocketImplImports
    
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
    def initialize
      super()
    end
    
    typesig { [FileDescriptor] }
    def initialize(fd)
      super()
      self.attr_fd = fd
    end
    
    typesig { [::Java::Boolean] }
    def socket_create(stream)
      if ((self.attr_fd).nil?)
        raise SocketException.new("Socket closed")
      end # v6 Only
      newfd = socket0(stream, false)
      self.attr_fd_access.set(self.attr_fd, newfd)
    end
    
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    def socket_connect(address, port, timeout)
      nativefd = check_and_return_native_fd
      if ((address).nil?)
        raise NullPointerException.new("inet address argument is null.")
      end
      connect_result = 0
      if (timeout <= 0)
        connect_result = connect0(nativefd, address, port)
      else
        configure_blocking(nativefd, false)
        begin
          connect_result = connect0(nativefd, address, port)
          if ((connect_result).equal?(WOULDBLOCK))
            wait_for_connect(nativefd, timeout)
          end
        ensure
          configure_blocking(nativefd, true)
        end
      end
      # We need to set the local port field. If bind was called
      # previous to the connect (by the client) then localport field
      # will already be set.
      if ((self.attr_localport).equal?(0))
        self.attr_localport = local_port0(nativefd)
      end
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def socket_bind(address, port)
      nativefd = check_and_return_native_fd
      if ((address).nil?)
        raise NullPointerException.new("inet address argument is null.")
      end
      bind0(nativefd, address, port)
      if ((port).equal?(0))
        self.attr_localport = local_port0(nativefd)
      else
        self.attr_localport = port
      end
      self.attr_address = address
    end
    
    typesig { [::Java::Int] }
    def socket_listen(backlog)
      nativefd = check_and_return_native_fd
      listen0(nativefd, backlog)
    end
    
    typesig { [SocketImpl] }
    def socket_accept(s)
      nativefd = check_and_return_native_fd
      if ((s).nil?)
        raise NullPointerException.new("socket is null")
      end
      newfd = -1
      isaa = Array.typed(InetSocketAddress).new(1) { nil }
      if (self.attr_timeout <= 0)
        newfd = accept0(nativefd, isaa)
      else
        configure_blocking(nativefd, false)
        begin
          wait_for_new_connection(nativefd, self.attr_timeout)
          newfd = accept0(nativefd, isaa)
          if (!(newfd).equal?(-1))
            configure_blocking(newfd, true)
          end
        ensure
          configure_blocking(nativefd, true)
        end
      end
      # Update (SocketImpl)s' fd
      self.attr_fd_access.set(s.attr_fd, newfd)
      # Update socketImpls remote port, address and localport
      isa = isaa[0]
      s.attr_port = isa.get_port
      s.attr_address = isa.get_address
      s.attr_localport = self.attr_localport
    end
    
    typesig { [] }
    def socket_available
      nativefd = check_and_return_native_fd
      return available0(nativefd)
    end
    
    typesig { [::Java::Boolean] }
    def socket_close0(use_deferred_close)
      # unused
      if ((self.attr_fd).nil?)
        raise SocketException.new("Socket closed")
      end
      if (!self.attr_fd.valid)
        return
      end
      close0(self.attr_fd_access.get(self.attr_fd))
      self.attr_fd_access.set(self.attr_fd, -1)
    end
    
    typesig { [::Java::Int] }
    def socket_shutdown(howto)
      nativefd = check_and_return_native_fd
      shutdown0(nativefd, howto)
    end
    
    typesig { [::Java::Int, ::Java::Boolean, Object] }
    def socket_set_option(opt, on, value)
      nativefd = check_and_return_native_fd
      if ((opt).equal?(SO_TIMEOUT))
        # timeout implemented through select.
        return
      end
      option_value = 0
      case (opt)
      when TCP_NODELAY, SO_OOBINLINE, SO_KEEPALIVE, SO_REUSEADDR
        option_value = on ? 1 : 0
      when SO_SNDBUF, SO_RCVBUF, IP_TOS
        option_value = (value).int_value
      when SO_LINGER
        if (on)
          option_value = (value).int_value
        else
          option_value = -1
        end
      else
        # shouldn't get here
        raise SocketException.new("Option not supported")
      end
      set_int_option(nativefd, opt, option_value)
    end
    
    typesig { [::Java::Int, Object] }
    def socket_get_option(opt, ia_container_obj)
      nativefd = check_and_return_native_fd
      # SO_BINDADDR is not a socket option.
      if ((opt).equal?(SO_BINDADDR))
        local_address(nativefd, ia_container_obj)
        return 0 # return value doesn't matter.
      end
      value = get_int_option(nativefd, opt)
      case (opt)
      when TCP_NODELAY, SO_OOBINLINE, SO_KEEPALIVE, SO_REUSEADDR
        return ((value).equal?(0)) ? -1 : 1
      end
      return value
    end
    
    typesig { [::Java::Int, Object, FileDescriptor] }
    def socket_get_option1(opt, ia_container_obj, fd)
      return 0
    end
    
    typesig { [::Java::Int] }
    # un-implemented REMOVE
    def socket_send_urgent_data(data)
      nativefd = check_and_return_native_fd
      send_oob(nativefd, data)
    end
    
    typesig { [] }
    def check_and_return_native_fd
      if ((self.attr_fd).nil? || !self.attr_fd.valid)
        raise SocketException.new("Socket closed")
      end
      return self.attr_fd_access.get(self.attr_fd)
    end
    
    class_module.module_eval {
      const_set_lazy(:WOULDBLOCK) { -2 }
      const_attr_reader  :WOULDBLOCK
      
      # Nothing available (non-blocking)
      when_class_loaded do
        init_ids
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_initIDs, [:pointer, :long], :void
      typesig { [] }
      # Native methods
      def init_ids
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_initIDs, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_socket0, [:pointer, :long, :int8, :int8], :int32
      typesig { [::Java::Boolean, ::Java::Boolean] }
      def socket0(stream, v6only)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_socket0, JNI.env, self.jni_id, stream ? 1 : 0, v6only ? 1 : 0)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_bind0, [:pointer, :long, :int32, :long, :int32], :void
      typesig { [::Java::Int, InetAddress, ::Java::Int] }
      def bind0(fd, local_address_, localport)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_bind0, JNI.env, self.jni_id, fd.to_int, local_address_.jni_id, localport.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_connect0, [:pointer, :long, :int32, :long, :int32], :int32
      typesig { [::Java::Int, InetAddress, ::Java::Int] }
      def connect0(fd, remote, remote_port)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_connect0, JNI.env, self.jni_id, fd.to_int, remote.jni_id, remote_port.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_waitForConnect, [:pointer, :long, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int] }
      def wait_for_connect(fd, timeout)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_waitForConnect, JNI.env, self.jni_id, fd.to_int, timeout.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_localPort0, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      def local_port0(fd)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_localPort0, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_localAddress, [:pointer, :long, :int32, :long], :void
      typesig { [::Java::Int, InetAddressContainer] }
      def local_address(fd, in_)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_localAddress, JNI.env, self.jni_id, fd.to_int, in_.jni_id)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_listen0, [:pointer, :long, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int] }
      def listen0(fd, backlog)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_listen0, JNI.env, self.jni_id, fd.to_int, backlog.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_accept0, [:pointer, :long, :int32, :long], :int32
      typesig { [::Java::Int, Array.typed(InetSocketAddress)] }
      def accept0(fd, isaa)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_accept0, JNI.env, self.jni_id, fd.to_int, isaa.jni_id)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_waitForNewConnection, [:pointer, :long, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int] }
      def wait_for_new_connection(fd, timeout)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_waitForNewConnection, JNI.env, self.jni_id, fd.to_int, timeout.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_available0, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      def available0(fd)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_available0, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_close0, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def close0(fd)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_close0, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_shutdown0, [:pointer, :long, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int] }
      def shutdown0(fd, howto)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_shutdown0, JNI.env, self.jni_id, fd.to_int, howto.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_setIntOption, [:pointer, :long, :int32, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      def set_int_option(fd, cmd, option_value)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_setIntOption, JNI.env, self.jni_id, fd.to_int, cmd.to_int, option_value.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_getIntOption, [:pointer, :long, :int32, :int32], :int32
      typesig { [::Java::Int, ::Java::Int] }
      def get_int_option(fd, cmd)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_getIntOption, JNI.env, self.jni_id, fd.to_int, cmd.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_sendOOB, [:pointer, :long, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int] }
      def send_oob(fd, data)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_sendOOB, JNI.env, self.jni_id, fd.to_int, data.to_int)
      end
      
      JNI.load_native_method :Java_java_net_DualStackPlainSocketImpl_configureBlocking, [:pointer, :long, :int32, :int8], :void
      typesig { [::Java::Int, ::Java::Boolean] }
      def configure_blocking(fd, blocking)
        JNI.call_native_method(:Java_java_net_DualStackPlainSocketImpl_configureBlocking, JNI.env, self.jni_id, fd.to_int, blocking ? 1 : 0)
      end
    }
    
    private
    alias_method :initialize__dual_stack_plain_socket_impl, :initialize
  end
  
end
