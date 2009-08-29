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
  module DummyScopeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Scope
      include_const ::Java::Lang::Reflect, :TypeVariable
    }
  end
  
  # This class is used to provide enclosing scopes for top level classes.
  # We cannot use <tt>null</tt> to represent such a scope, since the
  # enclosing scope is computed lazily, and so the field storing it is
  # null until it has been computed. Therefore, <tt>null</tt> is reserved
  # to represent an as-yet-uncomputed scope, and cannot be used for any
  # other kind of scope.
  class DummyScope 
    include_class_members DummyScopeImports
    include Scope
    
    class_module.module_eval {
      # Caches the unique instance of this class; instances contain no data
      # so we can use the singleton pattern
      
      def singleton
        defined?(@@singleton) ? @@singleton : @@singleton= DummyScope.new
      end
      alias_method :attr_singleton, :singleton
      
      def singleton=(value)
        @@singleton = value
      end
      alias_method :attr_singleton=, :singleton=
    }
    
    typesig { [] }
    # constructor is private to enforce use of factory method
    def initialize
    end
    
    class_module.module_eval {
      typesig { [] }
      # Factory method. Enforces the singleton pattern - only one
      # instance of this class ever exists.
      def make
        return self.attr_singleton
      end
    }
    
    typesig { [String] }
    # Lookup a type variable in the scope, using its name. Always returns
    # <tt>null</tt>.
    # @param name - the name of the type variable being looked up
    # @return  null
    def lookup(name)
      return nil
    end
    
    private
    alias_method :initialize__dummy_scope, :initialize
  end
  
end
