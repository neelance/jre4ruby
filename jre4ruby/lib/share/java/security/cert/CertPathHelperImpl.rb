require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Cert
  module CertPathHelperImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include ::Java::Util
      include_const ::Sun::Security::Provider::Certpath, :CertPathHelper
      include_const ::Sun::Security::X509, :GeneralNameInterface
    }
  end
  
  # Helper class that allows the Sun CertPath provider to access
  # implementation dependent APIs in CertPath framework.
  # 
  # @author Andreas Sterbenz
  class CertPathHelperImpl < CertPathHelperImplImports.const_get :CertPathHelper
    include_class_members CertPathHelperImplImports
    
    typesig { [] }
    def initialize
      super()
      # empty
    end
    
    class_module.module_eval {
      typesig { [] }
      # Initialize the helper framework. This method must be called from
      # the static initializer of each class that is the target of one of
      # the methods in this class. This ensures that the helper if initialized
      # prior to a tunneled call from the Sun provider.
      def initialize_
        synchronized(self) do
          if ((CertPathHelper.attr_instance).nil?)
            CertPathHelper.attr_instance = CertPathHelperImpl.new
          end
        end
      end
    }
    
    typesig { [X509CertSelector, JavaSet] }
    def impl_set_path_to_names(sel, names)
      sel.set_path_to_names_internal(names)
    end
    
    private
    alias_method :initialize__cert_path_helper_impl, :initialize
  end
  
end
