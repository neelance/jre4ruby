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
  module TwoStacksPlainSocketImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileDescriptor
    }
  end
  
  # This class defines the plain SocketImpl that is used for all
  # Windows version lower than Vista. It adds support for IPv6 on
  # these platforms where available.
  # 
  # For backward compatibility Windows platforms that do not have IPv6
  # support also use this implementation, and fd1 gets set to null
  # during socket creation.
  # 
  # @author Chris Hegarty
  class TwoStacksPlainSocketImpl < TwoStacksPlainSocketImplImports.const_get :AbstractPlainSocketImpl
    include_class_members TwoStacksPlainSocketImplImports
    
    # second fd, used for ipv6 on windows only.
    # fd1 is used for listeners and for client sockets at initialization
    # until the socket is connected. Up to this point fd always refers
    # to the ipv4 socket and fd1 to the ipv6 socket. After the socket
    # becomes connected, fd always refers to the connected socket
    # (either v4 or v6) and fd1 is closed.
    # 
    # For ServerSockets, fd always refers to the v4 listener and
    # fd1 the v6 listener.
    attr_accessor :fd1
    alias_method :attr_fd1, :fd1
    undef_method :fd1
    alias_method :attr_fd1=, :fd1=
    undef_method :fd1=
    
    # Needed for ipv6 on windows because we need to know
    # if the socket is bound to ::0 or 0.0.0.0, when a caller
    # asks for it. Otherwise we don't know which socket to ask.
    attr_accessor :any_local_bound_addr
    alias_method :attr_any_local_bound_addr, :any_local_bound_addr
    undef_method :any_local_bound_addr
    alias_method :attr_any_local_bound_addr=, :any_local_bound_addr=
    undef_method :any_local_bound_addr=
    
    # to prevent starvation when listening on two sockets, this is
    # is used to hold the id of the last socket we accepted on.
    attr_accessor :lastfd
    alias_method :attr_lastfd, :lastfd
    undef_method :lastfd
    alias_method :attr_lastfd=, :lastfd=
    undef_method :lastfd=
    
    class_module.module_eval {
      when_class_loaded do
        init_proto
      end
    }
    
    typesig { [] }
    def initialize
      @fd1 = nil
      @any_local_bound_addr = nil
      @lastfd = 0
      super()
      @any_local_bound_addr = nil
      @lastfd = -1
    end
    
    typesig { [FileDescriptor] }
    def initialize(fd)
      @fd1 = nil
      @any_local_bound_addr = nil
      @lastfd = 0
      super()
      @any_local_bound_addr = nil
      @lastfd = -1
      self.attr_fd = fd
    end
    
    typesig { [::Java::Boolean] }
    # Creates a socket with a boolean that specifies whether this
    # is a stream socket (true) or an unconnected UDP socket (false).
    def create(stream)
      synchronized(self) do
        @fd1 = FileDescriptor.new
        super(stream)
      end
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Binds the socket to the specified address of the specified local port.
    # @param address the address
    # @param port the port
    def bind(address, lport)
      synchronized(self) do
        super(address, lport)
        if (address.is_any_local_address)
          @any_local_bound_addr = address
        end
      end
    end
    
    typesig { [::Java::Int] }
    def get_option(opt)
      if (is_closed_or_pending)
        raise SocketException.new("Socket Closed")
      end
      if ((opt).equal?(SO_BINDADDR))
        if (!(self.attr_fd).nil? && !(@fd1).nil?)
          # must be unbound or else bound to anyLocal
          return @any_local_bound_addr
        end
        in_ = InetAddressContainer.new
        socket_get_option(opt, in_)
        return in_.attr_addr
      else
        return super(opt)
      end
    end
    
    typesig { [] }
    # Closes the socket.
    def close
      synchronized((self.attr_fd_lock)) do
        if (!(self.attr_fd).nil? || !(@fd1).nil?)
          if ((self.attr_fd_use_count).equal?(0))
            if (self.attr_close_pending)
              return
            end
            self.attr_close_pending = true
            socket_close
            self.attr_fd = nil
            @fd1 = nil
            return
          else
            # If a thread has acquired the fd and a close
            # isn't pending then use a deferred close.
            # Also decrement fdUseCount to signal the last
            # thread that releases the fd to close it.
            if (!self.attr_close_pending)
              self.attr_close_pending = true
              self.attr_fd_use_count -= 1
              socket_close
            end
          end
        end
      end
    end
    
    typesig { [] }
    def reset
      if (!(self.attr_fd).nil? || !(@fd1).nil?)
        socket_close
      end
      self.attr_fd = nil
      @fd1 = nil
      super
    end
    
    typesig { [] }
    # Return true if already closed or close is pending
    def is_closed_or_pending
      # Lock on fdLock to ensure that we wait if a
      # close is in progress.
      synchronized((self.attr_fd_lock)) do
        if (self.attr_close_pending || ((self.attr_fd).nil? && (@fd1).nil?))
          return true
        else
          return false
        end
      end
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_initProto, [:pointer, :long], :void
      typesig { [] }
      # Native methods
      def init_proto
        JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_initProto, JNI.env, self.jni_id)
      end
    }
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketCreate, [:pointer, :long, :int8], :void
    typesig { [::Java::Boolean] }
    def socket_create(is_server)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketCreate, JNI.env, self.jni_id, is_server ? 1 : 0)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketConnect, [:pointer, :long, :long, :int32, :int32], :void
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    def socket_connect(address, port, timeout)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketConnect, JNI.env, self.jni_id, address.jni_id, port.to_int, timeout.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketBind, [:pointer, :long, :long, :int32], :void
    typesig { [InetAddress, ::Java::Int] }
    def socket_bind(address, port)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketBind, JNI.env, self.jni_id, address.jni_id, port.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketListen, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def socket_listen(count)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketListen, JNI.env, self.jni_id, count.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketAccept, [:pointer, :long, :long], :void
    typesig { [SocketImpl] }
    def socket_accept(s)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketAccept, JNI.env, self.jni_id, s.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketAvailable, [:pointer, :long], :int32
    typesig { [] }
    def socket_available
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketAvailable, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketClose0, [:pointer, :long, :int8], :void
    typesig { [::Java::Boolean] }
    def socket_close0(use_deferred_close)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketClose0, JNI.env, self.jni_id, use_deferred_close ? 1 : 0)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketShutdown, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def socket_shutdown(howto)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketShutdown, JNI.env, self.jni_id, howto.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketSetOption, [:pointer, :long, :int32, :int8, :long], :void
    typesig { [::Java::Int, ::Java::Boolean, Object] }
    def socket_set_option(cmd, on, value)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketSetOption, JNI.env, self.jni_id, cmd.to_int, on ? 1 : 0, value.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketGetOption, [:pointer, :long, :int32, :long], :int32
    typesig { [::Java::Int, Object] }
    def socket_get_option(opt, ia_container_obj)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketGetOption, JNI.env, self.jni_id, opt.to_int, ia_container_obj.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketGetOption1, [:pointer, :long, :int32, :long, :long], :int32
    typesig { [::Java::Int, Object, FileDescriptor] }
    def socket_get_option1(opt, ia_container_obj, fd)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketGetOption1, JNI.env, self.jni_id, opt.to_int, ia_container_obj.jni_id, fd.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainSocketImpl_socketSendUrgentData, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def socket_send_urgent_data(data)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainSocketImpl_socketSendUrgentData, JNI.env, self.jni_id, data.to_int)
    end
    
    private
    alias_method :initialize__two_stacks_plain_socket_impl, :initialize
  end
  
end
