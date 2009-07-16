require "rjava"

# 
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
  module MemoryCredentialsCacheImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :JavaFile
    }
  end
  
  # Windows supports the "API: cache" type, which is a shared memory cache.  This is
  # implemented by krbcc32.dll as part of the MIT Kerberos for Win32 distribution.
  # MemoryCredentialsCache will provide future functions to access shared memeory cache on
  # Windows platform. Native code implementation may be necessary.
  # 
  # This class extends CredentialsCache. It is used for accessing data in shared memory
  # cache on Windows platforms.
  # 
  # @author Yanni Zhang
  class MemoryCredentialsCache < MemoryCredentialsCacheImports.const_get :CredentialsCache
    include_class_members MemoryCredentialsCacheImports
    
    class_module.module_eval {
      typesig { [PrincipalName] }
      def get_ccache_instance(p)
        return nil
      end
      
      typesig { [PrincipalName, JavaFile] }
      def get_ccache_instance(p, cache_file)
        return nil
      end
    }
    
    typesig { [String] }
    def exists(cache)
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
    
    typesig { [PrincipalName, Realm] }
    def get_creds(sname, srealm)
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_primary_principal
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__memory_credentials_cache, :initialize
  end
  
end
