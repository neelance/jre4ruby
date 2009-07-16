require "rjava"

# 
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
module Sun::Security::Provider::Certpath
  module CertPathHelperImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Security::Cert, :X509CertSelector
      include_const ::Sun::Security::X509, :GeneralNameInterface
    }
  end
  
  # 
  # Helper class that allows access to Sun specific known-public methods in the
  # java.security.cert package. It relies on a subclass in the
  # java.security.cert packages that is initialized before any of these methods
  # are called (achieved via static initializers).
  # 
  # The methods are made available in this fashion for performance reasons.
  # 
  # @author Andreas Sterbenz
  class CertPathHelper 
    include_class_members CertPathHelperImports
    
    class_module.module_eval {
      # 
      # Object used to tunnel the calls. Initialized by CertPathHelperImpl.
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
    }
    
    typesig { [] }
    def initialize
      # empty
    end
    
    typesig { [X509CertSelector, JavaSet] }
    def impl_set_path_to_names(sel, names)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [X509CertSelector, JavaSet] }
      def set_path_to_names(sel, names)
        self.attr_instance.impl_set_path_to_names(sel, names)
      end
    }
    
    private
    alias_method :initialize__cert_path_helper, :initialize
  end
  
end
