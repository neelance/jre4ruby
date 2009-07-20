require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Http
  module HttpURLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :ProtocolException
      include_const ::Java::Net, :HttpRetryException
      include_const ::Java::Net, :PasswordAuthentication
      include_const ::Java::Net, :Authenticator
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Net, :SocketTimeoutException
      include_const ::Java::Net, :Proxy
      include_const ::Java::Net, :ProxySelector
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :InetSocketAddress
      include_const ::Java::Net, :CookieHandler
      include_const ::Java::Net, :ResponseCache
      include_const ::Java::Net, :CacheResponse
      include_const ::Java::Net, :SecureCacheResponse
      include_const ::Java::Net, :CacheRequest
      include_const ::Java::Net::Authenticator, :RequestorType
      include ::Java::Io
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util::Logging, :Level
      include_const ::Java::Util::Logging, :Logger
      include ::Sun::Net
      include ::Sun::Net::Www
      include_const ::Sun::Net::Www::Http, :HttpClient
      include_const ::Sun::Net::Www::Http, :PosterOutputStream
      include_const ::Sun::Net::Www::Http, :ChunkedInputStream
      include_const ::Sun::Net::Www::Http, :ChunkedOutputStream
      include_const ::Java::Text, :SimpleDateFormat
      include_const ::Java::Util, :TimeZone
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio::Channels, :ReadableByteChannel
      include_const ::Java::Nio::Channels, :WritableByteChannel
      include_const ::Java::Nio::Channels, :Selector
      include_const ::Java::Nio::Channels, :SelectionKey
      include_const ::Java::Nio::Channels, :SelectableChannel
      include ::Java::Lang::Reflect
    }
  end
  
  # A class to represent an HTTP connection to a remote object.
  class HttpURLConnection < Java::Net::HttpURLConnection
    include_class_members HttpURLConnectionImports
    
    class_module.module_eval {
      
      def logger
        defined?(@@logger) ? @@logger : @@logger= Logger.get_logger("sun.net.www.protocol.http.HttpURLConnection")
      end
      alias_method :attr_logger, :logger
      
      def logger=(value)
        @@logger = value
      end
      alias_method :attr_logger=, :logger=
      
      # max # of allowed re-directs
      const_set_lazy(:DefaultmaxRedirects) { 20 }
      const_attr_reader  :DefaultmaxRedirects
    }
    
    attr_accessor :str_output_stream
    alias_method :attr_str_output_stream, :str_output_stream
    undef_method :str_output_stream
    alias_method :attr_str_output_stream=, :str_output_stream=
    undef_method :str_output_stream=
    
    class_module.module_eval {
      const_set_lazy(:RETRY_MSG1) { "cannot retry due to proxy authentication, in streaming mode" }
      const_attr_reader  :RETRY_MSG1
      
      const_set_lazy(:RETRY_MSG2) { "cannot retry due to server authentication, in streaming mode" }
      const_attr_reader  :RETRY_MSG2
      
      const_set_lazy(:RETRY_MSG3) { "cannot retry due to redirection, in streaming mode" }
      const_attr_reader  :RETRY_MSG3
      
      # System properties related to error stream handling:
      # 
      # sun.net.http.errorstream.enableBuffering = <boolean>
      # 
      # With the above system property set to true (default is false),
      # when the response code is >=400, the HTTP handler will try to
      # buffer the response body (up to a certain amount and within a
      # time limit). Thus freeing up the underlying socket connection
      # for reuse. The rationale behind this is that usually when the
      # server responds with a >=400 error (client error or server
      # error, such as 404 file not found), the server will send a
      # small response body to explain who to contact and what to do to
      # recover. With this property set to true, even if the
      # application doesn't call getErrorStream(), read the response
      # body, and then call close(), the underlying socket connection
      # can still be kept-alive and reused. The following two system
      # properties provide further control to the error stream
      # buffering behaviour.
      # 
      # sun.net.http.errorstream.timeout = <int>
      # the timeout (in millisec) waiting the error stream
      # to be buffered; default is 300 ms
      # 
      # sun.net.http.errorstream.bufferSize = <int>
      # the size (in bytes) to use for the buffering the error stream;
      # default is 4k
      # 
      # Should we enable buffering of error streams?
      
      def enable_esbuffer
        defined?(@@enable_esbuffer) ? @@enable_esbuffer : @@enable_esbuffer= false
      end
      alias_method :attr_enable_esbuffer, :enable_esbuffer
      
      def enable_esbuffer=(value)
        @@enable_esbuffer = value
      end
      alias_method :attr_enable_esbuffer=, :enable_esbuffer=
      
      # timeout waiting for read for buffered error stream;
      
      def timeout4esbuffer
        defined?(@@timeout4esbuffer) ? @@timeout4esbuffer : @@timeout4esbuffer= 0
      end
      alias_method :attr_timeout4esbuffer, :timeout4esbuffer
      
      def timeout4esbuffer=(value)
        @@timeout4esbuffer = value
      end
      alias_method :attr_timeout4esbuffer=, :timeout4esbuffer=
      
      # buffer size for buffered error stream;
      
      def buf_size4es
        defined?(@@buf_size4es) ? @@buf_size4es : @@buf_size4es= 0
      end
      alias_method :attr_buf_size4es, :buf_size4es
      
      def buf_size4es=(value)
        @@buf_size4es = value
      end
      alias_method :attr_buf_size4es=, :buf_size4es=
      
      when_class_loaded do
        const_set :MaxRedirects, Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("http.maxRedirects", DefaultmaxRedirects)).int_value
        const_set :Version, (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.version"))).to_s
        agent = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("http.agent"))
        if ((agent).nil?)
          agent = "Java/" + Version
        else
          agent = agent + " Java/" + Version
        end
        const_set :UserAgent, agent
        const_set :ValidateProxy, Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("http.auth.digest.validateProxy")).boolean_value
        const_set :ValidateServer, Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("http.auth.digest.validateServer")).boolean_value
        self.attr_enable_esbuffer = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.net.http.errorstream.enableBuffering")).boolean_value
        self.attr_timeout4esbuffer = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("sun.net.http.errorstream.timeout", 300)).int_value
        if (self.attr_timeout4esbuffer <= 0)
          self.attr_timeout4esbuffer = 300 # use the default
        end
        self.attr_buf_size4es = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("sun.net.http.errorstream.bufferSize", 4096)).int_value
        if (self.attr_buf_size4es <= 0)
          self.attr_buf_size4es = 4096 # use the default
        end
      end
      
      const_set_lazy(:HttpVersion) { "HTTP/1.1" }
      const_attr_reader  :HttpVersion
      
      const_set_lazy(:AcceptString) { "text/html, image/gif, image/jpeg, *; q=.2, */*; q=.2" }
      const_attr_reader  :AcceptString
      
      # the following http request headers should NOT have their values
      # returned for security reasons.
      const_set_lazy(:EXCLUDE_HEADERS) { Array.typed(String).new(["Proxy-Authorization", "Authorization"]) }
      const_attr_reader  :EXCLUDE_HEADERS
    }
    
    attr_accessor :http
    alias_method :attr_http, :http
    undef_method :http
    alias_method :attr_http=, :http=
    undef_method :http=
    
    attr_accessor :handler
    alias_method :attr_handler, :handler
    undef_method :handler
    alias_method :attr_handler=, :handler=
    undef_method :handler=
    
    attr_accessor :inst_proxy
    alias_method :attr_inst_proxy, :inst_proxy
    undef_method :inst_proxy
    alias_method :attr_inst_proxy=, :inst_proxy=
    undef_method :inst_proxy=
    
    attr_accessor :cookie_handler
    alias_method :attr_cookie_handler, :cookie_handler
    undef_method :cookie_handler
    alias_method :attr_cookie_handler=, :cookie_handler=
    undef_method :cookie_handler=
    
    attr_accessor :cache_handler
    alias_method :attr_cache_handler, :cache_handler
    undef_method :cache_handler
    alias_method :attr_cache_handler=, :cache_handler=
    undef_method :cache_handler=
    
    # the cached response, and cached response headers and body
    attr_accessor :cached_response
    alias_method :attr_cached_response, :cached_response
    undef_method :cached_response
    alias_method :attr_cached_response=, :cached_response=
    undef_method :cached_response=
    
    attr_accessor :cached_headers
    alias_method :attr_cached_headers, :cached_headers
    undef_method :cached_headers
    alias_method :attr_cached_headers=, :cached_headers=
    undef_method :cached_headers=
    
    attr_accessor :cached_input_stream
    alias_method :attr_cached_input_stream, :cached_input_stream
    undef_method :cached_input_stream
    alias_method :attr_cached_input_stream=, :cached_input_stream=
    undef_method :cached_input_stream=
    
    # output stream to server
    attr_accessor :ps
    alias_method :attr_ps, :ps
    undef_method :ps
    alias_method :attr_ps=, :ps=
    undef_method :ps=
    
    # buffered error stream
    attr_accessor :error_stream
    alias_method :attr_error_stream, :error_stream
    undef_method :error_stream
    alias_method :attr_error_stream=, :error_stream=
    undef_method :error_stream=
    
    # User set Cookies
    attr_accessor :set_user_cookies
    alias_method :attr_set_user_cookies, :set_user_cookies
    undef_method :set_user_cookies
    alias_method :attr_set_user_cookies=, :set_user_cookies=
    undef_method :set_user_cookies=
    
    attr_accessor :user_cookies
    alias_method :attr_user_cookies, :user_cookies
    undef_method :user_cookies
    alias_method :attr_user_cookies=, :user_cookies=
    undef_method :user_cookies=
    
    class_module.module_eval {
      # We only have a single static authenticator for now.
      # REMIND:  backwards compatibility with JDK 1.1.  Should be
      # eliminated for JDK 2.0.
      
      def default_auth
        defined?(@@default_auth) ? @@default_auth : @@default_auth= nil
      end
      alias_method :attr_default_auth, :default_auth
      
      def default_auth=(value)
        @@default_auth = value
      end
      alias_method :attr_default_auth=, :default_auth=
    }
    
    # all the headers we send
    # NOTE: do *NOT* dump out the content of 'requests' in the
    # output or stacktrace since it may contain security-sensitive
    # headers such as those defined in EXCLUDE_HEADERS.
    attr_accessor :requests
    alias_method :attr_requests, :requests
    undef_method :requests
    alias_method :attr_requests=, :requests=
    undef_method :requests=
    
    # The following two fields are only used with Digest Authentication
    attr_accessor :domain
    alias_method :attr_domain, :domain
    undef_method :domain
    alias_method :attr_domain=, :domain=
    undef_method :domain=
    
    # The list of authentication domains
    attr_accessor :digestparams
    alias_method :attr_digestparams, :digestparams
    undef_method :digestparams
    alias_method :attr_digestparams=, :digestparams=
    undef_method :digestparams=
    
    # Current credentials in use
    attr_accessor :current_proxy_credentials
    alias_method :attr_current_proxy_credentials, :current_proxy_credentials
    undef_method :current_proxy_credentials
    alias_method :attr_current_proxy_credentials=, :current_proxy_credentials=
    undef_method :current_proxy_credentials=
    
    attr_accessor :current_server_credentials
    alias_method :attr_current_server_credentials, :current_server_credentials
    undef_method :current_server_credentials
    alias_method :attr_current_server_credentials=, :current_server_credentials=
    undef_method :current_server_credentials=
    
    attr_accessor :need_to_check
    alias_method :attr_need_to_check, :need_to_check
    undef_method :need_to_check
    alias_method :attr_need_to_check=, :need_to_check=
    undef_method :need_to_check=
    
    attr_accessor :doing_ntlm2nd_stage
    alias_method :attr_doing_ntlm2nd_stage, :doing_ntlm2nd_stage
    undef_method :doing_ntlm2nd_stage
    alias_method :attr_doing_ntlm2nd_stage=, :doing_ntlm2nd_stage=
    undef_method :doing_ntlm2nd_stage=
    
    # doing the 2nd stage of an NTLM server authentication
    attr_accessor :doing_ntlmp2nd_stage
    alias_method :attr_doing_ntlmp2nd_stage, :doing_ntlmp2nd_stage
    undef_method :doing_ntlmp2nd_stage
    alias_method :attr_doing_ntlmp2nd_stage=, :doing_ntlmp2nd_stage=
    undef_method :doing_ntlmp2nd_stage=
    
    # doing the 2nd stage of an NTLM proxy authentication
    # try auth without calling Authenticator
    attr_accessor :try_transparent_ntlmserver
    alias_method :attr_try_transparent_ntlmserver, :try_transparent_ntlmserver
    undef_method :try_transparent_ntlmserver
    alias_method :attr_try_transparent_ntlmserver=, :try_transparent_ntlmserver=
    undef_method :try_transparent_ntlmserver=
    
    attr_accessor :try_transparent_ntlmproxy
    alias_method :attr_try_transparent_ntlmproxy, :try_transparent_ntlmproxy
    undef_method :try_transparent_ntlmproxy
    alias_method :attr_try_transparent_ntlmproxy=, :try_transparent_ntlmproxy=
    undef_method :try_transparent_ntlmproxy=
    
    attr_accessor :auth_obj
    alias_method :attr_auth_obj, :auth_obj
    undef_method :auth_obj
    alias_method :attr_auth_obj=, :auth_obj=
    undef_method :auth_obj=
    
    # Set if the user is manually setting the Authorization or Proxy-Authorization headers
    attr_accessor :is_user_server_auth
    alias_method :attr_is_user_server_auth, :is_user_server_auth
    undef_method :is_user_server_auth
    alias_method :attr_is_user_server_auth=, :is_user_server_auth=
    undef_method :is_user_server_auth=
    
    attr_accessor :is_user_proxy_auth
    alias_method :attr_is_user_proxy_auth, :is_user_proxy_auth
    undef_method :is_user_proxy_auth
    alias_method :attr_is_user_proxy_auth=, :is_user_proxy_auth=
    undef_method :is_user_proxy_auth=
    
    # Progress source
    attr_accessor :pi
    alias_method :attr_pi, :pi
    undef_method :pi
    alias_method :attr_pi=, :pi=
    undef_method :pi=
    
    # all the response headers we get back
    attr_accessor :responses
    alias_method :attr_responses, :responses
    undef_method :responses
    alias_method :attr_responses=, :responses=
    undef_method :responses=
    
    # the stream _from_ the server
    attr_accessor :input_stream
    alias_method :attr_input_stream, :input_stream
    undef_method :input_stream
    alias_method :attr_input_stream=, :input_stream=
    undef_method :input_stream=
    
    # post stream _to_ the server, if any
    attr_accessor :poster
    alias_method :attr_poster, :poster
    undef_method :poster
    alias_method :attr_poster=, :poster=
    undef_method :poster=
    
    # Indicates if the std. request headers have been set in requests.
    attr_accessor :set_requests
    alias_method :attr_set_requests, :set_requests
    undef_method :set_requests
    alias_method :attr_set_requests=, :set_requests=
    undef_method :set_requests=
    
    # Indicates whether a request has already failed or not
    attr_accessor :failed_once
    alias_method :attr_failed_once, :failed_once
    undef_method :failed_once
    alias_method :attr_failed_once=, :failed_once=
    undef_method :failed_once=
    
    # Remembered Exception, we will throw it again if somebody
    # calls getInputStream after disconnect
    attr_accessor :remembered_exception
    alias_method :attr_remembered_exception, :remembered_exception
    undef_method :remembered_exception
    alias_method :attr_remembered_exception=, :remembered_exception=
    undef_method :remembered_exception=
    
    # If we decide we want to reuse a client, we put it here
    attr_accessor :reuse_client
    alias_method :attr_reuse_client, :reuse_client
    undef_method :reuse_client
    alias_method :attr_reuse_client=, :reuse_client=
    undef_method :reuse_client=
    
    # Redefine timeouts from java.net.URLConnection as we nee -1 to mean
    # not set. This is to ensure backward compatibility.
    attr_accessor :connect_timeout
    alias_method :attr_connect_timeout, :connect_timeout
    undef_method :connect_timeout
    alias_method :attr_connect_timeout=, :connect_timeout=
    undef_method :connect_timeout=
    
    attr_accessor :read_timeout
    alias_method :attr_read_timeout, :read_timeout
    undef_method :read_timeout
    alias_method :attr_read_timeout=, :read_timeout=
    undef_method :read_timeout=
    
    class_module.module_eval {
      typesig { [String, InetAddress, ::Java::Int, String, String, String, URL, RequestorType] }
      # privileged request password authentication
      def privileged_request_password_authentication(host, addr, port, protocol, prompt, scheme, url, auth_type)
        return Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members HttpURLConnection
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Authenticator.request_password_authentication(host, addr, port, protocol, prompt, scheme, url, auth_type)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    }
    
    typesig { [String, String] }
    # checks the validity of http message header and throws
    # IllegalArgumentException if invalid.
    def check_message_header(key, value)
      lf = Character.new(?\n.ord)
      index = key.index_of(lf)
      if (!(index).equal?(-1))
        raise IllegalArgumentException.new("Illegal character(s) in message header field: " + key)
      else
        if ((value).nil?)
          return
        end
        index = value.index_of(lf)
        while (!(index).equal?(-1))
          index += 1
          if (index < value.length)
            c = value.char_at(index)
            if (((c).equal?(Character.new(?\s.ord))) || ((c).equal?(Character.new(?\t.ord))))
              # ok, check the next occurrence
              index = value.index_of(lf, index)
              next
            end
          end
          raise IllegalArgumentException.new("Illegal character(s) in message header value: " + value)
        end
      end
    end
    
    typesig { [] }
    # adds the standard key/val pairs to reqests if necessary & write to
    # given PrintStream
    def write_requests
      # print all message headers in the MessageHeader
      # onto the wire - all the ones we've set and any
      # others that have been set
      # 
      # send any pre-emptive authentication
      if (@http.attr_using_proxy)
        set_preemptive_proxy_authentication(@requests)
      end
      if (!@set_requests)
        # We're very particular about the order in which we
        # set the request headers here.  The order should not
        # matter, but some careless CGI programs have been
        # written to expect a very particular order of the
        # standard headers.  To name names, the order in which
        # Navigator3.0 sends them.  In particular, we make *sure*
        # to send Content-type: <> and Content-length:<> second
        # to last and last, respectively, in the case of a POST
        # request.
        if (!@failed_once)
          @requests.prepend((self.attr_method).to_s + " " + (@http.get_urlfile).to_s + " " + HttpVersion, nil)
        end
        if (!get_use_caches)
          @requests.set_if_not_set("Cache-Control", "no-cache")
          @requests.set_if_not_set("Pragma", "no-cache")
        end
        @requests.set_if_not_set("User-Agent", UserAgent)
        port = self.attr_url.get_port
        host = self.attr_url.get_host
        if (!(port).equal?(-1) && !(port).equal?(self.attr_url.get_default_port))
          host += ":" + (String.value_of(port)).to_s
        end
        @requests.set_if_not_set("Host", host)
        @requests.set_if_not_set("Accept", AcceptString)
        # For HTTP/1.1 the default behavior is to keep connections alive.
        # However, we may be talking to a 1.0 server so we should set
        # keep-alive just in case, except if we have encountered an error
        # or if keep alive is disabled via a system property
        # 
        # Try keep-alive only on first attempt
        if (!@failed_once && @http.get_http_keep_alive_set)
          if (@http.attr_using_proxy)
            @requests.set_if_not_set("Proxy-Connection", "keep-alive")
          else
            @requests.set_if_not_set("Connection", "keep-alive")
          end
        else
          # RFC 2616 HTTP/1.1 section 14.10 says:
          # HTTP/1.1 applications that do not support persistent
          # connections MUST include the "close" connection option
          # in every message
          @requests.set_if_not_set("Connection", "close")
        end
        # Set modified since if necessary
        mod_time = get_if_modified_since
        if (!(mod_time).equal?(0))
          date = Date.new(mod_time)
          # use the preferred date format according to RFC 2068(HTTP1.1),
          # RFC 822 and RFC 1123
          fo = SimpleDateFormat.new("EEE, dd MMM yyyy HH:mm:ss 'GMT'", Locale::US)
          fo.set_time_zone(TimeZone.get_time_zone("GMT"))
          @requests.set_if_not_set("If-Modified-Since", fo.format(date))
        end
        # check for preemptive authorization
        sauth = AuthenticationInfo.get_server_auth(self.attr_url)
        if (!(sauth).nil? && sauth.supports_preemptive_authorization)
          # Sets "Authorization"
          @requests.set_if_not_set(sauth.get_header_name, sauth.get_header_value(self.attr_url, self.attr_method))
          @current_server_credentials = sauth
        end
        if (!(self.attr_method == "PUT") && (!(@poster).nil? || streaming))
          @requests.set_if_not_set("Content-type", "application/x-www-form-urlencoded")
        end
        if (streaming)
          if (!(self.attr_chunk_length).equal?(-1))
            @requests.set("Transfer-Encoding", "chunked")
          else
            @requests.set("Content-Length", String.value_of(self.attr_fixed_content_length))
          end
        else
          if (!(@poster).nil?)
            # add Content-Length & POST/PUT data
            synchronized((@poster)) do
              # close it, so no more data can be added
              @poster.close
              @requests.set("Content-Length", String.value_of(@poster.size))
            end
          end
        end
        # get applicable cookies based on the uri and request headers
        # add them to the existing request headers
        set_cookie_header
        @set_requests = true
      end
      if (self.attr_logger.is_loggable(Level::FINEST))
        self.attr_logger.fine(@requests.to_s)
      end
      @http.write_requests(@requests, @poster)
      if (@ps.check_error)
        proxy_host = @http.get_proxy_host_used
        proxy_port = @http.get_proxy_port_used
        disconnect_internal
        if (@failed_once)
          raise IOException.new("Error writing to server")
        else
          # try once more
          @failed_once = true
          if (!(proxy_host).nil?)
            set_proxied_client(self.attr_url, proxy_host, proxy_port)
          else
            set_new_client(self.attr_url)
          end
          @ps = @http.get_output_stream
          self.attr_connected = true
          @responses = MessageHeader.new
          @set_requests = false
          write_requests
        end
      end
    end
    
    typesig { [URL] }
    # Create a new HttpClient object, bypassing the cache of
    # HTTP client objects/connections.
    # 
    # @param url       the URL being accessed
    def set_new_client(url)
      set_new_client(url, false)
    end
    
    typesig { [URL, ::Java::Boolean] }
    # Obtain a HttpsClient object. Use the cached copy if specified.
    # 
    # @param url       the URL being accessed
    # @param useCache  whether the cached connection should be used
    # if present
    def set_new_client(url, use_cache)
      @http = HttpClient._new(url, nil, -1, use_cache, @connect_timeout)
      @http.set_read_timeout(@read_timeout)
    end
    
    typesig { [URL, String, ::Java::Int] }
    # Create a new HttpClient object, set up so that it uses
    # per-instance proxying to the given HTTP proxy.  This
    # bypasses the cache of HTTP client objects/connections.
    # 
    # @param url       the URL being accessed
    # @param proxyHost the proxy host to use
    # @param proxyPort the proxy port to use
    def set_proxied_client(url, proxy_host, proxy_port)
      set_proxied_client(url, proxy_host, proxy_port, false)
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Boolean] }
    # Obtain a HttpClient object, set up so that it uses per-instance
    # proxying to the given HTTP proxy. Use the cached copy of HTTP
    # client objects/connections if specified.
    # 
    # @param url       the URL being accessed
    # @param proxyHost the proxy host to use
    # @param proxyPort the proxy port to use
    # @param useCache  whether the cached connection should be used
    # if present
    def set_proxied_client(url, proxy_host, proxy_port, use_cache)
      proxied_connect(url, proxy_host, proxy_port, use_cache)
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Boolean] }
    def proxied_connect(url, proxy_host, proxy_port, use_cache)
      @http = HttpClient._new(url, proxy_host, proxy_port, use_cache, @connect_timeout)
      @http.set_read_timeout(@read_timeout)
    end
    
    typesig { [URL, Handler] }
    def initialize(u, handler)
      # we set proxy == null to distinguish this case with the case
      # when per connection proxy is set
      initialize__http_urlconnection(u, nil, handler)
    end
    
    typesig { [URL, String, ::Java::Int] }
    def initialize(u, host, port)
      initialize__http_urlconnection(u, Proxy.new(Proxy::Type::HTTP, InetSocketAddress.create_unresolved(host, port)))
    end
    
    typesig { [URL, Proxy] }
    # this constructor is used by other protocol handlers such as ftp
    # that want to use http to fetch urls on their behalf.
    def initialize(u, p)
      initialize__http_urlconnection(u, p, Handler.new)
    end
    
    typesig { [URL, Proxy, Handler] }
    def initialize(u, p, handler)
      @str_output_stream = nil
      @http = nil
      @handler = nil
      @inst_proxy = nil
      @cookie_handler = nil
      @cache_handler = nil
      @cached_response = nil
      @cached_headers = nil
      @cached_input_stream = nil
      @ps = nil
      @error_stream = nil
      @set_user_cookies = false
      @user_cookies = nil
      @requests = nil
      @domain = nil
      @digestparams = nil
      @current_proxy_credentials = nil
      @current_server_credentials = nil
      @need_to_check = false
      @doing_ntlm2nd_stage = false
      @doing_ntlmp2nd_stage = false
      @try_transparent_ntlmserver = false
      @try_transparent_ntlmproxy = false
      @auth_obj = nil
      @is_user_server_auth = false
      @is_user_proxy_auth = false
      @pi = nil
      @responses = nil
      @input_stream = nil
      @poster = nil
      @set_requests = false
      @failed_once = false
      @remembered_exception = nil
      @reuse_client = nil
      @connect_timeout = 0
      @read_timeout = 0
      @cdata = nil
      super(u)
      @ps = nil
      @error_stream = nil
      @set_user_cookies = true
      @user_cookies = nil
      @current_proxy_credentials = nil
      @current_server_credentials = nil
      @need_to_check = true
      @doing_ntlm2nd_stage = false
      @doing_ntlmp2nd_stage = false
      @try_transparent_ntlmserver = NTLMAuthentication.supports_transparent_auth
      @try_transparent_ntlmproxy = NTLMAuthentication.supports_transparent_auth
      @input_stream = nil
      @poster = nil
      @set_requests = false
      @failed_once = false
      @remembered_exception = nil
      @reuse_client = nil
      @connect_timeout = -1
      @read_timeout = -1
      @cdata = Array.typed(::Java::Byte).new(128) { 0 }
      @requests = MessageHeader.new
      @responses = MessageHeader.new
      @handler = handler
      @inst_proxy = p
      @cookie_handler = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members HttpURLConnection
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return CookieHandler.get_default
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @cache_handler = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members HttpURLConnection
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return ResponseCache.get_default
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    class_module.module_eval {
      typesig { [HttpAuthenticator] }
      # @deprecated.  Use java.net.Authenticator.setDefault() instead.
      def set_default_authenticator(a)
        self.attr_default_auth = a
      end
      
      typesig { [URLConnection] }
      # opens a stream allowing redirects only to the same host.
      def open_connection_check_redirects(c)
        redir = false
        redirects = 0
        in_ = nil
        begin
          if (c.is_a?(HttpURLConnection))
            (c).set_instance_follow_redirects(false)
          end
          # We want to open the input stream before
          # getting headers, because getHeaderField()
          # et al swallow IOExceptions.
          in_ = c.get_input_stream
          redir = false
          if (c.is_a?(HttpURLConnection))
            http = c
            stat = http.get_response_code
            if (stat >= 300 && stat <= 307 && !(stat).equal?(306) && !(stat).equal?(HttpURLConnection::HTTP_NOT_MODIFIED))
              base = http.get_url
              loc = http.get_header_field("Location")
              target = nil
              if (!(loc).nil?)
                target = URL.new(base, loc)
              end
              http.disconnect
              if ((target).nil? || !(base.get_protocol == target.get_protocol) || !(base.get_port).equal?(target.get_port) || !hosts_equal(base, target) || redirects >= 5)
                raise SecurityException.new("illegal URL redirect")
              end
              redir = true
              c = target.open_connection
              redirects += 1
            end
          end
        end while (redir)
        return in_
      end
      
      typesig { [URL, URL] }
      # Same as java.net.URL.hostsEqual
      def hosts_equal(u1, u2)
        h1 = u1.get_host
        h2 = u2.get_host
        if ((h1).nil?)
          return (h2).nil?
        else
          if ((h2).nil?)
            return false
          else
            if (h1.equals_ignore_case(h2))
              return true
            end
          end
        end
        # Have to resolve addresses before comparing, otherwise
        # names like tachyon and tachyon.eng would compare different
        result = Array.typed(::Java::Boolean).new([false])
        Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members HttpURLConnection
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              a1 = InetAddress.get_by_name(h1)
              a2 = InetAddress.get_by_name(h2)
              result[0] = (a1 == a2)
            rescue UnknownHostException => e
            rescue SecurityException => e
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return result[0]
      end
    }
    
    typesig { [] }
    # overridden in HTTPS subclass
    def connect
      plain_connect
    end
    
    typesig { [] }
    def check_reuse_connection
      if (self.attr_connected)
        return true
      end
      if (!(@reuse_client).nil?)
        @http = @reuse_client
        @http.set_read_timeout(get_read_timeout)
        @http.attr_reuse = false
        @reuse_client = nil
        self.attr_connected = true
        return true
      end
      return false
    end
    
    typesig { [] }
    def plain_connect
      if (self.attr_connected)
        return
      end
      # try to see if request can be served from local cache
      if (!(@cache_handler).nil? && get_use_caches)
        begin
          uri = ParseUtil.to_uri(self.attr_url)
          if (!(uri).nil?)
            @cached_response = @cache_handler.get(uri, get_request_method, @requests.get_headers(EXCLUDE_HEADERS))
            if ("https".equals_ignore_case(uri.get_scheme) && !(@cached_response.is_a?(SecureCacheResponse)))
              @cached_response = nil
            end
            if (!(@cached_response).nil?)
              @cached_headers = map_to_message_header(@cached_response.get_headers)
              @cached_input_stream = @cached_response.get_body
            end
          end
        rescue IOException => ioex
          # ignore and commence normal connection
        end
        if (!(@cached_headers).nil? && !(@cached_input_stream).nil?)
          self.attr_connected = true
          return
        else
          @cached_response = nil
        end
      end
      begin
        # Try to open connections using the following scheme,
        # return on the first one that's successful:
        # 1) if (instProxy != null)
        # connect to instProxy; raise exception if failed
        # 2) else use system default ProxySelector
        # 3) is 2) fails, make direct connection
        if ((@inst_proxy).nil?)
          sel = Java::Security::AccessController.do_privileged(# no instance Proxy is set
          # 
          # Do we have to use a proxy?
          Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members HttpURLConnection
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return ProxySelector.get_default
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          p = nil
          if (!(sel).nil?)
            uri = Sun::Net::Www::ParseUtil.to_uri(self.attr_url)
            it = sel.select(uri).iterator
            while (it.has_next)
              p = it.next
              begin
                if (!@failed_once)
                  @http = get_new_http_client(self.attr_url, p, @connect_timeout)
                  @http.set_read_timeout(@read_timeout)
                else
                  # make sure to construct new connection if first
                  # attempt failed
                  @http = get_new_http_client(self.attr_url, p, @connect_timeout, false)
                  @http.set_read_timeout(@read_timeout)
                end
                break
              rescue IOException => ioex
                if (!(p).equal?(Proxy::NO_PROXY))
                  sel.connect_failed(uri, p.address, ioex)
                  if (!it.has_next)
                    # fallback to direct connection
                    @http = get_new_http_client(self.attr_url, nil, @connect_timeout, false)
                    @http.set_read_timeout(@read_timeout)
                    break
                  end
                else
                  raise ioex
                end
                next
              end
            end
          else
            # No proxy selector, create http client with no proxy
            if (!@failed_once)
              @http = get_new_http_client(self.attr_url, nil, @connect_timeout)
              @http.set_read_timeout(@read_timeout)
            else
              # make sure to construct new connection if first
              # attempt failed
              @http = get_new_http_client(self.attr_url, nil, @connect_timeout, false)
              @http.set_read_timeout(@read_timeout)
            end
          end
        else
          if (!@failed_once)
            @http = get_new_http_client(self.attr_url, @inst_proxy, @connect_timeout)
            @http.set_read_timeout(@read_timeout)
          else
            # make sure to construct new connection if first
            # attempt failed
            @http = get_new_http_client(self.attr_url, @inst_proxy, @connect_timeout, false)
            @http.set_read_timeout(@read_timeout)
          end
        end
        @ps = @http.get_output_stream
      rescue IOException => e
        raise e
      end
      # constructor to HTTP client calls openserver
      self.attr_connected = true
    end
    
    typesig { [URL, Proxy, ::Java::Int] }
    # subclass HttpsClient will overwrite & return an instance of HttpsClient
    def get_new_http_client(url, p, connect_timeout)
      return HttpClient._new(url, p, connect_timeout)
    end
    
    typesig { [URL, Proxy, ::Java::Int, ::Java::Boolean] }
    # subclass HttpsClient will overwrite & return an instance of HttpsClient
    def get_new_http_client(url, p, connect_timeout, use_cache)
      return HttpClient._new(url, p, connect_timeout, use_cache)
    end
    
    typesig { [] }
    # Allowable input/output sequences:
    # [interpreted as POST/PUT]
    # - get output, [write output,] get input, [read input]
    # - get output, [write output]
    # [interpreted as GET]
    # - get input, [read input]
    # Disallowed:
    # - get input, [read input,] get output, [write output]
    def get_output_stream
      synchronized(self) do
        begin
          if (!self.attr_do_output)
            raise ProtocolException.new("cannot write to a URLConnection" + " if doOutput=false - call setDoOutput(true)")
          end
          if ((self.attr_method == "GET"))
            self.attr_method = "POST" # Backward compatibility
          end
          if (!("POST" == self.attr_method) && !("PUT" == self.attr_method) && ("http" == self.attr_url.get_protocol))
            raise ProtocolException.new("HTTP method " + (self.attr_method).to_s + " doesn't support output")
          end
          # if there's already an input stream open, throw an exception
          if (!(@input_stream).nil?)
            raise ProtocolException.new("Cannot write output after reading input.")
          end
          if (!check_reuse_connection)
            connect
          end
          # REMIND: This exists to fix the HttpsURLConnection subclass.
          # Hotjava needs to run on JDK1.1FCS.  Do proper fix in subclass
          # for 1.2 and remove this.
          if (streaming && (@str_output_stream).nil?)
            write_requests
          end
          @ps = @http.get_output_stream
          if (streaming)
            if ((@str_output_stream).nil?)
              if (!(self.attr_fixed_content_length).equal?(-1))
                @str_output_stream = StreamingOutputStream.new_local(self, @ps, self.attr_fixed_content_length)
              else
                if (!(self.attr_chunk_length).equal?(-1))
                  @str_output_stream = StreamingOutputStream.new_local(self, ChunkedOutputStream.new(@ps, self.attr_chunk_length), -1)
                end
              end
            end
            return @str_output_stream
          else
            if ((@poster).nil?)
              @poster = PosterOutputStream.new
            end
            return @poster
          end
        rescue RuntimeException => e
          disconnect_internal
          raise e
        rescue IOException => e
          disconnect_internal
          raise e
        end
      end
    end
    
    typesig { [] }
    def streaming
      return (!(self.attr_fixed_content_length).equal?(-1)) || (!(self.attr_chunk_length).equal?(-1))
    end
    
    typesig { [] }
    # get applicable cookies based on the uri and request headers
    # add them to the existing request headers
    def set_cookie_header
      if (!(@cookie_handler).nil?)
        # we only want to capture the user defined Cookies once, as
        # they cannot be changed by user code after we are connected,
        # only internally.
        if (@set_user_cookies)
          k = @requests.get_key("Cookie")
          if (!(k).equal?(-1))
            @user_cookies = (@requests.get_value(k)).to_s
          end
          @set_user_cookies = false
        end
        # remove old Cookie header before setting new one.
        @requests.remove("Cookie")
        uri = ParseUtil.to_uri(self.attr_url)
        if (!(uri).nil?)
          cookies = @cookie_handler.get(uri, @requests.get_headers(EXCLUDE_HEADERS))
          if (!cookies.is_empty)
            s = cookies.entry_set
            k_itr = s.iterator
            while (k_itr.has_next)
              entry = k_itr.next
              key = entry.get_key
              # ignore all entries that don't have "Cookie"
              # or "Cookie2" as keys
              if (!"Cookie".equals_ignore_case(key) && !"Cookie2".equals_ignore_case(key))
                next
              end
              l = entry.get_value
              if (!(l).nil? && !l.is_empty)
                v_itr = l.iterator
                cookie_value = StringBuilder.new
                while (v_itr.has_next)
                  value = v_itr.next
                  cookie_value.append(value).append(Character.new(?;.ord))
                end
                # strip off the ending ;-sign
                begin
                  @requests.add(key, cookie_value.substring(0, cookie_value.length - 1))
                rescue StringIndexOutOfBoundsException => ignored
                  # no-op
                end
              end
            end
          end
        end
        if (!(@user_cookies).nil?)
          k = 0
          if (!((k = @requests.get_key("Cookie"))).equal?(-1))
            @requests.set("Cookie", (@requests.get_value(k)).to_s + ";" + @user_cookies)
          else
            @requests.set("Cookie", @user_cookies)
          end
        end
      end # end of getting cookies
    end
    
    typesig { [] }
    def get_input_stream
      synchronized(self) do
        if (!self.attr_do_input)
          raise ProtocolException.new("Cannot read from URLConnection" + " if doInput=false (call setDoInput(true))")
        end
        if (!(@remembered_exception).nil?)
          if (@remembered_exception.is_a?(RuntimeException))
            raise RuntimeException.new(@remembered_exception)
          else
            raise get_chained_exception(@remembered_exception)
          end
        end
        if (!(@input_stream).nil?)
          return @input_stream
        end
        if (streaming)
          if ((@str_output_stream).nil?)
            get_output_stream
          end
          # make sure stream is closed
          @str_output_stream.close
          if (!@str_output_stream.written_ok)
            raise IOException.new("Incomplete output stream")
          end
        end
        redirects = 0
        resp_code = 0
        cl = -1
        server_authentication = nil
        proxy_authentication = nil
        srv_hdr = nil
        # If the user has set either of these headers then do not remove them
        @is_user_server_auth = !(@requests.get_key("Authorization")).equal?(-1)
        @is_user_proxy_auth = !(@requests.get_key("Proxy-Authorization")).equal?(-1)
        begin
          begin
            if (!check_reuse_connection)
              connect
            end
            if (!(@cached_input_stream).nil?)
              return @cached_input_stream
            end
            # Check if URL should be metered
            metered_input = ProgressMonitor.get_default.should_meter_input(self.attr_url, self.attr_method)
            if (metered_input)
              @pi = ProgressSource.new(self.attr_url, self.attr_method)
              @pi.begin_tracking
            end
            # REMIND: This exists to fix the HttpsURLConnection subclass.
            # Hotjava needs to run on JDK1.1FCS.  Do proper fix once a
            # proper solution for SSL can be found.
            @ps = @http.get_output_stream
            if (!streaming)
              write_requests
            end
            @http.parse_http(@responses, @pi, self)
            if (self.attr_logger.is_loggable(Level::FINEST))
              self.attr_logger.fine(@responses.to_s)
            end
            @input_stream = @http.get_input_stream
            resp_code = get_response_code
            if ((resp_code).equal?(HTTP_PROXY_AUTH))
              if (streaming)
                disconnect_internal
                raise HttpRetryException.new(RETRY_MSG1, HTTP_PROXY_AUTH)
              end
              # changes: add a 3rd parameter to the constructor of
              # AuthenticationHeader, so that NegotiateAuthentication.
              # isSupported can be tested.
              # The other 2 appearances of "new AuthenticationHeader" is
              # altered in similar ways.
              authhdr = AuthenticationHeader.new("Proxy-Authenticate", @responses, @http.get_proxy_host_used)
              if (!@doing_ntlmp2nd_stage)
                proxy_authentication = reset_proxy_authentication(proxy_authentication, authhdr)
                if (!(proxy_authentication).nil?)
                  redirects += 1
                  disconnect_internal
                  next
                end
              else
                # in this case, only one header field will be present
                raw = @responses.find_value("Proxy-Authenticate")
                reset
                if (!proxy_authentication.set_headers(self, authhdr.header_parser, raw))
                  disconnect_internal
                  raise IOException.new("Authentication failure")
                end
                if (!(server_authentication).nil? && !(srv_hdr).nil? && !server_authentication.set_headers(self, srv_hdr.header_parser, raw))
                  disconnect_internal
                  raise IOException.new("Authentication failure")
                end
                @auth_obj = nil
                @doing_ntlmp2nd_stage = false
                next
              end
            end
            # cache proxy authentication info
            if (!(proxy_authentication).nil?)
              # cache auth info on success, domain header not relevant.
              proxy_authentication.add_to_cache
            end
            if ((resp_code).equal?(HTTP_UNAUTHORIZED))
              if (streaming)
                disconnect_internal
                raise HttpRetryException.new(RETRY_MSG2, HTTP_UNAUTHORIZED)
              end
              srv_hdr = AuthenticationHeader.new("WWW-Authenticate", @responses, self.attr_url.get_host.to_lower_case)
              raw_ = srv_hdr.raw
              if (!@doing_ntlm2nd_stage)
                if ((!(server_authentication).nil?) && !(server_authentication.is_a?(NTLMAuthentication)))
                  if (server_authentication.is_authorization_stale(raw_))
                    # we can retry with the current credentials
                    disconnect_internal
                    redirects += 1
                    @requests.set(server_authentication.get_header_name, server_authentication.get_header_value(self.attr_url, self.attr_method))
                    @current_server_credentials = server_authentication
                    set_cookie_header
                    next
                  else
                    server_authentication.remove_from_cache
                  end
                end
                server_authentication = get_server_authentication(srv_hdr)
                @current_server_credentials = server_authentication
                if (!(server_authentication).nil?)
                  disconnect_internal
                  redirects += 1 # don't let things loop ad nauseum
                  set_cookie_header
                  next
                end
              else
                reset
                # header not used for ntlm
                if (!server_authentication.set_headers(self, nil, raw_))
                  disconnect_internal
                  raise IOException.new("Authentication failure")
                end
                @doing_ntlm2nd_stage = false
                @auth_obj = nil
                set_cookie_header
                next
              end
            end
            # cache server authentication info
            if (!(server_authentication).nil?)
              # cache auth info on success
              if (!(server_authentication.is_a?(DigestAuthentication)) || ((@domain).nil?))
                if (server_authentication.is_a?(BasicAuthentication))
                  # check if the path is shorter than the existing entry
                  npath = AuthenticationInfo.reduce_path(self.attr_url.get_path)
                  opath = server_authentication.attr_path
                  if (!opath.starts_with(npath) || npath.length >= opath.length)
                    # npath is longer, there must be a common root
                    npath = (BasicAuthentication.get_root_path(opath, npath)).to_s
                  end
                  # remove the entry and create a new one
                  a = server_authentication.clone
                  server_authentication.remove_from_cache
                  a.attr_path = npath
                  server_authentication = a
                end
                server_authentication.add_to_cache
              else
                # what we cache is based on the domain list in the request
                srv = server_authentication
                tok = StringTokenizer.new(@domain, " ")
                realm = srv.attr_realm
                pw = srv.attr_pw
                @digestparams = srv.attr_params
                while (tok.has_more_tokens)
                  path = tok.next_token
                  begin
                    # path could be an abs_path or a complete URI
                    u = URL.new(self.attr_url, path)
                    d = DigestAuthentication.new(false, u, realm, "Digest", pw, @digestparams)
                    d.add_to_cache
                  rescue Exception => e
                  end
                end
              end
            end
            # some flags should be reset to its initialized form so that
            # even after a redirect the necessary checks can still be
            # preformed.
            # serverAuthentication = null;
            @doing_ntlmp2nd_stage = false
            @doing_ntlm2nd_stage = false
            if (!@is_user_server_auth)
              @requests.remove("Authorization")
            end
            if (!@is_user_proxy_auth)
              @requests.remove("Proxy-Authorization")
            end
            if ((resp_code).equal?(HTTP_OK))
              check_response_credentials(false)
            else
              @need_to_check = false
            end
            # a flag need to clean
            @need_to_check = true
            if (follow_redirect)
              # if we should follow a redirect, then the followRedirects()
              # method will disconnect() and re-connect us to the new
              # location
              redirects += 1
              # redirecting HTTP response may have set cookie, so
              # need to re-generate request header
              set_cookie_header
              next
            end
            begin
              cl = JavaInteger.parse_int(@responses.find_value("content-length"))
            rescue Exception => exc
            end
            if ((self.attr_method == "HEAD") || (cl).equal?(0) || (resp_code).equal?(HTTP_NOT_MODIFIED) || (resp_code).equal?(HTTP_NO_CONTENT))
              if (!(@pi).nil?)
                @pi.finish_tracking
                @pi = nil
              end
              @http.finished
              @http = nil
              @input_stream = EmptyInputStream.new
              self.attr_connected = false
            end
            if ((resp_code).equal?(200) || (resp_code).equal?(203) || (resp_code).equal?(206) || (resp_code).equal?(300) || (resp_code).equal?(301) || (resp_code).equal?(410))
              if (!(@cache_handler).nil? && get_use_caches)
                # give cache a chance to save response in cache
                uri = ParseUtil.to_uri(self.attr_url)
                if (!(uri).nil?)
                  uconn = self
                  if ("https".equals_ignore_case(uri.get_scheme))
                    begin
                      # use reflection to get to the public
                      # HttpsURLConnection instance saved in
                      # DelegateHttpsURLConnection
                      uconn = self.get_class.get_field("httpsURLConnection").get(self)
                    rescue IllegalAccessException => iae
                      # ignored; use 'this'
                    rescue NoSuchFieldException => nsfe
                      # ignored; use 'this'
                    end
                  end
                  cache_request = @cache_handler.put(uri, uconn)
                  if (!(cache_request).nil? && !(@http).nil?)
                    @http.set_cache_request(cache_request)
                    @input_stream = HttpInputStream.new_local(self, @input_stream, cache_request)
                  end
                end
              end
            end
            if (!(@input_stream.is_a?(HttpInputStream)))
              @input_stream = HttpInputStream.new_local(self, @input_stream)
            end
            if (resp_code >= 400)
              if ((resp_code).equal?(404) || (resp_code).equal?(410))
                raise FileNotFoundException.new(self.attr_url.to_s)
              else
                raise Java::Io::IOException.new("Server returned HTTP" + " response code: " + (resp_code).to_s + " for URL: " + (self.attr_url.to_s).to_s)
              end
            end
            @poster = nil
            @str_output_stream = nil
            return @input_stream
          end while (redirects < MaxRedirects)
          raise ProtocolException.new("Server redirected too many " + " times (" + (redirects).to_s + ")")
        rescue RuntimeException => e
          disconnect_internal
          @remembered_exception = e
          raise e
        rescue IOException => e
          @remembered_exception = e
          # buffer the error stream if bytes < 4k
          # and it can be buffered within 1 second
          te = @responses.find_value("Transfer-Encoding")
          if (!(@http).nil? && @http.is_keeping_alive && self.attr_enable_esbuffer && (cl > 0 || (!(te).nil? && te.equals_ignore_case("chunked"))))
            @error_stream = ErrorStream.get_error_stream(@input_stream, cl, @http)
          end
          raise e
        ensure
          if ((resp_code).equal?(HTTP_PROXY_AUTH) && !(proxy_authentication).nil?)
            proxy_authentication.end_auth_request
          else
            if ((resp_code).equal?(HTTP_UNAUTHORIZED) && !(server_authentication).nil?)
              server_authentication.end_auth_request
            end
          end
        end
      end
    end
    
    typesig { [IOException] }
    # Creates a chained exception that has the same type as
    # original exception and with the same message. Right now,
    # there is no convenient APIs for doing so.
    def get_chained_exception(remembered_exception)
      begin
        original_exception = remembered_exception
        cls = Array.typed(Class).new(1) { nil }
        cls[0] = String.class
        args = Array.typed(String).new(1) { nil }
        args[0] = original_exception.get_message
        chained_exception = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members HttpURLConnection
          include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            ctr = original_exception.get_class.get_constructor(cls)
            return ctr.new_instance(args)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        chained_exception.init_cause(original_exception)
        return chained_exception
      rescue Exception => ignored
        return remembered_exception
      end
    end
    
    typesig { [] }
    def get_error_stream
      if (self.attr_connected && self.attr_response_code >= 400)
        # Client Error 4xx and Server Error 5xx
        if (!(@error_stream).nil?)
          return @error_stream
        else
          if (!(@input_stream).nil?)
            return @input_stream
          end
        end
      end
      return nil
    end
    
    typesig { [AuthenticationInfo, AuthenticationHeader] }
    # set or reset proxy authentication info in request headers
    # after receiving a 407 error. In the case of NTLM however,
    # receiving a 407 is normal and we just skip the stale check
    # because ntlm does not support this feature.
    def reset_proxy_authentication(proxy_authentication, auth)
      if ((!(proxy_authentication).nil?) && !(proxy_authentication.is_a?(NTLMAuthentication)))
        raw_ = auth.raw
        if (proxy_authentication.is_authorization_stale(raw_))
          # we can retry with the current credentials
          @requests.set(proxy_authentication.get_header_name, proxy_authentication.get_header_value(self.attr_url, self.attr_method))
          @current_proxy_credentials = proxy_authentication
          return proxy_authentication
        else
          proxy_authentication.remove_from_cache
        end
      end
      proxy_authentication = get_http_proxy_authentication(auth)
      @current_proxy_credentials = proxy_authentication
      return proxy_authentication
    end
    
    typesig { [] }
    # establish a tunnel through proxy server
    def do_tunneling
      synchronized(self) do
        retry_tunnel = 0
        status_line = ""
        resp_code = 0
        proxy_authentication = nil
        proxy_host = nil
        proxy_port = -1
        # save current requests so that they can be restored after tunnel is setup.
        saved_requests = @requests
        @requests = MessageHeader.new
        begin
          begin
            if (!check_reuse_connection)
              proxied_connect(self.attr_url, proxy_host, proxy_port, false)
            end
            # send the "CONNECT" request to establish a tunnel
            # through proxy server
            send_connectrequest
            @responses.reset
            # There is no need to track progress in HTTP Tunneling,
            # so ProgressSource is null.
            @http.parse_http(@responses, nil, self)
            status_line = (@responses.get_value(0)).to_s
            st = StringTokenizer.new(status_line)
            st.next_token
            resp_code = JavaInteger.parse_int(st.next_token.trim)
            if ((resp_code).equal?(HTTP_PROXY_AUTH))
              authhdr = AuthenticationHeader.new("Proxy-Authenticate", @responses, @http.get_proxy_host_used)
              if (!@doing_ntlmp2nd_stage)
                proxy_authentication = reset_proxy_authentication(proxy_authentication, authhdr)
                if (!(proxy_authentication).nil?)
                  proxy_host = (@http.get_proxy_host_used).to_s
                  proxy_port = @http.get_proxy_port_used
                  disconnect_internal
                  retry_tunnel += 1
                  next
                end
              else
                raw_ = @responses.find_value("Proxy-Authenticate")
                reset
                if (!proxy_authentication.set_headers(self, authhdr.header_parser, raw_))
                  proxy_host = (@http.get_proxy_host_used).to_s
                  proxy_port = @http.get_proxy_port_used
                  disconnect_internal
                  raise IOException.new("Authentication failure")
                end
                @auth_obj = nil
                @doing_ntlmp2nd_stage = false
                next
              end
            end
            # cache proxy authentication info
            if (!(proxy_authentication).nil?)
              # cache auth info on success, domain header not relevant.
              proxy_authentication.add_to_cache
            end
            if ((resp_code).equal?(HTTP_OK))
              break
            end
            # we don't know how to deal with other response code
            # so disconnect and report error
            disconnect_internal
            break
          end while (retry_tunnel < MaxRedirects)
          if (retry_tunnel >= MaxRedirects || (!(resp_code).equal?(HTTP_OK)))
            raise IOException.new("Unable to tunnel through proxy." + " Proxy returns \"" + status_line + "\"")
          end
        ensure
          if ((resp_code).equal?(HTTP_PROXY_AUTH) && !(proxy_authentication).nil?)
            proxy_authentication.end_auth_request
          end
        end
        # restore original request headers
        @requests = saved_requests
        # reset responses
        @responses.reset
      end
    end
    
    typesig { [] }
    # send a CONNECT request for establishing a tunnel to proxy server
    def send_connectrequest
      port = self.attr_url.get_port
      # setRequests == true indicates the std. request headers
      # have been set in (previous) requests.
      # so the first one must be the http method (GET, etc.).
      # we need to set it to CONNECT soon, remove this one first.
      # otherwise, there may have 2 http methods in headers
      if (@set_requests)
        @requests.set(0, nil, nil)
      end
      @requests.prepend("CONNECT " + (self.attr_url.get_host).to_s + ":" + ((!(port).equal?(-1) ? port : self.attr_url.get_default_port)).to_s + " " + HttpVersion, nil)
      @requests.set_if_not_set("User-Agent", UserAgent)
      host = self.attr_url.get_host
      if (!(port).equal?(-1) && !(port).equal?(self.attr_url.get_default_port))
        host += ":" + (String.value_of(port)).to_s
      end
      @requests.set_if_not_set("Host", host)
      # Not really necessary for a tunnel, but can't hurt
      @requests.set_if_not_set("Accept", AcceptString)
      set_preemptive_proxy_authentication(@requests)
      @http.write_requests(@requests, nil)
      # remove CONNECT header
      @requests.set(0, nil, nil)
    end
    
    typesig { [MessageHeader] }
    # Sets pre-emptive proxy authentication in header
    def set_preemptive_proxy_authentication(requests)
      pauth = AuthenticationInfo.get_proxy_auth(@http.get_proxy_host_used, @http.get_proxy_port_used)
      if (!(pauth).nil? && pauth.supports_preemptive_authorization)
        # Sets "Proxy-authorization"
        requests.set(pauth.get_header_name, pauth.get_header_value(self.attr_url, self.attr_method))
        @current_proxy_credentials = pauth
      end
    end
    
    typesig { [AuthenticationHeader] }
    # Gets the authentication for an HTTP proxy, and applies it to
    # the connection.
    def get_http_proxy_authentication(authhdr)
      # get authorization from authenticator
      ret = nil
      raw_ = authhdr.raw
      host = @http.get_proxy_host_used
      port = @http.get_proxy_port_used
      if (!(host).nil? && authhdr.is_present)
        p = authhdr.header_parser
        realm = p.find_value("realm")
        scheme_ = authhdr.scheme
        scheme_id = 0
        if ("basic".equals_ignore_case(scheme_))
          scheme_id = BasicAuthentication::BASIC_AUTH
        else
          if ("digest".equals_ignore_case(scheme_))
            scheme_id = DigestAuthentication::DIGEST_AUTH
          else
            if ("ntlm".equals_ignore_case(scheme_))
              scheme_id = NTLMAuthentication::NTLM_AUTH
              @doing_ntlmp2nd_stage = true
            else
              if ("Kerberos".equals_ignore_case(scheme_))
                scheme_id = NegotiateAuthentication::KERBEROS_AUTH
                @doing_ntlmp2nd_stage = true
              else
                if ("Negotiate".equals_ignore_case(scheme_))
                  scheme_id = NegotiateAuthentication::NEGOTIATE_AUTH
                  @doing_ntlmp2nd_stage = true
                else
                  scheme_id = 0
                end
              end
            end
          end
        end
        if ((realm).nil?)
          realm = ""
        end
        ret = AuthenticationInfo.get_proxy_auth(host, port, realm, scheme_id)
        if ((ret).nil?)
          if ((scheme_id).equal?(BasicAuthentication::BASIC_AUTH))
            addr = nil
            begin
              final_host = host
              addr = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members HttpURLConnection
                include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  return InetAddress.get_by_name(final_host)
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            rescue Java::Security::PrivilegedActionException => ignored
              # User will have an unknown host.
            end
            a = privileged_request_password_authentication(host, addr, port, "http", realm, scheme_, self.attr_url, RequestorType::PROXY)
            if (!(a).nil?)
              ret = BasicAuthentication.new(true, host, port, realm, a)
            end
          else
            if ((scheme_id).equal?(DigestAuthentication::DIGEST_AUTH))
              a = privileged_request_password_authentication(host, nil, port, self.attr_url.get_protocol, realm, scheme_, self.attr_url, RequestorType::PROXY)
              if (!(a).nil?)
                params = DigestAuthentication::Parameters.new
                ret = DigestAuthentication.new(true, host, port, realm, scheme_, a, params)
              end
            else
              if ((scheme_id).equal?(NTLMAuthentication::NTLM_AUTH))
                a = nil
                if (!@try_transparent_ntlmproxy)
                  a = privileged_request_password_authentication(host, nil, port, self.attr_url.get_protocol, "", scheme_, self.attr_url, RequestorType::PROXY)
                end
                # If we are not trying transparent authentication then
                # we need to have a PasswordAuthentication instance. For
                # transparent authentication (Windows only) the username
                # and password will be picked up from the current logged
                # on users credentials.
                if (@try_transparent_ntlmproxy || (!@try_transparent_ntlmproxy && !(a).nil?))
                  ret = NTLMAuthentication.new(true, host, port, a)
                end
                @try_transparent_ntlmproxy = false
              else
                if ((scheme_id).equal?(NegotiateAuthentication::NEGOTIATE_AUTH))
                  ret = NegotiateAuthentication.new(true, host, port, nil, "Negotiate")
                else
                  if ((scheme_id).equal?(NegotiateAuthentication::KERBEROS_AUTH))
                    ret = NegotiateAuthentication.new(true, host, port, nil, "Kerberos")
                  end
                end
              end
            end
          end
        end
        # For backwards compatibility, we also try defaultAuth
        # REMIND:  Get rid of this for JDK2.0.
        if ((ret).nil? && !(self.attr_default_auth).nil? && self.attr_default_auth.scheme_supported(scheme_))
          begin
            u = URL.new("http", host, port, "/")
            a = self.attr_default_auth.auth_string(u, scheme_, realm)
            if (!(a).nil?)
              ret = BasicAuthentication.new(true, host, port, realm, a)
              # not in cache by default - cache on success
            end
          rescue Java::Net::MalformedURLException => ignored
          end
        end
        if (!(ret).nil?)
          if (!ret.set_headers(self, p, raw_))
            ret = nil
          end
        end
      end
      return ret
    end
    
    typesig { [AuthenticationHeader] }
    # Gets the authentication for an HTTP server, and applies it to
    # the connection.
    # @param authHdr the AuthenticationHeader which tells what auth scheme is
    # prefered.
    def get_server_authentication(authhdr)
      # get authorization from authenticator
      ret = nil
      raw_ = authhdr.raw
      # When we get an NTLM auth from cache, don't set any special headers
      if (authhdr.is_present)
        p = authhdr.header_parser
        realm = p.find_value("realm")
        scheme_ = authhdr.scheme
        scheme_id = 0
        if ("basic".equals_ignore_case(scheme_))
          scheme_id = BasicAuthentication::BASIC_AUTH
        else
          if ("digest".equals_ignore_case(scheme_))
            scheme_id = DigestAuthentication::DIGEST_AUTH
          else
            if ("ntlm".equals_ignore_case(scheme_))
              scheme_id = NTLMAuthentication::NTLM_AUTH
              @doing_ntlm2nd_stage = true
            else
              if ("Kerberos".equals_ignore_case(scheme_))
                scheme_id = NegotiateAuthentication::KERBEROS_AUTH
                @doing_ntlm2nd_stage = true
              else
                if ("Negotiate".equals_ignore_case(scheme_))
                  scheme_id = NegotiateAuthentication::NEGOTIATE_AUTH
                  @doing_ntlm2nd_stage = true
                else
                  scheme_id = 0
                end
              end
            end
          end
        end
        @domain = (p.find_value("domain")).to_s
        if ((realm).nil?)
          realm = ""
        end
        ret = AuthenticationInfo.get_server_auth(self.attr_url, realm, scheme_id)
        addr = nil
        if ((ret).nil?)
          begin
            addr = InetAddress.get_by_name(self.attr_url.get_host)
          rescue Java::Net::UnknownHostException => ignored
            # User will have addr = null
          end
        end
        # replacing -1 with default port for a protocol
        port = self.attr_url.get_port
        if ((port).equal?(-1))
          port = self.attr_url.get_default_port
        end
        if ((ret).nil?)
          if ((scheme_id).equal?(NegotiateAuthentication::KERBEROS_AUTH))
            url1 = nil
            begin
              url1 = URL.new(self.attr_url, "/")
              # truncate the path
            rescue Exception => e
              url1 = self.attr_url
            end
            ret = NegotiateAuthentication.new(false, url1, nil, "Kerberos")
          end
          if ((scheme_id).equal?(NegotiateAuthentication::NEGOTIATE_AUTH))
            url1 = nil
            begin
              url1 = URL.new(self.attr_url, "/")
              # truncate the path
            rescue Exception => e
              url1 = self.attr_url
            end
            ret = NegotiateAuthentication.new(false, url1, nil, "Negotiate")
          end
          if ((scheme_id).equal?(BasicAuthentication::BASIC_AUTH))
            a = privileged_request_password_authentication(self.attr_url.get_host, addr, port, self.attr_url.get_protocol, realm, scheme_, self.attr_url, RequestorType::SERVER)
            if (!(a).nil?)
              ret = BasicAuthentication.new(false, self.attr_url, realm, a)
            end
          end
          if ((scheme_id).equal?(DigestAuthentication::DIGEST_AUTH))
            a = privileged_request_password_authentication(self.attr_url.get_host, addr, port, self.attr_url.get_protocol, realm, scheme_, self.attr_url, RequestorType::SERVER)
            if (!(a).nil?)
              @digestparams = DigestAuthentication::Parameters.new
              ret = DigestAuthentication.new(false, self.attr_url, realm, scheme_, a, @digestparams)
            end
          end
          if ((scheme_id).equal?(NTLMAuthentication::NTLM_AUTH))
            url1 = nil
            begin
              url1 = URL.new(self.attr_url, "/")
              # truncate the path
            rescue Exception => e
              url1 = self.attr_url
            end
            a = nil
            if (!@try_transparent_ntlmserver)
              a = privileged_request_password_authentication(self.attr_url.get_host, addr, port, self.attr_url.get_protocol, "", scheme_, self.attr_url, RequestorType::SERVER)
            end
            # If we are not trying transparent authentication then
            # we need to have a PasswordAuthentication instance. For
            # transparent authentication (Windows only) the username
            # and password will be picked up from the current logged
            # on users credentials.
            if (@try_transparent_ntlmserver || (!@try_transparent_ntlmserver && !(a).nil?))
              ret = NTLMAuthentication.new(false, url1, a)
            end
            @try_transparent_ntlmserver = false
          end
        end
        # For backwards compatibility, we also try defaultAuth
        # REMIND:  Get rid of this for JDK2.0.
        if ((ret).nil? && !(self.attr_default_auth).nil? && self.attr_default_auth.scheme_supported(scheme_))
          a = self.attr_default_auth.auth_string(self.attr_url, scheme_, realm)
          if (!(a).nil?)
            ret = BasicAuthentication.new(false, self.attr_url, realm, a)
            # not in cache by default - cache on success
          end
        end
        if (!(ret).nil?)
          if (!ret.set_headers(self, p, raw_))
            ret = nil
          end
        end
      end
      return ret
    end
    
    typesig { [::Java::Boolean] }
    # inclose will be true if called from close(), in which case we
    # force the call to check because this is the last chance to do so.
    # If not in close(), then the authentication info could arrive in a trailer
    # field, which we have not read yet.
    def check_response_credentials(in_close)
      begin
        if (!@need_to_check)
          return
        end
        if (ValidateProxy && !(@current_proxy_credentials).nil?)
          raw_ = @responses.find_value("Proxy-Authentication-Info")
          if (in_close || (!(raw_).nil?))
            @current_proxy_credentials.check_response(raw_, self.attr_method, self.attr_url)
            @current_proxy_credentials = nil
          end
        end
        if (ValidateServer && !(@current_server_credentials).nil?)
          raw_ = @responses.find_value("Authentication-Info")
          if (in_close || (!(raw_).nil?))
            @current_server_credentials.check_response(raw_, self.attr_method, self.attr_url)
            @current_server_credentials = nil
          end
        end
        if (((@current_server_credentials).nil?) && ((@current_proxy_credentials).nil?))
          @need_to_check = false
        end
      rescue IOException => e
        disconnect_internal
        self.attr_connected = false
        raise e
      end
    end
    
    typesig { [] }
    # Tells us whether to follow a redirect.  If so, it
    # closes the connection (break any keep-alive) and
    # resets the url, re-connects, and resets the request
    # property.
    def follow_redirect
      if (!get_instance_follow_redirects)
        return false
      end
      stat = get_response_code
      if (stat < 300 || stat > 307 || (stat).equal?(306) || (stat).equal?(HTTP_NOT_MODIFIED))
        return false
      end
      loc = get_header_field("Location")
      if ((loc).nil?)
        # this should be present - if not, we have no choice
        # but to go forward w/ the response we got
        return false
      end
      loc_url = nil
      begin
        loc_url = URL.new(loc)
        if (!self.attr_url.get_protocol.equals_ignore_case(loc_url.get_protocol))
          return false
        end
      rescue MalformedURLException => mue
        # treat loc as a relative URI to conform to popular browsers
        loc_url = URL.new(self.attr_url, loc)
      end
      disconnect_internal
      if (streaming)
        raise HttpRetryException.new(RETRY_MSG3, stat, loc)
      end
      # clear out old response headers!!!!
      @responses = MessageHeader.new
      if ((stat).equal?(HTTP_USE_PROXY))
        # This means we must re-request the resource through the
        # proxy denoted in the "Location:" field of the response.
        # Judging by the spec, the string in the Location header
        # _should_ denote a URL - let's hope for "http://my.proxy.org"
        # Make a new HttpClient to the proxy, using HttpClient's
        # Instance-specific proxy fields, but note we're still fetching
        # the same URL.
        proxy_host = loc_url.get_host
        proxy_port = loc_url.get_port
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_connect(proxy_host, proxy_port)
        end
        set_proxied_client(self.attr_url, proxy_host, proxy_port)
        @requests.set(0, (self.attr_method).to_s + " " + (@http.get_urlfile).to_s + " " + HttpVersion, nil)
        self.attr_connected = true
      else
        # maintain previous headers, just change the name
        # of the file we're getting
        self.attr_url = loc_url
        if ((self.attr_method == "POST") && !Boolean.get_boolean("http.strictPostRedirect") && (!(stat).equal?(307)))
          # The HTTP/1.1 spec says that a redirect from a POST
          # *should not* be immediately turned into a GET, and
          # that some HTTP/1.0 clients incorrectly did this.
          # Correct behavior redirects a POST to another POST.
          # Unfortunately, since most browsers have this incorrect
          # behavior, the web works this way now.  Typical usage
          # seems to be:
          # POST a login code or passwd to a web page.
          # after validation, the server redirects to another
          # (welcome) page
          # The second request is (erroneously) expected to be GET
          # 
          # We will do the incorrect thing (POST-->GET) by default.
          # We will provide the capability to do the "right" thing
          # (POST-->POST) by a system property, "http.strictPostRedirect=true"
          @requests = MessageHeader.new
          @set_requests = false
          set_request_method("GET")
          @poster = nil
          if (!check_reuse_connection)
            connect
          end
        else
          if (!check_reuse_connection)
            connect
          end
          # Even after a connect() call, http variable still can be
          # null, if a ResponseCache has been installed and it returns
          # a non-null CacheResponse instance. So check nullity before using it.
          # 
          # And further, if http is null, there's no need to do anything
          # about request headers because successive http session will use
          # cachedInputStream/cachedHeaders anyway, which is returned by
          # CacheResponse.
          if (!(@http).nil?)
            @requests.set(0, (self.attr_method).to_s + " " + (@http.get_urlfile).to_s + " " + HttpVersion, nil)
            port = self.attr_url.get_port
            host = self.attr_url.get_host
            if (!(port).equal?(-1) && !(port).equal?(self.attr_url.get_default_port))
              host += ":" + (String.value_of(port)).to_s
            end
            @requests.set("Host", host)
          end
        end
      end
      return true
    end
    
    # dummy byte buffer for reading off socket prior to closing
    attr_accessor :cdata
    alias_method :attr_cdata, :cdata
    undef_method :cdata
    alias_method :attr_cdata=, :cdata=
    undef_method :cdata=
    
    typesig { [] }
    # Reset (without disconnecting the TCP conn) in order to do another transaction with this instance
    def reset
      @http.attr_reuse = true
      # must save before calling close
      @reuse_client = @http
      is = @http.get_input_stream
      if (!(self.attr_method == "HEAD"))
        begin
          # we want to read the rest of the response without using the
          # hurry mechanism, because that would close the connection
          # if everything is not available immediately
          if ((is.is_a?(ChunkedInputStream)) || (is.is_a?(MeteredStream)))
            # reading until eof will not block
            while (is.read(@cdata) > 0)
            end
          else
            # raw stream, which will block on read, so only read
            # the expected number of bytes, probably 0
            cl = 0
            n = 0
            begin
              cl = JavaInteger.parse_int(@responses.find_value("Content-Length"))
            rescue Exception => e
            end
            i = 0
            while i < cl
              if (((n = is.read(@cdata))).equal?(-1))
                break
              else
                i += n
              end
            end
          end
        rescue IOException => e
          @http.attr_reuse = false
          @reuse_client = nil
          disconnect_internal
          return
        end
        begin
          if (is.is_a?(MeteredStream))
            is.close
          end
        rescue IOException => e
        end
      end
      self.attr_response_code = -1
      @responses = MessageHeader.new
      self.attr_connected = false
    end
    
    typesig { [] }
    # Disconnect from the server (for internal use)
    def disconnect_internal
      self.attr_response_code = -1
      if (!(@pi).nil?)
        @pi.finish_tracking
        @pi = nil
      end
      if (!(@http).nil?)
        @http.close_server
        @http = nil
        self.attr_connected = false
      end
    end
    
    typesig { [] }
    # Disconnect from the server (public API)
    def disconnect
      self.attr_response_code = -1
      if (!(@pi).nil?)
        @pi.finish_tracking
        @pi = nil
      end
      if (!(@http).nil?)
        # If we have an input stream this means we received a response
        # from the server. That stream may have been read to EOF and
        # dependening on the stream type may already be closed or the
        # the http client may be returned to the keep-alive cache.
        # If the http client has been returned to the keep-alive cache
        # it may be closed (idle timeout) or may be allocated to
        # another request.
        # 
        # In other to avoid timing issues we close the input stream
        # which will either close the underlying connection or return
        # the client to the cache. If there's a possibility that the
        # client has been returned to the cache (ie: stream is a keep
        # alive stream or a chunked input stream) then we remove an
        # idle connection to the server. Note that this approach
        # can be considered an approximation in that we may close a
        # different idle connection to that used by the request.
        # Additionally it's possible that we close two connections
        # - the first becuase it wasn't an EOF (and couldn't be
        # hurried) - the second, another idle connection to the
        # same server. The is okay because "disconnect" is an
        # indication that the application doesn't intend to access
        # this http server for a while.
        if (!(@input_stream).nil?)
          hc = @http
          # un-synchronized
          ka = hc.is_keeping_alive
          begin
            @input_stream.close
          rescue IOException => ioe
          end
          # if the connection is persistent it may have been closed
          # or returned to the keep-alive cache. If it's been returned
          # to the keep-alive cache then we would like to close it
          # but it may have been allocated
          if (ka)
            hc.close_idle_connection
          end
        else
          # We are deliberatly being disconnected so HttpClient
          # should not try to resend the request no matter what stage
          # of the connection we are in.
          @http.set_do_not_retry(true)
          @http.close_server
        end
        # poster = null;
        @http = nil
        self.attr_connected = false
      end
      @cached_input_stream = nil
      if (!(@cached_headers).nil?)
        @cached_headers.reset
      end
    end
    
    typesig { [] }
    def using_proxy
      if (!(@http).nil?)
        return (!(@http.get_proxy_host_used).nil?)
      end
      return false
    end
    
    typesig { [String] }
    # Gets a header field by name. Returns null if not known.
    # @param name the name of the header field
    def get_header_field(name)
      begin
        get_input_stream
      rescue IOException => e
      end
      if (!(@cached_headers).nil?)
        return @cached_headers.find_value(name)
      end
      return @responses.find_value(name)
    end
    
    typesig { [] }
    # Returns an unmodifiable Map of the header fields.
    # The Map keys are Strings that represent the
    # response-header field names. Each Map value is an
    # unmodifiable List of Strings that represents
    # the corresponding field values.
    # 
    # @return a Map of header fields
    # @since 1.4
    def get_header_fields
      begin
        get_input_stream
      rescue IOException => e
      end
      if (!(@cached_headers).nil?)
        return @cached_headers.get_headers
      end
      return @responses.get_headers
    end
    
    typesig { [::Java::Int] }
    # Gets a header field by index. Returns null if not known.
    # @param n the index of the header field
    def get_header_field(n)
      begin
        get_input_stream
      rescue IOException => e
      end
      if (!(@cached_headers).nil?)
        return @cached_headers.get_value(n)
      end
      return @responses.get_value(n)
    end
    
    typesig { [::Java::Int] }
    # Gets a header field by index. Returns null if not known.
    # @param n the index of the header field
    def get_header_field_key(n)
      begin
        get_input_stream
      rescue IOException => e
      end
      if (!(@cached_headers).nil?)
        return @cached_headers.get_key(n)
      end
      return @responses.get_key(n)
    end
    
    typesig { [String, String] }
    # Sets request property. If a property with the key already
    # exists, overwrite its value with the new value.
    # @param value the value to be set
    def set_request_property(key, value)
      if (self.attr_connected)
        raise IllegalStateException.new("Already connected")
      end
      if ((key).nil?)
        raise NullPointerException.new("key is null")
      end
      check_message_header(key, value)
      @requests.set(key, value)
    end
    
    typesig { [String, String] }
    # Adds a general request property specified by a
    # key-value pair.  This method will not overwrite
    # existing values associated with the same key.
    # 
    # @param   key     the keyword by which the request is known
    # (e.g., "<code>accept</code>").
    # @param   value  the value associated with it.
    # @see #getRequestProperties(java.lang.String)
    # @since 1.4
    def add_request_property(key, value)
      if (self.attr_connected)
        raise IllegalStateException.new("Already connected")
      end
      if ((key).nil?)
        raise NullPointerException.new("key is null")
      end
      check_message_header(key, value)
      @requests.add(key, value)
    end
    
    typesig { [String, String] }
    # Set a property for authentication.  This can safely disregard
    # the connected test.
    def set_authentication_property(key, value)
      check_message_header(key, value)
      @requests.set(key, value)
    end
    
    typesig { [String] }
    def get_request_property(key)
      # don't return headers containing security sensitive information
      if (!(key).nil?)
        i = 0
        while i < EXCLUDE_HEADERS.attr_length
          if (key.equals_ignore_case(EXCLUDE_HEADERS[i]))
            return nil
          end
          i += 1
        end
      end
      return @requests.find_value(key)
    end
    
    typesig { [] }
    # Returns an unmodifiable Map of general request
    # properties for this connection. The Map keys
    # are Strings that represent the request-header
    # field names. Each Map value is a unmodifiable List
    # of Strings that represents the corresponding
    # field values.
    # 
    # @return  a Map of the general request properties for this connection.
    # @throws IllegalStateException if already connected
    # @since 1.4
    def get_request_properties
      if (self.attr_connected)
        raise IllegalStateException.new("Already connected")
      end
      # exclude headers containing security-sensitive info
      return @requests.get_headers(EXCLUDE_HEADERS)
    end
    
    typesig { [::Java::Int] }
    def set_connect_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeouts can't be negative")
      end
      @connect_timeout = timeout
    end
    
    typesig { [] }
    # Returns setting for connect timeout.
    # <p>
    # 0 return implies that the option is disabled
    # (i.e., timeout of infinity).
    # 
    # @return an <code>int</code> that indicates the connect timeout
    # value in milliseconds
    # @see java.net.URLConnection#setConnectTimeout(int)
    # @see java.net.URLConnection#connect()
    # @since 1.5
    def get_connect_timeout
      return (@connect_timeout < 0 ? 0 : @connect_timeout)
    end
    
    typesig { [::Java::Int] }
    # Sets the read timeout to a specified timeout, in
    # milliseconds. A non-zero value specifies the timeout when
    # reading from Input stream when a connection is established to a
    # resource. If the timeout expires before there is data available
    # for read, a java.net.SocketTimeoutException is raised. A
    # timeout of zero is interpreted as an infinite timeout.
    # 
    # <p> Some non-standard implementation of this method ignores the
    # specified timeout. To see the read timeout set, please call
    # getReadTimeout().
    # 
    # @param timeout an <code>int</code> that specifies the timeout
    # value to be used in milliseconds
    # @throws IllegalArgumentException if the timeout parameter is negative
    # 
    # @see java.net.URLConnectiongetReadTimeout()
    # @see java.io.InputStream#read()
    # @since 1.5
    def set_read_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeouts can't be negative")
      end
      @read_timeout = timeout
    end
    
    typesig { [] }
    # Returns setting for read timeout. 0 return implies that the
    # option is disabled (i.e., timeout of infinity).
    # 
    # @return an <code>int</code> that indicates the read timeout
    # value in milliseconds
    # 
    # @see java.net.URLConnection#setReadTimeout(int)
    # @see java.io.InputStream#read()
    # @since 1.5
    def get_read_timeout
      return @read_timeout < 0 ? 0 : @read_timeout
    end
    
    typesig { [] }
    def finalize
      # this should do nothing.  The stream finalizer will close
      # the fd
    end
    
    typesig { [] }
    def get_method
      return self.attr_method
    end
    
    typesig { [Map] }
    def map_to_message_header(map)
      headers = MessageHeader.new
      if ((map).nil? || map.is_empty)
        return headers
      end
      entries = map.entry_set
      itr1 = entries.iterator
      while (itr1.has_next)
        entry = itr1.next
        key = entry.get_key
        values = entry.get_value
        itr2 = values.iterator
        while (itr2.has_next)
          value = itr2.next
          if ((key).nil?)
            headers.prepend(key, value)
          else
            headers.add(key, value)
          end
        end
      end
      return headers
    end
    
    class_module.module_eval {
      # The purpose of this wrapper is just to capture the close() call
      # so we can check authentication information that may have
      # arrived in a Trailer field and to write data to a cache
      const_set_lazy(:HttpInputStream) { Class.new(FilterInputStream) do
        extend LocalClass
        include_class_members HttpURLConnection
        
        attr_accessor :cache_request
        alias_method :attr_cache_request, :cache_request
        undef_method :cache_request
        alias_method :attr_cache_request=, :cache_request=
        undef_method :cache_request=
        
        attr_accessor :output_stream
        alias_method :attr_output_stream, :output_stream
        undef_method :output_stream
        alias_method :attr_output_stream=, :output_stream=
        undef_method :output_stream=
        
        attr_accessor :marked
        alias_method :attr_marked, :marked
        undef_method :marked
        alias_method :attr_marked=, :marked=
        undef_method :marked=
        
        attr_accessor :in_cache
        alias_method :attr_in_cache, :in_cache
        undef_method :in_cache
        alias_method :attr_in_cache=, :in_cache=
        undef_method :in_cache=
        
        attr_accessor :mark_count
        alias_method :attr_mark_count, :mark_count
        undef_method :mark_count
        alias_method :attr_mark_count=, :mark_count=
        undef_method :mark_count=
        
        typesig { [InputStream] }
        def initialize(is)
          @cache_request = nil
          @output_stream = nil
          @marked = false
          @in_cache = 0
          @mark_count = 0
          @skip_buffer = nil
          super(is)
          @marked = false
          @in_cache = 0
          @mark_count = 0
          @cache_request = nil
          @output_stream = nil
        end
        
        typesig { [InputStream, CacheRequest] }
        def initialize(is, cache_request)
          @cache_request = nil
          @output_stream = nil
          @marked = false
          @in_cache = 0
          @mark_count = 0
          @skip_buffer = nil
          super(is)
          @marked = false
          @in_cache = 0
          @mark_count = 0
          @cache_request = cache_request
          begin
            @output_stream = cache_request.get_body
          rescue IOException => ioex
            @cache_request.abort
            @cache_request = nil
            @output_stream = nil
          end
        end
        
        typesig { [::Java::Int] }
        # Marks the current position in this input stream. A subsequent
        # call to the <code>reset</code> method repositions this stream at
        # the last marked position so that subsequent reads re-read the same
        # bytes.
        # <p>
        # The <code>readlimit</code> argument tells this input stream to
        # allow that many bytes to be read before the mark position gets
        # invalidated.
        # <p>
        # This method simply performs <code>in.mark(readlimit)</code>.
        # 
        # @param   readlimit   the maximum limit of bytes that can be read before
        # the mark position becomes invalid.
        # @see     java.io.FilterInputStream#in
        # @see     java.io.FilterInputStream#reset()
        def mark(readlimit)
          synchronized(self) do
            super(readlimit)
            if (!(@cache_request).nil?)
              @marked = true
              @mark_count = 0
            end
          end
        end
        
        typesig { [] }
        # Repositions this stream to the position at the time the
        # <code>mark</code> method was last called on this input stream.
        # <p>
        # This method
        # simply performs <code>in.reset()</code>.
        # <p>
        # Stream marks are intended to be used in
        # situations where you need to read ahead a little to see what's in
        # the stream. Often this is most easily done by invoking some
        # general parser. If the stream is of the type handled by the
        # parse, it just chugs along happily. If the stream is not of
        # that type, the parser should toss an exception when it fails.
        # If this happens within readlimit bytes, it allows the outer
        # code to reset the stream and try another parser.
        # 
        # @exception  IOException  if the stream has not been marked or if the
        # mark has been invalidated.
        # @see        java.io.FilterInputStream#in
        # @see        java.io.FilterInputStream#mark(int)
        def reset
          synchronized(self) do
            super
            if (!(@cache_request).nil?)
              @marked = false
              @in_cache += @mark_count
            end
          end
        end
        
        typesig { [] }
        def read
          begin
            b = Array.typed(::Java::Byte).new(1) { 0 }
            ret = read(b)
            return ((ret).equal?(-1) ? ret : (b[0] & 0xff))
          rescue IOException => ioex
            if (!(@cache_request).nil?)
              @cache_request.abort
            end
            raise ioex
          end
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def read(b)
          return read(b, 0, b.attr_length)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          begin
            new_len = super(b, off, len)
            n_write = 0
            # write to cache
            if (@in_cache > 0)
              if (@in_cache >= new_len)
                @in_cache -= new_len
                n_write = 0
              else
                n_write = new_len - @in_cache
                @in_cache = 0
              end
            else
              n_write = new_len
            end
            if (n_write > 0 && !(@output_stream).nil?)
              @output_stream.write(b, off + (new_len - n_write), n_write)
            end
            if (@marked)
              @mark_count += new_len
            end
            return new_len
          rescue IOException => ioex
            if (!(@cache_request).nil?)
              @cache_request.abort
            end
            raise ioex
          end
        end
        
        typesig { [] }
        def close
          begin
            if (!(@output_stream).nil?)
              if (!(read).equal?(-1))
                @cache_request.abort
              else
                @output_stream.close
              end
            end
            super
          rescue IOException => ioex
            if (!(@cache_request).nil?)
              @cache_request.abort
            end
            raise ioex
          ensure
            @local_class_parent.attr_http = nil
            check_response_credentials(true)
          end
        end
        
        # same implementation as InputStream.skip
        attr_accessor :skip_buffer
        alias_method :attr_skip_buffer, :skip_buffer
        undef_method :skip_buffer
        alias_method :attr_skip_buffer=, :skip_buffer=
        undef_method :skip_buffer=
        
        class_module.module_eval {
          const_set_lazy(:SKIP_BUFFER_SIZE) { 8096 }
          const_attr_reader  :SKIP_BUFFER_SIZE
        }
        
        typesig { [::Java::Long] }
        def skip(n)
          remaining = n
          nr = 0
          if ((@skip_buffer).nil?)
            @skip_buffer = Array.typed(::Java::Byte).new(self.class::SKIP_BUFFER_SIZE) { 0 }
          end
          local_skip_buffer = @skip_buffer
          if (n <= 0)
            return 0
          end
          while (remaining > 0)
            nr = read(local_skip_buffer, 0, RJava.cast_to_int(Math.min(self.class::SKIP_BUFFER_SIZE, remaining)))
            if (nr < 0)
              break
            end
            remaining -= nr
          end
          return n - remaining
        end
        
        private
        alias_method :initialize__http_input_stream, :initialize
      end }
      
      const_set_lazy(:StreamingOutputStream) { Class.new(FilterOutputStream) do
        extend LocalClass
        include_class_members HttpURLConnection
        
        attr_accessor :expected
        alias_method :attr_expected, :expected
        undef_method :expected
        alias_method :attr_expected=, :expected=
        undef_method :expected=
        
        attr_accessor :written
        alias_method :attr_written, :written
        undef_method :written
        alias_method :attr_written=, :written=
        undef_method :written=
        
        attr_accessor :closed
        alias_method :attr_closed, :closed
        undef_method :closed
        alias_method :attr_closed=, :closed=
        undef_method :closed=
        
        attr_accessor :error
        alias_method :attr_error, :error
        undef_method :error
        alias_method :attr_error=, :error=
        undef_method :error=
        
        attr_accessor :error_excp
        alias_method :attr_error_excp, :error_excp
        undef_method :error_excp
        alias_method :attr_error_excp=, :error_excp=
        undef_method :error_excp=
        
        typesig { [OutputStream, ::Java::Int] }
        # expectedLength == -1 if the stream is chunked
        # expectedLength > 0 if the stream is fixed content-length
        # In the 2nd case, we make sure the expected number of
        # of bytes are actually written
        def initialize(os, expected_length)
          @expected = 0
          @written = 0
          @closed = false
          @error = false
          @error_excp = nil
          super(os)
          @expected = expected_length
          @written = 0
          @closed = false
          @error = false
        end
        
        typesig { [::Java::Int] }
        def write(b)
          check_error
          @written += 1
          if (!(@expected).equal?(-1) && @written > @expected)
            raise IOException.new("too many bytes written")
          end
          self.attr_out.write(b)
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def write(b)
          write(b, 0, b.attr_length)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def write(b, off, len)
          check_error
          @written += len
          if (!(@expected).equal?(-1) && @written > @expected)
            self.attr_out.close
            raise IOException.new("too many bytes written")
          end
          self.attr_out.write(b, off, len)
        end
        
        typesig { [] }
        def check_error
          if (@closed)
            raise IOException.new("Stream is closed")
          end
          if (@error)
            raise @error_excp
          end
          if ((self.attr_out).check_error)
            raise IOException.new("Error writing request body to server")
          end
        end
        
        typesig { [] }
        # this is called to check that all the bytes
        # that were supposed to be written were written
        # and that the stream is now closed().
        def written_ok
          return @closed && !@error
        end
        
        typesig { [] }
        def close
          if (@closed)
            return
          end
          @closed = true
          if (!(@expected).equal?(-1))
            # not chunked
            if (!(@written).equal?(@expected))
              @error = true
              @error_excp = IOException.new("insufficient data written")
              self.attr_out.close
              raise @error_excp
            end
            FilterOutputStream.instance_method(:flush).bind(self).call
            # can't close the socket
          else
            # chunked
            super
            # force final chunk to be written
            # trailing \r\n
            o = self.attr_http.get_output_stream
            o.write(Character.new(?\r.ord))
            o.write(Character.new(?\n.ord))
            o.flush
          end
        end
        
        private
        alias_method :initialize__streaming_output_stream, :initialize
      end }
      
      const_set_lazy(:ErrorStream) { Class.new(InputStream) do
        include_class_members HttpURLConnection
        
        attr_accessor :buffer
        alias_method :attr_buffer, :buffer
        undef_method :buffer
        alias_method :attr_buffer=, :buffer=
        undef_method :buffer=
        
        attr_accessor :is
        alias_method :attr_is, :is
        undef_method :is
        alias_method :attr_is=, :is=
        undef_method :is=
        
        typesig { [ByteBuffer] }
        def initialize(buf)
          @buffer = nil
          @is = nil
          super()
          @buffer = buf
          @is = nil
        end
        
        typesig { [ByteBuffer, InputStream] }
        def initialize(buf, is)
          @buffer = nil
          @is = nil
          super()
          @buffer = buf
          @is = is
        end
        
        class_module.module_eval {
          typesig { [InputStream, ::Java::Int, HttpClient] }
          # when this method is called, it's either the case that cl > 0, or
          # if chunk-encoded, cl = -1; in other words, cl can't be 0
          def get_error_stream(is, cl, http)
            # cl can't be 0; this following is here for extra precaution
            if ((cl).equal?(0))
              return nil
            end
            begin
              # set SO_TIMEOUT to 1/5th of the total timeout
              # remember the old timeout value so that we can restore it
              old_timeout = http.set_timeout(self.attr_timeout4esbuffer / 5)
              expected = 0
              is_chunked = false
              # the chunked case
              if (cl < 0)
                expected = self.attr_buf_size4es
                is_chunked = true
              else
                expected = cl
              end
              if (expected <= self.attr_buf_size4es)
                buffer = Array.typed(::Java::Byte).new(expected) { 0 }
                count = 0
                time = 0
                len = 0
                begin
                  begin
                    len = is.read(buffer, count, buffer.attr_length - count)
                    if (len < 0)
                      if (cl < 0)
                        # chunked ended
                        # if chunked ended prematurely,
                        # an IOException would be thrown
                        break
                      end
                      # the server sends less than cl bytes of data
                      raise IOException.new("the server closes" + " before sending " + (cl).to_s + " bytes of data")
                    end
                    count += len
                  rescue SocketTimeoutException => ex
                    time += self.attr_timeout4esbuffer / 5
                  end
                end while (count < expected && time < self.attr_timeout4esbuffer)
                # reset SO_TIMEOUT to old value
                http.set_timeout(old_timeout)
                # if count < cl at this point, we will not try to reuse
                # the connection
                if ((count).equal?(0))
                  # since we haven't read anything,
                  # we will return the underlying
                  # inputstream back to the application
                  return nil
                else
                  if (((count).equal?(expected) && !(is_chunked)) || (is_chunked && len < 0))
                    # put the connection into keep-alive cache
                    # the inputstream will try to do the right thing
                    is.close
                    return ErrorStream.new(ByteBuffer.wrap(buffer, 0, count))
                  else
                    # we read part of the response body
                    return ErrorStream.new(ByteBuffer.wrap(buffer, 0, count), is)
                  end
                end
              end
              return nil
            rescue IOException => ioex
              # ioex.printStackTrace();
              return nil
            end
          end
        }
        
        typesig { [] }
        def available
          if ((@is).nil?)
            return @buffer.remaining
          else
            return @buffer.remaining + @is.available
          end
        end
        
        typesig { [] }
        def read
          b = Array.typed(::Java::Byte).new(1) { 0 }
          ret = read(b)
          return ((ret).equal?(-1) ? ret : (b[0] & 0xff))
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def read(b)
          return read(b, 0, b.attr_length)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          rem = @buffer.remaining
          if (rem > 0)
            ret = rem < len ? rem : len
            @buffer.get(b, off, ret)
            return ret
          else
            if ((@is).nil?)
              return -1
            else
              return @is.read(b, off, len)
            end
          end
        end
        
        typesig { [] }
        def close
          @buffer = nil
          if (!(@is).nil?)
            @is.close
          end
        end
        
        private
        alias_method :initialize__error_stream, :initialize
      end }
    }
    
    private
    alias_method :initialize__http_urlconnection, :initialize
  end
  
  # An input stream that just returns EOF.  This is for
  # HTTP URLConnections that are KeepAlive && use the
  # HEAD method - i.e., stream not dead, but nothing to be read.
  class EmptyInputStream < HttpURLConnectionImports.const_get :InputStream
    include_class_members HttpURLConnectionImports
    
    typesig { [] }
    def available
      return 0
    end
    
    typesig { [] }
    def read
      return -1
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__empty_input_stream, :initialize
  end
  
end
