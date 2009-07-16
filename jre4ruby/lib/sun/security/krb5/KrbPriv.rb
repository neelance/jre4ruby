require "rjava"

# 
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
  module KrbPrivImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Crypto
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # XXX This class does not appear to be used. *
  class KrbPriv < KrbPrivImports.const_get :KrbAppMessage
    include_class_members KrbPrivImports
    
    attr_accessor :obuf
    alias_method :attr_obuf, :obuf
    undef_method :obuf
    alias_method :attr_obuf=, :obuf=
    undef_method :obuf=
    
    attr_accessor :user_data
    alias_method :attr_user_data, :user_data
    undef_method :user_data
    alias_method :attr_user_data=, :user_data=
    undef_method :user_data=
    
    typesig { [Array.typed(::Java::Byte), Credentials, EncryptionKey, KerberosTime, SeqNumber, HostAddress, HostAddress] }
    def initialize(user_data, creds, sub_key, timestamp, seq_number, saddr, raddr)
      @obuf = nil
      @user_data = nil
      super()
      req_key = nil
      if (!(sub_key).nil?)
        req_key = sub_key
      else
        req_key = creds.attr_key
      end
      @obuf = mk_priv(user_data, req_key, timestamp, seq_number, saddr, raddr)
    end
    
    typesig { [Array.typed(::Java::Byte), Credentials, EncryptionKey, SeqNumber, HostAddress, HostAddress, ::Java::Boolean, ::Java::Boolean] }
    def initialize(msg, creds, sub_key, seq_number, saddr, raddr, timestamp_required, seq_number_required)
      @obuf = nil
      @user_data = nil
      super()
      krb_priv = KRBPriv.new(msg)
      req_key = nil
      if (!(sub_key).nil?)
        req_key = sub_key
      else
        req_key = creds.attr_key
      end
      @user_data = rd_priv(krb_priv, req_key, seq_number, saddr, raddr, timestamp_required, seq_number_required, creds.attr_client, creds.attr_client.get_realm)
    end
    
    typesig { [] }
    def get_message
      return @obuf
    end
    
    typesig { [] }
    def get_data
      return @user_data
    end
    
    typesig { [Array.typed(::Java::Byte), EncryptionKey, KerberosTime, SeqNumber, HostAddress, HostAddress] }
    def mk_priv(user_data, key, timestamp, seq_number, s_address, r_address)
      usec = nil
      seqno = nil
      if (!(timestamp).nil?)
        usec = timestamp.get_micro_seconds
      end
      if (!(seq_number).nil?)
        seqno = seq_number.current
        seq_number.step
      end
      unenc_enc_krb_priv_part = EncKrbPrivPart.new(user_data, timestamp, usec, seqno, s_address, r_address)
      temp = unenc_enc_krb_priv_part.asn1_encode
      enc_krb_priv_part = EncryptedData.new(key, temp, KeyUsage::KU_ENC_KRB_PRIV_PART)
      krb_priv = KRBPriv.new(enc_krb_priv_part)
      temp = krb_priv.asn1_encode
      return krb_priv.asn1_encode
    end
    
    typesig { [KRBPriv, EncryptionKey, SeqNumber, HostAddress, HostAddress, ::Java::Boolean, ::Java::Boolean, PrincipalName, Realm] }
    def rd_priv(krb_priv, key, seq_number, s_address, r_address, timestamp_required, seq_number_required, cname, crealm)
      bytes = krb_priv.attr_enc_part.decrypt(key, KeyUsage::KU_ENC_KRB_PRIV_PART)
      temp = krb_priv.attr_enc_part.reset(bytes, true)
      ref = DerValue.new(temp)
      enc_part = EncKrbPrivPart.new(ref)
      check(enc_part.attr_timestamp, enc_part.attr_usec, enc_part.attr_seq_number, enc_part.attr_s_address, enc_part.attr_r_address, seq_number, s_address, r_address, timestamp_required, seq_number_required, cname, crealm)
      return enc_part.attr_user_data
    end
    
    private
    alias_method :initialize__krb_priv, :initialize
  end
  
end
