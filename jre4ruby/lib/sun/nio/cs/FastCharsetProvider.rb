require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FastCharsetProviderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset::Spi, :CharsetProvider
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
    }
  end
  
  # Abstract base class for fast charset providers.
  # 
  # @author Mark Reinhold
  class FastCharsetProvider < FastCharsetProviderImports.const_get :CharsetProvider
    include_class_members FastCharsetProviderImports
    
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
    
    # Maps canonical names to cached instances
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
    
    typesig { [String, Map, Map, Map] }
    def initialize(pp, am, cm, c)
      @class_map = nil
      @alias_map = nil
      @cache = nil
      @package_prefix = nil
      super()
      @package_prefix = pp
      @alias_map = am
      @class_map = cm
      @cache = c
    end
    
    typesig { [String] }
    def canonicalize(csn)
      acn = @alias_map.get(csn)
      return (!(acn).nil?) ? acn : csn
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Private ASCII-only version, optimized for interpretation during startup
      def to_lower(s)
        n = s.length
        all_lower = true
        i = 0
        while i < n
          c = s.char_at(i)
          if (((c - Character.new(?A.ord)) | (Character.new(?Z.ord) - c)) >= 0)
            all_lower = false
            break
          end
          i += 1
        end
        if (all_lower)
          return s
        end
        ca = CharArray.new(n)
        i_ = 0
        while i_ < n
          c = s.char_at(i_)
          if (((c - Character.new(?A.ord)) | (Character.new(?Z.ord) - c)) >= 0)
            ca[i_] = RJava.cast_to_char((c + 0x20))
          else
            ca[i_] = RJava.cast_to_char(c)
          end
          i_ += 1
        end
        return String.new(ca)
      end
    }
    
    typesig { [String] }
    def lookup(charset_name)
      csn = canonicalize(to_lower(charset_name))
      # Check cache first
      cs = @cache.get(csn)
      if (!(cs).nil?)
        return cs
      end
      # Do we even support this charset?
      cln = @class_map.get(csn)
      if ((cln).nil?)
        return nil
      end
      if ((cln == "US_ASCII"))
        cs = US_ASCII.new
        @cache.put(csn, cs)
        return cs
      end
      # Instantiate the charset and cache it
      begin
        c = Class.for_name(@package_prefix + "." + cln, true, self.get_class.get_class_loader)
        cs = c.new_instance
        @cache.put(csn, cs)
        return cs
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
        return lookup(canonicalize(charset_name))
      end
    end
    
    typesig { [] }
    def charsets
      return Class.new(Iterator.class == Class ? Iterator : Object) do
        extend LocalClass
        include_class_members FastCharsetProvider
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
          @i = self.attr_class_map.key_set.iterator
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__fast_charset_provider, :initialize
  end
  
end
