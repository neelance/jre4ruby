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
  module AuthorityKeyIdentifierExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # This class represents the Authority Key Identifier Extension.
  # 
  # <p>The authority key identifier extension provides a means of
  # identifying the particular public key used to sign a certificate.
  # This extension would be used where an issuer has multiple signing
  # keys (either due to multiple concurrent key pairs or due to
  # changeover).
  # <p>
  # The ASN.1 syntax for this is:
  # <pre>
  # AuthorityKeyIdentifier ::= SEQUENCE {
  # keyIdentifier             [0] KeyIdentifier           OPTIONAL,
  # authorityCertIssuer       [1] GeneralNames            OPTIONAL,
  # authorityCertSerialNumber [2] CertificateSerialNumber OPTIONAL
  # }
  # KeyIdentifier ::= OCTET STRING
  # </pre>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class AuthorityKeyIdentifierExtension < AuthorityKeyIdentifierExtensionImports.const_get :Extension
    include_class_members AuthorityKeyIdentifierExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.AuthorityKeyIdentifier" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "AuthorityKeyIdentifier" }
      const_attr_reader  :NAME
      
      const_set_lazy(:KEY_ID) { "key_id" }
      const_attr_reader  :KEY_ID
      
      const_set_lazy(:AUTH_NAME) { "auth_name" }
      const_attr_reader  :AUTH_NAME
      
      const_set_lazy(:SERIAL_NUMBER) { "serial_number" }
      const_attr_reader  :SERIAL_NUMBER
      
      # Private data members
      const_set_lazy(:TAG_ID) { 0 }
      const_attr_reader  :TAG_ID
      
      const_set_lazy(:TAG_NAMES) { 1 }
      const_attr_reader  :TAG_NAMES
      
      const_set_lazy(:TAG_SERIAL_NUM) { 2 }
      const_attr_reader  :TAG_SERIAL_NUM
    }
    
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    attr_accessor :names
    alias_method :attr_names, :names
    undef_method :names
    alias_method :attr_names=, :names=
    undef_method :names=
    
    attr_accessor :serial_num
    alias_method :attr_serial_num, :serial_num
    undef_method :serial_num
    alias_method :attr_serial_num=, :serial_num=
    undef_method :serial_num=
    
    typesig { [] }
    # Encode only the extension value
    def encode_this
      if ((@id).nil? && (@names).nil? && (@serial_num).nil?)
        self.attr_extension_value = nil
        return
      end
      seq = DerOutputStream.new
      tmp = DerOutputStream.new
      if (!(@id).nil?)
        tmp1 = DerOutputStream.new
        @id.encode(tmp1)
        tmp.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_ID), tmp1)
      end
      begin
        if (!(@names).nil?)
          tmp1 = DerOutputStream.new
          @names.encode(tmp1)
          tmp.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_NAMES), tmp1)
        end
      rescue JavaException => e
        raise IOException.new(e.to_s)
      end
      if (!(@serial_num).nil?)
        tmp1 = DerOutputStream.new
        @serial_num.encode(tmp1)
        tmp.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_SERIAL_NUM), tmp1)
      end
      seq.write(DerValue.attr_tag_sequence, tmp)
      self.attr_extension_value = seq.to_byte_array
    end
    
    typesig { [KeyIdentifier, GeneralNames, SerialNumber] }
    # The default constructor for this extension.  Null parameters make
    # the element optional (not present).
    # 
    # @param id the KeyIdentifier associated with this extension.
    # @param names the GeneralNames associated with this extension
    # @param serialNum the CertificateSerialNumber associated with
    # this extension.
    # @exception IOException on error.
    def initialize(kid, name, sn)
      @id = nil
      @names = nil
      @serial_num = nil
      super()
      @id = nil
      @names = nil
      @serial_num = nil
      @id = kid
      @names = name
      @serial_num = sn
      self.attr_extension_id = PKIXExtensions::AuthorityKey_Id
      self.attr_critical = false
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @id = nil
      @names = nil
      @serial_num = nil
      super()
      @id = nil
      @names = nil
      @serial_num = nil
      self.attr_extension_id = PKIXExtensions::AuthorityKey_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for " + "AuthorityKeyIdentifierExtension.")
      end
      # Note that all the fields in AuthorityKeyIdentifier are defined as
      # being OPTIONAL, i.e., there could be an empty SEQUENCE, resulting
      # in val.data being null.
      while ((!(val.attr_data).nil?) && (!(val.attr_data.available).equal?(0)))
        opt = val.attr_data.get_der_value
        # NB. this is always encoded with the IMPLICIT tag
        # The checks only make sense if we assume implicit tagging,
        # with explicit tagging the form is always constructed.
        if (opt.is_context_specific(TAG_ID) && !opt.is_constructed)
          if (!(@id).nil?)
            raise IOException.new("Duplicate KeyIdentifier in " + "AuthorityKeyIdentifier.")
          end
          opt.reset_tag(DerValue.attr_tag_octet_string)
          @id = KeyIdentifier.new(opt)
        else
          if (opt.is_context_specific(TAG_NAMES) && opt.is_constructed)
            if (!(@names).nil?)
              raise IOException.new("Duplicate GeneralNames in " + "AuthorityKeyIdentifier.")
            end
            opt.reset_tag(DerValue.attr_tag_sequence)
            @names = GeneralNames.new(opt)
          else
            if (opt.is_context_specific(TAG_SERIAL_NUM) && !opt.is_constructed)
              if (!(@serial_num).nil?)
                raise IOException.new("Duplicate SerialNumber in " + "AuthorityKeyIdentifier.")
              end
              opt.reset_tag(DerValue.attr_tag_integer)
              @serial_num = SerialNumber.new(opt)
            else
              raise IOException.new("Invalid encoding of " + "AuthorityKeyIdentifierExtension.")
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Return the object as a string.
    def to_s
      s = RJava.cast_to_string(super) + "AuthorityKeyIdentifier [\n"
      if (!(@id).nil?)
        s += RJava.cast_to_string(@id.to_s) + "\n"
      end
      if (!(@names).nil?)
        s += RJava.cast_to_string(@names.to_s) + "\n"
      end
      if (!(@serial_num).nil?)
        s += RJava.cast_to_string(@serial_num.to_s) + "\n"
      end
      return (s + "]\n")
    end
    
    typesig { [OutputStream] }
    # Write the extension to the OutputStream.
    # 
    # @param out the OutputStream to write the extension to.
    # @exception IOException on error.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::AuthorityKey_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(KEY_ID))
        if (!(obj.is_a?(KeyIdentifier)))
          raise IOException.new("Attribute value should be of " + "type KeyIdentifier.")
        end
        @id = obj
      else
        if (name.equals_ignore_case(AUTH_NAME))
          if (!(obj.is_a?(GeneralNames)))
            raise IOException.new("Attribute value should be of " + "type GeneralNames.")
          end
          @names = obj
        else
          if (name.equals_ignore_case(SERIAL_NUMBER))
            if (!(obj.is_a?(SerialNumber)))
              raise IOException.new("Attribute value should be of " + "type SerialNumber.")
            end
            @serial_num = obj
          else
            raise IOException.new("Attribute name not recognized by " + "CertAttrSet:AuthorityKeyIdentifier.")
          end
        end
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(KEY_ID))
        return (@id)
      else
        if (name.equals_ignore_case(AUTH_NAME))
          return (@names)
        else
          if (name.equals_ignore_case(SERIAL_NUMBER))
            return (@serial_num)
          else
            raise IOException.new("Attribute name not recognized by " + "CertAttrSet:AuthorityKeyIdentifier.")
          end
        end
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(KEY_ID))
        @id = nil
      else
        if (name.equals_ignore_case(AUTH_NAME))
          @names = nil
        else
          if (name.equals_ignore_case(SERIAL_NUMBER))
            @serial_num = nil
          else
            raise IOException.new("Attribute name not recognized by " + "CertAttrSet:AuthorityKeyIdentifier.")
          end
        end
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(KEY_ID)
      elements.add_element(AUTH_NAME)
      elements.add_element(SERIAL_NUMBER)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__authority_key_identifier_extension, :initialize
  end
  
end
