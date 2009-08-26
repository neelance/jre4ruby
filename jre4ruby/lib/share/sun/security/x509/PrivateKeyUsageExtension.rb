require "rjava"

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
  module PrivateKeyUsageExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateParsingException
      include_const ::Java::Security::Cert, :CertificateExpiredException
      include_const ::Java::Security::Cert, :CertificateNotYetValidException
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the Private Key Usage Extension.
  # 
  # <p>The Private Key Usage Period extension allows the certificate issuer
  # to specify a different validity period for the private key than the
  # certificate. This extension is intended for use with digital
  # signature keys.  This extension consists of two optional components
  # notBefore and notAfter.  The private key associated with the
  # certificate should not be used to sign objects before or after the
  # times specified by the two components, respectively.
  # 
  # <pre>
  # PrivateKeyUsagePeriod ::= SEQUENCE {
  # notBefore  [0]  GeneralizedTime OPTIONAL,
  # notAfter   [1]  GeneralizedTime OPTIONAL }
  # </pre>
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class PrivateKeyUsageExtension < PrivateKeyUsageExtensionImports.const_get :Extension
    include_class_members PrivateKeyUsageExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.PrivateKeyUsage" }
      const_attr_reader  :IDENT
      
      # Sub attributes name for this CertAttrSet.
      const_set_lazy(:NAME) { "PrivateKeyUsage" }
      const_attr_reader  :NAME
      
      const_set_lazy(:NOT_BEFORE) { "not_before" }
      const_attr_reader  :NOT_BEFORE
      
      const_set_lazy(:NOT_AFTER) { "not_after" }
      const_attr_reader  :NOT_AFTER
      
      # Private data members
      const_set_lazy(:TAG_BEFORE) { 0 }
      const_attr_reader  :TAG_BEFORE
      
      const_set_lazy(:TAG_AFTER) { 1 }
      const_attr_reader  :TAG_AFTER
    }
    
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
    # Encode this extension value.
    def encode_this
      if ((@not_before).nil? && (@not_after).nil?)
        self.attr_extension_value = nil
        return
      end
      seq = DerOutputStream.new
      tagged = DerOutputStream.new
      if (!(@not_before).nil?)
        tmp = DerOutputStream.new
        tmp.put_generalized_time(@not_before)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_BEFORE), tmp)
      end
      if (!(@not_after).nil?)
        tmp = DerOutputStream.new
        tmp.put_generalized_time(@not_after)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_AFTER), tmp)
      end
      seq.write(DerValue.attr_tag_sequence, tagged)
      self.attr_extension_value = seq.to_byte_array
    end
    
    typesig { [JavaDate, JavaDate] }
    # The default constructor for PrivateKeyUsageExtension.
    # 
    # @param notBefore the date/time before which the private key
    # should not be used.
    # @param notAfter the date/time after which the private key
    # should not be used.
    def initialize(not_before, not_after)
      @not_before = nil
      @not_after = nil
      super()
      @not_before = nil
      @not_after = nil
      @not_before = not_before
      @not_after = not_after
      self.attr_extension_id = PKIXExtensions::PrivateKeyUsage_Id
      self.attr_critical = false
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception CertificateException on certificate parsing errors.
    # @exception IOException on error.
    def initialize(critical, value)
      @not_before = nil
      @not_after = nil
      super()
      @not_before = nil
      @not_after = nil
      self.attr_extension_id = PKIXExtensions::PrivateKeyUsage_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      str = DerInputStream.new(self.attr_extension_value)
      seq = str.get_sequence(2)
      # NB. this is always encoded with the IMPLICIT tag
      # The checks only make sense if we assume implicit tagging,
      # with explicit tagging the form is always constructed.
      i = 0
      while i < seq.attr_length
        opt = seq[i]
        if (opt.is_context_specific(TAG_BEFORE) && !opt.is_constructed)
          if (!(@not_before).nil?)
            raise CertificateParsingException.new("Duplicate notBefore in PrivateKeyUsage.")
          end
          opt.reset_tag(DerValue.attr_tag_generalized_time)
          str = DerInputStream.new(opt.to_byte_array)
          @not_before = str.get_generalized_time
        else
          if (opt.is_context_specific(TAG_AFTER) && !opt.is_constructed)
            if (!(@not_after).nil?)
              raise CertificateParsingException.new("Duplicate notAfter in PrivateKeyUsage.")
            end
            opt.reset_tag(DerValue.attr_tag_generalized_time)
            str = DerInputStream.new(opt.to_byte_array)
            @not_after = str.get_generalized_time
          else
            raise IOException.new("Invalid encoding of " + "PrivateKeyUsageExtension")
          end
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Return the printable string.
    def to_s
      return (RJava.cast_to_string(super) + "PrivateKeyUsage: [\n" + RJava.cast_to_string((((@not_before).nil?) ? "" : "From: " + RJava.cast_to_string(@not_before.to_s) + ", ")) + RJava.cast_to_string((((@not_after).nil?) ? "" : "To: " + RJava.cast_to_string(@not_after.to_s))) + "]\n")
    end
    
    typesig { [] }
    # Verify that that the current time is within the validity period.
    # 
    # @exception CertificateExpiredException if the certificate has expired.
    # @exception CertificateNotYetValidException if the certificate is not
    # yet valid.
    def valid
      now = JavaDate.new
      valid(now)
    end
    
    typesig { [JavaDate] }
    # Verify that that the passed time is within the validity period.
    # 
    # @exception CertificateExpiredException if the certificate has expired
    # with respect to the <code>Date</code> supplied.
    # @exception CertificateNotYetValidException if the certificate is not
    # yet valid with respect to the <code>Date</code> supplied.
    def valid(now)
      # we use the internal Dates rather than the passed in Date
      # because someone could override the Date methods after()
      # and before() to do something entirely different.
      if (@not_before.after(now))
        raise CertificateNotYetValidException.new("NotBefore: " + RJava.cast_to_string(@not_before.to_s))
      end
      if (@not_after.before(now))
        raise CertificateExpiredException.new("NotAfter: " + RJava.cast_to_string(@not_after.to_s))
      end
    end
    
    typesig { [OutputStream] }
    # Write the extension to the OutputStream.
    # 
    # @param out the OutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::PrivateKeyUsage_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    # @exception CertificateException on attribute handling errors.
    def set(name, obj)
      if (!(obj.is_a?(JavaDate)))
        raise CertificateException.new("Attribute must be of type Date.")
      end
      if (name.equals_ignore_case(NOT_BEFORE))
        @not_before = obj
      else
        if (name.equals_ignore_case(NOT_AFTER))
          @not_after = obj
        else
          raise CertificateException.new("Attribute name not recognized by" + " CertAttrSet:PrivateKeyUsage.")
        end
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    # @exception CertificateException on attribute handling errors.
    def get(name)
      if (name.equals_ignore_case(NOT_BEFORE))
        return (JavaDate.new(@not_before.get_time))
      else
        if (name.equals_ignore_case(NOT_AFTER))
          return (JavaDate.new(@not_after.get_time))
        else
          raise CertificateException.new("Attribute name not recognized by" + " CertAttrSet:PrivateKeyUsage.")
        end
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    # @exception CertificateException on attribute handling errors.
    def delete(name)
      if (name.equals_ignore_case(NOT_BEFORE))
        @not_before = nil
      else
        if (name.equals_ignore_case(NOT_AFTER))
          @not_after = nil
        else
          raise CertificateException.new("Attribute name not recognized by" + " CertAttrSet:PrivateKeyUsage.")
        end
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(NOT_BEFORE)
      elements.add_element(NOT_AFTER)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__private_key_usage_extension, :initialize
  end
  
end
