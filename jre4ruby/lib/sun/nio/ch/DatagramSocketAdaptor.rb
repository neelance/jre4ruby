require "rjava"

# 
# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DatagramSocketAdaptorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Net
      include ::Java::Nio
      include ::Java::Nio::Channels
    }
  end
  
  # Make a datagram-socket channel look like a datagram socket.
  # 
  # The methods in this class are defined in exactly the same order as in
  # java.net.DatagramSocket so as to simplify tracking future changes to that
  # class.
  class DatagramSocketAdaptor < DatagramSocketAdaptorImports.const_get :DatagramSocket
    include_class_members DatagramSocketAdaptorImports
    
    # The channel being adapted
    attr_accessor :dc
    alias_method :attr_dc, :dc
    undef_method :dc
    alias_method :attr_dc=, :dc=
    undef_method :dc=
    
    # Option adaptor object, created on demand
    attr_accessor :opts
    alias_method :attr_opts, :opts
    undef_method :opts
    alias_method :attr_opts=, :opts=
    undef_method :opts=
    
    # Timeout "option" value for receives
    attr_accessor :timeout
    alias_method :attr_timeout, :timeout
    undef_method :timeout
    alias_method :attr_timeout=, :timeout=
    undef_method :timeout=
    
    # Traffic-class/Type-of-service
    attr_accessor :traffic_class
    alias_method :attr_traffic_class, :traffic_class
    undef_method :traffic_class
    alias_method :attr_traffic_class=, :traffic_class=
    undef_method :traffic_class=
    
    typesig { [DatagramChannelImpl] }
    # ## super will create a useless impl
    def initialize(dc)
      # Invoke the DatagramSocketAdaptor(SocketAddress) constructor,
      # passing a dummy DatagramSocketImpl object to aovid any native
      # resource allocation in super class and invoking our bind method
      # before the dc field is initialized.
      @dc = nil
      @opts = nil
      @timeout = 0
      @traffic_class = 0
      super(DummyDatagramSocket)
      @opts = nil
      @timeout = 0
      @traffic_class = 0
      @dc = dc
    end
    
    class_module.module_eval {
      typesig { [DatagramChannelImpl] }
      def create(dc)
        begin
          return DatagramSocketAdaptor.new(dc)
        rescue IOException => x
          raise JavaError.new(x)
        end
      end
    }
    
    typesig { [SocketAddress] }
    def connect_internal(remote)
      isa = Net.as_inet_socket_address(remote)
      port = isa.get_port
      if (port < 0 || port > 0xffff)
        raise IllegalArgumentException.new("connect: " + (port).to_s)
      end
      if ((remote).nil?)
        raise IllegalArgumentException.new("connect: null address")
      end
      if (!is_closed)
        return
      end
      begin
        @dc.connect(remote)
      rescue Exception => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [SocketAddress] }
    def bind(local)
      begin
        if ((local).nil?)
          local = InetSocketAddress.new(0)
        end
        @dc.bind(local)
      rescue Exception => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def connect(address, port)
      begin
        connect_internal(InetSocketAddress.new(address, port))
      rescue SocketException => x
        # Yes, j.n.DatagramSocket really does this
      end
    end
    
    typesig { [SocketAddress] }
    def connect(remote)
      if ((remote).nil?)
        raise IllegalArgumentException.new("Address can't be null")
      end
      connect_internal(remote)
    end
    
    typesig { [] }
    def disconnect
      begin
        @dc.disconnect
      rescue IOException => x
        raise JavaError.new(x)
      end
    end
    
    typesig { [] }
    def is_bound
      return @dc.is_bound
    end
    
    typesig { [] }
    def is_connected
      return @dc.is_connected
    end
    
    typesig { [] }
    def get_inet_address
      return (is_connected ? Net.as_inet_socket_address(@dc.remote_address).get_address : nil)
    end
    
    typesig { [] }
    def get_port
      return (is_connected ? Net.as_inet_socket_address(@dc.remote_address).get_port : -1)
    end
    
    typesig { [DatagramPacket] }
    def send(p)
      synchronized((@dc.blocking_lock)) do
        if (!@dc.is_blocking)
          raise IllegalBlockingModeException.new
        end
        begin
          synchronized((p)) do
            bb = ByteBuffer.wrap(p.get_data, p.get_offset, p.get_length)
            if (@dc.is_connected)
              if ((p.get_address).nil?)
                # Legacy DatagramSocket will send in this case
                # and set address and port of the packet
                isa = @dc.attr_remote_address
                p.set_port(isa.get_port)
                p.set_address(isa.get_address)
                @dc.write(bb)
              else
                # Target address may not match connected address
                @dc.send(bb, p.get_socket_address)
              end
            else
              # Not connected so address must be valid or throw
              @dc.send(bb, p.get_socket_address)
            end
          end
        rescue IOException => x
          Net.translate_exception(x)
        end
      end
    end
    
    typesig { [ByteBuffer] }
    # Must hold dc.blockingLock()
    def receive(bb)
      if ((@timeout).equal?(0))
        @dc.receive(bb)
        return
      end
      # Implement timeout with a selector
      sk = nil
      sel = nil
      @dc.configure_blocking(false)
      begin
        n = 0
        if (!(@dc.receive(bb)).nil?)
          return
        end
        sel = Util.get_temporary_selector(@dc)
        sk = @dc.register(sel, SelectionKey::OP_READ)
        to = @timeout
        loop do
          if (!@dc.is_open)
            raise ClosedChannelException.new
          end
          st = System.current_time_millis
          ns = sel.select(to)
          if (ns > 0 && sk.is_readable)
            if (!(@dc.receive(bb)).nil?)
              return
            end
          end
          sel.selected_keys.remove(sk)
          to -= System.current_time_millis - st
          if (to <= 0)
            raise SocketTimeoutException.new
          end
        end
      ensure
        if (!(sk).nil?)
          sk.cancel
        end
        if (@dc.is_open)
          @dc.configure_blocking(true)
        end
        if (!(sel).nil?)
          Util.release_temporary_selector(sel)
        end
      end
    end
    
    typesig { [DatagramPacket] }
    def receive(p)
      synchronized((@dc.blocking_lock)) do
        if (!@dc.is_blocking)
          raise IllegalBlockingModeException.new
        end
        begin
          synchronized((p)) do
            bb = ByteBuffer.wrap(p.get_data, p.get_offset, p.get_length)
            receive(bb)
            p.set_length(bb.position - p.get_offset)
          end
        rescue IOException => x
          Net.translate_exception(x)
        end
      end
    end
    
    typesig { [] }
    def get_local_address
      if (is_closed)
        return nil
      end
      begin
        return Net.as_inet_socket_address(@dc.local_address).get_address
      rescue Exception => x
        return InetSocketAddress.new(0).get_address
      end
    end
    
    typesig { [] }
    def get_local_port
      if (is_closed)
        return -1
      end
      begin
        return Net.as_inet_socket_address(@dc.local_address).get_port
      rescue Exception => x
        return 0
      end
    end
    
    typesig { [::Java::Int] }
    def set_so_timeout(timeout)
      @timeout = timeout
    end
    
    typesig { [] }
    def get_so_timeout
      return @timeout
    end
    
    typesig { [] }
    def opts
      if ((@opts).nil?)
        @opts = OptionAdaptor.new(@dc)
      end
      return @opts
    end
    
    typesig { [::Java::Int] }
    def set_send_buffer_size(size)
      opts.set_send_buffer_size(size)
    end
    
    typesig { [] }
    def get_send_buffer_size
      return opts.get_send_buffer_size
    end
    
    typesig { [::Java::Int] }
    def set_receive_buffer_size(size)
      opts.set_receive_buffer_size(size)
    end
    
    typesig { [] }
    def get_receive_buffer_size
      return opts.get_receive_buffer_size
    end
    
    typesig { [::Java::Boolean] }
    def set_reuse_address(on)
      opts.set_reuse_address(on)
    end
    
    typesig { [] }
    def get_reuse_address
      return opts.get_reuse_address
    end
    
    typesig { [::Java::Boolean] }
    def set_broadcast(on)
      opts.set_broadcast(on)
    end
    
    typesig { [] }
    def get_broadcast
      return opts.get_broadcast
    end
    
    typesig { [::Java::Int] }
    def set_traffic_class(tc)
      opts.set_traffic_class(tc)
      @traffic_class = tc
    end
    
    typesig { [] }
    def get_traffic_class
      tc = opts.get_traffic_class
      if (tc < 0)
        tc = @traffic_class
      end
      return tc
    end
    
    typesig { [] }
    def close
      begin
        @dc.close
      rescue IOException => x
        raise JavaError.new(x)
      end
    end
    
    typesig { [] }
    def is_closed
      return !@dc.is_open
    end
    
    typesig { [] }
    def get_channel
      return @dc
    end
    
    class_module.module_eval {
      const_set_lazy(:DummyDatagramSocket) { # 
      # A dummy implementation of DatagramSocketImpl that can be passed to the
      # DatagramSocket constructor so that no native resources are allocated in
      # super class.
      Class.new(DatagramSocketImpl.class == Class ? DatagramSocketImpl : Object) do
        extend LocalClass
        include_class_members DatagramSocketAdaptor
        include DatagramSocketImpl if DatagramSocketImpl.class == Module
        
        typesig { [] }
        define_method :create do
        end
        
        typesig { [::Java::Int, InetAddress] }
        define_method :bind do |lport, laddr|
        end
        
        typesig { [DatagramPacket] }
        define_method :send do |p|
        end
        
        typesig { [InetAddress] }
        define_method :peek do |i|
          return 0
        end
        
        typesig { [DatagramPacket] }
        define_method :peek_data do |p|
          return 0
        end
        
        typesig { [DatagramPacket] }
        define_method :receive do |p|
        end
        
        typesig { [::Java::Byte] }
        define_method :set_ttl do |ttl|
        end
        
        typesig { [] }
        define_method :get_ttl do
          return 0
        end
        
        typesig { [::Java::Int] }
        define_method :set_time_to_live do |ttl|
        end
        
        typesig { [] }
        define_method :get_time_to_live do
          return 0
        end
        
        typesig { [InetAddress] }
        define_method :join do |inetaddr|
        end
        
        typesig { [InetAddress] }
        define_method :leave do |inetaddr|
        end
        
        typesig { [SocketAddress, NetworkInterface] }
        define_method :join_group do |mcastaddr, net_if|
        end
        
        typesig { [SocketAddress, NetworkInterface] }
        define_method :leave_group do |mcastaddr, net_if|
        end
        
        typesig { [] }
        define_method :close do
        end
        
        typesig { [::Java::Int] }
        define_method :get_option do |opt_id|
          return nil
        end
        
        typesig { [::Java::Int, Object] }
        define_method :set_option do |opt_id, value|
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :DummyDatagramSocket
    }
    
    private
    alias_method :initialize__datagram_socket_adaptor, :initialize
  end
  
end
