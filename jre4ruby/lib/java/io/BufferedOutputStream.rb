require "rjava"

# 
# Copyright 1994-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module BufferedOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # The class implements a buffered output stream. By setting up such
  # an output stream, an application can write bytes to the underlying
  # output stream without necessarily causing a call to the underlying
  # system for each byte written.
  # 
  # @author  Arthur van Hoff
  # @since   JDK1.0
  class BufferedOutputStream < BufferedOutputStreamImports.const_get :FilterOutputStream
    include_class_members BufferedOutputStreamImports
    
    # 
    # The internal buffer where data is stored.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # 
    # The number of valid bytes in the buffer. This value is always
    # in the range <tt>0</tt> through <tt>buf.length</tt>; elements
    # <tt>buf[0]</tt> through <tt>buf[count-1]</tt> contain valid
    # byte data.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [OutputStream] }
    # 
    # Creates a new buffered output stream to write data to the
    # specified underlying output stream.
    # 
    # @param   out   the underlying output stream.
    def initialize(out)
      initialize__buffered_output_stream(out, 8192)
    end
    
    typesig { [OutputStream, ::Java::Int] }
    # 
    # Creates a new buffered output stream to write data to the
    # specified underlying output stream with the specified buffer
    # size.
    # 
    # @param   out    the underlying output stream.
    # @param   size   the buffer size.
    # @exception IllegalArgumentException if size &lt;= 0.
    def initialize(out, size)
      @buf = nil
      @count = 0
      super(out)
      if (size <= 0)
        raise IllegalArgumentException.new("Buffer size <= 0")
      end
      @buf = Array.typed(::Java::Byte).new(size) { 0 }
    end
    
    typesig { [] }
    # Flush the internal buffer
    def flush_buffer
      if (@count > 0)
        self.attr_out.write(@buf, 0, @count)
        @count = 0
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Writes the specified byte to this buffered output stream.
    # 
    # @param      b   the byte to be written.
    # @exception  IOException  if an I/O error occurs.
    def write(b)
      synchronized(self) do
        if (@count >= @buf.attr_length)
          flush_buffer
        end
        @buf[((@count += 1) - 1)] = b
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Writes <code>len</code> bytes from the specified byte array
    # starting at offset <code>off</code> to this buffered output stream.
    # 
    # <p> Ordinarily this method stores bytes from the given array into this
    # stream's buffer, flushing the buffer to the underlying output stream as
    # needed.  If the requested length is at least as large as this stream's
    # buffer, however, then this method will flush the buffer and write the
    # bytes directly to the underlying output stream.  Thus redundant
    # <code>BufferedOutputStream</code>s will not copy data unnecessarily.
    # 
    # @param      b     the data.
    # @param      off   the start offset in the data.
    # @param      len   the number of bytes to write.
    # @exception  IOException  if an I/O error occurs.
    def write(b, off, len)
      synchronized(self) do
        if (len >= @buf.attr_length)
          # If the request length exceeds the size of the output buffer,
          # flush the output buffer and then write the data directly.
          # In this way buffered streams will cascade harmlessly.
          flush_buffer
          self.attr_out.write(b, off, len)
          return
        end
        if (len > @buf.attr_length - @count)
          flush_buffer
        end
        System.arraycopy(b, off, @buf, @count, len)
        @count += len
      end
    end
    
    typesig { [] }
    # 
    # Flushes this buffered output stream. This forces any buffered
    # output bytes to be written out to the underlying output stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def flush
      synchronized(self) do
        flush_buffer
        self.attr_out.flush
      end
    end
    
    private
    alias_method :initialize__buffered_output_stream, :initialize
  end
  
end
