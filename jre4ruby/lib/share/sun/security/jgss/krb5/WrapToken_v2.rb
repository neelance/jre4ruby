require "rjava"

# Copyright 2004-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module WrapToken_v2Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Sun::Security::Krb5, :Confounder
      include_const ::Sun::Security::Krb5, :KrbException
    }
  end
  
  # This class represents the new format of GSS tokens, as specified in
  # draft-ietf-krb-wg-gssapi-cfx-07.txt, emitted by the GSSContext.wrap()
  # call. It is a MessageToken except that it also contains plaintext or
  # encrypted data at the end. A WrapToken has certain other rules that are
  # peculiar to it and different from a  MICToken, which is another type of
  # MessageToken. All data in a WrapToken is prepended by a random counfounder
  # of 16 bytes. Thus, all application data is replaced by
  # (confounder || data || tokenHeader || checksum).
  # 
  # @author Seema Malkani
  class WrapToken_v2 < WrapToken_v2Imports.const_get :MessageToken_v2
    include_class_members WrapToken_v2Imports
    
    class_module.module_eval {
      # The size of the random confounder used in a WrapToken.
      const_set_lazy(:CONFOUNDER_SIZE) { 16 }
      const_attr_reader  :CONFOUNDER_SIZE
    }
    
    # A token may come in either in an InputStream or as a
    # byte[]. Store a reference to it in either case and process
    # it's data only later when getData() is called and
    # decryption/copying is needed to be done. Note that JCE can
    # decrypt both from a byte[] and from an InputStream.
    attr_accessor :read_token_from_input_stream
    alias_method :attr_read_token_from_input_stream, :read_token_from_input_stream
    undef_method :read_token_from_input_stream
    alias_method :attr_read_token_from_input_stream=, :read_token_from_input_stream=
    undef_method :read_token_from_input_stream=
    
    attr_accessor :is
    alias_method :attr_is, :is
    undef_method :is
    alias_method :attr_is=, :is=
    undef_method :is=
    
    attr_accessor :token_bytes
    alias_method :attr_token_bytes, :token_bytes
    undef_method :token_bytes
    alias_method :attr_token_bytes=, :token_bytes=
    undef_method :token_bytes=
    
    attr_accessor :token_offset
    alias_method :attr_token_offset, :token_offset
    undef_method :token_offset
    alias_method :attr_token_offset=, :token_offset=
    undef_method :token_offset=
    
    attr_accessor :token_len
    alias_method :attr_token_len, :token_len
    undef_method :token_len
    alias_method :attr_token_len=, :token_len=
    undef_method :token_len=
    
    # Application data may come from an InputStream or from a
    # byte[]. However, it will always be stored and processed as a
    # byte[] since
    # (a) the MessageDigest class only accepts a byte[] as input and
    # (b) It allows writing to an OuputStream via a CipherOutputStream.
    attr_accessor :data_bytes
    alias_method :attr_data_bytes, :data_bytes
    undef_method :data_bytes
    alias_method :attr_data_bytes=, :data_bytes=
    undef_method :data_bytes=
    
    attr_accessor :data_offset
    alias_method :attr_data_offset, :data_offset
    undef_method :data_offset
    alias_method :attr_data_offset=, :data_offset=
    undef_method :data_offset=
    
    attr_accessor :data_len
    alias_method :attr_data_len, :data_len
    undef_method :data_len
    alias_method :attr_data_len=, :data_len=
    undef_method :data_len=
    
    # the len of the token data:
    # (confounder || data || tokenHeader || checksum)
    attr_accessor :data_size
    alias_method :attr_data_size, :data_size
    undef_method :data_size
    alias_method :attr_data_size=, :data_size=
    undef_method :data_size=
    
    # Accessed by CipherHelper
    attr_accessor :confounder
    alias_method :attr_confounder, :confounder
    undef_method :confounder
    alias_method :attr_confounder=, :confounder=
    undef_method :confounder=
    
    attr_accessor :privacy
    alias_method :attr_privacy, :privacy
    undef_method :privacy
    alias_method :attr_privacy=, :privacy=
    undef_method :privacy=
    
    attr_accessor :initiator
    alias_method :attr_initiator, :initiator
    undef_method :initiator
    alias_method :attr_initiator=, :initiator=
    undef_method :initiator=
    
    typesig { [Krb5Context, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    # Constructs a WrapToken from token bytes obtained from the
    # peer.
    # @param context the mechanism context associated with this
    # token
    # @param tokenBytes the bytes of the token
    # @param tokenOffset the offset of the token
    # @param tokenLen the length of the token
    # @param prop the MessageProp into which characteristics of the
    # parsed token will be stored.
    # @throws GSSException if the token is defective
    def initialize(context, token_bytes, token_offset, token_len, prop)
      # Just parse the MessageToken part first
      @read_token_from_input_stream = false
      @is = nil
      @token_bytes = nil
      @token_offset = 0
      @token_len = 0
      @data_bytes = nil
      @data_offset = 0
      @data_len = 0
      @data_size = 0
      @confounder = nil
      @privacy = false
      @initiator = false
      super(Krb5Token::WRAP_ID_v2, context, token_bytes, token_offset, token_len, prop)
      @read_token_from_input_stream = true
      @is = nil
      @token_bytes = nil
      @token_offset = 0
      @token_len = 0
      @data_bytes = nil
      @data_offset = 0
      @data_len = 0
      @data_size = 0
      @confounder = nil
      @privacy = false
      @initiator = true
      @read_token_from_input_stream = false
      # rotate token bytes as per RRC
      new_token_bytes = Array.typed(::Java::Byte).new(token_len) { 0 }
      if (rotate_left(token_bytes, token_offset, new_token_bytes, token_len))
        @token_bytes = new_token_bytes
        @token_offset = 0
      else
        @token_bytes = token_bytes
        @token_offset = token_offset
      end
      # Will need the token bytes again when extracting data
      @token_len = token_len
      @privacy = prop.get_privacy
      @data_size = token_len - TOKEN_HEADER_SIZE
      # save initiator
      @initiator = context.is_initiator
    end
    
    typesig { [Krb5Context, InputStream, MessageProp] }
    # Constructs a WrapToken from token bytes read on the fly from
    # an InputStream.
    # @param context the mechanism context associated with this
    # token
    # @param is the InputStream containing the token bytes
    # @param prop the MessageProp into which characteristics of the
    # parsed token will be stored.
    # @throws GSSException if the token is defective or if there is
    # a problem reading from the InputStream
    def initialize(context, is, prop)
      # Just parse the MessageToken part first
      @read_token_from_input_stream = false
      @is = nil
      @token_bytes = nil
      @token_offset = 0
      @token_len = 0
      @data_bytes = nil
      @data_offset = 0
      @data_len = 0
      @data_size = 0
      @confounder = nil
      @privacy = false
      @initiator = false
      super(Krb5Token::WRAP_ID_v2, context, is, prop)
      @read_token_from_input_stream = true
      @is = nil
      @token_bytes = nil
      @token_offset = 0
      @token_len = 0
      @data_bytes = nil
      @data_offset = 0
      @data_len = 0
      @data_size = 0
      @confounder = nil
      @privacy = false
      @initiator = true
      # Will need the token bytes again when extracting data
      @is = is
      @privacy = prop.get_privacy
      # get the token length
      begin
        @token_len = is.available
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(get_token_id)) + ": " + RJava.cast_to_string(e.get_message))
      end
      # data size
      @data_size = @token_len - TOKEN_HEADER_SIZE
      # save initiator
      @initiator = context.is_initiator
    end
    
    typesig { [] }
    # Obtains the application data that was transmitted in this
    # WrapToken.
    # @return a byte array containing the application data
    # @throws GSSException if an error occurs while decrypting any
    # cipher text and checking for validity
    def get_data
      temp = Array.typed(::Java::Byte).new(@data_size) { 0 }
      len = get_data(temp, 0)
      # len obtained is after removing confounder, tokenHeader and HMAC
      ret_val = Array.typed(::Java::Byte).new(len) { 0 }
      System.arraycopy(temp, 0, ret_val, 0, ret_val.attr_length)
      return ret_val
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Obtains the application data that was transmitted in this
    # WrapToken, writing it into an application provided output
    # array.
    # @param dataBuf the output buffer into which the data must be
    # written
    # @param dataBufOffset the offset at which to write the data
    # @return the size of the data written
    # @throws GSSException if an error occurs while decrypting any
    # cipher text and checking for validity
    def get_data(data_buf, data_buf_offset)
      if (@read_token_from_input_stream)
        get_data_from_stream(data_buf, data_buf_offset)
      else
        get_data_from_buffer(data_buf, data_buf_offset)
      end
      ret_val = 0
      if (@privacy)
        ret_val = @data_size - @confounder.attr_length - TOKEN_HEADER_SIZE - self.attr_cipher_helper.get_checksum_length
      else
        ret_val = @data_size - self.attr_cipher_helper.get_checksum_length
      end
      return ret_val
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Helper routine to obtain the application data transmitted in
    # this WrapToken. It is called if the WrapToken was constructed
    # with a byte array as input.
    # @param dataBuf the output buffer into which the data must be
    # written
    # @param dataBufOffset the offset at which to write the data
    # @throws GSSException if an error occurs while decrypting any
    # cipher text and checking for validity
    def get_data_from_buffer(data_buf, data_buf_offset)
      data_pos = @token_offset + TOKEN_HEADER_SIZE
      data_length = 0
      if (data_pos + @data_size > @token_offset + @token_len)
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Insufficient data in " + RJava.cast_to_string(get_token_name(get_token_id)))
      end
      # debug("WrapToken cons: data is token is [" +
      # getHexBytes(tokenBytes, tokenOffset, tokenLen) + "]\n");
      @confounder = Array.typed(::Java::Byte).new(CONFOUNDER_SIZE) { 0 }
      # Do decryption if this token was privacy protected.
      if (@privacy)
        # decrypt data
        self.attr_cipher_helper.decrypt_data(self, @token_bytes, data_pos, @data_size, data_buf, data_buf_offset, get_key_usage)
        # debug("\t\tDecrypted data is [" +
        # getHexBytes(confounder) + " " +
        # getHexBytes(dataBuf, dataBufOffset,
        # dataSize - CONFOUNDER_SIZE) +
        # "]\n");
        data_length = @data_size - CONFOUNDER_SIZE - TOKEN_HEADER_SIZE - self.attr_cipher_helper.get_checksum_length
      else
        # Token data is in cleartext
        debug("\t\tNo encryption was performed by peer.\n")
        # data
        data_length = @data_size - self.attr_cipher_helper.get_checksum_length
        System.arraycopy(@token_bytes, data_pos, data_buf, data_buf_offset, data_length)
        # debug("\t\tData is: " + getHexBytes(dataBuf, data_length));
        # 
        # Make sure checksum is not corrupt
        if (!verify_sign(data_buf, data_buf_offset, data_length))
          raise GSSException.new(GSSException::BAD_MIC, -1, "Corrupt checksum in Wrap token")
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Helper routine to obtain the application data transmitted in
    # this WrapToken. It is called if the WrapToken was constructed
    # with an Inputstream.
    # @param dataBuf the output buffer into which the data must be
    # written
    # @param dataBufOffset the offset at which to write the data
    # @throws GSSException if an error occurs while decrypting any
    # cipher text and checking for validity
    def get_data_from_stream(data_buf, data_buf_offset)
      data_length = 0
      # Don't check the token length. Data will be read on demand from
      # the InputStream.
      # debug("WrapToken cons: data will be read from InputStream.\n");
      @confounder = Array.typed(::Java::Byte).new(CONFOUNDER_SIZE) { 0 }
      begin
        # Do decryption if this token was privacy protected.
        if (@privacy)
          self.attr_cipher_helper.decrypt_data(self, @is, @data_size, data_buf, data_buf_offset, get_key_usage)
          # debug("\t\tDecrypted data is [" +
          # getHexBytes(confounder) + " " +
          # getHexBytes(dataBuf, dataBufOffset,
          # dataSize - CONFOUNDER_SIZE) +
          # "]\n");
          data_length = @data_size - CONFOUNDER_SIZE - TOKEN_HEADER_SIZE - self.attr_cipher_helper.get_checksum_length
        else
          # Token data is in cleartext
          debug("\t\tNo encryption was performed by peer.\n")
          read_fully(@is, @confounder)
          # read the data
          data_length = @data_size - self.attr_cipher_helper.get_checksum_length
          read_fully(@is, data_buf, data_buf_offset, data_length)
          # Make sure checksum is not corrupt
          if (!verify_sign(data_buf, data_buf_offset, data_length))
            raise GSSException.new(GSSException::BAD_MIC, -1, "Corrupt checksum in Wrap token")
          end
        end
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, RJava.cast_to_string(get_token_name(get_token_id)) + ": " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [Krb5Context, MessageProp, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def initialize(context, prop, data_bytes, data_offset, data_len)
      @read_token_from_input_stream = false
      @is = nil
      @token_bytes = nil
      @token_offset = 0
      @token_len = 0
      @data_bytes = nil
      @data_offset = 0
      @data_len = 0
      @data_size = 0
      @confounder = nil
      @privacy = false
      @initiator = false
      super(Krb5Token::WRAP_ID_v2, context)
      @read_token_from_input_stream = true
      @is = nil
      @token_bytes = nil
      @token_offset = 0
      @token_len = 0
      @data_bytes = nil
      @data_offset = 0
      @data_len = 0
      @data_size = 0
      @confounder = nil
      @privacy = false
      @initiator = true
      @confounder = Confounder.bytes(CONFOUNDER_SIZE)
      @data_size = @confounder.attr_length + data_len + TOKEN_HEADER_SIZE + self.attr_cipher_helper.get_checksum_length
      @data_bytes = data_bytes
      @data_offset = data_offset
      @data_len = data_len
      # save initiator
      @initiator = context.is_initiator
      # debug("\nWrapToken cons: data to wrap is [" +
      # getHexBytes(confounder) + " " +
      # getHexBytes(dataBytes, dataOffset, dataLen) + "]\n");
      gen_sign_and_seq_number(prop, data_bytes, data_offset, data_len)
      # If the application decides to ask for privacy when the context
      # did not negotiate for it, do not provide it. The peer might not
      # have support for it. The app will realize this with a call to
      # pop.getPrivacy() after wrap().
      if (!context.get_conf_state)
        prop.set_privacy(false)
      end
      @privacy = prop.get_privacy
    end
    
    typesig { [OutputStream] }
    def encode(os)
      super(os)
      # debug("\n\nWriting data: [");
      if (!@privacy)
        # Wrap Tokens (without confidentiality) =
        # { 16 byte token_header | plaintext | 12-byte HMAC }
        # where HMAC is on { plaintext | token_header }
        # calculate checksum
        checksum = get_checksum(@data_bytes, @data_offset, @data_len)
        # data
        # debug(" " + getHexBytes(dataBytes, dataOffset, dataLen));
        os.write(@data_bytes, @data_offset, @data_len)
        # write HMAC
        # debug(" " + getHexBytes(checksum,
        # cipherHelper.getChecksumLength()));
        os.write(checksum)
      else
        # Wrap Tokens (with confidentiality) =
        # { 16 byte token_header |
        # Encrypt(16-byte confounder | plaintext | token_header) |
        # 12-byte HMAC }
        self.attr_cipher_helper.encrypt_data(self, @confounder, get_token_header, @data_bytes, @data_offset, @data_len, get_key_usage, os)
      end
      # debug("]\n");
    end
    
    typesig { [] }
    def encode
      # XXX Fine tune this initial size
      bos = ByteArrayOutputStream.new(@data_size + 50)
      encode(bos)
      return bos.to_byte_array
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def encode(out_token, offset)
      ret_val = 0
      # Token header is small
      bos = ByteArrayOutputStream.new
      super(bos)
      header = bos.to_byte_array
      System.arraycopy(header, 0, out_token, offset, header.attr_length)
      offset += header.attr_length
      # debug("WrapToken.encode: Writing data: [");
      if (!@privacy)
        # Wrap Tokens (without confidentiality) =
        # { 16 byte token_header | plaintext | 12-byte HMAC }
        # where HMAC is on { plaintext | token_header }
        # calculate checksum
        checksum = get_checksum(@data_bytes, @data_offset, @data_len)
        # data
        # debug(" " + getHexBytes(dataBytes, dataOffset, dataLen));
        System.arraycopy(@data_bytes, @data_offset, out_token, offset, @data_len)
        offset += @data_len
        # write HMAC
        # debug(" " + getHexBytes(checksum,
        # cipherHelper.getChecksumLength()));
        System.arraycopy(checksum, 0, out_token, offset, self.attr_cipher_helper.get_checksum_length)
        ret_val = header.attr_length + @data_len + self.attr_cipher_helper.get_checksum_length
      else
        # Wrap Tokens (with confidentiality) =
        # { 16 byte token_header |
        # Encrypt(16-byte confounder | plaintext | token_header) |
        # 12-byte HMAC }
        c_len = self.attr_cipher_helper.encrypt_data(self, @confounder, get_token_header, @data_bytes, @data_offset, @data_len, out_token, offset, get_key_usage)
        ret_val = header.attr_length + c_len
        # debug(getHexBytes(outToken, offset, dataSize));
      end
      # debug("]\n");
      # %%% assume that plaintext length == ciphertext len
      return ret_val
    end
    
    typesig { [] }
    def get_krb5token_size
      return (get_token_size + @data_size)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Boolean, ::Java::Int, CipherHelper] }
      # This implementation is way to conservative. And it certainly
      # doesn't return the maximum limit.
      def get_size_limit(qop, conf_req, max_token_size, ch)
        # safety
        return (GSSHeader.get_max_mech_token_size(OID, max_token_size) - (get_token_size(ch) + CONFOUNDER_SIZE) - 8)
      end
    }
    
    private
    alias_method :initialize__wrap_token_v2, :initialize
  end
  
end
