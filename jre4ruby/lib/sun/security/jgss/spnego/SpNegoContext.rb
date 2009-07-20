require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Spnego
  module SpNegoContextImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Spnego
      include ::Java::Io
      include_const ::Java::Security, :Provider
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss
      include ::Sun::Security::Jgss::Spi
      include ::Sun::Security::Util
    }
  end
  
  # Implements the mechanism specific context class for SPNEGO
  # GSS-API mechanism
  # 
  # @author Seema Malkani
  # @since 1.6
  class SpNegoContext 
    include_class_members SpNegoContextImports
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
    
    class_module.module_eval {
      const_set_lazy(:CHECKSUM_DELEG_FLAG) { 1 }
      const_attr_reader  :CHECKSUM_DELEG_FLAG
      
      const_set_lazy(:CHECKSUM_MUTUAL_FLAG) { 2 }
      const_attr_reader  :CHECKSUM_MUTUAL_FLAG
      
      const_set_lazy(:CHECKSUM_REPLAY_FLAG) { 4 }
      const_attr_reader  :CHECKSUM_REPLAY_FLAG
      
      const_set_lazy(:CHECKSUM_SEQUENCE_FLAG) { 8 }
      const_attr_reader  :CHECKSUM_SEQUENCE_FLAG
      
      const_set_lazy(:CHECKSUM_CONF_FLAG) { 16 }
      const_attr_reader  :CHECKSUM_CONF_FLAG
      
      const_set_lazy(:CHECKSUM_INTEG_FLAG) { 32 }
      const_attr_reader  :CHECKSUM_INTEG_FLAG
    }
    
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
    
    attr_accessor :peer_name
    alias_method :attr_peer_name, :peer_name
    undef_method :peer_name
    alias_method :attr_peer_name=, :peer_name=
    undef_method :peer_name=
    
    attr_accessor :my_name
    alias_method :attr_my_name, :my_name
    undef_method :my_name
    alias_method :attr_my_name=, :my_name=
    undef_method :my_name=
    
    attr_accessor :my_cred
    alias_method :attr_my_cred, :my_cred
    undef_method :my_cred
    alias_method :attr_my_cred=, :my_cred=
    undef_method :my_cred=
    
    attr_accessor :mech_context
    alias_method :attr_mech_context, :mech_context
    undef_method :mech_context
    alias_method :attr_mech_context=, :mech_context=
    undef_method :mech_context=
    
    attr_accessor :der_mech_types
    alias_method :attr_der_mech_types, :der_mech_types
    undef_method :der_mech_types
    alias_method :attr_der_mech_types=, :der_mech_types=
    undef_method :der_mech_types=
    
    attr_accessor :lifetime
    alias_method :attr_lifetime, :lifetime
    undef_method :lifetime
    alias_method :attr_lifetime=, :lifetime=
    undef_method :lifetime=
    
    attr_accessor :channel_binding
    alias_method :attr_channel_binding, :channel_binding
    undef_method :channel_binding
    alias_method :attr_channel_binding=, :channel_binding=
    undef_method :channel_binding=
    
    attr_accessor :initiator
    alias_method :attr_initiator, :initiator
    undef_method :initiator
    alias_method :attr_initiator=, :initiator=
    undef_method :initiator=
    
    # the underlying negotiated mechanism
    attr_accessor :internal_mech
    alias_method :attr_internal_mech, :internal_mech
    undef_method :internal_mech
    alias_method :attr_internal_mech=, :internal_mech=
    undef_method :internal_mech=
    
    # the SpNegoMechFactory that creates this context
    attr_accessor :factory
    alias_method :attr_factory, :factory
    undef_method :factory
    alias_method :attr_factory=, :factory=
    undef_method :factory=
    
    class_module.module_eval {
      # debug property
      const_set_lazy(:DEBUG) { Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.security.spnego.debug")).boolean_value }
      const_attr_reader  :DEBUG
    }
    
    typesig { [SpNegoMechFactory, GSSNameSpi, GSSCredentialSpi, ::Java::Int] }
    # Constructor for SpNegoContext to be called on the context initiator's
    # side.
    def initialize(factory, peer_name, my_cred, lifetime)
      @state = STATE_NEW
      @cred_deleg_state = false
      @mutual_auth_state = true
      @replay_det_state = true
      @sequence_det_state = true
      @conf_state = true
      @integ_state = true
      @peer_name = nil
      @my_name = nil
      @my_cred = nil
      @mech_context = nil
      @der_mech_types = nil
      @lifetime = 0
      @channel_binding = nil
      @initiator = false
      @internal_mech = nil
      @factory = nil
      if ((peer_name).nil?)
        raise IllegalArgumentException.new("Cannot have null peer name")
      end
      if ((!(my_cred).nil?) && !(my_cred.is_a?(SpNegoCredElement)))
        raise IllegalArgumentException.new("Wrong cred element type")
      end
      @peer_name = peer_name
      @my_cred = my_cred
      @lifetime = lifetime
      @initiator = true
      @factory = factory
    end
    
    typesig { [SpNegoMechFactory, GSSCredentialSpi] }
    # Constructor for SpNegoContext to be called on the context acceptor's
    # side.
    def initialize(factory, my_cred)
      @state = STATE_NEW
      @cred_deleg_state = false
      @mutual_auth_state = true
      @replay_det_state = true
      @sequence_det_state = true
      @conf_state = true
      @integ_state = true
      @peer_name = nil
      @my_name = nil
      @my_cred = nil
      @mech_context = nil
      @der_mech_types = nil
      @lifetime = 0
      @channel_binding = nil
      @initiator = false
      @internal_mech = nil
      @factory = nil
      if ((!(my_cred).nil?) && !(my_cred.is_a?(SpNegoCredElement)))
        raise IllegalArgumentException.new("Wrong cred element type")
      end
      @my_cred = my_cred
      @initiator = false
      @factory = factory
    end
    
    typesig { [SpNegoMechFactory, Array.typed(::Java::Byte)] }
    # Constructor for SpNegoContext to import a previously exported context.
    def initialize(factory, inter_process_token)
      @state = STATE_NEW
      @cred_deleg_state = false
      @mutual_auth_state = true
      @replay_det_state = true
      @sequence_det_state = true
      @conf_state = true
      @integ_state = true
      @peer_name = nil
      @my_name = nil
      @my_cred = nil
      @mech_context = nil
      @der_mech_types = nil
      @lifetime = 0
      @channel_binding = nil
      @initiator = false
      @internal_mech = nil
      @factory = nil
      raise GSSException.new(GSSException::UNAVAILABLE, -1, "GSS Import Context not available")
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
      if (!(@mech_context).nil? && ((@state).equal?(STATE_IN_PROCESS) || (@state).equal?(STATE_DONE)))
        return @mech_context.get_cred_deleg_state
      else
        return @cred_deleg_state
      end
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
    
    typesig { [] }
    # Returns the mechanism oid.
    # 
    # @return the Oid of this context
    def get_mech
      if (is_established)
        return get_negotiated_mech
      end
      return (SpNegoMechFactory::GSS_SPNEGO_MECH_OID)
    end
    
    typesig { [] }
    def get_negotiated_mech
      return (@internal_mech)
    end
    
    typesig { [] }
    def get_provider
      return SpNegoMechFactory::PROVIDER
    end
    
    typesig { [] }
    def dispose
      @mech_context = nil
      @state = STATE_DELETED
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
    # It is responsibility of the caller to send the token
    # to its peer for processing.
    # @exception GSSException
    def init_sec_context(is, mech_token_size)
      ret_val = nil
      init_token = nil
      mech_token = nil
      error_code = GSSException::FAILURE
      if (DEBUG)
        System.out.println("Entered SpNego.initSecContext with " + "state=" + (print_state(@state)).to_s)
      end
      if (!is_initiator)
        raise GSSException.new(GSSException::FAILURE, -1, "initSecContext on an acceptor GSSContext")
      end
      begin
        if ((@state).equal?(STATE_NEW))
          @state = STATE_IN_PROCESS
          error_code = GSSException::NO_CRED
          # determine available mech set
          mech_list = get_available_mechs
          @der_mech_types = get_encoded_mechs(mech_list)
          # pull out first mechanism
          @internal_mech = mech_list[0]
          # get the token for first mechanism
          mech_token = _gss_init_sec_context(nil)
          error_code = GSSException::DEFECTIVE_TOKEN
          mic_token = nil
          if (!GSSUtil.use_msinterop)
            # calculate MIC only in normal mode
            mic_token = generate_mech_list_mic(@der_mech_types)
          end
          # generate SPNEGO token
          init_token = NegTokenInit.new(@der_mech_types, get_context_flags, mech_token, mic_token)
          if (DEBUG)
            System.out.println("SpNegoContext.initSecContext: " + "sending token of type = " + (SpNegoToken.get_token_name(init_token.get_type)).to_s)
          end
          # get the encoded token
          ret_val = init_token.get_encoded
        else
          if ((@state).equal?(STATE_IN_PROCESS))
            error_code = GSSException::FAILURE
            if ((is).nil?)
              raise GSSException.new(error_code, -1, "No token received from peer!")
            end
            error_code = GSSException::DEFECTIVE_TOKEN
            server_token = Array.typed(::Java::Byte).new(is.available) { 0 }
            SpNegoToken.read_fully(is, server_token)
            if (DEBUG)
              System.out.println("SpNegoContext.initSecContext: " + "process received token = " + (SpNegoToken.get_hex_bytes(server_token)).to_s)
            end
            # read the SPNEGO token
            # token will be validated when parsing
            targ_token = NegTokenTarg.new(server_token)
            if (DEBUG)
              System.out.println("SpNegoContext.initSecContext: " + "received token of type = " + (SpNegoToken.get_token_name(targ_token.get_type)).to_s)
            end
            # pull out mechanism
            @internal_mech = targ_token.get_supported_mech
            if ((@internal_mech).nil?)
              # return wth failure
              raise GSSException.new(error_code, -1, "supported mechansim from server is null")
            end
            # get the negotiated result
            nego_result = nil
            result = targ_token.get_negotiated_result
            case (result)
            when 0
              nego_result = SpNegoToken::NegoResult::ACCEPT_COMPLETE
              @state = STATE_DONE
            when 1
              nego_result = SpNegoToken::NegoResult::ACCEPT_INCOMPLETE
              @state = STATE_IN_PROCESS
            when 2
              nego_result = SpNegoToken::NegoResult::REJECT
              @state = STATE_DELETED
            else
              @state = STATE_DONE
            end
            error_code = GSSException::BAD_MECH
            if ((nego_result).equal?(SpNegoToken::NegoResult::REJECT))
              raise GSSException.new(error_code, -1, @internal_mech.to_s)
            end
            error_code = GSSException::DEFECTIVE_TOKEN
            if (((nego_result).equal?(SpNegoToken::NegoResult::ACCEPT_COMPLETE)) || ((nego_result).equal?(SpNegoToken::NegoResult::ACCEPT_INCOMPLETE)))
              # pull out the mechanism token
              accept_token = targ_token.get_response_token
              if ((accept_token).nil?)
                # return wth failure
                raise GSSException.new(error_code, -1, "mechansim token from server is null")
              end
              mech_token = _gss_init_sec_context(accept_token)
              # verify MIC
              if (!GSSUtil.use_msinterop)
                mic_token = targ_token.get_mech_list_mic
                if (!verify_mech_list_mic(@der_mech_types, mic_token))
                  raise GSSException.new(error_code, -1, "verification of MIC on MechList Failed!")
                end
              end
              if (is_mech_context_established)
                @state = STATE_DONE
                ret_val = mech_token
                if (DEBUG)
                  System.out.println("SPNEGO Negotiated Mechanism = " + (@internal_mech).to_s + " " + (GSSUtil.get_mech_str(@internal_mech)).to_s)
                end
              else
                # generate SPNEGO token
                init_token = NegTokenInit.new(nil, nil, mech_token, nil)
                if (DEBUG)
                  System.out.println("SpNegoContext.initSecContext:" + " continue sending token of type = " + (SpNegoToken.get_token_name(init_token.get_type)).to_s)
                end
                # get the encoded token
                ret_val = init_token.get_encoded
              end
            end
          else
            # XXX Use logging API
            if (DEBUG)
              System.out.println(@state)
            end
          end
        end
        if (DEBUG)
          if (!(ret_val).nil?)
            System.out.println("SNegoContext.initSecContext: " + "sending token = " + (SpNegoToken.get_hex_bytes(ret_val)).to_s)
          end
        end
      rescue GSSException => e
        gss_exception = GSSException.new(error_code, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      return ret_val
    end
    
    typesig { [InputStream, ::Java::Int] }
    # Acceptor's context establishment call. This method may be
    # required to be called several times. A CONTINUE_NEEDED return
    # call indicates that more calls are needed after the next token
    # is received from the peer.
    # 
    # @param is contains the token received from the peer.
    # @return any token required to be sent to the peer
    # It is responsibility of the caller to send the token
    # to its peer for processing.
    # @exception GSSException
    def accept_sec_context(is, mech_token_size)
      ret_val = nil
      nego_result = nil
      valid = true
      if (DEBUG)
        System.out.println("Entered SpNegoContext.acceptSecContext with " + "state=" + (print_state(@state)).to_s)
      end
      if (is_initiator)
        raise GSSException.new(GSSException::FAILURE, -1, "acceptSecContext on an initiator " + "GSSContext")
      end
      begin
        if ((@state).equal?(STATE_NEW))
          @state = STATE_IN_PROCESS
          # read data
          token = Array.typed(::Java::Byte).new(is.available) { 0 }
          SpNegoToken.read_fully(is, token)
          if (DEBUG)
            System.out.println("SpNegoContext.acceptSecContext: " + "receiving token = " + (SpNegoToken.get_hex_bytes(token)).to_s)
          end
          # read the SPNEGO token
          # token will be validated when parsing
          init_token = NegTokenInit.new(token)
          if (DEBUG)
            System.out.println("SpNegoContext.acceptSecContext: " + "received token of type = " + (SpNegoToken.get_token_name(init_token.get_type)).to_s)
          end
          mech_list = init_token.get_mech_type_list
          @der_mech_types = init_token.get_mech_types
          if ((@der_mech_types).nil?)
            valid = false
          end
          # get the mechanism token
          mech_token = init_token.get_mech_token
          # Select the best match between the list of mechs
          # that the initiator requested and the list that
          # the acceptor will support.
          supported_mech_set = get_available_mechs
          mech_wanted = negotiate_mech_type(supported_mech_set, mech_list)
          if ((mech_wanted).nil?)
            valid = false
          end
          # save the desired mechansim
          @internal_mech = mech_wanted
          # get the token for mechanism
          accept_token = _gss_accept_sec_context(mech_token)
          if ((accept_token).nil?)
            valid = false
          end
          # verify MIC
          if (!GSSUtil.use_msinterop && valid)
            valid = verify_mech_list_mic(@der_mech_types, init_token.get_mech_list_mic)
          end
          # determine negotiated result status
          if (valid)
            if (is_mech_context_established)
              nego_result = SpNegoToken::NegoResult::ACCEPT_COMPLETE
              @state = STATE_DONE
              # now set the context flags for acceptor
              set_context_flags
              # print the negotiated mech info
              if (DEBUG)
                System.out.println("SPNEGO Negotiated Mechanism = " + (@internal_mech).to_s + " " + (GSSUtil.get_mech_str(@internal_mech)).to_s)
              end
            else
              nego_result = SpNegoToken::NegoResult::ACCEPT_INCOMPLETE
              @state = STATE_IN_PROCESS
            end
          else
            nego_result = SpNegoToken::NegoResult::REJECT
            @state = STATE_DONE
          end
          if (DEBUG)
            System.out.println("SpNegoContext.acceptSecContext: " + "mechanism wanted = " + (mech_wanted).to_s)
            System.out.println("SpNegoContext.acceptSecContext: " + "negotiated result = " + (nego_result).to_s)
          end
          # calculate MIC only in normal mode
          mic_token = nil
          if (!GSSUtil.use_msinterop && valid)
            mic_token = generate_mech_list_mic(@der_mech_types)
          end
          # generate SPNEGO token
          targ_token = NegTokenTarg.new(nego_result.ordinal, mech_wanted, accept_token, mic_token)
          if (DEBUG)
            System.out.println("SpNegoContext.acceptSecContext: " + "sending token of type = " + (SpNegoToken.get_token_name(targ_token.get_type)).to_s)
          end
          # get the encoded token
          ret_val = targ_token.get_encoded
        else
          if ((@state).equal?(STATE_IN_PROCESS))
            # read the token
            client_token = Array.typed(::Java::Byte).new(is.available) { 0 }
            SpNegoToken.read_fully(is, client_token)
            accept_token = _gss_accept_sec_context(client_token)
            if ((accept_token).nil?)
              valid = false
            end
            # determine negotiated result status
            if (valid)
              if (is_mech_context_established)
                nego_result = SpNegoToken::NegoResult::ACCEPT_COMPLETE
                @state = STATE_DONE
              else
                nego_result = SpNegoToken::NegoResult::ACCEPT_INCOMPLETE
                @state = STATE_IN_PROCESS
              end
            else
              nego_result = SpNegoToken::NegoResult::REJECT
              @state = STATE_DONE
            end
            # generate SPNEGO token
            targ_token = NegTokenTarg.new(nego_result.ordinal, nil, accept_token, nil)
            if (DEBUG)
              System.out.println("SpNegoContext.acceptSecContext: " + "sending token of type = " + (SpNegoToken.get_token_name(targ_token.get_type)).to_s)
            end
            # get the encoded token
            ret_val = targ_token.get_encoded
          else
            # XXX Use logging API
            if (DEBUG)
              System.out.println("AcceptSecContext: state = " + (@state).to_s)
            end
          end
        end
        if (DEBUG)
          System.out.println("SpNegoContext.acceptSecContext: " + "sending token = " + (SpNegoToken.get_hex_bytes(ret_val)).to_s)
        end
      rescue IOException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, e.get_message)
        gss_exception.init_cause(e)
        raise gss_exception
      end
      return ret_val
    end
    
    typesig { [] }
    # obtain the available mechanisms
    def get_available_mechs
      if (!(@my_cred).nil?)
        mechs = Array.typed(Oid).new(1) { nil }
        mechs[0] = @my_cred.get_internal_mech
        return mechs
      else
        return @factory.attr_available_mechs
      end
    end
    
    typesig { [Array.typed(Oid)] }
    # get ther DER encoded MechList
    def get_encoded_mechs(mech_set)
      mech = DerOutputStream.new
      i = 0
      while i < mech_set.attr_length
        mech_type = mech_set[i].get_der
        mech.write(mech_type)
        i += 1
      end
      # insert in SEQUENCE
      mech_type_list = DerOutputStream.new
      mech_type_list.write(DerValue.attr_tag_sequence, mech)
      encoded = mech_type_list.to_byte_array
      return encoded
    end
    
    typesig { [] }
    # get the context flags
    def get_context_flags
      flags = 0
      if (get_cred_deleg_state)
        flags |= CHECKSUM_DELEG_FLAG
      end
      if (get_mutual_auth_state)
        flags |= CHECKSUM_MUTUAL_FLAG
      end
      if (get_replay_det_state)
        flags |= CHECKSUM_REPLAY_FLAG
      end
      if (get_sequence_det_state)
        flags |= CHECKSUM_SEQUENCE_FLAG
      end
      if (get_integ_state)
        flags |= CHECKSUM_INTEG_FLAG
      end
      if (get_conf_state)
        flags |= CHECKSUM_CONF_FLAG
      end
      temp = Array.typed(::Java::Byte).new(1) { 0 }
      temp[0] = (flags & 0xff)
      return temp
    end
    
    typesig { [] }
    def set_context_flags
      if (!(@mech_context).nil?)
        # default for cred delegation is false
        if (@mech_context.get_cred_deleg_state)
          set_cred_deleg_state(true)
        end
        # default for the following are true
        if (!@mech_context.get_mutual_auth_state)
          set_mutual_auth_state(false)
        end
        if (!@mech_context.get_replay_det_state)
          set_replay_det_state(false)
        end
        if (!@mech_context.get_sequence_det_state)
          set_sequence_det_state(false)
        end
        if (!@mech_context.get_integ_state)
          set_integ_state(false)
        end
        if (!@mech_context.get_conf_state)
          set_conf_state(false)
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # generate MIC on mechList
    def generate_mech_list_mic(mech_types)
      # sanity check the required input
      if ((mech_types).nil?)
        if (DEBUG)
          System.out.println("SpNegoContext: no MIC token included")
        end
        return nil
      end
      # check if mechansim supports integrity
      if (!@mech_context.get_integ_state)
        if (DEBUG)
          System.out.println("SpNegoContext: no MIC token included" + " - mechanism does not support integrity")
        end
        return nil
      end
      # compute MIC on DER encoded mechanism list
      mic = nil
      begin
        prop = MessageProp.new(0, true)
        mic = get_mic(mech_types, 0, mech_types.attr_length, prop)
        if (DEBUG)
          System.out.println("SpNegoContext: getMIC = " + (SpNegoToken.get_hex_bytes(mic)).to_s)
        end
      rescue GSSException => e
        mic = nil
        if (DEBUG)
          System.out.println("SpNegoContext: no MIC token included" + " - getMIC failed : " + (e.get_message).to_s)
        end
      end
      return mic
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # verify MIC on MechList
    def verify_mech_list_mic(mech_types, token)
      # sanity check the input
      if ((token).nil?)
        if (DEBUG)
          System.out.println("SpNegoContext: no MIC token validation")
        end
        return true
      end
      # check if mechansim supports integrity
      if (!@mech_context.get_integ_state)
        if (DEBUG)
          System.out.println("SpNegoContext: no MIC token validation" + " - mechanism does not support integrity")
        end
        return true
      end
      # now verify the token
      valid = false
      begin
        prop = MessageProp.new(0, true)
        verify_mic(token, 0, token.attr_length, mech_types, 0, mech_types.attr_length, prop)
        valid = true
      rescue GSSException => e
        valid = false
        if (DEBUG)
          System.out.println("SpNegoContext: MIC validation failed! " + (e.get_message).to_s)
        end
      end
      return valid
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # call gss_init_sec_context for the corresponding underlying mechanism
    def _gss_init_sec_context(token)
      tok = nil
      if ((@mech_context).nil?)
        # initialize mech context
        server_name = @factory.attr_manager.create_name(@peer_name.to_s, @peer_name.get_string_name_type, @internal_mech)
        cred = nil
        if (!(@my_cred).nil?)
          # create context with provided credential
          cred = GSSCredentialImpl.new(@factory.attr_manager, @my_cred.get_internal_cred)
        end
        @mech_context = @factory.attr_manager.create_context(server_name, @internal_mech, cred, GSSContext::DEFAULT_LIFETIME)
        @mech_context.request_conf(@conf_state)
        @mech_context.request_integ(@integ_state)
        @mech_context.request_cred_deleg(@cred_deleg_state)
        @mech_context.request_mutual_auth(@mutual_auth_state)
        @mech_context.request_replay_det(@replay_det_state)
        @mech_context.request_sequence_det(@sequence_det_state)
      end
      # pass token
      if (!(token).nil?)
        tok = token
      else
        tok = Array.typed(::Java::Byte).new(0) { 0 }
      end
      # pass token to mechanism initSecContext
      init_token = @mech_context.init_sec_context(tok, 0, tok.attr_length)
      return init_token
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # call gss_accept_sec_context for the corresponding underlying mechanism
    def _gss_accept_sec_context(token)
      if ((@mech_context).nil?)
        # initialize mech context
        cred = nil
        if (!(@my_cred).nil?)
          # create context with provided credential
          cred = GSSCredentialImpl.new(@factory.attr_manager, @my_cred.get_internal_cred)
        end
        @mech_context = @factory.attr_manager.create_context(cred)
      end
      # pass token to mechanism acceptSecContext
      accept_token = @mech_context.accept_sec_context(token, 0, token.attr_length)
      return accept_token
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Oid), Array.typed(Oid)] }
      # This routine compares the recieved mechset to the mechset that
      # this server can support. It looks sequentially through the mechset
      # and the first one that matches what the server can support is
      # chosen as the negotiated mechanism. If one is found, negResult
      # is set to ACCEPT_COMPLETE, otherwise we return NULL and negResult
      # is set to REJECT.
      def negotiate_mech_type(supported_mech_set, mech_set)
        i = 0
        while i < supported_mech_set.attr_length
          j = 0
          while j < mech_set.attr_length
            if ((mech_set[j] == supported_mech_set[i]))
              if (DEBUG)
                System.out.println("SpNegoContext: " + "negotiated mechanism = " + (mech_set[j]).to_s)
              end
              return (mech_set[j])
            end
            j += 1
          end
          i += 1
        end
        return nil
      end
    }
    
    typesig { [] }
    def is_established
      return ((@state).equal?(STATE_DONE))
    end
    
    typesig { [] }
    def is_mech_context_established
      if (!(@mech_context).nil?)
        return @mech_context.is_established
      else
        if (DEBUG)
          System.out.println("The underlying mechansim context has " + "not been initialized")
        end
        return false
      end
    end
    
    typesig { [] }
    def export
      raise GSSException.new(GSSException::UNAVAILABLE, -1, "GSS Export Context not available")
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
    
    typesig { [::Java::Int] }
    # Requests the desired lifetime. Can only be used on the context
    # initiator's side.
    def request_lifetime(lifetime)
      if ((@state).equal?(STATE_NEW) && is_initiator)
        @lifetime = lifetime
      end
    end
    
    typesig { [] }
    # The lifetime remaining for this context.
    def get_lifetime
      if (!(@mech_context).nil?)
        return @mech_context.get_lifetime
      else
        return GSSContext::INDEFINITE_LIFETIME
      end
    end
    
    typesig { [] }
    def is_transferable
      return false
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
    
    typesig { [] }
    def get_targ_name
      # fill-in the GSSName
      # get the peer name for the mechanism
      if (!(@mech_context).nil?)
        targ_name = @mech_context.get_targ_name
        @peer_name = targ_name.get_element(@internal_mech)
        return @peer_name
      else
        if (DEBUG)
          System.out.println("The underlying mechansim context has " + "not been initialized")
        end
        return nil
      end
    end
    
    typesig { [] }
    def get_src_name
      # fill-in the GSSName
      # get the src name for the mechanism
      if (!(@mech_context).nil?)
        src_name = @mech_context.get_src_name
        @my_name = src_name.get_element(@internal_mech)
        return @my_name
      else
        if (DEBUG)
          System.out.println("The underlying mechansim context has " + "not been initialized")
        end
        return nil
      end
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
      if (!(@mech_context).nil?)
        deleg_cred = @mech_context.get_deleg_cred
        # determine delegated cred element usage
        initiate = false
        if ((deleg_cred.get_usage).equal?(GSSCredential::INITIATE_ONLY))
          initiate = true
        end
        mech_cred = deleg_cred.get_element(@internal_mech, initiate)
        cred = SpNegoCredElement.new(mech_cred)
        return cred.get_internal_cred
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "getDelegCred called in invalid state!")
      end
    end
    
    typesig { [::Java::Int, ::Java::Boolean, ::Java::Int] }
    def get_wrap_size_limit(qop, conf_req, max_tok_size)
      if (!(@mech_context).nil?)
        return @mech_context.get_wrap_size_limit(qop, conf_req, max_tok_size)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "getWrapSizeLimit called in invalid state!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def wrap(in_buf, offset, len, msg_prop)
      if (!(@mech_context).nil?)
        return @mech_context.wrap(in_buf, offset, len, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Wrap called in invalid state!")
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def wrap(is, os, msg_prop)
      if (!(@mech_context).nil?)
        @mech_context.wrap(is, os, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "Wrap called in invalid state!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def unwrap(in_buf, offset, len, msg_prop)
      if (!(@mech_context).nil?)
        return @mech_context.unwrap(in_buf, offset, len, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "UnWrap called in invalid state!")
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def unwrap(is, os, msg_prop)
      if (!(@mech_context).nil?)
        @mech_context.unwrap(is, os, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "UnWrap called in invalid state!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def get_mic(in_msg, offset, len, msg_prop)
      if (!(@mech_context).nil?)
        return @mech_context.get_mic(in_msg, offset, len, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "getMIC called in invalid state!")
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def get_mic(is, os, msg_prop)
      if (!(@mech_context).nil?)
        @mech_context.get_mic(is, os, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "getMIC called in invalid state!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def verify_mic(in_tok, tok_offset, tok_len, in_msg, msg_offset, msg_len, msg_prop)
      if (!(@mech_context).nil?)
        @mech_context.verify_mic(in_tok, tok_offset, tok_len, in_msg, msg_offset, msg_len, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "verifyMIC called in invalid state!")
      end
    end
    
    typesig { [InputStream, InputStream, MessageProp] }
    def verify_mic(is, msg_str, msg_prop)
      if (!(@mech_context).nil?)
        @mech_context.verify_mic(is, msg_str, msg_prop)
      else
        raise GSSException.new(GSSException::NO_CONTEXT, -1, "verifyMIC called in invalid state!")
      end
    end
    
    class_module.module_eval {
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
          return ("Unknown state " + (state).to_s)
        end
      end
    }
    
    private
    alias_method :initialize__sp_nego_context, :initialize
  end
  
end
