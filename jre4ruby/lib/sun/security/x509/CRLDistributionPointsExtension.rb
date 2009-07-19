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
  module CRLDistributionPointsExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Util
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :ObjectIdentifier
    }
  end
  
  # Represent the CRL Distribution Points Extension (OID = 2.5.29.31).
  # <p>
  # The CRL distribution points extension identifies how CRL information
  # is obtained.  The extension SHOULD be non-critical, but the PKIX profile
  # recommends support for this extension by CAs and applications.
  # <p>
  # For PKIX, if the cRLDistributionPoints extension contains a
  # DistributionPointName of type URI, the following semantics MUST be
  # assumed: the URI is a pointer to the current CRL for the associated
  # reasons and will be issued by the associated cRLIssuer.  The
  # expected values for the URI conform to the following rules.  The
  # name MUST be a non-relative URL, and MUST follow the URL syntax and
  # encoding rules specified in [RFC 1738].  The name must include both
  # a scheme (e.g., "http" or "ftp") and a scheme-specific-part.  The
  # scheme- specific-part must include a fully qualified domain name or
  # IP address as the host.  As specified in [RFC 1738], the scheme
  # name is not case-sensitive (e.g., "http" is equivalent to "HTTP").
  # The host part is also not case-sensitive, but other components of
  # the scheme-specific-part may be case-sensitive. When comparing
  # URIs, conforming implementations MUST compare the scheme and host
  # without regard to case, but assume the remainder of the
  # scheme-specific-part is case sensitive.  Processing rules for other
  # values are not defined by this specification.  If the
  # distributionPoint omits reasons, the CRL MUST include revocations
  # for all reasons. If the distributionPoint omits cRLIssuer, the CRL
  # MUST be issued by the CA that issued the certificate.
  # <p>
  # The ASN.1 definition for this is:
  # <pre>
  # id-ce-cRLDistributionPoints OBJECT IDENTIFIER ::=  { id-ce 31 }
  # 
  # cRLDistributionPoints ::= {
  # CRLDistPointsSyntax }
  # 
  # CRLDistPointsSyntax ::= SEQUENCE SIZE (1..MAX) OF DistributionPoint
  # </pre>
  # <p>
  # @author Anne Anderson
  # @author Andreas Sterbenz
  # @since 1.4.2
  # @see DistributionPoint
  # @see Extension
  # @see CertAttrSet
  class CRLDistributionPointsExtension < CRLDistributionPointsExtensionImports.const_get :Extension
    include_class_members CRLDistributionPointsExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.CRLDistributionPoints" }
      const_attr_reader  :IDENT
      
      # Attribute name.
      const_set_lazy(:NAME) { "CRLDistributionPoints" }
      const_attr_reader  :NAME
      
      const_set_lazy(:POINTS) { "points" }
      const_attr_reader  :POINTS
    }
    
    # The List of DistributionPoint objects.
    attr_accessor :distribution_points
    alias_method :attr_distribution_points, :distribution_points
    undef_method :distribution_points
    alias_method :attr_distribution_points=, :distribution_points=
    undef_method :distribution_points=
    
    attr_accessor :extension_name
    alias_method :attr_extension_name, :extension_name
    undef_method :extension_name
    alias_method :attr_extension_name=, :extension_name=
    undef_method :extension_name=
    
    typesig { [JavaList] }
    # Create a CRLDistributionPointsExtension from a List of
    # DistributionPoint; the criticality is set to false.
    # 
    # @param distributionPoints the list of distribution points
    # @throws IOException on error
    def initialize(distribution_points)
      initialize__crldistribution_points_extension(false, distribution_points)
    end
    
    typesig { [::Java::Boolean, JavaList] }
    # Create a CRLDistributionPointsExtension from a List of
    # DistributionPoint.
    # 
    # @param isCritical the criticality setting.
    # @param distributionPoints the list of distribution points
    # @throws IOException on error
    def initialize(is_critical, distribution_points)
      initialize__crldistribution_points_extension(PKIXExtensions::CRLDistributionPoints_Id, is_critical, distribution_points, NAME)
    end
    
    typesig { [ObjectIdentifier, ::Java::Boolean, JavaList, String] }
    # Creates the extension (also called by the subclass).
    def initialize(extension_id, is_critical, distribution_points, extension_name)
      @distribution_points = nil
      @extension_name = nil
      super()
      self.attr_extension_id = extension_id
      self.attr_critical = is_critical
      @distribution_points = distribution_points
      encode_this
      @extension_name = extension_name
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value Array of DER encoded bytes of the actual value.
    # @exception IOException on error.
    def initialize(critical, value)
      initialize__crldistribution_points_extension(PKIXExtensions::CRLDistributionPoints_Id, critical, value, NAME)
    end
    
    typesig { [ObjectIdentifier, Boolean, Object, String] }
    # Creates the extension (also called by the subclass).
    def initialize(extension_id, critical, value, extension_name)
      @distribution_points = nil
      @extension_name = nil
      super()
      self.attr_extension_id = extension_id
      self.attr_critical = critical.boolean_value
      if (!(value.is_a?(Array.typed(::Java::Byte))))
        raise IOException.new("Illegal argument type")
      end
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for " + extension_name + " extension.")
      end
      @distribution_points = ArrayList.new
      while (!(val.attr_data.available).equal?(0))
        seq = val.attr_data.get_der_value
        point = DistributionPoint.new(seq)
        @distribution_points.add(point)
      end
      @extension_name = extension_name
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return @extension_name
    end
    
    typesig { [OutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      encode(out, PKIXExtensions::CRLDistributionPoints_Id, false)
    end
    
    typesig { [OutputStream, ObjectIdentifier, ::Java::Boolean] }
    # Write the extension to the DerOutputStream.
    # (Also called by the subclass)
    def encode(out, extension_id, is_critical)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = extension_id
        self.attr_critical = is_critical
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(POINTS))
        if (!(obj.is_a?(JavaList)))
          raise IOException.new("Attribute value should be of type List.")
        end
        @distribution_points = obj
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:" + @extension_name + ".")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(POINTS))
        return @distribution_points
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:" + @extension_name + ".")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(POINTS))
        @distribution_points = ArrayList.new
      else
        raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:" + @extension_name + ".")
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(POINTS)
      return elements.elements
    end
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      if (@distribution_points.is_empty)
        self.attr_extension_value = nil
      else
        pnts = DerOutputStream.new
        @distribution_points.each do |point|
          point.encode(pnts)
        end
        seq = DerOutputStream.new
        seq.write(DerValue.attr_tag_sequence, pnts)
        self.attr_extension_value = seq.to_byte_array
      end
    end
    
    typesig { [] }
    # Return the extension as user readable string.
    def to_s
      return (super).to_s + @extension_name + " [\n  " + (@distribution_points).to_s + "]\n"
    end
    
    private
    alias_method :initialize__crldistribution_points_extension, :initialize
  end
  
end
