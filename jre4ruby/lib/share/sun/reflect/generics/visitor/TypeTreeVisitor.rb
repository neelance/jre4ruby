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
module Sun::Reflect::Generics::Visitor
  module TypeTreeVisitorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Visitor
      include ::Sun::Reflect::Generics::Tree
    }
  end
  
  # Visit a TypeTree and produce a result of type T.
  module TypeTreeVisitor
    include_class_members TypeTreeVisitorImports
    
    typesig { [] }
    # Returns the result of the visit.
    # @return the result of the visit
    def get_result
      raise NotImplementedError
    end
    
    typesig { [FormalTypeParameter] }
    # Visitor methods, per node type
    def visit_formal_type_parameter(ftp)
      raise NotImplementedError
    end
    
    typesig { [ClassTypeSignature] }
    def visit_class_type_signature(ct)
      raise NotImplementedError
    end
    
    typesig { [ArrayTypeSignature] }
    def visit_array_type_signature(a)
      raise NotImplementedError
    end
    
    typesig { [TypeVariableSignature] }
    def visit_type_variable_signature(tv)
      raise NotImplementedError
    end
    
    typesig { [Wildcard] }
    def visit_wildcard(w)
      raise NotImplementedError
    end
    
    typesig { [SimpleClassTypeSignature] }
    def visit_simple_class_type_signature(sct)
      raise NotImplementedError
    end
    
    typesig { [BottomSignature] }
    def visit_bottom_signature(b)
      raise NotImplementedError
    end
    
    typesig { [ByteSignature] }
    # Primitives and Void
    def visit_byte_signature(b)
      raise NotImplementedError
    end
    
    typesig { [BooleanSignature] }
    def visit_boolean_signature(b)
      raise NotImplementedError
    end
    
    typesig { [ShortSignature] }
    def visit_short_signature(s)
      raise NotImplementedError
    end
    
    typesig { [CharSignature] }
    def visit_char_signature(c)
      raise NotImplementedError
    end
    
    typesig { [IntSignature] }
    def visit_int_signature(i)
      raise NotImplementedError
    end
    
    typesig { [LongSignature] }
    def visit_long_signature(l)
      raise NotImplementedError
    end
    
    typesig { [FloatSignature] }
    def visit_float_signature(f)
      raise NotImplementedError
    end
    
    typesig { [DoubleSignature] }
    def visit_double_signature(d)
      raise NotImplementedError
    end
    
    typesig { [VoidDescriptor] }
    def visit_void_descriptor(v)
      raise NotImplementedError
    end
  end
  
end
