require "rjava"

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
  module OutputRecordImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Nio
      include_const ::Javax::Net::Ssl, :SSLException
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # SSL 3.0 records, as written to a TCP stream.
  # 
  # Each record has a message area that starts out with data supplied by the
  # application.  It may grow/shrink due to compression and will be modified
  # in place for mac-ing and encryption.
  # 
  # Handshake records have additional needs, notably accumulation of a set
  # of hashes which are used to establish that handshaking was done right.
  # Handshake records usually have several handshake messages each, and we
  # need message-level control over what's hashed.
  # 
  # @author David Brownell
  class OutputRecord < OutputRecordImports.const_get :ByteArrayOutputStream
    include_class_members OutputRecordImports
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
    
    attr_accessor :first_message
    alias_method :attr_first_message, :first_message
    undef_method :first_message
    alias_method :attr_first_message=, :first_message=
    undef_method :first_message=
    
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    # current protocol version, sent as record version
    attr_accessor :protocol_version
    alias_method :attr_protocol_version, :protocol_version
    undef_method :protocol_version
    alias_method :attr_protocol_version=, :protocol_version=
    undef_method :protocol_version=
    
    # version for the ClientHello message. Only relevant if this is a
    # client handshake record. If set to ProtocolVersion.SSL20Hello,
    # the V3 client hello is converted to V2 format.
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
    
    typesig { [::Java::Byte, ::Java::Int] }
    # Default constructor makes a record supporting the maximum
    # SSL record size.  It allocates the header bytes directly.
    # 
    # @param type the content type for the record
    def initialize(type, size)
      @handshake_hash = nil
      @last_hashed = 0
      @first_message = false
      @content_type = 0
      @protocol_version = nil
      @hello_version = nil
      super(size)
      @protocol_version = ProtocolVersion::DEFAULT
      @hello_version = ProtocolVersion::DEFAULT_HELLO
      @first_message = true
      self.attr_count = self.attr_header_size
      @content_type = type
      @last_hashed = self.attr_count
    end
    
    typesig { [::Java::Byte] }
    def initialize(type)
      initialize__output_record(type, record_size(type))
    end
    
    class_module.module_eval {
      typesig { [::Java::Byte] }
      # Get the size of the buffer we need for records of the specified
      # type.
      def record_size(type)
        if (((type).equal?(self.attr_ct_change_cipher_spec)) || ((type).equal?(self.attr_ct_alert)))
          return self.attr_max_alert_record_size
        else
          return self.attr_max_record_size
        end
      end
    }
    
    typesig { [ProtocolVersion] }
    # Updates the SSL version of this record.
    def set_version(protocol_version)
      synchronized(self) do
        @protocol_version = protocol_version
      end
    end
    
    typesig { [ProtocolVersion] }
    # Updates helloVersion of this record.
    def set_hello_version(hello_version)
      synchronized(self) do
        @hello_version = hello_version
      end
    end
    
    typesig { [] }
    # Reset the record so that it can be refilled, starting
    # immediately after the header.
    def reset
      synchronized(self) do
        super
        self.attr_count = self.attr_header_size
        @last_hashed = self.attr_count
      end
    end
    
    typesig { [HandshakeHash] }
    # For handshaking, we need to be able to hash every byte above the
    # record marking layer.  This is where we're guaranteed to see those
    # bytes, so this is where we can hash them.
    def set_handshake_hash(handshake_hash)
      raise AssertError if not (((@content_type).equal?(self.attr_ct_handshake)))
      @handshake_hash = handshake_hash
    end
    
    typesig { [] }
    # We hash (the plaintext) on demand.  There is one place where
    # we want to access the hash in the middle of a record:  client
    # cert message gets hashed, and part of the same record is the
    # client cert verify message which uses that hash.  So we track
    # how much of each record we've hashed so far.
    def do_hashes
      len = self.attr_count - @last_hashed
      if (len > 0)
        hash_internal(self.attr_buf, @last_hashed, len)
        @last_hashed = self.attr_count
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Need a helper function so we can hash the V2 hello correctly
    def hash_internal(buf, offset, len)
      if (!(Debug).nil? && Debug.is_on("data"))
        begin
          hd = HexDumpEncoder.new
          System.out.println("[write] MD5 and SHA1 hashes:  len = " + (len).to_s)
          hd.encode_buffer(ByteArrayInputStream.new(buf, @last_hashed, len), System.out)
        rescue IOException => e
        end
      end
      @handshake_hash.update(buf, @last_hashed, len)
      @last_hashed = self.attr_count
    end
    
    typesig { [] }
    # Return true iff the record is empty -- to avoid doing the work
    # of sending empty records over the network.
    def is_empty
      return (self.attr_count).equal?(self.attr_header_size)
    end
    
    typesig { [::Java::Byte] }
    # Return true if the record is of a given alert.
    def is_alert(description)
      # An alert is defined with a two bytes struct,
      # {byte level, byte description}, following after the header bytes.
      if (self.attr_count > (self.attr_header_size + 1) && (@content_type).equal?(self.attr_ct_alert))
        return (self.attr_buf[self.attr_header_size + 1]).equal?(description)
      end
      return false
    end
    
    typesig { [MAC] }
    # Compute the MAC and append it to this record.  In case we
    # are automatically flushing a handshake stream, make sure we
    # have hashed the message first.
    def add_mac(signer)
      # when we support compression, hashing can't go here
      # since it'll need to be done on the uncompressed data,
      # and the MAC applies to the compressed data.
      if ((@content_type).equal?(self.attr_ct_handshake))
        do_hashes
      end
      if (!(signer._maclen).equal?(0))
        hash = signer.compute(@content_type, self.attr_buf, self.attr_header_size, self.attr_count - self.attr_header_size)
        write(hash)
      end
    end
    
    typesig { [CipherBox] }
    # Encrypt ... length may grow due to block cipher padding
    def encrypt(box)
      len = self.attr_count - self.attr_header_size
      self.attr_count = self.attr_header_size + box.encrypt(self.attr_buf, self.attr_header_size, len)
    end
    
    typesig { [] }
    # Tell how full the buffer is ... for filling it with application or
    # handshake data.
    def available_data_bytes
      data_size = self.attr_count - self.attr_header_size
      return self.attr_max_data_size - data_size
    end
    
    typesig { [] }
    # Return the type of SSL record that's buffered here.
    def content_type
      return @content_type
    end
    
    typesig { [OutputStream] }
    # Write the record out on the stream.  Note that you must have (in
    # order) compressed the data, appended the MAC, and encrypted it in
    # order for the record to be understood by the other end.  (Some of
    # those steps will be null early in handshaking.)
    # 
    # Note that this does no locking for the connection, it's required
    # that synchronization be done elsewhere.  Also, this does its work
    # in a single low level write, for efficiency.
    def write(s)
      # Don't emit content-free records.  (Even change cipher spec
      # messages have a byte of data!)
      if ((self.attr_count).equal?(self.attr_header_size))
        return
      end
      length = self.attr_count - self.attr_header_size
      # "should" really never write more than about 14 Kb...
      if (length < 0)
        raise SSLException.new("output record size too small: " + (length).to_s)
      end
      if (!(Debug).nil? && (Debug.is_on("record") || Debug.is_on("handshake")))
        if ((!(Debug).nil? && Debug.is_on("record")) || (content_type).equal?(self.attr_ct_change_cipher_spec))
          # v3.0/v3.1 ...
          System.out.println((JavaThread.current_thread.get_name).to_s + ", WRITE: " + (@protocol_version).to_s + " " + (InputRecord.content_name(content_type)).to_s + ", length = " + (length).to_s)
        end
      end
      # If this is the initial ClientHello on this connection and
      # we're not trying to resume a (V3) session then send a V2
      # ClientHello instead so we can detect V2 servers cleanly.
      if (@first_message && use_v2hello)
        v3msg = Array.typed(::Java::Byte).new(length - 4) { 0 }
        System.arraycopy(self.attr_buf, self.attr_header_size + 4, v3msg, 0, v3msg.attr_length)
        _v3to_v2client_hello(v3msg)
        @handshake_hash.reset
        @last_hashed = 2
        do_hashes
        if (!(Debug).nil? && Debug.is_on("record"))
          System.out.println((JavaThread.current_thread.get_name).to_s + ", WRITE: SSLv2 client hello message" + ", length = " + ((self.attr_count - 2)).to_s) # 2 byte SSLv2 header
        end
      else
        # Fill out the header, write it and the message.
        self.attr_buf[0] = @content_type
        self.attr_buf[1] = @protocol_version.attr_major
        self.attr_buf[2] = @protocol_version.attr_minor
        self.attr_buf[3] = (length >> 8)
        self.attr_buf[4] = (length)
      end
      @first_message = false
      write_buffer(s, self.attr_buf, 0, self.attr_count)
      reset
    end
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Actually do the write here.  For SSLEngine's HS data,
    # we'll override this method and let it take the appropriate
    # action.
    def write_buffer(s, buf, off, len)
      s.write(buf, off, len)
      s.flush
      if (!(Debug).nil? && Debug.is_on("packet"))
        begin
          hd = HexDumpEncoder.new
          bb = ByteBuffer.wrap(buf, off, len)
          System.out.println("[Raw write]: length = " + (bb.remaining).to_s)
          hd.encode_buffer(bb, System.out)
        rescue IOException => e
        end
      end
    end
    
    typesig { [] }
    # Return whether the buffer contains a ClientHello message that should
    # be converted to V2 format.
    def use_v2hello
      return @first_message && ((@hello_version).equal?(ProtocolVersion::SSL20Hello)) && ((@content_type).equal?(self.attr_ct_handshake)) && ((self.attr_buf[5]).equal?(HandshakeMessage.attr_ht_client_hello)) && ((self.attr_buf[self.attr_header_size + 4 + 2 + 32]).equal?(0)) # V3 session ID is empty
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Detect "old" servers which are capable of SSL V2.0 protocol ... for
    # example, Netscape Commerce 1.0 servers.  The V3 message is in the
    # header and the bytes passed as parameter.  This routine translates
    # the V3 message into an equivalent V2 one.
    def _v3to_v2client_hello(v3msg)
      v3session_id_len_offset = 2 + 32 # version + nonce
      v3session_id_len = v3msg[v3session_id_len_offset]
      v3cipher_spec_len_offset = v3session_id_len_offset + 1 + v3session_id_len
      v3cipher_spec_len = ((v3msg[v3cipher_spec_len_offset] & 0xff) << 8) + (v3msg[v3cipher_spec_len_offset + 1] & 0xff)
      cipher_specs = v3cipher_spec_len / 2 # 2 bytes each in V3
      # Copy over the cipher specs. We don't care about actually translating
      # them for use with an actual V2 server since we only talk V3.
      # Therefore, just copy over the V3 cipher spec values with a leading
      # 0.
      v3cipher_spec_offset = v3cipher_spec_len_offset + 2 # skip length
      v2cipher_spec_len = 0
      self.attr_count = 11
      i = 0
      while i < cipher_specs
        byte1 = 0
        byte2 = 0
        byte1 = v3msg[((v3cipher_spec_offset += 1) - 1)]
        byte2 = v3msg[((v3cipher_spec_offset += 1) - 1)]
        v2cipher_spec_len += _v3to_v2cipher_suite(byte1, byte2)
        i += 1
      end
      # Build the first part of the V3 record header from the V2 one
      # that's now buffered up.  (Lengths are fixed up later).
      self.attr_buf[2] = HandshakeMessage.attr_ht_client_hello
      self.attr_buf[3] = v3msg[0] # major version
      self.attr_buf[4] = v3msg[1] # minor version
      self.attr_buf[5] = (v2cipher_spec_len >> 8)
      self.attr_buf[6] = v2cipher_spec_len
      self.attr_buf[7] = 0
      self.attr_buf[8] = 0 # always no session
      self.attr_buf[9] = 0
      self.attr_buf[10] = 32 # nonce length (always 32 in V3)
      # Copy in the nonce.
      System.arraycopy(v3msg, 2, self.attr_buf, self.attr_count, 32)
      self.attr_count += 32
      # Set the length of the message.
      self.attr_count -= 2 # don't include length field itself
      self.attr_buf[0] = (self.attr_count >> 8)
      self.attr_buf[0] |= 0x80
      self.attr_buf[1] = (self.attr_count)
      self.attr_count += 2
    end
    
    class_module.module_eval {
      # Mappings from V3 cipher suite encodings to their pure V2 equivalents.
      # This is taken from the SSL V3 specification, Appendix E.
      
      def v3to_v2cipher_map1
        defined?(@@v3to_v2cipher_map1) ? @@v3to_v2cipher_map1 : @@v3to_v2cipher_map1= Array.typed(::Java::Int).new([-1, -1, -1, 0x2, 0x1, -1, 0x4, 0x5, -1, 0x6, 0x7])
      end
      alias_method :attr_v3to_v2cipher_map1, :v3to_v2cipher_map1
      
      def v3to_v2cipher_map1=(value)
        @@v3to_v2cipher_map1 = value
      end
      alias_method :attr_v3to_v2cipher_map1=, :v3to_v2cipher_map1=
      
      
      def v3to_v2cipher_map3
        defined?(@@v3to_v2cipher_map3) ? @@v3to_v2cipher_map3 : @@v3to_v2cipher_map3= Array.typed(::Java::Int).new([-1, -1, -1, 0x80, 0x80, -1, 0x80, 0x80, -1, 0x40, 0xc0])
      end
      alias_method :attr_v3to_v2cipher_map3, :v3to_v2cipher_map3
      
      def v3to_v2cipher_map3=(value)
        @@v3to_v2cipher_map3 = value
      end
      alias_method :attr_v3to_v2cipher_map3=, :v3to_v2cipher_map3=
    }
    
    typesig { [::Java::Byte, ::Java::Byte] }
    # See which matching pure-V2 cipher specs we need to include.
    # We are including these not because we are actually prepared
    # to talk V2 but because the Oracle Web Server insists on receiving
    # at least 1 "pure V2" cipher suite that it supports and returns an
    # illegal_parameter alert unless one is present. Rather than mindlessly
    # claiming to implement all documented pure V2 cipher suites the code below
    # just claims to implement the V2 cipher suite that is "equivalent"
    # in terms of cipher algorithm & exportability with the actual V3 cipher
    # suite that we do support.
    def _v3to_v2cipher_suite(byte1, byte2)
      self.attr_buf[((self.attr_count += 1) - 1)] = 0
      self.attr_buf[((self.attr_count += 1) - 1)] = byte1
      self.attr_buf[((self.attr_count += 1) - 1)] = byte2
      if (((byte2 & 0xff) > 0xa) || ((self.attr_v3to_v2cipher_map1[byte2]).equal?(-1)))
        return 3
      end
      self.attr_buf[((self.attr_count += 1) - 1)] = self.attr_v3to_v2cipher_map1[byte2]
      self.attr_buf[((self.attr_count += 1) - 1)] = 0
      self.attr_buf[((self.attr_count += 1) - 1)] = self.attr_v3to_v2cipher_map3[byte2]
      return 6
    end
    
    private
    alias_method :initialize__output_record, :initialize
  end
  
end
