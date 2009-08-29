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
  module InhibitAnyPolicyExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :ObjectIdentifier
    }
  end
  
  # This class represents the Inhibit Any-Policy Extension.
  # 
  # <p>The inhibit any-policy extension can be used in certificates issued
  # to CAs. The inhibit any-policy indicates that the special any-policy
  # OID, with the value {2 5 29 32 0}, is not considered an explicit
  # match for other certificate policies.  The value indicates the number
  # of additional certificates that may appear in the path before any-
  # policy is no longer permitted.  For example, a value of one indicates
  # that any-policy may be processed in certificates issued by the sub-
  # ject of this certificate, but not in additional certificates in the
  # path.
  # <p>
  # This extension MUST be critical.
  # <p>
  # The ASN.1 syntax for this extension is:
  # <code><pre>
  # id-ce-inhibitAnyPolicy OBJECT IDENTIFIER ::=  { id-ce 54 }
  # 
  # InhibitAnyPolicy ::= SkipCerts
  # 
  # SkipCerts ::= INTEGER (0..MAX)
  # </pre></code>
  # @author Anne Anderson
  # @see CertAttrSet
  # @see Extension
  class InhibitAnyPolicyExtension < InhibitAnyPolicyExtensionImports.const_get :Extension
    include_class_members InhibitAnyPolicyExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.InhibitAnyPolicy" }
      const_attr_reader  :IDENT
      
      # Object identifier for "any-policy"
      
      def any_policy_id
        defined?(@@any_policy_id) ? @@any_policy_id : @@any_policy_id= nil
      end
      alias_method :attr_any_policy_id, :any_policy_id
      
      def any_policy_id=(value)
        @@any_policy_id = value
      end
      alias_method :attr_any_policy_id=, :any_policy_id=
      
      when_class_loaded do
        begin
          self.attr_any_policy_id = ObjectIdentifier.new("2.5.29.32.0")
        rescue IOException => ioe
          # Should not happen
        end
      end
      
      # Attribute names.
      const_set_lazy(:NAME) { "InhibitAnyPolicy" }
      const_attr_reader  :NAME
      
      const_set_lazy(:SKIP_CERTS) { "skip_certs" }
      const_attr_reader  :SKIP_CERTS
    }
    
    # Private data members
    attr_accessor :skip_certs
    alias_method :attr_skip_certs, :skip_certs
    undef_method :skip_certs
    alias_method :attr_skip_certs=, :skip_certs=
    undef_method :skip_certs=
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      out = DerOutputStream.new
      out.put_integer(@skip_certs)
      self.attr_extension_value = out.to_byte_array
    end
    
    typesig { [::Java::Int] }
    # Default constructor for this object.
    # 
    # @param skipCerts specifies the depth of the certification path.
    # Use value of -1 to request unlimited depth.
    def initialize(skip_certs)
      @skip_certs = 0
      super()
      @skip_certs = JavaInteger::MAX_VALUE
      if (skip_certs < -1)
        raise IOException.new("Invalid value for skipCerts")
      end
      if ((skip_certs).equal?(-1))
        @skip_certs = JavaInteger::MAX_VALUE
      else
        @skip_certs = skip_certs
      end
      self.attr_extension_id = PKIXExtensions::InhibitAnyPolicy_Id
      self.attr_critical = true
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical criticality flag to use.  Must be true for this
    # extension.
    # @param value a byte array holding the DER-encoded extension value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @skip_certs = 0
      super()
      @skip_certs = JavaInteger::MAX_VALUE
      self.attr_extension_id = PKIXExtensions::InhibitAnyPolicy_Id
      if (!critical.boolean_value)
        raise IOException.new("Criticality cannot be false for " + "InhibitAnyPolicy")
      end
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_integer))
        raise IOException.new("Invalid encoding of InhibitAnyPolicy: " + "data not integer")
      end
      if ((val.attr_data).nil?)
        raise IOException.new("Invalid encoding of InhibitAnyPolicy: " + "null data")
      end
      skip_certs_value = val.get_integer
      if (skip_certs_value < -1)
        raise IOException.new("Invalid value for skipCerts")
      end
      if ((skip_certs_value).equal?(-1))
        @skip_certs = JavaInteger::MAX_VALUE
      else
        @skip_certs = skip_certs_value
      end
    end
    
    typesig { [] }
    # Return user readable form of extension.
    def to_s
      s = RJava.cast_to_string(super) + "InhibitAnyPolicy: " + RJava.cast_to_string(@skip_certs) + "\n"
      return s
    end
    
    typesig { [OutputStream] }
    # Encode this extension value to the output stream.
    # 
    # @param out the DerOutputStream to encode the extension to.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::InhibitAnyPolicy_Id
        self.attr_critical = true
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    # 
    # @param name name of attribute to set. Must be SKIP_CERTS.
    # @param obj  value to which attribute is to be set.  Must be Integer
    # type.
    # @throws IOException on error
    def set(name, obj)
      if (name.equals_ignore_case(SKIP_CERTS))
        if (!(obj.is_a?(JavaInteger)))
          raise IOException.new("Attribute value should be of type Integer.")
        end
        skip_certs_value = (obj).int_value
        if (skip_certs_value < -1)
          raise IOException.new("Invalid value for skipCerts")
        end
        if ((skip_certs_value).equal?(-1))
          @skip_certs = JavaInteger::MAX_VALUE
        else
          @skip_certs = skip_certs_value
        end
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:InhibitAnyPolicy.")
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    # 
    # @param name name of attribute to get.  Must be SKIP_CERTS.
    # @returns value of the attribute.  In this case it will be of type
    # Integer.
    # @throws IOException on error
    def get(name)
      if (name.equals_ignore_case(SKIP_CERTS))
        return (@skip_certs)
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:InhibitAnyPolicy.")
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    # 
    # @param name name of attribute to delete. Must be SKIP_CERTS.
    # @throws IOException on error.  In this case, IOException will always be
    # thrown, because the only attribute, SKIP_CERTS, is
    # required.
    def delete(name)
      if (name.equals_ignore_case(SKIP_CERTS))
        raise IOException.new("Attribute " + SKIP_CERTS + " may not be deleted.")
      else
        raise IOException.new("Attribute name not recognized by " + "CertAttrSet:InhibitAnyPolicy.")
      end
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    # 
    # @returns enumeration of elements
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(SKIP_CERTS)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    # 
    # @returns name of attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__inhibit_any_policy_extension, :initialize
  end
  
end
