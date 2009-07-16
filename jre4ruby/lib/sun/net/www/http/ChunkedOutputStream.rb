require "rjava"

# 
# Copyright 2004-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Http
  module ChunkedOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Http
      include ::Java::Io
    }
  end
  
  # 
  # OutputStream that sends the output to the underlying stream using chunked
  # encoding as specified in RFC 2068.
  # 
  # @author  Alan Bateman
  class ChunkedOutputStream < ChunkedOutputStreamImports.const_get :PrintStream
    include_class_members ChunkedOutputStreamImports
    
    class_module.module_eval {
      # Default chunk size (including chunk header) if not specified
      const_set_lazy(:DEFAULT_CHUNK_SIZE) { 4096 }
      const_attr_reader  :DEFAULT_CHUNK_SIZE
    }
    
    # internal buffer
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # underlying stream
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    # the chunk size we use
    attr_accessor :preferred_chunk_size
    alias_method :attr_preferred_chunk_size, :preferred_chunk_size
    undef_method :preferred_chunk_size
    alias_method :attr_preferred_chunk_size=, :preferred_chunk_size=
    undef_method :preferred_chunk_size=
    
    class_module.module_eval {
      # if the users write buffer is bigger than this size, we
      # write direct from the users buffer instead of copying
      const_set_lazy(:MAX_BUF_SIZE) { 10 * 1024 }
      const_attr_reader  :MAX_BUF_SIZE
    }
    
    typesig { [::Java::Int] }
    # return the size of the header for a particular chunk size
    def header_size(size)
      return 2 + (JavaInteger.to_hex_string(size)).length
    end
    
    typesig { [PrintStream] }
    def initialize(o)
      initialize__chunked_output_stream(o, DEFAULT_CHUNK_SIZE)
    end
    
    typesig { [PrintStream, ::Java::Int] }
    def initialize(o, size)
      @buf = nil
      @count = 0
      @out = nil
      @preferred_chunk_size = 0
      super(o)
      @out = o
      if (size <= 0)
        size = DEFAULT_CHUNK_SIZE
      end
      # Adjust the size to cater for the chunk header - eg: if the
      # preferred chunk size is 1k this means the chunk size should
      # be 1019 bytes (differs by 5 from preferred size because of
      # 3 bytes for chunk size in hex and CRLF).
      if (size > 0)
        adjusted_size = size - header_size(size)
        if (adjusted_size + header_size(adjusted_size) < size)
          ((adjusted_size += 1) - 1)
        end
        size = adjusted_size
      end
      if (size > 0)
        @preferred_chunk_size = size
      else
        @preferred_chunk_size = DEFAULT_CHUNK_SIZE - header_size(DEFAULT_CHUNK_SIZE)
      end
      # start with an initial buffer
      @buf = Array.typed(::Java::Byte).new(@preferred_chunk_size + 32) { 0 }
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Boolean] }
    # 
    # If flushAll is true, then all data is flushed in one chunk.
    # 
    # If false and the size of the buffer data exceeds the preferred
    # chunk size then chunks are flushed to the output stream.
    # If there isn't enough data to make up a complete chunk,
    # then the method returns.
    def flush(buf, flush_all)
      flush(buf, flush_all, 0)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Boolean, ::Java::Int] }
    def flush(buf, flush_all, offset)
      chunk_size = 0
      begin
        if (@count < @preferred_chunk_size)
          if (!flush_all)
            break
          end
          chunk_size = @count
        else
          chunk_size = @preferred_chunk_size
        end
        bytes = nil
        begin
          bytes = (JavaInteger.to_hex_string(chunk_size)).get_bytes("US-ASCII")
        rescue Java::Io::UnsupportedEncodingException => e
          # This should never happen.
          raise InternalError.new(e.get_message)
        end
        @out.write(bytes, 0, bytes.attr_length)
        @out.write(Character.new(?\r.ord))
        @out.write(Character.new(?\n.ord))
        if (chunk_size > 0)
          @out.write(buf, offset, chunk_size)
          @out.write(Character.new(?\r.ord))
          @out.write(Character.new(?\n.ord))
        end
        @out.flush
        if (check_error)
          break
        end
        if (chunk_size > 0)
          @count -= chunk_size
          offset += chunk_size
        end
      end while (@count > 0)
      if (!check_error && @count > 0)
        System.arraycopy(buf, offset, @buf, 0, @count)
      end
    end
    
    typesig { [] }
    def check_error
      return @out.check_error
    end
    
    typesig { [] }
    # 
    # Check if we have enough data for a chunk and if so flush to the
    # underlying output stream.
    def check_flush
      if (@count >= @preferred_chunk_size)
        flush(@buf, false)
      end
    end
    
    typesig { [] }
    # Check that the output stream is still open
    def ensure_open
      if ((@out).nil?)
        set_error
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def write(b, off, len)
      synchronized(self) do
        ensure_open
        if ((off < 0) || (off > b.attr_length) || (len < 0) || ((off + len) > b.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return
          end
        end
        if (len > MAX_BUF_SIZE)
          # first finish the current chunk
          l = @preferred_chunk_size - @count
          if (l > 0)
            System.arraycopy(b, off, @buf, @count, l)
            @count = @preferred_chunk_size
            flush(@buf, false)
          end
          @count = len - l
          # Now write the rest of the data
          flush(b, false, l + off)
        else
          newcount = @count + len
          if (newcount > @buf.attr_length)
            newbuf = Array.typed(::Java::Byte).new(Math.max(@buf.attr_length << 1, newcount)) { 0 }
            System.arraycopy(@buf, 0, newbuf, 0, @count)
            @buf = newbuf
          end
          System.arraycopy(b, off, @buf, @count, len)
          @count = newcount
          check_flush
        end
      end
    end
    
    typesig { [::Java::Int] }
    def write(b)
      synchronized(self) do
        ensure_open
        newcount = @count + 1
        if (newcount > @buf.attr_length)
          newbuf = Array.typed(::Java::Byte).new(Math.max(@buf.attr_length << 1, newcount)) { 0 }
          System.arraycopy(@buf, 0, newbuf, 0, @count)
          @buf = newbuf
        end
        @buf[@count] = b
        @count = newcount
        check_flush
      end
    end
    
    typesig { [] }
    def reset
      synchronized(self) do
        @count = 0
      end
    end
    
    typesig { [] }
    def size
      return @count
    end
    
    typesig { [] }
    def close
      synchronized(self) do
        ensure_open
        # if we have buffer a chunked send it
        if (@count > 0)
          flush(@buf, true)
        end
        # send a zero length chunk
        flush(@buf, true)
        # don't close the underlying stream
        @out = nil
      end
    end
    
    typesig { [] }
    def flush
      synchronized(self) do
        ensure_open
        if (@count > 0)
          flush(@buf, true)
        end
      end
    end
    
    private
    alias_method :initialize__chunked_output_stream, :initialize
  end
  
end
