require "rjava"

# 
# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NegotiateAuthenticationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Sun::Net::Www, :HeaderParser
      include_const ::Sun::Misc, :BASE64Decoder
      include_const ::Sun::Misc, :BASE64Encoder
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :PasswordAuthentication
      include_const ::Java::Io, :IOException
    }
  end
  
  # MS will send a final WWW-Authenticate even if the status is already
  # 200 OK. The token can be fed into initSecContext() again to determine
  # if the server can be trusted. This is not the same concept as Digest's
  # Authentication-Info header.
  # 
  # Currently we ignore this header.
  # 
  # NegotiateAuthentication:
  # 
  # @author weijun.wang@sun.com
  # @since 1.6
  class NegotiateAuthentication < NegotiateAuthenticationImports.const_get :AuthenticationInfo
    include_class_members NegotiateAuthenticationImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 100 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :scheme
    alias_method :attr_scheme, :scheme
    undef_method :scheme
    alias_method :attr_scheme=, :scheme=
    undef_method :scheme=
    
    class_module.module_eval {
      const_set_lazy(:NEGOTIATE_AUTH) { Character.new(?S.ord) }
      const_attr_reader  :NEGOTIATE_AUTH
      
      const_set_lazy(:KERBEROS_AUTH) { Character.new(?K.ord) }
      const_attr_reader  :KERBEROS_AUTH
      
      # These maps are used to manage the GSS availability for diffrent
      # hosts. The key for both maps is the host name.
      # <code>supported</code> is set when isSupported is checked,
      # if it's true, a cached Negotiator is put into <code>cache</code>.
      # the cache can be used only once, so after the first use, it's cleaned.
      
      def supported
        defined?(@@supported) ? @@supported : @@supported= nil
      end
      alias_method :attr_supported, :supported
      
      def supported=(value)
        @@supported = value
      end
      alias_method :attr_supported=, :supported=
      
      
      def cache
        defined?(@@cache) ? @@cache : @@cache= nil
      end
      alias_method :attr_cache, :cache
      
      def cache=(value)
        @@cache = value
      end
      alias_method :attr_cache=, :cache=
    }
    
    # The HTTP Negotiate Helper
    attr_accessor :negotiator
    alias_method :attr_negotiator, :negotiator
    undef_method :negotiator
    alias_method :attr_negotiator=, :negotiator=
    undef_method :negotiator=
    
    typesig { [::Java::Boolean, URL, PasswordAuthentication, String] }
    # 
    # Constructor used for WWW entries. <code>pw</code> is not used because
    # for GSS there is only one single PasswordAuthentication which is
    # independant of host/port/... info.
    def initialize(is_proxy, url, pw, scheme)
      @scheme = nil
      @negotiator = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, NEGOTIATE_AUTH, url, "")
      @scheme = nil
      @negotiator = nil
      @scheme = scheme
    end
    
    typesig { [::Java::Boolean, String, ::Java::Int, PasswordAuthentication, String] }
    # 
    # Constructor used for proxy entries
    def initialize(is_proxy, host, port, pw, scheme)
      @scheme = nil
      @negotiator = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, NEGOTIATE_AUTH, host, port, "")
      @scheme = nil
      @negotiator = nil
      @scheme = scheme
    end
    
    typesig { [] }
    # 
    # @return true if this authentication supports preemptive authorization
    def supports_preemptive_authorization
      return false
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      # 
      # Find out if a hostname supports Negotiate protocol. In order to find
      # out yes or no, an initialization of a Negotiator object against
      # hostname and scheme is tried. The generated object will be cached
      # under the name of hostname at a success try.<br>
      # 
      # If this method is called for the second time on a hostname, the answer is
      # already saved in <code>supported</code>, so no need to try again.
      # 
      # @param hostname hostname to test
      # @param scheme scheme to test
      # @return true if supported
      def is_supported(hostname, scheme)
        synchronized(self) do
          if ((self.attr_supported).nil?)
            self.attr_supported = HashMap.new
            self.attr_cache = HashMap.new
          end
          hostname = (hostname.to_lower_case).to_s
          if (self.attr_supported.contains_key(hostname))
            return self.attr_supported.get(hostname)
          end
          begin
            neg = Negotiator.get_supported(hostname, scheme)
            self.attr_supported.put(hostname, true)
            # the only place cache.put is called. here we can make sure
            # the object is valid and the oneToken inside is not null
            self.attr_cache.put(hostname, neg)
            return true
          rescue Exception => e
            self.attr_supported.put(hostname, false)
            return false
          end
        end
      end
    }
    
    typesig { [] }
    # 
    # @return the name of the HTTP header this authentication wants to set
    def get_header_name
      if ((self.attr_type).equal?(SERVER_AUTHENTICATION))
        return "Authorization"
      else
        return "Proxy-Authorization"
      end
    end
    
    typesig { [URL, String] }
    # 
    # Not supported. Must use the setHeaders() method
    def get_header_value(url, method)
      raise RuntimeException.new("getHeaderValue not supported")
    end
    
    typesig { [String] }
    # 
    # Check if the header indicates that the current auth. parameters are stale.
    # If so, then replace the relevant field with the new value
    # and return true. Otherwise return false.
    # returning true means the request can be retried with the same userid/password
    # returning false means we have to go back to the user to ask for a new
    # username password.
    def is_authorization_stale(header)
      return false
      # should not be called for Negotiate
    end
    
    typesig { [HttpURLConnection, HeaderParser, String] }
    # 
    # Set header(s) on the given connection.
    # @param conn The connection to apply the header(s) to
    # @param p A source of header values for this connection, not used because
    # HeaderParser converts the fields to lower case, use raw instead
    # @param raw The raw header field.
    # @return true if all goes well, false if no headers were set.
    def set_headers(conn, p, raw)
      synchronized(self) do
        begin
          response = nil
          incoming = nil
          parts = raw.split(Regexp.new("\\s+"))
          if (parts.attr_length > 1)
            incoming = BASE64Decoder.new.decode_buffer(parts[1])
          end
          response = @scheme + " " + (B64Encoder.new_local(self).encode((incoming).nil? ? first_token : next_token(incoming))).to_s
          conn.set_authentication_property(get_header_name, response)
          return true
        rescue IOException => e
          return false
        end
      end
    end
    
    typesig { [] }
    # 
    # return the first token.
    # @returns the token
    # @throws IOException if <code>Negotiator.getSupported()</code> or
    # <code>Negotiator.firstToken()</code> failed.
    def first_token
      @negotiator = nil
      if (!(self.attr_cache).nil?)
        synchronized((self.attr_cache)) do
          @negotiator = self.attr_cache.get(get_host)
          if (!(@negotiator).nil?)
            self.attr_cache.remove(get_host) # so that it is only used once
          end
        end
      end
      if ((@negotiator).nil?)
        begin
          @negotiator = Negotiator.get_supported(get_host, @scheme)
        rescue Exception => e
          ioe = IOException.new("Cannot initialize Negotiator")
          ioe.init_cause(e)
          raise ioe
        end
      end
      return @negotiator.first_token
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # return more tokens
    # @param token the token to be fed into <code>negotiator.nextToken()</code>
    # @returns the token
    # @throws IOException if <code>negotiator.nextToken()</code> throws Exception.
    # May happen if the input token is invalid.
    def next_token(token)
      return @negotiator.next_token(token)
    end
    
    typesig { [String, String, URL] }
    # 
    # no-use for Negotiate
    def check_response(header, method, url)
    end
    
    class_module.module_eval {
      const_set_lazy(:B64Encoder) { Class.new(BASE64Encoder) do
        extend LocalClass
        include_class_members NegotiateAuthentication
        
        typesig { [] }
        def bytes_per_line
          return 100000 # as big as it can be, maybe INT_MAX
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__b64encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__negotiate_authentication, :initialize
  end
  
  # 
  # This abstract class is a bridge to connect NegotiteAuthentication and
  # NegotiatorImpl, so that JAAS and JGSS calls can be made
  class Negotiator 
    include_class_members NegotiateAuthenticationImports
    
    class_module.module_eval {
      typesig { [String, String] }
      def get_supported(hostname, scheme)
        # These lines are equivalent to
        # return new NegotiatorImpl(hostname, scheme);
        # The current implementation will make sure NegotiatorImpl is not
        # directly referenced when compiling, thus smooth the way of building
        # the J2SE platform where HttpURLConnection is a bootstrap class.
        clazz = Class.for_name("sun.net.www.protocol.http.NegotiatorImpl")
        c = clazz.get_constructor(String.class, String.class)
        return (c.new_instance(hostname, scheme))
      end
    }
    
    typesig { [] }
    def first_token
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def next_token(in_)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__negotiator, :initialize
  end
  
end
