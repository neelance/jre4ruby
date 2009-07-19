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
module Java::Net
  module HttpURLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :Permission
      include_const ::Java::Util, :Date
    }
  end
  
  # A URLConnection with support for HTTP-specific features. See
  # <A HREF="http://www.w3.org/pub/WWW/Protocols/"> the spec </A> for
  # details.
  # <p>
  # 
  # Each HttpURLConnection instance is used to make a single request
  # but the underlying network connection to the HTTP server may be
  # transparently shared by other instances. Calling the close() methods
  # on the InputStream or OutputStream of an HttpURLConnection
  # after a request may free network resources associated with this
  # instance but has no effect on any shared persistent connection.
  # Calling the disconnect() method may close the underlying socket
  # if a persistent connection is otherwise idle at that time.
  # 
  # @see     java.net.HttpURLConnection#disconnect()
  # @since JDK1.1
  class HttpURLConnection < HttpURLConnectionImports.const_get :URLConnection
    include_class_members HttpURLConnectionImports
    
    # instance variables
    # 
    # The HTTP method (GET,POST,PUT,etc.).
    attr_accessor :method
    alias_method :attr_method, :method
    undef_method :method
    alias_method :attr_method=, :method=
    undef_method :method=
    
    # The chunk-length when using chunked encoding streaming mode for output.
    # A value of <code>-1</code> means chunked encoding is disabled for output.
    # @since 1.5
    attr_accessor :chunk_length
    alias_method :attr_chunk_length, :chunk_length
    undef_method :chunk_length
    alias_method :attr_chunk_length=, :chunk_length=
    undef_method :chunk_length=
    
    # The fixed content-length when using fixed-length streaming mode.
    # A value of <code>-1</code> means fixed-length streaming mode is disabled
    # for output.
    # @since 1.5
    attr_accessor :fixed_content_length
    alias_method :attr_fixed_content_length, :fixed_content_length
    undef_method :fixed_content_length
    alias_method :attr_fixed_content_length=, :fixed_content_length=
    undef_method :fixed_content_length=
    
    typesig { [::Java::Int] }
    # Returns the key for the <code>n</code><sup>th</sup> header field.
    # Some implementations may treat the <code>0</code><sup>th</sup>
    # header field as special, i.e. as the status line returned by the HTTP
    # server. In this case, {@link #getHeaderField(int) getHeaderField(0)} returns the status
    # line, but <code>getHeaderFieldKey(0)</code> returns null.
    # 
    # @param   n   an index, where n >=0.
    # @return  the key for the <code>n</code><sup>th</sup> header field,
    # or <code>null</code> if the key does not exist.
    def get_header_field_key(n)
      return nil
    end
    
    typesig { [::Java::Int] }
    # This method is used to enable streaming of a HTTP request body
    # without internal buffering, when the content length is known in
    # advance.
    # <p>
    # An exception will be thrown if the application
    # attempts to write more data than the indicated
    # content-length, or if the application closes the OutputStream
    # before writing the indicated amount.
    # <p>
    # When output streaming is enabled, authentication
    # and redirection cannot be handled automatically.
    # A HttpRetryException will be thrown when reading
    # the response if authentication or redirection are required.
    # This exception can be queried for the details of the error.
    # <p>
    # This method must be called before the URLConnection is connected.
    # 
    # @param   contentLength The number of bytes which will be written
    # to the OutputStream.
    # 
    # @throws  IllegalStateException if URLConnection is already connected
    # or if a different streaming mode is already enabled.
    # 
    # @throws  IllegalArgumentException if a content length less than
    # zero is specified.
    # 
    # @see     #setChunkedStreamingMode(int)
    # @since 1.5
    def set_fixed_length_streaming_mode(content_length)
      if (self.attr_connected)
        raise IllegalStateException.new("Already connected")
      end
      if (!(@chunk_length).equal?(-1))
        raise IllegalStateException.new("Chunked encoding streaming mode set")
      end
      if (content_length < 0)
        raise IllegalArgumentException.new("invalid content length")
      end
      @fixed_content_length = content_length
    end
    
    class_module.module_eval {
      # Default chunk size (including chunk header) if not specified;
      # we want to keep this in sync with the one defined in
      # sun.net.www.http.ChunkedOutputStream
      const_set_lazy(:DEFAULT_CHUNK_SIZE) { 4096 }
      const_attr_reader  :DEFAULT_CHUNK_SIZE
    }
    
    typesig { [::Java::Int] }
    # This method is used to enable streaming of a HTTP request body
    # without internal buffering, when the content length is <b>not</b>
    # known in advance. In this mode, chunked transfer encoding
    # is used to send the request body. Note, not all HTTP servers
    # support this mode.
    # <p>
    # When output streaming is enabled, authentication
    # and redirection cannot be handled automatically.
    # A HttpRetryException will be thrown when reading
    # the response if authentication or redirection are required.
    # This exception can be queried for the details of the error.
    # <p>
    # This method must be called before the URLConnection is connected.
    # 
    # @param   chunklen The number of bytes to write in each chunk.
    # If chunklen is less than or equal to zero, a default
    # value will be used.
    # 
    # @throws  IllegalStateException if URLConnection is already connected
    # or if a different streaming mode is already enabled.
    # 
    # @see     #setFixedLengthStreamingMode(int)
    # @since 1.5
    def set_chunked_streaming_mode(chunklen)
      if (self.attr_connected)
        raise IllegalStateException.new("Can't set streaming mode: already connected")
      end
      if (!(@fixed_content_length).equal?(-1))
        raise IllegalStateException.new("Fixed length streaming mode set")
      end
      @chunk_length = chunklen <= 0 ? DEFAULT_CHUNK_SIZE : chunklen
    end
    
    typesig { [::Java::Int] }
    # Returns the value for the <code>n</code><sup>th</sup> header field.
    # Some implementations may treat the <code>0</code><sup>th</sup>
    # header field as special, i.e. as the status line returned by the HTTP
    # server.
    # <p>
    # This method can be used in conjunction with the
    # {@link #getHeaderFieldKey getHeaderFieldKey} method to iterate through all
    # the headers in the message.
    # 
    # @param   n   an index, where n>=0.
    # @return  the value of the <code>n</code><sup>th</sup> header field,
    # or <code>null</code> if the value does not exist.
    # @see     java.net.HttpURLConnection#getHeaderFieldKey(int)
    def get_header_field(n)
      return nil
    end
    
    # An <code>int</code> representing the three digit HTTP Status-Code.
    # <ul>
    # <li> 1xx: Informational
    # <li> 2xx: Success
    # <li> 3xx: Redirection
    # <li> 4xx: Client Error
    # <li> 5xx: Server Error
    # </ul>
    attr_accessor :response_code
    alias_method :attr_response_code, :response_code
    undef_method :response_code
    alias_method :attr_response_code=, :response_code=
    undef_method :response_code=
    
    # The HTTP response message.
    attr_accessor :response_message
    alias_method :attr_response_message, :response_message
    undef_method :response_message
    alias_method :attr_response_message=, :response_message=
    undef_method :response_message=
    
    class_module.module_eval {
      # static variables
      # do we automatically follow redirects? The default is true.
      
      def follow_redirects
        defined?(@@follow_redirects) ? @@follow_redirects : @@follow_redirects= true
      end
      alias_method :attr_follow_redirects, :follow_redirects
      
      def follow_redirects=(value)
        @@follow_redirects = value
      end
      alias_method :attr_follow_redirects=, :follow_redirects=
    }
    
    # If <code>true</code>, the protocol will automatically follow redirects.
    # If <code>false</code>, the protocol will not automatically follow
    # redirects.
    # <p>
    # This field is set by the <code>setInstanceFollowRedirects</code>
    # method. Its value is returned by the <code>getInstanceFollowRedirects</code>
    # method.
    # <p>
    # Its default value is based on the value of the static followRedirects
    # at HttpURLConnection construction time.
    # 
    # @see     java.net.HttpURLConnection#setInstanceFollowRedirects(boolean)
    # @see     java.net.HttpURLConnection#getInstanceFollowRedirects()
    # @see     java.net.HttpURLConnection#setFollowRedirects(boolean)
    attr_accessor :instance_follow_redirects
    alias_method :attr_instance_follow_redirects, :instance_follow_redirects
    undef_method :instance_follow_redirects
    alias_method :attr_instance_follow_redirects=, :instance_follow_redirects=
    undef_method :instance_follow_redirects=
    
    class_module.module_eval {
      # valid HTTP methods
      const_set_lazy(:Methods) { Array.typed(String).new(["GET", "POST", "HEAD", "OPTIONS", "PUT", "DELETE", "TRACE"]) }
      const_attr_reader  :Methods
    }
    
    typesig { [URL] }
    # Constructor for the HttpURLConnection.
    # @param u the URL
    def initialize(u)
      @method = nil
      @chunk_length = 0
      @fixed_content_length = 0
      @response_code = 0
      @response_message = nil
      @instance_follow_redirects = false
      super(u)
      @method = "GET"
      @chunk_length = -1
      @fixed_content_length = -1
      @response_code = -1
      @response_message = nil
      @instance_follow_redirects = self.attr_follow_redirects
    end
    
    class_module.module_eval {
      typesig { [::Java::Boolean] }
      # Sets whether HTTP redirects  (requests with response code 3xx) should
      # be automatically followed by this class.  True by default.  Applets
      # cannot change this variable.
      # <p>
      # If there is a security manager, this method first calls
      # the security manager's <code>checkSetFactory</code> method
      # to ensure the operation is allowed.
      # This could result in a SecurityException.
      # 
      # @param set a <code>boolean</code> indicating whether or not
      # to follow HTTP redirects.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkSetFactory</code> method doesn't
      # allow the operation.
      # @see        SecurityManager#checkSetFactory
      # @see #getFollowRedirects()
      def set_follow_redirects(set)
        sec = System.get_security_manager
        if (!(sec).nil?)
          # seems to be the best check here...
          sec.check_set_factory
        end
        self.attr_follow_redirects = set
      end
      
      typesig { [] }
      # Returns a <code>boolean</code> indicating
      # whether or not HTTP redirects (3xx) should
      # be automatically followed.
      # 
      # @return <code>true</code> if HTTP redirects should
      # be automatically followed, <tt>false</tt> if not.
      # @see #setFollowRedirects(boolean)
      def get_follow_redirects
        return self.attr_follow_redirects
      end
    }
    
    typesig { [::Java::Boolean] }
    # Sets whether HTTP redirects (requests with response code 3xx) should
    # be automatically followed by this <code>HttpURLConnection</code>
    # instance.
    # <p>
    # The default value comes from followRedirects, which defaults to
    # true.
    # 
    # @param followRedirects a <code>boolean</code> indicating
    # whether or not to follow HTTP redirects.
    # 
    # @see    java.net.HttpURLConnection#instanceFollowRedirects
    # @see #getInstanceFollowRedirects
    # @since 1.3
    def set_instance_follow_redirects(follow_redirects)
      @instance_follow_redirects = follow_redirects
    end
    
    typesig { [] }
    # Returns the value of this <code>HttpURLConnection</code>'s
    # <code>instanceFollowRedirects</code> field.
    # 
    # @return  the value of this <code>HttpURLConnection</code>'s
    # <code>instanceFollowRedirects</code> field.
    # @see     java.net.HttpURLConnection#instanceFollowRedirects
    # @see #setInstanceFollowRedirects(boolean)
    # @since 1.3
    def get_instance_follow_redirects
      return @instance_follow_redirects
    end
    
    typesig { [String] }
    # Set the method for the URL request, one of:
    # <UL>
    # <LI>GET
    # <LI>POST
    # <LI>HEAD
    # <LI>OPTIONS
    # <LI>PUT
    # <LI>DELETE
    # <LI>TRACE
    # </UL> are legal, subject to protocol restrictions.  The default
    # method is GET.
    # 
    # @param method the HTTP method
    # @exception ProtocolException if the method cannot be reset or if
    # the requested method isn't valid for HTTP.
    # @see #getRequestMethod()
    def set_request_method(method)
      if (self.attr_connected)
        raise ProtocolException.new("Can't reset method: already connected")
      end
      # This restriction will prevent people from using this class to
      # experiment w/ new HTTP methods using java.  But it should
      # be placed for security - the request String could be
      # arbitrarily long.
      i = 0
      while i < Methods.attr_length
        if ((Methods[i] == method))
          @method = method
          return
        end
        ((i += 1) - 1)
      end
      raise ProtocolException.new("Invalid HTTP method: " + method)
    end
    
    typesig { [] }
    # Get the request method.
    # @return the HTTP request method
    # @see #setRequestMethod(java.lang.String)
    def get_request_method
      return @method
    end
    
    typesig { [] }
    # Gets the status code from an HTTP response message.
    # For example, in the case of the following status lines:
    # <PRE>
    # HTTP/1.0 200 OK
    # HTTP/1.0 401 Unauthorized
    # </PRE>
    # It will return 200 and 401 respectively.
    # Returns -1 if no code can be discerned
    # from the response (i.e., the response is not valid HTTP).
    # @throws IOException if an error occurred connecting to the server.
    # @return the HTTP Status-Code, or -1
    def get_response_code
      # We're got the response code already
      if (!(@response_code).equal?(-1))
        return @response_code
      end
      # Ensure that we have connected to the server. Record
      # exception as we need to re-throw it if there isn't
      # a status line.
      exc = nil
      begin
        get_input_stream
      rescue Exception => e
        exc = e
      end
      # If we can't a status-line then re-throw any exception
      # that getInputStream threw.
      status_line = get_header_field(0)
      if ((status_line).nil?)
        if (!(exc).nil?)
          if (exc.is_a?(RuntimeException))
            raise exc
          else
            raise exc
          end
        end
        return -1
      end
      # Examine the status-line - should be formatted as per
      # section 6.1 of RFC 2616 :-
      # 
      # Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase
      # 
      # If status line can't be parsed return -1.
      if (status_line.starts_with("HTTP/1."))
        code_pos = status_line.index_of(Character.new(?\s.ord))
        if (code_pos > 0)
          phrase_pos = status_line.index_of(Character.new(?\s.ord), code_pos + 1)
          if (phrase_pos > 0 && phrase_pos < status_line.length)
            @response_message = (status_line.substring(phrase_pos + 1)).to_s
          end
          # deviation from RFC 2616 - don't reject status line
          # if SP Reason-Phrase is not included.
          if (phrase_pos < 0)
            phrase_pos = status_line.length
          end
          begin
            @response_code = JavaInteger.parse_int(status_line.substring(code_pos + 1, phrase_pos))
            return @response_code
          rescue NumberFormatException => e
          end
        end
      end
      return -1
    end
    
    typesig { [] }
    # Gets the HTTP response message, if any, returned along with the
    # response code from a server.  From responses like:
    # <PRE>
    # HTTP/1.0 200 OK
    # HTTP/1.0 404 Not Found
    # </PRE>
    # Extracts the Strings "OK" and "Not Found" respectively.
    # Returns null if none could be discerned from the responses
    # (the result was not valid HTTP).
    # @throws IOException if an error occurred connecting to the server.
    # @return the HTTP response message, or <code>null</code>
    def get_response_message
      get_response_code
      return @response_message
    end
    
    typesig { [String, ::Java::Long] }
    def get_header_field_date(name, default)
      date_string = get_header_field(name)
      begin
        if ((date_string.index_of("GMT")).equal?(-1))
          date_string = date_string + " GMT"
        end
        return Date.parse(date_string)
      rescue Exception => e
      end
      return default
    end
    
    typesig { [] }
    # Indicates that other requests to the server
    # are unlikely in the near future. Calling disconnect()
    # should not imply that this HttpURLConnection
    # instance can be reused for other requests.
    def disconnect
      raise NotImplementedError
    end
    
    typesig { [] }
    # Indicates if the connection is going through a proxy.
    # @return a boolean indicating if the connection is
    # using a proxy.
    def using_proxy
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_permission
      port = self.attr_url.get_port
      port = port < 0 ? 80 : port
      host = (self.attr_url.get_host).to_s + ":" + (port).to_s
      permission = SocketPermission.new(host, "connect")
      return permission
    end
    
    typesig { [] }
    # Returns the error stream if the connection failed
    # but the server sent useful data nonetheless. The
    # typical example is when an HTTP server responds
    # with a 404, which will cause a FileNotFoundException
    # to be thrown in connect, but the server sent an HTML
    # help page with suggestions as to what to do.
    # 
    # <p>This method will not cause a connection to be initiated.  If
    # the connection was not connected, or if the server did not have
    # an error while connecting or if the server had an error but
    # no error data was sent, this method will return null. This is
    # the default.
    # 
    # @return an error stream if any, null if there have been no
    # errors, the connection is not connected or the server sent no
    # useful data.
    def get_error_stream
      return nil
    end
    
    class_module.module_eval {
      # The response codes for HTTP, as of version 1.1.
      # 
      # REMIND: do we want all these??
      # Others not here that we do want??
      # 2XX: generally "OK"
      # 
      # HTTP Status-Code 200: OK.
      const_set_lazy(:HTTP_OK) { 200 }
      const_attr_reader  :HTTP_OK
      
      # HTTP Status-Code 201: Created.
      const_set_lazy(:HTTP_CREATED) { 201 }
      const_attr_reader  :HTTP_CREATED
      
      # HTTP Status-Code 202: Accepted.
      const_set_lazy(:HTTP_ACCEPTED) { 202 }
      const_attr_reader  :HTTP_ACCEPTED
      
      # HTTP Status-Code 203: Non-Authoritative Information.
      const_set_lazy(:HTTP_NOT_AUTHORITATIVE) { 203 }
      const_attr_reader  :HTTP_NOT_AUTHORITATIVE
      
      # HTTP Status-Code 204: No Content.
      const_set_lazy(:HTTP_NO_CONTENT) { 204 }
      const_attr_reader  :HTTP_NO_CONTENT
      
      # HTTP Status-Code 205: Reset Content.
      const_set_lazy(:HTTP_RESET) { 205 }
      const_attr_reader  :HTTP_RESET
      
      # HTTP Status-Code 206: Partial Content.
      const_set_lazy(:HTTP_PARTIAL) { 206 }
      const_attr_reader  :HTTP_PARTIAL
      
      # 3XX: relocation/redirect
      # 
      # HTTP Status-Code 300: Multiple Choices.
      const_set_lazy(:HTTP_MULT_CHOICE) { 300 }
      const_attr_reader  :HTTP_MULT_CHOICE
      
      # HTTP Status-Code 301: Moved Permanently.
      const_set_lazy(:HTTP_MOVED_PERM) { 301 }
      const_attr_reader  :HTTP_MOVED_PERM
      
      # HTTP Status-Code 302: Temporary Redirect.
      const_set_lazy(:HTTP_MOVED_TEMP) { 302 }
      const_attr_reader  :HTTP_MOVED_TEMP
      
      # HTTP Status-Code 303: See Other.
      const_set_lazy(:HTTP_SEE_OTHER) { 303 }
      const_attr_reader  :HTTP_SEE_OTHER
      
      # HTTP Status-Code 304: Not Modified.
      const_set_lazy(:HTTP_NOT_MODIFIED) { 304 }
      const_attr_reader  :HTTP_NOT_MODIFIED
      
      # HTTP Status-Code 305: Use Proxy.
      const_set_lazy(:HTTP_USE_PROXY) { 305 }
      const_attr_reader  :HTTP_USE_PROXY
      
      # 4XX: client error
      # 
      # HTTP Status-Code 400: Bad Request.
      const_set_lazy(:HTTP_BAD_REQUEST) { 400 }
      const_attr_reader  :HTTP_BAD_REQUEST
      
      # HTTP Status-Code 401: Unauthorized.
      const_set_lazy(:HTTP_UNAUTHORIZED) { 401 }
      const_attr_reader  :HTTP_UNAUTHORIZED
      
      # HTTP Status-Code 402: Payment Required.
      const_set_lazy(:HTTP_PAYMENT_REQUIRED) { 402 }
      const_attr_reader  :HTTP_PAYMENT_REQUIRED
      
      # HTTP Status-Code 403: Forbidden.
      const_set_lazy(:HTTP_FORBIDDEN) { 403 }
      const_attr_reader  :HTTP_FORBIDDEN
      
      # HTTP Status-Code 404: Not Found.
      const_set_lazy(:HTTP_NOT_FOUND) { 404 }
      const_attr_reader  :HTTP_NOT_FOUND
      
      # HTTP Status-Code 405: Method Not Allowed.
      const_set_lazy(:HTTP_BAD_METHOD) { 405 }
      const_attr_reader  :HTTP_BAD_METHOD
      
      # HTTP Status-Code 406: Not Acceptable.
      const_set_lazy(:HTTP_NOT_ACCEPTABLE) { 406 }
      const_attr_reader  :HTTP_NOT_ACCEPTABLE
      
      # HTTP Status-Code 407: Proxy Authentication Required.
      const_set_lazy(:HTTP_PROXY_AUTH) { 407 }
      const_attr_reader  :HTTP_PROXY_AUTH
      
      # HTTP Status-Code 408: Request Time-Out.
      const_set_lazy(:HTTP_CLIENT_TIMEOUT) { 408 }
      const_attr_reader  :HTTP_CLIENT_TIMEOUT
      
      # HTTP Status-Code 409: Conflict.
      const_set_lazy(:HTTP_CONFLICT) { 409 }
      const_attr_reader  :HTTP_CONFLICT
      
      # HTTP Status-Code 410: Gone.
      const_set_lazy(:HTTP_GONE) { 410 }
      const_attr_reader  :HTTP_GONE
      
      # HTTP Status-Code 411: Length Required.
      const_set_lazy(:HTTP_LENGTH_REQUIRED) { 411 }
      const_attr_reader  :HTTP_LENGTH_REQUIRED
      
      # HTTP Status-Code 412: Precondition Failed.
      const_set_lazy(:HTTP_PRECON_FAILED) { 412 }
      const_attr_reader  :HTTP_PRECON_FAILED
      
      # HTTP Status-Code 413: Request Entity Too Large.
      const_set_lazy(:HTTP_ENTITY_TOO_LARGE) { 413 }
      const_attr_reader  :HTTP_ENTITY_TOO_LARGE
      
      # HTTP Status-Code 414: Request-URI Too Large.
      const_set_lazy(:HTTP_REQ_TOO_LONG) { 414 }
      const_attr_reader  :HTTP_REQ_TOO_LONG
      
      # HTTP Status-Code 415: Unsupported Media Type.
      const_set_lazy(:HTTP_UNSUPPORTED_TYPE) { 415 }
      const_attr_reader  :HTTP_UNSUPPORTED_TYPE
      
      # 5XX: server error
      # 
      # HTTP Status-Code 500: Internal Server Error.
      # @deprecated   it is misplaced and shouldn't have existed.
      const_set_lazy(:HTTP_SERVER_ERROR) { 500 }
      const_attr_reader  :HTTP_SERVER_ERROR
      
      # HTTP Status-Code 500: Internal Server Error.
      const_set_lazy(:HTTP_INTERNAL_ERROR) { 500 }
      const_attr_reader  :HTTP_INTERNAL_ERROR
      
      # HTTP Status-Code 501: Not Implemented.
      const_set_lazy(:HTTP_NOT_IMPLEMENTED) { 501 }
      const_attr_reader  :HTTP_NOT_IMPLEMENTED
      
      # HTTP Status-Code 502: Bad Gateway.
      const_set_lazy(:HTTP_BAD_GATEWAY) { 502 }
      const_attr_reader  :HTTP_BAD_GATEWAY
      
      # HTTP Status-Code 503: Service Unavailable.
      const_set_lazy(:HTTP_UNAVAILABLE) { 503 }
      const_attr_reader  :HTTP_UNAVAILABLE
      
      # HTTP Status-Code 504: Gateway Timeout.
      const_set_lazy(:HTTP_GATEWAY_TIMEOUT) { 504 }
      const_attr_reader  :HTTP_GATEWAY_TIMEOUT
      
      # HTTP Status-Code 505: HTTP Version Not Supported.
      const_set_lazy(:HTTP_VERSION) { 505 }
      const_attr_reader  :HTTP_VERSION
    }
    
    private
    alias_method :initialize__http_urlconnection, :initialize
  end
  
end
