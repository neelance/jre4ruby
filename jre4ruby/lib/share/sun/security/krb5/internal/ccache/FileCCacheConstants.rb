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
module Sun::Security::Krb5::Internal::Ccache
  module FileCCacheConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
    }
  end
  
  # Constants used by file-based credential cache classes.
  # 
  # @author Yanni Zhang
  module FileCCacheConstants
    include_class_members FileCCacheConstantsImports
    
    class_module.module_eval {
      # FCC version 2 contains type information for principals.  FCC
      # version 1 does not.
      # 
      # FCC version 3 contains keyblock encryption type information, and is
      # architecture independent.  Previous versions are not.
      const_set_lazy(:KRB5_FCC_FVNO_1) { 0x501 }
      const_attr_reader  :KRB5_FCC_FVNO_1
      
      const_set_lazy(:KRB5_FCC_FVNO_2) { 0x502 }
      const_attr_reader  :KRB5_FCC_FVNO_2
      
      const_set_lazy(:KRB5_FCC_FVNO_3) { 0x503 }
      const_attr_reader  :KRB5_FCC_FVNO_3
      
      const_set_lazy(:KRB5_FCC_FVNO_4) { 0x504 }
      const_attr_reader  :KRB5_FCC_FVNO_4
      
      const_set_lazy(:FCC_TAG_DELTATIME) { 1 }
      const_attr_reader  :FCC_TAG_DELTATIME
      
      const_set_lazy(:KRB5_NT_UNKNOWN) { 0 }
      const_attr_reader  :KRB5_NT_UNKNOWN
      
      const_set_lazy(:MAXNAMELENGTH) { 1024 }
      const_attr_reader  :MAXNAMELENGTH
      
      const_set_lazy(:TKT_FLG_FORWARDABLE) { 0x40000000 }
      const_attr_reader  :TKT_FLG_FORWARDABLE
      
      const_set_lazy(:TKT_FLG_FORWARDED) { 0x20000000 }
      const_attr_reader  :TKT_FLG_FORWARDED
      
      const_set_lazy(:TKT_FLG_PROXIABLE) { 0x10000000 }
      const_attr_reader  :TKT_FLG_PROXIABLE
      
      const_set_lazy(:TKT_FLG_PROXY) { 0x8000000 }
      const_attr_reader  :TKT_FLG_PROXY
      
      const_set_lazy(:TKT_FLG_MAY_POSTDATE) { 0x4000000 }
      const_attr_reader  :TKT_FLG_MAY_POSTDATE
      
      const_set_lazy(:TKT_FLG_POSTDATED) { 0x2000000 }
      const_attr_reader  :TKT_FLG_POSTDATED
      
      const_set_lazy(:TKT_FLG_INVALID) { 0x1000000 }
      const_attr_reader  :TKT_FLG_INVALID
      
      const_set_lazy(:TKT_FLG_RENEWABLE) { 0x800000 }
      const_attr_reader  :TKT_FLG_RENEWABLE
      
      const_set_lazy(:TKT_FLG_INITIAL) { 0x400000 }
      const_attr_reader  :TKT_FLG_INITIAL
      
      const_set_lazy(:TKT_FLG_PRE_AUTH) { 0x200000 }
      const_attr_reader  :TKT_FLG_PRE_AUTH
      
      const_set_lazy(:TKT_FLG_HW_AUTH) { 0x100000 }
      const_attr_reader  :TKT_FLG_HW_AUTH
    }
  end
  
end
