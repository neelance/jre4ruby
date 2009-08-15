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
  module CertificateSerialNumberImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the SerialNumber attribute for the Certificate.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  class CertificateSerialNumber 
    include_class_members CertificateSerialNumberImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.serialNumber" }
      const_attr_reader  :IDENT
      
      # Sub attributes name for this CertAttrSet.
      const_set_lazy(:NAME) { "serialNumber" }
      const_attr_reader  :NAME
      
      const_set_lazy(:NUMBER) { "number" }
      const_attr_reader  :NUMBER
    }
    
    attr_accessor :serial
    alias_method :attr_serial, :serial
    undef_method :serial
    alias_method :attr_serial=, :serial=
    undef_method :serial=
    
    typesig { [BigInteger] }
    # Default constructor for the certificate attribute.
    # 
    # @param serial the serial number for the certificate.
    def initialize(num)
      @serial = nil
      @serial = SerialNumber.new(num)
    end
    
    typesig { [::Java::Int] }
    # Default constructor for the certificate attribute.
    # 
    # @param serial the serial number for the certificate.
    def initialize(num)
      @serial = nil
      @serial = SerialNumber.new(num)
    end
    
    typesig { [DerInputStream] }
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the serial number from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @serial = nil
      @serial = SerialNumber.new(in_)
    end
    
    typesig { [InputStream] }
    # Create the object, decoding the values from the passed stream.
    # 
    # @param in the InputStream to read the serial number from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @serial = nil
      @serial = SerialNumber.new(in_)
    end
    
    typesig { [DerValue] }
    # Create the object, decoding the values from the passed DerValue.
    # 
    # @param val the DER encoded value.
    # @exception IOException on decoding errors.
    def initialize(val)
      @serial = nil
      @serial = SerialNumber.new(val)
    end
    
    typesig { [] }
    # Return the serial number as user readable string.
    def to_s
      if ((@serial).nil?)
        return ""
      end
      return (@serial.to_s)
    end
    
    typesig { [OutputStream] }
    # Encode the serial number in DER form to the stream.
    # 
    # @param out the DerOutputStream to marshal the contents to.
    # @exception IOException on errors.
    def encode(out)
      tmp = DerOutputStream.new
      @serial.encode(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(SerialNumber)))
        raise IOException.new("Attribute must be of type SerialNumber.")
      end
      if (name.equals_ignore_case(NUMBER))
        @serial = obj
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateSerialNumber.")
      end
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(NUMBER))
        return (@serial)
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateSerialNumber.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(NUMBER))
        @serial = nil
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:CertificateSerialNumber.")
      end
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(NUMBER)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__certificate_serial_number, :initialize
  end
  
end
