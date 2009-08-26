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
  module MessageTokenImports
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
  
  # This class is a base class for other token definitions that pertain to
  # per-message GSS-API calls. Conceptually GSS-API has two types of
  # per-message tokens: WrapToken and MicToken. They differ in the respect
  # that a WrapToken carries additional plaintext or ciphertext application
  # data besides just the sequence number and checksum. This class
  # encapsulates the commonality in the structure of the WrapToken and the
  # MicToken. This structure can be represented as:
  # <p>
  # <pre>
  # 0..1           TOK_ID          Identification field.
  # 01 01 - Mic token
  # 02 01 - Wrap token
  # 2..3           SGN_ALG         Checksum algorithm indicator.
  # 00 00 - DES MAC MD5
  # 01 00 - MD2.5
  # 02 00 - DES MAC
  # 04 00 - HMAC SHA1 DES3-KD
  # 11 00 - RC4-HMAC
  # 4..5           SEAL_ALG        ff ff - none
  # 00 00 - DES
  # 02 00 - DES3-KD
  # 10 00 - RC4-HMAC
  # 6..7           Filler          Contains ff ff
  # 8..15          SND_SEQ         Encrypted sequence number field.
  # 16..s+15       SGN_CKSUM       Checksum of plaintext padded data,
  # calculated according to algorithm
  # specified in SGN_ALG field.
  # s+16..last     Data            encrypted or plaintext padded data
  # </pre>
  # Where "s" indicates the size of the checksum.
  # <p>
  # As always, this is preceeded by a GSSHeader.
  # 
  # @author Mayank Upadhyay
  # @author Ram Marti
  # @see sun.security.jgss.GSSHeader
  class MessageToken < MessageTokenImports.const_get :Krb5Token
    include_class_members MessageTokenImports
    
    class_module.module_eval {
      # Fields in header minus checksum size
      const_set_lazy(:TOKEN_NO_CKSUM_SIZE) { 16 }
      const_attr_reader  :TOKEN_NO_CKSUM_SIZE
      
      # Filler data as defined in the specification of the Kerberos v5 GSS-API
      # Mechanism.
      const_set_lazy(:FILLER) { 0xffff }
      const_attr_reader  :FILLER
      
      # Signing algorithm values (for the SNG_ALG field)
      # From RFC 1964
      # Use a DES MAC MD5 checksum
      const_set_lazy(:SGN_ALG_DES_MAC_MD5) { 0x0 }
      const_attr_reader  :SGN_ALG_DES_MAC_MD5
      
      # Use DES MAC checksum.
      const_set_lazy(:SGN_ALG_DES_MAC) { 0x200 }
      const_attr_reader  :SGN_ALG_DES_MAC
      
      # From draft-raeburn-cat-gssapi-krb5-3des-00
      # Use a HMAC SHA1 DES3 -KD checksum
      const_set_lazy(:SGN_ALG_HMAC_SHA1_DES3_KD) { 0x400 }
      const_attr_reader  :SGN_ALG_HMAC_SHA1_DES3_KD
      
      # Sealing algorithm values (for the SEAL_ALG field)
      # RFC 1964
      # 
      # A value for the SEAL_ALG field that indicates that no encryption was
      # used.
      const_set_lazy(:SEAL_ALG_NONE) { 0xffff }
      const_attr_reader  :SEAL_ALG_NONE
      
      # Use DES CBC encryption algorithm.
      const_set_lazy(:SEAL_ALG_DES) { 0x0 }
      const_attr_reader  :SEAL_ALG_DES
      
      # From draft-raeburn-cat-gssapi-krb5-3des-00
      # 
      # Use DES3-KD sealing algorithm. (draft-raeburn-cat-gssapi-krb5-3des-00)
      # This algorithm uses triple-DES with key derivation, with a usage
      # value KG_USAGE_SEAL.  Padding is still to 8-byte multiples, and the
      # IV for encrypting application data is zero.
      const_set_lazy(:SEAL_ALG_DES3_KD) { 0x200 }
      const_attr_reader  :SEAL_ALG_DES3_KD
      
      # draft draft-brezak-win2k-krb-rc4-hmac-04.txt
      const_set_lazy(:SEAL_ALG_ARCFOUR_HMAC) { 0x1000 }
      const_attr_reader  :SEAL_ALG_ARCFOUR_HMAC
      
      const_set_lazy(:SGN_ALG_HMAC_MD5_ARCFOUR) { 0x1100 }
      const_attr_reader  :SGN_ALG_HMAC_MD5_ARCFOUR
      
      const_set_lazy(:TOKEN_ID_POS) { 0 }
      const_attr_reader  :TOKEN_ID_POS
      
      const_set_lazy(:SIGN_ALG_POS) { 2 }
      const_attr_reader  :SIGN_ALG_POS
      
      const_set_lazy(:SEAL_ALG_POS) { 4 }
      const_attr_reader  :SEAL_ALG_POS
    }
    
    attr_accessor :seq_number
    alias_method :attr_seq_number, :seq_number
    undef_method :seq_number
    alias_method :attr_seq_number=, :seq_number=
    undef_method :seq_number=
    
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
    
    attr_accessor :token_id
    alias_method :attr_token_id, :token_id
    undef_method :token_id
    alias_method :attr_token_id=, :token_id=
    undef_method :token_id=
    
    attr_accessor :gss_header
    alias_method :attr_gss_header, :gss_header
    undef_method :gss_header
    alias_method :attr_gss_header=, :gss_header=
    undef_method :gss_header=
    
    attr_accessor :token_header
    alias_method :attr_token_header, :token_header
    undef_method :token_header
    alias_method :attr_token_header=, :token_header=
    undef_method :token_header=
    
    attr_accessor :checksum
    alias_method :attr_checksum, :checksum
    undef_method :checksum
    alias_method :attr_checksum=, :checksum=
    undef_method :checksum=
    
    attr_accessor :enc_seq_number
    alias_method :attr_enc_seq_number, :enc_seq_number
    undef_method :enc_seq_number
    alias_method :attr_enc_seq_number=, :enc_seq_number=
    undef_method :enc_seq_number=
    
    attr_accessor :seq_number_data
    alias_method :attr_seq_number_data, :seq_number_data
    undef_method :seq_number_data
    alias_method :attr_seq_number_data=, :seq_number_data=
    undef_method :seq_number_data=
    
    # cipher instance used by the corresponding GSSContext
    attr_accessor :cipher_helper
    alias_method :attr_cipher_helper, :cipher_helper
    undef_method :cipher_helper
    alias_method :attr_cipher_helper=, :cipher_helper=
    undef_method :cipher_helper=
    
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
      initialize__message_token(token_id, context, ByteArrayInputStream.new(token_bytes, token_offset, token_len), prop)
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
      @seq_number = 0
      @conf_state = false
      @initiator = false
      @token_id = 0
      @gss_header = nil
      @token_header = nil
      @checksum = nil
      @enc_seq_number = nil
      @seq_number_data = nil
      @cipher_helper = nil
      super()
      @conf_state = true
      @initiator = true
      @token_id = 0
      @gss_header = nil
      @token_header = nil
      @checksum = nil
      @enc_seq_number = nil
      @seq_number_data = nil
      @cipher_helper = nil
      init(token_id, context)
      begin
        @gss_header = GSSHeader.new(is)
        if (!(@gss_header.get_oid == OID))
          raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, get_token_name(token_id))
        end
        if (!@conf_state)
          prop.set_privacy(false)
        end
        @token_header = MessageTokenHeader.new_local(self, is, prop)
        @enc_seq_number = Array.typed(::Java::Byte).new(8) { 0 }
        read_fully(is, @enc_seq_number)
        # debug("\n\tRead EncSeq#=" +
        # getHexBytes(encSeqNumber, encSeqNumber.length));
        @checksum = Array.typed(::Java::Byte).new(@cipher_helper.get_checksum_length) { 0 }
        read_fully(is, @checksum)
        # debug("\n\tRead checksum=" +
        # getHexBytes(checksum, checksum.length));
        # debug("\nLeaving MessageToken.Cons\n");
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(token_id)) + ":" + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [] }
    # Used to obtain the GSSHeader that was at the start of this
    # token.
    def get_gssheader
      return @gss_header
    end
    
    typesig { [] }
    # Used to obtain the token id that was contained in this token.
    # @return the token id in the token
    def get_token_id
      return @token_id
    end
    
    typesig { [] }
    # Used to obtain the encrypted sequence number in this token.
    # @return the encrypted sequence number in the token
    def get_enc_seq_number
      return @enc_seq_number
    end
    
    typesig { [] }
    # Used to obtain the checksum that was contained in this token.
    # @return the checksum in the token
    def get_checksum
      return @checksum
    end
    
    typesig { [] }
    # Used to determine if this token contains any encrypted data.
    # @return true if it contains any encrypted data, false if there is only
    # plaintext data or if there is no data.
    def get_conf_state
      return @conf_state
    end
    
    typesig { [MessageProp, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
    # Generates the checksum field and the encrypted sequence number
    # field. The encrypted sequence number uses the 8 bytes of the checksum
    # as an initial vector in a fixed DesCbc algorithm.
    # 
    # @param prop the MessageProp structure that determines what sort of
    # checksum and sealing algorithm should be used. The lower byte
    # of qop determines the checksum algorithm while the upper byte
    # determines the signing algorithm.
    # Checksum values are:
    # 0 - default (DES_MAC)
    # 1 - MD5
    # 2 - DES_MD5
    # 3 - DES_MAC
    # 4 - HMAC_SHA1
    # Sealing values are:
    # 0 - default (DES)
    # 1 - DES
    # 2 - DES3-KD
    # 
    # @param optionalHeader an optional header that will be processed first
    # during  checksum calculation
    # 
    # @param data the application data to checksum
    # @param offset the offset where the data starts
    # @param len the length of the data
    # 
    # @param optionalTrailer an optional trailer that will be processed
    # last during checksum calculation. e.g., padding that should be
    # appended to the application data
    # 
    # @throws GSSException if an error occurs in the checksum calculation or
    # encryption sequence number calculation.
    def gen_sign_and_seq_number(prop, optional_header, data, offset, len, optional_trailer)
      # debug("Inside MessageToken.genSignAndSeqNumber:\n");
      qop = prop.get_qop
      if (!(qop).equal?(0))
        qop = 0
        prop.set_qop(qop)
      end
      if (!@conf_state)
        prop.set_privacy(false)
      end
      # Create a token header with the correct sign and seal algorithm
      # values.
      @token_header = MessageTokenHeader.new_local(self, @token_id, prop.get_privacy, qop)
      # Calculate SGN_CKSUM
      @checksum = get_checksum(optional_header, data, offset, len, optional_trailer)
      # debug("\n\tCalc checksum=" +
      # getHexBytes(checksum, checksum.length));
      # Calculate SND_SEQ
      @seq_number_data = Array.typed(::Java::Byte).new(8) { 0 }
      # When using this RC4 based encryption type, the sequence number is
      # always sent in big-endian rather than little-endian order.
      if (@cipher_helper.is_arc_four)
        write_big_endian(@seq_number, @seq_number_data)
      else
        # for all other etypes
        write_little_endian(@seq_number, @seq_number_data)
      end
      if (!@initiator)
        @seq_number_data[4] = 0xff
        @seq_number_data[5] = 0xff
        @seq_number_data[6] = 0xff
        @seq_number_data[7] = 0xff
      end
      @enc_seq_number = @cipher_helper.encrypt_seq(@checksum, @seq_number_data, 0, 8)
      # debug("\n\tCalc seqNum=" +
      # getHexBytes(seqNumberData, seqNumberData.length));
      # debug("\n\tCalc encSeqNum=" +
      # getHexBytes(encSeqNumber, encSeqNumber.length));
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
    # Verifies that the checksum field and sequence number direction bytes
    # are valid and consistent with the application data.
    # 
    # @param optionalHeader an optional header that will be processed first
    # during checksum calculation.
    # 
    # @param data the application data
    # @param offset the offset where the data begins
    # @param len the length of the application data
    # 
    # @param optionalTrailer an optional trailer that will be processed last
    # during checksum calculation. e.g., padding that should be appended to
    # the application data
    # 
    # @throws GSSException if an error occurs in the checksum calculation or
    # encryption sequence number calculation.
    def verify_sign_and_seq_number(optional_header, data, offset, len, optional_trailer)
      # debug("\tIn verifySign:\n");
      # debug("\t\tchecksum:   [" + getHexBytes(checksum) + "]\n");
      my_checksum = get_checksum(optional_header, data, offset, len, optional_trailer)
      # debug("\t\tmychecksum: [" + getHexBytes(myChecksum) +"]\n");
      # debug("\t\tchecksum:   [" + getHexBytes(checksum) + "]\n");
      if (MessageDigest.is_equal(@checksum, my_checksum))
        @seq_number_data = @cipher_helper.decrypt_seq(@checksum, @enc_seq_number, 0, 8)
        # debug("\t\tencSeqNumber:   [" + getHexBytes(encSeqNumber)
        # + "]\n");
        # debug("\t\tseqNumberData:   [" + getHexBytes(seqNumberData)
        # + "]\n");
        # 
        # The token from the initiator has direction bytes 0x00 and
        # the token from the acceptor has direction bytes 0xff.
        direction_byte = 0
        if (@initiator)
          direction_byte = 0xff
        end # Received token from acceptor
        if (((@seq_number_data[4]).equal?(direction_byte)) && ((@seq_number_data[5]).equal?(direction_byte)) && ((@seq_number_data[6]).equal?(direction_byte)) && ((@seq_number_data[7]).equal?(direction_byte)))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    def get_sequence_number
      sequence_num = 0
      if (@cipher_helper.is_arc_four)
        sequence_num = read_big_endian(@seq_number_data, 0, 4)
      else
        sequence_num = read_little_endian(@seq_number_data, 0, 4)
      end
      return sequence_num
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
    # Computes the checksum based on the algorithm stored in the
    # tokenHeader.
    # 
    # @param optionalHeader an optional header that will be processed first
    # during checksum calculation.
    # 
    # @param data the application data
    # @param offset the offset where the data begins
    # @param len the length of the application data
    # 
    # @param optionalTrailer an optional trailer that will be processed last
    # during checksum calculation. e.g., padding that should be appended to
    # the application data
    # 
    # @throws GSSException if an error occurs in the checksum calculation.
    def get_checksum(optional_header, data, offset, len, optional_trailer)
      # debug("Will do getChecksum:\n");
      # 
      # For checksum calculation the token header bytes i.e., the first 8
      # bytes following the GSSHeader, are logically prepended to the
      # application data to bind the data to this particular token.
      # 
      # Note: There is no such requirement wrt adding padding to the
      # application data for checksumming, although the cryptographic
      # algorithm used might itself apply some padding.
      token_header_bytes = @token_header.get_bytes
      existing_header = optional_header
      checksum_data_header = token_header_bytes
      if (!(existing_header).nil?)
        checksum_data_header = Array.typed(::Java::Byte).new(token_header_bytes.attr_length + existing_header.attr_length) { 0 }
        System.arraycopy(token_header_bytes, 0, checksum_data_header, 0, token_header_bytes.attr_length)
        System.arraycopy(existing_header, 0, checksum_data_header, token_header_bytes.attr_length, existing_header.attr_length)
      end
      return @cipher_helper.calculate_checksum(@token_header.get_sign_alg, checksum_data_header, optional_trailer, data, offset, len, @token_id)
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
      @seq_number = 0
      @conf_state = false
      @initiator = false
      @token_id = 0
      @gss_header = nil
      @token_header = nil
      @checksum = nil
      @enc_seq_number = nil
      @seq_number_data = nil
      @cipher_helper = nil
      super()
      @conf_state = true
      @initiator = true
      @token_id = 0
      @gss_header = nil
      @token_header = nil
      @checksum = nil
      @enc_seq_number = nil
      @seq_number_data = nil
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
    end
    
    typesig { [OutputStream] }
    # Encodes a GSSHeader and this token onto an OutputStream.
    # 
    # @param os the OutputStream to which this should be written
    # @throws GSSException if an error occurs while writing to the OutputStream
    def encode(os)
      @gss_header = GSSHeader.new(OID, get_krb5token_size)
      @gss_header.encode(os)
      @token_header.encode(os)
      # debug("Writing seqNumber: " + getHexBytes(encSeqNumber));
      os.write(@enc_seq_number)
      # debug("Writing checksum: " + getHexBytes(checksum));
      os.write(@checksum)
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
      return TOKEN_NO_CKSUM_SIZE + @cipher_helper.get_checksum_length
    end
    
    class_module.module_eval {
      typesig { [CipherHelper] }
      def get_token_size(ch)
        return TOKEN_NO_CKSUM_SIZE + ch.get_checksum_length
      end
    }
    
    typesig { [::Java::Boolean, ::Java::Int] }
    # Obtains the conext key that is associated with this token.
    # @return the context key
    # 
    # 
    # public final byte[] getContextKey() {
    # return contextKey;
    # }
    # 
    # 
    # Obtains the encryption algorithm that should be used in this token
    # given the state of confidentiality the application requested.
    # Requested qop must be consistent with negotiated session key.
    # @param confRequested true if the application desired confidentiality
    # on this token, false otherwise
    # @param qop the qop requested by the application
    # @throws GSSException if qop is incompatible with the negotiated
    # session key
    def get_seal_alg(conf_requested, qop)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # ******************************************* //
      # I N N E R    C L A S S E S    F O L L O W
      # ******************************************* //
      # 
      # This inner class represents the initial portion of the message token
      # and contains information about the checksum and encryption algorithms
      # that are in use. It constitutes the first 8 bytes of the
      # message token:
      # <pre>
      # 0..1           TOK_ID          Identification field.
      # 01 01 - Mic token
      # 02 01 - Wrap token
      # 2..3           SGN_ALG         Checksum algorithm indicator.
      # 00 00 - DES MAC MD5
      # 01 00 - MD2.5
      # 02 00 - DES MAC
      # 04 00 - HMAC SHA1 DES3-KD
      # 11 00 - RC4-HMAC
      # 4..5           SEAL_ALG        ff ff - none
      # 00 00 - DES
      # 02 00 - DES3-KD
      # 10 00 - RC4-HMAC
      # 6..7           Filler          Contains ff ff
      # </pre>
      const_set_lazy(:MessageTokenHeader) { Class.new do
        extend LocalClass
        include_class_members MessageToken
        
        attr_accessor :token_id
        alias_method :attr_token_id, :token_id
        undef_method :token_id
        alias_method :attr_token_id=, :token_id=
        undef_method :token_id=
        
        attr_accessor :sign_alg
        alias_method :attr_sign_alg, :sign_alg
        undef_method :sign_alg
        alias_method :attr_sign_alg=, :sign_alg=
        undef_method :sign_alg=
        
        attr_accessor :seal_alg
        alias_method :attr_seal_alg, :seal_alg
        undef_method :seal_alg
        alias_method :attr_seal_alg=, :seal_alg=
        undef_method :seal_alg=
        
        attr_accessor :bytes
        alias_method :attr_bytes, :bytes
        undef_method :bytes
        alias_method :attr_bytes=, :bytes=
        undef_method :bytes=
        
        typesig { [::Java::Int, ::Java::Boolean, ::Java::Int] }
        # Constructs a MessageTokenHeader for the specified token type with
        # appropriate checksum and encryption algorithms fields.
        # 
        # @param tokenId the token id for this mesage token
        # @param conf true if confidentiality will be resuested with this
        # message token, false otherwise.
        # @param qop the value of the quality of protection that will be
        # desired.
        def initialize(token_id, conf, qop)
          @token_id = 0
          @sign_alg = 0
          @seal_alg = 0
          @bytes = Array.typed(::Java::Byte).new(8) { 0 }
          @token_id = token_id
          @sign_alg = @local_class_parent.get_sgn_alg(qop)
          @seal_alg = @local_class_parent.get_seal_alg(conf, qop)
          @bytes[0] = (token_id >> 8)
          @bytes[1] = (token_id)
          @bytes[2] = (@sign_alg >> 8)
          @bytes[3] = (@sign_alg)
          @bytes[4] = (@seal_alg >> 8)
          @bytes[5] = (@seal_alg)
          @bytes[6] = (MessageToken::FILLER >> 8)
          @bytes[7] = (MessageToken::FILLER)
        end
        
        typesig { [class_self::InputStream, class_self::MessageProp] }
        # Constructs a MessageTokenHeader by reading it from an InputStream
        # and sets the appropriate confidentiality and quality of protection
        # values in a MessageProp structure.
        # 
        # @param is the InputStream to read from
        # @param prop the MessageProp to populate
        # @throws IOException is an error occurs while reading from the
        # InputStream
        def initialize(is, prop)
          @token_id = 0
          @sign_alg = 0
          @seal_alg = 0
          @bytes = Array.typed(::Java::Byte).new(8) { 0 }
          read_fully(is, @bytes)
          @token_id = read_int(@bytes, TOKEN_ID_POS)
          @sign_alg = read_int(@bytes, SIGN_ALG_POS)
          @seal_alg = read_int(@bytes, SEAL_ALG_POS)
          # debug("\nMessageTokenHeader read tokenId=" +
          # getHexBytes(bytes) + "\n");
          # XXX compare to FILLER
          temp = read_int(@bytes, SEAL_ALG_POS + 2)
          # debug("SIGN_ALG=" + signAlg);
          case (@seal_alg)
          when SEAL_ALG_DES, SEAL_ALG_DES3_KD, SEAL_ALG_ARCFOUR_HMAC
            prop.set_privacy(true)
          else
            prop.set_privacy(false)
          end
          prop.set_qop(0) # default
        end
        
        typesig { [class_self::OutputStream] }
        # Encodes this MessageTokenHeader onto an OutputStream
        # @param os the OutputStream to write to
        # @throws IOException is an error occurs while writing
        def encode(os)
          os.write(@bytes)
        end
        
        typesig { [] }
        # Returns the token id for the message token.
        # @return the token id
        # @see sun.security.jgss.krb5.Krb5Token#MIC_ID
        # @see sun.security.jgss.krb5.Krb5Token#WRAP_ID
        def get_token_id
          return @token_id
        end
        
        typesig { [] }
        # Returns the sign algorithm for the message token.
        # @return the sign algorithm
        # @see sun.security.jgss.krb5.MessageToken#SIGN_DES_MAC
        # @see sun.security.jgss.krb5.MessageToken#SIGN_DES_MAC_MD5
        def get_sign_alg
          return @sign_alg
        end
        
        typesig { [] }
        # Returns the seal algorithm for the message token.
        # @return the seal algorithm
        # @see sun.security.jgss.krb5.MessageToken#SEAL_ALG_DES
        # @see sun.security.jgss.krb5.MessageToken#SEAL_ALG_NONE
        def get_seal_alg
          return @seal_alg
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
    
    typesig { [::Java::Int] }
    # end of class MessageTokenHeader
    # 
    # Determine signing algorithm based on QOP.
    def get_sgn_alg(qop)
      # QOP ignored
      return @cipher_helper.get_sgn_alg
    end
    
    private
    alias_method :initialize__message_token, :initialize
  end
  
end
