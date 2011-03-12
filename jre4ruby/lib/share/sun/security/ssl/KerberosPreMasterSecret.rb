require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module KerberosPreMasterSecretImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Javax::Net::Ssl
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
    }
  end
  
  # This is the Kerberos premaster secret in the Kerberos client key
  # exchange message (CLIENT --> SERVER); it holds the
  # Kerberos-encrypted pre-master secret. The secret is encrypted using the
  # Kerberos session key.  The padding and size of the resulting message
  # depends on the session key type, but the pre-master secret is
  # always exactly 48 bytes.
  class KerberosPreMasterSecret 
    include_class_members KerberosPreMasterSecretImports
    
    attr_accessor :protocol_version
    alias_method :attr_protocol_version, :protocol_version
    undef_method :protocol_version
    alias_method :attr_protocol_version=, :protocol_version=
    undef_method :protocol_version=
    
    # preMaster [0,1]
    attr_accessor :pre_master
    alias_method :attr_pre_master, :pre_master
    undef_method :pre_master
    alias_method :attr_pre_master=, :pre_master=
    undef_method :pre_master=
    
    # 48 bytes
    attr_accessor :encrypted
    alias_method :attr_encrypted, :encrypted
    undef_method :encrypted
    alias_method :attr_encrypted=, :encrypted=
    undef_method :encrypted=
    
    typesig { [ProtocolVersion, SecureRandom, EncryptionKey] }
    # Constructor used by client to generate premaster secret.
    # 
    # Client randomly creates a pre-master secret and encrypts it
    # using the Kerberos session key; only the server can decrypt
    # it, using the session key available in the service ticket.
    # 
    # @param protocolVersion used to set preMaster[0,1]
    # @param generator random number generator for generating premaster secret
    # @param sessionKey Kerberos session key for encrypting premaster secret
    def initialize(protocol_version, generator, session_key)
      @protocol_version = nil
      @pre_master = nil
      @encrypted = nil
      if ((session_key.get_etype).equal?(EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD))
        raise IOException.new("session keys with des3-cbc-hmac-sha1-kd encryption type " + "are not supported for TLS Kerberos cipher suites")
      end
      @protocol_version = protocol_version
      @pre_master = generate_pre_master(generator, protocol_version)
      # Encrypt premaster secret
      begin
        e_data = EncryptedData.new(session_key, @pre_master, KeyUsage::KU_UNKNOWN)
        @encrypted = e_data.get_bytes # not ASN.1 encoded.
      rescue KrbException => e
        raise SSLKeyException.new("Kerberos premaster secret error").init_cause(e)
      end
    end
    
    typesig { [ProtocolVersion, ProtocolVersion, SecureRandom, HandshakeInStream, EncryptionKey] }
    # Constructor used by server to decrypt encrypted premaster secret.
    # The protocol version in preMaster[0,1] must match either currentVersion
    # or clientVersion, otherwise, the premaster secret is set to
    # a random one to foil possible attack.
    # 
    # @param currentVersion version of protocol being used
    # @param clientVersion version requested by client
    # @param generator random number generator used to generate
    #        bogus premaster secret if premaster secret verification fails
    # @param input input stream from which to read the encrypted
    #        premaster secret
    # @param sessionKey Kerberos session key to be used for decryption
    def initialize(current_version, client_version, generator, input, session_key)
      @protocol_version = nil
      @pre_master = nil
      @encrypted = nil
      # Extract encrypted premaster secret from message
      @encrypted = input.get_bytes16
      if (!(HandshakeMessage.attr_debug).nil? && Debug.is_on("handshake"))
        if (!(@encrypted).nil?)
          Debug.println(System.out, "encrypted premaster secret", @encrypted)
        end
      end
      if ((session_key.get_etype).equal?(EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD))
        raise IOException.new("session keys with des3-cbc-hmac-sha1-kd encryption type " + "are not supported for TLS Kerberos cipher suites")
      end
      # Decrypt premaster secret
      begin
        # optional kvno
        data = EncryptedData.new(session_key.get_etype, nil, @encrypted)
        temp = data.decrypt(session_key, KeyUsage::KU_UNKNOWN)
        if (!(HandshakeMessage.attr_debug).nil? && Debug.is_on("handshake"))
          if (!(@encrypted).nil?)
            Debug.println(System.out, "decrypted premaster secret", temp)
          end
        end
        # Reset data stream after decryption, remove redundant bytes
        @pre_master = data.reset(temp, false)
        @protocol_version = ProtocolVersion.value_of(@pre_master[0], @pre_master[1])
        if (!(HandshakeMessage.attr_debug).nil? && Debug.is_on("handshake"))
          System.out.println("Kerberos PreMasterSecret version: " + RJava.cast_to_string(@protocol_version))
        end
      rescue JavaException => e
        # catch exception & process below
        @pre_master = nil
        @protocol_version = current_version
      end
      # check if the premaster secret version is ok
      # the specification says that it must be the maximum version supported
      # by the client from its ClientHello message. However, many
      # implementations send the negotiated version, so accept both
      # NOTE that we may be comparing two unsupported version numbers in
      # the second case, which is why we cannot use object references
      # equality in this special case
      version_mismatch = (!(@protocol_version).equal?(current_version)) && (!(@protocol_version.attr_v).equal?(client_version.attr_v))
      # Bogus decrypted ClientKeyExchange? If so, conjure a
      # a random preMaster secret that will fail later during
      # Finished message processing. This is a countermeasure against
      # the "interactive RSA PKCS#1 encryption envelop attack" reported
      # in June 1998. Preserving the executation path will
      # mitigate timing attacks and force consistent error handling
      # that will prevent an attacking client from differentiating
      # different kinds of decrypted ClientKeyExchange bogosities.
      if (((@pre_master).nil?) || (!(@pre_master.attr_length).equal?(48)) || version_mismatch)
        if (!(HandshakeMessage.attr_debug).nil? && Debug.is_on("handshake"))
          System.out.println("Kerberos PreMasterSecret error, " + "generating random secret")
          if (!(@pre_master).nil?)
            Debug.println(System.out, "Invalid secret", @pre_master)
          end
        end
        @pre_master = generate_pre_master(generator, current_version)
        @protocol_version = current_version
      end
    end
    
    typesig { [ProtocolVersion, SecureRandom] }
    # Used by server to generate premaster secret in case of
    # problem decoding ticket.
    # 
    # @param protocolVersion used for preMaster[0,1]
    # @param generator random number generator to use for generating secret.
    def initialize(protocol_version, generator)
      @protocol_version = nil
      @pre_master = nil
      @encrypted = nil
      @protocol_version = protocol_version
      @pre_master = generate_pre_master(generator, protocol_version)
    end
    
    class_module.module_eval {
      typesig { [SecureRandom, ProtocolVersion] }
      def generate_pre_master(rand, ver)
        pm = Array.typed(::Java::Byte).new(48) { 0 }
        rand.next_bytes(pm)
        pm[0] = ver.attr_major
        pm[1] = ver.attr_minor
        return pm
      end
    }
    
    typesig { [] }
    # Clone not needed; package internal use only
    def get_unencrypted
      return @pre_master
    end
    
    typesig { [] }
    # Clone not needed; package internal use only
    def get_encrypted
      return @encrypted
    end
    
    private
    alias_method :initialize__kerberos_pre_master_secret, :initialize
  end
  
end
