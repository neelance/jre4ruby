require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SocksConstsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # Constants used by the SOCKS protocol implementation.
  module SocksConsts
    include_class_members SocksConstsImports
    
    class_module.module_eval {
      const_set_lazy(:PROTO_VERS4) { 4 }
      const_attr_reader  :PROTO_VERS4
      
      const_set_lazy(:PROTO_VERS) { 5 }
      const_attr_reader  :PROTO_VERS
      
      const_set_lazy(:DEFAULT_PORT) { 1080 }
      const_attr_reader  :DEFAULT_PORT
      
      const_set_lazy(:NO_AUTH) { 0 }
      const_attr_reader  :NO_AUTH
      
      const_set_lazy(:GSSAPI) { 1 }
      const_attr_reader  :GSSAPI
      
      const_set_lazy(:USER_PASSW) { 2 }
      const_attr_reader  :USER_PASSW
      
      const_set_lazy(:NO_METHODS) { -1 }
      const_attr_reader  :NO_METHODS
      
      const_set_lazy(:CONNECT) { 1 }
      const_attr_reader  :CONNECT
      
      const_set_lazy(:BIND) { 2 }
      const_attr_reader  :BIND
      
      const_set_lazy(:UDP_ASSOC) { 3 }
      const_attr_reader  :UDP_ASSOC
      
      const_set_lazy(:IPV4) { 1 }
      const_attr_reader  :IPV4
      
      const_set_lazy(:DOMAIN_NAME) { 3 }
      const_attr_reader  :DOMAIN_NAME
      
      const_set_lazy(:IPV6) { 4 }
      const_attr_reader  :IPV6
      
      const_set_lazy(:REQUEST_OK) { 0 }
      const_attr_reader  :REQUEST_OK
      
      const_set_lazy(:GENERAL_FAILURE) { 1 }
      const_attr_reader  :GENERAL_FAILURE
      
      const_set_lazy(:NOT_ALLOWED) { 2 }
      const_attr_reader  :NOT_ALLOWED
      
      const_set_lazy(:NET_UNREACHABLE) { 3 }
      const_attr_reader  :NET_UNREACHABLE
      
      const_set_lazy(:HOST_UNREACHABLE) { 4 }
      const_attr_reader  :HOST_UNREACHABLE
      
      const_set_lazy(:CONN_REFUSED) { 5 }
      const_attr_reader  :CONN_REFUSED
      
      const_set_lazy(:TTL_EXPIRED) { 6 }
      const_attr_reader  :TTL_EXPIRED
      
      const_set_lazy(:CMD_NOT_SUPPORTED) { 7 }
      const_attr_reader  :CMD_NOT_SUPPORTED
      
      const_set_lazy(:ADDR_TYPE_NOT_SUP) { 8 }
      const_attr_reader  :ADDR_TYPE_NOT_SUP
    }
  end
  
end
