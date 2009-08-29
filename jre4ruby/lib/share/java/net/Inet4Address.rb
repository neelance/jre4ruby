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
  module Inet4AddressImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Security, :AccessController
      include_const ::Java::Io, :ObjectStreamException
      include ::Sun::Security::Action
    }
  end
  
  # This class represents an Internet Protocol version 4 (IPv4) address.
  # Defined by <a href="http://www.ietf.org/rfc/rfc790.txt">
  # <i>RFC&nbsp;790: Assigned Numbers</i></a>,
  # <a href="http://www.ietf.org/rfc/rfc1918.txt">
  # <i>RFC&nbsp;1918: Address Allocation for Private Internets</i></a>,
  # and <a href="http://www.ietf.org/rfc/rfc2365.txt"><i>RFC&nbsp;2365:
  # Administratively Scoped IP Multicast</i></a>
  # 
  # <h4> <A NAME="format">Textual representation of IP addresses</a> </h4>
  # 
  # Textual representation of IPv4 address used as input to methods
  # takes one of the following forms:
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>d.d.d.d</tt></td></tr>
  # <tr><td><tt>d.d.d</tt></td></tr>
  # <tr><td><tt>d.d</tt></td></tr>
  # <tr><td><tt>d</tt></td></tr>
  # </table></blockquote>
  # 
  # <p> When four parts are specified, each is interpreted as a byte of
  # data and assigned, from left to right, to the four bytes of an IPv4
  # address.
  # 
  # <p> When a three part address is specified, the last part is
  # interpreted as a 16-bit quantity and placed in the right most two
  # bytes of the network address. This makes the three part address
  # format convenient for specifying Class B net- work addresses as
  # 128.net.host.
  # 
  # <p> When a two part address is supplied, the last part is
  # interpreted as a 24-bit quantity and placed in the right most three
  # bytes of the network address. This makes the two part address
  # format convenient for specifying Class A network addresses as
  # net.host.
  # 
  # <p> When only one part is given, the value is stored directly in
  # the network address without any byte rearrangement.
  # 
  # <p> For methods that return a textual representation as output
  # value, the first form, i.e. a dotted-quad string, is used.
  # 
  # <h4> The Scope of a Multicast Address </h4>
  # 
  # Historically the IPv4 TTL field in the IP header has doubled as a
  # multicast scope field: a TTL of 0 means node-local, 1 means
  # link-local, up through 32 means site-local, up through 64 means
  # region-local, up through 128 means continent-local, and up through
  # 255 are global. However, the administrative scoping is preferred.
  # Please refer to <a href="http://www.ietf.org/rfc/rfc2365.txt">
  # <i>RFC&nbsp;2365: Administratively Scoped IP Multicast</i></a>
  # @since 1.4
  class Inet4Address < Inet4AddressImports.const_get :InetAddress
    include_class_members Inet4AddressImports
    
    class_module.module_eval {
      const_set_lazy(:INADDRSZ) { 4 }
      const_attr_reader  :INADDRSZ
      
      # use serialVersionUID from InetAddress, but Inet4Address instance
      # is always replaced by an InetAddress instance before being
      # serialized
      const_set_lazy(:SerialVersionUID) { 3286316764910316507 }
      const_attr_reader  :SerialVersionUID
      
      # Perform initializations.
      when_class_loaded do
        init
      end
    }
    
    typesig { [] }
    def initialize
      super()
      self.attr_host_name = nil
      self.attr_address = 0
      self.attr_family = IPv4
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    def initialize(host_name, addr)
      super()
      self.attr_host_name = host_name
      self.attr_family = IPv4
      if (!(addr).nil?)
        if ((addr.attr_length).equal?(INADDRSZ))
          self.attr_address = addr[3] & 0xff
          self.attr_address |= ((addr[2] << 8) & 0xff00)
          self.attr_address |= ((addr[1] << 16) & 0xff0000)
          self.attr_address |= ((addr[0] << 24) & -0x1000000)
        end
      end
    end
    
    typesig { [String, ::Java::Int] }
    def initialize(host_name, address)
      super()
      self.attr_host_name = host_name
      self.attr_family = IPv4
      self.attr_address = address
    end
    
    typesig { [] }
    # Replaces the object to be serialized with an InetAddress object.
    # 
    # @return the alternate object to be serialized.
    # 
    # @throws ObjectStreamException if a new object replacing this
    # object could not be created
    def write_replace
      # will replace the to be serialized 'this' object
      inet = InetAddress.new
      inet.attr_host_name = self.attr_host_name
      inet.attr_address = self.attr_address
      # Prior to 1.4 an InetAddress was created with a family
      # based on the platform AF_INET value (usually 2).
      # For compatibility reasons we must therefore write the
      # the InetAddress with this family.
      inet.attr_family = 2
      return inet
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is an
    # IP multicast address. IP multicast address is a Class D
    # address i.e first four bits of the address are 1110.
    # @return a <code>boolean</code> indicating if the InetAddress is
    # an IP multicast address
    # @since   JDK1.1
    def is_multicast_address
      return (((self.attr_address & -0x10000000)).equal?(-0x20000000))
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress in a wildcard address.
    # @return a <code>boolean</code> indicating if the Inetaddress is
    # a wildcard address.
    # @since 1.4
    def is_any_local_address
      return (self.attr_address).equal?(0)
    end
    
    class_module.module_eval {
      # Utility routine to check if the InetAddress is a loopback address.
      # 
      # @return a <code>boolean</code> indicating if the InetAddress is
      # a loopback address; or false otherwise.
      # @since 1.4
      const_set_lazy(:Loopback) { 2130706433 }
      const_attr_reader  :Loopback
    }
    
    typesig { [] }
    # 127.0.0.1
    def is_loopback_address
      # 127.x.x.x
      byte_addr = get_address
      return (byte_addr[0]).equal?(127)
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is an link local address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a link local address; or false if address is not a link local unicast address.
    # @since 1.4
    def is_link_local_address
      # link-local unicast in IPv4 (169.254.0.0/16)
      # defined in "Documenting Special Use IPv4 Address Blocks
      # that have been Registered with IANA" by Bill Manning
      # draft-manning-dsua-06.txt
      return ((((self.attr_address >> 24) & 0xff)).equal?(169)) && ((((self.attr_address >> 16) & 0xff)).equal?(254))
    end
    
    typesig { [] }
    # Utility routine to check if the InetAddress is a site local address.
    # 
    # @return a <code>boolean</code> indicating if the InetAddress is
    # a site local address; or false if address is not a site local unicast address.
    # @since 1.4
    def is_site_local_address
      # refer to RFC 1918
      # 10/8 prefix
      # 172.16/12 prefix
      # 192.168/16 prefix
      return ((((self.attr_address >> 24) & 0xff)).equal?(10)) || (((((self.attr_address >> 24) & 0xff)).equal?(172)) && ((((self.attr_address >> 16) & 0xf0)).equal?(16))) || (((((self.attr_address >> 24) & 0xff)).equal?(192)) && ((((self.attr_address >> 16) & 0xff)).equal?(168)))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has global scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of global scope, false if it is not
    # of global scope or it is not a multicast address
    # @since 1.4
    def is_mcglobal
      # 224.0.1.0 to 238.255.255.255
      byte_addr = get_address
      return ((byte_addr[0] & 0xff) >= 224 && (byte_addr[0] & 0xff) <= 238) && !(((byte_addr[0] & 0xff)).equal?(224) && (byte_addr[1]).equal?(0) && (byte_addr[2]).equal?(0))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has node scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of node-local scope, false if it is not
    # of node-local scope or it is not a multicast address
    # @since 1.4
    def is_mcnode_local
      # unless ttl == 0
      return false
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has link scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of link-local scope, false if it is not
    # of link-local scope or it is not a multicast address
    # @since 1.4
    def is_mclink_local
      # 224.0.0/24 prefix and ttl == 1
      return ((((self.attr_address >> 24) & 0xff)).equal?(224)) && ((((self.attr_address >> 16) & 0xff)).equal?(0)) && ((((self.attr_address >> 8) & 0xff)).equal?(0))
    end
    
    typesig { [] }
    # Utility routine to check if the multicast address has site scope.
    # 
    # @return a <code>boolean</code> indicating if the address has
    # is a multicast address of site-local scope, false if it is not
    # of site-local scope or it is not a multicast address
    # @since 1.4
    def is_mcsite_local
      # 239.255/16 prefix or ttl < 32
      return ((((self.attr_address >> 24) & 0xff)).equal?(239)) && ((((self.attr_address >> 16) & 0xff)).equal?(255))
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
      # 239.192 - 239.195
      return ((((self.attr_address >> 24) & 0xff)).equal?(239)) && (((self.attr_address >> 16) & 0xff) >= 192) && (((self.attr_address >> 16) & 0xff) <= 195)
    end
    
    typesig { [] }
    # Returns the raw IP address of this <code>InetAddress</code>
    # object. The result is in network byte order: the highest order
    # byte of the address is in <code>getAddress()[0]</code>.
    # 
    # @return  the raw IP address of this object.
    def get_address
      addr = Array.typed(::Java::Byte).new(INADDRSZ) { 0 }
      addr[0] = ((self.attr_address >> 24) & 0xff)
      addr[1] = ((self.attr_address >> 16) & 0xff)
      addr[2] = ((self.attr_address >> 8) & 0xff)
      addr[3] = (self.attr_address & 0xff)
      return addr
    end
    
    typesig { [] }
    # Returns the IP address string in textual presentation form.
    # 
    # @return  the raw IP address in a string format.
    # @since   JDK1.0.2
    def get_host_address
      return numeric_to_text_format(get_address)
    end
    
    typesig { [] }
    # Returns a hashcode for this IP address.
    # 
    # @return  a hash code value for this IP address.
    def hash_code
      return self.attr_address
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
    def ==(obj)
      return (!(obj).nil?) && (obj.is_a?(Inet4Address)) && (((obj).attr_address).equal?(self.attr_address))
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      # Utilities
      # 
      # Converts IPv4 binary address into a string suitable for presentation.
      # 
      # @param src a byte array representing an IPv4 numeric address
      # @return a String representing the IPv4 address in
      # textual representation format
      # @since 1.4
      def numeric_to_text_format(src)
        return RJava.cast_to_string((src[0] & 0xff)) + "." + RJava.cast_to_string((src[1] & 0xff)) + "." + RJava.cast_to_string((src[2] & 0xff)) + "." + RJava.cast_to_string((src[3] & 0xff))
      end
      
      JNI.native_method :Java_java_net_Inet4Address_init, [:pointer, :long], :void
      typesig { [] }
      # Perform class load-time initializations.
      def init
        JNI.__send__(:Java_java_net_Inet4Address_init, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__inet4address, :initialize
  end
  
end
