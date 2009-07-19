require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module SocketPermissionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :PermissionCollection
      include_const ::Java::Security, :Policy
      include_const ::Java::Io, :Serializable
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
      include_const ::Sun::Net::Util, :IPAddressUtil
      include_const ::Sun::Security::Util, :SecurityConstants
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # public String toString()
  # {
  # StringBuffer s = new StringBuffer(super.toString() + "\n" +
  # "cname = " + cname + "\n" +
  # "wildcard = " + wildcard + "\n" +
  # "invalid = " + invalid + "\n" +
  # "portrange = " + portrange[0] + "," + portrange[1] + "\n");
  # if (addresses != null) for (int i=0; i<addresses.length; i++) {
  # s.append( addresses[i].getHostAddress());
  # s.append("\n");
  # } else {
  # s.append("(no addresses)\n");
  # }
  # 
  # return s.toString();
  # }
  # 
  # public static void main(String args[]) throws Exception {
  # SocketPermission this_ = new SocketPermission(args[0], "connect");
  # SocketPermission that_ = new SocketPermission(args[1], "connect");
  # System.out.println("-----\n");
  # System.out.println("this.implies(that) = " + this_.implies(that_));
  # System.out.println("-----\n");
  # System.out.println("this = "+this_);
  # System.out.println("-----\n");
  # System.out.println("that = "+that_);
  # System.out.println("-----\n");
  # 
  # SocketPermissionCollection nps = new SocketPermissionCollection();
  # nps.add(this_);
  # nps.add(new SocketPermission("www-leland.stanford.edu","connect"));
  # nps.add(new SocketPermission("www-sun.com","connect"));
  # System.out.println("nps.implies(that) = " + nps.implies(that_));
  # System.out.println("-----\n");
  # }
  # 
  # 
  # This class represents access to a network via sockets.
  # A SocketPermission consists of a
  # host specification and a set of "actions" specifying ways to
  # connect to that host. The host is specified as
  # <pre>
  # host = (hostname | IPv4address | iPv6reference) [:portrange]
  # portrange = portnumber | -portnumber | portnumber-[portnumber]
  # </pre>
  # The host is expressed as a DNS name, as a numerical IP address,
  # or as "localhost" (for the local machine).
  # The wildcard "*" may be included once in a DNS name host
  # specification. If it is included, it must be in the leftmost
  # position, as in "*.sun.com".
  # <p>
  # The format of the IPv6reference should follow that specified in <a
  # href="http://www.ietf.org/rfc/rfc2732.txt"><i>RFC&nbsp;2732: Format
  # for Literal IPv6 Addresses in URLs</i></a>:
  # <pre>
  # ipv6reference = "[" IPv6address "]"
  # </pre>
  # For example, you can construct a SocketPermission instance
  # as the following:
  # <pre>
  # String hostAddress = inetaddress.getHostAddress();
  # if (inetaddress instanceof Inet6Address) {
  # sp = new SocketPermission("[" + hostAddress + "]:" + port, action);
  # } else {
  # sp = new SocketPermission(hostAddress + ":" + port, action);
  # }
  # </pre>
  # or
  # <pre>
  # String host = url.getHost();
  # sp = new SocketPermission(host + ":" + port, action);
  # </pre>
  # <p>
  # The <A HREF="Inet6Address.html#lform">full uncompressed form</A> of
  # an IPv6 literal address is also valid.
  # <p>
  # The port or portrange is optional. A port specification of the
  # form "N-", where <i>N</i> is a port number, signifies all ports
  # numbered <i>N</i> and above, while a specification of the
  # form "-N" indicates all ports numbered <i>N</i> and below.
  # <p>
  # The possible ways to connect to the host are
  # <pre>
  # accept
  # connect
  # listen
  # resolve
  # </pre>
  # The "listen" action is only meaningful when used with "localhost".
  # The "resolve" action is implied when any of the other actions are present.
  # The action "resolve" refers to host/ip name service lookups.
  # 
  # <p>As an example of the creation and meaning of SocketPermissions,
  # note that if the following permission:
  # 
  # <pre>
  # p1 = new SocketPermission("puffin.eng.sun.com:7777", "connect,accept");
  # </pre>
  # 
  # is granted to some code, it allows that code to connect to port 7777 on
  # <code>puffin.eng.sun.com</code>, and to accept connections on that port.
  # 
  # <p>Similarly, if the following permission:
  # 
  # <pre>
  # p1 = new SocketPermission("puffin.eng.sun.com:7777", "connect,accept");
  # p2 = new SocketPermission("localhost:1024-", "accept,connect,listen");
  # </pre>
  # 
  # is granted to some code, it allows that code to
  # accept connections on, connect to, or listen on any port between
  # 1024 and 65535 on the local host.
  # 
  # <p>Note: Granting code permission to accept or make connections to remote
  # hosts may be dangerous because malevolent code can then more easily
  # transfer and share confidential data among parties who may not
  # otherwise have access to the data.
  # 
  # @see java.security.Permissions
  # @see SocketPermission
  # 
  # 
  # @author Marianne Mueller
  # @author Roland Schemers
  # 
  # @serial exclude
  class SocketPermission < SocketPermissionImports.const_get :Permission
    include_class_members SocketPermissionImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7204263841984476862 }
      const_attr_reader  :SerialVersionUID
      
      # Connect to host:port
      const_set_lazy(:CONNECT) { 0x1 }
      const_attr_reader  :CONNECT
      
      # Listen on host:port
      const_set_lazy(:LISTEN) { 0x2 }
      const_attr_reader  :LISTEN
      
      # Accept a connection from host:port
      const_set_lazy(:ACCEPT) { 0x4 }
      const_attr_reader  :ACCEPT
      
      # Resolve DNS queries
      const_set_lazy(:RESOLVE) { 0x8 }
      const_attr_reader  :RESOLVE
      
      # No actions
      const_set_lazy(:NONE) { 0x0 }
      const_attr_reader  :NONE
      
      # All actions
      const_set_lazy(:ALL) { CONNECT | LISTEN | ACCEPT | RESOLVE }
      const_attr_reader  :ALL
      
      # various port constants
      const_set_lazy(:PORT_MIN) { 0 }
      const_attr_reader  :PORT_MIN
      
      const_set_lazy(:PORT_MAX) { 65535 }
      const_attr_reader  :PORT_MAX
      
      const_set_lazy(:PRIV_PORT_MAX) { 1023 }
      const_attr_reader  :PRIV_PORT_MAX
    }
    
    # the actions mask
    attr_accessor :mask
    alias_method :attr_mask, :mask
    undef_method :mask
    alias_method :attr_mask=, :mask=
    undef_method :mask=
    
    # the actions string.
    # 
    # @serial
    attr_accessor :actions
    alias_method :attr_actions, :actions
    undef_method :actions
    alias_method :attr_actions=, :actions=
    undef_method :actions=
    
    # Left null as long as possible, then
    # created and re-used in the getAction function.
    # hostname part as it is passed
    attr_accessor :hostname
    alias_method :attr_hostname, :hostname
    undef_method :hostname
    alias_method :attr_hostname=, :hostname=
    undef_method :hostname=
    
    # the canonical name of the host
    # in the case of "*.foo.com", cname is ".foo.com".
    attr_accessor :cname
    alias_method :attr_cname, :cname
    undef_method :cname
    alias_method :attr_cname=, :cname=
    undef_method :cname=
    
    # all the IP addresses of the host
    attr_accessor :addresses
    alias_method :attr_addresses, :addresses
    undef_method :addresses
    alias_method :attr_addresses=, :addresses=
    undef_method :addresses=
    
    # true if the hostname is a wildcard (e.g. "*.sun.com")
    attr_accessor :wildcard
    alias_method :attr_wildcard, :wildcard
    undef_method :wildcard
    alias_method :attr_wildcard=, :wildcard=
    undef_method :wildcard=
    
    # true if we were initialized with a single numeric IP address
    attr_accessor :init_with_ip
    alias_method :attr_init_with_ip, :init_with_ip
    undef_method :init_with_ip
    alias_method :attr_init_with_ip=, :init_with_ip=
    undef_method :init_with_ip=
    
    # true if this SocketPermission represents an invalid/unknown host
    # used for implies when the delayed lookup has already failed
    attr_accessor :invalid
    alias_method :attr_invalid, :invalid
    undef_method :invalid
    alias_method :attr_invalid=, :invalid=
    undef_method :invalid=
    
    # port range on host
    attr_accessor :portrange
    alias_method :attr_portrange, :portrange
    undef_method :portrange
    alias_method :attr_portrange=, :portrange=
    undef_method :portrange=
    
    attr_accessor :default_deny
    alias_method :attr_default_deny, :default_deny
    undef_method :default_deny
    alias_method :attr_default_deny=, :default_deny=
    undef_method :default_deny=
    
    # true if this SocketPermission represents a hostname
    # that failed our reverse mapping heuristic test
    attr_accessor :untrusted
    alias_method :attr_untrusted, :untrusted
    undef_method :untrusted
    alias_method :attr_untrusted=, :untrusted=
    undef_method :untrusted=
    
    class_module.module_eval {
      # true if the trustProxy system property is set
      
      def trust_proxy
        defined?(@@trust_proxy) ? @@trust_proxy : @@trust_proxy= false
      end
      alias_method :attr_trust_proxy, :trust_proxy
      
      def trust_proxy=(value)
        @@trust_proxy = value
      end
      alias_method :attr_trust_proxy=, :trust_proxy=
      
      # true if the sun.net.trustNameService system property is set
      
      def trust_name_service
        defined?(@@trust_name_service) ? @@trust_name_service : @@trust_name_service= false
      end
      alias_method :attr_trust_name_service, :trust_name_service
      
      def trust_name_service=(value)
        @@trust_name_service = value
      end
      alias_method :attr_trust_name_service=, :trust_name_service=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= nil
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      
      def debug_init
        defined?(@@debug_init) ? @@debug_init : @@debug_init= false
      end
      alias_method :attr_debug_init, :debug_init
      
      def debug_init=(value)
        @@debug_init = value
      end
      alias_method :attr_debug_init=, :debug_init=
      
      when_class_loaded do
        tmp = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("trustProxy"))
        self.attr_trust_proxy = tmp.boolean_value
        tmp = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.net.trustNameService"))
        self.attr_trust_name_service = tmp.boolean_value
      end
      
      typesig { [] }
      def get_debug
        synchronized(self) do
          if (!self.attr_debug_init)
            self.attr_debug = Debug.get_instance("access")
            self.attr_debug_init = true
          end
          return self.attr_debug
        end
      end
    }
    
    typesig { [String, String] }
    # Creates a new SocketPermission object with the specified actions.
    # The host is expressed as a DNS name, or as a numerical IP address.
    # Optionally, a port or a portrange may be supplied (separated
    # from the DNS name or IP address by a colon).
    # <p>
    # To specify the local machine, use "localhost" as the <i>host</i>.
    # Also note: An empty <i>host</i> String ("") is equivalent to "localhost".
    # <p>
    # The <i>actions</i> parameter contains a comma-separated list of the
    # actions granted for the specified host (and port(s)). Possible actions are
    # "connect", "listen", "accept", "resolve", or
    # any combination of those. "resolve" is automatically added
    # when any of the other three are specified.
    # <p>
    # Examples of SocketPermission instantiation are the following:
    # <pre>
    # nr = new SocketPermission("www.catalog.com", "connect");
    # nr = new SocketPermission("www.sun.com:80", "connect");
    # nr = new SocketPermission("*.sun.com", "connect");
    # nr = new SocketPermission("*.edu", "resolve");
    # nr = new SocketPermission("204.160.241.0", "connect");
    # nr = new SocketPermission("localhost:1024-65535", "listen");
    # nr = new SocketPermission("204.160.241.0:1024-65535", "connect");
    # </pre>
    # 
    # @param host the hostname or IPaddress of the computer, optionally
    # including a colon followed by a port or port range.
    # @param action the action string.
    def initialize(host, action)
      @mask = 0
      @actions = nil
      @hostname = nil
      @cname = nil
      @addresses = nil
      @wildcard = false
      @init_with_ip = false
      @invalid = false
      @portrange = nil
      @default_deny = false
      @untrusted = false
      super(get_host(host))
      @default_deny = false
      # name initialized to getHost(host); NPE detected in getHost()
      init(get_name, get_mask(action))
    end
    
    typesig { [String, ::Java::Int] }
    def initialize(host, mask)
      @mask = 0
      @actions = nil
      @hostname = nil
      @cname = nil
      @addresses = nil
      @wildcard = false
      @init_with_ip = false
      @invalid = false
      @portrange = nil
      @default_deny = false
      @untrusted = false
      super(get_host(host))
      @default_deny = false
      # name initialized to getHost(host); NPE detected in getHost()
      init(get_name, mask)
    end
    
    typesig { [] }
    def set_deny
      @default_deny = true
    end
    
    class_module.module_eval {
      typesig { [String] }
      def get_host(host)
        if ((host == ""))
          return "localhost"
        else
          # IPv6 literal address used in this context should follow
          # the format specified in RFC 2732;
          # if not, we try to solve the unambiguous case
          ind = 0
          if (!(host.char_at(0)).equal?(Character.new(?[.ord)))
            if (!((ind = host.index_of(Character.new(?:.ord)))).equal?(host.last_index_of(Character.new(?:.ord))))
              # More than one ":", meaning IPv6 address is not
              # in RFC 2732 format;
              # We will rectify user errors for all unambiguious cases
              st = StringTokenizer.new(host, ":")
              tokens = st.count_tokens
              if ((tokens).equal?(9))
                # IPv6 address followed by port
                ind = host.last_index_of(Character.new(?:.ord))
                host = "[" + (host.substring(0, ind)).to_s + "]" + (host.substring(ind)).to_s
              else
                if ((tokens).equal?(8) && (host.index_of("::")).equal?(-1))
                  # IPv6 address only, not followed by port
                  host = "[" + host + "]"
                else
                  # could be ambiguous
                  raise IllegalArgumentException.new("Ambiguous" + " hostport part")
                end
              end
            end
          end
          return host
        end
      end
    }
    
    typesig { [String] }
    def parse_port(port)
      if ((port).nil? || (port == "") || (port == "*"))
        return Array.typed(::Java::Int).new([PORT_MIN, PORT_MAX])
      end
      dash = port.index_of(Character.new(?-.ord))
      if ((dash).equal?(-1))
        p = JavaInteger.parse_int(port)
        return Array.typed(::Java::Int).new([p, p])
      else
        low = port.substring(0, dash)
        high = port.substring(dash + 1)
        l = 0
        h = 0
        if ((low == ""))
          l = PORT_MIN
        else
          l = JavaInteger.parse_int(low)
        end
        if ((high == ""))
          h = PORT_MAX
        else
          h = JavaInteger.parse_int(high)
        end
        if (l < 0 || h < 0 || h < l)
          raise IllegalArgumentException.new("invalid port range")
        end
        return Array.typed(::Java::Int).new([l, h])
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Initialize the SocketPermission object. We don't do any DNS lookups
    # as this point, instead we hold off until the implies method is
    # called.
    def init(host, mask)
      # Set the integer mask that represents the actions
      if (!((mask & ALL)).equal?(mask))
        raise IllegalArgumentException.new("invalid actions mask")
      end
      # always OR in RESOLVE if we allow any of the others
      @mask = mask | RESOLVE
      # Parse the host name.  A name has up to three components, the
      # hostname, a port number, or two numbers representing a port
      # range.   "www.sun.com:8080-9090" is a valid host name.
      # With IPv6 an address can be 2010:836B:4179::836B:4179
      # An IPv6 address needs to be enclose in []
      # For ex: [2010:836B:4179::836B:4179]:8080-9090
      # Refer to RFC 2732 for more information.
      rb = 0
      start = 0
      end_ = 0
      sep = -1
      hostport = host
      if ((host.char_at(0)).equal?(Character.new(?[.ord)))
        start = 1
        rb = host.index_of(Character.new(?].ord))
        if (!(rb).equal?(-1))
          host = (host.substring(start, rb)).to_s
        else
          raise IllegalArgumentException.new("invalid host/port: " + host)
        end
        sep = hostport.index_of(Character.new(?:.ord), rb + 1)
      else
        start = 0
        sep = host.index_of(Character.new(?:.ord), rb)
        end_ = sep
        if (!(sep).equal?(-1))
          host = (host.substring(start, end_)).to_s
        end
      end
      if (!(sep).equal?(-1))
        port = hostport.substring(sep + 1)
        begin
          @portrange = parse_port(port)
        rescue Exception => e
          raise IllegalArgumentException.new("invalid port range: " + port)
        end
      else
        @portrange = Array.typed(::Java::Int).new([PORT_MIN, PORT_MAX])
      end
      @hostname = host
      # is this a domain wildcard specification
      if (host.last_index_of(Character.new(?*.ord)) > 0)
        raise IllegalArgumentException.new("invalid host wildcard specification")
      else
        if (host.starts_with("*"))
          @wildcard = true
          if ((host == "*"))
            @cname = ""
          else
            if (host.starts_with("*."))
              @cname = (host.substring(1).to_lower_case).to_s
            else
              raise IllegalArgumentException.new("invalid host wildcard specification")
            end
          end
          return
        else
          if (host.length > 0)
            # see if we are being initialized with an IP address.
            ch = host.char_at(0)
            if ((ch).equal?(Character.new(?:.ord)) || !(Character.digit(ch, 16)).equal?(-1))
              ip = IPAddressUtil.text_to_numeric_format_v4(host)
              if ((ip).nil?)
                ip = IPAddressUtil.text_to_numeric_format_v6(host)
              end
              if (!(ip).nil?)
                begin
                  @addresses = Array.typed(InetAddress).new([InetAddress.get_by_address(ip)])
                  @init_with_ip = true
                rescue UnknownHostException => uhe
                  # this shouldn't happen
                  @invalid = true
                end
              end
            end
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Convert an action string to an integer actions mask.
      # 
      # @param action the action string
      # @return the action mask
      def get_mask(action)
        if ((action).nil?)
          raise NullPointerException.new("action can't be null")
        end
        if ((action == ""))
          raise IllegalArgumentException.new("action can't be empty")
        end
        mask = NONE
        # Check against use of constants (used heavily within the JDK)
        if ((action).equal?(SecurityConstants::SOCKET_RESOLVE_ACTION))
          return RESOLVE
        else
          if ((action).equal?(SecurityConstants::SOCKET_CONNECT_ACTION))
            return CONNECT
          else
            if ((action).equal?(SecurityConstants::SOCKET_LISTEN_ACTION))
              return LISTEN
            else
              if ((action).equal?(SecurityConstants::SOCKET_ACCEPT_ACTION))
                return ACCEPT
              else
                if ((action).equal?(SecurityConstants::SOCKET_CONNECT_ACCEPT_ACTION))
                  return CONNECT | ACCEPT
                end
              end
            end
          end
        end
        a = action.to_char_array
        i = a.attr_length - 1
        if (i < 0)
          return mask
        end
        while (!(i).equal?(-1))
          c = 0
          # skip whitespace
          while ((!(i).equal?(-1)) && (((c = a[i])).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\r.ord)) || (c).equal?(Character.new(?\n.ord)) || (c).equal?(Character.new(?\f.ord)) || (c).equal?(Character.new(?\t.ord))))
            ((i -= 1) + 1)
          end
          # check for the known strings
          matchlen = 0
          if (i >= 6 && ((a[i - 6]).equal?(Character.new(?c.ord)) || (a[i - 6]).equal?(Character.new(?C.ord))) && ((a[i - 5]).equal?(Character.new(?o.ord)) || (a[i - 5]).equal?(Character.new(?O.ord))) && ((a[i - 4]).equal?(Character.new(?n.ord)) || (a[i - 4]).equal?(Character.new(?N.ord))) && ((a[i - 3]).equal?(Character.new(?n.ord)) || (a[i - 3]).equal?(Character.new(?N.ord))) && ((a[i - 2]).equal?(Character.new(?e.ord)) || (a[i - 2]).equal?(Character.new(?E.ord))) && ((a[i - 1]).equal?(Character.new(?c.ord)) || (a[i - 1]).equal?(Character.new(?C.ord))) && ((a[i]).equal?(Character.new(?t.ord)) || (a[i]).equal?(Character.new(?T.ord))))
            matchlen = 7
            mask |= CONNECT
          else
            if (i >= 6 && ((a[i - 6]).equal?(Character.new(?r.ord)) || (a[i - 6]).equal?(Character.new(?R.ord))) && ((a[i - 5]).equal?(Character.new(?e.ord)) || (a[i - 5]).equal?(Character.new(?E.ord))) && ((a[i - 4]).equal?(Character.new(?s.ord)) || (a[i - 4]).equal?(Character.new(?S.ord))) && ((a[i - 3]).equal?(Character.new(?o.ord)) || (a[i - 3]).equal?(Character.new(?O.ord))) && ((a[i - 2]).equal?(Character.new(?l.ord)) || (a[i - 2]).equal?(Character.new(?L.ord))) && ((a[i - 1]).equal?(Character.new(?v.ord)) || (a[i - 1]).equal?(Character.new(?V.ord))) && ((a[i]).equal?(Character.new(?e.ord)) || (a[i]).equal?(Character.new(?E.ord))))
              matchlen = 7
              mask |= RESOLVE
            else
              if (i >= 5 && ((a[i - 5]).equal?(Character.new(?l.ord)) || (a[i - 5]).equal?(Character.new(?L.ord))) && ((a[i - 4]).equal?(Character.new(?i.ord)) || (a[i - 4]).equal?(Character.new(?I.ord))) && ((a[i - 3]).equal?(Character.new(?s.ord)) || (a[i - 3]).equal?(Character.new(?S.ord))) && ((a[i - 2]).equal?(Character.new(?t.ord)) || (a[i - 2]).equal?(Character.new(?T.ord))) && ((a[i - 1]).equal?(Character.new(?e.ord)) || (a[i - 1]).equal?(Character.new(?E.ord))) && ((a[i]).equal?(Character.new(?n.ord)) || (a[i]).equal?(Character.new(?N.ord))))
                matchlen = 6
                mask |= LISTEN
              else
                if (i >= 5 && ((a[i - 5]).equal?(Character.new(?a.ord)) || (a[i - 5]).equal?(Character.new(?A.ord))) && ((a[i - 4]).equal?(Character.new(?c.ord)) || (a[i - 4]).equal?(Character.new(?C.ord))) && ((a[i - 3]).equal?(Character.new(?c.ord)) || (a[i - 3]).equal?(Character.new(?C.ord))) && ((a[i - 2]).equal?(Character.new(?e.ord)) || (a[i - 2]).equal?(Character.new(?E.ord))) && ((a[i - 1]).equal?(Character.new(?p.ord)) || (a[i - 1]).equal?(Character.new(?P.ord))) && ((a[i]).equal?(Character.new(?t.ord)) || (a[i]).equal?(Character.new(?T.ord))))
                  matchlen = 6
                  mask |= ACCEPT
                else
                  # parse error
                  raise IllegalArgumentException.new("invalid permission: " + action)
                end
              end
            end
          end
          # make sure we didn't just match the tail of a word
          # like "ackbarfaccept".  Also, skip to the comma.
          seencomma = false
          while (i >= matchlen && !seencomma)
            case (a[i - matchlen])
            # FALLTHROUGH
            when Character.new(?,.ord)
              seencomma = true
            when Character.new(?\s.ord), Character.new(?\r.ord), Character.new(?\n.ord), Character.new(?\f.ord), Character.new(?\t.ord)
            else
              raise IllegalArgumentException.new("invalid permission: " + action)
            end
            ((i -= 1) + 1)
          end
          # point i at the location of the comma minus one (or -1).
          i -= matchlen
        end
        return mask
      end
    }
    
    typesig { [] }
    # attempt to get the fully qualified domain name
    def get_canon_name
      if (!(@cname).nil? || @invalid || @untrusted)
        return
      end
      # attempt to get the canonical name
      begin
        # first get the IP addresses if we don't have them yet
        # this is because we need the IP address to then get
        # FQDN.
        if ((@addresses).nil?)
          get_ip
        end
        # we have to do this check, otherwise we might not
        # get the fully qualified domain name
        if (@init_with_ip)
          @cname = (@addresses[0].get_host_name(false).to_lower_case).to_s
        else
          @cname = (InetAddress.get_by_name(@addresses[0].get_host_address).get_host_name(false).to_lower_case).to_s
          if (!self.attr_trust_name_service && Sun::Net::Www::URLConnection.is_proxied_host(@hostname))
            if (!match(@cname, @hostname) && (@default_deny || !(@cname == @addresses[0].get_host_address)))
              # Last chance
              if (!authorized(@hostname, @addresses[0].get_address))
                @untrusted = true
                debug = get_debug
                if (!(debug).nil? && Debug.is_on("failure"))
                  debug.println("socket access restriction: proxied host " + "(" + (@addresses[0]).to_s + ")" + " does not match " + @cname + " from reverse lookup")
                end
              end
            end
          end
        end
      rescue UnknownHostException => uhe
        @invalid = true
        raise uhe
      end
    end
    
    typesig { [String, String] }
    def match(cname, hname)
      a = cname.to_lower_case
      b = hname.to_lower_case
      if (a.starts_with(b) && (((a.length).equal?(b.length)) || ((a.char_at(b.length)).equal?(Character.new(?..ord)))))
        return true
      end
      if (b.ends_with(".akamai.net") || b.ends_with(".akamai.com"))
        return true
      end
      af = fragment(a)
      bf = fragment(b)
      return !(af.length).equal?(0) && !(bf.length).equal?(0) && (fragment(a) == fragment(b))
    end
    
    typesig { [String] }
    # www.sun.com. -> sun.com
    # www.sun.co.uk -> sun.co.uk
    # www.sun.com.au -> sun.com.au
    def fragment(cname)
      dot = 0
      dot = cname.last_index_of(Character.new(?..ord))
      if ((dot).equal?(-1))
        return cname
      end
      if ((dot).equal?(0))
        return ""
      end
      if ((dot).equal?(cname.length - 1))
        cname = (cname.substring(0, cname.length - 1)).to_s
        dot = cname.last_index_of(Character.new(?..ord))
      end
      if (dot < 1)
        return ""
      end
      second = cname.last_index_of(Character.new(?..ord), dot - 1)
      if ((second).equal?(-1))
        return cname
      end
      if (((cname.length - dot) <= 3) && ((dot - second) <= 4) && second > 0)
        if ((dot - second).equal?(4))
          s = cname.substring(second + 1, dot)
          if (!((s == "com") || (s == "org") || (s == "edu")))
            return cname.substring(second + 1)
          end
        end
        third = cname.last_index_of(Character.new(?..ord), second - 1)
        if ((third).equal?(-1))
          return cname.substring(second + 1)
        else
          return cname.substring(third + 1)
        end
      end
      return cname.substring(second + 1)
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    def authorized(cname, addr)
      if ((addr.attr_length).equal?(4))
        return authorized_ipv4(cname, addr)
      else
        if ((addr.attr_length).equal?(16))
          return authorized_ipv6(cname, addr)
        else
          return false
        end
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    def authorized_ipv4(cname, addr)
      auth_host = ""
      auth = nil
      begin
        auth_host = "auth." + ((addr[3] & 0xff)).to_s + "." + ((addr[2] & 0xff)).to_s + "." + ((addr[1] & 0xff)).to_s + "." + ((addr[0] & 0xff)).to_s + ".in-addr.arpa"
        # auth = InetAddress.getAllByName0(authHost, false)[0];
        auth_host = @hostname + (Character.new(?..ord)).to_s + auth_host
        auth = InetAddress.get_all_by_name0(auth_host, false)[0]
        if ((auth == InetAddress.get_by_address(addr)))
          return true
        end
        debug = get_debug
        if (!(debug).nil? && Debug.is_on("failure"))
          debug.println("socket access restriction: IP address of " + (auth).to_s + " != " + (InetAddress.get_by_address(addr)).to_s)
        end
      rescue UnknownHostException => uhe
        debug_ = get_debug
        if (!(debug_).nil? && Debug.is_on("failure"))
          debug_.println("socket access restriction: forward lookup failed for " + auth_host)
        end
      rescue IOException => x
      end
      return false
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    def authorized_ipv6(cname, addr)
      auth_host = ""
      auth = nil
      begin
        sb = StringBuffer.new(39)
        i = 15
        while i >= 0
          sb.append(JavaInteger.to_hex_string(((addr[i]) & 0xf)))
          sb.append(Character.new(?..ord))
          sb.append(JavaInteger.to_hex_string(((addr[i] >> 4) & 0xf)))
          sb.append(Character.new(?..ord))
          ((i -= 1) + 1)
        end
        auth_host = "auth." + (sb.to_s).to_s + "IP6.ARPA"
        # auth = InetAddress.getAllByName0(authHost, false)[0];
        auth_host = @hostname + (Character.new(?..ord)).to_s + auth_host
        auth = InetAddress.get_all_by_name0(auth_host, false)[0]
        if ((auth == InetAddress.get_by_address(addr)))
          return true
        end
        debug = get_debug
        if (!(debug).nil? && Debug.is_on("failure"))
          debug.println("socket access restriction: IP address of " + (auth).to_s + " != " + (InetAddress.get_by_address(addr)).to_s)
        end
      rescue UnknownHostException => uhe
        debug_ = get_debug
        if (!(debug_).nil? && Debug.is_on("failure"))
          debug_.println("socket access restriction: forward lookup failed for " + auth_host)
        end
      rescue IOException => x
      end
      return false
    end
    
    typesig { [] }
    # get IP addresses. Sets invalid to true if we can't get them.
    def get_ip
      if (!(@addresses).nil? || @wildcard || @invalid)
        return
      end
      begin
        # now get all the IP addresses
        host = nil
        if ((get_name.char_at(0)).equal?(Character.new(?[.ord)))
          # Literal IPv6 address
          host = (get_name.substring(1, get_name.index_of(Character.new(?].ord)))).to_s
        else
          i = get_name.index_of(":")
          if ((i).equal?(-1))
            host = (get_name).to_s
          else
            host = (get_name.substring(0, i)).to_s
          end
        end
        @addresses = Array.typed(InetAddress).new([InetAddress.get_all_by_name0(host, false)[0]])
      rescue UnknownHostException => uhe
        @invalid = true
        raise uhe
      rescue IndexOutOfBoundsException => iobe
        @invalid = true
        raise UnknownHostException.new(get_name)
      end
    end
    
    typesig { [Permission] }
    # Checks if this socket permission object "implies" the
    # specified permission.
    # <P>
    # More specifically, this method first ensures that all of the following
    # are true (and returns false if any of them are not):<p>
    # <ul>
    # <li> <i>p</i> is an instanceof SocketPermission,<p>
    # <li> <i>p</i>'s actions are a proper subset of this
    # object's actions, and<p>
    # <li> <i>p</i>'s port range is included in this port range. Note:
    # port range is ignored when p only contains the action, 'resolve'.<p>
    # </ul>
    # 
    # Then <code>implies</code> checks each of the following, in order,
    # and for each returns true if the stated condition is true:<p>
    # <ul>
    # <li> If this object was initialized with a single IP address and one of <i>p</i>'s
    # IP addresses is equal to this object's IP address.<p>
    # <li>If this object is a wildcard domain (such as *.sun.com), and
    # <i>p</i>'s canonical name (the name without any preceding *)
    # ends with this object's canonical host name. For example, *.sun.com
    # implies *.eng.sun.com..<p>
    # <li>If this object was not initialized with a single IP address, and one of this
    # object's IP addresses equals one of <i>p</i>'s IP addresses.<p>
    # <li>If this canonical name equals <i>p</i>'s canonical name.<p>
    # </ul>
    # 
    # If none of the above are true, <code>implies</code> returns false.
    # @param p the permission to check against.
    # 
    # @return true if the specified permission is implied by this object,
    # false if not.
    def implies(p)
      i = 0
      j = 0
      if (!(p.is_a?(SocketPermission)))
        return false
      end
      if ((p).equal?(self))
        return true
      end
      that = p
      return (((@mask & that.attr_mask)).equal?(that.attr_mask)) && implies_ignore_mask(that)
    end
    
    typesig { [SocketPermission] }
    # Checks if the incoming Permission's action are a proper subset of
    # the this object's actions.
    # <P>
    # Check, in the following order:
    # <ul>
    # <li> Checks that "p" is an instanceof a SocketPermission
    # <li> Checks that "p"'s actions are a proper subset of the
    # current object's actions.
    # <li> Checks that "p"'s port range is included in this port range
    # <li> If this object was initialized with an IP address, checks that
    # one of "p"'s IP addresses is equal to this object's IP address.
    # <li> If either object is a wildcard domain (i.e., "*.sun.com"),
    # attempt to match based on the wildcard.
    # <li> If this object was not initialized with an IP address, attempt
    # to find a match based on the IP addresses in both objects.
    # <li> Attempt to match on the canonical hostnames of both objects.
    # </ul>
    # @param p the incoming permission request
    # 
    # @return true if "permission" is a proper subset of the current object,
    # false if not.
    def implies_ignore_mask(that)
      i = 0
      j = 0
      if (!((that.attr_mask & RESOLVE)).equal?(that.attr_mask))
        # check port range
        if ((that.attr_portrange[0] < @portrange[0]) || (that.attr_portrange[1] > @portrange[1]))
          return false
        end
      end
      # allow a "*" wildcard to always match anything
      if (@wildcard && ("" == @cname))
        return true
      end
      # return if either one of these NetPerm objects are invalid...
      if (@invalid || that.attr_invalid)
        return (self.attr_trust_proxy ? in_proxy_we_trust(that) : false)
      end
      if (self.get_name.equals_ignore_case(that.get_name))
        return true
      end
      begin
        if (@init_with_ip)
          # we only check IP addresses
          if (that.attr_wildcard)
            return false
          end
          if (that.attr_init_with_ip)
            return ((@addresses[0] == that.attr_addresses[0]))
          else
            if ((that.attr_addresses).nil?)
              that.get_ip
            end
            i = 0
            while i < that.attr_addresses.attr_length
              if ((@addresses[0] == that.attr_addresses[i]))
                return true
              end
              ((i += 1) - 1)
            end
          end
          # since "this" was initialized with an IP address, we
          # don't check any other cases
          return false
        end
        # check and see if we have any wildcards...
        if (@wildcard || that.attr_wildcard)
          # if they are both wildcards, return true iff
          # that's cname ends with this cname (i.e., *.sun.com
          # implies *.eng.sun.com)
          if (@wildcard && that.attr_wildcard)
            return (that.attr_cname.ends_with(@cname))
          end
          # a non-wildcard can't imply a wildcard
          if (that.attr_wildcard)
            return false
          end
          # this is a wildcard, lets see if that's cname ends with
          # it...
          if ((that.attr_cname).nil?)
            that.get_canon_name
          end
          return (that.attr_cname.ends_with(@cname))
        end
        if ((@cname).nil?)
          self.get_canon_name
        end
        # comapare IP addresses
        if ((@addresses).nil?)
          self.get_ip
        end
        if ((that.attr_addresses).nil?)
          that.get_ip
        end
        if (!(that.attr_init_with_ip && @untrusted))
          j = 0
          while j < @addresses.attr_length
            i = 0
            while i < that.attr_addresses.attr_length
              if ((@addresses[j] == that.attr_addresses[i]))
                return true
              end
              ((i += 1) - 1)
            end
            ((j += 1) - 1)
          end
          # XXX: if all else fails, compare hostnames?
          # Do we really want this?
          if ((that.attr_cname).nil?)
            that.get_canon_name
          end
          return (@cname.equals_ignore_case(that.attr_cname))
        end
      rescue UnknownHostException => uhe
        if (self.attr_trust_proxy)
          return in_proxy_we_trust(that)
        end
      end
      # make sure the first thing that is done here is to return
      # false. If not, uncomment the return false in the above catch.
      return false
    end
    
    typesig { [SocketPermission] }
    def in_proxy_we_trust(that)
      # if we trust the proxy, we see if the original names/IPs passed
      # in were equal.
      this_host = @hostname
      that_host = that.attr_hostname
      if ((this_host).nil?)
        return false
      else
        return this_host.equals_ignore_case(that_host)
      end
    end
    
    typesig { [Object] }
    # Checks two SocketPermission objects for equality.
    # <P>
    # @param obj the object to test for equality with this object.
    # 
    # @return true if <i>obj</i> is a SocketPermission, and has the
    # same hostname, port range, and actions as this
    # SocketPermission object. However, port range will be ignored
    # in the comparison if <i>obj</i> only contains the action, 'resolve'.
    def equals(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(SocketPermission)))
        return false
      end
      that = obj
      # this is (overly?) complex!!!
      # check the mask first
      if (!(@mask).equal?(that.attr_mask))
        return false
      end
      if (!((that.attr_mask & RESOLVE)).equal?(that.attr_mask))
        # now check the port range...
        if ((!(@portrange[0]).equal?(that.attr_portrange[0])) || (!(@portrange[1]).equal?(that.attr_portrange[1])))
          return false
        end
      end
      # short cut. This catches:
      # "crypto" equal to "crypto", or
      # "1.2.3.4" equal to "1.2.3.4.", or
      # "*.edu" equal to "*.edu", but it
      # does not catch "crypto" equal to
      # "crypto.eng.sun.com".
      if (self.get_name.equals_ignore_case(that.get_name))
        return true
      end
      # we now attempt to get the Canonical (FQDN) name and
      # compare that. If this fails, about all we can do is return
      # false.
      begin
        self.get_canon_name
        that.get_canon_name
      rescue UnknownHostException => uhe
        return false
      end
      if (@invalid || that.attr_invalid)
        return false
      end
      if (!(@cname).nil?)
        return @cname.equals_ignore_case(that.attr_cname)
      end
      return false
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      # If this SocketPermission was initialized with an IP address
      # or a wildcard, use getName().hashCode(), otherwise use
      # the hashCode() of the host name returned from
      # java.net.InetAddress.getHostName method.
      if (@init_with_ip || @wildcard)
        return self.get_name.hash_code
      end
      begin
        get_canon_name
      rescue UnknownHostException => uhe
      end
      if (@invalid || (@cname).nil?)
        return self.get_name.hash_code
      else
        return @cname.hash_code
      end
    end
    
    typesig { [] }
    # Return the current action mask.
    # 
    # @return the actions mask.
    def get_mask
      return @mask
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Returns the "canonical string representation" of the actions in the
      # specified mask.
      # Always returns present actions in the following order:
      # connect, listen, accept, resolve.
      # 
      # @param mask a specific integer action mask to translate into a string
      # @return the canonical string representation of the actions
      def get_actions(mask)
        sb = StringBuilder.new
        comma = false
        if (((mask & CONNECT)).equal?(CONNECT))
          comma = true
          sb.append("connect")
        end
        if (((mask & LISTEN)).equal?(LISTEN))
          if (comma)
            sb.append(Character.new(?,.ord))
          else
            comma = true
          end
          sb.append("listen")
        end
        if (((mask & ACCEPT)).equal?(ACCEPT))
          if (comma)
            sb.append(Character.new(?,.ord))
          else
            comma = true
          end
          sb.append("accept")
        end
        if (((mask & RESOLVE)).equal?(RESOLVE))
          if (comma)
            sb.append(Character.new(?,.ord))
          else
            comma = true
          end
          sb.append("resolve")
        end
        return sb.to_s
      end
    }
    
    typesig { [] }
    # Returns the canonical string representation of the actions.
    # Always returns present actions in the following order:
    # connect, listen, accept, resolve.
    # 
    # @return the canonical string representation of the actions.
    def get_actions
      if ((@actions).nil?)
        @actions = (get_actions(@mask)).to_s
      end
      return @actions
    end
    
    typesig { [] }
    # Returns a new PermissionCollection object for storing SocketPermission
    # objects.
    # <p>
    # SocketPermission objects must be stored in a manner that allows them
    # to be inserted into the collection in any order, but that also enables the
    # PermissionCollection <code>implies</code>
    # method to be implemented in an efficient (and consistent) manner.
    # 
    # @return a new PermissionCollection object suitable for storing SocketPermissions.
    def new_permission_collection
      return SocketPermissionCollection.new
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # WriteObject is called to save the state of the SocketPermission
    # to a stream. The actions are serialized, and the superclass
    # takes care of the name.
    def write_object(s)
      synchronized(self) do
        # Write out the actions. The superclass takes care of the name
        # call getActions to make sure actions field is initialized
        if ((@actions).nil?)
          get_actions
        end
        s.default_write_object
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject is called to restore the state of the SocketPermission from
    # a stream.
    def read_object(s)
      synchronized(self) do
        # Read in the action, then initialize the rest
        s.default_read_object
        init(get_name, get_mask(@actions))
      end
    end
    
    private
    alias_method :initialize__socket_permission, :initialize
  end
  
  # if (init'd with IP, key is IP as string)
  # if wildcard, its the wild card
  # else its the cname?
  # 
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # 
  # 
  # @author Roland Schemers
  # 
  # @serial include
  class SocketPermissionCollection < SocketPermissionImports.const_get :PermissionCollection
    include_class_members SocketPermissionImports
    include Serializable
    
    # Not serialized; see serialization section at end of class
    attr_accessor :perms
    alias_method :attr_perms, :perms
    undef_method :perms
    alias_method :attr_perms=, :perms=
    undef_method :perms=
    
    typesig { [] }
    # Create an empty SocketPermissions object.
    def initialize
      @perms = nil
      super()
      @perms = ArrayList.new
    end
    
    typesig { [Permission] }
    # Adds a permission to the SocketPermissions. The key for the hash is
    # the name in the case of wildcards, or all the IP addresses.
    # 
    # @param permission the Permission object to add.
    # 
    # @exception IllegalArgumentException - if the permission is not a
    # SocketPermission
    # 
    # @exception SecurityException - if this SocketPermissionCollection object
    # has been marked readonly
    def add(permission)
      if (!(permission.is_a?(SocketPermission)))
        raise IllegalArgumentException.new("invalid permission: " + (permission).to_s)
      end
      if (is_read_only)
        raise SecurityException.new("attempt to add a Permission to a readonly PermissionCollection")
      end
      # optimization to ensure perms most likely to be tested
      # show up early (4301064)
      synchronized((self)) do
        @perms.add(0, permission)
      end
    end
    
    typesig { [Permission] }
    # Check and see if this collection of permissions implies the permissions
    # expressed in "permission".
    # 
    # @param p the Permission object to compare
    # 
    # @return true if "permission" is a proper subset of a permission in
    # the collection, false if not.
    def implies(permission)
      if (!(permission.is_a?(SocketPermission)))
        return false
      end
      np = permission
      desired = np.get_mask
      effective = 0
      needed = desired
      synchronized((self)) do
        len = @perms.size
        # System.out.println("implies "+np);
        i = 0
        while i < len
          x = @perms.get(i)
          # System.out.println("  trying "+x);
          if ((!((needed & x.get_mask)).equal?(0)) && x.implies_ignore_mask(np))
            effective |= x.get_mask
            if (((effective & desired)).equal?(desired))
              return true
            end
            needed = (desired ^ effective)
          end
          ((i += 1) - 1)
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns an enumeration of all the SocketPermission objects in the
    # container.
    # 
    # @return an enumeration of all the SocketPermission objects.
    def elements
      # Convert Iterator into Enumeration
      synchronized((self)) do
        return Collections.enumeration(@perms)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 2787186408602843674 }
      const_attr_reader  :SerialVersionUID
      
      # Need to maintain serialization interoperability with earlier releases,
      # which had the serializable field:
      # 
      # The SocketPermissions for this set.
      # @serial
      # 
      # private Vector permissions;
      # 
      # @serialField permissions java.util.Vector
      # A list of the SocketPermissions for this set.
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("permissions", Vector.class), ]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData "permissions" field (a Vector containing the SocketPermissions).
    # 
    # 
    # Writes the contents of the perms field out as a Vector for
    # serialization compatibility with earlier releases.
    def write_object(out)
      # Don't call out.defaultWriteObject()
      # Write out Vector
      permissions = Vector.new(@perms.size)
      synchronized((self)) do
        permissions.add_all(@perms)
      end
      pfields = out.put_fields
      pfields.put("permissions", permissions)
      out.write_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reads in a Vector of SocketPermissions and saves them in the perms field.
    def read_object(in_)
      # Don't call in.defaultReadObject()
      # Read in serialized fields
      gfields = in_.read_fields
      # Get the one we want
      permissions = gfields.get("permissions", nil)
      @perms = ArrayList.new(permissions.size)
      @perms.add_all(permissions)
    end
    
    private
    alias_method :initialize__socket_permission_collection, :initialize
  end
  
end
