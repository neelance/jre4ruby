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
module Sun::Security::Util
  module DerValueImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :JavaDate
    }
  end
  
  # Represents a single DER-encoded value.  DER encoding rules are a subset
  # of the "Basic" Encoding Rules (BER), but they only support a single way
  # ("Definite" encoding) to encode any given value.
  # 
  # <P>All DER-encoded data are triples <em>{type, length, data}</em>.  This
  # class represents such tagged values as they have been read (or constructed),
  # and provides structured access to the encoded data.
  # 
  # <P>At this time, this class supports only a subset of the types of DER
  # data encodings which are defined.  That subset is sufficient for parsing
  # most X.509 certificates, and working with selected additional formats
  # (such as PKCS #10 certificate requests, and some kinds of PKCS #7 data).
  # 
  # A note with respect to T61/Teletex strings: From RFC 1617, section 4.1.3
  # and RFC 3280, section 4.1.2.4., we assume that this kind of string will
  # contain ISO-8859-1 characters only.
  # 
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class DerValue 
    include_class_members DerValueImports
    
    class_module.module_eval {
      # The tag class types
      const_set_lazy(:TAG_UNIVERSAL) { 0x0 }
      const_attr_reader  :TAG_UNIVERSAL
      
      const_set_lazy(:TAG_APPLICATION) { 0x40 }
      const_attr_reader  :TAG_APPLICATION
      
      const_set_lazy(:TAG_CONTEXT) { 0x80 }
      const_attr_reader  :TAG_CONTEXT
      
      const_set_lazy(:TAG_PRIVATE) { 0xc0 }
      const_attr_reader  :TAG_PRIVATE
    }
    
    # The DER tag of the value; one of the tag_ constants.
    attr_accessor :tag
    alias_method :attr_tag, :tag
    undef_method :tag
    alias_method :attr_tag=, :tag=
    undef_method :tag=
    
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # The DER-encoded data of the value.
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    class_module.module_eval {
      # The type starts at the first byte of the encoding, and
      # is one of these tag_* values.  That may be all the type
      # data that is needed.
      # 
      # 
      # These tags are the "universal" tags ... they mean the same
      # in all contexts.  (Mask with 0x1f -- five bits.)
      # 
      # Tag value indicating an ASN.1 "BOOLEAN" value.
      const_set_lazy(:Tag_Boolean) { 0x1 }
      const_attr_reader  :Tag_Boolean
      
      # Tag value indicating an ASN.1 "INTEGER" value.
      const_set_lazy(:Tag_Integer) { 0x2 }
      const_attr_reader  :Tag_Integer
      
      # Tag value indicating an ASN.1 "BIT STRING" value.
      const_set_lazy(:Tag_BitString) { 0x3 }
      const_attr_reader  :Tag_BitString
      
      # Tag value indicating an ASN.1 "OCTET STRING" value.
      const_set_lazy(:Tag_OctetString) { 0x4 }
      const_attr_reader  :Tag_OctetString
      
      # Tag value indicating an ASN.1 "NULL" value.
      const_set_lazy(:Tag_Null) { 0x5 }
      const_attr_reader  :Tag_Null
      
      # Tag value indicating an ASN.1 "OBJECT IDENTIFIER" value.
      const_set_lazy(:Tag_ObjectId) { 0x6 }
      const_attr_reader  :Tag_ObjectId
      
      # Tag value including an ASN.1 "ENUMERATED" value
      const_set_lazy(:Tag_Enumerated) { 0xa }
      const_attr_reader  :Tag_Enumerated
      
      # Tag value indicating an ASN.1 "UTF8String" value.
      const_set_lazy(:Tag_UTF8String) { 0xc }
      const_attr_reader  :Tag_UTF8String
      
      # Tag value including a "printable" string
      const_set_lazy(:Tag_PrintableString) { 0x13 }
      const_attr_reader  :Tag_PrintableString
      
      # Tag value including a "teletype" string
      const_set_lazy(:Tag_T61String) { 0x14 }
      const_attr_reader  :Tag_T61String
      
      # Tag value including an ASCII string
      const_set_lazy(:Tag_IA5String) { 0x16 }
      const_attr_reader  :Tag_IA5String
      
      # Tag value indicating an ASN.1 "UTCTime" value.
      const_set_lazy(:Tag_UtcTime) { 0x17 }
      const_attr_reader  :Tag_UtcTime
      
      # Tag value indicating an ASN.1 "GeneralizedTime" value.
      const_set_lazy(:Tag_GeneralizedTime) { 0x18 }
      const_attr_reader  :Tag_GeneralizedTime
      
      # Tag value indicating an ASN.1 "GenerallString" value.
      const_set_lazy(:Tag_GeneralString) { 0x1b }
      const_attr_reader  :Tag_GeneralString
      
      # Tag value indicating an ASN.1 "UniversalString" value.
      const_set_lazy(:Tag_UniversalString) { 0x1c }
      const_attr_reader  :Tag_UniversalString
      
      # Tag value indicating an ASN.1 "BMPString" value.
      const_set_lazy(:Tag_BMPString) { 0x1e }
      const_attr_reader  :Tag_BMPString
      
      # CONSTRUCTED seq/set
      # 
      # Tag value indicating an ASN.1
      # "SEQUENCE" (zero to N elements, order is significant).
      const_set_lazy(:Tag_Sequence) { 0x30 }
      const_attr_reader  :Tag_Sequence
      
      # Tag value indicating an ASN.1
      # "SEQUENCE OF" (one to N elements, order is significant).
      const_set_lazy(:Tag_SequenceOf) { 0x30 }
      const_attr_reader  :Tag_SequenceOf
      
      # Tag value indicating an ASN.1
      # "SET" (zero to N members, order does not matter).
      const_set_lazy(:Tag_Set) { 0x31 }
      const_attr_reader  :Tag_Set
      
      # Tag value indicating an ASN.1
      # "SET OF" (one to N members, order does not matter).
      const_set_lazy(:Tag_SetOf) { 0x31 }
      const_attr_reader  :Tag_SetOf
    }
    
    typesig { [] }
    # These values are the high order bits for the other kinds of tags.
    # 
    # 
    # Returns true if the tag class is UNIVERSAL.
    def is_universal
      return (((@tag & 0xc0)).equal?(0x0))
    end
    
    typesig { [] }
    # Returns true if the tag class is APPLICATION.
    def is_application
      return (((@tag & 0xc0)).equal?(0x40))
    end
    
    typesig { [] }
    # Returns true iff the CONTEXT SPECIFIC bit is set in the type tag.
    # This is associated with the ASN.1 "DEFINED BY" syntax.
    def is_context_specific
      return (((@tag & 0xc0)).equal?(0x80))
    end
    
    typesig { [::Java::Byte] }
    # Returns true iff the CONTEXT SPECIFIC TAG matches the passed tag.
    def is_context_specific(cntxt_tag)
      if (!is_context_specific)
        return false
      end
      return (((@tag & 0x1f)).equal?(cntxt_tag))
    end
    
    typesig { [] }
    def is_private
      return (((@tag & 0xc0)).equal?(0xc0))
    end
    
    typesig { [] }
    # Returns true iff the CONSTRUCTED bit is set in the type tag.
    def is_constructed
      return (((@tag & 0x20)).equal?(0x20))
    end
    
    typesig { [::Java::Byte] }
    # Returns true iff the CONSTRUCTED TAG matches the passed tag.
    def is_constructed(constructed_tag)
      if (!is_constructed)
        return false
      end
      return (((@tag & 0x1f)).equal?(constructed_tag))
    end
    
    typesig { [String] }
    # Creates a PrintableString or UTF8string DER value from a string
    def initialize(value)
      @tag = 0
      @buffer = nil
      @data = nil
      @length = 0
      is_printable_string = true
      i = 0
      while i < value.length
        if (!is_printable_string_char(value.char_at(i)))
          is_printable_string = false
          break
        end
        i += 1
      end
      @data = init(is_printable_string ? Tag_PrintableString : Tag_UTF8String, value)
    end
    
    typesig { [::Java::Byte, String] }
    # Creates a string type DER value from a String object
    # @param stringTag the tag for the DER value to create
    # @param value the String object to use for the DER value
    def initialize(string_tag, value)
      @tag = 0
      @buffer = nil
      @data = nil
      @length = 0
      @data = init(string_tag, value)
    end
    
    typesig { [::Java::Byte, Array.typed(::Java::Byte)] }
    # Creates a DerValue from a tag and some DER-encoded data.
    # 
    # @param tag the DER type tag
    # @param data the DER-encoded data
    def initialize(tag, data)
      @tag = 0
      @buffer = nil
      @data = nil
      @length = 0
      @tag = tag
      @buffer = DerInputBuffer.new(data.clone)
      @length = data.attr_length
      @data = DerInputStream.new(@buffer)
      @data.mark(JavaInteger::MAX_VALUE)
    end
    
    typesig { [DerInputBuffer] }
    # package private
    def initialize(in_)
      @tag = 0
      @buffer = nil
      @data = nil
      @length = 0
      # XXX must also parse BER-encoded constructed
      # values such as sequences, sets...
      @tag = in_.read
      len_byte = in_.read
      @length = DerInputStream.get_length((len_byte & 0xff), in_)
      if ((@length).equal?(-1))
        # indefinite length encoding found
        inbuf = in_.dup
        read_len = inbuf.available
        offset = 2 # for tag and length bytes
        indef_data = Array.typed(::Java::Byte).new(read_len + offset) { 0 }
        indef_data[0] = @tag
        indef_data[1] = len_byte
        dis = DataInputStream.new(inbuf)
        dis.read_fully(indef_data, offset, read_len)
        dis.close
        der_in = DerIndefLenConverter.new
        inbuf = DerInputBuffer.new(der_in.convert(indef_data))
        if (!(@tag).equal?(inbuf.read))
          raise IOException.new("Indefinite length encoding not supported")
        end
        @length = DerInputStream.get_length(inbuf)
        @buffer = inbuf.dup
        @buffer.truncate(@length)
        @data = DerInputStream.new(@buffer)
        # indefinite form is encoded by sending a length field with a
        # length of 0. - i.e. [1000|0000].
        # the object is ended by sending two zero bytes.
        in_.skip(@length + offset)
      else
        @buffer = in_.dup
        @buffer.truncate(@length)
        @data = DerInputStream.new(@buffer)
        in_.skip(@length)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Get an ASN.1/DER encoded datum from a buffer.  The
    # entire buffer must hold exactly one datum, including
    # its tag and length.
    # 
    # @param buf buffer holding a single DER-encoded datum.
    def initialize(buf)
      @tag = 0
      @buffer = nil
      @data = nil
      @length = 0
      @data = init(true, ByteArrayInputStream.new(buf))
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Get an ASN.1/DER encoded datum from part of a buffer.
    # That part of the buffer must hold exactly one datum, including
    # its tag and length.
    # 
    # @param buf the buffer
    # @param offset start point of the single DER-encoded dataum
    # @param length how many bytes are in the encoded datum
    def initialize(buf, offset, len)
      @tag = 0
      @buffer = nil
      @data = nil
      @length = 0
      @data = init(true, ByteArrayInputStream.new(buf, offset, len))
    end
    
    typesig { [InputStream] }
    # Get an ASN1/DER encoded datum from an input stream.  The
    # stream may have additional data following the encoded datum.
    # In case of indefinite length encoded datum, the input stream
    # must hold only one datum.
    # 
    # @param in the input stream holding a single DER datum,
    # which may be followed by additional data
    def initialize(in_)
      @tag = 0
      @buffer = nil
      @data = nil
      @length = 0
      @data = init(false, in_)
    end
    
    typesig { [::Java::Byte, String] }
    def init(string_tag, value)
      enc = nil
      @tag = string_tag
      case (string_tag)
      # TBD: Need encoder for UniversalString before it can
      # be handled.
      when Tag_PrintableString, Tag_IA5String, Tag_GeneralString
        enc = "ASCII"
      when Tag_T61String
        enc = "ISO-8859-1"
      when Tag_BMPString
        enc = "UnicodeBigUnmarked"
      when Tag_UTF8String
        enc = "UTF8"
      else
        raise IllegalArgumentException.new("Unsupported DER string type")
      end
      buf = value.get_bytes(enc)
      @length = buf.attr_length
      @buffer = DerInputBuffer.new(buf)
      result = DerInputStream.new(@buffer)
      result.mark(JavaInteger::MAX_VALUE)
      return result
    end
    
    typesig { [::Java::Boolean, InputStream] }
    # helper routine
    def init(fully_buffered, in_)
      @tag = in_.read
      len_byte = in_.read
      @length = DerInputStream.get_length((len_byte & 0xff), in_)
      if ((@length).equal?(-1))
        # indefinite length encoding found
        read_len = in_.available
        offset = 2 # for tag and length bytes
        indef_data = Array.typed(::Java::Byte).new(read_len + offset) { 0 }
        indef_data[0] = @tag
        indef_data[1] = len_byte
        dis = DataInputStream.new(in_)
        dis.read_fully(indef_data, offset, read_len)
        dis.close
        der_in = DerIndefLenConverter.new
        in_ = ByteArrayInputStream.new(der_in.convert(indef_data))
        if (!(@tag).equal?(in_.read))
          raise IOException.new("Indefinite length encoding not supported")
        end
        @length = DerInputStream.get_length(in_)
      end
      if ((@length).equal?(0))
        return nil
      end
      if (fully_buffered && !(in_.available).equal?(@length))
        raise IOException.new("extra data given to DerValue constructor")
      end
      bytes = Array.typed(::Java::Byte).new(@length) { 0 }
      # n.b. readFully not needed in normal fullyBuffered case
      dis = DataInputStream.new(in_)
      dis.read_fully(bytes)
      @buffer = DerInputBuffer.new(bytes)
      return DerInputStream.new(@buffer)
    end
    
    typesig { [DerOutputStream] }
    # Encode an ASN1/DER encoded datum onto a DER output stream.
    def encode(out)
      out.write(@tag)
      out.put_length(@length)
      # XXX yeech, excess copies ... DerInputBuffer.write(OutStream)
      if (@length > 0)
        value = Array.typed(::Java::Byte).new(@length) { 0 }
        # always synchronized on data
        synchronized((@data)) do
          @buffer.reset
          if (!(@buffer.read(value)).equal?(@length))
            raise IOException.new("short DER value read (encode)")
          end
          out.write(value)
        end
      end
    end
    
    typesig { [] }
    def get_data
      return @data
    end
    
    typesig { [] }
    def get_tag
      return @tag
    end
    
    typesig { [] }
    # Returns an ASN.1 BOOLEAN
    # 
    # @return the boolean held in this DER value
    def get_boolean
      if (!(@tag).equal?(Tag_Boolean))
        raise IOException.new("DerValue.getBoolean, not a BOOLEAN " + RJava.cast_to_string(@tag))
      end
      if (!(@length).equal?(1))
        raise IOException.new("DerValue.getBoolean, invalid length " + RJava.cast_to_string(@length))
      end
      if (!(@buffer.read).equal?(0))
        return true
      end
      return false
    end
    
    typesig { [] }
    # Returns an ASN.1 OBJECT IDENTIFIER.
    # 
    # @return the OID held in this DER value
    def get_oid
      if (!(@tag).equal?(Tag_ObjectId))
        raise IOException.new("DerValue.getOID, not an OID " + RJava.cast_to_string(@tag))
      end
      return ObjectIdentifier.new(@buffer)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def append(a, b)
      if ((a).nil?)
        return b
      end
      ret = Array.typed(::Java::Byte).new(a.attr_length + b.attr_length) { 0 }
      System.arraycopy(a, 0, ret, 0, a.attr_length)
      System.arraycopy(b, 0, ret, a.attr_length, b.attr_length)
      return ret
    end
    
    typesig { [] }
    # Returns an ASN.1 OCTET STRING
    # 
    # @return the octet string held in this DER value
    def get_octet_string
      bytes = nil
      if (!(@tag).equal?(Tag_OctetString) && !is_constructed(Tag_OctetString))
        raise IOException.new("DerValue.getOctetString, not an Octet String: " + RJava.cast_to_string(@tag))
      end
      bytes = Array.typed(::Java::Byte).new(@length) { 0 }
      if (!(@buffer.read(bytes)).equal?(@length))
        raise IOException.new("short read on DerValue buffer")
      end
      if (is_constructed)
        in_ = DerInputStream.new(bytes)
        bytes = nil
        while (!(in_.available).equal?(0))
          bytes = append(bytes, in_.get_octet_string)
        end
      end
      return bytes
    end
    
    typesig { [] }
    # Returns an ASN.1 INTEGER value as an integer.
    # 
    # @return the integer held in this DER value.
    def get_integer
      if (!(@tag).equal?(Tag_Integer))
        raise IOException.new("DerValue.getInteger, not an int " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_integer(@data.available)
    end
    
    typesig { [] }
    # Returns an ASN.1 INTEGER value as a BigInteger.
    # 
    # @return the integer held in this DER value as a BigInteger.
    def get_big_integer
      if (!(@tag).equal?(Tag_Integer))
        raise IOException.new("DerValue.getBigInteger, not an int " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_big_integer(@data.available, false)
    end
    
    typesig { [] }
    # Returns an ASN.1 INTEGER value as a positive BigInteger.
    # This is just to deal with implementations that incorrectly encode
    # some values as negative.
    # 
    # @return the integer held in this DER value as a BigInteger.
    def get_positive_big_integer
      if (!(@tag).equal?(Tag_Integer))
        raise IOException.new("DerValue.getBigInteger, not an int " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_big_integer(@data.available, true)
    end
    
    typesig { [] }
    # Returns an ASN.1 ENUMERATED value.
    # 
    # @return the integer held in this DER value.
    def get_enumerated
      if (!(@tag).equal?(Tag_Enumerated))
        raise IOException.new("DerValue.getEnumerated, incorrect tag: " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_integer(@data.available)
    end
    
    typesig { [] }
    # Returns an ASN.1 BIT STRING value.  The bit string must be byte-aligned.
    # 
    # @return the bit string held in this value
    def get_bit_string
      if (!(@tag).equal?(Tag_BitString))
        raise IOException.new("DerValue.getBitString, not a bit string " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_bit_string
    end
    
    typesig { [] }
    # Returns an ASN.1 BIT STRING value that need not be byte-aligned.
    # 
    # @return a BitArray representing the bit string held in this value
    def get_unaligned_bit_string
      if (!(@tag).equal?(Tag_BitString))
        raise IOException.new("DerValue.getBitString, not a bit string " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_unaligned_bit_string
    end
    
    typesig { [] }
    # Returns the name component as a Java string, regardless of its
    # encoding restrictions (ASCII, T61, Printable, IA5, BMP, UTF8).
    # 
    # TBD: Need encoder for UniversalString before it can be handled.
    def get_as_string
      if ((@tag).equal?(Tag_UTF8String))
        return get_utf8string
      else
        if ((@tag).equal?(Tag_PrintableString))
          return get_printable_string
        else
          if ((@tag).equal?(Tag_T61String))
            return get_t61string
          else
            if ((@tag).equal?(Tag_IA5String))
              return get_ia5string
            # else if (tag == tag_UniversalString)
            # return getUniversalString();
            else
              if ((@tag).equal?(Tag_BMPString))
                return get_bmpstring
              else
                if ((@tag).equal?(Tag_GeneralString))
                  return get_general_string
                else
                  return nil
                end
              end
            end
          end
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Returns an ASN.1 BIT STRING value, with the tag assumed implicit
    # based on the parameter.  The bit string must be byte-aligned.
    # 
    # @params tagImplicit if true, the tag is assumed implicit.
    # @return the bit string held in this value
    def get_bit_string(tag_implicit)
      if (!tag_implicit)
        if (!(@tag).equal?(Tag_BitString))
          raise IOException.new("DerValue.getBitString, not a bit string " + RJava.cast_to_string(@tag))
        end
      end
      return @buffer.get_bit_string
    end
    
    typesig { [::Java::Boolean] }
    # Returns an ASN.1 BIT STRING value, with the tag assumed implicit
    # based on the parameter.  The bit string need not be byte-aligned.
    # 
    # @params tagImplicit if true, the tag is assumed implicit.
    # @return the bit string held in this value
    def get_unaligned_bit_string(tag_implicit)
      if (!tag_implicit)
        if (!(@tag).equal?(Tag_BitString))
          raise IOException.new("DerValue.getBitString, not a bit string " + RJava.cast_to_string(@tag))
        end
      end
      return @buffer.get_unaligned_bit_string
    end
    
    typesig { [] }
    # Helper routine to return all the bytes contained in the
    # DerInputStream associated with this object.
    def get_data_bytes
      ret_val = Array.typed(::Java::Byte).new(@length) { 0 }
      synchronized((@data)) do
        @data.reset
        @data.get_bytes(ret_val)
      end
      return ret_val
    end
    
    typesig { [] }
    # Returns an ASN.1 STRING value
    # 
    # @return the printable string held in this value
    def get_printable_string
      if (!(@tag).equal?(Tag_PrintableString))
        raise IOException.new("DerValue.getPrintableString, not a string " + RJava.cast_to_string(@tag))
      end
      return String.new(get_data_bytes, "ASCII")
    end
    
    typesig { [] }
    # Returns an ASN.1 T61 (Teletype) STRING value
    # 
    # @return the teletype string held in this value
    def get_t61string
      if (!(@tag).equal?(Tag_T61String))
        raise IOException.new("DerValue.getT61String, not T61 " + RJava.cast_to_string(@tag))
      end
      return String.new(get_data_bytes, "ISO-8859-1")
    end
    
    typesig { [] }
    # Returns an ASN.1 IA5 (ASCII) STRING value
    # 
    # @return the ASCII string held in this value
    def get_ia5string
      if (!(@tag).equal?(Tag_IA5String))
        raise IOException.new("DerValue.getIA5String, not IA5 " + RJava.cast_to_string(@tag))
      end
      return String.new(get_data_bytes, "ASCII")
    end
    
    typesig { [] }
    # Returns the ASN.1 BMP (Unicode) STRING value as a Java string.
    # 
    # @return a string corresponding to the encoded BMPString held in
    # this value
    def get_bmpstring
      if (!(@tag).equal?(Tag_BMPString))
        raise IOException.new("DerValue.getBMPString, not BMP " + RJava.cast_to_string(@tag))
      end
      # BMPString is the same as Unicode in big endian, unmarked
      # format.
      return String.new(get_data_bytes, "UnicodeBigUnmarked")
    end
    
    typesig { [] }
    # Returns the ASN.1 UTF-8 STRING value as a Java String.
    # 
    # @return a string corresponding to the encoded UTF8String held in
    # this value
    def get_utf8string
      if (!(@tag).equal?(Tag_UTF8String))
        raise IOException.new("DerValue.getUTF8String, not UTF-8 " + RJava.cast_to_string(@tag))
      end
      return String.new(get_data_bytes, "UTF8")
    end
    
    typesig { [] }
    # Returns the ASN.1 GENERAL STRING value as a Java String.
    # 
    # @return a string corresponding to the encoded GeneralString held in
    # this value
    def get_general_string
      if (!(@tag).equal?(Tag_GeneralString))
        raise IOException.new("DerValue.getGeneralString, not GeneralString " + RJava.cast_to_string(@tag))
      end
      return String.new(get_data_bytes, "ASCII")
    end
    
    typesig { [] }
    # Returns a Date if the DerValue is UtcTime.
    # 
    # @return the Date held in this DER value
    def get_utctime
      if (!(@tag).equal?(Tag_UtcTime))
        raise IOException.new("DerValue.getUTCTime, not a UtcTime: " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_utctime(@data.available)
    end
    
    typesig { [] }
    # Returns a Date if the DerValue is GeneralizedTime.
    # 
    # @return the Date held in this DER value
    def get_generalized_time
      if (!(@tag).equal?(Tag_GeneralizedTime))
        raise IOException.new("DerValue.getGeneralizedTime, not a GeneralizedTime: " + RJava.cast_to_string(@tag))
      end
      return @buffer.get_generalized_time(@data.available)
    end
    
    typesig { [Object] }
    # Returns true iff the other object is a DER value which
    # is bitwise equal to this one.
    # 
    # @param other the object being compared with this one
    def ==(other)
      if (other.is_a?(DerValue))
        return self.==(other)
      else
        return false
      end
    end
    
    typesig { [DerValue] }
    # Bitwise equality comparison.  DER encoded values have a single
    # encoding, so that bitwise equality of the encoded values is an
    # efficient way to establish equivalence of the unencoded values.
    # 
    # @param other the object being compared with this one
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if (!(@tag).equal?(other.attr_tag))
        return false
      end
      if ((@data).equal?(other.attr_data))
        return true
      end
      # make sure the order of lock is always consistent to avoid a deadlock
      return (System.identity_hash_code(@data) > System.identity_hash_code(other.attr_data)) ? do_equals(self, other) : do_equals(other, self)
    end
    
    class_module.module_eval {
      typesig { [DerValue, DerValue] }
      # Helper for public method equals()
      def do_equals(d1, d2)
        synchronized((d1.attr_data)) do
          synchronized((d2.attr_data)) do
            d1.attr_data.reset
            d2.attr_data.reset
            return (d1.attr_buffer == d2.attr_buffer)
          end
        end
      end
    }
    
    typesig { [] }
    # Returns a printable representation of the value.
    # 
    # @return printable representation of the value
    def to_s
      begin
        str = get_as_string
        if (!(str).nil?)
          return "\"" + str + "\""
        end
        if ((@tag).equal?(Tag_Null))
          return "[DerValue, null]"
        end
        if ((@tag).equal?(Tag_ObjectId))
          return "OID." + RJava.cast_to_string(get_oid)
        # integers
        else
          return "[DerValue, tag = " + RJava.cast_to_string(@tag) + ", length = " + RJava.cast_to_string(@length) + "]"
        end
      rescue IOException => e
        raise IllegalArgumentException.new("misformatted DER value")
      end
    end
    
    typesig { [] }
    # Returns a DER-encoded value, such that if it's passed to the
    # DerValue constructor, a value equivalent to "this" is returned.
    # 
    # @return DER-encoded value, including tag and length.
    def to_byte_array
      out = DerOutputStream.new
      encode(out)
      @data.reset
      return out.to_byte_array
    end
    
    typesig { [] }
    # For "set" and "sequence" types, this function may be used
    # to return a DER stream of the members of the set or sequence.
    # This operation is not supported for primitive types such as
    # integers or bit strings.
    def to_der_input_stream
      if ((@tag).equal?(Tag_Sequence) || (@tag).equal?(Tag_Set))
        return DerInputStream.new(@buffer)
      end
      raise IOException.new("toDerInputStream rejects tag type " + RJava.cast_to_string(@tag))
    end
    
    typesig { [] }
    # Get the length of the encoded value.
    def length
      return @length
    end
    
    class_module.module_eval {
      typesig { [::Java::Char] }
      # Determine if a character is one of the permissible characters for
      # PrintableString:
      # A-Z, a-z, 0-9, space, apostrophe (39), left and right parentheses,
      # plus sign, comma, hyphen, period, slash, colon, equals sign,
      # and question mark.
      # 
      # Characters that are *not* allowed in PrintableString include
      # exclamation point, quotation mark, number sign, dollar sign,
      # percent sign, ampersand, asterisk, semicolon, less than sign,
      # greater than sign, at sign, left and right square brackets,
      # backslash, circumflex (94), underscore, back quote (96),
      # left and right curly brackets, vertical line, tilde,
      # and the control codes (0-31 and 127).
      # 
      # This list is based on X.680 (the ASN.1 spec).
      def is_printable_string_char(ch)
        if ((ch >= Character.new(?a.ord) && ch <= Character.new(?z.ord)) || (ch >= Character.new(?A.ord) && ch <= Character.new(?Z.ord)) || (ch >= Character.new(?0.ord) && ch <= Character.new(?9.ord)))
          return true
        else
          case (ch)
          # space
          # apostrophe
          # left paren
          # right paren
          # plus
          # comma
          # hyphen
          # period
          # slash
          # colon
          # equals
          when Character.new(?\s.ord), Character.new(?\'.ord), Character.new(?(.ord), Character.new(?).ord), Character.new(?+.ord), Character.new(?,.ord), Character.new(?-.ord), Character.new(?..ord), Character.new(?/.ord), Character.new(?:.ord), Character.new(?=.ord), Character.new(??.ord)
            # question mark
            return true
          else
            return false
          end
        end
      end
      
      typesig { [::Java::Byte, ::Java::Boolean, ::Java::Byte] }
      # Create the tag of the attribute.
      # 
      # @params class the tag class type, one of UNIVERSAL, CONTEXT,
      # APPLICATION or PRIVATE
      # @params form if true, the value is constructed, otherwise it
      # is primitive.
      # @params val the tag value
      def create_tag(tag_class, form, val)
        tag = (tag_class | val)
        if (form)
          tag |= 0x20
        end
        return (tag)
      end
    }
    
    typesig { [::Java::Byte] }
    # Set the tag of the attribute. Commonly used to reset the
    # tag value used for IMPLICIT encodings.
    # 
    # @params tag the tag value
    def reset_tag(tag)
      @tag = tag
    end
    
    typesig { [] }
    # Returns a hashcode for this DerValue.
    # 
    # @return a hashcode for this DerValue.
    def hash_code
      return to_s.hash_code
    end
    
    private
    alias_method :initialize__der_value, :initialize
  end
  
end
