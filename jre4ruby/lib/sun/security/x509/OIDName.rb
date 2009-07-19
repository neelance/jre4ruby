require "rjava"

# Copyright 1997-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module OIDNameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # This class implements the OIDName as required by the GeneralNames
  # ASN.1 object.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see GeneralName
  # @see GeneralNames
  # @see GeneralNameInterface
  class OIDName 
    include_class_members OIDNameImports
    include GeneralNameInterface
    
    attr_accessor :oid
    alias_method :attr_oid, :oid
    undef_method :oid
    alias_method :attr_oid=, :oid=
    undef_method :oid=
    
    typesig { [DerValue] }
    # Create the OIDName object from the passed encoded Der value.
    # 
    # @param derValue the encoded DER OIDName.
    # @exception IOException on error.
    def initialize(der_value)
      @oid = nil
      @oid = der_value.get_oid
    end
    
    typesig { [ObjectIdentifier] }
    # Create the OIDName object with the specified name.
    # 
    # @param name the OIDName.
    def initialize(oid)
      @oid = nil
      @oid = oid
    end
    
    typesig { [String] }
    # Create the OIDName from the String form of the OID
    # 
    # @param name the OIDName in form "x.y.z..."
    # @throws IOException on error
    def initialize(name)
      @oid = nil
      begin
        @oid = ObjectIdentifier.new(name)
      rescue Exception => e
        raise IOException.new("Unable to create OIDName: " + (e).to_s)
      end
    end
    
    typesig { [] }
    # Return the type of the GeneralName.
    def get_type
      return (GeneralNameInterface::NAME_OID)
    end
    
    typesig { [DerOutputStream] }
    # Encode the OID name into the DerOutputStream.
    # 
    # @param out the DER stream to encode the OIDName to.
    # @exception IOException on encoding errors.
    def encode(out)
      out.put_oid(@oid)
    end
    
    typesig { [] }
    # Convert the name into user readable string.
    def to_s
      return ("OIDName: " + (@oid.to_s).to_s)
    end
    
    typesig { [] }
    # Returns this OID name.
    def get_oid
      return @oid
    end
    
    typesig { [Object] }
    # Compares this name with another, for equality.
    # 
    # @return true iff the names are identical
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(OIDName)))
        return false
      end
      other = obj
      return (@oid == other.attr_oid)
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      return @oid.hash_code
    end
    
    typesig { [GeneralNameInterface] }
    # Return type of constraint inputName places on this name:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name (i.e. does not constrain).
    # <li>NAME_MATCH = 0: input name matches name.
    # <li>NAME_NARROWS = 1: input name narrows name (is lower in the naming subtree)
    # <li>NAME_WIDENS = 2: input name widens name (is higher in the naming subtree)
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name, but is same type.
    # </ul>.  These results are used in checking NameConstraints during
    # certification path verification.
    # 
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is not exact match, but narrowing and widening are
    # not supported for this name type.
    def constrains(input_name)
      constraint_type = 0
      if ((input_name).nil?)
        constraint_type = NAME_DIFF_TYPE
      else
        if (!(input_name.get_type).equal?(NAME_OID))
          constraint_type = NAME_DIFF_TYPE
        else
          if ((self == input_name))
            constraint_type = NAME_MATCH
          else
            # widens and narrows not defined in RFC2459 for OIDName (aka registeredID)
            raise UnsupportedOperationException.new("Narrowing and widening are not supported for OIDNames")
          end
        end
      end
      return constraint_type
    end
    
    typesig { [] }
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds and for calculating
    # path lengths in name subtrees.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      raise UnsupportedOperationException.new("subtreeDepth() not supported for OIDName.")
    end
    
    private
    alias_method :initialize__oidname, :initialize
  end
  
end
