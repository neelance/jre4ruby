require "rjava"

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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal
  module LoginOptionsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # Implements the ASN.1 KDCOptions type.
  # 
  # <xmp>
  # KDCOptions   ::= KerberosFlags
  # -- reserved(0),
  # -- forwardable(1),
  # -- forwarded(2),
  # -- proxiable(3),
  # -- proxy(4),
  # -- allow-postdate(5),
  # -- postdated(6),
  # -- unused7(7),
  # -- renewable(8),
  # -- unused9(9),
  # -- unused10(10),
  # -- opt-hardware-auth(11),
  # -- unused12(12),
  # -- unused13(13),
  # -- 15 is reserved for canonicalize
  # -- unused15(15),
  # -- 26 was unused in 1510
  # -- disable-transited-check(26),
  # -- renewable-ok(27),
  # -- enc-tkt-in-skey(28),
  # -- renew(30),
  # -- validate(31)
  # 
  # KerberosFlags ::= BIT STRING (SIZE (32..MAX))
  # -- minimum number of bits shall be sent,
  # -- but no fewer than 32
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class LoginOptions < LoginOptionsImports.const_get :KDCOptions
    include_class_members LoginOptionsImports
    
    class_module.module_eval {
      # Login Options
      const_set_lazy(:RESERVED) { 0 }
      const_attr_reader  :RESERVED
      
      const_set_lazy(:FORWARDABLE) { 1 }
      const_attr_reader  :FORWARDABLE
      
      const_set_lazy(:PROXIABLE) { 3 }
      const_attr_reader  :PROXIABLE
      
      const_set_lazy(:ALLOW_POSTDATE) { 5 }
      const_attr_reader  :ALLOW_POSTDATE
      
      const_set_lazy(:RENEWABLE) { 8 }
      const_attr_reader  :RENEWABLE
      
      const_set_lazy(:RENEWABLE_OK) { 27 }
      const_attr_reader  :RENEWABLE_OK
      
      const_set_lazy(:ENC_TKT_IN_SKEY) { 28 }
      const_attr_reader  :ENC_TKT_IN_SKEY
      
      const_set_lazy(:RENEW) { 30 }
      const_attr_reader  :RENEW
      
      const_set_lazy(:VALIDATE) { 31 }
      const_attr_reader  :VALIDATE
      
      const_set_lazy(:MAX) { 31 }
      const_attr_reader  :MAX
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__login_options, :initialize
  end
  
end
