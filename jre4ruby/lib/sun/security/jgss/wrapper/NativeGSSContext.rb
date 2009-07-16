require "rjava"

# 
# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Wrapper
  module NativeGSSContextImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Wrapper
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :Provider
      include_const ::Sun::Security::Jgss, :GSSHeader
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Jgss, :GSSExceptionImpl
      include ::Sun::Security::Jgss::Spi
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Security::Jgss::Spnego, :NegTokenInit
      include_const ::Sun::Security::Jgss::Spnego, :NegTokenTarg
      include_const ::Javax::Security::Auth::Kerberos, :DelegationPermission
      include ::Java::Io
    }
  end
  
  # 
  # This class is essentially a wrapper class for the gss_ctx_id_t
  # structure of the native GSS library.
  # @author Valerie Peng
  # @since 1.6
  class NativeGSSContext 
    include_class_members NativeGSSContextImports
    include GSSContextSpi
    
    class_module.module_eval {
      const_set_lazy(:GSS_C_DELEG_FLAG) { 1 }
      const_attr_reader  :GSS_C_DELEG_FLAG
      
      const_set_lazy(:GSS_C_MUTUAL_FLAG) { 2 }
      const_attr_reader  :GSS_C_MUTUAL_FLAG
      
      const_set_lazy(:GSS_C_REPLAY_FLAG) { 4 }
      const_attr_reader  :GSS_C_REPLAY_FLAG
      
      const_set_lazy(:GSS_C_SEQUENCE_FLAG) { 8 }
      const_attr_reader  :GSS_C_SEQUENCE_FLAG
      
      const_set_lazy(:GSS_C_CONF_FLAG) { 16 }
      const_attr_reader  :GSS_C_CONF_FLAG
      
      const_set_lazy(:GSS_C_INTEG_FLAG) { 32 }
      const_attr_reader  :GSS_C_INTEG_FLAG
      
      const_set_lazy(:GSS_C_ANON_FLAG) { 64 }
      const_attr_reader  :GSS_C_ANON_FLAG
      
      const_set_lazy(:GSS_C_PROT_READY_FLAG) { 128 }
      const_attr_reader  :GSS_C_PROT_READY_FLAG
      
      const_set_lazy(:GSS_C_TRANS_FLAG) { 256 }
      const_attr_reader  :GSS_C_TRANS_FLAG
      
      const_set_lazy(:NUM_OF_INQUIRE_VALUES) { 6 }
      const_attr_reader  :NUM_OF_INQUIRE_VALUES
    }
    
    attr_accessor :p_context
    alias_method :attr_p_context, :p_context
    undef_method :p_context
    alias_method :attr_p_context=, :p_context=
    undef_method :p_context=
    
    # Pointer to the gss_ctx_id_t structure
    attr_accessor :src_name
    alias_method :attr_src_name, :src_name
    undef_method :src_name
    alias_method :attr_src_name=, :src_name=
    undef_method :src_name=
    
    attr_accessor :target_name
    alias_method :attr_target_name, :target_name
    undef_method :target_name
    alias_method :attr_target_name=, :target_name=
    undef_method :target_name=
    
    attr_accessor :cred
    alias_method :attr_cred, :cred
    undef_method :cred
    alias_method :attr_cred=, :cred=
    undef_method :cred=
    
    attr_accessor :is_initiator
    alias_method :attr_is_initiator, :is_initiator
    undef_method :is_initiator
    alias_method :attr_is_initiator=, :is_initiator=
    undef_method :is_initiator=
    
    attr_accessor :is_established
    alias_method :attr_is_established, :is_established
    undef_method :is_established
    alias_method :attr_is_established=, :is_established=
    undef_method :is_established=
    
    attr_accessor :actual_mech
    alias_method :attr_actual_mech, :actual_mech
    undef_method :actual_mech
    alias_method :attr_actual_mech=, :actual_mech=
    undef_method :actual_mech=
    
    # Assigned during context establishment
    attr_accessor :cb
    alias_method :attr_cb, :cb
    undef_method :cb
    alias_method :attr_cb=, :cb=
    undef_method :cb=
    
    attr_accessor :delegated_cred
    alias_method :attr_delegated_cred, :delegated_cred
    undef_method :delegated_cred
    alias_method :attr_delegated_cred=, :delegated_cred=
    undef_method :delegated_cred=
    
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    attr_accessor :lifetime
    alias_method :attr_lifetime, :lifetime
    undef_method :lifetime
    alias_method :attr_lifetime=, :lifetime=
    undef_method :lifetime=
    
    attr_accessor :c_stub
    alias_method :attr_c_stub, :c_stub
    undef_method :c_stub
    alias_method :attr_c_stub=, :c_stub=
    undef_method :c_stub=
    
    attr_accessor :skip_deleg_perm_check
    alias_method :attr_skip_deleg_perm_check, :skip_deleg_perm_check
    undef_method :skip_deleg_perm_check
    alias_method :attr_skip_deleg_perm_check=, :skip_deleg_perm_check=
    undef_method :skip_deleg_perm_check=
    
    attr_accessor :skip_service_perm_check
    alias_method :attr_skip_service_perm_check, :skip_service_perm_check
    undef_method :skip_service_perm_check
    alias_method :attr_skip_service_perm_check=, :skip_service_perm_check=
    undef_method :skip_service_perm_check=
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Boolean] }
      # Retrieve the (preferred) mech out of SPNEGO tokens, i.e.
      # NegTokenInit & NegTokenTarg
      def get_mech_from_sp_nego_token(token, is_initiator)
        mech = nil
        if (is_initiator)
          header = nil
          begin
            header = GSSHeader.new(ByteArrayInputStream.new(token))
          rescue IOException => ioe
            raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
          end
          neg_token_len = header.get_mech_token_length
          neg_token = Array.typed(::Java::Byte).new(neg_token_len) { 0 }
          System.arraycopy(token, token.attr_length - neg_token_len, neg_token, 0, neg_token.attr_length)
          ntok = NegTokenInit.new(neg_token)
          if (!(ntok.get_mech_token).nil?)
            mech_list = ntok.get_mech_type_list
            mech = mech_list[0]
          end
        else
          ntok_ = NegTokenTarg.new(token)
          mech = ntok_.get_supported_mech
        end
        return mech
      end
    }
    
    typesig { [] }
    # Perform the Service permission check
    def do_service_perm_check
      if (!(System.get_security_manager).nil?)
        action = (@is_initiator ? "initiate" : "accept")
        # Need to check Service permission for accessing
        # initiator cred for SPNEGO during context establishment
        if (GSSUtil.is_sp_nego_mech(@c_stub.get_mech) && @is_initiator && !@is_established)
          if ((@src_name).nil?)
            # Check by creating default initiator KRB5 cred
            temp_cred = GSSCredElement.new(nil, @lifetime, GSSCredential::INITIATE_ONLY, GSSLibStub.get_instance(GSSUtil::GSS_KRB5_MECH_OID))
            temp_cred.dispose
          else
            tgs_name = Krb5Util.get_tgsname(@src_name)
            Krb5Util.check_service_permission(tgs_name, action)
          end
        end
        target_str = @target_name.get_krb_name
        Krb5Util.check_service_permission(target_str, action)
        @skip_service_perm_check = true
      end
    end
    
    typesig { [] }
    # Perform the Delegation permission check
    def do_deleg_perm_check
      sm = System.get_security_manager
      if (!(sm).nil?)
        target_str = @target_name.get_krb_name
        tgs_str = Krb5Util.get_tgsname(@target_name)
        buf = StringBuffer.new("\"")
        buf.append(target_str).append("\" \"")
        buf.append(tgs_str).append(Character.new(?\".ord))
        krb_princ_pair = buf.to_s
        SunNativeProvider.debug("Checking DelegationPermission (" + krb_princ_pair + ")")
        perm = DelegationPermission.new(krb_princ_pair)
        sm.check_permission(perm)
        @skip_deleg_perm_check = true
      end
    end
    
    typesig { [InputStream, ::Java::Int] }
    def retrieve_token(is, mech_token_len)
      begin
        result = nil
        if (!(mech_token_len).equal?(-1))
          # Need to add back the GSS header for a complete GSS token
          SunNativeProvider.debug("Precomputed mechToken length: " + (mech_token_len).to_s)
          gss_header = GSSHeader.new(ObjectIdentifier.new(@c_stub.get_mech.to_s), mech_token_len)
          baos = ByteArrayOutputStream.new(600)
          mech_token = Array.typed(::Java::Byte).new(mech_token_len) { 0 }
          len = is.read(mech_token)
          raise AssertError if not (((mech_token_len).equal?(len)))
          gss_header.encode(baos)
          baos.write(mech_token)
          result = baos.to_byte_array
        else
          # Must be unparsed GSS token or SPNEGO's NegTokenTarg token
          raise AssertError if not (((mech_token_len).equal?(-1)))
          dv = DerValue.new(is)
          result = dv.to_byte_array
        end
        SunNativeProvider.debug("Complete Token length: " + (result.attr_length).to_s)
        return result
      rescue IOException => ioe
        raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
      end
    end
    
    typesig { [GSSNameElement, GSSCredElement, ::Java::Int, GSSLibStub] }
    # Constructor for context initiator
    def initialize(peer, my_cred, time, stub)
      @p_context = 0
      @src_name = nil
      @target_name = nil
      @cred = nil
      @is_initiator = false
      @is_established = false
      @actual_mech = nil
      @cb = nil
      @delegated_cred = nil
      @flags = 0
      @lifetime = GSSCredential::DEFAULT_LIFETIME
      @c_stub = nil
      @skip_deleg_perm_check = false
      @skip_service_perm_check = false
      if ((peer).nil?)
        raise GSSException.new(GSSException::FAILURE, 1, "null peer")
      end
      @c_stub = stub
      @cred = my_cred
      @target_name = peer
      @is_initiator = true
      @lifetime = time
      if (GSSUtil.is_kerberos_mech(@c_stub.get_mech))
        do_service_perm_check
        if ((@cred).nil?)
          @cred = GSSCredElement.new(nil, @lifetime, GSSCredential::INITIATE_ONLY, @c_stub)
        end
        @src_name = @cred.get_name
      end
    end
    
    typesig { [GSSCredElement, GSSLibStub] }
    # Constructor for context acceptor
    def initialize(my_cred, stub)
      @p_context = 0
      @src_name = nil
      @target_name = nil
      @cred = nil
      @is_initiator = false
      @is_established = false
      @actual_mech = nil
      @cb = nil
      @delegated_cred = nil
      @flags = 0
      @lifetime = GSSCredential::DEFAULT_LIFETIME
      @c_stub = nil
      @skip_deleg_perm_check = false
      @skip_service_perm_check = false
      @c_stub = stub
      @cred = my_cred
      if (!(@cred).nil?)
        @target_name = @cred.get_name
      end
      @is_initiator = false
      # Defer Service permission check for default acceptor cred
      # to acceptSecContext()
      if (GSSUtil.is_kerberos_mech(@c_stub.get_mech) && !(@target_name).nil?)
        do_service_perm_check
      end
      # srcName and potentially targetName (when myCred is null)
      # will be set in GSSLibStub.acceptContext(...)
    end
    
    typesig { [::Java::Long, GSSLibStub] }
    # Constructor for imported context
    def initialize(p_ctxt, stub)
      @p_context = 0
      @src_name = nil
      @target_name = nil
      @cred = nil
      @is_initiator = false
      @is_established = false
      @actual_mech = nil
      @cb = nil
      @delegated_cred = nil
      @flags = 0
      @lifetime = GSSCredential::DEFAULT_LIFETIME
      @c_stub = nil
      @skip_deleg_perm_check = false
      @skip_service_perm_check = false
      raise AssertError if not ((!(@p_context).equal?(0)))
      @p_context = p_ctxt
      @c_stub = stub
      # Set everything except cred, cb, delegatedCred
      info = @c_stub.inquire_context(@p_context)
      if (!(info.attr_length).equal?(NUM_OF_INQUIRE_VALUES))
        raise RuntimeException.new("Bug w/ GSSLibStub.inquireContext()")
      end
      @src_name = GSSNameElement.new(info[0], @c_stub)
      @target_name = GSSNameElement.new(info[1], @c_stub)
      @is_initiator = (!(info[2]).equal?(0))
      @is_established = (!(info[3]).equal?(0))
      @flags = RJava.cast_to_int(info[4])
      @lifetime = RJava.cast_to_int(info[5])
      # Do Service Permission check when importing SPNEGO context
      # just to be safe
      mech = @c_stub.get_mech
      if (GSSUtil.is_sp_nego_mech(mech) || GSSUtil.is_kerberos_mech(mech))
        do_service_perm_check
      end
    end
    
    typesig { [] }
    def get_provider
      return SunNativeProvider::INSTANCE
    end
    
    typesig { [InputStream, ::Java::Int] }
    def init_sec_context(is, mech_token_len)
      out_token = nil
      if ((!@is_established) && (@is_initiator))
        in_token = nil
        # Ignore the specified input stream on the first call
        if (!(@p_context).equal?(0))
          in_token = retrieve_token(is, mech_token_len)
          SunNativeProvider.debug("initSecContext=> inToken len=" + (in_token.attr_length).to_s)
        end
        if (!get_cred_deleg_state)
          @skip_deleg_perm_check = true
        end
        if (GSSUtil.is_kerberos_mech(@c_stub.get_mech) && !@skip_deleg_perm_check)
          do_deleg_perm_check
        end
        p_cred = ((@cred).nil? ? 0 : @cred.attr_p_cred)
        out_token = @c_stub.init_context(p_cred, @target_name.attr_p_name, @cb, in_token, self)
        SunNativeProvider.debug("initSecContext=> outToken len=" + (((out_token).nil? ? 0 : out_token.attr_length)).to_s)
        # Only inspect the token when the permission check
        # has not been performed
        if (GSSUtil.is_sp_nego_mech(@c_stub.get_mech) && !(out_token).nil?)
          # WORKAROUND for SEAM bug#6287358
          @actual_mech = get_mech_from_sp_nego_token(out_token, true)
          if (GSSUtil.is_kerberos_mech(@actual_mech))
            if (!@skip_service_perm_check)
              do_service_perm_check
            end
            if (!@skip_deleg_perm_check)
              do_deleg_perm_check
            end
          end
        end
        if (@is_established)
          if ((@src_name).nil?)
            @src_name = GSSNameElement.new(@c_stub.get_context_name(@p_context, true), @c_stub)
          end
          if ((@cred).nil?)
            @cred = GSSCredElement.new(@src_name, @lifetime, GSSCredential::INITIATE_ONLY, @c_stub)
          end
        end
      end
      return out_token
    end
    
    typesig { [InputStream, ::Java::Int] }
    def accept_sec_context(is, mech_token_len)
      out_token = nil
      if ((!@is_established) && (!@is_initiator))
        in_token = retrieve_token(is, mech_token_len)
        SunNativeProvider.debug("acceptSecContext=> inToken len=" + (in_token.attr_length).to_s)
        p_cred = ((@cred).nil? ? 0 : @cred.attr_p_cred)
        out_token = @c_stub.accept_context(p_cred, @cb, in_token, self)
        SunNativeProvider.debug("acceptSecContext=> outToken len=" + (((out_token).nil? ? 0 : out_token.attr_length)).to_s)
        if ((@target_name).nil?)
          @target_name = GSSNameElement.new(@c_stub.get_context_name(@p_context, false), @c_stub)
          # Replace the current default acceptor cred now that
          # the context acceptor name is available
          if (!(@cred).nil?)
            @cred.dispose
          end
          @cred = GSSCredElement.new(@target_name, @lifetime, GSSCredential::ACCEPT_ONLY, @c_stub)
        end
        # Only inspect token when the permission check has not
        # been performed
        if (GSSUtil.is_sp_nego_mech(@c_stub.get_mech) && (!(out_token).nil?) && !@skip_service_perm_check)
          if (GSSUtil.is_kerberos_mech(get_mech_from_sp_nego_token(out_token, false)))
            do_service_perm_check
          end
        end
      end
      return out_token
    end
    
    typesig { [] }
    def is_established
      return @is_established
    end
    
    typesig { [] }
    def dispose
      @src_name = nil
      @target_name = nil
      @cred = nil
      @delegated_cred = nil
      if (!(@p_context).equal?(0))
        @p_context = @c_stub.delete_context(@p_context)
        @p_context = 0
      end
    end
    
    typesig { [::Java::Int, ::Java::Boolean, ::Java::Int] }
    def get_wrap_size_limit(qop, conf_req, max_token_size)
      return @c_stub.wrap_size_limit(@p_context, (conf_req ? 1 : 0), qop, max_token_size)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def wrap(in_buf, offset, len, msg_prop)
      data = in_buf
      if ((!(offset).equal?(0)) || (!(len).equal?(in_buf.attr_length)))
        data = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(in_buf, offset, data, 0, len)
      end
      return @c_stub.wrap(@p_context, data, msg_prop)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, OutputStream, MessageProp] }
    def wrap(in_buf, offset, len, os, msg_prop)
      begin
        result = wrap(in_buf, offset, len, msg_prop)
        os.write(result)
      rescue IOException => ioe
        raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, MessageProp] }
    def wrap(in_buf, in_offset, len, out_buf, out_offset, msg_prop)
      result = wrap(in_buf, in_offset, len, msg_prop)
      System.arraycopy(result, 0, out_buf, out_offset, result.attr_length)
      return result.attr_length
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def wrap(in_stream, out_stream, msg_prop)
      begin
        data = Array.typed(::Java::Byte).new(in_stream.available) { 0 }
        length = in_stream.read(data)
        token = wrap(data, 0, length, msg_prop)
        out_stream.write(token)
      rescue IOException => ioe
        raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def unwrap(in_buf, offset, len, msg_prop)
      if ((!(offset).equal?(0)) || (!(len).equal?(in_buf.attr_length)))
        temp = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(in_buf, offset, temp, 0, len)
        return @c_stub.unwrap(@p_context, temp, msg_prop)
      else
        return @c_stub.unwrap(@p_context, in_buf, msg_prop)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, MessageProp] }
    def unwrap(in_buf, in_offset, len, out_buf, out_offset, msg_prop)
      result = nil
      if ((!(in_offset).equal?(0)) || (!(len).equal?(in_buf.attr_length)))
        temp = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(in_buf, in_offset, temp, 0, len)
        result = @c_stub.unwrap(@p_context, temp, msg_prop)
      else
        result = @c_stub.unwrap(@p_context, in_buf, msg_prop)
      end
      System.arraycopy(result, 0, out_buf, out_offset, result.attr_length)
      return result.attr_length
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def unwrap(in_stream, out_stream, msg_prop)
      begin
        wrapped = Array.typed(::Java::Byte).new(in_stream.available) { 0 }
        w_length = in_stream.read(wrapped)
        data = unwrap(wrapped, 0, w_length, msg_prop)
        out_stream.write(data)
        out_stream.flush
      rescue IOException => ioe
        raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
      end
    end
    
    typesig { [InputStream, Array.typed(::Java::Byte), ::Java::Int, MessageProp] }
    def unwrap(in_stream, out_buf, out_offset, msg_prop)
      wrapped = nil
      w_length = 0
      begin
        wrapped = Array.typed(::Java::Byte).new(in_stream.available) { 0 }
        w_length = in_stream.read(wrapped)
        result = unwrap(wrapped, 0, w_length, msg_prop)
      rescue IOException => ioe
        raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
      end
      result_ = unwrap(wrapped, 0, w_length, msg_prop)
      System.arraycopy(result_, 0, out_buf, out_offset, result_.attr_length)
      return result_.attr_length
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def get_mic(in_, offset, len, msg_prop)
      qop = ((msg_prop).nil? ? 0 : msg_prop.get_qop)
      in_msg = in_
      if ((!(offset).equal?(0)) || (!(len).equal?(in_.attr_length)))
        in_msg = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(in_, offset, in_msg, 0, len)
      end
      return @c_stub.get_mic(@p_context, qop, in_msg)
    end
    
    typesig { [InputStream, OutputStream, MessageProp] }
    def get_mic(in_stream, out_stream, msg_prop)
      begin
        length = 0
        msg = Array.typed(::Java::Byte).new(in_stream.available) { 0 }
        length = in_stream.read(msg)
        msg_token = get_mic(msg, 0, length, msg_prop)
        if ((!(msg_token).nil?) && !(msg_token.attr_length).equal?(0))
          out_stream.write(msg_token)
        end
      rescue IOException => ioe
        raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def verify_mic(in_token, t_offset, t_len, in_msg, m_offset, m_len, msg_prop)
      token = in_token
      msg = in_msg
      if ((!(t_offset).equal?(0)) || (!(t_len).equal?(in_token.attr_length)))
        token = Array.typed(::Java::Byte).new(t_len) { 0 }
        System.arraycopy(in_token, t_offset, token, 0, t_len)
      end
      if ((!(m_offset).equal?(0)) || (!(m_len).equal?(in_msg.attr_length)))
        msg = Array.typed(::Java::Byte).new(m_len) { 0 }
        System.arraycopy(in_msg, m_offset, msg, 0, m_len)
      end
      @c_stub.verify_mic(@p_context, token, msg, msg_prop)
    end
    
    typesig { [InputStream, InputStream, MessageProp] }
    def verify_mic(tok_stream, msg_stream, msg_prop)
      begin
        msg = Array.typed(::Java::Byte).new(msg_stream.available) { 0 }
        m_length = msg_stream.read(msg)
        tok = Array.typed(::Java::Byte).new(tok_stream.available) { 0 }
        t_length = tok_stream.read(tok)
        verify_mic(tok, 0, t_length, msg, 0, m_length, msg_prop)
      rescue IOException => ioe
        raise GSSExceptionImpl.new(GSSException::FAILURE, ioe)
      end
    end
    
    typesig { [] }
    def export
      result = @c_stub.export_context(@p_context)
      @p_context = 0
      return result
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def change_flags(flag_mask, is_enable)
      if (@is_initiator && (@p_context).equal?(0))
        if (is_enable)
          @flags |= flag_mask
        else
          @flags &= ~flag_mask
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    def request_mutual_auth(state)
      change_flags(GSS_C_MUTUAL_FLAG, state)
    end
    
    typesig { [::Java::Boolean] }
    def request_replay_det(state)
      change_flags(GSS_C_REPLAY_FLAG, state)
    end
    
    typesig { [::Java::Boolean] }
    def request_sequence_det(state)
      change_flags(GSS_C_SEQUENCE_FLAG, state)
    end
    
    typesig { [::Java::Boolean] }
    def request_cred_deleg(state)
      change_flags(GSS_C_DELEG_FLAG, state)
    end
    
    typesig { [::Java::Boolean] }
    def request_anonymity(state)
      change_flags(GSS_C_ANON_FLAG, state)
    end
    
    typesig { [::Java::Boolean] }
    def request_conf(state)
      change_flags(GSS_C_CONF_FLAG, state)
    end
    
    typesig { [::Java::Boolean] }
    def request_integ(state)
      change_flags(GSS_C_INTEG_FLAG, state)
    end
    
    typesig { [::Java::Int] }
    def request_lifetime(lifetime)
      if (@is_initiator && (@p_context).equal?(0))
        @lifetime = lifetime
      end
    end
    
    typesig { [ChannelBinding] }
    def set_channel_binding(cb)
      if ((@p_context).equal?(0))
        @cb = cb
      end
    end
    
    typesig { [::Java::Int] }
    def check_flags(flag_mask)
      return (!((@flags & flag_mask)).equal?(0))
    end
    
    typesig { [] }
    def get_cred_deleg_state
      return check_flags(GSS_C_DELEG_FLAG)
    end
    
    typesig { [] }
    def get_mutual_auth_state
      return check_flags(GSS_C_MUTUAL_FLAG)
    end
    
    typesig { [] }
    def get_replay_det_state
      return check_flags(GSS_C_REPLAY_FLAG)
    end
    
    typesig { [] }
    def get_sequence_det_state
      return check_flags(GSS_C_SEQUENCE_FLAG)
    end
    
    typesig { [] }
    def get_anonymity_state
      return check_flags(GSS_C_ANON_FLAG)
    end
    
    typesig { [] }
    def is_transferable
      return check_flags(GSS_C_TRANS_FLAG)
    end
    
    typesig { [] }
    def is_prot_ready
      return check_flags(GSS_C_PROT_READY_FLAG)
    end
    
    typesig { [] }
    def get_conf_state
      return check_flags(GSS_C_CONF_FLAG)
    end
    
    typesig { [] }
    def get_integ_state
      return check_flags(GSS_C_INTEG_FLAG)
    end
    
    typesig { [] }
    def get_lifetime
      return @c_stub.get_context_time(@p_context)
    end
    
    typesig { [] }
    def get_src_name
      return @src_name
    end
    
    typesig { [] }
    def get_targ_name
      return @target_name
    end
    
    typesig { [] }
    def get_mech
      if (@is_established && !(@actual_mech).nil?)
        return @actual_mech
      else
        return @c_stub.get_mech
      end
    end
    
    typesig { [] }
    def get_deleg_cred
      return @delegated_cred
    end
    
    typesig { [] }
    def is_initiator
      return @is_initiator
    end
    
    typesig { [] }
    def finalize
      dispose
    end
    
    private
    alias_method :initialize__native_gsscontext, :initialize
  end
  
end
