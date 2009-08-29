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
module Sun::Security::Krb5
  module KrbKdcRepImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  class KrbKdcRep 
    include_class_members KrbKdcRepImports
    
    class_module.module_eval {
      typesig { [KDCReq, KDCRep] }
      def check(req, rep)
        if (!req.attr_req_body.attr_cname.equals_without_realm(rep.attr_cname))
          rep.attr_enc_kdcrep_part.attr_key.destroy
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
        end
        # XXX
        # if (!req.reqBody.crealm.equals(rep.crealm)) {
        # rep.encKDCRepPart.key.destroy();
        # throw new KrbApErrException(Krb5.KRB_AP_ERR_MODIFIED);
        # }
        if (!req.attr_req_body.attr_sname.equals_without_realm(rep.attr_enc_kdcrep_part.attr_sname))
          rep.attr_enc_kdcrep_part.attr_key.destroy
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
        end
        if (!(req.attr_req_body.attr_crealm == rep.attr_enc_kdcrep_part.attr_srealm))
          rep.attr_enc_kdcrep_part.attr_key.destroy
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
        end
        if (!(req.attr_req_body.get_nonce).equal?(rep.attr_enc_kdcrep_part.attr_nonce))
          rep.attr_enc_kdcrep_part.attr_key.destroy
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
        end
        if (((!(req.attr_req_body.attr_addresses).nil? && !(rep.attr_enc_kdcrep_part.attr_caddr).nil?) && !(req.attr_req_body.attr_addresses == rep.attr_enc_kdcrep_part.attr_caddr)))
          rep.attr_enc_kdcrep_part.attr_key.destroy
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
        end
        i = 1
        while i < 6
          if (!(req.attr_req_body.attr_kdc_options.get(i)).equal?(rep.attr_enc_kdcrep_part.attr_flags.get(i)))
            raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
          end
          i += 1
        end
        # XXX Can renew a ticket but not ask for a renewable renewed ticket
        # See impl of Credentials.renew().
        if (!(req.attr_req_body.attr_kdc_options.get(KDCOptions::RENEWABLE)).equal?(rep.attr_enc_kdcrep_part.attr_flags.get(KDCOptions::RENEWABLE)))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
        end
        if (((req.attr_req_body.attr_from).nil?) || req.attr_req_body.attr_from.is_zero)
          # verify this is allowed
          if ((!(rep.attr_enc_kdcrep_part.attr_starttime).nil?) && !rep.attr_enc_kdcrep_part.attr_starttime.in_clock_skew)
            rep.attr_enc_kdcrep_part.attr_key.destroy
            raise KrbApErrException.new(Krb5::KRB_AP_ERR_SKEW)
          end
        end
        if ((!(req.attr_req_body.attr_from).nil?) && !req.attr_req_body.attr_from.is_zero)
          # verify this is allowed
          if ((!(rep.attr_enc_kdcrep_part.attr_starttime).nil?) && !(req.attr_req_body.attr_from == rep.attr_enc_kdcrep_part.attr_starttime))
            rep.attr_enc_kdcrep_part.attr_key.destroy
            raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
          end
        end
        if (!req.attr_req_body.attr_till.is_zero && rep.attr_enc_kdcrep_part.attr_endtime.greater_than(req.attr_req_body.attr_till))
          rep.attr_enc_kdcrep_part.attr_key.destroy
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
        end
        if (req.attr_req_body.attr_kdc_options.get(KDCOptions::RENEWABLE))
          if (!(req.attr_req_body.attr_rtime).nil? && !req.attr_req_body.attr_rtime.is_zero)
            # verify this is required
            if (((rep.attr_enc_kdcrep_part.attr_renew_till).nil?) || rep.attr_enc_kdcrep_part.attr_renew_till.greater_than(req.attr_req_body.attr_rtime))
              rep.attr_enc_kdcrep_part.attr_key.destroy
              raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
            end
          end
        end
        if (req.attr_req_body.attr_kdc_options.get(KDCOptions::RENEWABLE_OK) && rep.attr_enc_kdcrep_part.attr_flags.get(KDCOptions::RENEWABLE))
          if (!req.attr_req_body.attr_till.is_zero)
            # verify this is required
            if (((rep.attr_enc_kdcrep_part.attr_renew_till).nil?) || rep.attr_enc_kdcrep_part.attr_renew_till.greater_than(req.attr_req_body.attr_till))
              rep.attr_enc_kdcrep_part.attr_key.destroy
              raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
            end
          end
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__krb_kdc_rep, :initialize
  end
  
end
