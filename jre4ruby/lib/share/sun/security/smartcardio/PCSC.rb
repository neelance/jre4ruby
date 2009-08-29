require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PCSCImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Action, :LoadLibraryAction
    }
  end
  
  # Access to native PC/SC functions and definition of PC/SC constants.
  # Initialization and platform specific PC/SC constants are handled in
  # the platform specific superclass.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class PCSC < PCSCImports.const_get :PlatformPCSC
    include_class_members PCSCImports
    
    typesig { [] }
    def initialize
      super()
      # no instantiation
    end
    
    class_module.module_eval {
      typesig { [] }
      def check_available
        if (!(self.attr_init_exception).nil?)
          raise UnsupportedOperationException.new("PC/SC not available on this platform", self.attr_init_exception)
        end
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardEstablishContext, [:pointer, :long, :int32], :int64
      typesig { [::Java::Int] }
      # returns SCARDCONTEXT (contextId)
      def _scard_establish_context(scope)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardEstablishContext, JNI.env, self.jni_id, scope.to_int)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardListReaders, [:pointer, :long, :int64], :long
      typesig { [::Java::Long] }
      def _scard_list_readers(context_id)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardListReaders, JNI.env, self.jni_id, context_id.to_int)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardConnect, [:pointer, :long, :int64, :long, :int32, :int32], :int64
      typesig { [::Java::Long, String, ::Java::Int, ::Java::Int] }
      # returns SCARDHANDLE (cardId)
      def _scard_connect(context_id, reader_name, share_mode, preferred_protocols)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardConnect, JNI.env, self.jni_id, context_id.to_int, reader_name.jni_id, share_mode.to_int, preferred_protocols.to_int)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardTransmit, [:pointer, :long, :int64, :int32, :long, :int32, :int32], :long
      typesig { [::Java::Long, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def _scard_transmit(card_id, protocol, buf, ofs, len)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardTransmit, JNI.env, self.jni_id, card_id.to_int, protocol.to_int, buf.jni_id, ofs.to_int, len.to_int)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardStatus, [:pointer, :long, :int64, :long], :long
      typesig { [::Java::Long, Array.typed(::Java::Byte)] }
      # returns the ATR of the card, updates status[] with reader state and protocol
      def _scard_status(card_id, status)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardStatus, JNI.env, self.jni_id, card_id.to_int, status.jni_id)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardDisconnect, [:pointer, :long, :int64, :int32], :void
      typesig { [::Java::Long, ::Java::Int] }
      def _scard_disconnect(card_id, disposition)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardDisconnect, JNI.env, self.jni_id, card_id.to_int, disposition.to_int)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardGetStatusChange, [:pointer, :long, :int64, :int64, :long, :long], :long
      typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Int), Array.typed(String)] }
      # returns dwEventState[] of the same size and order as readerNames[]
      def _scard_get_status_change(context_id, timeout, current_state, reader_names)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardGetStatusChange, JNI.env, self.jni_id, context_id.to_int, timeout.to_int, current_state.jni_id, reader_names.jni_id)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardBeginTransaction, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def _scard_begin_transaction(card_id)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardBeginTransaction, JNI.env, self.jni_id, card_id.to_int)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardEndTransaction, [:pointer, :long, :int64, :int32], :void
      typesig { [::Java::Long, ::Java::Int] }
      def _scard_end_transaction(card_id, disposition)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardEndTransaction, JNI.env, self.jni_id, card_id.to_int, disposition.to_int)
      end
      
      JNI.native_method :Java_sun_security_smartcardio_PCSC_SCardControl, [:pointer, :long, :int64, :int32, :long], :long
      typesig { [::Java::Long, ::Java::Int, Array.typed(::Java::Byte)] }
      def _scard_control(card_id, control_code, send_buffer)
        JNI.__send__(:Java_sun_security_smartcardio_PCSC_SCardControl, JNI.env, self.jni_id, card_id.to_int, control_code.to_int, send_buffer.jni_id)
      end
      
      # PCSC success/error/failure/warning codes
      const_set_lazy(:SCARD_S_SUCCESS) { 0x0 }
      const_attr_reader  :SCARD_S_SUCCESS
      
      const_set_lazy(:SCARD_E_CANCELLED) { -0x7feffffe }
      const_attr_reader  :SCARD_E_CANCELLED
      
      const_set_lazy(:SCARD_E_CANT_DISPOSE) { -0x7feffff2 }
      const_attr_reader  :SCARD_E_CANT_DISPOSE
      
      const_set_lazy(:SCARD_E_INSUFFICIENT_BUFFER) { -0x7feffff8 }
      const_attr_reader  :SCARD_E_INSUFFICIENT_BUFFER
      
      const_set_lazy(:SCARD_E_INVALID_ATR) { -0x7fefffeb }
      const_attr_reader  :SCARD_E_INVALID_ATR
      
      const_set_lazy(:SCARD_E_INVALID_HANDLE) { -0x7feffffd }
      const_attr_reader  :SCARD_E_INVALID_HANDLE
      
      const_set_lazy(:SCARD_E_INVALID_PARAMETER) { -0x7feffffc }
      const_attr_reader  :SCARD_E_INVALID_PARAMETER
      
      const_set_lazy(:SCARD_E_INVALID_TARGET) { -0x7feffffb }
      const_attr_reader  :SCARD_E_INVALID_TARGET
      
      const_set_lazy(:SCARD_E_INVALID_VALUE) { -0x7fefffef }
      const_attr_reader  :SCARD_E_INVALID_VALUE
      
      const_set_lazy(:SCARD_E_NO_MEMORY) { -0x7feffffa }
      const_attr_reader  :SCARD_E_NO_MEMORY
      
      const_set_lazy(:SCARD_F_COMM_ERROR) { -0x7fefffed }
      const_attr_reader  :SCARD_F_COMM_ERROR
      
      const_set_lazy(:SCARD_F_INTERNAL_ERROR) { -0x7fefffff }
      const_attr_reader  :SCARD_F_INTERNAL_ERROR
      
      const_set_lazy(:SCARD_F_UNKNOWN_ERROR) { -0x7fefffec }
      const_attr_reader  :SCARD_F_UNKNOWN_ERROR
      
      const_set_lazy(:SCARD_F_WAITED_TOO_LONG) { -0x7feffff9 }
      const_attr_reader  :SCARD_F_WAITED_TOO_LONG
      
      const_set_lazy(:SCARD_E_UNKNOWN_READER) { -0x7feffff7 }
      const_attr_reader  :SCARD_E_UNKNOWN_READER
      
      const_set_lazy(:SCARD_E_TIMEOUT) { -0x7feffff6 }
      const_attr_reader  :SCARD_E_TIMEOUT
      
      const_set_lazy(:SCARD_E_SHARING_VIOLATION) { -0x7feffff5 }
      const_attr_reader  :SCARD_E_SHARING_VIOLATION
      
      const_set_lazy(:SCARD_E_NO_SMARTCARD) { -0x7feffff4 }
      const_attr_reader  :SCARD_E_NO_SMARTCARD
      
      const_set_lazy(:SCARD_E_UNKNOWN_CARD) { -0x7feffff3 }
      const_attr_reader  :SCARD_E_UNKNOWN_CARD
      
      const_set_lazy(:SCARD_E_PROTO_MISMATCH) { -0x7feffff1 }
      const_attr_reader  :SCARD_E_PROTO_MISMATCH
      
      const_set_lazy(:SCARD_E_NOT_READY) { -0x7feffff0 }
      const_attr_reader  :SCARD_E_NOT_READY
      
      const_set_lazy(:SCARD_E_SYSTEM_CANCELLED) { -0x7fefffee }
      const_attr_reader  :SCARD_E_SYSTEM_CANCELLED
      
      const_set_lazy(:SCARD_E_NOT_TRANSACTED) { -0x7fefffea }
      const_attr_reader  :SCARD_E_NOT_TRANSACTED
      
      const_set_lazy(:SCARD_E_READER_UNAVAILABLE) { -0x7fefffe9 }
      const_attr_reader  :SCARD_E_READER_UNAVAILABLE
      
      const_set_lazy(:SCARD_W_UNSUPPORTED_CARD) { -0x7fefff9b }
      const_attr_reader  :SCARD_W_UNSUPPORTED_CARD
      
      const_set_lazy(:SCARD_W_UNRESPONSIVE_CARD) { -0x7fefff9a }
      const_attr_reader  :SCARD_W_UNRESPONSIVE_CARD
      
      const_set_lazy(:SCARD_W_UNPOWERED_CARD) { -0x7fefff99 }
      const_attr_reader  :SCARD_W_UNPOWERED_CARD
      
      const_set_lazy(:SCARD_W_RESET_CARD) { -0x7fefff98 }
      const_attr_reader  :SCARD_W_RESET_CARD
      
      const_set_lazy(:SCARD_W_REMOVED_CARD) { -0x7fefff97 }
      const_attr_reader  :SCARD_W_REMOVED_CARD
      
      const_set_lazy(:SCARD_W_INSERTED_CARD) { -0x7fefff96 }
      const_attr_reader  :SCARD_W_INSERTED_CARD
      
      const_set_lazy(:SCARD_E_UNSUPPORTED_FEATURE) { -0x7fefffe1 }
      const_attr_reader  :SCARD_E_UNSUPPORTED_FEATURE
      
      const_set_lazy(:SCARD_E_PCI_TOO_SMALL) { -0x7fefffe7 }
      const_attr_reader  :SCARD_E_PCI_TOO_SMALL
      
      const_set_lazy(:SCARD_E_READER_UNSUPPORTED) { -0x7fefffe6 }
      const_attr_reader  :SCARD_E_READER_UNSUPPORTED
      
      const_set_lazy(:SCARD_E_DUPLICATE_READER) { -0x7fefffe5 }
      const_attr_reader  :SCARD_E_DUPLICATE_READER
      
      const_set_lazy(:SCARD_E_CARD_UNSUPPORTED) { -0x7fefffe4 }
      const_attr_reader  :SCARD_E_CARD_UNSUPPORTED
      
      const_set_lazy(:SCARD_E_NO_SERVICE) { -0x7fefffe3 }
      const_attr_reader  :SCARD_E_NO_SERVICE
      
      const_set_lazy(:SCARD_E_SERVICE_STOPPED) { -0x7fefffe2 }
      const_attr_reader  :SCARD_E_SERVICE_STOPPED
      
      # MS undocumented
      const_set_lazy(:SCARD_E_NO_READERS_AVAILABLE) { -0x7fefffd2 }
      const_attr_reader  :SCARD_E_NO_READERS_AVAILABLE
      
      # std. Windows invalid handle return code, used instead of SCARD code
      const_set_lazy(:WINDOWS_ERROR_INVALID_HANDLE) { 6 }
      const_attr_reader  :WINDOWS_ERROR_INVALID_HANDLE
      
      const_set_lazy(:WINDOWS_ERROR_INVALID_PARAMETER) { 87 }
      const_attr_reader  :WINDOWS_ERROR_INVALID_PARAMETER
      
      const_set_lazy(:SCARD_SCOPE_USER) { 0x0 }
      const_attr_reader  :SCARD_SCOPE_USER
      
      const_set_lazy(:SCARD_SCOPE_TERMINAL) { 0x1 }
      const_attr_reader  :SCARD_SCOPE_TERMINAL
      
      const_set_lazy(:SCARD_SCOPE_SYSTEM) { 0x2 }
      const_attr_reader  :SCARD_SCOPE_SYSTEM
      
      const_set_lazy(:SCARD_SCOPE_GLOBAL) { 0x3 }
      const_attr_reader  :SCARD_SCOPE_GLOBAL
      
      const_set_lazy(:SCARD_SHARE_EXCLUSIVE) { 0x1 }
      const_attr_reader  :SCARD_SHARE_EXCLUSIVE
      
      const_set_lazy(:SCARD_SHARE_SHARED) { 0x2 }
      const_attr_reader  :SCARD_SHARE_SHARED
      
      const_set_lazy(:SCARD_SHARE_DIRECT) { 0x3 }
      const_attr_reader  :SCARD_SHARE_DIRECT
      
      const_set_lazy(:SCARD_LEAVE_CARD) { 0x0 }
      const_attr_reader  :SCARD_LEAVE_CARD
      
      const_set_lazy(:SCARD_RESET_CARD) { 0x1 }
      const_attr_reader  :SCARD_RESET_CARD
      
      const_set_lazy(:SCARD_UNPOWER_CARD) { 0x2 }
      const_attr_reader  :SCARD_UNPOWER_CARD
      
      const_set_lazy(:SCARD_EJECT_CARD) { 0x3 }
      const_attr_reader  :SCARD_EJECT_CARD
      
      const_set_lazy(:SCARD_STATE_UNAWARE) { 0x0 }
      const_attr_reader  :SCARD_STATE_UNAWARE
      
      const_set_lazy(:SCARD_STATE_IGNORE) { 0x1 }
      const_attr_reader  :SCARD_STATE_IGNORE
      
      const_set_lazy(:SCARD_STATE_CHANGED) { 0x2 }
      const_attr_reader  :SCARD_STATE_CHANGED
      
      const_set_lazy(:SCARD_STATE_UNKNOWN) { 0x4 }
      const_attr_reader  :SCARD_STATE_UNKNOWN
      
      const_set_lazy(:SCARD_STATE_UNAVAILABLE) { 0x8 }
      const_attr_reader  :SCARD_STATE_UNAVAILABLE
      
      const_set_lazy(:SCARD_STATE_EMPTY) { 0x10 }
      const_attr_reader  :SCARD_STATE_EMPTY
      
      const_set_lazy(:SCARD_STATE_PRESENT) { 0x20 }
      const_attr_reader  :SCARD_STATE_PRESENT
      
      const_set_lazy(:SCARD_STATE_ATRMATCH) { 0x40 }
      const_attr_reader  :SCARD_STATE_ATRMATCH
      
      const_set_lazy(:SCARD_STATE_EXCLUSIVE) { 0x80 }
      const_attr_reader  :SCARD_STATE_EXCLUSIVE
      
      const_set_lazy(:SCARD_STATE_INUSE) { 0x100 }
      const_attr_reader  :SCARD_STATE_INUSE
      
      const_set_lazy(:SCARD_STATE_MUTE) { 0x200 }
      const_attr_reader  :SCARD_STATE_MUTE
      
      const_set_lazy(:SCARD_STATE_UNPOWERED) { 0x400 }
      const_attr_reader  :SCARD_STATE_UNPOWERED
      
      const_set_lazy(:TIMEOUT_INFINITE) { -0x1 }
      const_attr_reader  :TIMEOUT_INFINITE
      
      const_set_lazy(:HexDigits) { "0123456789abcdef".to_char_array }
      const_attr_reader  :HexDigits
      
      typesig { [Array.typed(::Java::Byte)] }
      def to_s(b)
        sb = StringBuffer.new(b.attr_length * 3)
        i = 0
        while i < b.attr_length
          k = b[i] & 0xff
          if (!(i).equal?(0))
            sb.append(Character.new(?:.ord))
          end
          sb.append(HexDigits[k >> 4])
          sb.append(HexDigits[k & 0xf])
          i += 1
        end
        return sb.to_s
      end
    }
    
    private
    alias_method :initialize__pcsc, :initialize
  end
  
end
