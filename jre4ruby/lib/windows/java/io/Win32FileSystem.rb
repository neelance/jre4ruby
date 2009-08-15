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
  module Win32FileSystemImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Security, :AccessController
      include_const ::Java::Util, :Locale
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  class Win32FileSystem < Win32FileSystemImports.const_get :FileSystem
    include_class_members Win32FileSystemImports
    
    attr_accessor :slash
    alias_method :attr_slash, :slash
    undef_method :slash
    alias_method :attr_slash=, :slash=
    undef_method :slash=
    
    attr_accessor :alt_slash
    alias_method :attr_alt_slash, :alt_slash
    undef_method :alt_slash
    alias_method :attr_alt_slash=, :alt_slash=
    undef_method :alt_slash=
    
    attr_accessor :semicolon
    alias_method :attr_semicolon, :semicolon
    undef_method :semicolon
    alias_method :attr_semicolon=, :semicolon=
    undef_method :semicolon=
    
    typesig { [] }
    def initialize
      @slash = 0
      @alt_slash = 0
      @semicolon = 0
      @cache = nil
      @prefix_cache = nil
      super()
      @cache = ExpiringCache.new
      @prefix_cache = ExpiringCache.new
      @slash = AccessController.do_privileged(GetPropertyAction.new("file.separator")).char_at(0)
      @semicolon = AccessController.do_privileged(GetPropertyAction.new("path.separator")).char_at(0)
      @alt_slash = ((@slash).equal?(Character.new(?\\.ord))) ? Character.new(?/.ord) : Character.new(?\\.ord)
    end
    
    typesig { [::Java::Char] }
    def is_slash(c)
      return ((c).equal?(Character.new(?\\.ord))) || ((c).equal?(Character.new(?/.ord)))
    end
    
    typesig { [::Java::Char] }
    def is_letter(c)
      return ((c >= Character.new(?a.ord)) && (c <= Character.new(?z.ord))) || ((c >= Character.new(?A.ord)) && (c <= Character.new(?Z.ord)))
    end
    
    typesig { [String] }
    def slashify(p)
      if ((p.length > 0) && (!(p.char_at(0)).equal?(@slash)))
        return RJava.cast_to_string(@slash) + p
      else
        return p
      end
    end
    
    typesig { [] }
    # -- Normalization and construction --
    def get_separator
      return @slash
    end
    
    typesig { [] }
    def get_path_separator
      return @semicolon
    end
    
    typesig { [String, ::Java::Int, StringBuffer] }
    # A normal Win32 pathname contains no duplicate slashes, except possibly
    # for a UNC prefix, and does not end with a slash.  It may be the empty
    # string.  Normalized Win32 pathnames have the convenient property that
    # the length of the prefix almost uniquely identifies the type of the path
    # and whether it is absolute or relative:
    # 
    # 0  relative to both drive and directory
    # 1  drive-relative (begins with '\\')
    # 2  absolute UNC (if first char is '\\'),
    # else directory-relative (has form "z:foo")
    # 3  absolute local pathname (begins with "z:\\")
    def normalize_prefix(path, len, sb)
      src = 0
      while ((src < len) && is_slash(path.char_at(src)))
        src += 1
      end
      c = 0
      if ((len - src >= 2) && is_letter(c = path.char_at(src)) && (path.char_at(src + 1)).equal?(Character.new(?:.ord)))
        # Remove leading slashes if followed by drive specifier.
        # This hack is necessary to support file URLs containing drive
        # specifiers (e.g., "file://c:/path").  As a side effect,
        # "/c:/path" can be used as an alternative to "c:/path".
        sb.append(c)
        sb.append(Character.new(?:.ord))
        src += 2
      else
        src = 0
        if ((len >= 2) && is_slash(path.char_at(0)) && is_slash(path.char_at(1)))
          # UNC pathname: Retain first slash; leave src pointed at
          # second slash so that further slashes will be collapsed
          # into the second slash.  The result will be a pathname
          # beginning with "\\\\" followed (most likely) by a host
          # name.
          src = 1
          sb.append(@slash)
        end
      end
      return src
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Normalize the given pathname, whose length is len, starting at the given
    # offset; everything before this offset is already normal.
    def normalize(path, len, off)
      if ((len).equal?(0))
        return path
      end
      if (off < 3)
        off = 0
      end
      # Avoid fencepost cases with UNC pathnames
      src = 0
      slash = @slash
      sb = StringBuffer.new(len)
      if ((off).equal?(0))
        # Complete normalization, including prefix
        src = normalize_prefix(path, len, sb)
      else
        # Partial normalization
        src = off
        sb.append(path.substring(0, off))
      end
      # Remove redundant slashes from the remainder of the path, forcing all
      # slashes into the preferred slash
      while (src < len)
        c = path.char_at(((src += 1) - 1))
        if (is_slash(c))
          while ((src < len) && is_slash(path.char_at(src)))
            src += 1
          end
          if ((src).equal?(len))
            # Check for trailing separator
            sn = sb.length
            if (((sn).equal?(2)) && ((sb.char_at(1)).equal?(Character.new(?:.ord))))
              # "z:\\"
              sb.append(slash)
              break
            end
            if ((sn).equal?(0))
              # "\\"
              sb.append(slash)
              break
            end
            if (((sn).equal?(1)) && (is_slash(sb.char_at(0))))
              # "\\\\" is not collapsed to "\\" because "\\\\" marks
              # the beginning of a UNC pathname.  Even though it is
              # not, by itself, a valid UNC pathname, we leave it as
              # is in order to be consistent with the win32 APIs,
              # which treat this case as an invalid UNC pathname
              # rather than as an alias for the root directory of
              # the current drive.
              sb.append(slash)
              break
            end
            # Path does not denote a root directory, so do not append
            # trailing slash
            break
          else
            sb.append(slash)
          end
        else
          sb.append(c)
        end
      end
      rv = sb.to_s
      return rv
    end
    
    typesig { [String] }
    # Check that the given pathname is normal.  If not, invoke the real
    # normalizer on the part of the pathname that requires normalization.
    # This way we iterate through the whole pathname string only once.
    def normalize(path)
      n = path.length
      slash = @slash
      alt_slash = @alt_slash
      prev = 0
      i = 0
      while i < n
        c = path.char_at(i)
        if ((c).equal?(alt_slash))
          return normalize(path, n, ((prev).equal?(slash)) ? i - 1 : i)
        end
        if (((c).equal?(slash)) && ((prev).equal?(slash)) && (i > 1))
          return normalize(path, n, i - 1)
        end
        if (((c).equal?(Character.new(?:.ord))) && (i > 1))
          return normalize(path, n, 0)
        end
        prev = c
        i += 1
      end
      if ((prev).equal?(slash))
        return normalize(path, n, n - 1)
      end
      return path
    end
    
    typesig { [String] }
    def prefix_length(path)
      slash = @slash
      n = path.length
      if ((n).equal?(0))
        return 0
      end
      c0 = path.char_at(0)
      c1 = (n > 1) ? path.char_at(1) : 0
      if ((c0).equal?(slash))
        if ((c1).equal?(slash))
          return 2
        end
        # Absolute UNC pathname "\\\\foo"
        return 1
        # Drive-relative "\\foo"
      end
      if (is_letter(c0) && ((c1).equal?(Character.new(?:.ord))))
        if ((n > 2) && ((path.char_at(2)).equal?(slash)))
          return 3
        end
        # Absolute local pathname "z:\\foo"
        return 2
        # Directory-relative "z:foo"
      end
      return 0
      # Completely relative
    end
    
    typesig { [String, String] }
    def resolve(parent, child)
      pn = parent.length
      if ((pn).equal?(0))
        return child
      end
      cn = child.length
      if ((cn).equal?(0))
        return parent
      end
      c = child
      child_start = 0
      parent_end = pn
      if ((cn > 1) && ((c.char_at(0)).equal?(@slash)))
        if ((c.char_at(1)).equal?(@slash))
          # Drop prefix when child is a UNC pathname
          child_start = 2
        else
          # Drop prefix when child is drive-relative
          child_start = 1
        end
        if ((cn).equal?(child_start))
          # Child is double slash
          if ((parent.char_at(pn - 1)).equal?(@slash))
            return parent.substring(0, pn - 1)
          end
          return parent
        end
      end
      if ((parent.char_at(pn - 1)).equal?(@slash))
        parent_end -= 1
      end
      strlen = parent_end + cn - child_start
      the_chars = nil
      if ((child.char_at(child_start)).equal?(@slash))
        the_chars = CharArray.new(strlen)
        parent.get_chars(0, parent_end, the_chars, 0)
        child.get_chars(child_start, cn, the_chars, parent_end)
      else
        the_chars = CharArray.new(strlen + 1)
        parent.get_chars(0, parent_end, the_chars, 0)
        the_chars[parent_end] = @slash
        child.get_chars(child_start, cn, the_chars, parent_end + 1)
      end
      return String.new(the_chars)
    end
    
    typesig { [] }
    def get_default_parent
      return ("" + RJava.cast_to_string(@slash))
    end
    
    typesig { [String] }
    def from_uripath(path)
      p = path
      if ((p.length > 2) && ((p.char_at(2)).equal?(Character.new(?:.ord))))
        # "/c:/foo" --> "c:/foo"
        p = RJava.cast_to_string(p.substring(1))
        # "c:/foo/" --> "c:/foo", but "c:/" --> "c:/"
        if ((p.length > 3) && p.ends_with("/"))
          p = RJava.cast_to_string(p.substring(0, p.length - 1))
        end
      else
        if ((p.length > 1) && p.ends_with("/"))
          # "/foo/" --> "/foo"
          p = RJava.cast_to_string(p.substring(0, p.length - 1))
        end
      end
      return p
    end
    
    typesig { [JavaFile] }
    # -- Path operations --
    def is_absolute(f)
      pl = f.get_prefix_length
      return ((((pl).equal?(2)) && ((f.get_path.char_at(0)).equal?(@slash))) || ((pl).equal?(3)))
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_getDriveDirectory, [:pointer, :long, :int32], :long
    typesig { [::Java::Int] }
    def get_drive_directory(drive)
      JNI.__send__(:Java_java_io_Win32FileSystem_getDriveDirectory, JNI.env, self.jni_id, drive.to_int)
    end
    
    class_module.module_eval {
      
      def drive_dir_cache
        defined?(@@drive_dir_cache) ? @@drive_dir_cache : @@drive_dir_cache= Array.typed(String).new(26) { nil }
      end
      alias_method :attr_drive_dir_cache, :drive_dir_cache
      
      def drive_dir_cache=(value)
        @@drive_dir_cache = value
      end
      alias_method :attr_drive_dir_cache=, :drive_dir_cache=
      
      typesig { [::Java::Char] }
      def drive_index(d)
        if ((d >= Character.new(?a.ord)) && (d <= Character.new(?z.ord)))
          return d - Character.new(?a.ord)
        end
        if ((d >= Character.new(?A.ord)) && (d <= Character.new(?Z.ord)))
          return d - Character.new(?A.ord)
        end
        return -1
      end
    }
    
    typesig { [::Java::Char] }
    def get_drive_directory(drive)
      i = drive_index(drive)
      if (i < 0)
        return nil
      end
      s = self.attr_drive_dir_cache[i]
      if (!(s).nil?)
        return s
      end
      s = RJava.cast_to_string(get_drive_directory(i + 1))
      self.attr_drive_dir_cache[i] = s
      return s
    end
    
    typesig { [] }
    def get_user_path
      # For both compatibility and security,
      # we must look this up every time
      return normalize(System.get_property("user.dir"))
    end
    
    typesig { [String] }
    def get_drive(path)
      pl = prefix_length(path)
      return ((pl).equal?(3)) ? path.substring(0, 2) : nil
    end
    
    typesig { [JavaFile] }
    def resolve(f)
      path = f.get_path
      pl = f.get_prefix_length
      if (((pl).equal?(2)) && ((path.char_at(0)).equal?(@slash)))
        return path
      end
      # UNC
      if ((pl).equal?(3))
        return path
      end
      # Absolute local
      if ((pl).equal?(0))
        return get_user_path + slashify(path)
      end
      # Completely relative
      if ((pl).equal?(1))
        # Drive-relative
        up = get_user_path
        ud = get_drive(up)
        if (!(ud).nil?)
          return ud + path
        end
        return up + path
        # User dir is a UNC path
      end
      if ((pl).equal?(2))
        # Directory-relative
        up = get_user_path
        ud = get_drive(up)
        if ((!(ud).nil?) && path.starts_with(ud))
          return up + RJava.cast_to_string(slashify(path.substring(2)))
        end
        drive = path.char_at(0)
        dir = get_drive_directory(drive)
        np = nil
        if (!(dir).nil?)
          # When resolving a directory-relative path that refers to a
          # drive other than the current drive, insist that the caller
          # have read permission on the result
          p = drive + (RJava.cast_to_string(Character.new(?:.ord)) + dir + RJava.cast_to_string(slashify(path.substring(2))))
          security = System.get_security_manager
          begin
            if (!(security).nil?)
              security.check_read(p)
            end
          rescue SecurityException => x
            # Don't disclose the drive's directory in the exception
            raise SecurityException.new("Cannot resolve path " + path)
          end
          return p
        end
        return RJava.cast_to_string(drive) + ":" + RJava.cast_to_string(slashify(path.substring(2)))
        # fake it
      end
      raise InternalError.new("Unresolvable path: " + path)
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
    
    attr_accessor :prefix_cache
    alias_method :attr_prefix_cache, :prefix_cache
    undef_method :prefix_cache
    alias_method :attr_prefix_cache=, :prefix_cache=
    undef_method :prefix_cache=
    
    typesig { [String] }
    def canonicalize(path)
      # If path is a drive letter only then skip canonicalization
      len = path.length
      if (((len).equal?(2)) && (is_letter(path.char_at(0))) && ((path.char_at(1)).equal?(Character.new(?:.ord))))
        c = path.char_at(0)
        if ((c >= Character.new(?A.ord)) && (c <= Character.new(?Z.ord)))
          return path
        end
        return "" + RJava.cast_to_string((RJava.cast_to_char((c - 32)))) + RJava.cast_to_string(Character.new(?:.ord))
      else
        if (((len).equal?(3)) && (is_letter(path.char_at(0))) && ((path.char_at(1)).equal?(Character.new(?:.ord))) && ((path.char_at(2)).equal?(Character.new(?\\.ord))))
          c = path.char_at(0)
          if ((c >= Character.new(?A.ord)) && (c <= Character.new(?Z.ord)))
            return path
          end
          return "" + RJava.cast_to_string((RJava.cast_to_char((c - 32)))) + RJava.cast_to_string(Character.new(?:.ord)) + RJava.cast_to_string(Character.new(?\\.ord))
        end
      end
      if (!self.attr_use_canon_caches)
        return canonicalize0(path)
      else
        res = @cache.get(path)
        if ((res).nil?)
          dir = nil
          res_dir = nil
          if (self.attr_use_canon_prefix_cache)
            dir = RJava.cast_to_string(parent_or_null(path))
            if (!(dir).nil?)
              res_dir = RJava.cast_to_string(@prefix_cache.get(dir))
              if (!(res_dir).nil?)
                # Hit only in prefix cache; full path is canonical,
                # but we need to get the canonical name of the file
                # in this directory to get the appropriate capitalization
                filename = path.substring(1 + dir.length)
                res = RJava.cast_to_string(canonicalize_with_prefix(res_dir, filename))
                @cache.put(dir + RJava.cast_to_string(JavaFile.attr_separator_char) + filename, res)
              end
            end
          end
          if ((res).nil?)
            res = RJava.cast_to_string(canonicalize0(path))
            @cache.put(path, res)
            if (self.attr_use_canon_prefix_cache && !(dir).nil?)
              res_dir = RJava.cast_to_string(parent_or_null(res))
              if (!(res_dir).nil?)
                f = JavaFile.new(res)
                if (f.exists && !f.is_directory)
                  @prefix_cache.put(dir, res_dir)
                end
              end
            end
          end
        end
        raise AssertError if not (canonicalize0(path).equals_ignore_case(res))
        return res
      end
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_canonicalize0, [:pointer, :long, :long], :long
    typesig { [String] }
    def canonicalize0(path)
      JNI.__send__(:Java_java_io_Win32FileSystem_canonicalize0, JNI.env, self.jni_id, path.jni_id)
    end
    
    typesig { [String, String] }
    def canonicalize_with_prefix(canonical_prefix, filename)
      return canonicalize_with_prefix0(canonical_prefix, canonical_prefix + RJava.cast_to_string(JavaFile.attr_separator_char) + filename)
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_canonicalizeWithPrefix0, [:pointer, :long, :long, :long], :long
    typesig { [String, String] }
    # Run the canonicalization operation assuming that the prefix
    # (everything up to the last filename) is canonical; just gets
    # the canonical name of the last element of the path
    def canonicalize_with_prefix0(canonical_prefix, path_with_canonical_prefix)
      JNI.__send__(:Java_java_io_Win32FileSystem_canonicalizeWithPrefix0, JNI.env, self.jni_id, canonical_prefix.jni_id, path_with_canonical_prefix.jni_id)
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
        alt_sep = Character.new(?/.ord)
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
            if ((non_dot_count).equal?(0))
              # Punt on pathnames ending in a .
              return nil
            end
          else
            if ((c).equal?(sep))
              if ((adjacent_dots).equal?(1) && (non_dot_count).equal?(0))
                # Punt on pathnames containing . and ..
                return nil
              end
              if ((idx).equal?(0) || idx >= last - 1 || (path.char_at(idx - 1)).equal?(sep) || (path.char_at(idx - 1)).equal?(alt_sep))
                # Punt on pathnames containing adjacent slashes
                # toward the end
                return nil
              end
              return path.substring(0, idx)
            else
              if ((c).equal?(alt_sep))
                # Punt on pathnames containing both backward and
                # forward slashes
                return nil
              else
                if ((c).equal?(Character.new(?*.ord)) || (c).equal?(Character.new(??.ord)))
                  # Punt on pathnames containing wildcards
                  return nil
                else
                  (non_dot_count += 1)
                  adjacent_dots = 0
                end
              end
            end
          end
          (idx -= 1)
        end
        return nil
      end
    }
    
    JNI.native_method :Java_java_io_Win32FileSystem_getBooleanAttributes, [:pointer, :long, :long], :int32
    typesig { [JavaFile] }
    # -- Attribute accessors --
    def get_boolean_attributes(f)
      JNI.__send__(:Java_java_io_Win32FileSystem_getBooleanAttributes, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_checkAccess, [:pointer, :long, :long, :int32], :int8
    typesig { [JavaFile, ::Java::Int] }
    def check_access(f, access)
      JNI.__send__(:Java_java_io_Win32FileSystem_checkAccess, JNI.env, self.jni_id, f.jni_id, access.to_int) != 0
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_getLastModifiedTime, [:pointer, :long, :long], :int64
    typesig { [JavaFile] }
    def get_last_modified_time(f)
      JNI.__send__(:Java_java_io_Win32FileSystem_getLastModifiedTime, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_getLength, [:pointer, :long, :long], :int64
    typesig { [JavaFile] }
    def get_length(f)
      JNI.__send__(:Java_java_io_Win32FileSystem_getLength, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_setPermission, [:pointer, :long, :long, :int32, :int8, :int8], :int8
    typesig { [JavaFile, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    def set_permission(f, access, enable, owneronly)
      JNI.__send__(:Java_java_io_Win32FileSystem_setPermission, JNI.env, self.jni_id, f.jni_id, access.to_int, enable ? 1 : 0, owneronly ? 1 : 0) != 0
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_createFileExclusively, [:pointer, :long, :long], :int8
    typesig { [String] }
    # -- File operations --
    def create_file_exclusively(path)
      JNI.__send__(:Java_java_io_Win32FileSystem_createFileExclusively, JNI.env, self.jni_id, path.jni_id) != 0
    end
    
    typesig { [JavaFile] }
    def delete(f)
      # Keep canonicalization caches in sync after file deletion
      # and renaming operations. Could be more clever than this
      # (i.e., only remove/update affected entries) but probably
      # not worth it since these entries expire after 30 seconds
      # anyway.
      @cache.clear
      @prefix_cache.clear
      return delete0(f)
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_delete0, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def delete0(f)
      JNI.__send__(:Java_java_io_Win32FileSystem_delete0, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_list, [:pointer, :long, :long], :long
    typesig { [JavaFile] }
    def list(f)
      JNI.__send__(:Java_java_io_Win32FileSystem_list, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_createDirectory, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def create_directory(f)
      JNI.__send__(:Java_java_io_Win32FileSystem_createDirectory, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    typesig { [JavaFile, JavaFile] }
    def rename(f1, f2)
      # Keep canonicalization caches in sync after file deletion
      # and renaming operations. Could be more clever than this
      # (i.e., only remove/update affected entries) but probably
      # not worth it since these entries expire after 30 seconds
      # anyway.
      @cache.clear
      @prefix_cache.clear
      return rename0(f1, f2)
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_rename0, [:pointer, :long, :long, :long], :int8
    typesig { [JavaFile, JavaFile] }
    def rename0(f1, f2)
      JNI.__send__(:Java_java_io_Win32FileSystem_rename0, JNI.env, self.jni_id, f1.jni_id, f2.jni_id) != 0
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_setLastModifiedTime, [:pointer, :long, :long, :int64], :int8
    typesig { [JavaFile, ::Java::Long] }
    def set_last_modified_time(f, time)
      JNI.__send__(:Java_java_io_Win32FileSystem_setLastModifiedTime, JNI.env, self.jni_id, f.jni_id, time.to_int) != 0
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_setReadOnly, [:pointer, :long, :long], :int8
    typesig { [JavaFile] }
    def set_read_only(f)
      JNI.__send__(:Java_java_io_Win32FileSystem_setReadOnly, JNI.env, self.jni_id, f.jni_id) != 0
    end
    
    typesig { [String] }
    # -- Filesystem interface --
    def access(path)
      begin
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_read(path)
        end
        return true
      rescue SecurityException => x
        return false
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_Win32FileSystem_listRoots0, [:pointer, :long], :int32
      typesig { [] }
      def list_roots0
        JNI.__send__(:Java_java_io_Win32FileSystem_listRoots0, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    def list_roots
      ds = list_roots0
      n = 0
      i = 0
      while i < 26
        if (!(((ds >> i) & 1)).equal?(0))
          if (!access(RJava.cast_to_string(RJava.cast_to_char((Character.new(?A.ord) + i))) + ":" + RJava.cast_to_string(@slash)))
            ds &= ~(1 << i)
          else
            n += 1
          end
        end
        i += 1
      end
      fs = Array.typed(JavaFile).new(n) { nil }
      j = 0
      slash = @slash
      i_ = 0
      while i_ < 26
        if (!(((ds >> i_) & 1)).equal?(0))
          fs[((j += 1) - 1)] = JavaFile.new(RJava.cast_to_string(RJava.cast_to_char((Character.new(?A.ord) + i_))) + ":" + RJava.cast_to_string(slash))
        end
        i_ += 1
      end
      return fs
    end
    
    typesig { [JavaFile, ::Java::Int] }
    # -- Disk usage --
    def get_space(f, t)
      if (f.exists)
        file = (f.is_directory ? f : f.get_parent_file)
        return get_space0(file, t)
      end
      return 0
    end
    
    JNI.native_method :Java_java_io_Win32FileSystem_getSpace0, [:pointer, :long, :long, :int32], :int64
    typesig { [JavaFile, ::Java::Int] }
    def get_space0(f, t)
      JNI.__send__(:Java_java_io_Win32FileSystem_getSpace0, JNI.env, self.jni_id, f.jni_id, t.to_int)
    end
    
    typesig { [JavaFile, JavaFile] }
    # -- Basic infrastructure --
    def compare(f1, f2)
      return f1.get_path.compare_to_ignore_case(f2.get_path)
    end
    
    typesig { [JavaFile] }
    def hash_code(f)
      # Could make this more efficient: String.hashCodeIgnoreCase
      return f.get_path.to_lower_case(Locale::ENGLISH).hash_code ^ 1234321
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_Win32FileSystem_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_java_io_Win32FileSystem_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_ids
      end
    }
    
    private
    alias_method :initialize__win32file_system, :initialize
  end
  
end
