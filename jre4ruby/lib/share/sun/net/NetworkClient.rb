require "rjava"

# Copyright 1994-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module NetworkClientImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include ::Java::Io
      include_const ::Java::Net, :Socket
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :InetSocketAddress
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :Proxy
      include_const ::Java::Util, :Arrays
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This is the base class for network clients.
  # 
  # @author      Jonathan Payne
  class NetworkClient 
    include_class_members NetworkClientImports
    
    attr_accessor :proxy
    alias_method :attr_proxy, :proxy
    undef_method :proxy
    alias_method :attr_proxy=, :proxy=
    undef_method :proxy=
    
    # Socket for communicating with server.
    attr_accessor :server_socket
    alias_method :attr_server_socket, :server_socket
    undef_method :server_socket
    alias_method :attr_server_socket=, :server_socket=
    undef_method :server_socket=
    
    # Stream for printing to the server.
    attr_accessor :server_output
    alias_method :attr_server_output, :server_output
    undef_method :server_output
    alias_method :attr_server_output=, :server_output=
    undef_method :server_output=
    
    # Buffered stream for reading replies from server.
    attr_accessor :server_input
    alias_method :attr_server_input, :server_input
    undef_method :server_input
    alias_method :attr_server_input=, :server_input=
    undef_method :server_input=
    
    class_module.module_eval {
      
      def default_so_timeout
        defined?(@@default_so_timeout) ? @@default_so_timeout : @@default_so_timeout= 0
      end
      alias_method :attr_default_so_timeout, :default_so_timeout
      
      def default_so_timeout=(value)
        @@default_so_timeout = value
      end
      alias_method :attr_default_so_timeout=, :default_so_timeout=
      
      
      def default_connect_timeout
        defined?(@@default_connect_timeout) ? @@default_connect_timeout : @@default_connect_timeout= 0
      end
      alias_method :attr_default_connect_timeout, :default_connect_timeout
      
      def default_connect_timeout=(value)
        @@default_connect_timeout = value
      end
      alias_method :attr_default_connect_timeout=, :default_connect_timeout=
    }
    
    attr_accessor :read_timeout
    alias_method :attr_read_timeout, :read_timeout
    undef_method :read_timeout
    alias_method :attr_read_timeout=, :read_timeout=
    undef_method :read_timeout=
    
    attr_accessor :connect_timeout
    alias_method :attr_connect_timeout, :connect_timeout
    undef_method :connect_timeout
    alias_method :attr_connect_timeout=, :connect_timeout=
    undef_method :connect_timeout=
    
    class_module.module_eval {
      # Name of encoding to use for output
      
      def encoding
        defined?(@@encoding) ? @@encoding : @@encoding= nil
      end
      alias_method :attr_encoding, :encoding
      
      def encoding=(value)
        @@encoding = value
      end
      alias_method :attr_encoding=, :encoding=
      
      when_class_loaded do
        vals = Array.typed(::Java::Int).new([0, 0])
        encs = Array.typed(String).new([nil])
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members NetworkClient
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            vals[0] = JavaInteger.get_integer("sun.net.client.defaultReadTimeout", 0).int_value
            vals[1] = JavaInteger.get_integer("sun.net.client.defaultConnectTimeout", 0).int_value
            encs[0] = System.get_property("file.encoding", "ISO8859_1")
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if ((vals[0]).equal?(0))
          self.attr_default_so_timeout = -1
        else
          self.attr_default_so_timeout = vals[0]
        end
        if ((vals[1]).equal?(0))
          self.attr_default_connect_timeout = -1
        else
          self.attr_default_connect_timeout = vals[1]
        end
        self.attr_encoding = RJava.cast_to_string(encs[0])
        begin
          if (!is_asciisuperset(self.attr_encoding))
            self.attr_encoding = "ISO8859_1"
          end
        rescue JavaException => e
          self.attr_encoding = "ISO8859_1"
        end
      end
      
      typesig { [String] }
      # Test the named character encoding to verify that it converts ASCII
      # characters correctly. We have to use an ASCII based encoding, or else
      # the NetworkClients will not work correctly in EBCDIC based systems.
      # However, we cannot just use ASCII or ISO8859_1 universally, because in
      # Asian locales, non-ASCII characters may be embedded in otherwise
      # ASCII based protocols (eg. HTTP). The specifications (RFC2616, 2398)
      # are a little ambiguous in this matter. For instance, RFC2398 [part 2.1]
      # says that the HTTP request URI should be escaped using a defined
      # mechanism, but there is no way to specify in the escaped string what
      # the original character set is. It is not correct to assume that
      # UTF-8 is always used (as in URLs in HTML 4.0).  For this reason,
      # until the specifications are updated to deal with this issue more
      # comprehensively, and more importantly, HTTP servers are known to
      # support these mechanisms, we will maintain the current behavior
      # where it is possible to send non-ASCII characters in their original
      # unescaped form.
      def is_asciisuperset(encoding)
        chk_s = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "abcdefghijklmnopqrstuvwxyz-_.!~*'();/?:@&=+$,"
        # Expected byte sequence for string above
        chk_b = Array.typed(::Java::Byte).new([48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 45, 95, 46, 33, 126, 42, 39, 40, 41, 59, 47, 63, 58, 64, 38, 61, 43, 36, 44])
        b = chk_s.get_bytes(encoding)
        return (Arrays == b)
      end
    }
    
    typesig { [String, ::Java::Int] }
    # Open a connection to the server.
    def open_server(server, port)
      if (!(@server_socket).nil?)
        close_server
      end
      @server_socket = do_connect(server, port)
      begin
        @server_output = PrintStream.new(BufferedOutputStream.new(@server_socket.get_output_stream), true, self.attr_encoding)
      rescue UnsupportedEncodingException => e
        raise InternalError.new(self.attr_encoding + "encoding not found")
      end
      @server_input = BufferedInputStream.new(@server_socket.get_input_stream)
    end
    
    typesig { [String, ::Java::Int] }
    # Return a socket connected to the server, with any
    # appropriate options pre-established
    def do_connect(server, port)
      s = nil
      if (!(@proxy).nil?)
        if ((@proxy.type).equal?(Proxy::Type::SOCKS))
          s = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members NetworkClient
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return self.class::Socket.new(self.attr_proxy)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        else
          s = Socket.new(Proxy::NO_PROXY)
        end
      else
        s = Socket.new
      end
      # Instance specific timeouts do have priority, that means
      # connectTimeout & readTimeout (-1 means not set)
      # Then global default timeouts
      # Then no timeout.
      if (@connect_timeout >= 0)
        s.connect(InetSocketAddress.new(server, port), @connect_timeout)
      else
        if (self.attr_default_connect_timeout > 0)
          s.connect(InetSocketAddress.new(server, port), self.attr_default_connect_timeout)
        else
          s.connect(InetSocketAddress.new(server, port))
        end
      end
      if (@read_timeout >= 0)
        s.set_so_timeout(@read_timeout)
      else
        if (self.attr_default_so_timeout > 0)
          s.set_so_timeout(self.attr_default_so_timeout)
        end
      end
      return s
    end
    
    typesig { [] }
    def get_local_address
      if ((@server_socket).nil?)
        raise IOException.new("not connected")
      end
      return @server_socket.get_local_address
    end
    
    typesig { [] }
    # Close an open connection to the server.
    def close_server
      if (!server_is_open)
        return
      end
      @server_socket.close
      @server_socket = nil
      @server_input = nil
      @server_output = nil
    end
    
    typesig { [] }
    # Return server connection status
    def server_is_open
      return !(@server_socket).nil?
    end
    
    typesig { [String, ::Java::Int] }
    # Create connection with host <i>host</i> on port <i>port</i>
    def initialize(host, port)
      @proxy = Proxy::NO_PROXY
      @server_socket = nil
      @server_output = nil
      @server_input = nil
      @read_timeout = -1
      @connect_timeout = -1
      open_server(host, port)
    end
    
    typesig { [] }
    def initialize
      @proxy = Proxy::NO_PROXY
      @server_socket = nil
      @server_output = nil
      @server_input = nil
      @read_timeout = -1
      @connect_timeout = -1
    end
    
    typesig { [::Java::Int] }
    def set_connect_timeout(timeout)
      @connect_timeout = timeout
    end
    
    typesig { [] }
    def get_connect_timeout
      return @connect_timeout
    end
    
    typesig { [::Java::Int] }
    def set_read_timeout(timeout)
      if (!(@server_socket).nil? && timeout >= 0)
        begin
          @server_socket.set_so_timeout(timeout)
        rescue IOException => e
          # We tried...
        end
      end
      @read_timeout = timeout
    end
    
    typesig { [] }
    def get_read_timeout
      return @read_timeout
    end
    
    private
    alias_method :initialize__network_client, :initialize
  end
  
end
