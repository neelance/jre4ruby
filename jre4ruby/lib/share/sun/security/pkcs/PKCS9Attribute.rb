require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs
  module PKCS9AttributeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :Hashtable
      include_const ::Sun::Security::X509, :CertificateExtensions
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerEncoder
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # Class supporting any PKCS9 attributes.
  # Supports DER decoding and access to attribute values, but not
  # DER encoding or setting of values.
  # 
  # <a name="classTable"><h3>Type/Class Table</h3></a>
  # The following table shows the correspondence between
  # PKCS9 attribute types and value component classes.
  # 
  # <P>
  # <TABLE BORDER CELLPADDING=8 ALIGN=CENTER>
  # 
  # <TR>
  # <TH>Object Identifier</TH>
  # <TH>Attribute Name</TH>
  # <TH>Type</TH>
  # <TH>Value Class</TH>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.1</TD>
  # <TD>EmailAddress</TD>
  # <TD>Multi-valued</TD>
  # <TD><code>String[]</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.2</TD>
  # <TD>UnstructuredName</TD>
  # <TD>Multi-valued</TD>
  # <TD><code>String[]</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.3</TD>
  # <TD>ContentType</TD>
  # <TD>Single-valued</TD>
  # <TD><code>ObjectIdentifier</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.4</TD>
  # <TD>MessageDigest</TD>
  # <TD>Single-valued</TD>
  # <TD><code>byte[]</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.5</TD>
  # <TD>SigningTime</TD>
  # <TD>Single-valued</TD>
  # <TD><code>Date</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.6</TD>
  # <TD>Countersignature</TD>
  # <TD>Multi-valued</TD>
  # <TD><code>SignerInfo[]</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.7</TD>
  # <TD>ChallengePassword</TD>
  # <TD>Single-valued</TD>
  # <TD><code>String</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.8</TD>
  # <TD>UnstructuredAddress</TD>
  # <TD>Single-valued</TD>
  # <TD><code>String</code></TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.9</TD>
  # <TD>ExtendedCertificateAttributes</TD>
  # <TD>Multi-valued</TD>
  # <TD>(not supported)</TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.10</TD>
  # <TD>IssuerAndSerialNumber</TD>
  # <TD>Single-valued</TD>
  # <TD>(not supported)</TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.{11,12}</TD>
  # <TD>RSA DSI proprietary</TD>
  # <TD>Single-valued</TD>
  # <TD>(not supported)</TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.13</TD>
  # <TD>S/MIME unused assignment</TD>
  # <TD>Single-valued</TD>
  # <TD>(not supported)</TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.14</TD>
  # <TD>ExtensionRequest</TD>
  # <TD>Single-valued</TD>
  # <TD>CertificateExtensions</TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.15</TD>
  # <TD>SMIMECapability</TD>
  # <TD>Single-valued</TD>
  # <TD>(not supported)</TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.16.2.12</TD>
  # <TD>SigningCertificate</TD>
  # <TD>Single-valued</TD>
  # <TD>SigningCertificateInfo</TD>
  # </TR>
  # 
  # <TR>
  # <TD>1.2.840.113549.1.9.16.2.14</TD>
  # <TD>SignatureTimestampToken</TD>
  # <TD>Single-valued</TD>
  # <TD>byte[]</TD>
  # </TR>
  # 
  # </TABLE>
  # 
  # @author Douglas Hoover
  class PKCS9Attribute 
    include_class_members PKCS9AttributeImports
    include DerEncoder
    
    class_module.module_eval {
      # Are we debugging ?
      const_set_lazy(:Debug) { Debug.get_instance("jar") }
      const_attr_reader  :Debug
      
      # Array of attribute OIDs defined in PKCS9, by number.
      const_set_lazy(:PKCS9_OIDS) { Array.typed(ObjectIdentifier).new(18) { nil } }
      const_attr_reader  :PKCS9_OIDS
      
      when_class_loaded do
        # static initializer for PKCS9_OIDS
        i = 1
        while i < PKCS9_OIDS.attr_length - 2
          PKCS9_OIDS[i] = ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 9, i]))
          i += 1
        end
        # Initialize SigningCertificate and SignatureTimestampToken
        # separately (because their values are out of sequence)
        PKCS9_OIDS[PKCS9_OIDS.attr_length - 2] = ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 9, 16, 2, 12]))
        PKCS9_OIDS[PKCS9_OIDS.attr_length - 1] = ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 9, 16, 2, 14]))
      end
      
      # first element [0] not used
      const_set_lazy(:EMAIL_ADDRESS_OID) { PKCS9_OIDS[1] }
      const_attr_reader  :EMAIL_ADDRESS_OID
      
      const_set_lazy(:UNSTRUCTURED_NAME_OID) { PKCS9_OIDS[2] }
      const_attr_reader  :UNSTRUCTURED_NAME_OID
      
      const_set_lazy(:CONTENT_TYPE_OID) { PKCS9_OIDS[3] }
      const_attr_reader  :CONTENT_TYPE_OID
      
      const_set_lazy(:MESSAGE_DIGEST_OID) { PKCS9_OIDS[4] }
      const_attr_reader  :MESSAGE_DIGEST_OID
      
      const_set_lazy(:SIGNING_TIME_OID) { PKCS9_OIDS[5] }
      const_attr_reader  :SIGNING_TIME_OID
      
      const_set_lazy(:COUNTERSIGNATURE_OID) { PKCS9_OIDS[6] }
      const_attr_reader  :COUNTERSIGNATURE_OID
      
      const_set_lazy(:CHALLENGE_PASSWORD_OID) { PKCS9_OIDS[7] }
      const_attr_reader  :CHALLENGE_PASSWORD_OID
      
      const_set_lazy(:UNSTRUCTURED_ADDRESS_OID) { PKCS9_OIDS[8] }
      const_attr_reader  :UNSTRUCTURED_ADDRESS_OID
      
      const_set_lazy(:EXTENDED_CERTIFICATE_ATTRIBUTES_OID) { PKCS9_OIDS[9] }
      const_attr_reader  :EXTENDED_CERTIFICATE_ATTRIBUTES_OID
      
      const_set_lazy(:ISSUER_SERIALNUMBER_OID) { PKCS9_OIDS[10] }
      const_attr_reader  :ISSUER_SERIALNUMBER_OID
      
      # [11], [12] are RSA DSI proprietary
      # [13] ==> signingDescription, S/MIME, not used anymore
      const_set_lazy(:EXTENSION_REQUEST_OID) { PKCS9_OIDS[14] }
      const_attr_reader  :EXTENSION_REQUEST_OID
      
      const_set_lazy(:SMIME_CAPABILITY_OID) { PKCS9_OIDS[15] }
      const_attr_reader  :SMIME_CAPABILITY_OID
      
      const_set_lazy(:SIGNING_CERTIFICATE_OID) { PKCS9_OIDS[16] }
      const_attr_reader  :SIGNING_CERTIFICATE_OID
      
      const_set_lazy(:SIGNATURE_TIMESTAMP_TOKEN_OID) { PKCS9_OIDS[17] }
      const_attr_reader  :SIGNATURE_TIMESTAMP_TOKEN_OID
      
      const_set_lazy(:EMAIL_ADDRESS_STR) { "EmailAddress" }
      const_attr_reader  :EMAIL_ADDRESS_STR
      
      const_set_lazy(:UNSTRUCTURED_NAME_STR) { "UnstructuredName" }
      const_attr_reader  :UNSTRUCTURED_NAME_STR
      
      const_set_lazy(:CONTENT_TYPE_STR) { "ContentType" }
      const_attr_reader  :CONTENT_TYPE_STR
      
      const_set_lazy(:MESSAGE_DIGEST_STR) { "MessageDigest" }
      const_attr_reader  :MESSAGE_DIGEST_STR
      
      const_set_lazy(:SIGNING_TIME_STR) { "SigningTime" }
      const_attr_reader  :SIGNING_TIME_STR
      
      const_set_lazy(:COUNTERSIGNATURE_STR) { "Countersignature" }
      const_attr_reader  :COUNTERSIGNATURE_STR
      
      const_set_lazy(:CHALLENGE_PASSWORD_STR) { "ChallengePassword" }
      const_attr_reader  :CHALLENGE_PASSWORD_STR
      
      const_set_lazy(:UNSTRUCTURED_ADDRESS_STR) { "UnstructuredAddress" }
      const_attr_reader  :UNSTRUCTURED_ADDRESS_STR
      
      const_set_lazy(:EXTENDED_CERTIFICATE_ATTRIBUTES_STR) { "ExtendedCertificateAttributes" }
      const_attr_reader  :EXTENDED_CERTIFICATE_ATTRIBUTES_STR
      
      const_set_lazy(:ISSUER_SERIALNUMBER_STR) { "IssuerAndSerialNumber" }
      const_attr_reader  :ISSUER_SERIALNUMBER_STR
      
      # [11], [12] are RSA DSI proprietary
      const_set_lazy(:RSA_PROPRIETARY_STR) { "RSAProprietary" }
      const_attr_reader  :RSA_PROPRIETARY_STR
      
      # [13] ==> signingDescription, S/MIME, not used anymore
      const_set_lazy(:SMIME_SIGNING_DESC_STR) { "SMIMESigningDesc" }
      const_attr_reader  :SMIME_SIGNING_DESC_STR
      
      const_set_lazy(:EXTENSION_REQUEST_STR) { "ExtensionRequest" }
      const_attr_reader  :EXTENSION_REQUEST_STR
      
      const_set_lazy(:SMIME_CAPABILITY_STR) { "SMIMECapability" }
      const_attr_reader  :SMIME_CAPABILITY_STR
      
      const_set_lazy(:SIGNING_CERTIFICATE_STR) { "SigningCertificate" }
      const_attr_reader  :SIGNING_CERTIFICATE_STR
      
      const_set_lazy(:SIGNATURE_TIMESTAMP_TOKEN_STR) { "SignatureTimestampToken" }
      const_attr_reader  :SIGNATURE_TIMESTAMP_TOKEN_STR
      
      # Hashtable mapping names and variant names of supported
      # attributes to their OIDs. This table contains all name forms
      # that occur in PKCS9, in lower case.
      const_set_lazy(:NAME_OID_TABLE) { Hashtable.new(18) }
      const_attr_reader  :NAME_OID_TABLE
      
      when_class_loaded do
        # static initializer for PCKS9_NAMES
        NAME_OID_TABLE.put("emailaddress", PKCS9_OIDS[1])
        NAME_OID_TABLE.put("unstructuredname", PKCS9_OIDS[2])
        NAME_OID_TABLE.put("contenttype", PKCS9_OIDS[3])
        NAME_OID_TABLE.put("messagedigest", PKCS9_OIDS[4])
        NAME_OID_TABLE.put("signingtime", PKCS9_OIDS[5])
        NAME_OID_TABLE.put("countersignature", PKCS9_OIDS[6])
        NAME_OID_TABLE.put("challengepassword", PKCS9_OIDS[7])
        NAME_OID_TABLE.put("unstructuredaddress", PKCS9_OIDS[8])
        NAME_OID_TABLE.put("extendedcertificateattributes", PKCS9_OIDS[9])
        NAME_OID_TABLE.put("issuerandserialnumber", PKCS9_OIDS[10])
        NAME_OID_TABLE.put("rsaproprietary", PKCS9_OIDS[11])
        NAME_OID_TABLE.put("rsaproprietary", PKCS9_OIDS[12])
        NAME_OID_TABLE.put("signingdescription", PKCS9_OIDS[13])
        NAME_OID_TABLE.put("extensionrequest", PKCS9_OIDS[14])
        NAME_OID_TABLE.put("smimecapability", PKCS9_OIDS[15])
        NAME_OID_TABLE.put("signingcertificate", PKCS9_OIDS[16])
        NAME_OID_TABLE.put("signaturetimestamptoken", PKCS9_OIDS[17])
      end
      
      # Hashtable mapping attribute OIDs defined in PKCS9 to the
      # corresponding attribute value type.
      const_set_lazy(:OID_NAME_TABLE) { Hashtable.new(16) }
      const_attr_reader  :OID_NAME_TABLE
      
      when_class_loaded do
        OID_NAME_TABLE.put(PKCS9_OIDS[1], EMAIL_ADDRESS_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[2], UNSTRUCTURED_NAME_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[3], CONTENT_TYPE_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[4], MESSAGE_DIGEST_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[5], SIGNING_TIME_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[6], COUNTERSIGNATURE_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[7], CHALLENGE_PASSWORD_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[8], UNSTRUCTURED_ADDRESS_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[9], EXTENDED_CERTIFICATE_ATTRIBUTES_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[10], ISSUER_SERIALNUMBER_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[11], RSA_PROPRIETARY_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[12], RSA_PROPRIETARY_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[13], SMIME_SIGNING_DESC_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[14], EXTENSION_REQUEST_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[15], SMIME_CAPABILITY_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[16], SIGNING_CERTIFICATE_STR)
        OID_NAME_TABLE.put(PKCS9_OIDS[17], SIGNATURE_TIMESTAMP_TOKEN_STR)
      end
      
      # Acceptable ASN.1 tags for DER encodings of values of PKCS9
      # attributes, by index in <code>PKCS9_OIDS</code>.
      # Sets of acceptable tags are represented as arrays.
      # EMailAddress
      # UnstructuredName
      # ContentType
      # MessageDigest
      # SigningTime
      # Countersignature
      # ChallengePassword
      # UnstructuredAddress
      # ExtendedCertificateAttributes
      # issuerAndSerialNumber
      # extensionRequest
      # SMIMECapability
      # SigningCertificate
      # SignatureTimestampToken
      const_set_lazy(:PKCS9_VALUE_TAGS) { Array.typed(Array.typed(Byte)).new([nil, Array.typed(Byte).new([Byte.new(DerValue.attr_tag_ia5string)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_ia5string)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_object_id)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_octet_string)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_utc_time)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_sequence)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_printable_string), Byte.new(DerValue.attr_tag_t61string)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_printable_string), Byte.new(DerValue.attr_tag_t61string)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_set_of)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_sequence)]), nil, nil, nil, Array.typed(Byte).new([Byte.new(DerValue.attr_tag_sequence)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_sequence)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_sequence)]), Array.typed(Byte).new([Byte.new(DerValue.attr_tag_sequence)])]) }
      const_attr_reader  :PKCS9_VALUE_TAGS
      
      const_set_lazy(:VALUE_CLASSES) { Array.typed(Class).new(18) { nil } }
      const_attr_reader  :VALUE_CLASSES
      
      when_class_loaded do
        begin
          str = Class.for_name("[Ljava.lang.String;")
          VALUE_CLASSES[0] = nil # not used
          VALUE_CLASSES[1] = str # EMailAddress
          VALUE_CLASSES[2] = str # UnstructuredName # ContentType
          VALUE_CLASSES[3] = Class.for_name("sun.security.util.ObjectIdentifier")
          VALUE_CLASSES[4] = Class.for_name("[B") # MessageDigest (byte[])
          VALUE_CLASSES[5] = Class.for_name("java.util.Date") # SigningTime # Countersignature
          VALUE_CLASSES[6] = Class.for_name("[Lsun.security.pkcs.SignerInfo;") # ChallengePassword
          VALUE_CLASSES[7] = Class.for_name("java.lang.String")
          VALUE_CLASSES[8] = str # UnstructuredAddress
          VALUE_CLASSES[9] = nil # ExtendedCertificateAttributes
          VALUE_CLASSES[10] = nil # IssuerAndSerialNumber
          VALUE_CLASSES[11] = nil # not used
          VALUE_CLASSES[12] = nil # not used
          VALUE_CLASSES[13] = nil # not used # ExtensionRequest
          VALUE_CLASSES[14] = Class.for_name("sun.security.x509.CertificateExtensions")
          VALUE_CLASSES[15] = nil # not supported yet
          VALUE_CLASSES[16] = nil # not supported yet
          VALUE_CLASSES[17] = Class.for_name("[B") # SignatureTimestampToken
        rescue ClassNotFoundException => e
          raise ExceptionInInitializerError.new(e.to_s)
        end
      end
      
      # Array indicating which PKCS9 attributes are single-valued,
      # by index in <code>PKCS9_OIDS</code>.
      # EMailAddress
      # UnstructuredName
      # ContentType
      # MessageDigest
      # SigningTime
      # Countersignature
      # ChallengePassword
      # UnstructuredAddress
      # ExtendedCertificateAttributes
      # IssuerAndSerialNumber - not supported yet
      # not used
      # not used
      # not used
      # ExtensionRequest
      # SMIMECapability - not supported yet
      # SigningCertificate
      # SignatureTimestampToken
      const_set_lazy(:SINGLE_VALUED) { Array.typed(::Java::Boolean).new([false, false, false, true, true, true, false, true, false, false, true, false, false, false, true, true, true, true]) }
      const_attr_reader  :SINGLE_VALUED
    }
    
    # The OID of this attribute is <code>PKCS9_OIDS[index]</code>.
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    # Value set of this attribute.  Its class is given by
    # <code>VALUE_CLASSES[index]</code>.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [ObjectIdentifier, Object] }
    # Construct an attribute object from the attribute's OID and
    # value.  If the attribute is single-valued, provide only one
    # value.  If the attribute is multi-valued, provide an array
    # containing all the values.
    # Arrays of length zero are accepted, though probably useless.
    # 
    # <P> The
    # <a href=#classTable>table</a> gives the class that <code>value</code>
    # must have for a given attribute.
    def initialize(oid, value)
      @index = 0
      @value = nil
      init(oid, value)
    end
    
    typesig { [String, Object] }
    # Construct an attribute object from the attribute's name and
    # value.  If the attribute is single-valued, provide only one
    # value.  If the attribute is multi-valued, provide an array
    # containing all the values.
    # Arrays of length zero are accepted, though probably useless.
    # 
    # <P> The
    # <a href=#classTable>table</a> gives the class that <code>value</code>
    # must have for a given attribute. Reasonable variants of these
    # attributes are accepted; in particular, case does not matter.
    # 
    # @exception IllegalArgumentException
    # if the <code>name</code> is not recognized of the
    # <code>value</code> has the wrong type.
    def initialize(name, value)
      @index = 0
      @value = nil
      oid = get_oid(name)
      if ((oid).nil?)
        raise IllegalArgumentException.new("Unrecognized attribute name " + name + " constructing PKCS9Attribute.")
      end
      init(oid, value)
    end
    
    typesig { [ObjectIdentifier, Object] }
    def init(oid, value)
      @index = index_of(oid, PKCS9_OIDS, 1)
      if ((@index).equal?(-1))
        raise IllegalArgumentException.new("Unsupported OID " + RJava.cast_to_string(oid) + " constructing PKCS9Attribute.")
      end
      if (!VALUE_CLASSES[@index].is_instance(value))
        raise IllegalArgumentException.new("Wrong value class " + " for attribute " + RJava.cast_to_string(oid) + " constructing PKCS9Attribute; was " + RJava.cast_to_string(value.get_class.to_s) + ", should be " + RJava.cast_to_string(VALUE_CLASSES[@index].to_s))
      end
      @value = value
    end
    
    typesig { [DerValue] }
    # Construct a PKCS9Attribute from its encoding on an input
    # stream.
    # 
    # @param val the DerValue representing the DER encoding of the attribute.
    # @exception IOException on parsing error.
    def initialize(der_val)
      @index = 0
      @value = nil
      der_in = DerInputStream.new(der_val.to_byte_array)
      val = der_in.get_sequence(2)
      if (!(der_in.available).equal?(0))
        raise IOException.new("Excess data parsing PKCS9Attribute")
      end
      if (!(val.attr_length).equal?(2))
        raise IOException.new("PKCS9Attribute doesn't have two components")
      end
      # get the oid
      oid = val[0].get_oid
      @index = index_of(oid, PKCS9_OIDS, 1)
      if ((@index).equal?(-1))
        if (!(Debug).nil?)
          Debug.println("ignoring unsupported signer attribute: " + RJava.cast_to_string(oid))
        end
        raise ParsingException.new("Unsupported PKCS9 attribute: " + RJava.cast_to_string(oid))
      end
      elems = DerInputStream.new(val[1].to_byte_array).get_set(1)
      # check single valued have only one value
      if (SINGLE_VALUED[@index] && elems.attr_length > 1)
        throw_single_valued_exception
      end
      # check for illegal element tags
      tag = nil
      i = 0
      while i < elems.attr_length
        tag = Byte.new(elems[i].attr_tag)
        if ((index_of(tag, PKCS9_VALUE_TAGS[@index], 0)).equal?(-1))
          throw_tag_exception(tag)
        end
        i += 1
      end
      case (@index)
      when 1, 2, 8
        # email address
        # unstructured name
        # unstructured address
        # open scope
        values = Array.typed(String).new(elems.attr_length) { nil }
        i_ = 0
        while i_ < elems.attr_length
          values[i_] = elems[i_].get_as_string
          i_ += 1
        end
        @value = values # close scope
      when 3
        # content type
        @value = elems[0].get_oid
      when 4
        # message digest
        @value = elems[0].get_octet_string
      when 5
        # signing time
        @value = (DerInputStream.new(elems[0].to_byte_array)).get_utctime
      when 6
        # countersignature
        # open scope
        values = Array.typed(SignerInfo).new(elems.attr_length) { nil }
        i_ = 0
        while i_ < elems.attr_length
          values[i_] = SignerInfo.new(elems[i_].to_der_input_stream)
          i_ += 1
        end
        @value = values # close scope
      when 7
        # challenge password
        @value = elems[0].get_as_string
      when 9
        # extended-certificate attribute -- not supported
        raise IOException.new("PKCS9 extended-certificate " + "attribute not supported.")
      when 10
        # break unnecessary
        # issuerAndserialNumber attribute -- not supported
        raise IOException.new("PKCS9 IssuerAndSerialNumber" + "attribute not supported.")
      when 11, 12
        # break unnecessary
        # RSA DSI proprietary
        # RSA DSI proprietary
        raise IOException.new("PKCS9 RSA DSI attributes" + "11 and 12, not supported.")
      when 13
        # break unnecessary
        # S/MIME unused attribute
        raise IOException.new("PKCS9 attribute #13 not supported.")
      when 14
        # break unnecessary
        # ExtensionRequest
        @value = CertificateExtensions.new(DerInputStream.new(elems[0].to_byte_array))
      when 15
        # SMIME-capability attribute -- not supported
        raise IOException.new("PKCS9 SMIMECapability " + "attribute not supported.")
      when 16
        # break unnecessary
        # SigningCertificate attribute
        @value = SigningCertificateInfo.new(elems[0].to_byte_array)
      when 17
        # SignatureTimestampToken attribute
        @value = elems[0].to_byte_array
      # can't happen
      else
      end
    end
    
    typesig { [OutputStream] }
    # Write the DER encoding of this attribute to an output stream.
    # 
    # <P> N.B.: This method always encodes values of
    # ChallengePassword and UnstructuredAddress attributes as ASN.1
    # <code>PrintableString</code>s, without checking whether they
    # should be encoded as <code>T61String</code>s.
    def der_encode(out)
      temp = DerOutputStream.new
      temp.put_oid(get_oid)
      case (@index)
      when 1, 2
        # email address
        # unstructured name
        # open scope
        values = @value
        temps = Array.typed(DerOutputStream).new(values.attr_length) { nil }
        i = 0
        while i < values.attr_length
          temps[i] = DerOutputStream.new
          temps[i].put_ia5string(values[i])
          i += 1
        end
        temp.put_ordered_set_of(DerValue.attr_tag_set, temps) # close scope
      when 3
        # content type
        temp2 = DerOutputStream.new
        temp2.put_oid(@value)
        temp.write(DerValue.attr_tag_set, temp2.to_byte_array)
      when 4
        # message digest
        temp2 = DerOutputStream.new
        temp2.put_octet_string(@value)
        temp.write(DerValue.attr_tag_set, temp2.to_byte_array)
      when 5
        # signing time
        temp2 = DerOutputStream.new
        temp2.put_utctime(@value)
        temp.write(DerValue.attr_tag_set, temp2.to_byte_array)
      when 6
        # countersignature
        temp.put_ordered_set_of(DerValue.attr_tag_set, @value)
      when 7
        # challenge password
        temp2 = DerOutputStream.new
        temp2.put_printable_string(@value)
        temp.write(DerValue.attr_tag_set, temp2.to_byte_array)
      when 8
        # unstructured address
        # open scope
        values = @value
        temps = Array.typed(DerOutputStream).new(values.attr_length) { nil }
        i = 0
        while i < values.attr_length
          temps[i] = DerOutputStream.new
          temps[i].put_printable_string(values[i])
          i += 1
        end
        temp.put_ordered_set_of(DerValue.attr_tag_set, temps) # close scope
      when 9
        # extended-certificate attribute -- not supported
        raise IOException.new("PKCS9 extended-certificate " + "attribute not supported.")
      when 10
        # break unnecessary
        # issuerAndserialNumber attribute -- not supported
        raise IOException.new("PKCS9 IssuerAndSerialNumber" + "attribute not supported.")
      when 11, 12
        # break unnecessary
        # RSA DSI proprietary
        # RSA DSI proprietary
        raise IOException.new("PKCS9 RSA DSI attributes" + "11 and 12, not supported.")
      when 13
        # break unnecessary
        # S/MIME unused attribute
        raise IOException.new("PKCS9 attribute #13 not supported.")
      when 14
        # break unnecessary
        # ExtensionRequest
        temp2 = DerOutputStream.new
        exts = @value
        begin
          exts.encode(temp2, true)
        rescue CertificateException => ex
          raise IOException.new(ex.to_s)
        end
        temp.write(DerValue.attr_tag_set, temp2.to_byte_array)
      when 15
        # SMIMECapability
        raise IOException.new("PKCS9 attribute #15 not supported.")
      when 16
        # break unnecessary
        # SigningCertificate
        raise IOException.new("PKCS9 SigningCertificate attribute not supported.")
      when 17
        # break unnecessary
        # SignatureTimestampToken
        temp.write(DerValue.attr_tag_set, @value)
      # can't happen
      else
      end
      der_out = DerOutputStream.new
      der_out.write(DerValue.attr_tag_sequence, temp.to_byte_array)
      out.write(der_out.to_byte_array)
    end
    
    typesig { [] }
    # Get the value of this attribute.  If the attribute is
    # single-valued, return just the one value.  If the attribute is
    # multi-valued, return an array containing all the values.
    # It is possible for this array to be of length 0.
    # 
    # <P> The
    # <a href=#classTable>table</a> gives the class of the value returned,
    # depending on the type of this attribute.
    def get_value
      return @value
    end
    
    typesig { [] }
    # Show whether this attribute is single-valued.
    def is_single_valued
      return SINGLE_VALUED[@index]
    end
    
    typesig { [] }
    # Return the OID of this attribute.
    def get_oid
      return PKCS9_OIDS[@index]
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return OID_NAME_TABLE.get(PKCS9_OIDS[@index])
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Return the OID for a given attribute name or null if we don't recognize
      # the name.
      def get_oid(name)
        return NAME_OID_TABLE.get(name.to_lower_case)
      end
      
      typesig { [ObjectIdentifier] }
      # Return the attribute name for a given OID or null if we don't recognize
      # the oid.
      def get_name(oid)
        return OID_NAME_TABLE.get(oid)
      end
    }
    
    typesig { [] }
    # Returns a string representation of this attribute.
    def to_s
      buf = StringBuffer.new(100)
      buf.append("[")
      buf.append(OID_NAME_TABLE.get(PKCS9_OIDS[@index]))
      buf.append(": ")
      if (SINGLE_VALUED[@index])
        if (@value.is_a?(Array.typed(::Java::Byte)))
          # special case for octet string
          hex_dump = HexDumpEncoder.new
          buf.append(hex_dump.encode_buffer(@value))
        else
          buf.append(@value.to_s)
        end
        buf.append("]")
        return buf.to_s
      else
        # multi-valued
        first = true
        values = @value
        j = 0
        while j < values.attr_length
          if (first)
            first = false
          else
            buf.append(", ")
          end
          buf.append(values[j].to_s)
          j += 1
        end
        return buf.to_s
      end
    end
    
    class_module.module_eval {
      typesig { [Object, Array.typed(Object), ::Java::Int] }
      # Beginning the search at <code>start</code>, find the first
      # index <code>i</code> such that <code>a[i] = obj</code>.
      # 
      # @return the index, if found, and -1 otherwise.
      def index_of(obj, a, start)
        i = start
        while i < a.attr_length
          if ((obj == a[i]))
            return i
          end
          i += 1
        end
        return -1
      end
    }
    
    typesig { [] }
    # Throw an exception when there are multiple values for
    # a single-valued attribute.
    def throw_single_valued_exception
      raise IOException.new("Single-value attribute " + RJava.cast_to_string(get_oid) + " (" + RJava.cast_to_string(get_name) + ")" + " has multiple values.")
    end
    
    typesig { [Byte] }
    # Throw an exception when the tag on a value encoding is
    # wrong for the attribute whose value it is.
    def throw_tag_exception(tag)
      expected_tags = PKCS9_VALUE_TAGS[@index]
      msg = StringBuffer.new(100)
      msg.append("Value of attribute ")
      msg.append(get_oid.to_s)
      msg.append(" (")
      msg.append(get_name)
      msg.append(") has wrong tag: ")
      msg.append(tag.to_s)
      msg.append(".  Expected tags: ")
      msg.append(expected_tags[0].to_s)
      i = 1
      while i < expected_tags.attr_length
        msg.append(", ")
        msg.append(expected_tags[i].to_s)
        i += 1
      end
      msg.append(".")
      raise IOException.new(msg.to_s)
    end
    
    private
    alias_method :initialize__pkcs9attribute, :initialize
  end
  
end
