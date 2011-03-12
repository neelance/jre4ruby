require "rjava"

# Copyright 1995-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module CharacterEncoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio, :ByteBuffer
    }
  end
  
  # This class defines the encoding half of character encoders.
  # A character encoder is an algorithim for transforming 8 bit binary
  # data into text (generally 7 bit ASCII or 8 bit ISO-Latin-1 text)
  # for transmition over text channels such as e-mail and network news.
  # 
  # The character encoders have been structured around a central theme
  # that, in general, the encoded text has the form:
  # 
  # <pre>
  #      [Buffer Prefix]
  #      [Line Prefix][encoded data atoms][Line Suffix]
  #      [Buffer Suffix]
  # </pre>
  # 
  # In the CharacterEncoder and CharacterDecoder classes, one complete
  # chunk of data is referred to as a <i>buffer</i>. Encoded buffers
  # are all text, and decoded buffers (sometimes just referred to as
  # buffers) are binary octets.
  # 
  # To create a custom encoder, you must, at a minimum,  overide three
  # abstract methods in this class.
  # <DL>
  # <DD>bytesPerAtom which tells the encoder how many bytes to
  # send to encodeAtom
  # <DD>encodeAtom which encodes the bytes sent to it as text.
  # <DD>bytesPerLine which tells the encoder the maximum number of
  # bytes per line.
  # </DL>
  # 
  # Several useful encoders have already been written and are
  # referenced in the See Also list below.
  # 
  # @author      Chuck McManis
  # @see         CharacterDecoder;
  # @see         UCEncoder
  # @see         UUEncoder
  # @see         BASE64Encoder
  class CharacterEncoder 
    include_class_members CharacterEncoderImports
    
    # Stream that understands "printing"
    attr_accessor :p_stream
    alias_method :attr_p_stream, :p_stream
    undef_method :p_stream
    alias_method :attr_p_stream=, :p_stream=
    undef_method :p_stream=
    
    typesig { [] }
    # Return the number of bytes per atom of encoding
    def bytes_per_atom
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the number of bytes that can be encoded per line
    def bytes_per_line
      raise NotImplementedError
    end
    
    typesig { [OutputStream] }
    # Encode the prefix for the entire buffer. By default is simply
    # opens the PrintStream for use by the other functions.
    def encode_buffer_prefix(a_stream)
      @p_stream = PrintStream.new(a_stream)
    end
    
    typesig { [OutputStream] }
    # Encode the suffix for the entire buffer.
    def encode_buffer_suffix(a_stream)
    end
    
    typesig { [OutputStream, ::Java::Int] }
    # Encode the prefix that starts every output line.
    def encode_line_prefix(a_stream, a_length)
    end
    
    typesig { [OutputStream] }
    # Encode the suffix that ends every output line. By default
    # this method just prints a <newline> into the output stream.
    def encode_line_suffix(a_stream)
      @p_stream.println
    end
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Encode one "atom" of information into characters.
    def encode_atom(a_stream, some_bytes, an_offset, a_length)
      raise NotImplementedError
    end
    
    typesig { [InputStream, Array.typed(::Java::Byte)] }
    # This method works around the bizarre semantics of BufferedInputStream's
    # read method.
    def read_fully(in_, buffer)
      i = 0
      while i < buffer.attr_length
        q = in_.read
        if ((q).equal?(-1))
          return i
        end
        buffer[i] = q
        i += 1
      end
      return buffer.attr_length
    end
    
    typesig { [InputStream, OutputStream] }
    # Encode bytes from the input stream, and write them as text characters
    # to the output stream. This method will run until it exhausts the
    # input stream, but does not print the line suffix for a final
    # line that is shorter than bytesPerLine().
    def encode(in_stream, out_stream)
      j = 0
      num_bytes = 0
      tmpbuffer = Array.typed(::Java::Byte).new(bytes_per_line) { 0 }
      encode_buffer_prefix(out_stream)
      while (true)
        num_bytes = read_fully(in_stream, tmpbuffer)
        if ((num_bytes).equal?(0))
          break
        end
        encode_line_prefix(out_stream, num_bytes)
        j = 0
        while j < num_bytes
          if ((j + bytes_per_atom) <= num_bytes)
            encode_atom(out_stream, tmpbuffer, j, bytes_per_atom)
          else
            encode_atom(out_stream, tmpbuffer, j, (num_bytes) - j)
          end
          j += bytes_per_atom
        end
        if (num_bytes < bytes_per_line)
          break
        else
          encode_line_suffix(out_stream)
        end
      end
      encode_buffer_suffix(out_stream)
    end
    
    typesig { [Array.typed(::Java::Byte), OutputStream] }
    # Encode the buffer in <i>aBuffer</i> and write the encoded
    # result to the OutputStream <i>aStream</i>.
    def encode(a_buffer, a_stream)
      in_stream = ByteArrayInputStream.new(a_buffer)
      encode(in_stream, a_stream)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # A 'streamless' version of encode that simply takes a buffer of
    # bytes and returns a string containing the encoded buffer.
    def encode(a_buffer)
      out_stream = ByteArrayOutputStream.new
      in_stream = ByteArrayInputStream.new(a_buffer)
      ret_val = nil
      begin
        encode(in_stream, out_stream)
        # explicit ascii->unicode conversion
        ret_val = RJava.cast_to_string(out_stream.to_s("8859_1"))
      rescue JavaException => ioexception
        # This should never happen.
        raise JavaError.new("CharacterEncoder.encode internal error")
      end
      return (ret_val)
    end
    
    typesig { [ByteBuffer] }
    # Return a byte array from the remaining bytes in this ByteBuffer.
    # <P>
    # The ByteBuffer's position will be advanced to ByteBuffer's limit.
    # <P>
    # To avoid an extra copy, the implementation will attempt to return the
    # byte array backing the ByteBuffer.  If this is not possible, a
    # new byte array will be created.
    def get_bytes(bb)
      # This should never return a BufferOverflowException, as we're
      # careful to allocate just the right amount.
      buf = nil
      # If it has a usable backing byte buffer, use it.  Use only
      # if the array exactly represents the current ByteBuffer.
      if (bb.has_array)
        tmp = bb.array
        if (((tmp.attr_length).equal?(bb.capacity)) && ((tmp.attr_length).equal?(bb.remaining)))
          buf = tmp
          bb.position(bb.limit)
        end
      end
      if ((buf).nil?)
        # This class doesn't have a concept of encode(buf, len, off),
        # so if we have a partial buffer, we must reallocate
        # space.
        buf = Array.typed(::Java::Byte).new(bb.remaining) { 0 }
        # position() automatically updated
        bb.get(buf)
      end
      return buf
    end
    
    typesig { [ByteBuffer, OutputStream] }
    # Encode the <i>aBuffer</i> ByteBuffer and write the encoded
    # result to the OutputStream <i>aStream</i>.
    # <P>
    # The ByteBuffer's position will be advanced to ByteBuffer's limit.
    def encode(a_buffer, a_stream)
      buf = get_bytes(a_buffer)
      encode(buf, a_stream)
    end
    
    typesig { [ByteBuffer] }
    # A 'streamless' version of encode that simply takes a ByteBuffer
    # and returns a string containing the encoded buffer.
    # <P>
    # The ByteBuffer's position will be advanced to ByteBuffer's limit.
    def encode(a_buffer)
      buf = get_bytes(a_buffer)
      return encode(buf)
    end
    
    typesig { [InputStream, OutputStream] }
    # Encode bytes from the input stream, and write them as text characters
    # to the output stream. This method will run until it exhausts the
    # input stream. It differs from encode in that it will add the
    # line at the end of a final line that is shorter than bytesPerLine().
    def encode_buffer(in_stream, out_stream)
      j = 0
      num_bytes = 0
      tmpbuffer = Array.typed(::Java::Byte).new(bytes_per_line) { 0 }
      encode_buffer_prefix(out_stream)
      while (true)
        num_bytes = read_fully(in_stream, tmpbuffer)
        if ((num_bytes).equal?(0))
          break
        end
        encode_line_prefix(out_stream, num_bytes)
        j = 0
        while j < num_bytes
          if ((j + bytes_per_atom) <= num_bytes)
            encode_atom(out_stream, tmpbuffer, j, bytes_per_atom)
          else
            encode_atom(out_stream, tmpbuffer, j, (num_bytes) - j)
          end
          j += bytes_per_atom
        end
        encode_line_suffix(out_stream)
        if (num_bytes < bytes_per_line)
          break
        end
      end
      encode_buffer_suffix(out_stream)
    end
    
    typesig { [Array.typed(::Java::Byte), OutputStream] }
    # Encode the buffer in <i>aBuffer</i> and write the encoded
    # result to the OutputStream <i>aStream</i>.
    def encode_buffer(a_buffer, a_stream)
      in_stream = ByteArrayInputStream.new(a_buffer)
      encode_buffer(in_stream, a_stream)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # A 'streamless' version of encode that simply takes a buffer of
    # bytes and returns a string containing the encoded buffer.
    def encode_buffer(a_buffer)
      out_stream = ByteArrayOutputStream.new
      in_stream = ByteArrayInputStream.new(a_buffer)
      begin
        encode_buffer(in_stream, out_stream)
      rescue JavaException => ioexception
        # This should never happen.
        raise JavaError.new("CharacterEncoder.encodeBuffer internal error")
      end
      return (out_stream.to_s)
    end
    
    typesig { [ByteBuffer, OutputStream] }
    # Encode the <i>aBuffer</i> ByteBuffer and write the encoded
    # result to the OutputStream <i>aStream</i>.
    # <P>
    # The ByteBuffer's position will be advanced to ByteBuffer's limit.
    def encode_buffer(a_buffer, a_stream)
      buf = get_bytes(a_buffer)
      encode_buffer(buf, a_stream)
    end
    
    typesig { [ByteBuffer] }
    # A 'streamless' version of encode that simply takes a ByteBuffer
    # and returns a string containing the encoded buffer.
    # <P>
    # The ByteBuffer's position will be advanced to ByteBuffer's limit.
    def encode_buffer(a_buffer)
      buf = get_bytes(a_buffer)
      return encode_buffer(buf)
    end
    
    typesig { [] }
    def initialize
      @p_stream = nil
    end
    
    private
    alias_method :initialize__character_encoder, :initialize
  end
  
end
