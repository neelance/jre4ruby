require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Krb5
  module Krb5ContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Security::Jgss, :GSSUtil
      include ::Sun::Security::Jgss::Spi
      include_const ::Sun::Security::Jgss, :TokenTracker
      include ::Sun::Security::Krb5
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Javax::Crypto, :Cipher
      include_const ::Javax::Security::Auth, :Subject
      include ::Javax::Security::Auth::Kerberos
    }
  end
  
  # Implements the mechanism specific context class for the Kerberos v5
  # GSS-API mechanism.
  # 
  # @author Mayank Upadhyay
  # @author Ram Marti
  # @since 1.4
  class Krb5Context 
    include_class_members Krb5ContextImports
    include GSSContextSpi
    
    class_module.module_eval {
      # The different states that this context can be in.
      const_set_lazy(:STATE_NEW) { 1 }
      const_attr_reader  :STATE_NEW
      
      const_set_lazy(:STATE_IN_PROCESS) { 2 }
      const_attr_reader  :STATE_IN_PROCESS
      
      const_set_lazy(:STATE_DONE) { 3 }
      const_attr_reader  :STATE_DONE
      
      const_set_lazy(:STATE_DELETED) { 4 }
      const_attr_reader  :STATE_DELETED
    }
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # Optional features that the application can set and their default
    # values.
    attr_accessor :cred_deleg_state
    alias_method :attr_cred_deleg_state, :cred_deleg_state
    undef_method :cred_deleg_state
    alias_method :attr_cred_deleg_state=, :cred_deleg_state=
    undef_method :cred_deleg_state=
    
    attr_accessor :mutual_auth_state
    alias_method :attr_mutual_auth_state, :mutual_auth_state
    undef_method :mutual_auth_state
    alias_method :attr_mutual_auth_state=, :mutual_auth_state=
    undef_method :mutual_auth_state=
    
    attr_accessor :replay_det_state
    alias_method :attr_replay_det_state, :replay_det_state
    undef_method :replay_det_state
    alias_method :attr_replay_det_state=, :replay_det_state=
    undef_method :replay_det_state=
    
    attr_accessor :sequence_det_state
    alias_method :attr_sequence_det_state, :sequence_det_state
    undef_method :sequence_det_state
    alias_method :attr_sequence_det_state=, :sequence_det_state=
    undef_method :sequence_det_state=
    
    attr_accessor :conf_state
    alias_method :attr_conf_state, :conf_state
    undef_method :conf_state
    alias_method :attr_conf_state=, :conf_state=
    undef_method :conf_state=
    
    attr_accessor :integ_state
    alias_method :attr_integ_state, :integ_state
    undef_method :integ_state
    alias_method :attr_integ_state=, :integ_state=
    undef_method :integ_state=
    
    attr_accessor :my_seq_number
    alias_method :attr_my_seq_number, :my_seq_number
    undef_method :my_seq_number
    alias_method :attr_my_seq_number=, :my_seq_number=
    undef_method :my_seq_number=
    
    attr_accessor :peer_seq_number
    alias_method :attr_peer_seq_number, :peer_seq_number
    undef_method :peer_seq_number
    alias_method :attr_peer_seq_number=, :peer_seq_number=
    undef_method :peer_seq_number=
    
    attr_accessor :peer_token_tracker
    alias_method :attr_peer_token_tracker, :peer_token_tracker
    undef_method :peer_token_tracker
    alias_method :attr_peer_token_tracker=, :peer_token_tracker=
    undef_method :peer_token_tracker=
    
    attr_accessor :cipher_helper
    alias_method :attr_cipher_helper, :cipher_helper
    undef_method :cipher_helper
    alias_method :attr_cipher_helper=, :cipher_helper=
    undef_method :cipher_helper=
    
    # Separate locks for the sequence numbers allow the application to
    # receive tokens at the same time that it is sending tokens. Note
    # that the application must synchronize the generation and
    # transmission of tokens such that tokens are processed in the same
    # order that they are generated. This is important when sequence
    # checking of per-message tokens is enabled.
    attr_accessor :my_seq_number_lock
    alias_method :attr_my_seq_number_lock, :my_seq_number_lock
    undef_method :my_seq_number_lock
    alias_method :attr_my_seq_number_lock=, :my_seq_number_lock=
    undef_method :my_seq_number_lock=
    
    attr_accessor :peer_seq_number_lock
    alias_method :attr_peer_seq_number_lock, :peer_seq_number_lock
    undef_method :peer_seq_number_lock
    alias_method :attr_peer_seq_number_lock=, :peer_seq_number_lock=
    undef_method :peer_seq_number_lock=
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :my_name
    alias_method :attr_my_name, :my_name
    undef_method :my_name
    alias_method :attr_my_name=, :my_name=
    undef_method :my_name=
    
    attr_accessor :peer_name
    alias_method :attr_peer_name, :peer_name
    undef_method :peer_name
    alias_method :attr_peer_name=, :peer_name=
    undef_method :peer_name=
    
    attr_accessor :lifetime
    alias_method :attr_lifetime, :lifetime
    undef_method :lifetime
    alias_method :attr_lifetime=, :lifetime=
    undef_method :lifetime=
    
    attr_accessor :initiator
    alias_method :attr_initiator, :initiator
    undef_method :initiator
    alias_method :attr_initiator=, :initiator=
    undef_method :initiator=
    
    attr_accessor :channel_binding
    alias_method :attr_channel_binding, :channel_binding
    undef_method :channel_binding
    alias_method :attr_channel_binding=, :channel_binding=
    undef_method :channel_binding=
    
    attr_accessor :my_cred
    alias_method :attr_my_cred, :my_cred
    undef_method :my_cred
    alias_method :attr_my_cred=, :my_cred=
    undef_method :my_cred=
    
    attr_accessor :delegated_cred
    alias_method :attr_delegated_cred, :delegated_cred
    undef_method :delegated_cred
    alias_method :attr_delegated_cred=, :delegated_cred=
    undef_method :delegated_cred=
    
    # Set only on acceptor side
    # DESCipher instance used by the corresponding GSSContext
    attr_accessor :des_cipher
    alias_method :attr_des_cipher, :des_cipher
    undef_method :des_cipher
    alias_method :attr_des_cipher=, :des_cipher=
    undef_method :des_cipher=
    
    # XXX See if the required info from these can be extracted and
    # stored elsewhere
    attr_accessor :service_creds
    alias_method :attr_service_creds, :service_creds
    undef_method :service_creds
    alias_method :attr_service_creds=, :service_creds=
    undef_method :service_creds=
    
    attr_accessor :ap_req
    alias_method :attr_ap_req, :ap_req
    undef_method :ap_req
    alias_method :attr_ap_req=, :ap_req=
    undef_method :ap_req=
    
    attr_accessor :caller
    alias_method :attr_caller, :caller
    undef_method :caller
    alias_method :attr_caller=, :caller=
    undef_method :caller=
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Krb5Util::DEBUG }
      const_attr_reader  :DEBUG
    }
    
    typesig { [::Java::Int, Krb5NameElement, Krb5CredElement, ::Java::Int] }
    # Constructor for Krb5Context to be called on the context initiator's
    # side.
    def initialize(caller, peer_name, my_cred, lifetime)
      @state = STATE_NEW
      @cred_deleg_state = false
      @mutual_auth_state = true
      @replay_det_state = true
      @sequence_det_state = true
      @conf_state = true
      @integ_state = true
      @my_seq_number = 0
      @peer_seq_number = 0
      @peer_token_tracker = nil
      @cipher_helper = nil
      @my_seq_number_lock = Object.new
      @peer_seq_number_lock = Object.new
      @key = nil
      @my_name = nil
      @peer_name = nil
      @lifetime = 0
      @initiator = false
      @channel_binding = nil
      @my_cred = nil
      @delegated_cred = nil
      @des_cipher = nil
      @service_creds = nil
      @ap_req = nil
      @caller = 0
      if ((peer_name).nil?)
        raise IllegalArgumentException.new("Cannot have null peer name")
      end
      @caller = caller
      @peer_name = peer_name
      @my_cred = my_cred
      @lifetime = lifetime
      @initiator = true
    end
    
    typesig { [::Java::Int, Krb5CredElement] }
    # Constructor for Krb5Context to be called on the context acceptor's
    # side.
    def initialize(caller, my_cred)
      @state = STATE_NEW
      @cred_deleg_state = false
      @mutual_auth_state = true
      @replay_det_state = true
      @sequence_det_state = true
      @conf_state = true
      @integ_state = true
      @my_seq_number = 0
      @peer_seq_number = 0
      @peer_token_tracker = nil
      @cipher_helper = nil
      @my_seq_number_lock = Object.new
      @peer_seq_number_lock = Object.new
      @key = nil
      @my_name = nil
      @peer_name = nil
      @lifetime = 0
      @initiator = false
      @channel_binding = nil
      @my_cred = nil
      @delegated_cred = nil
      @des_cipher = nil
      @service_creds = nil
      @ap_req = nil
      @caller = 0
      @caller = caller
      @my_cred = my_cred
      @initiator = false
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Constructor for Krb5Context to import a previously exported context.
    def initialize(caller, inter_process_token)
      @state = STATE_NEW
      @cred_deleg_state = false
      @mutual_auth_state = true
      @replay_det_state = true
      @sequence_det_state = true
      @conf_state = true
      @integ_state = true
      @my_seq_number = 0
      @peer_seq_number = 0
      @peer_token_tracker = nil
      @cipher_helper = nil
      @my_seq_number_lock = Object.new
      @peer_seq_number_lock = Object.new
      @key = nil
      @my_name = nil
      @peer_name = nil
      @lifetime = 0
      @initiator = false
      @channel_binding = nil
      @my_cred = nil
      @delegated_cred = nil
      @des_cipher = nil
      @service_creds = nil
      @ap_req = nil
      @caller = 0
      raise GSSException.new(GSSException::UNAVAILABLE, -1, "GSS Import Context not available")
    end
    
    typesig { [] }
    # Method to determine if the context can be exported and then
    # re-imported.
    def is_transferable
      return false
    end
    
    typesig { [] }
    # The lifetime remaining for this context.
    def get_lifetime
      # XXX Return service ticket lifetime
      return GSSContext::INDEFINITE_LIFETIME
    end
    
    typesig { [::Java::Int] }
    # Methods that may be invoked by the GSS framework in response
    # to an application request for setting/getting these
    # properties.
    # 
    # These can only be called on the initiator side.
    # 
    # Notice that an application can only request these
    # properties. The mechanism may or may not support them. The
    # application must make getXXX calls after context establishment
    # to see if the mechanism implementations on both sides support
    # these features. requestAnonymity is an exception where the
    # application will want to call getAnonymityState prior to sending any
    # GSS token during context establishment.
    # 
    # Also note that the requests can only be placed before context
    # establishment starts. i.e. when state is STATE_NEW
    # 
    # 
    # Requests the desired lifetime. Can only be used on the context
    # initiator's side.
    def request_lifetime(lifetime)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @lifetime = lifetime
      end
    end
    
    typesig { [::Java::Boolean] }
    # Requests that confidentiality be available.
    def request_conf(value)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @conf_state = value
      end
    end
    
    typesig { [] }
    # Is confidentiality available?
    def get_conf_state
      return @conf_state
    end
    
    typesig { [::Java::Boolean] }
    # Requests that integrity be available.
    def request_integ(value)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @integ_state = value
      end
    end
    
    typesig { [] }
    # Is integrity available?
    def get_integ_state
      return @integ_state
    end
    
    typesig { [::Java::Boolean] }
    # Requests that credential delegation be done during context
    # establishment.
    def request_cred_deleg(value)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @cred_deleg_state = value
      end
    end
    
    typesig { [] }
    # Is credential delegation enabled?
    def get_cred_deleg_state
      return @cred_deleg_state
    end
    
    typesig { [::Java::Boolean] }
    # Requests that mutual authentication be done during context
    # establishment. Since this is fromm the client's perspective, it
    # essentially requests that the server be authenticated.
    def request_mutual_auth(value)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @mutual_auth_state = value
      end
    end
    
    typesig { [] }
    # Is mutual authentication enabled? Since this is from the client's
    # perspective, it essentially meas that the server is being
    # authenticated.
    def get_mutual_auth_state
      return @mutual_auth_state
    end
    
    typesig { [::Java::Boolean] }
    # Requests that replay detection be done on the GSS wrap and MIC
    # tokens.
    def request_replay_det(value)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @replay_det_state = value
      end
    end
    
    typesig { [] }
    # Is replay detection enabled on the GSS wrap and MIC tokens?
    # We enable replay detection if sequence checking is enabled.
    def get_replay_det_state
      return @replay_det_state || @sequence_det_state
    end
    
    typesig { [::Java::Boolean] }
    # Requests that sequence checking be done on the GSS wrap and MIC
    # tokens.
    def request_sequence_det(value)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @sequence_det_state = value
      end
    end
    
    typesig { [] }
    # Is sequence checking enabled on the GSS Wrap and MIC tokens?
    # We enable sequence checking if replay detection is enabled.
    def get_sequence_det_state
      return @sequence_det_state || @replay_det_state
    end
    
    typesig { [::Java::Boolean] }
    # Anonymity is a little different in that after an application
    # requests anonymity it will want to know whether the mechanism
    # can support it or not, prior to sending any tokens across for
    # context establishment. Since this is from the initiator's
    # perspective, it essentially requests that the initiator be
    # anonymous.
    def request_anonymity(value)
      # Ignore silently. Application will check back with
      # getAnonymityState.
    end
    
    typesig { [] }
    # RFC 2853 actually calls for this to be called after context
    # establishment to get the right answer, but that is
    # incorrect. The application may not want to send over any
    # tokens if anonymity is not available.
    def get_anonymity_state
      return false
    end
    
    typesig { [EncryptionKey] }
    # Package private methods invoked by other Krb5 plugin classes.
    # 
    # 
    # Get the context specific DESCipher instance, invoked in
    # MessageToken.init()
    def get_cipher_helper(ckey)
      cipher_key = nil
      if ((@cipher_helper).nil?)
        cipher_key = ((get_key).nil?) ? ckey : get_key
        @cipher_helper = CipherHelper.new(cipher_key)
      end
      return @cipher_helper
    end
    
    typesig { [] }
    def increment_my_sequence_number
      ret_val = 0
      synchronized((@my_seq_number_lock)) do
        ret_val = @my_seq_number
        @my_seq_number = ret_val + 1
      end
      return ret_val
    end
    
    typesig { [::Java::Int] }
    def reset_my_sequence_number(seq_number)
      if (DEBUG)
        System.out.println("Krb5Context setting mySeqNumber to: " + RJava.cast_to_string(seq_number))
      end
      synchronized((@my_seq_number_lock)) do
        @my_seq_number = seq_number
      end
    end
    
    typesig { [::Java::Int] }
    def reset_peer_sequence_number(seq_number)
      if (DEBUG)
        System.out.println("Krb5Context setting peerSeqNumber to: " + RJava.cast_to_string(seq_number))
      end
      synchronized((@peer_seq_number_lock)) do
        @peer_seq_number = seq_number
        @peer_token_tracker = TokenTracker.new(@peer_seq_number)
      end
    end
    
    typesig { [EncryptionKey] }
    def set_key(key)
      @key = key
      # %%% to do: should clear old cipherHelper first
      @cipher_helper = CipherHelper.new(key) # Need to use new key
    end
    
    typesig { [] }
    def get_key
      return @key
    end
    
    typesig { [Krb5CredElement] }
    # Called on the acceptor side to store the delegated credentials
    # received in the AcceptSecContextToken.
    def set_deleg_cred(delegated_cred)
      @delegated_cred = delegated_cred
    end
    
    typesig { [::Java::Boolean] }
    # While the application can only request the following features,
    # other classes in the package can call the actual set methods
    # for them. They are called as context establishment tokens are
    # received on an acceptor side and the context feature list that
    # the initiator wants becomes known.
    # 
    # 
    # This method is also called by InitialToken.OverloadedChecksum if the
    # TGT is not forwardable and the user requested delegation.
    def set_cred_deleg_state(state)
      @cred_deleg_state = state
    end
    
    typesig { [::Java::Boolean] }
    def set_mutual_auth_state(state)
      @mutual_auth_state = state
    end
    
    typesig { [::Java::Boolean] }
    def set_replay_det_state(state)
      @replay_det_state = state
    end
    
    typesig { [::Java::Boolean] }
    def set_sequence_det_state(state)
      @sequence_det_state = state
    end
    
    typesig { [::Java::Boolean] }
    def set_conf_state(state)
      @conf_state = state
    end
    
    typesig { [::Java::Boolean] }
    def set_integ_state(state)
      @integ_state = state
    end
    
    typesig { [ChannelBinding] }
    # Sets the channel bindings to be used during context
    # establishment.
    def set_channel_binding(channel_binding)
      @channel_binding = channel_binding
    end
    
    typesig { [] }
    def get_channel_binding
      return @channel_binding
    end
    
    typesig { [] }
    # Returns the mechanism oid.
    # 
    # @return the Oid of this context
    def get_mech
      return (Krb5MechFactory::GSS_KRB5_MECH_OID)
    end
    
    typesig { [] }
    # Returns the context initiator name.
    # 
    # @return initiator name
    # @exception GSSException
    def get_src_name
      return (is_initiator ? @my_name : @peer_name)
    end
    
    typesig { [] }
    # Returns the context acceptor.
    # 
    # @return context acceptor(target) name
    # @exception GSSException
    def get_targ_name
      return (!is_initiator ? @my_name : @peer_name)
    end
    
    typesig { [] }
    # Returns the delegated credential for the context. This
    # is an optional feature of contexts which not all
    # mechanisms will support. A context can be requested to
    # support credential delegation by using the <b>CRED_DELEG</b>.
    # This is only valid on the acceptor side of the context.
    # @return GSSCredentialSpi object for the delegated credential
    # @exception GSSException
    # @see GSSContext#getDelegCredState
    def get_deleg_cred
      if (!(@state).equal?(STATE_IN_PROCESS) && !(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT)
      end
      if ((@delegated_cred).nil?)
        raise GSSException.new(GSSException::NO_CRED)
      end
      return @delegated_cred
    end
    
    typesig { [] }
    # Tests if this is the initiator side of the context.
    # 
    # @return boolean indicating if this is initiator (true)
    # or target (false)
    def is_initiator
      return @initiator
    end
    
    typesig { [] }
    # Tests if the context can be used for per-message service.
    # Context may allow the calls to the per-message service
    # functions before being fully established.
    # 
    # @return boolean indicating if per-message methods can
    # be called.
    def is_prot_ready
      return ((@state).equal?(STATE_DONE))
    end
    
    typesig { [InputStream, ::Java::Int] }
    # Initiator context establishment call. This method may be
    # required to be called several times. A CONTINUE_NEEDED return
    # call indicates that more calls are needed after the next token
    # is received from the peer.
    # 
    # @param is contains the token received from the peer. On the
    # first call it will be ignored.
    # @return any token required to be sent to the peer
    # It is responsibility of the caller
    # to send the token to its peer for processing.
    # @exception GSSException
    def init_sec_context(is, mech_token_size)
      ret_val = nil
      token = nil
      error_code = GSSException::FAILURE
      if (DEBUG)
        System.out.println("Entered Krb5Context.initSecContext with " + "state=" + RJava.cast_to_string(print_state(@state)))
      end
      if (!is_initiator)
        raise GSSException.new(GSSException::FAILURE, -1, "initSecContext on an acceptor " + "GSSContext")
      end
      begin
        if ((@state).equal?(STATE_NEW))
          @state = STATE_IN_PROCESS
          error_code = GSSException::NO_CRED
          if ((@my_cred).nil?)
            @my_cred = Krb5InitCredential.get_instance(@caller, @my_name, GSSCredential::DEFAULT_LIFETIME)
          else
            if (!@my_cred.is_initiator_credential)
              raise GSSException.new(error_code, -1, "No TGT available")
            end
          end
          @my_name = @my_cred.get_name
          tgt = (@my_cred).get_krb5credentials
          check_permission(@peer_name.get_krb5principal_name.get_name, "initiate")
          # If useSubjectCredsonly is true then
          # we check whether we already have the ticket
          # for this service in the Subject and reuse it
          acc = AccessController.get_context
          if (GSSUtil.use_subject_creds_only(@caller))
            kerb_ticket = nil
            begin
              kerb_ticket = AccessController.do_privileged(# get service ticket from caller's subject
              Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members Krb5Context
                include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  # XXX to be cleaned
                  # highly consider just calling:
                  # Subject.getSubject
                  # SubjectComber.find
                  # instead of Krb5Util.getTicket
                  # since it's useSubjectCredsOnly here,
                  # don't worry about the null
                  return Krb5Util.get_ticket(GSSUtil::CALLER_UNKNOWN, self.attr_my_name.get_krb5principal_name.get_name, self.attr_peer_name.get_krb5principal_name.get_name, acc)
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            rescue PrivilegedActionException => e
              if (DEBUG)
                System.out.println("Attempt to obtain service" + " ticket from the subject failed!")
              end
            end
            if (!(kerb_ticket).nil?)
              if (DEBUG)
                System.out.println("Found service ticket in " + "the subject" + RJava.cast_to_string(kerb_ticket))
              end
              # convert Ticket to serviceCreds
              # XXX Should merge these two object types
              # avoid converting back and forth
              @service_creds = Krb5Util.ticket_to_creds(kerb_ticket)
            end
          end
          if ((@service_creds).nil?)
            # either we did not find the serviceCreds in the
            # Subject or useSubjectCreds is false
            if (DEBUG)
              System.out.println("Service ticket not found in " + "the subject")
            end
            # Get Service ticket using the Kerberos protocols
            @service_creds = Credentials.acquire_service_creds(@peer_name.get_krb5principal_name.get_name, tgt)
            if (GSSUtil.use_subject_creds_only(@caller))
              subject = AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
                extend LocalClass
                include_class_members Krb5Context
                include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
                
                typesig { [] }
                define_method :run do
                  return (Subject.get_subject(acc))
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
              if (!(subject).nil? && !subject.is_read_only)
                # Store the service credentials as
                # javax.security.auth.kerberos.KerberosTicket in
                # the Subject. We could wait till the context is
                # succesfully established; however it is easier
                # to do here and there is no harm indoing it here.
                kt = Krb5Util.creds_to_ticket(@service_creds)
                AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
                  extend LocalClass
                  include_class_members Krb5Context
                  include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    subject.get_private_credentials.add(kt)
                    return nil
                  end
                  
                  typesig { [Vararg.new(Object)] }
                  define_method :initialize do |*args|
                    super(*args)
                  end
                  
                  private
                  alias_method :initialize_anonymous, :initialize
                end.new_local(self))
              else
                # log it for debugging purpose
                if (DEBUG)
                  System.out.println("Subject is " + "readOnly;Kerberos Service " + "ticket not stored")
                end
              end
            end
          end
          error_code = GSSException::FAILURE
          token = InitSecContextToken.new(self, tgt, @service_creds)
          @ap_req = (token).get_krb_ap_req
          ret_val = token.encode
          @my_cred = nil
          if (!get_mutual_auth_state)
            @state = STATE_DONE
          end
          if (DEBUG)
            System.out.println("Created InitSecContextToken:\n" + RJava.cast_to_string(HexDumpEncoder.new.encode_buffer(ret_val)))
          end
        else
          if ((@state).equal?(STATE_IN_PROCESS))
            # No need to write anything;
            # just validate the incoming token
            AcceptSecContextToken.new(self, @service_creds, @ap_req, is)
            @service_creds = nil
            @ap_req = nil
            @state = STATE_DONE
          else
            # XXX Use logging API?
            if (DEBUG)
              System.out.println(@state)
            end
          end
        end
      rescue KrbException => e
        if (DEBUG)
          e.print_stack_trace
        end
        gss_exception = GSSException.new(error_code, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      rescue IOException => e
        gss_exception = GSSException.new(error_code, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      return ret_val
    end
    
    typesig { [] }
    def is_established
      return ((@state).equal?(STATE_DONE))
    end
    
    typesig { [InputStream, ::Java::Int] }
    # Acceptor's context establishment call. This method may be
    # required to be called several times. A CONTINUE_NEEDED return
    # call indicates that more calls are needed after the next token
    # is received from the peer.
    # 
    # @param is contains the token received from the peer.
    # @return any token required to be sent to the peer
    # It is responsibility of the caller
    # to send the token to its peer for processing.
    # @exception GSSException
    def accept_sec_context(is, mech_token_size)
      ret_val = nil
      if (DEBUG)
        System.out.println("Entered Krb5Context.acceptSecContext with " + "state=" + RJava.cast_to_string(print_state(@state)))
      end
      if (is_initiator)
        raise GSSException.new(GSSException::FAILURE, -1, "acceptSecContext on an initiator " + "GSSContext")
      end
      begin
        if ((@state).equal?(STATE_NEW))
          @state = STATE_IN_PROCESS
          if ((@my_cred).nil?)
            @my_cred = Krb5AcceptCredential.get_instance(@caller, @my_name)
          else
            if (!@my_cred.is_acceptor_credential)
              raise GSSException.new(GSSException::NO_CRED, -1, "No Secret Key available")
            end
          end
          @my_name = @my_cred.get_name
          check_permission(@my_name.get_krb5principal_name.get_name, "accept")
          secret_keys = (@my_cred).get_krb5encryption_keys
          token = InitSecContextToken.new(self, secret_keys, is)
          client_name = token.get_krb_ap_req.get_client
          @peer_name = Krb5NameElement.get_instance(client_name)
          if (get_mutual_auth_state)
            ret_val = AcceptSecContextToken.new(self, token.get_krb_ap_req).encode
          end
          @my_cred = nil
          @state = STATE_DONE
        else
          # XXX Use logging API?
          if (DEBUG)
            System.out.println(@state)
          end
        end
      rescue KrbException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      rescue IOException => e
        if (DEBUG)
          e.print_stack_trace
        end
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      return ret_val
    end
    
    typesig { [::Java::Int, ::Java::Boolean, ::Java::Int] }
    # Queries the context for largest data size to accomodate
    # the specified protection and be <= maxTokSize.
    # 
    # @param qop the quality of protection that the context will be
    # asked to provide.
    # @param confReq a flag indicating whether confidentiality will be
    # requested or not
    # @param outputSize the maximum size of the output token
    # @return the maximum size for the input message that can be
    # provided to the wrap() method in order to guarantee that these
    # requirements are met.
    # @throws GSSException
    def get_wrap_size_limit(qop, conf_req, max_tok_size)
      ret_val = 0
      if ((@cipher_helper.get_proto).equal?(0))
        ret_val = WrapToken.get_size_limit(qop, conf_req, max_tok_size, get_cipher_helper(nil))
      else
        if ((@cipher_helper.get_proto).equal?(1))
          ret_val = WrapToken_v2.get_size_limit(qop, conf_req, max_tok_size, get_cipher_helper(nil))
        end
      end
      return ret_val
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    # Per-message calls depend on the sequence number. The sequence number
    # synchronization is at a finer granularity because wrap and getMIC
    # care about the local sequence number (mySeqNumber) where are unwrap
    # and verifyMIC care about the remote sequence number (peerSeqNumber).
    def wrap(in_buf, offset, len, msg_prop)
      if (DEBUG)
        System.out.println("Krb5Context.wrap: data=[" + RJava.cast_to_string(get_hex_bytes(in_buf, offset, len)) + "]")
      end
      if (!(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Wrap called in invalid state!")
      end
      enc_token = nil
      begin
        if ((@cipher_helper.get_proto).equal?(0))
          token = WrapToken.new(self, msg_prop, in_buf, offset, len)
          enc_token = token.encode
        else
          if ((@cipher_helper.get_proto).equal?(1))
            token = WrapToken_v2.new(self, msg_prop, in_buf, offset, len)
            enc_token = token.encode
          end
        end
        if (DEBUG)
          System.out.println("Krb5Context.wrap: token=[" + RJava.cast_to_string(get_hex_bytes(enc_token, 0, enc_token.attr_length)) + "]")
        end
        return enc_token
      rescue IOException => e
        enc_token = nil
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, MessageProp] }
    def wrap(in_buf, in_offset, len, out_buf, out_offset, msg_prop)
      if (!(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Wrap called in invalid state!")
      end
      ret_val = 0
      begin
        if ((@cipher_helper.get_proto).equal?(0))
          token = WrapToken.new(self, msg_prop, in_buf, in_offset, len)
          ret_val = token.encode(out_buf, out_offset)
        else
          if ((@cipher_helper.get_proto).equal?(1))
            token = WrapToken_v2.new(self, msg_prop, in_buf, in_offset, len)
            ret_val = token.encode(out_buf, out_offset)
          end
        end
        if (DEBUG)
          System.out.println("Krb5Context.wrap: token=[" + RJava.cast_to_string(get_hex_bytes(out_buf, out_offset, ret_val)) + "]")
        end
        return ret_val
      rescue IOException => e
        ret_val = 0
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, OutputStream, MessageProp] }
    def wrap(in_buf, offset, len, os, msg_prop)
      if (!(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Wrap called in invalid state!")
      end
      enc_token = nil
      begin
        if ((@cipher_helper.get_proto).equal?(0))
          token = WrapToken.new(self, msg_prop, in_buf, offset, len)
          token.encode(os)
          if (DEBUG)
            enc_token = token.encode
          end
        else
          if ((@cipher_helper.get_proto).equal?(1))
            token = WrapToken_v2.new(self, msg_prop, in_buf, offset, len)
            token.encode(os)
            if (DEBUG)
              enc_token = token.encode
            end
          end
        end
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      if (DEBUG)
        System.out.println("Krb5Context.wrap: token=[" + RJava.cast_to_string(get_hex_bytes(enc_token, 0, enc_token.attr_length)) + "]")
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def wrap(is, os, msg_prop)
      data = nil
      begin
        data = Array.typed(::Java::Byte).new(is.available) { 0 }
        is.read(data)
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      wrap(data, 0, data.attr_length, os, msg_prop)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def unwrap(in_buf, offset, len, msg_prop)
      if (DEBUG)
        System.out.println("Krb5Context.unwrap: token=[" + RJava.cast_to_string(get_hex_bytes(in_buf, offset, len)) + "]")
      end
      if (!(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT, -1, " Unwrap called in invalid state!")
      end
      data = nil
      if ((@cipher_helper.get_proto).equal?(0))
        token = WrapToken.new(self, in_buf, offset, len, msg_prop)
        data = token.get_data
        set_sequencing_and_replay_props(token, msg_prop)
      else
        if ((@cipher_helper.get_proto).equal?(1))
          token = WrapToken_v2.new(self, in_buf, offset, len, msg_prop)
          data = token.get_data
          set_sequencing_and_replay_props(token, msg_prop)
        end
      end
      if (DEBUG)
        System.out.println("Krb5Context.unwrap: data=[" + RJava.cast_to_string(get_hex_bytes(data, 0, data.attr_length)) + "]")
      end
      return data
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, MessageProp] }
    def unwrap(in_buf, in_offset, len, out_buf, out_offset, msg_prop)
      if (!(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Unwrap called in invalid state!")
      end
      if ((@cipher_helper.get_proto).equal?(0))
        token = WrapToken.new(self, in_buf, in_offset, len, msg_prop)
        len = token.get_data(out_buf, out_offset)
        set_sequencing_and_replay_props(token, msg_prop)
      else
        if ((@cipher_helper.get_proto).equal?(1))
          token = WrapToken_v2.new(self, in_buf, in_offset, len, msg_prop)
          len = token.get_data(out_buf, out_offset)
          set_sequencing_and_replay_props(token, msg_prop)
        end
      end
      return len
    end
    
    typesig { [InputStream, Array.typed(::Java::Byte), ::Java::Int, MessageProp] }
    def unwrap(is, out_buf, out_offset, msg_prop)
      if (!(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Unwrap called in invalid state!")
      end
      len = 0
      if ((@cipher_helper.get_proto).equal?(0))
        token = WrapToken.new(self, is, msg_prop)
        len = token.get_data(out_buf, out_offset)
        set_sequencing_and_replay_props(token, msg_prop)
      else
        if ((@cipher_helper.get_proto).equal?(1))
          token = WrapToken_v2.new(self, is, msg_prop)
          len = token.get_data(out_buf, out_offset)
          set_sequencing_and_replay_props(token, msg_prop)
        end
      end
      return len
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def unwrap(is, os, msg_prop)
      if (!(@state).equal?(STATE_DONE))
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Unwrap called in invalid state!")
      end
      data = nil
      if ((@cipher_helper.get_proto).equal?(0))
        token = WrapToken.new(self, is, msg_prop)
        data = token.get_data
        set_sequencing_and_replay_props(token, msg_prop)
      else
        if ((@cipher_helper.get_proto).equal?(1))
          token = WrapToken_v2.new(self, is, msg_prop)
          data = token.get_data
          set_sequencing_and_replay_props(token, msg_prop)
        end
      end
      begin
        os.write(data)
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def get_mic(in_msg, offset, len, msg_prop)
      mic_token = nil
      begin
        if ((@cipher_helper.get_proto).equal?(0))
          token = MicToken.new(self, msg_prop, in_msg, offset, len)
          mic_token = token.encode
        else
          if ((@cipher_helper.get_proto).equal?(1))
            token = MicToken_v2.new(self, msg_prop, in_msg, offset, len)
            mic_token = token.encode
          end
        end
        return mic_token
      rescue IOException => e
        mic_token = nil
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, MessageProp] }
    def get_mic(in_msg, offset, len, out_buf, out_offset, msg_prop)
      ret_val = 0
      begin
        if ((@cipher_helper.get_proto).equal?(0))
          token = MicToken.new(self, msg_prop, in_msg, offset, len)
          ret_val = token.encode(out_buf, out_offset)
        else
          if ((@cipher_helper.get_proto).equal?(1))
            token = MicToken_v2.new(self, msg_prop, in_msg, offset, len)
            ret_val = token.encode(out_buf, out_offset)
          end
        end
        return ret_val
      rescue IOException => e
        ret_val = 0
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, OutputStream, MessageProp] }
    # Checksum calculation requires a byte[]. Hence might as well pass
    # a byte[] into the MicToken constructor. However, writing the
    # token can be optimized for cases where the application passed in
    # an OutputStream.
    def get_mic(in_msg, offset, len, os, msg_prop)
      begin
        if ((@cipher_helper.get_proto).equal?(0))
          token = MicToken.new(self, msg_prop, in_msg, offset, len)
          token.encode(os)
        else
          if ((@cipher_helper.get_proto).equal?(1))
            token = MicToken_v2.new(self, msg_prop, in_msg, offset, len)
            token.encode(os)
          end
        end
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def get_mic(is, os, msg_prop)
      data = nil
      begin
        data = Array.typed(::Java::Byte).new(is.available) { 0 }
        is.read(data)
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      get_mic(data, 0, data.attr_length, os, msg_prop)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def verify_mic(in_tok, tok_offset, tok_len, in_msg, msg_offset, msg_len, msg_prop)
      if ((@cipher_helper.get_proto).equal?(0))
        token = MicToken.new(self, in_tok, tok_offset, tok_len, msg_prop)
        token.verify(in_msg, msg_offset, msg_len)
        set_sequencing_and_replay_props(token, msg_prop)
      else
        if ((@cipher_helper.get_proto).equal?(1))
          token = MicToken_v2.new(self, in_tok, tok_offset, tok_len, msg_prop)
          token.verify(in_msg, msg_offset, msg_len)
          set_sequencing_and_replay_props(token, msg_prop)
        end
      end
    end
    
    typesig { [InputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def verify_mic(is, in_msg, msg_offset, msg_len, msg_prop)
      if ((@cipher_helper.get_proto).equal?(0))
        token = MicToken.new(self, is, msg_prop)
        token.verify(in_msg, msg_offset, msg_len)
        set_sequencing_and_replay_props(token, msg_prop)
      else
        if ((@cipher_helper.get_proto).equal?(1))
          token = MicToken_v2.new(self, is, msg_prop)
          token.verify(in_msg, msg_offset, msg_len)
          set_sequencing_and_replay_props(token, msg_prop)
        end
      end
    end
    
    typesig { [InputStream, InputStream, MessageProp] }
    def verify_mic(is, msg_str, m_prop)
      msg = nil
      begin
        msg = Array.typed(::Java::Byte).new(msg_str.available) { 0 }
        msg_str.read(msg)
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      verify_mic(is, msg, 0, msg.attr_length, m_prop)
    end
    
    typesig { [] }
    # Produces a token representing this context. After this call
    # the context will no longer be usable until an import is
    # performed on the returned token.
    # 
    # @param os the output token will be written to this stream
    # @exception GSSException
    def export
      raise GSSException.new(GSSException::UNAVAILABLE, -1, "GSS Export Context not available")
    end
    
    typesig { [] }
    # Releases context resources and terminates the
    # context between 2 peer.
    # 
    # @exception GSSException with major codes NO_CONTEXT, FAILURE.
    def dispose
      @state = STATE_DELETED
      @delegated_cred = nil
    end
    
    typesig { [] }
    def get_provider
      return Krb5MechFactory::PROVIDER
    end
    
    typesig { [MessageToken, MessageProp] }
    # Sets replay and sequencing information for a message token received
    # form the peer.
    def set_sequencing_and_replay_props(token, prop)
      if (@replay_det_state || @sequence_det_state)
        seq_num = token.get_sequence_number
        @peer_token_tracker.get_props(seq_num, prop)
      end
    end
    
    typesig { [MessageToken_v2, MessageProp] }
    # Sets replay and sequencing information for a message token received
    # form the peer.
    def set_sequencing_and_replay_props(token, prop)
      if (@replay_det_state || @sequence_det_state)
        seq_num = token.get_sequence_number
        @peer_token_tracker.get_props(seq_num, prop)
      end
    end
    
    typesig { [String, String] }
    def check_permission(principal, action)
      sm = System.get_security_manager
      if (!(sm).nil?)
        perm = ServicePermission.new(principal, action)
        sm.check_permission(perm)
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def get_hex_bytes(bytes, pos, len)
        sb = StringBuffer.new
        i = 0
        while i < len
          b1 = (bytes[i] >> 4) & 0xf
          b2 = bytes[i] & 0xf
          sb.append(JavaInteger.to_hex_string(b1))
          sb.append(JavaInteger.to_hex_string(b2))
          sb.append(Character.new(?\s.ord))
          i += 1
        end
        return sb.to_s
      end
      
      typesig { [::Java::Int] }
      def print_state(state)
        case (state)
        when STATE_NEW
          return ("STATE_NEW")
        when STATE_IN_PROCESS
          return ("STATE_IN_PROCESS")
        when STATE_DONE
          return ("STATE_DONE")
        when STATE_DELETED
          return ("STATE_DELETED")
        else
          return ("Unknown state " + RJava.cast_to_string(state))
        end
      end
    }
    
    typesig { [] }
    def get_caller
      # Currently used by InitialToken only
      return @caller
    end
    
    private
    alias_method :initialize__krb5context, :initialize
  end
  
end
