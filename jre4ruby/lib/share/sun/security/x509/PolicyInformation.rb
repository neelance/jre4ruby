require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PolicyInformationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :PolicyQualifierInfo
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedHashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # PolicyInformation is the class that contains a specific certificate policy
  # that is part of the CertificatePoliciesExtension. A
  # CertificatePolicyExtension value consists of a vector of these objects.
  # <p>
  # The ASN.1 syntax for PolicyInformation (IMPLICIT tagging is defined in the
  # module definition):
  # <pre>
  # 
  # PolicyInformation ::= SEQUENCE {
  # policyIdentifier   CertPolicyId,
  # policyQualifiers   SEQUENCE SIZE (1..MAX) OF
  # PolicyQualifierInfo OPTIONAL }
  # 
  # CertPolicyId ::= OBJECT IDENTIFIER
  # 
  # PolicyQualifierInfo ::= SEQUENCE {
  # policyQualifierId  PolicyQualifierId,
  # qualifier          ANY DEFINED BY policyQualifierId }
  # </pre>
  # 
  # @author Sean Mullan
  # @author Anne Anderson
  # @since       1.4
  class PolicyInformation 
    include_class_members PolicyInformationImports
    
    class_module.module_eval {
      # Attribute names
      const_set_lazy(:NAME) { "PolicyInformation" }
      const_attr_reader  :NAME
      
      const_set_lazy(:ID) { "id" }
      const_attr_reader  :ID
      
      const_set_lazy(:QUALIFIERS) { "qualifiers" }
      const_attr_reader  :QUALIFIERS
    }
    
    # The policy OID
    attr_accessor :policy_identifier
    alias_method :attr_policy_identifier, :policy_identifier
    undef_method :policy_identifier
    alias_method :attr_policy_identifier=, :policy_identifier=
    undef_method :policy_identifier=
    
    # A Set of java.security.cert.PolicyQualifierInfo objects
    attr_accessor :policy_qualifiers
    alias_method :attr_policy_qualifiers, :policy_qualifiers
    undef_method :policy_qualifiers
    alias_method :attr_policy_qualifiers=, :policy_qualifiers=
    undef_method :policy_qualifiers=
    
    typesig { [CertificatePolicyId, JavaSet] }
    # Create an instance of PolicyInformation
    # 
    # @param policyIdentifier the policyIdentifier as a
    # CertificatePolicyId
    # @param policyQualifiers a Set of PolicyQualifierInfo objects.
    # Must not be NULL. Specify an empty Set for no qualifiers.
    # @exception IOException on decoding errors.
    def initialize(policy_identifier, policy_qualifiers)
      @policy_identifier = nil
      @policy_qualifiers = nil
      if ((policy_qualifiers).nil?)
        raise NullPointerException.new("policyQualifiers is null")
      end
      @policy_qualifiers = LinkedHashSet.new(policy_qualifiers)
      @policy_identifier = policy_identifier
    end
    
    typesig { [DerValue] }
    # Create an instance of PolicyInformation, decoding from
    # the passed DerValue.
    # 
    # @param val the DerValue to construct the PolicyInformation from.
    # @exception IOException on decoding errors.
    def initialize(val)
      @policy_identifier = nil
      @policy_qualifiers = nil
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding of PolicyInformation")
      end
      @policy_identifier = CertificatePolicyId.new(val.attr_data.get_der_value)
      if (!(val.attr_data.available).equal?(0))
        @policy_qualifiers = LinkedHashSet.new
        opt = val.attr_data.get_der_value
        if (!(opt.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("Invalid encoding of PolicyInformation")
        end
        if ((opt.attr_data.available).equal?(0))
          raise IOException.new("No data available in policyQualifiers")
        end
        while (!(opt.attr_data.available).equal?(0))
          @policy_qualifiers.add(PolicyQualifierInfo.new(opt.attr_data.get_der_value.to_byte_array))
        end
      else
        @policy_qualifiers = Collections.empty_set
      end
    end
    
    typesig { [Object] }
    # Compare this PolicyInformation with another object for equality
    # 
    # @param other object to be compared with this
    # @return true iff the PolicyInformation objects match
    def ==(other)
      if (!(other.is_a?(PolicyInformation)))
        return false
      end
      pi_other = other
      if (!(@policy_identifier == pi_other.get_policy_identifier))
        return false
      end
      return (@policy_qualifiers == pi_other.get_policy_qualifiers)
    end
    
    typesig { [] }
    # Returns the hash code for this PolicyInformation.
    # 
    # @return a hash code value.
    def hash_code
      myhash = 37 + @policy_identifier.hash_code
      myhash = 37 * myhash + @policy_qualifiers.hash_code
      return myhash
    end
    
    typesig { [] }
    # Return the policyIdentifier value
    # 
    # @return The CertificatePolicyId object containing
    # the policyIdentifier (not a copy).
    def get_policy_identifier
      return @policy_identifier
    end
    
    typesig { [] }
    # Return the policyQualifiers value
    # 
    # @return a Set of PolicyQualifierInfo objects associated
    # with this certificate policy (not a copy).
    # Returns an empty Set if there are no qualifiers.
    # Never returns null.
    def get_policy_qualifiers
      return @policy_qualifiers
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(ID))
        return @policy_identifier
      else
        if (name.equals_ignore_case(QUALIFIERS))
          return @policy_qualifiers
        else
          raise IOException.new("Attribute name [" + name + "] not recognized by PolicyInformation.")
        end
      end
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(ID))
        if (obj.is_a?(CertificatePolicyId))
          @policy_identifier = obj
        else
          raise IOException.new("Attribute value must be instance " + "of CertificatePolicyId.")
        end
      else
        if (name.equals_ignore_case(QUALIFIERS))
          if ((@policy_identifier).nil?)
            raise IOException.new("Attribute must have a " + "CertificatePolicyIdentifier value before " + "PolicyQualifierInfo can be set.")
          end
          if (obj.is_a?(JavaSet))
            i = (obj).iterator
            while (i.has_next)
              obj1 = i.next_
              if (!(obj1.is_a?(PolicyQualifierInfo)))
                raise IOException.new("Attribute value must be a" + "Set of PolicyQualifierInfo objects.")
              end
            end
            @policy_qualifiers = obj
          else
            raise IOException.new("Attribute value must be of type Set.")
          end
        else
          raise IOException.new("Attribute name [" + name + "] not recognized by PolicyInformation")
        end
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(QUALIFIERS))
        @policy_qualifiers = Collections.empty_set
      else
        if (name.equals_ignore_case(ID))
          raise IOException.new("Attribute ID may not be deleted from " + "PolicyInformation.")
        else
          # ID may not be deleted
          raise IOException.new("Attribute name [" + name + "] not recognized by PolicyInformation.")
        end
      end
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(ID)
      elements.add_element(QUALIFIERS)
      return elements.elements
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return NAME
    end
    
    typesig { [] }
    # Return a printable representation of the PolicyInformation.
    def to_s
      s = StringBuilder.new("  [" + RJava.cast_to_string(@policy_identifier.to_s))
      s.append(RJava.cast_to_string(@policy_qualifiers) + "  ]\n")
      return s.to_s
    end
    
    typesig { [DerOutputStream] }
    # Write the PolicyInformation to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      @policy_identifier.encode(tmp)
      if (!@policy_qualifiers.is_empty)
        tmp2 = DerOutputStream.new
        @policy_qualifiers.each do |pq|
          tmp2.write(pq.get_encoded)
        end
        tmp.write(DerValue.attr_tag_sequence, tmp2)
      end
      out.write(DerValue.attr_tag_sequence, tmp)
    end
    
    private
    alias_method :initialize__policy_information, :initialize
  end
  
end
