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
  module SimpleClassTypeSignatureImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Tree
      include_const ::Sun::Reflect::Generics::Visitor, :TypeTreeVisitor
    }
  end
  
  class SimpleClassTypeSignature 
    include_class_members SimpleClassTypeSignatureImports
    include FieldTypeSignature
    
    attr_accessor :dollar
    alias_method :attr_dollar, :dollar
    undef_method :dollar
    alias_method :attr_dollar=, :dollar=
    undef_method :dollar=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :type_args
    alias_method :attr_type_args, :type_args
    undef_method :type_args
    alias_method :attr_type_args=, :type_args=
    undef_method :type_args=
    
    typesig { [String, ::Java::Boolean, Array.typed(TypeArgument)] }
    def initialize(n, dollar, tas)
      @dollar = false
      @name = nil
      @type_args = nil
      @name = n
      @dollar = dollar
      @type_args = tas
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Boolean, Array.typed(TypeArgument)] }
      def make(n, dollar, tas)
        return SimpleClassTypeSignature.new(n, dollar, tas)
      end
    }
    
    typesig { [] }
    # Should a '$' be used instead of '.' to separate this component
    # of the name from the previous one when composing a string to
    # pass to Class.forName; in other words, is this a transition to
    # a nested class.
    def get_dollar
      return @dollar
    end
    
    typesig { [] }
    def get_name
      return @name
    end
    
    typesig { [] }
    def get_type_arguments
      return @type_args
    end
    
    typesig { [TypeTreeVisitor] }
    def accept(v)
      v.visit_simple_class_type_signature(self)
    end
    
    private
    alias_method :initialize__simple_class_type_signature, :initialize
  end
  
end
