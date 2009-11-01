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
  module TwoStacksPlainDatagramSocketImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileDescriptor
    }
  end
  
  # This class defines the plain DatagramSocketImpl that is used for all
  # Windows versions lower than Vista. It adds support for IPv6 on
  # these platforms where available.
  # 
  # For backward compatibility windows platforms that do not have IPv6
  # support also use this implementation, and fd1 gets set to null
  # during socket creation.
  # 
  # @author Chris Hegarty
  class TwoStacksPlainDatagramSocketImpl < TwoStacksPlainDatagramSocketImplImports.const_get :AbstractPlainDatagramSocketImpl
    include_class_members TwoStacksPlainDatagramSocketImplImports
    
    # Used for IPv6 on Windows only
    attr_accessor :fd1
    alias_method :attr_fd1, :fd1
    undef_method :fd1
    alias_method :attr_fd1=, :fd1=
    undef_method :fd1=
    
    # Needed for ipv6 on windows because we need to know
    # if the socket was bound to ::0 or 0.0.0.0, when a caller
    # asks for it. In this case, both sockets are used, but we
    # don't know whether the caller requested ::0 or 0.0.0.0
    # and need to remember it here.
    attr_accessor :any_local_bound_addr
    alias_method :attr_any_local_bound_addr, :any_local_bound_addr
    undef_method :any_local_bound_addr
    alias_method :attr_any_local_bound_addr=, :any_local_bound_addr=
    undef_method :any_local_bound_addr=
    
    attr_accessor :fduse
    alias_method :attr_fduse, :fduse
    undef_method :fduse
    alias_method :attr_fduse=, :fduse=
    undef_method :fduse=
    
    # saved between peek() and receive() calls
    # saved between successive calls to receive, if data is detected
    # on both sockets at same time. To ensure that one socket is not
    # starved, they rotate using this field
    attr_accessor :lastfd
    alias_method :attr_lastfd, :lastfd
    undef_method :lastfd
    alias_method :attr_lastfd=, :lastfd=
    undef_method :lastfd=
    
    class_module.module_eval {
      when_class_loaded do
        init
      end
    }
    
    typesig { [] }
    def create
      synchronized(self) do
        @fd1 = FileDescriptor.new
        super
      end
    end
    
    typesig { [::Java::Int, InetAddress] }
    def bind(lport, laddr)
      synchronized(self) do
        super(lport, laddr)
        if (laddr.is_any_local_address)
          @any_local_bound_addr = laddr
        end
      end
    end
    
    typesig { [DatagramPacket] }
    def receive(p)
      synchronized(self) do
        begin
          receive0(p)
        ensure
          @fduse = -1
        end
      end
    end
    
    typesig { [::Java::Int] }
    def get_option(opt_id)
      if (is_closed)
        raise SocketException.new("Socket Closed")
      end
      if ((opt_id).equal?(SO_BINDADDR))
        if (!(self.attr_fd).nil? && !(@fd1).nil?)
          return @any_local_bound_addr
        end
        return socket_get_option(opt_id)
      else
        return super(opt_id)
      end
    end
    
    typesig { [] }
    def is_closed
      return ((self.attr_fd).nil? && (@fd1).nil?) ? true : false
    end
    
    typesig { [] }
    def close
      if (!(self.attr_fd).nil? || !(@fd1).nil?)
        datagram_socket_close
        self.attr_fd = nil
        @fd1 = nil
      end
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_bind0, [:pointer, :long, :int32, :long], :void
    typesig { [::Java::Int, InetAddress] }
    # Native methods
    def bind0(lport, laddr)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_bind0, JNI.env, self.jni_id, lport.to_int, laddr.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_send, [:pointer, :long, :long], :void
    typesig { [DatagramPacket] }
    def send(p)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_send, JNI.env, self.jni_id, p.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_peek, [:pointer, :long, :long], :int32
    typesig { [InetAddress] }
    def peek(i)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_peek, JNI.env, self.jni_id, i.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_peekData, [:pointer, :long, :long], :int32
    typesig { [DatagramPacket] }
    def peek_data(p)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_peekData, JNI.env, self.jni_id, p.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_receive0, [:pointer, :long, :long], :void
    typesig { [DatagramPacket] }
    def receive0(p)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_receive0, JNI.env, self.jni_id, p.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_setTimeToLive, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def set_time_to_live(ttl)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_setTimeToLive, JNI.env, self.jni_id, ttl.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_getTimeToLive, [:pointer, :long], :int32
    typesig { [] }
    def get_time_to_live
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_getTimeToLive, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_setTTL, [:pointer, :long, :int8], :void
    typesig { [::Java::Byte] }
    def set_ttl(ttl)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_setTTL, JNI.env, self.jni_id, ttl.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_getTTL, [:pointer, :long], :int8
    typesig { [] }
    def get_ttl
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_getTTL, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_join, [:pointer, :long, :long, :long], :void
    typesig { [InetAddress, NetworkInterface] }
    def join(inetaddr, net_if)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_join, JNI.env, self.jni_id, inetaddr.jni_id, net_if.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_leave, [:pointer, :long, :long, :long], :void
    typesig { [InetAddress, NetworkInterface] }
    def leave(inetaddr, net_if)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_leave, JNI.env, self.jni_id, inetaddr.jni_id, net_if.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_datagramSocketCreate, [:pointer, :long], :void
    typesig { [] }
    def datagram_socket_create
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_datagramSocketCreate, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_datagramSocketClose, [:pointer, :long], :void
    typesig { [] }
    def datagram_socket_close
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_datagramSocketClose, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_socketSetOption, [:pointer, :long, :int32, :long], :void
    typesig { [::Java::Int, Object] }
    def socket_set_option(opt, val)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_socketSetOption, JNI.env, self.jni_id, opt.to_int, val.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_socketGetOption, [:pointer, :long, :int32], :long
    typesig { [::Java::Int] }
    def socket_get_option(opt)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_socketGetOption, JNI.env, self.jni_id, opt.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_connect0, [:pointer, :long, :long, :int32], :void
    typesig { [InetAddress, ::Java::Int] }
    def connect0(address, port)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_connect0, JNI.env, self.jni_id, address.jni_id, port.to_int)
    end
    
    JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_disconnect0, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def disconnect0(family)
      JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_disconnect0, JNI.env, self.jni_id, family.to_int)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_net_TwoStacksPlainDatagramSocketImpl_init, [:pointer, :long], :void
      typesig { [] }
      # Perform class load-time initializations.
      def init
        JNI.call_native_method(:Java_java_net_TwoStacksPlainDatagramSocketImpl_init, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    def initialize
      @fd1 = nil
      @any_local_bound_addr = nil
      @fduse = 0
      @lastfd = 0
      super()
      @any_local_bound_addr = nil
      @fduse = -1
      @lastfd = -1
    end
    
    private
    alias_method :initialize__two_stacks_plain_datagram_socket_impl, :initialize
  end
  
end
