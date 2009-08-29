require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module ServiceLoaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Net, :URL
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # A simple service-provider loading facility.
  # 
  # <p> A <i>service</i> is a well-known set of interfaces and (usually
  # abstract) classes.  A <i>service provider</i> is a specific implementation
  # of a service.  The classes in a provider typically implement the interfaces
  # and subclass the classes defined in the service itself.  Service providers
  # can be installed in an implementation of the Java platform in the form of
  # extensions, that is, jar files placed into any of the usual extension
  # directories.  Providers can also be made available by adding them to the
  # application's class path or by some other platform-specific means.
  # 
  # <p> For the purpose of loading, a service is represented by a single type,
  # that is, a single interface or abstract class.  (A concrete class can be
  # used, but this is not recommended.)  A provider of a given service contains
  # one or more concrete classes that extend this <i>service type</i> with data
  # and code specific to the provider.  The <i>provider class</i> is typically
  # not the entire provider itself but rather a proxy which contains enough
  # information to decide whether the provider is able to satisfy a particular
  # request together with code that can create the actual provider on demand.
  # The details of provider classes tend to be highly service-specific; no
  # single class or interface could possibly unify them, so no such type is
  # defined here.  The only requirement enforced by this facility is that
  # provider classes must have a zero-argument constructor so that they can be
  # instantiated during loading.
  # 
  # <p><a name="format"> A service provider is identified by placing a
  # <i>provider-configuration file</i> in the resource directory
  # <tt>META-INF/services</tt>.  The file's name is the fully-qualified <a
  # href="../lang/ClassLoader.html#name">binary name</a> of the service's type.
  # The file contains a list of fully-qualified binary names of concrete
  # provider classes, one per line.  Space and tab characters surrounding each
  # name, as well as blank lines, are ignored.  The comment character is
  # <tt>'#'</tt> (<tt>'&#92;u0023'</tt>, <font size="-1">NUMBER SIGN</font>); on
  # each line all characters following the first comment character are ignored.
  # The file must be encoded in UTF-8.
  # 
  # <p> If a particular concrete provider class is named in more than one
  # configuration file, or is named in the same configuration file more than
  # once, then the duplicates are ignored.  The configuration file naming a
  # particular provider need not be in the same jar file or other distribution
  # unit as the provider itself.  The provider must be accessible from the same
  # class loader that was initially queried to locate the configuration file;
  # note that this is not necessarily the class loader from which the file was
  # actually loaded.
  # 
  # <p> Providers are located and instantiated lazily, that is, on demand.  A
  # service loader maintains a cache of the providers that have been loaded so
  # far.  Each invocation of the {@link #iterator iterator} method returns an
  # iterator that first yields all of the elements of the cache, in
  # instantiation order, and then lazily locates and instantiates any remaining
  # providers, adding each one to the cache in turn.  The cache can be cleared
  # via the {@link #reload reload} method.
  # 
  # <p> Service loaders always execute in the security context of the caller.
  # Trusted system code should typically invoke the methods in this class, and
  # the methods of the iterators which they return, from within a privileged
  # security context.
  # 
  # <p> Instances of this class are not safe for use by multiple concurrent
  # threads.
  # 
  # <p> Unless otherwise specified, passing a <tt>null</tt> argument to any
  # method in this class will cause a {@link NullPointerException} to be thrown.
  # 
  # 
  # <p><span style="font-weight: bold; padding-right: 1em">Example</span>
  # Suppose we have a service type <tt>com.example.CodecSet</tt> which is
  # intended to represent sets of encoder/decoder pairs for some protocol.  In
  # this case it is an abstract class with two abstract methods:
  # 
  # <blockquote><pre>
  # public abstract Encoder getEncoder(String encodingName);
  # public abstract Decoder getDecoder(String encodingName);</pre></blockquote>
  # 
  # Each method returns an appropriate object or <tt>null</tt> if the provider
  # does not support the given encoding.  Typical providers support more than
  # one encoding.
  # 
  # <p> If <tt>com.example.impl.StandardCodecs</tt> is an implementation of the
  # <tt>CodecSet</tt> service then its jar file also contains a file named
  # 
  # <blockquote><pre>
  # META-INF/services/com.example.CodecSet</pre></blockquote>
  # 
  # <p> This file contains the single line:
  # 
  # <blockquote><pre>
  # com.example.impl.StandardCodecs    # Standard codecs</pre></blockquote>
  # 
  # <p> The <tt>CodecSet</tt> class creates and saves a single service instance
  # at initialization:
  # 
  # <blockquote><pre>
  # private static ServiceLoader&lt;CodecSet&gt; codecSetLoader
  # = ServiceLoader.load(CodecSet.class);</pre></blockquote>
  # 
  # <p> To locate an encoder for a given encoding name it defines a static
  # factory method which iterates through the known and available providers,
  # returning only when it has located a suitable encoder or has run out of
  # providers.
  # 
  # <blockquote><pre>
  # public static Encoder getEncoder(String encodingName) {
  # for (CodecSet cp : codecSetLoader) {
  # Encoder enc = cp.getEncoder(encodingName);
  # if (enc != null)
  # return enc;
  # }
  # return null;
  # }</pre></blockquote>
  # 
  # <p> A <tt>getDecoder</tt> method is defined similarly.
  # 
  # 
  # <p><span style="font-weight: bold; padding-right: 1em">Usage Note</span> If
  # the class path of a class loader that is used for provider loading includes
  # remote network URLs then those URLs will be dereferenced in the process of
  # searching for provider-configuration files.
  # 
  # <p> This activity is normal, although it may cause puzzling entries to be
  # created in web-server logs.  If a web server is not configured correctly,
  # however, then this activity may cause the provider-loading algorithm to fail
  # spuriously.
  # 
  # <p> A web server should return an HTTP 404 (Not Found) response when a
  # requested resource does not exist.  Sometimes, however, web servers are
  # erroneously configured to return an HTTP 200 (OK) response along with a
  # helpful HTML error page in such cases.  This will cause a {@link
  # ServiceConfigurationError} to be thrown when this class attempts to parse
  # the HTML page as a provider-configuration file.  The best solution to this
  # problem is to fix the misconfigured web server to return the correct
  # response code (HTTP 404) along with the HTML error page.
  # 
  # @param  <S>
  # The type of the service to be loaded by this loader
  # 
  # @author Mark Reinhold
  # @since 1.6
  class ServiceLoader 
    include_class_members ServiceLoaderImports
    include Iterable
    
    class_module.module_eval {
      const_set_lazy(:PREFIX) { "META-INF/services/" }
      const_attr_reader  :PREFIX
    }
    
    # The class or interface representing the service being loaded
    attr_accessor :service
    alias_method :attr_service, :service
    undef_method :service
    alias_method :attr_service=, :service=
    undef_method :service=
    
    # The class loader used to locate, load, and instantiate providers
    attr_accessor :loader
    alias_method :attr_loader, :loader
    undef_method :loader
    alias_method :attr_loader=, :loader=
    undef_method :loader=
    
    # Cached providers, in instantiation order
    attr_accessor :providers
    alias_method :attr_providers, :providers
    undef_method :providers
    alias_method :attr_providers=, :providers=
    undef_method :providers=
    
    # The current lazy-lookup iterator
    attr_accessor :lookup_iterator
    alias_method :attr_lookup_iterator, :lookup_iterator
    undef_method :lookup_iterator
    alias_method :attr_lookup_iterator=, :lookup_iterator=
    undef_method :lookup_iterator=
    
    typesig { [] }
    # Clear this loader's provider cache so that all providers will be
    # reloaded.
    # 
    # <p> After invoking this method, subsequent invocations of the {@link
    # #iterator() iterator} method will lazily look up and instantiate
    # providers from scratch, just as is done by a newly-created loader.
    # 
    # <p> This method is intended for use in situations in which new providers
    # can be installed into a running Java virtual machine.
    def reload
      @providers.clear
      @lookup_iterator = LazyIterator.new_local(self, @service, @loader)
    end
    
    typesig { [Class, ClassLoader] }
    def initialize(svc, cl)
      @service = nil
      @loader = nil
      @providers = LinkedHashMap.new
      @lookup_iterator = nil
      @service = svc
      @loader = cl
      reload
    end
    
    class_module.module_eval {
      typesig { [Class, String, JavaThrowable] }
      def fail(service, msg, cause)
        raise ServiceConfigurationError.new(RJava.cast_to_string(service.get_name) + ": " + msg, cause)
      end
      
      typesig { [Class, String] }
      def fail(service, msg)
        raise ServiceConfigurationError.new(RJava.cast_to_string(service.get_name) + ": " + msg)
      end
      
      typesig { [Class, URL, ::Java::Int, String] }
      def fail(service, u, line, msg)
        fail(service, RJava.cast_to_string(u) + ":" + RJava.cast_to_string(line) + ": " + msg)
      end
    }
    
    typesig { [Class, URL, BufferedReader, ::Java::Int, JavaList] }
    # Parse a single line from the given configuration file, adding the name
    # on the line to the names list.
    def parse_line(service, u, r, lc, names)
      ln = r.read_line
      if ((ln).nil?)
        return -1
      end
      ci = ln.index_of(Character.new(?#.ord))
      if (ci >= 0)
        ln = RJava.cast_to_string(ln.substring(0, ci))
      end
      ln = RJava.cast_to_string(ln.trim)
      n = ln.length
      if (!(n).equal?(0))
        if ((ln.index_of(Character.new(?\s.ord)) >= 0) || (ln.index_of(Character.new(?\t.ord)) >= 0))
          fail(service, u, lc, "Illegal configuration-file syntax")
        end
        cp = ln.code_point_at(0)
        if (!Character.is_java_identifier_start(cp))
          fail(service, u, lc, "Illegal provider-class name: " + ln)
        end
        i = Character.char_count(cp)
        while i < n
          cp = ln.code_point_at(i)
          if (!Character.is_java_identifier_part(cp) && (!(cp).equal?(Character.new(?..ord))))
            fail(service, u, lc, "Illegal provider-class name: " + ln)
          end
          i += Character.char_count(cp)
        end
        if (!@providers.contains_key(ln) && !names.contains(ln))
          names.add(ln)
        end
      end
      return lc + 1
    end
    
    typesig { [Class, URL] }
    # Parse the content of the given URL as a provider-configuration file.
    # 
    # @param  service
    # The service type for which providers are being sought;
    # used to construct error detail strings
    # 
    # @param  u
    # The URL naming the configuration file to be parsed
    # 
    # @return A (possibly empty) iterator that will yield the provider-class
    # names in the given configuration file that are not yet members
    # of the returned set
    # 
    # @throws ServiceConfigurationError
    # If an I/O error occurs while reading from the given URL, or
    # if a configuration-file format error is detected
    def parse(service, u)
      in_ = nil
      r = nil
      names = ArrayList.new
      begin
        in_ = u.open_stream
        r = BufferedReader.new(InputStreamReader.new(in_, "utf-8"))
        lc = 1
        while ((lc = parse_line(service, u, r, lc, names)) >= 0)
        end
      rescue IOException => x
        fail(service, "Error reading configuration file", x)
      ensure
        begin
          if (!(r).nil?)
            r.close
          end
          if (!(in_).nil?)
            in_.close
          end
        rescue IOException => y
          fail(service, "Error closing configuration file", y)
        end
      end
      return names.iterator
    end
    
    class_module.module_eval {
      # Private inner class implementing fully-lazy provider lookup
      const_set_lazy(:LazyIterator) { Class.new do
        extend LocalClass
        include_class_members ServiceLoader
        include Iterator
        
        attr_accessor :service
        alias_method :attr_service, :service
        undef_method :service
        alias_method :attr_service=, :service=
        undef_method :service=
        
        attr_accessor :loader
        alias_method :attr_loader, :loader
        undef_method :loader
        alias_method :attr_loader=, :loader=
        undef_method :loader=
        
        attr_accessor :configs
        alias_method :attr_configs, :configs
        undef_method :configs
        alias_method :attr_configs=, :configs=
        undef_method :configs=
        
        attr_accessor :pending
        alias_method :attr_pending, :pending
        undef_method :pending
        alias_method :attr_pending=, :pending=
        undef_method :pending=
        
        attr_accessor :next_name
        alias_method :attr_next_name, :next_name
        undef_method :next_name
        alias_method :attr_next_name=, :next_name=
        undef_method :next_name=
        
        typesig { [class_self::Class, class_self::ClassLoader] }
        def initialize(service, loader)
          @service = nil
          @loader = nil
          @configs = nil
          @pending = nil
          @next_name = nil
          @service = service
          @loader = loader
        end
        
        typesig { [] }
        def has_next
          if (!(@next_name).nil?)
            return true
          end
          if ((@configs).nil?)
            begin
              full_name = PREFIX + RJava.cast_to_string(@service.get_name)
              if ((@loader).nil?)
                @configs = ClassLoader.get_system_resources(full_name)
              else
                @configs = @loader.get_resources(full_name)
              end
            rescue self.class::IOException => x
              fail(@service, "Error locating configuration files", x)
            end
          end
          while (((@pending).nil?) || !@pending.has_next)
            if (!@configs.has_more_elements)
              return false
            end
            @pending = parse(@service, @configs.next_element)
          end
          @next_name = RJava.cast_to_string(@pending.next_)
          return true
        end
        
        typesig { [] }
        def next_
          if (!has_next)
            raise self.class::NoSuchElementException.new
          end
          cn = @next_name
          @next_name = RJava.cast_to_string(nil)
          begin
            p = @service.cast(Class.for_name(cn, true, @loader).new_instance)
            self.attr_providers.put(cn, p)
            return p
          rescue self.class::ClassNotFoundException => x
            fail(@service, "Provider " + cn + " not found")
          rescue self.class::JavaThrowable => x
            fail(@service, "Provider " + cn + " could not be instantiated: " + RJava.cast_to_string(x), x)
          end
          raise self.class::JavaError.new # This cannot happen
        end
        
        typesig { [] }
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__lazy_iterator, :initialize
      end }
    }
    
    typesig { [] }
    # Lazily loads the available providers of this loader's service.
    # 
    # <p> The iterator returned by this method first yields all of the
    # elements of the provider cache, in instantiation order.  It then lazily
    # loads and instantiates any remaining providers, adding each one to the
    # cache in turn.
    # 
    # <p> To achieve laziness the actual work of parsing the available
    # provider-configuration files and instantiating providers must be done by
    # the iterator itself.  Its {@link java.util.Iterator#hasNext hasNext} and
    # {@link java.util.Iterator#next next} methods can therefore throw a
    # {@link ServiceConfigurationError} if a provider-configuration file
    # violates the specified format, or if it names a provider class that
    # cannot be found and instantiated, or if the result of instantiating the
    # class is not assignable to the service type, or if any other kind of
    # exception or error is thrown as the next provider is located and
    # instantiated.  To write robust code it is only necessary to catch {@link
    # ServiceConfigurationError} when using a service iterator.
    # 
    # <p> If such an error is thrown then subsequent invocations of the
    # iterator will make a best effort to locate and instantiate the next
    # available provider, but in general such recovery cannot be guaranteed.
    # 
    # <blockquote style="font-size: smaller; line-height: 1.2"><span
    # style="padding-right: 1em; font-weight: bold">Design Note</span>
    # Throwing an error in these cases may seem extreme.  The rationale for
    # this behavior is that a malformed provider-configuration file, like a
    # malformed class file, indicates a serious problem with the way the Java
    # virtual machine is configured or is being used.  As such it is
    # preferable to throw an error rather than try to recover or, even worse,
    # fail silently.</blockquote>
    # 
    # <p> The iterator returned by this method does not support removal.
    # Invoking its {@link java.util.Iterator#remove() remove} method will
    # cause an {@link UnsupportedOperationException} to be thrown.
    # 
    # @return  An iterator that lazily loads providers for this loader's
    # service
    def iterator
      return Class.new(Iterator.class == Class ? Iterator : Object) do
        extend LocalClass
        include_class_members ServiceLoader
        include Iterator if Iterator.class == Module
        
        attr_accessor :known_providers
        alias_method :attr_known_providers, :known_providers
        undef_method :known_providers
        alias_method :attr_known_providers=, :known_providers=
        undef_method :known_providers=
        
        typesig { [] }
        define_method :has_next do
          if (@known_providers.has_next)
            return true
          end
          return self.attr_lookup_iterator.has_next
        end
        
        typesig { [] }
        define_method :next_ do
          if (@known_providers.has_next)
            return @known_providers.next_.get_value
          end
          return self.attr_lookup_iterator.next_
        end
        
        typesig { [] }
        define_method :remove do
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        define_method :initialize do
          @known_providers = nil
          super()
          @known_providers = self.attr_providers.entry_set.iterator
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    class_module.module_eval {
      typesig { [Class, ClassLoader] }
      # Creates a new service loader for the given service type and class
      # loader.
      # 
      # @param  service
      # The interface or abstract class representing the service
      # 
      # @param  loader
      # The class loader to be used to load provider-configuration files
      # and provider classes, or <tt>null</tt> if the system class
      # loader (or, failing that, the bootstrap class loader) is to be
      # used
      # 
      # @return A new service loader
      def load(service, loader)
        return ServiceLoader.new(service, loader)
      end
      
      typesig { [Class] }
      # Creates a new service loader for the given service type, using the
      # current thread's {@linkplain java.lang.Thread#getContextClassLoader
      # context class loader}.
      # 
      # <p> An invocation of this convenience method of the form
      # 
      # <blockquote><pre>
      # ServiceLoader.load(<i>service</i>)</pre></blockquote>
      # 
      # is equivalent to
      # 
      # <blockquote><pre>
      # ServiceLoader.load(<i>service</i>,
      # Thread.currentThread().getContextClassLoader())</pre></blockquote>
      # 
      # @param  service
      # The interface or abstract class representing the service
      # 
      # @return A new service loader
      def load(service)
        cl = JavaThread.current_thread.get_context_class_loader
        return ServiceLoader.load(service, cl)
      end
      
      typesig { [Class] }
      # Creates a new service loader for the given service type, using the
      # extension class loader.
      # 
      # <p> This convenience method simply locates the extension class loader,
      # call it <tt><i>extClassLoader</i></tt>, and then returns
      # 
      # <blockquote><pre>
      # ServiceLoader.load(<i>service</i>, <i>extClassLoader</i>)</pre></blockquote>
      # 
      # <p> If the extension class loader cannot be found then the system class
      # loader is used; if there is no system class loader then the bootstrap
      # class loader is used.
      # 
      # <p> This method is intended for use when only installed providers are
      # desired.  The resulting service will only find and load providers that
      # have been installed into the current Java virtual machine; providers on
      # the application's class path will be ignored.
      # 
      # @param  service
      # The interface or abstract class representing the service
      # 
      # @return A new service loader
      def load_installed(service)
        cl = ClassLoader.get_system_class_loader
        prev = nil
        while (!(cl).nil?)
          prev = cl
          cl = cl.get_parent
        end
        return ServiceLoader.load(service, prev)
      end
    }
    
    typesig { [] }
    # Returns a string describing this service.
    # 
    # @return  A descriptive string
    def to_s
      return "java.util.ServiceLoader[" + RJava.cast_to_string(@service.get_name) + "]"
    end
    
    private
    alias_method :initialize__service_loader, :initialize
  end
  
end
