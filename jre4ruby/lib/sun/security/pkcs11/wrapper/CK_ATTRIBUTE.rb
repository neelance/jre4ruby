require "rjava"

# Portions Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
# 
# Copyright  (c) 2002 Graz University of Technology. All rights reserved.
# 
# Redistribution and use in  source and binary forms, with or without
# modification, are permitted  provided that the following conditions are met:
# 
# 1. Redistributions of  source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in  binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 3. The end-user documentation included with the redistribution, if any, must
# include the following acknowledgment:
# 
# "This product includes software developed by IAIK of Graz University of
# Technology."
# 
# Alternately, this acknowledgment may appear in the software itself, if
# and wherever such third-party acknowledgments normally appear.
# 
# 4. The names "Graz University of Technology" and "IAIK of Graz University of
# Technology" must not be used to endorse or promote products derived from
# this software without prior written permission.
# 
# 5. Products derived from this software may not be called
# "IAIK PKCS Wrapper", nor may "IAIK" appear in their name, without prior
# written permission of Graz University of Technology.
# 
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE LICENSOR BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY  OF SUCH DAMAGE.
module Sun::Security::Pkcs11::Wrapper
  module CK_ATTRIBUTEImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # class CK_ATTRIBUTE includes the type, value and length of an attribute.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_ATTRIBUTE {&nbsp;&nbsp;
  # CK_ATTRIBUTE_TYPE type;&nbsp;&nbsp;
  # CK_VOID_PTR pValue;&nbsp;&nbsp;
  # CK_ULONG ulValueLen;
  # } CK_ATTRIBUTE;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_ATTRIBUTE 
    include_class_members CK_ATTRIBUTEImports
    
    class_module.module_eval {
      # common attributes
      # NOTE that CK_ATTRIBUTE is a mutable classes but these attributes
      # *MUST NEVER* be modified, e.g. by using them in a
      # C_GetAttributeValue() call!
      const_set_lazy(:TOKEN_FALSE) { CK_ATTRIBUTE.new(CKA_TOKEN, false) }
      const_attr_reader  :TOKEN_FALSE
      
      const_set_lazy(:SENSITIVE_FALSE) { CK_ATTRIBUTE.new(CKA_SENSITIVE, false) }
      const_attr_reader  :SENSITIVE_FALSE
      
      const_set_lazy(:EXTRACTABLE_TRUE) { CK_ATTRIBUTE.new(CKA_EXTRACTABLE, true) }
      const_attr_reader  :EXTRACTABLE_TRUE
      
      const_set_lazy(:ENCRYPT_TRUE) { CK_ATTRIBUTE.new(CKA_ENCRYPT, true) }
      const_attr_reader  :ENCRYPT_TRUE
      
      const_set_lazy(:DECRYPT_TRUE) { CK_ATTRIBUTE.new(CKA_DECRYPT, true) }
      const_attr_reader  :DECRYPT_TRUE
      
      const_set_lazy(:WRAP_TRUE) { CK_ATTRIBUTE.new(CKA_WRAP, true) }
      const_attr_reader  :WRAP_TRUE
      
      const_set_lazy(:UNWRAP_TRUE) { CK_ATTRIBUTE.new(CKA_UNWRAP, true) }
      const_attr_reader  :UNWRAP_TRUE
      
      const_set_lazy(:SIGN_TRUE) { CK_ATTRIBUTE.new(CKA_SIGN, true) }
      const_attr_reader  :SIGN_TRUE
      
      const_set_lazy(:VERIFY_TRUE) { CK_ATTRIBUTE.new(CKA_VERIFY, true) }
      const_attr_reader  :VERIFY_TRUE
      
      const_set_lazy(:SIGN_RECOVER_TRUE) { CK_ATTRIBUTE.new(CKA_SIGN_RECOVER, true) }
      const_attr_reader  :SIGN_RECOVER_TRUE
      
      const_set_lazy(:VERIFY_RECOVER_TRUE) { CK_ATTRIBUTE.new(CKA_VERIFY_RECOVER, true) }
      const_attr_reader  :VERIFY_RECOVER_TRUE
      
      const_set_lazy(:DERIVE_TRUE) { CK_ATTRIBUTE.new(CKA_DERIVE, true) }
      const_attr_reader  :DERIVE_TRUE
      
      const_set_lazy(:ENCRYPT_NULL) { CK_ATTRIBUTE.new(CKA_ENCRYPT) }
      const_attr_reader  :ENCRYPT_NULL
      
      const_set_lazy(:DECRYPT_NULL) { CK_ATTRIBUTE.new(CKA_DECRYPT) }
      const_attr_reader  :DECRYPT_NULL
      
      const_set_lazy(:WRAP_NULL) { CK_ATTRIBUTE.new(CKA_WRAP) }
      const_attr_reader  :WRAP_NULL
      
      const_set_lazy(:UNWRAP_NULL) { CK_ATTRIBUTE.new(CKA_UNWRAP) }
      const_attr_reader  :UNWRAP_NULL
    }
    
    typesig { [] }
    def initialize
      @type = 0
      @p_value = nil
      # empty
    end
    
    typesig { [::Java::Long] }
    def initialize(type)
      @type = 0
      @p_value = nil
      @type = type
    end
    
    typesig { [::Java::Long, Object] }
    def initialize(type, p_value)
      @type = 0
      @p_value = nil
      @type = type
      @p_value = p_value
    end
    
    typesig { [::Java::Long, ::Java::Boolean] }
    def initialize(type, value)
      @type = 0
      @p_value = nil
      @type = type
      @p_value = Boolean.value_of(value)
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    def initialize(type, value)
      @type = 0
      @p_value = nil
      @type = type
      @p_value = Long.value_of(value)
    end
    
    typesig { [::Java::Long, BigInteger] }
    def initialize(type, value)
      @type = 0
      @p_value = nil
      @type = type
      @p_value = Sun::Security::Pkcs11::P11Util.get_magnitude(value)
    end
    
    typesig { [] }
    def get_big_integer
      if ((@p_value.is_a?(Array.typed(::Java::Byte))).equal?(false))
        raise RuntimeException.new("Not a byte[]")
      end
      return BigInteger.new(1, @p_value)
    end
    
    typesig { [] }
    def get_boolean
      if ((@p_value.is_a?(Boolean)).equal?(false))
        raise RuntimeException.new("Not a Boolean: " + (@p_value.get_class.get_name).to_s)
      end
      return (@p_value).boolean_value
    end
    
    typesig { [] }
    def get_char_array
      if ((@p_value.is_a?(Array.typed(::Java::Char))).equal?(false))
        raise RuntimeException.new("Not a char[]")
      end
      return @p_value
    end
    
    typesig { [] }
    def get_byte_array
      if ((@p_value.is_a?(Array.typed(::Java::Byte))).equal?(false))
        raise RuntimeException.new("Not a byte[]")
      end
      return @p_value
    end
    
    typesig { [] }
    def get_long
      if ((@p_value.is_a?(Long)).equal?(false))
        raise RuntimeException.new("Not a Long: " + (@p_value.get_class.get_name).to_s)
      end
      return (@p_value).long_value
    end
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ATTRIBUTE_TYPE type;
    # </PRE>
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VOID_PTR pValue;
    # CK_ULONG ulValueLen;
    # </PRE>
    attr_accessor :p_value
    alias_method :attr_p_value, :p_value
    undef_method :p_value
    alias_method :attr_p_value=, :p_value=
    undef_method :p_value=
    
    typesig { [] }
    # Returns the string representation of CK_ATTRIBUTE.
    # 
    # @return the string representation of CK_ATTRIBUTE
    def to_s
      prefix = (Functions.get_attribute_name(@type)).to_s + " = "
      if ((@type).equal?(CKA_CLASS))
        return prefix + (Functions.get_object_class_name(get_long)).to_s
      else
        if ((@type).equal?(CKA_KEY_TYPE))
          return prefix + (Functions.get_key_name(get_long)).to_s
        else
          s = nil
          if (@p_value.is_a?(Array.typed(::Java::Char)))
            s = (String.new(@p_value)).to_s
          else
            if (@p_value.is_a?(Array.typed(::Java::Byte)))
              s = (Functions.to_hex_string(@p_value)).to_s
            else
              s = (String.value_of(@p_value)).to_s
            end
          end
          return prefix + s
        end
      end
    end
    
    private
    alias_method :initialize__ck_attribute, :initialize
  end
  
end
