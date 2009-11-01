require "rjava"

# Portions Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PKCS11Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include ::Java::Util
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This is the default implementation of the PKCS11 interface. IT connects to
  # the pkcs11wrapper.dll file, which is the native part of this library.
  # The strange and awkward looking initialization was chosen to avoid calling
  # loadLibrary from a static initialization block, because this would complicate
  # the use in applets.
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  # @invariants (pkcs11ModulePath_ <> null)
  class PKCS11 
    include_class_members PKCS11Imports
    
    class_module.module_eval {
      # The name of the native part of the wrapper; i.e. the filename without
      # the extension (e.g. ".DLL" or ".so").
      const_set_lazy(:PKCS11_WRAPPER) { "j2pkcs11" }
      const_attr_reader  :PKCS11_WRAPPER
      
      when_class_loaded do
        AccessController.do_privileged(# cannot use LoadLibraryAction because that would make the native
        # library available to the bootclassloader, but we run in the
        # extension classloader.
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members PKCS11
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            System.load_library(PKCS11_WRAPPER)
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        initialize_library
      end
      
      typesig { [] }
      def load_native
        # dummy method that can be called to make sure the native
        # portion has been loaded. actual loading happens in the
        # static initializer, hence this method is empty.
      end
    }
    
    # The PKCS#11 module to connect to. This is the PKCS#11 driver of the token;
    # e.g. pk2priv.dll.
    attr_accessor :pkcs11module_path
    alias_method :attr_pkcs11module_path, :pkcs11module_path
    undef_method :pkcs11module_path
    alias_method :attr_pkcs11module_path=, :pkcs11module_path=
    undef_method :pkcs11module_path=
    
    attr_accessor :p_native_data
    alias_method :attr_p_native_data, :p_native_data
    undef_method :p_native_data
    alias_method :attr_p_native_data=, :p_native_data=
    undef_method :p_native_data=
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_initializeLibrary, [:pointer, :long], :void
      typesig { [] }
      # This method does the initialization of the native library. It is called
      # exactly once for this class.
      # 
      # @preconditions
      # @postconditions
      def initialize_library
        JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_initializeLibrary, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_finalizeLibrary, [:pointer, :long], :void
      typesig { [] }
      # XXX
      # 
      # This method does the finalization of the native library. It is called
      # exactly once for this class. The library uses this method for a clean-up
      # of any resources.
      # 
      # @preconditions
      # @postconditions
      def finalize_library
        JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_finalizeLibrary, JNI.env, self.jni_id)
      end
      
      const_set_lazy(:ModuleMap) { HashMap.new }
      const_attr_reader  :ModuleMap
    }
    
    typesig { [String, String] }
    # Connects to the PKCS#11 driver given. The filename must contain the
    # path, if the driver is not in the system's search path.
    # 
    # @param pkcs11ModulePath the PKCS#11 library path
    # @preconditions (pkcs11ModulePath <> null)
    # @postconditions
    def initialize(pkcs11module_path, function_list_name)
      @pkcs11module_path = nil
      @p_native_data = 0
      connect(pkcs11module_path, function_list_name)
      @pkcs11module_path = pkcs11module_path
    end
    
    class_module.module_eval {
      typesig { [String, String, CK_C_INITIALIZE_ARGS, ::Java::Boolean] }
      def get_instance(pkcs11module_path, function_list, p_init_args, omit_initialize)
        synchronized(self) do
          # we may only call C_Initialize once per native .so/.dll
          # so keep a cache using the (non-canonicalized!) path
          pkcs11 = ModuleMap.get(pkcs11module_path)
          if ((pkcs11).nil?)
            if ((!(p_init_args).nil?) && (!((p_init_args.attr_flags & CKF_OS_LOCKING_OK)).equal?(0)))
              pkcs11 = PKCS11.new(pkcs11module_path, function_list)
            else
              pkcs11 = SynchronizedPKCS11.new(pkcs11module_path, function_list)
            end
            if ((omit_initialize).equal?(false))
              begin
                pkcs11._c_initialize(p_init_args)
              rescue PKCS11Exception => e
                # ignore already-initialized error code
                # rethrow all other errors
                if (!(e.get_error_code).equal?(CKR_CRYPTOKI_ALREADY_INITIALIZED))
                  raise e
                end
              end
            end
            ModuleMap.put(pkcs11module_path, pkcs11)
          end
          return pkcs11
        end
      end
    }
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_connect, [:pointer, :long, :long, :long], :void
    typesig { [String, String] }
    # Connects this object to the specified PKCS#11 library. This method is for
    # internal use only.
    # Declared private, because incorrect handling may result in errors in the
    # native part.
    # 
    # @param pkcs11ModulePath The PKCS#11 library path.
    # @preconditions (pkcs11ModulePath <> null)
    # @postconditions
    def connect(pkcs11module_path, function_list_name)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_connect, JNI.env, self.jni_id, pkcs11module_path.jni_id, function_list_name.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_disconnect, [:pointer, :long], :void
    typesig { [] }
    # Disconnects the PKCS#11 library from this object. After calling this
    # method, this object is no longer connected to a native PKCS#11 module
    # and any subsequent calls to C_ methods will fail. This method is for
    # internal use only.
    # Declared private, because incorrect handling may result in errors in the
    # native part.
    # 
    # @preconditions
    # @postconditions
    def disconnect
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_disconnect, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Initialize, [:pointer, :long, :long], :void
    typesig { [Object] }
    # Implementation of PKCS11 methods delegated to native pkcs11wrapper library
    # *****************************************************************************
    # General-purpose
    # 
    # 
    # C_Initialize initializes the Cryptoki library.
    # (General-purpose)
    # 
    # @param pInitArgs if pInitArgs is not NULL it gets casted to
    # CK_C_INITIALIZE_ARGS_PTR and dereferenced
    # (PKCS#11 param: CK_VOID_PTR pInitArgs)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_initialize(p_init_args)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Initialize, JNI.env, self.jni_id, p_init_args.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Finalize, [:pointer, :long, :long], :void
    typesig { [Object] }
    # C_Finalize indicates that an application is done with the
    # Cryptoki library
    # (General-purpose)
    # 
    # @param pReserved is reserved. Should be NULL_PTR
    # (PKCS#11 param: CK_VOID_PTR pReserved)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pReserved == null)
    # @postconditions
    def _c_finalize(p_reserved)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Finalize, JNI.env, self.jni_id, p_reserved.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetInfo, [:pointer, :long], :long
    typesig { [] }
    # C_GetInfo returns general information about Cryptoki.
    # (General-purpose)
    # 
    # @return the information.
    # (PKCS#11 param: CK_INFO_PTR pInfo)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_get_info
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetInfo, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetSlotList, [:pointer, :long, :int8], :long
    typesig { [::Java::Boolean] }
    # *****************************************************************************
    # Slot and token management
    # 
    # 
    # C_GetSlotList obtains a list of slots in the system.
    # (Slot and token management)
    # 
    # @param tokenPresent if true only Slot IDs with a token are returned
    # (PKCS#11 param: CK_BBOOL tokenPresent)
    # @return a long array of slot IDs and number of Slot IDs
    # (PKCS#11 param: CK_SLOT_ID_PTR pSlotList, CK_ULONG_PTR pulCount)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_get_slot_list(token_present)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetSlotList, JNI.env, self.jni_id, token_present ? 1 : 0)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetSlotInfo, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    # C_GetSlotInfo obtains information about a particular slot in
    # the system.
    # (Slot and token management)
    # 
    # @param slotID the ID of the slot
    # (PKCS#11 param: CK_SLOT_ID slotID)
    # @return the slot information
    # (PKCS#11 param: CK_SLOT_INFO_PTR pInfo)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_get_slot_info(slot_id)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetSlotInfo, JNI.env, self.jni_id, slot_id.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetTokenInfo, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    # C_GetTokenInfo obtains information about a particular token
    # in the system.
    # (Slot and token management)
    # 
    # @param slotID ID of the token's slot
    # (PKCS#11 param: CK_SLOT_ID slotID)
    # @return the token information
    # (PKCS#11 param: CK_TOKEN_INFO_PTR pInfo)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_get_token_info(slot_id)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetTokenInfo, JNI.env, self.jni_id, slot_id.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetMechanismList, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    # C_GetMechanismList obtains a list of mechanism types
    # supported by a token.
    # (Slot and token management)
    # 
    # @param slotID ID of the token's slot
    # (PKCS#11 param: CK_SLOT_ID slotID)
    # @return a long array of mechanism types and number of mechanism types
    # (PKCS#11 param: CK_MECHANISM_TYPE_PTR pMechanismList,
    # CK_ULONG_PTR pulCount)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_get_mechanism_list(slot_id)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetMechanismList, JNI.env, self.jni_id, slot_id.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetMechanismInfo, [:pointer, :long, :int64, :int64], :long
    typesig { [::Java::Long, ::Java::Long] }
    # C_GetMechanismInfo obtains information about a particular
    # mechanism possibly supported by a token.
    # (Slot and token management)
    # 
    # @param slotID ID of the token's slot
    # (PKCS#11 param: CK_SLOT_ID slotID)
    # @param type type of mechanism
    # (PKCS#11 param: CK_MECHANISM_TYPE type)
    # @return the mechanism info
    # (PKCS#11 param: CK_MECHANISM_INFO_PTR pInfo)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_get_mechanism_info(slot_id, type)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetMechanismInfo, JNI.env, self.jni_id, slot_id.to_int, type.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1OpenSession, [:pointer, :long, :int64, :int64, :long, :long], :int64
    typesig { [::Java::Long, ::Java::Long, Object, CK_NOTIFY] }
    # C_InitToken initializes a token.
    # (Slot and token management)
    # 
    # @param slotID ID of the token's slot
    # (PKCS#11 param: CK_SLOT_ID slotID)
    # @param pPin the SO's initial PIN and the length in bytes of the PIN
    # (PKCS#11 param: CK_CHAR_PTR pPin, CK_ULONG ulPinLen)
    # @param pLabel 32-byte token label (blank padded)
    # (PKCS#11 param: CK_UTF8CHAR_PTR pLabel)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native void C_InitToken(long slotID, char[] pPin, char[] pLabel) throws PKCS11Exception;
    # 
    # C_InitPIN initializes the normal user's PIN.
    # (Slot and token management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pPin the normal user's PIN and the length in bytes of the PIN
    # (PKCS#11 param: CK_CHAR_PTR pPin, CK_ULONG ulPinLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native void C_InitPIN(long hSession, char[] pPin) throws PKCS11Exception;
    # 
    # C_SetPIN modifies the PIN of the user who is logged in.
    # (Slot and token management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pOldPin the old PIN and the length of the old PIN
    # (PKCS#11 param: CK_CHAR_PTR pOldPin, CK_ULONG ulOldLen)
    # @param pNewPin the new PIN and the length of the new PIN
    # (PKCS#11 param: CK_CHAR_PTR pNewPin, CK_ULONG ulNewLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native void C_SetPIN(long hSession, char[] pOldPin, char[] pNewPin) throws PKCS11Exception;
    # *****************************************************************************
    # Session management
    # 
    # 
    # C_OpenSession opens a session between an application and a
    # token.
    # (Session management)
    # 
    # @param slotID the slot's ID
    # (PKCS#11 param: CK_SLOT_ID slotID)
    # @param flags of CK_SESSION_INFO
    # (PKCS#11 param: CK_FLAGS flags)
    # @param pApplication passed to callback
    # (PKCS#11 param: CK_VOID_PTR pApplication)
    # @param Notify the callback function
    # (PKCS#11 param: CK_NOTIFY Notify)
    # @return the session handle
    # (PKCS#11 param: CK_SESSION_HANDLE_PTR phSession)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_open_session(slot_id, flags, p_application, notify)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1OpenSession, JNI.env, self.jni_id, slot_id.to_int, flags.to_int, p_application.jni_id, notify.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1CloseSession, [:pointer, :long, :int64], :void
    typesig { [::Java::Long] }
    # C_CloseSession closes a session between an application and a
    # token.
    # (Session management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_close_session(h_session)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1CloseSession, JNI.env, self.jni_id, h_session.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetSessionInfo, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    # C_CloseAllSessions closes all sessions with a token.
    # (Session management)
    # 
    # @param slotID the ID of the token's slot
    # (PKCS#11 param: CK_SLOT_ID slotID)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native void C_CloseAllSessions(long slotID) throws PKCS11Exception;
    # 
    # C_GetSessionInfo obtains information about the session.
    # (Session management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @return the session info
    # (PKCS#11 param: CK_SESSION_INFO_PTR pInfo)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_get_session_info(h_session)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetSessionInfo, JNI.env, self.jni_id, h_session.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Login, [:pointer, :long, :int64, :int64, :long], :void
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Char)] }
    # C_GetOperationState obtains the state of the cryptographic operation
    # in a session.
    # (Session management)
    # 
    # @param hSession session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @return the state and the state length
    # (PKCS#11 param: CK_BYTE_PTR pOperationState,
    # CK_ULONG_PTR pulOperationStateLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    # 
    # public native byte[] C_GetOperationState(long hSession) throws PKCS11Exception;
    # 
    # C_SetOperationState restores the state of the cryptographic
    # operation in a session.
    # (Session management)
    # 
    # @param hSession session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pOperationState the state and the state length
    # (PKCS#11 param: CK_BYTE_PTR pOperationState,
    # CK_ULONG ulOperationStateLen)
    # @param hEncryptionKey en/decryption key
    # (PKCS#11 param: CK_OBJECT_HANDLE hEncryptionKey)
    # @param hAuthenticationKey sign/verify key
    # (PKCS#11 param: CK_OBJECT_HANDLE hAuthenticationKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native void C_SetOperationState(long hSession, byte[] pOperationState, long hEncryptionKey, long hAuthenticationKey) throws PKCS11Exception;
    # 
    # C_Login logs a user into a token.
    # (Session management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param userType the user type
    # (PKCS#11 param: CK_USER_TYPE userType)
    # @param pPin the user's PIN and the length of the PIN
    # (PKCS#11 param: CK_CHAR_PTR pPin, CK_ULONG ulPinLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_login(h_session, user_type, p_pin)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Login, JNI.env, self.jni_id, h_session.to_int, user_type.to_int, p_pin.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Logout, [:pointer, :long, :int64], :void
    typesig { [::Java::Long] }
    # C_Logout logs a user out from a token.
    # (Session management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_logout(h_session)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Logout, JNI.env, self.jni_id, h_session.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1CreateObject, [:pointer, :long, :int64, :long], :int64
    typesig { [::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # *****************************************************************************
    # Object management
    # 
    # 
    # C_CreateObject creates a new object.
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pTemplate the object's template and number of attributes in
    # template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @return the object's handle
    # (PKCS#11 param: CK_OBJECT_HANDLE_PTR phObject)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_create_object(h_session, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1CreateObject, JNI.env, self.jni_id, h_session.to_int, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1CopyObject, [:pointer, :long, :int64, :int64, :long], :int64
    typesig { [::Java::Long, ::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # C_CopyObject copies an object, creating a new object for the
    # copy.
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param hObject the object's handle
    # (PKCS#11 param: CK_OBJECT_HANDLE hObject)
    # @param pTemplate the template for the new object and number of attributes
    # in template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @return the handle of the copy
    # (PKCS#11 param: CK_OBJECT_HANDLE_PTR phNewObject)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_copy_object(h_session, h_object, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1CopyObject, JNI.env, self.jni_id, h_session.to_int, h_object.to_int, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DestroyObject, [:pointer, :long, :int64, :int64], :void
    typesig { [::Java::Long, ::Java::Long] }
    # C_DestroyObject destroys an object.
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param hObject the object's handle
    # (PKCS#11 param: CK_OBJECT_HANDLE hObject)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_destroy_object(h_session, h_object)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DestroyObject, JNI.env, self.jni_id, h_session.to_int, h_object.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetAttributeValue, [:pointer, :long, :int64, :int64, :long], :void
    typesig { [::Java::Long, ::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # C_GetObjectSize gets the size of an object in bytes.
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param hObject the object's handle
    # (PKCS#11 param: CK_OBJECT_HANDLE hObject)
    # @return the size of the object
    # (PKCS#11 param: CK_ULONG_PTR pulSize)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native long C_GetObjectSize(long hSession, long hObject) throws PKCS11Exception;
    # 
    # C_GetAttributeValue obtains the value of one or more object
    # attributes. The template attributes also receive the values.
    # (Object management)
    # note: in PKCS#11 pTemplate and the result template are the same
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param hObject the object's handle
    # (PKCS#11 param: CK_OBJECT_HANDLE hObject)
    # @param pTemplate specifies the attributes and number of attributes to get
    # The template attributes also receive the values.
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pTemplate <> null)
    # @postconditions (result <> null)
    def _c_get_attribute_value(h_session, h_object, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GetAttributeValue, JNI.env, self.jni_id, h_session.to_int, h_object.to_int, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1SetAttributeValue, [:pointer, :long, :int64, :int64, :long], :void
    typesig { [::Java::Long, ::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # C_SetAttributeValue modifies the value of one or more object
    # attributes
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param hObject the object's handle
    # (PKCS#11 param: CK_OBJECT_HANDLE hObject)
    # @param pTemplate specifies the attributes and values to get; number of
    # attributes in the template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pTemplate <> null)
    # @postconditions
    def _c_set_attribute_value(h_session, h_object, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1SetAttributeValue, JNI.env, self.jni_id, h_session.to_int, h_object.to_int, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1FindObjectsInit, [:pointer, :long, :int64, :long], :void
    typesig { [::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # C_FindObjectsInit initializes a search for token and session
    # objects that match a template.
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pTemplate the object's attribute values to match and the number of
    # attributes in search template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_find_objects_init(h_session, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1FindObjectsInit, JNI.env, self.jni_id, h_session.to_int, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1FindObjects, [:pointer, :long, :int64, :int64], :long
    typesig { [::Java::Long, ::Java::Long] }
    # C_FindObjects continues a search for token and session
    # objects that match a template, obtaining additional object
    # handles.
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param ulMaxObjectCount the max. object handles to get
    # (PKCS#11 param: CK_ULONG ulMaxObjectCount)
    # @return the object's handles and the actual number of objects returned
    # (PKCS#11 param: CK_ULONG_PTR pulObjectCount)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_find_objects(h_session, ul_max_object_count)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1FindObjects, JNI.env, self.jni_id, h_session.to_int, ul_max_object_count.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1FindObjectsFinal, [:pointer, :long, :int64], :void
    typesig { [::Java::Long] }
    # C_FindObjectsFinal finishes a search for token and session
    # objects.
    # (Object management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_find_objects_final(h_session)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1FindObjectsFinal, JNI.env, self.jni_id, h_session.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1EncryptInit, [:pointer, :long, :int64, :long, :int64], :void
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long] }
    # *****************************************************************************
    # Encryption and decryption
    # 
    # 
    # C_EncryptInit initializes an encryption operation.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the encryption mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hKey the handle of the encryption key
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_encrypt_init(h_session, p_mechanism, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1EncryptInit, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Encrypt, [:pointer, :long, :int64, :long, :int32, :int32, :long, :int32, :int32], :int32
    typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_Encrypt encrypts single-part data.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pData the data to get encrypted and the data's length
    # (PKCS#11 param: CK_BYTE_PTR pData, CK_ULONG ulDataLen)
    # @return the encrypted data and the encrypted data's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedData,
    # CK_ULONG_PTR pulEncryptedDataLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pData <> null)
    # @postconditions (result <> null)
    def _c_encrypt(h_session, in_, in_ofs, in_len, out, out_ofs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Encrypt, JNI.env, self.jni_id, h_session.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int, out.jni_id, out_ofs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1EncryptUpdate, [:pointer, :long, :int64, :int64, :long, :int32, :int32, :int64, :long, :int32, :int32], :int32
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_EncryptUpdate continues a multiple-part encryption
    # operation.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pPart the data part to get encrypted and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG ulPartLen)
    # @return the encrypted data part and the encrypted data part's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedPart,
    # CK_ULONG_PTR pulEncryptedPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pPart <> null)
    # @postconditions
    def _c_encrypt_update(h_session, direct_in, in_, in_ofs, in_len, direct_out, out, out_ofs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1EncryptUpdate, JNI.env, self.jni_id, h_session.to_int, direct_in.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int, direct_out.to_int, out.jni_id, out_ofs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1EncryptFinal, [:pointer, :long, :int64, :int64, :long, :int32, :int32], :int32
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_EncryptFinal finishes a multiple-part encryption
    # operation.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @return the last encrypted data part and the last data part's length
    # (PKCS#11 param: CK_BYTE_PTR pLastEncryptedPart,
    # CK_ULONG_PTR pulLastEncryptedPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_encrypt_final(h_session, direct_out, out, out_ofs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1EncryptFinal, JNI.env, self.jni_id, h_session.to_int, direct_out.to_int, out.jni_id, out_ofs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DecryptInit, [:pointer, :long, :int64, :long, :int64], :void
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long] }
    # C_DecryptInit initializes a decryption operation.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the decryption mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hKey the handle of the decryption key
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_decrypt_init(h_session, p_mechanism, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DecryptInit, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Decrypt, [:pointer, :long, :int64, :long, :int32, :int32, :long, :int32, :int32], :int32
    typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_Decrypt decrypts encrypted data in a single part.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pEncryptedData the encrypted data to get decrypted and the
    # encrypted data's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedData,
    # CK_ULONG ulEncryptedDataLen)
    # @return the decrypted data and the data's length
    # (PKCS#11 param: CK_BYTE_PTR pData, CK_ULONG_PTR pulDataLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pEncryptedPart <> null)
    # @postconditions (result <> null)
    def _c_decrypt(h_session, in_, in_ofs, in_len, out, out_ofs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Decrypt, JNI.env, self.jni_id, h_session.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int, out.jni_id, out_ofs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DecryptUpdate, [:pointer, :long, :int64, :int64, :long, :int32, :int32, :int64, :long, :int32, :int32], :int32
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_DecryptUpdate continues a multiple-part decryption
    # operation.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pEncryptedPart the encrypted data part to get decrypted and the
    # encrypted data part's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedPart,
    # CK_ULONG ulEncryptedPartLen)
    # @return the decrypted data part and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG_PTR pulPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pEncryptedPart <> null)
    # @postconditions
    def _c_decrypt_update(h_session, direct_in, in_, in_ofs, in_len, direct_out, out, out_ofs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DecryptUpdate, JNI.env, self.jni_id, h_session.to_int, direct_in.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int, direct_out.to_int, out.jni_id, out_ofs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DecryptFinal, [:pointer, :long, :int64, :int64, :long, :int32, :int32], :int32
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_DecryptFinal finishes a multiple-part decryption
    # operation.
    # (Encryption and decryption)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @return the last decrypted data part and the last data part's length
    # (PKCS#11 param: CK_BYTE_PTR pLastPart,
    # CK_ULONG_PTR pulLastPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_decrypt_final(h_session, direct_out, out, out_ofs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DecryptFinal, JNI.env, self.jni_id, h_session.to_int, direct_out.to_int, out.jni_id, out_ofs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestInit, [:pointer, :long, :int64, :long], :void
    typesig { [::Java::Long, CK_MECHANISM] }
    # *****************************************************************************
    # Message digesting
    # 
    # 
    # C_DigestInit initializes a message-digesting operation.
    # (Message digesting)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the digesting mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_digest_init(h_session, p_mechanism)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestInit, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestSingle, [:pointer, :long, :int64, :long, :long, :int32, :int32, :long, :int32, :int32], :int32
    typesig { [::Java::Long, CK_MECHANISM, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # note that C_DigestSingle does not exist in PKCS#11
    # we combined the C_DigestInit and C_Digest into a single function
    # to save on Java<->C transitions and save 5-10% on small digests
    # this made the C_Digest method redundant, it has been removed
    # 
    # C_Digest digests data in a single part.
    # (Message digesting)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param data the data to get digested and the data's length
    # (PKCS#11 param: CK_BYTE_PTR pData, CK_ULONG ulDataLen)
    # @return the message digest and the length of the message digest
    # (PKCS#11 param: CK_BYTE_PTR pDigest, CK_ULONG_PTR pulDigestLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (data <> null)
    # @postconditions (result <> null)
    def _c_digest_single(h_session, p_mechanism, in_, in_ofs, in_len, digest, digest_ofs, digest_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestSingle, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, in_.jni_id, in_ofs.to_int, in_len.to_int, digest.jni_id, digest_ofs.to_int, digest_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestUpdate, [:pointer, :long, :int64, :int64, :long, :int32, :int32], :void
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_DigestUpdate continues a multiple-part message-digesting
    # operation.
    # (Message digesting)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pPart the data to get digested and the data's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG ulPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pPart <> null)
    # @postconditions
    def _c_digest_update(h_session, direct_in, in_, in_ofs, in_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestUpdate, JNI.env, self.jni_id, h_session.to_int, direct_in.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestKey, [:pointer, :long, :int64, :int64], :void
    typesig { [::Java::Long, ::Java::Long] }
    # C_DigestKey continues a multi-part message-digesting
    # operation, by digesting the value of a secret key as part of
    # the data already digested.
    # (Message digesting)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param hKey the handle of the secret key to be digested
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_digest_key(h_session, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestKey, JNI.env, self.jni_id, h_session.to_int, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestFinal, [:pointer, :long, :int64, :long, :int32, :int32], :int32
    typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_DigestFinal finishes a multiple-part message-digesting
    # operation.
    # (Message digesting)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @return the message digest and the length of the message digest
    # (PKCS#11 param: CK_BYTE_PTR pDigest, CK_ULONG_PTR pulDigestLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_digest_final(h_session, p_digest, digest_ofs, digest_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DigestFinal, JNI.env, self.jni_id, h_session.to_int, p_digest.jni_id, digest_ofs.to_int, digest_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignInit, [:pointer, :long, :int64, :long, :int64], :void
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long] }
    # *****************************************************************************
    # Signing and MACing
    # 
    # 
    # C_SignInit initializes a signature (private key encryption)
    # operation, where the signature is (will be) an appendix to
    # the data, and plaintext cannot be recovered from the
    # signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the signature mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hKey the handle of the signature key
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_sign_init(h_session, p_mechanism, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignInit, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Sign, [:pointer, :long, :int64, :long], :long
    typesig { [::Java::Long, Array.typed(::Java::Byte)] }
    # C_Sign signs (encrypts with private key) data in a single
    # part, where the signature is (will be) an appendix to the
    # data, and plaintext cannot be recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pData the data to sign and the data's length
    # (PKCS#11 param: CK_BYTE_PTR pData, CK_ULONG ulDataLen)
    # @return the signature and the signature's length
    # (PKCS#11 param: CK_BYTE_PTR pSignature,
    # CK_ULONG_PTR pulSignatureLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pData <> null)
    # @postconditions (result <> null)
    def _c_sign(h_session, p_data)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Sign, JNI.env, self.jni_id, h_session.to_int, p_data.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignUpdate, [:pointer, :long, :int64, :int64, :long, :int32, :int32], :void
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_SignUpdate continues a multiple-part signature operation,
    # where the signature is (will be) an appendix to the data,
    # and plaintext cannot be recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pPart the data part to sign and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG ulPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pPart <> null)
    # @postconditions
    def _c_sign_update(h_session, direct_in, in_, in_ofs, in_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignUpdate, JNI.env, self.jni_id, h_session.to_int, direct_in.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignFinal, [:pointer, :long, :int64, :int32], :long
    typesig { [::Java::Long, ::Java::Int] }
    # C_SignFinal finishes a multiple-part signature operation,
    # returning the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @return the signature and the signature's length
    # (PKCS#11 param: CK_BYTE_PTR pSignature,
    # CK_ULONG_PTR pulSignatureLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_sign_final(h_session, expected_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignFinal, JNI.env, self.jni_id, h_session.to_int, expected_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignRecoverInit, [:pointer, :long, :int64, :long, :int64], :void
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long] }
    # C_SignRecoverInit initializes a signature operation, where
    # the data can be recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the signature mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hKey the handle of the signature key
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_sign_recover_init(h_session, p_mechanism, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignRecoverInit, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignRecover, [:pointer, :long, :int64, :long, :int32, :int32, :long, :int32, :int32], :int32
    typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_SignRecover signs data in a single operation, where the
    # data can be recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pData the data to sign and the data's length
    # (PKCS#11 param: CK_BYTE_PTR pData, CK_ULONG ulDataLen)
    # @return the signature and the signature's length
    # (PKCS#11 param: CK_BYTE_PTR pSignature,
    # CK_ULONG_PTR pulSignatureLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pData <> null)
    # @postconditions (result <> null)
    def _c_sign_recover(h_session, in_, in_ofs, in_len, out, out_oufs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1SignRecover, JNI.env, self.jni_id, h_session.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int, out.jni_id, out_oufs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyInit, [:pointer, :long, :int64, :long, :int64], :void
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long] }
    # *****************************************************************************
    # Verifying signatures and MACs
    # 
    # 
    # C_VerifyInit initializes a verification operation, where the
    # signature is an appendix to the data, and plaintext cannot
    # cannot be recovered from the signature (e.g. DSA).
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the verification mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hKey the handle of the verification key
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_verify_init(h_session, p_mechanism, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyInit, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1Verify, [:pointer, :long, :int64, :long, :long], :void
    typesig { [::Java::Long, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # C_Verify verifies a signature in a single-part operation,
    # where the signature is an appendix to the data, and plaintext
    # cannot be recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pData the signed data and the signed data's length
    # (PKCS#11 param: CK_BYTE_PTR pData, CK_ULONG ulDataLen)
    # @param pSignature the signature to verify and the signature's length
    # (PKCS#11 param: CK_BYTE_PTR pSignature, CK_ULONG ulSignatureLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pData <> null) and (pSignature <> null)
    # @postconditions
    def _c_verify(h_session, p_data, p_signature)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1Verify, JNI.env, self.jni_id, h_session.to_int, p_data.jni_id, p_signature.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyUpdate, [:pointer, :long, :int64, :int64, :long, :int32, :int32], :void
    typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_VerifyUpdate continues a multiple-part verification
    # operation, where the signature is an appendix to the data,
    # and plaintext cannot be recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pPart the signed data part and the signed data part's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG ulPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pPart <> null)
    # @postconditions
    def _c_verify_update(h_session, direct_in, in_, in_ofs, in_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyUpdate, JNI.env, self.jni_id, h_session.to_int, direct_in.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyFinal, [:pointer, :long, :int64, :long], :void
    typesig { [::Java::Long, Array.typed(::Java::Byte)] }
    # C_VerifyFinal finishes a multiple-part verification
    # operation, checking the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pSignature the signature to verify and the signature's length
    # (PKCS#11 param: CK_BYTE_PTR pSignature, CK_ULONG ulSignatureLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pSignature <> null)
    # @postconditions
    def _c_verify_final(h_session, p_signature)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyFinal, JNI.env, self.jni_id, h_session.to_int, p_signature.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyRecoverInit, [:pointer, :long, :int64, :long, :int64], :void
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long] }
    # C_VerifyRecoverInit initializes a signature verification
    # operation, where the data is recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the verification mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hKey the handle of the verification key
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_verify_recover_init(h_session, p_mechanism, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyRecoverInit, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyRecover, [:pointer, :long, :int64, :long, :int32, :int32, :long, :int32, :int32], :int32
    typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # C_VerifyRecover verifies a signature in a single-part
    # operation, where the data is recovered from the signature.
    # (Signing and MACing)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pSignature the signature to verify and the signature's length
    # (PKCS#11 param: CK_BYTE_PTR pSignature, CK_ULONG ulSignatureLen)
    # @return the recovered data and the recovered data's length
    # (PKCS#11 param: CK_BYTE_PTR pData, CK_ULONG_PTR pulDataLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pSignature <> null)
    # @postconditions (result <> null)
    def _c_verify_recover(h_session, in_, in_ofs, in_len, out, out_oufs, out_len)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1VerifyRecover, JNI.env, self.jni_id, h_session.to_int, in_.jni_id, in_ofs.to_int, in_len.to_int, out.jni_id, out_oufs.to_int, out_len.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GenerateKey, [:pointer, :long, :int64, :long, :long], :int64
    typesig { [::Java::Long, CK_MECHANISM, Array.typed(CK_ATTRIBUTE)] }
    # *****************************************************************************
    # Dual-function cryptographic operations
    # 
    # 
    # C_DigestEncryptUpdate continues a multiple-part digesting
    # and encryption operation.
    # (Dual-function cryptographic operations)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pPart the data part to digest and to encrypt and the data's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG ulPartLen)
    # @return the digested and encrypted data part and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedPart,
    # CK_ULONG_PTR pulEncryptedPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pPart <> null)
    # @postconditions
    # 
    # public native byte[] C_DigestEncryptUpdate(long hSession, byte[] pPart) throws PKCS11Exception;
    # 
    # C_DecryptDigestUpdate continues a multiple-part decryption and
    # digesting operation.
    # (Dual-function cryptographic operations)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pEncryptedPart the encrypted data part to decrypt and to digest
    # and encrypted data part's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedPart,
    # CK_ULONG ulEncryptedPartLen)
    # @return the decrypted and digested data part and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG_PTR pulPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pEncryptedPart <> null)
    # @postconditions
    # 
    # public native byte[] C_DecryptDigestUpdate(long hSession, byte[] pEncryptedPart) throws PKCS11Exception;
    # 
    # C_SignEncryptUpdate continues a multiple-part signing and
    # encryption operation.
    # (Dual-function cryptographic operations)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pPart the data part to sign and to encrypt and the data part's
    # length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG ulPartLen)
    # @return the signed and encrypted data part and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedPart,
    # CK_ULONG_PTR pulEncryptedPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pPart <> null)
    # @postconditions
    # 
    # public native byte[] C_SignEncryptUpdate(long hSession, byte[] pPart) throws PKCS11Exception;
    # 
    # C_DecryptVerifyUpdate continues a multiple-part decryption and
    # verify operation.
    # (Dual-function cryptographic operations)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pEncryptedPart the encrypted data part to decrypt and to verify
    # and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pEncryptedPart,
    # CK_ULONG ulEncryptedPartLen)
    # @return the decrypted and verified data part and the data part's length
    # (PKCS#11 param: CK_BYTE_PTR pPart, CK_ULONG_PTR pulPartLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pEncryptedPart <> null)
    # @postconditions
    # 
    # public native byte[] C_DecryptVerifyUpdate(long hSession, byte[] pEncryptedPart) throws PKCS11Exception;
    # *****************************************************************************
    # Key management
    # 
    # 
    # C_GenerateKey generates a secret key, creating a new key
    # object.
    # (Key management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the key generation mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param pTemplate the template for the new key and the number of
    # attributes in the template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @return the handle of the new key
    # (PKCS#11 param: CK_OBJECT_HANDLE_PTR phKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_generate_key(h_session, p_mechanism, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GenerateKey, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GenerateKeyPair, [:pointer, :long, :int64, :long, :long, :long], :long
    typesig { [::Java::Long, CK_MECHANISM, Array.typed(CK_ATTRIBUTE), Array.typed(CK_ATTRIBUTE)] }
    # C_GenerateKeyPair generates a public-key/private-key pair,
    # creating new key objects.
    # (Key management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the key generation mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param pPublicKeyTemplate the template for the new public key and the
    # number of attributes in the template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pPublicKeyTemplate,
    # CK_ULONG ulPublicKeyAttributeCount)
    # @param pPrivateKeyTemplate the template for the new private key and the
    # number of attributes in the template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pPrivateKeyTemplate
    # CK_ULONG ulPrivateKeyAttributeCount)
    # @return a long array with exactly two elements and the public key handle
    # as the first element and the private key handle as the second
    # element
    # (PKCS#11 param: CK_OBJECT_HANDLE_PTR phPublicKey,
    # CK_OBJECT_HANDLE_PTR phPrivateKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pMechanism <> null)
    # @postconditions (result <> null) and (result.length == 2)
    def _c_generate_key_pair(h_session, p_mechanism, p_public_key_template, p_private_key_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GenerateKeyPair, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, p_public_key_template.jni_id, p_private_key_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1WrapKey, [:pointer, :long, :int64, :long, :int64, :int64], :long
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long, ::Java::Long] }
    # C_WrapKey wraps (i.e., encrypts) a key.
    # (Key management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the wrapping mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hWrappingKey the handle of the wrapping key
    # (PKCS#11 param: CK_OBJECT_HANDLE hWrappingKey)
    # @param hKey the handle of the key to be wrapped
    # (PKCS#11 param: CK_OBJECT_HANDLE hKey)
    # @return the wrapped key and the length of the wrapped key
    # (PKCS#11 param: CK_BYTE_PTR pWrappedKey,
    # CK_ULONG_PTR pulWrappedKeyLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions (result <> null)
    def _c_wrap_key(h_session, p_mechanism, h_wrapping_key, h_key)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1WrapKey, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_wrapping_key.to_int, h_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1UnwrapKey, [:pointer, :long, :int64, :long, :int64, :long, :long], :int64
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long, Array.typed(::Java::Byte), Array.typed(CK_ATTRIBUTE)] }
    # C_UnwrapKey unwraps (decrypts) a wrapped key, creating a new
    # key object.
    # (Key management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the unwrapping mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hUnwrappingKey the handle of the unwrapping key
    # (PKCS#11 param: CK_OBJECT_HANDLE hUnwrappingKey)
    # @param pWrappedKey the wrapped key to unwrap and the wrapped key's length
    # (PKCS#11 param: CK_BYTE_PTR pWrappedKey, CK_ULONG ulWrappedKeyLen)
    # @param pTemplate the template for the new key and the number of
    # attributes in the template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @return the handle of the unwrapped key
    # (PKCS#11 param: CK_OBJECT_HANDLE_PTR phKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pWrappedKey <> null)
    # @postconditions
    def _c_unwrap_key(h_session, p_mechanism, h_unwrapping_key, p_wrapped_key, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1UnwrapKey, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_unwrapping_key.to_int, p_wrapped_key.jni_id, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1DeriveKey, [:pointer, :long, :int64, :long, :int64, :long], :int64
    typesig { [::Java::Long, CK_MECHANISM, ::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # C_DeriveKey derives a key from a base key, creating a new key
    # object.
    # (Key management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pMechanism the key derivation mechanism
    # (PKCS#11 param: CK_MECHANISM_PTR pMechanism)
    # @param hBaseKey the handle of the base key
    # (PKCS#11 param: CK_OBJECT_HANDLE hBaseKey)
    # @param pTemplate the template for the new key and the number of
    # attributes in the template
    # (PKCS#11 param: CK_ATTRIBUTE_PTR pTemplate, CK_ULONG ulCount)
    # @return the handle of the derived key
    # (PKCS#11 param: CK_OBJECT_HANDLE_PTR phKey)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    def _c_derive_key(h_session, p_mechanism, h_base_key, p_template)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1DeriveKey, JNI.env, self.jni_id, h_session.to_int, p_mechanism.jni_id, h_base_key.to_int, p_template.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1SeedRandom, [:pointer, :long, :int64, :long], :void
    typesig { [::Java::Long, Array.typed(::Java::Byte)] }
    # *****************************************************************************
    # Random number generation
    # 
    # 
    # C_SeedRandom mixes additional seed material into the token's
    # random number generator.
    # (Random number generation)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param pSeed the seed material and the seed material's length
    # (PKCS#11 param: CK_BYTE_PTR pSeed, CK_ULONG ulSeedLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pSeed <> null)
    # @postconditions
    def _c_seed_random(h_session, p_seed)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1SeedRandom, JNI.env, self.jni_id, h_session.to_int, p_seed.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_pkcs11_wrapper_PKCS11_C_1GenerateRandom, [:pointer, :long, :int64, :long], :void
    typesig { [::Java::Long, Array.typed(::Java::Byte)] }
    # C_GenerateRandom generates random data.
    # (Random number generation)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @param RandomData receives the random data and the length of RandomData
    # is the length of random data to be generated
    # (PKCS#11 param: CK_BYTE_PTR pRandomData, CK_ULONG ulRandomLen)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (randomData <> null)
    # @postconditions
    def _c_generate_random(h_session, random_data)
      JNI.call_native_method(:Java_sun_security_pkcs11_wrapper_PKCS11_C_1GenerateRandom, JNI.env, self.jni_id, h_session.to_int, random_data.jni_id)
    end
    
    typesig { [] }
    # *****************************************************************************
    # Parallel function management
    # 
    # 
    # C_GetFunctionStatus is a legacy function; it obtains an
    # updated status of a function running in parallel with an
    # application.
    # (Parallel function management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native void C_GetFunctionStatus(long hSession) throws PKCS11Exception;
    # 
    # C_CancelFunction is a legacy function; it cancels a function
    # running in parallel.
    # (Parallel function management)
    # 
    # @param hSession the session's handle
    # (PKCS#11 param: CK_SESSION_HANDLE hSession)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions
    # @postconditions
    # 
    # public native void C_CancelFunction(long hSession) throws PKCS11Exception;
    # *****************************************************************************
    # Functions added in for Cryptoki Version 2.01 or later
    # 
    # 
    # C_WaitForSlotEvent waits for a slot event (token insertion,
    # removal, etc.) to occur.
    # (General-purpose)
    # 
    # @param flags blocking/nonblocking flag
    # (PKCS#11 param: CK_FLAGS flags)
    # @param pReserved reserved. Should be null
    # (PKCS#11 param: CK_VOID_PTR pReserved)
    # @return the slot ID where the event occured
    # (PKCS#11 param: CK_SLOT_ID_PTR pSlot)
    # @exception PKCS11Exception If function returns other value than CKR_OK.
    # @preconditions (pRserved == null)
    # @postconditions
    # 
    # public native long C_WaitForSlotEvent(long flags, Object pRserved) throws PKCS11Exception;
    # 
    # Returns the string representation of this object.
    # 
    # @return The string representation of object
    def to_s
      return "Module name: " + @pkcs11module_path
    end
    
    typesig { [] }
    # Calls disconnect() to cleanup the native part of the wrapper. Once this
    # method is called, this object cannot be used any longer. Any subsequent
    # call to a C_* method will result in a runtime exception.
    # 
    # @exception Throwable If finalization fails.
    def finalize
      disconnect
    end
    
    class_module.module_eval {
      # PKCS11 subclass that has all methods synchronized and delegating to the
      # parent. Used for tokens that only support single threaded access
      const_set_lazy(:SynchronizedPKCS11) { Class.new(PKCS11) do
        include_class_members PKCS11
        
        typesig { [String, String] }
        def initialize(pkcs11module_path, function_list_name)
          super(pkcs11module_path, function_list_name)
        end
        
        typesig { [Object] }
        def _c_initialize(p_init_args)
          synchronized(self) do
            super(p_init_args)
          end
        end
        
        typesig { [Object] }
        def _c_finalize(p_reserved)
          synchronized(self) do
            super(p_reserved)
          end
        end
        
        typesig { [] }
        def _c_get_info
          synchronized(self) do
            return super
          end
        end
        
        typesig { [::Java::Boolean] }
        def _c_get_slot_list(token_present)
          synchronized(self) do
            return super(token_present)
          end
        end
        
        typesig { [::Java::Long] }
        def _c_get_slot_info(slot_id)
          synchronized(self) do
            return super(slot_id)
          end
        end
        
        typesig { [::Java::Long] }
        def _c_get_token_info(slot_id)
          synchronized(self) do
            return super(slot_id)
          end
        end
        
        typesig { [::Java::Long] }
        def _c_get_mechanism_list(slot_id)
          synchronized(self) do
            return super(slot_id)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long] }
        def _c_get_mechanism_info(slot_id, type)
          synchronized(self) do
            return super(slot_id, type)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Object, class_self::CK_NOTIFY] }
        def _c_open_session(slot_id, flags, p_application, notify)
          synchronized(self) do
            return super(slot_id, flags, p_application, notify)
          end
        end
        
        typesig { [::Java::Long] }
        def _c_close_session(h_session)
          synchronized(self) do
            super(h_session)
          end
        end
        
        typesig { [::Java::Long] }
        def _c_get_session_info(h_session)
          synchronized(self) do
            return super(h_session)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Char)] }
        def _c_login(h_session, user_type, p_pin)
          synchronized(self) do
            super(h_session, user_type, p_pin)
          end
        end
        
        typesig { [::Java::Long] }
        def _c_logout(h_session)
          synchronized(self) do
            super(h_session)
          end
        end
        
        typesig { [::Java::Long, Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_create_object(h_session, p_template)
          synchronized(self) do
            return super(h_session, p_template)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_copy_object(h_session, h_object, p_template)
          synchronized(self) do
            return super(h_session, h_object, p_template)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long] }
        def _c_destroy_object(h_session, h_object)
          synchronized(self) do
            super(h_session, h_object)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_get_attribute_value(h_session, h_object, p_template)
          synchronized(self) do
            super(h_session, h_object, p_template)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_set_attribute_value(h_session, h_object, p_template)
          synchronized(self) do
            super(h_session, h_object, p_template)
          end
        end
        
        typesig { [::Java::Long, Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_find_objects_init(h_session, p_template)
          synchronized(self) do
            super(h_session, p_template)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long] }
        def _c_find_objects(h_session, ul_max_object_count)
          synchronized(self) do
            return super(h_session, ul_max_object_count)
          end
        end
        
        typesig { [::Java::Long] }
        def _c_find_objects_final(h_session)
          synchronized(self) do
            super(h_session)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long] }
        def _c_encrypt_init(h_session, p_mechanism, h_key)
          synchronized(self) do
            super(h_session, p_mechanism, h_key)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_encrypt(h_session, in_, in_ofs, in_len, out, out_ofs, out_len)
          synchronized(self) do
            return super(h_session, in_, in_ofs, in_len, out, out_ofs, out_len)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_encrypt_update(h_session, direct_in, in_, in_ofs, in_len, direct_out, out, out_ofs, out_len)
          synchronized(self) do
            return super(h_session, direct_in, in_, in_ofs, in_len, direct_out, out, out_ofs, out_len)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_encrypt_final(h_session, direct_out, out, out_ofs, out_len)
          synchronized(self) do
            return super(h_session, direct_out, out, out_ofs, out_len)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long] }
        def _c_decrypt_init(h_session, p_mechanism, h_key)
          synchronized(self) do
            super(h_session, p_mechanism, h_key)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_decrypt(h_session, in_, in_ofs, in_len, out, out_ofs, out_len)
          synchronized(self) do
            return super(h_session, in_, in_ofs, in_len, out, out_ofs, out_len)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_decrypt_update(h_session, direct_in, in_, in_ofs, in_len, direct_out, out, out_ofs, out_len)
          synchronized(self) do
            return super(h_session, direct_in, in_, in_ofs, in_len, direct_out, out, out_ofs, out_len)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_decrypt_final(h_session, direct_out, out, out_ofs, out_len)
          synchronized(self) do
            return super(h_session, direct_out, out, out_ofs, out_len)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM] }
        def _c_digest_init(h_session, p_mechanism)
          synchronized(self) do
            super(h_session, p_mechanism)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_digest_single(h_session, p_mechanism, in_, in_ofs, in_len, digest, digest_ofs, digest_len)
          synchronized(self) do
            return super(h_session, p_mechanism, in_, in_ofs, in_len, digest, digest_ofs, digest_len)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_digest_update(h_session, direct_in, in_, in_ofs, in_len)
          synchronized(self) do
            super(h_session, direct_in, in_, in_ofs, in_len)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long] }
        def _c_digest_key(h_session, h_key)
          synchronized(self) do
            super(h_session, h_key)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_digest_final(h_session, p_digest, digest_ofs, digest_len)
          synchronized(self) do
            return super(h_session, p_digest, digest_ofs, digest_len)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long] }
        def _c_sign_init(h_session, p_mechanism, h_key)
          synchronized(self) do
            super(h_session, p_mechanism, h_key)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte)] }
        def _c_sign(h_session, p_data)
          synchronized(self) do
            return super(h_session, p_data)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_sign_update(h_session, direct_in, in_, in_ofs, in_len)
          synchronized(self) do
            super(h_session, direct_in, in_, in_ofs, in_len)
          end
        end
        
        typesig { [::Java::Long, ::Java::Int] }
        def _c_sign_final(h_session, expected_len)
          synchronized(self) do
            return super(h_session, expected_len)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long] }
        def _c_sign_recover_init(h_session, p_mechanism, h_key)
          synchronized(self) do
            super(h_session, p_mechanism, h_key)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_sign_recover(h_session, in_, in_ofs, in_len, out, out_oufs, out_len)
          synchronized(self) do
            return super(h_session, in_, in_ofs, in_len, out, out_oufs, out_len)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long] }
        def _c_verify_init(h_session, p_mechanism, h_key)
          synchronized(self) do
            super(h_session, p_mechanism, h_key)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
        def _c_verify(h_session, p_data, p_signature)
          synchronized(self) do
            super(h_session, p_data, p_signature)
          end
        end
        
        typesig { [::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_verify_update(h_session, direct_in, in_, in_ofs, in_len)
          synchronized(self) do
            super(h_session, direct_in, in_, in_ofs, in_len)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte)] }
        def _c_verify_final(h_session, p_signature)
          synchronized(self) do
            super(h_session, p_signature)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long] }
        def _c_verify_recover_init(h_session, p_mechanism, h_key)
          synchronized(self) do
            super(h_session, p_mechanism, h_key)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def _c_verify_recover(h_session, in_, in_ofs, in_len, out, out_oufs, out_len)
          synchronized(self) do
            return super(h_session, in_, in_ofs, in_len, out, out_oufs, out_len)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_generate_key(h_session, p_mechanism, p_template)
          synchronized(self) do
            return super(h_session, p_mechanism, p_template)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, Array.typed(class_self::CK_ATTRIBUTE), Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_generate_key_pair(h_session, p_mechanism, p_public_key_template, p_private_key_template)
          synchronized(self) do
            return super(h_session, p_mechanism, p_public_key_template, p_private_key_template)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long, ::Java::Long] }
        def _c_wrap_key(h_session, p_mechanism, h_wrapping_key, h_key)
          synchronized(self) do
            return super(h_session, p_mechanism, h_wrapping_key, h_key)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long, Array.typed(::Java::Byte), Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_unwrap_key(h_session, p_mechanism, h_unwrapping_key, p_wrapped_key, p_template)
          synchronized(self) do
            return super(h_session, p_mechanism, h_unwrapping_key, p_wrapped_key, p_template)
          end
        end
        
        typesig { [::Java::Long, class_self::CK_MECHANISM, ::Java::Long, Array.typed(class_self::CK_ATTRIBUTE)] }
        def _c_derive_key(h_session, p_mechanism, h_base_key, p_template)
          synchronized(self) do
            return super(h_session, p_mechanism, h_base_key, p_template)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte)] }
        def _c_seed_random(h_session, p_seed)
          synchronized(self) do
            super(h_session, p_seed)
          end
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Byte)] }
        def _c_generate_random(h_session, random_data)
          synchronized(self) do
            super(h_session, random_data)
          end
        end
        
        private
        alias_method :initialize__synchronized_pkcs11, :initialize
      end }
    }
    
    private
    alias_method :initialize__pkcs11, :initialize
  end
  
end
