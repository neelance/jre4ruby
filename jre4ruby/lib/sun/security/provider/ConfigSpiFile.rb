require "rjava"

# 
# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ConfigSpiFileImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :URIParameter
      include_const ::Javax::Security::Auth::Login, :Configuration
      include_const ::Javax::Security::Auth::Login, :ConfigurationSpi
      include_const ::Javax::Security::Auth::Login, :AppConfigurationEntry
      include_const ::Com::Sun::Security::Auth::Login, :ConfigFile
    }
  end
  
  # 
  # This class wraps the ConfigFile subclass implementation of Configuration
  # inside a ConfigurationSpi implementation that is available from the
  # SUN provider via the Configuration.getInstance calls.
  class ConfigSpiFile < ConfigSpiFileImports.const_get :ConfigurationSpi
    include_class_members ConfigSpiFileImports
    
    attr_accessor :cf
    alias_method :attr_cf, :cf
    undef_method :cf
    alias_method :attr_cf=, :cf=
    undef_method :cf=
    
    typesig { [Configuration::Parameters] }
    def initialize(params)
      @cf = nil
      super()
      # call in a doPrivileged
      # 
      # we have already passed the Configuration.getInstance
      # security check.  also this class is not freely accessible
      # (it is in the "sun" package).
      # 
      # we can not put doPrivileged calls into
      # ConfigFile because it is a public com.sun class
      begin
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ConfigSpiFile
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            if ((params).nil?)
              self.attr_cf = ConfigFile.new
            else
              if (!(params.is_a?(URIParameter)))
                raise IllegalArgumentException.new("Unrecognized parameter: " + (params).to_s)
              end
              uri_param = params
              self.attr_cf = ConfigFile.new(uri_param.get_uri)
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue SecurityException => se
        # if ConfigFile threw a standalone SecurityException
        # (no cause), re-throw it.
        # 
        # ConfigFile chains checked IOExceptions to SecurityException.
        cause = se.get_cause
        if (!(cause).nil? && cause.is_a?(Java::Io::IOException))
          raise cause
        end
        # unrecognized cause
        raise se
      end
      # if ConfigFile throws some other RuntimeException,
      # let it percolate up naturally.
    end
    
    typesig { [String] }
    def engine_get_app_configuration_entry(name)
      return @cf.get_app_configuration_entry(name)
    end
    
    typesig { [] }
    def engine_refresh
      @cf.refresh
    end
    
    private
    alias_method :initialize__config_spi_file, :initialize
  end
  
end
