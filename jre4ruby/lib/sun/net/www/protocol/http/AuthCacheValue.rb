require "rjava"

# 
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
module Sun::Net::Www::Protocol::Http
  module AuthCacheValueImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Serializable
      include ::Java::Net
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
    }
  end
  
  # 
  # AuthCacheValue: interface to minimise exposure to authentication cache
  # for external users (ie. plugin)
  # 
  # @author Michael McMahon
  class AuthCacheValue 
    include_class_members AuthCacheValueImports
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:Proxy) { Type::Proxy }
      const_attr_reader  :Proxy
      
      const_set_lazy(:Server) { Type::Server }
      const_attr_reader  :Server
      
      class Type 
        include_class_members AuthCacheValue
        
        class_module.module_eval {
          const_set_lazy(:Proxy) { Type.new.set_value_name("Proxy") }
          const_attr_reader  :Proxy
          
          const_set_lazy(:Server) { Type.new.set_value_name("Server") }
          const_attr_reader  :Server
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [Proxy, Server]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__type, :initialize
      end
      
      # 
      # Caches authentication info entered by user.  See cacheKey()
      
      def cache
        defined?(@@cache) ? @@cache : @@cache= AuthCacheImpl.new
      end
      alias_method :attr_cache, :cache
      
      def cache=(value)
        @@cache = value
      end
      alias_method :attr_cache=, :cache=
      
      typesig { [AuthCache] }
      def set_auth_cache(map)
        self.attr_cache = map
      end
    }
    
    typesig { [] }
    # Package private ctor to prevent extension outside package
    def initialize
    end
    
    typesig { [] }
    def get_auth_type
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # name of server/proxy
    def get_host
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # portnumber of server/proxy
    def get_port
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # realm of authentication if known
    def get_realm
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # root path of realm or the request path if the root
    # is not known yet.
    def get_path
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # returns http or https
    def get_protocol_scheme
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # the credentials associated with this authentication
    def credentials
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__auth_cache_value, :initialize
  end
  
end
