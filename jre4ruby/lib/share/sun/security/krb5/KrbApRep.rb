require "rjava"

# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KrbApRepImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class encapsulates a KRB-AP-REP sent from the service to the
  # client.
  class KrbApRep 
    include_class_members KrbApRepImports
    
    attr_accessor :obuf
    alias_method :attr_obuf, :obuf
    undef_method :obuf
    alias_method :attr_obuf=, :obuf=
    undef_method :obuf=
    
    attr_accessor :ibuf
    alias_method :attr_ibuf, :ibuf
    undef_method :ibuf
    alias_method :attr_ibuf=, :ibuf=
    undef_method :ibuf=
    
    attr_accessor :enc_part
    alias_method :attr_enc_part, :enc_part
    undef_method :enc_part
    alias_method :attr_enc_part=, :enc_part=
    undef_method :enc_part=
    
    # although in plain text
    attr_accessor :ap_rep_messg
    alias_method :attr_ap_rep_messg, :ap_rep_messg
    undef_method :ap_rep_messg
    alias_method :attr_ap_rep_messg=, :ap_rep_messg=
    undef_method :ap_rep_messg=
    
    typesig { [KrbApReq, ::Java::Boolean, ::Java::Boolean] }
    # Constructs a KRB-AP-REP to send to a client.
    # @throws KrbException
    # @throws IOException
    # 
    # Used in AcceptSecContextToken
    def initialize(incoming_req, use_seq_number, use_sub_key)
      @obuf = nil
      @ibuf = nil
      @enc_part = nil
      @ap_rep_messg = nil
      sub_key = (use_sub_key ? EncryptionKey.new(incoming_req.get_creds.get_session_key) : nil)
      seq_num = LocalSeqNumber.new
      init(incoming_req, sub_key, seq_num)
    end
    
    typesig { [Array.typed(::Java::Byte), Credentials, KrbApReq] }
    # Constructs a KRB-AP-REQ from the bytes received from a service.
    # @throws KrbException
    # @throws IOException
    # 
    # Used in AcceptSecContextToken
    def initialize(message, tgt_creds, outgoing_req)
      initialize__krb_ap_rep(message, tgt_creds)
      authenticate(outgoing_req)
    end
    
    typesig { [KrbApReq, EncryptionKey, SeqNumber] }
    def init(ap_req, sub_key, seq_number)
      create_message(ap_req.get_creds.attr_key, ap_req.get_ctime, ap_req.cusec, sub_key, seq_number)
      @obuf = @ap_rep_messg.asn1_encode
    end
    
    typesig { [Array.typed(::Java::Byte), Credentials] }
    # Constructs a KrbApRep object.
    # @param msg a byte array of reply message.
    # @param tgs_creds client's credential.
    # @exception KrbException
    # @exception IOException
    def initialize(msg, tgs_creds)
      initialize__krb_ap_rep(DerValue.new(msg), tgs_creds)
    end
    
    typesig { [DerValue, Credentials] }
    # Constructs a KrbApRep object.
    # @param msg a byte array of reply message.
    # @param tgs_creds client's credential.
    # @exception KrbException
    # @exception IOException
    def initialize(encoding, tgs_creds)
      @obuf = nil
      @ibuf = nil
      @enc_part = nil
      @ap_rep_messg = nil
      rep = nil
      begin
        rep = APRep.new(encoding)
      rescue Asn1Exception => e
        rep = nil
        err = KRBError.new(encoding)
        err_str = err.get_error_string
        e_text = nil
        if ((err_str.char_at(err_str.length - 1)).equal?(0))
          e_text = RJava.cast_to_string(err_str.substring(0, err_str.length - 1))
        else
          e_text = err_str
        end
        ke = KrbException.new(err.get_error_code, e_text)
        ke.init_cause(e)
        raise ke
      end
      temp = rep.attr_enc_part.decrypt(tgs_creds.attr_key, KeyUsage::KU_ENC_AP_REP_PART)
      enc_ap_rep_part = rep.attr_enc_part.reset(temp, true)
      encoding = DerValue.new(enc_ap_rep_part)
      @enc_part = EncAPRepPart.new(encoding)
    end
    
    typesig { [KrbApReq] }
    def authenticate(ap_req)
      if (!(@enc_part.attr_ctime.get_seconds).equal?(ap_req.get_ctime.get_seconds) || !(@enc_part.attr_cusec).equal?(ap_req.get_ctime.get_micro_seconds))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_MUT_FAIL)
      end
    end
    
    typesig { [] }
    # Returns the optional subkey stored in
    # this message. Returns null if none is stored.
    def get_sub_key
      # XXX Can encPart be null
      return @enc_part.get_sub_key
    end
    
    typesig { [] }
    # Returns the optional sequence number stored in the
    # this message. Returns null if none is stored.
    def get_seq_number
      # XXX Can encPart be null
      return @enc_part.get_seq_number
    end
    
    typesig { [] }
    # Returns the ASN.1 encoding that should be sent to the peer.
    def get_message
      return @obuf
    end
    
    typesig { [EncryptionKey, KerberosTime, ::Java::Int, EncryptionKey, SeqNumber] }
    def create_message(key, ctime, cusec_, sub_key, seq_number)
      seqno = nil
      if (!(seq_number).nil?)
        seqno = seq_number.current
      end
      @enc_part = EncAPRepPart.new(ctime, cusec_, sub_key, seqno)
      enc_part_encoding = @enc_part.asn1_encode
      enc_enc_part = EncryptedData.new(key, enc_part_encoding, KeyUsage::KU_ENC_AP_REP_PART)
      @ap_rep_messg = APRep.new(enc_enc_part)
    end
    
    private
    alias_method :initialize__krb_ap_rep, :initialize
  end
  
end
