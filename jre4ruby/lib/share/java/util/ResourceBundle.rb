require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1999 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Util
  module ResourceBundleImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Lang::Ref, :ReferenceQueue
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Lang::Ref, :WeakReference
      include_const ::Java::Net, :JarURLConnection
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Concurrent, :ConcurrentMap
      include_const ::Java::Util::Jar, :JarEntry
    }
  end
  
  # Resource bundles contain locale-specific objects.
  # When your program needs a locale-specific resource,
  # a <code>String</code> for example, your program can load it
  # from the resource bundle that is appropriate for the
  # current user's locale. In this way, you can write
  # program code that is largely independent of the user's
  # locale isolating most, if not all, of the locale-specific
  # information in resource bundles.
  # 
  # <p>
  # This allows you to write programs that can:
  # <UL type=SQUARE>
  # <LI> be easily localized, or translated, into different languages
  # <LI> handle multiple locales at once
  # <LI> be easily modified later to support even more locales
  # </UL>
  # 
  # <P>
  # Resource bundles belong to families whose members share a common base
  # name, but whose names also have additional components that identify
  # their locales. For example, the base name of a family of resource
  # bundles might be "MyResources". The family should have a default
  # resource bundle which simply has the same name as its family -
  # "MyResources" - and will be used as the bundle of last resort if a
  # specific locale is not supported. The family can then provide as
  # many locale-specific members as needed, for example a German one
  # named "MyResources_de".
  # 
  # <P>
  # Each resource bundle in a family contains the same items, but the items have
  # been translated for the locale represented by that resource bundle.
  # For example, both "MyResources" and "MyResources_de" may have a
  # <code>String</code> that's used on a button for canceling operations.
  # In "MyResources" the <code>String</code> may contain "Cancel" and in
  # "MyResources_de" it may contain "Abbrechen".
  # 
  # <P>
  # If there are different resources for different countries, you
  # can make specializations: for example, "MyResources_de_CH" contains objects for
  # the German language (de) in Switzerland (CH). If you want to only
  # modify some of the resources
  # in the specialization, you can do so.
  # 
  # <P>
  # When your program needs a locale-specific object, it loads
  # the <code>ResourceBundle</code> class using the
  # {@link #getBundle(java.lang.String, java.util.Locale) getBundle}
  # method:
  # <blockquote>
  # <pre>
  # ResourceBundle myResources =
  # ResourceBundle.getBundle("MyResources", currentLocale);
  # </pre>
  # </blockquote>
  # 
  # <P>
  # Resource bundles contain key/value pairs. The keys uniquely
  # identify a locale-specific object in the bundle. Here's an
  # example of a <code>ListResourceBundle</code> that contains
  # two key/value pairs:
  # <blockquote>
  # <pre>
  # public class MyResources extends ListResourceBundle {
  # protected Object[][] getContents() {
  # return new Object[][] {
  # // LOCALIZE THE SECOND STRING OF EACH ARRAY (e.g., "OK")
  # {"OkKey", "OK"},
  # {"CancelKey", "Cancel"},
  # // END OF MATERIAL TO LOCALIZE
  # };
  # }
  # }
  # </pre>
  # </blockquote>
  # Keys are always <code>String</code>s.
  # In this example, the keys are "OkKey" and "CancelKey".
  # In the above example, the values
  # are also <code>String</code>s--"OK" and "Cancel"--but
  # they don't have to be. The values can be any type of object.
  # 
  # <P>
  # You retrieve an object from resource bundle using the appropriate
  # getter method. Because "OkKey" and "CancelKey"
  # are both strings, you would use <code>getString</code> to retrieve them:
  # <blockquote>
  # <pre>
  # button1 = new Button(myResources.getString("OkKey"));
  # button2 = new Button(myResources.getString("CancelKey"));
  # </pre>
  # </blockquote>
  # The getter methods all require the key as an argument and return
  # the object if found. If the object is not found, the getter method
  # throws a <code>MissingResourceException</code>.
  # 
  # <P>
  # Besides <code>getString</code>, <code>ResourceBundle</code> also provides
  # a method for getting string arrays, <code>getStringArray</code>,
  # as well as a generic <code>getObject</code> method for any other
  # type of object. When using <code>getObject</code>, you'll
  # have to cast the result to the appropriate type. For example:
  # <blockquote>
  # <pre>
  # int[] myIntegers = (int[]) myResources.getObject("intList");
  # </pre>
  # </blockquote>
  # 
  # <P>
  # The Java Platform provides two subclasses of <code>ResourceBundle</code>,
  # <code>ListResourceBundle</code> and <code>PropertyResourceBundle</code>,
  # that provide a fairly simple way to create resources.
  # As you saw briefly in a previous example, <code>ListResourceBundle</code>
  # manages its resource as a list of key/value pairs.
  # <code>PropertyResourceBundle</code> uses a properties file to manage
  # its resources.
  # 
  # <p>
  # If <code>ListResourceBundle</code> or <code>PropertyResourceBundle</code>
  # do not suit your needs, you can write your own <code>ResourceBundle</code>
  # subclass.  Your subclasses must override two methods: <code>handleGetObject</code>
  # and <code>getKeys()</code>.
  # 
  # <h4>ResourceBundle.Control</h4>
  # 
  # The {@link ResourceBundle.Control} class provides information necessary
  # to perform the bundle loading process by the <code>getBundle</code>
  # factory methods that take a <code>ResourceBundle.Control</code>
  # instance. You can implement your own subclass in order to enable
  # non-standard resource bundle formats, change the search strategy, or
  # define caching parameters. Refer to the descriptions of the class and the
  # {@link #getBundle(String, Locale, ClassLoader, Control) getBundle}
  # factory method for details.
  # 
  # <h4>Cache Management</h4>
  # 
  # Resource bundle instances created by the <code>getBundle</code> factory
  # methods are cached by default, and the factory methods return the same
  # resource bundle instance multiple times if it has been
  # cached. <code>getBundle</code> clients may clear the cache, manage the
  # lifetime of cached resource bundle instances using time-to-live values,
  # or specify not to cache resource bundle instances. Refer to the
  # descriptions of the {@linkplain #getBundle(String, Locale, ClassLoader,
  # Control) <code>getBundle</code> factory method}, {@link
  # #clearCache(ClassLoader) clearCache}, {@link
  # Control#getTimeToLive(String, Locale)
  # ResourceBundle.Control.getTimeToLive}, and {@link
  # Control#needsReload(String, Locale, String, ClassLoader, ResourceBundle,
  # long) ResourceBundle.Control.needsReload} for details.
  # 
  # <h4>Example</h4>
  # 
  # The following is a very simple example of a <code>ResourceBundle</code>
  # subclass, <code>MyResources</code>, that manages two resources (for a larger number of
  # resources you would probably use a <code>Map</code>).
  # Notice that you don't need to supply a value if
  # a "parent-level" <code>ResourceBundle</code> handles the same
  # key with the same value (as for the okKey below).
  # <blockquote>
  # <pre>
  # // default (English language, United States)
  # public class MyResources extends ResourceBundle {
  # public Object handleGetObject(String key) {
  # if (key.equals("okKey")) return "Ok";
  # if (key.equals("cancelKey")) return "Cancel";
  # return null;
  # }
  # 
  # public Enumeration&lt;String&gt; getKeys() {
  # return Collections.enumeration(keySet());
  # }
  # 
  # // Overrides handleKeySet() so that the getKeys() implementation
  # // can rely on the keySet() value.
  # protected Set&lt;String&gt; handleKeySet() {
  # return new HashSet&lt;String&gt;(Arrays.asList("okKey", "cancelKey"));
  # }
  # }
  # 
  # // German language
  # public class MyResources_de extends MyResources {
  # public Object handleGetObject(String key) {
  # // don't need okKey, since parent level handles it.
  # if (key.equals("cancelKey")) return "Abbrechen";
  # return null;
  # }
  # 
  # protected Set&lt;String&gt; handleKeySet() {
  # return new HashSet&lt;String&gt;(Arrays.asList("cancelKey"));
  # }
  # }
  # </pre>
  # </blockquote>
  # You do not have to restrict yourself to using a single family of
  # <code>ResourceBundle</code>s. For example, you could have a set of bundles for
  # exception messages, <code>ExceptionResources</code>
  # (<code>ExceptionResources_fr</code>, <code>ExceptionResources_de</code>, ...),
  # and one for widgets, <code>WidgetResource</code> (<code>WidgetResources_fr</code>,
  # <code>WidgetResources_de</code>, ...); breaking up the resources however you like.
  # 
  # @see ListResourceBundle
  # @see PropertyResourceBundle
  # @see MissingResourceException
  # @since JDK1.1
  class ResourceBundle 
    include_class_members ResourceBundleImports
    
    class_module.module_eval {
      # initial size of the bundle cache
      const_set_lazy(:INITIAL_CACHE_SIZE) { 32 }
      const_attr_reader  :INITIAL_CACHE_SIZE
      
      const_set_lazy(:NONEXISTENT_BUNDLE) { # constant indicating that no resource bundle exists
      Class.new(ResourceBundle.class == Class ? ResourceBundle : Object) do
        extend LocalClass
        include_class_members ResourceBundle
        include ResourceBundle if ResourceBundle.class == Module
        
        typesig { [] }
        define_method :get_keys do
          return nil
        end
        
        typesig { [String] }
        define_method :handle_get_object do |key|
          return nil
        end
        
        typesig { [] }
        define_method :to_s do
          return "NONEXISTENT_BUNDLE"
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :NONEXISTENT_BUNDLE
      
      # The cache is a map from cache keys (with bundle base name, locale, and
      # class loader) to either a resource bundle or NONEXISTENT_BUNDLE wrapped by a
      # BundleReference.
      # 
      # The cache is a ConcurrentMap, allowing the cache to be searched
      # concurrently by multiple threads.  This will also allow the cache keys
      # to be reclaimed along with the ClassLoaders they reference.
      # 
      # This variable would be better named "cache", but we keep the old
      # name for compatibility with some workarounds for bug 4212439.
      const_set_lazy(:CacheList) { ConcurrentHashMap.new(INITIAL_CACHE_SIZE) }
      const_attr_reader  :CacheList
      
      # This ConcurrentMap is used to keep multiple threads from loading the
      # same bundle concurrently.  The table entries are <CacheKey, Thread>
      # where CacheKey is the key for the bundle that is under construction
      # and Thread is the thread that is constructing the bundle.
      # This list is manipulated in findBundleInCache and putBundleInCache.
      const_set_lazy(:UnderConstruction) { ConcurrentHashMap.new }
      const_attr_reader  :UnderConstruction
      
      # Queue for reference objects referring to class loaders or bundles.
      const_set_lazy(:ReferenceQueue) { ReferenceQueue.new }
      const_attr_reader  :ReferenceQueue
    }
    
    # The parent bundle of this bundle.
    # The parent bundle is searched by {@link #getObject getObject}
    # when this bundle does not contain a particular resource.
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    # The locale for this bundle.
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    # The base bundle name for this bundle.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # The flag indicating this bundle has expired in the cache.
    attr_accessor :expired
    alias_method :attr_expired, :expired
    undef_method :expired
    alias_method :attr_expired=, :expired=
    undef_method :expired=
    
    # The back link to the cache key. null if this bundle isn't in
    # the cache (yet) or has expired.
    attr_accessor :cache_key
    alias_method :attr_cache_key, :cache_key
    undef_method :cache_key
    alias_method :attr_cache_key=, :cache_key=
    undef_method :cache_key=
    
    # A Set of the keys contained only in this ResourceBundle.
    attr_accessor :key_set
    alias_method :attr_key_set, :key_set
    undef_method :key_set
    alias_method :attr_key_set=, :key_set=
    undef_method :key_set=
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      @parent = nil
      @locale = nil
      @name = nil
      @expired = false
      @cache_key = nil
      @key_set = nil
    end
    
    typesig { [String] }
    # Gets a string for the given key from this resource bundle or one of its parents.
    # Calling this method is equivalent to calling
    # <blockquote>
    # <code>(String) {@link #getObject(java.lang.String) getObject}(key)</code>.
    # </blockquote>
    # 
    # @param key the key for the desired string
    # @exception NullPointerException if <code>key</code> is <code>null</code>
    # @exception MissingResourceException if no object for the given key can be found
    # @exception ClassCastException if the object found for the given key is not a string
    # @return the string for the given key
    def get_string(key)
      return get_object(key)
    end
    
    typesig { [String] }
    # Gets a string array for the given key from this resource bundle or one of its parents.
    # Calling this method is equivalent to calling
    # <blockquote>
    # <code>(String[]) {@link #getObject(java.lang.String) getObject}(key)</code>.
    # </blockquote>
    # 
    # @param key the key for the desired string array
    # @exception NullPointerException if <code>key</code> is <code>null</code>
    # @exception MissingResourceException if no object for the given key can be found
    # @exception ClassCastException if the object found for the given key is not a string array
    # @return the string array for the given key
    def get_string_array(key)
      return get_object(key)
    end
    
    typesig { [String] }
    # Gets an object for the given key from this resource bundle or one of its parents.
    # This method first tries to obtain the object from this resource bundle using
    # {@link #handleGetObject(java.lang.String) handleGetObject}.
    # If not successful, and the parent resource bundle is not null,
    # it calls the parent's <code>getObject</code> method.
    # If still not successful, it throws a MissingResourceException.
    # 
    # @param key the key for the desired object
    # @exception NullPointerException if <code>key</code> is <code>null</code>
    # @exception MissingResourceException if no object for the given key can be found
    # @return the object for the given key
    def get_object(key)
      obj = handle_get_object(key)
      if ((obj).nil?)
        if (!(@parent).nil?)
          obj = @parent.get_object(key)
        end
        if ((obj).nil?)
          raise MissingResourceException.new("Can't find resource for bundle " + RJava.cast_to_string(self.get_class.get_name) + ", key " + key, self.get_class.get_name, key)
        end
      end
      return obj
    end
    
    typesig { [] }
    # Returns the locale of this resource bundle. This method can be used after a
    # call to getBundle() to determine whether the resource bundle returned really
    # corresponds to the requested locale or is a fallback.
    # 
    # @return the locale of this resource bundle
    def get_locale
      return @locale
    end
    
    class_module.module_eval {
      typesig { [] }
      # Automatic determination of the ClassLoader to be used to load
      # resources on behalf of the client.  N.B. The client is getLoader's
      # caller's caller.
      def get_loader
        stack = get_class_context
        # Magic number 2 identifies our caller's caller
        c = stack[2]
        cl = ((c).nil?) ? nil : c.get_class_loader
        if ((cl).nil?)
          # When the caller's loader is the boot class loader, cl is null
          # here. In that case, ClassLoader.getSystemClassLoader() may
          # return the same class loader that the application is
          # using. We therefore use a wrapper ClassLoader to create a
          # separate scope for bundles loaded on behalf of the Java
          # runtime so that these bundles cannot be returned from the
          # cache to the application (5048280).
          cl = RBClassLoader::INSTANCE
        end
        return cl
      end
      
      JNI.native_method :Java_java_util_ResourceBundle_getClassContext, [:pointer, :long], :long
      typesig { [] }
      def get_class_context
        JNI.__send__(:Java_java_util_ResourceBundle_getClassContext, JNI.env, self.jni_id)
      end
      
      # A wrapper of ClassLoader.getSystemClassLoader().
      const_set_lazy(:RBClassLoader) { Class.new(ClassLoader) do
        include_class_members ResourceBundle
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { AccessController.do_privileged(Class.new(self.class::PrivilegedAction.class == Class ? self.class::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members RBClassLoader
            include self::PrivilegedAction if self::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return self.class::RBClassLoader.new
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)) }
          const_attr_reader  :INSTANCE
          
          const_set_lazy(:Loader) { ClassLoader.get_system_class_loader }
          const_attr_reader  :Loader
        }
        
        typesig { [] }
        def initialize
          super()
        end
        
        typesig { [self::String] }
        def load_class(name)
          if (!(self.class::Loader).nil?)
            return self.class::Loader.load_class(name)
          end
          return Class.for_name(name)
        end
        
        typesig { [self::String] }
        def get_resource(name)
          if (!(self.class::Loader).nil?)
            return self.class::Loader.get_resource(name)
          end
          return ClassLoader.get_system_resource(name)
        end
        
        typesig { [self::String] }
        def get_resource_as_stream(name)
          if (!(self.class::Loader).nil?)
            return self.class::Loader.get_resource_as_stream(name)
          end
          return ClassLoader.get_system_resource_as_stream(name)
        end
        
        private
        alias_method :initialize__rbclass_loader, :initialize
      end }
    }
    
    typesig { [ResourceBundle] }
    # Sets the parent bundle of this bundle.
    # The parent bundle is searched by {@link #getObject getObject}
    # when this bundle does not contain a particular resource.
    # 
    # @param parent this bundle's parent bundle.
    def set_parent(parent)
      raise AssertError if not (!(parent).equal?(NONEXISTENT_BUNDLE))
      @parent = parent
    end
    
    class_module.module_eval {
      # Key used for cached resource bundles.  The key checks the base
      # name, the locale, and the class loader to determine if the
      # resource is a match to the requested one. The loader may be
      # null, but the base name and the locale must have a non-null
      # value.
      const_set_lazy(:CacheKey) { Class.new do
        include_class_members ResourceBundle
        include Cloneable
        
        # These three are the actual keys for lookup in Map.
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :locale
        alias_method :attr_locale, :locale
        undef_method :locale
        alias_method :attr_locale=, :locale=
        undef_method :locale=
        
        attr_accessor :loader_ref
        alias_method :attr_loader_ref, :loader_ref
        undef_method :loader_ref
        alias_method :attr_loader_ref=, :loader_ref=
        undef_method :loader_ref=
        
        # bundle format which is necessary for calling
        # Control.needsReload().
        attr_accessor :format
        alias_method :attr_format, :format
        undef_method :format
        alias_method :attr_format=, :format=
        undef_method :format=
        
        # These time values are in CacheKey so that NONEXISTENT_BUNDLE
        # doesn't need to be cloned for caching.
        # The time when the bundle has been loaded
        attr_accessor :load_time
        alias_method :attr_load_time, :load_time
        undef_method :load_time
        alias_method :attr_load_time=, :load_time=
        undef_method :load_time=
        
        # The time when the bundle expires in the cache, or either
        # Control.TTL_DONT_CACHE or Control.TTL_NO_EXPIRATION_CONTROL.
        attr_accessor :expiration_time
        alias_method :attr_expiration_time, :expiration_time
        undef_method :expiration_time
        alias_method :attr_expiration_time=, :expiration_time=
        undef_method :expiration_time=
        
        # Placeholder for an error report by a Throwable
        attr_accessor :cause
        alias_method :attr_cause, :cause
        undef_method :cause
        alias_method :attr_cause=, :cause=
        undef_method :cause=
        
        # Hash code value cache to avoid recalculating the hash code
        # of this instance.
        attr_accessor :hash_code_cache
        alias_method :attr_hash_code_cache, :hash_code_cache
        undef_method :hash_code_cache
        alias_method :attr_hash_code_cache=, :hash_code_cache=
        undef_method :hash_code_cache=
        
        typesig { [self::String, self::Locale, self::ClassLoader] }
        def initialize(base_name, locale, loader)
          @name = nil
          @locale = nil
          @loader_ref = nil
          @format = nil
          @load_time = 0
          @expiration_time = 0
          @cause = nil
          @hash_code_cache = 0
          @name = base_name
          @locale = locale
          if ((loader).nil?)
            @loader_ref = nil
          else
            @loader_ref = self.class::LoaderReference.new(loader, ReferenceQueue, self)
          end
          calculate_hash_code
        end
        
        typesig { [] }
        def get_name
          return @name
        end
        
        typesig { [self::String] }
        def set_name(base_name)
          if (!(@name == base_name))
            @name = base_name
            calculate_hash_code
          end
          return self
        end
        
        typesig { [] }
        def get_locale
          return @locale
        end
        
        typesig { [self::Locale] }
        def set_locale(locale)
          if (!(@locale == locale))
            @locale = locale
            calculate_hash_code
          end
          return self
        end
        
        typesig { [] }
        def get_loader
          return (!(@loader_ref).nil?) ? @loader_ref.get : nil
        end
        
        typesig { [Object] }
        def ==(other)
          if ((self).equal?(other))
            return true
          end
          begin
            other_entry = other
            # quick check to see if they are not equal
            if (!(@hash_code_cache).equal?(other_entry.attr_hash_code_cache))
              return false
            end
            # are the names the same?
            if (!(@name == other_entry.attr_name))
              return false
            end
            # are the locales the same?
            if (!(@locale == other_entry.attr_locale))
              return false
            end
            # are refs (both non-null) or (both null)?
            if ((@loader_ref).nil?)
              return (other_entry.attr_loader_ref).nil?
            end
            loader = @loader_ref.get
            # with a null reference we can no longer find
            # out which class loader was referenced; so
            # treat it as unequal
            return (!(other_entry.attr_loader_ref).nil?) && (!(loader).nil?) && ((loader).equal?(other_entry.attr_loader_ref.get))
          rescue self.class::NullPointerException => e
          rescue self.class::ClassCastException => e
          end
          return false
        end
        
        typesig { [] }
        def hash_code
          return @hash_code_cache
        end
        
        typesig { [] }
        def calculate_hash_code
          @hash_code_cache = @name.hash_code << 3
          @hash_code_cache ^= @locale.hash_code
          loader = get_loader
          if (!(loader).nil?)
            @hash_code_cache ^= loader.hash_code
          end
        end
        
        typesig { [] }
        def clone
          begin
            clone = super
            if (!(@loader_ref).nil?)
              clone.attr_loader_ref = self.class::LoaderReference.new(@loader_ref.get, ReferenceQueue, clone)
            end
            # Clear the reference to a Throwable
            clone.attr_cause = nil
            return clone
          rescue self.class::CloneNotSupportedException => e
            # this should never happen
            raise self.class::InternalError.new
          end
        end
        
        typesig { [] }
        def get_format
          return @format
        end
        
        typesig { [self::String] }
        def set_format(format)
          @format = format
        end
        
        typesig { [self::JavaThrowable] }
        def set_cause(cause)
          if ((@cause).nil?)
            @cause = cause
          else
            # Override the cause if the previous one is
            # ClassNotFoundException.
            if (@cause.is_a?(self.class::ClassNotFoundException))
              @cause = cause
            end
          end
        end
        
        typesig { [] }
        def get_cause
          return @cause
        end
        
        typesig { [] }
        def to_s
          l = @locale.to_s
          if ((l.length).equal?(0))
            if (!(@locale.get_variant.length).equal?(0))
              l = "__" + RJava.cast_to_string(@locale.get_variant)
            else
              l = "\"\""
            end
          end
          return "CacheKey[" + @name + ", lc=" + l + ", ldr=" + RJava.cast_to_string(get_loader) + "(format=" + @format + ")]"
        end
        
        private
        alias_method :initialize__cache_key, :initialize
      end }
      
      # The common interface to get a CacheKey in LoaderReference and
      # BundleReference.
      const_set_lazy(:CacheKeyReference) { Module.new do
        include_class_members ResourceBundle
        
        typesig { [] }
        def get_cache_key
          raise NotImplementedError
        end
      end }
      
      # References to class loaders are weak references, so that they can be
      # garbage collected when nobody else is using them. The ResourceBundle
      # class has no reason to keep class loaders alive.
      const_set_lazy(:LoaderReference) { Class.new(WeakReference) do
        include_class_members ResourceBundle
        overload_protected {
          include CacheKeyReference
        }
        
        attr_accessor :cache_key
        alias_method :attr_cache_key, :cache_key
        undef_method :cache_key
        alias_method :attr_cache_key=, :cache_key=
        undef_method :cache_key=
        
        typesig { [self::ClassLoader, self::ReferenceQueue, self::CacheKey] }
        def initialize(referent, q, key)
          @cache_key = nil
          super(referent, q)
          @cache_key = key
        end
        
        typesig { [] }
        def get_cache_key
          return @cache_key
        end
        
        private
        alias_method :initialize__loader_reference, :initialize
      end }
      
      # References to bundles are soft references so that they can be garbage
      # collected when they have no hard references.
      const_set_lazy(:BundleReference) { Class.new(SoftReference) do
        include_class_members ResourceBundle
        overload_protected {
          include CacheKeyReference
        }
        
        attr_accessor :cache_key
        alias_method :attr_cache_key, :cache_key
        undef_method :cache_key
        alias_method :attr_cache_key=, :cache_key=
        undef_method :cache_key=
        
        typesig { [self::ResourceBundle, self::ReferenceQueue, self::CacheKey] }
        def initialize(referent, q, key)
          @cache_key = nil
          super(referent, q)
          @cache_key = key
        end
        
        typesig { [] }
        def get_cache_key
          return @cache_key
        end
        
        private
        alias_method :initialize__bundle_reference, :initialize
      end }
      
      typesig { [String] }
      # Gets a resource bundle using the specified base name, the default locale,
      # and the caller's class loader. Calling this method is equivalent to calling
      # <blockquote>
      # <code>getBundle(baseName, Locale.getDefault(), this.getClass().getClassLoader())</code>,
      # </blockquote>
      # except that <code>getClassLoader()</code> is run with the security
      # privileges of <code>ResourceBundle</code>.
      # See {@link #getBundle(String, Locale, ClassLoader) getBundle}
      # for a complete description of the search and instantiation strategy.
      # 
      # @param baseName the base name of the resource bundle, a fully qualified class name
      # @exception java.lang.NullPointerException
      # if <code>baseName</code> is <code>null</code>
      # @exception MissingResourceException
      # if no resource bundle for the specified base name can be found
      # @return a resource bundle for the given base name and the default locale
      def get_bundle(base_name)
        # must determine loader here, else we break stack invariant
        return get_bundle_impl(base_name, Locale.get_default, get_loader, Control::INSTANCE)
      end
      
      typesig { [String, Control] }
      # Returns a resource bundle using the specified base name, the
      # default locale and the specified control. Calling this method
      # is equivalent to calling
      # <pre>
      # getBundle(baseName, Locale.getDefault(),
      # this.getClass().getClassLoader(), control),
      # </pre>
      # except that <code>getClassLoader()</code> is run with the security
      # privileges of <code>ResourceBundle</code>.  See {@link
      # #getBundle(String, Locale, ClassLoader, Control) getBundle} for the
      # complete description of the resource bundle loading process with a
      # <code>ResourceBundle.Control</code>.
      # 
      # @param baseName
      # the base name of the resource bundle, a fully qualified class
      # name
      # @param control
      # the control which gives information for the resource bundle
      # loading process
      # @return a resource bundle for the given base name and the default
      # locale
      # @exception NullPointerException
      # if <code>baseName</code> or <code>control</code> is
      # <code>null</code>
      # @exception MissingResourceException
      # if no resource bundle for the specified base name can be found
      # @exception IllegalArgumentException
      # if the given <code>control</code> doesn't perform properly
      # (e.g., <code>control.getCandidateLocales</code> returns null.)
      # Note that validation of <code>control</code> is performed as
      # needed.
      # @since 1.6
      def get_bundle(base_name, control)
        # must determine loader here, else we break stack invariant
        return get_bundle_impl(base_name, Locale.get_default, get_loader, control)
      end
      
      typesig { [String, Locale] }
      # Gets a resource bundle using the specified base name and locale,
      # and the caller's class loader. Calling this method is equivalent to calling
      # <blockquote>
      # <code>getBundle(baseName, locale, this.getClass().getClassLoader())</code>,
      # </blockquote>
      # except that <code>getClassLoader()</code> is run with the security
      # privileges of <code>ResourceBundle</code>.
      # See {@link #getBundle(String, Locale, ClassLoader) getBundle}
      # for a complete description of the search and instantiation strategy.
      # 
      # @param baseName
      # the base name of the resource bundle, a fully qualified class name
      # @param locale
      # the locale for which a resource bundle is desired
      # @exception NullPointerException
      # if <code>baseName</code> or <code>locale</code> is <code>null</code>
      # @exception MissingResourceException
      # if no resource bundle for the specified base name can be found
      # @return a resource bundle for the given base name and locale
      def get_bundle(base_name, locale)
        # must determine loader here, else we break stack invariant
        return get_bundle_impl(base_name, locale, get_loader, Control::INSTANCE)
      end
      
      typesig { [String, Locale, Control] }
      # Returns a resource bundle using the specified base name, target
      # locale and control, and the caller's class loader. Calling this
      # method is equivalent to calling
      # <pre>
      # getBundle(baseName, targetLocale, this.getClass().getClassLoader(),
      # control),
      # </pre>
      # except that <code>getClassLoader()</code> is run with the security
      # privileges of <code>ResourceBundle</code>.  See {@link
      # #getBundle(String, Locale, ClassLoader, Control) getBundle} for the
      # complete description of the resource bundle loading process with a
      # <code>ResourceBundle.Control</code>.
      # 
      # @param baseName
      # the base name of the resource bundle, a fully qualified
      # class name
      # @param targetLocale
      # the locale for which a resource bundle is desired
      # @param control
      # the control which gives information for the resource
      # bundle loading process
      # @return a resource bundle for the given base name and a
      # <code>Locale</code> in <code>locales</code>
      # @exception NullPointerException
      # if <code>baseName</code>, <code>locales</code> or
      # <code>control</code> is <code>null</code>
      # @exception MissingResourceException
      # if no resource bundle for the specified base name in any
      # of the <code>locales</code> can be found.
      # @exception IllegalArgumentException
      # if the given <code>control</code> doesn't perform properly
      # (e.g., <code>control.getCandidateLocales</code> returns null.)
      # Note that validation of <code>control</code> is performed as
      # needed.
      # @since 1.6
      def get_bundle(base_name, target_locale, control)
        # must determine loader here, else we break stack invariant
        return get_bundle_impl(base_name, target_locale, get_loader, control)
      end
      
      typesig { [String, Locale, ClassLoader] }
      # Gets a resource bundle using the specified base name, locale, and class loader.
      # 
      # <p><a name="default_behavior"/>
      # Conceptually, <code>getBundle</code> uses the following strategy for locating and instantiating
      # resource bundles:
      # <p>
      # <code>getBundle</code> uses the base name, the specified locale, and the default
      # locale (obtained from {@link java.util.Locale#getDefault() Locale.getDefault})
      # to generate a sequence of <a name="candidates"><em>candidate bundle names</em></a>.
      # If the specified locale's language, country, and variant are all empty
      # strings, then the base name is the only candidate bundle name.
      # Otherwise, the following sequence is generated from the attribute
      # values of the specified locale (language1, country1, and variant1)
      # and of the default locale (language2, country2, and variant2):
      # <ul>
      # <li> baseName + "_" + language1 + "_" + country1 + "_" + variant1
      # <li> baseName + "_" + language1 + "_" + country1
      # <li> baseName + "_" + language1
      # <li> baseName + "_" + language2 + "_" + country2 + "_" + variant2
      # <li> baseName + "_" + language2 + "_" + country2
      # <li> baseName + "_" + language2
      # <li> baseName
      # </ul>
      # <p>
      # Candidate bundle names where the final component is an empty string are omitted.
      # For example, if country1 is an empty string, the second candidate bundle name is omitted.
      # 
      # <p>
      # <code>getBundle</code> then iterates over the candidate bundle names to find the first
      # one for which it can <em>instantiate</em> an actual resource bundle. For each candidate
      # bundle name, it attempts to create a resource bundle:
      # <ul>
      # <li>
      # First, it attempts to load a class using the candidate bundle name.
      # If such a class can be found and loaded using the specified class loader, is assignment
      # compatible with ResourceBundle, is accessible from ResourceBundle, and can be instantiated,
      # <code>getBundle</code> creates a new instance of this class and uses it as the <em>result
      # resource bundle</em>.
      # <li>
      # Otherwise, <code>getBundle</code> attempts to locate a property resource file.
      # It generates a path name from the candidate bundle name by replacing all "." characters
      # with "/" and appending the string ".properties".
      # It attempts to find a "resource" with this name using
      # {@link java.lang.ClassLoader#getResource(java.lang.String) ClassLoader.getResource}.
      # (Note that a "resource" in the sense of <code>getResource</code> has nothing to do with
      # the contents of a resource bundle, it is just a container of data, such as a file.)
      # If it finds a "resource", it attempts to create a new
      # {@link PropertyResourceBundle} instance from its contents.
      # If successful, this instance becomes the <em>result resource bundle</em>.
      # </ul>
      # 
      # <p>
      # If no result resource bundle has been found, a <code>MissingResourceException</code>
      # is thrown.
      # 
      # <p><a name="parent_chain"/>
      # Once a result resource bundle has been found, its <em>parent chain</em> is instantiated.
      # <code>getBundle</code> iterates over the candidate bundle names that can be
      # obtained by successively removing variant, country, and language
      # (each time with the preceding "_") from the bundle name of the result resource bundle.
      # As above, candidate bundle names where the final component is an empty string are omitted.
      # With each of the candidate bundle names it attempts to instantiate a resource bundle, as
      # described above.
      # Whenever it succeeds, it calls the previously instantiated resource
      # bundle's {@link #setParent(java.util.ResourceBundle) setParent} method
      # with the new resource bundle, unless the previously instantiated resource
      # bundle already has a non-null parent.
      # 
      # <p>
      # <code>getBundle</code> caches instantiated resource bundles and
      # may return the same resource bundle instance multiple
      # times.
      # 
      # <p>
      # The <code>baseName</code> argument should be a fully qualified class name. However, for
      # compatibility with earlier versions, Sun's Java SE Runtime Environments do not verify this,
      # and so it is possible to access <code>PropertyResourceBundle</code>s by specifying a
      # path name (using "/") instead of a fully qualified class name (using ".").
      # 
      # <p><a name="default_behavior_example"/>
      # <strong>Example:</strong><br>The following class and property files are provided:
      # <pre>
      # MyResources.class
      # MyResources.properties
      # MyResources_fr.properties
      # MyResources_fr_CH.class
      # MyResources_fr_CH.properties
      # MyResources_en.properties
      # MyResources_es_ES.class
      # </pre>
      # The contents of all files are valid (that is, public non-abstract subclasses of <code>ResourceBundle</code> for
      # the ".class" files, syntactically correct ".properties" files).
      # The default locale is <code>Locale("en", "GB")</code>.
      # <p>
      # Calling <code>getBundle</code> with the shown locale argument values instantiates
      # resource bundles from the following sources:
      # <ul>
      # <li>Locale("fr", "CH"): result MyResources_fr_CH.class, parent MyResources_fr.properties, parent MyResources.class
      # <li>Locale("fr", "FR"): result MyResources_fr.properties, parent MyResources.class
      # <li>Locale("de", "DE"): result MyResources_en.properties, parent MyResources.class
      # <li>Locale("en", "US"): result MyResources_en.properties, parent MyResources.class
      # <li>Locale("es", "ES"): result MyResources_es_ES.class, parent MyResources.class
      # </ul>
      # <p>The file MyResources_fr_CH.properties is never used because it is hidden by
      # MyResources_fr_CH.class. Likewise, MyResources.properties is also hidden by
      # MyResources.class.
      # 
      # @param baseName the base name of the resource bundle, a fully qualified class name
      # @param locale the locale for which a resource bundle is desired
      # @param loader the class loader from which to load the resource bundle
      # @return a resource bundle for the given base name and locale
      # @exception java.lang.NullPointerException
      # if <code>baseName</code>, <code>locale</code>, or <code>loader</code> is <code>null</code>
      # @exception MissingResourceException
      # if no resource bundle for the specified base name can be found
      # @since 1.2
      def get_bundle(base_name, locale, loader)
        if ((loader).nil?)
          raise NullPointerException.new
        end
        return get_bundle_impl(base_name, locale, loader, Control::INSTANCE)
      end
      
      typesig { [String, Locale, ClassLoader, Control] }
      # Returns a resource bundle using the specified base name, target
      # locale, class loader and control. Unlike the {@linkplain
      # #getBundle(String, Locale, ClassLoader) <code>getBundle</code>
      # factory methods with no <code>control</code> argument}, the given
      # <code>control</code> specifies how to locate and instantiate resource
      # bundles. Conceptually, the bundle loading process with the given
      # <code>control</code> is performed in the following steps.
      # 
      # <p>
      # <ol>
      # <li>This factory method looks up the resource bundle in the cache for
      # the specified <code>baseName</code>, <code>targetLocale</code> and
      # <code>loader</code>.  If the requested resource bundle instance is
      # found in the cache and the time-to-live periods of the instance and
      # all of its parent instances have not expired, the instance is returned
      # to the caller. Otherwise, this factory method proceeds with the
      # loading process below.</li>
      # 
      # <li>The {@link ResourceBundle.Control#getFormats(String)
      # control.getFormats} method is called to get resource bundle formats
      # to produce bundle or resource names. The strings
      # <code>"java.class"</code> and <code>"java.properties"</code>
      # designate class-based and {@linkplain PropertyResourceBundle
      # property}-based resource bundles, respectively. Other strings
      # starting with <code>"java."</code> are reserved for future extensions
      # and must not be used for application-defined formats. Other strings
      # designate application-defined formats.</li>
      # 
      # <li>The {@link ResourceBundle.Control#getCandidateLocales(String,
      # Locale) control.getCandidateLocales} method is called with the target
      # locale to get a list of <em>candidate <code>Locale</code>s</em> for
      # which resource bundles are searched.</li>
      # 
      # <li>The {@link ResourceBundle.Control#newBundle(String, Locale,
      # String, ClassLoader, boolean) control.newBundle} method is called to
      # instantiate a <code>ResourceBundle</code> for the base bundle name, a
      # candidate locale, and a format. (Refer to the note on the cache
      # lookup below.) This step is iterated over all combinations of the
      # candidate locales and formats until the <code>newBundle</code> method
      # returns a <code>ResourceBundle</code> instance or the iteration has
      # used up all the combinations. For example, if the candidate locales
      # are <code>Locale("de", "DE")</code>, <code>Locale("de")</code> and
      # <code>Locale("")</code> and the formats are <code>"java.class"</code>
      # and <code>"java.properties"</code>, then the following is the
      # sequence of locale-format combinations to be used to call
      # <code>control.newBundle</code>.
      # 
      # <table style="width: 50%; text-align: left; margin-left: 40px;"
      # border="0" cellpadding="2" cellspacing="2">
      # <tbody><code>
      # <tr>
      # <td
      # style="vertical-align: top; text-align: left; font-weight: bold; width: 50%;">Locale<br>
      # </td>
      # <td
      # style="vertical-align: top; text-align: left; font-weight: bold; width: 50%;">format<br>
      # </td>
      # </tr>
      # <tr>
      # <td style="vertical-align: top; width: 50%;">Locale("de", "DE")<br>
      # </td>
      # <td style="vertical-align: top; width: 50%;">java.class<br>
      # </td>
      # </tr>
      # <tr>
      # <td style="vertical-align: top; width: 50%;">Locale("de", "DE")</td>
      # <td style="vertical-align: top; width: 50%;">java.properties<br>
      # </td>
      # </tr>
      # <tr>
      # <td style="vertical-align: top; width: 50%;">Locale("de")</td>
      # <td style="vertical-align: top; width: 50%;">java.class</td>
      # </tr>
      # <tr>
      # <td style="vertical-align: top; width: 50%;">Locale("de")</td>
      # <td style="vertical-align: top; width: 50%;">java.properties</td>
      # </tr>
      # <tr>
      # <td style="vertical-align: top; width: 50%;">Locale("")<br>
      # </td>
      # <td style="vertical-align: top; width: 50%;">java.class</td>
      # </tr>
      # <tr>
      # <td style="vertical-align: top; width: 50%;">Locale("")</td>
      # <td style="vertical-align: top; width: 50%;">java.properties</td>
      # </tr>
      # </code></tbody>
      # </table>
      # </li>
      # 
      # <li>If the previous step has found no resource bundle, proceed to
      # Step 6. If a bundle has been found that is a base bundle (a bundle
      # for <code>Locale("")</code>), and the candidate locale list only contained
      # <code>Locale("")</code>, return the bundle to the caller. If a bundle
      # has been found that is a base bundle, but the candidate locale list
      # contained locales other than Locale(""), put the bundle on hold and
      # proceed to Step 6. If a bundle has been found that is not a base
      # bundle, proceed to Step 7.</li>
      # 
      # <li>The {@link ResourceBundle.Control#getFallbackLocale(String,
      # Locale) control.getFallbackLocale} method is called to get a fallback
      # locale (alternative to the current target locale) to try further
      # finding a resource bundle. If the method returns a non-null locale,
      # it becomes the next target locale and the loading process starts over
      # from Step 3. Otherwise, if a base bundle was found and put on hold in
      # a previous Step 5, it is returned to the caller now. Otherwise, a
      # MissingResourceException is thrown.</li>
      # 
      # <li>At this point, we have found a resource bundle that's not the
      # base bundle. If this bundle set its parent during its instantiation,
      # it is returned to the caller. Otherwise, its <a
      # href="./ResourceBundle.html#parent_chain">parent chain</a> is
      # instantiated based on the list of candidate locales from which it was
      # found. Finally, the bundle is returned to the caller.</li>
      # 
      # 
      # </ol>
      # 
      # <p>During the resource bundle loading process above, this factory
      # method looks up the cache before calling the {@link
      # Control#newBundle(String, Locale, String, ClassLoader, boolean)
      # control.newBundle} method.  If the time-to-live period of the
      # resource bundle found in the cache has expired, the factory method
      # calls the {@link ResourceBundle.Control#needsReload(String, Locale,
      # String, ClassLoader, ResourceBundle, long) control.needsReload}
      # method to determine whether the resource bundle needs to be reloaded.
      # If reloading is required, the factory method calls
      # <code>control.newBundle</code> to reload the resource bundle.  If
      # <code>control.newBundle</code> returns <code>null</code>, the factory
      # method puts a dummy resource bundle in the cache as a mark of
      # nonexistent resource bundles in order to avoid lookup overhead for
      # subsequent requests. Such dummy resource bundles are under the same
      # expiration control as specified by <code>control</code>.
      # 
      # <p>All resource bundles loaded are cached by default. Refer to
      # {@link Control#getTimeToLive(String,Locale)
      # control.getTimeToLive} for details.
      # 
      # 
      # <p>The following is an example of the bundle loading process with the
      # default <code>ResourceBundle.Control</code> implementation.
      # 
      # <p>Conditions:
      # <ul>
      # <li>Base bundle name: <code>foo.bar.Messages</code>
      # <li>Requested <code>Locale</code>: {@link Locale#ITALY}</li>
      # <li>Default <code>Locale</code>: {@link Locale#FRENCH}</li>
      # <li>Available resource bundles:
      # <code>foo/bar/Messages_fr.properties</code> and
      # <code>foo/bar/Messages.properties</code></li>
      # 
      # </ul>
      # 
      # <p>First, <code>getBundle</code> tries loading a resource bundle in
      # the following sequence.
      # 
      # <ul>
      # <li>class <code>foo.bar.Messages_it_IT</code>
      # <li>file <code>foo/bar/Messages_it_IT.properties</code>
      # <li>class <code>foo.bar.Messages_it</code></li>
      # <li>file <code>foo/bar/Messages_it.properties</code></li>
      # <li>class <code>foo.bar.Messages</code></li>
      # <li>file <code>foo/bar/Messages.properties</code></li>
      # </ul>
      # 
      # <p>At this point, <code>getBundle</code> finds
      # <code>foo/bar/Messages.properties</code>, which is put on hold
      # because it's the base bundle.  <code>getBundle</code> calls {@link
      # Control#getFallbackLocale(String, Locale)
      # control.getFallbackLocale("foo.bar.Messages", Locale.ITALY)} which
      # returns <code>Locale.FRENCH</code>. Next, <code>getBundle</code>
      # tries loading a bundle in the following sequence.
      # 
      # <ul>
      # <li>class <code>foo.bar.Messages_fr</code></li>
      # <li>file <code>foo/bar/Messages_fr.properties</code></li>
      # <li>class <code>foo.bar.Messages</code></li>
      # <li>file <code>foo/bar/Messages.properties</code></li>
      # </ul>
      # 
      # <p><code>getBundle</code> finds
      # <code>foo/bar/Messages_fr.properties</code> and creates a
      # <code>ResourceBundle</code> instance. Then, <code>getBundle</code>
      # sets up its parent chain from the list of the candiate locales.  Only
      # <code>foo/bar/Messages.properties</code> is found in the list and
      # <code>getBundle</code> creates a <code>ResourceBundle</code> instance
      # that becomes the parent of the instance for
      # <code>foo/bar/Messages_fr.properties</code>.
      # 
      # @param baseName
      # the base name of the resource bundle, a fully qualified
      # class name
      # @param targetLocale
      # the locale for which a resource bundle is desired
      # @param loader
      # the class loader from which to load the resource bundle
      # @param control
      # the control which gives information for the resource
      # bundle loading process
      # @return a resource bundle for the given base name and locale
      # @exception NullPointerException
      # if <code>baseName</code>, <code>targetLocale</code>,
      # <code>loader</code>, or <code>control</code> is
      # <code>null</code>
      # @exception MissingResourceException
      # if no resource bundle for the specified base name can be found
      # @exception IllegalArgumentException
      # if the given <code>control</code> doesn't perform properly
      # (e.g., <code>control.getCandidateLocales</code> returns null.)
      # Note that validation of <code>control</code> is performed as
      # needed.
      # @since 1.6
      def get_bundle(base_name, target_locale, loader, control)
        if ((loader).nil? || (control).nil?)
          raise NullPointerException.new
        end
        return get_bundle_impl(base_name, target_locale, loader, control)
      end
      
      typesig { [String, Locale, ClassLoader, Control] }
      def get_bundle_impl(base_name, locale, loader, control)
        if ((locale).nil? || (control).nil?)
          raise NullPointerException.new
        end
        # We create a CacheKey here for use by this call. The base
        # name and loader will never change during the bundle loading
        # process. We have to make sure that the locale is set before
        # using it as a cache key.
        cache_key = CacheKey.new(base_name, locale, loader)
        bundle = nil
        # Quick lookup of the cache.
        bundle_ref = CacheList.get(cache_key)
        if (!(bundle_ref).nil?)
          bundle = bundle_ref.get
          bundle_ref = nil
        end
        # If this bundle and all of its parents are valid (not expired),
        # then return this bundle. If any of the bundles is expired, we
        # don't call control.needsReload here but instead drop into the
        # complete loading process below.
        if (is_valid_bundle(bundle) && has_valid_parent_chain(bundle))
          return bundle
        end
        # No valid bundle was found in the cache, so we need to load the
        # resource bundle and its parents.
        is_known_control = ((control).equal?(Control::INSTANCE)) || (control.is_a?(SingleFormatControl))
        formats = control.get_formats(base_name)
        if (!is_known_control && !check_list(formats))
          raise IllegalArgumentException.new("Invalid Control: getFormats")
        end
        base_bundle = nil
        target_locale = locale
        while !(target_locale).nil?
          candidate_locales = control.get_candidate_locales(base_name, target_locale)
          if (!is_known_control && !check_list(candidate_locales))
            raise IllegalArgumentException.new("Invalid Control: getCandidateLocales")
          end
          bundle = find_bundle(cache_key, candidate_locales, formats, 0, control, base_bundle)
          # If the loaded bundle is the base bundle and exactly for the
          # requested locale or the only candidate locale, then take the
          # bundle as the resulting one. If the loaded bundle is the base
          # bundle, it's put on hold until we finish processing all
          # fallback locales.
          if (is_valid_bundle(bundle))
            is_base_bundle = (Locale::ROOT == bundle.attr_locale)
            if (!is_base_bundle || (bundle.attr_locale == locale) || ((candidate_locales.size).equal?(1) && (bundle.attr_locale == candidate_locales.get(0))))
              break
            end
            # If the base bundle has been loaded, keep the reference in
            # baseBundle so that we can avoid any redundant loading in case
            # the control specify not to cache bundles.
            if (is_base_bundle && (base_bundle).nil?)
              base_bundle = bundle
            end
          end
          target_locale = control.get_fallback_locale(base_name, target_locale)
        end
        if ((bundle).nil?)
          if ((base_bundle).nil?)
            throw_missing_resource_exception(base_name, locale, cache_key.get_cause)
          end
          bundle = base_bundle
        end
        return bundle
      end
      
      typesig { [JavaList] }
      # Checks if the given <code>List</code> is not null, not empty,
      # not having null in its elements.
      def check_list(a)
        valid = (!(a).nil? && !(a.size).equal?(0))
        if (valid)
          size_ = a.size
          i = 0
          while valid && i < size_
            valid = (!(a.get(i)).nil?)
            i += 1
          end
        end
        return valid
      end
      
      typesig { [CacheKey, JavaList, JavaList, ::Java::Int, Control, ResourceBundle] }
      def find_bundle(cache_key, candidate_locales, formats, index, control, base_bundle)
        target_locale = candidate_locales.get(index)
        parent = nil
        if (!(index).equal?(candidate_locales.size - 1))
          parent = find_bundle(cache_key, candidate_locales, formats, index + 1, control, base_bundle)
        else
          if (!(base_bundle).nil? && (Locale::ROOT == target_locale))
            return base_bundle
          end
        end
        # Before we do the real loading work, see whether we need to
        # do some housekeeping: If references to class loaders or
        # resource bundles have been nulled out, remove all related
        # information from the cache.
        ref = nil
        while (!((ref = ReferenceQueue.poll)).nil?)
          CacheList.remove((ref).get_cache_key)
        end
        # flag indicating the resource bundle has expired in the cache
        expired_bundle = false
        # First, look up the cache to see if it's in the cache, without
        # declaring beginLoading.
        cache_key.set_locale(target_locale)
        bundle = find_bundle_in_cache(cache_key, control)
        if (is_valid_bundle(bundle))
          expired_bundle = bundle.attr_expired
          if (!expired_bundle)
            # If its parent is the one asked for by the candidate
            # locales (the runtime lookup path), we can take the cached
            # one. (If it's not identical, then we'd have to check the
            # parent's parents to be consistent with what's been
            # requested.)
            if ((bundle.attr_parent).equal?(parent))
              return bundle
            end
            # Otherwise, remove the cached one since we can't keep
            # the same bundles having different parents.
            bundle_ref = CacheList.get(cache_key)
            if (!(bundle_ref).nil? && (bundle_ref.get).equal?(bundle))
              CacheList.remove(cache_key, bundle_ref)
            end
          end
        end
        if (!(bundle).equal?(NONEXISTENT_BUNDLE))
          const_key = cache_key.clone
          begin
            # Try declaring loading. If beginLoading() returns true,
            # then we can proceed. Otherwise, we need to take a look
            # at the cache again to see if someone else has loaded
            # the bundle and put it in the cache while we've been
            # waiting for other loading work to complete.
            while (!begin_loading(const_key))
              bundle = find_bundle_in_cache(cache_key, control)
              if ((bundle).nil?)
                next
              end
              if ((bundle).equal?(NONEXISTENT_BUNDLE))
                # If the bundle is NONEXISTENT_BUNDLE, the bundle doesn't exist.
                return parent
              end
              expired_bundle = bundle.attr_expired
              if (!expired_bundle)
                if ((bundle.attr_parent).equal?(parent))
                  return bundle
                end
                bundle_ref = CacheList.get(cache_key)
                if (!(bundle_ref).nil? && (bundle_ref.get).equal?(bundle))
                  CacheList.remove(cache_key, bundle_ref)
                end
              end
            end
            begin
              bundle = load_bundle(cache_key, formats, control, expired_bundle)
              if (!(bundle).nil?)
                if ((bundle.attr_parent).nil?)
                  bundle.set_parent(parent)
                end
                bundle.attr_locale = target_locale
                bundle = put_bundle_in_cache(cache_key, bundle, control)
                return bundle
              end
              # Put NONEXISTENT_BUNDLE in the cache as a mark that there's no bundle
              # instance for the locale.
              put_bundle_in_cache(cache_key, NONEXISTENT_BUNDLE, control)
            ensure
              end_loading(const_key)
            end
          ensure
            if (const_key.get_cause.is_a?(InterruptedException))
              JavaThread.current_thread.interrupt
            end
          end
        end
        raise AssertError if not (!(UnderConstruction.get(cache_key)).equal?(JavaThread.current_thread))
        return parent
      end
      
      typesig { [CacheKey, JavaList, Control, ::Java::Boolean] }
      def load_bundle(cache_key, formats, control, reload)
        raise AssertError if not ((UnderConstruction.get(cache_key)).equal?(JavaThread.current_thread))
        # Here we actually load the bundle in the order of formats
        # specified by the getFormats() value.
        target_locale = cache_key.get_locale
        bundle = nil
        size_ = formats.size
        i = 0
        while i < size_
          format = formats.get(i)
          begin
            bundle = control.new_bundle(cache_key.get_name, target_locale, format, cache_key.get_loader, reload)
          rescue LinkageError => error
            # We need to handle the LinkageError case due to
            # inconsistent case-sensitivity in ClassLoader.
            # See 6572242 for details.
            cache_key.set_cause(error)
          rescue JavaException => cause
            cache_key.set_cause(cause)
          end
          if (!(bundle).nil?)
            # Set the format in the cache key so that it can be
            # used when calling needsReload later.
            cache_key.set_format(format)
            bundle.attr_name = cache_key.get_name
            bundle.attr_locale = target_locale
            # Bundle provider might reuse instances. So we should make
            # sure to clear the expired flag here.
            bundle.attr_expired = false
            break
          end
          i += 1
        end
        raise AssertError if not ((UnderConstruction.get(cache_key)).equal?(JavaThread.current_thread))
        return bundle
      end
      
      typesig { [ResourceBundle] }
      def is_valid_bundle(bundle)
        return !(bundle).nil? && !(bundle).equal?(NONEXISTENT_BUNDLE)
      end
      
      typesig { [ResourceBundle] }
      # Determines whether any of resource bundles in the parent chain,
      # including the leaf, have expired.
      def has_valid_parent_chain(bundle)
        now = System.current_time_millis
        while (!(bundle).nil?)
          if (bundle.attr_expired)
            return false
          end
          key = bundle.attr_cache_key
          if (!(key).nil?)
            expiration_time = key.attr_expiration_time
            if (expiration_time >= 0 && expiration_time <= now)
              return false
            end
          end
          bundle = bundle.attr_parent
        end
        return true
      end
      
      typesig { [CacheKey] }
      # Declares the beginning of actual resource bundle loading. This method
      # returns true if the declaration is successful and the current thread has
      # been put in underConstruction. If someone else has already begun
      # loading, this method waits until that loading work is complete and
      # returns false.
      def begin_loading(const_key)
        me = JavaThread.current_thread
        worker = nil
        # We need to declare by putting the current Thread (me) to
        # underConstruction that we are working on loading the specified
        # resource bundle. If we are already working the loading, it means
        # that the resource loading requires a recursive call. In that case,
        # we have to proceed. (4300693)
        if ((((worker = UnderConstruction.put_if_absent(const_key, me))).nil?) || (worker).equal?(me))
          return true
        end
        # If someone else is working on the loading, wait until
        # the Thread finishes the bundle loading.
        synchronized((worker)) do
          while ((UnderConstruction.get(const_key)).equal?(worker))
            begin
              worker.wait
            rescue InterruptedException => e
              # record the interruption
              const_key.set_cause(e)
            end
          end
        end
        return false
      end
      
      typesig { [CacheKey] }
      # Declares the end of the bundle loading. This method calls notifyAll
      # for those who are waiting for this completion.
      def end_loading(const_key)
        # Remove this Thread from the underConstruction map and wake up
        # those who have been waiting for me to complete this bundle
        # loading.
        me = JavaThread.current_thread
        raise AssertError if not (((UnderConstruction.get(const_key)).equal?(me)))
        UnderConstruction.remove(const_key)
        synchronized((me)) do
          me.notify_all
        end
      end
      
      typesig { [String, Locale, JavaThrowable] }
      # Throw a MissingResourceException with proper message
      def throw_missing_resource_exception(base_name, locale, cause)
        # If the cause is a MissingResourceException, avoid creating
        # a long chain. (6355009)
        if (cause.is_a?(MissingResourceException))
          cause = nil
        end
        # className
        # key
        raise MissingResourceException.new("Can't find bundle for base name " + base_name + ", locale " + RJava.cast_to_string(locale), base_name + "_" + RJava.cast_to_string(locale), "", cause)
      end
      
      typesig { [CacheKey, Control] }
      # Finds a bundle in the cache. Any expired bundles are marked as
      # `expired' and removed from the cache upon return.
      # 
      # @param cacheKey the key to look up the cache
      # @param control the Control to be used for the expiration control
      # @return the cached bundle, or null if the bundle is not found in the
      # cache or its parent has expired. <code>bundle.expire</code> is true
      # upon return if the bundle in the cache has expired.
      def find_bundle_in_cache(cache_key, control)
        bundle_ref = CacheList.get(cache_key)
        if ((bundle_ref).nil?)
          return nil
        end
        bundle = bundle_ref.get
        if ((bundle).nil?)
          return nil
        end
        p = bundle.attr_parent
        raise AssertError if not (!(p).equal?(NONEXISTENT_BUNDLE))
        # If the parent has expired, then this one must also expire. We
        # check only the immediate parent because the actual loading is
        # done from the root (base) to leaf (child) and the purpose of
        # checking is to propagate expiration towards the leaf. For
        # example, if the requested locale is ja_JP_JP and there are
        # bundles for all of the candidates in the cache, we have a list,
        # 
        # base <- ja <- ja_JP <- ja_JP_JP
        # 
        # If ja has expired, then it will reload ja and the list becomes a
        # tree.
        # 
        # base <- ja (new)
        # "   <- ja (expired) <- ja_JP <- ja_JP_JP
        # 
        # When looking up ja_JP in the cache, it finds ja_JP in the cache
        # which references to the expired ja. Then, ja_JP is marked as
        # expired and removed from the cache. This will be propagated to
        # ja_JP_JP.
        # 
        # Now, it's possible, for example, that while loading new ja_JP,
        # someone else has started loading the same bundle and finds the
        # base bundle has expired. Then, what we get from the first
        # getBundle call includes the expired base bundle. However, if
        # someone else didn't start its loading, we wouldn't know if the
        # base bundle has expired at the end of the loading process. The
        # expiration control doesn't guarantee that the returned bundle and
        # its parents haven't expired.
        # 
        # We could check the entire parent chain to see if there's any in
        # the chain that has expired. But this process may never end. An
        # extreme case would be that getTimeToLive returns 0 and
        # needsReload always returns true.
        if (!(p).nil? && p.attr_expired)
          raise AssertError if not (!(bundle).equal?(NONEXISTENT_BUNDLE))
          bundle.attr_expired = true
          bundle.attr_cache_key = nil
          CacheList.remove(cache_key, bundle_ref)
          bundle = nil
        else
          key = bundle_ref.get_cache_key
          expiration_time = key.attr_expiration_time
          if (!bundle.attr_expired && expiration_time >= 0 && expiration_time <= System.current_time_millis)
            # its TTL period has expired.
            if (!(bundle).equal?(NONEXISTENT_BUNDLE))
              # Synchronize here to call needsReload to avoid
              # redundant concurrent calls for the same bundle.
              synchronized((bundle)) do
                expiration_time = key.attr_expiration_time
                if (!bundle.attr_expired && expiration_time >= 0 && expiration_time <= System.current_time_millis)
                  begin
                    bundle.attr_expired = control.needs_reload(key.get_name, key.get_locale, key.get_format, key.get_loader, bundle, key.attr_load_time)
                  rescue JavaException => e
                    cache_key.set_cause(e)
                  end
                  if (bundle.attr_expired)
                    # If the bundle needs to be reloaded, then
                    # remove the bundle from the cache, but
                    # return the bundle with the expired flag
                    # on.
                    bundle.attr_cache_key = nil
                    CacheList.remove(cache_key, bundle_ref)
                  else
                    # Update the expiration control info. and reuse
                    # the same bundle instance
                    set_expiration_time(key, control)
                  end
                end
              end
            else
              # We just remove NONEXISTENT_BUNDLE from the cache.
              CacheList.remove(cache_key, bundle_ref)
              bundle = nil
            end
          end
        end
        return bundle
      end
      
      typesig { [CacheKey, ResourceBundle, Control] }
      # Put a new bundle in the cache.
      # 
      # @param cacheKey the key for the resource bundle
      # @param bundle the resource bundle to be put in the cache
      # @return the ResourceBundle for the cacheKey; if someone has put
      # the bundle before this call, the one found in the cache is
      # returned.
      def put_bundle_in_cache(cache_key, bundle, control)
        set_expiration_time(cache_key, control)
        if (!(cache_key.attr_expiration_time).equal?(Control::TTL_DONT_CACHE))
          key = cache_key.clone
          bundle_ref = BundleReference.new(bundle, ReferenceQueue, key)
          bundle.attr_cache_key = key
          # Put the bundle in the cache if it's not been in the cache.
          result = CacheList.put_if_absent(key, bundle_ref)
          # If someone else has put the same bundle in the cache before
          # us and it has not expired, we should use the one in the cache.
          if (!(result).nil?)
            rb = result.get
            if (!(rb).nil? && !rb.attr_expired)
              # Clear the back link to the cache key
              bundle.attr_cache_key = nil
              bundle = rb
              # Clear the reference in the BundleReference so that
              # it won't be enqueued.
              bundle_ref.clear
            else
              # Replace the invalid (garbage collected or expired)
              # instance with the valid one.
              CacheList.put(key, bundle_ref)
            end
          end
        end
        return bundle
      end
      
      typesig { [CacheKey, Control] }
      def set_expiration_time(cache_key, control)
        ttl = control.get_time_to_live(cache_key.get_name, cache_key.get_locale)
        if (ttl >= 0)
          # If any expiration time is specified, set the time to be
          # expired in the cache.
          now = System.current_time_millis
          cache_key.attr_load_time = now
          cache_key.attr_expiration_time = now + ttl
        else
          if (ttl >= Control::TTL_NO_EXPIRATION_CONTROL)
            cache_key.attr_expiration_time = ttl
          else
            raise IllegalArgumentException.new("Invalid Control: TTL=" + RJava.cast_to_string(ttl))
          end
        end
      end
      
      typesig { [] }
      # Removes all resource bundles from the cache that have been loaded
      # using the caller's class loader.
      # 
      # @since 1.6
      # @see ResourceBundle.Control#getTimeToLive(String,Locale)
      def clear_cache
        clear_cache(get_loader)
      end
      
      typesig { [ClassLoader] }
      # Removes all resource bundles from the cache that have been loaded
      # using the given class loader.
      # 
      # @param loader the class loader
      # @exception NullPointerException if <code>loader</code> is null
      # @since 1.6
      # @see ResourceBundle.Control#getTimeToLive(String,Locale)
      def clear_cache(loader)
        if ((loader).nil?)
          raise NullPointerException.new
        end
        set = CacheList.key_set
        set.each do |key|
          if ((key.get_loader).equal?(loader))
            set.remove(key)
          end
        end
      end
    }
    
    typesig { [String] }
    # Gets an object for the given key from this resource bundle.
    # Returns null if this resource bundle does not contain an
    # object for the given key.
    # 
    # @param key the key for the desired object
    # @exception NullPointerException if <code>key</code> is <code>null</code>
    # @return the object for the given key, or null
    def handle_get_object(key)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an enumeration of the keys.
    # 
    # @return an <code>Enumeration</code> of the keys contained in
    # this <code>ResourceBundle</code> and its parent bundles.
    def get_keys
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Determines whether the given <code>key</code> is contained in
    # this <code>ResourceBundle</code> or its parent bundles.
    # 
    # @param key
    # the resource <code>key</code>
    # @return <code>true</code> if the given <code>key</code> is
    # contained in this <code>ResourceBundle</code> or its
    # parent bundles; <code>false</code> otherwise.
    # @exception NullPointerException
    # if <code>key</code> is <code>null</code>
    # @since 1.6
    def contains_key(key)
      if ((key).nil?)
        raise NullPointerException.new
      end
      rb = self
      while !(rb).nil?
        if (rb.handle_key_set.contains(key))
          return true
        end
        rb = rb.attr_parent
      end
      return false
    end
    
    typesig { [] }
    # Returns a <code>Set</code> of all keys contained in this
    # <code>ResourceBundle</code> and its parent bundles.
    # 
    # @return a <code>Set</code> of all keys contained in this
    # <code>ResourceBundle</code> and its parent bundles.
    # @since 1.6
    def key_set
      keys = HashSet.new
      rb = self
      while !(rb).nil?
        keys.add_all(rb.handle_key_set)
        rb = rb.attr_parent
      end
      return keys
    end
    
    typesig { [] }
    # Returns a <code>Set</code> of the keys contained <em>only</em>
    # in this <code>ResourceBundle</code>.
    # 
    # <p>The default implementation returns a <code>Set</code> of the
    # keys returned by the {@link #getKeys() getKeys} method except
    # for the ones for which the {@link #handleGetObject(String)
    # handleGetObject} method returns <code>null</code>. Once the
    # <code>Set</code> has been created, the value is kept in this
    # <code>ResourceBundle</code> in order to avoid producing the
    # same <code>Set</code> in the next calls.  Override this method
    # in subclass implementations for faster handling.
    # 
    # @return a <code>Set</code> of the keys contained only in this
    # <code>ResourceBundle</code>
    # @since 1.6
    def handle_key_set
      if ((@key_set).nil?)
        synchronized((self)) do
          if ((@key_set).nil?)
            keys = HashSet.new
            enum_keys = get_keys
            while (enum_keys.has_more_elements)
              key = enum_keys.next_element
              if (!(handle_get_object(key)).nil?)
                keys.add(key)
              end
            end
            @key_set = keys
          end
        end
      end
      return @key_set
    end
    
    class_module.module_eval {
      # <code>ResourceBundle.Control</code> defines a set of callback methods
      # that are invoked by the {@link ResourceBundle#getBundle(String,
      # Locale, ClassLoader, Control) ResourceBundle.getBundle} factory
      # methods during the bundle loading process. In other words, a
      # <code>ResourceBundle.Control</code> collaborates with the factory
      # methods for loading resource bundles. The default implementation of
      # the callback methods provides the information necessary for the
      # factory methods to perform the <a
      # href="./ResourceBundle.html#default_behavior">default behavior</a>.
      # 
      # <p>In addition to the callback methods, the {@link
      # #toBundleName(String, Locale) toBundleName} and {@link
      # #toResourceName(String, String) toResourceName} methods are defined
      # primarily for convenience in implementing the callback
      # methods. However, the <code>toBundleName</code> method could be
      # overridden to provide different conventions in the organization and
      # packaging of localized resources.  The <code>toResourceName</code>
      # method is <code>final</code> to avoid use of wrong resource and class
      # name separators.
      # 
      # <p>Two factory methods, {@link #getControl(List)} and {@link
      # #getNoFallbackControl(List)}, provide
      # <code>ResourceBundle.Control</code> instances that implement common
      # variations of the default bundle loading process.
      # 
      # <p>The formats returned by the {@link Control#getFormats(String)
      # getFormats} method and candidate locales returned by the {@link
      # ResourceBundle.Control#getCandidateLocales(String, Locale)
      # getCandidateLocales} method must be consistent in all
      # <code>ResourceBundle.getBundle</code> invocations for the same base
      # bundle. Otherwise, the <code>ResourceBundle.getBundle</code> methods
      # may return unintended bundles. For example, if only
      # <code>"java.class"</code> is returned by the <code>getFormats</code>
      # method for the first call to <code>ResourceBundle.getBundle</code>
      # and only <code>"java.properties"</code> for the second call, then the
      # second call will return the class-based one that has been cached
      # during the first call.
      # 
      # <p>A <code>ResourceBundle.Control</code> instance must be thread-safe
      # if it's simultaneously used by multiple threads.
      # <code>ResourceBundle.getBundle</code> does not synchronize to call
      # the <code>ResourceBundle.Control</code> methods. The default
      # implementations of the methods are thread-safe.
      # 
      # <p>Applications can specify <code>ResourceBundle.Control</code>
      # instances returned by the <code>getControl</code> factory methods or
      # created from a subclass of <code>ResourceBundle.Control</code> to
      # customize the bundle loading process. The following are examples of
      # changing the default bundle loading process.
      # 
      # <p><b>Example 1</b>
      # 
      # <p>The following code lets <code>ResourceBundle.getBundle</code> look
      # up only properties-based resources.
      # 
      # <pre>
      # import java.util.*;
      # import static java.util.ResourceBundle.Control.*;
      # ...
      # ResourceBundle bundle =
      # ResourceBundle.getBundle("MyResources", new Locale("fr", "CH"),
      # ResourceBundle.Control.getControl(FORMAT_PROPERTIES));
      # </pre>
      # 
      # Given the resource bundles in the <a
      # href="./ResourceBundle.html#default_behavior_example">example</a> in
      # the <code>ResourceBundle.getBundle</code> description, this
      # <code>ResourceBundle.getBundle</code> call loads
      # <code>MyResources_fr_CH.properties</code> whose parent is
      # <code>MyResources_fr.properties</code> whose parent is
      # <code>MyResources.properties</code>. (<code>MyResources_fr_CH.properties</code>
      # is not hidden, but <code>MyResources_fr_CH.class</code> is.)
      # 
      # <p><b>Example 2</b>
      # 
      # <p>The following is an example of loading XML-based bundles
      # using {@link Properties#loadFromXML(java.io.InputStream)
      # Properties.loadFromXML}.
      # 
      # <pre>
      # ResourceBundle rb = ResourceBundle.getBundle("Messages",
      # new ResourceBundle.Control() {
      # public List&lt;String&gt; getFormats(String baseName) {
      # if (baseName == null)
      # throw new NullPointerException();
      # return Arrays.asList("xml");
      # }
      # public ResourceBundle newBundle(String baseName,
      # Locale locale,
      # String format,
      # ClassLoader loader,
      # boolean reload)
      # throws IllegalAccessException,
      # InstantiationException,
      # IOException {
      # if (baseName == null || locale == null
      # || format == null || loader == null)
      # throw new NullPointerException();
      # ResourceBundle bundle = null;
      # if (format.equals("xml")) {
      # String bundleName = toBundleName(baseName, locale);
      # String resourceName = toResourceName(bundleName, format);
      # InputStream stream = null;
      # if (reload) {
      # URL url = loader.getResource(resourceName);
      # if (url != null) {
      # URLConnection connection = url.openConnection();
      # if (connection != null) {
      # // Disable caches to get fresh data for
      # // reloading.
      # connection.setUseCaches(false);
      # stream = connection.getInputStream();
      # }
      # }
      # } else {
      # stream = loader.getResourceAsStream(resourceName);
      # }
      # if (stream != null) {
      # BufferedInputStream bis = new BufferedInputStream(stream);
      # bundle = new XMLResourceBundle(bis);
      # bis.close();
      # }
      # }
      # return bundle;
      # }
      # });
      # 
      # ...
      # 
      # private static class XMLResourceBundle extends ResourceBundle {
      # private Properties props;
      # XMLResourceBundle(InputStream stream) throws IOException {
      # props = new Properties();
      # props.loadFromXML(stream);
      # }
      # protected Object handleGetObject(String key) {
      # return props.getProperty(key);
      # }
      # public Enumeration&lt;String&gt; getKeys() {
      # ...
      # }
      # }
      # </pre>
      # 
      # @since 1.6
      const_set_lazy(:Control) { Class.new do
        include_class_members ResourceBundle
        
        class_module.module_eval {
          # The default format <code>List</code>, which contains the strings
          # <code>"java.class"</code> and <code>"java.properties"</code>, in
          # this order. This <code>List</code> is {@linkplain
          # Collections#unmodifiableList(List) unmodifiable}.
          # 
          # @see #getFormats(String)
          const_set_lazy(:FORMAT_DEFAULT) { Collections.unmodifiable_list(Arrays.as_list("java.class", "java.properties")) }
          const_attr_reader  :FORMAT_DEFAULT
          
          # The class-only format <code>List</code> containing
          # <code>"java.class"</code>. This <code>List</code> is {@linkplain
          # Collections#unmodifiableList(List) unmodifiable}.
          # 
          # @see #getFormats(String)
          const_set_lazy(:FORMAT_CLASS) { Collections.unmodifiable_list(Arrays.as_list("java.class")) }
          const_attr_reader  :FORMAT_CLASS
          
          # The properties-only format <code>List</code> containing
          # <code>"java.properties"</code>. This <code>List</code> is
          # {@linkplain Collections#unmodifiableList(List) unmodifiable}.
          # 
          # @see #getFormats(String)
          const_set_lazy(:FORMAT_PROPERTIES) { Collections.unmodifiable_list(Arrays.as_list("java.properties")) }
          const_attr_reader  :FORMAT_PROPERTIES
          
          # The time-to-live constant for not caching loaded resource bundle
          # instances.
          # 
          # @see #getTimeToLive(String, Locale)
          const_set_lazy(:TTL_DONT_CACHE) { -1 }
          const_attr_reader  :TTL_DONT_CACHE
          
          # The time-to-live constant for disabling the expiration control
          # for loaded resource bundle instances in the cache.
          # 
          # @see #getTimeToLive(String, Locale)
          const_set_lazy(:TTL_NO_EXPIRATION_CONTROL) { -2 }
          const_attr_reader  :TTL_NO_EXPIRATION_CONTROL
          
          const_set_lazy(:INSTANCE) { self.class::Control.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [] }
        # Sole constructor. (For invocation by subclass constructors,
        # typically implicit.)
        def initialize
        end
        
        class_module.module_eval {
          typesig { [self::JavaList] }
          # Returns a <code>ResourceBundle.Control</code> in which the {@link
          # #getFormats(String) getFormats} method returns the specified
          # <code>formats</code>. The <code>formats</code> must be equal to
          # one of {@link Control#FORMAT_PROPERTIES}, {@link
          # Control#FORMAT_CLASS} or {@link
          # Control#FORMAT_DEFAULT}. <code>ResourceBundle.Control</code>
          # instances returned by this method are singletons and thread-safe.
          # 
          # <p>Specifying {@link Control#FORMAT_DEFAULT} is equivalent to
          # instantiating the <code>ResourceBundle.Control</code> class,
          # except that this method returns a singleton.
          # 
          # @param formats
          # the formats to be returned by the
          # <code>ResourceBundle.Control.getFormats</code> method
          # @return a <code>ResourceBundle.Control</code> supporting the
          # specified <code>formats</code>
          # @exception NullPointerException
          # if <code>formats</code> is <code>null</code>
          # @exception IllegalArgumentException
          # if <code>formats</code> is unknown
          def get_control(formats)
            if ((formats == Control::FORMAT_PROPERTIES))
              return SingleFormatControl::PROPERTIES_ONLY
            end
            if ((formats == Control::FORMAT_CLASS))
              return SingleFormatControl::CLASS_ONLY
            end
            if ((formats == Control::FORMAT_DEFAULT))
              return Control::INSTANCE
            end
            raise self.class::IllegalArgumentException.new
          end
          
          typesig { [self::JavaList] }
          # Returns a <code>ResourceBundle.Control</code> in which the {@link
          # #getFormats(String) getFormats} method returns the specified
          # <code>formats</code> and the {@link
          # Control#getFallbackLocale(String, Locale) getFallbackLocale}
          # method returns <code>null</code>. The <code>formats</code> must
          # be equal to one of {@link Control#FORMAT_PROPERTIES}, {@link
          # Control#FORMAT_CLASS} or {@link Control#FORMAT_DEFAULT}.
          # <code>ResourceBundle.Control</code> instances returned by this
          # method are singletons and thread-safe.
          # 
          # @param formats
          # the formats to be returned by the
          # <code>ResourceBundle.Control.getFormats</code> method
          # @return a <code>ResourceBundle.Control</code> supporting the
          # specified <code>formats</code> with no fallback
          # <code>Locale</code> support
          # @exception NullPointerException
          # if <code>formats</code> is <code>null</code>
          # @exception IllegalArgumentException
          # if <code>formats</code> is unknown
          def get_no_fallback_control(formats)
            if ((formats == Control::FORMAT_DEFAULT))
              return NoFallbackControl::NO_FALLBACK
            end
            if ((formats == Control::FORMAT_PROPERTIES))
              return NoFallbackControl::PROPERTIES_ONLY_NO_FALLBACK
            end
            if ((formats == Control::FORMAT_CLASS))
              return NoFallbackControl::CLASS_ONLY_NO_FALLBACK
            end
            raise self.class::IllegalArgumentException.new
          end
        }
        
        typesig { [self::String] }
        # Returns a <code>List</code> of <code>String</code>s containing
        # formats to be used to load resource bundles for the given
        # <code>baseName</code>. The <code>ResourceBundle.getBundle</code>
        # factory method tries to load resource bundles with formats in the
        # order specified by the list. The list returned by this method
        # must have at least one <code>String</code>. The predefined
        # formats are <code>"java.class"</code> for class-based resource
        # bundles and <code>"java.properties"</code> for {@linkplain
        # PropertyResourceBundle properties-based} ones. Strings starting
        # with <code>"java."</code> are reserved for future extensions and
        # must not be used by application-defined formats.
        # 
        # <p>It is not a requirement to return an immutable (unmodifiable)
        # <code>List</code>.  However, the returned <code>List</code> must
        # not be mutated after it has been returned by
        # <code>getFormats</code>.
        # 
        # <p>The default implementation returns {@link #FORMAT_DEFAULT} so
        # that the <code>ResourceBundle.getBundle</code> factory method
        # looks up first class-based resource bundles, then
        # properties-based ones.
        # 
        # @param baseName
        # the base name of the resource bundle, a fully qualified class
        # name
        # @return a <code>List</code> of <code>String</code>s containing
        # formats for loading resource bundles.
        # @exception NullPointerException
        # if <code>baseName</code> is null
        # @see #FORMAT_DEFAULT
        # @see #FORMAT_CLASS
        # @see #FORMAT_PROPERTIES
        def get_formats(base_name)
          if ((base_name).nil?)
            raise self.class::NullPointerException.new
          end
          return self.class::FORMAT_DEFAULT
        end
        
        typesig { [self::String, self::Locale] }
        # Returns a <code>List</code> of <code>Locale</code>s as candidate
        # locales for <code>baseName</code> and <code>locale</code>. This
        # method is called by the <code>ResourceBundle.getBundle</code>
        # factory method each time the factory method tries finding a
        # resource bundle for a target <code>Locale</code>.
        # 
        # <p>The sequence of the candidate locales also corresponds to the
        # runtime resource lookup path (also known as the <I>parent
        # chain</I>), if the corresponding resource bundles for the
        # candidate locales exist and their parents are not defined by
        # loaded resource bundles themselves.  The last element of the list
        # must be a {@linkplain Locale#ROOT root locale} if it is desired to
        # have the base bundle as the terminal of the parent chain.
        # 
        # <p>If the given locale is equal to <code>Locale.ROOT</code> (the
        # root locale), a <code>List</code> containing only the root
        # <code>Locale</code> must be returned. In this case, the
        # <code>ResourceBundle.getBundle</code> factory method loads only
        # the base bundle as the resulting resource bundle.
        # 
        # <p>It is not a requirement to return an immutable
        # (unmodifiable) <code>List</code>. However, the returned
        # <code>List</code> must not be mutated after it has been
        # returned by <code>getCandidateLocales</code>.
        # 
        # <p>The default implementation returns a <code>List</code> containing
        # <code>Locale</code>s in the following sequence:
        # <pre>
        # Locale(language, country, variant)
        # Locale(language, country)
        # Locale(language)
        # Locale.ROOT
        # </pre>
        # where <code>language</code>, <code>country</code> and
        # <code>variant</code> are the language, country and variant values
        # of the given <code>locale</code>, respectively. Locales where the
        # final component values are empty strings are omitted.
        # 
        # <p>The default implementation uses an {@link ArrayList} that
        # overriding implementations may modify before returning it to the
        # caller. However, a subclass must not modify it after it has
        # been returned by <code>getCandidateLocales</code>.
        # 
        # <p>For example, if the given <code>baseName</code> is "Messages"
        # and the given <code>locale</code> is
        # <code>Locale("ja",&nbsp;"",&nbsp;"XX")</code>, then a
        # <code>List</code> of <code>Locale</code>s:
        # <pre>
        # Locale("ja", "", "XX")
        # Locale("ja")
        # Locale.ROOT
        # </pre>
        # is returned. And if the resource bundles for the "ja" and
        # "" <code>Locale</code>s are found, then the runtime resource
        # lookup path (parent chain) is:
        # <pre>
        # Messages_ja -> Messages
        # </pre>
        # 
        # @param baseName
        # the base name of the resource bundle, a fully
        # qualified class name
        # @param locale
        # the locale for which a resource bundle is desired
        # @return a <code>List</code> of candidate
        # <code>Locale</code>s for the given <code>locale</code>
        # @exception NullPointerException
        # if <code>baseName</code> or <code>locale</code> is
        # <code>null</code>
        def get_candidate_locales(base_name, locale)
          if ((base_name).nil?)
            raise self.class::NullPointerException.new
          end
          language = locale.get_language
          country = locale.get_country
          variant = locale.get_variant
          locales = self.class::ArrayList.new(4)
          if (variant.length > 0)
            locales.add(locale)
          end
          if (country.length > 0)
            locales.add(((locales.size).equal?(0)) ? locale : Locale.get_instance(language, country, ""))
          end
          if (language.length > 0)
            locales.add(((locales.size).equal?(0)) ? locale : Locale.get_instance(language, "", ""))
          end
          locales.add(Locale::ROOT)
          return locales
        end
        
        typesig { [self::String, self::Locale] }
        # Returns a <code>Locale</code> to be used as a fallback locale for
        # further resource bundle searches by the
        # <code>ResourceBundle.getBundle</code> factory method. This method
        # is called from the factory method every time when no resulting
        # resource bundle has been found for <code>baseName</code> and
        # <code>locale</code>, where locale is either the parameter for
        # <code>ResourceBundle.getBundle</code> or the previous fallback
        # locale returned by this method.
        # 
        # <p>The method returns <code>null</code> if no further fallback
        # search is desired.
        # 
        # <p>The default implementation returns the {@linkplain
        # Locale#getDefault() default <code>Locale</code>} if the given
        # <code>locale</code> isn't the default one.  Otherwise,
        # <code>null</code> is returned.
        # 
        # @param baseName
        # the base name of the resource bundle, a fully
        # qualified class name for which
        # <code>ResourceBundle.getBundle</code> has been
        # unable to find any resource bundles (except for the
        # base bundle)
        # @param locale
        # the <code>Locale</code> for which
        # <code>ResourceBundle.getBundle</code> has been
        # unable to find any resource bundles (except for the
        # base bundle)
        # @return a <code>Locale</code> for the fallback search,
        # or <code>null</code> if no further fallback search
        # is desired.
        # @exception NullPointerException
        # if <code>baseName</code> or <code>locale</code>
        # is <code>null</code>
        def get_fallback_locale(base_name, locale)
          if ((base_name).nil?)
            raise self.class::NullPointerException.new
          end
          default_locale = Locale.get_default
          return (locale == default_locale) ? nil : default_locale
        end
        
        typesig { [self::String, self::Locale, self::String, self::ClassLoader, ::Java::Boolean] }
        # Instantiates a resource bundle for the given bundle name of the
        # given format and locale, using the given class loader if
        # necessary. This method returns <code>null</code> if there is no
        # resource bundle available for the given parameters. If a resource
        # bundle can't be instantiated due to an unexpected error, the
        # error must be reported by throwing an <code>Error</code> or
        # <code>Exception</code> rather than simply returning
        # <code>null</code>.
        # 
        # <p>If the <code>reload</code> flag is <code>true</code>, it
        # indicates that this method is being called because the previously
        # loaded resource bundle has expired.
        # 
        # <p>The default implementation instantiates a
        # <code>ResourceBundle</code> as follows.
        # 
        # <ul>
        # 
        # <li>The bundle name is obtained by calling {@link
        # #toBundleName(String, Locale) toBundleName(baseName,
        # locale)}.</li>
        # 
        # <li>If <code>format</code> is <code>"java.class"</code>, the
        # {@link Class} specified by the bundle name is loaded by calling
        # {@link ClassLoader#loadClass(String)}. Then, a
        # <code>ResourceBundle</code> is instantiated by calling {@link
        # Class#newInstance()}.  Note that the <code>reload</code> flag is
        # ignored for loading class-based resource bundles in this default
        # implementation.</li>
        # 
        # <li>If <code>format</code> is <code>"java.properties"</code>,
        # {@link #toResourceName(String, String) toResourceName(bundlename,
        # "properties")} is called to get the resource name.
        # If <code>reload</code> is <code>true</code>, {@link
        # ClassLoader#getResource(String) load.getResource} is called
        # to get a {@link URL} for creating a {@link
        # URLConnection}. This <code>URLConnection</code> is used to
        # {@linkplain URLConnection#setUseCaches(boolean) disable the
        # caches} of the underlying resource loading layers,
        # and to {@linkplain URLConnection#getInputStream() get an
        # <code>InputStream</code>}.
        # Otherwise, {@link ClassLoader#getResourceAsStream(String)
        # loader.getResourceAsStream} is called to get an {@link
        # InputStream}. Then, a {@link
        # PropertyResourceBundle} is constructed with the
        # <code>InputStream</code>.</li>
        # 
        # <li>If <code>format</code> is neither <code>"java.class"</code>
        # nor <code>"java.properties"</code>, an
        # <code>IllegalArgumentException</code> is thrown.</li>
        # 
        # </ul>
        # 
        # @param baseName
        # the base bundle name of the resource bundle, a fully
        # qualified class name
        # @param locale
        # the locale for which the resource bundle should be
        # instantiated
        # @param format
        # the resource bundle format to be loaded
        # @param loader
        # the <code>ClassLoader</code> to use to load the bundle
        # @param reload
        # the flag to indicate bundle reloading; <code>true</code>
        # if reloading an expired resource bundle,
        # <code>false</code> otherwise
        # @return the resource bundle instance,
        # or <code>null</code> if none could be found.
        # @exception NullPointerException
        # if <code>bundleName</code>, <code>locale</code>,
        # <code>format</code>, or <code>loader</code> is
        # <code>null</code>, or if <code>null</code> is returned by
        # {@link #toBundleName(String, Locale) toBundleName}
        # @exception IllegalArgumentException
        # if <code>format</code> is unknown, or if the resource
        # found for the given parameters contains malformed data.
        # @exception ClassCastException
        # if the loaded class cannot be cast to <code>ResourceBundle</code>
        # @exception IllegalAccessException
        # if the class or its nullary constructor is not
        # accessible.
        # @exception InstantiationException
        # if the instantiation of a class fails for some other
        # reason.
        # @exception ExceptionInInitializerError
        # if the initialization provoked by this method fails.
        # @exception SecurityException
        # If a security manager is present and creation of new
        # instances is denied. See {@link Class#newInstance()}
        # for details.
        # @exception IOException
        # if an error occurred when reading resources using
        # any I/O operations
        def new_bundle(base_name, locale, format, loader, reload)
          bundle_name = to_bundle_name(base_name, locale)
          bundle = nil
          if ((format == "java.class"))
            begin
              bundle_class = loader.load_class(bundle_name)
              # If the class isn't a ResourceBundle subclass, throw a
              # ClassCastException.
              if (ResourceBundle.is_assignable_from(bundle_class))
                bundle = bundle_class.new_instance
              else
                raise self.class::ClassCastException.new(RJava.cast_to_string(bundle_class.get_name) + " cannot be cast to ResourceBundle")
              end
            rescue self.class::ClassNotFoundException => e
            end
          else
            if ((format == "java.properties"))
              resource_name = to_resource_name(bundle_name, "properties")
              class_loader = loader
              reload_flag = reload
              stream = nil
              begin
                stream = AccessController.do_privileged(Class.new(self.class::PrivilegedExceptionAction.class == Class ? self.class::PrivilegedExceptionAction : Object) do
                  extend LocalClass
                  include_class_members Control
                  include self::PrivilegedExceptionAction if self::PrivilegedExceptionAction.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    is = nil
                    if (reload_flag)
                      url = class_loader.get_resource(resource_name)
                      if (!(url).nil?)
                        connection = url.open_connection
                        if (!(connection).nil?)
                          # Disable caches to get fresh data for
                          # reloading.
                          connection.set_use_caches(false)
                          is = connection.get_input_stream
                        end
                      end
                    else
                      is = class_loader.get_resource_as_stream(resource_name)
                    end
                    return is
                  end
                  
                  typesig { [] }
                  define_method :initialize do
                    super()
                  end
                  
                  private
                  alias_method :initialize_anonymous, :initialize
                end.new_local(self))
              rescue self.class::PrivilegedActionException => e
                raise e.get_exception
              end
              if (!(stream).nil?)
                begin
                  bundle = self.class::PropertyResourceBundle.new(stream)
                ensure
                  stream.close
                end
              end
            else
              raise self.class::IllegalArgumentException.new("unknown format: " + format)
            end
          end
          return bundle
        end
        
        typesig { [self::String, self::Locale] }
        # Returns the time-to-live (TTL) value for resource bundles that
        # are loaded under this
        # <code>ResourceBundle.Control</code>. Positive time-to-live values
        # specify the number of milliseconds a bundle can remain in the
        # cache without being validated against the source data from which
        # it was constructed. The value 0 indicates that a bundle must be
        # validated each time it is retrieved from the cache. {@link
        # #TTL_DONT_CACHE} specifies that loaded resource bundles are not
        # put in the cache. {@link #TTL_NO_EXPIRATION_CONTROL} specifies
        # that loaded resource bundles are put in the cache with no
        # expiration control.
        # 
        # <p>The expiration affects only the bundle loading process by the
        # <code>ResourceBundle.getBundle</code> factory method.  That is,
        # if the factory method finds a resource bundle in the cache that
        # has expired, the factory method calls the {@link
        # #needsReload(String, Locale, String, ClassLoader, ResourceBundle,
        # long) needsReload} method to determine whether the resource
        # bundle needs to be reloaded. If <code>needsReload</code> returns
        # <code>true</code>, the cached resource bundle instance is removed
        # from the cache. Otherwise, the instance stays in the cache,
        # updated with the new TTL value returned by this method.
        # 
        # <p>All cached resource bundles are subject to removal from the
        # cache due to memory constraints of the runtime environment.
        # Returning a large positive value doesn't mean to lock loaded
        # resource bundles in the cache.
        # 
        # <p>The default implementation returns {@link #TTL_NO_EXPIRATION_CONTROL}.
        # 
        # @param baseName
        # the base name of the resource bundle for which the
        # expiration value is specified.
        # @param locale
        # the locale of the resource bundle for which the
        # expiration value is specified.
        # @return the time (0 or a positive millisecond offset from the
        # cached time) to get loaded bundles expired in the cache,
        # {@link #TTL_NO_EXPIRATION_CONTROL} to disable the
        # expiration control, or {@link #TTL_DONT_CACHE} to disable
        # caching.
        # @exception NullPointerException
        # if <code>baseName</code> or <code>locale</code> is
        # <code>null</code>
        def get_time_to_live(base_name, locale)
          if ((base_name).nil? || (locale).nil?)
            raise self.class::NullPointerException.new
          end
          return self.class::TTL_NO_EXPIRATION_CONTROL
        end
        
        typesig { [self::String, self::Locale, self::String, self::ClassLoader, self::ResourceBundle, ::Java::Long] }
        # Determines if the expired <code>bundle</code> in the cache needs
        # to be reloaded based on the loading time given by
        # <code>loadTime</code> or some other criteria. The method returns
        # <code>true</code> if reloading is required; <code>false</code>
        # otherwise. <code>loadTime</code> is a millisecond offset since
        # the <a href="Calendar.html#Epoch"> <code>Calendar</code>
        # Epoch</a>.
        # 
        # The calling <code>ResourceBundle.getBundle</code> factory method
        # calls this method on the <code>ResourceBundle.Control</code>
        # instance used for its current invocation, not on the instance
        # used in the invocation that originally loaded the resource
        # bundle.
        # 
        # <p>The default implementation compares <code>loadTime</code> and
        # the last modified time of the source data of the resource
        # bundle. If it's determined that the source data has been modified
        # since <code>loadTime</code>, <code>true</code> is
        # returned. Otherwise, <code>false</code> is returned. This
        # implementation assumes that the given <code>format</code> is the
        # same string as its file suffix if it's not one of the default
        # formats, <code>"java.class"</code> or
        # <code>"java.properties"</code>.
        # 
        # @param baseName
        # the base bundle name of the resource bundle, a
        # fully qualified class name
        # @param locale
        # the locale for which the resource bundle
        # should be instantiated
        # @param format
        # the resource bundle format to be loaded
        # @param loader
        # the <code>ClassLoader</code> to use to load the bundle
        # @param bundle
        # the resource bundle instance that has been expired
        # in the cache
        # @param loadTime
        # the time when <code>bundle</code> was loaded and put
        # in the cache
        # @return <code>true</code> if the expired bundle needs to be
        # reloaded; <code>false</code> otherwise.
        # @exception NullPointerException
        # if <code>baseName</code>, <code>locale</code>,
        # <code>format</code>, <code>loader</code>, or
        # <code>bundle</code> is <code>null</code>
        def needs_reload(base_name, locale, format, loader, bundle, load_time)
          if ((bundle).nil?)
            raise self.class::NullPointerException.new
          end
          if ((format == "java.class") || (format == "java.properties"))
            format = RJava.cast_to_string(format.substring(5))
          end
          result = false
          begin
            resource_name = to_resource_name(to_bundle_name(base_name, locale), format)
            url = loader.get_resource(resource_name)
            if (!(url).nil?)
              last_modified = 0
              connection = url.open_connection
              if (!(connection).nil?)
                # disable caches to get the correct data
                connection.set_use_caches(false)
                if (connection.is_a?(self.class::JarURLConnection))
                  ent = (connection).get_jar_entry
                  if (!(ent).nil?)
                    last_modified = ent.get_time
                    if ((last_modified).equal?(-1))
                      last_modified = 0
                    end
                  end
                else
                  last_modified = connection.get_last_modified
                end
              end
              result = last_modified >= load_time
            end
          rescue self.class::NullPointerException => npe
            raise npe
          rescue self.class::JavaException => e
            # ignore other exceptions
          end
          return result
        end
        
        typesig { [self::String, self::Locale] }
        # Converts the given <code>baseName</code> and <code>locale</code>
        # to the bundle name. This method is called from the default
        # implementation of the {@link #newBundle(String, Locale, String,
        # ClassLoader, boolean) newBundle} and {@link #needsReload(String,
        # Locale, String, ClassLoader, ResourceBundle, long) needsReload}
        # methods.
        # 
        # <p>This implementation returns the following value:
        # <pre>
        # baseName + "_" + language + "_" + country + "_" + variant
        # </pre>
        # where <code>language</code>, <code>country</code> and
        # <code>variant</code> are the language, country and variant values
        # of <code>locale</code>, respectively. Final component values that
        # are empty Strings are omitted along with the preceding '_'. If
        # all of the values are empty strings, then <code>baseName</code>
        # is returned.
        # 
        # <p>For example, if <code>baseName</code> is
        # <code>"baseName"</code> and <code>locale</code> is
        # <code>Locale("ja",&nbsp;"",&nbsp;"XX")</code>, then
        # <code>"baseName_ja_&thinsp;_XX"</code> is returned. If the given
        # locale is <code>Locale("en")</code>, then
        # <code>"baseName_en"</code> is returned.
        # 
        # <p>Overriding this method allows applications to use different
        # conventions in the organization and packaging of localized
        # resources.
        # 
        # @param baseName
        # the base name of the resource bundle, a fully
        # qualified class name
        # @param locale
        # the locale for which a resource bundle should be
        # loaded
        # @return the bundle name for the resource bundle
        # @exception NullPointerException
        # if <code>baseName</code> or <code>locale</code>
        # is <code>null</code>
        def to_bundle_name(base_name, locale)
          if ((locale).equal?(Locale::ROOT))
            return base_name
          end
          language = locale.get_language
          country = locale.get_country
          variant = locale.get_variant
          if ((language).equal?("") && (country).equal?("") && (variant).equal?(""))
            return base_name
          end
          sb = self.class::StringBuilder.new(base_name)
          sb.append(Character.new(?_.ord))
          if (!(variant).equal?(""))
            sb.append(language).append(Character.new(?_.ord)).append(country).append(Character.new(?_.ord)).append(variant)
          else
            if (!(country).equal?(""))
              sb.append(language).append(Character.new(?_.ord)).append(country)
            else
              sb.append(language)
            end
          end
          return sb.to_s
        end
        
        typesig { [self::String, self::String] }
        # Converts the given <code>bundleName</code> to the form required
        # by the {@link ClassLoader#getResource ClassLoader.getResource}
        # method by replacing all occurrences of <code>'.'</code> in
        # <code>bundleName</code> with <code>'/'</code> and appending a
        # <code>'.'</code> and the given file <code>suffix</code>. For
        # example, if <code>bundleName</code> is
        # <code>"foo.bar.MyResources_ja_JP"</code> and <code>suffix</code>
        # is <code>"properties"</code>, then
        # <code>"foo/bar/MyResources_ja_JP.properties"</code> is returned.
        # 
        # @param bundleName
        # the bundle name
        # @param suffix
        # the file type suffix
        # @return the converted resource name
        # @exception NullPointerException
        # if <code>bundleName</code> or <code>suffix</code>
        # is <code>null</code>
        def to_resource_name(bundle_name, suffix)
          sb = self.class::StringBuilder.new(bundle_name.length + 1 + suffix.length)
          sb.append(bundle_name.replace(Character.new(?..ord), Character.new(?/.ord))).append(Character.new(?..ord)).append(suffix)
          return sb.to_s
        end
        
        private
        alias_method :initialize__control, :initialize
      end }
      
      const_set_lazy(:SingleFormatControl) { Class.new(Control) do
        include_class_members ResourceBundle
        
        class_module.module_eval {
          const_set_lazy(:PROPERTIES_ONLY) { self.class::SingleFormatControl.new(FORMAT_PROPERTIES) }
          const_attr_reader  :PROPERTIES_ONLY
          
          const_set_lazy(:CLASS_ONLY) { self.class::SingleFormatControl.new(FORMAT_CLASS) }
          const_attr_reader  :CLASS_ONLY
        }
        
        attr_accessor :formats
        alias_method :attr_formats, :formats
        undef_method :formats
        alias_method :attr_formats=, :formats=
        undef_method :formats=
        
        typesig { [self::JavaList] }
        def initialize(formats)
          @formats = nil
          super()
          @formats = formats
        end
        
        typesig { [self::String] }
        def get_formats(base_name)
          if ((base_name).nil?)
            raise self.class::NullPointerException.new
          end
          return @formats
        end
        
        private
        alias_method :initialize__single_format_control, :initialize
      end }
      
      const_set_lazy(:NoFallbackControl) { Class.new(SingleFormatControl) do
        include_class_members ResourceBundle
        
        class_module.module_eval {
          const_set_lazy(:NO_FALLBACK) { self.class::NoFallbackControl.new(FORMAT_DEFAULT) }
          const_attr_reader  :NO_FALLBACK
          
          const_set_lazy(:PROPERTIES_ONLY_NO_FALLBACK) { self.class::NoFallbackControl.new(FORMAT_PROPERTIES) }
          const_attr_reader  :PROPERTIES_ONLY_NO_FALLBACK
          
          const_set_lazy(:CLASS_ONLY_NO_FALLBACK) { self.class::NoFallbackControl.new(FORMAT_CLASS) }
          const_attr_reader  :CLASS_ONLY_NO_FALLBACK
        }
        
        typesig { [self::JavaList] }
        def initialize(formats)
          super(formats)
        end
        
        typesig { [self::String, self::Locale] }
        def get_fallback_locale(base_name, locale)
          if ((base_name).nil? || (locale).nil?)
            raise self.class::NullPointerException.new
          end
          return nil
        end
        
        private
        alias_method :initialize__no_fallback_control, :initialize
      end }
    }
    
    private
    alias_method :initialize__resource_bundle, :initialize
  end
  
end
