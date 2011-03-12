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
  module ByteArrayOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :Arrays
    }
  end
  
  # This class implements an output stream in which the data is
  # written into a byte array. The buffer automatically grows as data
  # is written to it.
  # The data can be retrieved using <code>toByteArray()</code> and
  # <code>toString()</code>.
  # <p>
  # Closing a <tt>ByteArrayOutputStream</tt> has no effect. The methods in
  # this class can be called after the stream has been closed without
  # generating an <tt>IOException</tt>.
  # 
  # @author  Arthur van Hoff
  # @since   JDK1.0
  class ByteArrayOutputStream < ByteArrayOutputStreamImports.const_get :OutputStream
    include_class_members ByteArrayOutputStreamImports
    
    # The buffer where data is stored.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # The number of valid bytes in the buffer.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [] }
    # Creates a new byte array output stream. The buffer capacity is
    # initially 32 bytes, though its size increases if necessary.
    def initialize
      initialize__byte_array_output_stream(32)
    end
    
    typesig { [::Java::Int] }
    # Creates a new byte array output stream, with a buffer capacity of
    # the specified size, in bytes.
    # 
    # @param   size   the initial size.
    # @exception  IllegalArgumentException if size is negative.
    def initialize(size)
      @buf = nil
      @count = 0
      super()
      if (size < 0)
        raise IllegalArgumentException.new("Negative initial size: " + RJava.cast_to_string(size))
      end
      @buf = Array.typed(::Java::Byte).new(size) { 0 }
    end
    
    typesig { [::Java::Int] }
    # Writes the specified byte to this byte array output stream.
    # 
    # @param   b   the byte to be written.
    def write(b)
      synchronized(self) do
        newcount = @count + 1
        if (newcount > @buf.attr_length)
          @buf = Arrays.copy_of(@buf, Math.max(@buf.attr_length << 1, newcount))
        end
        @buf[@count] = b
        @count = newcount
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes <code>len</code> bytes from the specified byte array
    # starting at offset <code>off</code> to this byte array output stream.
    # 
    # @param   b     the data.
    # @param   off   the start offset in the data.
    # @param   len   the number of bytes to write.
    def write(b, off, len)
      synchronized(self) do
        if ((off < 0) || (off > b.attr_length) || (len < 0) || ((off + len) > b.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return
          end
        end
        newcount = @count + len
        if (newcount > @buf.attr_length)
          @buf = Arrays.copy_of(@buf, Math.max(@buf.attr_length << 1, newcount))
        end
        System.arraycopy(b, off, @buf, @count, len)
        @count = newcount
      end
    end
    
    typesig { [OutputStream] }
    # Writes the complete contents of this byte array output stream to
    # the specified output stream argument, as if by calling the output
    # stream's write method using <code>out.write(buf, 0, count)</code>.
    # 
    # @param      out   the output stream to which to write the data.
    # @exception  IOException  if an I/O error occurs.
    def write_to(out)
      synchronized(self) do
        out.write(@buf, 0, @count)
      end
    end
    
    typesig { [] }
    # Resets the <code>count</code> field of this byte array output
    # stream to zero, so that all currently accumulated output in the
    # output stream is discarded. The output stream can be used again,
    # reusing the already allocated buffer space.
    # 
    # @see     java.io.ByteArrayInputStream#count
    def reset
      synchronized(self) do
        @count = 0
      end
    end
    
    typesig { [] }
    # Creates a newly allocated byte array. Its size is the current
    # size of this output stream and the valid contents of the buffer
    # have been copied into it.
    # 
    # @return  the current contents of this output stream, as a byte array.
    # @see     java.io.ByteArrayOutputStream#size()
    def to_byte_array
      synchronized(self) do
        return Arrays.copy_of(@buf, @count)
      end
    end
    
    typesig { [] }
    # Returns the current size of the buffer.
    # 
    # @return  the value of the <code>count</code> field, which is the number
    #          of valid bytes in this output stream.
    # @see     java.io.ByteArrayOutputStream#count
    def size
      synchronized(self) do
        return @count
      end
    end
    
    typesig { [] }
    # Converts the buffer's contents into a string decoding bytes using the
    # platform's default character set. The length of the new <tt>String</tt>
    # is a function of the character set, and hence may not be equal to the
    # size of the buffer.
    # 
    # <p> This method always replaces malformed-input and unmappable-character
    # sequences with the default replacement string for the platform's
    # default character set. The {@linkplain java.nio.charset.CharsetDecoder}
    # class should be used when more control over the decoding process is
    # required.
    # 
    # @return String decoded from the buffer's contents.
    # @since  JDK1.1
    def to_s
      synchronized(self) do
        return String.new(@buf, 0, @count)
      end
    end
    
    typesig { [String] }
    # Converts the buffer's contents into a string by decoding the bytes using
    # the specified {@link java.nio.charset.Charset charsetName}. The length of
    # the new <tt>String</tt> is a function of the charset, and hence may not be
    # equal to the length of the byte array.
    # 
    # <p> This method always replaces malformed-input and unmappable-character
    # sequences with this charset's default replacement string. The {@link
    # java.nio.charset.CharsetDecoder} class should be used when more control
    # over the decoding process is required.
    # 
    # @param  charsetName  the name of a supported
    #              {@linkplain java.nio.charset.Charset </code>charset<code>}
    # @return String decoded from the buffer's contents.
    # @exception  UnsupportedEncodingException
    #             If the named charset is not supported
    # @since   JDK1.1
    def to_s(charset_name)
      synchronized(self) do
        return String.new(@buf, 0, @count, charset_name)
      end
    end
    
    typesig { [::Java::Int] }
    # Creates a newly allocated string. Its size is the current size of
    # the output stream and the valid contents of the buffer have been
    # copied into it. Each character <i>c</i> in the resulting string is
    # constructed from the corresponding element <i>b</i> in the byte
    # array such that:
    # <blockquote><pre>
    #     c == (char)(((hibyte &amp; 0xff) &lt;&lt; 8) | (b &amp; 0xff))
    # </pre></blockquote>
    # 
    # @deprecated This method does not properly convert bytes into characters.
    # As of JDK&nbsp;1.1, the preferred way to do this is via the
    # <code>toString(String enc)</code> method, which takes an encoding-name
    # argument, or the <code>toString()</code> method, which uses the
    # platform's default character encoding.
    # 
    # @param      hibyte    the high byte of each resulting Unicode character.
    # @return     the current contents of the output stream, as a string.
    # @see        java.io.ByteArrayOutputStream#size()
    # @see        java.io.ByteArrayOutputStream#toString(String)
    # @see        java.io.ByteArrayOutputStream#toString()
    def to_s(hibyte)
      synchronized(self) do
        return String.new(@buf, hibyte, 0, @count)
      end
    end
    
    typesig { [] }
    # Closing a <tt>ByteArrayOutputStream</tt> has no effect. The methods in
    # this class can be called after the stream has been closed without
    # generating an <tt>IOException</tt>.
    # <p>
    def close
    end
    
    private
    alias_method :initialize__byte_array_output_stream, :initialize
  end
  
end
