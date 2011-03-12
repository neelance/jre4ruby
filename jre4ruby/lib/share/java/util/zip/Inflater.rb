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
  module InflaterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
    }
  end
  
  # This class provides support for general purpose decompression using the
  # popular ZLIB compression library. The ZLIB compression library was
  # initially developed as part of the PNG graphics standard and is not
  # protected by patents. It is fully described in the specifications at
  # the <a href="package-summary.html#package_description">java.util.zip
  # package description</a>.
  # 
  # <p>The following code fragment demonstrates a trivial compression
  # and decompression of a string using <tt>Deflater</tt> and
  # <tt>Inflater</tt>.
  # 
  # <blockquote><pre>
  # try {
  #     // Encode a String into bytes
  #     String inputString = "blahblahblah\u20AC\u20AC";
  #     byte[] input = inputString.getBytes("UTF-8");
  # 
  #     // Compress the bytes
  #     byte[] output = new byte[100];
  #     Deflater compresser = new Deflater();
  #     compresser.setInput(input);
  #     compresser.finish();
  #     int compressedDataLength = compresser.deflate(output);
  # 
  #     // Decompress the bytes
  #     Inflater decompresser = new Inflater();
  #     decompresser.setInput(output, 0, compressedDataLength);
  #     byte[] result = new byte[100];
  #     int resultLength = decompresser.inflate(result);
  #     decompresser.end();
  # 
  #     // Decode the bytes into a String
  #     String outputString = new String(result, 0, resultLength, "UTF-8");
  # } catch(java.io.UnsupportedEncodingException ex) {
  #     // handle
  # } catch (java.util.zip.DataFormatException ex) {
  #     // handle
  # }
  # </pre></blockquote>
  # 
  # @see         Deflater
  # @author      David Connelly
  class Inflater 
    include_class_members InflaterImports
    
    attr_accessor :strm
    alias_method :attr_strm, :strm
    undef_method :strm
    alias_method :attr_strm=, :strm=
    undef_method :strm=
    
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    attr_accessor :off
    alias_method :attr_off, :off
    undef_method :off
    alias_method :attr_off=, :off=
    undef_method :off=
    
    attr_accessor :len
    alias_method :attr_len, :len
    undef_method :len
    alias_method :attr_len=, :len=
    undef_method :len=
    
    attr_accessor :finished
    alias_method :attr_finished, :finished
    undef_method :finished
    alias_method :attr_finished=, :finished=
    undef_method :finished=
    
    attr_accessor :need_dict
    alias_method :attr_need_dict, :need_dict
    undef_method :need_dict
    alias_method :attr_need_dict=, :need_dict=
    undef_method :need_dict=
    
    class_module.module_eval {
      when_class_loaded do
        # Zip library is loaded from System.initializeSystemClass
        init_ids
      end
    }
    
    typesig { [::Java::Boolean] }
    # Creates a new decompressor. If the parameter 'nowrap' is true then
    # the ZLIB header and checksum fields will not be used. This provides
    # compatibility with the compression format used by both GZIP and PKZIP.
    # <p>
    # Note: When using the 'nowrap' option it is also necessary to provide
    # an extra "dummy" byte as input. This is required by the ZLIB native
    # library in order to support certain optimizations.
    # 
    # @param nowrap if true then support GZIP compatible compression
    def initialize(nowrap)
      @strm = 0
      @buf = Array.typed(::Java::Byte).new(0) { 0 }
      @off = 0
      @len = 0
      @finished = false
      @need_dict = false
      @strm = init(nowrap)
    end
    
    typesig { [] }
    # Creates a new decompressor.
    def initialize
      initialize__inflater(false)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Sets input data for decompression. Should be called whenever
    # needsInput() returns true indicating that more input data is
    # required.
    # @param b the input data bytes
    # @param off the start offset of the input data
    # @param len the length of the input data
    # @see Inflater#needsInput
    def set_input(b, off, len)
      synchronized(self) do
        if ((b).nil?)
          raise NullPointerException.new
        end
        if (off < 0 || len < 0 || off > b.attr_length - len)
          raise ArrayIndexOutOfBoundsException.new
        end
        @buf = b
        @off = off
        @len = len
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets input data for decompression. Should be called whenever
    # needsInput() returns true indicating that more input data is
    # required.
    # @param b the input data bytes
    # @see Inflater#needsInput
    def set_input(b)
      set_input(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Sets the preset dictionary to the given array of bytes. Should be
    # called when inflate() returns 0 and needsDictionary() returns true
    # indicating that a preset dictionary is required. The method getAdler()
    # can be used to get the Adler-32 value of the dictionary needed.
    # @param b the dictionary data bytes
    # @param off the start offset of the data
    # @param len the length of the data
    # @see Inflater#needsDictionary
    # @see Inflater#getAdler
    def set_dictionary(b, off, len)
      synchronized(self) do
        if ((@strm).equal?(0) || (b).nil?)
          raise NullPointerException.new
        end
        if (off < 0 || len < 0 || off > b.attr_length - len)
          raise ArrayIndexOutOfBoundsException.new
        end
        set_dictionary(@strm, b, off, len)
        @need_dict = false
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the preset dictionary to the given array of bytes. Should be
    # called when inflate() returns 0 and needsDictionary() returns true
    # indicating that a preset dictionary is required. The method getAdler()
    # can be used to get the Adler-32 value of the dictionary needed.
    # @param b the dictionary data bytes
    # @see Inflater#needsDictionary
    # @see Inflater#getAdler
    def set_dictionary(b)
      set_dictionary(b, 0, b.attr_length)
    end
    
    typesig { [] }
    # Returns the total number of bytes remaining in the input buffer.
    # This can be used to find out what bytes still remain in the input
    # buffer after decompression has finished.
    # @return the total number of bytes remaining in the input buffer
    def get_remaining
      synchronized(self) do
        return @len
      end
    end
    
    typesig { [] }
    # Returns true if no data remains in the input buffer. This can
    # be used to determine if #setInput should be called in order
    # to provide more input.
    # @return true if no data remains in the input buffer
    def needs_input
      synchronized(self) do
        return @len <= 0
      end
    end
    
    typesig { [] }
    # Returns true if a preset dictionary is needed for decompression.
    # @return true if a preset dictionary is needed for decompression
    # @see Inflater#setDictionary
    def needs_dictionary
      synchronized(self) do
        return @need_dict
      end
    end
    
    typesig { [] }
    # Returns true if the end of the compressed data stream has been
    # reached.
    # @return true if the end of the compressed data stream has been
    # reached
    def finished
      synchronized(self) do
        return @finished
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Uncompresses bytes into specified buffer. Returns actual number
    # of bytes uncompressed. A return value of 0 indicates that
    # needsInput() or needsDictionary() should be called in order to
    # determine if more input data or a preset dictionary is required.
    # In the latter case, getAdler() can be used to get the Adler-32
    # value of the dictionary required.
    # @param b the buffer for the uncompressed data
    # @param off the start offset of the data
    # @param len the maximum number of uncompressed bytes
    # @return the actual number of uncompressed bytes
    # @exception DataFormatException if the compressed data format is invalid
    # @see Inflater#needsInput
    # @see Inflater#needsDictionary
    def inflate(b, off, len)
      synchronized(self) do
        if ((b).nil?)
          raise NullPointerException.new
        end
        if (off < 0 || len < 0 || off > b.attr_length - len)
          raise ArrayIndexOutOfBoundsException.new
        end
        return inflate_bytes(b, off, len)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Uncompresses bytes into specified buffer. Returns actual number
    # of bytes uncompressed. A return value of 0 indicates that
    # needsInput() or needsDictionary() should be called in order to
    # determine if more input data or a preset dictionary is required.
    # In the latter case, getAdler() can be used to get the Adler-32
    # value of the dictionary required.
    # @param b the buffer for the uncompressed data
    # @return the actual number of uncompressed bytes
    # @exception DataFormatException if the compressed data format is invalid
    # @see Inflater#needsInput
    # @see Inflater#needsDictionary
    def inflate(b)
      return inflate(b, 0, b.attr_length)
    end
    
    typesig { [] }
    # Returns the ADLER-32 value of the uncompressed data.
    # @return the ADLER-32 value of the uncompressed data
    def get_adler
      synchronized(self) do
        ensure_open
        return get_adler(@strm)
      end
    end
    
    typesig { [] }
    # Returns the total number of compressed bytes input so far.
    # 
    # <p>Since the number of bytes may be greater than
    # Integer.MAX_VALUE, the {@link #getBytesRead()} method is now
    # the preferred means of obtaining this information.</p>
    # 
    # @return the total number of compressed bytes input so far
    def get_total_in
      return (get_bytes_read).to_int
    end
    
    typesig { [] }
    # Returns the total number of compressed bytes input so far.</p>
    # 
    # @return the total (non-negative) number of compressed bytes input so far
    # @since 1.5
    def get_bytes_read
      synchronized(self) do
        ensure_open
        return get_bytes_read(@strm)
      end
    end
    
    typesig { [] }
    # Returns the total number of uncompressed bytes output so far.
    # 
    # <p>Since the number of bytes may be greater than
    # Integer.MAX_VALUE, the {@link #getBytesWritten()} method is now
    # the preferred means of obtaining this information.</p>
    # 
    # @return the total number of uncompressed bytes output so far
    def get_total_out
      return (get_bytes_written).to_int
    end
    
    typesig { [] }
    # Returns the total number of uncompressed bytes output so far.</p>
    # 
    # @return the total (non-negative) number of uncompressed bytes output so far
    # @since 1.5
    def get_bytes_written
      synchronized(self) do
        ensure_open
        return get_bytes_written(@strm)
      end
    end
    
    typesig { [] }
    # Resets inflater so that a new set of input data can be processed.
    def reset
      synchronized(self) do
        ensure_open
        reset(@strm)
        @finished = false
        @need_dict = false
        @off = @len = 0
      end
    end
    
    typesig { [] }
    # Closes the decompressor and discards any unprocessed input.
    # This method should be called when the decompressor is no longer
    # being used, but will also be called automatically by the finalize()
    # method. Once this method is called, the behavior of the Inflater
    # object is undefined.
    def end_
      synchronized(self) do
        if (!(@strm).equal?(0))
          end_(@strm)
          @strm = 0
          @buf = nil
        end
      end
    end
    
    typesig { [] }
    # Closes the decompressor when garbage is collected.
    def finalize
      end_
    end
    
    typesig { [] }
    def ensure_open
      if ((@strm).equal?(0))
        raise NullPointerException.new
      end
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_util_zip_Inflater_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.call_native_method(:Java_java_util_zip_Inflater_initIDs, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_java_util_zip_Inflater_init, [:pointer, :long, :int8], :int64
      typesig { [::Java::Boolean] }
      def init(nowrap)
        JNI.call_native_method(:Java_java_util_zip_Inflater_init, JNI.env, self.jni_id, nowrap ? 1 : 0)
      end
      
      JNI.load_native_method :Java_java_util_zip_Inflater_setDictionary, [:pointer, :long, :int64, :long, :int32, :int32], :void
      typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def set_dictionary(strm, b, off, len)
        JNI.call_native_method(:Java_java_util_zip_Inflater_setDictionary, JNI.env, self.jni_id, strm.to_int, b.jni_id, off.to_int, len.to_int)
      end
    }
    
    JNI.load_native_method :Java_java_util_zip_Inflater_inflateBytes, [:pointer, :long, :long, :int32, :int32], :int32
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def inflate_bytes(b, off, len)
      JNI.call_native_method(:Java_java_util_zip_Inflater_inflateBytes, JNI.env, self.jni_id, b.jni_id, off.to_int, len.to_int)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_util_zip_Inflater_getAdler, [:pointer, :long, :int64], :int32
      typesig { [::Java::Long] }
      def get_adler(strm)
        JNI.call_native_method(:Java_java_util_zip_Inflater_getAdler, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.load_native_method :Java_java_util_zip_Inflater_getBytesRead, [:pointer, :long, :int64], :int64
      typesig { [::Java::Long] }
      def get_bytes_read(strm)
        JNI.call_native_method(:Java_java_util_zip_Inflater_getBytesRead, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.load_native_method :Java_java_util_zip_Inflater_getBytesWritten, [:pointer, :long, :int64], :int64
      typesig { [::Java::Long] }
      def get_bytes_written(strm)
        JNI.call_native_method(:Java_java_util_zip_Inflater_getBytesWritten, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.load_native_method :Java_java_util_zip_Inflater_reset, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def reset(strm)
        JNI.call_native_method(:Java_java_util_zip_Inflater_reset, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.load_native_method :Java_java_util_zip_Inflater_end, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def end_(strm)
        JNI.call_native_method(:Java_java_util_zip_Inflater_end, JNI.env, self.jni_id, strm.to_int)
      end
    }
    
    private
    alias_method :initialize__inflater, :initialize
  end
  
end
