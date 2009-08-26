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
  module EngineOutputRecordImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Nio
      include_const ::Javax::Net::Ssl, :SSLException
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # A OutputRecord class extension which uses external ByteBuffers
  # or the internal ByteArrayOutputStream for data manipulations.
  # <P>
  # Instead of rewriting this entire class
  # to use ByteBuffers, we leave things intact, so handshake, CCS,
  # and alerts will continue to use the internal buffers, but application
  # data will use external buffers.
  # 
  # @author Brad Wetmore
  class EngineOutputRecord < EngineOutputRecordImports.const_get :OutputRecord
    include_class_members EngineOutputRecordImports
    
    attr_accessor :writer
    alias_method :attr_writer, :writer
    undef_method :writer
    alias_method :attr_writer=, :writer=
    undef_method :writer=
    
    attr_accessor :finished_msg
    alias_method :attr_finished_msg, :finished_msg
    undef_method :finished_msg
    alias_method :attr_finished_msg=, :finished_msg=
    undef_method :finished_msg=
    
    typesig { [::Java::Byte, SSLEngineImpl] }
    # All handshake hashing is done by the superclass
    # 
    # 
    # Default constructor makes a record supporting the maximum
    # SSL record size.  It allocates the header bytes directly.
    # 
    # @param type the content type for the record
    def initialize(type, engine)
      @writer = nil
      @finished_msg = false
      super(type, record_size(type))
      @finished_msg = false
      @writer = engine.attr_writer
    end
    
    class_module.module_eval {
      typesig { [::Java::Byte] }
      # Get the size of the buffer we need for records of the specified
      # type.
      # <P>
      # Application data buffers will provide their own byte buffers,
      # and will not use the internal byte caching.
      def record_size(type)
        case (type)
        when self.attr_ct_change_cipher_spec, self.attr_ct_alert
          return self.attr_max_alert_record_size
        when self.attr_ct_handshake
          return self.attr_max_record_size
        when self.attr_ct_application_data
          return 0
        end
        raise RuntimeException.new("Unknown record type: " + RJava.cast_to_string(type))
      end
    }
    
    typesig { [] }
    def set_finished_msg
      @finished_msg = true
    end
    
    typesig { [] }
    def flush
      @finished_msg = false
    end
    
    typesig { [] }
    def is_finished_msg
      return @finished_msg
    end
    
    typesig { [MAC, ByteBuffer] }
    # Calculate the MAC value, storing the result either in
    # the internal buffer, or at the end of the destination
    # ByteBuffer.
    # <P>
    # We assume that the higher levels have assured us enough
    # room, otherwise we'll indirectly throw a
    # BufferOverFlowException runtime exception.
    # 
    # position should equal limit, and points to the next
    # free spot.
    def add_mac(signer, bb)
      if (!(signer._maclen).equal?(0))
        hash = signer.compute(content_type, bb)
        # position was advanced to limit in compute above.
        # 
        # Mark next area as writable (above layers should have
        # established that we have plenty of room), then write
        # out the hash.
        bb.limit(bb.limit + hash.attr_length)
        bb.put(hash)
      end
    end
    
    typesig { [CipherBox, ByteBuffer] }
    # Encrypt a ByteBuffer.
    # 
    # We assume that the higher levels have assured us enough
    # room for the encryption (plus padding), otherwise we'll
    # indirectly throw a BufferOverFlowException runtime exception.
    # 
    # position and limit will be the same, and points to the
    # next free spot.
    def encrypt(box, bb)
      box.encrypt(bb)
    end
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Override the actual write below.  We do things this way to be
    # consistent with InputRecord.  InputRecord may try to write out
    # data to the peer, and *then* throw an Exception.  This forces
    # data to be generated/output before the exception is ever
    # generated.
    def write_buffer(s, buf, off, len)
      # Copy data out of buffer, it's ready to go.
      net_bb = ByteBuffer.allocate(len).put(buf, 0, len).flip
      @writer.put_outbound_data(net_bb)
    end
    
    typesig { [MAC, CipherBox] }
    # Main method for writing non-application data.
    # We MAC/encrypt, then send down for processing.
    def write(write_mac, write_cipher)
      # Sanity check.
      case (content_type)
      when self.attr_ct_change_cipher_spec, self.attr_ct_alert, self.attr_ct_handshake
      else
        raise RuntimeException.new("unexpected byte buffers")
      end
      # Don't bother to really write empty records.  We went this
      # far to drive the handshake machinery, for correctness; not
      # writing empty records improves performance by cutting CPU
      # time and network resource usage.  Also, some protocol
      # implementations are fragile and don't like to see empty
      # records, so this increases robustness.
      # 
      # (Even change cipher spec messages have a byte of data!)
      if (!is_empty)
        # compress();              // eventually
        add_mac(write_mac)
        encrypt(write_cipher)
        write(nil) # send down for processing
      end
      return
    end
    
    typesig { [EngineArgs, MAC, CipherBox] }
    # Main wrap/write driver.
    def write(ea, write_mac, write_cipher)
      # sanity check to make sure someone didn't inadvertantly
      # send us an impossible combination we don't know how
      # to process.
      raise AssertError if not (((content_type).equal?(self.attr_ct_application_data)))
      # Have we set the MAC's yet?  If not, we're not ready
      # to process application data yet.
      if ((write_mac).equal?(MAC.attr_null))
        return
      end
      # Don't bother to really write empty records.  We went this
      # far to drive the handshake machinery, for correctness; not
      # writing empty records improves performance by cutting CPU
      # time and network resource usage.  Also, some protocol
      # implementations are fragile and don't like to see empty
      # records, so this increases robustness.
      length = Math.min(ea.get_app_remaining, self.attr_max_data_size)
      if ((length).equal?(0))
        return
      end
      # Copy out existing buffer values.
      dst_bb = ea.attr_net_data
      dst_pos = dst_bb.position
      dst_lim = dst_bb.limit
      # Where to put the data.  Jump over the header.
      # 
      # Don't need to worry about SSLv2 rewrites, if we're here,
      # that's long since done.
      dst_data = dst_pos + self.attr_header_size
      dst_bb.position(dst_data)
      ea.gather(length)
      # "flip" but skip over header again, add MAC & encrypt
      # addMAC will expand the limit to reflect the new
      # data.
      dst_bb.limit(dst_bb.position)
      dst_bb.position(dst_data)
      add_mac(write_mac, dst_bb)
      # Encrypt may pad, so again the limit may have changed.
      dst_bb.limit(dst_bb.position)
      dst_bb.position(dst_data)
      encrypt(write_cipher, dst_bb)
      if (!(self.attr_debug).nil? && (Debug.is_on("record") || Debug.is_on("handshake")))
        if ((!(self.attr_debug).nil? && Debug.is_on("record")) || (content_type).equal?(self.attr_ct_change_cipher_spec))
          # v3.0/v3.1 ...
          System.out.println(RJava.cast_to_string(JavaThread.current_thread.get_name) + ", WRITE: " + RJava.cast_to_string(self.attr_protocol_version) + " " + RJava.cast_to_string(InputRecord.content_name(content_type)) + ", length = " + RJava.cast_to_string(length))
        end
      end
      packet_length = dst_bb.limit - dst_data
      # Finish out the record header.
      dst_bb.put(dst_pos, content_type)
      dst_bb.put(dst_pos + 1, self.attr_protocol_version.attr_major)
      dst_bb.put(dst_pos + 2, self.attr_protocol_version.attr_minor)
      dst_bb.put(dst_pos + 3, (packet_length >> 8))
      dst_bb.put(dst_pos + 4, packet_length)
      # Position was already set by encrypt() above.
      dst_bb.limit(dst_lim)
      return
    end
    
    private
    alias_method :initialize__engine_output_record, :initialize
  end
  
end
