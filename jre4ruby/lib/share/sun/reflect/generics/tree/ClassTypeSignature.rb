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
  module ClassTypeSignatureImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Tree
      include_const ::Java::Util, :JavaList
      include_const ::Sun::Reflect::Generics::Visitor, :TypeTreeVisitor
    }
  end
  
  # AST representing class types.
  class ClassTypeSignature 
    include_class_members ClassTypeSignatureImports
    include FieldTypeSignature
    
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    typesig { [JavaList] }
    def initialize(p)
      @path = nil
      @path = p
    end
    
    class_module.module_eval {
      typesig { [JavaList] }
      def make(p)
        return ClassTypeSignature.new(p)
      end
    }
    
    typesig { [] }
    def get_path
      return @path
    end
    
    typesig { [TypeTreeVisitor] }
    def accept(v)
      v.visit_class_type_signature(self)
    end
    
    private
    alias_method :initialize__class_type_signature, :initialize
  end
  
end
