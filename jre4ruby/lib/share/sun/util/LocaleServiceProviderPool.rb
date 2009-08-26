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
module Sun::Util
  module LocaleServiceProviderPoolImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedHashSet
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :ServiceLoader
      include_const ::Java::Util, :ServiceConfigurationError
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Logging, :Logger
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Util::Resources, :LocaleData
      include_const ::Sun::Util::Resources, :OpenListResourceBundle
    }
  end
  
  # An instance of this class holds a set of the third party implementations of a particular
  # locale sensitive service, such as {@link java.util.spi.LocaleNameProvider}.
  class LocaleServiceProviderPool 
    include_class_members LocaleServiceProviderPoolImports
    
    class_module.module_eval {
      # A Map that holds singleton instances of this class.  Each instance holds a
      # set of provider implementations of a particular locale sensitive service.
      
      def pool_of_pools
        defined?(@@pool_of_pools) ? @@pool_of_pools : @@pool_of_pools= ConcurrentHashMap.new
      end
      alias_method :attr_pool_of_pools, :pool_of_pools
      
      def pool_of_pools=(value)
        @@pool_of_pools = value
      end
      alias_method :attr_pool_of_pools=, :pool_of_pools=
    }
    
    # A Set containing locale service providers that implement the
    # specified provider SPI
    attr_accessor :providers
    alias_method :attr_providers, :providers
    undef_method :providers
    alias_method :attr_providers=, :providers=
    undef_method :providers=
    
    # A Map that retains Locale->provider mapping
    attr_accessor :providers_cache
    alias_method :attr_providers_cache, :providers_cache
    undef_method :providers_cache
    alias_method :attr_providers_cache=, :providers_cache=
    undef_method :providers_cache=
    
    # Available locales for this locale sensitive service.  This also contains
    # JRE's available locales
    attr_accessor :available_locales
    alias_method :attr_available_locales, :available_locales
    undef_method :available_locales
    alias_method :attr_available_locales=, :available_locales=
    undef_method :available_locales=
    
    class_module.module_eval {
      # Available locales within this JRE.  Currently this is declared as
      # static.  This could be non-static later, so that they could have
      # different sets for each locale sensitive services.
      
      def available_jrelocales
        defined?(@@available_jrelocales) ? @@available_jrelocales : @@available_jrelocales= nil
      end
      alias_method :attr_available_jrelocales, :available_jrelocales
      
      def available_jrelocales=(value)
        @@available_jrelocales = value
      end
      alias_method :attr_available_jrelocales=, :available_jrelocales=
    }
    
    # Provider locales for this locale sensitive service.
    attr_accessor :provider_locales
    alias_method :attr_provider_locales, :provider_locales
    undef_method :provider_locales
    alias_method :attr_provider_locales=, :provider_locales=
    undef_method :provider_locales=
    
    class_module.module_eval {
      typesig { [Class] }
      # A factory method that returns a singleton instance
      def get_pool(provider_class)
        pool = self.attr_pool_of_pools.get(provider_class)
        if ((pool).nil?)
          new_pool = LocaleServiceProviderPool.new(provider_class)
          pool = self.attr_pool_of_pools.put(provider_class, new_pool)
          if ((pool).nil?)
            pool = new_pool
          end
        end
        return pool
      end
    }
    
    typesig { [Class] }
    # The sole constructor.
    # 
    # @param c class of the locale sensitive service
    def initialize(c)
      @providers = LinkedHashSet.new
      @providers_cache = ConcurrentHashMap.new
      @available_locales = nil
      @provider_locales = nil
      begin
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members LocaleServiceProviderPool
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            ServiceLoader.load_installed(c).each do |provider|
              self.attr_providers.add(provider)
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
      rescue PrivilegedActionException => e
        Logger.get_logger("sun.util.LocaleServiceProviderPool").config(e.to_s)
      end
    end
    
    class_module.module_eval {
      # Lazy loaded set of available locales.
      # Loading all locales is a very long operation.
      const_set_lazy(:AllAvailableLocales) { Class.new do
        include_class_members LocaleServiceProviderPool
        
        class_module.module_eval {
          when_class_loaded do
            provider_classes = Array.typed(self.class::Class).new([Java::Text::Spi::BreakIteratorProvider, Java::Text::Spi::CollatorProvider, Java::Text::Spi::DateFormatProvider, Java::Text::Spi::DateFormatSymbolsProvider, Java::Text::Spi::DecimalFormatSymbolsProvider, Java::Text::Spi::NumberFormatProvider, Java::Util::Spi::CurrencyNameProvider, Java::Util::Spi::LocaleNameProvider, Java::Util::Spi::TimeZoneNameProvider])
            all = self.class::HashSet.new(Arrays.as_list(LocaleData.get_available_locales))
            provider_classes.each do |providerClass|
              pool = LocaleServiceProviderPool.get_pool(provider_class)
              all.add_all(pool.get_provider_locales)
            end
            const_set :AllAvailableLocales, all.to_array(Array.typed(self.class::Locale).new(0) { nil })
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__all_available_locales, :initialize
      end }
      
      typesig { [] }
      # Returns an array of available locales for all the provider classes.
      # This array is a merged array of all the locales that are provided by each
      # provider, including the JRE.
      # 
      # @return an array of the available locales for all provider classes
      def get_all_available_locales
        return AllAvailableLocales.attr_all_available_locales.clone
      end
    }
    
    typesig { [] }
    # Returns an array of available locales.  This array is a
    # merged array of all the locales that are provided by each
    # provider, including the JRE.
    # 
    # @return an array of the available locales
    def get_available_locales
      synchronized(self) do
        if ((@available_locales).nil?)
          @available_locales = HashSet.new(get_jrelocales)
          if (has_providers)
            @available_locales.add_all(get_provider_locales)
          end
        end
        tmp = Array.typed(Locale).new(@available_locales.size) { nil }
        @available_locales.to_array(tmp)
        return tmp
      end
    end
    
    typesig { [] }
    # Returns an array of available locales from providers.
    # Note that this method does not return a defensive copy.
    # 
    # @return list of the provider locales
    def get_provider_locales
      synchronized(self) do
        if ((@provider_locales).nil?)
          @provider_locales = HashSet.new
          if (has_providers)
            @providers.each do |lsp|
              locales = lsp.get_available_locales
              locales.each do |locale|
                @provider_locales.add(locale)
              end
            end
          end
        end
        return @provider_locales
      end
    end
    
    typesig { [] }
    # Returns whether any provider for this locale sensitive
    # service is available or not.
    # 
    # @return true if any provider is available
    def has_providers
      return !@providers.is_empty
    end
    
    typesig { [] }
    # Returns an array of available locales supported by the JRE.
    # Note that this method does not return a defensive copy.
    # 
    # @return list of the available JRE locales
    def get_jrelocales
      synchronized(self) do
        if ((self.attr_available_jrelocales).nil?)
          self.attr_available_jrelocales = Arrays.as_list(LocaleData.get_available_locales)
        end
        return self.attr_available_jrelocales
      end
    end
    
    typesig { [Locale] }
    # Returns whether the given locale is supported by the JRE.
    # 
    # @param locale the locale to test.
    # @return true, if the locale is supported by the JRE. false
    # otherwise.
    def is_jresupported(locale)
      locales = get_jrelocales
      return locales.contains(locale)
    end
    
    typesig { [LocalizedObjectGetter, Locale, Object] }
    # Returns the provider's localized object for the specified
    # locale.
    # 
    # @param getter an object on which getObject() method
    # is called to obtain the provider's instance.
    # @param locale the given locale that is used as the starting one
    # @param params provider specific parameters
    # @return provider's instance, or null.
    def get_localized_object(getter, locale, *params)
      return get_localized_object_impl(getter, locale, true, nil, nil, nil, params)
    end
    
    typesig { [LocalizedObjectGetter, Locale, OpenListResourceBundle, String, Object] }
    # Returns the provider's localized name for the specified
    # locale.
    # 
    # @param getter an object on which getObject() method
    # is called to obtain the provider's instance.
    # @param locale the given locale that is used as the starting one
    # @param bundle JRE resource bundle that contains
    # the localized names, or null for localized objects.
    # @param key the key string if bundle is supplied, otherwise null.
    # @param params provider specific parameters
    # @return provider's instance, or null.
    def get_localized_object(getter, locale, bundle, key, *params)
      return get_localized_object_impl(getter, locale, false, nil, bundle, key, params)
    end
    
    typesig { [LocalizedObjectGetter, Locale, String, OpenListResourceBundle, String, Object] }
    # Returns the provider's localized name for the specified
    # locale.
    # 
    # @param getter an object on which getObject() method
    # is called to obtain the provider's instance.
    # @param locale the given locale that is used as the starting one
    # @param bundleKey JRE specific bundle key. e.g., "USD" is for currency
    # symbol and "usd" is for currency display name in the JRE bundle.
    # @param bundle JRE resource bundle that contains
    # the localized names, or null for localized objects.
    # @param key the key string if bundle is supplied, otherwise null.
    # @param params provider specific parameters
    # @return provider's instance, or null.
    def get_localized_object(getter, locale, bundle_key, bundle, key, *params)
      return get_localized_object_impl(getter, locale, false, bundle_key, bundle, key, params)
    end
    
    typesig { [LocalizedObjectGetter, Locale, ::Java::Boolean, String, OpenListResourceBundle, String, Object] }
    def get_localized_object_impl(getter, locale, is_object_provider, bundle_key, bundle, key, *params)
      if (has_providers)
        if ((bundle_key).nil?)
          bundle_key = key
        end
        bundle_locale = (!(bundle).nil? ? bundle.get_locale : nil)
        requested = locale
        lsp = nil
        providers_obj = nil
        # check whether a provider has an implementation that's closer
        # to the requested locale than the bundle we've found (for
        # localized names), or Java runtime's supported locale
        # (for localized objects)
        while (!((locale = find_provider_locale(locale, bundle_locale))).nil?)
          lsp = find_provider(locale)
          if (!(lsp).nil?)
            providers_obj = getter.get_object(lsp, requested, key, params)
            if (!(providers_obj).nil?)
              return providers_obj
            else
              if (is_object_provider)
                Logger.get_logger("sun.util.LocaleServiceProviderPool").config("A locale sensitive service provider returned null for a localized objects,  which should not happen.  provider: " + RJava.cast_to_string(lsp) + " locale: " + RJava.cast_to_string(requested))
              end
            end
          end
          locale = get_parent_locale(locale)
        end
        # look up the JRE bundle and its parent chain.  Only
        # providers for localized names are checked hereafter.
        while (!(bundle).nil?)
          bundle_locale = bundle.get_locale
          if (bundle.handle_get_keys.contains(bundle_key))
            # JRE has it.
            return nil
          else
            lsp = find_provider(bundle_locale)
            if (!(lsp).nil?)
              providers_obj = getter.get_object(lsp, requested, key, params)
              if (!(providers_obj).nil?)
                return providers_obj
              end
            end
          end
          # try parent bundle
          bundle = bundle.get_parent
        end
      end
      # not found.
      return nil
    end
    
    typesig { [Locale] }
    # Returns a locale service provider instance that supports
    # the specified locale.
    # 
    # @param locale the given locale
    # @return the provider, or null if there is
    # no provider available.
    def find_provider(locale)
      if (!has_providers)
        return nil
      end
      if (@providers_cache.contains_key(locale))
        provider = @providers_cache.get(locale)
        if (!(provider).equal?(NullProvider::INSTANCE))
          return provider
        end
      else
        @providers.each do |lsp|
          locales = lsp.get_available_locales
          locales.each do |available|
            if ((locale == available))
              provider_in_cache = @providers_cache.put(locale, lsp)
              return (!(provider_in_cache).nil? ? provider_in_cache : lsp)
            end
          end
        end
        @providers_cache.put(locale, NullProvider::INSTANCE)
      end
      return nil
    end
    
    typesig { [Locale, Locale] }
    # Returns the provider's locale that is the most appropriate
    # within the range
    # 
    # @param start the given locale that is used as the starting one
    # @param end the given locale that is used as the end one (exclusive),
    # or null if it reaching any of the JRE supported locale should
    # terminate the look up.
    # @return the most specific locale within the range, or null
    # if no provider locale found in that range.
    def find_provider_locale(start, end_)
      prov_loc = get_provider_locales
      current = start
      while (!(current).nil?)
        if (!(end_).nil?)
          if ((current == end_))
            current = nil
            break
          end
        else
          if (is_jresupported(current))
            current = nil
            break
          end
        end
        if (prov_loc.contains(current))
          break
        end
        current = get_parent_locale(current)
      end
      return current
    end
    
    class_module.module_eval {
      typesig { [Locale] }
      # Returns the parent locale.
      # 
      # @param locale the locale
      # @return the parent locale
      def get_parent_locale(locale)
        variant = locale.get_variant
        if (!(variant).equal?(""))
          underscore_index = variant.last_index_of(Character.new(?_.ord))
          if (!(underscore_index).equal?((-1)))
            return Locale.new(locale.get_language, locale.get_country, variant.substring(0, underscore_index))
          else
            return Locale.new(locale.get_language, locale.get_country)
          end
        else
          if (!(locale.get_country).equal?(""))
            return Locale.new(locale.get_language)
          else
            if (!(locale.get_language).equal?(""))
              return Locale::ROOT
            else
              return nil
            end
          end
        end
      end
      
      # A dummy locale service provider that indicates there is no
      # provider available
      const_set_lazy(:NullProvider) { Class.new(LocaleServiceProvider) do
        include_class_members LocaleServiceProviderPool
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { self::NullProvider.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [] }
        def get_available_locales
          raise self.class::RuntimeException.new("Should not get called.")
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__null_provider, :initialize
      end }
      
      # An interface to get a localized object for each locale sensitve
      # service class.
      const_set_lazy(:LocalizedObjectGetter) { Module.new do
        include_class_members LocaleServiceProviderPool
        
        typesig { [Object, Locale, String, Object] }
        # Returns an object from the provider
        # 
        # @param lsp the provider
        # @param locale the locale
        # @param key key string to localize, or null if the provider is not
        # a name provider
        # @param params provider specific params
        # @return localized object from the provider
        def get_object(lsp, locale, key, *params)
          raise NotImplementedError
        end
      end }
    }
    
    private
    alias_method :initialize__locale_service_provider_pool, :initialize
  end
  
end
