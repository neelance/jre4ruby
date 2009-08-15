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
  module UUEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class implements a Berkeley uu character encoder. This encoder
  # was made famous by uuencode program.
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
  # The last line of data in a uuencoded file is represented by a single
  # space character. This is translated by the decoding engine to a line
  # length of zero. This is immediately followed by a line which contains
  # the word 'end[newline]'
  # 
  # @author      Chuck McManis
  # @see         CharacterEncoder
  # @see         UUDecoder
  class UUEncoder < UUEncoderImports.const_get :CharacterEncoder
    include_class_members UUEncoderImports
    
    # This name is stored in the begin line.
    attr_accessor :buffer_name
    alias_method :attr_buffer_name, :buffer_name
    undef_method :buffer_name
    alias_method :attr_buffer_name=, :buffer_name=
    undef_method :buffer_name=
    
    # Represents UNIX(tm) mode bits. Generally three octal digits representing
    # read, write, and execute permission of the owner, group owner, and
    # others. They should be interpreted as the bit groups:
    # (owner) (group) (others)
    # rwx      rwx     rwx    (r = read, w = write, x = execute)
    # 
    # By default these are set to 644 (UNIX rw-r--r-- permissions).
    attr_accessor :mode
    alias_method :attr_mode, :mode
    undef_method :mode
    alias_method :attr_mode=, :mode=
    undef_method :mode=
    
    typesig { [] }
    # Default - buffer begin line will be:
    # <pre>
    # begin 644 encoder.buf
    # </pre>
    def initialize
      @buffer_name = nil
      @mode = 0
      super()
      @buffer_name = "encoder.buf"
      @mode = 644
    end
    
    typesig { [String] }
    # Specifies a name for the encoded buffer, begin line will be:
    # <pre>
    # begin 644 [FNAME]
    # </pre>
    def initialize(fname)
      @buffer_name = nil
      @mode = 0
      super()
      @buffer_name = fname
      @mode = 644
    end
    
    typesig { [String, ::Java::Int] }
    # Specifies a name and mode for the encoded buffer, begin line will be:
    # <pre>
    # begin [MODE] [FNAME]
    # </pre>
    def initialize(fname, new_mode)
      @buffer_name = nil
      @mode = 0
      super()
      @buffer_name = fname
      @mode = new_mode
    end
    
    typesig { [] }
    # number of bytes per atom in uuencoding is 3
    def bytes_per_atom
      return (3)
    end
    
    typesig { [] }
    # number of bytes per line in uuencoding is 45
    def bytes_per_line
      return (45)
    end
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # encodeAtom - take three bytes and encodes them into 4 characters
    # If len is less than 3 then remaining bytes are filled with '1'.
    # This insures that the last line won't end in spaces and potentiallly
    # be truncated.
    def encode_atom(out_stream, data, offset, len)
      a = 0
      b = 1
      c = 1
      c1 = 0
      c2 = 0
      c3 = 0
      c4 = 0
      a = data[offset]
      if (len > 1)
        b = data[offset + 1]
      end
      if (len > 2)
        c = data[offset + 2]
      end
      c1 = (a >> 2) & 0x3f
      c2 = ((a << 4) & 0x30) | ((b >> 4) & 0xf)
      c3 = ((b << 2) & 0x3c) | ((c >> 6) & 0x3)
      c4 = c & 0x3f
      out_stream.write(c1 + Character.new(?\s.ord))
      out_stream.write(c2 + Character.new(?\s.ord))
      out_stream.write(c3 + Character.new(?\s.ord))
      out_stream.write(c4 + Character.new(?\s.ord))
      return
    end
    
    typesig { [OutputStream, ::Java::Int] }
    # Encode the line prefix which consists of the single character. The
    # lenght is added to the value of ' ' (32 decimal) and printed.
    def encode_line_prefix(out_stream, length)
      out_stream.write((length & 0x3f) + Character.new(?\s.ord))
    end
    
    typesig { [OutputStream] }
    # The line suffix for uuencoded files is simply a new line.
    def encode_line_suffix(out_stream)
      self.attr_p_stream.println
    end
    
    typesig { [OutputStream] }
    # encodeBufferPrefix writes the begin line to the output stream.
    def encode_buffer_prefix(a)
      @p_stream = PrintStream.new(a)
      @p_stream.print("begin " + RJava.cast_to_string(@mode) + " ")
      if (!(@buffer_name).nil?)
        @p_stream.println(@buffer_name)
      else
        @p_stream.println("encoder.bin")
      end
      @p_stream.flush
    end
    
    typesig { [OutputStream] }
    # encodeBufferSuffix writes the single line containing space (' ') and
    # the line containing the word 'end' to the output stream.
    def encode_buffer_suffix(a)
      @p_stream.println(" \nend")
      @p_stream.flush
    end
    
    private
    alias_method :initialize__uuencoder, :initialize
  end
  
end
