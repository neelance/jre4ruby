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
  module BASE64EncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class implements a BASE64 Character encoder as specified in RFC1521.
  # This RFC is part of the MIME specification as published by the Internet
  # Engineering Task Force (IETF). Unlike some other encoding schemes there
  # is nothing in this encoding that indicates
  # where a buffer starts or ends.
  # 
  # This means that the encoded text will simply start with the first line
  # of encoded text and end with the last line of encoded text.
  # 
  # @author      Chuck McManis
  # @see         CharacterEncoder
  # @see         BASE64Decoder
  class BASE64Encoder < BASE64EncoderImports.const_get :CharacterEncoder
    include_class_members BASE64EncoderImports
    
    typesig { [] }
    # this class encodes three bytes per atom.
    def bytes_per_atom
      return (3)
    end
    
    typesig { [] }
    # this class encodes 57 bytes per line. This results in a maximum
    # of 57/3 * 4 or 76 characters per output line. Not counting the
    # line termination.
    def bytes_per_line
      return (57)
    end
    
    class_module.module_eval {
      # This array maps the characters to their 6 bit values
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
    }
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # encodeAtom - Take three bytes of input and encode it as 4
    # printable characters. Note that if the length in len is less
    # than three is encodes either one or two '=' signs to indicate
    # padding characters.
    def encode_atom(out_stream, data, offset, len)
      a = 0
      b = 0
      c = 0
      if ((len).equal?(1))
        a = data[offset]
        b = 0
        c = 0
        out_stream.write(Pem_array[(a >> 2) & 0x3f])
        out_stream.write(Pem_array[((a << 4) & 0x30) + ((b >> 4) & 0xf)])
        out_stream.write(Character.new(?=.ord))
        out_stream.write(Character.new(?=.ord))
      else
        if ((len).equal?(2))
          a = data[offset]
          b = data[offset + 1]
          c = 0
          out_stream.write(Pem_array[(a >> 2) & 0x3f])
          out_stream.write(Pem_array[((a << 4) & 0x30) + ((b >> 4) & 0xf)])
          out_stream.write(Pem_array[((b << 2) & 0x3c) + ((c >> 6) & 0x3)])
          out_stream.write(Character.new(?=.ord))
        else
          a = data[offset]
          b = data[offset + 1]
          c = data[offset + 2]
          out_stream.write(Pem_array[(a >> 2) & 0x3f])
          out_stream.write(Pem_array[((a << 4) & 0x30) + ((b >> 4) & 0xf)])
          out_stream.write(Pem_array[((b << 2) & 0x3c) + ((c >> 6) & 0x3)])
          out_stream.write(Pem_array[c & 0x3f])
        end
      end
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__base64encoder, :initialize
  end
  
end
