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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Ktab
  module KeyTabConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ktab
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  # krb v5, keytab version 2 (standard)
  # This class represents a Key Table entry. Each entry contains the service principal of
  # the key, time stamp, key version and secret key itself.
  # 
  # @author Yanni Zhang
  module KeyTabConstants
    include_class_members KeyTabConstantsImports
    
    class_module.module_eval {
      const_set_lazy(:PrincipalComponentSize) { 2 }
      const_attr_reader  :PrincipalComponentSize
      
      const_set_lazy(:RealmSize) { 2 }
      const_attr_reader  :RealmSize
      
      const_set_lazy(:PrincipalSize) { 2 }
      const_attr_reader  :PrincipalSize
      
      const_set_lazy(:PrincipalTypeSize) { 4 }
      const_attr_reader  :PrincipalTypeSize
      
      const_set_lazy(:TimestampSize) { 4 }
      const_attr_reader  :TimestampSize
      
      const_set_lazy(:KeyVersionSize) { 1 }
      const_attr_reader  :KeyVersionSize
      
      const_set_lazy(:KeyTypeSize) { 2 }
      const_attr_reader  :KeyTypeSize
      
      const_set_lazy(:KeySize) { 2 }
      const_attr_reader  :KeySize
      
      const_set_lazy(:KRB5_KT_VNO_1) { 0x501 }
      const_attr_reader  :KRB5_KT_VNO_1
      
      # krb v5, keytab version 1 (DCE compat)
      const_set_lazy(:KRB5_KT_VNO) { 0x502 }
      const_attr_reader  :KRB5_KT_VNO
    }
  end
  
end
