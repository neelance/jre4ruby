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
module Sun::Security::Jgss
  module GSSManagerImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss::Spi
      include ::Java::Io
      include_const ::Java::Security, :NoSuchProviderException
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This class provides the default implementation of the GSSManager
  # interface.
  class GSSManagerImpl < GSSManagerImplImports.const_get :GSSManager
    include_class_members GSSManagerImplImports
    
    class_module.module_eval {
      # Undocumented property
      const_set_lazy(:USE_NATIVE_PROP) { "sun.security.jgss.native" }
      const_attr_reader  :USE_NATIVE_PROP
      
      when_class_loaded do
        const_set :USE_NATIVE, AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members GSSManagerImpl
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            osname = System.get_property("os.name")
            if (osname.starts_with("SunOS") || osname.starts_with("Linux"))
              return Boolean.new(System.get_property(USE_NATIVE_PROP))
            end
            return Boolean::FALSE
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    }
    
    attr_accessor :list
    alias_method :attr_list, :list
    undef_method :list
    alias_method :attr_list=, :list=
    undef_method :list=
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Used by java SPNEGO impl to make sure native is disabled
    def initialize(caller, use_native)
      @list = nil
      super()
      @list = ProviderList.new(caller, use_native)
    end
    
    typesig { [::Java::Int] }
    # Used by HTTP/SPNEGO NegotiatorImpl
    def initialize(caller)
      @list = nil
      super()
      @list = ProviderList.new(caller, USE_NATIVE)
    end
    
    typesig { [] }
    def initialize
      @list = nil
      super()
      @list = ProviderList.new(GSSUtil::CALLER_UNKNOWN, USE_NATIVE)
    end
    
    typesig { [] }
    def get_mechs
      return @list.get_mechs
    end
    
    typesig { [Oid] }
    def get_names_for_mech(mech)
      factory = @list.get_mech_factory(mech)
      return factory.get_name_types.clone
    end
    
    typesig { [Oid] }
    def get_mechs_for_name(name_type)
      mechs = @list.get_mechs
      ret_val = Array.typed(Oid).new(mechs.attr_length) { nil }
      pos = 0
      # Iterate thru all mechs in GSS
      i = 0
      while i < mechs.attr_length
        # what nametypes does this mech support?
        mech = mechs[i]
        begin
          names_for_mech = get_names_for_mech(mech)
          # Is the desired Oid present in that list?
          if (name_type.contained_in(names_for_mech))
            ret_val[((pos += 1) - 1)] = mech
          end
        rescue GSSException => e
          # Squelch it and just skip over this mechanism
          GSSUtil.debug("Skip " + RJava.cast_to_string(mech) + ": error retrieving supported name types")
        end
        i += 1
      end
      # Trim the list if needed
      if (pos < ret_val.attr_length)
        temp = Array.typed(Oid).new(pos) { nil }
        i_ = 0
        while i_ < pos
          temp[i_] = ret_val[i_]
          i_ += 1
        end
        ret_val = temp
      end
      return ret_val
    end
    
    typesig { [String, Oid] }
    def create_name(name_str, name_type)
      return GSSNameImpl.new(self, name_str, name_type)
    end
    
    typesig { [Array.typed(::Java::Byte), Oid] }
    def create_name(name, name_type)
      return GSSNameImpl.new(self, name, name_type)
    end
    
    typesig { [String, Oid, Oid] }
    def create_name(name_str, name_type, mech)
      return GSSNameImpl.new(self, name_str, name_type, mech)
    end
    
    typesig { [Array.typed(::Java::Byte), Oid, Oid] }
    def create_name(name, name_type, mech)
      return GSSNameImpl.new(self, name, name_type, mech)
    end
    
    typesig { [::Java::Int] }
    def create_credential(usage)
      return GSSCredentialImpl.new(self, usage)
    end
    
    typesig { [GSSName, ::Java::Int, Oid, ::Java::Int] }
    def create_credential(a_name, lifetime, mech, usage)
      return GSSCredentialImpl.new(self, a_name, lifetime, mech, usage)
    end
    
    typesig { [GSSName, ::Java::Int, Array.typed(Oid), ::Java::Int] }
    def create_credential(a_name, lifetime, mechs, usage)
      return GSSCredentialImpl.new(self, a_name, lifetime, mechs, usage)
    end
    
    typesig { [GSSName, Oid, GSSCredential, ::Java::Int] }
    def create_context(peer, mech, my_cred, lifetime)
      return GSSContextImpl.new(self, peer, mech, my_cred, lifetime)
    end
    
    typesig { [GSSCredential] }
    def create_context(my_cred)
      return GSSContextImpl.new(self, my_cred)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def create_context(inter_process_token)
      return GSSContextImpl.new(self, inter_process_token)
    end
    
    typesig { [Provider, Oid] }
    def add_provider_at_front(p, mech)
      @list.add_provider_at_front(p, mech)
    end
    
    typesig { [Provider, Oid] }
    def add_provider_at_end(p, mech)
      @list.add_provider_at_end(p, mech)
    end
    
    typesig { [GSSNameSpi, ::Java::Int, ::Java::Int, Oid, ::Java::Int] }
    def get_credential_element(name, init_lifetime, accept_lifetime, mech, usage)
      factory = @list.get_mech_factory(mech)
      return factory.get_credential_element(name, init_lifetime, accept_lifetime, usage)
    end
    
    typesig { [String, Oid, Oid] }
    # Used by java SPNEGO impl
    def get_name_element(name, name_type, mech)
      # Just use the most preferred MF impl assuming GSSNameSpi
      # objects are interoperable among providers
      factory = @list.get_mech_factory(mech)
      return factory.get_name_element(name, name_type)
    end
    
    typesig { [Array.typed(::Java::Byte), Oid, Oid] }
    # Used by java SPNEGO impl
    def get_name_element(name, name_type, mech)
      # Just use the most preferred MF impl assuming GSSNameSpi
      # objects are interoperable among providers
      factory = @list.get_mech_factory(mech)
      return factory.get_name_element(name, name_type)
    end
    
    typesig { [GSSNameSpi, GSSCredentialSpi, ::Java::Int, Oid] }
    def get_mechanism_context(peer, my_initiator_cred, lifetime, mech)
      p = nil
      if (!(my_initiator_cred).nil?)
        p = my_initiator_cred.get_provider
      end
      factory = @list.get_mech_factory(mech, p)
      return factory.get_mechanism_context(peer, my_initiator_cred, lifetime)
    end
    
    typesig { [GSSCredentialSpi, Oid] }
    def get_mechanism_context(my_acceptor_cred, mech)
      p = nil
      if (!(my_acceptor_cred).nil?)
        p = my_acceptor_cred.get_provider
      end
      factory = @list.get_mech_factory(mech, p)
      return factory.get_mechanism_context(my_acceptor_cred)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def get_mechanism_context(exported_context)
      if (((exported_context).nil?) || ((exported_context.attr_length).equal?(0)))
        raise GSSException.new(GSSException::NO_CONTEXT)
      end
      result = nil
      # Only allow context import with native provider since JGSS
      # still has not defined its own interprocess token format
      mechs = @list.get_mechs
      i = 0
      while i < mechs.attr_length
        factory = @list.get_mech_factory(mechs[i])
        if ((factory.get_provider.get_name == "SunNativeGSS"))
          result = factory.get_mechanism_context(exported_context)
          if (!(result).nil?)
            break
          end
        end
        i += 1
      end
      if ((result).nil?)
        raise GSSException.new(GSSException::UNAVAILABLE)
      end
      return result
    end
    
    private
    alias_method :initialize__gssmanager_impl, :initialize
  end
  
end
