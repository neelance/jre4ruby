require "rjava"

# Portions Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
# 
# Copyright  (c) 2002 Graz University of Technology. All rights reserved.
# 
# Redistribution and use in  source and binary forms, with or without
# modification, are permitted  provided that the following conditions are met:
# 
# 1. Redistributions of  source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in  binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 3. The end-user documentation included with the redistribution, if any, must
# include the following acknowledgment:
# 
# "This product includes software developed by IAIK of Graz University of
# Technology."
# 
# Alternately, this acknowledgment may appear in the software itself, if
# and wherever such third-party acknowledgments normally appear.
# 
# 4. The names "Graz University of Technology" and "IAIK of Graz University of
# Technology" must not be used to endorse or promote products derived from
# this software without prior written permission.
# 
# 5. Products derived from this software may not be called
# "IAIK PKCS Wrapper", nor may "IAIK" appear in their name, without prior
# written permission of Graz University of Technology.
# 
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE LICENSOR BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY  OF SUCH DAMAGE.
module Sun::Security::Pkcs11::Wrapper
  module PKCS11ConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # This interface holds constants of the PKCS#11 v2.11 standard.
  # This is mainly the content of the 'pkcs11t.h' header file.
  # 
  # Mapping of primitiv data types to Java types:
  # <pre>
  # TRUE .......................................... true
  # FALSE ......................................... false
  # CK_BYTE ....................................... byte
  # CK_CHAR ....................................... char
  # CK_UTF8CHAR ................................... char
  # CK_BBOOL ...................................... boolean
  # CK_ULONG ...................................... long
  # CK_LONG ....................................... long
  # CK_FLAGS ...................................... long
  # CK_NOTIFICATION ............................... long
  # CK_SLOT_ID .................................... long
  # CK_SESSION_HANDLE ............................. long
  # CK_USER_TYPE .................................. long
  # CK_SESSION_HANDLE ............................. long
  # CK_STATE ...................................... long
  # CK_OBJECT_HANDLE .............................. long
  # CK_OBJECT_CLASS ............................... long
  # CK_HW_FEATURE_TYPE ............................ long
  # CK_KEY_TYPE ................................... long
  # CK_CERTIFICATE_TYPE ........................... long
  # CK_ATTRIBUTE_TYPE ............................. long
  # CK_VOID_PTR ................................... Object[]
  # CK_BYTE_PTR ................................... byte[]
  # CK_CHAR_PTR ................................... char[]
  # CK_UTF8CHAR_PTR ............................... char[]
  # CK_MECHANISM_TYPE ............................. long
  # CK_RV ......................................... long
  # CK_RSA_PKCS_OAEP_MGF_TYPE ..................... long
  # CK_RSA_PKCS_OAEP_SOURCE_TYPE .................. long
  # CK_RC2_PARAMS ................................. long
  # CK_MAC_GENERAL_PARAMS ......................... long
  # CK_EXTRACT_PARAMS ............................. long
  # CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE .... long
  # CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE .............. long
  # CK_EC_KDF_TYPE ................................ long
  # CK_X9_42_DH_KDF_TYPE .......................... long
  # </pre>
  # 
  # @author <a href="mailto:Karl.Scheibelhofer@iaik.at"> Karl Scheibelhofer </a>
  # @invariants
  module PKCS11Constants
    include_class_members PKCS11ConstantsImports
    
    class_module.module_eval {
      const_set_lazy(:TRUE) { true }
      const_attr_reader  :TRUE
      
      const_set_lazy(:FALSE) { false }
      const_attr_reader  :FALSE
      
      const_set_lazy(:NULL_PTR) { nil }
      const_attr_reader  :NULL_PTR
      
      # some special values for certain CK_ULONG variables
      # Cryptoki defines CK_UNAVAILABLE_INFORMATION as (~0UL)
      # This means it is 0xffffffff in ILP32/LLP64 but 0xffffffffffffffff in LP64.
      # To avoid these differences on the Java side, the native code treats
      # CK_UNAVAILABLE_INFORMATION specially and always returns (long)-1 for it.
      # See ckULongSpecialToJLong() in pkcs11wrapper.h
      const_set_lazy(:CK_UNAVAILABLE_INFORMATION) { -1 }
      const_attr_reader  :CK_UNAVAILABLE_INFORMATION
      
      const_set_lazy(:CK_EFFECTIVELY_INFINITE) { 0 }
      const_attr_reader  :CK_EFFECTIVELY_INFINITE
      
      # The following value is always invalid if used as a session
      # handle or object handle
      const_set_lazy(:CK_INVALID_HANDLE) { 0 }
      const_attr_reader  :CK_INVALID_HANDLE
      
      # CK_NOTIFICATION enumerates the types of notifications that
      # Cryptoki provides to an application
      # CK_NOTIFICATION has been changed from an enum to a CK_ULONG
      # for v2.0
      const_set_lazy(:CKN_SURRENDER) { 0 }
      const_attr_reader  :CKN_SURRENDER
      
      # flags: bit flags that provide capabilities of the slot
      # Bit Flag              Mask        Meaning
      const_set_lazy(:CKF_TOKEN_PRESENT) { 0x1 }
      const_attr_reader  :CKF_TOKEN_PRESENT
      
      const_set_lazy(:CKF_REMOVABLE_DEVICE) { 0x2 }
      const_attr_reader  :CKF_REMOVABLE_DEVICE
      
      const_set_lazy(:CKF_HW_SLOT) { 0x4 }
      const_attr_reader  :CKF_HW_SLOT
      
      # The flags parameter is defined as follows:
      # Bit Flag                    Mask        Meaning
      # 
      # has random # generator
      const_set_lazy(:CKF_RNG) { 0x1 }
      const_attr_reader  :CKF_RNG
      
      # token is write-protected
      const_set_lazy(:CKF_WRITE_PROTECTED) { 0x2 }
      const_attr_reader  :CKF_WRITE_PROTECTED
      
      # user must login
      const_set_lazy(:CKF_LOGIN_REQUIRED) { 0x4 }
      const_attr_reader  :CKF_LOGIN_REQUIRED
      
      # normal user's PIN is set
      const_set_lazy(:CKF_USER_PIN_INITIALIZED) { 0x8 }
      const_attr_reader  :CKF_USER_PIN_INITIALIZED
      
      # CKF_RESTORE_KEY_NOT_NEEDED is new for v2.0.  If it is set,
      # that means that *every* time the state of cryptographic
      # operations of a session is successfully saved, all keys
      # needed to continue those operations are stored in the state
      const_set_lazy(:CKF_RESTORE_KEY_NOT_NEEDED) { 0x20 }
      const_attr_reader  :CKF_RESTORE_KEY_NOT_NEEDED
      
      # CKF_CLOCK_ON_TOKEN is new for v2.0.  If it is set, that means
      # that the token has some sort of clock.  The time on that
      # clock is returned in the token info structure
      const_set_lazy(:CKF_CLOCK_ON_TOKEN) { 0x40 }
      const_attr_reader  :CKF_CLOCK_ON_TOKEN
      
      # CKF_PROTECTED_AUTHENTICATION_PATH is new for v2.0.  If it is
      # set, that means that there is some way for the user to login
      # without sending a PIN through the Cryptoki library itself
      const_set_lazy(:CKF_PROTECTED_AUTHENTICATION_PATH) { 0x100 }
      const_attr_reader  :CKF_PROTECTED_AUTHENTICATION_PATH
      
      # CKF_DUAL_CRYPTO_OPERATIONS is new for v2.0.  If it is true,
      # that means that a single session with the token can perform
      # dual simultaneous cryptographic operations (digest and
      # encrypt; decrypt and digest; sign and encrypt; and decrypt
      # and sign)
      const_set_lazy(:CKF_DUAL_CRYPTO_OPERATIONS) { 0x200 }
      const_attr_reader  :CKF_DUAL_CRYPTO_OPERATIONS
      
      # CKF_TOKEN_INITIALIZED if new for v2.10. If it is true, the
      # token has been initialized using C_InitializeToken or an
      # equivalent mechanism outside the scope of PKCS #11.
      # Calling C_InitializeToken when this flag is set will cause
      # the token to be reinitialized.
      const_set_lazy(:CKF_TOKEN_INITIALIZED) { 0x400 }
      const_attr_reader  :CKF_TOKEN_INITIALIZED
      
      # CKF_SECONDARY_AUTHENTICATION if new for v2.10. If it is
      # true, the token supports secondary authentication for
      # private key objects.
      const_set_lazy(:CKF_SECONDARY_AUTHENTICATION) { 0x800 }
      const_attr_reader  :CKF_SECONDARY_AUTHENTICATION
      
      # CKF_USER_PIN_COUNT_LOW if new for v2.10. If it is true, an
      # incorrect user login PIN has been entered at least once
      # since the last successful authentication.
      const_set_lazy(:CKF_USER_PIN_COUNT_LOW) { 0x10000 }
      const_attr_reader  :CKF_USER_PIN_COUNT_LOW
      
      # CKF_USER_PIN_FINAL_TRY if new for v2.10. If it is true,
      # supplying an incorrect user PIN will it to become locked.
      const_set_lazy(:CKF_USER_PIN_FINAL_TRY) { 0x20000 }
      const_attr_reader  :CKF_USER_PIN_FINAL_TRY
      
      # CKF_USER_PIN_LOCKED if new for v2.10. If it is true, the
      # user PIN has been locked. User login to the token is not
      # possible.
      const_set_lazy(:CKF_USER_PIN_LOCKED) { 0x40000 }
      const_attr_reader  :CKF_USER_PIN_LOCKED
      
      # CKF_USER_PIN_TO_BE_CHANGED if new for v2.10. If it is true,
      # the user PIN value is the default value set by token
      # initialization or manufacturing.
      const_set_lazy(:CKF_USER_PIN_TO_BE_CHANGED) { 0x80000 }
      const_attr_reader  :CKF_USER_PIN_TO_BE_CHANGED
      
      # CKF_SO_PIN_COUNT_LOW if new for v2.10. If it is true, an
      # incorrect SO login PIN has been entered at least once since
      # the last successful authentication.
      const_set_lazy(:CKF_SO_PIN_COUNT_LOW) { 0x100000 }
      const_attr_reader  :CKF_SO_PIN_COUNT_LOW
      
      # CKF_SO_PIN_FINAL_TRY if new for v2.10. If it is true,
      # supplying an incorrect SO PIN will it to become locked.
      const_set_lazy(:CKF_SO_PIN_FINAL_TRY) { 0x200000 }
      const_attr_reader  :CKF_SO_PIN_FINAL_TRY
      
      # CKF_SO_PIN_LOCKED if new for v2.10. If it is true, the SO
      # PIN has been locked. SO login to the token is not possible.
      const_set_lazy(:CKF_SO_PIN_LOCKED) { 0x400000 }
      const_attr_reader  :CKF_SO_PIN_LOCKED
      
      # CKF_SO_PIN_TO_BE_CHANGED if new for v2.10. If it is true,
      # the SO PIN value is the default value set by token
      # initialization or manufacturing.
      const_set_lazy(:CKF_SO_PIN_TO_BE_CHANGED) { 0x800000 }
      const_attr_reader  :CKF_SO_PIN_TO_BE_CHANGED
      
      # CK_USER_TYPE enumerates the types of Cryptoki users
      # CK_USER_TYPE has been changed from an enum to a CK_ULONG for
      # v2.0
      # Security Officer
      const_set_lazy(:CKU_SO) { 0 }
      const_attr_reader  :CKU_SO
      
      # Normal user
      const_set_lazy(:CKU_USER) { 1 }
      const_attr_reader  :CKU_USER
      
      # CK_STATE enumerates the session states
      # CK_STATE has been changed from an enum to a CK_ULONG for
      # v2.0
      const_set_lazy(:CKS_RO_PUBLIC_SESSION) { 0 }
      const_attr_reader  :CKS_RO_PUBLIC_SESSION
      
      const_set_lazy(:CKS_RO_USER_FUNCTIONS) { 1 }
      const_attr_reader  :CKS_RO_USER_FUNCTIONS
      
      const_set_lazy(:CKS_RW_PUBLIC_SESSION) { 2 }
      const_attr_reader  :CKS_RW_PUBLIC_SESSION
      
      const_set_lazy(:CKS_RW_USER_FUNCTIONS) { 3 }
      const_attr_reader  :CKS_RW_USER_FUNCTIONS
      
      const_set_lazy(:CKS_RW_SO_FUNCTIONS) { 4 }
      const_attr_reader  :CKS_RW_SO_FUNCTIONS
      
      # The flags are defined in the following table:
      # Bit Flag                Mask        Meaning
      # 
      # session is r/w
      const_set_lazy(:CKF_RW_SESSION) { 0x2 }
      const_attr_reader  :CKF_RW_SESSION
      
      # no parallel
      const_set_lazy(:CKF_SERIAL_SESSION) { 0x4 }
      const_attr_reader  :CKF_SERIAL_SESSION
      
      # The following classes of objects are defined:
      # CKO_HW_FEATURE is new for v2.10
      # CKO_DOMAIN_PARAMETERS is new for v2.11
      const_set_lazy(:CKO_DATA) { 0x0 }
      const_attr_reader  :CKO_DATA
      
      const_set_lazy(:CKO_CERTIFICATE) { 0x1 }
      const_attr_reader  :CKO_CERTIFICATE
      
      const_set_lazy(:CKO_PUBLIC_KEY) { 0x2 }
      const_attr_reader  :CKO_PUBLIC_KEY
      
      const_set_lazy(:CKO_PRIVATE_KEY) { 0x3 }
      const_attr_reader  :CKO_PRIVATE_KEY
      
      const_set_lazy(:CKO_SECRET_KEY) { 0x4 }
      const_attr_reader  :CKO_SECRET_KEY
      
      const_set_lazy(:CKO_HW_FEATURE) { 0x5 }
      const_attr_reader  :CKO_HW_FEATURE
      
      const_set_lazy(:CKO_DOMAIN_PARAMETERS) { 0x6 }
      const_attr_reader  :CKO_DOMAIN_PARAMETERS
      
      const_set_lazy(:CKO_VENDOR_DEFINED) { 0x80000000 }
      const_attr_reader  :CKO_VENDOR_DEFINED
      
      # pseudo object class ANY (for template manager)
      const_set_lazy(:PCKO_ANY) { 0x7fffff23 }
      const_attr_reader  :PCKO_ANY
      
      # The following hardware feature types are defined
      const_set_lazy(:CKH_MONOTONIC_COUNTER) { 0x1 }
      const_attr_reader  :CKH_MONOTONIC_COUNTER
      
      const_set_lazy(:CKH_CLOCK) { 0x2 }
      const_attr_reader  :CKH_CLOCK
      
      const_set_lazy(:CKH_VENDOR_DEFINED) { 0x80000000 }
      const_attr_reader  :CKH_VENDOR_DEFINED
      
      # the following key types are defined:
      const_set_lazy(:CKK_RSA) { 0x0 }
      const_attr_reader  :CKK_RSA
      
      const_set_lazy(:CKK_DSA) { 0x1 }
      const_attr_reader  :CKK_DSA
      
      const_set_lazy(:CKK_DH) { 0x2 }
      const_attr_reader  :CKK_DH
      
      # CKK_ECDSA and CKK_KEA are new for v2.0
      # CKK_ECDSA is deprecated in v2.11, CKK_EC is preferred.
      const_set_lazy(:CKK_ECDSA) { 0x3 }
      const_attr_reader  :CKK_ECDSA
      
      const_set_lazy(:CKK_EC) { 0x3 }
      const_attr_reader  :CKK_EC
      
      const_set_lazy(:CKK_X9_42_DH) { 0x4 }
      const_attr_reader  :CKK_X9_42_DH
      
      const_set_lazy(:CKK_KEA) { 0x5 }
      const_attr_reader  :CKK_KEA
      
      const_set_lazy(:CKK_GENERIC_SECRET) { 0x10 }
      const_attr_reader  :CKK_GENERIC_SECRET
      
      const_set_lazy(:CKK_RC2) { 0x11 }
      const_attr_reader  :CKK_RC2
      
      const_set_lazy(:CKK_RC4) { 0x12 }
      const_attr_reader  :CKK_RC4
      
      const_set_lazy(:CKK_DES) { 0x13 }
      const_attr_reader  :CKK_DES
      
      const_set_lazy(:CKK_DES2) { 0x14 }
      const_attr_reader  :CKK_DES2
      
      const_set_lazy(:CKK_DES3) { 0x15 }
      const_attr_reader  :CKK_DES3
      
      # all these key types are new for v2.0
      const_set_lazy(:CKK_CAST) { 0x16 }
      const_attr_reader  :CKK_CAST
      
      const_set_lazy(:CKK_CAST3) { 0x17 }
      const_attr_reader  :CKK_CAST3
      
      # CKK_CAST5 is deprecated in v2.11, CKK_CAST128 is preferred.
      const_set_lazy(:CKK_CAST5) { 0x18 }
      const_attr_reader  :CKK_CAST5
      
      # CAST128=CAST5
      const_set_lazy(:CKK_CAST128) { 0x18 }
      const_attr_reader  :CKK_CAST128
      
      const_set_lazy(:CKK_RC5) { 0x19 }
      const_attr_reader  :CKK_RC5
      
      const_set_lazy(:CKK_IDEA) { 0x1a }
      const_attr_reader  :CKK_IDEA
      
      const_set_lazy(:CKK_SKIPJACK) { 0x1b }
      const_attr_reader  :CKK_SKIPJACK
      
      const_set_lazy(:CKK_BATON) { 0x1c }
      const_attr_reader  :CKK_BATON
      
      const_set_lazy(:CKK_JUNIPER) { 0x1d }
      const_attr_reader  :CKK_JUNIPER
      
      const_set_lazy(:CKK_CDMF) { 0x1e }
      const_attr_reader  :CKK_CDMF
      
      const_set_lazy(:CKK_AES) { 0x1f }
      const_attr_reader  :CKK_AES
      
      # v2.20
      const_set_lazy(:CKK_BLOWFISH) { 0x20 }
      const_attr_reader  :CKK_BLOWFISH
      
      const_set_lazy(:CKK_VENDOR_DEFINED) { 0x80000000 }
      const_attr_reader  :CKK_VENDOR_DEFINED
      
      # pseudo key type ANY (for template manager)
      const_set_lazy(:PCKK_ANY) { 0x7fffff22 }
      const_attr_reader  :PCKK_ANY
      
      const_set_lazy(:PCKK_HMAC) { 0x7fffff23 }
      const_attr_reader  :PCKK_HMAC
      
      const_set_lazy(:PCKK_SSLMAC) { 0x7fffff24 }
      const_attr_reader  :PCKK_SSLMAC
      
      const_set_lazy(:PCKK_TLSPREMASTER) { 0x7fffff25 }
      const_attr_reader  :PCKK_TLSPREMASTER
      
      const_set_lazy(:PCKK_TLSRSAPREMASTER) { 0x7fffff26 }
      const_attr_reader  :PCKK_TLSRSAPREMASTER
      
      const_set_lazy(:PCKK_TLSMASTER) { 0x7fffff27 }
      const_attr_reader  :PCKK_TLSMASTER
      
      # The following certificate types are defined:
      # CKC_X_509_ATTR_CERT is new for v2.10
      const_set_lazy(:CKC_X_509) { 0x0 }
      const_attr_reader  :CKC_X_509
      
      const_set_lazy(:CKC_X_509_ATTR_CERT) { 0x1 }
      const_attr_reader  :CKC_X_509_ATTR_CERT
      
      const_set_lazy(:CKC_VENDOR_DEFINED) { 0x80000000 }
      const_attr_reader  :CKC_VENDOR_DEFINED
      
      # The following attribute types are defined:
      const_set_lazy(:CKA_CLASS) { 0x0 }
      const_attr_reader  :CKA_CLASS
      
      const_set_lazy(:CKA_TOKEN) { 0x1 }
      const_attr_reader  :CKA_TOKEN
      
      const_set_lazy(:CKA_PRIVATE) { 0x2 }
      const_attr_reader  :CKA_PRIVATE
      
      const_set_lazy(:CKA_LABEL) { 0x3 }
      const_attr_reader  :CKA_LABEL
      
      const_set_lazy(:CKA_APPLICATION) { 0x10 }
      const_attr_reader  :CKA_APPLICATION
      
      const_set_lazy(:CKA_VALUE) { 0x11 }
      const_attr_reader  :CKA_VALUE
      
      # CKA_OBJECT_ID is new for v2.10
      const_set_lazy(:CKA_OBJECT_ID) { 0x12 }
      const_attr_reader  :CKA_OBJECT_ID
      
      const_set_lazy(:CKA_CERTIFICATE_TYPE) { 0x80 }
      const_attr_reader  :CKA_CERTIFICATE_TYPE
      
      const_set_lazy(:CKA_ISSUER) { 0x81 }
      const_attr_reader  :CKA_ISSUER
      
      const_set_lazy(:CKA_SERIAL_NUMBER) { 0x82 }
      const_attr_reader  :CKA_SERIAL_NUMBER
      
      # CKA_AC_ISSUER, CKA_OWNER, and CKA_ATTR_TYPES are new L;
      # for v2.10
      const_set_lazy(:CKA_AC_ISSUER) { 0x83 }
      const_attr_reader  :CKA_AC_ISSUER
      
      const_set_lazy(:CKA_OWNER) { 0x84 }
      const_attr_reader  :CKA_OWNER
      
      const_set_lazy(:CKA_ATTR_TYPES) { 0x85 }
      const_attr_reader  :CKA_ATTR_TYPES
      
      # CKA_TRUSTED is new for v2.11
      const_set_lazy(:CKA_TRUSTED) { 0x86 }
      const_attr_reader  :CKA_TRUSTED
      
      const_set_lazy(:CKA_KEY_TYPE) { 0x100 }
      const_attr_reader  :CKA_KEY_TYPE
      
      const_set_lazy(:CKA_SUBJECT) { 0x101 }
      const_attr_reader  :CKA_SUBJECT
      
      const_set_lazy(:CKA_ID) { 0x102 }
      const_attr_reader  :CKA_ID
      
      const_set_lazy(:CKA_SENSITIVE) { 0x103 }
      const_attr_reader  :CKA_SENSITIVE
      
      const_set_lazy(:CKA_ENCRYPT) { 0x104 }
      const_attr_reader  :CKA_ENCRYPT
      
      const_set_lazy(:CKA_DECRYPT) { 0x105 }
      const_attr_reader  :CKA_DECRYPT
      
      const_set_lazy(:CKA_WRAP) { 0x106 }
      const_attr_reader  :CKA_WRAP
      
      const_set_lazy(:CKA_UNWRAP) { 0x107 }
      const_attr_reader  :CKA_UNWRAP
      
      const_set_lazy(:CKA_SIGN) { 0x108 }
      const_attr_reader  :CKA_SIGN
      
      const_set_lazy(:CKA_SIGN_RECOVER) { 0x109 }
      const_attr_reader  :CKA_SIGN_RECOVER
      
      const_set_lazy(:CKA_VERIFY) { 0x10a }
      const_attr_reader  :CKA_VERIFY
      
      const_set_lazy(:CKA_VERIFY_RECOVER) { 0x10b }
      const_attr_reader  :CKA_VERIFY_RECOVER
      
      const_set_lazy(:CKA_DERIVE) { 0x10c }
      const_attr_reader  :CKA_DERIVE
      
      const_set_lazy(:CKA_START_DATE) { 0x110 }
      const_attr_reader  :CKA_START_DATE
      
      const_set_lazy(:CKA_END_DATE) { 0x111 }
      const_attr_reader  :CKA_END_DATE
      
      const_set_lazy(:CKA_MODULUS) { 0x120 }
      const_attr_reader  :CKA_MODULUS
      
      const_set_lazy(:CKA_MODULUS_BITS) { 0x121 }
      const_attr_reader  :CKA_MODULUS_BITS
      
      const_set_lazy(:CKA_PUBLIC_EXPONENT) { 0x122 }
      const_attr_reader  :CKA_PUBLIC_EXPONENT
      
      const_set_lazy(:CKA_PRIVATE_EXPONENT) { 0x123 }
      const_attr_reader  :CKA_PRIVATE_EXPONENT
      
      const_set_lazy(:CKA_PRIME_1) { 0x124 }
      const_attr_reader  :CKA_PRIME_1
      
      const_set_lazy(:CKA_PRIME_2) { 0x125 }
      const_attr_reader  :CKA_PRIME_2
      
      const_set_lazy(:CKA_EXPONENT_1) { 0x126 }
      const_attr_reader  :CKA_EXPONENT_1
      
      const_set_lazy(:CKA_EXPONENT_2) { 0x127 }
      const_attr_reader  :CKA_EXPONENT_2
      
      const_set_lazy(:CKA_COEFFICIENT) { 0x128 }
      const_attr_reader  :CKA_COEFFICIENT
      
      const_set_lazy(:CKA_PRIME) { 0x130 }
      const_attr_reader  :CKA_PRIME
      
      const_set_lazy(:CKA_SUBPRIME) { 0x131 }
      const_attr_reader  :CKA_SUBPRIME
      
      const_set_lazy(:CKA_BASE) { 0x132 }
      const_attr_reader  :CKA_BASE
      
      # CKA_PRIME_BITS and CKA_SUB_PRIME_BITS are new for v2.11
      const_set_lazy(:CKA_PRIME_BITS) { 0x133 }
      const_attr_reader  :CKA_PRIME_BITS
      
      const_set_lazy(:CKA_SUB_PRIME_BITS) { 0x134 }
      const_attr_reader  :CKA_SUB_PRIME_BITS
      
      const_set_lazy(:CKA_VALUE_BITS) { 0x160 }
      const_attr_reader  :CKA_VALUE_BITS
      
      const_set_lazy(:CKA_VALUE_LEN) { 0x161 }
      const_attr_reader  :CKA_VALUE_LEN
      
      # CKA_EXTRACTABLE, CKA_LOCAL, CKA_NEVER_EXTRACTABLE,
      # CKA_ALWAYS_SENSITIVE, CKA_MODIFIABLE, CKA_ECDSA_PARAMS,
      # and CKA_EC_POINT are new for v2.0
      const_set_lazy(:CKA_EXTRACTABLE) { 0x162 }
      const_attr_reader  :CKA_EXTRACTABLE
      
      const_set_lazy(:CKA_LOCAL) { 0x163 }
      const_attr_reader  :CKA_LOCAL
      
      const_set_lazy(:CKA_NEVER_EXTRACTABLE) { 0x164 }
      const_attr_reader  :CKA_NEVER_EXTRACTABLE
      
      const_set_lazy(:CKA_ALWAYS_SENSITIVE) { 0x165 }
      const_attr_reader  :CKA_ALWAYS_SENSITIVE
      
      # CKA_KEY_GEN_MECHANISM is new for v2.11
      const_set_lazy(:CKA_KEY_GEN_MECHANISM) { 0x166 }
      const_attr_reader  :CKA_KEY_GEN_MECHANISM
      
      const_set_lazy(:CKA_MODIFIABLE) { 0x170 }
      const_attr_reader  :CKA_MODIFIABLE
      
      # CKA_ECDSA_PARAMS is deprecated in v2.11,
      # CKA_EC_PARAMS is preferred.
      const_set_lazy(:CKA_ECDSA_PARAMS) { 0x180 }
      const_attr_reader  :CKA_ECDSA_PARAMS
      
      const_set_lazy(:CKA_EC_PARAMS) { 0x180 }
      const_attr_reader  :CKA_EC_PARAMS
      
      const_set_lazy(:CKA_EC_POINT) { 0x181 }
      const_attr_reader  :CKA_EC_POINT
      
      # CKA_SECONDARY_AUTH, CKA_AUTH_PIN_FLAGS,
      # CKA_HW_FEATURE_TYPE, CKA_RESET_ON_INIT, and CKA_HAS_RESET
      # are new for v2.10
      const_set_lazy(:CKA_SECONDARY_AUTH) { 0x200 }
      const_attr_reader  :CKA_SECONDARY_AUTH
      
      const_set_lazy(:CKA_AUTH_PIN_FLAGS) { 0x201 }
      const_attr_reader  :CKA_AUTH_PIN_FLAGS
      
      const_set_lazy(:CKA_HW_FEATURE_TYPE) { 0x300 }
      const_attr_reader  :CKA_HW_FEATURE_TYPE
      
      const_set_lazy(:CKA_RESET_ON_INIT) { 0x301 }
      const_attr_reader  :CKA_RESET_ON_INIT
      
      const_set_lazy(:CKA_HAS_RESET) { 0x302 }
      const_attr_reader  :CKA_HAS_RESET
      
      const_set_lazy(:CKA_VENDOR_DEFINED) { 0x80000000 }
      const_attr_reader  :CKA_VENDOR_DEFINED
      
      # the following mechanism types are defined:
      const_set_lazy(:CKM_RSA_PKCS_KEY_PAIR_GEN) { 0x0 }
      const_attr_reader  :CKM_RSA_PKCS_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_RSA_PKCS) { 0x1 }
      const_attr_reader  :CKM_RSA_PKCS
      
      const_set_lazy(:CKM_RSA_9796) { 0x2 }
      const_attr_reader  :CKM_RSA_9796
      
      const_set_lazy(:CKM_RSA_X_509) { 0x3 }
      const_attr_reader  :CKM_RSA_X_509
      
      # CKM_MD2_RSA_PKCS, CKM_MD5_RSA_PKCS, and CKM_SHA1_RSA_PKCS
      # are new for v2.0.  They are mechanisms which hash and sign
      const_set_lazy(:CKM_MD2_RSA_PKCS) { 0x4 }
      const_attr_reader  :CKM_MD2_RSA_PKCS
      
      const_set_lazy(:CKM_MD5_RSA_PKCS) { 0x5 }
      const_attr_reader  :CKM_MD5_RSA_PKCS
      
      const_set_lazy(:CKM_SHA1_RSA_PKCS) { 0x6 }
      const_attr_reader  :CKM_SHA1_RSA_PKCS
      
      # CKM_RIPEMD128_RSA_PKCS, CKM_RIPEMD160_RSA_PKCS, and
      # CKM_RSA_PKCS_OAEP are new for v2.10
      const_set_lazy(:CKM_RIPEMD128_RSA_PKCS) { 0x7 }
      const_attr_reader  :CKM_RIPEMD128_RSA_PKCS
      
      const_set_lazy(:CKM_RIPEMD160_RSA_PKCS) { 0x8 }
      const_attr_reader  :CKM_RIPEMD160_RSA_PKCS
      
      const_set_lazy(:CKM_RSA_PKCS_OAEP) { 0x9 }
      const_attr_reader  :CKM_RSA_PKCS_OAEP
      
      # CKM_RSA_X9_31_KEY_PAIR_GEN, CKM_RSA_X9_31, CKM_SHA1_RSA_X9_31,
      # CKM_RSA_PKCS_PSS, and CKM_SHA1_RSA_PKCS_PSS are new for v2.11
      const_set_lazy(:CKM_RSA_X9_31_KEY_PAIR_GEN) { 0xa }
      const_attr_reader  :CKM_RSA_X9_31_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_RSA_X9_31) { 0xb }
      const_attr_reader  :CKM_RSA_X9_31
      
      const_set_lazy(:CKM_SHA1_RSA_X9_31) { 0xc }
      const_attr_reader  :CKM_SHA1_RSA_X9_31
      
      const_set_lazy(:CKM_RSA_PKCS_PSS) { 0xd }
      const_attr_reader  :CKM_RSA_PKCS_PSS
      
      const_set_lazy(:CKM_SHA1_RSA_PKCS_PSS) { 0xe }
      const_attr_reader  :CKM_SHA1_RSA_PKCS_PSS
      
      const_set_lazy(:CKM_DSA_KEY_PAIR_GEN) { 0x10 }
      const_attr_reader  :CKM_DSA_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_DSA) { 0x11 }
      const_attr_reader  :CKM_DSA
      
      const_set_lazy(:CKM_DSA_SHA1) { 0x12 }
      const_attr_reader  :CKM_DSA_SHA1
      
      const_set_lazy(:CKM_DH_PKCS_KEY_PAIR_GEN) { 0x20 }
      const_attr_reader  :CKM_DH_PKCS_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_DH_PKCS_DERIVE) { 0x21 }
      const_attr_reader  :CKM_DH_PKCS_DERIVE
      
      # CKM_X9_42_DH_KEY_PAIR_GEN, CKM_X9_42_DH_DERIVE,
      # CKM_X9_42_DH_HYBRID_DERIVE, and CKM_X9_42_MQV_DERIVE are new for
      # v2.11
      const_set_lazy(:CKM_X9_42_DH_KEY_PAIR_GEN) { 0x30 }
      const_attr_reader  :CKM_X9_42_DH_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_X9_42_DH_DERIVE) { 0x31 }
      const_attr_reader  :CKM_X9_42_DH_DERIVE
      
      const_set_lazy(:CKM_X9_42_DH_HYBRID_DERIVE) { 0x32 }
      const_attr_reader  :CKM_X9_42_DH_HYBRID_DERIVE
      
      const_set_lazy(:CKM_X9_42_MQV_DERIVE) { 0x33 }
      const_attr_reader  :CKM_X9_42_MQV_DERIVE
      
      # v2.20
      const_set_lazy(:CKM_SHA256_RSA_PKCS) { 0x40 }
      const_attr_reader  :CKM_SHA256_RSA_PKCS
      
      const_set_lazy(:CKM_SHA384_RSA_PKCS) { 0x41 }
      const_attr_reader  :CKM_SHA384_RSA_PKCS
      
      const_set_lazy(:CKM_SHA512_RSA_PKCS) { 0x42 }
      const_attr_reader  :CKM_SHA512_RSA_PKCS
      
      const_set_lazy(:CKM_RC2_KEY_GEN) { 0x100 }
      const_attr_reader  :CKM_RC2_KEY_GEN
      
      const_set_lazy(:CKM_RC2_ECB) { 0x101 }
      const_attr_reader  :CKM_RC2_ECB
      
      const_set_lazy(:CKM_RC2_CBC) { 0x102 }
      const_attr_reader  :CKM_RC2_CBC
      
      const_set_lazy(:CKM_RC2_MAC) { 0x103 }
      const_attr_reader  :CKM_RC2_MAC
      
      # CKM_RC2_MAC_GENERAL and CKM_RC2_CBC_PAD are new for v2.0
      const_set_lazy(:CKM_RC2_MAC_GENERAL) { 0x104 }
      const_attr_reader  :CKM_RC2_MAC_GENERAL
      
      const_set_lazy(:CKM_RC2_CBC_PAD) { 0x105 }
      const_attr_reader  :CKM_RC2_CBC_PAD
      
      const_set_lazy(:CKM_RC4_KEY_GEN) { 0x110 }
      const_attr_reader  :CKM_RC4_KEY_GEN
      
      const_set_lazy(:CKM_RC4) { 0x111 }
      const_attr_reader  :CKM_RC4
      
      const_set_lazy(:CKM_DES_KEY_GEN) { 0x120 }
      const_attr_reader  :CKM_DES_KEY_GEN
      
      const_set_lazy(:CKM_DES_ECB) { 0x121 }
      const_attr_reader  :CKM_DES_ECB
      
      const_set_lazy(:CKM_DES_CBC) { 0x122 }
      const_attr_reader  :CKM_DES_CBC
      
      const_set_lazy(:CKM_DES_MAC) { 0x123 }
      const_attr_reader  :CKM_DES_MAC
      
      # CKM_DES_MAC_GENERAL and CKM_DES_CBC_PAD are new for v2.0
      const_set_lazy(:CKM_DES_MAC_GENERAL) { 0x124 }
      const_attr_reader  :CKM_DES_MAC_GENERAL
      
      const_set_lazy(:CKM_DES_CBC_PAD) { 0x125 }
      const_attr_reader  :CKM_DES_CBC_PAD
      
      const_set_lazy(:CKM_DES2_KEY_GEN) { 0x130 }
      const_attr_reader  :CKM_DES2_KEY_GEN
      
      const_set_lazy(:CKM_DES3_KEY_GEN) { 0x131 }
      const_attr_reader  :CKM_DES3_KEY_GEN
      
      const_set_lazy(:CKM_DES3_ECB) { 0x132 }
      const_attr_reader  :CKM_DES3_ECB
      
      const_set_lazy(:CKM_DES3_CBC) { 0x133 }
      const_attr_reader  :CKM_DES3_CBC
      
      const_set_lazy(:CKM_DES3_MAC) { 0x134 }
      const_attr_reader  :CKM_DES3_MAC
      
      # CKM_DES3_MAC_GENERAL, CKM_DES3_CBC_PAD, CKM_CDMF_KEY_GEN,
      # CKM_CDMF_ECB, CKM_CDMF_CBC, CKM_CDMF_MAC,
      # CKM_CDMF_MAC_GENERAL, and CKM_CDMF_CBC_PAD are new for v2.0
      const_set_lazy(:CKM_DES3_MAC_GENERAL) { 0x135 }
      const_attr_reader  :CKM_DES3_MAC_GENERAL
      
      const_set_lazy(:CKM_DES3_CBC_PAD) { 0x136 }
      const_attr_reader  :CKM_DES3_CBC_PAD
      
      const_set_lazy(:CKM_CDMF_KEY_GEN) { 0x140 }
      const_attr_reader  :CKM_CDMF_KEY_GEN
      
      const_set_lazy(:CKM_CDMF_ECB) { 0x141 }
      const_attr_reader  :CKM_CDMF_ECB
      
      const_set_lazy(:CKM_CDMF_CBC) { 0x142 }
      const_attr_reader  :CKM_CDMF_CBC
      
      const_set_lazy(:CKM_CDMF_MAC) { 0x143 }
      const_attr_reader  :CKM_CDMF_MAC
      
      const_set_lazy(:CKM_CDMF_MAC_GENERAL) { 0x144 }
      const_attr_reader  :CKM_CDMF_MAC_GENERAL
      
      const_set_lazy(:CKM_CDMF_CBC_PAD) { 0x145 }
      const_attr_reader  :CKM_CDMF_CBC_PAD
      
      const_set_lazy(:CKM_MD2) { 0x200 }
      const_attr_reader  :CKM_MD2
      
      # CKM_MD2_HMAC and CKM_MD2_HMAC_GENERAL are new for v2.0
      const_set_lazy(:CKM_MD2_HMAC) { 0x201 }
      const_attr_reader  :CKM_MD2_HMAC
      
      const_set_lazy(:CKM_MD2_HMAC_GENERAL) { 0x202 }
      const_attr_reader  :CKM_MD2_HMAC_GENERAL
      
      const_set_lazy(:CKM_MD5) { 0x210 }
      const_attr_reader  :CKM_MD5
      
      # CKM_MD5_HMAC and CKM_MD5_HMAC_GENERAL are new for v2.0
      const_set_lazy(:CKM_MD5_HMAC) { 0x211 }
      const_attr_reader  :CKM_MD5_HMAC
      
      const_set_lazy(:CKM_MD5_HMAC_GENERAL) { 0x212 }
      const_attr_reader  :CKM_MD5_HMAC_GENERAL
      
      const_set_lazy(:CKM_SHA_1) { 0x220 }
      const_attr_reader  :CKM_SHA_1
      
      # CKM_SHA_1_HMAC and CKM_SHA_1_HMAC_GENERAL are new for v2.0
      const_set_lazy(:CKM_SHA_1_HMAC) { 0x221 }
      const_attr_reader  :CKM_SHA_1_HMAC
      
      const_set_lazy(:CKM_SHA_1_HMAC_GENERAL) { 0x222 }
      const_attr_reader  :CKM_SHA_1_HMAC_GENERAL
      
      # CKM_RIPEMD128, CKM_RIPEMD128_HMAC,
      # CKM_RIPEMD128_HMAC_GENERAL, CKM_RIPEMD160, CKM_RIPEMD160_HMAC,
      # and CKM_RIPEMD160_HMAC_GENERAL are new for v2.10
      const_set_lazy(:CKM_RIPEMD128) { 0x230 }
      const_attr_reader  :CKM_RIPEMD128
      
      const_set_lazy(:CKM_RIPEMD128_HMAC) { 0x231 }
      const_attr_reader  :CKM_RIPEMD128_HMAC
      
      const_set_lazy(:CKM_RIPEMD128_HMAC_GENERAL) { 0x232 }
      const_attr_reader  :CKM_RIPEMD128_HMAC_GENERAL
      
      const_set_lazy(:CKM_RIPEMD160) { 0x240 }
      const_attr_reader  :CKM_RIPEMD160
      
      const_set_lazy(:CKM_RIPEMD160_HMAC) { 0x241 }
      const_attr_reader  :CKM_RIPEMD160_HMAC
      
      const_set_lazy(:CKM_RIPEMD160_HMAC_GENERAL) { 0x242 }
      const_attr_reader  :CKM_RIPEMD160_HMAC_GENERAL
      
      # v2.20
      const_set_lazy(:CKM_SHA256) { 0x250 }
      const_attr_reader  :CKM_SHA256
      
      const_set_lazy(:CKM_SHA256_HMAC) { 0x251 }
      const_attr_reader  :CKM_SHA256_HMAC
      
      const_set_lazy(:CKM_SHA256_HMAC_GENERAL) { 0x252 }
      const_attr_reader  :CKM_SHA256_HMAC_GENERAL
      
      const_set_lazy(:CKM_SHA384) { 0x260 }
      const_attr_reader  :CKM_SHA384
      
      const_set_lazy(:CKM_SHA384_HMAC) { 0x261 }
      const_attr_reader  :CKM_SHA384_HMAC
      
      const_set_lazy(:CKM_SHA384_HMAC_GENERAL) { 0x262 }
      const_attr_reader  :CKM_SHA384_HMAC_GENERAL
      
      const_set_lazy(:CKM_SHA512) { 0x270 }
      const_attr_reader  :CKM_SHA512
      
      const_set_lazy(:CKM_SHA512_HMAC) { 0x271 }
      const_attr_reader  :CKM_SHA512_HMAC
      
      const_set_lazy(:CKM_SHA512_HMAC_GENERAL) { 0x272 }
      const_attr_reader  :CKM_SHA512_HMAC_GENERAL
      
      # All of the following mechanisms are new for v2.0
      # Note that CAST128 and CAST5 are the same algorithm
      const_set_lazy(:CKM_CAST_KEY_GEN) { 0x300 }
      const_attr_reader  :CKM_CAST_KEY_GEN
      
      const_set_lazy(:CKM_CAST_ECB) { 0x301 }
      const_attr_reader  :CKM_CAST_ECB
      
      const_set_lazy(:CKM_CAST_CBC) { 0x302 }
      const_attr_reader  :CKM_CAST_CBC
      
      const_set_lazy(:CKM_CAST_MAC) { 0x303 }
      const_attr_reader  :CKM_CAST_MAC
      
      const_set_lazy(:CKM_CAST_MAC_GENERAL) { 0x304 }
      const_attr_reader  :CKM_CAST_MAC_GENERAL
      
      const_set_lazy(:CKM_CAST_CBC_PAD) { 0x305 }
      const_attr_reader  :CKM_CAST_CBC_PAD
      
      const_set_lazy(:CKM_CAST3_KEY_GEN) { 0x310 }
      const_attr_reader  :CKM_CAST3_KEY_GEN
      
      const_set_lazy(:CKM_CAST3_ECB) { 0x311 }
      const_attr_reader  :CKM_CAST3_ECB
      
      const_set_lazy(:CKM_CAST3_CBC) { 0x312 }
      const_attr_reader  :CKM_CAST3_CBC
      
      const_set_lazy(:CKM_CAST3_MAC) { 0x313 }
      const_attr_reader  :CKM_CAST3_MAC
      
      const_set_lazy(:CKM_CAST3_MAC_GENERAL) { 0x314 }
      const_attr_reader  :CKM_CAST3_MAC_GENERAL
      
      const_set_lazy(:CKM_CAST3_CBC_PAD) { 0x315 }
      const_attr_reader  :CKM_CAST3_CBC_PAD
      
      const_set_lazy(:CKM_CAST5_KEY_GEN) { 0x320 }
      const_attr_reader  :CKM_CAST5_KEY_GEN
      
      const_set_lazy(:CKM_CAST128_KEY_GEN) { 0x320 }
      const_attr_reader  :CKM_CAST128_KEY_GEN
      
      const_set_lazy(:CKM_CAST5_ECB) { 0x321 }
      const_attr_reader  :CKM_CAST5_ECB
      
      const_set_lazy(:CKM_CAST128_ECB) { 0x321 }
      const_attr_reader  :CKM_CAST128_ECB
      
      const_set_lazy(:CKM_CAST5_CBC) { 0x322 }
      const_attr_reader  :CKM_CAST5_CBC
      
      const_set_lazy(:CKM_CAST128_CBC) { 0x322 }
      const_attr_reader  :CKM_CAST128_CBC
      
      const_set_lazy(:CKM_CAST5_MAC) { 0x323 }
      const_attr_reader  :CKM_CAST5_MAC
      
      const_set_lazy(:CKM_CAST128_MAC) { 0x323 }
      const_attr_reader  :CKM_CAST128_MAC
      
      const_set_lazy(:CKM_CAST5_MAC_GENERAL) { 0x324 }
      const_attr_reader  :CKM_CAST5_MAC_GENERAL
      
      const_set_lazy(:CKM_CAST128_MAC_GENERAL) { 0x324 }
      const_attr_reader  :CKM_CAST128_MAC_GENERAL
      
      const_set_lazy(:CKM_CAST5_CBC_PAD) { 0x325 }
      const_attr_reader  :CKM_CAST5_CBC_PAD
      
      const_set_lazy(:CKM_CAST128_CBC_PAD) { 0x325 }
      const_attr_reader  :CKM_CAST128_CBC_PAD
      
      const_set_lazy(:CKM_RC5_KEY_GEN) { 0x330 }
      const_attr_reader  :CKM_RC5_KEY_GEN
      
      const_set_lazy(:CKM_RC5_ECB) { 0x331 }
      const_attr_reader  :CKM_RC5_ECB
      
      const_set_lazy(:CKM_RC5_CBC) { 0x332 }
      const_attr_reader  :CKM_RC5_CBC
      
      const_set_lazy(:CKM_RC5_MAC) { 0x333 }
      const_attr_reader  :CKM_RC5_MAC
      
      const_set_lazy(:CKM_RC5_MAC_GENERAL) { 0x334 }
      const_attr_reader  :CKM_RC5_MAC_GENERAL
      
      const_set_lazy(:CKM_RC5_CBC_PAD) { 0x335 }
      const_attr_reader  :CKM_RC5_CBC_PAD
      
      const_set_lazy(:CKM_IDEA_KEY_GEN) { 0x340 }
      const_attr_reader  :CKM_IDEA_KEY_GEN
      
      const_set_lazy(:CKM_IDEA_ECB) { 0x341 }
      const_attr_reader  :CKM_IDEA_ECB
      
      const_set_lazy(:CKM_IDEA_CBC) { 0x342 }
      const_attr_reader  :CKM_IDEA_CBC
      
      const_set_lazy(:CKM_IDEA_MAC) { 0x343 }
      const_attr_reader  :CKM_IDEA_MAC
      
      const_set_lazy(:CKM_IDEA_MAC_GENERAL) { 0x344 }
      const_attr_reader  :CKM_IDEA_MAC_GENERAL
      
      const_set_lazy(:CKM_IDEA_CBC_PAD) { 0x345 }
      const_attr_reader  :CKM_IDEA_CBC_PAD
      
      const_set_lazy(:CKM_GENERIC_SECRET_KEY_GEN) { 0x350 }
      const_attr_reader  :CKM_GENERIC_SECRET_KEY_GEN
      
      const_set_lazy(:CKM_CONCATENATE_BASE_AND_KEY) { 0x360 }
      const_attr_reader  :CKM_CONCATENATE_BASE_AND_KEY
      
      const_set_lazy(:CKM_CONCATENATE_BASE_AND_DATA) { 0x362 }
      const_attr_reader  :CKM_CONCATENATE_BASE_AND_DATA
      
      const_set_lazy(:CKM_CONCATENATE_DATA_AND_BASE) { 0x363 }
      const_attr_reader  :CKM_CONCATENATE_DATA_AND_BASE
      
      const_set_lazy(:CKM_XOR_BASE_AND_DATA) { 0x364 }
      const_attr_reader  :CKM_XOR_BASE_AND_DATA
      
      const_set_lazy(:CKM_EXTRACT_KEY_FROM_KEY) { 0x365 }
      const_attr_reader  :CKM_EXTRACT_KEY_FROM_KEY
      
      const_set_lazy(:CKM_SSL3_PRE_MASTER_KEY_GEN) { 0x370 }
      const_attr_reader  :CKM_SSL3_PRE_MASTER_KEY_GEN
      
      const_set_lazy(:CKM_SSL3_MASTER_KEY_DERIVE) { 0x371 }
      const_attr_reader  :CKM_SSL3_MASTER_KEY_DERIVE
      
      const_set_lazy(:CKM_SSL3_KEY_AND_MAC_DERIVE) { 0x372 }
      const_attr_reader  :CKM_SSL3_KEY_AND_MAC_DERIVE
      
      # CKM_SSL3_MASTER_KEY_DERIVE_DH, CKM_TLS_PRE_MASTER_KEY_GEN,
      # CKM_TLS_MASTER_KEY_DERIVE, CKM_TLS_KEY_AND_MAC_DERIVE, and
      # CKM_TLS_MASTER_KEY_DERIVE_DH are new for v2.11
      const_set_lazy(:CKM_SSL3_MASTER_KEY_DERIVE_DH) { 0x373 }
      const_attr_reader  :CKM_SSL3_MASTER_KEY_DERIVE_DH
      
      const_set_lazy(:CKM_TLS_PRE_MASTER_KEY_GEN) { 0x374 }
      const_attr_reader  :CKM_TLS_PRE_MASTER_KEY_GEN
      
      const_set_lazy(:CKM_TLS_MASTER_KEY_DERIVE) { 0x375 }
      const_attr_reader  :CKM_TLS_MASTER_KEY_DERIVE
      
      const_set_lazy(:CKM_TLS_KEY_AND_MAC_DERIVE) { 0x376 }
      const_attr_reader  :CKM_TLS_KEY_AND_MAC_DERIVE
      
      const_set_lazy(:CKM_TLS_MASTER_KEY_DERIVE_DH) { 0x377 }
      const_attr_reader  :CKM_TLS_MASTER_KEY_DERIVE_DH
      
      const_set_lazy(:CKM_TLS_PRF) { 0x378 }
      const_attr_reader  :CKM_TLS_PRF
      
      const_set_lazy(:CKM_SSL3_MD5_MAC) { 0x380 }
      const_attr_reader  :CKM_SSL3_MD5_MAC
      
      const_set_lazy(:CKM_SSL3_SHA1_MAC) { 0x381 }
      const_attr_reader  :CKM_SSL3_SHA1_MAC
      
      const_set_lazy(:CKM_MD5_KEY_DERIVATION) { 0x390 }
      const_attr_reader  :CKM_MD5_KEY_DERIVATION
      
      const_set_lazy(:CKM_MD2_KEY_DERIVATION) { 0x391 }
      const_attr_reader  :CKM_MD2_KEY_DERIVATION
      
      const_set_lazy(:CKM_SHA1_KEY_DERIVATION) { 0x392 }
      const_attr_reader  :CKM_SHA1_KEY_DERIVATION
      
      # v2.20
      const_set_lazy(:CKM_SHA256_KEY_DERIVATION) { 0x393 }
      const_attr_reader  :CKM_SHA256_KEY_DERIVATION
      
      const_set_lazy(:CKM_SHA384_KEY_DERIVATION) { 0x394 }
      const_attr_reader  :CKM_SHA384_KEY_DERIVATION
      
      const_set_lazy(:CKM_SHA512_KEY_DERIVATION) { 0x395 }
      const_attr_reader  :CKM_SHA512_KEY_DERIVATION
      
      const_set_lazy(:CKM_PBE_MD2_DES_CBC) { 0x3a0 }
      const_attr_reader  :CKM_PBE_MD2_DES_CBC
      
      const_set_lazy(:CKM_PBE_MD5_DES_CBC) { 0x3a1 }
      const_attr_reader  :CKM_PBE_MD5_DES_CBC
      
      const_set_lazy(:CKM_PBE_MD5_CAST_CBC) { 0x3a2 }
      const_attr_reader  :CKM_PBE_MD5_CAST_CBC
      
      const_set_lazy(:CKM_PBE_MD5_CAST3_CBC) { 0x3a3 }
      const_attr_reader  :CKM_PBE_MD5_CAST3_CBC
      
      const_set_lazy(:CKM_PBE_MD5_CAST5_CBC) { 0x3a4 }
      const_attr_reader  :CKM_PBE_MD5_CAST5_CBC
      
      const_set_lazy(:CKM_PBE_MD5_CAST128_CBC) { 0x3a4 }
      const_attr_reader  :CKM_PBE_MD5_CAST128_CBC
      
      const_set_lazy(:CKM_PBE_SHA1_CAST5_CBC) { 0x3a5 }
      const_attr_reader  :CKM_PBE_SHA1_CAST5_CBC
      
      const_set_lazy(:CKM_PBE_SHA1_CAST128_CBC) { 0x3a5 }
      const_attr_reader  :CKM_PBE_SHA1_CAST128_CBC
      
      const_set_lazy(:CKM_PBE_SHA1_RC4_128) { 0x3a6 }
      const_attr_reader  :CKM_PBE_SHA1_RC4_128
      
      const_set_lazy(:CKM_PBE_SHA1_RC4_40) { 0x3a7 }
      const_attr_reader  :CKM_PBE_SHA1_RC4_40
      
      const_set_lazy(:CKM_PBE_SHA1_DES3_EDE_CBC) { 0x3a8 }
      const_attr_reader  :CKM_PBE_SHA1_DES3_EDE_CBC
      
      const_set_lazy(:CKM_PBE_SHA1_DES2_EDE_CBC) { 0x3a9 }
      const_attr_reader  :CKM_PBE_SHA1_DES2_EDE_CBC
      
      const_set_lazy(:CKM_PBE_SHA1_RC2_128_CBC) { 0x3aa }
      const_attr_reader  :CKM_PBE_SHA1_RC2_128_CBC
      
      const_set_lazy(:CKM_PBE_SHA1_RC2_40_CBC) { 0x3ab }
      const_attr_reader  :CKM_PBE_SHA1_RC2_40_CBC
      
      # CKM_PKCS5_PBKD2 is new for v2.10
      const_set_lazy(:CKM_PKCS5_PBKD2) { 0x3b0 }
      const_attr_reader  :CKM_PKCS5_PBKD2
      
      const_set_lazy(:CKM_PBA_SHA1_WITH_SHA1_HMAC) { 0x3c0 }
      const_attr_reader  :CKM_PBA_SHA1_WITH_SHA1_HMAC
      
      const_set_lazy(:CKM_KEY_WRAP_LYNKS) { 0x400 }
      const_attr_reader  :CKM_KEY_WRAP_LYNKS
      
      const_set_lazy(:CKM_KEY_WRAP_SET_OAEP) { 0x401 }
      const_attr_reader  :CKM_KEY_WRAP_SET_OAEP
      
      # Fortezza mechanisms
      const_set_lazy(:CKM_SKIPJACK_KEY_GEN) { 0x1000 }
      const_attr_reader  :CKM_SKIPJACK_KEY_GEN
      
      const_set_lazy(:CKM_SKIPJACK_ECB64) { 0x1001 }
      const_attr_reader  :CKM_SKIPJACK_ECB64
      
      const_set_lazy(:CKM_SKIPJACK_CBC64) { 0x1002 }
      const_attr_reader  :CKM_SKIPJACK_CBC64
      
      const_set_lazy(:CKM_SKIPJACK_OFB64) { 0x1003 }
      const_attr_reader  :CKM_SKIPJACK_OFB64
      
      const_set_lazy(:CKM_SKIPJACK_CFB64) { 0x1004 }
      const_attr_reader  :CKM_SKIPJACK_CFB64
      
      const_set_lazy(:CKM_SKIPJACK_CFB32) { 0x1005 }
      const_attr_reader  :CKM_SKIPJACK_CFB32
      
      const_set_lazy(:CKM_SKIPJACK_CFB16) { 0x1006 }
      const_attr_reader  :CKM_SKIPJACK_CFB16
      
      const_set_lazy(:CKM_SKIPJACK_CFB8) { 0x1007 }
      const_attr_reader  :CKM_SKIPJACK_CFB8
      
      const_set_lazy(:CKM_SKIPJACK_WRAP) { 0x1008 }
      const_attr_reader  :CKM_SKIPJACK_WRAP
      
      const_set_lazy(:CKM_SKIPJACK_PRIVATE_WRAP) { 0x1009 }
      const_attr_reader  :CKM_SKIPJACK_PRIVATE_WRAP
      
      const_set_lazy(:CKM_SKIPJACK_RELAYX) { 0x100a }
      const_attr_reader  :CKM_SKIPJACK_RELAYX
      
      const_set_lazy(:CKM_KEA_KEY_PAIR_GEN) { 0x1010 }
      const_attr_reader  :CKM_KEA_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_KEA_KEY_DERIVE) { 0x1011 }
      const_attr_reader  :CKM_KEA_KEY_DERIVE
      
      const_set_lazy(:CKM_FORTEZZA_TIMESTAMP) { 0x1020 }
      const_attr_reader  :CKM_FORTEZZA_TIMESTAMP
      
      const_set_lazy(:CKM_BATON_KEY_GEN) { 0x1030 }
      const_attr_reader  :CKM_BATON_KEY_GEN
      
      const_set_lazy(:CKM_BATON_ECB128) { 0x1031 }
      const_attr_reader  :CKM_BATON_ECB128
      
      const_set_lazy(:CKM_BATON_ECB96) { 0x1032 }
      const_attr_reader  :CKM_BATON_ECB96
      
      const_set_lazy(:CKM_BATON_CBC128) { 0x1033 }
      const_attr_reader  :CKM_BATON_CBC128
      
      const_set_lazy(:CKM_BATON_COUNTER) { 0x1034 }
      const_attr_reader  :CKM_BATON_COUNTER
      
      const_set_lazy(:CKM_BATON_SHUFFLE) { 0x1035 }
      const_attr_reader  :CKM_BATON_SHUFFLE
      
      const_set_lazy(:CKM_BATON_WRAP) { 0x1036 }
      const_attr_reader  :CKM_BATON_WRAP
      
      # CKM_ECDSA_KEY_PAIR_GEN is deprecated in v2.11,
      # CKM_EC_KEY_PAIR_GEN is preferred
      const_set_lazy(:CKM_ECDSA_KEY_PAIR_GEN) { 0x1040 }
      const_attr_reader  :CKM_ECDSA_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_EC_KEY_PAIR_GEN) { 0x1040 }
      const_attr_reader  :CKM_EC_KEY_PAIR_GEN
      
      const_set_lazy(:CKM_ECDSA) { 0x1041 }
      const_attr_reader  :CKM_ECDSA
      
      const_set_lazy(:CKM_ECDSA_SHA1) { 0x1042 }
      const_attr_reader  :CKM_ECDSA_SHA1
      
      # CKM_ECDH1_DERIVE, CKM_ECDH1_COFACTOR_DERIVE, and CKM_ECMQV_DERIVE
      # are new for v2.11
      const_set_lazy(:CKM_ECDH1_DERIVE) { 0x1050 }
      const_attr_reader  :CKM_ECDH1_DERIVE
      
      const_set_lazy(:CKM_ECDH1_COFACTOR_DERIVE) { 0x1051 }
      const_attr_reader  :CKM_ECDH1_COFACTOR_DERIVE
      
      const_set_lazy(:CKM_ECMQV_DERIVE) { 0x1052 }
      const_attr_reader  :CKM_ECMQV_DERIVE
      
      const_set_lazy(:CKM_JUNIPER_KEY_GEN) { 0x1060 }
      const_attr_reader  :CKM_JUNIPER_KEY_GEN
      
      const_set_lazy(:CKM_JUNIPER_ECB128) { 0x1061 }
      const_attr_reader  :CKM_JUNIPER_ECB128
      
      const_set_lazy(:CKM_JUNIPER_CBC128) { 0x1062 }
      const_attr_reader  :CKM_JUNIPER_CBC128
      
      const_set_lazy(:CKM_JUNIPER_COUNTER) { 0x1063 }
      const_attr_reader  :CKM_JUNIPER_COUNTER
      
      const_set_lazy(:CKM_JUNIPER_SHUFFLE) { 0x1064 }
      const_attr_reader  :CKM_JUNIPER_SHUFFLE
      
      const_set_lazy(:CKM_JUNIPER_WRAP) { 0x1065 }
      const_attr_reader  :CKM_JUNIPER_WRAP
      
      const_set_lazy(:CKM_FASTHASH) { 0x1070 }
      const_attr_reader  :CKM_FASTHASH
      
      # CKM_AES_KEY_GEN, CKM_AES_ECB, CKM_AES_CBC, CKM_AES_MAC,
      # CKM_AES_MAC_GENERAL, CKM_AES_CBC_PAD, CKM_DSA_PARAMETER_GEN,
      # CKM_DH_PKCS_PARAMETER_GEN, and CKM_X9_42_DH_PARAMETER_GEN are
      # new for v2.11
      const_set_lazy(:CKM_AES_KEY_GEN) { 0x1080 }
      const_attr_reader  :CKM_AES_KEY_GEN
      
      const_set_lazy(:CKM_AES_ECB) { 0x1081 }
      const_attr_reader  :CKM_AES_ECB
      
      const_set_lazy(:CKM_AES_CBC) { 0x1082 }
      const_attr_reader  :CKM_AES_CBC
      
      const_set_lazy(:CKM_AES_MAC) { 0x1083 }
      const_attr_reader  :CKM_AES_MAC
      
      const_set_lazy(:CKM_AES_MAC_GENERAL) { 0x1084 }
      const_attr_reader  :CKM_AES_MAC_GENERAL
      
      const_set_lazy(:CKM_AES_CBC_PAD) { 0x1085 }
      const_attr_reader  :CKM_AES_CBC_PAD
      
      # v2.20
      const_set_lazy(:CKM_BLOWFISH_KEY_GEN) { 0x1090 }
      const_attr_reader  :CKM_BLOWFISH_KEY_GEN
      
      const_set_lazy(:CKM_BLOWFISH_CBC) { 0x1091 }
      const_attr_reader  :CKM_BLOWFISH_CBC
      
      const_set_lazy(:CKM_DSA_PARAMETER_GEN) { 0x2000 }
      const_attr_reader  :CKM_DSA_PARAMETER_GEN
      
      const_set_lazy(:CKM_DH_PKCS_PARAMETER_GEN) { 0x2001 }
      const_attr_reader  :CKM_DH_PKCS_PARAMETER_GEN
      
      const_set_lazy(:CKM_X9_42_DH_PARAMETER_GEN) { 0x2002 }
      const_attr_reader  :CKM_X9_42_DH_PARAMETER_GEN
      
      const_set_lazy(:CKM_VENDOR_DEFINED) { 0x80000000 }
      const_attr_reader  :CKM_VENDOR_DEFINED
      
      # NSS private
      const_set_lazy(:CKM_NSS_TLS_PRF_GENERAL) { 0x80000373 }
      const_attr_reader  :CKM_NSS_TLS_PRF_GENERAL
      
      # ids for our pseudo mechanisms SecureRandom and KeyStore
      const_set_lazy(:PCKM_SECURERANDOM) { 0x7fffff20 }
      const_attr_reader  :PCKM_SECURERANDOM
      
      const_set_lazy(:PCKM_KEYSTORE) { 0x7fffff21 }
      const_attr_reader  :PCKM_KEYSTORE
      
      # The flags are defined as follows:
      # Bit Flag               Mask        Meaning
      # performed by HW
      const_set_lazy(:CKF_HW) { 0x1 }
      const_attr_reader  :CKF_HW
      
      # The flags CKF_ENCRYPT, CKF_DECRYPT, CKF_DIGEST, CKF_SIGN,
      # CKG_SIGN_RECOVER, CKF_VERIFY, CKF_VERIFY_RECOVER,
      # CKF_GENERATE, CKF_GENERATE_KEY_PAIR, CKF_WRAP, CKF_UNWRAP,
      # and CKF_DERIVE are new for v2.0.  They specify whether or not
      # a mechanism can be used for a particular task
      const_set_lazy(:CKF_ENCRYPT) { 0x100 }
      const_attr_reader  :CKF_ENCRYPT
      
      const_set_lazy(:CKF_DECRYPT) { 0x200 }
      const_attr_reader  :CKF_DECRYPT
      
      const_set_lazy(:CKF_DIGEST) { 0x400 }
      const_attr_reader  :CKF_DIGEST
      
      const_set_lazy(:CKF_SIGN) { 0x800 }
      const_attr_reader  :CKF_SIGN
      
      const_set_lazy(:CKF_SIGN_RECOVER) { 0x1000 }
      const_attr_reader  :CKF_SIGN_RECOVER
      
      const_set_lazy(:CKF_VERIFY) { 0x2000 }
      const_attr_reader  :CKF_VERIFY
      
      const_set_lazy(:CKF_VERIFY_RECOVER) { 0x4000 }
      const_attr_reader  :CKF_VERIFY_RECOVER
      
      const_set_lazy(:CKF_GENERATE) { 0x8000 }
      const_attr_reader  :CKF_GENERATE
      
      const_set_lazy(:CKF_GENERATE_KEY_PAIR) { 0x10000 }
      const_attr_reader  :CKF_GENERATE_KEY_PAIR
      
      const_set_lazy(:CKF_WRAP) { 0x20000 }
      const_attr_reader  :CKF_WRAP
      
      const_set_lazy(:CKF_UNWRAP) { 0x40000 }
      const_attr_reader  :CKF_UNWRAP
      
      const_set_lazy(:CKF_DERIVE) { 0x80000 }
      const_attr_reader  :CKF_DERIVE
      
      # CKF_EC_F_P, CKF_EC_F_2M, CKF_EC_ECPARAMETERS, CKF_EC_NAMEDCURVE,
      # CKF_EC_UNCOMPRESS, and CKF_EC_COMPRESS are new for v2.11. They
      # describe a token's EC capabilities not available in mechanism
      # information.
      const_set_lazy(:CKF_EC_F_P) { 0x100000 }
      const_attr_reader  :CKF_EC_F_P
      
      const_set_lazy(:CKF_EC_F_2M) { 0x200000 }
      const_attr_reader  :CKF_EC_F_2M
      
      const_set_lazy(:CKF_EC_ECPARAMETERS) { 0x400000 }
      const_attr_reader  :CKF_EC_ECPARAMETERS
      
      const_set_lazy(:CKF_EC_NAMEDCURVE) { 0x800000 }
      const_attr_reader  :CKF_EC_NAMEDCURVE
      
      const_set_lazy(:CKF_EC_UNCOMPRESS) { 0x1000000 }
      const_attr_reader  :CKF_EC_UNCOMPRESS
      
      const_set_lazy(:CKF_EC_COMPRESS) { 0x2000000 }
      const_attr_reader  :CKF_EC_COMPRESS
      
      # FALSE for 2.01
      const_set_lazy(:CKF_EXTENSION) { 0x80000000 }
      const_attr_reader  :CKF_EXTENSION
      
      # CK_RV is a value that identifies the return value of a
      # Cryptoki function
      # CK_RV was changed from CK_USHORT to CK_ULONG for v2.0
      const_set_lazy(:CKR_OK) { 0x0 }
      const_attr_reader  :CKR_OK
      
      const_set_lazy(:CKR_CANCEL) { 0x1 }
      const_attr_reader  :CKR_CANCEL
      
      const_set_lazy(:CKR_HOST_MEMORY) { 0x2 }
      const_attr_reader  :CKR_HOST_MEMORY
      
      const_set_lazy(:CKR_SLOT_ID_INVALID) { 0x3 }
      const_attr_reader  :CKR_SLOT_ID_INVALID
      
      # CKR_FLAGS_INVALID was removed for v2.0
      # CKR_GENERAL_ERROR and CKR_FUNCTION_FAILED are new for v2.0
      const_set_lazy(:CKR_GENERAL_ERROR) { 0x5 }
      const_attr_reader  :CKR_GENERAL_ERROR
      
      const_set_lazy(:CKR_FUNCTION_FAILED) { 0x6 }
      const_attr_reader  :CKR_FUNCTION_FAILED
      
      # CKR_ARGUMENTS_BAD, CKR_NO_EVENT, CKR_NEED_TO_CREATE_THREADS,
      # and CKR_CANT_LOCK are new for v2.01
      const_set_lazy(:CKR_ARGUMENTS_BAD) { 0x7 }
      const_attr_reader  :CKR_ARGUMENTS_BAD
      
      const_set_lazy(:CKR_NO_EVENT) { 0x8 }
      const_attr_reader  :CKR_NO_EVENT
      
      const_set_lazy(:CKR_NEED_TO_CREATE_THREADS) { 0x9 }
      const_attr_reader  :CKR_NEED_TO_CREATE_THREADS
      
      const_set_lazy(:CKR_CANT_LOCK) { 0xa }
      const_attr_reader  :CKR_CANT_LOCK
      
      const_set_lazy(:CKR_ATTRIBUTE_READ_ONLY) { 0x10 }
      const_attr_reader  :CKR_ATTRIBUTE_READ_ONLY
      
      const_set_lazy(:CKR_ATTRIBUTE_SENSITIVE) { 0x11 }
      const_attr_reader  :CKR_ATTRIBUTE_SENSITIVE
      
      const_set_lazy(:CKR_ATTRIBUTE_TYPE_INVALID) { 0x12 }
      const_attr_reader  :CKR_ATTRIBUTE_TYPE_INVALID
      
      const_set_lazy(:CKR_ATTRIBUTE_VALUE_INVALID) { 0x13 }
      const_attr_reader  :CKR_ATTRIBUTE_VALUE_INVALID
      
      const_set_lazy(:CKR_DATA_INVALID) { 0x20 }
      const_attr_reader  :CKR_DATA_INVALID
      
      const_set_lazy(:CKR_DATA_LEN_RANGE) { 0x21 }
      const_attr_reader  :CKR_DATA_LEN_RANGE
      
      const_set_lazy(:CKR_DEVICE_ERROR) { 0x30 }
      const_attr_reader  :CKR_DEVICE_ERROR
      
      const_set_lazy(:CKR_DEVICE_MEMORY) { 0x31 }
      const_attr_reader  :CKR_DEVICE_MEMORY
      
      const_set_lazy(:CKR_DEVICE_REMOVED) { 0x32 }
      const_attr_reader  :CKR_DEVICE_REMOVED
      
      const_set_lazy(:CKR_ENCRYPTED_DATA_INVALID) { 0x40 }
      const_attr_reader  :CKR_ENCRYPTED_DATA_INVALID
      
      const_set_lazy(:CKR_ENCRYPTED_DATA_LEN_RANGE) { 0x41 }
      const_attr_reader  :CKR_ENCRYPTED_DATA_LEN_RANGE
      
      const_set_lazy(:CKR_FUNCTION_CANCELED) { 0x50 }
      const_attr_reader  :CKR_FUNCTION_CANCELED
      
      const_set_lazy(:CKR_FUNCTION_NOT_PARALLEL) { 0x51 }
      const_attr_reader  :CKR_FUNCTION_NOT_PARALLEL
      
      # CKR_FUNCTION_NOT_SUPPORTED is new for v2.0
      const_set_lazy(:CKR_FUNCTION_NOT_SUPPORTED) { 0x54 }
      const_attr_reader  :CKR_FUNCTION_NOT_SUPPORTED
      
      const_set_lazy(:CKR_KEY_HANDLE_INVALID) { 0x60 }
      const_attr_reader  :CKR_KEY_HANDLE_INVALID
      
      # CKR_KEY_SENSITIVE was removed for v2.0
      const_set_lazy(:CKR_KEY_SIZE_RANGE) { 0x62 }
      const_attr_reader  :CKR_KEY_SIZE_RANGE
      
      const_set_lazy(:CKR_KEY_TYPE_INCONSISTENT) { 0x63 }
      const_attr_reader  :CKR_KEY_TYPE_INCONSISTENT
      
      # CKR_KEY_NOT_NEEDED, CKR_KEY_CHANGED, CKR_KEY_NEEDED,
      # CKR_KEY_INDIGESTIBLE, CKR_KEY_FUNCTION_NOT_PERMITTED,
      # CKR_KEY_NOT_WRAPPABLE, and CKR_KEY_UNEXTRACTABLE are new for
      # v2.0
      const_set_lazy(:CKR_KEY_NOT_NEEDED) { 0x64 }
      const_attr_reader  :CKR_KEY_NOT_NEEDED
      
      const_set_lazy(:CKR_KEY_CHANGED) { 0x65 }
      const_attr_reader  :CKR_KEY_CHANGED
      
      const_set_lazy(:CKR_KEY_NEEDED) { 0x66 }
      const_attr_reader  :CKR_KEY_NEEDED
      
      const_set_lazy(:CKR_KEY_INDIGESTIBLE) { 0x67 }
      const_attr_reader  :CKR_KEY_INDIGESTIBLE
      
      const_set_lazy(:CKR_KEY_FUNCTION_NOT_PERMITTED) { 0x68 }
      const_attr_reader  :CKR_KEY_FUNCTION_NOT_PERMITTED
      
      const_set_lazy(:CKR_KEY_NOT_WRAPPABLE) { 0x69 }
      const_attr_reader  :CKR_KEY_NOT_WRAPPABLE
      
      const_set_lazy(:CKR_KEY_UNEXTRACTABLE) { 0x6a }
      const_attr_reader  :CKR_KEY_UNEXTRACTABLE
      
      const_set_lazy(:CKR_MECHANISM_INVALID) { 0x70 }
      const_attr_reader  :CKR_MECHANISM_INVALID
      
      const_set_lazy(:CKR_MECHANISM_PARAM_INVALID) { 0x71 }
      const_attr_reader  :CKR_MECHANISM_PARAM_INVALID
      
      # CKR_OBJECT_CLASS_INCONSISTENT and CKR_OBJECT_CLASS_INVALID
      # were removed for v2.0
      const_set_lazy(:CKR_OBJECT_HANDLE_INVALID) { 0x82 }
      const_attr_reader  :CKR_OBJECT_HANDLE_INVALID
      
      const_set_lazy(:CKR_OPERATION_ACTIVE) { 0x90 }
      const_attr_reader  :CKR_OPERATION_ACTIVE
      
      const_set_lazy(:CKR_OPERATION_NOT_INITIALIZED) { 0x91 }
      const_attr_reader  :CKR_OPERATION_NOT_INITIALIZED
      
      const_set_lazy(:CKR_PIN_INCORRECT) { 0xa0 }
      const_attr_reader  :CKR_PIN_INCORRECT
      
      const_set_lazy(:CKR_PIN_INVALID) { 0xa1 }
      const_attr_reader  :CKR_PIN_INVALID
      
      const_set_lazy(:CKR_PIN_LEN_RANGE) { 0xa2 }
      const_attr_reader  :CKR_PIN_LEN_RANGE
      
      # CKR_PIN_EXPIRED and CKR_PIN_LOCKED are new for v2.0
      const_set_lazy(:CKR_PIN_EXPIRED) { 0xa3 }
      const_attr_reader  :CKR_PIN_EXPIRED
      
      const_set_lazy(:CKR_PIN_LOCKED) { 0xa4 }
      const_attr_reader  :CKR_PIN_LOCKED
      
      const_set_lazy(:CKR_SESSION_CLOSED) { 0xb0 }
      const_attr_reader  :CKR_SESSION_CLOSED
      
      const_set_lazy(:CKR_SESSION_COUNT) { 0xb1 }
      const_attr_reader  :CKR_SESSION_COUNT
      
      const_set_lazy(:CKR_SESSION_HANDLE_INVALID) { 0xb3 }
      const_attr_reader  :CKR_SESSION_HANDLE_INVALID
      
      const_set_lazy(:CKR_SESSION_PARALLEL_NOT_SUPPORTED) { 0xb4 }
      const_attr_reader  :CKR_SESSION_PARALLEL_NOT_SUPPORTED
      
      const_set_lazy(:CKR_SESSION_READ_ONLY) { 0xb5 }
      const_attr_reader  :CKR_SESSION_READ_ONLY
      
      const_set_lazy(:CKR_SESSION_EXISTS) { 0xb6 }
      const_attr_reader  :CKR_SESSION_EXISTS
      
      # CKR_SESSION_READ_ONLY_EXISTS and
      # CKR_SESSION_READ_WRITE_SO_EXISTS are new for v2.0
      const_set_lazy(:CKR_SESSION_READ_ONLY_EXISTS) { 0xb7 }
      const_attr_reader  :CKR_SESSION_READ_ONLY_EXISTS
      
      const_set_lazy(:CKR_SESSION_READ_WRITE_SO_EXISTS) { 0xb8 }
      const_attr_reader  :CKR_SESSION_READ_WRITE_SO_EXISTS
      
      const_set_lazy(:CKR_SIGNATURE_INVALID) { 0xc0 }
      const_attr_reader  :CKR_SIGNATURE_INVALID
      
      const_set_lazy(:CKR_SIGNATURE_LEN_RANGE) { 0xc1 }
      const_attr_reader  :CKR_SIGNATURE_LEN_RANGE
      
      const_set_lazy(:CKR_TEMPLATE_INCOMPLETE) { 0xd0 }
      const_attr_reader  :CKR_TEMPLATE_INCOMPLETE
      
      const_set_lazy(:CKR_TEMPLATE_INCONSISTENT) { 0xd1 }
      const_attr_reader  :CKR_TEMPLATE_INCONSISTENT
      
      const_set_lazy(:CKR_TOKEN_NOT_PRESENT) { 0xe0 }
      const_attr_reader  :CKR_TOKEN_NOT_PRESENT
      
      const_set_lazy(:CKR_TOKEN_NOT_RECOGNIZED) { 0xe1 }
      const_attr_reader  :CKR_TOKEN_NOT_RECOGNIZED
      
      const_set_lazy(:CKR_TOKEN_WRITE_PROTECTED) { 0xe2 }
      const_attr_reader  :CKR_TOKEN_WRITE_PROTECTED
      
      const_set_lazy(:CKR_UNWRAPPING_KEY_HANDLE_INVALID) { 0xf0 }
      const_attr_reader  :CKR_UNWRAPPING_KEY_HANDLE_INVALID
      
      const_set_lazy(:CKR_UNWRAPPING_KEY_SIZE_RANGE) { 0xf1 }
      const_attr_reader  :CKR_UNWRAPPING_KEY_SIZE_RANGE
      
      const_set_lazy(:CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT) { 0xf2 }
      const_attr_reader  :CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT
      
      const_set_lazy(:CKR_USER_ALREADY_LOGGED_IN) { 0x100 }
      const_attr_reader  :CKR_USER_ALREADY_LOGGED_IN
      
      const_set_lazy(:CKR_USER_NOT_LOGGED_IN) { 0x101 }
      const_attr_reader  :CKR_USER_NOT_LOGGED_IN
      
      const_set_lazy(:CKR_USER_PIN_NOT_INITIALIZED) { 0x102 }
      const_attr_reader  :CKR_USER_PIN_NOT_INITIALIZED
      
      const_set_lazy(:CKR_USER_TYPE_INVALID) { 0x103 }
      const_attr_reader  :CKR_USER_TYPE_INVALID
      
      # CKR_USER_ANOTHER_ALREADY_LOGGED_IN and CKR_USER_TOO_MANY_TYPES
      # are new to v2.01
      const_set_lazy(:CKR_USER_ANOTHER_ALREADY_LOGGED_IN) { 0x104 }
      const_attr_reader  :CKR_USER_ANOTHER_ALREADY_LOGGED_IN
      
      const_set_lazy(:CKR_USER_TOO_MANY_TYPES) { 0x105 }
      const_attr_reader  :CKR_USER_TOO_MANY_TYPES
      
      const_set_lazy(:CKR_WRAPPED_KEY_INVALID) { 0x110 }
      const_attr_reader  :CKR_WRAPPED_KEY_INVALID
      
      const_set_lazy(:CKR_WRAPPED_KEY_LEN_RANGE) { 0x112 }
      const_attr_reader  :CKR_WRAPPED_KEY_LEN_RANGE
      
      const_set_lazy(:CKR_WRAPPING_KEY_HANDLE_INVALID) { 0x113 }
      const_attr_reader  :CKR_WRAPPING_KEY_HANDLE_INVALID
      
      const_set_lazy(:CKR_WRAPPING_KEY_SIZE_RANGE) { 0x114 }
      const_attr_reader  :CKR_WRAPPING_KEY_SIZE_RANGE
      
      const_set_lazy(:CKR_WRAPPING_KEY_TYPE_INCONSISTENT) { 0x115 }
      const_attr_reader  :CKR_WRAPPING_KEY_TYPE_INCONSISTENT
      
      const_set_lazy(:CKR_RANDOM_SEED_NOT_SUPPORTED) { 0x120 }
      const_attr_reader  :CKR_RANDOM_SEED_NOT_SUPPORTED
      
      # These are new to v2.0
      const_set_lazy(:CKR_RANDOM_NO_RNG) { 0x121 }
      const_attr_reader  :CKR_RANDOM_NO_RNG
      
      # These are new to v2.11
      const_set_lazy(:CKR_DOMAIN_PARAMS_INVALID) { 0x130 }
      const_attr_reader  :CKR_DOMAIN_PARAMS_INVALID
      
      # These are new to v2.0
      const_set_lazy(:CKR_BUFFER_TOO_SMALL) { 0x150 }
      const_attr_reader  :CKR_BUFFER_TOO_SMALL
      
      const_set_lazy(:CKR_SAVED_STATE_INVALID) { 0x160 }
      const_attr_reader  :CKR_SAVED_STATE_INVALID
      
      const_set_lazy(:CKR_INFORMATION_SENSITIVE) { 0x170 }
      const_attr_reader  :CKR_INFORMATION_SENSITIVE
      
      const_set_lazy(:CKR_STATE_UNSAVEABLE) { 0x180 }
      const_attr_reader  :CKR_STATE_UNSAVEABLE
      
      # These are new to v2.01
      const_set_lazy(:CKR_CRYPTOKI_NOT_INITIALIZED) { 0x190 }
      const_attr_reader  :CKR_CRYPTOKI_NOT_INITIALIZED
      
      const_set_lazy(:CKR_CRYPTOKI_ALREADY_INITIALIZED) { 0x191 }
      const_attr_reader  :CKR_CRYPTOKI_ALREADY_INITIALIZED
      
      const_set_lazy(:CKR_MUTEX_BAD) { 0x1a0 }
      const_attr_reader  :CKR_MUTEX_BAD
      
      const_set_lazy(:CKR_MUTEX_NOT_LOCKED) { 0x1a1 }
      const_attr_reader  :CKR_MUTEX_NOT_LOCKED
      
      const_set_lazy(:CKR_VENDOR_DEFINED) { 0x80000000 }
      const_attr_reader  :CKR_VENDOR_DEFINED
      
      # flags: bit flags that provide capabilities of the slot
      # Bit Flag = Mask
      const_set_lazy(:CKF_LIBRARY_CANT_CREATE_OS_THREADS) { 0x1 }
      const_attr_reader  :CKF_LIBRARY_CANT_CREATE_OS_THREADS
      
      const_set_lazy(:CKF_OS_LOCKING_OK) { 0x2 }
      const_attr_reader  :CKF_OS_LOCKING_OK
      
      # CKF_DONT_BLOCK is for the function C_WaitForSlotEvent
      const_set_lazy(:CKF_DONT_BLOCK) { 1 }
      const_attr_reader  :CKF_DONT_BLOCK
      
      # The following MGFs are defined
      const_set_lazy(:CKG_MGF1_SHA1) { 0x1 }
      const_attr_reader  :CKG_MGF1_SHA1
      
      # The following encoding parameter sources are defined
      const_set_lazy(:CKZ_DATA_SPECIFIED) { 0x1 }
      const_attr_reader  :CKZ_DATA_SPECIFIED
      
      # The following PRFs are defined in PKCS #5 v2.0.
      const_set_lazy(:CKP_PKCS5_PBKD2_HMAC_SHA1) { 0x1 }
      const_attr_reader  :CKP_PKCS5_PBKD2_HMAC_SHA1
      
      # The following salt value sources are defined in PKCS #5 v2.0.
      const_set_lazy(:CKZ_SALT_SPECIFIED) { 0x1 }
      const_attr_reader  :CKZ_SALT_SPECIFIED
      
      # the following EC Key Derivation Functions are defined
      const_set_lazy(:CKD_NULL) { 0x1 }
      const_attr_reader  :CKD_NULL
      
      const_set_lazy(:CKD_SHA1_KDF) { 0x2 }
      const_attr_reader  :CKD_SHA1_KDF
      
      # the following X9.42 Diffie-Hellman Key Derivation Functions are defined
      const_set_lazy(:CKD_SHA1_KDF_ASN1) { 0x3 }
      const_attr_reader  :CKD_SHA1_KDF_ASN1
      
      const_set_lazy(:CKD_SHA1_KDF_CONCATENATE) { 0x4 }
      const_attr_reader  :CKD_SHA1_KDF_CONCATENATE
      
      # private NSS attribute (for DSA and DH private keys)
      const_set_lazy(:CKA_NETSCAPE_DB) { 0xd5a0db00 }
      const_attr_reader  :CKA_NETSCAPE_DB
      
      # base number of NSS private attributes
      const_set_lazy(:CKA_NETSCAPE_BASE) { 0x80000000 + 0x4e534350 }
      const_attr_reader  :CKA_NETSCAPE_BASE
      
      # object type for NSS trust
      const_set_lazy(:CKO_NETSCAPE_TRUST) { CKA_NETSCAPE_BASE + 3 }
      const_attr_reader  :CKO_NETSCAPE_TRUST
      
      # base number for NSS trust attributes
      const_set_lazy(:CKA_NETSCAPE_TRUST_BASE) { CKA_NETSCAPE_BASE + 0x2000 }
      const_attr_reader  :CKA_NETSCAPE_TRUST_BASE
      
      # attributes for NSS trust
      const_set_lazy(:CKA_NETSCAPE_TRUST_SERVER_AUTH) { CKA_NETSCAPE_TRUST_BASE + 8 }
      const_attr_reader  :CKA_NETSCAPE_TRUST_SERVER_AUTH
      
      const_set_lazy(:CKA_NETSCAPE_TRUST_CLIENT_AUTH) { CKA_NETSCAPE_TRUST_BASE + 9 }
      const_attr_reader  :CKA_NETSCAPE_TRUST_CLIENT_AUTH
      
      const_set_lazy(:CKA_NETSCAPE_TRUST_CODE_SIGNING) { CKA_NETSCAPE_TRUST_BASE + 10 }
      const_attr_reader  :CKA_NETSCAPE_TRUST_CODE_SIGNING
      
      const_set_lazy(:CKA_NETSCAPE_TRUST_EMAIL_PROTECTION) { CKA_NETSCAPE_TRUST_BASE + 11 }
      const_attr_reader  :CKA_NETSCAPE_TRUST_EMAIL_PROTECTION
      
      const_set_lazy(:CKA_NETSCAPE_CERT_SHA1_HASH) { CKA_NETSCAPE_TRUST_BASE + 100 }
      const_attr_reader  :CKA_NETSCAPE_CERT_SHA1_HASH
      
      const_set_lazy(:CKA_NETSCAPE_CERT_MD5_HASH) { CKA_NETSCAPE_TRUST_BASE + 101 }
      const_attr_reader  :CKA_NETSCAPE_CERT_MD5_HASH
      
      # trust values for each of the NSS trust attributes
      const_set_lazy(:CKT_NETSCAPE_TRUSTED) { CKA_NETSCAPE_BASE + 1 }
      const_attr_reader  :CKT_NETSCAPE_TRUSTED
      
      const_set_lazy(:CKT_NETSCAPE_TRUSTED_DELEGATOR) { CKA_NETSCAPE_BASE + 2 }
      const_attr_reader  :CKT_NETSCAPE_TRUSTED_DELEGATOR
      
      const_set_lazy(:CKT_NETSCAPE_UNTRUSTED) { CKA_NETSCAPE_BASE + 3 }
      const_attr_reader  :CKT_NETSCAPE_UNTRUSTED
      
      const_set_lazy(:CKT_NETSCAPE_MUST_VERIFY) { CKA_NETSCAPE_BASE + 4 }
      const_attr_reader  :CKT_NETSCAPE_MUST_VERIFY
      
      const_set_lazy(:CKT_NETSCAPE_TRUST_UNKNOWN) { CKA_NETSCAPE_BASE + 5 }
      const_attr_reader  :CKT_NETSCAPE_TRUST_UNKNOWN
      
      # default
      const_set_lazy(:CKT_NETSCAPE_VALID) { CKA_NETSCAPE_BASE + 10 }
      const_attr_reader  :CKT_NETSCAPE_VALID
      
      const_set_lazy(:CKT_NETSCAPE_VALID_DELEGATOR) { CKA_NETSCAPE_BASE + 11 }
      const_attr_reader  :CKT_NETSCAPE_VALID_DELEGATOR
    }
  end
  
end
