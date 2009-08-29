require "rjava"

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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Ccache
  module CredentialsCacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
    }
  end
  
  # CredentialsCache stores credentials(tickets, session keys, etc) in a semi-permanent store
  # for later use by different program.
  # 
  # @author Yanni Zhang
  class CredentialsCache 
    include_class_members CredentialsCacheImports
    
    class_module.module_eval {
      
      def singleton
        defined?(@@singleton) ? @@singleton : @@singleton= nil
      end
      alias_method :attr_singleton, :singleton
      
      def singleton=(value)
        @@singleton = value
      end
      alias_method :attr_singleton=, :singleton=
      
      
      def cache_name
        defined?(@@cache_name) ? @@cache_name : @@cache_name= nil
      end
      alias_method :attr_cache_name, :cache_name
      
      def cache_name=(value)
        @@cache_name = value
      end
      alias_method :attr_cache_name=, :cache_name=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [PrincipalName] }
      def get_instance(principal)
        return FileCredentialsCache.acquire_instance(principal, nil)
      end
      
      typesig { [String] }
      def get_instance(cache)
        if ((cache.length >= 5) && cache.substring(0, 5).equals_ignore_case("FILE:"))
          return FileCredentialsCache.acquire_instance(nil, cache.substring(5))
        end
        # XXX else, memory credential cache
        # default is file credential cache.
        return FileCredentialsCache.acquire_instance(nil, cache)
      end
      
      typesig { [PrincipalName, String] }
      def get_instance(principal, cache)
        # XXX Modify this to use URL framework of the JDK
        if (!(cache).nil? && (cache.length >= 5) && cache.region_matches(true, 0, "FILE:", 0, 5))
          return FileCredentialsCache.acquire_instance(principal, cache.substring(5))
        end
        # When cache is null, read the default cache.
        # XXX else ..we haven't provided support for memory credential cache
        # yet. (supported in native code)
        # default is file credentials cache.
        return FileCredentialsCache.acquire_instance(principal, cache)
      end
      
      typesig { [] }
      # Gets the default credentials cache.
      def get_instance
        # Default credentials cache is file-based.
        return FileCredentialsCache.acquire_instance
      end
      
      typesig { [PrincipalName, String] }
      def create(principal, name)
        if ((name).nil?)
          raise RuntimeException.new("cache name error")
        end
        if ((name.length >= 5) && name.region_matches(true, 0, "FILE:", 0, 5))
          name = RJava.cast_to_string(name.substring(5))
          return (FileCredentialsCache._new(principal, name))
        end
        # else return file credentials cache
        # default is file credentials cache.
        return (FileCredentialsCache._new(principal, name))
      end
      
      typesig { [PrincipalName] }
      def create(principal)
        # create a default credentials cache for a specified principal
        return (FileCredentialsCache._new(principal))
      end
      
      typesig { [] }
      def cache_name
        return self.attr_cache_name
      end
    }
    
    typesig { [] }
    def get_primary_principal
      raise NotImplementedError
    end
    
    typesig { [Credentials] }
    def update(c)
      raise NotImplementedError
    end
    
    typesig { [] }
    def save
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_creds_list
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_default_creds
      raise NotImplementedError
    end
    
    typesig { [PrincipalName, Realm] }
    def get_creds(sname, srealm)
      raise NotImplementedError
    end
    
    typesig { [LoginOptions, PrincipalName, Realm] }
    def get_creds(options, sname, srealm)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__credentials_cache, :initialize
  end
  
end
