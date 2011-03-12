require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RDNImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Lang::Reflect
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :StringReader
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :Principal
      include ::Java::Util
      include ::Sun::Security::Util
      include_const ::Sun::Security::Pkcs, :PKCS9Attribute
      include_const ::Javax::Security::Auth::X500, :X500Principal
    }
  end
  
  # RDNs are a set of {attribute = value} assertions.  Some of those
  # attributes are "distinguished" (unique w/in context).  Order is
  # never relevant.
  # 
  # Some X.500 names include only a single distinguished attribute
  # per RDN.  This style is currently common.
  # 
  # Note that DER-encoded RDNs sort AVAs by assertion OID ... so that
  # when we parse this data we don't have to worry about canonicalizing
  # it, but we'll need to sort them when we expose the RDN class more.
  # <p>
  # The ASN.1 for RDNs is:
  # <pre>
  # RelativeDistinguishedName ::=
  #   SET OF AttributeTypeAndValue
  # 
  # AttributeTypeAndValue ::= SEQUENCE {
  #   type     AttributeType,
  #   value    AttributeValue }
  # 
  # AttributeType ::= OBJECT IDENTIFIER
  # 
  # AttributeValue ::= ANY DEFINED BY AttributeType
  # </pre>
  # 
  # Note that instances of this class are immutable.
  class RDN 
    include_class_members RDNImports
    
    # currently not private, accessed directly from X500Name
    attr_accessor :assertion
    alias_method :attr_assertion, :assertion
    undef_method :assertion
    alias_method :attr_assertion=, :assertion=
    undef_method :assertion=
    
    # cached immutable List of the AVAs
    attr_accessor :ava_list
    alias_method :attr_ava_list, :ava_list
    undef_method :ava_list
    alias_method :attr_ava_list=, :ava_list=
    undef_method :ava_list=
    
    # cache canonical String form
    attr_accessor :canonical_string
    alias_method :attr_canonical_string, :canonical_string
    undef_method :canonical_string
    alias_method :attr_canonical_string=, :canonical_string=
    undef_method :canonical_string=
    
    typesig { [String] }
    # Constructs an RDN from its printable representation.
    # 
    # An RDN may consist of one or multiple Attribute Value Assertions (AVAs),
    # using '+' as a separator.
    # If the '+' should be considered part of an AVA value, it must be
    # preceded by '\'.
    # 
    # @param name String form of RDN
    # @throws IOException on parsing error
    def initialize(name)
      initialize__rdn(name, Collections.empty_map)
    end
    
    typesig { [String, Map] }
    # Constructs an RDN from its printable representation.
    # 
    # An RDN may consist of one or multiple Attribute Value Assertions (AVAs),
    # using '+' as a separator.
    # If the '+' should be considered part of an AVA value, it must be
    # preceded by '\'.
    # 
    # @param name String form of RDN
    # @param keyword an additional mapping of keywords to OIDs
    # @throws IOException on parsing error
    def initialize(name, keyword_map)
      @assertion = nil
      @ava_list = nil
      @canonical_string = nil
      quote_count = 0
      search_offset = 0
      ava_offset = 0
      ava_vec = ArrayList.new(3)
      next_plus = name.index_of(Character.new(?+.ord))
      while (next_plus >= 0)
        quote_count += X500Name.count_quotes(name, search_offset, next_plus)
        # We have encountered an AVA delimiter (plus sign).
        # If the plus sign in the RDN under consideration is
        # preceded by a backslash (escape), or by a double quote, it
        # is part of the AVA. Otherwise, it is used as a separator, to
        # delimit the AVA under consideration from any subsequent AVAs.
        if (next_plus > 0 && !(name.char_at(next_plus - 1)).equal?(Character.new(?\\.ord)) && !(quote_count).equal?(1))
          # Plus sign is a separator
          ava_string = name.substring(ava_offset, next_plus)
          if ((ava_string.length).equal?(0))
            raise IOException.new("empty AVA in RDN \"" + name + "\"")
          end
          # Parse AVA, and store it in vector
          ava = AVA.new(StringReader.new(ava_string), keyword_map)
          ava_vec.add(ava)
          # Increase the offset
          ava_offset = next_plus + 1
          # Set quote counter back to zero
          quote_count = 0
        end
        search_offset = next_plus + 1
        next_plus = name.index_of(Character.new(?+.ord), search_offset)
      end
      # parse last or only AVA
      ava_string = name.substring(ava_offset)
      if ((ava_string.length).equal?(0))
        raise IOException.new("empty AVA in RDN \"" + name + "\"")
      end
      ava = AVA.new(StringReader.new(ava_string), keyword_map)
      ava_vec.add(ava)
      @assertion = ava_vec.to_array(Array.typed(AVA).new(ava_vec.size) { nil })
    end
    
    typesig { [String, String] }
    # Constructs an RDN from its printable representation.
    # 
    # An RDN may consist of one or multiple Attribute Value Assertions (AVAs),
    # using '+' as a separator.
    # If the '+' should be considered part of an AVA value, it must be
    # preceded by '\'.
    # 
    # @param name String form of RDN
    # @throws IOException on parsing error
    def initialize(name, format)
      initialize__rdn(name, format, Collections.empty_map)
    end
    
    typesig { [String, String, Map] }
    # Constructs an RDN from its printable representation.
    # 
    # An RDN may consist of one or multiple Attribute Value Assertions (AVAs),
    # using '+' as a separator.
    # If the '+' should be considered part of an AVA value, it must be
    # preceded by '\'.
    # 
    # @param name String form of RDN
    # @param keyword an additional mapping of keywords to OIDs
    # @throws IOException on parsing error
    def initialize(name, format, keyword_map)
      @assertion = nil
      @ava_list = nil
      @canonical_string = nil
      if ((format.equals_ignore_case("RFC2253")).equal?(false))
        raise IOException.new("Unsupported format " + format)
      end
      search_offset = 0
      ava_offset = 0
      ava_vec = ArrayList.new(3)
      next_plus = name.index_of(Character.new(?+.ord))
      while (next_plus >= 0)
        # We have encountered an AVA delimiter (plus sign).
        # If the plus sign in the RDN under consideration is
        # preceded by a backslash (escape), or by a double quote, it
        # is part of the AVA. Otherwise, it is used as a separator, to
        # delimit the AVA under consideration from any subsequent AVAs.
        if (next_plus > 0 && !(name.char_at(next_plus - 1)).equal?(Character.new(?\\.ord)))
          # Plus sign is a separator
          ava_string = name.substring(ava_offset, next_plus)
          if ((ava_string.length).equal?(0))
            raise IOException.new("empty AVA in RDN \"" + name + "\"")
          end
          # Parse AVA, and store it in vector
          ava = AVA.new(StringReader.new(ava_string), AVA::RFC2253, keyword_map)
          ava_vec.add(ava)
          # Increase the offset
          ava_offset = next_plus + 1
        end
        search_offset = next_plus + 1
        next_plus = name.index_of(Character.new(?+.ord), search_offset)
      end
      # parse last or only AVA
      ava_string = name.substring(ava_offset)
      if ((ava_string.length).equal?(0))
        raise IOException.new("empty AVA in RDN \"" + name + "\"")
      end
      ava = AVA.new(StringReader.new(ava_string), AVA::RFC2253, keyword_map)
      ava_vec.add(ava)
      @assertion = ava_vec.to_array(Array.typed(AVA).new(ava_vec.size) { nil })
    end
    
    typesig { [DerValue] }
    # Constructs an RDN from an ASN.1 encoded value.  The encoding
    # of the name in the stream uses DER (a BER/1 subset).
    # 
    # @param value a DER-encoded value holding an RDN.
    # @throws IOException on parsing error.
    def initialize(rdn)
      @assertion = nil
      @ava_list = nil
      @canonical_string = nil
      if (!(rdn.attr_tag).equal?(DerValue.attr_tag_set))
        raise IOException.new("X500 RDN")
      end
      dis = DerInputStream.new(rdn.to_byte_array)
      avaset = dis.get_set(5)
      @assertion = Array.typed(AVA).new(avaset.attr_length) { nil }
      i = 0
      while i < avaset.attr_length
        @assertion[i] = AVA.new(avaset[i])
        i += 1
      end
    end
    
    typesig { [::Java::Int] }
    # Creates an empty RDN with slots for specified
    # number of AVAs.
    # 
    # @param i number of AVAs to be in RDN
    def initialize(i)
      @assertion = nil
      @ava_list = nil
      @canonical_string = nil
      @assertion = Array.typed(AVA).new(i) { nil }
    end
    
    typesig { [AVA] }
    def initialize(ava)
      @assertion = nil
      @ava_list = nil
      @canonical_string = nil
      if ((ava).nil?)
        raise NullPointerException.new
      end
      @assertion = Array.typed(AVA).new([ava])
    end
    
    typesig { [Array.typed(AVA)] }
    def initialize(avas)
      @assertion = nil
      @ava_list = nil
      @canonical_string = nil
      @assertion = avas.clone
      i = 0
      while i < @assertion.attr_length
        if ((@assertion[i]).nil?)
          raise NullPointerException.new
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Return an immutable List of the AVAs in this RDN.
    def avas
      list = @ava_list
      if ((list).nil?)
        list = Collections.unmodifiable_list(Arrays.as_list(@assertion))
        @ava_list = list
      end
      return list
    end
    
    typesig { [] }
    # Return the number of AVAs in this RDN.
    def size
      return @assertion.attr_length
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(RDN)).equal?(false))
        return false
      end
      other = obj
      if (!(@assertion.attr_length).equal?(other.attr_assertion.attr_length))
        return false
      end
      this_canon = self.to_rfc2253string(true)
      other_canon = other.to_rfc2253string(true)
      return (this_canon == other_canon)
    end
    
    typesig { [] }
    # Calculates a hash code value for the object.  Objects
    # which are equal will also have the same hashcode.
    # 
    # @returns int hashCode value
    def hash_code
      return to_rfc2253string(true).hash_code
    end
    
    typesig { [ObjectIdentifier] }
    # return specified attribute value from RDN
    # 
    # @params oid ObjectIdentifier of attribute to be found
    # @returns DerValue of attribute value; null if attribute does not exist
    def find_attribute(oid)
      i = 0
      while i < @assertion.attr_length
        if ((@assertion[i].attr_oid == oid))
          return @assertion[i].attr_value
        end
        i += 1
      end
      return nil
    end
    
    typesig { [DerOutputStream] }
    # Encode the RDN in DER-encoded form.
    # 
    # @param out DerOutputStream to which RDN is to be written
    # @throws IOException on error
    def encode(out)
      out.put_ordered_set_of(DerValue.attr_tag_set, @assertion)
    end
    
    typesig { [] }
    # Returns a printable form of this RDN, using RFC 1779 style catenation
    # of attribute/value assertions, and emitting attribute type keywords
    # from RFCs 1779, 2253, and 3280.
    def to_s
      if ((@assertion.attr_length).equal?(1))
        return @assertion[0].to_s
      end
      sb = StringBuilder.new
      i = 0
      while i < @assertion.attr_length
        if (!(i).equal?(0))
          sb.append(" + ")
        end
        sb.append(@assertion[i].to_s)
        i += 1
      end
      return sb.to_s
    end
    
    typesig { [] }
    # Returns a printable form of this RDN using the algorithm defined in
    # RFC 1779. Only RFC 1779 attribute type keywords are emitted.
    def to_rfc1779string
      return to_rfc1779string(Collections.empty_map)
    end
    
    typesig { [Map] }
    # Returns a printable form of this RDN using the algorithm defined in
    # RFC 1779. RFC 1779 attribute type keywords are emitted, as well
    # as keywords contained in the OID/keyword map.
    def to_rfc1779string(oid_map)
      if ((@assertion.attr_length).equal?(1))
        return @assertion[0].to_rfc1779string(oid_map)
      end
      sb = StringBuilder.new
      i = 0
      while i < @assertion.attr_length
        if (!(i).equal?(0))
          sb.append(" + ")
        end
        sb.append(@assertion[i].to_rfc1779string(oid_map))
        i += 1
      end
      return sb.to_s
    end
    
    typesig { [] }
    # Returns a printable form of this RDN using the algorithm defined in
    # RFC 2253. Only RFC 2253 attribute type keywords are emitted.
    def to_rfc2253string
      return to_rfc2253string_internal(false, Collections.empty_map)
    end
    
    typesig { [Map] }
    # Returns a printable form of this RDN using the algorithm defined in
    # RFC 2253. RFC 2253 attribute type keywords are emitted, as well as
    # keywords contained in the OID/keyword map.
    def to_rfc2253string(oid_map)
      return to_rfc2253string_internal(false, oid_map)
    end
    
    typesig { [::Java::Boolean] }
    # Returns a printable form of this RDN using the algorithm defined in
    # RFC 2253. Only RFC 2253 attribute type keywords are emitted.
    # If canonical is true, then additional canonicalizations
    # documented in X500Principal.getName are performed.
    def to_rfc2253string(canonical)
      if ((canonical).equal?(false))
        return to_rfc2253string_internal(false, Collections.empty_map)
      end
      c = @canonical_string
      if ((c).nil?)
        c = RJava.cast_to_string(to_rfc2253string_internal(true, Collections.empty_map))
        @canonical_string = c
      end
      return c
    end
    
    typesig { [::Java::Boolean, Map] }
    def to_rfc2253string_internal(canonical, oid_map)
      # Section 2.2: When converting from an ASN.1 RelativeDistinguishedName
      # to a string, the output consists of the string encodings of each
      # AttributeTypeAndValue (according to 2.3), in any order.
      # 
      # Where there is a multi-valued RDN, the outputs from adjoining
      # AttributeTypeAndValues are separated by a plus ('+' ASCII 43)
      # character.
      # normally, an RDN only contains one AVA
      if ((@assertion.attr_length).equal?(1))
        return canonical ? @assertion[0].to_rfc2253canonical_string : @assertion[0].to_rfc2253string(oid_map)
      end
      relname = StringBuilder.new
      if (!canonical)
        i = 0
        while i < @assertion.attr_length
          if (i > 0)
            relname.append(Character.new(?+.ord))
          end
          relname.append(@assertion[i].to_rfc2253string(oid_map))
          i += 1
        end
      else
        # order the string type AVA's alphabetically,
        # followed by the oid type AVA's numerically
        ava_list = ArrayList.new(@assertion.attr_length)
        i = 0
        while i < @assertion.attr_length
          ava_list.add(@assertion[i])
          i += 1
        end
        Java::Util::Collections.sort(ava_list, AVAComparator.get_instance)
        i_ = 0
        while i_ < ava_list.size
          if (i_ > 0)
            relname.append(Character.new(?+.ord))
          end
          relname.append(ava_list.get(i_).to_rfc2253canonical_string)
          i_ += 1
        end
      end
      return relname.to_s
    end
    
    private
    alias_method :initialize__rdn, :initialize
  end
  
  class AVAComparator 
    include_class_members RDNImports
    include Comparator
    
    class_module.module_eval {
      const_set_lazy(:INSTANCE) { AVAComparator.new }
      const_attr_reader  :INSTANCE
    }
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      typesig { [] }
      def get_instance
        return INSTANCE
      end
    }
    
    typesig { [AVA, AVA] }
    # AVA's containing a standard keyword are ordered alphabetically,
    # followed by AVA's containing an OID keyword, ordered numerically
    def compare(a1, a2)
      a1has2253 = a1.has_rfc2253keyword
      a2has2253 = a2.has_rfc2253keyword
      if ((a1has2253).equal?(a2has2253))
        return (a1.to_rfc2253canonical_string <=> a2.to_rfc2253canonical_string)
      else
        if (a1has2253)
          return -1
        else
          return 1
        end
      end
    end
    
    private
    alias_method :initialize__avacomparator, :initialize
  end
  
end
