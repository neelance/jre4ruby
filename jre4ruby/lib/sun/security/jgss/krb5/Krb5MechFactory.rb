require "rjava"

# 
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
module Sun::Security::Jgss::Krb5
  module Krb5MechFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Sun::Security::Jgss, :GSSUtil
      include ::Sun::Security::Jgss::Spi
      include_const ::Javax::Security::Auth::Kerberos, :ServicePermission
      include_const ::Java::Security, :Provider
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Vector
    }
  end
  
  # 
  # Krb5 Mechanism plug in for JGSS
  # This is the properties object required by the JGSS framework.
  # All mechanism specific information is defined here.
  # 
  # @author Mayank Upadhyay
  class Krb5MechFactory 
    include_class_members Krb5MechFactoryImports
    include MechanismFactory
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Krb5Util::DEBUG }
      const_attr_reader  :DEBUG
      
      const_set_lazy(:PROVIDER) { Sun::Security::Jgss::SunProvider.new }
      const_attr_reader  :PROVIDER
      
      const_set_lazy(:GSS_KRB5_MECH_OID) { create_oid("1.2.840.113554.1.2.2") }
      const_attr_reader  :GSS_KRB5_MECH_OID
      
      const_set_lazy(:NT_GSS_KRB5_PRINCIPAL) { create_oid("1.2.840.113554.1.2.2.1") }
      const_attr_reader  :NT_GSS_KRB5_PRINCIPAL
      
      
      def name_types
        defined?(@@name_types) ? @@name_types : @@name_types= Array.typed(Oid).new([GSSName::NT_USER_NAME, GSSName::NT_HOSTBASED_SERVICE, GSSName::NT_EXPORT_NAME, NT_GSS_KRB5_PRINCIPAL])
      end
      alias_method :attr_name_types, :name_types
      
      def name_types=(value)
        @@name_types = value
      end
      alias_method :attr_name_types=, :name_types=
    }
    
    attr_accessor :caller
    alias_method :attr_caller, :caller
    undef_method :caller
    alias_method :attr_caller=, :caller=
    undef_method :caller=
    
    class_module.module_eval {
      typesig { [GSSNameSpi, ::Java::Boolean] }
      def get_cred_from_subject(name, initiate)
        creds = GSSUtil.search_subject(name, GSS_KRB5_MECH_OID, initiate, (initiate ? Krb5InitCredential.class : Krb5AcceptCredential.class))
        result = (((creds).nil? || creds.is_empty) ? nil : creds.first_element)
        # Force permission check before returning the cred to caller
        if (!(result).nil?)
          if (initiate)
            check_init_cred_permission(result.get_name)
          else
            check_accept_cred_permission(result.get_name, name)
          end
        end
        return result
      end
    }
    
    typesig { [::Java::Int] }
    def initialize(caller)
      @caller = 0
      @caller = caller
    end
    
    typesig { [String, Oid] }
    def get_name_element(name_str, name_type)
      return Krb5NameElement.get_instance(name_str, name_type)
    end
    
    typesig { [Array.typed(::Java::Byte), Oid] }
    def get_name_element(name, name_type)
      # At this point, even an exported name is stripped down to safe
      # bytes only
      # XXX Use encoding here
      return Krb5NameElement.get_instance(String.new(name), name_type)
    end
    
    typesig { [GSSNameSpi, ::Java::Int, ::Java::Int, ::Java::Int] }
    def get_credential_element(name, init_lifetime, accept_lifetime, usage)
      if (!(name).nil? && !(name.is_a?(Krb5NameElement)))
        name = Krb5NameElement.get_instance(name.to_s, name.get_string_name_type)
      end
      cred_element = get_cred_from_subject(name, (!(usage).equal?(GSSCredential::ACCEPT_ONLY)))
      if ((cred_element).nil?)
        if ((usage).equal?(GSSCredential::INITIATE_ONLY) || (usage).equal?(GSSCredential::INITIATE_AND_ACCEPT))
          cred_element = Krb5InitCredential.get_instance(@caller, name, init_lifetime)
          check_init_cred_permission(cred_element.get_name)
        else
          if ((usage).equal?(GSSCredential::ACCEPT_ONLY))
            cred_element = Krb5AcceptCredential.get_instance(@caller, name)
            check_accept_cred_permission(cred_element.get_name, name)
          else
            raise GSSException.new(GSSException::FAILURE, -1, "Unknown usage mode requested")
          end
        end
      end
      return cred_element
    end
    
    class_module.module_eval {
      typesig { [Krb5NameElement] }
      def check_init_cred_permission(name)
        sm = System.get_security_manager
        if (!(sm).nil?)
          realm = (name.get_krb5principal_name).get_realm_as_string
          tgs_principal = String.new("krbtgt/" + realm + (Character.new(?@.ord)).to_s + realm)
          perm = ServicePermission.new(tgs_principal, "initiate")
          begin
            sm.check_permission(perm)
          rescue SecurityException => e
            if (DEBUG)
              System.out.println("Permission to initiate" + "kerberos init credential" + (e.get_message).to_s)
            end
            raise e
          end
        end
      end
      
      typesig { [Krb5NameElement, GSSNameSpi] }
      def check_accept_cred_permission(name, original_name)
        sm = System.get_security_manager
        if (!(sm).nil?)
          perm = ServicePermission.new(name.get_krb5principal_name.get_name, "accept")
          begin
            sm.check_permission(perm)
          rescue SecurityException => e
            if ((original_name).nil?)
              # Don't disclose the name of the principal
              e = SecurityException.new("No permission to acquire " + "Kerberos accept credential")
              # Don't call e.initCause() with caught exception
            end
            raise e
          end
        end
      end
    }
    
    typesig { [GSSNameSpi, GSSCredentialSpi, ::Java::Int] }
    def get_mechanism_context(peer, my_initiator_cred, lifetime)
      if (!(peer).nil? && !(peer.is_a?(Krb5NameElement)))
        peer = Krb5NameElement.get_instance(peer.to_s, peer.get_string_name_type)
      end
      # XXX Convert myInitiatorCred to Krb5CredElement
      if ((my_initiator_cred).nil?)
        my_initiator_cred = get_credential_element(nil, lifetime, 0, GSSCredential::INITIATE_ONLY)
      end
      return Krb5Context.new(@caller, peer, my_initiator_cred, lifetime)
    end
    
    typesig { [GSSCredentialSpi] }
    def get_mechanism_context(my_acceptor_cred)
      # XXX Convert myAcceptorCred to Krb5CredElement
      if ((my_acceptor_cred).nil?)
        my_acceptor_cred = get_credential_element(nil, 0, GSSCredential::INDEFINITE_LIFETIME, GSSCredential::ACCEPT_ONLY)
      end
      return Krb5Context.new(@caller, my_acceptor_cred)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def get_mechanism_context(exported_context)
      return Krb5Context.new(@caller, exported_context)
    end
    
    typesig { [] }
    def get_mechanism_oid
      return GSS_KRB5_MECH_OID
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
    
    class_module.module_eval {
      typesig { [String] }
      def create_oid(oid_str)
        ret_val = nil
        begin
          ret_val = Oid.new(oid_str)
        rescue GSSException => e
          # Should not happen!
        end
        return ret_val
      end
    }
    
    private
    alias_method :initialize__krb5mech_factory, :initialize
  end
  
end
