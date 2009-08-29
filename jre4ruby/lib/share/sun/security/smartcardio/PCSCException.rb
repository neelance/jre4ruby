require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Smartcardio
  module PCSCExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
    }
  end
  
  # Exception for PC/SC errors. The native code portion checks the return value
  # of the SCard* functions. If it indicates an error, the native code constructs
  # an instance of this exception, throws it, and returns to Java.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class PCSCException < PCSCExceptionImports.const_get :JavaException
    include_class_members PCSCExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 4181137171979130432 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :code
    alias_method :attr_code, :code
    undef_method :code
    alias_method :attr_code=, :code=
    undef_method :code=
    
    typesig { [::Java::Int] }
    def initialize(code)
      @code = 0
      super(to_error_string(code))
      @code = code
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def to_error_string(code)
        case (code)
        when SCARD_S_SUCCESS
          return "SCARD_S_SUCCESS"
        when SCARD_E_CANCELLED
          return "SCARD_E_CANCELLED"
        when SCARD_E_CANT_DISPOSE
          return "SCARD_E_CANT_DISPOSE"
        when SCARD_E_INSUFFICIENT_BUFFER
          return "SCARD_E_INSUFFICIENT_BUFFER"
        when SCARD_E_INVALID_ATR
          return "SCARD_E_INVALID_ATR"
        when SCARD_E_INVALID_HANDLE
          return "SCARD_E_INVALID_HANDLE"
        when SCARD_E_INVALID_PARAMETER
          return "SCARD_E_INVALID_PARAMETER"
        when SCARD_E_INVALID_TARGET
          return "SCARD_E_INVALID_TARGET"
        when SCARD_E_INVALID_VALUE
          return "SCARD_E_INVALID_VALUE"
        when SCARD_E_NO_MEMORY
          return "SCARD_E_NO_MEMORY"
        when SCARD_F_COMM_ERROR
          return "SCARD_F_COMM_ERROR"
        when SCARD_F_INTERNAL_ERROR
          return "SCARD_F_INTERNAL_ERROR"
        when SCARD_F_UNKNOWN_ERROR
          return "SCARD_F_UNKNOWN_ERROR"
        when SCARD_F_WAITED_TOO_LONG
          return "SCARD_F_WAITED_TOO_LONG"
        when SCARD_E_UNKNOWN_READER
          return "SCARD_E_UNKNOWN_READER"
        when SCARD_E_TIMEOUT
          return "SCARD_E_TIMEOUT"
        when SCARD_E_SHARING_VIOLATION
          return "SCARD_E_SHARING_VIOLATION"
        when SCARD_E_NO_SMARTCARD
          return "SCARD_E_NO_SMARTCARD"
        when SCARD_E_UNKNOWN_CARD
          return "SCARD_E_UNKNOWN_CARD"
        when SCARD_E_PROTO_MISMATCH
          return "SCARD_E_PROTO_MISMATCH"
        when SCARD_E_NOT_READY
          return "SCARD_E_NOT_READY"
        when SCARD_E_SYSTEM_CANCELLED
          return "SCARD_E_SYSTEM_CANCELLED"
        when SCARD_E_NOT_TRANSACTED
          return "SCARD_E_NOT_TRANSACTED"
        when SCARD_E_READER_UNAVAILABLE
          return "SCARD_E_READER_UNAVAILABLE"
        when SCARD_W_UNSUPPORTED_CARD
          return "SCARD_W_UNSUPPORTED_CARD"
        when SCARD_W_UNRESPONSIVE_CARD
          return "SCARD_W_UNRESPONSIVE_CARD"
        when SCARD_W_UNPOWERED_CARD
          return "SCARD_W_UNPOWERED_CARD"
        when SCARD_W_RESET_CARD
          return "SCARD_W_RESET_CARD"
        when SCARD_W_REMOVED_CARD
          return "SCARD_W_REMOVED_CARD"
        when SCARD_W_INSERTED_CARD
          return "SCARD_W_INSERTED_CARD"
        when SCARD_E_UNSUPPORTED_FEATURE
          return "SCARD_E_UNSUPPORTED_FEATURE"
        when SCARD_E_PCI_TOO_SMALL
          return "SCARD_E_PCI_TOO_SMALL"
        when SCARD_E_READER_UNSUPPORTED
          return "SCARD_E_READER_UNSUPPORTED"
        when SCARD_E_DUPLICATE_READER
          return "SCARD_E_DUPLICATE_READER"
        when SCARD_E_CARD_UNSUPPORTED
          return "SCARD_E_CARD_UNSUPPORTED"
        when SCARD_E_NO_SERVICE
          return "SCARD_E_NO_SERVICE"
        when SCARD_E_SERVICE_STOPPED
          return "SCARD_E_SERVICE_STOPPED"
        when SCARD_E_NO_READERS_AVAILABLE
          return "SCARD_E_NO_READERS_AVAILABLE"
        when WINDOWS_ERROR_INVALID_HANDLE
          return "WINDOWS_ERROR_INVALID_HANDLE"
        when WINDOWS_ERROR_INVALID_PARAMETER
          return "WINDOWS_ERROR_INVALID_PARAMETER"
        else
          return "Unknown error 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(code))
        end
      end
    }
    
    private
    alias_method :initialize__pcscexception, :initialize
  end
  
end
