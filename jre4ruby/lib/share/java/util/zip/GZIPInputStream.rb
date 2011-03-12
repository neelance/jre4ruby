require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GZIPInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :SequenceInputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
    }
  end
  
  # This class implements a stream filter for reading compressed data in
  # the GZIP file format.
  # 
  # @see         InflaterInputStream
  # @author      David Connelly
  class GZIPInputStream < GZIPInputStreamImports.const_get :InflaterInputStream
    include_class_members GZIPInputStreamImports
    
    # CRC-32 for uncompressed data.
    attr_accessor :crc
    alias_method :attr_crc, :crc
    undef_method :crc
    alias_method :attr_crc=, :crc=
    undef_method :crc=
    
    # Indicates end of input stream.
    attr_accessor :eos
    alias_method :attr_eos, :eos
    undef_method :eos
    alias_method :attr_eos=, :eos=
    undef_method :eos=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    typesig { [] }
    # Check to make sure that this stream has not been closed
    def ensure_open
      if (@closed)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [InputStream, ::Java::Int] }
    # Creates a new input stream with the specified buffer size.
    # @param in the input stream
    # @param size the input buffer size
    # @exception IOException if an I/O error has occurred
    # @exception IllegalArgumentException if size is <= 0
    def initialize(in_, size)
      @crc = nil
      @eos = false
      @closed = false
      @tmpbuf = nil
      super(in_, Inflater.new(true), size)
      @crc = CRC32.new
      @closed = false
      @tmpbuf = Array.typed(::Java::Byte).new(128) { 0 }
      self.attr_uses_default_inflater = true
      read_header
      @crc.reset
    end
    
    typesig { [InputStream] }
    # Creates a new input stream with a default buffer size.
    # @param in the input stream
    # @exception IOException if an I/O error has occurred
    def initialize(in_)
      initialize__gzipinput_stream(in_, 512)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads uncompressed data into an array of bytes. If <code>len</code> is not
    # zero, the method will block until some input can be decompressed; otherwise,
    # no bytes are read and <code>0</code> is returned.
    # @param buf the buffer into which the data is read
    # @param off the start offset in the destination array <code>b</code>
    # @param len the maximum number of bytes read
    # @return  the actual number of bytes read, or -1 if the end of the
    #          compressed input stream is reached
    # @exception  NullPointerException If <code>buf</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>buf.length - off</code>
    # @exception IOException if an I/O error has occurred or the compressed
    #                        input data is corrupt
    def read(buf, off, len)
      ensure_open
      if (@eos)
        return -1
      end
      len = super(buf, off, len)
      if ((len).equal?(-1))
        read_trailer
        @eos = true
      else
        @crc.update(buf, off, len)
      end
      return len
    end
    
    typesig { [] }
    # Closes this input stream and releases any system resources associated
    # with the stream.
    # @exception IOException if an I/O error has occurred
    def close
      if (!@closed)
        super
        @eos = true
        @closed = true
      end
    end
    
    class_module.module_eval {
      # GZIP header magic number.
      const_set_lazy(:GZIP_MAGIC) { 0x8b1f }
      const_attr_reader  :GZIP_MAGIC
      
      # File header flags.
      const_set_lazy(:FTEXT) { 1 }
      const_attr_reader  :FTEXT
      
      # Extra text
      const_set_lazy(:FHCRC) { 2 }
      const_attr_reader  :FHCRC
      
      # Header CRC
      const_set_lazy(:FEXTRA) { 4 }
      const_attr_reader  :FEXTRA
      
      # Extra field
      const_set_lazy(:FNAME) { 8 }
      const_attr_reader  :FNAME
      
      # File name
      const_set_lazy(:FCOMMENT) { 16 }
      const_attr_reader  :FCOMMENT
    }
    
    typesig { [] }
    # File comment
    # Reads GZIP member header.
    def read_header
      in_ = CheckedInputStream.new(self.attr_in, @crc)
      @crc.reset
      # Check header magic
      if (!(read_ushort(in_)).equal?(GZIP_MAGIC))
        raise IOException.new("Not in GZIP format")
      end
      # Check compression method
      if (!(read_ubyte(in_)).equal?(8))
        raise IOException.new("Unsupported compression method")
      end
      # Read flags
      flg = read_ubyte(in_)
      # Skip MTIME, XFL, and OS fields
      skip_bytes(in_, 6)
      # Skip optional extra field
      if (((flg & FEXTRA)).equal?(FEXTRA))
        skip_bytes(in_, read_ushort(in_))
      end
      # Skip optional file name
      if (((flg & FNAME)).equal?(FNAME))
        while (!(read_ubyte(in_)).equal?(0))
        end
      end
      # Skip optional file comment
      if (((flg & FCOMMENT)).equal?(FCOMMENT))
        while (!(read_ubyte(in_)).equal?(0))
        end
      end
      # Check optional header CRC
      if (((flg & FHCRC)).equal?(FHCRC))
        v = (@crc.get_value).to_int & 0xffff
        if (!(read_ushort(in_)).equal?(v))
          raise IOException.new("Corrupt GZIP header")
        end
      end
    end
    
    typesig { [] }
    # Reads GZIP member trailer.
    def read_trailer
      in_ = self.attr_in
      n = self.attr_inf.get_remaining
      if (n > 0)
        in_ = SequenceInputStream.new(ByteArrayInputStream.new(self.attr_buf, self.attr_len - n, n), in_)
      end
      # Uses left-to-right evaluation order
      # rfc1952; ISIZE is the input size modulo 2^32
      if ((!(read_uint(in_)).equal?(@crc.get_value)) || (!(read_uint(in_)).equal?((self.attr_inf.get_bytes_written & 0xffffffff))))
        raise IOException.new("Corrupt GZIP trailer")
      end
    end
    
    typesig { [InputStream] }
    # Reads unsigned integer in Intel byte order.
    def read_uint(in_)
      s = read_ushort(in_)
      return (read_ushort(in_) << 16) | s
    end
    
    typesig { [InputStream] }
    # Reads unsigned short in Intel byte order.
    def read_ushort(in_)
      b = read_ubyte(in_)
      return ((read_ubyte(in_)).to_int << 8) | b
    end
    
    typesig { [InputStream] }
    # Reads unsigned byte.
    def read_ubyte(in_)
      b = in_.read
      if ((b).equal?(-1))
        raise EOFException.new
      end
      if (b < -1 || b > 255)
        # Report on this.in, not argument in; see read{Header, Trailer}.
        raise IOException.new(RJava.cast_to_string(self.attr_in.get_class.get_name) + ".read() returned value out of range -1..255: " + RJava.cast_to_string(b))
      end
      return b
    end
    
    attr_accessor :tmpbuf
    alias_method :attr_tmpbuf, :tmpbuf
    undef_method :tmpbuf
    alias_method :attr_tmpbuf=, :tmpbuf=
    undef_method :tmpbuf=
    
    typesig { [InputStream, ::Java::Int] }
    # Skips bytes of input data blocking until all bytes are skipped.
    # Does not assume that the input stream is capable of seeking.
    def skip_bytes(in_, n)
      while (n > 0)
        len = in_.read(@tmpbuf, 0, n < @tmpbuf.attr_length ? n : @tmpbuf.attr_length)
        if ((len).equal?(-1))
          raise EOFException.new
        end
        n -= len
      end
    end
    
    private
    alias_method :initialize__gzipinput_stream, :initialize
  end
  
end
