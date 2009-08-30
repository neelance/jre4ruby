require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FileSystemPreferencesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Util::Logging, :Logger
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
    }
  end
  
  # Preferences implementation for Unix.  Preferences are stored in the file
  # system, with one directory per preferences node.  All of the preferences
  # at each node are stored in a single file.  Atomic file system operations
  # (e.g. File.renameTo) are used to ensure integrity.  An in-memory cache of
  # the "explored" portion of the tree is maintained for performance, and
  # written back to the disk periodically.  File-locking is used to ensure
  # reasonable behavior when multiple VMs are running at the same time.
  # (The file lock is obtained only for sync(), flush() and removeNode().)
  # 
  # @author  Josh Bloch
  # @see     Preferences
  # @since   1.4
  class FileSystemPreferences < FileSystemPreferencesImports.const_get :AbstractPreferences
    include_class_members FileSystemPreferencesImports
    
    class_module.module_eval {
      const_set_lazy(:SYNC_INTERVAL) { Math.max(1, JavaInteger.parse_int(AccessController.do_privileged(# Sync interval in seconds.
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members FileSystemPreferences
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return System.get_property("java.util.prefs.syncInterval", "30")
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)))) }
      const_attr_reader  :SYNC_INTERVAL
      
      typesig { [] }
      # Returns logger for error messages. Backing store exceptions are logged at
      # WARNING level.
      def get_logger
        return Logger.get_logger("java.util.prefs")
      end
      
      # Directory for system preferences.
      
      def system_root_dir
        defined?(@@system_root_dir) ? @@system_root_dir : @@system_root_dir= nil
      end
      alias_method :attr_system_root_dir, :system_root_dir
      
      def system_root_dir=(value)
        @@system_root_dir = value
      end
      alias_method :attr_system_root_dir=, :system_root_dir=
      
      # Flag, indicating whether systemRoot  directory is writable
      
      def is_system_root_writable
        defined?(@@is_system_root_writable) ? @@is_system_root_writable : @@is_system_root_writable= false
      end
      alias_method :attr_is_system_root_writable, :is_system_root_writable
      
      def is_system_root_writable=(value)
        @@is_system_root_writable = value
      end
      alias_method :attr_is_system_root_writable=, :is_system_root_writable=
      
      # Directory for user preferences.
      
      def user_root_dir
        defined?(@@user_root_dir) ? @@user_root_dir : @@user_root_dir= nil
      end
      alias_method :attr_user_root_dir, :user_root_dir
      
      def user_root_dir=(value)
        @@user_root_dir = value
      end
      alias_method :attr_user_root_dir=, :user_root_dir=
      
      # Flag, indicating whether userRoot  directory is writable
      
      def is_user_root_writable
        defined?(@@is_user_root_writable) ? @@is_user_root_writable : @@is_user_root_writable= false
      end
      alias_method :attr_is_user_root_writable, :is_user_root_writable
      
      def is_user_root_writable=(value)
        @@is_user_root_writable = value
      end
      alias_method :attr_is_user_root_writable=, :is_user_root_writable=
      
      # The user root.
      
      def user_root
        defined?(@@user_root) ? @@user_root : @@user_root= nil
      end
      alias_method :attr_user_root, :user_root
      
      def user_root=(value)
        @@user_root = value
      end
      alias_method :attr_user_root=, :user_root=
      
      typesig { [] }
      def get_user_root
        synchronized(self) do
          if ((self.attr_user_root).nil?)
            setup_user_root
            self.attr_user_root = FileSystemPreferences.new(true)
          end
          return self.attr_user_root
        end
      end
      
      typesig { [] }
      def setup_user_root
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_user_root_dir = self.class::JavaFile.new(System.get_property("java.util.prefs.userRoot", System.get_property("user.home")), ".java/.userPrefs")
            # Attempt to create root dir if it does not yet exist.
            if (!self.attr_user_root_dir.exists)
              if (self.attr_user_root_dir.mkdirs)
                begin
                  chmod(self.attr_user_root_dir.get_canonical_path, USER_RWX)
                rescue self.class::IOException => e
                  get_logger.warning("Could not change permissions" + " on userRoot directory. ")
                end
                get_logger.info("Created user preferences directory.")
              else
                get_logger.warning("Couldn't create user preferences" + " directory. User preferences are unusable.")
              end
            end
            self.attr_is_user_root_writable = self.attr_user_root_dir.can_write
            user_name = System.get_property("user.name")
            self.attr_user_lock_file = self.class::JavaFile.new(self.attr_user_root_dir, ".user.lock." + user_name)
            self.attr_user_root_mod_file = self.class::JavaFile.new(self.attr_user_root_dir, ".userRootModFile." + user_name)
            if (!self.attr_user_root_mod_file.exists)
              begin
                # create if does not exist.
                self.attr_user_root_mod_file.create_new_file
                # Only user can read/write userRootModFile.
                result = chmod(self.attr_user_root_mod_file.get_canonical_path, USER_READ_WRITE)
                if (!(result).equal?(0))
                  get_logger.warning("Problem creating userRoot " + "mod file. Chmod failed on " + RJava.cast_to_string(self.attr_user_root_mod_file.get_canonical_path) + " Unix error code " + RJava.cast_to_string(result))
                end
              rescue self.class::IOException => e
                get_logger.warning(e.to_s)
              end
            end
            self.attr_user_root_mod_time = self.attr_user_root_mod_file.last_modified
            return nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      # The system root.
      
      def system_root
        defined?(@@system_root) ? @@system_root : @@system_root= nil
      end
      alias_method :attr_system_root, :system_root
      
      def system_root=(value)
        @@system_root = value
      end
      alias_method :attr_system_root=, :system_root=
      
      typesig { [] }
      def get_system_root
        synchronized(self) do
          if ((self.attr_system_root).nil?)
            setup_system_root
            self.attr_system_root = FileSystemPreferences.new(false)
          end
          return self.attr_system_root
        end
      end
      
      typesig { [] }
      def setup_system_root
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            system_prefs_dir_name = System.get_property("java.util.prefs.systemRoot", "/etc/.java")
            self.attr_system_root_dir = self.class::JavaFile.new(system_prefs_dir_name, ".systemPrefs")
            # Attempt to create root dir if it does not yet exist.
            if (!self.attr_system_root_dir.exists)
              # system root does not exist in /etc/.java
              # Switching  to java.home
              self.attr_system_root_dir = self.class::JavaFile.new(System.get_property("java.home"), ".systemPrefs")
              if (!self.attr_system_root_dir.exists)
                if (self.attr_system_root_dir.mkdirs)
                  get_logger.info("Created system preferences directory " + "in java.home.")
                  begin
                    chmod(self.attr_system_root_dir.get_canonical_path, USER_RWX_ALL_RX)
                  rescue self.class::IOException => e
                  end
                else
                  get_logger.warning("Could not create " + "system preferences directory. System " + "preferences are unusable.")
                end
              end
            end
            self.attr_is_system_root_writable = self.attr_system_root_dir.can_write
            self.attr_system_lock_file = self.class::JavaFile.new(self.attr_system_root_dir, ".system.lock")
            self.attr_system_root_mod_file = self.class::JavaFile.new(self.attr_system_root_dir, ".systemRootModFile")
            if (!self.attr_system_root_mod_file.exists && self.attr_is_system_root_writable)
              begin
                # create if does not exist.
                self.attr_system_root_mod_file.create_new_file
                result = chmod(self.attr_system_root_mod_file.get_canonical_path, USER_RW_ALL_READ)
                if (!(result).equal?(0))
                  get_logger.warning("Chmod failed on " + RJava.cast_to_string(self.attr_system_root_mod_file.get_canonical_path) + " Unix error code " + RJava.cast_to_string(result))
                end
              rescue self.class::IOException => e
                get_logger.warning(e.to_s)
              end
            end
            self.attr_system_root_mod_time = self.attr_system_root_mod_file.last_modified
            return nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      # Unix user write/read permission
      const_set_lazy(:USER_READ_WRITE) { 600 }
      const_attr_reader  :USER_READ_WRITE
      
      const_set_lazy(:USER_RW_ALL_READ) { 644 }
      const_attr_reader  :USER_RW_ALL_READ
      
      const_set_lazy(:USER_RWX_ALL_RX) { 755 }
      const_attr_reader  :USER_RWX_ALL_RX
      
      const_set_lazy(:USER_RWX) { 700 }
      const_attr_reader  :USER_RWX
      
      # The lock file for the user tree.
      
      def user_lock_file
        defined?(@@user_lock_file) ? @@user_lock_file : @@user_lock_file= nil
      end
      alias_method :attr_user_lock_file, :user_lock_file
      
      def user_lock_file=(value)
        @@user_lock_file = value
      end
      alias_method :attr_user_lock_file=, :user_lock_file=
      
      # The lock file for the system tree.
      
      def system_lock_file
        defined?(@@system_lock_file) ? @@system_lock_file : @@system_lock_file= nil
      end
      alias_method :attr_system_lock_file, :system_lock_file
      
      def system_lock_file=(value)
        @@system_lock_file = value
      end
      alias_method :attr_system_lock_file=, :system_lock_file=
      
      # Unix lock handle for userRoot.
      # Zero, if unlocked.
      
      def user_root_lock_handle
        defined?(@@user_root_lock_handle) ? @@user_root_lock_handle : @@user_root_lock_handle= 0
      end
      alias_method :attr_user_root_lock_handle, :user_root_lock_handle
      
      def user_root_lock_handle=(value)
        @@user_root_lock_handle = value
      end
      alias_method :attr_user_root_lock_handle=, :user_root_lock_handle=
      
      # Unix lock handle for systemRoot.
      # Zero, if unlocked.
      
      def system_root_lock_handle
        defined?(@@system_root_lock_handle) ? @@system_root_lock_handle : @@system_root_lock_handle= 0
      end
      alias_method :attr_system_root_lock_handle, :system_root_lock_handle
      
      def system_root_lock_handle=(value)
        @@system_root_lock_handle = value
      end
      alias_method :attr_system_root_lock_handle=, :system_root_lock_handle=
    }
    
    # The directory representing this preference node.  There is no guarantee
    # that this directory exits, as another VM can delete it at any time
    # that it (the other VM) holds the file-lock.  While the root node cannot
    # be deleted, it may not yet have been created, or the underlying
    # directory could have been deleted accidentally.
    attr_accessor :dir
    alias_method :attr_dir, :dir
    undef_method :dir
    alias_method :attr_dir=, :dir=
    undef_method :dir=
    
    # The file representing this preference node's preferences.
    # The file format is undocumented, and subject to change
    # from release to release, but I'm sure that you can figure
    # it out if you try real hard.
    attr_accessor :prefs_file
    alias_method :attr_prefs_file, :prefs_file
    undef_method :prefs_file
    alias_method :attr_prefs_file=, :prefs_file=
    undef_method :prefs_file=
    
    # A temporary file used for saving changes to preferences.  As part of
    # the sync operation, changes are first saved into this file, and then
    # atomically renamed to prefsFile.  This results in an atomic state
    # change from one valid set of preferences to another.  The
    # the file-lock is held for the duration of this transformation.
    attr_accessor :tmp_file
    alias_method :attr_tmp_file, :tmp_file
    undef_method :tmp_file
    alias_method :attr_tmp_file=, :tmp_file=
    undef_method :tmp_file=
    
    class_module.module_eval {
      # File, which keeps track of global modifications of userRoot.
      
      def user_root_mod_file
        defined?(@@user_root_mod_file) ? @@user_root_mod_file : @@user_root_mod_file= nil
      end
      alias_method :attr_user_root_mod_file, :user_root_mod_file
      
      def user_root_mod_file=(value)
        @@user_root_mod_file = value
      end
      alias_method :attr_user_root_mod_file=, :user_root_mod_file=
      
      # Flag, which indicated whether userRoot was modified by another VM
      
      def is_user_root_modified
        defined?(@@is_user_root_modified) ? @@is_user_root_modified : @@is_user_root_modified= false
      end
      alias_method :attr_is_user_root_modified, :is_user_root_modified
      
      def is_user_root_modified=(value)
        @@is_user_root_modified = value
      end
      alias_method :attr_is_user_root_modified=, :is_user_root_modified=
      
      # Keeps track of userRoot modification time. This time is reset to
      # zero after UNIX reboot, and is increased by 1 second each time
      # userRoot is modified.
      
      def user_root_mod_time
        defined?(@@user_root_mod_time) ? @@user_root_mod_time : @@user_root_mod_time= 0
      end
      alias_method :attr_user_root_mod_time, :user_root_mod_time
      
      def user_root_mod_time=(value)
        @@user_root_mod_time = value
      end
      alias_method :attr_user_root_mod_time=, :user_root_mod_time=
      
      # File, which keeps track of global modifications of systemRoot
      
      def system_root_mod_file
        defined?(@@system_root_mod_file) ? @@system_root_mod_file : @@system_root_mod_file= nil
      end
      alias_method :attr_system_root_mod_file, :system_root_mod_file
      
      def system_root_mod_file=(value)
        @@system_root_mod_file = value
      end
      alias_method :attr_system_root_mod_file=, :system_root_mod_file=
      
      # Flag, which indicates whether systemRoot was modified by another VM
      
      def is_system_root_modified
        defined?(@@is_system_root_modified) ? @@is_system_root_modified : @@is_system_root_modified= false
      end
      alias_method :attr_is_system_root_modified, :is_system_root_modified
      
      def is_system_root_modified=(value)
        @@is_system_root_modified = value
      end
      alias_method :attr_is_system_root_modified=, :is_system_root_modified=
      
      # Keeps track of systemRoot modification time. This time is reset to
      # zero after system reboot, and is increased by 1 second each time
      # systemRoot is modified.
      
      def system_root_mod_time
        defined?(@@system_root_mod_time) ? @@system_root_mod_time : @@system_root_mod_time= 0
      end
      alias_method :attr_system_root_mod_time, :system_root_mod_time
      
      def system_root_mod_time=(value)
        @@system_root_mod_time = value
      end
      alias_method :attr_system_root_mod_time=, :system_root_mod_time=
    }
    
    # Locally cached preferences for this node (includes uncommitted
    # changes).  This map is initialized with from disk when the first get or
    # put operation occurs on this node.  It is synchronized with the
    # corresponding disk file (prefsFile) by the sync operation.  The initial
    # value is read *without* acquiring the file-lock.
    attr_accessor :prefs_cache
    alias_method :attr_prefs_cache, :prefs_cache
    undef_method :prefs_cache
    alias_method :attr_prefs_cache=, :prefs_cache=
    undef_method :prefs_cache=
    
    # The last modification time of the file backing this node at the time
    # that prefCache was last synchronized (or initially read).  This
    # value is set *before* reading the file, so it's conservative; the
    # actual timestamp could be (slightly) higher.  A value of zero indicates
    # that we were unable to initialize prefsCache from the disk, or
    # have not yet attempted to do so.  (If prefsCache is non-null, it
    # indicates the former; if it's null, the latter.)
    attr_accessor :last_sync_time
    alias_method :attr_last_sync_time, :last_sync_time
    undef_method :last_sync_time
    alias_method :attr_last_sync_time=, :last_sync_time=
    undef_method :last_sync_time=
    
    class_module.module_eval {
      # Unix error code for locked file.
      const_set_lazy(:EAGAIN) { 11 }
      const_attr_reader  :EAGAIN
      
      # Unix error code for denied access.
      const_set_lazy(:EACCES) { 13 }
      const_attr_reader  :EACCES
      
      # Used to interpret results of native functions
      const_set_lazy(:LOCK_HANDLE) { 0 }
      const_attr_reader  :LOCK_HANDLE
      
      const_set_lazy(:ERROR_CODE) { 1 }
      const_attr_reader  :ERROR_CODE
    }
    
    # A list of all uncommitted preference changes.  The elements in this
    # list are of type PrefChange.  If this node is concurrently modified on
    # disk by another VM, the two sets of changes are merged when this node
    # is sync'ed by overwriting our prefsCache with the preference map last
    # written out to disk (by the other VM), and then replaying this change
    # log against that map.  The resulting map is then written back
    # to the disk.
    attr_accessor :change_log
    alias_method :attr_change_log, :change_log
    undef_method :change_log
    alias_method :attr_change_log=, :change_log=
    undef_method :change_log=
    
    class_module.module_eval {
      # Represents a change to a preference.
      const_set_lazy(:Change) { Class.new do
        extend LocalClass
        include_class_members FileSystemPreferences
        
        typesig { [] }
        # Reapplies the change to prefsCache.
        def replay
          raise NotImplementedError
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__change, :initialize
      end }
      
      # Represents a preference put.
      const_set_lazy(:Put) { Class.new(Change) do
        extend LocalClass
        include_class_members FileSystemPreferences
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :value
        alias_method :attr_value, :value
        undef_method :value
        alias_method :attr_value=, :value=
        undef_method :value=
        
        typesig { [String, String] }
        def initialize(key, value)
          @key = nil
          @value = nil
          super()
          @key = key
          @value = value
        end
        
        typesig { [] }
        def replay
          self.attr_prefs_cache.put(@key, @value)
        end
        
        private
        alias_method :initialize__put, :initialize
      end }
      
      # Represents a preference remove.
      const_set_lazy(:Remove) { Class.new(Change) do
        extend LocalClass
        include_class_members FileSystemPreferences
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        typesig { [String] }
        def initialize(key)
          @key = nil
          super()
          @key = key
        end
        
        typesig { [] }
        def replay
          self.attr_prefs_cache.remove(@key)
        end
        
        private
        alias_method :initialize__remove, :initialize
      end }
      
      # Represents the creation of this node.
      const_set_lazy(:NodeCreate) { Class.new(Change) do
        extend LocalClass
        include_class_members FileSystemPreferences
        
        typesig { [] }
        # Performs no action, but the presence of this object in changeLog
        # will force the node and its ancestors to be made permanent at the
        # next sync.
        def replay
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__node_create, :initialize
      end }
    }
    
    # NodeCreate object for this node.
    attr_accessor :node_create
    alias_method :attr_node_create, :node_create
    undef_method :node_create
    alias_method :attr_node_create=, :node_create=
    undef_method :node_create=
    
    typesig { [] }
    # Replay changeLog against prefsCache.
    def replay_changes
      i = 0
      n = @change_log.size
      while i < n
        (@change_log.get(i)).replay
        i += 1
      end
    end
    
    class_module.module_eval {
      
      def sync_timer
        defined?(@@sync_timer) ? @@sync_timer : @@sync_timer= Timer.new(true)
      end
      alias_method :attr_sync_timer, :sync_timer
      
      def sync_timer=(value)
        @@sync_timer = value
      end
      alias_method :attr_sync_timer=, :sync_timer=
      
      # Daemon Thread
      when_class_loaded do
        self.attr_sync_timer.schedule(# Add periodic timer task to periodically sync cached prefs
        Class.new(TimerTask.class == Class ? TimerTask : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include TimerTask if TimerTask.class == Module
          
          typesig { [] }
          define_method :run do
            sync_world
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self), SYNC_INTERVAL * 1000, SYNC_INTERVAL * 1000)
        AccessController.do_privileged(# Add shutdown hook to flush cached prefs on normal termination
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            privileged_action_class = self.class
            Runtime.get_runtime.add_shutdown_hook(Class.new(self.class::JavaThread.class == Class ? self.class::JavaThread : Object) do
              extend LocalClass
              include_class_members privileged_action_class
              include class_self::JavaThread if class_self::JavaThread.class == Module
              
              typesig { [] }
              define_method :run do
                self.attr_sync_timer.cancel
                sync_world
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            return nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [] }
      def sync_world
        # Synchronization necessary because userRoot and systemRoot are
        # lazily initialized.
        user_rt = nil
        system_rt = nil
        synchronized((FileSystemPreferences)) do
          user_rt = self.attr_user_root
          system_rt = self.attr_system_root
        end
        begin
          if (!(user_rt).nil?)
            user_rt.flush
          end
        rescue BackingStoreException => e
          get_logger.warning("Couldn't flush user prefs: " + RJava.cast_to_string(e))
        end
        begin
          if (!(system_rt).nil?)
            system_rt.flush
          end
        rescue BackingStoreException => e
          get_logger.warning("Couldn't flush system prefs: " + RJava.cast_to_string(e))
        end
      end
    }
    
    attr_accessor :is_user_node
    alias_method :attr_is_user_node, :is_user_node
    undef_method :is_user_node
    alias_method :attr_is_user_node=, :is_user_node=
    undef_method :is_user_node=
    
    typesig { [::Java::Boolean] }
    # Special constructor for roots (both user and system).  This constructor
    # will only be called twice, by the static initializer.
    def initialize(user)
      @dir = nil
      @prefs_file = nil
      @tmp_file = nil
      @prefs_cache = nil
      @last_sync_time = 0
      @change_log = nil
      @node_create = nil
      @is_user_node = false
      super(nil, "")
      @prefs_cache = nil
      @last_sync_time = 0
      @change_log = ArrayList.new
      @node_create = nil
      @is_user_node = user
      @dir = (user ? self.attr_user_root_dir : self.attr_system_root_dir)
      @prefs_file = JavaFile.new(@dir, "prefs.xml")
      @tmp_file = JavaFile.new(@dir, "prefs.tmp")
    end
    
    typesig { [FileSystemPreferences, String] }
    # Construct a new FileSystemPreferences instance with the specified
    # parent node and name.  This constructor, called from childSpi,
    # is used to make every node except for the two //roots.
    def initialize(parent, name)
      @dir = nil
      @prefs_file = nil
      @tmp_file = nil
      @prefs_cache = nil
      @last_sync_time = 0
      @change_log = nil
      @node_create = nil
      @is_user_node = false
      super(parent, name)
      @prefs_cache = nil
      @last_sync_time = 0
      @change_log = ArrayList.new
      @node_create = nil
      @is_user_node = parent.attr_is_user_node
      @dir = JavaFile.new(parent.attr_dir, dir_name(name))
      @prefs_file = JavaFile.new(@dir, "prefs.xml")
      @tmp_file = JavaFile.new(@dir, "prefs.tmp")
      AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members FileSystemPreferences
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          self.attr_new_node = !self.attr_dir.exists
          return nil
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (self.attr_new_node)
        # These 2 things guarantee node will get wrtten at next flush/sync
        @prefs_cache = TreeMap.new
        @node_create = NodeCreate.new_local(self)
        @change_log.add(@node_create)
      end
    end
    
    typesig { [] }
    def is_user_node
      return @is_user_node
    end
    
    typesig { [String, String] }
    def put_spi(key, value)
      init_cache_if_necessary
      @change_log.add(Put.new_local(self, key, value))
      @prefs_cache.put(key, value)
    end
    
    typesig { [String] }
    def get_spi(key)
      init_cache_if_necessary
      return @prefs_cache.get(key)
    end
    
    typesig { [String] }
    def remove_spi(key)
      init_cache_if_necessary
      @change_log.add(Remove.new_local(self, key))
      @prefs_cache.remove(key)
    end
    
    typesig { [] }
    # Initialize prefsCache if it has yet to be initialized.  When this method
    # returns, prefsCache will be non-null.  If the data was successfully
    # read from the file, lastSyncTime will be updated.  If prefsCache was
    # null, but it was impossible to read the file (because it didn't
    # exist or for any other reason) prefsCache will be initialized to an
    # empty, modifiable Map, and lastSyncTime remain zero.
    def init_cache_if_necessary
      if (!(@prefs_cache).nil?)
        return
      end
      begin
        load_cache
      rescue JavaException => e
        # assert lastSyncTime == 0;
        @prefs_cache = TreeMap.new
      end
    end
    
    typesig { [] }
    # Attempt to load prefsCache from the backing store.  If the attempt
    # succeeds, lastSyncTime will be updated (the new value will typically
    # correspond to the data loaded into the map, but it may be less,
    # if another VM is updating this node concurrently).  If the attempt
    # fails, a BackingStoreException is thrown and both prefsCache and
    # lastSyncTime are unaffected by the call.
    def load_cache
      begin
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            m = self.class::TreeMap.new
            new_last_sync_time = 0
            begin
              new_last_sync_time = self.attr_prefs_file.last_modified
              fis = self.class::FileInputStream.new(self.attr_prefs_file)
              XmlSupport.import_map(fis, m)
              fis.close
            rescue self.class::JavaException => e
              if (e.is_a?(self.class::InvalidPreferencesFormatException))
                get_logger.warning("Invalid preferences format in " + RJava.cast_to_string(self.attr_prefs_file.get_path))
                self.attr_prefs_file.rename_to(self.class::JavaFile.new(self.attr_prefs_file.get_parent_file, "IncorrectFormatPrefs.xml"))
                m = self.class::TreeMap.new
              else
                if (e.is_a?(self.class::FileNotFoundException))
                  get_logger.warning("Prefs file removed in background " + RJava.cast_to_string(self.attr_prefs_file.get_path))
                else
                  raise self.class::BackingStoreException.new(e)
                end
              end
            end
            # Attempt succeeded; update state
            self.attr_prefs_cache = m
            self.attr_last_sync_time = new_last_sync_time
            return nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => e
        raise e.get_exception
      end
    end
    
    typesig { [] }
    # Attempt to write back prefsCache to the backing store.  If the attempt
    # succeeds, lastSyncTime will be updated (the new value will correspond
    # exactly to the data thust written back, as we hold the file lock, which
    # prevents a concurrent write.  If the attempt fails, a
    # BackingStoreException is thrown and both the backing store (prefsFile)
    # and lastSyncTime will be unaffected by this call.  This call will
    # NEVER leave prefsFile in a corrupt state.
    def write_back_cache
      begin
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              if (!self.attr_dir.exists && !self.attr_dir.mkdirs)
                raise self.class::BackingStoreException.new(RJava.cast_to_string(self.attr_dir) + " create failed.")
              end
              fos = self.class::FileOutputStream.new(self.attr_tmp_file)
              XmlSupport.export_map(fos, self.attr_prefs_cache)
              fos.close
              if (!self.attr_tmp_file.rename_to(self.attr_prefs_file))
                raise self.class::BackingStoreException.new("Can't rename " + RJava.cast_to_string(self.attr_tmp_file) + " to " + RJava.cast_to_string(self.attr_prefs_file))
              end
            rescue self.class::JavaException => e
              if (e.is_a?(self.class::BackingStoreException))
                raise e
              end
              raise self.class::BackingStoreException.new(e)
            end
            return nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => e
        raise e.get_exception
      end
    end
    
    typesig { [] }
    def keys_spi
      init_cache_if_necessary
      return @prefs_cache.key_set.to_array(Array.typed(String).new(@prefs_cache.size) { nil })
    end
    
    typesig { [] }
    def children_names_spi
      return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members FileSystemPreferences
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          result = self.class::ArrayList.new
          dir_contents = self.attr_dir.list_files
          if (!(dir_contents).nil?)
            i = 0
            while i < dir_contents.attr_length
              if (dir_contents[i].is_directory)
                result.add(node_name(dir_contents[i].get_name))
              end
              i += 1
            end
          end
          return result.to_array(EMPTY_STRING_ARRAY)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    class_module.module_eval {
      const_set_lazy(:EMPTY_STRING_ARRAY) { Array.typed(String).new(0) { nil } }
      const_attr_reader  :EMPTY_STRING_ARRAY
    }
    
    typesig { [String] }
    def child_spi(name)
      return FileSystemPreferences.new(self, name)
    end
    
    typesig { [] }
    def remove_node
      synchronized((is_user_node ? self.attr_user_lock_file : self.attr_system_lock_file)) do
        # to remove a node we need an exclusive lock
        if (!lock_file(false))
          raise (BackingStoreException.new("Couldn't get file lock."))
        end
        begin
          super
        ensure
          unlock_file
        end
      end
    end
    
    typesig { [] }
    # Called with file lock held (in addition to node locks).
    def remove_node_spi
      begin
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            if (self.attr_change_log.contains(self.attr_node_create))
              self.attr_change_log.remove(self.attr_node_create)
              self.attr_node_create = nil
              return nil
            end
            if (!self.attr_dir.exists)
              return nil
            end
            self.attr_prefs_file.delete
            self.attr_tmp_file.delete
            # dir should be empty now.  If it's not, empty it
            junk = self.attr_dir.list_files
            if (!(junk.attr_length).equal?(0))
              get_logger.warning("Found extraneous files when removing node: " + RJava.cast_to_string(Arrays.as_list(junk)))
              i = 0
              while i < junk.attr_length
                junk[i].delete
                i += 1
              end
            end
            if (!self.attr_dir.delete)
              raise self.class::BackingStoreException.new("Couldn't delete dir: " + RJava.cast_to_string(self.attr_dir))
            end
            return nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => e
        raise e.get_exception
      end
    end
    
    typesig { [] }
    def sync
      synchronized(self) do
        user_node = is_user_node
        shared = false
        if (user_node)
          shared = false
          # use exclusive lock for user prefs
        else
          # if can write to system root, use exclusive lock.
          # otherwise use shared lock.
          shared = !self.attr_is_system_root_writable
        end
        synchronized((is_user_node ? self.attr_user_lock_file : self.attr_system_lock_file)) do
          if (!lock_file(shared))
            raise (BackingStoreException.new("Couldn't get file lock."))
          end
          new_mod_time = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members FileSystemPreferences
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              nmt = 0
              if (is_user_node)
                nmt = self.attr_user_root_mod_file.last_modified
                self.attr_is_user_root_modified = (self.attr_user_root_mod_time).equal?(nmt)
              else
                nmt = self.attr_system_root_mod_file.last_modified
                self.attr_is_system_root_modified = (self.attr_system_root_mod_time).equal?(nmt)
              end
              return self.class::Long.new(nmt)
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          begin
            super
            AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members FileSystemPreferences
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                if (is_user_node)
                  self.attr_user_root_mod_time = new_mod_time.long_value + 1000
                  self.attr_user_root_mod_file.set_last_modified(self.attr_user_root_mod_time)
                else
                  self.attr_system_root_mod_time = new_mod_time.long_value + 1000
                  self.attr_system_root_mod_file.set_last_modified(self.attr_system_root_mod_time)
                end
                return nil
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          ensure
            unlock_file
          end
        end
      end
    end
    
    typesig { [] }
    def sync_spi
      begin
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members FileSystemPreferences
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            sync_spi_privileged
            return nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => e
        raise e.get_exception
      end
    end
    
    typesig { [] }
    def sync_spi_privileged
      if (is_removed)
        raise IllegalStateException.new("Node has been removed")
      end
      if ((@prefs_cache).nil?)
        return
      end # We've never been used, don't bother syncing
      last_modified_time = 0
      if ((is_user_node ? self.attr_is_user_root_modified : self.attr_is_system_root_modified))
        last_modified_time = @prefs_file.last_modified
        if (!(last_modified_time).equal?(@last_sync_time))
          # Prefs at this node were externally modified; read in node and
          # playback any local mods since last sync
          load_cache
          replay_changes
          @last_sync_time = last_modified_time
        end
      else
        if (!(@last_sync_time).equal?(0) && !@dir.exists)
          # This node was removed in the background.  Playback any changes
          # against a virgin (empty) Map.
          @prefs_cache = TreeMap.new
          replay_changes
        end
      end
      if (!@change_log.is_empty)
        write_back_cache # Creates directory & file if necessary
        # Attempt succeeded; it's barely possible that the call to
        # lastModified might fail (i.e., return 0), but this would not
        # be a disaster, as lastSyncTime is allowed to lag.
        last_modified_time = @prefs_file.last_modified
        # If lastSyncTime did not change, or went back
        # increment by 1 second. Since we hold the lock
        # lastSyncTime always monotonically encreases in the
        # atomic sense.
        if (@last_sync_time <= last_modified_time)
          @last_sync_time = last_modified_time + 1000
          @prefs_file.set_last_modified(@last_sync_time)
        end
        @change_log.clear
      end
    end
    
    typesig { [] }
    def flush
      if (is_removed)
        return
      end
      sync
    end
    
    typesig { [] }
    def flush_spi
      # assert false;
    end
    
    class_module.module_eval {
      typesig { [::Java::Char] }
      # Returns true if the specified character is appropriate for use in
      # Unix directory names.  A character is appropriate if it's a printable
      # ASCII character (> 0x1f && < 0x7f) and unequal to slash ('/', 0x2f),
      # dot ('.', 0x2e), or underscore ('_', 0x5f).
      def is_dir_char(ch)
        return ch > 0x1f && ch < 0x7f && !(ch).equal?(Character.new(?/.ord)) && !(ch).equal?(Character.new(?..ord)) && !(ch).equal?(Character.new(?_.ord))
      end
      
      typesig { [String] }
      # Returns the directory name corresponding to the specified node name.
      # Generally, this is just the node name.  If the node name includes
      # inappropriate characters (as per isDirChar) it is translated to Base64.
      # with the underscore  character ('_', 0x5f) prepended.
      def dir_name(node_name)
        i = 0
        n = node_name.length
        while i < n
          if (!is_dir_char(node_name.char_at(i)))
            return "_" + RJava.cast_to_string(Base64.byte_array_to_alt_base64(byte_array(node_name)))
          end
          i += 1
        end
        return node_name
      end
      
      typesig { [String] }
      # Translate a string into a byte array by translating each character
      # into two bytes, high-byte first ("big-endian").
      def byte_array(s)
        len = s.length
        result = Array.typed(::Java::Byte).new(2 * len) { 0 }
        i = 0
        j = 0
        while i < len
          c = s.char_at(i)
          result[((j += 1) - 1)] = (c >> 8)
          result[((j += 1) - 1)] = c
          i += 1
        end
        return result
      end
      
      typesig { [String] }
      # Returns the node name corresponding to the specified directory name.
      # (Inverts the transformation of dirName(String).
      def node_name(dir_name_)
        if (!(dir_name_.char_at(0)).equal?(Character.new(?_.ord)))
          return dir_name_
        end
        a = Base64.alt_base64to_byte_array(dir_name_.substring(1))
        result = StringBuffer.new(a.attr_length / 2)
        i = 0
        while i < a.attr_length
          high_byte = a[((i += 1) - 1)] & 0xff
          low_byte = a[((i += 1) - 1)] & 0xff
          result.append(RJava.cast_to_char(((high_byte << 8) | low_byte)))
        end
        return result.to_s
      end
    }
    
    typesig { [::Java::Boolean] }
    # Try to acquire the appropriate file lock (user or system).  If
    # the initial attempt fails, several more attempts are made using
    # an exponential backoff strategy.  If all attempts fail, this method
    # returns false.
    # @throws SecurityException if file access denied.
    def lock_file(shared)
      usernode = is_user_node
      result = nil
      error_code = 0
      lock_file_ = (usernode ? self.attr_user_lock_file : self.attr_system_lock_file)
      sleep_time = self.attr_init_sleep_time
      i = 0
      while i < self.attr_max_attempts
        begin
          perm = (usernode ? USER_READ_WRITE : USER_RW_ALL_READ)
          result = lock_file0(lock_file_.get_canonical_path, perm, shared)
          error_code = result[ERROR_CODE]
          if (!(result[LOCK_HANDLE]).equal?(0))
            if (usernode)
              self.attr_user_root_lock_handle = result[LOCK_HANDLE]
            else
              self.attr_system_root_lock_handle = result[LOCK_HANDLE]
            end
            return true
          end
        rescue IOException => e
          # // If at first, you don't succeed...
        end
        begin
          JavaThread.sleep(sleep_time)
        rescue InterruptedException => e
          check_lock_file0error_code(error_code)
          return false
        end
        sleep_time *= 2
        i += 1
      end
      check_lock_file0error_code(error_code)
      return false
    end
    
    typesig { [::Java::Int] }
    # Checks if unlockFile0() returned an error. Throws a SecurityException,
    # if access denied. Logs a warning otherwise.
    def check_lock_file0error_code(error_code)
      if ((error_code).equal?(EACCES))
        raise SecurityException.new("Could not lock " + RJava.cast_to_string((is_user_node ? "User prefs." : "System prefs.")) + " Lock file access denied.")
      end
      if (!(error_code).equal?(EAGAIN))
        get_logger.warning("Could not lock " + RJava.cast_to_string((is_user_node ? "User prefs. " : "System prefs.")) + " Unix error code " + RJava.cast_to_string(error_code) + ".")
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_prefs_FileSystemPreferences_lockFile0, [:pointer, :long, :long, :int32, :int8], :long
      typesig { [String, ::Java::Int, ::Java::Boolean] }
      # Locks file using UNIX file locking.
      # @param fileName Absolute file name of the lock file.
      # @return Returns a lock handle, used to unlock the file.
      def lock_file0(file_name, permission, shared)
        JNI.__send__(:Java_java_util_prefs_FileSystemPreferences_lockFile0, JNI.env, self.jni_id, file_name.jni_id, permission.to_int, shared ? 1 : 0)
      end
      
      JNI.native_method :Java_java_util_prefs_FileSystemPreferences_unlockFile0, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      # Unlocks file previously locked by lockFile0().
      # @param lockHandle Handle to the file lock.
      # @return Returns zero if OK, UNIX error code if failure.
      def unlock_file0(lock_handle)
        JNI.__send__(:Java_java_util_prefs_FileSystemPreferences_unlockFile0, JNI.env, self.jni_id, lock_handle.to_int)
      end
      
      JNI.native_method :Java_java_util_prefs_FileSystemPreferences_chmod, [:pointer, :long, :long, :int32], :int32
      typesig { [String, ::Java::Int] }
      # Changes UNIX file permissions.
      def chmod(file_name, permission)
        JNI.__send__(:Java_java_util_prefs_FileSystemPreferences_chmod, JNI.env, self.jni_id, file_name.jni_id, permission.to_int)
      end
      
      # Initial time between lock attempts, in ms.  The time is doubled
      # after each failing attempt (except the first).
      
      def init_sleep_time
        defined?(@@init_sleep_time) ? @@init_sleep_time : @@init_sleep_time= 50
      end
      alias_method :attr_init_sleep_time, :init_sleep_time
      
      def init_sleep_time=(value)
        @@init_sleep_time = value
      end
      alias_method :attr_init_sleep_time=, :init_sleep_time=
      
      # Maximum number of lock attempts.
      
      def max_attempts
        defined?(@@max_attempts) ? @@max_attempts : @@max_attempts= 5
      end
      alias_method :attr_max_attempts, :max_attempts
      
      def max_attempts=(value)
        @@max_attempts = value
      end
      alias_method :attr_max_attempts=, :max_attempts=
    }
    
    typesig { [] }
    # Release the the appropriate file lock (user or system).
    # @throws SecurityException if file access denied.
    def unlock_file
      result = 0
      usernode = is_user_node
      lock_file_ = (usernode ? self.attr_user_lock_file : self.attr_system_lock_file)
      lock_handle = (usernode ? self.attr_user_root_lock_handle : self.attr_system_root_lock_handle)
      if ((lock_handle).equal?(0))
        get_logger.warning("Unlock: zero lockHandle for " + RJava.cast_to_string((usernode ? "user" : "system")) + " preferences.)")
        return
      end
      result = unlock_file0(lock_handle)
      if (!(result).equal?(0))
        get_logger.warning("Could not drop file-lock on " + RJava.cast_to_string((is_user_node ? "user" : "system")) + " preferences." + " Unix error code " + RJava.cast_to_string(result) + ".")
        if ((result).equal?(EACCES))
          raise SecurityException.new("Could not unlock" + RJava.cast_to_string((is_user_node ? "User prefs." : "System prefs.")) + " Lock file access denied.")
        end
      end
      if (is_user_node)
        self.attr_user_root_lock_handle = 0
      else
        self.attr_system_root_lock_handle = 0
      end
    end
    
    private
    alias_method :initialize__file_system_preferences, :initialize
  end
  
end
