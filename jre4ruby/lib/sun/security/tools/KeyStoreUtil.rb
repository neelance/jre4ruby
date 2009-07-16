require "rjava"

# 
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
module Sun::Security::Tools
  module KeyStoreUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Tools
    }
  end
  
  # 
  # <p> This class provides several utilities to <code>KeyStore</code>.
  # 
  # @since 1.6.0
  class KeyStoreUtil 
    include_class_members KeyStoreUtilImports
    
    typesig { [] }
    # Class and methods marked as public so that they can be
    # accessed by JarSigner, which although lies in a package
    # with the same name, but bundled in tools.jar and loaded
    # by another class loader, hence in a different *runtime*
    # package.
    # 
    # See JVM Spec, 5.3 and 5.4.4
    def initialize
      # this class is not meant to be instantiated
    end
    
    class_module.module_eval {
      typesig { [String] }
      # 
      # Returns true if KeyStore has a password. This is true except for
      # MSCAPI KeyStores
      def is_windows_key_store(storetype)
        return storetype.equals_ignore_case("Windows-MY") || storetype.equals_ignore_case("Windows-ROOT")
      end
      
      typesig { [String] }
      # 
      # Returns standard-looking names for storetype
      def nice_store_type_name(storetype)
        if (storetype.equals_ignore_case("Windows-MY"))
          return "Windows-MY"
        else
          if (storetype.equals_ignore_case("Windows-ROOT"))
            return "Windows-ROOT"
          else
            return storetype.to_upper_case
          end
        end
      end
    }
    
    private
    alias_method :initialize__key_store_util, :initialize
  end
  
end
