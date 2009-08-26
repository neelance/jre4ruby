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
module Sun::Net::Httpserver
  module UnmodifiableHeadersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Util
      include ::Com::Sun::Net::Httpserver
    }
  end
  
  class UnmodifiableHeaders < UnmodifiableHeadersImports.const_get :Headers
    include_class_members UnmodifiableHeadersImports
    
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    typesig { [Headers] }
    def initialize(map)
      @map = nil
      super()
      @map = map
    end
    
    typesig { [] }
    def size
      return @map.size
    end
    
    typesig { [] }
    def is_empty
      return @map.is_empty
    end
    
    typesig { [Object] }
    def contains_key(key)
      return @map.contains_key(key)
    end
    
    typesig { [Object] }
    def contains_value(value)
      return @map.contains_value(value)
    end
    
    typesig { [Object] }
    def get(key)
      return @map.get(key)
    end
    
    typesig { [String] }
    def get_first(key)
      return @map.get_first(key)
    end
    
    typesig { [String, SwtList] }
    def put(key, value)
      return @map.put(key, value)
    end
    
    typesig { [String, String] }
    def add(key, value)
      raise UnsupportedOperationException.new("unsupported operation")
    end
    
    typesig { [String, String] }
    def set(key, value)
      raise UnsupportedOperationException.new("unsupported operation")
    end
    
    typesig { [Object] }
    def remove(key)
      raise UnsupportedOperationException.new("unsupported operation")
    end
    
    typesig { [Map] }
    def put_all(t)
      raise UnsupportedOperationException.new("unsupported operation")
    end
    
    typesig { [] }
    def clear
      raise UnsupportedOperationException.new("unsupported operation")
    end
    
    typesig { [] }
    def key_set
      return Collections.unmodifiable_set(@map.key_set)
    end
    
    typesig { [] }
    def values
      return Collections.unmodifiable_collection(@map.values)
    end
    
    typesig { [] }
    # TODO check that contents of set are not modifable : security
    def entry_set
      return Collections.unmodifiable_set(@map.entry_set)
    end
    
    typesig { [Object] }
    def ==(o)
      return (@map == o)
    end
    
    typesig { [] }
    def hash_code
      return @map.hash_code
    end
    
    private
    alias_method :initialize__unmodifiable_headers, :initialize
  end
  
end
