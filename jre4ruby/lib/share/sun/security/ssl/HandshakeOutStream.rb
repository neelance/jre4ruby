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
  module HandshakeOutStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :MessageDigest
    }
  end
  
  # Output stream for handshake data.  This is used only internally
  # to the SSL classes.
  # 
  # MT note:  one thread at a time is presumed be writing handshake
  # messages, but (after initial connection setup) it's possible to
  # have other threads reading/writing application data.  It's the
  # SSLSocketImpl class that synchronizes record writes.
  # 
  # @author  David Brownell
  class HandshakeOutStream < HandshakeOutStreamImports.const_get :OutputStream
    include_class_members HandshakeOutStreamImports
    
    attr_accessor :socket
    alias_method :attr_socket, :socket
    undef_method :socket
    alias_method :attr_socket=, :socket=
    undef_method :socket=
    
    attr_accessor :engine
    alias_method :attr_engine, :engine
    undef_method :engine
    alias_method :attr_engine=, :engine=
    undef_method :engine=
    
    attr_accessor :r
    alias_method :attr_r, :r
    undef_method :r
    alias_method :attr_r=, :r=
    undef_method :r=
    
    typesig { [ProtocolVersion, ProtocolVersion, HandshakeHash, SSLSocketImpl] }
    def initialize(protocol_version, hello_version, handshake_hash, socket)
      @socket = nil
      @engine = nil
      @r = nil
      super()
      @socket = socket
      @r = OutputRecord.new(Record.attr_ct_handshake)
      init(protocol_version, hello_version, handshake_hash)
    end
    
    typesig { [ProtocolVersion, ProtocolVersion, HandshakeHash, SSLEngineImpl] }
    def initialize(protocol_version, hello_version, handshake_hash, engine)
      @socket = nil
      @engine = nil
      @r = nil
      super()
      @engine = engine
      @r = EngineOutputRecord.new(Record.attr_ct_handshake, engine)
      init(protocol_version, hello_version, handshake_hash)
    end
    
    typesig { [ProtocolVersion, ProtocolVersion, HandshakeHash] }
    def init(protocol_version, hello_version, handshake_hash)
      @r.set_version(protocol_version)
      @r.set_hello_version(hello_version)
      @r.set_handshake_hash(handshake_hash)
    end
    
    typesig { [] }
    # Update the handshake data hashes ... mostly for use after a
    # client cert has been sent, so the cert verify message can be
    # constructed correctly yet without forcing extra I/O.  In all
    # other cases, automatic hash calculation suffices.
    def do_hashes
      @r.do_hashes
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Write some data out onto the stream ... buffers as much as possible.
    # Hashes are updated automatically if something gets flushed to the
    # network (e.g. a big cert message etc).
    def write(buf, off, len)
      while (len > 0)
        howmuch = Math.min(len, @r.available_data_bytes)
        if ((howmuch).equal?(0))
          flush
        else
          @r.write(buf, off, howmuch)
          off += howmuch
          len -= howmuch
        end
      end
    end
    
    typesig { [::Java::Int] }
    # write-a-byte
    def write(i)
      if (@r.available_data_bytes < 1)
        flush
      end
      @r.write(i)
    end
    
    typesig { [] }
    def flush
      if (!(@socket).nil?)
        begin
          @socket.write_record(@r)
        rescue IOException => e
          # Had problems writing; check if there was an
          # alert from peer. If alert received, waitForClose
          # will throw an exception for the alert
          @socket.wait_for_close(true)
          # No alert was received, just rethrow exception
          raise e
        end
      else
        # engine != null
        # Even if record might be empty, flush anyway in case
        # there is a finished handshake message that we need
        # to queue.
        @engine.write_record(@r)
      end
    end
    
    typesig { [] }
    # Tell the OutputRecord that a finished message was
    # contained either in this record or the one immeiately
    # preceeding it.  We need to reliably pass back notifications
    # that a finish message occured.
    def set_finished_msg
      raise AssertError if not (((@socket).nil?))
      (@r).set_finished_msg
    end
    
    typesig { [::Java::Int] }
    # Put integers encoded in standard 8, 16, 24, and 32 bit
    # big endian formats. Note that OutputStream.write(int) only
    # writes the least significant 8 bits and ignores the rest.
    def put_int8(i)
      @r.write(i)
    end
    
    typesig { [::Java::Int] }
    def put_int16(i)
      if (@r.available_data_bytes < 2)
        flush
      end
      @r.write(i >> 8)
      @r.write(i)
    end
    
    typesig { [::Java::Int] }
    def put_int24(i)
      if (@r.available_data_bytes < 3)
        flush
      end
      @r.write(i >> 16)
      @r.write(i >> 8)
      @r.write(i)
    end
    
    typesig { [::Java::Int] }
    def put_int32(i)
      if (@r.available_data_bytes < 4)
        flush
      end
      @r.write(i >> 24)
      @r.write(i >> 16)
      @r.write(i >> 8)
      @r.write(i)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Put byte arrays with length encoded as 8, 16, 24 bit
    # integers in big-endian format.
    def put_bytes8(b)
      if ((b).nil?)
        put_int8(0)
        return
      end
      put_int8(b.attr_length)
      write(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def put_bytes16(b)
      if ((b).nil?)
        put_int16(0)
        return
      end
      put_int16(b.attr_length)
      write(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def put_bytes24(b)
      if ((b).nil?)
        put_int24(0)
        return
      end
      put_int24(b.attr_length)
      write(b, 0, b.attr_length)
    end
    
    private
    alias_method :initialize__handshake_out_stream, :initialize
  end
  
end
