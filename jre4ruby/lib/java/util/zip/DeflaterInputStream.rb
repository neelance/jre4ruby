require "rjava"

# 
# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Zip
  module DeflaterInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :FilterInputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # 
  # Implements an input stream filter for compressing data in the "deflate"
  # compression format.
  # 
  # @since       1.6
  # @author      David R Tribble (david@tribble.com)
  # 
  # @see DeflaterOutputStream
  # @see InflaterOutputStream
  # @see InflaterInputStream
  class DeflaterInputStream < DeflaterInputStreamImports.const_get :FilterInputStream
    include_class_members DeflaterInputStreamImports
    
    # Compressor for this stream.
    attr_accessor :def
    alias_method :attr_def, :def
    undef_method :def
    alias_method :attr_def=, :def=
    undef_method :def=
    
    # Input buffer for reading compressed data.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # Temporary read buffer.
    attr_accessor :rbuf
    alias_method :attr_rbuf, :rbuf
    undef_method :rbuf
    alias_method :attr_rbuf=, :rbuf=
    undef_method :rbuf=
    
    # Default compressor is used.
    attr_accessor :uses_default_deflater
    alias_method :attr_uses_default_deflater, :uses_default_deflater
    undef_method :uses_default_deflater
    alias_method :attr_uses_default_deflater=, :uses_default_deflater=
    undef_method :uses_default_deflater=
    
    # End of the underlying input stream has been reached.
    attr_accessor :reach_eof
    alias_method :attr_reach_eof, :reach_eof
    undef_method :reach_eof
    alias_method :attr_reach_eof=, :reach_eof=
    undef_method :reach_eof=
    
    typesig { [] }
    # 
    # Check to make sure that this stream has not been closed.
    def ensure_open
      if ((self.attr_in).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [InputStream] }
    # 
    # Creates a new input stream with a default compressor and buffer
    # size.
    # 
    # @param in input stream to read the uncompressed data to
    # @throws NullPointerException if {@code in} is null
    def initialize(in_)
      initialize__deflater_input_stream(in_, Deflater.new)
      @uses_default_deflater = true
    end
    
    typesig { [InputStream, Deflater] }
    # 
    # Creates a new input stream with the specified compressor and a
    # default buffer size.
    # 
    # @param in input stream to read the uncompressed data to
    # @param defl compressor ("deflater") for this stream
    # @throws NullPointerException if {@code in} or {@code defl} is null
    def initialize(in_, defl)
      initialize__deflater_input_stream(in_, defl, 512)
    end
    
    typesig { [InputStream, Deflater, ::Java::Int] }
    # 
    # Creates a new input stream with the specified compressor and buffer
    # size.
    # 
    # @param in input stream to read the uncompressed data to
    # @param defl compressor ("deflater") for this stream
    # @param bufLen compression buffer size
    # @throws IllegalArgumentException if {@code bufLen} is <= 0
    # @throws NullPointerException if {@code in} or {@code defl} is null
    def initialize(in_, defl, buf_len)
      @def = nil
      @buf = nil
      @rbuf = nil
      @uses_default_deflater = false
      @reach_eof = false
      super(in_)
      @rbuf = Array.typed(::Java::Byte).new(1) { 0 }
      @uses_default_deflater = false
      @reach_eof = false
      # Sanity checks
      if ((in_).nil?)
        raise NullPointerException.new("Null input")
      end
      if ((defl).nil?)
        raise NullPointerException.new("Null deflater")
      end
      if (buf_len < 1)
        raise IllegalArgumentException.new("Buffer size < 1")
      end
      # Initialize
      @def = defl
      @buf = Array.typed(::Java::Byte).new(buf_len) { 0 }
    end
    
    typesig { [] }
    # 
    # Closes this input stream and its underlying input stream, discarding
    # any pending uncompressed data.
    # 
    # @throws IOException if an I/O error occurs
    def close
      if (!(self.attr_in).nil?)
        begin
          # Clean up
          if (@uses_default_deflater)
            @def.end
          end
          self.attr_in.close
        ensure
          self.attr_in = nil
        end
      end
    end
    
    typesig { [] }
    # 
    # Reads a single byte of compressed data from the input stream.
    # This method will block until some input can be read and compressed.
    # 
    # @return a single byte of compressed data, or -1 if the end of the
    # uncompressed input stream is reached
    # @throws IOException if an I/O error occurs or if this stream is
    # already closed
    def read
      # Read a single byte of compressed data
      len = read(@rbuf, 0, 1)
      if (len <= 0)
        return -1
      end
      return (@rbuf[0] & 0xff)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Reads compressed data into a byte array.
    # This method will block until some input can be read and compressed.
    # 
    # @param b buffer into which the data is read
    # @param off starting offset of the data within {@code b}
    # @param len maximum number of compressed bytes to read into {@code b}
    # @return the actual number of bytes read, or -1 if the end of the
    # uncompressed input stream is reached
    # @throws IndexOutOfBoundsException  if {@code len} > {@code b.length -
    # off}
    # @throws IOException if an I/O error occurs or if this input stream is
    # already closed
    def read(b, off, len)
      # Sanity checks
      ensure_open
      if ((b).nil?)
        raise NullPointerException.new("Null buffer for read")
      else
        if (off < 0 || len < 0 || len > b.attr_length - off)
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
      end
      # Read and compress (deflate) input data bytes
      cnt = 0
      while (len > 0 && !@def.finished)
        n = 0
        # Read data from the input stream
        if (@def.needs_input)
          n = self.attr_in.read(@buf, 0, @buf.attr_length)
          if (n < 0)
            # End of the input stream reached
            @def.finish
          else
            if (n > 0)
              @def.set_input(@buf, 0, n)
            end
          end
        end
        # Compress the input data, filling the read buffer
        n = @def.deflate(b, off, len)
        cnt += n
        off += n
        len -= n
      end
      if ((cnt).equal?(0) && @def.finished)
        @reach_eof = true
        cnt = -1
      end
      return cnt
    end
    
    typesig { [::Java::Long] }
    # 
    # Skips over and discards data from the input stream.
    # This method may block until the specified number of bytes are read and
    # skipped. <em>Note:</em> While {@code n} is given as a {@code long},
    # the maximum number of bytes which can be skipped is
    # {@code Integer.MAX_VALUE}.
    # 
    # @param n number of bytes to be skipped
    # @return the actual number of bytes skipped
    # @throws IOException if an I/O error occurs or if this stream is
    # already closed
    def skip(n)
      if (n < 0)
        raise IllegalArgumentException.new("negative skip length")
      end
      ensure_open
      # Skip bytes by repeatedly decompressing small blocks
      if (@rbuf.attr_length < 512)
        @rbuf = Array.typed(::Java::Byte).new(512) { 0 }
      end
      total = RJava.cast_to_int(Math.min(n, JavaInteger::MAX_VALUE))
      cnt = 0
      while (total > 0)
        # Read a small block of uncompressed bytes
        len = read(@rbuf, 0, (total <= @rbuf.attr_length ? total : @rbuf.attr_length))
        if (len < 0)
          break
        end
        cnt += len
        total -= len
      end
      return cnt
    end
    
    typesig { [] }
    # 
    # Returns 0 after EOF has been reached, otherwise always return 1.
    # <p>
    # Programs should not count on this method to return the actual number
    # of bytes that could be read without blocking
    # @return zero after the end of the underlying input stream has been
    # reached, otherwise always returns 1
    # @throws IOException if an I/O error occurs or if this stream is
    # already closed
    def available
      ensure_open
      if (@reach_eof)
        return 0
      end
      return 1
    end
    
    typesig { [] }
    # 
    # Always returns {@code false} because this input stream does not support
    # the {@link #mark mark()} and {@link #reset reset()} methods.
    # 
    # @return false, always
    def mark_supported
      return false
    end
    
    typesig { [::Java::Int] }
    # 
    # <i>This operation is not supported</i>.
    # 
    # @param limit maximum bytes that can be read before invalidating the position marker
    def mark(limit)
      # Operation not supported
    end
    
    typesig { [] }
    # 
    # <i>This operation is not supported</i>.
    # 
    # @throws IOException always thrown
    def reset
      raise IOException.new("mark/reset not supported")
    end
    
    private
    alias_method :initialize__deflater_input_stream, :initialize
  end
  
end
