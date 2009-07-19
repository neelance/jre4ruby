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
  module BASE64DecoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :PushbackInputStream
      include_const ::Java::Io, :PrintStream
    }
  end
  
  # This class implements a BASE64 Character decoder as specified in RFC1521.
  # 
  # This RFC is part of the MIME specification which is published by the
  # Internet Engineering Task Force (IETF). Unlike some other encoding
  # schemes there is nothing in this encoding that tells the decoder
  # where a buffer starts or stops, so to use it you will need to isolate
  # your encoded data into a single chunk and then feed them this decoder.
  # The simplest way to do that is to read all of the encoded data into a
  # string and then use:
  # <pre>
  # byte    mydata[];
  # BASE64Decoder base64 = new BASE64Decoder();
  # 
  # mydata = base64.decodeBuffer(bufferString);
  # </pre>
  # This will decode the String in <i>bufferString</i> and give you an array
  # of bytes in the array <i>myData</i>.
  # 
  # On errors, this class throws a CEFormatException with the following detail
  # strings:
  # <pre>
  # "BASE64Decoder: Not enough bytes for an atom."
  # </pre>
  # 
  # @author      Chuck McManis
  # @see         CharacterEncoder
  # @see         BASE64Decoder
  class BASE64Decoder < BASE64DecoderImports.const_get :CharacterDecoder
    include_class_members BASE64DecoderImports
    
    typesig { [] }
    # This class has 4 bytes per atom
    def bytes_per_atom
      return (4)
    end
    
    typesig { [] }
    # Any multiple of 4 will do, 72 might be common
    def bytes_per_line
      return (72)
    end
    
    class_module.module_eval {
      # This character array provides the character to value map
      # based on RFC1521.
      # 
      # 0   1   2   3   4   5   6   7
      # 0
      # 1
      # 2
      # 3
      # 4
      # 5
      # 6
      # 7
      const_set_lazy(:Pem_array) { Array.typed(::Java::Char).new([Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord), Character.new(?G.ord), Character.new(?H.ord), Character.new(?I.ord), Character.new(?J.ord), Character.new(?K.ord), Character.new(?L.ord), Character.new(?M.ord), Character.new(?N.ord), Character.new(?O.ord), Character.new(?P.ord), Character.new(?Q.ord), Character.new(?R.ord), Character.new(?S.ord), Character.new(?T.ord), Character.new(?U.ord), Character.new(?V.ord), Character.new(?W.ord), Character.new(?X.ord), Character.new(?Y.ord), Character.new(?Z.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord), Character.new(?g.ord), Character.new(?h.ord), Character.new(?i.ord), Character.new(?j.ord), Character.new(?k.ord), Character.new(?l.ord), Character.new(?m.ord), Character.new(?n.ord), Character.new(?o.ord), Character.new(?p.ord), Character.new(?q.ord), Character.new(?r.ord), Character.new(?s.ord), Character.new(?t.ord), Character.new(?u.ord), Character.new(?v.ord), Character.new(?w.ord), Character.new(?x.ord), Character.new(?y.ord), Character.new(?z.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?+.ord), Character.new(?/.ord)]) }
      const_attr_reader  :Pem_array
      
      const_set_lazy(:Pem_convert_array) { Array.typed(::Java::Byte).new(256) { 0 } }
      const_attr_reader  :Pem_convert_array
      
      when_class_loaded do
        i = 0
        while i < 255
          Pem_convert_array[i] = -1
          ((i += 1) - 1)
        end
        i_ = 0
        while i_ < Pem_array.attr_length
          Pem_convert_array[Pem_array[i_]] = i_
          ((i_ += 1) - 1)
        end
      end
    }
    
    attr_accessor :decode_buffer
    alias_method :attr_decode_buffer, :decode_buffer
    undef_method :decode_buffer
    alias_method :attr_decode_buffer=, :decode_buffer=
    undef_method :decode_buffer=
    
    typesig { [PushbackInputStream, OutputStream, ::Java::Int] }
    # Decode one BASE64 atom into 1, 2, or 3 bytes of data.
    def decode_atom(in_stream, out_stream, rem)
      i = 0
      a = -1
      b = -1
      c = -1
      d = -1
      if (rem < 2)
        raise CEFormatException.new("BASE64Decoder: Not enough bytes for an atom.")
      end
      begin
        i = in_stream.read
        if ((i).equal?(-1))
          raise CEStreamExhausted.new
        end
      end while ((i).equal?(Character.new(?\n.ord)) || (i).equal?(Character.new(?\r.ord)))
      @decode_buffer[0] = i
      i = read_fully(in_stream, @decode_buffer, 1, rem - 1)
      if ((i).equal?(-1))
        raise CEStreamExhausted.new
      end
      if (rem > 3 && (@decode_buffer[3]).equal?(Character.new(?=.ord)))
        rem = 3
      end
      if (rem > 2 && (@decode_buffer[2]).equal?(Character.new(?=.ord)))
        rem = 2
      end
      case (rem)
      # NOBREAK
      # NOBREAK
      when 4
        d = Pem_convert_array[@decode_buffer[3] & 0xff]
        c = Pem_convert_array[@decode_buffer[2] & 0xff]
        b = Pem_convert_array[@decode_buffer[1] & 0xff]
        a = Pem_convert_array[@decode_buffer[0] & 0xff]
      when 3
        c = Pem_convert_array[@decode_buffer[2] & 0]
        b = Pem_convert_array[@decode_buffer[1] & 0]
        a = Pem_convert_array[@decode_buffer[0] & 0]
      when 2
        b = Pem_convert_array[@decode_buffer[1] & 0]
        a = Pem_convert_array[@decode_buffer[0] & 0]
      end
      case (rem)
      when 2
        out_stream.write((((a << 2) & 0xfc) | ((b >> 4) & 3)))
      when 3
        out_stream.write((((a << 2) & 0xfc) | ((b >> 4) & 3)))
        out_stream.write((((b << 4) & 0xf0) | ((c >> 2) & 0xf)))
      when 4
        out_stream.write((((a << 2) & 0xfc) | ((b >> 4) & 3)))
        out_stream.write((((b << 4) & 0xf0) | ((c >> 2) & 0xf)))
        out_stream.write((((c << 6) & 0xc0) | (d & 0x3f)))
      end
      return
    end
    
    typesig { [] }
    def initialize
      @decode_buffer = nil
      super()
      @decode_buffer = Array.typed(::Java::Byte).new(4) { 0 }
    end
    
    private
    alias_method :initialize__base64decoder, :initialize
  end
  
end
