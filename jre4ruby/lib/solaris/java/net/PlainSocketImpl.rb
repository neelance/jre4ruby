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
  module PlainSocketImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileDescriptor
    }
  end
  
  # On Unix systems we simply delegate to native methods.
  # 
  # @author Chris Hegarty
  class PlainSocketImpl < PlainSocketImplImports.const_get :AbstractPlainSocketImpl
    include_class_members PlainSocketImplImports
    
    class_module.module_eval {
      when_class_loaded do
        init_proto
      end
    }
    
    typesig { [] }
    # Constructs an empty instance.
    def initialize
      super()
    end
    
    typesig { [FileDescriptor] }
    # Constructs an instance with the given file descriptor.
    def initialize(fd)
      super()
      self.attr_fd = fd
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketCreate, [:pointer, :long, :int8], :void
    typesig { [::Java::Boolean] }
    def socket_create(is_server)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketCreate, JNI.env, self.jni_id, is_server ? 1 : 0)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketConnect, [:pointer, :long, :long, :int32, :int32], :void
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    def socket_connect(address, port, timeout)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketConnect, JNI.env, self.jni_id, address.jni_id, port.to_int, timeout.to_int)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketBind, [:pointer, :long, :long, :int32], :void
    typesig { [InetAddress, ::Java::Int] }
    def socket_bind(address, port)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketBind, JNI.env, self.jni_id, address.jni_id, port.to_int)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketListen, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def socket_listen(count)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketListen, JNI.env, self.jni_id, count.to_int)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketAccept, [:pointer, :long, :long], :void
    typesig { [SocketImpl] }
    def socket_accept(s)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketAccept, JNI.env, self.jni_id, s.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketAvailable, [:pointer, :long], :int32
    typesig { [] }
    def socket_available
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketAvailable, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketClose0, [:pointer, :long, :int8], :void
    typesig { [::Java::Boolean] }
    def socket_close0(use_deferred_close)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketClose0, JNI.env, self.jni_id, use_deferred_close ? 1 : 0)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketShutdown, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def socket_shutdown(howto)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketShutdown, JNI.env, self.jni_id, howto.to_int)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_net_PlainSocketImpl_initProto, [:pointer, :long], :void
      typesig { [] }
      def init_proto
        JNI.call_native_method(:Java_java_net_PlainSocketImpl_initProto, JNI.env, self.jni_id)
      end
    }
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketSetOption, [:pointer, :long, :int32, :int8, :long], :void
    typesig { [::Java::Int, ::Java::Boolean, Object] }
    def socket_set_option(cmd, on, value)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketSetOption, JNI.env, self.jni_id, cmd.to_int, on ? 1 : 0, value.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketGetOption, [:pointer, :long, :int32, :long], :int32
    typesig { [::Java::Int, Object] }
    def socket_get_option(opt, ia_container_obj)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketGetOption, JNI.env, self.jni_id, opt.to_int, ia_container_obj.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketGetOption1, [:pointer, :long, :int32, :long, :long], :int32
    typesig { [::Java::Int, Object, FileDescriptor] }
    def socket_get_option1(opt, ia_container_obj, fd)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketGetOption1, JNI.env, self.jni_id, opt.to_int, ia_container_obj.jni_id, fd.jni_id)
    end
    
    JNI.load_native_method :Java_java_net_PlainSocketImpl_socketSendUrgentData, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def socket_send_urgent_data(data)
      JNI.call_native_method(:Java_java_net_PlainSocketImpl_socketSendUrgentData, JNI.env, self.jni_id, data.to_int)
    end
    
    private
    alias_method :initialize__plain_socket_impl, :initialize
  end
  
end
