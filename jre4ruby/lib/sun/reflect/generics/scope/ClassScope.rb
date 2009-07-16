require "rjava"

# 
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
module Sun::Reflect::Generics::Scope
  module ClassScopeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Scope
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :Method
    }
  end
  
  # 
  # This class represents the scope containing the type variables of
  # a class.
  class ClassScope < ClassScopeImports.const_get :AbstractScope
    include_class_members ClassScopeImports
    include Scope
    
    typesig { [Class] }
    # constructor is private to enforce use of factory method
    def initialize(c)
      super(c)
    end
    
    typesig { [] }
    # 
    # Overrides the abstract method in the superclass.
    # @return the enclosing scope
    def compute_enclosing_scope
      receiver = get_recvr
      m = receiver.get_enclosing_method
      if (!(m).nil?)
        # Receiver is a local or anonymous class enclosed in a
        # method.
        return MethodScope.make(m)
      end
      cnstr = receiver.get_enclosing_constructor
      if (!(cnstr).nil?)
        # Receiver is a local or anonymous class enclosed in a
        # constructor.
        return ConstructorScope.make(cnstr)
      end
      c = receiver.get_enclosing_class
      # if there is a declaring class, recvr is a member class
      # and its enclosing scope is that of the declaring class
      if (!(c).nil?)
        # Receiver is a local class, an anonymous class, or a
        # member class (static or not).
        return ClassScope.make(c)
      end
      # otherwise, recvr is a top level class, and it has no real
      # enclosing scope.
      return DummyScope.make
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # 
      # Factory method. Takes a <tt>Class</tt> object and creates a
      # scope for it.
      # @param c - a Class whose scope we want to obtain
      # @return The type-variable scope for the class c
      def make(c)
        return ClassScope.new(c)
      end
    }
    
    private
    alias_method :initialize__class_scope, :initialize
  end
  
end
