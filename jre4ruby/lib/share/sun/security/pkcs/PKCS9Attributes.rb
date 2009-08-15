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
  module PKCS9AttributesImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Hashtable
      include_const ::Sun::Security::Util, :DerEncoder
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :ObjectIdentifier
    }
  end
  
  # A set of attributes of class PKCS9Attribute.
  # 
  # @author Douglas Hoover
  class PKCS9Attributes 
    include_class_members PKCS9AttributesImports
    
    # Attributes in this set indexed by OID.
    attr_accessor :attributes
    alias_method :attr_attributes, :attributes
    undef_method :attributes
    alias_method :attr_attributes=, :attributes=
    undef_method :attributes=
    
    # The keys of this hashtable are the OIDs of permitted attributes.
    attr_accessor :permitted_attributes
    alias_method :attr_permitted_attributes, :permitted_attributes
    undef_method :permitted_attributes
    alias_method :attr_permitted_attributes=, :permitted_attributes=
    undef_method :permitted_attributes=
    
    # The DER encoding of this attribute set.  The tag byte must be
    # DerValue.tag_SetOf.
    attr_accessor :der_encoding
    alias_method :attr_der_encoding, :der_encoding
    undef_method :der_encoding
    alias_method :attr_der_encoding=, :der_encoding=
    undef_method :der_encoding=
    
    # Contols how attributes, which are not recognized by the PKCS9Attribute
    # class, are handled during parsing.
    attr_accessor :ignore_unsupported_attributes
    alias_method :attr_ignore_unsupported_attributes, :ignore_unsupported_attributes
    undef_method :ignore_unsupported_attributes
    alias_method :attr_ignore_unsupported_attributes=, :ignore_unsupported_attributes=
    undef_method :ignore_unsupported_attributes=
    
    typesig { [Array.typed(ObjectIdentifier), DerInputStream] }
    # Construct a set of PKCS9 Attributes from its
    # DER encoding on a DerInputStream, accepting only attributes
    # with OIDs on the given
    # list.  If the array is null, accept all attributes supported by
    # class PKCS9Attribute.
    # 
    # @param permittedAttributes
    # Array of attribute OIDs that will be accepted.
    # @param in
    # the contents of the DER encoding of the attribute set.
    # 
    # @exception IOException
    # on i/o error, encoding syntax error, unacceptable or
    # unsupported attribute, or duplicate attribute.
    # 
    # @see PKCS9Attribute
    def initialize(permitted_attributes, in_)
      @attributes = Hashtable.new(3)
      @permitted_attributes = nil
      @der_encoding = nil
      @ignore_unsupported_attributes = false
      if (!(permitted_attributes).nil?)
        @permitted_attributes = Hashtable.new(permitted_attributes.attr_length)
        i = 0
        while i < permitted_attributes.attr_length
          @permitted_attributes.put(permitted_attributes[i], permitted_attributes[i])
          i += 1
        end
      else
        @permitted_attributes = nil
      end
      # derEncoding initialized in <code>decode()</code>
      @der_encoding = decode(in_)
    end
    
    typesig { [DerInputStream] }
    # Construct a set of PKCS9 Attributes from the contents of its
    # DER encoding on a DerInputStream.  Accept all attributes
    # supported by class PKCS9Attribute and reject any unsupported
    # attributes.
    # 
    # @param in the contents of the DER encoding of the attribute set.
    # @exception IOException
    # on i/o error, encoding syntax error, or unsupported or
    # duplicate attribute.
    # 
    # @see PKCS9Attribute
    def initialize(in_)
      initialize__pkcs9attributes(in_, false)
    end
    
    typesig { [DerInputStream, ::Java::Boolean] }
    # Construct a set of PKCS9 Attributes from the contents of its
    # DER encoding on a DerInputStream.  Accept all attributes
    # supported by class PKCS9Attribute and ignore any unsupported
    # attributes, if directed.
    # 
    # @param in the contents of the DER encoding of the attribute set.
    # @param ignoreUnsupportedAttributes If true then any attributes
    # not supported by the PKCS9Attribute class are ignored. Otherwise
    # unsupported attributes cause an exception to be thrown.
    # @exception IOException
    # on i/o error, encoding syntax error, or unsupported or
    # duplicate attribute.
    # 
    # @see PKCS9Attribute
    def initialize(in_, ignore_unsupported_attributes)
      @attributes = Hashtable.new(3)
      @permitted_attributes = nil
      @der_encoding = nil
      @ignore_unsupported_attributes = false
      @ignore_unsupported_attributes = ignore_unsupported_attributes
      # derEncoding initialized in <code>decode()</code>
      @der_encoding = decode(in_)
      @permitted_attributes = nil
    end
    
    typesig { [Array.typed(PKCS9Attribute)] }
    # Construct a set of PKCS9 Attributes from the given array of
    # PKCS9 attributes.
    # DER encoding on a DerInputStream.  All attributes in
    # <code>attribs</code> must be
    # supported by class PKCS9Attribute.
    # 
    # @exception IOException
    # on i/o error, encoding syntax error, or unsupported or
    # duplicate attribute.
    # 
    # @see PKCS9Attribute
    def initialize(attribs)
      @attributes = Hashtable.new(3)
      @permitted_attributes = nil
      @der_encoding = nil
      @ignore_unsupported_attributes = false
      oid = nil
      i = 0
      while i < attribs.attr_length
        oid = attribs[i].get_oid
        if (@attributes.contains_key(oid))
          raise IllegalArgumentException.new("PKCSAttribute " + RJava.cast_to_string(attribs[i].get_oid) + " duplicated while constructing " + "PKCS9Attributes.")
        end
        @attributes.put(oid, attribs[i])
        i += 1
      end
      @der_encoding = generate_der_encoding
      @permitted_attributes = nil
    end
    
    typesig { [DerInputStream] }
    # Decode this set of PKCS9 attributes from the contents of its
    # DER encoding. Ignores unsupported attributes when directed.
    # 
    # @param in
    # the contents of the DER encoding of the attribute set.
    # 
    # @exception IOException
    # on i/o error, encoding syntax error, unacceptable or
    # unsupported attribute, or duplicate attribute.
    def decode(in_)
      val = in_.get_der_value
      # save the DER encoding with its proper tag byte.
      der_encoding = val.to_byte_array
      der_encoding[0] = DerValue.attr_tag_set_of
      der_in = DerInputStream.new(der_encoding)
      der_vals = der_in.get_set(3, true)
      attrib = nil
      oid = nil
      reuse_encoding = true
      i = 0
      while i < der_vals.attr_length
        begin
          attrib = PKCS9Attribute.new(der_vals[i])
        rescue ParsingException => e
          if (@ignore_unsupported_attributes)
            reuse_encoding = false # cannot reuse supplied DER encoding
            i += 1
            next # skip
          else
            raise e
          end
        end
        oid = attrib.get_oid
        if (!(@attributes.get(oid)).nil?)
          raise IOException.new("Duplicate PKCS9 attribute: " + RJava.cast_to_string(oid))
        end
        if (!(@permitted_attributes).nil? && !@permitted_attributes.contains_key(oid))
          raise IOException.new("Attribute " + RJava.cast_to_string(oid) + " not permitted in this attribute set")
        end
        @attributes.put(oid, attrib)
        i += 1
      end
      return reuse_encoding ? der_encoding : generate_der_encoding
    end
    
    typesig { [::Java::Byte, OutputStream] }
    # Put the DER encoding of this PKCS9 attribute set on an
    # DerOutputStream, tagged with the given implicit tag.
    # 
    # @param tag the implicit tag to use in the DER encoding.
    # @param out the output stream on which to put the DER encoding.
    # 
    # @exception IOException  on output error.
    def encode(tag, out)
      out.write(tag)
      out.write(@der_encoding, 1, @der_encoding.attr_length - 1)
    end
    
    typesig { [] }
    def generate_der_encoding
      out = DerOutputStream.new
      attrib_vals = @attributes.values.to_array
      out.put_ordered_set_of(DerValue.attr_tag_set_of, cast_to_der_encoder(attrib_vals))
      return out.to_byte_array
    end
    
    typesig { [] }
    # Return the DER encoding of this attribute set, tagged with
    # DerValue.tag_SetOf.
    def get_der_encoding
      return @der_encoding.clone
    end
    
    typesig { [ObjectIdentifier] }
    # Get an attribute from this set.
    def get_attribute(oid)
      return @attributes.get(oid)
    end
    
    typesig { [String] }
    # Get an attribute from this set.
    def get_attribute(name)
      return @attributes.get(PKCS9Attribute.get_oid(name))
    end
    
    typesig { [] }
    # Get an array of all attributes in this set, in order of OID.
    def get_attributes
      attribs = Array.typed(PKCS9Attribute).new(@attributes.size) { nil }
      oid = nil
      j = 0
      i = 1
      while i < PKCS9Attribute::PKCS9_OIDS.attr_length && j < attribs.attr_length
        attribs[j] = get_attribute(PKCS9Attribute::PKCS9_OIDS[i])
        if (!(attribs[j]).nil?)
          j += 1
        end
        i += 1
      end
      return attribs
    end
    
    typesig { [ObjectIdentifier] }
    # Get an attribute value by OID.
    def get_attribute_value(oid)
      begin
        value = get_attribute(oid).get_value
        return value
      rescue NullPointerException => ex
        raise IOException.new("No value found for attribute " + RJava.cast_to_string(oid))
      end
    end
    
    typesig { [String] }
    # Get an attribute value by type name.
    def get_attribute_value(name)
      oid = PKCS9Attribute.get_oid(name)
      if ((oid).nil?)
        raise IOException.new("Attribute name " + name + " not recognized or not supported.")
      end
      return get_attribute_value(oid)
    end
    
    typesig { [] }
    # Returns the PKCS9 block in a printable string form.
    def to_s
      buf = StringBuffer.new(200)
      buf.append("PKCS9 Attributes: [\n\t")
      oid = nil
      value = nil
      first = true
      i = 1
      while i < PKCS9Attribute::PKCS9_OIDS.attr_length
        value = get_attribute(PKCS9Attribute::PKCS9_OIDS[i])
        if ((value).nil?)
          i += 1
          next
        end
        # we have a value; print it
        if (first)
          first = false
        else
          buf.append(";\n\t")
        end
        buf.append(value.to_s)
        i += 1
      end
      buf.append("\n\t] (end PKCS9 Attributes)")
      return buf.to_s
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Object)] }
      # Cast an object array whose components are
      # <code>DerEncoder</code>s to <code>DerEncoder[]</code>.
      def cast_to_der_encoder(objs)
        encoders = Array.typed(DerEncoder).new(objs.attr_length) { nil }
        i = 0
        while i < encoders.attr_length
          encoders[i] = objs[i]
          i += 1
        end
        return encoders
      end
    }
    
    private
    alias_method :initialize__pkcs9attributes, :initialize
  end
  
end
