require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module VerificationProviderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Util
      include ::Java::Security
      include_const ::Sun::Security::Action, :PutAllAction
      include_const ::Sun::Security::Rsa, :SunRsaSignEntries
    }
  end
  
  # Provider used for verification of signed JAR files *if* the Sun and
  # SunRsaSign main classes have been removed. Otherwise, this provider is not
  # necessary and registers no algorithms. This functionality only exists to
  # support a use case required by a specific customer and is not generally
  # supported.
  # 
  # @since  1.7
  # @author Andreas Sterbenz
  class VerificationProvider < VerificationProviderImports.const_get :Provider
    include_class_members VerificationProviderImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7482667077568930381 }
      const_attr_reader  :SerialVersionUID
      
      when_class_loaded do
        b = false
        begin
          Class.for_name("sun.security.provider.Sun")
          Class.for_name("sun.security.rsa.SunRsaSign")
          b = false
        rescue ClassNotFoundException => e
          b = true
        end
        const_set :ACTIVE, b
      end
    }
    
    typesig { [] }
    def initialize
      super("SunJarVerification", 1.7, "Jar Verification Provider")
      # register all algorithms normally registered by the Sun and SunRsaSign
      # providers, but only if they are missing
      if ((ACTIVE).equal?(false))
        return
      end
      # if there is no security manager installed, put directly into
      # the provider. Otherwise, create a temporary map and use a
      # doPrivileged() call at the end to transfer the contents
      if ((System.get_security_manager).nil?)
        SunEntries.put_entries(self)
        SunRsaSignEntries.put_entries(self)
      else
        # use LinkedHashMap to preserve the order of the PRNGs
        map = LinkedHashMap.new
        SunEntries.put_entries(map)
        SunRsaSignEntries.put_entries(map)
        AccessController.do_privileged(PutAllAction.new(self, map))
      end
    end
    
    private
    alias_method :initialize__verification_provider, :initialize
  end
  
end
