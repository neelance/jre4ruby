require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EngineInputRecordImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Nio
      include ::Javax::Net::Ssl
      include_const ::Javax::Crypto, :BadPaddingException
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # Wrapper class around InputRecord.
  # 
  # Application data is kept external to the InputRecord,
  # but handshake data (alert/change_cipher_spec/handshake) will
  # be kept internally in the ByteArrayInputStream.
  # 
  # @author Brad Wetmore
  class EngineInputRecord < EngineInputRecordImports.const_get :InputRecord
    include_class_members EngineInputRecordImports
    
    attr_accessor :engine
    alias_method :attr_engine, :engine
    undef_method :engine
    alias_method :attr_engine=, :engine=
    undef_method :engine=
    
    class_module.module_eval {
      # A dummy ByteBuffer we'll pass back even when the data
      # is stored internally.  It'll never actually be used.
      
      def tmp_bb
        defined?(@@tmp_bb) ? @@tmp_bb : @@tmp_bb= ByteBuffer.allocate(0)
      end
      alias_method :attr_tmp_bb, :tmp_bb
      
      def tmp_bb=(value)
        @@tmp_bb = value
      end
      alias_method :attr_tmp_bb=, :tmp_bb=
    }
    
    # Flag to tell whether the last read/parsed data resides
    # internal in the ByteArrayInputStream, or in the external
    # buffers.
    attr_accessor :internal_data
    alias_method :attr_internal_data, :internal_data
    undef_method :internal_data
    alias_method :attr_internal_data=, :internal_data=
    undef_method :internal_data=
    
    typesig { [SSLEngineImpl] }
    def initialize(engine)
      @engine = nil
      @internal_data = false
      super()
      @engine = engine
    end
    
    typesig { [] }
    def content_type
      if (@internal_data)
        return super
      else
        return self.attr_ct_application_data
      end
    end
    
    typesig { [ByteBuffer] }
    # Check if there is enough inbound data in the ByteBuffer
    # to make a inbound packet.  Look for both SSLv2 and SSLv3.
    # 
    # @return -1 if there are not enough bytes to tell (small header),
    def bytes_in_complete_packet(buf)
      # SSLv2 length field is in bytes 0/1
      # SSLv3/TLS length field is in bytes 3/4
      if (buf.remaining < 5)
        return -1
      end
      pos = buf.position
      byte_zero = buf.get(pos)
      len = 0
      # If we have already verified previous packets, we can
      # ignore the verifications steps, and jump right to the
      # determination.  Otherwise, try one last hueristic to
      # see if it's SSL/TLS.
      if (self.attr_format_verified || ((byte_zero).equal?(self.attr_ct_handshake)) || ((byte_zero).equal?(self.attr_ct_alert)))
        # Last sanity check that it's not a wild record
        record_version = ProtocolVersion.value_of(buf.get(pos + 1), buf.get(pos + 2))
        # Check if too old (currently not possible)
        # or if the major version does not match.
        # The actual version negotiation is in the handshaker classes
        if ((record_version.attr_v < ProtocolVersion::MIN.attr_v) || (record_version.attr_major > ProtocolVersion::MAX.attr_major))
          raise SSLException.new("Unsupported record version " + (record_version).to_s)
        end
        # Reasonably sure this is a V3, disable further checks.
        # We can't do the same in the v2 check below, because
        # read still needs to parse/handle the v2 clientHello.
        self.attr_format_verified = true
        # One of the SSLv3/TLS message types.
        len = ((buf.get(pos + 3) & 0xff) << 8) + (buf.get(pos + 4) & 0xff) + self.attr_header_size
      else
        # Must be SSLv2 or something unknown.
        # Check if it's short (2 bytes) or
        # long (3) header.
        # 
        # Internals can warn about unsupported SSLv2
        is_short = (!((byte_zero & 0x80)).equal?(0))
        if (is_short && (((buf.get(pos + 2)).equal?(1)) || (buf.get(pos + 2)).equal?(4)))
          record_version = ProtocolVersion.value_of(buf.get(pos + 3), buf.get(pos + 4))
          # Check if too old (currently not possible)
          # or if the major version does not match.
          # The actual version negotiation is in the handshaker classes
          if ((record_version.attr_v < ProtocolVersion::MIN.attr_v) || (record_version.attr_major > ProtocolVersion::MAX.attr_major))
            # if it's not SSLv2, we're out of here.
            if (!(record_version.attr_v).equal?(ProtocolVersion::SSL20Hello.attr_v))
              raise SSLException.new("Unsupported record version " + (record_version).to_s)
            end
          end
          # Client or Server Hello
          mask = (is_short ? 0x7f : 0x3f)
          len = ((byte_zero & mask) << 8) + (buf.get(pos + 1) & 0xff) + (is_short ? 2 : 3)
        else
          # Gobblygook!
          raise SSLException.new("Unrecognized SSL message, plaintext connection?")
        end
      end
      return len
    end
    
    typesig { [MAC, ByteBuffer] }
    # Verifies and removes the MAC value.  Returns true if
    # the MAC checks out OK.
    # 
    # On entry:
    # position = beginning of app/MAC data
    # limit = end of MAC data.
    # 
    # On return:
    # position = beginning of app data
    # limit = end of app data
    def check_mac(signer, bb)
      if (@internal_data)
        return check_mac(signer)
      end
      len = signer._maclen
      if ((len).equal?(0))
        # no mac
        return true
      end
      # Grab the original limit
      lim = bb.limit
      # Delineate the area to apply a MAC on.
      mac_data = lim - len
      bb.limit(mac_data)
      mac = signer.compute(content_type, bb)
      if (!(len).equal?(mac.attr_length))
        raise RuntimeException.new("Internal MAC error")
      end
      # Delineate the MAC values, position was already set
      # by doing the compute above.
      # 
      # We could zero the MAC area, but not much useful information
      # there anyway.
      bb.position(mac_data)
      bb.limit(lim)
      begin
        i = 0
        while i < len
          if (!(bb.get).equal?(mac[i]))
            # No BB.equals(byte []); !
            return false
          end
          ((i += 1) - 1)
        end
        return true
      ensure
        # Position to the data.
        bb.rewind
        bb.limit(mac_data)
      end
    end
    
    typesig { [CipherBox, ByteBuffer] }
    # Pass the data down if it's internally cached, otherwise
    # do it here.
    # 
    # If internal data, data is decrypted internally.
    # 
    # If external data(app), return a new ByteBuffer with data to
    # process.
    def decrypt(box, bb)
      if (@internal_data)
        decrypt(box)
        return self.attr_tmp_bb
      end
      box.decrypt(bb)
      bb.rewind
      return bb.slice
    end
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Override the actual write below.  We do things this way to be
    # consistent with InputRecord.  InputRecord may try to write out
    # data to the peer, and *then* throw an Exception.  This forces
    # data to be generated/output before the exception is ever
    # generated.
    def write_buffer(s, buf, off, len)
      # Copy data out of buffer, it's ready to go.
      net_bb = (ByteBuffer.allocate(len).put(buf, 0, len).flip)
      @engine.attr_writer.put_outbound_data_sync(net_bb)
    end
    
    typesig { [ByteBuffer] }
    # Delineate or read a complete packet from src.
    # 
    # If internal data (hs, alert, ccs), the data is read and
    # stored internally.
    # 
    # If external data (app), return a new ByteBuffer which points
    # to the data to process.
    def read(src_bb)
      # Could have a src == null/dst == null check here,
      # but that was already checked by SSLEngine.unwrap before
      # ever attempting to read.
      # 
      # 
      # If we have anything besides application data,
      # or if we haven't even done the initial v2 verification,
      # we send this down to be processed by the underlying
      # internal cache.
      if (!self.attr_format_verified || (!(src_bb.get(src_bb.position)).equal?(self.attr_ct_application_data)))
        @internal_data = true
        read(ByteBufferInputStream.new(src_bb), nil)
        return self.attr_tmp_bb
      end
      @internal_data = false
      src_pos = src_bb.position
      src_lim = src_bb.limit
      record_version = ProtocolVersion.value_of(src_bb.get(src_pos + 1), src_bb.get(src_pos + 2))
      # Check if too old (currently not possible)
      # or if the major version does not match.
      # The actual version negotiation is in the handshaker classes
      if ((record_version.attr_v < ProtocolVersion::MIN.attr_v) || (record_version.attr_major > ProtocolVersion::MAX.attr_major))
        raise SSLException.new("Unsupported record version " + (record_version).to_s)
      end
      # It's really application data.  How much to consume?
      # Jump over the header.
      len = bytes_in_complete_packet(src_bb)
      raise AssertError if not ((len > 0))
      if (!(self.attr_debug).nil? && Debug.is_on("packet"))
        begin
          hd = HexDumpEncoder.new
          src_bb.limit(src_pos + len)
          bb = src_bb.duplicate # Use copy of BB
          System.out.println("[Raw read (bb)]: length = " + (len).to_s)
          hd.encode_buffer(bb, System.out)
        rescue IOException => e
        end
      end
      # Demarcate past header to end of packet.
      src_bb.position(src_pos + self.attr_header_size)
      src_bb.limit(src_pos + len)
      # Protect remainder of buffer, create slice to actually
      # operate on.
      bb = src_bb.slice
      src_bb.position(src_bb.limit)
      src_bb.limit(src_lim)
      return bb
    end
    
    private
    alias_method :initialize__engine_input_record, :initialize
  end
  
end
