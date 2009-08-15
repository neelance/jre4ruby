require "rjava"

# Copyright 1998-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FileSystemImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Package-private abstract class for the local filesystem abstraction.
  class FileSystem 
    include_class_members FileSystemImports
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_FileSystem_getFileSystem, [:pointer, :long], :long
      typesig { [] }
      # Return the FileSystem object representing this platform's local
      # filesystem.
      def get_file_system
        JNI.__send__(:Java_java_io_FileSystem_getFileSystem, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    # -- Normalization and construction --
    # 
    # Return the local filesystem's name-separator character.
    def get_separator
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the local filesystem's path-separator character.
    def get_path_separator
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Convert the given pathname string to normal form.  If the string is
    # already in normal form then it is simply returned.
    def normalize(path)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Compute the length of this pathname string's prefix.  The pathname
    # string must be in normal form.
    def prefix_length(path)
      raise NotImplementedError
    end
    
    typesig { [String, String] }
    # Resolve the child pathname string against the parent.
    # Both strings must be in normal form, and the result
    # will be in normal form.
    def resolve(parent, child)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the parent pathname string to be used when the parent-directory
    # argument in one of the two-argument File constructors is the empty
    # pathname.
    def get_default_parent
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Post-process the given URI path string if necessary.  This is used on
    # win32, e.g., to transform "/c:/foo" into "c:/foo".  The path string
    # still has slash separators; code in the File class will translate them
    # after this method returns.
    def from_uripath(path)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # -- Path operations --
    # 
    # Tell whether or not the given abstract pathname is absolute.
    def is_absolute(f)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # Resolve the given abstract pathname into absolute form.  Invoked by the
    # getAbsolutePath and getCanonicalPath methods in the File class.
    def resolve(f)
      raise NotImplementedError
    end
    
    typesig { [String] }
    def canonicalize(path)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # -- Attribute accessors --
      # Constants for simple boolean attributes
      const_set_lazy(:BA_EXISTS) { 0x1 }
      const_attr_reader  :BA_EXISTS
      
      const_set_lazy(:BA_REGULAR) { 0x2 }
      const_attr_reader  :BA_REGULAR
      
      const_set_lazy(:BA_DIRECTORY) { 0x4 }
      const_attr_reader  :BA_DIRECTORY
      
      const_set_lazy(:BA_HIDDEN) { 0x8 }
      const_attr_reader  :BA_HIDDEN
    }
    
    typesig { [JavaFile] }
    # Return the simple boolean attributes for the file or directory denoted
    # by the given abstract pathname, or zero if it does not exist or some
    # other I/O error occurs.
    def get_boolean_attributes(f)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      const_set_lazy(:ACCESS_READ) { 0x4 }
      const_attr_reader  :ACCESS_READ
      
      const_set_lazy(:ACCESS_WRITE) { 0x2 }
      const_attr_reader  :ACCESS_WRITE
      
      const_set_lazy(:ACCESS_EXECUTE) { 0x1 }
      const_attr_reader  :ACCESS_EXECUTE
    }
    
    typesig { [JavaFile, ::Java::Int] }
    # Check whether the file or directory denoted by the given abstract
    # pathname may be accessed by this process.  The second argument specifies
    # which access, ACCESS_READ, ACCESS_WRITE or ACCESS_EXECUTE, to check.
    # Return false if access is denied or an I/O error occurs
    def check_access(f, access)
      raise NotImplementedError
    end
    
    typesig { [JavaFile, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    # Set on or off the access permission (to owner only or to all) to the file
    # or directory denoted by the given abstract pathname, based on the parameters
    # enable, access and oweronly.
    def set_permission(f, access, enable, owneronly)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # Return the time at which the file or directory denoted by the given
    # abstract pathname was last modified, or zero if it does not exist or
    # some other I/O error occurs.
    def get_last_modified_time(f)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # Return the length in bytes of the file denoted by the given abstract
    # pathname, or zero if it does not exist, is a directory, or some other
    # I/O error occurs.
    def get_length(f)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # -- File operations --
    # 
    # Create a new empty file with the given pathname.  Return
    # <code>true</code> if the file was created and <code>false</code> if a
    # file or directory with the given pathname already exists.  Throw an
    # IOException if an I/O error occurs.
    def create_file_exclusively(pathname)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # Delete the file or directory denoted by the given abstract pathname,
    # returning <code>true</code> if and only if the operation succeeds.
    def delete(f)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # List the elements of the directory denoted by the given abstract
    # pathname.  Return an array of strings naming the elements of the
    # directory if successful; otherwise, return <code>null</code>.
    def list(f)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # Create a new directory denoted by the given abstract pathname,
    # returning <code>true</code> if and only if the operation succeeds.
    def create_directory(f)
      raise NotImplementedError
    end
    
    typesig { [JavaFile, JavaFile] }
    # Rename the file or directory denoted by the first abstract pathname to
    # the second abstract pathname, returning <code>true</code> if and only if
    # the operation succeeds.
    def rename(f1, f2)
      raise NotImplementedError
    end
    
    typesig { [JavaFile, ::Java::Long] }
    # Set the last-modified time of the file or directory denoted by the
    # given abstract pathname, returning <code>true</code> if and only if the
    # operation succeeds.
    def set_last_modified_time(f, time)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # Mark the file or directory denoted by the given abstract pathname as
    # read-only, returning <code>true</code> if and only if the operation
    # succeeds.
    def set_read_only(f)
      raise NotImplementedError
    end
    
    typesig { [] }
    # -- Filesystem interface --
    # 
    # List the available filesystem roots.
    def list_roots
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # -- Disk usage --
      const_set_lazy(:SPACE_TOTAL) { 0 }
      const_attr_reader  :SPACE_TOTAL
      
      const_set_lazy(:SPACE_FREE) { 1 }
      const_attr_reader  :SPACE_FREE
      
      const_set_lazy(:SPACE_USABLE) { 2 }
      const_attr_reader  :SPACE_USABLE
    }
    
    typesig { [JavaFile, ::Java::Int] }
    def get_space(f, t)
      raise NotImplementedError
    end
    
    typesig { [JavaFile, JavaFile] }
    # -- Basic infrastructure --
    # 
    # Compare two abstract pathnames lexicographically.
    def compare(f1, f2)
      raise NotImplementedError
    end
    
    typesig { [JavaFile] }
    # Compute the hash code of an abstract pathname.
    def hash_code(f)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # Flags for enabling/disabling performance optimizations for file
      # name canonicalization
      
      def use_canon_caches
        defined?(@@use_canon_caches) ? @@use_canon_caches : @@use_canon_caches= true
      end
      alias_method :attr_use_canon_caches, :use_canon_caches
      
      def use_canon_caches=(value)
        @@use_canon_caches = value
      end
      alias_method :attr_use_canon_caches=, :use_canon_caches=
      
      
      def use_canon_prefix_cache
        defined?(@@use_canon_prefix_cache) ? @@use_canon_prefix_cache : @@use_canon_prefix_cache= true
      end
      alias_method :attr_use_canon_prefix_cache, :use_canon_prefix_cache
      
      def use_canon_prefix_cache=(value)
        @@use_canon_prefix_cache = value
      end
      alias_method :attr_use_canon_prefix_cache=, :use_canon_prefix_cache=
      
      typesig { [String, ::Java::Boolean] }
      def get_boolean_property(prop, default_val)
        val = System.get_property(prop)
        if ((val).nil?)
          return default_val
        end
        if (val.equals_ignore_case("true"))
          return true
        else
          return false
        end
      end
      
      when_class_loaded do
        self.attr_use_canon_caches = get_boolean_property("sun.io.useCanonCaches", self.attr_use_canon_caches)
        self.attr_use_canon_prefix_cache = get_boolean_property("sun.io.useCanonPrefixCache", self.attr_use_canon_prefix_cache)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__file_system, :initialize
  end
  
end
