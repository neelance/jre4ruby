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
  module SocketOptsImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :NetworkInterface
      include_const ::Java::Net, :SocketOptions
      include ::Java::Nio::Channels
    }
  end
  
  class SocketOptsImpl 
    include_class_members SocketOptsImplImports
    include SocketOpts
    
    class_module.module_eval {
      # Others that pass addresses, etc., will come later
      const_set_lazy(:Dispatcher) { Class.new do
        include_class_members SocketOptsImpl
        
        typesig { [::Java::Int] }
        def get_int(opt)
          raise NotImplementedError
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def set_int(opt, arg)
          raise NotImplementedError
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__dispatcher, :initialize
      end }
    }
    
    attr_accessor :d
    alias_method :attr_d, :d
    undef_method :d
    alias_method :attr_d=, :d=
    undef_method :d=
    
    typesig { [Dispatcher] }
    def initialize(d)
      @d = nil
      @d = d
    end
    
    typesig { [::Java::Int] }
    def get_boolean(opt)
      return @d.get_int(opt) > 0
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def set_boolean(opt, b)
      @d.set_int(opt, b ? 1 : 0)
    end
    
    typesig { [::Java::Int] }
    def get_int(opt)
      return @d.get_int(opt)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def set_int(opt, n)
      @d.set_int(opt, n)
    end
    
    typesig { [::Java::Int] }
    def get_network_interface(opt)
      raise UnsupportedOperationException.new("NYI")
    end
    
    typesig { [::Java::Int, NetworkInterface] }
    def set_network_interface(opt, ni)
      raise UnsupportedOperationException.new("NYI")
    end
    
    typesig { [StringBuffer, String] }
    def add_to_string(sb, s)
      c = sb.char_at(sb.length - 1)
      if ((!(c).equal?(Character.new(?[.ord))) && (!(c).equal?(Character.new(?=.ord))))
        sb.append(Character.new(?\s.ord))
      end
      sb.append(s)
    end
    
    typesig { [StringBuffer, ::Java::Int] }
    def add_to_string(sb, n)
      add_to_string(sb, JavaInteger.to_s(n))
    end
    
    typesig { [] }
    # SO_BROADCAST
    def broadcast
      return get_boolean(SocketOptions::SO_BROADCAST)
    end
    
    typesig { [::Java::Boolean] }
    def broadcast(b)
      set_boolean(SocketOptions::SO_BROADCAST, b)
      return self
    end
    
    typesig { [] }
    # SO_KEEPALIVE
    def keep_alive
      return get_boolean(SocketOptions::SO_KEEPALIVE)
    end
    
    typesig { [::Java::Boolean] }
    def keep_alive(b)
      set_boolean(SocketOptions::SO_KEEPALIVE, b)
      return self
    end
    
    typesig { [] }
    # SO_LINGER
    def linger
      return get_int(SocketOptions::SO_LINGER)
    end
    
    typesig { [::Java::Int] }
    def linger(n)
      set_int(SocketOptions::SO_LINGER, n)
      return self
    end
    
    typesig { [] }
    # SO_OOBINLINE
    def out_of_band_inline
      return get_boolean(SocketOptions::SO_OOBINLINE)
    end
    
    typesig { [::Java::Boolean] }
    def out_of_band_inline(b)
      set_boolean(SocketOptions::SO_OOBINLINE, b)
      return self
    end
    
    typesig { [] }
    # SO_RCVBUF
    def receive_buffer_size
      return get_int(SocketOptions::SO_RCVBUF)
    end
    
    typesig { [::Java::Int] }
    def receive_buffer_size(n)
      if (n <= 0)
        raise IllegalArgumentException.new("Invalid receive size")
      end
      set_int(SocketOptions::SO_RCVBUF, n)
      return self
    end
    
    typesig { [] }
    # SO_SNDBUF
    def send_buffer_size
      return get_int(SocketOptions::SO_SNDBUF)
    end
    
    typesig { [::Java::Int] }
    def send_buffer_size(n)
      if (n <= 0)
        raise IllegalArgumentException.new("Invalid send size")
      end
      set_int(SocketOptions::SO_SNDBUF, n)
      return self
    end
    
    typesig { [] }
    # SO_REUSEADDR
    def reuse_address
      return get_boolean(SocketOptions::SO_REUSEADDR)
    end
    
    typesig { [::Java::Boolean] }
    def reuse_address(b)
      set_boolean(SocketOptions::SO_REUSEADDR, b)
      return self
    end
    
    typesig { [StringBuffer] }
    # toString
    def to_s(sb)
      n = 0
      if (broadcast)
        add_to_string(sb, "broadcast")
      end
      if (keep_alive)
        add_to_string(sb, "keepalive")
      end
      if ((n = linger) > 0)
        add_to_string(sb, "linger=")
        add_to_string(sb, n)
      end
      if (out_of_band_inline)
        add_to_string(sb, "oobinline")
      end
      if ((n = receive_buffer_size) > 0)
        add_to_string(sb, "rcvbuf=")
        add_to_string(sb, n)
      end
      if ((n = send_buffer_size) > 0)
        add_to_string(sb, "sndbuf=")
        add_to_string(sb, n)
      end
      if (reuse_address)
        add_to_string(sb, "reuseaddr")
      end
    end
    
    typesig { [] }
    def to_s
      sb = StringBuffer.new
      sb.append(self.get_class.get_interfaces[0].get_name)
      sb.append(Character.new(?[.ord))
      i = sb.length
      begin
        to_s(sb)
      rescue IOException => x
        sb.set_length(i)
        sb.append("closed")
      end
      sb.append(Character.new(?].ord))
      return sb.to_s
    end
    
    class_module.module_eval {
      # IP-specific socket options
      const_set_lazy(:IP) { Class.new(SocketOptsImpl) do
        include_class_members SocketOptsImpl
        overload_protected {
          include SocketOpts::IP
        }
        
        typesig { [self::Dispatcher] }
        def initialize(d)
          super(d)
        end
        
        typesig { [] }
        # IP_MULTICAST_IF2
        # ## Do we need IP_MULTICAST_IF also?
        def multicast_interface
          return get_network_interface(SocketOptions::IP_MULTICAST_IF2)
        end
        
        typesig { [self::NetworkInterface] }
        def multicast_interface(ni)
          set_network_interface(SocketOptions::IP_MULTICAST_IF2, ni)
          return self
        end
        
        typesig { [] }
        # IP_MULTICAST_LOOP
        def multicast_loop
          return get_boolean(SocketOptions::IP_MULTICAST_LOOP)
        end
        
        typesig { [::Java::Boolean] }
        def multicast_loop(b)
          set_boolean(SocketOptions::IP_MULTICAST_LOOP, b)
          return self
        end
        
        typesig { [] }
        # IP_TOS
        def type_of_service
          return get_int(SocketOptions::IP_TOS)
        end
        
        typesig { [::Java::Int] }
        def type_of_service(tos)
          set_int(SocketOptions::IP_TOS, tos)
          return self
        end
        
        typesig { [self::StringBuffer] }
        # toString
        def to_s(sb)
          super(sb)
          n = 0
          if ((n = type_of_service) > 0)
            add_to_string(sb, "tos=")
            add_to_string(sb, n)
          end
        end
        
        class_module.module_eval {
          # TCP-specific IP options
          const_set_lazy(:TCP) { Class.new(self.class::SocketOptsImpl::IP) do
            include_class_members IP
            overload_protected {
              include self.class::SocketOpts::IP::TCP
            }
            
            typesig { [self::Dispatcher] }
            def initialize(d)
              super(d)
            end
            
            typesig { [] }
            # TCP_NODELAY
            def no_delay
              return get_boolean(SocketOptions::TCP_NODELAY)
            end
            
            typesig { [::Java::Boolean] }
            def no_delay(b)
              set_boolean(SocketOptions::TCP_NODELAY, b)
              return self
            end
            
            typesig { [self::StringBuffer] }
            # toString
            def to_s(sb)
              super(sb)
              if (no_delay)
                add_to_string(sb, "nodelay")
              end
            end
            
            private
            alias_method :initialize__tcp, :initialize
          end }
        }
        
        private
        alias_method :initialize__ip, :initialize
      end }
    }
    
    private
    alias_method :initialize__socket_opts_impl, :initialize
  end
  
end
