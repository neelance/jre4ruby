require "rjava"

# Copyright 2002-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NTLMAuthenticationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Random
      include_const ::Sun::Net::Www, :HeaderParser
      include ::Java::Io
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include ::Java::Security
      include ::Java::Net
    }
  end
  
  # NTLMAuthentication:
  # 
  # @author Michael McMahon
  class NTLMAuthentication < NTLMAuthenticationImports.const_get :AuthenticationInfo
    include_class_members NTLMAuthenticationImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 100 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:NTLM_AUTH) { Character.new(?N.ord) }
      const_attr_reader  :NTLM_AUTH
    }
    
    attr_accessor :hostname
    alias_method :attr_hostname, :hostname
    undef_method :hostname
    alias_method :attr_hostname=, :hostname=
    undef_method :hostname=
    
    class_module.module_eval {
      
      def default_domain
        defined?(@@default_domain) ? @@default_domain : @@default_domain= nil
      end
      alias_method :attr_default_domain, :default_domain
      
      def default_domain=(value)
        @@default_domain = value
      end
      alias_method :attr_default_domain=, :default_domain=
      
      # Domain to use if not specified by user
      when_class_loaded do
        self.attr_default_domain = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("http.auth.ntlm.domain", "domain")))
      end
    }
    
    typesig { [] }
    def init0
      @hostname = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members NTLMAuthentication
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          localhost = nil
          begin
            localhost = RJava.cast_to_string(InetAddress.get_local_host.get_host_name.to_upper_case)
          rescue self.class::UnknownHostException => e
            localhost = "localhost"
          end
          return localhost
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)))
      x = @hostname.index_of(Character.new(?..ord))
      if (!(x).equal?(-1))
        @hostname = RJava.cast_to_string(@hostname.substring(0, x))
      end
    end
    
    attr_accessor :username
    alias_method :attr_username, :username
    undef_method :username
    alias_method :attr_username=, :username=
    undef_method :username=
    
    attr_accessor :ntdomain
    alias_method :attr_ntdomain, :ntdomain
    undef_method :ntdomain
    alias_method :attr_ntdomain=, :ntdomain=
    undef_method :ntdomain=
    
    attr_accessor :password
    alias_method :attr_password, :password
    undef_method :password
    alias_method :attr_password=, :password=
    undef_method :password=
    
    typesig { [::Java::Boolean, URL, PasswordAuthentication] }
    # Create a NTLMAuthentication:
    # Username may be specified as domain<BACKSLASH>username in the application Authenticator.
    # If this notation is not used, then the domain will be taken
    # from a system property: "http.auth.ntlm.domain".
    def initialize(is_proxy, url, pw)
      @hostname = nil
      @username = nil
      @ntdomain = nil
      @password = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, NTLM_AUTH, url, "")
      init(pw)
    end
    
    typesig { [PasswordAuthentication] }
    def init(pw)
      self.attr_pw = pw
      if (!(pw).nil?)
        s = pw.get_user_name
        i = s.index_of(Character.new(?\\.ord))
        if ((i).equal?(-1))
          @username = s
          @ntdomain = self.attr_default_domain
        else
          @ntdomain = RJava.cast_to_string(s.substring(0, i).to_upper_case)
          @username = RJava.cast_to_string(s.substring(i + 1))
        end
        @password = RJava.cast_to_string(String.new(pw.get_password))
      else
        # credentials will be acquired from OS
        @username = RJava.cast_to_string(nil)
        @ntdomain = RJava.cast_to_string(nil)
        @password = RJava.cast_to_string(nil)
      end
      init0
    end
    
    typesig { [::Java::Boolean, String, ::Java::Int, PasswordAuthentication] }
    # Constructor used for proxy entries
    def initialize(is_proxy, host, port, pw)
      @hostname = nil
      @username = nil
      @ntdomain = nil
      @password = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, NTLM_AUTH, host, port, "")
      init(pw)
    end
    
    typesig { [] }
    # @return true if this authentication supports preemptive authorization
    def supports_preemptive_authorization
      return false
    end
    
    class_module.module_eval {
      typesig { [] }
      # @return true if NTLM supported transparently (no password needed, SSO)
      def supports_transparent_auth
        return true
      end
    }
    
    typesig { [] }
    # @return the name of the HTTP header this authentication wants set
    def get_header_name
      if ((self.attr_type).equal?(SERVER_AUTHENTICATION))
        return "Authorization"
      else
        return "Proxy-authorization"
      end
    end
    
    typesig { [URL, String] }
    # Not supported. Must use the setHeaders() method
    def get_header_value(url, method)
      raise RuntimeException.new("getHeaderValue not supported")
    end
    
    typesig { [String] }
    # Check if the header indicates that the current auth. parameters are stale.
    # If so, then replace the relevant field with the new value
    # and return true. Otherwise return false.
    # returning true means the request can be retried with the same userid/password
    # returning false means we have to go back to the user to ask for a new
    # username password.
    def is_authorization_stale(header)
      return false
      # should not be called for ntlm
    end
    
    typesig { [HttpURLConnection, HeaderParser, String] }
    # Set header(s) on the given connection.
    # @param conn The connection to apply the header(s) to
    # @param p A source of header values for this connection, not used because
    # HeaderParser converts the fields to lower case, use raw instead
    # @param raw The raw header field.
    # @return true if all goes well, false if no headers were set.
    def set_headers(conn, p, raw)
      synchronized(self) do
        begin
          seq = conn.attr_auth_obj
          if ((seq).nil?)
            seq = NTLMAuthSequence.new(@username, @password, @ntdomain)
            conn.attr_auth_obj = seq
          end
          response = "NTLM " + RJava.cast_to_string(seq.get_auth_header(raw.length > 6 ? raw.substring(5) : nil))
          conn.set_authentication_property(get_header_name, response)
          return true
        rescue IOException => e
          return false
        end
      end
    end
    
    typesig { [String, String, URL] }
    # This is a no-op for NTLM, because there is no authentication information
    # provided by the server to the client
    def check_response(header, method, url)
    end
    
    private
    alias_method :initialize__ntlmauthentication, :initialize
  end
  
end
