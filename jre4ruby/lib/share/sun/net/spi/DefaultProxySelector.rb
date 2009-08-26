require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Spi
  module DefaultProxySelectorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Spi
      include ::Sun::Net::Www::Http
      include_const ::Sun::Net, :NetProperties
      include ::Java::Net
      include ::Java::Util
      include ::Java::Util::Regex
      include ::Java::Io
      include_const ::Sun::Misc, :RegexpPool
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # Supports proxy settings using system properties This proxy selector
  # provides backward compatibility with the old http protocol handler
  # as far as how proxy is set
  # 
  # Most of the implementation copied from the old http protocol handler
  # 
  # Supports http/https/ftp.proxyHost, http/https/ftp.proxyPort,
  # proxyHost, proxyPort, and http/https/ftp.nonProxyHost, and socks.
  # NOTE: need to do gopher as well
  class DefaultProxySelector < DefaultProxySelectorImports.const_get :ProxySelector
    include_class_members DefaultProxySelectorImports
    
    class_module.module_eval {
      # This is where we define all the valid System Properties we have to
      # support for each given protocol.
      # The format of this 2 dimensional array is :
      # - 1 row per protocol (http, ftp, ...)
      # - 1st element of each row is the protocol name
      # - subsequent elements are prefixes for Host & Port properties
      # listed in order of priority.
      # Example:
      # {"ftp", "ftp.proxy", "ftpProxy", "proxy", "socksProxy"},
      # means for FTP we try in that oder:
      # + ftp.proxyHost & ftp.proxyPort
      # + ftpProxyHost & ftpProxyPort
      # + proxyHost & proxyPort
      # + socksProxyHost & socksProxyPort
      # 
      # Note that the socksProxy should *always* be the last on the list
      # 
      # 
      # protocol, Property prefix 1, Property prefix 2, ...
      const_set_lazy(:Props) { Array.typed(Array.typed(String)).new([Array.typed(String).new(["http", "http.proxy", "proxy", "socksProxy"]), Array.typed(String).new(["https", "https.proxy", "proxy", "socksProxy"]), Array.typed(String).new(["ftp", "ftp.proxy", "ftpProxy", "proxy", "socksProxy"]), Array.typed(String).new(["gopher", "gopherProxy", "socksProxy"]), Array.typed(String).new(["socket", "socksProxy"])]) }
      const_attr_reader  :Props
      
      
      def has_system_proxies
        defined?(@@has_system_proxies) ? @@has_system_proxies : @@has_system_proxies= false
      end
      alias_method :attr_has_system_proxies, :has_system_proxies
      
      def has_system_proxies=(value)
        @@has_system_proxies = value
      end
      alias_method :attr_has_system_proxies=, :has_system_proxies=
      
      
      def defprops
        defined?(@@defprops) ? @@defprops : @@defprops= Properties.new
      end
      alias_method :attr_defprops, :defprops
      
      def defprops=(value)
        @@defprops = value
      end
      alias_method :attr_defprops=, :defprops=
      
      when_class_loaded do
        key = "java.net.useSystemProxies"
        b = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members DefaultProxySelector
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return NetProperties.get_boolean(key)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (!(b).nil? && b.boolean_value)
          Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("net"))
          self.attr_has_system_proxies = init
        end
      end
      
      # How to deal with "non proxy hosts":
      # since we do have to generate a RegexpPool we don't want to do that if
      # it's not necessary. Therefore we do cache the result, on a per-protocol
      # basis, and change it only when the "source", i.e. the system property,
      # did change.
      const_set_lazy(:NonProxyInfo) { Class.new do
        include_class_members DefaultProxySelector
        
        attr_accessor :hosts_source
        alias_method :attr_hosts_source, :hosts_source
        undef_method :hosts_source
        alias_method :attr_hosts_source=, :hosts_source=
        undef_method :hosts_source=
        
        attr_accessor :hosts_pool
        alias_method :attr_hosts_pool, :hosts_pool
        undef_method :hosts_pool
        alias_method :attr_hosts_pool=, :hosts_pool=
        undef_method :hosts_pool=
        
        attr_accessor :property
        alias_method :attr_property, :property
        undef_method :property
        alias_method :attr_property=, :property=
        undef_method :property=
        
        typesig { [self::String, self::String, self::RegexpPool] }
        def initialize(p, s, pool)
          @hosts_source = nil
          @hosts_pool = nil
          @property = nil
          @property = p
          @hosts_source = s
          @hosts_pool = pool
        end
        
        private
        alias_method :initialize__non_proxy_info, :initialize
      end }
      
      
      def ftp_non_proxy_info
        defined?(@@ftp_non_proxy_info) ? @@ftp_non_proxy_info : @@ftp_non_proxy_info= NonProxyInfo.new("ftp.nonProxyHosts", nil, nil)
      end
      alias_method :attr_ftp_non_proxy_info, :ftp_non_proxy_info
      
      def ftp_non_proxy_info=(value)
        @@ftp_non_proxy_info = value
      end
      alias_method :attr_ftp_non_proxy_info=, :ftp_non_proxy_info=
      
      
      def http_non_proxy_info
        defined?(@@http_non_proxy_info) ? @@http_non_proxy_info : @@http_non_proxy_info= NonProxyInfo.new("http.nonProxyHosts", nil, nil)
      end
      alias_method :attr_http_non_proxy_info, :http_non_proxy_info
      
      def http_non_proxy_info=(value)
        @@http_non_proxy_info = value
      end
      alias_method :attr_http_non_proxy_info=, :http_non_proxy_info=
    }
    
    typesig { [URI] }
    # select() method. Where all the hard work is done.
    # Build a list of proxies depending on URI.
    # Since we're only providing compatibility with the system properties
    # from previous releases (see list above), that list will always
    # contain 1 single proxy, default being NO_PROXY.
    def select(uri)
      if ((uri).nil?)
        raise IllegalArgumentException.new("URI can't be null.")
      end
      protocol = uri.get_scheme
      host = uri.get_host
      port = uri.get_port
      if ((host).nil?)
        # This is a hack to ensure backward compatibility in two
        # cases: 1. hostnames contain non-ascii characters,
        # internationalized domain names. in which case, URI will
        # return null, see BugID 4957669; 2. Some hostnames can
        # contain '_' chars even though it's not supposed to be
        # legal, in which case URI will return null for getHost,
        # but not for getAuthority() See BugID 4913253
        auth = uri.get_authority
        if (!(auth).nil?)
          i = 0
          i = auth.index_of(Character.new(?@.ord))
          if (i >= 0)
            auth = RJava.cast_to_string(auth.substring(i + 1))
          end
          i = auth.last_index_of(Character.new(?:.ord))
          if (i >= 0)
            begin
              port = JavaInteger.parse_int(auth.substring(i + 1))
            rescue NumberFormatException => e
              port = -1
            end
            auth = RJava.cast_to_string(auth.substring(0, i))
          end
          host = auth
        end
      end
      if ((protocol).nil? || (host).nil?)
        raise IllegalArgumentException.new("protocol = " + protocol + " host = " + host)
      end
      proxyl = ArrayList.new(1)
      # special case localhost and loopback addresses to
      # not go through proxy
      if (is_loopback(host))
        proxyl.add(Proxy::NO_PROXY)
        return proxyl
      end
      pinfo = nil
      if ("http".equals_ignore_case(protocol))
        pinfo = self.attr_http_non_proxy_info
      else
        if ("https".equals_ignore_case(protocol))
          # HTTPS uses the same property as HTTP, for backward
          # compatibility
          pinfo = self.attr_http_non_proxy_info
        else
          if ("ftp".equals_ignore_case(protocol))
            pinfo = self.attr_ftp_non_proxy_info
          end
        end
      end
      # Let's check the System properties for that protocol
      proto = protocol
      nprop = pinfo
      urlhost = host.to_lower_case
      p = AccessController.do_privileged(# This is one big doPrivileged call, but we're trying to optimize
      # the code as much as possible. Since we're checking quite a few
      # System properties it does help having only 1 call to doPrivileged.
      # Be mindful what you do in here though!
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members DefaultProxySelector
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          i = 0
          j = 0
          phost = nil
          pport = 0
          nphosts = nil
          saddr = nil
          # Then let's walk the list of protocols in our array
          i = 0
          while i < Props.attr_length
            if (Props[i][0].equals_ignore_case(proto))
              j = 1
              while j < Props[i].attr_length
                # System.getProp() will give us an empty
                # String, "" for a defined but "empty"
                # property.
                phost = RJava.cast_to_string(NetProperties.get(RJava.cast_to_string(Props[i][j]) + "Host"))
                if (!(phost).nil? && !(phost.length).equal?(0))
                  break
                end
                j += 1
              end
              if ((phost).nil? || (phost.length).equal?(0))
                # No system property defined for that
                # protocol. Let's check System Proxy
                # settings (Gnome & Windows) if we were
                # instructed to.
                if (self.attr_has_system_proxies)
                  sproto = nil
                  if (proto.equals_ignore_case("socket"))
                    sproto = "socks"
                  else
                    sproto = proto
                  end
                  sproxy = get_system_proxy(sproto, urlhost)
                  if (!(sproxy).nil?)
                    return sproxy
                  end
                end
                return Proxy::NO_PROXY
              end
              # If a Proxy Host is defined for that protocol
              # Let's get the NonProxyHosts property
              if (!(nprop).nil?)
                nphosts = RJava.cast_to_string(NetProperties.get(nprop.attr_property))
                synchronized((nprop)) do
                  if ((nphosts).nil?)
                    nprop.attr_hosts_source = nil
                    nprop.attr_hosts_pool = nil
                  else
                    if (!(nphosts == nprop.attr_hosts_source))
                      pool = self.class::RegexpPool.new
                      st = self.class::StringTokenizer.new(nphosts, "|", false)
                      begin
                        while (st.has_more_tokens)
                          pool.add(st.next_token.to_lower_case, Boolean::TRUE)
                        end
                      rescue Sun::Misc::self.class::REException => ex
                      end
                      nprop.attr_hosts_pool = pool
                      nprop.attr_hosts_source = nphosts
                    end
                  end
                  if (!(nprop.attr_hosts_pool).nil? && !(nprop.attr_hosts_pool.match(urlhost)).nil?)
                    return Proxy::NO_PROXY
                  end
                end
              end
              # We got a host, let's check for port
              pport = NetProperties.get_integer(RJava.cast_to_string(Props[i][j]) + "Port", 0).int_value
              if ((pport).equal?(0) && j < (Props[i].attr_length - 1))
                # Can't find a port with same prefix as Host
                # AND it's not a SOCKS proxy
                # Let's try the other prefixes for that proto
                k = 1
                while k < (Props[i].attr_length - 1)
                  if ((!(k).equal?(j)) && ((pport).equal?(0)))
                    pport = NetProperties.get_integer(RJava.cast_to_string(Props[i][k]) + "Port", 0).int_value
                  end
                  k += 1
                end
              end
              # Still couldn't find a port, let's use default
              if ((pport).equal?(0))
                if ((j).equal?((Props[i].attr_length - 1)))
                  # SOCKS
                  pport = default_port("socket")
                else
                  pport = default_port(proto)
                end
              end
              # We did find a proxy definition.
              # Let's create the address, but don't resolve it
              # as this will be done at connection time
              saddr = InetSocketAddress.create_unresolved(phost, pport)
              # Socks is *always* the last on the list.
              if ((j).equal?((Props[i].attr_length - 1)))
                return self.class::Proxy.new(Proxy::Type::SOCKS, saddr)
              else
                return self.class::Proxy.new(Proxy::Type::HTTP, saddr)
              end
            end
            i += 1
          end
          return Proxy::NO_PROXY
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      proxyl.add(p)
      # If no specific property was set for that URI, we should be
      # returning an iterator to an empty List.
      return proxyl
    end
    
    typesig { [URI, SocketAddress, IOException] }
    def connect_failed(uri, sa, ioe)
      if ((uri).nil? || (sa).nil? || (ioe).nil?)
        raise IllegalArgumentException.new("Arguments can't be null.")
      end
      # ignored
    end
    
    typesig { [String] }
    def default_port(protocol)
      if ("http".equals_ignore_case(protocol))
        return 80
      else
        if ("https".equals_ignore_case(protocol))
          return 443
        else
          if ("ftp".equals_ignore_case(protocol))
            return 80
          else
            if ("socket".equals_ignore_case(protocol))
              return 1080
            else
              if ("gopher".equals_ignore_case(protocol))
                return 80
              else
                return -1
              end
            end
          end
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:P6) { Pattern.compile("::1|(0:){7}1|(0:){1,6}:1") }
      const_attr_reader  :P6
    }
    
    typesig { [String] }
    def is_loopback(host)
      if ((host).nil? || (host.length).equal?(0))
        return false
      end
      if (host.equals_ignore_case("localhost"))
        return true
      end
      # The string could represent a numerical IP address.
      # For IPv4 addresses, check whether it starts with 127.
      # For IPv6 addresses, check whether it is ::1 or its equivalent.
      # Don't check IPv4-mapped or IPv4-compatible addresses
      if (host.starts_with("127."))
        # possible IPv4 loopback address
        p = 4
        q = 0
        n = host.length
        # Per RFC2732: At most three digits per byte
        # Further constraint: Each element fits in a byte
        if ((q = scan_byte(host, p, n)) <= p)
          return false
        end
        p = q
        if ((q = scan(host, p, n, Character.new(?..ord))) <= p)
          return (q).equal?(n) && @number > 0
        end
        p = q
        if ((q = scan_byte(host, p, n)) <= p)
          return false
        end
        p = q
        if ((q = scan(host, p, n, Character.new(?..ord))) <= p)
          return (q).equal?(n) && @number > 0
        end
        p = q
        if ((q = scan_byte(host, p, n)) <= p)
          return false
        end
        return (q).equal?(n) && @number > 0
      end
      if (host.ends_with(":1"))
        return P6.matcher(host).matches
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [::Java::Char, ::Java::Char] }
      # Character-class masks, in reverse order from RFC2396 because
      # initializers for static fields cannot make forward references.
      # Compute a low-order mask for the characters
      # between first and last, inclusive
      def low_mask(first, last)
        m = 0
        f = Math.max(Math.min(first, 63), 0)
        l = Math.max(Math.min(last, 63), 0)
        i = f
        while i <= l
          m |= 1 << i
          i += 1
        end
        return m
      end
      
      # digit    = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" |
      # "8" | "9"
      const_set_lazy(:L_DIGIT) { low_mask(Character.new(?0.ord), Character.new(?9.ord)) }
      const_attr_reader  :L_DIGIT
      
      const_set_lazy(:H_DIGIT) { 0 }
      const_attr_reader  :H_DIGIT
    }
    
    # Scan a string of decimal digits whose value fits in a byte
    attr_accessor :number
    alias_method :attr_number, :number
    undef_method :number
    alias_method :attr_number=, :number=
    undef_method :number=
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    def scan_byte(input, start, n)
      p = start
      q = scan(input, p, n, L_DIGIT, H_DIGIT)
      if (q <= p)
        return q
      end
      @number = JavaInteger.parse_int(input.substring(p, q))
      if (@number > 255)
        return p
      end
      return q
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Char] }
    # Scan a specific char: If the char at the given start position is
    # equal to c, return the index of the next char; otherwise, return the
    # start position.
    def scan(input, start, end_, c)
      if ((start < end_) && ((input.char_at(start)).equal?(c)))
        return start + 1
      end
      return start
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Long, ::Java::Long] }
    # Scan chars that match the given mask pair
    def scan(input, start, n, low_mask_, high_mask)
      p = start
      while (p < n)
        c = input.char_at(p)
        if (match(c, low_mask_, high_mask))
          p += 1
          next
        end
        break
      end
      return p
    end
    
    typesig { [::Java::Char, ::Java::Long, ::Java::Long] }
    # Tell whether the given character is permitted by the given mask pair
    def match(c, low_mask_, high_mask)
      if (c < 64)
        return !(((1 << c) & low_mask_)).equal?(0)
      end
      if (c < 128)
        return !(((1 << (c - 64)) & high_mask)).equal?(0)
      end
      return false
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_net_spi_DefaultProxySelector_init, [:pointer, :long], :int8
      typesig { [] }
      def init
        JNI.__send__(:Java_sun_net_spi_DefaultProxySelector_init, JNI.env, self.jni_id) != 0
      end
    }
    
    JNI.native_method :Java_sun_net_spi_DefaultProxySelector_getSystemProxy, [:pointer, :long, :long, :long], :long
    typesig { [String, String] }
    def get_system_proxy(protocol, host)
      JNI.__send__(:Java_sun_net_spi_DefaultProxySelector_getSystemProxy, JNI.env, self.jni_id, protocol.jni_id, host.jni_id)
    end
    
    typesig { [] }
    def initialize
      @number = 0
      super()
    end
    
    private
    alias_method :initialize__default_proxy_selector, :initialize
  end
  
end
