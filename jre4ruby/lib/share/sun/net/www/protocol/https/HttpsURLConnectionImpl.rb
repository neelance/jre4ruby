require "rjava"

# Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# NOTE: This class lives in the package sun.net.www.protocol.https.
# There is a copy in com.sun.net.ssl.internal.www.protocol.https for JSSE
# 1.0.2 compatibility. It is 100% identical except the package and extends
# lines. Any changes should be made to be class in sun.net.* and then copied
# to com.sun.net.*.
# For both copies of the file, uncomment one line and comment the other
module Sun::Net::Www::Protocol::Https
  module HttpsURLConnectionImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Https
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :Proxy
      include_const ::Java::Net, :ProtocolException
      include ::Java::Io
      include ::Javax::Net::Ssl
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :Principal
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Sun::Net::Www::Http, :HttpClient
    }
  end
  
  # package com.sun.net.ssl.internal.www.protocol.https;
  # A class to represent an HTTP connection to a remote object.
  # 
  # Ideally, this class should subclass and inherit the http handler
  # implementation, but it can't do so because that class have the
  # wrong Java Type.  Thus it uses the delegate (aka, the
  # Adapter/Wrapper design pattern) to reuse code from the http
  # handler.
  # 
  # Since it would use a delegate to access
  # sun.net.www.protocol.http.HttpURLConnection functionalities, it
  # needs to implement all public methods in it's super class and all
  # the way to Object.
  # For both copies of the file, uncomment one line and comment the
  # other. The differences between the two copies are introduced for
  # plugin, and it is marked as such.
  class HttpsURLConnectionImpl < Javax::Net::Ssl::HttpsURLConnection
    include_class_members HttpsURLConnectionImplImports
    
    # public class HttpsURLConnectionOldImpl
    #      extends com.sun.net.ssl.HttpsURLConnection {
    # NOTE: made protected for plugin so that subclass can set it.
    attr_accessor :delegate
    alias_method :attr_delegate, :delegate
    undef_method :delegate
    alias_method :attr_delegate=, :delegate=
    undef_method :delegate=
    
    typesig { [URL, Handler] }
    # For both copies of the file, uncomment one line and comment the other
    def initialize(u, handler)
      initialize__https_urlconnection_impl(u, nil, handler)
      #    HttpsURLConnectionOldImpl(URL u, Handler handler) throws IOException {
    end
    
    typesig { [URL, Proxy, Handler] }
    # For both copies of the file, uncomment one line and comment the other
    def initialize(u, p, handler)
      @delegate = nil
      super(u)
      #    HttpsURLConnectionOldImpl(URL u, Proxy p, Handler handler) throws IOException {
      @delegate = DelegateHttpsURLConnection.new(self.attr_url, p, handler, self)
    end
    
    typesig { [URL] }
    # NOTE: introduced for plugin
    # subclass needs to overwrite this to set delegate to
    # the appropriate delegatee
    def initialize(u)
      @delegate = nil
      super(u)
    end
    
    typesig { [URL] }
    # Create a new HttpClient object, bypassing the cache of
    # HTTP client objects/connections.
    # 
    # @param url       the URL being accessed
    def set_new_client(url)
      @delegate.set_new_client(url, false)
    end
    
    typesig { [URL, ::Java::Boolean] }
    # Obtain a HttpClient object. Use the cached copy if specified.
    # 
    # @param url       the URL being accessed
    # @param useCache  whether the cached connection should be used
    #                  if present
    def set_new_client(url, use_cache)
      @delegate.set_new_client(url, use_cache)
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
      @delegate.set_proxied_client(url, proxy_host, proxy_port)
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
    #                  if present
    def set_proxied_client(url, proxy_host, proxy_port, use_cache)
      @delegate.set_proxied_client(url, proxy_host, proxy_port, use_cache)
    end
    
    typesig { [] }
    # Implements the HTTP protocol handler's "connect" method,
    # establishing an SSL connection to the server as necessary.
    def connect
      @delegate.connect
    end
    
    typesig { [] }
    # Used by subclass to access "connected" variable.  Since we are
    # delegating the actual implementation to "delegate", we need to
    # delegate the access of "connected" as well.
    def is_connected
      return @delegate.is_connected
    end
    
    typesig { [::Java::Boolean] }
    # Used by subclass to access "connected" variable.  Since we are
    # delegating the actual implementation to "delegate", we need to
    # delegate the access of "connected" as well.
    def set_connected(conn)
      @delegate.set_connected(conn)
    end
    
    typesig { [] }
    # Returns the cipher suite in use on this connection.
    def get_cipher_suite
      return @delegate.get_cipher_suite
    end
    
    typesig { [] }
    # Returns the certificate chain the client sent to the
    # server, or null if the client did not authenticate.
    def get_local_certificates
      return @delegate.get_local_certificates
    end
    
    typesig { [] }
    # Returns the server's certificate chain, or throws
    # SSLPeerUnverified Exception if
    # the server did not authenticate.
    def get_server_certificates
      return @delegate.get_server_certificates
    end
    
    typesig { [] }
    # Returns the server's X.509 certificate chain, or null if
    # the server did not authenticate.
    # 
    # NOTE: This method is not necessary for the version of this class
    # implementing javax.net.ssl.HttpsURLConnection, but provided for
    # compatibility with the com.sun.net.ssl.HttpsURLConnection version.
    def get_server_certificate_chain
      begin
        return @delegate.get_server_certificate_chain
      rescue SSLPeerUnverifiedException => e
        # this method does not throw an exception as declared in
        # com.sun.net.ssl.HttpsURLConnection.
        # Return null for compatibility.
        return nil
      end
    end
    
    typesig { [] }
    # Returns the principal with which the server authenticated itself,
    # or throw a SSLPeerUnverifiedException if the server did not authenticate.
    def get_peer_principal
      return @delegate.get_peer_principal
    end
    
    typesig { [] }
    # Returns the principal the client sent to the
    # server, or null if the client did not authenticate.
    def get_local_principal
      return @delegate.get_local_principal
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
        return @delegate.get_output_stream
      end
    end
    
    typesig { [] }
    def get_input_stream
      synchronized(self) do
        return @delegate.get_input_stream
      end
    end
    
    typesig { [] }
    def get_error_stream
      return @delegate.get_error_stream
    end
    
    typesig { [] }
    # Disconnect from the server.
    def disconnect
      @delegate.disconnect
    end
    
    typesig { [] }
    def using_proxy
      return @delegate.using_proxy
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
      return @delegate.get_header_fields
    end
    
    typesig { [String] }
    # Gets a header field by name. Returns null if not known.
    # @param name the name of the header field
    def get_header_field(name)
      return @delegate.get_header_field(name)
    end
    
    typesig { [::Java::Int] }
    # Gets a header field by index. Returns null if not known.
    # @param n the index of the header field
    def get_header_field(n)
      return @delegate.get_header_field(n)
    end
    
    typesig { [::Java::Int] }
    # Gets a header field by index. Returns null if not known.
    # @param n the index of the header field
    def get_header_field_key(n)
      return @delegate.get_header_field_key(n)
    end
    
    typesig { [String, String] }
    # Sets request property. If a property with the key already
    # exists, overwrite its value with the new value.
    # @param value the value to be set
    def set_request_property(key, value)
      @delegate.set_request_property(key, value)
    end
    
    typesig { [String, String] }
    # Adds a general request property specified by a
    # key-value pair.  This method will not overwrite
    # existing values associated with the same key.
    # 
    # @param   key     the keyword by which the request is known
    #                  (e.g., "<code>accept</code>").
    # @param   value  the value associated with it.
    # @see #getRequestProperties(java.lang.String)
    # @since 1.4
    def add_request_property(key, value)
      @delegate.add_request_property(key, value)
    end
    
    typesig { [] }
    # Overwrite super class method
    def get_response_code
      return @delegate.get_response_code
    end
    
    typesig { [String] }
    def get_request_property(key)
      return @delegate.get_request_property(key)
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
      return @delegate.get_request_properties
    end
    
    typesig { [::Java::Boolean] }
    # We support JDK 1.2.x so we can't count on these from JDK 1.3.
    # We override and supply our own version.
    def set_instance_follow_redirects(should_follow)
      @delegate.set_instance_follow_redirects(should_follow)
    end
    
    typesig { [] }
    def get_instance_follow_redirects
      return @delegate.get_instance_follow_redirects
    end
    
    typesig { [String] }
    def set_request_method(method)
      @delegate.set_request_method(method)
    end
    
    typesig { [] }
    def get_request_method
      return @delegate.get_request_method
    end
    
    typesig { [] }
    def get_response_message
      return @delegate.get_response_message
    end
    
    typesig { [String, ::Java::Long] }
    def get_header_field_date(name, default)
      return @delegate.get_header_field_date(name, default)
    end
    
    typesig { [] }
    def get_permission
      return @delegate.get_permission
    end
    
    typesig { [] }
    def get_url
      return @delegate.get_url
    end
    
    typesig { [] }
    def get_content_length
      return @delegate.get_content_length
    end
    
    typesig { [] }
    def get_content_type
      return @delegate.get_content_type
    end
    
    typesig { [] }
    def get_content_encoding
      return @delegate.get_content_encoding
    end
    
    typesig { [] }
    def get_expiration
      return @delegate.get_expiration
    end
    
    typesig { [] }
    def get_date
      return @delegate.get_date
    end
    
    typesig { [] }
    def get_last_modified
      return @delegate.get_last_modified
    end
    
    typesig { [String, ::Java::Int] }
    def get_header_field_int(name, default)
      return @delegate.get_header_field_int(name, default)
    end
    
    typesig { [] }
    def get_content
      return @delegate.get_content
    end
    
    typesig { [Array.typed(Class)] }
    def get_content(classes)
      return @delegate.get_content(classes)
    end
    
    typesig { [] }
    def to_s
      return @delegate.to_s
    end
    
    typesig { [::Java::Boolean] }
    def set_do_input(doinput)
      @delegate.set_do_input(doinput)
    end
    
    typesig { [] }
    def get_do_input
      return @delegate.get_do_input
    end
    
    typesig { [::Java::Boolean] }
    def set_do_output(dooutput)
      @delegate.set_do_output(dooutput)
    end
    
    typesig { [] }
    def get_do_output
      return @delegate.get_do_output
    end
    
    typesig { [::Java::Boolean] }
    def set_allow_user_interaction(allowuserinteraction)
      @delegate.set_allow_user_interaction(allowuserinteraction)
    end
    
    typesig { [] }
    def get_allow_user_interaction
      return @delegate.get_allow_user_interaction
    end
    
    typesig { [::Java::Boolean] }
    def set_use_caches(usecaches)
      @delegate.set_use_caches(usecaches)
    end
    
    typesig { [] }
    def get_use_caches
      return @delegate.get_use_caches
    end
    
    typesig { [::Java::Long] }
    def set_if_modified_since(ifmodifiedsince)
      @delegate.set_if_modified_since(ifmodifiedsince)
    end
    
    typesig { [] }
    def get_if_modified_since
      return @delegate.get_if_modified_since
    end
    
    typesig { [] }
    def get_default_use_caches
      return @delegate.get_default_use_caches
    end
    
    typesig { [::Java::Boolean] }
    def set_default_use_caches(defaultusecaches)
      @delegate.set_default_use_caches(defaultusecaches)
    end
    
    typesig { [] }
    # finalize (dispose) the delegated object.  Otherwise
    # sun.net.www.protocol.http.HttpURLConnection's finalize()
    # would have to be made public.
    def finalize
      @delegate.dispose
    end
    
    typesig { [Object] }
    def ==(obj)
      return (@delegate == obj)
    end
    
    typesig { [] }
    def hash_code
      return @delegate.hash_code
    end
    
    typesig { [::Java::Int] }
    def set_connect_timeout(timeout)
      @delegate.set_connect_timeout(timeout)
    end
    
    typesig { [] }
    def get_connect_timeout
      return @delegate.get_connect_timeout
    end
    
    typesig { [::Java::Int] }
    def set_read_timeout(timeout)
      @delegate.set_read_timeout(timeout)
    end
    
    typesig { [] }
    def get_read_timeout
      return @delegate.get_read_timeout
    end
    
    typesig { [::Java::Int] }
    def set_fixed_length_streaming_mode(content_length)
      @delegate.set_fixed_length_streaming_mode(content_length)
    end
    
    typesig { [::Java::Int] }
    def set_chunked_streaming_mode(chunklen)
      @delegate.set_chunked_streaming_mode(chunklen)
    end
    
    private
    alias_method :initialize__https_urlconnection_impl, :initialize
  end
  
end
