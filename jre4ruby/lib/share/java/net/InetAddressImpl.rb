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
  module InetAddressImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
    }
  end
  
  # Package private interface to "implementation" used by
  # {@link InetAddress}.
  # <p>
  # See {@link java.net.Inet4AddressImp} and
  # {@link java.net.Inet6AddressImp}.
  # 
  # @since 1.4
  module InetAddressImpl
    include_class_members InetAddressImplImports
    
    typesig { [] }
    def get_local_host_name
      raise NotImplementedError
    end
    
    typesig { [String] }
    def lookup_all_host_addr(hostname)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def get_host_by_addr(addr)
      raise NotImplementedError
    end
    
    typesig { [] }
    def any_local_address
      raise NotImplementedError
    end
    
    typesig { [] }
    def loopback_address
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int, NetworkInterface, ::Java::Int] }
    def is_reachable(addr, timeout, netif, ttl)
      raise NotImplementedError
    end
  end
  
end
