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
module Sun::Security::Jgss
  module GSSContextImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss::Spi
      include ::Sun::Security::Jgss
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class represents the JGSS security context and its associated
  # operations.  JGSS security contexts are established between
  # peers using locally established credentials.  Multiple contexts
  # may exist simultaneously between a pair of peers, using the same
  # or different set of credentials.  The JGSS is independent of
  # the underlying transport protocols and depends on its callers to
  # transport the tokens between peers.
  # <p>
  # The context object can be thought of as having 3 implicit states:
  # before it is established, during its context establishment, and
  # after a fully established context exists.
  # <p>
  # Before the context establishment phase is initiated, the context
  # initiator may request specific characteristics desired of the
  # established context. These can be set using the set methods. After the
  # context is established, the caller can check the actual characteristic
  # and services offered by the context using the query methods.
  # <p>
  # The context establishment phase begins with the first call to the
  # initSecContext method by the context initiator. During this phase the
  # initSecContext and acceptSecContext methods will produce GSS-API
  # authentication tokens which the calling application needs to send to its
  # peer. The initSecContext and acceptSecContext methods may
  # return a CONTINUE_NEEDED code which indicates that a token is needed
  # from its peer in order to continue the context establishment phase. A
  # return code of COMPLETE signals that the local end of the context is
  # established. This may still require that a token be sent to the peer,
  # depending if one is produced by GSS-API. The isEstablished method can
  # also be used to determine if the local end of the context has been
  # fully established. During the context establishment phase, the
  # isProtReady method may be called to determine if the context can be
  # used for the per-message operations. This allows implementation to
  # use per-message operations on contexts which aren't fully established.
  # <p>
  # After the context has been established or the isProtReady method
  # returns "true", the query routines can be invoked to determine the actual
  # characteristics and services of the established context. The
  # application can also start using the per-message methods of wrap and
  # getMIC to obtain cryptographic operations on application supplied data.
  # <p>
  # When the context is no longer needed, the application should call
  # dispose to release any system resources the context may be using.
  # <DL><DT><B>RFC 2078</b>
  # <DD>This class corresponds to the context level calls together with
  # the per message calls of RFC 2078. The gss_init_sec_context and
  # gss_accept_sec_context calls have been made simpler by only taking
  # required parameters.  The context can have its properties set before
  # the first call to initSecContext. The supplementary status codes for the
  # per-message operations are returned in an instance of the MessageProp
  # class, which is used as an argument in these calls.</dl>
  class GSSContextImpl 
    include_class_members GSSContextImplImports
    include GSSContext
    
    attr_accessor :gss_manager
    alias_method :attr_gss_manager, :gss_manager
    undef_method :gss_manager
    alias_method :attr_gss_manager=, :gss_manager=
    undef_method :gss_manager=
    
    class_module.module_eval {
      # private flags for the context state
      const_set_lazy(:PRE_INIT) { 1 }
      const_attr_reader  :PRE_INIT
      
      const_set_lazy(:IN_PROGRESS) { 2 }
      const_attr_reader  :IN_PROGRESS
      
      const_set_lazy(:READY) { 3 }
      const_attr_reader  :READY
      
      const_set_lazy(:DELETED) { 4 }
      const_attr_reader  :DELETED
    }
    
    # instance variables
    attr_accessor :current_state
    alias_method :attr_current_state, :current_state
    undef_method :current_state
    alias_method :attr_current_state=, :current_state=
    undef_method :current_state=
    
    attr_accessor :initiator
    alias_method :attr_initiator, :initiator
    undef_method :initiator
    alias_method :attr_initiator=, :initiator=
    undef_method :initiator=
    
    attr_accessor :mech_ctxt
    alias_method :attr_mech_ctxt, :mech_ctxt
    undef_method :mech_ctxt
    alias_method :attr_mech_ctxt=, :mech_ctxt=
    undef_method :mech_ctxt=
    
    attr_accessor :mech_oid
    alias_method :attr_mech_oid, :mech_oid
    undef_method :mech_oid
    alias_method :attr_mech_oid=, :mech_oid=
    undef_method :mech_oid=
    
    attr_accessor :obj_id
    alias_method :attr_obj_id, :obj_id
    undef_method :obj_id
    alias_method :attr_obj_id=, :obj_id=
    undef_method :obj_id=
    
    attr_accessor :my_cred
    alias_method :attr_my_cred, :my_cred
    undef_method :my_cred
    alias_method :attr_my_cred=, :my_cred=
    undef_method :my_cred=
    
    attr_accessor :deleg_cred
    alias_method :attr_deleg_cred, :deleg_cred
    undef_method :deleg_cred
    alias_method :attr_deleg_cred=, :deleg_cred=
    undef_method :deleg_cred=
    
    attr_accessor :src_name
    alias_method :attr_src_name, :src_name
    undef_method :src_name
    alias_method :attr_src_name=, :src_name=
    undef_method :src_name=
    
    attr_accessor :targ_name
    alias_method :attr_targ_name, :targ_name
    undef_method :targ_name
    alias_method :attr_targ_name=, :targ_name=
    undef_method :targ_name=
    
    attr_accessor :req_lifetime
    alias_method :attr_req_lifetime, :req_lifetime
    undef_method :req_lifetime
    alias_method :attr_req_lifetime=, :req_lifetime=
    undef_method :req_lifetime=
    
    attr_accessor :channel_bindings
    alias_method :attr_channel_bindings, :channel_bindings
    undef_method :channel_bindings
    alias_method :attr_channel_bindings=, :channel_bindings=
    undef_method :channel_bindings=
    
    attr_accessor :req_conf_state
    alias_method :attr_req_conf_state, :req_conf_state
    undef_method :req_conf_state
    alias_method :attr_req_conf_state=, :req_conf_state=
    undef_method :req_conf_state=
    
    attr_accessor :req_integ_state
    alias_method :attr_req_integ_state, :req_integ_state
    undef_method :req_integ_state
    alias_method :attr_req_integ_state=, :req_integ_state=
    undef_method :req_integ_state=
    
    attr_accessor :req_mutual_auth_state
    alias_method :attr_req_mutual_auth_state, :req_mutual_auth_state
    undef_method :req_mutual_auth_state
    alias_method :attr_req_mutual_auth_state=, :req_mutual_auth_state=
    undef_method :req_mutual_auth_state=
    
    attr_accessor :req_replay_det_state
    alias_method :attr_req_replay_det_state, :req_replay_det_state
    undef_method :req_replay_det_state
    alias_method :attr_req_replay_det_state=, :req_replay_det_state=
    undef_method :req_replay_det_state=
    
    attr_accessor :req_sequence_det_state
    alias_method :attr_req_sequence_det_state, :req_sequence_det_state
    undef_method :req_sequence_det_state
    alias_method :attr_req_sequence_det_state=, :req_sequence_det_state=
    undef_method :req_sequence_det_state=
    
    attr_accessor :req_cred_deleg_state
    alias_method :attr_req_cred_deleg_state, :req_cred_deleg_state
    undef_method :req_cred_deleg_state
    alias_method :attr_req_cred_deleg_state=, :req_cred_deleg_state=
    undef_method :req_cred_deleg_state=
    
    attr_accessor :req_anon_state
    alias_method :attr_req_anon_state, :req_anon_state
    undef_method :req_anon_state
    alias_method :attr_req_anon_state=, :req_anon_state=
    undef_method :req_anon_state=
    
    typesig { [GSSManagerImpl, GSSName, Oid, GSSCredential, ::Java::Int] }
    # Creates a GSSContextImp on the context initiator's side.
    def initialize(gss_manager, peer, mech, my_cred, lifetime)
      @gss_manager = nil
      @current_state = PRE_INIT
      @initiator = false
      @mech_ctxt = nil
      @mech_oid = nil
      @obj_id = nil
      @my_cred = nil
      @deleg_cred = nil
      @src_name = nil
      @targ_name = nil
      @req_lifetime = INDEFINITE_LIFETIME
      @channel_bindings = nil
      @req_conf_state = true
      @req_integ_state = true
      @req_mutual_auth_state = true
      @req_replay_det_state = true
      @req_sequence_det_state = true
      @req_cred_deleg_state = false
      @req_anon_state = false
      if (((peer).nil?) || !(peer.is_a?(GSSNameImpl)))
        raise GSSException.new(GSSException::BAD_NAME)
      end
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      @gss_manager = gss_manager
      @my_cred = my_cred # XXX Check first
      @req_lifetime = lifetime
      @targ_name = peer
      @mech_oid = mech
      @initiator = true
    end
    
    typesig { [GSSManagerImpl, GSSCredential] }
    # Creates a GSSContextImpl on the context acceptor's side.
    def initialize(gss_manager, my_cred)
      @gss_manager = nil
      @current_state = PRE_INIT
      @initiator = false
      @mech_ctxt = nil
      @mech_oid = nil
      @obj_id = nil
      @my_cred = nil
      @deleg_cred = nil
      @src_name = nil
      @targ_name = nil
      @req_lifetime = INDEFINITE_LIFETIME
      @channel_bindings = nil
      @req_conf_state = true
      @req_integ_state = true
      @req_mutual_auth_state = true
      @req_replay_det_state = true
      @req_sequence_det_state = true
      @req_cred_deleg_state = false
      @req_anon_state = false
      @gss_manager = gss_manager
      @my_cred = my_cred # XXX Check first
      @initiator = false
    end
    
    typesig { [GSSManagerImpl, Array.typed(::Java::Byte)] }
    # Creates a GSSContextImpl out of a previously exported
    # GSSContext.
    # 
    # @see #isTransferable
    def initialize(gss_manager, inter_process_token)
      @gss_manager = nil
      @current_state = PRE_INIT
      @initiator = false
      @mech_ctxt = nil
      @mech_oid = nil
      @obj_id = nil
      @my_cred = nil
      @deleg_cred = nil
      @src_name = nil
      @targ_name = nil
      @req_lifetime = INDEFINITE_LIFETIME
      @channel_bindings = nil
      @req_conf_state = true
      @req_integ_state = true
      @req_mutual_auth_state = true
      @req_replay_det_state = true
      @req_sequence_det_state = true
      @req_cred_deleg_state = false
      @req_anon_state = false
      @gss_manager = gss_manager
      @mech_ctxt = gss_manager.get_mechanism_context(inter_process_token)
      @initiator = @mech_ctxt.is_initiator
      @mech_oid = @mech_ctxt.get_mech
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def init_sec_context(input_buf, offset, len)
      # Size of ByteArrayOutputStream will double each time that extra
      # bytes are to be written. Usually, without delegation, a GSS
      # initial token containing the Kerberos AP-REQ is between 400 and
      # 600 bytes.
      bos = ByteArrayOutputStream.new(600)
      bin = ByteArrayInputStream.new(input_buf, offset, len)
      size = init_sec_context(bin, bos)
      return ((size).equal?(0) ? nil : bos.to_byte_array)
    end
    
    typesig { [InputStream, OutputStream] }
    def init_sec_context(in_stream, out_stream)
      if (!(@mech_ctxt).nil? && !(@current_state).equal?(IN_PROGRESS))
        raise GSSExceptionImpl.new(GSSException::FAILURE, "Illegal call to initSecContext")
      end
      gss_header = nil
      in_token_len = -1
      cred_element = nil
      first_token = false
      begin
        if ((@mech_ctxt).nil?)
          if (!(@my_cred).nil?)
            begin
              cred_element = @my_cred.get_element(@mech_oid, true)
            rescue GSSException => ge
              if (GSSUtil.is_sp_nego_mech(@mech_oid) && (ge.get_major).equal?(GSSException::NO_CRED))
                cred_element = @my_cred.get_element(@my_cred.get_mechs[0], true)
              else
                raise ge
              end
            end
          end
          name_element = @targ_name.get_element(@mech_oid)
          @mech_ctxt = @gss_manager.get_mechanism_context(name_element, cred_element, @req_lifetime, @mech_oid)
          @mech_ctxt.request_conf(@req_conf_state)
          @mech_ctxt.request_integ(@req_integ_state)
          @mech_ctxt.request_cred_deleg(@req_cred_deleg_state)
          @mech_ctxt.request_mutual_auth(@req_mutual_auth_state)
          @mech_ctxt.request_replay_det(@req_replay_det_state)
          @mech_ctxt.request_sequence_det(@req_sequence_det_state)
          @mech_ctxt.request_anonymity(@req_anon_state)
          @mech_ctxt.set_channel_binding(@channel_bindings)
          @obj_id = ObjectIdentifier.new(@mech_oid.to_s)
          @current_state = IN_PROGRESS
          first_token = true
        else
          if ((@mech_ctxt.get_provider.get_name == "SunNativeGSS") || GSSUtil.is_sp_nego_mech(@mech_oid))
            # do not parse GSS header for native provider or SPNEGO
            # mech
          else
            # parse GSS header
            gss_header = GSSHeader.new(in_stream)
            if (!(gss_header.get_oid == @obj_id))
              raise GSSExceptionImpl.new(GSSException::DEFECTIVE_TOKEN, "Mechanism not equal to " + RJava.cast_to_string(@mech_oid.to_s) + " in initSecContext token")
            end
            in_token_len = gss_header.get_mech_token_length
          end
        end
        obuf = @mech_ctxt.init_sec_context(in_stream, in_token_len)
        ret_val = 0
        if (!(obuf).nil?)
          ret_val = obuf.attr_length
          if ((@mech_ctxt.get_provider.get_name == "SunNativeGSS") || (!first_token && GSSUtil.is_sp_nego_mech(@mech_oid)))
            # do not add GSS header for native provider or SPNEGO
            # except for the first SPNEGO token
          else
            # add GSS header
            gss_header = GSSHeader.new(@obj_id, obuf.attr_length)
            ret_val += gss_header.encode(out_stream)
          end
          out_stream.write(obuf)
        end
        if (@mech_ctxt.is_established)
          @current_state = READY
        end
        return ret_val
      rescue IOException => e
        raise GSSExceptionImpl.new(GSSException::DEFECTIVE_TOKEN, e.get_message)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def accept_sec_context(in_tok, offset, len)
      # Usually initial GSS token containing a Kerberos AP-REP is less
      # than 100 bytes.
      bos = ByteArrayOutputStream.new(100)
      accept_sec_context(ByteArrayInputStream.new(in_tok, offset, len), bos)
      return bos.to_byte_array
    end
    
    typesig { [InputStream, OutputStream] }
    def accept_sec_context(in_stream, out_stream)
      if (!(@mech_ctxt).nil? && !(@current_state).equal?(IN_PROGRESS))
        raise GSSExceptionImpl.new(GSSException::FAILURE, "Illegal call to acceptSecContext")
      end
      gss_header = nil
      in_token_len = -1
      cred_element = nil
      begin
        if ((@mech_ctxt).nil?)
          # mechOid will be null for an acceptor's context
          gss_header = GSSHeader.new(in_stream)
          in_token_len = gss_header.get_mech_token_length
          # Convert ObjectIdentifier to Oid
          @obj_id = gss_header.get_oid
          @mech_oid = Oid.new(@obj_id.to_s)
          # System.out.println("Entered GSSContextImpl.acceptSecContext"
          # + " with mechanism = " + mechOid);
          if (!(@my_cred).nil?)
            cred_element = @my_cred.get_element(@mech_oid, false)
          end
          @mech_ctxt = @gss_manager.get_mechanism_context(cred_element, @mech_oid)
          @mech_ctxt.set_channel_binding(@channel_bindings)
          @current_state = IN_PROGRESS
        else
          if ((@mech_ctxt.get_provider.get_name == "SunNativeGSS") || (GSSUtil.is_sp_nego_mech(@mech_oid)))
            # do not parse GSS header for native provider and SPNEGO
          else
            # parse GSS Header
            gss_header = GSSHeader.new(in_stream)
            if (!(gss_header.get_oid == @obj_id))
              raise GSSExceptionImpl.new(GSSException::DEFECTIVE_TOKEN, "Mechanism not equal to " + RJava.cast_to_string(@mech_oid.to_s) + " in acceptSecContext token")
            end
            in_token_len = gss_header.get_mech_token_length
          end
        end
        obuf = @mech_ctxt.accept_sec_context(in_stream, in_token_len)
        if (!(obuf).nil?)
          ret_val = obuf.attr_length
          if ((@mech_ctxt.get_provider.get_name == "SunNativeGSS") || (GSSUtil.is_sp_nego_mech(@mech_oid)))
            # do not add GSS header for native provider and SPNEGO
          else
            # add GSS header
            gss_header = GSSHeader.new(@obj_id, obuf.attr_length)
            ret_val += gss_header.encode(out_stream)
          end
          out_stream.write(obuf)
        end
        if (@mech_ctxt.is_established)
          @current_state = READY
        end
      rescue IOException => e
        raise GSSExceptionImpl.new(GSSException::DEFECTIVE_TOKEN, e.get_message)
      end
    end
    
    typesig { [] }
    def is_established
      if ((@mech_ctxt).nil?)
        return false
      else
        return ((@current_state).equal?(READY))
      end
    end
    
    typesig { [::Java::Int, ::Java::Boolean, ::Java::Int] }
    def get_wrap_size_limit(qop, conf_req, max_token_size)
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_wrap_size_limit(qop, conf_req, max_token_size)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def wrap(in_buf, offset, len, msg_prop)
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.wrap(in_buf, offset, len, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def wrap(in_stream, out_stream, msg_prop)
      if (!(@mech_ctxt).nil?)
        @mech_ctxt.wrap(in_stream, out_stream, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def unwrap(in_buf, offset, len, msg_prop)
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.unwrap(in_buf, offset, len, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def unwrap(in_stream, out_stream, msg_prop)
      if (!(@mech_ctxt).nil?)
        @mech_ctxt.unwrap(in_stream, out_stream, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def get_mic(in_msg, offset, len, msg_prop)
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_mic(in_msg, offset, len, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def get_mic(in_stream, out_stream, msg_prop)
      if (!(@mech_ctxt).nil?)
        @mech_ctxt.get_mic(in_stream, out_stream, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def verify_mic(in_tok, tok_offset, tok_len, in_msg, msg_offset, msg_len, msg_prop)
      if (!(@mech_ctxt).nil?)
        @mech_ctxt.verify_mic(in_tok, tok_offset, tok_len, in_msg, msg_offset, msg_len, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [InputStream, InputStream, MessageProp] }
    def verify_mic(tok_stream, msg_stream, msg_prop)
      if (!(@mech_ctxt).nil?)
        @mech_ctxt.verify_mic(tok_stream, msg_stream, msg_prop)
      else
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
    end
    
    typesig { [] }
    def export
      # Defaults to null to match old behavior
      result = nil
      # Only allow context export from native provider since JGSS
      # still has not defined its own interprocess token format
      if (@mech_ctxt.is_transferable && (@mech_ctxt.get_provider.get_name == "SunNativeGSS"))
        result = @mech_ctxt.export
      end
      return result
    end
    
    typesig { [::Java::Boolean] }
    def request_mutual_auth(state)
      if ((@mech_ctxt).nil?)
        @req_mutual_auth_state = state
      end
    end
    
    typesig { [::Java::Boolean] }
    def request_replay_det(state)
      if ((@mech_ctxt).nil?)
        @req_replay_det_state = state
      end
    end
    
    typesig { [::Java::Boolean] }
    def request_sequence_det(state)
      if ((@mech_ctxt).nil?)
        @req_sequence_det_state = state
      end
    end
    
    typesig { [::Java::Boolean] }
    def request_cred_deleg(state)
      if ((@mech_ctxt).nil?)
        @req_cred_deleg_state = state
      end
    end
    
    typesig { [::Java::Boolean] }
    def request_anonymity(state)
      if ((@mech_ctxt).nil?)
        @req_anon_state = state
      end
    end
    
    typesig { [::Java::Boolean] }
    def request_conf(state)
      if ((@mech_ctxt).nil?)
        @req_conf_state = state
      end
    end
    
    typesig { [::Java::Boolean] }
    def request_integ(state)
      if ((@mech_ctxt).nil?)
        @req_integ_state = state
      end
    end
    
    typesig { [::Java::Int] }
    def request_lifetime(lifetime)
      if ((@mech_ctxt).nil?)
        @req_lifetime = lifetime
      end
    end
    
    typesig { [ChannelBinding] }
    def set_channel_binding(channel_bindings)
      if ((@mech_ctxt).nil?)
        @channel_bindings = channel_bindings
      end
    end
    
    typesig { [] }
    def get_cred_deleg_state
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_cred_deleg_state
      else
        return @req_cred_deleg_state
      end
    end
    
    typesig { [] }
    def get_mutual_auth_state
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_mutual_auth_state
      else
        return @req_mutual_auth_state
      end
    end
    
    typesig { [] }
    def get_replay_det_state
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_replay_det_state
      else
        return @req_replay_det_state
      end
    end
    
    typesig { [] }
    def get_sequence_det_state
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_sequence_det_state
      else
        return @req_sequence_det_state
      end
    end
    
    typesig { [] }
    def get_anonymity_state
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_anonymity_state
      else
        return @req_anon_state
      end
    end
    
    typesig { [] }
    def is_transferable
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.is_transferable
      else
        return false
      end
    end
    
    typesig { [] }
    def is_prot_ready
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.is_prot_ready
      else
        return false
      end
    end
    
    typesig { [] }
    def get_conf_state
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_conf_state
      else
        return @req_conf_state
      end
    end
    
    typesig { [] }
    def get_integ_state
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_integ_state
      else
        return @req_integ_state
      end
    end
    
    typesig { [] }
    def get_lifetime
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_lifetime
      else
        return @req_lifetime
      end
    end
    
    typesig { [] }
    def get_src_name
      if ((@src_name).nil?)
        @src_name = GSSNameImpl.wrap_element(@gss_manager, @mech_ctxt.get_src_name)
      end
      return @src_name
    end
    
    typesig { [] }
    def get_targ_name
      if ((@targ_name).nil?)
        @targ_name = GSSNameImpl.wrap_element(@gss_manager, @mech_ctxt.get_targ_name)
      end
      return @targ_name
    end
    
    typesig { [] }
    def get_mech
      if (!(@mech_ctxt).nil?)
        return @mech_ctxt.get_mech
      end
      return @mech_oid
    end
    
    typesig { [] }
    def get_deleg_cred
      if ((@mech_ctxt).nil?)
        raise GSSExceptionImpl.new(GSSException::NO_CONTEXT, "No mechanism context yet!")
      end
      del_cred_element = @mech_ctxt.get_deleg_cred
      return ((del_cred_element).nil? ? nil : GSSCredentialImpl.new(@gss_manager, del_cred_element))
    end
    
    typesig { [] }
    def is_initiator
      return @initiator
    end
    
    typesig { [] }
    def dispose
      @current_state = DELETED
      if (!(@mech_ctxt).nil?)
        @mech_ctxt.dispose
        @mech_ctxt = nil
      end
      @my_cred = nil
      @src_name = nil
      @targ_name = nil
    end
    
    private
    alias_method :initialize__gsscontext_impl, :initialize
  end
  
end
