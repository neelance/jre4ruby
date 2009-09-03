require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module ResourcesMgrImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
    }
  end
  
  class ResourcesMgr 
    include_class_members ResourcesMgrImports
    
    class_module.module_eval {
      # intended for java.security, javax.security and sun.security resources
      
      def bundle
        defined?(@@bundle) ? @@bundle : @@bundle= nil
      end
      alias_method :attr_bundle, :bundle
      
      def bundle=(value)
        @@bundle = value
      end
      alias_method :attr_bundle=, :bundle=
      
      # intended for com.sun.security resources
      
      def alt_bundle
        defined?(@@alt_bundle) ? @@alt_bundle : @@alt_bundle= nil
      end
      alias_method :attr_alt_bundle, :alt_bundle
      
      def alt_bundle=(value)
        @@alt_bundle = value
      end
      alias_method :attr_alt_bundle=, :alt_bundle=
      
      typesig { [String] }
      def get_string(s)
        if ((self.attr_bundle).nil?)
          self.attr_bundle = Java::Security::AccessController.do_privileged(# only load if/when needed
          Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members ResourcesMgr
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return (Java::Util::ResourceBundle.get_bundle("sun.security.util.Resources"))
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        return self.attr_bundle.get_string(s)
      end
      
      typesig { [String, String] }
      def get_string(s, alt_bundle_name)
        if ((self.attr_alt_bundle).nil?)
          self.attr_alt_bundle = Java::Security::AccessController.do_privileged(# only load if/when needed
          Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members ResourcesMgr
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return (Java::Util::ResourceBundle.get_bundle(alt_bundle_name))
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        return self.attr_alt_bundle.get_string(s)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__resources_mgr, :initialize
  end
  
end
