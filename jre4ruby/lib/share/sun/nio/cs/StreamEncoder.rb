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
  module StreamEncoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Nio::Channels
      include ::Java::Nio::Charset
    }
  end
  
  class StreamEncoder < StreamEncoderImports.const_get :Writer
    include_class_members StreamEncoderImports
    
    class_module.module_eval {
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
    
    class_module.module_eval {
      typesig { [OutputStream, Object, String] }
      # Factories for java.io.OutputStreamWriter
      def for_output_stream_writer(out, lock, charset_name)
        csn = charset_name
        if ((csn).nil?)
          csn = RJava.cast_to_string(Charset.default_charset.name)
        end
        begin
          if (Charset.is_supported(csn))
            return StreamEncoder.new(out, lock, Charset.for_name(csn))
          end
        rescue IllegalCharsetNameException => x
        end
        raise UnsupportedEncodingException.new(csn)
      end
      
      typesig { [OutputStream, Object, Charset] }
      def for_output_stream_writer(out, lock, cs)
        return StreamEncoder.new(out, lock, cs)
      end
      
      typesig { [OutputStream, Object, CharsetEncoder] }
      def for_output_stream_writer(out, lock, enc)
        return StreamEncoder.new(out, lock, enc)
      end
      
      typesig { [WritableByteChannel, CharsetEncoder, ::Java::Int] }
      # Factory for java.nio.channels.Channels.newWriter
      def for_encoder(ch, enc, min_buffer_cap)
        return StreamEncoder.new(ch, enc, min_buffer_cap)
      end
    }
    
    typesig { [] }
    # -- Public methods corresponding to those in OutputStreamWriter --
    # All synchronization and state/argument checking is done in these public
    # methods; the concrete stream-encoder subclasses defined below need not
    # do any such checking.
    def get_encoding
      if (is_open)
        return encoding_name
      end
      return nil
    end
    
    typesig { [] }
    def flush_buffer
      synchronized((self.attr_lock)) do
        if (is_open)
          impl_flush_buffer
        else
          raise IOException.new("Stream closed")
        end
      end
    end
    
    typesig { [::Java::Int] }
    def write(c)
      cbuf = CharArray.new(1)
      cbuf[0] = RJava.cast_to_char(c)
      write(cbuf, 0, 1)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    def write(cbuf, off, len)
      synchronized((self.attr_lock)) do
        ensure_open
        if ((off < 0) || (off > cbuf.attr_length) || (len < 0) || ((off + len) > cbuf.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return
          end
        end
        impl_write(cbuf, off, len)
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    def write(str, off, len)
      # Check the len before creating a char buffer
      if (len < 0)
        raise IndexOutOfBoundsException.new
      end
      cbuf = CharArray.new(len)
      str.get_chars(off, off + len, cbuf, 0)
      write(cbuf, 0, len)
    end
    
    typesig { [] }
    def flush
      synchronized((self.attr_lock)) do
        ensure_open
        impl_flush
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
    
    # -- Charset-based stream encoder impl --
    attr_accessor :cs
    alias_method :attr_cs, :cs
    undef_method :cs
    alias_method :attr_cs=, :cs=
    undef_method :cs=
    
    attr_accessor :encoder
    alias_method :attr_encoder, :encoder
    undef_method :encoder
    alias_method :attr_encoder=, :encoder=
    undef_method :encoder=
    
    attr_accessor :bb
    alias_method :attr_bb, :bb
    undef_method :bb
    alias_method :attr_bb=, :bb=
    undef_method :bb=
    
    # Exactly one of these is non-null
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    attr_accessor :ch
    alias_method :attr_ch, :ch
    undef_method :ch
    alias_method :attr_ch=, :ch=
    undef_method :ch=
    
    # Leftover first char in a surrogate pair
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
    
    attr_accessor :lcb
    alias_method :attr_lcb, :lcb
    undef_method :lcb
    alias_method :attr_lcb=, :lcb=
    undef_method :lcb=
    
    typesig { [OutputStream, Object, Charset] }
    def initialize(out, lock, cs)
      initialize__stream_encoder(out, lock, cs.new_encoder.on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE))
    end
    
    typesig { [OutputStream, Object, CharsetEncoder] }
    def initialize(out, lock, enc)
      @is_open = false
      @cs = nil
      @encoder = nil
      @bb = nil
      @out = nil
      @ch = nil
      @have_leftover_char = false
      @leftover_char = 0
      @lcb = nil
      super(lock)
      @is_open = true
      @have_leftover_char = false
      @lcb = nil
      @out = out
      @ch = nil
      @cs = enc.charset
      @encoder = enc
      # This path disabled until direct buffers are faster
      if (false && out.is_a?(FileOutputStream))
        @ch = (out).get_channel
        if (!(@ch).nil?)
          @bb = ByteBuffer.allocate_direct(DEFAULT_BYTE_BUFFER_SIZE)
        end
      end
      if ((@ch).nil?)
        @bb = ByteBuffer.allocate(DEFAULT_BYTE_BUFFER_SIZE)
      end
    end
    
    typesig { [WritableByteChannel, CharsetEncoder, ::Java::Int] }
    def initialize(ch, enc, mbc)
      @is_open = false
      @cs = nil
      @encoder = nil
      @bb = nil
      @out = nil
      @ch = nil
      @have_leftover_char = false
      @leftover_char = 0
      @lcb = nil
      super()
      @is_open = true
      @have_leftover_char = false
      @lcb = nil
      @out = nil
      @ch = ch
      @cs = enc.charset
      @encoder = enc
      @bb = ByteBuffer.allocate(mbc < 0 ? DEFAULT_BYTE_BUFFER_SIZE : mbc)
    end
    
    typesig { [] }
    def write_bytes
      @bb.flip
      lim = @bb.limit
      pos = @bb.position
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      if (rem > 0)
        if (!(@ch).nil?)
          if (!(@ch.write(@bb)).equal?(rem))
            raise AssertError, RJava.cast_to_string(rem) if not (false)
          end
        else
          @out.write(@bb.array, @bb.array_offset + pos, rem)
        end
      end
      @bb.clear
    end
    
    typesig { [CharBuffer, ::Java::Boolean] }
    def flush_leftover_char(cb, end_of_input)
      if (!@have_leftover_char && !end_of_input)
        return
      end
      if ((@lcb).nil?)
        @lcb = CharBuffer.allocate(2)
      else
        @lcb.clear
      end
      if (@have_leftover_char)
        @lcb.put(@leftover_char)
      end
      if ((!(cb).nil?) && cb.has_remaining)
        @lcb.put(cb.get)
      end
      @lcb.flip
      while (@lcb.has_remaining || end_of_input)
        cr = @encoder.encode(@lcb, @bb, end_of_input)
        if (cr.is_underflow)
          if (@lcb.has_remaining)
            @leftover_char = @lcb.get
            if (!(cb).nil? && cb.has_remaining)
              flush_leftover_char(cb, end_of_input)
            end
            return
          end
          break
        end
        if (cr.is_overflow)
          raise AssertError if not (@bb.position > 0)
          write_bytes
          next
        end
        cr.throw_exception
      end
      @have_leftover_char = false
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    def impl_write(cbuf, off, len)
      cb = CharBuffer.wrap(cbuf, off, len)
      if (@have_leftover_char)
        flush_leftover_char(cb, false)
      end
      while (cb.has_remaining)
        cr = @encoder.encode(cb, @bb, false)
        if (cr.is_underflow)
          raise AssertError, RJava.cast_to_string(cb.remaining) if not ((cb.remaining <= 1))
          if ((cb.remaining).equal?(1))
            @have_leftover_char = true
            @leftover_char = cb.get
          end
          break
        end
        if (cr.is_overflow)
          raise AssertError if not (@bb.position > 0)
          write_bytes
          next
        end
        cr.throw_exception
      end
    end
    
    typesig { [] }
    def impl_flush_buffer
      if (@bb.position > 0)
        write_bytes
      end
    end
    
    typesig { [] }
    def impl_flush
      impl_flush_buffer
      if (!(@out).nil?)
        @out.flush
      end
    end
    
    typesig { [] }
    def impl_close
      flush_leftover_char(nil, true)
      begin
        loop do
          cr = @encoder.flush(@bb)
          if (cr.is_underflow)
            break
          end
          if (cr.is_overflow)
            raise AssertError if not (@bb.position > 0)
            write_bytes
            next
          end
          cr.throw_exception
        end
        if (@bb.position > 0)
          write_bytes
        end
        if (!(@ch).nil?)
          @ch.close
        else
          @out.close
        end
      rescue IOException => x
        @encoder.reset
        raise x
      end
    end
    
    typesig { [] }
    def encoding_name
      return ((@cs.is_a?(HistoricallyNamedCharset)) ? (@cs).historical_name : @cs.name)
    end
    
    private
    alias_method :initialize__stream_encoder, :initialize
  end
  
end
