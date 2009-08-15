require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NTLMAuthenticationImports
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
  # 
  # 
  # NTLM authentication is nominally based on the framework defined in RFC2617,
  # but differs from the standard (Basic & Digest) schemes as follows:
  # 
  # 1. A complete authentication requires three request/response transactions
  # as shown below:
  # REQ ------------------------------->
  # <---- 401 (signalling NTLM) --------
  # 
  # REQ (with type1 NTLM msg) --------->
  # <---- 401 (with type 2 NTLM msg) ---
  # 
  # REQ (with type3 NTLM msg) --------->
  # <---- OK ---------------------------
  # 
  # 2. The scope of the authentication is the TCP connection (which must be kept-alive)
  # after the type2 response is received. This means that NTLM does not work end-to-end
  # through a proxy, rather between client and proxy, or between client and server (with no proxy)
  class NTLMAuthentication < NTLMAuthenticationImports.const_get :AuthenticationInfo
    include_class_members NTLMAuthenticationImports
    
    class_module.module_eval {
      
      def ntlm_auth
        defined?(@@ntlm_auth) ? @@ntlm_auth : @@ntlm_auth= Character.new(?N.ord)
      end
      alias_method :attr_ntlm_auth, :ntlm_auth
      
      def ntlm_auth=(value)
        @@ntlm_auth = value
      end
      alias_method :attr_ntlm_auth=, :ntlm_auth=
    }
    
    attr_accessor :type1
    alias_method :attr_type1, :type1
    undef_method :type1
    alias_method :attr_type1=, :type1=
    undef_method :type1=
    
    attr_accessor :type3
    alias_method :attr_type3, :type3
    undef_method :type3
    alias_method :attr_type3=, :type3=
    undef_method :type3=
    
    attr_accessor :fac
    alias_method :attr_fac, :fac
    undef_method :fac
    alias_method :attr_fac=, :fac=
    undef_method :fac=
    
    attr_accessor :cipher
    alias_method :attr_cipher, :cipher
    undef_method :cipher
    alias_method :attr_cipher=, :cipher=
    undef_method :cipher=
    
    attr_accessor :md4
    alias_method :attr_md4, :md4
    undef_method :md4
    alias_method :attr_md4=, :md4=
    undef_method :md4=
    
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
      
      typesig { [] }
      def supports_transparent_auth
        return false
      end
    }
    
    typesig { [] }
    def init0
      @type1 = Array.typed(::Java::Byte).new(256) { 0 }
      @type3 = Array.typed(::Java::Byte).new(256) { 0 }
      System.arraycopy(Array.typed(::Java::Byte).new([Character.new(?N.ord), Character.new(?T.ord), Character.new(?L.ord), Character.new(?M.ord), Character.new(?S.ord), Character.new(?S.ord), Character.new(?P.ord), 0, 1]), 0, @type1, 0, 9)
      @type1[12] = 3
      @type1[13] = 0xb2
      @type1[28] = 0x20
      System.arraycopy(Array.typed(::Java::Byte).new([Character.new(?N.ord), Character.new(?T.ord), Character.new(?L.ord), Character.new(?M.ord), Character.new(?S.ord), Character.new(?S.ord), Character.new(?P.ord), 0, 3]), 0, @type3, 0, 9)
      @type3[12] = 0x18
      @type3[14] = 0x18
      @type3[20] = 0x18
      @type3[22] = 0x18
      @type3[32] = 0x40
      @type3[60] = 1
      @type3[61] = 0x82
      begin
        @hostname = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members NTLMAuthentication
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            localhost = nil
            begin
              localhost = RJava.cast_to_string(InetAddress.get_local_host.get_host_name.to_upper_case)
            rescue UnknownHostException => e
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
        @fac = SecretKeyFactory.get_instance("DES")
        @cipher = Cipher.get_instance("DES/ECB/NoPadding")
        @md4 = Sun::Security::Provider::MD4.get_instance
      rescue NoSuchPaddingException => e
        raise AssertError if not (false)
      rescue NoSuchAlgorithmException => e
        raise AssertError if not (false)
      end
    end
    
    attr_accessor :pw
    alias_method :attr_pw, :pw
    undef_method :pw
    alias_method :attr_pw=, :pw=
    undef_method :pw=
    
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
      @type1 = nil
      @type3 = nil
      @fac = nil
      @cipher = nil
      @md4 = nil
      @hostname = nil
      @pw = nil
      @username = nil
      @ntdomain = nil
      @password = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, self.attr_ntlm_auth, url, "")
      init(pw)
    end
    
    typesig { [PasswordAuthentication] }
    def init(pw)
      @pw = pw
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
      init0
    end
    
    typesig { [::Java::Boolean, String, ::Java::Int, PasswordAuthentication] }
    # Constructor used for proxy entries
    def initialize(is_proxy, host, port, pw)
      @type1 = nil
      @type3 = nil
      @fac = nil
      @cipher = nil
      @md4 = nil
      @hostname = nil
      @pw = nil
      @username = nil
      @ntdomain = nil
      @password = nil
      super(is_proxy ? PROXY_AUTHENTICATION : SERVER_AUTHENTICATION, self.attr_ntlm_auth, host, port, "")
      init(pw)
    end
    
    typesig { [] }
    # @return true if this authentication supports preemptive authorization
    def supports_preemptive_authorization
      return false
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
          response = nil
          if (raw.length < 6)
            # NTLM<sp>
            response = RJava.cast_to_string(build_type1msg)
          else
            msg = raw.substring(5)
            # skip NTLM<sp>
            response = RJava.cast_to_string(build_type3msg(msg))
          end
          conn.set_authentication_property(get_header_name, response)
          return true
        rescue IOException => e
          return false
        rescue GeneralSecurityException => e
          return false
        end
      end
    end
    
    typesig { [String, String, URL] }
    # This is a no-op for NTLM, because there is no authentication information
    # provided by the server to the client
    def check_response(header, method, url)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, String, String] }
    def copybytes(dest, destpos, src, enc)
      begin
        x = src.get_bytes(enc)
        System.arraycopy(x, 0, dest, destpos, x.attr_length)
      rescue UnsupportedEncodingException => e
        raise AssertError if not (false)
      end
    end
    
    typesig { [] }
    def build_type1msg
      dlen = @ntdomain.length
      @type1[16] = (dlen % 256)
      @type1[17] = (dlen / 256)
      @type1[18] = @type1[16]
      @type1[19] = @type1[17]
      hlen = @hostname.length
      @type1[24] = (hlen % 256)
      @type1[25] = (hlen / 256)
      @type1[26] = @type1[24]
      @type1[27] = @type1[25]
      copybytes(@type1, 32, @hostname, "ISO8859_1")
      copybytes(@type1, hlen + 32, @ntdomain, "ISO8859_1")
      @type1[20] = ((hlen + 32) % 256)
      @type1[21] = ((hlen + 32) / 256)
      msg = Array.typed(::Java::Byte).new(32 + hlen + dlen) { 0 }
      System.arraycopy(@type1, 0, msg, 0, 32 + hlen + dlen)
      result = "NTLM " + RJava.cast_to_string((B64Encoder.new).encode(msg))
      return result
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Convert a 7 byte array to an 8 byte array (for a des key with parity)
    # input starts at offset off
    def make_des_key(input, off)
      in_ = Array.typed(::Java::Int).new(input.attr_length) { 0 }
      i = 0
      while i < in_.attr_length
        in_[i] = input[i] < 0 ? input[i] + 256 : input[i]
        i += 1
      end
      out = Array.typed(::Java::Byte).new(8) { 0 }
      out[0] = in_[off + 0]
      out[1] = (((in_[off + 0] << 7) & 0xff) | (in_[off + 1] >> 1))
      out[2] = (((in_[off + 1] << 6) & 0xff) | (in_[off + 2] >> 2))
      out[3] = (((in_[off + 2] << 5) & 0xff) | (in_[off + 3] >> 3))
      out[4] = (((in_[off + 3] << 4) & 0xff) | (in_[off + 4] >> 4))
      out[5] = (((in_[off + 4] << 3) & 0xff) | (in_[off + 5] >> 5))
      out[6] = (((in_[off + 5] << 2) & 0xff) | (in_[off + 6] >> 6))
      out[7] = ((in_[off + 6] << 1) & 0xff)
      return out
    end
    
    typesig { [] }
    def calc_lmhash
      magic = Array.typed(::Java::Byte).new([0x4b, 0x47, 0x53, 0x21, 0x40, 0x23, 0x24, 0x25])
      pwb = @password.to_upper_case.get_bytes
      pwb1 = Array.typed(::Java::Byte).new(14) { 0 }
      len = @password.length
      if (len > 14)
        len = 14
      end
      System.arraycopy(pwb, 0, pwb1, 0, len)
      # Zero padded
      dks1 = DESKeySpec.new(make_des_key(pwb1, 0))
      dks2 = DESKeySpec.new(make_des_key(pwb1, 7))
      key1 = @fac.generate_secret(dks1)
      key2 = @fac.generate_secret(dks2)
      @cipher.init(Cipher::ENCRYPT_MODE, key1)
      out1 = @cipher.do_final(magic, 0, 8)
      @cipher.init(Cipher::ENCRYPT_MODE, key2)
      out2 = @cipher.do_final(magic, 0, 8)
      result = Array.typed(::Java::Byte).new(21) { 0 }
      System.arraycopy(out1, 0, result, 0, 8)
      System.arraycopy(out2, 0, result, 8, 8)
      return result
    end
    
    typesig { [] }
    def calc_nthash
      pw = nil
      begin
        pw = @password.get_bytes("UnicodeLittleUnmarked")
      rescue UnsupportedEncodingException => e
        raise AssertError if not (false)
      end
      out = @md4.digest(pw)
      result = Array.typed(::Java::Byte).new(21) { 0 }
      System.arraycopy(out, 0, result, 0, 16)
      return result
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # key is a 21 byte array. Split it into 3 7 byte chunks,
    # Convert each to 8 byte DES keys, encrypt the text arg with
    # each key and return the three results in a sequential []
    def calc_response(key, text)
      raise AssertError if not ((key.attr_length).equal?(21))
      dks1 = DESKeySpec.new(make_des_key(key, 0))
      dks2 = DESKeySpec.new(make_des_key(key, 7))
      dks3 = DESKeySpec.new(make_des_key(key, 14))
      key1 = @fac.generate_secret(dks1)
      key2 = @fac.generate_secret(dks2)
      key3 = @fac.generate_secret(dks3)
      @cipher.init(Cipher::ENCRYPT_MODE, key1)
      out1 = @cipher.do_final(text, 0, 8)
      @cipher.init(Cipher::ENCRYPT_MODE, key2)
      out2 = @cipher.do_final(text, 0, 8)
      @cipher.init(Cipher::ENCRYPT_MODE, key3)
      out3 = @cipher.do_final(text, 0, 8)
      result = Array.typed(::Java::Byte).new(24) { 0 }
      System.arraycopy(out1, 0, result, 0, 8)
      System.arraycopy(out2, 0, result, 8, 8)
      System.arraycopy(out3, 0, result, 16, 8)
      return result
    end
    
    typesig { [String] }
    def build_type3msg(challenge)
      # First decode the type2 message to get the server nonce
      # nonce is located at type2[24] for 8 bytes
      type2 = (Sun::Misc::BASE64Decoder.new).decode_buffer(challenge)
      nonce = Array.typed(::Java::Byte).new(8) { 0 }
      System.arraycopy(type2, 24, nonce, 0, 8)
      ulen = @username.length * 2
      @type3[36] = @type3[38] = (ulen % 256)
      @type3[37] = @type3[39] = (ulen / 256)
      dlen = @ntdomain.length * 2
      @type3[28] = @type3[30] = (dlen % 256)
      @type3[29] = @type3[31] = (dlen / 256)
      hlen = @hostname.length * 2
      @type3[44] = @type3[46] = (hlen % 256)
      @type3[45] = @type3[47] = (hlen / 256)
      l = 64
      copybytes(@type3, l, @ntdomain, "UnicodeLittleUnmarked")
      @type3[32] = (l % 256)
      @type3[33] = (l / 256)
      l += dlen
      copybytes(@type3, l, @username, "UnicodeLittleUnmarked")
      @type3[40] = (l % 256)
      @type3[41] = (l / 256)
      l += ulen
      copybytes(@type3, l, @hostname, "UnicodeLittleUnmarked")
      @type3[48] = (l % 256)
      @type3[49] = (l / 256)
      l += hlen
      lmhash = calc_lmhash
      lmresponse = calc_response(lmhash, nonce)
      nthash = calc_nthash
      ntresponse = calc_response(nthash, nonce)
      System.arraycopy(lmresponse, 0, @type3, l, 24)
      @type3[16] = (l % 256)
      @type3[17] = (l / 256)
      l += 24
      System.arraycopy(ntresponse, 0, @type3, l, 24)
      @type3[24] = (l % 256)
      @type3[25] = (l / 256)
      l += 24
      @type3[56] = (l % 256)
      @type3[57] = (l / 256)
      msg = Array.typed(::Java::Byte).new(l) { 0 }
      System.arraycopy(@type3, 0, msg, 0, l)
      result = "NTLM " + RJava.cast_to_string((B64Encoder.new).encode(msg))
      return result
    end
    
    private
    alias_method :initialize__ntlmauthentication, :initialize
  end
  
  class B64Encoder < Sun::Misc::BASE64Encoder
    include_class_members NTLMAuthenticationImports
    
    typesig { [] }
    # to force it to to the entire encoding in one line
    def bytes_per_line
      return 1024
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__b64encoder, :initialize
  end
  
end
