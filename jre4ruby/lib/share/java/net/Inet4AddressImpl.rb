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
module Java::Net
  module Inet4AddressImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
    }
  end
  
  # Package private implementation of InetAddressImpl for IPv4.
  # 
  # @since 1.4
  class Inet4AddressImpl 
    include_class_members Inet4AddressImplImports
    include InetAddressImpl
    
    JNI.native_method :Java_java_net_Inet4AddressImpl_getLocalHostName, [:pointer, :long], :long
    typesig { [] }
    def get_local_host_name
      JNI.__send__(:Java_java_net_Inet4AddressImpl_getLocalHostName, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_net_Inet4AddressImpl_lookupAllHostAddr, [:pointer, :long, :long], :long
    typesig { [String] }
    def lookup_all_host_addr(hostname)
      JNI.__send__(:Java_java_net_Inet4AddressImpl_lookupAllHostAddr, JNI.env, self.jni_id, hostname.jni_id)
    end
    
    JNI.native_method :Java_java_net_Inet4AddressImpl_getHostByAddr, [:pointer, :long, :long], :long
    typesig { [Array.typed(::Java::Byte)] }
    def get_host_by_addr(addr)
      JNI.__send__(:Java_java_net_Inet4AddressImpl_getHostByAddr, JNI.env, self.jni_id, addr.jni_id)
    end
    
    JNI.native_method :Java_java_net_Inet4AddressImpl_isReachable0, [:pointer, :long, :long, :int32, :long, :int32], :int8
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    def is_reachable0(addr, timeout, ifaddr, ttl)
      JNI.__send__(:Java_java_net_Inet4AddressImpl_isReachable0, JNI.env, self.jni_id, addr.jni_id, timeout.to_int, ifaddr.jni_id, ttl.to_int) != 0
    end
    
    typesig { [] }
    def any_local_address
      synchronized(self) do
        if ((@any_local_address).nil?)
          @any_local_address = Inet4Address.new # {0x00,0x00,0x00,0x00}
          @any_local_address.attr_host_name = "0.0.0.0"
        end
        return @any_local_address
      end
    end
    
    typesig { [] }
    def loopback_address
      synchronized(self) do
        if ((@loopback_address).nil?)
          loopback = Array.typed(::Java::Byte).new([0x7f, 0x0, 0x0, 0x1])
          @loopback_address = Inet4Address.new("localhost", loopback)
        end
        return @loopback_address
      end
    end
    
    typesig { [InetAddress, ::Java::Int, NetworkInterface, ::Java::Int] }
    def is_reachable(addr, timeout, netif, ttl)
      ifaddr = nil
      if (!(netif).nil?)
        # Let's make sure we use an address of the proper family
        it = netif.get_inet_addresses
        inetaddr = nil
        while (!(inetaddr.is_a?(Inet4Address)) && it.has_more_elements)
          inetaddr = it.next_element
        end
        if (inetaddr.is_a?(Inet4Address))
          ifaddr = inetaddr.get_address
        end
      end
      return is_reachable0(addr.get_address, timeout, ifaddr, ttl)
    end
    
    attr_accessor :any_local_address
    alias_method :attr_any_local_address, :any_local_address
    undef_method :any_local_address
    alias_method :attr_any_local_address=, :any_local_address=
    undef_method :any_local_address=
    
    attr_accessor :loopback_address
    alias_method :attr_loopback_address, :loopback_address
    undef_method :loopback_address
    alias_method :attr_loopback_address=, :loopback_address=
    undef_method :loopback_address=
    
    typesig { [] }
    def initialize
      @any_local_address = nil
      @loopback_address = nil
    end
    
    private
    alias_method :initialize__inet4address_impl, :initialize
  end
  
end
