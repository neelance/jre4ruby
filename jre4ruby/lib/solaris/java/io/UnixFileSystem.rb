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
  module UnixFileSystemImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  class UnixFileSystem < UnixFileSystemImports.const_get :FileSystem
    include_class_members UnixFileSystemImports
    
    attr_accessor :slash
    alias_method :attr_slash, :slash
    undef_method :slash
    alias_method :attr_slash=, :slash=
    undef_method :slash=
    
    attr_accessor :colon
    alias_method :attr_colon, :colon
    undef_method :colon
    alias_method :attr_colon=, :colon=
    undef_method :colon=
    
    attr_accessor :java_home
    alias_method :attr_java_home, :java_home
    undef_method :java_home
    alias_method :attr_java_home=, :java_home=
    undef_method :java_home=
    
    typesig { [] }
    def initialize
      @slash = 0
      @colon = 0
      @java_home = nil
      @cache = nil
      @java_home_prefix_cache = nil
      super()
      @cache = ExpiringCache.new
      @java_home_prefix_cache = ExpiringCache.new
      @slash = AccessController.do_privileged(GetPropertyAction.new("file.separator")).char_at(0)
      @colon = AccessController.do_privileged(GetPropertyAction.new("path.separator")).char_at(0)
      @java_home = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new("java.home")))
    end
    
    typesig { [] }
    # -- Normalization and construction --
    def get_separator
      return @slash
    end
    
    typesig { [] }
    def get_path_separator
      return @colon
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # A normal Unix pathname contains no duplicate slashes and does not end
    # with a slash.  It may be the empty string.
    # Normalize the given pathname, whose length is len, starting at the given
    # offset; everything before this offset is already normal.
    def normalize(pathname, len, off)
      if ((len).equal?(0))
        return pathname
      end
      n = len
      while ((n > 0) && ((pathname.char_at(n - 1)).equal?(Character.new(?/.ord))))
        n -= 1
      end
      if ((n).equal?(0))
        return "/"
      end
      sb = StringBuffer.new(pathname.length)
      if (off > 0)
        sb.append(pathname.substring(0, off))
      end
      prev_char = 0
      i = off
      while i < n
        c = pathname.char_at(i)
        if (((prev_char).equal?(Character.new(?/.ord))) && ((c).equal?(Character.new(?/.ord))))
          i += 1
          next
        end
        sb.append(c)
        prev_char = c
        i += 1
      end
      return sb.to_s
    end
    
    typesig { [String] }
    # Check that the given pathname is normal.  If not, invoke the real
    # normalizer on the part of the pathname that requires normalization.
    # This way we iterate through the whole pathname string only once.
    def normalize(pathname)
      n = pathname.length
      prev_char = 0
      i = 0
      while i < n
        c = pathname.char_at(i)
        if (((prev_char).equal?(Character.new(?/.ord))) && ((c).equal?(Character.new(?/.ord))))
          return normalize(pathname, n, i - 1)
        end
        prev_char = c
        i += 1
      end
      if ((prev_char).equal?(Character.new(?/.ord)))
        return normalize(pathname, n, n - 1)
      end
      return pathname
    end
    
    typesig { [String] }
    def prefix_length(pathname)
      if ((pathname.length).equal?(0))
        return 0
      end
      return ((pathname.char_at(0)).equal?(Character.new(?/.ord))) ? 1 : 0
    end
    
    typesig { [String, String] }
    def resolve(parent, child)
      if ((child == ""))
        return parent
      end
      if ((child.char_at(0)).equal?(Character.new(?/.ord)))
        if ((parent == "/"))
          return child
        end
        return parent + child
      end
      if ((parent == "/"))
        return parent + child
      end
      return parent + RJava.cast_to_string(Character.new(?/.ord)) + child
    end
    
    typesig { [] }
    def get_default_parent
      return "/"
    end
    
    typesig { [String] }
    def from_uripath(path)
      p = path
      if (p.ends_with("/") && (p.length > 1))
        # "/foo/" --> "/foo", but "/" --> "/"
        p = RJava.cast_to_string(p.substring(0, p.length - 1))
      end
      return p
    end
    
    typesig { [JavaFile] }
    # -- Path operations --
    def is_absolute(f)
      return (!(f.get_prefix_length).equal?(0))
    end
    
    typesig { [JavaFile] }
    def resolve(f)
      if (is_absolute(f))
        return f.get_path
      end
      return resolve(System.get_property("user.dir"), f.get_path)
    end
    
    # Caches for canonicalization results to improve startup performance.
    # The first cache handles repeated canonicalizations of the same path
    # name. The prefix cache handles repeated canonicalizations within the
    # same directory, and must not create results differing from the true
    # canonicalization algorithm in canonicalize_md.c. For this reason the
    # prefix cache is conservative and is not used for complex path names.
    attr_accessor :cache
    alias_method :attr_cache, :cache
    undef_method :cache
    alias_method :attr_cache=, :cache=
    undef_method :cache=
    
    # On Unix symlinks can jump anywhere in the file system, so we only
    # treat prefixes in java.home as trusted and cacheable in the
    # canonicalization algorithm
    attr_accessor :java_home_prefix_cache
    alias_method :attr_java_home_prefix_cache, :java_home_prefix_cache
    undef_method :java_home_prefix_cache
    alias_method :attr_java_home_prefix_cache=, :java_home_prefix_cache=
    undef_method :java_home_prefix_cache=
    
    typesig { [String] }
    def canonicalize(path)
      if (!self.attr_use_canon_caches)
        return canonicalize0(path)
      else
        res = @cache.get(path)
        if ((res).nil?)
          dir = nil
          res_dir = nil
          if (self.attr_use_canon_prefix_cache)
            # Note that this can cause symlinks that should
            # be resolved to a destination directory to be
            # resolved to the directory they're contained in
            dir = RJava.cast_to_string(parent_or_null(path))
            if (!(dir).nil?)
              res_dir = RJava.cast_to_string(@java_home_prefix_cache.get(dir))
              if (!(res_dir).nil?)
                # Hit only in prefix cache; full path is canonical
                filename = path.substring(1 + dir.length)
                res = res_dir + RJava.cast_to_string(@slash) + filename
                @cache.put(dir + RJava.cast_to_string(@slash) + filename, res)
              end
            end
          end
          if ((res).nil?)
            res = RJava.cast_to_string(canonicalize0(path))
            @cache.put(path, res)
            if (self.attr_use_canon_prefix_cache && !(dir).nil? && dir.starts_with(@java_home))
              res_dir = RJava.cast_to_string(parent_or_null(res))
              # Note that we don't allow a resolved symlink
              # to elsewhere in java.home to pollute the
              # prefix cache (java.home prefix cache could
              # just as easily be a set at this point)
              if (!(res_dir).nil? && (res_dir == dir))
                f = JavaFile.new(res)
                if (f.exists && !f.is_directory)
                  @java_home_prefix_cache.put(dir, res_dir)
                end
              end
            end
          end
        end
        raise AssertError if not ((canonicalize0(path) == res) || path.starts_with(@java_home))
        return res
      end
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_canonicalize0, [:pointer, :long, :long], :long
    typesig { [String] }
    def canonicalize0(path)
      JNI.__send__(:Java_java_io_UnixFileSystem_canonicalize0, JNI.env, self.jni_id, path.jni_id)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Best-effort attempt to get parent of this path; used for
      # optimization of filename canonicalization. This must return null for
      # any cases where the code in canonicalize_md.c would throw an
      # exception or otherwise deal with non-simple pathnames like handling
      # of "." and "..". It may conservatively return null in other
      # situations as well. Returning null will cause the underlying
      # (expensive) canonicalization routine to be called.
      def parent_or_null(path)
        if ((path).nil?)
          return nil
        end
        sep = JavaFile.attr_separator_char
        last = path.length - 1
        idx = last
        adjacent_dots = 0
        non_dot_count = 0
        while (idx > 0)
          c = path.char_at(idx)
          if ((c).equal?(Character.new(?..ord)))
            if ((adjacent_dots += 1) >= 2)
              # Punt on pathnames containing . and ..
              return nil
            end
          else
            if ((c).equal?(sep))
              if ((adjacent_dots).equal?(1) && (non_dot_count).equal?(0))
                # Punt on pathnames containing . and ..
                return nil
              end
              if ((idx).equal?(0) || idx >= last - 1 || (path.char_at(idx - 1)).equal?(sep))
                # Punt on pathnames containing adjacent slashes
                # toward the end
                return nil
              end
              return path.substring(0, idx)
            else
              (non_dot_count += 1)
              adjacent_dots = 0
            end
          end
          (idx -= 1)
        end
        return nil
      end
    }
    
    JNI.native_method :Java_java_io_UnixFileSystem_getBooleanAttributes0, [:pointer, :long, :long], :int32
    typesig { [JavaFile] }
    # -- Attribute accessors --
    def get_boolean_attributes0(f)
      JNI.__send__(:Java_java_io_UnixFileSystem_getBooleanAttributes0, JNI.env, self.jni_id, f.jni_id)
    end
    
    typesig { [JavaFile] }
    def get_boolean_attributes(f)
      rv = get_boolean_attributes0(f)
      name = f.get_name
      hidden = (name.length > 0) && ((name.char_at(0)).equal?(Character.new(?..ord)))
      return rv | (hidden ? BA_HIDDEN : 0)
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_checkAccess, [:pointer, :long, :long, :int32], :int8
    typesig { [JavaFile, ::Java::Int] }
    def check_access(f, access)
      JNI.__send__(:Java_java_io_UnixFileSystem_checkAccess, JNI.env, self.jni_id, f.jni_id, access.to_int) != 0
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_getLastModifiedTime, [:pointer, :long, :long], :int64
    typesig { [JavaFile] }
    def get_last_modified_time(f)
      JNI.__send__(:Java_java_io_UnixFileSystem_getLastModifiedTime, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_getLength, [:pointer, :long, :long], :int64
    typesig { [JavaFile] }
    def get_length(f)
      JNI.__send__(:Java_java_io_UnixFileSystem_getLength, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_setPermission, [:pointer, :long, :long, :int32, :int8, :int8], :int8
    typesig { [JavaFile, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    def set_permission(f, access, enable, owneronly)
      JNI.__send__(:Java_java_io_UnixFileSystem_setPermission, JNI.env, self.jni_id, f.jni_id, access.to_int, enable ? 1 : 0, owneronly ? 1 : 0) != 0
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_createFileExclusively, [:pointer, :long, :long], :int8
    typesig { [String] }
    # -- File operations --
    def create_file_exclusively(path)
      JNI.__send__(:Java_java_io_UnixFileSystem_createFileExclusively, JNI.env, self.jni_id, path.jni_id) != 0
    end
    
    typesig { [JavaFile] }
    def delete(f)
      # Keep canonicalization caches in sync after file deletion
      # and renaming operations. Could be more clever than this
      # (i.e., only remove/update affected entries) but probably
      # not worth it since these entries expire after 30 seconds
      # anyway.
      @cache.clear
      @java_home_prefix_cache.clear
      return delete0(f)
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_delete0, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def delete0(f)
      JNI.__send__(:Java_java_io_UnixFileSystem_delete0, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_list, [:pointer, :long, :long], :long
    typesig { [JavaFile] }
    def list(f)
      JNI.__send__(:Java_java_io_UnixFileSystem_list, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_createDirectory, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def create_directory(f)
      JNI.__send__(:Java_java_io_UnixFileSystem_createDirectory, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    typesig { [JavaFile, JavaFile] }
    def rename(f1, f2)
      # Keep canonicalization caches in sync after file deletion
      # and renaming operations. Could be more clever than this
      # (i.e., only remove/update affected entries) but probably
      # not worth it since these entries expire after 30 seconds
      # anyway.
      @cache.clear
      @java_home_prefix_cache.clear
      return rename0(f1, f2)
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_rename0, [:pointer, :long, :long, :long], :int8
    typesig { [JavaFile, JavaFile] }
    def rename0(f1, f2)
      JNI.__send__(:Java_java_io_UnixFileSystem_rename0, JNI.env, self.jni_id, f1.jni_id, f2.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_setLastModifiedTime, [:pointer, :long, :long, :int64], :int8
    typesig { [JavaFile, ::Java::Long] }
    def set_last_modified_time(f, time)
      JNI.__send__(:Java_java_io_UnixFileSystem_setLastModifiedTime, JNI.env, self.jni_id, f.jni_id, time.to_int) != 0
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_setReadOnly, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def set_read_only(f)
      JNI.__send__(:Java_java_io_UnixFileSystem_setReadOnly, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    typesig { [] }
    # -- Filesystem interface --
    def list_roots
      begin
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_read("/")
        end
        return Array.typed(JavaFile).new([JavaFile.new("/")])
      rescue SecurityException => x
        return Array.typed(JavaFile).new(0) { nil }
      end
    end
    
    JNI.native_method :Java_java_io_UnixFileSystem_getSpace, [:pointer, :long, :long, :int32], :int64
    typesig { [JavaFile, ::Java::Int] }
    # -- Disk usage --
    def get_space(f, t)
      JNI.__send__(:Java_java_io_UnixFileSystem_getSpace, JNI.env, self.jni_id, f.jni_id, t.to_int)
    end
    
    typesig { [JavaFile, JavaFile] }
    # -- Basic infrastructure --
    def compare(f1, f2)
      return (f1.get_path <=> f2.get_path)
    end
    
    typesig { [JavaFile] }
    def hash_code(f)
      return f.get_path.hash_code ^ 1234321
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_UnixFileSystem_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_java_io_UnixFileSystem_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_ids
      end
    }
    
    private
    alias_method :initialize__unix_file_system, :initialize
  end
  
end
