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
module Sun::Net::Www::Protocol::Http
  module AuthCacheImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
    }
  end
  
  # @author Michael McMahon
  class AuthCacheImpl 
    include_class_members AuthCacheImplImports
    include AuthCache
    
    attr_accessor :hashtable
    alias_method :attr_hashtable, :hashtable
    undef_method :hashtable
    alias_method :attr_hashtable=, :hashtable=
    undef_method :hashtable=
    
    typesig { [] }
    def initialize
      @hashtable = nil
      @hashtable = HashMap.new
    end
    
    typesig { [HashMap] }
    def set_map(map)
      @hashtable = map
    end
    
    typesig { [String, AuthCacheValue] }
    # put a value in map according to primary key + secondary key which
    # is the path field of AuthenticationInfo
    def put(pkey, value)
      synchronized(self) do
        list = @hashtable.get(pkey)
        skey = value.get_path
        if ((list).nil?)
          list = LinkedList.new
          @hashtable.put(pkey, list)
        end
        # Check if the path already exists or a super-set of it exists
        iter = list.list_iterator
        while (iter.has_next)
          inf = iter.next_
          if ((inf.attr_path).nil? || inf.attr_path.starts_with(skey))
            iter.remove
          end
        end
        iter.add(value)
      end
    end
    
    typesig { [String, String] }
    # get a value from map checking both primary
    # and secondary (urlpath) key
    def get(pkey, skey)
      synchronized(self) do
        result = nil
        list = @hashtable.get(pkey)
        if ((list).nil? || (list.size).equal?(0))
          return nil
        end
        if ((skey).nil?)
          # list should contain only one element
          return list.get(0)
        end
        iter = list.list_iterator
        while (iter.has_next)
          inf = iter.next_
          if (skey.starts_with(inf.attr_path))
            return inf
          end
        end
        return nil
      end
    end
    
    typesig { [String, AuthCacheValue] }
    def remove(pkey, entry)
      synchronized(self) do
        list = @hashtable.get(pkey)
        if ((list).nil?)
          return
        end
        if ((entry).nil?)
          list.clear
          return
        end
        iter = list.list_iterator
        while (iter.has_next)
          inf = iter.next_
          if ((entry == inf))
            iter.remove
          end
        end
      end
    end
    
    private
    alias_method :initialize__auth_cache_impl, :initialize
  end
  
end
