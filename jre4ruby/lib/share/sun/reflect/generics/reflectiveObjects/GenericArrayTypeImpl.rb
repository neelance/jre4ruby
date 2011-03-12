require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Generics::ReflectiveObjects
  module GenericArrayTypeImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::ReflectiveObjects
      include_const ::Java::Lang::Reflect, :GenericArrayType
      include_const ::Java::Lang::Reflect, :Type
    }
  end
  
  # Implementation of GenericArrayType interface for core reflection.
  class GenericArrayTypeImpl 
    include_class_members GenericArrayTypeImplImports
    include GenericArrayType
    
    attr_accessor :generic_component_type
    alias_method :attr_generic_component_type, :generic_component_type
    undef_method :generic_component_type
    alias_method :attr_generic_component_type=, :generic_component_type=
    undef_method :generic_component_type=
    
    typesig { [Type] }
    # private constructor enforces use of static factory
    def initialize(ct)
      @generic_component_type = nil
      @generic_component_type = ct
    end
    
    class_module.module_eval {
      typesig { [Type] }
      # Factory method.
      # @param ct - the desired component type of the generic array type
      # being created
      # @return a generic array type with the desired component type
      def make(ct)
        return GenericArrayTypeImpl.new(ct)
      end
    }
    
    typesig { [] }
    # Returns  a <tt>Type</tt> object representing the component type
    # of this array.
    # 
    # @return  a <tt>Type</tt> object representing the component type
    #     of this array
    # @since 1.5
    def get_generic_component_type
      return @generic_component_type # return cached component type
    end
    
    typesig { [] }
    def to_s
      component_type = get_generic_component_type
      sb = StringBuilder.new
      if (component_type.is_a?(Class))
        sb.append((component_type).get_name)
      else
        sb.append(component_type.to_s)
      end
      sb.append("[]")
      return sb.to_s
    end
    
    typesig { [Object] }
    def ==(o)
      if (o.is_a?(GenericArrayType))
        that = o
        that_component_type = that.get_generic_component_type
        return (@generic_component_type).nil? ? (that_component_type).nil? : (@generic_component_type == that_component_type)
      else
        return false
      end
    end
    
    typesig { [] }
    def hash_code
      return ((@generic_component_type).nil?) ? 0 : @generic_component_type.hash_code
    end
    
    private
    alias_method :initialize__generic_array_type_impl, :initialize
  end
  
end
