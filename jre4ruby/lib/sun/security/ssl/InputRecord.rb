require "rjava"

# 
# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module InputRecordImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Nio
      include_const ::Java::Net, :SocketException
      include_const ::Java::Net, :SocketTimeoutException
      include_const ::Javax::Crypto, :BadPaddingException
      include ::Javax::Net::Ssl
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # 
  # SSL 3.0 records, as pulled off a TCP stream.  Input records are
  # basically buffers tied to a particular input stream ... a layer
  # above this must map these records into the model of a continuous
  # stream of data.
  # 
  # Since this returns SSL 3.0 records, it's the layer that needs to
  # map SSL 2.0 style handshake records into SSL 3.0 ones for those
  # "old" clients that interop with both V2 and V3 servers.  Not as
  # pretty as might be desired.
  # 
  # NOTE:  During handshaking, each message must be hashed to support
  # verification that the handshake process wasn't compromised.
  # 
  # @author David Brownell
  class InputRecord < InputRecordImports.const_get :ByteArrayInputStream
    include_class_members InputRecordImports
    include Record
    
    attr_accessor :handshake_hash
    alias_method :attr_handshake_hash, :handshake_hash
    undef_method :handshake_hash
    alias_method :attr_handshake_hash=, :handshake_hash=
    undef_method :handshake_hash=
    
    attr_accessor :last_hashed
    alias_method :attr_last_hashed, :last_hashed
    undef_method :last_hashed
    alias_method :attr_last_hashed=, :last_hashed=
    undef_method :last_hashed=
    
    attr_accessor :format_verified
    alias_method :attr_format_verified, :format_verified
    undef_method :format_verified
    alias_method :attr_format_verified=, :format_verified=
    undef_method :format_verified=
    
    # SSLv2 ruled out?
    attr_accessor :is_closed
    alias_method :attr_is_closed, :is_closed
    undef_method :is_closed
    alias_method :attr_is_closed=, :is_closed=
    undef_method :is_closed=
    
    attr_accessor :app_data_valid
    alias_method :attr_app_data_valid, :app_data_valid
    undef_method :app_data_valid
    alias_method :attr_app_data_valid=, :app_data_valid=
    undef_method :app_data_valid=
    
    # The ClientHello version to accept. If set to ProtocolVersion.SSL20Hello
    # and the first message we read is a ClientHello in V2 format, we convert
    # it to V3. Otherwise we throw an exception when encountering a V2 hello.
    attr_accessor :hello_version
    alias_method :attr_hello_version, :hello_version
    undef_method :hello_version
    alias_method :attr_hello_version=, :hello_version=
    undef_method :hello_version=
    
    class_module.module_eval {
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    # The existing record length
    attr_accessor :exlen
    alias_method :attr_exlen, :exlen
    undef_method :exlen
    alias_method :attr_exlen=, :exlen=
    undef_method :exlen=
    
    # V2 handshake message
    attr_accessor :v2buf
    alias_method :attr_v2buf, :v2buf
    undef_method :v2buf
    alias_method :attr_v2buf=, :v2buf=
    undef_method :v2buf=
    
    typesig { [] }
    # 
    # Construct the record to hold the maximum sized input record.
    # Data will be filled in separately.
    def initialize
      @handshake_hash = nil
      @last_hashed = 0
      @format_verified = false
      @is_closed = false
      @app_data_valid = false
      @hello_version = nil
      @exlen = 0
      @v2buf = nil
      super(Array.typed(::Java::Byte).new(self.attr_max_record_size) { 0 })
      @format_verified = true
      set_hello_version(ProtocolVersion::DEFAULT_HELLO)
      self.attr_pos = self.attr_header_size
      self.attr_count = self.attr_header_size
      @last_hashed = self.attr_count
      @exlen = 0
      @v2buf = nil
    end
    
    typesig { [ProtocolVersion] }
    def set_hello_version(hello_version)
      @hello_version = hello_version
    end
    
    typesig { [] }
    def get_hello_version
      return @hello_version
    end
    
    typesig { [] }
    # 
    # Enable format checks if initial handshaking hasn't completed
    def enable_format_checks
      @format_verified = false
    end
    
    typesig { [] }
    # return whether the data in this record is valid, decrypted data
    def is_app_data_valid
      return @app_data_valid
    end
    
    typesig { [::Java::Boolean] }
    def set_app_data_valid(value)
      @app_data_valid = value
    end
    
    typesig { [] }
    # 
    # Return the content type of the record.
    def content_type
      return self.attr_buf[0]
    end
    
    typesig { [HandshakeHash] }
    # 
    # For handshaking, we need to be able to hash every byte above the
    # record marking layer.  This is where we're guaranteed to see those
    # bytes, so this is where we can hash them ... especially in the
    # case of hashing the initial V2 message!
    def set_handshake_hash(handshake_hash)
      @handshake_hash = handshake_hash
    end
    
    typesig { [] }
    def get_handshake_hash
      return @handshake_hash
    end
    
    typesig { [MAC] }
    # 
    # Verify and remove the MAC ... used for all records.
    def check_mac(signer)
      len = signer._maclen
      if ((len).equal?(0))
        # no mac
        return true
      end
      offset = self.attr_count - len
      if (offset < self.attr_header_size)
        # data length would be negative, something is wrong
        return false
      end
      mac = signer.compute(content_type, self.attr_buf, self.attr_header_size, offset - self.attr_header_size)
      if (!(len).equal?(mac.attr_length))
        raise RuntimeException.new("Internal MAC error")
      end
      i = 0
      while i < len
        if (!(self.attr_buf[offset + i]).equal?(mac[i]))
          return false
        end
        ((i += 1) - 1)
      end
      self.attr_count -= len
      return true
    end
    
    typesig { [CipherBox] }
    def decrypt(box)
      len = self.attr_count - self.attr_header_size
      self.attr_count = self.attr_header_size + box.decrypt(self.attr_buf, self.attr_header_size, len)
    end
    
    typesig { [::Java::Int] }
    # 
    # Well ... hello_request messages are _never_ hashed since we can't
    # know when they'd appear in the sequence.
    def ignore(bytes)
      if (bytes > 0)
        self.attr_pos += bytes
        @last_hashed = self.attr_pos
      end
    end
    
    typesig { [] }
    # 
    # We hash the (plaintext) we've processed, but only on demand.
    # 
    # There is one place where we want to access the hash in the middle
    # of a record:  client cert message gets hashed, and part of the
    # same record is the client cert verify message which uses that hash.
    # So we track how much we've read and hashed.
    def do_hashes
      len = self.attr_pos - @last_hashed
      if (len > 0)
        hash_internal(self.attr_buf, @last_hashed, len)
        @last_hashed = self.attr_pos
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Need a helper function so we can hash the V2 hello correctly
    def hash_internal(databuf, offset, len)
      if (!(Debug).nil? && Debug.is_on("data"))
        begin
          hd = HexDumpEncoder.new
          System.out.println("[read] MD5 and SHA1 hashes:  len = " + (len).to_s)
          hd.encode_buffer(ByteArrayInputStream.new(databuf, offset, len), System.out)
        rescue IOException => e
        end
      end
      @handshake_hash.update(databuf, offset, len)
    end
    
    typesig { [InputRecord] }
    # 
    # Handshake messages may cross record boundaries.  We "queue"
    # these in big buffers if we need to cope with this problem.
    # This is not anticipated to be a common case; if this turns
    # out to be wrong, this can readily be sped up.
    def queue_handshake(r)
      len = 0
      # 
      # Hash any data that's read but unhashed.
      do_hashes
      # 
      # Move any unread data to the front of the buffer,
      # flagging it all as unhashed.
      if (self.attr_pos > self.attr_header_size)
        len = self.attr_count - self.attr_pos
        if (!(len).equal?(0))
          System.arraycopy(self.attr_buf, self.attr_pos, self.attr_buf, self.attr_header_size, len)
        end
        self.attr_pos = self.attr_header_size
        @last_hashed = self.attr_pos
        self.attr_count = self.attr_header_size + len
      end
      # 
      # Grow "buf" if needed
      len = r.available + self.attr_count
      if (self.attr_buf.attr_length < len)
        newbuf = nil
        newbuf = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(self.attr_buf, 0, newbuf, 0, self.attr_count)
        self.attr_buf = newbuf
      end
      # 
      # Append the new buffer to this one.
      System.arraycopy(r.attr_buf, r.attr_pos, self.attr_buf, self.attr_count, len - self.attr_count)
      self.attr_count = len
      # 
      # Adjust lastHashed; important for now with clients which
      # send SSL V2 client hellos.  This will go away eventually,
      # by buffer code cleanup.
      len = r.attr_last_hashed - r.attr_pos
      if ((self.attr_pos).equal?(self.attr_header_size))
        @last_hashed += len
      else
        raise SSLProtocolException.new("?? confused buffer hashing ??")
      end
      # we've read the record, advance the pointers
      r.attr_pos = r.attr_count
    end
    
    typesig { [] }
    # 
    # Prevent any more data from being read into this record,
    # and flag the record as holding no data.
    def close
      @app_data_valid = false
      @is_closed = true
      self.attr_mark = 0
      self.attr_pos = 0
      self.attr_count = 0
    end
    
    class_module.module_eval {
      # 
      # We may need to send this SSL v2 "No Cipher" message back, if we
      # are faced with an SSLv2 "hello" that's not saying "I talk v3".
      # It's the only one documented in the V2 spec as a fatal error.
      # 
      # unpadded 3 byte record
      # ... error message
      # ... NO_CIPHER error
      const_set_lazy(:V2NoCipher) { Array.typed(::Java::Byte).new([0x80, 0x3, 0x0, 0x0, 0x1]) }
      const_attr_reader  :V2NoCipher
    }
    
    typesig { [InputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def read_fully(s, b, off, len)
      n = 0
      while (n < len)
        read_len = s.read(b, off + n, len - n)
        if (read_len < 0)
          return read_len
        end
        if (!(Debug).nil? && Debug.is_on("packet"))
          begin
            hd = HexDumpEncoder.new
            bb = ByteBuffer.wrap(b, off + n, read_len)
            System.out.println("[Raw read]: length = " + (bb.remaining).to_s)
            hd.encode_buffer(bb, System.out)
          rescue IOException => e
          end
        end
        n += read_len
        @exlen += read_len
      end
      return n
    end
    
    typesig { [InputStream, OutputStream] }
    # 
    # Read the SSL V3 record ... first time around, check to see if it
    # really IS a V3 record.  Handle SSL V2 clients which can talk V3.0,
    # as well as real V3 record format; otherwise report an error.
    def read(s, o)
      if (@is_closed)
        return
      end
      # 
      # For SSL it really _is_ an error if the other end went away
      # so ungracefully as to not shut down cleanly.
      if (@exlen < self.attr_header_size)
        really = read_fully(s, self.attr_buf, @exlen, self.attr_header_size - @exlen)
        if (really < 0)
          raise EOFException.new("SSL peer shut down incorrectly")
        end
        self.attr_pos = self.attr_header_size
        self.attr_count = self.attr_header_size
        @last_hashed = self.attr_pos
      end
      # 
      # The first record might use some other record marking convention,
      # typically SSL v2 header.  (PCT could also be detected here.)
      # This case is currently common -- Navigator 3.0 usually works
      # this way, as do IE 3.0 and other products.
      if (!@format_verified)
        @format_verified = true
        # 
        # The first record must either be a handshake record or an
        # alert message. If it's not, it is either invalid or an
        # SSLv2 message.
        if (!(self.attr_buf[0]).equal?(self.attr_ct_handshake) && !(self.attr_buf[0]).equal?(self.attr_ct_alert))
          handle_unknown_record(s, o)
        else
          read_v3record(s, o)
        end
      else
        # formatVerified == true
        read_v3record(s, o)
      end
    end
    
    typesig { [InputStream, OutputStream] }
    # 
    # Read a SSL/TLS record. Throw an IOException if the format is invalid.
    def read_v3record(s, o)
      record_version = ProtocolVersion.value_of(self.attr_buf[1], self.attr_buf[2])
      # Check if too old (currently not possible)
      # or if the major version does not match.
      # The actual version negotiation is in the handshaker classes
      if ((record_version.attr_v < ProtocolVersion::MIN.attr_v) || (record_version.attr_major > ProtocolVersion::MAX.attr_major))
        raise SSLException.new("Unsupported record version " + (record_version).to_s)
      end
      # 
      # Get and check length, then the data.
      content_len = ((self.attr_buf[3] & 0xff) << 8) + (self.attr_buf[4] & 0xff)
      # 
      # Check for upper bound.
      if (content_len < 0 || content_len > self.attr_max_large_record_size - self.attr_header_size)
        raise SSLProtocolException.new("Bad InputRecord size" + ", count = " + (content_len).to_s + ", buf.length = " + (self.attr_buf.attr_length).to_s)
      end
      # 
      # Grow "buf" if needed. Since buf is maxRecordSize by default,
      # this only occurs when we receive records which violate the
      # SSL specification. This is a workaround for a Microsoft SSL bug.
      if (content_len > self.attr_buf.attr_length - self.attr_header_size)
        newbuf = Array.typed(::Java::Byte).new(content_len + self.attr_header_size) { 0 }
        System.arraycopy(self.attr_buf, 0, newbuf, 0, self.attr_header_size)
        self.attr_buf = newbuf
      end
      if (@exlen < content_len + self.attr_header_size)
        really = read_fully(s, self.attr_buf, @exlen, content_len + self.attr_header_size - @exlen)
        if (really < 0)
          raise SSLException.new("SSL peer shut down incorrectly")
        end
      end
      if (@exlen >= content_len + self.attr_header_size)
        # now we've got a complete record.
        self.attr_count = content_len + self.attr_header_size
        @exlen = 0
      end
      if (!(Debug).nil? && Debug.is_on("record"))
        if (self.attr_count < 0 || self.attr_count > (self.attr_max_record_size - self.attr_header_size))
          System.out.println((JavaThread.current_thread.get_name).to_s + ", Bad InputRecord size" + ", count = " + (self.attr_count).to_s)
        end
        System.out.println((JavaThread.current_thread.get_name).to_s + ", READ: " + (record_version).to_s + " " + (content_name(content_type)).to_s + ", length = " + (available).to_s)
      end
      # 
      # then caller decrypts, verifies, and uncompresses
    end
    
    typesig { [InputStream, OutputStream] }
    # 
    # Deal with unknown records. Called if the first data we read on this
    # connection does not look like an SSL/TLS record. It could a SSLv2
    # message, or just garbage.
    def handle_unknown_record(s, o)
      # 
      # No?  Oh well; does it look like a V2 "ClientHello"?
      # That'd be an unpadded handshake message; we don't
      # bother checking length just now.
      if ((!((self.attr_buf[0] & 0x80)).equal?(0)) && (self.attr_buf[2]).equal?(1))
        # 
        # if the user has disabled SSLv2Hello (using
        # setEnabledProtocol) then throw an
        # exception
        if (!(@hello_version).equal?(ProtocolVersion::SSL20Hello))
          raise SSLHandshakeException.new("SSLv2Hello is disabled")
        end
        record_version = ProtocolVersion.value_of(self.attr_buf[3], self.attr_buf[4])
        if ((record_version).equal?(ProtocolVersion::SSL20Hello))
          # 
          # Looks like a V2 client hello, but not one saying
          # "let's talk SSLv3".  So we send an SSLv2 error
          # message, one that's treated as fatal by clients.
          # (Otherwise we'll hang.)
          begin
            write_buffer(o, V2NoCipher, 0, V2NoCipher.attr_length)
          rescue Exception => e
            # NOTHING
          end
          raise SSLException.new("Unsupported SSL v2.0 ClientHello")
        end
        # 
        # If we can map this into a V3 ClientHello, read and
        # hash the rest of the V2 handshake, turn it into a
        # V3 ClientHello message, and pass it up.
        len = ((self.attr_buf[0] & 0x7f) << 8) + (self.attr_buf[1] & 0xff) - 3
        if ((@v2buf).nil?)
          @v2buf = Array.typed(::Java::Byte).new(len) { 0 }
        end
        if (@exlen < len + self.attr_header_size)
          really = read_fully(s, @v2buf, @exlen - self.attr_header_size, len + self.attr_header_size - @exlen)
          if (really < 0)
            raise EOFException.new("SSL peer shut down incorrectly")
          end
          # now we've got a complete record.
          @exlen = 0
        end
        hash_internal(self.attr_buf, 2, 3)
        hash_internal(@v2buf, 0, len)
        _v2to_v3client_hello(@v2buf)
        @v2buf = nil
        @last_hashed = self.attr_count
        if (!(Debug).nil? && Debug.is_on("record"))
          System.out.println((JavaThread.current_thread.get_name).to_s + ", READ:  SSL v2, contentType = " + (content_name(content_type)).to_s + ", translated length = " + (available).to_s)
        end
        return
      else
        # 
        # Does it look like a V2 "ServerHello"?
        if ((!((self.attr_buf[0] & 0x80)).equal?(0)) && (self.attr_buf[2]).equal?(4))
          raise SSLException.new("SSL V2.0 servers are not supported.")
        end
        # 
        # If this is a V2 NoCipher message then this means
        # the other server doesn't support V3. Otherwise, we just
        # don't understand what it's saying.
        i = 0
        while i < V2NoCipher.attr_length
          if (!(self.attr_buf[i]).equal?(V2NoCipher[i]))
            raise SSLException.new("Unrecognized SSL message, plaintext connection?")
          end
          ((i += 1) - 1)
        end
        raise SSLException.new("SSL V2.0 servers are not supported.")
      end
    end
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Actually do the write here.  For SSLEngine's HS data,
    # we'll override this method and let it take the appropriate
    # action.
    def write_buffer(s, buf, off, len)
      s.write(buf, 0, len)
      s.flush
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Support "old" clients which are capable of SSL V3.0 protocol ... for
    # example, Navigator 3.0 clients.  The V2 message is in the header and
    # the bytes passed as parameter.  This routine translates the V2 message
    # into an equivalent V3 one.
    def _v2to_v3client_hello(v2msg)
      i = 0
      # 
      # Build the first part of the V3 record header from the V2 one
      # that's now buffered up.  (Lengths are fixed up later).
      self.attr_buf[0] = self.attr_ct_handshake
      self.attr_buf[1] = self.attr_buf[3] # V3.x
      self.attr_buf[2] = self.attr_buf[4]
      # header [3..4] for handshake message length
      # count = 5;
      # 
      # Store the generic V3 handshake header:  4 bytes
      self.attr_buf[5] = 1 # HandshakeMessage.ht_client_hello
      # buf [6..8] for length of ClientHello (int24)
      # count += 4;
      # 
      # ClientHello header starts with SSL version
      self.attr_buf[9] = self.attr_buf[1]
      self.attr_buf[10] = self.attr_buf[2]
      # count += 2;
      self.attr_count = 11
      # 
      # Start parsing the V2 message ...
      cipher_spec_len = 0
      session_id_len = 0
      nonce_len = 0
      cipher_spec_len = ((v2msg[0] & 0xff) << 8) + (v2msg[1] & 0xff)
      session_id_len = ((v2msg[2] & 0xff) << 8) + (v2msg[3] & 0xff)
      nonce_len = ((v2msg[4] & 0xff) << 8) + (v2msg[5] & 0xff)
      # 
      # Copy Random value/nonce ... if less than the 32 bytes of
      # a V3 "Random", right justify and zero pad to the left.  Else
      # just take the last 32 bytes.
      offset = 6 + cipher_spec_len + session_id_len
      if (nonce_len < 32)
        i = 0
        while i < (32 - nonce_len)
          self.attr_buf[((self.attr_count += 1) - 1)] = 0
          ((i += 1) - 1)
        end
        System.arraycopy(v2msg, offset, self.attr_buf, self.attr_count, nonce_len)
        self.attr_count += nonce_len
      else
        System.arraycopy(v2msg, offset + (nonce_len - 32), self.attr_buf, self.attr_count, 32)
        self.attr_count += 32
      end
      # 
      # Copy Session ID (only one byte length!)
      offset -= session_id_len
      self.attr_buf[((self.attr_count += 1) - 1)] = session_id_len
      System.arraycopy(v2msg, offset, self.attr_buf, self.attr_count, session_id_len)
      self.attr_count += session_id_len
      # 
      # Copy and translate cipher suites ... V2 specs with first byte zero
      # are really V3 specs (in the last 2 bytes), just copy those and drop
      # the other ones.  Preference order remains unchanged.
      # 
      # Example:  Netscape Navigator 3.0 (exportable) says:
      # 
      # 0/3,     SSL_RSA_EXPORT_WITH_RC4_40_MD5
      # 0/6,     SSL_RSA_EXPORT_WITH_RC2_CBC_40_MD5
      # 
      # Microsoft Internet Explorer 3.0 (exportable) supports only
      # 
      # 0/3,     SSL_RSA_EXPORT_WITH_RC4_40_MD5
      j = 0
      offset -= cipher_spec_len
      j = self.attr_count + 2
      i = 0
      while i < cipher_spec_len
        if (!(v2msg[offset + i]).equal?(0))
          i += 3
          next
        end
        self.attr_buf[((j += 1) - 1)] = v2msg[offset + i + 1]
        self.attr_buf[((j += 1) - 1)] = v2msg[offset + i + 2]
        i += 3
      end
      j -= self.attr_count + 2
      self.attr_buf[((self.attr_count += 1) - 1)] = (j >> 8)
      self.attr_buf[((self.attr_count += 1) - 1)] = j
      self.attr_count += j
      # 
      # Append compression methods (default/null only)
      self.attr_buf[((self.attr_count += 1) - 1)] = 1
      self.attr_buf[((self.attr_count += 1) - 1)] = 0 # Session.compression_null
      # 
      # Fill in lengths of the messages we synthesized (nested:
      # V3 handshake message within V3 record) and then return
      self.attr_buf[3] = (self.attr_count - self.attr_header_size)
      self.attr_buf[4] = ((self.attr_count - self.attr_header_size) >> 8)
      self.attr_buf[self.attr_header_size + 1] = 0
      self.attr_buf[self.attr_header_size + 2] = (((self.attr_count - self.attr_header_size) - 4) >> 8)
      self.attr_buf[self.attr_header_size + 3] = ((self.attr_count - self.attr_header_size) - 4)
      self.attr_pos = self.attr_header_size
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # 
      # Return a description for the given content type. This method should be
      # in Record, but since that is an interface this is not possible.
      # Called from InputRecord and OutputRecord.
      def content_name(content_type_)
        case (content_type_)
        when self.attr_ct_change_cipher_spec
          return "Change Cipher Spec"
        when self.attr_ct_alert
          return "Alert"
        when self.attr_ct_handshake
          return "Handshake"
        when self.attr_ct_application_data
          return "Application Data"
        else
          return "contentType = " + (content_type_).to_s
        end
      end
    }
    
    private
    alias_method :initialize__input_record, :initialize
  end
  
end
