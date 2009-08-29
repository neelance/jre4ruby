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
  module AcceptSecContextTokenImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayInputStream
      include ::Sun::Security::Krb5
    }
  end
  
  class AcceptSecContextToken < AcceptSecContextTokenImports.const_get :InitialToken
    include_class_members AcceptSecContextTokenImports
    
    attr_accessor :ap_rep
    alias_method :attr_ap_rep, :ap_rep
    undef_method :ap_rep
    alias_method :attr_ap_rep=, :ap_rep=
    undef_method :ap_rep=
    
    typesig { [Krb5Context, KrbApReq] }
    # Creates an AcceptSecContextToken for the context acceptor to send to
    # the context initiator.
    def initialize(context, ap_req)
      @ap_rep = nil
      super()
      @ap_rep = nil
      # RFC 1964, section 1.2 states:
      # (1) context key: uses Kerberos session key (or subkey, if
      # present in authenticator emitted by context initiator) directly
      # 
      # This does not mention context acceptor. Hence we will not
      # generate a subkey on the acceptor side. Note: Our initiator will
      # still allow another acceptor to generate a subkey, even though
      # our acceptor does not do so.
      use_subkey = false
      use_sequence_number = true
      @ap_rep = KrbApRep.new(ap_req, use_sequence_number, use_subkey)
      context.reset_my_sequence_number(@ap_rep.get_seq_number.int_value)
      # Note: The acceptor side context key was set when the
      # InitSecContextToken was received.
    end
    
    typesig { [Krb5Context, Credentials, KrbApReq, InputStream] }
    # Creates an AcceptSecContextToken at the context initiator's side
    # using the bytes received from  the acceptor.
    def initialize(context, service_creds, ap_req, is)
      @ap_rep = nil
      super()
      @ap_rep = nil
      token_id = ((is.read << 8) | is.read)
      if (!(token_id).equal?(Krb5Token::AP_REP_ID))
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "AP_REP token id does not match!")
      end
      ap_rep_bytes = Sun::Security::Util::DerValue.new(is).to_byte_array
      ap_rep = KrbApRep.new(ap_rep_bytes, service_creds, ap_req)
      # Allow the context acceptor to set a subkey if desired, even
      # though our context acceptor will not do so.
      sub_key = ap_rep.get_sub_key
      if (!(sub_key).nil?)
        context.set_key(sub_key)
        # System.out.println("\n\nSub-Session key from AP-REP is: " +
        # getHexBytes(subKey.getBytes()) + "\n");
      end
      ap_rep_seq_number = ap_rep.get_seq_number
      peer_seq_number = (!(ap_rep_seq_number).nil? ? ap_rep_seq_number.int_value : 0)
      context.reset_peer_sequence_number(peer_seq_number)
    end
    
    typesig { [] }
    def encode
      ap_rep_bytes = @ap_rep.get_message
      ret_val = Array.typed(::Java::Byte).new(2 + ap_rep_bytes.attr_length) { 0 }
      write_int(Krb5Token::AP_REP_ID, ret_val, 0)
      System.arraycopy(ap_rep_bytes, 0, ret_val, 2, ap_rep_bytes.attr_length)
      return ret_val
    end
    
    private
    alias_method :initialize__accept_sec_context_token, :initialize
  end
  
end
