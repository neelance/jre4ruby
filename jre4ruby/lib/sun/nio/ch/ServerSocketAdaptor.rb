require "rjava"

# 
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
  # package-private
  module ServerSocketAdaptorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Net
      include ::Java::Nio::Channels
    }
  end
  
  # Make a server-socket channel look like a server socket.
  # 
  # The methods in this class are defined in exactly the same order as in
  # java.net.ServerSocket so as to simplify tracking future changes to that
  # class.
  class ServerSocketAdaptor < ServerSocketAdaptorImports.const_get :ServerSocket
    include_class_members ServerSocketAdaptorImports
    
    # The channel being adapted
    attr_accessor :ssc
    alias_method :attr_ssc, :ssc
    undef_method :ssc
    alias_method :attr_ssc=, :ssc=
    undef_method :ssc=
    
    # Option adaptor object, created on demand
    attr_accessor :opts
    alias_method :attr_opts, :opts
    undef_method :opts
    alias_method :attr_opts=, :opts=
    undef_method :opts=
    
    # Timeout "option" value for accepts
    attr_accessor :timeout
    alias_method :attr_timeout, :timeout
    undef_method :timeout
    alias_method :attr_timeout=, :timeout=
    undef_method :timeout=
    
    class_module.module_eval {
      typesig { [ServerSocketChannelImpl] }
      def create(ssc)
        begin
          return ServerSocketAdaptor.new(ssc)
        rescue IOException => x
          raise JavaError.new(x)
        end
      end
    }
    
    typesig { [ServerSocketChannelImpl] }
    # ## super will create a useless impl
    def initialize(ssc)
      @ssc = nil
      @opts = nil
      @timeout = 0
      super()
      @opts = nil
      @timeout = 0
      @ssc = ssc
    end
    
    typesig { [SocketAddress] }
    def bind(local)
      bind(local, 50)
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    def bind(local, backlog)
      if ((local).nil?)
        local = InetSocketAddress.new(0)
      end
      begin
        @ssc.bind(local, backlog)
      rescue Exception => x
        Net.translate_exception(x)
      end
    end
    
    typesig { [] }
    def get_inet_address
      if (!@ssc.is_bound)
        return nil
      end
      return Net.as_inet_socket_address(@ssc.local_address).get_address
    end
    
    typesig { [] }
    def get_local_port
      if (!@ssc.is_bound)
        return -1
      end
      return Net.as_inet_socket_address(@ssc.local_address).get_port
    end
    
    typesig { [] }
    def accept
      synchronized((@ssc.blocking_lock)) do
        if (!@ssc.is_bound)
          raise IllegalBlockingModeException.new
        end
        begin
          if ((@timeout).equal?(0))
            sc = @ssc.accept
            if ((sc).nil? && !@ssc.is_blocking)
              raise IllegalBlockingModeException.new
            end
            return sc.socket
          end
          # Implement timeout with a selector
          sk = nil
          sel = nil
          @ssc.configure_blocking(false)
          begin
            sc_ = nil
            if (!((sc_ = @ssc.accept)).nil?)
              return sc_.socket
            end
            sel = Util.get_temporary_selector(@ssc)
            sk = @ssc.register(sel, SelectionKey::OP_ACCEPT)
            to = @timeout
            loop do
              if (!@ssc.is_open)
                raise ClosedChannelException.new
              end
              st = System.current_time_millis
              ns = sel.select(to)
              if (ns > 0 && sk.is_acceptable && (!((sc_ = @ssc.accept)).nil?))
                return sc_.socket
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
            if (@ssc.is_open)
              @ssc.configure_blocking(true)
            end
            if (!(sel).nil?)
              Util.release_temporary_selector(sel)
            end
          end
        rescue Exception => x
          Net.translate_exception(x)
          raise AssertError if not (false)
          return nil # Never happens
        end
      end
    end
    
    typesig { [] }
    def close
      begin
        @ssc.close
      rescue Exception => x
        Net.translate_exception(x)
      end
    end
    
    typesig { [] }
    def get_channel
      return @ssc
    end
    
    typesig { [] }
    def is_bound
      return @ssc.is_bound
    end
    
    typesig { [] }
    def is_closed
      return !@ssc.is_open
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
        @opts = OptionAdaptor.new(@ssc)
      end
      return @opts
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
    def to_s
      if (!is_bound)
        return "ServerSocket[unbound]"
      end
      # ",port=" + getPort() +
      return "ServerSocket[addr=" + (get_inet_address).to_s + ",localport=" + (get_local_port).to_s + "]"
    end
    
    typesig { [::Java::Int] }
    def set_receive_buffer_size(size)
      opts.set_receive_buffer_size(size)
    end
    
    typesig { [] }
    def get_receive_buffer_size
      return opts.get_receive_buffer_size
    end
    
    private
    alias_method :initialize__server_socket_adaptor, :initialize
  end
  
end
