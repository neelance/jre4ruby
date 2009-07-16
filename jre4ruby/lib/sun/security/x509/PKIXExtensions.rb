require "rjava"

# 
# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PKIXExtensionsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Io
      include ::Sun::Security::Util
    }
  end
  
  # 
  # Lists all the object identifiers of the X509 extensions of the PKIX profile.
  # 
  # <p>Extensions are addiitonal attributes which can be inserted in a X509
  # v3 certificate. For example a "Driving License Certificate" could have
  # the driving license number as a extension.
  # 
  # <p>Extensions are represented as a sequence of the extension identifier
  # (Object Identifier), a boolean flag stating whether the extension is to
  # be treated as being critical and the extension value itself (this is again
  # a DER encoding of the extension value).
  # 
  # @see Extension
  # 
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class PKIXExtensions 
    include_class_members PKIXExtensionsImports
    
    class_module.module_eval {
      # The object identifiers
      const_set_lazy(:AuthorityKey_data) { Array.typed(::Java::Int).new([2, 5, 29, 35]) }
      const_attr_reader  :AuthorityKey_data
      
      const_set_lazy(:SubjectKey_data) { Array.typed(::Java::Int).new([2, 5, 29, 14]) }
      const_attr_reader  :SubjectKey_data
      
      const_set_lazy(:KeyUsage_data) { Array.typed(::Java::Int).new([2, 5, 29, 15]) }
      const_attr_reader  :KeyUsage_data
      
      const_set_lazy(:PrivateKeyUsage_data) { Array.typed(::Java::Int).new([2, 5, 29, 16]) }
      const_attr_reader  :PrivateKeyUsage_data
      
      const_set_lazy(:CertificatePolicies_data) { Array.typed(::Java::Int).new([2, 5, 29, 32]) }
      const_attr_reader  :CertificatePolicies_data
      
      const_set_lazy(:PolicyMappings_data) { Array.typed(::Java::Int).new([2, 5, 29, 33]) }
      const_attr_reader  :PolicyMappings_data
      
      const_set_lazy(:SubjectAlternativeName_data) { Array.typed(::Java::Int).new([2, 5, 29, 17]) }
      const_attr_reader  :SubjectAlternativeName_data
      
      const_set_lazy(:IssuerAlternativeName_data) { Array.typed(::Java::Int).new([2, 5, 29, 18]) }
      const_attr_reader  :IssuerAlternativeName_data
      
      const_set_lazy(:SubjectDirectoryAttributes_data) { Array.typed(::Java::Int).new([2, 5, 29, 9]) }
      const_attr_reader  :SubjectDirectoryAttributes_data
      
      const_set_lazy(:BasicConstraints_data) { Array.typed(::Java::Int).new([2, 5, 29, 19]) }
      const_attr_reader  :BasicConstraints_data
      
      const_set_lazy(:NameConstraints_data) { Array.typed(::Java::Int).new([2, 5, 29, 30]) }
      const_attr_reader  :NameConstraints_data
      
      const_set_lazy(:PolicyConstraints_data) { Array.typed(::Java::Int).new([2, 5, 29, 36]) }
      const_attr_reader  :PolicyConstraints_data
      
      const_set_lazy(:CRLDistributionPoints_data) { Array.typed(::Java::Int).new([2, 5, 29, 31]) }
      const_attr_reader  :CRLDistributionPoints_data
      
      const_set_lazy(:CRLNumber_data) { Array.typed(::Java::Int).new([2, 5, 29, 20]) }
      const_attr_reader  :CRLNumber_data
      
      const_set_lazy(:IssuingDistributionPoint_data) { Array.typed(::Java::Int).new([2, 5, 29, 28]) }
      const_attr_reader  :IssuingDistributionPoint_data
      
      const_set_lazy(:DeltaCRLIndicator_data) { Array.typed(::Java::Int).new([2, 5, 29, 27]) }
      const_attr_reader  :DeltaCRLIndicator_data
      
      const_set_lazy(:ReasonCode_data) { Array.typed(::Java::Int).new([2, 5, 29, 21]) }
      const_attr_reader  :ReasonCode_data
      
      const_set_lazy(:HoldInstructionCode_data) { Array.typed(::Java::Int).new([2, 5, 29, 23]) }
      const_attr_reader  :HoldInstructionCode_data
      
      const_set_lazy(:InvalidityDate_data) { Array.typed(::Java::Int).new([2, 5, 29, 24]) }
      const_attr_reader  :InvalidityDate_data
      
      const_set_lazy(:ExtendedKeyUsage_data) { Array.typed(::Java::Int).new([2, 5, 29, 37]) }
      const_attr_reader  :ExtendedKeyUsage_data
      
      const_set_lazy(:InhibitAnyPolicy_data) { Array.typed(::Java::Int).new([2, 5, 29, 54]) }
      const_attr_reader  :InhibitAnyPolicy_data
      
      const_set_lazy(:CertificateIssuer_data) { Array.typed(::Java::Int).new([2, 5, 29, 29]) }
      const_attr_reader  :CertificateIssuer_data
      
      const_set_lazy(:AuthInfoAccess_data) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 1, 1]) }
      const_attr_reader  :AuthInfoAccess_data
      
      const_set_lazy(:SubjectInfoAccess_data) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 1, 11]) }
      const_attr_reader  :SubjectInfoAccess_data
      
      const_set_lazy(:FreshestCRL_data) { Array.typed(::Java::Int).new([2, 5, 29, 46]) }
      const_attr_reader  :FreshestCRL_data
      
      when_class_loaded do
        const_set :AuthorityKey_Id, ObjectIdentifier.new_internal(AuthorityKey_data)
        const_set :SubjectKey_Id, ObjectIdentifier.new_internal(SubjectKey_data)
        const_set :KeyUsage_Id, ObjectIdentifier.new_internal(KeyUsage_data)
        const_set :PrivateKeyUsage_Id, ObjectIdentifier.new_internal(PrivateKeyUsage_data)
        const_set :CertificatePolicies_Id, ObjectIdentifier.new_internal(CertificatePolicies_data)
        const_set :PolicyMappings_Id, ObjectIdentifier.new_internal(PolicyMappings_data)
        const_set :SubjectAlternativeName_Id, ObjectIdentifier.new_internal(SubjectAlternativeName_data)
        const_set :IssuerAlternativeName_Id, ObjectIdentifier.new_internal(IssuerAlternativeName_data)
        const_set :ExtendedKeyUsage_Id, ObjectIdentifier.new_internal(ExtendedKeyUsage_data)
        const_set :InhibitAnyPolicy_Id, ObjectIdentifier.new_internal(InhibitAnyPolicy_data)
        const_set :SubjectDirectoryAttributes_Id, ObjectIdentifier.new_internal(SubjectDirectoryAttributes_data)
        const_set :BasicConstraints_Id, ObjectIdentifier.new_internal(BasicConstraints_data)
        const_set :ReasonCode_Id, ObjectIdentifier.new_internal(ReasonCode_data)
        const_set :HoldInstructionCode_Id, ObjectIdentifier.new_internal(HoldInstructionCode_data)
        const_set :InvalidityDate_Id, ObjectIdentifier.new_internal(InvalidityDate_data)
        const_set :NameConstraints_Id, ObjectIdentifier.new_internal(NameConstraints_data)
        const_set :PolicyConstraints_Id, ObjectIdentifier.new_internal(PolicyConstraints_data)
        const_set :CRLDistributionPoints_Id, ObjectIdentifier.new_internal(CRLDistributionPoints_data)
        const_set :CRLNumber_Id, ObjectIdentifier.new_internal(CRLNumber_data)
        const_set :IssuingDistributionPoint_Id, ObjectIdentifier.new_internal(IssuingDistributionPoint_data)
        const_set :DeltaCRLIndicator_Id, ObjectIdentifier.new_internal(DeltaCRLIndicator_data)
        const_set :CertificateIssuer_Id, ObjectIdentifier.new_internal(CertificateIssuer_data)
        const_set :AuthInfoAccess_Id, ObjectIdentifier.new_internal(AuthInfoAccess_data)
        const_set :SubjectInfoAccess_Id, ObjectIdentifier.new_internal(SubjectInfoAccess_data)
        const_set :FreshestCRL_Id, ObjectIdentifier.new_internal(FreshestCRL_data)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__pkixextensions, :initialize
  end
  
end
