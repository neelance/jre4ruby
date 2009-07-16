require "rjava"

# 
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
  module DeflaterOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :FilterOutputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # 
  # This class implements an output stream filter for compressing data in
  # the "deflate" compression format. It is also used as the basis for other
  # types of compression filters, such as GZIPOutputStream.
  # 
  # @see         Deflater
  # @author      David Connelly
  class DeflaterOutputStream < DeflaterOutputStreamImports.const_get :FilterOutputStream
    include_class_members DeflaterOutputStreamImports
    
    # 
    # Compressor for this stream.
    attr_accessor :def
    alias_method :attr_def, :def
    undef_method :def
    alias_method :attr_def=, :def=
    undef_method :def=
    
    # 
    # Output buffer for writing compressed data.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # 
    # Indicates that the stream has been closed.
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    typesig { [OutputStream, Deflater, ::Java::Int] }
    # 
    # Creates a new output stream with the specified compressor and
    # buffer size.
    # @param out the output stream
    # @param def the compressor ("deflater")
    # @param size the output buffer size
    # @exception IllegalArgumentException if size is <= 0
    def initialize(out, def_, size)
      @def = nil
      @buf = nil
      @closed = false
      @uses_default_deflater = false
      super(out)
      @closed = false
      @uses_default_deflater = false
      if ((out).nil? || (def_).nil?)
        raise NullPointerException.new
      else
        if (size <= 0)
          raise IllegalArgumentException.new("buffer size <= 0")
        end
      end
      @def = def_
      @buf = Array.typed(::Java::Byte).new(size) { 0 }
    end
    
    typesig { [OutputStream, Deflater] }
    # 
    # Creates a new output stream with the specified compressor and
    # a default buffer size.
    # @param out the output stream
    # @param def the compressor ("deflater")
    def initialize(out, def_)
      initialize__deflater_output_stream(out, def_, 512)
    end
    
    attr_accessor :uses_default_deflater
    alias_method :attr_uses_default_deflater, :uses_default_deflater
    undef_method :uses_default_deflater
    alias_method :attr_uses_default_deflater=, :uses_default_deflater=
    undef_method :uses_default_deflater=
    
    typesig { [OutputStream] }
    # 
    # Creates a new output stream with a default compressor and buffer size.
    # @param out the output stream
    def initialize(out)
      initialize__deflater_output_stream(out, Deflater.new)
      @uses_default_deflater = true
    end
    
    typesig { [::Java::Int] }
    # 
    # Writes a byte to the compressed output stream. This method will
    # block until the byte can be written.
    # @param b the byte to be written
    # @exception IOException if an I/O error has occurred
    def write(b)
      buf = Array.typed(::Java::Byte).new(1) { 0 }
      buf[0] = (b & 0xff)
      write(buf, 0, 1)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Writes an array of bytes to the compressed output stream. This
    # method will block until all the bytes are written.
    # @param b the data to be written
    # @param off the start offset of the data
    # @param len the length of the data
    # @exception IOException if an I/O error has occurred
    def write(b, off, len)
      if (@def.finished)
        raise IOException.new("write beyond end of stream")
      end
      if ((off | len | (off + len) | (b.attr_length - (off + len))) < 0)
        raise IndexOutOfBoundsException.new
      else
        if ((len).equal?(0))
          return
        end
      end
      if (!@def.finished)
        # Deflate no more than stride bytes at a time.  This avoids
        # excess copying in deflateBytes (see Deflater.c)
        stride = @buf.attr_length
        i = 0
        while i < len
          @def.set_input(b, off + i, Math.min(stride, len - i))
          while (!@def.needs_input)
            deflate
          end
          i += stride
        end
      end
    end
    
    typesig { [] }
    # 
    # Finishes writing compressed data to the output stream without closing
    # the underlying stream. Use this method when applying multiple filters
    # in succession to the same output stream.
    # @exception IOException if an I/O error has occurred
    def finish
      if (!@def.finished)
        @def.finish
        while (!@def.finished)
          deflate
        end
      end
    end
    
    typesig { [] }
    # 
    # Writes remaining compressed data to the output stream and closes the
    # underlying stream.
    # @exception IOException if an I/O error has occurred
    def close
      if (!@closed)
        finish
        if (@uses_default_deflater)
          @def.end
        end
        self.attr_out.close
        @closed = true
      end
    end
    
    typesig { [] }
    # 
    # Writes next block of compressed data to the output stream.
    # @throws IOException if an I/O error has occurred
    def deflate
      len = @def.deflate(@buf, 0, @buf.attr_length)
      if (len > 0)
        self.attr_out.write(@buf, 0, len)
      end
    end
    
    private
    alias_method :initialize__deflater_output_stream, :initialize
  end
  
end
