require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module ICUDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Io, :InputStream
      include_const ::Java::Net, :URL
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :MissingResourceException
    }
  end
  
  # Provides access to ICU data files as InputStreams.  Implements security checking.
  class ICUData 
    include_class_members ICUDataImports
    
    class_module.module_eval {
      typesig { [Class, String, ::Java::Boolean] }
      def get_stream(root, resource_name, required)
        i = nil
        if (!(System.get_security_manager).nil?)
          i = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members ICUData
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return root.get_resource_as_stream(resource_name)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        else
          i = root.get_resource_as_stream(resource_name)
        end
        if ((i).nil? && required)
          raise MissingResourceException.new("could not locate data", root.get_package.get_name, resource_name)
        end
        return i
      end
      
      typesig { [String] }
      # Convenience override that calls getStream(ICUData.class, resourceName, false);
      def get_stream(resource_name)
        return get_stream(ICUData, resource_name, false)
      end
      
      typesig { [String] }
      # Convenience method that calls getStream(ICUData.class, resourceName, true).
      def get_required_stream(resource_name)
        return get_stream(ICUData, resource_name, true)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__icudata, :initialize
  end
  
end
