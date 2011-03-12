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
  module DerOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :FilterOutputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Text, :SimpleDateFormat
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :TimeZone
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :Arrays
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # Output stream marshaling DER-encoded data.  This is eventually provided
  # in the form of a byte array; there is no advance limit on the size of
  # that byte array.
  # 
  # <P>At this time, this class supports only a subset of the types of
  # DER data encodings which are defined.  That subset is sufficient for
  # generating most X.509 certificates.
  # 
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class DerOutputStream < DerOutputStreamImports.const_get :ByteArrayOutputStream
    include_class_members DerOutputStreamImports
    overload_protected {
      include DerEncoder
    }
    
    typesig { [::Java::Int] }
    # Construct an DER output stream.
    # 
    # @param size how large a buffer to preallocate.
    def initialize(size)
      super(size)
    end
    
    typesig { [] }
    # Construct an DER output stream.
    def initialize
      super()
    end
    
    typesig { [::Java::Byte, Array.typed(::Java::Byte)] }
    # Writes tagged, pre-marshaled data.  This calcuates and encodes
    # the length, so that the output data is the standard triple of
    # { tag, length, data } used by all DER values.
    # 
    # @param tag the DER value tag for the data, such as
    #          <em>DerValue.tag_Sequence</em>
    # @param buf buffered data, which must be DER-encoded
    def write(tag, buf)
      write(tag)
      put_length(buf.attr_length)
      write(buf, 0, buf.attr_length)
    end
    
    typesig { [::Java::Byte, DerOutputStream] }
    # Writes tagged data using buffer-to-buffer copy.  As above,
    # this writes a standard DER record.  This is often used when
    # efficiently encapsulating values in sequences.
    # 
    # @param tag the DER value tag for the data, such as
    #          <em>DerValue.tag_Sequence</em>
    # @param out buffered data
    def write(tag, out)
      write(tag)
      put_length(out.attr_count)
      write(out.attr_buf, 0, out.attr_count)
    end
    
    typesig { [::Java::Byte, DerOutputStream] }
    # Writes implicitly tagged data using buffer-to-buffer copy.  As above,
    # this writes a standard DER record.  This is often used when
    # efficiently encapsulating implicitly tagged values.
    # 
    # @param tag the DER value of the context-specific tag that replaces
    # original tag of the value in the output, such as in
    # <pre>
    #          <em> <field> [N] IMPLICIT <type></em>
    # </pre>
    # For example, <em>FooLength [1] IMPLICIT INTEGER</em>, with value=4;
    # would be encoded as "81 01 04"  whereas in explicit
    # tagging it would be encoded as "A1 03 02 01 04".
    # Notice that the tag is A1 and not 81, this is because with
    # explicit tagging the form is always constructed.
    # @param value original value being implicitly tagged
    def write_implicit(tag, value)
      write(tag)
      write(value.attr_buf, 1, value.attr_count - 1)
    end
    
    typesig { [DerValue] }
    # Marshals pre-encoded DER value onto the output stream.
    def put_der_value(val)
      val.encode(self)
    end
    
    typesig { [::Java::Boolean] }
    # PRIMITIVES -- these are "universal" ASN.1 simple types.
    # 
    #  BOOLEAN, INTEGER, BIT STRING, OCTET STRING, NULL
    #  OBJECT IDENTIFIER, SEQUENCE(OF), SET(OF)
    #  PrintableString, T61String, IA5String, UTCTime
    # Marshals a DER boolean on the output stream.
    def put_boolean(val)
      write(DerValue.attr_tag_boolean)
      put_length(1)
      if (val)
        write(0xff)
      else
        write(0)
      end
    end
    
    typesig { [::Java::Int] }
    # Marshals a DER enumerated on the output stream.
    # @param i the enumerated value.
    def put_enumerated(i)
      write(DerValue.attr_tag_enumerated)
      put_integer_contents(i)
    end
    
    typesig { [BigInteger] }
    # Marshals a DER integer on the output stream.
    # 
    # @param i the integer in the form of a BigInteger.
    def put_integer(i)
      write(DerValue.attr_tag_integer)
      buf = i.to_byte_array # least number  of bytes
      put_length(buf.attr_length)
      write(buf, 0, buf.attr_length)
    end
    
    typesig { [JavaInteger] }
    # Marshals a DER integer on the output stream.
    # @param i the integer in the form of an Integer.
    def put_integer(i)
      put_integer(i.int_value)
    end
    
    typesig { [::Java::Int] }
    # Marshals a DER integer on the output stream.
    # @param i the integer.
    def put_integer(i)
      write(DerValue.attr_tag_integer)
      put_integer_contents(i)
    end
    
    typesig { [::Java::Int] }
    def put_integer_contents(i)
      bytes = Array.typed(::Java::Byte).new(4) { 0 }
      start = 0
      # Obtain the four bytes of the int
      bytes[3] = (i & 0xff)
      bytes[2] = ((i & 0xff00) >> 8)
      bytes[1] = ((i & 0xff0000) >> 16)
      bytes[0] = ((i & -0x1000000) >> 24)
      # Reduce them to the least number of bytes needed to
      # represent this int
      if ((bytes[0]).equal?(0xff))
        # Eliminate redundant 0xff
        j = 0
        while j < 3
          if (((bytes[j]).equal?(0xff)) && (((bytes[j + 1] & 0x80)).equal?(0x80)))
            start += 1
          else
            break
          end
          j += 1
        end
      else
        if ((bytes[0]).equal?(0x0))
          # Eliminate redundant 0x00
          j = 0
          while j < 3
            if (((bytes[j]).equal?(0x0)) && (((bytes[j + 1] & 0x80)).equal?(0)))
              start += 1
            else
              break
            end
            j += 1
          end
        end
      end
      put_length(4 - start)
      k = start
      while k < 4
        write(bytes[k])
        k += 1
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Marshals a DER bit string on the output stream. The bit
    # string must be byte-aligned.
    # 
    # @param bits the bit string, MSB first
    def put_bit_string(bits)
      write(DerValue.attr_tag_bit_string)
      put_length(bits.attr_length + 1)
      write(0) # all of last octet is used
      write(bits)
    end
    
    typesig { [BitArray] }
    # Marshals a DER bit string on the output stream.
    # The bit strings need not be byte-aligned.
    # 
    # @param bits the bit string, MSB first
    def put_unaligned_bit_string(ba)
      bits = ba.to_byte_array
      write(DerValue.attr_tag_bit_string)
      put_length(bits.attr_length + 1)
      write(bits.attr_length * 8 - ba.length) # excess bits in last octet
      write(bits)
    end
    
    typesig { [BitArray] }
    # Marshals a truncated DER bit string on the output stream.
    # The bit strings need not be byte-aligned.
    # 
    # @param bits the bit string, MSB first
    def put_truncated_unaligned_bit_string(ba)
      put_unaligned_bit_string(ba.truncate)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # DER-encodes an ASN.1 OCTET STRING value on the output stream.
    # 
    # @param octets the octet string
    def put_octet_string(octets)
      write(DerValue.attr_tag_octet_string, octets)
    end
    
    typesig { [] }
    # Marshals a DER "null" value on the output stream.  These are
    # often used to indicate optional values which have been omitted.
    def put_null
      write(DerValue.attr_tag_null)
      put_length(0)
    end
    
    typesig { [ObjectIdentifier] }
    # Marshals an object identifier (OID) on the output stream.
    # Corresponds to the ASN.1 "OBJECT IDENTIFIER" construct.
    def put_oid(oid)
      oid.encode(self)
    end
    
    typesig { [Array.typed(DerValue)] }
    # Marshals a sequence on the output stream.  This supports both
    # the ASN.1 "SEQUENCE" (zero to N values) and "SEQUENCE OF"
    # (one to N values) constructs.
    def put_sequence(seq)
      bytes = DerOutputStream.new
      i = 0
      i = 0
      while i < seq.attr_length
        seq[i].encode(bytes)
        i += 1
      end
      write(DerValue.attr_tag_sequence, bytes)
    end
    
    typesig { [Array.typed(DerValue)] }
    # Marshals the contents of a set on the output stream without
    # ordering the elements.  Ok for BER encoding, but not for DER
    # encoding.
    # 
    # For DER encoding, use orderedPutSet() or orderedPutSetOf().
    def put_set(set)
      bytes = DerOutputStream.new
      i = 0
      i = 0
      while i < set.attr_length
        set[i].encode(bytes)
        i += 1
      end
      write(DerValue.attr_tag_set, bytes)
    end
    
    typesig { [::Java::Byte, Array.typed(DerEncoder)] }
    # Marshals the contents of a set on the output stream.  Sets
    # are semantically unordered, but DER requires that encodings of
    # set elements be sorted into ascending lexicographical order
    # before being output.  Hence sets with the same tags and
    # elements have the same DER encoding.
    # 
    # This method supports the ASN.1 "SET OF" construct, but not
    # "SET", which uses a different order.
    def put_ordered_set_of(tag, set)
      put_ordered_set(tag, set, self.attr_lex_order)
    end
    
    typesig { [::Java::Byte, Array.typed(DerEncoder)] }
    # Marshals the contents of a set on the output stream.  Sets
    # are semantically unordered, but DER requires that encodings of
    # set elements be sorted into ascending tag order
    # before being output.  Hence sets with the same tags and
    # elements have the same DER encoding.
    # 
    # This method supports the ASN.1 "SET" construct, but not
    # "SET OF", which uses a different order.
    def put_ordered_set(tag, set)
      put_ordered_set(tag, set, self.attr_tag_order)
    end
    
    class_module.module_eval {
      # Lexicographical order comparison on byte arrays, for ordering
      # elements of a SET OF objects in DER encoding.
      
      def lex_order
        defined?(@@lex_order) ? @@lex_order : @@lex_order= ByteArrayLexOrder.new
      end
      alias_method :attr_lex_order, :lex_order
      
      def lex_order=(value)
        @@lex_order = value
      end
      alias_method :attr_lex_order=, :lex_order=
      
      # Tag order comparison on byte arrays, for ordering elements of
      # SET objects in DER encoding.
      
      def tag_order
        defined?(@@tag_order) ? @@tag_order : @@tag_order= ByteArrayTagOrder.new
      end
      alias_method :attr_tag_order, :tag_order
      
      def tag_order=(value)
        @@tag_order = value
      end
      alias_method :attr_tag_order=, :tag_order=
    }
    
    typesig { [::Java::Byte, Array.typed(DerEncoder), Comparator] }
    # Marshals a the contents of a set on the output stream with the
    # encodings of its sorted in increasing order.
    # 
    # @param order the order to use when sorting encodings of components.
    def put_ordered_set(tag, set, order)
      streams = Array.typed(DerOutputStream).new(set.attr_length) { nil }
      i = 0
      while i < set.attr_length
        streams[i] = DerOutputStream.new
        set[i].der_encode(streams[i])
        i += 1
      end
      # order the element encodings
      bufs = Array.typed(Array.typed(::Java::Byte)).new(streams.attr_length) { nil }
      i_ = 0
      while i_ < streams.attr_length
        bufs[i_] = streams[i_].to_byte_array
        i_ += 1
      end
      Arrays.sort(bufs, order)
      bytes = DerOutputStream.new
      i__ = 0
      while i__ < streams.attr_length
        bytes.write(bufs[i__])
        i__ += 1
      end
      write(tag, bytes)
    end
    
    typesig { [String] }
    # Marshals a string as a DER encoded UTF8String.
    def put_utf8string(s)
      write_string(s, DerValue.attr_tag_utf8string, "UTF8")
    end
    
    typesig { [String] }
    # Marshals a string as a DER encoded PrintableString.
    def put_printable_string(s)
      write_string(s, DerValue.attr_tag_printable_string, "ASCII")
    end
    
    typesig { [String] }
    # Marshals a string as a DER encoded T61String.
    def put_t61string(s)
      # Works for characters that are defined in both ASCII and
      # T61.
      write_string(s, DerValue.attr_tag_t61string, "ISO-8859-1")
    end
    
    typesig { [String] }
    # Marshals a string as a DER encoded IA5String.
    def put_ia5string(s)
      write_string(s, DerValue.attr_tag_ia5string, "ASCII")
    end
    
    typesig { [String] }
    # Marshals a string as a DER encoded BMPString.
    def put_bmpstring(s)
      write_string(s, DerValue.attr_tag_bmpstring, "UnicodeBigUnmarked")
    end
    
    typesig { [String] }
    # Marshals a string as a DER encoded GeneralString.
    def put_general_string(s)
      write_string(s, DerValue.attr_tag_general_string, "ASCII")
    end
    
    typesig { [String, ::Java::Byte, String] }
    # Private helper routine for writing DER encoded string values.
    # @param s the string to write
    # @param stringTag one of the DER string tags that indicate which
    # encoding should be used to write the string out.
    # @param enc the name of the encoder that should be used corresponding
    # to the above tag.
    def write_string(s, string_tag, enc)
      data = s.get_bytes(enc)
      write(string_tag)
      put_length(data.attr_length)
      write(data)
    end
    
    typesig { [JavaDate] }
    # Marshals a DER UTC time/date value.
    # 
    # <P>YYMMDDhhmmss{Z|+hhmm|-hhmm} ... emits only using Zulu time
    # and with seconds (even if seconds=0) as per RFC 3280.
    def put_utctime(d)
      put_time(d, DerValue.attr_tag_utc_time)
    end
    
    typesig { [JavaDate] }
    # Marshals a DER Generalized Time/date value.
    # 
    # <P>YYYYMMDDhhmmss{Z|+hhmm|-hhmm} ... emits only using Zulu time
    # and with seconds (even if seconds=0) as per RFC 3280.
    def put_generalized_time(d)
      put_time(d, DerValue.attr_tag_generalized_time)
    end
    
    typesig { [JavaDate, ::Java::Byte] }
    # Private helper routine for marshalling a DER UTC/Generalized
    # time/date value. If the tag specified is not that for UTC Time
    # then it defaults to Generalized Time.
    # @param d the date to be marshalled
    # @param tag the tag for UTC Time or Generalized Time
    def put_time(d, tag)
      # Format the date.
      tz = TimeZone.get_time_zone("GMT")
      pattern = nil
      if ((tag).equal?(DerValue.attr_tag_utc_time))
        pattern = "yyMMddHHmmss'Z'"
      else
        tag = DerValue.attr_tag_generalized_time
        pattern = "yyyyMMddHHmmss'Z'"
      end
      sdf = SimpleDateFormat.new(pattern)
      sdf.set_time_zone(tz)
      time = (sdf.format(d)).get_bytes("ISO-8859-1")
      # Write the formatted date.
      write(tag)
      put_length(time.attr_length)
      write(time)
    end
    
    typesig { [::Java::Int] }
    # Put the encoding of the length in the stream.
    # 
    # @params len the length of the attribute.
    # @exception IOException on writing errors.
    def put_length(len)
      if (len < 128)
        write(len)
      else
        if (len < (1 << 8))
          write(0x81)
          write(len)
        else
          if (len < (1 << 16))
            write(0x82)
            write((len >> 8))
            write(len)
          else
            if (len < (1 << 24))
              write(0x83)
              write((len >> 16))
              write((len >> 8))
              write(len)
            else
              write(0x84)
              write((len >> 24))
              write((len >> 16))
              write((len >> 8))
              write(len)
            end
          end
        end
      end
    end
    
    typesig { [::Java::Byte, ::Java::Boolean, ::Java::Byte] }
    # Put the tag of the attribute in the stream.
    # 
    # @params class the tag class type, one of UNIVERSAL, CONTEXT,
    #                            APPLICATION or PRIVATE
    # @params form if true, the value is constructed, otherwise it is
    # primitive.
    # @params val the tag value
    def put_tag(tag_class, form, val)
      tag = (tag_class | val)
      if (form)
        tag |= 0x20
      end
      write(tag)
    end
    
    typesig { [OutputStream] }
    # Write the current contents of this <code>DerOutputStream</code>
    # to an <code>OutputStream</code>.
    # 
    # @exception IOException on output error.
    def der_encode(out)
      out.write(to_byte_array)
    end
    
    private
    alias_method :initialize__der_output_stream, :initialize
  end
  
end
