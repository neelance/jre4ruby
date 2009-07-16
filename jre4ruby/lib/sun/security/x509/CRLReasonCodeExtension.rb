require "rjava"

# 
# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CRLReasonCodeExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # 
  # The reasonCode is a non-critical CRL entry extension that identifies
  # the reason for the certificate revocation. CAs are strongly
  # encouraged to include reason codes in CRL entries; however, the
  # reason code CRL entry extension should be absent instead of using the
  # unspecified (0) reasonCode value.
  # <p>The ASN.1 syntax for this is:
  # <pre>
  # id-ce-cRLReason OBJECT IDENTIFIER ::= { id-ce 21 }
  # 
  # -- reasonCode ::= { CRLReason }
  # 
  # CRLReason ::= ENUMERATED {
  # unspecified             (0),
  # keyCompromise           (1),
  # cACompromise            (2),
  # affiliationChanged      (3),
  # superseded              (4),
  # cessationOfOperation    (5),
  # certificateHold         (6),
  # removeFromCRL           (8),
  # privilegeWithdrawn      (9),
  # aACompromise           (10) }
  # </pre>
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class CRLReasonCodeExtension < CRLReasonCodeExtensionImports.const_get :Extension
    include_class_members CRLReasonCodeExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # 
      # Attribute name and Reason codes
      const_set_lazy(:NAME) { "CRLReasonCode" }
      const_attr_reader  :NAME
      
      const_set_lazy(:REASON) { "reason" }
      const_attr_reader  :REASON
      
      const_set_lazy(:UNSPECIFIED) { 0 }
      const_attr_reader  :UNSPECIFIED
      
      const_set_lazy(:KEY_COMPROMISE) { 1 }
      const_attr_reader  :KEY_COMPROMISE
      
      const_set_lazy(:CA_COMPROMISE) { 2 }
      const_attr_reader  :CA_COMPROMISE
      
      const_set_lazy(:AFFLIATION_CHANGED) { 3 }
      const_attr_reader  :AFFLIATION_CHANGED
      
      const_set_lazy(:SUPERSEDED) { 4 }
      const_attr_reader  :SUPERSEDED
      
      const_set_lazy(:CESSATION_OF_OPERATION) { 5 }
      const_attr_reader  :CESSATION_OF_OPERATION
      
      const_set_lazy(:CERTIFICATE_HOLD) { 6 }
      const_attr_reader  :CERTIFICATE_HOLD
      
      # note 7 missing in syntax
      const_set_lazy(:REMOVE_FROM_CRL) { 8 }
      const_attr_reader  :REMOVE_FROM_CRL
      
      const_set_lazy(:PRIVILEGE_WITHDRAWN) { 9 }
      const_attr_reader  :PRIVILEGE_WITHDRAWN
      
      const_set_lazy(:AA_COMPROMISE) { 10 }
      const_attr_reader  :AA_COMPROMISE
    }
    
    attr_accessor :reason_code
    alias_method :attr_reason_code, :reason_code
    undef_method :reason_code
    alias_method :attr_reason_code=, :reason_code=
    undef_method :reason_code=
    
    typesig { [] }
    def encode_this
      if ((@reason_code).equal?(0))
        self.attr_extension_value = nil
        return
      end
      dos = DerOutputStream.new
      dos.put_enumerated(@reason_code)
      self.attr_extension_value = dos.to_byte_array
    end
    
    typesig { [::Java::Int] }
    # 
    # Create a CRLReasonCodeExtension with the passed in reason.
    # Criticality automatically set to false.
    # 
    # @param reason the enumerated value for the reason code.
    def initialize(reason)
      initialize__crlreason_code_extension(false, reason)
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    # 
    # Create a CRLReasonCodeExtension with the passed in reason.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param reason the enumerated value for the reason code.
    def initialize(critical, reason)
      @reason_code = 0
      super()
      @reason_code = 0
      self.attr_extension_id = PKIXExtensions::ReasonCode_Id
      self.attr_critical = critical
      @reason_code = reason
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # 
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @reason_code = 0
      super()
      @reason_code = 0
      self.attr_extension_id = PKIXExtensions::ReasonCode_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      @reason_code = val.get_enumerated
    end
    
    typesig { [String, Object] }
    # 
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(JavaInteger)))
        raise IOException.new("Attribute must be of type Integer.")
      end
      if (name.equals_ignore_case(REASON))
        @reason_code = (obj).int_value
      else
        raise IOException.new("Name not supported by CRLReasonCodeExtension")
      end
      encode_this
    end
    
    typesig { [String] }
    # 
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(REASON))
        return @reason_code
      else
        raise IOException.new("Name not supported by CRLReasonCodeExtension")
      end
    end
    
    typesig { [String] }
    # 
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(REASON))
        @reason_code = 0
      else
        raise IOException.new("Name not supported by CRLReasonCodeExtension")
      end
      encode_this
    end
    
    typesig { [] }
    # 
    # Returns a printable representation of the Reason code.
    def to_s
      s = (super).to_s + "    Reason Code: "
      case (@reason_code)
      when UNSPECIFIED
        s += "Unspecified"
      when KEY_COMPROMISE
        s += "Key Compromise"
      when CA_COMPROMISE
        s += "CA Compromise"
      when AFFLIATION_CHANGED
        s += "Affiliation Changed"
      when SUPERSEDED
        s += "Superseded"
      when CESSATION_OF_OPERATION
        s += "Cessation Of Operation"
      when CERTIFICATE_HOLD
        s += "Certificate Hold"
      when REMOVE_FROM_CRL
        s += "Remove from CRL"
      when PRIVILEGE_WITHDRAWN
        s += "Privilege Withdrawn"
      when AA_COMPROMISE
        s += "AA Compromise"
      else
        s += "Unrecognized reason code (" + (@reason_code).to_s + ")"
      end
      return (s)
    end
    
    typesig { [OutputStream] }
    # 
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::ReasonCode_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [] }
    # 
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(REASON)
      return elements.elements
    end
    
    typesig { [] }
    # 
    # Return the name of this attribute.
    def get_name
      return NAME
    end
    
    private
    alias_method :initialize__crlreason_code_extension, :initialize
  end
  
end
