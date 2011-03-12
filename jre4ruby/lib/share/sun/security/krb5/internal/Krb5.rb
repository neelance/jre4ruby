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
module Sun::Security::Krb5::Internal
  module Krb5Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Util, :Hashtable
    }
  end
  
  # Constants and other defined values from RFC 4120
  class Krb5 
    include_class_members Krb5Imports
    
    class_module.module_eval {
      # Recommended KDC values
      const_set_lazy(:DEFAULT_ALLOWABLE_CLOCKSKEW) { 5 * 60 }
      const_attr_reader  :DEFAULT_ALLOWABLE_CLOCKSKEW
      
      # 5 minutes
      const_set_lazy(:DEFAULT_MINIMUM_LIFETIME) { 5 * 60 }
      const_attr_reader  :DEFAULT_MINIMUM_LIFETIME
      
      # 5 minutes
      const_set_lazy(:DEFAULT_MAXIMUM_RENEWABLE_LIFETIME) { 7 * 24 * 60 * 60 }
      const_attr_reader  :DEFAULT_MAXIMUM_RENEWABLE_LIFETIME
      
      # 1 week
      const_set_lazy(:DEFAULT_MAXIMUM_TICKET_LIFETIME) { 24 * 60 * 60 }
      const_attr_reader  :DEFAULT_MAXIMUM_TICKET_LIFETIME
      
      # 1 day
      const_set_lazy(:DEFAULT_FORWARDABLE_ALLOWED) { true }
      const_attr_reader  :DEFAULT_FORWARDABLE_ALLOWED
      
      const_set_lazy(:DEFAULT_PROXIABLE_ALLOWED) { true }
      const_attr_reader  :DEFAULT_PROXIABLE_ALLOWED
      
      const_set_lazy(:DEFAULT_POSTDATE_ALLOWED) { true }
      const_attr_reader  :DEFAULT_POSTDATE_ALLOWED
      
      const_set_lazy(:DEFAULT_RENEWABLE_ALLOWED) { true }
      const_attr_reader  :DEFAULT_RENEWABLE_ALLOWED
      
      const_set_lazy(:AP_EMPTY_ADDRESSES_ALLOWED) { true }
      const_attr_reader  :AP_EMPTY_ADDRESSES_ALLOWED
      
      # AP_REQ Options
      const_set_lazy(:AP_OPTS_RESERVED) { 0 }
      const_attr_reader  :AP_OPTS_RESERVED
      
      const_set_lazy(:AP_OPTS_USE_SESSION_KEY) { 1 }
      const_attr_reader  :AP_OPTS_USE_SESSION_KEY
      
      const_set_lazy(:AP_OPTS_MUTUAL_REQUIRED) { 2 }
      const_attr_reader  :AP_OPTS_MUTUAL_REQUIRED
      
      const_set_lazy(:AP_OPTS_MAX) { 31 }
      const_attr_reader  :AP_OPTS_MAX
      
      # Ticket Flags
      const_set_lazy(:TKT_OPTS_RESERVED) { 0 }
      const_attr_reader  :TKT_OPTS_RESERVED
      
      const_set_lazy(:TKT_OPTS_FORWARDABLE) { 1 }
      const_attr_reader  :TKT_OPTS_FORWARDABLE
      
      const_set_lazy(:TKT_OPTS_FORWARDED) { 2 }
      const_attr_reader  :TKT_OPTS_FORWARDED
      
      const_set_lazy(:TKT_OPTS_PROXIABLE) { 3 }
      const_attr_reader  :TKT_OPTS_PROXIABLE
      
      const_set_lazy(:TKT_OPTS_PROXY) { 4 }
      const_attr_reader  :TKT_OPTS_PROXY
      
      const_set_lazy(:TKT_OPTS_MAY_POSTDATE) { 5 }
      const_attr_reader  :TKT_OPTS_MAY_POSTDATE
      
      const_set_lazy(:TKT_OPTS_POSTDATED) { 6 }
      const_attr_reader  :TKT_OPTS_POSTDATED
      
      const_set_lazy(:TKT_OPTS_INVALID) { 7 }
      const_attr_reader  :TKT_OPTS_INVALID
      
      const_set_lazy(:TKT_OPTS_RENEWABLE) { 8 }
      const_attr_reader  :TKT_OPTS_RENEWABLE
      
      const_set_lazy(:TKT_OPTS_INITIAL) { 9 }
      const_attr_reader  :TKT_OPTS_INITIAL
      
      const_set_lazy(:TKT_OPTS_PRE_AUTHENT) { 10 }
      const_attr_reader  :TKT_OPTS_PRE_AUTHENT
      
      const_set_lazy(:TKT_OPTS_HW_AUTHENT) { 11 }
      const_attr_reader  :TKT_OPTS_HW_AUTHENT
      
      const_set_lazy(:TKT_OPTS_DELEGATE) { 13 }
      const_attr_reader  :TKT_OPTS_DELEGATE
      
      const_set_lazy(:TKT_OPTS_MAX) { 31 }
      const_attr_reader  :TKT_OPTS_MAX
      
      # KDC Options
      # (option values defined in KDCOptions.java)
      const_set_lazy(:KDC_OPTS_MAX) { 31 }
      const_attr_reader  :KDC_OPTS_MAX
      
      # KerberosFlags
      const_set_lazy(:KRB_FLAGS_MAX) { 31 }
      const_attr_reader  :KRB_FLAGS_MAX
      
      # Last Request types
      const_set_lazy(:LRTYPE_NONE) { 0 }
      const_attr_reader  :LRTYPE_NONE
      
      const_set_lazy(:LRTYPE_TIME_OF_INITIAL_TGT) { 1 }
      const_attr_reader  :LRTYPE_TIME_OF_INITIAL_TGT
      
      const_set_lazy(:LRTYPE_TIME_OF_INITIAL_REQ) { 2 }
      const_attr_reader  :LRTYPE_TIME_OF_INITIAL_REQ
      
      const_set_lazy(:LRTYPE_TIME_OF_NEWEST_TGT) { 3 }
      const_attr_reader  :LRTYPE_TIME_OF_NEWEST_TGT
      
      const_set_lazy(:LRTYPE_TIME_OF_LAST_RENEWAL) { 4 }
      const_attr_reader  :LRTYPE_TIME_OF_LAST_RENEWAL
      
      const_set_lazy(:LRTYPE_TIME_OF_LAST_REQ) { 5 }
      const_attr_reader  :LRTYPE_TIME_OF_LAST_REQ
      
      # Host address lengths
      const_set_lazy(:ADDR_LEN_INET) { 4 }
      const_attr_reader  :ADDR_LEN_INET
      
      const_set_lazy(:ADDR_LEN_CHAOS) { 2 }
      const_attr_reader  :ADDR_LEN_CHAOS
      
      const_set_lazy(:ADDR_LEN_OSI) { 0 }
      const_attr_reader  :ADDR_LEN_OSI
      
      # means variable
      const_set_lazy(:ADDR_LEN_XNS) { 6 }
      const_attr_reader  :ADDR_LEN_XNS
      
      const_set_lazy(:ADDR_LEN_APPLETALK) { 3 }
      const_attr_reader  :ADDR_LEN_APPLETALK
      
      const_set_lazy(:ADDR_LEN_DECNET) { 2 }
      const_attr_reader  :ADDR_LEN_DECNET
      
      # Host address types
      const_set_lazy(:ADDRTYPE_UNIX) { 1 }
      const_attr_reader  :ADDRTYPE_UNIX
      
      # Local
      const_set_lazy(:ADDRTYPE_INET) { 2 }
      const_attr_reader  :ADDRTYPE_INET
      
      # Internet
      const_set_lazy(:ADDRTYPE_IMPLINK) { 3 }
      const_attr_reader  :ADDRTYPE_IMPLINK
      
      # Arpanet
      const_set_lazy(:ADDRTYPE_PUP) { 4 }
      const_attr_reader  :ADDRTYPE_PUP
      
      # PUP
      const_set_lazy(:ADDRTYPE_CHAOS) { 5 }
      const_attr_reader  :ADDRTYPE_CHAOS
      
      # CHAOS
      const_set_lazy(:ADDRTYPE_XNS) { 6 }
      const_attr_reader  :ADDRTYPE_XNS
      
      # XEROX Network Services
      const_set_lazy(:ADDRTYPE_IPX) { 6 }
      const_attr_reader  :ADDRTYPE_IPX
      
      # IPX
      const_set_lazy(:ADDRTYPE_ISO) { 7 }
      const_attr_reader  :ADDRTYPE_ISO
      
      # ISO
      const_set_lazy(:ADDRTYPE_ECMA) { 8 }
      const_attr_reader  :ADDRTYPE_ECMA
      
      # European Computer Manufacturers
      const_set_lazy(:ADDRTYPE_DATAKIT) { 9 }
      const_attr_reader  :ADDRTYPE_DATAKIT
      
      # Datakit
      const_set_lazy(:ADDRTYPE_CCITT) { 10 }
      const_attr_reader  :ADDRTYPE_CCITT
      
      # CCITT
      const_set_lazy(:ADDRTYPE_SNA) { 11 }
      const_attr_reader  :ADDRTYPE_SNA
      
      # SNA
      const_set_lazy(:ADDRTYPE_DECNET) { 12 }
      const_attr_reader  :ADDRTYPE_DECNET
      
      # DECnet
      const_set_lazy(:ADDRTYPE_DLI) { 13 }
      const_attr_reader  :ADDRTYPE_DLI
      
      # Direct Data Link Interface
      const_set_lazy(:ADDRTYPE_LAT) { 14 }
      const_attr_reader  :ADDRTYPE_LAT
      
      # LAT
      const_set_lazy(:ADDRTYPE_HYLINK) { 15 }
      const_attr_reader  :ADDRTYPE_HYLINK
      
      # NSC Hyperchannel
      const_set_lazy(:ADDRTYPE_APPLETALK) { 16 }
      const_attr_reader  :ADDRTYPE_APPLETALK
      
      # AppleTalk
      const_set_lazy(:ADDRTYPE_NETBIOS) { 17 }
      const_attr_reader  :ADDRTYPE_NETBIOS
      
      # NetBios
      const_set_lazy(:ADDRTYPE_VOICEVIEW) { 18 }
      const_attr_reader  :ADDRTYPE_VOICEVIEW
      
      # VoiceView
      const_set_lazy(:ADDRTYPE_FIREFOX) { 19 }
      const_attr_reader  :ADDRTYPE_FIREFOX
      
      # Firefox
      const_set_lazy(:ADDRTYPE_BAN) { 21 }
      const_attr_reader  :ADDRTYPE_BAN
      
      # Banyan
      const_set_lazy(:ADDRTYPE_ATM) { 22 }
      const_attr_reader  :ADDRTYPE_ATM
      
      # ATM
      const_set_lazy(:ADDRTYPE_INET6) { 24 }
      const_attr_reader  :ADDRTYPE_INET6
      
      # Internet Protocol V6
      # IP Transport UDP Port for KDC Messages
      const_set_lazy(:KDC_INET_DEFAULT_PORT) { 88 }
      const_attr_reader  :KDC_INET_DEFAULT_PORT
      
      # number of retries before giving up
      const_set_lazy(:KDC_RETRY_LIMIT) { 3 }
      const_attr_reader  :KDC_RETRY_LIMIT
      
      # OSI authentication mechanism OID
      # public static final int[] OSI_AUTH_MECH_TYPE = { /*iso*/ 1, /*org*/ 3,
      #                                               /*dod*/ 5, /*internet*/ 1, /*security*/ 5, /*kerberosv5*/ 2 };
      # Protocol constants and associated values
      # Key Types
      const_set_lazy(:KEYTYPE_NULL) { 0 }
      const_attr_reader  :KEYTYPE_NULL
      
      const_set_lazy(:KEYTYPE_DES) { 1 }
      const_attr_reader  :KEYTYPE_DES
      
      const_set_lazy(:KEYTYPE_DES3) { 2 }
      const_attr_reader  :KEYTYPE_DES3
      
      const_set_lazy(:KEYTYPE_AES) { 3 }
      const_attr_reader  :KEYTYPE_AES
      
      const_set_lazy(:KEYTYPE_ARCFOUR_HMAC) { 4 }
      const_attr_reader  :KEYTYPE_ARCFOUR_HMAC
      
      # ----------------------------------------+-----------------
      #                      padata type       |padata-type value
      # ----------------------------------------+-----------------
      const_set_lazy(:PA_TGS_REQ) { 1 }
      const_attr_reader  :PA_TGS_REQ
      
      const_set_lazy(:PA_ENC_TIMESTAMP) { 2 }
      const_attr_reader  :PA_ENC_TIMESTAMP
      
      const_set_lazy(:PA_PW_SALT) { 3 }
      const_attr_reader  :PA_PW_SALT
      
      # new preauth types
      const_set_lazy(:PA_ETYPE_INFO) { 11 }
      const_attr_reader  :PA_ETYPE_INFO
      
      const_set_lazy(:PA_ETYPE_INFO2) { 19 }
      const_attr_reader  :PA_ETYPE_INFO2
      
      # -------------------------------+-------------
      # authorization data type        |ad-type value
      # -------------------------------+-------------
      # reserved values                 0-63
      const_set_lazy(:OSF_DCE) { 64 }
      const_attr_reader  :OSF_DCE
      
      const_set_lazy(:SESAME) { 65 }
      const_attr_reader  :SESAME
      
      # ----------------------------------------------+-----------------
      # alternate authentication type                 |method-type value
      # ----------------------------------------------+-----------------
      #                      reserved values          0-63
      const_set_lazy(:ATT_CHALLENGE_RESPONSE) { 64 }
      const_attr_reader  :ATT_CHALLENGE_RESPONSE
      
      # --------------------------------------------+-------------
      # transited encoding type                     |tr-type value
      # --------------------------------------------+-------------
      const_set_lazy(:DOMAIN_X500_COMPRESS) { 1 }
      const_attr_reader  :DOMAIN_X500_COMPRESS
      
      #                      reserved values        all others
      # ----------------------------+-------+-----------------------------------------
      #                      Label |Value  |Meaning
      # ----------------------------+-------+-----------------------------------------
      const_set_lazy(:PVNO) { 5 }
      const_attr_reader  :PVNO
      
      # current Kerberos protocol version number
      const_set_lazy(:AUTHNETICATOR_VNO) { 5 }
      const_attr_reader  :AUTHNETICATOR_VNO
      
      # current authenticator version number
      const_set_lazy(:TICKET_VNO) { 5 }
      const_attr_reader  :TICKET_VNO
      
      # current ticket version number
      # message types
      # there are several message sub-components not included here
      const_set_lazy(:KRB_AS_REQ) { 10 }
      const_attr_reader  :KRB_AS_REQ
      
      # Request for initial authentication
      const_set_lazy(:KRB_AS_REP) { 11 }
      const_attr_reader  :KRB_AS_REP
      
      # Response to KRB_AS_REQ request
      const_set_lazy(:KRB_TGS_REQ) { 12 }
      const_attr_reader  :KRB_TGS_REQ
      
      # Request for authentication based on TGT
      const_set_lazy(:KRB_TGS_REP) { 13 }
      const_attr_reader  :KRB_TGS_REP
      
      # Response to KRB_TGS_REQ request
      const_set_lazy(:KRB_AP_REQ) { 14 }
      const_attr_reader  :KRB_AP_REQ
      
      # application request to server
      const_set_lazy(:KRB_AP_REP) { 15 }
      const_attr_reader  :KRB_AP_REP
      
      # Response to KRB_AP_REQ_MUTUAL
      const_set_lazy(:KRB_SAFE) { 20 }
      const_attr_reader  :KRB_SAFE
      
      # Safe (checksummed) application message
      const_set_lazy(:KRB_PRIV) { 21 }
      const_attr_reader  :KRB_PRIV
      
      # Private (encrypted) application message
      const_set_lazy(:KRB_CRED) { 22 }
      const_attr_reader  :KRB_CRED
      
      # Private (encrypted) message to forward credentials
      const_set_lazy(:KRB_ERROR) { 30 }
      const_attr_reader  :KRB_ERROR
      
      # Error response
      # message component types
      const_set_lazy(:KRB_TKT) { 1 }
      const_attr_reader  :KRB_TKT
      
      # Ticket
      const_set_lazy(:KRB_AUTHENTICATOR) { 2 }
      const_attr_reader  :KRB_AUTHENTICATOR
      
      # Authenticator
      const_set_lazy(:KRB_ENC_TKT_PART) { 3 }
      const_attr_reader  :KRB_ENC_TKT_PART
      
      # Encrypted ticket part
      const_set_lazy(:KRB_ENC_AS_REP_PART) { 25 }
      const_attr_reader  :KRB_ENC_AS_REP_PART
      
      # Encrypted initial authentication part
      const_set_lazy(:KRB_ENC_TGS_REP_PART) { 26 }
      const_attr_reader  :KRB_ENC_TGS_REP_PART
      
      # Encrypted TGS request part
      const_set_lazy(:KRB_ENC_AP_REP_PART) { 27 }
      const_attr_reader  :KRB_ENC_AP_REP_PART
      
      # Encrypted application request part
      const_set_lazy(:KRB_ENC_KRB_PRIV_PART) { 28 }
      const_attr_reader  :KRB_ENC_KRB_PRIV_PART
      
      # Encrypted application message part
      const_set_lazy(:KRB_ENC_KRB_CRED_PART) { 29 }
      const_attr_reader  :KRB_ENC_KRB_CRED_PART
      
      # Encrypted credentials forward part
      # error codes
      const_set_lazy(:KDC_ERR_NONE) { 0 }
      const_attr_reader  :KDC_ERR_NONE
      
      # No error
      const_set_lazy(:KDC_ERR_NAME_EXP) { 1 }
      const_attr_reader  :KDC_ERR_NAME_EXP
      
      # Client's entry in database expired
      const_set_lazy(:KDC_ERR_SERVICE_EXP) { 2 }
      const_attr_reader  :KDC_ERR_SERVICE_EXP
      
      # Server's entry in database has expired
      const_set_lazy(:KDC_ERR_BAD_PVNO) { 3 }
      const_attr_reader  :KDC_ERR_BAD_PVNO
      
      # Requested protocol version number not supported
      const_set_lazy(:KDC_ERR_C_OLD_MAST_KVNO) { 4 }
      const_attr_reader  :KDC_ERR_C_OLD_MAST_KVNO
      
      # Client's key encrypted in old master key
      const_set_lazy(:KDC_ERR_S_OLD_MAST_KVNO) { 5 }
      const_attr_reader  :KDC_ERR_S_OLD_MAST_KVNO
      
      # Server's key encrypted in old master key
      const_set_lazy(:KDC_ERR_C_PRINCIPAL_UNKNOWN) { 6 }
      const_attr_reader  :KDC_ERR_C_PRINCIPAL_UNKNOWN
      
      # Client not found in Kerberos database
      const_set_lazy(:KDC_ERR_S_PRINCIPAL_UNKNOWN) { 7 }
      const_attr_reader  :KDC_ERR_S_PRINCIPAL_UNKNOWN
      
      # Server not found in Kerberos database
      const_set_lazy(:KDC_ERR_PRINCIPAL_NOT_UNIQUE) { 8 }
      const_attr_reader  :KDC_ERR_PRINCIPAL_NOT_UNIQUE
      
      # Multiple principal entries in database
      const_set_lazy(:KDC_ERR_NULL_KEY) { 9 }
      const_attr_reader  :KDC_ERR_NULL_KEY
      
      # The client or server has a null key
      const_set_lazy(:KDC_ERR_CANNOT_POSTDATE) { 10 }
      const_attr_reader  :KDC_ERR_CANNOT_POSTDATE
      
      # Ticket not eligible for postdating
      const_set_lazy(:KDC_ERR_NEVER_VALID) { 11 }
      const_attr_reader  :KDC_ERR_NEVER_VALID
      
      # Requested start time is later than end time
      const_set_lazy(:KDC_ERR_POLICY) { 12 }
      const_attr_reader  :KDC_ERR_POLICY
      
      # KDC policy rejects request
      const_set_lazy(:KDC_ERR_BADOPTION) { 13 }
      const_attr_reader  :KDC_ERR_BADOPTION
      
      # KDC cannot accommodate requested option
      const_set_lazy(:KDC_ERR_ETYPE_NOSUPP) { 14 }
      const_attr_reader  :KDC_ERR_ETYPE_NOSUPP
      
      # KDC has no support for encryption type
      const_set_lazy(:KDC_ERR_SUMTYPE_NOSUPP) { 15 }
      const_attr_reader  :KDC_ERR_SUMTYPE_NOSUPP
      
      # KDC has no support for checksum type
      const_set_lazy(:KDC_ERR_PADATA_TYPE_NOSUPP) { 16 }
      const_attr_reader  :KDC_ERR_PADATA_TYPE_NOSUPP
      
      # KDC has no support for padata type
      const_set_lazy(:KDC_ERR_TRTYPE_NOSUPP) { 17 }
      const_attr_reader  :KDC_ERR_TRTYPE_NOSUPP
      
      # KDC has no support for transited type
      const_set_lazy(:KDC_ERR_CLIENT_REVOKED) { 18 }
      const_attr_reader  :KDC_ERR_CLIENT_REVOKED
      
      # Clients credentials have been revoked
      const_set_lazy(:KDC_ERR_SERVICE_REVOKED) { 19 }
      const_attr_reader  :KDC_ERR_SERVICE_REVOKED
      
      # Credentials for server have been revoked
      const_set_lazy(:KDC_ERR_TGT_REVOKED) { 20 }
      const_attr_reader  :KDC_ERR_TGT_REVOKED
      
      # TGT has been revoked
      const_set_lazy(:KDC_ERR_CLIENT_NOTYET) { 21 }
      const_attr_reader  :KDC_ERR_CLIENT_NOTYET
      
      # Client not yet valid - try again later
      const_set_lazy(:KDC_ERR_SERVICE_NOTYET) { 22 }
      const_attr_reader  :KDC_ERR_SERVICE_NOTYET
      
      # Server not yet valid - try again later
      const_set_lazy(:KDC_ERR_KEY_EXPIRED) { 23 }
      const_attr_reader  :KDC_ERR_KEY_EXPIRED
      
      # Password has expired - change password to reset
      const_set_lazy(:KDC_ERR_PREAUTH_FAILED) { 24 }
      const_attr_reader  :KDC_ERR_PREAUTH_FAILED
      
      # Pre-authentication information was invalid
      const_set_lazy(:KDC_ERR_PREAUTH_REQUIRED) { 25 }
      const_attr_reader  :KDC_ERR_PREAUTH_REQUIRED
      
      # Additional pre-authentication required
      const_set_lazy(:KRB_AP_ERR_BAD_INTEGRITY) { 31 }
      const_attr_reader  :KRB_AP_ERR_BAD_INTEGRITY
      
      # Integrity check on decrypted field failed
      const_set_lazy(:KRB_AP_ERR_TKT_EXPIRED) { 32 }
      const_attr_reader  :KRB_AP_ERR_TKT_EXPIRED
      
      # Ticket expired
      const_set_lazy(:KRB_AP_ERR_TKT_NYV) { 33 }
      const_attr_reader  :KRB_AP_ERR_TKT_NYV
      
      # Ticket not yet valid
      const_set_lazy(:KRB_AP_ERR_REPEAT) { 34 }
      const_attr_reader  :KRB_AP_ERR_REPEAT
      
      # Request is a replay
      const_set_lazy(:KRB_AP_ERR_NOT_US) { 35 }
      const_attr_reader  :KRB_AP_ERR_NOT_US
      
      # The ticket isn't for us
      const_set_lazy(:KRB_AP_ERR_BADMATCH) { 36 }
      const_attr_reader  :KRB_AP_ERR_BADMATCH
      
      # Ticket and authenticator don't match
      const_set_lazy(:KRB_AP_ERR_SKEW) { 37 }
      const_attr_reader  :KRB_AP_ERR_SKEW
      
      # Clock skew too great
      const_set_lazy(:KRB_AP_ERR_BADADDR) { 38 }
      const_attr_reader  :KRB_AP_ERR_BADADDR
      
      # Incorrect net address
      const_set_lazy(:KRB_AP_ERR_BADVERSION) { 39 }
      const_attr_reader  :KRB_AP_ERR_BADVERSION
      
      # Protocol version mismatch
      const_set_lazy(:KRB_AP_ERR_MSG_TYPE) { 40 }
      const_attr_reader  :KRB_AP_ERR_MSG_TYPE
      
      # Invalid msg type
      const_set_lazy(:KRB_AP_ERR_MODIFIED) { 41 }
      const_attr_reader  :KRB_AP_ERR_MODIFIED
      
      # Message stream modified
      const_set_lazy(:KRB_AP_ERR_BADORDER) { 42 }
      const_attr_reader  :KRB_AP_ERR_BADORDER
      
      # Message out of order
      const_set_lazy(:KRB_AP_ERR_BADKEYVER) { 44 }
      const_attr_reader  :KRB_AP_ERR_BADKEYVER
      
      # Specified version of key is not available
      const_set_lazy(:KRB_AP_ERR_NOKEY) { 45 }
      const_attr_reader  :KRB_AP_ERR_NOKEY
      
      # Service key not available
      const_set_lazy(:KRB_AP_ERR_MUT_FAIL) { 46 }
      const_attr_reader  :KRB_AP_ERR_MUT_FAIL
      
      # Mutual authentication failed
      const_set_lazy(:KRB_AP_ERR_BADDIRECTION) { 47 }
      const_attr_reader  :KRB_AP_ERR_BADDIRECTION
      
      # Incorrect message direction
      const_set_lazy(:KRB_AP_ERR_METHOD) { 48 }
      const_attr_reader  :KRB_AP_ERR_METHOD
      
      # Alternative authentication method required
      const_set_lazy(:KRB_AP_ERR_BADSEQ) { 49 }
      const_attr_reader  :KRB_AP_ERR_BADSEQ
      
      # Incorrect sequence number in message
      const_set_lazy(:KRB_AP_ERR_INAPP_CKSUM) { 50 }
      const_attr_reader  :KRB_AP_ERR_INAPP_CKSUM
      
      # Inappropriate type of checksum in message
      const_set_lazy(:KRB_ERR_RESPONSE_TOO_BIG) { 52 }
      const_attr_reader  :KRB_ERR_RESPONSE_TOO_BIG
      
      # Response too big for UDP, retry with TCP
      const_set_lazy(:KRB_ERR_GENERIC) { 60 }
      const_attr_reader  :KRB_ERR_GENERIC
      
      # Generic error (description in e-text)
      const_set_lazy(:KRB_ERR_FIELD_TOOLONG) { 61 }
      const_attr_reader  :KRB_ERR_FIELD_TOOLONG
      
      # Field is too long for this implementation
      const_set_lazy(:KRB_CRYPTO_NOT_SUPPORT) { 100 }
      const_attr_reader  :KRB_CRYPTO_NOT_SUPPORT
      
      # Client does not support this crypto type
      const_set_lazy(:KRB_AP_ERR_NOREALM) { 62 }
      const_attr_reader  :KRB_AP_ERR_NOREALM
      
      const_set_lazy(:KRB_AP_ERR_GEN_CRED) { 63 }
      const_attr_reader  :KRB_AP_ERR_GEN_CRED
      
      #  public static final int KRB_AP_ERR_CKSUM_NOKEY          =101;    //Lack of the key to generate the checksum
      # error codes specific to this implementation
      const_set_lazy(:KRB_AP_ERR_REQ_OPTIONS) { 101 }
      const_attr_reader  :KRB_AP_ERR_REQ_OPTIONS
      
      # Invalid TGS_REQ
      const_set_lazy(:API_INVALID_ARG) { 400 }
      const_attr_reader  :API_INVALID_ARG
      
      # Invalid argument
      const_set_lazy(:BITSTRING_SIZE_INVALID) { 500 }
      const_attr_reader  :BITSTRING_SIZE_INVALID
      
      # BitString size does not match input byte array
      const_set_lazy(:BITSTRING_INDEX_OUT_OF_BOUNDS) { 501 }
      const_attr_reader  :BITSTRING_INDEX_OUT_OF_BOUNDS
      
      # BitString bit index does not fall within size
      const_set_lazy(:BITSTRING_BAD_LENGTH) { 502 }
      const_attr_reader  :BITSTRING_BAD_LENGTH
      
      # BitString length is wrong for the expected type
      const_set_lazy(:REALM_ILLCHAR) { 600 }
      const_attr_reader  :REALM_ILLCHAR
      
      # Illegal character in realm name; one of: '/', ':', '\0'
      const_set_lazy(:REALM_NULL) { 601 }
      const_attr_reader  :REALM_NULL
      
      # Null realm name
      const_set_lazy(:ASN1_BAD_TIMEFORMAT) { 900 }
      const_attr_reader  :ASN1_BAD_TIMEFORMAT
      
      # Input not in GeneralizedTime format
      const_set_lazy(:ASN1_MISSING_FIELD) { 901 }
      const_attr_reader  :ASN1_MISSING_FIELD
      
      # Structure is missing a required field
      const_set_lazy(:ASN1_MISPLACED_FIELD) { 902 }
      const_attr_reader  :ASN1_MISPLACED_FIELD
      
      # Unexpected field number
      const_set_lazy(:ASN1_TYPE_MISMATCH) { 903 }
      const_attr_reader  :ASN1_TYPE_MISMATCH
      
      # Type numbers are inconsistent
      const_set_lazy(:ASN1_OVERFLOW) { 904 }
      const_attr_reader  :ASN1_OVERFLOW
      
      # Value too large
      const_set_lazy(:ASN1_OVERRUN) { 905 }
      const_attr_reader  :ASN1_OVERRUN
      
      # Encoding ended unexpectedly
      const_set_lazy(:ASN1_BAD_ID) { 906 }
      const_attr_reader  :ASN1_BAD_ID
      
      # Identifier doesn't match expected value
      const_set_lazy(:ASN1_BAD_LENGTH) { 907 }
      const_attr_reader  :ASN1_BAD_LENGTH
      
      # Length doesn't match expected value
      const_set_lazy(:ASN1_BAD_FORMAT) { 908 }
      const_attr_reader  :ASN1_BAD_FORMAT
      
      # Badly-formatted encoding
      const_set_lazy(:ASN1_PARSE_ERROR) { 909 }
      const_attr_reader  :ASN1_PARSE_ERROR
      
      # Parse error
      const_set_lazy(:ASN1_BAD_CLASS) { 910 }
      const_attr_reader  :ASN1_BAD_CLASS
      
      # Bad class number
      const_set_lazy(:ASN1_BAD_TYPE) { 911 }
      const_attr_reader  :ASN1_BAD_TYPE
      
      # Bad type number
      const_set_lazy(:ASN1_BAD_TAG) { 912 }
      const_attr_reader  :ASN1_BAD_TAG
      
      # Bad tag number
      const_set_lazy(:ASN1_UNSUPPORTED_TYPE) { 913 }
      const_attr_reader  :ASN1_UNSUPPORTED_TYPE
      
      # Unsupported ASN.1 type encountered
      const_set_lazy(:ASN1_CANNOT_ENCODE) { 914 }
      const_attr_reader  :ASN1_CANNOT_ENCODE
      
      # Encoding failed due to invalid parameter(s)
      
      def err_msg_list
        defined?(@@err_msg_list) ? @@err_msg_list : @@err_msg_list= nil
      end
      alias_method :attr_err_msg_list, :err_msg_list
      
      def err_msg_list=(value)
        @@err_msg_list = value
      end
      alias_method :attr_err_msg_list=, :err_msg_list=
      
      typesig { [::Java::Int] }
      def get_error_message(i)
        return self.attr_err_msg_list.get(i)
      end
      
      const_set_lazy(:DEBUG) { Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.security.krb5.debug")) }
      const_attr_reader  :DEBUG
      
      const_set_lazy(:HexDumper) { Sun::Misc::HexDumpEncoder.new }
      const_attr_reader  :HexDumper
      
      when_class_loaded do
        self.attr_err_msg_list = Hashtable.new
        self.attr_err_msg_list.put(KDC_ERR_NONE, "No error")
        self.attr_err_msg_list.put(KDC_ERR_NAME_EXP, "Client's entry in database expired")
        self.attr_err_msg_list.put(KDC_ERR_SERVICE_EXP, "Server's entry in database has expired")
        self.attr_err_msg_list.put(KDC_ERR_BAD_PVNO, "Requested protocol version number not supported")
        self.attr_err_msg_list.put(KDC_ERR_C_OLD_MAST_KVNO, "Client's key encrypted in old master key")
        self.attr_err_msg_list.put(KDC_ERR_S_OLD_MAST_KVNO, "Server's key encrypted in old master key")
        self.attr_err_msg_list.put(KDC_ERR_C_PRINCIPAL_UNKNOWN, "Client not found in Kerberos database")
        self.attr_err_msg_list.put(KDC_ERR_S_PRINCIPAL_UNKNOWN, "Server not found in Kerberos database")
        self.attr_err_msg_list.put(KDC_ERR_PRINCIPAL_NOT_UNIQUE, "Multiple principal entries in database")
        self.attr_err_msg_list.put(KDC_ERR_NULL_KEY, "The client or server has a null key")
        self.attr_err_msg_list.put(KDC_ERR_CANNOT_POSTDATE, "Ticket not eligible for postdating")
        self.attr_err_msg_list.put(KDC_ERR_NEVER_VALID, "Requested start time is later than end time")
        self.attr_err_msg_list.put(KDC_ERR_POLICY, "KDC policy rejects request")
        self.attr_err_msg_list.put(KDC_ERR_BADOPTION, "KDC cannot accommodate requested option")
        self.attr_err_msg_list.put(KDC_ERR_ETYPE_NOSUPP, "KDC has no support for encryption type")
        self.attr_err_msg_list.put(KDC_ERR_SUMTYPE_NOSUPP, "KDC has no support for checksum type")
        self.attr_err_msg_list.put(KDC_ERR_PADATA_TYPE_NOSUPP, "KDC has no support for padata type")
        self.attr_err_msg_list.put(KDC_ERR_TRTYPE_NOSUPP, "KDC has no support for transited type")
        self.attr_err_msg_list.put(KDC_ERR_CLIENT_REVOKED, "Clients credentials have been revoked")
        self.attr_err_msg_list.put(KDC_ERR_SERVICE_REVOKED, "Credentials for server have been revoked")
        self.attr_err_msg_list.put(KDC_ERR_TGT_REVOKED, "TGT has been revoked")
        self.attr_err_msg_list.put(KDC_ERR_CLIENT_NOTYET, "Client not yet valid - try again later")
        self.attr_err_msg_list.put(KDC_ERR_SERVICE_NOTYET, "Server not yet valid - try again later")
        self.attr_err_msg_list.put(KDC_ERR_KEY_EXPIRED, "Password has expired - change password to reset")
        self.attr_err_msg_list.put(KDC_ERR_PREAUTH_FAILED, "Pre-authentication information was invalid")
        self.attr_err_msg_list.put(KDC_ERR_PREAUTH_REQUIRED, "Additional pre-authentication required")
        self.attr_err_msg_list.put(KRB_AP_ERR_BAD_INTEGRITY, "Integrity check on decrypted field failed")
        self.attr_err_msg_list.put(KRB_AP_ERR_TKT_EXPIRED, "Ticket expired")
        self.attr_err_msg_list.put(KRB_AP_ERR_TKT_NYV, "Ticket not yet valid")
        self.attr_err_msg_list.put(KRB_AP_ERR_REPEAT, "Request is a replay")
        self.attr_err_msg_list.put(KRB_AP_ERR_NOT_US, "The ticket isn't for us")
        self.attr_err_msg_list.put(KRB_AP_ERR_BADMATCH, "Ticket and authenticator don't match")
        self.attr_err_msg_list.put(KRB_AP_ERR_SKEW, "Clock skew too great")
        self.attr_err_msg_list.put(KRB_AP_ERR_BADADDR, "Incorrect net address")
        self.attr_err_msg_list.put(KRB_AP_ERR_BADVERSION, "Protocol version mismatch")
        self.attr_err_msg_list.put(KRB_AP_ERR_MSG_TYPE, "Invalid msg type")
        self.attr_err_msg_list.put(KRB_AP_ERR_MODIFIED, "Message stream modified")
        self.attr_err_msg_list.put(KRB_AP_ERR_BADORDER, "Message out of order")
        self.attr_err_msg_list.put(KRB_AP_ERR_BADKEYVER, "Specified version of key is not available")
        self.attr_err_msg_list.put(KRB_AP_ERR_NOKEY, "Service key not available")
        self.attr_err_msg_list.put(KRB_AP_ERR_MUT_FAIL, "Mutual authentication failed")
        self.attr_err_msg_list.put(KRB_AP_ERR_BADDIRECTION, "Incorrect message direction")
        self.attr_err_msg_list.put(KRB_AP_ERR_METHOD, "Alternative authentication method required")
        self.attr_err_msg_list.put(KRB_AP_ERR_BADSEQ, "Incorrect sequence number in message")
        self.attr_err_msg_list.put(KRB_AP_ERR_INAPP_CKSUM, "Inappropriate type of checksum in message")
        self.attr_err_msg_list.put(KRB_ERR_RESPONSE_TOO_BIG, "Response too big for UDP, retry with TCP")
        self.attr_err_msg_list.put(KRB_ERR_GENERIC, "Generic error (description in e-text)")
        self.attr_err_msg_list.put(KRB_ERR_FIELD_TOOLONG, "Field is too long for this implementation")
        self.attr_err_msg_list.put(KRB_AP_ERR_NOREALM, "Realm name not available") # used in setDefaultCreds() in sun.security.krb5.Credentials
        # error messages specific to this implementation
        self.attr_err_msg_list.put(API_INVALID_ARG, "Invalid argument")
        self.attr_err_msg_list.put(BITSTRING_SIZE_INVALID, "BitString size does not match input byte array")
        self.attr_err_msg_list.put(BITSTRING_INDEX_OUT_OF_BOUNDS, "BitString bit index does not fall within size")
        self.attr_err_msg_list.put(BITSTRING_BAD_LENGTH, "BitString length is wrong for the expected type")
        self.attr_err_msg_list.put(REALM_ILLCHAR, "Illegal character in realm name; one of: '/', ':', '\0'")
        self.attr_err_msg_list.put(REALM_NULL, "Null realm name")
        self.attr_err_msg_list.put(ASN1_BAD_TIMEFORMAT, "Input not in GeneralizedTime format")
        self.attr_err_msg_list.put(ASN1_MISSING_FIELD, "Structure is missing a required field")
        self.attr_err_msg_list.put(ASN1_MISPLACED_FIELD, "Unexpected field number")
        self.attr_err_msg_list.put(ASN1_TYPE_MISMATCH, "Type numbers are inconsistent")
        self.attr_err_msg_list.put(ASN1_OVERFLOW, "Value too large")
        self.attr_err_msg_list.put(ASN1_OVERRUN, "Encoding ended unexpectedly")
        self.attr_err_msg_list.put(ASN1_BAD_ID, "Identifier doesn't match expected value")
        self.attr_err_msg_list.put(ASN1_BAD_LENGTH, "Length doesn't match expected value")
        self.attr_err_msg_list.put(ASN1_BAD_FORMAT, "Badly-formatted encoding")
        self.attr_err_msg_list.put(ASN1_PARSE_ERROR, "Parse error")
        self.attr_err_msg_list.put(ASN1_BAD_CLASS, "Bad class number")
        self.attr_err_msg_list.put(ASN1_BAD_TYPE, "Bad type number")
        self.attr_err_msg_list.put(ASN1_BAD_TAG, "Bad tag number")
        self.attr_err_msg_list.put(ASN1_UNSUPPORTED_TYPE, "Unsupported ASN.1 type encountered")
        self.attr_err_msg_list.put(ASN1_CANNOT_ENCODE, "Encoding failed due to invalid parameter(s)")
        self.attr_err_msg_list.put(KRB_CRYPTO_NOT_SUPPORT, "Client has no support for crypto type")
        self.attr_err_msg_list.put(KRB_AP_ERR_REQ_OPTIONS, "Invalid option setting in ticket request.")
        self.attr_err_msg_list.put(KRB_AP_ERR_GEN_CRED, "Fail to create credential.")
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__krb5, :initialize
  end
  
end
