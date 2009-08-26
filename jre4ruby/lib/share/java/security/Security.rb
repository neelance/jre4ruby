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
module Java::Security
  module SecurityImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Lang::Reflect
      include ::Java::Util
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include ::Java::Io
      include_const ::Java::Net, :URL
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :PropertyExpander
      include_const ::Java::Security::Provider, :Service
      include ::Sun::Security::Jca
    }
  end
  
  # <p>This class centralizes all security properties and common security
  # methods. One of its primary uses is to manage providers.
  # 
  # @author Benjamin Renaud
  class Security 
    include_class_members SecurityImports
    
    class_module.module_eval {
      # Are we debugging? -- for developers
      const_set_lazy(:Sdebug) { Debug.get_instance("properties") }
      const_attr_reader  :Sdebug
      
      # The java.security properties
      
      def props
        defined?(@@props) ? @@props : @@props= nil
      end
      alias_method :attr_props, :props
      
      def props=(value)
        @@props = value
      end
      alias_method :attr_props=, :props=
      
      # An element in the cache
      const_set_lazy(:ProviderProperty) { Class.new do
        include_class_members Security
        
        attr_accessor :class_name
        alias_method :attr_class_name, :class_name
        undef_method :class_name
        alias_method :attr_class_name=, :class_name=
        undef_method :class_name=
        
        attr_accessor :provider
        alias_method :attr_provider, :provider
        undef_method :provider
        alias_method :attr_provider=, :provider=
        undef_method :provider=
        
        typesig { [] }
        def initialize
          @class_name = nil
          @provider = nil
        end
        
        private
        alias_method :initialize__provider_property, :initialize
      end }
      
      when_class_loaded do
        AccessController.do_privileged(# doPrivileged here because there are multiple
        # things in initialize that might require privs.
        # (the FileInputStream call and the File.exists call,
        # the securityPropFile call, etc)
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Security
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            initialize_
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
      
      typesig { [] }
      def initialize_
        self.attr_props = Properties.new
        loaded_props = false
        override_all = false
        # first load the system properties file
        # to determine the value of security.overridePropertiesFile
        prop_file = security_prop_file("java.security")
        if (prop_file.exists)
          is = nil
          begin
            fis = FileInputStream.new(prop_file)
            is = BufferedInputStream.new(fis)
            self.attr_props.load(is)
            loaded_props = true
            if (!(Sdebug).nil?)
              Sdebug.println("reading security properties file: " + RJava.cast_to_string(prop_file))
            end
          rescue IOException => e
            if (!(Sdebug).nil?)
              Sdebug.println("unable to load security properties from " + RJava.cast_to_string(prop_file))
              e.print_stack_trace
            end
          ensure
            if (!(is).nil?)
              begin
                is.close
              rescue IOException => ioe
                if (!(Sdebug).nil?)
                  Sdebug.println("unable to close input stream")
                end
              end
            end
          end
        end
        if ("true".equals_ignore_case(self.attr_props.get_property("security.overridePropertiesFile")))
          extra_prop_file = System.get_property("java.security.properties")
          if (!(extra_prop_file).nil? && extra_prop_file.starts_with("="))
            override_all = true
            extra_prop_file = RJava.cast_to_string(extra_prop_file.substring(1))
          end
          if (override_all)
            self.attr_props = Properties.new
            if (!(Sdebug).nil?)
              Sdebug.println("overriding other security properties files!")
            end
          end
          # now load the user-specified file so its values
          # will win if they conflict with the earlier values
          if (!(extra_prop_file).nil?)
            bis = nil
            begin
              prop_url = nil
              extra_prop_file = RJava.cast_to_string(PropertyExpander.expand(extra_prop_file))
              prop_file = JavaFile.new(extra_prop_file)
              if (prop_file.exists)
                prop_url = URL.new("file:" + RJava.cast_to_string(prop_file.get_canonical_path))
              else
                prop_url = URL.new(extra_prop_file)
              end
              bis = BufferedInputStream.new(prop_url.open_stream)
              self.attr_props.load(bis)
              loaded_props = true
              if (!(Sdebug).nil?)
                Sdebug.println("reading security properties file: " + RJava.cast_to_string(prop_url))
                if (override_all)
                  Sdebug.println("overriding other security properties files!")
                end
              end
            rescue JavaException => e
              if (!(Sdebug).nil?)
                Sdebug.println("unable to load security properties from " + extra_prop_file)
                e.print_stack_trace
              end
            ensure
              if (!(bis).nil?)
                begin
                  bis.close
                rescue IOException => ioe
                  if (!(Sdebug).nil?)
                    Sdebug.println("unable to close input stream")
                  end
                end
              end
            end
          end
        end
        if (!loaded_props)
          initialize_static
          if (!(Sdebug).nil?)
            Sdebug.println("unable to load security properties " + "-- using defaults")
          end
        end
      end
      
      typesig { [] }
      # Initialize to default values, if <java.home>/lib/java.security
      # is not found.
      def initialize_static
        self.attr_props.put("security.provider.1", "sun.security.provider.Sun")
        self.attr_props.put("security.provider.2", "sun.security.rsa.SunRsaSign")
        self.attr_props.put("security.provider.3", "com.sun.net.ssl.internal.ssl.Provider")
        self.attr_props.put("security.provider.4", "com.sun.crypto.provider.SunJCE")
        self.attr_props.put("security.provider.5", "sun.security.jgss.SunProvider")
        self.attr_props.put("security.provider.6", "com.sun.security.sasl.Provider")
      end
    }
    
    typesig { [] }
    # Don't let anyone instantiate this.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      def security_prop_file(filename)
        # maybe check for a system property which will specify where to
        # look. Someday.
        sep = JavaFile.attr_separator
        return JavaFile.new(RJava.cast_to_string(System.get_property("java.home")) + sep + "lib" + sep + "security" + sep + filename)
      end
      
      typesig { [String] }
      # Looks up providers, and returns the property (and its associated
      # provider) mapping the key, if any.
      # The order in which the providers are looked up is the
      # provider-preference order, as specificed in the security
      # properties file.
      def get_provider_property(key)
        entry = nil
        providers = Providers.get_provider_list.providers
        i = 0
        while i < providers.size
          match_key = nil
          prov = providers.get(i)
          prop = prov.get_property(key)
          if ((prop).nil?)
            # Is there a match if we do a case-insensitive property name
            # comparison? Let's try ...
            e = prov.keys
            while e.has_more_elements && (prop).nil?
              match_key = RJava.cast_to_string(e.next_element)
              if (key.equals_ignore_case(match_key))
                prop = RJava.cast_to_string(prov.get_property(match_key))
                break
              end
            end
          end
          if (!(prop).nil?)
            new_entry = ProviderProperty.new
            new_entry.attr_class_name = prop
            new_entry.attr_provider = prov
            return new_entry
          end
          i += 1
        end
        return entry
      end
      
      typesig { [String, Provider] }
      # Returns the property (if any) mapping the key for the given provider.
      def get_provider_property(key, provider)
        prop = provider.get_property(key)
        if ((prop).nil?)
          # Is there a match if we do a case-insensitive property name
          # comparison? Let's try ...
          e = provider.keys
          while e.has_more_elements && (prop).nil?
            match_key = e.next_element
            if (key.equals_ignore_case(match_key))
              prop = RJava.cast_to_string(provider.get_property(match_key))
              break
            end
          end
        end
        return prop
      end
      
      typesig { [String, String] }
      # Gets a specified property for an algorithm. The algorithm name
      # should be a standard name. See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # One possible use is by specialized algorithm parsers, which may map
      # classes to algorithms which they understand (much like Key parsers
      # do).
      # 
      # @param algName the algorithm name.
      # 
      # @param propName the name of the property to get.
      # 
      # @return the value of the specified property.
      # 
      # @deprecated This method used to return the value of a proprietary
      # property in the master file of the "SUN" Cryptographic Service
      # Provider in order to determine how to parse algorithm-specific
      # parameters. Use the new provider-based and algorithm-independent
      # <code>AlgorithmParameters</code> and <code>KeyFactory</code> engine
      # classes (introduced in the J2SE version 1.2 platform) instead.
      def get_algorithm_property(alg_name, prop_name)
        entry = get_provider_property("Alg." + prop_name + "." + alg_name)
        if (!(entry).nil?)
          return entry.attr_class_name
        else
          return nil
        end
      end
      
      typesig { [Provider, ::Java::Int] }
      # Adds a new provider, at a specified position. The position is
      # the preference order in which providers are searched for
      # requested algorithms.  The position is 1-based, that is,
      # 1 is most preferred, followed by 2, and so on.
      # 
      # <p>If the given provider is installed at the requested position,
      # the provider that used to be at that position, and all providers
      # with a position greater than <code>position</code>, are shifted up
      # one position (towards the end of the list of installed providers).
      # 
      # <p>A provider cannot be added if it is already installed.
      # 
      # <p>First, if there is a security manager, its
      # <code>checkSecurityAccess</code>
      # method is called with the string
      # <code>"insertProvider."+provider.getName()</code>
      # to see if it's ok to add a new provider.
      # If the default implementation of <code>checkSecurityAccess</code>
      # is used (i.e., that method is not overriden), then this will result in
      # a call to the security manager's <code>checkPermission</code> method
      # with a
      # <code>SecurityPermission("insertProvider."+provider.getName())</code>
      # permission.
      # 
      # @param provider the provider to be added.
      # 
      # @param position the preference position that the caller would
      # like for this provider.
      # 
      # @return the actual preference position in which the provider was
      # added, or -1 if the provider was not added because it is
      # already installed.
      # 
      # @throws  NullPointerException if provider is null
      # @throws  SecurityException
      # if a security manager exists and its <code>{@link
      # java.lang.SecurityManager#checkSecurityAccess}</code> method
      # denies access to add a new provider
      # 
      # @see #getProvider
      # @see #removeProvider
      # @see java.security.SecurityPermission
      def insert_provider_at(provider, position)
        synchronized(self) do
          provider_name = provider.get_name
          check("insertProvider." + provider_name)
          list = Providers.get_full_provider_list
          new_list = ProviderList.insert_at(list, provider, position - 1)
          if ((list).equal?(new_list))
            return -1
          end
          Providers.set_provider_list(new_list)
          return new_list.get_index(provider_name) + 1
        end
      end
      
      typesig { [Provider] }
      # Adds a provider to the next position available.
      # 
      # <p>First, if there is a security manager, its
      # <code>checkSecurityAccess</code>
      # method is called with the string
      # <code>"insertProvider."+provider.getName()</code>
      # to see if it's ok to add a new provider.
      # If the default implementation of <code>checkSecurityAccess</code>
      # is used (i.e., that method is not overriden), then this will result in
      # a call to the security manager's <code>checkPermission</code> method
      # with a
      # <code>SecurityPermission("insertProvider."+provider.getName())</code>
      # permission.
      # 
      # @param provider the provider to be added.
      # 
      # @return the preference position in which the provider was
      # added, or -1 if the provider was not added because it is
      # already installed.
      # 
      # @throws  NullPointerException if provider is null
      # @throws  SecurityException
      # if a security manager exists and its <code>{@link
      # java.lang.SecurityManager#checkSecurityAccess}</code> method
      # denies access to add a new provider
      # 
      # @see #getProvider
      # @see #removeProvider
      # @see java.security.SecurityPermission
      def add_provider(provider)
        # We can't assign a position here because the statically
        # registered providers may not have been installed yet.
        # insertProviderAt() will fix that value after it has
        # loaded the static providers.
        return insert_provider_at(provider, 0)
      end
      
      typesig { [String] }
      # Removes the provider with the specified name.
      # 
      # <p>When the specified provider is removed, all providers located
      # at a position greater than where the specified provider was are shifted
      # down one position (towards the head of the list of installed
      # providers).
      # 
      # <p>This method returns silently if the provider is not installed or
      # if name is null.
      # 
      # <p>First, if there is a security manager, its
      # <code>checkSecurityAccess</code>
      # method is called with the string <code>"removeProvider."+name</code>
      # to see if it's ok to remove the provider.
      # If the default implementation of <code>checkSecurityAccess</code>
      # is used (i.e., that method is not overriden), then this will result in
      # a call to the security manager's <code>checkPermission</code> method
      # with a <code>SecurityPermission("removeProvider."+name)</code>
      # permission.
      # 
      # @param name the name of the provider to remove.
      # 
      # @throws  SecurityException
      # if a security manager exists and its <code>{@link
      # java.lang.SecurityManager#checkSecurityAccess}</code> method
      # denies
      # access to remove the provider
      # 
      # @see #getProvider
      # @see #addProvider
      def remove_provider(name)
        synchronized(self) do
          check("removeProvider." + name)
          list = Providers.get_full_provider_list
          new_list = ProviderList.remove(list, name)
          Providers.set_provider_list(new_list)
        end
      end
      
      typesig { [] }
      # Returns an array containing all the installed providers. The order of
      # the providers in the array is their preference order.
      # 
      # @return an array of all the installed providers.
      def get_providers
        return Providers.get_full_provider_list.to_array
      end
      
      typesig { [String] }
      # Returns the provider installed with the specified name, if
      # any. Returns null if no provider with the specified name is
      # installed or if name is null.
      # 
      # @param name the name of the provider to get.
      # 
      # @return the provider of the specified name.
      # 
      # @see #removeProvider
      # @see #addProvider
      def get_provider(name)
        return Providers.get_provider_list.get_provider(name)
      end
      
      typesig { [String] }
      # Returns an array containing all installed providers that satisfy the
      # specified selection criterion, or null if no such providers have been
      # installed. The returned providers are ordered
      # according to their <a href=
      # "#insertProviderAt(java.security.Provider, int)">preference order</a>.
      # 
      # <p> A cryptographic service is always associated with a particular
      # algorithm or type. For example, a digital signature service is
      # always associated with a particular algorithm (e.g., DSA),
      # and a CertificateFactory service is always associated with
      # a particular certificate type (e.g., X.509).
      # 
      # <p>The selection criterion must be specified in one of the following two
      # formats:
      # <ul>
      # <li> <i>&lt;crypto_service>.&lt;algorithm_or_type></i> <p> The
      # cryptographic service name must not contain any dots.
      # <p> A
      # provider satisfies the specified selection criterion iff the provider
      # implements the
      # specified algorithm or type for the specified cryptographic service.
      # <p> For example, "CertificateFactory.X.509"
      # would be satisfied by any provider that supplied
      # a CertificateFactory implementation for X.509 certificates.
      # <li> <i>&lt;crypto_service>.&lt;algorithm_or_type>
      # &lt;attribute_name>:&lt attribute_value></i>
      # <p> The cryptographic service name must not contain any dots. There
      # must be one or more space charaters between the the
      # <i>&lt;algorithm_or_type></i> and the <i>&lt;attribute_name></i>.
      # <p> A provider satisfies this selection criterion iff the
      # provider implements the specified algorithm or type for the specified
      # cryptographic service and its implementation meets the
      # constraint expressed by the specified attribute name/value pair.
      # <p> For example, "Signature.SHA1withDSA KeySize:1024" would be
      # satisfied by any provider that implemented
      # the SHA1withDSA signature algorithm with a keysize of 1024 (or larger).
      # 
      # </ul>
      # 
      # <p> See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard cryptographic service names, standard
      # algorithm names and standard attribute names.
      # 
      # @param filter the criterion for selecting
      # providers. The filter is case-insensitive.
      # 
      # @return all the installed providers that satisfy the selection
      # criterion, or null if no such providers have been installed.
      # 
      # @throws InvalidParameterException
      # if the filter is not in the required format
      # @throws NullPointerException if filter is null
      # 
      # @see #getProviders(java.util.Map)
      # @since 1.3
      def get_providers(filter)
        key = nil
        value = nil
        index = filter.index_of(Character.new(?:.ord))
        if ((index).equal?(-1))
          key = filter
          value = ""
        else
          key = RJava.cast_to_string(filter.substring(0, index))
          value = RJava.cast_to_string(filter.substring(index + 1))
        end
        hashtable_filter = Hashtable.new(1)
        hashtable_filter.put(key, value)
        return (get_providers(hashtable_filter))
      end
      
      typesig { [Map] }
      # Returns an array containing all installed providers that satisfy the
      # specified* selection criteria, or null if no such providers have been
      # installed. The returned providers are ordered
      # according to their <a href=
      # "#insertProviderAt(java.security.Provider, int)">preference order</a>.
      # 
      # <p>The selection criteria are represented by a map.
      # Each map entry represents a selection criterion.
      # A provider is selected iff it satisfies all selection
      # criteria. The key for any entry in such a map must be in one of the
      # following two formats:
      # <ul>
      # <li> <i>&lt;crypto_service>.&lt;algorithm_or_type></i>
      # <p> The cryptographic service name must not contain any dots.
      # <p> The value associated with the key must be an empty string.
      # <p> A provider
      # satisfies this selection criterion iff the provider implements the
      # specified algorithm or type for the specified cryptographic service.
      # <li>  <i>&lt;crypto_service>.&lt;algorithm_or_type> &lt;attribute_name></i>
      # <p> The cryptographic service name must not contain any dots. There
      # must be one or more space charaters between the <i>&lt;algorithm_or_type></i>
      # and the <i>&lt;attribute_name></i>.
      # <p> The value associated with the key must be a non-empty string.
      # A provider satisfies this selection criterion iff the
      # provider implements the specified algorithm or type for the specified
      # cryptographic service and its implementation meets the
      # constraint expressed by the specified attribute name/value pair.
      # </ul>
      # 
      # <p> See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard cryptographic service names, standard
      # algorithm names and standard attribute names.
      # 
      # @param filter the criteria for selecting
      # providers. The filter is case-insensitive.
      # 
      # @return all the installed providers that satisfy the selection
      # criteria, or null if no such providers have been installed.
      # 
      # @throws InvalidParameterException
      # if the filter is not in the required format
      # @throws NullPointerException if filter is null
      # 
      # @see #getProviders(java.lang.String)
      # @since 1.3
      def get_providers(filter)
        # Get all installed providers first.
        # Then only return those providers who satisfy the selection criteria.
        all_providers = Security.get_providers
        key_set_ = filter.key_set
        candidates = LinkedHashSet.new(5)
        # Returns all installed providers
        # if the selection criteria is null.
        if (((key_set_).nil?) || ((all_providers).nil?))
          return all_providers
        end
        first_search = true
        # For each selection criterion, remove providers
        # which don't satisfy the criterion from the candidate set.
        ite = key_set_.iterator
        while ite.has_next
          key = ite.next_
          value = filter.get(key)
          new_candidates = get_all_qualifying_candidates(key, value, all_providers)
          if (first_search)
            candidates = new_candidates
            first_search = false
          end
          if ((!(new_candidates).nil?) && !new_candidates.is_empty)
            # For each provider in the candidates set, if it
            # isn't in the newCandidate set, we should remove
            # it from the candidate set.
            cans_ite = candidates.iterator
            while cans_ite.has_next
              prov = cans_ite.next_
              if (!new_candidates.contains(prov))
                cans_ite.remove
              end
            end
          else
            candidates = nil
            break
          end
        end
        if (((candidates).nil?) || (candidates.is_empty))
          return nil
        end
        candidates_array = candidates.to_array
        result = Array.typed(Provider).new(candidates_array.attr_length) { nil }
        i = 0
        while i < result.attr_length
          result[i] = candidates_array[i]
          i += 1
        end
        return result
      end
      
      # Map containing cached Spi Class objects of the specified type
      const_set_lazy(:SpiMap) { ConcurrentHashMap.new }
      const_attr_reader  :SpiMap
      
      typesig { [String] }
      # Return the Class object for the given engine type
      # (e.g. "MessageDigest"). Works for Spis in the java.security package
      # only.
      def get_spi_class(type)
        clazz = SpiMap.get(type)
        if (!(clazz).nil?)
          return clazz
        end
        begin
          clazz = Class.for_name("java.security." + type + "Spi")
          SpiMap.put(type, clazz)
          return clazz
        rescue ClassNotFoundException => e
          raise AssertionError.new("Spi class not found").init_cause(e)
        end
      end
      
      typesig { [String, String, String] }
      # Returns an array of objects: the first object in the array is
      # an instance of an implementation of the requested algorithm
      # and type, and the second object in the array identifies the provider
      # of that implementation.
      # The <code>provider</code> argument can be null, in which case all
      # configured providers will be searched in order of preference.
      def get_impl(algorithm, type, provider)
        if ((provider).nil?)
          return GetInstance.get_instance(type, get_spi_class(type), algorithm).to_array
        else
          return GetInstance.get_instance(type, get_spi_class(type), algorithm, provider).to_array
        end
      end
      
      typesig { [String, String, String, Object] }
      def get_impl(algorithm, type, provider, params)
        if ((provider).nil?)
          return GetInstance.get_instance(type, get_spi_class(type), algorithm, params).to_array
        else
          return GetInstance.get_instance(type, get_spi_class(type), algorithm, params, provider).to_array
        end
      end
      
      typesig { [String, String, Provider] }
      # Returns an array of objects: the first object in the array is
      # an instance of an implementation of the requested algorithm
      # and type, and the second object in the array identifies the provider
      # of that implementation.
      # The <code>provider</code> argument cannot be null.
      def get_impl(algorithm, type, provider)
        return GetInstance.get_instance(type, get_spi_class(type), algorithm, provider).to_array
      end
      
      typesig { [String, String, Provider, Object] }
      def get_impl(algorithm, type, provider, params)
        return GetInstance.get_instance(type, get_spi_class(type), algorithm, params, provider).to_array
      end
      
      typesig { [String] }
      # Gets a security property value.
      # 
      # <p>First, if there is a security manager, its
      # <code>checkPermission</code>  method is called with a
      # <code>java.security.SecurityPermission("getProperty."+key)</code>
      # permission to see if it's ok to retrieve the specified
      # security property value..
      # 
      # @param key the key of the property being retrieved.
      # 
      # @return the value of the security property corresponding to key.
      # 
      # @throws  SecurityException
      # if a security manager exists and its <code>{@link
      # java.lang.SecurityManager#checkPermission}</code> method
      # denies
      # access to retrieve the specified security property value
      # @throws  NullPointerException is key is null
      # 
      # @see #setProperty
      # @see java.security.SecurityPermission
      def get_property(key)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(SecurityPermission.new("getProperty." + key))
        end
        name = self.attr_props.get_property(key)
        if (!(name).nil?)
          name = RJava.cast_to_string(name.trim)
        end # could be a class name with trailing ws
        return name
      end
      
      typesig { [String, String] }
      # Sets a security property value.
      # 
      # <p>First, if there is a security manager, its
      # <code>checkPermission</code> method is called with a
      # <code>java.security.SecurityPermission("setProperty."+key)</code>
      # permission to see if it's ok to set the specified
      # security property value.
      # 
      # @param key the name of the property to be set.
      # 
      # @param datum the value of the property to be set.
      # 
      # @throws  SecurityException
      # if a security manager exists and its <code>{@link
      # java.lang.SecurityManager#checkPermission}</code> method
      # denies access to set the specified security property value
      # @throws  NullPointerException if key or datum is null
      # 
      # @see #getProperty
      # @see java.security.SecurityPermission
      def set_property(key, datum)
        check("setProperty." + key)
        self.attr_props.put(key, datum)
        invalidate_smcache(key)
        # See below.
      end
      
      typesig { [String] }
      # Implementation detail:  If the property we just set in
      # setProperty() was either "package.access" or
      # "package.definition", we need to signal to the SecurityManager
      # class that the value has just changed, and that it should
      # invalidate it's local cache values.
      # 
      # Rather than create a new API entry for this function,
      # we use reflection to set a private variable.
      def invalidate_smcache(key)
        pa = (key == "package.access")
        pd = (key == "package.definition")
        if (pa || pd)
          # run
          AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members Security
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                # Get the class via the bootstrap class loader.
                cl = Class.for_name("java.lang.SecurityManager", false, nil)
                f = nil
                accessible = false
                if (pa)
                  f = cl.get_declared_field("packageAccessValid")
                  accessible = f.is_accessible
                  f.set_accessible(true)
                else
                  f = cl.get_declared_field("packageDefinitionValid")
                  accessible = f.is_accessible
                  f.set_accessible(true)
                end
                f.set_boolean(f, false)
                f.set_accessible(accessible)
              rescue self.class::JavaException => e1
                # If we couldn't get the class, it hasn't
                # been loaded yet.  If there is no such
                # field, we shouldn't try to set it.  There
                # shouldn't be a security execption, as we
                # are loaded by boot class loader, and we
                # are inside a doPrivileged() here.
                # 
                # NOOP: don't do anything...
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
          # PrivilegedAction
        end
        # if
      end
      
      typesig { [String] }
      def check(directive)
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_security_access(directive)
        end
      end
      
      typesig { [String, String, Array.typed(Provider)] }
      # Returns all providers who satisfy the specified
      # criterion.
      def get_all_qualifying_candidates(filter_key, filter_value, all_providers)
        filter_components = get_filter_components(filter_key, filter_value)
        # The first component is the service name.
        # The second is the algorithm name.
        # If the third isn't null, that is the attrinute name.
        service_name = filter_components[0]
        alg_name = filter_components[1]
        attr_name = filter_components[2]
        return get_providers_not_using_cache(service_name, alg_name, attr_name, filter_value, all_providers)
      end
      
      typesig { [String, String, String, String, Array.typed(Provider)] }
      def get_providers_not_using_cache(service_name, alg_name, attr_name, filter_value, all_providers)
        candidates = LinkedHashSet.new(5)
        i = 0
        while i < all_providers.attr_length
          if (is_criterion_satisfied(all_providers[i], service_name, alg_name, attr_name, filter_value))
            candidates.add(all_providers[i])
          end
          i += 1
        end
        return candidates
      end
      
      typesig { [Provider, String, String, String, String] }
      # Returns true if the given provider satisfies
      # the selection criterion key:value.
      def is_criterion_satisfied(prov, service_name, alg_name, attr_name, filter_value)
        key = service_name + RJava.cast_to_string(Character.new(?..ord)) + alg_name
        if (!(attr_name).nil?)
          key += RJava.cast_to_string(Character.new(?\s.ord)) + attr_name
        end
        # Check whether the provider has a property
        # whose key is the same as the given key.
        prop_value = get_provider_property(key, prov)
        if ((prop_value).nil?)
          # Check whether we have an alias instead
          # of a standard name in the key.
          standard_name = get_provider_property("Alg.Alias." + service_name + "." + alg_name, prov)
          if (!(standard_name).nil?)
            key = service_name + "." + standard_name
            if (!(attr_name).nil?)
              key += RJava.cast_to_string(Character.new(?\s.ord)) + attr_name
            end
            prop_value = RJava.cast_to_string(get_provider_property(key, prov))
          end
          if ((prop_value).nil?)
            # The provider doesn't have the given
            # key in its property list.
            return false
          end
        end
        # If the key is in the format of:
        # <crypto_service>.<algorithm_or_type>,
        # there is no need to check the value.
        if ((attr_name).nil?)
          return true
        end
        # If we get here, the key must be in the
        # format of <crypto_service>.<algorithm_or_provider> <attribute_name>.
        if (is_standard_attr(attr_name))
          return is_constraint_satisfied(attr_name, filter_value, prop_value)
        else
          return filter_value.equals_ignore_case(prop_value)
        end
      end
      
      typesig { [String] }
      # Returns true if the attribute is a standard attribute;
      # otherwise, returns false.
      def is_standard_attr(attribute)
        # For now, we just have two standard attributes:
        # KeySize and ImplementedIn.
        if (attribute.equals_ignore_case("KeySize"))
          return true
        end
        if (attribute.equals_ignore_case("ImplementedIn"))
          return true
        end
        return false
      end
      
      typesig { [String, String, String] }
      # Returns true if the requested attribute value is supported;
      # otherwise, returns false.
      def is_constraint_satisfied(attribute, value, prop)
        # For KeySize, prop is the max key size the
        # provider supports for a specific <crypto_service>.<algorithm>.
        if (attribute.equals_ignore_case("KeySize"))
          requested_size = JavaInteger.parse_int(value)
          max_size = JavaInteger.parse_int(prop)
          if (requested_size <= max_size)
            return true
          else
            return false
          end
        end
        # For Type, prop is the type of the implementation
        # for a specific <crypto service>.<algorithm>.
        if (attribute.equals_ignore_case("ImplementedIn"))
          return value.equals_ignore_case(prop)
        end
        return false
      end
      
      typesig { [String, String] }
      def get_filter_components(filter_key, filter_value)
        alg_index = filter_key.index_of(Character.new(?..ord))
        if (alg_index < 0)
          # There must be a dot in the filter, and the dot
          # shouldn't be at the beginning of this string.
          raise InvalidParameterException.new("Invalid filter")
        end
        service_name = filter_key.substring(0, alg_index)
        alg_name = nil
        attr_name = nil
        if ((filter_value.length).equal?(0))
          # The filterValue is an empty string. So the filterKey
          # should be in the format of <crypto_service>.<algorithm_or_type>.
          alg_name = RJava.cast_to_string(filter_key.substring(alg_index + 1).trim)
          if ((alg_name.length).equal?(0))
            # There must be a algorithm or type name.
            raise InvalidParameterException.new("Invalid filter")
          end
        else
          # The filterValue is a non-empty string. So the filterKey must be
          # in the format of
          # <crypto_service>.<algorithm_or_type> <attribute_name>
          attr_index = filter_key.index_of(Character.new(?\s.ord))
          if ((attr_index).equal?(-1))
            # There is no attribute name in the filter.
            raise InvalidParameterException.new("Invalid filter")
          else
            attr_name = RJava.cast_to_string(filter_key.substring(attr_index + 1).trim)
            if ((attr_name.length).equal?(0))
              # There is no attribute name in the filter.
              raise InvalidParameterException.new("Invalid filter")
            end
          end
          # There must be an algorithm name in the filter.
          if ((attr_index < alg_index) || ((alg_index).equal?(attr_index - 1)))
            raise InvalidParameterException.new("Invalid filter")
          else
            alg_name = RJava.cast_to_string(filter_key.substring(alg_index + 1, attr_index))
          end
        end
        result = Array.typed(String).new(3) { nil }
        result[0] = service_name
        result[1] = alg_name
        result[2] = attr_name
        return result
      end
      
      typesig { [String] }
      # Returns a Set of Strings containing the names of all available
      # algorithms or types for the specified Java cryptographic service
      # (e.g., Signature, MessageDigest, Cipher, Mac, KeyStore). Returns
      # an empty Set if there is no provider that supports the
      # specified service or if serviceName is null. For a complete list
      # of Java cryptographic services, please see the
      # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html">Java
      # Cryptography Architecture API Specification &amp; Reference</a>.
      # Note: the returned set is immutable.
      # 
      # @param serviceName the name of the Java cryptographic
      # service (e.g., Signature, MessageDigest, Cipher, Mac, KeyStore).
      # Note: this parameter is case-insensitive.
      # 
      # @return a Set of Strings containing the names of all available
      # algorithms or types for the specified Java cryptographic service
      # or an empty set if no provider supports the specified service.
      # 
      # @since 1.4
      def get_algorithms(service_name)
        if (((service_name).nil?) || ((service_name.length).equal?(0)) || (service_name.ends_with(".")))
          return Collections::EMPTY_SET
        end
        result = HashSet.new
        providers = Security.get_providers
        i = 0
        while i < providers.attr_length
          # Check the keys for each provider.
          e = providers[i].keys
          while e.has_more_elements
            current_key = (e.next_element).to_upper_case
            if (current_key.starts_with(service_name.to_upper_case))
              # We should skip the currentKey if it contains a
              # whitespace. The reason is: such an entry in the
              # provider property contains attributes for the
              # implementation of an algorithm. We are only interested
              # in entries which lead to the implementation
              # classes.
              if (current_key.index_of(" ") < 0)
                result.add(current_key.substring(service_name.length + 1))
              end
            end
          end
          i += 1
        end
        return Collections.unmodifiable_set(result)
      end
    }
    
    private
    alias_method :initialize__security, :initialize
  end
  
end
