require "rjava"

# Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module WinNTFileSystemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Unicode-aware FileSystem for Windows NT/2000.
  # 
  # @author Konstantin Kladko
  # @since 1.4
  class WinNTFileSystem < WinNTFileSystemImports.const_get :Win32FileSystem
    include_class_members WinNTFileSystemImports
    
    JNI.native_method :Java_java_io_WinNTFileSystem_canonicalize0, [:pointer, :long, :long], :long
    typesig { [String] }
    def canonicalize0(path)
      JNI.__send__(:Java_java_io_WinNTFileSystem_canonicalize0, JNI.env, self.jni_id, path.jni_id)
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_canonicalizeWithPrefix0, [:pointer, :long, :long, :long], :long
    typesig { [String, String] }
    def canonicalize_with_prefix0(canonical_prefix, path_with_canonical_prefix)
      JNI.__send__(:Java_java_io_WinNTFileSystem_canonicalizeWithPrefix0, JNI.env, self.jni_id, canonical_prefix.jni_id, path_with_canonical_prefix.jni_id)
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_getBooleanAttributes, [:pointer, :long, :long], :int32
    typesig { [JavaFile] }
    # -- Attribute accessors --
    def get_boolean_attributes(f)
      JNI.__send__(:Java_java_io_WinNTFileSystem_getBooleanAttributes, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_checkAccess, [:pointer, :long, :long, :int32], :int8
    typesig { [JavaFile, ::Java::Int] }
    def check_access(f, access)
      JNI.__send__(:Java_java_io_WinNTFileSystem_checkAccess, JNI.env, self.jni_id, f.jni_id, access.to_int) != 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_getLastModifiedTime, [:pointer, :long, :long], :int64
    typesig { [JavaFile] }
    def get_last_modified_time(f)
      JNI.__send__(:Java_java_io_WinNTFileSystem_getLastModifiedTime, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_getLength, [:pointer, :long, :long], :int64
    typesig { [JavaFile] }
    def get_length(f)
      JNI.__send__(:Java_java_io_WinNTFileSystem_getLength, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_setPermission, [:pointer, :long, :long, :int32, :int8, :int8], :int8
    typesig { [JavaFile, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    def set_permission(f, access, enable, owneronly)
      JNI.__send__(:Java_java_io_WinNTFileSystem_setPermission, JNI.env, self.jni_id, f.jni_id, access.to_int, enable ? 1 : 0, owneronly ? 1 : 0) != 0
    end
    
    typesig { [JavaFile, ::Java::Int] }
    def get_space(f, t)
      if (f.exists)
        return get_space0(f, t)
      end
      return 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_getSpace0, [:pointer, :long, :long, :int32], :int64
    typesig { [JavaFile, ::Java::Int] }
    def get_space0(f, t)
      JNI.__send__(:Java_java_io_WinNTFileSystem_getSpace0, JNI.env, self.jni_id, f.jni_id, t.to_int)
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_createFileExclusively, [:pointer, :long, :long], :int8
    typesig { [String] }
    # -- File operations --
    def create_file_exclusively(path)
      JNI.__send__(:Java_java_io_WinNTFileSystem_createFileExclusively, JNI.env, self.jni_id, path.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_delete0, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def delete0(f)
      JNI.__send__(:Java_java_io_WinNTFileSystem_delete0, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_list, [:pointer, :long, :long], :long
    typesig { [JavaFile] }
    def list(f)
      JNI.__send__(:Java_java_io_WinNTFileSystem_list, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_createDirectory, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def create_directory(f)
      JNI.__send__(:Java_java_io_WinNTFileSystem_createDirectory, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_rename0, [:pointer, :long, :long, :long], :int8
    typesig { [JavaFile, JavaFile] }
    def rename0(f1, f2)
      JNI.__send__(:Java_java_io_WinNTFileSystem_rename0, JNI.env, self.jni_id, f1.jni_id, f2.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_setLastModifiedTime, [:pointer, :long, :long, :int64], :int8
    typesig { [JavaFile, ::Java::Long] }
    def set_last_modified_time(f, time)
      JNI.__send__(:Java_java_io_WinNTFileSystem_setLastModifiedTime, JNI.env, self.jni_id, f.jni_id, time.to_int) != 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_setReadOnly, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def set_read_only(f)
      JNI.__send__(:Java_java_io_WinNTFileSystem_setReadOnly, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_WinNTFileSystem_getDriveDirectory, [:pointer, :long, :int32], :long
    typesig { [::Java::Int] }
    def get_drive_directory(drive)
      JNI.__send__(:Java_java_io_WinNTFileSystem_getDriveDirectory, JNI.env, self.jni_id, drive.to_int)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_WinNTFileSystem_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_java_io_WinNTFileSystem_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_ids
      end
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__win_ntfile_system, :initialize
  end
  
end
