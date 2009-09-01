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
  module SunNativeProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Wrapper
      include_const ::Java::Util, :HashMap
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Org::Ietf::Jgss, :Oid
      include_const ::Sun::Security::Action, :PutAllAction
    }
  end
  
  # Defines the Sun NativeGSS provider for plugging in the
  # native GSS mechanisms to Java GSS.
  # 
  # List of supported mechanisms depends on the local
  # machine configuration.
  # 
  # @author Yu-Ching Valerie Peng
  class SunNativeProvider < SunNativeProviderImports.const_get :Provider
    include_class_members SunNativeProviderImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -238911724858694204 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:NAME) { "SunNativeGSS" }
      const_attr_reader  :NAME
      
      const_set_lazy(:INFO) { "Sun Native GSS provider" }
      const_attr_reader  :INFO
      
      const_set_lazy(:MF_CLASS) { "sun.security.jgss.wrapper.NativeGSSFactory" }
      const_attr_reader  :MF_CLASS
      
      const_set_lazy(:LIB_PROP) { "sun.security.jgss.lib" }
      const_attr_reader  :LIB_PROP
      
      const_set_lazy(:DEBUG_PROP) { "sun.security.nativegss.debug" }
      const_attr_reader  :DEBUG_PROP
      
      
      def mech_map
        defined?(@@mech_map) ? @@mech_map : @@mech_map= nil
      end
      alias_method :attr_mech_map, :mech_map
      
      def mech_map=(value)
        @@mech_map = value
      end
      alias_method :attr_mech_map=, :mech_map=
      
      const_set_lazy(:INSTANCE) { SunNativeProvider.new }
      const_attr_reader  :INSTANCE
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [String] }
      def debug(message)
        if (self.attr_debug)
          if ((message).nil?)
            raise NullPointerException.new
          end
          System.out.println(NAME + ": " + message)
        end
      end
      
      when_class_loaded do
        self.attr_mech_map = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members SunNativeProvider
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_debug = Boolean.parse_boolean(System.get_property(DEBUG_PROP))
            begin
              System.load_library("j2gss")
            rescue self.class::JavaError => err
              debug("No j2gss library found!")
              if (self.attr_debug)
                err.print_stack_trace
              end
              return nil
            end
            gss_lib = System.get_property(LIB_PROP)
            if ((gss_lib).nil? || (gss_lib.trim == ""))
              osname = System.get_property("os.name")
              if (osname.starts_with("SunOS"))
                gss_lib = "libgss.so"
              else
                if (osname.starts_with("Linux"))
                  gss_lib = "libgssapi.so"
                end
              end
            end
            if (GSSLibStub.init(gss_lib))
              debug("Loaded GSS library: " + gss_lib)
              mechs = GSSLibStub.indicate_mechs
              map = self.class::HashMap.new
              i = 0
              while i < mechs.attr_length
                debug("Native MF for " + RJava.cast_to_string(mechs[i]))
                map.put("GssApiMechanism." + RJava.cast_to_string(mechs[i]), MF_CLASS)
                i += 1
              end
              return map
            end
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
    }
    
    typesig { [] }
    def initialize
      # We are the Sun NativeGSS provider
      super(NAME, 1.0, INFO)
      if (!(self.attr_mech_map).nil?)
        AccessController.do_privileged(PutAllAction.new(self, self.attr_mech_map))
      end
    end
    
    private
    alias_method :initialize__sun_native_provider, :initialize
  end
  
end
