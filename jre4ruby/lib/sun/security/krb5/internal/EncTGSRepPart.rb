require "rjava"

# 
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
  module EncTGSRepPartImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  class EncTGSRepPart < EncTGSRepPartImports.const_get :EncKDCRepPart
    include_class_members EncTGSRepPartImports
    
    typesig { [EncryptionKey, LastReq, ::Java::Int, KerberosTime, TicketFlags, KerberosTime, KerberosTime, KerberosTime, KerberosTime, Realm, PrincipalName, HostAddresses] }
    def initialize(new_key, new_last_req, new_nonce, new_key_expiration, new_flags, new_authtime, new_starttime, new_endtime, new_renew_till, new_srealm, new_sname, new_caddr)
      super(new_key, new_last_req, new_nonce, new_key_expiration, new_flags, new_authtime, new_starttime, new_endtime, new_renew_till, new_srealm, new_sname, new_caddr, Krb5::KRB_ENC_TGS_REP_PART)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      super()
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      super()
      init(encoding)
    end
    
    typesig { [DerValue] }
    def init(encoding)
      init(encoding, Krb5::KRB_ENC_TGS_REP_PART)
    end
    
    typesig { [] }
    def asn1_encode
      return asn1_encode(Krb5::KRB_ENC_TGS_REP_PART)
    end
    
    private
    alias_method :initialize__enc_tgsrep_part, :initialize
  end
  
end
