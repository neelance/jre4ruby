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
  module CertificatePolicyIdImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # Represent the CertificatePolicyId ASN.1 object.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class CertificatePolicyId 
    include_class_members CertificatePolicyIdImports
    
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    typesig { [ObjectIdentifier] }
    # Create a CertificatePolicyId with the ObjectIdentifier.
    # 
    # @param id the ObjectIdentifier for the policy id.
    def initialize(id)
      @id = nil
      @id = id
    end
    
    typesig { [DerValue] }
    # Create the object from its Der encoded value.
    # 
    # @param val the DER encoded value for the same.
    def initialize(val)
      @id = nil
      @id = val.get_oid
    end
    
    typesig { [] }
    # Return the value of the CertificatePolicyId as an ObjectIdentifier.
    def get_identifier
      return (@id)
    end
    
    typesig { [] }
    # Returns a printable representation of the CertificatePolicyId.
    def to_s
      s = "CertificatePolicyId: [" + (@id.to_s).to_s + "]\n"
      return (s)
    end
    
    typesig { [DerOutputStream] }
    # Write the CertificatePolicyId to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the object to.
    # @exception IOException on errors.
    def encode(out)
      out.put_oid(@id)
    end
    
    typesig { [Object] }
    # Compares this CertificatePolicyId with another, for
    # equality. Uses ObjectIdentifier.equals() as test for
    # equality.
    # 
    # @return true iff the ids are identical.
    def equals(other)
      if (other.is_a?(CertificatePolicyId))
        return (@id == (other).get_identifier)
      else
        return false
      end
    end
    
    typesig { [] }
    # Returns a hash code value for this object.
    # 
    # @return a hash code value
    def hash_code
      return @id.hash_code
    end
    
    private
    alias_method :initialize__certificate_policy_id, :initialize
  end
  
end
