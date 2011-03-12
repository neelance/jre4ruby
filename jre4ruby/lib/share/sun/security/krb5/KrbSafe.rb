require "rjava"

# Portions Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5
  module KrbSafeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Java::Io, :IOException
    }
  end
  
  class KrbSafe < KrbSafeImports.const_get :KrbAppMessage
    include_class_members KrbSafeImports
    
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
      @obuf = mk_safe(user_data, req_key, timestamp, seq_number, saddr, raddr)
    end
    
    typesig { [Array.typed(::Java::Byte), Credentials, EncryptionKey, SeqNumber, HostAddress, HostAddress, ::Java::Boolean, ::Java::Boolean] }
    def initialize(msg, creds, sub_key, seq_number, saddr, raddr, timestamp_required, seq_number_required)
      @obuf = nil
      @user_data = nil
      super()
      krb_safe = KRBSafe.new(msg)
      req_key = nil
      if (!(sub_key).nil?)
        req_key = sub_key
      else
        req_key = creds.attr_key
      end
      @user_data = rd_safe(krb_safe, req_key, seq_number, saddr, raddr, timestamp_required, seq_number_required, creds.attr_client, creds.attr_client.get_realm)
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
    def mk_safe(user_data, key, timestamp, seq_number, s_address, r_address)
      usec = nil
      seqno = nil
      if (!(timestamp).nil?)
        usec = timestamp.get_micro_seconds
      end
      if (!(seq_number).nil?)
        seqno = seq_number.current
        seq_number.step
      end
      krb_safe_body = KRBSafeBody.new(user_data, timestamp, usec, seqno, s_address, r_address)
      temp = krb_safe_body.asn1_encode
      cksum = Checksum.new(Checksum::SAFECKSUMTYPE_DEFAULT, temp, key, KeyUsage::KU_KRB_SAFE_CKSUM)
      krb_safe = KRBSafe.new(krb_safe_body, cksum)
      temp = krb_safe.asn1_encode
      return krb_safe.asn1_encode
    end
    
    typesig { [KRBSafe, EncryptionKey, SeqNumber, HostAddress, HostAddress, ::Java::Boolean, ::Java::Boolean, PrincipalName, Realm] }
    def rd_safe(krb_safe, key, seq_number, s_address, r_address, timestamp_required, seq_number_required, cname, crealm)
      temp = krb_safe.attr_safe_body.asn1_encode
      if (!krb_safe.attr_cksum.verify_keyed_checksum(temp, key, KeyUsage::KU_KRB_SAFE_CKSUM))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
      end
      check(krb_safe.attr_safe_body.attr_timestamp, krb_safe.attr_safe_body.attr_usec, krb_safe.attr_safe_body.attr_seq_number, krb_safe.attr_safe_body.attr_s_address, krb_safe.attr_safe_body.attr_r_address, seq_number, s_address, r_address, timestamp_required, seq_number_required, cname, crealm)
      return krb_safe.attr_safe_body.attr_user_data
    end
    
    private
    alias_method :initialize__krb_safe, :initialize
  end
  
end
