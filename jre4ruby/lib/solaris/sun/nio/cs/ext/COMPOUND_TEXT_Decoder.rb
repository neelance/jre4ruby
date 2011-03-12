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
  module COMPOUND_TEXT_DecoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include ::Java::Nio::Charset
    }
  end
  
  # An algorithmic conversion from COMPOUND_TEXT to Unicode.
  class COMPOUND_TEXT_Decoder < COMPOUND_TEXT_DecoderImports.const_get :CharsetDecoder
    include_class_members COMPOUND_TEXT_DecoderImports
    
    class_module.module_eval {
      const_set_lazy(:NORMAL_BYTES) { 0 }
      const_attr_reader  :NORMAL_BYTES
      
      const_set_lazy(:NONSTANDARD_BYTES) { 1 }
      const_attr_reader  :NONSTANDARD_BYTES
      
      const_set_lazy(:VERSION_SEQUENCE_V) { 2 }
      const_attr_reader  :VERSION_SEQUENCE_V
      
      const_set_lazy(:VERSION_SEQUENCE_TERM) { 3 }
      const_attr_reader  :VERSION_SEQUENCE_TERM
      
      const_set_lazy(:ESCAPE_SEQUENCE) { 4 }
      const_attr_reader  :ESCAPE_SEQUENCE
      
      const_set_lazy(:CHARSET_NGIIF) { 5 }
      const_attr_reader  :CHARSET_NGIIF
      
      const_set_lazy(:CHARSET_NLIIF) { 6 }
      const_attr_reader  :CHARSET_NLIIF
      
      const_set_lazy(:CHARSET_NLIF) { 7 }
      const_attr_reader  :CHARSET_NLIF
      
      const_set_lazy(:CHARSET_NRIIF) { 8 }
      const_attr_reader  :CHARSET_NRIIF
      
      const_set_lazy(:CHARSET_NRIF) { 9 }
      const_attr_reader  :CHARSET_NRIF
      
      const_set_lazy(:CHARSET_NONSTANDARD_FOML) { 10 }
      const_attr_reader  :CHARSET_NONSTANDARD_FOML
      
      const_set_lazy(:CHARSET_NONSTANDARD_OML) { 11 }
      const_attr_reader  :CHARSET_NONSTANDARD_OML
      
      const_set_lazy(:CHARSET_NONSTANDARD_ML) { 12 }
      const_attr_reader  :CHARSET_NONSTANDARD_ML
      
      const_set_lazy(:CHARSET_NONSTANDARD_L) { 13 }
      const_attr_reader  :CHARSET_NONSTANDARD_L
      
      const_set_lazy(:CHARSET_NONSTANDARD) { 14 }
      const_attr_reader  :CHARSET_NONSTANDARD
      
      const_set_lazy(:CHARSET_LIIF) { 15 }
      const_attr_reader  :CHARSET_LIIF
      
      const_set_lazy(:CHARSET_LIF) { 16 }
      const_attr_reader  :CHARSET_LIF
      
      const_set_lazy(:CHARSET_RIIF) { 17 }
      const_attr_reader  :CHARSET_RIIF
      
      const_set_lazy(:CHARSET_RIF) { 18 }
      const_attr_reader  :CHARSET_RIF
      
      const_set_lazy(:CONTROL_SEQUENCE_PIF) { 19 }
      const_attr_reader  :CONTROL_SEQUENCE_PIF
      
      const_set_lazy(:CONTROL_SEQUENCE_IF) { 20 }
      const_attr_reader  :CONTROL_SEQUENCE_IF
      
      const_set_lazy(:EXTENSION_ML) { 21 }
      const_attr_reader  :EXTENSION_ML
      
      const_set_lazy(:EXTENSION_L) { 22 }
      const_attr_reader  :EXTENSION_L
      
      const_set_lazy(:EXTENSION) { 23 }
      const_attr_reader  :EXTENSION
      
      const_set_lazy(:ESCAPE_SEQUENCE_OTHER) { 24 }
      const_attr_reader  :ESCAPE_SEQUENCE_OTHER
      
      const_set_lazy(:ERR_LATIN1) { "ISO8859_1 unsupported" }
      const_attr_reader  :ERR_LATIN1
      
      const_set_lazy(:ERR_ILLSTATE) { "Illegal state" }
      const_attr_reader  :ERR_ILLSTATE
      
      const_set_lazy(:ERR_ESCBYTE) { "Illegal byte in 0x1B escape sequence" }
      const_attr_reader  :ERR_ESCBYTE
      
      const_set_lazy(:ERR_ENCODINGBYTE) { "Illegal byte in non-standard character set name" }
      const_attr_reader  :ERR_ENCODINGBYTE
      
      const_set_lazy(:ERR_CTRLBYTE) { "Illegal byte in 0x9B control sequence" }
      const_attr_reader  :ERR_CTRLBYTE
      
      const_set_lazy(:ERR_CTRLPI) { "P following I in 0x9B control sequence" }
      const_attr_reader  :ERR_CTRLPI
      
      const_set_lazy(:ERR_VERSTART) { "Versioning escape sequence can only appear at start of byte stream" }
      const_attr_reader  :ERR_VERSTART
      
      const_set_lazy(:ERR_VERMANDATORY) { "Cannot parse mandatory extensions" }
      const_attr_reader  :ERR_VERMANDATORY
      
      const_set_lazy(:ERR_ENCODING) { "Unknown encoding: " }
      const_attr_reader  :ERR_ENCODING
      
      const_set_lazy(:ERR_FLUSH) { "Escape sequence, control sequence, or ML extension not terminated" }
      const_attr_reader  :ERR_FLUSH
    }
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    attr_accessor :ext_count
    alias_method :attr_ext_count, :ext_count
    undef_method :ext_count
    alias_method :attr_ext_count=, :ext_count=
    undef_method :ext_count=
    
    attr_accessor :ext_offset
    alias_method :attr_ext_offset, :ext_offset
    undef_method :ext_offset
    alias_method :attr_ext_offset=, :ext_offset=
    undef_method :ext_offset=
    
    attr_accessor :version_sequence_allowed
    alias_method :attr_version_sequence_allowed, :version_sequence_allowed
    undef_method :version_sequence_allowed
    alias_method :attr_version_sequence_allowed=, :version_sequence_allowed=
    undef_method :version_sequence_allowed=
    
    attr_accessor :byte_buf
    alias_method :attr_byte_buf, :byte_buf
    undef_method :byte_buf
    alias_method :attr_byte_buf=, :byte_buf=
    undef_method :byte_buf=
    
    attr_accessor :in_bb
    alias_method :attr_in_bb, :in_bb
    undef_method :in_bb
    alias_method :attr_in_bb=, :in_bb=
    undef_method :in_bb=
    
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    attr_accessor :encoding_queue
    alias_method :attr_encoding_queue, :encoding_queue
    undef_method :encoding_queue
    alias_method :attr_encoding_queue=, :encoding_queue=
    undef_method :encoding_queue=
    
    attr_accessor :gl_decoder
    alias_method :attr_gl_decoder, :gl_decoder
    undef_method :gl_decoder
    alias_method :attr_gl_decoder=, :gl_decoder=
    undef_method :gl_decoder=
    
    attr_accessor :gr_decoder
    alias_method :attr_gr_decoder, :gr_decoder
    undef_method :gr_decoder
    alias_method :attr_gr_decoder=, :gr_decoder=
    undef_method :gr_decoder=
    
    attr_accessor :non_standard_decoder
    alias_method :attr_non_standard_decoder, :non_standard_decoder
    undef_method :non_standard_decoder
    alias_method :attr_non_standard_decoder=, :non_standard_decoder=
    undef_method :non_standard_decoder=
    
    attr_accessor :last_decoder
    alias_method :attr_last_decoder, :last_decoder
    undef_method :last_decoder
    alias_method :attr_last_decoder=, :last_decoder=
    undef_method :last_decoder=
    
    attr_accessor :gl_high
    alias_method :attr_gl_high, :gl_high
    undef_method :gl_high
    alias_method :attr_gl_high=, :gl_high=
    undef_method :gl_high=
    
    attr_accessor :gr_high
    alias_method :attr_gr_high, :gr_high
    undef_method :gr_high
    alias_method :attr_gr_high=, :gr_high=
    undef_method :gr_high=
    
    typesig { [Charset] }
    def initialize(cs)
      @state = 0
      @ext_count = 0
      @ext_offset = 0
      @version_sequence_allowed = false
      @byte_buf = nil
      @in_bb = nil
      @queue = nil
      @encoding_queue = nil
      @gl_decoder = nil
      @gr_decoder = nil
      @non_standard_decoder = nil
      @last_decoder = nil
      @gl_high = false
      @gr_high = false
      @fbb = nil
      super(cs, 1.0, 1.0)
      @state = NORMAL_BYTES
      @version_sequence_allowed = true
      @byte_buf = Array.typed(::Java::Byte).new(1) { 0 }
      @in_bb = ByteBuffer.allocate_(16)
      @queue = ByteArrayOutputStream.new
      @encoding_queue = ByteArrayOutputStream.new
      @gl_high = false
      @gr_high = true
      @fbb = ByteBuffer.allocate_(0)
      begin
        # Initial state in ISO 2022 designates Latin-1 charset.
        @gl_decoder = Charset.for_name("ASCII").new_decoder
        @gr_decoder = Charset.for_name("ISO8859_1").new_decoder
      rescue IllegalArgumentException => e
        error(ERR_LATIN1)
      end
      init_decoder(@gl_decoder)
      init_decoder(@gr_decoder)
    end
    
    typesig { [ByteBuffer, CharBuffer] }
    def decode_loop(src, des)
      cr = CoderResult::UNDERFLOW
      input = src.array
      in_off = src.array_offset + src.position
      in_end = src.array_offset + src.limit
      begin
        while (in_off < in_end && cr.is_underflow)
          # Byte parsing is done with shorts instead of bytes because
          # Java bytes are signed, while COMPOUND_TEXT bytes are not. If
          # we used the Java byte type, the > and < tests during parsing
          # would not work correctly.
          cr = handle_byte(RJava.cast_to_short((input[in_off] & 0xff)), des)
          in_off += 1
        end
        return cr
      ensure
        src.position(in_off - src.array_offset)
      end
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def handle_byte(new_byte, cb)
      cr = CoderResult::UNDERFLOW
      case (@state)
      when NORMAL_BYTES
        cr = normal_bytes(new_byte, cb)
      when NONSTANDARD_BYTES
        cr = non_standard_bytes(new_byte, cb)
      when VERSION_SEQUENCE_V, VERSION_SEQUENCE_TERM
        cr = version_sequence(new_byte)
      when ESCAPE_SEQUENCE
        cr = escape_sequence(new_byte)
      when CHARSET_NGIIF
        cr = charset94_n(new_byte)
      when CHARSET_NLIIF, CHARSET_NLIF
        cr = charset94_nl(new_byte, cb)
      when CHARSET_NRIIF, CHARSET_NRIF
        cr = charset94_nr(new_byte, cb)
      when CHARSET_NONSTANDARD_FOML, CHARSET_NONSTANDARD_OML, CHARSET_NONSTANDARD_ML, CHARSET_NONSTANDARD_L, CHARSET_NONSTANDARD
        cr = charset_non_standard(new_byte, cb)
      when CHARSET_LIIF, CHARSET_LIF
        cr = charset9496_l(new_byte, cb)
      when CHARSET_RIIF, CHARSET_RIF
        cr = charset9496_r(new_byte, cb)
      when CONTROL_SEQUENCE_PIF, CONTROL_SEQUENCE_IF
        cr = control_sequence(new_byte)
      when EXTENSION_ML, EXTENSION_L, EXTENSION
        cr = extension(new_byte)
      when ESCAPE_SEQUENCE_OTHER
        cr = escape_sequence_other(new_byte)
      else
        error(ERR_ILLSTATE)
      end
      return cr
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def normal_bytes(new_byte, cb)
      cr = CoderResult::UNDERFLOW # C0
      if ((new_byte >= 0x0 && new_byte <= 0x1f) || (new_byte >= 0x80 && new_byte <= 0x9f))
        # C1
        new_char = 0
        case (new_byte)
        when 0x1b
          @state = ESCAPE_SEQUENCE
          @queue.write(new_byte)
          return cr
        when 0x9b
          @state = CONTROL_SEQUENCE_PIF
          @version_sequence_allowed = false
          @queue.write(new_byte)
          return cr
        when 0x9
          @version_sequence_allowed = false
          new_char = Character.new(?\t.ord)
        when 0xa
          @version_sequence_allowed = false
          new_char = Character.new(?\n.ord)
        else
          @version_sequence_allowed = false
          return cr
        end
        if (!cb.has_remaining)
          return CoderResult::OVERFLOW
        else
          cb.put(new_char)
        end
      else
        decoder = nil
        high = false
        @version_sequence_allowed = false
        if (new_byte >= 0x20 && new_byte <= 0x7f)
          decoder = @gl_decoder
          high = @gl_high
        else
          # if (newByte >= 0xA0 && newByte <= 0xFF)
          decoder = @gr_decoder
          high = @gr_high
        end
        if (!(@last_decoder).nil? && !(decoder).equal?(@last_decoder))
          cr = flush_decoder(@last_decoder, cb)
        end
        @last_decoder = decoder
        if (!(decoder).nil?)
          b = new_byte
          if (high)
            b |= 0x80
          else
            b &= 0x7f
          end
          @in_bb.put(b)
          @in_bb.flip
          cr = decoder.decode(@in_bb, cb, false)
          if (!@in_bb.has_remaining || cr.is_malformed)
            @in_bb.clear
          else
            pos = @in_bb.limit
            @in_bb.clear
            @in_bb.position(pos)
          end
        else
          if (cb.remaining < replacement.length)
            cb.put(replacement)
          else
            return CoderResult::OVERFLOW
          end
        end
      end
      return cr
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def non_standard_bytes(new_byte, cb)
      cr = CoderResult::UNDERFLOW
      if (!(@non_standard_decoder).nil?)
        # byteBuf[0] = (byte)newByte;
        @in_bb.put(new_byte)
        @in_bb.flip
        cr = @non_standard_decoder.decode(@in_bb, cb, false)
        if (!@in_bb.has_remaining)
          @in_bb.clear
        else
          pos = @in_bb.limit
          @in_bb.clear
          @in_bb.position(pos)
        end
      else
        if (cb.remaining < replacement.length)
          cb.put(replacement)
        else
          return CoderResult::OVERFLOW
        end
      end
      @ext_offset += 1
      if (@ext_offset >= @ext_count)
        @ext_offset = @ext_count = 0
        @state = NORMAL_BYTES
        cr = flush_decoder(@non_standard_decoder, cb)
        @non_standard_decoder = nil
      end
      return cr
    end
    
    typesig { [::Java::Short] }
    def escape_sequence(new_byte)
      case (new_byte)
      when 0x23
        @state = VERSION_SEQUENCE_V
      when 0x24
        @state = CHARSET_NGIIF
        @version_sequence_allowed = false
      when 0x25
        @state = CHARSET_NONSTANDARD_FOML
        @version_sequence_allowed = false
      when 0x28
        @state = CHARSET_LIIF
        @version_sequence_allowed = false
      when 0x29, 0x2d
        @state = CHARSET_RIIF
        @version_sequence_allowed = false
      else
        # escapeSequenceOther will write to queue if appropriate
        return escape_sequence_other(new_byte)
      end
      @queue.write(new_byte)
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short] }
    # Test for unknown, but valid, escape sequences.
    def escape_sequence_other(new_byte)
      if (new_byte >= 0x20 && new_byte <= 0x2f)
        # {I}
        @state = ESCAPE_SEQUENCE_OTHER
        @version_sequence_allowed = false
        @queue.write(new_byte)
      else
        if (new_byte >= 0x30 && new_byte <= 0x7e)
          # F -- end of sequence
          @state = NORMAL_BYTES
          @version_sequence_allowed = false
          @queue.reset
        else
          return malformed_input(ERR_ESCBYTE)
        end
      end
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short] }
    # Parses directionality, as well as unknown, but valid, control sequences.
    def control_sequence(new_byte)
      if (new_byte >= 0x30 && new_byte <= 0x3f)
        # {P}
        if ((@state).equal?(CONTROL_SEQUENCE_IF))
          # P no longer allowed
          return malformed_input(ERR_CTRLPI)
        end
        @queue.write(new_byte)
      else
        if (new_byte >= 0x20 && new_byte <= 0x2f)
          # {I}
          @state = CONTROL_SEQUENCE_IF
          @queue.write(new_byte)
        else
          if (new_byte >= 0x40 && new_byte <= 0x7e)
            # F -- end of sequence
            @state = NORMAL_BYTES
            @queue.reset
          else
            return malformed_input(ERR_CTRLBYTE)
          end
        end
      end
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short] }
    def version_sequence(new_byte)
      if ((@state).equal?(VERSION_SEQUENCE_V))
        if (new_byte >= 0x20 && new_byte <= 0x2f)
          @state = VERSION_SEQUENCE_TERM
          @queue.write(new_byte)
        else
          return escape_sequence_other(new_byte)
        end
      else
        # if (state == VERSION_SEQUENCE_TERM)
        case (new_byte)
        when 0x30
          if (!@version_sequence_allowed)
            return malformed_input(ERR_VERSTART)
          end
          # OK to ignore extensions
          @version_sequence_allowed = false
          @state = NORMAL_BYTES
          @queue.reset
        when 0x31
          return malformed_input((@version_sequence_allowed) ? ERR_VERMANDATORY : ERR_VERSTART)
        else
          return escape_sequence_other(new_byte)
        end
      end
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short] }
    def charset94_n(new_byte)
      case (new_byte)
      when 0x28
        @state = CHARSET_NLIIF
      when 0x29
        @state = CHARSET_NRIIF
      else
        # escapeSequenceOther will write byte if appropriate
        return escape_sequence_other(new_byte)
      end
      @queue.write(new_byte)
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def charset94_nl(new_byte, cb)
      if (new_byte >= 0x21 && new_byte <= ((@state).equal?(CHARSET_NLIIF) ? 0x23 : 0x2f))
        # {I}
        @state = CHARSET_NLIF
        @queue.write(new_byte)
      else
        if (new_byte >= 0x40 && new_byte <= 0x7e)
          # F
          return switch_decoder(new_byte, cb)
        else
          return escape_sequence_other(new_byte)
        end
      end
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def charset94_nr(new_byte, cb)
      if (new_byte >= 0x21 && new_byte <= ((@state).equal?(CHARSET_NRIIF) ? 0x23 : 0x2f))
        # {I}
        @state = CHARSET_NRIF
        @queue.write(new_byte)
      else
        if (new_byte >= 0x40 && new_byte <= 0x7e)
          # F
          return switch_decoder(new_byte, cb)
        else
          return escape_sequence_other(new_byte)
        end
      end
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def charset9496_l(new_byte, cb)
      if (new_byte >= 0x21 && new_byte <= ((@state).equal?(CHARSET_LIIF) ? 0x23 : 0x2f))
        # {I}
        @state = CHARSET_LIF
        @queue.write(new_byte)
        return CoderResult::UNDERFLOW
      else
        if (new_byte >= 0x40 && new_byte <= 0x7e)
          # F
          return switch_decoder(new_byte, cb)
        else
          return escape_sequence_other(new_byte)
        end
      end
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def charset9496_r(new_byte, cb)
      if (new_byte >= 0x21 && new_byte <= ((@state).equal?(CHARSET_RIIF) ? 0x23 : 0x2f))
        # {I}
        @state = CHARSET_RIF
        @queue.write(new_byte)
        return CoderResult::UNDERFLOW
      else
        if (new_byte >= 0x40 && new_byte <= 0x7e)
          # F
          return switch_decoder(new_byte, cb)
        else
          return escape_sequence_other(new_byte)
        end
      end
    end
    
    typesig { [::Java::Short, CharBuffer] }
    def charset_non_standard(new_byte, cb)
      case (@state)
      when CHARSET_NONSTANDARD_FOML
        if ((new_byte).equal?(0x2f))
          @state = CHARSET_NONSTANDARD_OML
          @queue.write(new_byte)
        else
          return escape_sequence_other(new_byte)
        end
      when CHARSET_NONSTANDARD_OML
        if (new_byte >= 0x30 && new_byte <= 0x34)
          @state = CHARSET_NONSTANDARD_ML
          @queue.write(new_byte)
        else
          if (new_byte >= 0x35 && new_byte <= 0x3f)
            @state = EXTENSION_ML
            @queue.write(new_byte)
          else
            return escape_sequence_other(new_byte)
          end
        end
      when CHARSET_NONSTANDARD_ML
        @ext_count = (new_byte & 0x7f) * 0x80
        @state = CHARSET_NONSTANDARD_L
      when CHARSET_NONSTANDARD_L
        @ext_count = @ext_count + (new_byte & 0x7f)
        @state = (@ext_count > 0) ? CHARSET_NONSTANDARD : NORMAL_BYTES
      when CHARSET_NONSTANDARD
        if ((new_byte).equal?(0x3f) || (new_byte).equal?(0x2a))
          @queue.reset # In this case, only current byte is bad.
          return malformed_input(ERR_ENCODINGBYTE)
        end
        @ext_offset += 1
        if (@ext_offset >= @ext_count)
          @ext_offset = @ext_count = 0
          @state = NORMAL_BYTES
          @queue.reset
          @encoding_queue.reset
        else
          if ((new_byte).equal?(0x2))
            # encoding name terminator
            return switch_decoder(RJava.cast_to_short(0), cb)
          else
            @encoding_queue.write(new_byte)
          end
        end
      else
        error(ERR_ILLSTATE)
      end
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short] }
    def extension(new_byte)
      case (@state)
      when EXTENSION_ML
        @ext_count = (new_byte & 0x7f) * 0x80
        @state = EXTENSION_L
      when EXTENSION_L
        @ext_count = @ext_count + (new_byte & 0x7f)
        @state = (@ext_count > 0) ? EXTENSION : NORMAL_BYTES
      when EXTENSION
        # Consume 'count' bytes. Don't bother putting them on the queue.
        # There may be too many and we can't do anything with them anyway.
        @ext_offset += 1
        if (@ext_offset >= @ext_count)
          @ext_offset = @ext_count = 0
          @state = NORMAL_BYTES
          @queue.reset
        end
      else
        error(ERR_ILLSTATE)
      end
      return CoderResult::UNDERFLOW
    end
    
    typesig { [::Java::Short, CharBuffer] }
    # Preconditions:
    #   1. 'queue' contains ControlSequence.escSequence
    #   2. 'encodingQueue' contains ControlSequence.encoding
    def switch_decoder(last_byte, cb)
      cr = CoderResult::UNDERFLOW
      decoder = nil
      high = false
      esc_sequence = nil
      encoding = nil
      if (!(last_byte).equal?(0))
        @queue.write(last_byte)
      end
      esc_sequence = @queue.to_byte_array
      @queue.reset
      if ((@state).equal?(CHARSET_NONSTANDARD))
        encoding = @encoding_queue.to_byte_array
        @encoding_queue.reset
        decoder = CompoundTextSupport.get_non_standard_decoder(esc_sequence, encoding)
      else
        decoder = CompoundTextSupport.get_standard_decoder(esc_sequence)
        high = CompoundTextSupport.get_high_bit(esc_sequence)
      end
      if (!(decoder).nil?)
        init_decoder(decoder)
      else
        if ((unmappable_character_action).equal?(CodingErrorAction::REPORT))
          bad_input_length = 1
          if (!(encoding).nil?)
            bad_input_length = encoding.attr_length
          else
            if (esc_sequence.attr_length > 0)
              bad_input_length = esc_sequence.attr_length
            end
          end
          return CoderResult.unmappable_for_length(bad_input_length)
        end
      end
      if ((@state).equal?(CHARSET_NLIIF) || (@state).equal?(CHARSET_NLIF) || (@state).equal?(CHARSET_LIIF) || (@state).equal?(CHARSET_LIF))
        if ((@last_decoder).equal?(@gl_decoder))
          cr = flush_decoder(@gl_decoder, cb)
        end
        @gl_decoder = @last_decoder = decoder
        @gl_high = high
        @state = NORMAL_BYTES
      else
        if ((@state).equal?(CHARSET_NRIIF) || (@state).equal?(CHARSET_NRIF) || (@state).equal?(CHARSET_RIIF) || (@state).equal?(CHARSET_RIF))
          if ((@last_decoder).equal?(@gr_decoder))
            cr = flush_decoder(@gr_decoder, cb)
          end
          @gr_decoder = @last_decoder = decoder
          @gr_high = high
          @state = NORMAL_BYTES
        else
          if ((@state).equal?(CHARSET_NONSTANDARD))
            if (!(@last_decoder).nil?)
              cr = flush_decoder(@last_decoder, cb)
              @last_decoder = nil
            end
            @non_standard_decoder = decoder
            @state = NONSTANDARD_BYTES
          else
            error(ERR_ILLSTATE)
          end
        end
      end
      return cr
    end
    
    attr_accessor :fbb
    alias_method :attr_fbb, :fbb
    undef_method :fbb
    alias_method :attr_fbb=, :fbb=
    undef_method :fbb=
    
    typesig { [CharsetDecoder, CharBuffer] }
    def flush_decoder(dec, cb)
      dec.decode(@fbb, cb, true)
      cr = dec.flush(cb)
      dec.reset # reuse
      return cr
    end
    
    typesig { [String] }
    def malformed_input(msg)
      bad_input_length = @queue.size + 1 # current byte
      @queue.reset
      # TBD: nowhere to put the msg in CoderResult
      return CoderResult.malformed_for_length(bad_input_length)
    end
    
    typesig { [String] }
    def error(msg)
      # For now, throw InternalError. Convert to 'assert' keyword later.
      raise InternalError.new(msg)
    end
    
    typesig { [CharBuffer] }
    def impl_flush(out)
      cr = CoderResult::UNDERFLOW
      if (!(@last_decoder).nil?)
        cr = flush_decoder(@last_decoder, out)
      end
      if (!(@state).equal?(NORMAL_BYTES))
        # TBD message ERR_FLUSH;
        cr = CoderResult.malformed_for_length(0)
      end
      reset
      return cr
    end
    
    typesig { [] }
    # Resets the decoder.
    # Call this method to reset the decoder to its initial state
    def impl_reset
      @state = NORMAL_BYTES
      @ext_count = @ext_offset = 0
      @version_sequence_allowed = true
      @queue.reset
      @encoding_queue.reset
      @non_standard_decoder = @last_decoder = nil
      @gl_high = false
      @gr_high = true
      begin
        # Initial state in ISO 2022 designates Latin-1 charset.
        @gl_decoder = Charset.for_name("ASCII").new_decoder
        @gr_decoder = Charset.for_name("ISO8859_1").new_decoder
      rescue IllegalArgumentException => e
        error(ERR_LATIN1)
      end
      init_decoder(@gl_decoder)
      init_decoder(@gr_decoder)
    end
    
    typesig { [CodingErrorAction] }
    def impl_on_malformed_input(new_action)
      if (!(@gl_decoder).nil?)
        @gl_decoder.on_malformed_input(new_action)
      end
      if (!(@gr_decoder).nil?)
        @gr_decoder.on_malformed_input(new_action)
      end
      if (!(@non_standard_decoder).nil?)
        @non_standard_decoder.on_malformed_input(new_action)
      end
    end
    
    typesig { [CodingErrorAction] }
    def impl_on_unmappable_character(new_action)
      if (!(@gl_decoder).nil?)
        @gl_decoder.on_unmappable_character(new_action)
      end
      if (!(@gr_decoder).nil?)
        @gr_decoder.on_unmappable_character(new_action)
      end
      if (!(@non_standard_decoder).nil?)
        @non_standard_decoder.on_unmappable_character(new_action)
      end
    end
    
    typesig { [String] }
    def impl_replace_with(new_replacement)
      if (!(@gl_decoder).nil?)
        @gl_decoder.replace_with(new_replacement)
      end
      if (!(@gr_decoder).nil?)
        @gr_decoder.replace_with(new_replacement)
      end
      if (!(@non_standard_decoder).nil?)
        @non_standard_decoder.replace_with(new_replacement)
      end
    end
    
    typesig { [CharsetDecoder] }
    def init_decoder(dec)
      dec.on_unmappable_character(CodingErrorAction::REPLACE).replace_with(replacement)
    end
    
    private
    alias_method :initialize__compound_text_decoder, :initialize
  end
  
end
