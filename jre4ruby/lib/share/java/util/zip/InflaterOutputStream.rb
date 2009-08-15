require "rjava"

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
  module InflaterOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :FilterOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
    }
  end
  
  # Implements an output stream filter for uncompressing data stored in the
  # "deflate" compression format.
  # 
  # @since       1.6
  # @author      David R Tribble (david@tribble.com)
  # 
  # @see InflaterInputStream
  # @see DeflaterInputStream
  # @see DeflaterOutputStream
  class InflaterOutputStream < InflaterOutputStreamImports.const_get :FilterOutputStream
    include_class_members InflaterOutputStreamImports
    
    # Decompressor for this stream.
    attr_accessor :inf
    alias_method :attr_inf, :inf
    undef_method :inf
    alias_method :attr_inf=, :inf=
    undef_method :inf=
    
    # Output buffer for writing uncompressed data.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # Temporary write buffer.
    attr_accessor :wbuf
    alias_method :attr_wbuf, :wbuf
    undef_method :wbuf
    alias_method :attr_wbuf=, :wbuf=
    undef_method :wbuf=
    
    # Default decompressor is used.
    attr_accessor :uses_default_inflater
    alias_method :attr_uses_default_inflater, :uses_default_inflater
    undef_method :uses_default_inflater
    alias_method :attr_uses_default_inflater=, :uses_default_inflater=
    undef_method :uses_default_inflater=
    
    # true iff {@link #close()} has been called.
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    typesig { [] }
    # Checks to make sure that this stream has not been closed.
    def ensure_open
      if (@closed)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [OutputStream] }
    # Creates a new output stream with a default decompressor and buffer
    # size.
    # 
    # @param out output stream to write the uncompressed data to
    # @throws NullPointerException if {@code out} is null
    def initialize(out)
      initialize__inflater_output_stream(out, Inflater.new)
      @uses_default_inflater = true
    end
    
    typesig { [OutputStream, Inflater] }
    # Creates a new output stream with the specified decompressor and a
    # default buffer size.
    # 
    # @param out output stream to write the uncompressed data to
    # @param infl decompressor ("inflater") for this stream
    # @throws NullPointerException if {@code out} or {@code infl} is null
    def initialize(out, infl)
      initialize__inflater_output_stream(out, infl, 512)
    end
    
    typesig { [OutputStream, Inflater, ::Java::Int] }
    # Creates a new output stream with the specified decompressor and
    # buffer size.
    # 
    # @param out output stream to write the uncompressed data to
    # @param infl decompressor ("inflater") for this stream
    # @param bufLen decompression buffer size
    # @throws IllegalArgumentException if {@code bufLen} is <= 0
    # @throws NullPointerException if {@code out} or {@code infl} is null
    def initialize(out, infl, buf_len)
      @inf = nil
      @buf = nil
      @wbuf = nil
      @uses_default_inflater = false
      @closed = false
      super(out)
      @wbuf = Array.typed(::Java::Byte).new(1) { 0 }
      @uses_default_inflater = false
      @closed = false
      # Sanity checks
      if ((out).nil?)
        raise NullPointerException.new("Null output")
      end
      if ((infl).nil?)
        raise NullPointerException.new("Null inflater")
      end
      if (buf_len <= 0)
        raise IllegalArgumentException.new("Buffer size < 1")
      end
      # Initialize
      @inf = infl
      @buf = Array.typed(::Java::Byte).new(buf_len) { 0 }
    end
    
    typesig { [] }
    # Writes any remaining uncompressed data to the output stream and closes
    # the underlying output stream.
    # 
    # @throws IOException if an I/O error occurs
    def close
      if (!@closed)
        # Complete the uncompressed output
        begin
          finish
        ensure
          self.attr_out.close
          @closed = true
        end
      end
    end
    
    typesig { [] }
    # Flushes this output stream, forcing any pending buffered output bytes to be
    # written.
    # 
    # @throws IOException if an I/O error occurs or this stream is already
    # closed
    def flush
      ensure_open
      # Finish decompressing and writing pending output data
      if (!@inf.finished)
        begin
          while (!@inf.finished && !@inf.needs_input)
            n = 0
            # Decompress pending output data
            n = @inf.inflate(@buf, 0, @buf.attr_length)
            if (n < 1)
              break
            end
            # Write the uncompressed output data block
            self.attr_out.write(@buf, 0, n)
          end
          super
        rescue DataFormatException => ex
          # Improperly formatted compressed (ZIP) data
          msg = ex.get_message
          if ((msg).nil?)
            msg = "Invalid ZLIB data format"
          end
          raise ZipException.new(msg)
        end
      end
    end
    
    typesig { [] }
    # Finishes writing uncompressed data to the output stream without closing
    # the underlying stream.  Use this method when applying multiple filters in
    # succession to the same output stream.
    # 
    # @throws IOException if an I/O error occurs or this stream is already
    # closed
    def finish
      ensure_open
      # Finish decompressing and writing pending output data
      flush
      if (@uses_default_inflater)
        @inf.end_
      end
    end
    
    typesig { [::Java::Int] }
    # Writes a byte to the uncompressed output stream.
    # 
    # @param b a single byte of compressed data to decompress and write to
    # the output stream
    # @throws IOException if an I/O error occurs or this stream is already
    # closed
    # @throws ZipException if a compression (ZIP) format error occurs
    def write(b)
      # Write a single byte of data
      @wbuf[0] = b
      write(@wbuf, 0, 1)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes an array of bytes to the uncompressed output stream.
    # 
    # @param b buffer containing compressed data to decompress and write to
    # the output stream
    # @param off starting offset of the compressed data within {@code b}
    # @param len number of bytes to decompress from {@code b}
    # @throws IndexOutOfBoundsException if {@code off} < 0, or if
    # {@code len} < 0, or if {@code len} > {@code b.length - off}
    # @throws IOException if an I/O error occurs or this stream is already
    # closed
    # @throws NullPointerException if {@code b} is null
    # @throws ZipException if a compression (ZIP) format error occurs
    def write(b, off, len)
      # Sanity checks
      ensure_open
      if ((b).nil?)
        raise NullPointerException.new("Null buffer for read")
      else
        if (off < 0 || len < 0 || len > b.attr_length - off)
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return
          end
        end
      end
      # Write uncompressed data to the output stream
      begin
        loop do
          n = 0
          # Fill the decompressor buffer with output data
          if (@inf.needs_input)
            part = 0
            if (len < 1)
              break
            end
            part = (len < 512 ? len : 512)
            @inf.set_input(b, off, part)
            off += part
            len -= part
          end
          # Decompress and write blocks of output data
          begin
            n = @inf.inflate(@buf, 0, @buf.attr_length)
            if (n > 0)
              self.attr_out.write(@buf, 0, n)
            end
          end while (n > 0)
          # Check the decompressor
          if (@inf.finished)
            break
          end
          if (@inf.needs_dictionary)
            raise ZipException.new("ZLIB dictionary missing")
          end
        end
      rescue DataFormatException => ex
        # Improperly formatted compressed (ZIP) data
        msg = ex.get_message
        if ((msg).nil?)
          msg = "Invalid ZLIB data format"
        end
        raise ZipException.new(msg)
      end
    end
    
    private
    alias_method :initialize__inflater_output_stream, :initialize
  end
  
end
