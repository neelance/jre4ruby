require "rjava"

# Copyright 1995-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AuthenticationInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include ::Java::Io
      include ::Java::Net
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
      include_const ::Sun::Net::Www, :HeaderParser
    }
  end
  
  # AuthenticationInfo: Encapsulate the information needed to
  # authenticate a user to a server.
  # 
  # @author Jon Payne
  # @author Herb Jellinek
  # @author Bill Foote
  # REMIND:  It would be nice if this class understood about partial matching.
  #      If you're authorized for foo.com, chances are high you're also
  #      authorized for baz.foo.com.
  # NB:  When this gets implemented, be careful about the uncaching
  #      policy in HttpURLConnection.  A failure on baz.foo.com shouldn't
  #      uncache foo.com!
  class AuthenticationInfo < AuthenticationInfoImports.const_get :AuthCacheValue
    include_class_members AuthenticationInfoImports
    overload_protected {
      include Cloneable
    }
    
    class_module.module_eval {
      # Constants saying what kind of authroization this is.  This determines
      # the namespace in the hash table lookup.
      const_set_lazy(:SERVER_AUTHENTICATION) { Character.new(?s.ord) }
      const_attr_reader  :SERVER_AUTHENTICATION
      
      const_set_lazy(:PROXY_AUTHENTICATION) { Character.new(?p.ord) }
      const_attr_reader  :PROXY_AUTHENTICATION
      
      # If true, then simultaneous authentication requests to the same realm/proxy
      # are serialized, in order to avoid a user having to type the same username/passwords
      # repeatedly, via the Authenticator. Default is false, which means that this
      # behavior is switched off.
      
      def serialize_auth
        defined?(@@serialize_auth) ? @@serialize_auth : @@serialize_auth= false
      end
      alias_method :attr_serialize_auth, :serialize_auth
      
      def serialize_auth=(value)
        @@serialize_auth = value
      end
      alias_method :attr_serialize_auth=, :serialize_auth=
      
      when_class_loaded do
        self.attr_serialize_auth = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("http.auth.serializeRequests")).boolean_value
      end
    }
    
    # AuthCacheValue:
    attr_accessor :pw
    alias_method :attr_pw, :pw
    undef_method :pw
    alias_method :attr_pw=, :pw=
    undef_method :pw=
    
    typesig { [] }
    def credentials
      return @pw
    end
    
    typesig { [] }
    def get_auth_type
      return (@type).equal?(SERVER_AUTHENTICATION) ? AuthCacheValue::Type::Server : AuthCacheValue::Type::Proxy
    end
    
    typesig { [] }
    def get_host
      return @host
    end
    
    typesig { [] }
    def get_port
      return @port
    end
    
    typesig { [] }
    def get_realm
      return @realm
    end
    
    typesig { [] }
    def get_path
      return @path
    end
    
    typesig { [] }
    def get_protocol_scheme
      return @protocol
    end
    
    class_module.module_eval {
      # requests is used to ensure that interaction with the
      # Authenticator for a particular realm is single threaded.
      # ie. if multiple threads need to get credentials from the user
      # at the same time, then all but the first will block until
      # the first completes its authentication.
      
      def requests
        defined?(@@requests) ? @@requests : @@requests= HashMap.new
      end
      alias_method :attr_requests, :requests
      
      def requests=(value)
        @@requests = value
      end
      alias_method :attr_requests=, :requests=
      
      typesig { [String] }
      # check if a request for this destination is in progress
      # return false immediately if not. Otherwise block until
      # request is finished and return true
      def request_is_in_progress(key)
        if (!self.attr_serialize_auth)
          # behavior is disabled. Revert to concurrent requests
          return false
        end
        synchronized((self.attr_requests)) do
          t = nil
          c = nil
          c = JavaThread.current_thread
          if (((t = self.attr_requests.get(key))).nil?)
            self.attr_requests.put(key, c)
            return false
          end
          if ((t).equal?(c))
            return false
          end
          while (self.attr_requests.contains_key(key))
            begin
              self.attr_requests.wait
            rescue InterruptedException => e
            end
          end
        end
        # entry may be in cache now.
        return true
      end
      
      typesig { [String] }
      # signal completion of an authentication (whether it succeeded or not)
      # so that other threads can continue.
      def request_completed(key)
        synchronized((self.attr_requests)) do
          waspresent = !(self.attr_requests.remove(key)).nil?
          raise AssertError if not (waspresent)
          self.attr_requests.notify_all
        end
      end
    }
    
    # public String toString () {
    # return ("{"+type+":"+authType+":"+protocol+":"+host+":"+port+":"+realm+":"+path+"}");
    # }
    # REMIND:  This cache just grows forever.  We should put in a bounded
    #          cache, or maybe something using WeakRef's.
    # The type (server/proxy) of authentication this is.  Used for key lookup
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # The authentication type (basic/digest). Also used for key lookup
    attr_accessor :auth_type
    alias_method :attr_auth_type, :auth_type
    undef_method :auth_type
    alias_method :attr_auth_type=, :auth_type=
    undef_method :auth_type=
    
    # The protocol/scheme (i.e. http or https ). Need to keep the caches
    # logically separate for the two protocols. This field is only used
    # when constructed with a URL (the normal case for server authentication)
    # For proxy authentication the protocol is not relevant.
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    # The host we're authenticating against.
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    # The port on the host we're authenticating against.
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    # The realm we're authenticating against.
    attr_accessor :realm
    alias_method :attr_realm, :realm
    undef_method :realm
    alias_method :attr_realm=, :realm=
    undef_method :realm=
    
    # The shortest path from the URL we authenticated against.
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    typesig { [::Java::Char, ::Java::Char, String, ::Java::Int, String] }
    # Use this constructor only for proxy entries
    def initialize(type, auth_type, host, port, realm)
      @pw = nil
      @type = 0
      @auth_type = 0
      @protocol = nil
      @host = nil
      @port = 0
      @realm = nil
      @path = nil
      @s1 = nil
      @s2 = nil
      super()
      @type = type
      @auth_type = auth_type
      @protocol = ""
      @host = host.to_lower_case
      @port = port
      @realm = realm
      @path = nil
    end
    
    typesig { [] }
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        # Cannot happen because Cloneable implemented by AuthenticationInfo
        return nil
      end
    end
    
    typesig { [::Java::Char, ::Java::Char, URL, String] }
    # Constructor used to limit the authorization to the path within
    # the URL. Use this constructor for origin server entries.
    def initialize(type, auth_type, url, realm)
      @pw = nil
      @type = 0
      @auth_type = 0
      @protocol = nil
      @host = nil
      @port = 0
      @realm = nil
      @path = nil
      @s1 = nil
      @s2 = nil
      super()
      @type = type
      @auth_type = auth_type
      @protocol = url.get_protocol.to_lower_case
      @host = url.get_host.to_lower_case
      @port = url.get_port
      if ((@port).equal?(-1))
        @port = url.get_default_port
      end
      @realm = realm
      url_path = url.get_path
      if ((url_path.length).equal?(0))
        @path = url_path
      else
        @path = reduce_path(url_path)
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # reduce the path to the root of where we think the
      # authorization begins. This could get shorter as
      # the url is traversed up following a successful challenge.
      def reduce_path(url_path)
        sep_index = url_path.last_index_of(Character.new(?/.ord))
        target_suffix_index = url_path.last_index_of(Character.new(?..ord))
        if (!(sep_index).equal?(-1))
          if (sep_index < target_suffix_index)
            return url_path.substring(0, sep_index + 1)
          else
            return url_path
          end
        else
          return url_path
        end
      end
      
      typesig { [URL] }
      # Returns info for the URL, for an HTTP server auth.  Used when we
      # don't yet know the realm
      # (i.e. when we're preemptively setting the auth).
      def get_server_auth(url)
        port = url.get_port
        if ((port).equal?(-1))
          port = url.get_default_port
        end
        key = RJava.cast_to_string(SERVER_AUTHENTICATION) + ":" + RJava.cast_to_string(url.get_protocol.to_lower_case) + ":" + RJava.cast_to_string(url.get_host.to_lower_case) + ":" + RJava.cast_to_string(port)
        return get_auth(key, url)
      end
      
      typesig { [URL, String, ::Java::Char] }
      # Returns info for the URL, for an HTTP server auth.  Used when we
      # do know the realm (i.e. when we're responding to a challenge).
      # In this case we do not use the path because the protection space
      # is identified by the host:port:realm only
      def get_server_auth(url, realm, atype)
        port = url.get_port
        if ((port).equal?(-1))
          port = url.get_default_port
        end
        key = RJava.cast_to_string(SERVER_AUTHENTICATION) + ":" + RJava.cast_to_string(atype) + ":" + RJava.cast_to_string(url.get_protocol.to_lower_case) + ":" + RJava.cast_to_string(url.get_host.to_lower_case) + ":" + RJava.cast_to_string(port) + ":" + realm
        cached = get_auth(key, nil)
        if (((cached).nil?) && request_is_in_progress(key))
          # check the cache again, it might contain an entry
          cached = get_auth(key, nil)
        end
        return cached
      end
      
      typesig { [String, URL] }
      # Return the AuthenticationInfo object from the cache if it's path is
      # a substring of the supplied URLs path.
      def get_auth(key, url)
        if ((url).nil?)
          return self.attr_cache.get(key, nil)
        else
          return self.attr_cache.get(key, url.get_path)
        end
      end
      
      typesig { [String, ::Java::Int] }
      # Returns a firewall authentication, for the given host/port.  Used
      # for preemptive header-setting. Note, the protocol field is always
      # blank for proxies.
      def get_proxy_auth(host, port)
        key = RJava.cast_to_string(PROXY_AUTHENTICATION) + "::" + RJava.cast_to_string(host.to_lower_case) + ":" + RJava.cast_to_string(port)
        result = self.attr_cache.get(key, nil)
        return result
      end
      
      typesig { [String, ::Java::Int, String, ::Java::Char] }
      # Returns a firewall authentication, for the given host/port and realm.
      # Used in response to a challenge. Note, the protocol field is always
      # blank for proxies.
      def get_proxy_auth(host, port, realm, atype)
        key = RJava.cast_to_string(PROXY_AUTHENTICATION) + ":" + RJava.cast_to_string(atype) + "::" + RJava.cast_to_string(host.to_lower_case) + ":" + RJava.cast_to_string(port) + ":" + realm
        cached = self.attr_cache.get(key, nil)
        if (((cached).nil?) && request_is_in_progress(key))
          # check the cache again, it might contain an entry
          cached = self.attr_cache.get(key, nil)
        end
        return cached
      end
    }
    
    typesig { [] }
    # Add this authentication to the cache
    def add_to_cache
      self.attr_cache.put(cache_key(true), self)
      if (supports_preemptive_authorization)
        self.attr_cache.put(cache_key(false), self)
      end
      end_auth_request
    end
    
    typesig { [] }
    def end_auth_request
      if (!self.attr_serialize_auth)
        return
      end
      synchronized((self.attr_requests)) do
        request_completed(cache_key(true))
      end
    end
    
    typesig { [] }
    # Remove this authentication from the cache
    def remove_from_cache
      self.attr_cache.remove(cache_key(true), self)
      if (supports_preemptive_authorization)
        self.attr_cache.remove(cache_key(false), self)
      end
    end
    
    typesig { [] }
    # @return true if this authentication supports preemptive authorization
    def supports_preemptive_authorization
      raise NotImplementedError
    end
    
    typesig { [] }
    # @return the name of the HTTP header this authentication wants set.
    #          This is used for preemptive authorization.
    def get_header_name
      raise NotImplementedError
    end
    
    typesig { [URL, String] }
    # Calculates and returns the authentication header value based
    # on the stored authentication parameters. If the calculation does not depend
    # on the URL or the request method then these parameters are ignored.
    # @param url The URL
    # @param method The request method
    # @return the value of the HTTP header this authentication wants set.
    #          Used for preemptive authorization.
    def get_header_value(url, method)
      raise NotImplementedError
    end
    
    typesig { [HttpURLConnection, HeaderParser, String] }
    # Set header(s) on the given connection.  Subclasses must override
    # This will only be called for
    # definitive (i.e. non-preemptive) authorization.
    # @param conn The connection to apply the header(s) to
    # @param p A source of header values for this connection, if needed.
    # @param raw The raw header field (if needed)
    # @return true if all goes well, false if no headers were set.
    def set_headers(conn, p, raw)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Check if the header indicates that the current auth. parameters are stale.
    # If so, then replace the relevant field with the new value
    # and return true. Otherwise return false.
    # returning true means the request can be retried with the same userid/password
    # returning false means we have to go back to the user to ask for a new
    # username password.
    def is_authorization_stale(header)
      raise NotImplementedError
    end
    
    typesig { [String, String, URL] }
    # Check for any expected authentication information in the response
    # from the server
    def check_response(header, method, url)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Give a key for hash table lookups.
    # @param includeRealm if you want the realm considered.  Preemptively
    #          setting an authorization is done before the realm is known.
    def cache_key(include_realm)
      # This must be kept in sync with the getXXXAuth() methods in this
      # class.
      if (include_realm)
        return RJava.cast_to_string(@type) + ":" + RJava.cast_to_string(@auth_type) + ":" + @protocol + ":" + @host + ":" + RJava.cast_to_string(@port) + ":" + @realm
      else
        return RJava.cast_to_string(@type) + ":" + @protocol + ":" + @host + ":" + RJava.cast_to_string(@port)
      end
    end
    
    attr_accessor :s1
    alias_method :attr_s1, :s1
    undef_method :s1
    alias_method :attr_s1=, :s1=
    undef_method :s1=
    
    attr_accessor :s2
    alias_method :attr_s2, :s2
    undef_method :s2
    alias_method :attr_s2=, :s2=
    undef_method :s2=
    
    typesig { [ObjectInputStream] }
    # used for serialization of pw
    def read_object(s)
      s.default_read_object
      @pw = PasswordAuthentication.new(@s1, @s2.to_char_array)
      @s1 = RJava.cast_to_string(nil)
      @s2 = RJava.cast_to_string(nil)
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    def write_object(s)
      synchronized(self) do
        @s1 = RJava.cast_to_string(@pw.get_user_name)
        @s2 = RJava.cast_to_string(String.new(@pw.get_password))
        s.default_write_object
      end
    end
    
    private
    alias_method :initialize__authentication_info, :initialize
  end
  
end
