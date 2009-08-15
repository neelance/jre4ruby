require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module DefaultSelectorProviderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Nio::Channels::Spi, :SelectorProvider
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # Creates this platform's default SelectorProvider
  class DefaultSelectorProvider 
    include_class_members DefaultSelectorProviderImports
    
    typesig { [] }
    # Prevent instantiation.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the default SelectorProvider.
      def create
        osname = AccessController.do_privileged(GetPropertyAction.new("os.name"))
        if (("SunOS" == osname))
          return Sun::Nio::Ch::DevPollSelectorProvider.new
        end
        # use EPollSelectorProvider for Linux kernels >= 2.6
        if (("Linux" == osname))
          osversion = AccessController.do_privileged(GetPropertyAction.new("os.version"))
          vers = osversion.split(Regexp.new("\\."))
          if (vers.attr_length >= 2)
            begin
              major = JavaInteger.parse_int(vers[0])
              minor = JavaInteger.parse_int(vers[1])
              if (major > 2 || ((major).equal?(2) && minor >= 6))
                return Sun::Nio::Ch::EPollSelectorProvider.new
              end
            rescue NumberFormatException => x
              # format not recognized
            end
          end
        end
        return Sun::Nio::Ch::PollSelectorProvider.new
      end
    }
    
    private
    alias_method :initialize__default_selector_provider, :initialize
  end
  
end
