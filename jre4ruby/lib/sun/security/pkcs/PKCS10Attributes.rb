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
  module PKCS10AttributesImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the PKCS10 attributes for the request.
  # The ASN.1 syntax for this is:
  # <pre>
  # Attributes ::= SET OF Attribute
  # </pre>
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see PKCS10
  # @see PKCS10Attribute
  class PKCS10Attributes 
    include_class_members PKCS10AttributesImports
    include DerEncoder
    
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    typesig { [] }
    # Default constructor for the PKCS10 attribute.
    def initialize
      @map = Hashtable.new(3)
    end
    
    typesig { [Array.typed(PKCS10Attribute)] }
    # Create the object from the array of PKCS10Attribute objects.
    # 
    # @param attrs the array of PKCS10Attribute objects.
    def initialize(attrs)
      @map = Hashtable.new(3)
      i = 0
      while i < attrs.attr_length
        @map.put(attrs[i].get_attribute_id.to_s, attrs[i])
        ((i += 1) - 1)
      end
    end
    
    typesig { [DerInputStream] }
    # Create the object, decoding the values from the passed DER stream.
    # The DER stream contains the SET OF Attribute.
    # 
    # @param in the DerInputStream to read the attributes from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @map = Hashtable.new(3)
      attrs = in_.get_set(3, true)
      if ((attrs).nil?)
        raise IOException.new("Illegal encoding of attributes")
      end
      i = 0
      while i < attrs.attr_length
        attr = PKCS10Attribute.new(attrs[i])
        @map.put(attr.get_attribute_id.to_s, attr)
        ((i += 1) - 1)
      end
    end
    
    typesig { [OutputStream] }
    # Encode the attributes in DER form to the stream.
    # 
    # @param out the OutputStream to marshal the contents to.
    # @exception IOException on encoding errors.
    def encode(out)
      der_encode(out)
    end
    
    typesig { [OutputStream] }
    # Encode the attributes in DER form to the stream.
    # Implements the <code>DerEncoder</code> interface.
    # 
    # @param out the OutputStream to marshal the contents to.
    # @exception IOException on encoding errors.
    def der_encode(out)
      # first copy the elements into an array
      all_attrs = @map.values
      attribs = all_attrs.to_array(Array.typed(PKCS10Attribute).new(@map.size) { nil })
      attr_out = DerOutputStream.new
      attr_out.put_ordered_set_of(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0), attribs)
      out.write(attr_out.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set_attribute(name, obj)
      if (obj.is_a?(PKCS10Attribute))
        @map.put(name, obj)
      end
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get_attribute(name)
      return @map.get(name)
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete_attribute(name)
      @map.remove(name)
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      return (@map.elements)
    end
    
    typesig { [] }
    # Return a Collection of attributes existing within this
    # PKCS10Attributes object.
    def get_attributes
      return (Collections.unmodifiable_collection(@map.values))
    end
    
    typesig { [Object] }
    # Compares this PKCS10Attributes for equality with the specified
    # object. If the <code>other</code> object is an
    # <code>instanceof</code> <code>PKCS10Attributes</code>, then
    # all the entries are compared with the entries from this.
    # 
    # @param other the object to test for equality with this PKCS10Attributes.
    # @return true if all the entries match that of the Other,
    # false otherwise.
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(PKCS10Attributes)))
        return false
      end
      others_attribs = (other).get_attributes
      attrs = others_attribs.to_array(Array.typed(PKCS10Attribute).new(others_attribs.size) { nil })
      len = attrs.attr_length
      if (!(len).equal?(@map.size))
        return false
      end
      this_attr = nil
      other_attr = nil
      key = nil
      i = 0
      while i < len
        other_attr = attrs[i]
        key = (other_attr.get_attribute_id.to_s).to_s
        if ((key).nil?)
          return false
        end
        this_attr = @map.get(key)
        if ((this_attr).nil?)
          return false
        end
        if (!(this_attr == other_attr))
          return false
        end
        ((i += 1) - 1)
      end
      return true
    end
    
    typesig { [] }
    # Returns a hashcode value for this PKCS10Attributes.
    # 
    # @return the hashcode value.
    def hash_code
      return @map.hash_code
    end
    
    typesig { [] }
    # Returns a string representation of this <tt>PKCS10Attributes</tt> object
    # in the form of a set of entries, enclosed in braces and separated
    # by the ASCII characters "<tt>,&nbsp;</tt>" (comma and space).
    # <p>Overrides the <tt>toString</tt> method of <tt>Object</tt>.
    # 
    # @return  a string representation of this PKCS10Attributes.
    def to_s
      s = (@map.size).to_s + "\n" + (@map.to_s).to_s
      return s
    end
    
    private
    alias_method :initialize__pkcs10attributes, :initialize
  end
  
end
