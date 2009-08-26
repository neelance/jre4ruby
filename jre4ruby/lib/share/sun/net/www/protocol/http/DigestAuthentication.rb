require "rjava"

# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DigestAuthenticationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include ::Java::Io
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :ProtocolException
      include_const ::Java::Net, :PasswordAuthentication
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Random
      include_const ::Sun::Net::Www, :HeaderParser
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
    }
  end
  
  # DigestAuthentication: Encapsulate an http server authentication using
  # the "Digest" scheme, as described in RFC2069 and updated in RFC2617
  # 
  # @author Bill Foote
  class DigestAuthentication < DigestAuthenticationImports.const_get :AuthenticationInfo
    include_class_members DigestAuthenticationImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 100 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:DIGEST_AUTH) { Character.new(?D.ord) }
      const_attr_reader  :DIGEST_AUTH
    }
    
    attr_accessor :auth_method
    alias_method :attr_auth_method, :auth_method
    undef_method :auth_method
    alias_method :attr_auth_method=, :auth_method=
    undef_method :auth_method=
    
    class_module.module_eval {
      # Authentication parameters defined in RFC2617.
      # One instance of these may be shared among several DigestAuthentication
      # instances as a result of a single authorization (for multiple domains)
      const_set_lazy(:Parameters) { Class.new do
        include_class_members DigestAuthentication
        include Java::Io::Serializable
        
        attr_accessor :server_qop
        alias_method :attr_server_qop, :server_qop
        undef_method :server_qop
        alias_method :attr_server_qop=, :server_qop=
        undef_method :server_qop=
        
        # server proposed qop=auth
        attr_accessor :opaque
        alias_method :attr_opaque, :opaque
        undef_method :opaque
        alias_method :attr_opaque=, :opaque=
        undef_method :opaque=
        
        attr_accessor :cnonce
        alias_method :attr_cnonce, :cnonce
        undef_method :cnonce
        alias_method :attr_cnonce=, :cnonce=
        undef_method :cnonce=
        
        attr_accessor :nonce
        alias_method :attr_nonce, :nonce
        undef_method :nonce
        alias_method :attr_nonce=, :nonce=
        undef_method :nonce=
        
        attr_accessor :algorithm
        alias_method :attr_algorithm, :algorithm
        undef_method :algorithm
        alias_method :attr_algorithm=, :algorithm=
        undef_method :algorithm=
        
        attr_accessor :nccount
        alias_method :attr_nccount, :nccount
        undef_method :nccount
        alias_method :attr_nccount=, :nccount=
        undef_method :nccount=
        
        # The H(A1) string used for MD5-sess
        attr_accessor :cached_ha1
        alias_method :attr_cached_ha1, :cached_ha1
        undef_method :cached_ha1
        alias_method :attr_cached_ha1=, :cached_ha1=
        undef_method :cached_ha1=
        
        # Force the HA1 value to be recalculated because the nonce has changed
        attr_accessor :redo_cached_ha1
        alias_method :attr_redo_cached_ha1, :redo_cached_ha1
        undef_method :redo_cached_ha1
        alias_method :attr_redo_cached_ha1=, :redo_cached_ha1=
        undef_method :redo_cached_ha1=
        
        class_module.module_eval {
          const_set_lazy(:CnonceRepeat) { 5 }
          const_attr_reader  :CnonceRepeat
          
          const_set_lazy(:Cnoncelen) { 40 }
          const_attr_reader  :Cnoncelen
          
          # number of characters in cnonce
          
          def random
            defined?(@@random) ? @@random : @@random= nil
          end
          alias_method :attr_random, :random
          
          def random=(value)
            @@random = value
          end
          alias_method :attr_random=, :random=
          
          when_class_loaded do
            self.attr_random = class_self::Random.new
          end
        }
        
        typesig { [] }
        def initialize
          @server_qop = false
          @opaque = nil
          @cnonce = nil
          @nonce = nil
          @algorithm = nil
          @nccount = 0
          @cached_ha1 = nil
          @redo_cached_ha1 = true
          @cnonce_count = 0
          @server_qop = false
          @opaque = RJava.cast_to_string(nil)
          @algorithm = RJava.cast_to_string(nil)
          @cached_ha1 = RJava.cast_to_string(nil)
          @nonce = RJava.cast_to_string(nil)
          set_new_cnonce
        end
        
        typesig { [] }
        def auth_qop
          return @server_qop
        end
        
        typesig { [] }
        def increment_nc
          synchronized(self) do
            @nccount += 1
          end
        end
        
        typesig { [] }
        def get_nccount
          synchronized(self) do
            return @nccount
          end
        end
        
        attr_accessor :cnonce_count
        alias_method :attr_cnonce_count, :cnonce_count
        undef_method :cnonce_count
        alias_method :attr_cnonce_count=, :cnonce_count=
        undef_method :cnonce_count=
        
        typesig { [] }
        # each call increments the counter
        def get_cnonce
          synchronized(self) do
            if (@cnonce_count >= self.class::CnonceRepeat)
              set_new_cnonce
            end
            @cnonce_count += 1
            return @cnonce
          end
        end
        
        typesig { [] }
        def set_new_cnonce
          synchronized(self) do
            bb = Array.typed(::Java::Byte).new(self.class::Cnoncelen / 2) { 0 }
            cc = CharArray.new(self.class::Cnoncelen)
            self.attr_random.next_bytes(bb)
            i = 0
            while i < (self.class::Cnoncelen / 2)
              x = bb[i] + 128
              cc[i * 2] = RJava.cast_to_char((Character.new(?A.ord) + x / 16))
              cc[i * 2 + 1] = RJava.cast_to_char((Character.new(?A.ord) + x % 16))
              i += 1
            end
            @cnonce = RJava.cast_to_string(String.new(cc, 0, self.class::Cnoncelen))
            @cnonce_count = 0
            @redo_cached_ha1 = true
          end
        end
        
        typesig { [String] }
        def set_qop(qop)
          synchronized(self) do
            if (!(qop).nil?)
              st = self.class::StringTokenizer.new(qop, " ")
              while (st.has_more_tokens)
                if (st.next_token.equals_ignore_case("auth"))
                  @server_qop = true
                  return
                end
              end
            end
            @server_qop = false
          end
        end
        
        typesig { [] }
        def get_opaque
          synchronized(self) do
            return @opaque
          end
        end
        
        typesig { [String] }
        def set_opaque(s)
          synchronized(self) do
            @opaque = s
          end
        end
        
        typesig { [] }
        def get_nonce
          synchronized(self) do
            return @nonce
          end
        end
        
        typesig { [String] }
        def set_nonce(s)
          synchronized(self) do
            if (!(s == @nonce))
              @nonce = s
              @nccount = 0
              @redo_cached_ha1 = true
            end
          end
        end
        
        typesig { [] }
        def get_cached_ha1
          synchronized(self) do
            if (@redo_cached_ha1)
              return nil
            else
              return @cached_ha1
            end
          end
        end
        
        typesig { [String] }
        def set_cached_ha1(s)
          synchronized(self) do
            @cached_ha1 = s
            @redo_cached_ha1 = false
          end
        end
        
        typesig { [] }
        def get_algorithm
          synchronized(self) do
            return @algorithm
          end
        end
        
        typesig { [String] }
        def set_algorithm(s)
          synchronized(self) do
            @algorithm = s
          end
        end
        
        private
        alias_method :initialize__parameters, :initialize
      end }
    }
    
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    typesig { [::Java::Boolean, URL, String, String, PasswordAuthentication, Parameters] }
    # Create a DigestAuthentication
    def initialize(is_proxy, url, realm, auth_method, pw, params)
      @auth_method = nil
      @params = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, DIGEST_AUTH, url, realm)
      @auth_method = auth_method
      self.attr_pw = pw
      @params = params
    end
    
    typesig { [::Java::Boolean, String, ::Java::Int, String, String, PasswordAuthentication, Parameters] }
    def initialize(is_proxy, host, port, realm, auth_method, pw, params)
      @auth_method = nil
      @params = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, DIGEST_AUTH, host, port, realm)
      @auth_method = auth_method
      self.attr_pw = pw
      @params = params
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
        return "Proxy-Authorization"
      end
    end
    
    typesig { [URL, String] }
    # Reclaculates the request-digest and returns it.
    # @return the value of the HTTP header this authentication wants set
    def get_header_value(url, method)
      return get_header_value_impl(url.get_file, method)
    end
    
    typesig { [String] }
    # Check if the header indicates that the current auth. parameters are stale.
    # If so, then replace the relevant field with the new value
    # and return true. Otherwise return false.
    # returning true means the request can be retried with the same userid/password
    # returning false means we have to go back to the user to ask for a new
    # username password.
    def is_authorization_stale(header)
      p = HeaderParser.new(header)
      s = p.find_value("stale")
      if ((s).nil? || !(s == "true"))
        return false
      end
      new_nonce = p.find_value("nonce")
      if ((new_nonce).nil? || ("" == new_nonce))
        return false
      end
      @params.set_nonce(new_nonce)
      return true
    end
    
    typesig { [HttpURLConnection, HeaderParser, String] }
    # Set header(s) on the given connection.
    # @param conn The connection to apply the header(s) to
    # @param p A source of header values for this connection, if needed.
    # @param raw Raw header values for this connection, if needed.
    # @return true if all goes well, false if no headers were set.
    def set_headers(conn, p, raw)
      @params.set_nonce(p.find_value("nonce"))
      @params.set_opaque(p.find_value("opaque"))
      @params.set_qop(p.find_value("qop"))
      uri = conn.get_url.get_file
      if ((@params.attr_nonce).nil? || (@auth_method).nil? || (self.attr_pw).nil? || (self.attr_realm).nil?)
        return false
      end
      if (@auth_method.length >= 1)
        # Method seems to get converted to all lower case elsewhere.
        # It really does need to start with an upper case letter
        # here.
        @auth_method = RJava.cast_to_string(Character.to_upper_case(@auth_method.char_at(0)) + @auth_method.substring(1).to_lower_case)
      end
      algorithm = p.find_value("algorithm")
      if ((algorithm).nil? || ("" == algorithm))
        algorithm = "MD5" # The default, accoriding to rfc2069
      end
      @params.set_algorithm(algorithm)
      # If authQop is true, then the server is doing RFC2617 and
      # has offered qop=auth. We do not support any other modes
      # and if auth is not offered we fallback to the RFC2069 behavior
      if (@params.auth_qop)
        @params.set_new_cnonce
      end
      value = get_header_value_impl(uri, conn.get_method)
      if (!(value).nil?)
        conn.set_authentication_property(get_header_name, value)
        return true
      else
        return false
      end
    end
    
    typesig { [String, String] }
    # Calculate the Authorization header field given the request URI
    # and based on the authorization information in params
    def get_header_value_impl(uri, method)
      response = nil
      passwd = self.attr_pw.get_password
      qop = @params.auth_qop
      opaque = @params.get_opaque
      cnonce = @params.get_cnonce
      nonce = @params.get_nonce
      algorithm = @params.get_algorithm
      @params.increment_nc
      nccount = @params.get_nccount
      ncstring = nil
      if (!(nccount).equal?(-1))
        ncstring = RJava.cast_to_string(JavaInteger.to_hex_string(nccount).to_lower_case)
        len = ncstring.length
        if (len < 8)
          ncstring = RJava.cast_to_string(ZeroPad[len]) + ncstring
        end
      end
      begin
        response = RJava.cast_to_string(compute_digest(true, self.attr_pw.get_user_name, passwd, self.attr_realm, method, uri, nonce, cnonce, ncstring))
      rescue NoSuchAlgorithmException => ex
        return nil
      end
      ncfield = "\""
      if (qop)
        ncfield = "\", nc=" + ncstring
      end
      value = @auth_method + " username=\"" + RJava.cast_to_string(self.attr_pw.get_user_name) + "\", realm=\"" + RJava.cast_to_string(self.attr_realm) + "\", nonce=\"" + nonce + ncfield + ", uri=\"" + uri + "\", response=\"" + response + "\", algorithm=\"" + algorithm
      if (!(opaque).nil?)
        value = value + "\", opaque=\"" + opaque
      end
      if (!(cnonce).nil?)
        value = value + "\", cnonce=\"" + cnonce
      end
      if (qop)
        value = value + "\", qop=\"auth"
      end
      value = value + "\""
      return value
    end
    
    typesig { [String, String, URL] }
    def check_response(header, method, url)
      uri = url.get_file
      passwd = self.attr_pw.get_password
      username = self.attr_pw.get_user_name
      qop = @params.auth_qop
      opaque = @params.get_opaque
      cnonce = @params.attr_cnonce
      nonce = @params.get_nonce
      algorithm = @params.get_algorithm
      nccount = @params.get_nccount
      ncstring = nil
      if ((header).nil?)
        raise ProtocolException.new("No authentication information in response")
      end
      if (!(nccount).equal?(-1))
        ncstring = RJava.cast_to_string(JavaInteger.to_hex_string(nccount).to_upper_case)
        len = ncstring.length
        if (len < 8)
          ncstring = RJava.cast_to_string(ZeroPad[len]) + ncstring
        end
      end
      begin
        expected = compute_digest(false, username, passwd, self.attr_realm, method, uri, nonce, cnonce, ncstring)
        p = HeaderParser.new(header)
        rspauth = p.find_value("rspauth")
        if ((rspauth).nil?)
          raise ProtocolException.new("No digest in response")
        end
        if (!(rspauth == expected))
          raise ProtocolException.new("Response digest invalid")
        end
        # Check if there is a nextnonce field
        nextnonce = p.find_value("nextnonce")
        if (!(nextnonce).nil? && !("" == nextnonce))
          @params.set_nonce(nextnonce)
        end
      rescue NoSuchAlgorithmException => ex
        raise ProtocolException.new("Unsupported algorithm in response")
      end
    end
    
    typesig { [::Java::Boolean, String, Array.typed(::Java::Char), String, String, String, String, String, String] }
    def compute_digest(is_request, user_name, password, realm, conn_method, request_uri, nonce_string, cnonce, nc_value)
      a1 = nil
      hash_a1 = nil
      algorithm = @params.get_algorithm
      md5sess = algorithm.equals_ignore_case("MD5-sess")
      md = MessageDigest.get_instance(md5sess ? "MD5" : algorithm)
      if (md5sess)
        if (((hash_a1 = RJava.cast_to_string(@params.get_cached_ha1))).nil?)
          s = user_name + ":" + realm + ":"
          s1 = encode(s, password, md)
          a1 = s1 + ":" + nonce_string + ":" + cnonce
          hash_a1 = RJava.cast_to_string(encode(a1, nil, md))
          @params.set_cached_ha1(hash_a1)
        end
      else
        a1 = user_name + ":" + realm + ":"
        hash_a1 = RJava.cast_to_string(encode(a1, password, md))
      end
      a2 = nil
      if (is_request)
        a2 = conn_method + ":" + request_uri
      else
        a2 = ":" + request_uri
      end
      hash_a2 = encode(a2, nil, md)
      combo = nil
      final_hash = nil
      if (@params.auth_qop)
        # RRC2617 when qop=auth
        combo = hash_a1 + ":" + nonce_string + ":" + nc_value + ":" + cnonce + ":auth:" + hash_a2
      else
        # for compatibility with RFC2069
        combo = hash_a1 + ":" + nonce_string + ":" + hash_a2
      end
      final_hash = RJava.cast_to_string(encode(combo, nil, md))
      return final_hash
    end
    
    class_module.module_eval {
      const_set_lazy(:CharArray) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord)]) }
      const_attr_reader  :CharArray
      
      # 0         1          2         3        4       5      6     7
      const_set_lazy(:ZeroPad) { Array.typed(String).new(["00000000", "0000000", "000000", "00000", "0000", "000", "00", "0"]) }
      const_attr_reader  :ZeroPad
    }
    
    typesig { [String, Array.typed(::Java::Char), MessageDigest] }
    def encode(src, passwd, md)
      begin
        md.update(src.get_bytes("ISO-8859-1"))
      rescue Java::Io::UnsupportedEncodingException => uee
        raise AssertError if not (false)
      end
      if (!(passwd).nil?)
        passwd_bytes = Array.typed(::Java::Byte).new(passwd.attr_length) { 0 }
        i = 0
        while i < passwd.attr_length
          passwd_bytes[i] = passwd[i]
          i += 1
        end
        md.update(passwd_bytes)
        Arrays.fill(passwd_bytes, 0x0)
      end
      digest_ = md.digest
      res = StringBuffer.new(digest_.attr_length * 2)
      i = 0
      while i < digest_.attr_length
        hashchar = ((digest_[i] >> 4) & 0xf)
        res.append(CharArray[hashchar])
        hashchar = (digest_[i] & 0xf)
        res.append(CharArray[hashchar])
        i += 1
      end
      return res.to_s
    end
    
    private
    alias_method :initialize__digest_authentication, :initialize
  end
  
end
