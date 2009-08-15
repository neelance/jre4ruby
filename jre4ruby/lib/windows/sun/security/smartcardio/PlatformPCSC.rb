require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PlatformPCSCImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Action, :LoadLibraryAction
    }
  end
  
  # Platform specific code and constants
  class PlatformPCSC 
    include_class_members PlatformPCSCImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      when_class_loaded do
        const_set :InitException, load_library
      end
      
      typesig { [] }
      def load_library
        begin
          AccessController.do_privileged(LoadLibraryAction.new("j2pcsc"))
          return nil
        rescue JavaThrowable => e
          return e
        end
      end
      
      # PCSC constants defined differently under Windows and MUSCLE
      # Windows version
      const_set_lazy(:SCARD_PROTOCOL_T0) { 0x1 }
      const_attr_reader  :SCARD_PROTOCOL_T0
      
      const_set_lazy(:SCARD_PROTOCOL_T1) { 0x2 }
      const_attr_reader  :SCARD_PROTOCOL_T1
      
      const_set_lazy(:SCARD_PROTOCOL_RAW) { 0x10000 }
      const_attr_reader  :SCARD_PROTOCOL_RAW
      
      const_set_lazy(:SCARD_UNKNOWN) { 0x0 }
      const_attr_reader  :SCARD_UNKNOWN
      
      const_set_lazy(:SCARD_ABSENT) { 0x1 }
      const_attr_reader  :SCARD_ABSENT
      
      const_set_lazy(:SCARD_PRESENT) { 0x2 }
      const_attr_reader  :SCARD_PRESENT
      
      const_set_lazy(:SCARD_SWALLOWED) { 0x3 }
      const_attr_reader  :SCARD_SWALLOWED
      
      const_set_lazy(:SCARD_POWERED) { 0x4 }
      const_attr_reader  :SCARD_POWERED
      
      const_set_lazy(:SCARD_NEGOTIABLE) { 0x5 }
      const_attr_reader  :SCARD_NEGOTIABLE
      
      const_set_lazy(:SCARD_SPECIFIC) { 0x6 }
      const_attr_reader  :SCARD_SPECIFIC
    }
    
    private
    alias_method :initialize__platform_pcsc, :initialize
  end
  
end
