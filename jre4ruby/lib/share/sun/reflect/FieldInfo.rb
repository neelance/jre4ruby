require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module FieldInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :Modifier
    }
  end
  
  # NOTE: obsolete as of JDK 1.4 B75 and should be removed from the
  # workspace (FIXME)
  class FieldInfo 
    include_class_members FieldInfoImports
    
    # Set by the VM directly. Do not move these fields around or add
    # others before (or after) them without also modifying the VM's code.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    attr_accessor :modifiers
    alias_method :attr_modifiers, :modifiers
    undef_method :modifiers
    alias_method :attr_modifiers=, :modifiers=
    undef_method :modifiers=
    
    # This is compatible with the old reflection implementation's
    # "slot" value to allow sun.misc.Unsafe to work
    attr_accessor :slot
    alias_method :attr_slot, :slot
    undef_method :slot
    alias_method :attr_slot=, :slot=
    undef_method :slot=
    
    typesig { [] }
    # Not really necessary to provide a constructor since the VM
    # creates these directly
    def initialize
      @name = nil
      @signature = nil
      @modifiers = 0
      @slot = 0
    end
    
    typesig { [] }
    def name
      return @name
    end
    
    typesig { [] }
    # This is in "external" format, i.e. having '.' as separator
    # rather than '/'
    def signature
      return @signature
    end
    
    typesig { [] }
    def modifiers
      return @modifiers
    end
    
    typesig { [] }
    def slot
      return @slot
    end
    
    typesig { [] }
    # Convenience routine
    def is_public
      return (Modifier.is_public(modifiers))
    end
    
    private
    alias_method :initialize__field_info, :initialize
  end
  
end
