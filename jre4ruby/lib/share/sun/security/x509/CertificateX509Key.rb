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
  module CertificateX509KeyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the X509Key attribute for the Certificate.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  class CertificateX509Key 
    include_class_members CertificateX509KeyImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.key" }
      const_attr_reader  :IDENT
      
      # Sub attributes name for this CertAttrSet.
      const_set_lazy(:NAME) { "key" }
      const_attr_reader  :NAME
      
      const_set_lazy(:KEY) { "value" }
      const_attr_reader  :KEY
    }
    
    # Private data member
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    typesig { [PublicKey] }
    # Default constructor for the certificate attribute.
    # 
    # @param key the X509Key
    def initialize(key)
      @key = nil
      @key = key
    end
    
    typesig { [DerInputStream] }
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the X509Key from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @key = nil
      val = in_.get_der_value
      @key = X509Key.parse(val)
    end
    
    typesig { [InputStream] }
    # Create the object, decoding the values from the passed stream.
    # 
    # @param in the InputStream to read the X509Key from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @key = nil
      val = DerValue.new(in_)
      @key = X509Key.parse(val)
    end
    
    typesig { [] }
    # Return the key as printable string.
    def to_s
      if ((@key).nil?)
        return ""
      end
      return (@key.to_s)
    end
    
    typesig { [OutputStream] }
    # Encode the key in DER form to the stream.
    # 
    # @param out the OutputStream to marshal the contents to.
    # @exception IOException on errors.
    def encode(out)
      tmp = DerOutputStream.new
      tmp.write(@key.get_encoded)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(KEY))
        @key = obj
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateX509Key.")
      end
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(KEY))
        return (@key)
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateX509Key.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(KEY))
        @key = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateX509Key.")
      end
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(KEY)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__certificate_x509key, :initialize
  end
  
end
