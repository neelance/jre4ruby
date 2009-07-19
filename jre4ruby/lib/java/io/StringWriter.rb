require "rjava"

# Copyright 1996-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module StringWriterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # A character stream that collects its output in a string buffer, which can
  # then be used to construct a string.
  # <p>
  # Closing a <tt>StringWriter</tt> has no effect. The methods in this class
  # can be called after the stream has been closed without generating an
  # <tt>IOException</tt>.
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class StringWriter < StringWriterImports.const_get :Writer
    include_class_members StringWriterImports
    
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    typesig { [] }
    # Create a new string writer using the default initial string-buffer
    # size.
    def initialize
      @buf = nil
      super()
      @buf = StringBuffer.new
      self.attr_lock = @buf
    end
    
    typesig { [::Java::Int] }
    # Create a new string writer using the specified initial string-buffer
    # size.
    # 
    # @param initialSize
    # The number of <tt>char</tt> values that will fit into this buffer
    # before it is automatically expanded
    # 
    # @throws IllegalArgumentException
    # If <tt>initialSize</tt> is negative
    def initialize(initial_size)
      @buf = nil
      super()
      if (initial_size < 0)
        raise IllegalArgumentException.new("Negative buffer size")
      end
      @buf = StringBuffer.new(initial_size)
      self.attr_lock = @buf
    end
    
    typesig { [::Java::Int] }
    # Write a single character.
    def write(c)
      @buf.append(RJava.cast_to_char(c))
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Write a portion of an array of characters.
    # 
    # @param  cbuf  Array of characters
    # @param  off   Offset from which to start writing characters
    # @param  len   Number of characters to write
    def write(cbuf, off, len)
      if ((off < 0) || (off > cbuf.attr_length) || (len < 0) || ((off + len) > cbuf.attr_length) || ((off + len) < 0))
        raise IndexOutOfBoundsException.new
      else
        if ((len).equal?(0))
          return
        end
      end
      @buf.append(cbuf, off, len)
    end
    
    typesig { [String] }
    # Write a string.
    def write(str)
      @buf.append(str)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Write a portion of a string.
    # 
    # @param  str  String to be written
    # @param  off  Offset from which to start writing characters
    # @param  len  Number of characters to write
    def write(str, off, len)
      @buf.append(str.substring(off, off + len))
    end
    
    typesig { [CharSequence] }
    # Appends the specified character sequence to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.write(csq.toString()) </pre>
    # 
    # <p> Depending on the specification of <tt>toString</tt> for the
    # character sequence <tt>csq</tt>, the entire sequence may not be
    # appended. For instance, invoking the <tt>toString</tt> method of a
    # character buffer will return a subsequence whose content depends upon
    # the buffer's position and limit.
    # 
    # @param  csq
    # The character sequence to append.  If <tt>csq</tt> is
    # <tt>null</tt>, then the four characters <tt>"null"</tt> are
    # appended to this writer.
    # 
    # @return  This writer
    # 
    # @since  1.5
    def append(csq)
      if ((csq).nil?)
        write("null")
      else
        write(csq.to_s)
      end
      return self
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    # Appends a subsequence of the specified character sequence to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq, start,
    # end)</tt> when <tt>csq</tt> is not <tt>null</tt>, behaves in
    # exactly the same way as the invocation
    # 
    # <pre>
    # out.write(csq.subSequence(start, end).toString()) </pre>
    # 
    # @param  csq
    # The character sequence from which a subsequence will be
    # appended.  If <tt>csq</tt> is <tt>null</tt>, then characters
    # will be appended as if <tt>csq</tt> contained the four
    # characters <tt>"null"</tt>.
    # 
    # @param  start
    # The index of the first character in the subsequence
    # 
    # @param  end
    # The index of the character following the last character in the
    # subsequence
    # 
    # @return  This writer
    # 
    # @throws  IndexOutOfBoundsException
    # If <tt>start</tt> or <tt>end</tt> are negative, <tt>start</tt>
    # is greater than <tt>end</tt>, or <tt>end</tt> is greater than
    # <tt>csq.length()</tt>
    # 
    # @since  1.5
    def append(csq, start, end_)
      cs = ((csq).nil? ? "null" : csq)
      write(cs.sub_sequence(start, end_).to_s)
      return self
    end
    
    typesig { [::Java::Char] }
    # Appends the specified character to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(c)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.write(c) </pre>
    # 
    # @param  c
    # The 16-bit character to append
    # 
    # @return  This writer
    # 
    # @since 1.5
    def append(c)
      write(c)
      return self
    end
    
    typesig { [] }
    # Return the buffer's current value as a string.
    def to_s
      return @buf.to_s
    end
    
    typesig { [] }
    # Return the string buffer itself.
    # 
    # @return StringBuffer holding the current buffer value.
    def get_buffer
      return @buf
    end
    
    typesig { [] }
    # Flush the stream.
    def flush
    end
    
    typesig { [] }
    # Closing a <tt>StringWriter</tt> has no effect. The methods in this
    # class can be called after the stream has been closed without generating
    # an <tt>IOException</tt>.
    def close
    end
    
    private
    alias_method :initialize__string_writer, :initialize
  end
  
end
