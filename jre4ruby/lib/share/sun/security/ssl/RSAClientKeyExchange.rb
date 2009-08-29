require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RSAClientKeyExchangeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include ::Javax::Net::Ssl
      include_const ::Sun::Security::Internal::Spec, :TlsRsaPremasterSecretParameterSpec
    }
  end
  
  # This is the client key exchange message (CLIENT --> SERVER) used with
  # all RSA key exchanges; it holds the RSA-encrypted pre-master secret.
  # 
  # The message is encrypted using PKCS #1 block type 02 encryption with the
  # server's public key.  The padding and resulting message size is a function
  # of this server's public key modulus size, but the pre-master secret is
  # always exactly 48 bytes.
  class RSAClientKeyExchange < RSAClientKeyExchangeImports.const_get :HandshakeMessage
    include_class_members RSAClientKeyExchangeImports
    
    class_module.module_eval {
      # The TLS spec says that the version in the RSA premaster secret must
      # be the maximum version supported by the client (i.e. the version it
      # requested in its client hello version). However, we (and other
      # implementations) used to send the active negotiated version. The
      # system property below allows to toggle the behavior.
      # 
      # Default is "false" (old behavior) for compatibility reasons. This
      # will be changed in the future.
      const_set_lazy(:PROP_NAME) { "com.sun.net.ssl.rsaPreMasterSecretFix" }
      const_attr_reader  :PROP_NAME
      
      const_set_lazy(:RsaPreMasterSecretFix) { Debug.get_boolean_property(PROP_NAME, false) }
      const_attr_reader  :RsaPreMasterSecretFix
    }
    
    typesig { [] }
    def message_type
      return self.attr_ht_client_key_exchange
    end
    
    # The following field values were encrypted with the server's public
    # key (or temp key from server key exchange msg) and are presented
    # here in DECRYPTED form.
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
    
    attr_accessor :encrypted
    alias_method :attr_encrypted, :encrypted
    undef_method :encrypted
    alias_method :attr_encrypted=, :encrypted=
    undef_method :encrypted=
    
    typesig { [ProtocolVersion, ProtocolVersion, SecureRandom, PublicKey] }
    # same size as public modulus
    # 
    # Client randomly creates a pre-master secret and encrypts it
    # using the server's RSA public key; only the server can decrypt
    # it, using its RSA private key.  Result is the same size as the
    # server's public key, and uses PKCS #1 block format 02.
    def initialize(protocol_version, max_version, generator, public_key)
      @protocol_version = nil
      @pre_master = nil
      @encrypted = nil
      super()
      if (((public_key.get_algorithm == "RSA")).equal?(false))
        raise SSLKeyException.new("Public key not of type RSA")
      end
      @protocol_version = protocol_version
      major = 0
      minor = 0
      if (RsaPreMasterSecretFix)
        major = max_version.attr_major
        minor = max_version.attr_minor
      else
        major = protocol_version.attr_major
        minor = protocol_version.attr_minor
      end
      begin
        kg = JsseJce.get_key_generator("SunTlsRsaPremasterSecret")
        kg.init(TlsRsaPremasterSecretParameterSpec.new(major, minor))
        @pre_master = kg.generate_key
        cipher = JsseJce.get_cipher(JsseJce::CIPHER_RSA_PKCS1)
        cipher.init(Cipher::WRAP_MODE, public_key, generator)
        @encrypted = cipher.wrap(@pre_master)
      rescue GeneralSecurityException => e
        raise SSLKeyException.new("RSA premaster secret error").init_cause(e)
      end
    end
    
    typesig { [ProtocolVersion, HandshakeInStream, ::Java::Int, PrivateKey] }
    # Server gets the PKCS #1 (block format 02) data, decrypts
    # it with its private key.
    def initialize(current_version, input, message_size, private_key)
      @protocol_version = nil
      @pre_master = nil
      @encrypted = nil
      super()
      if (((private_key.get_algorithm == "RSA")).equal?(false))
        raise SSLKeyException.new("Private key not of type RSA")
      end
      @protocol_version = current_version
      if (current_version.attr_v >= ProtocolVersion::TLS10.attr_v)
        @encrypted = input.get_bytes16
      else
        @encrypted = Array.typed(::Java::Byte).new(message_size) { 0 }
        if (!(input.read(@encrypted)).equal?(message_size))
          raise SSLProtocolException.new("SSL: read PreMasterSecret: short read")
        end
      end
      begin
        cipher = JsseJce.get_cipher(JsseJce::CIPHER_RSA_PKCS1)
        cipher.init(Cipher::UNWRAP_MODE, private_key)
        @pre_master = cipher.unwrap(@encrypted, "TlsRsaPremasterSecret", Cipher::SECRET_KEY)
      rescue JavaException => e
        # Bogus decrypted ClientKeyExchange? If so, conjure a
        # a random preMaster secret that will fail later during
        # Finished message processing. This is a countermeasure against
        # the "interactive RSA PKCS#1 encryption envelop attack" reported
        # in June 1998. Preserving the executation path will
        # mitigate timing attacks and force consistent error handling
        # that will prevent an attacking client from differentiating
        # different kinds of decrypted ClientKeyExchange bogosities.
        if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
          System.out.println("Error decrypting premaster secret:")
          e.print_stack_trace(System.out)
          System.out.println("Generating random secret")
        end
        @pre_master = generate_dummy_secret(current_version)
      end
    end
    
    class_module.module_eval {
      typesig { [ProtocolVersion] }
      # generate a premaster secret with the specified version number
      def generate_dummy_secret(version)
        begin
          kg = JsseJce.get_key_generator("SunTlsRsaPremasterSecret")
          kg.init(TlsRsaPremasterSecretParameterSpec.new(version.attr_major, version.attr_minor))
          return kg.generate_key
        rescue GeneralSecurityException => e
          raise RuntimeException.new("Could not generate dummy secret", e)
        end
      end
    }
    
    typesig { [] }
    def message_length
      if (@protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v)
        return @encrypted.attr_length + 2
      else
        return @encrypted.attr_length
      end
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      if (@protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v)
        s.put_bytes16(@encrypted)
      else
        s.write(@encrypted)
      end
    end
    
    typesig { [PrintStream] }
    def print(s)
      s.println("*** ClientKeyExchange, RSA PreMasterSecret, " + RJava.cast_to_string(@protocol_version))
    end
    
    private
    alias_method :initialize__rsaclient_key_exchange, :initialize
  end
  
end
