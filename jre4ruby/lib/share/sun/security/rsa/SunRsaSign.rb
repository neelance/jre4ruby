require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Rsa
  module SunRsaSignImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include ::Java::Util
      include ::Java::Security
      include_const ::Sun::Security::Action, :PutAllAction
    }
  end
  
  # Provider class for the RSA signature provider. Supports RSA keyfactory,
  # keypair generation, and RSA signatures.
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class SunRsaSign < SunRsaSignImports.const_get :Provider
    include_class_members SunRsaSignImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 866040293550393045 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    def initialize
      super("SunRsaSign", 1.7, "Sun RSA signature provider")
      # if there is no security manager installed, put directly into
      # the provider. Otherwise, create a temporary map and use a
      # doPrivileged() call at the end to transfer the contents
      if ((System.get_security_manager).nil?)
        SunRsaSignEntries.put_entries(self)
      else
        # use LinkedHashMap to preserve the order of the PRNGs
        map = HashMap.new
        SunRsaSignEntries.put_entries(map)
        AccessController.do_privileged(PutAllAction.new(self, map))
      end
    end
    
    private
    alias_method :initialize__sun_rsa_sign, :initialize
  end
  
end
