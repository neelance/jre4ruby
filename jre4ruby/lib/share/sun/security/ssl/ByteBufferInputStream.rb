require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module ByteBufferInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Nio
    }
  end
  
  # A simple InputStream which uses ByteBuffers as it's backing store.
  # <P>
  # The only IOException should come if the InputStream has been closed.
  # All other IOException should not occur because all the data is local.
  # Data reads on an exhausted ByteBuffer returns a -1.
  # 
  # @author  Brad Wetmore
  class ByteBufferInputStream < ByteBufferInputStreamImports.const_get :InputStream
    include_class_members ByteBufferInputStreamImports
    
    attr_accessor :bb
    alias_method :attr_bb, :bb
    undef_method :bb
    alias_method :attr_bb=, :bb=
    undef_method :bb=
    
    typesig { [ByteBuffer] }
    def initialize(bb)
      @bb = nil
      super()
      @bb = bb
    end
    
    typesig { [] }
    # Returns a byte from the ByteBuffer.
    # 
    # Increments position().
    def read
      if ((@bb).nil?)
        raise IOException.new("read on a closed InputStream")
      end
      if ((@bb.remaining).equal?(0))
        return -1
      end
      return @bb.get
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Returns a byte array from the ByteBuffer.
    # 
    # Increments position().
    def read(b)
      if ((@bb).nil?)
        raise IOException.new("read on a closed InputStream")
      end
      return read(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Returns a byte array from the ByteBuffer.
    # 
    # Increments position().
    def read(b, off, len)
      if ((@bb).nil?)
        raise IOException.new("read on a closed InputStream")
      end
      if ((b).nil?)
        raise NullPointerException.new
      else
        if ((off < 0) || (off > b.attr_length) || (len < 0) || ((off + len) > b.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
      end
      length = Math.min(@bb.remaining, len)
      if ((length).equal?(0))
        return -1
      end
      @bb.get(b, off, length)
      return length
    end
    
    typesig { [::Java::Long] }
    # Skips over and discards <code>n</code> bytes of data from this input
    # stream.
    def skip(n)
      if ((@bb).nil?)
        raise IOException.new("skip on a closed InputStream")
      end
      if (n <= 0)
        return 0
      end
      # ByteBuffers have at most an int, so lose the upper bits.
      # The contract allows this.
      n_int = (n).to_int
      skip = Math.min(@bb.remaining, n_int)
      @bb.position(@bb.position + skip)
      return n_int
    end
    
    typesig { [] }
    # Returns the number of bytes that can be read (or skipped over)
    # from this input stream without blocking by the next caller of a
    # method for this input stream.
    def available
      if ((@bb).nil?)
        raise IOException.new("available on a closed InputStream")
      end
      return @bb.remaining
    end
    
    typesig { [] }
    # Closes this input stream and releases any system resources associated
    # with the stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      @bb = nil
    end
    
    typesig { [::Java::Int] }
    # Marks the current position in this input stream.
    def mark(readlimit)
      synchronized(self) do
      end
    end
    
    typesig { [] }
    # Repositions this stream to the position at the time the
    # <code>mark</code> method was last called on this input stream.
    def reset
      synchronized(self) do
        raise IOException.new("mark/reset not supported")
      end
    end
    
    typesig { [] }
    # Tests if this input stream supports the <code>mark</code> and
    # <code>reset</code> methods.
    def mark_supported
      return false
    end
    
    private
    alias_method :initialize__byte_buffer_input_stream, :initialize
  end
  
end
