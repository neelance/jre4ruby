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
  module InitialTokenImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Javax::Security::Auth::Kerberos, :DelegationPermission
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :Inet4Address
      include_const ::Java::Net, :Inet6Address
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Krb5::Internal, :Krb5
    }
  end
  
  class InitialToken < InitialTokenImports.const_get :Krb5Token
    include_class_members InitialTokenImports
    
    class_module.module_eval {
      const_set_lazy(:CHECKSUM_TYPE) { 0x8003 }
      const_attr_reader  :CHECKSUM_TYPE
      
      const_set_lazy(:CHECKSUM_LENGTH_SIZE) { 4 }
      const_attr_reader  :CHECKSUM_LENGTH_SIZE
      
      const_set_lazy(:CHECKSUM_BINDINGS_SIZE) { 16 }
      const_attr_reader  :CHECKSUM_BINDINGS_SIZE
      
      const_set_lazy(:CHECKSUM_FLAGS_SIZE) { 4 }
      const_attr_reader  :CHECKSUM_FLAGS_SIZE
      
      const_set_lazy(:CHECKSUM_DELEG_OPT_SIZE) { 2 }
      const_attr_reader  :CHECKSUM_DELEG_OPT_SIZE
      
      const_set_lazy(:CHECKSUM_DELEG_LGTH_SIZE) { 2 }
      const_attr_reader  :CHECKSUM_DELEG_LGTH_SIZE
      
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
    
    attr_accessor :checksum_first_bytes
    alias_method :attr_checksum_first_bytes, :checksum_first_bytes
    undef_method :checksum_first_bytes
    alias_method :attr_checksum_first_bytes=, :checksum_first_bytes=
    undef_method :checksum_first_bytes=
    
    class_module.module_eval {
      const_set_lazy(:CHANNEL_BINDING_AF_INET) { 2 }
      const_attr_reader  :CHANNEL_BINDING_AF_INET
      
      const_set_lazy(:CHANNEL_BINDING_AF_INET6) { 24 }
      const_attr_reader  :CHANNEL_BINDING_AF_INET6
      
      const_set_lazy(:CHANNEL_BINDING_AF_NULL_ADDR) { 255 }
      const_attr_reader  :CHANNEL_BINDING_AF_NULL_ADDR
      
      const_set_lazy(:Inet4_ADDRSZ) { 4 }
      const_attr_reader  :Inet4_ADDRSZ
      
      const_set_lazy(:Inet6_ADDRSZ) { 16 }
      const_attr_reader  :Inet6_ADDRSZ
      
      const_set_lazy(:OverloadedChecksum) { Class.new do
        extend LocalClass
        include_class_members InitialToken
        
        attr_accessor :checksum_bytes
        alias_method :attr_checksum_bytes, :checksum_bytes
        undef_method :checksum_bytes
        alias_method :attr_checksum_bytes=, :checksum_bytes=
        undef_method :checksum_bytes=
        
        attr_accessor :deleg_creds
        alias_method :attr_deleg_creds, :deleg_creds
        undef_method :deleg_creds
        alias_method :attr_deleg_creds=, :deleg_creds=
        undef_method :deleg_creds=
        
        attr_accessor :flags
        alias_method :attr_flags, :flags
        undef_method :flags
        alias_method :attr_flags=, :flags=
        undef_method :flags=
        
        typesig { [class_self::Krb5Context, class_self::Credentials, class_self::Credentials] }
        # Called on the initiator side when creating the
        # InitSecContextToken.
        def initialize(context, tgt, service_ticket)
          @checksum_bytes = nil
          @deleg_creds = nil
          @flags = 0
          krb_cred_message = nil
          pos = 0
          size = CHECKSUM_LENGTH_SIZE + CHECKSUM_BINDINGS_SIZE + CHECKSUM_FLAGS_SIZE
          if (context.get_cred_deleg_state)
            if ((context.get_caller).equal?(GSSUtil::CALLER_HTTP_NEGOTIATE) && !service_ticket.get_flags[Krb5::TKT_OPTS_DELEGATE])
              # When the caller is HTTP/SPNEGO and OK-AS-DELEGATE
              # is not present in the service ticket, delegation
              # is disabled.
              context.set_cred_deleg_state(false)
            else
              if (!tgt.is_forwardable)
                # XXX log this resetting of delegation state
                context.set_cred_deleg_state(false)
              else
                krb_cred = nil
                cipher_helper = context.get_cipher_helper(service_ticket.get_session_key)
                if (use_null_key(cipher_helper))
                  krb_cred = self.class::KrbCred.new(tgt, service_ticket, EncryptionKey::NULL_KEY)
                else
                  krb_cred = self.class::KrbCred.new(tgt, service_ticket, service_ticket.get_session_key)
                end
                krb_cred_message = krb_cred.get_message
                size += CHECKSUM_DELEG_OPT_SIZE + CHECKSUM_DELEG_LGTH_SIZE + krb_cred_message.attr_length
              end
            end
          end
          @checksum_bytes = Array.typed(::Java::Byte).new(size) { 0 }
          @checksum_bytes[((pos += 1) - 1)] = CHECKSUM_FIRST_BYTES[0]
          @checksum_bytes[((pos += 1) - 1)] = CHECKSUM_FIRST_BYTES[1]
          @checksum_bytes[((pos += 1) - 1)] = CHECKSUM_FIRST_BYTES[2]
          @checksum_bytes[((pos += 1) - 1)] = CHECKSUM_FIRST_BYTES[3]
          local_bindings = context.get_channel_binding
          if (!(local_bindings).nil?)
            local_bindings_bytes = compute_channel_binding(context.get_channel_binding)
            System.arraycopy(local_bindings_bytes, 0, @checksum_bytes, pos, local_bindings_bytes.attr_length)
            # System.out.println("ChannelBinding hash: "
            # + getHexBytes(localBindingsBytes));
          end
          pos += CHECKSUM_BINDINGS_SIZE
          if (context.get_cred_deleg_state)
            @flags |= CHECKSUM_DELEG_FLAG
          end
          if (context.get_mutual_auth_state)
            @flags |= CHECKSUM_MUTUAL_FLAG
          end
          if (context.get_replay_det_state)
            @flags |= CHECKSUM_REPLAY_FLAG
          end
          if (context.get_sequence_det_state)
            @flags |= CHECKSUM_SEQUENCE_FLAG
          end
          if (context.get_integ_state)
            @flags |= CHECKSUM_INTEG_FLAG
          end
          if (context.get_conf_state)
            @flags |= CHECKSUM_CONF_FLAG
          end
          temp = Array.typed(::Java::Byte).new(4) { 0 }
          write_little_endian(@flags, temp)
          @checksum_bytes[((pos += 1) - 1)] = temp[0]
          @checksum_bytes[((pos += 1) - 1)] = temp[1]
          @checksum_bytes[((pos += 1) - 1)] = temp[2]
          @checksum_bytes[((pos += 1) - 1)] = temp[3]
          if (context.get_cred_deleg_state)
            delegate_to = service_ticket.get_server
            # Cannot use '\"' instead of "\"" in constructor because
            # it is interpreted as suggested length!
            buf = self.class::StringBuffer.new("\"")
            buf.append(delegate_to.get_name).append(Character.new(?\".ord))
            realm = delegate_to.get_realm_as_string
            buf.append(" \"krbtgt/").append(realm).append(Character.new(?@.ord))
            buf.append(realm).append(Character.new(?\".ord))
            sm = System.get_security_manager
            if (!(sm).nil?)
              perm = self.class::DelegationPermission.new(buf.to_s)
              sm.check_permission(perm)
            end
            # Write 1 in little endian but in two bytes
            # for DlgOpt
            @checksum_bytes[((pos += 1) - 1)] = 0x1
            @checksum_bytes[((pos += 1) - 1)] = 0x0
            # Write the length of the delegated credential in little
            # endian but in two bytes for Dlgth
            if (krb_cred_message.attr_length > 0xffff)
              raise self.class::GSSException.new(GSSException::FAILURE, -1, "Incorrect messsage length")
            end
            write_little_endian(krb_cred_message.attr_length, temp)
            @checksum_bytes[((pos += 1) - 1)] = temp[0]
            @checksum_bytes[((pos += 1) - 1)] = temp[1]
            System.arraycopy(krb_cred_message, 0, @checksum_bytes, pos, krb_cred_message.attr_length)
          end
        end
        
        typesig { [class_self::Krb5Context, class_self::Checksum, class_self::EncryptionKey] }
        # Called on the acceptor side when reading an InitSecContextToken.
        # 
        # XXX Passing in Checksum is not required. byte[] can
        # be passed in if this checksum type denotes a
        # raw_checksum. In that case, make Checksum class krb5
        # internal.
        def initialize(context, checksum, key)
          @checksum_bytes = nil
          @deleg_creds = nil
          @flags = 0
          pos = 0
          @checksum_bytes = checksum.get_bytes
          if ((!(@checksum_bytes[0]).equal?(CHECKSUM_FIRST_BYTES[0])) || (!(@checksum_bytes[1]).equal?(CHECKSUM_FIRST_BYTES[1])) || (!(@checksum_bytes[2]).equal?(CHECKSUM_FIRST_BYTES[2])) || (!(@checksum_bytes[3]).equal?(CHECKSUM_FIRST_BYTES[3])))
            raise self.class::GSSException.new(GSSException::FAILURE, -1, "Incorrect checksum")
          end
          remote_binding_bytes = Array.typed(::Java::Byte).new(CHECKSUM_BINDINGS_SIZE) { 0 }
          System.arraycopy(@checksum_bytes, 4, remote_binding_bytes, 0, CHECKSUM_BINDINGS_SIZE)
          no_bindings = Array.typed(::Java::Byte).new(CHECKSUM_BINDINGS_SIZE) { 0 }
          token_contains_bindings = (!(Java::Util::Arrays == no_bindings))
          local_bindings = context.get_channel_binding
          if (token_contains_bindings || !(local_bindings).nil?)
            bad_bindings = false
            error_message = nil
            if (token_contains_bindings && !(local_bindings).nil?)
              local_bindings_bytes = compute_channel_binding(local_bindings)
              # System.out.println("ChannelBinding hash: "
              # + getHexBytes(localBindingsBytes));
              bad_bindings = (!(Java::Util::Arrays == local_bindings_bytes))
              error_message = "Bytes mismatch!"
            else
              if ((local_bindings).nil?)
                error_message = "ChannelBinding not provided!"
                bad_bindings = true
              else
                error_message = "Token missing ChannelBinding!"
                bad_bindings = true
              end
            end
            if (bad_bindings)
              raise self.class::GSSException.new(GSSException::BAD_BINDINGS, -1, error_message)
            end
          end
          @flags = read_little_endian(@checksum_bytes, 20, 4)
          if ((@flags & CHECKSUM_DELEG_FLAG) > 0)
            # XXX
            # if ((checksumBytes[24] != (byte)0x01) &&
            # (checksumBytes[25] != (byte)0x00))
            cred_len = read_little_endian(@checksum_bytes, 26, 2)
            cred_bytes = Array.typed(::Java::Byte).new(cred_len) { 0 }
            System.arraycopy(@checksum_bytes, 28, cred_bytes, 0, cred_len)
            cipher_helper = context.get_cipher_helper(key)
            if (use_null_key(cipher_helper))
              @deleg_creds = self.class::KrbCred.new(cred_bytes, EncryptionKey::NULL_KEY).get_delegated_creds[0]
            else
              @deleg_creds = self.class::KrbCred.new(cred_bytes, key).get_delegated_creds[0]
            end
          end
        end
        
        typesig { [class_self::CipherHelper] }
        # check if KRB-CRED message should use NULL_KEY for encryption
        def use_null_key(ch)
          flag = true
          # for "newer" etypes and RC4-HMAC do not use NULL KEY
          if (((ch.get_proto).equal?(1)) || ch.is_arc_four)
            flag = false
          end
          return flag
        end
        
        typesig { [] }
        def get_checksum
          return self.class::Checksum.new(@checksum_bytes, CHECKSUM_TYPE)
        end
        
        typesig { [] }
        def get_delegated_creds
          return @deleg_creds
        end
        
        typesig { [class_self::Krb5Context] }
        def set_context_flags(context)
          # default for cred delegation is false
          if ((@flags & CHECKSUM_DELEG_FLAG) > 0)
            context.set_cred_deleg_state(true)
          end
          # default for the following are true
          if (((@flags & CHECKSUM_MUTUAL_FLAG)).equal?(0))
            context.set_mutual_auth_state(false)
          end
          if (((@flags & CHECKSUM_REPLAY_FLAG)).equal?(0))
            context.set_replay_det_state(false)
          end
          if (((@flags & CHECKSUM_SEQUENCE_FLAG)).equal?(0))
            context.set_sequence_det_state(false)
          end
          if (((@flags & CHECKSUM_CONF_FLAG)).equal?(0))
            context.set_conf_state(false)
          end
          if (((@flags & CHECKSUM_INTEG_FLAG)).equal?(0))
            context.set_integ_state(false)
          end
        end
        
        private
        alias_method :initialize__overloaded_checksum, :initialize
      end }
    }
    
    typesig { [InetAddress] }
    def get_addr_type(addr)
      address_type = CHANNEL_BINDING_AF_NULL_ADDR
      if (addr.is_a?(Inet4Address))
        address_type = CHANNEL_BINDING_AF_INET
      else
        if (addr.is_a?(Inet6Address))
          address_type = CHANNEL_BINDING_AF_INET6
        end
      end
      return (address_type)
    end
    
    typesig { [InetAddress] }
    def get_addr_bytes(addr)
      address_type = get_addr_type(addr)
      address_bytes = addr.get_address
      if (!(address_bytes).nil?)
        case (address_type)
        when CHANNEL_BINDING_AF_INET
          if (!(address_bytes.attr_length).equal?(Inet4_ADDRSZ))
            raise GSSException.new(GSSException::FAILURE, -1, "Incorrect AF-INET address length in ChannelBinding.")
          end
          return (address_bytes)
        when CHANNEL_BINDING_AF_INET6
          if (!(address_bytes.attr_length).equal?(Inet6_ADDRSZ))
            raise GSSException.new(GSSException::FAILURE, -1, "Incorrect AF-INET6 address length in ChannelBinding.")
          end
          return (address_bytes)
        else
          raise GSSException.new(GSSException::FAILURE, -1, "Cannot handle non AF-INET addresses in ChannelBinding.")
        end
      end
      return nil
    end
    
    typesig { [ChannelBinding] }
    def compute_channel_binding(channel_binding)
      initiator_address = channel_binding.get_initiator_address
      acceptor_address = channel_binding.get_acceptor_address
      size = 5 * 4
      initiator_address_type = get_addr_type(initiator_address)
      acceptor_address_type = get_addr_type(acceptor_address)
      initiator_address_bytes = nil
      if (!(initiator_address).nil?)
        initiator_address_bytes = get_addr_bytes(initiator_address)
        size += initiator_address_bytes.attr_length
      end
      acceptor_address_bytes = nil
      if (!(acceptor_address).nil?)
        acceptor_address_bytes = get_addr_bytes(acceptor_address)
        size += acceptor_address_bytes.attr_length
      end
      app_data_bytes = channel_binding.get_application_data
      if (!(app_data_bytes).nil?)
        size += app_data_bytes.attr_length
      end
      data = Array.typed(::Java::Byte).new(size) { 0 }
      pos = 0
      write_little_endian(initiator_address_type, data, pos)
      pos += 4
      if (!(initiator_address_bytes).nil?)
        write_little_endian(initiator_address_bytes.attr_length, data, pos)
        pos += 4
        System.arraycopy(initiator_address_bytes, 0, data, pos, initiator_address_bytes.attr_length)
        pos += initiator_address_bytes.attr_length
      else
        # Write length 0
        pos += 4
      end
      write_little_endian(acceptor_address_type, data, pos)
      pos += 4
      if (!(acceptor_address_bytes).nil?)
        write_little_endian(acceptor_address_bytes.attr_length, data, pos)
        pos += 4
        System.arraycopy(acceptor_address_bytes, 0, data, pos, acceptor_address_bytes.attr_length)
        pos += acceptor_address_bytes.attr_length
      else
        # Write length 0
        pos += 4
      end
      if (!(app_data_bytes).nil?)
        write_little_endian(app_data_bytes.attr_length, data, pos)
        pos += 4
        System.arraycopy(app_data_bytes, 0, data, pos, app_data_bytes.attr_length)
        pos += app_data_bytes.attr_length
      else
        # Write 0
        pos += 4
      end
      begin
        md5 = MessageDigest.get_instance("MD5")
        return md5.digest(data)
      rescue NoSuchAlgorithmException => e
        raise GSSException.new(GSSException::FAILURE, -1, "Could not get MD5 Message Digest - " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [] }
    def encode
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
      @checksum_first_bytes = nil
      super()
      @checksum_first_bytes = Array.typed(::Java::Byte).new([0x10, 0x0, 0x0, 0x0])
    end
    
    private
    alias_method :initialize__initial_token, :initialize
  end
  
end
