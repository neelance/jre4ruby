require "rjava"

# Copyright 1995-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UCDecoderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :PushbackInputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class implements a robust character decoder. The decoder will
  # converted encoded text into binary data.
  # 
  # The basic encoding unit is a 3 character atom. It encodes two bytes
  # of data. Bytes are encoded into a 64 character set, the characters
  # were chosen specifically because they appear in all codesets.
  # We don't care what their numerical equivalent is because
  # we use a character array to map them. This is like UUencoding
  # with the dependency on ASCII removed.
  # 
  # The three chars that make up an atom are encoded as follows:
  # <pre>
  #      00xxxyyy 00axxxxx 00byyyyy
  #      00 = leading zeros, all values are 0 - 63
  #      xxxyyy - Top 3 bits of X, Top 3 bits of Y
  #      axxxxx - a = X parity bit, xxxxx lower 5 bits of X
  #      byyyyy - b = Y parity bit, yyyyy lower 5 bits of Y
  # </pre>
  # 
  # The atoms are arranged into lines suitable for inclusion into an
  # email message or text file. The number of bytes that are encoded
  # per line is 48 which keeps the total line length  under 80 chars)
  # 
  # Each line has the form(
  # <pre>
  #  *(LLSS)(DDDD)(DDDD)(DDDD)...(CRC)
  #  Where each (xxx) represents a three character atom.
  #  (LLSS) - 8 bit length (high byte), and sequence number
  #           modulo 256;
  #  (DDDD) - Data byte atoms, if length is odd, last data
  #           atom has (DD00) (high byte data, low byte 0)
  #  (CRC)  - 16 bit CRC for the line, includes length,
  #           sequence, and all data bytes. If there is a
  #           zero pad byte (odd length) it is _NOT_
  #           included in the CRC.
  # </pre>
  # 
  # If an error is encountered during decoding this class throws a
  # CEFormatException. The specific detail messages are:
  # 
  # <pre>
  #    "UCDecoder: High byte parity error."
  #    "UCDecoder: Low byte parity error."
  #    "UCDecoder: Out of sequence line."
  #    "UCDecoder: CRC check failed."
  # </pre>
  # 
  # @author      Chuck McManis
  # @see         CharacterEncoder
  # @see         UCEncoder
  class UCDecoder < UCDecoderImports.const_get :CharacterDecoder
    include_class_members UCDecoderImports
    
    typesig { [] }
    # This class encodes two bytes per atom.
    def bytes_per_atom
      return (2)
    end
    
    typesig { [] }
    # this class encodes 48 bytes per line
    def bytes_per_line
      return (48)
    end
    
    class_module.module_eval {
      # this is the UCE mapping of 0-63 to characters ..
      #     0         1         2         3         4         5         6         7
      # 0
      # 1
      # 2
      # 3
      # 4
      # 5
      # 6
      # 7
      const_set_lazy(:Map_array) { Array.typed(::Java::Byte).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord), Character.new(?G.ord), Character.new(?H.ord), Character.new(?I.ord), Character.new(?J.ord), Character.new(?K.ord), Character.new(?L.ord), Character.new(?M.ord), Character.new(?N.ord), Character.new(?O.ord), Character.new(?P.ord), Character.new(?Q.ord), Character.new(?R.ord), Character.new(?S.ord), Character.new(?T.ord), Character.new(?U.ord), Character.new(?V.ord), Character.new(?W.ord), Character.new(?X.ord), Character.new(?Y.ord), Character.new(?Z.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord), Character.new(?g.ord), Character.new(?h.ord), Character.new(?i.ord), Character.new(?j.ord), Character.new(?k.ord), Character.new(?l.ord), Character.new(?m.ord), Character.new(?n.ord), Character.new(?o.ord), Character.new(?p.ord), Character.new(?q.ord), Character.new(?r.ord), Character.new(?s.ord), Character.new(?t.ord), Character.new(?u.ord), Character.new(?v.ord), Character.new(?w.ord), Character.new(?x.ord), Character.new(?y.ord), Character.new(?z.ord), Character.new(?(.ord), Character.new(?).ord)]) }
      const_attr_reader  :Map_array
    }
    
    attr_accessor :sequence
    alias_method :attr_sequence, :sequence
    undef_method :sequence
    alias_method :attr_sequence=, :sequence=
    undef_method :sequence=
    
    attr_accessor :tmp
    alias_method :attr_tmp, :tmp
    undef_method :tmp
    alias_method :attr_tmp=, :tmp=
    undef_method :tmp=
    
    attr_accessor :crc
    alias_method :attr_crc, :crc
    undef_method :crc
    alias_method :attr_crc=, :crc=
    undef_method :crc=
    
    typesig { [PushbackInputStream, OutputStream, ::Java::Int] }
    # Decode one atom - reads the characters from the input stream, decodes
    # them, and checks for valid parity.
    def decode_atom(in_stream, out_stream, l)
      i = 0
      p1 = 0
      p2 = 0
      np1 = 0
      np2 = 0
      a = -1
      b = -1
      c = -1
      high_byte = 0
      low_byte = 0
      tmp = Array.typed(::Java::Byte).new(3) { 0 }
      i = in_stream.read(tmp)
      if (!(i).equal?(3))
        raise CEStreamExhausted.new
      end
      i = 0
      while (i < 64) && (((a).equal?(-1)) || ((b).equal?(-1)) || ((c).equal?(-1)))
        if ((tmp[0]).equal?(Map_array[i]))
          a = i
        end
        if ((tmp[1]).equal?(Map_array[i]))
          b = i
        end
        if ((tmp[2]).equal?(Map_array[i]))
          c = i
        end
        i += 1
      end
      high_byte = (((a & 0x38) << 2) + (b & 0x1f))
      low_byte = (((a & 0x7) << 5) + (c & 0x1f))
      p1 = 0
      p2 = 0
      i = 1
      while i < 256
        if (!((high_byte & i)).equal?(0))
          p1 += 1
        end
        if (!((low_byte & i)).equal?(0))
          p2 += 1
        end
        i = i * 2
      end
      np1 = (b & 32) / 32
      np2 = (c & 32) / 32
      if (!((p1 & 1)).equal?(np1))
        raise CEFormatException.new("UCDecoder: High byte parity error.")
      end
      if (!((p2 & 1)).equal?(np2))
        raise CEFormatException.new("UCDecoder: Low byte parity error.")
      end
      out_stream.write(high_byte)
      @crc.update(high_byte)
      if ((l).equal?(2))
        out_stream.write(low_byte)
        @crc.update(low_byte)
      end
    end
    
    attr_accessor :line_and_seq
    alias_method :attr_line_and_seq, :line_and_seq
    undef_method :line_and_seq
    alias_method :attr_line_and_seq=, :line_and_seq=
    undef_method :line_and_seq=
    
    typesig { [PushbackInputStream, OutputStream] }
    # decodeBufferPrefix initializes the sequence number to zero.
    def decode_buffer_prefix(in_stream, out_stream)
      @sequence = 0
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # decodeLinePrefix reads the sequence number and the number of
    # encoded bytes from the line. If the sequence number is not the
    # previous sequence number + 1 then an exception is thrown.
    # UCE lines are line terminator immune, they all start with *
    # so the other thing this method does is scan for the next line
    # by looking for the * character.
    # 
    # @exception CEFormatException out of sequence lines detected.
    def decode_line_prefix(in_stream, out_stream)
      i = 0
      n_len = 0
      n_seq = 0
      xtmp = nil
      c = 0
      @crc.attr_value = 0
      while (true)
        c = in_stream.read(@tmp, 0, 1)
        if ((c).equal?(-1))
          raise CEStreamExhausted.new
        end
        if ((@tmp[0]).equal?(Character.new(?*.ord)))
          break
        end
      end
      @line_and_seq.reset
      decode_atom(in_stream, @line_and_seq, 2)
      xtmp = @line_and_seq.to_byte_array
      n_len = xtmp[0] & 0xff
      n_seq = xtmp[1] & 0xff
      if (!(n_seq).equal?(@sequence))
        raise CEFormatException.new("UCDecoder: Out of sequence line.")
      end
      @sequence = (@sequence + 1) & 0xff
      return (n_len)
    end
    
    typesig { [PushbackInputStream, OutputStream] }
    # this method reads the CRC that is at the end of every line and
    # verifies that it matches the computed CRC.
    # 
    # @exception CEFormatException if CRC check fails.
    def decode_line_suffix(in_stream, out_stream)
      i = 0
      line_crc = @crc.attr_value
      read_crc = 0
      tmp = nil
      @line_and_seq.reset
      decode_atom(in_stream, @line_and_seq, 2)
      tmp = @line_and_seq.to_byte_array
      read_crc = ((tmp[0] << 8) & 0xff00) + (tmp[1] & 0xff)
      if (!(read_crc).equal?(line_crc))
        raise CEFormatException.new("UCDecoder: CRC check failed.")
      end
    end
    
    typesig { [] }
    def initialize
      @sequence = 0
      @tmp = nil
      @crc = nil
      @line_and_seq = nil
      super()
      @tmp = Array.typed(::Java::Byte).new(2) { 0 }
      @crc = CRC16.new
      @line_and_seq = ByteArrayOutputStream.new(2)
    end
    
    private
    alias_method :initialize__ucdecoder, :initialize
  end
  
end
