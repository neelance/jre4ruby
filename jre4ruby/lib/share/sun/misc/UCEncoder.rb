require "rjava"

# Copyright 1995-1997 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UCEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class implements a robust character encoder. The encoder is designed
  # to convert binary data into printable characters. The characters are
  # assumed to exist but they are not assumed to be ASCII, the complete set
  # is 0-9, A-Z, a-z, "(", and ")".
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
  # 00xxxyyy 00axxxxx 00byyyyy
  # 00 = leading zeros, all values are 0 - 63
  # xxxyyy - Top 3 bits of X, Top 3 bits of Y
  # axxxxx - a = X parity bit, xxxxx lower 5 bits of X
  # byyyyy - b = Y parity bit, yyyyy lower 5 bits of Y
  # </pre>
  # 
  # The atoms are arranged into lines suitable for inclusion into an
  # email message or text file. The number of bytes that are encoded
  # per line is 48 which keeps the total line length  under 80 chars)
  # 
  # Each line has the form(
  # <pre>
  # *(LLSS)(DDDD)(DDDD)(DDDD)...(CRC)
  # Where each (xxx) represents a three character atom.
  # (LLSS) - 8 bit length (high byte), and sequence number
  # modulo 256;
  # (DDDD) - Data byte atoms, if length is odd, last data
  # atom has (DD00) (high byte data, low byte 0)
  # (CRC)  - 16 bit CRC for the line, includes length,
  # sequence, and all data bytes. If there is a
  # zero pad byte (odd length) it is _NOT_
  # included in the CRC.
  # </pre>
  # 
  # @author      Chuck McManis
  # @see         CharacterEncoder
  # @see         UCDecoder
  class UCEncoder < UCEncoderImports.const_get :CharacterEncoder
    include_class_members UCEncoderImports
    
    typesig { [] }
    # this clase encodes two bytes per atom
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
      # 0         1         2         3         4         5         6         7
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
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # encodeAtom - take two bytes and encode them into the correct
    # three characters. If only one byte is to be encoded, the other
    # must be zero. The padding byte is not included in the CRC computation.
    def encode_atom(out_stream, data, offset, len)
      i = 0
      p1 = 0
      p2 = 0 # parity bits
      a = 0
      b = 0
      a = data[offset]
      if ((len).equal?(2))
        b = data[offset + 1]
      else
        b = 0
      end
      @crc.update(a)
      if ((len).equal?(2))
        @crc.update(b)
      end
      out_stream.write(Map_array[((a >> 2) & 0x38) + ((b >> 5) & 0x7)])
      p1 = 0
      p2 = 0
      i = 1
      while i < 256
        if (!((a & i)).equal?(0))
          p1 += 1
        end
        if (!((b & i)).equal?(0))
          p2 += 1
        end
        i = i * 2
      end
      p1 = (p1 & 1) * 32
      p2 = (p2 & 1) * 32
      out_stream.write(Map_array[(a & 31) + p1])
      out_stream.write(Map_array[(b & 31) + p2])
      return
    end
    
    typesig { [OutputStream, ::Java::Int] }
    # Each UCE encoded line starts with a prefix of '*[XXX]', where
    # the sequence number and the length are encoded in the first
    # atom.
    def encode_line_prefix(out_stream, length)
      out_stream.write(Character.new(?*.ord))
      @crc.attr_value = 0
      @tmp[0] = length
      @tmp[1] = @sequence
      @sequence = (@sequence + 1) & 0xff
      encode_atom(out_stream, @tmp, 0, 2)
    end
    
    typesig { [OutputStream] }
    # each UCE encoded line ends with YYY and encoded version of the
    # 16 bit checksum. The most significant byte of the check sum
    # is always encoded FIRST.
    def encode_line_suffix(out_stream)
      @tmp[0] = ((@crc.attr_value >> 8) & 0xff)
      @tmp[1] = (@crc.attr_value & 0xff)
      encode_atom(out_stream, @tmp, 0, 2)
      @p_stream.println
    end
    
    typesig { [OutputStream] }
    # The buffer prefix code is used to initialize the sequence number
    # to zero.
    def encode_buffer_prefix(a)
      @sequence = 0
      super(a)
    end
    
    typesig { [] }
    def initialize
      @sequence = 0
      @tmp = nil
      @crc = nil
      super()
      @tmp = Array.typed(::Java::Byte).new(2) { 0 }
      @crc = CRC16.new
    end
    
    private
    alias_method :initialize__ucencoder, :initialize
  end
  
end
