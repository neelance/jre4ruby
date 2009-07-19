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
  module MethodTypeSignatureImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Tree
      include_const ::Sun::Reflect::Generics::Visitor, :Visitor
    }
  end
  
  class MethodTypeSignature 
    include_class_members MethodTypeSignatureImports
    include Signature
    
    attr_accessor :formal_type_params
    alias_method :attr_formal_type_params, :formal_type_params
    undef_method :formal_type_params
    alias_method :attr_formal_type_params=, :formal_type_params=
    undef_method :formal_type_params=
    
    attr_accessor :parameter_types
    alias_method :attr_parameter_types, :parameter_types
    undef_method :parameter_types
    alias_method :attr_parameter_types=, :parameter_types=
    undef_method :parameter_types=
    
    attr_accessor :return_type
    alias_method :attr_return_type, :return_type
    undef_method :return_type
    alias_method :attr_return_type=, :return_type=
    undef_method :return_type=
    
    attr_accessor :exception_types
    alias_method :attr_exception_types, :exception_types
    undef_method :exception_types
    alias_method :attr_exception_types=, :exception_types=
    undef_method :exception_types=
    
    typesig { [Array.typed(FormalTypeParameter), Array.typed(TypeSignature), ReturnType, Array.typed(FieldTypeSignature)] }
    def initialize(ftps, pts, rt, ets)
      @formal_type_params = nil
      @parameter_types = nil
      @return_type = nil
      @exception_types = nil
      @formal_type_params = ftps
      @parameter_types = pts
      @return_type = rt
      @exception_types = ets
    end
    
    class_module.module_eval {
      typesig { [Array.typed(FormalTypeParameter), Array.typed(TypeSignature), ReturnType, Array.typed(FieldTypeSignature)] }
      def make(ftps, pts, rt, ets)
        return MethodTypeSignature.new(ftps, pts, rt, ets)
      end
    }
    
    typesig { [] }
    def get_formal_type_parameters
      return @formal_type_params
    end
    
    typesig { [] }
    def get_parameter_types
      return @parameter_types
    end
    
    typesig { [] }
    def get_return_type
      return @return_type
    end
    
    typesig { [] }
    def get_exception_types
      return @exception_types
    end
    
    typesig { [Visitor] }
    def accept(v)
      v.visit_method_type_signature(self)
    end
    
    private
    alias_method :initialize__method_type_signature, :initialize
  end
  
end
