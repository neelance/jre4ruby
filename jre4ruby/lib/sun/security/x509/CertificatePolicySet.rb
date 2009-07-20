require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertificatePolicySetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Collections
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the certificate policy set ASN.1 object.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class CertificatePolicySet 
    include_class_members CertificatePolicySetImports
    
    attr_accessor :ids
    alias_method :attr_ids, :ids
    undef_method :ids
    alias_method :attr_ids=, :ids=
    undef_method :ids=
    
    typesig { [Vector] }
    # The default constructor for this class.
    # 
    # @param ids the sequence of CertificatePolicyId's.
    def initialize(ids)
      @ids = nil
      @ids = ids
    end
    
    typesig { [DerInputStream] }
    # Create the object from the DerValue.
    # 
    # @param in the passed DerInputStream.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @ids = nil
      @ids = Vector.new
      seq = in_.get_sequence(5)
      i = 0
      while i < seq.attr_length
        id = CertificatePolicyId.new(seq[i])
        @ids.add_element(id)
        i += 1
      end
    end
    
    typesig { [] }
    # Return printable form of the object.
    def to_s
      s = "CertificatePolicySet:[\n" + (@ids.to_s).to_s + "]\n"
      return (s)
    end
    
    typesig { [DerOutputStream] }
    # Encode the policy set to the output stream.
    # 
    # @param out the DerOutputStream to encode the data to.
    def encode(out)
      tmp = DerOutputStream.new
      i = 0
      while i < @ids.size
        (@ids.element_at(i)).encode(tmp)
        i += 1
      end
      out.write(DerValue.attr_tag_sequence, tmp)
    end
    
    typesig { [] }
    # Return the sequence of CertificatePolicyIds.
    # 
    # @return A List containing the CertificatePolicyId objects.
    def get_cert_policy_ids
      return Collections.unmodifiable_list(@ids)
    end
    
    private
    alias_method :initialize__certificate_policy_set, :initialize
  end
  
end
