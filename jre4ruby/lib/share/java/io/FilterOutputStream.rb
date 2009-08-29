require "rjava"

# Copyright 1994-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FilterOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # This class is the superclass of all classes that filter output
  # streams. These streams sit on top of an already existing output
  # stream (the <i>underlying</i> output stream) which it uses as its
  # basic sink of data, but possibly transforming the data along the
  # way or providing additional functionality.
  # <p>
  # The class <code>FilterOutputStream</code> itself simply overrides
  # all methods of <code>OutputStream</code> with versions that pass
  # all requests to the underlying output stream. Subclasses of
  # <code>FilterOutputStream</code> may further override some of these
  # methods as well as provide additional methods and fields.
  # 
  # @author  Jonathan Payne
  # @since   JDK1.0
  class FilterOutputStream < FilterOutputStreamImports.const_get :OutputStream
    include_class_members FilterOutputStreamImports
    
    # The underlying output stream to be filtered.
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    typesig { [OutputStream] }
    # Creates an output stream filter built on top of the specified
    # underlying output stream.
    # 
    # @param   out   the underlying output stream to be assigned to
    # the field <tt>this.out</tt> for later use, or
    # <code>null</code> if this instance is to be
    # created without an underlying stream.
    def initialize(out)
      @out = nil
      super()
      @out = out
    end
    
    typesig { [::Java::Int] }
    # Writes the specified <code>byte</code> to this output stream.
    # <p>
    # The <code>write</code> method of <code>FilterOutputStream</code>
    # calls the <code>write</code> method of its underlying output stream,
    # that is, it performs <tt>out.write(b)</tt>.
    # <p>
    # Implements the abstract <tt>write</tt> method of <tt>OutputStream</tt>.
    # 
    # @param      b   the <code>byte</code>.
    # @exception  IOException  if an I/O error occurs.
    def write(b)
      @out.write(b)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Writes <code>b.length</code> bytes to this output stream.
    # <p>
    # The <code>write</code> method of <code>FilterOutputStream</code>
    # calls its <code>write</code> method of three arguments with the
    # arguments <code>b</code>, <code>0</code>, and
    # <code>b.length</code>.
    # <p>
    # Note that this method does not call the one-argument
    # <code>write</code> method of its underlying stream with the single
    # argument <code>b</code>.
    # 
    # @param      b   the data to be written.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#write(byte[], int, int)
    def write(b)
      write(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes <code>len</code> bytes from the specified
    # <code>byte</code> array starting at offset <code>off</code> to
    # this output stream.
    # <p>
    # The <code>write</code> method of <code>FilterOutputStream</code>
    # calls the <code>write</code> method of one argument on each
    # <code>byte</code> to output.
    # <p>
    # Note that this method does not call the <code>write</code> method
    # of its underlying input stream with the same arguments. Subclasses
    # of <code>FilterOutputStream</code> should provide a more efficient
    # implementation of this method.
    # 
    # @param      b     the data.
    # @param      off   the start offset in the data.
    # @param      len   the number of bytes to write.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#write(int)
    def write(b, off, len)
      if ((off | len | (b.attr_length - (len + off)) | (off + len)) < 0)
        raise IndexOutOfBoundsException.new
      end
      i = 0
      while i < len
        write(b[off + i])
        i += 1
      end
    end
    
    typesig { [] }
    # Flushes this output stream and forces any buffered output bytes
    # to be written out to the stream.
    # <p>
    # The <code>flush</code> method of <code>FilterOutputStream</code>
    # calls the <code>flush</code> method of its underlying output stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#out
    def flush
      @out.flush
    end
    
    typesig { [] }
    # Closes this output stream and releases any system resources
    # associated with the stream.
    # <p>
    # The <code>close</code> method of <code>FilterOutputStream</code>
    # calls its <code>flush</code> method, and then calls the
    # <code>close</code> method of its underlying output stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FilterOutputStream#flush()
    # @see        java.io.FilterOutputStream#out
    def close
      begin
        flush
      rescue IOException => ignored
      end
      @out.close
    end
    
    private
    alias_method :initialize__filter_output_stream, :initialize
  end
  
end
