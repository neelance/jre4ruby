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
module Sun::Reflect::Generics::Tree
  module WildcardImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Tree
      include_const ::Sun::Reflect::Generics::Visitor, :TypeTreeVisitor
    }
  end
  
  class Wildcard 
    include_class_members WildcardImports
    include TypeArgument
    
    attr_accessor :upper_bounds
    alias_method :attr_upper_bounds, :upper_bounds
    undef_method :upper_bounds
    alias_method :attr_upper_bounds=, :upper_bounds=
    undef_method :upper_bounds=
    
    attr_accessor :lower_bounds
    alias_method :attr_lower_bounds, :lower_bounds
    undef_method :lower_bounds
    alias_method :attr_lower_bounds=, :lower_bounds=
    undef_method :lower_bounds=
    
    typesig { [Array.typed(FieldTypeSignature), Array.typed(FieldTypeSignature)] }
    def initialize(ubs, lbs)
      @upper_bounds = nil
      @lower_bounds = nil
      @upper_bounds = ubs
      @lower_bounds = lbs
    end
    
    class_module.module_eval {
      const_set_lazy(:EmptyBounds) { Array.typed(FieldTypeSignature).new(0) { nil } }
      const_attr_reader  :EmptyBounds
      
      typesig { [Array.typed(FieldTypeSignature), Array.typed(FieldTypeSignature)] }
      def make(ubs, lbs)
        return Wildcard.new(ubs, lbs)
      end
    }
    
    typesig { [] }
    def get_upper_bounds
      return @upper_bounds
    end
    
    typesig { [] }
    def get_lower_bounds
      if ((@lower_bounds.attr_length).equal?(1) && (@lower_bounds[0]).equal?(BottomSignature.make))
        return EmptyBounds
      else
        return @lower_bounds
      end
    end
    
    typesig { [TypeTreeVisitor] }
    def accept(v)
      v.visit_wildcard(self)
    end
    
    private
    alias_method :initialize__wildcard, :initialize
  end
  
end
