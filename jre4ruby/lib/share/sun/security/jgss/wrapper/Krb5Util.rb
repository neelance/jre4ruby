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
module Sun::Security::Jgss::Wrapper
  module Krb5UtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Wrapper
      include ::Org::Ietf::Jgss
      include_const ::Javax::Security::Auth::Kerberos, :ServicePermission
    }
  end
  
  # This class is an utility class for Kerberos related stuff.
  # @author Valerie Peng
  # @since 1.6
  class Krb5Util 
    include_class_members Krb5UtilImports
    
    class_module.module_eval {
      typesig { [GSSNameElement] }
      # Return the Kerberos TGS principal name using the domain
      # of the specified <code>name</code>
      def get_tgsname(name)
        krb_princ = name.get_krb_name
        at_index = krb_princ.index_of("@")
        realm = krb_princ.substring(at_index + 1)
        buf = StringBuffer.new("krbtgt/")
        buf.append(realm).append(Character.new(?@.ord)).append(realm)
        return buf.to_s
      end
      
      typesig { [String, String] }
      # Perform the Service Permission check using the specified
      # <code>target</code> and <code>action</code>
      def check_service_permission(target, action)
        sm = System.get_security_manager
        if (!(sm).nil?)
          SunNativeProvider.debug("Checking ServicePermission(" + target + ", " + action + ")")
          perm = ServicePermission.new(target, action)
          sm.check_permission(perm)
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__krb5util, :initialize
  end
  
end
