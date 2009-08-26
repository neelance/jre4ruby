require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SocketAdaptorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Lang::Ref
      include ::Java::Net
      include ::Java::Nio
      include ::Java::Nio::Channels
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedExceptionAction
      include ::Java::Util
    }
  end
  
  # Make a socket channel look like a socket.
  # 
  # The only aspects of java.net.Socket-hood that we don't attempt to emulate
  # here are the interrupted-I/O exceptions (which our Solaris implementations
  # attempt to support) and the sending of urgent data.  Otherwise an adapted
  # socket should look enough like a real java.net.Socket to fool most of the
  # developers most of the time, right down to the exception message strings.
  # 
  # The methods in this class are defined in exactly the same order as in
  # java.net.Socket so as to simplify tracking future changes to that class.
  class SocketAdaptor < SocketAdaptorImports.const_get :Socket
    include_class_members SocketAdaptorImports
    
    # The channel being adapted
    attr_accessor :sc
    alias_method :attr_sc, :sc
    undef_method :sc
    alias_method :attr_sc=, :sc=
    undef_method :sc=
    
    # Option adaptor object, created on demand
    attr_accessor :opts
    alias_method :attr_opts, :opts
    undef_method :opts
    alias_method :attr_opts=, :opts=
    undef_method :opts=
    
    # Timeout "option" value for reads
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
    
    typesig { [SocketChannelImpl] }
    # ## super will create a useless impl
    def initialize(sc)
      @sc = nil
      @opts = nil
      @timeout = 0
      @traffic_class = 0
      @socket_input_stream = nil
      super()
      @opts = nil
      @timeout = 0
      @traffic_class = 0
      @socket_input_stream = nil
      @sc = sc
    end
    
    class_module.module_eval {
      typesig { [SocketChannelImpl] }
      def create(sc)
        return SocketAdaptor.new(sc)
      end
    }
    
    typesig { [] }
    def get_channel
      return @sc
    end
    
    typesig { [SocketAddress] }
    # Override this method just to protect against changes in the superclass
    def connect(remote)
      connect(remote, 0)
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    def connect(remote, timeout)
      if ((remote).nil?)
        raise IllegalArgumentException.new("connect: The address can't be null")
      end
      if (timeout < 0)
        raise IllegalArgumentException.new("connect: timeout can't be negative")
      end
      synchronized((@sc.blocking_lock)) do
        if (!@sc.is_blocking)
          raise IllegalBlockingModeException.new
        end
        begin
          if ((timeout).equal?(0))
            @sc.connect(remote)
            return
          end
          # Implement timeout with a selector
          sk = nil
          sel = nil
          @sc.configure_blocking(false)
          begin
            if (@sc.connect(remote))
              return
            end
            sel = Util.get_temporary_selector(@sc)
            sk = @sc.register(sel, SelectionKey::OP_CONNECT)
            to = timeout
            loop do
              if (!@sc.is_open)
                raise ClosedChannelException.new
              end
              st = System.current_time_millis
              ns = sel.select(to)
              if (ns > 0 && sk.is_connectable && @sc.finish_connect)
                break
              end
              sel.selected_keys.remove(sk)
              to -= System.current_time_millis - st
              if (to <= 0)
                begin
                  @sc.close
                rescue IOException => x
                end
                raise SocketTimeoutException.new
              end
            end
          ensure
            if (!(sk).nil?)
              sk.cancel
            end
            if (@sc.is_open)
              @sc.configure_blocking(true)
            end
            if (!(sel).nil?)
              Util.release_temporary_selector(sel)
            end
          end
        rescue JavaException => x
          Net.translate_exception(x, true)
        end
      end
    end
    
    typesig { [SocketAddress] }
    def bind(local)
      begin
        if ((local).nil?)
          local = InetSocketAddress.new(0)
        end
        @sc.bind(local)
      rescue JavaException => x
        Net.translate_exception(x)
      end
    end
    
    typesig { [] }
    def get_inet_address
      if (!@sc.is_connected)
        return nil
      end
      return Net.as_inet_socket_address(@sc.remote_address).get_address
    end
    
    typesig { [] }
    def get_local_address
      if (!@sc.is_bound)
        return InetSocketAddress.new(0).get_address
      end
      return Net.as_inet_socket_address(@sc.local_address).get_address
    end
    
    typesig { [] }
    def get_port
      if (!@sc.is_connected)
        return 0
      end
      return Net.as_inet_socket_address(@sc.remote_address).get_port
    end
    
    typesig { [] }
    def get_local_port
      if (!@sc.is_bound)
        return -1
      end
      return Net.as_inet_socket_address(@sc.local_address).get_port
    end
    
    class_module.module_eval {
      const_set_lazy(:SocketInputStream) { Class.new(ChannelInputStream) do
        extend LocalClass
        include_class_members SocketAdaptor
        
        typesig { [] }
        def initialize
          super(self.attr_sc)
        end
        
        typesig { [self::ByteBuffer] }
        def read(bb)
          synchronized((self.attr_sc.blocking_lock)) do
            if (!self.attr_sc.is_blocking)
              raise self.class::IllegalBlockingModeException.new
            end
            if ((self.attr_timeout).equal?(0))
              return self.attr_sc.read(bb)
            end
            # Implement timeout with a selector
            sk = nil
            sel = nil
            self.attr_sc.configure_blocking(false)
            begin
              n = 0
              if (!((n = self.attr_sc.read(bb))).equal?(0))
                return n
              end
              sel = Util.get_temporary_selector(self.attr_sc)
              sk = self.attr_sc.register(sel, SelectionKey::OP_READ)
              to = self.attr_timeout
              loop do
                if (!self.attr_sc.is_open)
                  raise self.class::ClosedChannelException.new
                end
                st = System.current_time_millis
                ns = sel.select(to)
                if (ns > 0 && sk.is_readable)
                  if (!((n = self.attr_sc.read(bb))).equal?(0))
                    return n
                  end
                end
                sel.selected_keys.remove(sk)
                to -= System.current_time_millis - st
                if (to <= 0)
                  raise self.class::SocketTimeoutException.new
                end
              end
            ensure
              if (!(sk).nil?)
                sk.cancel
              end
              if (self.attr_sc.is_open)
                self.attr_sc.configure_blocking(true)
              end
              if (!(sel).nil?)
                Util.release_temporary_selector(sel)
              end
            end
          end
        end
        
        private
        alias_method :initialize__socket_input_stream, :initialize
      end }
    }
    
    attr_accessor :socket_input_stream
    alias_method :attr_socket_input_stream, :socket_input_stream
    undef_method :socket_input_stream
    alias_method :attr_socket_input_stream=, :socket_input_stream=
    undef_method :socket_input_stream=
    
    typesig { [] }
    def get_input_stream
      if (!@sc.is_open)
        raise SocketException.new("Socket is closed")
      end
      if (!@sc.is_connected)
        raise SocketException.new("Socket is not connected")
      end
      if (!@sc.is_input_open)
        raise SocketException.new("Socket input is shutdown")
      end
      if ((@socket_input_stream).nil?)
        begin
          @socket_input_stream = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members SocketAdaptor
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              return self.class::SocketInputStream.new
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue Java::Security::PrivilegedActionException => e
          raise e.get_exception
        end
      end
      return @socket_input_stream
    end
    
    typesig { [] }
    def get_output_stream
      if (!@sc.is_open)
        raise SocketException.new("Socket is closed")
      end
      if (!@sc.is_connected)
        raise SocketException.new("Socket is not connected")
      end
      if (!@sc.is_output_open)
        raise SocketException.new("Socket output is shutdown")
      end
      os = nil
      begin
        os = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members SocketAdaptor
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Channels.new_output_stream(self.attr_sc)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue Java::Security::PrivilegedActionException => e
        raise e.get_exception
      end
      return os
    end
    
    typesig { [] }
    def opts
      if ((@opts).nil?)
        @opts = OptionAdaptor.new(@sc)
      end
      return @opts
    end
    
    typesig { [::Java::Boolean] }
    def set_tcp_no_delay(on)
      opts.set_tcp_no_delay(on)
    end
    
    typesig { [] }
    def get_tcp_no_delay
      return opts.get_tcp_no_delay
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    def set_so_linger(on, linger)
      opts.set_so_linger(on, linger)
    end
    
    typesig { [] }
    def get_so_linger
      return opts.get_so_linger
    end
    
    typesig { [::Java::Int] }
    def send_urgent_data(data)
      raise SocketException.new("Urgent data not supported")
    end
    
    typesig { [::Java::Boolean] }
    def set_oobinline(on)
      opts.set_oobinline(on)
    end
    
    typesig { [] }
    def get_oobinline
      return opts.get_oobinline
    end
    
    typesig { [::Java::Int] }
    def set_so_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeout can't be negative")
      end
      @timeout = timeout
    end
    
    typesig { [] }
    def get_so_timeout
      return @timeout
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
    def set_keep_alive(on)
      opts.set_keep_alive(on)
    end
    
    typesig { [] }
    def get_keep_alive
      return opts.get_keep_alive
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
    
    typesig { [::Java::Boolean] }
    def set_reuse_address(on)
      opts.set_reuse_address(on)
    end
    
    typesig { [] }
    def get_reuse_address
      return opts.get_reuse_address
    end
    
    typesig { [] }
    def close
      begin
        @sc.close
      rescue JavaException => x
        Net.translate_to_socket_exception(x)
      end
    end
    
    typesig { [] }
    def shutdown_input
      begin
        @sc.shutdown_input
      rescue JavaException => x
        Net.translate_exception(x)
      end
    end
    
    typesig { [] }
    def shutdown_output
      begin
        @sc.shutdown_output
      rescue JavaException => x
        Net.translate_exception(x)
      end
    end
    
    typesig { [] }
    def to_s
      if (@sc.is_connected)
        return "Socket[addr=" + RJava.cast_to_string(get_inet_address) + ",port=" + RJava.cast_to_string(get_port) + ",localport=" + RJava.cast_to_string(get_local_port) + "]"
      end
      return "Socket[unconnected]"
    end
    
    typesig { [] }
    def is_connected
      return @sc.is_connected
    end
    
    typesig { [] }
    def is_bound
      return @sc.is_bound
    end
    
    typesig { [] }
    def is_closed
      return !@sc.is_open
    end
    
    typesig { [] }
    def is_input_shutdown
      return !@sc.is_input_open
    end
    
    typesig { [] }
    def is_output_shutdown
      return !@sc.is_output_open
    end
    
    private
    alias_method :initialize__socket_adaptor, :initialize
  end
  
end
