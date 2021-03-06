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
module Java::Io
  module OutputStreamWriterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Sun::Nio::Cs, :StreamEncoder
    }
  end
  
  # An OutputStreamWriter is a bridge from character streams to byte streams:
  # Characters written to it are encoded into bytes using a specified {@link
  # java.nio.charset.Charset <code>charset</code>}.  The charset that it uses
  # may be specified by name or may be given explicitly, or the platform's
  # default charset may be accepted.
  # 
  # <p> Each invocation of a write() method causes the encoding converter to be
  # invoked on the given character(s).  The resulting bytes are accumulated in a
  # buffer before being written to the underlying output stream.  The size of
  # this buffer may be specified, but by default it is large enough for most
  # purposes.  Note that the characters passed to the write() methods are not
  # buffered.
  # 
  # <p> For top efficiency, consider wrapping an OutputStreamWriter within a
  # BufferedWriter so as to avoid frequent converter invocations.  For example:
  # 
  # <pre>
  # Writer out
  #   = new BufferedWriter(new OutputStreamWriter(System.out));
  # </pre>
  # 
  # <p> A <i>surrogate pair</i> is a character represented by a sequence of two
  # <tt>char</tt> values: A <i>high</i> surrogate in the range '&#92;uD800' to
  # '&#92;uDBFF' followed by a <i>low</i> surrogate in the range '&#92;uDC00' to
  # '&#92;uDFFF'.
  # 
  # <p> A <i>malformed surrogate element</i> is a high surrogate that is not
  # followed by a low surrogate or a low surrogate that is not preceded by a
  # high surrogate.
  # 
  # <p> This class always replaces malformed surrogate elements and unmappable
  # character sequences with the charset's default <i>substitution sequence</i>.
  # The {@linkplain java.nio.charset.CharsetEncoder} class should be used when more
  # control over the encoding process is required.
  # 
  # @see BufferedWriter
  # @see OutputStream
  # @see java.nio.charset.Charset
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class OutputStreamWriter < OutputStreamWriterImports.const_get :Writer
    include_class_members OutputStreamWriterImports
    
    attr_accessor :se
    alias_method :attr_se, :se
    undef_method :se
    alias_method :attr_se=, :se=
    undef_method :se=
    
    typesig { [OutputStream, String] }
    # Creates an OutputStreamWriter that uses the named charset.
    # 
    # @param  out
    #         An OutputStream
    # 
    # @param  charsetName
    #         The name of a supported
    #         {@link java.nio.charset.Charset </code>charset<code>}
    # 
    # @exception  UnsupportedEncodingException
    #             If the named encoding is not supported
    def initialize(out, charset_name)
      @se = nil
      super(out)
      if ((charset_name).nil?)
        raise NullPointerException.new("charsetName")
      end
      @se = StreamEncoder.for_output_stream_writer(out, self, charset_name)
    end
    
    typesig { [OutputStream] }
    # Creates an OutputStreamWriter that uses the default character encoding.
    # 
    # @param  out  An OutputStream
    def initialize(out)
      @se = nil
      super(out)
      begin
        @se = StreamEncoder.for_output_stream_writer(out, self, nil)
      rescue UnsupportedEncodingException => e
        raise JavaError.new(e)
      end
    end
    
    typesig { [OutputStream, Charset] }
    # Creates an OutputStreamWriter that uses the given charset. </p>
    # 
    # @param  out
    #         An OutputStream
    # 
    # @param  cs
    #         A charset
    # 
    # @since 1.4
    # @spec JSR-51
    def initialize(out, cs)
      @se = nil
      super(out)
      if ((cs).nil?)
        raise NullPointerException.new("charset")
      end
      @se = StreamEncoder.for_output_stream_writer(out, self, cs)
    end
    
    typesig { [OutputStream, CharsetEncoder] }
    # Creates an OutputStreamWriter that uses the given charset encoder.  </p>
    # 
    # @param  out
    #         An OutputStream
    # 
    # @param  enc
    #         A charset encoder
    # 
    # @since 1.4
    # @spec JSR-51
    def initialize(out, enc)
      @se = nil
      super(out)
      if ((enc).nil?)
        raise NullPointerException.new("charset encoder")
      end
      @se = StreamEncoder.for_output_stream_writer(out, self, enc)
    end
    
    typesig { [] }
    # Returns the name of the character encoding being used by this stream.
    # 
    # <p> If the encoding has an historical name then that name is returned;
    # otherwise the encoding's canonical name is returned.
    # 
    # <p> If this instance was created with the {@link
    # #OutputStreamWriter(OutputStream, String)} constructor then the returned
    # name, being unique for the encoding, may differ from the name passed to
    # the constructor.  This method may return <tt>null</tt> if the stream has
    # been closed. </p>
    # 
    # @return The historical name of this encoding, or possibly
    #         <code>null</code> if the stream has been closed
    # 
    # @see java.nio.charset.Charset
    # 
    # @revised 1.4
    # @spec JSR-51
    def get_encoding
      return @se.get_encoding
    end
    
    typesig { [] }
    # Flushes the output buffer to the underlying byte stream, without flushing
    # the byte stream itself.  This method is non-private only so that it may
    # be invoked by PrintStream.
    def flush_buffer
      @se.flush_buffer
    end
    
    typesig { [::Java::Int] }
    # Writes a single character.
    # 
    # @exception  IOException  If an I/O error occurs
    def write(c)
      @se.write(c)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Writes a portion of an array of characters.
    # 
    # @param  cbuf  Buffer of characters
    # @param  off   Offset from which to start writing characters
    # @param  len   Number of characters to write
    # 
    # @exception  IOException  If an I/O error occurs
    def write(cbuf, off, len)
      @se.write(cbuf, off, len)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Writes a portion of a string.
    # 
    # @param  str  A String
    # @param  off  Offset from which to start writing characters
    # @param  len  Number of characters to write
    # 
    # @exception  IOException  If an I/O error occurs
    def write(str, off, len)
      @se.write(str, off, len)
    end
    
    typesig { [] }
    # Flushes the stream.
    # 
    # @exception  IOException  If an I/O error occurs
    def flush
      @se.flush
    end
    
    typesig { [] }
    def close
      @se.close
    end
    
    private
    alias_method :initialize__output_stream_writer, :initialize
  end
  
end
