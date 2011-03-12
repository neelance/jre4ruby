require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DistributionPointNameImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Java::Util
      include_const ::Sun::Security::Util, :BitArray
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
    }
  end
  
  # Represents the DistributionPointName ASN.1 type.
  # 
  # It is used in the CRL Distribution Points Extension (OID = 2.5.29.31)
  # and the Issuing Distribution Point Extension (OID = 2.5.29.28).
  # <p>
  # Its ASN.1 definition is:
  # <pre>
  # 
  #     DistributionPointName ::= CHOICE {
  #         fullName                  [0] GeneralNames,
  #         nameRelativeToCRLIssuer   [1] RelativeDistinguishedName }
  # 
  #     GeneralNames ::= SEQUENCE SIZE (1..MAX) OF GeneralName
  # 
  #     GeneralName ::= CHOICE {
  #         otherName                 [0] INSTANCE OF OTHER-NAME,
  #         rfc822Name                [1] IA5String,
  #         dNSName                   [2] IA5String,
  #         x400Address               [3] ORAddress,
  #         directoryName             [4] Name,
  #         ediPartyName              [5] EDIPartyName,
  #         uniformResourceIdentifier [6] IA5String,
  #         iPAddress                 [7] OCTET STRING,
  #         registeredID              [8] OBJECT IDENTIFIER }
  # 
  #     RelativeDistinguishedName ::= SET OF AttributeTypeAndValue
  # 
  #     AttributeTypeAndValue ::= SEQUENCE {
  #         type    AttributeType,
  #         value   AttributeValue }
  # 
  #     AttributeType ::= OBJECT IDENTIFIER
  # 
  #     AttributeValue ::= ANY DEFINED BY AttributeType
  # 
  # </pre>
  # <p>
  # Instances of this class are designed to be immutable. However, since this
  # is an internal API we do not use defensive cloning for values for
  # performance reasons. It is the responsibility of the consumer to ensure
  # that no mutable elements are modified.
  # 
  # @see CRLDistributionPointsExtension
  # @see IssuingDistributionPointExtension
  # @since 1.6
  class DistributionPointName 
    include_class_members DistributionPointNameImports
    
    class_module.module_eval {
      # ASN.1 context specific tag values
      const_set_lazy(:TAG_FULL_NAME) { 0 }
      const_attr_reader  :TAG_FULL_NAME
      
      const_set_lazy(:TAG_RELATIVE_NAME) { 1 }
      const_attr_reader  :TAG_RELATIVE_NAME
    }
    
    # Only one of fullName and relativeName can be set
    attr_accessor :full_name
    alias_method :attr_full_name, :full_name
    undef_method :full_name
    alias_method :attr_full_name=, :full_name=
    undef_method :full_name=
    
    attr_accessor :relative_name
    alias_method :attr_relative_name, :relative_name
    undef_method :relative_name
    alias_method :attr_relative_name=, :relative_name=
    undef_method :relative_name=
    
    # Cached hashCode value
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    typesig { [GeneralNames] }
    # Creates a distribution point name using a full name.
    # 
    # @param fullName the name for the distribution point.
    # @exception IllegalArgumentException if <code>fullName</code> is null.
    def initialize(full_name)
      @full_name = nil
      @relative_name = nil
      @hash_code = 0
      if ((full_name).nil?)
        raise IllegalArgumentException.new("fullName must not be null")
      end
      @full_name = full_name
    end
    
    typesig { [RDN] }
    # Creates a distribution point name using a relative name.
    # 
    # @param relativeName the name of the distribution point relative to
    #        the name of the issuer of the CRL.
    # @exception IllegalArgumentException if <code>relativeName</code> is null.
    def initialize(relative_name)
      @full_name = nil
      @relative_name = nil
      @hash_code = 0
      if ((relative_name).nil?)
        raise IllegalArgumentException.new("relativeName must not be null")
      end
      @relative_name = relative_name
    end
    
    typesig { [DerValue] }
    # Creates a distribution point name from its DER-encoded form.
    # 
    # @param encoding the DER-encoded value.
    # @throws IOException on decoding error.
    def initialize(encoding)
      @full_name = nil
      @relative_name = nil
      @hash_code = 0
      if (encoding.is_context_specific(TAG_FULL_NAME) && encoding.is_constructed)
        encoding.reset_tag(DerValue.attr_tag_sequence)
        @full_name = GeneralNames.new(encoding)
      else
        if (encoding.is_context_specific(TAG_RELATIVE_NAME) && encoding.is_constructed)
          encoding.reset_tag(DerValue.attr_tag_set)
          @relative_name = RDN.new(encoding)
        else
          raise IOException.new("Invalid encoding for DistributionPointName")
        end
      end
    end
    
    typesig { [] }
    # Returns the full name for the distribution point or null if not set.
    def get_full_name
      return @full_name
    end
    
    typesig { [] }
    # Returns the relative name for the distribution point or null if not set.
    def get_relative_name
      return @relative_name
    end
    
    typesig { [DerOutputStream] }
    # Encodes the distribution point name and writes it to the DerOutputStream.
    # 
    # @param out the output stream.
    # @exception IOException on encoding error.
    def encode(out)
      the_choice = DerOutputStream.new
      if (!(@full_name).nil?)
        @full_name.encode(the_choice)
        out.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_FULL_NAME), the_choice)
      else
        @relative_name.encode(the_choice)
        out.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_RELATIVE_NAME), the_choice)
      end
    end
    
    typesig { [Object] }
    # Compare an object to this distribution point name for equality.
    # 
    # @param obj Object to be compared to this
    # @return true if objects match; false otherwise
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(DistributionPointName)).equal?(false))
        return false
      end
      other = obj
      return self.==(@full_name, other.attr_full_name) && self.==(@relative_name, other.attr_relative_name)
    end
    
    typesig { [] }
    # Returns the hash code for this distribution point name.
    # 
    # @return the hash code.
    def hash_code
      hash = @hash_code
      if ((hash).equal?(0))
        hash = 1
        if (!(@full_name).nil?)
          hash += @full_name.hash_code
        else
          hash += @relative_name.hash_code
        end
        @hash_code = hash
      end
      return hash
    end
    
    typesig { [] }
    # Returns a printable string of the distribution point name.
    def to_s
      sb = StringBuilder.new
      if (!(@full_name).nil?)
        sb.append("DistributionPointName:\n     " + RJava.cast_to_string(@full_name) + "\n")
      else
        sb.append("DistributionPointName:\n     " + RJava.cast_to_string(@relative_name) + "\n")
      end
      return sb.to_s
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # Utility function for a.equals(b) where both a and b may be null.
      def ==(a, b)
        return ((a).nil?) ? ((b).nil?) : (a == b)
      end
    }
    
    private
    alias_method :initialize__distribution_point_name, :initialize
  end
  
end
