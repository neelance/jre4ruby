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
  module ClientHandshakerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Util
      include_const ::Java::Security::Interfaces, :ECPublicKey
      include_const ::Java::Security::Spec, :ECParameterSpec
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include ::Javax::Net::Ssl
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include_const ::Sun::Security::Jgss::Krb5, :Krb5Util
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Com::Sun::Net::Ssl::Internal::Ssl, :X509ExtendedTrustManager
      include ::Sun::Security::Ssl::HandshakeMessage
      include ::Sun::Security::Ssl::CipherSuite
    }
  end
  
  # ClientHandshaker does the protocol handshaking from the point
  # of view of a client.  It is driven asychronously by handshake messages
  # as delivered by the parent Handshaker class, and also uses
  # common functionality (e.g. key generation) that is provided there.
  # 
  # @author David Brownell
  class ClientHandshaker < ClientHandshakerImports.const_get :Handshaker
    include_class_members ClientHandshakerImports
    
    # the server's public key from its certificate.
    attr_accessor :server_key
    alias_method :attr_server_key, :server_key
    undef_method :server_key
    alias_method :attr_server_key=, :server_key=
    undef_method :server_key=
    
    # the server's ephemeral public key from the server key exchange message
    # for ECDHE/ECDH_anon and RSA_EXPORT.
    attr_accessor :ephemeral_server_key
    alias_method :attr_ephemeral_server_key, :ephemeral_server_key
    undef_method :ephemeral_server_key
    alias_method :attr_ephemeral_server_key=, :ephemeral_server_key=
    undef_method :ephemeral_server_key=
    
    # server's ephemeral public value for DHE/DH_anon key exchanges
    attr_accessor :server_dh
    alias_method :attr_server_dh, :server_dh
    undef_method :server_dh
    alias_method :attr_server_dh=, :server_dh=
    undef_method :server_dh=
    
    attr_accessor :dh
    alias_method :attr_dh, :dh
    undef_method :dh
    alias_method :attr_dh=, :dh=
    undef_method :dh=
    
    attr_accessor :ecdh
    alias_method :attr_ecdh, :ecdh
    undef_method :ecdh
    alias_method :attr_ecdh=, :ecdh=
    undef_method :ecdh=
    
    attr_accessor :cert_request
    alias_method :attr_cert_request, :cert_request
    undef_method :cert_request
    alias_method :attr_cert_request=, :cert_request=
    undef_method :cert_request=
    
    attr_accessor :server_key_exchange_received
    alias_method :attr_server_key_exchange_received, :server_key_exchange_received
    undef_method :server_key_exchange_received
    alias_method :attr_server_key_exchange_received=, :server_key_exchange_received=
    undef_method :server_key_exchange_received=
    
    # The RSA PreMasterSecret needs to know the version of
    # ClientHello that was used on this handshake.  This represents
    # the "max version" this client is supporting.  In the
    # case of an initial handshake, it's the max version enabled,
    # but in the case of a resumption attempt, it's the version
    # of the session we're trying to resume.
    attr_accessor :max_protocol_version
    alias_method :attr_max_protocol_version, :max_protocol_version
    undef_method :max_protocol_version
    alias_method :attr_max_protocol_version=, :max_protocol_version=
    undef_method :max_protocol_version=
    
    typesig { [SSLSocketImpl, SSLContextImpl, ProtocolList] }
    # Constructors
    def initialize(socket, context, enabled_protocols)
      @server_key = nil
      @ephemeral_server_key = nil
      @server_dh = nil
      @dh = nil
      @ecdh = nil
      @cert_request = nil
      @server_key_exchange_received = false
      @max_protocol_version = nil
      super(socket, context, enabled_protocols, true, true)
    end
    
    typesig { [SSLEngineImpl, SSLContextImpl, ProtocolList] }
    def initialize(engine, context, enabled_protocols)
      @server_key = nil
      @ephemeral_server_key = nil
      @server_dh = nil
      @dh = nil
      @ecdh = nil
      @cert_request = nil
      @server_key_exchange_received = false
      @max_protocol_version = nil
      super(engine, context, enabled_protocols, true, true)
    end
    
    typesig { [::Java::Byte, ::Java::Int] }
    # This routine handles all the client side handshake messages, one at
    # a time.  Given the message type (and in some cases the pending cipher
    # spec) it parses the type-specific message.  Then it calls a function
    # that handles that specific message.
    # 
    # It updates the state machine (need to verify it) as each message
    # is processed, and writes responses as needed using the connection
    # in the constructor.
    def process_message(type, message_len)
      if (self.attr_state > type && (!(type).equal?(HandshakeMessage.attr_ht_hello_request) && !(self.attr_state).equal?(HandshakeMessage.attr_ht_client_hello)))
        raise SSLProtocolException.new("Handshake message sequence violation, " + (type).to_s)
      end
      case (type)
      when HandshakeMessage.attr_ht_hello_request
        self.server_hello_request(HelloRequest.new(self.attr_input))
      when HandshakeMessage.attr_ht_server_hello
        self.server_hello(ServerHello.new(self.attr_input, message_len))
      when HandshakeMessage.attr_ht_certificate
        if ((self.attr_key_exchange).equal?(K_DH_ANON) || (self.attr_key_exchange).equal?(K_ECDH_ANON) || (self.attr_key_exchange).equal?(K_KRB5) || (self.attr_key_exchange).equal?(K_KRB5_EXPORT))
          fatal_se(Alerts.attr_alert_unexpected_message, "unexpected server cert chain")
          # NOTREACHED
        end
        self.server_certificate(CertificateMsg.new(self.attr_input))
        @server_key = self.attr_session.get_peer_certificates[0].get_public_key
      when HandshakeMessage.attr_ht_server_key_exchange
        @server_key_exchange_received = true
        case (self.attr_key_exchange)
        when K_RSA, K_RSA_EXPORT
          begin
            self.server_key_exchange(RSA_ServerKeyExchange.new(self.attr_input))
          rescue GeneralSecurityException => e
            throw_sslexception("Server key", e)
          end
        when K_DH_ANON
          self.server_key_exchange(DH_ServerKeyExchange.new(self.attr_input))
        when K_DHE_DSS, K_DHE_RSA
          begin
            self.server_key_exchange(DH_ServerKeyExchange.new(self.attr_input, @server_key, self.attr_clnt_random.attr_random_bytes, self.attr_svr_random.attr_random_bytes, message_len))
          rescue GeneralSecurityException => e
            throw_sslexception("Server key", e)
          end
        when K_ECDHE_ECDSA, K_ECDHE_RSA, K_ECDH_ANON
          begin
            self.server_key_exchange(ECDH_ServerKeyExchange.new(self.attr_input, @server_key, self.attr_clnt_random.attr_random_bytes, self.attr_svr_random.attr_random_bytes))
          rescue GeneralSecurityException => e
            throw_sslexception("Server key", e)
          end
        when K_ECDH_ECDSA, K_ECDH_RSA
          raise SSLProtocolException.new("Protocol violation: server sent" + " a server key exchange message for key exchange " + (self.attr_key_exchange).to_s)
        when K_KRB5, K_KRB5_EXPORT
          raise SSLProtocolException.new("unexpected receipt of server key exchange algorithm")
        else
          raise SSLProtocolException.new("unsupported key exchange algorithm = " + (self.attr_key_exchange).to_s)
        end
      when HandshakeMessage.attr_ht_certificate_request
        # save for later, it's handled by serverHelloDone
        if (((self.attr_key_exchange).equal?(K_DH_ANON)) || ((self.attr_key_exchange).equal?(K_ECDH_ANON)))
          raise SSLHandshakeException.new("Client authentication requested for " + "anonymous cipher suite.")
        else
          if ((self.attr_key_exchange).equal?(K_KRB5) || (self.attr_key_exchange).equal?(K_KRB5_EXPORT))
            raise SSLHandshakeException.new("Client certificate requested for " + "kerberos cipher suite.")
          end
        end
        @cert_request = CertificateRequest.new(self.attr_input)
        if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
          @cert_request.print(System.out)
        end
      when HandshakeMessage.attr_ht_server_hello_done
        self.server_hello_done(ServerHelloDone.new(self.attr_input))
      when HandshakeMessage.attr_ht_finished
        self.server_finished(Finished.new(self.attr_protocol_version, self.attr_input))
      else
        raise SSLProtocolException.new("Illegal client handshake msg, " + (type).to_s)
      end
      # Move state machine forward if the message handling
      # code didn't already do so
      if (self.attr_state < type)
        self.attr_state = type
      end
    end
    
    typesig { [HelloRequest] }
    # Used by the server to kickstart negotiations -- this requests a
    # "client hello" to renegotiate current cipher specs (e.g. maybe lots
    # of data has been encrypted with the same keys, or the server needs
    # the client to present a certificate).
    def server_hello_request(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      # Could be (e.g. at connection setup) that we already
      # sent the "client hello" but the server's not seen it.
      if (self.attr_state < HandshakeMessage.attr_ht_client_hello)
        kickstart
      end
    end
    
    typesig { [ServerHello] }
    # Server chooses session parameters given options created by the
    # client -- basically, cipher options, session id, and someday a
    # set of compression options.
    # 
    # There are two branches of the state machine, decided by the
    # details of this message.  One is the "fast" handshake, where we
    # can resume the pre-existing session we asked resume.  The other
    # is a more expensive "full" handshake, with key exchange and
    # probably authentication getting done.
    def server_hello(mesg)
      @server_key_exchange_received = false
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      # check if the server selected protocol version is OK for us
      mesg_version = mesg.attr_protocol_version
      if ((self.attr_enabled_protocols.contains(mesg_version)).equal?(false))
        raise SSLHandshakeException.new("Server chose unsupported or disabled protocol: " + (mesg_version).to_s)
      end
      # Set protocolVersion and propagate to SSLSocket and the
      # Handshake streams
      set_version(mesg_version)
      # Save server nonce, we always use it to compute connection
      # keys and it's also used to create the master secret if we're
      # creating a new session (i.e. in the full handshake).
      self.attr_svr_random = mesg.attr_svr_random
      if ((is_enabled(mesg.attr_cipher_suite)).equal?(false))
        fatal_se(Alerts.attr_alert_illegal_parameter, "Server selected disabled ciphersuite " + (self.attr_cipher_suite).to_s)
      end
      set_cipher_suite(mesg.attr_cipher_suite)
      if (!(mesg.attr_compression_method).equal?(0))
        fatal_se(Alerts.attr_alert_illegal_parameter, "compression type not supported, " + (mesg.attr_compression_method).to_s)
        # NOTREACHED
      end
      # so far so good, let's look at the session
      if (!(self.attr_session).nil?)
        # we tried to resume, let's see what the server decided
        if ((self.attr_session.get_session_id == mesg.attr_session_id))
          # server resumed the session, let's make sure everything
          # checks out
          # Verify that the session ciphers are unchanged.
          session_suite = self.attr_session.get_suite
          if (!(self.attr_cipher_suite).equal?(session_suite))
            raise SSLProtocolException.new("Server returned wrong cipher suite for session")
          end
          # verify protocol version match
          session_version = self.attr_session.get_protocol_version
          if (!(self.attr_protocol_version).equal?(session_version))
            raise SSLProtocolException.new("Server resumed session with wrong protocol version")
          end
          # validate subject identity
          if ((session_suite.attr_key_exchange).equal?(K_KRB5) || (session_suite.attr_key_exchange).equal?(K_KRB5_EXPORT))
            local_principal = self.attr_session.get_local_principal
            subject = nil
            begin
              subject = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members ClientHandshaker
                include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  return Krb5Util.get_subject(GSSUtil::CALLER_SSL_CLIENT, get_acc_se)
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            rescue PrivilegedActionException => e
              subject = nil
              if (!(self.attr_debug).nil? && Debug.is_on("session"))
                System.out.println("Attempt to obtain" + " subject failed!")
              end
            end
            if (!(subject).nil?)
              principals = subject.get_principals(KerberosPrincipal.class)
              if (!principals.contains(local_principal))
                raise SSLProtocolException.new("Server resumed" + " session with wrong subject identity")
              else
                if (!(self.attr_debug).nil? && Debug.is_on("session"))
                  System.out.println("Subject identity is same")
                end
              end
            else
              if (!(self.attr_debug).nil? && Debug.is_on("session"))
                System.out.println("Kerberos credentials are not" + " present in the current Subject; check if " + " javax.security.auth.useSubjectAsCreds" + " system property has been set to false")
              end
              raise SSLProtocolException.new("Server resumed session with no subject")
            end
          end
          # looks fine; resume it, and update the state machine.
          self.attr_resuming_session = true
          self.attr_state = HandshakeMessage.attr_ht_finished - 1
          calculate_connection_keys(self.attr_session.get_master_secret)
          if (!(self.attr_debug).nil? && Debug.is_on("session"))
            System.out.println("%% Server resumed " + (self.attr_session).to_s)
          end
          return
        else
          # we wanted to resume, but the server refused
          self.attr_session = nil
          if (!self.attr_enable_new_session)
            raise SSLException.new("New session creation is disabled")
          end
        end
      end
      # check extensions
      mesg.attr_extensions.list.each do |ext|
        type = ext.attr_type
        if ((!(type).equal?(ExtensionType::EXT_ELLIPTIC_CURVES)) && (!(type).equal?(ExtensionType::EXT_EC_POINT_FORMATS)))
          fatal_se(Alerts.attr_alert_unsupported_extension, "Server sent an unsupported extension: " + (type).to_s)
        end
      end
      # Create a new session, we need to do the full handshake
      self.attr_session = SSLSessionImpl.new(self.attr_protocol_version, self.attr_cipher_suite, mesg.attr_session_id, get_host_se, get_port_se)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        System.out.println("** " + (self.attr_cipher_suite).to_s)
      end
    end
    
    typesig { [RSA_ServerKeyExchange] }
    # Server's own key was either a signing-only key, or was too
    # large for export rules ... this message holds an ephemeral
    # RSA key to use for key exchange.
    def server_key_exchange(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      if (!mesg.verify(@server_key, self.attr_clnt_random, self.attr_svr_random))
        fatal_se(Alerts.attr_alert_handshake_failure, "server key exchange invalid")
        # NOTREACHED
      end
      @ephemeral_server_key = mesg.get_public_key
    end
    
    typesig { [DH_ServerKeyExchange] }
    # Diffie-Hellman key exchange.  We save the server public key and
    # our own D-H algorithm object so we can defer key calculations
    # until after we've sent the client key exchange message (which
    # gives client and server some useful parallelism).
    def server_key_exchange(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      @dh = DHCrypt.new(mesg.get_modulus, mesg.get_base, self.attr_ssl_context.get_secure_random)
      @server_dh = mesg.get_server_public_key
    end
    
    typesig { [ECDH_ServerKeyExchange] }
    def server_key_exchange(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      key = mesg.get_public_key
      @ecdh = ECDHCrypt.new(key.get_params, self.attr_ssl_context.get_secure_random)
      @ephemeral_server_key = key
    end
    
    typesig { [ServerHelloDone] }
    # The server's "Hello Done" message is the client's sign that
    # it's time to do all the hard work.
    def server_hello_done(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      # Always make sure the input has been digested before we
      # start emitting data, to ensure the hashes are correctly
      # computed for the Finished and CertificateVerify messages
      # which we send (here).
      self.attr_input.digest_now
      # FIRST ... if requested, send an appropriate Certificate chain
      # to authenticate the client, and remember the associated private
      # key to sign the CertificateVerify message.
      signing_key = nil
      if (!(@cert_request).nil?)
        km = self.attr_ssl_context.get_x509key_manager
        keytypes_tmp = ArrayList.new(4)
        i = 0
        while i < @cert_request.attr_types.attr_length
          type_name = nil
          case (@cert_request.attr_types[i])
          # Fixed DH/ECDH client authentication not supported
          # Any other values (currently not used in TLS)
          when CertificateRequest.attr_cct_rsa_sign
            type_name = "RSA"
          when CertificateRequest.attr_cct_dss_sign
            type_name = "DSA"
          when CertificateRequest.attr_cct_ecdsa_sign
            # ignore if we do not have EC crypto available
            type_name = (JsseJce.is_ec_available ? "EC" : nil).to_s
          when CertificateRequest.attr_cct_rsa_fixed_dh, CertificateRequest.attr_cct_dss_fixed_dh, CertificateRequest.attr_cct_rsa_fixed_ecdh, CertificateRequest.attr_cct_ecdsa_fixed_ecdh, CertificateRequest.attr_cct_rsa_ephemeral_dh, CertificateRequest.attr_cct_dss_ephemeral_dh
            type_name = (nil).to_s
          else
            type_name = (nil).to_s
          end
          if ((!(type_name).nil?) && (!keytypes_tmp.contains(type_name)))
            keytypes_tmp.add(type_name)
          end
          ((i += 1) - 1)
        end
        alias_ = nil
        keytypes_tmp_size = keytypes_tmp.size
        if (!(keytypes_tmp_size).equal?(0))
          keytypes = keytypes_tmp.to_array(Array.typed(String).new(keytypes_tmp_size) { nil })
          if (!(self.attr_conn).nil?)
            alias_ = (km.choose_client_alias(keytypes, @cert_request.get_authorities, self.attr_conn)).to_s
          else
            alias_ = (km.choose_engine_client_alias(keytypes, @cert_request.get_authorities, self.attr_engine)).to_s
          end
        end
        m1 = nil
        if (!(alias_).nil?)
          certs = km.get_certificate_chain(alias_)
          if ((!(certs).nil?) && (!(certs.attr_length).equal?(0)))
            public_key = certs[0].get_public_key
            # for EC, make sure we use a supported named curve
            if (public_key.is_a?(ECPublicKey))
              params = (public_key).get_params
              index = SupportedEllipticCurvesExtension.get_curve_index(params)
              if (!SupportedEllipticCurvesExtension.is_supported(index))
                public_key = nil
              end
            end
            if (!(public_key).nil?)
              m1 = CertificateMsg.new(certs)
              signing_key = km.get_private_key(alias_)
              self.attr_session.set_local_private_key(signing_key)
              self.attr_session.set_local_certificates(certs)
            end
          end
        end
        if ((m1).nil?)
          # No appropriate cert was found ... report this to the
          # server.  For SSLv3, send the no_certificate alert;
          # TLS uses an empty cert chain instead.
          if (self.attr_protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v)
            m1 = CertificateMsg.new(Array.typed(X509Certificate).new(0) { nil })
          else
            warning_se(Alerts.attr_alert_no_certificate)
          end
        end
        # At last ... send any client certificate chain.
        if (!(m1).nil?)
          if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
            m1.print(System.out)
          end
          m1.write(self.attr_output)
        end
      end
      # SECOND ... send the client key exchange message.  The
      # procedure used is a function of the cipher suite selected;
      # one is always needed.
      m2 = nil
      case (self.attr_key_exchange)
      when K_RSA, K_RSA_EXPORT
        # For RSA key exchange, we randomly generate a new
        # pre-master secret and encrypt it with the server's
        # public key.  Then we save that pre-master secret
        # so that we can calculate the keying data later;
        # it's a performance speedup not to do that until
        # the client's waiting for the server response, but
        # more of a speedup for the D-H case.
        key = ((self.attr_key_exchange).equal?(K_RSA)) ? @server_key : @ephemeral_server_key
        m2 = RSAClientKeyExchange.new(self.attr_protocol_version, @max_protocol_version, self.attr_ssl_context.get_secure_random, key)
      when K_DH_RSA, K_DH_DSS
        # For DH Key exchange, we only need to make sure the server
        # knows our public key, so we calculate the same pre-master
        # secret.
        # 
        # For certs that had DH keys in them, we send an empty
        # handshake message (no key) ... we flag this case by
        # passing a null "dhPublic" value.
        # 
        # Otherwise we send ephemeral DH keys, unsigned.
        # 
        # if (useDH_RSA || useDH_DSS)
        m2 = DHClientKeyExchange.new
      when K_DHE_RSA, K_DHE_DSS, K_DH_ANON
        if ((@dh).nil?)
          raise SSLProtocolException.new("Server did not send a DH Server Key Exchange message")
        end
        m2 = DHClientKeyExchange.new(@dh.get_public_key)
      when K_ECDHE_RSA, K_ECDHE_ECDSA, K_ECDH_ANON
        if ((@ecdh).nil?)
          raise SSLProtocolException.new("Server did not send a ECDH Server Key Exchange message")
        end
        m2 = ECDHClientKeyExchange.new(@ecdh.get_public_key)
      when K_ECDH_RSA, K_ECDH_ECDSA
        if ((@server_key).nil?)
          raise SSLProtocolException.new("Server did not send certificate message")
        end
        if ((@server_key.is_a?(ECPublicKey)).equal?(false))
          raise SSLProtocolException.new("Server certificate does not include an EC key")
        end
        params = (@server_key).get_params
        @ecdh = ECDHCrypt.new(params, self.attr_ssl_context.get_secure_random)
        m2 = ECDHClientKeyExchange.new(@ecdh.get_public_key)
      when K_KRB5, K_KRB5_EXPORT
        hostname = get_host_se
        if ((hostname).nil?)
          raise IOException.new("Hostname is required" + " to use Kerberos cipher suites")
        end
        kerberos_msg = KerberosClientKeyExchange.new(hostname, is_loopback_se, get_acc_se, self.attr_protocol_version, self.attr_ssl_context.get_secure_random)
        # Record the principals involved in exchange
        self.attr_session.set_peer_principal(kerberos_msg.get_peer_principal)
        self.attr_session.set_local_principal(kerberos_msg.get_local_principal)
        m2 = kerberos_msg
      else
        # somethings very wrong
        raise RuntimeException.new("Unsupported key exchange: " + (self.attr_key_exchange).to_s)
      end
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        m2.print(System.out)
      end
      m2.write(self.attr_output)
      # THIRD, send a "change_cipher_spec" record followed by the
      # "Finished" message.  We flush the messages we've queued up, to
      # get concurrency between client and server.  The concurrency is
      # useful as we calculate the master secret, which is needed both
      # to compute the "Finished" message, and to compute the keys used
      # to protect all records following the change_cipher_spec.
      self.attr_output.do_hashes
      self.attr_output.flush
      # We deferred calculating the master secret and this connection's
      # keying data; we do it now.  Deferring this calculation is good
      # from a performance point of view, since it lets us do it during
      # some time that network delays and the server's own calculations
      # would otherwise cause to be "dead" in the critical path.
      pre_master_secret = nil
      case (self.attr_key_exchange)
      when K_RSA, K_RSA_EXPORT
        pre_master_secret = (m2).attr_pre_master
      when K_KRB5, K_KRB5_EXPORT
        secret_bytes = (m2).get_pre_master_secret.get_unencrypted
        pre_master_secret = SecretKeySpec.new(secret_bytes, "TlsPremasterSecret")
      when K_DHE_RSA, K_DHE_DSS, K_DH_ANON
        pre_master_secret = @dh.get_agreed_secret(@server_dh)
      when K_ECDHE_RSA, K_ECDHE_ECDSA, K_ECDH_ANON
        pre_master_secret = @ecdh.get_agreed_secret(@ephemeral_server_key)
      when K_ECDH_RSA, K_ECDH_ECDSA
        pre_master_secret = @ecdh.get_agreed_secret(@server_key)
      else
        raise IOException.new("Internal error: unknown key exchange " + (self.attr_key_exchange).to_s)
      end
      calculate_keys(pre_master_secret, nil)
      # FOURTH, if we sent a Certificate, we need to send a signed
      # CertificateVerify (unless the key in the client's certificate
      # was a Diffie-Hellman key).).
      # 
      # This uses a hash of the previous handshake messages ... either
      # a nonfinal one (if the particular implementation supports it)
      # or else using the third element in the arrays of hashes being
      # computed.
      if (!(signing_key).nil?)
        m3 = nil
        begin
          m3 = CertificateVerify.new(self.attr_protocol_version, self.attr_handshake_hash, signing_key, self.attr_session.get_master_secret, self.attr_ssl_context.get_secure_random)
        rescue GeneralSecurityException => e
          fatal_se(Alerts.attr_alert_handshake_failure, "Error signing certificate verify", e)
          # NOTREACHED, make compiler happy
          m3 = nil
        end
        if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
          m3.print(System.out)
        end
        m3.write(self.attr_output)
        self.attr_output.do_hashes
      end
      # OK, that's that!
      send_change_cipher_and_finish(false)
    end
    
    typesig { [Finished] }
    # "Finished" is the last handshake message sent.  If we got this
    # far, the MAC has been validated post-decryption.  We validate
    # the two hashes here as an additional sanity check, protecting
    # the handshake against various active attacks.
    def server_finished(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      verified = mesg.verify(self.attr_protocol_version, self.attr_handshake_hash, Finished::SERVER, self.attr_session.get_master_secret)
      if (!verified)
        fatal_se(Alerts.attr_alert_illegal_parameter, "server 'finished' message doesn't verify")
        # NOTREACHED
      end
      # OK, it verified.  If we're doing the fast handshake, add that
      # "Finished" message to the hash of handshake messages, then send
      # our own change_cipher_spec and Finished message for the server
      # to verify in turn.  These are the last handshake messages.
      # 
      # In any case, update the session cache.  We're done handshaking,
      # so there are no threats any more associated with partially
      # completed handshakes.
      if (self.attr_resuming_session)
        self.attr_input.digest_now
        send_change_cipher_and_finish(true)
      end
      self.attr_session.set_last_accessed_time(System.current_time_millis)
      if (!self.attr_resuming_session)
        if (self.attr_session.is_rejoinable)
          (self.attr_ssl_context.engine_get_client_session_context).put(self.attr_session)
          if (!(self.attr_debug).nil? && Debug.is_on("session"))
            System.out.println("%% Cached client session: " + (self.attr_session).to_s)
          end
        else
          if (!(self.attr_debug).nil? && Debug.is_on("session"))
            System.out.println("%% Didn't cache non-resumable client session: " + (self.attr_session).to_s)
          end
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Send my change-cipher-spec and Finished message ... done as the
    # last handshake act in either the short or long sequences.  In
    # the short one, we've already seen the server's Finished; in the
    # long one, we wait for it now.
    def send_change_cipher_and_finish(finished_tag)
      mesg = Finished.new(self.attr_protocol_version, self.attr_handshake_hash, Finished::CLIENT, self.attr_session.get_master_secret)
      # Send the change_cipher_spec message, then the Finished message
      # which we just calculated (and protected using the keys we just
      # calculated).  Server responds with its Finished message, except
      # in the "fast handshake" (resume session) case.
      send_change_cipher_spec(mesg, finished_tag)
      # Update state machine so server MUST send 'finished' next.
      # (In "long" handshake case; in short case, we're responding
      # to its message.)
      self.attr_state = HandshakeMessage.attr_ht_finished - 1
    end
    
    typesig { [] }
    # Returns a ClientHello message to kickstart renegotiations
    def get_kickstart_message
      mesg = ClientHello.new(self.attr_ssl_context.get_secure_random, self.attr_protocol_version)
      @max_protocol_version = self.attr_protocol_version
      self.attr_clnt_random = mesg.attr_clnt_random
      # Try to resume an existing session.  This might be mandatory,
      # given certain API options.
      self.attr_session = (self.attr_ssl_context.engine_get_client_session_context).get(get_host_se, get_port_se)
      if (!(self.attr_debug).nil? && Debug.is_on("session"))
        if (!(self.attr_session).nil?)
          System.out.println("%% Client cached " + (self.attr_session).to_s + ((self.attr_session.is_rejoinable ? "" : " (not rejoinable)")).to_s)
        else
          System.out.println("%% No cached client session")
        end
      end
      if ((!(self.attr_session).nil?) && ((self.attr_session.is_rejoinable).equal?(false)))
        self.attr_session = nil
      end
      if (!(self.attr_session).nil?)
        session_suite = self.attr_session.get_suite
        session_version = self.attr_session.get_protocol_version
        if ((is_enabled(session_suite)).equal?(false))
          if (!(self.attr_debug).nil? && Debug.is_on("session"))
            System.out.println("%% can't resume, cipher disabled")
          end
          self.attr_session = nil
        end
        if ((!(self.attr_session).nil?) && ((self.attr_enabled_protocols.contains(session_version)).equal?(false)))
          if (!(self.attr_debug).nil? && Debug.is_on("session"))
            System.out.println("%% can't resume, protocol disabled")
          end
          self.attr_session = nil
        end
        if (!(self.attr_session).nil?)
          if (!(self.attr_debug).nil?)
            if (Debug.is_on("handshake") || Debug.is_on("session"))
              System.out.println("%% Try resuming " + (self.attr_session).to_s + " from port " + (get_local_port_se).to_s)
            end
          end
          mesg.attr_session_id = self.attr_session.get_session_id
          mesg.attr_protocol_version = session_version
          @max_protocol_version = session_version
          # Update SSL version number in underlying SSL socket and
          # handshake output stream, so that the output records (at the
          # record layer) have the correct version
          set_version(session_version)
        end
        # don't say much beyond the obvious if we _must_ resume.
        if (!self.attr_enable_new_session)
          if ((self.attr_session).nil?)
            raise SSLException.new("Can't reuse existing SSL client session")
          end
          mesg.set_cipher_suites(CipherSuiteList.new(session_suite))
          return mesg
        end
      end
      if ((self.attr_session).nil?)
        if (self.attr_enable_new_session)
          mesg.attr_session_id = SSLSessionImpl.attr_null_session.get_session_id
        else
          raise SSLException.new("No existing session to resume.")
        end
      end
      # All we have left to do is fill out the cipher suites.
      # (If this changes, change the 'return' above!)
      mesg.set_cipher_suites(self.attr_enabled_cipher_suites)
      return mesg
    end
    
    typesig { [::Java::Byte] }
    # Fault detected during handshake.
    def handshake_alert(description)
      message = Alerts.alert_description(description)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        System.out.println("SSL - handshake alert: " + message)
      end
      raise SSLProtocolException.new("handshake alert:  " + message)
    end
    
    typesig { [CertificateMsg] }
    # Unless we are using an anonymous ciphersuite, the server always
    # sends a certificate message (for the CipherSuites we currently
    # support). The trust manager verifies the chain for us.
    def server_certificate(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      peer_certs = mesg.get_certificate_chain
      if ((peer_certs.attr_length).equal?(0))
        fatal_se(Alerts.attr_alert_bad_certificate, "empty certificate chain")
      end
      # ask the trust manager to verify the chain
      tm = self.attr_ssl_context.get_x509trust_manager
      begin
        # find out the key exchange algorithm used
        # use "RSA" for non-ephemeral "RSA_EXPORT"
        key_exchange_string = nil
        if ((self.attr_key_exchange).equal?(K_RSA_EXPORT) && !@server_key_exchange_received)
          key_exchange_string = (K_RSA.attr_name).to_s
        else
          key_exchange_string = (self.attr_key_exchange.attr_name).to_s
        end
        identificator = get_hostname_verification_se
        if (tm.is_a?(X509ExtendedTrustManager))
          (tm).check_server_trusted((!(peer_certs).nil? ? peer_certs.clone : nil), key_exchange_string, get_host_se, identificator)
        else
          if (!(identificator).nil?)
            raise RuntimeException.new("trust manager does not support peer identification")
          end
          tm.check_server_trusted((!(peer_certs).nil? ? peer_certs.clone : peer_certs), key_exchange_string)
        end
      rescue CertificateException => e
        # This will throw an exception, so include the original error.
        fatal_se(Alerts.attr_alert_certificate_unknown, e)
      end
      self.attr_session.set_peer_certificates(peer_certs)
    end
    
    private
    alias_method :initialize__client_handshaker, :initialize
  end
  
end
