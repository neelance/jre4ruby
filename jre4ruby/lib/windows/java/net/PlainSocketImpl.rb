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
      include ::Java::Io
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This class PlainSocketImpl simply delegates to the appropriate real
  # SocketImpl. We do this because PlainSocketImpl is already extended
  # by SocksSocketImpl.
  # <p>
  # There are two possibilities for the real SocketImpl,
  # TwoStacksPlainSocketImpl or DualStackPlainSocketImpl. We use
  # DualStackPlainSocketImpl on systems that have a dual stack
  # TCP implementation. Otherwise we create an instance of
  # TwoStacksPlainSocketImpl and delegate to it.
  # 
  # @author Chris Hegarty
  class PlainSocketImpl < PlainSocketImplImports.const_get :AbstractPlainSocketImpl
    include_class_members PlainSocketImplImports
    
    attr_accessor :impl
    alias_method :attr_impl, :impl
    undef_method :impl
    alias_method :attr_impl=, :impl=
    undef_method :impl=
    
    class_module.module_eval {
      # the windows version.
      
      def version
        defined?(@@version) ? @@version : @@version= 0.0
      end
      alias_method :attr_version, :version
      
      def version=(value)
        @@version = value
      end
      alias_method :attr_version=, :version=
      
      # java.net.preferIPv4Stack
      
      def prefer_ipv4stack
        defined?(@@prefer_ipv4stack) ? @@prefer_ipv4stack : @@prefer_ipv4stack= false
      end
      alias_method :attr_prefer_ipv4stack, :prefer_ipv4stack
      
      def prefer_ipv4stack=(value)
        @@prefer_ipv4stack = value
      end
      alias_method :attr_prefer_ipv4stack=, :prefer_ipv4stack=
      
      # If the version supports a dual stack TCP implementation
      
      def use_dual_stack_impl
        defined?(@@use_dual_stack_impl) ? @@use_dual_stack_impl : @@use_dual_stack_impl= false
      end
      alias_method :attr_use_dual_stack_impl, :use_dual_stack_impl
      
      def use_dual_stack_impl=(value)
        @@use_dual_stack_impl = value
      end
      alias_method :attr_use_dual_stack_impl=, :use_dual_stack_impl=
      
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members PlainSocketImpl
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_version = 0
            begin
              self.attr_version = Float.parse_float(System.get_properties.get_property("os.version"))
              self.attr_prefer_ipv4stack = Boolean.parse_boolean(System.get_properties.get_property("java.net.preferIPv4Stack"))
            rescue self.class::NumberFormatException => e
              raise AssertError, RJava.cast_to_string(e) if not (false)
            end
            return nil # nothing to return
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # (version >= 6.0) implies Vista or greater.
        if (self.attr_version >= 6.0 && !self.attr_prefer_ipv4stack)
          self.attr_use_dual_stack_impl = true
        end
      end
    }
    
    typesig { [] }
    # Constructs an empty instance.
    def initialize
      @impl = nil
      super()
      if (self.attr_use_dual_stack_impl)
        @impl = DualStackPlainSocketImpl.new
      else
        @impl = TwoStacksPlainSocketImpl.new
      end
    end
    
    typesig { [FileDescriptor] }
    # Constructs an instance with the given file descriptor.
    def initialize(fd)
      @impl = nil
      super()
      if (self.attr_use_dual_stack_impl)
        @impl = DualStackPlainSocketImpl.new(fd)
      else
        @impl = TwoStacksPlainSocketImpl.new(fd)
      end
    end
    
    typesig { [] }
    # Override methods in SocketImpl that access impl's fields.
    def get_file_descriptor
      return @impl.get_file_descriptor
    end
    
    typesig { [] }
    def get_inet_address
      return @impl.get_inet_address
    end
    
    typesig { [] }
    def get_port
      return @impl.get_port
    end
    
    typesig { [] }
    def get_local_port
      return @impl.get_local_port
    end
    
    typesig { [Socket] }
    def set_socket(soc)
      @impl.set_socket(soc)
    end
    
    typesig { [] }
    def get_socket
      return @impl.get_socket
    end
    
    typesig { [ServerSocket] }
    def set_server_socket(soc)
      @impl.set_server_socket(soc)
    end
    
    typesig { [] }
    def get_server_socket
      return @impl.get_server_socket
    end
    
    typesig { [] }
    def to_s
      return @impl.to_s
    end
    
    typesig { [::Java::Boolean] }
    # Override methods in AbstractPlainSocketImpl that access impl's fields.
    def create(stream)
      synchronized(self) do
        @impl.create(stream)
      end
    end
    
    typesig { [String, ::Java::Int] }
    def connect(host, port)
      @impl.connect(host, port)
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def connect(address, port)
      @impl.connect(address, port)
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    def connect(address, timeout)
      @impl.connect(address, timeout)
    end
    
    typesig { [::Java::Int, Object] }
    def set_option(opt, val)
      @impl.set_option(opt, val)
    end
    
    typesig { [::Java::Int] }
    def get_option(opt)
      return @impl.get_option(opt)
    end
    
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    def do_connect(address, port, timeout)
      synchronized(self) do
        @impl.do_connect(address, port, timeout)
      end
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def bind(address, lport)
      synchronized(self) do
        @impl.bind(address, lport)
      end
    end
    
    typesig { [SocketImpl] }
    def accept(s)
      synchronized(self) do
        # pass in the real impl not the wrapper.
        (s).attr_impl.attr_address = InetAddress.new
        (s).attr_impl.attr_fd = FileDescriptor.new
        @impl.accept((s).attr_impl)
      end
    end
    
    typesig { [FileDescriptor] }
    def set_file_descriptor(fd)
      @impl.set_file_descriptor(fd)
    end
    
    typesig { [InetAddress] }
    def set_address(address)
      @impl.set_address(address)
    end
    
    typesig { [::Java::Int] }
    def set_port(port)
      @impl.set_port(port)
    end
    
    typesig { [::Java::Int] }
    def set_local_port(local_port)
      @impl.set_local_port(local_port)
    end
    
    typesig { [] }
    def get_input_stream
      synchronized(self) do
        return @impl.get_input_stream
      end
    end
    
    typesig { [SocketInputStream] }
    def set_input_stream(in_)
      @impl.set_input_stream(in_)
    end
    
    typesig { [] }
    def get_output_stream
      synchronized(self) do
        return @impl.get_output_stream
      end
    end
    
    typesig { [] }
    def close
      @impl.close
    end
    
    typesig { [] }
    def reset
      @impl.reset
    end
    
    typesig { [] }
    def shutdown_input
      @impl.shutdown_input
    end
    
    typesig { [] }
    def shutdown_output
      @impl.shutdown_output
    end
    
    typesig { [::Java::Int] }
    def send_urgent_data(data)
      @impl.send_urgent_data(data)
    end
    
    typesig { [] }
    def acquire_fd
      return @impl.acquire_fd
    end
    
    typesig { [] }
    def release_fd
      @impl.release_fd
    end
    
    typesig { [] }
    def is_connection_reset
      return @impl.is_connection_reset
    end
    
    typesig { [] }
    def is_connection_reset_pending
      return @impl.is_connection_reset_pending
    end
    
    typesig { [] }
    def set_connection_reset
      @impl.set_connection_reset
    end
    
    typesig { [] }
    def set_connection_reset_pending
      @impl.set_connection_reset_pending
    end
    
    typesig { [] }
    def is_closed_or_pending
      return @impl.is_closed_or_pending
    end
    
    typesig { [] }
    def get_timeout
      return @impl.get_timeout
    end
    
    typesig { [::Java::Boolean] }
    # Override methods in AbstractPlainSocketImpl that need to be implemented.
    def socket_create(is_server)
      @impl.socket_create(is_server)
    end
    
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    def socket_connect(address, port, timeout)
      @impl.socket_connect(address, port, timeout)
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def socket_bind(address, port)
      @impl.socket_bind(address, port)
    end
    
    typesig { [::Java::Int] }
    def socket_listen(count)
      @impl.socket_listen(count)
    end
    
    typesig { [SocketImpl] }
    def socket_accept(s)
      @impl.socket_accept(s)
    end
    
    typesig { [] }
    def socket_available
      return @impl.socket_available
    end
    
    typesig { [::Java::Boolean] }
    def socket_close0(use_deferred_close)
      @impl.socket_close0(use_deferred_close)
    end
    
    typesig { [::Java::Int] }
    def socket_shutdown(howto)
      @impl.socket_shutdown(howto)
    end
    
    typesig { [::Java::Int, ::Java::Boolean, Object] }
    def socket_set_option(cmd, on, value)
      socket_set_option(cmd, on, value)
    end
    
    typesig { [::Java::Int, Object] }
    def socket_get_option(opt, ia_container_obj)
      return @impl.socket_get_option(opt, ia_container_obj)
    end
    
    typesig { [::Java::Int, Object, FileDescriptor] }
    def socket_get_option1(opt, ia_container_obj, fd)
      return @impl.socket_get_option1(opt, ia_container_obj, fd)
    end
    
    typesig { [::Java::Int] }
    def socket_send_urgent_data(data)
      @impl.socket_send_urgent_data(data)
    end
    
    private
    alias_method :initialize__plain_socket_impl, :initialize
  end
  
end
