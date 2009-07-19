require "rjava"

# Copyright 2002-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module ExpiringCacheImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :LinkedHashMap
      include_const ::Java::Util, :JavaSet
    }
  end
  
  class ExpiringCache 
    include_class_members ExpiringCacheImports
    
    attr_accessor :millis_until_expiration
    alias_method :attr_millis_until_expiration, :millis_until_expiration
    undef_method :millis_until_expiration
    alias_method :attr_millis_until_expiration=, :millis_until_expiration=
    undef_method :millis_until_expiration=
    
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    # Clear out old entries every few queries
    attr_accessor :query_count
    alias_method :attr_query_count, :query_count
    undef_method :query_count
    alias_method :attr_query_count=, :query_count=
    undef_method :query_count=
    
    attr_accessor :query_overflow
    alias_method :attr_query_overflow, :query_overflow
    undef_method :query_overflow
    alias_method :attr_query_overflow=, :query_overflow=
    undef_method :query_overflow=
    
    attr_accessor :max_entries
    alias_method :attr_max_entries, :max_entries
    undef_method :max_entries
    alias_method :attr_max_entries=, :max_entries=
    undef_method :max_entries=
    
    class_module.module_eval {
      const_set_lazy(:Entry) { Class.new do
        include_class_members ExpiringCache
        
        attr_accessor :timestamp
        alias_method :attr_timestamp, :timestamp
        undef_method :timestamp
        alias_method :attr_timestamp=, :timestamp=
        undef_method :timestamp=
        
        attr_accessor :val
        alias_method :attr_val, :val
        undef_method :val
        alias_method :attr_val=, :val=
        undef_method :val=
        
        typesig { [::Java::Long, String] }
        def initialize(timestamp, val)
          @timestamp = 0
          @val = nil
          @timestamp = timestamp
          @val = val
        end
        
        typesig { [] }
        def timestamp
          return @timestamp
        end
        
        typesig { [::Java::Long] }
        def set_timestamp(timestamp)
          @timestamp = timestamp
        end
        
        typesig { [] }
        def val
          return @val
        end
        
        typesig { [String] }
        def set_val(val)
          @val = val
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
      initialize__expiring_cache(30000)
    end
    
    typesig { [::Java::Long] }
    def initialize(millis_until_expiration)
      @millis_until_expiration = 0
      @map = nil
      @query_count = 0
      @query_overflow = 300
      @max_entries = 200
      @millis_until_expiration = millis_until_expiration
      @map = Class.new(LinkedHashMap.class == Class ? LinkedHashMap : Object) do
        extend LocalClass
        include_class_members ExpiringCache
        include LinkedHashMap if LinkedHashMap.class == Module
        
        typesig { [Map::Entry] }
        define_method :remove_eldest_entry do |eldest|
          return size > MAX_ENTRIES
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
    def get(key)
      synchronized(self) do
        if ((@query_count += 1) >= @query_overflow)
          cleanup
        end
        entry = entry_for(key)
        if (!(entry).nil?)
          return entry.val
        end
        return nil
      end
    end
    
    typesig { [String, String] }
    def put(key, val_)
      synchronized(self) do
        if ((@query_count += 1) >= @query_overflow)
          cleanup
        end
        entry = entry_for(key)
        if (!(entry).nil?)
          entry.set_timestamp(System.current_time_millis)
          entry.set_val(val_)
        else
          @map.put(key, Entry.new(System.current_time_millis, val_))
        end
      end
    end
    
    typesig { [] }
    def clear
      synchronized(self) do
        @map.clear
      end
    end
    
    typesig { [String] }
    def entry_for(key)
      entry = @map.get(key)
      if (!(entry).nil?)
        delta = System.current_time_millis - entry.timestamp
        if (delta < 0 || delta >= @millis_until_expiration)
          @map.remove(key)
          entry = nil
        end
      end
      return entry
    end
    
    typesig { [] }
    def cleanup
      key_set_ = @map.key_set
      # Avoid ConcurrentModificationExceptions
      keys = Array.typed(String).new(key_set_.size) { nil }
      i = 0
      iter = key_set_.iterator
      while iter.has_next
        key = iter.next
        keys[((i += 1) - 1)] = key
      end
      j = 0
      while j < keys.attr_length
        entry_for(keys[j])
        ((j += 1) - 1)
      end
      @query_count = 0
    end
    
    private
    alias_method :initialize__expiring_cache, :initialize
  end
  
end
