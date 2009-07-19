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
module Sun::Security::Provider
  module PolicySpiFileImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Security, :CodeSource
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :PermissionCollection
      include_const ::Java::Security, :Policy
      include_const ::Java::Security, :PolicySpi
      include_const ::Java::Security, :ProtectionDomain
      include_const ::Java::Security, :URIParameter
      include_const ::Java::Net, :MalformedURLException
    }
  end
  
  # This class wraps the PolicyFile subclass implementation of Policy
  # inside a PolicySpi implementation that is available from the SUN provider
  # via the Policy.getInstance calls.
  class PolicySpiFile < PolicySpiFileImports.const_get :PolicySpi
    include_class_members PolicySpiFileImports
    
    attr_accessor :pf
    alias_method :attr_pf, :pf
    undef_method :pf
    alias_method :attr_pf=, :pf=
    undef_method :pf=
    
    typesig { [Policy::Parameters] }
    def initialize(params)
      @pf = nil
      super()
      if ((params).nil?)
        @pf = PolicyFile.new
      else
        if (!(params.is_a?(URIParameter)))
          raise IllegalArgumentException.new("Unrecognized policy parameter: " + (params).to_s)
        end
        uri_param = params
        begin
          @pf = PolicyFile.new(uri_param.get_uri.to_url)
        rescue MalformedURLException => mue
          raise IllegalArgumentException.new("Invalid URIParameter", mue)
        end
      end
    end
    
    typesig { [CodeSource] }
    def engine_get_permissions(codesource)
      return @pf.get_permissions(codesource)
    end
    
    typesig { [ProtectionDomain] }
    def engine_get_permissions(d)
      return @pf.get_permissions(d)
    end
    
    typesig { [ProtectionDomain, Permission] }
    def engine_implies(d, p)
      return @pf.implies(d, p)
    end
    
    typesig { [] }
    def engine_refresh
      @pf.refresh
    end
    
    private
    alias_method :initialize__policy_spi_file, :initialize
  end
  
end
