require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jca
  module ProviderListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jca
      include ::Java::Util
      include ::Java::Security
      include_const ::Java::Security::Provider, :Service
    }
  end
  
  # List of Providers. Used to represent the provider preferences.
  # 
  # The system starts out with a ProviderList that only has the classNames
  # of the Providers. Providers are loaded on demand only when needed.
  # 
  # For compatibility reasons, Providers that could not be loaded are ignored
  # and internally presented as the instance EMPTY_PROVIDER. However, those
  # objects cannot be presented to applications. Call the convert() method
  # to force all Providers to be loaded and to obtain a ProviderList with
  # invalid entries removed. All this is handled by the Security class.
  # 
  # Note that all indices used by this class are 0-based per general Java
  # convention. These must be converted to the 1-based indices used by the
  # Security class externally when needed.
  # 
  # Instances of this class are immutable. This eliminates the need for
  # cloning and synchronization in consumers. The add() and remove() style
  # methods are static in order to avoid confusion about the immutability.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class ProviderList 
    include_class_members ProviderListImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Sun::Security::Util::Debug.get_instance("jca", "ProviderList") }
      const_attr_reader  :Debug
      
      const_set_lazy(:PC0) { Array.typed(ProviderConfig).new(0) { nil } }
      const_attr_reader  :PC0
      
      const_set_lazy(:P0) { Array.typed(Provider).new(0) { nil } }
      const_attr_reader  :P0
      
      # constant for an ProviderList with no elements
      const_set_lazy(:EMPTY) { ProviderList.new(PC0, true) }
      const_attr_reader  :EMPTY
      
      const_set_lazy(:EMPTY_PROVIDER) { # dummy provider object to use during initialization
      # used to avoid explicit null checks in various places
      Class.new(Provider.class == Class ? Provider : Object) do
        extend LocalClass
        include_class_members ProviderList
        include Provider if Provider.class == Module
        
        typesig { [String, String] }
        # override getService() to return null slightly faster
        define_method :get_service do |type, algorithm|
          return nil
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, "##Empty##", 1.0, "initialization in progress") }
      const_attr_reader  :EMPTY_PROVIDER
      
      typesig { [] }
      # construct a ProviderList from the security properties
      # (static provider configuration in the java.security file)
      def from_security_properties
        return AccessController.do_privileged(# doPrivileged() because of Security.getProperty()
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ProviderList
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.class::ProviderList.new
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [ProviderList, Provider] }
      def add(provider_list, p)
        return insert_at(provider_list, p, -1)
      end
      
      typesig { [ProviderList, Provider, ::Java::Int] }
      def insert_at(provider_list, p, position)
        if (!(provider_list.get_provider(p.get_name)).nil?)
          return provider_list
        end
        list = ArrayList.new(Arrays.as_list(provider_list.attr_configs))
        n = list.size
        if ((position < 0) || (position > n))
          position = n
        end
        list.add(position, ProviderConfig.new(p))
        return ProviderList.new(list.to_array(PC0), true)
      end
      
      typesig { [ProviderList, String] }
      def remove(provider_list, name)
        # make sure provider exists
        if ((provider_list.get_provider(name)).nil?)
          return provider_list
        end
        # copy all except matching to new list
        configs = Array.typed(ProviderConfig).new(provider_list.size - 1) { nil }
        j = 0
        provider_list.attr_configs.each do |config|
          if (((config.get_provider.get_name == name)).equal?(false))
            configs[((j += 1) - 1)] = config
          end
        end
        return ProviderList.new(configs, true)
      end
      
      typesig { [Provider] }
      # Create a new ProviderList from the specified Providers.
      # This method is for use by SunJSSE.
      def new_list(*providers)
        configs = Array.typed(ProviderConfig).new(providers.attr_length) { nil }
        i = 0
        while i < providers.attr_length
          configs[i] = ProviderConfig.new(providers[i])
          i += 1
        end
        return ProviderList.new(configs, true)
      end
    }
    
    # configuration of the providers
    attr_accessor :configs
    alias_method :attr_configs, :configs
    undef_method :configs
    alias_method :attr_configs=, :configs=
    undef_method :configs=
    
    # flag indicating whether all configs have been loaded successfully
    attr_accessor :all_loaded
    alias_method :attr_all_loaded, :all_loaded
    undef_method :all_loaded
    alias_method :attr_all_loaded=, :all_loaded=
    undef_method :all_loaded=
    
    # List returned by providers()
    attr_accessor :user_list
    alias_method :attr_user_list, :user_list
    undef_method :user_list
    alias_method :attr_user_list=, :user_list=
    undef_method :user_list=
    
    typesig { [Array.typed(ProviderConfig), ::Java::Boolean] }
    # Create a new ProviderList from an array of configs
    def initialize(configs, all_loaded)
      @configs = nil
      @all_loaded = false
      @user_list = Class.new(AbstractList.class == Class ? AbstractList : Object) do
        extend LocalClass
        include_class_members ProviderList
        include AbstractList if AbstractList.class == Module
        
        typesig { [] }
        define_method :size do
          return configs.attr_length
        end
        
        typesig { [::Java::Int] }
        define_method :get do |index|
          return get_provider(index)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @configs = configs
      @all_loaded = all_loaded
    end
    
    typesig { [] }
    # Return a new ProviderList parsed from the java.security Properties.
    def initialize
      @configs = nil
      @all_loaded = false
      @user_list = Class.new(AbstractList.class == Class ? AbstractList : Object) do
        extend LocalClass
        include_class_members ProviderList
        include AbstractList if AbstractList.class == Module
        
        typesig { [] }
        define_method :size do
          return self.attr_configs.attr_length
        end
        
        typesig { [::Java::Int] }
        define_method :get do |index|
          return get_provider(index)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      config_list = ArrayList.new
      i = 1
      while true
        entry = Security.get_property("security.provider." + RJava.cast_to_string(i))
        if ((entry).nil?)
          break
        end
        entry = RJava.cast_to_string(entry.trim)
        if ((entry.length).equal?(0))
          System.err.println("invalid entry for " + "security.provider." + RJava.cast_to_string(i))
          break
        end
        k = entry.index_of(Character.new(?\s.ord))
        config = nil
        if ((k).equal?(-1))
          config = ProviderConfig.new(entry)
        else
          class_name = entry.substring(0, k)
          argument = entry.substring(k + 1).trim
          config = ProviderConfig.new(class_name, argument)
        end
        # Get rid of duplicate providers.
        if ((config_list.contains(config)).equal?(false))
          config_list.add(config)
        end
        i += 1
      end
      @configs = config_list.to_array(PC0)
      if (!(Debug).nil?)
        Debug.println("provider configuration: " + RJava.cast_to_string(config_list))
      end
    end
    
    typesig { [Array.typed(String)] }
    # Construct a special ProviderList for JAR verification. It consists
    # of the providers specified via jarClassNames, which must be on the
    # bootclasspath and cannot be in signed JAR files. This is to avoid
    # possible recursion and deadlock during verification.
    def get_jar_list(jar_class_names)
      new_configs = ArrayList.new
      jar_class_names.each do |className|
        new_config = ProviderConfig.new(class_name)
        @configs.each do |config|
          # if the equivalent object is present in this provider list,
          # use the old object rather than the new object.
          # this ensures that when the provider is loaded in the
          # new thread local list, it will also become available
          # in this provider list
          if ((config == new_config))
            new_config = config
            break
          end
        end
        new_configs.add(new_config)
      end
      config_array = new_configs.to_array(PC0)
      return ProviderList.new(config_array, false)
    end
    
    typesig { [] }
    def size
      return @configs.attr_length
    end
    
    typesig { [::Java::Int] }
    # Return the Provider at the specified index. Returns EMPTY_PROVIDER
    # if the provider could not be loaded at this time.
    def get_provider(index)
      p = @configs[index].get_provider
      return (!(p).nil?) ? p : EMPTY_PROVIDER
    end
    
    typesig { [] }
    # Return an unmodifiable List of all Providers in this List. The
    # individual Providers are loaded on demand. Elements that could not
    # be initialized are replaced with EMPTY_PROVIDER.
    def providers
      return @user_list
    end
    
    typesig { [String] }
    def get_provider_config(name)
      index = get_index(name)
      return (!(index).equal?(-1)) ? @configs[index] : nil
    end
    
    typesig { [String] }
    # return the Provider with the specified name or null
    def get_provider(name)
      config = get_provider_config(name)
      return ((config).nil?) ? nil : config.get_provider
    end
    
    typesig { [String] }
    # Return the index at which the provider with the specified name is
    # installed or -1 if it is not present in this ProviderList.
    def get_index(name)
      i = 0
      while i < @configs.attr_length
        p = get_provider(i)
        if ((p.get_name == name))
          return i
        end
        i += 1
      end
      return -1
    end
    
    typesig { [] }
    # attempt to load all Providers not already loaded
    def load_all
      if (@all_loaded)
        return @configs.attr_length
      end
      if (!(Debug).nil?)
        Debug.println("Loading all providers")
        JavaException.new("Call trace").print_stack_trace
      end
      n = 0
      i = 0
      while i < @configs.attr_length
        p = @configs[i].get_provider
        if (!(p).nil?)
          n += 1
        end
        i += 1
      end
      if ((n).equal?(@configs.attr_length))
        @all_loaded = true
      end
      return n
    end
    
    typesig { [] }
    # Try to load all Providers and return the ProviderList. If one or
    # more Providers could not be loaded, a new ProviderList with those
    # entries removed is returned. Otherwise, the method returns this.
    def remove_invalid
      n = load_all
      if ((n).equal?(@configs.attr_length))
        return self
      end
      new_configs = Array.typed(ProviderConfig).new(n) { nil }
      i = 0
      j = 0
      while i < @configs.attr_length
        config = @configs[i]
        if (config.is_loaded)
          new_configs[((j += 1) - 1)] = config
        end
        i += 1
      end
      return ProviderList.new(new_configs, true)
    end
    
    typesig { [] }
    # return the providers as an array
    def to_array
      return providers.to_array(P0)
    end
    
    typesig { [] }
    # return a String representation of this ProviderList
    def to_s
      return Arrays.as_list(@configs).to_s
    end
    
    typesig { [String, String] }
    # Return a Service describing an implementation of the specified
    # algorithm from the Provider with the highest precedence that
    # supports that algorithm. Return null if no Provider supports this
    # algorithm.
    def get_service(type, name)
      i = 0
      while i < @configs.attr_length
        p = get_provider(i)
        s = p.get_service(type, name)
        if (!(s).nil?)
          return s
        end
        i += 1
      end
      return nil
    end
    
    typesig { [String, String] }
    # Return a List containing all the Services describing implementations
    # of the specified algorithms in precedence order. If no implementation
    # exists, this method returns an empty List.
    # 
    # The elements of this list are determined lazily on demand.
    # 
    # The List returned is NOT thread safe.
    def get_services(type, algorithm)
      return ServiceList.new_local(self, type, algorithm)
    end
    
    typesig { [String, JavaList] }
    # This method exists for compatibility with JCE only. It will be removed
    # once JCE has been changed to use the replacement method.
    # @deprecated use getServices(List<ServiceId>) instead
    def get_services(type, algorithms)
      ids = ArrayList.new
      algorithms.each do |alg|
        ids.add(ServiceId.new(type, alg))
      end
      return get_services(ids)
    end
    
    typesig { [JavaList] }
    def get_services(ids)
      return ServiceList.new_local(self, ids)
    end
    
    class_module.module_eval {
      # Inner class for a List of Services. Custom List implementation in
      # order to delay Provider initialization and lookup.
      # Not thread safe.
      const_set_lazy(:ServiceList) { Class.new(AbstractList) do
        extend LocalClass
        include_class_members ProviderList
        
        # type and algorithm for simple lookup
        # avoid allocating/traversing the ServiceId list for these lookups
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
        
        # list of ids for parallel lookup
        # if ids is non-null, type and algorithm are null
        attr_accessor :ids
        alias_method :attr_ids, :ids
        undef_method :ids
        alias_method :attr_ids=, :ids=
        undef_method :ids=
        
        # first service we have found
        # it is stored in a separate variable so that we can avoid
        # allocating the services list if we do not need the second service.
        # this is the case if we don't failover (failovers are typically rare)
        attr_accessor :first_service
        alias_method :attr_first_service, :first_service
        undef_method :first_service
        alias_method :attr_first_service=, :first_service=
        undef_method :first_service=
        
        # list of the services we have found so far
        attr_accessor :services
        alias_method :attr_services, :services
        undef_method :services
        alias_method :attr_services=, :services=
        undef_method :services=
        
        # index into config[] of the next provider we need to query
        attr_accessor :provider_index
        alias_method :attr_provider_index, :provider_index
        undef_method :provider_index
        alias_method :attr_provider_index=, :provider_index=
        undef_method :provider_index=
        
        typesig { [self::String, self::String] }
        def initialize(type, algorithm)
          @type = nil
          @algorithm = nil
          @ids = nil
          @first_service = nil
          @services = nil
          @provider_index = 0
          super()
          @type = type
          @algorithm = algorithm
          @ids = nil
        end
        
        typesig { [self::JavaList] }
        def initialize(ids)
          @type = nil
          @algorithm = nil
          @ids = nil
          @first_service = nil
          @services = nil
          @provider_index = 0
          super()
          @type = nil
          @algorithm = nil
          @ids = ids
        end
        
        typesig { [self::Service] }
        def add_service(s)
          if ((@first_service).nil?)
            @first_service = s
          else
            if ((@services).nil?)
              @services = self.class::ArrayList.new(4)
              @services.add(@first_service)
            end
            @services.add(s)
          end
        end
        
        typesig { [::Java::Int] }
        def try_get(index)
          while (true)
            if (((index).equal?(0)) && (!(@first_service).nil?))
              return @first_service
            else
              if ((!(@services).nil?) && (@services.size > index))
                return @services.get(index)
              end
            end
            if (@provider_index >= self.attr_configs.attr_length)
              return nil
            end
            # check all algorithms in this provider before moving on
            p = get_provider(((@provider_index += 1) - 1))
            if (!(@type).nil?)
              # simple lookup
              s = p.get_service(@type, @algorithm)
              if (!(s).nil?)
                add_service(s)
              end
            else
              # parallel lookup
              @ids.each do |id|
                s = p.get_service(id.attr_type, id.attr_algorithm)
                if (!(s).nil?)
                  add_service(s)
                end
              end
            end
          end
        end
        
        typesig { [::Java::Int] }
        def get(index)
          s = try_get(index)
          if ((s).nil?)
            raise self.class::IndexOutOfBoundsException.new
          end
          return s
        end
        
        typesig { [] }
        def size
          n = 0
          if (!(@services).nil?)
            n = @services.size
          else
            n = (!(@first_service).nil?) ? 1 : 0
          end
          while (!(try_get(n)).nil?)
            n += 1
          end
          return n
        end
        
        typesig { [] }
        # override isEmpty() and iterator() to not call size()
        # this avoids loading + checking all Providers
        def is_empty
          return ((try_get(0)).nil?)
        end
        
        typesig { [] }
        def iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members ServiceList
            include self::Iterator if self::Iterator.class == Module
            
            attr_accessor :index
            alias_method :attr_index, :index
            undef_method :index
            alias_method :attr_index=, :index=
            undef_method :index=
            
            typesig { [] }
            define_method :has_next do
              return !(try_get(@index)).nil?
            end
            
            typesig { [] }
            define_method :next_ do
              s = try_get(@index)
              if ((s).nil?)
                raise self.class::NoSuchElementException.new
              end
              @index += 1
              return s
            end
            
            typesig { [] }
            define_method :remove do
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [] }
            define_method :initialize do
              @index = 0
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        private
        alias_method :initialize__service_list, :initialize
      end }
    }
    
    private
    alias_method :initialize__provider_list, :initialize
  end
  
end
