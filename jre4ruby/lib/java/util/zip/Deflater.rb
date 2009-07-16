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
  module DeflaterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
    }
  end
  
  # 
  # This class provides support for general purpose compression using the
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
  # // Encode a String into bytes
  # String inputString = "blahblahblah\u20AC\u20AC";
  # byte[] input = inputString.getBytes("UTF-8");
  # 
  # // Compress the bytes
  # byte[] output = new byte[100];
  # Deflater compresser = new Deflater();
  # compresser.setInput(input);
  # compresser.finish();
  # int compressedDataLength = compresser.deflate(output);
  # 
  # // Decompress the bytes
  # Inflater decompresser = new Inflater();
  # decompresser.setInput(output, 0, compressedDataLength);
  # byte[] result = new byte[100];
  # int resultLength = decompresser.inflate(result);
  # decompresser.end();
  # 
  # // Decode the bytes into a String
  # String outputString = new String(result, 0, resultLength, "UTF-8");
  # } catch(java.io.UnsupportedEncodingException ex) {
  # // handle
  # } catch (java.util.zip.DataFormatException ex) {
  # // handle
  # }
  # </pre></blockquote>
  # 
  # @see         Inflater
  # @author      David Connelly
  class Deflater 
    include_class_members DeflaterImports
    
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
    
    attr_accessor :level
    alias_method :attr_level, :level
    undef_method :level
    alias_method :attr_level=, :level=
    undef_method :level=
    
    attr_accessor :strategy
    alias_method :attr_strategy, :strategy
    undef_method :strategy
    alias_method :attr_strategy=, :strategy=
    undef_method :strategy=
    
    attr_accessor :set_params
    alias_method :attr_set_params, :set_params
    undef_method :set_params
    alias_method :attr_set_params=, :set_params=
    undef_method :set_params=
    
    attr_accessor :finish
    alias_method :attr_finish, :finish
    undef_method :finish
    alias_method :attr_finish=, :finish=
    undef_method :finish=
    
    attr_accessor :finished
    alias_method :attr_finished, :finished
    undef_method :finished
    alias_method :attr_finished=, :finished=
    undef_method :finished=
    
    class_module.module_eval {
      # 
      # Compression method for the deflate algorithm (the only one currently
      # supported).
      const_set_lazy(:DEFLATED) { 8 }
      const_attr_reader  :DEFLATED
      
      # 
      # Compression level for no compression.
      const_set_lazy(:NO_COMPRESSION) { 0 }
      const_attr_reader  :NO_COMPRESSION
      
      # 
      # Compression level for fastest compression.
      const_set_lazy(:BEST_SPEED) { 1 }
      const_attr_reader  :BEST_SPEED
      
      # 
      # Compression level for best compression.
      const_set_lazy(:BEST_COMPRESSION) { 9 }
      const_attr_reader  :BEST_COMPRESSION
      
      # 
      # Default compression level.
      const_set_lazy(:DEFAULT_COMPRESSION) { -1 }
      const_attr_reader  :DEFAULT_COMPRESSION
      
      # 
      # Compression strategy best used for data consisting mostly of small
      # values with a somewhat random distribution. Forces more Huffman coding
      # and less string matching.
      const_set_lazy(:FILTERED) { 1 }
      const_attr_reader  :FILTERED
      
      # 
      # Compression strategy for Huffman coding only.
      const_set_lazy(:HUFFMAN_ONLY) { 2 }
      const_attr_reader  :HUFFMAN_ONLY
      
      # 
      # Default compression strategy.
      const_set_lazy(:DEFAULT_STRATEGY) { 0 }
      const_attr_reader  :DEFAULT_STRATEGY
      
      when_class_loaded do
        # Zip library is loaded from System.initializeSystemClass
        init_ids
      end
    }
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # 
    # Creates a new compressor using the specified compression level.
    # If 'nowrap' is true then the ZLIB header and checksum fields will
    # not be used in order to support the compression format used in
    # both GZIP and PKZIP.
    # @param level the compression level (0-9)
    # @param nowrap if true then use GZIP compatible compression
    def initialize(level, nowrap)
      @strm = 0
      @buf = Array.typed(::Java::Byte).new(0) { 0 }
      @off = 0
      @len = 0
      @level = 0
      @strategy = 0
      @set_params = false
      @finish = false
      @finished = false
      @level = level
      @strategy = DEFAULT_STRATEGY
      @strm = init(level, DEFAULT_STRATEGY, nowrap)
    end
    
    typesig { [::Java::Int] }
    # 
    # Creates a new compressor using the specified compression level.
    # Compressed data will be generated in ZLIB format.
    # @param level the compression level (0-9)
    def initialize(level)
      initialize__deflater(level, false)
    end
    
    typesig { [] }
    # 
    # Creates a new compressor with the default compression level.
    # Compressed data will be generated in ZLIB format.
    def initialize
      initialize__deflater(DEFAULT_COMPRESSION, false)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Sets input data for compression. This should be called whenever
    # needsInput() returns true indicating that more input data is required.
    # @param b the input data bytes
    # @param off the start offset of the data
    # @param len the length of the data
    # @see Deflater#needsInput
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
    # 
    # Sets input data for compression. This should be called whenever
    # needsInput() returns true indicating that more input data is required.
    # @param b the input data bytes
    # @see Deflater#needsInput
    def set_input(b)
      set_input(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Sets preset dictionary for compression. A preset dictionary is used
    # when the history buffer can be predetermined. When the data is later
    # uncompressed with Inflater.inflate(), Inflater.getAdler() can be called
    # in order to get the Adler-32 value of the dictionary required for
    # decompression.
    # @param b the dictionary data bytes
    # @param off the start offset of the data
    # @param len the length of the data
    # @see Inflater#inflate
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
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Sets preset dictionary for compression. A preset dictionary is used
    # when the history buffer can be predetermined. When the data is later
    # uncompressed with Inflater.inflate(), Inflater.getAdler() can be called
    # in order to get the Adler-32 value of the dictionary required for
    # decompression.
    # @param b the dictionary data bytes
    # @see Inflater#inflate
    # @see Inflater#getAdler
    def set_dictionary(b)
      set_dictionary(b, 0, b.attr_length)
    end
    
    typesig { [::Java::Int] }
    # 
    # Sets the compression strategy to the specified value.
    # @param strategy the new compression strategy
    # @exception IllegalArgumentException if the compression strategy is
    # invalid
    def set_strategy(strategy)
      synchronized(self) do
        case (strategy)
        when DEFAULT_STRATEGY, FILTERED, HUFFMAN_ONLY
        else
          raise IllegalArgumentException.new
        end
        if (!(@strategy).equal?(strategy))
          @strategy = strategy
          @set_params = true
        end
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Sets the current compression level to the specified value.
    # @param level the new compression level (0-9)
    # @exception IllegalArgumentException if the compression level is invalid
    def set_level(level)
      synchronized(self) do
        if ((level < 0 || level > 9) && !(level).equal?(DEFAULT_COMPRESSION))
          raise IllegalArgumentException.new("invalid compression level")
        end
        if (!(@level).equal?(level))
          @level = level
          @set_params = true
        end
      end
    end
    
    typesig { [] }
    # 
    # Returns true if the input data buffer is empty and setInput()
    # should be called in order to provide more input.
    # @return true if the input data buffer is empty and setInput()
    # should be called in order to provide more input
    def needs_input
      return @len <= 0
    end
    
    typesig { [] }
    # 
    # When called, indicates that compression should end with the current
    # contents of the input buffer.
    def finish
      synchronized(self) do
        @finish = true
      end
    end
    
    typesig { [] }
    # 
    # Returns true if the end of the compressed data output stream has
    # been reached.
    # @return true if the end of the compressed data output stream has
    # been reached
    def finished
      synchronized(self) do
        return @finished
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Fills specified buffer with compressed data. Returns actual number
    # of bytes of compressed data. A return value of 0 indicates that
    # needsInput() should be called in order to determine if more input
    # data is required.
    # @param b the buffer for the compressed data
    # @param off the start offset of the data
    # @param len the maximum number of bytes of compressed data
    # @return the actual number of bytes of compressed data
    def deflate(b, off, len)
      synchronized(self) do
        if ((b).nil?)
          raise NullPointerException.new
        end
        if (off < 0 || len < 0 || off > b.attr_length - len)
          raise ArrayIndexOutOfBoundsException.new
        end
        return deflate_bytes(b, off, len)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Fills specified buffer with compressed data. Returns actual number
    # of bytes of compressed data. A return value of 0 indicates that
    # needsInput() should be called in order to determine if more input
    # data is required.
    # @param b the buffer for the compressed data
    # @return the actual number of bytes of compressed data
    def deflate(b)
      return deflate(b, 0, b.attr_length)
    end
    
    typesig { [] }
    # 
    # Returns the ADLER-32 value of the uncompressed data.
    # @return the ADLER-32 value of the uncompressed data
    def get_adler
      synchronized(self) do
        ensure_open
        return get_adler(@strm)
      end
    end
    
    typesig { [] }
    # 
    # Returns the total number of uncompressed bytes input so far.
    # 
    # <p>Since the number of bytes may be greater than
    # Integer.MAX_VALUE, the {@link #getBytesRead()} method is now
    # the preferred means of obtaining this information.</p>
    # 
    # @return the total number of uncompressed bytes input so far
    def get_total_in
      return RJava.cast_to_int(get_bytes_read)
    end
    
    typesig { [] }
    # 
    # Returns the total number of uncompressed bytes input so far.</p>
    # 
    # @return the total (non-negative) number of uncompressed bytes input so far
    # @since 1.5
    def get_bytes_read
      synchronized(self) do
        ensure_open
        return get_bytes_read(@strm)
      end
    end
    
    typesig { [] }
    # 
    # Returns the total number of compressed bytes output so far.
    # 
    # <p>Since the number of bytes may be greater than
    # Integer.MAX_VALUE, the {@link #getBytesWritten()} method is now
    # the preferred means of obtaining this information.</p>
    # 
    # @return the total number of compressed bytes output so far
    def get_total_out
      return RJava.cast_to_int(get_bytes_written)
    end
    
    typesig { [] }
    # 
    # Returns the total number of compressed bytes output so far.</p>
    # 
    # @return the total (non-negative) number of compressed bytes output so far
    # @since 1.5
    def get_bytes_written
      synchronized(self) do
        ensure_open
        return get_bytes_written(@strm)
      end
    end
    
    typesig { [] }
    # 
    # Resets deflater so that a new set of input data can be processed.
    # Keeps current compression level and strategy settings.
    def reset
      synchronized(self) do
        ensure_open
        reset(@strm)
        @finish = false
        @finished = false
        @off = @len = 0
      end
    end
    
    typesig { [] }
    # 
    # Closes the compressor and discards any unprocessed input.
    # This method should be called when the compressor is no longer
    # being used, but will also be called automatically by the
    # finalize() method. Once this method is called, the behavior
    # of the Deflater object is undefined.
    def end
      synchronized(self) do
        if (!(@strm).equal?(0))
          end(@strm)
          @strm = 0
          @buf = nil
        end
      end
    end
    
    typesig { [] }
    # 
    # Closes the compressor when garbage is collected.
    def finalize
      end
    end
    
    typesig { [] }
    def ensure_open
      if ((@strm).equal?(0))
        raise NullPointerException.new
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_Deflater_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_java_util_zip_Deflater_initIDs, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_util_zip_Deflater_init, [:pointer, :long, :int32, :int32, :int8], :int64
      typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
      def init(level, strategy, nowrap)
        JNI.__send__(:Java_java_util_zip_Deflater_init, JNI.env, self.jni_id, level.to_int, strategy.to_int, nowrap ? 1 : 0)
      end
      
      JNI.native_method :Java_java_util_zip_Deflater_setDictionary, [:pointer, :long, :int64, :long, :int32, :int32], :void
      typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def set_dictionary(strm, b, off, len)
        JNI.__send__(:Java_java_util_zip_Deflater_setDictionary, JNI.env, self.jni_id, strm.to_int, b.jni_id, off.to_int, len.to_int)
      end
    }
    
    JNI.native_method :Java_java_util_zip_Deflater_deflateBytes, [:pointer, :long, :long, :int32, :int32], :int32
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def deflate_bytes(b, off, len)
      JNI.__send__(:Java_java_util_zip_Deflater_deflateBytes, JNI.env, self.jni_id, b.jni_id, off.to_int, len.to_int)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_Deflater_getAdler, [:pointer, :long, :int64], :int32
      typesig { [::Java::Long] }
      def get_adler(strm)
        JNI.__send__(:Java_java_util_zip_Deflater_getAdler, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_Deflater_getBytesRead, [:pointer, :long, :int64], :int64
      typesig { [::Java::Long] }
      def get_bytes_read(strm)
        JNI.__send__(:Java_java_util_zip_Deflater_getBytesRead, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_Deflater_getBytesWritten, [:pointer, :long, :int64], :int64
      typesig { [::Java::Long] }
      def get_bytes_written(strm)
        JNI.__send__(:Java_java_util_zip_Deflater_getBytesWritten, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_Deflater_reset, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def reset(strm)
        JNI.__send__(:Java_java_util_zip_Deflater_reset, JNI.env, self.jni_id, strm.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_Deflater_end, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def end(strm)
        JNI.__send__(:Java_java_util_zip_Deflater_end, JNI.env, self.jni_id, strm.to_int)
      end
    }
    
    private
    alias_method :initialize__deflater, :initialize
  end
  
end
