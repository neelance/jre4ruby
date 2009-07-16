require "rjava"

# 
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
module Sun::Misc
  module LauncherImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FilePermission
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLClassLoader
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URLStreamHandler
      include_const ::Java::Net, :URLStreamHandlerFactory
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Vector
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PermissionCollection
      include_const ::Java::Security, :Permissions
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :ProtectionDomain
      include_const ::Java::Security, :CodeSource
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Security::Util, :SecurityConstants
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # 
  # This class is used by the system to launch the main application.
  # Launcher
  class Launcher 
    include_class_members LauncherImports
    
    class_module.module_eval {
      
      def factory
        defined?(@@factory) ? @@factory : @@factory= Factory.new
      end
      alias_method :attr_factory, :factory
      
      def factory=(value)
        @@factory = value
      end
      alias_method :attr_factory=, :factory=
      
      
      def launcher
        defined?(@@launcher) ? @@launcher : @@launcher= Launcher.new
      end
      alias_method :attr_launcher, :launcher
      
      def launcher=(value)
        @@launcher = value
      end
      alias_method :attr_launcher=, :launcher=
      
      typesig { [] }
      def get_launcher
        return self.attr_launcher
      end
    }
    
    attr_accessor :loader
    alias_method :attr_loader, :loader
    undef_method :loader
    alias_method :attr_loader=, :loader=
    undef_method :loader=
    
    typesig { [] }
    def initialize
      @loader = nil
      # Create the extension class loader
      extcl = nil
      begin
        extcl = ExtClassLoader.get_ext_class_loader
      rescue IOException => e
        raise InternalError.new("Could not create extension class loader")
      end
      # Now create the class loader to use to launch the application
      begin
        @loader = AppClassLoader.get_app_class_loader(extcl)
      rescue IOException => e
        raise InternalError.new("Could not create application class loader")
      end
      # Also set the context class loader for the primordial thread.
      JavaThread.current_thread.set_context_class_loader(@loader)
      # Finally, install a security manager if requested
      s = System.get_property("java.security.manager")
      if (!(s).nil?)
        sm = nil
        if (("" == s) || ("default" == s))
          sm = Java::Lang::SecurityManager.new
        else
          begin
            sm = @loader.load_class(s).new_instance
          rescue IllegalAccessException => e
          rescue InstantiationException => e
          rescue ClassNotFoundException => e
          rescue ClassCastException => e
          end
        end
        if (!(sm).nil?)
          System.set_security_manager(sm)
        else
          raise InternalError.new("Could not create SecurityManager: " + s)
        end
      end
    end
    
    typesig { [] }
    # 
    # Returns the class loader used to launch the main application.
    def get_class_loader
      return @loader
    end
    
    class_module.module_eval {
      # 
      # The class loader used for loading installed extensions.
      const_set_lazy(:ExtClassLoader) { Class.new(URLClassLoader) do
        include_class_members Launcher
        
        attr_accessor :dirs
        alias_method :attr_dirs, :dirs
        undef_method :dirs
        alias_method :attr_dirs=, :dirs=
        undef_method :dirs=
        
        class_module.module_eval {
          typesig { [] }
          # 
          # create an ExtClassLoader. The ExtClassLoader is created
          # within a context that limits which files it can read
          def get_ext_class_loader
            dirs = get_ext_dirs
            begin
              return AccessController.do_privileged(# Prior implementations of this doPrivileged() block supplied
              # aa synthesized ACC via a call to the private method
              # ExtClassLoader.getContext().
              Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members ExtClassLoader
                include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  len = dirs.attr_length
                  i = 0
                  while i < len
                    MetaIndex.register_directory(dirs[i])
                    ((i += 1) - 1)
                  end
                  return ExtClassLoader.new(dirs)
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            rescue Java::Security::PrivilegedActionException => e
              raise e.get_exception
            end
          end
        }
        
        typesig { [URL] }
        def add_ext_url(url)
          URLClassLoader.instance_method(:add_url).bind(self).call(url)
        end
        
        typesig { [Array.typed(JavaFile)] }
        # 
        # Creates a new ExtClassLoader for the specified directories.
        def initialize(dirs)
          @dirs = nil
          super(get_ext_urls(dirs), nil, self.attr_factory)
          @dirs = dirs
        end
        
        class_module.module_eval {
          typesig { [] }
          def get_ext_dirs
            s = System.get_property("java.ext.dirs")
            dirs = nil
            if (!(s).nil?)
              st = StringTokenizer.new(s, JavaFile.attr_path_separator)
              count = st.count_tokens
              dirs = Array.typed(JavaFile).new(count) { nil }
              i = 0
              while i < count
                dirs[i] = JavaFile.new(st.next_token)
                ((i += 1) - 1)
              end
            else
              dirs = Array.typed(JavaFile).new(0) { nil }
            end
            return dirs
          end
          
          typesig { [Array.typed(JavaFile)] }
          def get_ext_urls(dirs)
            urls = Vector.new
            i = 0
            while i < dirs.attr_length
              files = dirs[i].list
              if (!(files).nil?)
                j = 0
                while j < files.attr_length
                  if (!(files[j] == "meta-index"))
                    f = JavaFile.new(dirs[i], files[j])
                    urls.add(get_file_url(f))
                  end
                  ((j += 1) - 1)
                end
              end
              ((i += 1) - 1)
            end
            ua = Array.typed(URL).new(urls.size) { nil }
            urls.copy_into(ua)
            return ua
          end
        }
        
        typesig { [String] }
        # 
        # Searches the installed extension directories for the specified
        # library name. For each extension directory, we first look for
        # the native library in the subdirectory whose name is the value
        # of the system property <code>os.arch</code>. Failing that, we
        # look in the extension directory itself.
        def find_library(name)
          name = (System.map_library_name(name)).to_s
          i = 0
          while i < @dirs.attr_length
            # Look in architecture-specific subdirectory first
            arch = System.get_property("os.arch")
            if (!(arch).nil?)
              file = JavaFile.new(JavaFile.new(@dirs[i], arch), name)
              if (file.exists)
                return file.get_absolute_path
              end
            end
            # Then check the extension directory
            file_ = JavaFile.new(@dirs[i], name)
            if (file_.exists)
              return file_.get_absolute_path
            end
            ((i += 1) - 1)
          end
          return nil
        end
        
        class_module.module_eval {
          typesig { [Array.typed(JavaFile)] }
          def get_context(dirs)
            perms = PathPermissions.new(dirs)
            domain = ProtectionDomain.new(CodeSource.new(perms.get_code_base, nil), perms)
            acc = AccessControlContext.new(Array.typed(ProtectionDomain).new([domain]))
            return acc
          end
        }
        
        private
        alias_method :initialize__ext_class_loader, :initialize
      end }
      
      # 
      # The class loader used for loading from java.class.path.
      # runs in a restricted security context.
      const_set_lazy(:AppClassLoader) { Class.new(URLClassLoader) do
        include_class_members Launcher
        
        class_module.module_eval {
          typesig { [ClassLoader] }
          def get_app_class_loader(extcl)
            s = System.get_property("java.class.path")
            path = ((s).nil?) ? Array.typed(JavaFile).new(0) { nil } : get_class_path(s)
            return AccessController.do_privileged(# Note: on bugid 4256530
            # Prior implementations of this doPrivileged() block supplied
            # a rather restrictive ACC via a call to the private method
            # AppClassLoader.getContext(). This proved overly restrictive
            # when loading  classes. Specifically it prevent
            # accessClassInPackage.sun.* grants from being honored.
            Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members AppClassLoader
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                urls = ((s).nil?) ? Array.typed(URL).new(0) { nil } : path_to_urls(path)
                return AppClassLoader.new(urls, extcl)
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
        }
        
        typesig { [Array.typed(URL), ClassLoader] }
        # 
        # Creates a new AppClassLoader
        def initialize(urls, parent)
          super(urls, parent, self.attr_factory)
        end
        
        typesig { [String, ::Java::Boolean] }
        # 
        # Override loadClass so we can checkPackageAccess.
        def load_class(name, resolve)
          synchronized(self) do
            i = name.last_index_of(Character.new(?..ord))
            if (!(i).equal?(-1))
              sm = System.get_security_manager
              if (!(sm).nil?)
                sm.check_package_access(name.substring(0, i))
              end
            end
            return (super(name, resolve))
          end
        end
        
        typesig { [CodeSource] }
        # 
        # allow any classes loaded from classpath to exit the VM.
        def get_permissions(codesource)
          perms = super(codesource)
          perms.add(RuntimePermission.new("exitVM"))
          return perms
        end
        
        typesig { [String] }
        # 
        # This class loader supports dynamic additions to the class path
        # at runtime.
        # 
        # @see java.lang.instrument.Instrumentation#appendToSystemClassPathSearch
        def append_to_class_path_for_instrumentation(path)
          raise AssertError if not ((JavaThread.holds_lock(self)))
          # addURL is a no-op if path already contains the URL
          URLClassLoader.instance_method(:add_url).bind(self).call(get_file_url(JavaFile.new(path)))
        end
        
        class_module.module_eval {
          typesig { [Array.typed(JavaFile)] }
          # 
          # create a context that can read any directories (recursively)
          # mentioned in the class path. In the case of a jar, it has to
          # be the directory containing the jar, not just the jar, as jar
          # files might refer to other jar files.
          def get_context(cp)
            perms = PathPermissions.new(cp)
            domain = ProtectionDomain.new(CodeSource.new(perms.get_code_base, nil), perms)
            acc = AccessControlContext.new(Array.typed(ProtectionDomain).new([domain]))
            return acc
          end
        }
        
        private
        alias_method :initialize__app_class_loader, :initialize
      end }
      
      typesig { [] }
      def get_bootstrap_class_path
        prop = AccessController.do_privileged(GetPropertyAction.new("sun.boot.class.path"))
        urls = nil
        if (!(prop).nil?)
          path = prop
          urls = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members Launcher
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              class_path = get_class_path(path)
              len = class_path.attr_length
              seen_dirs = HashSet.new
              i = 0
              while i < len
                cur_entry = class_path[i]
                # Negative test used to properly handle
                # nonexistent jars on boot class path
                if (!cur_entry.is_directory)
                  cur_entry = cur_entry.get_parent_file
                end
                if (!(cur_entry).nil? && seen_dirs.add(cur_entry))
                  MetaIndex.register_directory(cur_entry)
                end
                ((i += 1) - 1)
              end
              return path_to_urls(class_path)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        else
          urls = Array.typed(URL).new(0) { nil }
        end
        return URLClassPath.new(urls, self.attr_factory)
      end
      
      typesig { [Array.typed(JavaFile)] }
      def path_to_urls(path)
        urls = Array.typed(URL).new(path.attr_length) { nil }
        i = 0
        while i < path.attr_length
          urls[i] = get_file_url(path[i])
          ((i += 1) - 1)
        end
        # DEBUG
        # for (int i = 0; i < urls.length; i++) {
        # System.out.println("urls[" + i + "] = " + '"' + urls[i] + '"');
        # }
        return urls
      end
      
      typesig { [String] }
      def get_class_path(cp)
        path = nil
        if (!(cp).nil?)
          count = 0
          max_count = 1
          pos = 0
          last_pos = 0
          # Count the number of separators first
          while (!((pos = cp.index_of(JavaFile.attr_path_separator, last_pos))).equal?(-1))
            ((max_count += 1) - 1)
            last_pos = pos + 1
          end
          path = Array.typed(JavaFile).new(max_count) { nil }
          last_pos = pos = 0
          # Now scan for each path component
          while (!((pos = cp.index_of(JavaFile.attr_path_separator, last_pos))).equal?(-1))
            if (pos - last_pos > 0)
              path[((count += 1) - 1)] = JavaFile.new(cp.substring(last_pos, pos))
            else
              # empty path component translates to "."
              path[((count += 1) - 1)] = JavaFile.new(".")
            end
            last_pos = pos + 1
          end
          # Make sure we include the last path component
          if (last_pos < cp.length)
            path[((count += 1) - 1)] = JavaFile.new(cp.substring(last_pos))
          else
            path[((count += 1) - 1)] = JavaFile.new(".")
          end
          # Trim array to correct size
          if (!(count).equal?(max_count))
            tmp = Array.typed(JavaFile).new(count) { nil }
            System.arraycopy(path, 0, tmp, 0, count)
            path = tmp
          end
        else
          path = Array.typed(JavaFile).new(0) { nil }
        end
        # DEBUG
        # for (int i = 0; i < path.length; i++) {
        # System.out.println("path[" + i + "] = " + '"' + path[i] + '"');
        # }
        return path
      end
      
      
      def file_handler
        defined?(@@file_handler) ? @@file_handler : @@file_handler= nil
      end
      alias_method :attr_file_handler, :file_handler
      
      def file_handler=(value)
        @@file_handler = value
      end
      alias_method :attr_file_handler=, :file_handler=
      
      typesig { [JavaFile] }
      def get_file_url(file)
        begin
          file = file.get_canonical_file
        rescue IOException => e
        end
        begin
          return ParseUtil.file_to_encoded_url(file)
        rescue MalformedURLException => e
          # Should never happen since we specify the protocol...
          raise InternalError.new
        end
      end
      
      # 
      # The stream handler factory for loading system protocol handlers.
      const_set_lazy(:Factory) { Class.new do
        include_class_members Launcher
        include URLStreamHandlerFactory
        
        class_module.module_eval {
          
          def prefix
            defined?(@@prefix) ? @@prefix : @@prefix= "sun.net.www.protocol"
          end
          alias_method :attr_prefix, :prefix
          
          def prefix=(value)
            @@prefix = value
          end
          alias_method :attr_prefix=, :prefix=
        }
        
        typesig { [String] }
        def create_urlstream_handler(protocol)
          name = self.attr_prefix + "." + protocol + ".Handler"
          begin
            c = Class.for_name(name)
            return c.new_instance
          rescue ClassNotFoundException => e
            e.print_stack_trace
          rescue InstantiationException => e
            e_.print_stack_trace
          rescue IllegalAccessException => e
            e__.print_stack_trace
          end
          raise InternalError.new("could not load " + protocol + "system protocol handler")
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__factory, :initialize
      end }
    }
    
    private
    alias_method :initialize__launcher, :initialize
  end
  
  class PathPermissions < LauncherImports.const_get :PermissionCollection
    include_class_members LauncherImports
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.2.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 8133287259134945693 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    attr_accessor :perms
    alias_method :attr_perms, :perms
    undef_method :perms
    alias_method :attr_perms=, :perms=
    undef_method :perms=
    
    attr_accessor :code_base
    alias_method :attr_code_base, :code_base
    undef_method :code_base
    alias_method :attr_code_base=, :code_base=
    undef_method :code_base=
    
    typesig { [Array.typed(JavaFile)] }
    def initialize(path)
      @path = nil
      @perms = nil
      @code_base = nil
      super()
      @path = path
      @perms = nil
      @code_base = nil
    end
    
    typesig { [] }
    def get_code_base
      return @code_base
    end
    
    typesig { [Java::Security::Permission] }
    def add(permission)
      raise SecurityException.new("attempt to add a permission")
    end
    
    typesig { [] }
    def init
      synchronized(self) do
        if (!(@perms).nil?)
          return
        end
        @perms = Permissions.new
        # this is needed to be able to create the classloader itself!
        @perms.add(SecurityConstants::CREATE_CLASSLOADER_PERMISSION)
        # add permission to read any "java.*" property
        @perms.add(Java::Util::PropertyPermission.new("java.*", SecurityConstants::PROPERTY_READ_ACTION))
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members PathPermissions
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            i = 0
            while i < self.attr_path.attr_length
              f = self.attr_path[i]
              path = nil
              begin
                path = (f.get_canonical_path).to_s
              rescue IOException => ioe
                path = (f.get_absolute_path).to_s
              end
              if ((i).equal?(0))
                self.attr_code_base = Launcher.get_file_url(JavaFile.new(path))
              end
              if (f.is_directory)
                if (path.ends_with(JavaFile.attr_separator))
                  self.attr_perms.add(FilePermission.new(path + "-", SecurityConstants::FILE_READ_ACTION))
                else
                  self.attr_perms.add(FilePermission.new(path + (JavaFile.attr_separator).to_s + "-", SecurityConstants::FILE_READ_ACTION))
                end
              else
                end_index = path.last_index_of(JavaFile.attr_separator_char)
                if (!(end_index).equal?(-1))
                  path = (path.substring(0, end_index + 1)).to_s + "-"
                  self.attr_perms.add(FilePermission.new(path, SecurityConstants::FILE_READ_ACTION))
                else
                  # XXX?
                end
              end
              ((i += 1) - 1)
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [Java::Security::Permission] }
    def implies(permission)
      if ((@perms).nil?)
        init
      end
      return @perms.implies(permission)
    end
    
    typesig { [] }
    def elements
      if ((@perms).nil?)
        init
      end
      synchronized((@perms)) do
        return @perms.elements
      end
    end
    
    typesig { [] }
    def to_s
      if ((@perms).nil?)
        init
      end
      return @perms.to_s
    end
    
    private
    alias_method :initialize__path_permissions, :initialize
  end
  
end
