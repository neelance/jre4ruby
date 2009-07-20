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
  module WrapTokenImports
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
  
  # This class represents a token emitted by the GSSContext.wrap()
  # call. It is a MessageToken except that it also contains plaintext
  # or encrypted data at the end. A wrapToken has certain other rules
  # that are peculiar to it and different from a MICToken, which is
  # another type of MessageToken. All data in a WrapToken is prepended
  # by a random counfounder of 8 bytes. All data in a WrapToken is
  # also padded with one to eight bytes where all bytes are equal in
  # value to the number of bytes being padded. Thus, all application
  # data is replaced by (confounder || data || padding).
  # 
  # @author Mayank Upadhyay
  class WrapToken < WrapTokenImports.const_get :MessageToken
    include_class_members WrapTokenImports
    
    class_module.module_eval {
      # The size of the random confounder used in a WrapToken.
      const_set_lazy(:CONFOUNDER_SIZE) { 8 }
      const_attr_reader  :CONFOUNDER_SIZE
      
      # The padding used with a WrapToken. All data is padded to the
      # next multiple of 8 bytes, even if its length is already
      # multiple of 8.
      # Use this table as a quick way to obtain padding bytes by
      # indexing it with the number of padding bytes required.
      # 
      # No, no one escapes padding
      const_set_lazy(:Pads) { Array.typed(Array.typed(::Java::Byte)).new([nil, Array.typed(::Java::Byte).new([0x1]), Array.typed(::Java::Byte).new([0x2, 0x2]), Array.typed(::Java::Byte).new([0x3, 0x3, 0x3]), Array.typed(::Java::Byte).new([0x4, 0x4, 0x4, 0x4]), Array.typed(::Java::Byte).new([0x5, 0x5, 0x5, 0x5, 0x5]), Array.typed(::Java::Byte).new([0x6, 0x6, 0x6, 0x6, 0x6, 0x6]), Array.typed(::Java::Byte).new([0x7, 0x7, 0x7, 0x7, 0x7, 0x7, 0x7]), Array.typed(::Java::Byte).new([0x8, 0x8, 0x8, 0x8, 0x8, 0x8, 0x8, 0x8])]) }
      const_attr_reader  :Pads
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
    
    # the len of the token data: (confounder || data || padding)
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
    
    attr_accessor :padding
    alias_method :attr_padding, :padding
    undef_method :padding
    alias_method :attr_padding=, :padding=
    undef_method :padding=
    
    attr_accessor :privacy
    alias_method :attr_privacy, :privacy
    undef_method :privacy
    alias_method :attr_privacy=, :privacy=
    undef_method :privacy=
    
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
      @padding = nil
      @privacy = false
      super(Krb5Token::WRAP_ID, context, token_bytes, token_offset, token_len, prop)
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
      @padding = nil
      @privacy = false
      @read_token_from_input_stream = false
      # Will need the token bytes again when extracting data
      @token_bytes = token_bytes
      @token_offset = token_offset
      @token_len = token_len
      @privacy = prop.get_privacy
      @data_size = get_gssheader.get_mech_token_length - get_krb5token_size
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
      @padding = nil
      @privacy = false
      super(Krb5Token::WRAP_ID, context, is, prop)
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
      @padding = nil
      @privacy = false
      # Will need the token bytes again when extracting data
      @is = is
      @privacy = prop.get_privacy
      # debug("WrapToken Cons: gssHeader.getMechTokenLength=" +
      # getGSSHeader().getMechTokenLength());
      # debug("\n                token size="
      # + getTokenSize());
      @data_size = get_gssheader.get_mech_token_length - get_token_size
      # debug("\n                dataSize=" + dataSize);
      # debug("\n");
    end
    
    typesig { [] }
    # Obtains the application data that was transmitted in this
    # WrapToken.
    # @return a byte array containing the application data
    # @throws GSSException if an error occurs while decrypting any
    # cipher text and checking for validity
    def get_data
      temp = Array.typed(::Java::Byte).new(@data_size) { 0 }
      get_data(temp, 0)
      # Remove the confounder and the padding
      ret_val = Array.typed(::Java::Byte).new(@data_size - @confounder.attr_length - @padding.attr_length) { 0 }
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
      return (@data_size - @confounder.attr_length - @padding.attr_length)
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
      gss_header = get_gssheader
      data_pos = @token_offset + gss_header.get_length + get_token_size
      if (data_pos + @data_size > @token_offset + @token_len)
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Insufficient data in " + (get_token_name(get_token_id)).to_s)
      end
      # debug("WrapToken cons: data is token is [" +
      # getHexBytes(tokenBytes, tokenOffset, tokenLen) + "]\n");
      @confounder = Array.typed(::Java::Byte).new(CONFOUNDER_SIZE) { 0 }
      # Do decryption if this token was privacy protected.
      if (@privacy)
        self.attr_cipher_helper.decrypt_data(self, @token_bytes, data_pos, @data_size, data_buf, data_buf_offset)
        # debug("\t\tDecrypted data is [" +
        # getHexBytes(confounder) + " " +
        # getHexBytes(dataBuf, dataBufOffset,
        # dataSize - CONFOUNDER_SIZE - padding.length) +
        # getHexBytes(padding) +
        # "]\n");
      else
        # Token data is in cleartext
        # debug("\t\tNo encryption was performed by peer.\n");
        System.arraycopy(@token_bytes, data_pos, @confounder, 0, CONFOUNDER_SIZE)
        pad_size = @token_bytes[data_pos + @data_size - 1]
        if (pad_size < 0)
          pad_size = 0
        end
        if (pad_size > 8)
          pad_size %= 8
        end
        @padding = Pads[pad_size]
        # debug("\t\tPadding applied was: " + padSize + "\n");
        System.arraycopy(@token_bytes, data_pos + CONFOUNDER_SIZE, data_buf, data_buf_offset, @data_size - CONFOUNDER_SIZE - pad_size)
        # byte[] debugbuf = new byte[dataSize - CONFOUNDER_SIZE - padSize];
        # System.arraycopy(tokenBytes, dataPos + CONFOUNDER_SIZE,
        # debugbuf, 0, debugbuf.length);
        # debug("\t\tData is: " + getHexBytes(debugbuf, debugbuf.length));
      end
      # Make sure sign and sequence number are not corrupt
      if (!verify_sign_and_seq_number(@confounder, data_buf, data_buf_offset, @data_size - CONFOUNDER_SIZE - @padding.attr_length, @padding))
        raise GSSException.new(GSSException::BAD_MIC, -1, "Corrupt checksum or sequence number in Wrap token")
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
      gss_header = get_gssheader
      # Don't check the token length. Data will be read on demand from
      # the InputStream.
      # debug("WrapToken cons: data will be read from InputStream.\n");
      @confounder = Array.typed(::Java::Byte).new(CONFOUNDER_SIZE) { 0 }
      begin
        # Do decryption if this token was privacy protected.
        if (@privacy)
          self.attr_cipher_helper.decrypt_data(self, @is, @data_size, data_buf, data_buf_offset)
          # debug("\t\tDecrypted data is [" +
          # getHexBytes(confounder) + " " +
          # getHexBytes(dataBuf, dataBufOffset,
          # dataSize - CONFOUNDER_SIZE - padding.length) +
          # getHexBytes(padding) +
          # "]\n");
        else
          # Token data is in cleartext
          # debug("\t\tNo encryption was performed by peer.\n");
          read_fully(@is, @confounder)
          # Data is always a multiple of 8 with this GSS Mech
          # Copy all but last block as they are
          num_blocks = (@data_size - CONFOUNDER_SIZE) / 8 - 1
          offset = data_buf_offset
          i = 0
          while i < num_blocks
            read_fully(@is, data_buf, offset, 8)
            offset += 8
            i += 1
          end
          final_block = Array.typed(::Java::Byte).new(8) { 0 }
          read_fully(@is, final_block)
          pad_size = final_block[7]
          @padding = Pads[pad_size]
          # debug("\t\tPadding applied was: " + padSize + "\n");
          System.arraycopy(final_block, 0, data_buf, offset, final_block.attr_length - pad_size)
        end
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, (get_token_name(get_token_id)).to_s + ": " + (e.get_message).to_s)
      end
      # Make sure sign and sequence number are not corrupt
      if (!verify_sign_and_seq_number(@confounder, data_buf, data_buf_offset, @data_size - CONFOUNDER_SIZE - @padding.attr_length, @padding))
        raise GSSException.new(GSSException::BAD_MIC, -1, "Corrupt checksum or sequence number in Wrap token")
      end
    end
    
    typesig { [::Java::Int] }
    # Helper routine to pick the right padding for a certain length
    # of application data. Every application message has some
    # padding between 1 and 8 bytes.
    # @param len the length of the application data
    # @return the padding to be applied
    def get_padding(len)
      pad_size = 0
      # For RC4-HMAC, all padding is rounded up to 1 byte.
      # One byte is needed to say that there is 1 byte of padding.
      if (self.attr_cipher_helper.is_arc_four)
        pad_size = 1
      else
        pad_size = len % 8
        pad_size = 8 - pad_size
      end
      return Pads[pad_size]
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
      @padding = nil
      @privacy = false
      super(Krb5Token::WRAP_ID, context)
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
      @padding = nil
      @privacy = false
      @confounder = Confounder.bytes(CONFOUNDER_SIZE)
      @padding = get_padding(data_len)
      @data_size = @confounder.attr_length + data_len + @padding.attr_length
      @data_bytes = data_bytes
      @data_offset = data_offset
      @data_len = data_len
      # debug("\nWrapToken cons: data to wrap is [" +
      # getHexBytes(confounder) + " " +
      # getHexBytes(dataBytes, dataOffset, dataLen) + " " +
      # // padding is never null for Wrap
      # getHexBytes(padding) + "]\n");
      gen_sign_and_seq_number(prop, @confounder, data_bytes, data_offset, data_len, @padding)
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
      # debug("Writing data: [");
      if (!@privacy)
        # debug(getHexBytes(confounder, confounder.length));
        os.write(@confounder)
        # debug(" " + getHexBytes(dataBytes, dataOffset, dataLen));
        os.write(@data_bytes, @data_offset, @data_len)
        # debug(" " + getHexBytes(padding, padding.length));
        os.write(@padding)
      else
        self.attr_cipher_helper.encrypt_data(self, @confounder, @data_bytes, @data_offset, @data_len, @padding, os)
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
      # Token header is small
      bos = ByteArrayOutputStream.new
      super(bos)
      header = bos.to_byte_array
      System.arraycopy(header, 0, out_token, offset, header.attr_length)
      offset += header.attr_length
      # debug("WrapToken.encode: Writing data: [");
      if (!@privacy)
        # debug(getHexBytes(confounder, confounder.length));
        System.arraycopy(@confounder, 0, out_token, offset, @confounder.attr_length)
        offset += @confounder.attr_length
        # debug(" " + getHexBytes(dataBytes, dataOffset, dataLen));
        System.arraycopy(@data_bytes, @data_offset, out_token, offset, @data_len)
        offset += @data_len
        # debug(" " + getHexBytes(padding, padding.length));
        System.arraycopy(@padding, 0, out_token, offset, @padding.attr_length)
      else
        self.attr_cipher_helper.encrypt_data(self, @confounder, @data_bytes, @data_offset, @data_len, @padding, out_token, offset)
        # debug(getHexBytes(outToken, offset, dataSize));
      end
      # debug("]\n");
      # %%% assume that plaintext length == ciphertext len
      return (header.attr_length + @confounder.attr_length + @data_len + @padding.attr_length)
    end
    
    typesig { [] }
    def get_krb5token_size
      return (get_token_size + @data_size)
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    def get_seal_alg(conf, qop)
      if (!conf)
        return SEAL_ALG_NONE
      end
      # ignore QOP
      return self.attr_cipher_helper.get_seal_alg
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Boolean, ::Java::Int, CipherHelper] }
      # This implementation is way too conservative. And it certainly
      # doesn't return the maximum limit.
      def get_size_limit(qop, conf_req, max_token_size, ch)
        return (GSSHeader.get_max_mech_token_size(OID, max_token_size) - (get_token_size(ch) + CONFOUNDER_SIZE) - 8)
        # safety
      end
    }
    
    private
    alias_method :initialize__wrap_token, :initialize
  end
  
end
