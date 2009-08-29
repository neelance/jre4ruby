require "rjava"

# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UnsafeStaticFieldAccessorImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Base class for sun.misc.Unsafe-based FieldAccessors for static
  # fields. The observation is that there are only nine types of
  # fields from the standpoint of reflection code: the eight primitive
  # types and Object. Using class Unsafe instead of generated
  # bytecodes saves memory and loading time for the
  # dynamically-generated FieldAccessors.
  class UnsafeStaticFieldAccessorImpl < UnsafeStaticFieldAccessorImplImports.const_get :UnsafeFieldAccessorImpl
    include_class_members UnsafeStaticFieldAccessorImplImports
    
    class_module.module_eval {
      when_class_loaded do
        Reflection.register_fields_to_filter(UnsafeStaticFieldAccessorImpl, Array.typed(String).new(["base"]))
      end
    }
    
    attr_accessor :base
    alias_method :attr_base, :base
    undef_method :base
    alias_method :attr_base=, :base=
    undef_method :base=
    
    typesig { [Field] }
    # base
    def initialize(field)
      @base = nil
      super(field)
      @base = self.attr_unsafe.static_field_base(field)
    end
    
    private
    alias_method :initialize__unsafe_static_field_accessor_impl, :initialize
  end
  
end
