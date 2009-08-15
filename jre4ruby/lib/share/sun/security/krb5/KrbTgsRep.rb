require "rjava"

# Portions Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KrbTgsRepImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class encapsulates a TGS-REP that is sent from the KDC to the
  # Kerberos client.
  class KrbTgsRep < KrbTgsRepImports.const_get :KrbKdcRep
    include_class_members KrbTgsRepImports
    
    attr_accessor :rep
    alias_method :attr_rep, :rep
    undef_method :rep
    alias_method :attr_rep=, :rep=
    undef_method :rep=
    
    attr_accessor :creds
    alias_method :attr_creds, :creds
    undef_method :creds
    alias_method :attr_creds=, :creds=
    undef_method :creds=
    
    attr_accessor :second_ticket
    alias_method :attr_second_ticket, :second_ticket
    undef_method :second_ticket
    alias_method :attr_second_ticket=, :second_ticket=
    undef_method :second_ticket=
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Krb5::DEBUG }
      const_attr_reader  :DEBUG
    }
    
    typesig { [Array.typed(::Java::Byte), KrbTgsReq] }
    def initialize(ibuf, tgs_req)
      @rep = nil
      @creds = nil
      @second_ticket = nil
      super()
      ref = DerValue.new(ibuf)
      req = tgs_req.get_message
      rep = nil
      begin
        rep = TGSRep.new(ref)
      rescue Asn1Exception => e
        rep = nil
        err = KRBError.new(ref)
        err_str = err.get_error_string
        e_text = nil # pick up text sent by the server (if any)
        if (!(err_str).nil? && err_str.length > 0)
          if ((err_str.char_at(err_str.length - 1)).equal?(0))
            e_text = RJava.cast_to_string(err_str.substring(0, err_str.length - 1))
          else
            e_text = err_str
          end
        end
        ke = nil
        if ((e_text).nil?)
          # no text sent from server
          ke = KrbException.new(err.get_error_code)
        else
          # override default text with server text
          ke = KrbException.new(err.get_error_code, e_text)
        end
        ke.init_cause(e)
        raise ke
      end
      enc_tgs_rep_bytes = rep.attr_enc_part.decrypt(tgs_req.attr_tgs_req_key, tgs_req.used_subkey ? KeyUsage::KU_ENC_TGS_REP_PART_SUBKEY : KeyUsage::KU_ENC_TGS_REP_PART_SESSKEY)
      enc_tgs_rep_part = rep.attr_enc_part.reset(enc_tgs_rep_bytes, true)
      ref = DerValue.new(enc_tgs_rep_part)
      enc_part = EncTGSRepPart.new(ref)
      rep.attr_ticket.attr_sname.set_realm(rep.attr_ticket.attr_realm)
      rep.attr_enc_kdcrep_part = enc_part
      check(req, rep)
      @creds = Credentials.new(rep.attr_ticket, req.attr_req_body.attr_cname, rep.attr_ticket.attr_sname, enc_part.attr_key, enc_part.attr_flags, enc_part.attr_authtime, enc_part.attr_starttime, enc_part.attr_endtime, enc_part.attr_renew_till, enc_part.attr_caddr)
      @rep = rep
      @creds = @creds
      @second_ticket = tgs_req.get_second_ticket
    end
    
    typesig { [] }
    # Return the credentials that were contained in this KRB-TGS-REP.
    def get_creds
      return @creds
    end
    
    typesig { [] }
    def set_credentials
      return Sun::Security::Krb5::Internal::Ccache::Credentials.new(@rep, @second_ticket)
    end
    
    private
    alias_method :initialize__krb_tgs_rep, :initialize
  end
  
end
