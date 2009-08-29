require "rjava"

# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Cert
  module PolicyQualifierInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Io, :IOException
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Security::Util, :DerValue
    }
  end
  
  # An immutable policy qualifier represented by the ASN.1 PolicyQualifierInfo
  # structure.
  # 
  # <p>The ASN.1 definition is as follows:
  # <p><pre>
  # PolicyQualifierInfo ::= SEQUENCE {
  # policyQualifierId       PolicyQualifierId,
  # qualifier               ANY DEFINED BY policyQualifierId }
  # </pre>
  # <p>
  # A certificate policies extension, if present in an X.509 version 3
  # certificate, contains a sequence of one or more policy information terms,
  # each of which consists of an object identifier (OID) and optional
  # qualifiers. In an end-entity certificate, these policy information terms
  # indicate the policy under which the certificate has been issued and the
  # purposes for which the certificate may be used. In a CA certificate, these
  # policy information terms limit the set of policies for certification paths
  # which include this certificate.
  # <p>
  # A <code>Set</code> of <code>PolicyQualifierInfo</code> objects are returned
  # by the {@link PolicyNode#getPolicyQualifiers PolicyNode.getPolicyQualifiers}
  # method. This allows applications with specific policy requirements to
  # process and validate each policy qualifier. Applications that need to
  # process policy qualifiers should explicitly set the
  # <code>policyQualifiersRejected</code> flag to false (by calling the
  # {@link PKIXParameters#setPolicyQualifiersRejected
  # PKIXParameters.setPolicyQualifiersRejected} method) before validating
  # a certification path.
  # 
  # <p>Note that the PKIX certification path validation algorithm specifies
  # that any policy qualifier in a certificate policies extension that is
  # marked critical must be processed and validated. Otherwise the
  # certification path must be rejected. If the
  # <code>policyQualifiersRejected</code> flag is set to false, it is up to
  # the application to validate all policy qualifiers in this manner in order
  # to be PKIX compliant.
  # 
  # <p><b>Concurrent Access</b>
  # 
  # <p>All <code>PolicyQualifierInfo</code> objects must be immutable and
  # thread-safe. That is, multiple threads may concurrently invoke the
  # methods defined in this class on a single <code>PolicyQualifierInfo</code>
  # object (or more than one) with no ill effects. Requiring
  # <code>PolicyQualifierInfo</code> objects to be immutable and thread-safe
  # allows them to be passed around to various pieces of code without
  # worrying about coordinating access.
  # 
  # @author      seth proctor
  # @author      Sean Mullan
  # @since       1.4
  class PolicyQualifierInfo 
    include_class_members PolicyQualifierInfoImports
    
    attr_accessor :m_encoded
    alias_method :attr_m_encoded, :m_encoded
    undef_method :m_encoded
    alias_method :attr_m_encoded=, :m_encoded=
    undef_method :m_encoded=
    
    attr_accessor :m_id
    alias_method :attr_m_id, :m_id
    undef_method :m_id
    alias_method :attr_m_id=, :m_id=
    undef_method :m_id=
    
    attr_accessor :m_data
    alias_method :attr_m_data, :m_data
    undef_method :m_data
    alias_method :attr_m_data=, :m_data=
    undef_method :m_data=
    
    attr_accessor :pqi_string
    alias_method :attr_pqi_string, :pqi_string
    undef_method :pqi_string
    alias_method :attr_pqi_string=, :pqi_string=
    undef_method :pqi_string=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Creates an instance of <code>PolicyQualifierInfo</code> from the
    # encoded bytes. The encoded byte array is copied on construction.
    # 
    # @param encoded a byte array containing the qualifier in DER encoding
    # @exception IOException thrown if the byte array does not represent a
    # valid and parsable policy qualifier
    def initialize(encoded)
      @m_encoded = nil
      @m_id = nil
      @m_data = nil
      @pqi_string = nil
      @m_encoded = encoded.clone
      val = DerValue.new(@m_encoded)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for PolicyQualifierInfo")
      end
      @m_id = RJava.cast_to_string((val.attr_data.get_der_value).get_oid.to_s)
      tmp = val.attr_data.to_byte_array
      if ((tmp).nil?)
        @m_data = nil
      else
        @m_data = Array.typed(::Java::Byte).new(tmp.attr_length) { 0 }
        System.arraycopy(tmp, 0, @m_data, 0, tmp.attr_length)
      end
    end
    
    typesig { [] }
    # Returns the <code>policyQualifierId</code> field of this
    # <code>PolicyQualifierInfo</code>. The <code>policyQualifierId</code>
    # is an Object Identifier (OID) represented by a set of nonnegative
    # integers separated by periods.
    # 
    # @return the OID (never <code>null</code>)
    def get_policy_qualifier_id
      return @m_id
    end
    
    typesig { [] }
    # Returns the ASN.1 DER encoded form of this
    # <code>PolicyQualifierInfo</code>.
    # 
    # @return the ASN.1 DER encoded bytes (never <code>null</code>).
    # Note that a copy is returned, so the data is cloned each time
    # this method is called.
    def get_encoded
      return @m_encoded.clone
    end
    
    typesig { [] }
    # Returns the ASN.1 DER encoded form of the <code>qualifier</code>
    # field of this <code>PolicyQualifierInfo</code>.
    # 
    # @return the ASN.1 DER encoded bytes of the <code>qualifier</code>
    # field. Note that a copy is returned, so the data is cloned each
    # time this method is called.
    def get_policy_qualifier
      return ((@m_data).nil? ? nil : @m_data.clone)
    end
    
    typesig { [] }
    # Return a printable representation of this
    # <code>PolicyQualifierInfo</code>.
    # 
    # @return a <code>String</code> describing the contents of this
    # <code>PolicyQualifierInfo</code>
    def to_s
      if (!(@pqi_string).nil?)
        return @pqi_string
      end
      enc = HexDumpEncoder.new
      sb = StringBuffer.new
      sb.append("PolicyQualifierInfo: [\n")
      sb.append("  qualifierID: " + @m_id + "\n")
      sb.append("  qualifier: " + RJava.cast_to_string(((@m_data).nil? ? "null" : enc.encode_buffer(@m_data))) + "\n")
      sb.append("]")
      @pqi_string = RJava.cast_to_string(sb.to_s)
      return @pqi_string
    end
    
    private
    alias_method :initialize__policy_qualifier_info, :initialize
  end
  
end
