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
  module KrbCredImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Util, :DerValue
    }
  end
  
  # This class encapsulates the KRB-CRED message that a client uses to
  # send its delegated credentials to a server.
  # 
  # Supports delegation of one ticket only.
  # @author Mayank Upadhyay
  class KrbCred 
    include_class_members KrbCredImports
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    attr_accessor :obuf
    alias_method :attr_obuf, :obuf
    undef_method :obuf
    alias_method :attr_obuf=, :obuf=
    undef_method :obuf=
    
    attr_accessor :cred_messg
    alias_method :attr_cred_messg, :cred_messg
    undef_method :cred_messg
    alias_method :attr_cred_messg=, :cred_messg=
    undef_method :cred_messg=
    
    attr_accessor :ticket
    alias_method :attr_ticket, :ticket
    undef_method :ticket
    alias_method :attr_ticket=, :ticket=
    undef_method :ticket=
    
    attr_accessor :enc_part
    alias_method :attr_enc_part, :enc_part
    undef_method :enc_part
    alias_method :attr_enc_part=, :enc_part=
    undef_method :enc_part=
    
    attr_accessor :creds
    alias_method :attr_creds, :creds
    undef_method :creds
    alias_method :attr_creds=, :creds=
    undef_method :creds=
    
    attr_accessor :time_stamp
    alias_method :attr_time_stamp, :time_stamp
    undef_method :time_stamp
    alias_method :attr_time_stamp=, :time_stamp=
    undef_method :time_stamp=
    
    typesig { [Credentials, Credentials, EncryptionKey] }
    # Used in InitialToken with null key
    def initialize(tgt, service_ticket, key)
      @obuf = nil
      @cred_messg = nil
      @ticket = nil
      @enc_part = nil
      @creds = nil
      @time_stamp = nil
      client = tgt.get_client
      tg_service = tgt.get_server
      server = service_ticket.get_server
      if (!(service_ticket.get_client == client))
        raise KrbException.new(Krb5::KRB_ERR_GENERIC, "Client principal does not match")
      end
      # XXX Check Windows flag OK-TO-FORWARD-TO
      # Invoke TGS-REQ to get a forwarded TGT for the peer
      options = KDCOptions.new
      options.set(KDCOptions::FORWARDED, true)
      options.set(KDCOptions::FORWARDABLE, true)
      s_addrs = nil
      # XXX Also NT_GSS_KRB5_PRINCIPAL can be a host based principal
      # GSSName.NT_HOSTBASED_SERVICE should display with KRB_NT_SRV_HST
      if ((server.get_name_type).equal?(PrincipalName::KRB_NT_SRV_HST))
        s_addrs = HostAddresses.new(server)
      end
      tgs_req = KrbTgsReq.new(options, tgt, tg_service, nil, nil, nil, nil, s_addrs, nil, nil, nil)
      @cred_messg = create_message(tgs_req.send_and_get_creds, key)
      @obuf = @cred_messg.asn1_encode
    end
    
    typesig { [Credentials, EncryptionKey] }
    def create_message(delegated_creds, key)
      session_key = delegated_creds.get_session_key
      princ = delegated_creds.get_client
      realm = princ.get_realm
      tg_service = delegated_creds.get_server
      tgs_realm = tg_service.get_realm
      cred_info = KrbCredInfo.new(session_key, realm, princ, delegated_creds.attr_flags, delegated_creds.attr_auth_time, delegated_creds.attr_start_time, delegated_creds.attr_end_time, delegated_creds.attr_renew_till, tgs_realm, tg_service, delegated_creds.attr_c_addr)
      @time_stamp = KerberosTime.new(KerberosTime::NOW)
      cred_infos = Array.typed(KrbCredInfo).new([cred_info])
      enc_part = EncKrbCredPart.new(cred_infos, @time_stamp, nil, nil, nil, nil)
      enc_enc_part = EncryptedData.new(key, enc_part.asn1_encode, KeyUsage::KU_ENC_KRB_CRED_PART)
      tickets = Array.typed(Ticket).new([delegated_creds.attr_ticket])
      @cred_messg = KRBCred.new(tickets, enc_enc_part)
      return @cred_messg
    end
    
    typesig { [Array.typed(::Java::Byte), EncryptionKey] }
    # Used in InitialToken, key always NULL_KEY
    def initialize(asn1message, key)
      @obuf = nil
      @cred_messg = nil
      @ticket = nil
      @enc_part = nil
      @creds = nil
      @time_stamp = nil
      @cred_messg = KRBCred.new(asn1message)
      @ticket = @cred_messg.attr_tickets[0]
      temp = @cred_messg.attr_enc_part.decrypt(key, KeyUsage::KU_ENC_KRB_CRED_PART)
      plain_text = @cred_messg.attr_enc_part.reset(temp, true)
      encoding = DerValue.new(plain_text)
      enc_part = EncKrbCredPart.new(encoding)
      @time_stamp = enc_part.attr_time_stamp
      cred_info = enc_part.attr_ticket_info[0]
      cred_info_key = cred_info.attr_key
      prealm = cred_info.attr_prealm
      # XXX PrincipalName can store realm + principalname or
      # just principal name.
      pname = cred_info.attr_pname
      pname.set_realm(prealm)
      flags = cred_info.attr_flags
      authtime = cred_info.attr_authtime
      starttime = cred_info.attr_starttime
      endtime = cred_info.attr_endtime
      renew_till = cred_info.attr_renew_till
      srealm = cred_info.attr_srealm
      sname = cred_info.attr_sname
      sname.set_realm(srealm)
      caddr = cred_info.attr_caddr
      if (self.attr_debug)
        System.out.println(">>>Delegated Creds have pname=" + RJava.cast_to_string(pname) + " sname=" + RJava.cast_to_string(sname) + " authtime=" + RJava.cast_to_string(authtime) + " starttime=" + RJava.cast_to_string(starttime) + " endtime=" + RJava.cast_to_string(endtime) + "renewTill=" + RJava.cast_to_string(renew_till))
      end
      @creds = Credentials.new(@ticket, pname, sname, cred_info_key, flags, authtime, starttime, endtime, renew_till, caddr)
    end
    
    typesig { [] }
    # Returns the delegated credentials from the peer.
    def get_delegated_creds
      all_creds = Array.typed(Credentials).new([@creds])
      return all_creds
    end
    
    typesig { [] }
    # Returns the ASN.1 encoding that should be sent to the peer.
    def get_message
      return @obuf
    end
    
    private
    alias_method :initialize__krb_cred, :initialize
  end
  
end
