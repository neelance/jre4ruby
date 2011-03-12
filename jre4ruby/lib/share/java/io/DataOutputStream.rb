require "rjava"

# Copyright 1994-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module DataOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # A data output stream lets an application write primitive Java data
  # types to an output stream in a portable way. An application can
  # then use a data input stream to read the data back in.
  # 
  # @author  unascribed
  # @see     java.io.DataInputStream
  # @since   JDK1.0
  class DataOutputStream < DataOutputStreamImports.const_get :FilterOutputStream
    include_class_members DataOutputStreamImports
    overload_protected {
      include DataOutput
    }
    
    # The number of bytes written to the data output stream so far.
    # If this counter overflows, it will be wrapped to Integer.MAX_VALUE.
    attr_accessor :written
    alias_method :attr_written, :written
    undef_method :written
    alias_method :attr_written=, :written=
    undef_method :written=
    
    # bytearr is initialized on demand by writeUTF
    attr_accessor :bytearr
    alias_method :attr_bytearr, :bytearr
    undef_method :bytearr
    alias_method :attr_bytearr=, :bytearr=
    undef_method :bytearr=
    
    typesig { [OutputStream] }
    # Creates a new data output stream to write data to the specified
    # underlying output stream. The counter <code>written</code> is
    # set to zero.
    # 
    # @param   out   the underlying output stream, to be saved for later
    #                use.
    # @see     java.io.FilterOutputStream#out
    def initialize(out)
      @written = 0
      @bytearr = nil
      @write_buffer = nil
      super(out)
      @bytearr = nil
      @write_buffer = Array.typed(::Java::Byte).new(8) { 0 }
    end
    
    typesig { [::Java::Int] }
    # Increases the written counter by the specified value
    # until it reaches Integer.MAX_VALUE.
    def inc_count(value)
      temp = @written + value
      if (temp < 0)
        temp = JavaInteger::MAX_VALUE
      end
      @written = temp
    end
    
    typesig { [::Java::Int] }
    # Writes the specified byte (the low eight bits of the argument
    # <code>b</code>) to the underlying output stream. If no exception
    # is thrown, the counter <code>written</code> is incremented by
    # <code>1</code>.
    # <p>
    # Implements the <code>write</code> method of <code>OutputStream</code>.
    # 
    # @param      b   the <code>byte</code> to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write(b)
      synchronized(self) do
        self.attr_out.write(b)
        inc_count(1)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes <code>len</code> bytes from the specified byte array
    # starting at offset <code>off</code> to the underlying output stream.
    # If no exception is thrown, the counter <code>written</code> is
    # incremented by <code>len</code>.
    # 
    # @param      b     the data.
    # @param      off   the start offset in the data.
    # @param      len   the number of bytes to write.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write(b, off, len)
      synchronized(self) do
        self.attr_out.write(b, off, len)
        inc_count(len)
      end
    end
    
    typesig { [] }
    # Flushes this data output stream. This forces any buffered output
    # bytes to be written out to the stream.
    # <p>
    # The <code>flush</code> method of <code>DataOutputStream</code>
    # calls the <code>flush</code> method of its underlying output stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    # @see        java.io.OutputStream#flush()
    def flush
      self.attr_out.flush
    end
    
    typesig { [::Java::Boolean] }
    # Writes a <code>boolean</code> to the underlying output stream as
    # a 1-byte value. The value <code>true</code> is written out as the
    # value <code>(byte)1</code>; the value <code>false</code> is
    # written out as the value <code>(byte)0</code>. If no exception is
    # thrown, the counter <code>written</code> is incremented by
    # <code>1</code>.
    # 
    # @param      v   a <code>boolean</code> value to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write_boolean(v)
      self.attr_out.write(v ? 1 : 0)
      inc_count(1)
    end
    
    typesig { [::Java::Int] }
    # Writes out a <code>byte</code> to the underlying output stream as
    # a 1-byte value. If no exception is thrown, the counter
    # <code>written</code> is incremented by <code>1</code>.
    # 
    # @param      v   a <code>byte</code> value to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write_byte(v)
      self.attr_out.write(v)
      inc_count(1)
    end
    
    typesig { [::Java::Int] }
    # Writes a <code>short</code> to the underlying output stream as two
    # bytes, high byte first. If no exception is thrown, the counter
    # <code>written</code> is incremented by <code>2</code>.
    # 
    # @param      v   a <code>short</code> to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write_short(v)
      self.attr_out.write((v >> 8) & 0xff)
      self.attr_out.write((v >> 0) & 0xff)
      inc_count(2)
    end
    
    typesig { [::Java::Int] }
    # Writes a <code>char</code> to the underlying output stream as a
    # 2-byte value, high byte first. If no exception is thrown, the
    # counter <code>written</code> is incremented by <code>2</code>.
    # 
    # @param      v   a <code>char</code> value to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write_char(v)
      self.attr_out.write((v >> 8) & 0xff)
      self.attr_out.write((v >> 0) & 0xff)
      inc_count(2)
    end
    
    typesig { [::Java::Int] }
    # Writes an <code>int</code> to the underlying output stream as four
    # bytes, high byte first. If no exception is thrown, the counter
    # <code>written</code> is incremented by <code>4</code>.
    # 
    # @param      v   an <code>int</code> to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write_int(v)
      self.attr_out.write((v >> 24) & 0xff)
      self.attr_out.write((v >> 16) & 0xff)
      self.attr_out.write((v >> 8) & 0xff)
      self.attr_out.write((v >> 0) & 0xff)
      inc_count(4)
    end
    
    attr_accessor :write_buffer
    alias_method :attr_write_buffer, :write_buffer
    undef_method :write_buffer
    alias_method :attr_write_buffer=, :write_buffer=
    undef_method :write_buffer=
    
    typesig { [::Java::Long] }
    # Writes a <code>long</code> to the underlying output stream as eight
    # bytes, high byte first. In no exception is thrown, the counter
    # <code>written</code> is incremented by <code>8</code>.
    # 
    # @param      v   a <code>long</code> to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write_long(v)
      @write_buffer[0] = (v >> 56)
      @write_buffer[1] = (v >> 48)
      @write_buffer[2] = (v >> 40)
      @write_buffer[3] = (v >> 32)
      @write_buffer[4] = (v >> 24)
      @write_buffer[5] = (v >> 16)
      @write_buffer[6] = (v >> 8)
      @write_buffer[7] = (v >> 0)
      self.attr_out.write(@write_buffer, 0, 8)
      inc_count(8)
    end
    
    typesig { [::Java::Float] }
    # Converts the float argument to an <code>int</code> using the
    # <code>floatToIntBits</code> method in class <code>Float</code>,
    # and then writes that <code>int</code> value to the underlying
    # output stream as a 4-byte quantity, high byte first. If no
    # exception is thrown, the counter <code>written</code> is
    # incremented by <code>4</code>.
    # 
    # @param      v   a <code>float</code> value to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    # @see        java.lang.Float#floatToIntBits(float)
    def write_float(v)
      write_int(Float.float_to_int_bits(v))
    end
    
    typesig { [::Java::Double] }
    # Converts the double argument to a <code>long</code> using the
    # <code>doubleToLongBits</code> method in class <code>Double</code>,
    # and then writes that <code>long</code> value to the underlying
    # output stream as an 8-byte quantity, high byte first. If no
    # exception is thrown, the counter <code>written</code> is
    # incremented by <code>8</code>.
    # 
    # @param      v   a <code>double</code> value to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    # @see        java.lang.Double#doubleToLongBits(double)
    def write_double(v)
      write_long(Double.double_to_long_bits(v))
    end
    
    typesig { [String] }
    # Writes out the string to the underlying output stream as a
    # sequence of bytes. Each character in the string is written out, in
    # sequence, by discarding its high eight bits. If no exception is
    # thrown, the counter <code>written</code> is incremented by the
    # length of <code>s</code>.
    # 
    # @param      s   a string of bytes to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def write_bytes(s)
      len = s.length
      i = 0
      while i < len
        self.attr_out.write(s.char_at(i))
        i += 1
      end
      inc_count(len)
    end
    
    typesig { [String] }
    # Writes a string to the underlying output stream as a sequence of
    # characters. Each character is written to the data output stream as
    # if by the <code>writeChar</code> method. If no exception is
    # thrown, the counter <code>written</code> is incremented by twice
    # the length of <code>s</code>.
    # 
    # @param      s   a <code>String</code> value to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.DataOutputStream#writeChar(int)
    # @see        java.io.FilterOutputStream#out
    def write_chars(s)
      len = s.length
      i = 0
      while i < len
        v = s.char_at(i)
        self.attr_out.write((v >> 8) & 0xff)
        self.attr_out.write((v >> 0) & 0xff)
        i += 1
      end
      inc_count(len * 2)
    end
    
    typesig { [String] }
    # Writes a string to the underlying output stream using
    # <a href="DataInput.html#modified-utf-8">modified UTF-8</a>
    # encoding in a machine-independent manner.
    # <p>
    # First, two bytes are written to the output stream as if by the
    # <code>writeShort</code> method giving the number of bytes to
    # follow. This value is the number of bytes actually written out,
    # not the length of the string. Following the length, each character
    # of the string is output, in sequence, using the modified UTF-8 encoding
    # for the character. If no exception is thrown, the counter
    # <code>written</code> is incremented by the total number of
    # bytes written to the output stream. This will be at least two
    # plus the length of <code>str</code>, and at most two plus
    # thrice the length of <code>str</code>.
    # 
    # @param      str   a string to be written.
    # @exception  IOException  if an I/O error occurs.
    def write_utf(str)
      write_utf(str, self)
    end
    
    class_module.module_eval {
      typesig { [String, DataOutput] }
      # Writes a string to the specified DataOutput using
      # <a href="DataInput.html#modified-utf-8">modified UTF-8</a>
      # encoding in a machine-independent manner.
      # <p>
      # First, two bytes are written to out as if by the <code>writeShort</code>
      # method giving the number of bytes to follow. This value is the number of
      # bytes actually written out, not the length of the string. Following the
      # length, each character of the string is output, in sequence, using the
      # modified UTF-8 encoding for the character. If no exception is thrown, the
      # counter <code>written</code> is incremented by the total number of
      # bytes written to the output stream. This will be at least two
      # plus the length of <code>str</code>, and at most two plus
      # thrice the length of <code>str</code>.
      # 
      # @param      str   a string to be written.
      # @param      out   destination to write to
      # @return     The number of bytes written out.
      # @exception  IOException  if an I/O error occurs.
      def write_utf(str, out)
        strlen = str.length
        utflen = 0
        c = 0
        count = 0
        # use charAt instead of copying String to char array
        i = 0
        while i < strlen
          c = str.char_at(i)
          if ((c >= 0x1) && (c <= 0x7f))
            utflen += 1
          else
            if (c > 0x7ff)
              utflen += 3
            else
              utflen += 2
            end
          end
          i += 1
        end
        if (utflen > 65535)
          raise UTFDataFormatException.new("encoded string too long: " + RJava.cast_to_string(utflen) + " bytes")
        end
        bytearr = nil
        if (out.is_a?(DataOutputStream))
          dos = out
          if ((dos.attr_bytearr).nil? || (dos.attr_bytearr.attr_length < (utflen + 2)))
            dos.attr_bytearr = Array.typed(::Java::Byte).new((utflen * 2) + 2) { 0 }
          end
          bytearr = dos.attr_bytearr
        else
          bytearr = Array.typed(::Java::Byte).new(utflen + 2) { 0 }
        end
        bytearr[((count += 1) - 1)] = ((utflen >> 8) & 0xff)
        bytearr[((count += 1) - 1)] = ((utflen >> 0) & 0xff)
        i_ = 0
        i_ = 0
        while i_ < strlen
          c = str.char_at(i_)
          if (!((c >= 0x1) && (c <= 0x7f)))
            break
          end
          bytearr[((count += 1) - 1)] = c
          i_ += 1
        end
        while i_ < strlen
          c = str.char_at(i_)
          if ((c >= 0x1) && (c <= 0x7f))
            bytearr[((count += 1) - 1)] = c
          else
            if (c > 0x7ff)
              bytearr[((count += 1) - 1)] = (0xe0 | ((c >> 12) & 0xf))
              bytearr[((count += 1) - 1)] = (0x80 | ((c >> 6) & 0x3f))
              bytearr[((count += 1) - 1)] = (0x80 | ((c >> 0) & 0x3f))
            else
              bytearr[((count += 1) - 1)] = (0xc0 | ((c >> 6) & 0x1f))
              bytearr[((count += 1) - 1)] = (0x80 | ((c >> 0) & 0x3f))
            end
          end
          i_ += 1
        end
        out.write(bytearr, 0, utflen + 2)
        return utflen + 2
      end
    }
    
    typesig { [] }
    # Returns the current value of the counter <code>written</code>,
    # the number of bytes written to this data output stream so far.
    # If the counter overflows, it will be wrapped to Integer.MAX_VALUE.
    # 
    # @return  the value of the <code>written</code> field.
    # @see     java.io.DataOutputStream#written
    def size
      return @written
    end
    
    private
    alias_method :initialize__data_output_stream, :initialize
  end
  
end
