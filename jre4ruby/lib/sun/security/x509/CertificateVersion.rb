require "rjava"

# 
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
  module CertificateVersionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # 
  # This class defines the version of the X509 Certificate.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  class CertificateVersion 
    include_class_members CertificateVersionImports
    include CertAttrSet
    
    class_module.module_eval {
      # 
      # X509Certificate Version 1
      const_set_lazy(:V1) { 0 }
      const_attr_reader  :V1
      
      # 
      # X509Certificate Version 2
      const_set_lazy(:V2) { 1 }
      const_attr_reader  :V2
      
      # 
      # X509Certificate Version 3
      const_set_lazy(:V3) { 2 }
      const_attr_reader  :V3
      
      # 
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.version" }
      const_attr_reader  :IDENT
      
      # 
      # Sub attributes name for this CertAttrSet.
      const_set_lazy(:NAME) { "version" }
      const_attr_reader  :NAME
      
      const_set_lazy(:VERSION) { "number" }
      const_attr_reader  :VERSION
    }
    
    # Private data members
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    typesig { [] }
    # Returns the version number.
    def get_version
      return (@version)
    end
    
    typesig { [DerValue] }
    # Construct the class from the passed DerValue
    def construct(der_val)
      if (der_val.is_constructed && der_val.is_context_specific)
        der_val = der_val.attr_data.get_der_value
        @version = der_val.get_integer
        if (!(der_val.attr_data.available).equal?(0))
          raise IOException.new("X.509 version, bad format")
        end
      end
    end
    
    typesig { [] }
    # 
    # The default constructor for this class,
    # sets the version to 0 (i.e. X.509 version 1).
    def initialize
      @version = V1
      @version = V1
    end
    
    typesig { [::Java::Int] }
    # 
    # The constructor for this class for the required version.
    # 
    # @param version the version for the certificate.
    # @exception IOException if the version is not valid.
    def initialize(version)
      @version = V1
      # check that it is a valid version
      if ((version).equal?(V1) || (version).equal?(V2) || (version).equal?(V3))
        @version = version
      else
        raise IOException.new("X.509 Certificate version " + (version).to_s + " not supported.\n")
      end
    end
    
    typesig { [DerInputStream] }
    # 
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the CertificateVersion from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @version = V1
      @version = V1
      der_val = in_.get_der_value
      construct(der_val)
    end
    
    typesig { [InputStream] }
    # 
    # Create the object, decoding the values from the passed stream.
    # 
    # @param in the InputStream to read the CertificateVersion from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @version = V1
      @version = V1
      der_val = DerValue.new(in_)
      construct(der_val)
    end
    
    typesig { [DerValue] }
    # 
    # Create the object, decoding the values from the passed DerValue.
    # 
    # @param val the Der encoded value.
    # @exception IOException on decoding errors.
    def initialize(val)
      @version = V1
      @version = V1
      construct(val)
    end
    
    typesig { [] }
    # 
    # Return the version number of the certificate.
    def to_s
      return ("Version: V" + ((@version + 1)).to_s)
    end
    
    typesig { [OutputStream] }
    # 
    # Encode the CertificateVersion period in DER form to the stream.
    # 
    # @param out the OutputStream to marshal the contents to.
    # @exception IOException on errors.
    def encode(out)
      # Nothing for default
      if ((@version).equal?(V1))
        return
      end
      tmp = DerOutputStream.new
      tmp.put_integer(@version)
      seq = DerOutputStream.new
      seq.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0), tmp)
      out.write(seq.to_byte_array)
    end
    
    typesig { [String, Object] }
    # 
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(JavaInteger)))
        raise IOException.new("Attribute must be of type Integer.")
      end
      if (name.equals_ignore_case(VERSION))
        @version = (obj).int_value
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateVersion.")
      end
    end
    
    typesig { [String] }
    # 
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(VERSION))
        return (get_version)
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateVersion.")
      end
    end
    
    typesig { [String] }
    # 
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(VERSION))
        @version = V1
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateVersion.")
      end
    end
    
    typesig { [] }
    # 
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(VERSION)
      return (elements.elements)
    end
    
    typesig { [] }
    # 
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    typesig { [::Java::Int] }
    # 
    # Compare versions.
    def compare(vers)
      return (@version - vers)
    end
    
    private
    alias_method :initialize__certificate_version, :initialize
  end
  
end
