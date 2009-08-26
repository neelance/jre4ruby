require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module KeyCacheImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include ::Java::Lang::Ref
      include_const ::Java::Security, :Key
      include_const ::Sun::Security::Util, :Cache
    }
  end
  
  # Key to P11Key translation cache. The PKCS#11 token can only perform
  # operations on keys stored on the token (permanently or temporarily). That
  # means that in order to allow the PKCS#11 provider to use keys from other
  # providers, we need to transparently convert them to P11Keys. The engines
  # do that using (Secret)KeyFactories, which in turn use this class as a
  # cache.
  # 
  # There are two KeyCache instances per provider, one for secret keys and
  # one for public and private keys.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class KeyCache 
    include_class_members KeyCacheImports
    
    attr_accessor :strong_cache
    alias_method :attr_strong_cache, :strong_cache
    undef_method :strong_cache
    alias_method :attr_strong_cache=, :strong_cache=
    undef_method :strong_cache=
    
    attr_accessor :cache_reference
    alias_method :attr_cache_reference, :cache_reference
    undef_method :cache_reference
    alias_method :attr_cache_reference=, :cache_reference=
    undef_method :cache_reference=
    
    typesig { [] }
    def initialize
      @strong_cache = nil
      @cache_reference = nil
      @strong_cache = Cache.new_hard_memory_cache(16)
    end
    
    class_module.module_eval {
      const_set_lazy(:IdentityWrapper) { Class.new do
        include_class_members KeyCache
        
        attr_accessor :obj
        alias_method :attr_obj, :obj
        undef_method :obj
        alias_method :attr_obj=, :obj=
        undef_method :obj=
        
        typesig { [self::Object] }
        def initialize(obj)
          @obj = nil
          @obj = obj
        end
        
        typesig { [self::Object] }
        def ==(o)
          if ((self).equal?(o))
            return true
          end
          if ((o.is_a?(self.class::IdentityWrapper)).equal?(false))
            return false
          end
          other = o
          return (@obj).equal?(other.attr_obj)
        end
        
        typesig { [] }
        def hash_code
          return System.identity_hash_code(@obj)
        end
        
        private
        alias_method :initialize__identity_wrapper, :initialize
      end }
    }
    
    typesig { [Key] }
    def get(key)
      synchronized(self) do
        p11key = @strong_cache.get(IdentityWrapper.new(key))
        if (!(p11key).nil?)
          return p11key
        end
        map = ((@cache_reference).nil?) ? nil : @cache_reference.get
        if ((map).nil?)
          return nil
        end
        return map.get(key)
      end
    end
    
    typesig { [Key, P11Key] }
    def put(key, p11key)
      synchronized(self) do
        @strong_cache.put(IdentityWrapper.new(key), p11key)
        map = ((@cache_reference).nil?) ? nil : @cache_reference.get
        if ((map).nil?)
          map = IdentityHashMap.new
          @cache_reference = WeakReference.new(map)
        end
        map.put(key, p11key)
      end
    end
    
    private
    alias_method :initialize__key_cache, :initialize
  end
  
end
