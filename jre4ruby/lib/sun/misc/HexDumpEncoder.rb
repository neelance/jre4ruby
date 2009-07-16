require "rjava"

# 
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
  module HexDumpEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # 
  # This class encodes a buffer into the classic: "Hexadecimal Dump" format of
  # the past. It is useful for analyzing the contents of binary buffers.
  # The format produced is as follows:
  # <pre>
  # xxxx: 00 11 22 33 44 55 66 77   88 99 aa bb cc dd ee ff ................
  # </pre>
  # Where xxxx is the offset into the buffer in 16 byte chunks, followed
  # by ascii coded hexadecimal bytes followed by the ASCII representation of
  # the bytes or '.' if they are not valid bytes.
  # 
  # @author      Chuck McManis
  class HexDumpEncoder < HexDumpEncoderImports.const_get :CharacterEncoder
    include_class_members HexDumpEncoderImports
    
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    attr_accessor :this_line_length
    alias_method :attr_this_line_length, :this_line_length
    undef_method :this_line_length
    alias_method :attr_this_line_length=, :this_line_length=
    undef_method :this_line_length=
    
    attr_accessor :current_byte
    alias_method :attr_current_byte, :current_byte
    undef_method :current_byte
    alias_method :attr_current_byte=, :current_byte=
    undef_method :current_byte=
    
    attr_accessor :this_line
    alias_method :attr_this_line, :this_line
    undef_method :this_line
    alias_method :attr_this_line=, :this_line=
    undef_method :this_line=
    
    class_module.module_eval {
      typesig { [PrintStream, ::Java::Byte] }
      def hex_digit(p, x)
        c = 0
        c = RJava.cast_to_char(((x >> 4) & 0xf))
        if (c > 9)
          c = RJava.cast_to_char(((c - 10) + Character.new(?A.ord)))
        else
          c = RJava.cast_to_char((c + Character.new(?0.ord)))
        end
        p.write(c)
        c = RJava.cast_to_char((x & 0xf))
        if (c > 9)
          c = RJava.cast_to_char(((c - 10) + Character.new(?A.ord)))
        else
          c = RJava.cast_to_char((c + Character.new(?0.ord)))
        end
        p.write(c)
      end
    }
    
    typesig { [] }
    def bytes_per_atom
      return (1)
    end
    
    typesig { [] }
    def bytes_per_line
      return (16)
    end
    
    typesig { [OutputStream] }
    def encode_buffer_prefix(o)
      @offset = 0
      super(o)
    end
    
    typesig { [OutputStream, ::Java::Int] }
    def encode_line_prefix(o, len)
      hex_digit(self.attr_p_stream, ((@offset >> 8) & 0xff))
      hex_digit(self.attr_p_stream, (@offset & 0xff))
      self.attr_p_stream.print(": ")
      @current_byte = 0
      @this_line_length = len
    end
    
    typesig { [OutputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def encode_atom(o, buf, off, len)
      @this_line[@current_byte] = buf[off]
      hex_digit(self.attr_p_stream, buf[off])
      self.attr_p_stream.print(" ")
      ((@current_byte += 1) - 1)
      if ((@current_byte).equal?(8))
        self.attr_p_stream.print("  ")
      end
    end
    
    typesig { [OutputStream] }
    def encode_line_suffix(o)
      if (@this_line_length < 16)
        i = @this_line_length
        while i < 16
          self.attr_p_stream.print("   ")
          if ((i).equal?(7))
            self.attr_p_stream.print("  ")
          end
          ((i += 1) - 1)
        end
      end
      self.attr_p_stream.print(" ")
      i_ = 0
      while i_ < @this_line_length
        if ((@this_line[i_] < Character.new(?\s.ord)) || (@this_line[i_] > Character.new(?z.ord)))
          self.attr_p_stream.print(".")
        else
          self.attr_p_stream.write(@this_line[i_])
        end
        ((i_ += 1) - 1)
      end
      self.attr_p_stream.println
      @offset += @this_line_length
    end
    
    typesig { [] }
    def initialize
      @offset = 0
      @this_line_length = 0
      @current_byte = 0
      @this_line = nil
      super()
      @this_line = Array.typed(::Java::Byte).new(16) { 0 }
    end
    
    private
    alias_method :initialize__hex_dump_encoder, :initialize
  end
  
end
