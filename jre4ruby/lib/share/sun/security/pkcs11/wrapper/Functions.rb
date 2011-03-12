require "rjava"
 # * Portions Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
# Copyright  (c) 2002 Graz University of Technology. All rights reserved.
# 
# Redistribution and use in  source and binary forms, with or without
# modification, are permitted  provided that the following conditions are met:
# 
# 1. Redistributions of  source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 
# 2. Redistributions in  binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# 3. The end-user documentation included with the redistribution, if any, must
#    include the following acknowledgment:
# 
#    "This product includes software developed by IAIK of Graz University of
#     Technology."
# 
#    Alternately, this acknowledgment may appear in the software itself, if
#    and wherever such third-party acknowledgments normally appear.
# 
# 4. The names "Graz University of Technology" and "IAIK of Graz University of
#    Technology" must not be used to endorse or promote products derived from
#    this software without prior written permission.
# 
# 5. Products derived from this software may not be called
#    "IAIK PKCS Wrapper", nor may "IAIK" appear in their name, without prior
#    written permission of Graz University of Technology.
# 
#  THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE LICENSOR BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
#  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
#  OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY  OF SUCH DAMAGE.
module Sun::Security::Pkcs11::Wrapper
  module FunctionsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
    }
  end
  
  # This class contains onyl static methods. It is the place for all functions
  # that are used by several classes in this package.
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class Functions 
    include_class_members FunctionsImports
    
    class_module.module_eval {
      # maps between ids and their names, forward and reverse
      # ids are stored as Integers to save space
      # since only the lower 32 bits are ever used anyway
      # mechanisms (CKM_*)
      const_set_lazy(:MechNames) { HashMap.new }
      const_attr_reader  :MechNames
      
      const_set_lazy(:MechIds) { HashMap.new }
      const_attr_reader  :MechIds
      
      # key types (CKK_*)
      const_set_lazy(:KeyNames) { HashMap.new }
      const_attr_reader  :KeyNames
      
      const_set_lazy(:KeyIds) { HashMap.new }
      const_attr_reader  :KeyIds
      
      # attributes (CKA_*)
      const_set_lazy(:AttributeNames) { HashMap.new }
      const_attr_reader  :AttributeNames
      
      const_set_lazy(:AttributeIds) { HashMap.new }
      const_attr_reader  :AttributeIds
      
      # object classes (CKO_*)
      const_set_lazy(:ObjectClassNames) { HashMap.new }
      const_attr_reader  :ObjectClassNames
      
      const_set_lazy(:ObjectClassIds) { HashMap.new }
      const_attr_reader  :ObjectClassIds
      
      # For converting numbers to their hex presentation.
      const_set_lazy(:HEX_DIGITS) { "0123456789ABCDEF".to_char_array }
      const_attr_reader  :HEX_DIGITS
      
      typesig { [::Java::Long] }
      # Converts a long value to a hexadecimal String of length 16. Includes
      # leading zeros if necessary.
      # 
      # @param value The long value to be converted.
      # @return The hexadecimal string representation of the long value.
      def to_full_hex_string(value)
        current_value = value
        string_buffer = StringBuffer.new(16)
        j = 0
        while j < 16
          current_digit = (current_value).to_int & 0xf
          string_buffer.append(HEX_DIGITS[current_digit])
          current_value >>= 4
          j += 1
        end
        return string_buffer.reverse.to_s
      end
      
      typesig { [::Java::Int] }
      # Converts a int value to a hexadecimal String of length 8. Includes
      # leading zeros if necessary.
      # 
      # @param value The int value to be converted.
      # @return The hexadecimal string representation of the int value.
      def to_full_hex_string(value)
        current_value = value
        string_buffer = StringBuffer.new(8)
        i = 0
        while i < 8
          current_digit = current_value & 0xf
          string_buffer.append(HEX_DIGITS[current_digit])
          current_value >>= 4
          i += 1
        end
        return string_buffer.reverse.to_s
      end
      
      typesig { [::Java::Long] }
      # converts a long value to a hexadecimal String
      # 
      # @param value the long value to be converted
      # @return the hexadecimal string representation of the long value
      def to_hex_string(value)
        return Long.to_hex_string(value)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Converts a byte array to a hexadecimal String. Each byte is presented by
      # its two digit hex-code; 0x0A -> "0a", 0x00 -> "00". No leading "0x" is
      # included in the result.
      # 
      # @param value the byte array to be converted
      # @return the hexadecimal string representation of the byte array
      def to_hex_string(value)
        if ((value).nil?)
          return nil
        end
        buffer = StringBuffer.new(2 * value.attr_length)
        single = 0
        i = 0
        while i < value.attr_length
          single = value[i] & 0xff
          if (single < 0x10)
            buffer.append(Character.new(?0.ord))
          end
          buffer.append(JavaInteger.to_s(single, 16))
          i += 1
        end
        return buffer.to_s
      end
      
      typesig { [::Java::Long] }
      # converts a long value to a binary String
      # 
      # @param value the long value to be converted
      # @return the binary string representation of the long value
      def to_binary_string(value)
        return Long.to_s(value, 2)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # converts a byte array to a binary String
      # 
      # @param value the byte array to be converted
      # @return the binary string representation of the byte array
      def to_binary_string(value)
        help_big_integer = BigInteger.new(1, value)
        return help_big_integer.to_s(2)
      end
      
      const_set_lazy(:Flags) { Class.new do
        include_class_members Functions
        
        attr_accessor :flag_ids
        alias_method :attr_flag_ids, :flag_ids
        undef_method :flag_ids
        alias_method :attr_flag_ids=, :flag_ids=
        undef_method :flag_ids=
        
        attr_accessor :flag_names
        alias_method :attr_flag_names, :flag_names
        undef_method :flag_names
        alias_method :attr_flag_names=, :flag_names=
        undef_method :flag_names=
        
        typesig { [Array.typed(::Java::Long), Array.typed(String)] }
        def initialize(flag_ids, flag_names)
          @flag_ids = nil
          @flag_names = nil
          if (!(flag_ids.attr_length).equal?(flag_names.attr_length))
            raise self.class::AssertionError.new("Array lengths do not match")
          end
          @flag_ids = flag_ids
          @flag_names = flag_names
        end
        
        typesig { [::Java::Long] }
        def to_s(val)
          sb = self.class::StringBuilder.new
          first = true
          i = 0
          while i < @flag_ids.attr_length
            if (!((val & @flag_ids[i])).equal?(0))
              if ((first).equal?(false))
                sb.append(" | ")
              end
              sb.append(@flag_names[i])
              first = false
            end
            i += 1
          end
          return sb.to_s
        end
        
        private
        alias_method :initialize__flags, :initialize
      end }
      
      const_set_lazy(:SlotInfoFlags) { Flags.new(Array.typed(::Java::Long).new([CKF_TOKEN_PRESENT, CKF_REMOVABLE_DEVICE, CKF_HW_SLOT]), Array.typed(String).new(["CKF_TOKEN_PRESENT", "CKF_REMOVABLE_DEVICE", "CKF_HW_SLOT"])) }
      const_attr_reader  :SlotInfoFlags
      
      typesig { [::Java::Long] }
      # converts the long value flags to a SlotInfoFlag string
      # 
      # @param flags the flags to be converted
      # @return the SlotInfoFlag string representation of the flags
      def slot_info_flags_to_string(flags)
        return SlotInfoFlags.to_s(flags)
      end
      
      const_set_lazy(:TokenInfoFlags) { Flags.new(Array.typed(::Java::Long).new([CKF_RNG, CKF_WRITE_PROTECTED, CKF_LOGIN_REQUIRED, CKF_USER_PIN_INITIALIZED, CKF_RESTORE_KEY_NOT_NEEDED, CKF_CLOCK_ON_TOKEN, CKF_PROTECTED_AUTHENTICATION_PATH, CKF_DUAL_CRYPTO_OPERATIONS, CKF_TOKEN_INITIALIZED, CKF_SECONDARY_AUTHENTICATION, CKF_USER_PIN_COUNT_LOW, CKF_USER_PIN_FINAL_TRY, CKF_USER_PIN_LOCKED, CKF_USER_PIN_TO_BE_CHANGED, CKF_SO_PIN_COUNT_LOW, CKF_SO_PIN_FINAL_TRY, CKF_SO_PIN_LOCKED, CKF_SO_PIN_TO_BE_CHANGED]), Array.typed(String).new(["CKF_RNG", "CKF_WRITE_PROTECTED", "CKF_LOGIN_REQUIRED", "CKF_USER_PIN_INITIALIZED", "CKF_RESTORE_KEY_NOT_NEEDED", "CKF_CLOCK_ON_TOKEN", "CKF_PROTECTED_AUTHENTICATION_PATH", "CKF_DUAL_CRYPTO_OPERATIONS", "CKF_TOKEN_INITIALIZED", "CKF_SECONDARY_AUTHENTICATION", "CKF_USER_PIN_COUNT_LOW", "CKF_USER_PIN_FINAL_TRY", "CKF_USER_PIN_LOCKED", "CKF_USER_PIN_TO_BE_CHANGED", "CKF_SO_PIN_COUNT_LOW", "CKF_SO_PIN_FINAL_TRY", "CKF_SO_PIN_LOCKED", "CKF_SO_PIN_TO_BE_CHANGED"])) }
      const_attr_reader  :TokenInfoFlags
      
      typesig { [::Java::Long] }
      # converts long value flags to a TokenInfoFlag string
      # 
      # @param flags the flags to be converted
      # @return the TokenInfoFlag string representation of the flags
      def token_info_flags_to_string(flags)
        return TokenInfoFlags.to_s(flags)
      end
      
      const_set_lazy(:SessionInfoFlags) { Flags.new(Array.typed(::Java::Long).new([CKF_RW_SESSION, CKF_SERIAL_SESSION]), Array.typed(String).new(["CKF_RW_SESSION", "CKF_SERIAL_SESSION"])) }
      const_attr_reader  :SessionInfoFlags
      
      typesig { [::Java::Long] }
      # converts the long value flags to a SessionInfoFlag string
      # 
      # @param flags the flags to be converted
      # @return the SessionInfoFlag string representation of the flags
      def session_info_flags_to_string(flags)
        return SessionInfoFlags.to_s(flags)
      end
      
      typesig { [::Java::Long] }
      # converts the long value state to a SessionState string
      # 
      # @param state the state to be converted
      # @return the SessionState string representation of the state
      def session_state_to_string(state)
        name = nil
        if ((state).equal?(CKS_RO_PUBLIC_SESSION))
          name = "CKS_RO_PUBLIC_SESSION"
        else
          if ((state).equal?(CKS_RO_USER_FUNCTIONS))
            name = "CKS_RO_USER_FUNCTIONS"
          else
            if ((state).equal?(CKS_RW_PUBLIC_SESSION))
              name = "CKS_RW_PUBLIC_SESSION"
            else
              if ((state).equal?(CKS_RW_USER_FUNCTIONS))
                name = "CKS_RW_USER_FUNCTIONS"
              else
                if ((state).equal?(CKS_RW_SO_FUNCTIONS))
                  name = "CKS_RW_SO_FUNCTIONS"
                else
                  name = "ERROR: unknown session state 0x" + RJava.cast_to_string(to_full_hex_string(state))
                end
              end
            end
          end
        end
        return name
      end
      
      const_set_lazy(:MechanismInfoFlags) { Flags.new(Array.typed(::Java::Long).new([CKF_HW, CKF_ENCRYPT, CKF_DECRYPT, CKF_DIGEST, CKF_SIGN, CKF_SIGN_RECOVER, CKF_VERIFY, CKF_VERIFY_RECOVER, CKF_GENERATE, CKF_GENERATE_KEY_PAIR, CKF_WRAP, CKF_UNWRAP, CKF_DERIVE, CKF_EC_F_P, CKF_EC_F_2M, CKF_EC_ECPARAMETERS, CKF_EC_NAMEDCURVE, CKF_EC_UNCOMPRESS, CKF_EC_COMPRESS, CKF_EXTENSION]), Array.typed(String).new(["CKF_HW", "CKF_ENCRYPT", "CKF_DECRYPT", "CKF_DIGEST", "CKF_SIGN", "CKF_SIGN_RECOVER", "CKF_VERIFY", "CKF_VERIFY_RECOVER", "CKF_GENERATE", "CKF_GENERATE_KEY_PAIR", "CKF_WRAP", "CKF_UNWRAP", "CKF_DERIVE", "CKF_EC_F_P", "CKF_EC_F_2M", "CKF_EC_ECPARAMETERS", "CKF_EC_NAMEDCURVE", "CKF_EC_UNCOMPRESS", "CKF_EC_COMPRESS", "CKF_EXTENSION"])) }
      const_attr_reader  :MechanismInfoFlags
      
      typesig { [::Java::Long] }
      # converts the long value flags to a MechanismInfoFlag string
      # 
      # @param flags the flags to be converted
      # @return the MechanismInfoFlag string representation of the flags
      def mechanism_info_flags_to_string(flags)
        return MechanismInfoFlags.to_s(flags)
      end
      
      typesig { [Map, ::Java::Long] }
      def get_name(name_map, id)
        name = nil
        if (((id >> 32)).equal?(0))
          name = RJava.cast_to_string(name_map.get(JavaInteger.value_of((id).to_int)))
        end
        if ((name).nil?)
          name = "Unknown 0x" + RJava.cast_to_string(to_full_hex_string(id))
        end
        return name
      end
      
      typesig { [Map, String] }
      def get_id(id_map, name)
        mech = id_map.get(name)
        if ((mech).nil?)
          raise IllegalArgumentException.new("Unknown name " + name)
        end
        return mech.int_value & 0xffffffff
      end
      
      typesig { [::Java::Long] }
      def get_mechanism_name(id)
        return get_name(MechNames, id)
      end
      
      typesig { [String] }
      def get_mechanism_id(name)
        return get_id(MechIds, name)
      end
      
      typesig { [::Java::Long] }
      def get_key_name(id)
        return get_name(KeyNames, id)
      end
      
      typesig { [String] }
      def get_key_id(name)
        return get_id(KeyIds, name)
      end
      
      typesig { [::Java::Long] }
      def get_attribute_name(id)
        return get_name(AttributeNames, id)
      end
      
      typesig { [String] }
      def get_attribute_id(name)
        return get_id(AttributeIds, name)
      end
      
      typesig { [::Java::Long] }
      def get_object_class_name(id)
        return get_name(ObjectClassNames, id)
      end
      
      typesig { [String] }
      def get_object_class_id(name)
        return get_id(ObjectClassIds, name)
      end
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Check the given arrays for equalitiy. This method considers both arrays as
      # equal, if both are <code>null</code> or both have the same length and
      # contain exactly the same byte values.
      # 
      # @param array1 The first array.
      # @param array2 The second array.
      # @return True, if both arrays are <code>null</code> or both have the same
      #         length and contain exactly the same byte values. False, otherwise.
      # @preconditions
      # @postconditions
      def ==(array1, array2)
        return Arrays.==(array1, array2)
      end
      
      typesig { [Array.typed(::Java::Char), Array.typed(::Java::Char)] }
      # Check the given arrays for equalitiy. This method considers both arrays as
      # equal, if both are <code>null</code> or both have the same length and
      # contain exactly the same char values.
      # 
      # @param array1 The first array.
      # @param array2 The second array.
      # @return True, if both arrays are <code>null</code> or both have the same
      #         length and contain exactly the same char values. False, otherwise.
      # @preconditions
      # @postconditions
      def ==(array1, array2)
        return Arrays.==(array1, array2)
      end
      
      typesig { [CK_DATE, CK_DATE] }
      # Check the given dates for equalitiy. This method considers both dates as
      # equal, if both are <code>null</code> or both contain exactly the same char
      # values.
      # 
      # @param date1 The first date.
      # @param date2 The second date.
      # @return True, if both dates are <code>null</code> or both contain the same
      #         char values. False, otherwise.
      # @preconditions
      # @postconditions
      def ==(date1, date2)
        equal = false
        if ((date1).equal?(date2))
          equal = true
        else
          if ((!(date1).nil?) && (!(date2).nil?))
            equal = self.==(date1.attr_year, date2.attr_year) && self.==(date1.attr_month, date2.attr_month) && self.==(date1.attr_day, date2.attr_day)
          else
            equal = false
          end
        end
        return equal
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Calculate a hash code for the given byte array.
      # 
      # @param array The byte array.
      # @return A hash code for the given array.
      # @preconditions
      # @postconditions
      def hash_code(array)
        hash = 0
        if (!(array).nil?)
          i = 0
          while (i < 4) && (i < array.attr_length)
            hash ^= (((0xff & array[i])).to_int) << ((i % 4) << 3)
            i += 1
          end
        end
        return hash
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # Calculate a hash code for the given char array.
      # 
      # @param array The char array.
      # @return A hash code for the given array.
      # @preconditions
      # @postconditions
      def hash_code(array)
        hash = 0
        if (!(array).nil?)
          i = 0
          while (i < 4) && (i < array.attr_length)
            hash ^= (((0xffff & array[i])).to_int) << ((i % 2) << 4)
            i += 1
          end
        end
        return hash
      end
      
      typesig { [CK_DATE] }
      # Calculate a hash code for the given date object.
      # 
      # @param date The date object.
      # @return A hash code for the given date.
      # @preconditions
      # @postconditions
      def hash_code(date)
        hash = 0
        if (!(date).nil?)
          if ((date.attr_year.attr_length).equal?(4))
            hash ^= (((0xffff & date.attr_year[0])).to_int) << 16
            hash ^= ((0xffff & date.attr_year[1])).to_int
            hash ^= (((0xffff & date.attr_year[2])).to_int) << 16
            hash ^= ((0xffff & date.attr_year[3])).to_int
          end
          if ((date.attr_month.attr_length).equal?(2))
            hash ^= (((0xffff & date.attr_month[0])).to_int) << 16
            hash ^= ((0xffff & date.attr_month[1])).to_int
          end
          if ((date.attr_day.attr_length).equal?(2))
            hash ^= (((0xffff & date.attr_day[0])).to_int) << 16
            hash ^= ((0xffff & date.attr_day[1])).to_int
          end
        end
        return hash
      end
      
      typesig { [Map, Map, ::Java::Long, String] }
      def add_mapping(name_map, id_map, id, name)
        if (!((id >> 32)).equal?(0))
          raise AssertionError.new("Id has high bits set: " + RJava.cast_to_string(id) + ", " + name)
        end
        int_id = JavaInteger.value_of((id).to_int)
        if (!(name_map.put(int_id, name)).nil?)
          raise AssertionError.new("Duplicate id: " + RJava.cast_to_string(id) + ", " + name)
        end
        if (!(id_map.put(name, int_id)).nil?)
          raise AssertionError.new("Duplicate name: " + RJava.cast_to_string(id) + ", " + name)
        end
      end
      
      typesig { [::Java::Long, String] }
      def add_mech(id, name)
        add_mapping(MechNames, MechIds, id, name)
      end
      
      typesig { [::Java::Long, String] }
      def add_key_type(id, name)
        add_mapping(KeyNames, KeyIds, id, name)
      end
      
      typesig { [::Java::Long, String] }
      def add_attribute(id, name)
        add_mapping(AttributeNames, AttributeIds, id, name)
      end
      
      typesig { [::Java::Long, String] }
      def add_object_class(id, name)
        add_mapping(ObjectClassNames, ObjectClassIds, id, name)
      end
      
      when_class_loaded do
        add_mech(CKM_RSA_PKCS_KEY_PAIR_GEN, "CKM_RSA_PKCS_KEY_PAIR_GEN")
        add_mech(CKM_RSA_PKCS, "CKM_RSA_PKCS")
        add_mech(CKM_RSA_9796, "CKM_RSA_9796")
        add_mech(CKM_RSA_X_509, "CKM_RSA_X_509")
        add_mech(CKM_MD2_RSA_PKCS, "CKM_MD2_RSA_PKCS")
        add_mech(CKM_MD5_RSA_PKCS, "CKM_MD5_RSA_PKCS")
        add_mech(CKM_SHA1_RSA_PKCS, "CKM_SHA1_RSA_PKCS")
        add_mech(CKM_RIPEMD128_RSA_PKCS, "CKM_RIPEMD128_RSA_PKCS")
        add_mech(CKM_RIPEMD160_RSA_PKCS, "CKM_RIPEMD160_RSA_PKCS")
        add_mech(CKM_RSA_PKCS_OAEP, "CKM_RSA_PKCS_OAEP")
        add_mech(CKM_RSA_X9_31_KEY_PAIR_GEN, "CKM_RSA_X9_31_KEY_PAIR_GEN")
        add_mech(CKM_RSA_X9_31, "CKM_RSA_X9_31")
        add_mech(CKM_SHA1_RSA_X9_31, "CKM_SHA1_RSA_X9_31")
        add_mech(CKM_RSA_PKCS_PSS, "CKM_RSA_PKCS_PSS")
        add_mech(CKM_SHA1_RSA_PKCS_PSS, "CKM_SHA1_RSA_PKCS_PSS")
        add_mech(CKM_DSA_KEY_PAIR_GEN, "CKM_DSA_KEY_PAIR_GEN")
        add_mech(CKM_DSA, "CKM_DSA")
        add_mech(CKM_DSA_SHA1, "CKM_DSA_SHA1")
        add_mech(CKM_DH_PKCS_KEY_PAIR_GEN, "CKM_DH_PKCS_KEY_PAIR_GEN")
        add_mech(CKM_DH_PKCS_DERIVE, "CKM_DH_PKCS_DERIVE")
        add_mech(CKM_X9_42_DH_KEY_PAIR_GEN, "CKM_X9_42_DH_KEY_PAIR_GEN")
        add_mech(CKM_X9_42_DH_DERIVE, "CKM_X9_42_DH_DERIVE")
        add_mech(CKM_X9_42_DH_HYBRID_DERIVE, "CKM_X9_42_DH_HYBRID_DERIVE")
        add_mech(CKM_X9_42_MQV_DERIVE, "CKM_X9_42_MQV_DERIVE")
        add_mech(CKM_SHA256_RSA_PKCS, "CKM_SHA256_RSA_PKCS")
        add_mech(CKM_SHA384_RSA_PKCS, "CKM_SHA384_RSA_PKCS")
        add_mech(CKM_SHA512_RSA_PKCS, "CKM_SHA512_RSA_PKCS")
        add_mech(CKM_RC2_KEY_GEN, "CKM_RC2_KEY_GEN")
        add_mech(CKM_RC2_ECB, "CKM_RC2_ECB")
        add_mech(CKM_RC2_CBC, "CKM_RC2_CBC")
        add_mech(CKM_RC2_MAC, "CKM_RC2_MAC")
        add_mech(CKM_RC2_MAC_GENERAL, "CKM_RC2_MAC_GENERAL")
        add_mech(CKM_RC2_CBC_PAD, "CKM_RC2_CBC_PAD")
        add_mech(CKM_RC4_KEY_GEN, "CKM_RC4_KEY_GEN")
        add_mech(CKM_RC4, "CKM_RC4")
        add_mech(CKM_DES_KEY_GEN, "CKM_DES_KEY_GEN")
        add_mech(CKM_DES_ECB, "CKM_DES_ECB")
        add_mech(CKM_DES_CBC, "CKM_DES_CBC")
        add_mech(CKM_DES_MAC, "CKM_DES_MAC")
        add_mech(CKM_DES_MAC_GENERAL, "CKM_DES_MAC_GENERAL")
        add_mech(CKM_DES_CBC_PAD, "CKM_DES_CBC_PAD")
        add_mech(CKM_DES2_KEY_GEN, "CKM_DES2_KEY_GEN")
        add_mech(CKM_DES3_KEY_GEN, "CKM_DES3_KEY_GEN")
        add_mech(CKM_DES3_ECB, "CKM_DES3_ECB")
        add_mech(CKM_DES3_CBC, "CKM_DES3_CBC")
        add_mech(CKM_DES3_MAC, "CKM_DES3_MAC")
        add_mech(CKM_DES3_MAC_GENERAL, "CKM_DES3_MAC_GENERAL")
        add_mech(CKM_DES3_CBC_PAD, "CKM_DES3_CBC_PAD")
        add_mech(CKM_CDMF_KEY_GEN, "CKM_CDMF_KEY_GEN")
        add_mech(CKM_CDMF_ECB, "CKM_CDMF_ECB")
        add_mech(CKM_CDMF_CBC, "CKM_CDMF_CBC")
        add_mech(CKM_CDMF_MAC, "CKM_CDMF_MAC")
        add_mech(CKM_CDMF_MAC_GENERAL, "CKM_CDMF_MAC_GENERAL")
        add_mech(CKM_CDMF_CBC_PAD, "CKM_CDMF_CBC_PAD")
        add_mech(CKM_MD2, "CKM_MD2")
        add_mech(CKM_MD2_HMAC, "CKM_MD2_HMAC")
        add_mech(CKM_MD2_HMAC_GENERAL, "CKM_MD2_HMAC_GENERAL")
        add_mech(CKM_MD5, "CKM_MD5")
        add_mech(CKM_MD5_HMAC, "CKM_MD5_HMAC")
        add_mech(CKM_MD5_HMAC_GENERAL, "CKM_MD5_HMAC_GENERAL")
        add_mech(CKM_SHA_1, "CKM_SHA_1")
        add_mech(CKM_SHA_1_HMAC, "CKM_SHA_1_HMAC")
        add_mech(CKM_SHA_1_HMAC_GENERAL, "CKM_SHA_1_HMAC_GENERAL")
        add_mech(CKM_RIPEMD128, "CKM_RIPEMD128")
        add_mech(CKM_RIPEMD128_HMAC, "CKM_RIPEMD128_HMAC")
        add_mech(CKM_RIPEMD128_HMAC_GENERAL, "CKM_RIPEMD128_HMAC_GENERAL")
        add_mech(CKM_RIPEMD160, "CKM_RIPEMD160")
        add_mech(CKM_RIPEMD160_HMAC, "CKM_RIPEMD160_HMAC")
        add_mech(CKM_RIPEMD160_HMAC_GENERAL, "CKM_RIPEMD160_HMAC_GENERAL")
        add_mech(CKM_SHA256, "CKM_SHA256")
        add_mech(CKM_SHA256_HMAC, "CKM_SHA256_HMAC")
        add_mech(CKM_SHA256_HMAC_GENERAL, "CKM_SHA256_HMAC_GENERAL")
        add_mech(CKM_SHA384, "CKM_SHA384")
        add_mech(CKM_SHA384_HMAC, "CKM_SHA384_HMAC")
        add_mech(CKM_SHA384_HMAC_GENERAL, "CKM_SHA384_HMAC_GENERAL")
        add_mech(CKM_SHA512, "CKM_SHA512")
        add_mech(CKM_SHA512_HMAC, "CKM_SHA512_HMAC")
        add_mech(CKM_SHA512_HMAC_GENERAL, "CKM_SHA512_HMAC_GENERAL")
        add_mech(CKM_CAST_KEY_GEN, "CKM_CAST_KEY_GEN")
        add_mech(CKM_CAST_ECB, "CKM_CAST_ECB")
        add_mech(CKM_CAST_CBC, "CKM_CAST_CBC")
        add_mech(CKM_CAST_MAC, "CKM_CAST_MAC")
        add_mech(CKM_CAST_MAC_GENERAL, "CKM_CAST_MAC_GENERAL")
        add_mech(CKM_CAST_CBC_PAD, "CKM_CAST_CBC_PAD")
        add_mech(CKM_CAST3_KEY_GEN, "CKM_CAST3_KEY_GEN")
        add_mech(CKM_CAST3_ECB, "CKM_CAST3_ECB")
        add_mech(CKM_CAST3_CBC, "CKM_CAST3_CBC")
        add_mech(CKM_CAST3_MAC, "CKM_CAST3_MAC")
        add_mech(CKM_CAST3_MAC_GENERAL, "CKM_CAST3_MAC_GENERAL")
        add_mech(CKM_CAST3_CBC_PAD, "CKM_CAST3_CBC_PAD")
        add_mech(CKM_CAST128_KEY_GEN, "CKM_CAST128_KEY_GEN")
        add_mech(CKM_CAST128_ECB, "CKM_CAST128_ECB")
        add_mech(CKM_CAST128_CBC, "CKM_CAST128_CBC")
        add_mech(CKM_CAST128_MAC, "CKM_CAST128_MAC")
        add_mech(CKM_CAST128_MAC_GENERAL, "CKM_CAST128_MAC_GENERAL")
        add_mech(CKM_CAST128_CBC_PAD, "CKM_CAST128_CBC_PAD")
        add_mech(CKM_RC5_KEY_GEN, "CKM_RC5_KEY_GEN")
        add_mech(CKM_RC5_ECB, "CKM_RC5_ECB")
        add_mech(CKM_RC5_CBC, "CKM_RC5_CBC")
        add_mech(CKM_RC5_MAC, "CKM_RC5_MAC")
        add_mech(CKM_RC5_MAC_GENERAL, "CKM_RC5_MAC_GENERAL")
        add_mech(CKM_RC5_CBC_PAD, "CKM_RC5_CBC_PAD")
        add_mech(CKM_IDEA_KEY_GEN, "CKM_IDEA_KEY_GEN")
        add_mech(CKM_IDEA_ECB, "CKM_IDEA_ECB")
        add_mech(CKM_IDEA_CBC, "CKM_IDEA_CBC")
        add_mech(CKM_IDEA_MAC, "CKM_IDEA_MAC")
        add_mech(CKM_IDEA_MAC_GENERAL, "CKM_IDEA_MAC_GENERAL")
        add_mech(CKM_IDEA_CBC_PAD, "CKM_IDEA_CBC_PAD")
        add_mech(CKM_GENERIC_SECRET_KEY_GEN, "CKM_GENERIC_SECRET_KEY_GEN")
        add_mech(CKM_CONCATENATE_BASE_AND_KEY, "CKM_CONCATENATE_BASE_AND_KEY")
        add_mech(CKM_CONCATENATE_BASE_AND_DATA, "CKM_CONCATENATE_BASE_AND_DATA")
        add_mech(CKM_CONCATENATE_DATA_AND_BASE, "CKM_CONCATENATE_DATA_AND_BASE")
        add_mech(CKM_XOR_BASE_AND_DATA, "CKM_XOR_BASE_AND_DATA")
        add_mech(CKM_EXTRACT_KEY_FROM_KEY, "CKM_EXTRACT_KEY_FROM_KEY")
        add_mech(CKM_SSL3_PRE_MASTER_KEY_GEN, "CKM_SSL3_PRE_MASTER_KEY_GEN")
        add_mech(CKM_SSL3_MASTER_KEY_DERIVE, "CKM_SSL3_MASTER_KEY_DERIVE")
        add_mech(CKM_SSL3_KEY_AND_MAC_DERIVE, "CKM_SSL3_KEY_AND_MAC_DERIVE")
        add_mech(CKM_SSL3_MASTER_KEY_DERIVE_DH, "CKM_SSL3_MASTER_KEY_DERIVE_DH")
        add_mech(CKM_TLS_PRE_MASTER_KEY_GEN, "CKM_TLS_PRE_MASTER_KEY_GEN")
        add_mech(CKM_TLS_MASTER_KEY_DERIVE, "CKM_TLS_MASTER_KEY_DERIVE")
        add_mech(CKM_TLS_KEY_AND_MAC_DERIVE, "CKM_TLS_KEY_AND_MAC_DERIVE")
        add_mech(CKM_TLS_MASTER_KEY_DERIVE_DH, "CKM_TLS_MASTER_KEY_DERIVE_DH")
        add_mech(CKM_TLS_PRF, "CKM_TLS_PRF")
        add_mech(CKM_SSL3_MD5_MAC, "CKM_SSL3_MD5_MAC")
        add_mech(CKM_SSL3_SHA1_MAC, "CKM_SSL3_SHA1_MAC")
        add_mech(CKM_MD5_KEY_DERIVATION, "CKM_MD5_KEY_DERIVATION")
        add_mech(CKM_MD2_KEY_DERIVATION, "CKM_MD2_KEY_DERIVATION")
        add_mech(CKM_SHA1_KEY_DERIVATION, "CKM_SHA1_KEY_DERIVATION")
        add_mech(CKM_SHA256_KEY_DERIVATION, "CKM_SHA256_KEY_DERIVATION")
        add_mech(CKM_SHA384_KEY_DERIVATION, "CKM_SHA384_KEY_DERIVATION")
        add_mech(CKM_SHA512_KEY_DERIVATION, "CKM_SHA512_KEY_DERIVATION")
        add_mech(CKM_PBE_MD2_DES_CBC, "CKM_PBE_MD2_DES_CBC")
        add_mech(CKM_PBE_MD5_DES_CBC, "CKM_PBE_MD5_DES_CBC")
        add_mech(CKM_PBE_MD5_CAST_CBC, "CKM_PBE_MD5_CAST_CBC")
        add_mech(CKM_PBE_MD5_CAST3_CBC, "CKM_PBE_MD5_CAST3_CBC")
        add_mech(CKM_PBE_MD5_CAST128_CBC, "CKM_PBE_MD5_CAST128_CBC")
        add_mech(CKM_PBE_SHA1_CAST128_CBC, "CKM_PBE_SHA1_CAST128_CBC")
        add_mech(CKM_PBE_SHA1_RC4_128, "CKM_PBE_SHA1_RC4_128")
        add_mech(CKM_PBE_SHA1_RC4_40, "CKM_PBE_SHA1_RC4_40")
        add_mech(CKM_PBE_SHA1_DES3_EDE_CBC, "CKM_PBE_SHA1_DES3_EDE_CBC")
        add_mech(CKM_PBE_SHA1_DES2_EDE_CBC, "CKM_PBE_SHA1_DES2_EDE_CBC")
        add_mech(CKM_PBE_SHA1_RC2_128_CBC, "CKM_PBE_SHA1_RC2_128_CBC")
        add_mech(CKM_PBE_SHA1_RC2_40_CBC, "CKM_PBE_SHA1_RC2_40_CBC")
        add_mech(CKM_PKCS5_PBKD2, "CKM_PKCS5_PBKD2")
        add_mech(CKM_PBA_SHA1_WITH_SHA1_HMAC, "CKM_PBA_SHA1_WITH_SHA1_HMAC")
        add_mech(CKM_KEY_WRAP_LYNKS, "CKM_KEY_WRAP_LYNKS")
        add_mech(CKM_KEY_WRAP_SET_OAEP, "CKM_KEY_WRAP_SET_OAEP")
        add_mech(CKM_SKIPJACK_KEY_GEN, "CKM_SKIPJACK_KEY_GEN")
        add_mech(CKM_SKIPJACK_ECB64, "CKM_SKIPJACK_ECB64")
        add_mech(CKM_SKIPJACK_CBC64, "CKM_SKIPJACK_CBC64")
        add_mech(CKM_SKIPJACK_OFB64, "CKM_SKIPJACK_OFB64")
        add_mech(CKM_SKIPJACK_CFB64, "CKM_SKIPJACK_CFB64")
        add_mech(CKM_SKIPJACK_CFB32, "CKM_SKIPJACK_CFB32")
        add_mech(CKM_SKIPJACK_CFB16, "CKM_SKIPJACK_CFB16")
        add_mech(CKM_SKIPJACK_CFB8, "CKM_SKIPJACK_CFB8")
        add_mech(CKM_SKIPJACK_WRAP, "CKM_SKIPJACK_WRAP")
        add_mech(CKM_SKIPJACK_PRIVATE_WRAP, "CKM_SKIPJACK_PRIVATE_WRAP")
        add_mech(CKM_SKIPJACK_RELAYX, "CKM_SKIPJACK_RELAYX")
        add_mech(CKM_KEA_KEY_PAIR_GEN, "CKM_KEA_KEY_PAIR_GEN")
        add_mech(CKM_KEA_KEY_DERIVE, "CKM_KEA_KEY_DERIVE")
        add_mech(CKM_FORTEZZA_TIMESTAMP, "CKM_FORTEZZA_TIMESTAMP")
        add_mech(CKM_BATON_KEY_GEN, "CKM_BATON_KEY_GEN")
        add_mech(CKM_BATON_ECB128, "CKM_BATON_ECB128")
        add_mech(CKM_BATON_ECB96, "CKM_BATON_ECB96")
        add_mech(CKM_BATON_CBC128, "CKM_BATON_CBC128")
        add_mech(CKM_BATON_COUNTER, "CKM_BATON_COUNTER")
        add_mech(CKM_BATON_SHUFFLE, "CKM_BATON_SHUFFLE")
        add_mech(CKM_BATON_WRAP, "CKM_BATON_WRAP")
        add_mech(CKM_EC_KEY_PAIR_GEN, "CKM_EC_KEY_PAIR_GEN")
        add_mech(CKM_ECDSA, "CKM_ECDSA")
        add_mech(CKM_ECDSA_SHA1, "CKM_ECDSA_SHA1")
        add_mech(CKM_ECDH1_DERIVE, "CKM_ECDH1_DERIVE")
        add_mech(CKM_ECDH1_COFACTOR_DERIVE, "CKM_ECDH1_COFACTOR_DERIVE")
        add_mech(CKM_ECMQV_DERIVE, "CKM_ECMQV_DERIVE")
        add_mech(CKM_JUNIPER_KEY_GEN, "CKM_JUNIPER_KEY_GEN")
        add_mech(CKM_JUNIPER_ECB128, "CKM_JUNIPER_ECB128")
        add_mech(CKM_JUNIPER_CBC128, "CKM_JUNIPER_CBC128")
        add_mech(CKM_JUNIPER_COUNTER, "CKM_JUNIPER_COUNTER")
        add_mech(CKM_JUNIPER_SHUFFLE, "CKM_JUNIPER_SHUFFLE")
        add_mech(CKM_JUNIPER_WRAP, "CKM_JUNIPER_WRAP")
        add_mech(CKM_FASTHASH, "CKM_FASTHASH")
        add_mech(CKM_AES_KEY_GEN, "CKM_AES_KEY_GEN")
        add_mech(CKM_AES_ECB, "CKM_AES_ECB")
        add_mech(CKM_AES_CBC, "CKM_AES_CBC")
        add_mech(CKM_AES_MAC, "CKM_AES_MAC")
        add_mech(CKM_AES_MAC_GENERAL, "CKM_AES_MAC_GENERAL")
        add_mech(CKM_AES_CBC_PAD, "CKM_AES_CBC_PAD")
        add_mech(CKM_BLOWFISH_KEY_GEN, "CKM_BLOWFISH_KEY_GEN")
        add_mech(CKM_BLOWFISH_CBC, "CKM_BLOWFISH_CBC")
        add_mech(CKM_DSA_PARAMETER_GEN, "CKM_DSA_PARAMETER_GEN")
        add_mech(CKM_DH_PKCS_PARAMETER_GEN, "CKM_DH_PKCS_PARAMETER_GEN")
        add_mech(CKM_X9_42_DH_PARAMETER_GEN, "CKM_X9_42_DH_PARAMETER_GEN")
        add_mech(CKM_VENDOR_DEFINED, "CKM_VENDOR_DEFINED")
        add_mech(CKM_NSS_TLS_PRF_GENERAL, "CKM_NSS_TLS_PRF_GENERAL")
        add_mech(PCKM_SECURERANDOM, "SecureRandom")
        add_mech(PCKM_KEYSTORE, "KeyStore")
        add_key_type(CKK_RSA, "CKK_RSA")
        add_key_type(CKK_DSA, "CKK_DSA")
        add_key_type(CKK_DH, "CKK_DH")
        add_key_type(CKK_EC, "CKK_EC")
        add_key_type(CKK_X9_42_DH, "CKK_X9_42_DH")
        add_key_type(CKK_KEA, "CKK_KEA")
        add_key_type(CKK_GENERIC_SECRET, "CKK_GENERIC_SECRET")
        add_key_type(CKK_RC2, "CKK_RC2")
        add_key_type(CKK_RC4, "CKK_RC4")
        add_key_type(CKK_DES, "CKK_DES")
        add_key_type(CKK_DES2, "CKK_DES2")
        add_key_type(CKK_DES3, "CKK_DES3")
        add_key_type(CKK_CAST, "CKK_CAST")
        add_key_type(CKK_CAST3, "CKK_CAST3")
        add_key_type(CKK_CAST128, "CKK_CAST128")
        add_key_type(CKK_RC5, "CKK_RC5")
        add_key_type(CKK_IDEA, "CKK_IDEA")
        add_key_type(CKK_SKIPJACK, "CKK_SKIPJACK")
        add_key_type(CKK_BATON, "CKK_BATON")
        add_key_type(CKK_JUNIPER, "CKK_JUNIPER")
        add_key_type(CKK_CDMF, "CKK_CDMF")
        add_key_type(CKK_AES, "CKK_AES")
        add_key_type(CKK_BLOWFISH, "CKK_BLOWFISH")
        add_key_type(CKK_VENDOR_DEFINED, "CKK_VENDOR_DEFINED")
        add_key_type(PCKK_ANY, "*")
        add_attribute(CKA_CLASS, "CKA_CLASS")
        add_attribute(CKA_TOKEN, "CKA_TOKEN")
        add_attribute(CKA_PRIVATE, "CKA_PRIVATE")
        add_attribute(CKA_LABEL, "CKA_LABEL")
        add_attribute(CKA_APPLICATION, "CKA_APPLICATION")
        add_attribute(CKA_VALUE, "CKA_VALUE")
        add_attribute(CKA_OBJECT_ID, "CKA_OBJECT_ID")
        add_attribute(CKA_CERTIFICATE_TYPE, "CKA_CERTIFICATE_TYPE")
        add_attribute(CKA_ISSUER, "CKA_ISSUER")
        add_attribute(CKA_SERIAL_NUMBER, "CKA_SERIAL_NUMBER")
        add_attribute(CKA_AC_ISSUER, "CKA_AC_ISSUER")
        add_attribute(CKA_OWNER, "CKA_OWNER")
        add_attribute(CKA_ATTR_TYPES, "CKA_ATTR_TYPES")
        add_attribute(CKA_TRUSTED, "CKA_TRUSTED")
        add_attribute(CKA_KEY_TYPE, "CKA_KEY_TYPE")
        add_attribute(CKA_SUBJECT, "CKA_SUBJECT")
        add_attribute(CKA_ID, "CKA_ID")
        add_attribute(CKA_SENSITIVE, "CKA_SENSITIVE")
        add_attribute(CKA_ENCRYPT, "CKA_ENCRYPT")
        add_attribute(CKA_DECRYPT, "CKA_DECRYPT")
        add_attribute(CKA_WRAP, "CKA_WRAP")
        add_attribute(CKA_UNWRAP, "CKA_UNWRAP")
        add_attribute(CKA_SIGN, "CKA_SIGN")
        add_attribute(CKA_SIGN_RECOVER, "CKA_SIGN_RECOVER")
        add_attribute(CKA_VERIFY, "CKA_VERIFY")
        add_attribute(CKA_VERIFY_RECOVER, "CKA_VERIFY_RECOVER")
        add_attribute(CKA_DERIVE, "CKA_DERIVE")
        add_attribute(CKA_START_DATE, "CKA_START_DATE")
        add_attribute(CKA_END_DATE, "CKA_END_DATE")
        add_attribute(CKA_MODULUS, "CKA_MODULUS")
        add_attribute(CKA_MODULUS_BITS, "CKA_MODULUS_BITS")
        add_attribute(CKA_PUBLIC_EXPONENT, "CKA_PUBLIC_EXPONENT")
        add_attribute(CKA_PRIVATE_EXPONENT, "CKA_PRIVATE_EXPONENT")
        add_attribute(CKA_PRIME_1, "CKA_PRIME_1")
        add_attribute(CKA_PRIME_2, "CKA_PRIME_2")
        add_attribute(CKA_EXPONENT_1, "CKA_EXPONENT_1")
        add_attribute(CKA_EXPONENT_2, "CKA_EXPONENT_2")
        add_attribute(CKA_COEFFICIENT, "CKA_COEFFICIENT")
        add_attribute(CKA_PRIME, "CKA_PRIME")
        add_attribute(CKA_SUBPRIME, "CKA_SUBPRIME")
        add_attribute(CKA_BASE, "CKA_BASE")
        add_attribute(CKA_PRIME_BITS, "CKA_PRIME_BITS")
        add_attribute(CKA_SUB_PRIME_BITS, "CKA_SUB_PRIME_BITS")
        add_attribute(CKA_VALUE_BITS, "CKA_VALUE_BITS")
        add_attribute(CKA_VALUE_LEN, "CKA_VALUE_LEN")
        add_attribute(CKA_EXTRACTABLE, "CKA_EXTRACTABLE")
        add_attribute(CKA_LOCAL, "CKA_LOCAL")
        add_attribute(CKA_NEVER_EXTRACTABLE, "CKA_NEVER_EXTRACTABLE")
        add_attribute(CKA_ALWAYS_SENSITIVE, "CKA_ALWAYS_SENSITIVE")
        add_attribute(CKA_KEY_GEN_MECHANISM, "CKA_KEY_GEN_MECHANISM")
        add_attribute(CKA_MODIFIABLE, "CKA_MODIFIABLE")
        add_attribute(CKA_EC_PARAMS, "CKA_EC_PARAMS")
        add_attribute(CKA_EC_POINT, "CKA_EC_POINT")
        add_attribute(CKA_SECONDARY_AUTH, "CKA_SECONDARY_AUTH")
        add_attribute(CKA_AUTH_PIN_FLAGS, "CKA_AUTH_PIN_FLAGS")
        add_attribute(CKA_HW_FEATURE_TYPE, "CKA_HW_FEATURE_TYPE")
        add_attribute(CKA_RESET_ON_INIT, "CKA_RESET_ON_INIT")
        add_attribute(CKA_HAS_RESET, "CKA_HAS_RESET")
        add_attribute(CKA_VENDOR_DEFINED, "CKA_VENDOR_DEFINED")
        add_attribute(CKA_NETSCAPE_DB, "CKA_NETSCAPE_DB")
        add_attribute(CKA_NETSCAPE_TRUST_SERVER_AUTH, "CKA_NETSCAPE_TRUST_SERVER_AUTH")
        add_attribute(CKA_NETSCAPE_TRUST_CLIENT_AUTH, "CKA_NETSCAPE_TRUST_CLIENT_AUTH")
        add_attribute(CKA_NETSCAPE_TRUST_CODE_SIGNING, "CKA_NETSCAPE_TRUST_CODE_SIGNING")
        add_attribute(CKA_NETSCAPE_TRUST_EMAIL_PROTECTION, "CKA_NETSCAPE_TRUST_EMAIL_PROTECTION")
        add_attribute(CKA_NETSCAPE_CERT_SHA1_HASH, "CKA_NETSCAPE_CERT_SHA1_HASH")
        add_attribute(CKA_NETSCAPE_CERT_MD5_HASH, "CKA_NETSCAPE_CERT_MD5_HASH")
        add_object_class(CKO_DATA, "CKO_DATA")
        add_object_class(CKO_CERTIFICATE, "CKO_CERTIFICATE")
        add_object_class(CKO_PUBLIC_KEY, "CKO_PUBLIC_KEY")
        add_object_class(CKO_PRIVATE_KEY, "CKO_PRIVATE_KEY")
        add_object_class(CKO_SECRET_KEY, "CKO_SECRET_KEY")
        add_object_class(CKO_HW_FEATURE, "CKO_HW_FEATURE")
        add_object_class(CKO_DOMAIN_PARAMETERS, "CKO_DOMAIN_PARAMETERS")
        add_object_class(CKO_VENDOR_DEFINED, "CKO_VENDOR_DEFINED")
        add_object_class(PCKO_ANY, "*")
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__functions, :initialize
  end
  
end
