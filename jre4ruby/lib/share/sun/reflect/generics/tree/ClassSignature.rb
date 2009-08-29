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
  module ClassSignatureImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Tree
      include_const ::Sun::Reflect::Generics::Visitor, :Visitor
    }
  end
  
  class ClassSignature 
    include_class_members ClassSignatureImports
    include Signature
    
    attr_accessor :formal_type_params
    alias_method :attr_formal_type_params, :formal_type_params
    undef_method :formal_type_params
    alias_method :attr_formal_type_params=, :formal_type_params=
    undef_method :formal_type_params=
    
    attr_accessor :superclass
    alias_method :attr_superclass, :superclass
    undef_method :superclass
    alias_method :attr_superclass=, :superclass=
    undef_method :superclass=
    
    attr_accessor :super_interfaces
    alias_method :attr_super_interfaces, :super_interfaces
    undef_method :super_interfaces
    alias_method :attr_super_interfaces=, :super_interfaces=
    undef_method :super_interfaces=
    
    typesig { [Array.typed(FormalTypeParameter), ClassTypeSignature, Array.typed(ClassTypeSignature)] }
    def initialize(ftps, sc, sis)
      @formal_type_params = nil
      @superclass = nil
      @super_interfaces = nil
      @formal_type_params = ftps
      @superclass = sc
      @super_interfaces = sis
    end
    
    class_module.module_eval {
      typesig { [Array.typed(FormalTypeParameter), ClassTypeSignature, Array.typed(ClassTypeSignature)] }
      def make(ftps, sc, sis)
        return ClassSignature.new(ftps, sc, sis)
      end
    }
    
    typesig { [] }
    def get_formal_type_parameters
      return @formal_type_params
    end
    
    typesig { [] }
    def get_superclass
      return @superclass
    end
    
    typesig { [] }
    def get_super_interfaces
      return @super_interfaces
    end
    
    typesig { [Visitor] }
    def accept(v)
      v.visit_class_signature(self)
    end
    
    private
    alias_method :initialize__class_signature, :initialize
  end
  
end
