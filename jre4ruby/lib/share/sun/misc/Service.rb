require "rjava"

# Copyright 1999-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ServiceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
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
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :TreeSet
    }
  end
  
  # A simple service-provider lookup mechanism.  A <i>service</i> is a
  # well-known set of interfaces and (usually abstract) classes.  A <i>service
  # provider</i> is a specific implementation of a service.  The classes in a
  # provider typically implement the interfaces and subclass the classes defined
  # in the service itself.  Service providers may be installed in an
  # implementation of the Java platform in the form of extensions, that is, jar
  # files placed into any of the usual extension directories.  Providers may
  # also be made available by adding them to the applet or application class
  # path or by some other platform-specific means.
  # 
  # <p> In this lookup mechanism a service is represented by an interface or an
  # abstract class.  (A concrete class may be used, but this is not
  # recommended.)  A provider of a given service contains one or more concrete
  # classes that extend this <i>service class</i> with data and code specific to
  # the provider.  This <i>provider class</i> will typically not be the entire
  # provider itself but rather a proxy that contains enough information to
  # decide whether the provider is able to satisfy a particular request together
  # with code that can create the actual provider on demand.  The details of
  # provider classes tend to be highly service-specific; no single class or
  # interface could possibly unify them, so no such class has been defined.  The
  # only requirement enforced here is that provider classes must have a
  # zero-argument constructor so that they may be instantiated during lookup.
  # 
  # <p> A service provider identifies itself by placing a provider-configuration
  # file in the resource directory <tt>META-INF/services</tt>.  The file's name
  # should consist of the fully-qualified name of the abstract service class.
  # The file should contain a list of fully-qualified concrete provider-class
  # names, one per line.  Space and tab characters surrounding each name, as
  # well as blank lines, are ignored.  The comment character is <tt>'#'</tt>
  # (<tt>0x23</tt>); on each line all characters following the first comment
  # character are ignored.  The file must be encoded in UTF-8.
  # 
  # <p> If a particular concrete provider class is named in more than one
  # configuration file, or is named in the same configuration file more than
  # once, then the duplicates will be ignored.  The configuration file naming a
  # particular provider need not be in the same jar file or other distribution
  # unit as the provider itself.  The provider must be accessible from the same
  # class loader that was initially queried to locate the configuration file;
  # note that this is not necessarily the class loader that found the file.
  # 
  # <p> <b>Example:</b> Suppose we have a service class named
  # <tt>java.io.spi.CharCodec</tt>.  It has two abstract methods:
  # 
  # <pre>
  #   public abstract CharEncoder getEncoder(String encodingName);
  #   public abstract CharDecoder getDecoder(String encodingName);
  # </pre>
  # 
  # Each method returns an appropriate object or <tt>null</tt> if it cannot
  # translate the given encoding.  Typical <tt>CharCodec</tt> providers will
  # support more than one encoding.
  # 
  # <p> If <tt>sun.io.StandardCodec</tt> is a provider of the <tt>CharCodec</tt>
  # service then its jar file would contain the file
  # <tt>META-INF/services/java.io.spi.CharCodec</tt>.  This file would contain
  # the single line:
  # 
  # <pre>
  #   sun.io.StandardCodec    # Standard codecs for the platform
  # </pre>
  # 
  # To locate an encoder for a given encoding name, the internal I/O code would
  # do something like this:
  # 
  # <pre>
  #   CharEncoder getEncoder(String encodingName) {
  #       Iterator ps = Service.providers(CharCodec.class);
  #       while (ps.hasNext()) {
  #           CharCodec cc = (CharCodec)ps.next();
  #           CharEncoder ce = cc.getEncoder(encodingName);
  #           if (ce != null)
  #               return ce;
  #       }
  #       return null;
  #   }
  # </pre>
  # 
  # The provider-lookup mechanism always executes in the security context of the
  # caller.  Trusted system code should typically invoke the methods in this
  # class from within a privileged security context.
  # 
  # @author Mark Reinhold
  # @since 1.3
  class Service 
    include_class_members ServiceImports
    
    class_module.module_eval {
      const_set_lazy(:Prefix) { "META-INF/services/" }
      const_attr_reader  :Prefix
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [Class, String, JavaThrowable] }
      def fail(service, msg, cause)
        sce = ServiceConfigurationError.new(RJava.cast_to_string(service.get_name) + ": " + msg)
        sce.init_cause(cause)
        raise sce
      end
      
      typesig { [Class, String] }
      def fail(service, msg)
        raise ServiceConfigurationError.new(RJava.cast_to_string(service.get_name) + ": " + msg)
      end
      
      typesig { [Class, URL, ::Java::Int, String] }
      def fail(service, u, line, msg)
        fail(service, RJava.cast_to_string(u) + ":" + RJava.cast_to_string(line) + ": " + msg)
      end
      
      typesig { [Class, URL, BufferedReader, ::Java::Int, JavaList, JavaSet] }
      # Parse a single line from the given configuration file, adding the name
      # on the line to both the names list and the returned set iff the name is
      # not already a member of the returned set.
      def parse_line(service, u, r, lc, names, returned)
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
          if (!returned.contains(ln))
            names.add(ln)
            returned.add(ln)
          end
        end
        return lc + 1
      end
      
      typesig { [Class, URL, JavaSet] }
      # Parse the content of the given URL as a provider-configuration file.
      # 
      # @param  service
      #         The service class for which providers are being sought;
      #         used to construct error detail strings
      # 
      # @param  url
      #         The URL naming the configuration file to be parsed
      # 
      # @param  returned
      #         A Set containing the names of provider classes that have already
      #         been returned.  This set will be updated to contain the names
      #         that will be yielded from the returned <tt>Iterator</tt>.
      # 
      # @return A (possibly empty) <tt>Iterator</tt> that will yield the
      #         provider-class names in the given configuration file that are
      #         not yet members of the returned set
      # 
      # @throws ServiceConfigurationError
      #         If an I/O error occurs while reading from the given URL, or
      #         if a configuration-file format error is detected
      def parse(service, u, returned)
        in_ = nil
        r = nil
        names = ArrayList.new
        begin
          in_ = u.open_stream
          r = BufferedReader.new(InputStreamReader.new(in_, "utf-8"))
          lc = 1
          while ((lc = parse_line(service, u, r, lc, names, returned)) >= 0)
          end
        rescue IOException => x
          fail(service, ": " + RJava.cast_to_string(x))
        ensure
          begin
            if (!(r).nil?)
              r.close
            end
            if (!(in_).nil?)
              in_.close
            end
          rescue IOException => y
            fail(service, ": " + RJava.cast_to_string(y))
          end
        end
        return names.iterator
      end
      
      # Private inner class implementing fully-lazy provider lookup
      const_set_lazy(:LazyIterator) { Class.new do
        include_class_members Service
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
        
        attr_accessor :returned
        alias_method :attr_returned, :returned
        undef_method :returned
        alias_method :attr_returned=, :returned=
        undef_method :returned=
        
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
          @returned = self.class::TreeSet.new
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
              full_name = Prefix + RJava.cast_to_string(@service.get_name)
              if ((@loader).nil?)
                @configs = ClassLoader.get_system_resources(full_name)
              else
                @configs = @loader.get_resources(full_name)
              end
            rescue self.class::IOException => x
              fail(@service, ": " + RJava.cast_to_string(x))
            end
          end
          while (((@pending).nil?) || !@pending.has_next)
            if (!@configs.has_more_elements)
              return false
            end
            @pending = parse(@service, @configs.next_element, @returned)
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
            return Class.for_name(cn, true, @loader).new_instance
          rescue self.class::ClassNotFoundException => x
            fail(@service, "Provider " + cn + " not found")
          rescue self.class::JavaException => x
            fail(@service, "Provider " + cn + " could not be instantiated: " + RJava.cast_to_string(x), x)
          end
          return nil # This cannot happen
        end
        
        typesig { [] }
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__lazy_iterator, :initialize
      end }
      
      typesig { [Class, ClassLoader] }
      # Locates and incrementally instantiates the available providers of a
      # given service using the given class loader.
      # 
      # <p> This method transforms the name of the given service class into a
      # provider-configuration filename as described above and then uses the
      # <tt>getResources</tt> method of the given class loader to find all
      # available files with that name.  These files are then read and parsed to
      # produce a list of provider-class names.  The iterator that is returned
      # uses the given class loader to lookup and then instantiate each element
      # of the list.
      # 
      # <p> Because it is possible for extensions to be installed into a running
      # Java virtual machine, this method may return different results each time
      # it is invoked. <p>
      # 
      # @param  service
      #         The service's abstract service class
      # 
      # @param  loader
      #         The class loader to be used to load provider-configuration files
      #         and instantiate provider classes, or <tt>null</tt> if the system
      #         class loader (or, failing that the bootstrap class loader) is to
      #         be used
      # 
      # @return An <tt>Iterator</tt> that yields provider objects for the given
      #         service, in some arbitrary order.  The iterator will throw a
      #         <tt>ServiceConfigurationError</tt> if a provider-configuration
      #         file violates the specified format or if a provider class cannot
      #         be found and instantiated.
      # 
      # @throws ServiceConfigurationError
      #         If a provider-configuration file violates the specified format
      #         or names a provider class that cannot be found and instantiated
      # 
      # @see #providers(java.lang.Class)
      # @see #installedProviders(java.lang.Class)
      def providers(service, loader)
        return LazyIterator.new(service, loader)
      end
      
      typesig { [Class] }
      # Locates and incrementally instantiates the available providers of a
      # given service using the context class loader.  This convenience method
      # is equivalent to
      # 
      # <pre>
      #   ClassLoader cl = Thread.currentThread().getContextClassLoader();
      #   return Service.providers(service, cl);
      # </pre>
      # 
      # @param  service
      #         The service's abstract service class
      # 
      # @return An <tt>Iterator</tt> that yields provider objects for the given
      #         service, in some arbitrary order.  The iterator will throw a
      #         <tt>ServiceConfigurationError</tt> if a provider-configuration
      #         file violates the specified format or if a provider class cannot
      #         be found and instantiated.
      # 
      # @throws ServiceConfigurationError
      #         If a provider-configuration file violates the specified format
      #         or names a provider class that cannot be found and instantiated
      # 
      # @see #providers(java.lang.Class, java.lang.ClassLoader)
      def providers(service)
        cl = JavaThread.current_thread.get_context_class_loader
        return Service.providers(service, cl)
      end
      
      typesig { [Class] }
      # Locates and incrementally instantiates the available providers of a
      # given service using the extension class loader.  This convenience method
      # simply locates the extension class loader, call it
      # <tt>extClassLoader</tt>, and then does
      # 
      # <pre>
      #   return Service.providers(service, extClassLoader);
      # </pre>
      # 
      # If the extension class loader cannot be found then the system class
      # loader is used; if there is no system class loader then the bootstrap
      # class loader is used.
      # 
      # @param  service
      #         The service's abstract service class
      # 
      # @return An <tt>Iterator</tt> that yields provider objects for the given
      #         service, in some arbitrary order.  The iterator will throw a
      #         <tt>ServiceConfigurationError</tt> if a provider-configuration
      #         file violates the specified format or if a provider class cannot
      #         be found and instantiated.
      # 
      # @throws ServiceConfigurationError
      #         If a provider-configuration file violates the specified format
      #         or names a provider class that cannot be found and instantiated
      # 
      # @see #providers(java.lang.Class, java.lang.ClassLoader)
      def installed_providers(service)
        cl = ClassLoader.get_system_class_loader
        prev = nil
        while (!(cl).nil?)
          prev = cl
          cl = cl.get_parent
        end
        return Service.providers(service, prev)
      end
    }
    
    private
    alias_method :initialize__service, :initialize
  end
  
end
