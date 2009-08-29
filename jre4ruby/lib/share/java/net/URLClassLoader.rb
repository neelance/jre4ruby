require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module URLClassLoaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FilePermission
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :URLStreamHandlerFactory
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Util::Jar, :Attributes
      include_const ::Java::Util::Jar::Attributes, :Name
      include_const ::Java::Security, :CodeSigner
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :SecureClassLoader
      include_const ::Java::Security, :CodeSource
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :PermissionCollection
      include_const ::Sun::Misc, :Resource
      include_const ::Sun::Misc, :URLClassPath
      include_const ::Sun::Net::Www, :ParseUtil
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # This class loader is used to load classes and resources from a search
  # path of URLs referring to both JAR files and directories. Any URL that
  # ends with a '/' is assumed to refer to a directory. Otherwise, the URL
  # is assumed to refer to a JAR file which will be opened as needed.
  # <p>
  # The AccessControlContext of the thread that created the instance of
  # URLClassLoader will be used when subsequently loading classes and
  # resources.
  # <p>
  # The classes that are loaded are by default granted permission only to
  # access the URLs specified when the URLClassLoader was created.
  # 
  # @author  David Connelly
  # @since   1.2
  class URLClassLoader < URLClassLoaderImports.const_get :SecureClassLoader
    include_class_members URLClassLoaderImports
    
    # The search path for classes and resources
    attr_accessor :ucp
    alias_method :attr_ucp, :ucp
    undef_method :ucp
    alias_method :attr_ucp=, :ucp=
    undef_method :ucp=
    
    # The context to be used when loading classes and resources
    attr_accessor :acc
    alias_method :attr_acc, :acc
    undef_method :acc
    alias_method :attr_acc=, :acc=
    undef_method :acc=
    
    typesig { [Array.typed(URL), ClassLoader] }
    # Constructs a new URLClassLoader for the given URLs. The URLs will be
    # searched in the order specified for classes and resources after first
    # searching in the specified parent class loader. Any URL that ends with
    # a '/' is assumed to refer to a directory. Otherwise, the URL is assumed
    # to refer to a JAR file which will be downloaded and opened as needed.
    # 
    # <p>If there is a security manager, this method first
    # calls the security manager's <code>checkCreateClassLoader</code> method
    # to ensure creation of a class loader is allowed.
    # 
    # @param urls the URLs from which to load classes and resources
    # @param parent the parent class loader for delegation
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkCreateClassLoader</code> method doesn't allow
    # creation of a class loader.
    # @see SecurityManager#checkCreateClassLoader
    def initialize(urls, parent)
      @ucp = nil
      @acc = nil
      super(parent)
      # this is to make the stack depth consistent with 1.1
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_create_class_loader
      end
      @ucp = URLClassPath.new(urls)
      @acc = AccessController.get_context
    end
    
    typesig { [Array.typed(URL)] }
    # Constructs a new URLClassLoader for the specified URLs using the
    # default delegation parent <code>ClassLoader</code>. The URLs will
    # be searched in the order specified for classes and resources after
    # first searching in the parent class loader. Any URL that ends with
    # a '/' is assumed to refer to a directory. Otherwise, the URL is
    # assumed to refer to a JAR file which will be downloaded and opened
    # as needed.
    # 
    # <p>If there is a security manager, this method first
    # calls the security manager's <code>checkCreateClassLoader</code> method
    # to ensure creation of a class loader is allowed.
    # 
    # @param urls the URLs from which to load classes and resources
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkCreateClassLoader</code> method doesn't allow
    # creation of a class loader.
    # @see SecurityManager#checkCreateClassLoader
    def initialize(urls)
      @ucp = nil
      @acc = nil
      super()
      # this is to make the stack depth consistent with 1.1
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_create_class_loader
      end
      @ucp = URLClassPath.new(urls)
      @acc = AccessController.get_context
    end
    
    typesig { [Array.typed(URL), ClassLoader, URLStreamHandlerFactory] }
    # Constructs a new URLClassLoader for the specified URLs, parent
    # class loader, and URLStreamHandlerFactory. The parent argument
    # will be used as the parent class loader for delegation. The
    # factory argument will be used as the stream handler factory to
    # obtain protocol handlers when creating new jar URLs.
    # 
    # <p>If there is a security manager, this method first
    # calls the security manager's <code>checkCreateClassLoader</code> method
    # to ensure creation of a class loader is allowed.
    # 
    # @param urls the URLs from which to load classes and resources
    # @param parent the parent class loader for delegation
    # @param factory the URLStreamHandlerFactory to use when creating URLs
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkCreateClassLoader</code> method doesn't allow
    # creation of a class loader.
    # @see SecurityManager#checkCreateClassLoader
    def initialize(urls, parent, factory)
      @ucp = nil
      @acc = nil
      super(parent)
      # this is to make the stack depth consistent with 1.1
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_create_class_loader
      end
      @ucp = URLClassPath.new(urls, factory)
      @acc = AccessController.get_context
    end
    
    typesig { [URL] }
    # Appends the specified URL to the list of URLs to search for
    # classes and resources.
    # 
    # @param url the URL to be added to the search path of URLs
    def add_url(url)
      @ucp.add_url(url)
    end
    
    typesig { [] }
    # Returns the search path of URLs for loading classes and resources.
    # This includes the original list of URLs specified to the constructor,
    # along with any URLs subsequently appended by the addURL() method.
    # @return the search path of URLs for loading classes and resources.
    def get_urls
      return @ucp.get_urls
    end
    
    typesig { [String] }
    # Finds and loads the class with the specified name from the URL search
    # path. Any URLs referring to JAR files are loaded and opened as needed
    # until the class is found.
    # 
    # @param name the name of the class
    # @return the resulting class
    # @exception ClassNotFoundException if the class could not be found
    def find_class(name)
      begin
        return AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members URLClassLoader
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            path = name.replace(Character.new(?..ord), Character.new(?/.ord)).concat(".class")
            res = self.attr_ucp.get_resource(path, false)
            if (!(res).nil?)
              begin
                return define_class(name, res)
              rescue self.class::IOException => e
                raise self.class::ClassNotFoundException.new(name, e)
              end
            else
              raise self.class::ClassNotFoundException.new(name)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self), @acc)
      rescue Java::Security::PrivilegedActionException => pae
        raise pae.get_exception
      end
    end
    
    typesig { [String, Resource] }
    # Defines a Class using the class bytes obtained from the specified
    # Resource. The resulting Class must be resolved before it can be
    # used.
    def define_class(name, res)
      i = name.last_index_of(Character.new(?..ord))
      url = res.get_code_source_url
      if (!(i).equal?(-1))
        pkgname = name.substring(0, i)
        # Check if package already loaded.
        pkg = get_package(pkgname)
        man = res.get_manifest
        if (!(pkg).nil?)
          # Package found, so check package sealing.
          if (pkg.is_sealed)
            # Verify that code source URL is the same.
            if (!pkg.is_sealed(url))
              raise SecurityException.new("sealing violation: package " + pkgname + " is sealed")
            end
          else
            # Make sure we are not attempting to seal the package
            # at this code source URL.
            if ((!(man).nil?) && is_sealed(pkgname, man))
              raise SecurityException.new("sealing violation: can't seal package " + pkgname + ": already loaded")
            end
          end
        else
          if (!(man).nil?)
            define_package(pkgname, man, url)
          else
            define_package(pkgname, nil, nil, nil, nil, nil, nil, nil)
          end
        end
      end
      # Now read the class bytes and define the class
      bb = res.get_byte_buffer
      if (!(bb).nil?)
        # Use (direct) ByteBuffer:
        signers = res.get_code_signers
        cs = CodeSource.new(url, signers)
        return define_class(name, bb, cs)
      else
        b = res.get_bytes
        # must read certificates AFTER reading bytes.
        signers = res.get_code_signers
        cs = CodeSource.new(url, signers)
        return define_class(name, b, 0, b.attr_length, cs)
      end
    end
    
    typesig { [String, Manifest, URL] }
    # Defines a new package by name in this ClassLoader. The attributes
    # contained in the specified Manifest will be used to obtain package
    # version and sealing information. For sealed packages, the additional
    # URL specifies the code source URL from which the package was loaded.
    # 
    # @param name  the package name
    # @param man   the Manifest containing package version and sealing
    # information
    # @param url   the code source url for the package, or null if none
    # @exception   IllegalArgumentException if the package name duplicates
    # an existing package either in this class loader or one
    # of its ancestors
    # @return the newly defined Package object
    def define_package(name, man, url)
      path = name.replace(Character.new(?..ord), Character.new(?/.ord)).concat("/")
      spec_title = nil
      spec_version = nil
      spec_vendor = nil
      impl_title = nil
      impl_version = nil
      impl_vendor = nil
      sealed = nil
      seal_base = nil
      attr = man.get_attributes(path)
      if (!(attr).nil?)
        spec_title = RJava.cast_to_string(attr.get_value(Name::SPECIFICATION_TITLE))
        spec_version = RJava.cast_to_string(attr.get_value(Name::SPECIFICATION_VERSION))
        spec_vendor = RJava.cast_to_string(attr.get_value(Name::SPECIFICATION_VENDOR))
        impl_title = RJava.cast_to_string(attr.get_value(Name::IMPLEMENTATION_TITLE))
        impl_version = RJava.cast_to_string(attr.get_value(Name::IMPLEMENTATION_VERSION))
        impl_vendor = RJava.cast_to_string(attr.get_value(Name::IMPLEMENTATION_VENDOR))
        sealed = RJava.cast_to_string(attr.get_value(Name::SEALED))
      end
      attr = man.get_main_attributes
      if (!(attr).nil?)
        if ((spec_title).nil?)
          spec_title = RJava.cast_to_string(attr.get_value(Name::SPECIFICATION_TITLE))
        end
        if ((spec_version).nil?)
          spec_version = RJava.cast_to_string(attr.get_value(Name::SPECIFICATION_VERSION))
        end
        if ((spec_vendor).nil?)
          spec_vendor = RJava.cast_to_string(attr.get_value(Name::SPECIFICATION_VENDOR))
        end
        if ((impl_title).nil?)
          impl_title = RJava.cast_to_string(attr.get_value(Name::IMPLEMENTATION_TITLE))
        end
        if ((impl_version).nil?)
          impl_version = RJava.cast_to_string(attr.get_value(Name::IMPLEMENTATION_VERSION))
        end
        if ((impl_vendor).nil?)
          impl_vendor = RJava.cast_to_string(attr.get_value(Name::IMPLEMENTATION_VENDOR))
        end
        if ((sealed).nil?)
          sealed = RJava.cast_to_string(attr.get_value(Name::SEALED))
        end
      end
      if ("true".equals_ignore_case(sealed))
        seal_base = url
      end
      return define_package(name, spec_title, spec_version, spec_vendor, impl_title, impl_version, impl_vendor, seal_base)
    end
    
    typesig { [String, Manifest] }
    # Returns true if the specified package name is sealed according to the
    # given manifest.
    def is_sealed(name, man)
      path = name.replace(Character.new(?..ord), Character.new(?/.ord)).concat("/")
      attr = man.get_attributes(path)
      sealed = nil
      if (!(attr).nil?)
        sealed = RJava.cast_to_string(attr.get_value(Name::SEALED))
      end
      if ((sealed).nil?)
        if (!((attr = man.get_main_attributes)).nil?)
          sealed = RJava.cast_to_string(attr.get_value(Name::SEALED))
        end
      end
      return "true".equals_ignore_case(sealed)
    end
    
    typesig { [String] }
    # Finds the resource with the specified name on the URL search path.
    # 
    # @param name the name of the resource
    # @return a <code>URL</code> for the resource, or <code>null</code>
    # if the resource could not be found.
    def find_resource(name)
      url = AccessController.do_privileged(# The same restriction to finding classes applies to resources
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members URLClassLoader
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return self.attr_ucp.find_resource(name, true)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self), @acc)
      return !(url).nil? ? @ucp.check_url(url) : nil
    end
    
    typesig { [String] }
    # Returns an Enumeration of URLs representing all of the resources
    # on the URL search path having the specified name.
    # 
    # @param name the resource name
    # @exception IOException if an I/O exception occurs
    # @return an <code>Enumeration</code> of <code>URL</code>s
    def find_resources(name)
      e = @ucp.find_resources(name, true)
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members URLClassLoader
        include Enumeration if Enumeration.class == Module
        
        attr_accessor :url
        alias_method :attr_url, :url
        undef_method :url
        alias_method :attr_url=, :url=
        undef_method :url=
        
        typesig { [] }
        define_method :next_ do
          if (!(@url).nil?)
            return true
          end
          begin
            enumeration_class = self.class
            u = AccessController.do_privileged(Class.new(self.class::PrivilegedAction.class == Class ? self.class::PrivilegedAction : Object) do
              extend LocalClass
              include_class_members enumeration_class
              include class_self::PrivilegedAction if class_self::PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                if (!e.has_more_elements)
                  return nil
                end
                return e.next_element
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self), self.attr_acc)
            if ((u).nil?)
              break
            end
            @url = self.attr_ucp.check_url(u)
          end while ((@url).nil?)
          return !(@url).nil?
        end
        
        typesig { [] }
        define_method :next_element do
          if (!next_)
            raise self.class::NoSuchElementException.new
          end
          u = @url
          @url = nil
          return u
        end
        
        typesig { [] }
        define_method :has_more_elements do
          return next_
        end
        
        typesig { [] }
        define_method :initialize do
          @url = nil
          super()
          @url = nil
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [CodeSource] }
    # Returns the permissions for the given codesource object.
    # The implementation of this method first calls super.getPermissions
    # and then adds permissions based on the URL of the codesource.
    # <p>
    # If the protocol of this URL is "jar", then the permission granted
    # is based on the permission that is required by the URL of the Jar
    # file.
    # <p>
    # If the protocol is "file"
    # and the path specifies a file, then permission to read that
    # file is granted. If protocol is "file" and the path is
    # a directory, permission is granted to read all files
    # and (recursively) all files and subdirectories contained in
    # that directory.
    # <p>
    # If the protocol is not "file", then permission
    # to connect to and accept connections from the URL's host is granted.
    # @param codesource the codesource
    # @return the permissions granted to the codesource
    def get_permissions(codesource)
      perms = super(codesource)
      url = codesource.get_location
      p = nil
      url_connection = nil
      begin
        url_connection = url.open_connection
        p = url_connection.get_permission
      rescue Java::Io::IOException => ioe
        p = nil
        url_connection = nil
      end
      if (p.is_a?(FilePermission))
        # if the permission has a separator char on the end,
        # it means the codebase is a directory, and we need
        # to add an additional permission to read recursively
        path = p.get_name
        if (path.ends_with(JavaFile.attr_separator))
          path += "-"
          p = FilePermission.new(path, SecurityConstants::FILE_READ_ACTION)
        end
      else
        if (((p).nil?) && ((url.get_protocol == "file")))
          path = url.get_file.replace(Character.new(?/.ord), JavaFile.attr_separator_char)
          path = RJava.cast_to_string(ParseUtil.decode(path))
          if (path.ends_with(JavaFile.attr_separator))
            path += "-"
          end
          p = FilePermission.new(path, SecurityConstants::FILE_READ_ACTION)
        else
          # Not loading from a 'file:' URL so we want to give the class
          # permission to connect to and accept from the remote host
          # after we've made sure the host is the correct one and is valid.
          loc_url = url
          if (url_connection.is_a?(JarURLConnection))
            loc_url = (url_connection).get_jar_file_url
          end
          host = loc_url.get_host
          if (!(host).nil? && (host.length > 0))
            p = SocketPermission.new(host, SecurityConstants::SOCKET_CONNECT_ACCEPT_ACTION)
          end
        end
      end
      # make sure the person that created this class loader
      # would have this permission
      if (!(p).nil?)
        sm = System.get_security_manager
        if (!(sm).nil?)
          fp = p
          AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members URLClassLoader
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              sm.check_permission(fp)
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self), @acc)
        end
        perms.add(p)
      end
      return perms
    end
    
    class_module.module_eval {
      typesig { [Array.typed(URL), ClassLoader] }
      # Creates a new instance of URLClassLoader for the specified
      # URLs and parent class loader. If a security manager is
      # installed, the <code>loadClass</code> method of the URLClassLoader
      # returned by this method will invoke the
      # <code>SecurityManager.checkPackageAccess</code> method before
      # loading the class.
      # 
      # @param urls the URLs to search for classes and resources
      # @param parent the parent class loader for delegation
      # @return the resulting class loader
      def new_instance(urls, parent)
        # Save the caller's context
        acc = AccessController.get_context
        ucl = AccessController.do_privileged(# Need a privileged block to create the class loader
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members URLClassLoader
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.class::FactoryURLClassLoader.new(urls, parent)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # Now set the context on the loader using the one we saved,
        # not the one inside the privileged block...
        ucl.attr_acc = acc
        return ucl
      end
      
      typesig { [Array.typed(URL)] }
      # Creates a new instance of URLClassLoader for the specified
      # URLs and default parent class loader. If a security manager is
      # installed, the <code>loadClass</code> method of the URLClassLoader
      # returned by this method will invoke the
      # <code>SecurityManager.checkPackageAccess</code> before
      # loading the class.
      # 
      # @param urls the URLs to search for classes and resources
      # @return the resulting class loader
      def new_instance(urls)
        # Save the caller's context
        acc = AccessController.get_context
        ucl = AccessController.do_privileged(# Need a privileged block to create the class loader
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members URLClassLoader
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.class::FactoryURLClassLoader.new(urls)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # Now set the context on the loader using the one we saved,
        # not the one inside the privileged block...
        ucl.attr_acc = acc
        return ucl
      end
      
      when_class_loaded do
        Sun::Misc::SharedSecrets.set_java_net_access(Class.new(Sun::Misc::JavaNetAccess.class == Class ? Sun::Misc::JavaNetAccess : Object) do
          extend LocalClass
          include_class_members URLClassLoader
          include Sun::Misc::JavaNetAccess if Sun::Misc::JavaNetAccess.class == Module
          
          typesig { [URLClassLoader] }
          define_method :get_urlclass_path do |u|
            return u.attr_ucp
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
    
    private
    alias_method :initialize__urlclass_loader, :initialize
  end
  
  class FactoryURLClassLoader < URLClassLoaderImports.const_get :URLClassLoader
    include_class_members URLClassLoaderImports
    
    typesig { [Array.typed(URL), ClassLoader] }
    def initialize(urls, parent)
      super(urls, parent)
    end
    
    typesig { [Array.typed(URL)] }
    def initialize(urls)
      super(urls)
    end
    
    typesig { [String, ::Java::Boolean] }
    def load_class(name, resolve)
      synchronized(self) do
        # First check if we have permission to access the package. This
        # should go away once we've added support for exported packages.
        sm = System.get_security_manager
        if (!(sm).nil?)
          i = name.last_index_of(Character.new(?..ord))
          if (!(i).equal?(-1))
            sm.check_package_access(name.substring(0, i))
          end
        end
        return super(name, resolve)
      end
    end
    
    private
    alias_method :initialize__factory_urlclass_loader, :initialize
  end
  
end
