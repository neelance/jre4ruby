require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DistributionPointImports
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
  
  # Represent the DistributionPoint sequence used in the CRL
  # Distribution Points Extension (OID = 2.5.29.31).
  # <p>
  # The ASN.1 definition for this is:
  # <pre>
  # DistributionPoint ::= SEQUENCE {
  # distributionPoint       [0]     DistributionPointName OPTIONAL,
  # reasons                 [1]     ReasonFlags OPTIONAL,
  # cRLIssuer               [2]     GeneralNames OPTIONAL }
  # 
  # DistributionPointName ::= CHOICE {
  # fullName                [0]     GeneralNames,
  # nameRelativeToCRLIssuer [1]     RelativeDistinguishedName }
  # 
  # ReasonFlags ::= BIT STRING {
  # unused                  (0),
  # keyCompromise           (1),
  # cACompromise            (2),
  # affiliationChanged      (3),
  # superseded              (4),
  # cessationOfOperation    (5),
  # certificateHold         (6),
  # privilegeWithdrawn      (7),
  # aACompromise            (8) }
  # 
  # GeneralNames ::= SEQUENCE SIZE (1..MAX) OF GeneralName
  # 
  # GeneralName ::= CHOICE {
  # otherName                   [0] INSTANCE OF OTHER-NAME,
  # rfc822Name                  [1] IA5String,
  # dNSName                     [2] IA5String,
  # x400Address                 [3] ORAddress,
  # directoryName               [4] Name,
  # ediPartyName                [5] EDIPartyName,
  # uniformResourceIdentifier   [6] IA5String,
  # iPAddress                   [7] OCTET STRING,
  # registeredID                [8] OBJECT IDENTIFIER }
  # 
  # RelativeDistinguishedName ::=
  # SET OF AttributeTypeAndValue
  # 
  # AttributeTypeAndValue ::= SEQUENCE {
  # type     AttributeType,
  # value    AttributeValue }
  # 
  # AttributeType ::= OBJECT IDENTIFIER
  # 
  # AttributeValue ::= ANY DEFINED BY AttributeType
  # </pre>
  # <p>
  # Instances of this class are designed to be immutable. However, since this
  # is an internal API we do not use defensive cloning for values for
  # performance reasons. It is the responsibility of the consumer to ensure
  # that no mutable elements are modified.
  # 
  # @author Anne Anderson
  # @author Andreas Sterbenz
  # @since 1.4.2
  # @see CRLDistributionPointsExtension
  class DistributionPoint 
    include_class_members DistributionPointImports
    
    class_module.module_eval {
      # reason flag bits
      # NOTE that these are NOT quite the same as the CRL reason code extension
      const_set_lazy(:KEY_COMPROMISE) { 1 }
      const_attr_reader  :KEY_COMPROMISE
      
      const_set_lazy(:CA_COMPROMISE) { 2 }
      const_attr_reader  :CA_COMPROMISE
      
      const_set_lazy(:AFFILIATION_CHANGED) { 3 }
      const_attr_reader  :AFFILIATION_CHANGED
      
      const_set_lazy(:SUPERSEDED) { 4 }
      const_attr_reader  :SUPERSEDED
      
      const_set_lazy(:CESSATION_OF_OPERATION) { 5 }
      const_attr_reader  :CESSATION_OF_OPERATION
      
      const_set_lazy(:CERTIFICATE_HOLD) { 6 }
      const_attr_reader  :CERTIFICATE_HOLD
      
      const_set_lazy(:PRIVILEGE_WITHDRAWN) { 7 }
      const_attr_reader  :PRIVILEGE_WITHDRAWN
      
      const_set_lazy(:AA_COMPROMISE) { 8 }
      const_attr_reader  :AA_COMPROMISE
      
      const_set_lazy(:REASON_STRINGS) { Array.typed(String).new([nil, "key compromise", "CA compromise", "affiliation changed", "superseded", "cessation of operation", "certificate hold", "privilege withdrawn", "AA compromise", ]) }
      const_attr_reader  :REASON_STRINGS
      
      # context specific tag values
      const_set_lazy(:TAG_DIST_PT) { 0 }
      const_attr_reader  :TAG_DIST_PT
      
      const_set_lazy(:TAG_REASONS) { 1 }
      const_attr_reader  :TAG_REASONS
      
      const_set_lazy(:TAG_ISSUER) { 2 }
      const_attr_reader  :TAG_ISSUER
      
      const_set_lazy(:TAG_FULL_NAME) { 0 }
      const_attr_reader  :TAG_FULL_NAME
      
      const_set_lazy(:TAG_REL_NAME) { 1 }
      const_attr_reader  :TAG_REL_NAME
    }
    
    # only one of fullName and relativeName can be set
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
    
    # reasonFlags or null
    attr_accessor :reason_flags
    alias_method :attr_reason_flags, :reason_flags
    undef_method :reason_flags
    alias_method :attr_reason_flags=, :reason_flags=
    undef_method :reason_flags=
    
    # crlIssuer or null
    attr_accessor :crl_issuer
    alias_method :attr_crl_issuer, :crl_issuer
    undef_method :crl_issuer
    alias_method :attr_crl_issuer=, :crl_issuer=
    undef_method :crl_issuer=
    
    # cached hashCode value
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    typesig { [GeneralNames, Array.typed(::Java::Boolean), GeneralNames] }
    # Constructor for the class using GeneralNames for DistributionPointName
    # 
    # @param fullName the GeneralNames of the distribution point; may be null
    # @param reasons the CRL reasons included in the CRL at this distribution
    # point; may be null
    # @param issuer the name(s) of the CRL issuer for the CRL at this
    # distribution point; may be null
    def initialize(full_name, reason_flags, crl_issuer)
      @full_name = nil
      @relative_name = nil
      @reason_flags = nil
      @crl_issuer = nil
      @hash_code = 0
      if (((full_name).nil?) && ((crl_issuer).nil?))
        raise IllegalArgumentException.new("fullName and crlIssuer may not both be null")
      end
      @full_name = full_name
      @reason_flags = reason_flags
      @crl_issuer = crl_issuer
    end
    
    typesig { [RDN, Array.typed(::Java::Boolean), GeneralNames] }
    # Constructor for the class using RelativeDistinguishedName for
    # DistributionPointName
    # 
    # @param relativeName the RelativeDistinguishedName of the distribution
    # point; may not be null
    # @param reasons the CRL reasons included in the CRL at this distribution
    # point; may be null
    # @param issuer the name(s) of the CRL issuer for the CRL at this
    # distribution point; may not be null or empty.
    def initialize(relative_name, reason_flags, crl_issuer)
      @full_name = nil
      @relative_name = nil
      @reason_flags = nil
      @crl_issuer = nil
      @hash_code = 0
      if (((relative_name).nil?) && ((crl_issuer).nil?))
        raise IllegalArgumentException.new("relativeName and crlIssuer may not both be null")
      end
      @relative_name = relative_name
      @reason_flags = reason_flags
      @crl_issuer = crl_issuer
    end
    
    typesig { [DerValue] }
    # Create the object from the passed DER encoded form.
    # 
    # @param val the DER encoded form of the DistributionPoint
    # @throws IOException on error
    def initialize(val)
      @full_name = nil
      @relative_name = nil
      @reason_flags = nil
      @crl_issuer = nil
      @hash_code = 0
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding of DistributionPoint.")
      end
      # Note that all the fields in DistributionPoint are defined as
      # being OPTIONAL, i.e., there could be an empty SEQUENCE, resulting
      # in val.data being null.
      while ((!(val.attr_data).nil?) && (!(val.attr_data.available).equal?(0)))
        opt = val.attr_data.get_der_value
        if (opt.is_context_specific(TAG_DIST_PT) && opt.is_constructed)
          if ((!(@full_name).nil?) || (!(@relative_name).nil?))
            raise IOException.new("Duplicate DistributionPointName in " + "DistributionPoint.")
          end
          dist_pnt = opt.attr_data.get_der_value
          if (dist_pnt.is_context_specific(TAG_FULL_NAME) && dist_pnt.is_constructed)
            dist_pnt.reset_tag(DerValue.attr_tag_sequence)
            @full_name = GeneralNames.new(dist_pnt)
          else
            if (dist_pnt.is_context_specific(TAG_REL_NAME) && dist_pnt.is_constructed)
              dist_pnt.reset_tag(DerValue.attr_tag_set)
              @relative_name = RDN.new(dist_pnt)
            else
              raise IOException.new("Invalid DistributionPointName in " + "DistributionPoint")
            end
          end
        else
          if (opt.is_context_specific(TAG_REASONS) && !opt.is_constructed)
            if (!(@reason_flags).nil?)
              raise IOException.new("Duplicate Reasons in " + "DistributionPoint.")
            end
            opt.reset_tag(DerValue.attr_tag_bit_string)
            @reason_flags = (opt.get_unaligned_bit_string).to_boolean_array
          else
            if (opt.is_context_specific(TAG_ISSUER) && opt.is_constructed)
              if (!(@crl_issuer).nil?)
                raise IOException.new("Duplicate CRLIssuer in " + "DistributionPoint.")
              end
              opt.reset_tag(DerValue.attr_tag_sequence)
              @crl_issuer = GeneralNames.new(opt)
            else
              raise IOException.new("Invalid encoding of " + "DistributionPoint.")
            end
          end
        end
      end
      if (((@crl_issuer).nil?) && ((@full_name).nil?) && ((@relative_name).nil?))
        raise IOException.new("One of fullName, relativeName, " + " and crlIssuer has to be set")
      end
    end
    
    typesig { [] }
    # Return the full distribution point name or null if not set.
    def get_full_name
      return @full_name
    end
    
    typesig { [] }
    # Return the relative distribution point name or null if not set.
    def get_relative_name
      return @relative_name
    end
    
    typesig { [] }
    # Return the reason flags or null if not set.
    def get_reason_flags
      return @reason_flags
    end
    
    typesig { [] }
    # Return the CRL issuer name or null if not set.
    def get_crlissuer
      return @crl_issuer
    end
    
    typesig { [DerOutputStream] }
    # Write the DistributionPoint value to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on error.
    def encode(out)
      tagged = DerOutputStream.new
      # NOTE: only one of pointNames and pointRDN can be set
      if ((!(@full_name).nil?) || (!(@relative_name).nil?))
        distribution_point = DerOutputStream.new
        if (!(@full_name).nil?)
          der_out = DerOutputStream.new
          @full_name.encode(der_out)
          distribution_point.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_FULL_NAME), der_out)
        else
          if (!(@relative_name).nil?)
            der_out = DerOutputStream.new
            @relative_name.encode(der_out)
            distribution_point.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_REL_NAME), der_out)
          end
        end
        tagged.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_DIST_PT), distribution_point)
      end
      if (!(@reason_flags).nil?)
        reasons = DerOutputStream.new
        rf = BitArray.new(@reason_flags)
        reasons.put_truncated_unaligned_bit_string(rf)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_REASONS), reasons)
      end
      if (!(@crl_issuer).nil?)
        issuer = DerOutputStream.new
        @crl_issuer.encode(issuer)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_ISSUER), issuer)
      end
      out.write(DerValue.attr_tag_sequence, tagged)
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # Utility function for a.equals(b) where both a and b may be null.
      def ==(a, b)
        return ((a).nil?) ? ((b).nil?) : (a == b)
      end
    }
    
    typesig { [Object] }
    # Compare an object to this DistributionPoint for equality.
    # 
    # @param obj Object to be compared to this
    # @return true if objects match; false otherwise
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(DistributionPoint)).equal?(false))
        return false
      end
      other = obj
      equal = self.==(@full_name, other.attr_full_name) && self.==(@relative_name, other.attr_relative_name) && self.==(@crl_issuer, other.attr_crl_issuer) && (Arrays == @reason_flags)
      return equal
    end
    
    typesig { [] }
    def hash_code
      hash = @hash_code
      if ((hash).equal?(0))
        hash = 1
        if (!(@full_name).nil?)
          hash += @full_name.hash_code
        end
        if (!(@relative_name).nil?)
          hash += @relative_name.hash_code
        end
        if (!(@crl_issuer).nil?)
          hash += @crl_issuer.hash_code
        end
        if (!(@reason_flags).nil?)
          i = 0
          while i < @reason_flags.attr_length
            if (@reason_flags[i])
              hash += i
            end
            i += 1
          end
        end
        @hash_code = hash
      end
      return hash
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Return a string representation for reasonFlag bit 'reason'.
      def reason_to_string(reason)
        if ((reason > 0) && (reason < REASON_STRINGS.attr_length))
          return REASON_STRINGS[reason]
        end
        return "Unknown reason " + RJava.cast_to_string(reason)
      end
    }
    
    typesig { [] }
    # Return a printable string of the Distribution Point.
    def to_s
      sb = StringBuilder.new
      if (!(@full_name).nil?)
        sb.append("DistributionPoint:\n     " + RJava.cast_to_string(@full_name) + "\n")
      end
      if (!(@relative_name).nil?)
        sb.append("DistributionPoint:\n     " + RJava.cast_to_string(@relative_name) + "\n")
      end
      if (!(@reason_flags).nil?)
        sb.append("   ReasonFlags:\n")
        i = 0
        while i < @reason_flags.attr_length
          if (@reason_flags[i])
            sb.append("    " + RJava.cast_to_string(reason_to_string(i)) + "\n")
          end
          i += 1
        end
      end
      if (!(@crl_issuer).nil?)
        sb.append("   CRLIssuer:" + RJava.cast_to_string(@crl_issuer) + "\n")
      end
      return sb.to_s
    end
    
    private
    alias_method :initialize__distribution_point, :initialize
  end
  
end
