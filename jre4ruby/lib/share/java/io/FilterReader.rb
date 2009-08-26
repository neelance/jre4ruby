require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FilterReaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Abstract class for reading filtered character streams.
  # The abstract class <code>FilterReader</code> itself
  # provides default methods that pass all requests to
  # the contained stream. Subclasses of <code>FilterReader</code>
  # should override some of these methods and may also provide
  # additional methods and fields.
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class FilterReader < FilterReaderImports.const_get :Reader
    include_class_members FilterReaderImports
    
    # The underlying character-input stream.
    attr_accessor :in
    alias_method :attr_in, :in
    undef_method :in
    alias_method :attr_in=, :in=
    undef_method :in=
    
    typesig { [Reader] }
    # Creates a new filtered reader.
    # 
    # @param in  a Reader object providing the underlying stream.
    # @throws NullPointerException if <code>in</code> is <code>null</code>
    def initialize(in_)
      @in = nil
      super(in_)
      @in = in_
    end
    
    typesig { [] }
    # Reads a single character.
    # 
    # @exception  IOException  If an I/O error occurs
    def read
      return @in.read
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Reads characters into a portion of an array.
    # 
    # @exception  IOException  If an I/O error occurs
    def read(cbuf, off, len)
      return @in.read(cbuf, off, len)
    end
    
    typesig { [::Java::Long] }
    # Skips characters.
    # 
    # @exception  IOException  If an I/O error occurs
    def skip(n)
      return @in.skip(n)
    end
    
    typesig { [] }
    # Tells whether this stream is ready to be read.
    # 
    # @exception  IOException  If an I/O error occurs
    def ready
      return @in.ready
    end
    
    typesig { [] }
    # Tells whether this stream supports the mark() operation.
    def mark_supported
      return @in.mark_supported
    end
    
    typesig { [::Java::Int] }
    # Marks the present position in the stream.
    # 
    # @exception  IOException  If an I/O error occurs
    def mark(read_ahead_limit)
      @in.mark(read_ahead_limit)
    end
    
    typesig { [] }
    # Resets the stream.
    # 
    # @exception  IOException  If an I/O error occurs
    def reset
      @in.reset
    end
    
    typesig { [] }
    def close
      @in.close
    end
    
    private
    alias_method :initialize__filter_reader, :initialize
  end
  
end