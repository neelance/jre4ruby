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
  module NetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Lang::Reflect
      include ::Java::Net
      include ::Java::Nio::Channels
    }
  end
  
  class Net 
    include_class_members NetImports
    
    typesig { [] }
    # package-private
    def initialize
    end
    
    class_module.module_eval {
      typesig { [SocketAddress] }
      # -- Miscellaneous utilities --
      def check_address(sa)
        if ((sa).nil?)
          raise IllegalArgumentException.new
        end
        if (!(sa.is_a?(InetSocketAddress)))
          raise UnsupportedAddressTypeException.new
        end # ## needs arg
        isa = sa
        if (isa.is_unresolved)
          raise UnresolvedAddressException.new
        end # ## needs arg
        return isa
      end
      
      typesig { [SocketAddress] }
      def as_inet_socket_address(sa)
        if (!(sa.is_a?(InetSocketAddress)))
          raise UnsupportedAddressTypeException.new
        end
        return sa
      end
      
      typesig { [Exception] }
      def translate_to_socket_exception(x)
        if (x.is_a?(SocketException))
          raise x
        end
        nx = x
        if (x.is_a?(ClosedChannelException))
          nx = SocketException.new("Socket is closed")
        else
          if (x.is_a?(AlreadyBoundException))
            nx = SocketException.new("Already bound")
          else
            if (x.is_a?(NotYetBoundException))
              nx = SocketException.new("Socket is not bound yet")
            else
              if (x.is_a?(UnsupportedAddressTypeException))
                nx = SocketException.new("Unsupported address type")
              else
                if (x.is_a?(UnresolvedAddressException))
                  nx = SocketException.new("Unresolved address")
                end
              end
            end
          end
        end
        if (!(nx).equal?(x))
          nx.init_cause(x)
        end
        if (nx.is_a?(SocketException))
          raise nx
        else
          if (nx.is_a?(RuntimeException))
            raise nx
          else
            raise JavaError.new("Untranslated exception", nx)
          end
        end
      end
      
      typesig { [Exception, ::Java::Boolean] }
      def translate_exception(x, unknown_host_for_unresolved)
        if (x.is_a?(IOException))
          raise x
        end
        # Throw UnknownHostException from here since it cannot
        # be thrown as a SocketException
        if (unknown_host_for_unresolved && (x.is_a?(UnresolvedAddressException)))
          raise UnknownHostException.new
        end
        translate_to_socket_exception(x)
      end
      
      typesig { [Exception] }
      def translate_exception(x)
        translate_exception(x, false)
      end
      
      typesig { [::Java::Boolean] }
      # -- Socket operations --
      def socket(stream)
        return IOUtil.new_fd(socket0(stream, false))
      end
      
      typesig { [::Java::Boolean] }
      def server_socket(stream)
        return IOUtil.new_fd(socket0(stream, true))
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_socket0, [:pointer, :long, :int8, :int8], :int32
      typesig { [::Java::Boolean, ::Java::Boolean] }
      # Due to oddities SO_REUSEADDR on windows reuse is ignored
      def socket0(stream, reuse)
        JNI.__send__(:Java_sun_nio_ch_Net_socket0, JNI.env, self.jni_id, stream ? 1 : 0, reuse ? 1 : 0)
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_bind, [:pointer, :long, :long, :long, :int32], :void
      typesig { [FileDescriptor, InetAddress, ::Java::Int] }
      def bind(fd, addr, port)
        JNI.__send__(:Java_sun_nio_ch_Net_bind, JNI.env, self.jni_id, fd.jni_id, addr.jni_id, port.to_int)
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_connect, [:pointer, :long, :long, :long, :int32, :int32], :int32
      typesig { [FileDescriptor, InetAddress, ::Java::Int, ::Java::Int] }
      def connect(fd, remote, remote_port, traffic_class)
        JNI.__send__(:Java_sun_nio_ch_Net_connect, JNI.env, self.jni_id, fd.jni_id, remote.jni_id, remote_port.to_int, traffic_class.to_int)
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_localPort, [:pointer, :long, :long], :int32
      typesig { [FileDescriptor] }
      def local_port(fd)
        JNI.__send__(:Java_sun_nio_ch_Net_localPort, JNI.env, self.jni_id, fd.jni_id)
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_localInetAddress, [:pointer, :long, :long], :long
      typesig { [FileDescriptor] }
      def local_inet_address(fd)
        JNI.__send__(:Java_sun_nio_ch_Net_localInetAddress, JNI.env, self.jni_id, fd.jni_id)
      end
      
      typesig { [FileDescriptor] }
      def local_address(fd)
        begin
          return InetSocketAddress.new(local_inet_address(fd), local_port(fd))
        rescue IOException => x
          raise JavaError.new(x) # Can't happen
        end
      end
      
      typesig { [FileDescriptor] }
      def local_port_number(fd)
        begin
          return local_port(fd)
        rescue IOException => x
          raise JavaError.new(x) # Can't happen
        end
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_getIntOption0, [:pointer, :long, :long, :int32], :int32
      typesig { [FileDescriptor, ::Java::Int] }
      def get_int_option0(fd, opt)
        JNI.__send__(:Java_sun_nio_ch_Net_getIntOption0, JNI.env, self.jni_id, fd.jni_id, opt.to_int)
      end
      
      typesig { [FileDescriptor, ::Java::Int] }
      def get_int_option(fd, opt)
        return get_int_option0(fd, opt)
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_setIntOption0, [:pointer, :long, :long, :int32, :int32], :void
      typesig { [FileDescriptor, ::Java::Int, ::Java::Int] }
      def set_int_option0(fd, opt, arg)
        JNI.__send__(:Java_sun_nio_ch_Net_setIntOption0, JNI.env, self.jni_id, fd.jni_id, opt.to_int, arg.to_int)
      end
      
      typesig { [FileDescriptor, ::Java::Int, ::Java::Int] }
      def set_int_option(fd, opt, arg)
        set_int_option0(fd, opt, arg)
      end
      
      JNI.native_method :Java_sun_nio_ch_Net_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_sun_nio_ch_Net_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        Util.load
        init_ids
      end
    }
    
    private
    alias_method :initialize__net, :initialize
  end
  
end
