require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Http
  module PosterOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Http
      include ::Java::Io
      include ::Java::Net
    }
  end
  
  # Instances of this class are returned to applications for the purpose of
  # sending user data for a HTTP POST or PUT request. This class is used
  # when the content-length will be specified in the header of the request.
  # The semantics of ByteArrayOutputStream are extended so that
  # when close() is called, it is no longer possible to write
  # additional data to the stream. From this point the content length of
  # the request is fixed and cannot change.
  # 
  # @author Michael McMahon
  class PosterOutputStream < PosterOutputStreamImports.const_get :ByteArrayOutputStream
    include_class_members PosterOutputStreamImports
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    typesig { [] }
    # Creates a new output stream for POST user data
    def initialize
      @closed = false
      super(256)
    end
    
    typesig { [::Java::Int] }
    # Writes the specified byte to this output stream.
    # 
    # @param   b   the byte to be written.
    def write(b)
      synchronized(self) do
        if (@closed)
          return
        end
        super(b)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes <code>len</code> bytes from the specified byte array
    # starting at offset <code>off</code> to this output stream.
    # 
    # @param   b     the data.
    # @param   off   the start offset in the data.
    # @param   len   the number of bytes to write.
    def write(b, off, len)
      synchronized(self) do
        if (@closed)
          return
        end
        super(b, off, len)
      end
    end
    
    typesig { [] }
    # Resets the <code>count</code> field of this output
    # stream to zero, so that all currently accumulated output in the
    # ouput stream is discarded. The output stream can be used again,
    # reusing the already allocated buffer space. If the output stream
    # has been closed, then this method has no effect.
    # 
    # @see     java.io.ByteArrayInputStream#count
    def reset
      synchronized(self) do
        if (@closed)
          return
        end
        super
      end
    end
    
    typesig { [] }
    # After close() has been called, it is no longer possible to write
    # to this stream. Further calls to write will have no effect.
    def close
      synchronized(self) do
        @closed = true
        super
      end
    end
    
    private
    alias_method :initialize__poster_output_stream, :initialize
  end
  
end
