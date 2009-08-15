require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertificateIssuerExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # Represents the CRL Certificate Issuer Extension (OID = 2.5.29.29).
  # <p>
  # The CRL certificate issuer extension identifies the certificate issuer
  # associated with an entry in an indirect CRL, i.e. a CRL that has the
  # indirectCRL indicator set in its issuing distribution point extension. If
  # this extension is not present on the first entry in an indirect CRL, the
  # certificate issuer defaults to the CRL issuer. On subsequent entries
  # in an indirect CRL, if this extension is not present, the certificate
  # issuer for the entry is the same as that for the preceding entry.
  # <p>
  # If used by conforming CRL issuers, this extension is always
  # critical.  If an implementation ignored this extension it could not
  # correctly attribute CRL entries to certificates.  PKIX (RFC 3280)
  # RECOMMENDS that implementations recognize this extension.
  # <p>
  # The ASN.1 definition for this is:
  # <pre>
  # id-ce-certificateIssuer   OBJECT IDENTIFIER ::= { id-ce 29 }
  # 
  # certificateIssuer ::=     GeneralNames
  # </pre>
  # 
  # @author Anne Anderson
  # @author Sean Mullan
  # @since 1.5
  # @see Extension
  # @see CertAttrSet
  class CertificateIssuerExtension < CertificateIssuerExtensionImports.const_get :Extension
    include_class_members CertificateIssuerExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Attribute names.
      const_set_lazy(:NAME) { "CertificateIssuer" }
      const_attr_reader  :NAME
      
      const_set_lazy(:ISSUER) { "issuer" }
      const_attr_reader  :ISSUER
    }
    
    attr_accessor :names
    alias_method :attr_names, :names
    undef_method :names
    alias_method :attr_names=, :names=
    undef_method :names=
    
    typesig { [] }
    # Encode this extension
    def encode_this
      if ((@names).nil? || @names.is_empty)
        self.attr_extension_value = nil
        return
      end
      os = DerOutputStream.new
      @names.encode(os)
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [GeneralNames] }
    # Create a CertificateIssuerExtension containing the specified issuer name.
    # Criticality is automatically set to true.
    # 
    # @param issuer the certificate issuer
    # @throws IOException on error
    def initialize(issuer)
      @names = nil
      super()
      self.attr_extension_id = PKIXExtensions::CertificateIssuer_Id
      self.attr_critical = true
      @names = issuer
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create a CertificateIssuerExtension from the specified DER encoded
    # value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value
    # @throws ClassCastException if value is not an array of bytes
    # @throws IOException on error
    def initialize(critical, value)
      @names = nil
      super()
      self.attr_extension_id = PKIXExtensions::CertificateIssuer_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      @names = GeneralNames.new(val)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    # 
    # @throws IOException on error
    def set(name, obj)
      if (name.equals_ignore_case(ISSUER))
        if (!(obj.is_a?(GeneralNames)))
          raise IOException.new("Attribute value must be of type " + "GeneralNames")
        end
        @names = obj
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateIssuer")
      end
      encode_this
    end
    
    typesig { [String] }
    # Gets the attribute value.
    # 
    # @throws IOException on error
    def get(name)
      if (name.equals_ignore_case(ISSUER))
        return @names
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateIssuer")
      end
    end
    
    typesig { [String] }
    # Deletes the attribute value.
    # 
    # @throws IOException on error
    def delete(name)
      if (name.equals_ignore_case(ISSUER))
        @names = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateIssuer")
      end
      encode_this
    end
    
    typesig { [] }
    # Returns a printable representation of the certificate issuer.
    def to_s
      return RJava.cast_to_string(super) + "Certificate Issuer [\n" + RJava.cast_to_string(String.value_of(@names)) + "]\n"
    end
    
    typesig { [OutputStream] }
    # Write the extension to the OutputStream.
    # 
    # @param out the OutputStream to write the extension to
    # @exception IOException on encoding errors
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::CertificateIssuer_Id
        self.attr_critical = true
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(ISSUER)
      return elements.elements
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return NAME
    end
    
    private
    alias_method :initialize__certificate_issuer_extension, :initialize
  end
  
end
