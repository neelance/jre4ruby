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
  module Krb5AcceptCredentialImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Sun::Security::Jgss, :GSSUtil
      include ::Sun::Security::Jgss::Spi
      include ::Sun::Security::Krb5
      include ::Javax::Security::Auth::Kerberos
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Javax::Security::Auth, :DestroyFailedException
    }
  end
  
  # 
  # Implements the krb5 acceptor credential element.
  # 
  # @author Mayank Upadhyay
  # @since 1.4
  class Krb5AcceptCredential < Krb5AcceptCredentialImports.const_get :KerberosKey
    include_class_members Krb5AcceptCredentialImports
    include Krb5CredElement
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7714332137352567952 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # 
    # We cache an EncryptionKey representation of this key because many
    # Krb5 operation require a key in that form. At some point we might do
    # away with EncryptionKey altogether and use the base class
    # KerberosKey everywhere.
    attr_accessor :krb5encryption_keys
    alias_method :attr_krb5encryption_keys, :krb5encryption_keys
    undef_method :krb5encryption_keys
    alias_method :attr_krb5encryption_keys=, :krb5encryption_keys=
    undef_method :krb5encryption_keys=
    
    typesig { [Krb5NameElement, Array.typed(KerberosKey)] }
    def initialize(name, keys)
      # 
      # Initialize this instance with the data from the acquired
      # KerberosKey. This class needs to be a KerberosKey too
      # hence we can't just store a reference.
      @name = nil
      @krb5encryption_keys = nil
      super(keys[0].get_principal, keys[0].get_encoded, keys[0].get_key_type, keys[0].get_version_number)
      @name = name
      # Cache this for later use by the sun.security.krb5 package.
      @krb5encryption_keys = Array.typed(EncryptionKey).new(keys.attr_length) { nil }
      i = 0
      while i < keys.attr_length
        @krb5encryption_keys[i] = EncryptionKey.new(keys[i].get_encoded, keys[i].get_key_type, keys[i].get_version_number)
        ((i += 1) - 1)
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Krb5NameElement] }
      def get_instance(caller, name)
        server_princ = ((name).nil? ? nil : name.get_krb5principal_name.get_name)
        acc = AccessController.get_context
        keys = nil
        begin
          keys = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members Krb5AcceptCredential
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Krb5Util.get_keys((caller).equal?(GSSUtil::CALLER_UNKNOWN) ? GSSUtil::CALLER_ACCEPT : caller, server_princ, acc)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue PrivilegedActionException => e
          ge = GSSException.new(GSSException::NO_CRED, -1, "Attempt to obtain new ACCEPT credentials failed!")
          ge.init_cause(e.get_exception)
          raise ge
        end
        if ((keys).nil? || (keys.attr_length).equal?(0))
          raise GSSException.new(GSSException::NO_CRED, -1, "Failed to find any Kerberos Key")
        end
        if ((name).nil?)
          full_name = keys[0].get_principal.get_name
          name = Krb5NameElement.get_instance(full_name, Krb5MechFactory::NT_GSS_KRB5_PRINCIPAL)
        end
        return Krb5AcceptCredential.new(name, keys)
      end
    }
    
    typesig { [] }
    # 
    # Returns the principal name for this credential. The name
    # is in mechanism specific format.
    # 
    # @return GSSNameSpi representing principal name of this credential
    # @exception GSSException may be thrown
    def get_name
      return @name
    end
    
    typesig { [] }
    # 
    # Returns the init lifetime remaining.
    # 
    # @return the init lifetime remaining in seconds
    # @exception GSSException may be thrown
    def get_init_lifetime
      return 0
    end
    
    typesig { [] }
    # 
    # Returns the accept lifetime remaining.
    # 
    # @return the accept lifetime remaining in seconds
    # @exception GSSException may be thrown
    def get_accept_lifetime
      return GSSCredential::INDEFINITE_LIFETIME
    end
    
    typesig { [] }
    def is_initiator_credential
      return false
    end
    
    typesig { [] }
    def is_acceptor_credential
      return true
    end
    
    typesig { [] }
    # 
    # Returns the oid representing the underlying credential
    # mechanism oid.
    # 
    # @return the Oid for this credential mechanism
    # @exception GSSException may be thrown
    def get_mechanism
      return Krb5MechFactory::GSS_KRB5_MECH_OID
    end
    
    typesig { [] }
    def get_provider
      return Krb5MechFactory::PROVIDER
    end
    
    typesig { [] }
    def get_krb5encryption_keys
      return @krb5encryption_keys
    end
    
    typesig { [] }
    # 
    # Called to invalidate this credential element.
    def dispose
      begin
        destroy
      rescue DestroyFailedException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, "Could not destroy credentials - " + (e.get_message).to_s)
        gss_exception.init_cause(e)
      end
    end
    
    typesig { [] }
    # 
    # Destroys the locally cached EncryptionKey value and then calls
    # destroy in the base class.
    def destroy
      if (!(@krb5encryption_keys).nil?)
        i = 0
        while i < @krb5encryption_keys.attr_length
          @krb5encryption_keys[i].destroy
          ((i += 1) - 1)
        end
        @krb5encryption_keys = nil
      end
      super
    end
    
    private
    alias_method :initialize__krb5accept_credential, :initialize
  end
  
end
