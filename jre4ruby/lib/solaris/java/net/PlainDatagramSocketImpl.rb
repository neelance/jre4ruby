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
  module PlainDatagramSocketImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
    }
  end
  
  # On Unix systems we simply delegate to native methods.
  # 
  # @author Chris Hegarty
  class PlainDatagramSocketImpl < PlainDatagramSocketImplImports.const_get :AbstractPlainDatagramSocketImpl
    include_class_members PlainDatagramSocketImplImports
    
    class_module.module_eval {
      when_class_loaded do
        init
      end
    }
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_bind0, [:pointer, :long, :int32, :long], :void
    typesig { [::Java::Int, InetAddress] }
    def bind0(lport, laddr)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_bind0, JNI.env, self.jni_id, lport.to_int, laddr.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_send, [:pointer, :long, :long], :void
    typesig { [DatagramPacket] }
    def send(p)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_send, JNI.env, self.jni_id, p.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_peek, [:pointer, :long, :long], :int32
    typesig { [InetAddress] }
    def peek(i)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_peek, JNI.env, self.jni_id, i.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_peekData, [:pointer, :long, :long], :int32
    typesig { [DatagramPacket] }
    def peek_data(p)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_peekData, JNI.env, self.jni_id, p.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_receive0, [:pointer, :long, :long], :void
    typesig { [DatagramPacket] }
    def receive0(p)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_receive0, JNI.env, self.jni_id, p.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_setTimeToLive, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def set_time_to_live(ttl)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_setTimeToLive, JNI.env, self.jni_id, ttl.to_int)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_getTimeToLive, [:pointer, :long], :int32
    typesig { [] }
    def get_time_to_live
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_getTimeToLive, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_setTTL, [:pointer, :long, :int8], :void
    typesig { [::Java::Byte] }
    def set_ttl(ttl)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_setTTL, JNI.env, self.jni_id, ttl.to_int)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_getTTL, [:pointer, :long], :int8
    typesig { [] }
    def get_ttl
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_getTTL, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_join, [:pointer, :long, :long, :long], :void
    typesig { [InetAddress, NetworkInterface] }
    def join(inetaddr, net_if)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_join, JNI.env, self.jni_id, inetaddr.jni_id, net_if.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_leave, [:pointer, :long, :long, :long], :void
    typesig { [InetAddress, NetworkInterface] }
    def leave(inetaddr, net_if)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_leave, JNI.env, self.jni_id, inetaddr.jni_id, net_if.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_datagramSocketCreate, [:pointer, :long], :void
    typesig { [] }
    def datagram_socket_create
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_datagramSocketCreate, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_datagramSocketClose, [:pointer, :long], :void
    typesig { [] }
    def datagram_socket_close
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_datagramSocketClose, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_socketSetOption, [:pointer, :long, :int32, :long], :void
    typesig { [::Java::Int, Object] }
    def socket_set_option(opt, val)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_socketSetOption, JNI.env, self.jni_id, opt.to_int, val.jni_id)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_socketGetOption, [:pointer, :long, :int32], :long
    typesig { [::Java::Int] }
    def socket_get_option(opt)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_socketGetOption, JNI.env, self.jni_id, opt.to_int)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_connect0, [:pointer, :long, :long, :int32], :void
    typesig { [InetAddress, ::Java::Int] }
    def connect0(address, port)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_connect0, JNI.env, self.jni_id, address.jni_id, port.to_int)
    end
    
    JNI.native_method :Java_java_net_PlainDatagramSocketImpl_disconnect0, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def disconnect0(family)
      JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_disconnect0, JNI.env, self.jni_id, family.to_int)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_net_PlainDatagramSocketImpl_init, [:pointer, :long], :void
      typesig { [] }
      # Perform class load-time initializations.
      def init
        JNI.__send__(:Java_java_net_PlainDatagramSocketImpl_init, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__plain_datagram_socket_impl, :initialize
  end
  
end
