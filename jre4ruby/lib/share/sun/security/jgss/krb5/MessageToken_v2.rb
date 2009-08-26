require "rjava"

# Copyright 2004-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MessageToken_v2Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss
      include ::Sun::Security::Krb5
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :MessageDigest
    }
  end
  
  # end of class MessageTokenHeader
  # 
  # This class is a base class for new GSS token definitions, as defined
  # in draft-ietf-krb-wg-gssapi-cfx-07.txt, that pertain to per-message
  # GSS-API calls. Conceptually GSS-API has two types of per-message tokens:
  # WrapToken and MicToken. They differ in the respect that a WrapToken
  # carries additional plaintext or ciphertext application data besides
  # just the sequence number and checksum. This class encapsulates the
  # commonality in the structure of the WrapToken and the MicToken.
  # This structure can be represented as:
  # <p>
  # <pre>
  # Wrap Tokens
  # 
  # Octet no   Name        Description
  # ---------------------------------------------------------------
  # 0..1     TOK_ID     Identification field.  Tokens emitted by
  # GSS_Wrap() contain the the hex value 05 04
  # expressed in big endian order in this field.
  # 2        Flags      Attributes field, as described in section
  # 4.2.2.
  # 3        Filler     Contains the hex value FF.
  # 4..5     EC         Contains the "extra count" field, in big
  # endian order as described in section 4.2.3.
  # 6..7     RRC        Contains the "right rotation count" in big
  # endian order, as described in section 4.2.5.
  # 8..15    SND_SEQ    Sequence number field in clear text,
  # expressed in big endian order.
  # 16..last Data       Encrypted data for Wrap tokens with
  # confidentiality, or plaintext data followed
  # by the checksum for Wrap tokens without
  # confidentiality, as described in section
  # 4.2.4.
  # MIC Tokens
  # 
  # Octet no   Name        Description
  # -----------------------------------------------------------------
  # 0..1     TOK_ID     Identification field.  Tokens emitted by
  # GSS_GetMIC() contain the hex value 04 04
  # expressed in big endian order in this field.
  # 2        Flags      Attributes field, as described in section
  # 4.2.2.
  # 3..7     Filler     Contains five octets of hex value FF.
  # 8..15    SND_SEQ    Sequence number field in clear text,
  # expressed in big endian order.
  # 16..last SGN_CKSUM  Checksum of the "to-be-signed" data and
  # octet 0..15, as described in section 4.2.4.
  # 
  # </pre>
  # <p>
  # 
  # @author Seema Malkani
  class MessageToken_v2 < MessageToken_v2Imports.const_get :Krb5Token
    include_class_members MessageToken_v2Imports
    
    class_module.module_eval {
      const_set_lazy(:TOKEN_ID_POS) { 0 }
      const_attr_reader  :TOKEN_ID_POS
      
      const_set_lazy(:TOKEN_FLAG_POS) { 2 }
      const_attr_reader  :TOKEN_FLAG_POS
      
      const_set_lazy(:TOKEN_EC_POS) { 4 }
      const_attr_reader  :TOKEN_EC_POS
      
      const_set_lazy(:TOKEN_RRC_POS) { 6 }
      const_attr_reader  :TOKEN_RRC_POS
      
      # token header size
      const_set_lazy(:TOKEN_HEADER_SIZE) { 16 }
      const_attr_reader  :TOKEN_HEADER_SIZE
    }
    
    attr_accessor :token_id
    alias_method :attr_token_id, :token_id
    undef_method :token_id
    alias_method :attr_token_id=, :token_id=
    undef_method :token_id=
    
    attr_accessor :seq_number
    alias_method :attr_seq_number, :seq_number
    undef_method :seq_number
    alias_method :attr_seq_number=, :seq_number=
    undef_method :seq_number=
    
    # EC and RRC fields
    attr_accessor :ec
    alias_method :attr_ec, :ec
    undef_method :ec
    alias_method :attr_ec=, :ec=
    undef_method :ec=
    
    attr_accessor :rrc
    alias_method :attr_rrc, :rrc
    undef_method :rrc
    alias_method :attr_rrc=, :rrc=
    undef_method :rrc=
    
    attr_accessor :conf_state
    alias_method :attr_conf_state, :conf_state
    undef_method :conf_state
    alias_method :attr_conf_state=, :conf_state=
    undef_method :conf_state=
    
    attr_accessor :initiator
    alias_method :attr_initiator, :initiator
    undef_method :initiator
    alias_method :attr_initiator=, :initiator=
    undef_method :initiator=
    
    attr_accessor :confounder
    alias_method :attr_confounder, :confounder
    undef_method :confounder
    alias_method :attr_confounder=, :confounder=
    undef_method :confounder=
    
    attr_accessor :checksum
    alias_method :attr_checksum, :checksum
    undef_method :checksum
    alias_method :attr_checksum=, :checksum=
    undef_method :checksum=
    
    attr_accessor :key_usage
    alias_method :attr_key_usage, :key_usage
    undef_method :key_usage
    alias_method :attr_key_usage=, :key_usage=
    undef_method :key_usage=
    
    attr_accessor :seq_number_data
    alias_method :attr_seq_number_data, :seq_number_data
    undef_method :seq_number_data
    alias_method :attr_seq_number_data=, :seq_number_data=
    undef_method :seq_number_data=
    
    attr_accessor :token_header
    alias_method :attr_token_header, :token_header
    undef_method :token_header
    alias_method :attr_token_header=, :token_header=
    undef_method :token_header=
    
    # cipher instance used by the corresponding GSSContext
    attr_accessor :cipher_helper
    alias_method :attr_cipher_helper, :cipher_helper
    undef_method :cipher_helper
    alias_method :attr_cipher_helper=, :cipher_helper=
    undef_method :cipher_helper=
    
    class_module.module_eval {
      # draft-ietf-krb-wg-gssapi-cfx-07
      const_set_lazy(:KG_USAGE_ACCEPTOR_SEAL) { 22 }
      const_attr_reader  :KG_USAGE_ACCEPTOR_SEAL
      
      const_set_lazy(:KG_USAGE_ACCEPTOR_SIGN) { 23 }
      const_attr_reader  :KG_USAGE_ACCEPTOR_SIGN
      
      const_set_lazy(:KG_USAGE_INITIATOR_SEAL) { 24 }
      const_attr_reader  :KG_USAGE_INITIATOR_SEAL
      
      const_set_lazy(:KG_USAGE_INITIATOR_SIGN) { 25 }
      const_attr_reader  :KG_USAGE_INITIATOR_SIGN
      
      # draft-ietf-krb-wg-gssapi-cfx-07
      const_set_lazy(:FLAG_SENDER_IS_ACCEPTOR) { 1 }
      const_attr_reader  :FLAG_SENDER_IS_ACCEPTOR
      
      const_set_lazy(:FLAG_WRAP_CONFIDENTIAL) { 2 }
      const_attr_reader  :FLAG_WRAP_CONFIDENTIAL
      
      const_set_lazy(:FLAG_ACCEPTOR_SUBKEY) { 4 }
      const_attr_reader  :FLAG_ACCEPTOR_SUBKEY
      
      const_set_lazy(:FILLER) { 0xff }
      const_attr_reader  :FILLER
    }
    
    typesig { [::Java::Int, Krb5Context, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    # Constructs a MessageToken from a byte array. If there are more bytes
    # in the array than needed, the extra bytes are simply ignroed.
    # 
    # @param tokenId the token id that should be contained in this token as
    # it is read.
    # @param context the Kerberos context associated with this token
    # @param tokenBytes the byte array containing the token
    # @param tokenOffset the offset where the token begins
    # @param tokenLen the length of the token
    # @param prop the MessageProp structure in which the properties of the
    # token should be stored.
    # @throws GSSException if there is a problem parsing the token
    def initialize(token_id, context, token_bytes, token_offset, token_len, prop)
      initialize__message_token_v2(token_id, context, ByteArrayInputStream.new(token_bytes, token_offset, token_len), prop)
    end
    
    typesig { [::Java::Int, Krb5Context, InputStream, MessageProp] }
    # Constructs a MessageToken from an InputStream. Bytes will be read on
    # demand and the thread might block if there are not enough bytes to
    # complete the token.
    # 
    # @param tokenId the token id that should be contained in this token as
    # it is read.
    # @param context the Kerberos context associated with this token
    # @param is the InputStream from which to read
    # @param prop the MessageProp structure in which the properties of the
    # token should be stored.
    # @throws GSSException if there is a problem reading from the
    # InputStream or parsing the token
    def initialize(token_id, context, is, prop)
      @token_id = 0
      @seq_number = 0
      @ec = 0
      @rrc = 0
      @conf_state = false
      @initiator = false
      @confounder = nil
      @checksum = nil
      @key_usage = 0
      @seq_number_data = nil
      @token_header = nil
      @cipher_helper = nil
      super()
      @token_id = 0
      @ec = 0
      @rrc = 0
      @conf_state = true
      @initiator = true
      @confounder = nil
      @checksum = nil
      @key_usage = 0
      @seq_number_data = nil
      @token_header = nil
      @cipher_helper = nil
      init(token_id, context)
      begin
        if (!@conf_state)
          prop.set_privacy(false)
        end
        @token_header = MessageTokenHeader.new_local(self, is, prop, token_id)
        # set key_usage
        if ((token_id).equal?(Krb5Token::WRAP_ID_v2))
          @key_usage = (!@initiator ? KG_USAGE_INITIATOR_SEAL : KG_USAGE_ACCEPTOR_SEAL)
        else
          if ((token_id).equal?(Krb5Token::MIC_ID_v2))
            @key_usage = (!@initiator ? KG_USAGE_INITIATOR_SIGN : KG_USAGE_ACCEPTOR_SIGN)
          end
        end
        # Read checksum
        token_len = is.available
        data = Array.typed(::Java::Byte).new(token_len) { 0 }
        read_fully(is, data)
        @checksum = Array.typed(::Java::Byte).new(@cipher_helper.get_checksum_length) { 0 }
        System.arraycopy(data, token_len - @cipher_helper.get_checksum_length, @checksum, 0, @cipher_helper.get_checksum_length)
        # debug("\nLeaving MessageToken.Cons\n");
        # validate EC for Wrap tokens without confidentiality
        if (!prop.get_privacy && ((token_id).equal?(Krb5Token::WRAP_ID_v2)))
          if (!(@checksum.attr_length).equal?(@ec))
            raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(token_id)) + ":" + "EC incorrect!")
          end
        end
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(token_id)) + ":" + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [] }
    # Used to obtain the token id that was contained in this token.
    # @return the token id in the token
    def get_token_id
      return @token_id
    end
    
    typesig { [] }
    # Used to obtain the key_usage type for this token.
    # @return the key_usage for the token
    def get_key_usage
      return @key_usage
    end
    
    typesig { [] }
    # Used to determine if this token contains any encrypted data.
    # @return true if it contains any encrypted data, false if there is only
    # plaintext data or if there is no data.
    def get_conf_state
      return @conf_state
    end
    
    typesig { [MessageProp, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Generates the checksum field and the sequence number field.
    # 
    # @param prop the MessageProp structure
    # @param data the application data to checksum
    # @param offset the offset where the data starts
    # @param len the length of the data
    # 
    # @throws GSSException if an error occurs in the checksum calculation or
    # sequence number calculation.
    def gen_sign_and_seq_number(prop, data, offset, len)
      # debug("Inside MessageToken.genSignAndSeqNumber:\n");
      qop = prop.get_qop
      if (!(qop).equal?(0))
        qop = 0
        prop.set_qop(qop)
      end
      if (!@conf_state)
        prop.set_privacy(false)
      end
      # Create a new gss token header as defined in
      # draft-ietf-krb-wg-gssapi-cfx-07
      @token_header = MessageTokenHeader.new_local(self, @token_id, prop.get_privacy, true)
      # debug("\n\t Message Header = " +
      # getHexBytes(tokenHeader.getBytes(), tokenHeader.getBytes().length));
      # set key_usage
      if ((@token_id).equal?(Krb5Token::WRAP_ID_v2))
        @key_usage = (@initiator ? KG_USAGE_INITIATOR_SEAL : KG_USAGE_ACCEPTOR_SEAL)
      else
        if ((@token_id).equal?(Krb5Token::MIC_ID_v2))
          @key_usage = (@initiator ? KG_USAGE_INITIATOR_SIGN : KG_USAGE_ACCEPTOR_SIGN)
        end
      end
      # Calculate SGN_CKSUM
      if (((@token_id).equal?(MIC_ID_v2)) || (!prop.get_privacy && ((@token_id).equal?(WRAP_ID_v2))))
        @checksum = get_checksum(data, offset, len)
        # debug("\n\tCalc checksum=" +
        # getHexBytes(checksum, checksum.length));
      end
      # In Wrap tokens without confidentiality, the EC field SHALL be used
      # to encode the number of octets in the trailing checksum
      if (!prop.get_privacy && ((@token_id).equal?(WRAP_ID_v2)))
        tok_header = @token_header.get_bytes
        tok_header[4] = (@checksum.attr_length >> 8)
        tok_header[5] = (@checksum.attr_length)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Verifies the validity of checksum field
    # 
    # @param data the application data
    # @param offset the offset where the data begins
    # @param len the length of the application data
    # 
    # @throws GSSException if an error occurs in the checksum calculation
    def verify_sign(data, offset, len)
      # debug("\t====In verifySign:====\n");
      # debug("\t\t checksum:   [" + getHexBytes(checksum) + "]\n");
      # debug("\t\t data = [" + getHexBytes(data) + "]\n");
      my_checksum = get_checksum(data, offset, len)
      # debug("\t\t mychecksum: [" + getHexBytes(myChecksum) +"]\n");
      if (MessageDigest.is_equal(@checksum, my_checksum))
        # debug("\t\t====Checksum PASS:====\n");
        return true
      end
      return false
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # Rotate bytes as per the "RRC" (Right Rotation Count) received.
    # Our implementation does not do any rotates when sending, only
    # when receiving, we rotate left as per the RRC count, to revert it.
    # 
    # @return true if bytes are rotated
    def rotate_left(in_bytes, token_offset, out_bytes, bufsize)
      offset = 0
      # debug("\nRotate left: (before rotation) in_bytes = [ " +
      # getHexBytes(in_bytes, tokenOffset, bufsize) + "]");
      if (@rrc > 0)
        if ((bufsize).equal?(0))
          return false
        end
        @rrc = @rrc % (bufsize - TOKEN_HEADER_SIZE)
        if ((@rrc).equal?(0))
          return false
        end
        # if offset is not zero
        if (token_offset > 0)
          offset += token_offset
        end
        # copy the header
        System.arraycopy(in_bytes, offset, out_bytes, 0, TOKEN_HEADER_SIZE)
        offset += TOKEN_HEADER_SIZE
        # copy rest of the bytes
        System.arraycopy(in_bytes, offset + @rrc, out_bytes, TOKEN_HEADER_SIZE, bufsize - TOKEN_HEADER_SIZE - @rrc)
        # copy the bytes specified by rrc count
        System.arraycopy(in_bytes, offset, out_bytes, bufsize - TOKEN_HEADER_SIZE - @rrc, @rrc)
        # debug("\nRotate left: (after rotation) out_bytes = [ " +
        # getHexBytes(out_bytes, 0, bufsize) + "]");
        return true
      end
      return false
    end
    
    typesig { [] }
    def get_sequence_number
      return (read_big_endian(@seq_number_data, 0, 4))
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Computes the checksum based on the algorithm stored in the
    # tokenHeader.
    # 
    # @param data the application data
    # @param offset the offset where the data begins
    # @param len the length of the application data
    # 
    # @throws GSSException if an error occurs in the checksum calculation.
    def get_checksum(data, offset, len)
      # debug("Will do getChecksum:\n");
      # 
      # For checksum calculation the token header bytes i.e., the first 16
      # bytes following the GSSHeader, are logically prepended to the
      # application data to bind the data to this particular token.
      # 
      # Note: There is no such requirement wrt adding padding to the
      # application data for checksumming, although the cryptographic
      # algorithm used might itself apply some padding.
      token_header_bytes = @token_header.get_bytes
      # check confidentiality
      conf_flag = token_header_bytes[TOKEN_FLAG_POS] & FLAG_WRAP_CONFIDENTIAL
      # clear EC in token header for checksum calculation
      if (((conf_flag).equal?(0)) && ((@token_id).equal?(WRAP_ID_v2)))
        token_header_bytes[4] = 0
        token_header_bytes[5] = 0
      end
      return @cipher_helper.calculate_checksum(token_header_bytes, data, offset, len, @key_usage)
    end
    
    typesig { [::Java::Int, Krb5Context] }
    # Constructs an empty MessageToken for the local context to send to
    # the peer. It also increments the local sequence number in the
    # Krb5Context instance it uses after obtaining the object lock for
    # it.
    # 
    # @param tokenId the token id that should be contained in this token
    # @param context the Kerberos context associated with this token
    def initialize(token_id, context)
      @token_id = 0
      @seq_number = 0
      @ec = 0
      @rrc = 0
      @conf_state = false
      @initiator = false
      @confounder = nil
      @checksum = nil
      @key_usage = 0
      @seq_number_data = nil
      @token_header = nil
      @cipher_helper = nil
      super()
      @token_id = 0
      @ec = 0
      @rrc = 0
      @conf_state = true
      @initiator = true
      @confounder = nil
      @checksum = nil
      @key_usage = 0
      @seq_number_data = nil
      @token_header = nil
      @cipher_helper = nil
      # debug("\n============================");
      # debug("\nMySessionKey=" +
      # getHexBytes(context.getMySessionKey().getBytes()));
      # debug("\nPeerSessionKey=" +
      # getHexBytes(context.getPeerSessionKey().getBytes()));
      # debug("\n============================\n");
      init(token_id, context)
      @seq_number = context.increment_my_sequence_number
    end
    
    typesig { [::Java::Int, Krb5Context] }
    def init(token_id, context)
      @token_id = token_id
      # Just for consistency check in Wrap
      @conf_state = context.get_conf_state
      @initiator = context.is_initiator
      @cipher_helper = context.get_cipher_helper(nil)
      # debug("In MessageToken.Cons");
      # draft-ietf-krb-wg-gssapi-cfx-07
      @token_id = token_id
    end
    
    typesig { [OutputStream] }
    # Encodes a GSSHeader and this token onto an OutputStream.
    # 
    # @param os the OutputStream to which this should be written
    # @throws GSSException if an error occurs while writing to the OutputStream
    def encode(os)
      # debug("Writing tokenHeader " + getHexBytes(tokenHeader.getBytes());
      # (16 bytes of token header that includes sequence Number)
      @token_header.encode(os)
      # debug("Writing checksum: " + getHexBytes(checksum));
      if ((@token_id).equal?(MIC_ID_v2))
        os.write(@checksum)
      end
    end
    
    typesig { [] }
    # Obtains the size of this token. Note that this excludes the size of
    # the GSSHeader.
    # @return token size
    def get_krb5token_size
      return get_token_size
    end
    
    typesig { [] }
    def get_token_size
      return (TOKEN_HEADER_SIZE + @cipher_helper.get_checksum_length)
    end
    
    class_module.module_eval {
      typesig { [CipherHelper] }
      def get_token_size(ch)
        return (TOKEN_HEADER_SIZE + ch.get_checksum_length)
      end
    }
    
    typesig { [] }
    def get_token_header
      return (@token_header.get_bytes)
    end
    
    class_module.module_eval {
      # ******************************************* //
      # I N N E R    C L A S S E S    F O L L O W
      # ******************************************* //
      # 
      # This inner class represents the initial portion of the message token.
      # It constitutes the first 16 bytes of the message token:
      # <pre>
      # Wrap Tokens
      # 
      # Octet no   Name        Description
      # ---------------------------------------------------------------
      # 0..1     TOK_ID     Identification field.  Tokens emitted by
      # GSS_Wrap() contain the the hex value 05 04
      # expressed in big endian order in this field.
      # 2        Flags      Attributes field, as described in section
      # 4.2.2.
      # 3        Filler     Contains the hex value FF.
      # 4..5     EC         Contains the "extra count" field, in big
      # endian order as described in section 4.2.3.
      # 6..7     RRC        Contains the "right rotation count" in big
      # endian order, as described in section 4.2.5.
      # 8..15    SND_SEQ    Sequence number field in clear text,
      # expressed in big endian order.
      # 
      # MIC Tokens
      # 
      # Octet no   Name        Description
      # -----------------------------------------------------------------
      # 0..1     TOK_ID     Identification field.  Tokens emitted by
      # GSS_GetMIC() contain the hex value 04 04
      # expressed in big endian order in this field.
      # 2        Flags      Attributes field, as described in section
      # 4.2.2.
      # 3..7     Filler     Contains five octets of hex value FF.
      # 8..15    SND_SEQ    Sequence number field in clear text,
      # expressed in big endian order.
      # </pre>
      const_set_lazy(:MessageTokenHeader) { Class.new do
        extend LocalClass
        include_class_members MessageToken_v2
        
        attr_accessor :token_id
        alias_method :attr_token_id, :token_id
        undef_method :token_id
        alias_method :attr_token_id=, :token_id=
        undef_method :token_id=
        
        attr_accessor :bytes
        alias_method :attr_bytes, :bytes
        undef_method :bytes
        alias_method :attr_bytes=, :bytes=
        undef_method :bytes=
        
        typesig { [::Java::Int, ::Java::Boolean, ::Java::Boolean] }
        # new token header draft-ietf-krb-wg-gssapi-cfx-07
        def initialize(token_id, conf, have_acceptor_subkey)
          @token_id = 0
          @bytes = Array.typed(::Java::Byte).new(TOKEN_HEADER_SIZE) { 0 }
          @token_id = token_id
          @bytes[0] = (token_id >> 8)
          @bytes[1] = (token_id)
          # Flags (Note: MIT impl requires subkey)
          flags = 0
          flags = ((self.attr_initiator ? 0 : FLAG_SENDER_IS_ACCEPTOR) | ((conf && !(token_id).equal?(MIC_ID_v2)) ? FLAG_WRAP_CONFIDENTIAL : 0) | (have_acceptor_subkey ? FLAG_ACCEPTOR_SUBKEY : 0))
          @bytes[2] = flags
          # filler
          @bytes[3] = FILLER
          # EC and RRC fields
          if ((token_id).equal?(WRAP_ID_v2))
            # EC field
            @bytes[4] = 0
            @bytes[5] = 0
            # RRC field
            @bytes[6] = 0
            @bytes[7] = 0
          else
            if ((token_id).equal?(MIC_ID_v2))
              # octets of filler FF
              i = 4
              while i < 8
                @bytes[i] = FILLER
                i += 1
              end
            end
          end
          # Calculate SND_SEQ
          self.attr_seq_number_data = Array.typed(::Java::Byte).new(8) { 0 }
          write_big_endian(self.attr_seq_number, self.attr_seq_number_data, 4)
          System.arraycopy(self.attr_seq_number_data, 0, @bytes, 8, 8)
        end
        
        typesig { [self::InputStream, self::MessageProp, ::Java::Int] }
        # Constructs a MessageTokenHeader by reading it from an InputStream
        # and sets the appropriate confidentiality and quality of protection
        # values in a MessageProp structure.
        # 
        # @param is the InputStream to read from
        # @param prop the MessageProp to populate
        # @throws IOException is an error occurs while reading from the
        # InputStream
        def initialize(is, prop, tok_id)
          @token_id = 0
          @bytes = Array.typed(::Java::Byte).new(TOKEN_HEADER_SIZE) { 0 }
          read_fully(is, @bytes, 0, TOKEN_HEADER_SIZE)
          @token_id = read_int(@bytes, TOKEN_ID_POS)
          # Validate new GSS TokenHeader
          # 
          # valid acceptor_flag is set
          acceptor_flag = (self.attr_initiator ? FLAG_SENDER_IS_ACCEPTOR : 0)
          flag = @bytes[TOKEN_FLAG_POS] & FLAG_SENDER_IS_ACCEPTOR
          if (!((flag).equal?(acceptor_flag)))
            raise self.class::GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(@token_id)) + ":" + "Acceptor Flag Missing!")
          end
          # check for confidentiality
          conf_flag = @bytes[TOKEN_FLAG_POS] & FLAG_WRAP_CONFIDENTIAL
          if (((conf_flag).equal?(FLAG_WRAP_CONFIDENTIAL)) && ((@token_id).equal?(WRAP_ID_v2)))
            prop.set_privacy(true)
          else
            prop.set_privacy(false)
          end
          # validate Token ID
          if (!(@token_id).equal?(tok_id))
            raise self.class::GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(@token_id)) + ":" + "Defective Token ID!")
          end
          # validate filler
          if (!((@bytes[3] & 0xff)).equal?(FILLER))
            raise self.class::GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(@token_id)) + ":" + "Defective Token Filler!")
          end
          # validate next 4 bytes of filler for MIC tokens
          if ((@token_id).equal?(MIC_ID_v2))
            i = 4
            while i < 8
              if (!((@bytes[i] & 0xff)).equal?(FILLER))
                raise self.class::GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(@token_id)) + ":" + "Defective Token Filler!")
              end
              i += 1
            end
          end
          # read EC field
          self.attr_ec = read_big_endian(@bytes, TOKEN_EC_POS, 2)
          # read RRC field
          self.attr_rrc = read_big_endian(@bytes, TOKEN_RRC_POS, 2)
          # set default QOP
          prop.set_qop(0)
          # sequence number
          self.attr_seq_number_data = Array.typed(::Java::Byte).new(8) { 0 }
          System.arraycopy(@bytes, 8, self.attr_seq_number_data, 0, 8)
        end
        
        typesig { [self::OutputStream] }
        # Encodes this MessageTokenHeader onto an OutputStream
        # @param os the OutputStream to write to
        # @throws IOException is an error occurs while writing
        def encode(os)
          os.write(@bytes)
        end
        
        typesig { [] }
        # Returns the token id for the message token.
        # @return the token id
        # @see sun.security.jgss.krb5.Krb5Token#MIC_ID_v2
        # @see sun.security.jgss.krb5.Krb5Token#WRAP_ID_v2
        def get_token_id
          return @token_id
        end
        
        typesig { [] }
        # Returns the bytes of this header.
        # @return 8 bytes that form this header
        def get_bytes
          return @bytes
        end
        
        private
        alias_method :initialize__message_token_header, :initialize
      end }
    }
    
    private
    alias_method :initialize__message_token_v2, :initialize
  end
  
end
