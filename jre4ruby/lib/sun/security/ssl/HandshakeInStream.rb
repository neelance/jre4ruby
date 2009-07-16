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
  module HandshakeInStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :MessageDigest
      include_const ::Javax::Net::Ssl, :SSLException
    }
  end
  
  # 
  # InputStream for handshake data, used internally only. Contains the
  # handshake message buffer and methods to parse them.
  # 
  # Once a new handshake record arrives, it is buffered in this class until
  # processed by the Handshaker. The buffer may also contain incomplete
  # handshake messages in case the message is split across multiple records.
  # Handshaker.process_record deals with all that. It may also contain
  # handshake messages larger than the default buffer size (e.g. large
  # certificate messages). The buffer is grown dynamically to handle that
  # (see InputRecord.queueHandshake()).
  # 
  # Note that the InputRecord used as a buffer here is separate from the
  # AppInStream.r, which is where data from the socket is initially read
  # into. This is because once the initial handshake has been completed,
  # handshake and application data messages may be interleaved arbitrarily
  # and must be processed independently.
  # 
  # @author David Brownell
  class HandshakeInStream < HandshakeInStreamImports.const_get :InputStream
    include_class_members HandshakeInStreamImports
    
    attr_accessor :r
    alias_method :attr_r, :r
    undef_method :r
    alias_method :attr_r=, :r=
    undef_method :r=
    
    typesig { [HandshakeHash] }
    # 
    # Construct the stream; we'll be accumulating hashes of the
    # input records using two sets of digests.
    def initialize(handshake_hash)
      @r = nil
      super()
      @r = InputRecord.new
      @r.set_handshake_hash(handshake_hash)
    end
    
    typesig { [] }
    # overridden InputStream methods
    # 
    # Return the number of bytes available for read().
    # 
    # Note that this returns the bytes remaining in the buffer, not
    # the bytes remaining in the current handshake message.
    def available
      return @r.available
    end
    
    typesig { [] }
    # 
    # Get a byte of handshake data.
    def read
      n = @r.read
      if ((n).equal?(-1))
        raise SSLException.new("Unexpected end of handshake data")
      end
      return n
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Get a bunch of bytes of handshake data.
    def read(b, off, len)
      # we read from a ByteArrayInputStream, it always returns the
      # data in a single read if enough is available
      n = @r.read(b, off, len)
      if (!(n).equal?(len))
        raise SSLException.new("Unexpected end of handshake data")
      end
      return n
    end
    
    typesig { [::Java::Long] }
    # 
    # Skip some handshake data.
    def skip(n)
      return @r.skip(n)
    end
    
    typesig { [::Java::Int] }
    # 
    # Mark/ reset code, implemented using InputRecord mark/ reset.
    # 
    # Note that it currently provides only a limited mark functionality
    # and should be used with care (once a new handshake record has been
    # read, data that has already been consumed is lost even if marked).
    def mark(readlimit)
      @r.mark(readlimit)
    end
    
    typesig { [] }
    def reset
      @r.reset
    end
    
    typesig { [] }
    def mark_supported
      return true
    end
    
    typesig { [InputRecord] }
    # handshake management functions
    # 
    # Here's an incoming record with handshake data.  Queue the contents;
    # it might be one or more entire messages, complete a message that's
    # partly queued, or both.
    def incoming_record(in_)
      @r.queue_handshake(in_)
    end
    
    typesig { [] }
    # 
    # Hash any data we've consumed but not yet hashed.  Useful mostly
    # for processing client certificate messages (so we can check the
    # immediately following cert verify message) and finished messages
    # (so we can compute our own finished message).
    def digest_now
      @r.do_hashes
    end
    
    typesig { [::Java::Int] }
    # 
    # Do more than skip that handshake data ... totally ignore it.
    # The difference is that the data does not get hashed.
    def ignore(n)
      @r.ignore(n)
    end
    
    typesig { [] }
    # Message parsing methods
    # 
    # Read 8, 16, 24, and 32 bit SSL integer data types, encoded
    # in standard big-endian form.
    def get_int8
      return read
    end
    
    typesig { [] }
    def get_int16
      return (get_int8 << 8) | get_int8
    end
    
    typesig { [] }
    def get_int24
      return (get_int8 << 16) | (get_int8 << 8) | get_int8
    end
    
    typesig { [] }
    def get_int32
      return (get_int8 << 24) | (get_int8 << 16) | (get_int8 << 8) | get_int8
    end
    
    typesig { [] }
    # 
    # Read byte vectors with 8, 16, and 24 bit length encodings.
    def get_bytes8
      len = get_int8
      b = Array.typed(::Java::Byte).new(len) { 0 }
      read(b, 0, len)
      return b
    end
    
    typesig { [] }
    def get_bytes16
      len = get_int16
      b = Array.typed(::Java::Byte).new(len) { 0 }
      read(b, 0, len)
      return b
    end
    
    typesig { [] }
    def get_bytes24
      len = get_int24
      b = Array.typed(::Java::Byte).new(len) { 0 }
      read(b, 0, len)
      return b
    end
    
    private
    alias_method :initialize__handshake_in_stream, :initialize
  end
  
end
