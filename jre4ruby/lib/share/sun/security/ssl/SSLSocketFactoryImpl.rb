require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module SSLSocketFactoryImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Net
      include_const ::Javax::Net::Ssl, :SSLSocketFactory
      include_const ::Javax::Net::Ssl, :SSLSocket
    }
  end
  
  # Implementation of an SSL socket factory.  This provides the public
  # hooks to create SSL sockets, using a "high level" programming
  # interface which encapsulates system security policy defaults rather than
  # offering application flexibility.  In particular, it uses a configurable
  # authentication context (and the keys held there) rather than offering
  # any flexibility about which keys to use; that context defaults to the
  # process-default context, but may be explicitly specified.
  # 
  # @author David Brownell
  class SSLSocketFactoryImpl < SSLSocketFactoryImplImports.const_get :SSLSocketFactory
    include_class_members SSLSocketFactoryImplImports
    
    class_module.module_eval {
      
      def default_context
        defined?(@@default_context) ? @@default_context : @@default_context= nil
      end
      alias_method :attr_default_context, :default_context
      
      def default_context=(value)
        @@default_context = value
      end
      alias_method :attr_default_context=, :default_context=
    }
    
    attr_accessor :context
    alias_method :attr_context, :context
    undef_method :context
    alias_method :attr_context=, :context=
    undef_method :context=
    
    typesig { [] }
    # Constructor used to instantiate the default factory. This method is
    # only called if the old "ssl.SocketFactory.provider" property in the
    # java.security file is set.
    def initialize
      @context = nil
      super()
      @context = DefaultSSLContextImpl.get_default_impl
    end
    
    typesig { [SSLContextImpl] }
    # Constructs an SSL socket factory.
    def initialize(context)
      @context = nil
      super()
      @context = context
    end
    
    typesig { [] }
    # Creates an unconnected socket.
    # 
    # @return the unconnected socket
    # @see java.net.Socket#connect(java.net.SocketAddress, int)
    def create_socket
      return SSLSocketImpl.new(@context)
    end
    
    typesig { [String, ::Java::Int] }
    # Constructs an SSL connection to a named host at a specified port.
    # This acts as the SSL client, and may authenticate itself or rejoin
    # existing SSL sessions allowed by the authentication context which
    # has been configured.
    # 
    # @param host name of the host with which to connect
    # @param port number of the server's port
    def create_socket(host, port)
      return SSLSocketImpl.new(@context, host, port)
    end
    
    typesig { [Socket, String, ::Java::Int, ::Java::Boolean] }
    # Returns a socket layered over an existing socket to a
    # ServerSocket on the named host, at the given port.  This
    # constructor can be used when tunneling SSL through a proxy. The
    # host and port refer to the logical destination server.  This
    # socket is configured using the socket options established for
    # this factory.
    # 
    # @param s the existing socket
    # @param host the server host
    # @param port the server port
    # @param autoClose close the underlying socket when this socket is closed
    # 
    # @exception IOException if the connection can't be established
    # @exception UnknownHostException if the host is not known
    def create_socket(s, host, port, auto_close)
      return SSLSocketImpl.new(@context, s, host, port, auto_close)
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Constructs an SSL connection to a server at a specified address
    # and TCP port.  This acts as the SSL client, and may authenticate
    # itself or rejoin existing SSL sessions allowed by the authentication
    # context which has been configured.
    # 
    # @param address the server's host
    # @param port its port
    def create_socket(address, port)
      return SSLSocketImpl.new(@context, address, port)
    end
    
    typesig { [String, ::Java::Int, InetAddress, ::Java::Int] }
    # Constructs an SSL connection to a named host at a specified port.
    # This acts as the SSL client, and may authenticate itself or rejoin
    # existing SSL sessions allowed by the authentication context which
    # has been configured. The socket will also bind() to the local
    # address and port supplied.
    def create_socket(host, port, client_address, client_port)
      return SSLSocketImpl.new(@context, host, port, client_address, client_port)
    end
    
    typesig { [InetAddress, ::Java::Int, InetAddress, ::Java::Int] }
    # Constructs an SSL connection to a server at a specified address
    # and TCP port.  This acts as the SSL client, and may authenticate
    # itself or rejoin existing SSL sessions allowed by the authentication
    # context which has been configured. The socket will also bind() to
    # the local address and port supplied.
    def create_socket(address, port, client_address, client_port)
      return SSLSocketImpl.new(@context, address, port, client_address, client_port)
    end
    
    typesig { [] }
    # Returns the subset of the supported cipher suites which are
    # enabled by default.  These cipher suites all provide a minimum
    # quality of service whereby the server authenticates itself
    # (preventing person-in-the-middle attacks) and where traffic
    # is encrypted to provide confidentiality.
    def get_default_cipher_suites
      CipherSuiteList.clear_available_cache
      return CipherSuiteList.get_default.to_string_array
    end
    
    typesig { [] }
    # Returns the names of the cipher suites which could be enabled for use
    # on an SSL connection.  Normally, only a subset of these will actually
    # be enabled by default, since this list may include cipher suites which
    # do not support the mutual authentication of servers and clients, or
    # which do not protect data confidentiality.  Servers may also need
    # certain kinds of certificates to use certain cipher suites.
    def get_supported_cipher_suites
      CipherSuiteList.clear_available_cache
      return CipherSuiteList.get_supported.to_string_array
    end
    
    private
    alias_method :initialize__sslsocket_factory_impl, :initialize
  end
  
end
