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
module Sun::Security::Smartcardio
  module SunPCSCImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include ::Java::Security
      include ::Javax::Smartcardio
    }
  end
  
  # Provider object for PC/SC.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class SunPCSC < SunPCSCImports.const_get :Provider
    include_class_members SunPCSCImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6168388284028876579 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    def initialize
      super("SunPCSC", 1.6, "Sun PC/SC provider")
      AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members SunPCSC
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          put("TerminalFactory.PC/SC", "sun.security.smartcardio.SunPCSC$Factory")
          return nil
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    class_module.module_eval {
      const_set_lazy(:Factory) { Class.new(TerminalFactorySpi) do
        include_class_members SunPCSC
        
        typesig { [Object] }
        def initialize(obj)
          super()
          if (!(obj).nil?)
            raise self.class::IllegalArgumentException.new("SunPCSC factory does not use parameters")
          end
          # make sure PCSC is available and that we can obtain a context
          PCSC.check_available
          PCSCTerminals.init_context
        end
        
        typesig { [] }
        # Returns the available readers.
        # This must be a new object for each call.
        def engine_terminals
          return self.class::PCSCTerminals.new
        end
        
        private
        alias_method :initialize__factory, :initialize
      end }
    }
    
    private
    alias_method :initialize__sun_pcsc, :initialize
  end
  
end
