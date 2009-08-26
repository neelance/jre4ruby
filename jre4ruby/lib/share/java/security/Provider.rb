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
  module ProviderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include ::Java::Util
      include_const ::Java::Util::Locale, :ENGLISH
      include ::Java::Lang::Ref
      include ::Java::Lang::Reflect
      include_const ::Java::Security::Cert, :CertStoreParameters
      include_const ::Javax::Security::Auth::Login, :Configuration
    }
  end
  
  # This class represents a "provider" for the
  # Java Security API, where a provider implements some or all parts of
  # Java Security. Services that a provider may implement include:
  # 
  # <ul>
  # 
  # <li>Algorithms (such as DSA, RSA, MD5 or SHA-1).
  # 
  # <li>Key generation, conversion, and management facilities (such as for
  # algorithm-specific keys).
  # 
  # </ul>
  # 
  # <p>Each provider has a name and a version number, and is configured
  # in each runtime it is installed in.
  # 
  # <p>See <a href =
  # "../../../technotes/guides/security/crypto/CryptoSpec.html#Provider">The Provider Class</a>
  # in the "Java Cryptography Architecture API Specification &amp; Reference"
  # for information about how a particular type of provider, the
  # cryptographic service provider, works and is installed. However,
  # please note that a provider can be used to implement any security
  # service in Java that uses a pluggable architecture with a choice
  # of implementations that fit underneath.
  # 
  # <p>Some provider implementations may encounter unrecoverable internal
  # errors during their operation, for example a failure to communicate with a
  # security token. A {@link ProviderException} should be used to indicate
  # such errors.
  # 
  # <p>The service type <code>Provider</code> is reserved for use by the
  # security framework. Services of this type cannot be added, removed,
  # or modified by applications.
  # The following attributes are automatically placed in each Provider object:
  # <table cellspacing=4>
  # <tr><th>Name</th><th>Value</th>
  # <tr><td><code>Provider.id name</code></td>
  # <td><code>String.valueOf(provider.getName())</code></td>
  # <tr><td><code>Provider.id version</code></td>
  # <td><code>String.valueOf(provider.getVersion())</code></td>
  # <tr><td><code>Provider.id info</code></td>
  # <td><code>String.valueOf(provider.getInfo())</code></td>
  # <tr><td><code>Provider.id className</code></td>
  # <td><code>provider.getClass().getName()</code></td>
  # </table>
  # 
  # @author Benjamin Renaud
  # @author Andreas Sterbenz
  class Provider < ProviderImports.const_get :Properties
    include_class_members ProviderImports
    
    class_module.module_eval {
      # Declare serialVersionUID to be compatible with JDK1.1
      const_set_lazy(:SerialVersionUID) { -4298000515446427739 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:Debug) { Sun::Security::Util::Debug.get_instance("provider", "Provider") }
      const_attr_reader  :Debug
    }
    
    # The provider name.
    # 
    # @serial
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # A description of the provider and its services.
    # 
    # @serial
    attr_accessor :info
    alias_method :attr_info, :info
    undef_method :info
    alias_method :attr_info=, :info=
    undef_method :info=
    
    # The provider version number.
    # 
    # @serial
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :entry_set
    alias_method :attr_entry_set, :entry_set
    undef_method :entry_set
    alias_method :attr_entry_set=, :entry_set=
    undef_method :entry_set=
    
    attr_accessor :entry_set_call_count
    alias_method :attr_entry_set_call_count, :entry_set_call_count
    undef_method :entry_set_call_count
    alias_method :attr_entry_set_call_count=, :entry_set_call_count=
    undef_method :entry_set_call_count=
    
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    typesig { [String, ::Java::Double, String] }
    # Constructs a provider with the specified name, version number,
    # and information.
    # 
    # @param name the provider name.
    # 
    # @param version the provider version number.
    # 
    # @param info a description of the provider and its services.
    def initialize(name, version, info)
      @name = nil
      @info = nil
      @version = 0.0
      @entry_set = nil
      @entry_set_call_count = 0
      @initialized = false
      @legacy_changed = false
      @services_changed = false
      @legacy_strings = nil
      @service_map = nil
      @legacy_map = nil
      @service_set = nil
      super()
      @entry_set = nil
      @entry_set_call_count = 0
      @name = name
      @version = version
      @info = info
      put_id
      @initialized = true
    end
    
    typesig { [] }
    # Returns the name of this provider.
    # 
    # @return the name of this provider.
    def get_name
      return @name
    end
    
    typesig { [] }
    # Returns the version number for this provider.
    # 
    # @return the version number for this provider.
    def get_version
      return @version
    end
    
    typesig { [] }
    # Returns a human-readable description of the provider and its
    # services.  This may return an HTML page, with relevant links.
    # 
    # @return a description of the provider and its services.
    def get_info
      return @info
    end
    
    typesig { [] }
    # Returns a string with the name and the version number
    # of this provider.
    # 
    # @return the string with the name and the version number
    # for this provider.
    def to_s
      return @name + " version " + RJava.cast_to_string(@version)
    end
    
    typesig { [] }
    # override the following methods to ensure that provider
    # information can only be changed if the caller has the appropriate
    # permissions.
    # 
    # 
    # Clears this provider so that it no longer contains the properties
    # used to look up facilities implemented by the provider.
    # 
    # <p>First, if there is a security manager, its
    # <code>checkSecurityAccess</code> method is called with the string
    # <code>"clearProviderProperties."+name</code> (where <code>name</code>
    # is the provider name) to see if it's ok to clear this provider.
    # If the default implementation of <code>checkSecurityAccess</code>
    # is used (that is, that method is not overriden), then this results in
    # a call to the security manager's <code>checkPermission</code> method
    # with a <code>SecurityPermission("clearProviderProperties."+name)</code>
    # permission.
    # 
    # @throws  SecurityException
    # if a security manager exists and its <code>{@link
    # java.lang.SecurityManager#checkSecurityAccess}</code> method
    # denies access to clear this provider
    # 
    # @since 1.2
    def clear
      synchronized(self) do
        check("clearProviderProperties." + @name)
        if (!(Debug).nil?)
          Debug.println("Remove " + @name + " provider properties")
        end
        impl_clear
      end
    end
    
    typesig { [InputStream] }
    # Reads a property list (key and element pairs) from the input stream.
    # 
    # @param inStream   the input stream.
    # @exception  IOException  if an error occurred when reading from the
    # input stream.
    # @see java.util.Properties#load
    def load(in_stream)
      synchronized(self) do
        check("putProviderProperty." + @name)
        if (!(Debug).nil?)
          Debug.println("Load " + @name + " provider properties")
        end
        temp_properties = Properties.new
        temp_properties.load(in_stream)
        impl_put_all(temp_properties)
      end
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified Map to this provider.
    # These mappings will replace any properties that this provider had
    # for any of the keys currently in the specified Map.
    # 
    # @since 1.2
    def put_all(t)
      synchronized(self) do
        check("putProviderProperty." + @name)
        if (!(Debug).nil?)
          Debug.println("Put all " + @name + " provider properties")
        end
        impl_put_all(t)
      end
    end
    
    typesig { [] }
    # Returns an unmodifiable Set view of the property entries contained
    # in this Provider.
    # 
    # @see   java.util.Map.Entry
    # @since 1.2
    def entry_set
      synchronized(self) do
        check_initialized
        if ((@entry_set).nil?)
          if ((((@entry_set_call_count += 1) - 1)).equal?(0))
            # Initial call
            @entry_set = Collections.unmodifiable_map(self).entry_set
          else
            return super
          end # Recursive call
        end
        # This exception will be thrown if the implementation of
        # Collections.unmodifiableMap.entrySet() is changed such that it
        # no longer calls entrySet() on the backing Map.  (Provider's
        # entrySet implementation depends on this "implementation detail",
        # which is unlikely to change.
        if (!(@entry_set_call_count).equal?(2))
          raise RuntimeException.new("Internal error.")
        end
        return @entry_set
      end
    end
    
    typesig { [] }
    # Returns an unmodifiable Set view of the property keys contained in
    # this provider.
    # 
    # @since 1.2
    def key_set
      check_initialized
      return Collections.unmodifiable_set(super)
    end
    
    typesig { [] }
    # Returns an unmodifiable Collection view of the property values
    # contained in this provider.
    # 
    # @since 1.2
    def values
      check_initialized
      return Collections.unmodifiable_collection(super)
    end
    
    typesig { [Object, Object] }
    # Sets the <code>key</code> property to have the specified
    # <code>value</code>.
    # 
    # <p>First, if there is a security manager, its
    # <code>checkSecurityAccess</code> method is called with the string
    # <code>"putProviderProperty."+name</code>, where <code>name</code> is the
    # provider name, to see if it's ok to set this provider's property values.
    # If the default implementation of <code>checkSecurityAccess</code>
    # is used (that is, that method is not overriden), then this results in
    # a call to the security manager's <code>checkPermission</code> method
    # with a <code>SecurityPermission("putProviderProperty."+name)</code>
    # permission.
    # 
    # @param key the property key.
    # 
    # @param value the property value.
    # 
    # @return the previous value of the specified property
    # (<code>key</code>), or null if it did not have one.
    # 
    # @throws  SecurityException
    # if a security manager exists and its <code>{@link
    # java.lang.SecurityManager#checkSecurityAccess}</code> method
    # denies access to set property values.
    # 
    # @since 1.2
    def put(key, value)
      synchronized(self) do
        check("putProviderProperty." + @name)
        if (!(Debug).nil?)
          Debug.println("Set " + @name + " provider property [" + RJava.cast_to_string(key) + "/" + RJava.cast_to_string(value) + "]")
        end
        return impl_put(key, value)
      end
    end
    
    typesig { [Object] }
    # Removes the <code>key</code> property (and its corresponding
    # <code>value</code>).
    # 
    # <p>First, if there is a security manager, its
    # <code>checkSecurityAccess</code> method is called with the string
    # <code>"removeProviderProperty."+name</code>, where <code>name</code> is
    # the provider name, to see if it's ok to remove this provider's
    # properties. If the default implementation of
    # <code>checkSecurityAccess</code> is used (that is, that method is not
    # overriden), then this results in a call to the security manager's
    # <code>checkPermission</code> method with a
    # <code>SecurityPermission("removeProviderProperty."+name)</code>
    # permission.
    # 
    # @param key the key for the property to be removed.
    # 
    # @return the value to which the key had been mapped,
    # or null if the key did not have a mapping.
    # 
    # @throws  SecurityException
    # if a security manager exists and its <code>{@link
    # java.lang.SecurityManager#checkSecurityAccess}</code> method
    # denies access to remove this provider's properties.
    # 
    # @since 1.2
    def remove(key)
      synchronized(self) do
        check("removeProviderProperty." + @name)
        if (!(Debug).nil?)
          Debug.println("Remove " + @name + " provider property " + RJava.cast_to_string(key))
        end
        return impl_remove(key)
      end
    end
    
    typesig { [Object] }
    # let javadoc show doc from superclass
    def get(key)
      check_initialized
      return super(key)
    end
    
    typesig { [] }
    # let javadoc show doc from superclass
    def keys
      check_initialized
      return super
    end
    
    typesig { [] }
    # let javadoc show doc from superclass
    def elements
      check_initialized
      return super
    end
    
    typesig { [String] }
    # let javadoc show doc from superclass
    def get_property(key)
      check_initialized
      return super(key)
    end
    
    typesig { [] }
    def check_initialized
      if (!@initialized)
        raise IllegalStateException.new
      end
    end
    
    typesig { [String] }
    def check(directive)
      check_initialized
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_security_access(directive)
      end
    end
    
    # legacy properties changed since last call to any services method?
    attr_accessor :legacy_changed
    alias_method :attr_legacy_changed, :legacy_changed
    undef_method :legacy_changed
    alias_method :attr_legacy_changed=, :legacy_changed=
    undef_method :legacy_changed=
    
    # serviceMap changed since last call to getServices()
    attr_accessor :services_changed
    alias_method :attr_services_changed, :services_changed
    undef_method :services_changed
    alias_method :attr_services_changed=, :services_changed=
    undef_method :services_changed=
    
    # Map<String,String>
    attr_accessor :legacy_strings
    alias_method :attr_legacy_strings, :legacy_strings
    undef_method :legacy_strings
    alias_method :attr_legacy_strings=, :legacy_strings=
    undef_method :legacy_strings=
    
    # Map<ServiceKey,Service>
    # used for services added via putService(), initialized on demand
    attr_accessor :service_map
    alias_method :attr_service_map, :service_map
    undef_method :service_map
    alias_method :attr_service_map=, :service_map=
    undef_method :service_map=
    
    # Map<ServiceKey,Service>
    # used for services added via legacy methods, init on demand
    attr_accessor :legacy_map
    alias_method :attr_legacy_map, :legacy_map
    undef_method :legacy_map
    alias_method :attr_legacy_map=, :legacy_map=
    undef_method :legacy_map=
    
    # Set<Service>
    # Unmodifiable set of all services. Initialized on demand.
    attr_accessor :service_set
    alias_method :attr_service_set, :service_set
    undef_method :service_set
    alias_method :attr_service_set=, :service_set=
    undef_method :service_set=
    
    typesig { [] }
    # register the id attributes for this provider
    # this is to ensure that equals() and hashCode() do not incorrectly
    # report to different provider objects as the same
    def put_id
      # note: name and info may be null
      Properties.instance_method(:put).bind(self).call("Provider.id name", String.value_of(@name))
      Properties.instance_method(:put).bind(self).call("Provider.id version", String.value_of(@version))
      Properties.instance_method(:put).bind(self).call("Provider.id info", String.value_of(@info))
      Properties.instance_method(:put).bind(self).call("Provider.id className", self.get_class.get_name)
    end
    
    typesig { [ObjectInputStream] }
    def read_object(in_)
      copy = HashMap.new
      Properties.instance_method(:entry_set).bind(self).call.each do |entry|
        copy.put(entry.get_key, entry.get_value)
      end
      self.attr_defaults = nil
      in_.default_read_object
      impl_clear
      @initialized = true
      put_all(copy)
    end
    
    typesig { [Map] }
    # Copies all of the mappings from the specified Map to this provider.
    # Internal method to be called AFTER the security check has been
    # performed.
    def impl_put_all(t)
      (t).entry_set.each do |e|
        impl_put(e.get_key, e.get_value)
      end
    end
    
    typesig { [Object] }
    def impl_remove(key)
      if (key.is_a?(String))
        key_string = key
        if (key_string.starts_with("Provider."))
          return nil
        end
        @legacy_changed = true
        if ((@legacy_strings).nil?)
          @legacy_strings = LinkedHashMap.new
        end
        @legacy_strings.remove(key_string)
      end
      return Properties.instance_method(:remove).bind(self).call(key)
    end
    
    typesig { [Object, Object] }
    def impl_put(key, value)
      if ((key.is_a?(String)) && (value.is_a?(String)))
        key_string = key
        if (key_string.starts_with("Provider."))
          return nil
        end
        @legacy_changed = true
        if ((@legacy_strings).nil?)
          @legacy_strings = LinkedHashMap.new
        end
        @legacy_strings.put(key_string, value)
      end
      return Properties.instance_method(:put).bind(self).call(key, value)
    end
    
    typesig { [] }
    def impl_clear
      if (!(@legacy_strings).nil?)
        @legacy_strings.clear
      end
      if (!(@legacy_map).nil?)
        @legacy_map.clear
      end
      if (!(@service_map).nil?)
        @service_map.clear
      end
      @legacy_changed = false
      @services_changed = false
      @service_set = nil
      Properties.instance_method(:clear).bind(self).call
      put_id
    end
    
    class_module.module_eval {
      # used as key in the serviceMap and legacyMap HashMaps
      const_set_lazy(:ServiceKey) { Class.new do
        include_class_members Provider
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :algorithm
        alias_method :attr_algorithm, :algorithm
        undef_method :algorithm
        alias_method :attr_algorithm=, :algorithm=
        undef_method :algorithm=
        
        attr_accessor :original_algorithm
        alias_method :attr_original_algorithm, :original_algorithm
        undef_method :original_algorithm
        alias_method :attr_original_algorithm=, :original_algorithm=
        undef_method :original_algorithm=
        
        typesig { [self::String, self::String, ::Java::Boolean] }
        def initialize(type, algorithm, intern)
          @type = nil
          @algorithm = nil
          @original_algorithm = nil
          @type = type
          @original_algorithm = algorithm
          algorithm = RJava.cast_to_string(algorithm.to_upper_case(ENGLISH))
          @algorithm = intern ? algorithm.intern : algorithm
        end
        
        typesig { [] }
        def hash_code
          return @type.hash_code + @algorithm.hash_code
        end
        
        typesig { [Object] }
        def ==(obj)
          if ((self).equal?(obj))
            return true
          end
          if ((obj.is_a?(self.class::ServiceKey)).equal?(false))
            return false
          end
          other = obj
          return (@type == other.attr_type) && (@algorithm == other.attr_algorithm)
        end
        
        typesig { [self::String, self::String] }
        def matches(type, algorithm)
          return ((@type).equal?(type)) && ((@original_algorithm).equal?(algorithm))
        end
        
        private
        alias_method :initialize__service_key, :initialize
      end }
    }
    
    typesig { [] }
    # Ensure all the legacy String properties are fully parsed into
    # service objects.
    def ensure_legacy_parsed
      if (((@legacy_changed).equal?(false)) || ((@legacy_strings).nil?))
        return
      end
      @service_set = nil
      if ((@legacy_map).nil?)
        @legacy_map = LinkedHashMap.new
      else
        @legacy_map.clear
      end
      @legacy_strings.entry_set.each do |entry|
        parse_legacy_put(entry.get_key, entry.get_value)
      end
      remove_invalid_services(@legacy_map)
      @legacy_changed = false
    end
    
    typesig { [Map] }
    # Remove all invalid services from the Map. Invalid services can only
    # occur if the legacy properties are inconsistent or incomplete.
    def remove_invalid_services(map)
      t = map.entry_set.iterator
      while t.has_next
        entry = t.next_
        s = entry.get_value
        if ((s.is_valid).equal?(false))
          t.remove
        end
      end
    end
    
    typesig { [String] }
    def get_type_and_algorithm(key)
      i = key.index_of(".")
      if (i < 1)
        if (!(Debug).nil?)
          Debug.println("Ignoring invalid entry in provider " + @name + ":" + key)
        end
        return nil
      end
      type = key.substring(0, i)
      alg = key.substring(i + 1)
      return Array.typed(String).new([type, alg])
    end
    
    class_module.module_eval {
      const_set_lazy(:ALIAS_PREFIX) { "Alg.Alias." }
      const_attr_reader  :ALIAS_PREFIX
      
      const_set_lazy(:ALIAS_PREFIX_LOWER) { "alg.alias." }
      const_attr_reader  :ALIAS_PREFIX_LOWER
      
      const_set_lazy(:ALIAS_LENGTH) { ALIAS_PREFIX.length }
      const_attr_reader  :ALIAS_LENGTH
    }
    
    typesig { [String, String] }
    def parse_legacy_put(name, value)
      if (name.to_lower_case(ENGLISH).starts_with(ALIAS_PREFIX_LOWER))
        # e.g. put("Alg.Alias.MessageDigest.SHA", "SHA-1");
        # aliasKey ~ MessageDigest.SHA
        std_alg = value
        alias_key = name.substring(ALIAS_LENGTH)
        type_and_alg = get_type_and_algorithm(alias_key)
        if ((type_and_alg).nil?)
          return
        end
        type = get_engine_name(type_and_alg[0])
        alias_alg = type_and_alg[1].intern
        key = ServiceKey.new(type, std_alg, true)
        s = @legacy_map.get(key)
        if ((s).nil?)
          s = Service.new(self)
          s.attr_type = type
          s.attr_algorithm = std_alg
          @legacy_map.put(key, s)
        end
        @legacy_map.put(ServiceKey.new(type, alias_alg, true), s)
        s.add_alias(alias_alg)
      else
        type_and_alg = get_type_and_algorithm(name)
        if ((type_and_alg).nil?)
          return
        end
        i = type_and_alg[1].index_of(Character.new(?\s.ord))
        if ((i).equal?(-1))
          # e.g. put("MessageDigest.SHA-1", "sun.security.provider.SHA");
          type = get_engine_name(type_and_alg[0])
          std_alg = type_and_alg[1].intern
          class_name = value
          key = ServiceKey.new(type, std_alg, true)
          s = @legacy_map.get(key)
          if ((s).nil?)
            s = Service.new(self)
            s.attr_type = type
            s.attr_algorithm = std_alg
            @legacy_map.put(key, s)
          end
          s.attr_class_name = class_name
        else
          # attribute
          # e.g. put("MessageDigest.SHA-1 ImplementedIn", "Software");
          attribute_value = value
          type = get_engine_name(type_and_alg[0])
          attribute_string = type_and_alg[1]
          std_alg = attribute_string.substring(0, i).intern
          attribute_name = attribute_string.substring(i + 1)
          # kill additional spaces
          while (attribute_name.starts_with(" "))
            attribute_name = RJava.cast_to_string(attribute_name.substring(1))
          end
          attribute_name = RJava.cast_to_string(attribute_name.intern)
          key = ServiceKey.new(type, std_alg, true)
          s = @legacy_map.get(key)
          if ((s).nil?)
            s = Service.new(self)
            s.attr_type = type
            s.attr_algorithm = std_alg
            @legacy_map.put(key, s)
          end
          s.add_attribute(attribute_name, attribute_value)
        end
      end
    end
    
    typesig { [String, String] }
    # Get the service describing this Provider's implementation of the
    # specified type of this algorithm or alias. If no such
    # implementation exists, this method returns null. If there are two
    # matching services, one added to this provider using
    # {@link #putService putService()} and one added via {@link #put put()},
    # the service added via {@link #putService putService()} is returned.
    # 
    # @param type the type of {@link Service service} requested
    # (for example, <code>MessageDigest</code>)
    # @param algorithm the case insensitive algorithm name (or alternate
    # alias) of the service requested (for example, <code>SHA-1</code>)
    # 
    # @return the service describing this Provider's matching service
    # or null if no such service exists
    # 
    # @throws NullPointerException if type or algorithm is null
    # 
    # @since 1.5
    def get_service(type, algorithm)
      synchronized(self) do
        check_initialized
        # avoid allocating a new key object if possible
        key = self.attr_previous_key
        if ((key.matches(type, algorithm)).equal?(false))
          key = ServiceKey.new(type, algorithm, false)
          self.attr_previous_key = key
        end
        if (!(@service_map).nil?)
          service = @service_map.get(key)
          if (!(service).nil?)
            return service
          end
        end
        ensure_legacy_parsed
        return (!(@legacy_map).nil?) ? @legacy_map.get(key) : nil
      end
    end
    
    class_module.module_eval {
      # ServiceKey from previous getService() call
      # by re-using it if possible we avoid allocating a new object
      # and the toUpperCase() call.
      # re-use will occur e.g. as the framework traverses the provider
      # list and queries each provider with the same values until it finds
      # a matching service
      
      def previous_key
        defined?(@@previous_key) ? @@previous_key : @@previous_key= ServiceKey.new("", "", false)
      end
      alias_method :attr_previous_key, :previous_key
      
      def previous_key=(value)
        @@previous_key = value
      end
      alias_method :attr_previous_key=, :previous_key=
    }
    
    typesig { [] }
    # Get an unmodifiable Set of all services supported by
    # this Provider.
    # 
    # @return an unmodifiable Set of all services supported by
    # this Provider
    # 
    # @since 1.5
    def get_services
      synchronized(self) do
        check_initialized
        if (@legacy_changed || @services_changed)
          @service_set = nil
        end
        if ((@service_set).nil?)
          ensure_legacy_parsed
          set = LinkedHashSet.new
          if (!(@service_map).nil?)
            set.add_all(@service_map.values)
          end
          if (!(@legacy_map).nil?)
            set.add_all(@legacy_map.values)
          end
          @service_set = Collections.unmodifiable_set(set)
          @services_changed = false
        end
        return @service_set
      end
    end
    
    typesig { [Service] }
    # Add a service. If a service of the same type with the same algorithm
    # name exists and it was added using {@link #putService putService()},
    # it is replaced by the new service.
    # This method also places information about this service
    # in the provider's Hashtable values in the format described in the
    # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html">
    # Java Cryptography Architecture API Specification &amp; Reference </a>.
    # 
    # <p>Also, if there is a security manager, its
    # <code>checkSecurityAccess</code> method is called with the string
    # <code>"putProviderProperty."+name</code>, where <code>name</code> is
    # the provider name, to see if it's ok to set this provider's property
    # values. If the default implementation of <code>checkSecurityAccess</code>
    # is used (that is, that method is not overriden), then this results in
    # a call to the security manager's <code>checkPermission</code> method with
    # a <code>SecurityPermission("putProviderProperty."+name)</code>
    # permission.
    # 
    # @param s the Service to add
    # 
    # @throws SecurityException
    # if a security manager exists and its <code>{@link
    # java.lang.SecurityManager#checkSecurityAccess}</code> method denies
    # access to set property values.
    # @throws NullPointerException if s is null
    # 
    # @since 1.5
    def put_service(s)
      synchronized(self) do
        check("putProviderProperty." + @name)
        if (!(Debug).nil?)
          Debug.println(@name + ".putService(): " + RJava.cast_to_string(s))
        end
        if ((s).nil?)
          raise NullPointerException.new
        end
        if (!(s.get_provider).equal?(self))
          raise IllegalArgumentException.new("service.getProvider() must match this Provider object")
        end
        if ((@service_map).nil?)
          @service_map = LinkedHashMap.new
        end
        @services_changed = true
        type = s.get_type
        algorithm = s.get_algorithm
        key = ServiceKey.new(type, algorithm, true)
        # remove existing service
        impl_remove_service(@service_map.get(key))
        @service_map.put(key, s)
        s.get_aliases.each do |alias|
          @service_map.put(ServiceKey.new(type, alias_, true), s)
        end
        put_property_strings(s)
      end
    end
    
    typesig { [Service] }
    # Put the string properties for this Service in this Provider's
    # Hashtable.
    def put_property_strings(s)
      type = s.get_type
      algorithm = s.get_algorithm
      # use super() to avoid permission check and other processing
      Properties.instance_method(:put).bind(self).call(type + "." + algorithm, s.get_class_name)
      s.get_aliases.each do |alias|
        Properties.instance_method(:put).bind(self).call(ALIAS_PREFIX + type + "." + alias_, algorithm)
      end
      s.attr_attributes.entry_set.each do |entry|
        key = type + "." + algorithm + " " + RJava.cast_to_string(entry.get_key)
        Properties.instance_method(:put).bind(self).call(key, entry.get_value)
      end
    end
    
    typesig { [Service] }
    # Remove the string properties for this Service from this Provider's
    # Hashtable.
    def remove_property_strings(s)
      type = s.get_type
      algorithm = s.get_algorithm
      # use super() to avoid permission check and other processing
      Properties.instance_method(:remove).bind(self).call(type + "." + algorithm)
      s.get_aliases.each do |alias|
        Properties.instance_method(:remove).bind(self).call(ALIAS_PREFIX + type + "." + alias_)
      end
      s.attr_attributes.entry_set.each do |entry|
        key = type + "." + algorithm + " " + RJava.cast_to_string(entry.get_key)
        Properties.instance_method(:remove).bind(self).call(key)
      end
    end
    
    typesig { [Service] }
    # Remove a service previously added using
    # {@link #putService putService()}. The specified service is removed from
    # this provider. It will no longer be returned by
    # {@link #getService getService()} and its information will be removed
    # from this provider's Hashtable.
    # 
    # <p>Also, if there is a security manager, its
    # <code>checkSecurityAccess</code> method is called with the string
    # <code>"removeProviderProperty."+name</code>, where <code>name</code> is
    # the provider name, to see if it's ok to remove this provider's
    # properties. If the default implementation of
    # <code>checkSecurityAccess</code> is used (that is, that method is not
    # overriden), then this results in a call to the security manager's
    # <code>checkPermission</code> method with a
    # <code>SecurityPermission("removeProviderProperty."+name)</code>
    # permission.
    # 
    # @param s the Service to be removed
    # 
    # @throws  SecurityException
    # if a security manager exists and its <code>{@link
    # java.lang.SecurityManager#checkSecurityAccess}</code> method denies
    # access to remove this provider's properties.
    # @throws NullPointerException if s is null
    # 
    # @since 1.5
    def remove_service(s)
      synchronized(self) do
        check("removeProviderProperty." + @name)
        if (!(Debug).nil?)
          Debug.println(@name + ".removeService(): " + RJava.cast_to_string(s))
        end
        if ((s).nil?)
          raise NullPointerException.new
        end
        impl_remove_service(s)
      end
    end
    
    typesig { [Service] }
    def impl_remove_service(s)
      if (((s).nil?) || ((@service_map).nil?))
        return
      end
      type = s.get_type
      algorithm = s.get_algorithm
      key = ServiceKey.new(type, algorithm, false)
      old_service = @service_map.get(key)
      if (!(s).equal?(old_service))
        return
      end
      @services_changed = true
      @service_map.remove(key)
      s.get_aliases.each do |alias|
        @service_map.remove(ServiceKey.new(type, alias_, false))
      end
      remove_property_strings(s)
    end
    
    class_module.module_eval {
      # Wrapped String that behaves in a case insensitive way for equals/hashCode
      const_set_lazy(:UString) { Class.new do
        include_class_members Provider
        
        attr_accessor :string
        alias_method :attr_string, :string
        undef_method :string
        alias_method :attr_string=, :string=
        undef_method :string=
        
        attr_accessor :lower_string
        alias_method :attr_lower_string, :lower_string
        undef_method :lower_string
        alias_method :attr_lower_string=, :lower_string=
        undef_method :lower_string=
        
        typesig { [self::String] }
        def initialize(s)
          @string = nil
          @lower_string = nil
          @string = s
          @lower_string = s.to_lower_case(ENGLISH)
        end
        
        typesig { [] }
        def hash_code
          return @lower_string.hash_code
        end
        
        typesig { [Object] }
        def ==(obj)
          if ((self).equal?(obj))
            return true
          end
          if ((obj.is_a?(self.class::UString)).equal?(false))
            return false
          end
          other = obj
          return (@lower_string == other.attr_lower_string)
        end
        
        typesig { [] }
        def to_s
          return @string
        end
        
        private
        alias_method :initialize__ustring, :initialize
      end }
      
      # describe relevant properties of a type of engine
      const_set_lazy(:EngineDescription) { Class.new do
        include_class_members Provider
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :supports_parameter
        alias_method :attr_supports_parameter, :supports_parameter
        undef_method :supports_parameter
        alias_method :attr_supports_parameter=, :supports_parameter=
        undef_method :supports_parameter=
        
        attr_accessor :constructor_parameter_class_name
        alias_method :attr_constructor_parameter_class_name, :constructor_parameter_class_name
        undef_method :constructor_parameter_class_name
        alias_method :attr_constructor_parameter_class_name=, :constructor_parameter_class_name=
        undef_method :constructor_parameter_class_name=
        
        attr_accessor :constructor_parameter_class
        alias_method :attr_constructor_parameter_class, :constructor_parameter_class
        undef_method :constructor_parameter_class
        alias_method :attr_constructor_parameter_class=, :constructor_parameter_class=
        undef_method :constructor_parameter_class=
        
        typesig { [self::String, ::Java::Boolean, self::String] }
        def initialize(name, sp, param_name)
          @name = nil
          @supports_parameter = false
          @constructor_parameter_class_name = nil
          @constructor_parameter_class = nil
          @name = name
          @supports_parameter = sp
          @constructor_parameter_class_name = param_name
        end
        
        typesig { [] }
        def get_constructor_parameter_class
          clazz = @constructor_parameter_class
          if ((clazz).nil?)
            clazz = Class.for_name(@constructor_parameter_class_name)
            @constructor_parameter_class = clazz
          end
          return clazz
        end
        
        private
        alias_method :initialize__engine_description, :initialize
      end }
      
      typesig { [String, ::Java::Boolean, String] }
      def add_engine(name, sp, param_name)
        ed = EngineDescription.new(name, sp, param_name)
        # also index by canonical name to avoid toLowerCase() for some lookups
        KnownEngines.put(name.to_lower_case(ENGLISH), ed)
        KnownEngines.put(name, ed)
      end
      
      when_class_loaded do
        const_set :KnownEngines, HashMap.new
        # JCA
        add_engine("AlgorithmParameterGenerator", false, nil)
        add_engine("AlgorithmParameters", false, nil)
        add_engine("KeyFactory", false, nil)
        add_engine("KeyPairGenerator", false, nil)
        add_engine("KeyStore", false, nil)
        add_engine("MessageDigest", false, nil)
        add_engine("SecureRandom", false, nil)
        add_engine("Signature", true, nil)
        add_engine("CertificateFactory", false, nil)
        add_engine("CertPathBuilder", false, nil)
        add_engine("CertPathValidator", false, nil)
        add_engine("CertStore", false, "java.security.cert.CertStoreParameters")
        # JCE
        add_engine("Cipher", true, nil)
        add_engine("ExemptionMechanism", false, nil)
        add_engine("Mac", true, nil)
        add_engine("KeyAgreement", true, nil)
        add_engine("KeyGenerator", false, nil)
        add_engine("SecretKeyFactory", false, nil)
        # JSSE
        add_engine("KeyManagerFactory", false, nil)
        add_engine("SSLContext", false, nil)
        add_engine("TrustManagerFactory", false, nil)
        # JGSS
        add_engine("GssApiMechanism", false, nil)
        # SASL
        add_engine("SaslClientFactory", false, nil)
        add_engine("SaslServerFactory", false, nil)
        # POLICY
        add_engine("Policy", false, "java.security.Policy$Parameters")
        # CONFIGURATION
        add_engine("Configuration", false, "javax.security.auth.login.Configuration$Parameters")
        # XML DSig
        add_engine("XMLSignatureFactory", false, nil)
        add_engine("KeyInfoFactory", false, nil)
        add_engine("TransformService", false, nil)
        # Smart Card I/O
        add_engine("TerminalFactory", false, "java.lang.Object")
      end
      
      typesig { [String] }
      # get the "standard" (mixed-case) engine name for arbitary case engine name
      # if there is no known engine by that name, return s
      def get_engine_name(s)
        # try original case first, usually correct
        e = KnownEngines.get(s)
        if ((e).nil?)
          e = KnownEngines.get(s.to_lower_case(ENGLISH))
        end
        return ((e).nil?) ? s : e.attr_name
      end
      
      # The description of a security service. It encapsulates the properties
      # of a service and contains a factory method to obtain new implementation
      # instances of this service.
      # 
      # <p>Each service has a provider that offers the service, a type,
      # an algorithm name, and the name of the class that implements the
      # service. Optionally, it also includes a list of alternate algorithm
      # names for this service (aliases) and attributes, which are a map of
      # (name, value) String pairs.
      # 
      # <p>This class defines the methods {@link #supportsParameter
      # supportsParameter()} and {@link #newInstance newInstance()}
      # which are used by the Java security framework when it searches for
      # suitable services and instantes them. The valid arguments to those
      # methods depend on the type of service. For the service types defined
      # within Java SE, see the
      # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for the valid values.
      # Note that components outside of Java SE can define additional types of
      # services and their behavior.
      # 
      # <p>Instances of this class are immutable.
      # 
      # @since 1.5
      const_set_lazy(:Service) { Class.new do
        include_class_members Provider
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :algorithm
        alias_method :attr_algorithm, :algorithm
        undef_method :algorithm
        alias_method :attr_algorithm=, :algorithm=
        undef_method :algorithm=
        
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
        
        attr_accessor :aliases
        alias_method :attr_aliases, :aliases
        undef_method :aliases
        alias_method :attr_aliases=, :aliases=
        undef_method :aliases=
        
        attr_accessor :attributes
        alias_method :attr_attributes, :attributes
        undef_method :attributes
        alias_method :attr_attributes=, :attributes=
        undef_method :attributes=
        
        # Reference to the cached implementation Class object
        attr_accessor :class_ref
        alias_method :attr_class_ref, :class_ref
        undef_method :class_ref
        alias_method :attr_class_ref=, :class_ref=
        undef_method :class_ref=
        
        # flag indicating whether this service has its attributes for
        # supportedKeyFormats or supportedKeyClasses set
        # if null, the values have not been initialized
        # if TRUE, at least one of supportedFormats/Classes is non null
        attr_accessor :has_key_attributes
        alias_method :attr_has_key_attributes, :has_key_attributes
        undef_method :has_key_attributes
        alias_method :attr_has_key_attributes=, :has_key_attributes=
        undef_method :has_key_attributes=
        
        # supported encoding formats
        attr_accessor :supported_formats
        alias_method :attr_supported_formats, :supported_formats
        undef_method :supported_formats
        alias_method :attr_supported_formats=, :supported_formats=
        undef_method :supported_formats=
        
        # names of the supported key (super) classes
        attr_accessor :supported_classes
        alias_method :attr_supported_classes, :supported_classes
        undef_method :supported_classes
        alias_method :attr_supported_classes=, :supported_classes=
        undef_method :supported_classes=
        
        # whether this service has been registered with the Provider
        attr_accessor :registered
        alias_method :attr_registered, :registered
        undef_method :registered
        alias_method :attr_registered=, :registered=
        undef_method :registered=
        
        class_module.module_eval {
          const_set_lazy(:CLASS0) { Array.typed(self.class::Class).new(0) { nil } }
          const_attr_reader  :CLASS0
        }
        
        typesig { [self::Provider] }
        # this constructor and these methods are used for parsing
        # the legacy string properties.
        def initialize(provider)
          @type = nil
          @algorithm = nil
          @class_name = nil
          @provider = nil
          @aliases = nil
          @attributes = nil
          @class_ref = nil
          @has_key_attributes = nil
          @supported_formats = nil
          @supported_classes = nil
          @registered = false
          @provider = provider
          @aliases = Collections.empty_list
          @attributes = Collections.empty_map
        end
        
        typesig { [] }
        def is_valid
          return (!(@type).nil?) && (!(@algorithm).nil?) && (!(@class_name).nil?)
        end
        
        typesig { [self::String] }
        def add_alias(alias_)
          if (@aliases.is_empty)
            @aliases = self.class::ArrayList.new(2)
          end
          @aliases.add(alias_)
        end
        
        typesig { [self::String, self::String] }
        def add_attribute(type, value)
          if (@attributes.is_empty)
            @attributes = self.class::HashMap.new(8)
          end
          @attributes.put(self.class::UString.new(type), value)
        end
        
        typesig { [self::Provider, self::String, self::String, self::String, self::JavaList, self::Map] }
        # Construct a new service.
        # 
        # @param provider the provider that offers this service
        # @param type the type of this service
        # @param algorithm the algorithm name
        # @param className the name of the class implementing this service
        # @param aliases List of aliases or null if algorithm has no aliases
        # @param attributes Map of attributes or null if this implementation
        # has no attributes
        # 
        # @throws NullPointerException if provider, type, algorithm, or
        # className is null
        def initialize(provider, type, algorithm, class_name, aliases, attributes)
          @type = nil
          @algorithm = nil
          @class_name = nil
          @provider = nil
          @aliases = nil
          @attributes = nil
          @class_ref = nil
          @has_key_attributes = nil
          @supported_formats = nil
          @supported_classes = nil
          @registered = false
          if (((provider).nil?) || ((type).nil?) || ((algorithm).nil?) || ((class_name).nil?))
            raise self.class::NullPointerException.new
          end
          @provider = provider
          @type = get_engine_name(type)
          @algorithm = algorithm
          @class_name = class_name
          if ((aliases).nil?)
            @aliases = Collections.empty_list
          else
            @aliases = self.class::ArrayList.new(aliases)
          end
          if ((attributes).nil?)
            @attributes = Collections.empty_map
          else
            @attributes = self.class::HashMap.new
            attributes.entry_set.each do |entry|
              @attributes.put(self.class::UString.new(entry.get_key), entry.get_value)
            end
          end
        end
        
        typesig { [] }
        # Get the type of this service. For example, <code>MessageDigest</code>.
        # 
        # @return the type of this service
        def get_type
          return @type
        end
        
        typesig { [] }
        # Return the name of the algorithm of this service. For example,
        # <code>SHA-1</code>.
        # 
        # @return the algorithm of this service
        def get_algorithm
          return @algorithm
        end
        
        typesig { [] }
        # Return the Provider of this service.
        # 
        # @return the Provider of this service
        def get_provider
          return @provider
        end
        
        typesig { [] }
        # Return the name of the class implementing this service.
        # 
        # @return the name of the class implementing this service
        def get_class_name
          return @class_name
        end
        
        typesig { [] }
        # internal only
        def get_aliases
          return @aliases
        end
        
        typesig { [self::String] }
        # Return the value of the specified attribute or null if this
        # attribute is not set for this Service.
        # 
        # @param name the name of the requested attribute
        # 
        # @return the value of the specified attribute or null if the
        # attribute is not present
        # 
        # @throws NullPointerException if name is null
        def get_attribute(name)
          if ((name).nil?)
            raise self.class::NullPointerException.new
          end
          return @attributes.get(self.class::UString.new(name))
        end
        
        typesig { [Object] }
        # Return a new instance of the implementation described by this
        # service. The security provider framework uses this method to
        # construct implementations. Applications will typically not need
        # to call it.
        # 
        # <p>The default implementation uses reflection to invoke the
        # standard constructor for this type of service.
        # Security providers can override this method to implement
        # instantiation in a different way.
        # For details and the values of constructorParameter that are
        # valid for the various types of services see the
        # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html">
        # Java Cryptography Architecture API Specification &amp;
        # Reference</a>.
        # 
        # @param constructorParameter the value to pass to the constructor,
        # or null if this type of service does not use a constructorParameter.
        # 
        # @return a new implementation of this service
        # 
        # @throws InvalidParameterException if the value of
        # constructorParameter is invalid for this type of service.
        # @throws NoSuchAlgorithmException if instantation failed for
        # any other reason.
        def new_instance(constructor_parameter)
          if ((@registered).equal?(false))
            if (!(@provider.get_service(@type, @algorithm)).equal?(self))
              raise self.class::NoSuchAlgorithmException.new("Service not registered with Provider " + RJava.cast_to_string(@provider.get_name) + ": " + RJava.cast_to_string(self))
            end
            @registered = true
          end
          begin
            cap = KnownEngines.get(@type)
            if ((cap).nil?)
              # unknown engine type, use generic code
              # this is the code path future for non-core
              # optional packages
              return new_instance_generic(constructor_parameter)
            end
            if ((cap.attr_constructor_parameter_class_name).nil?)
              if (!(constructor_parameter).nil?)
                raise self.class::InvalidParameterException.new("constructorParameter not used with " + @type + " engines")
              end
              clazz = get_impl_class
              return clazz.new_instance
            else
              param_class = cap.get_constructor_parameter_class
              if (!(constructor_parameter).nil?)
                arg_class = constructor_parameter.get_class
                if ((param_class.is_assignable_from(arg_class)).equal?(false))
                  raise self.class::InvalidParameterException.new("constructorParameter must be instanceof " + RJava.cast_to_string(cap.attr_constructor_parameter_class_name.replace(Character.new(?$.ord), Character.new(?..ord))) + " for engine type " + @type)
                end
              end
              clazz = get_impl_class
              cons = clazz.get_constructor(param_class)
              return cons.new_instance(constructor_parameter)
            end
          rescue self.class::NoSuchAlgorithmException => e
            raise e
          rescue self.class::InvocationTargetException => e
            raise self.class::NoSuchAlgorithmException.new("Error constructing implementation (algorithm: " + @algorithm + ", provider: " + RJava.cast_to_string(@provider.get_name) + ", class: " + @class_name + ")", e.get_cause)
          rescue self.class::JavaException => e
            raise self.class::NoSuchAlgorithmException.new("Error constructing implementation (algorithm: " + @algorithm + ", provider: " + RJava.cast_to_string(@provider.get_name) + ", class: " + @class_name + ")", e)
          end
        end
        
        typesig { [] }
        # return the implementation Class object for this service
        def get_impl_class
          begin
            ref = @class_ref
            clazz = ((ref).nil?) ? nil : ref.get
            if ((clazz).nil?)
              cl = @provider.get_class.get_class_loader
              if ((cl).nil?)
                clazz = Class.for_name(@class_name)
              else
                clazz = cl.load_class(@class_name)
              end
              @class_ref = self.class::WeakReference.new(clazz)
            end
            return clazz
          rescue self.class::ClassNotFoundException => e
            raise self.class::NoSuchAlgorithmException.new("class configured for " + @type + "(provider: " + RJava.cast_to_string(@provider.get_name) + ")" + "cannot be found.", e)
          end
        end
        
        typesig { [Object] }
        # Generic code path for unknown engine types. Call the
        # no-args constructor if constructorParameter is null, otherwise
        # use the first matching constructor.
        def new_instance_generic(constructor_parameter)
          clazz = get_impl_class
          if ((constructor_parameter).nil?)
            o = clazz.new_instance
            return o
          end
          arg_class = constructor_parameter.get_class
          cons = clazz.get_constructors
          # find first public constructor that can take the
          # argument as parameter
          i = 0
          while i < cons.attr_length
            con = cons[i]
            param_types = con.get_parameter_types
            if (!(param_types.attr_length).equal?(1))
              i += 1
              next
            end
            if ((param_types[0].is_assignable_from(arg_class)).equal?(false))
              i += 1
              next
            end
            o = con.new_instance(Array.typed(Object).new([constructor_parameter]))
            return o
            i += 1
          end
          raise self.class::NoSuchAlgorithmException.new("No constructor matching " + RJava.cast_to_string(arg_class.get_name) + " found in class " + @class_name)
        end
        
        typesig { [Object] }
        # Test whether this Service can use the specified parameter.
        # Returns false if this service cannot use the parameter. Returns
        # true if this service can use the parameter, if a fast test is
        # infeasible, or if the status is unknown.
        # 
        # <p>The security provider framework uses this method with
        # some types of services to quickly exclude non-matching
        # implementations for consideration.
        # Applications will typically not need to call it.
        # 
        # <p>For details and the values of parameter that are valid for the
        # various types of services see the top of this class and the
        # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html">
        # Java Cryptography Architecture API Specification &amp;
        # Reference</a>.
        # Security providers can override it to implement their own test.
        # 
        # @param parameter the parameter to test
        # 
        # @return false if this this service cannot use the specified
        # parameter; true if it can possibly use the parameter
        # 
        # @throws InvalidParameterException if the value of parameter is
        # invalid for this type of service or if this method cannot be
        # used with this type of service
        def supports_parameter(parameter)
          cap = KnownEngines.get(@type)
          if ((cap).nil?)
            # unknown engine type, return true by default
            return true
          end
          if ((cap.attr_supports_parameter).equal?(false))
            raise self.class::InvalidParameterException.new("supportsParameter() not " + "used with " + @type + " engines")
          end
          # allow null for keys without attributes for compatibility
          if ((!(parameter).nil?) && ((parameter.is_a?(self.class::Key)).equal?(false)))
            raise self.class::InvalidParameterException.new("Parameter must be instanceof Key for engine " + @type)
          end
          if ((has_key_attributes).equal?(false))
            return true
          end
          if ((parameter).nil?)
            return false
          end
          key = parameter
          if (supports_key_format(key))
            return true
          end
          if (supports_key_class(key))
            return true
          end
          return false
        end
        
        typesig { [] }
        # Return whether this service has its Supported* properties for
        # keys defined. Parses the attributes if not yet initialized.
        def has_key_attributes
          b = @has_key_attributes
          if ((b).nil?)
            synchronized((self)) do
              s = nil
              s = RJava.cast_to_string(get_attribute("SupportedKeyFormats"))
              if (!(s).nil?)
                @supported_formats = s.split(Regexp.new("\\|"))
              end
              s = RJava.cast_to_string(get_attribute("SupportedKeyClasses"))
              if (!(s).nil?)
                class_names = s.split(Regexp.new("\\|"))
                class_list = self.class::ArrayList.new(class_names.attr_length)
                class_names.each do |className|
                  clazz = get_key_class(class_name)
                  if (!(clazz).nil?)
                    class_list.add(clazz)
                  end
                end
                @supported_classes = class_list.to_array(self.class::CLASS0)
              end
              bool = (!(@supported_formats).nil?) || (!(@supported_classes).nil?)
              b = Boolean.value_of(bool)
              @has_key_attributes = b
            end
          end
          return b.boolean_value
        end
        
        typesig { [self::String] }
        # get the key class object of the specified name
        def get_key_class(name)
          begin
            return Class.for_name(name)
          rescue self.class::ClassNotFoundException => e
            # ignore
          end
          begin
            cl = @provider.get_class.get_class_loader
            if (!(cl).nil?)
              return cl.load_class(name)
            end
          rescue self.class::ClassNotFoundException => e
            # ignore
          end
          return nil
        end
        
        typesig { [self::Key] }
        def supports_key_format(key)
          if ((@supported_formats).nil?)
            return false
          end
          format = key.get_format
          if ((format).nil?)
            return false
          end
          @supported_formats.each do |supportedFormat|
            if ((supported_format == format))
              return true
            end
          end
          return false
        end
        
        typesig { [self::Key] }
        def supports_key_class(key)
          if ((@supported_classes).nil?)
            return false
          end
          key_class = key.get_class
          @supported_classes.each do |clazz|
            if (clazz.is_assignable_from(key_class))
              return true
            end
          end
          return false
        end
        
        typesig { [] }
        # Return a String representation of this service.
        # 
        # @return a String representation of this service.
        def to_s
          a_string = @aliases.is_empty ? "" : "\r\n  aliases: " + RJava.cast_to_string(@aliases.to_s)
          attrs = @attributes.is_empty ? "" : "\r\n  attributes: " + RJava.cast_to_string(@attributes.to_s)
          return RJava.cast_to_string(@provider.get_name) + ": " + @type + "." + @algorithm + " -> " + @class_name + a_string + attrs + "\r\n"
        end
        
        private
        alias_method :initialize__service, :initialize
      end }
    }
    
    private
    alias_method :initialize__provider, :initialize
  end
  
end
