require "rjava"

# Copyright 1995-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UUDecoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :PushbackInputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class implements a Berkeley uu character decoder. This decoder
  # was made famous by the uudecode program.
  # 
  # The basic character coding is algorithmic, taking 6 bits of binary
  # data and adding it to an ASCII ' ' (space) character. This converts
  # these six bits into a printable representation. Note that it depends
  # on the ASCII character encoding standard for english. Groups of three
  # bytes are converted into 4 characters by treating the three bytes
  # a four 6 bit groups, group 1 is byte 1's most significant six bits,
  # group 2 is byte 1's least significant two bits plus byte 2's four
  # most significant bits. etc.
  # 
  # In this encoding, the buffer prefix is:
  # <pre>
  # begin [mode] [filename]
  # </pre>
  # 
  # This is followed by one or more lines of the form:
  # <pre>
  # (len)(data)(data)(data) ...
  # </pre>
  # where (len) is the number of bytes on this line. Note that groupings
  # are always four characters, even if length is not a multiple of three
  # bytes. When less than three characters are encoded, the values of the
  # last remaining bytes is undefined and should be ignored.
  # 
  # The last line of data in a uuencoded buffer is represented by a single
  # space character. This is translated by the decoding engine to a line
  # length of zero. This is immediately followed by a line which contains
  # the word 'end[newline]'
  # 
  # If an error is encountered during decoding this class throws a
  # CEFormatException. The specific detail messages are:
  # 
  # <pre>
  # "UUDecoder: No begin line."
  # "UUDecoder: Malformed begin line."
  # "UUDecoder: Short Buffer."
  # "UUDecoder: Bad Line Length."
  # "UUDecoder: Missing 'end' line."
  # </pre>
  # 
  # @author      Chuck McManis
  # @see         CharacterDecoder
  # @see         UUEncoder
  class UUDecoder < UUDecoderImports.const_get :CharacterDecoder
    include_class_members UUDecoderImports
    
    # This string contains the name that was in the buffer being decoded.
    attr_accessor :buffer_name
    alias_method :attr_buffer_name, :buffer_name
    undef_method :buffer_name
    alias_method :attr_buffer_name=, :buffer_name=
    undef_method :buffer_name=
    
    # Represents UNIX(tm) mode bits. Generally three octal digits
    # representing read, write, and execute permission of the owner,
    # group owner, and  others. They should be interpreted as the bit groups:
    # <pre>
    # (owner) (group) (others)
    # rwx      rwx     rwx    (r = read, w = write, x = execute)
    # </pre>
    attr_accessor :mode
    alias_method :attr_mode, :mode
    undef_method :mode
    alias_method :attr_mode=, :mode=
    undef_method :mode=
    
    typesig { [] }
    # UU encoding specifies 3 bytes per atom.
    def bytes_per_atom
      return (3)
    end
    
    typesig { [] }
    # All UU lines have 45 bytes on them, for line length of 15*4+1 or 61
    # characters per line.
    def bytes_per_line
      return (45)
    end
    
    # This is used to decode the atoms
    attr_accessor :decoder_buffer
    alias_method :attr_decoder_buffer, :decoder_buffer
    undef_method :decoder_buffer
    alias_method :attr_decoder_buffer=, :decoder_buffer=
    undef_method :decoder_buffer=
    
    typesig { [PushbackInputStream, OutputStream, ::Java::Int] }
    # Decode a UU atom. Note that if l is less than 3 we don't write
    # the extra bits, however the encoder always encodes 4 character
    # groups even when they are not needed.
    def decode_atom(in_stream, out_stream, l)
      i = 0
      c1 = 0
      c2 = 0
      c3 = 0
      c4 = 0
      a = 0
      b = 0
      c = 0
      x = StringBuffer.new
      i = 0
      while i < 4
        c1 = in_stream.read
        if ((c1).equal?(-1))
          raise CEStreamExhausted.new
        end
        x.append(RJava.cast_to_char(c1))
        @decoder_buffer[i] = ((c1 - Character.new(?\s.ord)) & 0x3f)
        ((i += 1) - 1)
      end
      a = ((@decoder_buffer[0] << 2) & 0xfc) | ((@decoder_buffer[1] >> 4) & 3)
      b = ((@decoder_buffer[1] << 4) & 0xf0) | ((@decoder_buffer[2] >> 2) & 0xf)
      c = ((@decoder_buffer[2] << 6) & 0xc0) | (@decoder_buffer[3] & 0x3f)
      out_stream.write((a & 0xff))
      if (l > 1)
        out_stream.write((b & 0xff))
      end
      if (l > 2)
        out_stream.write((c & 0xff))
      end
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # For uuencoded buffers, the data begins with a line of the form:
    # begin MODE FILENAME
    # This line always starts in column 1.
    def decode_buffer_prefix(in_stream, out_stream)
      c = 0
      q = StringBuffer.new(32)
      r = nil
      saw_new_line = false
      # This works by ripping through the buffer until it finds a 'begin'
      # line or the end of the buffer.
      saw_new_line = true
      while (true)
        c = in_stream.read
        if ((c).equal?(-1))
          raise CEFormatException.new("UUDecoder: No begin line.")
        end
        if (((c).equal?(Character.new(?b.ord))) && saw_new_line)
          c = in_stream.read
          if ((c).equal?(Character.new(?e.ord)))
            break
          end
        end
        saw_new_line = ((c).equal?(Character.new(?\n.ord))) || ((c).equal?(Character.new(?\r.ord)))
      end
      # Now we think its begin, (we've seen ^be) so verify it here.
      while ((!(c).equal?(Character.new(?\n.ord))) && (!(c).equal?(Character.new(?\r.ord))))
        c = in_stream.read
        if ((c).equal?(-1))
          raise CEFormatException.new("UUDecoder: No begin line.")
        end
        if ((!(c).equal?(Character.new(?\n.ord))) && (!(c).equal?(Character.new(?\r.ord))))
          q.append(RJava.cast_to_char(c))
        end
      end
      r = (q.to_s).to_s
      if (!(r.index_of(Character.new(?\s.ord))).equal?(3))
        raise CEFormatException.new("UUDecoder: Malformed begin line.")
      end
      @mode = JavaInteger.parse_int(r.substring(4, 7))
      @buffer_name = (r.substring(r.index_of(Character.new(?\s.ord), 6) + 1)).to_s
      # Check for \n after \r
      if ((c).equal?(Character.new(?\r.ord)))
        c = in_stream.read
        if ((!(c).equal?(Character.new(?\n.ord))) && (!(c).equal?(-1)))
          in_stream.unread(c)
        end
      end
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # In uuencoded buffers, encoded lines start with a character that
    # represents the number of bytes encoded in this line. The last
    # line of input is always a line that starts with a single space
    # character, which would be a zero length line.
    def decode_line_prefix(in_stream, out_stream)
      c = 0
      c = in_stream.read
      if ((c).equal?(Character.new(?\s.ord)))
        c = in_stream.read
        # discard the (first)trailing CR or LF
        c = in_stream.read
        # check for a second one
        if ((!(c).equal?(Character.new(?\n.ord))) && (!(c).equal?(-1)))
          in_stream.unread(c)
        end
        raise CEStreamExhausted.new
      else
        if ((c).equal?(-1))
          raise CEFormatException.new("UUDecoder: Short Buffer.")
        end
      end
      c = (c - Character.new(?\s.ord)) & 0x3f
      if (c > bytes_per_line)
        raise CEFormatException.new("UUDecoder: Bad Line Length.")
      end
      return (c)
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # Find the end of the line for the next operation.
    # The following sequences are recognized as end-of-line
    # CR, CR LF, or LF
    def decode_line_suffix(in_stream, out_stream)
      c = 0
      while (true)
        c = in_stream.read
        if ((c).equal?(-1))
          raise CEStreamExhausted.new
        end
        if ((c).equal?(Character.new(?\n.ord)))
          break
        end
        if ((c).equal?(Character.new(?\r.ord)))
          c = in_stream.read
          if ((!(c).equal?(Character.new(?\n.ord))) && (!(c).equal?(-1)))
            in_stream.unread(c)
          end
          break
        end
      end
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # UUencoded files have a buffer suffix which consists of the word
    # end. This line should immediately follow the line with a single
    # space in it.
    def decode_buffer_suffix(in_stream, out_stream)
      c = 0
      c = in_stream.read(@decoder_buffer)
      if ((!(@decoder_buffer[0]).equal?(Character.new(?e.ord))) || (!(@decoder_buffer[1]).equal?(Character.new(?n.ord))) || (!(@decoder_buffer[2]).equal?(Character.new(?d.ord))))
        raise CEFormatException.new("UUDecoder: Missing 'end' line.")
      end
    end
    
    typesig { [] }
    def initialize
      @buffer_name = nil
      @mode = 0
      @decoder_buffer = nil
      super()
      @decoder_buffer = Array.typed(::Java::Byte).new(4) { 0 }
    end
    
    private
    alias_method :initialize__uudecoder, :initialize
  end
  
end
