require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module OptionAdaptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Net
      include ::Java::Nio
      include ::Java::Nio::Channels
    }
  end
  
  # Adaptor class for java.net-style options
  # 
  # The option get/set methods in the socket, server-socket, and datagram-socket
  # adaptors delegate to an instance of this class.
  # 
  class OptionAdaptor 
    include_class_members OptionAdaptorImports
    
    # package-private
    attr_accessor :opts
    alias_method :attr_opts, :opts
    undef_method :opts
    alias_method :attr_opts=, :opts=
    undef_method :opts=
    
    typesig { [SocketChannelImpl] }
    def initialize(sc)
      @opts = nil
      @opts = sc.options
    end
    
    typesig { [ServerSocketChannelImpl] }
    def initialize(ssc)
      @opts = nil
      @opts = ssc.options
    end
    
    typesig { [DatagramChannelImpl] }
    def initialize(dc)
      @opts = nil
      @opts = dc.options
    end
    
    typesig { [] }
    def opts
      return @opts
    end
    
    typesig { [] }
    def tcp_opts
      return @opts
    end
    
    typesig { [::Java::Boolean] }
    def set_tcp_no_delay(on)
      begin
        tcp_opts.no_delay(on)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_tcp_no_delay
      begin
        return tcp_opts.no_delay
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return false # Never happens
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    def set_so_linger(on, linger)
      begin
        if (linger > 65535)
          linger = 65535
        end
        opts.linger(on ? linger : -1)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_so_linger
      begin
        return opts.linger
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return 0 # Never happens
      end
    end
    
    typesig { [::Java::Boolean] }
    def set_oobinline(on)
      begin
        opts.out_of_band_inline(on)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_oobinline
      begin
        return opts.out_of_band_inline
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return false # Never happens
      end
    end
    
    typesig { [::Java::Int] }
    def set_send_buffer_size(size)
      begin
        opts.send_buffer_size(size)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_send_buffer_size
      begin
        return opts.send_buffer_size
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return 0 # Never happens
      end
    end
    
    typesig { [::Java::Int] }
    def set_receive_buffer_size(size)
      begin
        opts.receive_buffer_size(size)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_receive_buffer_size
      begin
        return opts.receive_buffer_size
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return 0 # Never happens
      end
    end
    
    typesig { [::Java::Boolean] }
    def set_keep_alive(on)
      begin
        opts.keep_alive(on)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_keep_alive
      begin
        return opts.keep_alive
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return false # Never happens
      end
    end
    
    typesig { [::Java::Int] }
    def set_traffic_class(tc)
      if (tc < 0 || tc > 255)
        raise IllegalArgumentException.new("tc is not in range 0 -- 255")
      end
      begin
        opts.type_of_service(tc)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_traffic_class
      begin
        return opts.type_of_service
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return 0 # Never happens
      end
    end
    
    typesig { [::Java::Boolean] }
    def set_reuse_address(on)
      begin
        opts.reuse_address(on)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_reuse_address
      begin
        return opts.reuse_address
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return false # Never happens
      end
    end
    
    typesig { [::Java::Boolean] }
    def set_broadcast(on)
      begin
        opts.broadcast(on)
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def get_broadcast
      begin
        return opts.broadcast
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
        return false # Never happens
      end
    end
    
    private
    alias_method :initialize__option_adaptor, :initialize
  end
  
end
