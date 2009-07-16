require "rjava"

# 
# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal::Crypto
  module KeyUsageImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Crypto
    }
  end
  
  # 
  # Key usages used for key derivation in Kerberos.
  class KeyUsage 
    include_class_members KeyUsageImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      const_set_lazy(:KU_UNKNOWN) { 0 }
      const_attr_reader  :KU_UNKNOWN
      
      # Cannot be 0
      # Defined in draft-yu-krb-wg-kerberos-extensions-00.txt, Appendix A
      const_set_lazy(:KU_PA_ENC_TS) { 1 }
      const_attr_reader  :KU_PA_ENC_TS
      
      # KrbAsReq
      const_set_lazy(:KU_TICKET) { 2 }
      const_attr_reader  :KU_TICKET
      
      # KrbApReq (ticket)
      const_set_lazy(:KU_ENC_AS_REP_PART) { 3 }
      const_attr_reader  :KU_ENC_AS_REP_PART
      
      # KrbAsRep
      const_set_lazy(:KU_TGS_REQ_AUTH_DATA_SESSKEY) { 4 }
      const_attr_reader  :KU_TGS_REQ_AUTH_DATA_SESSKEY
      
      # KrbTgsReq
      const_set_lazy(:KU_TGS_REQ_AUTH_DATA_SUBKEY) { 5 }
      const_attr_reader  :KU_TGS_REQ_AUTH_DATA_SUBKEY
      
      # KrbTgsReq
      const_set_lazy(:KU_PA_TGS_REQ_CKSUM) { 6 }
      const_attr_reader  :KU_PA_TGS_REQ_CKSUM
      
      # KrbTgsReq
      const_set_lazy(:KU_PA_TGS_REQ_AUTHENTICATOR) { 7 }
      const_attr_reader  :KU_PA_TGS_REQ_AUTHENTICATOR
      
      # KrbApReq
      const_set_lazy(:KU_ENC_TGS_REP_PART_SESSKEY) { 8 }
      const_attr_reader  :KU_ENC_TGS_REP_PART_SESSKEY
      
      # KrbTgsRep
      const_set_lazy(:KU_ENC_TGS_REP_PART_SUBKEY) { 9 }
      const_attr_reader  :KU_ENC_TGS_REP_PART_SUBKEY
      
      # KrbTgsRep
      const_set_lazy(:KU_AUTHENTICATOR_CKSUM) { 10 }
      const_attr_reader  :KU_AUTHENTICATOR_CKSUM
      
      const_set_lazy(:KU_AP_REQ_AUTHENTICATOR) { 11 }
      const_attr_reader  :KU_AP_REQ_AUTHENTICATOR
      
      # KrbApReq
      const_set_lazy(:KU_ENC_AP_REP_PART) { 12 }
      const_attr_reader  :KU_ENC_AP_REP_PART
      
      # KrbApRep
      const_set_lazy(:KU_ENC_KRB_PRIV_PART) { 13 }
      const_attr_reader  :KU_ENC_KRB_PRIV_PART
      
      # KrbPriv
      const_set_lazy(:KU_ENC_KRB_CRED_PART) { 14 }
      const_attr_reader  :KU_ENC_KRB_CRED_PART
      
      # KrbCred
      const_set_lazy(:KU_KRB_SAFE_CKSUM) { 15 }
      const_attr_reader  :KU_KRB_SAFE_CKSUM
      
      # KrbSafe
      const_set_lazy(:KU_AD_KDC_ISSUED_CKSUM) { 19 }
      const_attr_reader  :KU_AD_KDC_ISSUED_CKSUM
      
      typesig { [::Java::Int] }
      def is_valid(usage)
        return usage >= 0
      end
    }
    
    private
    alias_method :initialize__key_usage, :initialize
  end
  
end
