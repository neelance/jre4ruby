require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Prefs
  module WindowsPreferencesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :TreeMap
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Util::Logging, :Logger
    }
  end
  
  # Windows registry based implementation of  <tt>Preferences</tt>.
  # <tt>Preferences</tt>' <tt>systemRoot</tt> and <tt>userRoot</tt> are stored in
  # <tt>HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Prefs</tt> and
  # <tt>HKEY_CURRENT_USER\Software\JavaSoft\Prefs</tt> correspondingly.
  # 
  # @author  Konstantin Kladko
  # @see Preferences
  # @see PreferencesFactory
  # @since 1.4
  class WindowsPreferences < WindowsPreferencesImports.const_get :AbstractPreferences
    include_class_members WindowsPreferencesImports
    
    class_module.module_eval {
      # Logger for error messages
      
      def logger
        defined?(@@logger) ? @@logger : @@logger= nil
      end
      alias_method :attr_logger, :logger
      
      def logger=(value)
        @@logger = value
      end
      alias_method :attr_logger=, :logger=
      
      # Windows registry path to <tt>Preferences</tt>'s root nodes.
      const_set_lazy(:WINDOWS_ROOT_PATH) { string_to_byte_array("Software\\JavaSoft\\Prefs") }
      const_attr_reader  :WINDOWS_ROOT_PATH
      
      # Windows handles to <tt>HKEY_CURRENT_USER</tt> and
      # <tt>HKEY_LOCAL_MACHINE</tt> hives.
      const_set_lazy(:HKEY_CURRENT_USER) { -0x7fffffff }
      const_attr_reader  :HKEY_CURRENT_USER
      
      const_set_lazy(:HKEY_LOCAL_MACHINE) { -0x7ffffffe }
      const_attr_reader  :HKEY_LOCAL_MACHINE
      
      # Mount point for <tt>Preferences</tt>'  user root.
      const_set_lazy(:USER_ROOT_NATIVE_HANDLE) { HKEY_CURRENT_USER }
      const_attr_reader  :USER_ROOT_NATIVE_HANDLE
      
      # Mount point for <tt>Preferences</tt>'  system root.
      const_set_lazy(:SYSTEM_ROOT_NATIVE_HANDLE) { HKEY_LOCAL_MACHINE }
      const_attr_reader  :SYSTEM_ROOT_NATIVE_HANDLE
      
      # Maximum byte-encoded path length for Windows native functions,
      # ending <tt>null</tt> character not included.
      const_set_lazy(:MAX_WINDOWS_PATH_LENGTH) { 256 }
      const_attr_reader  :MAX_WINDOWS_PATH_LENGTH
      
      # User root node.
      const_set_lazy(:UserRoot) { WindowsPreferences.new(USER_ROOT_NATIVE_HANDLE, WINDOWS_ROOT_PATH) }
      const_attr_reader  :UserRoot
      
      # System root node.
      const_set_lazy(:SystemRoot) { WindowsPreferences.new(SYSTEM_ROOT_NATIVE_HANDLE, WINDOWS_ROOT_PATH) }
      const_attr_reader  :SystemRoot
      
      # Windows error codes.
      const_set_lazy(:ERROR_SUCCESS) { 0 }
      const_attr_reader  :ERROR_SUCCESS
      
      const_set_lazy(:ERROR_FILE_NOT_FOUND) { 2 }
      const_attr_reader  :ERROR_FILE_NOT_FOUND
      
      const_set_lazy(:ERROR_ACCESS_DENIED) { 5 }
      const_attr_reader  :ERROR_ACCESS_DENIED
      
      # Constants used to interpret returns of native functions
      const_set_lazy(:NATIVE_HANDLE) { 0 }
      const_attr_reader  :NATIVE_HANDLE
      
      const_set_lazy(:ERROR_CODE) { 1 }
      const_attr_reader  :ERROR_CODE
      
      const_set_lazy(:SUBKEYS_NUMBER) { 0 }
      const_attr_reader  :SUBKEYS_NUMBER
      
      const_set_lazy(:VALUES_NUMBER) { 2 }
      const_attr_reader  :VALUES_NUMBER
      
      const_set_lazy(:MAX_KEY_LENGTH) { 3 }
      const_attr_reader  :MAX_KEY_LENGTH
      
      const_set_lazy(:MAX_VALUE_NAME_LENGTH) { 4 }
      const_attr_reader  :MAX_VALUE_NAME_LENGTH
      
      const_set_lazy(:DISPOSITION) { 2 }
      const_attr_reader  :DISPOSITION
      
      const_set_lazy(:REG_CREATED_NEW_KEY) { 1 }
      const_attr_reader  :REG_CREATED_NEW_KEY
      
      const_set_lazy(:REG_OPENED_EXISTING_KEY) { 2 }
      const_attr_reader  :REG_OPENED_EXISTING_KEY
      
      const_set_lazy(:NULL_NATIVE_HANDLE) { 0 }
      const_attr_reader  :NULL_NATIVE_HANDLE
      
      # Windows security masks
      const_set_lazy(:DELETE) { 0x10000 }
      const_attr_reader  :DELETE
      
      const_set_lazy(:KEY_QUERY_VALUE) { 1 }
      const_attr_reader  :KEY_QUERY_VALUE
      
      const_set_lazy(:KEY_SET_VALUE) { 2 }
      const_attr_reader  :KEY_SET_VALUE
      
      const_set_lazy(:KEY_CREATE_SUB_KEY) { 4 }
      const_attr_reader  :KEY_CREATE_SUB_KEY
      
      const_set_lazy(:KEY_ENUMERATE_SUB_KEYS) { 8 }
      const_attr_reader  :KEY_ENUMERATE_SUB_KEYS
      
      const_set_lazy(:KEY_READ) { 0x20019 }
      const_attr_reader  :KEY_READ
      
      const_set_lazy(:KEY_WRITE) { 0x20006 }
      const_attr_reader  :KEY_WRITE
      
      const_set_lazy(:KEY_ALL_ACCESS) { 0xf003f }
      const_attr_reader  :KEY_ALL_ACCESS
      
      # Initial time between registry access attempts, in ms. The time is doubled
      # after each failing attempt (except the first).
      
      def init_sleep_time
        defined?(@@init_sleep_time) ? @@init_sleep_time : @@init_sleep_time= 50
      end
      alias_method :attr_init_sleep_time, :init_sleep_time
      
      def init_sleep_time=(value)
        @@init_sleep_time = value
      end
      alias_method :attr_init_sleep_time=, :init_sleep_time=
      
      # Maximum number of registry access attempts.
      
      def max_attempts
        defined?(@@max_attempts) ? @@max_attempts : @@max_attempts= 5
      end
      alias_method :attr_max_attempts, :max_attempts
      
      def max_attempts=(value)
        @@max_attempts = value
      end
      alias_method :attr_max_attempts=, :max_attempts=
    }
    
    # BackingStore availability flag.
    attr_accessor :is_backing_store_available
    alias_method :attr_is_backing_store_available, :is_backing_store_available
    undef_method :is_backing_store_available
    alias_method :attr_is_backing_store_available=, :is_backing_store_available=
    undef_method :is_backing_store_available=
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegOpenKey, [:pointer, :long, :int32, :long, :int32], :long
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
      # Java wrapper for Windows registry API RegOpenKey()
      def _windows_reg_open_key(h_key, sub_key, security_mask)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegOpenKey, JNI.env, self.jni_id, h_key.to_int, sub_key.jni_id, security_mask.to_int)
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
      # Retries RegOpenKey() MAX_ATTEMPTS times before giving up.
      def _windows_reg_open_key1(h_key, sub_key, security_mask)
        result = _windows_reg_open_key(h_key, sub_key, security_mask)
        if ((result[ERROR_CODE]).equal?(ERROR_SUCCESS))
          return result
        else
          if ((result[ERROR_CODE]).equal?(ERROR_FILE_NOT_FOUND))
            logger.warning("Trying to recreate Windows registry node " + RJava.cast_to_string(byte_array_to_string(sub_key)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(h_key)) + ".")
            # Try recreation
            handle = _windows_reg_create_key_ex(h_key, sub_key)[NATIVE_HANDLE]
            _windows_reg_close_key(handle)
            return _windows_reg_open_key(h_key, sub_key, security_mask)
          else
            if (!(result[ERROR_CODE]).equal?(ERROR_ACCESS_DENIED))
              sleep_time = self.attr_init_sleep_time
              i = 0
              while i < self.attr_max_attempts
                begin
                  JavaThread.sleep(sleep_time)
                rescue InterruptedException => e
                  return result
                end
                sleep_time *= 2
                result = _windows_reg_open_key(h_key, sub_key, security_mask)
                if ((result[ERROR_CODE]).equal?(ERROR_SUCCESS))
                  return result
                end
                i += 1
              end
            end
          end
        end
        return result
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegCloseKey, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      # Java wrapper for Windows registry API RegCloseKey()
      def _windows_reg_close_key(h_key)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegCloseKey, JNI.env, self.jni_id, h_key.to_int)
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegCreateKeyEx, [:pointer, :long, :int32, :long], :long
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      # Java wrapper for Windows registry API RegCreateKeyEx()
      def _windows_reg_create_key_ex(h_key, sub_key)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegCreateKeyEx, JNI.env, self.jni_id, h_key.to_int, sub_key.jni_id)
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      # Retries RegCreateKeyEx() MAX_ATTEMPTS times before giving up.
      def _windows_reg_create_key_ex1(h_key, sub_key)
        result = _windows_reg_create_key_ex(h_key, sub_key)
        if ((result[ERROR_CODE]).equal?(ERROR_SUCCESS))
          return result
        else
          sleep_time = self.attr_init_sleep_time
          i = 0
          while i < self.attr_max_attempts
            begin
              JavaThread.sleep(sleep_time)
            rescue InterruptedException => e
              return result
            end
            sleep_time *= 2
            result = _windows_reg_create_key_ex(h_key, sub_key)
            if ((result[ERROR_CODE]).equal?(ERROR_SUCCESS))
              return result
            end
            i += 1
          end
        end
        return result
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegDeleteKey, [:pointer, :long, :int32, :long], :int32
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      # Java wrapper for Windows registry API RegDeleteKey()
      def _windows_reg_delete_key(h_key, sub_key)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegDeleteKey, JNI.env, self.jni_id, h_key.to_int, sub_key.jni_id)
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegFlushKey, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      # Java wrapper for Windows registry API RegFlushKey()
      def _windows_reg_flush_key(h_key)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegFlushKey, JNI.env, self.jni_id, h_key.to_int)
      end
      
      typesig { [::Java::Int] }
      # Retries RegFlushKey() MAX_ATTEMPTS times before giving up.
      def _windows_reg_flush_key1(h_key)
        result = _windows_reg_flush_key(h_key)
        if ((result).equal?(ERROR_SUCCESS))
          return result
        else
          sleep_time = self.attr_init_sleep_time
          i = 0
          while i < self.attr_max_attempts
            begin
              JavaThread.sleep(sleep_time)
            rescue InterruptedException => e
              return result
            end
            sleep_time *= 2
            result = _windows_reg_flush_key(h_key)
            if ((result).equal?(ERROR_SUCCESS))
              return result
            end
            i += 1
          end
        end
        return result
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegQueryValueEx, [:pointer, :long, :int32, :long], :long
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      # Java wrapper for Windows registry API RegQueryValueEx()
      def _windows_reg_query_value_ex(h_key, value_name)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegQueryValueEx, JNI.env, self.jni_id, h_key.to_int, value_name.jni_id)
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegSetValueEx, [:pointer, :long, :int32, :long, :long], :int32
      typesig { [::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Java wrapper for Windows registry API RegSetValueEx()
      def _windows_reg_set_value_ex(h_key, value_name, value)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegSetValueEx, JNI.env, self.jni_id, h_key.to_int, value_name.jni_id, value.jni_id)
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Retries RegSetValueEx() MAX_ATTEMPTS times before giving up.
      def _windows_reg_set_value_ex1(h_key, value_name, value)
        result = _windows_reg_set_value_ex(h_key, value_name, value)
        if ((result).equal?(ERROR_SUCCESS))
          return result
        else
          sleep_time = self.attr_init_sleep_time
          i = 0
          while i < self.attr_max_attempts
            begin
              JavaThread.sleep(sleep_time)
            rescue InterruptedException => e
              return result
            end
            sleep_time *= 2
            result = _windows_reg_set_value_ex(h_key, value_name, value)
            if ((result).equal?(ERROR_SUCCESS))
              return result
            end
            i += 1
          end
        end
        return result
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegDeleteValue, [:pointer, :long, :int32, :long], :int32
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      # Java wrapper for Windows registry API RegDeleteValue()
      def _windows_reg_delete_value(h_key, value_name)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegDeleteValue, JNI.env, self.jni_id, h_key.to_int, value_name.jni_id)
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegQueryInfoKey, [:pointer, :long, :int32], :long
      typesig { [::Java::Int] }
      # Java wrapper for Windows registry API RegQueryInfoKey()
      def _windows_reg_query_info_key(h_key)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegQueryInfoKey, JNI.env, self.jni_id, h_key.to_int)
      end
      
      typesig { [::Java::Int] }
      # Retries RegQueryInfoKey() MAX_ATTEMPTS times before giving up.
      def _windows_reg_query_info_key1(h_key)
        result = _windows_reg_query_info_key(h_key)
        if ((result[ERROR_CODE]).equal?(ERROR_SUCCESS))
          return result
        else
          sleep_time = self.attr_init_sleep_time
          i = 0
          while i < self.attr_max_attempts
            begin
              JavaThread.sleep(sleep_time)
            rescue InterruptedException => e
              return result
            end
            sleep_time *= 2
            result = _windows_reg_query_info_key(h_key)
            if ((result[ERROR_CODE]).equal?(ERROR_SUCCESS))
              return result
            end
            i += 1
          end
        end
        return result
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegEnumKeyEx, [:pointer, :long, :int32, :int32, :int32], :long
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      # Java wrapper for Windows registry API RegEnumKeyEx()
      def _windows_reg_enum_key_ex(h_key, sub_key_index, max_key_length)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegEnumKeyEx, JNI.env, self.jni_id, h_key.to_int, sub_key_index.to_int, max_key_length.to_int)
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      # Retries RegEnumKeyEx() MAX_ATTEMPTS times before giving up.
      def _windows_reg_enum_key_ex1(h_key, sub_key_index, max_key_length)
        result = _windows_reg_enum_key_ex(h_key, sub_key_index, max_key_length)
        if (!(result).nil?)
          return result
        else
          sleep_time = self.attr_init_sleep_time
          i = 0
          while i < self.attr_max_attempts
            begin
              JavaThread.sleep(sleep_time)
            rescue InterruptedException => e
              return result
            end
            sleep_time *= 2
            result = _windows_reg_enum_key_ex(h_key, sub_key_index, max_key_length)
            if (!(result).nil?)
              return result
            end
            i += 1
          end
        end
        return result
      end
      
      JNI.load_native_method :Java_java_util_prefs_WindowsPreferences_WindowsRegEnumValue, [:pointer, :long, :int32, :int32, :int32], :long
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      # Java wrapper for Windows registry API RegEnumValue()
      def _windows_reg_enum_value(h_key, value_index, max_value_name_length)
        JNI.call_native_method(:Java_java_util_prefs_WindowsPreferences_WindowsRegEnumValue, JNI.env, self.jni_id, h_key.to_int, value_index.to_int, max_value_name_length.to_int)
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      # Retries RegEnumValueEx() MAX_ATTEMPTS times before giving up.
      def _windows_reg_enum_value1(h_key, value_index, max_value_name_length)
        result = _windows_reg_enum_value(h_key, value_index, max_value_name_length)
        if (!(result).nil?)
          return result
        else
          sleep_time = self.attr_init_sleep_time
          i = 0
          while i < self.attr_max_attempts
            begin
              JavaThread.sleep(sleep_time)
            rescue InterruptedException => e
              return result
            end
            sleep_time *= 2
            result = _windows_reg_enum_value(h_key, value_index, max_value_name_length)
            if (!(result).nil?)
              return result
            end
            i += 1
          end
        end
        return result
      end
    }
    
    typesig { [WindowsPreferences, String] }
    # Constructs a <tt>WindowsPreferences</tt> node, creating underlying
    # Windows registry node and all its Windows parents, if they are not yet
    # created.
    # Logs a warning message, if Windows Registry is unavailable.
    def initialize(parent, name)
      @is_backing_store_available = false
      super(parent, name)
      @is_backing_store_available = true
      parent_native_handle = parent.open_key(KEY_CREATE_SUB_KEY, KEY_READ)
      if ((parent_native_handle).equal?(NULL_NATIVE_HANDLE))
        # if here, openKey failed and logged
        @is_backing_store_available = false
        return
      end
      result = _windows_reg_create_key_ex1(parent_native_handle, to_windows_name(name))
      if (!(result[ERROR_CODE]).equal?(ERROR_SUCCESS))
        logger.warning("Could not create windows registry " + "node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegCreateKeyEx(...) returned error code " + RJava.cast_to_string(result[ERROR_CODE]) + ".")
        @is_backing_store_available = false
        return
      end
      self.attr_new_node = ((result[DISPOSITION]).equal?(REG_CREATED_NEW_KEY))
      close_key(parent_native_handle)
      close_key(result[NATIVE_HANDLE])
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # Constructs a root node creating the underlying
    # Windows registry node and all of its parents, if they have not yet been
    # created.
    # Logs a warning message, if Windows Registry is unavailable.
    # @param rootNativeHandle Native handle to one of Windows top level keys.
    # @param rootDirectory Path to root directory, as a byte-encoded string.
    def initialize(root_native_handle_, root_directory)
      @is_backing_store_available = false
      super(nil, "")
      @is_backing_store_available = true
      result = _windows_reg_create_key_ex1(root_native_handle_, root_directory)
      if (!(result[ERROR_CODE]).equal?(ERROR_SUCCESS))
        logger.warning("Could not open/create prefs root node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegCreateKeyEx(...) returned error code " + RJava.cast_to_string(result[ERROR_CODE]) + ".")
        @is_backing_store_available = false
        return
      end
      # Check if a new node
      self.attr_new_node = ((result[DISPOSITION]).equal?(REG_CREATED_NEW_KEY))
      close_key(result[NATIVE_HANDLE])
    end
    
    typesig { [] }
    # Returns Windows absolute path of the current node as a byte array.
    # Java "/" separator is transformed into Windows "\".
    # @see Preferences#absolutePath()
    def windows_absolute_path
      bstream = ByteArrayOutputStream.new
      bstream.write(WINDOWS_ROOT_PATH, 0, WINDOWS_ROOT_PATH.attr_length - 1)
      tokenizer = StringTokenizer.new(absolute_path, "/")
      while (tokenizer.has_more_tokens)
        bstream.write(Character.new(?\\.ord))
        next_name = tokenizer.next_token
        windows_next_name = to_windows_name(next_name)
        bstream.write(windows_next_name, 0, windows_next_name.attr_length - 1)
      end
      bstream.write(0)
      return bstream.to_byte_array
    end
    
    typesig { [::Java::Int] }
    # Opens current node's underlying Windows registry key using a
    # given security mask.
    # @param securityMask Windows security mask.
    # @return Windows registry key's handle.
    # @see #openKey(byte[], int)
    # @see #openKey(int, byte[], int)
    # @see #closeKey(int)
    def open_key(security_mask)
      return open_key(security_mask, security_mask)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Opens current node's underlying Windows registry key using a
    # given security mask.
    # @param mask1 Preferred Windows security mask.
    # @param mask2 Alternate Windows security mask.
    # @return Windows registry key's handle.
    # @see #openKey(byte[], int)
    # @see #openKey(int, byte[], int)
    # @see #closeKey(int)
    def open_key(mask1, mask2)
      return open_key(windows_absolute_path, mask1, mask2)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Opens Windows registry key at a given absolute path using a given
    # security mask.
    # @param windowsAbsolutePath Windows absolute path of the
    # key as a byte-encoded string.
    # @param mask1 Preferred Windows security mask.
    # @param mask2 Alternate Windows security mask.
    # @return Windows registry key's handle.
    # @see #openKey(int)
    # @see #openKey(int, byte[],int)
    # @see #closeKey(int)
    def open_key(windows_absolute_path_, mask1, mask2)
      # Check if key's path is short enough be opened at once
      # otherwise use a path-splitting procedure
      if (windows_absolute_path_.attr_length <= MAX_WINDOWS_PATH_LENGTH + 1)
        result = _windows_reg_open_key1(root_native_handle, windows_absolute_path_, mask1)
        if ((result[ERROR_CODE]).equal?(ERROR_ACCESS_DENIED) && !(mask2).equal?(mask1))
          result = _windows_reg_open_key1(root_native_handle, windows_absolute_path_, mask2)
        end
        if (!(result[ERROR_CODE]).equal?(ERROR_SUCCESS))
          logger.warning("Could not open windows " + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegOpenKey(...) returned error code " + RJava.cast_to_string(result[ERROR_CODE]) + ".")
          result[NATIVE_HANDLE] = NULL_NATIVE_HANDLE
          if ((result[ERROR_CODE]).equal?(ERROR_ACCESS_DENIED))
            raise SecurityException.new("Could not open windows " + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ": Access denied")
          end
        end
        return result[NATIVE_HANDLE]
      else
        return open_key(root_native_handle, windows_absolute_path_, mask1, mask2)
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Opens Windows registry key at a given relative path
    # with respect to a given Windows registry key.
    # @param windowsAbsolutePath Windows relative path of the
    # key as a byte-encoded string.
    # @param nativeHandle handle to the base Windows key.
    # @param mask1 Preferred Windows security mask.
    # @param mask2 Alternate Windows security mask.
    # @return Windows registry key's handle.
    # @see #openKey(int)
    # @see #openKey(byte[],int)
    # @see #closeKey(int)
    def open_key(native_handle, windows_relative_path, mask1, mask2)
      # If the path is short enough open at once. Otherwise split the path
      if (windows_relative_path.attr_length <= MAX_WINDOWS_PATH_LENGTH + 1)
        result = _windows_reg_open_key1(native_handle, windows_relative_path, mask1)
        if ((result[ERROR_CODE]).equal?(ERROR_ACCESS_DENIED) && !(mask2).equal?(mask1))
          result = _windows_reg_open_key1(native_handle, windows_relative_path, mask2)
        end
        if (!(result[ERROR_CODE]).equal?(ERROR_SUCCESS))
          logger.warning("Could not open windows " + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(native_handle)) + ". Windows RegOpenKey(...) returned error code " + RJava.cast_to_string(result[ERROR_CODE]) + ".")
          result[NATIVE_HANDLE] = NULL_NATIVE_HANDLE
        end
        return result[NATIVE_HANDLE]
      else
        separator_position = -1
        # Be greedy - open the longest possible path
        i = MAX_WINDOWS_PATH_LENGTH
        while i > 0
          if ((windows_relative_path[i]).equal?((Character.new(?\\.ord))))
            separator_position = i
            break
          end
          i -= 1
        end
        # Split the path and do the recursion
        next_relative_root = Array.typed(::Java::Byte).new(separator_position + 1) { 0 }
        System.arraycopy(windows_relative_path, 0, next_relative_root, 0, separator_position)
        next_relative_root[separator_position] = 0
        next_relative_path = Array.typed(::Java::Byte).new(windows_relative_path.attr_length - separator_position - 1) { 0 }
        System.arraycopy(windows_relative_path, separator_position + 1, next_relative_path, 0, next_relative_path.attr_length)
        next_native_handle = open_key(native_handle, next_relative_root, mask1, mask2)
        if ((next_native_handle).equal?(NULL_NATIVE_HANDLE))
          return NULL_NATIVE_HANDLE
        end
        result = open_key(next_native_handle, next_relative_path, mask1, mask2)
        close_key(next_native_handle)
        return result
      end
    end
    
    typesig { [::Java::Int] }
    # Closes Windows registry key.
    # Logs a warning if Windows registry is unavailable.
    # @param key's Windows registry handle.
    # @see #openKey(int)
    # @see #openKey(byte[],int)
    # @see #openKey(int, byte[],int)
    def close_key(native_handle)
      result = _windows_reg_close_key(native_handle)
      if (!(result).equal?(ERROR_SUCCESS))
        logger.warning("Could not close windows " + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegCloseKey(...) returned error code " + RJava.cast_to_string(result) + ".")
      end
    end
    
    typesig { [String, String] }
    # Implements <tt>AbstractPreferences</tt> <tt>putSpi()</tt> method.
    # Puts name-value pair into the underlying Windows registry node.
    # Logs a warning, if Windows registry is unavailable.
    # @see #getSpi(String)
    def put_spi(java_name, value)
      native_handle = open_key(KEY_SET_VALUE)
      if ((native_handle).equal?(NULL_NATIVE_HANDLE))
        @is_backing_store_available = false
        return
      end
      result = _windows_reg_set_value_ex1(native_handle, to_windows_name(java_name), to_windows_value_string(value))
      if (!(result).equal?(ERROR_SUCCESS))
        logger.warning("Could not assign value to key " + RJava.cast_to_string(byte_array_to_string(to_windows_name(java_name))) + " at Windows registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegSetValueEx(...) returned error code " + RJava.cast_to_string(result) + ".")
        @is_backing_store_available = false
      end
      close_key(native_handle)
    end
    
    typesig { [String] }
    # Implements <tt>AbstractPreferences</tt> <tt>getSpi()</tt> method.
    # Gets a string value from the underlying Windows registry node.
    # Logs a warning, if Windows registry is unavailable.
    # @see #putSpi(String, String)
    def get_spi(java_name)
      native_handle = open_key(KEY_QUERY_VALUE)
      if ((native_handle).equal?(NULL_NATIVE_HANDLE))
        return nil
      end
      result_object = _windows_reg_query_value_ex(native_handle, to_windows_name(java_name))
      if ((result_object).nil?)
        close_key(native_handle)
        return nil
      end
      close_key(native_handle)
      return to_java_value_string(result_object)
    end
    
    typesig { [String] }
    # Implements <tt>AbstractPreferences</tt> <tt>removeSpi()</tt> method.
    # Deletes a string name-value pair from the underlying Windows registry
    # node, if this value still exists.
    # Logs a warning, if Windows registry is unavailable or key has already
    # been deleted.
    def remove_spi(key)
      native_handle = open_key(KEY_SET_VALUE)
      if ((native_handle).equal?(NULL_NATIVE_HANDLE))
        return
      end
      result = _windows_reg_delete_value(native_handle, to_windows_name(key))
      if (!(result).equal?(ERROR_SUCCESS) && !(result).equal?(ERROR_FILE_NOT_FOUND))
        logger.warning("Could not delete windows registry " + "value " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + "\\" + RJava.cast_to_string(to_windows_name(key)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegDeleteValue(...) returned error code " + RJava.cast_to_string(result) + ".")
        @is_backing_store_available = false
      end
      close_key(native_handle)
    end
    
    typesig { [] }
    # Implements <tt>AbstractPreferences</tt> <tt>keysSpi()</tt> method.
    # Gets value names from the underlying Windows registry node.
    # Throws a BackingStoreException and logs a warning, if
    # Windows registry is unavailable.
    def keys_spi
      # Find out the number of values
      native_handle = open_key(KEY_QUERY_VALUE)
      if ((native_handle).equal?(NULL_NATIVE_HANDLE))
        raise BackingStoreException.new("Could not open windows" + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ".")
      end
      result = _windows_reg_query_info_key1(native_handle)
      if (!(result[ERROR_CODE]).equal?(ERROR_SUCCESS))
        info = "Could not query windows" + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegQueryInfoKeyEx(...) returned error code " + RJava.cast_to_string(result[ERROR_CODE]) + "."
        logger.warning(info)
        raise BackingStoreException.new(info)
      end
      max_value_name_length = result[MAX_VALUE_NAME_LENGTH]
      values_number = result[VALUES_NUMBER]
      if ((values_number).equal?(0))
        close_key(native_handle)
        return Array.typed(String).new(0) { nil }
      end
      # Get the values
      value_names = Array.typed(String).new(values_number) { nil }
      i = 0
      while i < values_number
        windows_name = _windows_reg_enum_value1(native_handle, i, max_value_name_length + 1)
        if ((windows_name).nil?)
          info = "Could not enumerate value #" + RJava.cast_to_string(i) + "  of windows node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + "."
          logger.warning(info)
          raise BackingStoreException.new(info)
        end
        value_names[i] = to_java_name(windows_name)
        i += 1
      end
      close_key(native_handle)
      return value_names
    end
    
    typesig { [] }
    # Implements <tt>AbstractPreferences</tt> <tt>childrenNamesSpi()</tt> method.
    # Calls Windows registry to retrive children of this node.
    # Throws a BackingStoreException and logs a warning message,
    # if Windows registry is not available.
    def children_names_spi
      # Open key
      native_handle = open_key(KEY_ENUMERATE_SUB_KEYS | KEY_QUERY_VALUE)
      if ((native_handle).equal?(NULL_NATIVE_HANDLE))
        raise BackingStoreException.new("Could not open windows" + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ".")
      end
      # Get number of children
      result = _windows_reg_query_info_key1(native_handle)
      if (!(result[ERROR_CODE]).equal?(ERROR_SUCCESS))
        info = "Could not query windows" + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegQueryInfoKeyEx(...) returned error code " + RJava.cast_to_string(result[ERROR_CODE]) + "."
        logger.warning(info)
        raise BackingStoreException.new(info)
      end
      max_key_length = result[MAX_KEY_LENGTH]
      sub_keys_number = result[SUBKEYS_NUMBER]
      if ((sub_keys_number).equal?(0))
        close_key(native_handle)
        return Array.typed(String).new(0) { nil }
      end
      subkeys = Array.typed(String).new(sub_keys_number) { nil }
      children = Array.typed(String).new(sub_keys_number) { nil }
      # Get children
      i = 0
      while i < sub_keys_number
        windows_name = _windows_reg_enum_key_ex1(native_handle, i, max_key_length + 1)
        if ((windows_name).nil?)
          info = "Could not enumerate key #" + RJava.cast_to_string(i) + "  of windows node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". "
          logger.warning(info)
          raise BackingStoreException.new(info)
        end
        java_name = to_java_name(windows_name)
        children[i] = java_name
        i += 1
      end
      close_key(native_handle)
      return children
    end
    
    typesig { [] }
    # Implements <tt>Preferences</tt> <tt>flush()</tt> method.
    # Flushes Windows registry changes to disk.
    # Throws a BackingStoreException and logs a warning message if Windows
    # registry is not available.
    def flush
      if (is_removed)
        self.attr_parent.flush
        return
      end
      if (!@is_backing_store_available)
        raise BackingStoreException.new("flush(): Backing store not available.")
      end
      native_handle = open_key(KEY_READ)
      if ((native_handle).equal?(NULL_NATIVE_HANDLE))
        raise BackingStoreException.new("Could not open windows" + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ".")
      end
      result = _windows_reg_flush_key1(native_handle)
      if (!(result).equal?(ERROR_SUCCESS))
        info = "Could not flush windows " + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegFlushKey(...) returned error code " + RJava.cast_to_string(result) + "."
        logger.warning(info)
        raise BackingStoreException.new(info)
      end
      close_key(native_handle)
    end
    
    typesig { [] }
    # Implements <tt>Preferences</tt> <tt>sync()</tt> method.
    # Flushes Windows registry changes to disk. Equivalent to flush().
    # @see flush()
    def sync
      if (is_removed)
        raise IllegalStateException.new("Node has been removed")
      end
      flush
    end
    
    typesig { [String] }
    # Implements <tt>AbstractPreferences</tt> <tt>childSpi()</tt> method.
    # Constructs a child node with a
    # given name and creates its underlying Windows registry node,
    # if it does not exist.
    # Logs a warning message, if Windows Registry is unavailable.
    def child_spi(name)
      return WindowsPreferences.new(self, name)
    end
    
    typesig { [] }
    # Implements <tt>AbstractPreferences</tt> <tt>removeNodeSpi()</tt> method.
    # Deletes underlying Windows registry node.
    # Throws a BackingStoreException and logs a warning, if Windows registry
    # is not available.
    def remove_node_spi
      parent_native_handle = (parent).open_key(DELETE)
      if ((parent_native_handle).equal?(NULL_NATIVE_HANDLE))
        raise BackingStoreException.new("Could not open parent windows" + "registry node of " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ".")
      end
      result = _windows_reg_delete_key(parent_native_handle, to_windows_name(name))
      if (!(result).equal?(ERROR_SUCCESS))
        info = "Could not delete windows " + "registry node " + RJava.cast_to_string(byte_array_to_string(windows_absolute_path)) + " at root 0x" + RJava.cast_to_string(JavaInteger.to_hex_string(root_native_handle)) + ". Windows RegDeleteKeyEx(...) returned error code " + RJava.cast_to_string(result) + "."
        logger.warning(info)
        raise BackingStoreException.new(info)
      end
      close_key(parent_native_handle)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      # Converts value's or node's name from its byte array representation to
      # java string. Two encodings, simple and altBase64 are used. See
      # {@link #toWindowsName(String) toWindowsName()} for a detailed
      # description of encoding conventions.
      # @param windowsNameArray Null-terminated byte array.
      def to_java_name(windows_name_array)
        windows_name = byte_array_to_string(windows_name_array)
        # check if Alt64
        if ((windows_name.length > 1) && ((windows_name.substring(0, 2) == "/!")))
          return to_java_alt64name(windows_name)
        end
        java_name = StringBuffer.new
        ch = 0
        # Decode from simple encoding
        i = 0
        while i < windows_name.length
          if (((ch = windows_name.char_at(i))).equal?(Character.new(?/.ord)))
            next_ = Character.new(?\s.ord)
            if ((windows_name.length > i + 1) && ((next_ = windows_name.char_at(i + 1)) >= Character.new(?A.ord)) && (next_ <= Character.new(?Z.ord)))
              ch = next_
              i += 1
            else
              if ((windows_name.length > i + 1) && ((next_).equal?(Character.new(?/.ord))))
                ch = Character.new(?\\.ord)
                i += 1
              end
            end
          else
            if ((ch).equal?(Character.new(?\\.ord)))
              ch = Character.new(?/.ord)
            end
          end
          java_name.append(ch)
          i += 1
        end
        return java_name.to_s
      end
      
      typesig { [String] }
      # Converts value's or node's name from its Windows representation to java
      # string, using altBase64 encoding. See
      # {@link #toWindowsName(String) toWindowsName()} for a detailed
      # description of encoding conventions.
      def to_java_alt64name(windows_name)
        byte_buffer = Base64.alt_base64to_byte_array(windows_name.substring(2))
        result = StringBuffer.new
        i = 0
        while i < byte_buffer.attr_length
          firstbyte = (byte_buffer[((i += 1) - 1)] & 0xff)
          secondbyte = (byte_buffer[i] & 0xff)
          result.append(RJava.cast_to_char(((firstbyte << 8) + secondbyte)))
          i += 1
        end
        return result.to_s
      end
      
      typesig { [String] }
      # Converts value's or node's name to its Windows representation
      # as a byte-encoded string.
      # Two encodings, simple and altBase64 are used.
      # <p>
      # <i>Simple</i> encoding is used, if java string does not contain
      # any characters less, than 0x0020, or greater, than 0x007f.
      # Simple encoding adds "/" character to capital letters, i.e.
      # "A" is encoded as "/A". Character '\' is encoded as '//',
      # '/' is encoded as '\'.
      # The constructed string is converted to byte array by truncating the
      # highest byte and adding the terminating <tt>null</tt> character.
      # <p>
      # <i>altBase64</i>  encoding is used, if java string does contain at least
      # one character less, than 0x0020, or greater, than 0x007f.
      # This encoding is marked by setting first two bytes of the
      # Windows string to '/!'. The java name is then encoded using
      # byteArrayToAltBase64() method from
      # Base64 class.
      def to_windows_name(java_name)
        windows_name = StringBuffer.new
        i = 0
        while i < java_name.length
          ch = java_name.char_at(i)
          if ((ch < 0x20) || (ch > 0x7f))
            # If a non-trivial character encountered, use altBase64
            return to_windows_alt64name(java_name)
          end
          if ((ch).equal?(Character.new(?\\.ord)))
            windows_name.append("//")
          else
            if ((ch).equal?(Character.new(?/.ord)))
              windows_name.append(Character.new(?\\.ord))
            else
              if ((ch >= Character.new(?A.ord)) && (ch <= Character.new(?Z.ord)))
                windows_name.append("/" + RJava.cast_to_string(ch))
              else
                windows_name.append(ch)
              end
            end
          end
          i += 1
        end
        return string_to_byte_array(windows_name.to_s)
      end
      
      typesig { [String] }
      # Converts value's or node's name to its Windows representation
      # as a byte-encoded string, using altBase64 encoding. See
      # {@link #toWindowsName(String) toWindowsName()} for a detailed
      # description of encoding conventions.
      def to_windows_alt64name(java_name)
        java_name_array = Array.typed(::Java::Byte).new(2 * java_name.length) { 0 }
        # Convert to byte pairs
        counter = 0
        i = 0
        while i < java_name.length
          ch = java_name.char_at(i)
          java_name_array[((counter += 1) - 1)] = (ch >> 8)
          java_name_array[((counter += 1) - 1)] = ch
          i += 1
        end
        return string_to_byte_array("/!" + RJava.cast_to_string(Base64.byte_array_to_alt_base64(java_name_array)))
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Converts value string from its Windows representation
      # to java string.  See
      # {@link #toWindowsValueString(String) toWindowsValueString()} for the
      # description of the encoding algorithm.
      def to_java_value_string(windows_name_array)
        # Use modified native2ascii algorithm
        windows_name = byte_array_to_string(windows_name_array)
        java_name = StringBuffer.new
        ch = 0
        i = 0
        while i < windows_name.length
          if (((ch = windows_name.char_at(i))).equal?(Character.new(?/.ord)))
            next_ = Character.new(?\s.ord)
            if (windows_name.length > i + 1 && ((next_ = windows_name.char_at(i + 1))).equal?(Character.new(?u.ord)))
              if (windows_name.length < i + 6)
                break
              else
                ch = RJava.cast_to_char(JavaInteger.parse_int(windows_name.substring(i + 2, i + 6), 16))
                i += 5
              end
            else
              if ((windows_name.length > i + 1) && ((windows_name.char_at(i + 1)) >= Character.new(?A.ord)) && (next_ <= Character.new(?Z.ord)))
                ch = next_
                i += 1
              else
                if ((windows_name.length > i + 1) && ((next_).equal?(Character.new(?/.ord))))
                  ch = Character.new(?\\.ord)
                  i += 1
                end
              end
            end
          else
            if ((ch).equal?(Character.new(?\\.ord)))
              ch = Character.new(?/.ord)
            end
          end
          java_name.append(ch)
          i += 1
        end
        return java_name.to_s
      end
      
      typesig { [String] }
      # Converts value string to it Windows representation.
      # as a byte-encoded string.
      # Encoding algorithm adds "/" character to capital letters, i.e.
      # "A" is encoded as "/A". Character '\' is encoded as '//',
      # '/' is encoded as  '\'.
      # Then encoding scheme similar to jdk's native2ascii converter is used
      # to convert java string to a byte array of ASCII characters.
      def to_windows_value_string(java_name)
        windows_name = StringBuffer.new
        i = 0
        while i < java_name.length
          ch = java_name.char_at(i)
          if ((ch < 0x20) || (ch > 0x7f))
            # write \udddd
            windows_name.append("/u")
            hex = JavaInteger.to_hex_string(java_name.char_at(i))
            hex4 = StringBuffer.new(hex)
            hex4.reverse
            len = 4 - hex4.length
            j = 0
            while j < len
              hex4.append(Character.new(?0.ord))
              j += 1
            end
            j_ = 0
            while j_ < 4
              windows_name.append(hex4.char_at(3 - j_))
              j_ += 1
            end
          else
            if ((ch).equal?(Character.new(?\\.ord)))
              windows_name.append("//")
            else
              if ((ch).equal?(Character.new(?/.ord)))
                windows_name.append(Character.new(?\\.ord))
              else
                if ((ch >= Character.new(?A.ord)) && (ch <= Character.new(?Z.ord)))
                  windows_name.append("/" + RJava.cast_to_string(ch))
                else
                  windows_name.append(ch)
                end
              end
            end
          end
          i += 1
        end
        return string_to_byte_array(windows_name.to_s)
      end
    }
    
    typesig { [] }
    # Returns native handle for the top Windows node for this node.
    def root_native_handle
      return (is_user_node ? USER_ROOT_NATIVE_HANDLE : SYSTEM_ROOT_NATIVE_HANDLE)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns this java string as a null-terminated byte array
      def string_to_byte_array(str)
        result = Array.typed(::Java::Byte).new(str.length + 1) { 0 }
        i = 0
        while i < str.length
          result[i] = str.char_at(i)
          i += 1
        end
        result[str.length] = 0
        return result
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Converts a null-terminated byte array to java string
      def byte_array_to_string(array)
        result = StringBuffer.new
        i = 0
        while i < array.attr_length - 1
          result.append(RJava.cast_to_char(array[i]))
          i += 1
        end
        return result.to_s
      end
    }
    
    typesig { [] }
    # Empty, never used implementation  of AbstractPreferences.flushSpi().
    def flush_spi
      # assert false;
    end
    
    typesig { [] }
    # Empty, never used implementation  of AbstractPreferences.flushSpi().
    def sync_spi
      # assert false;
    end
    
    class_module.module_eval {
      typesig { [] }
      def logger
        synchronized(self) do
          if ((self.attr_logger).nil?)
            self.attr_logger = Logger.get_logger("java.util.prefs")
          end
          return self.attr_logger
        end
      end
    }
    
    private
    alias_method :initialize__windows_preferences, :initialize
  end
  
end
