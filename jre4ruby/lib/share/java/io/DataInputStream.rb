require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DataInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # A data input stream lets an application read primitive Java data
  # types from an underlying input stream in a machine-independent
  # way. An application uses a data output stream to write data that
  # can later be read by a data input stream.
  # <p>
  # DataInputStream is not necessarily safe for multithreaded access.
  # Thread safety is optional and is the responsibility of users of
  # methods in this class.
  # 
  # @author  Arthur van Hoff
  # @see     java.io.DataOutputStream
  # @since   JDK1.0
  class DataInputStream < DataInputStreamImports.const_get :FilterInputStream
    include_class_members DataInputStreamImports
    overload_protected {
      include DataInput
    }
    
    typesig { [InputStream] }
    # Creates a DataInputStream that uses the specified
    # underlying InputStream.
    # 
    # @param  in   the specified input stream
    def initialize(in_)
      @bytearr = nil
      @chararr = nil
      @read_buffer = nil
      @line_buffer = nil
      super(in_)
      @bytearr = Array.typed(::Java::Byte).new(80) { 0 }
      @chararr = CharArray.new(80)
      @read_buffer = Array.typed(::Java::Byte).new(8) { 0 }
    end
    
    # working arrays initialized on demand by readUTF
    attr_accessor :bytearr
    alias_method :attr_bytearr, :bytearr
    undef_method :bytearr
    alias_method :attr_bytearr=, :bytearr=
    undef_method :bytearr=
    
    attr_accessor :chararr
    alias_method :attr_chararr, :chararr
    undef_method :chararr
    alias_method :attr_chararr=, :chararr=
    undef_method :chararr=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reads some number of bytes from the contained input stream and
    # stores them into the buffer array <code>b</code>. The number of
    # bytes actually read is returned as an integer. This method blocks
    # until input data is available, end of file is detected, or an
    # exception is thrown.
    # 
    # <p>If <code>b</code> is null, a <code>NullPointerException</code> is
    # thrown. If the length of <code>b</code> is zero, then no bytes are
    # read and <code>0</code> is returned; otherwise, there is an attempt
    # to read at least one byte. If no byte is available because the
    # stream is at end of file, the value <code>-1</code> is returned;
    # otherwise, at least one byte is read and stored into <code>b</code>.
    # 
    # <p>The first byte read is stored into element <code>b[0]</code>, the
    # next one into <code>b[1]</code>, and so on. The number of bytes read
    # is, at most, equal to the length of <code>b</code>. Let <code>k</code>
    # be the number of bytes actually read; these bytes will be stored in
    # elements <code>b[0]</code> through <code>b[k-1]</code>, leaving
    # elements <code>b[k]</code> through <code>b[b.length-1]</code>
    # unaffected.
    # 
    # <p>The <code>read(b)</code> method has the same effect as:
    # <blockquote><pre>
    # read(b, 0, b.length)
    # </pre></blockquote>
    # 
    # @param      b   the buffer into which the data is read.
    # @return     the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end
    # of the stream has been reached.
    # @exception  IOException if the first byte cannot be read for any reason
    # other than end of file, the stream has been closed and the underlying
    # input stream does not support reading after close, or another I/O
    # error occurs.
    # @see        java.io.FilterInputStream#in
    # @see        java.io.InputStream#read(byte[], int, int)
    def read(b)
      return self.attr_in.read(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads up to <code>len</code> bytes of data from the contained
    # input stream into an array of bytes.  An attempt is made to read
    # as many as <code>len</code> bytes, but a smaller number may be read,
    # possibly zero. The number of bytes actually read is returned as an
    # integer.
    # 
    # <p> This method blocks until input data is available, end of file is
    # detected, or an exception is thrown.
    # 
    # <p> If <code>len</code> is zero, then no bytes are read and
    # <code>0</code> is returned; otherwise, there is an attempt to read at
    # least one byte. If no byte is available because the stream is at end of
    # file, the value <code>-1</code> is returned; otherwise, at least one
    # byte is read and stored into <code>b</code>.
    # 
    # <p> The first byte read is stored into element <code>b[off]</code>, the
    # next one into <code>b[off+1]</code>, and so on. The number of bytes read
    # is, at most, equal to <code>len</code>. Let <i>k</i> be the number of
    # bytes actually read; these bytes will be stored in elements
    # <code>b[off]</code> through <code>b[off+</code><i>k</i><code>-1]</code>,
    # leaving elements <code>b[off+</code><i>k</i><code>]</code> through
    # <code>b[off+len-1]</code> unaffected.
    # 
    # <p> In every case, elements <code>b[0]</code> through
    # <code>b[off]</code> and elements <code>b[off+len]</code> through
    # <code>b[b.length-1]</code> are unaffected.
    # 
    # @param      b     the buffer into which the data is read.
    # @param off the start offset in the destination array <code>b</code>
    # @param      len   the maximum number of bytes read.
    # @return     the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end
    # of the stream has been reached.
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    # @exception  IOException if the first byte cannot be read for any reason
    # other than end of file, the stream has been closed and the underlying
    # input stream does not support reading after close, or another I/O
    # error occurs.
    # @see        java.io.FilterInputStream#in
    # @see        java.io.InputStream#read(byte[], int, int)
    def read(b, off, len)
      return self.attr_in.read(b, off, len)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # See the general contract of the <code>readFully</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @param      b   the buffer into which the data is read.
    # @exception  EOFException  if this input stream reaches the end before
    # reading all the bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_fully(b)
      read_fully(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # See the general contract of the <code>readFully</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @param      b     the buffer into which the data is read.
    # @param      off   the start offset of the data.
    # @param      len   the number of bytes to read.
    # @exception  EOFException  if this input stream reaches the end before
    # reading all the bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_fully(b, off, len)
      if (len < 0)
        raise IndexOutOfBoundsException.new
      end
      n = 0
      while (n < len)
        count = self.attr_in.read(b, off + n, len - n)
        if (count < 0)
          raise EOFException.new
        end
        n += count
      end
    end
    
    typesig { [::Java::Int] }
    # See the general contract of the <code>skipBytes</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes for this operation are read from the contained
    # input stream.
    # 
    # @param      n   the number of bytes to be skipped.
    # @return     the actual number of bytes skipped.
    # @exception  IOException  if the contained input stream does not support
    # seek, or the stream has been closed and
    # the contained input stream does not support
    # reading after close, or another I/O error occurs.
    def skip_bytes(n)
      total = 0
      cur = 0
      while ((total < n) && ((cur = RJava.cast_to_int(self.attr_in.skip(n - total))) > 0))
        total += cur
      end
      return total
    end
    
    typesig { [] }
    # See the general contract of the <code>readBoolean</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes for this operation are read from the contained
    # input stream.
    # 
    # @return     the <code>boolean</code> value read.
    # @exception  EOFException  if this input stream has reached the end.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_boolean
      ch = self.attr_in.read
      if (ch < 0)
        raise EOFException.new
      end
      return (!(ch).equal?(0))
    end
    
    typesig { [] }
    # See the general contract of the <code>readByte</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next byte of this input stream as a signed 8-bit
    # <code>byte</code>.
    # @exception  EOFException  if this input stream has reached the end.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_byte
      ch = self.attr_in.read
      if (ch < 0)
        raise EOFException.new
      end
      return (ch)
    end
    
    typesig { [] }
    # See the general contract of the <code>readUnsignedByte</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next byte of this input stream, interpreted as an
    # unsigned 8-bit number.
    # @exception  EOFException  if this input stream has reached the end.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see         java.io.FilterInputStream#in
    def read_unsigned_byte
      ch = self.attr_in.read
      if (ch < 0)
        raise EOFException.new
      end
      return ch
    end
    
    typesig { [] }
    # See the general contract of the <code>readShort</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next two bytes of this input stream, interpreted as a
    # signed 16-bit number.
    # @exception  EOFException  if this input stream reaches the end before
    # reading two bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_short
      ch1 = self.attr_in.read
      ch2 = self.attr_in.read
      if ((ch1 | ch2) < 0)
        raise EOFException.new
      end
      return RJava.cast_to_short(((ch1 << 8) + (ch2 << 0)))
    end
    
    typesig { [] }
    # See the general contract of the <code>readUnsignedShort</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next two bytes of this input stream, interpreted as an
    # unsigned 16-bit integer.
    # @exception  EOFException  if this input stream reaches the end before
    # reading two bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_unsigned_short
      ch1 = self.attr_in.read
      ch2 = self.attr_in.read
      if ((ch1 | ch2) < 0)
        raise EOFException.new
      end
      return (ch1 << 8) + (ch2 << 0)
    end
    
    typesig { [] }
    # See the general contract of the <code>readChar</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next two bytes of this input stream, interpreted as a
    # <code>char</code>.
    # @exception  EOFException  if this input stream reaches the end before
    # reading two bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_char
      ch1 = self.attr_in.read
      ch2 = self.attr_in.read
      if ((ch1 | ch2) < 0)
        raise EOFException.new
      end
      return RJava.cast_to_char(((ch1 << 8) + (ch2 << 0)))
    end
    
    typesig { [] }
    # See the general contract of the <code>readInt</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next four bytes of this input stream, interpreted as an
    # <code>int</code>.
    # @exception  EOFException  if this input stream reaches the end before
    # reading four bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_int
      ch1 = self.attr_in.read
      ch2 = self.attr_in.read
      ch3 = self.attr_in.read
      ch4 = self.attr_in.read
      if ((ch1 | ch2 | ch3 | ch4) < 0)
        raise EOFException.new
      end
      return ((ch1 << 24) + (ch2 << 16) + (ch3 << 8) + (ch4 << 0))
    end
    
    attr_accessor :read_buffer
    alias_method :attr_read_buffer, :read_buffer
    undef_method :read_buffer
    alias_method :attr_read_buffer=, :read_buffer=
    undef_method :read_buffer=
    
    typesig { [] }
    # See the general contract of the <code>readLong</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next eight bytes of this input stream, interpreted as a
    # <code>long</code>.
    # @exception  EOFException  if this input stream reaches the end before
    # reading eight bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.FilterInputStream#in
    def read_long
      read_fully(@read_buffer, 0, 8)
      return ((@read_buffer[0] << 56) + ((@read_buffer[1] & 255) << 48) + ((@read_buffer[2] & 255) << 40) + ((@read_buffer[3] & 255) << 32) + ((@read_buffer[4] & 255) << 24) + ((@read_buffer[5] & 255) << 16) + ((@read_buffer[6] & 255) << 8) + ((@read_buffer[7] & 255) << 0))
    end
    
    typesig { [] }
    # See the general contract of the <code>readFloat</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next four bytes of this input stream, interpreted as a
    # <code>float</code>.
    # @exception  EOFException  if this input stream reaches the end before
    # reading four bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.DataInputStream#readInt()
    # @see        java.lang.Float#intBitsToFloat(int)
    def read_float
      return Float.int_bits_to_float(read_int)
    end
    
    typesig { [] }
    # See the general contract of the <code>readDouble</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     the next eight bytes of this input stream, interpreted as a
    # <code>double</code>.
    # @exception  EOFException  if this input stream reaches the end before
    # reading eight bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @see        java.io.DataInputStream#readLong()
    # @see        java.lang.Double#longBitsToDouble(long)
    def read_double
      return Double.long_bits_to_double(read_long)
    end
    
    attr_accessor :line_buffer
    alias_method :attr_line_buffer, :line_buffer
    undef_method :line_buffer
    alias_method :attr_line_buffer=, :line_buffer=
    undef_method :line_buffer=
    
    typesig { [] }
    # See the general contract of the <code>readLine</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @deprecated This method does not properly convert bytes to characters.
    # As of JDK&nbsp;1.1, the preferred way to read lines of text is via the
    # <code>BufferedReader.readLine()</code> method.  Programs that use the
    # <code>DataInputStream</code> class to read lines can be converted to use
    # the <code>BufferedReader</code> class by replacing code of the form:
    # <blockquote><pre>
    # DataInputStream d =&nbsp;new&nbsp;DataInputStream(in);
    # </pre></blockquote>
    # with:
    # <blockquote><pre>
    # BufferedReader d
    # =&nbsp;new&nbsp;BufferedReader(new&nbsp;InputStreamReader(in));
    # </pre></blockquote>
    # 
    # @return     the next line of text from this input stream.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.BufferedReader#readLine()
    # @see        java.io.FilterInputStream#in
    def read_line
      buf = @line_buffer
      if ((buf).nil?)
        buf = @line_buffer = CharArray.new(128)
      end
      room = buf.attr_length
      offset = 0
      c = 0
      while (true)
        case (c = self.attr_in.read)
        when -1, Character.new(?\n.ord)
          break
        when Character.new(?\r.ord)
          c2 = self.attr_in.read
          if ((!(c2).equal?(Character.new(?\n.ord))) && (!(c2).equal?(-1)))
            if (!(self.attr_in.is_a?(PushbackInputStream)))
              self.attr_in = PushbackInputStream.new(self.attr_in)
            end
            (self.attr_in).unread(c2)
          end
          break
        else
          if ((room -= 1) < 0)
            buf = CharArray.new(offset + 128)
            room = buf.attr_length - offset - 1
            System.arraycopy(@line_buffer, 0, buf, 0, offset)
            @line_buffer = buf
          end
          buf[((offset += 1) - 1)] = RJava.cast_to_char(c)
        end
      end
      if (((c).equal?(-1)) && ((offset).equal?(0)))
        return nil
      end
      return String.copy_value_of(buf, 0, offset)
    end
    
    typesig { [] }
    # See the general contract of the <code>readUTF</code>
    # method of <code>DataInput</code>.
    # <p>
    # Bytes
    # for this operation are read from the contained
    # input stream.
    # 
    # @return     a Unicode string.
    # @exception  EOFException  if this input stream reaches the end before
    # reading all the bytes.
    # @exception  IOException   the stream has been closed and the contained
    # input stream does not support reading after close, or
    # another I/O error occurs.
    # @exception  UTFDataFormatException if the bytes do not represent a valid
    # modified UTF-8 encoding of a string.
    # @see        java.io.DataInputStream#readUTF(java.io.DataInput)
    def read_utf
      return read_utf(self)
    end
    
    class_module.module_eval {
      typesig { [DataInput] }
      # Reads from the
      # stream <code>in</code> a representation
      # of a Unicode  character string encoded in
      # <a href="DataInput.html#modified-utf-8">modified UTF-8</a> format;
      # this string of characters is then returned as a <code>String</code>.
      # The details of the modified UTF-8 representation
      # are  exactly the same as for the <code>readUTF</code>
      # method of <code>DataInput</code>.
      # 
      # @param      in   a data input stream.
      # @return     a Unicode string.
      # @exception  EOFException            if the input stream reaches the end
      # before all the bytes.
      # @exception  IOException   the stream has been closed and the contained
      # input stream does not support reading after close, or
      # another I/O error occurs.
      # @exception  UTFDataFormatException  if the bytes do not represent a
      # valid modified UTF-8 encoding of a Unicode string.
      # @see        java.io.DataInputStream#readUnsignedShort()
      def read_utf(in_)
        utflen = in_.read_unsigned_short
        bytearr = nil
        chararr = nil
        if (in_.is_a?(DataInputStream))
          dis = in_
          if (dis.attr_bytearr.attr_length < utflen)
            dis.attr_bytearr = Array.typed(::Java::Byte).new(utflen * 2) { 0 }
            dis.attr_chararr = CharArray.new(utflen * 2)
          end
          chararr = dis.attr_chararr
          bytearr = dis.attr_bytearr
        else
          bytearr = Array.typed(::Java::Byte).new(utflen) { 0 }
          chararr = CharArray.new(utflen)
        end
        c = 0
        char2 = 0
        char3 = 0
        count = 0
        chararr_count = 0
        in_.read_fully(bytearr, 0, utflen)
        while (count < utflen)
          c = RJava.cast_to_int(bytearr[count]) & 0xff
          if (c > 127)
            break
          end
          count += 1
          chararr[((chararr_count += 1) - 1)] = RJava.cast_to_char(c)
        end
        while (count < utflen)
          c = RJava.cast_to_int(bytearr[count]) & 0xff
          case (c >> 4)
          when 0, 1, 2, 3, 4, 5, 6, 7
            # 0xxxxxxx
            count += 1
            chararr[((chararr_count += 1) - 1)] = RJava.cast_to_char(c)
          when 12, 13
            # 110x xxxx   10xx xxxx
            count += 2
            if (count > utflen)
              raise UTFDataFormatException.new("malformed input: partial character at end")
            end
            char2 = RJava.cast_to_int(bytearr[count - 1])
            if (!((char2 & 0xc0)).equal?(0x80))
              raise UTFDataFormatException.new("malformed input around byte " + RJava.cast_to_string(count))
            end
            chararr[((chararr_count += 1) - 1)] = RJava.cast_to_char((((c & 0x1f) << 6) | (char2 & 0x3f)))
          when 14
            # 1110 xxxx  10xx xxxx  10xx xxxx
            count += 3
            if (count > utflen)
              raise UTFDataFormatException.new("malformed input: partial character at end")
            end
            char2 = RJava.cast_to_int(bytearr[count - 2])
            char3 = RJava.cast_to_int(bytearr[count - 1])
            if ((!((char2 & 0xc0)).equal?(0x80)) || (!((char3 & 0xc0)).equal?(0x80)))
              raise UTFDataFormatException.new("malformed input around byte " + RJava.cast_to_string((count - 1)))
            end
            chararr[((chararr_count += 1) - 1)] = RJava.cast_to_char((((c & 0xf) << 12) | ((char2 & 0x3f) << 6) | ((char3 & 0x3f) << 0)))
          else
            # 10xx xxxx,  1111 xxxx
            raise UTFDataFormatException.new("malformed input around byte " + RJava.cast_to_string(count))
          end
        end
        # The number of chars produced may be less than utflen
        return String.new(chararr, 0, chararr_count)
      end
    }
    
    private
    alias_method :initialize__data_input_stream, :initialize
  end
  
end
