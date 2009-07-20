require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module BasicAuthenticationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :URISyntaxException
      include_const ::Java::Net, :PasswordAuthentication
      include_const ::Sun::Net::Www, :HeaderParser
    }
  end
  
  # BasicAuthentication: Encapsulate an http server authentication using
  # the "basic" scheme.
  # 
  # @author Bill Foote
  class BasicAuthentication < BasicAuthenticationImports.const_get :AuthenticationInfo
    include_class_members BasicAuthenticationImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 100 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:BASIC_AUTH) { Character.new(?B.ord) }
      const_attr_reader  :BASIC_AUTH
    }
    
    # The authentication string for this host, port, and realm.  This is
    # a simple BASE64 encoding of "login:password".
    attr_accessor :auth
    alias_method :attr_auth, :auth
    undef_method :auth
    alias_method :attr_auth=, :auth=
    undef_method :auth=
    
    typesig { [::Java::Boolean, String, ::Java::Int, String, PasswordAuthentication] }
    # Create a BasicAuthentication
    def initialize(is_proxy, host, port, realm, pw)
      @auth = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, BASIC_AUTH, host, port, realm)
      plain = (pw.get_user_name).to_s + ":"
      name_bytes = nil
      begin
        name_bytes = plain.get_bytes("ISO-8859-1")
      rescue Java::Io::UnsupportedEncodingException => uee
        raise AssertError if not (false)
      end
      # get password bytes
      passwd = pw.get_password
      passwd_bytes = Array.typed(::Java::Byte).new(passwd.attr_length) { 0 }
      i = 0
      while i < passwd.attr_length
        passwd_bytes[i] = passwd[i]
        i += 1
      end
      # concatenate user name and password bytes and encode them
      concat = Array.typed(::Java::Byte).new(name_bytes.attr_length + passwd_bytes.attr_length) { 0 }
      System.arraycopy(name_bytes, 0, concat, 0, name_bytes.attr_length)
      System.arraycopy(passwd_bytes, 0, concat, name_bytes.attr_length, passwd_bytes.attr_length)
      @auth = "Basic " + ((Sun::Misc::BASE64Encoder.new).encode(concat)).to_s
      self.attr_pw = pw
    end
    
    typesig { [::Java::Boolean, String, ::Java::Int, String, String] }
    # Create a BasicAuthentication
    def initialize(is_proxy, host, port, realm, auth)
      @auth = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, BASIC_AUTH, host, port, realm)
      @auth = "Basic " + auth
    end
    
    typesig { [::Java::Boolean, URL, String, PasswordAuthentication] }
    # Create a BasicAuthentication
    def initialize(is_proxy, url, realm, pw)
      @auth = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, BASIC_AUTH, url, realm)
      plain = (pw.get_user_name).to_s + ":"
      name_bytes = nil
      begin
        name_bytes = plain.get_bytes("ISO-8859-1")
      rescue Java::Io::UnsupportedEncodingException => uee
        raise AssertError if not (false)
      end
      # get password bytes
      passwd = pw.get_password
      passwd_bytes = Array.typed(::Java::Byte).new(passwd.attr_length) { 0 }
      i = 0
      while i < passwd.attr_length
        passwd_bytes[i] = passwd[i]
        i += 1
      end
      # concatenate user name and password bytes and encode them
      concat = Array.typed(::Java::Byte).new(name_bytes.attr_length + passwd_bytes.attr_length) { 0 }
      System.arraycopy(name_bytes, 0, concat, 0, name_bytes.attr_length)
      System.arraycopy(passwd_bytes, 0, concat, name_bytes.attr_length, passwd_bytes.attr_length)
      @auth = "Basic " + ((Sun::Misc::BASE64Encoder.new).encode(concat)).to_s
      self.attr_pw = pw
    end
    
    typesig { [::Java::Boolean, URL, String, String] }
    # Create a BasicAuthentication
    def initialize(is_proxy, url, realm, auth)
      @auth = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, BASIC_AUTH, url, realm)
      @auth = "Basic " + auth
    end
    
    typesig { [] }
    # @return true if this authentication supports preemptive authorization
    def supports_preemptive_authorization
      return true
    end
    
    typesig { [] }
    # @return the name of the HTTP header this authentication wants set
    def get_header_name
      if ((self.attr_type).equal?(SERVER_AUTHENTICATION))
        return "Authorization"
      else
        return "Proxy-authorization"
      end
    end
    
    typesig { [HttpURLConnection, HeaderParser, String] }
    # Set header(s) on the given connection. This will only be called for
    # definitive (i.e. non-preemptive) authorization.
    # @param conn The connection to apply the header(s) to
    # @param p A source of header values for this connection, if needed.
    # @param raw The raw header values for this connection, if needed.
    # @return true if all goes well, false if no headers were set.
    def set_headers(conn, p, raw)
      conn.set_authentication_property(get_header_name, get_header_value(nil, nil))
      return true
    end
    
    typesig { [URL, String] }
    # @return the value of the HTTP header this authentication wants set
    def get_header_value(url, method)
      # For Basic the authorization string does not depend on the request URL
      # or the request method
      return @auth
    end
    
    typesig { [String] }
    # For Basic Authentication, the security parameters can never be stale.
    # In other words there is no possibility to reuse the credentials.
    # They are always either valid or invalid.
    def is_authorization_stale(header)
      return false
    end
    
    typesig { [String, String, URL] }
    # For Basic Authentication, there is no security information in the
    # response
    def check_response(header, method, url)
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      # @return the common root path between npath and path.
      # This is used to detect when we have an authentication for two
      # paths and the root of th authentication space is the common root.
      def get_root_path(npath, opath)
        index = 0
        toindex = 0
        # Must normalize so we don't get confused by ../ and ./ segments
        begin
          npath = (URI.new(npath).normalize.get_path).to_s
          opath = (URI.new(opath).normalize.get_path).to_s
        rescue URISyntaxException => e
          # ignore error and use the old value
        end
        while (index < opath.length)
          toindex = opath.index_of(Character.new(?/.ord), index + 1)
          if (!(toindex).equal?(-1) && opath.region_matches(0, npath, 0, toindex + 1))
            index = toindex
          else
            return opath.substring(0, index + 1)
          end
        end
        # should not reach here. If we do simply return npath
        return npath
      end
    }
    
    private
    alias_method :initialize__basic_authentication, :initialize
  end
  
end
