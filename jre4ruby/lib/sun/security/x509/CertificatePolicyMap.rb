require "rjava"

# 
# Copyright 1997 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertificatePolicyMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # 
  # Represent the CertificatePolicyMap ASN.1 object.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class CertificatePolicyMap 
    include_class_members CertificatePolicyMapImports
    
    attr_accessor :issuer_domain
    alias_method :attr_issuer_domain, :issuer_domain
    undef_method :issuer_domain
    alias_method :attr_issuer_domain=, :issuer_domain=
    undef_method :issuer_domain=
    
    attr_accessor :subject_domain
    alias_method :attr_subject_domain, :subject_domain
    undef_method :subject_domain
    alias_method :attr_subject_domain=, :subject_domain=
    undef_method :subject_domain=
    
    typesig { [CertificatePolicyId, CertificatePolicyId] }
    # 
    # Create a CertificatePolicyMap with the passed CertificatePolicyId's.
    # 
    # @param issuer the CertificatePolicyId for the issuer CA.
    # @param subject the CertificatePolicyId for the subject CA.
    def initialize(issuer, subject)
      @issuer_domain = nil
      @subject_domain = nil
      @issuer_domain = issuer
      @subject_domain = subject
    end
    
    typesig { [DerValue] }
    # 
    # Create the CertificatePolicyMap from the DER encoded value.
    # 
    # @param val the DER encoded value of the same.
    def initialize(val)
      @issuer_domain = nil
      @subject_domain = nil
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for CertificatePolicyMap")
      end
      @issuer_domain = CertificatePolicyId.new(val.attr_data.get_der_value)
      @subject_domain = CertificatePolicyId.new(val.attr_data.get_der_value)
    end
    
    typesig { [] }
    # 
    # Return the issuer CA part of the policy map.
    def get_issuer_identifier
      return (@issuer_domain)
    end
    
    typesig { [] }
    # 
    # Return the subject CA part of the policy map.
    def get_subject_identifier
      return (@subject_domain)
    end
    
    typesig { [] }
    # 
    # Returns a printable representation of the CertificatePolicyId.
    def to_s
      s = "CertificatePolicyMap: [\n" + "IssuerDomain:" + (@issuer_domain.to_s).to_s + "SubjectDomain:" + (@subject_domain.to_s).to_s + "]\n"
      return (s)
    end
    
    typesig { [DerOutputStream] }
    # 
    # Write the CertificatePolicyMap to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the object to.
    # @exception IOException on errors.
    def encode(out)
      tmp = DerOutputStream.new
      @issuer_domain.encode(tmp)
      @subject_domain.encode(tmp)
      out.write(DerValue.attr_tag_sequence, tmp)
    end
    
    private
    alias_method :initialize__certificate_policy_map, :initialize
  end
  
end
