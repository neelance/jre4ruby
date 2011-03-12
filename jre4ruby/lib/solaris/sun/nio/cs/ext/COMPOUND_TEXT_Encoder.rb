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
module Sun::Nio::Cs::Ext
  module COMPOUND_TEXT_EncoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include ::Java::Nio::Charset
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
    }
  end
  
  class COMPOUND_TEXT_Encoder < COMPOUND_TEXT_EncoderImports.const_get :CharsetEncoder
    include_class_members COMPOUND_TEXT_EncoderImports
    
    class_module.module_eval {
      # NOTE: The following four static variables should be used *only* for
      # testing whether a encoder can encode a specific character. They
      # cannot be used for actual encoding because they are shared across all
      # COMPOUND_TEXT encoders and may be stateful.
      const_set_lazy(:EncodingToEncoderMap) { Collections.synchronized_map(HashMap.new(21, 1.0)) }
      const_attr_reader  :EncodingToEncoderMap
      
      when_class_loaded do
        encoder = Charset.default_charset.new_encoder
        encoding = encoder.charset.name
        if (("ISO8859_1" == encoding))
          const_set :Latin1Encoder, encoder
          const_set :DefaultEncoder, encoder
          const_set :DefaultEncodingSupported, true
        else
          begin
            const_set :Latin1Encoder, Charset.for_name("ISO8859_1").new_encoder
          rescue IllegalArgumentException => e
            raise ExceptionInInitializerError.new("ISO8859_1 unsupported")
          end
          const_set :DefaultEncoder, encoder
          const_set :DefaultEncodingSupported, CompoundTextSupport.get_encodings.contains(DefaultEncoder.charset.name)
        end
      end
    }
    
    attr_accessor :encoder
    alias_method :attr_encoder, :encoder
    undef_method :encoder
    alias_method :attr_encoder=, :encoder=
    undef_method :encoder=
    
    attr_accessor :char_buf
    alias_method :attr_char_buf, :char_buf
    undef_method :char_buf
    alias_method :attr_char_buf=, :char_buf=
    undef_method :char_buf=
    
    attr_accessor :charbuf
    alias_method :attr_charbuf, :charbuf
    undef_method :charbuf
    alias_method :attr_charbuf=, :charbuf=
    undef_method :charbuf=
    
    attr_accessor :non_standard_charset_buffer
    alias_method :attr_non_standard_charset_buffer, :non_standard_charset_buffer
    undef_method :non_standard_charset_buffer
    alias_method :attr_non_standard_charset_buffer=, :non_standard_charset_buffer=
    undef_method :non_standard_charset_buffer=
    
    attr_accessor :byte_buf
    alias_method :attr_byte_buf, :byte_buf
    undef_method :byte_buf
    alias_method :attr_byte_buf=, :byte_buf=
    undef_method :byte_buf=
    
    attr_accessor :bytebuf
    alias_method :attr_bytebuf, :bytebuf
    undef_method :bytebuf
    alias_method :attr_bytebuf=, :bytebuf=
    undef_method :bytebuf=
    
    attr_accessor :num_non_standard_chars
    alias_method :attr_num_non_standard_chars, :num_non_standard_chars
    undef_method :num_non_standard_chars
    alias_method :attr_num_non_standard_chars=, :num_non_standard_chars=
    undef_method :num_non_standard_chars=
    
    attr_accessor :non_standard_encoding_len
    alias_method :attr_non_standard_encoding_len, :non_standard_encoding_len
    undef_method :non_standard_encoding_len
    alias_method :attr_non_standard_encoding_len=, :non_standard_encoding_len=
    undef_method :non_standard_encoding_len=
    
    typesig { [Charset] }
    def initialize(cs)
      @encoder = nil
      @char_buf = nil
      @charbuf = nil
      @non_standard_charset_buffer = nil
      @byte_buf = nil
      @bytebuf = nil
      @num_non_standard_chars = 0
      @non_standard_encoding_len = 0
      @fcb = nil
      super(cs, ((CompoundTextSupport::MAX_CONTROL_SEQUENCE_LEN + 2)).to_f, ((CompoundTextSupport::MAX_CONTROL_SEQUENCE_LEN + 2)).to_f)
      @char_buf = CharArray.new(1)
      @charbuf = CharBuffer.wrap(@char_buf)
      @fcb = CharBuffer.allocate_(0)
      begin
        @encoder = Charset.for_name("ISO8859_1").new_encoder
      rescue IllegalArgumentException => cannot_happen
      end
      init_encoder(@encoder)
    end
    
    typesig { [CharBuffer, ByteBuffer] }
    def encode_loop(src, des)
      cr = CoderResult::UNDERFLOW
      input = src.array
      in_off = src.array_offset + src.position
      in_end = src.array_offset + src.limit
      begin
        while (in_off < in_end && cr.is_underflow)
          @char_buf[0] = input[in_off]
          if (@char_buf[0] <= Character.new(0x0008) || (@char_buf[0] >= Character.new(0x000B) && @char_buf[0] <= Character.new(0x001F)) || (@char_buf[0] >= Character.new(0x0080) && @char_buf[0] <= Character.new(0x009F)))
            # The compound text specification only permits the octets
            # 0x09, 0x0A, 0x1B, and 0x9B in C0 and C1. Of these, 1B and
            # 9B must also be removed because they initiate control
            # sequences.
            @char_buf[0] = Character.new(??.ord)
          end
          enc = get_encoder(@char_buf[0])
          # System.out.println("char=" + charBuf[0] + ", enc=" + enc);
          if ((enc).nil?)
            if ((unmappable_character_action).equal?(CodingErrorAction::REPORT))
              @char_buf[0] = Character.new(??.ord)
              enc = Latin1Encoder
            else
              return CoderResult.unmappable_for_length(1)
            end
          end
          if (!(enc).equal?(@encoder))
            if (!(@non_standard_charset_buffer).nil?)
              cr = flush_non_standard_charset_buffer(des)
            else
              # cr= encoder.flush(des);
              flush_encoder(@encoder, des)
            end
            if (!cr.is_underflow)
              return cr
            end
            esc_sequence = CompoundTextSupport.get_escape_sequence(enc.charset.name)
            if ((esc_sequence).nil?)
              raise InternalError.new("Unknown encoding: " + RJava.cast_to_string(enc.charset.name))
            else
              if ((esc_sequence[1]).equal?(0x25) && (esc_sequence[2]).equal?(0x2f))
                init_non_standard_charset_buffer(enc, esc_sequence)
              else
                if (des.remaining >= esc_sequence.attr_length)
                  des.put(esc_sequence, 0, esc_sequence.attr_length)
                else
                  return CoderResult::OVERFLOW
                end
              end
            end
            @encoder = enc
            next
          end
          @charbuf.rewind
          if ((@non_standard_charset_buffer).nil?)
            cr = @encoder.encode(@charbuf, des, false)
          else
            @bytebuf.clear
            cr = @encoder.encode(@charbuf, @bytebuf, false)
            @bytebuf.flip
            @non_standard_charset_buffer.write(@byte_buf, 0, @bytebuf.limit)
            @num_non_standard_chars += 1
          end
          in_off += 1
        end
        return cr
      ensure
        src.position(in_off - src.array_offset)
      end
    end
    
    typesig { [ByteBuffer] }
    def impl_flush(out)
      # : encoder.flush(out);
      cr = (!(@non_standard_charset_buffer).nil?) ? flush_non_standard_charset_buffer(out) : flush_encoder(@encoder, out)
      reset
      return cr
    end
    
    typesig { [CharsetEncoder, Array.typed(::Java::Byte)] }
    def init_non_standard_charset_buffer(c, esc_sequence)
      @non_standard_charset_buffer = ByteArrayOutputStream.new
      @byte_buf = Array.typed(::Java::Byte).new((c.max_bytes_per_char).to_int) { 0 }
      @bytebuf = ByteBuffer.wrap(@byte_buf)
      @non_standard_charset_buffer.write(esc_sequence, 0, esc_sequence.attr_length)
      @non_standard_charset_buffer.write(0) # M placeholder
      @non_standard_charset_buffer.write(0) # L placeholder
      encoding = CompoundTextSupport.get_encoding(c.charset.name)
      if ((encoding).nil?)
        raise InternalError.new("Unknown encoding: " + RJava.cast_to_string(@encoder.charset.name))
      end
      @non_standard_charset_buffer.write(encoding, 0, encoding.attr_length)
      @non_standard_charset_buffer.write(0x2) # divider
      @non_standard_encoding_len = encoding.attr_length + 1
    end
    
    typesig { [ByteBuffer] }
    def flush_non_standard_charset_buffer(out)
      if (@num_non_standard_chars > 0)
        flush_buf = Array.typed(::Java::Byte).new((@encoder.max_bytes_per_char).to_int * @num_non_standard_chars) { 0 }
        bb = ByteBuffer.wrap(flush_buf)
        flush_encoder(@encoder, bb)
        bb.flip
        @non_standard_charset_buffer.write(flush_buf, 0, bb.limit)
        @num_non_standard_chars = 0
      end
      num_bytes = @non_standard_charset_buffer.size
      non_standard_bytes_off = 6 + @non_standard_encoding_len
      if (out.remaining < (num_bytes - non_standard_bytes_off) + non_standard_bytes_off * (((num_bytes - non_standard_bytes_off) / ((1 << 14) - 1)) + 1))
        return CoderResult::OVERFLOW
      end
      non_standard_bytes = @non_standard_charset_buffer.to_byte_array
      # The non-standard charset header only supports 2^14-1 bytes of data.
      # If we have more than that, we have to repeat the header.
      begin
        out.put(0x1b)
        out.put(0x25)
        out.put(0x2f)
        out.put(non_standard_bytes[3])
        to_write = Math.min(num_bytes - non_standard_bytes_off, (1 << 14) - 1 - @non_standard_encoding_len)
        out.put((((to_write + @non_standard_encoding_len) / 0x80) | 0x80)) # M
        out.put((((to_write + @non_standard_encoding_len) % 0x80) | 0x80)) # L
        out.put(non_standard_bytes, 6, @non_standard_encoding_len)
        out.put(non_standard_bytes, non_standard_bytes_off, to_write)
        non_standard_bytes_off += to_write
      end while (non_standard_bytes_off < num_bytes)
      @non_standard_charset_buffer = nil
      @byte_buf = nil
      @non_standard_encoding_len = 0
      return CoderResult::UNDERFLOW
    end
    
    typesig { [] }
    # Resets the encoder.
    # Call this method to reset the encoder to its initial state
    def impl_reset
      @num_non_standard_chars = @non_standard_encoding_len = 0
      @non_standard_charset_buffer = nil
      @byte_buf = nil
      begin
        @encoder = Charset.for_name("ISO8859_1").new_encoder
      rescue IllegalArgumentException => cannot_happen
      end
      init_encoder(@encoder)
    end
    
    typesig { [::Java::Char] }
    # Return whether a character is mappable or not
    # @return true if a character is mappable
    def can_encode(ch)
      return !(get_encoder(ch)).nil?
    end
    
    typesig { [CodingErrorAction] }
    def impl_on_malformed_input(new_action)
      @encoder.on_unmappable_character(new_action)
    end
    
    typesig { [CodingErrorAction] }
    def impl_on_unmappable_character(new_action)
      @encoder.on_unmappable_character(new_action)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def impl_replace_with(new_replacement)
      if (!(@encoder).nil?)
        @encoder.replace_with(new_replacement)
      end
    end
    
    typesig { [::Java::Char] }
    # Try to figure out which CharsetEncoder to use for conversion
    # of the specified Unicode character. The target character encoding
    # of the returned encoder is approved to be used with Compound Text.
    # 
    # @param ch Unicode character
    # @return CharsetEncoder to convert the given character
    def get_encoder(ch)
      # 1. Try the current encoder.
      if (@encoder.can_encode(ch))
        return @encoder
      end
      # 2. Try the default encoder.
      if (DefaultEncodingSupported && DefaultEncoder.can_encode(ch))
        retval = nil
        begin
          retval = DefaultEncoder.charset.new_encoder
        rescue UnsupportedOperationException => cannot_happen
        end
        init_encoder(retval)
        return retval
      end
      # 3. Try ISO8859-1.
      if (Latin1Encoder.can_encode(ch))
        retval = nil
        begin
          retval = Latin1Encoder.charset.new_encoder
        rescue UnsupportedOperationException => cannot_happen
        end
        init_encoder(retval)
        return retval
      end
      # 4. Brute force search of all supported encodings.
      iter = CompoundTextSupport.get_encodings.iterator
      while iter.has_next
        encoding = iter.next_
        enc = EncodingToEncoderMap.get(encoding)
        if ((enc).nil?)
          enc = CompoundTextSupport.get_encoder(encoding)
          if ((enc).nil?)
            raise InternalError.new("Unsupported encoding: " + encoding)
          end
          EncodingToEncoderMap.put(encoding, enc)
        end
        if (enc.can_encode(ch))
          retval = CompoundTextSupport.get_encoder(encoding)
          init_encoder(retval)
          return retval
        end
      end
      return nil
    end
    
    typesig { [CharsetEncoder] }
    def init_encoder(enc)
      begin
        enc.on_unmappable_character(CodingErrorAction::REPLACE).replace_with(replacement)
      rescue IllegalArgumentException => x
      end
    end
    
    attr_accessor :fcb
    alias_method :attr_fcb, :fcb
    undef_method :fcb
    alias_method :attr_fcb=, :fcb=
    undef_method :fcb=
    
    typesig { [CharsetEncoder, ByteBuffer] }
    def flush_encoder(enc, bb)
      enc.encode(@fcb, bb, true)
      return enc.flush(bb)
    end
    
    private
    alias_method :initialize__compound_text_encoder, :initialize
  end
  
end
