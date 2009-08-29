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
  module HandshakerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security::Cert, :X509Certificate
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include ::Javax::Net::Ssl
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::Internal::Spec
      include_const ::Sun::Security::Internal::Interfaces, :TlsMasterSecret
      include ::Sun::Security::Ssl::HandshakeMessage
      include ::Sun::Security::Ssl::CipherSuite
    }
  end
  
  # Handshaker ... processes handshake records from an SSL V3.0
  # data stream, handling all the details of the handshake protocol.
  # 
  # Note that the real protocol work is done in two subclasses, the  base
  # class just provides the control flow and key generation framework.
  # 
  # @author David Brownell
  class Handshaker 
    include_class_members HandshakerImports
    
    # current protocol version
    attr_accessor :protocol_version
    alias_method :attr_protocol_version, :protocol_version
    undef_method :protocol_version
    alias_method :attr_protocol_version=, :protocol_version=
    undef_method :protocol_version=
    
    # list of enabled protocols
    attr_accessor :enabled_protocols
    alias_method :attr_enabled_protocols, :enabled_protocols
    undef_method :enabled_protocols
    alias_method :attr_enabled_protocols=, :enabled_protocols=
    undef_method :enabled_protocols=
    
    attr_accessor :is_client
    alias_method :attr_is_client, :is_client
    undef_method :is_client
    alias_method :attr_is_client=, :is_client=
    undef_method :is_client=
    
    attr_accessor :conn
    alias_method :attr_conn, :conn
    undef_method :conn
    alias_method :attr_conn=, :conn=
    undef_method :conn=
    
    attr_accessor :engine
    alias_method :attr_engine, :engine
    undef_method :engine
    alias_method :attr_engine=, :engine=
    undef_method :engine=
    
    attr_accessor :handshake_hash
    alias_method :attr_handshake_hash, :handshake_hash
    undef_method :handshake_hash
    alias_method :attr_handshake_hash=, :handshake_hash=
    undef_method :handshake_hash=
    
    attr_accessor :input
    alias_method :attr_input, :input
    undef_method :input
    alias_method :attr_input=, :input=
    undef_method :input=
    
    attr_accessor :output
    alias_method :attr_output, :output
    undef_method :output
    alias_method :attr_output=, :output=
    undef_method :output=
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    attr_accessor :ssl_context
    alias_method :attr_ssl_context, :ssl_context
    undef_method :ssl_context
    alias_method :attr_ssl_context=, :ssl_context=
    undef_method :ssl_context=
    
    attr_accessor :clnt_random
    alias_method :attr_clnt_random, :clnt_random
    undef_method :clnt_random
    alias_method :attr_clnt_random=, :clnt_random=
    undef_method :clnt_random=
    
    attr_accessor :svr_random
    alias_method :attr_svr_random, :svr_random
    undef_method :svr_random
    alias_method :attr_svr_random=, :svr_random=
    undef_method :svr_random=
    
    attr_accessor :session
    alias_method :attr_session, :session
    undef_method :session
    alias_method :attr_session=, :session=
    undef_method :session=
    
    # Temporary MD5 and SHA message digests. Must always be left
    # in reset state after use.
    attr_accessor :md5tmp
    alias_method :attr_md5tmp, :md5tmp
    undef_method :md5tmp
    alias_method :attr_md5tmp=, :md5tmp=
    undef_method :md5tmp=
    
    attr_accessor :sha_tmp
    alias_method :attr_sha_tmp, :sha_tmp
    undef_method :sha_tmp
    alias_method :attr_sha_tmp=, :sha_tmp=
    undef_method :sha_tmp=
    
    # list of enabled CipherSuites
    attr_accessor :enabled_cipher_suites
    alias_method :attr_enabled_cipher_suites, :enabled_cipher_suites
    undef_method :enabled_cipher_suites
    alias_method :attr_enabled_cipher_suites=, :enabled_cipher_suites=
    undef_method :enabled_cipher_suites=
    
    # current CipherSuite. Never null, initially SSL_NULL_WITH_NULL_NULL
    attr_accessor :cipher_suite
    alias_method :attr_cipher_suite, :cipher_suite
    undef_method :cipher_suite
    alias_method :attr_cipher_suite=, :cipher_suite=
    undef_method :cipher_suite=
    
    # current key exchange. Never null, initially K_NULL
    attr_accessor :key_exchange
    alias_method :attr_key_exchange, :key_exchange
    undef_method :key_exchange
    alias_method :attr_key_exchange=, :key_exchange=
    undef_method :key_exchange=
    
    # True if this session is being resumed (fast handshake)
    attr_accessor :resuming_session
    alias_method :attr_resuming_session, :resuming_session
    undef_method :resuming_session
    alias_method :attr_resuming_session=, :resuming_session=
    undef_method :resuming_session=
    
    # True if it's OK to start a new SSL session
    attr_accessor :enable_new_session
    alias_method :attr_enable_new_session, :enable_new_session
    undef_method :enable_new_session
    alias_method :attr_enable_new_session=, :enable_new_session=
    undef_method :enable_new_session=
    
    # Temporary storage for the individual keys. Set by
    # calculateConnectionKeys() and cleared once the ciphers are
    # activated.
    attr_accessor :clnt_write_key
    alias_method :attr_clnt_write_key, :clnt_write_key
    undef_method :clnt_write_key
    alias_method :attr_clnt_write_key=, :clnt_write_key=
    undef_method :clnt_write_key=
    
    attr_accessor :svr_write_key
    alias_method :attr_svr_write_key, :svr_write_key
    undef_method :svr_write_key
    alias_method :attr_svr_write_key=, :svr_write_key=
    undef_method :svr_write_key=
    
    attr_accessor :clnt_write_iv
    alias_method :attr_clnt_write_iv, :clnt_write_iv
    undef_method :clnt_write_iv
    alias_method :attr_clnt_write_iv=, :clnt_write_iv=
    undef_method :clnt_write_iv=
    
    attr_accessor :svr_write_iv
    alias_method :attr_svr_write_iv, :svr_write_iv
    undef_method :svr_write_iv
    alias_method :attr_svr_write_iv=, :svr_write_iv=
    undef_method :svr_write_iv=
    
    attr_accessor :clnt_mac_secret
    alias_method :attr_clnt_mac_secret, :clnt_mac_secret
    undef_method :clnt_mac_secret
    alias_method :attr_clnt_mac_secret=, :clnt_mac_secret=
    undef_method :clnt_mac_secret=
    
    attr_accessor :svr_mac_secret
    alias_method :attr_svr_mac_secret, :svr_mac_secret
    undef_method :svr_mac_secret
    alias_method :attr_svr_mac_secret=, :svr_mac_secret=
    undef_method :svr_mac_secret=
    
    # Delegated task subsystem data structures.
    # 
    # If thrown is set, we need to propagate this back immediately
    # on entry into processMessage().
    # 
    # Data is protected by the SSLEngine.this lock.
    attr_accessor :task_delegated
    alias_method :attr_task_delegated, :task_delegated
    undef_method :task_delegated
    alias_method :attr_task_delegated=, :task_delegated=
    undef_method :task_delegated=
    
    attr_accessor :delegated_task
    alias_method :attr_delegated_task, :delegated_task
    undef_method :delegated_task
    alias_method :attr_delegated_task=, :delegated_task=
    undef_method :delegated_task=
    
    attr_accessor :thrown
    alias_method :attr_thrown, :thrown
    undef_method :thrown
    alias_method :attr_thrown=, :thrown=
    undef_method :thrown=
    
    # Could probably use a java.util.concurrent.atomic.AtomicReference
    # here instead of using this lock.  Consider changing.
    attr_accessor :thrown_lock
    alias_method :attr_thrown_lock, :thrown_lock
    undef_method :thrown_lock
    alias_method :attr_thrown_lock=, :thrown_lock=
    undef_method :thrown_lock=
    
    class_module.module_eval {
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    typesig { [SSLSocketImpl, SSLContextImpl, ProtocolList, ::Java::Boolean, ::Java::Boolean] }
    def initialize(c, context, enabled_protocols, need_cert_verify, is_client)
      @protocol_version = nil
      @enabled_protocols = nil
      @is_client = false
      @conn = nil
      @engine = nil
      @handshake_hash = nil
      @input = nil
      @output = nil
      @state = 0
      @ssl_context = nil
      @clnt_random = nil
      @svr_random = nil
      @session = nil
      @md5tmp = nil
      @sha_tmp = nil
      @enabled_cipher_suites = nil
      @cipher_suite = nil
      @key_exchange = nil
      @resuming_session = false
      @enable_new_session = false
      @clnt_write_key = nil
      @svr_write_key = nil
      @clnt_write_iv = nil
      @svr_write_iv = nil
      @clnt_mac_secret = nil
      @svr_mac_secret = nil
      @task_delegated = false
      @delegated_task = nil
      @thrown = nil
      @thrown_lock = Object.new
      @conn = c
      init(context, enabled_protocols, need_cert_verify, is_client)
    end
    
    typesig { [SSLEngineImpl, SSLContextImpl, ProtocolList, ::Java::Boolean, ::Java::Boolean] }
    def initialize(engine, context, enabled_protocols, need_cert_verify, is_client)
      @protocol_version = nil
      @enabled_protocols = nil
      @is_client = false
      @conn = nil
      @engine = nil
      @handshake_hash = nil
      @input = nil
      @output = nil
      @state = 0
      @ssl_context = nil
      @clnt_random = nil
      @svr_random = nil
      @session = nil
      @md5tmp = nil
      @sha_tmp = nil
      @enabled_cipher_suites = nil
      @cipher_suite = nil
      @key_exchange = nil
      @resuming_session = false
      @enable_new_session = false
      @clnt_write_key = nil
      @svr_write_key = nil
      @clnt_write_iv = nil
      @svr_write_iv = nil
      @clnt_mac_secret = nil
      @svr_mac_secret = nil
      @task_delegated = false
      @delegated_task = nil
      @thrown = nil
      @thrown_lock = Object.new
      @engine = engine
      init(context, enabled_protocols, need_cert_verify, is_client)
    end
    
    typesig { [SSLContextImpl, ProtocolList, ::Java::Boolean, ::Java::Boolean] }
    def init(context, enabled_protocols, need_cert_verify, is_client)
      @ssl_context = context
      @is_client = is_client
      @enable_new_session = true
      set_cipher_suite(CipherSuite::C_NULL)
      @md5tmp = JsseJce.get_md5
      @sha_tmp = JsseJce.get_sha
      # We accumulate digests of the handshake messages so that
      # we can read/write CertificateVerify and Finished messages,
      # getting assurance against some particular active attacks.
      @handshake_hash = HandshakeHash.new(need_cert_verify)
      set_enabled_protocols(enabled_protocols)
      if (!(@conn).nil?)
        @conn.get_app_input_stream.attr_r.set_handshake_hash(@handshake_hash)
      else
        # engine != null
        @engine.attr_input_record.set_handshake_hash(@handshake_hash)
      end
      # In addition to the connection state machine, controlling
      # how the connection deals with the different sorts of records
      # that get sent (notably handshake transitions!), there's
      # also a handshaking state machine that controls message
      # sequencing.
      # 
      # It's a convenient artifact of the protocol that this can,
      # with only a couple of minor exceptions, be driven by the
      # type constant for the last message seen:  except for the
      # client's cert verify, those constants are in a convenient
      # order to drastically simplify state machine checking.
      @state = -1
    end
    
    typesig { [::Java::Byte, String] }
    # Reroutes calls to the SSLSocket or SSLEngine (*SE).
    # 
    # We could have also done it by extra classes
    # and letting them override, but this seemed much
    # less involved.
    def fatal_se(b, diagnostic)
      fatal_se(b, diagnostic, nil)
    end
    
    typesig { [::Java::Byte, JavaThrowable] }
    def fatal_se(b, cause)
      fatal_se(b, nil, cause)
    end
    
    typesig { [::Java::Byte, String, JavaThrowable] }
    def fatal_se(b, diagnostic, cause)
      if (!(@conn).nil?)
        @conn.fatal(b, diagnostic, cause)
      else
        @engine.fatal(b, diagnostic, cause)
      end
    end
    
    typesig { [::Java::Byte] }
    def warning_se(b)
      if (!(@conn).nil?)
        @conn.warning(b)
      else
        @engine.warning(b)
      end
    end
    
    typesig { [] }
    def get_host_se
      if (!(@conn).nil?)
        return @conn.get_host
      else
        return @engine.get_peer_host
      end
    end
    
    typesig { [] }
    def get_host_address_se
      if (!(@conn).nil?)
        return @conn.get_inet_address.get_host_address
      else
        # This is for caching only, doesn't matter that's is really
        # a hostname.  The main thing is that it doesn't do
        # a reverse DNS lookup, potentially slowing things down.
        return @engine.get_peer_host
      end
    end
    
    typesig { [] }
    def is_loopback_se
      if (!(@conn).nil?)
        return @conn.get_inet_address.is_loopback_address
      else
        return false
      end
    end
    
    typesig { [] }
    def get_port_se
      if (!(@conn).nil?)
        return @conn.get_port
      else
        return @engine.get_peer_port
      end
    end
    
    typesig { [] }
    def get_local_port_se
      if (!(@conn).nil?)
        return @conn.get_local_port
      else
        return -1
      end
    end
    
    typesig { [] }
    def get_hostname_verification_se
      if (!(@conn).nil?)
        return @conn.get_hostname_verification
      else
        return @engine.get_hostname_verification
      end
    end
    
    typesig { [] }
    def get_acc_se
      if (!(@conn).nil?)
        return @conn.get_acc
      else
        return @engine.get_acc
      end
    end
    
    typesig { [ProtocolVersion] }
    def set_version_se(protocol_version)
      if (!(@conn).nil?)
        @conn.set_version(protocol_version)
      else
        @engine.set_version(protocol_version)
      end
    end
    
    typesig { [ProtocolVersion] }
    # Set the active protocol version and propagate it to the SSLSocket
    # and our handshake streams. Called from ClientHandshaker
    # and ServerHandshaker with the negotiated protocol version.
    def set_version(protocol_version)
      @protocol_version = protocol_version
      set_version_se(protocol_version)
      @output.attr_r.set_version(protocol_version)
    end
    
    typesig { [ProtocolList] }
    # Set the enabled protocols. Called from the constructor or
    # SSLSocketImpl.setEnabledProtocols() (if the handshake is not yet
    # in progress).
    def set_enabled_protocols(enabled_protocols)
      @enabled_protocols = enabled_protocols
      # temporary protocol version until the actual protocol version
      # is negotiated in the Hello exchange. This affects the record
      # version we sent with the ClientHello. Using max() as the record
      # version is not really correct but some implementations fail to
      # correctly negotiate TLS otherwise.
      @protocol_version = enabled_protocols.attr_max
      hello_version = enabled_protocols.attr_hello_version
      @input = HandshakeInStream.new(@handshake_hash)
      if (!(@conn).nil?)
        @output = HandshakeOutStream.new(@protocol_version, hello_version, @handshake_hash, @conn)
        @conn.get_app_input_stream.attr_r.set_hello_version(hello_version)
      else
        @output = HandshakeOutStream.new(@protocol_version, hello_version, @handshake_hash, @engine)
        @engine.attr_output_record.set_hello_version(hello_version)
      end
    end
    
    typesig { [CipherSuite] }
    # Set cipherSuite and keyExchange to the given CipherSuite.
    # Does not perform any verification that this is a valid selection,
    # this must be done before calling this method.
    def set_cipher_suite(s)
      @cipher_suite = s
      @key_exchange = s.attr_key_exchange
    end
    
    typesig { [CipherSuite] }
    # Check if the given ciphersuite is enabled and available.
    # (Enabled ciphersuites are always available unless the status has
    # changed due to change in JCE providers since it was enabled).
    # Does not check if the required server certificates are available.
    def is_enabled(s)
      return @enabled_cipher_suites.contains(s) && s.is_available
    end
    
    typesig { [::Java::Boolean] }
    # As long as handshaking has not started, we can
    # change whether session creations are allowed.
    # 
    # Callers should do their own checking if handshaking
    # has started.
    def set_enable_session_creation(new_sessions)
      @enable_new_session = new_sessions
    end
    
    typesig { [] }
    # Create a new read cipher and return it to caller.
    def new_read_cipher
      cipher = @cipher_suite.attr_cipher
      box = nil
      if (@is_client)
        box = cipher.new_cipher(@protocol_version, @svr_write_key, @svr_write_iv, false)
        @svr_write_key = nil
        @svr_write_iv = nil
      else
        box = cipher.new_cipher(@protocol_version, @clnt_write_key, @clnt_write_iv, false)
        @clnt_write_key = nil
        @clnt_write_iv = nil
      end
      return box
    end
    
    typesig { [] }
    # Create a new write cipher and return it to caller.
    def new_write_cipher
      cipher = @cipher_suite.attr_cipher
      box = nil
      if (@is_client)
        box = cipher.new_cipher(@protocol_version, @clnt_write_key, @clnt_write_iv, true)
        @clnt_write_key = nil
        @clnt_write_iv = nil
      else
        box = cipher.new_cipher(@protocol_version, @svr_write_key, @svr_write_iv, true)
        @svr_write_key = nil
        @svr_write_iv = nil
      end
      return box
    end
    
    typesig { [] }
    # Create a new read MAC and return it to caller.
    def new_read_mac
      mac_alg = @cipher_suite.attr_mac_alg
      mac = nil
      if (@is_client)
        mac = mac_alg.new_mac(@protocol_version, @svr_mac_secret)
        @svr_mac_secret = nil
      else
        mac = mac_alg.new_mac(@protocol_version, @clnt_mac_secret)
        @clnt_mac_secret = nil
      end
      return mac
    end
    
    typesig { [] }
    # Create a new write MAC and return it to caller.
    def new_write_mac
      mac_alg = @cipher_suite.attr_mac_alg
      mac = nil
      if (@is_client)
        mac = mac_alg.new_mac(@protocol_version, @clnt_mac_secret)
        @clnt_mac_secret = nil
      else
        mac = mac_alg.new_mac(@protocol_version, @svr_mac_secret)
        @svr_mac_secret = nil
      end
      return mac
    end
    
    typesig { [] }
    # Returns true iff the handshake sequence is done, so that
    # this freshly created session can become the current one.
    def is_done
      return (@state).equal?(HandshakeMessage.attr_ht_finished)
    end
    
    typesig { [] }
    # Returns the session which was created through this
    # handshake sequence ... should be called after isDone()
    # returns true.
    def get_session
      return @session
    end
    
    typesig { [InputRecord, ::Java::Boolean] }
    # This routine is fed SSL handshake records when they become available,
    # and processes messages found therein.
    def process_record(r, expecting_finished)
      check_thrown
      # Store the incoming handshake data, then see if we can
      # now process any completed handshake messages
      @input.incoming_record(r)
      # We don't need to create a separate delegatable task
      # for finished messages.
      if ((!(@conn).nil?) || expecting_finished)
        process_loop
      else
        delegate_task(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members Handshaker
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            process_loop
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [] }
    # On input, we hash messages one at a time since servers may need
    # to access an intermediate hash to validate a CertificateVerify
    # message.
    # 
    # Note that many handshake messages can come in one record (and often
    # do, to reduce network resource utilization), and one message can also
    # require multiple records (e.g. very large Certificate messages).
    def process_loop
      while (@input.available > 0)
        message_type = 0
        message_len = 0
        # See if we can read the handshake message header, and
        # then the entire handshake message.  If not, wait till
        # we can read and process an entire message.
        @input.mark(4)
        message_type = @input.get_int8
        message_len = @input.get_int24
        if (@input.available < message_len)
          @input.reset
          return
        end
        # Process the messsage.  We require
        # that processMessage() consumes the entire message.  In
        # lieu of explicit error checks (how?!) we assume that the
        # data will look like garbage on encoding/processing errors,
        # and that other protocol code will detect such errors.
        # 
        # Note that digesting is normally deferred till after the
        # message has been processed, though to process at least the
        # client's Finished message (i.e. send the server's) we need
        # to acccelerate that digesting.
        # 
        # Also, note that hello request messages are never hashed;
        # that includes the hello request header, too.
        if ((message_type).equal?(HandshakeMessage.attr_ht_hello_request))
          @input.reset
          process_message(message_type, message_len)
          @input.ignore(4 + message_len)
        else
          @input.mark(message_len)
          process_message(message_type, message_len)
          @input.digest_now
        end
      end
    end
    
    typesig { [] }
    # Returns true iff the handshaker has sent any messages.
    # Server kickstarting is not as neat as it should be; we
    # need to create a new handshaker, this method lets us
    # know if we should.
    def started
      return @state >= 0
    end
    
    typesig { [] }
    # Used to kickstart the negotiation ... either writing a
    # ClientHello or a HelloRequest as appropriate, whichever
    # the subclass returns.  NOP if handshaking's already started.
    def kickstart
      if (@state >= 0)
        return
      end
      m = get_kickstart_message
      if (!(Debug).nil? && Debug.is_on("handshake"))
        m.print(System.out)
      end
      m.write(@output)
      @output.flush
      @state = m.message_type
    end
    
    typesig { [] }
    # Both client and server modes can start handshaking; but the
    # message they send to do so is different.
    def get_kickstart_message
      raise NotImplementedError
    end
    
    typesig { [::Java::Byte, ::Java::Int] }
    # Client and Server side protocols are each driven though this
    # call, which processes a single message and drives the appropriate
    # side of the protocol state machine (depending on the subclass).
    def process_message(message_type_, message_len)
      raise NotImplementedError
    end
    
    typesig { [::Java::Byte] }
    # Most alerts in the protocol relate to handshaking problems.
    # Alerts are detected as the connection reads data.
    def handshake_alert(description)
      raise NotImplementedError
    end
    
    typesig { [Finished, ::Java::Boolean] }
    # Sends a change cipher spec message and updates the write side
    # cipher state so that future messages use the just-negotiated spec.
    def send_change_cipher_spec(mesg, last_message)
      @output.flush # i.e. handshake data
      # The write cipher state is protected by the connection write lock
      # so we must grab it while making the change. We also
      # make sure no writes occur between sending the ChangeCipherSpec
      # message, installing the new cipher state, and sending the
      # Finished message.
      # 
      # We already hold SSLEngine/SSLSocket "this" by virtue
      # of this being called from the readRecord code.
      r = nil
      if (!(@conn).nil?)
        r = OutputRecord.new(Record.attr_ct_change_cipher_spec)
      else
        r = EngineOutputRecord.new(Record.attr_ct_change_cipher_spec, @engine)
      end
      r.set_version(@protocol_version)
      r.write(1) # single byte of data
      if (!(@conn).nil?)
        @conn.attr_write_lock.lock
        begin
          @conn.write_record(r)
          @conn.change_write_ciphers
          if (!(Debug).nil? && Debug.is_on("handshake"))
            mesg.print(System.out)
          end
          mesg.write(@output)
          @output.flush
        ensure
          @conn.attr_write_lock.unlock
        end
      else
        synchronized((@engine.attr_write_lock)) do
          @engine.write_record(r)
          @engine.change_write_ciphers
          if (!(Debug).nil? && Debug.is_on("handshake"))
            mesg.print(System.out)
          end
          mesg.write(@output)
          if (last_message)
            @output.set_finished_msg
          end
          @output.flush
        end
      end
    end
    
    typesig { [SecretKey, ProtocolVersion] }
    # Single access point to key calculation logic.  Given the
    # pre-master secret and the nonces from client and server,
    # produce all the keying material to be used.
    def calculate_keys(pre_master_secret, version)
      master = calculate_master_secret(pre_master_secret, version)
      @session.set_master_secret(master)
      calculate_connection_keys(master)
    end
    
    typesig { [SecretKey, ProtocolVersion] }
    # Calculate the master secret from its various components.  This is
    # used for key exchange by all cipher suites.
    # 
    # The master secret is the catenation of three MD5 hashes, each
    # consisting of the pre-master secret and a SHA1 hash.  Those three
    # SHA1 hashes are of (different) constant strings, the pre-master
    # secret, and the nonces provided by the client and the server.
    def calculate_master_secret(pre_master_secret, requested_version)
      spec = TlsMasterSecretParameterSpec.new(pre_master_secret, @protocol_version.attr_major, @protocol_version.attr_minor, @clnt_random.attr_random_bytes, @svr_random.attr_random_bytes)
      if (!(Debug).nil? && Debug.is_on("keygen"))
        dump = HexDumpEncoder.new
        System.out.println("SESSION KEYGEN:")
        System.out.println("PreMaster Secret:")
        print_hex(dump, pre_master_secret.get_encoded)
        # Nonces are dumped with connection keygen, no
        # benefit to doing it twice
      end
      master_secret = nil
      begin
        kg = JsseJce.get_key_generator("SunTlsMasterSecret")
        kg.init(spec)
        master_secret = kg.generate_key
      rescue GeneralSecurityException => e
        # For RSA premaster secrets, do not signal a protocol error
        # due to the Bleichenbacher attack. See comments further down.
        if (!(pre_master_secret.get_algorithm == "TlsRsaPremasterSecret"))
          raise ProviderException.new(e)
        end
        if (!(Debug).nil? && Debug.is_on("handshake"))
          System.out.println("RSA master secret generation error:")
          e.print_stack_trace(System.out)
          System.out.println("Generating new random premaster secret")
        end
        pre_master_secret = RSAClientKeyExchange.generate_dummy_secret(@protocol_version)
        # recursive call with new premaster secret
        return calculate_master_secret(pre_master_secret, nil)
      end
      # if no version check requested (client side handshake),
      # or version information is not available (not an RSA premaster secret),
      # return master secret immediately.
      if (((requested_version).nil?) || !(master_secret.is_a?(TlsMasterSecret)))
        return master_secret
      end
      tls_key = master_secret
      major = tls_key.get_major_version
      minor = tls_key.get_minor_version
      if ((major < 0) || (minor < 0))
        return master_secret
      end
      # check if the premaster secret version is ok
      # the specification says that it must be the maximum version supported
      # by the client from its ClientHello message. However, many
      # implementations send the negotiated version, so accept both
      # NOTE that we may be comparing two unsupported version numbers in
      # the second case, which is why we cannot use object reference
      # equality in this special case
      premaster_version = ProtocolVersion.value_of(major, minor)
      version_mismatch = (!(premaster_version).equal?(@protocol_version)) && (!(premaster_version.attr_v).equal?(requested_version.attr_v))
      if ((version_mismatch).equal?(false))
        # check passed, return key
        return master_secret
      end
      # Due to the Bleichenbacher attack, do not signal a protocol error.
      # Generate a random premaster secret and continue with the handshake,
      # which will fail when verifying the finished messages.
      # For more information, see comments in PreMasterSecret.
      if (!(Debug).nil? && Debug.is_on("handshake"))
        System.out.println("RSA PreMasterSecret version error: expected" + RJava.cast_to_string(@protocol_version) + " or " + RJava.cast_to_string(requested_version) + ", decrypted: " + RJava.cast_to_string(premaster_version))
        System.out.println("Generating new random premaster secret")
      end
      pre_master_secret = RSAClientKeyExchange.generate_dummy_secret(@protocol_version)
      # recursive call with new premaster secret
      return calculate_master_secret(pre_master_secret, nil)
    end
    
    typesig { [SecretKey] }
    # Calculate the keys needed for this connection, once the session's
    # master secret has been calculated.  Uses the master key and nonces;
    # the amount of keying material generated is a function of the cipher
    # suite that's been negotiated.
    # 
    # This gets called both on the "full handshake" (where we exchanged
    # a premaster secret and started a new session) as well as on the
    # "fast handshake" (where we just resumed a pre-existing session).
    def calculate_connection_keys(master_key)
      # For both the read and write sides of the protocol, we use the
      # master to generate MAC secrets and cipher keying material.  Block
      # ciphers need initialization vectors, which we also generate.
      # 
      # First we figure out how much keying material is needed.
      hash_size = @cipher_suite.attr_mac_alg.attr_size
      is_exportable = @cipher_suite.attr_exportable
      cipher = @cipher_suite.attr_cipher
      key_size = cipher.attr_key_size
      iv_size = cipher.attr_iv_size
      expanded_key_size = is_exportable ? cipher.attr_expanded_key_size : 0
      spec = TlsKeyMaterialParameterSpec.new(master_key, @protocol_version.attr_major, @protocol_version.attr_minor, @clnt_random.attr_random_bytes, @svr_random.attr_random_bytes, cipher.attr_algorithm, cipher.attr_key_size, expanded_key_size, cipher.attr_iv_size, hash_size)
      begin
        kg = JsseJce.get_key_generator("SunTlsKeyMaterial")
        kg.init(spec)
        key_spec = kg.generate_key
        @clnt_write_key = key_spec.get_client_cipher_key
        @svr_write_key = key_spec.get_server_cipher_key
        @clnt_write_iv = key_spec.get_client_iv
        @svr_write_iv = key_spec.get_server_iv
        @clnt_mac_secret = key_spec.get_client_mac_key
        @svr_mac_secret = key_spec.get_server_mac_key
      rescue GeneralSecurityException => e
        raise ProviderException.new(e)
      end
      # Dump the connection keys as they're generated.
      if (!(Debug).nil? && Debug.is_on("keygen"))
        synchronized((System.out)) do
          dump = HexDumpEncoder.new
          System.out.println("CONNECTION KEYGEN:")
          # Inputs:
          System.out.println("Client Nonce:")
          print_hex(dump, @clnt_random.attr_random_bytes)
          System.out.println("Server Nonce:")
          print_hex(dump, @svr_random.attr_random_bytes)
          System.out.println("Master Secret:")
          print_hex(dump, master_key.get_encoded)
          # Outputs:
          System.out.println("Client MAC write Secret:")
          print_hex(dump, @clnt_mac_secret.get_encoded)
          System.out.println("Server MAC write Secret:")
          print_hex(dump, @svr_mac_secret.get_encoded)
          if (!(@clnt_write_key).nil?)
            System.out.println("Client write key:")
            print_hex(dump, @clnt_write_key.get_encoded)
            System.out.println("Server write key:")
            print_hex(dump, @svr_write_key.get_encoded)
          else
            System.out.println("... no encryption keys used")
          end
          if (!(@clnt_write_iv).nil?)
            System.out.println("Client write IV:")
            print_hex(dump, @clnt_write_iv.get_iv)
            System.out.println("Server write IV:")
            print_hex(dump, @svr_write_iv.get_iv)
          else
            System.out.println("... no IV used for this cipher")
          end
          System.out.flush
        end
      end
    end
    
    class_module.module_eval {
      typesig { [HexDumpEncoder, Array.typed(::Java::Byte)] }
      def print_hex(dump, bytes)
        if ((bytes).nil?)
          System.out.println("(key bytes not available)")
        else
          begin
            dump.encode_buffer(bytes, System.out)
          rescue IOException => e
            # just for debugging, ignore this
          end
        end
      end
      
      typesig { [String, JavaThrowable] }
      # Throw an SSLException with the specified message and cause.
      # Shorthand until a new SSLException constructor is added.
      # This method never returns.
      def throw_sslexception(msg, cause)
        e = SSLException.new(msg)
        e.init_cause(cause)
        raise e
      end
      
      # Implement a simple task delegator.
      # 
      # We are currently implementing this as a single delegator, may
      # try for parallel tasks later.  Client Authentication could
      # benefit from this, where ClientKeyExchange/CertificateVerify
      # could be carried out in parallel.
      const_set_lazy(:DelegatedTask) { Class.new do
        extend LocalClass
        include_class_members Handshaker
        include Runnable
        
        attr_accessor :pea
        alias_method :attr_pea, :pea
        undef_method :pea
        alias_method :attr_pea=, :pea=
        undef_method :pea=
        
        typesig { [class_self::PrivilegedExceptionAction] }
        def initialize(pea)
          @pea = nil
          @pea = pea
        end
        
        typesig { [] }
        def run
          synchronized((self.attr_engine)) do
            begin
              AccessController.do_privileged(@pea, self.attr_engine.get_acc)
            rescue self.class::PrivilegedActionException => pae
              self.attr_thrown = pae.get_exception
            rescue self.class::RuntimeException => rte
              self.attr_thrown = rte
            end
            self.attr_delegated_task = nil
            self.attr_task_delegated = false
          end
        end
        
        private
        alias_method :initialize__delegated_task, :initialize
      end }
    }
    
    typesig { [PrivilegedExceptionAction] }
    def delegate_task(pea)
      @delegated_task = DelegatedTask.new_local(self, pea)
      @task_delegated = false
      @thrown = nil
    end
    
    typesig { [] }
    def get_task
      if (!@task_delegated)
        @task_delegated = true
        return @delegated_task
      else
        return nil
      end
    end
    
    typesig { [] }
    # See if there are any tasks which need to be delegated
    # 
    # Locked by SSLEngine.this.
    def task_outstanding
      return (!(@delegated_task).nil?)
    end
    
    typesig { [] }
    # The previous caller failed for some reason, report back the
    # Exception.  We won't worry about Error's.
    # 
    # Locked by SSLEngine.this.
    def check_thrown
      synchronized((@thrown_lock)) do
        if (!(@thrown).nil?)
          msg = @thrown.get_message
          if ((msg).nil?)
            msg = "Delegated task threw Exception/Error"
          end
          # See what the underlying type of exception is.  We should
          # throw the same thing.  Chain thrown to the new exception.
          e = @thrown
          @thrown = nil
          if (e.is_a?(RuntimeException))
            raise RuntimeException.new(msg).init_cause(e)
          else
            if (e.is_a?(SSLHandshakeException))
              raise SSLHandshakeException.new(msg).init_cause(e)
            else
              if (e.is_a?(SSLKeyException))
                raise SSLKeyException.new(msg).init_cause(e)
              else
                if (e.is_a?(SSLPeerUnverifiedException))
                  raise SSLPeerUnverifiedException.new(msg).init_cause(e)
                else
                  if (e.is_a?(SSLProtocolException))
                    raise SSLProtocolException.new(msg).init_cause(e)
                  else
                    # If it's SSLException or any other Exception,
                    # we'll wrap it in an SSLException.
                    raise SSLException.new(msg).init_cause(e)
                  end
                end
              end
            end
          end
        end
      end
    end
    
    private
    alias_method :initialize__handshaker, :initialize
  end
  
end
