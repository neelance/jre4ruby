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
  module AuthCacheImports
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
  # 
  # Interface provided by internal http authentication cache.
  # NB. This API will be replaced in a future release, and should
  # not be made public.
  module AuthCache
    include_class_members AuthCacheImports
    
    typesig { [String, AuthCacheValue] }
    # Put an entry in the cache. pkey is a string specified as follows:
    # 
    # A:[B:]C:D:E[:F]   Between 4 and 6 fields separated by ":"
    # where the fields have the following meaning:
    # A is "s" or "p" for server or proxy authentication respectively
    # B is optional and is "D", "B", or "N" for digest, basic or ntlm auth.
    # C is either "http" or "https"
    # D is the hostname
    # E is the port number
    # F is optional and if present is the realm
    # 
    # Generally, two entries are created for each AuthCacheValue,
    # one including the realm and one without the realm.
    # Also, for some schemes (digest) multiple entries may be created
    # with the same pkey, but with a different path value in
    # the AuthCacheValue.
    def put(pkey, value)
      raise NotImplementedError
    end
    
    typesig { [String, String] }
    # Get an entry from the cache based on pkey as described above, but also
    # using a pathname (skey) and the cache must return an entry
    # if skey is a sub-path of the AuthCacheValue.path field.
    def get(pkey, skey)
      raise NotImplementedError
    end
    
    typesig { [String, AuthCacheValue] }
    # remove the entry from the cache whose pkey is specified and
    # whose path is equal to entry.path. If entry is null then
    # all entries with the same pkey should be removed.
    def remove(pkey, entry)
      raise NotImplementedError
    end
  end
  
end
