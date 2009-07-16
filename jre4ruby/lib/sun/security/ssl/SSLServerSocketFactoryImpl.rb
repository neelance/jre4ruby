require "rjava"

# 
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
  module SSLServerSocketFactoryImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :ServerSocket
      include_const ::Javax::Net::Ssl, :SSLServerSocketFactory
    }
  end
  
  # 
  # This class creates SSL server sockets.
  # 
  # @author David Brownell
  class SSLServerSocketFactoryImpl < SSLServerSocketFactoryImplImports.const_get :SSLServerSocketFactory
    include_class_members SSLServerSocketFactoryImplImports
    
    class_module.module_eval {
      const_set_lazy(:DEFAULT_BACKLOG) { 50 }
      const_attr_reader  :DEFAULT_BACKLOG
    }
    
    attr_accessor :context
    alias_method :attr_context, :context
    undef_method :context
    alias_method :attr_context=, :context=
    undef_method :context=
    
    typesig { [] }
    # 
    # Constructor used to instantiate the default factory. This method is
    # only called if the old "ssl.ServerSocketFactory.provider" property in the
    # java.security file is set.
    def initialize
      @context = nil
      super()
      @context = DefaultSSLContextImpl.get_default_impl
    end
    
    typesig { [SSLContextImpl] }
    # 
    # Called from SSLContextImpl's getSSLServerSocketFactory().
    def initialize(context)
      @context = nil
      super()
      @context = context
    end
    
    typesig { [] }
    # 
    # Returns an unbound server socket.
    # 
    # @return the unbound socket
    # @throws IOException if the socket cannot be created
    # @see java.net.Socket#bind(java.net.SocketAddress)
    def create_server_socket
      return SSLServerSocketImpl.new(@context)
    end
    
    typesig { [::Java::Int] }
    def create_server_socket(port)
      return SSLServerSocketImpl.new(port, DEFAULT_BACKLOG, @context)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def create_server_socket(port, backlog)
      return SSLServerSocketImpl.new(port, backlog, @context)
    end
    
    typesig { [::Java::Int, ::Java::Int, InetAddress] }
    def create_server_socket(port, backlog, if_address)
      return SSLServerSocketImpl.new(port, backlog, if_address, @context)
    end
    
    typesig { [] }
    # 
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
    # 
    # Returns the names of the cipher suites which could be enabled for use
    # on an SSL connection.  Normally, only a subset of these will actually
    # be enabled by default, since this list may include cipher suites which
    # do not support the mutual authentication of servers and clients, or
    # which do not protect data confidentiality.  Servers may also need
    # certain kinds of certificates to use certain cipher suites.
    # 
    # @return an array of cipher suite names
    def get_supported_cipher_suites
      CipherSuiteList.clear_available_cache
      return CipherSuiteList.get_supported.to_string_array
    end
    
    private
    alias_method :initialize__sslserver_socket_factory_impl, :initialize
  end
  
end
