require "rjava"

# Copyright 1999-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ChunkedInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Http
      include ::Java::Io
      include ::Java::Util
      include ::Sun::Net
      include ::Sun::Net::Www
    }
  end
  
  # A <code>ChunkedInputStream</code> provides a stream for reading a body of
  # a http message that can be sent as a series of chunks, each with its own
  # size indicator. Optionally the last chunk can be followed by trailers
  # containing entity-header fields.
  # <p>
  # A <code>ChunkedInputStream</code> is also <code>Hurryable</code> so it
  # can be hurried to the end of the stream if the bytes are available on
  # the underlying stream.
  class ChunkedInputStream < ChunkedInputStreamImports.const_get :InputStream
    include_class_members ChunkedInputStreamImports
    include Hurryable
    
    # The underlying stream
    attr_accessor :in
    alias_method :attr_in, :in
    undef_method :in
    alias_method :attr_in=, :in=
    undef_method :in=
    
    # The <code>HttpClient</code> that should be notified when the chunked stream has
    # completed.
    attr_accessor :hc
    alias_method :attr_hc, :hc
    undef_method :hc
    alias_method :attr_hc=, :hc=
    undef_method :hc=
    
    # The <code>MessageHeader</code> that is populated with any optional trailer
    # that appear after the last chunk.
    attr_accessor :responses
    alias_method :attr_responses, :responses
    undef_method :responses
    alias_method :attr_responses=, :responses=
    undef_method :responses=
    
    # The size, in bytes, of the chunk that is currently being read.
    # This size is only valid if the current position in the underlying
    # input stream is inside a chunk (ie: state == STATE_READING_CHUNK).
    attr_accessor :chunk_size
    alias_method :attr_chunk_size, :chunk_size
    undef_method :chunk_size
    alias_method :attr_chunk_size=, :chunk_size=
    undef_method :chunk_size=
    
    # The number of bytes read from the underlying stream for the current
    # chunk. This value is always in the range <code>0</code> through to
    # <code>chunkSize</code>
    attr_accessor :chunk_read
    alias_method :attr_chunk_read, :chunk_read
    undef_method :chunk_read
    alias_method :attr_chunk_read=, :chunk_read=
    undef_method :chunk_read=
    
    # The internal buffer array where chunk data is available for the
    # application to read.
    attr_accessor :chunk_data
    alias_method :attr_chunk_data, :chunk_data
    undef_method :chunk_data
    alias_method :attr_chunk_data=, :chunk_data=
    undef_method :chunk_data=
    
    # The current position in the buffer. It contains the index
    # of the next byte to read from <code>chunkData</code>
    attr_accessor :chunk_pos
    alias_method :attr_chunk_pos, :chunk_pos
    undef_method :chunk_pos
    alias_method :attr_chunk_pos=, :chunk_pos=
    undef_method :chunk_pos=
    
    # The index one greater than the index of the last valid byte in the
    # buffer. This value is always in the range <code>0</code> through
    # <code>chunkData.length</code>.
    attr_accessor :chunk_count
    alias_method :attr_chunk_count, :chunk_count
    undef_method :chunk_count
    alias_method :attr_chunk_count=, :chunk_count=
    undef_method :chunk_count=
    
    # The internal buffer where bytes from the underlying stream can be
    # read. It may contain bytes representing chunk-size, chunk-data, or
    # trailer fields.
    attr_accessor :raw_data
    alias_method :attr_raw_data, :raw_data
    undef_method :raw_data
    alias_method :attr_raw_data=, :raw_data=
    undef_method :raw_data=
    
    # The current position in the buffer. It contains the index
    # of the next byte to read from <code>rawData</code>
    attr_accessor :raw_pos
    alias_method :attr_raw_pos, :raw_pos
    undef_method :raw_pos
    alias_method :attr_raw_pos=, :raw_pos=
    undef_method :raw_pos=
    
    # The index one greater than the index of the last valid byte in the
    # buffer. This value is always in the range <code>0</code> through
    # <code>rawData.length</code>.
    attr_accessor :raw_count
    alias_method :attr_raw_count, :raw_count
    undef_method :raw_count
    alias_method :attr_raw_count=, :raw_count=
    undef_method :raw_count=
    
    # Indicates if an error was encountered when processing the chunked
    # stream.
    attr_accessor :error
    alias_method :attr_error, :error
    undef_method :error
    alias_method :attr_error=, :error=
    undef_method :error=
    
    # Indicates if the chunked stream has been closed using the
    # <code>close</code> method.
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    class_module.module_eval {
      # State to indicate that next field should be :-
      # chunk-size [ chunk-extension ] CRLF
      const_set_lazy(:STATE_AWAITING_CHUNK_HEADER) { 1 }
      const_attr_reader  :STATE_AWAITING_CHUNK_HEADER
      
      # State to indicate that we are currently reading the chunk-data.
      const_set_lazy(:STATE_READING_CHUNK) { 2 }
      const_attr_reader  :STATE_READING_CHUNK
      
      # Indicates that a chunk has been completely read and the next
      # fields to be examine should be CRLF
      const_set_lazy(:STATE_AWAITING_CHUNK_EOL) { 3 }
      const_attr_reader  :STATE_AWAITING_CHUNK_EOL
      
      # Indicates that all chunks have been read and the next field
      # should be optional trailers or an indication that the chunked
      # stream is complete.
      const_set_lazy(:STATE_AWAITING_TRAILERS) { 4 }
      const_attr_reader  :STATE_AWAITING_TRAILERS
      
      # State to indicate that the chunked stream is complete and
      # no further bytes should be read from the underlying stream.
      const_set_lazy(:STATE_DONE) { 5 }
      const_attr_reader  :STATE_DONE
    }
    
    # Indicates the current state.
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    typesig { [] }
    # Check to make sure that this stream has not been closed.
    def ensure_open
      if (@closed)
        raise IOException.new("stream is closed")
      end
    end
    
    typesig { [::Java::Int] }
    # Ensures there is <code>size</code> bytes available in
    # <code>rawData</code>. This requires that we either
    # shift the bytes in use to the begining of the buffer
    # or allocate a large buffer with sufficient space available.
    def ensure_raw_available(size)
      if (@raw_count + size > @raw_data.attr_length)
        used = @raw_count - @raw_pos
        if (used + size > @raw_data.attr_length)
          tmp = Array.typed(::Java::Byte).new(used + size) { 0 }
          if (used > 0)
            System.arraycopy(@raw_data, @raw_pos, tmp, 0, used)
          end
          @raw_data = tmp
        else
          if (used > 0)
            System.arraycopy(@raw_data, @raw_pos, @raw_data, 0, used)
          end
        end
        @raw_count = used
        @raw_pos = 0
      end
    end
    
    typesig { [] }
    # Close the underlying input stream by either returning it to the
    # keep alive cache or closing the stream.
    # <p>
    # As a chunked stream is inheritly persistent (see HTTP 1.1 RFC) the
    # underlying stream can be returned to the keep alive cache if the
    # stream can be completely read without error.
    def close_underlying
      if ((@in).nil?)
        return
      end
      if (!@error && (@state).equal?(STATE_DONE))
        @hc.finished
      else
        if (!hurry)
          @hc.close_server
        end
      end
      @in = nil
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Attempt to read the remainder of a chunk directly into the
    # caller's buffer.
    # <p>
    # Return the number of bytes read.
    def fast_read(b, off, len)
      # assert state == STATE_READING_CHUNKS;
      remaining = @chunk_size - @chunk_read
      cnt = (remaining < len) ? remaining : len
      if (cnt > 0)
        nread = 0
        begin
          nread = @in.read(b, off, cnt)
        rescue IOException => e
          @error = true
          raise e
        end
        if (nread > 0)
          @chunk_read += nread
          if (@chunk_read >= @chunk_size)
            @state = STATE_AWAITING_CHUNK_EOL
          end
          return nread
        end
        @error = true
        raise IOException.new("Premature EOF")
      else
        return 0
      end
    end
    
    typesig { [] }
    # Process any outstanding bytes that have already been read into
    # <code>rawData</code>.
    # <p>
    # The parsing of the chunked stream is performed as a state machine with
    # <code>state</code> representing the current state of the processing.
    # <p>
    # Returns when either all the outstanding bytes in rawData have been
    # processed or there is insufficient bytes available to continue
    # processing. When the latter occurs <code>rawPos</code> will not have
    # been updated and thus the processing can be restarted once further
    # bytes have been read into <code>rawData</code>.
    def process_raw
      pos = 0
      i = 0
      while (!(@state).equal?(STATE_DONE))
        case (@state)
        # We are awaiting a line with a chunk header
        # 
        # 
        # We are awaiting raw entity data (some may have already been
        # read). chunkSize is the size of the chunk; chunkRead is the
        # total read from the underlying stream to date.
        # 
        # 
        # Awaiting CRLF after the chunk
        # 
        # 
        # Last chunk has been read so not we're waiting for optional
        # trailers.
        when STATE_AWAITING_CHUNK_HEADER
          # Find \n to indicate end of chunk header. If not found when there is
          # insufficient bytes in the raw buffer to parse a chunk header.
          pos = @raw_pos
          while (pos < @raw_count)
            if ((@raw_data[pos]).equal?(Character.new(?\n.ord)))
              break
            end
            ((pos += 1) - 1)
          end
          if (pos >= @raw_count)
            return
          end
          # Extract the chunk size from the header (ignoring extensions).
          header = String.new(@raw_data, @raw_pos, pos - @raw_pos + 1, "US-ASCII")
          i = 0
          while i < header.length
            if ((Character.digit(header.char_at(i), 16)).equal?(-1))
              break
            end
            ((i += 1) - 1)
          end
          begin
            @chunk_size = JavaInteger.parse_int(header.substring(0, i), 16)
          rescue NumberFormatException => e
            @error = true
            raise IOException.new("Bogus chunk size")
          end
          # Chunk has been parsed so move rawPos to first byte of chunk
          # data.
          @raw_pos = pos + 1
          @chunk_read = 0
          # A chunk size of 0 means EOF.
          if (@chunk_size > 0)
            @state = STATE_READING_CHUNK
          else
            @state = STATE_AWAITING_TRAILERS
          end
        when STATE_READING_CHUNK
          # no data available yet
          if (@raw_pos >= @raw_count)
            return
          end
          # Compute the number of bytes of chunk data available in the
          # raw buffer.
          copy_len = Math.min(@chunk_size - @chunk_read, @raw_count - @raw_pos)
          # Expand or compact chunkData if needed.
          if (@chunk_data.attr_length < @chunk_count + copy_len)
            cnt = @chunk_count - @chunk_pos
            if (@chunk_data.attr_length < cnt + copy_len)
              tmp = Array.typed(::Java::Byte).new(cnt + copy_len) { 0 }
              System.arraycopy(@chunk_data, @chunk_pos, tmp, 0, cnt)
              @chunk_data = tmp
            else
              System.arraycopy(@chunk_data, @chunk_pos, @chunk_data, 0, cnt)
            end
            @chunk_pos = 0
            @chunk_count = cnt
          end
          # Copy the chunk data into chunkData so that it's available
          # to the read methods.
          System.arraycopy(@raw_data, @raw_pos, @chunk_data, @chunk_count, copy_len)
          @raw_pos += copy_len
          @chunk_count += copy_len
          @chunk_read += copy_len
          # If all the chunk has been copied into chunkData then the next
          # token should be CRLF.
          if (@chunk_size - @chunk_read <= 0)
            @state = STATE_AWAITING_CHUNK_EOL
          else
            return
          end
        when STATE_AWAITING_CHUNK_EOL
          # not available yet
          if (@raw_pos + 1 >= @raw_count)
            return
          end
          if (!(@raw_data[@raw_pos]).equal?(Character.new(?\r.ord)))
            @error = true
            raise IOException.new("missing CR")
          end
          if (!(@raw_data[@raw_pos + 1]).equal?(Character.new(?\n.ord)))
            @error = true
            raise IOException.new("missing LF")
          end
          @raw_pos += 2
          # Move onto the next chunk
          @state = STATE_AWAITING_CHUNK_HEADER
        when STATE_AWAITING_TRAILERS
          # Do we have an entire line in the raw buffer?
          pos = @raw_pos
          while (pos < @raw_count)
            if ((@raw_data[pos]).equal?(Character.new(?\n.ord)))
              break
            end
            ((pos += 1) - 1)
          end
          if (pos >= @raw_count)
            return
          end
          if ((pos).equal?(@raw_pos))
            @error = true
            raise IOException.new("LF should be proceeded by CR")
          end
          if (!(@raw_data[pos - 1]).equal?(Character.new(?\r.ord)))
            @error = true
            raise IOException.new("LF should be proceeded by CR")
          end
          # Stream done so close underlying stream.
          if ((pos).equal?((@raw_pos + 1)))
            @state = STATE_DONE
            close_underlying
            return
          end
          # Extract any tailers and append them to the message
          # headers.
          trailer = String.new(@raw_data, @raw_pos, pos - @raw_pos, "US-ASCII")
          i = trailer.index_of(Character.new(?:.ord))
          if ((i).equal?(-1))
            raise IOException.new("Malformed tailer - format should be key:value")
          end
          key = (trailer.substring(0, i)).trim
          value = (trailer.substring(i + 1, trailer.length)).trim
          @responses.add(key, value)
          # Move onto the next trailer.
          @raw_pos = pos + 1
        end
      end
    end
    
    typesig { [] }
    # Reads any available bytes from the underlying stream into
    # <code>rawData</code> and returns the number of bytes of
    # chunk data available in <code>chunkData</code> that the
    # application can read.
    def read_ahead_non_blocking
      # If there's anything available on the underlying stream then we read
      # it into the raw buffer and process it. Processing ensures that any
      # available chunk data is made available in chunkData.
      avail = @in.available
      if (avail > 0)
        # ensure that there is space in rawData to read the available
        ensure_raw_available(avail)
        nread = 0
        begin
          nread = @in.read(@raw_data, @raw_count, avail)
        rescue IOException => e
          @error = true
          raise e
        end
        if (nread < 0)
          @error = true
          # premature EOF ?
          return -1
        end
        @raw_count += nread
        # Process the raw bytes that have been read.
        process_raw
      end
      # Return the number of chunked bytes available to read
      return @chunk_count - @chunk_pos
    end
    
    typesig { [] }
    # Reads from the underlying stream until there is chunk data
    # available in <code>chunkData</code> for the application to
    # read.
    def read_ahead_blocking
      begin
        # All of chunked response has been read to return EOF.
        if ((@state).equal?(STATE_DONE))
          return -1
        end
        # We must read into the raw buffer so make sure there is space
        # available. We use a size of 32 to avoid too much chunk data
        # being read into the raw buffer.
        ensure_raw_available(32)
        nread = 0
        begin
          nread = @in.read(@raw_data, @raw_count, @raw_data.attr_length - @raw_count)
        rescue IOException => e
          @error = true
          raise e
        end
        # If we hit EOF it means there's a problem as we should never
        # attempt to read once the last chunk and trailers have been
        # received.
        if (nread < 0)
          @error = true
          raise IOException.new("Premature EOF")
        end
        # Process the bytes from the underlying stream
        @raw_count += nread
        process_raw
      end while (@chunk_count <= 0)
      # Return the number of chunked bytes available to read
      return @chunk_count - @chunk_pos
    end
    
    typesig { [::Java::Boolean] }
    # Read ahead in either blocking or non-blocking mode. This method
    # is typically used when we run out of available bytes in
    # <code>chunkData</code> or we need to determine how many bytes
    # are available on the input stream.
    def read_ahead(allow_blocking)
      # Last chunk already received - return EOF
      if ((@state).equal?(STATE_DONE))
        return -1
      end
      # Reset position/count if data in chunkData is exhausted.
      if (@chunk_pos >= @chunk_count)
        @chunk_count = 0
        @chunk_pos = 0
      end
      # Read ahead blocking or non-blocking
      if (allow_blocking)
        return read_ahead_blocking
      else
        return read_ahead_non_blocking
      end
    end
    
    typesig { [InputStream, HttpClient, MessageHeader] }
    # Creates a <code>ChunkedInputStream</code> and saves its  arguments, for
    # later use.
    # 
    # @param   in   the underlying input stream.
    # @param   hc   the HttpClient
    # @param   responses   the MessageHeader that should be populated with optional
    # trailers.
    def initialize(in_, hc, responses)
      @in = nil
      @hc = nil
      @responses = nil
      @chunk_size = 0
      @chunk_read = 0
      @chunk_data = nil
      @chunk_pos = 0
      @chunk_count = 0
      @raw_data = nil
      @raw_pos = 0
      @raw_count = 0
      @error = false
      @closed = false
      @state = 0
      super()
      @chunk_data = Array.typed(::Java::Byte).new(4096) { 0 }
      @raw_data = Array.typed(::Java::Byte).new(32) { 0 }
      # save arguments
      @in = in_
      @responses = responses
      @hc = hc
      # Set our initial state to indicate that we are first starting to
      # look for a chunk header.
      @state = STATE_AWAITING_CHUNK_HEADER
    end
    
    typesig { [] }
    # See
    # the general contract of the <code>read</code>
    # method of <code>InputStream</code>.
    # 
    # @return     the next byte of data, or <code>-1</code> if the end of the
    # stream is reached.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read
      synchronized(self) do
        ensure_open
        if (@chunk_pos >= @chunk_count)
          if (read_ahead(true) <= 0)
            return -1
          end
        end
        return @chunk_data[((@chunk_pos += 1) - 1)] & 0xff
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads bytes from this stream into the specified byte array, starting at
    # the given offset.
    # 
    # @param      b     destination buffer.
    # @param      off   offset at which to start storing bytes.
    # @param      len   maximum number of bytes to read.
    # @return     the number of bytes read, or <code>-1</code> if the end of
    # the stream has been reached.
    # @exception  IOException  if an I/O error occurs.
    def read(b, off, len)
      synchronized(self) do
        ensure_open
        if ((off < 0) || (off > b.attr_length) || (len < 0) || ((off + len) > b.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
        avail = @chunk_count - @chunk_pos
        if (avail <= 0)
          # Optimization: if we're in the middle of the chunk read
          # directly from the underlying stream into the caller's
          # buffer
          if ((@state).equal?(STATE_READING_CHUNK))
            return fast_read(b, off, len)
          end
          # We're not in the middle of a chunk so we must read ahead
          # until there is some chunk data available.
          avail = read_ahead(true)
          if (avail < 0)
            return -1
            # EOF
          end
        end
        cnt = (avail < len) ? avail : len
        System.arraycopy(@chunk_data, @chunk_pos, b, off, cnt)
        @chunk_pos += cnt
        return cnt
      end
    end
    
    typesig { [] }
    # Returns the number of bytes that can be read from this input
    # stream without blocking.
    # 
    # @return     the number of bytes that can be read from this input
    # stream without blocking.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def available
      synchronized(self) do
        ensure_open
        avail = @chunk_count - @chunk_pos
        if (avail > 0)
          return avail
        end
        avail = read_ahead(false)
        if (avail < 0)
          return 0
        else
          return avail
        end
      end
    end
    
    typesig { [] }
    # Close the stream by either returning the connection to the
    # keep alive cache or closing the underlying stream.
    # <p>
    # If the chunked response hasn't been completely read we
    # try to "hurry" to the end of the response. If this is
    # possible (without blocking) then the connection can be
    # returned to the keep alive cache.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      synchronized(self) do
        if (@closed)
          return
        end
        close_underlying
        @closed = true
      end
    end
    
    typesig { [] }
    # Hurry the input stream by reading everything from the underlying
    # stream. If the last chunk (and optional trailers) can be read without
    # blocking then the stream is considered hurried.
    # <p>
    # Note that if an error has occured or we can't get to last chunk
    # without blocking then this stream can't be hurried and should be
    # closed.
    def hurry
      synchronized(self) do
        if ((@in).nil? || @error)
          return false
        end
        begin
          read_ahead(false)
        rescue Exception => e
          return false
        end
        if (@error)
          return false
        end
        return ((@state).equal?(STATE_DONE))
      end
    end
    
    private
    alias_method :initialize__chunked_input_stream, :initialize
  end
  
end
