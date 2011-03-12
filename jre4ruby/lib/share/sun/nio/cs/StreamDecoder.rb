require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module StreamDecoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Nio::Channels
      include ::Java::Nio::Charset
    }
  end
  
  class StreamDecoder < StreamDecoderImports.const_get :Reader
    include_class_members StreamDecoderImports
    
    class_module.module_eval {
      const_set_lazy(:MIN_BYTE_BUFFER_SIZE) { 32 }
      const_attr_reader  :MIN_BYTE_BUFFER_SIZE
      
      const_set_lazy(:DEFAULT_BYTE_BUFFER_SIZE) { 8192 }
      const_attr_reader  :DEFAULT_BYTE_BUFFER_SIZE
    }
    
    attr_accessor :is_open
    alias_method :attr_is_open, :is_open
    undef_method :is_open
    alias_method :attr_is_open=, :is_open=
    undef_method :is_open=
    
    typesig { [] }
    def ensure_open
      if (!@is_open)
        raise IOException.new("Stream closed")
      end
    end
    
    # In order to handle surrogates properly we must never try to produce
    # fewer than two characters at a time.  If we're only asked to return one
    # character then the other is saved here to be returned later.
    # 
    attr_accessor :have_leftover_char
    alias_method :attr_have_leftover_char, :have_leftover_char
    undef_method :have_leftover_char
    alias_method :attr_have_leftover_char=, :have_leftover_char=
    undef_method :have_leftover_char=
    
    attr_accessor :leftover_char
    alias_method :attr_leftover_char, :leftover_char
    undef_method :leftover_char
    alias_method :attr_leftover_char=, :leftover_char=
    undef_method :leftover_char=
    
    class_module.module_eval {
      typesig { [InputStream, Object, String] }
      # Factories for java.io.InputStreamReader
      def for_input_stream_reader(in_, lock, charset_name)
        csn = charset_name
        if ((csn).nil?)
          csn = RJava.cast_to_string(Charset.default_charset.name)
        end
        begin
          if (Charset.is_supported(csn))
            return StreamDecoder.new(in_, lock, Charset.for_name(csn))
          end
        rescue IllegalCharsetNameException => x
        end
        raise UnsupportedEncodingException.new(csn)
      end
      
      typesig { [InputStream, Object, Charset] }
      def for_input_stream_reader(in_, lock, cs)
        return StreamDecoder.new(in_, lock, cs)
      end
      
      typesig { [InputStream, Object, CharsetDecoder] }
      def for_input_stream_reader(in_, lock, dec)
        return StreamDecoder.new(in_, lock, dec)
      end
      
      typesig { [ReadableByteChannel, CharsetDecoder, ::Java::Int] }
      # Factory for java.nio.channels.Channels.newReader
      def for_decoder(ch, dec, min_buffer_cap)
        return StreamDecoder.new(ch, dec, min_buffer_cap)
      end
    }
    
    typesig { [] }
    # -- Public methods corresponding to those in InputStreamReader --
    # All synchronization and state/argument checking is done in these public
    # methods; the concrete stream-decoder subclasses defined below need not
    # do any such checking.
    def get_encoding
      if (is_open)
        return encoding_name
      end
      return nil
    end
    
    typesig { [] }
    def read
      return read0
    end
    
    typesig { [] }
    def read0
      synchronized((self.attr_lock)) do
        # Return the leftover char, if there is one
        if (@have_leftover_char)
          @have_leftover_char = false
          return @leftover_char
        end
        # Convert more bytes
        cb = CharArray.new(2)
        n = read(cb, 0, 2)
        case (n)
        when -1
          return -1
        when 2
          @leftover_char = cb[1]
          @have_leftover_char = true
          # FALL THROUGH
          return cb[0]
        when 1
          # FALL THROUGH
          return cb[0]
        else
          raise AssertError, RJava.cast_to_string(n) if not (false)
          return -1
        end
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    def read(cbuf, offset, length)
      off = offset
      len = length
      synchronized((self.attr_lock)) do
        ensure_open
        if ((off < 0) || (off > cbuf.attr_length) || (len < 0) || ((off + len) > cbuf.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        end
        if ((len).equal?(0))
          return 0
        end
        n = 0
        if (@have_leftover_char)
          # Copy the leftover char into the buffer
          cbuf[off] = @leftover_char
          off += 1
          len -= 1
          @have_leftover_char = false
          n = 1
          if (((len).equal?(0)) || !impl_ready)
            # Return now if this is all we can produce w/o blocking
            return n
          end
        end
        if ((len).equal?(1))
          # Treat single-character array reads just like read()
          c = read0
          if ((c).equal?(-1))
            return ((n).equal?(0)) ? -1 : n
          end
          cbuf[off] = RJava.cast_to_char(c)
          return n + 1
        end
        return n + impl_read(cbuf, off, off + len)
      end
    end
    
    typesig { [] }
    def ready
      synchronized((self.attr_lock)) do
        ensure_open
        return @have_leftover_char || impl_ready
      end
    end
    
    typesig { [] }
    def close
      synchronized((self.attr_lock)) do
        if (!@is_open)
          return
        end
        impl_close
        @is_open = false
      end
    end
    
    typesig { [] }
    def is_open
      return @is_open
    end
    
    class_module.module_eval {
      # -- Charset-based stream decoder impl --
      # In the early stages of the build we haven't yet built the NIO native
      # code, so guard against that by catching the first UnsatisfiedLinkError
      # and setting this flag so that later attempts fail quickly.
      # 
      
      def channels_available
        defined?(@@channels_available) ? @@channels_available : @@channels_available= true
      end
      alias_method :attr_channels_available, :channels_available
      
      def channels_available=(value)
        @@channels_available = value
      end
      alias_method :attr_channels_available=, :channels_available=
      
      typesig { [FileInputStream] }
      def get_channel(in_)
        if (!self.attr_channels_available)
          return nil
        end
        begin
          return in_.get_channel
        rescue UnsatisfiedLinkError => x
          self.attr_channels_available = false
          return nil
        end
      end
    }
    
    attr_accessor :cs
    alias_method :attr_cs, :cs
    undef_method :cs
    alias_method :attr_cs=, :cs=
    undef_method :cs=
    
    attr_accessor :decoder
    alias_method :attr_decoder, :decoder
    undef_method :decoder
    alias_method :attr_decoder=, :decoder=
    undef_method :decoder=
    
    attr_accessor :bb
    alias_method :attr_bb, :bb
    undef_method :bb
    alias_method :attr_bb=, :bb=
    undef_method :bb=
    
    # Exactly one of these is non-null
    attr_accessor :in
    alias_method :attr_in, :in
    undef_method :in
    alias_method :attr_in=, :in=
    undef_method :in=
    
    attr_accessor :ch
    alias_method :attr_ch, :ch
    undef_method :ch
    alias_method :attr_ch=, :ch=
    undef_method :ch=
    
    typesig { [InputStream, Object, Charset] }
    def initialize(in_, lock, cs)
      initialize__stream_decoder(in_, lock, cs.new_decoder.on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE))
    end
    
    typesig { [InputStream, Object, CharsetDecoder] }
    def initialize(in_, lock, dec)
      @is_open = false
      @have_leftover_char = false
      @leftover_char = 0
      @cs = nil
      @decoder = nil
      @bb = nil
      @in = nil
      @ch = nil
      super(lock)
      @is_open = true
      @have_leftover_char = false
      @cs = dec.charset
      @decoder = dec
      # This path disabled until direct buffers are faster
      if (false && in_.is_a?(FileInputStream))
        @ch = get_channel(in_)
        if (!(@ch).nil?)
          @bb = ByteBuffer.allocate_direct(DEFAULT_BYTE_BUFFER_SIZE)
        end
      end
      if ((@ch).nil?)
        @in = in_
        @ch = nil
        @bb = ByteBuffer.allocate_(DEFAULT_BYTE_BUFFER_SIZE)
      end
      @bb.flip # So that bb is initially empty
    end
    
    typesig { [ReadableByteChannel, CharsetDecoder, ::Java::Int] }
    def initialize(ch, dec, mbc)
      @is_open = false
      @have_leftover_char = false
      @leftover_char = 0
      @cs = nil
      @decoder = nil
      @bb = nil
      @in = nil
      @ch = nil
      super()
      @is_open = true
      @have_leftover_char = false
      @in = nil
      @ch = ch
      @decoder = dec
      @cs = dec.charset
      @bb = ByteBuffer.allocate_(mbc < 0 ? DEFAULT_BYTE_BUFFER_SIZE : (mbc < MIN_BYTE_BUFFER_SIZE ? MIN_BYTE_BUFFER_SIZE : mbc))
      @bb.flip
    end
    
    typesig { [] }
    def read_bytes
      @bb.compact
      begin
        if (!(@ch).nil?)
          # Read from the channel
          n = @ch.read(@bb)
          if (n < 0)
            return n
          end
        else
          # Read from the input stream, and then update the buffer
          lim = @bb.limit
          pos = @bb.position
          raise AssertError if not ((pos <= lim))
          rem = (pos <= lim ? lim - pos : 0)
          raise AssertError if not (rem > 0)
          n = @in.read(@bb.array, @bb.array_offset + pos, rem)
          if (n < 0)
            return n
          end
          if ((n).equal?(0))
            raise IOException.new("Underlying input stream returned zero bytes")
          end
          raise AssertError, "n = " + RJava.cast_to_string(n) + ", rem = " + RJava.cast_to_string(rem) if not ((n <= rem))
          @bb.position(pos + n)
        end
      ensure
        # Flip even when an IOException is thrown,
        # otherwise the stream will stutter
        @bb.flip
      end
      rem = @bb.remaining
      raise AssertError, RJava.cast_to_string(rem) if not ((!(rem).equal?(0)))
      return rem
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    def impl_read(cbuf, off, end_)
      # In order to handle surrogate pairs, this method requires that
      # the invoker attempt to read at least two characters.  Saving the
      # extra character, if any, at a higher level is easier than trying
      # to deal with it here.
      raise AssertError if not ((end_ - off > 1))
      cb = CharBuffer.wrap(cbuf, off, end_ - off)
      if (!(cb.position).equal?(0))
        # Ensure that cb[0] == cbuf[off]
        cb = cb.slice
      end
      eof = false
      loop do
        cr = @decoder.decode(@bb, cb, eof)
        if (cr.is_underflow)
          if (eof)
            break
          end
          if (!cb.has_remaining)
            break
          end
          if ((cb.position > 0) && !in_ready)
            break
          end # Block at most once
          n = read_bytes
          if (n < 0)
            eof = true
            if (((cb.position).equal?(0)) && (!@bb.has_remaining))
              break
            end
            @decoder.reset
          end
          next
        end
        if (cr.is_overflow)
          raise AssertError if not (cb.position > 0)
          break
        end
        cr.throw_exception
      end
      if (eof)
        # ## Need to flush decoder
        @decoder.reset
      end
      if ((cb.position).equal?(0))
        if (eof)
          return -1
        end
        raise AssertError if not (false)
      end
      return cb.position
    end
    
    typesig { [] }
    def encoding_name
      return ((@cs.is_a?(HistoricallyNamedCharset)) ? (@cs).historical_name : @cs.name)
    end
    
    typesig { [] }
    def in_ready
      begin
        return (((!(@in).nil?) && (@in.available > 0)) || (@ch.is_a?(FileChannel))) # ## RBC.available()?
      rescue IOException => x
        return false
      end
    end
    
    typesig { [] }
    def impl_ready
      return @bb.has_remaining || in_ready
    end
    
    typesig { [] }
    def impl_close
      if (!(@ch).nil?)
        @ch.close
      else
        @in.close
      end
    end
    
    private
    alias_method :initialize__stream_decoder, :initialize
  end
  
end
