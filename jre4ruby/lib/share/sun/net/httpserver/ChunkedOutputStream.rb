require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Httpserver
  module ChunkedOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Net
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # a class which allows the caller to write an arbitrary
  # number of bytes to an underlying stream.
  # normal close() does not close the underlying stream
  # 
  # This class is buffered.
  # 
  # Each chunk is written in one go as :-
  # abcd\r\nxxxxxxxxxxxxxx\r\n
  # 
  # abcd is the chunk-size, and xxx is the chunk data
  # If the length is less than 4 chars (in size) then the buffer
  # is written with an offset.
  # Final chunk is:
  # 0\r\n\r\n
  class ChunkedOutputStream < ChunkedOutputStreamImports.const_get :FilterOutputStream
    include_class_members ChunkedOutputStreamImports
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    class_module.module_eval {
      # max. amount of user data per chunk
      const_set_lazy(:CHUNK_SIZE) { 4096 }
      const_attr_reader  :CHUNK_SIZE
      
      # allow 4 bytes for chunk-size plus 4 for CRLFs
      const_set_lazy(:OFFSET) { 6 }
      const_attr_reader  :OFFSET
    }
    
    # initial <=4 bytes for len + CRLF
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    attr_accessor :t
    alias_method :attr_t, :t
    undef_method :t
    alias_method :attr_t=, :t=
    undef_method :t=
    
    typesig { [ExchangeImpl, OutputStream] }
    def initialize(t, src)
      @closed = false
      @pos = 0
      @count = 0
      @buf = nil
      @t = nil
      super(src)
      @closed = false
      @pos = OFFSET
      @count = 0
      @buf = Array.typed(::Java::Byte).new(CHUNK_SIZE + OFFSET + 2) { 0 }
      @t = t
    end
    
    typesig { [::Java::Int] }
    def write(b)
      if (@closed)
        raise StreamClosedException.new
      end
      @buf[((@pos += 1) - 1)] = b
      @count += 1
      if ((@count).equal?(CHUNK_SIZE))
        write_chunk
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def write(b, off, len)
      if (@closed)
        raise StreamClosedException.new
      end
      remain = CHUNK_SIZE - @count
      if (len > remain)
        System.arraycopy(b, off, @buf, @pos, remain)
        @count = CHUNK_SIZE
        write_chunk
        len -= remain
        off += remain
        while (len > CHUNK_SIZE)
          System.arraycopy(b, off, @buf, OFFSET, CHUNK_SIZE)
          len -= CHUNK_SIZE
          off += CHUNK_SIZE
          @count = CHUNK_SIZE
          write_chunk
        end
        @pos = OFFSET
      end
      if (len > 0)
        System.arraycopy(b, off, @buf, @pos, len)
        @count += len
        @pos += len
      end
    end
    
    typesig { [] }
    # write out a chunk , and reset the pointers
    # chunk does not have to be CHUNK_SIZE bytes
    # count must == number of user bytes (<= CHUNK_SIZE)
    def write_chunk
      c = JavaInteger.to_hex_string(@count).to_char_array
      clen = c.attr_length
      start_byte = 4 - clen
      i = 0
      i = 0
      while i < clen
        @buf[start_byte + i] = c[i]
        i += 1
      end
      @buf[start_byte + (((i += 1) - 1))] = Character.new(?\r.ord)
      @buf[start_byte + (((i += 1) - 1))] = Character.new(?\n.ord)
      @buf[start_byte + (((i += 1) - 1)) + @count] = Character.new(?\r.ord)
      @buf[start_byte + (((i += 1) - 1)) + @count] = Character.new(?\n.ord)
      self.attr_out.write(@buf, start_byte, i + @count)
      @count = 0
      @pos = OFFSET
    end
    
    typesig { [] }
    def close
      if (@closed)
        return
      end
      flush
      begin
        # write an empty chunk
        write_chunk
        self.attr_out.flush
        is = @t.get_original_input_stream
        if (!is.is_closed)
          is.close
        end
        # some clients close the connection before empty chunk is sent
      rescue IOException => e
      ensure
        @closed = true
      end
      e = WriteFinishedEvent.new(@t)
      @t.get_http_context.get_server_impl.add_event(e)
    end
    
    typesig { [] }
    def flush
      if (@closed)
        raise StreamClosedException.new
      end
      if (@count > 0)
        write_chunk
      end
      self.attr_out.flush
    end
    
    private
    alias_method :initialize__chunked_output_stream, :initialize
  end
  
end
