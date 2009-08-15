require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio::Charset
  module CharsetEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Charset
      include_const ::Java::Nio, :Buffer
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio, :BufferOverflowException
      include_const ::Java::Nio, :BufferUnderflowException
      include_const ::Java::Lang::Ref, :WeakReference
      include_const ::Java::Nio::Charset, :CoderMalfunctionError
    }
  end
  
  # javadoc
  # 
  # An engine that can transform a sequence of sixteen-bit Unicode characters into a sequence of
  # bytes in a specific charset.
  # 
  # <a name="steps">
  # 
  # <p> The input character sequence is provided in a character buffer or a series
  # of such buffers.  The output byte sequence is written to a byte buffer
  # or a series of such buffers.  An encoder should always be used by making
  # the following sequence of method invocations, hereinafter referred to as an
  # <i>encoding operation</i>:
  # 
  # <ol>
  # 
  # <li><p> Reset the encoder via the {@link #reset reset} method, unless it
  # has not been used before; </p></li>
  # 
  # <li><p> Invoke the {@link #encode encode} method zero or more times, as
  # long as additional input may be available, passing <tt>false</tt> for the
  # <tt>endOfInput</tt> argument and filling the input buffer and flushing the
  # output buffer between invocations; </p></li>
  # 
  # <li><p> Invoke the {@link #encode encode} method one final time, passing
  # <tt>true</tt> for the <tt>endOfInput</tt> argument; and then </p></li>
  # 
  # <li><p> Invoke the {@link #flush flush} method so that the encoder can
  # flush any internal state to the output buffer. </p></li>
  # 
  # </ol>
  # 
  # Each invocation of the {@link #encode encode} method will encode as many
  # characters as possible from the input buffer, writing the resulting bytes
  # to the output buffer.  The {@link #encode encode} method returns when more
  # input is required, when there is not enough room in the output buffer, or
  # when an encoding error has occurred.  In each case a {@link CoderResult}
  # object is returned to describe the reason for termination.  An invoker can
  # examine this object and fill the input buffer, flush the output buffer, or
  # attempt to recover from an encoding error, as appropriate, and try again.
  # 
  # <a name="ce">
  # 
  # <p> There are two general types of encoding errors.  If the input character
  # sequence is not a legal sixteen-bit Unicode sequence then the input is considered <i>malformed</i>.  If
  # the input character sequence is legal but cannot be mapped to a valid
  # byte sequence in the given charset then an <i>unmappable character</i> has been encountered.
  # 
  # <a name="cae">
  # 
  # <p> How an encoding error is handled depends upon the action requested for
  # that type of error, which is described by an instance of the {@link
  # CodingErrorAction} class.  The possible error actions are to {@link
  # CodingErrorAction#IGNORE </code>ignore<code>} the erroneous input, {@link
  # CodingErrorAction#REPORT </code>report<code>} the error to the invoker via
  # the returned {@link CoderResult} object, or {@link CodingErrorAction#REPLACE
  # </code>replace<code>} the erroneous input with the current value of the
  # replacement byte array.  The replacement
  # 
  # 
  # is initially set to the encoder's default replacement, which often
  # (but not always) has the initial value&nbsp;<tt>{</tt>&nbsp;<tt>(byte)'?'</tt>&nbsp;<tt>}</tt>;
  # 
  # 
  # 
  # 
  # 
  # its value may be changed via the {@link #replaceWith(byte[])
  # replaceWith} method.
  # 
  # <p> The default action for malformed-input and unmappable-character errors
  # is to {@link CodingErrorAction#REPORT </code>report<code>} them.  The
  # malformed-input error action may be changed via the {@link
  # #onMalformedInput(CodingErrorAction) onMalformedInput} method; the
  # unmappable-character action may be changed via the {@link
  # #onUnmappableCharacter(CodingErrorAction) onUnmappableCharacter} method.
  # 
  # <p> This class is designed to handle many of the details of the encoding
  # process, including the implementation of error actions.  An encoder for a
  # specific charset, which is a concrete subclass of this class, need only
  # implement the abstract {@link #encodeLoop encodeLoop} method, which
  # encapsulates the basic encoding loop.  A subclass that maintains internal
  # state should, additionally, override the {@link #implFlush implFlush} and
  # {@link #implReset implReset} methods.
  # 
  # <p> Instances of this class are not safe for use by multiple concurrent
  # threads.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  # 
  # @see ByteBuffer
  # @see CharBuffer
  # @see Charset
  # @see CharsetDecoder
  class CharsetEncoder 
    include_class_members CharsetEncoderImports
    
    attr_accessor :charset
    alias_method :attr_charset, :charset
    undef_method :charset
    alias_method :attr_charset=, :charset=
    undef_method :charset=
    
    attr_accessor :average_bytes_per_char
    alias_method :attr_average_bytes_per_char, :average_bytes_per_char
    undef_method :average_bytes_per_char
    alias_method :attr_average_bytes_per_char=, :average_bytes_per_char=
    undef_method :average_bytes_per_char=
    
    attr_accessor :max_bytes_per_char
    alias_method :attr_max_bytes_per_char, :max_bytes_per_char
    undef_method :max_bytes_per_char
    alias_method :attr_max_bytes_per_char=, :max_bytes_per_char=
    undef_method :max_bytes_per_char=
    
    attr_accessor :replacement
    alias_method :attr_replacement, :replacement
    undef_method :replacement
    alias_method :attr_replacement=, :replacement=
    undef_method :replacement=
    
    attr_accessor :malformed_input_action
    alias_method :attr_malformed_input_action, :malformed_input_action
    undef_method :malformed_input_action
    alias_method :attr_malformed_input_action=, :malformed_input_action=
    undef_method :malformed_input_action=
    
    attr_accessor :unmappable_character_action
    alias_method :attr_unmappable_character_action, :unmappable_character_action
    undef_method :unmappable_character_action
    alias_method :attr_unmappable_character_action=, :unmappable_character_action=
    undef_method :unmappable_character_action=
    
    class_module.module_eval {
      # Internal states
      const_set_lazy(:ST_RESET) { 0 }
      const_attr_reader  :ST_RESET
      
      const_set_lazy(:ST_CODING) { 1 }
      const_attr_reader  :ST_CODING
      
      const_set_lazy(:ST_END) { 2 }
      const_attr_reader  :ST_END
      
      const_set_lazy(:ST_FLUSHED) { 3 }
      const_attr_reader  :ST_FLUSHED
    }
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    class_module.module_eval {
      
      def state_names
        defined?(@@state_names) ? @@state_names : @@state_names= Array.typed(String).new(["RESET", "CODING", "CODING_END", "FLUSHED"])
      end
      alias_method :attr_state_names, :state_names
      
      def state_names=(value)
        @@state_names = value
      end
      alias_method :attr_state_names=, :state_names=
    }
    
    typesig { [Charset, ::Java::Float, ::Java::Float, Array.typed(::Java::Byte)] }
    # Initializes a new encoder.  The new encoder will have the given
    # bytes-per-char and replacement values. </p>
    # 
    # @param  averageBytesPerChar
    # A positive float value indicating the expected number of
    # bytes that will be produced for each input character
    # 
    # @param  maxBytesPerChar
    # A positive float value indicating the maximum number of
    # bytes that will be produced for each input character
    # 
    # @param  replacement
    # The initial replacement; must not be <tt>null</tt>, must have
    # non-zero length, must not be longer than maxBytesPerChar,
    # and must be {@link #isLegalReplacement </code>legal<code>}
    # 
    # @throws  IllegalArgumentException
    # If the preconditions on the parameters do not hold
    def initialize(cs, average_bytes_per_char, max_bytes_per_char, replacement)
      @charset = nil
      @average_bytes_per_char = 0.0
      @max_bytes_per_char = 0.0
      @replacement = nil
      @malformed_input_action = CodingErrorAction::REPORT
      @unmappable_character_action = CodingErrorAction::REPORT
      @state = ST_RESET
      @cached_decoder = nil
      @charset = cs
      if (average_bytes_per_char <= 0.0)
        raise IllegalArgumentException.new("Non-positive " + "averageBytesPerChar")
      end
      if (max_bytes_per_char <= 0.0)
        raise IllegalArgumentException.new("Non-positive " + "maxBytesPerChar")
      end
      if (!Charset.at_bug_level("1.4"))
        if (average_bytes_per_char > max_bytes_per_char)
          raise IllegalArgumentException.new("averageBytesPerChar" + " exceeds " + "maxBytesPerChar")
        end
      end
      @replacement = replacement
      @average_bytes_per_char = average_bytes_per_char
      @max_bytes_per_char = max_bytes_per_char
      replace_with(replacement)
    end
    
    typesig { [Charset, ::Java::Float, ::Java::Float] }
    # Initializes a new encoder.  The new encoder will have the given
    # bytes-per-char values and its replacement will be the
    # byte array <tt>{</tt>&nbsp;<tt>(byte)'?'</tt>&nbsp;<tt>}</tt>. </p>
    # 
    # @param  averageBytesPerChar
    # A positive float value indicating the expected number of
    # bytes that will be produced for each input character
    # 
    # @param  maxBytesPerChar
    # A positive float value indicating the maximum number of
    # bytes that will be produced for each input character
    # 
    # @throws  IllegalArgumentException
    # If the preconditions on the parameters do not hold
    def initialize(cs, average_bytes_per_char, max_bytes_per_char)
      initialize__charset_encoder(cs, average_bytes_per_char, max_bytes_per_char, Array.typed(::Java::Byte).new([Character.new(??.ord)]))
    end
    
    typesig { [] }
    # Returns the charset that created this encoder.  </p>
    # 
    # @return  This encoder's charset
    def charset
      return @charset
    end
    
    typesig { [] }
    # Returns this encoder's replacement value. </p>
    # 
    # @return  This encoder's current replacement,
    # which is never <tt>null</tt> and is never empty
    def replacement
      return @replacement
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Changes this encoder's replacement value.
    # 
    # <p> This method invokes the {@link #implReplaceWith implReplaceWith}
    # method, passing the new replacement, after checking that the new
    # replacement is acceptable.  </p>
    # 
    # @param  newReplacement
    # 
    # 
    # 
    # 
    # 
    # 
    # The new replacement; must not be <tt>null</tt>, must have
    # non-zero length, must not be longer than the value returned by
    # the {@link #maxBytesPerChar() maxBytesPerChar} method, and
    # must be {@link #isLegalReplacement </code>legal<code>}
    # 
    # 
    # @return  This encoder
    # 
    # @throws  IllegalArgumentException
    # If the preconditions on the parameter do not hold
    def replace_with(new_replacement)
      if ((new_replacement).nil?)
        raise IllegalArgumentException.new("Null replacement")
      end
      len = new_replacement.attr_length
      if ((len).equal?(0))
        raise IllegalArgumentException.new("Empty replacement")
      end
      if (len > @max_bytes_per_char)
        raise IllegalArgumentException.new("Replacement too long")
      end
      if (!is_legal_replacement(new_replacement))
        raise IllegalArgumentException.new("Illegal replacement")
      end
      @replacement = new_replacement
      impl_replace_with(new_replacement)
      return self
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reports a change to this encoder's replacement value.
    # 
    # <p> The default implementation of this method does nothing.  This method
    # should be overridden by encoders that require notification of changes to
    # the replacement.  </p>
    # 
    # @param  newReplacement
    def impl_replace_with(new_replacement)
    end
    
    attr_accessor :cached_decoder
    alias_method :attr_cached_decoder, :cached_decoder
    undef_method :cached_decoder
    alias_method :attr_cached_decoder=, :cached_decoder=
    undef_method :cached_decoder=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Tells whether or not the given byte array is a legal replacement value
    # for this encoder.
    # 
    # <p> A replacement is legal if, and only if, it is a legal sequence of
    # bytes in this encoder's charset; that is, it must be possible to decode
    # the replacement into one or more sixteen-bit Unicode characters.
    # 
    # <p> The default implementation of this method is not very efficient; it
    # should generally be overridden to improve performance.  </p>
    # 
    # @param  repl  The byte array to be tested
    # 
    # @return  <tt>true</tt> if, and only if, the given byte array
    # is a legal replacement value for this encoder
    def is_legal_replacement(repl)
      wr = @cached_decoder
      dec = nil
      if (((wr).nil?) || (((dec = wr.get)).nil?))
        dec = charset.new_decoder
        dec.on_malformed_input(CodingErrorAction::REPORT)
        dec.on_unmappable_character(CodingErrorAction::REPORT)
        @cached_decoder = WeakReference.new(dec)
      else
        dec.reset
      end
      bb = ByteBuffer.wrap(repl)
      cb = CharBuffer.allocate(RJava.cast_to_int((bb.remaining * dec.max_chars_per_byte)))
      cr = dec.decode(bb, cb, true)
      return !cr.is_error
    end
    
    typesig { [] }
    # Returns this encoder's current action for malformed-input errors.  </p>
    # 
    # @return The current malformed-input action, which is never <tt>null</tt>
    def malformed_input_action
      return @malformed_input_action
    end
    
    typesig { [CodingErrorAction] }
    # Changes this encoder's action for malformed-input errors.  </p>
    # 
    # <p> This method invokes the {@link #implOnMalformedInput
    # implOnMalformedInput} method, passing the new action.  </p>
    # 
    # @param  newAction  The new action; must not be <tt>null</tt>
    # 
    # @return  This encoder
    # 
    # @throws IllegalArgumentException
    # If the precondition on the parameter does not hold
    def on_malformed_input(new_action)
      if ((new_action).nil?)
        raise IllegalArgumentException.new("Null action")
      end
      @malformed_input_action = new_action
      impl_on_malformed_input(new_action)
      return self
    end
    
    typesig { [CodingErrorAction] }
    # Reports a change to this encoder's malformed-input action.
    # 
    # <p> The default implementation of this method does nothing.  This method
    # should be overridden by encoders that require notification of changes to
    # the malformed-input action.  </p>
    def impl_on_malformed_input(new_action)
    end
    
    typesig { [] }
    # Returns this encoder's current action for unmappable-character errors.
    # </p>
    # 
    # @return The current unmappable-character action, which is never
    # <tt>null</tt>
    def unmappable_character_action
      return @unmappable_character_action
    end
    
    typesig { [CodingErrorAction] }
    # Changes this encoder's action for unmappable-character errors.
    # 
    # <p> This method invokes the {@link #implOnUnmappableCharacter
    # implOnUnmappableCharacter} method, passing the new action.  </p>
    # 
    # @param  newAction  The new action; must not be <tt>null</tt>
    # 
    # @return  This encoder
    # 
    # @throws IllegalArgumentException
    # If the precondition on the parameter does not hold
    def on_unmappable_character(new_action)
      if ((new_action).nil?)
        raise IllegalArgumentException.new("Null action")
      end
      @unmappable_character_action = new_action
      impl_on_unmappable_character(new_action)
      return self
    end
    
    typesig { [CodingErrorAction] }
    # Reports a change to this encoder's unmappable-character action.
    # 
    # <p> The default implementation of this method does nothing.  This method
    # should be overridden by encoders that require notification of changes to
    # the unmappable-character action.  </p>
    def impl_on_unmappable_character(new_action)
    end
    
    typesig { [] }
    # Returns the average number of bytes that will be produced for each
    # character of input.  This heuristic value may be used to estimate the size
    # of the output buffer required for a given input sequence. </p>
    # 
    # @return  The average number of bytes produced
    # per character of input
    def average_bytes_per_char
      return @average_bytes_per_char
    end
    
    typesig { [] }
    # Returns the maximum number of bytes that will be produced for each
    # character of input.  This value may be used to compute the worst-case size
    # of the output buffer required for a given input sequence. </p>
    # 
    # @return  The maximum number of bytes that will be produced per
    # character of input
    def max_bytes_per_char
      return @max_bytes_per_char
    end
    
    typesig { [CharBuffer, ByteBuffer, ::Java::Boolean] }
    # Encodes as many characters as possible from the given input buffer,
    # writing the results to the given output buffer.
    # 
    # <p> The buffers are read from, and written to, starting at their current
    # positions.  At most {@link Buffer#remaining in.remaining()} characters
    # will be read and at most {@link Buffer#remaining out.remaining()}
    # bytes will be written.  The buffers' positions will be advanced to
    # reflect the characters read and the bytes written, but their marks and
    # limits will not be modified.
    # 
    # <p> In addition to reading characters from the input buffer and writing
    # bytes to the output buffer, this method returns a {@link CoderResult}
    # object to describe its reason for termination:
    # 
    # <ul>
    # 
    # <li><p> {@link CoderResult#UNDERFLOW} indicates that as much of the
    # input buffer as possible has been encoded.  If there is no further
    # input then the invoker can proceed to the next step of the
    # <a href="#steps">encoding operation</a>.  Otherwise this method
    # should be invoked again with further input.  </p></li>
    # 
    # <li><p> {@link CoderResult#OVERFLOW} indicates that there is
    # insufficient space in the output buffer to encode any more characters.
    # This method should be invoked again with an output buffer that has
    # more {@linkplain Buffer#remaining remaining} bytes. This is
    # typically done by draining any encoded bytes from the output
    # buffer.  </p></li>
    # 
    # <li><p> A {@link CoderResult#malformedForLength
    # </code>malformed-input<code>} result indicates that a malformed-input
    # error has been detected.  The malformed characters begin at the input
    # buffer's (possibly incremented) position; the number of malformed
    # characters may be determined by invoking the result object's {@link
    # CoderResult#length() length} method.  This case applies only if the
    # {@link #onMalformedInput </code>malformed action<code>} of this encoder
    # is {@link CodingErrorAction#REPORT}; otherwise the malformed input
    # will be ignored or replaced, as requested.  </p></li>
    # 
    # <li><p> An {@link CoderResult#unmappableForLength
    # </code>unmappable-character<code>} result indicates that an
    # unmappable-character error has been detected.  The characters that
    # encode the unmappable character begin at the input buffer's (possibly
    # incremented) position; the number of such characters may be determined
    # by invoking the result object's {@link CoderResult#length() length}
    # method.  This case applies only if the {@link #onUnmappableCharacter
    # </code>unmappable action<code>} of this encoder is {@link
    # CodingErrorAction#REPORT}; otherwise the unmappable character will be
    # ignored or replaced, as requested.  </p></li>
    # 
    # </ul>
    # 
    # In any case, if this method is to be reinvoked in the same encoding
    # operation then care should be taken to preserve any characters remaining
    # in the input buffer so that they are available to the next invocation.
    # 
    # <p> The <tt>endOfInput</tt> parameter advises this method as to whether
    # the invoker can provide further input beyond that contained in the given
    # input buffer.  If there is a possibility of providing additional input
    # then the invoker should pass <tt>false</tt> for this parameter; if there
    # is no possibility of providing further input then the invoker should
    # pass <tt>true</tt>.  It is not erroneous, and in fact it is quite
    # common, to pass <tt>false</tt> in one invocation and later discover that
    # no further input was actually available.  It is critical, however, that
    # the final invocation of this method in a sequence of invocations always
    # pass <tt>true</tt> so that any remaining unencoded input will be treated
    # as being malformed.
    # 
    # <p> This method works by invoking the {@link #encodeLoop encodeLoop}
    # method, interpreting its results, handling error conditions, and
    # reinvoking it as necessary.  </p>
    # 
    # 
    # @param  in
    # The input character buffer
    # 
    # @param  out
    # The output byte buffer
    # 
    # @param  endOfInput
    # <tt>true</tt> if, and only if, the invoker can provide no
    # additional input characters beyond those in the given buffer
    # 
    # @return  A coder-result object describing the reason for termination
    # 
    # @throws  IllegalStateException
    # If an encoding operation is already in progress and the previous
    # step was an invocation neither of the {@link #reset reset}
    # method, nor of this method with a value of <tt>false</tt> for
    # the <tt>endOfInput</tt> parameter, nor of this method with a
    # value of <tt>true</tt> for the <tt>endOfInput</tt> parameter
    # but a return value indicating an incomplete encoding operation
    # 
    # @throws  CoderMalfunctionError
    # If an invocation of the encodeLoop method threw
    # an unexpected exception
    def encode(in_, out, end_of_input)
      new_state = end_of_input ? ST_END : ST_CODING
      if ((!(@state).equal?(ST_RESET)) && (!(@state).equal?(ST_CODING)) && !(end_of_input && ((@state).equal?(ST_END))))
        throw_illegal_state_exception(@state, new_state)
      end
      @state = new_state
      loop do
        cr = nil
        begin
          cr = encode_loop(in_, out)
        rescue BufferUnderflowException => x
          raise CoderMalfunctionError.new(x)
        rescue BufferOverflowException => x
          raise CoderMalfunctionError.new(x)
        end
        if (cr.is_overflow)
          return cr
        end
        if (cr.is_underflow)
          if (end_of_input && in_.has_remaining)
            cr = CoderResult.malformed_for_length(in_.remaining)
            # Fall through to malformed-input case
          else
            return cr
          end
        end
        action = nil
        if (cr.is_malformed)
          action = @malformed_input_action
        else
          if (cr.is_unmappable)
            action = @unmappable_character_action
          else
            raise AssertError, RJava.cast_to_string(cr.to_s) if not (false)
          end
        end
        if ((action).equal?(CodingErrorAction::REPORT))
          return cr
        end
        if ((action).equal?(CodingErrorAction::REPLACE))
          if (out.remaining < @replacement.attr_length)
            return CoderResult::OVERFLOW
          end
          out.put(@replacement)
        end
        if (((action).equal?(CodingErrorAction::IGNORE)) || ((action).equal?(CodingErrorAction::REPLACE)))
          # Skip erroneous input either way
          in_.position(in_.position + cr.length)
          next
        end
        raise AssertError if not (false)
      end
    end
    
    typesig { [ByteBuffer] }
    # Flushes this encoder.
    # 
    # <p> Some encoders maintain internal state and may need to write some
    # final bytes to the output buffer once the overall input sequence has
    # been read.
    # 
    # <p> Any additional output is written to the output buffer beginning at
    # its current position.  At most {@link Buffer#remaining out.remaining()}
    # bytes will be written.  The buffer's position will be advanced
    # appropriately, but its mark and limit will not be modified.
    # 
    # <p> If this method completes successfully then it returns {@link
    # CoderResult#UNDERFLOW}.  If there is insufficient room in the output
    # buffer then it returns {@link CoderResult#OVERFLOW}.  If this happens
    # then this method must be invoked again, with an output buffer that has
    # more room, in order to complete the current <a href="#steps">encoding
    # operation</a>.
    # 
    # <p> If this encoder has already been flushed then invoking this method
    # has no effect.
    # 
    # <p> This method invokes the {@link #implFlush implFlush} method to
    # perform the actual flushing operation.  </p>
    # 
    # @param  out
    # The output byte buffer
    # 
    # @return  A coder-result object, either {@link CoderResult#UNDERFLOW} or
    # {@link CoderResult#OVERFLOW}
    # 
    # @throws  IllegalStateException
    # If the previous step of the current encoding operation was an
    # invocation neither of the {@link #flush flush} method nor of
    # the three-argument {@link
    # #encode(CharBuffer,ByteBuffer,boolean) encode} method
    # with a value of <tt>true</tt> for the <tt>endOfInput</tt>
    # parameter
    def flush(out)
      if ((@state).equal?(ST_END))
        cr = impl_flush(out)
        if (cr.is_underflow)
          @state = ST_FLUSHED
        end
        return cr
      end
      if (!(@state).equal?(ST_FLUSHED))
        throw_illegal_state_exception(@state, ST_FLUSHED)
      end
      return CoderResult::UNDERFLOW # Already flushed
    end
    
    typesig { [ByteBuffer] }
    # Flushes this encoder.
    # 
    # <p> The default implementation of this method does nothing, and always
    # returns {@link CoderResult#UNDERFLOW}.  This method should be overridden
    # by encoders that may need to write final bytes to the output buffer
    # once the entire input sequence has been read. </p>
    # 
    # @param  out
    # The output byte buffer
    # 
    # @return  A coder-result object, either {@link CoderResult#UNDERFLOW} or
    # {@link CoderResult#OVERFLOW}
    def impl_flush(out)
      return CoderResult::UNDERFLOW
    end
    
    typesig { [] }
    # Resets this encoder, clearing any internal state.
    # 
    # <p> This method resets charset-independent state and also invokes the
    # {@link #implReset() implReset} method in order to perform any
    # charset-specific reset actions.  </p>
    # 
    # @return  This encoder
    def reset
      impl_reset
      @state = ST_RESET
      return self
    end
    
    typesig { [] }
    # Resets this encoder, clearing any charset-specific internal state.
    # 
    # <p> The default implementation of this method does nothing.  This method
    # should be overridden by encoders that maintain internal state.  </p>
    def impl_reset
    end
    
    typesig { [CharBuffer, ByteBuffer] }
    # Encodes one or more characters into one or more bytes.
    # 
    # <p> This method encapsulates the basic encoding loop, encoding as many
    # characters as possible until it either runs out of input, runs out of room
    # in the output buffer, or encounters an encoding error.  This method is
    # invoked by the {@link #encode encode} method, which handles result
    # interpretation and error recovery.
    # 
    # <p> The buffers are read from, and written to, starting at their current
    # positions.  At most {@link Buffer#remaining in.remaining()} characters
    # will be read, and at most {@link Buffer#remaining out.remaining()}
    # bytes will be written.  The buffers' positions will be advanced to
    # reflect the characters read and the bytes written, but their marks and
    # limits will not be modified.
    # 
    # <p> This method returns a {@link CoderResult} object to describe its
    # reason for termination, in the same manner as the {@link #encode encode}
    # method.  Most implementations of this method will handle encoding errors
    # by returning an appropriate result object for interpretation by the
    # {@link #encode encode} method.  An optimized implementation may instead
    # examine the relevant error action and implement that action itself.
    # 
    # <p> An implementation of this method may perform arbitrary lookahead by
    # returning {@link CoderResult#UNDERFLOW} until it receives sufficient
    # input.  </p>
    # 
    # @param  in
    # The input character buffer
    # 
    # @param  out
    # The output byte buffer
    # 
    # @return  A coder-result object describing the reason for termination
    def encode_loop(in_, out)
      raise NotImplementedError
    end
    
    typesig { [CharBuffer] }
    # Convenience method that encodes the remaining content of a single input
    # character buffer into a newly-allocated byte buffer.
    # 
    # <p> This method implements an entire <a href="#steps">encoding
    # operation</a>; that is, it resets this encoder, then it encodes the
    # characters in the given character buffer, and finally it flushes this
    # encoder.  This method should therefore not be invoked if an encoding
    # operation is already in progress.  </p>
    # 
    # @param  in
    # The input character buffer
    # 
    # @return A newly-allocated byte buffer containing the result of the
    # encoding operation.  The buffer's position will be zero and its
    # limit will follow the last byte written.
    # 
    # @throws  IllegalStateException
    # If an encoding operation is already in progress
    # 
    # @throws  MalformedInputException
    # If the character sequence starting at the input buffer's current
    # position is not a legal sixteen-bit Unicode sequence and the current malformed-input action
    # is {@link CodingErrorAction#REPORT}
    # 
    # @throws  UnmappableCharacterException
    # If the character sequence starting at the input buffer's current
    # position cannot be mapped to an equivalent byte sequence and
    # the current unmappable-character action is {@link
    # CodingErrorAction#REPORT}
    def encode(in_)
      n = RJava.cast_to_int((in_.remaining * average_bytes_per_char))
      out = ByteBuffer.allocate(n)
      if (((n).equal?(0)) && ((in_.remaining).equal?(0)))
        return out
      end
      reset
      loop do
        cr = in_.has_remaining ? encode(in_, out, true) : CoderResult::UNDERFLOW
        if (cr.is_underflow)
          cr = flush(out)
        end
        if (cr.is_underflow)
          break
        end
        if (cr.is_overflow)
          n = 2 * n + 1 # Ensure progress; n might be 0!
          o = ByteBuffer.allocate(n)
          out.flip
          o.put(out)
          out = o
          next
        end
        cr.throw_exception
      end
      out.flip
      return out
    end
    
    typesig { [CharBuffer] }
    def can_encode(cb)
      if ((@state).equal?(ST_FLUSHED))
        reset
      else
        if (!(@state).equal?(ST_RESET))
          throw_illegal_state_exception(@state, ST_CODING)
        end
      end
      ma = malformed_input_action
      ua = unmappable_character_action
      begin
        on_malformed_input(CodingErrorAction::REPORT)
        on_unmappable_character(CodingErrorAction::REPORT)
        encode(cb)
      rescue CharacterCodingException => x
        return false
      ensure
        on_malformed_input(ma)
        on_unmappable_character(ua)
        reset
      end
      return true
    end
    
    typesig { [::Java::Char] }
    # Tells whether or not this encoder can encode the given character.
    # 
    # <p> This method returns <tt>false</tt> if the given character is a
    # surrogate character; such characters can be interpreted only when they
    # are members of a pair consisting of a high surrogate followed by a low
    # surrogate.  The {@link #canEncode(java.lang.CharSequence)
    # canEncode(CharSequence)} method may be used to test whether or not a
    # character sequence can be encoded.
    # 
    # <p> This method may modify this encoder's state; it should therefore not
    # be invoked if an <a href="#steps">encoding operation</a> is already in
    # progress.
    # 
    # <p> The default implementation of this method is not very efficient; it
    # should generally be overridden to improve performance.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this encoder can encode
    # the given character
    # 
    # @throws  IllegalStateException
    # If an encoding operation is already in progress
    def can_encode(c)
      cb = CharBuffer.allocate(1)
      cb.put(c)
      cb.flip
      return can_encode(cb)
    end
    
    typesig { [CharSequence] }
    # Tells whether or not this encoder can encode the given character
    # sequence.
    # 
    # <p> If this method returns <tt>false</tt> for a particular character
    # sequence then more information about why the sequence cannot be encoded
    # may be obtained by performing a full <a href="#steps">encoding
    # operation</a>.
    # 
    # <p> This method may modify this encoder's state; it should therefore not
    # be invoked if an encoding operation is already in progress.
    # 
    # <p> The default implementation of this method is not very efficient; it
    # should generally be overridden to improve performance.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this encoder can encode
    # the given character without throwing any exceptions and without
    # performing any replacements
    # 
    # @throws  IllegalStateException
    # If an encoding operation is already in progress
    def can_encode(cs)
      cb = nil
      if (cs.is_a?(CharBuffer))
        cb = (cs).duplicate
      else
        cb = CharBuffer.wrap(cs.to_s)
      end
      return can_encode(cb)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def throw_illegal_state_exception(from, to)
      raise IllegalStateException.new("Current state = " + RJava.cast_to_string(self.attr_state_names[from]) + ", new state = " + RJava.cast_to_string(self.attr_state_names[to]))
    end
    
    private
    alias_method :initialize__charset_encoder, :initialize
  end
  
end
