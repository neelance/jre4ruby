require "rjava"

# Copyright 1999-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ExtensionDependencyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FilenameFilter
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util::Jar, :JarFile
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Util::Jar, :Attributes
      include_const ::Java::Util::Jar::Attributes, :Name
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :MalformedURLException
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # <p>
  # This class checks dependent extensions a particular jar file may have
  # declared through its manifest attributes.
  # </p>
  # Jar file declared dependent extensions through the extension-list
  # attribute. The extension-list contains a list of keys used to
  # fetch the other attributes describing the required extension.
  # If key is the extension key declared in the extension-list
  # attribute, the following describing attribute can be found in
  # the manifest :
  # key-Extension-Name:  (Specification package name)
  # key-Specification-Version: (Specification-Version)
  # key-Implementation-Version: (Implementation-Version)
  # key-Implementation-Vendor-Id: (Imlementation-Vendor-Id)
  # key-Implementation-Version: (Implementation version)
  # key-Implementation-URL: (URL to download the requested extension)
  # <p>
  # This class also maintain versioning consistency of installed
  # extensions dependencies declared in jar file manifest.
  # </p>
  # @author  Jerome Dochez
  class ExtensionDependency 
    include_class_members ExtensionDependencyImports
    
    class_module.module_eval {
      # Callbak interfaces to delegate installation of missing extensions
      
      def providers
        defined?(@@providers) ? @@providers : @@providers= nil
      end
      alias_method :attr_providers, :providers
      
      def providers=(value)
        @@providers = value
      end
      alias_method :attr_providers=, :providers=
      
      typesig { [ExtensionInstallationProvider] }
      # <p>
      # Register an ExtensionInstallationProvider. The provider is responsible
      # for handling the installation (upgrade) of any missing extensions.
      # </p>
      # @param eip ExtensionInstallationProvider implementation
      def add_extension_installation_provider(eip)
        synchronized(self) do
          if ((self.attr_providers).nil?)
            self.attr_providers = Vector.new
          end
          self.attr_providers.add(eip)
        end
      end
      
      typesig { [ExtensionInstallationProvider] }
      # <p>
      # Unregister a previously installed installation provider
      # </p>
      def remove_extension_installation_provider(eip)
        synchronized(self) do
          self.attr_providers.remove(eip)
        end
      end
      
      typesig { [JarFile] }
      # <p>
      # Checks the dependencies of the jar file on installed extension.
      # </p>
      # @param jarFile containing the attriutes declaring the dependencies
      def check_extensions_dependencies(jar)
        if ((self.attr_providers).nil?)
          # no need to bother, nobody is registered to install missing
          # extensions
          return true
        end
        begin
          ext_dep = ExtensionDependency.new
          return ext_dep.check_extensions(jar)
        rescue ExtensionInstallationException => e
          debug(e.get_message)
        end
        return false
      end
    }
    
    typesig { [JarFile] }
    # Check for all declared required extensions in the jar file
    # manifest.
    def check_extensions(jar)
      man = nil
      begin
        man = jar.get_manifest
      rescue IOException => e
        return false
      end
      if ((man).nil?)
        # The applet does not define a manifest file, so
        # we just assume all dependencies are satisfied.
        return true
      end
      result = true
      attr = man.get_main_attributes
      if (!(attr).nil?)
        # Let's get the list of declared dependencies
        value = attr.get_value(Name::EXTENSION_LIST)
        if (!(value).nil?)
          st = StringTokenizer.new(value)
          # Iterate over all declared dependencies
          while (st.has_more_tokens)
            extension_name = st.next_token
            debug("The file " + RJava.cast_to_string(jar.get_name) + " appears to depend on " + extension_name)
            # Sanity Check
            ext_name = extension_name + "-" + RJava.cast_to_string(Name::EXTENSION_NAME.to_s)
            if ((attr.get_value(ext_name)).nil?)
              debug("The jar file " + RJava.cast_to_string(jar.get_name) + " appers to depend on " + extension_name + " but does not define the " + ext_name + " attribute in its manifest ")
            else
              if (!check_extension(extension_name, attr))
                debug("Failed installing " + extension_name)
                result = false
              end
            end
          end
        else
          debug("No dependencies for " + RJava.cast_to_string(jar.get_name))
        end
      end
      return result
    end
    
    typesig { [String, Attributes] }
    # <p>
    # Check that a particular dependency on an extension is satisfied.
    # </p>
    # @param extensionName is the key used for the attributes in the manifest
    # @param attr is the attributes of the manifest file
    # 
    # @return true if the dependency is satisfied by the installed extensions
    def check_extension(extension_name, attr)
      synchronized(self) do
        debug("Checking extension " + extension_name)
        if (check_extension_against_installed(extension_name, attr))
          return true
        end
        debug("Extension not currently installed ")
        req_info = ExtensionInfo.new(extension_name, attr)
        return install_extension(req_info, nil)
      end
    end
    
    typesig { [String, Attributes] }
    # <p>
    # Check if a particular extension is part of the currently installed
    # extensions.
    # </p>
    # @param extensionName is the key for the attributes in the manifest
    # @param attr is the attributes of the manifest
    # 
    # @return true if the requested extension is already installed
    def check_extension_against_installed(extension_name, attr)
      f_extension = check_extension_exists(extension_name)
      if (!(f_extension).nil?)
        # Extension already installed, just check against this one
        begin
          if (check_extension_against(extension_name, attr, f_extension))
            return true
          end
        rescue FileNotFoundException => e
          debug_exception(e)
        rescue IOException => e
          debug_exception(e)
        end
        return false
      else
        # Not sure if extension is already installed, so check all the
        # installed extension jar files to see if we get a match
        installed_exts = nil
        begin
          # Get the list of installed extension jar files so we can
          # compare the installed versus the requested extension
          installed_exts = get_installed_extensions
        rescue IOException => e
          debug_exception(e)
          return false
        end
        i = 0
        while i < installed_exts.attr_length
          begin
            if (check_extension_against(extension_name, attr, installed_exts[i]))
              return true
            end
          rescue FileNotFoundException => e
            debug_exception(e)
          rescue IOException => e
            debug_exception(e)
            # let's continue with the next installed extension
          end
          i += 1
        end
      end
      return false
    end
    
    typesig { [String, Attributes, JavaFile] }
    # <p>
    # Check if the requested extension described by the attributes
    # in the manifest under the key extensionName is compatible with
    # the jar file.
    # </p>
    # 
    # @param extensionName key in the attibute list
    # @param attr manifest file attributes
    # @param file installed extension jar file to compare the requested
    # extension against.
    def check_extension_against(extension_name, attr, file)
      debug("Checking extension " + extension_name + " against " + RJava.cast_to_string(file.get_name))
      # Load the jar file ...
      man = nil
      begin
        man = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members ExtensionDependency
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            if (!file.exists)
              raise self.class::FileNotFoundException.new(file.get_name)
            end
            jar_file = self.class::JarFile.new(file)
            return jar_file.get_manifest
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => e
        if (e.get_exception.is_a?(FileNotFoundException))
          raise e.get_exception
        end
        raise e.get_exception
      end
      # Construct the extension information object
      req_info = ExtensionInfo.new(extension_name, attr)
      debug("Requested Extension : " + RJava.cast_to_string(req_info))
      is_compatible = ExtensionInfo::INCOMPATIBLE
      inst_info = nil
      if (!(man).nil?)
        inst_attr = man.get_main_attributes
        if (!(inst_attr).nil?)
          inst_info = ExtensionInfo.new(nil, inst_attr)
          debug("Extension Installed " + RJava.cast_to_string(inst_info))
          is_compatible = inst_info.is_compatible_with(req_info)
          case (is_compatible)
          when ExtensionInfo::COMPATIBLE
            debug("Extensions are compatible")
            return true
          when ExtensionInfo::INCOMPATIBLE
            debug("Extensions are incompatible")
            return false
          else
            # everything else
            debug("Extensions require an upgrade or vendor switch")
            return install_extension(req_info, inst_info)
          end
        end
      end
      return false
    end
    
    typesig { [ExtensionInfo, ExtensionInfo] }
    # <p>
    # An required extension is missing, if an ExtensionInstallationProvider is
    # registered, delegate the installation of that particular extension to it.
    # </p>
    # 
    # @param reqInfo Missing extension information
    # @param instInfo Older installed version information
    # 
    # @return true if the installation is successful
    def install_extension(req_info, inst_info)
      current_providers = nil
      synchronized((self.attr_providers)) do
        current_providers = self.attr_providers.clone
      end
      e = current_providers.elements
      while e.has_more_elements
        eip = e.next_element
        if (!(eip).nil?)
          # delegate the installation to the provider
          if (eip.install_extension(req_info, inst_info))
            debug(RJava.cast_to_string(req_info.attr_name) + " installation successful")
            cl = Launcher.get_launcher.get_class_loader.get_parent
            add_new_extensions_to_class_loader(cl)
            return true
          end
        end
      end
      # We have tried all of our providers, noone could install this
      # extension, we just return failure at this point
      debug(RJava.cast_to_string(req_info.attr_name) + " installation failed")
      return false
    end
    
    typesig { [String] }
    # <p>
    # Checks if the extension, that is specified in the extension-list in
    # the applet jar manifest, is already installed (i.e. exists in the
    # extension directory).
    # </p>
    # 
    # @param extensionName extension name in the extension-list
    # 
    # @return the extension if it exists in the extension directory
    def check_extension_exists(extension_name)
      # Function added to fix bug 4504166
      ext_name = extension_name
      file_ext = Array.typed(String).new([".jar", ".zip"])
      return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members ExtensionDependency
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          begin
            f_extension = nil
            dirs = get_ext_dirs
            # Search the extension directories for the extension that is specified
            # in the attribute extension-list in the applet jar manifest
            i = 0
            while i < dirs.attr_length
              j = 0
              while j < file_ext.attr_length
                if (ext_name.to_lower_case.ends_with(file_ext[j]))
                  f_extension = self.class::JavaFile.new(dirs[i], ext_name)
                else
                  f_extension = self.class::JavaFile.new(dirs[i], ext_name + RJava.cast_to_string(file_ext[j]))
                end
                debug("checkExtensionExists:fileName " + RJava.cast_to_string(f_extension.get_name))
                if (f_extension.exists)
                  return f_extension
                end
                j += 1
              end
              i += 1
            end
            return nil
          rescue self.class::JavaException => e
            debug_exception(e)
            return nil
          end
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
      typesig { [] }
      # <p>
      # @return the java.ext.dirs property as a list of directory
      # </p>
      def get_ext_dirs
        s = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.ext.dirs"))
        dirs = nil
        if (!(s).nil?)
          st = StringTokenizer.new(s, JavaFile.attr_path_separator)
          count = st.count_tokens
          debug("getExtDirs count " + RJava.cast_to_string(count))
          dirs = Array.typed(JavaFile).new(count) { nil }
          i = 0
          while i < count
            dirs[i] = JavaFile.new(st.next_token)
            debug("getExtDirs dirs[" + RJava.cast_to_string(i) + "] " + RJava.cast_to_string(dirs[i]))
            i += 1
          end
        else
          dirs = Array.typed(JavaFile).new(0) { nil }
          debug("getExtDirs dirs " + RJava.cast_to_string(dirs))
        end
        debug("getExtDirs dirs.length " + RJava.cast_to_string(dirs.attr_length))
        return dirs
      end
      
      typesig { [Array.typed(JavaFile)] }
      # <p>
      # Scan the directories and return all files installed in those
      # </p>
      # @param dirs list of directories to scan
      # 
      # @return the list of files installed in all the directories
      def get_ext_files(dirs)
        urls = Vector.new
        i = 0
        while i < dirs.attr_length
          files = dirs[i].list(JarFilter.new)
          if (!(files).nil?)
            debug("getExtFiles files.length " + RJava.cast_to_string(files.attr_length))
            j = 0
            while j < files.attr_length
              f = JavaFile.new(dirs[i], files[j])
              urls.add(f)
              debug("getExtFiles f[" + RJava.cast_to_string(j) + "] " + RJava.cast_to_string(f))
              j += 1
            end
          end
          i += 1
        end
        ua = Array.typed(JavaFile).new(urls.size) { nil }
        urls.copy_into(ua)
        debug("getExtFiles ua.length " + RJava.cast_to_string(ua.attr_length))
        return ua
      end
    }
    
    typesig { [] }
    # <p>
    # @return the list of installed extensions jar files
    # </p>
    def get_installed_extensions
      return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members ExtensionDependency
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          begin
            return get_ext_files(get_ext_dirs)
          rescue self.class::IOException => e
            debug("Cannot get list of installed extensions")
            debug_exception(e)
            return Array.typed(self.class::URL).new(0) { nil }
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Launcher::ExtClassLoader] }
    # <p>
    # Add the newly installed jar file to the extension class loader.
    # </p>
    # 
    # @param cl the current installed extension class loader
    # 
    # @return true if successful
    def add_new_extensions_to_class_loader(cl)
      begin
        installed_exts = get_installed_extensions
        i = 0
        while i < installed_exts.attr_length
          inst_file = installed_exts[i]
          inst_url = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members ExtensionDependency
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                return ParseUtil.file_to_encoded_url(inst_file)
              rescue self.class::MalformedURLException => e
                debug_exception(e)
                return nil
              end
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          if (!(inst_url).nil?)
            urls = cl.get_urls
            found = false
            j = 0
            while j < urls.attr_length
              debug("URL[" + RJava.cast_to_string(j) + "] is " + RJava.cast_to_string(urls[j]) + " looking for " + RJava.cast_to_string(inst_url))
              if ((urls[j].to_s.compare_to_ignore_case(inst_url.to_s)).equal?(0))
                found = true
                debug("Found !")
              end
              j += 1
            end
            if (!found)
              debug("Not Found ! adding to the classloader " + RJava.cast_to_string(inst_url))
              cl.add_ext_url(inst_url)
            end
          end
          i += 1
        end
      rescue MalformedURLException => e
        e.print_stack_trace
      rescue IOException => e
        e.print_stack_trace
        # let's continue with the next installed extension
      end
      return Boolean::TRUE
    end
    
    class_module.module_eval {
      # True to display all debug and trace messages
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      typesig { [String] }
      def debug(s)
        if (DEBUG)
          System.err.println(s)
        end
      end
    }
    
    typesig { [JavaThrowable] }
    def debug_exception(e)
      if (DEBUG)
        e.print_stack_trace
      end
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__extension_dependency, :initialize
  end
  
end
