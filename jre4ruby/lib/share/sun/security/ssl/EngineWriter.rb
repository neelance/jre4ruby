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
  module EngineWriterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Javax::Net::Ssl
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Util, :LinkedList
      include_const ::Javax::Net::Ssl::SSLEngineResult, :HandshakeStatus
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # A class to help abstract away SSLEngine writing synchronization.
  class EngineWriter 
    include_class_members EngineWriterImports
    
    # Outgoing handshake Data waiting for a ride is stored here.
    # Normal application data is written directly into the outbound
    # buffer, but handshake data can be written out at any time,
    # so we have buffer it somewhere.
    # 
    # When wrap is called, we first check to see if there is
    # any data waiting, then if we're in a data transfer state,
    # we try to write app data.
    # 
    # This will contain either ByteBuffers, or the marker
    # HandshakeStatus.FINISHED to signify that a handshake just completed.
    attr_accessor :outbound_list
    alias_method :attr_outbound_list, :outbound_list
    undef_method :outbound_list
    alias_method :attr_outbound_list=, :outbound_list=
    undef_method :outbound_list=
    
    attr_accessor :outbound_closed
    alias_method :attr_outbound_closed, :outbound_closed
    undef_method :outbound_closed
    alias_method :attr_outbound_closed=, :outbound_closed=
    undef_method :outbound_closed=
    
    class_module.module_eval {
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    typesig { [] }
    def initialize
      @outbound_list = nil
      @outbound_closed = false
      @outbound_list = LinkedList.new
    end
    
    typesig { [ByteBuffer] }
    # Upper levels assured us we had room for at least one packet of data.
    # As per the SSLEngine spec, we only return one SSL packets worth of
    # data.
    def get_outbound_data(dst_bb)
      msg = @outbound_list.remove_first
      raise AssertError if not ((msg.is_a?(ByteBuffer)))
      bb_in = msg
      raise AssertError if not ((dst_bb.remaining >= bb_in.remaining))
      dst_bb.put(bb_in)
      # If we have more data in the queue, it's either
      # a finished message, or an indication that we need
      # to call wrap again.
      if (has_outbound_data_internal)
        msg = @outbound_list.get_first
        if ((msg).equal?(HandshakeStatus::FINISHED))
          @outbound_list.remove_first # consume the message
          return HandshakeStatus::FINISHED
        else
          return HandshakeStatus::NEED_WRAP
        end
      else
        return nil
      end
    end
    
    typesig { [EngineOutputRecord, MAC, CipherBox] }
    # Properly orders the output of the data written to the wrap call.
    # This is only handshake data, application data goes through the
    # other writeRecord.
    def write_record(output_record, write_mac, write_cipher)
      synchronized(self) do
        # Only output if we're still open.
        if (@outbound_closed)
          raise IOException.new("writer side was already closed.")
        end
        output_record.write(write_mac, write_cipher)
        # Did our handshakers notify that we just sent the
        # Finished message?
        # 
        # Add an "I'm finished" message to the queue.
        if (output_record.is_finished_msg)
          @outbound_list.add_last(HandshakeStatus::FINISHED)
        end
      end
    end
    
    typesig { [EngineArgs, ::Java::Boolean] }
    # Output the packet info.
    def dump_packet(ea, hs_data)
      begin
        hd = HexDumpEncoder.new
        bb = ea.attr_net_data.duplicate
        pos = bb.position
        bb.position(pos - ea.delta_net)
        bb.limit(pos)
        System.out.println("[Raw write" + RJava.cast_to_string((hs_data ? "" : " (bb)")) + "]: length = " + RJava.cast_to_string(bb.remaining))
        hd.encode_buffer(bb, System.out)
      rescue IOException => e
      end
    end
    
    typesig { [EngineOutputRecord, EngineArgs, MAC, CipherBox] }
    # Properly orders the output of the data written to the wrap call.
    # Only app data goes through here, handshake data goes through
    # the other writeRecord.
    # 
    # Shouldn't expect to have an IOException here.
    # 
    # Return any determined status.
    def write_record(output_record, ea, write_mac, write_cipher)
      synchronized(self) do
        # If we have data ready to go, output this first before
        # trying to consume app data.
        if (has_outbound_data_internal)
          hss = get_outbound_data(ea.attr_net_data)
          if (!(Debug).nil? && Debug.is_on("packet"))
            # We could have put the dump in
            # OutputRecord.write(OutputStream), but let's actually
            # output when it's actually output by the SSLEngine.
            dump_packet(ea, true)
          end
          return hss
        end
        # If we are closed, no more app data can be output.
        # Only existing handshake data (above) can be obtained.
        if (@outbound_closed)
          raise IOException.new("The write side was already closed")
        end
        output_record.write(ea, write_mac, write_cipher)
        if (!(Debug).nil? && Debug.is_on("packet"))
          dump_packet(ea, false)
        end
        # No way new outbound handshake data got here if we're
        # locked properly.
        # 
        # We don't have any status we can return.
        return nil
      end
    end
    
    typesig { [ByteBuffer] }
    # We already hold "this" lock, this is the callback from the
    # outputRecord.write() above.  We already know this
    # writer can accept more data (outboundClosed == false),
    # and the closure is sync'd.
    def put_outbound_data(bytes)
      @outbound_list.add_last(bytes)
    end
    
    typesig { [ByteBuffer] }
    # This is for the really rare case that someone is writing from
    # the *InputRecord* before we know what to do with it.
    def put_outbound_data_sync(bytes)
      synchronized(self) do
        if (@outbound_closed)
          raise IOException.new("Write side already closed")
        end
        @outbound_list.add_last(bytes)
      end
    end
    
    typesig { [] }
    # Non-synch'd version of this method, called by internals
    def has_outbound_data_internal
      return (!(@outbound_list.size).equal?(0))
    end
    
    typesig { [] }
    def has_outbound_data
      synchronized(self) do
        return has_outbound_data_internal
      end
    end
    
    typesig { [] }
    def is_outbound_done
      synchronized(self) do
        return @outbound_closed && !has_outbound_data_internal
      end
    end
    
    typesig { [] }
    def close_outbound
      synchronized(self) do
        @outbound_closed = true
      end
    end
    
    private
    alias_method :initialize__engine_writer, :initialize
  end
  
end
