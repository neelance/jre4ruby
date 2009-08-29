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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5
  module KrbAsReqImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Crypto, :EType
      include_const ::Sun::Security::Krb5::Internal::Crypto, :Nonce
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  # This class encapsulates the KRB-AS-REQ message that the client
  # sends to the KDC.
  class KrbAsReq < KrbAsReqImports.const_get :KrbKdcReq
    include_class_members KrbAsReqImports
    
    attr_accessor :princ_name
    alias_method :attr_princ_name, :princ_name
    undef_method :princ_name
    alias_method :attr_princ_name=, :princ_name=
    undef_method :princ_name=
    
    attr_accessor :as_req_messg
    alias_method :attr_as_req_messg, :as_req_messg
    undef_method :as_req_messg
    alias_method :attr_as_req_messg=, :as_req_messg=
    undef_method :as_req_messg=
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    class_module.module_eval {
      
      def default_kdcoptions
        defined?(@@default_kdcoptions) ? @@default_kdcoptions : @@default_kdcoptions= KDCOptions.new
      end
      alias_method :attr_default_kdcoptions, :default_kdcoptions
      
      def default_kdcoptions=(value)
        @@default_kdcoptions = value
      end
      alias_method :attr_default_kdcoptions=, :default_kdcoptions=
    }
    
    # pre-auth info
    attr_accessor :pa_enc_timestamp_required
    alias_method :attr_pa_enc_timestamp_required, :pa_enc_timestamp_required
    undef_method :pa_enc_timestamp_required
    alias_method :attr_pa_enc_timestamp_required=, :pa_enc_timestamp_required=
    undef_method :pa_enc_timestamp_required=
    
    attr_accessor :pa_exists
    alias_method :attr_pa_exists, :pa_exists
    undef_method :pa_exists
    alias_method :attr_pa_exists=, :pa_exists=
    undef_method :pa_exists=
    
    attr_accessor :pa_etype
    alias_method :attr_pa_etype, :pa_etype
    undef_method :pa_etype
    alias_method :attr_pa_etype=, :pa_etype=
    undef_method :pa_etype=
    
    attr_accessor :pa_salt
    alias_method :attr_pa_salt, :pa_salt
    undef_method :pa_salt
    alias_method :attr_pa_salt=, :pa_salt=
    undef_method :pa_salt=
    
    attr_accessor :pa_s2kparams
    alias_method :attr_pa_s2kparams, :pa_s2kparams
    undef_method :pa_s2kparams
    alias_method :attr_pa_s2kparams=, :pa_s2kparams=
    undef_method :pa_s2kparams=
    
    # default is address-less tickets
    attr_accessor :kdc_empty_addresses_allowed
    alias_method :attr_kdc_empty_addresses_allowed, :kdc_empty_addresses_allowed
    undef_method :kdc_empty_addresses_allowed
    alias_method :attr_kdc_empty_addresses_allowed=, :kdc_empty_addresses_allowed=
    undef_method :kdc_empty_addresses_allowed=
    
    typesig { [PrincipalName, Array.typed(EncryptionKey)] }
    # Creates a KRB-AS-REQ to send to the default KDC
    # @throws KrbException
    # @throws IOException
    # 
    # Called by Credentials
    def initialize(principal, keys)
      # for pre-authentication
      # pre-auth values
      # PrincipalName sname
      # KerberosTime from
      # KerberosTime till
      # KerberosTime rtime
      # int[] eTypes
      # HostAddresses addresses
      initialize__krb_as_req(keys, false, 0, nil, nil, self.attr_default_kdcoptions, principal, nil, nil, nil, nil, nil, nil, nil) # Ticket[] additionalTickets
    end
    
    typesig { [PrincipalName, Array.typed(EncryptionKey), ::Java::Boolean, ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Creates a KRB-AS-REQ to send to the default KDC
    # with pre-authentication values
    def initialize(principal, keys, pa_exists, etype, salt, s2kparams)
      # for pre-authentication
      # pre-auth values
      # PrincipalName sname
      # KerberosTime from
      # KerberosTime till
      # KerberosTime rtime
      # int[] eTypes
      # HostAddresses addresses
      initialize__krb_as_req(keys, pa_exists, etype, salt, s2kparams, self.attr_default_kdcoptions, principal, nil, nil, nil, nil, nil, nil, nil) # Ticket[] additionalTickets
    end
    
    class_module.module_eval {
      typesig { [Array.typed(EncryptionKey)] }
      def get_etypes_from_keys(keys)
        types = Array.typed(::Java::Int).new(keys.attr_length) { 0 }
        i = 0
        while i < keys.attr_length
          types[i] = keys[i].get_etype
          i += 1
        end
        return types
      end
    }
    
    typesig { [::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), PrincipalName] }
    # update with pre-auth info
    def update_pa(etype, salt, params, name)
      # set the pre-auth values
      @pa_exists = true
      @pa_etype = etype
      @pa_salt = salt
      @pa_s2kparams = params
      # update salt in PrincipalName
      if (!(salt).nil? && salt.attr_length > 0)
        new_salt = String.new(salt)
        name.set_salt(new_salt)
        if (@debug)
          System.out.println("Updated salt from pre-auth = " + RJava.cast_to_string(name.get_salt))
        end
      end
      @pa_enc_timestamp_required = true
    end
    
    typesig { [Array.typed(::Java::Char), KDCOptions, PrincipalName, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, Array.typed(Ticket)] }
    # Used by Kinit
    def initialize(password, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets)
      # pre-auth values
      # PrincipalName sname
      # KerberosTime from
      # KerberosTime till
      # KerberosTime rtime
      # int[] eTypes
      # HostAddresses addresses
      initialize__krb_as_req(password, false, 0, nil, nil, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets) # Ticket[] additionalTickets
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Boolean, ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), KDCOptions, PrincipalName, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, Array.typed(Ticket)] }
    # Used by Kinit
    def initialize(password, pa_exists, etype, salt, s2kparams, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets)
      @princ_name = nil
      @as_req_messg = nil
      @debug = false
      @pa_enc_timestamp_required = false
      @pa_exists = false
      @pa_etype = 0
      @pa_salt = nil
      @pa_s2kparams = nil
      @kdc_empty_addresses_allowed = false
      super()
      @debug = Krb5::DEBUG
      @pa_enc_timestamp_required = false
      @pa_exists = false
      @pa_etype = 0
      @pa_salt = nil
      @pa_s2kparams = nil
      @kdc_empty_addresses_allowed = true
      keys = nil
      # update with preauth info
      if (pa_exists)
        update_pa(etype, salt, s2kparams, cname)
      end
      if (!(password).nil?)
        keys = EncryptionKey.acquire_secret_keys(password, cname.get_salt, pa_exists, @pa_etype, @pa_s2kparams)
      end
      if (@debug)
        System.out.println(">>>KrbAsReq salt is " + RJava.cast_to_string(cname.get_salt))
      end
      begin
        init(keys, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets)
      ensure
        # Its ok to destroy the key here because we created it and are
        # now done with it.
        if (!(keys).nil?)
          i = 0
          while i < keys.attr_length
            keys[i].destroy
            i += 1
          end
        end
      end
    end
    
    typesig { [Array.typed(EncryptionKey), KDCOptions, PrincipalName, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, Array.typed(Ticket)] }
    # Used in Kinit
    def initialize(keys, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets)
      # pre-auth values
      # PrincipalName sname
      # KerberosTime from
      # KerberosTime till
      # KerberosTime rtime
      # int[] eTypes
      # HostAddresses addresses
      initialize__krb_as_req(keys, false, 0, nil, nil, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets) # Ticket[] additionalTickets
    end
    
    typesig { [Array.typed(EncryptionKey), ::Java::Boolean, ::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte), KDCOptions, PrincipalName, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, Array.typed(Ticket)] }
    # Used by Kinit
    def initialize(keys, pa_exists, etype, salt, s2kparams, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets)
      @princ_name = nil
      @as_req_messg = nil
      @debug = false
      @pa_enc_timestamp_required = false
      @pa_exists = false
      @pa_etype = 0
      @pa_salt = nil
      @pa_s2kparams = nil
      @kdc_empty_addresses_allowed = false
      super()
      @debug = Krb5::DEBUG
      @pa_enc_timestamp_required = false
      @pa_exists = false
      @pa_etype = 0
      @pa_salt = nil
      @pa_s2kparams = nil
      @kdc_empty_addresses_allowed = true
      # update with preauth info
      if (pa_exists)
        # update pre-auth info
        update_pa(etype, salt, s2kparams, cname)
        if (@debug)
          System.out.println(">>>KrbAsReq salt is " + RJava.cast_to_string(cname.get_salt))
        end
      end
      init(keys, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets)
    end
    
    typesig { [Array.typed(EncryptionKey), KDCOptions, PrincipalName, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, Array.typed(Ticket)] }
    # private KrbAsReq(KDCOptions options,
    # PrincipalName cname,
    # PrincipalName sname,
    # KerberosTime from,
    # KerberosTime till,
    # KerberosTime rtime,
    # int[] eTypes,
    # HostAddresses addresses,
    # Ticket[] additionalTickets)
    # throws KrbException, IOException {
    # init(null,
    # options,
    # cname,
    # sname,
    # from,
    # till,
    # rtime,
    # eTypes,
    # addresses,
    # additionalTickets);
    # }
    def init(keys, options, cname, sname, from, till, rtime, e_types, addresses, additional_tickets)
      # check if they are valid arguments. The optional fields should be
      # consistent with settings in KDCOptions. Mar 17 2000
      if (options.get(KDCOptions::FORWARDED) || options.get(KDCOptions::PROXY) || options.get(KDCOptions::ENC_TKT_IN_SKEY) || options.get(KDCOptions::RENEW) || options.get(KDCOptions::VALIDATE))
        # this option is only specified in a request to the
        # ticket-granting server
        raise KrbException.new(Krb5::KRB_AP_ERR_REQ_OPTIONS)
      end
      if (options.get(KDCOptions::POSTDATED))
        # if (from == null)
        # throw new KrbException(Krb5.KRB_AP_ERR_REQ_OPTIONS);
      else
        if (!(from).nil?)
          from = nil
        end
      end
      if (options.get(KDCOptions::RENEWABLE))
        # if (rtime == null)
        # throw new KrbException(Krb5.KRB_AP_ERR_REQ_OPTIONS);
      else
        if (!(rtime).nil?)
          rtime = nil
        end
      end
      @princ_name = cname
      key = nil
      tkt_etypes = nil
      if (@pa_exists && !(@pa_etype).equal?(EncryptedData::ETYPE_NULL))
        if (@debug)
          System.out.println("Pre-Authenticaton: find key for etype = " + RJava.cast_to_string(@pa_etype))
        end
        key = EncryptionKey.find_key(@pa_etype, keys)
        tkt_etypes = Array.typed(::Java::Int).new(1) { 0 }
        tkt_etypes[0] = @pa_etype
      else
        tkt_etypes = EType.get_defaults("default_tkt_enctypes", keys)
        key = EncryptionKey.find_key(tkt_etypes[0], keys)
      end
      pa_data = nil
      if (@pa_enc_timestamp_required)
        if (@debug)
          System.out.println("AS-REQ: Add PA_ENC_TIMESTAMP now")
        end
        ts = PAEncTSEnc.new
        temp = ts.asn1_encode
        if (!(key).nil?)
          # Use first key in list
          enc_ts = EncryptedData.new(key, temp, KeyUsage::KU_PA_ENC_TS)
          pa_data = Array.typed(PAData).new(1) { nil }
          pa_data[0] = PAData.new(Krb5::PA_ENC_TIMESTAMP, enc_ts.asn1_encode)
        end
      end
      if (@debug)
        System.out.println(">>> KrbAsReq calling createMessage")
      end
      if ((e_types).nil?)
        e_types = tkt_etypes
      end
      # check to use addresses in tickets
      if (Config.get_instance.use_addresses)
        @kdc_empty_addresses_allowed = false
      end
      # get the local InetAddress if required
      if ((addresses).nil? && !@kdc_empty_addresses_allowed)
        addresses = HostAddresses.get_local_addresses
      end
      @as_req_messg = create_message(pa_data, options, cname, cname.get_realm, sname, from, till, rtime, e_types, addresses, additional_tickets)
      self.attr_obuf = @as_req_messg.asn1_encode
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Returns an AS-REP message corresponding to the AS-REQ that
    # was sent.
    # @param password The password that will be used to derive the
    # secret key that will decrypt the AS-REP from  the KDC.
    # @exception KrbException if an error occurs while reading the data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def get_reply(password)
      if ((password).nil?)
        raise KrbException.new(Krb5::API_INVALID_ARG)
      end
      temp = nil
      keys = nil
      begin
        keys = EncryptionKey.acquire_secret_keys(password, @princ_name.get_salt, @pa_exists, @pa_etype, @pa_s2kparams)
        temp = get_reply(keys)
      ensure
        # Its ok to destroy the key here because we created it and are
        # now done with it.
        if (!(keys).nil?)
          i = 0
          while i < keys.attr_length
            keys[i].destroy
            i += 1
          end
        end
      end
      return temp
    end
    
    typesig { [] }
    # Sends an AS request to the realm of the client.
    # returns the KDC hostname that the request was sent to
    def send
      realm_str = nil
      if (!(@princ_name).nil?)
        realm_str = RJava.cast_to_string(@princ_name.get_realm_string)
      end
      return (send(realm_str))
    end
    
    typesig { [Array.typed(EncryptionKey)] }
    # Returns an AS-REP message corresponding to the AS-REQ that
    # was sent.
    # @param keys The secret keys that will decrypt the AS-REP from
    # the KDC; key selected depends on etype used to encrypt data.
    # @exception KrbException if an error occurs while reading the data.
    # @exception IOException if an I/O error occurs while reading encoded
    # data.
    def get_reply(keys)
      return KrbAsRep.new(self.attr_ibuf, keys, self)
    end
    
    typesig { [Array.typed(PAData), KDCOptions, PrincipalName, Realm, PrincipalName, KerberosTime, KerberosTime, KerberosTime, Array.typed(::Java::Int), HostAddresses, Array.typed(Ticket)] }
    def create_message(pa_data, kdc_options, cname, crealm, sname, from, till, rtime, e_types, addresses, additional_tickets)
      if (@debug)
        System.out.println(">>> KrbAsReq in createMessage")
      end
      req_sname = nil
      if ((sname).nil?)
        if ((crealm).nil?)
          raise RealmException.new(Krb5::REALM_NULL, "default realm not specified ")
        end
        req_sname = PrincipalName.new("krbtgt" + RJava.cast_to_string(PrincipalName::NAME_COMPONENT_SEPARATOR) + RJava.cast_to_string(crealm.to_s), PrincipalName::KRB_NT_SRV_INST)
      else
        req_sname = sname
      end
      req_till = nil
      if ((till).nil?)
        req_till = KerberosTime.new
      else
        req_till = till
      end
      kdc_req_body = KDCReqBody.new(kdc_options, cname, crealm, req_sname, from, req_till, rtime, Nonce.value, e_types, addresses, nil, additional_tickets)
      return ASReq.new(pa_data, kdc_req_body)
    end
    
    typesig { [] }
    def get_message
      return @as_req_messg
    end
    
    private
    alias_method :initialize__krb_as_req, :initialize
  end
  
end
