require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Zip
  module CheckedInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :FilterInputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # An input stream that also maintains a checksum of the data being read.
  # The checksum can then be used to verify the integrity of the input data.
  # 
  # @see         Checksum
  # @author      David Connelly
  class CheckedInputStream < CheckedInputStreamImports.const_get :FilterInputStream
    include_class_members CheckedInputStreamImports
    
    attr_accessor :cksum
    alias_method :attr_cksum, :cksum
    undef_method :cksum
    alias_method :attr_cksum=, :cksum=
    undef_method :cksum=
    
    typesig { [InputStream, Checksum] }
    # Creates an input stream using the specified Checksum.
    # @param in the input stream
    # @param cksum the Checksum
    def initialize(in_, cksum)
      @cksum = nil
      super(in_)
      @cksum = cksum
    end
    
    typesig { [] }
    # Reads a byte. Will block if no input is available.
    # @return the byte read, or -1 if the end of the stream is reached.
    # @exception IOException if an I/O error has occurred
    def read
      b = self.attr_in.read
      if (!(b).equal?(-1))
        @cksum.update(b)
      end
      return b
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads into an array of bytes. If <code>len</code> is not zero, the method
    # blocks until some input is available; otherwise, no
    # bytes are read and <code>0</code> is returned.
    # @param buf the buffer into which the data is read
    # @param off the start offset in the destination array <code>b</code>
    # @param len the maximum number of bytes read
    # @return    the actual number of bytes read, or -1 if the end
    # of the stream is reached.
    # @exception  NullPointerException If <code>buf</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>buf.length - off</code>
    # @exception IOException if an I/O error has occurred
    def read(buf, off, len)
      len = self.attr_in.read(buf, off, len)
      if (!(len).equal?(-1))
        @cksum.update(buf, off, len)
      end
      return len
    end
    
    typesig { [::Java::Long] }
    # Skips specified number of bytes of input.
    # @param n the number of bytes to skip
    # @return the actual number of bytes skipped
    # @exception IOException if an I/O error has occurred
    def skip(n)
      buf = Array.typed(::Java::Byte).new(512) { 0 }
      total = 0
      while (total < n)
        len = n - total
        len = read(buf, 0, len < buf.attr_length ? RJava.cast_to_int(len) : buf.attr_length)
        if ((len).equal?(-1))
          return total
        end
        total += len
      end
      return total
    end
    
    typesig { [] }
    # Returns the Checksum for this input stream.
    # @return the Checksum value
    def get_checksum
      return @cksum
    end
    
    private
    alias_method :initialize__checked_input_stream, :initialize
  end
  
end
