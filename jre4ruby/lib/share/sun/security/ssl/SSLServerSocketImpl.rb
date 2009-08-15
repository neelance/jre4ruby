require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SSLServerSocketImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :Socket
      include_const ::Java::Net, :ServerSocket
      include ::Java::Util
      include_const ::Javax::Net, :ServerSocketFactory
      include_const ::Javax::Net::Ssl, :SSLException
      include_const ::Javax::Net::Ssl, :SSLServerSocket
    }
  end
  
  # This class provides a simple way for servers to support conventional
  # use of the Secure Sockets Layer (SSL).  Application code uses an
  # SSLServerSocketImpl exactly like it uses a regular TCP ServerSocket; the
  # difference is that the connections established are secured using SSL.
  # 
  # <P> Also, the constructors take an explicit authentication context
  # parameter, giving flexibility with respect to how the server socket
  # authenticates itself.  That policy flexibility is not exposed through
  # the standard SSLServerSocketFactory API.
  # 
  # <P> System security defaults prevent server sockets from accepting
  # connections if they the authentication context has not been given
  # a certificate chain and its matching private key.  If the clients
  # of your application support "anonymous" cipher suites, you may be
  # able to configure a server socket to accept those suites.
  # 
  # @see SSLSocketImpl
  # @see SSLServerSocketFactoryImpl
  # 
  # @author David Brownell
  class SSLServerSocketImpl < SSLServerSocketImplImports.const_get :SSLServerSocket
    include_class_members SSLServerSocketImplImports
    
    attr_accessor :ssl_context
    alias_method :attr_ssl_context, :ssl_context
    undef_method :ssl_context
    alias_method :attr_ssl_context=, :ssl_context=
    undef_method :ssl_context=
    
    # Do newly accepted connections require clients to authenticate?
    attr_accessor :do_client_auth
    alias_method :attr_do_client_auth, :do_client_auth
    undef_method :do_client_auth
    alias_method :attr_do_client_auth=, :do_client_auth=
    undef_method :do_client_auth=
    
    # Do new connections created here use the "server" mode of SSL?
    attr_accessor :use_server_mode
    alias_method :attr_use_server_mode, :use_server_mode
    undef_method :use_server_mode
    alias_method :attr_use_server_mode=, :use_server_mode=
    undef_method :use_server_mode=
    
    # Can new connections created establish new sessions?
    attr_accessor :enable_session_creation
    alias_method :attr_enable_session_creation, :enable_session_creation
    undef_method :enable_session_creation
    alias_method :attr_enable_session_creation=, :enable_session_creation=
    undef_method :enable_session_creation=
    
    # what cipher suites to use by default
    attr_accessor :enabled_cipher_suites
    alias_method :attr_enabled_cipher_suites, :enabled_cipher_suites
    undef_method :enabled_cipher_suites
    alias_method :attr_enabled_cipher_suites=, :enabled_cipher_suites=
    undef_method :enabled_cipher_suites=
    
    # which protocol to use by default
    attr_accessor :enabled_protocols
    alias_method :attr_enabled_protocols, :enabled_protocols
    undef_method :enabled_protocols
    alias_method :attr_enabled_protocols=, :enabled_protocols=
    undef_method :enabled_protocols=
    
    # could enabledCipherSuites ever complete handshaking?
    attr_accessor :checked_enabled
    alias_method :attr_checked_enabled, :checked_enabled
    undef_method :checked_enabled
    alias_method :attr_checked_enabled=, :checked_enabled=
    undef_method :checked_enabled=
    
    typesig { [::Java::Int, ::Java::Int, SSLContextImpl] }
    # Create an SSL server socket on a port, using a non-default
    # authentication context and a specified connection backlog.
    # 
    # @param port the port on which to listen
    # @param backlog how many connections may be pending before
    # the system should start rejecting new requests
    # @param context authentication context for this server
    def initialize(port, backlog, context)
      @ssl_context = nil
      @do_client_auth = 0
      @use_server_mode = false
      @enable_session_creation = false
      @enabled_cipher_suites = nil
      @enabled_protocols = nil
      @checked_enabled = false
      super(port, backlog)
      @do_client_auth = SSLEngineImpl.attr_clauth_none
      @use_server_mode = true
      @enable_session_creation = true
      @enabled_cipher_suites = nil
      @enabled_protocols = nil
      @checked_enabled = false
      init_server(context)
    end
    
    typesig { [::Java::Int, ::Java::Int, InetAddress, SSLContextImpl] }
    # Create an SSL server socket on a port, using a specified
    # authentication context and a specified backlog of connections
    # as well as a particular specified network interface.  This
    # constructor is used on multihomed hosts, such as those used
    # for firewalls or as routers, to control through which interface
    # a network service is provided.
    # 
    # @param port the port on which to listen
    # @param backlog how many connections may be pending before
    # the system should start rejecting new requests
    # @param address the address of the network interface through
    # which connections will be accepted
    # @param context authentication context for this server
    def initialize(port, backlog, address, context)
      @ssl_context = nil
      @do_client_auth = 0
      @use_server_mode = false
      @enable_session_creation = false
      @enabled_cipher_suites = nil
      @enabled_protocols = nil
      @checked_enabled = false
      super(port, backlog, address)
      @do_client_auth = SSLEngineImpl.attr_clauth_none
      @use_server_mode = true
      @enable_session_creation = true
      @enabled_cipher_suites = nil
      @enabled_protocols = nil
      @checked_enabled = false
      init_server(context)
    end
    
    typesig { [SSLContextImpl] }
    # Creates an unbound server socket.
    def initialize(context)
      @ssl_context = nil
      @do_client_auth = 0
      @use_server_mode = false
      @enable_session_creation = false
      @enabled_cipher_suites = nil
      @enabled_protocols = nil
      @checked_enabled = false
      super()
      @do_client_auth = SSLEngineImpl.attr_clauth_none
      @use_server_mode = true
      @enable_session_creation = true
      @enabled_cipher_suites = nil
      @enabled_protocols = nil
      @checked_enabled = false
      init_server(context)
    end
    
    typesig { [SSLContextImpl] }
    # Initializes the server socket.
    def init_server(context)
      if ((context).nil?)
        raise SSLException.new("No Authentication context given")
      end
      @ssl_context = context
      @enabled_cipher_suites = CipherSuiteList.get_default
      @enabled_protocols = ProtocolList.get_default
    end
    
    typesig { [] }
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
    
    typesig { [] }
    # Returns the list of cipher suites which are currently enabled
    # for use by newly accepted connections.  A null return indicates
    # that the system defaults are in effect.
    def get_enabled_cipher_suites
      synchronized(self) do
        return @enabled_cipher_suites.to_string_array
      end
    end
    
    typesig { [Array.typed(String)] }
    # Controls which particular SSL cipher suites are enabled for use
    # by accepted connections.
    # 
    # @param suites Names of all the cipher suites to enable; null
    # means to accept system defaults.
    def set_enabled_cipher_suites(suites)
      synchronized(self) do
        @enabled_cipher_suites = CipherSuiteList.new(suites)
        @checked_enabled = false
      end
    end
    
    typesig { [] }
    def get_supported_protocols
      return ProtocolList.get_supported.to_string_array
    end
    
    typesig { [Array.typed(String)] }
    # Controls which protocols are enabled for use.
    # The protocols must have been listed by
    # getSupportedProtocols() as being supported.
    # 
    # @param protocols protocols to enable.
    # @exception IllegalArgumentException when one of the protocols
    # named by the parameter is not supported.
    def set_enabled_protocols(protocols)
      synchronized(self) do
        @enabled_protocols = ProtocolList.new(protocols)
      end
    end
    
    typesig { [] }
    def get_enabled_protocols
      synchronized(self) do
        return @enabled_protocols.to_string_array
      end
    end
    
    typesig { [::Java::Boolean] }
    # Controls whether the connections which are accepted must include
    # client authentication.
    def set_need_client_auth(flag)
      @do_client_auth = (flag ? SSLEngineImpl.attr_clauth_required : SSLEngineImpl.attr_clauth_none)
    end
    
    typesig { [] }
    def get_need_client_auth
      return ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_required))
    end
    
    typesig { [::Java::Boolean] }
    # Controls whether the connections which are accepted should request
    # client authentication.
    def set_want_client_auth(flag)
      @do_client_auth = (flag ? SSLEngineImpl.attr_clauth_requested : SSLEngineImpl.attr_clauth_none)
    end
    
    typesig { [] }
    def get_want_client_auth
      return ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_requested))
    end
    
    typesig { [::Java::Boolean] }
    # Makes the returned sockets act in SSL "client" mode, not the usual
    # server mode.  The canonical example of why this is needed is for
    # FTP clients, which accept connections from servers and should be
    # rejoining the already-negotiated SSL connection.
    def set_use_client_mode(flag)
      @use_server_mode = !flag
    end
    
    typesig { [] }
    def get_use_client_mode
      return !@use_server_mode
    end
    
    typesig { [::Java::Boolean] }
    # Controls whether new connections may cause creation of new SSL
    # sessions.
    def set_enable_session_creation(flag)
      @enable_session_creation = flag
    end
    
    typesig { [] }
    # Returns true if new connections may cause creation of new SSL
    # sessions.
    def get_enable_session_creation
      return @enable_session_creation
    end
    
    typesig { [] }
    # Accept a new SSL connection.  This server identifies itself with
    # information provided in the authentication context which was
    # presented during construction.
    def accept
      check_enabled_suites
      s = SSLSocketImpl.new(@ssl_context, @use_server_mode, @enabled_cipher_suites, @do_client_auth, @enable_session_creation, @enabled_protocols)
      impl_accept(s)
      s.done_connect
      return s
    end
    
    typesig { [] }
    # This is a sometimes helpful diagnostic check that is performed
    # once for each ServerSocket to verify that the initial set of
    # enabled suites are capable of supporting a successful handshake.
    def check_enabled_suites
      # We want to report an error if no cipher suites were actually
      # enabled, since this is an error users are known to make.  Then
      # they get vastly confused by having clients report an error!
      synchronized((self)) do
        if (@checked_enabled)
          return
        end
        if ((@use_server_mode).equal?(false))
          return
        end
        tmp = SSLSocketImpl.new(@ssl_context, @use_server_mode, @enabled_cipher_suites, @do_client_auth, @enable_session_creation, @enabled_protocols)
        begin
          handshaker = tmp.get_server_handshaker
          t = @enabled_cipher_suites.iterator
          while t.has_next
            suite = t.next_
            if (handshaker.try_set_cipher_suite(suite))
              @checked_enabled = true
              return
            end
          end
        ensure
          tmp.close_socket
        end
        # diagnostic text here is currently appropriate
        # since it's only certificate unavailability that can
        # cause such problems ... but that might change someday.
        raise SSLException.new("No available certificate or key corresponds" + " to the SSL cipher suites which are enabled.")
      end
    end
    
    typesig { [] }
    # Provides a brief description of this SSL socket.
    def to_s
      return "[SSL: " + RJava.cast_to_string(super) + "]"
    end
    
    private
    alias_method :initialize__sslserver_socket_impl, :initialize
  end
  
end
