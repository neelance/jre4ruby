require "rjava"

# Copyright 1996-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SSLSocketImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Net
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedAction
      include ::Java::Util
      include_const ::Java::Util::Concurrent, :TimeUnit
      include_const ::Java::Util::Concurrent::Locks, :ReentrantLock
      include_const ::Javax::Crypto, :BadPaddingException
      include ::Javax::Net::Ssl
      include_const ::Com::Sun::Net::Ssl::Internal::Ssl, :X509ExtendedTrustManager
    }
  end
  
  # Implementation of an SSL socket.  This is a normal connection type
  # socket, implementing SSL over some lower level socket, such as TCP.
  # Because it is layered over some lower level socket, it MUST override
  # all default socket methods.
  # 
  # <P> This API offers a non-traditional option for establishing SSL
  # connections.  You may first establish the connection directly, then pass
  # that connection to the SSL socket constructor with a flag saying which
  # role should be taken in the handshake protocol.  (The two ends of the
  # connection must not choose the same role!)  This allows setup of SSL
  # proxying or tunneling, and also allows the kind of "role reversal"
  # that is required for most FTP data transfers.
  # 
  # @see javax.net.ssl.SSLSocket
  # @see SSLServerSocket
  # 
  # @author David Brownell
  class SSLSocketImpl < SSLSocketImplImports.const_get :BaseSSLSocketImpl
    include_class_members SSLSocketImplImports
    
    class_module.module_eval {
      # ERROR HANDLING GUIDELINES
      # (which exceptions to throw and catch and which not to throw and catch)
      # 
      # . if there is an IOException (SocketException) when accessing the
      # underlying Socket, pass it through
      # 
      # . do not throw IOExceptions, throw SSLExceptions (or a subclass)
      # 
      # . for internal errors (things that indicate a bug in JSSE or a
      # grossly misconfigured J2RE), throw either an SSLException or
      # a RuntimeException at your convenience.
      # 
      # . handshaking code (Handshaker or HandshakeMessage) should generally
      # pass through exceptions, but can handle them if they know what to
      # do.
      # 
      # . exception chaining should be used for all new code. If you happen
      # to touch old code that does not use chaining, you should change it.
      # 
      # . there is a top level exception handler that sits at all entry
      # points from application code to SSLSocket read/write code. It
      # makes sure that all errors are handled (see handleException()).
      # 
      # . JSSE internal code should generally not call close(), call
      # closeInternal().
      # 
      # 
      # There's a state machine associated with each connection, which
      # among other roles serves to negotiate session changes.
      # 
      # - START with constructor, until the TCP connection's around.
      # - HANDSHAKE picks session parameters before allowing traffic.
      # There are many substates due to sequencing requirements
      # for handshake messages.
      # - DATA may be transmitted.
      # - RENEGOTIATE state allows concurrent data and handshaking
      # traffic ("same" substates as HANDSHAKE), and terminates
      # in selection of new session (and connection) parameters
      # - ERROR state immediately precedes abortive disconnect.
      # - SENT_CLOSE sent a close_notify to the peer. For layered,
      # non-autoclose socket, must now read close_notify
      # from peer before closing the connection. For nonlayered or
      # non-autoclose socket, close connection and go onto
      # cs_CLOSED state.
      # - CLOSED after sending close_notify alert, & socket is closed.
      # SSL connection objects are not reused.
      # - APP_CLOSED once the application calls close(). Then it behaves like
      # a closed socket, e.g.. getInputStream() throws an Exception.
      # 
      # State affects what SSL record types may legally be sent:
      # 
      # - Handshake ... only in HANDSHAKE and RENEGOTIATE states
      # - App Data ... only in DATA and RENEGOTIATE states
      # - Alert ... in HANDSHAKE, DATA, RENEGOTIATE
      # 
      # Re what may be received:  same as what may be sent, except that
      # HandshakeRequest handshaking messages can come from servers even
      # in the application data state, to request entry to RENEGOTIATE.
      # 
      # The state machine within HANDSHAKE and RENEGOTIATE states controls
      # the pending session, not the connection state, until the change
      # cipher spec and "Finished" handshake messages are processed and
      # make the "new" session become the current one.
      # 
      # NOTE: details of the SMs always need to be nailed down better.
      # The text above illustrates the core ideas.
      # 
      # +---->-------+------>--------->-------+
      # |            |                        |
      # <-----<    ^            ^  <-----<               v
      # START>----->HANDSHAKE>----->DATA>----->RENEGOTIATE  SENT_CLOSE
      # v            v               v        |   |
      # |            |               |        |   v
      # +------------+---------------+        v ERROR
      # |                                     |   |
      # v                                     |   |
      # ERROR>------>----->CLOSED<--------<----+-- +
      # |
      # v
      # APP_CLOSED
      # 
      # ALSO, note that the the purpose of handshaking (renegotiation is
      # included) is to assign a different, and perhaps new, session to
      # the connection.  The SSLv3 spec is a bit confusing on that new
      # protocol feature.
      const_set_lazy(:Cs_START) { 0 }
      const_attr_reader  :Cs_START
      
      const_set_lazy(:Cs_HANDSHAKE) { 1 }
      const_attr_reader  :Cs_HANDSHAKE
      
      const_set_lazy(:Cs_DATA) { 2 }
      const_attr_reader  :Cs_DATA
      
      const_set_lazy(:Cs_RENEGOTIATE) { 3 }
      const_attr_reader  :Cs_RENEGOTIATE
      
      const_set_lazy(:Cs_ERROR) { 4 }
      const_attr_reader  :Cs_ERROR
      
      const_set_lazy(:Cs_SENT_CLOSE) { 5 }
      const_attr_reader  :Cs_SENT_CLOSE
      
      const_set_lazy(:Cs_CLOSED) { 6 }
      const_attr_reader  :Cs_CLOSED
      
      const_set_lazy(:Cs_APP_CLOSED) { 7 }
      const_attr_reader  :Cs_APP_CLOSED
    }
    
    # Client authentication be off, requested, or required.
    # 
    # Migrated to SSLEngineImpl:
    # clauth_none/cl_auth_requested/clauth_required
    # 
    # 
    # Drives the protocol state machine.
    attr_accessor :connection_state
    alias_method :attr_connection_state, :connection_state
    undef_method :connection_state
    alias_method :attr_connection_state=, :connection_state=
    undef_method :connection_state=
    
    # Flag indicating if the next record we receive MUST be a Finished
    # message. Temporarily set during the handshake to ensure that
    # a change cipher spec message is followed by a finished message.
    attr_accessor :expecting_finished
    alias_method :attr_expecting_finished, :expecting_finished
    undef_method :expecting_finished
    alias_method :attr_expecting_finished=, :expecting_finished=
    undef_method :expecting_finished=
    
    # For improved diagnostics, we detail connection closure
    # If the socket is closed (connectionState >= cs_ERROR),
    # closeReason != null indicates if the socket was closed
    # because of an error or because or normal shutdown.
    attr_accessor :close_reason
    alias_method :attr_close_reason, :close_reason
    undef_method :close_reason
    alias_method :attr_close_reason=, :close_reason=
    undef_method :close_reason=
    
    # Per-connection private state that doesn't change when the
    # session is changed.
    attr_accessor :do_client_auth
    alias_method :attr_do_client_auth, :do_client_auth
    undef_method :do_client_auth
    alias_method :attr_do_client_auth=, :do_client_auth=
    undef_method :do_client_auth=
    
    attr_accessor :role_is_server
    alias_method :attr_role_is_server, :role_is_server
    undef_method :role_is_server
    alias_method :attr_role_is_server=, :role_is_server=
    undef_method :role_is_server=
    
    attr_accessor :enabled_cipher_suites
    alias_method :attr_enabled_cipher_suites, :enabled_cipher_suites
    undef_method :enabled_cipher_suites
    alias_method :attr_enabled_cipher_suites=, :enabled_cipher_suites=
    undef_method :enabled_cipher_suites=
    
    attr_accessor :enable_session_creation
    alias_method :attr_enable_session_creation, :enable_session_creation
    undef_method :enable_session_creation
    alias_method :attr_enable_session_creation=, :enable_session_creation=
    undef_method :enable_session_creation=
    
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    attr_accessor :auto_close
    alias_method :attr_auto_close, :auto_close
    undef_method :auto_close
    alias_method :attr_auto_close=, :auto_close=
    undef_method :auto_close=
    
    attr_accessor :acc
    alias_method :attr_acc, :acc
    undef_method :acc
    alias_method :attr_acc=, :acc=
    undef_method :acc=
    
    # hostname identification algorithm, the hostname identification is
    # disabled by default.
    attr_accessor :identification_alg
    alias_method :attr_identification_alg, :identification_alg
    undef_method :identification_alg
    alias_method :attr_identification_alg=, :identification_alg=
    undef_method :identification_alg=
    
    # READ ME * READ ME * READ ME * READ ME * READ ME * READ ME *
    # IMPORTANT STUFF TO UNDERSTANDING THE SYNCHRONIZATION ISSUES.
    # READ ME * READ ME * READ ME * READ ME * READ ME * READ ME *
    # 
    # There are several locks here.
    # 
    # The primary lock is the per-instance lock used by
    # synchronized(this) and the synchronized methods.  It controls all
    # access to things such as the connection state and variables which
    # affect handshaking.  If we are inside a synchronized method, we
    # can access the state directly, otherwise, we must use the
    # synchronized equivalents.
    # 
    # The handshakeLock is used to ensure that only one thread performs
    # the *complete initial* handshake.  If someone is handshaking, any
    # stray application or startHandshake() requests who find the
    # connection state is cs_HANDSHAKE will stall on handshakeLock
    # until handshaking is done.  Once the handshake is done, we either
    # succeeded or failed, but we can never go back to the cs_HANDSHAKE
    # or cs_START state again.
    # 
    # Note that the read/write() calls here in SSLSocketImpl are not
    # obviously synchronized.  In fact, it's very nonintuitive, and
    # requires careful examination of code paths.  Grab some coffee,
    # and be careful with any code changes.
    # 
    # There can be only three threads active at a time in the I/O
    # subsection of this class.
    # 1.  startHandshake
    # 2.  AppInputStream
    # 3.  AppOutputStream
    # One thread could call startHandshake().
    # AppInputStream/AppOutputStream read() and write() calls are each
    # synchronized on 'this' in their respective classes, so only one
    # app. thread will be doing a SSLSocketImpl.read() or .write()'s at
    # a time.
    # 
    # If handshaking is required (state cs_HANDSHAKE), and
    # getConnectionState() for some/all threads returns cs_HANDSHAKE,
    # only one can grab the handshakeLock, and the rest will stall
    # either on getConnectionState(), or on the handshakeLock if they
    # happen to successfully race through the getConnectionState().
    # 
    # If a writer is doing the initial handshaking, it must create a
    # temporary reader to read the responses from the other side.  As a
    # side-effect, the writer's reader will have priority over any
    # other reader.  However, the writer's reader is not allowed to
    # consume any application data.  When handshakeLock is finally
    # released, we either have a cs_DATA connection, or a
    # cs_CLOSED/cs_ERROR socket.
    # 
    # The writeLock is held while writing on a socket connection and
    # also to protect the MAC and cipher for their direction.  The
    # writeLock is package private for Handshaker which holds it while
    # writing the ChangeCipherSpec message.
    # 
    # To avoid the problem of a thread trying to change operational
    # modes on a socket while handshaking is going on, we synchronize
    # on 'this'.  If handshaking has not started yet, we tell the
    # handshaker to change its mode.  If handshaking has started,
    # we simply store that request until the next pending session
    # is created, at which time the new handshaker's state is set.
    # 
    # The readLock is held during readRecord(), which is responsible
    # for reading an InputRecord, decrypting it, and processing it.
    # The readLock ensures that these three steps are done atomically
    # and that once started, no other thread can block on InputRecord.read.
    # This is necessary so that processing of close_notify alerts
    # from the peer are handled properly.
    attr_accessor :handshake_lock
    alias_method :attr_handshake_lock, :handshake_lock
    undef_method :handshake_lock
    alias_method :attr_handshake_lock=, :handshake_lock=
    undef_method :handshake_lock=
    
    attr_accessor :write_lock
    alias_method :attr_write_lock, :write_lock
    undef_method :write_lock
    alias_method :attr_write_lock=, :write_lock=
    undef_method :write_lock=
    
    attr_accessor :read_lock
    alias_method :attr_read_lock, :read_lock
    undef_method :read_lock
    alias_method :attr_read_lock=, :read_lock=
    undef_method :read_lock=
    
    attr_accessor :inrec
    alias_method :attr_inrec, :inrec
    undef_method :inrec
    alias_method :attr_inrec=, :inrec=
    undef_method :inrec=
    
    # Crypto state that's reinitialized when the session changes.
    attr_accessor :read_mac
    alias_method :attr_read_mac, :read_mac
    undef_method :read_mac
    alias_method :attr_read_mac=, :read_mac=
    undef_method :read_mac=
    
    attr_accessor :write_mac
    alias_method :attr_write_mac, :write_mac
    undef_method :write_mac
    alias_method :attr_write_mac=, :write_mac=
    undef_method :write_mac=
    
    attr_accessor :read_cipher
    alias_method :attr_read_cipher, :read_cipher
    undef_method :read_cipher
    alias_method :attr_read_cipher=, :read_cipher=
    undef_method :read_cipher=
    
    attr_accessor :write_cipher
    alias_method :attr_write_cipher, :write_cipher
    undef_method :write_cipher
    alias_method :attr_write_cipher=, :write_cipher=
    undef_method :write_cipher=
    
    # NOTE: compression state would be saved here
    # 
    # The authentication context holds all information used to establish
    # who this end of the connection is (certificate chains, private keys,
    # etc) and who is trusted (e.g. as CAs or websites).
    attr_accessor :ssl_context
    alias_method :attr_ssl_context, :ssl_context
    undef_method :ssl_context
    alias_method :attr_ssl_context=, :ssl_context=
    undef_method :ssl_context=
    
    # This connection is one of (potentially) many associated with
    # any given session.  The output of the handshake protocol is a
    # new session ... although all the protocol description talks
    # about changing the cipher spec (and it does change), in fact
    # that's incidental since it's done by changing everything that
    # is associated with a session at the same time.  (TLS/IETF may
    # change that to add client authentication w/o new key exchg.)
    attr_accessor :sess
    alias_method :attr_sess, :sess
    undef_method :sess
    alias_method :attr_sess=, :sess=
    undef_method :sess=
    
    attr_accessor :handshaker
    alias_method :attr_handshaker, :handshaker
    undef_method :handshaker
    alias_method :attr_handshaker=, :handshaker=
    undef_method :handshaker=
    
    # If anyone wants to get notified about handshake completions,
    # they'll show up on this list.
    attr_accessor :handshake_listeners
    alias_method :attr_handshake_listeners, :handshake_listeners
    undef_method :handshake_listeners
    alias_method :attr_handshake_listeners=, :handshake_listeners=
    undef_method :handshake_listeners=
    
    # Reuse the same internal input/output streams.
    attr_accessor :sock_input
    alias_method :attr_sock_input, :sock_input
    undef_method :sock_input
    alias_method :attr_sock_input=, :sock_input=
    undef_method :sock_input=
    
    attr_accessor :sock_output
    alias_method :attr_sock_output, :sock_output
    undef_method :sock_output
    alias_method :attr_sock_output=, :sock_output=
    undef_method :sock_output=
    
    # These input and output streams block their data in SSL records,
    # and usually arrange integrity and privacy protection for those
    # records.  The guts of the SSL protocol are wrapped up in these
    # streams, and in the handshaking that establishes the details of
    # that integrity and privacy protection.
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
    
    # The protocols we support are SSL Version 3.0) and
    # TLS (version 3.1).
    # In addition we support a pseudo protocol called
    # SSLv2Hello which when set will result in an SSL v2 Hello
    # being sent with SSLv3 or TLSv1 version info.
    attr_accessor :enabled_protocols
    alias_method :attr_enabled_protocols, :enabled_protocols
    undef_method :enabled_protocols
    alias_method :attr_enabled_protocols=, :enabled_protocols=
    undef_method :enabled_protocols=
    
    # The SSL version associated with this connection.
    attr_accessor :protocol_version
    alias_method :attr_protocol_version, :protocol_version
    undef_method :protocol_version
    alias_method :attr_protocol_version=, :protocol_version=
    undef_method :protocol_version=
    
    class_module.module_eval {
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    typesig { [SSLContextImpl, String, ::Java::Int] }
    # CONSTRUCTORS AND INITIALIZATION CODE
    # 
    # 
    # Constructs an SSL connection to a named host at a specified port,
    # using the authentication context provided.  This endpoint acts as
    # the client, and may rejoin an existing SSL session if appropriate.
    # 
    # @param context authentication context to use
    # @param host name of the host with which to connect
    # @param port number of the server's port
    def initialize(context, host, port)
      @connection_state = 0
      @expecting_finished = false
      @close_reason = nil
      @do_client_auth = 0
      @role_is_server = false
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @host = nil
      @auto_close = false
      @acc = nil
      @identification_alg = nil
      @handshake_lock = nil
      @write_lock = nil
      @read_lock = nil
      @inrec = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @handshake_listeners = nil
      @sock_input = nil
      @sock_output = nil
      @input = nil
      @output = nil
      @enabled_protocols = nil
      @protocol_version = nil
      super()
      @enable_session_creation = true
      @auto_close = true
      @identification_alg = nil
      @protocol_version = ProtocolVersion::DEFAULT
      @host = host
      init(context, false)
      socket_address = InetSocketAddress.new(host, port)
      connect(socket_address, 0)
    end
    
    typesig { [SSLContextImpl, InetAddress, ::Java::Int] }
    # Constructs an SSL connection to a server at a specified address.
    # and TCP port, using the authentication context provided.  This
    # endpoint acts as the client, and may rejoin an existing SSL session
    # if appropriate.
    # 
    # @param context authentication context to use
    # @param address the server's host
    # @param port its port
    def initialize(context, host, port)
      @connection_state = 0
      @expecting_finished = false
      @close_reason = nil
      @do_client_auth = 0
      @role_is_server = false
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @host = nil
      @auto_close = false
      @acc = nil
      @identification_alg = nil
      @handshake_lock = nil
      @write_lock = nil
      @read_lock = nil
      @inrec = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @handshake_listeners = nil
      @sock_input = nil
      @sock_output = nil
      @input = nil
      @output = nil
      @enabled_protocols = nil
      @protocol_version = nil
      super()
      @enable_session_creation = true
      @auto_close = true
      @identification_alg = nil
      @protocol_version = ProtocolVersion::DEFAULT
      init(context, false)
      socket_address = InetSocketAddress.new(host, port)
      connect(socket_address, 0)
    end
    
    typesig { [SSLContextImpl, String, ::Java::Int, InetAddress, ::Java::Int] }
    # Constructs an SSL connection to a named host at a specified port,
    # using the authentication context provided.  This endpoint acts as
    # the client, and may rejoin an existing SSL session if appropriate.
    # 
    # @param context authentication context to use
    # @param host name of the host with which to connect
    # @param port number of the server's port
    # @param localAddr the local address the socket is bound to
    # @param localPort the local port the socket is bound to
    def initialize(context, host, port, local_addr, local_port)
      @connection_state = 0
      @expecting_finished = false
      @close_reason = nil
      @do_client_auth = 0
      @role_is_server = false
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @host = nil
      @auto_close = false
      @acc = nil
      @identification_alg = nil
      @handshake_lock = nil
      @write_lock = nil
      @read_lock = nil
      @inrec = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @handshake_listeners = nil
      @sock_input = nil
      @sock_output = nil
      @input = nil
      @output = nil
      @enabled_protocols = nil
      @protocol_version = nil
      super()
      @enable_session_creation = true
      @auto_close = true
      @identification_alg = nil
      @protocol_version = ProtocolVersion::DEFAULT
      @host = host
      init(context, false)
      bind(InetSocketAddress.new(local_addr, local_port))
      socket_address = InetSocketAddress.new(host, port)
      connect(socket_address, 0)
    end
    
    typesig { [SSLContextImpl, InetAddress, ::Java::Int, InetAddress, ::Java::Int] }
    # Constructs an SSL connection to a server at a specified address.
    # and TCP port, using the authentication context provided.  This
    # endpoint acts as the client, and may rejoin an existing SSL session
    # if appropriate.
    # 
    # @param context authentication context to use
    # @param address the server's host
    # @param port its port
    # @param localAddr the local address the socket is bound to
    # @param localPort the local port the socket is bound to
    def initialize(context, host, port, local_addr, local_port)
      @connection_state = 0
      @expecting_finished = false
      @close_reason = nil
      @do_client_auth = 0
      @role_is_server = false
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @host = nil
      @auto_close = false
      @acc = nil
      @identification_alg = nil
      @handshake_lock = nil
      @write_lock = nil
      @read_lock = nil
      @inrec = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @handshake_listeners = nil
      @sock_input = nil
      @sock_output = nil
      @input = nil
      @output = nil
      @enabled_protocols = nil
      @protocol_version = nil
      super()
      @enable_session_creation = true
      @auto_close = true
      @identification_alg = nil
      @protocol_version = ProtocolVersion::DEFAULT
      init(context, false)
      bind(InetSocketAddress.new(local_addr, local_port))
      socket_address = InetSocketAddress.new(host, port)
      connect(socket_address, 0)
    end
    
    typesig { [SSLContextImpl, ::Java::Boolean, CipherSuiteList, ::Java::Byte, ::Java::Boolean, ProtocolList] }
    # Package-private constructor used ONLY by SSLServerSocket.  The
    # java.net package accepts the TCP connection after this call is
    # made.  This just initializes handshake state to use "server mode",
    # giving control over the use of SSL client authentication.
    def initialize(context, server_mode, suites, client_auth, session_creation, protocols)
      @connection_state = 0
      @expecting_finished = false
      @close_reason = nil
      @do_client_auth = 0
      @role_is_server = false
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @host = nil
      @auto_close = false
      @acc = nil
      @identification_alg = nil
      @handshake_lock = nil
      @write_lock = nil
      @read_lock = nil
      @inrec = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @handshake_listeners = nil
      @sock_input = nil
      @sock_output = nil
      @input = nil
      @output = nil
      @enabled_protocols = nil
      @protocol_version = nil
      super()
      @enable_session_creation = true
      @auto_close = true
      @identification_alg = nil
      @protocol_version = ProtocolVersion::DEFAULT
      @do_client_auth = client_auth
      @enable_session_creation = session_creation
      init(context, server_mode)
      # Override what was picked out for us.
      @enabled_cipher_suites = suites
      @enabled_protocols = protocols
    end
    
    typesig { [SSLContextImpl] }
    # Package-private constructor used to instantiate an unconnected
    # socket. The java.net package will connect it, either when the
    # connect() call is made by the application.  This instance is
    # meant to set handshake state to use "client mode".
    def initialize(context)
      @connection_state = 0
      @expecting_finished = false
      @close_reason = nil
      @do_client_auth = 0
      @role_is_server = false
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @host = nil
      @auto_close = false
      @acc = nil
      @identification_alg = nil
      @handshake_lock = nil
      @write_lock = nil
      @read_lock = nil
      @inrec = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @handshake_listeners = nil
      @sock_input = nil
      @sock_output = nil
      @input = nil
      @output = nil
      @enabled_protocols = nil
      @protocol_version = nil
      super()
      @enable_session_creation = true
      @auto_close = true
      @identification_alg = nil
      @protocol_version = ProtocolVersion::DEFAULT
      init(context, false)
    end
    
    typesig { [SSLContextImpl, Socket, String, ::Java::Int, ::Java::Boolean] }
    # Layer SSL traffic over an existing connection, rather than creating
    # a new connection.  The existing connection may be used only for SSL
    # traffic (using this SSLSocket) until the SSLSocket.close() call
    # returns. However, if a protocol error is detected, that existing
    # connection is automatically closed.
    # 
    # <P> This particular constructor always uses the socket in the
    # role of an SSL client. It may be useful in cases which start
    # using SSL after some initial data transfers, for example in some
    # SSL tunneling applications or as part of some kinds of application
    # protocols which negotiate use of a SSL based security.
    # 
    # @param sock the existing connection
    # @param context the authentication context to use
    def initialize(context, sock, host, port, auto_close)
      @connection_state = 0
      @expecting_finished = false
      @close_reason = nil
      @do_client_auth = 0
      @role_is_server = false
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @host = nil
      @auto_close = false
      @acc = nil
      @identification_alg = nil
      @handshake_lock = nil
      @write_lock = nil
      @read_lock = nil
      @inrec = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @handshake_listeners = nil
      @sock_input = nil
      @sock_output = nil
      @input = nil
      @output = nil
      @enabled_protocols = nil
      @protocol_version = nil
      super(sock)
      @enable_session_creation = true
      @auto_close = true
      @identification_alg = nil
      @protocol_version = ProtocolVersion::DEFAULT
      # We always layer over a connected socket
      if (!sock.is_connected)
        raise SocketException.new("Underlying socket is not connected")
      end
      @host = host
      init(context, false)
      @auto_close = auto_close
      done_connect
    end
    
    typesig { [SSLContextImpl, ::Java::Boolean] }
    # Initializes the client socket.
    def init(context, is_server)
      @ssl_context = context
      @sess = SSLSessionImpl.attr_null_session
      # role is as specified, state is START until after
      # the low level connection's established.
      @role_is_server = is_server
      @connection_state = Cs_START
      # default read and write side cipher and MAC support
      # 
      # Note:  compression support would go here too
      @read_cipher = CipherBox.attr_null
      @read_mac = MAC.attr_null
      @write_cipher = CipherBox.attr_null
      @write_mac = MAC.attr_null
      @enabled_cipher_suites = CipherSuiteList.get_default
      @enabled_protocols = ProtocolList.get_default
      @handshake_lock = Object.new
      @write_lock = ReentrantLock.new
      @read_lock = Object.new
      @inrec = nil
      # save the acc
      @acc = AccessController.get_context
      @input = AppInputStream.new(self)
      @output = AppOutputStream.new(self)
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    # Connects this socket to the server with a specified timeout
    # value.
    # 
    # This method is either called on an unconnected SSLSocketImpl by the
    # application, or it is called in the constructor of a regular
    # SSLSocketImpl. If we are layering on top on another socket, then
    # this method should not be called, because we assume that the
    # underlying socket is already connected by the time it is passed to
    # us.
    # 
    # @param   endpoint the <code>SocketAddress</code>
    # @param   timeout  the timeout value to be used, 0 is no timeout
    # @throws  IOException if an error occurs during the connection
    # @throws  SocketTimeoutException if timeout expires before connecting
    def connect(endpoint, timeout)
      if (!(self.attr_self).equal?(self))
        raise SocketException.new("Already connected")
      end
      if (!(endpoint.is_a?(InetSocketAddress)))
        raise SocketException.new("Cannot handle non-Inet socket addresses.")
      end
      super(endpoint, timeout)
      done_connect
    end
    
    typesig { [] }
    # Initialize the handshaker and socket streams.
    # 
    # Called by connect, the layered constructor, and SSLServerSocket.
    def done_connect
      # Save the input and output streams.  May be done only after
      # java.net actually connects using the socket "self", else
      # we get some pretty bizarre failure modes.
      if ((self.attr_self).equal?(self))
        @sock_input = BaseSSLSocketImpl.instance_method(:get_input_stream).bind(self).call
        @sock_output = BaseSSLSocketImpl.instance_method(:get_output_stream).bind(self).call
      else
        @sock_input = self.attr_self.get_input_stream
        @sock_output = self.attr_self.get_output_stream
      end
      # Move to handshaking state, with pending session initialized
      # to defaults and the appropriate kind of handshaker set up.
      init_handshaker
    end
    
    typesig { [] }
    def get_connection_state
      synchronized(self) do
        return @connection_state
      end
    end
    
    typesig { [::Java::Int] }
    def set_connection_state(state)
      synchronized(self) do
        @connection_state = state
      end
    end
    
    typesig { [] }
    def get_acc
      return @acc
    end
    
    typesig { [OutputRecord] }
    # READING AND WRITING RECORDS
    # 
    # 
    # Record Output. Application data can't be sent until the first
    # handshake establishes a session.
    # 
    # NOTE:  we let empty records be written as a hook to force some
    # TCP-level activity, notably handshaking, to occur.
    def write_record(r)
      # The loop is in case of HANDSHAKE --> ERROR transitions, etc
      while ((r.content_type).equal?(Record.attr_ct_application_data))
        # Not all states support passing application data.  We
        # synchronize access to the connection state, so that
        # synchronous handshakes can complete cleanly.
        case (get_connection_state)
        # We've deferred the initial handshaking till just now,
        # when presumably a thread's decided it's OK to block for
        # longish periods of time for I/O purposes (as well as
        # configured the cipher suites it wants to use).
        # 
        # dummy
        # 
        # Else something's goofy in this state machine's use.
        when Cs_HANDSHAKE
          perform_initial_handshake
        when Cs_DATA, Cs_RENEGOTIATE
          break
        when Cs_ERROR
          fatal(Alerts.attr_alert_close_notify, "error while writing to socket")
        when Cs_SENT_CLOSE, Cs_CLOSED, Cs_APP_CLOSED
          # we should never get here (check in AppOutputStream)
          # this is just a fallback
          if (!(@close_reason).nil?)
            raise @close_reason
          else
            raise SocketException.new("Socket closed")
          end
        else
          raise SSLProtocolException.new("State error, send app data")
        end
      end
      # Don't bother to really write empty records.  We went this
      # far to drive the handshake machinery, for correctness; not
      # writing empty records improves performance by cutting CPU
      # time and network resource usage.  However, some protocol
      # implementations are fragile and don't like to see empty
      # records, so this also increases robustness.
      if (!r.is_empty)
        # If the record is a close notify alert, we need to honor
        # socket option SO_LINGER. Note that we will try to send
        # the close notify even if the SO_LINGER set to zero.
        if (r.is_alert(Alerts.attr_alert_close_notify) && get_so_linger >= 0)
          # keep and clear the current thread interruption status.
          interrupted_ = JavaThread.interrupted
          begin
            if (@write_lock.try_lock(get_so_linger, TimeUnit::SECONDS))
              begin
                write_record_internal(r)
              ensure
                @write_lock.unlock
              end
            else
              ssle = SSLException.new("SO_LINGER timeout," + " close_notify message cannot be sent.")
              # For layered, non-autoclose sockets, we are not
              # able to bring them into a usable state, so we
              # treat it as fatal error.
              if (!(self.attr_self).equal?(self) && !@auto_close)
                # Note that the alert description is
                # specified as -1, so no message will be send
                # to peer anymore.
                fatal((-1), ssle)
              else
                if ((!(Debug).nil?) && Debug.is_on("ssl"))
                  System.out.println(RJava.cast_to_string(thread_name) + ", received Exception: " + RJava.cast_to_string(ssle))
                end
              end
              # RFC2246 requires that the session becomes
              # unresumable if any connection is terminated
              # without proper close_notify messages with
              # level equal to warning.
              # 
              # RFC4346 no longer requires that a session not be
              # resumed if failure to properly close a connection.
              # 
              # We choose to make the session unresumable if
              # failed to send the close_notify message.
              @sess.invalidate
            end
          rescue InterruptedException => ie
            # keep interrupted status
            interrupted_ = true
          end
          # restore the interrupted status
          if (interrupted_)
            JavaThread.current_thread.interrupt
          end
        else
          @write_lock.lock
          begin
            write_record_internal(r)
          ensure
            @write_lock.unlock
          end
        end
      end
    end
    
    typesig { [OutputRecord] }
    def write_record_internal(r)
      # r.compress(c);
      r.add_mac(@write_mac)
      r.encrypt(@write_cipher)
      r.write(@sock_output)
    end
    
    typesig { [InputRecord] }
    # Read an application data record.  Alerts and handshake
    # messages are handled directly.
    def read_data_record(r)
      if ((get_connection_state).equal?(Cs_HANDSHAKE))
        perform_initial_handshake
      end
      read_record(r, true)
    end
    
    typesig { [InputRecord, ::Java::Boolean] }
    # Clear the pipeline of records from the peer, optionally returning
    # application data.   Caller is responsible for knowing that it's
    # possible to do this kind of clearing, if they don't want app
    # data -- e.g. since it's the initial SSL handshake.
    # 
    # Don't synchronize (this) during a blocking read() since it
    # protects data which is accessed on the write side as well.
    def read_record(r, need_app_data)
      state = 0
      # readLock protects reading and processing of an InputRecord.
      # It keeps the reading from sockInput and processing of the record
      # atomic so that no two threads can be blocked on the
      # read from the same input stream at the same time.
      # This is required for example when a reader thread is
      # blocked on the read and another thread is trying to
      # close the socket. For a non-autoclose, layered socket,
      # the thread performing the close needs to read the close_notify.
      # 
      # Use readLock instead of 'this' for locking because
      # 'this' also protects data accessed during writing.
      synchronized((@read_lock)) do
        # Read and handle records ... return application data
        # ONLY if it's needed.
        while ((!((state = get_connection_state)).equal?(Cs_CLOSED)) && (!(state).equal?(Cs_ERROR)) && (!(state).equal?(Cs_APP_CLOSED)))
          # Read a record ... maybe emitting an alert if we get a
          # comprehensible but unsupported "hello" message during
          # format checking (e.g. V2).
          begin
            r.set_app_data_valid(false)
            r.read(@sock_input, @sock_output)
          rescue SSLProtocolException => e
            begin
              fatal(Alerts.attr_alert_unexpected_message, e)
            rescue IOException => x
              # discard this exception
            end
            raise e
          rescue EOFException => eof
            handshaking = (get_connection_state <= Cs_HANDSHAKE)
            rethrow = self.attr_require_close_notify || handshaking
            if ((!(Debug).nil?) && Debug.is_on("ssl"))
              System.out.println(RJava.cast_to_string(thread_name) + ", received EOFException: " + RJava.cast_to_string((rethrow ? "error" : "ignored")))
            end
            if (rethrow)
              e = nil
              if (handshaking)
                e = SSLHandshakeException.new("Remote host closed connection during handshake")
              else
                e = SSLProtocolException.new("Remote host closed connection incorrectly")
              end
              e.init_cause(eof)
              raise e
            else
              # treat as if we had received a close_notify
              close_internal(false)
              next
            end
          end
          # The basic SSLv3 record protection involves (optional)
          # encryption for privacy, and an integrity check ensuring
          # data origin authentication.  We do them both here, and
          # throw a fatal alert if the integrity check fails.
          begin
            r.decrypt(@read_cipher)
          rescue BadPaddingException => e
            # RFC 2246 states that decryption_failed should be used
            # for this purpose. However, that allows certain attacks,
            # so we just send bad record MAC. We also need to make
            # sure to always check the MAC to avoid a timing attack
            # for the same issue. See paper by Vaudenay et al.
            r.check_mac(@read_mac)
            # use the same alert types as for MAC failure below
            alert_type = ((r.content_type).equal?(Record.attr_ct_handshake)) ? Alerts.attr_alert_handshake_failure : Alerts.attr_alert_bad_record_mac
            fatal(alert_type, "Invalid padding", e)
          end
          if (!r.check_mac(@read_mac))
            if ((r.content_type).equal?(Record.attr_ct_handshake))
              fatal(Alerts.attr_alert_handshake_failure, "bad handshake record MAC")
            else
              fatal(Alerts.attr_alert_bad_record_mac, "bad record MAC")
            end
          end
          # if (!r.decompress(c))
          # fatal(Alerts.alert_decompression_failure,
          # "decompression failure");
          # 
          # Process the record.
          synchronized((self)) do
            case (r.content_type)
            when Record.attr_ct_handshake
              # Handshake messages always go to a pending session
              # handshaker ... if there isn't one, create one.  This
              # must work asynchronously, for renegotiation.
              # 
              # NOTE that handshaking will either resume a session
              # which was in the cache (and which might have other
              # connections in it already), or else will start a new
              # session (new keys exchanged) with just this connection
              # in it.
              init_handshaker
              # process the handshake record ... may contain just
              # a partial handshake message or multiple messages.
              # 
              # The handshaker state machine will ensure that it's
              # a finished message.
              @handshaker.process_record(r, @expecting_finished)
              @expecting_finished = false
              if (@handshaker.is_done)
                @sess = @handshaker.get_session
                @handshaker = nil
                @connection_state = Cs_DATA
                # Tell folk about handshake completion, but do
                # it in a separate thread.
                if (!(@handshake_listeners).nil?)
                  event = HandshakeCompletedEvent.new(self, @sess)
                  t = NotifyHandshakeThread.new(@handshake_listeners.entry_set, event)
                  t.start
                end
              end
              if (need_app_data || !(@connection_state).equal?(Cs_DATA))
                next
              else
                return
              end
              # Pass this right back up to the application.
              if (!(@connection_state).equal?(Cs_DATA) && !(@connection_state).equal?(Cs_RENEGOTIATE) && !(@connection_state).equal?(Cs_SENT_CLOSE))
                raise SSLProtocolException.new("Data received in non-data state: " + RJava.cast_to_string(@connection_state))
              end
              if (@expecting_finished)
                raise SSLProtocolException.new("Expecting finished message, received data")
              end
              if (!need_app_data)
                raise SSLException.new("Discarding app data")
              end
              r.set_app_data_valid(true)
              return
            when Record.attr_ct_application_data
              # Pass this right back up to the application.
              if (!(@connection_state).equal?(Cs_DATA) && !(@connection_state).equal?(Cs_RENEGOTIATE) && !(@connection_state).equal?(Cs_SENT_CLOSE))
                raise SSLProtocolException.new("Data received in non-data state: " + RJava.cast_to_string(@connection_state))
              end
              if (@expecting_finished)
                raise SSLProtocolException.new("Expecting finished message, received data")
              end
              if (!need_app_data)
                raise SSLException.new("Discarding app data")
              end
              r.set_app_data_valid(true)
              return
            when Record.attr_ct_alert
              recv_alert(r)
              next
              if ((!(@connection_state).equal?(Cs_HANDSHAKE) && !(@connection_state).equal?(Cs_RENEGOTIATE)) || !(r.available).equal?(1) || !(r.read).equal?(1))
                fatal(Alerts.attr_alert_unexpected_message, "illegal change cipher spec msg, state = " + RJava.cast_to_string(@connection_state))
              end
              # The first message after a change_cipher_spec
              # record MUST be a "Finished" handshake record,
              # else it's a protocol violation.  We force this
              # to be checked by a minor tweak to the state
              # machine.
              change_read_ciphers
              # next message MUST be a finished message
              @expecting_finished = true
              next
              # TLS requires that unrecognized records be ignored.
              if (!(Debug).nil? && Debug.is_on("ssl"))
                System.out.println(RJava.cast_to_string(thread_name) + ", Received record type: " + RJava.cast_to_string(r.content_type))
              end
              next
            when Record.attr_ct_change_cipher_spec
              if ((!(@connection_state).equal?(Cs_HANDSHAKE) && !(@connection_state).equal?(Cs_RENEGOTIATE)) || !(r.available).equal?(1) || !(r.read).equal?(1))
                fatal(Alerts.attr_alert_unexpected_message, "illegal change cipher spec msg, state = " + RJava.cast_to_string(@connection_state))
              end
              # The first message after a change_cipher_spec
              # record MUST be a "Finished" handshake record,
              # else it's a protocol violation.  We force this
              # to be checked by a minor tweak to the state
              # machine.
              change_read_ciphers
              # next message MUST be a finished message
              @expecting_finished = true
              next
              # TLS requires that unrecognized records be ignored.
              if (!(Debug).nil? && Debug.is_on("ssl"))
                System.out.println(RJava.cast_to_string(thread_name) + ", Received record type: " + RJava.cast_to_string(r.content_type))
              end
              next
            else
              # TLS requires that unrecognized records be ignored.
              if (!(Debug).nil? && Debug.is_on("ssl"))
                System.out.println(RJava.cast_to_string(thread_name) + ", Received record type: " + RJava.cast_to_string(r.content_type))
              end
              next
            end
            # switch
          end # synchronized (this)
        end
        # couldn't read, due to some kind of error
        r.close
        return
      end # synchronized (readLock)
    end
    
    typesig { [] }
    # HANDSHAKE RELATED CODE
    # 
    # 
    # Return the AppInputStream. For use by Handshaker only.
    def get_app_input_stream
      return @input
    end
    
    typesig { [] }
    # Initialize and get the server handshaker. Used by SSLServerSocketImpl
    # for the ciphersuite availability test *only*.
    def get_server_handshaker
      init_handshaker
      # The connection state would have been set to cs_HANDSHAKE during the
      # handshaking initializing, however the caller may not have the
      # the low level connection's established, which is not consistent with
      # the HANDSHAKE state. As if it is unconnected, we need to reset the
      # connection state to cs_START.
      if (!is_connected)
        @connection_state = Cs_START
      end
      # Make sure that we get a ServerHandshaker.
      # This should never happen.
      if (!(@handshaker.is_a?(ServerHandshaker)))
        raise SSLProtocolException.new("unexpected handshaker instance")
      end
      return @handshaker
    end
    
    typesig { [] }
    # Initialize the handshaker object. This means:
    # 
    # . if a handshake is already in progress (state is cs_HANDSHAKE
    # or cs_RENEGOTIATE), do nothing and return
    # 
    # . if the socket is already closed, throw an Exception (internal error)
    # 
    # . otherwise (cs_START or cs_DATA), create the appropriate handshaker
    # object, initialize it, and advance the connection state (to
    # cs_HANDSHAKE or cs_RENEGOTIATE, respectively).
    # 
    # This method is called right after a new socket is created, when
    # starting renegotiation, or when changing client/ server mode of the
    # socket.
    def init_handshaker
      case (@connection_state)
      # Starting a new handshake.
      # 
      # 
      # We're already in the middle of a handshake.
      # 
      # 
      # Anyone allowed to call this routine is required to
      # do so ONLY if the connection state is reasonable...
      when Cs_START, Cs_DATA
      when Cs_HANDSHAKE, Cs_RENEGOTIATE
        return
      else
        raise IllegalStateException.new("Internal error")
      end
      # state is either cs_START or cs_DATA
      if ((@connection_state).equal?(Cs_START))
        @connection_state = Cs_HANDSHAKE
      else
        # cs_DATA
        @connection_state = Cs_RENEGOTIATE
      end
      if (@role_is_server)
        @handshaker = ServerHandshaker.new(self, @ssl_context, @enabled_protocols, @do_client_auth)
      else
        @handshaker = ClientHandshaker.new(self, @ssl_context, @enabled_protocols)
      end
      @handshaker.attr_enabled_cipher_suites = @enabled_cipher_suites
      @handshaker.set_enable_session_creation(@enable_session_creation)
      if ((@connection_state).equal?(Cs_RENEGOTIATE))
        # don't use SSLv2Hello when renegotiating
        @handshaker.attr_output.attr_r.set_hello_version(@protocol_version)
      end
    end
    
    typesig { [] }
    # Synchronously perform the initial handshake.
    # 
    # If the handshake is already in progress, this method blocks until it
    # is completed. If the initial handshake has already been completed,
    # it returns immediately.
    def perform_initial_handshake
      # use handshakeLock and the state check to make sure only
      # one thread performs the handshake
      synchronized((@handshake_lock)) do
        if ((get_connection_state).equal?(Cs_HANDSHAKE))
          # All initial handshaking goes through this
          # InputRecord until we have a valid SSL connection.
          # Once initial handshaking is finished, AppInputStream's
          # InputRecord can handle any future renegotiation.
          # 
          # Keep this local so that it goes out of scope and is
          # eventually GC'd.
          if ((@inrec).nil?)
            @inrec = InputRecord.new
            # Grab the characteristics already assigned to
            # AppInputStream's InputRecord.  Enable checking for
            # SSLv2 hellos on this first handshake.
            @inrec.set_handshake_hash(@input.attr_r.get_handshake_hash)
            @inrec.set_hello_version(@input.attr_r.get_hello_version)
            @inrec.enable_format_checks
          end
          kickstart_handshake
          read_record(@inrec, false)
          @inrec = nil
        end
      end
    end
    
    typesig { [] }
    # Starts an SSL handshake on this connection.
    def start_handshake
      # start an ssl handshake that could be resumed from timeout exception
      start_handshake(true)
    end
    
    typesig { [::Java::Boolean] }
    # Starts an ssl handshake on this connection.
    # 
    # @param resumable indicates the handshake process is resumable from a
    # certain exception. If <code>resumable</code>, the socket will
    # be reserved for exceptions like timeout; otherwise, the socket
    # will be closed, no further communications could be done.
    def start_handshake(resumable)
      check_write
      begin
        if ((get_connection_state).equal?(Cs_HANDSHAKE))
          # do initial handshake
          perform_initial_handshake
        else
          # start renegotiation
          kickstart_handshake
        end
      rescue JavaException => e
        # shutdown and rethrow (wrapped) exception as appropriate
        handle_exception(e, resumable)
      end
    end
    
    typesig { [] }
    # Kickstart the handshake if it is not already in progress.
    # This means:
    # 
    # . if handshaking is already underway, do nothing and return
    # 
    # . if the socket is not connected or already closed, throw an
    # Exception.
    # 
    # . otherwise, call initHandshake() to initialize the handshaker
    # object and progress the state. Then, send the initial
    # handshaking message if appropriate (always on clients and
    # on servers when renegotiating).
    def kickstart_handshake
      synchronized(self) do
        case (@connection_state)
        # The only way to get a socket in the state is when
        # you have an unconnected socket.
        when Cs_HANDSHAKE
          # handshaker already setup, proceed
        when Cs_DATA
          # initialize the handshaker, move to cs_RENEGOTIATE
          init_handshaker
        when Cs_RENEGOTIATE
          # handshaking already in progress, return
          return
        when Cs_START
          raise SocketException.new("handshaking attempted on unconnected socket")
        else
          raise SocketException.new("connection is closed")
        end
        # Kickstart handshake state machine if we need to ...
        # 
        # Note that handshaker.kickstart() writes the message
        # to its HandshakeOutStream, which calls back into
        # SSLSocketImpl.writeRecord() to send it.
        if (!@handshaker.started)
          if (@handshaker.is_a?(ClientHandshaker))
            # send client hello
            @handshaker.kickstart
          else
            if ((@connection_state).equal?(Cs_HANDSHAKE))
              # initial handshake, no kickstart message to send
            else
              # we want to renegotiate, send hello request
              @handshaker.kickstart
              # hello request is not included in the handshake
              # hashes, reset them
              @handshaker.attr_handshake_hash.reset
            end
          end
        end
      end
    end
    
    typesig { [] }
    # CLOSURE RELATED CALLS
    # 
    # 
    # Return whether the socket has been explicitly closed by the application.
    def is_closed
      return (get_connection_state).equal?(Cs_APP_CLOSED)
    end
    
    typesig { [] }
    # Return whether we have reached end-of-file.
    # 
    # If the socket is not connected, has been shutdown because of an error
    # or has been closed, throw an Exception.
    def check_eof
      case (get_connection_state)
      when Cs_START
        raise SocketException.new("Socket is not connected")
      when Cs_HANDSHAKE, Cs_DATA, Cs_RENEGOTIATE, Cs_SENT_CLOSE
        return false
      when Cs_APP_CLOSED
        raise SocketException.new("Socket is closed")
      when Cs_ERROR, Cs_CLOSED
        # either closed because of error, or normal EOF
        if ((@close_reason).nil?)
          return true
        end
        e = SSLException.new("Connection has been shutdown: " + RJava.cast_to_string(@close_reason))
        e.init_cause(@close_reason)
        raise e
      else
        # either closed because of error, or normal EOF
        if ((@close_reason).nil?)
          return true
        end
        e = SSLException.new("Connection has been shutdown: " + RJava.cast_to_string(@close_reason))
        e.init_cause(@close_reason)
        raise e
      end
    end
    
    typesig { [] }
    # Check if we can write data to this socket. If not, throw an IOException.
    def check_write
      if (check_eof || ((get_connection_state).equal?(Cs_SENT_CLOSE)))
        # we are at EOF, write must throw Exception
        raise SocketException.new("Connection closed by remote host")
      end
    end
    
    typesig { [] }
    def close_socket
      if ((!(Debug).nil?) && Debug.is_on("ssl"))
        System.out.println(RJava.cast_to_string(thread_name) + ", called closeSocket()")
      end
      if ((self.attr_self).equal?(self))
        BaseSSLSocketImpl.instance_method(:close).bind(self).call
      else
        self.attr_self.close
      end
    end
    
    typesig { [] }
    # Closing the connection is tricky ... we can't officially close the
    # connection until we know the other end is ready to go away too,
    # and if ever the connection gets aborted we must forget session
    # state (it becomes invalid).
    # 
    # 
    # Closes the SSL connection.  SSL includes an application level
    # shutdown handshake; you should close SSL sockets explicitly
    # rather than leaving it for finalization, so that your remote
    # peer does not experience a protocol error.
    def close
      if ((!(Debug).nil?) && Debug.is_on("ssl"))
        System.out.println(RJava.cast_to_string(thread_name) + ", called close()")
      end
      close_internal(true) # caller is initiating close
      set_connection_state(Cs_APP_CLOSED)
    end
    
    typesig { [::Java::Boolean] }
    # Don't synchronize the whole method because waitForClose()
    # (which calls readRecord()) might be called.
    # 
    # @param selfInitiated Indicates which party initiated the close.
    # If selfInitiated, this side is initiating a close; for layered and
    # non-autoclose socket, wait for close_notify response.
    # If !selfInitiated, peer sent close_notify; we reciprocate but
    # no need to wait for response.
    def close_internal(self_initiated)
      if ((!(Debug).nil?) && Debug.is_on("ssl"))
        System.out.println(RJava.cast_to_string(thread_name) + ", called closeInternal(" + RJava.cast_to_string(self_initiated) + ")")
      end
      state = get_connection_state
      begin
        case (state)
        # java.net code sometimes closes sockets "early", when
        # we can't actually do I/O on them.
        # 
        # 
        # If we're closing down due to error, we already sent (or else
        # received) the fatal alert ... no niceties, blow the connection
        # away as quickly as possible (even if we didn't allocate the
        # socket ourselves; it's unusable, regardless).
        # 
        # 
        # Sometimes close() gets called more than once.
        # 
        # 
        # Otherwise we indicate clean termination.
        # 
        # case cs_HANDSHAKE:
        # case cs_DATA:
        # case cs_RENEGOTIATE:
        # case cs_SENT_CLOSE:
        when Cs_START
        when Cs_ERROR
          close_socket
        when Cs_CLOSED, Cs_APP_CLOSED
        else
          synchronized((self)) do
            if ((((state = get_connection_state)).equal?(Cs_CLOSED)) || ((state).equal?(Cs_ERROR)) || ((state).equal?(Cs_APP_CLOSED)))
              return # connection was closed while we waited
            end
            if (!(state).equal?(Cs_SENT_CLOSE))
              warning(Alerts.attr_alert_close_notify)
              @connection_state = Cs_SENT_CLOSE
            end
          end
          # If state was cs_SENT_CLOSE before, we don't do the actual
          # closing since it is already in progress.
          if ((state).equal?(Cs_SENT_CLOSE))
            if (!(Debug).nil? && Debug.is_on("ssl"))
              System.out.println(RJava.cast_to_string(thread_name) + ", close invoked again; state = " + RJava.cast_to_string(get_connection_state))
            end
            if ((self_initiated).equal?(false))
              # We were called because a close_notify message was
              # received. This may be due to another thread calling
              # read() or due to our call to waitForClose() below.
              # In either case, just return.
              return
            end
            # Another thread explicitly called close(). We need to
            # wait for the closing to complete before returning.
            synchronized((self)) do
              while (@connection_state < Cs_CLOSED)
                begin
                  self.wait
                rescue InterruptedException => e
                  # ignore
                end
              end
            end
            if ((!(Debug).nil?) && Debug.is_on("ssl"))
              System.out.println(RJava.cast_to_string(thread_name) + ", after primary close; state = " + RJava.cast_to_string(get_connection_state))
            end
            return
          end
          if ((self.attr_self).equal?(self))
            BaseSSLSocketImpl.instance_method(:close).bind(self).call
          else
            if (@auto_close)
              self.attr_self.close
            else
              if (self_initiated)
                # layered && non-autoclose
                # read close_notify alert to clear input stream
                wait_for_close(false)
              end
            end
          end
          # state will be set to cs_CLOSED in the finally block below
        end
      ensure
        synchronized((self)) do
          # Upon exit from this method, the state is always >= cs_CLOSED
          @connection_state = ((@connection_state).equal?(Cs_APP_CLOSED)) ? Cs_APP_CLOSED : Cs_CLOSED
          # notify any threads waiting for the closing to finish
          self.notify_all
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Reads a close_notify or a fatal alert from the input stream.
    # Keep reading records until we get a close_notify or until
    # the connection is otherwise closed.  The close_notify or alert
    # might be read by another reader,
    # which will then process the close and set the connection state.
    def wait_for_close(rethrow)
      if (!(Debug).nil? && Debug.is_on("ssl"))
        System.out.println(RJava.cast_to_string(thread_name) + ", waiting for close_notify or alert: state " + RJava.cast_to_string(get_connection_state))
      end
      begin
        state = 0
        while ((!((state = get_connection_state)).equal?(Cs_CLOSED)) && (!(state).equal?(Cs_ERROR)) && (!(state).equal?(Cs_APP_CLOSED)))
          # create the InputRecord if it isn't intialized.
          if ((@inrec).nil?)
            @inrec = InputRecord.new
          end
          # Ask for app data and then throw it away
          begin
            read_record(@inrec, true)
          rescue SocketTimeoutException => e
            # if time out, ignore the exception and continue
          end
        end
        @inrec = nil
      rescue IOException => e
        if (!(Debug).nil? && Debug.is_on("ssl"))
          System.out.println(RJava.cast_to_string(thread_name) + ", Exception while waiting for close " + RJava.cast_to_string(e))
        end
        if (rethrow)
          raise e # pass exception up
        end
      end
    end
    
    typesig { [JavaException] }
    # EXCEPTION AND ALERT HANDLING
    # 
    # 
    # Handle an exception. This method is called by top level exception
    # handlers (in read(), write()) to make sure we always shutdown the
    # connection correctly and do not pass runtime exception to the
    # application.
    def handle_exception(e)
      handle_exception(e, true)
    end
    
    typesig { [JavaException, ::Java::Boolean] }
    # Handle an exception. This method is called by top level exception
    # handlers (in read(), write(), startHandshake()) to make sure we
    # always shutdown the connection correctly and do not pass runtime
    # exception to the application.
    # 
    # This method never returns normally, it always throws an IOException.
    # 
    # We first check if the socket has already been shutdown because of an
    # error. If so, we just rethrow the exception. If the socket has not
    # been shutdown, we sent a fatal alert and remember the exception.
    # 
    # @param e the Exception
    # @param resumable indicates the caller process is resumable from the
    # exception. If <code>resumable</code>, the socket will be
    # reserved for exceptions like timeout; otherwise, the socket
    # will be closed, no further communications could be done.
    def handle_exception(e, resumable)
      synchronized(self) do
        if ((!(Debug).nil?) && Debug.is_on("ssl"))
          System.out.println(RJava.cast_to_string(thread_name) + ", handling exception: " + RJava.cast_to_string(e.to_s))
        end
        # don't close the Socket in case of timeouts or interrupts if
        # the process is resumable.
        if (e.is_a?(InterruptedIOException) && resumable)
          raise e
        end
        # if we've already shutdown because of an error,
        # there is nothing to do except rethrow the exception
        if (!(@close_reason).nil?)
          if (e.is_a?(IOException))
            # includes SSLException
            raise e
          else
            # this is odd, not an IOException.
            # normally, this should not happen
            # if closeReason has been already been set
            raise Alerts.get_sslexception(Alerts.attr_alert_internal_error, e, "Unexpected exception")
          end
        end
        # need to perform error shutdown
        is_sslexception = (e.is_a?(SSLException))
        if (((is_sslexception).equal?(false)) && (e.is_a?(IOException)))
          # IOException from the socket
          # this means the TCP connection is already dead
          # we call fatal just to set the error status
          begin
            fatal(Alerts.attr_alert_unexpected_message, e)
          rescue IOException => ee
            # ignore (IOException wrapped in SSLException)
          end
          # rethrow original IOException
          raise e
        end
        # must be SSLException or RuntimeException
        alert_type = 0
        if (is_sslexception)
          if (e.is_a?(SSLHandshakeException))
            alert_type = Alerts.attr_alert_handshake_failure
          else
            alert_type = Alerts.attr_alert_unexpected_message
          end
        else
          alert_type = Alerts.attr_alert_internal_error
        end
        fatal(alert_type, e)
      end
    end
    
    typesig { [::Java::Byte] }
    # Send a warning alert.
    def warning(description)
      send_alert(Alerts.attr_alert_warning, description)
    end
    
    typesig { [::Java::Byte, String] }
    def fatal(description, diagnostic)
      synchronized(self) do
        fatal(description, diagnostic, nil)
      end
    end
    
    typesig { [::Java::Byte, JavaThrowable] }
    def fatal(description, cause)
      synchronized(self) do
        fatal(description, nil, cause)
      end
    end
    
    typesig { [::Java::Byte, String, JavaThrowable] }
    # Send a fatal alert, and throw an exception so that callers will
    # need to stand on their heads to accidentally continue processing.
    def fatal(description, diagnostic, cause)
      synchronized(self) do
        if ((!(@input).nil?) && (!(@input.attr_r).nil?))
          @input.attr_r.close
        end
        @sess.invalidate
        old_state = @connection_state
        @connection_state = Cs_ERROR
        # Has there been an error received yet?  If not, remember it.
        # By RFC 2246, we don't bother waiting for a response.
        # Fatal errors require immediate shutdown.
        if ((@close_reason).nil?)
          # Try to clear the kernel buffer to avoid TCP connection resets.
          if ((old_state).equal?(Cs_HANDSHAKE))
            @sock_input.skip(@sock_input.available)
          end
          # If the description equals -1, the alert won't be sent to peer.
          if (!(description).equal?(-1))
            send_alert(Alerts.attr_alert_fatal, description)
          end
          if (cause.is_a?(SSLException))
            # only true if != null
            @close_reason = cause
          else
            @close_reason = Alerts.get_sslexception(description, cause, diagnostic)
          end
        end
        # Clean up our side.
        close_socket
        @connection_state = ((old_state).equal?(Cs_APP_CLOSED)) ? Cs_APP_CLOSED : Cs_CLOSED
        raise @close_reason
      end
    end
    
    typesig { [InputRecord] }
    # Process an incoming alert ... caller must already have synchronized
    # access to "this".
    def recv_alert(r)
      level = r.read
      description = r.read
      if ((description).equal?(-1))
        # check for short message
        fatal(Alerts.attr_alert_illegal_parameter, "Short alert message")
      end
      if (!(Debug).nil? && (Debug.is_on("record") || Debug.is_on("handshake")))
        synchronized((System.out)) do
          System.out.print(thread_name)
          System.out.print(", RECV " + RJava.cast_to_string(@protocol_version) + " ALERT:  ")
          if ((level).equal?(Alerts.attr_alert_fatal))
            System.out.print("fatal, ")
          else
            if ((level).equal?(Alerts.attr_alert_warning))
              System.out.print("warning, ")
            else
              System.out.print("<level " + RJava.cast_to_string((0xff & level)) + ">, ")
            end
          end
          System.out.println(Alerts.alert_description(description))
        end
      end
      if ((level).equal?(Alerts.attr_alert_warning))
        if ((description).equal?(Alerts.attr_alert_close_notify))
          if ((@connection_state).equal?(Cs_HANDSHAKE))
            fatal(Alerts.attr_alert_unexpected_message, "Received close_notify during handshake")
          else
            close_internal(false) # reply to close
          end
        else
          # The other legal warnings relate to certificates,
          # e.g. no_certificate, bad_certificate, etc; these
          # are important to the handshaking code, which can
          # also handle illegal protocol alerts if needed.
          if (!(@handshaker).nil?)
            @handshaker.handshake_alert(description)
          end
        end
      else
        # fatal or unknown level
        reason = "Received fatal alert: " + RJava.cast_to_string(Alerts.alert_description(description))
        if ((@close_reason).nil?)
          @close_reason = Alerts.get_sslexception(description, reason)
        end
        fatal(Alerts.attr_alert_unexpected_message, reason)
      end
    end
    
    typesig { [::Java::Byte, ::Java::Byte] }
    # Emit alerts.  Caller must have synchronized with "this".
    def send_alert(level, description)
      if (@connection_state >= Cs_SENT_CLOSE)
        return
      end
      r = OutputRecord.new(Record.attr_ct_alert)
      r.set_version(@protocol_version)
      use_debug = !(Debug).nil? && Debug.is_on("ssl")
      if (use_debug)
        synchronized((System.out)) do
          System.out.print(thread_name)
          System.out.print(", SEND " + RJava.cast_to_string(@protocol_version) + " ALERT:  ")
          if ((level).equal?(Alerts.attr_alert_fatal))
            System.out.print("fatal, ")
          else
            if ((level).equal?(Alerts.attr_alert_warning))
              System.out.print("warning, ")
            else
              System.out.print("<level = " + RJava.cast_to_string((0xff & level)) + ">, ")
            end
          end
          System.out.println("description = " + RJava.cast_to_string(Alerts.alert_description(description)))
        end
      end
      r.write(level)
      r.write(description)
      begin
        write_record(r)
      rescue IOException => e
        if (use_debug)
          System.out.println(RJava.cast_to_string(thread_name) + ", Exception sending alert: " + RJava.cast_to_string(e))
        end
      end
    end
    
    typesig { [] }
    # VARIOUS OTHER METHODS
    # 
    # 
    # When a connection finishes handshaking by enabling use of a newly
    # negotiated session, each end learns about it in two halves (read,
    # and write).  When both read and write ciphers have changed, and the
    # last handshake message has been read, the connection has joined
    # (rejoined) the new session.
    # 
    # NOTE:  The SSLv3 spec is rather unclear on the concepts here.
    # Sessions don't change once they're established (including cipher
    # suite and master secret) but connections can join them (and leave
    # them).  They're created by handshaking, though sometime handshaking
    # causes connections to join up with pre-established sessions.
    def change_read_ciphers
      if (!(@connection_state).equal?(Cs_HANDSHAKE) && !(@connection_state).equal?(Cs_RENEGOTIATE))
        raise SSLProtocolException.new("State error, change cipher specs")
      end
      # ... create decompressor
      begin
        @read_cipher = @handshaker.new_read_cipher
        @read_mac = @handshaker.new_read_mac
      rescue GeneralSecurityException => e
        # "can't happen"
        raise SSLException.new("Algorithm missing:  ").init_cause(e)
      end
    end
    
    typesig { [] }
    # used by Handshaker
    def change_write_ciphers
      if (!(@connection_state).equal?(Cs_HANDSHAKE) && !(@connection_state).equal?(Cs_RENEGOTIATE))
        raise SSLProtocolException.new("State error, change cipher specs")
      end
      # ... create compressor
      begin
        @write_cipher = @handshaker.new_write_cipher
        @write_mac = @handshaker.new_write_mac
      rescue GeneralSecurityException => e
        # "can't happen"
        raise SSLException.new("Algorithm missing:  ").init_cause(e)
      end
    end
    
    typesig { [ProtocolVersion] }
    # Updates the SSL version associated with this connection.
    # Called from Handshaker once it has determined the negotiated version.
    def set_version(protocol_version)
      synchronized(self) do
        @protocol_version = protocol_version
        @output.attr_r.set_version(protocol_version)
      end
    end
    
    typesig { [] }
    def get_host
      synchronized(self) do
        if ((@host).nil?)
          @host = RJava.cast_to_string(get_inet_address.get_host_name)
        end
        return @host
      end
    end
    
    typesig { [] }
    # Gets an input stream to read from the peer on the other side.
    # Data read from this stream was always integrity protected in
    # transit, and will usually have been confidentiality protected.
    def get_input_stream
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        # Can't call isConnected() here, because the Handshakers
        # do some initialization before we actually connect.
        if ((@connection_state).equal?(Cs_START))
          raise SocketException.new("Socket is not connected")
        end
        return @input
      end
    end
    
    typesig { [] }
    # Gets an output stream to write to the peer on the other side.
    # Data written on this stream is always integrity protected, and
    # will usually be confidentiality protected.
    def get_output_stream
      synchronized(self) do
        if (is_closed)
          raise SocketException.new("Socket is closed")
        end
        # Can't call isConnected() here, because the Handshakers
        # do some initialization before we actually connect.
        if ((@connection_state).equal?(Cs_START))
          raise SocketException.new("Socket is not connected")
        end
        return @output
      end
    end
    
    typesig { [] }
    # Returns the the SSL Session in use by this connection.  These can
    # be long lived, and frequently correspond to an entire login session
    # for some user.
    def get_session
      # Force a synchronous handshake, if appropriate.
      if ((get_connection_state).equal?(Cs_HANDSHAKE))
        begin
          # start handshaking, if failed, the connection will be closed.
          start_handshake(false)
        rescue IOException => e
          # handshake failed. log and return a nullSession
          if (!(Debug).nil? && Debug.is_on("handshake"))
            System.out.println(RJava.cast_to_string(thread_name) + ", IOException in getSession():  " + RJava.cast_to_string(e))
          end
        end
      end
      synchronized((self)) do
        return @sess
      end
    end
    
    typesig { [::Java::Boolean] }
    # Controls whether new connections may cause creation of new SSL
    # sessions.
    # 
    # As long as handshaking has not started, we can change
    # whether we enable session creations.  Otherwise,
    # we will need to wait for the next handshake.
    def set_enable_session_creation(flag)
      synchronized(self) do
        @enable_session_creation = flag
        if ((!(@handshaker).nil?) && !@handshaker.started)
          @handshaker.set_enable_session_creation(@enable_session_creation)
        end
      end
    end
    
    typesig { [] }
    # Returns true if new connections may cause creation of new SSL
    # sessions.
    def get_enable_session_creation
      synchronized(self) do
        return @enable_session_creation
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets the flag controlling whether a server mode socket
    # *REQUIRES* SSL client authentication.
    # 
    # As long as handshaking has not started, we can change
    # whether client authentication is needed.  Otherwise,
    # we will need to wait for the next handshake.
    def set_need_client_auth(flag)
      synchronized(self) do
        @do_client_auth = (flag ? SSLEngineImpl.attr_clauth_required : SSLEngineImpl.attr_clauth_none)
        if ((!(@handshaker).nil?) && (@handshaker.is_a?(ServerHandshaker)) && !@handshaker.started)
          (@handshaker).set_client_auth(@do_client_auth)
        end
      end
    end
    
    typesig { [] }
    def get_need_client_auth
      synchronized(self) do
        return ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_required))
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets the flag controlling whether a server mode socket
    # *REQUESTS* SSL client authentication.
    # 
    # As long as handshaking has not started, we can change
    # whether client authentication is requested.  Otherwise,
    # we will need to wait for the next handshake.
    def set_want_client_auth(flag)
      synchronized(self) do
        @do_client_auth = (flag ? SSLEngineImpl.attr_clauth_requested : SSLEngineImpl.attr_clauth_none)
        if ((!(@handshaker).nil?) && (@handshaker.is_a?(ServerHandshaker)) && !@handshaker.started)
          (@handshaker).set_client_auth(@do_client_auth)
        end
      end
    end
    
    typesig { [] }
    def get_want_client_auth
      synchronized(self) do
        return ((@do_client_auth).equal?(SSLEngineImpl.attr_clauth_requested))
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets the flag controlling whether the socket is in SSL
    # client or server mode.  Must be called before any SSL
    # traffic has started.
    def set_use_client_mode(flag)
      synchronized(self) do
        case (@connection_state)
        # If handshake has started, that's an error.  Fall through...
        when Cs_START
          @role_is_server = !flag
        when Cs_HANDSHAKE
          # If we have a handshaker, but haven't started
          # SSL traffic, we can throw away our current
          # handshaker, and start from scratch.  Don't
          # need to call doneConnect() again, we already
          # have the streams.
          raise AssertError if not ((!(@handshaker).nil?))
          if (!@handshaker.started)
            @role_is_server = !flag
            @connection_state = Cs_START
            init_handshaker
          end
        else
          if (!(Debug).nil? && Debug.is_on("ssl"))
            System.out.println(RJava.cast_to_string(thread_name) + ", setUseClientMode() invoked in state = " + RJava.cast_to_string(@connection_state))
          end
          raise IllegalArgumentException.new("Cannot change mode after SSL traffic has started")
        end
      end
    end
    
    typesig { [] }
    def get_use_client_mode
      synchronized(self) do
        return !@role_is_server
      end
    end
    
    typesig { [] }
    # Returns the names of the cipher suites which could be enabled for use
    # on an SSL connection.  Normally, only a subset of these will actually
    # be enabled by default, since this list may include cipher suites which
    # do not support the mutual authentication of servers and clients, or
    # which do not protect data confidentiality.  Servers may also need
    # certain kinds of certificates to use certain cipher suites.
    # 
    # @return an array of cipher suite names
    def get_supported_cipher_suites
      CipherSuiteList.clear_available_cache
      return CipherSuiteList.get_supported.to_string_array
    end
    
    typesig { [Array.typed(String)] }
    # Controls which particular cipher suites are enabled for use on
    # this connection.  The cipher suites must have been listed by
    # getCipherSuites() as being supported.  Even if a suite has been
    # enabled, it might never be used if no peer supports it or the
    # requisite certificates (and private keys) are not available.
    # 
    # @param suites Names of all the cipher suites to enable.
    def set_enabled_cipher_suites(suites)
      synchronized(self) do
        @enabled_cipher_suites = CipherSuiteList.new(suites)
        if ((!(@handshaker).nil?) && !@handshaker.started)
          @handshaker.attr_enabled_cipher_suites = @enabled_cipher_suites
        end
      end
    end
    
    typesig { [] }
    # Returns the names of the SSL cipher suites which are currently enabled
    # for use on this connection.  When an SSL socket is first created,
    # all enabled cipher suites <em>(a)</em> protect data confidentiality,
    # by traffic encryption, and <em>(b)</em> can mutually authenticate
    # both clients and servers.  Thus, in some environments, this value
    # might be empty.
    # 
    # @return an array of cipher suite names
    def get_enabled_cipher_suites
      synchronized(self) do
        return @enabled_cipher_suites.to_string_array
      end
    end
    
    typesig { [] }
    # Returns the protocols that are supported by this implementation.
    # A subset of the supported protocols may be enabled for this connection
    # @ returns an array of protocol names.
    def get_supported_protocols
      return ProtocolList.get_supported.to_string_array
    end
    
    typesig { [Array.typed(String)] }
    # Controls which protocols are enabled for use on
    # this connection.  The protocols must have been listed by
    # getSupportedProtocols() as being supported.
    # 
    # @param protocols protocols to enable.
    # @exception IllegalArgumentException when one of the protocols
    # named by the parameter is not supported.
    def set_enabled_protocols(protocols)
      synchronized(self) do
        @enabled_protocols = ProtocolList.new(protocols)
        if ((!(@handshaker).nil?) && !@handshaker.started)
          @handshaker.set_enabled_protocols(@enabled_protocols)
        end
      end
    end
    
    typesig { [] }
    def get_enabled_protocols
      synchronized(self) do
        return @enabled_protocols.to_string_array
      end
    end
    
    typesig { [::Java::Int] }
    # Assigns the socket timeout.
    # @see java.net.Socket#setSoTimeout
    def set_so_timeout(timeout)
      if ((!(Debug).nil?) && Debug.is_on("ssl"))
        System.out.println(RJava.cast_to_string(thread_name) + ", setSoTimeout(" + RJava.cast_to_string(timeout) + ") called")
      end
      if ((self.attr_self).equal?(self))
        super(timeout)
      else
        self.attr_self.set_so_timeout(timeout)
      end
    end
    
    typesig { [HandshakeCompletedListener] }
    # Registers an event listener to receive notifications that an
    # SSL handshake has completed on this connection.
    def add_handshake_completed_listener(listener)
      synchronized(self) do
        if ((listener).nil?)
          raise IllegalArgumentException.new("listener is null")
        end
        if ((@handshake_listeners).nil?)
          @handshake_listeners = HashMap.new(4)
        end
        @handshake_listeners.put(listener, AccessController.get_context)
      end
    end
    
    typesig { [HandshakeCompletedListener] }
    # Removes a previously registered handshake completion listener.
    def remove_handshake_completed_listener(listener)
      synchronized(self) do
        if ((@handshake_listeners).nil?)
          raise IllegalArgumentException.new("no listeners")
        end
        if ((@handshake_listeners.remove(listener)).nil?)
          raise IllegalArgumentException.new("listener not registered")
        end
        if (@handshake_listeners.is_empty)
          @handshake_listeners = nil
        end
      end
    end
    
    typesig { [String] }
    # Try to configure the endpoint identification algorithm of the socket.
    # 
    # @param identificationAlgorithm the algorithm used to check the
    # endpoint identity.
    # @return true if the identification algorithm configuration success.
    def try_set_hostname_verification(identification_algorithm)
      synchronized(self) do
        if (@ssl_context.get_x509trust_manager.is_a?(X509ExtendedTrustManager))
          @identification_alg = identification_algorithm
          return true
        else
          return false
        end
      end
    end
    
    typesig { [] }
    # Returns the endpoint identification algorithm of the socket.
    def get_hostname_verification
      synchronized(self) do
        return @identification_alg
      end
    end
    
    class_module.module_eval {
      # We allocate a separate thread to deliver handshake completion
      # events.  This ensures that the notifications don't block the
      # protocol state machine.
      const_set_lazy(:NotifyHandshakeThread) { Class.new(JavaThread) do
        include_class_members SSLSocketImpl
        
        attr_accessor :targets
        alias_method :attr_targets, :targets
        undef_method :targets
        alias_method :attr_targets=, :targets=
        undef_method :targets=
        
        # who gets notified
        attr_accessor :event
        alias_method :attr_event, :event
        undef_method :event
        alias_method :attr_event=, :event=
        undef_method :event=
        
        typesig { [self::JavaSet, self::HandshakeCompletedEvent] }
        # the notification
        def initialize(entry_set, e)
          @targets = nil
          @event = nil
          super("HandshakeCompletedNotify-Thread")
          @targets = entry_set
          @event = e
        end
        
        typesig { [] }
        def run
          @targets.each do |entry|
            l = entry.get_key
            acc = entry.get_value
            AccessController.do_privileged(Class.new(self.class::PrivilegedAction.class == Class ? self.class::PrivilegedAction : Object) do
              extend LocalClass
              include_class_members NotifyHandshakeThread
              include self::PrivilegedAction if self::PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                l.handshake_completed(self.attr_event)
                return nil
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self), acc)
          end
        end
        
        private
        alias_method :initialize__notify_handshake_thread, :initialize
      end }
      
      typesig { [] }
      # Return the name of the current thread. Utility method.
      def thread_name
        return JavaThread.current_thread.get_name
      end
    }
    
    typesig { [] }
    # Returns a printable representation of this end of the connection.
    def to_s
      retval = StringBuffer.new(80)
      retval.append(JavaInteger.to_hex_string(hash_code))
      retval.append("[")
      retval.append(@sess.get_cipher_suite)
      retval.append(": ")
      if ((self.attr_self).equal?(self))
        retval.append(super)
      else
        retval.append(self.attr_self.to_s)
      end
      retval.append("]")
      return retval.to_s
    end
    
    private
    alias_method :initialize__sslsocket_impl, :initialize
  end
  
end
