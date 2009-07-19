require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module OtherNameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Util, :Arrays
      include ::Sun::Security::Util
    }
  end
  
  # This class represents the OtherName as required by the GeneralNames
  # ASN.1 object. It supplies the generic framework to allow specific
  # Other Name types, and also provides minimal support for unrecognized
  # Other Name types.
  # 
  # The ASN.1 definition for OtherName is:
  # <pre>
  # OtherName ::= SEQUENCE {
  # type-id    OBJECT IDENTIFIER,
  # value      [0] EXPLICIT ANY DEFINED BY type-id
  # }
  # </pre>
  # @author Hemma Prafullchandra
  class OtherName 
    include_class_members OtherNameImports
    include GeneralNameInterface
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :oid
    alias_method :attr_oid, :oid
    undef_method :oid
    alias_method :attr_oid=, :oid=
    undef_method :oid=
    
    attr_accessor :name_value
    alias_method :attr_name_value, :name_value
    undef_method :name_value
    alias_method :attr_name_value=, :name_value=
    undef_method :name_value=
    
    attr_accessor :gni
    alias_method :attr_gni, :gni
    undef_method :gni
    alias_method :attr_gni=, :gni=
    undef_method :gni=
    
    class_module.module_eval {
      const_set_lazy(:TAG_VALUE) { 0 }
      const_attr_reader  :TAG_VALUE
    }
    
    attr_accessor :myhash
    alias_method :attr_myhash, :myhash
    undef_method :myhash
    alias_method :attr_myhash=, :myhash=
    undef_method :myhash=
    
    typesig { [ObjectIdentifier, Array.typed(::Java::Byte)] }
    # Create the OtherName object from a passed ObjectIdentfier and
    # byte array name value
    # 
    # @param oid ObjectIdentifier of this OtherName object
    # @param value the DER-encoded value of the OtherName
    # @throws IOException on error
    def initialize(oid, value)
      @name = nil
      @oid = nil
      @name_value = nil
      @gni = nil
      @myhash = -1
      if ((oid).nil? || (value).nil?)
        raise NullPointerException.new("parameters may not be null")
      end
      @oid = oid
      @name_value = value
      @gni = get_gni(oid, value)
      if (!(@gni).nil?)
        @name = (@gni.to_s).to_s
      else
        @name = "Unrecognized ObjectIdentifier: " + (oid.to_s).to_s
      end
    end
    
    typesig { [DerValue] }
    # Create the OtherName object from the passed encoded Der value.
    # 
    # @param derValue the encoded DER OtherName.
    # @exception IOException on error.
    def initialize(der_value)
      @name = nil
      @oid = nil
      @name_value = nil
      @gni = nil
      @myhash = -1
      in_ = der_value.to_der_input_stream
      @oid = in_.get_oid
      val = in_.get_der_value
      @name_value = val.to_byte_array
      @gni = get_gni(@oid, @name_value)
      if (!(@gni).nil?)
        @name = (@gni.to_s).to_s
      else
        @name = "Unrecognized ObjectIdentifier: " + (@oid.to_s).to_s
      end
    end
    
    typesig { [] }
    # Get ObjectIdentifier
    def get_oid
      # XXXX May want to consider cloning this
      return @oid
    end
    
    typesig { [] }
    # Get name value
    def get_name_value
      return @name_value.clone
    end
    
    typesig { [ObjectIdentifier, Array.typed(::Java::Byte)] }
    # Get GeneralNameInterface
    def get_gni(oid, name_value)
      begin
        ext_class = OIDMap.get_class(oid)
        if ((ext_class).nil?)
          # Unsupported OtherName
          return nil
        end
        params = Array.typed(Class).new([Object.class])
        cons = (ext_class).get_constructor(params)
        passed = Array.typed(Object).new([name_value])
        gni = cons.new_instance(passed)
        return gni
      rescue Exception => e
        raise IOException.new("Instantiation error: " + (e).to_s).init_cause(e)
      end
    end
    
    typesig { [] }
    # Return the type of the GeneralName.
    def get_type
      return GeneralNameInterface::NAME_ANY
    end
    
    typesig { [DerOutputStream] }
    # Encode the Other name into the DerOutputStream.
    # 
    # @param out the DER stream to encode the Other-Name to.
    # @exception IOException on encoding errors.
    def encode(out)
      if (!(@gni).nil?)
        # This OtherName has a supported class
        @gni.encode(out)
        return
      else
        # This OtherName has no supporting class
        tmp = DerOutputStream.new
        tmp.put_oid(@oid)
        tmp.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_VALUE), @name_value)
        out.write(DerValue.attr_tag_sequence, tmp)
      end
    end
    
    typesig { [Object] }
    # Compares this name with another, for equality.
    # 
    # @return true iff the names are identical.
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(OtherName)))
        return false
      end
      other_other = other
      if (!((other_other.attr_oid == @oid)))
        return false
      end
      other_gni = nil
      begin
        other_gni = get_gni(other_other.attr_oid, other_other.attr_name_value)
      rescue IOException => ioe
        return false
      end
      result = false
      if (!(other_gni).nil?)
        begin
          result = ((other_gni.constrains(self)).equal?(NAME_MATCH))
        rescue UnsupportedOperationException => ioe
          result = false
        end
      else
        result = (Arrays == @name_value)
      end
      return result
    end
    
    typesig { [] }
    # Returns the hash code for this OtherName.
    # 
    # @return a hash code value.
    def hash_code
      if ((@myhash).equal?(-1))
        @myhash = 37 + @oid.hash_code
        i = 0
        while i < @name_value.attr_length
          @myhash = 37 * @myhash + @name_value[i]
          ((i += 1) - 1)
        end
      end
      return @myhash
    end
    
    typesig { [] }
    # Convert the name into user readable string.
    def to_s
      return "Other-Name: " + @name
    end
    
    typesig { [GeneralNameInterface] }
    # Return type of constraint inputName places on this name:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name
    # (i.e. does not constrain).
    # <li>NAME_MATCH = 0: input name matches name.
    # <li>NAME_NARROWS = 1: input name narrows name (is lower in the
    # naming subtree)
    # <li>NAME_WIDENS = 2: input name widens name (is higher in the
    # naming subtree)
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name,
    # but is same type.
    # </ul>.  These results are used in checking NameConstraints during
    # certification path verification.
    # 
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is same type, but
    # comparison operations are not supported for this name type.
    def constrains(input_name)
      constraint_type = 0
      if ((input_name).nil?)
        constraint_type = NAME_DIFF_TYPE
      else
        if (!(input_name.get_type).equal?(NAME_ANY))
          constraint_type = NAME_DIFF_TYPE
        else
          raise UnsupportedOperationException.new("Narrowing, widening, " + "and matching are not supported for OtherName.")
        end
      end
      return constraint_type
    end
    
    typesig { [] }
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      raise UnsupportedOperationException.new("subtreeDepth() not supported for generic OtherName")
    end
    
    private
    alias_method :initialize__other_name, :initialize
  end
  
end
