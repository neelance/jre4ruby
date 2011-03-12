require "rjava"

# Copyright 1995-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CharacterDecoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :PushbackInputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio, :ByteBuffer
    }
  end
  
  # This class defines the decoding half of character encoders.
  # A character decoder is an algorithim for transforming 8 bit
  # binary data that has been encoded into text by a character
  # encoder, back into original binary form.
  # 
  # The character encoders, in general, have been structured
  # around a central theme that binary data can be encoded into
  # text that has the form:
  # 
  # <pre>
  #      [Buffer Prefix]
  #      [Line Prefix][encoded data atoms][Line Suffix]
  #      [Buffer Suffix]
  # </pre>
  # 
  # Of course in the simplest encoding schemes, the buffer has no
  # distinct prefix of suffix, however all have some fixed relationship
  # between the text in an 'atom' and the binary data itself.
  # 
  # In the CharacterEncoder and CharacterDecoder classes, one complete
  # chunk of data is referred to as a <i>buffer</i>. Encoded buffers
  # are all text, and decoded buffers (sometimes just referred to as
  # buffers) are binary octets.
  # 
  # To create a custom decoder, you must, at a minimum,  overide three
  # abstract methods in this class.
  # <DL>
  # <DD>bytesPerAtom which tells the decoder how many bytes to
  # expect from decodeAtom
  # <DD>decodeAtom which decodes the bytes sent to it as text.
  # <DD>bytesPerLine which tells the encoder the maximum number of
  # bytes per line.
  # </DL>
  # 
  # In general, the character decoders return error in the form of a
  # CEFormatException. The syntax of the detail string is
  # <pre>
  #      DecoderClassName: Error message.
  # </pre>
  # 
  # Several useful decoders have already been written and are
  # referenced in the See Also list below.
  # 
  # @author      Chuck McManis
  # @see         CEFormatException
  # @see         CharacterEncoder
  # @see         UCDecoder
  # @see         UUDecoder
  # @see         BASE64Decoder
  class CharacterDecoder 
    include_class_members CharacterDecoderImports
    
    typesig { [] }
    # Return the number of bytes per atom of decoding
    def bytes_per_atom
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the maximum number of bytes that can be encoded per line
    def bytes_per_line
      raise NotImplementedError
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # decode the beginning of the buffer, by default this is a NOP.
    def decode_buffer_prefix(a_stream, b_stream)
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # decode the buffer suffix, again by default it is a NOP.
    def decode_buffer_suffix(a_stream, b_stream)
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # This method should return, if it knows, the number of bytes
    # that will be decoded. Many formats such as uuencoding provide
    # this information. By default we return the maximum bytes that
    # could have been encoded on the line.
    def decode_line_prefix(a_stream, b_stream)
      return (bytes_per_line)
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # This method post processes the line, if there are error detection
    # or correction codes in a line, they are generally processed by
    # this method. The simplest version of this method looks for the
    # (newline) character.
    def decode_line_suffix(a_stream, b_stream)
    end
    
    typesig { [PushbackInputStream, OutputStream, ::Java::Int] }
    # This method does an actual decode. It takes the decoded bytes and
    # writes them to the OutputStream. The integer <i>l</i> tells the
    # method how many bytes are required. This is always <= bytesPerAtom().
    def decode_atom(a_stream, b_stream, l)
      raise CEStreamExhausted.new
    end
    
    typesig { [InputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # This method works around the bizarre semantics of BufferedInputStream's
    # read method.
    def read_fully(in_, buffer, offset, len)
      i = 0
      while i < len
        q = in_.read
        if ((q).equal?(-1))
          return (((i).equal?(0)) ? -1 : i)
        end
        buffer[i + offset] = q
        i += 1
      end
      return len
    end
    
    typesig { [InputStream, OutputStream] }
    # Decode the text from the InputStream and write the decoded
    # octets to the OutputStream. This method runs until the stream
    # is exhausted.
    # @exception CEFormatException An error has occured while decoding
    # @exception CEStreamExhausted The input stream is unexpectedly out of data
    def decode_buffer(a_stream, b_stream)
      i = 0
      total_bytes = 0
      ps = PushbackInputStream.new(a_stream)
      decode_buffer_prefix(ps, b_stream)
      while (true)
        length = 0
        begin
          length = decode_line_prefix(ps, b_stream)
          i = 0
          while (i + bytes_per_atom) < length
            decode_atom(ps, b_stream, bytes_per_atom)
            total_bytes += bytes_per_atom
            i += bytes_per_atom
          end
          if (((i + bytes_per_atom)).equal?(length))
            decode_atom(ps, b_stream, bytes_per_atom)
            total_bytes += bytes_per_atom
          else
            decode_atom(ps, b_stream, length - i)
            total_bytes += (length - i)
          end
          decode_line_suffix(ps, b_stream)
        rescue CEStreamExhausted => e
          break
        end
      end
      decode_buffer_suffix(ps, b_stream)
    end
    
    typesig { [String] }
    # Alternate decode interface that takes a String containing the encoded
    # buffer and returns a byte array containing the data.
    # @exception CEFormatException An error has occured while decoding
    def decode_buffer(input_string)
      input_buffer = Array.typed(::Java::Byte).new(input_string.length) { 0 }
      in_stream = nil
      out_stream = nil
      input_string.get_bytes(0, input_string.length, input_buffer, 0)
      in_stream = ByteArrayInputStream.new(input_buffer)
      out_stream = ByteArrayOutputStream.new
      decode_buffer(in_stream, out_stream)
      return (out_stream.to_byte_array)
    end
    
    typesig { [InputStream] }
    # Decode the contents of the inputstream into a buffer.
    def decode_buffer(in_)
      out_stream = ByteArrayOutputStream.new
      decode_buffer(in_, out_stream)
      return (out_stream.to_byte_array)
    end
    
    typesig { [String] }
    # Decode the contents of the String into a ByteBuffer.
    def decode_buffer_to_byte_buffer(input_string)
      return ByteBuffer.wrap(decode_buffer(input_string))
    end
    
    typesig { [InputStream] }
    # Decode the contents of the inputStream into a ByteBuffer.
    def decode_buffer_to_byte_buffer(in_)
      return ByteBuffer.wrap(decode_buffer(in_))
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__character_decoder, :initialize
  end
  
end
