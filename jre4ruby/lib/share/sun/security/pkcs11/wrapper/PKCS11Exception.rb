require "rjava"

# Portions Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PKCS11ExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
      include ::Java::Util
    }
  end
  
  # This is the superclass of all checked exceptions used by this package. An
  # exception of this class indicates that a function call to the underlying
  # PKCS#11 module returned a value not equal to CKR_OK. The application can get
  # the returned value by calling getErrorCode(). A return value not equal to
  # CKR_OK is the only reason for such an exception to be thrown.
  # PKCS#11 defines the meaning of an error-code, which may depend on the
  # context in which the error occurs.
  # 
  # @author <a href="mailto:Karl.Scheibelhofer@iaik.at"> Karl Scheibelhofer </a>
  # @invariants
  class PKCS11Exception < PKCS11ExceptionImports.const_get :JavaException
    include_class_members PKCS11ExceptionImports
    
    # The code of the error which was the reason for this exception.
    attr_accessor :error_code_
    alias_method :attr_error_code_, :error_code_
    undef_method :error_code_
    alias_method :attr_error_code_=, :error_code_=
    undef_method :error_code_=
    
    class_module.module_eval {
      when_class_loaded do
        error_codes = Array.typed(::Java::Int).new([0x0, 0x1, 0x2, 0x3, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x30, 0x31, 0x32, 0x40, 0x41, 0x50, 0x51, 0x54, 0x60, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x70, 0x71, 0x82, 0x90, 0x91, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xb0, 0xb1, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xc0, 0xc1, 0xd0, 0xd1, 0xe0, 0xe1, 0xe2, 0xf0, 0xf1, 0xf2, 0x100, 0x101, 0x102, 0x103, 0x104, 0x105, 0x110, 0x112, 0x113, 0x114, 0x115, 0x120, 0x121, 0x150, 0x160, 0x170, 0x180, 0x190, 0x191, 0x1a0, 0x1a1, -0x80000000, ])
        error_messages = Array.typed(String).new(["CKR_OK", "CKR_CANCEL", "CKR_HOST_MEMORY", "CKR_SLOT_ID_INVALID", "CKR_GENERAL_ERROR", "CKR_FUNCTION_FAILED", "CKR_ARGUMENTS_BAD", "CKR_NO_EVENT", "CKR_NEED_TO_CREATE_THREADS", "CKR_CANT_LOCK", "CKR_ATTRIBUTE_READ_ONLY", "CKR_ATTRIBUTE_SENSITIVE", "CKR_ATTRIBUTE_TYPE_INVALID", "CKR_ATTRIBUTE_VALUE_INVALID", "CKR_DATA_INVALID", "CKR_DATA_LEN_RANGE", "CKR_DEVICE_ERROR", "CKR_DEVICE_MEMORY", "CKR_DEVICE_REMOVED", "CKR_ENCRYPTED_DATA_INVALID", "CKR_ENCRYPTED_DATA_LEN_RANGE", "CKR_FUNCTION_CANCELED", "CKR_FUNCTION_NOT_PARALLEL", "CKR_FUNCTION_NOT_SUPPORTED", "CKR_KEY_HANDLE_INVALID", "CKR_KEY_SIZE_RANGE", "CKR_KEY_TYPE_INCONSISTENT", "CKR_KEY_NOT_NEEDED", "CKR_KEY_CHANGED", "CKR_KEY_NEEDED", "CKR_KEY_INDIGESTIBLE", "CKR_KEY_FUNCTION_NOT_PERMITTED", "CKR_KEY_NOT_WRAPPABLE", "CKR_KEY_UNEXTRACTABLE", "CKR_MECHANISM_INVALID", "CKR_MECHANISM_PARAM_INVALID", "CKR_OBJECT_HANDLE_INVALID", "CKR_OPERATION_ACTIVE", "CKR_OPERATION_NOT_INITIALIZED", "CKR_PIN_INCORRECT", "CKR_PIN_INVALID", "CKR_PIN_LEN_RANGE", "CKR_PIN_EXPIRED", "CKR_PIN_LOCKED", "CKR_SESSION_CLOSED", "CKR_SESSION_COUNT", "CKR_SESSION_HANDLE_INVALID", "CKR_SESSION_PARALLEL_NOT_SUPPORTED", "CKR_SESSION_READ_ONLY", "CKR_SESSION_EXISTS", "CKR_SESSION_READ_ONLY_EXISTS", "CKR_SESSION_READ_WRITE_SO_EXISTS", "CKR_SIGNATURE_INVALID", "CKR_SIGNATURE_LEN_RANGE", "CKR_TEMPLATE_INCOMPLETE", "CKR_TEMPLATE_INCONSISTENT", "CKR_TOKEN_NOT_PRESENT", "CKR_TOKEN_NOT_RECOGNIZED", "CKR_TOKEN_WRITE_PROTECTED", "CKR_UNWRAPPING_KEY_HANDLE_INVALID", "CKR_UNWRAPPING_KEY_SIZE_RANGE", "CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT", "CKR_USER_ALREADY_LOGGED_IN", "CKR_USER_NOT_LOGGED_IN", "CKR_USER_PIN_NOT_INITIALIZED", "CKR_USER_TYPE_INVALID", "CKR_USER_ANOTHER_ALREADY_LOGGED_IN", "CKR_USER_TOO_MANY_TYPES", "CKR_WRAPPED_KEY_INVALID", "CKR_WRAPPED_KEY_LEN_RANGE", "CKR_WRAPPING_KEY_HANDLE_INVALID", "CKR_WRAPPING_KEY_SIZE_RANGE", "CKR_WRAPPING_KEY_TYPE_INCONSISTENT", "CKR_RANDOM_SEED_NOT_SUPPORTED", "CKR_RANDOM_NO_RNG", "CKR_BUFFER_TOO_SMALL", "CKR_SAVED_STATE_INVALID", "CKR_INFORMATION_SENSITIVE", "CKR_STATE_UNSAVEABLE", "CKR_CRYPTOKI_NOT_INITIALIZED", "CKR_CRYPTOKI_ALREADY_INITIALIZED", "CKR_MUTEX_BAD", "CKR_MUTEX_NOT_LOCKED", "CKR_VENDOR_DEFINED", ])
        const_set :ErrorMap, HashMap.new
        i = 0
        while i < error_codes.attr_length
          ErrorMap.put(Long.value_of(error_codes[i]), error_messages[i])
          i += 1
        end
      end
    }
    
    typesig { [::Java::Long] }
    # Constructor taking the error code as defined for the CKR_* constants
    # in PKCS#11.
    def initialize(error_code)
      @error_code_ = 0
      super()
      @error_code_ = error_code
    end
    
    typesig { [] }
    # This method gets the corresponding text error message from
    # a property file. If this file is not available, it returns the error
    # code as a hex-string.
    # 
    # @return The message or the error code; e.g. "CKR_DEVICE_ERROR" or
    # "0x00000030".
    # @preconditions
    # @postconditions (result <> null)
    def get_message
      message = ErrorMap.get(Long.value_of(@error_code_))
      if ((message).nil?)
        message = "0x" + RJava.cast_to_string(Functions.to_full_hex_string(RJava.cast_to_int(@error_code_)))
      end
      return message
    end
    
    typesig { [] }
    # Returns the PKCS#11 error code.
    # 
    # @return The error code; e.g. 0x00000030.
    # @preconditions
    # @postconditions
    def get_error_code
      return @error_code_
    end
    
    private
    alias_method :initialize__pkcs11exception, :initialize
  end
  
end
