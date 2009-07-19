require "rjava"

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
module Sun::Security::Jgss::Wrapper
  module GSSCredElementImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Wrapper
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :Provider
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Jgss::Spi, :GSSCredentialSpi
    }
  end
  
  # This class is essentially a wrapper class for the gss_cred_id_t
  # structure of the native GSS library.
  # @author Valerie Peng
  # @since 1.6
  class GSSCredElement 
    include_class_members GSSCredElementImports
    include GSSCredentialSpi
    
    attr_accessor :usage
    alias_method :attr_usage, :usage
    undef_method :usage
    alias_method :attr_usage=, :usage=
    undef_method :usage=
    
    attr_accessor :p_cred
    alias_method :attr_p_cred, :p_cred
    undef_method :p_cred
    alias_method :attr_p_cred=, :p_cred=
    undef_method :p_cred=
    
    # Pointer to the gss_cred_id_t structure
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :c_stub
    alias_method :attr_c_stub, :c_stub
    undef_method :c_stub
    alias_method :attr_c_stub=, :c_stub=
    undef_method :c_stub=
    
    typesig { [] }
    # Perform the necessary ServicePermission check on this cred
    def do_service_perm_check
      if (GSSUtil.is_kerberos_mech(@c_stub.get_mech))
        if (!(System.get_security_manager).nil?)
          if (is_initiator_credential)
            tgs_name = Krb5Util.get_tgsname(@name)
            Krb5Util.check_service_permission(tgs_name, "initiate")
          end
          if (is_acceptor_credential && !(@name).equal?(GSSNameElement::DEF_ACCEPTOR))
            krb_name = @name.get_krb_name
            Krb5Util.check_service_permission(krb_name, "accept")
          end
        end
      end
    end
    
    typesig { [::Java::Long, GSSNameElement, Oid] }
    # Construct delegation cred using the actual context mech and srcName
    def initialize(p_credentials, src_name, mech)
      @usage = 0
      @p_cred = 0
      @name = nil
      @c_stub = nil
      @p_cred = p_credentials
      @c_stub = GSSLibStub.get_instance(mech)
      @usage = GSSCredential::INITIATE_ONLY
      @name = src_name
    end
    
    typesig { [GSSNameElement, ::Java::Int, ::Java::Int, GSSLibStub] }
    def initialize(name, lifetime, usage, stub)
      @usage = 0
      @p_cred = 0
      @name = nil
      @c_stub = nil
      @c_stub = stub
      @usage = usage
      if (!(name).nil?)
        # Could be GSSNameElement.DEF_ACCEPTOR
        @name = name
        do_service_perm_check
        @p_cred = @c_stub.acquire_cred(@name.attr_p_name, lifetime, usage)
      else
        @p_cred = @c_stub.acquire_cred(0, lifetime, usage)
        @name = GSSNameElement.new(@c_stub.get_cred_name(@p_cred), @c_stub)
        do_service_perm_check
      end
    end
    
    typesig { [] }
    def get_provider
      return SunNativeProvider::INSTANCE
    end
    
    typesig { [] }
    def dispose
      @name = nil
      if (!(@p_cred).equal?(0))
        @p_cred = @c_stub.release_cred(@p_cred)
      end
    end
    
    typesig { [] }
    def get_name
      return ((@name).equal?(GSSNameElement::DEF_ACCEPTOR) ? nil : @name)
    end
    
    typesig { [] }
    def get_init_lifetime
      if (is_initiator_credential)
        return @c_stub.get_cred_time(@p_cred)
      else
        return 0
      end
    end
    
    typesig { [] }
    def get_accept_lifetime
      if (is_acceptor_credential)
        return @c_stub.get_cred_time(@p_cred)
      else
        return 0
      end
    end
    
    typesig { [] }
    def is_initiator_credential
      return (!(@usage).equal?(GSSCredential::ACCEPT_ONLY))
    end
    
    typesig { [] }
    def is_acceptor_credential
      return (!(@usage).equal?(GSSCredential::INITIATE_ONLY))
    end
    
    typesig { [] }
    def get_mechanism
      return @c_stub.get_mech
    end
    
    typesig { [] }
    def to_s
      # No hex bytes available for native impl
      return "N/A"
    end
    
    typesig { [] }
    def finalize
      dispose
    end
    
    private
    alias_method :initialize__gsscred_element, :initialize
  end
  
end
