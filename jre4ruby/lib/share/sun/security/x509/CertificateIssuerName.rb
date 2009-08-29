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
module Sun::Security::X509
  module CertificateIssuerNameImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the X500Name attribute for the Certificate.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  class CertificateIssuerName 
    include_class_members CertificateIssuerNameImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.issuer" }
      const_attr_reader  :IDENT
      
      # Sub attributes name for this CertAttrSet.
      const_set_lazy(:NAME) { "issuer" }
      const_attr_reader  :NAME
      
      const_set_lazy(:DN_NAME) { "dname" }
      const_attr_reader  :DN_NAME
      
      # accessor name for cached X500Principal only
      # do not allow a set() of this value, do not advertise with getElements()
      const_set_lazy(:DN_PRINCIPAL) { "x500principal" }
      const_attr_reader  :DN_PRINCIPAL
    }
    
    # Private data member
    attr_accessor :dn_name
    alias_method :attr_dn_name, :dn_name
    undef_method :dn_name
    alias_method :attr_dn_name=, :dn_name=
    undef_method :dn_name=
    
    # cached X500Principal version of the name
    attr_accessor :dn_principal
    alias_method :attr_dn_principal, :dn_principal
    undef_method :dn_principal
    alias_method :attr_dn_principal=, :dn_principal=
    undef_method :dn_principal=
    
    typesig { [X500Name] }
    # Default constructor for the certificate attribute.
    # 
    # @param name the X500Name
    def initialize(name)
      @dn_name = nil
      @dn_principal = nil
      @dn_name = name
    end
    
    typesig { [DerInputStream] }
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the X500Name from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @dn_name = nil
      @dn_principal = nil
      @dn_name = X500Name.new(in_)
    end
    
    typesig { [InputStream] }
    # Create the object, decoding the values from the passed stream.
    # 
    # @param in the InputStream to read the X500Name from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @dn_name = nil
      @dn_principal = nil
      der_val = DerValue.new(in_)
      @dn_name = X500Name.new(der_val)
    end
    
    typesig { [] }
    # Return the name as user readable string.
    def to_s
      if ((@dn_name).nil?)
        return ""
      end
      return (@dn_name.to_s)
    end
    
    typesig { [OutputStream] }
    # Encode the name in DER form to the stream.
    # 
    # @param out the DerOutputStream to marshal the contents to.
    # @exception IOException on errors.
    def encode(out)
      tmp = DerOutputStream.new
      @dn_name.encode(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(X500Name)))
        raise IOException.new("Attribute must be of type X500Name.")
      end
      if (name.equals_ignore_case(DN_NAME))
        @dn_name = obj
        @dn_principal = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateIssuerName.")
      end
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(DN_NAME))
        return (@dn_name)
      else
        if (name.equals_ignore_case(DN_PRINCIPAL))
          if (((@dn_principal).nil?) && (!(@dn_name).nil?))
            @dn_principal = @dn_name.as_x500principal
          end
          return @dn_principal
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateIssuerName.")
        end
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(DN_NAME))
        @dn_name = nil
        @dn_principal = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateIssuerName.")
      end
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(DN_NAME)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__certificate_issuer_name, :initialize
  end
  
end
