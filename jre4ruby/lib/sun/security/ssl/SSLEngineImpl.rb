require "rjava"

# 
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
  module SSLEngineImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Nio
      include_const ::Java::Nio, :ReadOnlyBufferException
      include_const ::Java::Util, :LinkedList
      include ::Java::Security
      include_const ::Javax::Crypto, :BadPaddingException
      include ::Javax::Net::Ssl
      include ::Javax::Net::Ssl::SSLEngineResult
      include_const ::Com::Sun::Net::Ssl::Internal::Ssl, :X509ExtendedTrustManager
    }
  end
  
  # 
  # Implementation of an non-blocking SSLEngine.
  # 
  # *Currently*, the SSLEngine code exists in parallel with the current
  # SSLSocket.  As such, the current implementation is using legacy code
  # with many of the same abstractions.  However, it varies in many
  # areas, most dramatically in the IO handling.
  # 
  # There are three main I/O threads that can be existing in parallel:
  # wrap(), unwrap(), and beginHandshake().  We are encouraging users to
  # not call multiple instances of wrap or unwrap, because the data could
  # appear to flow out of the SSLEngine in a non-sequential order.  We
  # take all steps we can to at least make sure the ordering remains
  # consistent, but once the calls returns, anything can happen.  For
  # example, thread1 and thread2 both call wrap, thread1 gets the first
  # packet, thread2 gets the second packet, but thread2 gets control back
  # before thread1, and sends the data.  The receiving side would see an
  # out-of-order error.
  # 
  # Handshaking is still done the same way as SSLSocket using the normal
  # InputStream/OutputStream abstactions.  We create
  # ClientHandshakers/ServerHandshakers, which produce/consume the
  # handshaking data.  The transfer of the data is largely handled by the
  # HandshakeInStream/HandshakeOutStreams.  Lastly, the
  # InputRecord/OutputRecords still have the same functionality, except
  # that they are overridden with EngineInputRecord/EngineOutputRecord,
  # which provide SSLEngine-specific functionality.
  # 
  # Some of the major differences are:
  # 
  # EngineInputRecord/EngineOutputRecord/EngineWriter:
  # 
  # In order to avoid writing whole new control flows for
  # handshaking, and to reuse most of the same code, we kept most
  # of the actual handshake code the same.  As usual, reading
  # handshake data may trigger output of more handshake data, so
  # what we do is write this data to internal buffers, and wait for
  # wrap() to be called to give that data a ride.
  # 
  # All data is routed through
  # EngineInputRecord/EngineOutputRecord.  However, all handshake
  # data (ct_alert/ct_change_cipher_spec/ct_handshake) are passed
  # through to the the underlying InputRecord/OutputRecord, and
  # the data uses the internal buffers.
  # 
  # Application data is handled slightly different, we copy the data
  # directly from the src to the dst buffers, and do all operations
  # on those buffers, saving the overhead of multiple copies.
  # 
  # In the case of an inbound record, unwrap passes the inbound
  # ByteBuffer to the InputRecord.  If the data is handshake data,
  # the data is read into the InputRecord's internal buffer.  If
  # the data is application data, the data is decoded directly into
  # the dst buffer.
  # 
  # In the case of an outbound record, when the write to the
  # "real" OutputStream's would normally take place, instead we
  # call back up to the EngineOutputRecord's version of
  # writeBuffer, at which time we capture the resulting output in a
  # ByteBuffer, and send that back to the EngineWriter for internal
  # storage.
  # 
  # EngineWriter is responsible for "handling" all outbound
  # data, be it handshake or app data, and for returning the data
  # to wrap() in the proper order.
  # 
  # ClientHandshaker/ServerHandshaker/Handshaker:
  # Methods which relied on SSLSocket now have work on either
  # SSLSockets or SSLEngines.
  # 
  # @author Brad Wetmore
  class SSLEngineImpl < SSLEngineImplImports.const_get :SSLEngine
    include_class_members SSLEngineImplImports
    
    # 
    # Fields and global comments
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
    # - CLOSED when one side closes down, used to start the shutdown
    # process.  SSL connection objects are not reused.
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
    # <-----<    ^            ^  <-----<               |
    # START>----->HANDSHAKE>----->DATA>----->RENEGOTIATE    |
    # v            v               v        |
    # |            |               |        |
    # +------------+---------------+        |
    # |                                     |
    # v                                     |
    # ERROR>------>----->CLOSED<--------<----+
    # 
    # ALSO, note that the the purpose of handshaking (renegotiation is
    # included) is to assign a different, and perhaps new, session to
    # the connection.  The SSLv3 spec is a bit confusing on that new
    # protocol feature.
    attr_accessor :connection_state
    alias_method :attr_connection_state, :connection_state
    undef_method :connection_state
    alias_method :attr_connection_state=, :connection_state=
    undef_method :connection_state=
    
    class_module.module_eval {
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
      
      const_set_lazy(:Cs_CLOSED) { 6 }
      const_attr_reader  :Cs_CLOSED
    }
    
    # 
    # Once we're in state cs_CLOSED, we can continue to
    # wrap/unwrap until we finish sending/receiving the messages
    # for close_notify.  EngineWriter handles outboundDone.
    attr_accessor :inbound_done
    alias_method :attr_inbound_done, :inbound_done
    undef_method :inbound_done
    alias_method :attr_inbound_done=, :inbound_done=
    undef_method :inbound_done=
    
    attr_accessor :writer
    alias_method :attr_writer, :writer
    undef_method :writer
    alias_method :attr_writer=, :writer=
    undef_method :writer=
    
    # 
    # The authentication context holds all information used to establish
    # who this end of the connection is (certificate chains, private keys,
    # etc) and who is trusted (e.g. as CAs or websites).
    attr_accessor :ssl_context
    alias_method :attr_ssl_context, :ssl_context
    undef_method :ssl_context
    alias_method :attr_ssl_context=, :ssl_context=
    undef_method :ssl_context=
    
    # 
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
    
    class_module.module_eval {
      # 
      # Client authentication be off, requested, or required.
      # 
      # This will be used by both this class and SSLSocket's variants.
      const_set_lazy(:Clauth_none) { 0 }
      const_attr_reader  :Clauth_none
      
      const_set_lazy(:Clauth_requested) { 1 }
      const_attr_reader  :Clauth_requested
      
      const_set_lazy(:Clauth_required) { 2 }
      const_attr_reader  :Clauth_required
    }
    
    # 
    # Flag indicating if the next record we receive MUST be a Finished
    # message. Temporarily set during the handshake to ensure that
    # a change cipher spec message is followed by a finished message.
    attr_accessor :expecting_finished
    alias_method :attr_expecting_finished, :expecting_finished
    undef_method :expecting_finished
    alias_method :attr_expecting_finished=, :expecting_finished=
    undef_method :expecting_finished=
    
    # 
    # If someone tries to closeInbound() (say at End-Of-Stream)
    # our engine having received a close_notify, we need to
    # notify the app that we may have a truncation attack underway.
    attr_accessor :recv_cn
    alias_method :attr_recv_cn, :recv_cn
    undef_method :recv_cn
    alias_method :attr_recv_cn=, :recv_cn=
    undef_method :recv_cn=
    
    # 
    # For improved diagnostics, we detail connection closure
    # If the engine is closed (connectionState >= cs_ERROR),
    # closeReason != null indicates if the engine was closed
    # because of an error or because or normal shutdown.
    attr_accessor :close_reason
    alias_method :attr_close_reason, :close_reason
    undef_method :close_reason
    alias_method :attr_close_reason=, :close_reason=
    undef_method :close_reason=
    
    # 
    # Per-connection private state that doesn't change when the
    # session is changed.
    attr_accessor :do_client_auth
    alias_method :attr_do_client_auth, :do_client_auth
    undef_method :do_client_auth
    alias_method :attr_do_client_auth=, :do_client_auth=
    undef_method :do_client_auth=
    
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
    
    attr_accessor :input_record
    alias_method :attr_input_record, :input_record
    undef_method :input_record
    alias_method :attr_input_record=, :input_record=
    undef_method :input_record=
    
    attr_accessor :output_record
    alias_method :attr_output_record, :output_record
    undef_method :output_record
    alias_method :attr_output_record=, :output_record=
    undef_method :output_record=
    
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
    
    # Have we been told whether we're client or server?
    attr_accessor :server_mode_set
    alias_method :attr_server_mode_set, :server_mode_set
    undef_method :server_mode_set
    alias_method :attr_server_mode_set=, :server_mode_set=
    undef_method :server_mode_set=
    
    attr_accessor :role_is_server
    alias_method :attr_role_is_server, :role_is_server
    undef_method :role_is_server
    alias_method :attr_role_is_server=, :role_is_server=
    undef_method :role_is_server=
    
    # 
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
    
    # 
    # The SSL version associated with this connection.
    attr_accessor :protocol_version
    alias_method :attr_protocol_version, :protocol_version
    undef_method :protocol_version
    alias_method :attr_protocol_version=, :protocol_version=
    undef_method :protocol_version=
    
    # 
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
    # Note that we must never acquire the <code>this</code> lock after
    # <code>writeLock</code> or run the risk of deadlock.
    # 
    # Grab some coffee, and be careful with any code changes.
    attr_accessor :wrap_lock
    alias_method :attr_wrap_lock, :wrap_lock
    undef_method :wrap_lock
    alias_method :attr_wrap_lock=, :wrap_lock=
    undef_method :wrap_lock=
    
    attr_accessor :unwrap_lock
    alias_method :attr_unwrap_lock, :unwrap_lock
    undef_method :unwrap_lock
    alias_method :attr_unwrap_lock=, :unwrap_lock=
    undef_method :unwrap_lock=
    
    attr_accessor :write_lock
    alias_method :attr_write_lock, :write_lock
    undef_method :write_lock
    alias_method :attr_write_lock=, :write_lock=
    undef_method :write_lock=
    
    class_module.module_eval {
      # 
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    typesig { [SSLContextImpl] }
    # 
    # Initialization/Constructors
    # 
    # 
    # Constructor for an SSLEngine from SSLContext, without
    # host/port hints.  This Engine will not be able to cache
    # sessions, but must renegotiate everything by hand.
    def initialize(ctx)
      @connection_state = 0
      @inbound_done = false
      @writer = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @expecting_finished = false
      @recv_cn = false
      @close_reason = nil
      @do_client_auth = 0
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @input_record = nil
      @output_record = nil
      @acc = nil
      @identification_alg = nil
      @server_mode_set = false
      @role_is_server = false
      @enabled_protocols = nil
      @protocol_version = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @wrap_lock = nil
      @unwrap_lock = nil
      @write_lock = nil
      super()
      @inbound_done = false
      @enable_session_creation = true
      @identification_alg = nil
      @server_mode_set = false
      @protocol_version = ProtocolVersion::DEFAULT
      init(ctx)
    end
    
    typesig { [SSLContextImpl, String, ::Java::Int] }
    # 
    # Constructor for an SSLEngine from SSLContext.
    def initialize(ctx, host, port)
      @connection_state = 0
      @inbound_done = false
      @writer = nil
      @ssl_context = nil
      @sess = nil
      @handshaker = nil
      @expecting_finished = false
      @recv_cn = false
      @close_reason = nil
      @do_client_auth = 0
      @enabled_cipher_suites = nil
      @enable_session_creation = false
      @input_record = nil
      @output_record = nil
      @acc = nil
      @identification_alg = nil
      @server_mode_set = false
      @role_is_server = false
      @enabled_protocols = nil
      @protocol_version = nil
      @read_mac = nil
      @write_mac = nil
      @read_cipher = nil
      @write_cipher = nil
      @wrap_lock = nil
      @unwrap_lock = nil
      @write_lock = nil
      super(host, port)
      @inbound_done = false
      @enable_session_creation = true
      @identification_alg = nil
      @server_mode_set = false
      @protocol_version = ProtocolVersion::DEFAULT
      init(ctx)
    end
    
    typesig { [SSLContextImpl] }
    # 
    # Initializes the Engine
    def init(ctx)
      if (!(Debug).nil? && Debug.is_on("ssl"))
        System.out.println("Using SSLEngineImpl.")
      end
      @ssl_context = ctx
      @sess = SSLSessionImpl.attr_null_session
      # 
      # State is cs_START until we initialize the handshaker.
      # 
      # Apps using SSLEngine are probably going to be server.
      # Somewhat arbitrary choice.
      @role_is_server = true
      @connection_state = Cs_START
      # 
      # default read and write side cipher and MAC support
      # 
      # Note:  compression support would go here too
      @read_cipher = CipherBox::NULL
      @read_mac = MAC::NULL
      @write_cipher = CipherBox::NULL
      @write_mac = MAC::NULL
      @enabled_cipher_suites = CipherSuiteList.get_default
      @enabled_protocols = ProtocolList.get_default
      @wrap_lock = Object.new
      @unwrap_lock = Object.new
      @write_lock = Object.new
      # 
      # Save the Access Control Context.  This will be used later
      # for a couple of things, including providing a context to
      # run tasks in, and for determining which credentials
      # to use for Subject based (JAAS) decisions
      @acc = AccessController.get_context
      # 
      # All outbound application data goes through this OutputRecord,
      # other data goes through their respective records created
      # elsewhere.  All inbound data goes through this one
      # input record.
      @output_record = EngineOutputRecord.new(Record.attr_ct_application_data, self)
      @input_record = EngineInputRecord.new(self)
      @input_record.enable_format_checks
      @writer = EngineWriter.new
    end
    
    typesig { [] }
    # 
    # Initialize the handshaker object. This means:
    # 
    # . if a handshake is already in progress (state is cs_HANDSHAKE
    # or cs_RENEGOTIATE), do nothing and return
    # 
    # . if the engine is already closed, throw an Exception (internal error)
    # 
    # . otherwise (cs_START or cs_DATA), create the appropriate handshaker
    # object, initialize it, and advance the connection state (to
    # cs_HANDSHAKE or cs_RENEGOTIATE, respectively).
    # 
    # This method is called right after a new engine is created, when
    # starting renegotiation, or when changing client/server mode of the
    # engine.
    def init_handshaker
      case (@connection_state)
      # 
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
    
    typesig { [HandshakeStatus] }
    # 
    # Report the current status of the Handshaker
    def get_hsstatus(hss)
      if (!(hss).nil?)
        return hss
      end
      synchronized((self)) do
        if (@writer.has_outbound_data)
          return HandshakeStatus::NEED_WRAP
        else
          if (!(@handshaker).nil?)
            if (@handshaker.task_outstanding)
              return HandshakeStatus::NEED_TASK
            else
              return HandshakeStatus::NEED_UNWRAP
            end
          else
            if ((@connection_state).equal?(Cs_CLOSED))
              # 
              # Special case where we're closing, but
              # still need the close_notify before we
              # can officially be closed.
              # 
              # Note isOutboundDone is taken care of by
              # hasOutboundData() above.
              if (!is_inbound_done)
                return HandshakeStatus::NEED_UNWRAP
              end # else not handshaking
            end
          end
        end
        return HandshakeStatus::NOT_HANDSHAKING
      end
    end
    
    typesig { [] }
    def check_task_thrown
      synchronized(self) do
        if (!(@handshaker).nil?)
          @handshaker.check_thrown
        end
      end
    end
    
    typesig { [] }
    # 
    # Handshaking and connection state code
    # 
    # 
    # Provides "this" synchronization for connection state.
    # Otherwise, you can access it directly.
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
    # 
    # Get the Access Control Context.
    # 
    # Used for a known context to
    # run tasks in, and for determining which credentials
    # to use for Subject-based (JAAS) decisions.
    def get_acc
      return @acc
    end
    
    typesig { [] }
    # 
    # Is a handshake currently underway?
    def get_handshake_status
      return get_hsstatus(nil)
    end
    
    typesig { [] }
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
    # 
    # Synchronized on "this" from readRecord.
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
    # 
    # used by Handshaker to change the active write cipher, follows
    # the output of the CCS message.
    # 
    # Also synchronized on "this" from readRecord/delegatedTask.
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
    # 
    # Updates the SSL version associated with this connection.
    # Called from Handshaker once it has determined the negotiated version.
    def set_version(protocol_version)
      synchronized(self) do
        @protocol_version = protocol_version
        @output_record.set_version(protocol_version)
      end
    end
    
    typesig { [] }
    # 
    # Kickstart the handshake if it is not already in progress.
    # This means:
    # 
    # . if handshaking is already underway, do nothing and return
    # 
    # . if the engine is not connected or already closed, throw an
    # Exception.
    # 
    # . otherwise, call initHandshake() to initialize the handshaker
    # object and progress the state. Then, send the initial
    # handshaking message if appropriate (always on clients and
    # on servers when renegotiating).
    def kickstart_handshake
      synchronized(self) do
        case (@connection_state)
        when Cs_START
          if (!@server_mode_set)
            raise IllegalStateException.new("Client/Server mode not yet set.")
          end
          init_handshaker
        when Cs_HANDSHAKE
          # handshaker already setup, proceed
        when Cs_DATA
          # initialize the handshaker, move to cs_RENEGOTIATE
          init_handshaker
        when Cs_RENEGOTIATE
          # handshaking already in progress, return
          return
        else
          # cs_ERROR/cs_CLOSED
          raise SSLException.new("SSLEngine is closing/closed")
        end
        # 
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
            # instanceof ServerHandshaker
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
    # 
    # Start a SSLEngine handshake
    def begin_handshake
      begin
        kickstart_handshake
      rescue Exception => e
        fatal(Alerts.attr_alert_handshake_failure, "Couldn't kickstart handshaking", e)
      end
    end
    
    typesig { [ByteBuffer, Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    # 
    # Read/unwrap side
    # 
    # 
    # Unwraps a buffer.  Does a variety of checks before grabbing
    # the unwrapLock, which blocks multiple unwraps from occuring.
    def unwrap(net_data, app_data, offset, length)
      ea = EngineArgs.new(net_data, app_data, offset, length)
      begin
        synchronized((@unwrap_lock)) do
          return read_net_record(ea)
        end
      rescue Exception => e
        # 
        # Don't reset position so it looks like we didn't
        # consume anything.  We did consume something, and it
        # got us into this situation, so report that much back.
        # Our days of consuming are now over anyway.
        fatal(Alerts.attr_alert_internal_error, "problem unwrapping net record", e)
        return nil # make compiler happy
      ensure
        # 
        # Just in case something failed to reset limits properly.
        ea.reset_lim
      end
    end
    
    typesig { [EngineArgs] }
    # 
    # Makes additional checks for unwrap, but this time more
    # specific to this packet and the current state of the machine.
    def read_net_record(ea)
      status = nil
      hs_status = nil
      # 
      # See if the handshaker needs to report back some SSLException.
      check_task_thrown
      # 
      # Check if we are closing/closed.
      if (is_inbound_done)
        return SSLEngineResult.new(Status::CLOSED, get_hsstatus(nil), 0, 0)
      end
      # 
      # If we're still in cs_HANDSHAKE, make sure it's been
      # started.
      synchronized((self)) do
        if (((@connection_state).equal?(Cs_HANDSHAKE)) || ((@connection_state).equal?(Cs_START)))
          kickstart_handshake
          # 
          # If there's still outbound data to flush, we
          # can return without trying to unwrap anything.
          hs_status = get_hsstatus(nil)
          if ((hs_status).equal?(HandshakeStatus::NEED_WRAP))
            return SSLEngineResult.new(Status::OK, hs_status, 0, 0)
          end
        end
      end
      # 
      # Grab a copy of this if it doesn't already exist,
      # and we can use it several places before anything major
      # happens on this side.  Races aren't critical
      # here.
      if ((hs_status).nil?)
        hs_status = get_hsstatus(nil)
      end
      # 
      # If we have a task outstanding, this *MUST* be done before
      # doing any more unwrapping, because we could be in the middle
      # of receiving a handshake message, for example, a finished
      # message which would change the ciphers.
      if ((hs_status).equal?(HandshakeStatus::NEED_TASK))
        return SSLEngineResult.new(Status::OK, hs_status, 0, 0)
      end
      # 
      # Check the packet to make sure enough is here.
      # This will also indirectly check for 0 len packets.
      packet_len = @input_record.bytes_in_complete_packet(ea.attr_net_data)
      # Is this packet bigger than SSL/TLS normally allows?
      if (packet_len > @sess.get_packet_buffer_size)
        if (packet_len > Record.attr_max_large_record_size)
          raise SSLProtocolException.new("Input SSL/TLS record too big: max = " + (Record.attr_max_large_record_size).to_s + " len = " + (packet_len).to_s)
        else
          # Expand the expected maximum packet/application buffer
          # sizes.
          @sess.expand_buffer_sizes
        end
      end
      # 
      # Check for OVERFLOW.
      # 
      # To be considered: We could delay enforcing the application buffer
      # free space requirement until after the initial handshaking.
      if ((packet_len - Record.attr_header_size) > ea.get_app_remaining)
        return SSLEngineResult.new(Status::BUFFER_OVERFLOW, hs_status, 0, 0)
      end
      # check for UNDERFLOW.
      if (((packet_len).equal?(-1)) || (ea.attr_net_data.remaining < packet_len))
        return SSLEngineResult.new(Status::BUFFER_UNDERFLOW, hs_status, 0, 0)
      end
      # 
      # We're now ready to actually do the read.
      # The only result code we really need to be exactly
      # right is the HS finished, for signaling to
      # HandshakeCompletedListeners.
      begin
        hs_status = read_record(ea)
      rescue SSLException => e
        raise e
      rescue IOException => e
        ex = SSLException.new("readRecord")
        ex.init_cause(e_)
        raise ex
      end
      # 
      # Check the various condition that we could be reporting.
      # 
      # It's *possible* something might have happened between the
      # above and now, but it was better to minimally lock "this"
      # during the read process.  We'll return the current
      # status, which is more representative of the current state.
      # 
      # status above should cover:  FINISHED, NEED_TASK
      status = (is_inbound_done ? Status::CLOSED : Status::OK)
      hs_status = get_hsstatus(hs_status)
      return SSLEngineResult.new(status, hs_status, ea.delta_net, ea.delta_app)
    end
    
    typesig { [EngineArgs] }
    # 
    # Actually do the read record processing.
    # 
    # Returns a Status if it can make specific determinations
    # of the engine state.  In particular, we need to signal
    # that a handshake just completed.
    # 
    # It would be nice to be symmetrical with the write side and move
    # the majority of this to EngineInputRecord, but there's too much
    # SSLEngine state to do that cleanly.  It must still live here.
    def read_record(ea)
      hs_status = nil
      # 
      # The various operations will return new sliced BB's,
      # this will avoid having to worry about positions and
      # limits in the netBB.
      read_bb = nil
      decrypted_bb = nil
      if (!(get_connection_state).equal?(Cs_ERROR))
        # 
        # Read a record ... maybe emitting an alert if we get a
        # comprehensible but unsupported "hello" message during
        # format checking (e.g. V2).
        begin
          read_bb = @input_record.read(ea.attr_net_data)
        rescue IOException => e
          fatal(Alerts.attr_alert_unexpected_message, e)
        end
        # 
        # The basic SSLv3 record protection involves (optional)
        # encryption for privacy, and an integrity check ensuring
        # data origin authentication.  We do them both here, and
        # throw a fatal alert if the integrity check fails.
        begin
          decrypted_bb = @input_record.decrypt(@read_cipher, read_bb)
        rescue BadPaddingException => e
          # RFC 2246 states that decryption_failed should be used
          # for this purpose. However, that allows certain attacks,
          # so we just send bad record MAC. We also need to make
          # sure to always check the MAC to avoid a timing attack
          # for the same issue. See paper by Vaudenay et al.
          # 
          # rewind the BB if necessary.
          read_bb.rewind
          @input_record.check_mac(@read_mac, read_bb)
          # use the same alert types as for MAC failure below
          alert_type = ((@input_record.content_type).equal?(Record.attr_ct_handshake)) ? Alerts.attr_alert_handshake_failure : Alerts.attr_alert_bad_record_mac
          fatal(alert_type, "Invalid padding", e_)
        end
        if (!@input_record.check_mac(@read_mac, decrypted_bb))
          if ((@input_record.content_type).equal?(Record.attr_ct_handshake))
            fatal(Alerts.attr_alert_handshake_failure, "bad handshake record MAC")
          else
            fatal(Alerts.attr_alert_bad_record_mac, "bad record MAC")
          end
        end
        # if (!inputRecord.decompress(c))
        # fatal(Alerts.alert_decompression_failure,
        # "decompression failure");
        # 
        # Process the record.
        synchronized((self)) do
          case (@input_record.content_type)
          when Record.attr_ct_handshake
            # 
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
            # 
            # process the handshake record ... may contain just
            # a partial handshake message or multiple messages.
            # 
            # The handshaker state machine will ensure that it's
            # a finished message.
            @handshaker.process_record(@input_record, @expecting_finished)
            @expecting_finished = false
            if (@handshaker.is_done)
              @sess = @handshaker.get_session
              if (!@writer.has_outbound_data)
                hs_status = HandshakeStatus::FINISHED
              end
              @handshaker = nil
              @connection_state = Cs_DATA
              # No handshakeListeners here.  That's a
              # SSLSocket thing.
            else
              if (@handshaker.task_outstanding)
                hs_status = HandshakeStatus::NEED_TASK
              end
            end
          when Record.attr_ct_application_data
            # Pass this right back up to the application.
            if ((!(@connection_state).equal?(Cs_DATA)) && (!(@connection_state).equal?(Cs_RENEGOTIATE)) && (!(@connection_state).equal?(Cs_CLOSED)))
              raise SSLProtocolException.new("Data received in non-data state: " + (@connection_state).to_s)
            end
            if (@expecting_finished)
              raise SSLProtocolException.new("Expecting finished message, received data")
            end
            # 
            # Don't return data once the inbound side is
            # closed.
            if (!@inbound_done)
              ea.scatter(decrypted_bb.slice)
            end
          when Record.attr_ct_alert
            recv_alert
          when Record.attr_ct_change_cipher_spec
            if ((!(@connection_state).equal?(Cs_HANDSHAKE) && !(@connection_state).equal?(Cs_RENEGOTIATE)) || !(@input_record.available).equal?(1) || !(@input_record.read).equal?(1))
              fatal(Alerts.attr_alert_unexpected_message, "illegal change cipher spec msg, state = " + (@connection_state).to_s)
            end
            # 
            # The first message after a change_cipher_spec
            # record MUST be a "Finished" handshake record,
            # else it's a protocol violation.  We force this
            # to be checked by a minor tweak to the state
            # machine.
            change_read_ciphers
            # next message MUST be a finished message
            @expecting_finished = true
          else
            # 
            # TLS requires that unrecognized records be ignored.
            if (!(Debug).nil? && Debug.is_on("ssl"))
              System.out.println((thread_name).to_s + ", Received record type: " + (@input_record.content_type).to_s)
            end
          end
          # switch
        end # synchronized (this)
      end
      return hs_status
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int, ByteBuffer] }
    # 
    # write/wrap side
    # 
    # 
    # Wraps a buffer.  Does a variety of checks before grabbing
    # the wrapLock, which blocks multiple wraps from occuring.
    def wrap(app_data, offset, length, net_data)
      ea = EngineArgs.new(app_data, offset, length, net_data)
      # 
      # We can be smarter about using smaller buffer sizes later.
      # For now, force it to be large enough to handle any
      # valid SSL/TLS record.
      if (net_data.remaining < @output_record.attr_max_record_size)
        return SSLEngineResult.new(Status::BUFFER_OVERFLOW, get_hsstatus(nil), 0, 0)
      end
      begin
        synchronized((@wrap_lock)) do
          return write_app_record(ea)
        end
      rescue Exception => e
        ea.reset_pos
        fatal(Alerts.attr_alert_internal_error, "problem unwrapping net record", e)
        return nil # make compiler happy
      ensure
        # 
        # Just in case something didn't reset limits properly.
        ea.reset_lim
      end
    end
    
    typesig { [EngineArgs] }
    # 
    # Makes additional checks for unwrap, but this time more
    # specific to this packet and the current state of the machine.
    def write_app_record(ea)
      status = nil
      hs_status = nil
      # 
      # See if the handshaker needs to report back some SSLException.
      check_task_thrown
      # 
      # short circuit if we're closed/closing.
      if (@writer.is_outbound_done)
        return SSLEngineResult.new(Status::CLOSED, get_hsstatus(nil), 0, 0)
      end
      # 
      # If we're still in cs_HANDSHAKE, make sure it's been
      # started.
      synchronized((self)) do
        if (((@connection_state).equal?(Cs_HANDSHAKE)) || ((@connection_state).equal?(Cs_START)))
          kickstart_handshake
          # 
          # If there's no HS data available to write, we can return
          # without trying to wrap anything.
          hs_status = get_hsstatus(nil)
          if ((hs_status).equal?(HandshakeStatus::NEED_UNWRAP))
            return SSLEngineResult.new(Status::OK, hs_status, 0, 0)
          end
        end
      end
      # 
      # Grab a copy of this if it doesn't already exist,
      # and we can use it several places before anything major
      # happens on this side.  Races aren't critical
      # here.
      if ((hs_status).nil?)
        hs_status = get_hsstatus(nil)
      end
      # 
      # If we have a task outstanding, this *MUST* be done before
      # doing any more wrapping, because we could be in the middle
      # of receiving a handshake message, for example, a finished
      # message which would change the ciphers.
      if ((hs_status).equal?(HandshakeStatus::NEED_TASK))
        return SSLEngineResult.new(Status::OK, hs_status, 0, 0)
      end
      # 
      # This will obtain any waiting outbound data, or will
      # process the outbound appData.
      begin
        synchronized((@write_lock)) do
          hs_status = write_record(@output_record, ea)
        end
      rescue SSLException => e
        raise e
      rescue IOException => e
        ex = SSLException.new("Write problems")
        ex.init_cause(e_)
        raise ex
      end
      # 
      # writeRecord might have reported some status.
      # Now check for the remaining cases.
      # 
      # status above should cover:  NEED_WRAP/FINISHED
      status = (is_outbound_done ? Status::CLOSED : Status::OK)
      hs_status = get_hsstatus(hs_status)
      return SSLEngineResult.new(status, hs_status, ea.delta_app, ea.delta_net)
    end
    
    typesig { [EngineOutputRecord, EngineArgs] }
    # 
    # Central point to write/get all of the outgoing data.
    def write_record(eor, ea)
      # eventually compress as well.
      return @writer.write_record(eor, ea, @write_mac, @write_cipher)
    end
    
    typesig { [EngineOutputRecord] }
    # 
    # Non-application OutputRecords go through here.
    def write_record(eor)
      # eventually compress as well.
      @writer.write_record(eor, @write_mac, @write_cipher)
    end
    
    typesig { [] }
    # 
    # Close code
    # 
    # 
    # Signals that no more outbound application data will be sent
    # on this <code>SSLEngine</code>.
    def close_outbound_internal
      if ((!(Debug).nil?) && Debug.is_on("ssl"))
        System.out.println((thread_name).to_s + ", closeOutboundInternal()")
      end
      # 
      # Already closed, ignore
      if (@writer.is_outbound_done)
        return
      end
      case (@connection_state)
      # 
      # If we haven't even started yet, don't bother reading inbound.
      # 
      # 
      # Otherwise we indicate clean termination.
      # 
      # case cs_HANDSHAKE:
      # case cs_DATA:
      # case cs_RENEGOTIATE:
      when Cs_START
        @writer.close_outbound
        @inbound_done = true
      when Cs_ERROR, Cs_CLOSED
      else
        warning(Alerts.attr_alert_close_notify)
        @writer.close_outbound
      end
      @connection_state = Cs_CLOSED
    end
    
    typesig { [] }
    def close_outbound
      synchronized(self) do
        # 
        # Dump out a close_notify to the remote side
        if ((!(Debug).nil?) && Debug.is_on("ssl"))
          System.out.println((thread_name).to_s + ", called closeOutbound()")
        end
        close_outbound_internal
      end
    end
    
    typesig { [] }
    # 
    # Returns the outbound application data closure state
    def is_outbound_done
      return @writer.is_outbound_done
    end
    
    typesig { [] }
    # 
    # Signals that no more inbound network data will be sent
    # to this <code>SSLEngine</code>.
    def close_inbound_internal
      if ((!(Debug).nil?) && Debug.is_on("ssl"))
        System.out.println((thread_name).to_s + ", closeInboundInternal()")
      end
      # 
      # Already closed, ignore
      if (@inbound_done)
        return
      end
      close_outbound_internal
      @inbound_done = true
      @connection_state = Cs_CLOSED
    end
    
    typesig { [] }
    # 
    # Close the inbound side of the connection.  We grab the
    # lock here, and do the real work in the internal verison.
    # We do check for truncation attacks.
    def close_inbound
      synchronized(self) do
        # 
        # Currently closes the outbound side as well.  The IETF TLS
        # working group has expressed the opinion that 1/2 open
        # connections are not allowed by the spec.  May change
        # someday in the future.
        if ((!(Debug).nil?) && Debug.is_on("ssl"))
          System.out.println((thread_name).to_s + ", called closeInbound()")
        end
        # 
        # No need to throw an Exception if we haven't even started yet.
        if ((!(@connection_state).equal?(Cs_START)) && !@recv_cn)
          @recv_cn = true # Only receive the Exception once
          fatal(Alerts.attr_alert_internal_error, "Inbound closed before receiving peer's close_notify: " + "possible truncation attack?")
        else
          # 
          # Currently, this is a no-op, but in case we change
          # the close inbound code later.
          close_inbound_internal
        end
      end
    end
    
    typesig { [] }
    # 
    # Returns the network inbound data closure state
    def is_inbound_done
      synchronized(self) do
        return @inbound_done
      end
    end
    
    typesig { [] }
    # 
    # Misc stuff
    # 
    # 
    # Returns the current <code>SSLSession</code> for this
    # <code>SSLEngine</code>
    # <P>
    # These can be long lived, and frequently correspond to an
    # entire login session for some user.
    def get_session
      synchronized(self) do
        return @sess
      end
    end
    
    typesig { [] }
    # 
    # Returns a delegated <code>Runnable</code> task for
    # this <code>SSLEngine</code>.
    def get_delegated_task
      synchronized(self) do
        if (!(@handshaker).nil?)
          return @handshaker.get_task
        end
        return nil
      end
    end
    
    typesig { [::Java::Byte] }
    # 
    # EXCEPTION AND ALERT HANDLING
    # 
    # 
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
    
    typesig { [::Java::Byte, Exception] }
    def fatal(description, cause)
      synchronized(self) do
        fatal(description, nil, cause)
      end
    end
    
    typesig { [::Java::Byte, String, Exception] }
    # 
    # We've got a fatal error here, so start the shutdown process.
    # 
    # Because of the way the code was written, we have some code
    # calling fatal directly when the "description" is known
    # and some throwing Exceptions which are then caught by higher
    # levels which then call here.  This code needs to determine
    # if one of the lower levels has already started the process.
    # 
    # We won't worry about Error's, if we have one of those,
    # we're in worse trouble.  Note:  the networking code doesn't
    # deal with Errors either.
    def fatal(description, diagnostic, cause)
      synchronized(self) do
        # 
        # If we have no further information, make a general-purpose
        # message for folks to see.  We generally have one or the other.
        if ((diagnostic).nil?)
          diagnostic = "General SSLEngine problem"
        end
        if ((cause).nil?)
          cause = Alerts.get_sslexception(description, cause, diagnostic)
        end
        # 
        # If we've already shutdown because of an error,
        # there is nothing we can do except rethrow the exception.
        # 
        # Most exceptions seen here will be SSLExceptions.
        # We may find the occasional Exception which hasn't been
        # converted to a SSLException, so we'll do it here.
        if (!(@close_reason).nil?)
          if ((!(Debug).nil?) && Debug.is_on("ssl"))
            System.out.println((thread_name).to_s + ", fatal: engine already closed.  Rethrowing " + (cause.to_s).to_s)
          end
          if (cause.is_a?(RuntimeException))
            raise cause
          else
            if (cause.is_a?(SSLException))
              raise cause
            else
              if (cause.is_a?(Exception))
                ssle = SSLException.new("fatal SSLEngine condition")
                ssle.init_cause(cause)
                raise ssle
              end
            end
          end
        end
        if ((!(Debug).nil?) && Debug.is_on("ssl"))
          System.out.println((thread_name).to_s + ", fatal error: " + (description).to_s + ": " + diagnostic + "\n" + (cause.to_s).to_s)
        end
        # 
        # Ok, this engine's going down.
        old_state = @connection_state
        @connection_state = Cs_ERROR
        @inbound_done = true
        @sess.invalidate
        # 
        # If we haven't even started handshaking yet, no need
        # to generate the fatal close alert.
        if (!(old_state).equal?(Cs_START))
          send_alert(Alerts.attr_alert_fatal, description)
        end
        if (cause.is_a?(SSLException))
          # only true if != null
          @close_reason = cause
        else
          # 
          # Including RuntimeExceptions, but we'll throw those
          # down below.  The closeReason isn't used again,
          # except for null checks.
          @close_reason = Alerts.get_sslexception(description, cause, diagnostic)
        end
        @writer.close_outbound
        @connection_state = Cs_CLOSED
        if (cause.is_a?(RuntimeException))
          raise cause
        else
          raise @close_reason
        end
      end
    end
    
    typesig { [] }
    # 
    # Process an incoming alert ... caller must already have synchronized
    # access to "this".
    def recv_alert
      level = @input_record.read
      description = @input_record.read
      if ((description).equal?(-1))
        # check for short message
        fatal(Alerts.attr_alert_illegal_parameter, "Short alert message")
      end
      if (!(Debug).nil? && (Debug.is_on("record") || Debug.is_on("handshake")))
        synchronized((System.out)) do
          System.out.print(thread_name)
          System.out.print(", RECV " + (@protocol_version).to_s + " ALERT:  ")
          if ((level).equal?(Alerts.attr_alert_fatal))
            System.out.print("fatal, ")
          else
            if ((level).equal?(Alerts.attr_alert_warning))
              System.out.print("warning, ")
            else
              System.out.print("<level " + ((0xff & level)).to_s + ">, ")
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
            @recv_cn = true
            close_inbound_internal # reply to close
          end
        else
          # 
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
        reason = "Received fatal alert: " + (Alerts.alert_description(description)).to_s
        if ((@close_reason).nil?)
          @close_reason = Alerts.get_sslexception(description, reason)
        end
        fatal(Alerts.attr_alert_unexpected_message, reason)
      end
    end
    
    typesig { [::Java::Byte, ::Java::Byte] }
    # 
    # Emit alerts.  Caller must have synchronized with "this".
    def send_alert(level, description)
      if (@connection_state >= Cs_CLOSED)
        return
      end
      r = EngineOutputRecord.new(Record.attr_ct_alert, self)
      r.set_version(@protocol_version)
      use_debug = !(Debug).nil? && Debug.is_on("ssl")
      if (use_debug)
        synchronized((System.out)) do
          System.out.print(thread_name)
          System.out.print(", SEND " + (@protocol_version).to_s + " ALERT:  ")
          if ((level).equal?(Alerts.attr_alert_fatal))
            System.out.print("fatal, ")
          else
            if ((level).equal?(Alerts.attr_alert_warning))
              System.out.print("warning, ")
            else
              System.out.print("<level = " + ((0xff & level)).to_s + ">, ")
            end
          end
          System.out.println("description = " + (Alerts.alert_description(description)).to_s)
        end
      end
      r.write(level)
      r.write(description)
      begin
        write_record(r)
      rescue IOException => e
        if (use_debug)
          System.out.println((thread_name).to_s + ", Exception sending alert: " + (e).to_s)
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # 
    # VARIOUS OTHER METHODS (COMMON TO SSLSocket)
    # 
    # 
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
    # 
    # Returns true if new connections may cause creation of new SSL
    # sessions.
    def get_enable_session_creation
      synchronized(self) do
        return @enable_session_creation
      end
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Sets the flag controlling whether a server mode engine
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
    # 
    # Sets the flag controlling whether a server mode engine
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
    # 
    # Sets the flag controlling whether the engine is in SSL
    # client or server mode.  Must be called before any SSL
    # traffic has started.
    def set_use_client_mode(flag)
      synchronized(self) do
        catch(:break_case) do
          case (@connection_state)
          # If handshake has started, that's an error.  Fall through...
          when Cs_START
            @role_is_server = !flag
            @server_mode_set = true
          when Cs_HANDSHAKE
            # 
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
              throw :break_case, :thrown
            end
            if (!(Debug).nil? && Debug.is_on("ssl"))
              System.out.println((thread_name).to_s + ", setUseClientMode() invoked in state = " + (@connection_state).to_s)
            end
            # 
            # We can let them continue if they catch this correctly,
            # we don't need to shut this down.
            raise IllegalArgumentException.new("Cannot change mode after SSL traffic has started")
          else
            if (!(Debug).nil? && Debug.is_on("ssl"))
              System.out.println((thread_name).to_s + ", setUseClientMode() invoked in state = " + (@connection_state).to_s)
            end
            # 
            # We can let them continue if they catch this correctly,
            # we don't need to shut this down.
            raise IllegalArgumentException.new("Cannot change mode after SSL traffic has started")
          end
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
    # 
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
    # 
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
    # 
    # Returns the names of the SSL cipher suites which are currently enabled
    # for use on this connection.  When an SSL engine is first created,
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
    # 
    # Returns the protocols that are supported by this implementation.
    # A subset of the supported protocols may be enabled for this connection
    # @ returns an array of protocol names.
    def get_supported_protocols
      return ProtocolList.get_supported.to_string_array
    end
    
    typesig { [Array.typed(String)] }
    # 
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
    
    typesig { [String] }
    # 
    # Try to configure the endpoint identification algorithm of the engine.
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
    # 
    # Returns the endpoint identification algorithm of the engine.
    def get_hostname_verification
      synchronized(self) do
        return @identification_alg
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Return the name of the current thread. Utility method.
      def thread_name
        return JavaThread.current_thread.get_name
      end
    }
    
    typesig { [] }
    # 
    # Returns a printable representation of this end of the connection.
    def to_s
      retval = StringBuilder.new(80)
      retval.append(JavaInteger.to_hex_string(hash_code))
      retval.append("[")
      retval.append("SSLEngine[hostname=")
      host = get_peer_host
      retval.append(((host).nil?) ? "null" : host)
      retval.append(" port=")
      retval.append(JavaInteger.to_s(get_peer_port))
      retval.append("] ")
      retval.append(get_session.get_cipher_suite)
      retval.append("]")
      return retval.to_s
    end
    
    private
    alias_method :initialize__sslengine_impl, :initialize
  end
  
end
