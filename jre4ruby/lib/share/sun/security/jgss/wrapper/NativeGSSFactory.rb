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
  module NativeGSSFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Wrapper
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :Provider
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Iterator
      include_const ::Javax::Security::Auth, :Subject
      include ::Javax::Security::Auth::Kerberos
      include ::Org::Ietf::Jgss
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Jgss, :GSSExceptionImpl
      include ::Sun::Security::Jgss::Spi
    }
  end
  
  # JGSS plugin for generic mechanisms provided through native GSS framework.
  # 
  # @author Valerie Peng
  class NativeGSSFactory 
    include_class_members NativeGSSFactoryImports
    include MechanismFactory
    
    attr_accessor :c_stub
    alias_method :attr_c_stub, :c_stub
    undef_method :c_stub
    alias_method :attr_c_stub=, :c_stub=
    undef_method :c_stub=
    
    attr_accessor :caller
    alias_method :attr_caller, :caller
    undef_method :caller
    alias_method :attr_caller=, :caller=
    undef_method :caller=
    
    typesig { [GSSNameElement, ::Java::Boolean] }
    def get_cred_from_subject(name, initiate)
      mech = @c_stub.get_mech
      creds = GSSUtil.search_subject(name, mech, initiate, GSSCredElement)
      # If Subject is present but no native creds available
      if (!(creds).nil? && creds.is_empty)
        if (GSSUtil.use_subject_creds_only(@caller))
          raise GSSException.new(GSSException::NO_CRED)
        end
      end
      result = (((creds).nil? || creds.is_empty) ? nil : creds.first_element)
      # Force permission check before returning the cred to caller
      if (!(result).nil?)
        result.do_service_perm_check
      end
      return result
    end
    
    typesig { [::Java::Int] }
    def initialize(caller)
      @c_stub = nil
      @caller = 0
      @caller = caller
      # Have to call setMech(Oid) explicitly before calling other
      # methods. Otherwise, NPE may be thrown unexpectantly
    end
    
    typesig { [Oid] }
    def set_mech(mech)
      @c_stub = GSSLibStub.get_instance(mech)
    end
    
    typesig { [String, Oid] }
    def get_name_element(name_str, name_type)
      begin
        name_bytes = ((name_str).nil? ? nil : name_str.get_bytes("UTF-8"))
        return GSSNameElement.new(name_bytes, name_type, @c_stub)
      rescue UnsupportedEncodingException => uee
        # Shouldn't happen
        raise GSSExceptionImpl.new(GSSException::FAILURE, uee)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), Oid] }
    def get_name_element(name, name_type)
      return GSSNameElement.new(name, name_type, @c_stub)
    end
    
    typesig { [GSSNameSpi, ::Java::Int, ::Java::Int, ::Java::Int] }
    def get_credential_element(name, init_lifetime, accept_lifetime, usage)
      nname = nil
      if (!(name).nil? && !(name.is_a?(GSSNameElement)))
        nname = get_name_element(name.to_s, name.get_string_name_type)
      else
        nname = name
      end
      if ((usage).equal?(GSSCredential::INITIATE_AND_ACCEPT))
        # Force separate acqusition of cred element since
        # MIT's impl does not correctly report NO_CRED error.
        usage = GSSCredential::INITIATE_ONLY
      end
      cred_element = get_cred_from_subject(nname, ((usage).equal?(GSSCredential::INITIATE_ONLY)))
      if ((cred_element).nil?)
        # No cred in the Subject
        if ((usage).equal?(GSSCredential::INITIATE_ONLY))
          cred_element = GSSCredElement.new(nname, init_lifetime, usage, @c_stub)
        else
          if ((usage).equal?(GSSCredential::ACCEPT_ONLY))
            if ((nname).nil?)
              nname = GSSNameElement::DEF_ACCEPTOR
            end
            cred_element = GSSCredElement.new(nname, accept_lifetime, usage, @c_stub)
          else
            raise GSSException.new(GSSException::FAILURE, -1, "Unknown usage mode requested")
          end
        end
      end
      return cred_element
    end
    
    typesig { [GSSNameSpi, GSSCredentialSpi, ::Java::Int] }
    def get_mechanism_context(peer, my_cred, lifetime)
      if ((peer).nil?)
        raise GSSException.new(GSSException::BAD_NAME)
      else
        if (!(peer.is_a?(GSSNameElement)))
          peer = get_name_element(peer.to_s, peer.get_string_name_type)
        end
      end
      if ((my_cred).nil?)
        my_cred = get_cred_from_subject(nil, true)
      else
        if (!(my_cred.is_a?(GSSCredElement)))
          raise GSSException.new(GSSException::NO_CRED)
        end
      end
      return NativeGSSContext.new(peer, my_cred, lifetime, @c_stub)
    end
    
    typesig { [GSSCredentialSpi] }
    def get_mechanism_context(my_cred)
      if ((my_cred).nil?)
        my_cred = get_cred_from_subject(nil, false)
      else
        if (!(my_cred.is_a?(GSSCredElement)))
          raise GSSException.new(GSSException::NO_CRED)
        end
      end
      return NativeGSSContext.new(my_cred, @c_stub)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def get_mechanism_context(exported_context)
      return @c_stub.import_context(exported_context)
    end
    
    typesig { [] }
    def get_mechanism_oid
      return @c_stub.get_mech
    end
    
    typesig { [] }
    def get_provider
      return SunNativeProvider::INSTANCE
    end
    
    typesig { [] }
    def get_name_types
      return @c_stub.inquire_names_for_mech
    end
    
    private
    alias_method :initialize__native_gssfactory, :initialize
  end
  
end
