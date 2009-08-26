require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module URLClassPathImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Util, :Stack
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util::Jar, :JarFile
      include_const ::Sun::Misc, :JarIndex
      include_const ::Sun::Misc, :InvalidJarIndexException
      include_const ::Sun::Net::Www, :ParseUtil
      include_const ::Java::Util::Zip, :ZipEntry
      include_const ::Java::Util::Jar, :JarEntry
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Util::Jar, :Attributes
      include_const ::Java::Util::Jar::Attributes, :Name
      include_const ::Java::Net, :JarURLConnection
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :HttpURLConnection
      include_const ::Java::Net, :URLStreamHandler
      include_const ::Java::Net, :URLStreamHandlerFactory
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :DataOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlException
      include_const ::Java::Security, :CodeSigner
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Sun::Misc, :FileURLMapper
    }
  end
  
  # This class is used to maintain a search path of URLs for loading classes
  # and resources from both JAR files and directories.
  # 
  # @author  David Connelly
  class URLClassPath 
    include_class_members URLClassPathImports
    
    class_module.module_eval {
      const_set_lazy(:USER_AGENT_JAVA_VERSION) { "UA-Java-Version" }
      const_attr_reader  :USER_AGENT_JAVA_VERSION
      
      when_class_loaded do
        const_set :JAVA_VERSION, RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.version")))
        const_set :DEBUG, (!(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("sun.misc.URLClassPath.debug"))).nil?)
      end
    }
    
    # The original search path of URLs.
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    # The stack of unopened URLs
    attr_accessor :urls
    alias_method :attr_urls, :urls
    undef_method :urls
    alias_method :attr_urls=, :urls=
    undef_method :urls=
    
    # The resulting search path of Loaders
    attr_accessor :loaders
    alias_method :attr_loaders, :loaders
    undef_method :loaders
    alias_method :attr_loaders=, :loaders=
    undef_method :loaders=
    
    # Map of each URL opened to its corresponding Loader
    attr_accessor :lmap
    alias_method :attr_lmap, :lmap
    undef_method :lmap
    alias_method :attr_lmap=, :lmap=
    undef_method :lmap=
    
    # The jar protocol handler to use when creating new URLs
    attr_accessor :jar_handler
    alias_method :attr_jar_handler, :jar_handler
    undef_method :jar_handler
    alias_method :attr_jar_handler=, :jar_handler=
    undef_method :jar_handler=
    
    typesig { [Array.typed(URL), URLStreamHandlerFactory] }
    # Creates a new URLClassPath for the given URLs. The URLs will be
    # searched in the order specified for classes and resources. A URL
    # ending with a '/' is assumed to refer to a directory. Otherwise,
    # the URL is assumed to refer to a JAR file.
    # 
    # @param urls the directory and JAR file URLs to search for classes
    # and resources
    # @param factory the URLStreamHandlerFactory to use when creating new URLs
    def initialize(urls, factory)
      @path = ArrayList.new
      @urls = Stack.new
      @loaders = ArrayList.new
      @lmap = HashMap.new
      @jar_handler = nil
      i = 0
      while i < urls.attr_length
        @path.add(urls[i])
        i += 1
      end
      push(urls)
      if (!(factory).nil?)
        @jar_handler = factory.create_urlstream_handler("jar")
      end
    end
    
    typesig { [Array.typed(URL)] }
    def initialize(urls)
      initialize__urlclass_path(urls, nil)
    end
    
    typesig { [URL] }
    # Appends the specified URL to the search path of directory and JAR
    # file URLs from which to load classes and resources.
    def add_url(url)
      synchronized((@urls)) do
        if (@path.contains(url))
          return
        end
        @urls.add(0, url)
        @path.add(url)
      end
    end
    
    typesig { [] }
    # Returns the original search path of URLs.
    def get_urls
      synchronized((@urls)) do
        return @path.to_array(Array.typed(URL).new(@path.size) { nil })
      end
    end
    
    typesig { [String, ::Java::Boolean] }
    # Finds the resource with the specified name on the URL search path
    # or null if not found or security check fails.
    # 
    # @param name      the name of the resource
    # @param check     whether to perform a security check
    # @return a <code>URL</code> for the resource, or <code>null</code>
    # if the resource could not be found.
    def find_resource(name, check)
      loader = nil
      i = 0
      while !((loader = get_loader(i))).nil?
        url = loader.find_resource(name, check)
        if (!(url).nil?)
          return url
        end
        i += 1
      end
      return nil
    end
    
    typesig { [String, ::Java::Boolean] }
    # Finds the first Resource on the URL search path which has the specified
    # name. Returns null if no Resource could be found.
    # 
    # @param name the name of the Resource
    # @param check     whether to perform a security check
    # @return the Resource, or null if not found
    def get_resource(name, check)
      if (DEBUG)
        System.err.println("URLClassPath.getResource(\"" + name + "\")")
      end
      loader = nil
      i = 0
      while !((loader = get_loader(i))).nil?
        res = loader.get_resource(name, check)
        if (!(res).nil?)
          return res
        end
        i += 1
      end
      return nil
    end
    
    typesig { [String, ::Java::Boolean] }
    # Finds all resources on the URL search path with the given name.
    # Returns an enumeration of the URL objects.
    # 
    # @param name the resource name
    # @return an Enumeration of all the urls having the specified name
    def find_resources(name, check)
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members URLClassPath
        include Enumeration if Enumeration.class == Module
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :url
        alias_method :attr_url, :url
        undef_method :url
        alias_method :attr_url=, :url=
        undef_method :url=
        
        typesig { [] }
        define_method :next_ do
          if (!(@url).nil?)
            return true
          else
            loader = nil
            while (!((loader = get_loader(((@index += 1) - 1)))).nil?)
              @url = loader.find_resource(name, check)
              if (!(@url).nil?)
                return true
              end
            end
            return false
          end
        end
        
        typesig { [] }
        define_method :has_more_elements do
          return next_
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
        define_method :initialize do
          @index = 0
          @url = nil
          super()
          @index = 0
          @url = nil
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [String] }
    def get_resource(name)
      return get_resource(name, true)
    end
    
    typesig { [String, ::Java::Boolean] }
    # Finds all resources on the URL search path with the given name.
    # Returns an enumeration of the Resource objects.
    # 
    # @param name the resource name
    # @return an Enumeration of all the resources having the specified name
    def get_resources(name, check)
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members URLClassPath
        include Enumeration if Enumeration.class == Module
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :res
        alias_method :attr_res, :res
        undef_method :res
        alias_method :attr_res=, :res=
        undef_method :res=
        
        typesig { [] }
        define_method :next_ do
          if (!(@res).nil?)
            return true
          else
            loader = nil
            while (!((loader = get_loader(((@index += 1) - 1)))).nil?)
              @res = loader.get_resource(name, check)
              if (!(@res).nil?)
                return true
              end
            end
            return false
          end
        end
        
        typesig { [] }
        define_method :has_more_elements do
          return next_
        end
        
        typesig { [] }
        define_method :next_element do
          if (!next_)
            raise self.class::NoSuchElementException.new
          end
          r = @res
          @res = nil
          return r
        end
        
        typesig { [] }
        define_method :initialize do
          @index = 0
          @res = nil
          super()
          @index = 0
          @res = nil
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [String] }
    def get_resources(name)
      return get_resources(name, true)
    end
    
    typesig { [::Java::Int] }
    # Returns the Loader at the specified position in the URL search
    # path. The URLs are opened and expanded as needed. Returns null
    # if the specified index is out of range.
    def get_loader(index)
      synchronized(self) do
        # Expand URL search path until the request can be satisfied
        # or the URL stack is empty.
        while (@loaders.size < index + 1)
          # Pop the next URL from the URL stack
          url = nil
          synchronized((@urls)) do
            if (@urls.empty)
              return nil
            else
              url = @urls.pop
            end
          end
          # Skip this URL if it already has a Loader. (Loader
          # may be null in the case where URL has not been opened
          # but is referenced by a JAR index.)
          if (@lmap.contains_key(url))
            next
          end
          # Otherwise, create a new Loader for the URL.
          loader = nil
          begin
            loader = get_loader(url)
            # If the loader defines a local class path then add the
            # URLs to the list of URLs to be opened.
            urls = loader.get_class_path
            if (!(urls).nil?)
              push(urls)
            end
          rescue IOException => e
            # Silently ignore for now...
            next
          end
          # Finally, add the Loader to the search path.
          @loaders.add(loader)
          @lmap.put(url, loader)
        end
        return @loaders.get(index)
      end
    end
    
    typesig { [URL] }
    # Returns the Loader for the specified base URL.
    def get_loader(url)
      begin
        return Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members URLClassPath
          include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            file = url.get_file
            if (!(file).nil? && file.ends_with("/"))
              if (("file" == url.get_protocol))
                return self.class::FileLoader.new(url)
              else
                return self.class::Loader.new(url)
              end
            else
              return self.class::JarLoader.new(url, self.attr_jar_handler, self.attr_lmap)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue Java::Security::PrivilegedActionException => pae
        raise pae.get_exception
      end
    end
    
    typesig { [Array.typed(URL)] }
    # Pushes the specified URLs onto the list of unopened URLs.
    def push(us)
      synchronized((@urls)) do
        i = us.attr_length - 1
        while i >= 0
          @urls.push(us[i])
          (i -= 1)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Convert class path specification into an array of file URLs.
      # 
      # The path of the file is encoded before conversion into URL
      # form so that reserved characters can safely appear in the path.
      def path_to_urls(path)
        st = StringTokenizer.new(path, JavaFile.attr_path_separator)
        urls = Array.typed(URL).new(st.count_tokens) { nil }
        count = 0
        while (st.has_more_tokens)
          f = JavaFile.new(st.next_token)
          begin
            f = JavaFile.new(f.get_canonical_path)
          rescue IOException => x
            # use the non-canonicalized filename
          end
          begin
            urls[((count += 1) - 1)] = ParseUtil.file_to_encoded_url(f)
          rescue IOException => x
          end
        end
        if (!(urls.attr_length).equal?(count))
          tmp = Array.typed(URL).new(count) { nil }
          System.arraycopy(urls, 0, tmp, 0, count)
          urls = tmp
        end
        return urls
      end
    }
    
    typesig { [URL] }
    # Check whether the resource URL should be returned.
    # Return null on security check failure.
    # Called by java.net.URLClassLoader.
    def check_url(url)
      begin
        check(url)
      rescue JavaException => e
        return nil
      end
      return url
    end
    
    class_module.module_eval {
      typesig { [URL] }
      # Check whether the resource URL should be returned.
      # Throw exception on failure.
      # Called internally within this file.
      def check(url)
        security = System.get_security_manager
        if (!(security).nil?)
          url_connection = url.open_connection
          perm = url_connection.get_permission
          if (!(perm).nil?)
            begin
              security.check_permission(perm)
            rescue SecurityException => se
              # fallback to checkRead/checkConnect for pre 1.2
              # security managers
              if ((perm.is_a?(Java::Io::FilePermission)) && !(perm.get_actions.index_of("read")).equal?(-1))
                security.check_read(perm.get_name)
              else
                if ((perm.is_a?(Java::Net::SocketPermission)) && !(perm.get_actions.index_of("connect")).equal?(-1))
                  loc_url = url
                  if (url_connection.is_a?(JarURLConnection))
                    loc_url = (url_connection).get_jar_file_url
                  end
                  security.check_connect(loc_url.get_host, loc_url.get_port)
                else
                  raise se
                end
              end
            end
          end
        end
      end
      
      # Inner class used to represent a loader of resources and classes
      # from a base URL.
      const_set_lazy(:Loader) { Class.new do
        include_class_members URLClassPath
        
        attr_accessor :base
        alias_method :attr_base, :base
        undef_method :base
        alias_method :attr_base=, :base=
        undef_method :base=
        
        typesig { [self::URL] }
        # Creates a new Loader for the specified URL.
        def initialize(url)
          @base = nil
          @base = url
        end
        
        typesig { [] }
        # Returns the base URL for this Loader.
        def get_base_url
          return @base
        end
        
        typesig { [String, ::Java::Boolean] }
        def find_resource(name, check)
          url = nil
          begin
            url = self.class::URL.new(@base, ParseUtil.encode_path(name, false))
          rescue self.class::MalformedURLException => e
            raise self.class::IllegalArgumentException.new("name")
          end
          begin
            if (check)
              URLClassPath.check(url)
            end
            # For a HTTP connection we use the HEAD method to
            # check if the resource exists.
            uc = url.open_connection
            if (uc.is_a?(self.class::HttpURLConnection))
              hconn = uc
              hconn.set_request_method("HEAD")
              if (hconn.get_response_code >= HttpURLConnection::HTTP_BAD_REQUEST)
                return nil
              end
            else
              # our best guess for the other cases
              is = url.open_stream
              is.close
            end
            return url
          rescue self.class::JavaException => e
            return nil
          end
        end
        
        typesig { [String, ::Java::Boolean] }
        def get_resource(name, check_)
          url = nil
          begin
            url = self.class::URL.new(@base, ParseUtil.encode_path(name, false))
          rescue self.class::MalformedURLException => e
            raise self.class::IllegalArgumentException.new("name")
          end
          uc = nil
          begin
            if (check_)
              URLClassPath.check(url)
            end
            uc = url.open_connection
            in_ = uc.get_input_stream
          rescue self.class::JavaException => e
            return nil
          end
          return Class.new(self.class::Resource.class == Class ? self.class::Resource : Object) do
            extend LocalClass
            include_class_members Loader
            include self::Resource if self::Resource.class == Module
            
            typesig { [] }
            define_method :get_name do
              return name
            end
            
            typesig { [] }
            define_method :get_url do
              return url
            end
            
            typesig { [] }
            define_method :get_code_source_url do
              return self.attr_base
            end
            
            typesig { [] }
            define_method :get_input_stream do
              return uc.get_input_stream
            end
            
            typesig { [] }
            define_method :get_content_length do
              return uc.get_content_length
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [String] }
        # Returns the Resource for the specified name, or null if not
        # found or the caller does not have the permission to get the
        # resource.
        def get_resource(name)
          return get_resource(name, true)
        end
        
        typesig { [] }
        # Returns the local class path for this loader, or null if none.
        def get_class_path
          return nil
        end
        
        private
        alias_method :initialize__loader, :initialize
      end }
      
      # Inner class used to represent a Loader of resources from a JAR URL.
      const_set_lazy(:JarLoader) { Class.new(Loader) do
        include_class_members URLClassPath
        
        attr_accessor :jar
        alias_method :attr_jar, :jar
        undef_method :jar
        alias_method :attr_jar=, :jar=
        undef_method :jar=
        
        attr_accessor :csu
        alias_method :attr_csu, :csu
        undef_method :csu
        alias_method :attr_csu=, :csu=
        undef_method :csu=
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :meta_index
        alias_method :attr_meta_index, :meta_index
        undef_method :meta_index
        alias_method :attr_meta_index=, :meta_index=
        undef_method :meta_index=
        
        attr_accessor :handler
        alias_method :attr_handler, :handler
        undef_method :handler
        alias_method :attr_handler=, :handler=
        undef_method :handler=
        
        attr_accessor :lmap
        alias_method :attr_lmap, :lmap
        undef_method :lmap
        alias_method :attr_lmap=, :lmap=
        undef_method :lmap=
        
        typesig { [self::URL, self::URLStreamHandler, self::HashMap] }
        # Creates a new JarLoader for the specified URL referring to
        # a JAR file.
        def initialize(url, jar_handler, loader_map)
          @jar = nil
          @csu = nil
          @index = nil
          @meta_index = nil
          @handler = nil
          @lmap = nil
          super(self.class::URL.new("jar", "", -1, RJava.cast_to_string(url) + "!/", jar_handler))
          @csu = url
          @handler = jar_handler
          @lmap = loader_map
          if (!is_optimizable(url))
            ensure_open
          else
            file_name = url.get_file
            if (!(file_name).nil?)
              file_name = RJava.cast_to_string(ParseUtil.decode(file_name))
              f = self.class::JavaFile.new(file_name)
              @meta_index = MetaIndex.for_jar(f)
              # If the meta index is found but the file is not
              # installed, set metaIndex to null. A typical
              # senario is charsets.jar which won't be installed
              # when the user is running in certain locale environment.
              # The side effect of null metaIndex will cause
              # ensureOpen get called so that IOException is thrown.
              if (!(@meta_index).nil? && !f.exists)
                @meta_index = nil
              end
            end
            # metaIndex is null when either there is no such jar file
            # entry recorded in meta-index file or such jar file is
            # missing in JRE. See bug 6340399.
            if ((@meta_index).nil?)
              ensure_open
            end
          end
        end
        
        typesig { [] }
        def get_jar_file
          return @jar
        end
        
        typesig { [self::URL] }
        def is_optimizable(url)
          return ("file" == url.get_protocol)
        end
        
        typesig { [] }
        def ensure_open
          if ((@jar).nil?)
            begin
              Java::Security::AccessController.do_privileged(Class.new(Java::Security::self.class::PrivilegedExceptionAction.class == Class ? Java::Security::self.class::PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members JarLoader
                include Java::Security::self::PrivilegedExceptionAction if Java::Security::self::PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  if (DEBUG)
                    System.err.println("Opening " + RJava.cast_to_string(self.attr_csu))
                    JavaThread.dump_stack
                  end
                  self.attr_jar = get_jar_file(self.attr_csu)
                  self.attr_index = JarIndex.get_jar_index(self.attr_jar, self.attr_meta_index)
                  if (!(self.attr_index).nil?)
                    jarfiles = self.attr_index.get_jar_files
                    # Add all the dependent URLs to the lmap so that loaders
                    # will not be created for them by URLClassPath.getLoader(int)
                    # if the same URL occurs later on the main class path.  We set
                    # Loader to null here to avoid creating a Loader for each
                    # URL until we actually need to try to load something from them.
                    i = 0
                    while i < jarfiles.attr_length
                      begin
                        jar_url = self.class::URL.new(self.attr_csu, jarfiles[i])
                        # If a non-null loader already exists, leave it alone.
                        if (!self.attr_lmap.contains_key(jar_url))
                          self.attr_lmap.put(jar_url, nil)
                        end
                      rescue self.class::MalformedURLException => e
                        i += 1
                        next
                      end
                      i += 1
                    end
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
            rescue Java::Security::self.class::PrivilegedActionException => pae
              raise pae.get_exception
            end
          end
        end
        
        typesig { [self::URL] }
        def get_jar_file(url)
          # Optimize case where url refers to a local jar file
          if (is_optimizable(url))
            p = self.class::FileURLMapper.new(url)
            if (!p.exists)
              raise self.class::FileNotFoundException.new(p.get_path)
            end
            return self.class::JarFile.new(p.get_path)
          end
          uc = get_base_url.open_connection
          uc.set_request_property(USER_AGENT_JAVA_VERSION, JAVA_VERSION)
          return (uc).get_jar_file
        end
        
        typesig { [] }
        # Returns the index of this JarLoader if it exists.
        def get_index
          begin
            ensure_open
          rescue self.class::IOException => e
            raise self.class::InternalError.new.init_cause(e)
          end
          return @index
        end
        
        typesig { [String, ::Java::Boolean, self::JarEntry] }
        # Creates the resource and if the check flag is set to true, checks if
        # is its okay to return the resource.
        def check_resource(name, check, entry)
          url = nil
          begin
            url = self.class::URL.new(get_base_url, ParseUtil.encode_path(name, false))
            if (check)
              URLClassPath.check(url)
            end
          rescue self.class::MalformedURLException => e
            return nil
            # throw new IllegalArgumentException("name");
          rescue self.class::IOException => e
            return nil
          rescue self.class::AccessControlException => e
            return nil
          end
          return Class.new(self.class::Resource.class == Class ? self.class::Resource : Object) do
            extend LocalClass
            include_class_members JarLoader
            include self::Resource if self::Resource.class == Module
            
            typesig { [] }
            define_method :get_name do
              return name
            end
            
            typesig { [] }
            define_method :get_url do
              return url
            end
            
            typesig { [] }
            define_method :get_code_source_url do
              return self.attr_csu
            end
            
            typesig { [] }
            define_method :get_input_stream do
              return self.attr_jar.get_input_stream(entry)
            end
            
            typesig { [] }
            define_method :get_content_length do
              return RJava.cast_to_int(entry.get_size)
            end
            
            typesig { [] }
            define_method :get_manifest do
              return self.attr_jar.get_manifest
            end
            
            typesig { [] }
            define_method :get_certificates do
              return entry.get_certificates
            end
            
            typesig { [] }
            define_method :get_code_signers do
              return entry.get_code_signers
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [String] }
        # Returns true iff atleast one resource in the jar file has the same
        # package name as that of the specified resource name.
        def valid_index(name)
          package_name = name
          pos = 0
          if (!((pos = name.last_index_of("/"))).equal?(-1))
            package_name = RJava.cast_to_string(name.substring(0, pos))
          end
          entry_name = nil
          entry = nil
          enum_ = @jar.entries
          while (enum_.has_more_elements)
            entry = enum_.next_element
            entry_name = RJava.cast_to_string(entry.get_name)
            if (!((pos = entry_name.last_index_of("/"))).equal?(-1))
              entry_name = RJava.cast_to_string(entry_name.substring(0, pos))
            end
            if ((entry_name == package_name))
              return true
            end
          end
          return false
        end
        
        typesig { [String, ::Java::Boolean] }
        # Returns the URL for a resource with the specified name
        def find_resource(name, check_)
          rsc = get_resource(name, check_)
          if (!(rsc).nil?)
            return rsc.get_url
          end
          return nil
        end
        
        typesig { [String, ::Java::Boolean] }
        # Returns the JAR Resource for the specified name.
        def get_resource(name, check_)
          if (!(@meta_index).nil?)
            if (!@meta_index.may_contain(name))
              return nil
            end
          end
          begin
            ensure_open
          rescue self.class::IOException => e
            raise self.class::InternalError.new.init_cause(e)
          end
          entry = @jar.get_jar_entry(name)
          if (!(entry).nil?)
            return check_resource(name, check_, entry)
          end
          if ((@index).nil?)
            return nil
          end
          visited = self.class::HashSet.new
          return get_resource(name, check_, visited)
        end
        
        typesig { [String, ::Java::Boolean, self::JavaSet] }
        # Version of getResource() that tracks the jar files that have been
        # visited by linking through the index files. This helper method uses
        # a HashSet to store the URLs of jar files that have been searched and
        # uses it to avoid going into an infinite loop, looking for a
        # non-existent resource
        def get_resource(name, check_, visited)
          res = nil
          jar_files = nil
          done = false
          count = 0
          jar_files_list = nil
          # If there no jar files in the index that can potential contain
          # this resource then return immediately.
          if (((jar_files_list = @index.get(name))).nil?)
            return nil
          end
          begin
            jar_files = jar_files_list.to_array
            size_ = jar_files_list.size
            # loop through the mapped jar file list
            while (count < size_)
              jar_name = jar_files[((count += 1) - 1)]
              new_loader = nil
              url = nil
              begin
                url = self.class::URL.new(@csu, jar_name)
                if (((new_loader = @lmap.get(url))).nil?)
                  new_loader = AccessController.do_privileged(# no loader has been set up for this jar file
                  # before
                  Class.new(self.class::PrivilegedExceptionAction.class == Class ? self.class::PrivilegedExceptionAction : Object) do
                    extend LocalClass
                    include_class_members JarLoader
                    include self::PrivilegedExceptionAction if self::PrivilegedExceptionAction.class == Module
                    
                    typesig { [] }
                    define_method :run do
                      return self.class::JarLoader.new(url, self.attr_handler, self.attr_lmap)
                    end
                    
                    typesig { [] }
                    define_method :initialize do
                      super()
                    end
                    
                    private
                    alias_method :initialize_anonymous, :initialize
                  end.new_local(self))
                  # this newly opened jar file has its own index,
                  # merge it into the parent's index, taking into
                  # account the relative path.
                  new_index = new_loader.get_index
                  if (!(new_index).nil?)
                    pos = jar_name.last_index_of("/")
                    new_index.merge(@index, ((pos).equal?(-1) ? nil : jar_name.substring(0, pos + 1)))
                  end
                  # put it in the global hashtable
                  @lmap.put(url, new_loader)
                end
              rescue Java::Security::self.class::PrivilegedActionException => pae
                next
              rescue self.class::MalformedURLException => e
                next
              end
              # Note that the addition of the url to the list of visited
              # jars incorporates a check for presence in the hashmap
              visited_url = !visited.add(url)
              if (!visited_url)
                begin
                  new_loader.ensure_open
                rescue self.class::IOException => e
                  raise self.class::InternalError.new.init_cause(e)
                end
                entry = new_loader.attr_jar.get_jar_entry(name)
                if (!(entry).nil?)
                  return new_loader.check_resource(name, check_, entry)
                end
                # Verify that at least one other resource with the
                # same package name as the lookedup resource is
                # present in the new jar
                if (!new_loader.valid_index(name))
                  # the mapping is wrong
                  raise self.class::InvalidJarIndexException.new("Invalid index")
                end
              end
              # If newLoader is the current loader or if it is a
              # loader that has already been searched or if the new
              # loader does not have an index then skip it
              # and move on to the next loader.
              if (visited_url || (new_loader).equal?(self) || (new_loader.get_index).nil?)
                next
              end
              # Process the index of the new loader
              if (!((res = new_loader.get_resource(name, check_, visited))).nil?)
                return res
              end
            end
            # Get the list of jar files again as the list could have grown
            # due to merging of index files.
            jar_files_list = @index.get(name)
          end while (count < jar_files_list.size)
          return nil
        end
        
        typesig { [] }
        # Returns the JAR file local class path, or null if none.
        def get_class_path
          if (!(@index).nil?)
            return nil
          end
          if (!(@meta_index).nil?)
            return nil
          end
          ensure_open
          parse_extensions_dependencies
          if (SharedSecrets.java_util_jar_access.jar_file_has_class_path_attribute(@jar))
            # Only get manifest when necessary
            man = @jar.get_manifest
            if (!(man).nil?)
              attr = man.get_main_attributes
              if (!(attr).nil?)
                value = attr.get_value(Name::CLASS_PATH)
                if (!(value).nil?)
                  return parse_class_path(@csu, value)
                end
              end
            end
          end
          return nil
        end
        
        typesig { [] }
        # parse the standard extension dependencies
        def parse_extensions_dependencies
          ExtensionDependency.check_extensions_dependencies(@jar)
        end
        
        typesig { [self::URL, String] }
        # Parses value of the Class-Path manifest attribute and returns
        # an array of URLs relative to the specified base URL.
        def parse_class_path(base, value)
          st = self.class::StringTokenizer.new(value)
          urls = Array.typed(self.class::URL).new(st.count_tokens) { nil }
          i = 0
          while (st.has_more_tokens)
            path = st.next_token
            urls[i] = self.class::URL.new(base, path)
            i += 1
          end
          return urls
        end
        
        private
        alias_method :initialize__jar_loader, :initialize
      end }
      
      # Inner class used to represent a loader of classes and resources
      # from a file URL that refers to a directory.
      const_set_lazy(:FileLoader) { Class.new(Loader) do
        include_class_members URLClassPath
        
        attr_accessor :dir
        alias_method :attr_dir, :dir
        undef_method :dir
        alias_method :attr_dir=, :dir=
        undef_method :dir=
        
        typesig { [self::URL] }
        def initialize(url)
          @dir = nil
          super(url)
          if (!("file" == url.get_protocol))
            raise self.class::IllegalArgumentException.new("url")
          end
          path = url.get_file.replace(Character.new(?/.ord), JavaFile.attr_separator_char)
          path = RJava.cast_to_string(ParseUtil.decode(path))
          @dir = self.class::JavaFile.new(path)
        end
        
        typesig { [String, ::Java::Boolean] }
        # Returns the URL for a resource with the specified name
        def find_resource(name, check)
          rsc = get_resource(name, check)
          if (!(rsc).nil?)
            return rsc.get_url
          end
          return nil
        end
        
        typesig { [String, ::Java::Boolean] }
        def get_resource(name, check)
          url = nil
          begin
            normalized_base = self.class::URL.new(get_base_url, ".")
            url = self.class::URL.new(get_base_url, ParseUtil.encode_path(name, false))
            if ((url.get_file.starts_with(normalized_base.get_file)).equal?(false))
              # requested resource had ../..'s in path
              return nil
            end
            if (check)
              URLClassPath.check(url)
            end
            file = self.class::JavaFile.new(@dir, name.replace(Character.new(?/.ord), JavaFile.attr_separator_char))
            if (file.exists)
              return Class.new(self.class::Resource.class == Class ? self.class::Resource : Object) do
                extend LocalClass
                include_class_members FileLoader
                include self::Resource if self::Resource.class == Module
                
                typesig { [] }
                define_method :get_name do
                  return name
                end
                
                typesig { [] }
                define_method :get_url do
                  return url
                end
                
                typesig { [] }
                define_method :get_code_source_url do
                  return get_base_url
                end
                
                typesig { [] }
                define_method :get_input_stream do
                  return self.class::FileInputStream.new(file)
                end
                
                typesig { [] }
                define_method :get_content_length do
                  return RJava.cast_to_int(file.length)
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self)
            end
          rescue self.class::JavaException => e
            return nil
          end
          return nil
        end
        
        private
        alias_method :initialize__file_loader, :initialize
      end }
    }
    
    private
    alias_method :initialize__urlclass_path, :initialize
  end
  
end
