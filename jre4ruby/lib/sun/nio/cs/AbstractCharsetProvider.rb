require "rjava"

# 
# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module AbstractCharsetProviderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset::Spi, :CharsetProvider
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :TreeMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Sun::Misc, :ASCIICaseInsensitiveComparator
    }
  end
  
  # 
  # Abstract base class for charset providers.
  # 
  # @author Mark Reinhold
  class AbstractCharsetProvider < AbstractCharsetProviderImports.const_get :CharsetProvider
    include_class_members AbstractCharsetProviderImports
    
    # Maps canonical names to class names
    attr_accessor :class_map
    alias_method :attr_class_map, :class_map
    undef_method :class_map
    alias_method :attr_class_map=, :class_map=
    undef_method :class_map=
    
    # Maps alias names to canonical names
    attr_accessor :alias_map
    alias_method :attr_alias_map, :alias_map
    undef_method :alias_map
    alias_method :attr_alias_map=, :alias_map=
    undef_method :alias_map=
    
    # Maps canonical names to alias-name arrays
    attr_accessor :alias_name_map
    alias_method :attr_alias_name_map, :alias_name_map
    undef_method :alias_name_map
    alias_method :attr_alias_name_map=, :alias_name_map=
    undef_method :alias_name_map=
    
    # Maps canonical names to soft references that hold cached instances
    attr_accessor :cache
    alias_method :attr_cache, :cache
    undef_method :cache
    alias_method :attr_cache=, :cache=
    undef_method :cache=
    
    attr_accessor :package_prefix
    alias_method :attr_package_prefix, :package_prefix
    undef_method :package_prefix
    alias_method :attr_package_prefix=, :package_prefix=
    undef_method :package_prefix=
    
    typesig { [] }
    def initialize
      @class_map = nil
      @alias_map = nil
      @alias_name_map = nil
      @cache = nil
      @package_prefix = nil
      super()
      @class_map = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @alias_map = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @alias_name_map = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @cache = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @package_prefix = "sun.nio.cs"
    end
    
    typesig { [String] }
    def initialize(pkg_prefix_name)
      @class_map = nil
      @alias_map = nil
      @alias_name_map = nil
      @cache = nil
      @package_prefix = nil
      super()
      @class_map = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @alias_map = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @alias_name_map = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @cache = TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
      @package_prefix = pkg_prefix_name
    end
    
    class_module.module_eval {
      typesig { [Map, String, Object] }
      # Add an entry to the given map, but only if no mapping yet exists
      # for the given name.
      def put(m, name, value)
        if (!m.contains_key(name))
          m.put(name, value)
        end
      end
      
      typesig { [Map, String] }
      def remove(m, name)
        x = m.remove(name)
        raise AssertError if not ((!(x).nil?))
      end
    }
    
    typesig { [String, String, Array.typed(String)] }
    # Declare support for the given charset
    def charset(name, class_name, aliases)
      synchronized((self)) do
        put(@class_map, name, class_name)
        i = 0
        while i < aliases.attr_length
          put(@alias_map, aliases[i], name)
          ((i += 1) - 1)
        end
        put(@alias_name_map, name, aliases)
        @cache.clear
      end
    end
    
    typesig { [String, Array.typed(String)] }
    def delete_charset(name, aliases)
      synchronized((self)) do
        remove(@class_map, name)
        i = 0
        while i < aliases.attr_length
          remove(@alias_map, aliases[i])
          ((i += 1) - 1)
        end
        remove(@alias_name_map, name)
        @cache.clear
      end
    end
    
    typesig { [] }
    # Late initialization hook, needed by some providers
    def init
    end
    
    typesig { [String] }
    def canonicalize(charset_name)
      acn = @alias_map.get(charset_name)
      return (!(acn).nil?) ? acn : charset_name
    end
    
    typesig { [String] }
    def lookup(csn)
      # Check cache first
      sr = @cache.get(csn)
      if (!(sr).nil?)
        cs = sr.get
        if (!(cs).nil?)
          return cs
        end
      end
      # Do we even support this charset?
      cln = @class_map.get(csn)
      if ((cln).nil?)
        return nil
      end
      # Instantiate the charset and cache it
      begin
        c = Class.for_name(@package_prefix + "." + cln, true, self.get_class.get_class_loader)
        cs_ = c.new_instance
        @cache.put(csn, SoftReference.new(cs_))
        return cs_
      rescue ClassNotFoundException => x
        return nil
      rescue IllegalAccessException => x
        return nil
      rescue InstantiationException => x
        return nil
      end
    end
    
    typesig { [String] }
    def charset_for_name(charset_name)
      synchronized((self)) do
        init
        return lookup(canonicalize(charset_name))
      end
    end
    
    typesig { [] }
    def charsets
      ks = nil
      synchronized((self)) do
        init
        ks = ArrayList.new(@class_map.key_set)
      end
      return Class.new(Iterator.class == Class ? Iterator : Object) do
        extend LocalClass
        include_class_members AbstractCharsetProvider
        include Iterator if Iterator.class == Module
        
        attr_accessor :i
        alias_method :attr_i, :i
        undef_method :i
        alias_method :attr_i=, :i=
        undef_method :i=
        
        typesig { [] }
        define_method :has_next do
          return @i.has_next
        end
        
        typesig { [] }
        define_method :next do
          csn = @i.next
          return lookup(csn)
        end
        
        typesig { [] }
        define_method :remove do
          raise UnsupportedOperationException.new
        end
        
        typesig { [] }
        define_method :initialize do
          @i = nil
          super()
          @i = ks.iterator
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [String] }
    def aliases(charset_name)
      synchronized((self)) do
        init
        return @alias_name_map.get(charset_name)
      end
    end
    
    private
    alias_method :initialize__abstract_charset_provider, :initialize
  end
  
end
