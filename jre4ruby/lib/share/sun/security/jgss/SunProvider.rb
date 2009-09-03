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
  module SunProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :AccessController
    }
  end
  
  # Defines the Sun JGSS provider.
  # Will merger this with the Sun security provider
  # sun.security.provider.Sun when the JGSS src is merged with the JDK
  # src.
  # 
  # Mechanisms supported are:
  # 
  # - Kerberos v5 as defined in RFC 1964.
  # Oid is 1.2.840.113554.1.2.2
  # 
  # - SPNEGO as defined in RFC 2478
  # Oid is 1.3.6.1.5.5.2
  # 
  # [Dummy mechanism is no longer compiled:
  # - Dummy mechanism. This is primarily useful to test a multi-mech
  # environment.
  # Oid is 1.3.6.1.4.1.42.2.26.1.2]
  # 
  # @author Mayank Upadhyay
  class SunProvider < SunProviderImports.const_get :Provider
    include_class_members SunProviderImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -238911724858694198 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:INFO) { "Sun " + "(Kerberos v5, SPNEGO)" }
      const_attr_reader  :INFO
      
      # "(Kerberos v5, Dummy GSS-API Mechanism)";
      const_set_lazy(:INSTANCE) { SunProvider.new }
      const_attr_reader  :INSTANCE
    }
    
    typesig { [] }
    def initialize
      # We are the Sun JGSS provider
      super("SunJGSS", 1.0, INFO)
      AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members SunProvider
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          put("GssApiMechanism.1.2.840.113554.1.2.2", "sun.security.jgss.krb5.Krb5MechFactory")
          put("GssApiMechanism.1.3.6.1.5.5.2", "sun.security.jgss.spnego.SpNegoMechFactory")
          # put("GssApiMechanism.1.3.6.1.4.1.42.2.26.1.2",
          # "sun.security.jgss.dummy.DummyMechFactory");
          return nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    private
    alias_method :initialize__sun_provider, :initialize
  end
  
end
