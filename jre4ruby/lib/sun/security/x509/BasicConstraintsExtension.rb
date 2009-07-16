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
  module BasicConstraintsExtensionImports
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
  # This class represents the Basic Constraints Extension.
  # 
  # <p>The basic constraints extension identifies whether the subject of the
  # certificate is a CA and how deep a certification path may exist
  # through that CA.
  # 
  # <pre>
  # The ASN.1 syntax for this extension is:
  # BasicConstraints ::= SEQUENCE {
  # cA                BOOLEAN DEFAULT FALSE,
  # pathLenConstraint INTEGER (0..MAX) OPTIONAL
  # }
  # </pre>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  # @see Extension
  class BasicConstraintsExtension < BasicConstraintsExtensionImports.const_get :Extension
    include_class_members BasicConstraintsExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # 
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.BasicConstraints" }
      const_attr_reader  :IDENT
      
      # 
      # Attribute names.
      const_set_lazy(:NAME) { "BasicConstraints" }
      const_attr_reader  :NAME
      
      const_set_lazy(:IS_CA) { "is_ca" }
      const_attr_reader  :IS_CA
      
      const_set_lazy(:PATH_LEN) { "path_len" }
      const_attr_reader  :PATH_LEN
    }
    
    # Private data members
    attr_accessor :ca
    alias_method :attr_ca, :ca
    undef_method :ca
    alias_method :attr_ca=, :ca=
    undef_method :ca=
    
    attr_accessor :path_len
    alias_method :attr_path_len, :path_len
    undef_method :path_len
    alias_method :attr_path_len=, :path_len=
    undef_method :path_len=
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      if ((@ca).equal?(false) && @path_len < 0)
        self.attr_extension_value = nil
        return
      end
      out = DerOutputStream.new
      tmp = DerOutputStream.new
      if (@ca)
        tmp.put_boolean(@ca)
      end
      if (@path_len >= 0)
        tmp.put_integer(@path_len)
      end
      out.write(DerValue.attr_tag_sequence, tmp)
      self.attr_extension_value = out.to_byte_array
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    # 
    # Default constructor for this object. The extension is marked
    # critical if the ca flag is true, false otherwise.
    # 
    # @param ca true, if the subject of the Certificate is a CA.
    # @param len specifies the depth of the certification path.
    def initialize(ca, len)
      initialize__basic_constraints_extension(Boolean.value_of(ca), ca, len)
    end
    
    typesig { [Boolean, ::Java::Boolean, ::Java::Int] }
    # 
    # Constructor for this object with specified criticality.
    # 
    # @param critical true, if the extension should be marked critical
    # @param ca true, if the subject of the Certificate is a CA.
    # @param len specifies the depth of the certification path.
    def initialize(critical, ca, len)
      @ca = false
      @path_len = 0
      super()
      @ca = false
      @path_len = -1
      @ca = ca
      @path_len = len
      self.attr_extension_id = PKIXExtensions::BasicConstraints_Id
      self.attr_critical = critical.boolean_value
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # 
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical flag indicating if extension is critical or not
    # @param value an array containing the DER encoded bytes of the extension.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @ca = false
      @path_len = 0
      super()
      @ca = false
      @path_len = -1
      self.attr_extension_id = PKIXExtensions::BasicConstraints_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding of BasicConstraints")
      end
      if ((val.attr_data).nil?)
        # non-CA cert ("cA" field is FALSE by default), return -1
        return
      end
      opt = val.attr_data.get_der_value
      if (!(opt.attr_tag).equal?(DerValue.attr_tag_boolean))
        # non-CA cert ("cA" field is FALSE by default), return -1
        return
      end
      @ca = opt.get_boolean
      if ((val.attr_data.available).equal?(0))
        # From PKIX profile:
        # Where pathLenConstraint does not appear, there is no
        # limit to the allowed length of the certification path.
        @path_len = JavaInteger::MAX_VALUE
        return
      end
      opt = val.attr_data.get_der_value
      if (!(opt.attr_tag).equal?(DerValue.attr_tag_integer))
        raise IOException.new("Invalid encoding of BasicConstraints")
      end
      @path_len = opt.get_integer
      # 
      # Activate this check once again after PKIX profiling
      # is a standard and this check no longer imposes an
      # interoperability barrier.
      # if (ca) {
      # if (!this.critical) {
      # throw new IOException("Criticality cannot be false for CA.");
      # }
      # }
    end
    
    typesig { [] }
    # 
    # Return user readable form of extension.
    def to_s
      s = (super).to_s + "BasicConstraints:[\n"
      s += (((@ca) ? ("  CA:true") : ("  CA:false"))).to_s + "\n"
      if (@path_len >= 0)
        s += "  PathLen:" + (@path_len).to_s + "\n"
      else
        s += "  PathLen: undefined\n"
      end
      return (s + "]\n")
    end
    
    typesig { [OutputStream] }
    # 
    # Encode this extension value to the output stream.
    # 
    # @param out the DerOutputStream to encode the extension to.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::BasicConstraints_Id
        if (@ca)
          self.attr_critical = true
        else
          self.attr_critical = false
        end
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # 
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(IS_CA))
        if (!(obj.is_a?(Boolean)))
          raise IOException.new("Attribute value should be of type Boolean.")
        end
        @ca = (obj).boolean_value
      else
        if (name.equals_ignore_case(PATH_LEN))
          if (!(obj.is_a?(JavaInteger)))
            raise IOException.new("Attribute value should be of type Integer.")
          end
          @path_len = (obj).int_value
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:BasicConstraints.")
        end
      end
      encode_this
    end
    
    typesig { [String] }
    # 
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(IS_CA))
        return (Boolean.value_of(@ca))
      else
        if (name.equals_ignore_case(PATH_LEN))
          return (JavaInteger.value_of(@path_len))
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:BasicConstraints.")
        end
      end
    end
    
    typesig { [String] }
    # 
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(IS_CA))
        @ca = false
      else
        if (name.equals_ignore_case(PATH_LEN))
          @path_len = -1
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:BasicConstraints.")
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
      elements.add_element(IS_CA)
      elements.add_element(PATH_LEN)
      return (elements.elements)
    end
    
    typesig { [] }
    # 
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__basic_constraints_extension, :initialize
  end
  
end
