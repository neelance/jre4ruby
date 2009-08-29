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
  module X500NameImports #:nodoc:
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
  
  # Note:  As of 1.4, the public class,
  # javax.security.auth.x500.X500Principal,
  # should be used when parsing, generating, and comparing X.500 DNs.
  # This class contains other useful methods for checking name constraints
  # and retrieving DNs by keyword.
  # 
  # <p> X.500 names are used to identify entities, such as those which are
  # identified by X.509 certificates.  They are world-wide, hierarchical,
  # and descriptive.  Entities can be identified by attributes, and in
  # some systems can be searched for according to those attributes.
  # <p>
  # The ASN.1 for this is:
  # <pre>
  # GeneralName ::= CHOICE {
  # ....
  # directoryName                   [4]     Name,
  # ....
  # Name ::= CHOICE {
  # RDNSequence }
  # 
  # RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
  # 
  # RelativeDistinguishedName ::=
  # SET OF AttributeTypeAndValue
  # 
  # AttributeTypeAndValue ::= SEQUENCE {
  # type     AttributeType,
  # value    AttributeValue }
  # 
  # AttributeType ::= OBJECT IDENTIFIER
  # 
  # AttributeValue ::= ANY DEFINED BY AttributeType
  # ....
  # DirectoryString ::= CHOICE {
  # teletexString           TeletexString (SIZE (1..MAX)),
  # printableString         PrintableString (SIZE (1..MAX)),
  # universalString         UniversalString (SIZE (1..MAX)),
  # utf8String              UTF8String (SIZE (1.. MAX)),
  # bmpString               BMPString (SIZE (1..MAX)) }
  # </pre>
  # <p>
  # This specification requires only a subset of the name comparison
  # functionality specified in the X.500 series of specifications.  The
  # requirements for conforming implementations are as follows:
  # <ol TYPE=a>
  # <li>attribute values encoded in different types (e.g.,
  # PrintableString and BMPString) may be assumed to represent
  # different strings;
  # <p>
  # <li>attribute values in types other than PrintableString are case
  # sensitive (this permits matching of attribute values as binary
  # objects);
  # <p>
  # <li>attribute values in PrintableString are not case sensitive
  # (e.g., "Marianne Swanson" is the same as "MARIANNE SWANSON"); and
  # <p>
  # <li>attribute values in PrintableString are compared after
  # removing leading and trailing white space and converting internal
  # substrings of one or more consecutive white space characters to a
  # single space.
  # </ol>
  # <p>
  # These name comparison rules permit a certificate user to validate
  # certificates issued using languages or encodings unfamiliar to the
  # certificate user.
  # <p>
  # In addition, implementations of this specification MAY use these
  # comparison rules to process unfamiliar attribute types for name
  # chaining. This allows implementations to process certificates with
  # unfamiliar attributes in the issuer name.
  # <p>
  # Note that the comparison rules defined in the X.500 series of
  # specifications indicate that the character sets used to encode data
  # in distinguished names are irrelevant.  The characters themselves are
  # compared without regard to encoding. Implementations of the profile
  # are permitted to use the comparison algorithm defined in the X.500
  # series.  Such an implementation will recognize a superset of name
  # matches recognized by the algorithm specified above.
  # <p>
  # Note that instances of this class are immutable.
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see GeneralName
  # @see GeneralNames
  # @see GeneralNameInterface
  class X500Name 
    include_class_members X500NameImports
    include GeneralNameInterface
    include Principal
    
    attr_accessor :dn
    alias_method :attr_dn, :dn
    undef_method :dn
    alias_method :attr_dn=, :dn=
    undef_method :dn=
    
    # roughly RFC 1779 DN, or null
    attr_accessor :rfc1779dn
    alias_method :attr_rfc1779dn, :rfc1779dn
    undef_method :rfc1779dn
    alias_method :attr_rfc1779dn=, :rfc1779dn=
    undef_method :rfc1779dn=
    
    # RFC 1779 compliant DN, or null
    attr_accessor :rfc2253dn
    alias_method :attr_rfc2253dn, :rfc2253dn
    undef_method :rfc2253dn
    alias_method :attr_rfc2253dn=, :rfc2253dn=
    undef_method :rfc2253dn=
    
    # RFC 2253 DN, or null
    attr_accessor :canonical_dn
    alias_method :attr_canonical_dn, :canonical_dn
    undef_method :canonical_dn
    alias_method :attr_canonical_dn=, :canonical_dn=
    undef_method :canonical_dn=
    
    # canonical RFC 2253 DN or null
    attr_accessor :names
    alias_method :attr_names, :names
    undef_method :names
    alias_method :attr_names=, :names=
    undef_method :names=
    
    # RDNs (never null)
    attr_accessor :x500principal
    alias_method :attr_x500principal, :x500principal
    undef_method :x500principal
    alias_method :attr_x500principal=, :x500principal=
    undef_method :x500principal=
    
    attr_accessor :encoded
    alias_method :attr_encoded, :encoded
    undef_method :encoded
    alias_method :attr_encoded=, :encoded=
    undef_method :encoded=
    
    # cached immutable list of the RDNs and all the AVAs
    attr_accessor :rdn_list
    alias_method :attr_rdn_list, :rdn_list
    undef_method :rdn_list
    alias_method :attr_rdn_list=, :rdn_list=
    undef_method :rdn_list=
    
    attr_accessor :all_ava_list
    alias_method :attr_all_ava_list, :all_ava_list
    undef_method :all_ava_list
    alias_method :attr_all_ava_list=, :all_ava_list=
    undef_method :all_ava_list=
    
    typesig { [String] }
    # Constructs a name from a conventionally formatted string, such
    # as "CN=Dave, OU=JavaSoft, O=Sun Microsystems, C=US".
    # (RFC 1779 or RFC 2253 style).
    # 
    # @param DN X.500 Distinguished Name
    def initialize(dname)
      initialize__x500name(dname, Collections.empty_map)
    end
    
    typesig { [String, Map] }
    # Constructs a name from a conventionally formatted string, such
    # as "CN=Dave, OU=JavaSoft, O=Sun Microsystems, C=US".
    # (RFC 1779 or RFC 2253 style).
    # 
    # @param DN X.500 Distinguished Name
    # @param keywordMap an additional keyword/OID map
    def initialize(dname, keyword_map)
      @dn = nil
      @rfc1779dn = nil
      @rfc2253dn = nil
      @canonical_dn = nil
      @names = nil
      @x500principal = nil
      @encoded = nil
      @rdn_list = nil
      @all_ava_list = nil
      parse_dn(dname, keyword_map)
    end
    
    typesig { [String, String] }
    # Constructs a name from a string formatted according to format.
    # Currently, the formats DEFAULT and RFC2253 are supported.
    # DEFAULT is the default format used by the X500Name(String)
    # constructor. RFC2253 is format strictly according to RFC2253
    # without extensions.
    # 
    # @param DN X.500 Distinguished Name
    def initialize(dname, format)
      @dn = nil
      @rfc1779dn = nil
      @rfc2253dn = nil
      @canonical_dn = nil
      @names = nil
      @x500principal = nil
      @encoded = nil
      @rdn_list = nil
      @all_ava_list = nil
      if ((dname).nil?)
        raise NullPointerException.new("Name must not be null")
      end
      if (format.equals_ignore_case("RFC2253"))
        parse_rfc2253dn(dname)
      else
        if (format.equals_ignore_case("DEFAULT"))
          parse_dn(dname, Collections.empty_map)
        else
          raise IOException.new("Unsupported format " + format)
        end
      end
    end
    
    typesig { [String, String, String, String] }
    # Constructs a name from fields common in enterprise application
    # environments.
    # 
    # <P><EM><STRONG>NOTE:</STRONG>  The behaviour when any of
    # these strings contain characters outside the ASCII range
    # is unspecified in currently relevant standards.</EM>
    # 
    # @param commonName common name of a person, e.g. "Vivette Davis"
    # @param organizationUnit small organization name, e.g. "Purchasing"
    # @param organizationName large organization name, e.g. "Onizuka, Inc."
    # @param country two letter country code, e.g. "CH"
    def initialize(common_name, organization_unit, organization_name, country)
      @dn = nil
      @rfc1779dn = nil
      @rfc2253dn = nil
      @canonical_dn = nil
      @names = nil
      @x500principal = nil
      @encoded = nil
      @rdn_list = nil
      @all_ava_list = nil
      @names = Array.typed(RDN).new(4) { nil }
      # NOTE:  it's only on output that little-endian
      # ordering is used.
      @names[3] = RDN.new(1)
      @names[3].attr_assertion[0] = AVA.new(CommonName_oid, DerValue.new(common_name))
      @names[2] = RDN.new(1)
      @names[2].attr_assertion[0] = AVA.new(OrgUnitName_oid, DerValue.new(organization_unit))
      @names[1] = RDN.new(1)
      @names[1].attr_assertion[0] = AVA.new(OrgName_oid, DerValue.new(organization_name))
      @names[0] = RDN.new(1)
      @names[0].attr_assertion[0] = AVA.new(CountryName_oid, DerValue.new(country))
    end
    
    typesig { [String, String, String, String, String, String] }
    # Constructs a name from fields common in Internet application
    # environments.
    # 
    # <P><EM><STRONG>NOTE:</STRONG>  The behaviour when any of
    # these strings contain characters outside the ASCII range
    # is unspecified in currently relevant standards.</EM>
    # 
    # @param commonName common name of a person, e.g. "Vivette Davis"
    # @param organizationUnit small organization name, e.g. "Purchasing"
    # @param organizationName large organization name, e.g. "Onizuka, Inc."
    # @param localityName locality (city) name, e.g. "Palo Alto"
    # @param stateName state name, e.g. "California"
    # @param country two letter country code, e.g. "CH"
    def initialize(common_name, organization_unit, organization_name, locality_name, state_name, country)
      @dn = nil
      @rfc1779dn = nil
      @rfc2253dn = nil
      @canonical_dn = nil
      @names = nil
      @x500principal = nil
      @encoded = nil
      @rdn_list = nil
      @all_ava_list = nil
      @names = Array.typed(RDN).new(6) { nil }
      # NOTE:  it's only on output that little-endian
      # ordering is used.
      @names[5] = RDN.new(1)
      @names[5].attr_assertion[0] = AVA.new(CommonName_oid, DerValue.new(common_name))
      @names[4] = RDN.new(1)
      @names[4].attr_assertion[0] = AVA.new(OrgUnitName_oid, DerValue.new(organization_unit))
      @names[3] = RDN.new(1)
      @names[3].attr_assertion[0] = AVA.new(OrgName_oid, DerValue.new(organization_name))
      @names[2] = RDN.new(1)
      @names[2].attr_assertion[0] = AVA.new(LocalityName_oid, DerValue.new(locality_name))
      @names[1] = RDN.new(1)
      @names[1].attr_assertion[0] = AVA.new(StateName_oid, DerValue.new(state_name))
      @names[0] = RDN.new(1)
      @names[0].attr_assertion[0] = AVA.new(CountryName_oid, DerValue.new(country))
    end
    
    typesig { [Array.typed(RDN)] }
    # Constructs a name from an array of relative distinguished names
    # 
    # @param rdnArray array of relative distinguished names
    # @throws IOException on error
    def initialize(rdn_array)
      @dn = nil
      @rfc1779dn = nil
      @rfc2253dn = nil
      @canonical_dn = nil
      @names = nil
      @x500principal = nil
      @encoded = nil
      @rdn_list = nil
      @all_ava_list = nil
      if ((rdn_array).nil?)
        @names = Array.typed(RDN).new(0) { nil }
      else
        @names = rdn_array.clone
        i = 0
        while i < @names.attr_length
          if ((@names[i]).nil?)
            raise IOException.new("Cannot create an X500Name")
          end
          i += 1
        end
      end
    end
    
    typesig { [DerValue] }
    # Constructs a name from an ASN.1 encoded value.  The encoding
    # of the name in the stream uses DER (a BER/1 subset).
    # 
    # @param value a DER-encoded value holding an X.500 name.
    def initialize(value)
      # Note that toDerInputStream uses only the buffer (data) and not
      # the tag, so an empty SEQUENCE (OF) will yield an empty DerInputStream
      initialize__x500name(value.to_der_input_stream)
    end
    
    typesig { [DerInputStream] }
    # Constructs a name from an ASN.1 encoded input stream.  The encoding
    # of the name in the stream uses DER (a BER/1 subset).
    # 
    # @param in DER-encoded data holding an X.500 name.
    def initialize(in_)
      @dn = nil
      @rfc1779dn = nil
      @rfc2253dn = nil
      @canonical_dn = nil
      @names = nil
      @x500principal = nil
      @encoded = nil
      @rdn_list = nil
      @all_ava_list = nil
      parse_der(in_)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs a name from an ASN.1 encoded byte array.
    # 
    # @param name DER-encoded byte array holding an X.500 name.
    def initialize(name)
      @dn = nil
      @rfc1779dn = nil
      @rfc2253dn = nil
      @canonical_dn = nil
      @names = nil
      @x500principal = nil
      @encoded = nil
      @rdn_list = nil
      @all_ava_list = nil
      in_ = DerInputStream.new(name)
      parse_der(in_)
    end
    
    typesig { [] }
    # Return an immutable List of all RDNs in this X500Name.
    def rdns
      list = @rdn_list
      if ((list).nil?)
        list = Collections.unmodifiable_list(Arrays.as_list(@names))
        @rdn_list = list
      end
      return list
    end
    
    typesig { [] }
    # Return the number of RDNs in this X500Name.
    def size
      return @names.attr_length
    end
    
    typesig { [] }
    # Return an immutable List of the the AVAs contained in all the
    # RDNs of this X500Name.
    def all_avas
      list = @all_ava_list
      if ((list).nil?)
        list = ArrayList.new
        i = 0
        while i < @names.attr_length
          list.add_all(@names[i].avas)
          i += 1
        end
      end
      return list
    end
    
    typesig { [] }
    # Return the total number of AVAs contained in all the RDNs of
    # this X500Name.
    def ava_size
      return all_avas.size
    end
    
    typesig { [] }
    # Return whether this X500Name is empty. An X500Name is not empty
    # if it has at least one RDN containing at least one AVA.
    def is_empty
      n = @names.attr_length
      if ((n).equal?(0))
        return true
      end
      i = 0
      while i < n
        if (!(@names[i].attr_assertion.attr_length).equal?(0))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Calculates a hash code value for the object.  Objects
    # which are equal will also have the same hashcode.
    def hash_code
      return get_rfc2253canonical_name.hash_code
    end
    
    typesig { [Object] }
    # Compares this name with another, for equality.
    # 
    # @return true iff the names are identical.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(X500Name)).equal?(false))
        return false
      end
      other = obj
      # if we already have the canonical forms, compare now
      if ((!(@canonical_dn).nil?) && (!(other.attr_canonical_dn).nil?))
        return (@canonical_dn == other.attr_canonical_dn)
      end
      # quick check that number of RDNs and AVAs match before canonicalizing
      n = @names.attr_length
      if (!(n).equal?(other.attr_names.attr_length))
        return false
      end
      i = 0
      while i < n
        r1 = @names[i]
        r2 = other.attr_names[i]
        if (!(r1.attr_assertion.attr_length).equal?(r2.attr_assertion.attr_length))
          return false
        end
        i += 1
      end
      # definite check via canonical form
      this_canonical = self.get_rfc2253canonical_name
      other_canonical = other.get_rfc2253canonical_name
      return (this_canonical == other_canonical)
    end
    
    typesig { [DerValue] }
    # Returns the name component as a Java string, regardless of its
    # encoding restrictions.
    def get_string(attribute)
      if ((attribute).nil?)
        return nil
      end
      value = attribute.get_as_string
      if ((value).nil?)
        raise IOException.new("not a DER string encoding, " + RJava.cast_to_string(attribute.attr_tag))
      else
        return value
      end
    end
    
    typesig { [] }
    # Return type of GeneralName.
    def get_type
      return (GeneralNameInterface::NAME_DIRECTORY)
    end
    
    typesig { [] }
    # Returns a "Country" name component.  If more than one
    # such attribute exists, the topmost one is returned.
    # 
    # @return "C=" component of the name, if any.
    def get_country
      attr = find_attribute(CountryName_oid)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns an "Organization" name component.  If more than
    # one such attribute exists, the topmost one is returned.
    # 
    # @return "O=" component of the name, if any.
    def get_organization
      attr = find_attribute(OrgName_oid)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns an "Organizational Unit" name component.  If more
    # than one such attribute exists, the topmost one is returned.
    # 
    # @return "OU=" component of the name, if any.
    def get_organizational_unit
      attr = find_attribute(OrgUnitName_oid)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "Common Name" component.  If more than one such
    # attribute exists, the topmost one is returned.
    # 
    # @return "CN=" component of the name, if any.
    def get_common_name
      attr = find_attribute(CommonName_oid)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "Locality" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "L=" component of the name, if any.
    def get_locality
      attr = find_attribute(LocalityName_oid)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "State" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "S=" component of the name, if any.
    def get_state
      attr = find_attribute(StateName_oid)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "Domain" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "DC=" component of the name, if any.
    def get_domain
      attr = find_attribute(DOMAIN_COMPONENT_OID)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "DN Qualifier" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "DNQ=" component of the name, if any.
    def get_dnqualifier
      attr = find_attribute(DNQUALIFIER_OID)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "Surname" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "SURNAME=" component of the name, if any.
    def get_surname
      attr = find_attribute(SURNAME_OID)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "Given Name" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "GIVENNAME=" component of the name, if any.
    def get_given_name
      attr = find_attribute(GIVENNAME_OID)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns an "Initials" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "INITIALS=" component of the name, if any.
    def get_initials
      attr = find_attribute(INITIALS_OID)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a "Generation Qualifier" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "GENERATION=" component of the name, if any.
    def get_generation
      attr = find_attribute(GENERATIONQUALIFIER_OID)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns an "IP address" name component.  If more than one
    # such component exists, the topmost one is returned.
    # 
    # @return "IP=" component of the name, if any.
    def get_ip
      attr = find_attribute(IpAddress_oid)
      return get_string(attr)
    end
    
    typesig { [] }
    # Returns a string form of the X.500 distinguished name.
    # The format of the string is from RFC 1779. The returned string
    # may contain non-standardised keywords for more readability
    # (keywords from RFCs 1779, 2253, and 3280).
    def to_s
      if ((@dn).nil?)
        generate_dn
      end
      return @dn
    end
    
    typesig { [] }
    # Returns a string form of the X.500 distinguished name
    # using the algorithm defined in RFC 1779. Only standard attribute type
    # keywords defined in RFC 1779 are emitted.
    def get_rfc1779name
      return get_rfc1779name(Collections.empty_map)
    end
    
    typesig { [Map] }
    # Returns a string form of the X.500 distinguished name
    # using the algorithm defined in RFC 1779. Attribute type
    # keywords defined in RFC 1779 are emitted, as well as additional
    # keywords contained in the OID/keyword map.
    def get_rfc1779name(oid_map)
      if (oid_map.is_empty)
        # return cached result
        if (!(@rfc1779dn).nil?)
          return @rfc1779dn
        else
          @rfc1779dn = RJava.cast_to_string(generate_rfc1779dn(oid_map))
          return @rfc1779dn
        end
      end
      return generate_rfc1779dn(oid_map)
    end
    
    typesig { [] }
    # Returns a string form of the X.500 distinguished name
    # using the algorithm defined in RFC 2253. Only standard attribute type
    # keywords defined in RFC 2253 are emitted.
    def get_rfc2253name
      return get_rfc2253name(Collections.empty_map)
    end
    
    typesig { [Map] }
    # Returns a string form of the X.500 distinguished name
    # using the algorithm defined in RFC 2253. Attribute type
    # keywords defined in RFC 2253 are emitted, as well as additional
    # keywords contained in the OID/keyword map.
    def get_rfc2253name(oid_map)
      # check for and return cached name
      if (oid_map.is_empty)
        if (!(@rfc2253dn).nil?)
          return @rfc2253dn
        else
          @rfc2253dn = RJava.cast_to_string(generate_rfc2253dn(oid_map))
          return @rfc2253dn
        end
      end
      return generate_rfc2253dn(oid_map)
    end
    
    typesig { [Map] }
    def generate_rfc2253dn(oid_map)
      # Section 2.1 : if the RDNSequence is an empty sequence
      # the result is the empty or zero length string.
      if ((@names.attr_length).equal?(0))
        return ""
      end
      # 2.1 (continued) : Otherwise, the output consists of the string
      # encodings of each RelativeDistinguishedName in the RDNSequence
      # (according to 2.2), starting with the last element of the sequence
      # and moving backwards toward the first.
      # 
      # The encodings of adjoining RelativeDistinguishedNames are separated
      # by a comma character (',' ASCII 44).
      fullname = StringBuilder.new(48)
      i = @names.attr_length - 1
      while i >= 0
        if (i < @names.attr_length - 1)
          fullname.append(Character.new(?,.ord))
        end
        fullname.append(@names[i].to_rfc2253string(oid_map))
        i -= 1
      end
      return fullname.to_s
    end
    
    typesig { [] }
    def get_rfc2253canonical_name
      # check for and return cached name
      if (!(@canonical_dn).nil?)
        return @canonical_dn
      end
      # Section 2.1 : if the RDNSequence is an empty sequence
      # the result is the empty or zero length string.
      if ((@names.attr_length).equal?(0))
        @canonical_dn = ""
        return @canonical_dn
      end
      # 2.1 (continued) : Otherwise, the output consists of the string
      # encodings of each RelativeDistinguishedName in the RDNSequence
      # (according to 2.2), starting with the last element of the sequence
      # and moving backwards toward the first.
      # 
      # The encodings of adjoining RelativeDistinguishedNames are separated
      # by a comma character (',' ASCII 44).
      fullname = StringBuilder.new(48)
      i = @names.attr_length - 1
      while i >= 0
        if (i < @names.attr_length - 1)
          fullname.append(Character.new(?,.ord))
        end
        fullname.append(@names[i].to_rfc2253string(true))
        i -= 1
      end
      @canonical_dn = RJava.cast_to_string(fullname.to_s)
      return @canonical_dn
    end
    
    typesig { [] }
    # Returns the value of toString().  This call is needed to
    # implement the java.security.Principal interface.
    def get_name
      return to_s
    end
    
    typesig { [ObjectIdentifier] }
    # Find the first instance of this attribute in a "top down"
    # search of all the attributes in the name.
    def find_attribute(attribute)
      if (!(@names).nil?)
        i = 0
        while i < @names.attr_length
          value = @names[i].find_attribute(attribute)
          if (!(value).nil?)
            return value
          end
          i += 1
        end
      end
      return nil
    end
    
    typesig { [ObjectIdentifier] }
    # Find the most specific ("last") attribute of the given
    # type.
    def find_most_specific_attribute(attribute)
      if (!(@names).nil?)
        i = @names.attr_length - 1
        while i >= 0
          value = @names[i].find_attribute(attribute)
          if (!(value).nil?)
            return value
          end
          i -= 1
        end
      end
      return nil
    end
    
    typesig { [DerInputStream] }
    def parse_der(in_)
      # X.500 names are a "SEQUENCE OF" RDNs, which means zero or
      # more and order matters.  We scan them in order, which
      # conventionally is big-endian.
      nameseq = nil
      der_bytes = in_.to_byte_array
      begin
        nameseq = in_.get_sequence(5)
      rescue IOException => ioe
        if ((der_bytes).nil?)
          nameseq = nil
        else
          der_val = DerValue.new(DerValue.attr_tag_sequence, der_bytes)
          der_bytes = der_val.to_byte_array
          nameseq = DerInputStream.new(der_bytes).get_sequence(5)
        end
      end
      if ((nameseq).nil?)
        @names = Array.typed(RDN).new(0) { nil }
      else
        @names = Array.typed(RDN).new(nameseq.attr_length) { nil }
        i = 0
        while i < nameseq.attr_length
          @names[i] = RDN.new(nameseq[i])
          i += 1
        end
      end
    end
    
    typesig { [DerOutputStream] }
    # Encodes the name in DER-encoded form.
    # 
    # @deprecated Use encode() instead
    # @param out where to put the DER-encoded X.500 name
    def emit(out)
      encode(out)
    end
    
    typesig { [DerOutputStream] }
    # Encodes the name in DER-encoded form.
    # 
    # @param out where to put the DER-encoded X.500 name
    def encode(out)
      tmp = DerOutputStream.new
      i = 0
      while i < @names.attr_length
        @names[i].encode(tmp)
        i += 1
      end
      out.write(DerValue.attr_tag_sequence, tmp)
    end
    
    typesig { [] }
    # Returned the encoding as an uncloned byte array. Callers must
    # guarantee that they neither modify it not expose it to untrusted
    # code.
    def get_encoded_internal
      if ((@encoded).nil?)
        out = DerOutputStream.new
        tmp = DerOutputStream.new
        i = 0
        while i < @names.attr_length
          @names[i].encode(tmp)
          i += 1
        end
        out.write(DerValue.attr_tag_sequence, tmp)
        @encoded = out.to_byte_array
      end
      return @encoded
    end
    
    typesig { [] }
    # Gets the name in DER-encoded form.
    # 
    # @return the DER encoded byte array of this name.
    def get_encoded
      return get_encoded_internal.clone
    end
    
    typesig { [String, Map] }
    # Parses a Distinguished Name (DN) in printable representation.
    # 
    # According to RFC 1779, RDNs in a DN are separated by comma.
    # The following examples show both methods of quoting a comma, so that it
    # is not considered a separator:
    # 
    # O="Sue, Grabbit and Runn" or
    # O=Sue\, Grabbit and Runn
    # 
    # This method can parse 1779 or 2253 DNs and non-standard 3280 keywords.
    # Additional keywords can be specified in the keyword/OID map.
    def parse_dn(input, keyword_map)
      if ((input).nil? || (input.length).equal?(0))
        @names = Array.typed(RDN).new(0) { nil }
        return
      end
      dn_vector = ArrayList.new
      dn_offset = 0
      rdn_end = 0
      rdn_string = nil
      quote_count = 0
      dn_string = input
      search_offset = 0
      next_comma = dn_string.index_of(Character.new(?,.ord))
      next_semi_colon = dn_string.index_of(Character.new(?;.ord))
      while (next_comma >= 0 || next_semi_colon >= 0)
        if (next_semi_colon < 0)
          rdn_end = next_comma
        else
          if (next_comma < 0)
            rdn_end = next_semi_colon
          else
            rdn_end = Math.min(next_comma, next_semi_colon)
          end
        end
        quote_count += count_quotes(dn_string, search_offset, rdn_end)
        # We have encountered an RDN delimiter (comma or a semicolon).
        # If the comma or semicolon in the RDN under consideration is
        # preceded by a backslash (escape), or by a double quote, it
        # is part of the RDN. Otherwise, it is used as a separator, to
        # delimit the RDN under consideration from any subsequent RDNs.
        if (rdn_end >= 0 && !(quote_count).equal?(1) && !escaped(rdn_end, search_offset, dn_string))
          # Comma/semicolon is a separator
          rdn_string = RJava.cast_to_string(dn_string.substring(dn_offset, rdn_end))
          # Parse RDN, and store it in vector
          rdn = RDN.new(rdn_string, keyword_map)
          dn_vector.add(rdn)
          # Increase the offset
          dn_offset = rdn_end + 1
          # Set quote counter back to zero
          quote_count = 0
        end
        search_offset = rdn_end + 1
        next_comma = dn_string.index_of(Character.new(?,.ord), search_offset)
        next_semi_colon = dn_string.index_of(Character.new(?;.ord), search_offset)
      end
      # Parse last or only RDN, and store it in vector
      rdn_string = RJava.cast_to_string(dn_string.substring(dn_offset))
      rdn = RDN.new(rdn_string, keyword_map)
      dn_vector.add(rdn)
      # Store the vector elements as an array of RDNs
      # NOTE: It's only on output that little-endian ordering is used.
      Collections.reverse(dn_vector)
      @names = dn_vector.to_array(Array.typed(RDN).new(dn_vector.size) { nil })
    end
    
    typesig { [String] }
    def parse_rfc2253dn(dn_string)
      if ((dn_string.length).equal?(0))
        @names = Array.typed(RDN).new(0) { nil }
        return
      end
      dn_vector = ArrayList.new
      dn_offset = 0
      rdn_string = nil
      search_offset = 0
      rdn_end = dn_string.index_of(Character.new(?,.ord))
      while (rdn_end >= 0)
        # We have encountered an RDN delimiter (comma).
        # If the comma in the RDN under consideration is
        # preceded by a backslash (escape), it
        # is part of the RDN. Otherwise, it is used as a separator, to
        # delimit the RDN under consideration from any subsequent RDNs.
        if (rdn_end > 0 && !escaped(rdn_end, search_offset, dn_string))
          # Comma is a separator
          rdn_string = RJava.cast_to_string(dn_string.substring(dn_offset, rdn_end))
          # Parse RDN, and store it in vector
          rdn = RDN.new(rdn_string, "RFC2253")
          dn_vector.add(rdn)
          # Increase the offset
          dn_offset = rdn_end + 1
        end
        search_offset = rdn_end + 1
        rdn_end = dn_string.index_of(Character.new(?,.ord), search_offset)
      end
      # Parse last or only RDN, and store it in vector
      rdn_string = RJava.cast_to_string(dn_string.substring(dn_offset))
      rdn = RDN.new(rdn_string, "RFC2253")
      dn_vector.add(rdn)
      # Store the vector elements as an array of RDNs
      # NOTE: It's only on output that little-endian ordering is used.
      Collections.reverse(dn_vector)
      @names = dn_vector.to_array(Array.typed(RDN).new(dn_vector.size) { nil })
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Int, ::Java::Int] }
      # Counts double quotes in string.
      # Escaped quotes are ignored.
      def count_quotes(string, from, to)
        count = 0
        i = from
        while i < to
          if (((string.char_at(i)).equal?(Character.new(?".ord)) && (i).equal?(from)) || ((string.char_at(i)).equal?(Character.new(?".ord)) && !(string.char_at(i - 1)).equal?(Character.new(?\\.ord))))
            count += 1
          end
          i += 1
        end
        return count
      end
      
      typesig { [::Java::Int, ::Java::Int, String] }
      def escaped(rdn_end, search_offset, dn_string)
        if ((rdn_end).equal?(1) && (dn_string.char_at(rdn_end - 1)).equal?(Character.new(?\\.ord)))
          # case 1:
          # \,
          return true
        else
          if (rdn_end > 1 && (dn_string.char_at(rdn_end - 1)).equal?(Character.new(?\\.ord)) && !(dn_string.char_at(rdn_end - 2)).equal?(Character.new(?\\.ord)))
            # case 2:
            # foo\,
            return true
          else
            if (rdn_end > 1 && (dn_string.char_at(rdn_end - 1)).equal?(Character.new(?\\.ord)) && (dn_string.char_at(rdn_end - 2)).equal?(Character.new(?\\.ord)))
              # case 3:
              # foo\\\\\,
              count = 0
              rdn_end -= 1 # back up to last backSlash
              while (rdn_end >= search_offset)
                if ((dn_string.char_at(rdn_end)).equal?(Character.new(?\\.ord)))
                  count += 1 # count consecutive backslashes
                end
                rdn_end -= 1
              end
              # if count is odd, then rdnEnd is escaped
              return !((count % 2)).equal?(0) ? true : false
            else
              return false
            end
          end
        end
      end
    }
    
    typesig { [] }
    # Dump the printable form of a distinguished name.  Each relative
    # name is separated from the next by a ",", and assertions in the
    # relative names have "label=value" syntax.
    # 
    # Uses RFC 1779 syntax (i.e. little-endian, comma separators)
    def generate_dn
      if ((@names.attr_length).equal?(1))
        @dn = RJava.cast_to_string(@names[0].to_s)
        return
      end
      sb = StringBuilder.new(48)
      if (!(@names).nil?)
        i = @names.attr_length - 1
        while i >= 0
          if (!(i).equal?(@names.attr_length - 1))
            sb.append(", ")
          end
          sb.append(@names[i].to_s)
          i -= 1
        end
      end
      @dn = RJava.cast_to_string(sb.to_s)
    end
    
    typesig { [Map] }
    # Dump the printable form of a distinguished name.  Each relative
    # name is separated from the next by a ",", and assertions in the
    # relative names have "label=value" syntax.
    # 
    # Uses RFC 1779 syntax (i.e. little-endian, comma separators)
    # Valid keywords from RFC 1779 are used. Additional keywords can be
    # specified in the OID/keyword map.
    def generate_rfc1779dn(oid_map)
      if ((@names.attr_length).equal?(1))
        return @names[0].to_rfc1779string(oid_map)
      end
      sb = StringBuilder.new(48)
      if (!(@names).nil?)
        i = @names.attr_length - 1
        while i >= 0
          if (!(i).equal?(@names.attr_length - 1))
            sb.append(", ")
          end
          sb.append(@names[i].to_rfc1779string(oid_map))
          i -= 1
        end
      end
      return sb.to_s
    end
    
    class_module.module_eval {
      typesig { [ObjectIdentifier] }
      # Maybe return a preallocated OID, to reduce storage costs
      # and speed recognition of common X.500 attributes.
      def intern(oid)
        interned = InternedOIDs.get(oid)
        if (!(interned).nil?)
          return interned
        end
        InternedOIDs.put(oid, oid)
        return oid
      end
      
      const_set_lazy(:InternedOIDs) { HashMap.new }
      const_attr_reader  :InternedOIDs
      
      # Selected OIDs from X.520
      # Includes all those specified in RFC 3280 as MUST or SHOULD
      # be recognized
      const_set_lazy(:CommonName_data) { Array.typed(::Java::Int).new([2, 5, 4, 3]) }
      const_attr_reader  :CommonName_data
      
      const_set_lazy(:SURNAME_DATA) { Array.typed(::Java::Int).new([2, 5, 4, 4]) }
      const_attr_reader  :SURNAME_DATA
      
      const_set_lazy(:SERIALNUMBER_DATA) { Array.typed(::Java::Int).new([2, 5, 4, 5]) }
      const_attr_reader  :SERIALNUMBER_DATA
      
      const_set_lazy(:CountryName_data) { Array.typed(::Java::Int).new([2, 5, 4, 6]) }
      const_attr_reader  :CountryName_data
      
      const_set_lazy(:LocalityName_data) { Array.typed(::Java::Int).new([2, 5, 4, 7]) }
      const_attr_reader  :LocalityName_data
      
      const_set_lazy(:StateName_data) { Array.typed(::Java::Int).new([2, 5, 4, 8]) }
      const_attr_reader  :StateName_data
      
      const_set_lazy(:StreetAddress_data) { Array.typed(::Java::Int).new([2, 5, 4, 9]) }
      const_attr_reader  :StreetAddress_data
      
      const_set_lazy(:OrgName_data) { Array.typed(::Java::Int).new([2, 5, 4, 10]) }
      const_attr_reader  :OrgName_data
      
      const_set_lazy(:OrgUnitName_data) { Array.typed(::Java::Int).new([2, 5, 4, 11]) }
      const_attr_reader  :OrgUnitName_data
      
      const_set_lazy(:Title_data) { Array.typed(::Java::Int).new([2, 5, 4, 12]) }
      const_attr_reader  :Title_data
      
      const_set_lazy(:GIVENNAME_DATA) { Array.typed(::Java::Int).new([2, 5, 4, 42]) }
      const_attr_reader  :GIVENNAME_DATA
      
      const_set_lazy(:INITIALS_DATA) { Array.typed(::Java::Int).new([2, 5, 4, 43]) }
      const_attr_reader  :INITIALS_DATA
      
      const_set_lazy(:GENERATIONQUALIFIER_DATA) { Array.typed(::Java::Int).new([2, 5, 4, 44]) }
      const_attr_reader  :GENERATIONQUALIFIER_DATA
      
      const_set_lazy(:DNQUALIFIER_DATA) { Array.typed(::Java::Int).new([2, 5, 4, 46]) }
      const_attr_reader  :DNQUALIFIER_DATA
      
      const_set_lazy(:IpAddress_data) { Array.typed(::Java::Int).new([1, 3, 6, 1, 4, 1, 42, 2, 11, 2, 1]) }
      const_attr_reader  :IpAddress_data
      
      const_set_lazy(:DOMAIN_COMPONENT_DATA) { Array.typed(::Java::Int).new([0, 9, 2342, 19200300, 100, 1, 25]) }
      const_attr_reader  :DOMAIN_COMPONENT_DATA
      
      const_set_lazy(:Userid_data) { Array.typed(::Java::Int).new([0, 9, 2342, 19200300, 100, 1, 1]) }
      const_attr_reader  :Userid_data
      
      when_class_loaded do
        # OID for the "CN=" attribute, denoting a person's common name.
        const_set :CommonName_oid, intern(ObjectIdentifier.new_internal(CommonName_data))
        # OID for the "SERIALNUMBER=" attribute, denoting a serial number for.
        # a name. Do not confuse with PKCS#9 issuerAndSerialNumber or the
        # certificate serial number.
        const_set :SERIALNUMBER_OID, intern(ObjectIdentifier.new_internal(SERIALNUMBER_DATA))
        # OID for the "C=" attribute, denoting a country.
        const_set :CountryName_oid, intern(ObjectIdentifier.new_internal(CountryName_data))
        # OID for the "L=" attribute, denoting a locality (such as a city)
        const_set :LocalityName_oid, intern(ObjectIdentifier.new_internal(LocalityName_data))
        # OID for the "O=" attribute, denoting an organization name
        const_set :OrgName_oid, intern(ObjectIdentifier.new_internal(OrgName_data))
        # OID for the "OU=" attribute, denoting an organizational unit name
        const_set :OrgUnitName_oid, intern(ObjectIdentifier.new_internal(OrgUnitName_data))
        # OID for the "S=" attribute, denoting a state (such as Delaware)
        const_set :StateName_oid, intern(ObjectIdentifier.new_internal(StateName_data))
        # OID for the "STREET=" attribute, denoting a street address.
        const_set :StreetAddress_oid, intern(ObjectIdentifier.new_internal(StreetAddress_data))
        # OID for the "T=" attribute, denoting a person's title.
        const_set :Title_oid, intern(ObjectIdentifier.new_internal(Title_data))
        # OID for the "DNQUALIFIER=" or "DNQ=" attribute, denoting DN
        # disambiguating information.
        const_set :DNQUALIFIER_OID, intern(ObjectIdentifier.new_internal(DNQUALIFIER_DATA))
        # OID for the "SURNAME=" attribute, denoting a person's surname.
        const_set :SURNAME_OID, intern(ObjectIdentifier.new_internal(SURNAME_DATA))
        # OID for the "GIVENNAME=" attribute, denoting a person's given name.
        const_set :GIVENNAME_OID, intern(ObjectIdentifier.new_internal(GIVENNAME_DATA))
        # OID for the "INITIALS=" attribute, denoting a person's initials.
        const_set :INITIALS_OID, intern(ObjectIdentifier.new_internal(INITIALS_DATA))
        # OID for the "GENERATION=" attribute, denoting Jr., II, etc.
        const_set :GENERATIONQUALIFIER_OID, intern(ObjectIdentifier.new_internal(GENERATIONQUALIFIER_DATA))
        # OIDs from other sources which show up in X.500 names we
        # expect to deal with often
        # 
        # OID for "IP=" IP address attributes, used with SKIP.
        const_set :IpAddress_oid, intern(ObjectIdentifier.new_internal(IpAddress_data))
        # Domain component OID from RFC 1274, RFC 2247, RFC 3280
        # 
        # 
        # OID for "DC=" domain component attributes, used with DNS names in DN
        # format
        const_set :DOMAIN_COMPONENT_OID, intern(ObjectIdentifier.new_internal(DOMAIN_COMPONENT_DATA))
        # OID for "UID=" denoting a user id, defined in RFCs 1274 & 2798.
        const_set :Userid_oid, intern(ObjectIdentifier.new_internal(Userid_data))
      end
    }
    
    typesig { [GeneralNameInterface] }
    # Return constraint type:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from this name
    # (i.e. does not constrain)
    # <li>NAME_MATCH = 0: input name matches this name
    # <li>NAME_NARROWS = 1: input name narrows this name
    # <li>NAME_WIDENS = 2: input name widens this name
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow this name,
    # &       but is same type
    # </ul>.  These results are used in checking NameConstraints during
    # certification path verification.
    # 
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is not exact match, but
    # narrowing and widening are not supported for this name type.
    def constrains(input_name)
      constraint_type = 0
      if ((input_name).nil?)
        constraint_type = NAME_DIFF_TYPE
      else
        if (!(input_name.get_type).equal?(NAME_DIRECTORY))
          constraint_type = NAME_DIFF_TYPE
        else
          # type == NAME_DIRECTORY
          input_x500 = input_name
          if ((input_x500 == self))
            constraint_type = NAME_MATCH
          else
            if ((input_x500.attr_names.attr_length).equal?(0))
              constraint_type = NAME_WIDENS
            else
              if ((@names.attr_length).equal?(0))
                constraint_type = NAME_NARROWS
              else
                if (input_x500.is_within_subtree(self))
                  constraint_type = NAME_NARROWS
                else
                  if (is_within_subtree(input_x500))
                    constraint_type = NAME_WIDENS
                  else
                    constraint_type = NAME_SAME_TYPE
                  end
                end
              end
            end
          end
        end
      end
      return constraint_type
    end
    
    typesig { [X500Name] }
    # Compares this name with another and determines if
    # it is within the subtree of the other. Useful for
    # checking against the name constraints extension.
    # 
    # @return true iff this name is within the subtree of other.
    def is_within_subtree(other)
      if ((self).equal?(other))
        return true
      end
      if ((other).nil?)
        return false
      end
      if ((other.attr_names.attr_length).equal?(0))
        return true
      end
      if ((@names.attr_length).equal?(0))
        return false
      end
      if (@names.attr_length < other.attr_names.attr_length)
        return false
      end
      i = 0
      while i < other.attr_names.attr_length
        if (!(@names[i] == other.attr_names[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds and for calculating
    # path lengths in name subtrees.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      return @names.attr_length
    end
    
    typesig { [X500Name] }
    # Return lowest common ancestor of this name and other name
    # 
    # @param other another X500Name
    # @return X500Name of lowest common ancestor; null if none
    def common_ancestor(other)
      if ((other).nil?)
        return nil
      end
      other_len = other.attr_names.attr_length
      this_len = @names.attr_length
      if ((this_len).equal?(0) || (other_len).equal?(0))
        return nil
      end
      min_len = (this_len < other_len) ? this_len : other_len
      # Compare names from highest RDN down the naming tree
      # Note that these are stored in RDN[0]...
      i = 0
      while i < min_len
        if (!(@names[i] == other.attr_names[i]))
          if ((i).equal?(0))
            return nil
          else
            break
          end
        end
        i += 1
      end
      # Copy matching RDNs into new RDN array
      ancestor = Array.typed(RDN).new(i) { nil }
      j = 0
      while j < i
        ancestor[j] = @names[j]
        j += 1
      end
      common_ancestor = nil
      begin
        common_ancestor = X500Name.new(ancestor)
      rescue IOException => ioe
        return nil
      end
      return common_ancestor
    end
    
    class_module.module_eval {
      # Retrieve the Constructor and Field we need for reflective access
      # and make them accessible.
      when_class_loaded do
        pa = Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members X500Name
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            p_class = X500Principal
            args = Array.typed(self.class::Class).new([X500Name])
            cons = (p_class).get_declared_constructor(args)
            cons.set_accessible(true)
            field = p_class.get_declared_field("thisX500Name")
            field.set_accessible(true)
            return Array.typed(Object).new([cons, field])
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        begin
          result = AccessController.do_privileged(pa)
          const_set :PrincipalConstructor, result[0]
          const_set :PrincipalField, result[1]
        rescue JavaException => e
          raise InternalError.new("Could not obtain " + "X500Principal access").init_cause(e)
        end
      end
    }
    
    typesig { [] }
    # Get an X500Principal backed by this X500Name.
    # 
    # Note that we are using privileged reflection to access the hidden
    # package private constructor in X500Principal.
    def as_x500principal
      if ((@x500principal).nil?)
        begin
          args = Array.typed(Object).new([self])
          @x500principal = PrincipalConstructor.new_instance(args)
        rescue JavaException => e
          raise RuntimeException.new("Unexpected exception", e)
        end
      end
      return @x500principal
    end
    
    class_module.module_eval {
      typesig { [X500Principal] }
      # Get the X500Name contained in the given X500Principal.
      # 
      # Note that the X500Name is retrieved using reflection.
      def as_x500name(p)
        begin
          name = PrincipalField.get(p)
          name.attr_x500principal = p
          return name
        rescue JavaException => e
          raise RuntimeException.new("Unexpected exception", e)
        end
      end
    }
    
    private
    alias_method :initialize__x500name, :initialize
  end
  
end
