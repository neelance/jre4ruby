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
  module InputStreamReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Sun::Nio::Cs, :StreamDecoder
    }
  end
  
  # An InputStreamReader is a bridge from byte streams to character streams: It
  # reads bytes and decodes them into characters using a specified {@link
  # java.nio.charset.Charset <code>charset</code>}.  The charset that it uses
  # may be specified by name or may be given explicitly, or the platform's
  # default charset may be accepted.
  # 
  # <p> Each invocation of one of an InputStreamReader's read() methods may
  # cause one or more bytes to be read from the underlying byte-input stream.
  # To enable the efficient conversion of bytes to characters, more bytes may
  # be read ahead from the underlying stream than are necessary to satisfy the
  # current read operation.
  # 
  # <p> For top efficiency, consider wrapping an InputStreamReader within a
  # BufferedReader.  For example:
  # 
  # <pre>
  # BufferedReader in
  #   = new BufferedReader(new InputStreamReader(System.in));
  # </pre>
  # 
  # @see BufferedReader
  # @see InputStream
  # @see java.nio.charset.Charset
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class InputStreamReader < InputStreamReaderImports.const_get :Reader
    include_class_members InputStreamReaderImports
    
    attr_accessor :sd
    alias_method :attr_sd, :sd
    undef_method :sd
    alias_method :attr_sd=, :sd=
    undef_method :sd=
    
    typesig { [InputStream] }
    # Creates an InputStreamReader that uses the default charset.
    # 
    # @param  in   An InputStream
    def initialize(in_)
      @sd = nil
      super(in_)
      begin
        @sd = StreamDecoder.for_input_stream_reader(in_, self, nil) # ## check lock object
      rescue UnsupportedEncodingException => e
        # The default encoding should always be available
        raise JavaError.new(e)
      end
    end
    
    typesig { [InputStream, String] }
    # Creates an InputStreamReader that uses the named charset.
    # 
    # @param  in
    #         An InputStream
    # 
    # @param  charsetName
    #         The name of a supported
    #         {@link java.nio.charset.Charset </code>charset<code>}
    # 
    # @exception  UnsupportedEncodingException
    #             If the named charset is not supported
    def initialize(in_, charset_name)
      @sd = nil
      super(in_)
      if ((charset_name).nil?)
        raise NullPointerException.new("charsetName")
      end
      @sd = StreamDecoder.for_input_stream_reader(in_, self, charset_name)
    end
    
    typesig { [InputStream, Charset] }
    # Creates an InputStreamReader that uses the given charset. </p>
    # 
    # @param  in       An InputStream
    # @param  cs       A charset
    # 
    # @since 1.4
    # @spec JSR-51
    def initialize(in_, cs)
      @sd = nil
      super(in_)
      if ((cs).nil?)
        raise NullPointerException.new("charset")
      end
      @sd = StreamDecoder.for_input_stream_reader(in_, self, cs)
    end
    
    typesig { [InputStream, CharsetDecoder] }
    # Creates an InputStreamReader that uses the given charset decoder.  </p>
    # 
    # @param  in       An InputStream
    # @param  dec      A charset decoder
    # 
    # @since 1.4
    # @spec JSR-51
    def initialize(in_, dec)
      @sd = nil
      super(in_)
      if ((dec).nil?)
        raise NullPointerException.new("charset decoder")
      end
      @sd = StreamDecoder.for_input_stream_reader(in_, self, dec)
    end
    
    typesig { [] }
    # Returns the name of the character encoding being used by this stream.
    # 
    # <p> If the encoding has an historical name then that name is returned;
    # otherwise the encoding's canonical name is returned.
    # 
    # <p> If this instance was created with the {@link
    # #InputStreamReader(InputStream, String)} constructor then the returned
    # name, being unique for the encoding, may differ from the name passed to
    # the constructor. This method will return <code>null</code> if the
    # stream has been closed.
    # </p>
    # @return The historical name of this encoding, or
    #         <code>null</code> if the stream has been closed
    # 
    # @see java.nio.charset.Charset
    # 
    # @revised 1.4
    # @spec JSR-51
    def get_encoding
      return @sd.get_encoding
    end
    
    typesig { [] }
    # Reads a single character.
    # 
    # @return The character read, or -1 if the end of the stream has been
    #         reached
    # 
    # @exception  IOException  If an I/O error occurs
    def read
      return @sd.read
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Reads characters into a portion of an array.
    # 
    # @param      cbuf     Destination buffer
    # @param      offset   Offset at which to start storing characters
    # @param      length   Maximum number of characters to read
    # 
    # @return     The number of characters read, or -1 if the end of the
    #             stream has been reached
    # 
    # @exception  IOException  If an I/O error occurs
    def read(cbuf, offset, length)
      return @sd.read(cbuf, offset, length)
    end
    
    typesig { [] }
    # Tells whether this stream is ready to be read.  An InputStreamReader is
    # ready if its input buffer is not empty, or if bytes are available to be
    # read from the underlying byte stream.
    # 
    # @exception  IOException  If an I/O error occurs
    def ready
      return @sd.ready
    end
    
    typesig { [] }
    def close
      @sd.close
    end
    
    private
    alias_method :initialize__input_stream_reader, :initialize
  end
  
end
