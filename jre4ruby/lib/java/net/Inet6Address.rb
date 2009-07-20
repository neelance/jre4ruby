require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module Inet6AddressImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Security, :AccessController
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectStreamException
      include_const ::Java::Io, :InvalidObjectException
      include ::Sun::Security::Action
      include_const ::Java::Util, :Enumeration
    }
  end
  
  # This class represents an Internet Protocol version 6 (IPv6) address.
  # Defined by <a href="http://www.ietf.org/rfc/rfc2373.txt">
  # <i>RFC&nbsp;2373: IP Version 6 Addressing Architecture</i></a>.
  # 
  # <h4> <A NAME="format">Textual representation of IP addresses</a> </h4>
  # 
  # Textual representation of IPv6 address used as input to methods
  # takes one of the following forms:
  # 
  # <ol>
  # <li><p> <A NAME="lform">The preferred form</a> is x:x:x:x:x:x:x:x,
  # where the 'x's are
  # the hexadecimal values of the eight 16-bit pieces of the
  # address. This is the full form.  For example,
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>1080:0:0:0:8:800:200C:417A</tt><td></tr>
  # </table></blockquote>
  # 
  # <p> Note that it is not necessary to write the leading zeros in
  # an individual field. However, there must be at least one numeral
  # in every field, except as described below.</li>
  # 
  # <li><p> Due to some methods of allocating certain styles of IPv6
  # addresses, it will be common for addresses to contain long
  # strings of zero bits. In order to make writing addresses
  # containing zero bits easier, a special syntax is available to
  # compress the zeros. The use of "::" indicates multiple groups
  # of 16-bits of zeros. The "::" can only appear once in an address.
  # The "::" can also be used to compress the leading and/or trailing
  # zeros in an address. For example,
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>1080::8:800:200C:417A</tt><td></tr>
  # </table></blockquote>
  # 
  # <li><p> An alternative form that is sometimes more convenient
  # when dealing with a mixed environment of IPv4 and IPv6 nodes is
  # x:x:x:x:x:x:d.d.d.d, where the 'x's are the hexadecimal values
  # of the six high-order 16-bit pieces of the address, and the 'd's
  # are the decimal values of the four low-order 8-bit pieces of the
  # standard IPv4 representation address, for example,
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>::FFFF:129.144.52.38</tt><td></tr>
  # <tr><td><tt>::129.144.52.38</tt><td></tr>
  # </table></blockquote>
  # 
  # <p> where "::FFFF:d.d.d.d" and "::d.d.d.d" are, respectively, the
  # general forms of an IPv4-mapped IPv6 address and an
  # IPv4-compatible IPv6 address. Note that the IPv4 portion must be
  # in the "d.d.d.d" form. The following forms are invalid:
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>::FFFF:d.d.d</tt><td></tr>
  # <tr><td><tt>::FFFF:d.d</tt><td></tr>
  # <tr><td><tt>::d.d.d</tt><td></tr>
  # <tr><td><tt>::d.d</tt><td></tr>
  # </table></blockquote>
  # 
  # <p> The following form:
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>::FFFF:d</tt><td></tr>
  # </table></blockquote>
  # 
  # <p> is valid, however it is an unconventional representation of
  # the IPv4-compatible IPv6 address,
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>::255.255.0.d</tt><td></tr>
  # </table></blockquote>
  # 
  # <p> while "::d" corresponds to the general IPv6 address
  # "0:0:0:0:0:0:0:d".</li>
  # </ol>
  # 
  # <p> For methods that return a textual representation as output
  # value, the full form is used. Inet6Address will return the full
  # form because it is unambiguous when used in combination with other
  # textual data.
  # 
  # <h4> Special IPv6 address </h4>
  # 
  # <blockquote>
  # <table cellspacing=2 summary="Description of IPv4-mapped address"> <tr><th valign=top><i>IPv4-mapped address</i></th>
  # <td>Of the form::ffff:w.x.y.z, this IPv6 address is used to
  # represent an IPv4 address. It allows the native program to
  # use the same address data structure and also the same
  # socket when communicating with both IPv4 and IPv6 nodes.
  # 
  # <p>In InetAddress and Inet6Address, it is used for internal
  # representation; it has no functional role. Java will never
  # return an IPv4-mapped address.  These classes can take an
  # IPv4-mapped address as input, both in byte array and text
  # representation. However, it will be converted into an IPv4
  # address.</td></tr>
  # </table></blockquote>
  # <p>
  # <h4> <A NAME="scoped">Textual representation of IPv6 scoped addresses</a> </h4>
  # <p>
  # The textual representation of IPv6 addresses as described above can be extended
  # to specify IPv6 scoped addresses. This extension to the basic addressing architecture
  # is described in [draft-ietf-ipngwg-scoping-arch-04.txt].
  # <p>
  # Because link-local and site-local addresses are non-global, it is possible that different hosts
  # may have the same destination address and may be reachable through different interfaces on the
  # same originating system. In this case, the originating system is said to be connected
  # to multiple zones of the same scope. In order to disambiguate which is the intended destination
  # zone, it is possible to append a zone identifier (or <i>scope_id</i>) to an IPv6 address.
  # <p>
  # The general format for specifying the <i>scope_id</i> is the following:
  # <p><blockquote><i>IPv6-address</i>%<i>scope_id</i></blockquote>
  # <p> The IPv6-address is a literal IPv6 address as described above.
  # The <i>scope_id</i> refers to an interface on the local system, and it can be specified
  # in two ways.
  # <p><ol><li><i>As a numeric identifier.</i> This must be a positive integer that identifies the
  # particular interface and scope as understood by the system. Usually, the numeric
  # values can be determined through administration tools on the system. Each interface may
  # have multiple values, one for each scope. If the scope is unspecified, then the default value
  # used is zero.</li><p>
  # <li><i>As a string.</i> This must be the exact string that is returned by
  # {@link java.net.NetworkInterface#getName()} for the particular interface in question.
  # When an Inet6Address is created in this way, the numeric scope-id is determined at the time
  # the object is created by querying the relevant NetworkInterface.</li>
  # </ol><p>
  # Note also, that the numeric <i>scope_id</i> can be retrieved from Inet6Address instances returned from the
  # NetworkInterface class. This can be used to find out the current scope ids configured on the system.
  # @since 1.4
  class Inet6Address < Inet6AddressImports.const_get :InetAddress
    include_class_members Inet6AddressImports
    
    class_module.module_eval {
      const_set_lazy(:INADDRSZ) { 16 }
      const_attr_reader  :INADDRSZ
    }
    
    # cached scope_id - for link-local address use only.
    attr_accessor :cached_scope_id
    alias_method :attr_cached_scope_id, :cached_scope_id
    undef_method :cached_scope_id
    alias_method :attr_cached_scope_id=, :cached_scope_id=
    undef_method :cached_scope_id=
    
    # Holds a 128-bit (16 bytes) IPv6 address.
    # 
    # @serial
    attr_accessor :ipaddress
    alias_method :attr_ipaddress, :ipaddress
    undef_method :ipaddress
    alias_method :attr_ipaddress=, :ipaddress=
    undef_method :ipaddress=
    
    # scope_id. The scope specified when the object is created. If the object is created
    # with an interface name, then the scope_id is not determined until the time it is needed.
    attr_accessor :scope_id
    alias_method :attr_scope_id, :scope_id
    undef_method :scope_id
    alias_method :attr_scope_id=, :scope_id=
    undef_method :scope_id=
    
    # This will be set to true when the scope_id field contains a valid
    # integer scope_id.
    attr_accessor :scope_id_set
    alias_method :attr_scope_id_set, :scope_id_set
    undef_method :scope_id_set
    alias_method :attr_scope_id_set=, :scope_id_set=
    undef_method :scope_id_set=
    
    # scoped interface. scope_id is derived from this as the scope_id of the first
    # address whose scope is the same as this address for the named interface.
    attr_accessor :scope_ifname
    alias_method :attr_scope_ifname, :scope_ifname
    undef_method :scope_ifname
    alias_method :attr_scope_ifname=, :scope_ifname=
    undef_method :scope_ifname=
    
    # set if the object is constructed with a scoped interface instead of a
    # numeric scope id.
    attr_accessor :scope_ifname_set
    alias_method :attr_scope_ifname_set, :scope_ifname_set
    undef_method :scope_ifname_set
    alias_method :attr_scope_ifname_set=, :scope_ifname_set=
    undef_method :scope_ifname_set=
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6880410070516793377 }
      const_attr_reader  :SerialVersionUID
      
      # Perform initializations.
      when_class_loaded do
        init
      end
    }
    
    typesig { [] }
    def initialize
      @cached_scope_id = 0
      @ipaddress = nil
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      @ifname = nil
      super()
      @cached_scope_id = 0
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      self.attr_host_name = nil
      @ipaddress = Array.typed(::Java::Byte).new(INADDRSZ) { 0 }
      self.attr_family = IPv6
    end
    
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int] }
    # checking of value for scope_id should be done by caller
    # scope_id must be >= 0, or -1 to indicate not being set
    def initialize(host_name, addr, scope_id)
      @cached_scope_id = 0
      @ipaddress = nil
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      @ifname = nil
      super()
      @cached_scope_id = 0
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      self.attr_host_name = host_name
      if ((addr.attr_length).equal?(INADDRSZ))
        # normal IPv6 address
        self.attr_family = IPv6
        @ipaddress = addr.clone
      end
      if (scope_id >= 0)
        @scope_id = scope_id
        @scope_id_set = true
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    def initialize(host_name, addr)
      @cached_scope_id = 0
      @ipaddress = nil
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      @ifname = nil
      super()
      @cached_scope_id = 0
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      begin
        initif(host_name, addr, nil)
      rescue UnknownHostException => e
      end
      # cant happen if ifname is null
    end
    
    typesig { [String, Array.typed(::Java::Byte), NetworkInterface] }
    def initialize(host_name, addr, nif)
      @cached_scope_id = 0
      @ipaddress = nil
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      @ifname = nil
      super()
      @cached_scope_id = 0
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      initif(host_name, addr, nif)
    end
    
    typesig { [String, Array.typed(::Java::Byte), String] }
    def initialize(host_name, addr, ifname)
      @cached_scope_id = 0
      @ipaddress = nil
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      @ifname = nil
      super()
      @cached_scope_id = 0
      @scope_id = 0
      @scope_id_set = false
      @scope_ifname = nil
      @scope_ifname_set = false
      initstr(host_name, addr, ifname)
    end
    
    class_module.module_eval {
      typesig { [String, Array.typed(::Java::Byte), NetworkInterface] }
      # Create an Inet6Address in the exact manner of {@link InetAddress#getByAddress(String,byte[])}
      # except that the IPv6 scope_id is set to the value corresponding to the given interface
      # for the address type specified in <code>addr</code>.
      # The call will fail with an UnknownHostException if the given interface does not have a numeric
      # scope_id assigned for the given address type (eg. link-local or site-local).
      # See <a href="Inet6Address.html#scoped">here</a> for a description of IPv6
      # scoped addresses.
      # 
      # @param host the specified host
      # @param addr the raw IP address in network byte order
      # @param nif an interface this address must be associated with.
      # @return  an Inet6Address object created from the raw IP address.
      # @exception  UnknownHostException  if IP address is of illegal length, or if the interface
      # does not have a numeric scope_id assigned for the given address type.
      # 
      # @since 1.5
      def get_by_address(host, addr, nif)
        if (!(host).nil? && host.length > 0 && (host.char_at(0)).equal?(Character.new(?[.ord)))
          if ((host.char_at(host.length - 1)).equal?(Character.new(?].ord)))
            host = (host.substring(1, host.length - 1)).to_s
          end
        end
        if (!(addr).nil?)
          if ((addr.attr_length).equal?(Inet6Address::INADDRSZ))
            return Inet6Address.new(host, addr, nif)
          end
        end
        raise UnknownHostException.new("addr is of illegal length")
      end
      
      typesig { [String, Array.typed(::Java::Byte), ::Java::Int] }
      # Create an Inet6Address in the exact manner of {@link InetAddress#getByAddress(String,byte[])}
      # except that the IPv6 scope_id is set to the given numeric value.
      # The scope_id is not checked to determine if it corresponds to any interface on the system.
      # See <a href="Inet6Address.html#scoped">here</a> for a description of IPv6
      # scoped addresses.
      # 
      # @param host the specified host
      # @param addr the raw IP address in network byte order
      # @param scope_id the numeric scope_id for the address.
      # @return  an Inet6Address object created from the raw IP address.
      # @exception  UnknownHostException  if IP address is of illegal length.
      # 
      # @since 1.5
      def get_by_address(host, addr, scope_id)
        if (!(host).nil? && host.length > 0 && (host.char_at(0)).equal?(Character.new(?[.ord)))
          if ((host.char_at(host.length - 1)).equal?(Character.new(?].ord)))
            host = (host.substring(1, host.length - 1)).to_s
          end
        end
        if (!(addr).nil?)
          if ((addr.attr_length).equal?(Inet6Address::INADDRSZ))
            return Inet6Address.new(host, addr, scope_id)
          end
        end
        raise UnknownHostException.new("addr is of illegal length")
      end
    }
    
    typesig { [String, Array.typed(::Java::Byte), String] }
    def initstr(host_name, addr, ifname)
      begin
        nif = NetworkInterface.get_by_name(ifname)
        if ((nif).nil?)
          raise UnknownHostException.new("no such interface " + ifname)
        end
        initif(host_name, addr, nif)
      rescue SocketException => e
        raise UnknownHostException.new("SocketException thrown" + ifname)
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte), NetworkInterface] }
    def initif(host_name, addr, nif)
      self.attr_host_name = host_name
      if ((addr.attr_length).equal?(INADDRSZ))
        # normal IPv6 address
        self.attr_family = IPv6
        @ipaddress = addr.clone
      end
      if (!(nif).nil?)
        @scope_ifname = nif
        @scope_ifname_set = true
        @scope_id = derive_numeric_scope(nif)
        @scope_id_set = true
      end
    end
    
    typesig { [Inet6Address] }
    # check the two Ipv6 addresses and return false if they are both
    # non global address types, but not the same.
    # (ie. one is sitelocal and the other linklocal)
    # return true otherwise.
    def different_local_address_types(other)
      if (is_link_local_address && !other.is_link_local_address)
        return false
      end
      if (is_site_local_address && !other.is_site_local_address)
        return false
      end
      return true
    end
    
    typesig { [NetworkInterface] }
    def derive_numeric_scope(ifc)
      addresses = ifc.get_inet_addresses
      while (addresses.has_more_elements)
        address = addresses.next_element
        if (!(address.is_a?(Inet6Address)))
          next
        end
        ia6_addr = address
        # check if site or link local prefixes match
        if (!different_local_address_types(ia6_addr))
          # type not the same, so carry on searching
          next
        end
        # found a matching address - return its scope_id
        return ia6_addr.attr_scope_id
      end
      raise UnknownHostException.new("no scope_id found")
    end
    
    typesig { [String] }
    def derive_numeric_scope(ifname)
      en = nil
      begin
        en = NetworkInterface.get_network_interfaces
      rescue SocketException => e
        raise UnknownHostException.new("could not enumerate local network interfaces")
      end
      while (en.has_more_elements)
        ifc = en.next_element
        if ((ifc.get_name == ifname))
          addresses = ifc.get_inet_addresses
          while (addresses.has_more_elements)
            address = addresses.next_element
            if (!(address.is_a?(Inet6Address)))
              next
            end
            ia6_addr = address
            # check if site or link local prefixes match
            if (!different_local_address_types(ia6_addr))
              # type not the same, so carry on searching
              next
            end
            # found a matching address - return its scope_id
            return ia6_addr.attr_scope_id
          end
        end
      end
      raise UnknownHostException.new("No matching address found for interface : " + ifname)
    end
    
    typesig { [ObjectInputStream] }
    # restore the state of this object from stream
    # including the scope information, only if the
    # scoped interface name is valid on this system
    def read_object(s)
      @scope_ifname = nil
      @scope_ifname_set = false
      s.default_read_object
      if (!(@ifname).nil? && !("" == @ifname))
        begin
          @scope_ifname = NetworkInterface.get_by_name(@ifname)
          begin
            @scope_id = derive_numeric_scope(@scope_ifname)
          rescue UnknownHostException => e
            # should not happen
            raise AssertError if not (false)
          end
        rescue SocketException => e
        end
        if ((@scope_ifname).nil?)
          # the interface does not exist on this system, so we clear
          # the scope information completely
          @scope_id_set = false
          @scope_ifname_set = false
          @scope_id = 0
        end
      end
      # if ifname was not supplied, then the numeric info is used
      @ipaddress = @ipaddress.clone
      # Check that our invariants are satisfied
      if (!(@ipaddress.attr_length).equal?(INADDRSZ))
        raise InvalidObjectException.new("invalid address length: " + (@ipaddress.attr_length).to_s)
      end
      if (!(self.attr_family).equal?(IPv6))
        raise InvalidObjectException.new("invalid address family type")
      end
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is an IP multicast
    # address. 11111111 at the start of the address identifies the
    # address as being a multicast address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # an IP multicast address
    # @since JDK1.1
    def is_multicast_address
      return (((@ipaddress[0] & 0xff)).equal?(0xff))
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress in a wildcard address.
    # @return a <code>boolean</code> indicating if the Inetaddress is
    # a wildcard address.
    # @since 1.4
    def is_any_local_address
      test = 0x0
      i = 0
      while i < INADDRSZ
        test |= @ipaddress[i]
        i += 1
      end
      return ((test).equal?(0x0))
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is a loopback address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a loopback address; or false otherwise.
    # @since 1.4
    def is_loopback_address
      test = 0x0
      i = 0
      while i < 15
        test |= @ipaddress[i]
        i += 1
      end
      return ((test).equal?(0x0)) && ((@ipaddress[15]).equal?(0x1))
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is an link local address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a link local address; or false if address is not a link local unicast address.
    # @since 1.4
    def is_link_local_address
      return (((@ipaddress[0] & 0xff)).equal?(0xfe) && ((@ipaddress[1] & 0xc0)).equal?(0x80))
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is a site local address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a site local address; or false if address is not a site local unicast address.
    # @since 1.4
    def is_site_local_address
      return (((@ipaddress[0] & 0xff)).equal?(0xfe) && ((@ipaddress[1] & 0xc0)).equal?(0xc0))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has global scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of global scope, false if it is not
    # of global scope or it is not a multicast address
    # @since 1.4
    def is_mcglobal
      return (((@ipaddress[0] & 0xff)).equal?(0xff) && ((@ipaddress[1] & 0xf)).equal?(0xe))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has node scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of node-local scope, false if it is not
    # of node-local scope or it is not a multicast address
    # @since 1.4
    def is_mcnode_local
      return (((@ipaddress[0] & 0xff)).equal?(0xff) && ((@ipaddress[1] & 0xf)).equal?(0x1))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has link scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of link-local scope, false if it is not
    # of link-local scope or it is not a multicast address
    # @since 1.4
    def is_mclink_local
      return (((@ipaddress[0] & 0xff)).equal?(0xff) && ((@ipaddress[1] & 0xf)).equal?(0x2))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has site scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of site-local scope, false if it is not
    # of site-local scope or it is not a multicast address
    # @since 1.4
    def is_mcsite_local
      return (((@ipaddress[0] & 0xff)).equal?(0xff) && ((@ipaddress[1] & 0xf)).equal?(0x5))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has organization scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of organization-local scope,
    # false if it is not of organization-local scope
    # or it is not a multicast address
    # @since 1.4
    def is_mcorg_local
      return (((@ipaddress[0] & 0xff)).equal?(0xff) && ((@ipaddress[1] & 0xf)).equal?(0x8))
    end
    
    typesig { [] }
    # Returns the raw IP address of this <code>InetAddress</code>
    # object. The result is in network byte order: the highest order
    # byte of the address is in <code>getAddress()[0]</code>.
    # 
    # @return  the raw IP address of this object.
    def get_address
      return @ipaddress.clone
    end
    
    typesig { [] }
    # Returns the numeric scopeId, if this instance is associated with
    # an interface. If no scoped_id is set, the returned value is zero.
    # 
    # @return the scopeId, or zero if not set.
    # @since 1.5
    def get_scope_id
      return @scope_id
    end
    
    typesig { [] }
    # Returns the scoped interface, if this instance was created with
    # with a scoped interface.
    # 
    # @return the scoped interface, or null if not set.
    # @since 1.5
    def get_scoped_interface
      return @scope_ifname
    end
    
    typesig { [] }
    # Returns the IP address string in textual presentation. If the instance was created
    # specifying a scope identifier then the scope id is appended to the IP address preceded by
    # a "%" (per-cent) character. This can be either a numeric value or a string, depending on which
    # was used to createthe instance.
    # 
    # @return  the raw IP address in a string format.
    def get_host_address
      s = numeric_to_text_format(@ipaddress)
      if (@scope_ifname_set)
        # must check this first
        s = s + "%" + (@scope_ifname.get_name).to_s
      else
        if (@scope_id_set)
          s = s + "%" + (@scope_id).to_s
        end
      end
      return s
    end
    
    typesig { [] }
    # Returns a hashcode for this IP address.
    # 
    # @return  a hash code value for this IP address.
    def hash_code
      if (!(@ipaddress).nil?)
        hash = 0
        i = 0
        while (i < INADDRSZ)
          j = 0
          component = 0
          while (j < 4 && i < INADDRSZ)
            component = (component << 8) + @ipaddress[i]
            j += 1
            i += 1
          end
          hash += component
        end
        return hash
      else
        return 0
      end
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
    # <code>false</code> otherwise.
    # @see     java.net.InetAddress#getAddress()
    def equals(obj)
      if ((obj).nil? || !(obj.is_a?(Inet6Address)))
        return false
      end
      inet_addr = obj
      i = 0
      while i < INADDRSZ
        if (!(@ipaddress[i]).equal?(inet_addr.attr_ipaddress[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is an
    # IPv4 compatible IPv6 address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # an IPv4 compatible IPv6 address; or false if address is IPv4 address.
    # @since 1.4
    def is_ipv4compatible_address
      if (((@ipaddress[0]).equal?(0x0)) && ((@ipaddress[1]).equal?(0x0)) && ((@ipaddress[2]).equal?(0x0)) && ((@ipaddress[3]).equal?(0x0)) && ((@ipaddress[4]).equal?(0x0)) && ((@ipaddress[5]).equal?(0x0)) && ((@ipaddress[6]).equal?(0x0)) && ((@ipaddress[7]).equal?(0x0)) && ((@ipaddress[8]).equal?(0x0)) && ((@ipaddress[9]).equal?(0x0)) && ((@ipaddress[10]).equal?(0x0)) && ((@ipaddress[11]).equal?(0x0)))
        return true
      end
      return false
    end
    
    class_module.module_eval {
      # Utilities
      const_set_lazy(:INT16SZ) { 2 }
      const_attr_reader  :INT16SZ
      
      typesig { [Array.typed(::Java::Byte)] }
      # Convert IPv6 binary address into presentation (printable) format.
      # 
      # @param src a byte array representing the IPv6 numeric address
      # @return a String representing an IPv6 address in
      # textual representation format
      # @since 1.4
      def numeric_to_text_format(src)
        sb = StringBuffer.new(39)
        i = 0
        while i < (INADDRSZ / INT16SZ)
          sb.append(JavaInteger.to_hex_string(((src[i << 1] << 8) & 0xff00) | (src[(i << 1) + 1] & 0xff)))
          if (i < (INADDRSZ / INT16SZ) - 1)
            sb.append(":")
          end
          i += 1
        end
        return sb.to_s
      end
      
      JNI.native_method :Java_java_net_Inet6Address_init, [:pointer, :long], :void
      typesig { [] }
      # Perform class load-time initializations.
      def init
        JNI.__send__(:Java_java_net_Inet6Address_init, JNI.env, self.jni_id)
      end
    }
    
    # Following field is only used during (de)/serialization
    attr_accessor :ifname
    alias_method :attr_ifname, :ifname
    undef_method :ifname
    alias_method :attr_ifname=, :ifname=
    undef_method :ifname=
    
    typesig { [Java::Io::ObjectOutputStream] }
    # default behavior is overridden in order to write the
    # scope_ifname field as a String, rather than a NetworkInterface
    # which is not serializable
    def write_object(s)
      synchronized(self) do
        if (@scope_ifname_set)
          @ifname = (@scope_ifname.get_name).to_s
        end
        s.default_write_object
      end
    end
    
    private
    alias_method :initialize__inet6address, :initialize
  end
  
end
