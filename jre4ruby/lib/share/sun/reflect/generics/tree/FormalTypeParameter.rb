require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FormalTypeParameterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Tree
      include_const ::Sun::Reflect::Generics::Visitor, :TypeTreeVisitor
    }
  end
  
  # AST that represents a formal type parameter.
  class FormalTypeParameter 
    include_class_members FormalTypeParameterImports
    include TypeTree
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :bounds
    alias_method :attr_bounds, :bounds
    undef_method :bounds
    alias_method :attr_bounds=, :bounds=
    undef_method :bounds=
    
    typesig { [String, Array.typed(FieldTypeSignature)] }
    def initialize(n, bs)
      @name = nil
      @bounds = nil
      @name = n
      @bounds = bs
    end
    
    class_module.module_eval {
      typesig { [String, Array.typed(FieldTypeSignature)] }
      # Factory method.
      # Returns a formal type parameter with the requested name and bounds.
      # @param n  the name of the type variable to be created by this method.
      # @param bs - the bounds of the type variable to be created by this method.
      # @return a formal type parameter with the requested name and bounds
      def make(n, bs)
        return FormalTypeParameter.new(n, bs)
      end
    }
    
    typesig { [] }
    def get_bounds
      return @bounds
    end
    
    typesig { [] }
    def get_name
      return @name
    end
    
    typesig { [TypeTreeVisitor] }
    def accept(v)
      v.visit_formal_type_parameter(self)
    end
    
    private
    alias_method :initialize__formal_type_parameter, :initialize
  end
  
end
