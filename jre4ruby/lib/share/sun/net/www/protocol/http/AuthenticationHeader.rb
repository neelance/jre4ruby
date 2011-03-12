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
  module AuthenticationHeaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include ::Sun::Net::Www
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :HashMap
    }
  end
  
  # This class is used to parse the information in WWW-Authenticate: and Proxy-Authenticate:
  # headers. It searches among multiple header lines and within each header line
  # for the best currently supported scheme. It can also return a HeaderParser
  # containing the challenge data for that particular scheme.
  # 
  # Some examples:
  # 
  # WWW-Authenticate: Basic realm="foo" Digest realm="bar" NTLM
  #  Note the realm parameter must be associated with the particular scheme.
  # 
  # or
  # 
  # WWW-Authenticate: Basic realm="foo"
  # WWW-Authenticate: Digest realm="foo",qop="auth",nonce="thisisanunlikelynonce"
  # WWW-Authenticate: NTLM
  # 
  # or
  # 
  # WWW-Authenticate: Basic realm="foo"
  # WWW-Authenticate: NTLM ASKAJK9893289889QWQIOIONMNMN
  # 
  # The last example shows how NTLM breaks the rules of rfc2617 for the structure of
  # the authentication header. This is the reason why the raw header field is used for ntlm.
  # 
  # At present, the class chooses schemes in following order :
  #      1. Negotiate (if supported)
  #      2. Kerberos (if supported)
  #      3. Digest
  #      4. NTLM (if supported)
  #      5. Basic
  # 
  # This choice can be modified by setting a system property:
  # 
  #      -Dhttp.auth.preference="scheme"
  # 
  # which in this case, specifies that "scheme" should be used as the auth scheme when offered
  # disregarding the default prioritisation. If scheme is not offered then the default priority
  # is used.
  # 
  # Attention: when http.auth.preference is set as SPNEGO or Kerberos, it's actually "Negotiate
  # with SPNEGO" or "Negotiate with Kerberos", which means the user will prefer the Negotiate
  # scheme with GSS/SPNEGO or GSS/Kerberos mechanism.
  # 
  # This also means that the real "Kerberos" scheme can never be set as a preference.
  class AuthenticationHeader 
    include_class_members AuthenticationHeaderImports
    
    attr_accessor :rsp
    alias_method :attr_rsp, :rsp
    undef_method :rsp
    alias_method :attr_rsp=, :rsp=
    undef_method :rsp=
    
    # the response to be parsed
    attr_accessor :preferred
    alias_method :attr_preferred, :preferred
    undef_method :preferred
    alias_method :attr_preferred=, :preferred=
    undef_method :preferred=
    
    attr_accessor :preferred_r
    alias_method :attr_preferred_r, :preferred_r
    undef_method :preferred_r
    alias_method :attr_preferred_r=, :preferred_r=
    undef_method :preferred_r=
    
    # raw Strings
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    class_module.module_eval {
      # the hostname for server,
      # used in checking the availability of Negotiate
      
      def auth_pref
        defined?(@@auth_pref) ? @@auth_pref : @@auth_pref= nil
      end
      alias_method :attr_auth_pref, :auth_pref
      
      def auth_pref=(value)
        @@auth_pref = value
      end
      alias_method :attr_auth_pref=, :auth_pref=
    }
    
    typesig { [] }
    def to_s
      return "AuthenticationHeader: prefer " + @preferred_r
    end
    
    class_module.module_eval {
      when_class_loaded do
        self.attr_auth_pref = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("http.auth.preference")))
        # http.auth.preference can be set to SPNEGO or Kerberos.
        # In fact they means "Negotiate with SPNEGO" and "Negotiate with
        # Kerberos" separately, so here they are all translated into
        # Negotiate. Read NegotiateAuthentication.java to see how they
        # were used later.
        if (!(self.attr_auth_pref).nil?)
          self.attr_auth_pref = RJava.cast_to_string(self.attr_auth_pref.to_lower_case)
          if ((self.attr_auth_pref == "spnego") || (self.attr_auth_pref == "kerberos"))
            self.attr_auth_pref = "negotiate"
          end
        end
      end
    }
    
    attr_accessor :hdrname
    alias_method :attr_hdrname, :hdrname
    undef_method :hdrname
    alias_method :attr_hdrname=, :hdrname=
    undef_method :hdrname=
    
    typesig { [String, MessageHeader] }
    # Name of the header to look for
    # parse a set of authentication headers and choose the preferred scheme
    # that we support
    def initialize(hdrname, response)
      @rsp = nil
      @preferred = nil
      @preferred_r = nil
      @host = nil
      @hdrname = nil
      @schemes = nil
      @rsp = response
      @hdrname = hdrname
      @schemes = HashMap.new
      parse
    end
    
    typesig { [String, MessageHeader, String] }
    # parse a set of authentication headers and choose the preferred scheme
    # that we support for a given host
    def initialize(hdrname, response, host)
      @rsp = nil
      @preferred = nil
      @preferred_r = nil
      @host = nil
      @hdrname = nil
      @schemes = nil
      @host = host
      @rsp = response
      @hdrname = hdrname
      @schemes = HashMap.new
      parse
    end
    
    class_module.module_eval {
      # we build up a map of scheme names mapped to SchemeMapValue objects
      const_set_lazy(:SchemeMapValue) { Class.new do
        include_class_members AuthenticationHeader
        
        typesig { [class_self::HeaderParser, String] }
        def initialize(h, r)
          @raw = nil
          @parser = nil
          @raw = r
          @parser = h
        end
        
        attr_accessor :raw
        alias_method :attr_raw, :raw
        undef_method :raw
        alias_method :attr_raw=, :raw=
        undef_method :raw=
        
        attr_accessor :parser
        alias_method :attr_parser, :parser
        undef_method :parser
        alias_method :attr_parser=, :parser=
        undef_method :parser=
        
        private
        alias_method :initialize__scheme_map_value, :initialize
      end }
    }
    
    attr_accessor :schemes
    alias_method :attr_schemes, :schemes
    undef_method :schemes
    alias_method :attr_schemes=, :schemes=
    undef_method :schemes=
    
    typesig { [] }
    # Iterate through each header line, and then within each line.
    # If multiple entries exist for a particular scheme (unlikely)
    # then the last one will be used. The
    # preferred scheme that we support will be used.
    def parse
      iter = @rsp.multi_value_iterator(@hdrname)
      while (iter.has_next)
        raw = iter.next_
        hp = HeaderParser.new(raw)
        keys_ = hp.keys
        i = 0
        last_scheme_index = 0
        i = 0
        last_scheme_index = -1
        while keys_.has_next
          keys_.next_
          if ((hp.find_value(i)).nil?)
            # found a scheme name
            if (!(last_scheme_index).equal?(-1))
              hpn = hp.subsequence(last_scheme_index, i)
              scheme = hpn.find_key(0)
              @schemes.put(scheme, SchemeMapValue.new(hpn, raw))
            end
            last_scheme_index = i
          end
          i += 1
        end
        if (i > last_scheme_index)
          hpn = hp.subsequence(last_scheme_index, i)
          scheme = hpn.find_key(0)
          @schemes.put(scheme, SchemeMapValue.new(hpn, raw))
        end
      end
      # choose the best of them, the order is
      # negotiate -> kerberos -> digest -> ntlm -> basic
      v = nil
      if ((self.attr_auth_pref).nil? || ((v = @schemes.get(self.attr_auth_pref))).nil?)
        if ((v).nil?)
          tmp = @schemes.get("negotiate")
          if (!(tmp).nil?)
            if ((@host).nil? || !NegotiateAuthentication.is_supported(@host, "Negotiate"))
              tmp = nil
            end
            v = tmp
          end
        end
        if ((v).nil?)
          tmp = @schemes.get("kerberos")
          if (!(tmp).nil?)
            # the Kerberos scheme is only observed in MS ISA Server. In
            # fact i think it's a Kerberos-mechnism-only Negotiate.
            # Since the Kerberos scheme is always accompanied with the
            # Negotiate scheme, so it seems impossible to reach this
            # line. Even if the user explicitly set http.auth.preference
            # as Kerberos, it means Negotiate with Kerberos, and the code
            # will still tried to use Negotiate at first.
            # 
            # The only chance this line get executed is that the server
            # only suggest the Kerberos scheme.
            if ((@host).nil? || !NegotiateAuthentication.is_supported(@host, "Kerberos"))
              tmp = nil
            end
            v = tmp
          end
        end
        if ((v).nil?)
          if (((v = @schemes.get("digest"))).nil?)
            if ((((v = @schemes.get("ntlm"))).nil?))
              v = @schemes.get("basic")
            end
          end
        end
      end
      if (!(v).nil?)
        @preferred = v.attr_parser
        @preferred_r = RJava.cast_to_string(v.attr_raw)
      end
    end
    
    typesig { [] }
    # return a header parser containing the preferred authentication scheme (only).
    # The preferred scheme is the strongest of the schemes proposed by the server.
    # The returned HeaderParser will contain the relevant parameters for that scheme
    def header_parser
      return @preferred
    end
    
    typesig { [] }
    # return the name of the preferred scheme
    def scheme
      if (!(@preferred).nil?)
        return @preferred.find_key(0)
      else
        return nil
      end
    end
    
    typesig { [] }
    # return the raw header field for the preferred/chosen scheme
    def raw
      return @preferred_r
    end
    
    typesig { [] }
    # returns true is the header exists and contains a recognised scheme
    def is_present
      return !(@preferred).nil?
    end
    
    private
    alias_method :initialize__authentication_header, :initialize
  end
  
end
