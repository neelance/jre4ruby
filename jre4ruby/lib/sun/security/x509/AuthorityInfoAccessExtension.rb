require "rjava"

# Copyright 2004-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AuthorityInfoAccessExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Util
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
    }
  end
  
  # The Authority Information Access Extension (OID = 1.3.6.1.5.5.7.1.1).
  # <p>
  # The AIA extension identifies how to access CA information and services
  # for the certificate in which it appears. It enables CAs to issue their
  # certificates pre-configured with the URLs appropriate for contacting
  # services relevant to those certificates. For example, a CA may issue a
  # certificate that identifies the specific OCSP Responder to use when
  # performing on-line validation of that certificate.
  # <p>
  # This extension is defined in
  # <a href="http://www.ietf.org/rfc/rfc3280.txt">Internet X.509 PKI Certificate and Certificate Revocation List (CRL) Profile</a>. The profile permits
  # the extension to be included in end-entity or CA certificates,
  # and it must be marked as non-critical. Its ASN.1 definition is as follows:
  # <pre>
  # id-pe-authorityInfoAccess OBJECT IDENTIFIER ::= { id-pe 1 }
  # 
  # AuthorityInfoAccessSyntax  ::=
  # SEQUENCE SIZE (1..MAX) OF AccessDescription
  # 
  # AccessDescription  ::=  SEQUENCE {
  # accessMethod          OBJECT IDENTIFIER,
  # accessLocation        GeneralName  }
  # </pre>
  # <p>
  # @see Extension
  # @see CertAttrSet
  class AuthorityInfoAccessExtension < AuthorityInfoAccessExtensionImports.const_get :Extension
    include_class_members AuthorityInfoAccessExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.AuthorityInfoAccess" }
      const_attr_reader  :IDENT
      
      # Attribute name.
      const_set_lazy(:NAME) { "AuthorityInfoAccess" }
      const_attr_reader  :NAME
      
      const_set_lazy(:DESCRIPTIONS) { "descriptions" }
      const_attr_reader  :DESCRIPTIONS
    }
    
    # The List of AccessDescription objects.
    attr_accessor :access_descriptions
    alias_method :attr_access_descriptions, :access_descriptions
    undef_method :access_descriptions
    alias_method :attr_access_descriptions=, :access_descriptions=
    undef_method :access_descriptions=
    
    typesig { [JavaList] }
    # Create an AuthorityInfoAccessExtension from a List of
    # AccessDescription; the criticality is set to false.
    # 
    # @param accessDescriptions the List of AccessDescription
    # @throws IOException on error
    def initialize(access_descriptions)
      @access_descriptions = nil
      super()
      self.attr_extension_id = PKIXExtensions::AuthInfoAccess_Id
      self.attr_critical = false
      @access_descriptions = access_descriptions
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value Array of DER encoded bytes of the actual value.
    # @exception IOException on error.
    def initialize(critical, value)
      @access_descriptions = nil
      super()
      self.attr_extension_id = PKIXExtensions::AuthInfoAccess_Id
      self.attr_critical = critical.boolean_value
      if (!(value.is_a?(Array.typed(::Java::Byte))))
        raise IOException.new("Illegal argument type")
      end
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for " + "AuthorityInfoAccessExtension.")
      end
      @access_descriptions = ArrayList.new
      while (!(val.attr_data.available).equal?(0))
        seq = val.attr_data.get_der_value
        access_description = AccessDescription.new(seq)
        @access_descriptions.add(access_description)
      end
    end
    
    typesig { [] }
    # Return the list of AccessDescription objects.
    def get_access_descriptions
      return @access_descriptions
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return NAME
    end
    
    typesig { [OutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::AuthInfoAccess_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(DESCRIPTIONS))
        if (!(obj.is_a?(JavaList)))
          raise IOException.new("Attribute value should be of type List.")
        end
        @access_descriptions = obj
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:AuthorityInfoAccessExtension.")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(DESCRIPTIONS))
        return @access_descriptions
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:AuthorityInfoAccessExtension.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(DESCRIPTIONS))
        @access_descriptions = ArrayList.new
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:AuthorityInfoAccessExtension.")
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(DESCRIPTIONS)
      return elements.elements
    end
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      if (@access_descriptions.is_empty)
        self.attr_extension_value = nil
      else
        ads = DerOutputStream.new
        @access_descriptions.each do |accessDescription|
          access_description.encode(ads)
        end
        seq = DerOutputStream.new
        seq.write(DerValue.attr_tag_sequence, ads)
        self.attr_extension_value = seq.to_byte_array
      end
    end
    
    typesig { [] }
    # Return the extension as user readable string.
    def to_s
      return (super).to_s + "AuthorityInfoAccess [\n  " + (@access_descriptions).to_s + "\n]\n"
    end
    
    private
    alias_method :initialize__authority_info_access_extension, :initialize
  end
  
end
