require "rjava"

# 
# Copyright 1997-1998 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PKCS10AttributeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # 
  # Represent a PKCS#10 Attribute.
  # 
  # <p>Attributes are additonal information which can be inserted in a PKCS#10
  # certificate request. For example a "Driving License Certificate" could have
  # the driving license number as an attribute.
  # 
  # <p>Attributes are represented as a sequence of the attribute identifier
  # (Object Identifier) and a set of DER encoded attribute values.
  # 
  # ASN.1 definition of Attribute:
  # <pre>
  # Attribute :: SEQUENCE {
  # type    AttributeType,
  # values  SET OF AttributeValue
  # }
  # AttributeType  ::= OBJECT IDENTIFIER
  # AttributeValue ::= ANY defined by type
  # </pre>
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class PKCS10Attribute 
    include_class_members PKCS10AttributeImports
    include DerEncoder
    
    attr_accessor :attribute_id
    alias_method :attr_attribute_id, :attribute_id
    undef_method :attribute_id
    alias_method :attr_attribute_id=, :attribute_id=
    undef_method :attribute_id=
    
    attr_accessor :attribute_value
    alias_method :attr_attribute_value, :attribute_value
    undef_method :attribute_value
    alias_method :attr_attribute_value=, :attribute_value=
    undef_method :attribute_value=
    
    typesig { [DerValue] }
    # 
    # Constructs an attribute from a DER encoding.
    # This constructor expects the value to be encoded as defined above,
    # i.e. a SEQUENCE of OID and SET OF value(s), not a literal
    # X.509 v3 extension. Only PKCS9 defined attributes are supported
    # currently.
    # 
    # @param derVal the der encoded attribute.
    # @exception IOException on parsing errors.
    def initialize(der_val)
      @attribute_id = nil
      @attribute_value = nil
      attr = PKCS9Attribute.new(der_val)
      @attribute_id = attr.get_oid
      @attribute_value = attr.get_value
    end
    
    typesig { [ObjectIdentifier, Object] }
    # 
    # Constructs an attribute from individual components of
    # ObjectIdentifier and the value (any java object).
    # 
    # @param attributeId the ObjectIdentifier of the attribute.
    # @param attributeValue an instance of a class that implements
    # the attribute identified by the ObjectIdentifier.
    def initialize(attribute_id, attribute_value)
      @attribute_id = nil
      @attribute_value = nil
      @attribute_id = attribute_id
      @attribute_value = attribute_value
    end
    
    typesig { [PKCS9Attribute] }
    # 
    # Constructs an attribute from PKCS9 attribute.
    # 
    # @param attr the PKCS9Attribute to create from.
    def initialize(attr)
      @attribute_id = nil
      @attribute_value = nil
      @attribute_id = attr.get_oid
      @attribute_value = attr.get_value
    end
    
    typesig { [OutputStream] }
    # 
    # DER encode this object onto an output stream.
    # Implements the <code>DerEncoder</code> interface.
    # 
    # @param out
    # the OutputStream on which to write the DER encoding.
    # 
    # @exception IOException on encoding errors.
    def der_encode(out)
      attr = PKCS9Attribute.new(@attribute_id, @attribute_value)
      attr.der_encode(out)
    end
    
    typesig { [] }
    # 
    # Returns the ObjectIdentifier of the attribute.
    def get_attribute_id
      return (@attribute_id)
    end
    
    typesig { [] }
    # 
    # Returns the attribute value.
    def get_attribute_value
      return (@attribute_value)
    end
    
    typesig { [] }
    # 
    # Returns the attribute in user readable form.
    def to_s
      return (@attribute_value.to_s)
    end
    
    private
    alias_method :initialize__pkcs10attribute, :initialize
  end
  
end
