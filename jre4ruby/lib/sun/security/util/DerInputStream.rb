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
module Sun::Security::Util
  module DerInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Vector
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Io, :DataInputStream
    }
  end
  
  # 
  # A DER input stream, used for parsing ASN.1 DER-encoded data such as
  # that found in X.509 certificates.  DER is a subset of BER/1, which has
  # the advantage that it allows only a single encoding of primitive data.
  # (High level data such as dates still support many encodings.)  That is,
  # it uses the "Definite" Encoding Rules (DER) not the "Basic" ones (BER).
  # 
  # <P>Note that, like BER/1, DER streams are streams of explicitly
  # tagged data values.  Accordingly, this programming interface does
  # not expose any variant of the java.io.InputStream interface, since
  # that kind of input stream holds untagged data values and using that
  # I/O model could prevent correct parsing of the DER data.
  # 
  # <P>At this time, this class supports only a subset of the types of DER
  # data encodings which are defined.  That subset is sufficient for parsing
  # most X.509 certificates.
  # 
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class DerInputStream 
    include_class_members DerInputStreamImports
    
    # 
    # This version only supports fully buffered DER.  This is easy to
    # work with, though if large objects are manipulated DER becomes
    # awkward to deal with.  That's where BER is useful, since BER
    # handles streaming data relatively well.
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # The DER tag of the value; one of the tag_ constants.
    attr_accessor :tag
    alias_method :attr_tag, :tag
    undef_method :tag
    alias_method :attr_tag=, :tag=
    undef_method :tag=
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Create a DER input stream from a data buffer.  The buffer is not
    # copied, it is shared.  Accordingly, the buffer should be treated
    # as read-only.
    # 
    # @param data the buffer from which to create the string (CONSUMED)
    def initialize(data)
      @buffer = nil
      @tag = 0
      init(data, 0, data.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Create a DER input stream from part of a data buffer.
    # The buffer is not copied, it is shared.  Accordingly, the
    # buffer should be treated as read-only.
    # 
    # @param data the buffer from which to create the string (CONSUMED)
    # @param offset the first index of <em>data</em> which will
    # be read as DER input in the new stream
    # @param len how long a chunk of the buffer to use,
    # starting at "offset"
    def initialize(data, offset, len)
      @buffer = nil
      @tag = 0
      init(data, offset, len)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # private helper routine
    def init(data, offset, len)
      if ((offset + 2 > data.attr_length) || (offset + len > data.attr_length))
        raise IOException.new("Encoding bytes too short")
      end
      # check for indefinite length encoding
      if (DerIndefLenConverter.is_indefinite(data[offset + 1]))
        in_data = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(data, offset, in_data, 0, len)
        der_in = DerIndefLenConverter.new
        @buffer = DerInputBuffer.new(der_in.convert(in_data))
      else
        @buffer = DerInputBuffer.new(data, offset, len)
      end
      @buffer.mark(JavaInteger::MAX_VALUE)
    end
    
    typesig { [DerInputBuffer] }
    def initialize(buf)
      @buffer = nil
      @tag = 0
      @buffer = buf
      @buffer.mark(JavaInteger::MAX_VALUE)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # 
    # Creates a new DER input stream from part of this input stream.
    # 
    # @param len how long a chunk of the current input stream to use,
    # starting at the current position.
    # @param do_skip true if the existing data in the input stream should
    # be skipped.  If this value is false, the next data read
    # on this stream and the newly created stream will be the
    # same.
    def sub_stream(len, do_skip)
      newbuf = @buffer.dup
      newbuf.truncate(len)
      if (do_skip)
        @buffer.skip(len)
      end
      return DerInputStream.new(newbuf)
    end
    
    typesig { [] }
    # 
    # Return what has been written to this DerInputStream
    # as a byte array. Useful for debugging.
    def to_byte_array
      return @buffer.to_byte_array
    end
    
    typesig { [] }
    # 
    # PRIMITIVES -- these are "universal" ASN.1 simple types.
    # 
    # INTEGER, ENUMERATED, BIT STRING, OCTET STRING, NULL
    # OBJECT IDENTIFIER, SEQUENCE (OF), SET (OF)
    # UTF8String, PrintableString, T61String, IA5String, UTCTime,
    # GeneralizedTime, BMPString.
    # Note: UniversalString not supported till encoder is available.
    # 
    # 
    # Get an integer from the input stream as an integer.
    # 
    # @return the integer held in this DER input stream.
    def get_integer
      if (!(@buffer.read).equal?(DerValue.attr_tag_integer))
        raise IOException.new("DER input, Integer tag error")
      end
      return @buffer.get_integer(get_length(@buffer))
    end
    
    typesig { [] }
    # 
    # Get a integer from the input stream as a BigInteger object.
    # 
    # @return the integer held in this DER input stream.
    def get_big_integer
      if (!(@buffer.read).equal?(DerValue.attr_tag_integer))
        raise IOException.new("DER input, Integer tag error")
      end
      return @buffer.get_big_integer(get_length(@buffer), false)
    end
    
    typesig { [] }
    # 
    # Returns an ASN.1 INTEGER value as a positive BigInteger.
    # This is just to deal with implementations that incorrectly encode
    # some values as negative.
    # 
    # @return the integer held in this DER value as a BigInteger.
    def get_positive_big_integer
      if (!(@buffer.read).equal?(DerValue.attr_tag_integer))
        raise IOException.new("DER input, Integer tag error")
      end
      return @buffer.get_big_integer(get_length(@buffer), true)
    end
    
    typesig { [] }
    # 
    # Get an enumerated from the input stream.
    # 
    # @return the integer held in this DER input stream.
    def get_enumerated
      if (!(@buffer.read).equal?(DerValue.attr_tag_enumerated))
        raise IOException.new("DER input, Enumerated tag error")
      end
      return @buffer.get_integer(get_length(@buffer))
    end
    
    typesig { [] }
    # 
    # Get a bit string from the input stream. Padded bits (if any)
    # will be stripped off before the bit string is returned.
    def get_bit_string
      if (!(@buffer.read).equal?(DerValue.attr_tag_bit_string))
        raise IOException.new("DER input not an bit string")
      end
      return @buffer.get_bit_string(get_length(@buffer))
    end
    
    typesig { [] }
    # 
    # Get a bit string from the input stream.  The bit string need
    # not be byte-aligned.
    def get_unaligned_bit_string
      if (!(@buffer.read).equal?(DerValue.attr_tag_bit_string))
        raise IOException.new("DER input not a bit string")
      end
      length = get_length(@buffer) - 1
      # 
      # First byte = number of excess bits in the last octet of the
      # representation.
      valid_bits = length * 8 - @buffer.read
      repn = Array.typed(::Java::Byte).new(length) { 0 }
      if ((!(length).equal?(0)) && (!(@buffer.read(repn)).equal?(length)))
        raise IOException.new("short read of DER bit string")
      end
      return BitArray.new(valid_bits, repn)
    end
    
    typesig { [] }
    # 
    # Returns an ASN.1 OCTET STRING from the input stream.
    def get_octet_string
      if (!(@buffer.read).equal?(DerValue.attr_tag_octet_string))
        raise IOException.new("DER input not an octet string")
      end
      length = get_length(@buffer)
      retval = Array.typed(::Java::Byte).new(length) { 0 }
      if ((!(length).equal?(0)) && (!(@buffer.read(retval)).equal?(length)))
        raise IOException.new("short read of DER octet string")
      end
      return retval
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Returns the asked number of bytes from the input stream.
    def get_bytes(val)
      if ((!(val.attr_length).equal?(0)) && (!(@buffer.read(val)).equal?(val.attr_length)))
        raise IOException.new("short read of DER octet string")
      end
    end
    
    typesig { [] }
    # 
    # Reads an encoded null value from the input stream.
    def get_null
      if (!(@buffer.read).equal?(DerValue.attr_tag_null) || !(@buffer.read).equal?(0))
        raise IOException.new("getNull, bad data")
      end
    end
    
    typesig { [] }
    # 
    # Reads an X.200 style Object Identifier from the stream.
    def get_oid
      return ObjectIdentifier.new(self)
    end
    
    typesig { [::Java::Int] }
    # 
    # Return a sequence of encoded entities.  ASN.1 sequences are
    # ordered, and they are often used, like a "struct" in C or C++,
    # to group data values.  They may have optional or context
    # specific values.
    # 
    # @param startLen guess about how long the sequence will be
    # (used to initialize an auto-growing data structure)
    # @return array of the values in the sequence
    def get_sequence(start_len)
      @tag = @buffer.read
      if (!(@tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Sequence tag error")
      end
      return read_vector(start_len)
    end
    
    typesig { [::Java::Int] }
    # 
    # Return a set of encoded entities.  ASN.1 sets are unordered,
    # though DER may specify an order for some kinds of sets (such
    # as the attributes in an X.500 relative distinguished name)
    # to facilitate binary comparisons of encoded values.
    # 
    # @param startLen guess about how large the set will be
    # (used to initialize an auto-growing data structure)
    # @return array of the values in the sequence
    def get_set(start_len)
      @tag = @buffer.read
      if (!(@tag).equal?(DerValue.attr_tag_set))
        raise IOException.new("Set tag error")
      end
      return read_vector(start_len)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # 
    # Return a set of encoded entities.  ASN.1 sets are unordered,
    # though DER may specify an order for some kinds of sets (such
    # as the attributes in an X.500 relative distinguished name)
    # to facilitate binary comparisons of encoded values.
    # 
    # @param startLen guess about how large the set will be
    # (used to initialize an auto-growing data structure)
    # @param implicit if true tag is assumed implicit.
    # @return array of the values in the sequence
    def get_set(start_len, implicit)
      @tag = @buffer.read
      if (!implicit)
        if (!(@tag).equal?(DerValue.attr_tag_set))
          raise IOException.new("Set tag error")
        end
      end
      return (read_vector(start_len))
    end
    
    typesig { [::Java::Int] }
    # 
    # Read a "vector" of values ... set or sequence have the
    # same encoding, except for the initial tag, so both use
    # this same helper routine.
    def read_vector(start_len)
      newstr = nil
      len_byte = @buffer.read
      len = get_length((len_byte & 0xff), @buffer)
      if ((len).equal?(-1))
        # indefinite length encoding found
        read_len = @buffer.available
        offset = 2 # for tag and length bytes
        indef_data = Array.typed(::Java::Byte).new(read_len + offset) { 0 }
        indef_data[0] = @tag
        indef_data[1] = len_byte
        dis = DataInputStream.new(@buffer)
        dis.read_fully(indef_data, offset, read_len)
        dis.close
        der_in = DerIndefLenConverter.new
        @buffer = DerInputBuffer.new(der_in.convert(indef_data))
        if (!(@tag).equal?(@buffer.read))
          raise IOException.new("Indefinite length encoding" + " not supported")
        end
        len = DerInputStream.get_length(@buffer)
      end
      if ((len).equal?(0))
        # return empty array instead of null, which should be
        # used only for missing optionals
        return Array.typed(DerValue).new(0) { nil }
      end
      # 
      # Create a temporary stream from which to read the data,
      # unless it's not really needed.
      if ((@buffer.available).equal?(len))
        newstr = self
      else
        newstr = sub_stream(len, true)
      end
      # 
      # Pull values out of the stream.
      vec = Vector.new(start_len)
      value = nil
      begin
        value = DerValue.new(newstr.attr_buffer)
        vec.add_element(value)
      end while (newstr.available > 0)
      if (!(newstr.available).equal?(0))
        raise IOException.new("extra data at end of vector")
      end
      # 
      # Now stick them into the array we're returning.
      i = 0
      max = vec.size
      retval = Array.typed(DerValue).new(max) { nil }
      i = 0
      while i < max
        retval[i] = vec.element_at(i)
        ((i += 1) - 1)
      end
      return retval
    end
    
    typesig { [] }
    # 
    # Get a single DER-encoded value from the input stream.
    # It can often be useful to pull a value from the stream
    # and defer parsing it.  For example, you can pull a nested
    # sequence out with one call, and only examine its elements
    # later when you really need to.
    def get_der_value
      return DerValue.new(@buffer)
    end
    
    typesig { [] }
    # 
    # Read a string that was encoded as a UTF8String DER value.
    def get_utf8string
      return read_string(DerValue.attr_tag_utf8string, "UTF-8", "UTF8")
    end
    
    typesig { [] }
    # 
    # Read a string that was encoded as a PrintableString DER value.
    def get_printable_string
      return read_string(DerValue.attr_tag_printable_string, "Printable", "ASCII")
    end
    
    typesig { [] }
    # 
    # Read a string that was encoded as a T61String DER value.
    def get_t61string
      # 
      # Works for common characters between T61 and ASCII.
      return read_string(DerValue.attr_tag_t61string, "T61", "ISO-8859-1")
    end
    
    typesig { [] }
    # 
    # Read a string that was encoded as a IA5tring DER value.
    def get_ia5string
      return read_string(DerValue.attr_tag_ia5string, "IA5", "ASCII")
    end
    
    typesig { [] }
    # 
    # Read a string that was encoded as a BMPString DER value.
    def get_bmpstring
      return read_string(DerValue.attr_tag_bmpstring, "BMP", "UnicodeBigUnmarked")
    end
    
    typesig { [] }
    # 
    # Read a string that was encoded as a GeneralString DER value.
    def get_general_string
      return read_string(DerValue.attr_tag_general_string, "General", "ASCII")
    end
    
    typesig { [::Java::Byte, String, String] }
    # 
    # Private helper routine to read an encoded string from the input
    # stream.
    # @param stringTag the tag for the type of string to read
    # @param stringName a name to display in error messages
    # @param enc the encoder to use to interpret the data. Should
    # correspond to the stringTag above.
    def read_string(string_tag, string_name, enc)
      if (!(@buffer.read).equal?(string_tag))
        raise IOException.new("DER input not a " + string_name + " string")
      end
      length = get_length(@buffer)
      retval = Array.typed(::Java::Byte).new(length) { 0 }
      if ((!(length).equal?(0)) && (!(@buffer.read(retval)).equal?(length)))
        raise IOException.new("short read of DER " + string_name + " string")
      end
      return String.new(retval, enc)
    end
    
    typesig { [] }
    # 
    # Get a UTC encoded time value from the input stream.
    def get_utctime
      if (!(@buffer.read).equal?(DerValue.attr_tag_utc_time))
        raise IOException.new("DER input, UTCtime tag invalid ")
      end
      return @buffer.get_utctime(get_length(@buffer))
    end
    
    typesig { [] }
    # 
    # Get a Generalized encoded time value from the input stream.
    def get_generalized_time
      if (!(@buffer.read).equal?(DerValue.attr_tag_generalized_time))
        raise IOException.new("DER input, GeneralizedTime tag invalid ")
      end
      return @buffer.get_generalized_time(get_length(@buffer))
    end
    
    typesig { [] }
    # 
    # Get a byte from the input stream.
    # 
    # package private
    def get_byte
      return (0xff & @buffer.read)
    end
    
    typesig { [] }
    def peek_byte
      return @buffer.peek
    end
    
    typesig { [] }
    # package private
    def get_length
      return get_length(@buffer)
    end
    
    class_module.module_eval {
      typesig { [InputStream] }
      # 
      # Get a length from the input stream, allowing for at most 32 bits of
      # encoding to be used.  (Not the same as getting a tagged integer!)
      # 
      # @return the length or -1 if indefinite length found.
      # @exception IOException on parsing error or unsupported lengths.
      def get_length(in_)
        return get_length(in_.read, in_)
      end
      
      typesig { [::Java::Int, InputStream] }
      # 
      # Get a length from the input stream, allowing for at most 32 bits of
      # encoding to be used.  (Not the same as getting a tagged integer!)
      # 
      # @return the length or -1 if indefinite length found.
      # @exception IOException on parsing error or unsupported lengths.
      def get_length(len_byte, in_)
        value = 0
        tmp = 0
        tmp = len_byte
        if (((tmp & 0x80)).equal?(0x0))
          # short form, 1 byte datum
          value = tmp
        else
          # long form or indefinite
          tmp &= 0x7f
          # 
          # NOTE:  tmp == 0 indicates indefinite length encoded data.
          # tmp > 4 indicates more than 4Gb of data.
          if ((tmp).equal?(0))
            return -1
          end
          if (tmp < 0 || tmp > 4)
            raise IOException.new("DerInputStream.getLength(): lengthTag=" + (tmp).to_s + ", " + (((tmp < 0) ? "incorrect DER encoding." : "too big.")).to_s)
          end
          value = 0
          while tmp > 0
            value <<= 8
            value += 0xff & in_.read
            ((tmp -= 1) + 1)
          end
        end
        return value
      end
    }
    
    typesig { [::Java::Int] }
    # 
    # Mark the current position in the buffer, so that
    # a later call to <code>reset</code> will return here.
    def mark(value)
      @buffer.mark(value)
    end
    
    typesig { [] }
    # 
    # Return to the position of the last <code>mark</code>
    # call.  A mark is implicitly set at the beginning of
    # the stream when it is created.
    def reset
      @buffer.reset
    end
    
    typesig { [] }
    # 
    # Returns the number of bytes available for reading.
    # This is most useful for testing whether the stream is
    # empty.
    def available
      return @buffer.available
    end
    
    private
    alias_method :initialize__der_input_stream, :initialize
  end
  
end
