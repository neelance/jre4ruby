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
module Sun::Net::Www::Protocol::Https
  module AbstractDelegateHttpsURLConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Https
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :Proxy
      include_const ::Java::Net, :SecureCacheResponse
      include_const ::Java::Security, :Principal
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :JavaList
      include_const ::Javax::Net::Ssl, :SSLPeerUnverifiedException
      include ::Sun::Net::Www::Http
      include_const ::Sun::Net::Www::Protocol::Http, :HttpURLConnection
    }
  end
  
  # HTTPS URL connection support.
  # We need this delegate because HttpsURLConnection is a subclass of
  # java.net.HttpURLConnection. We will avoid copying over the code from
  # sun.net.www.protocol.http.HttpURLConnection by having this class
  class AbstractDelegateHttpsURLConnection < AbstractDelegateHttpsURLConnectionImports.const_get :HttpURLConnection
    include_class_members AbstractDelegateHttpsURLConnectionImports
    
    typesig { [URL, Sun::Net::Www::Protocol::Http::Handler] }
    def initialize(url, handler)
      initialize__abstract_delegate_https_urlconnection(url, nil, handler)
    end
    
    typesig { [URL, Proxy, Sun::Net::Www::Protocol::Http::Handler] }
    def initialize(url, p, handler)
      super(url, p, handler)
    end
    
    typesig { [] }
    def get_sslsocket_factory
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_hostname_verifier
      raise NotImplementedError
    end
    
    typesig { [URL] }
    # No user application is able to call these routines, as no one
    # should ever get access to an instance of
    # DelegateHttpsURLConnection (sun.* or com.*)
    # 
    # 
    # Create a new HttpClient object, bypassing the cache of
    # HTTP client objects/connections.
    # 
    # Note: this method is changed from protected to public because
    # the com.sun.ssl.internal.www.protocol.https handler reuses this
    # class for its actual implemantation
    # 
    # @param url the URL being accessed
    def set_new_client(url)
      set_new_client(url, false)
    end
    
    typesig { [URL, ::Java::Boolean] }
    # Obtain a HttpClient object. Use the cached copy if specified.
    # 
    # Note: this method is changed from protected to public because
    # the com.sun.ssl.internal.www.protocol.https handler reuses this
    # class for its actual implemantation
    # 
    # @param url       the URL being accessed
    # @param useCache  whether the cached connection should be used
    # if present
    def set_new_client(url, use_cache)
      self.attr_http = HttpsClient._new(get_sslsocket_factory, url, get_hostname_verifier, use_cache)
      (self.attr_http).after_connect
    end
    
    typesig { [URL, String, ::Java::Int] }
    # Create a new HttpClient object, set up so that it uses
    # per-instance proxying to the given HTTP proxy.  This
    # bypasses the cache of HTTP client objects/connections.
    # 
    # Note: this method is changed from protected to public because
    # the com.sun.ssl.internal.www.protocol.https handler reuses this
    # class for its actual implemantation
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
    # Note: this method is changed from protected to public because
    # the com.sun.ssl.internal.www.protocol.https handler reuses this
    # class for its actual implemantation
    # 
    # @param url       the URL being accessed
    # @param proxyHost the proxy host to use
    # @param proxyPort the proxy port to use
    # @param useCache  whether the cached connection should be used
    # if present
    def set_proxied_client(url, proxy_host, proxy_port, use_cache)
      proxied_connect(url, proxy_host, proxy_port, use_cache)
      if (!self.attr_http.is_cached_connection)
        do_tunneling
      end
      (self.attr_http).after_connect
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Boolean] }
    def proxied_connect(url, proxy_host, proxy_port, use_cache)
      if (self.attr_connected)
        return
      end
      self.attr_http = HttpsClient._new(get_sslsocket_factory, url, get_hostname_verifier, proxy_host, proxy_port, use_cache)
      self.attr_connected = true
    end
    
    typesig { [] }
    # Used by subclass to access "connected" variable.
    def is_connected
      return self.attr_connected
    end
    
    typesig { [::Java::Boolean] }
    # Used by subclass to access "connected" variable.
    def set_connected(conn)
      self.attr_connected = conn
    end
    
    typesig { [] }
    # Implements the HTTP protocol handler's "connect" method,
    # establishing an SSL connection to the server as necessary.
    def connect
      if (self.attr_connected)
        return
      end
      plain_connect
      if (!(self.attr_cached_response).nil?)
        # using cached response
        return
      end
      if (!self.attr_http.is_cached_connection && self.attr_http.needs_tunneling)
        do_tunneling
      end
      (self.attr_http).after_connect
    end
    
    typesig { [URL, Proxy, ::Java::Int] }
    # will try to use cached HttpsClient
    def get_new_http_client(url, p, connect_timeout)
      return HttpsClient._new(get_sslsocket_factory, url, get_hostname_verifier, p, true, connect_timeout)
    end
    
    typesig { [URL, Proxy, ::Java::Int, ::Java::Boolean] }
    # will open new connection
    def get_new_http_client(url, p, connect_timeout, use_cache)
      return HttpsClient._new(get_sslsocket_factory, url, get_hostname_verifier, p, use_cache, connect_timeout)
    end
    
    typesig { [] }
    # Returns the cipher suite in use on this connection.
    def get_cipher_suite
      if (!(self.attr_cached_response).nil?)
        return (self.attr_cached_response).get_cipher_suite
      end
      if ((self.attr_http).nil?)
        raise IllegalStateException.new("connection not yet open")
      else
        return (self.attr_http).get_cipher_suite
      end
    end
    
    typesig { [] }
    # Returns the certificate chain the client sent to the
    # server, or null if the client did not authenticate.
    def get_local_certificates
      if (!(self.attr_cached_response).nil?)
        l = (self.attr_cached_response).get_local_certificate_chain
        if ((l).nil?)
          return nil
        else
          return l.to_array
        end
      end
      if ((self.attr_http).nil?)
        raise IllegalStateException.new("connection not yet open")
      else
        return ((self.attr_http).get_local_certificates)
      end
    end
    
    typesig { [] }
    # Returns the server's certificate chain, or throws
    # SSLPeerUnverified Exception if
    # the server did not authenticate.
    def get_server_certificates
      if (!(self.attr_cached_response).nil?)
        l = (self.attr_cached_response).get_server_certificate_chain
        if ((l).nil?)
          return nil
        else
          return l.to_array
        end
      end
      if ((self.attr_http).nil?)
        raise IllegalStateException.new("connection not yet open")
      else
        return ((self.attr_http).get_server_certificates)
      end
    end
    
    typesig { [] }
    # Returns the server's X.509 certificate chain, or null if
    # the server did not authenticate.
    def get_server_certificate_chain
      if (!(self.attr_cached_response).nil?)
        raise UnsupportedOperationException.new("this method is not supported when using cache")
      end
      if ((self.attr_http).nil?)
        raise IllegalStateException.new("connection not yet open")
      else
        return (self.attr_http).get_server_certificate_chain
      end
    end
    
    typesig { [] }
    # Returns the server's principal, or throws SSLPeerUnverifiedException
    # if the server did not authenticate.
    def get_peer_principal
      if (!(self.attr_cached_response).nil?)
        return (self.attr_cached_response).get_peer_principal
      end
      if ((self.attr_http).nil?)
        raise IllegalStateException.new("connection not yet open")
      else
        return ((self.attr_http).get_peer_principal)
      end
    end
    
    typesig { [] }
    # Returns the principal the client sent to the
    # server, or null if the client did not authenticate.
    def get_local_principal
      if (!(self.attr_cached_response).nil?)
        return (self.attr_cached_response).get_local_principal
      end
      if ((self.attr_http).nil?)
        raise IllegalStateException.new("connection not yet open")
      else
        return ((self.attr_http).get_local_principal)
      end
    end
    
    private
    alias_method :initialize__abstract_delegate_https_urlconnection, :initialize
  end
  
end
