require "rjava"

# 
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
  module ServerHandshakerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Cert
      include ::Java::Security::Interfaces
      include_const ::Java::Security::Spec, :ECParameterSpec
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include ::Javax::Net::Ssl
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth::Kerberos, :KerberosKey
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include_const ::Javax::Security::Auth::Kerberos, :ServicePermission
      include_const ::Sun::Security::Jgss::Krb5, :Krb5Util
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Com::Sun::Net::Ssl::Internal::Ssl, :X509ExtendedTrustManager
      include ::Sun::Security::Ssl::HandshakeMessage
      include ::Sun::Security::Ssl::CipherSuite
    }
  end
  
  # 
  # ServerHandshaker does the protocol handshaking from the point
  # of view of a server.  It is driven asychronously by handshake messages
  # as delivered by the parent Handshaker class, and also uses
  # common functionality (e.g. key generation) that is provided there.
  # 
  # @author David Brownell
  class ServerHandshaker < ServerHandshakerImports.const_get :Handshaker
    include_class_members ServerHandshakerImports
    
    # is the server going to require the client to authenticate?
    attr_accessor :do_client_auth
    alias_method :attr_do_client_auth, :do_client_auth
    undef_method :do_client_auth
    alias_method :attr_do_client_auth=, :do_client_auth=
    undef_method :do_client_auth=
    
    # our authentication info
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    attr_accessor :kerberos_keys
    alias_method :attr_kerberos_keys, :kerberos_keys
    undef_method :kerberos_keys
    alias_method :attr_kerberos_keys=, :kerberos_keys=
    undef_method :kerberos_keys=
    
    # flag to check for clientCertificateVerify message
    attr_accessor :need_client_verify
    alias_method :attr_need_client_verify, :need_client_verify
    undef_method :need_client_verify
    alias_method :attr_need_client_verify=, :need_client_verify=
    undef_method :need_client_verify=
    
    # 
    # For exportable ciphersuites using non-exportable key sizes, we use
    # ephemeral RSA keys. We could also do anonymous RSA in the same way
    # but there are no such ciphersuites currently defined.
    attr_accessor :temp_private_key
    alias_method :attr_temp_private_key, :temp_private_key
    undef_method :temp_private_key
    alias_method :attr_temp_private_key=, :temp_private_key=
    undef_method :temp_private_key=
    
    attr_accessor :temp_public_key
    alias_method :attr_temp_public_key, :temp_public_key
    undef_method :temp_public_key
    alias_method :attr_temp_public_key=, :temp_public_key=
    undef_method :temp_public_key=
    
    # 
    # For anonymous and ephemeral Diffie-Hellman key exchange, we use
    # ephemeral Diffie-Hellman keys.
    attr_accessor :dh
    alias_method :attr_dh, :dh
    undef_method :dh
    alias_method :attr_dh=, :dh=
    undef_method :dh=
    
    # Helper for ECDH based key exchanges
    attr_accessor :ecdh
    alias_method :attr_ecdh, :ecdh
    undef_method :ecdh
    alias_method :attr_ecdh=, :ecdh=
    undef_method :ecdh=
    
    # version request by the client in its ClientHello
    # we remember it for the RSA premaster secret version check
    attr_accessor :client_requested_version
    alias_method :attr_client_requested_version, :client_requested_version
    undef_method :client_requested_version
    alias_method :attr_client_requested_version=, :client_requested_version=
    undef_method :client_requested_version=
    
    attr_accessor :supported_curves
    alias_method :attr_supported_curves, :supported_curves
    undef_method :supported_curves
    alias_method :attr_supported_curves=, :supported_curves=
    undef_method :supported_curves=
    
    typesig { [SSLSocketImpl, SSLContextImpl, ProtocolList, ::Java::Byte] }
    # 
    # Constructor ... use the keys found in the auth context.
    def initialize(socket, context, enabled_protocols, client_auth)
      @do_client_auth = 0
      @certs = nil
      @private_key = nil
      @kerberos_keys = nil
      @need_client_verify = false
      @temp_private_key = nil
      @temp_public_key = nil
      @dh = nil
      @ecdh = nil
      @client_requested_version = nil
      @supported_curves = nil
      super(socket, context, enabled_protocols, (!(client_auth).equal?(SSLEngineImpl.attr_clauth_none)), false)
      @need_client_verify = false
      @do_client_auth = client_auth
    end
    
    typesig { [SSLEngineImpl, SSLContextImpl, ProtocolList, ::Java::Byte] }
    # 
    # Constructor ... use the keys found in the auth context.
    def initialize(engine, context, enabled_protocols, client_auth)
      @do_client_auth = 0
      @certs = nil
      @private_key = nil
      @kerberos_keys = nil
      @need_client_verify = false
      @temp_private_key = nil
      @temp_public_key = nil
      @dh = nil
      @ecdh = nil
      @client_requested_version = nil
      @supported_curves = nil
      super(engine, context, enabled_protocols, (!(client_auth).equal?(SSLEngineImpl.attr_clauth_none)), false)
      @need_client_verify = false
      @do_client_auth = client_auth
    end
    
    typesig { [::Java::Byte] }
    # 
    # As long as handshaking has not started, we can change
    # whether client authentication is required.  Otherwise,
    # we will need to wait for the next handshake.
    def set_client_auth(client_auth)
      @do_client_auth = client_auth
    end
    
    typesig { [::Java::Byte, ::Java::Int] }
    # 
    # This routine handles all the server side handshake messages, one at
    # a time.  Given the message type (and in some cases the pending cipher
    # spec) it parses the type-specific message.  Then it calls a function
    # that handles that specific message.
    # 
    # It updates the state machine as each message is processed, and writes
    # responses as needed using the connection in the constructor.
    def process_message(type, message_len)
      # 
      # In SSLv3 and TLS, messages follow strictly increasing
      # numerical order _except_ for one annoying special case.
      if ((self.attr_state > type) && (!(self.attr_state).equal?(HandshakeMessage.attr_ht_client_key_exchange) && !(type).equal?(HandshakeMessage.attr_ht_certificate_verify)))
        raise SSLProtocolException.new("Handshake message sequence violation, state = " + (self.attr_state).to_s + ", type = " + (type).to_s)
      end
      case (type)
      when HandshakeMessage.attr_ht_client_hello
        ch = ClientHello.new(self.attr_input, message_len)
        # 
        # send it off for processing.
        self.client_hello(ch)
      when HandshakeMessage.attr_ht_certificate
        if ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_none))
          fatal_se(Alerts.attr_alert_unexpected_message, "client sent unsolicited cert chain")
          # NOTREACHED
        end
        self.client_certificate(CertificateMsg.new(self.attr_input))
      when HandshakeMessage.attr_ht_client_key_exchange
        pre_master_secret = nil
        case (self.attr_key_exchange)
        when K_RSA, K_RSA_EXPORT
          # 
          # The client's pre-master secret is decrypted using
          # either the server's normal private RSA key, or the
          # temporary one used for non-export or signing-only
          # certificates/keys.
          pms = RSAClientKeyExchange.new(self.attr_protocol_version, self.attr_input, message_len, @private_key)
          pre_master_secret = self.client_key_exchange(pms)
        when K_KRB5, K_KRB5_EXPORT
          pre_master_secret = self.client_key_exchange(KerberosClientKeyExchange.new(self.attr_protocol_version, @client_requested_version, self.attr_ssl_context.get_secure_random, self.attr_input, @kerberos_keys))
        when K_DHE_RSA, K_DHE_DSS, K_DH_ANON
          # 
          # The pre-master secret is derived using the normal
          # Diffie-Hellman calculation.   Note that the main
          # protocol difference in these five flavors is in how
          # the ServerKeyExchange message was constructed!
          pre_master_secret = self.client_key_exchange(DHClientKeyExchange.new(self.attr_input))
        when K_ECDH_RSA, K_ECDH_ECDSA, K_ECDHE_RSA, K_ECDHE_ECDSA, K_ECDH_ANON
          pre_master_secret = self.client_key_exchange(ECDHClientKeyExchange.new(self.attr_input))
        else
          raise SSLProtocolException.new("Unrecognized key exchange: " + (self.attr_key_exchange).to_s)
        end
        # 
        # All keys are calculated from the premaster secret
        # and the exchanged nonces in the same way.
        calculate_keys(pre_master_secret, @client_requested_version)
      when HandshakeMessage.attr_ht_certificate_verify
        self.client_certificate_verify(CertificateVerify.new(self.attr_input))
      when HandshakeMessage.attr_ht_finished
        self.client_finished(Finished.new(self.attr_protocol_version, self.attr_input))
      else
        raise SSLProtocolException.new("Illegal server handshake msg, " + (type).to_s)
      end
      # 
      # Move the state machine forward except for that annoying
      # special case.  This means that clients could send extra
      # cert verify messages; not a problem so long as all of
      # them actually check out.
      if (self.attr_state < type && !(type).equal?(HandshakeMessage.attr_ht_certificate_verify))
        self.attr_state = type
      end
    end
    
    typesig { [ClientHello] }
    # 
    # ClientHello presents the server with a bunch of options, to which the
    # server replies with a ServerHello listing the ones which this session
    # will use.  If needed, it also writes its Certificate plus in some cases
    # a ServerKeyExchange message.  It may also write a CertificateRequest,
    # to elicit a client certificate.
    # 
    # All these messages are terminated by a ServerHelloDone message.  In
    # most cases, all this can be sent in a single Record.
    def client_hello(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      # 
      # Always make sure this entire record has been digested before we
      # start emitting output, to ensure correct digesting order.
      self.attr_input.digest_now
      # 
      # FIRST, construct the ServerHello using the options and priorities
      # from the ClientHello.  Update the (pending) cipher spec as we do
      # so, and save the client's version to protect against rollback
      # attacks.
      # 
      # There are a bunch of minor tasks here, and one major one: deciding
      # if the short or the full handshake sequence will be used.
      m1 = ServerHello.new
      @client_requested_version = mesg.attr_protocol_version
      # check if clientVersion is recent enough for us
      if (@client_requested_version.attr_v < self.attr_enabled_protocols.attr_min.attr_v)
        fatal_se(Alerts.attr_alert_handshake_failure, "Client requested protocol " + (@client_requested_version).to_s + " not enabled or not supported")
      end
      # now we know we have an acceptable version
      # use the lower of our max and the client requested version
      selected_version = nil
      if (@client_requested_version.attr_v <= self.attr_enabled_protocols.attr_max.attr_v)
        selected_version = @client_requested_version
      else
        selected_version = self.attr_enabled_protocols.attr_max
      end
      set_version(selected_version)
      m1.attr_protocol_version = self.attr_protocol_version
      # 
      # random ... save client and server values for later use
      # in computing the master secret (from pre-master secret)
      # and thence the other crypto keys.
      # 
      # NOTE:  this use of three inputs to generating _each_ set
      # of ciphers slows things down, but it does increase the
      # security since each connection in the session can hold
      # its own authenticated (and strong) keys.  One could make
      # creation of a session a rare thing...
      self.attr_clnt_random = mesg.attr_clnt_random
      self.attr_svr_random = RandomCookie.new(self.attr_ssl_context.get_secure_random)
      m1.attr_svr_random = self.attr_svr_random
      self.attr_session = nil # forget about the current session
      # 
      # Here we go down either of two paths:  (a) the fast one, where
      # the client's asked to rejoin an existing session, and the server
      # permits this; (b) the other one, where a new session is created.
      if (!(mesg.attr_session_id.length).equal?(0))
        # client is trying to resume a session, let's see...
        previous = (self.attr_ssl_context.engine_get_server_session_context).get(mesg.attr_session_id.get_id)
        # 
        # Check if we can use the fast path, resuming a session.  We
        # can do so iff we have a valid record for that session, and
        # the cipher suite for that session was on the list which the
        # client requested, and if we're not forgetting any needed
        # authentication on the part of the client.
        if (!(previous).nil?)
          self.attr_resuming_session = previous.is_rejoinable
          if (self.attr_resuming_session)
            old_version = previous.get_protocol_version
            # cannot resume session with different version
            if (!(old_version).equal?(self.attr_protocol_version))
              self.attr_resuming_session = false
            end
          end
          if (self.attr_resuming_session && ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_required)))
            begin
              previous.get_peer_principal
            rescue SSLPeerUnverifiedException => e
              self.attr_resuming_session = false
            end
          end
          # validate subject identity
          if (self.attr_resuming_session)
            suite = previous.get_suite
            if ((suite.attr_key_exchange).equal?(K_KRB5) || (suite.attr_key_exchange).equal?(K_KRB5_EXPORT))
              local_principal = previous.get_local_principal
              subject = nil
              begin
                subject = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
                  extend LocalClass
                  include_class_members ServerHandshaker
                  include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    return Krb5Util.get_subject(GSSUtil::CALLER_SSL_SERVER, get_acc_se)
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
                  self.attr_resuming_session = false
                  if (!(self.attr_debug).nil? && Debug.is_on("session"))
                    System.out.println("Subject identity" + " is not the same")
                  end
                else
                  if (!(self.attr_debug).nil? && Debug.is_on("session"))
                    System.out.println("Subject identity" + " is same")
                  end
                end
              else
                self.attr_resuming_session = false
                if (!(self.attr_debug).nil? && Debug.is_on("session"))
                  System.out.println("Kerberos credentials are" + " not present in the current Subject;" + " check if " + " javax.security.auth.useSubjectAsCreds" + " system property has been set to false")
                end
              end
            end
          end
          if (self.attr_resuming_session)
            suite_ = previous.get_suite
            # verify that the ciphersuite from the cached session
            # is in the list of client requested ciphersuites and
            # we have it enabled
            if (((is_enabled(suite_)).equal?(false)) || ((mesg.get_cipher_suites.contains(suite_)).equal?(false)))
              self.attr_resuming_session = false
            else
              # everything looks ok, set the ciphersuite
              # this should be done last when we are sure we
              # will resume
              set_cipher_suite(suite_)
            end
          end
          if (self.attr_resuming_session)
            self.attr_session = previous
            if (!(self.attr_debug).nil? && (Debug.is_on("handshake") || Debug.is_on("session")))
              System.out.println("%% Resuming " + (self.attr_session).to_s)
            end
          end
        end
      end # else client did not try to resume
      # 
      # If client hasn't specified a session we can resume, start a
      # new one and choose its cipher suite and compression options.
      # Unless new session creation is disabled for this connection!
      if ((self.attr_session).nil?)
        if (!self.attr_enable_new_session)
          raise SSLException.new("Client did not resume a session")
        end
        @supported_curves = mesg.attr_extensions.get(ExtensionType::EXT_ELLIPTIC_CURVES)
        choose_cipher_suite(mesg)
        self.attr_session = SSLSessionImpl.new(self.attr_protocol_version, self.attr_cipher_suite, self.attr_ssl_context.get_secure_random, get_host_address_se, get_port_se)
        self.attr_session.set_local_private_key(@private_key)
        # chooseCompression(mesg);
      end
      m1.attr_cipher_suite = self.attr_cipher_suite
      m1.attr_session_id = self.attr_session.get_session_id
      m1.attr_compression_method = self.attr_session.get_compression
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        m1.print(System.out)
        System.out.println("Cipher suite:  " + (self.attr_session.get_suite).to_s)
      end
      m1.write(self.attr_output)
      # 
      # If we are resuming a session, we finish writing handshake
      # messages right now and then finish.
      if (self.attr_resuming_session)
        calculate_connection_keys(self.attr_session.get_master_secret)
        send_change_cipher_and_finish(false)
        return
      end
      # 
      # SECOND, write the server Certificate(s) if we need to.
      # 
      # NOTE:  while an "anonymous RSA" mode is explicitly allowed by
      # the protocol, we can't support it since all of the SSL flavors
      # defined in the protocol spec are explicitly stated to require
      # using RSA certificates.
      if ((self.attr_key_exchange).equal?(K_KRB5) || (self.attr_key_exchange).equal?(K_KRB5_EXPORT))
        # Server certificates are omitted for Kerberos ciphers
      else
        if ((!(self.attr_key_exchange).equal?(K_DH_ANON)) && (!(self.attr_key_exchange).equal?(K_ECDH_ANON)))
          if ((@certs).nil?)
            raise RuntimeException.new("no certificates")
          end
          m2 = CertificateMsg.new(@certs)
          # 
          # Set local certs in the SSLSession, output
          # debug info, and then actually write to the client.
          self.attr_session.set_local_certificates(@certs)
          if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
            m2.print(System.out)
          end
          m2.write(self.attr_output)
          # XXX has some side effects with OS TCP buffering,
          # leave it out for now
          # let client verify chain in the meantime...
          # output.flush();
        else
          if (!(@certs).nil?)
            raise RuntimeException.new("anonymous keyexchange with certs")
          end
        end
      end
      # 
      # THIRD, the ServerKeyExchange message ... iff it's needed.
      # 
      # It's usually needed unless there's an encryption-capable
      # RSA cert, or a D-H cert.  The notable exception is that
      # exportable ciphers used with big RSA keys need to downgrade
      # to use short RSA keys, even when the key/cert encrypts OK.
      m3 = nil
      case (self.attr_key_exchange)
      when K_RSA, K_KRB5, K_KRB5_EXPORT
        # no server key exchange for RSA or KRB5 ciphersuites
        m3 = nil
      when K_RSA_EXPORT
        if (JsseJce.get_rsakey_length(@certs[0].get_public_key) > 512)
          begin
            m3 = RSA_ServerKeyExchange.new(@temp_public_key, @private_key, self.attr_clnt_random, self.attr_svr_random, self.attr_ssl_context.get_secure_random)
            @private_key = @temp_private_key
          rescue GeneralSecurityException => e
            throw_sslexception("Error generating RSA server key exchange", e__)
            m3 = nil # make compiler happy
          end
        else
          # RSA_EXPORT with short key, don't need ServerKeyExchange
          m3 = nil
        end
      when K_DHE_RSA, K_DHE_DSS
        begin
          m3 = DH_ServerKeyExchange.new(@dh, @private_key, self.attr_clnt_random.attr_random_bytes, self.attr_svr_random.attr_random_bytes, self.attr_ssl_context.get_secure_random)
        rescue GeneralSecurityException => e
          throw_sslexception("Error generating DH server key exchange", e___)
          m3 = nil # make compiler happy
        end
      when K_DH_ANON
        m3 = DH_ServerKeyExchange.new(@dh)
      when K_ECDHE_RSA, K_ECDHE_ECDSA, K_ECDH_ANON
        begin
          m3 = ECDH_ServerKeyExchange.new(@ecdh, @private_key, self.attr_clnt_random.attr_random_bytes, self.attr_svr_random.attr_random_bytes, self.attr_ssl_context.get_secure_random)
        rescue GeneralSecurityException => e
          throw_sslexception("Error generating ECDH server key exchange", e____)
          m3 = nil # make compiler happy
        end
      when K_ECDH_RSA, K_ECDH_ECDSA
        # ServerKeyExchange not used for fixed ECDH
        m3 = nil
      else
        raise RuntimeException.new("internal error: " + (self.attr_key_exchange).to_s)
      end
      if (!(m3).nil?)
        if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
          m3.print(System.out)
        end
        m3.write(self.attr_output)
      end
      # 
      # FOURTH, the CertificateRequest message.  The details of
      # the message can be affected by the key exchange algorithm
      # in use.  For example, certs with fixed Diffie-Hellman keys
      # are only useful with the DH_DSS and DH_RSA key exchange
      # algorithms.
      # 
      # Needed only if server requires client to authenticate self.
      # Illegal for anonymous flavors, so we need to check that.
      if ((self.attr_key_exchange).equal?(K_KRB5) || (self.attr_key_exchange).equal?(K_KRB5_EXPORT))
        # CertificateRequest is omitted for Kerberos ciphers
      else
        if (!(@do_client_auth).equal?(SSLEngineImpl.attr_clauth_none) && !(self.attr_key_exchange).equal?(K_DH_ANON) && !(self.attr_key_exchange).equal?(K_ECDH_ANON))
          m4 = nil
          ca_certs = nil
          ca_certs = self.attr_ssl_context.get_x509trust_manager.get_accepted_issuers
          m4 = CertificateRequest.new(ca_certs, self.attr_key_exchange)
          if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
            m4.print(System.out)
          end
          m4.write(self.attr_output)
        end
      end
      # 
      # FIFTH, say ServerHelloDone.
      m5 = ServerHelloDone.new
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        m5.print(System.out)
      end
      m5.write(self.attr_output)
      # 
      # Flush any buffered messages so the client will see them.
      # Ideally, all the messages above go in a single network level
      # message to the client.  Without big Certificate chains, it's
      # going to be the common case.
      self.attr_output.flush
    end
    
    typesig { [ClientHello] }
    # 
    # Choose cipher suite from among those supported by client. Sets
    # the cipherSuite and keyExchange variables.
    def choose_cipher_suite(mesg)
      mesg.get_cipher_suites.collection.each do |suite|
        if ((is_enabled(suite)).equal?(false))
          next
        end
        if ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_required))
          if (((suite.attr_key_exchange).equal?(K_DH_ANON)) || ((suite.attr_key_exchange).equal?(K_ECDH_ANON)))
            next
          end
        end
        if ((try_set_cipher_suite(suite)).equal?(false))
          next
        end
        return
      end
      fatal_se(Alerts.attr_alert_handshake_failure, "no cipher suites in common")
    end
    
    typesig { [CipherSuite] }
    # 
    # Set the given CipherSuite, if possible. Return the result.
    # The call succeeds if the CipherSuite is available and we have
    # the necessary certificates to complete the handshake. We don't
    # check if the CipherSuite is actually enabled.
    # 
    # If successful, this method also generates ephemeral keys if
    # required for this ciphersuite. This may take some time, so this
    # method should only be called if you really want to use the
    # CipherSuite.
    # 
    # This method is called from chooseCipherSuite() in this class
    # and SSLServerSocketImpl.checkEnabledSuites() (as a sanity check).
    def try_set_cipher_suite(suite)
      # 
      # If we're resuming a session we know we can
      # support this key exchange algorithm and in fact
      # have already cached the result of it in
      # the session state.
      if (self.attr_resuming_session)
        return true
      end
      if ((suite.is_available).equal?(false))
        return false
      end
      key_exchange = suite.attr_key_exchange
      # null out any existing references
      @private_key = nil
      @certs = nil
      @dh = nil
      @temp_private_key = nil
      @temp_public_key = nil
      case (key_exchange)
      when K_RSA, K_RSA_EXPORT, K_DHE_RSA, K_ECDHE_RSA
        # need RSA certs for authentication
        if ((setup_private_key_and_chain("RSA")).equal?(false))
          return false
        end
        if ((key_exchange).equal?(K_RSA_EXPORT))
          begin
            if (JsseJce.get_rsakey_length(@certs[0].get_public_key) > 512)
              if (!setup_ephemeral_rsakeys(suite.attr_exportable))
                return false
              end
            end
          rescue RuntimeException => e
            # could not determine keylength, ignore key
            return false
          end
        else
          if ((key_exchange).equal?(K_DHE_RSA))
            setup_ephemeral_dhkeys(suite.attr_exportable)
          else
            if ((key_exchange).equal?(K_ECDHE_RSA))
              if ((setup_ephemeral_ecdhkeys).equal?(false))
                return false
              end
            end
          end
        end # else nothing more to do for K_RSA
      when K_DHE_DSS
        # need DSS certs for authentication
        if ((setup_private_key_and_chain("DSA")).equal?(false))
          return false
        end
        setup_ephemeral_dhkeys(suite.attr_exportable)
      when K_ECDHE_ECDSA
        # need EC cert signed using EC
        if ((setup_private_key_and_chain("EC_EC")).equal?(false))
          return false
        end
        if ((setup_ephemeral_ecdhkeys).equal?(false))
          return false
        end
      when K_ECDH_RSA
        # need EC cert signed using RSA
        if ((setup_private_key_and_chain("EC_RSA")).equal?(false))
          return false
        end
        setup_static_ecdhkeys
      when K_ECDH_ECDSA
        # need EC cert signed using EC
        if ((setup_private_key_and_chain("EC_EC")).equal?(false))
          return false
        end
        setup_static_ecdhkeys
      when K_KRB5, K_KRB5_EXPORT
        # need Kerberos Key
        if (!setup_kerberos_keys)
          return false
        end
      when K_DH_ANON
        # no certs needed for anonymous
        setup_ephemeral_dhkeys(suite.attr_exportable)
      when K_ECDH_ANON
        # no certs needed for anonymous
        if ((setup_ephemeral_ecdhkeys).equal?(false))
          return false
        end
      else
        # internal error, unknown key exchange
        raise RuntimeException.new("Unrecognized cipherSuite: " + (suite).to_s)
      end
      set_cipher_suite(suite)
      return true
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Get some "ephemeral" RSA keys for this context. This means
    # generating them if it's not already been done.
    # 
    # Note that we currently do not implement any ciphersuites that use
    # strong ephemeral RSA. (We do not support the EXPORT1024 ciphersuites
    # and standard RSA ciphersuites prohibit ephemeral mode for some reason)
    # This means that export is always true and 512 bit keys are generated.
    def setup_ephemeral_rsakeys(export)
      kp = self.attr_ssl_context.get_ephemeral_key_manager.get_rsakey_pair(export, self.attr_ssl_context.get_secure_random)
      if ((kp).nil?)
        return false
      else
        @temp_public_key = kp.get_public
        @temp_private_key = kp.get_private
        return true
      end
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Acquire some "ephemeral" Diffie-Hellman  keys for this handshake.
    # We don't reuse these, for improved forward secrecy.
    def setup_ephemeral_dhkeys(export)
      # 
      # Diffie-Hellman keys ... we use 768 bit private keys due
      # to the "use twice as many key bits as bits you want secret"
      # rule of thumb, assuming we want the same size premaster
      # secret with Diffie-Hellman and RSA key exchanges.  Except
      # that exportable ciphers max out at 512 bits modulus values.
      @dh = DHCrypt.new((export ? 512 : 768), self.attr_ssl_context.get_secure_random)
    end
    
    typesig { [] }
    # Setup the ephemeral ECDH parameters.
    # If we cannot continue because we do not support any of the curves that
    # the client requested, return false. Otherwise (all is well), return true.
    def setup_ephemeral_ecdhkeys
      index = -1
      if (!(@supported_curves).nil?)
        # if the client sent the supported curves extension, pick the
        # first one that we support;
        @supported_curves.curve_ids.each do |curveId|
          if (SupportedEllipticCurvesExtension.is_supported(curve_id))
            index = curve_id
            break
          end
        end
        if (index < 0)
          # no match found, cannot use this ciphersuite
          return false
        end
      else
        # pick our preference
        index = SupportedEllipticCurvesExtension::DEFAULT.curve_ids[0]
      end
      oid = SupportedEllipticCurvesExtension.get_curve_oid(index)
      @ecdh = ECDHCrypt.new(oid, self.attr_ssl_context.get_secure_random)
      return true
    end
    
    typesig { [] }
    def setup_static_ecdhkeys
      # don't need to check whether the curve is supported, already done
      # in setupPrivateKeyAndChain().
      @ecdh = ECDHCrypt.new(@private_key, @certs[0].get_public_key)
    end
    
    typesig { [String] }
    # 
    # Retrieve the server key and certificate for the specified algorithm
    # from the KeyManager and set the instance variables.
    # 
    # @return true if successful, false if not available or invalid
    def setup_private_key_and_chain(algorithm)
      km = self.attr_ssl_context.get_x509key_manager
      alias_ = nil
      if (!(self.attr_conn).nil?)
        alias_ = (km.choose_server_alias(algorithm, nil, self.attr_conn)).to_s
      else
        alias_ = (km.choose_engine_server_alias(algorithm, nil, self.attr_engine)).to_s
      end
      if ((alias_).nil?)
        return false
      end
      temp_private_key = km.get_private_key(alias_)
      if ((temp_private_key).nil?)
        return false
      end
      temp_certs = km.get_certificate_chain(alias_)
      if (((temp_certs).nil?) || ((temp_certs.attr_length).equal?(0)))
        return false
      end
      key_algorithm = algorithm.split(Regexp.new("_"))[0]
      public_key = temp_certs[0].get_public_key
      if ((((temp_private_key.get_algorithm == key_algorithm)).equal?(false)) || (((public_key.get_algorithm == key_algorithm)).equal?(false)))
        return false
      end
      # For ECC certs, check whether we support the EC domain parameters.
      # If the client sent a SupportedEllipticCurves ClientHello extension,
      # check against that too.
      if ((key_algorithm == "EC"))
        if ((public_key.is_a?(ECPublicKey)).equal?(false))
          return false
        end
        params = (public_key).get_params
        index = SupportedEllipticCurvesExtension.get_curve_index(params)
        if ((SupportedEllipticCurvesExtension.is_supported(index)).equal?(false))
          return false
        end
        if ((!(@supported_curves).nil?) && !@supported_curves.contains(index))
          return false
        end
      end
      @private_key = temp_private_key
      @certs = temp_certs
      return true
    end
    
    typesig { [] }
    # 
    # Retrieve the Kerberos key for the specified server principal
    # from the JAAS configuration file.
    # 
    # @return true if successful, false if not available or invalid
    def setup_kerberos_keys
      if (!(@kerberos_keys).nil?)
        return true
      end
      begin
        acc = get_acc_se
        @kerberos_keys = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members ServerHandshaker
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            # get kerberos key for the default principal
            return Krb5Util.get_keys(GSSUtil::CALLER_SSL_SERVER, nil, acc)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # check permission to access and use the secret key of the
        # Kerberized "host" service
        if (!(@kerberos_keys).nil?)
          if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
            System.out.println("Using Kerberos key: " + (@kerberos_keys[0]).to_s)
          end
          server_principal = @kerberos_keys[0].get_principal.get_name
          sm = System.get_security_manager
          begin
            if (!(sm).nil?)
              sm.check_permission(ServicePermission.new(server_principal, "accept"), acc)
            end
          rescue SecurityException => se
            @kerberos_keys = nil
            # %%% destroy keys? or will that affect Subject?
            if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
              System.out.println("Permission to access Kerberos" + " secret key denied")
            end
            return false
          end
        end
        return (!(@kerberos_keys).nil?)
      rescue PrivilegedActionException => e
        # Likely exception here is LoginExceptin
        if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
          System.out.println("Attempt to obtain Kerberos key failed: " + (e.to_s).to_s)
        end
        return false
      end
    end
    
    typesig { [KerberosClientKeyExchange] }
    # 
    # For Kerberos ciphers, the premaster secret is encrypted using
    # the session key. See RFC 2712.
    def client_key_exchange(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      # Record the principals involved in exchange
      self.attr_session.set_peer_principal(mesg.get_peer_principal)
      self.attr_session.set_local_principal(mesg.get_local_principal)
      b = mesg.get_pre_master_secret.get_unencrypted
      return SecretKeySpec.new(b, "TlsPremasterSecret")
    end
    
    typesig { [DHClientKeyExchange] }
    # 
    # Diffie Hellman key exchange is used when the server presented
    # D-H parameters in its certificate (signed using RSA or DSS/DSA),
    # or else the server presented no certificate but sent D-H params
    # in a ServerKeyExchange message.  Use of D-H is specified by the
    # cipher suite chosen.
    # 
    # The message optionally contains the client's D-H public key (if
    # it wasn't not sent in a client certificate).  As always with D-H,
    # if a client and a server have each other's D-H public keys and
    # they use common algorithm parameters, they have a shared key
    # that's derived via the D-H calculation.  That key becomes the
    # pre-master secret.
    def client_key_exchange(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      return @dh.get_agreed_secret(mesg.get_client_public_key)
    end
    
    typesig { [ECDHClientKeyExchange] }
    def client_key_exchange(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      return @ecdh.get_agreed_secret(mesg.get_encoded_point)
    end
    
    typesig { [CertificateVerify] }
    # 
    # Client wrote a message to verify the certificate it sent earlier.
    # 
    # Note that this certificate isn't involved in key exchange.  Client
    # authentication messages are included in the checksums used to
    # validate the handshake (e.g. Finished messages).  Other than that,
    # the _exact_ identity of the client is less fundamental to protocol
    # security than its role in selecting keys via the pre-master secret.
    def client_certificate_verify(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      begin
        public_key = self.attr_session.get_peer_certificates[0].get_public_key
        valid = mesg.verify(self.attr_protocol_version, self.attr_handshake_hash, public_key, self.attr_session.get_master_secret)
        if ((valid).equal?(false))
          fatal_se(Alerts.attr_alert_bad_certificate, "certificate verify message signature error")
        end
      rescue GeneralSecurityException => e
        fatal_se(Alerts.attr_alert_bad_certificate, "certificate verify format error", e)
      end
      # reset the flag for clientCertificateVerify message
      @need_client_verify = false
    end
    
    typesig { [Finished] }
    # 
    # Client writes "finished" at the end of its handshake, after cipher
    # spec is changed.   We verify it and then send ours.
    # 
    # When we're resuming a session, we'll have already sent our own
    # Finished message so just the verification is needed.
    def client_finished(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      # 
      # Verify if client did send the certificate when client
      # authentication was required, otherwise server should not proceed
      if ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_required))
        # get X500Principal of the end-entity certificate for X509-based
        # ciphersuites, or Kerberos principal for Kerberos ciphersuites
        self.attr_session.get_peer_principal
      end
      # 
      # Verify if client did send clientCertificateVerify message following
      # the client Certificate, otherwise server should not proceed
      if (@need_client_verify)
        fatal_se(Alerts.attr_alert_handshake_failure, "client did not send certificate verify message")
      end
      # 
      # Verify the client's message with the "before" digest of messages,
      # and forget about continuing to use that digest.
      verified = mesg.verify(self.attr_protocol_version, self.attr_handshake_hash, Finished::CLIENT, self.attr_session.get_master_secret)
      if (!verified)
        fatal_se(Alerts.attr_alert_handshake_failure, "client 'finished' message doesn't verify")
        # NOTREACHED
      end
      # 
      # OK, it verified.  If we're doing the full handshake, add that
      # "Finished" message to the hash of handshake messages, then send
      # the change_cipher_spec and Finished message.
      if (!self.attr_resuming_session)
        self.attr_input.digest_now
        send_change_cipher_and_finish(true)
      end
      # 
      # Update the session cache only after the handshake completed, else
      # we're open to an attack against a partially completed handshake.
      self.attr_session.set_last_accessed_time(System.current_time_millis)
      if (!self.attr_resuming_session && self.attr_session.is_rejoinable)
        (self.attr_ssl_context.engine_get_server_session_context).put(self.attr_session)
        if (!(self.attr_debug).nil? && Debug.is_on("session"))
          System.out.println("%% Cached server session: " + (self.attr_session).to_s)
        end
      else
        if (!self.attr_resuming_session && !(self.attr_debug).nil? && Debug.is_on("session"))
          System.out.println("%% Didn't cache non-resumable server session: " + (self.attr_session).to_s)
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Compute finished message with the "server" digest (and then forget
    # about that digest, it can't be used again).
    def send_change_cipher_and_finish(finished_tag)
      self.attr_output.flush
      mesg = Finished.new(self.attr_protocol_version, self.attr_handshake_hash, Finished::SERVER, self.attr_session.get_master_secret)
      # 
      # Send the change_cipher_spec record; then our Finished handshake
      # message will be the last handshake message.  Flush, and now we
      # are ready for application data!!
      send_change_cipher_spec(mesg, finished_tag)
      # 
      # Update state machine so client MUST send 'finished' next
      # The update should only take place if it is not in the fast
      # handshake mode since the server has to wait for a finished
      # message from the client.
      if (finished_tag)
        self.attr_state = HandshakeMessage.attr_ht_finished
      end
    end
    
    typesig { [] }
    # 
    # Returns a HelloRequest message to kickstart renegotiations
    def get_kickstart_message
      return HelloRequest.new
    end
    
    typesig { [::Java::Byte] }
    # 
    # Fault detected during handshake.
    def handshake_alert(description)
      message = Alerts.alert_description(description)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        System.out.println("SSL -- handshake alert:  " + message)
      end
      # 
      # It's ok to get a no_certificate alert from a client of which
      # we *requested* authentication information.
      # However, if we *required* it, then this is not acceptable.
      # 
      # Anyone calling getPeerCertificates() on the
      # session will get an SSLPeerUnverifiedException.
      if (((description).equal?(Alerts.attr_alert_no_certificate)) && ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_requested)))
        return
      end
      raise SSLProtocolException.new("handshake alert: " + message)
    end
    
    typesig { [RSAClientKeyExchange] }
    # 
    # RSA key exchange is normally used.  The client encrypts a "pre-master
    # secret" with the server's public key, from the Certificate (or else
    # ServerKeyExchange) message that was sent to it by the server.  That's
    # decrypted using the private key before we get here.
    def client_key_exchange(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      return mesg.attr_pre_master
    end
    
    typesig { [CertificateMsg] }
    # 
    # Verify the certificate sent by the client. We'll only get one if we
    # sent a CertificateRequest to request client authentication. If we
    # are in TLS mode, the client may send a message with no certificates
    # to indicate it does not have an appropriate chain. (In SSLv3 mode,
    # it would send a no certificate alert).
    def client_certificate(mesg)
      if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
        mesg.print(System.out)
      end
      peer_certs = mesg.get_certificate_chain
      if ((peer_certs.attr_length).equal?(0))
        # 
        # If the client authentication is only *REQUESTED* (e.g.
        # not *REQUIRED*, this is an acceptable condition.)
        if ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_requested))
          return
        else
          fatal_se(Alerts.attr_alert_bad_certificate, "null cert chain")
        end
      end
      # ask the trust manager to verify the chain
      tm = self.attr_ssl_context.get_x509trust_manager
      begin
        # find out the types of client authentication used
        key = peer_certs[0].get_public_key
        key_algorithm = key.get_algorithm
        auth_type = nil
        if ((key_algorithm == "RSA"))
          auth_type = "RSA"
        else
          if ((key_algorithm == "DSA"))
            auth_type = "DSA"
          else
            if ((key_algorithm == "EC"))
              auth_type = "EC"
            else
              # unknown public key type
              auth_type = "UNKNOWN"
            end
          end
        end
        identificator = get_hostname_verification_se
        if (tm.is_a?(X509ExtendedTrustManager))
          (tm).check_client_trusted((!(peer_certs).nil? ? peer_certs.clone : nil), auth_type, get_host_se, identificator)
        else
          if (!(identificator).nil?)
            raise RuntimeException.new("trust manager does not support peer identification")
          end
          tm.check_client_trusted((!(peer_certs).nil? ? peer_certs.clone : peer_certs), auth_type)
        end
      rescue CertificateException => e
        # This will throw an exception, so include the original error.
        fatal_se(Alerts.attr_alert_certificate_unknown, e)
      end
      # set the flag for clientCertificateVerify message
      @need_client_verify = true
      self.attr_session.set_peer_certificates(peer_certs)
    end
    
    private
    alias_method :initialize__server_handshaker, :initialize
  end
  
end
