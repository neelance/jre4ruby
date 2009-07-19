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
  module InflaterInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :FilterInputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
    }
  end
  
  # This class implements a stream filter for uncompressing data in the
  # "deflate" compression format. It is also used as the basis for other
  # decompression filters, such as GZIPInputStream.
  # 
  # @see         Inflater
  # @author      David Connelly
  class InflaterInputStream < InflaterInputStreamImports.const_get :FilterInputStream
    include_class_members InflaterInputStreamImports
    
    # Decompressor for this stream.
    attr_accessor :inf
    alias_method :attr_inf, :inf
    undef_method :inf
    alias_method :attr_inf=, :inf=
    undef_method :inf=
    
    # Input buffer for decompression.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # Length of input buffer.
    attr_accessor :len
    alias_method :attr_len, :len
    undef_method :len
    alias_method :attr_len=, :len=
    undef_method :len=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    # this flag is set to true after EOF has reached
    attr_accessor :reach_eof
    alias_method :attr_reach_eof, :reach_eof
    undef_method :reach_eof
    alias_method :attr_reach_eof=, :reach_eof=
    undef_method :reach_eof=
    
    typesig { [] }
    # Check to make sure that this stream has not been closed
    def ensure_open
      if (@closed)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [InputStream, Inflater, ::Java::Int] }
    # Creates a new input stream with the specified decompressor and
    # buffer size.
    # @param in the input stream
    # @param inf the decompressor ("inflater")
    # @param size the input buffer size
    # @exception IllegalArgumentException if size is <= 0
    def initialize(in_, inf, size)
      @inf = nil
      @buf = nil
      @len = 0
      @closed = false
      @reach_eof = false
      @uses_default_inflater = false
      @single_byte_buf = nil
      @b = nil
      super(in_)
      @closed = false
      @reach_eof = false
      @uses_default_inflater = false
      @single_byte_buf = Array.typed(::Java::Byte).new(1) { 0 }
      @b = Array.typed(::Java::Byte).new(512) { 0 }
      if ((in_).nil? || (inf).nil?)
        raise NullPointerException.new
      else
        if (size <= 0)
          raise IllegalArgumentException.new("buffer size <= 0")
        end
      end
      @inf = inf
      @buf = Array.typed(::Java::Byte).new(size) { 0 }
    end
    
    typesig { [InputStream, Inflater] }
    # Creates a new input stream with the specified decompressor and a
    # default buffer size.
    # @param in the input stream
    # @param inf the decompressor ("inflater")
    def initialize(in_, inf)
      initialize__inflater_input_stream(in_, inf, 512)
    end
    
    attr_accessor :uses_default_inflater
    alias_method :attr_uses_default_inflater, :uses_default_inflater
    undef_method :uses_default_inflater
    alias_method :attr_uses_default_inflater=, :uses_default_inflater=
    undef_method :uses_default_inflater=
    
    typesig { [InputStream] }
    # Creates a new input stream with a default decompressor and buffer size.
    # @param in the input stream
    def initialize(in_)
      initialize__inflater_input_stream(in_, Inflater.new)
      @uses_default_inflater = true
    end
    
    attr_accessor :single_byte_buf
    alias_method :attr_single_byte_buf, :single_byte_buf
    undef_method :single_byte_buf
    alias_method :attr_single_byte_buf=, :single_byte_buf=
    undef_method :single_byte_buf=
    
    typesig { [] }
    # Reads a byte of uncompressed data. This method will block until
    # enough input is available for decompression.
    # @return the byte read, or -1 if end of compressed input is reached
    # @exception IOException if an I/O error has occurred
    def read
      ensure_open
      return (read(@single_byte_buf, 0, 1)).equal?(-1) ? -1 : @single_byte_buf[0] & 0xff
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads uncompressed data into an array of bytes. If <code>len</code> is not
    # zero, the method will block until some input can be decompressed; otherwise,
    # no bytes are read and <code>0</code> is returned.
    # @param b the buffer into which the data is read
    # @param off the start offset in the destination array <code>b</code>
    # @param len the maximum number of bytes read
    # @return the actual number of bytes read, or -1 if the end of the
    # compressed input is reached or a preset dictionary is needed
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    # @exception ZipException if a ZIP format error has occurred
    # @exception IOException if an I/O error has occurred
    def read(b, off, len)
      ensure_open
      if ((b).nil?)
        raise NullPointerException.new
      else
        if (off < 0 || len < 0 || len > b.attr_length - off)
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
      end
      begin
        n = 0
        while (((n = @inf.inflate(b, off, len))).equal?(0))
          if (@inf.finished || @inf.needs_dictionary)
            @reach_eof = true
            return -1
          end
          if (@inf.needs_input)
            fill
          end
        end
        return n
      rescue DataFormatException => e
        s = e.get_message
        raise ZipException.new(!(s).nil? ? s : "Invalid ZLIB data format")
      end
    end
    
    typesig { [] }
    # Returns 0 after EOF has been reached, otherwise always return 1.
    # <p>
    # Programs should not count on this method to return the actual number
    # of bytes that could be read without blocking.
    # 
    # @return     1 before EOF and 0 after EOF.
    # @exception  IOException  if an I/O error occurs.
    def available
      ensure_open
      if (@reach_eof)
        return 0
      else
        return 1
      end
    end
    
    attr_accessor :b
    alias_method :attr_b, :b
    undef_method :b
    alias_method :attr_b=, :b=
    undef_method :b=
    
    typesig { [::Java::Long] }
    # Skips specified number of bytes of uncompressed data.
    # @param n the number of bytes to skip
    # @return the actual number of bytes skipped.
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
        if (len > @b.attr_length)
          len = @b.attr_length
        end
        len = read(@b, 0, len)
        if ((len).equal?(-1))
          @reach_eof = true
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
        if (@uses_default_inflater)
          @inf.end
        end
        self.attr_in.close
        @closed = true
      end
    end
    
    typesig { [] }
    # Fills input buffer with more data to decompress.
    # @exception IOException if an I/O error has occurred
    def fill
      ensure_open
      @len = self.attr_in.read(@buf, 0, @buf.attr_length)
      if ((@len).equal?(-1))
        raise EOFException.new("Unexpected end of ZLIB input stream")
      end
      @inf.set_input(@buf, 0, @len)
    end
    
    typesig { [] }
    # Tests if this input stream supports the <code>mark</code> and
    # <code>reset</code> methods. The <code>markSupported</code>
    # method of <code>InflaterInputStream</code> returns
    # <code>false</code>.
    # 
    # @return  a <code>boolean</code> indicating if this stream type supports
    # the <code>mark</code> and <code>reset</code> methods.
    # @see     java.io.InputStream#mark(int)
    # @see     java.io.InputStream#reset()
    def mark_supported
      return false
    end
    
    typesig { [::Java::Int] }
    # Marks the current position in this input stream.
    # 
    # <p> The <code>mark</code> method of <code>InflaterInputStream</code>
    # does nothing.
    # 
    # @param   readlimit   the maximum limit of bytes that can be read before
    # the mark position becomes invalid.
    # @see     java.io.InputStream#reset()
    def mark(readlimit)
      synchronized(self) do
      end
    end
    
    typesig { [] }
    # Repositions this stream to the position at the time the
    # <code>mark</code> method was last called on this input stream.
    # 
    # <p> The method <code>reset</code> for class
    # <code>InflaterInputStream</code> does nothing except throw an
    # <code>IOException</code>.
    # 
    # @exception  IOException  if this method is invoked.
    # @see     java.io.InputStream#mark(int)
    # @see     java.io.IOException
    def reset
      synchronized(self) do
        raise IOException.new("mark/reset not supported")
      end
    end
    
    private
    alias_method :initialize__inflater_input_stream, :initialize
  end
  
end
