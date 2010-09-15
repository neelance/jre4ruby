require "rjava"

# Copyright 2001-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Https
  module HttpsClientImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Https
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :BufferedOutputStream
      include_const ::Java::Net, :Socket
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :InetSocketAddress
      include_const ::Java::Net, :Proxy
      include_const ::Java::Net, :CookieHandler
      include_const ::Java::Net, :Authenticator
      include_const ::Java::Net, :PasswordAuthentication
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :KeyStore
      include_const ::Java::Security, :PrivateKey
      include ::Java::Security::Cert
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Security, :AccessController
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include ::Javax::Net::Ssl
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Misc, :Regexp
      include_const ::Sun::Misc, :RegexpPool
      include_const ::Sun::Net::Www, :HeaderParser
      include_const ::Sun::Net::Www, :MessageHeader
      include_const ::Sun::Net::Www::Http, :HttpClient
      include ::Sun::Security::Action
      include_const ::Sun::Security::Util, :HostnameChecker
      include_const ::Sun::Security::Ssl, :SSLSocketImpl
    }
  end
  
  # This class provides HTTPS client URL support, building on the standard
  # "sun.net.www" HTTP protocol handler.  HTTPS is the same protocol as HTTP,
  # but differs in the transport layer which it uses:  <UL>
  # 
  # <LI>There's a <em>Secure Sockets Layer</em> between TCP
  # and the HTTP protocol code.
  # 
  # <LI>It uses a different default TCP port.
  # 
  # <LI>It doesn't use application level proxies, which can see and
  # manipulate HTTP user level data, compromising privacy.  It uses
  # low level tunneling instead, which hides HTTP protocol and data
  # from all third parties.  (Traffic analysis is still possible).
  # 
  # <LI>It does basic server authentication, to protect
  # against "URL spoofing" attacks.  This involves deciding
  # whether the X.509 certificate chain identifying the server
  # is trusted, and verifying that the name of the server is
  # found in the certificate.  (The application may enable an
  # anonymous SSL cipher suite, and such checks are not done
  # for anonymous ciphers.)
  # 
  # <LI>It exposes key SSL session attributes, specifically the
  # cipher suite in use and the server's X509 certificates, to
  # application software which knows about this protocol handler.
  # 
  # </UL>
  # 
  # <P> System properties used include:  <UL>
  # 
  # <LI><em>https.proxyHost</em> ... the host supporting SSL
  # tunneling using the conventional CONNECT syntax
  # 
  # <LI><em>https.proxyPort</em> ... port to use on proxyHost
  # 
  # <LI><em>https.cipherSuites</em> ... comma separated list of
  # SSL cipher suite names to enable.
  # 
  # <LI><em>http.nonProxyHosts</em> ...
  # 
  # </UL>
  # 
  # @author David Brownell
  # @author Bill Foote
  # 
  # final for export control reasons (access to APIs); remove with care
  class HttpsClient < HttpsClientImports.const_get :HttpClient
    include_class_members HttpsClientImports
    overload_protected {
      include HandshakeCompletedListener
    }
    
    class_module.module_eval {
      # STATIC STATE and ACCESSORS THERETO
      # HTTPS uses a different default port number than HTTP.
      const_set_lazy(:HttpsPortNumber) { 443 }
      const_attr_reader  :HttpsPortNumber
    }
    
    typesig { [] }
    # Returns the default HTTPS port (443)
    def get_default_port
      return HttpsPortNumber
    end
    
    attr_accessor :hv
    alias_method :attr_hv, :hv
    undef_method :hv
    alias_method :attr_hv=, :hv=
    undef_method :hv=
    
    attr_accessor :ssl_socket_factory
    alias_method :attr_ssl_socket_factory, :ssl_socket_factory
    undef_method :ssl_socket_factory
    alias_method :attr_ssl_socket_factory=, :ssl_socket_factory=
    undef_method :ssl_socket_factory=
    
    # HttpClient.proxyDisabled will always be false, because we don't
    # use an application-level HTTP proxy.  We might tunnel through
    # our http proxy, though.
    # INSTANCE DATA
    # last negotiated SSL session
    attr_accessor :session
    alias_method :attr_session, :session
    undef_method :session
    alias_method :attr_session=, :session=
    undef_method :session=
    
    typesig { [] }
    def get_cipher_suites
      # If ciphers are assigned, sort them into an array.
      ciphers = nil
      cipher_string = AccessController.do_privileged(GetPropertyAction.new("https.cipherSuites"))
      if ((cipher_string).nil? || ("" == cipher_string))
        ciphers = nil
      else
        tokenizer = nil
        v = Vector.new
        tokenizer = StringTokenizer.new(cipher_string, ",")
        while (tokenizer.has_more_tokens)
          v.add_element(tokenizer.next_token)
        end
        ciphers = Array.typed(String).new(v.size) { nil }
        i = 0
        while i < ciphers.attr_length
          ciphers[i] = v.element_at(i)
          i += 1
        end
      end
      return ciphers
    end
    
    typesig { [] }
    def get_protocols
      # If protocols are assigned, sort them into an array.
      protocols = nil
      protocol_string = AccessController.do_privileged(GetPropertyAction.new("https.protocols"))
      if ((protocol_string).nil? || ("" == protocol_string))
        protocols = nil
      else
        tokenizer = nil
        v = Vector.new
        tokenizer = StringTokenizer.new(protocol_string, ",")
        while (tokenizer.has_more_tokens)
          v.add_element(tokenizer.next_token)
        end
        protocols = Array.typed(String).new(v.size) { nil }
        i = 0
        while i < protocols.attr_length
          protocols[i] = v.element_at(i)
          i += 1
        end
      end
      return protocols
    end
    
    typesig { [] }
    def get_user_agent
      user_agent = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("https.agent"))
      if ((user_agent).nil? || (user_agent.length).equal?(0))
        user_agent = "JSSE"
      end
      return user_agent
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Int] }
      # should remove once HttpClient.newHttpProxy is putback
      def new_http_proxy(proxy_host, proxy_port)
        saddr = nil
        phost = proxy_host
        pport = proxy_port < 0 ? HttpsPortNumber : proxy_port
        begin
          saddr = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
            local_class_in HttpsClient
            include_class_members HttpsClient
            include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              return self.class::InetSocketAddress.new(phost, pport)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue Java::Security::PrivilegedActionException => pae
        end
        return Proxy.new(Proxy::Type::HTTP, saddr)
      end
    }
    
    typesig { [SSLSocketFactory, URL] }
    # CONSTRUCTOR, FACTORY
    # 
    # Create an HTTPS client URL.  Traffic will be tunneled through any
    # intermediate nodes rather than proxied, so that confidentiality
    # of data exchanged can be preserved.  However, note that all the
    # anonymous SSL flavors are subject to "person-in-the-middle"
    # attacks against confidentiality.  If you enable use of those
    # flavors, you may be giving up the protection you get through
    # SSL tunneling.
    # 
    # Use New to get new HttpsClient. This constructor is meant to be
    # used only by New method. New properly checks for URL spoofing.
    # 
    # @param URL https URL with which a connection must be established
    def initialize(sf, url)
      # HttpClient-level proxying is always disabled,
      # because we override doConnect to do tunneling instead.
      initialize__https_client(sf, url, nil, -1)
    end
    
    typesig { [SSLSocketFactory, URL, String, ::Java::Int] }
    # Create an HTTPS client URL.  Traffic will be tunneled through
    # the specified proxy server.
    def initialize(sf, url, proxy_host, proxy_port)
      initialize__https_client(sf, url, proxy_host, proxy_port, -1)
    end
    
    typesig { [SSLSocketFactory, URL, String, ::Java::Int, ::Java::Int] }
    # Create an HTTPS client URL.  Traffic will be tunneled through
    # the specified proxy server, with a connect timeout
    def initialize(sf, url, proxy_host, proxy_port, connect_timeout)
      initialize__https_client(sf, url, ((proxy_host).nil? ? nil : HttpsClient.new_http_proxy(proxy_host, proxy_port)), connect_timeout)
    end
    
    typesig { [SSLSocketFactory, URL, Proxy, ::Java::Int] }
    # Same as previous constructor except using a Proxy
    def initialize(sf, url, proxy, connect_timeout)
      @hv = nil
      @ssl_socket_factory = nil
      @session = nil
      super()
      self.attr_proxy = proxy
      set_sslsocket_factory(sf)
      self.attr_proxy_disabled = true
      self.attr_host = url.get_host
      self.attr_url = url
      self.attr_port = url.get_port
      if ((self.attr_port).equal?(-1))
        self.attr_port = get_default_port
      end
      set_connect_timeout(connect_timeout)
      self.attr_cookie_handler = Java::Security::AccessController.do_privileged(# get the cookieHandler if there is any
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        local_class_in HttpsClient
        include_class_members HttpsClient
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return CookieHandler.get_default
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      open_server
    end
    
    class_module.module_eval {
      typesig { [SSLSocketFactory, URL, HostnameVerifier] }
      # This code largely ripped off from HttpClient.New, and
      # it uses the same keepalive cache.
      def _new(sf, url, hv)
        return HttpsClient._new(sf, url, hv, true)
      end
      
      typesig { [SSLSocketFactory, URL, HostnameVerifier, ::Java::Boolean] }
      # See HttpClient for the model for this method.
      def _new(sf, url, hv, use_cache)
        return HttpsClient._new(sf, url, hv, nil, -1, use_cache)
      end
      
      typesig { [SSLSocketFactory, URL, HostnameVerifier, String, ::Java::Int] }
      # Get a HTTPS client to the URL.  Traffic will be tunneled through
      # the specified proxy server.
      def _new(sf, url, hv, proxy_host, proxy_port)
        return HttpsClient._new(sf, url, hv, proxy_host, proxy_port, true)
      end
      
      typesig { [SSLSocketFactory, URL, HostnameVerifier, String, ::Java::Int, ::Java::Boolean] }
      def _new(sf, url, hv, proxy_host, proxy_port, use_cache)
        return HttpsClient._new(sf, url, hv, proxy_host, proxy_port, use_cache, -1)
      end
      
      typesig { [SSLSocketFactory, URL, HostnameVerifier, String, ::Java::Int, ::Java::Boolean, ::Java::Int] }
      def _new(sf, url, hv, proxy_host, proxy_port, use_cache, connect_timeout)
        return HttpsClient._new(sf, url, hv, ((proxy_host).nil? ? nil : HttpsClient.new_http_proxy(proxy_host, proxy_port)), use_cache, connect_timeout)
      end
      
      typesig { [SSLSocketFactory, URL, HostnameVerifier, Proxy, ::Java::Boolean, ::Java::Int] }
      def _new(sf, url, hv, p, use_cache, connect_timeout)
        ret = nil
        if (use_cache)
          # see if one's already around
          ret = self.attr_kac.get(url, sf)
          if (!(ret).nil?)
            ret.attr_cached_http_client = true
          end
        end
        if ((ret).nil?)
          ret = HttpsClient.new(sf, url, p, connect_timeout)
        else
          security = System.get_security_manager
          if (!(security).nil?)
            security.check_connect(url.get_host, url.get_port)
          end
          ret.attr_url = url
        end
        ret.set_hostname_verifier(hv)
        return ret
      end
    }
    
    typesig { [HostnameVerifier] }
    # METHODS
    def set_hostname_verifier(hv)
      @hv = hv
    end
    
    typesig { [SSLSocketFactory] }
    def set_sslsocket_factory(sf)
      @ssl_socket_factory = sf
    end
    
    typesig { [] }
    def get_sslsocket_factory
      return @ssl_socket_factory
    end
    
    typesig { [] }
    def needs_tunneling
      return (!(self.attr_proxy).nil? && !(self.attr_proxy.type).equal?(Proxy::Type::DIRECT) && !(self.attr_proxy.type).equal?(Proxy::Type::SOCKS))
    end
    
    typesig { [] }
    def after_connect
      if (!is_cached_connection)
        s = nil
        factory = @ssl_socket_factory
        begin
          if (!(self.attr_server_socket.is_a?(SSLSocket)))
            s = factory.create_socket(self.attr_server_socket, self.attr_host, self.attr_port, true)
          else
            s = self.attr_server_socket
          end
        rescue IOException => ex
          # If we fail to connect through the tunnel, try it
          # locally, as a last resort.  If this doesn't work,
          # throw the original exception.
          begin
            s = factory.create_socket(self.attr_host, self.attr_port)
          rescue IOException => ignored
            raise ex
          end
        end
        # Force handshaking, so that we get any authentication.
        # Register a handshake callback so our session state tracks any
        # later session renegotiations.
        protocols = get_protocols
        ciphers = get_cipher_suites
        if (!(protocols).nil?)
          s.set_enabled_protocols(protocols)
        end
        if (!(ciphers).nil?)
          s.set_enabled_cipher_suites(ciphers)
        end
        s.add_handshake_completed_listener(self)
        # if the HostnameVerifier is not set, try to enable endpoint
        # identification during handshaking
        enabled_identification = false
        if (@hv.is_a?(DefaultHostnameVerifier) && (s.is_a?(SSLSocketImpl)) && (s).try_set_hostname_verification("HTTPS"))
          enabled_identification = true
        end
        s.start_handshake
        @session = s.get_session
        # change the serverSocket and serverOutput
        self.attr_server_socket = s
        begin
          self.attr_server_output = PrintStream.new(BufferedOutputStream.new(self.attr_server_socket.get_output_stream), false, self.attr_encoding)
        rescue UnsupportedEncodingException => e
          raise InternalError.new(RJava.cast_to_string(self.attr_encoding) + " encoding not found")
        end
        # check URL spoofing if it has not been checked under handshaking
        if (!enabled_identification)
          check_urlspoofing(@hv)
        end
      else
        # if we are reusing a cached https session,
        # we don't need to do handshaking etc. But we do need to
        # set the ssl session
        @session = (self.attr_server_socket).get_session
      end
    end
    
    typesig { [HostnameVerifier] }
    # Server identity checking is done according to RFC 2818: HTTP over TLS
    # Section 3.1 Server Identity
    def check_urlspoofing(hostname_verifier)
      # Get authenticated server name, if any
      done = false
      host = self.attr_url.get_host
      # if IPv6 strip off the "[]"
      if (!(host).nil? && host.starts_with("[") && host.ends_with("]"))
        host = RJava.cast_to_string(host.substring(1, host.length - 1))
      end
      peer_certs = nil
      begin
        checker = HostnameChecker.get_instance(HostnameChecker::TYPE_TLS)
        principal = get_peer_principal
        if (principal.is_a?(KerberosPrincipal))
          if (!checker.match(host, principal))
            raise SSLPeerUnverifiedException.new("Hostname checker" + " failed for Kerberos")
          end
        else
          # get the subject's certificate
          peer_certs = @session.get_peer_certificates
          peer_cert = nil
          if (peer_certs[0].is_a?(Java::Security::Cert::X509Certificate))
            peer_cert = peer_certs[0]
          else
            raise SSLPeerUnverifiedException.new("")
          end
          checker.match(host, peer_cert)
        end
        # if it doesn't throw an exception, we passed. Return.
        return
      rescue SSLPeerUnverifiedException => e
        # client explicitly changed default policy and enabled
        # anonymous ciphers; we can't check the standard policy
        # 
        # ignore
      rescue Java::Security::Cert::CertificateException => cpe
        # ignore
      end
      cipher = @session.get_cipher_suite
      if ((!(cipher).nil?) && (!(cipher.index_of("_anon_")).equal?(-1)))
        return
      else
        if ((!(hostname_verifier).nil?) && (hostname_verifier.verify(host, @session)))
          return
        end
      end
      self.attr_server_socket.close
      @session.invalidate
      raise IOException.new("HTTPS hostname wrong:  should be <" + RJava.cast_to_string(self.attr_url.get_host) + ">")
    end
    
    typesig { [] }
    def put_in_keep_alive_cache
      self.attr_kac.put(self.attr_url, @ssl_socket_factory, self)
    end
    
    typesig { [] }
    # Returns the cipher suite in use on this connection.
    def get_cipher_suite
      return @session.get_cipher_suite
    end
    
    typesig { [] }
    # Returns the certificate chain the client sent to the
    # server, or null if the client did not authenticate.
    def get_local_certificates
      return @session.get_local_certificates
    end
    
    typesig { [] }
    # Returns the certificate chain with which the server
    # authenticated itself, or throw a SSLPeerUnverifiedException
    # if the server did not authenticate.
    def get_server_certificates
      return @session.get_peer_certificates
    end
    
    typesig { [] }
    # Returns the X.509 certificate chain with which the server
    # authenticated itself, or null if the server did not authenticate.
    def get_server_certificate_chain
      return @session.get_peer_certificate_chain
    end
    
    typesig { [] }
    # Returns the principal with which the server authenticated
    # itself, or throw a SSLPeerUnverifiedException if the
    # server did not authenticate.
    def get_peer_principal
      principal = nil
      begin
        principal = @session.get_peer_principal
      rescue AbstractMethodError => e
        # if the provider does not support it, fallback to peer certs.
        # return the X500Principal of the end-entity cert.
        certs = @session.get_peer_certificates
        principal = (certs[0]).get_subject_x500principal
      end
      return principal
    end
    
    typesig { [] }
    # Returns the principal the client sent to the
    # server, or null if the client did not authenticate.
    def get_local_principal
      principal = nil
      begin
        principal = @session.get_local_principal
      rescue AbstractMethodError => e
        principal = nil
        # if the provider does not support it, fallback to local certs.
        # return the X500Principal of the end-entity cert.
        certs = @session.get_local_certificates
        if (!(certs).nil?)
          principal = (certs[0]).get_subject_x500principal
        end
      end
      return principal
    end
    
    typesig { [HandshakeCompletedEvent] }
    # This method implements the SSL HandshakeCompleted callback,
    # remembering the resulting session so that it may be queried
    # for the current cipher suite and peer certificates.  Servers
    # sometimes re-initiate handshaking, so the session in use on
    # a given connection may change.  When sessions change, so may
    # peer identities and cipher suites.
    def handshake_completed(event)
      @session = event.get_session
    end
    
    typesig { [] }
    # @return the proxy host being used for this client, or null
    # if we're not going through a proxy
    def get_proxy_host_used
      if (!needs_tunneling)
        return nil
      else
        return (self.attr_proxy.address).get_host_name
      end
    end
    
    typesig { [] }
    # @return the proxy port being used for this client.  Meaningless
    # if getProxyHostUsed() gives null.
    def get_proxy_port_used
      return ((self.attr_proxy).nil? || (self.attr_proxy.type).equal?(Proxy::Type::DIRECT) || (self.attr_proxy.type).equal?(Proxy::Type::SOCKS)) ? -1 : (self.attr_proxy.address).get_port
    end
    
    private
    alias_method :initialize__https_client, :initialize
  end
  
end
