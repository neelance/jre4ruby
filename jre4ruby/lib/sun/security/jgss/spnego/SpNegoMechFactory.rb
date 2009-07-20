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
module Sun::Security::Jgss::Spnego
  module SpNegoMechFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Spnego
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss
      include ::Sun::Security::Jgss::Spi
      include_const ::Sun::Security::Jgss::Krb5, :Krb5MechFactory
      include_const ::Sun::Security::Jgss::Krb5, :Krb5InitCredential
      include_const ::Sun::Security::Jgss::Krb5, :Krb5AcceptCredential
      include_const ::Sun::Security::Jgss::Krb5, :Krb5NameElement
      include_const ::Java::Security, :Provider
      include_const ::Java::Util, :Vector
    }
  end
  
  # SpNego Mechanism plug in for JGSS
  # This is the properties object required by the JGSS framework.
  # All mechanism specific information is defined here.
  # 
  # @author Seema Malkani
  # @since 1.6
  class SpNegoMechFactory 
    include_class_members SpNegoMechFactoryImports
    include MechanismFactory
    
    class_module.module_eval {
      const_set_lazy(:PROVIDER) { Sun::Security::Jgss::SunProvider.new }
      const_attr_reader  :PROVIDER
      
      const_set_lazy(:GSS_SPNEGO_MECH_OID) { GSSUtil.create_oid("1.3.6.1.5.5.2") }
      const_attr_reader  :GSS_SPNEGO_MECH_OID
      
      
      def name_types
        defined?(@@name_types) ? @@name_types : @@name_types= Array.typed(Oid).new([GSSName::NT_USER_NAME, GSSName::NT_HOSTBASED_SERVICE, GSSName::NT_EXPORT_NAME])
      end
      alias_method :attr_name_types, :name_types
      
      def name_types=(value)
        @@name_types = value
      end
      alias_method :attr_name_types=, :name_types=
    }
    
    # Use an instance of a GSSManager whose provider list
    # does not include native provider
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    attr_accessor :available_mechs
    alias_method :attr_available_mechs, :available_mechs
    undef_method :available_mechs
    alias_method :attr_available_mechs=, :available_mechs=
    undef_method :available_mechs=
    
    class_module.module_eval {
      typesig { [GSSNameSpi, ::Java::Boolean] }
      def get_cred_from_subject(name, initiate)
        creds = GSSUtil.search_subject(name, GSS_SPNEGO_MECH_OID, initiate, SpNegoCredElement.class)
        result = (((creds).nil? || creds.is_empty) ? nil : creds.first_element)
        # Force permission check before returning the cred to caller
        if (!(result).nil?)
          cred = result.get_internal_cred
          if (GSSUtil.is_kerberos_mech(cred.get_mechanism))
            if (initiate)
              krb_cred = cred
              Krb5MechFactory.check_init_cred_permission(krb_cred.get_name)
            else
              krb_cred = cred
              Krb5MechFactory.check_accept_cred_permission(krb_cred.get_name, name)
            end
          end
        end
        return result
      end
    }
    
    typesig { [::Java::Int] }
    def initialize(caller)
      @manager = nil
      @available_mechs = nil
      @manager = GSSManagerImpl.new(caller, false)
      mechs = @manager.get_mechs
      @available_mechs = Array.typed(Oid).new(mechs.attr_length - 1) { nil }
      i = 0
      j = 0
      while i < mechs.attr_length
        # Skip SpNego mechanism
        if (!(mechs[i] == GSS_SPNEGO_MECH_OID))
          @available_mechs[((j += 1) - 1)] = mechs[i]
        end
        i += 1
      end
    end
    
    typesig { [String, Oid] }
    def get_name_element(name_str, name_type)
      # get NameElement for the default Mechanism
      return @manager.get_name_element(name_str, name_type, nil)
    end
    
    typesig { [Array.typed(::Java::Byte), Oid] }
    def get_name_element(name, name_type)
      # get NameElement for the default Mechanism
      return @manager.get_name_element(name, name_type, nil)
    end
    
    typesig { [GSSNameSpi, ::Java::Int, ::Java::Int, ::Java::Int] }
    def get_credential_element(name, init_lifetime, accept_lifetime, usage)
      cred_element = get_cred_from_subject(name, (!(usage).equal?(GSSCredential::ACCEPT_ONLY)))
      if ((cred_element).nil?)
        # get CredElement for the default Mechanism
        cred_element = SpNegoCredElement.new(@manager.get_credential_element(name, init_lifetime, accept_lifetime, nil, usage))
      end
      return cred_element
    end
    
    typesig { [GSSNameSpi, GSSCredentialSpi, ::Java::Int] }
    def get_mechanism_context(peer, my_initiator_cred, lifetime)
      # get SpNego mechanism context
      if ((my_initiator_cred).nil?)
        my_initiator_cred = get_cred_from_subject(nil, true)
      else
        if (!(my_initiator_cred.is_a?(SpNegoCredElement)))
          # convert to SpNegoCredElement
          cred = SpNegoCredElement.new(my_initiator_cred)
          return SpNegoContext.new(self, peer, cred, lifetime)
        end
      end
      return SpNegoContext.new(self, peer, my_initiator_cred, lifetime)
    end
    
    typesig { [GSSCredentialSpi] }
    def get_mechanism_context(my_acceptor_cred)
      # get SpNego mechanism context
      if ((my_acceptor_cred).nil?)
        my_acceptor_cred = get_cred_from_subject(nil, false)
      else
        if (!(my_acceptor_cred.is_a?(SpNegoCredElement)))
          # convert to SpNegoCredElement
          cred = SpNegoCredElement.new(my_acceptor_cred)
          return SpNegoContext.new(self, cred)
        end
      end
      return SpNegoContext.new(self, my_acceptor_cred)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def get_mechanism_context(exported_context)
      # get SpNego mechanism context
      return SpNegoContext.new(self, exported_context)
    end
    
    typesig { [] }
    def get_mechanism_oid
      return GSS_SPNEGO_MECH_OID
    end
    
    typesig { [] }
    def get_provider
      return PROVIDER
    end
    
    typesig { [] }
    def get_name_types
      # nameTypes is cloned in GSSManager.getNamesForMech
      return self.attr_name_types
    end
    
    private
    alias_method :initialize__sp_nego_mech_factory, :initialize
  end
  
end
