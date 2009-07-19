require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UnsafeQualifiedStaticFieldAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Base class for sun.misc.Unsafe-based FieldAccessors for final or
  # volatile static fields.
  class UnsafeQualifiedStaticFieldAccessorImpl < UnsafeQualifiedStaticFieldAccessorImplImports.const_get :UnsafeStaticFieldAccessorImpl
    include_class_members UnsafeQualifiedStaticFieldAccessorImplImports
    
    attr_accessor :is_read_only
    alias_method :attr_is_read_only, :is_read_only
    undef_method :is_read_only
    alias_method :attr_is_read_only=, :is_read_only=
    undef_method :is_read_only=
    
    typesig { [Field, ::Java::Boolean] }
    def initialize(field, is_read_only)
      @is_read_only = false
      super(field)
      @is_read_only = is_read_only
    end
    
    private
    alias_method :initialize__unsafe_qualified_static_field_accessor_impl, :initialize
  end
  
end
