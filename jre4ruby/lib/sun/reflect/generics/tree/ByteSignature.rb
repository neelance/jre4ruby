require "rjava"

# 
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
  module ByteSignatureImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Tree
      include_const ::Sun::Reflect::Generics::Visitor, :TypeTreeVisitor
    }
  end
  
  # AST that represents the type byte.
  class ByteSignature 
    include_class_members ByteSignatureImports
    include BaseType
    
    class_module.module_eval {
      
      def singleton
        defined?(@@singleton) ? @@singleton : @@singleton= ByteSignature.new
      end
      alias_method :attr_singleton, :singleton
      
      def singleton=(value)
        @@singleton = value
      end
      alias_method :attr_singleton=, :singleton=
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [] }
      def make
        return self.attr_singleton
      end
    }
    
    typesig { [TypeTreeVisitor] }
    def accept(v)
      v.visit_byte_signature(self)
    end
    
    private
    alias_method :initialize__byte_signature, :initialize
  end
  
end
