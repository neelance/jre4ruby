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
  module CertificateValidityImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Security::Cert
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # 
  # This class defines the interval for which the certificate is valid.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  class CertificateValidity 
    include_class_members CertificateValidityImports
    include CertAttrSet
    
    class_module.module_eval {
      # 
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.validity" }
      const_attr_reader  :IDENT
      
      # 
      # Sub attributes name for this CertAttrSet.
      const_set_lazy(:NAME) { "validity" }
      const_attr_reader  :NAME
      
      const_set_lazy(:NOT_BEFORE) { "notBefore" }
      const_attr_reader  :NOT_BEFORE
      
      const_set_lazy(:NOT_AFTER) { "notAfter" }
      const_attr_reader  :NOT_AFTER
      
      const_set_lazy(:YR_2050) { 2524636800000 }
      const_attr_reader  :YR_2050
    }
    
    # Private data members
    attr_accessor :not_before
    alias_method :attr_not_before, :not_before
    undef_method :not_before
    alias_method :attr_not_before=, :not_before=
    undef_method :not_before=
    
    attr_accessor :not_after
    alias_method :attr_not_after, :not_after
    undef_method :not_after
    alias_method :attr_not_after=, :not_after=
    undef_method :not_after=
    
    typesig { [] }
    # Returns the first time the certificate is valid.
    def get_not_before
      return (Date.new(@not_before.get_time))
    end
    
    typesig { [] }
    # Returns the last time the certificate is valid.
    def get_not_after
      return (Date.new(@not_after.get_time))
    end
    
    typesig { [DerValue] }
    # Construct the class from the DerValue
    def construct(der_val)
      if (!(der_val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoded CertificateValidity, " + "starting sequence tag missing.")
      end
      # check if UTCTime encoded or GeneralizedTime
      if ((der_val.attr_data.available).equal?(0))
        raise IOException.new("No data encoded for CertificateValidity")
      end
      der_in = DerInputStream.new(der_val.to_byte_array)
      seq = der_in.get_sequence(2)
      if (!(seq.attr_length).equal?(2))
        raise IOException.new("Invalid encoding for CertificateValidity")
      end
      if ((seq[0].attr_tag).equal?(DerValue.attr_tag_utc_time))
        @not_before = der_val.attr_data.get_utctime
      else
        if ((seq[0].attr_tag).equal?(DerValue.attr_tag_generalized_time))
          @not_before = der_val.attr_data.get_generalized_time
        else
          raise IOException.new("Invalid encoding for CertificateValidity")
        end
      end
      if ((seq[1].attr_tag).equal?(DerValue.attr_tag_utc_time))
        @not_after = der_val.attr_data.get_utctime
      else
        if ((seq[1].attr_tag).equal?(DerValue.attr_tag_generalized_time))
          @not_after = der_val.attr_data.get_generalized_time
        else
          raise IOException.new("Invalid encoding for CertificateValidity")
        end
      end
    end
    
    typesig { [] }
    # 
    # Default constructor for the class.
    def initialize
      @not_before = nil
      @not_after = nil
    end
    
    typesig { [Date, Date] }
    # 
    # The default constructor for this class for the specified interval.
    # 
    # @param notBefore the date and time before which the certificate
    # is not valid.
    # @param notAfter the date and time after which the certificate is
    # not valid.
    def initialize(not_before, not_after)
      @not_before = nil
      @not_after = nil
      @not_before = not_before
      @not_after = not_after
    end
    
    typesig { [DerInputStream] }
    # 
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the CertificateValidity from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @not_before = nil
      @not_after = nil
      der_val = in_.get_der_value
      construct(der_val)
    end
    
    typesig { [] }
    # 
    # Return the validity period as user readable string.
    def to_s
      if ((@not_before).nil? || (@not_after).nil?)
        return ""
      end
      return ("Validity: [From: " + (@not_before.to_s).to_s + ",\n               To: " + (@not_after.to_s).to_s + "]")
    end
    
    typesig { [OutputStream] }
    # 
    # Encode the CertificateValidity period in DER form to the stream.
    # 
    # @param out the OutputStream to marshal the contents to.
    # @exception IOException on errors.
    def encode(out)
      # in cases where default constructor is used check for
      # null values
      if ((@not_before).nil? || (@not_after).nil?)
        raise IOException.new("CertAttrSet:CertificateValidity:" + " null values to encode.\n")
      end
      pair = DerOutputStream.new
      if (@not_before.get_time < YR_2050)
        pair.put_utctime(@not_before)
      else
        pair.put_generalized_time(@not_before)
      end
      if (@not_after.get_time < YR_2050)
        pair.put_utctime(@not_after)
      else
        pair.put_generalized_time(@not_after)
      end
      seq = DerOutputStream.new
      seq.write(DerValue.attr_tag_sequence, pair)
      out.write(seq.to_byte_array)
    end
    
    typesig { [String, Object] }
    # 
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(Date)))
        raise IOException.new("Attribute must be of type Date.")
      end
      if (name.equals_ignore_case(NOT_BEFORE))
        @not_before = obj
      else
        if (name.equals_ignore_case(NOT_AFTER))
          @not_after = obj
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateValidity.")
        end
      end
    end
    
    typesig { [String] }
    # 
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(NOT_BEFORE))
        return (get_not_before)
      else
        if (name.equals_ignore_case(NOT_AFTER))
          return (get_not_after)
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateValidity.")
        end
      end
    end
    
    typesig { [String] }
    # 
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(NOT_BEFORE))
        @not_before = nil
      else
        if (name.equals_ignore_case(NOT_AFTER))
          @not_after = nil
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet: CertificateValidity.")
        end
      end
    end
    
    typesig { [] }
    # 
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(NOT_BEFORE)
      elements.add_element(NOT_AFTER)
      return (elements.elements)
    end
    
    typesig { [] }
    # 
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    typesig { [] }
    # 
    # Verify that the current time is within the validity period.
    # 
    # @exception CertificateExpiredException if the certificate has expired.
    # @exception CertificateNotYetValidException if the certificate is not
    # yet valid.
    def valid
      now = Date.new
      valid(now)
    end
    
    typesig { [Date] }
    # 
    # Verify that the passed time is within the validity period.
    # @param now the Date against which to compare the validity
    # period.
    # 
    # @exception CertificateExpiredException if the certificate has expired
    # with respect to the <code>Date</code> supplied.
    # @exception CertificateNotYetValidException if the certificate is not
    # yet valid with respect to the <code>Date</code> supplied.
    def valid(now)
      # 
      # we use the internal Dates rather than the passed in Date
      # because someone could override the Date methods after()
      # and before() to do something entirely different.
      if (@not_before.after(now))
        raise CertificateNotYetValidException.new("NotBefore: " + (@not_before.to_s).to_s)
      end
      if (@not_after.before(now))
        raise CertificateExpiredException.new("NotAfter: " + (@not_after.to_s).to_s)
      end
    end
    
    private
    alias_method :initialize__certificate_validity, :initialize
  end
  
end
