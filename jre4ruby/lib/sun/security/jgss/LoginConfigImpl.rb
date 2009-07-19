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
module Sun::Security::Jgss
  module LoginConfigImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include_const ::Java::Util, :HashMap
      include_const ::Javax::Security::Auth::Login, :AppConfigurationEntry
      include_const ::Javax::Security::Auth::Login, :Configuration
      include_const ::Org::Ietf::Jgss, :Oid
    }
  end
  
  # A Configuration implementation especially designed for JGSS.
  # 
  # @author weijun.wang
  # @since 1.6
  class LoginConfigImpl < LoginConfigImplImports.const_get :Configuration
    include_class_members LoginConfigImplImports
    
    attr_accessor :config
    alias_method :attr_config, :config
    undef_method :config
    alias_method :attr_config=, :config=
    undef_method :config=
    
    attr_accessor :caller
    alias_method :attr_caller, :caller
    undef_method :caller
    alias_method :attr_caller=, :caller=
    undef_method :caller=
    
    attr_accessor :mech_name
    alias_method :attr_mech_name, :mech_name
    undef_method :mech_name
    alias_method :attr_mech_name=, :mech_name=
    undef_method :mech_name=
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Sun::Security::Util::Debug.get_instance("gssloginconfig", "\t[GSS LoginConfigImpl]") }
      const_attr_reader  :Debug
    }
    
    typesig { [::Java::Int, Oid] }
    # A new instance of LoginConfigImpl must be created for each login request
    # since it's only used by a single (caller, mech) pair
    # @param caller defined in GSSUtil as CALLER_XXX final fields
    # @param oid defined in GSSUtil as XXX_MECH_OID final fields
    def initialize(caller, mech)
      @config = nil
      @caller = 0
      @mech_name = nil
      super()
      @caller = caller
      if ((mech == GSSUtil::GSS_KRB5_MECH_OID))
        @mech_name = "krb5"
      else
        raise IllegalArgumentException.new((mech.to_s).to_s + " not supported")
      end
      @config = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members LoginConfigImpl
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return Configuration.get_configuration
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [String] }
    # @param name Almost useless, since the (caller, mech) is already passed
    # into constructor. The only use will be detecting OTHER which
    # is called in LoginContext
    def get_app_configuration_entry(name)
      entries = nil
      # This is the second call from LoginContext, which we will just ignore
      if ("OTHER".equals_ignore_case(name))
        return nil
      end
      alts = nil
      # Compatibility:
      # For the 4 old callers, old entry names will be used if the new
      # entry name is not provided.
      if (("krb5" == @mech_name))
        case (@caller)
        when GSSUtil::CALLER_INITIATE
          alts = Array.typed(String).new(["com.sun.security.jgss.krb5.initiate", "com.sun.security.jgss.initiate", ])
        when GSSUtil::CALLER_ACCEPT
          alts = Array.typed(String).new(["com.sun.security.jgss.krb5.accept", "com.sun.security.jgss.accept", ])
        when GSSUtil::CALLER_SSL_CLIENT
          alts = Array.typed(String).new(["com.sun.security.jgss.krb5.initiate", "com.sun.net.ssl.client", ])
        when GSSUtil::CALLER_SSL_SERVER
          alts = Array.typed(String).new(["com.sun.security.jgss.krb5.accept", "com.sun.net.ssl.server", ])
        when GSSUtil::CALLER_HTTP_NEGOTIATE
          alts = Array.typed(String).new(["com.sun.security.jgss.krb5.initiate", ])
        when GSSUtil::CALLER_UNKNOWN
          # should never use
          raise AssertionError.new("caller cannot be unknown")
        else
          raise AssertionError.new("caller not defined")
        end
      else
        raise IllegalArgumentException.new(@mech_name + " not supported")
        # No other mech at the moment, maybe --
        # 
        # switch (caller) {
        # case GSSUtil.CALLER_INITIATE:
        # case GSSUtil.CALLER_SSL_CLIENT:
        # case GSSUtil.CALLER_HTTP_NEGOTIATE:
        # alts = new String[] {
        # "com.sun.security.jgss." + mechName + ".initiate",
        # };
        # break;
        # case GSSUtil.CALLER_ACCEPT:
        # case GSSUtil.CALLER_SSL_SERVER:
        # alts = new String[] {
        # "com.sun.security.jgss." + mechName + ".accept",
        # };
        # break;
        # case GSSUtil.CALLER_UNKNOWN:
        # // should never use
        # throw new AssertionError("caller cannot be unknown");
        # default:
        # throw new AssertionError("caller not defined");
        # }
      end
      alts.each do |alt|
        entries = @config.get_app_configuration_entry(alt)
        if (!(Debug).nil?)
          Debug.println("Trying " + alt + ((((entries).nil?) ? ": does not exist." : ": Found!")).to_s)
        end
        if (!(entries).nil?)
          break
        end
      end
      if ((entries).nil?)
        if (!(Debug).nil?)
          Debug.println("Cannot read JGSS entry, use default values instead.")
        end
        entries = get_default_configuration_entry
      end
      return entries
    end
    
    typesig { [] }
    # Default value for a caller-mech pair when no entry is defined in
    # the system-wide Configuration object.
    def get_default_configuration_entry
      options = HashMap.new(2)
      if ((@mech_name).nil? || (@mech_name == "krb5"))
        if (is_server_side(@caller))
          # Assuming the keytab file can be found through
          # krb5 config file or under user home directory
          options.put("useKeyTab", "true")
          options.put("storeKey", "true")
          options.put("doNotPrompt", "true")
          options.put("isInitiator", "false")
        else
          options.put("useTicketCache", "true")
          options.put("doNotPrompt", "false")
        end
        return Array.typed(AppConfigurationEntry).new([AppConfigurationEntry.new("com.sun.security.auth.module.Krb5LoginModule", AppConfigurationEntry::LoginModuleControlFlag::REQUIRED, options)])
      end
      return nil
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def is_server_side(caller)
        return (GSSUtil::CALLER_ACCEPT).equal?(caller) || (GSSUtil::CALLER_SSL_SERVER).equal?(caller)
      end
    }
    
    private
    alias_method :initialize__login_config_impl, :initialize
  end
  
end
