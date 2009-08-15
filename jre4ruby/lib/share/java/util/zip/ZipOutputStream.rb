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
  module ZipOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :HashSet
    }
  end
  
  # This class implements an output stream filter for writing files in the
  # ZIP file format. Includes support for both compressed and uncompressed
  # entries.
  # 
  # @author      David Connelly
  class ZipOutputStream < ZipOutputStreamImports.const_get :DeflaterOutputStream
    include_class_members ZipOutputStreamImports
    overload_protected {
      include ZipConstants
    }
    
    class_module.module_eval {
      const_set_lazy(:XEntry) { Class.new do
        include_class_members ZipOutputStream
        
        attr_accessor :entry
        alias_method :attr_entry, :entry
        undef_method :entry
        alias_method :attr_entry=, :entry=
        undef_method :entry=
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :flag
        alias_method :attr_flag, :flag
        undef_method :flag
        alias_method :attr_flag=, :flag=
        undef_method :flag=
        
        typesig { [ZipEntry, ::Java::Long] }
        def initialize(entry, offset)
          @entry = nil
          @offset = 0
          @flag = 0
          @entry = entry
          @offset = offset
          # store size, compressed size, and crc-32 in data descriptor
          # immediately following the compressed entry data
          # store size, compressed size, and crc-32 in LOC header
          @flag = ((entry.attr_method).equal?(DEFLATED) && ((entry.attr_size).equal?(-1) || (entry.attr_csize).equal?(-1) || (entry.attr_crc).equal?(-1))) ? 8 : 0
        end
        
        private
        alias_method :initialize__xentry, :initialize
      end }
    }
    
    attr_accessor :current
    alias_method :attr_current, :current
    undef_method :current
    alias_method :attr_current=, :current=
    undef_method :current=
    
    attr_accessor :xentries
    alias_method :attr_xentries, :xentries
    undef_method :xentries
    alias_method :attr_xentries=, :xentries=
    undef_method :xentries=
    
    attr_accessor :names
    alias_method :attr_names, :names
    undef_method :names
    alias_method :attr_names=, :names=
    undef_method :names=
    
    attr_accessor :crc
    alias_method :attr_crc, :crc
    undef_method :crc
    alias_method :attr_crc=, :crc=
    undef_method :crc=
    
    attr_accessor :written
    alias_method :attr_written, :written
    undef_method :written
    alias_method :attr_written=, :written=
    undef_method :written=
    
    attr_accessor :locoff
    alias_method :attr_locoff, :locoff
    undef_method :locoff
    alias_method :attr_locoff=, :locoff=
    undef_method :locoff=
    
    attr_accessor :comment
    alias_method :attr_comment, :comment
    undef_method :comment
    alias_method :attr_comment=, :comment=
    undef_method :comment=
    
    attr_accessor :method
    alias_method :attr_method, :method
    undef_method :method
    alias_method :attr_method=, :method=
    undef_method :method=
    
    attr_accessor :finished
    alias_method :attr_finished, :finished
    undef_method :finished
    alias_method :attr_finished=, :finished=
    undef_method :finished=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    class_module.module_eval {
      typesig { [ZipEntry] }
      def version(e)
        case (e.attr_method)
        when DEFLATED
          return 20
        when STORED
          return 10
        else
          raise ZipException.new("unsupported compression method")
        end
      end
    }
    
    typesig { [] }
    # Checks to make sure that this stream has not been closed.
    def ensure_open
      if (@closed)
        raise IOException.new("Stream closed")
      end
    end
    
    class_module.module_eval {
      # Compression method for uncompressed (STORED) entries.
      const_set_lazy(:STORED) { ZipEntry::STORED }
      const_attr_reader  :STORED
      
      # Compression method for compressed (DEFLATED) entries.
      const_set_lazy(:DEFLATED) { ZipEntry::DEFLATED }
      const_attr_reader  :DEFLATED
    }
    
    typesig { [OutputStream] }
    # Creates a new ZIP output stream.
    # @param out the actual output stream
    def initialize(out)
      @current = nil
      @xentries = nil
      @names = nil
      @crc = nil
      @written = 0
      @locoff = 0
      @comment = nil
      @method = 0
      @finished = false
      @closed = false
      super(out, Deflater.new(Deflater::DEFAULT_COMPRESSION, true))
      @xentries = Vector.new
      @names = HashSet.new
      @crc = CRC32.new
      @written = 0
      @locoff = 0
      @method = DEFLATED
      @closed = false
      self.attr_uses_default_deflater = true
    end
    
    typesig { [String] }
    # Sets the ZIP file comment.
    # @param comment the comment string
    # @exception IllegalArgumentException if the length of the specified
    # ZIP file comment is greater than 0xFFFF bytes
    def set_comment(comment)
      if (!(comment).nil? && comment.length > 0xffff / 3 && get_utf8length(comment) > 0xffff)
        raise IllegalArgumentException.new("ZIP file comment too long.")
      end
      @comment = comment
    end
    
    typesig { [::Java::Int] }
    # Sets the default compression method for subsequent entries. This
    # default will be used whenever the compression method is not specified
    # for an individual ZIP file entry, and is initially set to DEFLATED.
    # @param method the default compression method
    # @exception IllegalArgumentException if the specified compression method
    # is invalid
    def set_method(method)
      if (!(method).equal?(DEFLATED) && !(method).equal?(STORED))
        raise IllegalArgumentException.new("invalid compression method")
      end
      @method = method
    end
    
    typesig { [::Java::Int] }
    # Sets the compression level for subsequent entries which are DEFLATED.
    # The default setting is DEFAULT_COMPRESSION.
    # @param level the compression level (0-9)
    # @exception IllegalArgumentException if the compression level is invalid
    def set_level(level)
      self.attr_def.set_level(level)
    end
    
    typesig { [ZipEntry] }
    # Begins writing a new ZIP file entry and positions the stream to the
    # start of the entry data. Closes the current entry if still active.
    # The default compression method will be used if no compression method
    # was specified for the entry, and the current time will be used if
    # the entry has no set modification time.
    # @param e the ZIP entry to be written
    # @exception ZipException if a ZIP format error has occurred
    # @exception IOException if an I/O error has occurred
    def put_next_entry(e)
      ensure_open
      if (!(@current).nil?)
        close_entry # close previous entry
      end
      if ((e.attr_time).equal?(-1))
        e.set_time(System.current_time_millis)
      end
      if ((e.attr_method).equal?(-1))
        e.attr_method = @method # use default method
      end
      case (e.attr_method)
      when DEFLATED
      when STORED
        # compressed size, uncompressed size, and crc-32 must all be
        # set for entries using STORED compression method
        if ((e.attr_size).equal?(-1))
          e.attr_size = e.attr_csize
        else
          if ((e.attr_csize).equal?(-1))
            e.attr_csize = e.attr_size
          else
            if (!(e.attr_size).equal?(e.attr_csize))
              raise ZipException.new("STORED entry where compressed != uncompressed size")
            end
          end
        end
        if ((e.attr_size).equal?(-1) || (e.attr_crc).equal?(-1))
          raise ZipException.new("STORED entry missing size, compressed size, or crc-32")
        end
      else
        raise ZipException.new("unsupported compression method")
      end
      if (!@names.add(e.attr_name))
        raise ZipException.new("duplicate entry: " + RJava.cast_to_string(e.attr_name))
      end
      @current = XEntry.new(e, @written)
      @xentries.add(@current)
      write_loc(@current)
    end
    
    typesig { [] }
    # Closes the current ZIP entry and positions the stream for writing
    # the next entry.
    # @exception ZipException if a ZIP format error has occurred
    # @exception IOException if an I/O error has occurred
    def close_entry
      ensure_open
      if (!(@current).nil?)
        e = @current.attr_entry
        case (e.attr_method)
        when DEFLATED
          self.attr_def.finish
          while (!self.attr_def.finished)
            deflate
          end
          if (((@current.attr_flag & 8)).equal?(0))
            # verify size, compressed size, and crc-32 settings
            if (!(e.attr_size).equal?(self.attr_def.get_bytes_read))
              raise ZipException.new("invalid entry size (expected " + RJava.cast_to_string(e.attr_size) + " but got " + RJava.cast_to_string(self.attr_def.get_bytes_read) + " bytes)")
            end
            if (!(e.attr_csize).equal?(self.attr_def.get_bytes_written))
              raise ZipException.new("invalid entry compressed size (expected " + RJava.cast_to_string(e.attr_csize) + " but got " + RJava.cast_to_string(self.attr_def.get_bytes_written) + " bytes)")
            end
            if (!(e.attr_crc).equal?(@crc.get_value))
              raise ZipException.new("invalid entry CRC-32 (expected 0x" + RJava.cast_to_string(Long.to_hex_string(e.attr_crc)) + " but got 0x" + RJava.cast_to_string(Long.to_hex_string(@crc.get_value)) + ")")
            end
          else
            e.attr_size = self.attr_def.get_bytes_read
            e.attr_csize = self.attr_def.get_bytes_written
            e.attr_crc = @crc.get_value
            write_ext(e)
          end
          self.attr_def.reset
          @written += e.attr_csize
        when STORED
          # we already know that both e.size and e.csize are the same
          if (!(e.attr_size).equal?(@written - @locoff))
            raise ZipException.new("invalid entry size (expected " + RJava.cast_to_string(e.attr_size) + " but got " + RJava.cast_to_string((@written - @locoff)) + " bytes)")
          end
          if (!(e.attr_crc).equal?(@crc.get_value))
            raise ZipException.new("invalid entry crc-32 (expected 0x" + RJava.cast_to_string(Long.to_hex_string(e.attr_crc)) + " but got 0x" + RJava.cast_to_string(Long.to_hex_string(@crc.get_value)) + ")")
          end
        else
          raise ZipException.new("invalid compression method")
        end
        @crc.reset
        @current = nil
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes an array of bytes to the current ZIP entry data. This method
    # will block until all the bytes are written.
    # @param b the data to be written
    # @param off the start offset in the data
    # @param len the number of bytes that are written
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    def write(b, off, len)
      synchronized(self) do
        ensure_open
        if (off < 0 || len < 0 || off > b.attr_length - len)
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return
          end
        end
        if ((@current).nil?)
          raise ZipException.new("no current ZIP entry")
        end
        entry = @current.attr_entry
        case (entry.attr_method)
        when DEFLATED
          super(b, off, len)
        when STORED
          @written += len
          if (@written - @locoff > entry.attr_size)
            raise ZipException.new("attempt to write past end of STORED entry")
          end
          self.attr_out.write(b, off, len)
        else
          raise ZipException.new("invalid compression method")
        end
        @crc.update(b, off, len)
      end
    end
    
    typesig { [] }
    # Finishes writing the contents of the ZIP output stream without closing
    # the underlying stream. Use this method when applying multiple filters
    # in succession to the same output stream.
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O exception has occurred
    def finish
      ensure_open
      if (@finished)
        return
      end
      if (!(@current).nil?)
        close_entry
      end
      if (@xentries.size < 1)
        raise ZipException.new("ZIP file must have at least one entry")
      end
      # write central directory
      off = @written
      @xentries.each do |xentry|
        write_cen(xentry)
      end
      write_end(off, @written - off)
      @finished = true
    end
    
    typesig { [] }
    # Closes the ZIP output stream as well as the stream being filtered.
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    def close
      if (!@closed)
        super
        @closed = true
      end
    end
    
    typesig { [XEntry] }
    # Writes local file (LOC) header for specified entry.
    def write_loc(xentry)
      e = xentry.attr_entry
      flag = xentry.attr_flag
      write_int(LOCSIG) # LOC header signature
      write_short(version(e)) # version needed to extract
      write_short(flag) # general purpose bit flag
      write_short(e.attr_method) # compression method
      write_int(e.attr_time) # last modification time
      if (((flag & 8)).equal?(8))
        # store size, uncompressed size, and crc-32 in data descriptor
        # immediately following compressed entry data
        write_int(0)
        write_int(0)
        write_int(0)
      else
        write_int(e.attr_crc) # crc-32
        write_int(e.attr_csize) # compressed size
        write_int(e.attr_size) # uncompressed size
      end
      name_bytes = get_utf8bytes(e.attr_name)
      write_short(name_bytes.attr_length)
      write_short(!(e.attr_extra).nil? ? e.attr_extra.attr_length : 0)
      write_bytes(name_bytes, 0, name_bytes.attr_length)
      if (!(e.attr_extra).nil?)
        write_bytes(e.attr_extra, 0, e.attr_extra.attr_length)
      end
      @locoff = @written
    end
    
    typesig { [ZipEntry] }
    # Writes extra data descriptor (EXT) for specified entry.
    def write_ext(e)
      write_int(EXTSIG) # EXT header signature
      write_int(e.attr_crc) # crc-32
      write_int(e.attr_csize) # compressed size
      write_int(e.attr_size) # uncompressed size
    end
    
    typesig { [XEntry] }
    # Write central directory (CEN) header for specified entry.
    # REMIND: add support for file attributes
    def write_cen(xentry)
      e = xentry.attr_entry
      flag = xentry.attr_flag
      version_ = version(e)
      write_int(CENSIG) # CEN header signature
      write_short(version_) # version made by
      write_short(version_) # version needed to extract
      write_short(flag) # general purpose bit flag
      write_short(e.attr_method) # compression method
      write_int(e.attr_time) # last modification time
      write_int(e.attr_crc) # crc-32
      write_int(e.attr_csize) # compressed size
      write_int(e.attr_size) # uncompressed size
      name_bytes = get_utf8bytes(e.attr_name)
      write_short(name_bytes.attr_length)
      write_short(!(e.attr_extra).nil? ? e.attr_extra.attr_length : 0)
      comment_bytes = nil
      if (!(e.attr_comment).nil?)
        comment_bytes = get_utf8bytes(e.attr_comment)
        write_short(comment_bytes.attr_length)
      else
        comment_bytes = nil
        write_short(0)
      end
      write_short(0) # starting disk number
      write_short(0) # internal file attributes (unused)
      write_int(0) # external file attributes (unused)
      write_int(xentry.attr_offset) # relative offset of local header
      write_bytes(name_bytes, 0, name_bytes.attr_length)
      if (!(e.attr_extra).nil?)
        write_bytes(e.attr_extra, 0, e.attr_extra.attr_length)
      end
      if (!(comment_bytes).nil?)
        write_bytes(comment_bytes, 0, comment_bytes.attr_length)
      end
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # Writes end of central directory (END) header.
    def write_end(off, len)
      count = @xentries.size
      write_int(ENDSIG) # END record signature
      write_short(0) # number of this disk
      write_short(0) # central directory start disk
      write_short(count) # number of directory entries on disk
      write_short(count) # total number of directory entries
      write_int(len) # length of central directory
      write_int(off) # offset of central directory
      if (!(@comment).nil?)
        # zip file comment
        b = get_utf8bytes(@comment)
        write_short(b.attr_length)
        write_bytes(b, 0, b.attr_length)
      else
        write_short(0)
      end
    end
    
    typesig { [::Java::Int] }
    # Writes a 16-bit short to the output stream in little-endian byte order.
    def write_short(v)
      out = self.attr_out
      out.write((v >> 0) & 0xff)
      out.write((v >> 8) & 0xff)
      @written += 2
    end
    
    typesig { [::Java::Long] }
    # Writes a 32-bit int to the output stream in little-endian byte order.
    def write_int(v)
      out = self.attr_out
      out.write(RJava.cast_to_int(((v >> 0) & 0xff)))
      out.write(RJava.cast_to_int(((v >> 8) & 0xff)))
      out.write(RJava.cast_to_int(((v >> 16) & 0xff)))
      out.write(RJava.cast_to_int(((v >> 24) & 0xff)))
      @written += 4
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes an array of bytes to the output stream.
    def write_bytes(b, off, len)
      @out.write(b, off, len)
      @written += len
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns the length of String's UTF8 encoding.
      def get_utf8length(s)
        count = 0
        i = 0
        while i < s.length
          ch = s.char_at(i)
          if (ch <= 0x7f)
            count += 1
          else
            if (ch <= 0x7ff)
              count += 2
            else
              count += 3
            end
          end
          i += 1
        end
        return count
      end
      
      typesig { [String] }
      # Returns an array of bytes representing the UTF8 encoding
      # of the specified String.
      def get_utf8bytes(s)
        c = s.to_char_array
        len = c.attr_length
        # Count the number of encoded bytes...
        count = 0
        i = 0
        while i < len
          ch = c[i]
          if (ch <= 0x7f)
            count += 1
          else
            if (ch <= 0x7ff)
              count += 2
            else
              count += 3
            end
          end
          i += 1
        end
        # Now return the encoded bytes...
        b = Array.typed(::Java::Byte).new(count) { 0 }
        off = 0
        i_ = 0
        while i_ < len
          ch = c[i_]
          if (ch <= 0x7f)
            b[((off += 1) - 1)] = ch
          else
            if (ch <= 0x7ff)
              b[((off += 1) - 1)] = ((ch >> 6) | 0xc0)
              b[((off += 1) - 1)] = ((ch & 0x3f) | 0x80)
            else
              b[((off += 1) - 1)] = ((ch >> 12) | 0xe0)
              b[((off += 1) - 1)] = (((ch >> 6) & 0x3f) | 0x80)
              b[((off += 1) - 1)] = ((ch & 0x3f) | 0x80)
            end
          end
          i_ += 1
        end
        return b
      end
    }
    
    private
    alias_method :initialize__zip_output_stream, :initialize
  end
  
end
