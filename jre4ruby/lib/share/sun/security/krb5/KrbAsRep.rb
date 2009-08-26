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
  module KrbAsRepImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include_const ::Sun::Security::Krb5::Internal::Crypto, :EType
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class encapsulates a AS-REP message that the KDC sends to the
  # client.
  class KrbAsRep < KrbAsRepImports.const_get :KrbKdcRep
    include_class_members KrbAsRepImports
    
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
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    typesig { [Array.typed(::Java::Byte), Array.typed(EncryptionKey), KrbAsReq] }
    def initialize(ibuf, keys, as_req)
      @rep = nil
      @creds = nil
      @debug = false
      super()
      @debug = Krb5::DEBUG
      if ((keys).nil?)
        raise KrbException.new(Krb5::API_INVALID_ARG)
      end
      encoding = DerValue.new(ibuf)
      req = as_req.get_message
      rep = nil
      begin
        rep = ASRep.new(encoding)
      rescue Asn1Exception => e
        rep = nil
        err = KRBError.new(encoding)
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
          ke = KrbException.new(err)
        else
          if (@debug)
            System.out.println("KRBError received: " + e_text)
          end
          # override default text with server text
          ke = KrbException.new(err, e_text)
        end
        ke.init_cause(e)
        raise ke
      end
      enc_part_key_type = rep.attr_enc_part.get_etype
      dkey = EncryptionKey.find_key(enc_part_key_type, keys)
      if ((dkey).nil?)
        raise KrbException.new(Krb5::API_INVALID_ARG, "Cannot find key of appropriate type to decrypt AS REP - " + RJava.cast_to_string(EType.to_s(enc_part_key_type)))
      end
      enc_as_rep_bytes = rep.attr_enc_part.decrypt(dkey, KeyUsage::KU_ENC_AS_REP_PART)
      enc_as_rep_part = rep.attr_enc_part.reset(enc_as_rep_bytes, true)
      encoding = DerValue.new(enc_as_rep_part)
      enc_part = EncASRepPart.new(encoding)
      rep.attr_ticket.attr_sname.set_realm(rep.attr_ticket.attr_realm)
      rep.attr_enc_kdcrep_part = enc_part
      check(req, rep)
      @creds = Credentials.new(rep.attr_ticket, req.attr_req_body.attr_cname, rep.attr_ticket.attr_sname, enc_part.attr_key, enc_part.attr_flags, enc_part.attr_authtime, enc_part.attr_starttime, enc_part.attr_endtime, enc_part.attr_renew_till, enc_part.attr_caddr)
      if (@debug)
        System.out.println(">>> KrbAsRep cons in KrbAsReq.getReply " + RJava.cast_to_string(req.attr_req_body.attr_cname.get_name_string))
      end
      @rep = rep
      @creds = @creds
    end
    
    typesig { [] }
    def get_creds
      return @creds
    end
    
    typesig { [] }
    # made public for Kinit
    def set_credentials
      return Sun::Security::Krb5::Internal::Ccache::Credentials.new(@rep)
    end
    
    private
    alias_method :initialize__krb_as_rep, :initialize
  end
  
end
