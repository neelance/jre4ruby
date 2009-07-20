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
module Sun::Security::X509
  module AVAImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :Reader
      include_const ::Java::Security, :AccessController
      include_const ::Java::Text, :Normalizer
      include ::Java::Util
      include_const ::Sun::Security::Action, :GetBooleanAction
      include ::Sun::Security::Util
      include_const ::Sun::Security::Pkcs, :PKCS9Attribute
    }
  end
  
  # X.500 Attribute-Value-Assertion (AVA):  an attribute, as identified by
  # some attribute ID, has some particular value.  Values are as a rule ASN.1
  # printable strings.  A conventional set of type IDs is recognized when
  # parsing (and generating) RFC 1779 or RFC 2253 syntax strings.
  # 
  # <P>AVAs are components of X.500 relative names.  Think of them as being
  # individual fields of a database record.  The attribute ID is how you
  # identify the field, and the value is part of a particular record.
  # <p>
  # Note that instances of this class are immutable.
  # 
  # @see X500Name
  # @see RDN
  # 
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class AVA 
    include_class_members AVAImports
    include DerEncoder
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("x509", "\t[AVA]") }
      const_attr_reader  :Debug
      
      # See CR 6391482: if enabled this flag preserves the old but incorrect
      # PrintableString encoding for DomainComponent. It may need to be set to
      # avoid breaking preexisting certificates generated with sun.security APIs.
      const_set_lazy(:PRESERVE_OLD_DC_ENCODING) { AccessController.do_privileged(GetBooleanAction.new("com.sun.security.preserveOldDCEncoding")) }
      const_attr_reader  :PRESERVE_OLD_DC_ENCODING
      
      # DEFAULT format allows both RFC1779 and RFC2253 syntax and
      # additional keywords.
      const_set_lazy(:DEFAULT) { 1 }
      const_attr_reader  :DEFAULT
      
      # RFC1779 specifies format according to RFC1779.
      const_set_lazy(:RFC1779) { 2 }
      const_attr_reader  :RFC1779
      
      # RFC2253 specifies format according to RFC2253.
      const_set_lazy(:RFC2253) { 3 }
      const_attr_reader  :RFC2253
    }
    
    # currently not private, accessed directly from RDN
    attr_accessor :oid
    alias_method :attr_oid, :oid
    undef_method :oid
    alias_method :attr_oid=, :oid=
    undef_method :oid=
    
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    class_module.module_eval {
      # If the value has any of these characters in it, it must be quoted.
      # Backslash and quote characters must also be individually escaped.
      # Leading and trailing spaces, also multiple internal spaces, also
      # call for quoting the whole string.
      const_set_lazy(:SpecialChars) { ",+=\n<>#;" }
      const_attr_reader  :SpecialChars
      
      # In RFC2253, if the value has any of these characters in it, it
      # must be quoted by a preceding \.
      const_set_lazy(:SpecialChars2253) { ",+\"\\<>;" }
      const_attr_reader  :SpecialChars2253
      
      # includes special chars from RFC1779 and RFC2253, as well as ' '
      const_set_lazy(:SpecialCharsAll) { ",=\n+<>#;\\\" " }
      const_attr_reader  :SpecialCharsAll
      
      # Values that aren't printable strings are emitted as BER-encoded
      # hex data.
      const_set_lazy(:HexDigits) { "0123456789ABCDEF" }
      const_attr_reader  :HexDigits
    }
    
    typesig { [ObjectIdentifier, DerValue] }
    def initialize(type, val)
      @oid = nil
      @value = nil
      if (((type).nil?) || ((val).nil?))
        raise NullPointerException.new
      end
      @oid = type
      @value = val
    end
    
    typesig { [Reader] }
    # Parse an RFC 1779 or RFC 2253 style AVA string:  CN=fee fie foe fum
    # or perhaps with quotes.  Not all defined AVA tags are supported;
    # of current note are X.400 related ones (PRMD, ADMD, etc).
    # 
    # This terminates at unescaped AVA separators ("+") or RDN
    # separators (",", ";"), or DN terminators (">"), and removes
    # cosmetic whitespace at the end of values.
    def initialize(in_)
      initialize__ava(in_, DEFAULT)
    end
    
    typesig { [Reader, Map] }
    # Parse an RFC 1779 or RFC 2253 style AVA string:  CN=fee fie foe fum
    # or perhaps with quotes. Additional keywords can be specified in the
    # keyword/OID map.
    # 
    # This terminates at unescaped AVA separators ("+") or RDN
    # separators (",", ";"), or DN terminators (">"), and removes
    # cosmetic whitespace at the end of values.
    def initialize(in_, keyword_map)
      initialize__ava(in_, DEFAULT, keyword_map)
    end
    
    typesig { [Reader, ::Java::Int] }
    # Parse an AVA string formatted according to format.
    # 
    # XXX format RFC1779 should only allow RFC1779 syntax but is
    # actually DEFAULT with RFC1779 keywords.
    def initialize(in_, format)
      initialize__ava(in_, format, Collections.empty_map)
    end
    
    typesig { [Reader, ::Java::Int, Map] }
    # Parse an AVA string formatted according to format.
    # 
    # XXX format RFC1779 should only allow RFC1779 syntax but is
    # actually DEFAULT with RFC1779 keywords.
    # 
    # @param in Reader containing AVA String
    # @param format parsing format
    # @param keywordMap a Map where a keyword String maps to a corresponding
    # OID String. Each AVA keyword will be mapped to the corresponding OID.
    # If an entry does not exist, it will fallback to the builtin
    # keyword/OID mapping.
    # @throws IOException if the AVA String is not valid in the specified
    # standard or an OID String from the keywordMap is improperly formatted
    def initialize(in_, format, keyword_map)
      @oid = nil
      @value = nil
      # assume format is one of DEFAULT, RFC1779, RFC2253
      temp = StringBuilder.new
      c = 0
      # First get the keyword indicating the attribute's type,
      # and map it to the appropriate OID.
      while (true)
        c = read_char(in_, "Incorrect AVA format")
        if ((c).equal?(Character.new(?=.ord)))
          break
        end
        temp.append(RJava.cast_to_char(c))
      end
      @oid = AVAKeyword.get_oid(temp.to_s, format, keyword_map)
      # Now parse the value.  "#hex", a quoted string, or a string
      # terminated by "+", ",", ";", ">".  Whitespace before or after
      # the value is stripped away unless format is RFC2253.
      temp.set_length(0)
      if ((format).equal?(RFC2253))
        # read next character
        c = in_.read
        if ((c).equal?(Character.new(?\s.ord)))
          raise IOException.new("Incorrect AVA RFC2253 format - " + "leading space must be escaped")
        end
      else
        # read next character skipping whitespace
        begin
          c = in_.read
        end while (((c).equal?(Character.new(?\s.ord))) || ((c).equal?(Character.new(?\n.ord))))
      end
      if ((c).equal?(-1))
        # empty value
        @value = DerValue.new("")
        return
      end
      if ((c).equal?(Character.new(?#.ord)))
        @value = parse_hex_string(in_, format)
      else
        if (((c).equal?(Character.new(?".ord))) && (!(format).equal?(RFC2253)))
          @value = parse_quoted_string(in_, temp)
        else
          @value = parse_string(in_, c, format, temp)
        end
      end
    end
    
    typesig { [] }
    # Get the ObjectIdentifier of this AVA.
    def get_object_identifier
      return @oid
    end
    
    typesig { [] }
    # Get the value of this AVA as a DerValue.
    def get_der_value
      return @value
    end
    
    typesig { [] }
    # Get the value of this AVA as a String.
    # 
    # @exception RuntimeException if we could not obtain the string form
    # (should not occur)
    def get_value_string
      begin
        s = @value.get_as_string
        if ((s).nil?)
          raise RuntimeException.new("AVA string is null")
        end
        return s
      rescue IOException => e
        # should not occur
        raise RuntimeException.new("AVA error: " + (e).to_s, e)
      end
    end
    
    class_module.module_eval {
      typesig { [Reader, ::Java::Int] }
      def parse_hex_string(in_, format)
        c = 0
        baos = ByteArrayOutputStream.new
        b = 0
        c_ndx = 0
        while (true)
          c = in_.read
          if (is_terminator(c, format))
            break
          end
          c_val = HexDigits.index_of(Character.to_upper_case(RJava.cast_to_char(c)))
          if ((c_val).equal?(-1))
            raise IOException.new("AVA parse, invalid hex " + "digit: " + (RJava.cast_to_char(c)).to_s)
          end
          if (((c_ndx % 2)).equal?(1))
            b = ((b * 16) + (c_val))
            baos.write(b)
          else
            b = (c_val)
          end
          c_ndx += 1
        end
        # throw exception if no hex digits
        if ((c_ndx).equal?(0))
          raise IOException.new("AVA parse, zero hex digits")
        end
        # throw exception if odd number of hex digits
        if ((c_ndx % 2).equal?(1))
          raise IOException.new("AVA parse, odd number of hex digits")
        end
        return DerValue.new(baos.to_byte_array)
      end
    }
    
    typesig { [Reader, StringBuilder] }
    def parse_quoted_string(in_, temp)
      # RFC1779 specifies that an entire RDN may be enclosed in double
      # quotes. In this case the syntax is any sequence of
      # backslash-specialChar, backslash-backslash,
      # backslash-doublequote, or character other than backslash or
      # doublequote.
      c = read_char(in_, "Quoted string did not end in quote")
      embedded_hex = ArrayList.new
      is_printable_string = true
      while (!(c).equal?(Character.new(?".ord)))
        if ((c).equal?(Character.new(?\\.ord)))
          c = read_char(in_, "Quoted string did not end in quote")
          # check for embedded hex pairs
          hex_byte = nil
          if (!((hex_byte = get_embedded_hex_pair(c, in_))).nil?)
            # always encode AVAs with embedded hex as UTF8
            is_printable_string = false
            # append consecutive embedded hex
            # as single string later
            embedded_hex.add(hex_byte)
            c = in_.read
            next
          end
          if (!(c).equal?(Character.new(?\\.ord)) && !(c).equal?(Character.new(?".ord)) && SpecialChars.index_of(RJava.cast_to_char(c)) < 0)
            raise IOException.new("Invalid escaped character in AVA: " + (RJava.cast_to_char(c)).to_s)
          end
        end
        # add embedded hex bytes before next char
        if (embedded_hex.size > 0)
          hex_string = get_embedded_hex_string(embedded_hex)
          temp.append(hex_string)
          embedded_hex.clear
        end
        # check for non-PrintableString chars
        is_printable_string &= DerValue.is_printable_string_char(RJava.cast_to_char(c))
        temp.append(RJava.cast_to_char(c))
        c = read_char(in_, "Quoted string did not end in quote")
      end
      # add trailing embedded hex bytes
      if (embedded_hex.size > 0)
        hex_string = get_embedded_hex_string(embedded_hex)
        temp.append(hex_string)
        embedded_hex.clear
      end
      begin
        c = in_.read
      end while (((c).equal?(Character.new(?\n.ord))) || ((c).equal?(Character.new(?\s.ord))))
      if (!(c).equal?(-1))
        raise IOException.new("AVA had characters other than " + "whitespace after terminating quote")
      end
      # encode as PrintableString unless value contains
      # non-PrintableString chars
      if ((@oid == PKCS9Attribute::EMAIL_ADDRESS_OID) || ((@oid == X500Name::DOMAIN_COMPONENT_OID) && (PRESERVE_OLD_DC_ENCODING).equal?(false)))
        # EmailAddress and DomainComponent must be IA5String
        return DerValue.new(DerValue.attr_tag_ia5string, temp.to_s.trim)
      else
        if (is_printable_string)
          return DerValue.new(temp.to_s.trim)
        else
          return DerValue.new(DerValue.attr_tag_utf8string, temp.to_s.trim)
        end
      end
    end
    
    typesig { [Reader, ::Java::Int, ::Java::Int, StringBuilder] }
    def parse_string(in_, c, format, temp)
      embedded_hex = ArrayList.new
      is_printable_string = true
      escape = false
      leading_char = true
      space_count = 0
      begin
        escape = false
        if ((c).equal?(Character.new(?\\.ord)))
          escape = true
          c = read_char(in_, "Invalid trailing backslash")
          # check for embedded hex pairs
          hex_byte = nil
          if (!((hex_byte = get_embedded_hex_pair(c, in_))).nil?)
            # always encode AVAs with embedded hex as UTF8
            is_printable_string = false
            # append consecutive embedded hex
            # as single string later
            embedded_hex.add(hex_byte)
            c = in_.read
            leading_char = false
            next
          end
          # check if character was improperly escaped
          if (((format).equal?(DEFAULT) && (SpecialCharsAll.index_of(RJava.cast_to_char(c))).equal?(-1)) || ((format).equal?(RFC1779) && (SpecialChars.index_of(RJava.cast_to_char(c))).equal?(-1) && !(c).equal?(Character.new(?\\.ord)) && !(c).equal?(Character.new(?\".ord))))
            raise IOException.new("Invalid escaped character in AVA: '" + (RJava.cast_to_char(c)).to_s + "'")
          else
            if ((format).equal?(RFC2253))
              if ((c).equal?(Character.new(?\s.ord)))
                # only leading/trailing space can be escaped
                if (!leading_char && !trailing_space(in_))
                  raise IOException.new("Invalid escaped space character " + "in AVA.  Only a leading or trailing " + "space character can be escaped.")
                end
              else
                if ((c).equal?(Character.new(?#.ord)))
                  # only leading '#' can be escaped
                  if (!leading_char)
                    raise IOException.new("Invalid escaped '#' character in AVA.  " + "Only a leading '#' can be escaped.")
                  end
                else
                  if ((SpecialChars2253.index_of(RJava.cast_to_char(c))).equal?(-1))
                    raise IOException.new("Invalid escaped character in AVA: '" + (RJava.cast_to_char(c)).to_s + "'")
                  end
                end
              end
            end
          end
        else
          # check if character should have been escaped
          if ((format).equal?(RFC2253))
            if (!(SpecialChars2253.index_of(RJava.cast_to_char(c))).equal?(-1))
              raise IOException.new("Character '" + (RJava.cast_to_char(c)).to_s + "' in AVA appears without escape")
            end
          end
        end
        # add embedded hex bytes before next char
        if (embedded_hex.size > 0)
          # add space(s) before embedded hex bytes
          i = 0
          while i < space_count
            temp.append(" ")
            i += 1
          end
          space_count = 0
          hex_string = get_embedded_hex_string(embedded_hex)
          temp.append(hex_string)
          embedded_hex.clear
        end
        # check for non-PrintableString chars
        is_printable_string &= DerValue.is_printable_string_char(RJava.cast_to_char(c))
        if ((c).equal?(Character.new(?\s.ord)) && (escape).equal?(false))
          # do not add non-escaped spaces yet
          # (non-escaped trailing spaces are ignored)
          space_count += 1
        else
          # add space(s)
          i = 0
          while i < space_count
            temp.append(" ")
            i += 1
          end
          space_count = 0
          temp.append(RJava.cast_to_char(c))
        end
        c = in_.read
        leading_char = false
      end while ((is_terminator(c, format)).equal?(false))
      if ((format).equal?(RFC2253) && space_count > 0)
        raise IOException.new("Incorrect AVA RFC2253 format - " + "trailing space must be escaped")
      end
      # add trailing embedded hex bytes
      if (embedded_hex.size > 0)
        hex_string = get_embedded_hex_string(embedded_hex)
        temp.append(hex_string)
        embedded_hex.clear
      end
      # encode as PrintableString unless value contains
      # non-PrintableString chars
      if ((@oid == PKCS9Attribute::EMAIL_ADDRESS_OID) || ((@oid == X500Name::DOMAIN_COMPONENT_OID) && (PRESERVE_OLD_DC_ENCODING).equal?(false)))
        # EmailAddress and DomainComponent must be IA5String
        return DerValue.new(DerValue.attr_tag_ia5string, temp.to_s)
      else
        if (is_printable_string)
          return DerValue.new(temp.to_s)
        else
          return DerValue.new(DerValue.attr_tag_utf8string, temp.to_s)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Reader] }
      def get_embedded_hex_pair(c1, in_)
        if (HexDigits.index_of(Character.to_upper_case(RJava.cast_to_char(c1))) >= 0)
          c2 = read_char(in_, "unexpected EOF - " + "escaped hex value must include two valid digits")
          if (HexDigits.index_of(Character.to_upper_case(RJava.cast_to_char(c2))) >= 0)
            hi = Character.digit(RJava.cast_to_char(c1), 16)
            lo = Character.digit(RJava.cast_to_char(c2), 16)
            return Byte.new(((hi << 4) + lo))
          else
            raise IOException.new("escaped hex value must include two valid digits")
          end
        end
        return nil
      end
      
      typesig { [JavaList] }
      def get_embedded_hex_string(hex_list)
        n = hex_list.size
        hex_bytes = Array.typed(::Java::Byte).new(n) { 0 }
        i = 0
        while i < n
          hex_bytes[i] = hex_list.get(i).byte_value
          i += 1
        end
        return String.new(hex_bytes, "UTF8")
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def is_terminator(ch, format)
        case (ch)
        when -1, Character.new(?+.ord), Character.new(?,.ord)
          return true
        when Character.new(?;.ord), Character.new(?>.ord)
          return !(format).equal?(RFC2253)
        else
          return false
        end
      end
      
      typesig { [Reader, String] }
      def read_char(in_, err_msg)
        c = in_.read
        if ((c).equal?(-1))
          raise IOException.new(err_msg)
        end
        return c
      end
      
      typesig { [Reader] }
      def trailing_space(in_)
        trailing = false
        if (!in_.mark_supported)
          # oh well
          return true
        else
          # make readAheadLimit huge -
          # in practice, AVA was passed a StringReader from X500Name,
          # and StringReader ignores readAheadLimit anyways
          in_.mark(9999)
          while (true)
            next_char = in_.read
            if ((next_char).equal?(-1))
              trailing = true
              break
            else
              if ((next_char).equal?(Character.new(?\s.ord)))
                next
              else
                if ((next_char).equal?(Character.new(?\\.ord)))
                  following_char = in_.read
                  if (!(following_char).equal?(Character.new(?\s.ord)))
                    trailing = false
                    break
                  end
                else
                  trailing = false
                  break
                end
              end
            end
          end
          in_.reset
          return trailing
        end
      end
    }
    
    typesig { [DerValue] }
    def initialize(derval)
      @oid = nil
      @value = nil
      # Individual attribute value assertions are SEQUENCE of two values.
      # That'd be a "struct" outside of ASN.1.
      if (!(derval.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("AVA not a sequence")
      end
      @oid = X500Name.intern(derval.attr_data.get_oid)
      @value = derval.attr_data.get_der_value
      if (!(derval.attr_data.available).equal?(0))
        raise IOException.new("AVA, extra bytes = " + (derval.attr_data.available).to_s)
      end
    end
    
    typesig { [DerInputStream] }
    def initialize(in_)
      initialize__ava(in_.get_der_value)
    end
    
    typesig { [Object] }
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(AVA)).equal?(false))
        return false
      end
      other = obj
      return (self.to_rfc2253canonical_string == other.to_rfc2253canonical_string)
    end
    
    typesig { [] }
    # Returns a hashcode for this AVA.
    # 
    # @return a hashcode for this AVA.
    def hash_code
      return to_rfc2253canonical_string.hash_code
    end
    
    typesig { [DerOutputStream] }
    # AVAs are encoded as a SEQUENCE of two elements.
    def encode(out)
      der_encode(out)
    end
    
    typesig { [OutputStream] }
    # DER encode this object onto an output stream.
    # Implements the <code>DerEncoder</code> interface.
    # 
    # @param out
    # the output stream on which to write the DER encoding.
    # 
    # @exception IOException on encoding error.
    def der_encode(out)
      tmp = DerOutputStream.new
      tmp2 = DerOutputStream.new
      tmp.put_oid(@oid)
      @value.encode(tmp)
      tmp2.write(DerValue.attr_tag_sequence, tmp)
      out.write(tmp2.to_byte_array)
    end
    
    typesig { [::Java::Int, Map] }
    def to_keyword(format, oid_map)
      return AVAKeyword.get_keyword(@oid, format, oid_map)
    end
    
    typesig { [] }
    # Returns a printable form of this attribute, using RFC 1779
    # syntax for individual attribute/value assertions.
    def to_s
      return to_keyword_value_string(to_keyword(DEFAULT, Collections.empty_map))
    end
    
    typesig { [] }
    # Returns a printable form of this attribute, using RFC 1779
    # syntax for individual attribute/value assertions. It only
    # emits standardised keywords.
    def to_rfc1779string
      return to_rfc1779string(Collections.empty_map)
    end
    
    typesig { [Map] }
    # Returns a printable form of this attribute, using RFC 1779
    # syntax for individual attribute/value assertions. It
    # emits standardised keywords, as well as keywords contained in the
    # OID/keyword map.
    def to_rfc1779string(oid_map)
      return to_keyword_value_string(to_keyword(RFC1779, oid_map))
    end
    
    typesig { [] }
    # Returns a printable form of this attribute, using RFC 2253
    # syntax for individual attribute/value assertions. It only
    # emits standardised keywords.
    def to_rfc2253string
      return to_rfc2253string(Collections.empty_map)
    end
    
    typesig { [Map] }
    # Returns a printable form of this attribute, using RFC 2253
    # syntax for individual attribute/value assertions. It
    # emits standardised keywords, as well as keywords contained in the
    # OID/keyword map.
    def to_rfc2253string(oid_map)
      # Section 2.3: The AttributeTypeAndValue is encoded as the string
      # representation of the AttributeType, followed by an equals character
      # ('=' ASCII 61), followed by the string representation of the
      # AttributeValue. The encoding of the AttributeValue is given in
      # section 2.4.
      type_and_value = StringBuilder.new(100)
      type_and_value.append(to_keyword(RFC2253, oid_map))
      type_and_value.append(Character.new(?=.ord))
      # Section 2.4: Converting an AttributeValue from ASN.1 to a String.
      # If the AttributeValue is of a type which does not have a string
      # representation defined for it, then it is simply encoded as an
      # octothorpe character ('#' ASCII 35) followed by the hexadecimal
      # representation of each of the bytes of the BER encoding of the X.500
      # AttributeValue.  This form SHOULD be used if the AttributeType is of
      # the dotted-decimal form.
      if ((type_and_value.char_at(0) >= Character.new(?0.ord) && type_and_value.char_at(0) <= Character.new(?9.ord)) || !is_der_string(@value, false))
        data = nil
        begin
          data = @value.to_byte_array
        rescue IOException => ie
          raise IllegalArgumentException.new("DER Value conversion")
        end
        type_and_value.append(Character.new(?#.ord))
        j = 0
        while j < data.attr_length
          b = data[j]
          type_and_value.append(Character.for_digit(0xf & (b >> 4), 16))
          type_and_value.append(Character.for_digit(0xf & b, 16))
          j += 1
        end
      else
        # 2.4 (cont): Otherwise, if the AttributeValue is of a type which
        # has a string representation, the value is converted first to a
        # UTF-8 string according to its syntax specification.
        # 
        # NOTE: this implementation only emits DirectoryStrings of the
        # types returned by isDerString().
        val_str = nil
        begin
          val_str = (String.new(@value.get_data_bytes, "UTF8")).to_s
        rescue IOException => ie
          raise IllegalArgumentException.new("DER Value conversion")
        end
        # 2.4 (cont): If the UTF-8 string does not have any of the
        # following characters which need escaping, then that string can be
        # used as the string representation of the value.
        # 
        # o   a space or "#" character occurring at the beginning of the
        # string
        # o   a space character occurring at the end of the string
        # o   one of the characters ",", "+", """, "\", "<", ">" or ";"
        # 
        # Implementations MAY escape other characters.
        # 
        # NOTE: this implementation also recognizes "=" and "#" as
        # characters which need escaping.
        # 
        # If a character to be escaped is one of the list shown above, then
        # it is prefixed by a backslash ('\' ASCII 92).
        # 
        # Otherwise the character to be escaped is replaced by a backslash
        # and two hex digits, which form a single byte in the code of the
        # character.
        escapees = ",=+<>#;\"\\"
        sbuffer = StringBuilder.new
        i = 0
        while i < val_str.length
          c = val_str.char_at(i)
          if (DerValue.is_printable_string_char(c) || escapees.index_of(c) >= 0)
            # escape escapees
            if (escapees.index_of(c) >= 0)
              sbuffer.append(Character.new(?\\.ord))
            end
            # append printable/escaped char
            sbuffer.append(c)
          else
            if (!(Debug).nil? && Debug.is_on("ava"))
              # embed non-printable/non-escaped char
              # as escaped hex pairs for debugging
              value_bytes = nil
              begin
                value_bytes = Character.to_s(c).get_bytes("UTF8")
              rescue IOException => ie
                raise IllegalArgumentException.new("DER Value conversion")
              end
              j = 0
              while j < value_bytes.attr_length
                sbuffer.append(Character.new(?\\.ord))
                hex_char = Character.for_digit(0xf & (value_bytes[j] >> 4), 16)
                sbuffer.append(Character.to_upper_case(hex_char))
                hex_char = Character.for_digit(0xf & (value_bytes[j]), 16)
                sbuffer.append(Character.to_upper_case(hex_char))
                j += 1
              end
            else
              # append non-printable/non-escaped char
              sbuffer.append(c)
            end
          end
          i += 1
        end
        chars = sbuffer.to_s.to_char_array
        sbuffer = StringBuilder.new
        # Find leading and trailing whitespace.
        lead = 0 # index of first char that is not leading whitespace
        lead = 0
        while lead < chars.attr_length
          if (!(chars[lead]).equal?(Character.new(?\s.ord)) && !(chars[lead]).equal?(Character.new(?\r.ord)))
            break
          end
          lead += 1
        end
        trail = 0 # index of last char that is not trailing whitespace
        trail = chars.attr_length - 1
        while trail >= 0
          if (!(chars[trail]).equal?(Character.new(?\s.ord)) && !(chars[trail]).equal?(Character.new(?\r.ord)))
            break
          end
          trail -= 1
        end
        # escape leading and trailing whitespace
        i_ = 0
        while i_ < chars.attr_length
          c = chars[i_]
          if (i_ < lead || i_ > trail)
            sbuffer.append(Character.new(?\\.ord))
          end
          sbuffer.append(c)
          i_ += 1
        end
        type_and_value.append(sbuffer.to_s)
      end
      return type_and_value.to_s
    end
    
    typesig { [] }
    def to_rfc2253canonical_string
      # Section 2.3: The AttributeTypeAndValue is encoded as the string
      # representation of the AttributeType, followed by an equals character
      # ('=' ASCII 61), followed by the string representation of the
      # AttributeValue. The encoding of the AttributeValue is given in
      # section 2.4.
      type_and_value = StringBuilder.new(40)
      type_and_value.append(to_keyword(RFC2253, Collections.empty_map))
      type_and_value.append(Character.new(?=.ord))
      # Section 2.4: Converting an AttributeValue from ASN.1 to a String.
      # If the AttributeValue is of a type which does not have a string
      # representation defined for it, then it is simply encoded as an
      # octothorpe character ('#' ASCII 35) followed by the hexadecimal
      # representation of each of the bytes of the BER encoding of the X.500
      # AttributeValue.  This form SHOULD be used if the AttributeType is of
      # the dotted-decimal form.
      if ((type_and_value.char_at(0) >= Character.new(?0.ord) && type_and_value.char_at(0) <= Character.new(?9.ord)) || !is_der_string(@value, true))
        data = nil
        begin
          data = @value.to_byte_array
        rescue IOException => ie
          raise IllegalArgumentException.new("DER Value conversion")
        end
        type_and_value.append(Character.new(?#.ord))
        j = 0
        while j < data.attr_length
          b = data[j]
          type_and_value.append(Character.for_digit(0xf & (b >> 4), 16))
          type_and_value.append(Character.for_digit(0xf & b, 16))
          j += 1
        end
      else
        # 2.4 (cont): Otherwise, if the AttributeValue is of a type which
        # has a string representation, the value is converted first to a
        # UTF-8 string according to its syntax specification.
        # 
        # NOTE: this implementation only emits DirectoryStrings of the
        # types returned by isDerString().
        val_str = nil
        begin
          val_str = (String.new(@value.get_data_bytes, "UTF8")).to_s
        rescue IOException => ie
          raise IllegalArgumentException.new("DER Value conversion")
        end
        # 2.4 (cont): If the UTF-8 string does not have any of the
        # following characters which need escaping, then that string can be
        # used as the string representation of the value.
        # 
        # o   a space or "#" character occurring at the beginning of the
        # string
        # o   a space character occurring at the end of the string
        # 
        # o   one of the characters ",", "+", """, "\", "<", ">" or ";"
        # 
        # If a character to be escaped is one of the list shown above, then
        # it is prefixed by a backslash ('\' ASCII 92).
        # 
        # Otherwise the character to be escaped is replaced by a backslash
        # and two hex digits, which form a single byte in the code of the
        # character.
        escapees = ",+<>;\"\\"
        sbuffer = StringBuilder.new
        previous_white = false
        i = 0
        while i < val_str.length
          c = val_str.char_at(i)
          if (DerValue.is_printable_string_char(c) || escapees.index_of(c) >= 0 || ((i).equal?(0) && (c).equal?(Character.new(?#.ord))))
            # escape leading '#' and escapees
            if (((i).equal?(0) && (c).equal?(Character.new(?#.ord))) || escapees.index_of(c) >= 0)
              sbuffer.append(Character.new(?\\.ord))
            end
            # convert multiple whitespace to single whitespace
            if (!Character.is_whitespace(c))
              previous_white = false
              sbuffer.append(c)
            else
              if ((previous_white).equal?(false))
                # add single whitespace
                previous_white = true
                sbuffer.append(c)
              else
                # ignore subsequent consecutive whitespace
                i += 1
                next
              end
            end
          else
            if (!(Debug).nil? && Debug.is_on("ava"))
              # embed non-printable/non-escaped char
              # as escaped hex pairs for debugging
              previous_white = false
              value_bytes = nil
              begin
                value_bytes = Character.to_s(c).get_bytes("UTF8")
              rescue IOException => ie
                raise IllegalArgumentException.new("DER Value conversion")
              end
              j = 0
              while j < value_bytes.attr_length
                sbuffer.append(Character.new(?\\.ord))
                sbuffer.append(Character.for_digit(0xf & (value_bytes[j] >> 4), 16))
                sbuffer.append(Character.for_digit(0xf & (value_bytes[j]), 16))
                j += 1
              end
            else
              # append non-printable/non-escaped char
              previous_white = false
              sbuffer.append(c)
            end
          end
          i += 1
        end
        # remove leading and trailing whitespace from value
        type_and_value.append(sbuffer.to_s.trim)
      end
      canon = type_and_value.to_s
      canon = (canon.to_upper_case(Locale::US).to_lower_case(Locale::US)).to_s
      return Normalizer.normalize(canon, Normalizer::Form::NFKD)
    end
    
    class_module.module_eval {
      typesig { [DerValue, ::Java::Boolean] }
      # Return true if DerValue can be represented as a String.
      def is_der_string(value, canonical)
        if (canonical)
          case (value.attr_tag)
          when DerValue.attr_tag_printable_string, DerValue.attr_tag_utf8string
            return true
          else
            return false
          end
        else
          case (value.attr_tag)
          when DerValue.attr_tag_printable_string, DerValue.attr_tag_t61string, DerValue.attr_tag_ia5string, DerValue.attr_tag_general_string, DerValue.attr_tag_bmpstring, DerValue.attr_tag_utf8string
            return true
          else
            return false
          end
        end
      end
    }
    
    typesig { [] }
    def has_rfc2253keyword
      return AVAKeyword.has_keyword(@oid, RFC2253)
    end
    
    typesig { [String] }
    def to_keyword_value_string(keyword)
      # Construct the value with as little copying and garbage
      # production as practical.  First the keyword (mandatory),
      # then the equals sign, finally the value.
      retval = StringBuilder.new(40)
      retval.append(keyword)
      retval.append("=")
      begin
        val_str = @value.get_as_string
        if ((val_str).nil?)
          # rfc1779 specifies that attribute values associated
          # with non-standard keyword attributes may be represented
          # using the hex format below.  This will be used only
          # when the value is not a string type
          data = @value.to_byte_array
          retval.append(Character.new(?#.ord))
          i = 0
          while i < data.attr_length
            retval.append(HexDigits.char_at((data[i] >> 4) & 0xf))
            retval.append(HexDigits.char_at(data[i] & 0xf))
            i += 1
          end
        else
          quote_needed = false
          sbuffer = StringBuilder.new
          previous_white = false
          escapees = ",+=\n<>#;\\\""
          # Special characters (e.g. AVA list separators) cause strings
          # to need quoting, or at least escaping.  So do leading or
          # trailing spaces, and multiple internal spaces.
          i = 0
          while i < val_str.length
            c = val_str.char_at(i)
            if (DerValue.is_printable_string_char(c) || escapees.index_of(c) >= 0)
              # quote if leading whitespace or special chars
              if (!quote_needed && (((i).equal?(0) && ((c).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\n.ord)))) || escapees.index_of(c) >= 0))
                quote_needed = true
              end
              # quote if multiple internal whitespace
              if (!((c).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\n.ord))))
                # escape '"' and '\'
                if ((c).equal?(Character.new(?".ord)) || (c).equal?(Character.new(?\\.ord)))
                  sbuffer.append(Character.new(?\\.ord))
                end
                previous_white = false
              else
                if (!quote_needed && previous_white)
                  quote_needed = true
                end
                previous_white = true
              end
              sbuffer.append(c)
            else
              if (!(Debug).nil? && Debug.is_on("ava"))
                # embed non-printable/non-escaped char
                # as escaped hex pairs for debugging
                previous_white = false
                # embed escaped hex pairs
                value_bytes = Character.to_s(c).get_bytes("UTF8")
                j = 0
                while j < value_bytes.attr_length
                  sbuffer.append(Character.new(?\\.ord))
                  hex_char = Character.for_digit(0xf & (value_bytes[j] >> 4), 16)
                  sbuffer.append(Character.to_upper_case(hex_char))
                  hex_char = Character.for_digit(0xf & (value_bytes[j]), 16)
                  sbuffer.append(Character.to_upper_case(hex_char))
                  j += 1
                end
              else
                # append non-printable/non-escaped char
                previous_white = false
                sbuffer.append(c)
              end
            end
            i += 1
          end
          # quote if trailing whitespace
          if (sbuffer.length > 0)
            trail_char = sbuffer.char_at(sbuffer.length - 1)
            if ((trail_char).equal?(Character.new(?\s.ord)) || (trail_char).equal?(Character.new(?\n.ord)))
              quote_needed = true
            end
          end
          # Emit the string ... quote it if needed
          if (quote_needed)
            retval.append("\"" + (sbuffer.to_s).to_s + "\"")
          else
            retval.append(sbuffer.to_s)
          end
        end
      rescue IOException => e
        raise IllegalArgumentException.new("DER Value conversion")
      end
      return retval.to_s
    end
    
    private
    alias_method :initialize__ava, :initialize
  end
  
  # Helper class that allows conversion from String to ObjectIdentifier and
  # vice versa according to RFC1779, RFC2253, and an augmented version of
  # those standards.
  class AVAKeyword 
    include_class_members AVAImports
    
    attr_accessor :keyword
    alias_method :attr_keyword, :keyword
    undef_method :keyword
    alias_method :attr_keyword=, :keyword=
    undef_method :keyword=
    
    attr_accessor :oid
    alias_method :attr_oid, :oid
    undef_method :oid
    alias_method :attr_oid=, :oid=
    undef_method :oid=
    
    attr_accessor :rfc1779compliant
    alias_method :attr_rfc1779compliant, :rfc1779compliant
    undef_method :rfc1779compliant
    alias_method :attr_rfc1779compliant=, :rfc1779compliant=
    undef_method :rfc1779compliant=
    
    attr_accessor :rfc2253compliant
    alias_method :attr_rfc2253compliant, :rfc2253compliant
    undef_method :rfc2253compliant
    alias_method :attr_rfc2253compliant=, :rfc2253compliant=
    undef_method :rfc2253compliant=
    
    typesig { [String, ObjectIdentifier, ::Java::Boolean, ::Java::Boolean] }
    def initialize(keyword, oid, rfc1779compliant, rfc2253compliant)
      @keyword = nil
      @oid = nil
      @rfc1779compliant = false
      @rfc2253compliant = false
      @keyword = keyword
      @oid = oid
      @rfc1779compliant = rfc1779compliant
      @rfc2253compliant = rfc2253compliant
      # register it
      OidMap.put(oid, self)
      KeywordMap.put(keyword, self)
    end
    
    typesig { [::Java::Int] }
    def is_compliant(standard)
      case (standard)
      when AVA::RFC1779
        return @rfc1779compliant
      when AVA::RFC2253
        return @rfc2253compliant
      when AVA::DEFAULT
        return true
      else
        # should not occur, internal error
        raise IllegalArgumentException.new("Invalid standard " + (standard).to_s)
      end
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Int] }
      # Get an object identifier representing the specified keyword (or
      # string encoded object identifier) in the given standard.
      # 
      # @throws IOException If the keyword is not valid in the specified standard
      def get_oid(keyword, standard)
        return get_oid(keyword, standard, Collections.empty_map)
      end
      
      typesig { [String, ::Java::Int, Map] }
      # Get an object identifier representing the specified keyword (or
      # string encoded object identifier) in the given standard.
      # 
      # @param keywordMap a Map where a keyword String maps to a corresponding
      # OID String. Each AVA keyword will be mapped to the corresponding OID.
      # If an entry does not exist, it will fallback to the builtin
      # keyword/OID mapping.
      # @throws IOException If the keyword is not valid in the specified standard
      # or the OID String to which a keyword maps to is improperly formatted.
      def get_oid(keyword, standard, extra_keyword_map)
        keyword = (keyword.to_upper_case).to_s
        if ((standard).equal?(AVA::RFC2253))
          if (keyword.starts_with(" ") || keyword.ends_with(" "))
            raise IOException.new("Invalid leading or trailing space " + "in keyword \"" + keyword + "\"")
          end
        else
          keyword = (keyword.trim).to_s
        end
        # check user-specified keyword map first, then fallback to built-in
        # map
        oid_string = extra_keyword_map.get(keyword)
        if ((oid_string).nil?)
          ak = KeywordMap.get(keyword)
          if ((!(ak).nil?) && ak.is_compliant(standard))
            return ak.attr_oid
          end
        else
          return ObjectIdentifier.new(oid_string)
        end
        # no keyword found or not standard compliant, check if OID string
        # RFC1779 requires, DEFAULT allows OID. prefix
        if ((standard).equal?(AVA::RFC1779))
          if ((keyword.starts_with("OID.")).equal?(false))
            raise IOException.new("Invalid RFC1779 keyword: " + keyword)
          end
          keyword = (keyword.substring(4)).to_s
        else
          if ((standard).equal?(AVA::DEFAULT))
            if (keyword.starts_with("OID."))
              keyword = (keyword.substring(4)).to_s
            end
          end
        end
        number = false
        if (!(keyword.length).equal?(0))
          ch = keyword.char_at(0)
          if ((ch >= Character.new(?0.ord)) && (ch <= Character.new(?9.ord)))
            number = true
          end
        end
        if ((number).equal?(false))
          raise IOException.new("Invalid keyword \"" + keyword + "\"")
        end
        return ObjectIdentifier.new(keyword)
      end
      
      typesig { [ObjectIdentifier, ::Java::Int] }
      # Get a keyword for the given ObjectIdentifier according to standard.
      # If no keyword is available, the ObjectIdentifier is encoded as a
      # String.
      def get_keyword(oid, standard)
        return get_keyword(oid, standard, Collections.empty_map)
      end
      
      typesig { [ObjectIdentifier, ::Java::Int, Map] }
      # Get a keyword for the given ObjectIdentifier according to standard.
      # Checks the extraOidMap for a keyword first, then falls back to the
      # builtin/default set. If no keyword is available, the ObjectIdentifier
      # is encoded as a String.
      def get_keyword(oid, standard, extra_oid_map)
        # check extraOidMap first, then fallback to built-in map
        oid_string = oid.to_s
        keyword_string = extra_oid_map.get(oid_string)
        if ((keyword_string).nil?)
          ak = OidMap.get(oid)
          if ((!(ak).nil?) && ak.is_compliant(standard))
            return ak.attr_keyword
          end
        else
          if ((keyword_string.length).equal?(0))
            raise IllegalArgumentException.new("keyword cannot be empty")
          end
          keyword_string = (keyword_string.trim).to_s
          c = keyword_string.char_at(0)
          if (c < 65 || c > 122 || (c > 90 && c < 97))
            raise IllegalArgumentException.new("keyword does not start with letter")
          end
          i = 1
          while i < keyword_string.length
            c = keyword_string.char_at(i)
            if ((c < 65 || c > 122 || (c > 90 && c < 97)) && (c < 48 || c > 57) && !(c).equal?(Character.new(?_.ord)))
              raise IllegalArgumentException.new("keyword character is not a letter, digit, or underscore")
            end
            i += 1
          end
          return keyword_string
        end
        # no compliant keyword, use OID
        if ((standard).equal?(AVA::RFC2253))
          return oid_string
        else
          return "OID." + oid_string
        end
      end
      
      typesig { [ObjectIdentifier, ::Java::Int] }
      # Test if oid has an associated keyword in standard.
      def has_keyword(oid, standard)
        ak = OidMap.get(oid)
        if ((ak).nil?)
          return false
        end
        return ak.is_compliant(standard)
      end
      
      when_class_loaded do
        const_set :OidMap, HashMap.new
        const_set :KeywordMap, HashMap.new
        # NOTE if multiple keywords are available for one OID, order
        # is significant!! Preferred *LAST*.
        AVAKeyword.new("CN", X500Name.attr_common_name_oid, true, true)
        AVAKeyword.new("C", X500Name.attr_country_name_oid, true, true)
        AVAKeyword.new("L", X500Name.attr_locality_name_oid, true, true)
        AVAKeyword.new("S", X500Name.attr_state_name_oid, false, false)
        AVAKeyword.new("ST", X500Name.attr_state_name_oid, true, true)
        AVAKeyword.new("O", X500Name.attr_org_name_oid, true, true)
        AVAKeyword.new("OU", X500Name.attr_org_unit_name_oid, true, true)
        AVAKeyword.new("T", X500Name.attr_title_oid, false, false)
        AVAKeyword.new("IP", X500Name.attr_ip_address_oid, false, false)
        AVAKeyword.new("STREET", X500Name.attr_street_address_oid, true, true)
        AVAKeyword.new("DC", X500Name::DOMAIN_COMPONENT_OID, false, true)
        AVAKeyword.new("DNQUALIFIER", X500Name::DNQUALIFIER_OID, false, false)
        AVAKeyword.new("DNQ", X500Name::DNQUALIFIER_OID, false, false)
        AVAKeyword.new("SURNAME", X500Name::SURNAME_OID, false, false)
        AVAKeyword.new("GIVENNAME", X500Name::GIVENNAME_OID, false, false)
        AVAKeyword.new("INITIALS", X500Name::INITIALS_OID, false, false)
        AVAKeyword.new("GENERATION", X500Name::GENERATIONQUALIFIER_OID, false, false)
        AVAKeyword.new("EMAIL", PKCS9Attribute::EMAIL_ADDRESS_OID, false, false)
        AVAKeyword.new("EMAILADDRESS", PKCS9Attribute::EMAIL_ADDRESS_OID, false, false)
        AVAKeyword.new("UID", X500Name.attr_userid_oid, false, true)
        AVAKeyword.new("SERIALNUMBER", X500Name::SERIALNUMBER_OID, false, false)
      end
    }
    
    private
    alias_method :initialize__avakeyword, :initialize
  end
  
end
