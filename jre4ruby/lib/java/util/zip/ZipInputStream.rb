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
  module ZipInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
      include_const ::Java::Io, :PushbackInputStream
    }
  end
  
  # This class implements an input stream filter for reading files in the
  # ZIP file format. Includes support for both compressed and uncompressed
  # entries.
  # 
  # @author      David Connelly
  class ZipInputStream < ZipInputStreamImports.const_get :InflaterInputStream
    include_class_members ZipInputStreamImports
    include ZipConstants
    
    attr_accessor :entry
    alias_method :attr_entry, :entry
    undef_method :entry
    alias_method :attr_entry=, :entry=
    undef_method :entry=
    
    attr_accessor :flag
    alias_method :attr_flag, :flag
    undef_method :flag
    alias_method :attr_flag=, :flag=
    undef_method :flag=
    
    attr_accessor :crc
    alias_method :attr_crc, :crc
    undef_method :crc
    alias_method :attr_crc=, :crc=
    undef_method :crc=
    
    attr_accessor :remaining
    alias_method :attr_remaining, :remaining
    undef_method :remaining
    alias_method :attr_remaining=, :remaining=
    undef_method :remaining=
    
    attr_accessor :tmpbuf
    alias_method :attr_tmpbuf, :tmpbuf
    undef_method :tmpbuf
    alias_method :attr_tmpbuf=, :tmpbuf=
    undef_method :tmpbuf=
    
    class_module.module_eval {
      const_set_lazy(:STORED) { ZipEntry::STORED }
      const_attr_reader  :STORED
      
      const_set_lazy(:DEFLATED) { ZipEntry::DEFLATED }
      const_attr_reader  :DEFLATED
    }
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    # this flag is set to true after EOF has reached for
    # one entry
    attr_accessor :entry_eof
    alias_method :attr_entry_eof, :entry_eof
    undef_method :entry_eof
    alias_method :attr_entry_eof=, :entry_eof=
    undef_method :entry_eof=
    
    typesig { [] }
    # Check to make sure that this stream has not been closed
    def ensure_open
      if (@closed)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [InputStream] }
    # Creates a new ZIP input stream.
    # @param in the actual input stream
    def initialize(in_)
      @entry = nil
      @flag = 0
      @crc = nil
      @remaining = 0
      @tmpbuf = nil
      @closed = false
      @entry_eof = false
      @b = nil
      super(PushbackInputStream.new(in_, 512), Inflater.new(true), 512)
      @crc = CRC32.new
      @tmpbuf = Array.typed(::Java::Byte).new(512) { 0 }
      @closed = false
      @entry_eof = false
      @b = Array.typed(::Java::Byte).new(256) { 0 }
      self.attr_uses_default_inflater = true
      if ((in_).nil?)
        raise NullPointerException.new("in is null")
      end
    end
    
    typesig { [] }
    # Reads the next ZIP file entry and positions the stream at the
    # beginning of the entry data.
    # @return the next ZIP file entry, or null if there are no more entries
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    def get_next_entry
      ensure_open
      if (!(@entry).nil?)
        close_entry
      end
      @crc.reset
      self.attr_inf.reset
      if (((@entry = read_loc)).nil?)
        return nil
      end
      if ((@entry.attr_method).equal?(STORED))
        @remaining = @entry.attr_size
      end
      @entry_eof = false
      return @entry
    end
    
    typesig { [] }
    # Closes the current ZIP entry and positions the stream for reading the
    # next entry.
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    def close_entry
      ensure_open
      while (!(read(@tmpbuf, 0, @tmpbuf.attr_length)).equal?(-1))
      end
      @entry_eof = true
    end
    
    typesig { [] }
    # Returns 0 after EOF has reached for the current entry data,
    # otherwise always return 1.
    # <p>
    # Programs should not count on this method to return the actual number
    # of bytes that could be read without blocking.
    # 
    # @return     1 before EOF and 0 after EOF has reached for current entry.
    # @exception  IOException  if an I/O error occurs.
    def available
      ensure_open
      if (@entry_eof)
        return 0
      else
        return 1
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads from the current ZIP entry into an array of bytes.
    # If <code>len</code> is not zero, the method
    # blocks until some input is available; otherwise, no
    # bytes are read and <code>0</code> is returned.
    # @param b the buffer into which the data is read
    # @param off the start offset in the destination array <code>b</code>
    # @param len the maximum number of bytes read
    # @return the actual number of bytes read, or -1 if the end of the
    # entry is reached
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    def read(b, off, len)
      ensure_open
      if (off < 0 || len < 0 || off > b.attr_length - len)
        raise IndexOutOfBoundsException.new
      else
        if ((len).equal?(0))
          return 0
        end
      end
      if ((@entry).nil?)
        return -1
      end
      case (@entry.attr_method)
      when DEFLATED
        len = super(b, off, len)
        if ((len).equal?(-1))
          read_end(@entry)
          @entry_eof = true
          @entry = nil
        else
          @crc.update(b, off, len)
        end
        return len
      when STORED
        if (@remaining <= 0)
          @entry_eof = true
          @entry = nil
          return -1
        end
        if (len > @remaining)
          len = RJava.cast_to_int(@remaining)
        end
        len = self.attr_in.read(b, off, len)
        if ((len).equal?(-1))
          raise ZipException.new("unexpected EOF")
        end
        @crc.update(b, off, len)
        @remaining -= len
        if ((@remaining).equal?(0) && !(@entry.attr_crc).equal?(@crc.get_value))
          raise ZipException.new("invalid entry CRC (expected 0x" + (Long.to_hex_string(@entry.attr_crc)).to_s + " but got 0x" + (Long.to_hex_string(@crc.get_value)).to_s + ")")
        end
        return len
      else
        raise ZipException.new("invalid compression method")
      end
    end
    
    typesig { [::Java::Long] }
    # Skips specified number of bytes in the current ZIP entry.
    # @param n the number of bytes to skip
    # @return the actual number of bytes skipped
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    # @exception IllegalArgumentException if n < 0
    def skip(n)
      if (n < 0)
        raise IllegalArgumentException.new("negative skip length")
      end
      ensure_open
      max = RJava.cast_to_int(Math.min(n, JavaInteger::MAX_VALUE))
      total = 0
      while (total < max)
        len = max - total
        if (len > @tmpbuf.attr_length)
          len = @tmpbuf.attr_length
        end
        len = read(@tmpbuf, 0, len)
        if ((len).equal?(-1))
          @entry_eof = true
          break
        end
        total += len
      end
      return total
    end
    
    typesig { [] }
    # Closes this input stream and releases any system resources associated
    # with the stream.
    # @exception IOException if an I/O error has occurred
    def close
      if (!@closed)
        super
        @closed = true
      end
    end
    
    attr_accessor :b
    alias_method :attr_b, :b
    undef_method :b
    alias_method :attr_b=, :b=
    undef_method :b=
    
    typesig { [] }
    # Reads local file (LOC) header for next entry.
    def read_loc
      begin
        read_fully(@tmpbuf, 0, LOCHDR)
      rescue EOFException => e
        return nil
      end
      if (!(get32(@tmpbuf, 0)).equal?(LOCSIG))
        return nil
      end
      # get the entry name and create the ZipEntry first
      len = get16(@tmpbuf, LOCNAM)
      blen = @b.attr_length
      if (len > blen)
        begin
          blen = blen * 2
        end while (len > blen)
        @b = Array.typed(::Java::Byte).new(blen) { 0 }
      end
      read_fully(@b, 0, len)
      e = create_zip_entry(get_utf8string(@b, 0, len))
      # now get the remaining fields for the entry
      @flag = get16(@tmpbuf, LOCFLG)
      if (((@flag & 1)).equal?(1))
        raise ZipException.new("encrypted ZIP entry not supported")
      end
      e.attr_method = get16(@tmpbuf, LOCHOW)
      e.attr_time = get32(@tmpbuf, LOCTIM)
      if (((@flag & 8)).equal?(8))
        # "Data Descriptor" present
        if (!(e.attr_method).equal?(DEFLATED))
          raise ZipException.new("only DEFLATED entries can have EXT descriptor")
        end
      else
        e.attr_crc = get32(@tmpbuf, LOCCRC)
        e.attr_csize = get32(@tmpbuf, LOCSIZ)
        e.attr_size = get32(@tmpbuf, LOCLEN)
      end
      len = get16(@tmpbuf, LOCEXT)
      if (len > 0)
        bb = Array.typed(::Java::Byte).new(len) { 0 }
        read_fully(bb, 0, len)
        e.set_extra(bb)
      end
      return e
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Fetches a UTF8-encoded String from the specified byte array.
      def get_utf8string(b, off, len)
        # First, count the number of characters in the sequence
        count = 0
        max = off + len
        i = off
        while (i < max)
          c = b[((i += 1) - 1)] & 0xff
          case (c >> 4)
          when 0, 1, 2, 3, 4, 5, 6, 7
            # 0xxxxxxx
            ((count += 1) - 1)
          when 12, 13
            # 110xxxxx 10xxxxxx
            if (!((b[((i += 1) - 1)] & 0xc0)).equal?(0x80))
              raise IllegalArgumentException.new
            end
            ((count += 1) - 1)
          when 14
            # 1110xxxx 10xxxxxx 10xxxxxx
            if ((!((b[((i += 1) - 1)] & 0xc0)).equal?(0x80)) || (!((b[((i += 1) - 1)] & 0xc0)).equal?(0x80)))
              raise IllegalArgumentException.new
            end
            ((count += 1) - 1)
          else
            # 10xxxxxx, 1111xxxx
            raise IllegalArgumentException.new
          end
        end
        if (!(i).equal?(max))
          raise IllegalArgumentException.new
        end
        # Now decode the characters...
        cs = CharArray.new(count)
        i = 0
        while (off < max)
          c = b[((off += 1) - 1)] & 0xff
          case (c >> 4)
          when 0, 1, 2, 3, 4, 5, 6, 7
            # 0xxxxxxx
            cs[((i += 1) - 1)] = RJava.cast_to_char(c)
          when 12, 13
            # 110xxxxx 10xxxxxx
            cs[((i += 1) - 1)] = RJava.cast_to_char((((c & 0x1f) << 6) | (b[((off += 1) - 1)] & 0x3f)))
          when 14
            # 1110xxxx 10xxxxxx 10xxxxxx
            t = (b[((off += 1) - 1)] & 0x3f) << 6
            cs[((i += 1) - 1)] = RJava.cast_to_char((((c & 0xf) << 12) | t | (b[((off += 1) - 1)] & 0x3f)))
          else
            # 10xxxxxx, 1111xxxx
            raise IllegalArgumentException.new
          end
        end
        return String.new(cs, 0, count)
      end
    }
    
    typesig { [String] }
    # Creates a new <code>ZipEntry</code> object for the specified
    # entry name.
    # 
    # @param name the ZIP file entry name
    # @return the ZipEntry just created
    def create_zip_entry(name)
      return ZipEntry.new(name)
    end
    
    typesig { [ZipEntry] }
    # Reads end of deflated entry as well as EXT descriptor if present.
    def read_end(e)
      n = self.attr_inf.get_remaining
      if (n > 0)
        (self.attr_in).unread(self.attr_buf, self.attr_len - n, n)
      end
      if (((@flag & 8)).equal?(8))
        # "Data Descriptor" present
        read_fully(@tmpbuf, 0, EXTHDR)
        sig = get32(@tmpbuf, 0)
        if (!(sig).equal?(EXTSIG))
          # no EXTSIG present
          e.attr_crc = sig
          e.attr_csize = get32(@tmpbuf, EXTSIZ - EXTCRC)
          e.attr_size = get32(@tmpbuf, EXTLEN - EXTCRC)
          (self.attr_in).unread(@tmpbuf, EXTHDR - EXTCRC - 1, EXTCRC)
        else
          e.attr_crc = get32(@tmpbuf, EXTCRC)
          e.attr_csize = get32(@tmpbuf, EXTSIZ)
          e.attr_size = get32(@tmpbuf, EXTLEN)
        end
      end
      if (!(e.attr_size).equal?(self.attr_inf.get_bytes_written))
        raise ZipException.new("invalid entry size (expected " + (e.attr_size).to_s + " but got " + (self.attr_inf.get_bytes_written).to_s + " bytes)")
      end
      if (!(e.attr_csize).equal?(self.attr_inf.get_bytes_read))
        raise ZipException.new("invalid entry compressed size (expected " + (e.attr_csize).to_s + " but got " + (self.attr_inf.get_bytes_read).to_s + " bytes)")
      end
      if (!(e.attr_crc).equal?(@crc.get_value))
        raise ZipException.new("invalid entry CRC (expected 0x" + (Long.to_hex_string(e.attr_crc)).to_s + " but got 0x" + (Long.to_hex_string(@crc.get_value)).to_s + ")")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads bytes, blocking until all bytes are read.
    def read_fully(b, off, len)
      while (len > 0)
        n = self.attr_in.read(b, off, len)
        if ((n).equal?(-1))
          raise EOFException.new
        end
        off += n
        len -= n
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # Fetches unsigned 16-bit value from byte array at specified offset.
      # The bytes are assumed to be in Intel (little-endian) byte order.
      def get16(b, off)
        return (b[off] & 0xff) | ((b[off + 1] & 0xff) << 8)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # Fetches unsigned 32-bit value from byte array at specified offset.
      # The bytes are assumed to be in Intel (little-endian) byte order.
      def get32(b, off)
        return get16(b, off) | (get16(b, off + 2) << 16)
      end
    }
    
    private
    alias_method :initialize__zip_input_stream, :initialize
  end
  
end
