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
  module PolicyConstraintsExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Vector
      include ::Sun::Security::Util
    }
  end
  
  # 
  # This class defines the certificate extension which specifies the
  # Policy constraints.
  # <p>
  # The policy constraints extension can be used in certificates issued
  # to CAs. The policy constraints extension constrains path validation
  # in two ways. It can be used to prohibit policy mapping or require
  # that each certificate in a path contain an acceptable policy
  # identifier.<p>
  # The ASN.1 syntax for this is (IMPLICIT tagging is defined in the
  # module definition):
  # <pre>
  # PolicyConstraints ::= SEQUENCE {
  # requireExplicitPolicy [0] SkipCerts OPTIONAL,
  # inhibitPolicyMapping  [1] SkipCerts OPTIONAL
  # }
  # SkipCerts ::= INTEGER (0..MAX)
  # </pre>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class PolicyConstraintsExtension < PolicyConstraintsExtensionImports.const_get :Extension
    include_class_members PolicyConstraintsExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # 
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.PolicyConstraints" }
      const_attr_reader  :IDENT
      
      # 
      # Attribute names.
      const_set_lazy(:NAME) { "PolicyConstraints" }
      const_attr_reader  :NAME
      
      const_set_lazy(:REQUIRE) { "require" }
      const_attr_reader  :REQUIRE
      
      const_set_lazy(:INHIBIT) { "inhibit" }
      const_attr_reader  :INHIBIT
      
      const_set_lazy(:TAG_REQUIRE) { 0 }
      const_attr_reader  :TAG_REQUIRE
      
      const_set_lazy(:TAG_INHIBIT) { 1 }
      const_attr_reader  :TAG_INHIBIT
    }
    
    attr_accessor :require
    alias_method :attr_require, :require
    undef_method :require
    alias_method :attr_require=, :require=
    undef_method :require=
    
    attr_accessor :inhibit
    alias_method :attr_inhibit, :inhibit
    undef_method :inhibit
    alias_method :attr_inhibit=, :inhibit=
    undef_method :inhibit=
    
    typesig { [] }
    # Encode this extension value.
    def encode_this
      if ((@require).equal?(-1) && (@inhibit).equal?(-1))
        self.attr_extension_value = nil
        return
      end
      tagged = DerOutputStream.new
      seq = DerOutputStream.new
      if (!(@require).equal?(-1))
        tmp = DerOutputStream.new
        tmp.put_integer(@require)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_REQUIRE), tmp)
      end
      if (!(@inhibit).equal?(-1))
        tmp_ = DerOutputStream.new
        tmp_.put_integer(@inhibit)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_INHIBIT), tmp_)
      end
      seq.write(DerValue.attr_tag_sequence, tagged)
      self.attr_extension_value = seq.to_byte_array
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Create a PolicyConstraintsExtension object with both
    # require explicit policy and inhibit policy mapping. The
    # extension is marked non-critical.
    # 
    # @param require require explicit policy (-1 for optional).
    # @param inhibit inhibit policy mapping (-1 for optional).
    def initialize(require, inhibit)
      initialize__policy_constraints_extension(Boolean::FALSE, require, inhibit)
    end
    
    typesig { [Boolean, ::Java::Int, ::Java::Int] }
    # 
    # Create a PolicyConstraintsExtension object with specified
    # criticality and both require explicit policy and inhibit
    # policy mapping.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param require require explicit policy (-1 for optional).
    # @param inhibit inhibit policy mapping (-1 for optional).
    def initialize(critical, require, inhibit)
      @require = 0
      @inhibit = 0
      super()
      @require = -1
      @inhibit = -1
      @require = require
      @inhibit = inhibit
      self.attr_extension_id = PKIXExtensions::PolicyConstraints_Id
      self.attr_critical = critical.boolean_value
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # 
    # Create the extension from its DER encoded value and criticality.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @require = 0
      @inhibit = 0
      super()
      @require = -1
      @inhibit = -1
      self.attr_extension_id = PKIXExtensions::PolicyConstraints_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Sequence tag missing for PolicyConstraint.")
      end
      in_ = val.attr_data
      while (!(in_).nil? && !(in_.available).equal?(0))
        next_ = in_.get_der_value
        if (next_.is_context_specific(TAG_REQUIRE) && !next_.is_constructed)
          if (!(@require).equal?(-1))
            raise IOException.new("Duplicate requireExplicitPolicy" + "found in the PolicyConstraintsExtension")
          end
          next_.reset_tag(DerValue.attr_tag_integer)
          @require = next_.get_integer
        else
          if (next_.is_context_specific(TAG_INHIBIT) && !next_.is_constructed)
            if (!(@inhibit).equal?(-1))
              raise IOException.new("Duplicate inhibitPolicyMapping" + "found in the PolicyConstraintsExtension")
            end
            next_.reset_tag(DerValue.attr_tag_integer)
            @inhibit = next_.get_integer
          else
            raise IOException.new("Invalid encoding of PolicyConstraint")
          end
        end
      end
    end
    
    typesig { [] }
    # 
    # Return the extension as user readable string.
    def to_s
      s = nil
      s = (super).to_s + "PolicyConstraints: [" + "  Require: "
      if ((@require).equal?(-1))
        s += "unspecified;"
      else
        s += (@require).to_s + ";"
      end
      s += "\tInhibit: "
      if ((@inhibit).equal?(-1))
        s += "unspecified"
      else
        s += (@inhibit).to_s
      end
      s += " ]\n"
      return s
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
        self.attr_extension_id = PKIXExtensions::PolicyConstraints_Id
        self.attr_critical = false
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # 
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(JavaInteger)))
        raise IOException.new("Attribute value should be of type Integer.")
      end
      if (name.equals_ignore_case(REQUIRE))
        @require = (obj).int_value
      else
        if (name.equals_ignore_case(INHIBIT))
          @inhibit = (obj).int_value
        else
          raise IOException.new("Attribute name " + "[" + name + "]" + " not recognized by " + "CertAttrSet:PolicyConstraints.")
        end
      end
      encode_this
    end
    
    typesig { [String] }
    # 
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(REQUIRE))
        return @require
      else
        if (name.equals_ignore_case(INHIBIT))
          return @inhibit
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:PolicyConstraints.")
        end
      end
    end
    
    typesig { [String] }
    # 
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(REQUIRE))
        @require = -1
      else
        if (name.equals_ignore_case(INHIBIT))
          @inhibit = -1
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:PolicyConstraints.")
        end
      end
      encode_this
    end
    
    typesig { [] }
    # 
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(REQUIRE)
      elements.add_element(INHIBIT)
      return (elements.elements)
    end
    
    typesig { [] }
    # 
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__policy_constraints_extension, :initialize
  end
  
end
