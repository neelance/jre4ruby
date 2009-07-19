require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IssuingDistributionPointExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Util
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
    }
  end
  
  # Represents the CRL Issuing Distribution Point Extension (OID = 2.5.29.28).
  # 
  # <p>
  # The issuing distribution point is a critical CRL extension that
  # identifies the CRL distribution point and scope for a particular CRL,
  # and it indicates whether the CRL covers revocation for end entity
  # certificates only, CA certificates only, attribute certificates only,
  # or a limited set of reason codes.
  # 
  # <p>
  # The extension is defined in Section 5.2.5 of
  # <a href="http://www.ietf.org/rfc/rfc3280.txt">Internet X.509 PKI Certific
  # ate and Certificate Revocation List (CRL) Profile</a>.
  # 
  # <p>
  # Its ASN.1 definition is as follows:
  # <pre>
  # id-ce-issuingDistributionPoint OBJECT IDENTIFIER ::= { id-ce 28 }
  # 
  # issuingDistributionPoint ::= SEQUENCE {
  # distributionPoint          [0] DistributionPointName OPTIONAL,
  # onlyContainsUserCerts      [1] BOOLEAN DEFAULT FALSE,
  # onlyContainsCACerts        [2] BOOLEAN DEFAULT FALSE,
  # onlySomeReasons            [3] ReasonFlags OPTIONAL,
  # indirectCRL                [4] BOOLEAN DEFAULT FALSE,
  # onlyContainsAttributeCerts [5] BOOLEAN DEFAULT FALSE }
  # </pre>
  # 
  # @see DistributionPoint
  # @since 1.6
  class IssuingDistributionPointExtension < IssuingDistributionPointExtensionImports.const_get :Extension
    include_class_members IssuingDistributionPointExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.IssuingDistributionPoint" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "IssuingDistributionPoint" }
      const_attr_reader  :NAME
      
      const_set_lazy(:POINT) { "point" }
      const_attr_reader  :POINT
      
      const_set_lazy(:REASONS) { "reasons" }
      const_attr_reader  :REASONS
      
      const_set_lazy(:ONLY_USER_CERTS) { "only_user_certs" }
      const_attr_reader  :ONLY_USER_CERTS
      
      const_set_lazy(:ONLY_CA_CERTS) { "only_ca_certs" }
      const_attr_reader  :ONLY_CA_CERTS
      
      const_set_lazy(:ONLY_ATTRIBUTE_CERTS) { "only_attribute_certs" }
      const_attr_reader  :ONLY_ATTRIBUTE_CERTS
      
      const_set_lazy(:INDIRECT_CRL) { "indirect_crl" }
      const_attr_reader  :INDIRECT_CRL
    }
    
    # The distribution point name for the CRL.
    attr_accessor :distribution_point
    alias_method :attr_distribution_point, :distribution_point
    undef_method :distribution_point
    alias_method :attr_distribution_point=, :distribution_point=
    undef_method :distribution_point=
    
    # The scope settings for the CRL.
    attr_accessor :revocation_reasons
    alias_method :attr_revocation_reasons, :revocation_reasons
    undef_method :revocation_reasons
    alias_method :attr_revocation_reasons=, :revocation_reasons=
    undef_method :revocation_reasons=
    
    attr_accessor :has_only_user_certs
    alias_method :attr_has_only_user_certs, :has_only_user_certs
    undef_method :has_only_user_certs
    alias_method :attr_has_only_user_certs=, :has_only_user_certs=
    undef_method :has_only_user_certs=
    
    attr_accessor :has_only_cacerts
    alias_method :attr_has_only_cacerts, :has_only_cacerts
    undef_method :has_only_cacerts
    alias_method :attr_has_only_cacerts=, :has_only_cacerts=
    undef_method :has_only_cacerts=
    
    attr_accessor :has_only_attribute_certs
    alias_method :attr_has_only_attribute_certs, :has_only_attribute_certs
    undef_method :has_only_attribute_certs
    alias_method :attr_has_only_attribute_certs=, :has_only_attribute_certs=
    undef_method :has_only_attribute_certs=
    
    attr_accessor :is_indirect_crl
    alias_method :attr_is_indirect_crl, :is_indirect_crl
    undef_method :is_indirect_crl
    alias_method :attr_is_indirect_crl=, :is_indirect_crl=
    undef_method :is_indirect_crl=
    
    class_module.module_eval {
      # ASN.1 context specific tag values
      const_set_lazy(:TAG_DISTRIBUTION_POINT) { 0 }
      const_attr_reader  :TAG_DISTRIBUTION_POINT
      
      const_set_lazy(:TAG_ONLY_USER_CERTS) { 1 }
      const_attr_reader  :TAG_ONLY_USER_CERTS
      
      const_set_lazy(:TAG_ONLY_CA_CERTS) { 2 }
      const_attr_reader  :TAG_ONLY_CA_CERTS
      
      const_set_lazy(:TAG_ONLY_SOME_REASONS) { 3 }
      const_attr_reader  :TAG_ONLY_SOME_REASONS
      
      const_set_lazy(:TAG_INDIRECT_CRL) { 4 }
      const_attr_reader  :TAG_INDIRECT_CRL
      
      const_set_lazy(:TAG_ONLY_ATTRIBUTE_CERTS) { 5 }
      const_attr_reader  :TAG_ONLY_ATTRIBUTE_CERTS
    }
    
    typesig { [DistributionPointName, ReasonFlags, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a critical IssuingDistributionPointExtension.
    # 
    # @param distributionPoint the name of the distribution point, or null for
    # none.
    # @param revocationReasons the revocation reasons associated with the
    # distribution point, or null for none.
    # @param hasOnlyUserCerts if <code>true</code> then scope of the CRL
    # includes only user certificates.
    # @param hasOnlyCACerts if <code>true</code> then scope of the CRL
    # includes only CA certificates.
    # @param hasOnlyAttributeCerts if <code>true</code> then scope of the CRL
    # includes only attribute certificates.
    # @param isIndirectCRL if <code>true</code> then the scope of the CRL
    # includes certificates issued by authorities other than the CRL
    # issuer. The responsible authority is indicated by a certificate
    # issuer CRL entry extension.
    # @throws IllegalArgumentException if more than one of
    # <code>hasOnlyUserCerts</code>, <code>hasOnlyCACerts</code>,
    # <code>hasOnlyAttributeCerts</code> is set to <code>true</code>.
    # @throws IOException on encoding error.
    def initialize(distribution_point, revocation_reasons, has_only_user_certs, has_only_cacerts, has_only_attribute_certs, is_indirect_crl)
      @distribution_point = nil
      @revocation_reasons = nil
      @has_only_user_certs = false
      @has_only_cacerts = false
      @has_only_attribute_certs = false
      @is_indirect_crl = false
      super()
      @distribution_point = nil
      @revocation_reasons = nil
      @has_only_user_certs = false
      @has_only_cacerts = false
      @has_only_attribute_certs = false
      @is_indirect_crl = false
      if ((has_only_user_certs && (has_only_cacerts || has_only_attribute_certs)) || (has_only_cacerts && (has_only_user_certs || has_only_attribute_certs)) || (has_only_attribute_certs && (has_only_user_certs || has_only_cacerts)))
        raise IllegalArgumentException.new("Only one of hasOnlyUserCerts, hasOnlyCACerts, " + "hasOnlyAttributeCerts may be set to true")
      end
      self.attr_extension_id = PKIXExtensions::IssuingDistributionPoint_Id
      self.attr_critical = true
      @distribution_point = distribution_point
      @revocation_reasons = revocation_reasons
      @has_only_user_certs = has_only_user_certs
      @has_only_cacerts = has_only_cacerts
      @has_only_attribute_certs = has_only_attribute_certs
      @is_indirect_crl = is_indirect_crl
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Creates a critical IssuingDistributionPointExtension from its
    # DER-encoding.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value the DER-encoded value. It must be a <code>byte[]</code>.
    # @exception IOException on decoding error.
    def initialize(critical, value)
      @distribution_point = nil
      @revocation_reasons = nil
      @has_only_user_certs = false
      @has_only_cacerts = false
      @has_only_attribute_certs = false
      @is_indirect_crl = false
      super()
      @distribution_point = nil
      @revocation_reasons = nil
      @has_only_user_certs = false
      @has_only_cacerts = false
      @has_only_attribute_certs = false
      @is_indirect_crl = false
      self.attr_extension_id = PKIXExtensions::IssuingDistributionPoint_Id
      self.attr_critical = critical.boolean_value
      if (!(value.is_a?(Array.typed(::Java::Byte))))
        raise IOException.new("Illegal argument type")
      end
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for " + "IssuingDistributionPointExtension.")
      end
      # All the elements in issuingDistributionPoint are optional
      if (((val.attr_data).nil?) || ((val.attr_data.available).equal?(0)))
        return
      end
      in_ = val.attr_data
      while (!(in_).nil? && !(in_.available).equal?(0))
        opt = in_.get_der_value
        if (opt.is_context_specific(TAG_DISTRIBUTION_POINT) && opt.is_constructed)
          @distribution_point = DistributionPointName.new(opt.attr_data.get_der_value)
        else
          if (opt.is_context_specific(TAG_ONLY_USER_CERTS) && !opt.is_constructed)
            opt.reset_tag(DerValue.attr_tag_boolean)
            @has_only_user_certs = opt.get_boolean
          else
            if (opt.is_context_specific(TAG_ONLY_CA_CERTS) && !opt.is_constructed)
              opt.reset_tag(DerValue.attr_tag_boolean)
              @has_only_cacerts = opt.get_boolean
            else
              if (opt.is_context_specific(TAG_ONLY_SOME_REASONS) && !opt.is_constructed)
                @revocation_reasons = ReasonFlags.new(opt) # expects tag implicit
              else
                if (opt.is_context_specific(TAG_INDIRECT_CRL) && !opt.is_constructed)
                  opt.reset_tag(DerValue.attr_tag_boolean)
                  @is_indirect_crl = opt.get_boolean
                else
                  if (opt.is_context_specific(TAG_ONLY_ATTRIBUTE_CERTS) && !opt.is_constructed)
                    opt.reset_tag(DerValue.attr_tag_boolean)
                    @has_only_attribute_certs = opt.get_boolean
                  else
                    raise IOException.new("Invalid encoding of IssuingDistributionPoint")
                  end
                end
              end
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Returns the name of this attribute.
    def get_name
      return NAME
    end
    
    typesig { [OutputStream] }
    # Encodes the issuing distribution point extension and writes it to the
    # DerOutputStream.
    # 
    # @param out the output stream.
    # @exception IOException on encoding error.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::IssuingDistributionPoint_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Sets the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(POINT))
        if (!(obj.is_a?(DistributionPointName)))
          raise IOException.new("Attribute value should be of type DistributionPointName.")
        end
        @distribution_point = obj
      else
        if (name.equals_ignore_case(REASONS))
          if (!(obj.is_a?(ReasonFlags)))
            raise IOException.new("Attribute value should be of type ReasonFlags.")
          end
        else
          if (name.equals_ignore_case(INDIRECT_CRL))
            if (!(obj.is_a?(Boolean)))
              raise IOException.new("Attribute value should be of type Boolean.")
            end
            @is_indirect_crl = (obj).boolean_value
          else
            if (name.equals_ignore_case(ONLY_USER_CERTS))
              if (!(obj.is_a?(Boolean)))
                raise IOException.new("Attribute value should be of type Boolean.")
              end
              @has_only_user_certs = (obj).boolean_value
            else
              if (name.equals_ignore_case(ONLY_CA_CERTS))
                if (!(obj.is_a?(Boolean)))
                  raise IOException.new("Attribute value should be of type Boolean.")
                end
                @has_only_cacerts = (obj).boolean_value
              else
                if (name.equals_ignore_case(ONLY_ATTRIBUTE_CERTS))
                  if (!(obj.is_a?(Boolean)))
                    raise IOException.new("Attribute value should be of type Boolean.")
                  end
                  @has_only_attribute_certs = (obj).boolean_value
                else
                  raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:IssuingDistributionPointExtension.")
                end
              end
            end
          end
        end
      end
      encode_this
    end
    
    typesig { [String] }
    # Gets the attribute value.
    def get(name)
      if (name.equals_ignore_case(POINT))
        return @distribution_point
      else
        if (name.equals_ignore_case(INDIRECT_CRL))
          return Boolean.value_of(@is_indirect_crl)
        else
          if (name.equals_ignore_case(REASONS))
            return @revocation_reasons
          else
            if (name.equals_ignore_case(ONLY_USER_CERTS))
              return Boolean.value_of(@has_only_user_certs)
            else
              if (name.equals_ignore_case(ONLY_CA_CERTS))
                return Boolean.value_of(@has_only_cacerts)
              else
                if (name.equals_ignore_case(ONLY_ATTRIBUTE_CERTS))
                  return Boolean.value_of(@has_only_attribute_certs)
                else
                  raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:IssuingDistributionPointExtension.")
                end
              end
            end
          end
        end
      end
    end
    
    typesig { [String] }
    # Deletes the attribute value.
    def delete(name)
      if (name.equals_ignore_case(POINT))
        @distribution_point = nil
      else
        if (name.equals_ignore_case(INDIRECT_CRL))
          @is_indirect_crl = false
        else
          if (name.equals_ignore_case(REASONS))
            @revocation_reasons = nil
          else
            if (name.equals_ignore_case(ONLY_USER_CERTS))
              @has_only_user_certs = false
            else
              if (name.equals_ignore_case(ONLY_CA_CERTS))
                @has_only_cacerts = false
              else
                if (name.equals_ignore_case(ONLY_ATTRIBUTE_CERTS))
                  @has_only_attribute_certs = false
                else
                  raise IOException.new("Attribute name [" + name + "] not recognized by " + "CertAttrSet:IssuingDistributionPointExtension.")
                end
              end
            end
          end
        end
      end
      encode_this
    end
    
    typesig { [] }
    # Returns an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(POINT)
      elements.add_element(REASONS)
      elements.add_element(ONLY_USER_CERTS)
      elements.add_element(ONLY_CA_CERTS)
      elements.add_element(ONLY_ATTRIBUTE_CERTS)
      elements.add_element(INDIRECT_CRL)
      return elements.elements
    end
    
    typesig { [] }
    # Encodes this extension value
    def encode_this
      if ((@distribution_point).nil? && (@revocation_reasons).nil? && !@has_only_user_certs && !@has_only_cacerts && !@has_only_attribute_certs && !@is_indirect_crl)
        self.attr_extension_value = nil
        return
      end
      tagged = DerOutputStream.new
      if (!(@distribution_point).nil?)
        tmp = DerOutputStream.new
        @distribution_point.encode(tmp)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_DISTRIBUTION_POINT), tmp)
      end
      if (@has_only_user_certs)
        tmp = DerOutputStream.new
        tmp.put_boolean(@has_only_user_certs)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_ONLY_USER_CERTS), tmp)
      end
      if (@has_only_cacerts)
        tmp = DerOutputStream.new
        tmp.put_boolean(@has_only_cacerts)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_ONLY_CA_CERTS), tmp)
      end
      if (!(@revocation_reasons).nil?)
        tmp = DerOutputStream.new
        @revocation_reasons.encode(tmp)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_ONLY_SOME_REASONS), tmp)
      end
      if (@is_indirect_crl)
        tmp = DerOutputStream.new
        tmp.put_boolean(@is_indirect_crl)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_INDIRECT_CRL), tmp)
      end
      if (@has_only_attribute_certs)
        tmp = DerOutputStream.new
        tmp.put_boolean(@has_only_attribute_certs)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_ONLY_ATTRIBUTE_CERTS), tmp)
      end
      seq = DerOutputStream.new
      seq.write(DerValue.attr_tag_sequence, tagged)
      self.attr_extension_value = seq.to_byte_array
    end
    
    typesig { [] }
    # Returns the extension as user readable string.
    def to_s
      sb = StringBuilder.new(super)
      sb.append("IssuingDistributionPoint [\n  ")
      if (!(@distribution_point).nil?)
        sb.append(@distribution_point)
      end
      if (!(@revocation_reasons).nil?)
        sb.append(@revocation_reasons)
      end
      sb.append((@has_only_user_certs) ? ("  Only contains user certs: true") : ("  Only contains user certs: false")).append("\n")
      sb.append((@has_only_cacerts) ? ("  Only contains CA certs: true") : ("  Only contains CA certs: false")).append("\n")
      sb.append((@has_only_attribute_certs) ? ("  Only contains attribute certs: true") : ("  Only contains attribute certs: false")).append("\n")
      sb.append((@is_indirect_crl) ? ("  Indirect CRL: true") : ("  Indirect CRL: false")).append("\n")
      sb.append("]\n")
      return sb.to_s
    end
    
    private
    alias_method :initialize__issuing_distribution_point_extension, :initialize
  end
  
end
