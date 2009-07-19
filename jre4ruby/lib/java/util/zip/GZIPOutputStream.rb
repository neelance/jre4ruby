require "rjava"

# Copyright 1996-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GZIPOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class implements a stream filter for writing compressed data in
  # the GZIP file format.
  # @author      David Connelly
  class GZIPOutputStream < GZIPOutputStreamImports.const_get :DeflaterOutputStream
    include_class_members GZIPOutputStreamImports
    
    # CRC-32 of uncompressed data.
    attr_accessor :crc
    alias_method :attr_crc, :crc
    undef_method :crc
    alias_method :attr_crc=, :crc=
    undef_method :crc=
    
    class_module.module_eval {
      # GZIP header magic number.
      const_set_lazy(:GZIP_MAGIC) { 0x8b1f }
      const_attr_reader  :GZIP_MAGIC
      
      # Trailer size in bytes.
      const_set_lazy(:TRAILER_SIZE) { 8 }
      const_attr_reader  :TRAILER_SIZE
    }
    
    typesig { [OutputStream, ::Java::Int] }
    # Creates a new output stream with the specified buffer size.
    # @param out the output stream
    # @param size the output buffer size
    # @exception IOException If an I/O error has occurred.
    # @exception IllegalArgumentException if size is <= 0
    def initialize(out, size)
      @crc = nil
      super(out, Deflater.new(Deflater::DEFAULT_COMPRESSION, true), size)
      @crc = CRC32.new
      self.attr_uses_default_deflater = true
      write_header
      @crc.reset
    end
    
    typesig { [OutputStream] }
    # Creates a new output stream with a default buffer size.
    # @param out the output stream
    # @exception IOException If an I/O error has occurred.
    def initialize(out)
      initialize__gzipoutput_stream(out, 512)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes array of bytes to the compressed output stream. This method
    # will block until all the bytes are written.
    # @param buf the data to be written
    # @param off the start offset of the data
    # @param len the length of the data
    # @exception IOException If an I/O error has occurred.
    def write(buf, off, len)
      synchronized(self) do
        super(buf, off, len)
        @crc.update(buf, off, len)
      end
    end
    
    typesig { [] }
    # Finishes writing compressed data to the output stream without closing
    # the underlying stream. Use this method when applying multiple filters
    # in succession to the same output stream.
    # @exception IOException if an I/O error has occurred
    def finish
      if (!self.attr_def.finished)
        self.attr_def.finish
        while (!self.attr_def.finished)
          len = self.attr_def.deflate(self.attr_buf, 0, self.attr_buf.attr_length)
          if (self.attr_def.finished && len <= self.attr_buf.attr_length - TRAILER_SIZE)
            # last deflater buffer. Fit trailer at the end
            write_trailer(self.attr_buf, len)
            len = len + TRAILER_SIZE
            self.attr_out.write(self.attr_buf, 0, len)
            return
          end
          if (len > 0)
            self.attr_out.write(self.attr_buf, 0, len)
          end
        end
        # if we can't fit the trailer at the end of the last
        # deflater buffer, we write it separately
        trailer = Array.typed(::Java::Byte).new(TRAILER_SIZE) { 0 }
        write_trailer(trailer, 0)
        self.attr_out.write(trailer)
      end
    end
    
    class_module.module_eval {
      # Writes GZIP member header.
      # 
      # Magic number (short)
      # Magic number (short)
      # Compression method (CM)
      # Flags (FLG)
      # Modification time MTIME (int)
      # Modification time MTIME (int)
      # Modification time MTIME (int)
      # Modification time MTIME (int)
      # Extra flags (XFLG)
      # Operating system (OS)
      const_set_lazy(:Header) { Array.typed(::Java::Byte).new([GZIP_MAGIC, (GZIP_MAGIC >> 8), Deflater::DEFLATED, 0, 0, 0, 0, 0, 0, 0]) }
      const_attr_reader  :Header
    }
    
    typesig { [] }
    def write_header
      self.attr_out.write(Header)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Writes GZIP member trailer to a byte array, starting at a given
    # offset.
    def write_trailer(buf, offset)
      write_int(RJava.cast_to_int(@crc.get_value), buf, offset) # CRC-32 of uncompr. data
      write_int(self.attr_def.get_total_in, buf, offset + 4) # Number of uncompr. bytes
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # Writes integer in Intel byte order to a byte array, starting at a
    # given offset.
    def write_int(i, buf, offset)
      write_short(i & 0xffff, buf, offset)
      write_short((i >> 16) & 0xffff, buf, offset + 2)
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # Writes short integer in Intel byte order to a byte array, starting
    # at a given offset
    def write_short(s, buf, offset)
      buf[offset] = (s & 0xff)
      buf[offset + 1] = ((s >> 8) & 0xff)
    end
    
    private
    alias_method :initialize__gzipoutput_stream, :initialize
  end
  
end
