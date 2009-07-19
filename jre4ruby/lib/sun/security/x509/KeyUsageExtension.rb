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
  module KeyUsageExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # Represent the Key Usage Extension.
  # 
  # <p>This extension, if present, defines the purpose (e.g., encipherment,
  # signature, certificate signing) of the key contained in the certificate.
  # The usage restriction might be employed when a multipurpose key is to be
  # restricted (e.g., when an RSA key should be used only for signing or only
  # for key encipherment).
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class KeyUsageExtension < KeyUsageExtensionImports.const_get :Extension
    include_class_members KeyUsageExtensionImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.KeyUsage" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "KeyUsage" }
      const_attr_reader  :NAME
      
      const_set_lazy(:DIGITAL_SIGNATURE) { "digital_signature" }
      const_attr_reader  :DIGITAL_SIGNATURE
      
      const_set_lazy(:NON_REPUDIATION) { "non_repudiation" }
      const_attr_reader  :NON_REPUDIATION
      
      const_set_lazy(:KEY_ENCIPHERMENT) { "key_encipherment" }
      const_attr_reader  :KEY_ENCIPHERMENT
      
      const_set_lazy(:DATA_ENCIPHERMENT) { "data_encipherment" }
      const_attr_reader  :DATA_ENCIPHERMENT
      
      const_set_lazy(:KEY_AGREEMENT) { "key_agreement" }
      const_attr_reader  :KEY_AGREEMENT
      
      const_set_lazy(:KEY_CERTSIGN) { "key_certsign" }
      const_attr_reader  :KEY_CERTSIGN
      
      const_set_lazy(:CRL_SIGN) { "crl_sign" }
      const_attr_reader  :CRL_SIGN
      
      const_set_lazy(:ENCIPHER_ONLY) { "encipher_only" }
      const_attr_reader  :ENCIPHER_ONLY
      
      const_set_lazy(:DECIPHER_ONLY) { "decipher_only" }
      const_attr_reader  :DECIPHER_ONLY
    }
    
    # Private data members
    attr_accessor :bit_string
    alias_method :attr_bit_string, :bit_string
    undef_method :bit_string
    alias_method :attr_bit_string=, :bit_string=
    undef_method :bit_string=
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      os = DerOutputStream.new
      os.put_truncated_unaligned_bit_string(BitArray.new(@bit_string))
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [::Java::Int] }
    # Check if bit is set.
    # 
    # @param position the position in the bit string to check.
    def is_set(position)
      return @bit_string[position]
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Set the bit at the specified position.
    def set(position, val)
      # enlarge bitString if necessary
      if (position >= @bit_string.attr_length)
        tmp = Array.typed(::Java::Boolean).new(position + 1) { false }
        System.arraycopy(@bit_string, 0, tmp, 0, @bit_string.attr_length)
        @bit_string = tmp
      end
      @bit_string[position] = val
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Create a KeyUsageExtension with the passed bit settings. The criticality
    # is set to true.
    # 
    # @param bitString the bits to be set for the extension.
    def initialize(bit_string)
      @bit_string = nil
      super()
      @bit_string = BitArray.new(bit_string.attr_length * 8, bit_string).to_boolean_array
      self.attr_extension_id = PKIXExtensions::KeyUsage_Id
      self.attr_critical = true
      encode_this
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    # Create a KeyUsageExtension with the passed bit settings. The criticality
    # is set to true.
    # 
    # @param bitString the bits to be set for the extension.
    def initialize(bit_string)
      @bit_string = nil
      super()
      @bit_string = bit_string
      self.attr_extension_id = PKIXExtensions::KeyUsage_Id
      self.attr_critical = true
      encode_this
    end
    
    typesig { [BitArray] }
    # Create a KeyUsageExtension with the passed bit settings. The criticality
    # is set to true.
    # 
    # @param bitString the bits to be set for the extension.
    def initialize(bit_string)
      @bit_string = nil
      super()
      @bit_string = bit_string.to_boolean_array
      self.attr_extension_id = PKIXExtensions::KeyUsage_Id
      self.attr_critical = true
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value of the same.
    # The DER encoded value may be wrapped in an OCTET STRING.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value (possibly
    # wrapped in an OCTET STRING).
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @bit_string = nil
      super()
      self.attr_extension_id = PKIXExtensions::KeyUsage_Id
      self.attr_critical = critical.boolean_value
      # The following check should be activated again after
      # the PKIX profiling work becomes standard and the check
      # is not a barrier to interoperability !
      # if (!this.critical) {
      # throw new IOException("KeyUsageExtension not marked critical,"
      # + " invalid profile.");
      # }
      ext_value = value
      if ((ext_value[0]).equal?(DerValue.attr_tag_octet_string))
        self.attr_extension_value = DerValue.new(ext_value).get_octet_string
      else
        self.attr_extension_value = ext_value
      end
      val = DerValue.new(self.attr_extension_value)
      @bit_string = val.get_unaligned_bit_string.to_boolean_array
    end
    
    typesig { [] }
    # Create a default key usage.
    def initialize
      @bit_string = nil
      super()
      self.attr_extension_id = PKIXExtensions::KeyUsage_Id
      self.attr_critical = true
      @bit_string = Array.typed(::Java::Boolean).new(0) { false }
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(Boolean)))
        raise IOException.new("Attribute must be of type Boolean.")
      end
      val = (obj).boolean_value
      if (name.equals_ignore_case(DIGITAL_SIGNATURE))
        set(0, val)
      else
        if (name.equals_ignore_case(NON_REPUDIATION))
          set(1, val)
        else
          if (name.equals_ignore_case(KEY_ENCIPHERMENT))
            set(2, val)
          else
            if (name.equals_ignore_case(DATA_ENCIPHERMENT))
              set(3, val)
            else
              if (name.equals_ignore_case(KEY_AGREEMENT))
                set(4, val)
              else
                if (name.equals_ignore_case(KEY_CERTSIGN))
                  set(5, val)
                else
                  if (name.equals_ignore_case(CRL_SIGN))
                    set(6, val)
                  else
                    if (name.equals_ignore_case(ENCIPHER_ONLY))
                      set(7, val)
                    else
                      if (name.equals_ignore_case(DECIPHER_ONLY))
                        set(8, val)
                      else
                        raise IOException.new("Attribute name not recognized by" + " CertAttrSet:KeyUsage.")
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(DIGITAL_SIGNATURE))
        return Boolean.value_of(is_set(0))
      else
        if (name.equals_ignore_case(NON_REPUDIATION))
          return Boolean.value_of(is_set(1))
        else
          if (name.equals_ignore_case(KEY_ENCIPHERMENT))
            return Boolean.value_of(is_set(2))
          else
            if (name.equals_ignore_case(DATA_ENCIPHERMENT))
              return Boolean.value_of(is_set(3))
            else
              if (name.equals_ignore_case(KEY_AGREEMENT))
                return Boolean.value_of(is_set(4))
              else
                if (name.equals_ignore_case(KEY_CERTSIGN))
                  return Boolean.value_of(is_set(5))
                else
                  if (name.equals_ignore_case(CRL_SIGN))
                    return Boolean.value_of(is_set(6))
                  else
                    if (name.equals_ignore_case(ENCIPHER_ONLY))
                      return Boolean.value_of(is_set(7))
                    else
                      if (name.equals_ignore_case(DECIPHER_ONLY))
                        return Boolean.value_of(is_set(8))
                      else
                        raise IOException.new("Attribute name not recognized by" + " CertAttrSet:KeyUsage.")
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(DIGITAL_SIGNATURE))
        set(0, false)
      else
        if (name.equals_ignore_case(NON_REPUDIATION))
          set(1, false)
        else
          if (name.equals_ignore_case(KEY_ENCIPHERMENT))
            set(2, false)
          else
            if (name.equals_ignore_case(DATA_ENCIPHERMENT))
              set(3, false)
            else
              if (name.equals_ignore_case(KEY_AGREEMENT))
                set(4, false)
              else
                if (name.equals_ignore_case(KEY_CERTSIGN))
                  set(5, false)
                else
                  if (name.equals_ignore_case(CRL_SIGN))
                    set(6, false)
                  else
                    if (name.equals_ignore_case(ENCIPHER_ONLY))
                      set(7, false)
                    else
                      if (name.equals_ignore_case(DECIPHER_ONLY))
                        set(8, false)
                      else
                        raise IOException.new("Attribute name not recognized by" + " CertAttrSet:KeyUsage.")
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      encode_this
    end
    
    typesig { [] }
    # Returns a printable representation of the KeyUsage.
    def to_s
      s = (super).to_s + "KeyUsage [\n"
      begin
        if (is_set(0))
          s += "  DigitalSignature\n"
        end
        if (is_set(1))
          s += "  Non_repudiation\n"
        end
        if (is_set(2))
          s += "  Key_Encipherment\n"
        end
        if (is_set(3))
          s += "  Data_Encipherment\n"
        end
        if (is_set(4))
          s += "  Key_Agreement\n"
        end
        if (is_set(5))
          s += "  Key_CertSign\n"
        end
        if (is_set(6))
          s += "  Crl_Sign\n"
        end
        if (is_set(7))
          s += "  Encipher_Only\n"
        end
        if (is_set(8))
          s += "  Decipher_Only\n"
        end
      rescue ArrayIndexOutOfBoundsException => ex
      end
      s += "]\n"
      return (s)
    end
    
    typesig { [OutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::KeyUsage_Id
        self.attr_critical = true
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(DIGITAL_SIGNATURE)
      elements.add_element(NON_REPUDIATION)
      elements.add_element(KEY_ENCIPHERMENT)
      elements.add_element(DATA_ENCIPHERMENT)
      elements.add_element(KEY_AGREEMENT)
      elements.add_element(KEY_CERTSIGN)
      elements.add_element(CRL_SIGN)
      elements.add_element(ENCIPHER_ONLY)
      elements.add_element(DECIPHER_ONLY)
      return (elements.elements)
    end
    
    typesig { [] }
    def get_bits
      return @bit_string.clone
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    private
    alias_method :initialize__key_usage_extension, :initialize
  end
  
end
