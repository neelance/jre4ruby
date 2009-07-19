require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TimeZoneNameUtilityImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Spi, :TimeZoneNameProvider
      include_const ::Sun::Util::Calendar, :ZoneInfo
      include_const ::Sun::Util::Resources, :LocaleData
      include_const ::Sun::Util::Resources, :OpenListResourceBundle
    }
  end
  
  # Utility class that deals with the localized time zone names
  class TimeZoneNameUtility 
    include_class_members TimeZoneNameUtilityImports
    
    class_module.module_eval {
      # cache to hold time zone resource bundles. Keyed by Locale
      
      def cached_bundles
        defined?(@@cached_bundles) ? @@cached_bundles : @@cached_bundles= ConcurrentHashMap.new
      end
      alias_method :attr_cached_bundles, :cached_bundles
      
      def cached_bundles=(value)
        @@cached_bundles = value
      end
      alias_method :attr_cached_bundles=, :cached_bundles=
      
      # cache to hold time zone localized strings. Keyed by Locale
      
      def cached_zone_data
        defined?(@@cached_zone_data) ? @@cached_zone_data : @@cached_zone_data= ConcurrentHashMap.new
      end
      alias_method :attr_cached_zone_data, :cached_zone_data
      
      def cached_zone_data=(value)
        @@cached_zone_data = value
      end
      alias_method :attr_cached_zone_data=, :cached_zone_data=
      
      typesig { [Locale] }
      # get time zone localized strings. Enumerate all keys.
      def get_zone_strings(locale)
        zones = nil
        data = self.attr_cached_zone_data.get(locale)
        if ((data).nil? || (((zones = data.get)).nil?))
          zones = load_zone_strings(locale)
          data = SoftReference.new(zones)
          self.attr_cached_zone_data.put(locale, data)
        end
        return zones
      end
      
      typesig { [Locale] }
      def load_zone_strings(locale)
        zones = LinkedList.new
        rb = get_bundle(locale)
        keys = rb.get_keys
        names = nil
        while (keys.has_more_elements)
          key = keys.next_element
          names = retrieve_display_names(rb, key, locale)
          if (!(names).nil?)
            zones.add(names)
          end
        end
        zones_array = Array.typed(String).new(zones.size) { nil }
        return zones.to_array(zones_array)
      end
      
      typesig { [String, Locale] }
      # Retrieve display names for a time zone ID.
      def retrieve_display_names(id, locale)
        rb = get_bundle(locale)
        return retrieve_display_names(rb, id, locale)
      end
      
      typesig { [OpenListResourceBundle, String, Locale] }
      def retrieve_display_names(rb, id, locale)
        pool = LocaleServiceProviderPool.get_pool(TimeZoneNameProvider.class)
        names = nil
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        if (pool.has_providers)
          names = pool.get_localized_object(TimeZoneNameGetter::INSTANCE, locale, rb, id)
        end
        if ((names).nil?)
          begin
            names = rb.get_string_array(id)
          rescue MissingResourceException => mre
            # fall through
          end
        end
        return names
      end
      
      typesig { [Locale] }
      def get_bundle(locale)
        rb = nil
        data = self.attr_cached_bundles.get(locale)
        if ((data).nil? || (((rb = data.get)).nil?))
          rb = LocaleData.get_time_zone_names(locale)
          data = SoftReference.new(rb)
          self.attr_cached_bundles.put(locale, data)
        end
        return rb
      end
      
      # Obtains a localized time zone strings from a TimeZoneNameProvider
      # implementation.
      const_set_lazy(:TimeZoneNameGetter) { Class.new do
        include_class_members TimeZoneNameUtility
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { TimeZoneNameGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [TimeZoneNameProvider, Locale, String, Object] }
        def get_object(time_zone_name_provider, locale, request_id, *params)
          raise AssertError if not ((params.attr_length).equal?(0))
          names = nil
          query_id = request_id
          if ((query_id == "GMT"))
            names = build_zone_strings(time_zone_name_provider, locale, query_id)
          else
            aliases = ZoneInfo.get_alias_table
            if (!(aliases).nil?)
              # Check whether this id is an alias, if so,
              # look for the standard id.
              if (aliases.contains_key(query_id))
                prev_id = query_id
                while (!((query_id = (aliases.get(query_id)).to_s)).nil?)
                  prev_id = query_id
                end
                query_id = prev_id
              end
              names = build_zone_strings(time_zone_name_provider, locale, query_id)
              if ((names).nil?)
                # There may be a case that a standard id has become an
                # alias.  so, check the aliases backward.
                names = examine_aliases(time_zone_name_provider, locale, query_id, aliases, aliases.entry_set)
              end
            end
          end
          if (!(names).nil?)
            names[0] = request_id
          end
          return names
        end
        
        class_module.module_eval {
          typesig { [TimeZoneNameProvider, Locale, String, Map, JavaSet] }
          def examine_aliases(tznp, locale, id, aliases, aliases_set)
            if (aliases.contains_value(id))
              aliases_set.each do |entry|
                if ((entry.get_value == id))
                  alias_ = entry.get_key
                  names = build_zone_strings(tznp, locale, alias_)
                  if (!(names).nil?)
                    return names
                  else
                    names = examine_aliases(tznp, locale, alias_, aliases, aliases_set)
                    if (!(names).nil?)
                      return names
                    end
                  end
                end
              end
            end
            return nil
          end
          
          typesig { [TimeZoneNameProvider, Locale, String] }
          def build_zone_strings(tznp, locale, id)
            names = Array.typed(String).new(5) { nil }
            i = 1
            while i <= 4
              names[i] = tznp.get_display_name(id, i >= 3, i % 2, locale)
              if (i >= 3 && (names[i]).nil?)
                names[i] = names[i - 2]
              end
              ((i += 1) - 1)
            end
            if ((names[1]).nil?)
              # this id seems not localized by this provider
              names = nil
            end
            return names
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__time_zone_name_getter, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__time_zone_name_utility, :initialize
  end
  
end
