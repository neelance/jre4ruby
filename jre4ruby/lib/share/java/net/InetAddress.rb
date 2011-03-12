require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module InetAddressImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :LinkedHashMap
      include_const ::Java::Util, :Random
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Security, :AccessController
      include_const ::Java::Io, :ObjectStreamException
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Action
      include_const ::Sun::Net, :InetAddressCachePolicy
      include_const ::Sun::Net::Util, :IPAddressUtil
      include_const ::Sun::Misc, :Service
      include ::Sun::Net::Spi::Nameservice
    }
  end
  
  # This class represents an Internet Protocol (IP) address.
  # 
  # <p> An IP address is either a 32-bit or 128-bit unsigned number
  # used by IP, a lower-level protocol on which protocols like UDP and
  # TCP are built. The IP address architecture is defined by <a
  # href="http://www.ietf.org/rfc/rfc790.txt"><i>RFC&nbsp;790:
  # Assigned Numbers</i></a>, <a
  # href="http://www.ietf.org/rfc/rfc1918.txt"> <i>RFC&nbsp;1918:
  # Address Allocation for Private Internets</i></a>, <a
  # href="http://www.ietf.org/rfc/rfc2365.txt"><i>RFC&nbsp;2365:
  # Administratively Scoped IP Multicast</i></a>, and <a
  # href="http://www.ietf.org/rfc/rfc2373.txt"><i>RFC&nbsp;2373: IP
  # Version 6 Addressing Architecture</i></a>. An instance of an
  # InetAddress consists of an IP address and possibly its
  # corresponding host name (depending on whether it is constructed
  # with a host name or whether it has already done reverse host name
  # resolution).
  # 
  # <h4> Address types </h4>
  # 
  # <blockquote><table cellspacing=2 summary="Description of unicast and multicast address types">
  #   <tr><th valign=top><i>unicast</i></th>
  #       <td>An identifier for a single interface. A packet sent to
  #         a unicast address is delivered to the interface identified by
  #         that address.
  # 
  #         <p> The Unspecified Address -- Also called anylocal or wildcard
  #         address. It must never be assigned to any node. It indicates the
  #         absence of an address. One example of its use is as the target of
  #         bind, which allows a server to accept a client connection on any
  #         interface, in case the server host has multiple interfaces.
  # 
  #         <p> The <i>unspecified</i> address must not be used as
  #         the destination address of an IP packet.
  # 
  #         <p> The <i>Loopback</i> Addresses -- This is the address
  #         assigned to the loopback interface. Anything sent to this
  #         IP address loops around and becomes IP input on the local
  #         host. This address is often used when testing a
  #         client.</td></tr>
  #   <tr><th valign=top><i>multicast</i></th>
  #       <td>An identifier for a set of interfaces (typically belonging
  #         to different nodes). A packet sent to a multicast address is
  #         delivered to all interfaces identified by that address.</td></tr>
  # </table></blockquote>
  # 
  # <h4> IP address scope </h4>
  # 
  # <p> <i>Link-local</i> addresses are designed to be used for addressing
  # on a single link for purposes such as auto-address configuration,
  # neighbor discovery, or when no routers are present.
  # 
  # <p> <i>Site-local</i> addresses are designed to be used for addressing
  # inside of a site without the need for a global prefix.
  # 
  # <p> <i>Global</i> addresses are unique across the internet.
  # 
  # <h4> Textual representation of IP addresses </h4>
  # 
  # The textual representation of an IP address is address family specific.
  # 
  # <p>
  # 
  # For IPv4 address format, please refer to <A
  # HREF="Inet4Address.html#format">Inet4Address#format</A>; For IPv6
  # address format, please refer to <A
  # HREF="Inet6Address.html#format">Inet6Address#format</A>.
  # 
  # <h4> Host Name Resolution </h4>
  # 
  # Host name-to-IP address <i>resolution</i> is accomplished through
  # the use of a combination of local machine configuration information
  # and network naming services such as the Domain Name System (DNS)
  # and Network Information Service(NIS). The particular naming
  # services(s) being used is by default the local machine configured
  # one. For any host name, its corresponding IP address is returned.
  # 
  # <p> <i>Reverse name resolution</i> means that for any IP address,
  # the host associated with the IP address is returned.
  # 
  # <p> The InetAddress class provides methods to resolve host names to
  # their IP addresses and vice versa.
  # 
  # <h4> InetAddress Caching </h4>
  # 
  # The InetAddress class has a cache to store successful as well as
  # unsuccessful host name resolutions.
  # 
  # <p> By default, when a security manager is installed, in order to
  # protect against DNS spoofing attacks,
  # the result of positive host name resolutions are
  # cached forever. When a security manager is not installed, the default
  # behavior is to cache entries for a finite (implementation dependent)
  # period of time. The result of unsuccessful host
  # name resolution is cached for a very short period of time (10
  # seconds) to improve performance.
  # 
  # <p> If the default behavior is not desired, then a Java security property
  # can be set to a different Time-to-live (TTL) value for positive
  # caching. Likewise, a system admin can configure a different
  # negative caching TTL value when needed.
  # 
  # <p> Two Java security properties control the TTL values used for
  #  positive and negative host name resolution caching:
  # 
  # <blockquote>
  # <dl>
  # <dt><b>networkaddress.cache.ttl</b></dt>
  # <dd>Indicates the caching policy for successful name lookups from
  # the name service. The value is specified as as integer to indicate
  # the number of seconds to cache the successful lookup. The default
  # setting is to cache for an implementation specific period of time.
  # <p>
  # A value of -1 indicates "cache forever".
  # </dd>
  # <p>
  # <dt><b>networkaddress.cache.negative.ttl</b> (default: 10)</dt>
  # <dd>Indicates the caching policy for un-successful name lookups
  # from the name service. The value is specified as as integer to
  # indicate the number of seconds to cache the failure for
  # un-successful lookups.
  # <p>
  # A value of 0 indicates "never cache".
  # A value of -1 indicates "cache forever".
  # </dd>
  # </dl>
  # </blockquote>
  # 
  # @author  Chris Warth
  # @see     java.net.InetAddress#getByAddress(byte[])
  # @see     java.net.InetAddress#getByAddress(java.lang.String, byte[])
  # @see     java.net.InetAddress#getAllByName(java.lang.String)
  # @see     java.net.InetAddress#getByName(java.lang.String)
  # @see     java.net.InetAddress#getLocalHost()
  # @since JDK1.0
  class InetAddress 
    include_class_members InetAddressImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      # Specify the address family: Internet Protocol, Version 4
      # @since 1.4
      const_set_lazy(:IPv4) { 1 }
      const_attr_reader  :IPv4
      
      # Specify the address family: Internet Protocol, Version 6
      # @since 1.4
      const_set_lazy(:IPv6) { 2 }
      const_attr_reader  :IPv6
      
      # Specify address family preference
      
      def prefer_ipv6address
        defined?(@@prefer_ipv6address) ? @@prefer_ipv6address : @@prefer_ipv6address= false
      end
      alias_method :attr_prefer_ipv6address, :prefer_ipv6address
      
      def prefer_ipv6address=(value)
        @@prefer_ipv6address = value
      end
      alias_method :attr_prefer_ipv6address=, :prefer_ipv6address=
    }
    
    # @serial
    attr_accessor :host_name
    alias_method :attr_host_name, :host_name
    undef_method :host_name
    alias_method :attr_host_name=, :host_name=
    undef_method :host_name=
    
    # Holds a 32-bit IPv4 address.
    # 
    # @serial
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    # Specifies the address family type, for instance, '1' for IPv4
    # addresses, and '2' for IPv6 addresses.
    # 
    # @serial
    attr_accessor :family
    alias_method :attr_family, :family
    undef_method :family
    alias_method :attr_family=, :family=
    undef_method :family=
    
    class_module.module_eval {
      # Used to store the name service provider
      
      def name_services
        defined?(@@name_services) ? @@name_services : @@name_services= nil
      end
      alias_method :attr_name_services, :name_services
      
      def name_services=(value)
        @@name_services = value
      end
      alias_method :attr_name_services=, :name_services=
    }
    
    # Used to store the best available hostname
    attr_accessor :canonical_host_name
    alias_method :attr_canonical_host_name, :canonical_host_name
    undef_method :canonical_host_name
    alias_method :attr_canonical_host_name=, :canonical_host_name=
    undef_method :canonical_host_name=
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 3286316764910316507 }
      const_attr_reader  :SerialVersionUID
      
      # Load net library into runtime, and perform initializations.
      when_class_loaded do
        self.attr_prefer_ipv6address = Java::Security::AccessController.do_privileged(GetBooleanAction.new("java.net.preferIPv6Addresses")).boolean_value
        AccessController.do_privileged(LoadLibraryAction.new("net"))
        init
      end
    }
    
    typesig { [] }
    # Constructor for the Socket.accept() method.
    # This creates an empty InetAddress, which is filled in by
    # the accept() method.  This InetAddress, however, is not
    # put in the address cache, since it is not created by name.
    def initialize
      @host_name = nil
      @address = 0
      @family = 0
      @canonical_host_name = nil
    end
    
    typesig { [] }
    # Replaces the de-serialized object with an Inet4Address object.
    # 
    # @return the alternate object to the de-serialized object.
    # 
    # @throws ObjectStreamException if a new object replacing this
    # object could not be created
    def read_resolve
      # will replace the deserialized 'this' object
      return Inet4Address.new(@host_name, @address)
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is an
    # IP multicast address.
    # @return a <code>boolean</code> indicating if the InetAddress is
    # an IP multicast address
    # @since   JDK1.1
    def is_multicast_address
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress in a wildcard address.
    # @return a <code>boolean</code> indicating if the Inetaddress is
    #         a wildcard address.
    # @since 1.4
    def is_any_local_address
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is a loopback address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a loopback address; or false otherwise.
    # @since 1.4
    def is_loopback_address
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is an link local address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a link local address; or false if address is not a link local unicast address.
    # @since 1.4
    def is_link_local_address
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is a site local address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a site local address; or false if address is not a site local unicast address.
    # @since 1.4
    def is_site_local_address
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has global scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    #         is a multicast address of global scope, false if it is not
    #         of global scope or it is not a multicast address
    # @since 1.4
    def is_mcglobal
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has node scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    #         is a multicast address of node-local scope, false if it is not
    #         of node-local scope or it is not a multicast address
    # @since 1.4
    def is_mcnode_local
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has link scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    #         is a multicast address of link-local scope, false if it is not
    #         of link-local scope or it is not a multicast address
    # @since 1.4
    def is_mclink_local
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has site scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    #         is a multicast address of site-local scope, false if it is not
    #         of site-local scope or it is not a multicast address
    # @since 1.4
    def is_mcsite_local
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has organization scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    #         is a multicast address of organization-local scope,
    #         false if it is not of organization-local scope
    #         or it is not a multicast address
    # @since 1.4
    def is_mcorg_local
      return false
    end
    
    typesig { [::Java::Int] }
    # Test whether that address is reachable. Best effort is made by the
    # implementation to try to reach the host, but firewalls and server
    # configuration may block requests resulting in a unreachable status
    # while some specific ports may be accessible.
    # A typical implementation will use ICMP ECHO REQUESTs if the
    # privilege can be obtained, otherwise it will try to establish
    # a TCP connection on port 7 (Echo) of the destination host.
    # <p>
    # The timeout value, in milliseconds, indicates the maximum amount of time
    # the try should take. If the operation times out before getting an
    # answer, the host is deemed unreachable. A negative value will result
    # in an IllegalArgumentException being thrown.
    # 
    # @param   timeout the time, in milliseconds, before the call aborts
    # @return a <code>boolean</code> indicating if the address is reachable.
    # @throws IOException if a network error occurs
    # @throws  IllegalArgumentException if <code>timeout</code> is negative.
    # @since 1.5
    def is_reachable(timeout)
      return is_reachable(nil, 0, timeout)
    end
    
    typesig { [NetworkInterface, ::Java::Int, ::Java::Int] }
    # Test whether that address is reachable. Best effort is made by the
    # implementation to try to reach the host, but firewalls and server
    # configuration may block requests resulting in a unreachable status
    # while some specific ports may be accessible.
    # A typical implementation will use ICMP ECHO REQUESTs if the
    # privilege can be obtained, otherwise it will try to establish
    # a TCP connection on port 7 (Echo) of the destination host.
    # <p>
    # The <code>network interface</code> and <code>ttl</code> parameters
    # let the caller specify which network interface the test will go through
    # and the maximum number of hops the packets should go through.
    # A negative value for the <code>ttl</code> will result in an
    # IllegalArgumentException being thrown.
    # <p>
    # The timeout value, in milliseconds, indicates the maximum amount of time
    # the try should take. If the operation times out before getting an
    # answer, the host is deemed unreachable. A negative value will result
    # in an IllegalArgumentException being thrown.
    # 
    # @param   netif   the NetworkInterface through which the
    #                    test will be done, or null for any interface
    # @param   ttl     the maximum numbers of hops to try or 0 for the
    #                  default
    # @param   timeout the time, in milliseconds, before the call aborts
    # @throws  IllegalArgumentException if either <code>timeout</code>
    #                          or <code>ttl</code> are negative.
    # @return a <code>boolean</code>indicating if the address is reachable.
    # @throws IOException if a network error occurs
    # @since 1.5
    def is_reachable(netif, ttl, timeout)
      if (ttl < 0)
        raise IllegalArgumentException.new("ttl can't be negative")
      end
      if (timeout < 0)
        raise IllegalArgumentException.new("timeout can't be negative")
      end
      return self.attr_impl.is_reachable(self, timeout, netif, ttl)
    end
    
    typesig { [] }
    # Gets the host name for this IP address.
    # 
    # <p>If this InetAddress was created with a host name,
    # this host name will be remembered and returned;
    # otherwise, a reverse name lookup will be performed
    # and the result will be returned based on the system
    # configured name lookup service. If a lookup of the name service
    # is required, call
    # {@link #getCanonicalHostName() getCanonicalHostName}.
    # 
    # <p>If there is a security manager, its
    # <code>checkConnect</code> method is first called
    # with the hostname and <code>-1</code>
    # as its arguments to see if the operation is allowed.
    # If the operation is not allowed, it will return
    # the textual representation of the IP address.
    # 
    # @return  the host name for this IP address, or if the operation
    #    is not allowed by the security check, the textual
    #    representation of the IP address.
    # 
    # @see InetAddress#getCanonicalHostName
    # @see SecurityManager#checkConnect
    def get_host_name
      return get_host_name(true)
    end
    
    typesig { [::Java::Boolean] }
    # Returns the hostname for this address.
    # If the host is equal to null, then this address refers to any
    # of the local machine's available network addresses.
    # this is package private so SocketPermission can make calls into
    # here without a security check.
    # 
    # <p>If there is a security manager, this method first
    # calls its <code>checkConnect</code> method
    # with the hostname and <code>-1</code>
    # as its arguments to see if the calling code is allowed to know
    # the hostname for this IP address, i.e., to connect to the host.
    # If the operation is not allowed, it will return
    # the textual representation of the IP address.
    # 
    # @return  the host name for this IP address, or if the operation
    #    is not allowed by the security check, the textual
    #    representation of the IP address.
    # 
    # @param check make security check if true
    # 
    # @see SecurityManager#checkConnect
    def get_host_name(check)
      if ((@host_name).nil?)
        @host_name = RJava.cast_to_string(InetAddress.get_host_from_name_service(self, check))
      end
      return @host_name
    end
    
    typesig { [] }
    # Gets the fully qualified domain name for this IP address.
    # Best effort method, meaning we may not be able to return
    # the FQDN depending on the underlying system configuration.
    # 
    # <p>If there is a security manager, this method first
    # calls its <code>checkConnect</code> method
    # with the hostname and <code>-1</code>
    # as its arguments to see if the calling code is allowed to know
    # the hostname for this IP address, i.e., to connect to the host.
    # If the operation is not allowed, it will return
    # the textual representation of the IP address.
    # 
    # @return  the fully qualified domain name for this IP address,
    #    or if the operation is not allowed by the security check,
    #    the textual representation of the IP address.
    # 
    # @see SecurityManager#checkConnect
    # 
    # @since 1.4
    def get_canonical_host_name
      if ((@canonical_host_name).nil?)
        @canonical_host_name = RJava.cast_to_string(InetAddress.get_host_from_name_service(self, true))
      end
      return @canonical_host_name
    end
    
    class_module.module_eval {
      typesig { [InetAddress, ::Java::Boolean] }
      # Returns the hostname for this address.
      # 
      # <p>If there is a security manager, this method first
      # calls its <code>checkConnect</code> method
      # with the hostname and <code>-1</code>
      # as its arguments to see if the calling code is allowed to know
      # the hostname for this IP address, i.e., to connect to the host.
      # If the operation is not allowed, it will return
      # the textual representation of the IP address.
      # 
      # @return  the host name for this IP address, or if the operation
      #    is not allowed by the security check, the textual
      #    representation of the IP address.
      # 
      # @param check make security check if true
      # 
      # @see SecurityManager#checkConnect
      def get_host_from_name_service(addr, check)
        host = nil
        self.attr_name_services.each do |nameService|
          begin
            # first lookup the hostname
            host = RJava.cast_to_string(name_service.get_host_by_addr(addr.get_address))
            # check to see if calling code is allowed to know
            # the hostname for this IP address, ie, connect to the host
            if (check)
              sec = System.get_security_manager
              if (!(sec).nil?)
                sec.check_connect(host, -1)
              end
            end
            # now get all the IP addresses for this hostname,
            # and make sure one of them matches the original IP
            # address. We do this to try and prevent spoofing.
            arr = InetAddress.get_all_by_name0(host, check)
            ok = false
            if (!(arr).nil?)
              i = 0
              while !ok && i < arr.attr_length
                ok = (addr == arr[i])
                i += 1
              end
            end
            # XXX: if it looks a spoof just return the address?
            if (!ok)
              host = RJava.cast_to_string(addr.get_host_address)
              return host
            end
            break
          rescue SecurityException => e
            host = RJava.cast_to_string(addr.get_host_address)
            break
          rescue UnknownHostException => e
            host = RJava.cast_to_string(addr.get_host_address)
            # let next provider resolve the hostname
          end
        end
        return host
      end
    }
    
    typesig { [] }
    # Returns the raw IP address of this <code>InetAddress</code>
    # object. The result is in network byte order: the highest order
    # byte of the address is in <code>getAddress()[0]</code>.
    # 
    # @return  the raw IP address of this object.
    def get_address
      return nil
    end
    
    typesig { [] }
    # Returns the IP address string in textual presentation.
    # 
    # @return  the raw IP address in a string format.
    # @since   JDK1.0.2
    def get_host_address
      return nil
    end
    
    typesig { [] }
    # Returns a hashcode for this IP address.
    # 
    # @return  a hash code value for this IP address.
    def hash_code
      return -1
    end
    
    typesig { [Object] }
    # Compares this object against the specified object.
    # The result is <code>true</code> if and only if the argument is
    # not <code>null</code> and it represents the same IP address as
    # this object.
    # <p>
    # Two instances of <code>InetAddress</code> represent the same IP
    # address if the length of the byte arrays returned by
    # <code>getAddress</code> is the same for both, and each of the
    # array components is the same for the byte arrays.
    # 
    # @param   obj   the object to compare against.
    # @return  <code>true</code> if the objects are the same;
    #          <code>false</code> otherwise.
    # @see     java.net.InetAddress#getAddress()
    def ==(obj)
      return false
    end
    
    typesig { [] }
    # Converts this IP address to a <code>String</code>. The
    # string returned is of the form: hostname / literal IP
    # address.
    # 
    # If the host name is unresolved, no reverse name service lookup
    # is performed. The hostname part will be represented by an empty string.
    # 
    # @return  a string representation of this IP address.
    def to_s
      return RJava.cast_to_string(((!(@host_name).nil?) ? @host_name : "")) + "/" + RJava.cast_to_string(get_host_address)
    end
    
    class_module.module_eval {
      # Cached addresses - our own litle nis, not!
      
      def address_cache
        defined?(@@address_cache) ? @@address_cache : @@address_cache= Cache.new(Cache::Type::Positive)
      end
      alias_method :attr_address_cache, :address_cache
      
      def address_cache=(value)
        @@address_cache = value
      end
      alias_method :attr_address_cache=, :address_cache=
      
      
      def negative_cache
        defined?(@@negative_cache) ? @@negative_cache : @@negative_cache= Cache.new(Cache::Type::Negative)
      end
      alias_method :attr_negative_cache, :negative_cache
      
      def negative_cache=(value)
        @@negative_cache = value
      end
      alias_method :attr_negative_cache=, :negative_cache=
      
      
      def address_cache_init
        defined?(@@address_cache_init) ? @@address_cache_init : @@address_cache_init= false
      end
      alias_method :attr_address_cache_init, :address_cache_init
      
      def address_cache_init=(value)
        @@address_cache_init = value
      end
      alias_method :attr_address_cache_init=, :address_cache_init=
      
      
      def unknown_array
        defined?(@@unknown_array) ? @@unknown_array : @@unknown_array= nil
      end
      alias_method :attr_unknown_array, :unknown_array
      
      def unknown_array=(value)
        @@unknown_array = value
      end
      alias_method :attr_unknown_array=, :unknown_array=
      
      # put THIS in cache
      
      def impl
        defined?(@@impl) ? @@impl : @@impl= nil
      end
      alias_method :attr_impl, :impl
      
      def impl=(value)
        @@impl = value
      end
      alias_method :attr_impl=, :impl=
      
      
      def lookup_table
        defined?(@@lookup_table) ? @@lookup_table : @@lookup_table= HashMap.new
      end
      alias_method :attr_lookup_table, :lookup_table
      
      def lookup_table=(value)
        @@lookup_table = value
      end
      alias_method :attr_lookup_table=, :lookup_table=
      
      # Represents a cache entry
      const_set_lazy(:CacheEntry) { Class.new do
        include_class_members InetAddress
        
        typesig { [Object, ::Java::Long] }
        def initialize(address, expiration)
          @address = nil
          @expiration = 0
          @address = address
          @expiration = expiration
        end
        
        attr_accessor :address
        alias_method :attr_address, :address
        undef_method :address
        alias_method :attr_address=, :address=
        undef_method :address=
        
        attr_accessor :expiration
        alias_method :attr_expiration, :expiration
        undef_method :expiration
        alias_method :attr_expiration=, :expiration=
        undef_method :expiration=
        
        private
        alias_method :initialize__cache_entry, :initialize
      end }
      
      # A cache that manages entries based on a policy specified
      # at creation time.
      const_set_lazy(:Cache) { Class.new do
        include_class_members InetAddress
        
        attr_accessor :cache
        alias_method :attr_cache, :cache
        undef_method :cache
        alias_method :attr_cache=, :cache=
        undef_method :cache=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        class_module.module_eval {
          const_set_lazy(:Positive) { Type::Positive }
          const_attr_reader  :Positive
          
          const_set_lazy(:Negative) { Type::Negative }
          const_attr_reader  :Negative
          
          class Type 
            include_class_members Cache
            
            class_module.module_eval {
              const_set_lazy(:Positive) { Type.new.set_value_name("Positive") }
              const_attr_reader  :Positive
              
              const_set_lazy(:Negative) { Type.new.set_value_name("Negative") }
              const_attr_reader  :Negative
            }
            
            typesig { [String] }
            def set_value_name(name)
              @value_name = name
              self
            end
            
            typesig { [] }
            def to_s
              @value_name
            end
            
            class_module.module_eval {
              typesig { [] }
              def values
                [Positive, Negative]
              end
            }
            
            typesig { [] }
            def initialize
            end
            
            private
            alias_method :initialize__type, :initialize
          end
        }
        
        typesig { [class_self::Type] }
        # Create cache
        def initialize(type)
          @cache = nil
          @type = nil
          @type = type
          @cache = self.class::LinkedHashMap.new
        end
        
        typesig { [] }
        def get_policy
          if ((@type).equal?(Type::Positive))
            return InetAddressCachePolicy.get
          else
            return InetAddressCachePolicy.get_negative
          end
        end
        
        typesig { [String, Object] }
        # Add an entry to the cache. If there's already an
        # entry then for this host then the entry will be
        # replaced.
        def put(host, address)
          policy = get_policy
          if ((policy).equal?(InetAddressCachePolicy::NEVER))
            return self
          end
          # purge any expired entries
          if (!(policy).equal?(InetAddressCachePolicy::FOREVER))
            # As we iterate in insertion order we can
            # terminate when a non-expired entry is found.
            expired = self.class::LinkedList.new
            i = @cache.key_set.iterator
            now = System.current_time_millis
            while (i.has_next)
              key = i.next_
              entry = @cache.get(key)
              if (entry.attr_expiration >= 0 && entry.attr_expiration < now)
                expired.add(key)
              else
                break
              end
            end
            i = expired.iterator
            while (i.has_next)
              @cache.remove(i.next_)
            end
          end
          # create new entry and add it to the cache
          # -- as a HashMap replaces existing entries we
          #    don't need to explicitly check if there is
          #    already an entry for this host.
          expiration = 0
          if ((policy).equal?(InetAddressCachePolicy::FOREVER))
            expiration = -1
          else
            expiration = System.current_time_millis + (policy * 1000)
          end
          entry = self.class::CacheEntry.new(address, expiration)
          @cache.put(host, entry)
          return self
        end
        
        typesig { [String] }
        # Query the cache for the specific host. If found then
        # return its CacheEntry, or null if not found.
        def get(host)
          policy = get_policy
          if ((policy).equal?(InetAddressCachePolicy::NEVER))
            return nil
          end
          entry = @cache.get(host)
          # check if entry has expired
          if (!(entry).nil? && !(policy).equal?(InetAddressCachePolicy::FOREVER))
            if (entry.attr_expiration >= 0 && entry.attr_expiration < System.current_time_millis)
              @cache.remove(host)
              entry = nil
            end
          end
          return entry
        end
        
        private
        alias_method :initialize__cache, :initialize
      end }
      
      typesig { [] }
      # Initialize cache and insert anyLocalAddress into the
      # unknown array with no expiry.
      def cache_init_if_needed
        raise AssertError if not (JavaThread.holds_lock(self.attr_address_cache))
        if (self.attr_address_cache_init)
          return
        end
        self.attr_unknown_array = Array.typed(InetAddress).new(1) { nil }
        self.attr_unknown_array[0] = self.attr_impl.any_local_address
        self.attr_address_cache.put(self.attr_impl.any_local_address.get_host_name, self.attr_unknown_array)
        self.attr_address_cache_init = true
      end
      
      typesig { [String, Object, ::Java::Boolean] }
      # Cache the given hostname and address.
      def cache_address(hostname, address, success)
        hostname = RJava.cast_to_string(hostname.to_lower_case)
        synchronized((self.attr_address_cache)) do
          cache_init_if_needed
          if (success)
            self.attr_address_cache.put(hostname, address)
          else
            self.attr_negative_cache.put(hostname, address)
          end
        end
      end
      
      typesig { [String] }
      # Lookup hostname in cache (positive & negative cache). If
      # found return address, null if not found.
      def get_cached_address(hostname)
        hostname = RJava.cast_to_string(hostname.to_lower_case)
        # search both positive & negative caches
        synchronized((self.attr_address_cache)) do
          entry = nil
          cache_init_if_needed
          entry = self.attr_address_cache.get(hostname)
          if ((entry).nil?)
            entry = self.attr_negative_cache.get(hostname)
          end
          if (!(entry).nil?)
            return entry.attr_address
          end
        end
        # not found
        return nil
      end
      
      typesig { [String] }
      def create_nsprovider(provider)
        if ((provider).nil?)
          return nil
        end
        name_service = nil
        if ((provider == "default"))
          name_service = # initialize the default name service
          Class.new(NameService.class == Class ? NameService : Object) do
            local_class_in InetAddress
            include_class_members InetAddress
            include NameService if NameService.class == Module
            
            typesig { [String] }
            define_method :lookup_all_host_addr do |host|
              return self.attr_impl.lookup_all_host_addr(host)
            end
            
            typesig { [Array.typed(::Java::Byte)] }
            define_method :get_host_by_addr do |addr|
              return self.attr_impl.get_host_by_addr(addr)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        else
          provider_name = provider
          begin
            name_service = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
              local_class_in InetAddress
              include_class_members InetAddress
              include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
              
              typesig { [] }
              define_method :run do
                itr = Service.providers(NameServiceDescriptor)
                while (itr.has_next)
                  nsd = itr.next_
                  if (provider_name.equals_ignore_case(RJava.cast_to_string(nsd.get_type) + "," + RJava.cast_to_string(nsd.get_provider_name)))
                    begin
                      return nsd.create_name_service
                    rescue self.class::JavaException => e
                      e.print_stack_trace
                      System.err.println("Cannot create name service:" + provider_name + ": " + RJava.cast_to_string(e))
                    end
                  end
                end
                return nil
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          rescue Java::Security::PrivilegedActionException => e
          end
        end
        return name_service
      end
      
      when_class_loaded do
        # create the impl
        self.attr_impl = (InetAddressImplFactory.new).create
        # get name service if provided and requested
        provider = nil
        prop_prefix = "sun.net.spi.nameservice.provider."
        n = 1
        self.attr_name_services = ArrayList.new
        provider = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new(prop_prefix + RJava.cast_to_string(n))))
        while (!(provider).nil?)
          ns = create_nsprovider(provider)
          if (!(ns).nil?)
            self.attr_name_services.add(ns)
          end
          n += 1
          provider = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new(prop_prefix + RJava.cast_to_string(n))))
        end
        # if not designate any name services provider,
        # creat a default one
        if ((self.attr_name_services.size).equal?(0))
          ns = create_nsprovider("default")
          self.attr_name_services.add(ns)
        end
      end
      
      typesig { [String, Array.typed(::Java::Byte)] }
      # Create an InetAddress based on the provided host name and IP address
      # No name service is checked for the validity of the address.
      # 
      # <p> The host name can either be a machine name, such as
      # "<code>java.sun.com</code>", or a textual representation of its IP
      # address.
      # <p> No validity checking is done on the host name either.
      # 
      # <p> If addr specifies an IPv4 address an instance of Inet4Address
      # will be returned; otherwise, an instance of Inet6Address
      # will be returned.
      # 
      # <p> IPv4 address byte array must be 4 bytes long and IPv6 byte array
      # must be 16 bytes long
      # 
      # @param host the specified host
      # @param addr the raw IP address in network byte order
      # @return  an InetAddress object created from the raw IP address.
      # @exception  UnknownHostException  if IP address is of illegal length
      # @since 1.4
      def get_by_address(host, addr)
        if (!(host).nil? && host.length > 0 && (host.char_at(0)).equal?(Character.new(?[.ord)))
          if ((host.char_at(host.length - 1)).equal?(Character.new(?].ord)))
            host = RJava.cast_to_string(host.substring(1, host.length - 1))
          end
        end
        if (!(addr).nil?)
          if ((addr.attr_length).equal?(Inet4Address::INADDRSZ))
            return Inet4Address.new(host, addr)
          else
            if ((addr.attr_length).equal?(Inet6Address::INADDRSZ))
              new_addr = IPAddressUtil.convert_from_ipv4mapped_address(addr)
              if (!(new_addr).nil?)
                return Inet4Address.new(host, new_addr)
              else
                return Inet6Address.new(host, addr)
              end
            end
          end
        end
        raise UnknownHostException.new("addr is of illegal length")
      end
      
      typesig { [String] }
      # Determines the IP address of a host, given the host's name.
      # 
      # <p> The host name can either be a machine name, such as
      # "<code>java.sun.com</code>", or a textual representation of its
      # IP address. If a literal IP address is supplied, only the
      # validity of the address format is checked.
      # 
      # <p> For <code>host</code> specified in literal IPv6 address,
      # either the form defined in RFC 2732 or the literal IPv6 address
      # format defined in RFC 2373 is accepted. IPv6 scoped addresses are also
      # supported. See <a href="Inet6Address.html#scoped">here</a> for a description of IPv6
      # scoped addresses.
      # 
      # <p> If the host is <tt>null</tt> then an <tt>InetAddress</tt>
      # representing an address of the loopback interface is returned.
      # See <a href="http://www.ietf.org/rfc/rfc3330.txt">RFC&nbsp;3330</a>
      # section&nbsp;2 and <a href="http://www.ietf.org/rfc/rfc2373.txt">RFC&nbsp;2373</a>
      # section&nbsp;2.5.3. </p>
      # 
      # @param      host   the specified host, or <code>null</code>.
      # @return     an IP address for the given host name.
      # @exception  UnknownHostException  if no IP address for the
      #               <code>host</code> could be found, or if a scope_id was specified
      #               for a global IPv6 address.
      # @exception  SecurityException if a security manager exists
      #             and its checkConnect method doesn't allow the operation
      def get_by_name(host)
        return InetAddress.get_all_by_name(host)[0]
      end
      
      typesig { [String, InetAddress] }
      # called from deployment cache manager
      def get_by_name(host, req_addr)
        return InetAddress.get_all_by_name(host, req_addr)[0]
      end
      
      typesig { [String] }
      # Given the name of a host, returns an array of its IP addresses,
      # based on the configured name service on the system.
      # 
      # <p> The host name can either be a machine name, such as
      # "<code>java.sun.com</code>", or a textual representation of its IP
      # address. If a literal IP address is supplied, only the
      # validity of the address format is checked.
      # 
      # <p> For <code>host</code> specified in <i>literal IPv6 address</i>,
      # either the form defined in RFC 2732 or the literal IPv6 address
      # format defined in RFC 2373 is accepted. A literal IPv6 address may
      # also be qualified by appending a scoped zone identifier or scope_id.
      # The syntax and usage of scope_ids is described
      # <a href="Inet6Address.html#scoped">here</a>.
      # <p> If the host is <tt>null</tt> then an <tt>InetAddress</tt>
      # representing an address of the loopback interface is returned.
      # See <a href="http://www.ietf.org/rfc/rfc3330.txt">RFC&nbsp;3330</a>
      # section&nbsp;2 and <a href="http://www.ietf.org/rfc/rfc2373.txt">RFC&nbsp;2373</a>
      # section&nbsp;2.5.3. </p>
      # 
      # <p> If there is a security manager and <code>host</code> is not
      # null and <code>host.length() </code> is not equal to zero, the
      # security manager's
      # <code>checkConnect</code> method is called
      # with the hostname and <code>-1</code>
      # as its arguments to see if the operation is allowed.
      # 
      # @param      host   the name of the host, or <code>null</code>.
      # @return     an array of all the IP addresses for a given host name.
      # 
      # @exception  UnknownHostException  if no IP address for the
      #               <code>host</code> could be found, or if a scope_id was specified
      #               for a global IPv6 address.
      # @exception  SecurityException  if a security manager exists and its
      #               <code>checkConnect</code> method doesn't allow the operation.
      # 
      # @see SecurityManager#checkConnect
      def get_all_by_name(host)
        return get_all_by_name(host, nil)
      end
      
      typesig { [String, InetAddress] }
      def get_all_by_name(host, req_addr)
        if ((host).nil? || (host.length).equal?(0))
          ret = Array.typed(InetAddress).new(1) { nil }
          ret[0] = self.attr_impl.loopback_address
          return ret
        end
        ipv6expected = false
        if ((host.char_at(0)).equal?(Character.new(?[.ord)))
          # This is supposed to be an IPv6 litteral
          if (host.length > 2 && (host.char_at(host.length - 1)).equal?(Character.new(?].ord)))
            host = RJava.cast_to_string(host.substring(1, host.length - 1))
            ipv6expected = true
          else
            # This was supposed to be a IPv6 address, but it's not!
            raise UnknownHostException.new(host)
          end
        end
        # if host is an IP address, we won't do further lookup
        if (!(Character.digit(host.char_at(0), 16)).equal?(-1) || ((host.char_at(0)).equal?(Character.new(?:.ord))))
          addr = nil
          numeric_zone = -1
          ifname = nil
          # see if it is IPv4 address
          addr = IPAddressUtil.text_to_numeric_format_v4(host)
          if ((addr).nil?)
            # see if it is IPv6 address
            # Check if a numeric or string zone id is present
            pos = 0
            if (!((pos = host.index_of("%"))).equal?(-1))
              numeric_zone = check_numeric_zone(host)
              if ((numeric_zone).equal?(-1))
                # remainder of string must be an ifname
                ifname = RJava.cast_to_string(host.substring(pos + 1))
              end
            end
            addr = IPAddressUtil.text_to_numeric_format_v6(host)
          else
            if (ipv6expected)
              # Means an IPv4 litteral between brackets!
              raise UnknownHostException.new("[" + host + "]")
            end
          end
          ret = Array.typed(InetAddress).new(1) { nil }
          if (!(addr).nil?)
            if ((addr.attr_length).equal?(Inet4Address::INADDRSZ))
              ret[0] = Inet4Address.new(nil, addr)
            else
              if (!(ifname).nil?)
                ret[0] = Inet6Address.new(nil, addr, ifname)
              else
                ret[0] = Inet6Address.new(nil, addr, numeric_zone)
              end
            end
            return ret
          end
        else
          if (ipv6expected)
            # We were expecting an IPv6 Litteral, but got something else
            raise UnknownHostException.new("[" + host + "]")
          end
        end
        return get_all_by_name0(host, req_addr, true)
      end
      
      typesig { [String] }
      # check if the literal address string has %nn appended
      # returns -1 if not, or the numeric value otherwise.
      # 
      # %nn may also be a string that represents the displayName of
      # a currently available NetworkInterface.
      def check_numeric_zone(s)
        percent = s.index_of(Character.new(?%.ord))
        slen = s.length
        digit_ = 0
        zone = 0
        if ((percent).equal?(-1))
          return -1
        end
        i = percent + 1
        while i < slen
          c = s.char_at(i)
          if ((c).equal?(Character.new(?].ord)))
            if ((i).equal?(percent + 1))
              # empty per-cent field
              return -1
            end
            break
          end
          if ((digit_ = Character.digit(c, 10)) < 0)
            return -1
          end
          zone = (zone * 10) + digit_
          i += 1
        end
        return zone
      end
      
      typesig { [String] }
      def get_all_by_name0(host)
        return get_all_by_name0(host, true)
      end
      
      typesig { [String, ::Java::Boolean] }
      # package private so SocketPermission can call it
      def get_all_by_name0(host, check)
        return get_all_by_name0(host, nil, check)
      end
      
      typesig { [String, InetAddress, ::Java::Boolean] }
      def get_all_by_name0(host, req_addr, check)
        # If it gets here it is presumed to be a hostname
        # Cache.get can return: null, unknownAddress, or InetAddress[]
        obj = nil
        objcopy = nil
        # make sure the connection to the host is allowed, before we
        # give out a hostname
        if (check)
          security = System.get_security_manager
          if (!(security).nil?)
            security.check_connect(host, -1)
          end
        end
        obj = get_cached_address(host)
        # If no entry in cache, then do the host lookup
        if ((obj).nil?)
          obj = get_address_from_name_service(host, req_addr)
        end
        if ((obj).equal?(self.attr_unknown_array))
          raise UnknownHostException.new(host)
        end
        # Make a copy of the InetAddress array
        objcopy = (obj).clone
        return objcopy
      end
      
      typesig { [String, InetAddress] }
      def get_address_from_name_service(host, req_addr)
        obj = nil
        success = false
        ex = nil
        # Check whether the host is in the lookupTable.
        # 1) If the host isn't in the lookupTable when
        #    checkLookupTable() is called, checkLookupTable()
        #    would add the host in the lookupTable and
        #    return null. So we will do the lookup.
        # 2) If the host is in the lookupTable when
        #    checkLookupTable() is called, the current thread
        #    would be blocked until the host is removed
        #    from the lookupTable. Then this thread
        #    should try to look up the addressCache.
        #     i) if it found the address in the
        #        addressCache, checkLookupTable()  would
        #        return the address.
        #     ii) if it didn't find the address in the
        #         addressCache for any reason,
        #         it should add the host in the
        #         lookupTable and return null so the
        #         following code would do  a lookup itself.
        if (((obj = check_lookup_table(host))).nil?)
          # This is the first thread which looks up the address
          # this host or the cache entry for this host has been
          # expired so this thread should do the lookup.
          self.attr_name_services.each do |nameService|
            begin
              # Do not put the call to lookup() inside the
              # constructor.  if you do you will still be
              # allocating space when the lookup fails.
              obj = name_service.lookup_all_host_addr(host)
              success = true
              break
            rescue UnknownHostException => uhe
              if (host.equals_ignore_case("localhost"))
                local = Array.typed(InetAddress).new([self.attr_impl.loopback_address])
                obj = local
                success = true
                break
              else
                obj = self.attr_unknown_array
                success = false
                ex = uhe
              end
            end
          end
          # More to do?
          addrs = obj
          if (!(req_addr).nil? && addrs.attr_length > 1 && !(addrs[0] == req_addr))
            # Find it?
            i = 1
            while i < addrs.attr_length
              if ((addrs[i] == req_addr))
                break
              end
              i += 1
            end
            # Rotate
            if (i < addrs.attr_length)
              tmp = nil
              tmp2 = req_addr
              j = 0
              while j < i
                tmp = addrs[j]
                addrs[j] = tmp2
                tmp2 = tmp
                j += 1
              end
              addrs[i] = tmp2
            end
          end
          # Cache the address.
          cache_address(host, obj, success)
          # Delete the host from the lookupTable, and
          # notify all threads waiting for the monitor
          # for lookupTable.
          update_lookup_table(host)
          if (!success && !(ex).nil?)
            raise ex
          end
        end
        return obj
      end
      
      typesig { [String] }
      def check_lookup_table(host)
        # make sure obj  is null.
        obj = nil
        synchronized((self.attr_lookup_table)) do
          # If the host isn't in the lookupTable, add it in the
          # lookuptable and return null. The caller should do
          # the lookup.
          if ((self.attr_lookup_table.contains_key(host)).equal?(false))
            self.attr_lookup_table.put(host, nil)
            return obj
          end
          # If the host is in the lookupTable, it means that another
          # thread is trying to look up the address of this host.
          # This thread should wait.
          while (self.attr_lookup_table.contains_key(host))
            begin
              self.attr_lookup_table.wait
            rescue InterruptedException => e
            end
          end
        end
        # The other thread has finished looking up the address of
        # the host. This thread should retry to get the address
        # from the addressCache. If it doesn't get the address from
        # the cache,  it will try to look up the address itself.
        obj = get_cached_address(host)
        if ((obj).nil?)
          synchronized((self.attr_lookup_table)) do
            self.attr_lookup_table.put(host, nil)
          end
        end
        return obj
      end
      
      typesig { [String] }
      def update_lookup_table(host)
        synchronized((self.attr_lookup_table)) do
          self.attr_lookup_table.remove(host)
          self.attr_lookup_table.notify_all
        end
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Returns an <code>InetAddress</code> object given the raw IP address .
      # The argument is in network byte order: the highest order
      # byte of the address is in <code>getAddress()[0]</code>.
      # 
      # <p> This method doesn't block, i.e. no reverse name service lookup
      # is performed.
      # 
      # <p> IPv4 address byte array must be 4 bytes long and IPv6 byte array
      # must be 16 bytes long
      # 
      # @param addr the raw IP address in network byte order
      # @return  an InetAddress object created from the raw IP address.
      # @exception  UnknownHostException  if IP address is of illegal length
      # @since 1.4
      def get_by_address(addr)
        return get_by_address(nil, addr)
      end
      
      
      def cached_local_host
        defined?(@@cached_local_host) ? @@cached_local_host : @@cached_local_host= nil
      end
      alias_method :attr_cached_local_host, :cached_local_host
      
      def cached_local_host=(value)
        @@cached_local_host = value
      end
      alias_method :attr_cached_local_host=, :cached_local_host=
      
      
      def cache_time
        defined?(@@cache_time) ? @@cache_time : @@cache_time= 0
      end
      alias_method :attr_cache_time, :cache_time
      
      def cache_time=(value)
        @@cache_time = value
      end
      alias_method :attr_cache_time=, :cache_time=
      
      const_set_lazy(:MaxCacheTime) { 5000 }
      const_attr_reader  :MaxCacheTime
      
      const_set_lazy(:CacheLock) { Object.new }
      const_attr_reader  :CacheLock
      
      typesig { [] }
      # Returns the address of the local host. This is achieved by retrieving
      # the name of the host from the system, then resolving that name into
      # an <code>InetAddress</code>.
      # 
      # <P>Note: The resolved address may be cached for a short period of time.
      # </P>
      # 
      # <p>If there is a security manager, its
      # <code>checkConnect</code> method is called
      # with the local host name and <code>-1</code>
      # as its arguments to see if the operation is allowed.
      # If the operation is not allowed, an InetAddress representing
      # the loopback address is returned.
      # 
      # @return     the address of the local host.
      # 
      # @exception  UnknownHostException  if the local host name could not
      #             be resolved into an address.
      # 
      # @see SecurityManager#checkConnect
      # @see java.net.InetAddress#getByName(java.lang.String)
      def get_local_host
        security = System.get_security_manager
        begin
          local = self.attr_impl.get_local_host_name
          if (!(security).nil?)
            security.check_connect(local, -1)
          end
          if ((local == "localhost"))
            return self.attr_impl.loopback_address
          end
          ret = nil
          synchronized((CacheLock)) do
            now = System.current_time_millis
            if (!(self.attr_cached_local_host).nil?)
              if ((now - self.attr_cache_time) < MaxCacheTime)
                # Less than 5s old?
                ret = self.attr_cached_local_host
              else
                self.attr_cached_local_host = nil
              end
            end
            # we are calling getAddressFromNameService directly
            # to avoid getting localHost from cache
            if ((ret).nil?)
              local_addrs = nil
              begin
                local_addrs = InetAddress.get_address_from_name_service(local, nil)
              rescue UnknownHostException => uhe
                raise UnknownHostException.new(local + ": " + RJava.cast_to_string(uhe.get_message))
              end
              self.attr_cached_local_host = local_addrs[0]
              self.attr_cache_time = now
              ret = local_addrs[0]
            end
          end
          return ret
        rescue Java::Lang::SecurityException => e
          return self.attr_impl.loopback_address
        end
      end
      
      JNI.load_native_method :Java_java_net_InetAddress_init, [:pointer, :long], :void
      typesig { [] }
      # Perform class load-time initializations.
      def init
        JNI.call_native_method(:Java_java_net_InetAddress_init, JNI.env, self.jni_id)
      end
      
      typesig { [] }
      # Returns the InetAddress representing anyLocalAddress
      # (typically 0.0.0.0 or ::0)
      def any_local_address
        return self.attr_impl.any_local_address
      end
      
      typesig { [String] }
      # Load and instantiate an underlying impl class
      def load_impl(impl_name)
        impl = nil
        # Property "impl.prefix" will be prepended to the classname
        # of the implementation object we instantiate, to which we
        # delegate the real work (like native methods).  This
        # property can vary across implementations of the java.
        # classes.  The default is an empty String "".
        prefix = AccessController.do_privileged(GetPropertyAction.new("impl.prefix", ""))
        impl = nil
        begin
          impl = Class.for_name("java.net." + prefix + impl_name).new_instance
        rescue ClassNotFoundException => e
          System.err.println("Class not found: java.net." + prefix + impl_name + ":\ncheck impl.prefix property " + "in your properties file.")
        rescue InstantiationException => e
          System.err.println("Could not instantiate: java.net." + prefix + impl_name + ":\ncheck impl.prefix property " + "in your properties file.")
        rescue IllegalAccessException => e
          System.err.println("Cannot access class: java.net." + prefix + impl_name + ":\ncheck impl.prefix property " + "in your properties file.")
        end
        if ((impl).nil?)
          begin
            impl = Class.for_name(impl_name).new_instance
          rescue JavaException => e
            raise JavaError.new("System property impl.prefix incorrect")
          end
        end
        return impl
      end
    }
    
    private
    alias_method :initialize__inet_address, :initialize
  end
  
  # Simple factory to create the impl
  class InetAddressImplFactory 
    include_class_members InetAddressImports
    
    class_module.module_eval {
      typesig { [] }
      def create
        o = nil
        if (is_ipv6supported)
          o = InetAddress.load_impl("Inet6AddressImpl")
        else
          o = InetAddress.load_impl("Inet4AddressImpl")
        end
        return o
      end
      
      JNI.load_native_method :Java_java_net_InetAddressImplFactory_isIPv6Supported, [:pointer, :long], :int8
      typesig { [] }
      def is_ipv6supported
        JNI.call_native_method(:Java_java_net_InetAddressImplFactory_isIPv6Supported, JNI.env, self.jni_id) != 0
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__inet_address_impl_factory, :initialize
  end
  
end
