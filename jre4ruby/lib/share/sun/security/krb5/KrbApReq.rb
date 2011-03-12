require "rjava"

# Portions Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KrbApReqImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Crypto
      include ::Sun::Security::Krb5::Internal::Rcache
      include_const ::Java::Net, :InetAddress
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class encapsulates a KRB-AP-REQ that a client sends to a
  # server for authentication.
  class KrbApReq 
    include_class_members KrbApReqImports
    
    attr_accessor :obuf
    alias_method :attr_obuf, :obuf
    undef_method :obuf
    alias_method :attr_obuf=, :obuf=
    undef_method :obuf=
    
    attr_accessor :ctime
    alias_method :attr_ctime, :ctime
    undef_method :ctime
    alias_method :attr_ctime=, :ctime=
    undef_method :ctime=
    
    attr_accessor :cusec
    alias_method :attr_cusec, :cusec
    undef_method :cusec
    alias_method :attr_cusec=, :cusec=
    undef_method :cusec=
    
    attr_accessor :authenticator
    alias_method :attr_authenticator, :authenticator
    undef_method :authenticator
    alias_method :attr_authenticator=, :authenticator=
    undef_method :authenticator=
    
    attr_accessor :creds
    alias_method :attr_creds, :creds
    undef_method :creds
    alias_method :attr_creds=, :creds=
    undef_method :creds=
    
    attr_accessor :ap_req_messg
    alias_method :attr_ap_req_messg, :ap_req_messg
    undef_method :ap_req_messg
    alias_method :attr_ap_req_messg=, :ap_req_messg=
    undef_method :ap_req_messg=
    
    class_module.module_eval {
      
      def table
        defined?(@@table) ? @@table : @@table= CacheTable.new
      end
      alias_method :attr_table, :table
      
      def table=(value)
        @@table = value
      end
      alias_method :attr_table=, :table=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    # default is address-less tickets
    attr_accessor :kdc_empty_addresses_allowed
    alias_method :attr_kdc_empty_addresses_allowed, :kdc_empty_addresses_allowed
    undef_method :kdc_empty_addresses_allowed
    alias_method :attr_kdc_empty_addresses_allowed=, :kdc_empty_addresses_allowed=
    undef_method :kdc_empty_addresses_allowed=
    
    typesig { [Credentials, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, Checksum] }
    # Contructs a AP-REQ message to send to the peer.
    # @param tgsCred the <code>Credentials</code> to be used to construct the
    #          AP Request  protocol message.
    # @param mutualRequired Whether mutual authentication is required
    # @param useSubkey Whether the subkey is to be used to protect this
    #        specific application session. If this is not set then the
    #        session key from the ticket will be used.
    # @throws KrbException for any Kerberos protocol specific error
    # @throws IOException for any IO related errors
    #          (e.g. socket operations)
    #  // Not Used
    # public KrbApReq(Credentials tgsCred,
    #                 boolean mutualRequired,
    #                 boolean useSubKey,
    #                 boolean useSeqNumber) throws Asn1Exception,
    #                 KrbCryptoException, KrbException, IOException {
    # 
    #     this(tgsCred, mutualRequired, useSubKey, useSeqNumber, null);
    # }
    # Contructs a AP-REQ message to send to the peer.
    # @param tgsCred the <code>Credentials</code> to be used to construct the
    #          AP Request  protocol message.
    # @param mutualRequired Whether mutual authentication is required
    # @param useSubkey Whether the subkey is to be used to protect this
    #        specific application session. If this is not set then the
    #        session key from the ticket will be used.
    # @param checksum checksum of the the application data that accompanies
    #        the KRB_AP_REQ.
    # @throws KrbException for any Kerberos protocol specific error
    # @throws IOException for any IO related errors
    #          (e.g. socket operations)
    # Used in InitSecContextToken
    def initialize(tgs_cred, mutual_required, use_sub_key, use_seq_number, cksum)
      @obuf = nil
      @ctime = nil
      @cusec = 0
      @authenticator = nil
      @creds = nil
      @ap_req_messg = nil
      @kdc_empty_addresses_allowed = true
      ap_options = (mutual_required ? APOptions.new(Krb5::AP_OPTS_MUTUAL_REQUIRED) : APOptions.new)
      if (self.attr_debug)
        System.out.println(">>> KrbApReq: APOptions are " + RJava.cast_to_string(ap_options))
      end
      sub_key = (use_sub_key ? EncryptionKey.new(tgs_cred.get_session_key) : nil)
      seq_num = LocalSeqNumber.new # AuthorizationData authzData
      init(ap_options, tgs_cred, cksum, sub_key, seq_num, nil, KeyUsage::KU_AP_REQ_AUTHENTICATOR)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(EncryptionKey), InetAddress] }
    # Contructs a AP-REQ message from the bytes received from the
    # peer.
    # @param message The message received from the peer
    # @param keys <code>EncrtyptionKey</code>s to decrypt the message;
    #       key selected will depend on etype used to encrypte data
    # @throws KrbException for any Kerberos protocol specific error
    # @throws IOException for any IO related errors
    #          (e.g. socket operations)
    # Used in InitSecContextToken (for AP_REQ and not TGS REQ)
    def initialize(message, keys, initiator)
      @obuf = nil
      @ctime = nil
      @cusec = 0
      @authenticator = nil
      @creds = nil
      @ap_req_messg = nil
      @kdc_empty_addresses_allowed = true
      @obuf = message
      if ((@ap_req_messg).nil?)
        decode
      end
      authenticate(keys, initiator)
    end
    
    typesig { [APOptions, Ticket, EncryptionKey, Realm, PrincipalName, Checksum, KerberosTime, EncryptionKey, SeqNumber, AuthorizationData] }
    # Contructs a AP-REQ message from the bytes received from the
    # peer.
    # @param value The <code>DerValue</code> that contains the
    #              DER enoded AP-REQ protocol message
    # @param keys <code>EncrtyptionKey</code>s to decrypt the message;
    # 
    # @throws KrbException for any Kerberos protocol specific error
    # @throws IOException for any IO related errors
    #          (e.g. socket operations)
    # public KrbApReq(DerValue value, EncryptionKey[] key, InetAddress initiator)
    #     throws KrbException, IOException {
    #     obuf = value.toByteArray();
    #     if (apReqMessg == null)
    #         decode(value);
    #     authenticate(keys, initiator);
    # }
    # 
    # KrbApReq(APOptions options,
    #          Credentials tgs_creds,
    #          Checksum cksum,
    #          EncryptionKey subKey,
    #          SeqNumber seqNumber,
    #          AuthorizationData authorizationData)
    #     throws KrbException, IOException {
    #     init(options, tgs_creds, cksum, subKey, seqNumber, authorizationData);
    # }
    # used by KrbTgsReq *
    def initialize(ap_options, ticket, key, crealm, cname, cksum, ctime, sub_key, seq_number, authorization_data)
      @obuf = nil
      @ctime = nil
      @cusec = 0
      @authenticator = nil
      @creds = nil
      @ap_req_messg = nil
      @kdc_empty_addresses_allowed = true
      init(ap_options, ticket, key, crealm, cname, cksum, ctime, sub_key, seq_number, authorization_data, KeyUsage::KU_PA_TGS_REQ_AUTHENTICATOR)
    end
    
    typesig { [APOptions, Credentials, Checksum, EncryptionKey, SeqNumber, AuthorizationData, ::Java::Int] }
    def init(options, tgs_creds, cksum, sub_key, seq_number, authorization_data, usage)
      @ctime = KerberosTime.new(KerberosTime::NOW)
      init(options, tgs_creds.attr_ticket, tgs_creds.attr_key, tgs_creds.attr_client.get_realm, tgs_creds.attr_client, cksum, @ctime, sub_key, seq_number, authorization_data, usage)
    end
    
    typesig { [APOptions, Ticket, EncryptionKey, Realm, PrincipalName, Checksum, KerberosTime, EncryptionKey, SeqNumber, AuthorizationData, ::Java::Int] }
    def init(ap_options, ticket, key, crealm, cname, cksum, ctime, sub_key, seq_number, authorization_data, usage)
      create_message(ap_options, ticket, key, crealm, cname, cksum, ctime, sub_key, seq_number, authorization_data, usage)
      @obuf = @ap_req_messg.asn1_encode
    end
    
    typesig { [] }
    def decode
      encoding = DerValue.new(@obuf)
      decode(encoding)
    end
    
    typesig { [DerValue] }
    def decode(encoding)
      @ap_req_messg = nil
      begin
        @ap_req_messg = APReq.new(encoding)
      rescue Asn1Exception => e
        @ap_req_messg = nil
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
    end
    
    typesig { [Array.typed(EncryptionKey), InetAddress] }
    def authenticate(keys, initiator)
      enc_part_key_type = @ap_req_messg.attr_ticket.attr_enc_part.get_etype
      dkey = EncryptionKey.find_key(enc_part_key_type, keys)
      if ((dkey).nil?)
        raise KrbException.new(Krb5::API_INVALID_ARG, "Cannot find key of appropriate type to decrypt AP REP - " + RJava.cast_to_string(EType.to_s(enc_part_key_type)))
      end
      bytes = @ap_req_messg.attr_ticket.attr_enc_part.decrypt(dkey, KeyUsage::KU_TICKET)
      temp = @ap_req_messg.attr_ticket.attr_enc_part.reset(bytes, true)
      enc_ticket_part = EncTicketPart.new(temp)
      check_permitted_etype(enc_ticket_part.attr_key.get_etype)
      bytes2 = @ap_req_messg.attr_authenticator.decrypt(enc_ticket_part.attr_key, KeyUsage::KU_AP_REQ_AUTHENTICATOR)
      temp2 = @ap_req_messg.attr_authenticator.reset(bytes2, true)
      @authenticator = Authenticator.new(temp2)
      @ctime = @authenticator.attr_ctime
      @cusec = @authenticator.attr_cusec
      @authenticator.attr_ctime.set_micro_seconds(@authenticator.attr_cusec)
      @authenticator.attr_cname.set_realm(@authenticator.attr_crealm)
      @ap_req_messg.attr_ticket.attr_sname.set_realm(@ap_req_messg.attr_ticket.attr_realm)
      enc_ticket_part.attr_cname.set_realm(enc_ticket_part.attr_crealm)
      Config.get_instance.reset_default_realm(@ap_req_messg.attr_ticket.attr_realm.to_s)
      if (!(@authenticator.attr_cname == enc_ticket_part.attr_cname))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADMATCH)
      end
      curr_time = KerberosTime.new(KerberosTime::NOW)
      if (!@authenticator.attr_ctime.in_clock_skew(curr_time))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_SKEW)
      end
      # start to check if it is a replay attack.
      time = AuthTime.new(@authenticator.attr_ctime.get_time, @authenticator.attr_cusec)
      client = @authenticator.attr_cname.to_s
      if (!(self.attr_table.get(time, @authenticator.attr_cname.to_s)).nil?)
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_REPEAT)
      else
        self.attr_table.put(client, time, curr_time.get_time)
      end
      # check to use addresses in tickets
      if (Config.get_instance.use_addresses)
        @kdc_empty_addresses_allowed = false
      end
      # sender host address
      sender = nil
      if (!(initiator).nil?)
        sender = HostAddress.new(initiator)
      end
      if (!(sender).nil? || !@kdc_empty_addresses_allowed)
        if (!(enc_ticket_part.attr_caddr).nil?)
          if ((sender).nil?)
            raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADADDR)
          end
          if (!enc_ticket_part.attr_caddr.in_list(sender))
            raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADADDR)
          end
        end
      end
      # XXX check for repeated authenticator
      # if found
      #    throw new KrbApErrException(Krb5.KRB_AP_ERR_REPEAT);
      # else
      #    save authenticator to check for later
      now = KerberosTime.new(KerberosTime::NOW)
      if ((!(enc_ticket_part.attr_starttime).nil? && enc_ticket_part.attr_starttime.greater_than_wrtclock_skew(now)) || enc_ticket_part.attr_flags.get(Krb5::TKT_OPTS_INVALID))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_TKT_NYV)
      end
      # if the current time is later than end time by more
      # than the allowable clock skew, throws ticket expired exception.
      if (!(enc_ticket_part.attr_endtime).nil? && now.greater_than_wrtclock_skew(enc_ticket_part.attr_endtime))
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_TKT_EXPIRED)
      end
      @creds = Credentials.new(@ap_req_messg.attr_ticket, @authenticator.attr_cname, @ap_req_messg.attr_ticket.attr_sname, enc_ticket_part.attr_key, nil, enc_ticket_part.attr_authtime, enc_ticket_part.attr_starttime, enc_ticket_part.attr_endtime, enc_ticket_part.attr_renew_till, enc_ticket_part.attr_caddr)
      if (self.attr_debug)
        System.out.println(">>> KrbApReq: authenticate succeed.")
      end
    end
    
    typesig { [] }
    # Returns the credentials that are contained in the ticket that
    # is part of this this AP-REP.
    def get_creds
      return @creds
    end
    
    typesig { [] }
    def get_ctime
      if (!(@ctime).nil?)
        return @ctime
      end
      return @authenticator.attr_ctime
    end
    
    typesig { [] }
    def cusec
      return @cusec
    end
    
    typesig { [] }
    def get_apoptions
      if ((@ap_req_messg).nil?)
        decode
      end
      if (!(@ap_req_messg).nil?)
        return @ap_req_messg.attr_ap_options
      end
      return nil
    end
    
    typesig { [] }
    # Returns true if mutual authentication is required and hence an
    # AP-REP will need to be generated.
    # @throws KrbException
    # @throws IOException
    def get_mutual_auth_required
      if ((@ap_req_messg).nil?)
        decode
      end
      if (!(@ap_req_messg).nil?)
        return @ap_req_messg.attr_ap_options.get(Krb5::AP_OPTS_MUTUAL_REQUIRED)
      end
      return false
    end
    
    typesig { [] }
    def use_session_key
      if ((@ap_req_messg).nil?)
        decode
      end
      if (!(@ap_req_messg).nil?)
        return @ap_req_messg.attr_ap_options.get(Krb5::AP_OPTS_USE_SESSION_KEY)
      end
      return false
    end
    
    typesig { [] }
    # Returns the optional subkey stored in the Authenticator for
    # this message. Returns null if none is stored.
    def get_sub_key
      # XXX Can authenticator be null
      return @authenticator.get_sub_key
    end
    
    typesig { [] }
    # Returns the optional sequence number stored in the
    # Authenticator for this message. Returns null if none is
    # stored.
    def get_seq_number
      # XXX Can authenticator be null
      return @authenticator.get_seq_number
    end
    
    typesig { [] }
    # Returns the optional Checksum stored in the
    # Authenticator for this message. Returns null if none is
    # stored.
    def get_checksum
      return @authenticator.get_checksum
    end
    
    typesig { [] }
    # Returns the ASN.1 encoding that should be sent to the peer.
    def get_message
      return @obuf
    end
    
    typesig { [] }
    # Returns the principal name of the client that generated this
    # message.
    def get_client
      return @creds.get_client
    end
    
    typesig { [APOptions, Ticket, EncryptionKey, Realm, PrincipalName, Checksum, KerberosTime, EncryptionKey, SeqNumber, AuthorizationData, ::Java::Int] }
    def create_message(ap_options, ticket, key, crealm, cname, cksum, ctime, sub_key, seq_number, authorization_data, usage)
      seqno = nil
      if (!(seq_number).nil?)
        seqno = seq_number.current
      end
      @authenticator = Authenticator.new(crealm, cname, cksum, ctime.get_micro_seconds, ctime, sub_key, seqno, authorization_data)
      temp = @authenticator.asn1_encode
      enc_authenticator = EncryptedData.new(key, temp, usage)
      @ap_req_messg = APReq.new(ap_options, ticket, enc_authenticator)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Check that key is one of the permitted types
      def check_permitted_etype(target)
        etypes = EType.get_defaults("permitted_enctypes")
        if ((etypes).nil?)
          raise KrbException.new("No supported encryption types listed in permitted_enctypes")
        end
        if (!EType.is_supported(target, etypes))
          raise KrbException.new(RJava.cast_to_string(EType.to_s(target)) + " encryption type not in permitted_enctypes list")
        end
      end
    }
    
    private
    alias_method :initialize__krb_ap_req, :initialize
  end
  
end
