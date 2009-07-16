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
module Sun::Security::Jgss::Spnego
  module SpNegoCredElementImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Spnego
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :Provider
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Jgss, :ProviderList
      include_const ::Sun::Security::Jgss, :GSSCredentialImpl
      include_const ::Sun::Security::Jgss::Spi, :GSSNameSpi
      include_const ::Sun::Security::Jgss::Spi, :GSSCredentialSpi
    }
  end
  
  # 
  # This class is the cred element implementation for SPNEGO mech.
  # NOTE: The current implementation can only support one mechanism.
  # This should be changed once multi-mechanism support is needed.
  # 
  # @author Valerie Peng
  # @since 1.6
  class SpNegoCredElement 
    include_class_members SpNegoCredElementImports
    include GSSCredentialSpi
    
    attr_accessor :cred
    alias_method :attr_cred, :cred
    undef_method :cred
    alias_method :attr_cred=, :cred=
    undef_method :cred=
    
    typesig { [GSSCredentialSpi] }
    def initialize(cred)
      @cred = nil
      @cred = cred
    end
    
    typesig { [] }
    def get_internal_mech
      return @cred.get_mechanism
    end
    
    typesig { [] }
    # Used by GSSUtil.populateCredentials()
    def get_internal_cred
      return @cred
    end
    
    typesig { [] }
    def get_provider
      return SpNegoMechFactory::PROVIDER
    end
    
    typesig { [] }
    def dispose
      @cred.dispose
    end
    
    typesig { [] }
    def get_name
      return @cred.get_name
    end
    
    typesig { [] }
    def get_init_lifetime
      return @cred.get_init_lifetime
    end
    
    typesig { [] }
    def get_accept_lifetime
      return @cred.get_accept_lifetime
    end
    
    typesig { [] }
    def is_initiator_credential
      return @cred.is_initiator_credential
    end
    
    typesig { [] }
    def is_acceptor_credential
      return @cred.is_acceptor_credential
    end
    
    typesig { [] }
    def get_mechanism
      return GSSUtil::GSS_SPNEGO_MECH_OID
    end
    
    private
    alias_method :initialize__sp_nego_cred_element, :initialize
  end
  
end
