require "rjava"

# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FilePermissionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include ::Java::Security
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Collections
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # This class represents access to a file or directory.  A FilePermission consists
  # of a pathname and a set of actions valid for that pathname.
  # <P>
  # Pathname is the pathname of the file or directory granted the specified
  # actions. A pathname that ends in "/*" (where "/" is
  # the file separator character, <code>File.separatorChar</code>) indicates
  # all the files and directories contained in that directory. A pathname
  # that ends with "/-" indicates (recursively) all files
  # and subdirectories contained in that directory. A pathname consisting of
  # the special token "&lt;&lt;ALL FILES&gt;&gt;" matches <b>any</b> file.
  # <P>
  # Note: A pathname consisting of a single "*" indicates all the files
  # in the current directory, while a pathname consisting of a single "-"
  # indicates all the files in the current directory and
  # (recursively) all files and subdirectories contained in the current
  # directory.
  # <P>
  # The actions to be granted are passed to the constructor in a string containing
  # a list of one or more comma-separated keywords. The possible keywords are
  # "read", "write", "execute", and "delete". Their meaning is defined as follows:
  # <P>
  # <DL>
  # <DT> read <DD> read permission
  # <DT> write <DD> write permission
  # <DT> execute
  # <DD> execute permission. Allows <code>Runtime.exec</code> to
  # be called. Corresponds to <code>SecurityManager.checkExec</code>.
  # <DT> delete
  # <DD> delete permission. Allows <code>File.delete</code> to
  # be called. Corresponds to <code>SecurityManager.checkDelete</code>.
  # </DL>
  # <P>
  # The actions string is converted to lowercase before processing.
  # <P>
  # Be careful when granting FilePermissions. Think about the implications
  # of granting read and especially write access to various files and
  # directories. The "&lt;&lt;ALL FILES>>" permission with write action is
  # especially dangerous. This grants permission to write to the entire
  # file system. One thing this effectively allows is replacement of the
  # system binary, including the JVM runtime environment.
  # 
  # <p>Please note: Code can always read a file from the same
  # directory it's in (or a subdirectory of that directory); it does not
  # need explicit permission to do so.
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # 
  # 
  # @author Marianne Mueller
  # @author Roland Schemers
  # @since 1.2
  # 
  # @serial exclude
  class FilePermission < FilePermissionImports.const_get :Permission
    include_class_members FilePermissionImports
    overload_protected {
      include Serializable
    }
    
    class_module.module_eval {
      # Execute action.
      const_set_lazy(:EXECUTE) { 0x1 }
      const_attr_reader  :EXECUTE
      
      # Write action.
      const_set_lazy(:WRITE) { 0x2 }
      const_attr_reader  :WRITE
      
      # Read action.
      const_set_lazy(:READ) { 0x4 }
      const_attr_reader  :READ
      
      # Delete action.
      const_set_lazy(:DELETE) { 0x8 }
      const_attr_reader  :DELETE
      
      # All actions (read,write,execute,delete)
      const_set_lazy(:ALL) { READ | WRITE | EXECUTE | DELETE }
      const_attr_reader  :ALL
      
      # No actions.
      const_set_lazy(:NONE) { 0x0 }
      const_attr_reader  :NONE
    }
    
    # the actions mask
    attr_accessor :mask
    alias_method :attr_mask, :mask
    undef_method :mask
    alias_method :attr_mask=, :mask=
    undef_method :mask=
    
    # does path indicate a directory? (wildcard or recursive)
    attr_accessor :directory
    alias_method :attr_directory, :directory
    undef_method :directory
    alias_method :attr_directory=, :directory=
    undef_method :directory=
    
    # is it a recursive directory specification?
    attr_accessor :recursive
    alias_method :attr_recursive, :recursive
    undef_method :recursive
    alias_method :attr_recursive=, :recursive=
    undef_method :recursive=
    
    # the actions string.
    # 
    # @serial
    attr_accessor :actions
    alias_method :attr_actions, :actions
    undef_method :actions
    alias_method :attr_actions=, :actions=
    undef_method :actions=
    
    # Left null as long as possible, then
    # created and re-used in the getAction function.
    # canonicalized dir path. In the case of
    # directories, it is the name "/blah/*" or "/blah/-" without
    # the last character (the "*" or "-").
    attr_accessor :cpath
    alias_method :attr_cpath, :cpath
    undef_method :cpath
    alias_method :attr_cpath=, :cpath=
    undef_method :cpath=
    
    class_module.module_eval {
      # static Strings used by init(int mask)
      const_set_lazy(:RECURSIVE_CHAR) { Character.new(?-.ord) }
      const_attr_reader  :RECURSIVE_CHAR
      
      const_set_lazy(:WILD_CHAR) { Character.new(?*.ord) }
      const_attr_reader  :WILD_CHAR
      
      # public String toString()
      # {
      # StringBuffer sb = new StringBuffer();
      # sb.append("***\n");
      # sb.append("cpath = "+cpath+"\n");
      # sb.append("mask = "+mask+"\n");
      # sb.append("actions = "+getActions()+"\n");
      # sb.append("directory = "+directory+"\n");
      # sb.append("recursive = "+recursive+"\n");
      # sb.append("***\n");
      # return sb.toString();
      # }
      const_set_lazy(:SerialVersionUID) { 7930732926638008763 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Int] }
    # initialize a FilePermission object. Common to all constructors.
    # Also called during de-serialization.
    # 
    # @param mask the actions mask to use.
    def init(mask)
      if (!((mask & ALL)).equal?(mask))
        raise IllegalArgumentException.new("invalid actions mask")
      end
      if ((mask).equal?(NONE))
        raise IllegalArgumentException.new("invalid actions mask")
      end
      if (((@cpath = RJava.cast_to_string(get_name))).nil?)
        raise NullPointerException.new("name can't be null")
      end
      @mask = mask
      if ((@cpath == "<<ALL FILES>>"))
        @directory = true
        @recursive = true
        @cpath = ""
        return
      end
      @cpath = RJava.cast_to_string(AccessController.do_privileged(# store only the canonical cpath if possible
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members FilePermission
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          begin
            return Sun::Security::Provider::PolicyFile.canon_path(self.attr_cpath)
          rescue self.class::IOException => ioe
            return self.attr_cpath
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)))
      len = @cpath.length
      last = ((len > 0) ? @cpath.char_at(len - 1) : 0)
      if ((last).equal?(RECURSIVE_CHAR) && (@cpath.char_at(len - 2)).equal?(JavaFile.attr_separator_char))
        @directory = true
        @recursive = true
        @cpath = RJava.cast_to_string(@cpath.substring(0, (len -= 1)))
      else
        if ((last).equal?(WILD_CHAR) && (@cpath.char_at(len - 2)).equal?(JavaFile.attr_separator_char))
          @directory = true
          # recursive = false;
          @cpath = RJava.cast_to_string(@cpath.substring(0, (len -= 1)))
        else
          # overkill since they are initialized to false, but
          # commented out here to remind us...
          # directory = false;
          # recursive = false;
        end
      end
      # XXX: at this point the path should be absolute. die if it isn't?
    end
    
    typesig { [String, String] }
    # Creates a new FilePermission object with the specified actions.
    # <i>path</i> is the pathname of a file or directory, and <i>actions</i>
    # contains a comma-separated list of the desired actions granted on the
    # file or directory. Possible actions are
    # "read", "write", "execute", and "delete".
    # 
    # <p>A pathname that ends in "/*" (where "/" is
    # the file separator character, <code>File.separatorChar</code>)
    # indicates all the files and directories contained in that directory.
    # A pathname that ends with "/-" indicates (recursively) all files and
    # subdirectories contained in that directory. The special pathname
    # "&lt;&lt;ALL FILES&gt;&gt;" matches any file.
    # 
    # <p>A pathname consisting of a single "*" indicates all the files
    # in the current directory, while a pathname consisting of a single "-"
    # indicates all the files in the current directory and
    # (recursively) all files and subdirectories contained in the current
    # directory.
    # 
    # <p>A pathname containing an empty string represents an empty path.
    # 
    # @param path the pathname of the file/directory.
    # @param actions the action string.
    # 
    # @throws IllegalArgumentException
    # If actions is <code>null</code>, empty or contains an action
    # other than the specified possible actions.
    def initialize(path, actions)
      @mask = 0
      @directory = false
      @recursive = false
      @actions = nil
      @cpath = nil
      super(path)
      init(get_mask(actions))
    end
    
    typesig { [String, ::Java::Int] }
    # Creates a new FilePermission object using an action mask.
    # More efficient than the FilePermission(String, String) constructor.
    # Can be used from within
    # code that needs to create a FilePermission object to pass into the
    # <code>implies</code> method.
    # 
    # @param path the pathname of the file/directory.
    # @param mask the action mask to use.
    # 
    # package private for use by the FilePermissionCollection add method
    def initialize(path, mask)
      @mask = 0
      @directory = false
      @recursive = false
      @actions = nil
      @cpath = nil
      super(path)
      init(mask)
    end
    
    typesig { [Permission] }
    # Checks if this FilePermission object "implies" the specified permission.
    # <P>
    # More specifically, this method returns true if:<p>
    # <ul>
    # <li> <i>p</i> is an instanceof FilePermission,<p>
    # <li> <i>p</i>'s actions are a proper subset of this
    # object's actions, and <p>
    # <li> <i>p</i>'s pathname is implied by this object's
    # pathname. For example, "/tmp/*" implies "/tmp/foo", since
    # "/tmp/*" encompasses all files in the "/tmp" directory,
    # including the one named "foo".
    # </ul>
    # 
    # @param p the permission to check against.
    # 
    # @return <code>true</code> if the specified permission is not
    # <code>null</code> and is implied by this object,
    # <code>false</code> otherwise.
    def implies(p)
      if (!(p.is_a?(FilePermission)))
        return false
      end
      that = p
      # we get the effective mask. i.e., the "and" of this and that.
      # They must be equal to that.mask for implies to return true.
      return (((@mask & that.attr_mask)).equal?(that.attr_mask)) && implies_ignore_mask(that)
    end
    
    typesig { [FilePermission] }
    # Checks if the Permission's actions are a proper subset of the
    # this object's actions. Returns the effective mask iff the
    # this FilePermission's path also implies that FilePermission's path.
    # 
    # @param that the FilePermission to check against.
    # @param exact return immediately if the masks are not equal
    # @return the effective mask
    def implies_ignore_mask(that)
      if (@directory)
        if (@recursive)
          # make sure that.path is longer then path so
          # something like /foo/- does not imply /foo
          if (that.attr_directory)
            return (that.attr_cpath.length >= @cpath.length) && that.attr_cpath.starts_with(@cpath)
          else
            return ((that.attr_cpath.length > @cpath.length) && that.attr_cpath.starts_with(@cpath))
          end
        else
          if (that.attr_directory)
            # if the permission passed in is a directory
            # specification, make sure that a non-recursive
            # permission (i.e., this object) can't imply a recursive
            # permission.
            if (that.attr_recursive)
              return false
            else
              return ((@cpath == that.attr_cpath))
            end
          else
            last = that.attr_cpath.last_index_of(JavaFile.attr_separator_char)
            if ((last).equal?(-1))
              return false
            else
              # this.cpath.equals(that.cpath.substring(0, last+1));
              # Use regionMatches to avoid creating new string
              return ((@cpath.length).equal?((last + 1))) && @cpath.region_matches(0, that.attr_cpath, 0, last + 1)
            end
          end
        end
      else
        if (that.attr_directory)
          # if this is NOT recursive/wildcarded,
          # do not let it imply a recursive/wildcarded permission
          return false
        else
          return ((@cpath == that.attr_cpath))
        end
      end
    end
    
    typesig { [Object] }
    # Checks two FilePermission objects for equality. Checks that <i>obj</i> is
    # a FilePermission, and has the same pathname and actions as this object.
    # <P>
    # @param obj the object we are testing for equality with this object.
    # @return <code>true</code> if obj is a FilePermission, and has the same
    # pathname and actions as this FilePermission object,
    # <code>false</code> otherwise.
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(FilePermission)))
        return false
      end
      that = obj
      return ((@mask).equal?(that.attr_mask)) && (@cpath == that.attr_cpath) && ((@directory).equal?(that.attr_directory)) && ((@recursive).equal?(that.attr_recursive))
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      return @cpath.hash_code
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Converts an actions String to an actions mask.
      # 
      # @param action the action string.
      # @return the actions mask.
      def get_mask(actions)
        mask = NONE
        # Null action valid?
        if ((actions).nil?)
          return mask
        end
        # Check against use of constants (used heavily within the JDK)
        if ((actions).equal?(SecurityConstants::FILE_READ_ACTION))
          return READ
        else
          if ((actions).equal?(SecurityConstants::FILE_WRITE_ACTION))
            return WRITE
          else
            if ((actions).equal?(SecurityConstants::FILE_EXECUTE_ACTION))
              return EXECUTE
            else
              if ((actions).equal?(SecurityConstants::FILE_DELETE_ACTION))
                return DELETE
              end
            end
          end
        end
        a = actions.to_char_array
        i = a.attr_length - 1
        if (i < 0)
          return mask
        end
        while (!(i).equal?(-1))
          c = 0
          # skip whitespace
          while ((!(i).equal?(-1)) && (((c = a[i])).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\r.ord)) || (c).equal?(Character.new(?\n.ord)) || (c).equal?(Character.new(?\f.ord)) || (c).equal?(Character.new(?\t.ord))))
            i -= 1
          end
          # check for the known strings
          matchlen = 0
          if (i >= 3 && ((a[i - 3]).equal?(Character.new(?r.ord)) || (a[i - 3]).equal?(Character.new(?R.ord))) && ((a[i - 2]).equal?(Character.new(?e.ord)) || (a[i - 2]).equal?(Character.new(?E.ord))) && ((a[i - 1]).equal?(Character.new(?a.ord)) || (a[i - 1]).equal?(Character.new(?A.ord))) && ((a[i]).equal?(Character.new(?d.ord)) || (a[i]).equal?(Character.new(?D.ord))))
            matchlen = 4
            mask |= READ
          else
            if (i >= 4 && ((a[i - 4]).equal?(Character.new(?w.ord)) || (a[i - 4]).equal?(Character.new(?W.ord))) && ((a[i - 3]).equal?(Character.new(?r.ord)) || (a[i - 3]).equal?(Character.new(?R.ord))) && ((a[i - 2]).equal?(Character.new(?i.ord)) || (a[i - 2]).equal?(Character.new(?I.ord))) && ((a[i - 1]).equal?(Character.new(?t.ord)) || (a[i - 1]).equal?(Character.new(?T.ord))) && ((a[i]).equal?(Character.new(?e.ord)) || (a[i]).equal?(Character.new(?E.ord))))
              matchlen = 5
              mask |= WRITE
            else
              if (i >= 6 && ((a[i - 6]).equal?(Character.new(?e.ord)) || (a[i - 6]).equal?(Character.new(?E.ord))) && ((a[i - 5]).equal?(Character.new(?x.ord)) || (a[i - 5]).equal?(Character.new(?X.ord))) && ((a[i - 4]).equal?(Character.new(?e.ord)) || (a[i - 4]).equal?(Character.new(?E.ord))) && ((a[i - 3]).equal?(Character.new(?c.ord)) || (a[i - 3]).equal?(Character.new(?C.ord))) && ((a[i - 2]).equal?(Character.new(?u.ord)) || (a[i - 2]).equal?(Character.new(?U.ord))) && ((a[i - 1]).equal?(Character.new(?t.ord)) || (a[i - 1]).equal?(Character.new(?T.ord))) && ((a[i]).equal?(Character.new(?e.ord)) || (a[i]).equal?(Character.new(?E.ord))))
                matchlen = 7
                mask |= EXECUTE
              else
                if (i >= 5 && ((a[i - 5]).equal?(Character.new(?d.ord)) || (a[i - 5]).equal?(Character.new(?D.ord))) && ((a[i - 4]).equal?(Character.new(?e.ord)) || (a[i - 4]).equal?(Character.new(?E.ord))) && ((a[i - 3]).equal?(Character.new(?l.ord)) || (a[i - 3]).equal?(Character.new(?L.ord))) && ((a[i - 2]).equal?(Character.new(?e.ord)) || (a[i - 2]).equal?(Character.new(?E.ord))) && ((a[i - 1]).equal?(Character.new(?t.ord)) || (a[i - 1]).equal?(Character.new(?T.ord))) && ((a[i]).equal?(Character.new(?e.ord)) || (a[i]).equal?(Character.new(?E.ord))))
                  matchlen = 6
                  mask |= DELETE
                else
                  # parse error
                  raise IllegalArgumentException.new("invalid permission: " + actions)
                end
              end
            end
          end
          # make sure we didn't just match the tail of a word
          # like "ackbarfaccept".  Also, skip to the comma.
          seencomma = false
          while (i >= matchlen && !seencomma)
            case (a[i - matchlen])
            # FALLTHROUGH
            when Character.new(?,.ord)
              seencomma = true
            when Character.new(?\s.ord), Character.new(?\r.ord), Character.new(?\n.ord), Character.new(?\f.ord), Character.new(?\t.ord)
            else
              raise IllegalArgumentException.new("invalid permission: " + actions)
            end
            i -= 1
          end
          # point i at the location of the comma minus one (or -1).
          i -= matchlen
        end
        return mask
      end
    }
    
    typesig { [] }
    # Return the current action mask. Used by the FilePermissionCollection.
    # 
    # @return the actions mask.
    def get_mask
      return @mask
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Return the canonical string representation of the actions.
      # Always returns present actions in the following order:
      # read, write, execute, delete.
      # 
      # @return the canonical string representation of the actions.
      def get_actions(mask)
        sb = StringBuilder.new
        comma = false
        if (((mask & READ)).equal?(READ))
          comma = true
          sb.append("read")
        end
        if (((mask & WRITE)).equal?(WRITE))
          if (comma)
            sb.append(Character.new(?,.ord))
          else
            comma = true
          end
          sb.append("write")
        end
        if (((mask & EXECUTE)).equal?(EXECUTE))
          if (comma)
            sb.append(Character.new(?,.ord))
          else
            comma = true
          end
          sb.append("execute")
        end
        if (((mask & DELETE)).equal?(DELETE))
          if (comma)
            sb.append(Character.new(?,.ord))
          else
            comma = true
          end
          sb.append("delete")
        end
        return sb.to_s
      end
    }
    
    typesig { [] }
    # Returns the "canonical string representation" of the actions.
    # That is, this method always returns present actions in the following order:
    # read, write, execute, delete. For example, if this FilePermission object
    # allows both write and read actions, a call to <code>getActions</code>
    # will return the string "read,write".
    # 
    # @return the canonical string representation of the actions.
    def get_actions
      if ((@actions).nil?)
        @actions = RJava.cast_to_string(get_actions(@mask))
      end
      return @actions
    end
    
    typesig { [] }
    # Returns a new PermissionCollection object for storing FilePermission
    # objects.
    # <p>
    # FilePermission objects must be stored in a manner that allows them
    # to be inserted into the collection in any order, but that also enables the
    # PermissionCollection <code>implies</code>
    # method to be implemented in an efficient (and consistent) manner.
    # 
    # <p>For example, if you have two FilePermissions:
    # <OL>
    # <LI>  <code>"/tmp/-", "read"</code>
    # <LI>  <code>"/tmp/scratch/foo", "write"</code>
    # </OL>
    # 
    # <p>and you are calling the <code>implies</code> method with the FilePermission:
    # 
    # <pre>
    # "/tmp/scratch/foo", "read,write",
    # </pre>
    # 
    # then the <code>implies</code> function must
    # take into account both the "/tmp/-" and "/tmp/scratch/foo"
    # permissions, so the effective permission is "read,write",
    # and <code>implies</code> returns true. The "implies" semantics for
    # FilePermissions are handled properly by the PermissionCollection object
    # returned by this <code>newPermissionCollection</code> method.
    # 
    # @return a new PermissionCollection object suitable for storing
    # FilePermissions.
    def new_permission_collection
      return FilePermissionCollection.new
    end
    
    typesig { [ObjectOutputStream] }
    # WriteObject is called to save the state of the FilePermission
    # to a stream. The actions are serialized, and the superclass
    # takes care of the name.
    def write_object(s)
      # Write out the actions. The superclass takes care of the name
      # call getActions to make sure actions field is initialized
      if ((@actions).nil?)
        get_actions
      end
      s.default_write_object
    end
    
    typesig { [ObjectInputStream] }
    # readObject is called to restore the state of the FilePermission from
    # a stream.
    def read_object(s)
      # Read in the actions, then restore everything else by calling init.
      s.default_read_object
      init(get_mask(@actions))
    end
    
    private
    alias_method :initialize__file_permission, :initialize
  end
  
  # A FilePermissionCollection stores a set of FilePermission permissions.
  # FilePermission objects
  # must be stored in a manner that allows them to be inserted in any
  # order, but enable the implies function to evaluate the implies
  # method.
  # For example, if you have two FilePermissions:
  # <OL>
  # <LI> "/tmp/-", "read"
  # <LI> "/tmp/scratch/foo", "write"
  # </OL>
  # And you are calling the implies function with the FilePermission:
  # "/tmp/scratch/foo", "read,write", then the implies function must
  # take into account both the /tmp/- and /tmp/scratch/foo
  # permissions, so the effective permission is "read,write".
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # 
  # 
  # @author Marianne Mueller
  # @author Roland Schemers
  # 
  # @serial include
  class FilePermissionCollection < FilePermissionImports.const_get :PermissionCollection
    include_class_members FilePermissionImports
    overload_protected {
      include Serializable
    }
    
    # Not serialized; see serialization section at end of class
    attr_accessor :perms
    alias_method :attr_perms, :perms
    undef_method :perms
    alias_method :attr_perms=, :perms=
    undef_method :perms=
    
    typesig { [] }
    # Create an empty FilePermissions object.
    def initialize
      @perms = nil
      super()
      @perms = ArrayList.new
    end
    
    typesig { [Permission] }
    # Adds a permission to the FilePermissions. The key for the hash is
    # permission.path.
    # 
    # @param permission the Permission object to add.
    # 
    # @exception IllegalArgumentException - if the permission is not a
    # FilePermission
    # 
    # @exception SecurityException - if this FilePermissionCollection object
    # has been marked readonly
    def add(permission)
      if (!(permission.is_a?(FilePermission)))
        raise IllegalArgumentException.new("invalid permission: " + RJava.cast_to_string(permission))
      end
      if (is_read_only)
        raise SecurityException.new("attempt to add a Permission to a readonly PermissionCollection")
      end
      synchronized((self)) do
        @perms.add(permission)
      end
    end
    
    typesig { [Permission] }
    # Check and see if this set of permissions implies the permissions
    # expressed in "permission".
    # 
    # @param p the Permission object to compare
    # 
    # @return true if "permission" is a proper subset of a permission in
    # the set, false if not.
    def implies(permission)
      if (!(permission.is_a?(FilePermission)))
        return false
      end
      fp = permission
      desired = fp.get_mask
      effective = 0
      needed = desired
      synchronized((self)) do
        len = @perms.size
        i = 0
        while i < len
          x = @perms.get(i)
          if ((!((needed & x.get_mask)).equal?(0)) && x.implies_ignore_mask(fp))
            effective |= x.get_mask
            if (((effective & desired)).equal?(desired))
              return true
            end
            needed = (desired ^ effective)
          end
          i += 1
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns an enumeration of all the FilePermission objects in the
    # container.
    # 
    # @return an enumeration of all the FilePermission objects.
    def elements
      # Convert Iterator into Enumeration
      synchronized((self)) do
        return Collections.enumeration(@perms)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 2202956749081564585 }
      const_attr_reader  :SerialVersionUID
      
      # Need to maintain serialization interoperability with earlier releases,
      # which had the serializable field:
      # private Vector permissions;
      # 
      # @serialField permissions java.util.Vector
      # A list of FilePermission objects.
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("permissions", Vector), ]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData "permissions" field (a Vector containing the FilePermissions).
    # 
    # 
    # Writes the contents of the perms field out as a Vector for
    # serialization compatibility with earlier releases.
    def write_object(out)
      # Don't call out.defaultWriteObject()
      # Write out Vector
      permissions = Vector.new(@perms.size)
      synchronized((self)) do
        permissions.add_all(@perms)
      end
      pfields = out.put_fields
      pfields.put("permissions", permissions)
      out.write_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reads in a Vector of FilePermissions and saves them in the perms field.
    def read_object(in_)
      # Don't call defaultReadObject()
      # Read in serialized fields
      gfields = in_.read_fields
      # Get the one we want
      permissions = gfields.get("permissions", nil)
      @perms = ArrayList.new(permissions.size)
      @perms.add_all(permissions)
    end
    
    private
    alias_method :initialize__file_permission_collection, :initialize
  end
  
end
