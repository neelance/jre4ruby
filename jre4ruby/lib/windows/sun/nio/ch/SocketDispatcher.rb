require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module SocketDispatcherImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
    }
  end
  
  # Allows different platforms to call different native methods
  # for read and write operations.
  class SocketDispatcher < SocketDispatcherImports.const_get :NativeDispatcher
    include_class_members SocketDispatcherImports
    
    class_module.module_eval {
      when_class_loaded do
        Util.load
      end
    }
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def read(fd, address, len)
      return read0(fd, address, len)
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def readv(fd, address, len)
      return readv0(fd, address, len)
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def write(fd, address, len)
      return write0(fd, address, len)
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def writev(fd, address, len)
      return writev0(fd, address, len)
    end
    
    typesig { [FileDescriptor] }
    def close(fd)
    end
    
    typesig { [FileDescriptor] }
    def pre_close(fd)
      close0(fd)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_nio_ch_SocketDispatcher_read0, [:pointer, :long, :long, :int64, :int32], :int32
      typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
      # -- Native methods
      def read0(fd, address, len)
        JNI.call_native_method(:Java_sun_nio_ch_SocketDispatcher_read0, JNI.env, self.jni_id, fd.jni_id, address.to_int, len.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_SocketDispatcher_readv0, [:pointer, :long, :long, :int64, :int32], :int64
      typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
      def readv0(fd, address, len)
        JNI.call_native_method(:Java_sun_nio_ch_SocketDispatcher_readv0, JNI.env, self.jni_id, fd.jni_id, address.to_int, len.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_SocketDispatcher_write0, [:pointer, :long, :long, :int64, :int32], :int32
      typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
      def write0(fd, address, len)
        JNI.call_native_method(:Java_sun_nio_ch_SocketDispatcher_write0, JNI.env, self.jni_id, fd.jni_id, address.to_int, len.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_SocketDispatcher_writev0, [:pointer, :long, :long, :int64, :int32], :int64
      typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
      def writev0(fd, address, len)
        JNI.call_native_method(:Java_sun_nio_ch_SocketDispatcher_writev0, JNI.env, self.jni_id, fd.jni_id, address.to_int, len.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_SocketDispatcher_close0, [:pointer, :long, :long], :void
      typesig { [FileDescriptor] }
      def close0(fd)
        JNI.call_native_method(:Java_sun_nio_ch_SocketDispatcher_close0, JNI.env, self.jni_id, fd.jni_id)
      end
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__socket_dispatcher, :initialize
  end
  
end
