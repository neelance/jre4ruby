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
  module KrbTgsReqImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Io, :InterruptedIOException
    }
  end
  
  # This class encapsulates a Kerberos TGS-REQ that is sent from the
  # client to the KDC.
  class KrbTgsReq < KrbTgsReqImports.const_get :KrbKdcReq
    include_class_members KrbTgsReqImports
    
    attr_accessor :princ_name
    alias_method :attr_princ_name, :princ_name
    undef_method :princ_name
    alias_method :attr_princ_name=, :princ_name=
    undef_method :princ_name=
    
    attr_accessor :serv_name
    alias_method :attr_serv_name, :serv_name
    undef_method :serv_name
    alias_method :attr_serv_name=, :serv_name=
    undef_method :serv_name=
    
    attr_accessor :tgs_req_messg
    alias_method :attr_tgs_req_messg, :tgs_req_messg
    undef_method :tgs_req_messg
    alias_method :attr_tgs_req_messg=, :tgs_req_messg=
    undef_method :tgs_req_messg=
    
    attr_accessor :ctime
    alias_method :attr_ctime, :ctime
    undef_method :ctime
    alias_method :attr_ctime=, :ctime=
    undef_method :ctime=
    
    attr_accessor :second_ticket
    alias_method :attr_second_ticket, :second_ticket
    undef_method :second_ticket
    alias_method :attr_second_ticket=, :second_ticket=
    undef_method :second_ticket=
    
    attr_accessor :use_subkey
    alias_method :attr_use_subkey, :use_subkey
    undef_method :use_subkey
    alias_method :attr_use_subkey=, :use_subkey=
    undef_method :use_subkey=
    
    attr_accessor :tgs_req_key
    alias_method :attr_tgs_req_key, :tgs_req_key
    undef_method :tgs_req_key
    alias_method :attr_tgs_req_key=, :tgs_req_key=
    undef_method :tgs_req_key=
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Krb5::DEBUG }
      const_attr_reader  :DEBUG
    }
    
    attr_accessor :default_timeout
    alias_method :attr_default_timeout, :default_timeout
    undef_method :default_timeout
    alias_method :attr_default_timeout=, :default_timeout=
    undef_method :default_timeout=
    
    typesig { [Credentials, PrincipalName] }
    # 30 seconds
    # Used in CredentialsUtil
    def initialize(as_creds, sname)
      # KerberosTime from
      # KerberosTime till
      # KerberosTime rtime
      # eTypes, // null, // int[] eTypes
      # HostAddresses addresses
      # AuthorizationData authorizationData
      # Ticket[] additionalTickets
      initialize__krb_tgs_req(KDCOptions.new, as_creds, sname, nil, nil, nil, nil, nil, nil, nil, nil) # EncryptionKey subSessionKey
    end
    
    typesig { [KDCOptions, Credentials, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, AuthorizationData, Array.typed(Ticket), EncryptionKey] }
    # Called by Credentials, KrbCred
    def initialize(options, as_creds, sname, from, till, rtime, e_types, addresses, authorization_data, additional_tickets, sub_key)
      @princ_name = nil
      @serv_name = nil
      @tgs_req_messg = nil
      @ctime = nil
      @second_ticket = nil
      @use_subkey = false
      @tgs_req_key = nil
      @default_timeout = 0
      super()
      @second_ticket = nil
      @use_subkey = false
      @default_timeout = 30 * 1000
      @princ_name = as_creds.attr_client
      @serv_name = sname
      @ctime = KerberosTime.new(KerberosTime::NOW)
      # check if they are valid arguments. The optional fields
      # should be  consistent with settings in KDCOptions.
      if (options.get(KDCOptions::FORWARDABLE) && (!(as_creds.attr_flags.get(Krb5::TKT_OPTS_FORWARDABLE))))
        raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
      end
      if (options.get(KDCOptions::FORWARDED))
        if (!(as_creds.attr_flags.get(KDCOptions::FORWARDABLE)))
          raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
        end
      end
      if (options.get(KDCOptions::PROXIABLE) && (!(as_creds.attr_flags.get(Krb5::TKT_OPTS_PROXIABLE))))
        raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
      end
      if (options.get(KDCOptions::PROXY))
        if (!(as_creds.attr_flags.get(KDCOptions::PROXIABLE)))
          raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
        end
      end
      if (options.get(KDCOptions::ALLOW_POSTDATE) && (!(as_creds.attr_flags.get(Krb5::TKT_OPTS_MAY_POSTDATE))))
        raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
      end
      if (options.get(KDCOptions::RENEWABLE) && (!(as_creds.attr_flags.get(Krb5::TKT_OPTS_RENEWABLE))))
        raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
      end
      if (options.get(KDCOptions::POSTDATED))
        if (!(as_creds.attr_flags.get(KDCOptions::POSTDATED)))
          raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
        end
      else
        if (!(from).nil?)
          from = nil
        end
      end
      if (options.get(KDCOptions::RENEWABLE))
        if (!(as_creds.attr_flags.get(KDCOptions::RENEWABLE)))
          raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
        end
      else
        if (!(rtime).nil?)
          rtime = nil
        end
      end
      if (options.get(KDCOptions::ENC_TKT_IN_SKEY))
        if ((additional_tickets).nil?)
          raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
        end
        # in TGS_REQ there could be more than one additional
        # tickets,  but in file-based credential cache,
        # there is only one additional ticket field.
        @second_ticket = additional_tickets[0]
      else
        if (!(additional_tickets).nil?)
          additional_tickets = nil
        end
      end
      @tgs_req_messg = create_request(options, as_creds.attr_ticket, as_creds.attr_key, @ctime, @princ_name, @princ_name.get_realm, @serv_name, from, till, rtime, e_types, addresses, authorization_data, additional_tickets, sub_key)
      self.attr_obuf = @tgs_req_messg.asn1_encode
      # XXX We need to revisit this to see if can't move it
      # up such that FORWARDED flag set in the options
      # is included in the marshaled request.
      # 
      # If this is based on a forwarded ticket, record that in the
      # options, because the returned TgsRep will contain the
      # FORWARDED flag set.
      if (as_creds.attr_flags.get(KDCOptions::FORWARDED))
        options.set(KDCOptions::FORWARDED, true)
      end
    end
    
    typesig { [] }
    # Sends a TGS request to the realm of the target.
    # @throws KrbException
    # @throws IOException
    def send
      realm_str = nil
      if (!(@serv_name).nil?)
        realm_str = (@serv_name.get_realm_string).to_s
      end
      return (send(realm_str))
    end
    
    typesig { [] }
    def get_reply
      return KrbTgsRep.new(self.attr_ibuf, self)
    end
    
    typesig { [] }
    # Sends the request, waits for a reply, and returns the Credentials.
    # Used in Credentials, KrbCred, and internal/CredentialsUtil.
    def send_and_get_creds
      tgs_rep = nil
      kdc = nil
      begin
        kdc = (send).to_s
        tgs_rep = get_reply
      rescue KrbException => ke
        if ((ke.return_code).equal?(Krb5::KRB_ERR_RESPONSE_TOO_BIG))
          # set useTCP and retry
          send(@serv_name.get_realm_string, kdc, true)
          tgs_rep = get_reply
        else
          raise ke
        end
      end
      return tgs_rep.get_creds
    end
    
    typesig { [] }
    def get_ctime
      return @ctime
    end
    
    typesig { [KDCOptions, Ticket, EncryptionKey, KerberosTime, PrincipalName, Realm, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, AuthorizationData, Array.typed(Ticket), EncryptionKey] }
    def create_request(kdc_options, ticket, key, ctime, cname, crealm, sname, from, till, rtime, e_types, addresses, authorization_data, additional_tickets, sub_key)
      req_till = nil
      if ((till).nil?)
        req_till = KerberosTime.new
      else
        req_till = till
      end
      # RFC 4120, Section 5.4.2.
      # For KRB_TGS_REP, the ciphertext is encrypted in the
      # sub-session key from the Authenticator, or if absent,
      # the session key from the ticket-granting ticket used
      # in the request.
      # 
      # To support this, use tgsReqKey to remember which key to use.
      @tgs_req_key = key
      req_e_types = nil
      if ((e_types).nil?)
        req_e_types = EType.get_defaults("default_tgs_enctypes")
        if ((req_e_types).nil?)
          raise KrbCryptoException.new("No supported encryption types listed in default_tgs_enctypes")
        end
      else
        req_e_types = e_types
      end
      req_key = nil
      enc_authorization_data = nil
      if (!(authorization_data).nil?)
        ad = authorization_data.asn1_encode
        if (!(sub_key).nil?)
          req_key = sub_key
          @tgs_req_key = sub_key # Key to use to decrypt reply
          @use_subkey = true
          enc_authorization_data = EncryptedData.new(req_key, ad, KeyUsage::KU_TGS_REQ_AUTH_DATA_SUBKEY)
        else
          enc_authorization_data = EncryptedData.new(key, ad, KeyUsage::KU_TGS_REQ_AUTH_DATA_SESSKEY)
        end
      end
      # crealm,
      # TO
      req_body = KDCReqBody.new(kdc_options, cname, sname.get_realm, sname, from, req_till, rtime, Nonce.value, req_e_types, addresses, enc_authorization_data, additional_tickets)
      temp = req_body.asn1_encode(Krb5::KRB_TGS_REQ)
      # if the checksum type is one of the keyed checksum types,
      # use session key.
      cksum = nil
      case (Checksum::CKSUMTYPE_DEFAULT)
      when Checksum::CKSUMTYPE_RSA_MD4_DES, Checksum::CKSUMTYPE_DES_MAC, Checksum::CKSUMTYPE_DES_MAC_K, Checksum::CKSUMTYPE_RSA_MD4_DES_K, Checksum::CKSUMTYPE_RSA_MD5_DES, Checksum::CKSUMTYPE_HMAC_SHA1_DES3_KD, Checksum::CKSUMTYPE_HMAC_MD5_ARCFOUR, Checksum::CKSUMTYPE_HMAC_SHA1_96_AES128, Checksum::CKSUMTYPE_HMAC_SHA1_96_AES256
        cksum = Checksum.new(Checksum::CKSUMTYPE_DEFAULT, temp, key, KeyUsage::KU_PA_TGS_REQ_CKSUM)
      when Checksum::CKSUMTYPE_CRC32, Checksum::CKSUMTYPE_RSA_MD4, Checksum::CKSUMTYPE_RSA_MD5
        cksum = Checksum.new(Checksum::CKSUMTYPE_DEFAULT, temp)
      else
        cksum = Checksum.new(Checksum::CKSUMTYPE_DEFAULT, temp)
      end
      # Usage will be KeyUsage.KU_PA_TGS_REQ_AUTHENTICATOR
      tgs_ap_req = KrbApReq.new(APOptions.new, ticket, key, crealm, cname, cksum, ctime, req_key, nil, nil).get_message
      tgs_padata = Array.typed(PAData).new(1) { nil }
      tgs_padata[0] = PAData.new(Krb5::PA_TGS_REQ, tgs_ap_req)
      return TGSReq.new(tgs_padata, req_body)
    end
    
    typesig { [] }
    def get_message
      return @tgs_req_messg
    end
    
    typesig { [] }
    def get_second_ticket
      return @second_ticket
    end
    
    class_module.module_eval {
      typesig { [String] }
      def debug(message)
        # System.err.println(">>> KrbTgsReq: " + message);
      end
    }
    
    typesig { [] }
    def used_subkey
      return @use_subkey
    end
    
    private
    alias_method :initialize__krb_tgs_req, :initialize
  end
  
end
