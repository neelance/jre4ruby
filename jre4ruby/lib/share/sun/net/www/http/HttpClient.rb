require "rjava"

# Copyright 1994-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Http
  module HttpClientImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Http
      include ::Java::Io
      include ::Java::Net
      include ::Java::Util
      include_const ::Sun::Net, :NetworkClient
      include_const ::Sun::Net, :ProgressSource
      include_const ::Sun::Net, :ProgressMonitor
      include_const ::Sun::Net::Www, :MessageHeader
      include_const ::Sun::Net::Www, :HeaderParser
      include_const ::Sun::Net::Www, :MeteredStream
      include_const ::Sun::Net::Www, :ParseUtil
      include_const ::Sun::Net::Www::Protocol::Http, :HttpURLConnection
      include_const ::Sun::Misc, :RegexpPool
      include ::Java::Security
    }
  end
  
  # @author Herb Jellinek
  # @author Dave Brown
  class HttpClient < HttpClientImports.const_get :NetworkClient
    include_class_members HttpClientImports
    
    # whether this httpclient comes from the cache
    attr_accessor :cached_http_client
    alias_method :attr_cached_http_client, :cached_http_client
    undef_method :cached_http_client
    alias_method :attr_cached_http_client=, :cached_http_client=
    undef_method :cached_http_client=
    
    attr_accessor :in_cache
    alias_method :attr_in_cache, :in_cache
    undef_method :in_cache
    alias_method :attr_in_cache=, :in_cache=
    undef_method :in_cache=
    
    attr_accessor :cookie_handler
    alias_method :attr_cookie_handler, :cookie_handler
    undef_method :cookie_handler
    alias_method :attr_cookie_handler=, :cookie_handler=
    undef_method :cookie_handler=
    
    # Http requests we send
    attr_accessor :requests
    alias_method :attr_requests, :requests
    undef_method :requests
    alias_method :attr_requests=, :requests=
    undef_method :requests=
    
    # Http data we send with the headers
    attr_accessor :poster
    alias_method :attr_poster, :poster
    undef_method :poster
    alias_method :attr_poster=, :poster=
    undef_method :poster=
    
    # if we've had one io error
    attr_accessor :failed_once
    alias_method :attr_failed_once, :failed_once
    undef_method :failed_once
    alias_method :attr_failed_once=, :failed_once=
    undef_method :failed_once=
    
    class_module.module_eval {
      # regexp pool of hosts for which we should connect directly, not Proxy
      # these are intialized from a property.
      
      def non_proxy_hosts_pool
        defined?(@@non_proxy_hosts_pool) ? @@non_proxy_hosts_pool : @@non_proxy_hosts_pool= nil
      end
      alias_method :attr_non_proxy_hosts_pool, :non_proxy_hosts_pool
      
      def non_proxy_hosts_pool=(value)
        @@non_proxy_hosts_pool = value
      end
      alias_method :attr_non_proxy_hosts_pool=, :non_proxy_hosts_pool=
      
      # The string source of nonProxyHostsPool
      
      def non_proxy_hosts_source
        defined?(@@non_proxy_hosts_source) ? @@non_proxy_hosts_source : @@non_proxy_hosts_source= nil
      end
      alias_method :attr_non_proxy_hosts_source, :non_proxy_hosts_source
      
      def non_proxy_hosts_source=(value)
        @@non_proxy_hosts_source = value
      end
      alias_method :attr_non_proxy_hosts_source=, :non_proxy_hosts_source=
      
      # Response code for CONTINUE
      const_set_lazy(:HTTP_CONTINUE) { 100 }
      const_attr_reader  :HTTP_CONTINUE
      
      # Default port number for http daemons. REMIND: make these private
      const_set_lazy(:HttpPortNumber) { 80 }
      const_attr_reader  :HttpPortNumber
    }
    
    typesig { [] }
    # return default port number (subclasses may override)
    def get_default_port
      return HttpPortNumber
    end
    
    class_module.module_eval {
      typesig { [String] }
      def get_default_port(proto)
        if ("http".equals_ignore_case(proto))
          return 80
        end
        if ("https".equals_ignore_case(proto))
          return 443
        end
        return -1
      end
    }
    
    # The following three data members are left in for binary
    # backwards-compatibility.  Unfortunately, HotJava sets them directly
    # when it wants to change the settings.  The new design has us not
    # cache these, so this is unnecessary, but eliminating the data members
    # would break HJB 1.1 under JDK 1.2.
    # 
    # These data members are not used, and their values are meaningless.
    # REMIND:  Take them out for JDK 2.0!
    # 
    # @deprecated
    # 
    # public static String proxyHost = null;
    # 
    # @deprecated
    # 
    # public static int proxyPort = 80;
    # instance-specific proxy fields override the static fields if set.
    # Used by FTP.  These are set to the true proxy host/port if
    # usingProxy is true.
    # 
    # private String instProxy = null;
    # private int instProxyPort = -1;
    # All proxying (generic as well as instance-specific) may be
    # disabled through use of this flag
    attr_accessor :proxy_disabled
    alias_method :attr_proxy_disabled, :proxy_disabled
    undef_method :proxy_disabled
    alias_method :attr_proxy_disabled=, :proxy_disabled=
    undef_method :proxy_disabled=
    
    # are we using proxy in this instance?
    attr_accessor :using_proxy
    alias_method :attr_using_proxy, :using_proxy
    undef_method :using_proxy
    alias_method :attr_using_proxy=, :using_proxy=
    undef_method :using_proxy=
    
    # target host, port for the URL
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    class_module.module_eval {
      # where we cache currently open, persistent connections
      
      def kac
        defined?(@@kac) ? @@kac : @@kac= KeepAliveCache.new
      end
      alias_method :attr_kac, :kac
      
      def kac=(value)
        @@kac = value
      end
      alias_method :attr_kac=, :kac=
      
      
      def keep_alive_prop
        defined?(@@keep_alive_prop) ? @@keep_alive_prop : @@keep_alive_prop= true
      end
      alias_method :attr_keep_alive_prop, :keep_alive_prop
      
      def keep_alive_prop=(value)
        @@keep_alive_prop = value
      end
      alias_method :attr_keep_alive_prop=, :keep_alive_prop=
      
      # retryPostProp is true by default so as to preserve behavior
      # from previous releases.
      
      def retry_post_prop
        defined?(@@retry_post_prop) ? @@retry_post_prop : @@retry_post_prop= true
      end
      alias_method :attr_retry_post_prop, :retry_post_prop
      
      def retry_post_prop=(value)
        @@retry_post_prop = value
      end
      alias_method :attr_retry_post_prop=, :retry_post_prop=
    }
    
    attr_accessor :keeping_alive
    alias_method :attr_keeping_alive, :keeping_alive
    undef_method :keeping_alive
    alias_method :attr_keeping_alive=, :keeping_alive=
    undef_method :keeping_alive=
    
    # this is a keep-alive connection
    attr_accessor :keep_alive_connections
    alias_method :attr_keep_alive_connections, :keep_alive_connections
    undef_method :keep_alive_connections
    alias_method :attr_keep_alive_connections=, :keep_alive_connections=
    undef_method :keep_alive_connections=
    
    # number of keep-alives left
    # Idle timeout value, in milliseconds. Zero means infinity,
    # iff keepingAlive=true.
    # Unfortunately, we can't always believe this one.  If I'm connected
    # through a Netscape proxy to a server that sent me a keep-alive
    # time of 15 sec, the proxy unilaterally terminates my connection
    # after 5 sec.  So we have to hard code our effective timeout to
    # 4 sec for the case where we're using a proxy. *SIGH*
    attr_accessor :keep_alive_timeout
    alias_method :attr_keep_alive_timeout, :keep_alive_timeout
    undef_method :keep_alive_timeout
    alias_method :attr_keep_alive_timeout=, :keep_alive_timeout=
    undef_method :keep_alive_timeout=
    
    # whether the response is to be cached
    attr_accessor :cache_request
    alias_method :attr_cache_request, :cache_request
    undef_method :cache_request
    alias_method :attr_cache_request=, :cache_request=
    undef_method :cache_request=
    
    # Url being fetched.
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    # if set, the client will be reused and must not be put in cache
    attr_accessor :reuse
    alias_method :attr_reuse, :reuse
    undef_method :reuse
    alias_method :attr_reuse=, :reuse=
    undef_method :reuse=
    
    class_module.module_eval {
      typesig { [] }
      # A NOP method kept for backwards binary compatibility
      # @deprecated -- system properties are no longer cached.
      def reset_properties
        synchronized(self) do
        end
      end
    }
    
    typesig { [] }
    def get_keep_alive_timeout
      return @keep_alive_timeout
    end
    
    class_module.module_eval {
      when_class_loaded do
        keep_alive = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("http.keepAlive"))
        retry_post = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("sun.net.http.retryPost"))
        if (!(keep_alive).nil?)
          self.attr_keep_alive_prop = Boolean.value_of(keep_alive).boolean_value
        else
          self.attr_keep_alive_prop = true
        end
        if (!(retry_post).nil?)
          self.attr_retry_post_prop = Boolean.value_of(retry_post).boolean_value
        else
          self.attr_retry_post_prop = true
        end
      end
    }
    
    typesig { [] }
    # @return true iff http keep alive is set (i.e. enabled).  Defaults
    # to true if the system property http.keepAlive isn't set.
    def get_http_keep_alive_set
      return self.attr_keep_alive_prop
    end
    
    typesig { [] }
    def initialize
      @cached_http_client = false
      @in_cache = false
      @cookie_handler = nil
      @requests = nil
      @poster = nil
      @failed_once = false
      @proxy_disabled = false
      @using_proxy = false
      @host = nil
      @port = 0
      @keeping_alive = false
      @keep_alive_connections = 0
      @keep_alive_timeout = 0
      @cache_request = nil
      @url = nil
      @reuse = false
      super()
      @cached_http_client = false
      @poster = nil
      @failed_once = false
      @using_proxy = false
      @keeping_alive = false
      @keep_alive_connections = -1
      @keep_alive_timeout = 0
      @cache_request = nil
      @reuse = false
    end
    
    typesig { [URL] }
    def initialize(url)
      initialize__http_client(url, nil, -1, false)
    end
    
    typesig { [URL, ::Java::Boolean] }
    def initialize(url, proxy_disabled)
      initialize__http_client(url, nil, -1, proxy_disabled)
    end
    
    typesig { [URL, String, ::Java::Int] }
    # This package-only CTOR should only be used for FTP piggy-backed on HTTP
    # HTTP URL's that use this won't take advantage of keep-alive.
    # Additionally, this constructor may be used as a last resort when the
    # first HttpClient gotten through New() failed (probably b/c of a
    # Keep-Alive mismatch).
    # 
    # XXX That documentation is wrong ... it's not package-private any more
    def initialize(url, proxy_host, proxy_port)
      initialize__http_client(url, proxy_host, proxy_port, false)
    end
    
    typesig { [URL, Proxy, ::Java::Int] }
    def initialize(url, p, to)
      @cached_http_client = false
      @in_cache = false
      @cookie_handler = nil
      @requests = nil
      @poster = nil
      @failed_once = false
      @proxy_disabled = false
      @using_proxy = false
      @host = nil
      @port = 0
      @keeping_alive = false
      @keep_alive_connections = 0
      @keep_alive_timeout = 0
      @cache_request = nil
      @url = nil
      @reuse = false
      super()
      @cached_http_client = false
      @poster = nil
      @failed_once = false
      @using_proxy = false
      @keeping_alive = false
      @keep_alive_connections = -1
      @keep_alive_timeout = 0
      @cache_request = nil
      @reuse = false
      self.attr_proxy = ((p).nil?) ? Proxy::NO_PROXY : p
      @host = url.get_host
      @url = url
      @port = url.get_port
      if ((@port).equal?(-1))
        @port = get_default_port
      end
      set_connect_timeout(to)
      @cookie_handler = Java::Security::AccessController.do_privileged(# get the cookieHandler if there is any
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        local_class_in HttpClient
        include_class_members HttpClient
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
      typesig { [String, ::Java::Int, String] }
      def new_http_proxy(proxy_host, proxy_port, proto)
        if ((proxy_host).nil? || (proto).nil?)
          return Proxy::NO_PROXY
        end
        pport = proxy_port < 0 ? get_default_port(proto) : proxy_port
        saddr = InetSocketAddress.create_unresolved(proxy_host, pport)
        return Proxy.new(Proxy::Type::HTTP, saddr)
      end
    }
    
    typesig { [URL, String, ::Java::Int, ::Java::Boolean] }
    # This constructor gives "ultimate" flexibility, including the ability
    # to bypass implicit proxying.  Sometimes we need to be using tunneling
    # (transport or network level) instead of proxying (application level),
    # for example when we don't want the application level data to become
    # visible to third parties.
    # 
    # @param url               the URL to which we're connecting
    # @param proxy             proxy to use for this URL (e.g. forwarding)
    # @param proxyPort         proxy port to use for this URL
    # @param proxyDisabled     true to disable default proxying
    def initialize(url, proxy_host, proxy_port, proxy_disabled)
      initialize__http_client(url, proxy_disabled ? Proxy::NO_PROXY : new_http_proxy(proxy_host, proxy_port, "http"), -1)
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Boolean, ::Java::Int] }
    def initialize(url, proxy_host, proxy_port, proxy_disabled, to)
      initialize__http_client(url, proxy_disabled ? Proxy::NO_PROXY : new_http_proxy(proxy_host, proxy_port, "http"), to)
    end
    
    class_module.module_eval {
      typesig { [URL] }
      # This class has no public constructor for HTTP.  This method is used to
      # get an HttpClient to the specifed URL.  If there's currently an
      # active HttpClient to that server/port, you'll get that one.
      def _new(url)
        return HttpClient._new(url, Proxy::NO_PROXY, -1, true)
      end
      
      typesig { [URL, ::Java::Boolean] }
      def _new(url, use_cache)
        return HttpClient._new(url, Proxy::NO_PROXY, -1, use_cache)
      end
      
      typesig { [URL, Proxy, ::Java::Int, ::Java::Boolean] }
      def _new(url, p, to, use_cache)
        if ((p).nil?)
          p = Proxy::NO_PROXY
        end
        ret = nil
        # see if one's already around
        if (use_cache)
          ret = self.attr_kac.get(url, nil)
          if (!(ret).nil?)
            if ((!(ret.attr_proxy).nil? && (ret.attr_proxy == p)) || ((ret.attr_proxy).nil? && (p).nil?))
              synchronized((ret)) do
                ret.attr_cached_http_client = true
                raise AssertError if not (ret.attr_in_cache)
                ret.attr_in_cache = false
              end
            else
              # We cannot return this connection to the cache as it's
              # KeepAliveTimeout will get reset. We simply close the connection.
              # This should be fine as it is very rare that a connection
              # to the same host will not use the same proxy.
              ret.attr_in_cache = false
              ret.close_server
              ret = nil
            end
          end
        end
        if ((ret).nil?)
          ret = HttpClient.new(url, p, to)
        else
          security = System.get_security_manager
          if (!(security).nil?)
            if ((ret.attr_proxy).equal?(Proxy::NO_PROXY) || (ret.attr_proxy).nil?)
              security.check_connect(InetAddress.get_by_name(url.get_host).get_host_address, url.get_port)
            else
              security.check_connect(url.get_host, url.get_port)
            end
          end
          ret.attr_url = url
        end
        return ret
      end
      
      typesig { [URL, Proxy, ::Java::Int] }
      def _new(url, p, to)
        return _new(url, p, to, true)
      end
      
      typesig { [URL, String, ::Java::Int, ::Java::Boolean] }
      def _new(url, proxy_host, proxy_port, use_cache)
        return _new(url, new_http_proxy(proxy_host, proxy_port, "http"), -1, use_cache)
      end
      
      typesig { [URL, String, ::Java::Int, ::Java::Boolean, ::Java::Int] }
      def _new(url, proxy_host, proxy_port, use_cache, to)
        return _new(url, new_http_proxy(proxy_host, proxy_port, "http"), to, use_cache)
      end
    }
    
    typesig { [] }
    # return it to the cache as still usable, if:
    # 1) It's keeping alive, AND
    # 2) It still has some connections left, AND
    # 3) It hasn't had a error (PrintStream.checkError())
    # 4) It hasn't timed out
    # 
    # If this client is not keepingAlive, it should have been
    # removed from the cache in the parseHeaders() method.
    def finished
      if (@reuse)
        # will be reused
        return
      end
      @keep_alive_connections -= 1
      @poster = nil
      if (@keep_alive_connections > 0 && is_keeping_alive && !(self.attr_server_output.check_error))
        # This connection is keepingAlive && still valid.
        # Return it to the cache.
        put_in_keep_alive_cache
      else
        close_server
      end
    end
    
    typesig { [] }
    def put_in_keep_alive_cache
      synchronized(self) do
        if (@in_cache)
          raise AssertError, "Duplicate put to keep alive cache" if not (false)
          return
        end
        @in_cache = true
        self.attr_kac.put(@url, nil, self)
      end
    end
    
    typesig { [] }
    def is_in_keep_alive_cache
      return @in_cache
    end
    
    typesig { [] }
    # Close an idle connection to this URL (if it exists in the
    # cache).
    def close_idle_connection
      http = self.attr_kac.get(@url, nil)
      if (!(http).nil?)
        http.close_server
      end
    end
    
    typesig { [String, ::Java::Int] }
    # We're very particular here about what our InputStream to the server
    # looks like for reasons that are apparent if you can decipher the
    # method parseHTTP().  That's why this method is overidden from the
    # superclass.
    def open_server(server, port)
      self.attr_server_socket = do_connect(server, port)
      begin
        self.attr_server_output = PrintStream.new(BufferedOutputStream.new(self.attr_server_socket.get_output_stream), false, self.attr_encoding)
      rescue UnsupportedEncodingException => e
        raise InternalError.new(RJava.cast_to_string(self.attr_encoding) + " encoding not found")
      end
      self.attr_server_socket.set_tcp_no_delay(true)
    end
    
    typesig { [] }
    # Returns true if the http request should be tunneled through proxy.
    # An example where this is the case is Https.
    def needs_tunneling
      return false
    end
    
    typesig { [] }
    # Returns true if this httpclient is from cache
    def is_cached_connection
      return @cached_http_client
    end
    
    typesig { [] }
    # Finish any work left after the socket connection is
    # established.  In the normal http case, it's a NO-OP. Subclass
    # may need to override this. An example is Https, where for
    # direct connection to the origin server, ssl handshake needs to
    # be done; for proxy tunneling, the socket needs to be converted
    # into an SSL socket before ssl handshake can take place.
    def after_connect
      # NO-OP. Needs to be overwritten by HttpsClient
    end
    
    typesig { [InetSocketAddress] }
    # call openServer in a privileged block
    def privileged_open_server(server)
      synchronized(self) do
        begin
          Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
            local_class_in HttpClient
            include_class_members HttpClient
            include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              open_server(server.get_host_name, server.get_port)
              return nil
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue Java::Security::PrivilegedActionException => pae
          raise pae.get_exception
        end
      end
    end
    
    typesig { [String, ::Java::Int] }
    # call super.openServer
    def super_open_server(proxy_host, proxy_port)
      NetworkClient.instance_method(:open_server).bind(self).call(proxy_host, proxy_port)
    end
    
    typesig { [String, ::Java::Int] }
    # call super.openServer in a privileged block
    def privileged_super_open_server(proxy_host, proxy_port)
      synchronized(self) do
        begin
          Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
            local_class_in HttpClient
            include_class_members HttpClient
            include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              super_open_server(proxy_host, proxy_port)
              return nil
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue Java::Security::PrivilegedActionException => pae
          raise pae.get_exception
        end
      end
    end
    
    typesig { [] }
    def open_server
      synchronized(self) do
        security = System.get_security_manager
        if (@keeping_alive)
          # already opened
          if (!(security).nil?)
            security.check_connect(@host, @port)
          end
          return
        end
        url_host = @url.get_host.to_lower_case
        if ((@url.get_protocol == "http") || (@url.get_protocol == "https"))
          if ((!(self.attr_proxy).nil?) && ((self.attr_proxy.type).equal?(Proxy::Type::HTTP)))
            Sun::Net::Www::URLConnection.set_proxied_host(@host)
            if (!(security).nil?)
              security.check_connect(@host, @port)
            end
            privileged_open_server(self.attr_proxy.address)
            @using_proxy = true
            return
          else
            # make direct connection
            if (!(security).nil?)
              # redundant?
              security.check_connect(@host, @port)
            end
            open_server(@host, @port)
            @using_proxy = false
            return
          end
        else
          # we're opening some other kind of url, most likely an
          # ftp url.
          if ((!(self.attr_proxy).nil?) && ((self.attr_proxy.type).equal?(Proxy::Type::HTTP)))
            Sun::Net::Www::URLConnection.set_proxied_host(@host)
            if (!(security).nil?)
              security.check_connect(@host, @port)
            end
            privileged_open_server(self.attr_proxy.address)
            @using_proxy = true
            return
          else
            # make direct connection
            if (!(security).nil?)
              # redundant?
              security.check_connect(@host, @port)
            end
            super(@host, @port)
            @using_proxy = false
            return
          end
        end
      end
    end
    
    typesig { [] }
    def get_urlfile
      file_name = @url.get_file
      if (((file_name).nil?) || ((file_name.length).equal?(0)))
        file_name = "/"
      end
      # proxyDisabled is set by subclass HttpsClient!
      if (@using_proxy && !@proxy_disabled)
        # Do not use URLStreamHandler.toExternalForm as the fragment
        # should not be part of the RequestURI. It should be an
        # absolute URI which does not have a fragment part.
        result = StringBuffer.new(128)
        result.append(@url.get_protocol)
        result.append(":")
        if (!(@url.get_authority).nil? && @url.get_authority.length > 0)
          result.append("//")
          result.append(@url.get_authority)
        end
        if (!(@url.get_path).nil?)
          result.append(@url.get_path)
        end
        if (!(@url.get_query).nil?)
          result.append(Character.new(??.ord))
          result.append(@url.get_query)
        end
        file_name = RJava.cast_to_string(result.to_s)
      end
      if ((file_name.index_of(Character.new(?\n.ord))).equal?(-1))
        return file_name
      else
        raise Java::Net::MalformedURLException.new("Illegal character in URL")
      end
    end
    
    typesig { [MessageHeader] }
    # @deprecated
    def write_requests(head)
      @requests = head
      @requests.print(self.attr_server_output)
      self.attr_server_output.flush
    end
    
    typesig { [MessageHeader, PosterOutputStream] }
    def write_requests(head, pos)
      @requests = head
      @requests.print(self.attr_server_output)
      @poster = pos
      if (!(@poster).nil?)
        @poster.write_to(self.attr_server_output)
      end
      self.attr_server_output.flush
    end
    
    typesig { [MessageHeader, ProgressSource, HttpURLConnection] }
    # Parse the first line of the HTTP request.  It usually looks
    # something like: "HTTP/1.0 <number> comment\r\n".
    def parse_http(responses, pi, httpuc)
      # If "HTTP/*" is found in the beginning, return true.  Let
      # HttpURLConnection parse the mime header itself.
      # 
      # If this isn't valid HTTP, then we don't try to parse a header
      # out of the beginning of the response into the responses,
      # and instead just queue up the output stream to it's very beginning.
      # This seems most reasonable, and is what the NN browser does.
      begin
        self.attr_server_input = self.attr_server_socket.get_input_stream
        self.attr_server_input = BufferedInputStream.new(self.attr_server_input)
        return (parse_httpheader(responses, pi, httpuc))
      rescue SocketTimeoutException => stex
        # We don't want to retry the request when the app. sets a timeout
        close_server
        raise stex
      rescue IOException => e
        close_server
        @cached_http_client = false
        if (!@failed_once && !(@requests).nil?)
          if ((httpuc.get_request_method == "POST") && !self.attr_retry_post_prop)
            # do not retry the request
          else
            # try once more
            @failed_once = true
            open_server
            if (needs_tunneling)
              httpuc.do_tunneling
            end
            after_connect
            write_requests(@requests, @poster)
            return parse_http(responses, pi, httpuc)
          end
        end
        raise e
      end
    end
    
    typesig { [::Java::Int] }
    def set_timeout(timeout)
      old = self.attr_server_socket.get_so_timeout
      self.attr_server_socket.set_so_timeout(timeout)
      return old
    end
    
    typesig { [MessageHeader, ProgressSource, HttpURLConnection] }
    def parse_httpheader(responses, pi, httpuc)
      # If "HTTP/*" is found in the beginning, return true.  Let
      # HttpURLConnection parse the mime header itself.
      # 
      # If this isn't valid HTTP, then we don't try to parse a header
      # out of the beginning of the response into the responses,
      # and instead just queue up the output stream to it's very beginning.
      # This seems most reasonable, and is what the NN browser does.
      @keep_alive_connections = -1
      @keep_alive_timeout = 0
      ret = false
      b = Array.typed(::Java::Byte).new(8) { 0 }
      begin
        nread = 0
        self.attr_server_input.mark(10)
        while (nread < 8)
          r = self.attr_server_input.read(b, nread, 8 - nread)
          if (r < 0)
            break
          end
          nread += r
        end
        keep = nil
        ret = (b[0]).equal?(Character.new(?H.ord)) && (b[1]).equal?(Character.new(?T.ord)) && (b[2]).equal?(Character.new(?T.ord)) && (b[3]).equal?(Character.new(?P.ord)) && (b[4]).equal?(Character.new(?/.ord)) && (b[5]).equal?(Character.new(?1.ord)) && (b[6]).equal?(Character.new(?..ord))
        self.attr_server_input.reset
        if (ret)
          # is valid HTTP - response started w/ "HTTP/1."
          responses.parse_header(self.attr_server_input)
          # we've finished parsing http headers
          # check if there are any applicable cookies to set (in cache)
          if (!(@cookie_handler).nil?)
            uri = ParseUtil.to_uri(@url)
            # NOTE: That cast from Map shouldn't be necessary but
            # a bug in javac is triggered under certain circumstances
            # So we do put the cast in as a workaround until
            # it is resolved.
            if (!(uri).nil?)
              @cookie_handler.put(uri, responses.get_headers)
            end
          end
          # decide if we're keeping alive:
          # This is a bit tricky.  There's a spec, but most current
          # servers (10/1/96) that support this differ in dialects.
          # If the server/client misunderstand each other, the
          # protocol should fall back onto HTTP/1.0, no keep-alive.
          if (@using_proxy)
            # not likely a proxy will return this
            keep = RJava.cast_to_string(responses.find_value("Proxy-Connection"))
          end
          if ((keep).nil?)
            keep = RJava.cast_to_string(responses.find_value("Connection"))
          end
          if (!(keep).nil? && (keep.to_lower_case == "keep-alive"))
            # some servers, notably Apache1.1, send something like:
            # "Keep-Alive: timeout=15, max=1" which we should respect.
            p = HeaderParser.new(responses.find_value("Keep-Alive"))
            if (!(p).nil?)
              # default should be larger in case of proxy
              @keep_alive_connections = p.find_int("max", @using_proxy ? 50 : 5)
              @keep_alive_timeout = p.find_int("timeout", @using_proxy ? 60 : 5)
            end
          else
            if (!(b[7]).equal?(Character.new(?0.ord)))
              # We're talking 1.1 or later. Keep persistent until
              # the server says to close.
              if (!(keep).nil?)
                # The only Connection token we understand is close.
                # Paranoia: if there is any Connection header then
                # treat as non-persistent.
                @keep_alive_connections = 1
              else
                @keep_alive_connections = 5
              end
            end
          end
        else
          if (!(nread).equal?(8))
            if (!@failed_once && !(@requests).nil?)
              if ((httpuc.get_request_method == "POST") && !self.attr_retry_post_prop)
                # do not retry the request
              else
                @failed_once = true
                close_server
                @cached_http_client = false
                open_server
                if (needs_tunneling)
                  httpuc.do_tunneling
                end
                after_connect
                write_requests(@requests, @poster)
                return parse_http(responses, pi, httpuc)
              end
            end
            raise SocketException.new("Unexpected end of file from server")
          else
            # we can't vouche for what this is....
            responses.set("Content-type", "unknown/unknown")
          end
        end
      rescue IOException => e
        raise e
      end
      code = -1
      begin
        resp = nil
        resp = RJava.cast_to_string(responses.get_value(0))
        # should have no leading/trailing LWS
        # expedite the typical case by assuming it has
        # form "HTTP/1.x <WS> 2XX <mumble>"
        ind = 0
        ind = resp.index_of(Character.new(?\s.ord))
        while ((resp.char_at(ind)).equal?(Character.new(?\s.ord)))
          ind += 1
        end
        code = JavaInteger.parse_int(resp.substring(ind, ind + 3))
      rescue JavaException => e
      end
      if ((code).equal?(HTTP_CONTINUE))
        responses.reset
        return parse_httpheader(responses, pi, httpuc)
      end
      cl = -1
      # Set things up to parse the entity body of the reply.
      # We should be smarter about avoid pointless work when
      # the HTTP method and response code indicate there will be
      # no entity body to parse.
      te = nil
      begin
        te = RJava.cast_to_string(responses.find_value("Transfer-Encoding"))
      rescue JavaException => e
      end
      if (!(te).nil? && te.equals_ignore_case("chunked"))
        self.attr_server_input = ChunkedInputStream.new(self.attr_server_input, self, responses)
        # If keep alive not specified then close after the stream
        # has completed.
        if (@keep_alive_connections <= 1)
          @keep_alive_connections = 1
          @keeping_alive = false
        else
          @keeping_alive = true
        end
        @failed_once = false
      else
        # If it's a keep alive connection then we will keep
        # (alive if :-
        # 1. content-length is specified, or
        # 2. "Not-Modified" or "No-Content" responses - RFC 2616 states that
        # 204 or 304 response must not include a message body.
        begin
          cl = JavaInteger.parse_int(responses.find_value("content-length"))
        rescue JavaException => e
        end
        request_line = @requests.get_key(0)
        if ((!(request_line).nil? && (request_line.starts_with("HEAD"))) || (code).equal?(HttpURLConnection::HTTP_NOT_MODIFIED) || (code).equal?(HttpURLConnection::HTTP_NO_CONTENT))
          cl = 0
        end
        if (@keep_alive_connections > 1 && (cl >= 0 || (code).equal?(HttpURLConnection::HTTP_NOT_MODIFIED) || (code).equal?(HttpURLConnection::HTTP_NO_CONTENT)))
          @keeping_alive = true
          @failed_once = false
        else
          if (@keeping_alive)
            # Previously we were keeping alive, and now we're not.  Remove
            # this from the cache (but only here, once) - otherwise we get
            # multiple removes and the cache count gets messed up.
            @keeping_alive = false
          end
        end
      end
      # wrap a KeepAliveStream/MeteredStream around it if appropriate
      if (cl > 0)
        # In this case, content length is well known, so it is okay
        # to wrap the input stream with KeepAliveStream/MeteredStream.
        if (!(pi).nil?)
          # Progress monitor is enabled
          pi.set_content_type(responses.find_value("content-type"))
        end
        if (is_keeping_alive)
          # Wrap KeepAliveStream if keep alive is enabled.
          self.attr_server_input = KeepAliveStream.new(self.attr_server_input, pi, cl, self)
          @failed_once = false
        else
          self.attr_server_input = MeteredStream.new(self.attr_server_input, pi, cl)
        end
      else
        if ((cl).equal?(-1))
          # In this case, content length is unknown - the input
          # stream would simply be a regular InputStream or
          # ChunkedInputStream.
          if (!(pi).nil?)
            # Progress monitoring is enabled.
            pi.set_content_type(responses.find_value("content-type"))
            # Wrap MeteredStream for tracking indeterministic
            # progress, even if the input stream is ChunkedInputStream.
            self.attr_server_input = MeteredStream.new(self.attr_server_input, pi, cl)
          else
            # Progress monitoring is disabled, and there is no
            # need to wrap an unknown length input stream.
            # ** This is an no-op **
          end
        else
          if (!(pi).nil?)
            pi.finish_tracking
          end
        end
      end
      return ret
    end
    
    typesig { [] }
    def get_input_stream
      synchronized(self) do
        return self.attr_server_input
      end
    end
    
    typesig { [] }
    def get_output_stream
      return self.attr_server_output
    end
    
    typesig { [] }
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "(" + RJava.cast_to_string(@url) + ")"
    end
    
    typesig { [] }
    def is_keeping_alive
      return get_http_keep_alive_set && @keeping_alive
    end
    
    typesig { [CacheRequest] }
    def set_cache_request(cache_request)
      @cache_request = cache_request
    end
    
    typesig { [] }
    def get_cache_request
      return @cache_request
    end
    
    typesig { [] }
    def finalize
      # This should do nothing.  The stream finalizer will
      # close the fd.
    end
    
    typesig { [::Java::Boolean] }
    def set_do_not_retry(value)
      # failedOnce is used to determine if a request should be retried.
      @failed_once = value
    end
    
    typesig { [] }
    # Use only on connections in error.
    def close_server
      begin
        @keeping_alive = false
        self.attr_server_socket.close
      rescue JavaException => e
      end
    end
    
    typesig { [] }
    # @return the proxy host being used for this client, or null
    # if we're not going through a proxy
    def get_proxy_host_used
      if (!@using_proxy)
        return nil
      else
        return (self.attr_proxy.address).get_host_name
      end
    end
    
    typesig { [] }
    # @return the proxy port being used for this client.  Meaningless
    # if getProxyHostUsed() gives null.
    def get_proxy_port_used
      if (@using_proxy)
        return (self.attr_proxy.address).get_port
      end
      return -1
    end
    
    private
    alias_method :initialize__http_client, :initialize
  end
  
end
