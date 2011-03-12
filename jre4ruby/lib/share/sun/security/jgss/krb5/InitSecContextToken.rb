require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module InitSecContextTokenImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Krb5
      include_const ::Java::Net, :InetAddress
    }
  end
  
  class InitSecContextToken < InitSecContextTokenImports.const_get :InitialToken
    include_class_members InitSecContextTokenImports
    
    attr_accessor :ap_req
    alias_method :attr_ap_req, :ap_req
    undef_method :ap_req
    alias_method :attr_ap_req=, :ap_req=
    undef_method :ap_req=
    
    typesig { [Krb5Context, Credentials, Credentials] }
    # For the context initiator to call. It constructs a new
    # InitSecContextToken to send over to the peer containing the desired
    # flags and the AP-REQ. It also updates the context with the local
    # sequence number and shared context key.
    # (When mutual auth is enabled the peer has an opportunity to
    # renegotiate the session key in the followup AcceptSecContextToken
    # that it sends.)
    def initialize(context, tgt, service_ticket)
      @ap_req = nil
      super()
      @ap_req = nil
      mutual_required = context.get_mutual_auth_state
      use_subkey = true # MIT Impl will crash if this is not set!
      use_sequence_number = true
      gss_checksum = OverloadedChecksum.new(context, tgt, service_ticket)
      checksum = gss_checksum.get_checksum
      @ap_req = KrbApReq.new(service_ticket, mutual_required, use_subkey, use_sequence_number, checksum)
      context.reset_my_sequence_number(@ap_req.get_seq_number.int_value)
      sub_key = @ap_req.get_sub_key
      if (!(sub_key).nil?)
        context.set_key(sub_key)
      else
        context.set_key(service_ticket.get_session_key)
      end
      if (!mutual_required)
        context.reset_peer_sequence_number(0)
      end
    end
    
    typesig { [Krb5Context, Array.typed(EncryptionKey), InputStream] }
    # For the context acceptor to call. It reads the bytes out of an
    # InputStream and constructs an InitSecContextToken with them.
    def initialize(context, keys, is)
      @ap_req = nil
      super()
      @ap_req = nil
      token_id = ((is.read << 8) | is.read)
      if (!(token_id).equal?(Krb5Token::AP_REQ_ID))
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "AP_REQ token id does not match!")
      end
      # XXX Modify KrbApReq cons to take an InputStream
      ap_req_bytes = Sun::Security::Util::DerValue.new(is).to_byte_array
      # debug("=====ApReqBytes: [" + getHexBytes(apReqBytes) + "]\n");
      addr = nil
      if (!(context.get_channel_binding).nil?)
        addr = context.get_channel_binding.get_initiator_address
      end
      @ap_req = KrbApReq.new(ap_req_bytes, keys, addr)
      # debug("\nReceived AP-REQ and authenticated it.\n");
      session_key = @ap_req.get_creds.get_session_key
      # System.out.println("\n\nSession key from service ticket is: " +
      # getHexBytes(sessionKey.getBytes()));
      sub_key = @ap_req.get_sub_key
      if (!(sub_key).nil?)
        context.set_key(sub_key)
        # System.out.println("Sub-Session key from authenticator is: " +
        # getHexBytes(subKey.getBytes()) + "\n");
      else
        context.set_key(session_key)
        # System.out.println("Sub-Session Key Missing in Authenticator.\n");
      end
      gss_checksum = OverloadedChecksum.new(context, @ap_req.get_checksum, session_key)
      gss_checksum.set_context_flags(context)
      deleg_cred = gss_checksum.get_delegated_creds
      if (!(deleg_cred).nil?)
        cred_element = Krb5InitCredential.get_instance(context.get_src_name, deleg_cred)
        context.set_deleg_cred(cred_element)
      end
      ap_req_seq_number = @ap_req.get_seq_number
      peer_seq_number = (!(ap_req_seq_number).nil? ? ap_req_seq_number.int_value : 0)
      context.reset_peer_sequence_number(peer_seq_number)
      if (!context.get_mutual_auth_state)
        # Use the same sequence number as the peer
        # (Behaviour exhibited by the Windows SSPI server)
        context.reset_my_sequence_number(peer_seq_number)
      end
    end
    
    typesig { [] }
    def get_krb_ap_req
      return @ap_req
    end
    
    typesig { [] }
    def encode
      ap_req_bytes = @ap_req.get_message
      ret_val = Array.typed(::Java::Byte).new(2 + ap_req_bytes.attr_length) { 0 }
      write_int(Krb5Token::AP_REQ_ID, ret_val, 0)
      System.arraycopy(ap_req_bytes, 0, ret_val, 2, ap_req_bytes.attr_length)
      #      System.out.println("GSS-Token with AP_REQ is:");
      #      System.out.println(getHexBytes(retVal));
      return ret_val
    end
    
    private
    alias_method :initialize__init_sec_context_token, :initialize
  end
  
end
