require "rjava"

# 
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
  module SocketOptsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include ::Java::Nio
      include_const ::Java::Net, :NetworkInterface
    }
  end
  
  # Typical use:
  # 
  # sc.options()
  # .noDelay(true)
  # .typeOfService(SocketOpts.IP.TOS_RELIABILITY)
  # .sendBufferSize(1024)
  # .receiveBufferSize(1024)
  # .keepAlive(true);
  module SocketOpts
    include_class_members SocketOptsImports
    
    typesig { [] }
    # SocketOptions already used in java.net
    # Options that apply to all kinds of sockets
    # SO_BROADCAST
    def broadcast
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    def broadcast(b)
      raise NotImplementedError
    end
    
    typesig { [] }
    # SO_KEEPALIVE
    def keep_alive
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    def keep_alive(b)
      raise NotImplementedError
    end
    
    typesig { [] }
    # SO_LINGER
    def linger
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def linger(n)
      raise NotImplementedError
    end
    
    typesig { [] }
    # SO_OOBINLINE
    def out_of_band_inline
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    def out_of_band_inline(b)
      raise NotImplementedError
    end
    
    typesig { [] }
    # SO_RCVBUF
    def receive_buffer_size
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def receive_buffer_size(n)
      raise NotImplementedError
    end
    
    typesig { [] }
    # SO_SNDBUF
    def send_buffer_size
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def send_buffer_size(n)
      raise NotImplementedError
    end
    
    typesig { [] }
    # SO_REUSEADDR
    def reuse_address
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    def reuse_address(b)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # IP-specific options
      const_set_lazy(:IP) { Module.new do
        include_class_members SocketOpts
        include SocketOpts
        
        typesig { [] }
        # IP_MULTICAST_IF2
        def multicast_interface
          raise NotImplementedError
        end
        
        typesig { [NetworkInterface] }
        def multicast_interface(ni)
          raise NotImplementedError
        end
        
        typesig { [] }
        # IP_MULTICAST_LOOP
        def multicast_loop
          raise NotImplementedError
        end
        
        typesig { [::Java::Boolean] }
        def multicast_loop(b)
          raise NotImplementedError
        end
        
        class_module.module_eval {
          # IP_TOS
          const_set_lazy(:TOS_LOWDELAY) { 0x10 }
          const_attr_reader  :TOS_LOWDELAY
          
          const_set_lazy(:TOS_THROUGHPUT) { 0x8 }
          const_attr_reader  :TOS_THROUGHPUT
          
          const_set_lazy(:TOS_RELIABILITY) { 0x4 }
          const_attr_reader  :TOS_RELIABILITY
          
          const_set_lazy(:TOS_MINCOST) { 0x2 }
          const_attr_reader  :TOS_MINCOST
        }
        
        typesig { [] }
        def type_of_service
          raise NotImplementedError
        end
        
        typesig { [::Java::Int] }
        def type_of_service(tos)
          raise NotImplementedError
        end
        
        class_module.module_eval {
          # TCP-specific options
          const_set_lazy(:TCP) { Module.new do
            include_class_members IP
            include IP
            
            typesig { [] }
            # TCP_NODELAY
            def no_delay
              raise NotImplementedError
            end
            
            typesig { [::Java::Boolean] }
            def no_delay(b)
              raise NotImplementedError
            end
          end }
        }
      end }
    }
  end
  
end
