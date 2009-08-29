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
module Sun::Reflect::Generics::Scope
  module ConstructorScopeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Scope
      include_const ::Java::Lang::Reflect, :Constructor
    }
  end
  
  # This class represents the scope containing the type variables of
  # a constructor.
  class ConstructorScope < ConstructorScopeImports.const_get :AbstractScope
    include_class_members ConstructorScopeImports
    
    typesig { [Constructor] }
    # constructor is private to enforce use of factory method
    def initialize(c)
      super(c)
    end
    
    typesig { [] }
    # utility method; computes enclosing class, from which we can
    # derive enclosing scope.
    def get_enclosing_class
      return get_recvr.get_declaring_class
    end
    
    typesig { [] }
    # Overrides the abstract method in the superclass.
    # @return the enclosing scope
    def compute_enclosing_scope
      # the enclosing scope of a (generic) constructor is the scope of the
      # class in which it was declared.
      return ClassScope.make(get_enclosing_class)
    end
    
    class_module.module_eval {
      typesig { [Constructor] }
      # Factory method. Takes a <tt>Constructor</tt> object and creates a
      # scope for it.
      # @param m - A Constructor whose scope we want to obtain
      # @return The type-variable scope for the constructor m
      def make(c)
        return ConstructorScope.new(c)
      end
    }
    
    private
    alias_method :initialize__constructor_scope, :initialize
  end
  
end
